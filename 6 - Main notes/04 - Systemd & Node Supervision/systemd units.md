---
date: 2026-08-22 15:00
tags:
  - flashcards/linux/systemd-units
  - concepts
  - linux
  - infrastructure
---
# systemd Units

## 🧠 The Core Concept
- **What is it?** A **Unit** is any resource or entity that systemd knows how to manage and supervise. Every unit is defined by a configuration file with an extension corresponding to its unit type.

## 🛠️ Common Unit Types
| Extension | Unit Type | Purpose |
| --- | --- | --- |
| `.service` | Service | Starts and controls daemons and background processes (e.g. `nginx.service`) |
| `.target` | Target | Groups multiple units to define boot states / runlevels (e.g. `multi-user.target`) |
| `.timer` | Timer | Triggers services based on schedules / events (replaces cron) |
| `.socket` | Socket | Implements socket-based activation for on-demand service startup |
| `.mount` | Mount point | Manages filesystem mount points (managed automatically via `/etc/fstab`) |
| `.path` | Path | Triggers services when a file/directory is modified (like `inotify`) |

## 💻 Key Commands
- `systemctl list-units`: List all currently active units in memory.
- `systemctl list-unit-files`: List all installed unit files on disk (enabled/disabled status).
- `systemctl cat <unit>`: Print the exact contents of a unit file and any override drop-in configs.

## 🔗 Connections
- **Related to:** [[systemd]], [[systemctl]], [[systemd targets]], [[Daemons]]

## ⚡ Active Recall Flashcards
What systemd unit type is used to schedule recurring tasks instead of cron?::`.timer`
<!--SR:!fsrs,2026-08-31T14:21:32.248Z,0,0.212,6.4133,1,1,0,0,2026-08-31T14:20:32.248Z-->

What systemd unit type enables on-demand daemon startup when network traffic arrives?::`.socket`
<!--SR:!fsrs,2026-08-31T14:21:41.924Z,0,0.212,6.4133,1,1,0,0,2026-08-31T14:20:41.924Z-->

A service behaves differently from the unit file you are reading on disk. How do you see the effective config, drop-in overrides included?::`systemctl cat <unit>`

What is the difference between `systemctl list-units` and `systemctl list-unit-files`?::`list-units` shows units loaded in RAM/active; `list-unit-files` shows all unit files installed on disk
<!--SR:!fsrs,2026-08-31T14:30:02.118Z,0,2.3065,2.11810397,1,1,0,1,2026-08-31T14:20:02.118Z-->
