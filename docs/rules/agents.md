# Agent Rules

- The main Codex agent remains the default implementer and integrator.
- Repo-local agent roles are defined in `.codex/agents/*.toml` and registered by `.codex/config.toml`.
- These roles are read-oriented by default. They review, diagnose, and plan unless the user or main Codex agent explicitly delegates a bounded write.
- Use a planner or architect subagent only when a phase has unclear boundaries, broad design tradeoffs, or cross-module impact.
- Use a code-reviewer subagent after code-writing phases when the change has meaningful regression risk.
- Use a security-reviewer subagent when a phase touches authentication, authorization, secrets, private data, file access, network access, payment, or permission boundaries.
- Use a build-error-resolver subagent when verification failures are non-obvious after one focused local investigation.
- Use an e2e-runner subagent when a phase changes a critical user-facing workflow.
- Use a refactor-cleaner subagent when workflow rules drift, duplication, or unnecessary abstraction becomes visible.
- Do not delegate tiny edits, mechanical documentation updates, or plan-file bookkeeping.
- Subagents should be read-oriented by default unless the user or phase explicitly allows implementation delegation.
- Do not modify global Codex config to install these agents. They are repo-local guidance for this repository.
