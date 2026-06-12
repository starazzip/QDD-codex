# QDD Codex

[English](../../README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Deutsch](README.de.md) | [Français](README.fr.md)

QDD Codex は **Questionnaire-Driven Development** のための Codex plugin です。あいまいな機能アイデアからすぐに code へ進むのではなく、各リクエストを軽量なループに整理します。

```text
questionnaire -> decisions -> phases -> implementation -> review/fix -> smoke test
```

Codex の作業を明確で、再開しやすく、検証しやすいものにしたいときに使います。

## 解決したい問題

機能開発は、ゴール、トレードオフ、検証方法が明確になる前に始まりがちです。その結果、agent が早く実装しすぎたり、ユーザーが隠れた前提を修正したり、後続の session で文脈が失われたりします。

QDD Codex はその文脈をローカルの plan files に保存します。分かりやすい multiple-choice questions を出し、decisions を記録し、作業を phases に分け、smoke-test steps を plan の近くに置きます。

## 向いているケース

- 機能アイデアはあるが scope がまだあいまい。
- Codex に実装計画の前に alignment questions を聞いてほしい。
- 後続の Codex sessions で再開できる phase files がほしい。
- review、fix、smoke-test steps を明確にしたい。

## 向いていないケース

- 1 行だけの小さな修正で十分。
- すでに完全な issue、spec、task breakdown がある。

## Quick Start

新しい checkout から始めます。

```bash
git clone https://github.com/starazzip/QDD-codex.git
cd QDD-codex
```

local marketplace から install します。

```bash
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

repository root で実行する場合、Windows PowerShell、macOS、Linux で同じ commands を使えます。

```powershell
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

Codex のバージョンが異なる marketplace name を表示する場合：

```bash
codex plugin marketplace list
codex plugin add qdd-codex@<marketplace-name>
```

install 後は Codex を再起動するか新しい thread を開始して、skill list を更新してください。

## Command Reference

| Command | 使うタイミング | Input | Output |
| --- | --- | --- | --- |
| `/qdd-whereami` | 現在の QDD 進捗を確認する。 | Current workspace plans。 | Active plan、stage、current phase、last action、next action、blockers、important files。 |
| `/qdd {description}` | 新しい feature plan を開始する。 | 短い feature description。 | `plans/<slug>/README.md`、`AGENTS.md`、`questionnaire.md`。 |
| `/qdd-align` | questionnaire に回答済み、または defaults を受け入れる。 | Active plan questionnaire。 | `decisions.md`、必要に応じて follow-up questions。 |
| `/qdd-plan` | `decisions.md` が確認済み。 | Plan goal と decisions。 | `phases/phase-XX.md` files。 |
| `/qdd-phase {N}` | 1 つの phase を実装する。 | 単一の phase number。 | Scoped changes、verification results、phase status updates。 |
| `/qdd-phase all` | active plan のすべての phases を完了する。 | Active plan with phases。 | すべての phases を順番に実行し、必要に応じて review/fix して plan を閉じる。 |
| `/qdd-review {N\|all}` | 完了した phase work を修正せずに review する。 | 1 つの phase または `all`。 | correctness、security、maintainability、missing tests、docs drift の findings。 |
| `/qdd-phase-fix {N\|all}` | review findings または failed verification を修正する。 | 1 つの phase または `all` と findings / failure output。 | Targeted fixes、rerun verification、updated phase status。 |
| `/qdd-smoke {target}` | 手動検証手順を作成する。 | Plan または phase target。 | user-facing smoke-test steps を含む `smoke.md`。 |

## Phase Loop

`/qdd-phase` は意図的に小さく保ちます。

1. Read plan context。
2. Plan the phase steps and risks。
3. 有用な場合は BDD scenarios を追加し、不要なら理由を記録する。
4. 有用な場合は tests を追加し、不要なら理由を記録する。
5. selected phase scope だけを実装する。
6. relevant verification を実行する。
7. phase status と smoke-test notes を wrap up する。

Review と fix は別々の commands です。実装、独立した評価、修正を分けた checkpoint にします。

## Example

```text
/qdd Add team invitation emails with role selection and expiration
```

Codex は local plan folder と questionnaire を作成し、誰が teammates を招待できるか、どの roles があるか、招待の有効期限、必要な email content、失敗時の扱いを明確にします。

questionnaire に回答するか recommended defaults を受け入れたら：

```text
/qdd-whereami
/qdd-align
```

`decisions.md` を review して、expected behavior と non-goals が意図どおりか確認します。問題なければ：

```text
/qdd-plan
```

生成された phases を読み、1 phase ずつ実装します。

```text
/qdd-phase 1
/qdd-review 1
/qdd-phase-fix 1
```

初期 phases が問題なければ、残りの approved phases を完了します。

```text
/qdd-phase all
```

handoff 前に user-facing verification steps を作成します。

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
