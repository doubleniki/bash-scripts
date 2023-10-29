#!/bin/bash
# Author: Nikita Saltykov

ask_about_cred() {
  echo "Please enter your $1:"
  read -r cred

  if [ -z "$cred" ] #If cred is not provided
  then
    echo "$1 is not provided. Exiting..."
    exit 1
  fi

  echo "$cred"
  return
}

init_git() {
  git init --quiet #Initialize git repository
  echo "Initialized git repository"

  return
}

gall() {
  git add . #Add all changed files

  # check if -m flag is provided
  if [ "$1" = "--amend" ]
  then
    git commit --amend --no-edit #Amend commit
  else
    message="${1:-Update}" #If commit message is not provided, use "Update"
    git commit -m "$message" #Commit with message
  fi

  # if --amend flag is provided, push with --force flag
  if [ "$1" = "--amend" ]
  then
    git push origin HEAD --force #Push to origin
  else
    git push origin HEAD #Push to origin
  fi

  echo "Pushed to origin HEAD"

  return
}

gcfg() {
  local name
  name=$(ask_about_cred "name")

  local email
  email=$(ask_about_cred "email")

  if [ -z "$name" ] || [ -z "$email" ] #If email is not provided
  then
    echo "Creds are not enough. Exiting..."
    exit 1
  fi

  echo "Provided name: $name, email: $email"

  # Ask if config will be global
  echo "Do you want to set global config? (y/n)"
  read -r global

  if [ "$global" = "y" ] #If --G is provided, set global config
  then
    git config --global user.name "${name}"
    git config --global user.email "$email"
  else
    git config user.name "${name}"
    git config user.email "$email"
  fi

  return
}

ginit() {
  init_git
  gcfg

  echo "Please enter the name of the main branch you want to create:"
  read -r branch_name

  branch_name=${branch_name:-main}

  git branch -m "$branch_name"
  git add .
  git commit -m "Initial commit"

  echo "Please enter the link of the remote repository you want to push to:"
  read -r remote_link

  if [ -n "$remote_link" ]
  then
    git remote add origin "$remote_link"
    git push -u origin HEAD

    echo "Pushed to origin HEAD"
  else
    echo "No remote link provided. Exiting..."
    exit 1
  fi
}
