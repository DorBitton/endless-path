---
date: 2026-10-01 13:30
tags:
  - flashcards/containers/docker
  - docker
  - containers
  - platform
  - triage
---
# Docker Container Lifecycle and CLI

## 🧠 The Core Concept

A container is not a virtual machine. It is an ordinary Linux process running directly on the host kernel, isolated by Linux Namespaces, constrained by Control Groups (cgroups), and rooted into an OverlayFS filesystem.

The Docker CLI manages the state machine governing these processes from creation to destruction:

```mermaid
stateDiagram-v2
    [*] --> Created : docker create / run
    Created --> Running : docker start
    Running --> Paused : docker pause (cgroup freezer)
    Paused --> Running : docker unpause
    Running --> Stopped : docker stop (SIGTERM -> 10s -> SIGKILL)
    Running --> Stopped : docker kill (immediate SIGKILL)
    Running --> Stopped : App exits (exit code recorded)
    Stopped --> Running : docker restart
    Stopped --> [*] : docker rm
```

### 1. How Containers Start Applications (ENTRYPOINT vs. CMD)
When a container launches, its entrypoint process is determined by a hierarchy of three layers:
1. **ENTRYPOINT:** Defines the fixed executable binary that runs when the container starts. It is not overridden by trailing CLI arguments; trailing CLI arguments are appended as arguments to the entrypoint binary. (To override, the user must explicitly pass `--entrypoint <binary>`).
2. **CMD:** Defines default arguments passed to the entrypoint, or the default executable if no ENTRYPOINT exists. Passing a trailing command on the CLI (`docker run <image> <command>`) completely overrides the Dockerfile `CMD`.
3. **CLI Arguments:** Trailing arguments provided at `docker run <flags> <image> <args>` override `CMD` and append to `ENTRYPOINT`.

| Dockerfile Configuration | CLI Invocation | Executed Process & Arguments |
| :--- | :--- | :--- |
| `ENTRYPOINT ["nginx"]`<br/>`CMD ["-g", "daemon off;"]` | `docker run my-nginx` | `nginx -g "daemon off;"` |
| `ENTRYPOINT ["nginx"]`<br/>`CMD ["-g", "daemon off;"]` | `docker run my-nginx -v` | `nginx -v` (CLI overrides CMD) |
| `ENTRYPOINT ["ping"]` | `docker run my-ping 8.8.8.8` | `ping 8.8.8.8` (CLI appends to ENTRYPOINT) |

### 2. Self-Healing Restart Policies
Docker containers can automatically restart when their processes exit or when the host daemon restarts. The policy is configured via `--restart <policy>`:

| Restart Policy | Non-Zero Exit Code (Crash) | Clean Exit (Code 0) | Stopped via `docker stop` | Host / Daemon Restarts |
| :--- | :---: | :---: | :---: | :---: |
| **`no`** (default) | No | No | No | No |
| **`on-failure`** | **Yes** | No | No | **Yes** (if failing) |
| **`always`** | **Yes** | **Yes** | No | **Yes** (even if manually stopped) |
| **`unless-stopped`** | **Yes** | **Yes** | No | **No** (if stopped before restart) |

- **`always` vs `unless-stopped` (The Production Gotcha):** Both policies restart crashed or exited containers. However, if an administrator deliberately stops a container with `docker stop web-app` and the host reboots:
  - Under **`always`**, Docker ignores the previous manual stop and restarts the container upon reboot.
  - Under **`unless-stopped`**, Docker recognizes the container was explicitly stopped prior to reboot and leaves it stopped.

### 3. Host Privileges and the Docker Socket
Running Docker commands without `sudo` requires adding the user to the local `docker` group:
```bash
sudo usermod -aG docker $USER
```
- **Security Reality:** The Docker daemon socket (`/var/run/docker.sock`) is owned by `root:docker`. Granting write access to this socket is equivalent to granting unlogged root privileges on the host. Any member of the `docker` group can execute a container that binds the host root filesystem (`docker run -v /:/host -it alpine chroot /host`) to gain root access over the host machine.

---

## 💻 Essential Commands & Operational Triage

### 1. Launching Containers
```bash
# Run a background (detached) container with host port binding and friendly name
docker run -d --name web-proxy -p 8080:80 nginx:alpine

# Run an ephemeral interactive shell (auto-deletes filesystem upon exit)
docker run -it --rm ubuntu:24.04 bash

# Run with an automatic restart policy (restarts unless manually stopped)
docker run -d --name redis-cache --restart unless-stopped redis:alpine

# Run with init process enabled (tini) to reap zombies and forward signals
docker run -d --name worker-app --init myapp:latest
```

