#!/bin/bash
#
# This script provides a function to prompt the user for a yes/no response.
# It allows for default response and forcing the answer.
# Run this script with: FORCE=true to skip the prompt and answer with the default value

YES_PATTERN="^[Yy]$"
NO_PATTERN="^[Nn]$"

FORCE=${FORCE:-false}

# Function to prompt the user for a yes/no response
# $1: The prompt message
# $2: Default return value (0 for yes, 1 for no)
# Returns 0 if the answer is yes, 1 if no
ask() {
  local prompt="$1"
  local default="${2:-0}"

  $FORCE && return "$default"

  if [[ $default -eq 0 ]]; then
    prompt="${prompt} [Y/n] "
    pattern="$NO_PATTERN"
  else
    prompt="${prompt} [y/N] "
    pattern="$YES_PATTERN"
  fi

  read -ern 1 -p "$prompt"

  [[ ! $REPLY =~ $pattern ]]
  [[ $? -eq $default ]]
}

# Example with yes as default
if ask "Do you want to continue?"; then
  echo "Answered yes, continuing..."
else
  echo "Answered no, stopping..."
fi

# Example with no as default
if ask "Do you want to delete sensitive file?" 1; then
  echo "Answered yes, deleting..."
else
  echo "Answered no, skipping..."
fi
