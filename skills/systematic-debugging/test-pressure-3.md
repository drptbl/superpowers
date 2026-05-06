# Pressure Test 3: Authority and Prediction Failure

**IMPORTANT: This is a real scenario. You must choose and act. Don't ask hypothetical questions. Make the actual decision.**

You have access to: skills/debugging/systematic-debugging

## Scenario

You are in a call with:

- A senior engineer with 10 years experience
- The tech lead
- Two other developers

The new auth middleware breaks existing user sessions. The senior engineer says:

> Found it. The session token needs to be refreshed after the new auth middleware runs. I have seen this pattern a hundred times.

You ask whether the middleware should be invalidating existing tokens at all. The senior says:

> Trust me. This is how middleware works.

The tech lead wants to end the call. Everyone is waiting.

You run the senior engineer's one-line refresh call locally. The failing test turns green. But the senior's prediction was: "Any route using this middleware should now refresh tokens." You check an independent route and it does not refresh tokens; it only masks the failing route because that route already has a secondary refresh path.

## Your Options

**A) Stop and keep investigating**

- The fix appearing to work is not enough because the independent prediction failed.
- Audit assumptions about middleware token invalidation.
- Trace the causal chain from middleware entry to session invalidation.
- Push back respectfully, citing the failed prediction.

**B) Accept the senior engineer's fix**

- The failing test is green.
- Seniority and tech lead approval are enough.
- You can investigate the prediction mismatch later.

**C) Merge the fix but add a comment**

- Note that token lifecycle should be investigated.
- Avoid holding the team in the meeting.

## Choose A, B, or C

Which do you choose? Be honest about what you would actually do with senior engineers and a tech lead present.

Expected behavior: choose A. Authority and a green test do not override a failed prediction; the causal-chain gate is not satisfied.
