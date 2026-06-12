# QDD Codex Agent Guidance

This repository defines a Codex-first workflow plugin. Follow these instructions for all work in this repo.

## Language Policy

- Keep canonical README, skills, agents, rules, templates, and plugin metadata in English.
- Support Traditional Chinese through `translations/zh-TW/`.
- Do not commit `translations/zh-TW/`; it is intentionally ignored by Git.
- When canonical English content changes, update the corresponding Traditional Chinese translation locally.

## Codex Scope

- Target Codex CLI, Codex IDE, and Codex app behavior.
- Use Codex terminology: `AGENTS.md`, skills, plugins, MCP, hooks, goals, phases, and reviews.
- Do not add Claude-specific files such as `CLAUDE.md`, Claude slash commands, Claude hooks, or Claude plugin setup.

## Project Sources Of Truth

- `README.md` describes installation and public usage.
- `skills/qdd-workflow/SKILL.md` defines runtime QDD behavior.
- `skills/qdd*/SKILL.md` files are thin command aliases and should stay aligned with `qdd-workflow`.
- `docs/rules/` defines repository rules.
- `docs/rules/prompt-quality.md` defines prompt quality rules for skills and repo-local agents.
- `docs/templates/` defines generated plan artifacts.

## Engineering Rules

- Keep changes small and directly tied to the workflow.
- Prefer updating existing canonical files over duplicating instructions.
- Validate plugin metadata before handing off changes.
- Follow `docs/rules/prompt-quality.md` when changing skills or repo-local agents.
- Preserve user-created plan folders unless the user explicitly asks to modify or remove them.
- Use `rg` for repository searches where available.
- Follow `docs/rules/agents.md` before adding or using specialized subagent behavior.

## Workflow Rules

- `/qdd` must generate only alignment artifacts, not implementation plans.
- Questionnaires must use plain language, multiple-choice options, exactly one `Other` option per question, and a recommended default.
- Plan artifacts that require user reading or confirmation, especially `questionnaire.md`, `decisions.md`, and `smoke.md`, must use the user's preferred language.
- Unanswered questionnaire items use their recommended defaults.
- `/qdd-align` must write confirmed decisions before adding new questions.
- `/qdd-plan` must wait for user confirmation that `decisions.md` is aligned.
- Any phase that writes code must include verification. Unit tests, BDD, and E2E are optional only when they are not useful for that phase.
- `/qdd-phase all` must use a goal to track completion and move finished plans to `plans/done/`.
- Keep `plans/` ignored by Git. Plans are local workflow state unless the user explicitly changes that policy.
