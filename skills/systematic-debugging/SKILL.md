---
name: systematic-debugging
description: Use when encountering bugs, failing tests, build failures, flaky behavior, performance regressions, runtime errors, or other unexpected technical behavior before proposing fixes
---

# Systematic Debugging

## Overview

Random fixes waste time and create new bugs. This skill is the stop sign before symptom patches, shotgun edits, and "try one thing" debugging.

**Core principle:** Find the root cause with a trustworthy feedback loop before proposing or applying fixes.

## The Iron Law

```
NO FIXES WITHOUT A TRUSTWORTHY FEEDBACK LOOP AND A ROOT-CAUSE CHAIN
```

A fix is not allowed until all three gates are satisfied:

1. The failure signal reproduces the user-described symptom, or the missing reproduction evidence is explicitly documented.
2. The causal chain from trigger to symptom is explained with no "somehow" gap.
3. Any uncertain causal link has an independent prediction that was checked against evidence.

If a change appears to work but its prediction fails, you found a symptom patch. The real cause is still active.

## When to Use

Use for any technical issue:

- Test failures, CI failures, build failures, type errors, runtime errors
- Production bugs, incidents, integration failures, bad API behavior
- Flaky, timing-dependent, or nondeterministic behavior
- Performance regressions, slow paths, resource spikes
- "It worked before" regressions or unclear behavior changes

Use this especially when pressure is high, a one-line fix seems obvious, prior attempts failed, or you do not fully understand the issue.

Do not skip it for simple bugs. Simple bugs move through the process quickly; they still need a root cause.

## Phase 0: Triage and Intake

Reach a concrete problem statement before reading random files.

1. **If the input is an issue tracker reference, fetch the full thread.**
   - GitHub, Linear, Jira, or similar references often contain updated reproduction steps, failed attempts, or late comments that supersede the original report.
   - If auth/tooling blocks retrieval, ask for the relevant issue body and comments.

2. **Extract the reported contract.**
   - Symptom, expected behavior, reproduction steps, environment, scope, and prior failed attempts.
   - If the user says they are stuck or tried fixes already, ask what they tried before repeating work.

3. **Verify environment sanity when relevant.**
   - Correct branch and no unintended local edits.
   - Expected dependency install state, runtime version, env vars, build artifacts, and local services.
   - Do this before deep tracing when stale dependencies, wrong runtime, missing services, or old build outputs could explain the symptom.

Ask questions only when investigation is genuinely blocked and the answer cannot be found by reading, running, or fetching available evidence.

## Phase 1: Build the Feedback Loop

The first deliverable is a pass/fail signal for the user-described bug. Code reading without a loop anchors on vibes.

A good loop is:

- **Representative:** It asserts the exact reported symptom, not just a nearby crash.
- **Agent-runnable:** You can run it repeatedly without manual interpretation.
- **Fast enough:** It gives feedback quickly enough to support iteration.
- **Deterministic enough:** It fails reliably, or raises a flaky bug's reproduction rate enough to debug.

Build the loop using the narrowest realistic seam:

1. Failing unit, integration, e2e, or regression test.
2. Focused CLI, HTTP, or scriptable repro with fixture input.
3. Browser automation or recorded trace replay for UI/network bugs.
4. Throwaway harness around the smallest runnable subsystem.
5. Property, fuzz, stress, or repeated-run loop for intermittent output.
6. Bisect or differential loop when a known-good state exists.
7. Structured human-in-the-loop steps only when automation cannot reach the environment.

Iterate on the loop itself:

- Make it faster by narrowing setup and skipping unrelated init.
- Make it sharper by asserting the exact bad value, error, timing, or side effect.
- Make it more deterministic by pinning time, RNG, filesystem, network, and concurrency where possible.

For flaky bugs, the goal is not immediate perfect reproduction. Raise the reproduction rate with repeated runs, stress, parallelism, scheduling control, or targeted instrumentation until the bug is debuggable.

For performance regressions, measure first. Establish a baseline with timing, profiler output, query plans, traces, or resource metrics before changing code.

If no trustworthy loop can be built, stop and say so. Document what was tried and request the missing artifact, access, environment, trace, log dump, or permission for temporary instrumentation. Do not proceed as if code inspection alone confirmed the bug.

## Phase 2: Reproduce and Capture the Symptom

Run the feedback loop and watch the bug happen.

Confirm before moving on:

- The loop fails for the same symptom the user reported.
- The failure is reproducible enough to debug.
- The exact evidence is captured: command, test path, output, stack trace, wrong value, timing, logs, or screenshot.

If the loop exposes a different bug, do not fix it unless the user redirects scope. Keep debugging the reported problem.

## Phase 3: Trace, Compare, and Audit Assumptions

Trace the observed bad state backward to where valid state first became invalid.

1. **Read the relevant code path.**
   - Start at the symptom.
   - Ask "where did this value come from?" and "who called this?"
   - Continue upstream until you find the first incorrect state transition.

2. **Inspect component boundaries.**
   - For API to service to database, CI to build to signing, frontend to backend, queue to worker, or similar chains, capture what enters and exits each boundary.
   - Add targeted instrumentation only where it distinguishes possible causes.

3. **Compare against working references.**
   - Find similar working code in the same codebase.
   - Compare config, inputs, invariants, dependencies, environment, and recent changes.
   - If applying a documented pattern, read the reference completely before adapting it.

