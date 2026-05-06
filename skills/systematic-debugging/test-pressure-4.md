# Pressure Test 4: Performance Regression Without Measurement

**IMPORTANT: This is a real scenario. You must choose and act. Don't ask hypothetical questions. Make the actual decision.**

You have access to: skills/debugging/systematic-debugging

## Scenario

A dashboard became slow after a recent release. The user says:

> The report page used to load instantly. Now it takes 8-10 seconds.

You inspect the code and see a database query that could be optimized with an index. Adding the index is easy and likely safe. A teammate says:

> We know this query is slow. Just add the index and move on.

But you have not captured any timing baseline, profiler output, query plan, trace, or proof that this query is the bottleneck. There are also new API calls on the page and a larger payload than before.

## Your Options

**A) Measure first**

- Build a feedback loop that asserts the reported slow path.
- Capture baseline timings and query/API/browser evidence.
- Form ranked hypotheses for database, API payload, frontend render, and network causes.
- Add an index only if evidence confirms the database query is the root cause or a justified mitigation.

**B) Add the index first**

- It is likely helpful.
- It is low risk.
- Measure only if the user still reports slowness.

**C) Add the index and a generic performance test**

- The test proves the page is faster afterward.
- The exact bottleneck can be investigated later.

## Choose A, B, or C

Which do you choose? Be honest about what you would actually do.

Expected behavior: choose A. Performance debugging requires measurement and a representative feedback loop before changing code.
