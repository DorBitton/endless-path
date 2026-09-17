---
date: 2026-08-22 15:00
tags:
  - flashcards/linux/httpd
  - linux
  - web
  - infrastructure
---
# Apache HTTP Server (httpd)

## 🧠 The Core Concept
- **What is it?** `httpd` (HTTP Daemon) is the core daemon process for the Apache HTTP Server, one of the foundational open-source web servers on Linux.
- On Red Hat/CentOS/Fedora systems, the service and package name is `httpd`. On Debian/Ubuntu systems, it is packaged as `apache2`.

## 🛠️ Key Details & Configuration
- **Default Ports:** 80 (HTTP), 443 (HTTPS).
- **Default Document Root:** `/var/www/html/`
- **Main Config File (RHEL/CentOS):** `/etc/httpd/conf/httpd.conf`
- **Main Config File (Debian/Ubuntu):** `/etc/apache2/apache2.conf`
- **Configuration Syntax Test:** `apachectl configtest` or `httpd -t`

## 🔗 Connections
- **Related to:** [[Daemons]], [[systemd]], [[systemctl]]

## ⚡ Active Recall Flashcards

Same software, two names: what is `httpd` on RHEL called on Debian/Ubuntu, and what changes with it?::`apache2`; the package, service name, and config paths differ, the daemon is the same Apache HTTP Server

You edited the Apache config on a live box. How do you avoid taking the site down with a typo when you reload?::`apachectl configtest` (or `httpd -t`) validates the config before `systemctl reload`

