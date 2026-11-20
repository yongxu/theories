# A trial on twenty theorems: do tellings that carry their premises let a reader recover them?

*AI-written (Claude Fable, the session that ran the survey), 21 November 2026, about 01:00 WIB. A small trial of the roadmap's last step, the tellings following the Lean. Nothing in the repository was edited by it: no docstring, chapter or record. The session that holds board row DJ weighed it and asked for it at a ceiling of 500,000 tokens, after Ren was shown that ceiling; he did not himself say yes. No person has read this. The files beside it are the trial's inputs and outputs, as text.*

## What was asked

The survey's second round set three tellings (the docstring, the record's law, the chapter's sentence) against the Lean statement for twenty headline theorems, by two models. No telling was false of its own theorem. For 14 of the twenty, at least one telling says more than the statement, most often by dropping a premise: 21 tellings in all.

The trial asks whether a wording that carries the premises does better for a reader who has only the telling. Written down before it ran, and sent to the session holding row DJ, was what would count as nothing learned:

1. the checker finds the proposed wordings no closer to the signatures than the present ones; or
2. the judge with the proposed wordings recovers no more premises than the judge with the present ones.

## How it ran

Every text was extracted by script and pasted into the agent's one input file. No agent searched or opened anything else.

| Agent | Model | Given | Tool calls | Tokens |
|---|---|---|---|---|
| Writer A, Writer B | Fable | 7 theorems each: signature, the three tellings as they stand, both models' fault notes | 1 file read each | 145,445 together |
| Judge, present arm | Fable | for the 11 theorems with a hypothesis: the flagged tellings as they stand, and a situation | 1 file read | 135,391 together |
| Judge, proposed arm | Fable | the same 11 and the same situations, with the proposed wordings | 1 file read | |
| Checker | astra 6.2, medium | all 14 signatures with their section premises, present and proposed wordings, the writers' hypothesis lists, both judges' answers | 0 commands, 54 seconds | 34,800 |

For each theorem with a hypothesis the writer also wrote a situation that meets every hypothesis but one. Neither judge saw the Lean, the hypotheses, or which one the situation fails.

## What came back

**The wordings (checker).** Of 21 proposed wordings, 13 are exact against the signature, 5 still say more, 1 says less, and 2 could not be judged without definitions the checker was not given. All 21 are closer to the signature than the telling that stands now.

**The writers' hypothesis lists (checker).** Complete and right for all 11 theorems that have a hypothesis; 41 hypotheses in all.

**The judges (scored by the checker).**

| | Hypotheses recovered | Said "does not apply" | For the right reason |
|---|---|---|---|
| Tellings as they stand | 17 of 41 | 6 of 11 | 4 of 11 |
| Proposed wordings | 40 of 41 | 11 of 11 | 11 of 11 |

With the tellings as they stand, the judge said the result applies to a situation that fails a hypothesis in 3 of 11 cases and could not tell in 2. Neither condition for "nothing learned" is met.

## Where the proposed wordings are still not exact

One round of writing is not enough. The checker's eight, by theorem number in `inputs.json`:

- 2, chapter: "whatever it starts from" is wider than a whole-number start.
- 4, chapter: "otherwise keeping the same" does not limit the agreement to the listed items.
- 5, docstring: "the one born at offset π i" names a birth the displayed conclusion does not.
- 6, chapter: one premise is tied to only part of the conclusion.
- 10, record: an opening disjunction and "at every step" go beyond the displayed equivalence.
- 12, record: a claim about a lineage is added; the signature concludes that a parent exists.
- 3, chapter, and 5, record: not judged, for want of definitions.

## What it cannot show

- **The situations were written by the writers of the proposed wordings**, from their own hypothesis lists. A wording and a case made by the same hand fit each other. A fairer test has the cases written by someone who sees only the signature.
- **One judge per arm, one checker, one run.** The judges are the same model as the writers.
- **Signatures were extracted by script.** Section variables and included premises were found for the checker by a second script; for one theorem (9) five of its seven hypotheses are such premises and are invisible in the signature alone. Definitions were not extracted, so words like "listed once" could not be checked.
- **Eleven theorems, chosen because a telling was already found wanting.** It says nothing of how often tellings mislead across the 537 theorem records.
- **No proof was read and nothing was built.**

## What a mend would touch

By script (`mend-cost.json`), if the 21 were mended as proposed:

- 9 docstrings in 9 Lean files of the core package. 36 records are bound to those files by whole-file hash; each would be bound again after a core run.
- 7 chapter sentences in 4 chapters (01, 02, 03, 07). A rewritten line in a section a record cites counts as drift for that record.
- 5 record laws.

None of this is done. The eight wordings above want a second writer and a second check first.

## What it cost

315,636 tokens by the harnesses' counts (145,445 + 135,391 + 34,800), under the ceiling of 500,000, and about 25 minutes of wall time with the extraction. This session's own tokens, for the scripts and this record, are not in that count.

## Files

`extract.py.txt` and `inputs.json` (the 14 theorems with their texts and section premises); `writer-A.md.txt`, `writer-B.md.txt`, `writers.json`; `judge-present.md.txt`, `judge-proposed.md.txt`, `judges.json`; `checker.md.txt`, `checker.schema.json`, `checker.json`; `mend-cost.json`.
