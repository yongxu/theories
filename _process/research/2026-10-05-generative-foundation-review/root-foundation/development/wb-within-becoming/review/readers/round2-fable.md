## WB round 2, reader Fable (branch `wb-homes`, 223f917bc → 00b2fbec2)

### Round-1 findings: fixed as meant, or how the fix differs

| # (round 1) | status |
|---|---|
| 1 T8 thesis / refuter | Fixed with my verb pair ("selects … less often" / "selecting … no less often"), not astra's ("abandons … no more often"); both coherent, the applied pair is consistent through 07, 08:600, ONE-PAGE, overview, PHILOSOPHY:568/576, the records and crosswalk. Chinese "选取…并不更少" now says the same. No conflict. |
| 2 README-ZH.md:23 | Fixed (now line 25). Two residues below (F, C). |
| 3 OPENING:79 | Fixed, in astra's wording; says what T8 now says. |
| 4 K7 red | Fixed: COVERAGE.json adds the class, 08:745 lists it, COMPLETION.md now "K7 … yes … 0 / met". |
| 5 overview zh:152 | Fixed: the "condition of its response, not its guarantee" clause added; the old formula sentence removed, as the English (148) dropped its counterpart under astra #14. Both languages agree. |
| 6 "only a standpoint taking the step" | Fixed in 07:3, 07:481, 07:538, 07:779, 08:758, COLLECTIVE-DIRECTION:76. |
| 7 01-ROOT:151 "asks more" | Fixed there; its sibling at 07:129 was not (new finding D). |
| 8 chapter restatements | All fixed (02 ×3, 05:182, 05:394, 03:477, 08:448, 08:484). |
| 9 fronts and dossiers | Fixed: CD:17, ONE-ARGUMENT 14/116, USES-EXAMPLES:192 (now matches its zh), 06:14, 06:565, PHILOSOPHY 47/461, ALIGNMENT:556. PHILOSOPHY 465 and 693 were left, rightly: 465's "two premises" are P2 and P4, 693 is a dated history sentence. |
| 10 THEORY-GRAPH.zh:20 | Re-rendered; matches the generator. |
| 11 USES-EXAMPLES.zh:160 | Fixed (now 165). |
| 12 T4 as T8's test | Fixed in astra's stronger form (T4 "does not test it: the bed gives the fishers nothing"); "beyond T4" removed everywhere; THEORY-GRAPH's "no test" now consistent. |
| 13 07:195 | Fixed in astra's wording. |
| 14 OPENING:75 | Fixed as proposed. |
| 15 atlas / crosswalk | The crosswalk kits re-said the "two premises / warrant open / life's way" entries; residue in G below. |
| 16–19, 21, 23, 24 | Fixed (07:219, OPENING 25/59/83, one-root:886 → "for what is offered", 07:117 "two premises stated next", comments and docstrings). |
| 20 double commas | Fixed in both records and the crosswalk. |
| 22 overview T8 open list | Not changed; still lacks "how C-like orders form" (low, kept as J). |

No fix of astra's conflicts with mine; where both of us named a line, the applied text is one of the two proposals and I agree with it.

### New findings, high first

