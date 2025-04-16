#!/bin/bash
#
# This script demonstrates how to read from a file in bash using file descriptors.
# see https://tldp.org/LDP/abs/html/x17974.html

set -eu

# Save stding to file descriptor 6
exec 6<&0

# Redirect stdin to file
exec < "$1"

echo "Following lines read from file."
echo "-------------------------------"
while read -r line; do
  echo "$line"
done
echo "-------------------------------"

# Restore stdin from file descriptor 6
exec 0<&6 6<&-
