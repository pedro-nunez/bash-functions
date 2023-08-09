#!/bin/bash

uu() {
  # Function to start writing (daily) updates on ongoing projects, work, etc.
  # Get current month, in format YYYY-MM.
  CURRENT_MONTH=$(date +%Y-%m)
  echo "Current month is ${CURRENT_MONTH}, i.e., $(date +%B) of $(date +%Y)."
  # Get current date (iso format and day of the week in parenthesis).
  CURRENT_DATE="$(date -I) ($(date +%A))"
  echo "Current date: ${CURRENT_DATE}."
  # Get also current date without day of the week for cross-referencing.
  REF_DATE="$(date -I)"
  # Get relevant month file.
  AUXILIARY_FILE="${HOME}/git/updates/months/${CURRENT_MONTH}.tex"
  echo "Relevant month file: ${AUXILIARY_FILE}."
  cd
  # Do one thing or another depending on whether the file for the current month file exists or not.
  if [ -f "${AUXILIARY_FILE}" ]
  then
    # File already exists.
    echo "File for this month already exists."
    # We check whether it is already included in main.tex, just in case.
    if ! grep -Fq "\include{months/${CURRENT_MONTH}" "${HOME}/git/updates/main.tex"
    then
      echo "Error: month file exists but is not included in main.tex."
      # Stop running the function and return failure (i.e., non-zero return).
      return 1
    fi
    # If the code still runs, then the file for the current month already exists and is included in main.tex.
    echo "And it is also included in main.tex, as it should be."
  else
    # File does not exist yet, so we create it and include it in main.tex.
    echo "File does not exist yet."
    # We create this month's file (with corresponding chapter title) in the current location.
    printf "\chapter{$(date +%B) $(date +%Y)}\n" >> "${AUXILIARY_FILE}"
    echo "New month file with corresponding chapter title was created."
    # Delete lines matching include{months/${CURRENT_MONTH} from main.tex, in case they existed.
    sed -i '/include{months\/'"${CURRENT_MONTH}"'/d' "${HOME}/git/updates/main.tex"
    if grep -Fq "\include{months" ${HOME}/git/updates/main.tex
    then
      # Some months are already included.
      echo "Some month files are already included in main.tex."
      # Add \include{months/${CURRENT_MONTH}} after the last line matching \include{months[^\n]*.
      sed -i '1h;1!H;$!d;x;s/.*include{months[^\n]*/&\n\\\include{months\/'"${CURRENT_MONTH}"'}/' "${HOME}/git/updates/main.tex"
      # The following are some more detailed explanations of this command, gotten among other places from https://stackoverflow.com/a/37911473/4405516.
      # 
      # First the s/.*{months[^\n]*/&\n\\\include{months/'"${CURRENT_MONTH}"'}/' part.
      # This is sed's substitute command.
      # In principle, this command alone would treat each line independently and by itself.
      # This behaviour is modified with the previous part '1h;1!H;$!d;x; which we will explain later.
      # But let us focus on the substitute command first.
      # .*include{months[^\n]* is the pattern that we are searching for.
      # . is any single character.
      # * is repetition of the previous character zero or more times.
      # Hence .* searches for any possible pattern of any possible length.
      # And .*include{months searches for any possible patter of any possible length finishing with include{months.
      # [^\n] matches any character other than \n.
      # Therefore .*include{months[^\n]* matches any string of characters finishing with include{months and then goes on to match up until the end of that line.
      # The reason to use [^\n]* instead of .*$ is that later on, when dealing with multiple lines together, we would also match include{months.*\nThe next line\nAnd the next one\nAnd so on until the end of any line after the line containing include{months; due to sed's greed, this would end up matching up until the end of the pattern space I think.
      # &\n\\\include{months/'"${CURRENT_MONTH}"'}/ is the string which we will use to replace the match.
      # The & character represents the match, so we will append a new line with \include... to the match.
      #
      # Now we move on to 1h;1!H;$!d;x; the following explanation is based on the answer given in https://stackoverflow.com/a/12834372/4405516 and the video https://www.youtube.com/watch?v=l0mKlIswojA.
      # Right after we call sed, the first line of main.tex is read and inserted automatically into the pattern space.
      # Then the command 1h is executed, which copies the first line of main.tex into the hold space.
      # Then the second command would be executed, but this command is executed on every line except on the first line of main.tex, so it is not executed now.
      # Then the third command $!d is executed, because we are not yet in the last line of main.tex.
      # This command deletes the current (first) line from the pattern space and moves on to a new line, in this case the second line of main.tex, skipping all the remaining commands that would have affected the line that we just deleted from the pattern space.
      # The second line is loaded into the pattern space and the hold space is unchanged, still containing the first line of main.tex.
      # Now we start editing the second line of main.tex, currently in the pattern space, with the same array of commands.
      # Now the command 1h is not executed anymore because we are already on the second line.
      # On the other hand the command 1!H is executed, appending the current pattern space to the hold buffer.
      # The hold buffer contains now the first two lines of main.tex.
      # If we are not in the last line of main.tex yet, then the third command $!d is executed, and the process starts again from the third line of main.tex.
      # Eventually we get to the last line of main.tex and we append it to the hold space with 1!H.
      # But this time $!d does not trigger, because we are currenlty on the last line.
      # The next command, x, exchanges now the hold buffer and the pattern buffer.
      # So the current pattern buffer contains the hole file main.tex (in a single line with \n instead of line breaks, I think).
      # The current hold space contains only the last line, but we don't care about that anymore.
      # Now the substitute command is applied to the current pattern buffer, containing all of main.tex (on a single line with \n instead of line breaks, I think).
      # The regular expressions used in the search pattern yield now the desired result: add a line \include... right after the last line containing the pattern include{months.
      echo "The new month file was included after the last one in main.tex."
    else
      # No months are included yet.
      echo "No month files included in main.tex yet."
      # We add \include{months/${CURRENT_MONTH}} after % Monthly files:.
      sed -i '/Monthly files:/a \\n\\include{months\/'"${CURRENT_MONTH}"'}' "${HOME}/git/updates/main.tex"
      echo "The new month file was included after the Monthly files comment in main.tex."
    fi
  fi
  # The current month's file exists and is included in main.tex now.
  echo "File for current month exists and is included in main.tex."
  # If the current date does not appear in this month's file, we add the corresponding (unnumbered) section and hyperref marker.
  if ! grep -Fq "\section*{\color{teal}${CURRENT_DATE}}" "${AUXILIARY_FILE}"
  then
    printf "\n\section*{\color{teal}${CURRENT_DATE}}\n\\\phantomsection\\\label{day:${REF_DATE}}\n\n" >> "${AUXILIARY_FILE}"
    echo "A new section for the current date was created."
  else
    echo "Section for the current date already exists."
  fi
  # We go to the location of the relevant month file.
  cd ${HOME}/git/updates/months
  # We open vim on the last line and start a new line below it in insert mode directly.
  vim "+norm Go" "+start" "${AUXILIARY_FILE}"
}
