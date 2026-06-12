---
name: qdd-workflow
description: Use when the user types /qdd-whereami, /qdd, /qdd-align, /qdd-plan, /qdd-phase, /qdd-review, /qdd-phase-fix, or /qdd-smoke to run the QDD Codex planning workflow.
---

# QDD Workflow

This skill implements Questionnaire-Driven Development for Codex. Treat command-shaped prompts as workflow commands:

- `/qdd {feature description}`
- `/qdd-whereami`
- `/qdd-align`
- `/qdd-plan`
- `/qdd-phase {N}`
- `/qdd-phase all`
- `/qdd-review {N|all}`
- `/qdd-phase-fix {N|all}`
- `/qdd-smoke {plan or phase}`

Use Codex-native surfaces only: repository files, `AGENTS.md`, skills, plugins, goals, subagents when available, and normal Codex verification. Do not create Claude-specific files, hooks, commands, or plugin setup.

## Shared Rules

- Follow `docs/rules/prompt-quality.md` when generating, updating, reviewing, or fixing QDD workflow artifacts.
- Before acting, identify the command, active plan, target phase, source files, expected output, and next action.
- Ask clarification questions only when the answer would change execution, scope, or safety.
- Do not impose a fixed maximum number of questionnaire or clarification questions; use the number needed to align the work.
- Keep command responses concise and include concrete file paths, verification results, blockers, and the next command when relevant.
- Store active plans under `plans/<feature-slug>/`.
- Store completed plans under `plans/done/<feature-slug>/`.
- Maintain `status.md` inside each active plan using `docs/templates/status.md` as the shape.
- Maintain `plans/current.md` when useful to point at the active plan.
- Use a short lowercase kebab-case slug derived from the feature description.
- If several active plans exist and the command does not name one, select the most recently modified active plan. If that is still ambiguous, ask only the blocking question needed to choose the plan.
- Keep generated plan content readable by non-specialists.
- Use English for canonical workflow files unless the user asks for Traditional Chinese output in a plan.
- Use the user's preferred language for plan artifacts that require user reading or confirmation, including `questionnaire.md`, `decisions.md`, and `smoke.md`.
- Support Traditional Chinese translations under `translations/zh-TW/`, but do not rely on translated files as the source of truth.
- Before editing an existing plan file, read it first and preserve user-authored answers.
- After every QDD command, update the active plan `status.md` with stage, current phase, last action, next action, blockers, important files, and update time.
- If `status.md` is missing or stale, infer status from plan files, rebuild `status.md`, and tell the user that the result was inferred.

## `/qdd-whereami`

Report where the user is in the QDD workflow.

Status source priority:

1. Read `plans/current.md` when it exists and points to an active plan.
2. Read the active plan's `status.md`.
3. If there is no current pointer, scan `plans/` for the most recently modified active plan, excluding `plans/done/`.
4. If `status.md` is missing or stale, infer status from plan files and rebuild it.
5. If no active plan exists, tell the user to start with `/qdd {description}`.

The response must include:

- Active plan.
- Stage.
- Current phase.
- Last action.
- Next action.
- Blockers.
- Important files.
- Whether the status was read directly or inferred.

Write the response in the user's preferred language.

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
Update the plan `status.md` with stage `alignment`, current phase `not started`, last action `/qdd`, and next action `/qdd-align`.

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

Update `status.md` with stage `decisions`, last action `/qdd-align`, and next action `/qdd-plan` when decisions are ready.

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

After writing phases, tell the user to read every phase before running `/qdd-phase {N}` or `/qdd-phase all`.
Update `status.md` with stage `planning`, last action `/qdd-plan`, and next action `/qdd-phase {N}`.

## `/qdd-phase {N}`

Execute one requested phase for the active plan. If the user provides `all`, execute every phase in the active plan in order. If the user provides a numeric range, explain that ranges are not supported and ask them to use `/qdd-phase all` or run phases one at a time.

Before implementation:

- Read the plan `README.md`, `decisions.md`, `AGENTS.md`, and selected phase files.
- Check the working tree when the repository uses Git.
- Keep changes scoped to selected phases.

During implementation:

- Follow the phase steps through implementation and required verification.
- Add BDD, TDD, or E2E only when the phase requires them; if skipped, record the reason.
- Update phase progress in the phase file.
- Add or update tests required by the phase.
- Run relevant verification.

After implementation:

- Record completed verification in the phase file.
- Add or update `smoke.md` if user smoke testing is needed.
- Summarize changed files and verification results.
- Do not run a broad independent review or expand into cleanup. Use `/qdd-review` for independent findings and `/qdd-phase-fix` for targeted fixes.
Update `status.md` with stage `phase`, current phase `{N}` or `all`, last action `/qdd-phase`, and next action `/qdd-review {N}` or `/qdd-smoke`.

## `/qdd-review {N|all}`

Review the requested phase after `/qdd-phase` has produced changes or verification results. If the target is `all`, review every completed phase in the active plan.

Before review:

- Read the plan `README.md`, `decisions.md`, `AGENTS.md`, selected phase files, and relevant changed files.
- Check available verification results.
- Keep the review scoped to the selected phase, or to all completed phases when the target is `all`.

Review for:

- Correctness and behavioral regressions.
- Security, privacy, permissions, secrets, and unsafe configuration.
- Maintainability, unnecessary complexity, and docs drift.
- Missing or weak verification.

After review:

- Write concise findings ordered by severity.
- Reference concrete files and commands where possible.
- Do not make fixes during review unless the user explicitly asks.
- If fixes are needed, tell the user to run `/qdd-phase-fix {N}` or `/qdd-phase-fix all`.
Update `status.md` with stage `review`, current phase `{N}` or `all`, last action `/qdd-review`, and next action `/qdd-phase-fix {N}` or `/qdd-smoke`.

## `/qdd-phase-fix {N|all}`

Fix only issues identified by `/qdd-review` or failed verification for the requested phase. If the target is `all`, fix findings across all reviewed phases in priority order.

Before fixing:

- Read the selected phase file, review findings, failed command output, and relevant changed files.
- Keep fixes bounded to the selected phase, or to reviewed phase findings when the target is `all`.

During fixing:

- Address high-risk findings and failed verification first.
- Do not expand scope into opportunistic cleanup or unrelated refactors.
- Re-run the relevant verification after fixes.

After fixing:

- Record the fixes and verification results in the phase file.
- Update `smoke.md` when user-facing verification changed.
- Summarize remaining risks or unresolved findings.
Update `status.md` with stage `fix`, current phase `{N}` or `all`, last action `/qdd-phase-fix`, and next action `/qdd-review {N}` or `/qdd-smoke`.

### `/qdd-phase all`

Use the goal mechanism to complete every approved phase in order. The goal should reference the active plan and state that all phases must be implemented and verified.

Complete every phase in the active plan using the `/qdd-phase {N}` rules one phase at a time. Use `/qdd-review {N|all}` and `/qdd-phase-fix {N|all}` when phases need independent review or targeted fixes. After all phases are complete:

- Ensure `smoke.md` exists.
- Update `status.md` with stage `done`, current phase `all`, last action `/qdd-phase all`, and next action `/qdd-smoke` before moving the plan.
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
Update `status.md` with stage `smoke`, last action `/qdd-smoke`, and next action based on remaining plan work.