### 2. Inspecting and Diagnosing Live Containers
```bash
# List active containers
docker ps

# List all containers (including stopped, crashed, and exited)
docker ps -a

# Stream standard output and standard error logs with timestamps
docker logs -f --tail 100 web-proxy

# Execute an interactive shell inside a running container
docker exec -it web-proxy sh

# Execute a one-off command non-interactively without entering the container
docker exec web-proxy ls -la /var/log

# Stream real-time cgroup CPU, memory, network, and block I/O utilization
docker stats

# Inspect container low-level JSON configuration, IP address, and mounts
docker inspect web-proxy --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
```

- **Safe Detachment (Ctrl-P, Ctrl-Q):** When attached to a container via `docker attach` or `docker run -it`, typing `Ctrl-C` sends `SIGINT` to Process ID 1, killing the container. Pressing the key combination `Ctrl-P` followed by `Ctrl-Q` detaches your terminal session cleanly without terminating the container process.

### 3. Stopping and Cleaning Up
```bash
# Graceful stop: sends SIGTERM, waits 10 seconds, then sends SIGKILL
docker stop web-proxy

# Immediate stop: sends SIGKILL immediately
docker kill web-proxy

# Remove an exited container (frees its writable upperdir layer)
docker rm web-proxy

# Force-remove a running container immediately
docker rm -f web-proxy

# Clean up all stopped containers, unused networks, and dangling images
docker system prune
```

---

## ⚠️ Common Pitfalls (The "Gotchas")

- **The PID 1 Signal Trap:** Inside a container PID namespace, the entrypoint process runs as Process ID 1 (PID 1). In Linux, PID 1 does not install default signal handlers. If the containerized application (such as Node.js, Python, or a Go binary) does not explicitly catch `SIGTERM`, `docker stop` hangs for exactly 10 seconds before Docker falls back to `SIGKILL`. This prevents orderly socket draining and database connection teardown. **Fix:** Handle `SIGTERM` in code, or run the container with the `--init` flag to inject a lightweight init system (`tini`).
- **Zombie Process Accumulation:** If an application process spawns subprocesses that terminate, and the parent fails to invoke `wait()` or `waitpid()`, the terminated children become zombie processes (`<defunct>`). Normally, the host `init` process adopts and reaps orphans. Inside a container without an init process, zombies remain in the container process table until host PID space is exhausted. **Fix:** Use `--init`.
- **Storage Leaks from Abandoned Containers:** Stopping a container with `docker stop` leaves its writable layer (`upperdir`) and log files on the host disk in `/var/lib/docker/`. Repeatedly executing automated tasks or scripts without `--rm` causes stopped containers to accumulate until host disk space or inodes are completely exhausted.
- **Port Allocation Collisions:** If `docker run -p 8080:80` fails with `bind: address already in use`, another process or container is already bound to port 8080 on the host interface. Run `ss -tulpn | grep 8080` on the host to identify the conflicting process.

---

## 🔗 Connections (Mental Mapping)

- **Execution Engine:** [[Container Runtimes (containerd and runc)]] (How dockerd passes execution to containerd and runc).
- **Filesystem Layers:** [[Container Storage and OverlayFS]] (How the container writable layer is created and discarded).
- **Image Blueprints:** [[Container Images and Multi-Arch Manifests]] (How images are tagged, pulled, and verified).
- **Application Packaging:** [[Containerizing Applications]] (How Dockerfiles define ENTRYPOINT, CMD, and dependencies).
- **Networking:** [[Container Networking and CNM]] (How container endpoints attach to bridge networks).
- **Kernel Isolation:** [[Linux Namespaces]] (How UTS, PID, NET, and MNT isolate container processes).
- **Signal Handling:** [[Process Control]] (How Linux processes respond to SIGTERM, SIGKILL, and SIGSTOP).

---

## ⚡ Active Recall Flashcards

What is the operational difference between ENTRYPOINT and CMD in a Dockerfile?::ENTRYPOINT sets the default executable that trailing CLI arguments append to; CMD sets default arguments that trailing CLI arguments completely overwrite.

How do the restart policies 'always' and 'unless-stopped' differ after a host reboot?::`always` restarts containers even if they were manually stopped prior to reboot; `unless-stopped` keeps manually stopped containers stopped.

What key combination allows an engineer to detach from an interactive container terminal without stopping the container?::`Ctrl-P, Ctrl-Q` (detaches without sending SIGINT).

What signal sequence does docker stop send to a running container?::It sends `SIGTERM`, waits a default 10-second grace period for cleanup, and then sends `SIGKILL`.

Why does docker stop often hang for 10 seconds on poorly configured container applications?::The application runs as Process ID 1 (PID 1) without an explicit `SIGTERM` signal handler, ignoring the termination request until Docker forces `SIGKILL`.

How does running a container with the --init flag prevent zombie process accumulation?::It inserts a lightweight init system (`tini`) as Process ID 1 to forward signals and reap orphaned child processes.

Why is adding an unprivileged user to the host docker group considered a severe security risk?::Access to `/var/run/docker.sock` allows mounting the host root filesystem into a container, granting full root privileges over the host.
