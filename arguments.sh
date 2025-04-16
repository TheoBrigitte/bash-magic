#!/bin/bash
#
# This script demonstrates how to parse command-line arguments in a bash script.
# It provides support for options with long and short names, as well as options that require arguments.
# It was inspired from https://mywiki.wooledge.org/BashFAQ/035
# It does not use either getopts (no suport long names) or getopt (not recommended).

set -eu

main() {
  # Arguments variables
  file=""
  verbosity_level=0

  # Process arguments
  while [ $# -gt 0 ]; do
    case $1 in
      -h|--help)
        # Display help message and exit.
        show_help
        exit
        ;;
      -f|--file)
        # Take the next argument as the value for --file.
        file=${2-}
        if [ -z "$file" ]; then
          echo 'ERROR: "--file" requires an argument.' >&2
          exit 1
        fi
        shift
        ;;
      -v|--verbose)
        # Increment verbosity level (once for each -v).
        verbosity_level=$((verbosity_level + 1))
        ;;
      --)
        # End of all options.
        shift
        break
        ;;
      -?*)
        echo "WARN: Unknown option $1" >&2
        ;;
      *)
        # No more options.
        break
        ;;
    esac
    shift
  done

  echo "verbosity: $verbosity_level"
  echo "file     : $file"
  echo "remaining:" "$@"
}

main "$@"
