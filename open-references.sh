#!/bin/bash

openref() {
  # Open a reference with the default pdf reader
  # The first argument should be the expected location of the reference
  # The second argument should be (the beginning of) the expected name of the file

  if [ $# == 2 ] && [ -d $1 ]
  # Make sure that the inputs are as expected
  then

    MATCHES=$(find ${1}/${2}* 2>/dev/null | wc -l)
    # Find the number of references starting with the first argument (ignore all errors)
    # It does not matter if $1 ends with a slash already, see https://unix.stackexchange.com/a/1919/212239

    if [ ${MATCHES} == 0 ]
    then
      echo "No reference matched."
    elif [ ${MATCHES} == 1 ]
    then
      okular "${1}/${2}"* 2>/dev/null & exit
      # Exactly one match, so we open the corresopnding reference
      # If we do not wish to close the terminal after opening the reference, we should replace the previous line by
      # (okular "${1}/${2}"* 2>/dev/null &)
      # See https://stackoverflow.com/a/38278291/4405516 for an explanation on the usage of parentheses above

    else
      echo "Several references matched:"
      cd "${1}"
      find "${2}"* 2>/dev/null
      # Several matches, so we list them all
      cd
    fi
  else
    echo "Invalid inputs."
  fi
}

b() {
  # Open a book with the default pdf reader
  # The first argument should be (the beginning of) the reference in biblatex's alphabetic style, but all letters lowercase
  # That is:
    # For a sinlge author, the first three letters of the name followed by the last two digits of the publication year
    # For several authors, the initial letters of the authors plus the last two digits of the publication year

  openref ${HOME}/books $1
}

n() {
  # Open lecture notes with the default pdf reader
  # The first argument should be (the beginning of) the reference in biblatex's alphabetic style, but all letters lowercase
  # That is:
    # For a sinlge author, the first three letters of the name followed by the last two digits of the publication year
    # For several authors, the initial letters of the authors plus the last two digits of the publication year

  openref ${HOME}/notes $1
}

p() {
  # Open a paper with the default pdf reader
  # The first argument should be (the beginning of) the reference in biblatex's alphabetic style, but all letters lowercase
  # That is:
    # For a sinlge author, the first three letters of the name followed by the last two digits of the publication year
    # For several authors, the initial letters of the authors plus the last two digits of the publication year

  openref ${HOME}/papers $1
}
