# The sample, frozen before coding

The re-coding sample was drawn on 24 October 2026, before any human coded a unit, by [`sample.py`](../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/review-packet/sample.py) with seed `20261024`, from the 4,116 units of the corpus classification (two frozen rounds, eleven files; [the classification](../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/classify/REPORT.md)).

| | |
|---|---|
| Units | 237 |
| Strata | text file × the AI's class; each file at least ten units, in proportion to the square root of its size; each class present in a file at least three units (or all, where it has fewer), the rest in proportion |
| Sheet (blind: no AI class, no AI note) | [`SHEET.tsv`](SHEET.tsv), sha256 `40cfa4836ea9d70150c339eb15a0313d4c1b9fabb227ad695300febb3fa38dcb` |
| Key (the AI's class and each unit's inclusion probability) | kept in the study folder, sha256 `43e18aea09a7395bfb70ece7f37797d329bef002c1207fd8b4c7bdb82c14e5f7`; coders are asked not to open it |
| Analysis | [`agreement.py`](agreement.py): Cohen's kappa of each coder against the AI, agreement weighted back to the corpus, agreement per class and the confusion matrix; Krippendorff's alpha among coders |

**Reading of the result, fixed now.** Agreement is reported, not passed or failed. Kappa of at least 0.6 between a coder and the AI is read as substantial agreement on the classification as a whole; a class whose units a coder classes otherwise in more than half the cases is read as a class the AI applied differently from the codebook. Coders are asked to code before reading any dossier; since the dossiers quote some sampled units with the AI's class, every coder's figures are also reported without those units (agreement.py finds them by scanning the dossiers). Every unit on which a coder and the AI disagree is reread, and the classification's counts in [the classical-texts chapter](../../chapters/06-CLASSICAL-TEXTS.md) are reported beside the agreement until it is rerun.

Re-running `sample.py` with the same seed on the same corpus gives the same two files byte for byte.
