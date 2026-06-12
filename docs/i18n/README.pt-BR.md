# QDD Codex

[English](../../README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Deutsch](README.de.md) | [Français](README.fr.md)

QDD Codex é um Codex plugin para **Questionnaire-Driven Development**. Ele ajuda você a não sair de uma ideia vaga direto para code, transformando cada pedido em um ciclo leve:

```text
questionnaire -> decisions -> phases -> implementation -> review/fix -> smoke test
```

Use quando quiser que o trabalho do Codex seja explícito, retomável e fácil de verificar.

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

## O Problema

Trabalho de feature muitas vezes começa antes de objetivo, tradeoffs e caminho de verificação estarem claros. Isso gera retrabalho: o agent implementa cedo demais, o usuário corrige suposições escondidas e sessions futuras perdem contexto.

QDD Codex mantém esse contexto em plan files locais. Ele faz perguntas claras de múltipla escolha, registra decisions, divide o trabalho em phases e mantém smoke-test steps perto do plan.

## Use Quando

- Você tem uma ideia de feature, mas o scope ainda está indefinido.
- Você quer que o Codex faça alignment questions antes de planejar a implementation.
- Você quer phase files que possam ser retomados em futuras Codex sessions.
- Você quer review, fix e smoke-test steps explícitos.

## Não Use Quando

- Você só precisa de uma alteração minúscula de uma linha.
- Você já tem issue, spec e task breakdown completos.

## Quick Start

A partir de um checkout novo:

```bash
git clone https://github.com/starazzip/QDD-codex.git
cd QDD-codex
```

Instale pelo local marketplace:

```bash
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

Os mesmos comandos funcionam no Windows PowerShell, macOS e Linux quando executados na repository root:

```powershell
codex plugin marketplace add .
codex plugin add qdd-codex@qdd-codex-local
```

Se a sua versão do Codex mostrar outro marketplace name:

```bash
codex plugin marketplace list
codex plugin add qdd-codex@<marketplace-name>
```

Reinicie o Codex ou abra uma nova thread depois de instalar para atualizar a skill list.

## Command Reference

| Command | Quando usar | Input | Output |
| --- | --- | --- | --- |
| `/qdd-whereami` | Verificar o progresso atual do QDD. | Current workspace plans. | Active plan, stage, current phase, last action, next action, blockers e important files. |
| `/qdd {description}` | Iniciar um novo feature plan. | Uma descrição curta. | `plans/<slug>/README.md`, `AGENTS.md` e `questionnaire.md`. |
| `/qdd-align` | O questionnaire foi respondido ou defaults são aceitáveis. | Active plan questionnaire. | `decisions.md`, mais follow-up questions se necessário. |
| `/qdd-plan` | `decisions.md` foi confirmado. | Plan goal e decisions. | `phases/phase-XX.md` files. |
| `/qdd-phase {N}` | Implementar uma phase. | Um único phase number. | Scoped changes, verification results, phase status updates. |
| `/qdd-phase all` | Completar todas as phases do active plan. | Active plan with phases. | Executa todas as phases em ordem, usa review/fix quando necessário e fecha o plan. |
| `/qdd-review {N\|all}` | Revisar phase work concluído sem corrigir. | Uma phase ou `all`. | Findings de correctness, security, maintainability, missing tests e docs drift. |
| `/qdd-phase-fix {N\|all}` | Corrigir review findings ou failed verification. | Uma phase ou `all`, mais findings ou failure output. | Targeted fixes, rerun verification e updated phase status. |
| `/qdd-smoke {target}` | Criar passos de verificação manual. | Plan ou phase target. | `smoke.md` com user-facing smoke-test steps. |

## Phase Loop

`/qdd-phase` fica intencionalmente pequeno:

1. Read plan context.
2. Plan the phase steps and risks.
3. Adicionar BDD scenarios quando útil; caso contrário, registrar o motivo.
4. Adicionar tests quando útil; caso contrário, registrar o motivo.
5. Implementar apenas o selected phase scope.
6. Executar relevant verification.
7. Wrap up phase status e smoke-test notes.

Review e fix são comandos separados para manter implementation, avaliação independente e correção como checkpoints distintos.

## Example

```text
/qdd Add team invitation emails with role selection and expiration
```

Codex cria um local plan folder e um questionnaire que esclarece quem pode convidar teammates, quais roles existem, por quanto tempo invitations ficam válidos, qual email content é necessário e como lidar com falhas.

Depois de responder o questionnaire ou aceitar os recommended defaults:

```text
/qdd-whereami
/qdd-align
```

Revise `decisions.md` para confirmar o expected behavior e os non-goals. Quando estiver alinhado com sua intenção:

```text
/qdd-plan
```

Leia as phases geradas e implemente uma phase por vez:

```text
/qdd-phase 1
/qdd-review 1
/qdd-phase-fix 1
```

Quando as primeiras phases estiverem boas, conclua as remaining approved phases:

```text
/qdd-phase all
```

Crie user-facing verification steps antes do handoff:

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
