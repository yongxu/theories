# AG review: the whole repository, for the old defensive frame

AI-authored plan, 9 November 2026, on Ren's words of that day ([source](../../../../../../sources/15-codex-theory-conversations/2026-11-09-agents-the-map.md), message 6: "对整个repo进行review，确保之前的这些遗留问题都被发现和修正，从而让接下来的context不会误导agent和human").

## What is looked for

The habit the old AGENTS.md set, wherever it reached text that people or agents read next:

1. **Purpose missing or undercut** where a reader or agent learns what this is: the map for alignment, the map of wisdom, shared understanding, absent, or stated and taken back in the same breath ("the want is theirs … nothing shows it met").
2. **Defence as the frame**: qualifiers leading; value measured by mathematical novelty ("none of the central results is new mathematics" used as the work's identity; "none of them a discovery", which does not follow from it); a standing attached to every sentence; "neither asserted" repeated as a posture.
3. **Principles above the map**: honesty, standing, rigour, warrant or readiness written as rules over the work instead of patterns within it; a should from outside; dualist pairs set over the account.
4. **Under-saying**: what exists (the laws of selection, the meta-attractor's lock, the atlas and crosswalk, the uses in alignment, the tests run) left unsaid where it would help a reader.
5. **The old order or readiness criterion carried on** ("what is false in what a reader is told" first; "ready for readers when no such error is left"; "other work after these") in the board, process pages, directives and review covers.
6. **AI readings set over Ren's aim**: "Where the words go further than the work", "read as …" glosses that shrink what he asked for, "provenance, not authority" used to set direction.

And the opposite error, which no fix may introduce: saying more than is there ("designed a better alignment", "for the first time, the whole space", "consensus"), losing a counterexample, a failed test or what a proof proves exactly.

## Limits on fixes

- Ren's words in `sources/` stay verbatim; only AI-authored sections there change, and then only where they mislead the next reader.
- Generated pages are fixed at their source (records, `research-config.json`'s `readme_*` keys, `_process/navigation/*`, atlas entries, generator templates), then rendered.
- A note section a record cites is frozen (research-check); a finding there is listed, not edited.
- Frozen test designs and review-packet tags stay as frozen; their live covers may say what they are.
- Before-copies in `history/` stay as they are.

## Coverage and agents (proposed)

| Stage | Agents | What |
|---|---|---|
| Find: whole reads | 13 | README first-screen sources and both renders; ONE-PAGE; ONE-PAGE.zh; THE-THEORY; OPENING; USES, USES-EXAMPLES, TESTS; 07; 08; chapters 01–06 openings and limits sections; GLOSSARY, MAP, OPEN-QUESTIONS, theories/README, LINEAGE and CROSSWALK fronts; review covers; board, RESULT-WORKFLOW, REPOSITORY-LAYOUT, GOALS, WHAT-REMAINS; RESEARCH-DIRECTIVES |
| Pointed by a peer | (in the generator sweep) | the qualifier passes of RW (c) piled "how far it has been seen" wording into every restatement of LINEAGE's arc in brief and the spine picture's key: `tools/research/spine.py` (`picture_key`, `how_to_read`), `theories/becoming/results/data/lineage.json` (`words`), `tools/research/connection_map.py`'s picture words |
| Find: sweeps | 5 | AI-authored sections of 360 source records; generator templates in `tools/research`; the 558 result records by the frame's phrases; 42 experiment fronts; my 316 project memories |
| Perspectives | 2 | Fable and astra each cold-read the same core (README, ONE-PAGE, USES, OPENING) under the new AGENTS.md, independently |
| Verify | ~18 | one adversarial verifier per finder's output: is it the old frame, and does the fix say more than is there or lose something true |
| Fix | ~14 | disjoint file groups in one worktree, sources not views |
| Completeness critic | 1 | what was not read, what kind of finding is missing |

About 53 agents, read-only except the fix stage; no builds in the agents. Then one render, the gate on the merged tree, one landing. Anything that changes direction (the board's "The way now", AGENTS.md) is shown to Ren before it lands.

## Holds and pointers from the other sessions (9 November)

The find and verify stages read main as it stands; the fix stage takes each held file only after its holder's landed clause.

- **WX** (crosswalk re-read by claim): LANDED main 976e2bafb, content tip a1b112c08; its files are free. It held `results/atlas/entries/{correspondences,dynamics,correspondence_groups}.json`, the pages generated from them and `development/wx-atlas-after-wb/`. Start from its NOTE.md, `kit/check.py` and `review/fields-changed.md`. Many fields carry WB's tails ("neither asserted, no warrant from outside sought"); cutting them to the claim each qualifies, and saying what each tradition saw and where it meets the account, is a whole-crosswalk pass for this review. Homes WX lists as still in the old frame: 07 §2's D45 sentence; COLLECTIVE-DIRECTION §4 and §8; dossier B's B-34; records `generation-and-degeneration-at-two-grains`, `whole-drawing-beyond-renewal-ends`, `a-code-formed-between-formations`, `least-loss-rest`.
- **rw-zh10** (Chinese fronts; last reader rounds): holds `_process/navigation/README-ZH.md` (not its 这是什么), ONE-PAGE.zh, THE-THEORY.zh, USES.zh, USES-EXAMPLES.zh, GLOSSARY.zh, review/README.zh, a new OPENING.zh.md, and the zh generators' strings. Chinese front rewrites wait for its tip.
- **rw-iter4** (coordinator; after WX): holds README-FIRST-SCREEN's "What it is for", USES.md ("At a glance"), the shared nav line, reading times and READING-BUDGETS, OPENING.md's header dates and three notes, the site builder. After it lands, RW stops rewording the fronts until this review sets their frame; its fifth re-score (`~/tmp/rw/drafts/rescore5-synthesis.md`) asks Q1/Q5 a plain statement of what the work is for and does, Q6 shorter uses cells. Ren's 8 November rule for the screen stands (AI mentioned once; no person named).
- **WB** (nothing in flight): its text is in scope, heaviest at the first screen's ethics line ("Its ethics asserts no should; its rankings mostly rest on two readings, neither asserted"), ONE-PAGE's ethics paragraph and T8 row in both languages, 07's ethics section, T8, §3.3 and §4, 08 lines 112, 435, 448, 600, 646, 710, 745, 758, OPENING's revised passages, USES, USES-EXAMPLES, the dossiers (PHILOSOPHY P-26), the atlas restatements, and the goal wordings in WB's FOR-OTHERS.md#for-ren (read before they reach Ren). Five reader rounds went mostly to re-saying qualifiers.
- **Theory progress** (nothing in flight): RW (c)'s qualifier passes piled "how far it has been seen" wording into `spine.py` (`picture_key`, `how_to_read`), lineage.json's `words`, connection_map.py's picture words.
