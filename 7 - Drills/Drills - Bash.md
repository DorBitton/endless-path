---
date: 2026-09-03 22:00
tags:
  - review
  - drills
  - bash
---
# Drills - Bash

Skill registry for Bash drills. Read by the AI following [[Drill Protocol]]. When this note shows up in the Spaced Repetition note review, it means: run a drill today.

Levels: 1 = one construct, 2 = two constructs plus validation, 3 = interview-shaped with a twist. The AI promotes after two consecutive PASS, demotes after two consecutive FAIL (see [[Drill Log]]).

| Skill (slug) | What mastery looks like | Level | Note |
| :--- | :--- | :---: | :--- |
| `args` | Validate `$#`, print a usage line with `$0`, forward `"$@"` correctly, exit non-zero on bad input | 1 | [[Bash Arguments and Usage]] |
| `exit-status` | Branch on `$?` and `||`/`&&`, use `set -euo pipefail` deliberately, `trap` for cleanup | 1 | [[Bash Exit Status and Strict Mode]] |
| `conditionals` | `if`/`elif` with `[[ ]]`, string vs integer tests, `case` dispatch with alternation and default | 1 | [[Bash Conditionals]] |
| `loops` | Iterate `"${arr[@]}"`, read a file line by line with `read -r` without losing variables to a subshell | 1 | [[Bash Loops]] |
| `functions` | `local` scope, return status vs `echo` output, call inside `if` | 1 | [[Bash Functions]] |
| `plumbing` | Redirect order (`2>&1 >file` trap), `tee` with `sudo`, here-docs, `pipefail` | 1 | [[Shell Plumbing]] |
| `text` | Extract and transform with `awk -F`, `sed s///g` and `-i.bak`, `grep`, `sort` then `uniq -c` | 1 | [[Text Processing Filters]] |
| `services` | Check a process or unit (`pgrep`, `systemctl is-active`), restart if down, log the action | 1 | [[Service Checks in Bash]] |
| `files-logs` | Find old files, report disk usage, truncate or rotate a log safely | 1 | [[Bash File Operations]] |

## Source notes
- Hub: [[Bash]] (one note per skill, linked in the table above)
- [[Process Control]]
- [[Logrotate]]
