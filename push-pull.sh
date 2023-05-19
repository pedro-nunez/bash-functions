#!/bin/bash

push() {
  # Push local changes on a repository to GitHub using
  # One should call this function from the folder containing the repository's folder
  # First argument is the name of the repository
  # If no arguments, then updates will be the default repository
  # Remaining arguments are used as a commit message
  # If at most one argument, "Some updates" will be the default commit message
  if [ $# = 0 ]
  then
    cd "${HOME}/git/updates"
    git add .
    git commit -m "Some updates"
    git push origin master
    cd
  elif [ $# = 1 ]
  then
    cd "${1}"
    git add .
    git commit -m "Some updates"
    git push origin master
    cd ..
  else
    cd "${1}"
    git add .
    git commit -m "${*:2}"
    git push origin master
    cd ..    
  fi
}

pull() {
  # Pull changes from GitHub to your local folder
  # First argument is the name of the repository
  # If no arguments, then updates will be the default repository
  if [ $# = 0 ]
  then
    cd "${HOME}/git/updates"
    git pull origin master
    cd
  else
    cd "${1}"
    git pull origin master
    cd ..
  fi
}
