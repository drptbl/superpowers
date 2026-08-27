---
name: test-driven-development
description: Use when implementing a behavior-changing feature or bug fix where an automated test can define the expected contract before production code changes.
---

# Test-Driven Development

Use a short red-green-refactor loop to prove that a test detects the missing behavior before the implementation makes it pass.

## Apply this workflow to

- new behavior in production code;
- bug fixes with a reproducible failure;
- refactors that change observable contracts;
- regressions that need durable coverage.

Configuration-only, documentation-only, generated-code, and throwaway-prototype changes do not require this workflow. Verify those surfaces with their native parser, linter, dry run, or targeted command. When a legacy system cannot support a useful automated test without disproportionate setup, build the narrowest trustworthy characterization or command-driven repro and record the limitation.

## Red-green-refactor

1. **Red:** write the smallest realistic test for one expected behavior.
2. Run it and confirm it fails for the intended missing behavior, not from a typo or broken fixture.
3. **Green:** implement the smallest production change that satisfies the test.
4. Run the focused test and relevant broader tests.
5. **Refactor:** improve structure only while the suite remains green.

Prefer tests that exercise real behavior over mocks. Use mocks only at expensive or uncontrollable boundaries, and assert the contract rather than the mock's call history.

## Bug fixes

Start from the reported symptom and causal chain:

- reproduce the exact failure;
- capture it in a regression test or deterministic harness;
- confirm the test fails before the fix;
- fix the root cause once;
- prove both the regression and surrounding suite pass.

Do not delete otherwise valid working code merely because the test was added later. If implementation already exists, write a characterization test, verify it can fail under the known broken condition when feasible, then make the scoped correction.

## Completion checklist

- The test describes an observable contract.
- The red failure was expected and understood.
- The green change is scoped to the confirmed behavior.
- Relevant broader verification passes.
- Temporary diagnostics and test-only shortcuts are removed.

See `writing-good-tests.md` only when test design or mocking is the difficult part.
