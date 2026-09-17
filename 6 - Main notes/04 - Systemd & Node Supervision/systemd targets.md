---
date: 2026-08-21 12:50
tags:
  - flashcards/linux/systemd-targets
  - concept
  - linux
  - infrastructure
---
# systemd Targets

## 🧠 The Core Concept (In My Own Words)
- **What is it?** A systemd target is an organizational unit that groups multiple services and units together to represent a specific system operating state.
- **Why does it matter?** Targets are the modern replacement for legacy SysV init **runlevels**. They define what "fully booted" means (e.g. headless server CLI vs. full desktop GUI) and establish dependency synchronization points (e.g. `network.target`).

## 🛠️ Real-World Application & Troubleshooting
- **Production Best Practice:** Production cloud servers (AWS, GCP) should always boot into `multi-user.target` to eliminate wasted RAM and CPU on unnecessary display managers and GUI desktop stacks.

### The 3 Essential Targets
1. `multi-user.target`: Standard headless multi-user CLI environment (Equivalent to SysV Runlevel 3). **Standard for 99% of servers.**
2. `graphical.target`: Desktop GUI environment with display manager (Equivalent to SysV Runlevel 5).
3. `rescue.target`: Single-user maintenance mode for emergency disk checks and root repair.

## 💻 Commands, Syntax & Code
- `systemctl get-default`: Show current default boot target.
- `sudo systemctl set-default multi-user.target`: Permanently set boot target to multi-user CLI mode.
- `sudo systemctl isolate rescue.target`: Immediately switch active system state into rescue mode without rebooting.
- `systemctl list-units --type=target`: View all currently loaded targets.

## 🔗 Connections
- **Related to:** [[systemd]], [[systemctl]], [[systemd units]]
- **Why linked:** In a unit's `[Install]` section, `WantedBy=multi-user.target` instructs systemd to boot the service when the server reaches standard CLI mode.

## ⚡ Active Recall Flashcards
What is a systemd Target?::A grouping mechanism for units representing a system state (modern replacement for runlevels)
<!--SR:!fsrs,2026-09-06T09:22:48.018Z,0,1.2931,5.11217071,1,1,0,0,2026-09-06T09:16:48.018Z-->

What is the standard systemd target for headless Linux servers?::`multi-user.target` (SysV Runlevel 3 equivalent)
<!--SR:!fsrs,2026-09-06T09:23:00.781Z,0,1.2931,5.11217071,1,1,0,0,2026-09-06T09:17:00.781Z-->

A cloud VM boots into a GUI target and wastes RAM. How do you check the default and switch it permanently to headless?::`systemctl get-default`, then `sudo systemctl set-default multi-user.target`
<!--SR:!fsrs,2026-09-06T09:23:11.443Z,0,1.2931,5.11217071,1,1,0,0,2026-09-06T09:17:11.443Z-->

Switch a running system into single-user maintenance mode without rebooting::`sudo systemctl isolate rescue.target`
<!--SR:!fsrs,2026-09-06T09:23:18.036Z,0,1.2931,5.11217071,1,1,0,0,2026-09-06T09:17:18.036Z-->

What is the difference between `rescue.target` and `emergency.target`?::rescue mounts filesystems and starts basic services before the root shell; emergency gives a root shell with `/` read-only and almost nothing else started
<!--SR:!fsrs,2026-09-06T09:23:34.643Z,0,1.2931,5.11217071,1,1,0,0,2026-09-06T09:17:34.643Z-->