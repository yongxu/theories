## WB round 3, reader Fable (00b2fbec2 → 47b9b069d)

### Round-2 findings: fixed as meant, or how the fix differs

| # (round 2) | status |
|---|---|
| A USES.zh:28 heading | Fixed: "人的发展，以及生生，即生命之延续", matching USES.md:24. |
| B USES.zh:25 not-claimed cell | Fixed: "有人必须持有延续条件或 C", matching USES.md:21. |
| C zh-editions.json | Not re-recorded after the round-3 edits: the record now lags three pages (see finding 1 below). |
| D 07:129 | Fixed as proposed ("the continuation of life …, which is not renewal of lines alone"). |
| E 08:112 | Fixed as proposed. |
| F README-ZH evidence paragraph | Fixed ("作为两种读法分开的范围与次序"). |
| G atlas "(生发)" quotations | Fixed in all four entries; none remain. |
| H 05:321 | Fixed as proposed, and carried into the six atlas entries that quoted it. |
| I OPENING:85 | Fixed ("a correspondence to actual AI systems, where one is shown"). |
| J overview T8 open list | Left on purpose; I accept the reason (it copies 07's T8, which does not list C-like orders). |

Astra's round-2 fixes do not conflict with mine. Where we touched the same sentences the applied text is astra's narrower "most use two readings / the self-concern results use the narrower order they state" (07:3, 08:448, the first screens, ONE-PAGE:32, OPENING:75, navigation.py:528); my round-1 and round-2 "two readings" summaries were the universal form astra objected to, and the applied form is the more exact one. The T4 explanation in 07:779 now follows astra's correction of the fact; I had accepted the earlier "the bed gives the fishers nothing" reasoning, which astra showed was wrong (keeping the bed does forgo catch), and the new sentence is right against IN1's README (the optimum of 50 t is the community's steady catch and ends the bed).

### Findings, high first

| # | file | line | quoted (≤25 words) | sev. | what is wrong | exact replacement |
|---|---|---|---|---|---|---|
| 1 | _process/navigation/zh-editions.json (with README-ZH.md, ONE-PAGE.zh.md, USES.zh.md) | 7–39 | "revised": "2026-11-09", "english": …, "chinese": … | medium | The round-3 edits came after `--revised` was last run. The recorded English digests of README-FIRST-SCREEN.md and ONE-PAGE.md no longer match (I computed `english_digest` for all seven), so the render will banner README.zh and ONE-PAGE.zh as lagging editions although their Chinese was revised in step; and the Chinese digests of README-ZH, ONE-PAGE.zh and USES.zh no longer match the files. A check that runs will mis-describe the state. | Re-run `zh_fronts --revised` for README-ZH.md, ONE-PAGE.zh.md and USES.zh.md so the record is of the current pair; then render. |
| 2 | theories/becoming/results/THEORY-GRAPH.md 61; results/completion/COMPLETION.md 112; theories/LINEAGE.md and LINEAGE.zh.md (overview sentence) | as listed | "a ranking is under two named readings, the continuation condition for scope and C for order" (THEORY-GRAPH, COMPLETION) | medium | Generated pages were not re-rendered after their sources changed in round 3: 08:435 and COVERAGE.json:1092 now say "that the wider is better is C's reading, with the continuation condition for scope", and lineage.json:111/164 gained the "after the cut, on 9 November" sentence, but the three pages still carry round-2 text. `--strict-fresh` will redden, and a reader of the graph table sees the universal "two named readings" the round removed. | Run the render; the pages take their sources' current sentences. |
| 3 | theories/becoming/results/atlas/entries/correspondences.json | 7175, 7973, 9812, 11191, 12994, 21897 (and 23184, 30372, 31251, 31911, 46980, 74274, 76455) | "a ranking, which needs the continuation condition for scope and C for order" / "whose losses count needs the continuation condition" | medium | The same sentence astra's round-2 row 2 named (and the kit fixed in five entries) survives in thirteen more: it makes the condition necessary for any loss to count and C necessary for any ranking, which 07 §4, COLLECTIVE-DIRECTION:76 and 07:481 now deny (narrower scopes count particular losses; self-concern results use a narrower order). Incomplete propagation of a correction already accepted. | In each: "a ranking rests on C or another named order; the continuation condition counts every unreturned loss, while narrower scopes can count particular ones without satisfying it" (and for the "whose losses count needs" form: "whose losses count is the continuation condition's reading, narrower scopes counting particular ones"). |
| 4 | theories/becoming/chapters/07-SIGNIFICANCE.md | 117 | "something new found after each step after which not everything held was held before" | low | Says the right thing (a new point exhibited whenever the next holding is not included in the previous one) in a sentence a reader has to parse twice. | "(each point refuted or unrefuted at each moment, and a new point exhibited at every step whose holding is not included in the one before)" |
| 5 | theories/becoming/ONE-PAGE.md 32; ONE-PAGE.zh.md 38 | 32 / 38 | "it names its readings, mostly two, neither asserted, each a hypothesis wherever used" / "多为两种，二者都不被断言" | low | "neither" and 二者 presuppose exactly two after "mostly two". | "it names its readings, mostly two, none asserted, each a hypothesis wherever used" / "多为两种，皆不被断言" |

### Patterns

The round did what it was asked: every round-2 finding of both readers is fixed in its home and the fix carried to the dossiers and the quoted crosswalk fields, the sentence-level diff reads clean against the seven questions, the generator quotations still match their homes word for word (checked by substring for the five navigation keys and the spine captions), K7 is met, and nothing in the new text puts a should, a ranking or an outside warrant back in the account's voice. The T8 paragraph is now, as far as I can read it, exactly as strong as what it rests on: an offer, a thesis that could fail, a refuter that negates it, and an honest account of why IN1 does not test it.

What remains is all in the layer around the text, and it recurs for the third time: the edit lands in the source and the derived state is left as it was. Round 1 had COMPLETION.md committed red and THEORY-GRAPH.zh stale; round 2 had the merge undoing two fixes and `--revised` certifying the undone file; round 3 has the render not re-run (three generated pages, two lineage editions) and the zh-editions record describing a state before the last edits, so the one check built to say "this Chinese page follows this English" would say the wrong thing in two directions at once. None of this is a reader-facing error of the kind the review was for, but each would redden the gate or mislabel a page, so I keep them at medium rather than low. The atlas residue is the same lesson in data: a correction accepted for five entries and applied by the entries named rather than by the sentence.

By the brief's rule the review does not end this round, but only on these three mechanical items; a fourth round would have nothing of substance to read unless the render or the re-record changes prose.

### What I read in full, and what not

Read in full: the brief's Round 3 section; astra's round-2 report; all of diff-round3.txt (215 lines) and all non-hash lines of diff-round3-records.txt. Opened in the tree: 07:3, 53, 117, 129, 219, 540, 779, 793; 08:112, 435, 448, 600; AGENTS:28; OPENING 75, 85; ONE-PAGE 32 and zh 38; USES.zh 25, 28; 05:321; IN1's README line 5; zh_fronts.py's digest and check functions (and computed the English and Chinese digests of all seven editions, a static comparison, not the checker's run); THEORY-GRAPH.md:61, COMPLETION.md:15/94/112, LINEAGE.md and .zh for the round-3 sentence. Re-ran my word scan for the removed formulas over the live prose (clean) and over the atlas (the thirteen entries above). Not read: the kits, generated pages beyond the lines named, the Lean (no new declaration is cited this round). Nothing was run, edited or committed; no subagent.
