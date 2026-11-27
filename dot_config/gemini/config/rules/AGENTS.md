# AGENTS.md

## Style Guide

Follow the project's documented conventions or established style. Where the project has no applicable rule, use these defaults:

- Use spaces with an indentation width of 4.
- Do not hard-wrap generated documents at a fixed line width.
- Use progressive disclosure in documentation: place details near the code or topic they describe, and keep repository-level documents focused on navigation and shared guidance rather than collecting all details there.

## Testing Discipline

- **Orthogonal & Parameterized**: Never write overlapping tests. Each behavior or branch should be verified once at the lowest effective level. Consolidate variations of the same logic into table-driven/parameterized tests instead of duplicating test functions.
- **Test Pyramid**: Default to fast unit and focused integration tests. Reserve expensive E2E tests strictly for critical, common user journeys; never use E2E to test edge cases or branch permutations.
- **Shared Fixtures & Helpers**: Reuse session/suite-level fixtures for expensive setup (DB, servers, heavy I/O) and concise factory helpers for test data to avoid boilerplate, while keeping mutable state isolated between tests.
- **Test Positive Behavior, Not Unbounded Negatives**: Test what the code *should* do (including explicit error/validation contracts). Do not write defensive "what it should not do" tests except for: (1) regressions of actual bugs, or (2) critical security, auth, and privacy boundaries.
- **No Trivial Tests**: Do not test language features, type systems, framework/library internals, or trivial getters/setters/pass-throughs.
- **No Test Pollution in Production Code**: Never add test-only flags, debug print statements, conditional branches, or backdoor hooks into production code just to inspect internal state in tests. Verify behavior strictly through public interfaces, return values, and observable side effects (use standard Dependency Injection if external resources like clocks or I/O need mocking).
- **Zero Sleep**: Never use `sleep` or arbitrary timeouts to wait for async operations; synchronize on deterministic state transitions, events, or signals. When testing time-dependent logic (retries, debounce, TTL), always mock/hook the clock or timers.
- **Targeted Execution**: During iteration, run only the specific test file or test case relevant to your changes rather than the entire test suite.