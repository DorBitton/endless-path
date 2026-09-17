---
date: 2026-09-12 10:00
tags:
  - flashcards/linux/bash
  - linux
  - bash
  - scripting
  - sre
---
# Bash Exit Status and Strict Mode

Drill skill: `exit-status` in [[Drills - Bash]]. Hub: [[Bash]].

## 🧠 The Core Concept

- **`$?`:** Exit status of the most recent command. `0` = success / true; `1` to `255` = failure / error.
- **Branch on the command, not on `$?`:** `if cmd; then` tests the exit status directly. Saving `$?` and testing it afterwards is an indirection that breaks as soon as another command runs in between.
- **Conditional Chaining:**
  - `cmd1 && cmd2`: Runs `cmd2` only if `cmd1` exits with status `0` (Success).
  - `cmd1 || cmd2`: Runs `cmd2` only if `cmd1` exits with a non-zero status (Failure).
- **The Pipeline Exit Code Blindspot:** In a standard pipeline `cmd1 | cmd2 | cmd3`, `$?` only reports the **last command**. In `cat missing_file.txt | grep "FATAL" | wc -l`, `cat` crashes with code `1`, but `wc -l` counts 0 lines and exits cleanly with `0`. The shell reports success and hides the failure from scripts and CI/CD pipelines.
- **The SRE Strict Mode Trio (`set -euo pipefail`):**
  - `-e` (`errexit`): Abort the script immediately if any command returns a non-zero exit code.
  - `-u` (`nounset`): Abort immediately if an uninitialized variable is referenced (prevents `rm -rf /$UNDEFINED_VAR`).
  - `-o pipefail`: The pipeline returns the exit status of the last failing command, so `-e` can catch hidden pipeline crashes.
- **`trap` for cleanup:** `trap 'rm -f "$tmp"' EXIT` runs the command when the script exits for any reason (normal end, `exit 1`, `set -e` abort, Ctrl-C). It is the only reliable way to guarantee temp files disappear.

## 💻 Syntax & Minimal Example

```bash
#!/bin/bash
set -euo pipefail

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

# Branch directly on the command's exit status
if ping -c 1 -W 1 "$1" > /dev/null 2>&1; then
    echo "$1 is reachable"
else
    echo "$1 is unreachable" >&2
    exit 2
fi

# Chaining
systemctl is-active --quiet nginx && echo "nginx up" || echo "nginx down"
```

## ⚠️ Common Pitfalls (The "Gotchas")

- **`((n++))` under `set -e`:** the arithmetic command returns the value of the expression *before* the increment. When `n` is 0 that is a false exit status and `set -e` aborts the script on the first iteration. Use `n=$((n + 1))`.
- **`&& ... ||` is not if/else:** in `a && b || c`, `c` also runs when `b` fails. Use a real `if` when `b` can fail.
- **Error message without `exit 1`:** printing to stderr and continuing returns 0 to the caller, so a cron job or CI step reports success.
- **`set -e` is ignored inside `if cmd`, `cmd || ...`, and `cmd && ...`:** that is by design; those contexts are the places you *want* a non-zero status.

## 🔗 Connections (Mental Mapping)

- **Where pipeline output goes:** [[Shell Plumbing]]
- **Temp files and atomic writes that rely on `trap`:** [[Bash File Operations]]
- **Signals behind `trap`:** [[Process Control]]

## ⚡ Active Recall Flashcards

How do you check the exit status of the previous command in Bash?::`$?` (`0` indicates success; `1` to `255` indicates an error)
<!--SR:!fsrs,2026-09-10T14:32:02.628Z,7,7.31530068,2.11121424,2,2,0,0,2026-09-03T14:32:02.628Z-->

Why can a failed command inside a pipeline (e.g. missing_file | wc -l) falsely report success ($? = 0), and how do you fix it?::By default $? only checks the exit status of the last command; fixed by enabling `set -o pipefail` so any stage failure causes the entire pipeline to fail

A script creates a temp file; how do you guarantee it is removed even if the script aborts under `set -e` or is interrupted?::`trap 'rm -f "$tmp"' EXIT` right after creating it; the EXIT trap fires on every exit path
