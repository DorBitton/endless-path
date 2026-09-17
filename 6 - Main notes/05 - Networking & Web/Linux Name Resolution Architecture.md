---
date: 2026-09-10 09:55
tags:
  - flashcards/linux/networking
  - concept
  - networking
  - linux
---
# Linux Name Resolution Architecture

## 🧠 The Core Concept
Host name resolution in Linux does not go directly to DNS. It passes through a three-stage configuration pipeline managed by the C library resolver (glibc):

1. **/etc/nsswitch.conf (The Traffic Cop):**
   - Directs the lookup order for the system resolver via the `hosts:` directive (e.g. `hosts: files dns`).
   - Tells the kernel whether to check local static files first or query external DNS nameservers.
2. **/etc/hosts (The Local Phonebook):**
   - Static, direct mappings between IP addresses and hostnames (e.g. `192.168.1.50 db-master`).
   - Evaluated before DNS when `files` precedes `dns` in `nsswitch.conf`. Reserved for boot-time resolution (localhost, local hostname) before network interfaces are up, or for private host overrides.
3. **/etc/resolv.conf (The Directory Operator):**
   - Lists upstream DNS nameserver IP addresses (e.g. `nameserver 8.8.8.8`).
   - It does not map domain names directly; it instructs the system which external resolvers to query.
   - In modern distros, this file is dynamically generated and managed by `systemd-resolved` or NetworkManager.

---

## 💻 Essential Commands & Minimal Triage

```bash
# 1. Check hostname resolution pipeline order
grep hosts /etc/nsswitch.conf

# 2. View local static hostname overrides
cat /etc/hosts

# 3. View upstream nameserver configuration
cat /etc/resolv.conf

# 4. Test exact OS glibc resolution path (respects nsswitch.conf)
getent hosts example.com
```

---

## ⚠️ Common Pitfalls (The "Gotchas")

- **Stale `/etc/hosts` Overrides:** Because `/etc/nsswitch.conf` usually queries `files` before `dns`, forgotten debugging entries in `/etc/hosts` silently intercept production traffic even after DNS records are updated or migrated.
- **Directly Editing a Dynamically Managed `/etc/resolv.conf`:** In modern systemd systems, `/etc/resolv.conf` is a symlink managed by `systemd-resolved`. Manual edits will be overwritten on network restarts or DHCP leases. Configure upstream DNS in `systemd-resolved` or network manager profiles instead.

---

## 🔗 Connections (Mental Mapping)

- **Hub:** [[Linux Networking Fundamentals]]
- **Related to:** [[Network Troubleshooting]]
- **Real-World Mental Model:** 
  - `nsswitch.conf`: The company policy stating "Check your desk notebook first; if not found, call directory assistance".
  - `hosts`: Your private desk notebook with speed-dial numbers.
  - `resolv.conf`: The phone number of directory assistance.

---

## ⚡ Active Recall Flashcards

What is the operational difference between /etc/hosts and /etc/resolv.conf?::/etc/hosts contains direct static name-to-IP mappings; /etc/resolv.conf points to upstream DNS nameserver IPs

Why can forgotten entries in /etc/hosts break production traffic after a server IP migration?::Because /etc/nsswitch.conf usually checks 'files' before 'dns', causing the host to use stale static IPs and ignore updated DNS records

Which file controls whether Linux checks local static files (/etc/hosts) before querying external DNS?::`/etc/nsswitch.conf` (via the `hosts:` entry)
