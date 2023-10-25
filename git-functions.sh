# Author: Nikita Saltykov
# My git functions

gall() {
  git add . #Add all changed files
  message="${1:-Update}" #If commit message is not provided, use "Update"
  git commit -m "$message" #Commit with message
  git push origin HEAD #Push to origin
}

gcfg() {
  if [ $# -eq 0 ] #If no arguments are provided
  then
    echo "Please provide a name and email"
  elif [ "$#" = "--G" ] #If --G is provided, set global config
  then
    git config --global user.name "$1"
    git config --global user.email "$2"
  else
    git config user.name "$1"
    git config user.email "$2"
  fi
}

ginit() {
  git init

  echo "Please enter your name:"
  read name
  echo "Please enter your email:"
  read email

  gcfg $name $email

  echo "Please enter the name of the main branch you want to create:"
  read branch_name

  git branch -m ${branch_name:-main}
  git add .
  git commit -m "Initial commit"

  echo "Please enter the link of the remote repository you want to push to:"
  read remote_link

  if [ -n "$remote_link" ]
  then
    echo "No remote link provided. Exiting..."
    exit 1
  fi

  git add remote origin $remote_link
}
