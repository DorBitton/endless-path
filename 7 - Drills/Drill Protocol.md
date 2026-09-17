---
date: 2026-09-03 22:00
tags:
  - guide
  - meta
  - drills
---
# 🏋️ Drill Protocol

Drills are hands-on practice for **composition skills**: writing a script, a unit file, a one-liner, from a blank terminal, under time. Flashcards keep atoms warm (a `for` loop, a flag). Drills train combining atoms under a fresh requirement, which is what an interview and a 3 AM incident both demand.

This document is both the human docs and the AI instructions. Any AI assistant (Claude Code, Gemini CLI, or another) running a drill follows the protocol below exactly.

---

## 📂 Files

| File | Purpose |
| :--- | :--- |
| `7 - Drills/Drill Protocol.md` | This document. The rules. |
| `7 - Drills/Drills - <Language>.md` | Skill registry per language (e.g. `Drills - Bash.md`). Tagged `#review` so the Obsidian Spaced Repetition plugin schedules "time to drill". |
| `7 - Drills/Drill Log.md` | Append-only log of every attempt. Drives skill selection and the difficulty ladder. |
| `7 - Drills/attempts/` | Where solutions are written: `YYYY-MM-DD-<skill-slug>.<ext>`. |

---

## 🚀 How the user runs a drill (minimum friction)

1. Open a terminal anywhere and start the assistant (`claude`, then `/drill`, or `/drill bash`, or `/drill bash loops`). In Gemini CLI, run it from the vault directory and type `drill`.
2. A single task appears with a `Read first:` line naming the note (and sections) that covers the skill, and a file path to write into.
3. Open the note, read the named sections, then **close it**. Theory goes in before the attempt, not during it.
4. Write the solution in a real terminal or editor from memory, with the note and the assistant window closed. Time budget: 10 minutes. Save it. Type `done` (or paste the code directly into the chat).
5. The assistant verifies, grades, logs, and shows the reference solution. Each miss points back to the note section it came from. Close the terminal. Total: 15 to 20 minutes, 2 to 3 times a week.

---

## 🤖 AI Protocol (follow in order)

### Step 0: Load state
- Read `7 - Drills/Drill Log.md` (last 20 lines are enough).
- Read the registry for the requested language (default: Bash). If the user named a skill, use it; otherwise pick by priority: a skill whose last result was FAIL, then the skill drilled least recently, then the lowest level.

### Step 1: Generate one task
- Exactly one task. Solvable in 5 to 15 lines at the skill's current level.
- Must differ from the last three logged tasks for that skill. The log is the memory; vary the surface (different files, services, inputs, twists), same underlying skill.
- Difficulty ladder:
  - **Level 1:** one construct, clean input.
  - **Level 2:** two constructs combined, one validation requirement.
  - **Level 3:** interview-shaped mini-task with a twist (malformed input, missing file, argument-driven target, must be idempotent).
- Output format, nothing else:

```
DRILL · <language> · <skill> · Level <n>
Read first: [[<note from the registry's Note column>]] · sections: <the 1 to 3 section headings the task draws on>. Close it before writing.
Task: <2 to 4 sentences>
Constraints: <bullet list, 2 to 4 items>
Write to: 7 - Drills/attempts/<YYYY-MM-DD>-<skill-slug>.<ext>
Type "done" when finished (or paste the code here).
```

- **Read first, then closed book.** The `Read first` line is the only theory the drill hands out. It names the note and the sections the task needs, never the task's answer. The user reads, closes the note, and writes from memory. A task must be solvable from those sections; if it needs something the note does not cover, fix the task or the note, not the drill.
- **Never show a solution, hint, or partial code before the attempt.** If the user asks for a hint, name the note section again, never syntax.

### Step 2: Wait for the attempt
- Do nothing until the user says `done` or pastes code. If they paste, save it to the attempt path yourself.

### Step 3: Verify (automatic first, review second)
- **Automatic:**
  - Bash: `bash -n <file>` for syntax; `shellcheck <file>` if installed; then create any fixtures under `/tmp/drill/` (fake log, fake config, fake input) and run the script against them. Compare actual output to expected.
  - Python: `python -m py_compile`, then run against fixtures; `ruff` if installed.
  - Go: `go vet`, `go build`, then run or `go test` against fixtures.
- **Review** the code against a short rubric: correctness, handles the stated edge case, quoting and safety (`"$var"`, `set -euo pipefail` where appropriate, `read -r`), idiomatic construct choice, readability. Do not nitpick style beyond that.

### Step 4: Grade and teach
- Grade on the skill being drilled, not on the whole script:
  - **PASS**: the drilled construct is correct and safe. Cosmetic output differences (spacing, punctuation, wording) never lower a grade.
  - **PARTIAL**: the drilled construct works but a real gotcha inside that skill was missed (subshell loss, word splitting, unquoted expansion, off-by-one in the loop logic).
  - **FAIL**: the drilled construct is wrong, crashes, or is unsafe.
- Misses outside the drilled skill (exit codes in a loops drill, formatting, spec details that do not touch the construct) go in a separate "Also noticed" line. They do not affect the grade or the log's Missed column.
- Show, in this order: what ran and what happened, the misses (each one sentence, mechanism first, ending with the note section that covers it, e.g. `[[Bash Loops]] > Common Pitfalls`), the "Also noticed" line if any, the reference solution, one sentence on why the reference chose its construct.
- Keep it under 25 lines. No lecture.

### Step 5: Log
Append one row to `7 - Drills/Drill Log.md`:

```
| 2026-09-03 | bash | loops | 2 | Count "error" lines in a log, count must survive the loop | PARTIAL | Piped into while: counter lost in subshell |
```

- Promote a skill one level in the registry after two consecutive PASS at the current level. Demote after two consecutive FAIL.

### Step 6: Feed the deck
- For each miss, propose one flashcard candidate in the standard `Prompt::Answer` format (structure card if it was a "why", production card if it was syntax), and name the note it belongs in (the skill's note from the registry). The user decides. Do not write into `6 - Main notes/` without a greenlight.

---

## 🧭 Rules of the game
- One drill per invocation. No "one more".
- The AI never types the solution first. The user does.
- Theory before, not during: the note is read before the attempt and closed while writing. The note is the memory, the drill is the test.
- Verification is grounded: run the code. Bash, Python, and Go are all executable; opinions come after evidence.
- Fixtures live in `/tmp/drill/`, never in the vault.
- Missed retrievals are the best source of flashcards. That is how drills move the deck forward instead of the deck guessing.
