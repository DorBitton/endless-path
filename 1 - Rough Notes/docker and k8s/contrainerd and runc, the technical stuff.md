 Overview

At a high level, container management is split into two layers:

* **runc (Low-Level Runtime):** The lightweight CLI tool that interacts directly with the Linux kernel (namespaces, cgroups) to create and start a container process, then exits.
* **containerd (High-Level Runtime):** The persistent daemon that manages the entire container lifecycle, including pulling images, unpacking storage, configuring networks, and supervising container processes by calling runc.

```
+-------------------------------------------------------------+
| Management Layer (Docker Daemon / Kubernetes Kubelet)       |
+-------------------------------------------------------------+
                              |
                              v
+-------------------------------------------------------------+
| containerd (High-level: images, snapshots, supervision)     |
+-------------------------------------------------------------+
                              |
                              v
+-------------------------------------------------------------+
| runc (Low-level: Linux cgroups, namespaces, seccomp)        |
+-------------------------------------------------------------+
                              |
                              v
                      [ Container Process ]
```

---

### 1. What is runc?

**runc** is the reference implementation of the Open Container Initiative (OCI) runtime specification.

* **What it does:** It takes an OCI-compliant root filesystem and a configuration file (`config.json`), applies Linux isolation primitives (namespaces for process isolation, cgroups for resource limits, capabilities, and seccomp profiles), and executes the container process.
* **Characteristics:** It is a CLI utility, not a background service. Once it sets up the kernel primitives and spawns the container entrypoint, the `runc` process exits, handing supervision over to a lightweight shim.

---

### 2. What is containerd?

**containerd** is an open-source, industry-standard container daemon originally extracted from Docker and now maintained by the Cloud Native Computing Foundation (CNCF).

* **What it does:**
  * Pulls and pushes container images from registries.
  * Manages local image storage and layer snapshots.
  * Manages container lifecycle states (create, start, stop, pause, delete).
  * Manages container networking attachments.
  * Calls `runc` under the hood to start containers, using `containerd-shim` to keep container standard input/output open without keeping the main daemon attached.

---

### 3. How Docker Uses Them

Originally, Docker was a monolithic daemon (`dockerd`) handling everything from API requests down to kernel namespace configuration. Docker later modularized its architecture by donating components to the open-source community:

```
Docker CLI -> dockerd -> containerd -> containerd-shim -> runc -> Container
```

1. **Docker CLI:** Sends high-level commands (like `docker run`) to the Docker daemon.
2. **dockerd:** Handles user-facing features like Docker Compose, local volume management, image builds (`BuildKit`), and user authentication.
3. **containerd:** Receives instructions from `dockerd` to pull the requested image and prepare the root filesystem.
4. **runc:** Invoked by `containerd` to configure the Linux kernel primitives and launch the container process.

---

### 4. How Kubernetes (k8s) Uses Them

Kubernetes manages container workloads across clusters using the Kubelet on each node. The Kubelet communicates with container runtimes via the Container Runtime Interface (CRI), an API defined by Kubernetes.

```
Kubelet -> CRI API -> containerd (with CRI plugin) -> containerd-shim -> runc -> Pod Containers
```

* **Direct Integration:** `containerd` includes a built-in CRI plugin. The Kubelet talks directly to `containerd` over a gRPC socket, completely bypassing the need for Docker.
* **Why Kubernetes dropped Docker (dockershim removal):** In earlier versions, Kubernetes used a bridge called `dockershim` to translate CRI calls into Docker API calls, which then called `containerd`, which then called `runc`. Removing `dockershim` eliminated the unnecessary Docker daemon layer, reducing CPU and memory overhead while talking directly to `containerd`.

---

### Quick Comparison

| Aspect | runc | containerd |
| :--- | :--- | :--- |
| **Scope** | Low-level (individual container execution) | High-level (complete container lifecycle manager) |
| **Process Type** | Short-lived CLI command | Long-running system daemon |
| **Image Handling** | None (requires a pre-unpacked filesystem) | Pulls, verifies, unpacks, and stores images |
| **Primary Consumer** | `containerd`, `CRI-O` | `dockerd`, Kubernetes `kubelet` |
