# QDD Codex

[English](../../README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Deutsch](README.de.md) | [Français](README.fr.md)

QDD Codex 是一个 Codex plugin，用来实践 **Questionnaire-Driven Development（问卷驱动开发）**。它帮助你避免从模糊需求直接跳到写 code，而是把每个请求整理成轻量流程：

```text
questionnaire -> decisions -> phases -> implementation -> review/fix -> smoke test
```

当你希望 Codex 的工作明确、可继续、可验证时，QDD Codex 很适合使用。

## 语言

- [English](../../README.md)
- [繁體中文](README.zh-TW.md)
- [简体中文](README.zh-CN.md)
- [日本語](README.ja.md)
- [한국어](README.ko.md)
- [Español](README.es.md)
- [Português (Brasil)](README.pt-BR.md)
- [Deutsch](README.de.md)
- [Français](README.fr.md)

## 想解决的问题

功能开发经常在目标、取舍和验证方式还没清楚时就开始。结果是反复修改：agent 太早实现，用户需要修正隐藏假设，后续 session 也丢失上下文。

QDD Codex 会把这些上下文保存在本地 plan files 中。它会提出清楚的选择题，记录 decisions，把工作切成 phases，并把 smoke-test steps 放在计划旁边。

## 适合使用

- 你有一个功能想法，但 scope 还不清楚。
- 你希望 Codex 在规划实现前先问对齐问题。
- 你想要可以在后续 Codex sessions 继续执行的 phase files。
- 你希望 review、fix、smoke-test steps 都是明确步骤。

## 不适合使用

- 你只需要非常小的一行修改。
- 你已经有完整的 issue、spec 和 task breakdown。

## 快速开始

从新的 checkout 开始：

```bash
git clone https://github.com/starazzip/QDD-codex.git
cd QDD-codex
```

从 local marketplace 安装：

```bash
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

在 repository root 执行时，Windows PowerShell、macOS 和 Linux 都使用同一组命令：

```powershell
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

如果你的 Codex 版本显示不同的 marketplace name：

```bash
codex plugin marketplace list
codex plugin add qdd-codex@<marketplace-name>
```

安装后重新启动 Codex 或开启新的 thread，让 skill list 刷新。

## 命令参考

| Command | 使用时机 | Input | Output |
| --- | --- | --- | --- |
| `/qdd-whereami` | 查看当前 QDD 进度。 | 当前 workspace plans。 | Active plan、stage、current phase、last action、next action、blockers 和 important files。 |
| `/qdd {description}` | 开始新的 feature plan。 | 简短功能描述。 | `plans/<slug>/README.md`、`AGENTS.md` 和 `questionnaire.md`。 |
| `/qdd-align` | questionnaire 已回答，或可以接受 defaults。 | Active plan questionnaire。 | `decisions.md`，必要时加 follow-up questions。 |
| `/qdd-plan` | `decisions.md` 已确认。 | Plan goal 和 decisions。 | `phases/phase-XX.md` files。 |
| `/qdd-phase {N}` | 实现一个 phase。 | 单一 phase number。 | Scoped changes、verification results、phase status updates。 |
| `/qdd-phase all` | 完成 active plan 的所有 phases。 | Active plan with phases。 | 按顺序运行所有 phases，需要时使用 review/fix，然后关闭 plan。 |
| `/qdd-review {N\|all}` | Review 已完成的 phase work，但不修复。 | 一个 phase 或 `all`。 | Correctness、security、maintainability、missing tests 和 docs drift findings。 |
| `/qdd-phase-fix {N\|all}` | 修复 review findings 或 failed verification。 | 一个 phase 或 `all`，以及 findings 或 failure output。 | Targeted fixes、rerun verification、updated phase status。 |
| `/qdd-smoke {target}` | 创建手动验证步骤。 | Plan 或 phase target。 | 包含 user-facing smoke-test steps 的 `smoke.md`。 |

## Phase Loop

`/qdd-phase` 会刻意保持小范围：

1. Read plan context。
2. Plan the phase steps and risks。
3. 需要时加入 BDD scenarios；不适用时记录原因。
4. 需要时加入 tests；不适用时记录原因。
5. 只实现 selected phase scope。
6. 运行 relevant verification。
7. Wrap up phase status 和 smoke-test notes。

Review 和 fix 是独立命令，让实现、独立评估和修复成为分开的检查点。

## 示例

```text
/qdd Add team invitation emails with role selection and expiration
```

Codex 会创建本地 plan folder 和 questionnaire，用来澄清谁能邀请队友、有哪些 roles、邀请多久后过期、email content 需要包含什么，以及失败时如何处理。

回答 questionnaire 或接受 recommended defaults 后：

```text
/qdd-whereami
/qdd-align
```

Review `decisions.md`，确认 expected behavior 和 non-goals 符合你的意图。确认后：

```text
/qdd-plan
```

阅读生成的 phases，然后一次实现一个 phase：

```text
/qdd-phase 1
/qdd-review 1
/qdd-phase-fix 1
```

前面的 phases 看起来没问题后，完成剩余已确认的 phases：

```text
/qdd-phase all
```

交付前创建 user-facing verification steps：

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
