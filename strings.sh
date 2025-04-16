#!/bin/bash
#
# This script demonstrates various string manipulation techniques in bash.
# https://tldp.org/LDP/abs/html/string-manipulation.html

# File path manipulation
path="/path/to/file.txt"
basename="${path##*/}"
dirname="${path%/*}"
extension="${path##*.}"
filename="${basename%.*}"
echo "path:      $path"
echo "dirname:   $dirname"
echo "basename:  $basename"
echo "filename:  $filename"
echo "extension: $extension"

# Replacement
input="one foo two foo three foo"
output="${input//foo/bar}"
echo "input:    $input"
echo "output:   $output"

input="case"
echo "${input^^}"
echo "${input,,}"

# Split a string with a delimiter
delimiter="|"
input="foo|bar|baz"
IFS="$delimiter" read -r -a array <<< "$input"

echo "split input:  $input"
echo "split output: ${array[*]} (${#array[@]} elements)"

# Join strings with a delimiter
join_by() {
  local IFS="$1"
  shift
  echo "$*"
}

delimiter="_"
input=("foo" "bar" "baz")
output=$(join_by "$delimiter" "${input[@]}")

echo "join input:  ${input[*]} (${#input[@]} elements)"
echo "join output: $output"
