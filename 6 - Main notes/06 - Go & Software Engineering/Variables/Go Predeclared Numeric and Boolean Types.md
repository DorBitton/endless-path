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

- **Strict Static Typing:** Go has no automatic type promotion or implicit conversions between variables. Even if types share the same byte size on your CPU architecture (such as `int` and `int64` on 64-bit systems), you cannot perform arithmetic or comparisons across them without an explicit type cast (for example, `int64(x) + y` or `float64(x) + y`). Converting a float to an integer (e.g. `int(30.2)`) truncates the fractional portion towards zero (`30`).
- **Numeric Types:**
  - **Signed Integers:** `int8` (-128 to 127), `int16`, `int32`, `int64`, and `int`.
  - **Unsigned Integers:** `uint8` (0 to 255, aliased as `byte`), `uint16`, `uint32`, `uint64`, `uint`, and `uintptr`.
  - **Platform-Dependent `int` and `uint`:** On a 32-bit machine, `int` is 32 bits; on a 64-bit machine, `int` is 64 bits. By default, use `int` unless working with fixed-size network protocols, binary serializations, or hardware interfaces.
  - **Floating Point:** `float32` and `float64` (default literal type is `float64`).
- **Boolean Type & Truthiness:**
  - `bool` holds only `true` or `false` (zero value `false`).
  - Go has no concept of "truthiness": nonzero numbers or non-empty strings cannot evaluate as booleans.
  - No other type can be converted to a `bool`, implicitly or explicitly (writing `bool(1)` or `bool("true")` triggers a compile error). You must use explicit comparison operators (`==`, `!=`, `>`, `<`, `<=`, `>=`), such as `x == 0` or `s == ""`.
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
	binaryMask := 0b1111_0000 // literal with separator
	var count int = 10
	var ratio float64 = 30.2

	// Explicit conversions (no automatic promotion; float to int truncates)
	sumFloat := float64(count) + ratio  // 40.2
	sumInt := count + int(ratio)         // 40
	cleared := binaryMask &^ 0b0101_0000 // bit clear operator (&^)

	// No truthiness: must compare explicitly to get a bool
	isEmpty := count == 0

	fmt.Printf("float=%.1f int=%d cleared=%08b empty=%t\n",
		sumFloat, sumInt, cleared, isEmpty)
}
```

## ⚠️ Common Pitfalls (The "Gotchas")

- **Silent Integer Overflow Wraparound:** Go integers overflow and underflow silently without throwing a panic or runtime error (for example, `uint8(255) + 1` wraps to `0`). Never rely on assumptions like `x + 1 > x` in metric counters or loop conditions.
- **No Implicit Type Promotion:** Attempting `myInt64 + myInt` stops compilation immediately with a type mismatch error. Every cross-type calculation requires explicit casting.
- **No Truthiness or Type Casting to `bool`:** Writing `if count` or `bool(1)` fails to compile. Go provides no truthy evaluations and permits no conversion from numbers or strings to `bool`. Always use explicit comparisons (`count != 0`).
- **Float Truncation on Integer Conversion:** Converting a float to an integer via `int(f)` truncates decimals towards zero rather than rounding (`int(30.9)` becomes `30`).
- **`++` and `--` are Statements, Not Expressions:** You cannot write `y = x++` or pass `x++` into a function argument. They are standalone statements that return nothing. Prefix increment (`++x`) is invalid syntax.
- **The Bit Clear Operator (`&^`):** In `z = x &^ y`, Go clears (sets to 0) every bit in `x` wherever the corresponding bit in `y` is 1.

## 🔗 Connections (Mental Mapping)

- **Variable Declarations & Zero Values:** [[Go Variable Declarations and Zero Values]]
- **Strings, Runes, and Bytes:** [[Go Strings and Runes]]
- **Real-World Mental Model:** Think of Go types as fixed-size physical memory slots. The compiler refuses to squeeze or stretch bits between slots unless you explicitly cast them.

## ⚡ Active Recall Flashcards

What happens when an integer exceeds its maximum limit during arithmetic in Go?::It wraps around silently without crashing or throwing a runtime panic (e.g. uint8 255 + 1 becomes 0)

Why does `var x int64 = 10; var y int = 20; _ = x + y` fail to compile?::Go requires explicit type conversion between distinct numeric types; there is no implicit type promotion

Can an integer or string be converted to a bool in Go (e.g. bool(1))?::No; Go has no truthiness and allows no conversions to bool; you must use comparison operators like x != 0 or s == ""

What happens to the decimal portion when converting a float to an int in Go (e.g. int(30.9))?::It is truncated towards zero (drops .9 and becomes 30), not rounded

What does the bit clear operator &^ do in Go?::It acts as AND NOT: for `z = x &^ y`, each bit in z is set to 0 if the corresponding bit in y is 1, otherwise it keeps x's bit

Why are expressions like `y = x++` or `++x` invalid in Go?::Increment (++) and decrement (--) in Go are postfix statements, not expressions, and return no value

What characters prefix binary, octal, and hexadecimal integer literals in Go?::0b for binary, 0o for octal, and 0x for hexadecimal
