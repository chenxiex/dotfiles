# CLAUDE.md

## Style Guide

Follow the project's documented conventions or established style. Where the project has no applicable rule, use these defaults:

- Use spaces with an indentation width of 4.
- Do not hard-wrap generated documents at a fixed line width.
- Use progressive disclosure in documentation: place details near the code or topic they describe, and keep repository-level documents focused on navigation and shared guidance rather than collecting all details there.

## Sandbox-Blocked Commands

If a test, smoke test, real-device probe, dependency installation, or similar command cannot run because it is blocked by the sandbox, agents must clearly state the specific permission being blocked—for example, "requires write access to the `/cache` path"—and then request elevated permission to run the command.

Agents must not skip any necessary probing or verification because of a sandbox restriction. Agents must not bypass the restriction by redirecting caches, installation paths, or other command data to a non-designated directory such as `/tmp`.

## Sandbox or container Commands

Sandbox or container commands like Flatpak or Docker may fail due to recursive sandbox. Agents must request elevated permission to run these commands, and stop immediately if permission request is blocked. Agents must not bypass Flatpak, `bwrap`, Docker, or any other sandbox or container boundary to execute an equivalent native host binary directly. 

