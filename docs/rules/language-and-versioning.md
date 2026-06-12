# Language And Versioning Rules

- English is the canonical language for versioned workflow files.
- GitHub-visible Traditional Chinese user documentation lives under `docs/i18n/`.
- Full local Traditional Chinese translation work lives under `translations/zh-TW/`.
- `translations/` must stay ignored by Git.
- `docs/i18n/` is versioned and may contain selected user-facing translations.
- When an English canonical file changes, update the matching Traditional Chinese translation locally.
- Keep translation files structurally aligned with the English source so drift is easy to detect.
- Plan artifacts that require user confirmation, including `questionnaire.md`, `decisions.md`, and `smoke.md`, must use the user's preferred language.
