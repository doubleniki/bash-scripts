# Author: Nikita Saltykov

ask_about_creds() {
  echo "Please enter your name:"
  read -r name
  echo "Please enter your email:"
  read -r email

  if [ -z "$name" ] || [ -z "$email" ] #If name or email is not provided
  then
    echo "Name or email is not provided. Exiting..."
    exit 1
  fi

  # return $name $email
  echo "$name $email"
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

  git push origin HEAD #Push to origin
}

gcfg() {
  if [ $# -eq 0 ] #If no arguments are provided
  then
    credentials=$(ask_about_creds) #Ask about credentials
    name=$(echo "$credentials" | cut -d " " -f 1) #Get name
    email=$(echo "$credentials" | cut -d " " -f 2) #Get email
  fi

  if [ "$#" = "--G" ] #If --G is provided, set global config
  then
    git config --global user.name "${1:-$name}"
    git config --global user.email "${2:-$email}"
  else
    git config user.name "${1:-$name}"
    git config user.email "${2:-$email}"
  fi
}

ginit() {
  git init

  credentials=$(ask_about_creds) #Ask about credentials
  name=$(echo "$credentials" | cut -d " " -f 1) #Get name
  email=$(echo "$credentials" | cut -d " " -f 2) #Get email

  gcfg "$name" "$email"

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
    echo "No remote link provided. Exiting..."
    exit 1
  fi

  git add remote origin "$remote_link"
  git push origin HEAD
}
