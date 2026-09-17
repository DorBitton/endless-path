---
date: 2026-09-12 10:00
tags:
  - flashcards/linux/bash
  - linux
  - bash
  - scripting
  - sre
---
# Service Checks in Bash

Drill skill: `services` in [[Drills - Bash]]. Hub: [[Bash]].

> [!warning] Stub
> Written during the Bash reorganisation from what [[systemctl]] and [[Process Control]] already say. Needs a ping-pong session before it earns flashcards.

## 🧠 The Core Concept

- **Ask the supervisor, not the process list, when there is one:** `systemctl is-active --quiet <unit>` returns exit status 0 when the unit is running. That is the check for anything systemd manages.
- **Fall back to the process table for unmanaged daemons:** `pgrep -x <name>` exits 0 when a process with exactly that name exists. `-x` matches the whole name so `sshd` does not match `sshd-agent`.
- **A restart script must be idempotent and must leave a trace:** check, act only when down, log what it did with a timestamp.

## 💻 Syntax & Minimal Example

```bash
#!/bin/bash
set -euo pipefail

unit="${1:?usage: $0 <unit>}"
log="/var/log/watchdog.log"

if systemctl is-active --quiet "$unit"; then
    exit 0
fi

echo "$(date '+%F %T') $unit is down, restarting" >> "$log"
if systemctl restart "$unit"; then
    echo "$(date '+%F %T') $unit restarted" >> "$log"
else
    echo "$(date '+%F %T') $unit restart FAILED" >> "$log"
    exit 1
fi

# Unmanaged daemon variant
if ! pgrep -x myagent > /dev/null; then
    /opt/myagent/bin/start
fi
```

## ⚠️ Common Pitfalls (The "Gotchas")

- **`pgrep <name>` without `-x`** substring-matches and can find the watchdog script itself when the script name contains the daemon name.
- **`ps aux | grep name`** matches the `grep` process too; the classic `grep [n]ame` trick or `pgrep` avoids it.
- **Restart loops:** a service that fails on start will be restarted every run. Log every action so the loop is visible, and consider `systemctl reset-failed` and the unit's own `Restart=` policy first.

## 🔗 Connections (Mental Mapping)

- **The commands behind the check:** [[systemctl]], [[Process Control]]
- **Where to run it periodically:** [[Cron]]
- **Exit codes the check relies on:** [[Bash Exit Status and Strict Mode]]

## ⚡ Active Recall Flashcards

%% No cards yet: stub note, cards come after a ping-pong session or a drill miss. %%
