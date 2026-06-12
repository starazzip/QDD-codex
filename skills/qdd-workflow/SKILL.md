---
name: qdd-workflow
description: Use when the user types /qdd, /qdd-align, /qdd-plan, /qdd-phase, /qdd-phase-all, or /qdd-smoke to run the QDD Codex planning workflow.
---

# QDD Workflow

This skill implements question-driven development for Codex. Treat command-shaped prompts as workflow commands:

- `/qdd {feature description}`
- `/qdd-align`
- `/qdd-plan`
- `/qdd-phase {1~X}`
- `/qdd-phase-all`
- `/qdd-smoke {plan or phase}`

Use Codex-native surfaces only: repository files, `AGENTS.md`, skills, plugins, goals, subagents when available, and normal Codex verification. Do not create Claude-specific files, hooks, commands, or plugin setup.

## Shared Rules

- Store active plans under `plans/<feature-slug>/`.
- Store completed plans under `plans/done/<feature-slug>/`.
- Use a short lowercase kebab-case slug derived from the feature description.
- If several active plans exist and the command does not name one, select the most recently modified active plan. If that is ambiguous, ask one concise question.
- Keep generated plan content readable by non-specialists.
- Use English for canonical workflow files unless the user asks for Traditional Chinese output in a plan.
- Use the user's preferred language for plan artifacts that require user reading or confirmation, including `questionnaire.md`, `decisions.md`, and `smoke.md`.
- Support Traditional Chinese translations under `translations/zh-TW/`, but do not rely on translated files as the source of truth.
- Before editing an existing plan file, read it first and preserve user-authored answers.

## `/qdd {feature description}`

Create `plans/<feature-slug>/` and generate only alignment artifacts:

- `README.md`
- `AGENTS.md`
- `questionnaire.md`

Do not generate `decisions.md`, phases, code, tests, or smoke tests yet.

`README.md` must include:

- Plain-language goal.
- Current status: `Alignment in progress`.
- How to continue: fill `questionnaire.md`, then run `/qdd-align`.
- Known constraints and assumptions.

`AGENTS.md` must include:

- Plan objective.
- Current progress.
- Plan-specific restrictions.
- The rule that phases cannot be created before decision confirmation.

`questionnaire.md` must include:

- A short instruction that unanswered questions use recommended defaults.
- Numbered questions.
- Multiple-choice answers only.
- Exactly one `Other:` option per question.
- One clearly marked recommended default per question.
- Plain-language wording that a non-specialist can understand.

Question coverage should include:

- User and problem.
- Desired outcome.
- MVP boundary.
- Non-goals.
- Data, privacy, security, or permission constraints.
- UX or interface expectations when relevant.
- Verification expectations.
- Delivery risk and tradeoffs.

After creating the files, tell the user to fill `plans/<slug>/questionnaire.md` and run `/qdd-align`.

## `/qdd-align`

Read the active plan's `questionnaire.md`.

Interpret answers as follows:

- Checked or clearly selected options are user answers.
- Blank questions use the recommended default.
- `Other:` is valid only when the user wrote a concrete answer.

Create or update `decisions.md` with:

- Confirmed decisions.
- Defaults used because the user did not answer.
- Constraints.
- Out-of-scope items.
- Open questions.

Write `decisions.md` in the user's preferred language. If the user normally writes in Traditional Chinese, use Traditional Chinese.

If more information is needed:

- Append a `Follow-up Questions` section to the original `questionnaire.md`.
- Follow the same multiple-choice rules: exactly one `Other:` option and one recommended default per question.
- Tell the user what was added and ask them to answer those follow-ups before running `/qdd-align` again.

If no follow-up questions are needed:

- Tell the user to review and confirm `decisions.md`.
- Do not create phases yet.

## `/qdd-plan`

Before planning, verify that `decisions.md` exists and that the user has confirmed it in chat or in the file. If not confirmed, ask the user to confirm `decisions.md` first.

Create `plans/<slug>/phases/` and write `phase-XX.md` files.

Each phase must include:

- Status.
- Objective.
- Inputs.
- Scope.
- Out of scope.
- Plan.
- BDD.
- TDD.
- Implement.
- E2E.
- Review.
- Fix.
- Wrap up.
- Verification.
- Done criteria.

Use the repository's available phase skill guidance when present. Reflect the phase cadence `Plan -> BDD -> TDD -> Implement -> E2E -> Review -> Fix -> Wrap up`, but do not copy another skill's full instructions into generated phase files. If a phase writes code, it must include verification. Unit tests, BDD, and E2E tests may be marked not applicable only with a reason.

After writing phases, tell the user to read every phase before running `/qdd-phase` or `/qdd-phase-all`.

## `/qdd-phase {1~X}`

Execute only the requested phase or phase range for the active plan.

Before implementation:

- Read the plan `README.md`, `decisions.md`, `AGENTS.md`, and selected phase files.
- Check the working tree when the repository uses Git.
- Keep changes scoped to selected phases.

During implementation:

- Follow the phase steps.
- Update phase progress in the phase file.
- Add or update tests required by the phase.
- Run relevant verification.

After implementation:

- Record completed verification in the phase file.
- Add or update `smoke.md` if user smoke testing is needed.
- Summarize changed files and verification results.

## `/qdd-phase-all`

Use the goal mechanism to complete every approved phase in order. The goal should reference the active plan and state that all phases must be implemented and verified.

Complete each phase using the `/qdd-phase` rules. After all phases are complete:

- Ensure `smoke.md` exists.
- Move `plans/<slug>/` to `plans/done/<slug>/`.
- Tell the user where the completed plan was moved.

If the environment cannot use a goal tool, write the goal text into `plans/<slug>/goal.md` and proceed phase by phase.

## `/qdd-smoke {plan or phase}`

Read the requested plan or phase and produce detailed smoke-test steps.

Write or update `smoke.md` in the plan folder with:

- Target.
- Preconditions.
- Step-by-step user actions.
- Expected results.
- Failure signals.
- Result checklist.

Use language suitable for the person who will manually verify the feature.
