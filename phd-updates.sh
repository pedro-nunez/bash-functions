#!/bin/bash

phd() {
  # Function to start working on a project taking project as input
  # Get current week number (Monday as first day of the week):
  WEEK_NUMBER=$(date +%V)
  echo "Current week: ${WEEK_NUMBER}"
  # Get current date (iso format and day of the week in parenthesis)
  CURRENT_DATE="$(date -I) ($(date +%A))"
  echo "Current date: ${CURRENT_DATE}"
  # Get also current date without day of the week for cross-referencing
  REF_DATE="$(date -I)"
  # Get relevant week file
  AUXILIARY_FILE="${HOME}/git/phd-2022/weeks/week${WEEK_NUMBER}.tex"
  echo "Relevalt week file: ${AUXILIARY_FILE}"
  cd
  # Do one thing or another depending on whether the file for the current week already exists or not
  if [ -f "${AUXILIARY_FILE}" ]; then
    # File already exists
    echo "File for this week already exists"
    # We check whether it is already included in main.tex just in case
    if ! grep -Fq "\include{weeks/week${WEEK_NUMBER}}" "${HOME}/git/phd-2022/main.tex"; then
      echo "Oops, week file exists but is not included in main.tex"
      # Stop running the function and return failure (non-zero return)
      return 1
    fi
    # File exists and is included in main.tex
    echo "And it is also included in main.tex"
    # Go to the location of this week's file
    cd ${HOME}/git/phd-2022/weeks
  else
    # File does not exist yet
    echo "File does not exist yet"
    # Get previous week number
    PREVIOUS_WEEK_NUMBER=$((10#${WEEK_NUMBER}-1))
    if [ ${#PREVIOUS_WEEK_NUMBER} -lt 2 ]; then
      echo "Add a zero to the left of previous week number"
      PREVIOUS_WEEK_NUMBER="0${PREVIOUS_WEEK_NUMBER}"
    fi
    echo "The previous week number is ${PREVIOUS_WEEK_NUMBER}"
    # Check whether previous week file exists
    if [ -f "${HOME}/git/phd-2022/weeks/week${PREVIOUS_WEEK_NUMBER}.tex" ]; then
      # Previous week file already exists
      echo "Previous week's file already exists"
      # We check whether it is already included in main.tex just in case
      if ! grep -Fq "\include{weeks/week${PREVIOUS_WEEK_NUMBER}}" "${HOME}/git/phd-2022/main.tex"; then
        echo "Oops, previous week file exists but is not included in main.tex"
        # Stop running the function and return failure (non-zero return)
        return 2
      fi
      # Previous week file exists and is included in main.tex
      echo "And it is also included in main.tex"
      # We delete lines matching week${WEEK_NUMBER} from main.tex, in case they existed
      sed -i '/week'"${WEEK_NUMBER}"'/d' "${HOME}/git/phd-2022/main.tex"
      # Add \include{weeks/week${WEEK_NUMBER}} after \include{weeks/week${PREVIOUS_WEEK_NUMBER}}
      sed -i '/^\\\include{weeks\/week'"${PREVIOUS_WEEK_NUMBER}"'}/a \\\include{weeks\/week'"${WEEK_NUMBER}"'}' "${HOME}/git/phd-2022/main.tex"
      # Go to the future location of the yet-to-be-created week file
      cd ${HOME}/git/phd-2022/weeks
      # This week's file will be created here once we exit this if statement, right after the next else block
    else
      # Previous week file does not exist yet
      echo "Previous week file does not exist yet"
      # We delete lines matching week${PREVIOUS_WEEK_NUMBER} from main.tex, in case they existed
      sed -i '/week'"${PREVIOUS_WEEK_NUMBER}"'/d' "${HOME}/git/phd-2022/main.tex"
      # We reset the section counter accordingly
      # \setcounter{section}{03} seems to have the same effect as \setcounter{section}{3}, so there is no need to modify the variable ${PREVIOUS_WEEK_NUMBER}
      # So we add \setcounter{section}{${PREVIOUS_WEEK_NUMBER}} after last line containing *include{weeks/week*
      sed -i '1h;1!H;$!d;x;s/.*{weeks\/week[^\n]*/&\n\\\setcounter{section}{'"${PREVIOUS_WEEK_NUMBER}"'}/' "${HOME}/git/phd-2022/main.tex"
      # The following are some more detailed explanations from the nice command, gotten among other places from https://stackoverflow.com/a/37911473/4405516

      # First the s/.*{weeks/week[^\n]*/&\n\\\setcounter{section}{'"${PREVIOUS_WEEK_NUMBER}"'}/' part
      # This is sed's substitute command
      # In principle, this command alone would treat each line independently and by itself
      # This behaviour is modified with the previous part '1h;1!H;$!d;x; which we will explain later
      # But let us focus on the substitute command first
      # .*{weeks/week[^\n]* is the pattern that we are searching for
      # . is any single character
      # * is repetition of the previous character zero or more times
      # Hence .* searches for any possible pattern of any possible length
      # And .*{weeks/week searches for any possible patter of any possible length finishing with {weeks/week
      # [^\n] matches any character other than \n
      # Therefore .*{weeks/week[^\n]* matches any string of characters finishing with {weeks/week and then goes on to match up until the end of that line
      # The reason to use [^\n]* instead of .*$ is that later on, when dealing with multiple lines together, we would also match {weeks/week.*\nThe next line\nAnd the next one\nAnd so on until the end of any line after the line containing {weeks/week; due to sed's greed, this would end up matching up until the end of the pattern space I think
      # &\n\\\setcounter{section}{'"${PREVIOUS_WEEK_NUMBER}"'} is the string which we will use to replace the match
      # The & character represents the match, so we will append a new line with \setcounter... to the match

      # Now we move on to 1h;1!H;$!d;x; the following explanation is based on the answer given in https://stackoverflow.com/a/12834372/4405516 and the video https://www.youtube.com/watch?v=l0mKlIswojA
      # Right after we call sed, the first line of main.tex is read and inserted automatically into the pattern space
      # Then the command 1h is executed, which copies the first line of main.tex into the hold space
      # Then the second command would be executed, but this command is executed on every line except on the first line of main.tex, so it is not executed now
      # Then the third command $!d is executed, because we are not yet in the last line of main.tex
      # This command deletes the current (first line) from the pattern space and moves on to a new line, in this case the second line of main.tex, skipping all the remaining commands that would have affected to the line that we just deleted from the pattern space
      # The second line is loaded into the pattern space and the hold space is unchanged, still containing the first line of main.tex
      # Now we start editing the second line of main.tex, currently in the pattern space, with the same array of commands
      # Now the command 1h is not executed anymore because we are already on the second line
      # On the other hand the command 1!H is executed, appending the current pattern space to the hold buffer
      # The hold buffer contains now the first two lines of main.tex
      # If we are not in the last line of main.tex yet, then the third command $!d is executed, and the process starts again from the third line of main.tex
      # Eventually we get to the last line of main.tex and we append it to the hold space with 1!H
      # But this time $!d does not trigger, because we are currenlty on the last line
      # The next command, x, exchanges now the hold buffer and the pattern buffer
      # So the current pattern buffer contains the hole file main.tex (in a single line with \n instead of line breaks, I think)
      # The current hold space contains only the last line, but we don't care about that anymore
      # Now the substitute command is applied to the current pattern buffer, containing all of main.tex (on a single line with \n instead of line breaks, I think)
      # The regular expressions used in the search pattern yield now the desired result: add a line \setcounter... right after the last line containing the pattern {weeks/week

      # Add \include{weeks/week${WEEK_NUMBER}} after \setcounter{section}{${PREVIOUS_WEEK_NUMBER}}
      sed -i '/^\\\setcounter{section}{'"${PREVIOUS_WEEK_NUMBER}"'}/a \\\include{weeks\/week'"${WEEK_NUMBER}"'}' "${HOME}/git/phd-2022/main.tex"
      # Go to the future location of the yet-to-be-created week file
      cd ${HOME}/git/phd-2022/weeks
      # This week's file will be created here right after we exit this if block
    fi
    # We create this week's (with corresponding seciton header) in the current location
    printf "\section{}" >> "${AUXILIARY_FILE}"
  fi
  echo "We should now be at ${HOME}/git/phd-2022/weeks"
  echo "We are currently in:"
  echo $(pwd)
  # Check if date exists or not and edit week file accordingly
  if ! grep -Fq "\subsection*{${CURRENT_DATE}}" "${AUXILIARY_FILE}"; then
    # If date does not exist, we add corresponding (unnumbered) subsection
    printf "\n\subsection*{${CURRENT_DATE}}\n\\\phantomsection\\\label{day:${REF_DATE}}\n" >> "${AUXILIARY_FILE}"
  fi
  if [ $# = 0 ]
  then
    # Set the TAG and TAGCOLOR appropriately
    TAG="General"
    TAGCOLOR="black"
  elif [ ${1} = "p1" ]
  then
    # Set the TAG and TAGCOLOR appropriately
    TAG="P1"
    TAGCOLOR="darkgreen"
  elif [ ${1} = "p2" ]
  then
    # Set the TAG and TAGCOLOR appropriately
    TAG="P2"
    TAGCOLOR="darkred"
  elif [ ${1} = "p3" ]
  then
    # Set the TAG and TAGCOLOR appropriately
    TAG="P3"
    TAGCOLOR="darkblue"
  elif [ ${1} = "pa" ]
  then
    # Set the TAG and TAGCOLOR appropriately
    TAG="PA"
    TAGCOLOR="darkgray"
  elif [ ${1} = "pb" ]
  then
    # Set the TAG and TAGCOLOR appropriately
    TAG="PB"
    TAGCOLOR="brown"
  else
    # Invalid input
    echo "Invalid input!"
    return 3
  fi
  # Use the corresponding TAG and TAGCOLOR in the preliminary edit of the current week's file
  printf "\n\\\noindent{\color{${TAGCOLOR}}[${TAG}]\\\\\\\\\n}\smallskip" >> "${AUXILIARY_FILE}"
  # Open vim on the last line and start a new line above it in insert mode directly
  vim "+norm GO" "+star" "${AUXILIARY_FILE}"
}

p1() {
  # Multi-purpose function to manage [P1]
  if [ $# = 0 ]
  then
    # Open phd updates and start writing about [P1]
    phd p1
  elif [ ${1} = "ls" ]
  then
    # Read todo list items having project P1
    todo-txt ls | grep -iF +P1
  else
    # Add a task with project P1 and context work
    todo-txt add ${@:1} +P1 @study
  fi
}

p2() {
  # Multi-purpose function to manage [P2]
  if [ $# = 0 ]
  then
    # Open phd updates and start writing about [P2]
    phd p2
  elif [ ${1} = "ls" ]
  then
    # Read todo list items having project P2
    todo-txt ls | grep -iF +P2
  else
    # Add a task with project P2 and context work
    todo-txt add ${@:1} +P2 @study
  fi
}

p3() {
  # Multi-purpose function to manage [P3]
  if [ $# = 0 ]
  then
    # Open phd updates and start writing about [P3]
    phd p3
  elif [ ${1} = "ls" ]
  then
    # Read todo list items having project P3
    todo-txt ls | grep -iF +P3
  else
    # Add a task with project P3 and context work
    todo-txt add ${@:1} +P3 @study
  fi
}

pa() {
  # Multi-purpose function to manage [PA]
  if [ $# = 0 ]
  then
    # Open phd updates and start writing about [PA]
    phd pa
  elif [ ${1} = "ls" ]
  then
    # Read todo list items having project PA
    todo-txt ls | grep -iF +PA
  else
    # Add a task with project PA and context work
    todo-txt add ${@:1} +PA @study
  fi
}

pb() {
  # Multi-purpose function to manage [PB]
  if [ $# = 0 ]
  then
    # Open phd updates and start writing about [PB]
    phd pb
  elif [ ${1} = "ls" ]
  then
    # Read todo list items having project PB
    todo-txt ls | grep -iF +PB
  else
    # Add a task with project PB and context work
    todo-txt add ${@:1} +PB @study
  fi
}
