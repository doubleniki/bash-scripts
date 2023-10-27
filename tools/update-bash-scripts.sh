# #!/bin/sh
# # Author: Nikita Saltykov

# # enable the "errexit" option
# set -e

# # Make sure important variables exist if not already defined
# #
# # $USER is defined by login(1) which is not always executed (e.g. containers)
# # POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
# USER=${USER:-$(id -u -n)}
# # $HOME is defined at the time of login, but it could be unset. If it is unset,
# # a tilde by itself (~) will not be expanded to the current user's home directory.
# # POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
# HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# # macOS does not have getent, but this works even if $HOME is unset
# HOME="${HOME:-$(eval echo ~$USER)}"

# # Default settings
# REPO=${REPO:-doubleniki/bash-scripts}
# REMOTE=${REMOTE:-https://github.com/${REPO}.git}
# BRANCH=${BRANCH:-master}

source ./base.sh

# check if git is installed
if ! command_exists git; then
  echo "git is not installed. Please install git and run this script again."
  exit 1
fi

# find bash-scripts dir
BASH_SCRIPTS_DIR=$(find $HOME -maxdepth 1 -name ".bash-scripts" | head -n 1)

# check if bash-scripts dir exists
if ! folder_exists $BASH_SCRIPTS_DIR; then
  echo "bash-scripts dir does not exist. Exiting..."
  exit 1
fi

cd $BASH_SCRIPTS_DIR

# check if git is initialized
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "git is not initialized. Initializing git..."
  git init
fi

# check if git remote is set
if ! git config --get remote.origin.url > /dev/null 2>&1; then
  echo "git remote is not set. Setting git remote..."
  git remote add origin $REMOTE
fi

# check if git branch is set
if ! git branch --show-current > /dev/null 2>&1; then
  echo "git branch is not set. Setting git branch..."
  git branch -M $BRANCH
fi

# fetch the latest changes
echo "Fetching the latest changes..."
git fetch origin $BRANCH

# check if git pull is needed
if ! git diff --quiet; then
  echo "git pull is needed. Pulling..."
  git pull origin $BRANCH
fi

# tell the user that the script is done
echo "Done!"
