#!/bin/bash

uu() {
  # Function to start writing updates on a project, taking tag for that project as input.
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
  if [ -f "${AUXILIARY_FILE}" ]; then
    # File already exists.
    echo "File for this month already exists."
    # We check whether it is already included in main.tex just in case.
    if ! grep -Fq "\include{months/${CURRENT_MONTH}" "${HOME}/git/updates/main.tex"; then
      echo "Error: month file exists but is not included in main.tex."
      # Stop running the function and return failure (i.e., non-zero return).
      return 1
    fi
    # If the code still runs, then the file for the current month already exists and is included in main.tex.
    echo "And it is also included in main.tex, as it should be."
    # Go to the location of this month's file.
    cd ${HOME}/git/updates/months
  else
    # File does not exist yet.
    echo "File does not exist yet."
    # Delete lines matching ${CURRENT_MONTH} from main.tex, in case they existed.
    sed -i '/"${CURRENT_MONTH}"'/d/ "${HOME}/git/updates/main.tex"
    # Add \include{months/${CURRENT_MONTH}} after the last \include{months/*.
    # TODO finish
  fi
}
