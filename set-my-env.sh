#!/bin/bash
# Author: Nikita Saltykov

set_folders() {
  # mkdir -p $HOME/Repo
  # mkdir -p $HOME/Repo/Personal
  # mkdir -p $HOME/Repo/Work

  personal=$HOME/Repo/Personal
  work=$HOME/Repo/Work

  echo "Please enter the link of the remote repository with your bash scripts:"
  read remote_link

  # find a bash config file
  bash_config_file=$(find $HOME -maxdepth 1 -name ".*shrc" -o -name ".*bash_profile" -o -name ".*bashrc" -o -name ".*zshrc" -o -name ".*zprofile" -o -name ".*zshenv" -o -name ".*zlogin" -o -name ".*zlogout" -o -name ".*profile" -o -name ".*login" -o -name ".*logout" | head -n 1)

  # write new variables to the config file
  echo "export PERSONAL_REPO=$personal" >> $bash_config_file
  echo "export WORK_REPO=$work" >> $bash_config_file

  # clone the repo with bash scripts
  remote_link=https://github.com/doubleniki/bash-scripts.git
  mkdir -p $HOME/.bash-scripts
  git clone $remote_link $HOME/.bash-scripts

  # get all shell scripts from the repo
  shell_scripts=$(find $HOME/.bash-scripts -name "*.sh")

  # source all shell scripts
  for script in $shell_scripts
  do
    echo "source $script" >> $bash_config_file
  done
}

set_folders
