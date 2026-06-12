# Language And Versioning Rules

- English is the canonical language for versioned workflow files.
- English `README.md` is the canonical source for GitHub-visible README translations.
- GitHub-visible user documentation translations live under `docs/i18n/README.<locale>.md`.
- The first maintained README locales are `zh-TW`, `zh-CN`, `ja`, `ko`, `es`, `pt-BR`, `de`, and `fr`.
- Full local Traditional Chinese translation work lives under `translations/zh-TW/`.
- `translations/` must stay ignored by Git.
- `docs/i18n/` is versioned and may contain selected user-facing translations.
- When English `README.md` changes, update the matching `docs/i18n/README.<locale>.md` files in the same work.
- Keep README translation files structurally aligned with English `README.md` so drift is easy to detect.
- Preserve commands, paths, plugin names, file names, and command names in English unless a localized explanation is needed.
- README translation updates are handled by the Codex workflow. Do not add external translation providers, API key setup, or translation scripts unless a future plan explicitly requires them.
- Plan artifacts that require user confirmation, including `questionnaire.md`, `decisions.md`, and `smoke.md`, must use the user's preferred language.
