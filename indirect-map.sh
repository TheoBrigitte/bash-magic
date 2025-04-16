#!/bin/bash
#
# This script demonstrates how to access a map (associative array) in bash.

# Declare MAP_NAME as associative array also known as map
declare -A MAP_NAME=(
	[foo]="bar"
	[answer]=42
)

# Direct access to foo key
echo "${MAP_NAME[foo]}"

# Indirect access to foo key
map_name="MAP_NAME"
key_name="foo"
map_key_accessor="${map_name}[${key_name}]"
echo "${!map_key_accessor}"
