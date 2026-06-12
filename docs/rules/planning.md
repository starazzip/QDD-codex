# Planning Rules

- Start with alignment, not implementation.
- Store every plan under `plans/<plan-slug>/`.
- Keep `plans/` out of version control; it is local working state.
- Use stable filenames: `README.md`, `AGENTS.md`, `questionnaire.md`, `decisions.md`, `smoke.md`, and `phases/phase-XX.md`.
- Use plain language that a non-specialist can understand.
- Make assumptions explicit and mark them as defaults.
- Do not create phases until `decisions.md` has been confirmed by the user.
- Keep each phase independently reviewable and verifiable.
- Phase files should follow the cadence `Plan -> BDD -> TDD -> Implement -> E2E -> Review -> Fix -> Wrap up`.
- If BDD, TDD, or E2E is skipped, the phase must state why.
