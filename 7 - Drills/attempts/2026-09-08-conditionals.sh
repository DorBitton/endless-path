#!/bin/bash

if [[ -f "$1" ]]; then
  echo "FILE"
  exit 0
elif [[ -d "$1" ]]; then
  echo "DIR"
  exit 0
else
  echo "NOT FOUND" >&2
  exit 1
fi
