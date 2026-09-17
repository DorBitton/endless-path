---
date: 2026-08-21 14:07
tags:
  - flashcards/linux/systemctl
  - linux
  - infrastructure
  - cli
---
# systemctl

## 🧠 The Core Concept (In My Own Words)
- **What is it?** `systemctl` is the primary command-line tool used to inspect the state of and manage configuration for [[systemd units]].
- **Why does it matter?** It is the primary steering wheel for the Linux operating system. When any service misbehaves, `systemctl` is the first command to check state and control service lifecycles.

## 🛠️ Real-World Application & Troubleshooting
- **The `daemon-reload` trap:** The most common human error. If you edit a unit file in `/etc/systemd/system/` and run `systemctl restart <service>`, it will either fail or run the old config. You **must** run `sudo systemctl daemon-reload` first so systemd parses the modified file.
- **Reload vs. Restart (Zero Downtime):**
  - `systemctl restart <unit>`: Stops and starts the process (drops active connections, brief downtime).
  - `systemctl reload <unit>`: Instructs running process to re-read config without dropping active connections (requires `ExecReload=` support in the unit file).
- **Hanging services:** When a service refuses to shut down gracefully and `systemctl stop` hangs, force-kill it immediately: `sudo systemctl kill --signal=KILL <service>`.

### Debugging Flow
1. Run `systemctl status <service>` to see *that* it failed (or `systemctl list-units --failed`).
2. Run `journalctl -u <service> -n 50` to find *why* it failed.

## 💻 Commands, Syntax & Code
Syntax: `sudo systemctl <subcommand> <service-name>`

| Command | What it does in plain English |
| --- | --- |
| `status <unit>` | Checks if a service is running and shows the last few log lines |
| `start` / `stop` / `restart <unit>` | Basic service lifecycle management |
| `reload <unit>` | Reloads daemon config with zero downtime (if supported by unit) |
| `enable` / `disable <unit>` | Sets whether service starts automatically at boot |
| `enable --now <unit>` | Enables for boot AND starts the service immediately |
| `is-active` / `is-enabled <unit>` | Returns status text & exit code 0/1 (great for bash scripts) |
| `daemon-reload` | Forces systemd to re-read unit files from disk |
| `list-units --type=service --state=failed` | Lists all failed services across the system |
| `isolate <target>` | Switches system mode (e.g. `systemctl isolate multi-user.target`) |

## 🔗 Connections
- **Related to:** [[systemd]] (the core architecture), [[journalctl]] (the log viewer), [[systemd targets]]
- **Analogy:** If `systemd` is the Kubernetes API server, `systemctl` is `kubectl`.

## ⚡ Active Recall Flashcards
After editing a unit file in `/etc/systemd/system/`, what command must you run before restarting?::`sudo systemctl daemon-reload`
<!--SR:!fsrs,2026-08-26T08:26:06.949Z,0,2.3065,2.11810397,1,1,0,1,2026-08-26T08:16:06.949Z-->

`systemctl stop` hangs on a service that refuses to exit. How do you force it down?::`sudo systemctl kill --signal=KILL <service>`

Command to list all systemd services across the system that are currently crashed/failed::`systemctl list-units --failed`
<!--SR:!fsrs,2026-08-26T08:26:57.401Z,0,2.3065,2.11810397,1,1,0,1,2026-08-26T08:16:57.401Z-->

Command to enable a systemd service for boot AND start it immediately in one step::`sudo systemctl enable --now <service>`
<!--SR:!fsrs,2026-08-26T08:26:42.193Z,0,2.3065,2.11810397,1,1,0,1,2026-08-26T08:16:42.193Z-->

What is the relationship between `systemctl` and `journalctl` during troubleshooting?::`systemctl status` shows *that* a service failed; `journalctl -u` shows *why* it failed
<!--SR:!fsrs,2026-08-26T08:26:24.001Z,0,2.3065,2.11810397,1,1,0,1,2026-08-26T08:16:24.001Z-->

How to apply configuration changes to a running service without dropping client connections?::`sudo systemctl reload <service>`


