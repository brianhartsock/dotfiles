This is my take on dotfiles and how to manage them. Very simple.

# Getting Started

Installing the dotfiles can be done in many different ways but the easiest is to use ansible and [ansible-role-dotfiles](https://github.com/geerlingguy/ansible-role-dotfiles).

Install ansible `brew install ansible`.

Create a `requirements.yml` file with the following information, and run `ansible-galaxy install -r requirements.yml`.

```yml
- name: geerlingguy.mas
- name: geerlingguy.dotfiles
```

Next create the variables file `vars.yml` with the appropriate variables set:

```yaml
dotfiles_repo: https://github.com/brianhartsock/dotfiles.git
dotfiles_repo_local_destination: ~/Code/dotfiles
dotfiles_files:
  - .bash_profile
  - .bashrc
  - .environment
  - .gemrc
  - .gitconfig
  - .vim
  - .vimrc
```

Then create your ansible playbook.

```yaml
- hosts: localhost
  vars_files:
    - vars.yml
  roles:
    - geerlingguy.dotfiles
```

Finally, run ansible with `ansible-playbook playbook.yml` and your dotfiles will be installed.

# How it works
Every file specified by `dotfiles_files` will be symlinked to ~. Easy peasy.

# Inspiration
Dotfiles are something very custom to the user and I didn't really want to use a community repository. With that said, there are some great repos that my dotfiles are based on:

* https://github.com/geerlingguy/dotfiles
* https://github.com/holman/dotfiles
* https://github.com/mathiasbynens
