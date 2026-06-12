# QDD Codex

[English](../../README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Deutsch](README.de.md) | [Français](README.fr.md)

QDD Codex 是 Codex plugin，用來實作 **Questionnaire-Driven Development（問卷驅動開發）**。它幫你避免從模糊需求直接跳進寫 code，而是把每個需求整理成輕量流程：

```text
問卷 -> 決策 -> phases -> 實作 -> review/fix -> 冒煙測試
```

當你希望 Codex 的工作可對齊、可續跑、可驗證，就適合使用 QDD Codex。

## 想解決的問題

很多功能開發在目標、取捨、驗證方式還沒清楚時就開始實作。結果是反覆修正、隱藏假設太多、下一次 Codex session 也很難接續上下文。

QDD Codex 會把這些上下文保存在本機 plan files 裡。它會先問清楚問題、整理決策、切分 phases，並把冒煙測試步驟放在計畫旁邊。

## 適合使用

- 你有功能想法，但 scope 還不清楚。
- 你希望 Codex 在規劃實作前先問對齊問題。
- 你需要可以在後續 Codex session 接著做的 phase files。
- 你希望 review、fix、smoke test 都是明確步驟。

## 不適合使用

- 你只需要非常小的一行修改。
- 你已經有完整 issue、spec 和 task breakdown。

## 快速開始

從全新 checkout 安裝：

```bash
git clone https://github.com/starazzip/QDD-codex.git
cd QDD-codex
```

從本機 marketplace 安裝：

```bash
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

在 repository root 執行時，Windows PowerShell、macOS、Linux 都使用同一組指令：

```powershell
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

如果你的 Codex 顯示不同 marketplace 名稱：

```bash
codex plugin marketplace list
codex plugin add qdd-codex@<marketplace-name>
```

安裝後請重新啟動 Codex 或開新 thread，讓 skill 清單刷新。

## 指令參考

| 指令 | 使用時機 | 輸入 | 輸出 |
| --- | --- | --- | --- |
| `/qdd-whereami` | 查看目前 QDD 進度。 | 目前工作區的 plans。 | active plan、狀態階段、目前 phase、最近動作、下一步、阻塞事項、重要檔案。 |
| `/qdd {description}` | 開始新功能計畫。 | 簡短功能描述。 | `plans/<slug>/README.md`、`AGENTS.md`、`questionnaire.md`。 |
| `/qdd-align` | 問卷已填寫，或接受推薦預設。 | 目前計畫的 `questionnaire.md`。 | `decisions.md`，必要時追加 follow-up questions。 |
| `/qdd-plan` | `decisions.md` 已確認。 | 計畫目標與決策內容。 | `phases/phase-XX.md`。 |
| `/qdd-phase {N}` | 執行單一 phase。 | 一個 phase 編號。 | 限定範圍的變更、驗證結果、phase 狀態更新。 |
| `/qdd-phase all` | 完成目前計畫下所有 phases。 | 已產生 phases 的目前計畫。 | 依序執行所有 phases，需要時 review/fix，最後關閉 plan。 |
| `/qdd-review {N\|all}` | review 已完成實作的 phase，但不修。 | 一個 phase 或 `all`。 | 正確性、安全性、可維護性、缺少測試、文件漂移等 findings。 |
| `/qdd-phase-fix {N\|all}` | 修 review findings 或驗證失敗。 | 一個 phase 或 `all`，加上 findings 或失敗輸出。 | 針對性修復、重新驗證、phase 狀態更新。 |
| `/qdd-smoke {target}` | 建立手動驗證步驟。 | plan 或 phase target。 | 使用者可執行的 `smoke.md`。 |

## Phase 閉環

`/qdd-phase` 會刻意保持較小：

1. 讀取 plan context。
2. 規劃本 phase 步驟與風險。
3. 需要時補 BDD scenarios；不需要時寫原因。
4. 需要時補 tests；不需要時寫原因。
5. 只實作指定 phase scope。
6. 執行相關驗證。
7. 更新 phase 狀態與 smoke-test notes。

Review 和 fix 是獨立指令，讓實作、獨立評估、針對性修復成為清楚分離的檢查點。

## 範例

```text
/qdd Add team invitation emails with role selection and expiration
```

Codex 會建立本機 plan folder 和 questionnaire，用來釐清誰可以邀請團隊成員、有哪些角色、邀請多久後失效、email 內容需要包含什麼、失敗時該怎麼處理。

填完問卷或接受推薦預設後：

```text
/qdd-whereami
/qdd-align
```

檢查 `decisions.md`，確認預期行為與不做的事都符合需求。確認後：

```text
/qdd-plan
```

閱讀產生的 phases，接著先一次執行一個 phase：

```text
/qdd-phase 1
/qdd-review 1
/qdd-phase-fix 1
```

前面的 phases 沒問題後，再完成剩下已確認的 phases：

```text
/qdd-phase all
```

交付前建立使用者可執行的驗收步驟：

```text
/qdd-smoke current plan
```

## 專案結構

```text
.codex-plugin/plugin.json        Plugin manifest.
.codex/config.toml               repo-local Codex agent 註冊。
.codex/agents/*.toml             維護本 repo 用的 read-oriented agent roles。
skills/qdd-workflow/SKILL.md     canonical QDD workflow。
skills/qdd*/SKILL.md             slash-style 指令別名。
docs/rules/                      Codex workflow rules。
docs/templates/                  generated plan templates。
docs/i18n/                       進版控的使用者翻譯文件。
```
