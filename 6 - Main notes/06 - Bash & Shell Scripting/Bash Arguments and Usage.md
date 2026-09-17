---
date: 2026-09-12 10:00
tags:
  - flashcards/linux/bash
  - linux
  - bash
  - scripting
---
# Bash Arguments and Usage

Drill skill: `args` in [[Drills - Bash]]. Hub: [[Bash]].

## 🧠 The Core Concept

A script receives its inputs as **positional parameters**. The job of the first lines of any script is to validate them, print a usage line when they are wrong, and pass them on intact.

| Parameter | Meaning & Expansion | Production Best Practice |
| :--- | :--- | :--- |
| **`$0`** | Name of the executing script or function | Use in usage banners: `echo "Usage: $0 <target>"` |
| **`$1`, `$2` ...** | First, second positional argument | Enclose multi-digit arguments in braces: `${10}` |
| **`$#`** | Total number of arguments passed | Validate inputs: `if [[ "$#" -ne 2 ]]; then ... fi` |
| **`$@`** | Expands each argument as a **separate quoted string** (`"$1" "$2"`) | **Always prefer `"$@"`** when forwarding arguments to sub-commands |
| **`$*`** | Collapses all arguments into a **single string** (`"$1 $2"`) | Avoid for arrays/lists; breaks on arguments containing spaces |

## 💻 Syntax & Minimal Example

```bash
#!/bin/bash
# Exactly two arguments, usage to stderr, non-zero exit on bad input
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <source> <destination>" >&2
    exit 1
fi

src="$1"
dst="$2"
echo "copying $src to $dst"

# Forward every argument, quoting preserved
rsync -a "$@"
```

## ⚠️ Common Pitfalls (The "Gotchas")

- **`$*` vs `"$@"`:** `$*` joins the arguments into one word, so `"error log.txt"` becomes two arguments downstream. `"$@"` re-quotes each one.
- **One check, not two:** `-ne` covers both too few and too many arguments. Separate `-lt` and `-gt` branches duplicate the same message.
- **Unquoted `$1`:** word-splits and glob-expands. Always `"$1"`.
- **Usage goes to stderr** (`>&2`) so a caller capturing stdout does not swallow it.

## 🔗 Connections (Mental Mapping)

- **Exit codes and strict mode:** [[Bash Exit Status and Strict Mode]]
- **Testing the arguments:** [[Bash Conditionals]]
- **Standard streams:** [[Shell Plumbing]]

## ⚡ Active Recall Flashcards

Why should you forward arguments with `"$@"` and not `$*`?::`"$@"` re-quotes each argument separately; `$*` collapses them into one string and breaks on arguments containing spaces

A script needs exactly two arguments; write the one-line guard that prints a usage line with `$0` to stderr and exits 1::`[[ $# -ne 2 ]] && { echo "Usage: $0 <src> <dst>" >&2; exit 1; }`
