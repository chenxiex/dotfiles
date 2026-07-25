# AGENTS.md

## File Write Policy

Agents may write files only in:

- The current project directory and its subdirectories
- `/tmp`
- `/var/tmp`
- `$TMPDIR`, if set

Agents must not write outside these locations.

In particular, agents must not write to:

- `~`, `$HOME`, `/home/*`, `/Users/*`
- `~/.config`, `~/.local`, `~/.ssh`, `~/.gnupg`
- `/etc`, `/usr`, `/bin`, `/sbin`, `/lib`, `/opt`
- Other projects, repositories, or unrelated directories

Agents must not bypass this rule with `../`, absolute paths, symlinks, bind mounts, or generated paths that resolve outside the allowed locations.

If the current project directory is unclear, agents must treat the current working directory at task start as the project directory.

If a task appears to require writing outside the allowed locations, stop and report the issue instead of performing the write.

## Global Codex Instructions

When using Plan mode or otherwise asking the user for input, wait indefinitely for the user's answer. Do not set or pass `autoResolutionMs` to `request_user_input` unless the user explicitly asks for auto-resolution in the current thread. If user input is required before continuing, ask without an auto-resolve timeout. If user doesn't provide an input, repeat the questions and stop what you are doing and wait for user input.
