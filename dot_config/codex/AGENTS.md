# AGENTS.md

## Style Guide

Follow the project's documented conventions or established style. Where the project has no applicable rule, use these defaults:

- Use spaces with an indentation width of 4.
- Do not hard-wrap generated documents at a fixed line width.
- Use progressive disclosure in documentation: place details near the code or topic they describe, and keep repository-level documents focused on navigation and shared guidance rather than collecting all details there.

## File Write Policy

Agents may write files only in:

- The current project directory and its subdirectories
- `/tmp`
- `/var/tmp`
- `$TMPDIR`, if set

Agents must not write outside these locations.

In particular, except for the explicitly allowed paths above, agents must not write to:

- `~`, `$HOME`, `/home/*`, `/Users/*`
- `~/.config`, `~/.local`, `~/.ssh`, `~/.gnupg` (Except for `~/.config/codex`)
- `/etc`, `/usr`, `/bin`, `/sbin`, `/lib`, `/opt`
- Other projects, repositories, or unrelated directories

Agents must not bypass this rule with `../`, absolute paths, symlinks, bind mounts, or generated paths that resolve outside the allowed locations.

If the current project directory is unclear, agents must treat the current working directory at task start as the project directory.

If a task appears to require writing outside the allowed locations, stop and report the issue instead of performing the write.

## Sandbox-Blocked Commands

If a test, smoke test, real-device probe, dependency installation, or similar command cannot run because it is blocked by the sandbox, agents must clearly state the specific permission being blocked—for example, "requires write access to the `/cache` path"—and then request elevated permission to run the command.

Agents must not skip any necessary probing or verification because of a sandbox restriction. Agents must not bypass the restriction by redirecting caches, installation paths, or other command data to a non-designated directory such as `/tmp`.

## Sandbox or container Commands

Sandbox or container commands like Flatpak or Docker may fail due to recursive sandbox. Agents must request elevated permission to run these commands, and stop immediately if permission request is blocked. Agents must not bypass Flatpak, `bwrap`, Docker, or any other sandbox or container boundary to execute an equivalent native host binary directly. 

## Subagent Delegation

- Proactively delegate when a task contains an independent, bounded side track whose parallel or isolated execution materially improves speed, coverage, or confidence.
- Keep cheap, trivial, tightly coupled, or critical-path work in the main agent; do not delegate solely to create parallelism.
- Give each subagent the relevant context, a concrete objective, an expected output, and clear ownership. Do not assign overlapping write scopes or duplicate work.
- Continue useful, non-conflicting main work while subagents run, and synchronize before decisions or edits that depend on their results.
- Treat subagent output as evidence to verify, then synthesize the material findings in the main response.
