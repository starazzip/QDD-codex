# Prompt Quality Rules

Use these rules for QDD skills, alias skills, and repo-local Codex agents.

## Intent

- Extract the user's command, target plan, target phase, and requested outcome before acting.
- When a command is ambiguous, choose the active plan from `plans/current.md` or the most recently modified active plan.
- Ask clarification questions only when the answer would change execution, scope, or safety.
- Do not impose a fixed maximum number of questionnaire or clarification questions; use as many as the workflow needs, and no more.

## Output Contract

- State the command input, the files or plan artifacts used, and the next action when handing work back to the user.
- Keep findings, decisions, blockers, and verification results easy to scan.
- Prefer concrete file paths, command names, and phase numbers over broad summaries.
- Use the user's preferred language for plan artifacts and user-facing smoke steps.

## Role Boundaries

- Keep alias skills thin; they should route to `skills/qdd-workflow/SKILL.md` rather than duplicate workflow logic.
- Keep repo-local agents read-oriented by default unless the main Codex agent explicitly delegates a bounded write.
- Keep review and fix responsibilities separate: review reports findings; fix addresses reviewed findings or failed verification.
- Keep QDD Codex-only. Do not add non-Codex profiles, runtime setup, or tool-specific instructions.

## Token Efficiency

- Remove wording that does not change behavior.
- Prefer short imperative instructions over long explanations.
- Avoid repeating the same rule in multiple files unless the duplicate is needed for command routing or role clarity.
- Keep instructions executable, scannable, and verifiable.

## Verification

- Validate plugin metadata after changing plugin, skill, or agent files.
- Search canonical files for stale command names, broken responsibilities, and references that should remain local-only.
- Record validation results in the active plan phase or smoke file.
