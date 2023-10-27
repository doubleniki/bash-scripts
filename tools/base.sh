#!/bin/sh
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
# shellcheck disable=SC2086
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~"$USER")}"

# Default settings
REPO=${REPO:-doubleniki/bash-scripts}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-master}

# check what shell is used
if [ -n "$ZSH_VERSION" ]; then
  SHELL="zsh"
elif [ -n "$BASH_VERSION" ]; then
  SHELL="bash"
else
  echo "Unknown shell. Exiting..."
  exit 1
fi

# find a bash config file based on the shell
if [ "$SHELL" = "zsh" ]; then
  BASH_CFG=$HOME/.zshrc
elif [ "$SHELL" = "bash" ]; then
  BASH_CFG=$HOME/.bashrc
fi

# check if cfg file found
if [ -z "$BASH_CFG" ]; then
  echo "Config file not found. Exiting..."
  exit 1
fi
