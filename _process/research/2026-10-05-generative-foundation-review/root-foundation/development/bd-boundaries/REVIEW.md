# BD2: the independent review and its re-check

31 October 2026. Board item BD2, not going out of a region on the root ([note §6](NOTE.md#6-not-going-out-on-the-root-board-item-bd2)).

## The review

One independent AI reader (a fresh Claude Opus agent, read only, with no part in writing the kit) read the kit's diff from the board's claim (`095de350e..b51bdac3f`, branch `bd2-crossing`), the repository's rules (AGENTS.md, RESULT-WORKFLOW) and the Lean it builds on. It was asked to check five things:

1. that each new theorem states what its name, docstring and module header say;
2. that every sentence of the texts, records, README rows, root bullets and checker scope claims exactly what the cited Lean proves, with its hypotheses, and that the Chinese says what the English says;
3. the repository's rules: record caps and public fields, one sense per term, no retired labels, Ren's words as provenance only, the nondual method, the calibration rule, wrappers, names;
4. placement and coherence: the record's home, its links, the reading's flow and anchors;
5. anything a careful reader would object to.

It was given the author's description of the change to verify, not to trust, and the scratch build's figures. It did not run the checker.
