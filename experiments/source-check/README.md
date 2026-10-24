# Source check

Does a model under-detect what its own text introduces? A crossed test (board item SC1, 23 October 2026) of the open observation in the fidelity count's calibration ([FIDELITY-RESULTS](../wenli-reading-transfer/FIDELITY-RESULTS.md#an-open-observation-the-author-coding-its-own-text)).

- Design: two authors (Claude, GPT) by two coders (the same two). 60 laws from FC1's Lean table. Each author writes a faithful plain-English statement of each law and a version with one planted excess referent. Both coders code all 240 texts by FC1's codebook v1.1, blind to authorship.
- Analysis: the author × coder interaction with a cluster bootstrap over laws.
- Pre-registered design and decision rule: [DESIGN.md](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/sc1-source-check/DESIGN.md).
- Results: [RESULTS.md](RESULTS.md).
- Kit, texts, codings and the analysis output: [`development/sc1-source-check/`](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/sc1-source-check/).
- Record: [fidelity-coders-on-own-and-other-texts](../../theories/becoming/results/records/fidelity-coders-on-own-and-other-texts.md).

Rerun: `python3 -I …/sc1-source-check/kit.py analyze` recomputes `results.json` from the committed codings. The texts and codings come from model runs and are not regenerated.
