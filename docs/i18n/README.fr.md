# QDD Codex

[English](../../README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Deutsch](README.de.md) | [Français](README.fr.md)

QDD Codex est un Codex plugin pour **Questionnaire-Driven Development**. Il aide à éviter de passer d'une idée vague directement au code en transformant chaque demande en boucle légère :

```text
questionnaire -> decisions -> phases -> implementation -> review/fix -> smoke test
```

Utilisez-le lorsque vous voulez que le travail de Codex soit explicite, reprenable et facile à vérifier.

## Le Problème

Le travail sur une fonctionnalité commence souvent avant que l'objectif, les tradeoffs et le verification path soient clairs. Cela crée des allers-retours : l'agent implémente trop tôt, l'utilisateur corrige des hypothèses cachées et les sessions suivantes perdent le contexte.

QDD Codex conserve ce contexte dans des plan files locaux. Il pose des multiple-choice questions claires, enregistre les decisions, découpe le travail en phases et garde les smoke-test steps près du plan.

## À Utiliser Quand

- Vous avez une idée de feature, mais le scope est encore flou.
- Vous voulez que Codex pose des alignment questions avant de planifier l'implementation.
- Vous voulez des phase files qui peuvent être repris dans de futures Codex sessions.
- Vous voulez que review, fix et smoke-test steps soient explicites.

## À Ne Pas Utiliser Quand

- Vous n'avez besoin que d'une minuscule modification d'une ligne.
- Vous avez déjà un issue, une spec et un task breakdown complets.

## Quick Start

Depuis un checkout frais :

```bash
git clone https://github.com/starazzip/QDD-codex.git
cd QDD-codex
```

Installez depuis le local marketplace :

```bash
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

Les mêmes commands fonctionnent sur Windows PowerShell, macOS et Linux lorsqu'elles sont exécutées depuis la repository root :

```powershell
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

Si votre version de Codex indique un marketplace name différent :

```bash
codex plugin marketplace list
codex plugin add qdd-codex@<marketplace-name>
```

Redémarrez Codex ou ouvrez un nouveau thread après l'installation afin de rafraîchir la skill list.

## Command Reference

| Command | Quand l'utiliser | Input | Output |
| --- | --- | --- | --- |
| `/qdd-whereami` | Vérifier la progression QDD actuelle. | Current workspace plans. | Active plan, stage, current phase, last action, next action, blockers et important files. |
| `/qdd {description}` | Démarrer un nouveau feature plan. | Une courte feature description. | `plans/<slug>/README.md`, `AGENTS.md` et `questionnaire.md`. |
| `/qdd-align` | Le questionnaire est rempli ou les defaults sont acceptables. | Active plan questionnaire. | `decisions.md`, plus des follow-up questions si nécessaire. |
| `/qdd-plan` | `decisions.md` est confirmé. | Plan goal et decisions. | `phases/phase-XX.md` files. |
| `/qdd-phase {N}` | Implémenter une phase. | Un seul phase number. | Scoped changes, verification results, phase status updates. |
| `/qdd-phase all` | Terminer toutes les phases de l'active plan. | Active plan with phases. | Exécute toutes les phases dans l'ordre, utilise review/fix si nécessaire, puis ferme le plan. |
| `/qdd-review {N\|all}` | Examiner le phase work terminé sans le corriger. | Une phase ou `all`. | Findings sur correctness, security, maintainability, missing tests et docs drift. |
| `/qdd-phase-fix {N\|all}` | Corriger les review findings ou failed verification. | Une phase ou `all`, plus findings ou failure output. | Targeted fixes, rerun verification, updated phase status. |
| `/qdd-smoke {target}` | Créer des étapes de vérification manuelle. | Plan ou phase target. | `smoke.md` avec des user-facing smoke-test steps. |

## Phase Loop

`/qdd-phase` reste volontairement petit :

1. Read plan context.
2. Plan the phase steps and risks.
3. Ajouter des BDD scenarios quand c'est utile ; sinon noter la raison.
4. Ajouter des tests quand c'est utile ; sinon noter la raison.
5. Implémenter uniquement le selected phase scope.
6. Exécuter la relevant verification.
7. Wrap up phase status et smoke-test notes.

Review et fix sont des commands séparées afin de garder implementation, évaluation indépendante et correction comme checkpoints distincts.

## Example

```text
/qdd Add team invitation emails with role selection and expiration
```

Codex crée un local plan folder et un questionnaire qui clarifie qui peut inviter des teammates, quels roles sont disponibles, combien de temps les invitations restent valides, quel email content est requis et comment gérer les échecs.

Après avoir répondu au questionnaire ou accepté les recommended defaults :

```text
/qdd-whereami
/qdd-align
```

Relisez `decisions.md` pour confirmer l'expected behavior et les non-goals. Lorsque cela correspond à votre intention :

```text
/qdd-plan
```

Lisez les phases générées, puis implémentez une phase à la fois :

```text
/qdd-phase 1
/qdd-review 1
/qdd-phase-fix 1
```

Lorsque les premières phases semblent correctes, terminez les remaining approved phases :

```text
/qdd-phase all
```

Créez des user-facing verification steps avant le handoff :

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
