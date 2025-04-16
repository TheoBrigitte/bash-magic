#!/bin/bash
#
# This script demonstrates how to use a dry-run mode in a bash script.
# Run this script with: DRY_RUN=true to enable dry-run mode

function _run () {
  if $DRY_RUN; then
    echo "[dry-run]" "$@" >&2
  else
    "$@"
  fi
}

DRY_RUN=${DRY_RUN:-false}

_run echo foo
