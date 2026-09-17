---
date: 2026-08-21 12:38
tags:
  - flashcards/linux/systemd
  - infrastructure
  - concepts
  - linux
---
# systemd

## 🧠 The Core Concept (In My Own Words)
- **What is it?** systemd is an init system and service supervisor—a unified suite of tools managing the lifecycle of system entities known as **Units** ([[systemd units]]).
- [[systemctl]] is the primary command-line tool used to interact with and control systemd.

### 🚦 Unit Lifecycle States
When querying units via `systemctl status`, systemd reports the state:
- `active (running)`: Healthy and running.
- `activating`: Executing startup commands or waiting on dependencies.
- `inactive (dead)`: Stopped cleanly; not running.
- `failed`: Process crashed, returned an error exit code, or exceeded start rate limits.

### 📂 Where do Unit files live?
Understanding these two primary paths prevents configuration loss during package upgrades:
1. `/usr/lib/systemd/system/`: Default unit files provided by installed packages (e.g. `apt install nginx`).
2. `/etc/systemd/system/`: Local system administrator customizations and unit overrides.

> **Rule of Priority:** systemd reads `/etc/` before `/usr/lib/`. Customizations and service unit files should **always** go into `/etc/systemd/system/` so package updates won't overwrite them.

## 💻 Real-World Example: The Unit File
Every unit is defined in an INI-style file (e.g. `rsync.service`):

```ini
[Unit]
Description=fast remote file copy program daemon
ConditionPathExists=/etc/rsyncd.conf
After=network.target

[Service]
ExecStart=/usr/bin/rsync --daemon --no-detach
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

**Section Breakdown:**
- **`[Unit]`**: Metadata, description, and prerequisites (e.g., abort startup if `/etc/rsyncd.conf` does not exist; `After=` ordering).
- **`[Service]`**: Execution behavior, binary path, daemon parameters, and restart policies.
- **`[Install]`**: Boot wiring. `WantedBy=multi-user.target` tells systemd to automatically start this service when reaching multi-user (CLI) mode.

### 🔄 Service Restart Policies (`[Service]`)
- `Restart=no` (default): Never restart automatically.
- `Restart=on-failure`: Restart only if exit code != 0 or killed by an abnormal signal (Production standard).
- `Restart=always`: Always restart, even after a clean shutdown (exit code 0).
- `RestartSec=5s`: Delay before attempting restart to prevent rapid crash loops.

## 🔗 Connections
- **Related to:** [[Daemons]], [[systemd targets]], [[systemctl]], [[journalctl]], [[systemd units]]
- **Why linked:** The `[Install]` block binds the service to a [[systemd targets|Target]] that defines system boot targets.

## ⚡ Active Recall Flashcards
Where do package-installed default systemd unit files reside?::`/usr/lib/systemd/system/`

Where do custom admin unit files and overrides belong in systemd?::`/etc/systemd/system/`

When a unit file exists in both `/etc/` and `/usr/lib/`, which one takes precedence?::`/etc/systemd/system/` (admin overrides package defaults)

What is the recommended production restart policy to recover from crashes without looping on clean exits?::`Restart=on-failure` (paired with `RestartSec=5s`)

Write a minimal systemd service unit for `/usr/local/bin/myapp` that starts after the network, restarts only on failure after 5 seconds, and is wired to boot on a headless server
?
```ini
[Unit]
Description=myapp
After=network.target
[Service]
ExecStart=/usr/local/bin/myapp
Restart=on-failure
RestartSec=5s
[Install]
WantedBy=multi-user.target
```

