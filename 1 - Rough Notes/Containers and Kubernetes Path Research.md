---
date: 2026-09-08 12:00
tags:
  - roadmap
  - research
  - containers
  - kubernetes
---
# Containers and Kubernetes Path Research

Decision this note supports: after the UNIX and Linux System Administration Handbook, go to containers and Kubernetes before the programming phases. Target: Platform Engineer who is fluent at the shell with `docker` and `kubectl`, and who understands the mechanism underneath the way the handbook explained Linux.

Checked: editions, publication dates and scope of every book below (publisher pages and catalog listings, September 2026). Unchecked: page-level quality of the 2026 releases (Kubernetes in Action 2nd, CKA Study Guide 2nd, Effective Platform Engineering); those verdicts are based on author track record and table of contents, not a read.

---

## 1. What the role actually asks for

Platform engineer job postings and 2026 roadmaps converge on the same stack:

| Layer | What shows up in postings | What it means for the path |
| :--- | :--- | :--- |
| Container runtime | Docker, containerd, OCI images, registries | Build images, understand the engine, know why a container is a process |
| Orchestration | Kubernetes (own the control plane, build abstractions on top) | Deep book plus cluster building, not just `kubectl apply` |
| Delivery | GitOps as default: Argo CD or Flux, Helm charts, Kustomize overlays | Tooling phase after the concepts |
| Infrastructure as code | Terraform (or OpenTofu), sometimes Ansible | One book, then use at work |
| Observability | Prometheus, Grafana, OpenTelemetry, Datadog | Already in the roadmap (Phase 4) |
| Developer platform | Backstage, Crossplane, internal developer platform design | Read for the shape, tools churn |
| Languages | Go, Python, Bash for tooling and automation | Go stays, just later |
| Certifications | CKA and CKAD "highly valued"; CKS for security-leaning roles | CKA is a cheap external check on fluency |

The CKA exam was overhauled in 2025 (CRDs and Operators, Gateway API, Helm and Kustomize, cluster upgrades and troubleshooting). It is performance-based at a terminal, which makes it the closest thing to an interview filter for "fluid in the shell".

---

## 2. The container book that does what the handbook did

The handbook works because it explains the mechanism (what a process is, what the kernel does) and then the commands. For containers the equivalent book is not a Docker book, it is:

