# QDD Codex

[English](README.md) | [繁體中文](docs/i18n/README.zh-TW.md) | [简体中文](docs/i18n/README.zh-CN.md) | [日本語](docs/i18n/README.ja.md) | [한국어](docs/i18n/README.ko.md) | [Español](docs/i18n/README.es.md) | [Português (Brasil)](docs/i18n/README.pt-BR.md) | [Deutsch](docs/i18n/README.de.md) | [Français](docs/i18n/README.fr.md)

QDD Codex is a Codex plugin for **Questionnaire-Driven Development**. It helps you stop jumping from a vague feature idea straight into code by turning each request into a lightweight loop:

```text
questionnaire -> decisions -> phases -> implementation -> review/fix -> smoke test
```

Use it when you want Codex work to be explicit, resumable, and easy to verify.

## The Problem

Feature work often starts before the goal, tradeoffs, and verification path are clear. That creates churn: the agent implements too early, the user has to correct hidden assumptions, and later sessions lose context.

QDD Codex keeps that context in local plan files. It asks clear multiple-choice questions, records decisions, splits work into phases, and keeps smoke-test steps next to the plan.

## Use When

- You have a feature idea but the scope is still fuzzy.
- You want Codex to ask alignment questions before planning implementation.
- You want phase files that can be resumed in later Codex sessions.
- You want review, fix, and smoke-test steps to be explicit.

## Do Not Use When

- You only need a tiny one-line edit.
- You already have a complete issue, spec, and task breakdown.

## Quick Start

From a fresh checkout:

```bash
git clone https://github.com/starazzip/QDD-codex.git
cd QDD-codex
```

Install from the local marketplace:

```bash
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

The same commands work on Windows PowerShell, macOS, and Linux when run from the repository root:

```powershell
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

If your Codex version reports a different marketplace name:

```bash
codex plugin marketplace list
codex plugin add qdd-codex@<marketplace-name>
```

Restart Codex or start a new thread after installing so the skill list refreshes.

## Command Reference

| Command | Use when | Input | Output |
| --- | --- | --- | --- |
| `/qdd-whereami` | Check current QDD progress. | Current workspace plans. | Active plan, stage, current phase, last action, next action, blockers, and important files. |
| `/qdd {description}` | Start a new feature plan. | A short feature description. | `plans/<slug>/README.md`, `AGENTS.md`, and `questionnaire.md`. |
| `/qdd-align` | The questionnaire is answered or defaults are acceptable. | Active plan questionnaire. | `decisions.md`, plus follow-up questions if needed. |
| `/qdd-plan` | `decisions.md` is confirmed. | Plan goal and decisions. | `phases/phase-XX.md` files. |
| `/qdd-phase {N}` | Implement one phase. | A single phase number. | Scoped changes, verification results, phase status updates. |
| `/qdd-phase all` | Complete every phase in the active plan. | Active plan with phases. | Runs all phases in order, uses review/fix when needed, then closes the plan. |
| `/qdd-review {N\|all}` | Review completed phase work without fixing it. | One phase or `all`. | Findings for correctness, security, maintainability, missing tests, and docs drift. |
| `/qdd-phase-fix {N\|all}` | Fix review findings or failed verification. | One phase or `all`, plus findings or failure output. | Targeted fixes, rerun verification, updated phase status. |
| `/qdd-smoke {target}` | Create manual verification steps. | Plan or phase target. | `smoke.md` with user-facing smoke-test steps. |

## Phase Loop

`/qdd-phase` stays intentionally small:

1. Read plan context.
2. Plan the phase steps and risks.
3. Add BDD scenarios when useful; otherwise record why not.
4. Add tests when useful; otherwise record why not.
5. Implement only the selected phase scope.
6. Run relevant verification.
7. Wrap up phase status and smoke-test notes.

Review and fix are separate commands to keep implementation, independent assessment, and remediation as distinct checkpoints.

## Example

```text
/qdd Add team invitation emails with role selection and expiration
```

Codex creates a local plan folder and a questionnaire that clarifies who can invite teammates, which roles are available, how long invitations stay valid, what email content is required, and how failures should be handled.

After answering the questionnaire or accepting the recommended defaults:

```text
/qdd-whereami
/qdd-align
```

Review `decisions.md` to confirm the expected behavior and non-goals. When it matches your intent:

```text
/qdd-plan
```

Read the generated phases, then implement one phase at a time:

```text
/qdd-phase 1
/qdd-review 1
/qdd-phase-fix 1
```

When the early phases look good, finish the remaining approved phases:

```text
/qdd-phase all
```

Create user-facing verification steps before handoff:

```text
/qdd-smoke current plan
```

## Repository Layout

```text
.codex-plugin/plugin.json        Plugin manifest.
.codex/config.toml               Repo-local Codex agent registration.
.codex/agents/*.toml             Read-oriented agent roles for maintaining this repo.
skills/qdd-workflow/SKILL.md     Canonical QDD workflow behavior.
skills/qdd*/SKILL.md             Slash-style command aliases.
docs/rules/                      Codex workflow rules.
docs/templates/                  Generated plan templates.
docs/i18n/                       Versioned user-facing translations.
```