| # | file | line | quoted (≤25 words) | sev. | what is wrong | exact replacement |
|---|---|---|---|---|---|---|
| A | theories/becoming/USES.zh.md | 28 | "**人的发展，以及生生作为对生命而言的道**" | high | Merge regression: the merge's resolution took main's (RW) version of the table row, so the Chinese heading reverted to "生生 as the way for life" while the English (USES.md:24) says "生生, the continuation of life"; the same file's own link at line 72 uses the new words. Round 1 had this fixed. | "**人的发展，以及生生，即生命之延续**" |
| B | theories/becoming/USES.zh.md | 25 (the "not claimed" cell of the alignment row) | "新的数学；延续条件与 C 有根据（[审查材料]…）" | high | Same regression: the English not-claimed list (USES.md:21) says "that anyone must hold the continuation condition or C"; the Chinese reverted to "that the condition and C are warranted", the warrant frame the revision removed. | "新的数学；有人必须持有延续条件或 C（[审查材料] (review/ALIGNMENT.md#the-dossier-in-ten-minutes)）。" |
| C | _process/navigation/zh-editions.json | 34–39, 7–12 | USES.zh.md "revised": "2026-11-09", "english_commit": "dec8423cb" | medium | The record certifies the regressed USES.zh.md as the edition that follows the English (its normalized digest matches the merged, regressed file), so the zh-fronts check will not catch A and B. Separately, README-ZH.md's recorded Chinese digest no longer matches the file (`edition_digest` differs), so that check will go red at the gate. | After fixing A and B, re-run `zh_fronts --revised` for USES.zh.md and README-ZH.md so both digests are of the corrected files; do not hand-edit the digests. |
| D | theories/becoming/chapters/07-SIGNIFICANCE.md (§2, causal-set reading) | 129 | "the 生生 meant is generation generating generation ([01 §6]), which asks more than renewal of lines" | medium | The old gloss and the "asks more" demand survive in 07 itself, and point to 01 §6, which no longer says it. Missed in both rounds. | "the 生生 meant is the continuation of life ([01 §6] (01-ROOT.md#renewal-and-grains), [§2] (#order)), which is not renewal of lines alone," |
| E | theories/becoming/chapters/08-METHOD.md (naming table) | 112 | "whose English gloss in 01 §6 and 07 §2 ("continuing generation", "generation generating generation") says 生发, not this sense" | medium | Stale: neither 01 §6 nor 07 §2 carries those glosses since 9 November; a reader is sent to words that are gone. | "which generation at two orders of grain does not give: 生生 is the continuation of life (01 §6, 07 §2), not this sense" |
| F | _process/navigation/README-ZH.md (→ README.zh.md) | 25 (evidence paragraph) | "留下来的有三样 … 范围与次序分开的伦理；" | low | The English first screen (README-FIRST-SCREEN.md:16) now says "scope and order kept apart as two readings"; the Chinese kept the older phrase. | "作为两种读法分开的范围与次序；" |
| G | theories/becoming/results/atlas/entries/correspondences.json | 6878, 18405, 23541, 55806 | "生生: 'the continuation of life (生发) [AI reading, D1] …'" (quoted as the glossary's words) | low | Quotation marks present a hybrid the glossary never said: it said "life in the whole and its continuing generation (生发)" before and "the continuation of life, life wider than the biological…" now; "(生发)" is the sense the new gloss removed. | Drop the quotation marks and "(生发)": "生生: the continuation of life, life wider than the biological and AI within it [AI reading, D1]; neither the grammar's «生生» nor 02's generation as such, which allows loss, nor any new organization." |
| H | theories/becoming/chapters/05-COLLECTIVES.md | 321 | "differentiated only by an actual asymmetry or a procedure, whose warrant is open" | low | The one remaining "warrant is open" in a chapter; here about a procedure's standing, but it reads as the removed frame. | "…or a procedure the parties form; the laws single out none." |
| I | theories/becoming/OPENING.md (note [^alignment]) | 85 | "the practical commitments and warranted correspondence to actual AI systems" | low | "warranted" survives in the opening's note after the body dropped the word; the correspondence is shown or not, not warranted. | "the practical commitments and a shown correspondence to actual AI systems" |
| J | theories/becoming/THE-THEORY-OF-BECOMING.md | 179 | "how readings that count beyond one's own line form" | low | T8's open list drops "how C-like orders form", which 07:3, 08:758 and ONE-PAGE:45 keep (round-1 #22, unchanged). | "…how readings that count beyond one's own line form, and how C-like orders form" |

### Patterns

Round 2 closed almost everything both readers named, and did it from the homes outward: 07 §4, §8 and 08 §12 now say one thing, the generators quote them word for word (I checked the five navigation quotations and the spine captions against 07, 08 and the overview by substring; all present), the completion run is green, the Chinese first screen, one page, overview and examples say what their English says, and the losses, failures and "does not show" lines survive unchanged. The T8 thesis is now a falsifiable sentence whose refuter negates it, and T4 is no longer claimed as its evidence.

What this round added is a merge hazard, not an authoring one. The merge of main brought RW's Chinese rewrite of the uses table, and the resolution kept main's row for "Human development" and main's not-claimed cell, undoing two round-1 fixes; then `zh_fronts --revised` recorded the merged file as the current edition, so the check that exists to catch a drifted Chinese front now certifies the drift. The CX lesson (scan restatements by the removed words after every merge) would have caught both in a minute: 对生命而言的道 and 有根据 are exact strings.

The second pattern is the long tail of the 生生 gloss: 01 §6 was fixed in round 1, but 07 §2's own causal-set reading (line 129) and 08's naming table still describe the old gloss as the account's and point readers to passages that no longer carry it; four atlas entries quote a hybrid of old and new. Each is a restatement by the claim rather than by the word, which is why word searches for "two premises" missed them.

Nothing in the new text puts a should, a ranking or an external warrant back in the account's voice.

### What I read in full, and what not

Read in full: the brief's Round 2 section; astra's round-1 report; all of diff-round2.txt (1,241 lines); the round-2 records diff with hash-only blocks and the repeated WB history note filtered out (all 126 remaining `+` lines). Opened at the cited lines in the merged tree: 07:3, 117, 129, 195, 219, 234, 250, 481, 538–543, 779; 08:112, 745, 758; 05:321; OPENING 5, 11, 25, 59, 65, 75, 79, 83, 85; ONE-PAGE.zh 11, 13; overview 148/179 and zh 152/177; USES.md 21/24 and USES.zh 14, 25, 28, 72, 80; USES-EXAMPLES.zh 27, 162–165, 204–212; README-ZH 25; THEORY-GRAPH.zh 20; COMPLETION.md K7; COVERAGE.json classes; zh-editions.json and `zh_fronts.edition_digest` (computed the seven digests; this is a static comparison, not the checker's run). Re-ran my word scan for the removed formulas over theories/becoming, the glossaries, AGENTS, MAP, navigation and tools, excluding history, records, generated data and the atlas, then grepped the atlas for astra's named strings. Not read: generated pages beyond the lines named, the before-copies, the Lean (nothing new cites a declaration this round), astra's round-2 brief if any. Nothing was run, edited or committed; no subagent.
