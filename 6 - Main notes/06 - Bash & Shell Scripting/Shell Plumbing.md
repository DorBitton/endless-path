---
date: 2026-09-12 10:00
tags:
  - flashcards/linux/bash
  - linux
  - bash
  - shell
  - triage
  - sre
---
# Shell Plumbing

Drill skill: `plumbing` in [[Drills - Bash]]. Hub: [[Bash]].

## 🧠 The Core Concept

- **The Three Standard Streams (File Descriptors 0, 1, 2):** Every Linux process starts with three default I/O channels inherited from its parent:
  - **`0` (`stdin`):** Standard input (keyboard stream or incoming piped data).
  - **`1` (`stdout`):** Standard output (regular program messages).
  - **`2` (`stderr`):** Standard error (error diagnostics and failure traces).
- **The Wire / Pointer Analogy:** Redirections (`<`, `>`, `>>`, `2>&1`) act like moving audio patch cables between standard streams and files. The shell processes redirections strictly **from left to right**.
- **Pipelines (`|`):** Connects the standard output (`stdout`) of one process directly to the standard input (`stdin`) of the next process via a kernel RAM buffer. No temporary files are created on disk. Each side of the pipe is its own process, which is why a `while` loop fed by a pipe runs in a subshell (see [[Bash Loops]]).

```mermaid
graph LR
    subgraph Process Standard Streams
        I["stdin (0)"] --> P["Running Process"]
        P --> O["stdout (1)"]
        P --> E["stderr (2)"]
    end
    subgraph Redirection & Pipe
        O -->|Pipe \| | P2["Next Process (stdin 0)"]
        E -->|2>&1| O
        O -->|> or >>| F["Log File on Disk"]
    end
```

---

## 💻 Syntax & Reference

### 1. Redirection Cheatsheet

| Syntax | Stream / Action | Mechanism / Real-World Meaning |
| :--- | :--- | :--- |
| `< file` | `0 < file` | Redirects file content into `stdin`. |
| `> file` | `1 > file` | Overwrites `stdout` to `file` (truncates file to 0 bytes first). |
| `>> file` | `1 >> file` | Appends `stdout` to the end of `file`. |
| `2> file` | `2 > file` | Redirects `stderr` errors to `file`. |
| `> file 2>&1` | Both streams | Unplugs `stdout` to file, then points `stderr` to `stdout` (all output captured). |
| `&> file` | Both streams | Bash shorthand for `> file 2>&1`. |
| `2> /dev/null` | Discard errors | Sends error messages to the kernel bit bucket. |
| `cmd < <(other)` | Process substitution | Feed `other`'s output as a file, without a pipe (the loop stays in the current shell). |

### 2. Here-Docs (`<<`) and Here-Strings (`<<<`)

```bash
# 1. Here-Doc (<<EOF): Pass multi-line text blocks directly to a command
cat << EOF > /etc/motd
========================================
 Welcome to Production Node: $(hostname)
 Managed by SRE Automation
========================================
EOF

# 2. Quoted delimiter ('EOF'): variables are NOT expanded, text is literal
cat > /tmp/template.txt << 'EOF'
Hello, $USER is printed literally here
EOF

# 3. Here-String (<<<): Feed a single string variable directly into stdin
grep "FAIL" <<< "$service_status"
wc -w <<< "three words count"
```

### 3. `tee`: split a stream

```bash
# Write to a file while still passing to stdout
./deploy.sh 2>&1 | tee deploy.log

# Append instead of overwrite
echo "Appended message" | tee -a /var/log/app.log

# Safely write to a root-protected file without permission denied
echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf > /dev/null
```

---

## ⚠️ Common Pitfalls & SRE Gotchas

- **The Redirection Order Trap (`> file 2>&1` vs `2>&1 > file`):**
  - `> file 2>&1` works because `stdout` is pointed to the file first, and `stderr` is then pointed to `stdout` (the file).
  - `2>&1 > file` fails because `stderr` is pointed to wherever `stdout` was pointing *at that instant* (the screen), before `stdout` is redirected to the file. Error messages still leak onto the terminal.
- **The Word Splitting Blast Radius:**
  - Running `rm $target` when `target="error log backup.txt"` causes the shell to split arguments on spaces, deleting three separate files: `error`, `log`, and `backup.txt`.
  - Always quote variable expansions: `rm "$target"`.
- **The `sudo >` Redirection Trap:**
  - Running `sudo echo "..." > /etc/protected.conf` fails with `Permission denied` because redirection is set up by the current unprivileged shell *before* `sudo` executes.
  - Fix: Pipe to `sudo tee`: `echo "..." | sudo tee /etc/protected.conf`.
- **Pipeline exit status:** `$?` reports only the last command in a pipeline. The mechanism and the `pipefail` fix live in [[Bash Exit Status and Strict Mode]].

---

## 🔗 Connections (Mental Mapping)

- **Process Memory & File Descriptors:** [[Process Control]]
- **Security & Privilege Boundaries:** [[Access Control and Rootly Powers]]
- **Filesystem Permissions:** [[Filesystem Hierarchy and Permissions]]
- **The filters that sit on the pipe:** [[Text Processing Filters]]
- **Exit codes through a pipe:** [[Bash Exit Status and Strict Mode]]

---

## ⚡ Active Recall Flashcards

Why does cmd 2>&1 > file.log still print error messages to the terminal screen instead of writing them to the file?::Redirections evaluate left-to-right; Wire 2 is copied to Wire 1 while Wire 1 is still pointing to the screen, before Wire 1 gets redirected to the file

Why does sudo echo "foo" > /etc/privileged.conf fail with Permission Denied, and how is it fixed?::The current unprivileged shell sets up file redirection before sudo executes; fixed by piping to elevated tee (echo "foo" | sudo tee /etc/privileged.conf)

What dangerous shell behavior happens if you pass an unquoted variable containing spaces (e.g. rm $filename)?::The shell performs word splitting, expanding each space-separated word into a distinct positional argument
