# Checked application models

These three modules compose existing Becoming components into a small feedback
example. The sources preserve the original study trials' Lean statements.

| Module | Theorems | Source declarations | Scope |
|---|---:|---:|---|
| FeedbackReadingTrial | 15 | 25 | Four stipulated situations, ambiguous wording, sound evidence refinement |
| InteractionHistoryTrial | 15 | 30 | Different retained histories; Boolean one-exchange update |
| GradualInteractionTrial | 23 | 45 | Weighted experiences, thresholds, lapses, retry, exact finite-plan abstraction |

Each verifier requires Lean 4.29.1, compiles the imported closure using the
repository's existing scratch builder, rejects warnings, and checks empty
reported axiom dependencies for its source declarations. The gradual closure
contains 50 source modules. Receipts name the exact source and verifier hashes;
they are local application checks rather than full package purity audits.

The browser defaults to the gradual module. Earlier Boolean updates are a
dependency and remain a separate model, rather than being reinterpreted as
gradual learning. Supporting, defensive and unresolved experiences are supplied
categories. Weights, thresholds, credibility, receptivity and opportunities to
choose clarification are supplied assumptions; no actual dialogue was measured.

See the [atlas documentation](../README.md) for reproduction commands, imported
components, human correspondence and the boundaries of the higher-level views.

## Research-informed extension

[Three-part learning model](RESEARCH-INFORMED-MODEL.md) separates expectation,
confidence and credibility, with exact same-lapse comparisons for both partners.
[Psychological grounding](PSYCHOLOGICAL-GROUNDING.md) records primary research and
assumption limits. Run `LEAN=/absolute/path/to/lean python3 -B verify_research.py`.
