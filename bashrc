
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Environment definition.
# Variables and other information that sets the stage for the environment
# are set here.
if [ -f ~/.environment ]; then
  source ~/.environment
fi

# Extra Environment Definitions
# Where other, more sensitive, environment variables are set.
if [ -f ~/.extra ]; then
  source ~/.extra
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.aliases, instead of adding them here directly.
if [ -f ~/.aliases ]; then
  source ~/.aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  source /etc/bash_completion
fi

# homebrew bash completion
PLATFORM=$(uname)
if [ $PLATFORM == 'Darwin' ]; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    source $(brew --prefix)/etc/bash_completion
  fi
fi

# NVM Setup
export NVM_DIR="/Users/brianhartsock/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# AWS Autocomplete
complete -C aws_completer aws

# Perl Brew
if [ -f ~/perl5/perlbrew/etc/bashrc ]; then
  source ~/perl5/perlbrew/etc/bashrc
fi

# RVM Setup
# RVM checks these lines in .bashrc so it must be in this file.
# RVM likes to be first...
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
