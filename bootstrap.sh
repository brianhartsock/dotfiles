#!/usr/bin/env bash

BREW_PACKAGES=(bash-completion coreutils findutils vim git git-extras curl wget watch node go python ssh-copy-id "homebrew/dupes/grep")
APT_PACKAGES=(realpath git vim)

DOTFILES_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PLATFORM=$(uname)

# Global state variables
overwrite_all=false backup_all=false skip_all=false

ubuntu () {
  sudo apt-get install -y $APT_PACKAGES
}

homebrew () {
  # Update homebrew
  info "updating homebrew"
  brew update > /dev/null

  # Install all the necassary homebrew packages
  info "installing requested homebrew packages"
  for pkg in ${BREW_PACKAGES[@]}; do
    installed_pkg_name=$(basename $pkg)
    if [ ! -n "$(brew ls --versions $installed_pkg_name)" ]; then
      info "installing $pkg"
      if [ $pkg == "vim" ]; then
        brew install vim --override-system-vi
      else
        brew install $pkg > /dev/null
      fi
      success "$pkg installed!"
    fi
  done

  info "upgrading all outdated homebrew packages"
  for pkg in $(brew outdated); do
    info "upgrading $pkg..."
    brew upgrade $pkg > /dev/null
    success "$pkg upgraded"
  done

  info "cleaning up homebrew"
  brew cleanup > /dev/null
}

info () {
  printf "  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

# template_files
#
# Function to return all files with a template extension. Template files 
# contain special template variables that are replaced with actual values.
template_files () {
  echo $(find . -name *.template | xargs basename)
}

# template_variables
#
# Search all template files for a list of template variables. Template
# variables have the form "${variable_name}" without the quotes. These
# variables are replaced by user input, or by bash variables that share
# the variable name. Take the example config file:
#
# gitconfig:
# [user]
#  name = ${GIT_NAME}
#
# There are two ways this template variable can be used. 
# 1. Do nothing. The script will prompt the user for the value
# 2. Run bootstrap.sh with a variable defined in the bash environment
#    i.e. GIT_NAME="Brian Hartsock" ./bootstrap.sh
template_variables () {
  echo $(find . -name *.template -exec grep -oE '\$\{([^}]+)\}' {} \; | sed 's/\${\(.*\)}/\1/')
}

# link_template_files
#
# This function does the heavy lifting of creating temporary template files,
# discovering the template values, and replacing them in the files. Finally
# those files are symlinked to the users home directory.
link_template_files () {
  local template_file= variable_name= variable_value=

  # Remove old hidden temp files
  rm .*.tmp 2> /dev/null && success "Removing all *.tmp files"

  # Copy all template files to a staging area
  for template_file in $(template_files); do
    cp $template_file .${template_file}.tmp && success "Created .${template_file}.tmp"
  done

  # Discover variable names
  for variable_name in $(template_variables); do
    variable_value=$(eval echo \$${variable_name})
    if [[ -n $variable_value ]]; then
      success "Found variable \$$variable_name."
    else
      user "$variable_name:"
      read -e variable_value
    fi
    sed -i "s/\\\${$variable_name}/$variable_value/" .*.tmp
  done

  # Link template files to users home directory
  for template_file in $(template_files); do
    link_file "$(realpath .${template_file}.tmp)" "${HOME}/.$(basename ${template_file%.template})"
  done
}


link_file () {
  local src=$1 dst=$2
  local overwrite= backup= skip= action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]; then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]; then
      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]; then
        skip=true;
      else
        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac
      fi
    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]; then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]; then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]; then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]; then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

files_to_link () {
  local link_file= exclusion_file=  files=()
  local exclusions=($(cat .exclusions))
  
  for link_file in $(find "$DOTFILES_ROOT" -maxdepth 1 -mindepth 1 | xargs -L 1 basename); do
    local skip=false
    for exclusion_file in ${exclusions[@]}; do
      if [[ "$link_file" =~ "$exclusion_file" ]]; then
        skip=true
      fi
      if [[ "$link_file" = *.template ]]; then
        skip=true
      fi
    done
    if [[ "$skip" == "false" ]]; then
      files+=( $link_file )
    fi
  done
  echo "${files[@]}"
}

if [ $PLATFORM == 'Darwin' ]
then
  info 'installing homebrew'
  homebrew
elif [ $PLATFORM == 'Linux' ]
then
  info 'installing ubuntu packages'
  ubuntu
fi

# Update any sub-modules (done after homebrew so we know e have git)
git submodule init > /dev/null
git submodule update > /dev/null

info 'installing dotfiles'

# Link all normal files
for src in $(files_to_link)
do
  dst=$HOME/.$src
  link_file $(realpath $src) $dst
done

# Link all template files
link_template_files
