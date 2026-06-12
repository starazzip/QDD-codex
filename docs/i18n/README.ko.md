# QDD Codex

[English](../../README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Deutsch](README.de.md) | [Français](README.fr.md)

QDD Codex는 **Questionnaire-Driven Development**를 위한 Codex plugin입니다. 모호한 기능 아이디어에서 바로 code로 뛰어들지 않고, 각 요청을 가벼운 흐름으로 정리합니다.

```text
questionnaire -> decisions -> phases -> implementation -> review/fix -> smoke test
```

Codex 작업을 명확하고, 이어서 진행하기 쉽고, 검증하기 쉽게 만들고 싶을 때 사용합니다.

## Language

- [English](../../README.md)
- [繁體中文](README.zh-TW.md)
- [简体中文](README.zh-CN.md)
- [日本語](README.ja.md)
- [한국어](README.ko.md)
- [Español](README.es.md)
- [Português (Brasil)](README.pt-BR.md)
- [Deutsch](README.de.md)
- [Français](README.fr.md)

## 해결하려는 문제

기능 작업은 목표, tradeoffs, verification path가 분명해지기 전에 시작되는 경우가 많습니다. 그러면 agent가 너무 빨리 구현하고, 사용자는 숨은 가정을 수정해야 하며, 이후 session에서는 문맥을 잃기 쉽습니다.

QDD Codex는 이 문맥을 local plan files에 보관합니다. 명확한 multiple-choice questions를 묻고, decisions를 기록하고, 작업을 phases로 나누며, smoke-test steps를 plan 옆에 둡니다.

## 사용하기 좋은 경우

- 기능 아이디어는 있지만 scope가 아직 모호합니다.
- Codex가 구현 계획 전에 alignment questions를 물어보길 원합니다.
- 이후 Codex sessions에서 이어서 실행할 수 있는 phase files가 필요합니다.
- review, fix, smoke-test steps를 명확한 단계로 만들고 싶습니다.

## 사용하지 않는 것이 좋은 경우

- 아주 작은 한 줄 수정만 필요합니다.
- 이미 완전한 issue, spec, task breakdown이 있습니다.

## Quick Start

새 checkout에서 시작합니다.

```bash
git clone https://github.com/starazzip/QDD-codex.git
cd QDD-codex
```

local marketplace에서 install합니다.

```bash
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

repository root에서 실행하면 Windows PowerShell, macOS, Linux에서 같은 commands를 사용할 수 있습니다.

```powershell
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

Codex 버전이 다른 marketplace name을 표시하면:

```bash
codex plugin marketplace list
codex plugin add qdd-codex@<marketplace-name>
```

install 후 Codex를 재시작하거나 새 thread를 열어 skill list를 갱신하세요.

## Command Reference

| Command | 사용할 때 | Input | Output |
| --- | --- | --- | --- |
| `/qdd-whereami` | 현재 QDD 진행 상황을 확인합니다. | Current workspace plans. | Active plan, stage, current phase, last action, next action, blockers, important files. |
| `/qdd {description}` | 새 feature plan을 시작합니다. | 짧은 feature description. | `plans/<slug>/README.md`, `AGENTS.md`, `questionnaire.md`. |
| `/qdd-align` | questionnaire를 작성했거나 defaults를 수락할 수 있습니다. | Active plan questionnaire. | `decisions.md`와 필요한 follow-up questions. |
| `/qdd-plan` | `decisions.md`가 확인되었습니다. | Plan goal과 decisions. | `phases/phase-XX.md` files. |
| `/qdd-phase {N}` | 한 phase를 구현합니다. | 단일 phase number. | Scoped changes, verification results, phase status updates. |
| `/qdd-phase all` | active plan의 모든 phases를 완료합니다. | Active plan with phases. | 모든 phases를 순서대로 실행하고 필요하면 review/fix 후 plan을 닫습니다. |
| `/qdd-review {N\|all}` | 완료된 phase work를 수정하지 않고 review합니다. | 하나의 phase 또는 `all`. | correctness, security, maintainability, missing tests, docs drift findings. |
| `/qdd-phase-fix {N\|all}` | review findings 또는 failed verification을 수정합니다. | 하나의 phase 또는 `all`, findings 또는 failure output. | Targeted fixes, rerun verification, updated phase status. |
| `/qdd-smoke {target}` | 수동 검증 단계를 만듭니다. | Plan 또는 phase target. | user-facing smoke-test steps가 포함된 `smoke.md`. |

## Phase Loop

`/qdd-phase`는 의도적으로 작게 유지됩니다.

1. Read plan context.
2. Plan the phase steps and risks.
3. 유용하면 BDD scenarios를 추가하고, 아니면 이유를 기록합니다.
4. 유용하면 tests를 추가하고, 아니면 이유를 기록합니다.
5. selected phase scope만 구현합니다.
6. relevant verification을 실행합니다.
7. phase status와 smoke-test notes를 wrap up합니다.

Review와 fix는 별도 commands입니다. 구현, 독립 평가, 수정이 분리된 checkpoint가 됩니다.

## Example

```text
/qdd Add team invitation emails with role selection and expiration
```

Codex는 local plan folder와 questionnaire를 만들고, 누가 teammates를 초대할 수 있는지, 어떤 roles가 있는지, invitation이 언제 만료되는지, email content에 무엇이 필요한지, 실패 시 어떻게 처리할지 명확히 합니다.

questionnaire에 답하거나 recommended defaults를 수락한 뒤:

```text
/qdd-whereami
/qdd-align
```

`decisions.md`를 review하여 expected behavior와 non-goals가 의도와 맞는지 확인합니다. 맞다면:

```text
/qdd-plan
```

생성된 phases를 읽고, 한 번에 하나의 phase를 구현합니다.

```text
/qdd-phase 1
/qdd-review 1
/qdd-phase-fix 1
```

초기 phases가 괜찮다면 남은 approved phases를 완료합니다.

```text
/qdd-phase all
```

handoff 전에 user-facing verification steps를 만듭니다.

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
