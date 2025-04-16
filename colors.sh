#!/bin/bash
#
# This script demonstrates how to use ANSI escape codes to print colored text in the terminal.
# Use \033[1 for bright colors
# Run this script with piped output to see the effect (e.g. with `| cat`)

BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NO_COLOR='\033[0m'

# Print colors
for color in BLACK RED GREEN ORANGE YELLOW BLUE PURPLE CYAN GRAY; do
  echo -e "> ${!color}${color}${NO_COLOR}"
done

# Helper to print colors
echo_color() {
  if [ "$COLOR" = true ]; then
    echo -e "$@"
  else
    # Magic sed command which strips out ANSI color codes
    echo -e "$@" | sed -e 's/\x1b\[[0-9;]*m//g'
  fi
}

COLOR=true
if [ ! -t 1 ]; then
  # Disable color if not connected to a terminal
  COLOR=false
fi

echo_color "${BLUE}interactive terminal ${COLOR}${NO_COLOR}"
