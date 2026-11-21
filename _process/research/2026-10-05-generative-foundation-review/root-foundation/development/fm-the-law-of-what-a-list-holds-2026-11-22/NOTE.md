# The law of what a list holds: how it was found, built and read

*AI-written (Claude Fable, board row FM), 22 November 2026. A record of a night's work, for whoever checks the landing or takes the next step. It tells what was done and where each thing is. The claim itself is on the board, in row FM; the statements are in the Lean; the record is [`kept-at-the-length-of-a-list`](../../../../../../theories/becoming/results/records/kept-at-the-length-of-a-list.md). Nothing here is a result.*

## Why

On 21 November Ren said the goal should be a full map with formal link proof, done elegantly, with its centre ([his words](../../../../../../sources/15-codex-theory-conversations/2026-11-21-a-full-map-with-its-centre.md)). Eight designs of a centre were refuted that night, and a read of every module of the package ([the whole read](../fm-whole-read-2026-11-22/NOTE.md)) found one thing missing at a definite place: for keeping by a choice against every outcome, the package had only the direction from a closed set to every horizon. The other direction was the first module here. What follows grew from it by readers' findings, not by a plan.

## What happened, in order

Every build was by an implementer of another kind of model (Astra 6.2), from a brief frozen before it ran, with what would count as nothing gained written in it. After each build I wrote what I expected of the next before it ran; those notes are in [AFTER-LEAN-EDGE-LAW.md.txt](AFTER-LEAN-EDGE-LAW.md.txt), with the clock, and are the running account. Every text was read by readers who took no part before the next step.

| Step | What it was | What came of it |
|---|---|---|
| `lean-edge` | The edge for a choice against every outcome on a listed world: what is viable for as many steps as there are configurations is viable one step more. | Built; two readers left it standing. |
| `lean-kept-edge` | A reader had seen that the induction used only that the step is monotone. The same said once for a monotone step on predicates, five kinds of keeping as cases. | Built. Its reader, by program over every monotone step on up to three points: a real join; the list need hold only the start; one case said twice; my sentence that the rising side "does not hold" was wrong (it holds classically). |
| `lean-edge-law` | The law standing alone, from the weaker premise, laid out by home; three statements on the rising side. | Built. A reader found that the proof for reach, which two of us had read line by line and liked, was the law's own induction written a second time, and gave the call. A sweep of all 407 modules found the law nowhere and named older results as further cases. |
| `lean-edge-law-repair` | Reach as a call; one step sooner; one route; a weaker premise for the reading. | Built; a reader: may be claimed. |
| `lean-edge-cases` | Six older results as cases; the losing side of a choice worded by a disjunction (the coordinating session's question). | Built. Reading it I saw its proof for the losing side was the induction a third time. |
| `lean-edge-law-repair-2` | One theorem for the whole ending side: where a rising step commutes with what a level would give, the level above the list's length comes down by one call of the falling bound. | Built as written on paper beforehand: three cases, each one commuting lemma and one call. |
| `lean-edge-final` | Both modules in the form that lands; the bridge said once; two short statements readers had named. | Built. |
| `landing-draft` | The text moved into fifteen module files, as a draft outside the repository; then one repair after two readers. | Built; 1,154 declarations of the fifteen modules audited, no axiom. |

## What readers changed

- That the induction used only monotonicity (so the law is not about processes).
- That the list need hold only the start's members (so it is a law of a guard a list holds, in a type that may hold more).
- That reach is a case, and so was every later "second induction": three times a proof was written that repeated the law's induction, and each time a reader set to ask "is this a call" saw it where readers who checked each line had not.
- That the two theorems of deciding are about one wording of the losing step, and show nothing of whether a choice has a positive ending side (the coordinating session). With the other wording and the moves listed it has.
- Docstrings: in every text some said more than their statements. The last were found in the landing draft, in two module docstrings.
- Of the claim on the board, after it was landed: four clauses say a little more than the Lean (the reading's further premise; "a level above" where two statements are of the level one above; "three implications" where there are four and a fifth). They are corrected by an appended sentence in row FM.

## What it is not

It has no quantity drawn down, no share, no lock and no time of reading. Through a reading its list is of codes, written by hand in the one instance built (by the session that holds row DJ). It is not one statement with both outcomes of a course with a choice, a reading and a bound on the ending side, which is what the whole read found missing and is still missing. It does not place the two ways with respect to each other. `Branching.reach_within_listed` still carries two premises it does not need; dropping them in place is owed.

## What it cost

Astra 6.2 (by its own footers): about 70 million tokens over ten runs, of which the sweep of the package 10.2 million and the landing draft with its repair 17.7 million. Claude side: about 2 million tokens in readers. Each scratch build was seconds; the machine's one long run is the core run of the landing.

## Where it is

Each folder holds its brief with the frozen hash, the implementer's report, the module as text, the last build's log, and the readers' returns; `break/` and `sweep/` hold readers' programs and a reader's sweep. Briefs: `BRIEF-*.md.txt`, hashes `FROZEN-*.sha256.txt`. [NOTES-FOR-THE-CENTRE.md.txt](NOTES-FOR-THE-CENTRE.md.txt): six statements of the package read for the next design. The scripts that applied the landing and wrote its records: `landing-draft/apply_land3.py.txt`, `record_text.py.txt`, `records3.py.txt`. `apply_land3.py` wrote the first text of the root's bullets, the README rows and the checker's scope; a reader's replacements (`landing-draft/RETURN-beside-reader-opus.md.txt`) were applied over it before the core run, and the record's `correspondence` field was added after the record check asked for it, so the landed files are those of the commits, not what the scripts alone would write.

## After: the owed landing (added 22 November, 05:38 WIB by the clock)

`Branching.reach_within_listed` lost its two unneeded premises in place the same morning, as a call of `Reaching.reach_within_of_pred_le`; `leadsWithin_trace` is deleted. What told or bound the two premises was changed with it: the record `reaching-before-and-after-a-juncture`, one sentence of chapter 2, the atlas entry's `takes` and one sentence of its mechanism, the premise `branching-decides`, the mapping row, the README row. `Junctures` now imports `ReachableRanges`. The sentence above that says it "still carries two premises" was true when written.