**Container Security, 2nd Edition (Liz Rice, O'Reilly, 2025).** Despite the title it is a container-internals book: namespaces, cgroups, capabilities, seccomp, overlay filesystems, rootless containers, image layers and the OCI spec, and it builds a container by hand with `unshare`, `chroot` and a small Go program. Rice is ex-CNCF technical oversight chair and chief open source officer at Isovalent (Cilium). The 2nd edition refreshes the 2020 original for cgroup v2, current Kubernetes and today's tooling. It links straight into the existing notes on Linux Namespaces, Linux Capabilities and Mandatory Access Control.

Verdict: Deep, notes. This is the anchor of the container block.

---

## 3. Docker: the fluency book

| Book | Verdict | Why |
| :--- | :--- | :--- |
| **Docker Deep Dive, 2025 Edition (Nigel Poulton, self-published, also via Packt)** | **Deep, drill along** | Short, current, and has a real engine architecture chapter (daemon, containerd, shim, runc, OCI). Chapters to read closely: engine architecture (5), images (6), containers (7), containerizing apps (8), Compose (9). Skip Swarm, Docker Model Runner (LLM chapter), Wasm. Every command in it should be typed, not read. |
| Learn Docker in a Month of Lunches, 2nd Edition (Elton Stoneman, Manning, 2025) | Skip | Good, but developer-shaped (Windows apps, CI) and overlaps Deep Dive almost fully. |
| Docker in Action, 2nd Edition (Nickoloff, Kuenzli, Manning, 2019) | Skip | Aging, pre cgroup v2, pre BuildKit. |
| Podman in Action (Dan Walsh, Manning, 2023) | Selective, optional | Written by the Red Hat Podman lead. Best explanation of rootless containers and running containers as systemd units. Read the rootless and systemd chapters if the work environment is RHEL-flavoured, otherwise skip. |
| Containerd From The Bottom Up (thecontainerdbook.com, free PDF, in progress) | Selective | Covers the layer Docker books stop at: OCI runtime bundles, runc lifecycle, the runtime v2 shim, containerd snapshotters, the CRI, CNI. Read the OCI and runc, containerd, and networking parts after Container Security. It is unfinished and unattributed, so treat as reference, not canon. |

---

## 4. Kubernetes: the deep book, the fluency book, the internals books

### Deep read
**Kubernetes in Action, 2nd Edition (Marko Lukša, Kevin Conner, Manning, March 2026, 688 pages, 5 parts, 18 chapters).** The 1st edition was the consensus best Kubernetes book for years; the 2nd was in early access for a long time and finally shipped in 2026. It is API-first: every object is explained as "what the control plane does with this" rather than "here is the YAML". That is the handbook's style applied to Kubernetes.

Verdict: Deep, notes. The anchor of the Kubernetes block.

### Fluency and drills
**Certified Kubernetes Administrator (CKA) Study Guide, 2nd Edition (Benjamin Muschko, O'Reilly, February 2026, 392 pages).** First guide aligned with the overhauled 2025 exam (Kubernetes v1.33, CRDs and Operators, Gateway API, Helm, Kustomize). Structured as tasks under time pressure, which is exactly the drill format used in `7 - Drills/`. Pair with the free killercoda scenarios and the killer.sh simulator that comes with the exam registration.

Verdict: Deep, drill along, read in parallel with Kubernetes in Action, one chapter of each per topic.

**The Kubernetes Book, 2025/2026 Edition (Nigel Poulton).** Accessible, current (Gateway API, native sidecars), but it covers the same ground as Kubernetes in Action at a shallower depth.

Verdict: Skip. If a one-week orientation is wanted before the deep book, read it in that week and take no notes.

### Build a cluster by hand
**Kubernetes The Hard Way (Kelsey Hightower, free, updated 2025: Kubernetes v1.32, containerd v2.1, etcd v3.6, ARM64 and AMD64, four VMs).** No scripts, every certificate and every systemd unit by hand. This is the systemd, PKI and networking knowledge from the handbook meeting Kubernetes.

Verdict: Do once, right after the architecture chapters of Kubernetes in Action. Write one note on the control plane boot sequence.

### Internals
| Book | Verdict | Why |
| :--- | :--- | :--- |
| **Core Kubernetes (Jay Vyas, Chris Love, Manning, 2022, 336 pages)** | Selective | Control plane internals, kubelet, iptables and IPVS, CNI, CSI, cluster bootstrap. Written by contributors. Four years old, but the internals it explains have not moved much. Read the control plane, kubelet, networking and storage chapters. |
| **Networking and Kubernetes: A Layered Approach (James Strong, Vallery Lancey, O'Reilly, 2021)** | Selective | Starts from Linux networking primitives (netns, veth, iptables, conntrack) and climbs to CNI, kube-proxy, Services, Ingress. Predates Gateway API and mostly predates eBPF dataplanes, so supplement with Cilium docs. The natural sequel to Part 2 of the handbook. |
| Kubernetes: Up and Running, 3rd Edition (Burns, Beda, Hightower, Evenson, O'Reilly, 2022) | Skip | No 4th edition exists. Overlaps Kubernetes in Action and is older. |

### Running it in production and designing the platform
| Book | Verdict | Why |
| :--- | :--- | :--- |
| **Production Kubernetes: Building Successful Application Platforms (Rosso, Lander, Brand, Harris, O'Reilly, 2021)** | Selective | Ex-Heptio and VMware field engineers. Not a tutorial: it is the catalogue of decisions a platform team has to make (cluster topology, ingress, identity, secrets, multi-tenancy, admission control, upgrades) and the trade-offs of each. Read it once concepts are solid; it is written for platform engineers by name. |
| Kubernetes Patterns, 2nd Edition (Ibryam, Huss, O'Reilly, 2023) | Reference | Sidecar, init, operator, autoscaling patterns with code. Look things up when a design question comes up. |
| Kubernetes Best Practices, 2nd Edition (Burns, Villalba, Strebel, Evenson, O'Reilly, 2024) | Reference | Short chapters, one practice each. Skim the table of contents, read on demand. |
| **Platform Engineering on Kubernetes (Mauricio Salatino, Manning, 2024)** | Selective | Builds an internal platform from Helm, Argo CD, Tekton, Dagger, Crossplane, Knative, Dapr. The tools will churn; the shape of "what a platform team offers" will not. Read for the shape, do not chase every tool. |
| Platform Engineering: A Guide for Technical, Product, and People Leaders (Camille Fournier, Ian Nowland, O'Reilly, October 2024) | Skim | Organisational, not technical. Read once to know how platform teams are judged. |
| Effective Platform Engineering (Ajay Chankramath et al., Manning, November 2025) | Candidate, unverified | Too new for a track record. Check reviews before buying. |

### Delivery tooling (learn from docs first, one book each at most)
| Tool | Resource | Verdict |
| :--- | :--- | :--- |
| Helm and Kustomize | Official docs; both are covered in the CKA guide | Docs only |
| Argo CD | Argo CD in Practice (Costea, Economakis, Packt, 2022) or GitOps Cookbook (Vinto, Soto Bueno, O'Reilly, 2022) | Selective, pick one. The cookbook if recipes are preferred. |
| Terraform / OpenTofu | Terraform: Up and Running, 3rd Edition (Yevgeniy Brikman, O'Reilly, 2022) | Selective. No 4th edition; Brikman's Gruntwork backs OpenTofu, so the book transfers. |

### Security (later, after Phase 4 of the roadmap)
| Book | Verdict |
| :--- | :--- |
| Certified Kubernetes Security Specialist (CKS) Study Guide (Muschko, O'Reilly, 2023, 1st edition only) | Reference, when security work comes up |
| Kubernetes Security and Observability (Creane, Gupta, Tigera, O'Reilly, 2021, free from Tigera) | Skim |

---

## 5. Proposed order and rough timing

Timing assumes the current pace (roughly one handbook part per two months, two or three drills a week).

1. **Finish the handbook Deep chapters** as already mapped: TCP/IP (13), DNS (16), Storage (20), Containers (25), Security (27), Monitoring (28), Performance (29). The Containers chapter is the hand-off point.
2. **Container block, 6 to 8 weeks.** Docker Deep Dive (two weeks, typed along, drills), then Container Security 2nd Edition (deep, notes into `03 - Containers & Platform Primitives`), then the runc and containerd parts of Containerd From The Bottom Up.
3. **Kubernetes block, 4 to 6 months.** Kubernetes in Action 2nd Edition and the CKA Study Guide in parallel, topic by topic, with killercoda drills. Kubernetes The Hard Way after the architecture chapters. Then Core Kubernetes and Networking and Kubernetes, selective. Sit the CKA at the end as the verification step for "fluid in the shell".
4. **Platform block, 2 to 3 months.** Production Kubernetes, Platform Engineering on Kubernetes, Terraform: Up and Running, one Argo CD book. Build a small platform end to end: kind or k3s cluster, Terraform for the infra, Helm chart, Argo CD syncing it, Prometheus scraping it.
5. **Then the programming phases** as they already stand: Python glue, C reading skill, OSTEP and The Linux Programming Interface, Go, Kubebuilder. Kubebuilder and Cloud Native Go land better after a year of operating clusters.

---

## 6. Trade-offs to be honest about

- **Go moves out by roughly a year.** Operators, controllers and most platform tooling are Go. Nothing in the container and Kubernetes blocks needs Go, but the Kubebuilder and Cloud Native Go phase waits.
- **Nothing here is drillable on the Windows work machine** unless Docker Desktop or a kind cluster is allowed there. Python was scheduled early precisely because it could be practised at work. If work allows WSL2 or Docker Desktop, the `kubectl` drills can move there; if not, all container and Kubernetes practice is evening time.
- **Book age.** Core Kubernetes, Networking and Kubernetes and Production Kubernetes are 2021 and 2022. They are kept because the internals they explain are stable; treat any tool-specific chapter (Ingress controllers, dashboards) as dated and check the current docs.
- **Two anchor books shipped in 2026.** Kubernetes in Action 2nd and the CKA guide 2nd are the right editions to buy but have no long-term reviews yet.

---

## 7. Vault follow-ups

- New notes go into `6 - Main notes/03 - Containers & Platform Primitives` and `07 - Kubernetes & Cloud` (folder planned in the operating guide, not created yet).
- `7 - Drills/` needs `Drills - Docker.md` and `Drills - kubectl.md` registries. The CKA guide's task format is the drill template.
- Flashcard decks: `flashcards/containers/*` and `flashcards/k8s/*` as already reserved in the flashcard guide.

## 🔗 Related
- [[Learning Roadmap]]
- [[Linux Namespaces]]
- [[Linux Capabilities]]
- [[Drill Protocol]]

## Sources
- Manning, Kubernetes in Action 2nd Edition: https://www.manning.com/books/kubernetes-in-action-second-edition
- O'Reilly, CKA Study Guide 2nd Edition: https://www.oreilly.com/library/view/certified-kubernetes-administrator/9798341608399/
- O'Reilly, Container Security 2nd Edition: https://www.oreilly.com/library/view/container-security-2nd/9798341627697/
- Leanpub, Docker Deep Dive: https://leanpub.com/dockerdeepdive
- Leanpub, The Kubernetes Book: https://leanpub.com/thekubernetesbook
- Manning, Core Kubernetes: https://www.manning.com/books/core-kubernetes
- O'Reilly, Networking and Kubernetes: https://www.oreilly.com/library/view/networking-and-kubernetes/9781492081647/
- O'Reilly, Production Kubernetes: https://www.amazon.com/Production-Kubernetes-Successful-Application-Platforms/dp/1492092304
- Manning, Platform Engineering on Kubernetes: https://www.manning.com/books/platform-engineering-on-kubernetes
- O'Reilly, Platform Engineering (Fournier, Nowland): https://www.oreilly.com/library/view/platform-engineering/9781098153632/
- Manning, Effective Platform Engineering: https://livebook.manning.com/book/effective-platform-engineering/about-this-book
- Manning, Podman in Action: https://www.manning.com/books/podman-in-action
- Manning, Learn Docker in a Month of Lunches 2nd Edition: https://www.manning.com/books/learn-docker-in-a-month-of-lunches-second-edition
- Containerd From The Bottom Up: https://thecontainerdbook.com/
- Kubernetes The Hard Way: https://github.com/kelseyhightower/kubernetes-the-hard-way
- O'Reilly, Kubernetes Patterns 2nd Edition: https://www.oreilly.com/library/view/kubernetes-patterns-2nd/9781098131678
- O'Reilly, Kubernetes Best Practices 2nd Edition: https://www.vitalsource.com/products/kubernetes-best-practices-brendan-burns-eddie-v9781098142179
- Packt, Argo CD in Practice: https://www.packtpub.com/en-us/product/argo-cd-in-practice-9781803233321
- GitOps Cookbook: https://www.amazon.com/GitOps-Cookbook-Kubernetes-Automation-Practice/dp/1492097470
- Terraform: Up and Running: https://www.terraformupandrunning.com/
- Tigera, Kubernetes Security and Observability: https://www.tigera.io/blog/weve-just-published-a-book-on-container-and-cloud-native-application-security-and-observability/
- Platform engineer skills 2026: https://devopsboys.com/blog/platform-engineering-job-skills-portfolio-2026 and https://interviewkickstart.com/skills/platform-engineer
- Best Kubernetes books 2026 (cross-check): https://computingforgeeks.com/essential-books-for-learning-kubernetes-fast/
