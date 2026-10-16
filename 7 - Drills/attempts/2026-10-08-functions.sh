#!/bin/bash

check_if_exists() {
  local filepath="$1"
  if [[ -f "$filepath" ]]; then
    echo "Found: $filepath"
    return 0
  else
    echo "Missing: $filepath"
    return 1
  fi
}

check_if_exists "$1"
