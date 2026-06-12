# QDD Codex

[English](../../README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Deutsch](README.de.md) | [Français](README.fr.md)

QDD Codex ist ein Codex plugin für **Questionnaire-Driven Development**. Es hilft dabei, nicht von einer unklaren Feature-Idee direkt in code zu springen, sondern jede Anfrage in einen leichten Ablauf zu bringen:

```text
questionnaire -> decisions -> phases -> implementation -> review/fix -> smoke test
```

Nutze es, wenn Codex-Arbeit ausdrücklich, wiederaufnehmbar und leicht prüfbar sein soll.

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

## Das Problem

Feature-Arbeit beginnt oft, bevor Ziel, tradeoffs und verification path klar sind. Das erzeugt Reibung: Der agent implementiert zu früh, der Nutzer korrigiert versteckte Annahmen, und spätere sessions verlieren Kontext.

QDD Codex hält diesen Kontext in lokalen plan files fest. Es stellt klare multiple-choice questions, speichert decisions, teilt Arbeit in phases und legt smoke-test steps neben den plan.

## Verwenden Wenn

- Du eine Feature-Idee hast, aber der scope noch unscharf ist.
- Codex vor der implementation planning alignment questions stellen soll.
- Du phase files möchtest, die in späteren Codex sessions fortgesetzt werden können.
- Review, fix und smoke-test steps explizit sein sollen.

## Nicht Verwenden Wenn

- Du nur eine winzige Ein-Zeilen-Änderung brauchst.
- Du bereits ein vollständiges issue, spec und task breakdown hast.

## Quick Start

Aus einem frischen checkout:

```bash
git clone https://github.com/starazzip/QDD-codex.git
cd QDD-codex
```

Aus dem local marketplace installieren:

```bash
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

Dieselben commands funktionieren in Windows PowerShell, macOS und Linux, wenn sie aus der repository root ausgeführt werden:

```powershell
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

Wenn deine Codex-Version einen anderen marketplace name meldet:

```bash
codex plugin marketplace list
codex plugin add qdd-codex@<marketplace-name>
```

Starte Codex nach der Installation neu oder öffne einen neuen thread, damit die skill list aktualisiert wird.

## Command Reference

| Command | Wann verwenden | Input | Output |
| --- | --- | --- | --- |
| `/qdd-whereami` | Aktuellen QDD-Fortschritt prüfen. | Current workspace plans. | Active plan, stage, current phase, last action, next action, blockers und important files. |
| `/qdd {description}` | Einen neuen feature plan starten. | Eine kurze feature description. | `plans/<slug>/README.md`, `AGENTS.md` und `questionnaire.md`. |
| `/qdd-align` | Das questionnaire ist beantwortet oder defaults sind akzeptabel. | Active plan questionnaire. | `decisions.md` plus follow-up questions bei Bedarf. |
| `/qdd-plan` | `decisions.md` ist bestätigt. | Plan goal und decisions. | `phases/phase-XX.md` files. |
| `/qdd-phase {N}` | Eine phase implementieren. | Eine einzelne phase number. | Scoped changes, verification results, phase status updates. |
| `/qdd-phase all` | Alle phases im active plan abschließen. | Active plan with phases. | Führt alle phases der Reihe nach aus, nutzt review/fix bei Bedarf und schließt den plan. |
| `/qdd-review {N\|all}` | Abgeschlossene phase work prüfen, ohne sie zu fixen. | Eine phase oder `all`. | Findings zu correctness, security, maintainability, missing tests und docs drift. |
| `/qdd-phase-fix {N\|all}` | Review findings oder failed verification beheben. | Eine phase oder `all` plus findings oder failure output. | Targeted fixes, rerun verification, updated phase status. |
| `/qdd-smoke {target}` | Manuelle Verifikationsschritte erstellen. | Plan oder phase target. | `smoke.md` mit user-facing smoke-test steps. |

## Phase Loop

`/qdd-phase` bleibt absichtlich klein:

1. Read plan context.
2. Plan the phase steps and risks.
3. BDD scenarios hinzufügen, wenn nützlich; sonst den Grund notieren.
4. Tests hinzufügen, wenn nützlich; sonst den Grund notieren.
5. Nur den selected phase scope implementieren.
6. Relevant verification ausführen.
7. Phase status und smoke-test notes abschließen.

Review und fix sind getrennte commands, damit implementation, unabhängige Bewertung und Behebung getrennte checkpoints bleiben.

## Example

```text
/qdd Add team invitation emails with role selection and expiration
```

Codex erstellt einen local plan folder und ein questionnaire, das klärt, wer teammates einladen darf, welche roles verfügbar sind, wie lange invitations gültig bleiben, welcher email content nötig ist und wie Fehler behandelt werden.

Nach dem Beantworten des questionnaire oder dem Akzeptieren der recommended defaults:

```text
/qdd-whereami
/qdd-align
```

Prüfe `decisions.md`, um expected behavior und non-goals zu bestätigen. Wenn es deiner Absicht entspricht:

```text
/qdd-plan
```

Lies die generierten phases und implementiere dann phase für phase:

```text
/qdd-phase 1
/qdd-review 1
/qdd-phase-fix 1
```

Wenn die frühen phases gut aussehen, schließe die übrigen approved phases ab:

```text
/qdd-phase all
```

Erstelle vor dem handoff user-facing verification steps:

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
