---
date: 2026-09-07 16:59
tags:
  - flashcards/linux/networking
  - concept
  - networking
  - triage
---
# Network Troubleshooting

## 🧠 The Core Concept
Network debugging in production follows a bottom-up diagnostic ladder across the protocol stack. Rather than guessing, an SRE isolates the failure to a specific layer:

1. **L3 Reachability (ICMP):** `ping` verifies basic host reachability, round-trip latency, and packet loss. However, many enterprise firewalls and cloud environments drop ICMP echo requests by default.
2. **Path & Transit Analysis:** `traceroute` and `mtr` identify intermediate hops, routing loops, and hop-by-hop latency.
   - *The TTL Mechanism:* `traceroute` intentionally sends packets with an initial **TTL (Time to Live)** of 1, incrementing by 1 for each successive probe. When a router decrements TTL to 0, it drops the packet and sends back an ICMP **Time Exceeded** message, exposing that hop's IP address.
   - *The Asterisk Gotcha (`* * *`):* Intermediate routers often rate-limit ICMP generation or drop expired packets silently to protect their CPU. Asterisks on middle hops do not indicate an outage if subsequent hops and the final destination respond.
3. **L4 Port Connectivity:** When ICMP is blocked, test the actual transport socket using `nc -zv` (Netcat) or `telnet`. If the TCP 3-way handshake completes, Layer 3 routing is healthy and the application port is open.
4. **Local Socket Health:** `ss` (Socket Statistics) inspects local endpoints directly from the kernel via Netlink (`sock_diag`). It exposes connection leaks (thousands of sockets stuck in `TIME-WAIT` or `CLOSE-WAIT`) and confirms if an application is actively bound and listening.
5. **Name Resolution (DNS):** Query tools diagnose resolution failures across recursive resolvers and authoritative servers:
   - *Tool Roles:* `dig` is the standard protocol debugger, exposing raw DNS headers, flags, and sections. `host` provides quick one-line script lookups. `nslookup` is legacy and uses its own internal resolver rather than standard system resolution libraries.
   - *Direct Server Queries (`@server`):* Bypasses the local system resolver (`/etc/resolv.conf`) to test a specific upstream resolver (e.g. `8.8.8.8`) or the authoritative nameserver (`ns1.example.com`) directly.
   - *Header Flags (`flags:`):* The `aa` (Authoritative Answer) flag proves the response came directly from the zone's authoritative nameserver rather than a recursive cache. `rd` indicates recursion was requested; `ra` confirms the server supports recursion.
   - *Diagnostic Return Codes:*
     - `NOERROR`: Query succeeded. (Gotcha: check the `ANSWER` count; an answer count of 0 means NODATA, where the domain exists but the requested record type does not).
     - `NXDOMAIN`: The domain name does not exist anywhere in the DNS tree.
     - `SERVFAIL`: The resolver encountered an upstream failure, network timeout, or DNSSEC validation break.
     - `REFUSED`: The nameserver refused to process the request (e.g. recursion is disabled for public clients).
   - *Reverse DNS (PTR):* Maps an IP back to a hostname via the `in-addr.arpa` hierarchy (`dig -x <ip>`), essential for email hygiene, logging, and security verification.
6. **Ground Truth Packet Inspection:** `tcpdump` and Wireshark capture raw network packets directly off the network interface. When logs and metrics fail, packet captures prove whether a packet ever arrived on the wire, who dropped the connection, or whether TCP resets (RST) were injected.

---

## 💻 Essential Commands & Minimal Triage

