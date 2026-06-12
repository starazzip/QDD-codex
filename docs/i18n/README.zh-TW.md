# QDD Codex

[English](../../README.md) | [繁體中文](README.zh-TW.md)

QDD Codex 是 Codex-first 的問卷驅動開發流程。它會把簡短功能描述轉成計畫資料夾，先用問卷對齊需求，再整理決策、切分 phase、執行實作，最後產生冒煙測試步驟。

英文版 `README.md` 是 canonical 來源。這份繁體中文 README 是 GitHub 可見的使用者文件；完整本機翻譯工作區可以放在 `translations/zh-TW/`，且不進版控。

## 指令

安裝或啟用 plugin skill 後，可以使用：

```text
/qdd {功能描述}
/qdd-align
/qdd-plan
/qdd-phase {1~X}
/qdd-phase-all
/qdd-smoke {計畫或 phase}
```

Codex CLI 有內建 slash commands，而可重複使用的自訂工作流最穩定的做法是透過 skills/plugins。QDD 會把這些 slash-style prompt 當成 skill trigger。如果目前使用的 Codex 介面沒有直接路由自訂 slash 文字，請用 `/skills` 或 `$qdd-workflow` 明確選取 skill，再貼上相同指令文字。

## 快速安裝

從此 repo 本機安裝：

```powershell
.\scripts\install.ps1
```

從全新 checkout 安裝：

```powershell
git clone https://github.com/starazzip/QDD-codex.git
cd QDD-codex
.\scripts\install.ps1
```

也可以手動執行：

```powershell
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

如果你的 Codex 顯示不同 marketplace 名稱，請先查詢再安裝：

```powershell
codex plugin marketplace list
codex plugin add qdd-codex@<marketplace-name>
```

安裝後請重新啟動 Codex 或開新 thread，讓 skill 清單刷新。

## 專案結構

```text
.codex-plugin/plugin.json        Plugin manifest.
.codex/config.toml               repo-local Codex agent 註冊。
.codex/agents/*.toml             維護本 repo 用的 read-oriented agent roles。
skills/qdd-workflow/SKILL.md     Canonical QDD workflow behavior.
skills/qdd*/SKILL.md             Slash-style command aliases.
docs/rules/                      Codex best-practice rules.
docs/templates/                  Workflow templates.
docs/CODEX_BEST_PRACTICES.md     Codex 使用準則。
docs/i18n/                       進版控的使用者翻譯文件。
translations/zh-TW/              本機完整繁中翻譯工作區，不進版控。
```

## Git 遠端

canonical repository：

```text
https://github.com/starazzip/QDD-codex.git
```

## 工作流程

1. `/qdd {描述}` 建立 `plans/<slug>/`，只產生 `README.md`、`AGENTS.md`、`questionnaire.md`。
2. `/qdd-align` 讀取問卷，整理 `decisions.md`，必要時追加問題。
3. `/qdd-plan` 在使用者確認 `decisions.md` 後建立 `plans/<slug>/phases/phase-XX.md`。
4. `/qdd-phase {1~X}` 執行指定 phase。
5. `/qdd-phase-all` 使用 goal 追蹤所有 phase，完成後移到 `plans/done/<slug>/`。
6. `/qdd-smoke {target}` 產生詳細冒煙測試步驟。

`plans/` 是本機 workflow 狀態，會被 Git 忽略。

## 設計規則

- 這個專案只面向 Codex 生態系。
- 英文 workflow、skills、agents、rules、templates 是 canonical。
- 需要 GitHub 可見的繁中使用者文件時，放在 `docs/i18n/`。
- 完整本機翻譯工作區放在 `translations/zh-TW/`，不進版控。
- 使用 `AGENTS.md` 放 repo 持久規範，使用 skills 放可重複工作流，使用 plugins 做安裝散發。
- 主 Codex agent 預設仍是 implementer/integrator；repo-local `.codex/agents/*.toml` 角色預設 read-oriented，用於 planning、review、security、build failures、E2E、cleanup 等檢查點。
- 不建立 Claude 專用檔案、hooks、commands 或 runtime configuration。
