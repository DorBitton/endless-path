---
date: 2026-09-12 10:00
tags:
  - flashcards/linux/bash
  - linux
  - bash
  - scripting
---
# Bash Conditionals

Drill skill: `conditionals` in [[Drills - Bash]]. Hub: [[Bash]].

## 🧠 The Core Concept

- **`[[ ... ]]`** is the Bash test keyword: no word splitting inside, supports `&&`, `||`, `==` with globs and `=~` with regex. Prefer it over `[ ]` in Bash scripts.
- **String vs integer tests:** `==` / `!=` / `<` compare strings; `-eq` / `-ne` / `-lt` / `-gt` compare integers. Mixing them errors or silently compares the wrong thing.
- **File tests** (`-f`, `-d`, `-e`, `-r`, `-w`) are conditionals too; the full table lives in [[Bash File Operations]].
- **`case`** dispatches on one value against glob patterns, with `|` for alternation and `*)` as the default branch. Cleaner than an `if`/`elif` ladder for command-style scripts.

## 💻 Syntax & Minimal Example

```bash
# 1. If / Elif / Else with Case-Insensitive Matching (${1,,})
user_role="${1,,}"  # Convert input to lowercase before testing

if [[ "$user_role" == "admin" || "$user_role" == "root" ]]; then
    echo "Access granted: Administrator role detected."
elif [[ "$user_role" == "viewer" ]]; then
    echo "Access granted: Read-only permissions."
else
    echo "Access denied: Unknown role '$1'."
    exit 1
fi

# 2. Case Statement (Multi-branch pattern matching)
case "${1,,}" in
    start|run)
        echo "Starting daemon..."
        ;;
    stop|kill)
        echo "Stopping daemon..."
        ;;
    status)
        echo "Checking daemon health..."
        ;;
    *)
        echo "Usage: $0 {start|stop|status}"
        exit 1
        ;;
esac

# 3. Path type check, error to stderr
path="$1"
if [[ -f "$path" ]]; then
    echo "regular file"
elif [[ -d "$path" ]]; then
    echo "directory"
else
    echo "no such path: $path" >&2
    exit 1
fi
```

## ⚠️ Common Pitfalls (The "Gotchas")

- **`-eq` on strings:** integer-only, errors with "integer expression expected". Use `=` / `!=` for strings.
- **`[ $var == x ]` with an empty `$var`** collapses to `[ == x ]` and errors. `[[ ]]` does not split, but quote anyway for consistency.
- **Missing `;;`** in `case` falls through to the next branch's commands.
- **Forgetting the `*)` default** means unknown input silently does nothing and exits 0.

## 🔗 Connections (Mental Mapping)

- **Exit codes the tests rely on:** [[Bash Exit Status and Strict Mode]]
- **File tests in depth:** [[Bash File Operations]]
- **Argument validation:** [[Bash Arguments and Usage]]

## ⚡ Active Recall Flashcards

In a Bash test, what goes wrong if you compare two strings with `-eq`?::`-eq` is integer-only and errors with "integer expression expected"; use `=` / `!=` for strings, `-eq` / `-lt` / `-gt` for numbers
<!--SR:!fsrs,2026-09-13T09:29:10.922Z,8,8.2956,1,2,1,0,0,2026-09-05T09:29:10.922Z-->

Write a Bash `case` block that dispatches on `$1`: `start`, `stop` (with `kill` as an alias), `status`, and otherwise prints a usage line with `$0` and exits 1
?
```bash
case "$1" in
  start)      echo "Starting" ;;
  stop|kill)  echo "Stopping" ;;
  status)     echo "Checking" ;;
  *)          echo "Usage: $0 {start|stop|status}"; exit 1 ;;
esac
```
<!--SR:!fsrs,2026-09-13T08:49:07.964Z,7,7.31530068,2.11121424,2,2,0,0,2026-09-06T08:49:07.964Z-->
