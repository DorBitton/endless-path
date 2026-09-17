---
date: 2026-09-10 09:55
tags:
  - flashcards/linux/networking
  - concept
  - networking
  - linux
---
# IP Routing and ARP

## 🧠 The Core Concept
Linux separates local layer 2 frame delivery from remote layer 3 packet routing:

- **Local Delivery (ARP):** If the destination IP falls within the local subnet, the kernel broadcasts an **ARP (Address Resolution Protocol)** request: *"Who has this IP? Reply with your MAC address."* Devices communicate directly at Layer 2.
- **Remote Delivery (Default Gateway):** If the destination IP is outside the local subnet, ARP broadcasts cannot reach it. The kernel consults the routing table (`ip route`), finds the **Default Gateway**, ARPs for the gateway's MAC address, and forwards the packet to the gateway for routing.
- **Routing Rules & Longest Prefix Match (LPM):**
  - *Host Route (/32):* Matches exactly one IP (e.g. `192.168.1.50/32`).
  - *Network Route (/24, /16):* Matches an entire subnet range.
  - *Default Gateway (0.0.0.0/0):* Catch-all route for any traffic not matching a more specific route.
  - *Longest Prefix Match:* If a destination matches multiple routes, the kernel forwards via the most specific route (the one with the longest prefix length / highest number of 1-bits).

---

## 💻 Essential Commands & Minimal Triage

```bash
# 1. View routing table and default gateway
ip route show

# 2. View the ARP neighbor cache (Layer 2 MAC mappings)
ip neigh show

# 3. Add a route to a remote subnet via a gateway
sudo ip route add 10.212.0.0/16 via 10.213.15.99

# 4. Add a single host route (/32)
sudo ip route add 192.168.1.50/32 via 10.213.15.1

# 5. Flush stale ARP entry for an IP
sudo ip neigh del 192.168.1.50 dev eth0
```

---

## ⚠️ Common Pitfalls (The "Gotchas")

- **Non-Zero Host Bits in Route Destinations (RTNETLINK error):** When adding a network route, the destination must have all host bits zeroed. Running `ip route add 132.236.227.15/24 via ...` fails with `RTNETLINK answers: Invalid argument`. It must be `132.236.227.0/24`.
- **ARP Broadcast Boundary:** ARP broadcasts do not cross routers. You cannot ARP for a remote IP address; you can only ARP for the next-hop router on your physical link.

---

## 🔗 Connections (Mental Mapping)

- **Hub:** [[Linux Networking Fundamentals]]
- **Related to:** [[IP Addressing and Subnetting]], [[Network Troubleshooting]]
- **Real-World Mental Model:** 
  - ARP: Shouting someone's name across the office floor.
  - Default Gateway: Handing an envelope to the mail clerk by the elevator because the recipient is on a different floor.

---

## ⚡ Active Recall Flashcards

Why does a host ARP for the default gateway MAC instead of the target server MAC when sending packets to a remote subnet?::ARP broadcasts cannot cross routers; the host must hand the frame to the gateway at Layer 2 so the gateway can route it at Layer 3

When an outgoing packet matches both 10.0.0.0/16 and 10.0.1.0/24 in the routing table, which path does it take and why?::The 10.0.1.0/24 path, because the kernel forwards using Longest Prefix Match (most specific mask)

Why does 'ip route add 192.168.1.15/24 via 10.0.0.1' fail with an RTNETLINK error?::Network route destinations must have host bits zeroed (must be 192.168.1.0/24, not .15)
