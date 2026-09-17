#!/bin/bash

echo "Total Number of Arguments: $#"
if [[ $# -gt 2 ]]; then
  echo "Usage: $0" >&2
  exit 1
elif [[ $# -lt 2 ]]; then
  echo "Usage: $0" >&2
  exit 1
else
  echo "Ready to copy to $2"
fi
