# WB review: findings that are not WB's to change

9 November 2026. The readers' inventories found these. Under the coordinator's settlement they belong to other owners, so WB has not changed them. Ids are [astra's](readers/inventory-astra-part1.md) ([part 2](readers/inventory-astra-part2.md)) and [Fable's](readers/inventory-fable.md).

## For RW (the case, the tests, the plain lead, the navigation, the uses table's structure)

- **A80** (fixed by RW's Chinese round, landed 9 November 2026, `0ec7f836b`): the overview's T2 row (EN 173, ZH 177) and USES-EXAMPLES.zh (199, 203, 207) say MQ5 passed. MQ5 is mixed: it passed its state and lag verdicts and failed both verdicts on the draw's response. The English USES-EXAMPLES already says so.
- **A81** (fixed by the same landing): ONE-PAGE.zh 13 and USES-EXAMPLES.zh 27 give the told cell as "被告知贻贝床与范围". That leaves out the rule for choosing among courses, which the English names.
- **A83**: 08's T3 row (595), ALIGNMENT (33, 567) and TESTS (64, 111) read LA1's failure as feedback that barely resolved the threshold. LA1b also assigned the best threshold, so its pass cannot isolate resolution as the cause.
- **A84**: ALIGNMENT's ten-minute lock item (12) says an unread loss "then grows past every bound". It grows past every bound only where it rises by at least one each step.
- **A88**: USES' "Six conditions for enough of the situation" presents six diagnostics from different models as a package of necessary conditions. They are six questions these models raise. astra's second round (A2-M6) found the same in COLLECTIVE-DIRECTION (lines 92, 101), USES (53) and USES.zh (58); its proposed wording: "Six considerations for a specified monitoring and response strategy [AI reading, D45], drawn from models with different hypotheses", and "Observation alone does not guarantee a response; these considerations have not been shown jointly necessary or sufficient, and they supply no ranking."
- **A82**: the glossary's "lock" says a configuration in which the course stays. A locked course can change share while the unread loss grows; what stays is the rule's favouring.
- **A4**: T1's "many renewal cycles" (02:278) has no quantified horizon.
- **The lineage's cut** (RW (c)): the cut is 8 November 2026. WB added one sentence after the cut to the ethics thread's introduction, saying that on 9 November the account set the warrant aside and T8 became its makers' offer. When the cut moves, that turn wants a point of its own, with its evidence (Ren's words in `sources/15-codex-theory-conversations/2026-11-08-within-becoming-no-should.md`, T8 in 07 §8).
- **The reading registers** (`theories/becoming/results/data/arguments-*.json`): every chapter's entry was stale on main, its source hash older than the chapter. WB reread chapter 7's entry and pinned it to the current chapter; the other chapters' entries wait for their own reread.
- **The one page's Chinese lead** (fixed by the same landing; ONE-PAGE.zh 9): "其余一切只经过 AI 的复审，迄今无人审查" says no one has reviewed it. The English says the person who directs the work has read its important parts and no independent human review is recorded yet; the Chinese should say the same.

<a id="for-ren"></a>
## For Ren (goal wording, prepared and listed under decisions pending him)

These goals restate the ethics in the frame WB revises. Each is listed here with a proposed wording; it changes only on his word.

- **Generative alignment** (GOALS:104; Fable F82, F85; astra A90). Joint alignment is defined by "courses are compared by widening". Proposed: aligned where what the rule reads, and what comes back to its shapers, keeps every continuation in view, and where ranking courses is done under readings each comparison names.
- **The ethics for life, and every intelligence formed within it** (GOALS:312, 322; F89; A91). It states "a stronger, universal warrant" as an open question and "the stance starts from what acting presupposes". Proposed: drop the warrant clause; describe how scopes and orders form, and offer the way of seeing of 07 §8.
- **Practical judgment for life, on the fewest premises** (GOALS:362; F90; A91). It says "C needs its own reason". Proposed: how C-like orders form, and which choices follow from which named readings.
- **Wisdom root** (GOALS:348; F17; A92). It says "Morality is appraised through this theory's universal principles, because morality appraises becoming and the model can appraise becoming". Proposed: how moralities form as appraisals of becoming, and what the model can say of them.
- **Continuing normative grounding direction** (GOALS:214; F87) and **Theory of Becoming premises** (GOALS:248; F88; A89). The wording in which significance is carried, and comparison defined as a law, to be re-said in the same way.
- **Stale progress** (A93, A94, A95): GOALS:294, 116 and OPEN-QUESTIONS:33. The progress pictures predate the 5 November holds and XL1. These are the goals' owners' to refresh.

## For the coordinator

- **The edition line.** Edition 5 states the two-premise picture and T8 as binding. WB's reason is now on the board's line "Which edition to send".
- **AGENTS.md's landing protocol** (astra's read of the draft). "While it stands" should mean "while it holds the head", and the re-read should come immediately before the fast-forward, after the checks. This is the coordinator's text; WB did not change it.

## For the crosswalk's owner

The crosswalk's entries (`theories/becoming/results/atlas/entries/correspondences.json`) restate the homes. WB re-said the parts that restate a changed sentence directly:

- the formula ("a ranking needs C or a premise in its place", "warrant open");
- 39 targets' T8 restatements, set to T8's new statement;
- the scope-and-order target;
- the selection, capability and revision sentences;
- the readings that cited T8's former refuter, now dated.

These ran through WB's kit scripts `crosswalk_formula.py` and `crosswalk_struct.py`, plus a last pass of exact replacements.

After the readers' first round, `kit/crosswalk_round1.py` and `kit/crosswalk_round1b.py` re-said the entries' own readings that still said the old frame (the ethics as "two premises" with "their warrant open", 生生 as "life in the whole", T8 as argued or as the way for life, T8's former refuter). They also fixed what WB's earlier passes had broken: "a ranking holds C or another order", where an act or a ranking was made to hold an order, now "rests on C or another named order"; "any a ranking"; a garbled warrant clause; quotations whose homes no longer say them, re-quoted from the homes or unquoted. `kit/wb_drift.py`, the crosswalk's `main_drift.py` with the base set to main and the head to this branch, still finds about 380 fields; the render counts 100 entries whose readings drifted. Most are windows of phrases that remain true: "the continuation condition for scope and C for order", "fixes whose losses count". What remains to read are the entries whose readings compare a source with the old T8 or with the "ranking needs C" frame. A crosswalk re-read should take them in its next round, from the drift list `wb_drift.py` writes. The Chinese `says` of the rewritten T8 targets were dropped, not translated, so the Chinese crosswalk shows the English there until it is re-read.
