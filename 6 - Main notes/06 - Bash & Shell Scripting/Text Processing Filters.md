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
# Text Processing Filters

Drill skill: `text` in [[Drills - Bash]]. Hub: [[Bash]].

## 🧠 The Core Concept

Filters are small programs that read stdin, transform it, and write stdout. Chained on a pipe ([[Shell Plumbing]]) they answer triage questions in one line: "which IP hits us most", "how many errors in the last hour", "flip this config flag in place".

- **`awk`:** A pattern-scanning language built for column extraction. Treats runs of whitespace as one delimiter, so it copes with `ps aux` and `df -h` output.
- **`sed`:** A stream editor for filtering and transforming text with regular expressions (find and replace, delete lines).
- **`grep`, `cut`, `sort`, `uniq`, `wc`, `head`, `tail`:** the counting and trimming toolkit.

---

## 💻 Syntax & Reference

### 1. Core Triage Filter Reference

| Filter Command | Primary Flags | Purpose in Incident Triage |
| :--- | :--- | :--- |
| **`cut`** | `-d':' -f1,3` | Cuts delimited text columns (best for clean files like `/etc/passwd`). |
| **`sort`** | `-n` (numeric), `-r` (reverse), `-k2` (column), `-h` (human sizes) | Orders lines so identical values become adjacent. |
| **`uniq`** | `-c` (count), `-d` (duplicates only) | Collapses consecutive matching lines and reports counts. |
| **`wc`** | `-l` (line count), `-c` (byte count) | Counts lines or volume of data flowing through pipe. |
| **`head` / `tail`** | `-n 10`, `tail -f` (follow live) | Trims top/bottom lines, or streams live appended logs. |
| **`grep`** | `-i` (case-insensitive), `-v` (invert), `-c` (count), `-E` (regex) | Filters lines matching a text pattern. |

### 2. `awk`: Column & Field Extraction

```bash
# 1. Extract 1st and 11th columns separated by default whitespace
ps aux | awk '{print $1, $11}'

# 2. Extract fields using custom delimiter (-F)
awk -F':' '{print "User: "$1, "Home: "$6}' /etc/passwd

# 3. Filter rows based on numeric column conditions
ps -eo pid,%cpu,comm | awk '$2 >= 90.0 {print "High CPU Process: "$3, "Usage: "$2"%"}'
```

### 3. `sed`: Stream Editing & In-Place Replacement

$$\Large \text{sed } \text{'}\mathbf{s}\text{/}\underbrace{\text{pattern}}_{\text{Find}}\text{/}\underbrace{\text{replacement}}_{\text{Replace}}\text{/}\mathbf{g}\text{'} \ \text{file.txt}$$

- **`s` (Substitute):** Instructs `sed` to perform a substitution operation.
- **`g` (Global):** Replace **every** occurrence on each line (without `g`, only the *first* occurrence per line is replaced).
- **Alternative Delimiters:** Avoid escaping file paths with backslashes (`\/`) by using `#` or `|`:
  `sed 's#/var/log#/opt/backup/log#g' config.yaml`

```bash
# 1. Global substitution across text
echo "apple pie, apple tart, apple cider" | sed 's/apple/cherry/g'
# Output: cherry pie, cherry tart, cherry cider

# 2. In-Place Edit with Automatic Backup (-i.bak)
sed -i.bak 's/debug: true/debug: false/g' config.yaml

# 3. Delete matching lines (/pattern/d)
sed '/^#/d' /etc/hosts    # Prints file with comment lines deleted

# 4. Print a line range or a single line
sed -n '10,20p' /var/log/syslog
sed -n '15p' /var/log/syslog
```

### 4. Golden SRE Triage Recipes

```bash
# 1. Top 5 Most Frequent IP Addresses from Access Log
cut -d' ' -f1 access.log | sort | uniq -c | sort -nr | head -n 5

# 2. Filter out healthcheck noise during live incident debugging
tail -f /var/log/nginx/access.log | grep -v "GET /healthz"

# 3. Count total active TCP connections in TIME_WAIT
ss -tan | grep TIME-WAIT | wc -l
```

---

## ⚠️ Common Pitfalls & SRE Gotchas

- **The `cut` Multiple-Space Trap:** `cut -d' ' -f2` treats consecutive spaces as multiple empty delimiters, failing on tabular text (like `ps aux` or `df -h`). Use `awk '{print $2}'` or `tr -s ' '` to collapse variable whitespace.
- **The `uniq` Sorting Requirement:** `uniq` only checks adjacent lines. If identical entries are scattered throughout the file, `uniq -c` counts them as separate groups unless the input is sorted first.
- **`sed -i` Portability Gotcha (Linux GNU vs macOS BSD):** GNU `sed` allows `sed -i "s/a/b/g" file`; BSD `sed` requires an explicit extension argument (`sed -i "" ...`). Cross-platform habit: always give a backup extension, `sed -i.bak "s/a/b/g" file`.
- **`grep -c` counts lines, not matches:** two hits on one line count once. Use `grep -o pattern | wc -l` for occurrences.

---

## 🔗 Connections (Mental Mapping)

- **The pipe these filters sit on:** [[Shell Plumbing]]
- **Editing files safely (atomic write instead of `sed -i` on live configs):** [[Bash File Operations]]
- **Disk and log triage:** [[Runaway Processes]], [[Logrotate]]

---

## ⚡ Active Recall Flashcards

Why must output be passed through sort before running uniq -c?::uniq only detects and collapses adjacent matching lines; unsorted duplicates across different lines are not counted together

Why does `cut -d' ' -f2` return the wrong column on `ps aux` or `df -h` output, and what do you use instead?::`cut` counts every space as a delimiter, so runs of spaces produce empty fields; use `awk '{print $2}'`, which collapses whitespace
