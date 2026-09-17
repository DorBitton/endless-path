---
date: 2026-08-21 20:07
tags:
  - flashcards/linux/journalctl
  - cli
  - linux
  - infrastructure
  - troubleshooting
---
# journalctl

## 🧠 The Core Concept (In My Own Words)
- **What is it?** `journald` is the background system daemon capturing logs (boot messages, kernel events, unit outputs). `journalctl` is the CLI tool used to query, filter, and stream those logs.
- **Why does it matter?** It centralizes logging into a single structured queryable database instead of hunting through isolated `/var/log` text files.

## 🛠️ Real-World Application & Troubleshooting
- **Production Usage:** The primary log tool when debugging unit crashes or boot failures.
- **The Persistence Gotcha:** By default on many distributions, `journald` logs are volatile (stored in RAM at `/run/log/journal`). If the machine reboots after a crash, all logs prior to the reboot are lost.
- **Fixing Log Persistence:**
  Edit `/etc/systemd/journald.conf`:
  ```ini
  [Journal]
  Storage=persistent
  ```
  Then restart the service: `sudo systemctl restart systemd-journald`.

## 💻 Commands, Syntax & Code
- `journalctl -u <unit>`: Filter logs for a specific unit (e.g. `journalctl -u nginx.service`).
- `journalctl -u <unit> -f`: Follow/tail logs in real-time for a specific service.
- `journalctl -xe`: Show recent logs with explanatory catalog descriptions (`-x`) jumped straight to the bottom (`-e`).
- `journalctl -b`: Show logs from the current boot only.
- `journalctl -b -1`: Show logs from the previous boot (requires persistent storage).
- `journalctl -b -1 -p err`: View errors only from the previous boot (post-mortem crash analysis).
- `journalctl --list-boots`: List all recorded boots with index, Boot ID, and timestamps.
- `journalctl -p err`: Filter by priority level (`err`, `warning`, `info`).
- `journalctl -n 50 --no-pager`: Show last 50 lines without opening a pager.

## 🔗 Connections
- **Related to:** [[systemd]], [[systemctl]], [[Daemons]]
- **Troubleshooting Link:** `systemctl status <service>` tells you a service failed; `journalctl -u <service>` provides the stack trace / error details.

## ⚡ Active Recall Flashcards
A service keeps crashing and you want to watch its log live while you restart it. Command?::`journalctl -u <unit> -f`

You need only this boot's messages, then the ones from the boot before the crash. Flags?::`-b` for the current boot, `-b -1` for the previous one (needs persistent storage)

Why do `journald` logs get lost after a server crash/reboot by default?::Stored in volatile RAM at `/run/log/journal`
<!--SR:!fsrs,2026-09-21T14:14:11.732Z,21,20.90649188,5.09241299,2,3,0,0,2026-08-31T14:14:11.732Z-->

In `/etc/systemd/journald.conf`, what setting makes logs persist across reboots?::`Storage=persistent`
<!--SR:!fsrs,2026-09-23T14:14:04.535Z,23,22.76818035,2.11121424,2,2,0,0,2026-08-31T14:14:04.535Z-->

The journal is too noisy and you want only errors and worse. Flag?::`-p err`

Why is `journalctl -xe` the reflex right after `systemctl status` shows a failure?::`-e` jumps to the newest entries, `-x` adds systemd catalog explanations for known error messages