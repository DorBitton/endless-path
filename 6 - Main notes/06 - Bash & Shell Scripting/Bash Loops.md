---
date: 2026-09-12 10:00
tags:
  - flashcards/linux/bash
  - linux
  - bash
  - scripting
---
# Bash Loops

Drill skill: `loops` in [[Drills - Bash]]. Hub: [[Bash]].

## 🧠 The Core Concept

- **`for` over a list:** `for x in "${arr[@]}"` visits every element with quoting preserved. `for f in "$dir"/*` visits files (a glob, not `ls` output).
- **`while read` over a file:** `while IFS= read -r line; do ...; done < "$file"` reads one line per iteration. `IFS=` keeps leading and trailing whitespace, `-r` keeps backslashes literal.
- **Where the input comes in decides where variables live:** redirecting into the loop (`done < file`) keeps the loop in the current shell. Piping into it (`cat file | while ...`) runs the loop in a subshell and every variable set inside is lost afterwards.
- **Counters:** `count=$((count + 1))` is safe under `set -e`; `((count++))` is not when the value is 0 (see [[Bash Exit Status and Strict Mode]]).

## 💻 Syntax & Minimal Example

```bash
# 1. For Loop over Array Elements
servers=("node-01" "node-02" "node-03")
for server in "${servers[@]}"; do
    echo "Checking ping to: $server"
done

# 2. While Loop: read a file line by line, counter survives the loop
count=0
while IFS= read -r line || [[ -n "$line" ]]; do
    count=$((count + 1))
    echo "$count: $line"
done < "$file"
echo "total: $count"

# 3. Whole file into an array (one element per line)
mapfile -t lines < "$file"
echo "Total lines: ${#lines[@]}"
echo "Last line: ${lines[-1]}"

# 4. Delimited data: split fields on the delimiter
while IFS=':' read -r username _ uid gid _ home shell; do
    echo "User: $username, UID: $uid, Shell: $shell"
done < /etc/passwd

# 5. Filenames with spaces or newlines: NUL-delimited find
while IFS= read -r -d '' path; do
    echo "Found: $path"
done < <(find "$dir" -name '*.log' -type f -print0)
```

## ⚠️ Common Pitfalls (The "Gotchas")

- **The Piped `while` Loop Subshell Variable Loss:** `cat file.txt | while read -r line; do count=$((count+1)); done` runs the loop in a subshell; `$count` disappears when it terminates. Fix: redirect at the loop boundary, `done < file.txt`.
- **The Array Expansion Pitfall (`$arr` vs `"${arr[@]}"`):** `$my_array` expands only index `0`. Always `"${my_array[@]}"`.
- **Last line without a trailing newline:** `read` returns non-zero on it, so a plain `while read` drops it. `|| [[ -n "$line" ]]` still processes that partial line.
- **`for f in $(ls)` and `for f in $(cat file)`:** word-split on spaces, so one filename or line with a space becomes two iterations. Use a glob or `while read`.
- **Off-by-one on numbered output:** increment before printing if the first line should be 1.

## 🔗 Connections (Mental Mapping)

- **Why the pipe makes a subshell:** [[Shell Plumbing]], [[Process Control]]
- **Reading files safely:** [[Bash File Operations]]
- **Counters under strict mode:** [[Bash Exit Status and Strict Mode]]

## ⚡ Active Recall Flashcards

Why does `$arr` expand to a single element, and what is the correct form?::Bare `$arr` is index 0 only; `"${arr[@]}"` expands every element with quoting and spaces preserved
<!--SR:!fsrs,2026-09-06T08:59:18.892Z,0,1.21921728,7.60420977,1,2,0,0,2026-09-06T08:53:18.892Z-->

Why does a counter incremented inside `cat file | while read line ...` end up unchanged after the loop?::The pipe runs the `while` in a subshell, so its variables vanish; use `while read -r line; do ...; done < file` instead
<!--SR:!fsrs,2026-09-13T08:53:10.567Z,7,7.31530068,2.11121424,2,2,0,0,2026-09-06T08:53:10.567Z-->

Read `/var/log/syslog` line by line and count the lines containing `error`; the count must be correct after the loop ends
?
```bash
count=0
while read -r line; do
  [[ "$line" == *error* ]] && count=$((count + 1))
done < /var/log/syslog
echo "$count"
```
<!--SR:!fsrs,2026-09-06T09:02:50.923Z,0,4.54602939,5.10228691,1,2,0,1,2026-09-06T08:52:50.923Z-->

Why add `|| [[ -n "$line" ]]` to a `while IFS= read -r line` loop?::`read` returns non-zero on a final line with no trailing newline, so the loop would skip it; the extra test still processes that partial line
