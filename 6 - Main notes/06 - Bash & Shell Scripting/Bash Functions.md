---
date: 2026-09-12 10:00
tags:
  - flashcards/linux/bash
  - linux
  - bash
  - scripting
---
# Bash Functions

Drill skill: `functions` in [[Drills - Bash]]. Hub: [[Bash]].

## 🧠 The Core Concept

- **Scope:** every variable in Bash is global unless declared `local` inside the function. A function that sets `target="tmp"` overwrites `$target` in the calling script.
- **Two ways to give something back:**
  - `return N` sets the exit status (`0` to `255`). It is for success/failure, tested with `if my_func; then`.
  - `echo` writes data to stdout. The caller captures it with `result=$(my_func)`.
- **A function is a command:** it receives `$1`, `$2`, `$#`, `"$@"` like a script, and its exit status is that of the last command run (or the explicit `return`).

## 💻 Syntax & Minimal Example

```bash
check_node_health() {
    # Always declare variables as local inside functions!
    local node_ip="$1"
    local ping_timeout=2

    ping -c 1 -W "$ping_timeout" "$node_ip" > /dev/null 2>&1
    # No explicit return needed: the function's status is ping's status
}

# Calling the function inside if: tests the exit status directly
if check_node_health "192.168.1.50"; then
    echo "Node is healthy."
else
    echo "Node unreachable!"
fi

# Returning data: echo it, capture with $( )
disk_used_pct() {
    local mount="${1:-/}"
    df --output=pcent "$mount" | tail -n 1 | tr -dc '0-9'
}
used=$(disk_used_pct /var)
echo "/var is at ${used}%"
```

## ⚠️ Common Pitfalls (The "Gotchas")

- **Function Global Namespace Pollution:** forgetting `local` silently overwrites caller variables with the same name. Always `local var_name="value"` inside function bodies.
- **`return "some string"`:** `return` only takes an integer; anything else errors. Use `echo` plus command substitution for data.
- **`local x=$(cmd)` hides the exit status of `cmd`:** the status of the line is that of `local`, which is 0. Split it: `local x; x=$(cmd)`.
- **Printing debug output in a function whose output is captured** corrupts `$(...)`. Send diagnostics to stderr (`>&2`).

## 🔗 Connections (Mental Mapping)

- **Exit status semantics:** [[Bash Exit Status and Strict Mode]]
- **Arguments inside a function:** [[Bash Arguments and Usage]]
- **stdout vs stderr:** [[Shell Plumbing]]

## ⚡ Active Recall Flashcards

What happens to a variable assigned inside a Bash function without `local`?::It is global and overwrites any same-named variable in the calling script
<!--SR:!fsrs,2026-09-13T09:39:39.336Z,8,8.2956,1,2,1,0,0,2026-09-05T09:39:39.336Z-->

Write a Bash function `check_node` that pings its first argument once with a 2 second timeout, then call it in an `if`/`else` that prints healthy or unreachable
?
```bash
check_node() {
  local ip="$1"
  ping -c 1 -W 2 "$ip" > /dev/null 2>&1
}
if check_node "$1"; then echo "healthy"; else echo "unreachable"; fi
```
<!--SR:!fsrs,2026-09-05T09:42:48.092Z,0,2.3065,2.11810397,1,1,0,1,2026-09-05T09:32:48.092Z-->

How does a Bash function hand a string back to its caller, given that `return` only accepts an integer?::It `echo`es the value and the caller captures it with `result=$(my_func)`; `return N` is only the exit status