4. **Run an assumption audit.**
   - List what must be true for your current mental model to hold.
   - Mark each item **verified** or **assumed**.
   - Convert important assumptions into evidence before forming fixes.

Most stuck debugging is a correct hypothesis tested against a false assumption.

## Phase 4: Hypotheses and Prediction Probes

Generate 3 to 5 ranked, falsifiable hypotheses unless the root cause is already obvious from direct evidence such as a missing import, explicit null dereference, or clear type mismatch.

For each hypothesis, state:

- The suspected root cause and location.
- The full causal chain from trigger to symptom.
- The prediction it makes if the chain is correct.
- The smallest probe that tests the prediction.

Test one hypothesis at a time. Change one variable at a time. Do not bundle fixes or instrumentation.

Temporary debug logs must use a unique prefix such as `[DEBUG-a4f2]`. Before completion, grep for that prefix and remove every debug line.

Use the best probe for the context:

- Debugger, REPL, direct inspection, or targeted assertion when available.
- Focused logs at hypothesis boundaries when runtime inspection is not available.
- Profilers, timing harnesses, query plans, and traces for performance regressions.
- Bisect, differential runs, or repeated stress loops for regressions and flakes.

### Causal-Chain Gate

Do not proceed to a fix until you can explain:

```
trigger -> state transition -> broken invariant -> observed symptom
```

No step may rely on "probably", "somehow", "I think", or authority. If a senior engineer, manager, or incident pressure pushes a fix without evidence, keep the gate.

If 2 to 3 hypotheses are exhausted without confirmation, stop and diagnose why:

- Hypotheses point to unrelated subsystems: likely design or boundary problem.
- Evidence contradicts itself: mental model is wrong; re-read the code path.
- Works locally but fails in CI/prod: focus on environment, config, dependencies, data, or timing.
- Fix works but prediction failed: symptom patch; root cause is still active.

Escalate with a diagnosis instead of trying one more random change.

## Phase 5: Test-First Fix

Fix the root cause, not the symptom.

1. **Choose the correct regression seam.**
   - The test must exercise the real bug pattern as it occurs at the call site.
   - A shallow test that cannot reproduce the causal chain gives false confidence.
   - If no correct seam exists, document that as a testability or architecture finding.

2. **Write or preserve the failing test first.**
   - Use the Phase 1 loop or convert the minimized repro into a failing regression.
   - Watch it fail for the right reason.
   - Use `superpowers:test-driven-development` for the test-first workflow.

3. **Apply one minimal fix.**
   - Address the confirmed root cause.
   - No drive-by refactors, bundled cleanup, or "while here" changes.
   - No fallback, compatibility, or workaround unless the root cause genuinely requires it.

4. **Verify.**
   - Regression test passes.
   - Original feedback loop no longer reproduces the bug.
   - Relevant broader tests still pass.

If the fix fails, return to Phase 4 with the new evidence. Three failed fixes means the root cause or design assumption is wrong; stop and escalate.

Use defense in depth only after the root cause is known, especially when the pattern appears in multiple locations or the impact would be severe. See `defense-in-depth.md`.

Use condition-based waiting instead of arbitrary sleeps for timing bugs. See `condition-based-waiting.md`.

## Phase 6: Cleanup and Debug Summary

Before claiming completion:

- Re-run the original feedback loop.
- Re-run the regression test or document why no correct test seam exists.
- Remove all temporary `[DEBUG-...]` instrumentation.
- Delete throwaway harnesses unless they are intentionally kept as named tests or scripts.
- State what root cause was confirmed and what evidence confirmed it.

End with a structured summary:

```markdown
## Debug Summary
**Problem**: [What was broken]
**Root Cause**: [Full causal chain with file:line references]
**Recommended Tests**: [Specific tests or the missing test seam]
**Fix**: [What changed, or "diagnosis only"]
**Prevention**: [Regression coverage, guardrails, or follow-up]
**Confidence**: [High/Medium/Low and why]
```

Diagnosis-only is a valid outcome. If the user asked only to investigate, or if the causal chain reveals a design problem requiring a separate decision, stop after the summary and do not make code changes.

## Red Flags

Stop and return to the process when you think:

- "Quick fix now, investigate later"
- "Just try changing this"
- "The fix is obvious"
- "I'll add a sleep/retry/fallback and move on"
- "I'll test after the fix"
- "Multiple changes will save time"
- "This authority figure says it is fine"
- "I do not understand it, but this might work"
- "One more fix attempt" after repeated failures
- "The prediction failed, but the test passes now"

## Quick Reference

| Phase | Output |
|-------|--------|
| 0. Triage | Problem statement, full issue context, environment sanity |
| 1. Feedback Loop | Representative runnable pass/fail signal |
| 2. Reproduce | Captured symptom evidence |
| 3. Trace and Audit | Root path, working comparison, verified assumptions |
| 4. Hypotheses | Ranked predictions and tested probes |
| 5. Fix | Failing test, single root-cause fix, verification |
| 6. Handoff | Cleanup and Debug Summary |

## Supporting Techniques

- `root-cause-tracing.md` - Trace bugs backward through call stack to find original trigger.
- `defense-in-depth.md` - Add validation at multiple layers after finding root cause.
- `condition-based-waiting.md` - Replace arbitrary sleeps with condition polling.

Related skills:

- `superpowers:test-driven-development` - Create the failing regression test.
- `superpowers:verification-before-completion` - Verify evidence before claiming success.
