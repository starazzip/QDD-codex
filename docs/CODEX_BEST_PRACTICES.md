# Codex Best Practices For QDD

QDD Codex follows these Codex practices:

- Use `AGENTS.md` for durable repository instructions.
- Use skills for reusable task workflows.
- Use plugins to distribute skills.
- Keep instructions progressive: short descriptions trigger the skill, detailed behavior lives in `SKILL.md`, and templates live in `docs/templates/`.
- Keep plan state in files under `plans/<plan-slug>/` so future Codex sessions can resume without relying on chat history.
- Use `/goal` or the goal tool for long multi-phase execution.
- Keep permissions narrow in normal use; raise privileges only when a task requires it.
- Prefer explicit user confirmation before moving from alignment to planning or from planning to implementation.
- Keep generated questionnaires and decisions readable by non-engineers.
- Put smoke-test steps in user-facing language that can be followed outside Codex.

Source alignment: this structure follows the Codex manual guidance that skills are reusable workflows, plugins are installable distribution units, and `AGENTS.md` is the repository instruction surface.
