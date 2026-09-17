---
date: 2026-09-03 22:00
tags:
  - drills
  - log
---
# Drill Log

Append-only. One row per attempt. The AI reads the tail of this file to pick the next skill and to avoid repeating a task. See [[Drill Protocol]].

| Date | Lang | Skill | Level | Task | Result | Missed |
| :--- | :--- | :--- | :---: | :--- | :--- | :--- |
| 2026-09-03 | bash | args | 1 | Validate two arguments, usage to stderr, report copy target | PARTIAL | Omitted $1 in message; duplicated gt/lt branches instead of -ne |
| 2026-09-06 | bash | exit-status | 1 | Ping target with 1s timeout, branch on exit status | PARTIAL | Indirect $? test instead of direct 'if cmd', unquoted $1 |
| 2026-09-08 | bash | conditionals | 1 | Check path type (-f/-d) with [[ ]], stderr on miss | PASS | None |
| 2026-09-11 | bash | loops | 1 | Read hosts file line by line with read -r, numbered output, total after loop | PASS | None (also noticed: numbering started at 0, missing-file branch exits 0) |
| 2026-09-12 | bash | files-logs | 1 | Delete .log files older than 7 days in $1 with one find, print each, validate directory | PARTIAL | Two separate find runs (list, then delete) instead of -print -delete: what is printed is not guaranteed to be what is deleted |
