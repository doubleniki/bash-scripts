#!/bin/bash
# Author: Nikita Saltykov

# enable the "errexit" option
set -e

# Make sure important variables exist if not already defined
#
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"

# Default settings
REPO=${REPO:-doubleniki/bash-scripts}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-master}

# find a bash config file
BASH_CFG=$(find $HOME -maxdepth 1 -name ".*shrc" -o -name ".*bash_profile" -o -name ".*bashrc" -o -name ".*zshrc" -o -name ".*zprofile" -o -name ".*zshenv" -o -name ".*zlogin" -o -name ".*zlogout" -o -name ".*profile" -o -name ".*login" -o -name ".*logout" | head -n 1)

echo "Please provide a dir for scripts or press enter to use default ($HOME/.bash-scripts):"
read INSTALL_DIR

INSTALL_DIR=${INSTALL_DIR:-$HOME/.bash-scripts}

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

folder_exists() {
  [ -d "$1" ]
}

set_folders() {
  # create folders for personal and work projects
  folder_exists $HOME/Repo || mkdir -p $HOME/Repo
  folder_exists $HOME/Repo/Personal || mkdir -p $HOME/Repo/Personal
  folder_exists $HOME/Repo/Work || mkdir -p $HOME/Repo/Work

  personal_projects_repo=$HOME/Repo/Personal
  work_project_repo=$HOME/Repo/Work

  echo "Please enter the link of the remote repository with your bash scripts:"
  read remote_link

  # write new variables to the config file
  echo "export PERSONAL_REPO=$personal_projects_repo" >> $BASH_CFG
  echo "export WORK_REPO=$work_project_repo" >> $BASH_CFG
}

clone_repo() {
  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  echo "Cloning bash functions & scripts..."

  command_exists git || {
    fmt_error "git is not installed"
    exit 1
  }

  # clone the repo with bash scripts
  mkdir -p $INSTALL_DIR
  git clone $REMOTE $INSTALL_DIR
}

insert_functions_to_config() {
  # find all functions
  functions=$(find $INSTALL_DIR/functions -type f -name "*.sh" -exec basename {} \; | sed 's/\.sh//g')

  # import functions to the config file
  for function in $functions
  do
    echo "source $INSTALL_DIR/functions/$function.sh" >> $BASH_CFG
  done
}

main() {
  set_folders
  clone_repo
  insert_functions_to_config

  # restart the shell
  exec -l $SHELL
}

main "$@"