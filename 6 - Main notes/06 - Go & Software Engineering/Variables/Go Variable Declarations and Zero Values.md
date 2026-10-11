---
date: 2026-10-11 13:30
tags:
  - flashcards/go/variables
  - go
  - programming
  - syntax
  - sre
---
# Go Variable Declarations and Zero Values

## 🧠 The Core Concept

- **The Zero Value Guarantee:** In Go, memory is never left uninitialized. If you declare a variable without providing an initial value, Go assigns its type-specific default "zero value". This prevents data leaks, non-deterministic bugs, and reading stale bytes from previously freed stack or heap memory.
  - Numeric types (`int`, `float`, `byte`, `rune`): `0` or `0.0`
  - Booleans (`bool`): `false`
  - Strings (`string`): `""` (empty string)
  - Reference and pointer types (pointers, slices, maps, channels, functions, interfaces): `nil`
- **Declaration Styles:**
  - `var x int`: Used when you want the default zero value.
  - `var x int = 10`: Explicit type and assignment. Useful when the desired type differs from the default literal type (for example, storing an `int64` instead of standard `int`).
  - `var x = 10`: Type inference with package or function scope.
  - `x := 10`: Short declaration operator. Only allowed inside function bodies (local scope).
  - `var ( ... )`: Declaration block used to group related package or module-level variables.
- **Compiler Rules:**
  - Every local variable declared inside a function must be read, or compilation fails.
  - The blank identifier (`_`) explicitly discards unused values (such as unwanted return values).

## 💻 Syntax & Minimal Example

```go
package main

import "fmt"

var environment = "production" // package scope requires var

func main() {
	var requestCount int  // zero value: 0
	var isDegraded bool   // zero value: false
	latencyLimit := 250.0 // short declaration (inferred float64)

	// := allows reusing requestCount because err is newly declared
	requestCount, err := increment(requestCount)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

	fmt.Printf("[%s] count=%d degraded=%t limit=%.1f\n",
		environment, requestCount, isDegraded, latencyLimit)
}

func increment(n int) (int, error) {
	return n + 1, nil
}
```

## ⚠️ Common Pitfalls (The "Gotchas")

- **The `:=` Variable Shadowing Trap:** Writing `err := doSomething()` inside an `if` or `for` block creates a brand new `err` scoped strictly to that block. The outer `err` variable remains unmodified, causing subsequent error checks in the parent scope to miss the failure entirely.
- **Short Declaration Scope Limitation:** `:=` cannot be used outside functions at package scope. Using `:=` at package level causes a syntax error.
- **Multi-Variable `:=` Requirements:** You can only reuse an existing variable name with `:=` if at least one variable on the left-hand side is new in the current scope. If all variables already exist, the compiler reports `no new variables on left side of :=`.
- **Unused Local Variables Stop Builds:** The compiler treats unused local variables as fatal compile-time errors to prevent dead code and memory leaks in production binaries.

## 🔗 Connections (Mental Mapping)

- **Numeric & Boolean Types:** [[Go Predeclared Numeric and Boolean Types]]
- **Strings, Runes, and Bytes:** [[Go Strings and Runes]]
- **Real-World Mental Model:** Think of a variable in Go as a strictly labeled storage locker. When the locker is built without contents, the janitor immediately wipes it clean to its zero state so no leftover garbage from the prior tenant remains.

## ⚡ Active Recall Flashcards

What does Go do when a variable is declared without an explicit initial value?::It initializes the variable to its default zero value (e.g. 0, false, "", or nil); memory is never left uninitialized with garbage bytes

Where is the short declaration operator := prohibited in Go?::At package scope; it is only valid inside function bodies

What is the requirement when using := with multiple variables where at least one was already declared?::At least one variable on the left side of := must be new to that scope

Why is variable shadowing with := dangerous in nested blocks (such as if or for)?::It creates a new inner variable instead of assigning to the outer one, which often masks errors by silently shadowing an outer err variable

How does the Go compiler handle an unused local variable versus an unused package level variable?::Unused local variables trigger a compile error, while unused package level variables are permitted