```bash
# 1. Test basic reachability with 3 packets
ping -c 3 10.0.1.50

# 2. Test TCP port connectivity when ICMP ping is blocked
nc -zv 10.0.1.50 5432

# 3. Real-time path tracing with packet loss per hop
mtr -rw 10.0.1.50

# 4. Query DNS record, check exact return code (NOERROR/NXDOMAIN) and TTL
dig api.example.com

# 5. Bypass local resolver cache and query authoritative nameserver directly
dig @ns1.example.com api.example.com

# 6. Trace full DNS resolution path from root servers down
dig +trace api.example.com

# 7. Reverse DNS lookup (resolve IP to hostname via PTR record)
dig -x 10.0.1.50

# 8. Script-friendly output (clean IP/record only, no headers)
dig +short api.example.com

# 9. Quick one-line hostname resolution
host api.example.com

# 10. Socket triage: high-level socket summary (instant leak detection)
ss -s

# 11. Socket triage: show listening TCP/UDP ports with PID (numeric, no DNS hang)
ss -tulpn

# 12. Surgical packet capture on interface eth0 for port 5432 (no DNS resolution)
sudo tcpdump -nn -i eth0 port 5432 -A
```

---

## ⚠️ Common Pitfalls (The "Gotchas")

- **Assuming Blocked Ping Equals Downtime:** Firewalls routinely block ICMP while leaving application ports wide open. Never conclude a service is down based solely on `ping`; verify with `nc -zv <host> <port>`.
- **Interpreting Traceroute Asterisks as Broken Paths:** Seeing `* * *` on hop 4 while hop 5 answers means router 4 simply declined to send an ICMP Time Exceeded response.
- **Running Unfiltered `tcpdump` on Production Nodes:** Running `tcpdump` without `-nn` or without strict port/host filters on a high-throughput server can flood the terminal, consume disk, or drop packets. Always filter by interface, port, and IP.
- **Ignoring Stale DNS TTLs:** If a service fails after an IP migration, check the TTL in `dig`. Resolvers and client libraries will continue hitting the old IP until the cached TTL hits 0.
- **Querying Without `@nameserver` Tests Local Cache, Not Ground Truth:** Running `dig example.com` only checks the local recursive resolver. During outages or IP changes, query the authoritative nameserver directly (`dig @ns1.example.com example.com`) to distinguish between cache lag and real zone misconfigurations.
- **The Empty NOERROR Trap (NODATA):** A status of `NOERROR` does not guarantee an IP address was returned. If the domain exists but lacks the requested record type (e.g. requesting `AAAA` for an IPv4-only host), `dig` returns `status: NOERROR` with an empty `ANSWER SECTION`.
- **nslookup Diverges from System Resolution:** `nslookup` implements its own internal DNS query engine and ignores `/etc/nsswitch.conf`. Use `dig` to inspect DNS protocol exchanges, and `getent hosts <domain>` to test the exact OS-level resolution path used by running applications.

---

## 🔗 Connections (Mental Mapping)

- **Related to:** [[Linux Networking Fundamentals]], [[Bash]]
- **Mental Model:** Step through the stack in order: Wire $\rightarrow$ Host Alive (`ping`) $\rightarrow$ Route Clear (`mtr`) $\rightarrow$ Port Open (`nc`) $\rightarrow$ Process Bound (`ss`) $\rightarrow$ Name Resolved (`dig`) $\rightarrow$ Packet Proof (`tcpdump`).

---

## ⚡ Active Recall Flashcards

How do you test if a remote TCP port is reachable when ICMP ping is blocked by a firewall?::`nc -zv <host> <port>` (or `telnet <host> <port>`)

How does traceroute discover the IP addresses of intermediate routers along a path?::It sends packets with incrementally increasing IP TTL values (starting at 1), causing each router to drop the packet and return an ICMP Time Exceeded message

During a traceroute, what does a row of asterisks (* * *) on an intermediate hop usually indicate?::The router is silently dropping expired packets or rate-limiting ICMP responses, not that the connection is broken

Which dig flag traces the full DNS resolution hierarchy starting from the root nameservers?::`+trace` (`dig +trace <domain>`)

Why is ss preferred over netstat for inspecting socket connections on high-traffic servers?::`ss` queries binary data directly via kernel Netlink sockets, while `netstat` slowly parses text files in `/proc/net/`

How do you verify whether a DNS response came from the authoritative nameserver or a cache using dig?::Check the header flags for 'aa' (Authoritative Answer); if 'aa' is present, the server is authoritative for the zone

During DNS triage, how do you bypass the local resolver cache to query an authoritative nameserver directly?::`dig @<nameserver-ip-or-host> <domain>`
