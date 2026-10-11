---
date: 2026-10-11 13:30
tags:
  - flashcards/go/types
  - go
  - programming
  - syntax
  - sre
---
# Go Predeclared Numeric and Boolean Types

## 🧠 The Core Concept

- **Strict Static Typing:** Go has no automatic type promotion or implicit conversions. Even if types share the same byte size on your CPU architecture (such as `int` and `int64` on 64-bit systems), you cannot perform arithmetic or comparisons across them without an explicit type cast (e.g. `int64(myInt)`).
- **Numeric Types:**
  - **Signed Integers:** `int8` (-128 to 127), `int16`, `int32`, `int64`, and `int`.
  - **Unsigned Integers:** `uint8` (0 to 255, aliased as `byte`), `uint16`, `uint32`, `uint64`, `uint`, and `uintptr`.
  - **Platform-Dependent `int` and `uint`:** On a 32-bit machine, `int` is 32 bits; on a 64-bit machine, `int` is 64 bits. By default, use `int` unless working with fixed-size network protocols, binary serializations, or hardware interfaces.
  - **Floating Point:** `float32` and `float64` (default literal type is `float64`).
- **Boolean Type:**
  - `bool` holds only `true` or `false` (zero value `false`). Go has no truthy or falsy evaluations: conditionals require a boolean expression (e.g. `if count > 0`, not `if count`).
- **Literal Formats and Readability:**
  - Literals are untyped until assigned or used in a typed context.
  - Number base prefixes: `0b` (binary), `0o` (octal), `0x` (hexadecimal). Default is base 10.
  - Digit separators (`_`): Underscores can be placed between digits to improve readability (e.g. `1_000_000`, `0b1010_1100`). They cannot appear at the beginning or end of a number.
  - Hexadecimal floating point literals use the prefix `0x` and exponent `p` (e.g. `0x12.34p5`).
- **Operators:**
  - Arithmetic: `+`, `-`, `*`, `/`, `%`
  - Bitwise: `<<`, `>>`, `&` (AND), `|` (OR), `^` (XOR / bitwise NOT), `&^` (bit clear / AND NOT)
  - Increment/Decrement: `++` and `--` exist only as postfix statements.

## 💻 Syntax & Minimal Example

```go
package main

import "fmt"

func main() {
	binaryMask := 0b1111_0000 // binary with readability separator
	hexPort := 0x1f90         // hexadecimal literal (8080)
	var baseCount int = 42
	var totalCount int64 = 1000

	// Explicit type conversion required:
	combined := int64(baseCount) + totalCount

	// Bit clear operator (&^): clears bits matching the second operand
	cleared := binaryMask &^ 0b0101_0000

	// Postfix statement only (no expression assignment)
	baseCount++

	fmt.Printf("combined=%d port=%d cleared=%08b base=%d\n",
		combined, hexPort, cleared, baseCount)
}
```

## ⚠️ Common Pitfalls (The "Gotchas")

- **Silent Integer Overflow Wraparound:** Go integers overflow and underflow silently without throwing a panic or runtime error (for example, `uint8(255) + 1` wraps to `0`). Never rely on assumptions like `x + 1 > x` in metric counters or loop conditions.
- **No Implicit Type Promotion:** Attempting `myInt64 + myInt` stops compilation immediately with a type mismatch error. Every cross-type calculation requires explicit casting.
- **`++` and `--` are Statements, Not Expressions:** You cannot write `y = x++` or pass `x++` into a function argument. They are standalone statements that return nothing. Prefix increment (`++x`) is invalid syntax.
- **The Bit Clear Operator (`&^`):** In `z = x &^ y`, Go clears (sets to 0) every bit in `x` wherever the corresponding bit in `y` is 1.

## 🔗 Connections (Mental Mapping)

- **Variable Declarations & Zero Values:** [[Go Variable Declarations and Zero Values]]
- **Strings, Runes, and Bytes:** [[Go Strings and Runes]]
- **Real-World Mental Model:** Think of Go types as fixed-size physical memory slots. The compiler refuses to squeeze or stretch bits between slots unless you explicitly cast them.

## ⚡ Active Recall Flashcards

What happens when an integer exceeds its maximum limit during arithmetic in Go?::It wraps around silently without crashing or throwing a runtime panic (e.g. uint8 255 + 1 becomes 0)

Why does `var x int64 = 10; var y int = 20; _ = x + y` fail to compile?::Go requires explicit type conversion between distinct numeric types; there is no implicit type promotion

What does the bit clear operator &^ do in Go?::It acts as AND NOT: for `z = x &^ y`, each bit in z is set to 0 if the corresponding bit in y is 1, otherwise it keeps x's bit

Why are expressions like `y = x++` or `++x` invalid in Go?::Increment (++) and decrement (--) in Go are postfix statements, not expressions, and return no value

What characters prefix binary, octal, and hexadecimal integer literals in Go?::0b for binary, 0o for octal, and 0x for hexadecimal
