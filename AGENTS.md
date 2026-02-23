# AGENTS.md

## Agent change notes

- Prefer shared interaction helpers in `lib/Modal_Core.ahk` over inline `SendInput` loops:
  - `Modal_SendKey(keys, count := 1)`
  - `Modal_SendSequence(sequence, count := 1, delimiter := "|")`
  - `Modal_SendAndWait(keys, waitMs := 50, count := 1)`
  - `Modal_ClickButton(button := "Left", count := 1)`
- For app-specific commands that require multiple keypresses, use `|`-delimited bindings so `Modal_SendAction` can execute them as a sequence.
- Keep changes minimal and localized to existing libraries (`Modal.ahk`, `lib/Modal_Core.ahk`, `lib/Modal_Navigation.ahk`, `lib/Modal_Actions.ahk`) unless a broader refactor is explicitly requested.
