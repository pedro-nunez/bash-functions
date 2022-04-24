#!/bin/bash

sheet() {
  # Create new exercise sheet for Elementargeometrie with corresponding private GitHub repository
  # First argument is the number of the exercise sheet
  # Second argument is the deadline to hand in the exercise sheet (DD.MM.YYYY)
  cd "${HOME}/git"
  mkdir "eg-blatt-${1}"
  cd "eg-blatt-${1}"
  cp "${HOME}/Templates/eg-ss-22/main.tex" "main.tex"
  cp "${HOME}/Templates/eg-ss-22/README.md" "README.md"
  cp "${HOME}/Templates/eg-ss-22/gitignore" ".gitignore"
  sed -i "s/number-of-blatt/${1}/g" "main.tex"
  sed -i "s/number-of-blatt/${1}/g" "README.md"
  sed -i "s/date-of-abgabe/${2}/g" "main.tex"
  git init
  git add .
  git commit -m "First commit"
  hub create -p
  git push origin master
}
