---
date: 2026-10-11 13:30
tags:
  - flashcards/go/strings
  - go
  - programming
  - syntax
  - sre
---
# Go Strings and Runes

## 🧠 The Core Concept

- **Strings in Go:** A string is an immutable sequence of bytes. By standard convention, Go source code and strings are encoded in UTF-8, but strings can contain any arbitrary byte data.
  - **Immutability:** Once initialized, the contents of a string cannot be modified. Reassigning a string variable simply points it to a new string value; it does not alter the original byte sequence.
  - **Zero Value:** `""` (the empty string, which contains 0 bytes).
- **Interpreted vs Raw String Literals:**
  - **Interpreted String Literals (`"..."`):** Delimited by double quotes. They expand backslash escape sequences such as `\n` (newline), `\t` (tab), `\"` (double quote), and `\\` (backslash). They cannot span multiple lines directly without escape sequences.
  - **Raw String Literals (`` `...` ``):** Delimited by backticks. They preserve text exactly as written, including actual newlines and double quotes. Escape characters are ignored. They cannot contain a backtick character.
- **Runes vs Bytes:**
  - **`byte`:** A language alias for `uint8`. Represents a single 8-bit byte.
  - **`rune`:** A language alias for `int32`. Represents a single **Unicode code point** (which takes between 1 and 4 bytes in UTF-8).
  - **Rune Literals:** Delimited by single quotes (for example, `'a'`, `'⌘'`, `'\n'`, `'\u0061'`).
  - **Quote Rules:** Single quotes and double quotes are not interchangeable in Go. Single quotes define a `rune`, double quotes define a `string`.
  - **Expressing Intent:** Always use `rune` instead of `int32` when working with characters or Unicode code points so your code's purpose is immediately clear.

## 💻 Syntax & Minimal Example

```go
package main

import "fmt"

func main() {
	// Interpreted string with escape characters
	interpreted := "Status: OK\n\"Healthy\""

	// Raw string literal preserves newlines and quotes verbatim
	raw := `{"status": "ok",
"healthy": true}`

	// Rune (Unicode code point) vs Byte
	var symbol rune = '⌘' // multi-byte UTF-8 character (int32)
	var ascii byte = 'A'  // single-byte character (uint8)

	fmt.Println(interpreted)
	fmt.Println(raw)
	fmt.Printf("Symbol: %c (code point: %U), Byte: %c\n", symbol, symbol, ascii)
}
```

## ⚠️ Common Pitfalls (The "Gotchas")

- **String Indexing Returns Bytes, Not Characters:** Indexing a string directly (`s[0]`) returns a `byte` (`uint8`), not a character or `rune`. If a string contains multi-byte UTF-8 characters (like emojis, non-Latin alphabets, or special symbols), indexing splits the byte sequence and returns an incomplete byte fragment. Use `for _, r := range s` or convert the string to `[]rune(s)` to safely inspect Unicode code points.
- **Quotes Are Not Interchangeable:** Writing `'hello'` causes a compile error (`more than one character in rune literal`). Single quotes are strictly reserved for individual runes.
- **String Immutability and Memory Allocation:** Because strings are immutable, writing `s[0] = 'x'` is a compile error. Concatenating strings repeatedly with `+` inside a tight loop allocates a new string buffer on every iteration. Use `strings.Builder` in production hot paths to avoid heap churn.

## 🔗 Connections (Mental Mapping)

- **Variable Declarations & Zero Values:** [[Go Variable Declarations and Zero Values]]
- **Numeric & Boolean Types:** [[Go Predeclared Numeric and Boolean Types]]
- **Real-World Mental Model:** Think of a string as a read-only window into a sequence of raw bytes. A `byte` is a single 8-bit memory slot, while a `rune` is a complete Unicode code point that may span up to 4 bytes in memory.

## ⚡ Active Recall Flashcards

What does indexing a string directly (e.g. s[0]) return in Go?::A single byte (uint8), not a rune or character; multi-byte UTF-8 characters will be sliced into raw bytes

What is the semantic difference between a byte and a rune in Go?::A byte is an alias for uint8 (1 raw byte); a rune is an alias for int32 representing a full Unicode code point (1 to 4 bytes in UTF-8)

Why are single quotes and double quotes not interchangeable in Go?::Single quotes denote a rune literal (int32 code point), whereas double quotes denote an interpreted string literal

What is the primary difference between interpreted strings ("") and raw string literals (``)?::Interpreted strings process escape sequences (\n, \t); raw strings preserve text verbatim including newlines and double quotes with no escaping

Why does mutating a string directly via s[0] = 'a' fail in Go?::Strings in Go are immutable; their underlying byte sequences cannot be modified after creation
