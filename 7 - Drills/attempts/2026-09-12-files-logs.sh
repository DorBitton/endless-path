#!/bin/bash

dir="$1"

[[ -e "$1" ]] || {
  echo "Error: No file path provided" >&2
  exit 1
}
[[ -d "$1" ]] || {
  echo "Error: path is not a directory" >&2
  exit 1
}

find "$1" -name "*.log" -type f -mtime +7

find "$1" -name "*.log" -type f -mtime +7 -delete

exit 0
