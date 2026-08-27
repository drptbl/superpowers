---
name: using-superpowers
description: Use when explicitly requested to use Superpowers, or when selecting among Superpowers process skills for a coding task whose trigger clearly matches.
---

# Using Superpowers

Superpowers provides focused process skills for design, debugging, planning, test-first implementation, delegation, and completion. It is a routing aid, not an always-on override.

## Selection rule

Use a Superpowers skill when either condition is true:

1. The user explicitly names it.
2. The current coding task clearly matches that skill's description, such as a reproducible failure for `systematic-debugging` or a new architectural feature for `brainstorming`.

Do not invoke Superpowers for ordinary questions, status checks, literal edits, or tasks already governed by a more specific repository skill. Read only the selected skill and the references it directly requires.

## Priority

System, developer, user, repository, and tool instructions retain their normal priority. A skill cannot override a higher-priority approval or safety boundary.

When multiple skills genuinely apply, use the smallest set that covers the work:

- process skill first when it determines the method;
- domain/implementation skill second;
- completion verification last.

Announce selected skills briefly in the main agent flow. A delegated subagent with a self-contained task should execute that contract without recursively loading this router.

## Common routes

- New product behavior or architecture: `superpowers:brainstorming`
- Bugs, failing tests, flaky behavior, or regressions: `superpowers:systematic-debugging`
- Behavior-changing implementation: `superpowers:test-driven-development`
- Written plan execution: `superpowers:executing-plans` or `superpowers:subagent-driven-development`
- Completion evidence: `superpowers:verification-before-completion`

Platform-specific tool mappings remain under `references/` and should be loaded only when that platform is in use.
