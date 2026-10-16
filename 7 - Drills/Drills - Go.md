---
date: 2026-10-15 12:58
tags:
  - review
  - drills
  - go
  - k8s
---
# Drills - Go

Skill registry for Go drills, covering core language mechanics and practical Kubernetes / cloud-native systems patterns. Read by the AI following [[Drill Protocol]]. When this note shows up in Spaced Repetition reviews, it means: run a Go drill today.

Levels:
* **Level 1:** Single construct, clean inputs, standard library.
* **Level 2:** Two constructs combined, edge cases, error handling or type conversions.
* **Level 3:** Production or interview-shaped twist (concurrency, cancellations, memory safety, or Kubernetes object manipulation).

Promotion rule: Two consecutive PASS at current level promotes to next level; two consecutive FAIL demotes.

---

## 🛠️ Track 1: Go Core Language Mechanics

| Skill (slug) | Status | What mastery looks like | Level | Note |
| :--- | :---: | :--- | :---: | :--- |
| `toolchain` | Unlocked | Initialize a module with `go mod init`, run package with `go run .`, compile with `go build`, tidy dependencies | 1 | [[Go Toolchain and Running Code]] |
| `vars-zero` | Unlocked | Declare typed variables, leverage zero values safely, avoid `:=` shadowing traps across blocks | 1 | [[Go Variable Declarations and Zero Values]] |
| `numeric-types` | Unlocked | Explicit type conversion, integer overflow awareness, byte vs rune conversions | 1 | [[Go Predeclared Numeric and Boolean Types]] |
| `strings-runes` | Unlocked | Iterate strings by rune vs byte, slice strings without cutting multi-byte UTF-8 code points | 1 | [[Go Strings and Runes]] |
| `slices` | Locked | Initialize with `make`, predict `len` vs `cap`, avoid sub-slice memory leaks, append safely | 1 | [[Go Slices and Maps]] |
| `maps` | Locked | Hash map lookups with the `comma ok` idiom, safe deletion, using `map[string]struct{}` as a set | 1 | [[Go Slices and Maps]] |
| `control-flow` | Locked | Four-way `for` loops, loop variable capture in closures, clean multi-case `switch` | 1 | [[Go Control Structures and Shadowing Traps]] |
| `functions-defer` | Locked | Multiple return values, variadic inputs, `defer` for resource release (files, locks, connections) | 1 | [[Go Functions and Defer Cleanup]] |
| `pointers` | Locked | Dereferencing, mutation via pointer receivers, distinguishing `nil` pointer from zero value | 1 | [[Go Pointers and Memory Mechanics]] |
| `structs` | Locked | Struct composition, field initialization, anonymous structs, embedding without inheritance | 1 | [[Go Structs and Data Modeling]] |
| `interfaces` | Locked | Duck typing, implementing standard `io.Reader`/`io.Writer`, type assertions `val, ok := i.(T)` | 1 | [[Go Methods and Interfaces]] |
| `errors` | Locked | Custom error types, wrapping with `%w`, inspection via `errors.Is` and `errors.As` | 1 | [[Go Error Handling in Production]] |

---

## ☸️ Track 2: Go for Kubernetes & Platform Engineering

These drills bridge Go syntax to Kubernetes controllers, manifest manipulation, and cloud runtime mechanics. Unlocked only when both the Go concept and the Kubernetes concept notes exist.

| Skill (slug) | Status | What mastery looks like | Level | Note |
| :--- | :---: | :--- | :---: | :--- |
| `k8s-manifest-json` | Locked | Define Go structs with `json:"..."` tags matching Kubernetes manifests; unmarshal and inspect spec fields | 1 | [[Go Structs and Data Modeling]] |
| `k8s-optional-pointers` | Locked | Model Kubernetes optional spec fields with pointers (`*int32`, `*bool`) to tell `nil` (unset) from `0`/`false` | 1 | [[Go Pointers and Memory Mechanics]] |
| `k8s-conditions-filter` | Locked | Write a function that iterates `.status.conditions`, handles polarity (`Ready=True` vs `MemoryPressure=False`), and reports health | 1 | [[Kubernetes API and Object Model]] |
| `k8s-errors-flow` | Locked | Distinguish not-found errors from network failures with `errors.Is`, matching `apierrors.IsNotFound` control flow | 1 | [[Go Error Handling in Production]] |
| `k8s-context-timeout` | Locked | Wrap simulated API server calls with `context.WithTimeout`, handle `ctx.Done()`, prevent goroutine leaks | 1 | [[Go Context and Lifecycle Cancellation]] |
| `k8s-reconcile-sig` | Locked | Implement a controller reconciliation function `Reconcile(ctx, req) (Result, error)` returning retry or stop signals | 1 | [[Kubernetes API and Object Model]] |
| `k8s-worker-pool` | Locked | Build a concurrent worker pool consuming from a buffered channel using `sync.WaitGroup` to simulate a controller queue | 1 | [[Go Concurrency - Goroutines, Channels, and Sync]] |

---

## Source Notes
* Master Go Map: [[Book Map - Learning Go (2nd Edition)]]
* Master Kubernetes Map: [[Book Map - Kubernetes in Action (2nd Edition)]]
* Core Variables: [[Go Variable Declarations and Zero Values]]
* API & Object Model: [[Kubernetes API and Object Model]]
