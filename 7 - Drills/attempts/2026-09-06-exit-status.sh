#!/bin/bash

ping $1 -c 1 -w 1 &>/dev/null
if [[ "$?" -eq 0 ]]; then
  echo "OK"
  exit 0
else
  echo "FAIL" >&2
  exit 1
fi
