#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
using_skill="$repo_root/skills/using-superpowers/SKILL.md"
brainstorming_skill="$repo_root/skills/brainstorming/SKILL.md"
tdd_skill="$repo_root/skills/test-driven-development/SKILL.md"

rg -q 'Use when explicitly requested' "$using_skill"
rg -q 'new feature|new subsystem|architectural change' "$brainstorming_skill"
rg -q 'Configuration-only' "$tdd_skill"

if rg -q '1% chance|before ANY response|EVERY task|NO production code|Delete means delete' \
  "$using_skill" "$brainstorming_skill" "$tdd_skill"; then
  echo 'over-broad skill policy remains' >&2
  exit 1
fi

for reference in $(rg -o '`[^`]+\.md`' "$tdd_skill" | tr -d '`' | sort -u); do
  if [[ ! -f "$(dirname "$tdd_skill")/$reference" ]]; then
    echo "missing TDD skill reference: $reference" >&2
    exit 1
  fi
done
