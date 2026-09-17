#!/bin/bash

# File path
file="$1"

if [[ -z "$file" ]]; then
  echo "No file path provided, default to /tmp/drill/hosts.txt"
  file="/tmp/drill/hosts.txt"
fi
# Counter init
counter=0

if [[ -e "$file" ]]; then
  while IFS= read -r line; do
    echo "$counter:$line"
    ((counter++))
  done <"$file"
  echo "total: $counter"
else
  echo "Error: file doesn't exists $file" >&2
fi
