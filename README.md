This is my take on dotfiles and how to manage them. Very simple, bash + homebrew.

# Getting Started
Running the `bootstrap.sh` will install a bunch of homebrew libraries and symlink files to the users home directory.

```
git clone https://github.com/brianhartsock/dotfiles .dotfiles
cd .dotfiles
./bootstrap.sh
```
Done!

# How it works
Every file in the directory will be symlinked to ~ and prefixed with a . to make the file hidden, with the exception of *Exclusions* and *Templates*.  Easy peasy.

## Templates
Template files are defined with a .template extension. Each template file contains template variables. Template variables have the form "${variable_name}" without the quotes. These variables are replaced by user input, or by bash variables that share the variable name. Take the example config file:

```
gitconfig:
[user]
 name = ${GIT_NAME}
```

There are two ways this template variable can be used. 

1. Do nothing. The script will prompt the user for the value
2. Run bootstrap.sh with a variable defined in the bash environment
   i.e. GIT_NAME="Brian Hartsock" ./bootstrap.sh

Template files are copied to hidden temp files, .tmp extension, where the template values are replaced and those tmp files are symlinked to the users home directory.

## Exclusions
To exclude a file from being symlinked, just place the name or a pattern in `.exlusions`. This is like a .gitignore file, but not as powerful. Please include one exclusion per link. Bash globbing is supported but comments are not.

For example, the following is valid:
```
README.md
LICENSE
*.swp
```
## extra
The extra file is a special file that will not be committed to git, but will by symlinked. It is bash file meant for bash environment variables. It is much like a template file, but a bit easier to use.

# Bugs
If you use this and find issues, just submit and issue or create a PR. I created this mainly for myself and am sure there are tons of scenarios that haven't been accounted for in the code.

# Inspiration
Dotfiles are something very custom to the user and I didn't really want to use a community repository. With that said, there are some great repos that my dotfiles are based on:

* https://github.com/holman/dotfiles
* https://github.com/mathiasbynens
