# QDD Codex

[English](../../README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Deutsch](README.de.md) | [Français](README.fr.md)

QDD Codex es un Codex plugin para **Questionnaire-Driven Development**. Ayuda a evitar saltar desde una idea vaga directamente al code, convirtiendo cada solicitud en un ciclo ligero:

```text
questionnaire -> decisions -> phases -> implementation -> review/fix -> smoke test
```

Úsalo cuando quieras que el trabajo de Codex sea explícito, reanudable y fácil de verificar.

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

## El Problema

El trabajo de funcionalidades suele empezar antes de que el objetivo, los tradeoffs y la ruta de verificación estén claros. Eso genera cambios repetidos: el agent implementa demasiado pronto, el usuario corrige supuestos ocultos y las siguientes sessions pierden contexto.

QDD Codex mantiene ese contexto en plan files locales. Hace preguntas claras de opción múltiple, registra decisions, divide el trabajo en phases y mantiene smoke-test steps junto al plan.

## Úsalo Cuando

- Tienes una idea de feature, pero el scope aún es difuso.
- Quieres que Codex haga alignment questions antes de planificar la implementation.
- Quieres phase files que puedan retomarse en futuras Codex sessions.
- Quieres que review, fix y smoke-test steps sean explícitos.

## No Lo Uses Cuando

- Solo necesitas un cambio diminuto de una línea.
- Ya tienes un issue, spec y task breakdown completos.

## Quick Start

Desde un checkout nuevo:

```bash
git clone https://github.com/starazzip/QDD-codex.git
cd QDD-codex
```

Instala desde el local marketplace:

```bash
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

Los mismos comandos funcionan en Windows PowerShell, macOS y Linux cuando se ejecutan desde la repository root:

```powershell
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

Si tu versión de Codex muestra un marketplace name diferente:

```bash
codex plugin marketplace list
codex plugin add qdd-codex@<marketplace-name>
```

Reinicia Codex o abre un nuevo thread después de instalar para refrescar la skill list.

## Command Reference

| Command | Cuándo usarlo | Input | Output |
| --- | --- | --- | --- |
| `/qdd-whereami` | Revisar el progreso actual de QDD. | Current workspace plans. | Active plan, stage, current phase, last action, next action, blockers e important files. |
| `/qdd {description}` | Iniciar un nuevo feature plan. | Una descripción breve. | `plans/<slug>/README.md`, `AGENTS.md` y `questionnaire.md`. |
| `/qdd-align` | El questionnaire está respondido o los defaults son aceptables. | Active plan questionnaire. | `decisions.md`, más follow-up questions si hacen falta. |
| `/qdd-plan` | `decisions.md` está confirmado. | Plan goal y decisions. | `phases/phase-XX.md` files. |
| `/qdd-phase {N}` | Implementar una phase. | Un solo phase number. | Scoped changes, verification results, phase status updates. |
| `/qdd-phase all` | Completar todas las phases del active plan. | Active plan with phases. | Ejecuta todas las phases en orden, usa review/fix cuando haga falta y cierra el plan. |
| `/qdd-review {N\|all}` | Revisar phase work completado sin corregirlo. | Una phase o `all`. | Findings de correctness, security, maintainability, missing tests y docs drift. |
| `/qdd-phase-fix {N\|all}` | Corregir review findings o failed verification. | Una phase o `all`, más findings o failure output. | Targeted fixes, rerun verification y updated phase status. |
| `/qdd-smoke {target}` | Crear pasos de verificación manual. | Plan o phase target. | `smoke.md` con user-facing smoke-test steps. |

## Phase Loop

`/qdd-phase` se mantiene intencionalmente pequeño:

1. Read plan context.
2. Plan the phase steps and risks.
3. Agregar BDD scenarios cuando sea útil; si no aplica, registrar la razón.
4. Agregar tests cuando sea útil; si no aplica, registrar la razón.
5. Implementar solo el selected phase scope.
6. Ejecutar relevant verification.
7. Wrap up phase status y smoke-test notes.

Review y fix son comandos separados para mantener implementation, evaluación independiente y remediación como checkpoints distintos.

## Example

```text
/qdd Add team invitation emails with role selection and expiration
```

Codex crea un local plan folder y un questionnaire que aclara quién puede invitar teammates, qué roles existen, cuánto duran las invitations, qué email content se requiere y cómo manejar fallos.

Después de responder el questionnaire o aceptar los recommended defaults:

```text
/qdd-whereami
/qdd-align
```

Revisa `decisions.md` para confirmar el expected behavior y los non-goals. Cuando coincida con tu intención:

```text
/qdd-plan
```

Lee las phases generadas y luego implementa una phase a la vez:

```text
/qdd-phase 1
/qdd-review 1
/qdd-phase-fix 1
```

Cuando las primeras phases se vean bien, termina las remaining approved phases:

```text
/qdd-phase all
```

Crea user-facing verification steps antes del handoff:

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
