---
date: 2026-09-10 09:55
tags:
  - flashcards/linux/networking
  - concept
  - networking
  - linux
---
# IP Addressing and Subnetting

## 🧠 The Core Concept
IPv4 addresses are 32 bits (4 bytes) long, divided into a **Network ID** and a **Host ID** by the subnet mask (CIDR notation):

- **CIDR Prefix (/N):** The number of bits allocated to the network prefix.
  - Total IPs in subnet = $2^{32 - \text{prefix}}$.
  - Usable IPs = $\text{Total} - 2$ (subtracting the base Network ID with all host bits 0, and the Broadcast address with all host bits 1).
  - *Cloud Exception:* AWS VPC subnets reserve 5 IP addresses per subnet (.0 network, .1 router, .2 DNS, .3 future use, .255 broadcast).
- **Subnet Boundaries Beyond /24:**
  - Subnet masks must start on true network address boundaries where host bits are zeroed.
  - Octet block size is calculated as $256 - \text{mask octet}$.
  - For `/26` (`255.255.255.192`), the block size is $256 - 192 = 64$. Subnets start strictly at `.0`, `.64`, `.128`, `.192`.
  - For example, `132.236.220.64/26` is valid (usable host range: `.65` to `.126`, broadcast: `.127`).

---

## 💻 Essential Commands & Minimal Triage

```bash
# 1. View all configured IP addresses and interface CIDR masks
ip -br addr show

# 2. Add an IP address to a specific interface
sudo ip addr add 192.168.1.50/24 dev eth0

# 3. Remove an assigned IP address from an interface
sudo ip addr del 192.168.1.50/24 dev eth0
```

---

## ⚠️ Common Pitfalls (The "Gotchas")

- **Subnet Mask Typo (ARP Blackhole):** Setting a `/16` mask instead of `/24` causes the kernel to believe remote subnets are in the same local layer 2 segment. It sends ARP requests that receive no response, failing with `Destination Host Unreachable` instead of routing through the gateway.
- **Usable vs. Total Host Count:** A `/24` gives 256 addresses, but only 254 usable hosts. Forgetting the minus 2 rule leads to IP exhaustion during subnet capacity planning.

---

## 🔗 Connections (Mental Mapping)

- **Hub:** [[Linux Networking Fundamentals]]
- **Related to:** [[IP Routing and ARP]], [[Network Troubleshooting]]
- **Real-World Mental Model:** The subnet mask is the perimeter fence of an office floor. Anyone inside the fence is reachable by shouting across the room (ARP). Anyone outside requires walking to the elevator (Gateway).

---

## ⚡ Active Recall Flashcards

What failure occurs if a server is mistakenly configured with a /16 subnet mask instead of /24?::It wrongly assumes hosts in other /24 subnets are local, shouting ARP requests that get no answer instead of forwarding to the gateway

How do you calculate the usable host count for an IPv4 CIDR prefix?::$2^{32 - \text{prefix}} - 2$ (subtracting the network address and broadcast address)

Why is 132.236.220.64/26 a valid network address while 132.236.220.10/26 is not?::Block size for /26 is 64 (256 - 192); valid network boundaries must start on multiples of 64 (.0, .64, .128, .192) with host bits zeroed
