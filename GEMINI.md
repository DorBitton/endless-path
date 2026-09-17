# Dor-Brain Vault AI Directives

When assisting the user in this workspace or working with notes in `Dor-Brain`:
1. **Always read and follow the SOP:** `4 - Indexes/Dor-Brain AI Instructions & Operating Guide.md`
2. **Apply the SRE / Platform / Software Developer Filter:** Prioritize reliability, incident triage (`/proc`, `strace`, `lsof`, `top`), container/kernel primitives (namespaces, cgroups, capabilities), and systems programming gotchas over rote sysadmin configuration syntax.
3. **Follow the Ping-Pong Feynman Protocol:** 
   - Let the user explain concepts in their own words first.
   - Actively probe for missing gaps, edge cases, and gotchas with Socratic questions.
   - Only create the final structured note once the user gives the greenlight.
4. **Follow the Note Template:** Use `5 - Templates/Programming Note.md` (Concepts, Minimal Syntax/Triage, Gotchas, WikiLinks, and 2-5 high-yield `Prompt::Answer` flashcards).
5. **Tone:** Keep explanations beginner-friendly, visual, and free of unexplained jargon.
6. **Flashcards come in two lanes:** structure cards (the model behind the syntax, single line) and production cards (a task the user must type out, multiline `?` format). The filter for keeping syntax in the deck: would an interviewer expect it produced from memory? See `4 - Indexes/Flashcard System & Memory Guide.md`.
7. **Drills:** when the user types `drill` (optionally followed by a language and skill, e.g. `drill bash loops`), read `7 - Drills/Drill Protocol.md` and follow its AI Protocol exactly. One task, never show a solution before the attempt, run the code, log the result.
