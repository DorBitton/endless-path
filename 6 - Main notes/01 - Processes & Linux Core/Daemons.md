---
date: 2026-08-21 11:51
tags:
  - flashcards/linux/daemons
  - linux
  - concepts
  - infrastructure
---
# Daemons

## 🧠 The Core Concept (In My Own Words)
- **What is it?** A long-running background process in Linux that executes tasks without direct user interaction. Daemons have no graphical interface or attached terminal session. They typically start at system boot and remain active until shutdown.
- **Why does it matter?** They keep the operating system functional, automated, responsive to network events, and secure.

## 🛠️ Real-World Application & Troubleshooting
- **How is it used in production?** 
	- [[systemd]]: The primary init daemon (**PID 1**) that starts and supervises all other system processes and services.
	- [[sshd]]: The secure shell daemon, listening on port 22 for remote connections.
	- [[Cron|crond]]: The cron daemon that executes scheduled jobs.
	- [[nginx]] / [[httpd]]: Web server daemons that listen for HTTP/S traffic.

- **How does it break?** When a daemon breaks, the symptoms range from a single malfunctioning feature to a total system crash:
	- `[System Event] ──> [Configuration Error / Out of Memory / Bad Permissions] ──> [Daemon Crashes / Freezes]`

- **How do I debug it?** 
	- **Check the vital signs**: Run `systemctl status <daemon_name>`. Look for the red **"failed"** or **"dead"** status indicator.
	- **Read the error logs**: Run `journalctl -u <daemon_name> -n 50`. This pulls the last 50 lines of system logs specifically for that daemon.

## 💻 Commands, Syntax & Code
- `systemctl status <daemon_name>`: Check health and recent log output.
- `systemctl list-units --failed`: Show all failed services across the system.
- `journalctl -u <daemon_name> -n 50`: Inspect the last 50 logs of a specific daemon.
- `sudo systemctl kill --signal=KILL <service_name>`: Force-kill an unresponsive daemon.

## 🔗 Connections
- **Supervision & Control:** [[systemd]], [[systemctl]], [[journalctl]]
- **Periodic Execution & Cleanup:** [[Cron]], [[Logrotate]]
- **Why linked:** Systemd is the daemon supervisor (PID 1), `systemctl` is the management tool, and `journalctl` collects output streams from all running daemons.

## ⚡ Active Recall Flashcards
What is a daemon in Linux?::A long-running background process running without an attached terminal or user interaction
<!--SR:!fsrs,2026-10-12T14:11:46.183Z,42,41.57871783,1,2,2,0,0,2026-08-31T14:11:46.183Z-->

What is PID 1 on modern Linux systems?::`systemd` (the init daemon that starts and supervises all processes)
<!--SR:!fsrs,2026-10-12T14:10:38.884Z,42,41.57871783,1,2,2,0,0,2026-08-31T14:10:38.884Z-->