#!/bin/bash

init_git_repo() {
  # Prompt the user for their name and email
  echo "Please enter your name:"
  read -r name

  echo "Please enter your email:"
  read -r email

  # Initialize the Git repository
  git init

  # Set the local Git config
  echo "Do you want to set global Git config? (y/n)"
  read -r global

  if [ "$global" = "y" ]
  then
    git config --global user.name "$name"
    git config --global user.email "$email"
  else
    git config user.name "$name"
    git config user.email "$email"
  fi

  # Prompt the user for the remote repository link
  echo "Please enter the link of the remote repository you want to push to:"
  read -r remote_link

  # Set the remote origin if a link is provided
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

init_git_repo
