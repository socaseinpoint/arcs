# Finding — the Russian is intentional i18n, not stray code

The Cyrillic in `bin/arcs` (lines ~117-130, 167-180) is the **`ru)` branch** of a deliberate
language `case` in `arc_md()` / `goal_md()`. Each has three branches:

- `*)`  → English (default)
- `ru)` → Russian
- `es)` → Spanish

The branch is selected by the project's `lang` (set at `arcs init en|ru|es`, line 113 comment:
"Field KEYS stay English so the parser is language-agnostic; only the human placeholder text +
headings are localized").

So the candidate's premise — "English-only code" — is wrong. This isn't leftover Russian; it's the
`lang=ru` feature's localized scaffold. The CLI logic and comments are already English.

## Implication

- **Translate ru→en** would delete the Russian locale and break `arcs init ru` (and by symmetry the
  argument for `es`). Net loss of a shipped feature.
- The only English-only-code reading that's coherent is "drop ru+es locales entirely" — a real
  product decision, not a cleanup.

## Options

1. **Keep as-is** — it's correct i18n. Close 19 as investigated, no change. (recommended)
2. **Drop ru+es, English-only templates** — removes the localization feature; `lang` collapses to en.
3. **Verify + polish the locales** — keep all three, just proofread ru/es for accuracy/consistency.
