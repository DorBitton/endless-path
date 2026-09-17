---
date: 2026-09-10 09:55
tags:
  - flashcards/linux/networking
  - concept
  - networking
  - linux
---
# Transport Protocols and Ports

## 🧠 The Core Concept
Transport protocols (Layer 4) multiplex application network streams to processes using port numbers (1 to 65,535):

- **TCP (Transmission Control Protocol):** Connection-oriented, full-duplex stream.
  - *Handshake:* 3-way handshake (SYN, SYN-ACK, ACK) to negotiate sequence numbers.
  - *Reliability:* Tracks sequence numbers, acknowledges received segments (ACK), and retransmits lost packets.
  - *Teardown:* 4-way teardown (FIN, ACK, FIN, ACK) to close both halves of the connection.
- **UDP (User Datagram Protocol):** Connectionless, stateless datagrams. No handshake, no sequence tracking, no retransmissions. Minimal overhead, ideal for DNS and real-time streaming.
- **Privileged Ports & Linux Capabilities:**
  - Ports below 1024 are privileged. Historically, processes binding to low ports (like 80 or 443) had to run as `root`.
  - In modern Linux, grant `CAP_NET_BIND_SERVICE` instead of root execution.

---

## 💻 Essential Commands & Minimal Triage

```bash
# 1. Check listening TCP and UDP ports with owning PID (numeric output, no DNS hang)
ss -tulpn

# 2. Grant a non-root binary permission to bind ports < 1024
sudo setcap 'cap_net_bind_service=+ep' /usr/local/bin/myapp
```

In a **systemd service unit**, grant low-port binding without root:
```ini
[Service]
User=appuser
AmbientCapabilities=CAP_NET_BIND_SERVICE
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
```

---

## ⚠️ Common Pitfalls (The "Gotchas")

- **The -n Flag in Outages:** Running `ss -tulp` or `netstat` without `-n` causes the command to perform reverse DNS lookups on every remote and local address. During network incidents or DNS outages, your terminal freezes for 30 seconds per socket. Always run `ss -tulpn`.
- **Running Web Servers as Root for Port 80/443:** Running an entire daemon as root just to bind port 80 or 443 violates the principle of least privilege. Use `CAP_NET_BIND_SERVICE` or front the daemon with a reverse proxy.

---

## 🔗 Connections (Mental Mapping)

- **Hub:** [[Linux Networking Fundamentals]]
- **Related to:** [[Linux Capabilities]], [[systemd units]], [[Network Troubleshooting]]
- **Real-World Mental Model:** 
  - IP Address: The street address of an apartment building.
  - Port Number: The specific apartment unit number inside that building.

---

## ⚡ Active Recall Flashcards

During a network outage, why must you include the -n flag when running ss or netstat?::It forces numeric output and prevents the command from hanging on broken DNS reverse lookups

What Linux capability allows a non-root process to bind to network ports below 1024?::`CAP_NET_BIND_SERVICE`

Write the systemd service section that grants an unprivileged service permission to bind privileged ports (<1024)
?
[Service]
AmbientCapabilities=CAP_NET_BIND_SERVICE
CapabilityBoundingSet=CAP_NET_BIND_SERVICE

