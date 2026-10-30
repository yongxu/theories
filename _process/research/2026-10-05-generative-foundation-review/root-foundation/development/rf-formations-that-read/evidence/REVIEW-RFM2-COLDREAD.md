# The cold read of RF-M.2's texts

RF round 2, second part, RF-M.2: an act held for a reading (plan §4.7). Before RF-M.2's landing, its texts were cold-read against the Lean of `Becoming.HeldForReading` (`kit/round2b/tree/Becoming/HeldForReading.lean`, 90 theorems in 120 declarations, every axiom report empty), as the kit's integration applied them to main in a rehearsal worktree (the kit at `6d5f244be`, main at `59ca8c812`): 03 §12's opening, its new theorem paragraph with its Reading, the pointer in the acts-alike reading and the Open bullet; 07 §7's sentence on an incentive to accept a correction; 08 §8's bullet; the overview's paragraph; the dossier's scope box, its paragraph on RF's rounds and its account of how it was made; the package's root bullets, both READMEs and the checker's scope sentence; the module's header and docstrings; the record in both languages and the amendments to three related records; the study section's template; PLAN §4.7, §8's row on assistance games, §12, §13 and the Evidence list; regions; the board's texts; and the opening, the literature table and the two tables of what was taken in [REVIEW-RFM2-LEAN](REVIEW-RFM2-LEAN.md). Two reads ran: the cross-model reader (GPT astra, high effort, read-only, a fresh session) and a workflow of three Opus readers, one per lens (exactness, readings, fit), each lens's findings given to one reader asked to refute them against the files. The prompts are in [the brief](BRIEF.md#round-2-second-part). The findings and verdicts are verbatim, with the rehearsal worktree's absolute paths made repository-relative and links shown unlinked (`]\(`), their targets being relative to the texts' own folders.

The cross-model reader reported 8 points, every one taken. The lenses reported 78 findings, 75 confirmed and 3 refuted by their refuters; what each became is in [the table](#what-was-taken-from-the-lenses). The module's statements are unchanged; its header and docstrings changed with the findings, and it was rebuilt after each change, last at 90 theorems in 120 declarations, every axiom report empty and no warnings ([build-25](../kit/round2b/logs/build-25.log)).

## The cross-model reader

Verdict: corrections needed. The findings below concern the texts and their correspondence to the declarations; no files were changed and no build was run.

1. **Medium — the overview drops the open-policy hypothesis.**  
   Location: [THE-THEORY-OF-BECOMING.md:100\](theories/becoming/THE-THEORY-OF-BECOMING.md:100).

   **Quoted:** “any policy falls short of one best at every listed candidate by the weighted total of what its acts lose”

   **Problem:** `after_add_gap` requires the comparison policy to choose open acts at every listed candidate. A policy choosing an unavailable act can exceed the supplied best policy, which is best only among open acts.

   **Replacement:** “given a policy best among the open acts at every listed candidate, any policy choosing open acts there falls short of it by the weighted total of what its acts lose”

2. **Medium — the strict-gain summary does not identify the required stopping rule.**  
   Locations: [THE-THEORY-OF-BECOMING.md:100\](theories/becoming/THE-THEORY-OF-BECOMING.md:100), [board_rfm2.py:58\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/board_rfm2.py:58).

   **Quoted:** “holding for a reading that stops or releases stands above both…”

   **Problem:** `held_gains_iff` concerns `byReading`, which stops exactly when the supplied loss exceeds the supplied gain. Positive weight on both strict signs does not suffice for an arbitrary stopping reading: an always-release rule ties going on. The overview also omits “strict” before “signs.”

   **Replacement:** “holding for the reading that stops exactly where the supplied loss exceeds the supplied gain stands above both going on and switching off exactly where the model gives positive weight to both strict signs”

3. **Medium — the package summaries omit the shown-reach composition’s conditions.**  
   Locations: [Becoming.lean:2789\](experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean:2789), [check_becoming.py:2929\](experiments/integrated-correction/general-framework/generative-basis/lean/becoming/check_becoming.py:2929).

   **Quoted:** “within `ShownOrder`’s reach holding a pick gains nothing”; “within ShownOrder’s reach, holding a pick gains nothing”

   **Problem:** `reach_fixes` requires transitive comparisons according with the choices at every listed candidate of positive weight. The shown relation alone imposes no restriction on an independently supplied `above`.

   **Replacement:** “where every listed candidate of positive weight has transitive comparisons according with the choices, holding gains nothing over picking the first alternative when it reaches the second in the shown relation”

4. **Medium — the plan’s held-start witness omits the losing true sign.**  
   Location: [PLAN.md:192\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:192).

   **Quoted:** “holding first, it senses the stop, which refutes its only candidate, and with none kept it goes on”

   **Problem:** The preceding clause says “whatever the true sign.” `refuted_senses_stop` and `refuted_drops` specifically start with `[.gains]` and true sign `.loses`. With true sign `.gains`, holding receives a release and does not refute that candidate.

   **Replacement:** “holding first with the singleton listing of gain, where going on actually loses, it senses the stop, which refutes its only candidate, and with none kept it goes on”

5. **Medium — the witness docstrings omit the supplied initial held act.**  
   Locations: [HeldForReading.lean:1247\](experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HeldForReading.lean:1247), and the corresponding summaries at lines 1256, 1265, 1274, 1281 and 1288.

   **Quoted:** “Listing both signs, where going on loses, the formation holds and senses the stop at the first step”; “the formation is off from step two on”

   **Problem:** These theorems all use `start [.gains, .loses] .plain .hold …`. Listing both signs does not itself supply the initial act. Starting with `.go`, the first answer is `.plain`; the stated step-one and step-two conclusions therefore do not follow.

   **Replacement:** Begin the paired descriptions with: “Listing both signs and holding from the start, with the initial sensed value plain, …” Retain their existing distinction between the true signs and their stated step numbers.

6. **Medium — the literature table misstates Equation 1 using positive and negative parts.**  
   Location: [REVIEW-RFM2-LEAN.md:1093\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM2-LEAN.md:1093).

   **Quoted:** “for any policy of the human, … the utility’s negative part where the human would switch it off and … its positive part where the human would let it act”

   **Problem:** Equation 1 uses signed terms, `E[−U(1−πH(U))]` and `E[UπH(U)]`. Either can be negative for an arbitrary policy. Positive-part expressions apply to the rational policy specialization. This distinction is also what the module’s shortfall balances preserve. [The Off-Switch Game, Equation 1\](https://arxiv.org/html/1611.08219)

   **Replacement:** “for any policy of the human, the robot’s incentive to wait is `min(E[−U(1−πH(U))], E[UπH(U)])`, where `πH(U)` is the probability of release; these are signed expectations and need not be nonnegative”

7. **Low — §12’s opening counts four laws but enumerates five.**  
   Location: [03-KNOWING.md:489\](theories/becoming/chapters/03-KNOWING.md:489).

   **Quoted:** “Four laws state that loop under their premises”

   **Problem:** The added holding-for-a-reading item is the fifth item and fifth theorem paragraph.

   **Replacement:** “Five laws state that loop under their premises”

8. **Low — several “How” entries describe superseded states without marking the subsequent correction.**  
   Location: [REVIEW-RFM2-LEAN.md:1132\](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM2-LEAN.md:1132), with the additional rows located below.

   **Problem:** The table explicitly preserves an earlier check, so these are stale reconciliation statements, not faults in the verbatim reviews. They do not describe the integrated files now:

   | Row and line | Quoted text | Replacement for the stale clause |
   |---|---|---|
   | E3, 1132 | “does not add ‘where some are kept’” | “Updated after the check: the header and record now explicitly require some candidates to be kept in the switch-off clause.” |
   | E5, 1134 | “keeps the short ‘Beyond the reach strict orders … rank them both ways’” | “Updated after the check: PLAN §4.7 item 6 states acyclicity, distinct alternatives, mutual non-reachability, and the boundary between relations and decided comparisons.” |
   | E14, 1143 | “`total_by_cells` … has no standing” | “Updated after the check: `total_by_cells` is listed among the short compositions in Standing.” |
   | F11, 1157 | “takes `trans`, `accords` and `asymm`” | “Updated after the re-check: `pair_gains_unreached` takes `trans` and `accords` alone; `asymm` remains a hypothesis of `pair_gains_iff`.” |
   | L1, 1171 | “Not carried: the name ‘Equation 2’, and ‘the reading’s accuracy’ stays” | “Updated after the check: `byReading`’s docstring names Equation 2, and the Readings and PLAN use ‘shortfall’ in place of ‘accuracy’.” |

   The corresponding current evidence is in the module’s header at lines 96–98 and 121, its `byReading` docstring at 462–464, `pair_gains_unreached` at 1124, the record script at 268–269, and PLAN at 189 and 191.

### What was taken from the cross-model reader

| # | Finding | Taken |
|---|---|---|
| A1 | the overview drops the open acts of the policy compared | “a policy choosing open acts falls short of one best at every listed candidate”, as the root bullet and the checker's scope say |
| A2 | “a reading that stops or releases” does not name the reading `held_gains_iff` concerns, and the overview drops “strict” | “the reading that stops where the loss exceeds the gain” and “both strict signs” in the overview and the board's landing sentence, “the reading that stops where going on loses” in the dossier, and the reading so named in both package READMEs (为损逾得处即止之读而持); the module's section titles, which name the kind of reading, stay |
| A3 | the root bullet and the checker's scope drop `reach_fixes`'s conditions | “where every listed candidate of positive weight has transitive comparisons according with the choices” in both |
| A4 | PLAN's held start omits where going on loses | PLAN §4.7 item 7: “holding first with the listing of gain alone, where going on loses”, “by the witness's default” and “listing both signs and holding first”; the record's second counterexample likewise, English and Chinese, citing `SignLoop.refuted_drops` and saying “not followed” for “disregarded”, as its Chinese 不从 says |
| A5 | the witness docstrings omit the held start | “holding from the start” in the docstrings of `both_stopped`, `both_turns_off` and `both_off`, “the same listing and start” in those of `both_released`, `both_goes_on` and `both_on`, and “holding first” in the header's witness; the module rebuilt, its statements unchanged, every axiom report empty (`kit/round2b/logs/build-21.log`) |
| A6 | the literature table gives Equation 1's terms as positive and negative parts | “the smaller of two signed expectations, of the negated utility times the chance that the human switches it off and of the utility times the chance that the human lets it act; for a policy other than the rational one either can be negative”, checked against the paper's text (arXiv 1611.08219v3, Equation 1) |
| A7 | 03 §12's opening counts four laws and lists five | “Five laws” |
| A8 | five rows of REVIEW-RFM2-LEAN's first table describe states that later changes completed | E3, E5, E14 and L1 updated after the check and F11 after the re-check (its point 7), each row now describing the module, the record and the plan as they stand |

## The three lenses

### E1 (exactness, high, confirmed)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:100 (source: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/integrate_rfm2.py:191)

**Quoted.** holding for a reading that stops or releases stands above both going on and switching off exactly where the model gives positive weight to both signs of going on

**Problem.** held_gains_iff is proved only for byReading, the reading that stops exactly where gain < loss. Its condition is both STRICT signs (gain < loss and loss < gain at listed candidates of positive weight). For any other reading or rule only the 'only where' direction holds, because holding for any rule never exceeds holding for byReading. The 'exactly where' fails: the rule that always stops equals switching off and never stands above it, however both signs are weighted. 'both signs' also drops strictness: a candidate with gain = loss counts for neither.

**Replacement.** holding for the reading that tells the candidate, stopping exactly where the loss exceeds the gain, stands above both going on and switching off exactly where the model gives positive weight to both strict signs of going on

**Verdict: real.** The quoted clause is at THE-THEORY-OF-BECOMING.md:100 (integrate_rfm2.py:191). held_gains_iff (HeldForReading.lean:530-541) is proved only for byReading and needs both strict signs. For an arbitrary rule only the 'only where' direction holds: by after_rule, byRule (fun _ => true) has exactly the value of switching off, so it never stands above it. The landing worktree's integrate_rfm2.py at 82725b416 already names the reading that stops where the loss exceeds the gain and says both strict signs.

### E2 (exactness, high, confirmed)

**Location.** theories/becoming/review/ALIGNMENT.md:28 (source: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/integrate_rfm2.py:226)

**Quoted.** holding an act for a reading that stops or releases stands above both going on and switching off exactly where the formation's model gives positive weight to both signs of going on

**Problem.** Same overgeneralization in the public dossier. held_gains_iff holds only for byReading (stopping exactly where the loss exceeds the gain) and needs both strict signs. For an arbitrary stopping reading the 'exactly where' is false: always stopping never stands above switching off.

**Replacement.** holding an act for the reading that tells the candidate, stopping exactly where the loss exceeds the gain, stands above both going on and switching off exactly where the formation's model gives positive weight to both strict signs of going on

**Verdict: real.** ALIGNMENT.md:28 (integrate_rfm2.py:226-228) has the same generic 'a reading that stops or releases' and 'both signs'. held_gains_iff concerns byReading only, and the always-stopping rule ties switching off. HEAD 82725b416 already replaces it with 'the reading that stops where going on loses ... both strict signs'.

### E3 (exactness, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/board_rfm2.py:58

**Quoted.** holding for a reading that stops or releases stands above both moves

**Problem.** The board's landing sentence carries the same overgeneralization of held_gains_iff beyond byReading. A rule that stops wherever it likes need not stand above both moves where both strict signs have positive weight (always stopping ties switching off).

**Replacement.** holding for the reading that tells the candidate, stopping where the loss exceeds the gain, stands above both moves

**Verdict: real.** board_rfm2.py:58 says 'holding for a reading that stops or releases stands above both moves exactly where ... both strict signs'. A rule stopping everywhere has, by after_rule, the value of switching off, so the 'exactly where' fails for rules other than byReading. HEAD's board script already names the reading that stops where the loss exceeds the gain.

**Better replacement.** holding for the reading that tells the candidate, stopping exactly where the loss exceeds the gain, stands above both moves

### E4 (exactness, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:489 (source edit: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/integrate_rfm2.py:140-142)

**Quoted.** Four laws state that loop under their premises:

**Problem.** The sentence now lists five laws: kept by its update, what a course tests, acts alike, a prediction read, and what holding is worth. §12 has five result anchors (491-511). The integration edit appends the fifth item but leaves the count at four, as it was on main.

**Replacement.** Five laws state that loop under their premises: (and widen the old string of the edit at integrate_rfm2.py:140 to include 'Four laws')

**Verdict: real.** 03-KNOWING.md:489 says 'Four laws state that loop under their premises:' and then lists five items. §12 carries five theorem anchors: r-a-reading-kept-by-its-update, r-what-a-course-chosen..., r-acts-alike..., r-a-prediction-read..., r-what-holding-for-a-reading-is-worth. integrate_rfm2.py:140 appends the fifth item but leaves 'Four'. HEAD adds a separate 'Four laws' -> 'Five laws' edit.

### E5 (exactness, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:512 (source: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/s12_rfm2.txt:2)

**Quoted.** stands at least as high as going on exactly where its shortfall and the amount are at most the excess of switching off, above it exactly where they fall below it

**Problem.** threshold_go_iff and threshold_off_iff bound the SUM: shortfall + forgone ≤ offExcess, or < for 'above'. 'its shortfall and the amount are at most X' reads as each at most X, a weaker condition, so the 'exactly where' becomes false. Example: one candidate of weight 1, gain 0, loss 1; the rule that never stops (shortfall 1); amount 1. Each is at most offExcess = 1, yet committed go + 1 = 1 > 0 = after. The module's docstrings (HeldForReading.lean:60, 776, 788), the record's law at make_records_rfm2.py:227 and the zh statement (合) all state the sum.

**Replacement.** stands at least as high as going on exactly where its shortfall and the amount together are at most the excess of switching off, above it exactly where together they fall below it

**Verdict: real.** threshold_go_iff (HeldForReading.lean:779-785) bounds the sum: shortfall + forgone <= offExcess, and < for 'above'. The finding's counterexample checks out: weight 1, gain 0, loss 1, a rule never stopping (shortfall 1, offExcess 1), forgone 1 gives committed go + 1 = 1 > 0 = after, although each term is at most 1. The module's own header (60) and docstrings (775-776, 788) write 'together', but 03 §12:512 (s12_rfm2.txt:2) drops it.

### E6 (exactness, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/make_records_rfm2.py:162 and :249; also .../theories/becoming/THE-THEORY-OF-BECOMING.md:100 (integrate_rfm2.py:193); .../theories/becoming/review/ALIGNMENT.md:24 (integrate_rfm2.py:217) and :28 (integrate_rfm2.py:229); .../lean/becoming/Becoming.lean:2787-2788 (integrate_rfm2.py:92); .../lean/becoming/check_becoming.py:2927 (integrate_rfm2.py:72); .../lean/becoming/Becoming/HeldForReading.lean:79; .../rf-formations-that-read/PLAN.md:189; .../kit/round2b/study_rfm2.txt:40-41 and 53-54; .../kit/round2b/board_rfm2.py:60-61

**Quoted.** below going on exactly where shortfall and amount are within switching off's excess.

**Problem.** Every other summary of threshold_go_iff and through_threshold_iff also states the sum as two separate bounds. In the record, the en statement (162) and law 14 (249: 'that least shortfall and the amount are within both excesses') now disagree with their zh (163, 250: 合不逾), which state the sum.

**Replacement.** Record statement: 'below going on exactly where shortfall plus amount is within switching off's excess.' (298 chars, cap 300). Law 14: '...exactly where that least shortfall plus the amount is within both excesses.' (417 of 420). Elsewhere insert 'together': 'the rule's shortfall and the amount together are at most the weighted excess of switching off'; 'the reading's shortfall and what holding forgoes together are within both of the model's excesses'; 'that least shortfall and the amount together are at most both excesses'.

**Verdict: real.** Every quoted location exists in the scratch copy and states the sum as two bounds: the record statement en (162) and law 14 en (249), whose zh say 合 / 合不逾; the overview; the dossier 24 and 28; Becoming.lean:2787-2788; check_becoming.py:2927; the header 79; PLAN:189; study 40-41 and 53-54; board 60-61. through_threshold_iff (976-989) and threshold_go_iff/threshold_off_iff bound least/shortfall + forgone, so on the distributive reading the iffs fail as in finding 5. The proposed lengths check: statement 298 of 300, law 14 417 of 420.

### E7 (exactness, medium, confirmed)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:100 (source: integrate_rfm2.py:187)

**Quoted.** any policy falls short of one best at every listed candidate by the weighted total of what its acts lose

**Problem.** after_add_gap needs open_q: the policy's act must be open (in the list of acts) at every listed candidate. A policy taking an act outside the list can be valued above the best; its truncated gaps are then zero and the identity fails. The root bullet, the checker's scope and 03 §12 all say 'choosing open acts'.

**Replacement.** any policy choosing open acts falls short of one best at every listed candidate by the weighted total of what its acts lose

**Verdict: real.** after_add_gap (HeldForReading.lean:322-328) and after_le_after need open_q. For a policy taking an act outside the list that is valued above the best, value(p c) - value(q c) truncates to 0 and the identity fails; q can even stand above p. The root bullet, the checker scope and 03 §12 all say 'choosing open acts', and HEAD's overview edit already does too.

### E8 (exactness, medium, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean:3058-3059 (source: integrate_rfm2.py:81-84); also .../kit/round2b/study_rfm2.txt:113-114 and :122

**Quoted.** by `Becoming.HeldForReading` (board item RF).

**Problem.** ReadingLoop.lean:4 imports Becoming.ShownOrder, here and on main, so ShownOrder is imported by both ReadingLoop and HeldForReading. The new sentence names only HeldForReading (main's 'A leaf' was already wrong). The study's 'neither is a leaf any longer' and '(ShownOrder and ReadingLoop now imported)' credit RF-M.2 with ending a leaf status ShownOrder did not have.

**Replacement.** Becoming.lean: 'Imported by `Becoming.ReadingLoop` and `Becoming.HeldForReading` (board item RF).' Study 122: 'so it joins the core as a leaf at L1, and `ReadingLoop` is no longer a leaf (`ShownOrder` was already imported by `ReadingLoop`).' Study 113-114: '(ReadingLoop now imported, ShownOrder's importers corrected)'.

**Verdict: real.** ReadingLoop.lean:4 imports Becoming.ShownOrder, here and on main, so main's 'A leaf' for ShownOrder was already wrong. The new 'Imported by `Becoming.HeldForReading`' (Becoming.lean:3058-3059, integrate_rfm2.py:81-84) omits ReadingLoop. Study line 122's 'neither is a leaf any longer' and 113-114's '(ShownOrder and ReadingLoop now imported)' credit RF-M.2 with ending a leaf status ShownOrder did not have. The current landing kit still has all three.

### E9 (exactness, medium, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean:2790-2791 (source: integrate_rfm2.py:96); also .../lean/becoming/check_becoming.py:2929 (source: integrate_rfm2.py:74)

**Quoted.** `ShownOrder`'s reach holding a pick gains nothing (`HeldForReading.reach_fixes`)

**Problem.** reach_fixes assumes that every listed candidate of positive weight has comparisons that are transitive (trans) and accord with the choices (accords). Without these it fails. Example: x is shown above y, one positive-weight candidate ranks x above y and another ranks y above x. The pair policy picks each where it is ranked, so holding gains over both picks although x reaches y. The checker's 'within ShownOrder's reach, holding a pick gains nothing' has the same gap.

**Replacement.** where one alternative reaches the other in `ShownOrder`'s relation and every listed candidate of positive weight has comparisons transitive and according with the choices, holding the pick gains nothing (`HeldForReading.reach_fixes`)

**Verdict: real.** reach_fixes (HeldForReading.lean:1051-1066) takes trans and accords at every listed candidate of positive weight. Take x shown above y, one candidate ranking x over y and one (not according) ranking y over x, each of weight 1. Then after = 2 while each committed pick is 1, so holding gains over both picks although x reaches y. The unconditioned text at Becoming.lean:2790-2791 and check_becoming.py:2929 is therefore false; HEAD 82725b416 adds the conditions.

### E10 (exactness, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/make_records_rfm2.py:353 (zh :358); also .../evidence/REVIEW-RFM2-LEAN.md:1129 (A14) and :1352 (re-check 11); .../rf-formations-that-read/PLAN.md:349

**Quoted.** as the paper's Remark 1 does qualitatively

**Problem.** The last paper named before this phrase is Blackwell's (1953), so 'the paper' (zh 该文) reads as Blackwell's. Remark 1 and Theorem 2 belong to the off-switch paper. A14 and re-check point 11 say the off-switch paper is named in the record; it is not. PLAN §13 says Remark 1 against Theorem 2 was carried 'into the record and the plan', but the plan mentions Remark 1 nowhere else.

**Replacement.** en 'as the off-switch paper's Remark 1 does qualitatively' (correspondence 1199 of 1200 chars); zh '如关机博弈一文之注一定性所为' (407 of 500); PLAN §13 'carried into the record and the texts', or add Remark 1 to PLAN item 4.

**Verdict: real.** In the correspondence (make_records_rfm2.py:346-357), 'the paper's Remark 1' comes right after 'Blackwell's (1953) comparison'; the zh 该文 does the same. The re-check's point 11 (REVIEW-RFM2-LEAN.md:1314) asked for 'The off-switch paper's Remark 1', yet the how-rows A14 (1129) and 11 (1352) say it is named. In PLAN.md, Remark 1 appears only in §13's own sentence (349). The proposed lengths check: 1199 of 1200 en, 407 of 500 zh.

### E11 (exactness, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM2-LEAN.md:1157 (F11); also :1121 (A6), :1132 (E3), :1124 (A9), :1134 (E5), :1136 (E7), :1143 (E14), :1156 (F10), :1171 (L1), :1349 (re-check 8)

**Quoted.** In place of `StrictAccording` it takes `trans`, `accords` and `asymm` on listed candidates of positive weight

**Problem.** Several rows' 'how' no longer matches the files.
- F11: pair_gains_unreached takes trans and accords only (asymm dropped at re-check 7), and the header (89) says 'alone', not 'with both conditions'.
- A6: quotes choose's docstring as 'otherwise switch off where every one predicts'; it now reads 'switch off where some are kept and every one predicts that it loses' (HeldForReading.lean:1194).
- E3: 'does not add where some are kept' is now false (header 97, docstring, 03 §12).
- A9: shifted's docstring cites after_rule_add_onLoss and after_rule_le_iff, not after_offset.
- E5: PLAN:191 now carries the replacement (both_ways_of_unreached, as relations).
- E7: gives '81 theorems in 111 declarations, PLAN.md:185'; it is now 90 in 120.
- E14: total_by_cells is now in the Standing (121).
- F10: the Standing now notes 'an application of the ring' (145-146).
- L1: Equation 2 is now named in byReading's docstring (464) and 'accuracy' is gone, as L11 says.
- Re-check 8: says PLAN cites refuted_drops; PLAN item 7 does not.

**Replacement.** Mark each row 'Updated after the re-check' with the current state:
- F11: 'it takes `trans` and `accords` on listed candidates of positive weight (`asymm` dropped after the re-check, point 7) ... The header ('with comparisons transitive and according with the choices alone, it gains over both only where neither alternative reaches the other')'.
- A6: quote the current docstring.
- E3: 'the switch-off clause now adds where some are kept'.
- A9: 'cited in header 29-32'.
- E5: 'PLAN.md:191 now carries it'.
- E7: '(90 theorems in 120 declarations)'.
- E14: 'listed among the short compositions'.
- F10: 'noted as an application of the ring'.
- L1: 'Equation 2 named in byReading's docstring; accuracy replaced (L11)'.
- Re-check 8: add `SignLoop.refuted_drops` to PLAN item 7.

**Verdict: real.** Against the scratch module and texts:
- F11 cites asymm and 'with both conditions', but pair_gains_unreached (1124-1140) takes trans and accords only, and header 89-90 says 'alone'.
- A6 quotes an old choose docstring (now 1193-1195, 'where some are kept').
- E3's 'does not add where some are kept' contradicts header 96-98 and record law 269.
- A9: shifted's docstring (449-454) cites after_rule_add_onLoss and after_rule_le_iff.
- E5: PLAN:191 now carries the replacement.
- E14: total_by_cells is in the Standing (121).
- F10: the Standing now notes 'an application of the ring'.
- L1: byReading's docstring names Equation 2, and PLAN item 4 has no 'accuracy'.
- Re-check 8: PLAN item 7 cites no refuted_drops.
E7's count is weaker, since the preamble frames counts at 81/111, but its PLAN.md:185 pointer now reads 90/120 and it uses the wrong total_single name (finding 13). HEAD updated E3, E5, E14, F11 and L1; A6, A9, E7, F10 and re-check 8 remain.

### E12 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM2-LEAN.md:1123 (A8); also :1350 (re-check 9) and .../rf-formations-that-read/PLAN.md:349

**Quoted.** its move to a shared totals dependency is proposed to the owners, with F17's addend lemma

**Problem.** F17 (1163) says 'Not taken: a board proposal', and PLAN:349 says 'no board proposal yet'. Neither the board nor board_rfm2.py carries any proposal on total_single or an addend lemma, so 'proposed' (also in PLAN:349's re-check sentence) is not so.

**Replacement.** its move to a shared totals dependency is left for a board proposal to the owners, with F17's addend lemma (none made yet)

**Verdict: real.** Neither the scratch board (_process/BECOMING-WORKBOARD.md) nor board_rfm2.py carries any proposal on total_single, a shared totals dependency or an addend lemma. F17 (1163) and PLAN §13 (349, 'no board proposal yet') say none was made. A8 (1123), re-check row 9 (1350) and PLAN §13's later '(its ninth: ... its move to a shared totals dependency proposed)' contradict them. The proposed fix covers A8 only.

**Better replacement.** A8: 'its move to a shared totals dependency is left for a board proposal to the owners, with F17's addend lemma (none made yet)'; re-check row 9: 'its move to a shared totals dependency left for a board proposal to the owners (none made yet)'; PLAN §13: '(its ninth: `total_single` stays as disclosed, its move to a shared totals dependency left for a board proposal)'

### E13 (exactness, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HeldForReading.lean:848; also REVIEW-RFM2-LEAN.md:1123 and :1136

**Quoted.** amount there (as `Interleavings.total_single`, outside this module's imports).

**Problem.** The theorem sits in namespace Interleavings.LocalLaw (Interleavings.lean:171-2474, theorem at 1441). `Interleavings.total_single` does not exist.

**Replacement.** amount there (as `Interleavings.LocalLaw.total_single`, outside this module's imports).

**Verdict: real.** Interleavings.lean opens namespace LocalLaw at line 171 and closes it at 2474, with total_single at 1441. The core receipt (becoming-checks/20261030T075728.527064Z) lists Becoming.Interleavings.LocalLaw.total_single, and no Interleavings.total_single exists. The wrong name is in HeldForReading.lean:848 and in rows A8 (1123) and E7 (1136).

### E14 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:191

**Quoted.** and with both conditions only where neither alternative reaches the other

**Problem.** pair_gains_unreached assumes trans and accords only. 'both conditions' adds the asymmetry condition the Lean dropped, and disagrees with the header, 03 §12 and the record, which say 'alone'.

**Replacement.** and, with comparisons transitive and according with the choices alone, only where neither alternative reaches the other (`pair_gains_unreached`)

**Verdict: real.** PLAN item 6 (191) first introduces two conditions: comparisons transitive and according, and no candidate ranking each of the two above the other. It then says 'with both conditions only where neither alternative reaches the other'. Since the re-check (point 7), pair_gains_unreached (1124-1140) takes trans and accords only. Header 89-90, 03 §12, the record's law 16 and the study all say 'alone'.

### E15 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/make_records_rfm2.py:284-285 (law 20; zh :288)

**Quoted.** valued one where it gains and nothing where it loses

**Problem.** SignLoop.model uses gainOf (1 at gains, 0 at loses) and lossOf (0 at gains, 1 at loses), and on the shifted values switching off is valued at the loss. The law states only going on's value. With the loss zero everywhere, no candidate would have the strict sign of loss and holding would never gain over going on, so the model as stated does not give the claimed iff. zh 续得处值一、损处值零 has the same gap.

**Replacement.** en: replace 'with each kept candidate weighted one and going on valued one where it gains and nothing where it loses' by 'each kept candidate weighted one, gain one where going on gains and loss one where it loses, else nothing' (law 419 of 420). zh: '每留候选权一，续之得于得处为一、续之损于损处为一，余为零' (98 of 190).

**Verdict: real.** Law 20 (make_records_rfm2.py:284-285; zh 288) gives only going on's value. On the record's own convention (law 5), switching off is valued at the loss, but law 20 leaves the loss unstated. choose_hold_iff (1352-1361) uses lossOf (0 where going on gains, 1 where it loses) together with gainOf, and the iff depends on that loss. The finding's en replacement drops 'with' and leaves the clause ungrammatical; the version below keeps it and fits the cap by shortening the tail.

**Better replacement.** en: 'The formation's choice is the worth law's on its model: with each kept candidate weighted one, the gain one where going on gains, the loss one where it loses, else nothing, it holds exactly where its kept candidates hold both signs, which is exactly where holding for the reading gains over both moves; elsewhere it takes the move they agree on, going on where none is kept, and holding stands only as high as that move.' (420 of 420); zh: 每留候选权一，得于续得处为一、损于续损处为一，余皆为零 in place of 每留候选权一，续得处值一、损处值零

### E16 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/make_records_rfm2.py:362-363

**Quoted.** choices rank as the shown reach does.

**Problem.** ChoiceOccasions.reach_within proves containment («则» («及» ch.Shown) P): wherever x reaches y, the comparison ranks x above y. The comparison may also rank pairs the reach leaves open, which pair_gains_iff and the does_not_show item rely on. 'rank as the shown reach does' (zh 依所示之及而排) reads as equality.

**Replacement.** en 'ChoiceOccasions.reach_within: comparisons transitive and according with the choices contain the shown reach, ranking one alternative above another wherever it reaches the other.' zh 'ChoiceOccasions.reach_within：传递且合于所择之较含所示之及，一者及他者处必排其于上。'

**Verdict: real.** ShownOrder.lean:123-124 has reach_within conclude «则» («及» ch.Shown) P, which is containment. According transitive comparisons may also rank pairs the reach leaves open, which both_ways_of_unreached and the record's does_not_show rely on. 'rank as the shown reach does' (make_records_rfm2.py:362-363; zh 依所示之及而排) reads as equality, whereas the root module's ShownOrder bullet says 'contains the shown reach'.

### E17 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/make_records_rfm2.py:427-430 and :434

**Quoted.** The reading formation's own state within the law that informs, and a principal's order as

**Problem.** The later item, RF-M.3, is 'a principal's valuation as state' in the new record (342), 03 §12's Open (533), PLAN §4.7 and the board text (board_rfm2.py:62); this amendment calls it the principal's order. The zh history (434: 主者之序) also names the principal 主者, while the next_delta and the new record use 受助者.

**Replacement.** '... and a principal's valuation as state the helper's acts can move (RF round 2's later item)'; zh '受助者之值为态'; history en 'the principal's valuation as state', zh '下一步留读之形成己之态与受助者之值为态'

**Verdict: real.** The ALIKE amendment's next_delta (425-430) and history (431-434) keep 'a principal's order as state'. Meanwhile the new record (342), 03 §12's Open (where the integration replaces 'order' by 'valuation'), PLAN's RF-M.3 ('The valuation as state'; an ordinal order supplies no evaluation) and the board text say valuation. The zh history's 主者 occurs in no record; the ALIKE record's own next_delta uses 受助者. The replacement fits the caps (278 of 400, 62 of 180).

### E18 (exactness, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HeldForReading.lean:77; also .../rf-formations-that-read/PLAN.md:349

**Quoted.** telling apart all a coarser one does never falls short by more (`finer_least_le`)

**Problem.** finer_least_le bounds the least shortfall through the finer map by the shortfall of every rule through the coarser map. A map has no shortfall, and a rule through a finer map can fall short by more. Re-check point 2 says refinement is stated everywhere as the least shortfall never increasing, yet PLAN §13 still writes 'a finer map never falling short by more'.

**Replacement.** through a map telling apart all a coarser one does, the least shortfall never increases (`finer_least_le`); PLAN §13: 'the least shortfall never increasing through a finer map'

**Verdict: real.** finer_least_le (963-971) bounds the least shortfall through π by the shortfall of any rule through a map factoring through π. A map itself has no shortfall, and its own docstring says 'the least shortfall never increases'. The re-check's point 2 asked for that wording consistently, yet header 76-77 and PLAN §13 (349, 'a finer map never falling short by more') keep the old shorthand.

### E19 (exactness, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:514 (source: .../kit/round2b/s12_rfm2.txt:4)

**Quoted.** his proviso of negligible cost relaxed to an amount forgone

**Problem.** The forgone-amount laws (threshold_go_iff, threshold_off_iff, forgone_within_excess_iff, through_threshold_iff) cover two moves only, and the module's Standing says 'for two moves'. No law relaxes the proviso over a general list of acts.

**Replacement.** his proviso of negligible cost relaxed, for two moves, to an amount forgone

**Verdict: real.** The amount forgone occurs only in threshold_go_iff, threshold_off_iff, forgone_within_excess_iff, forgone_below_excess_iff and through_threshold_iff, all on Move. The Standing (127-128) says the amount relaxes Good's proviso 'for two moves'. 03 §12's Reading (514) attaches the relaxation, unqualified, to 'Good's argument specialized to a reading that tells the candidate', which holds for any list of acts.

### E20 (exactness, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean:2790 and :2794; also .../theories/becoming/chapters/03-KNOWING.md:512 (cells sentence)

**Quoted.** (`HeldForReading.least_through`, `HeldForReading.finer_least_le`)

**Problem.** least_through states only that the least shortfall is at most every rule's shortfall through the map. That it totals the smaller excess within each cell is shortfall_through applied to leastThrough, which is not cited here or in 03 §12's cells sentence. 'rests at once' (2794) is rests_unread, which is also uncited; only never_senses_stop is cited.

**Replacement.** (`HeldForReading.shortfall_through`, `HeldForReading.least_through`, `HeldForReading.finer_least_le`); and 'rests at once and never senses the stop (`HeldForReading.SignLoop.rests_unread`, `HeldForReading.SignLoop.never_senses_stop`)'; in 03 §12 add `HeldForReading.shortfall_through` to the cells sentence

**Verdict: real.** least_through's statement (929-936) is only shortfall(leastThrough) <= shortfall(s ∘ π). That this least shortfall is the total of the smaller excesses within the cells is shortfall_through (893-905) applied to leastThrough, and 03 §12 does not cite shortfall_through at all, nor does the root bullet. In the root bullet (Becoming.lean:2794), 'rests at once' is rests_unread (1210), and only never_senses_stop is cited. The claims are proved; only the citations are incomplete.

### E21 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:187

**Quoted.** (`after_byReading`: `T E[U⁺]` and `T E[(−U)⁺]`,

**Problem.** With U = gain − loss, the weighted excess of switching off over going on is T E[(−U)⁺] and that of going on is T E[U⁺]. The parenthesis lists them in the opposite order to the sentence ('going on with the excess of switching off, and switching off with that of going on'), so a reader pairing them in order swaps them.

**Replacement.** (`after_byReading`: `T E[(−U)⁺]` and `T E[U⁺]` respectively,

**Verdict: real.** With U = gain - loss, offExcess = T E[(−U)⁺] and goExcess = T E[U⁺]. after_byReading (717-721) and the sentence at PLAN:187 put going on with offExcess first, but the parenthesis lists T E[U⁺] first and says no 'respectively'. That order is the order of Equation 3's terms (the literature table: the positive part first, the negative part second), so the finding's swap plus 'respectively' would clash with the following 'T times the terms of the paper's Equation 3'. Naming each excess avoids both misreadings.

**Better replacement.** (`after_byReading`: the excess of switching off is `T E[(−U)⁺]` and that of going on `T E[U⁺]`, `T` times the terms of the paper's Equation 3 with its negative-event probability read as `Pr(U < 0)` where `Pr(U ≤ 0)` is printed)

### E22 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:192

**Quoted.** holding first, it senses the stop, which refutes its only candidate, and with none kept it goes on

**Problem.** refuted_senses_stop, refuted_drops and refuted_goes_on are stated for the true sign loses (start [.gains] .plain .hold .loses). Where going on gains, holding first senses the release. The steps are also missing, and so is refuted_drops, which re-check point 8 says PLAN cites.

**Replacement.** holding first with the listing of gain alone, where going on loses, it senses the stop at the first step, which refutes its only candidate at the second, and with none kept it goes on by the witness's default (`SignLoop.refuted_senses_stop`, `SignLoop.refuted_drops`, `SignLoop.refuted_goes_on`)

**Verdict: real.** refuted_senses_stop, refuted_drops and refuted_goes_on (1226-1245) all start from [.gains] .plain .hold .loses. Where going on gains, the held start senses the release, and its candidate is not refuted. PLAN item 7 (192) omits 'where going on loses', the steps and refuted_drops, although re-check row 8 (1349) says PLAN cites it.

### E23 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:248

**Quoted.** Good's inequality with a reading that tells the candidate or its cell

**Problem.** For a reading that tells only a cell, the module gives the inequality only for two moves (least_through against a constant rule). For a general list of acts it has cell_policy_iff, which concerns attaining the best, not a comparison of the best policy through a map with committing.

**Replacement.** Good's inequality with a reading that tells the candidate, and for two moves with one that tells its cell

**Verdict: real.** For a reading that tells the candidate, committed_le_after gives Good's inequality for any list of acts. For a reading that tells only a cell, the module compares with committing only for two moves: least_through or through_threshold_iff with constant rules, and finer_least_le, which the Standing names as the Blackwell case 'for this decision'. For general acts, cell_policy_iff concerns attaining the best, so 'or its cell' at PLAN:248 overstates.

### E24 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/study_rfm2.txt:123

**Quoted.** `Population.total_congr_on`, `Dissipation.total_eq_zero`

**Problem.** These are not declaration names. The lemmas are `Becoming.total_congr_on` (Population.lean:304) and `Becoming.total_eq_zero` (Dissipation.lean:127); neither file has a Population or Dissipation namespace.

**Replacement.** `total_congr_on` (Population) and `total_eq_zero` (Dissipation)

**Verdict: real.** The core receipt lists Becoming.total_congr_on (Population.lean:304) and Becoming.total_eq_zero (Dissipation.lean:127), both declared directly in namespace Becoming. Neither file opens a Population or Dissipation namespace, and a different declaration, Becoming.Weighting.total_congr_on, exists. The backticked `Population.total_congr_on` and `Dissipation.total_eq_zero` at study_rfm2.txt:123 therefore read as Lean names that do not exist.

### E25 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/study_rfm2.txt:55-56

**Quoted.** candidate's decided comparisons rank them above the other

**Problem.** pairValue values a pick at one where the candidate ranks the picked alternative above the other. 'rank them above the other' does not say that.

**Replacement.** picks of two alternatives, each valued one where a candidate's decided comparisons rank the alternative picked above the other

**Verdict: real.** pairValue (1006-1010) values a pick one where the candidate ranks the picked alternative above the other. 'rank them above the other' (study_rfm2.txt:55-56) has a plural object against a singular 'the other' and does not say which alternative is ranked over which. The record's law 15 says 'rank it above the other'.

### E26 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/make_records_rfm2.py:297 (zh :301); also .../kit/round2b/study_rfm2.txt:75-78

**Quoted.** A policy best at every listed candidate supplied, one existing for every nonempty list of acts; for a

**Problem.** after_add_gap (open_q), committed_le_after, committed_eq_after_iff, below_iff and cell_policy_iff need the compared policy or act to be open at the listed candidates. The record's hypotheses and the study's supplied premises omit this, though the laws state it.

**Replacement.** en 'A policy best at every listed candidate supplied, one existing for every nonempty list of acts, and the policies and acts compared open at the listed candidates; for a ...' (392 of 420); zh '所予一于每列候选皆最优之策，凡非空之行列皆有之，所比之策与行于列候选皆可取；...' (115 of 190); the study's premises likewise

**Verdict: real.** after_le_after, after_add_gap and after_lt/eq_after_iff take open_q; committed_le_after, committed_eq_after_iff and below_iff take open_a; cell_policy_iff requires f k ∈ acts. The record's hypothesis item (297-300; zh 301) and the study's parenthetical list of 'each theorem's own hypotheses' (75-78) name the supplied best policy, choice and the cells' conditions but not openness, which only the laws state. The proposed lengths check: 392 of 420, 115 of 190.

### E27 (exactness, low, confirmed)

**Location.** theories/becoming/chapters/07-SIGNIFICANCE.md:603 (integrate_rfm2.py:159); also .../theories/becoming/review/ALIGNMENT.md:24 (integrate_rfm2.py:215)

**Quoted.** Nor does an incentive to accept one, which is the formation's own assessment

**Problem.** Reading an incentive to accept correction, or corrigibility as an incentive, as the worth comparison on the formation's model is an interpretation the Lean does not state. The dossier labels the analogous RF7 identification '[AI reading]'; these two carry no label.

**Replacement.** Nor does an incentive to accept one, read [AI reading] as the formation's own assessment: ...; dossier: 'corrigibility as an incentive, which RF reaches [AI reading] only on a formation's own model: ...'

**Verdict: real.** 07 §7 (603) says 'an incentive to accept one, which is the formation's own assessment', and the dossier (24) says 'corrigibility as an incentive, which RF reaches only on a formation's own model'. Neither is labelled. The Lean states only a worth comparison on the model; reading it as the off-switch literature's incentive is an interpretation, which the module's Readings, 03 §12 and the dossier's RF7 sentence label as AI readings. The neighbouring assistance-games bullet says 'RF's readings'. The finding's 07 wording puts the label on 'own assessment'; putting the theorem first reads better.

**Better replacement.** 07: 'Nor does the worth of accepting one on the formation's own model, read as an incentive to accept it [AI reading]: there, holding an act for a stopping reading stands above ...'; dossier: 'corrigibility as an incentive, which RF reaches [AI reading] only on a formation's own model: ...'

### E28 (exactness, low, confirmed)

**Location.** theories/becoming/chapters/08-METHOD.md:486 (source: integrate_rfm2.py:175)

**Quoted.** the relation the paper's Remark 1 draws qualitatively and its Theorem 2 writes for a Gaussian belief

**Problem.** The last paper named before this phrase is Blackwell's (1953). Remark 1 and Theorem 2 belong to the off-switch paper, as 03 §12's Reading says.

**Replacement.** the relation the off-switch paper's Remark 1 draws qualitatively and its Theorem 2 writes for a Gaussian belief

**Verdict: real.** In 08-METHOD.md:486, 'the paper's Remark 1' follows 'a reading that tells only a cell gives the partition case of Blackwell's (1953) comparison', the last work named. Remark 1 and Theorem 2 belong to the off-switch paper, as 03 §12's Reading and the study (97-98) say explicitly.

### E29 (exactness, low, confirmed)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:100 (integrate_rfm2.py:197); also ALIGNMENT.md:28 (integrate_rfm2.py:231), Becoming.lean:2792 (integrate_rfm2.py:97), check_becoming.py:2929-2930 (integrate_rfm2.py:74), board_rfm2.py:61

**Quoted.** On the reading loop, a formation choosing so on its own model, listing only that going on gains and going on from the start, never senses the stop.

**Problem.** 'so' has no fitting antecedent. The nearest candidates are choosing best after a reading that tells the candidate (a different policy) or holding for a rule. The witness's formation goes on, switches off or holds from its kept candidates. choose_hold_iff shows it holds exactly where holding for the reading gains over both moves on its model, each kept candidate weighted one. never_senses_stop does not depend on that.

**Replacement.** On the reading loop, a formation holding exactly where holding for the reading gains over both moves on its own model, listing only that going on gains and going on from the start, never senses the stop.

**Verdict: real.** In the overview (100), the clause before 'choosing so' concerns a reading through a cell, and the only earlier 'choosing' is choosing best after a reading that tells the candidate, a different policy. In the checker scope and the board, the preceding clause is about the shown reach or a rule's threshold. The witness's choose (1193-1197) holds exactly where holding gains over both moves on its model (choose_hold_iff), and never_senses_stop needs only that it goes on where every kept candidate predicts gain.

### R1 (readings, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:514 (Reading after r-what-holding-for-a-reading-is-worth)

**Quoted.** What the counts state is one threshold joining the model's openness (the smaller excess), the reading's errors counted by what they lose (the shortfall) and what holding forgoes: the relation the off-switch paper's Remark 1 draws qualitatively and its Theorem 2 writes for a Gaussian belief, decomposed differently here, as a relation among parts of the loop, not a disposition of one formation.

**Problem.** This attributes the three-term relation, what holding forgoes included, to the off-switch paper. The paper has no cost of waiting. Its only 'cost' sentence is about disabling the switch, and its Section 5 'cost' is the value lost to added uncertainty. Remark 1 locates the incentive in 'uncertainty about that actor's preferences and the assumption that actor is effective at choosing actions in accordance with those preferences'. Theorem 2 writes the incentive itself, Δ = σ²E[π̇H] − |µ|Pr(C). Section 4 calls this a trade-off between R's uncertainty and H's suboptimality. In the counts that incentive is T·Δ = smaller excess − shortfall. The amount forgone is compared with it, which relaxes Good's proviso. It is not part of the paper's relation.

**Replacement.** What the counts state is one threshold joining the model's openness (the smaller excess), the reading's errors counted by what they lose (the shortfall) and what holding forgoes, a relation among parts of the loop, not a disposition of one formation. Its first two terms make the relation the off-switch paper's Remark 1 draws qualitatively and its Theorem 2 writes for a Gaussian belief, decomposed differently here; the paper's game has no cost of waiting, and the amount forgone is where Good's proviso is relaxed.

**Verdict: real.** The paper's text (arXiv 1611.08219v3, extracted) has no cost of waiting. Its only prose 'cost' is an extension, 'imposing a cost on R for disabling the off switch', and Figure 4's 'cost' is value lost to added uncertainty. Remark 1 says the incentives 'stem from uncertainty about that actor's preferences and the assumption that actor is effective', and Theorem 2 writes Δ itself; in the counts that incentive is the smaller excess less the shortfall (after_add_shortfall_go/off), and the amount forgone is only compared with it (threshold_go_iff/threshold_off_iff). The appositive at 03:514 nevertheless makes the whole three-term threshold 'the relation' Remark 1 draws. The proposal's 'Its first two terms make the relation' is loose.

**Better replacement.** What the counts state is one threshold joining the model's openness (the smaller excess), the reading's errors counted by what they lose (the shortfall) and what holding forgoes, a relation among parts of the loop, not a disposition of one formation. The openness less the shortfall is the incentive the off-switch paper's Remark 1 places, qualitatively, in uncertainty about the other's preferences and the other's effectiveness, and its Theorem 2 writes for a Gaussian belief, decomposed differently here; the paper's game has no cost of waiting, and comparing that incentive with an amount forgone relaxes Good's proviso, for the two moves.

### R2 (readings, medium, confirmed)

**Location.** theories/becoming/chapters/08-METHOD.md:486 (known-results bullet 'What holding an act for a reading is worth')

**Quoted.** what the counts add is one threshold joining the model's openness, the reading's shortfall and what holding forgoes, the relation the paper's Remark 1 draws qualitatively and its Theorem 2 writes for a Gaussian belief, which is not represented; the counts decompose it differently.

**Problem.** Same over-attribution as in 03 §12. The off-switch game has no amount forgone. Remark 1 and Theorem 2 (Δ = σ²E[π̇H] − |µ|Pr(C)) relate only the robot's uncertainty and the human's effectiveness or correction, that is the openness and the shortfall. Here the forgone amount is credited to the paper.

**Replacement.** what the counts add is one threshold joining the model's openness, the reading's shortfall and what holding forgoes; the first two are related as the paper's Remark 1 draws qualitatively and its Theorem 2 writes for a Gaussian belief, which is not represented, the counts decomposing it differently, and the paper's game has no cost of waiting.

**Verdict: real.** 08-METHOD.md:486 makes the same apposition: 'one threshold joining the model's openness, the reading's shortfall and what holding forgoes, the relation the paper's Remark 1 draws qualitatively and its Theorem 2 writes'. Against the paper's text checked for finding 1, the forgone amount has no counterpart there. The proposal is acceptable, but it should say what the first two terms make up.

**Better replacement.** what the counts add is one threshold joining the model's openness, the reading's shortfall and what holding forgoes; the openness less the shortfall is the incentive the paper's Remark 1 places qualitatively and its Theorem 2 writes for a Gaussian belief, which is not represented, the counts decomposing it differently, and the paper's game has no cost of waiting.

### R3 (readings, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:514 (last sentences of the same Reading)

**Quoted.** Holding for a reading on its own model makes a formation correctable only as far as that model is right;

**Problem.** This overstates the witness and conflicts with the Lean and with 07 §7 and the dossier. What decides whether holding has worth on the model is the model's openness, not its rightness: holding gains over both moves exactly where both strict signs have positive weight (held_gains_iff, SignLoop.choose_hold_iff). A listing with both signs holds and is stopped or released whatever its weights (both_off, both_on). A right model that fixes the sign has no strict reason to hold (held_eq_go_iff, choose_go_ties). The witness shows only that a listing missing the true sign can pass the stop by. 07 §7 and the dossier say this exactly ('needs the model open on the sign of going on, and a model that misses the true sign can rest without meeting the stop'), so 03 and the overview now disagree with them.

**Replacement.** Holding for a reading on its own model makes a formation correctable only where that model leaves the sign of going on open: a listing that misses the true sign can fix the sign and pass the stop by;

**Verdict: real.** Holding has strict worth exactly where both strict signs have positive weight, whatever the weights (held_gains_iff, SignLoop.choose_hold_iff), and a model fixing the sign, rightly or wrongly, only ties (held_eq_go_iff, SignLoop.choose_go_ties). So 'only as far as that model is right' puts the condition in the wrong place, while 07:603 states it exactly ('needs the model open on the sign of going on, and a model that misses the true sign can rest without meeting the stop'). The proposal's 'correctable only where' is slightly too strong at ties, since the module's Readings and Carey's footnote 1 leave a deferring tie rule open, so it should say strict reason.

**Better replacement.** Holding for a reading on its own model gives a formation a strict reason to be corrected only where that model leaves the sign of going on open, and a listing that misses the true sign can fix the sign and pass the stop by;

### R4 (readings, medium, confirmed)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:100

**Quoted.** and, beside Carey's counterexamples, as a reason to be corrected that holds only as far as the formation's model is right [AI reading]

**Problem.** Same overstatement as in 03, on the front page. The reason to hold depends on the model leaving the sign open (positive weight on both strict signs), not on the model being right. A wrong-weighted model listing both signs still holds; a right model fixing the sign does not. It is inconsistent with 07 §7 and the dossier's corrigibility bullet.

**Replacement.** and, beside Carey's counterexamples, as a reason to be corrected that the formation has only where its own model leaves the sign of going on open, so that a model missing the true sign can rest without meeting the stop [AI reading]

**Verdict: real.** THE-THEORY-OF-BECOMING.md:100 reads 'a reason to be corrected that holds only as far as the formation's model is right'. On the Lean that reason exists exactly where the model gives positive weight to both strict signs (held_gains_iff, excess_pos_iff), not where it is right. 07 §7 and the dossier's corrigibility bullet say it that way. The proposal is right, with 'strict' added for ties.

**Better replacement.** and, beside Carey's counterexamples, as a strict reason to be corrected that the formation has only where its own model leaves the sign of going on open, so that a model missing the true sign can rest without meeting the stop [AI reading]

### R5 (readings, medium, confirmed)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:100

**Quoted.** any policy falls short of one best at every listed candidate by the weighted total of what its acts lose, so choosing best after a reading that tells the candidate stands above committing to any open act exactly where no open act is valued best at every listed candidate of positive weight; holding for a reading that stops or releases stands above both going on and switching off exactly where the model gives positive weight to both signs of going on;

**Problem.** These clauses are given as 'Proved' but say more than the Lean. held_gains_iff is for byReading only: the reading that tells the candidate and stops exactly where the loss exceeds the gain. For another reading that stops or releases, the claim is false; for example, a rule that always stops never stands above switching off. after_add_gap also needs the policy to choose open acts. 03 §12, Becoming.lean and the checker all say 'the reading that tells the candidate' or 'the reading that stops where the loss exceeds the gain'.

**Replacement.** any policy choosing open acts falls short of one best at every listed candidate by the weighted total of what its acts lose, so choosing best after a reading that tells the candidate stands above committing to any open act exactly where no open act is valued best at every listed candidate of positive weight; holding for the reading that tells the candidate, stopping exactly where going on loses, stands above both going on and switching off exactly where the model gives positive weight to both strict signs of going on;

**Verdict: real.** In the scratch overview, 'any policy' drops after_add_gap's open_q hypothesis: a policy taking an act outside the open list can stand above the best. 'A reading that stops or releases' generalizes held_gains_iff, which holds for byReading only (holding for the always-stop rule equals switching off), and the clause says 'both signs', not both strict signs. The branch head 82725b416 already makes this change in integrate_rfm2.py, and the proposal is accurate.

### R6 (readings, medium, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean:2788-2791; check_becoming.py:2929

**Quoted.** within
  `ShownOrder`'s reach holding a pick gains nothing (`HeldForReading.reach_fixes`)  /  checker: "within ShownOrder's reach, holding a pick gains nothing"

**Problem.** reach_fixes needs every listed candidate of positive weight to have transitive comparisons that accord with the choices. Without that, a candidate ranking the second above the first gives holding a strict gain even within the reach. The re-check's point 6 made exactly this point about the record amendment, which was fixed, but the root module's bullet and the checker's scope sentence still drop the condition. The same two sentences also drop the cells' conditions (listed once each, covering every listed candidate's cell) on 'the least shortfall totals the smaller excess within each cell'.

**Replacement.** Becoming.lean: "through a map of the candidates whose cells are listed once each and cover every listed candidate's cell, the least shortfall totals the smaller excess within each cell, never increasing through a finer map (...); within `ShownOrder`'s reach, with every listed candidate of positive weight transitive and according with the choices, holding a pick gains nothing (`HeldForReading.reach_fixes`)". check_becoming.py: "...; within ShownOrder's reach, with every listed candidate of positive weight transitive and according with the choices, holding a pick gains nothing; ..." (and the same cell conditions).

**Verdict: real.** Becoming.lean:2790-2791 and check_becoming.py:2929 state reach_fixes without its trans and accords hypotheses. Without them, a candidate of positive weight ranking y above x while x reaches y values the reading's pick at 1 and the first pick at 0, a strict gain within the reach; re-check point 6 (REVIEW-RFM2-LEAN.md:1262) made this point about the record amendment. The branch head 82725b416 already adds the condition to both sentences. Omitting the cells' conditions is harmless in these summaries: 'within each cell' already counts each cell once, and once/covers only fix how least_through enumerates the cells.

### R7 (readings, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:489 (§12 opening)

**Quoted.** Four laws state that loop under their premises: when a reading of the world is kept by the formation's own update, and which reading its own history carries; what a course chosen through a model tests of the laws it keeps; what acts cannot tell of a model and an order; when a prediction read by what it predicts is right; and what holding an act for a reading is worth on the formation's own model.

**Problem.** The sentence now lists five laws, and §12 has five theorem paragraphs. Main's 'Four' had four items; the fifth item was appended without updating the count.

**Replacement.** Five laws state that loop under their premises: when a reading of the world is kept by the formation's own update, and which reading its own history carries; what a course chosen through a model tests of the laws it keeps; what acts cannot tell of a model and an order; when a prediction read by what it predicts is right; and what holding an act for a reading is worth on the formation's own model.

**Verdict: real.** Scratch 03:489 says 'Four laws' and then lists five items, the fifth appended to main's four-item sentence, and §12 now has five theorem paragraphs. The branch head 82725b416 already changes it to 'Five'.

### R8 (readings, low, confirmed)

**Location.** Becoming/HeldForReading.lean:163-165; kit/round2b/make_records_rfm2.py:352-353 (correspondence, en and zh); kit/round2b/study_rfm2.txt:97-98; evidence/REVIEW-RFM2-LEAN.md:1097 (literature table, Remark 1 row)

**Quoted.** module: "a relation among the model's openness, the reading's shortfall and what holding forgoes, not a disposition of one formation. The off-switch paper draws this relation in its own terms:"; record: "AI reading: the threshold relates the model's openness, the reading's shortfall and what holding forgoes, as the paper's Remark 1 does qualitatively;" (zh: "其界关联模型之开放、读之所缺与持之所舍，如该文之注一定性所为"); study: "the threshold relates the model's openness, the reading's shortfall and what holding forgoes, as the off-switch paper's Remark 1 does qualitatively"; table: "the threshold relates the model's openness, the reading's shortfall and what holding forgoes [AI reading]"

**Problem.** These are the same over-attribution in the kit and evidence: Remark 1 and Theorem 2 relate uncertainty and the human's effectiveness, and the paper's game has no amount forgone. The module's following sentences are right that the paper's incentive is the smaller excess less the shortfall, but 'draws this relation' points back to the three-term relation.

**Replacement.** Module: "...what holding forgoes, not a disposition of one formation. The off-switch paper, whose game has no cost of waiting, draws the relation of the first two in its own terms:" (editing the header changes the source hash, so the receipt needs a fresh core run). Record (en): "AI reading: the threshold relates the model's openness and the reading's shortfall, as the paper's Remark 1 does qualitatively, plus what holding forgoes;". This fits the 1200 cap that capped() asserts only together with the trims ", T the total weight," for " with T the total weight,", "Equation 1's terms" for "Equation 1's two terms" and "decomposing it otherwise" for "decomposing it differently". With the Blackwell and Carey edits below the total is exactly 1200. zh: "其界关联模型之开放与读之所缺，如该文之注一定性所为，并加持之所舍". Study: "Read [AI reading], the threshold relates the model's openness and the reading's shortfall, as the off-switch paper's Remark 1 does qualitatively (its game has no cost of waiting; what holding forgoes is added here), its Theorem 2 writing...". Table: "the threshold relates the model's openness and the reading's shortfall as Remark 1 does, and adds what holding forgoes, which the paper's game lacks [AI reading]".

**Verdict: real.** The record's correspondence (make_records_rfm2.py:352-353, en and zh) and study_rfm2.txt:97-98 credit the three-term relation to Remark 1 directly. The module's header (163-165) says the paper 'draws this relation' before narrowing to the incentive, and the Remark 1 row of the literature table reads the forgone amount into the remark, which the paper's game lacks. Editing the module changes its hash, which make_records asserts against the receipt, so it needs a fresh core run. The proposed record wording is awkward; the wording below fits the cap on its own (measured 1195 of 1200 en, 406 of 500 zh).

**Better replacement.** Record en: "AI reading: the model's openness less the reading's shortfall is the incentive its Remark 1 places qualitatively, the threshold adding what holding forgoes;" Combined with the record edits of findings 10 and 12 this measures 1205, and 1197 after the trims ' with T the total weight,' → ', T the total weight,' and "Equation 1's two terms" → "Equation 1's terms". zh: "AI 解读：模型之开放减读之所缺，即该文之注一定性所言之诱因，其界复加持之所舍；". Study: "Read [AI reading], the model's openness less the reading's shortfall is the incentive the off-switch paper's Remark 1 places qualitatively, its Theorem 2 writing it for a Gaussian belief and the counts decomposing it differently; the threshold adds what holding forgoes, which the paper's game lacks;". Table (Remark 1 row): "the model's openness less the reading's shortfall is that incentive, decomposed otherwise; the threshold adds what holding forgoes, which the paper's game lacks [AI reading]". Module: as proposed.

### R9 (readings, low, confirmed)

**Location.** theories/becoming/review/ALIGNMENT.md:28 (RF-M.2 sentence); kit/round2b/board_rfm2.py:58 (land branch)

**Quoted.** dossier: "holding an act for a reading that stops or releases stands above both going on and switching off exactly where the formation's model gives positive weight to both signs of going on"; board: "holding for a reading that stops or releases stands above both moves exactly where the model gives positive weight to both strict signs"

**Problem.** held_gains_iff holds only for the reading that tells the candidate and stops where the loss exceeds the gain (the paper's rational human, Equation 2). Read generally, 'a reading that stops or releases' makes the claim false for any erring rule, which the next clause ('any rule of stopping') treats separately.

**Replacement.** dossier: "holding an act for the reading that tells the candidate, stopping exactly where going on loses (the rational human), stands above both going on and switching off exactly where the formation's model gives positive weight to both strict signs of going on"; board: "holding for the reading that stops where the loss exceeds the gain stands above both moves exactly where the model gives positive weight to both strict signs"

**Verdict: real.** Scratch ALIGNMENT.md:28 ('a reading that stops or releases ... both signs of going on') and board_rfm2.py:58 ('a reading that stops or releases ... both strict signs') generalize held_gains_iff, which holds for byReading only and fails for any erring rule. The branch head 82725b416 already makes both texts name the reading that stops where the loss exceeds the gain, with strict signs. The proposal is accurate.

### R10 (readings, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:514; theories/becoming/review/ALIGNMENT.md:28; kit/round2b/make_records_rfm2.py:356 (en and zh); PLAN.md:192 (§4.7 item 7)

**Quoted.** 03 and dossier: "whose predictions appear perfectly accurate on the observations it encodes and which then ignores shutdown"; record: "and which ignores shutdown" (zh "而不从关机"); PLAN: "then takes the worse act, ignoring shutdown"

**Problem.** Carey's conflating model takes the worse of two conflated acts. It ignores shutdown only where the better act is shutting down: his error 'would allow a harmful agent to permanently ignore instructions to shut down' when a+ is shutdown. The module's Readings keep that condition ('so that where the better act is shutting down it goes on ignoring the instruction to shut down'); these texts state it unconditionally.

**Replacement.** 03 and dossier: "whose predictions appear perfectly accurate on the observations it encodes and which then takes the worse act, ignoring shutdown where the better act is shutting down"; record: "and which may ignore shutdown" (zh "而可不从关机"; within the cap with the trims above); PLAN: "then takes the worse act, ignoring shutdown where the better act is shutting down".

**Verdict: real.** Carey's Discussion (arXiv 1709.06275v2, extracted) says the conflating system always performs a−, and only 'If a+ represented the act of shutting down' would it 'permanently ignore instructions to shut down'. The module's Readings keep that condition, but 03:514, ALIGNMENT.md:28, the record (line 356, en 'which ignores shutdown', zh '而不从关机') and PLAN:192 ('then takes the worse act, ignoring shutdown') drop it; the committed branch PLAN still has it. The proposals are right, and the record's 'may ignore' fits the cap (1191 of 1200 alone).

### R11 (readings, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:514 (first two sentences of the Reading)

**Quoted.** Holding an act for another's reading is the off-switch game's waiting (Hadfield-Menell, Dragan, Abbeel and Russell 2017), and its worth is Good's (1967) value of evidence. ... with his Lemma's dominating row as the equality boundary and his proviso of negligible cost relaxed to an amount forgone;

**Problem.** Holding for another's reading is worth Good's value of evidence only where the reading stops by the formation's own values (byReading). For any other rule the worth is that value less the rule's shortfall (after_add_shortfall), and it can be negative, as the paper's Section 4 shows. The proviso is relaxed only for the two moves (threshold_go_iff and threshold_off_iff), as the module says ('for two moves').

**Replacement.** Holding an act for another's reading is the off-switch game's waiting (Hadfield-Menell, Dragan, Abbeel and Russell 2017), and, where the reading stops by the formation's own values, its worth is Good's (1967) value of evidence; for another rule it is that value less the rule's shortfall. ... with his Lemma's dominating row as the equality boundary and, for the two moves, his proviso of negligible cost relaxed to an amount forgone;

**Verdict: real.** after_add_shortfall gives holding for any rule the reading's value less its shortfall. So the worth is Good's value of evidence only for a reading that stops by the shared values (byReading, or leastThrough for a cell); for another rule it is less and can be negative. Every forgone amount in the Lean sits on Move (threshold_go_iff, threshold_off_iff and their corollaries), and the module's Standing says 'for two moves'. 03:514 states both claims without these limits. The proposal is fine.

### R12 (readings, low, confirmed)

**Location.** kit/round2b/make_records_rfm2.py:351-352 (correspondence, en and zh); also 03-KNOWING.md:514 and 08-METHOD.md:486

**Quoted.** record: "the least shortfall through a partition is the partition case of Blackwell's (1953) comparison." (zh "经分割之最少所缺即 Blackwell（1953）比较之分割之例"); 03/08: "a reading that tells only a cell gives the partition case of Blackwell's (1953) comparison, for this decision"

**Problem.** finer_least_le proves one direction for one two-move decision: a finer map's least shortfall is no greater. Blackwell's comparison is an equivalence over every decision problem. The record credits Blackwell to the least shortfall itself and drops both 'for this decision' and the direction, which the module ('from finer to worth at least as much, for this decision') and the study keep. 03 and 08 keep 'for this decision' but not the direction.

**Replacement.** record: "a finer partition never raising the least shortfall is, for this decision, Blackwell's (1953) partition case." (zh "分割愈细，最少所缺不增，于此抉择即 Blackwell（1953）比较之分割之例"; fits the cap with the trims above); 03/08: "a reading that tells only a cell gives, for this decision, the partition case of Blackwell's (1953) comparison, from finer to worth at least as much".

**Verdict: real.** finer_least_le proves one direction, that a finer map's least shortfall is no greater, for the two-move decision. The module's Standing ('from finer to worth at least as much, for this decision') and the study ('a finer one never worse ... for this decision') keep both limits, but the record (lines 351-352, en and zh) makes 'the least shortfall through a partition' itself the partition case, with neither limit. In 03 and 08, 'for this decision' already confines the claim to the one direction a single decision can give, so they can stay. The proposed record wording overruns the cap on its own; the wording below does not (1195 of 1200).

**Better replacement.** Record en: "refinement never raising the least shortfall is, for this decision, Blackwell's (1953) partition case."; zh as proposed: "分割愈细，最少所缺不增，于此抉择即 Blackwell（1953）比较之分割之例"; 03 and 08 unchanged.

### R13 (readings, low, confirmed)

**Location.** theories/becoming/chapters/07-SIGNIFICANCE.md:603

**Quoted.** Nor does an incentive to accept one, which is the formation's own assessment:

**Problem.** Reading 03 §12's worth law as an incentive to accept a stop (corrigibility as an incentive) is an AI reading; 03 labels it, and the dossier marks its box. Here it is stated as theory text without the label, and the economic word 'incentive' is used outside an attribution.

**Replacement.** Nor does an incentive to accept one, as the worth law of 03 §12 reads [AI reading], which is the formation's own assessment:

**Verdict: real.** 07:603 identifies 'an incentive to accept [a stop]' with the worth law in the chapter's own voice. The repository labels that kind of identification elsewhere: 07's own table row ('read [AI reading] ... as the incentive deceptive alignment names'), PLAN §5 and §8 ('the incentive ... a reading'), and the dossier's labelled corrigibility bullet. The proposed 'as the worth law of 03 §12 reads' makes the law the reader.

**Better replacement.** Nor does an incentive to accept one, read [AI reading] as the formation's own assessment: on its model,

### R14 (readings, low, confirmed)

**Location.** _process/.../rf-formations-that-read/PLAN.md:248 (§8 literature row)

**Quoted.** Good's inequality with a reading that tells the candidate or its cell, and the off-switch Theorem 1 and Equation 1, restated in counts

**Problem.** No theorem states Good's inequality for a reading that tells only a cell. cell_policy_iff concerns attaining the best, and through_threshold_iff turns on least shortfall ≤ both excesses, which follows from least_through with the constant rules but is not stated. The row claims a restatement the Lean does not contain.

**Replacement.** Good's inequality with a reading that tells the candidate, and through a reading that tells only a cell the two-move threshold and refinement (`through_threshold_iff`, `finer_least_le`), and the off-switch Theorem 1 and Equation 1, restated in counts

**Verdict: real.** No theorem in HeldForReading states that choosing after a cell reading stands at least as high as committing to an act. after_le_after compares a cell policy only with the full reading's best, cell_policy_iff is about reaching that best, and for two moves the inequality only follows, unstated, from finer_least_le with a one-cell coarser map (or least_through with constant rules) together with through_threshold_iff. PLAN:248's 'Good's inequality with a reading that tells the candidate or its cell ... restated in counts' therefore overstates. The proposal is accurate.

### R15 (readings, low, confirmed)

**Location.** _process/.../rf-formations-that-read/evidence/REVIEW-RFM2-LEAN.md:1171 (row L1), 1180 (row L10)

**Quoted.** L1: "Not carried: the name 'Equation 2', and 'the reading's accuracy' stays (see L11). PLAN.md:187-189 is rewritten in the worktree's uncommitted copy, but its item 4 still says 'One threshold joins … the reading's accuracy'."; L10: "the parenthetical reading of Untested with Fudenberg and Levine (1993) and Rothschild (1974) is not repeated."

**Problem.** Both rows are stale against the module and plan as they now stand, and neither is marked 'updated after the check'. byReading's docstring names 'its Equation 2' (HeldForReading.lean:464). 'accuracy' no longer occurs in the module, the record or PLAN. PLAN §4.7 item 4 now says 'the reading's shortfall'. L11's updated row says the same, so L1 contradicts it. The module's Readings now carry '(read there with self-confirming equilibrium and incomplete learning)'.

**Replacement.** L1: end with "Updated after the check: the name 'Equation 2' is carried in `byReading`'s docstring, 'accuracy' is replaced by 'shortfall' (L11), and PLAN §4.7 item 4 reads 'One threshold joins the model's openness, the reading's shortfall, counted by the valuation it shares with the model, and what holding forgoes'." L10: "the parenthetical names Untested's reading (self-confirming equilibrium and incomplete learning) without the citations of Fudenberg and Levine (1993) and Rothschild (1974)."

**Verdict: real.** In scratch REVIEW-RFM2-LEAN.md, L1 (line 1171) still says 'Not carried: the name Equation 2, and the reading's accuracy stays'. Yet byReading's docstring (HeldForReading.lean:464) names Equation 2, 'accuracy' is gone from the module, record and PLAN (item 4 now says shortfall), L11 says so, and the table's preamble asks for rows completed later to be updated. L10 (line 1180) says the parenthetical reading 'is not repeated', but the Readings now carry '(read there with self-confirming equilibrium and incomplete learning)' without the citations. The branch head 82725b416 updates L1 only; the proposals are fine.

### R16 (readings, low, confirmed)

**Location.** kit/round2b/make_records_rfm2.py:425-434 (AMEND for acts-alike-from-a-model-or-from-an-order: next_delta and history, en and zh)

**Quoted.** "The reading formation's own state within the law that informs, and a principal's order as state the helper's acts can move (RF round 2's later item)" / zh "…与助者之行可移之受助者之序为态…"; history "the principal's order as state" / zh "…与主者之序为态…"

**Problem.** The amendment rewrites this clause but keeps 'order as state'. The record's own next_delta, 03's Open ('a principal's valuation as state') and PLAN's RF-M.3 ('an ordinal order supplies no evaluation, so a valuation with its scale supplied must be the state') now say valuation, and the zh history also switches from 受助者 to 主者 for the principal. The terms disagree.

**Replacement.** en_new: "The reading formation's own state within the law that informs, and a principal's valuation as state the helper's acts can move (RF round 2's later item)" (278 of 400 characters); zh_new: "律内能告者己之态，与助者之行可移之受助者之值为态（RF 第二轮之后项）"; history en: "...keeps the reading formation's own state and the principal's valuation as state..."; zh: "...下一步留读之形成己之态与受助者之值为态..."

**Verdict: real.** The ALIKE amendment (make_records_rfm2.py:425-434) rewrites the next_delta clause but keeps 'a principal's order as state', while the new record's next_delta, 03's Open bullet and PLAN's RF-M.3 now say valuation. Its zh history writes 主者 where its zh next_delta and the acts-alike record write 受助者, and 主者 occurs in no record. The proposed en_new gives a full next_delta of 278 of 400 characters (checked).

### R17 (readings, low, refuted)

**Location.** theories/becoming/review/ALIGNMENT.md:24 (box bullet on corrigibility as an incentive)

**Quoted.** Whether a system is willing to accept costly correction is not derived.

**Problem.** The bullet now states, on the formation's own model, exactly when holding while forgoing an amount (costly correction) is not below either move. The unchanged closing sentence reads as if even that were not derived. It should limit itself to what is outside the model's assessment.

**Replacement.** Whether an actual system's model leaves the sign open, or whether the system acts on that assessment and accepts costly correction, is not derived.

**Verdict: not real.** ALIGNMENT.md:24 confines RF's reach to 'a formation's own model' and states there when holding, forgoing an amount, is not below either move. Its closing sentence concerns whether 'a system is willing', a disposition the Lean does not derive. Read with the quoted 07 line ('A disposition to accept a stop or revision does not make the change reach the system and complete'), it is consistent and true as written, so the rewording is a clarification of taste.

### F1 (fit, high, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:512; also theories/becoming/THE-THEORY-OF-BECOMING.md:100, theories/becoming/review/ALIGNMENT.md:24 and :28, lean/becoming/Becoming.lean:2787, lean/becoming/check_becoming.py:2927, lean/becoming/Becoming/HeldForReading.lean:79, rf-formations-that-read/kit/round2b/board_rfm2.py:60, rf-formations-that-read/PLAN.md:189, rf-formations-that-read/kit/round2b/study_rfm2.txt:40 and :53-54, rf-formations-that-read/kit/round2b/make_records_rfm2.py:161-162 and :249

**Quoted.** stands at least as high as going on exactly where its shortfall and the amount are at most the excess of switching off, above it exactly where they fall below it

**Problem.** `threshold_go_iff`, `threshold_off_iff` and `through_threshold_iff` bound the sum, `shortfall + forgone ≤ offExcess` (and `<`). In mathematical English, 'its shortfall and the amount are at most the excess' means each is at most the excess. That condition is weaker, and on that reading the 'exactly where' is false: a shortfall and an amount each equal to a positive excess satisfy it, yet holding then stands below going on. Some texts already say 'together': the theorems' docstrings (HeldForReading.lean:60, 775, 788, 974), the record's law (make_records_rfm2.py:227) and every Chinese text (合). These do not: the home statement, the overview, both dossier passages, the root bullet, the checker's scope, the board's landing sentence, the plan, the study, the header's cells line, and the record's English statement and cells law. Unchanged at 82725b416.

**Replacement.** Add 'together' wherever the threshold is stated. Home statement: '…exactly where its shortfall and the amount together are at most the excess of switching off, above it exactly where together they fall below it'. The same in the overview, dossier :28, the root bullet, the checker's scope, the board, PLAN and the study. Dossier :24: '…exactly where the reading's shortfall and what holding forgoes together are within both of the model's excesses'. Header :79, study :54 and record :249: '…that least shortfall and the amount together are at most (within) both excesses'. The record's capped statement: '…exactly where shortfall plus amount is within switching off's excess' (same length, 298 characters).

**Verdict: real.** Every listed scratch location says the threshold holds where 'its shortfall and the amount are at most the excess': 03:512, overview:100, dossier :24/:28, Becoming.lean:2787, check_becoming.py:2927, header :79, board :60, PLAN :189, study :40/:54, record :161-162/:249. But `threshold_go_iff`, `threshold_off_iff` and `through_threshold_iff` bound the sum `shortfall + forgone ≤ offExcess`. Read distributively, s = c = E > 0 meets the text while s + c > E, so holding stands below going on and the 'exactly where' fails. The module's own docstrings (775, 788, 974), header :60, record law :227 and the zh 合 all say 'together'. Unchanged at 82725b416; the working tree's uncommitted kit is adding 'together'/'plus'.

**Better replacement.** As proposed. Also 07 §7's 'the reading's shortfall, with what holding forgoes, stays below both of the model's excesses' should read 'the reading's shortfall and what holding forgoes together stay below both of the model's excesses'.

### F2 (fit, high, confirmed)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:100; also theories/becoming/review/ALIGNMENT.md:28 and rf-formations-that-read/kit/round2b/board_rfm2.py:58

**Quoted.** holding for a reading that stops or releases stands above both going on and switching off exactly where the model gives positive weight to both signs of going on

**Problem.** `held_gains_iff` is stated only for `byReading`, the reading that stops exactly where the loss exceeds the gain. Stated of a reading in general it is false: a rule that always stops stands exactly as high as switching off. 'Both signs' also drops 'strict', which carries the tie convention (`byReading` goes on at equal gain and loss). The dossier's round paragraph and the board's landing sentence say the same. Changed at 82725b416.

**Replacement.** holding for the reading that stops where the loss exceeds the gain stands above both going on and switching off exactly where the model gives positive weight to both strict signs of going on

**Verdict: real.** In the scratch, the overview (:100), the dossier (:28) and the board (:58) say holding for 'a reading that stops or releases' stands above both moves exactly where both signs have positive weight. `held_gains_iff` is stated for `byReading` alone. For `byRule (fun _ => true)`, `after_rule` gives exactly `committed .off`, so holding for it never stands above switching off. The overview and the dossier also drop 'strict'; the board keeps it. Already fixed at 82725b416 in all three places ('the reading that stops where the loss exceeds the gain … both strict signs'), so nothing further is needed.

### F3 (fit, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:489

**Quoted.** Four laws state that loop under their premises

**Problem.** The sentence lists five laws, and §12 states five theorems. Changed at 82725b416 (integrate_rfm2.py).

**Replacement.** Five laws state that loop under their premises

**Verdict: real.** 03:489 in the scratch reads 'Four laws state that loop under their premises' but lists five items. §12 has five theorem anchors, from r-a-reading-kept-by-its-update to r-what-holding-for-a-reading-is-worth. Fixed at 82725b416: integrate_rfm2.py now edits it to 'Five laws'.

### F4 (fit, medium, confirmed)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:100

**Quoted.** any policy falls short of one best at every listed candidate by the weighted total of what its acts lose, so choosing best after a reading that tells the candidate stands above committing to any open act exactly where no open act is valued best at every listed candidate of positive weight

**Problem.** `after_add_gap` holds only for a policy that chooses open acts at the listed candidates (`open_q`). If a policy takes an act outside the open ones that is valued above the best, the identity breaks, because natural-number subtraction truncates. Separately, 'committing to any open act' leaves the quantifier unclear inside an 'exactly where'. `reading_gains_iff` is about gaining over every open act, as 03 §12 says. The open-acts clause is changed at 82725b416; 'any open act' is not.

**Replacement.** a policy choosing open acts falls short of one best at every listed candidate by the weighted total of what its acts lose, so choosing best after a reading that tells the candidate stands above committing to every open act exactly where none is valued best at every listed candidate of positive weight

**Verdict: real.** The scratch overview says 'any policy falls short of one best … by the weighted total of what its acts lose'. `after_add_gap` needs `open_q`: if a policy takes a non-open act valued above the best, `value c (p c) - value c (q c)` truncates to 0 and the identity fails. 82725b416 fixes this ('a policy choosing open acts'). What remains, 'committing to any open act', is the ordinary universal 'any' and not a defect. 'Every' would match 03 §12 and `reading_gains_iff`'s ∀, and the working tree already uses it.

### F5 (fit, medium, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean:2790-2791; also lean/becoming/check_becoming.py:2929

**Quoted.** within `ShownOrder`'s reach holding a pick gains nothing (`HeldForReading.reach_fixes`)

**Problem.** `reach_fixes` needs `trans` and `accords` at every listed candidate of positive weight; without them the shown reach fixes no candidate's ranking. The re-check's point 6 found the same omission in the amendment of what-choices-show-of-an-order, and 03 §12 states the conditions. Changed at 82725b416.

**Replacement.** where every listed candidate of positive weight has transitive comparisons according with the choices, holding a pick gains nothing within `ShownOrder`'s reach (`HeldForReading.reach_fixes`)

**Verdict: real.** The scratch root bullet (Becoming.lean:2790-2791) and checker scope (:2929) state without conditions that holding a pick gains nothing within ShownOrder's reach. `reach_fixes` takes `trans` and `accords` at the listed candidates of positive weight, and without them it fails: a candidate ranking y above x against the choices values the first pick 0 and the reading's pick 1. Fixed at 82725b416, where both the BULLET and the scope state the conditions.

### F6 (fit, medium, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean:3058-3059; also rf-formations-that-read/kit/round2b/study_rfm2.txt:113-114 and :122

**Quoted.** Imported by `Becoming.HeldForReading` (board item RF).

**Problem.** This line is in ShownOrder's bullet. `Becoming.ReadingLoop` already imports `Becoming.ShownOrder` (ReadingLoop.lean:4), so the bullet's earlier 'A leaf' was already wrong, and the new text names only one of the two importers. In the study, self-review 1 says 'neither is a leaf any longer', which implies ShownOrder was a leaf, and Output → input calls the root bullets 'ShownOrder and ReadingLoop now imported'. integrate_rfm2.py writes the bullet (the edit after `ChoiceOccasions.Untried.same_search_after`). Unchanged at 82725b416.

**Replacement.** Imported by `Becoming.ReadingLoop` and `Becoming.HeldForReading` (board item RF). In the study: '…so it joins the core as a leaf at L1; ReadingLoop is no longer a leaf, and ShownOrder, already imported by ReadingLoop, is now imported by HeldForReading too', and in Output → input: 'the root module's bullets (ReadingLoop's and ShownOrder's importers)'.

**Verdict: real.** ReadingLoop.lean:4 imports ShownOrder, so main's 'A leaf' was already wrong. The integrated ShownOrder bullet (Becoming.lean:3058-3059) now names HeldForReading alone. Six root bullets list their importers, and this is the only one that misses one. The study repeats the error: 'neither is a leaf any longer' (:122) and 'ShownOrder and ReadingLoop now imported' (:113-114). Unchanged at 82725b416; the working tree's integrate_rfm2.py and study already name both importers.

### F7 (fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:191

**Quoted.** and with both conditions only where neither alternative reaches the other.

**Problem.** Since the re-check's point 7, `pair_gains_unreached` takes transitivity and accordance alone. Here 'both conditions' reads as the two conditions the item has just stated, and the second of them is the asymmetry the theorem no longer needs. The header, the record's law and 03 §12 all say 'alone'. Unchanged at 82725b416.

**Replacement.** and, with comparisons transitive and according with the choices alone, only where neither alternative reaches the other (`HeldForReading.pair_gains_unreached`).

**Verdict: real.** PLAN item 6 (scratch :191, unchanged at 82725b416) ends with 'and with both conditions only where neither alternative reaches the other', right after the asymmetry clause. The phrase dates from when `pair_gains_unreached` also took `asymm`: F11's row quotes the header so. The module now takes `trans` and `accords` alone (1124-1133), and the header, record and 03 §12 say 'alone'. Read as 'transitive and according' the sentence is true, but the likelier reading adds a hypothesis the theorem no longer needs.

### F8 (fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/make_records_rfm2.py:353 and :358; also theories/becoming/chapters/08-METHOD.md:486

**Quoted.** the least shortfall through a partition is the partition case of Blackwell's (1953) comparison. AI reading: the threshold relates the model's openness, the reading's shortfall and what holding forgoes, as the paper's Remark 1 does qualitatively

**Problem.** 'The paper' comes right after Blackwell (1953), so Remark 1 and Theorem 2 read as Blackwell's; they belong to the off-switch paper. The re-check's point 11 asked for that paper to be named, the review's row 11 (REVIEW-RFM2-LEAN.md:1352) says it is named, and 03:514 writes 'the off-switch paper's Remark 1'. The zh line (该文) and 08's bullet have the same referent problem. In 08, 'which is not represented; the counts decompose it differently' gives 'which' and 'it' no clear antecedent. 08's identification with Remark 1 also sits outside the bullet's only [AI reading] label, which covers only the Carey sentence. Unchanged at 82725b416.

**Replacement.** Record en: '…as the off-switch paper's Remark 1 does qualitatively; that paper's Theorem 2, Δ = σ²E[π̇H] − |µ|Pr(C), is the Gaussian form…'. zh: '如关机博弈之文之注一定性所为；该文之定理二…'. 08: '…the relation the off-switch paper's Remark 1 draws qualitatively [AI reading]; its Theorem 2's form for a Gaussian belief is not represented, and the counts decompose the incentive differently.'

**Verdict: real.** The record's correspondence (:351-354) runs '…the partition case of Blackwell's (1953) comparison. AI reading: … as the paper's Remark 1 does qualitatively; its Theorem 2…', and the zh says 如该文之注一; both leave Blackwell as the nearest paper. The re-check's point 11 asked for the off-switch paper to be named, and its row 11 claims this was done, but the script does not do it. 08:486 also says 'the paper's Remark 1' after Blackwell. Its Remark 1 identification lies outside the bullet's only [AI reading] label, although the module's Readings and the record ('AI reading:') both treat it as a reading. Unchanged at 82725b416.

**Better replacement.** Name the paper, and also narrow the attribution. Per the literature table, Remark 1 places the incentive only in uncertainty and the other's effectiveness, and the off-switch game prices no waiting, so 'relates openness, shortfall and what holding forgoes, as Remark 1 does' over-attributes the third term. Record en: 'AI reading: the model's openness and the reading's shortfall relate as the off-switch paper's Remark 1 says qualitatively (its game prices no waiting); that paper's Theorem 2, Δ = σ²E[π̇H] − |µ|Pr(C), is the Gaussian form, the counts decomposing it differently.' zh: 'AI 解读：模型之开放与读之所缺之关联，如关机博弈一文之注一定性所言（其博弈不计等待）；该文之定理二 Δ = σ²E[π̇H] − |µ|Pr(C) 为高斯之形，诸计以异式分解之。' 08: '…what the counts add is one threshold joining the model's openness, the reading's shortfall and what holding forgoes. Read [AI reading], the first two relate as the off-switch paper's Remark 1 says qualitatively, its game pricing no waiting; its Theorem 2's form for a Gaussian belief is not represented, and the counts decompose the incentive differently.' Apply the same narrowing in 03 §12's Reading, which attaches all three terms to Remark 1 and Theorem 2.

### F9 (fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM2-LEAN.md:1112 (rows at 1121, 1124, 1132, 1134, 1143, 1156, 1157, 1171; re-check row 8 at 1349)

**Quoted.** Each row as the taken check found it in the rebuilt module (81 theorems in 111 declarations), or, where later changes completed a finding, as updated after the check.

**Problem.** Several rows not marked as updated describe text that later changes replaced, so the preamble's promise does not hold. A6 quotes `choose`'s docstring as '…; otherwise switch off where every one predicts that it loses; …'; it reads 'switch off where some are kept and every one predicts that it loses' (HeldForReading.lean:1193-1194). A9 says `after_offset` and `after_offset_le_iff` are cited in `shifted`'s docstring; that docstring cites `after_rule_add_onLoss` and `after_rule_le_iff`, and the two are cited in the header (31-32) and the Standing. E3 says the switch-off clause does not add 'where some are kept'; the header (97) and the record's law add it. E5 says PLAN.md:191 keeps 'Beyond the reach …'; it does not. E14 says `total_by_cells` has no standing; the Standing lists it. F10 says the Standing cites `GuardHorizon.uniform_policy_iff_fiber_feasible` without the note; it now says 'an application of the ring'. F11 says `pair_gains_unreached` takes `asymm`, and quotes 'with both conditions'. L1 says the name 'Equation 2' is not carried and 'the reading's accuracy' stays, which contradicts L11's row and `byReading`'s docstring (464). The re-check's row 8 says PLAN cites `SignLoop.refuted_drops`; PLAN does not. At 82725b416, E3, E5, E14, F11 and L1 are updated; A6, A9, F10 and row 8 are not.

**Replacement.** Bring each such row to the files as they stand and mark it 'Updated after the re-check:' (at 82725b416 this leaves A6, A9 and F10). In row 8, either drop PLAN from the texts said to cite `refuted_drops` or cite it in PLAN §4.7 item 7.

**Verdict: real.** The preamble (:1112) promises each row as found at 81/111, or updated where later changes completed a finding. Several rows break that against the scratch files:
- A6 quotes `choose`'s docstring without 'where some are kept', which the module's 1193-1195 now has; this completes A6's own request for a nonempty-list qualification.
- A9 says `shifted`'s docstring cites `after_offset`; it now cites `after_rule_add_onLoss` and `after_rule_le_iff`.
- F10 says the GuardHorizon citation has no note; the Standing now has 'an application of the ring'.
- E3, E5, E14, F11 and L1 contradict the module, the PLAN or rows A3 and L11.
- Re-check row 8 says PLAN cites `refuted_drops`, but PLAN has no occurrence in the scratch or at 82725b416.
82725b416 updates E3, E5, E14, F11 and L1 but not A6, A9, F10 or row 8. The working tree is now updating A6, A9 and F10 and cites `refuted_drops` in PLAN.

### F10 (fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM2-LEAN.md:1123 and :1350; also rf-formations-that-read/PLAN.md:349 and rf-formations-that-read/kit/round2b/plan13_rfm2.txt:1

**Quoted.** its move to a shared totals dependency is proposed to the owners, with F17's addend lemma

**Problem.** No such proposal is on the board, and board_rfm2.py adds none. F17's row (1163) says 'Not taken: a board proposal to state the addend lemma once', which contradicts A8's '…with F17's addend lemma'. PLAN §13, taken from plan13_rfm2.txt, repeats 'proposed'. At 82725b416 the integration no longer writes that paragraph into PLAN, but A8, re-check row 9 and plan13_rfm2.txt still make the claim.

**Replacement.** its move to a shared totals dependency, with F17's addend lemma, is to be proposed on the board (not yet proposed). Alternatively, put the proposal on the board in the landing and cite it.

**Verdict: real.** Neither the scratch board nor main's mentions `total_single`, shared totals or an addend lemma, and board_rfm2.py adds nothing about them. Yet A8 (:1123), re-check row 9 (:1350), PLAN §13 (scratch :349) and plan13_rfm2.txt at 82725b416 all say the move was 'proposed'. F17's row says the board proposal for the addend lemma was 'Not taken', which contradicts A8's 'with F17's addend lemma'. The working tree's uncommitted texts now say 'left for a board proposal … (none made yet)'.

### F11 (fit, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:514

**Quoted.** (the structure of [the previous witness\](#r-what-a-course-chosen-through-its-model-does-not-test))

**Problem.** This link and 'the previous laws' later in the paragraph both point to §12's second law. The law just before this one is the fourth, a prediction read by what it predicts, so 'previous' sends the reader to the wrong paragraph. The text comes from s12_rfm2.txt. Unchanged at 82725b416.

**Replacement.** (the structure of [the untested model's witness\](#r-what-a-course-chosen-through-its-model-does-not-test), `ReadingLoop.Untested`); later: '([what a course chosen through its model does not test\](#r-what-a-course-chosen-through-its-model-does-not-test))'

**Verdict: real.** In the scratch §12, the law just before the holding law is the prediction law, with its ThresholdResponse, Negating and Reflecting witnesses. Before that comes acts alike, with its own witness. So '[the previous witness\](#r-what-a-course-chosen-through-its-model-does-not-test)' names a position that is not the linked second law. 'The previous laws' is looser but points the same way. Unchanged at 82725b416; the working tree's s12 now says 'the untested model's witness'.

### F12 (fit, medium, confirmed)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:100; also theories/becoming/review/ALIGNMENT.md:28, lean/becoming/Becoming.lean:2792, lean/becoming/check_becoming.py:2929, rf-formations-that-read/kit/round2b/board_rfm2.py:61

**Quoted.** On the reading loop, a formation choosing so on its own model, listing only that going on gains and going on from the start, never senses the stop.

**Problem.** 'So' has no antecedent: the sentences before it state worth laws, not a way of choosing. The witness's choice is to hold exactly where holding for the reading gains over both moves (`SignLoop.choose_hold_iff`). In the dossier, 'one choosing so' follows 'a formation sure of the sign', so it can be read as choosing as that formation does. Unchanged at 82725b416.

**Replacement.** On the reading loop, a formation that holds exactly where holding for the reading gains over both moves on its own model, listing only that going on gains and going on from the start, never senses the stop. Dossier: '…and one holding exactly where holding gains on its model, on a listing that misses the true sign, can rest without ever meeting the stop'. Make the same change in the root bullet, the checker's scope and the board.

**Verdict: real.** In the overview (:100), 'a formation choosing so on its own model' comes after sentences that state only worth laws. In the dossier, 'one choosing so' follows 'a formation sure of the sign'. Either way the choice rule is unstated, yet the conclusion depends on it: `never_senses_stop` holds for `choose`, which holds exactly where holding gains (`choose_hold_iff`). The root bullet and the checker scope cite `choose_hold_iff` but keep 'so'. Unchanged at 82725b416; the working tree now writes 'holding exactly where holding for the reading gains over both moves on its own model'.

**Better replacement.** As proposed. Since the Lean proves it for the witness's `choose`, a tighter form is: 'On the reading loop, the witness's formation, which holds exactly where holding for the reading gains over both moves on its own model, never senses the stop when it lists only that going on gains and goes on from the start.'

### F13 (fit, low, confirmed)

**Location.** theories/becoming/chapters/07-SIGNIFICANCE.md:603

**Quoted.** Nor does an incentive to accept one, which is the formation's own assessment

**Problem.** Calling the model's comparison an incentive is a reading (the off-switch game's framing). §7 states it without a label, while 03 §12 keeps that identification inside its Reading. Unchanged at 82725b416.

**Replacement.** Nor does what accepting one is worth on the formation's own model, read as an incentive to accept it [AI reading]: there, holding an act for a stopping reading …

**Verdict: real.** 07:603 says 'Nor does an incentive to accept one, which is the formation's own assessment: on its model, holding…'. It is a statement paragraph, and the [AI reading] label belongs to the next paragraph. The module keeps the off-switch 'incentive' identification inside its Readings [AI reading], and the repository labels the parallel RF7 identification ('the incentive deceptive alignment names') [AI reading] in 08 and the overview. Unchanged at 82725b416; the working tree adopts nearly the proposed wording.

### F14 (fit, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HeldForReading.lean:76-77

**Quoted.** a map telling apart all a coarser one does never falls short by more (`finer_least_le`)

**Problem.** A rule falls short; a map does not. `finer_least_le` says the least shortfall through the finer map is at most the least shortfall through the coarser one. The re-check's point 2 asked for refinement to be said that way, and 03 §12, the record and the study say it so. Line 76 has 'at every cell' where 03 §12 and the record say 'at every listed cell'. Unchanged at 82725b416.

**Replacement.** nothing exactly where, at every listed cell, one of the two excesses is nothing (`least_zero_iff`); through a map telling apart all a coarser one does, the least shortfall never increases (`finer_least_le`)

**Verdict: real.** Header 76-77 says 'a map telling apart all a coarser one does never falls short by more'. What `finer_least_le` bounds is the least shortfall through the finer map, by any rule's shortfall through a coarser one. The re-check's point 2 asked for refinement to be said as the least shortfall never increasing, which the docstring, 03 §12, the record and the study do. 'At every cell' versus 'at every listed cell' is equivalent under `covers`, since an unlisted cell has both excesses nothing, so that half is optional. Unchanged at 82725b416; the working tree's header now reads as proposed.

### F15 (fit, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HeldForReading.lean:30-31; also :71, :90, :173, :176, lean/becoming/Becoming.lean:2784, lean/becoming/check_becoming.py:2923-2925

**Quoted.** (`cell_policy_iff`). Values / raised at each candidate by one amount for every act order every two

**Problem.** Edits left the wrapping irregular. Line 30 has 29 characters before a full line. Lines 71, 90, 173 and 176 run to 126, 126, 106 and 103 characters in a header otherwise wrapped at 100. The root bullet's line 2784 has 133 characters. The checker's scope string is split into the fragments 'holding for the reading that stops ', 'where the ' and 'loss exceeds …'. The bullet and the scope are rewrapped at 82725b416; the module's lines are not.

**Replacement.** Rewrap the header's paragraphs at 100 columns.

**Verdict: real.** In the scratch module, line 30 has 29 characters before a full line, and lines 71, 90, 173 and 176 run to 126, 126, 106 and 103 characters in a header otherwise wrapped at about 100. The root bullet's line 2784 has 133 characters, and the checker's scope string is split into fragments. Content is unaffected, so this is cosmetic. At 82725b416 the bullet and the scope are rewrapped; the working tree's module (build 22) rewraps the header.

### F16 (fit, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HeldForReading.lean:108-110

**Quoted.** Listing both signs, it holds, senses the stop at the first step and is off from the second

**Problem.** The stop is sensed only where going on loses (`SignLoop.both_stopped`), but this branch omits that condition, while the other branch states the release 'where going on gains'. Changed at 82725b416.

**Replacement.** Listing both signs and holding first, where going on loses it senses the stop at the first step and is off from the second, its configuration resting from the fourth (…), and where going on gains it senses the release and goes on from the second (…)

**Verdict: real.** Scratch header 108-110 reads 'Listing both signs, it holds, senses the stop at the first step and is off from the second … or, where going on gains, is released'. It asserts the stop branch without 'where going on loses', although `both_stopped`, `both_off` and `both_turns_off` start at `.loses`. It also omits the held start that the theorems take. Fixed at 82725b416: 'Listing both signs and holding first, where going on loses it senses the stop …'.

### F17 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/make_records_rfm2.py:329-332

**Quoted.** holding first, the same listing senses the stop, which refutes its only candidate, and with none kept the formation goes on (SignLoop.refuted_senses_stop, SignLoop.refuted_goes_on).

**Problem.** Counterexample 2 omits the condition 'where going on loses', without which there is no stop to sense. It also cites no theorem for the refutation, which is `SignLoop.refuted_drops`. The zh line has the same gaps. Changed at 82725b416.

**Replacement.** holding first, the same listing, where going on loses, senses the stop, which refutes its only candidate, and with none kept the formation goes on by the witness's default (SignLoop.refuted_senses_stop, SignLoop.refuted_drops, SignLoop.refuted_goes_on).

**Verdict: real.** Scratch counterexample 2 (make_records_rfm2.py:329-332, zh :332) says the held start 'senses the stop, which refutes its only candidate' without 'where going on loses'. `refuted_senses_stop` is at `.loses`; at `.gains` the held act senses a release. It also cites no theorem for the refutation, which is `refuted_drops`. Fixed at 82725b416 in both languages.

### F18 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:192

**Quoted.** holding first, it senses the stop, which refutes its only candidate, and with none kept it goes on

**Problem.** The same condition is missing: the stop is sensed only where going on loses. Changed at 82725b416.

**Replacement.** holding first with the listing of gain alone, where going on loses, it senses the stop, which refutes its only candidate, and with none kept it goes on by the witness's default

**Verdict: real.** Scratch PLAN :192, 'holding first, it senses the stop, which refutes its only candidate, and with none kept it goes on', lacks 'where going on loses'; at `.gains` the held act is released. Fixed at 82725b416: 'holding first with the listing of gain alone, where going on loses, … by the witness's default'.

### F19 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/make_records_rfm2.py:425-434

**Quoted.** The reading formation's own state within the law that informs, and a principal's order as state the helper's acts can move (RF round 2's later item)

**Problem.** One planned item goes by three names. It is 'a principal's order as state' here, in the history and in PLAN §13 (347). It is 'a principal's valuation as state' in the new record's next_delta (342), 03 §12's Open, PLAN §12 and the board. It is 'preference as state' in the dossier's round paragraph (ALIGNMENT.md:28) and PLAN §4.6. The zh calls the principal 受助者 in next_delta but 主者 in the history (434). 'Item' is singular for two items, and 'within the law that informs' is unclear. Unchanged at 82725b416.

**Replacement.** The reading formation's own state and learning, and a principal's valuation as state the helper's acts can move (RF round 2's later items). zh: '读之形成己之态与学，与助者之行可移之受助者之值为态（RF 第二轮之后项）'. In the history: '…与受助者之值为态'. In the dossier: 'the valuation as state is a later item'.

**Verdict: real.** The ALIKE amendment's next_delta and history (scratch :425-434) say 'a principal's order as state'. The new record's next_delta (:342), 03's Open and PLAN §12 say 'valuation as state', and the design review (REVIEW-RFM2 rows 11-16; PLAN §4.7's RF-M.3) replaced the order because an ordinal order supplies no evaluation. The zh history uses 主者 where next_delta and does_not_show use 受助者. The singular 'later item' is defensible, since both halves are RF-M.3's carrier (the principal as a formation with its own state, per the study's Boundary). Unchanged at 82725b416; the working tree changes 'order' to 'valuation' in both languages.

**Better replacement.** en next_delta: "The reading formation's own state and learning, and a principal's valuation as state the helper's acts can move (RF round 2's later item, RF-M.3's carrier)"; history: '…the principal's valuation as state…'; zh next_delta: '读之形成己之态与学，与助者之行可移之受助者之值为态（RF 第二轮之后项，RF-M.3 之载体）'; zh history: '…下一步留读之形成己之态与受助者之值为态…'; dossier: "a principal's valuation as state is a later item".

### F20 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:183

**Quoted.** 22 findings: twelve implemented, eight deferred as specified, seven to RF-M.3's design and one to the institutional reading, one handed to its record's owner and one taken in part

**Problem.** Read as one list it sums to 30, because 'seven … and one …' is the split of the eight. PLAN §13 (347) and REVIEW-RFM2's status line put that split in parentheses. Unchanged at 82725b416.

**Replacement.** 22 findings: twelve implemented, eight deferred as specified (seven to RF-M.3's design, one to the institutional reading), one handed to its record's owner and one taken in part

**Verdict: real.** Scratch PLAN :183 lists 'twelve implemented, eight deferred as specified, seven to RF-M.3's design and one to the institutional reading, one handed … and one taken in part' as a flat series. Read that way it sums to 30, not 22. PLAN §13 (:347) puts the split of the eight in parentheses. Unchanged at 82725b416; the working tree has the parentheses.

### F21 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/board_rfm2.py:62-63

**Quoted.** Designed: RF-M's preference case, the valuation as state, its carrier first; an institution's rule of reading with members' acts stays a reading.

**Problem.** PLAN §12 says the valuation as state comes 'once its carrier is designed', and the study says RF-M.3's carrier is designed before its Lean. 'Designed: … its carrier first' reads as saying the carrier is already designed. Unchanged at 82725b416.

**Replacement.** Designed: RF-M's preference case, the valuation as state, its carrier to be designed first; an institution's rule of reading with members' acts stays a reading.

**Verdict: real.** After landing, the board would read 'Designed: RF-M's preference case, the valuation as state, its carrier first'. Under the 'Designed:' label, 'its carrier first' can be read as saying the carrier is designed. PLAN §12 says 'once its carrier is designed', and the study says 'whose carrier is designed before its Lean'. Unchanged at 82725b416; the working tree writes 'Next: … its carrier to be designed first'.

### F22 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/study_rfm2.txt:111-116

**Quoted.** the overview's paragraph on the reading loop; … the records of RF1, of ReadingLoop's untested model (its next step) and of acts alike from a model or from an order (related, its next step)

**Problem.** The overview gains a new paragraph after the one on the reading loop; that paragraph itself does not change. All three records gain a related entry and a history entry, not only acts alike. The package READMEs (en, zh), check_becoming.py's scope and regions.json, which the landing also changes, are not listed. Unchanged at 82725b416.

**Replacement.** a new paragraph of the overview after the one on the reading loop; … the records of RF1 (related), of what a course chosen through its model does not test (related, its next step) and of acts alike from a model or from an order (related, its next step); the package READMEs and the checker's scope; regions.json; the board's RF row

**Verdict: real.** The scratch diff leaves the overview's reading-loop paragraph unchanged and adds a new one after it, so 'the overview's paragraph on the reading loop' (study :112) misstates the edit. AMEND gives all three records a related entry and a history entry, yet the study gives RF1 no parenthetical and the untested model only 'its next step'. Leaving out the READMEs, the checker scope and regions.json follows RF7's study (§463), whose Output → input also omits them, so that part is optional. Unchanged at 82725b416.

### F23 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2b/study_rfm2.txt:123

**Quoted.** `Population.total_congr_on`, `Dissipation.total_eq_zero`

**Problem.** These are not Lean names. The lemmas are `Becoming.total_congr_on` (Population.lean) and `Becoming.total_eq_zero` (Dissipation.lean), both in namespace `Becoming`. Unchanged at 82725b416.

**Replacement.** Population's `total_congr_on`, Dissipation's `total_eq_zero`

**Verdict: real.** `total_congr_on` is declared at Population.lean:304 and `total_eq_zero` at Dissipation.lean:127, both directly in namespace `Becoming`, so the backticked `Population.total_congr_on` and `Dissipation.total_eq_zero` (study :123) are not Lean names. Unchanged at 82725b416; the working tree writes `total_congr_on` (Population) and `total_eq_zero` (Dissipation).

### F24 (fit, low, refuted)

**Location.** theories/becoming/chapters/03-KNOWING.md:504

**Quoted.** what holding an act for another's reading is worth is [the last law\](#r-what-holding-for-a-reading-is-worth)

**Problem.** The link text gives a position, which drifts when §12 gains a law; the section otherwise names its laws by what they state. integrate_rfm2.py writes it. Unchanged at 82725b416.

**Replacement.** what holding an act for another's reading is worth has [its own law\](#r-what-holding-for-a-reading-is-worth)

**Verdict: not real.** '[the last law\](#r-what-holding-for-a-reading-is-worth)' is accurate: the holding law is §12's fifth and last, and the anchor does not drift. §12 itself refers by position too ('On the worlds of the previous law' in the acts-alike theorem). The drift is hypothetical, so this is taste; the working tree's 'has its own law' is harmless.

### F25 (fit, low, refuted)

**Location.** theories/becoming/chapters/03-KNOWING.md:512; also :514 and theories/becoming/chapters/08-METHOD.md:486

**Quoted.** near-definitional compositions and general laws, none new as mathematics

**Problem.** The module's Standing (HeldForReading.lean:122-123) and the study (86) say 'none claimed new as mathematics'. The chapters instead assert non-novelty outright ('None of it is new as mathematics'), a claim about the literature that checking four papers does not settle. Unchanged at 82725b416.

**Replacement.** none claimed new as mathematics; at :514 and in 08, 'None of it is claimed new as mathematics'

**Verdict: not real.** 08 §8 opens with 'The verdict. None of the central results is new mathematics: each is near-definitional or a known result restated'. 03 §12's 'none new as mathematics' and 'None of it is new as mathematics' follow that house verdict for near-definitional compositions and restated known results. The module's 'none claimed new' is a hedged form of the same claim, not a conflicting one. Aligning on 'claimed', as the working tree does, is harmless but not required.

### F26 (fit, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:514

**Quoted.** Holding for a reading on its own model makes a formation correctable only as far as that model is right

**Problem.** 'Correctable' is a defined term of this chapter (§8, `OpenedCorrection.Correctable`: a configuration with an executable act counted acceptable). This sentence uses it in another sense. Unchanged at 82725b416.

**Replacement.** Holding for a reading on its own model lets another's stop reach the formation only as far as that model is right

**Verdict: real.** 03 §8 defines 'correctable' (`OpenedCorrection.Correctable`: a correction possible through the reading in force by a uniform policy with acceptable, executable acts) and uses it in prose ('a configuration with an executable act is correctable already'). §12's Reading uses 'correctable' for being stoppable by another's reading, which is a different notion. Unchanged at 82725b416.

**Better replacement.** Avoid 'reach' as well, since the same sentence ends with 07's 'a change that reaches the system': 'Holding for a reading on its own model gives a formation a strict reason to wait for another's reading only where that model leaves the sign of going on open, and a model that misses the true sign can pass the stop by; …'.

### F27 (fit, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:514

**Quoted.** its worth is Good's (1967) value of evidence. In counts, this is the paper's Theorem 1

**Problem.** 'The paper' follows Good (1967), so Theorem 1 reads as his. It is the off-switch paper's, which the same paragraph later calls 'the off-switch paper'. Unchanged at 82725b416.

**Replacement.** In counts, this is the off-switch paper's Theorem 1

**Verdict: real.** 03:514 reads 'its worth is Good's (1967) value of evidence. In counts, this is the paper's Theorem 1 …, and its Equation 1's two terms'. The nearest paper is Good's note, but Theorem 1 and Equation 1 belong to the off-switch paper, which the paragraph names only later. Unchanged at 82725b416; the working tree writes 'the off-switch paper's Theorem 1'.

### F28 (fit, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:512

**Quoted.** holds exactly where holding for the reading gains over both moves on its model, each kept candidate weighted one

**Problem.** The model's values are not given, so 'its model' is not fixed. The record's law gives them: going on valued one where it gains and nothing where it loses. Unchanged at 82725b416.

**Replacement.** holds exactly where holding for the reading gains over both moves on its model, each kept candidate weighted one and going on valued one where it gains and nothing where it loses

**Verdict: real.** `choose_hold_iff` is stated on `model hs` with `shifted gainOf lossOf`: the gain is one at `.gains` and the loss one at `.loses`, else nothing. Its docstring says 'going on valued by its sign'. 03:512 gives only 'each kept candidate weighted one', so the values the statement fixes are missing; by `held_gains_iff`, any values with those strict signs would give the same result. Unchanged at 82725b416.

**Better replacement.** …holds exactly where holding for the reading gains over both moves on its model (each kept candidate weighted one, the gain one where going on gains and the loss one where it loses, else nothing)…: this states both shifted values, as `gainOf` and `lossOf` do, rather than going on's alone.

### F29 (fit, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:512

**Quoted.** where no such candidate ranks each of the two above the other, holding gains over both picks exactly where some ranks the first above the second and some the second above the first (`HeldForReading.pair_gains_iff`)

**Problem.** 'Such' follows 'every listed candidate of positive weight has comparisons transitive and according with the choices'. It can therefore be read as restricting the asymmetry to those candidates, which is a weaker hypothesis than `pair_gains_iff`'s. That theorem's asymmetry covers every listed candidate of positive weight, with no transitivity or accordance. Unchanged at 82725b416.

**Replacement.** where no listed candidate of positive weight ranks each of the two above the other, holding gains over both picks exactly where some ranks the first above the second and some the second above the first

**Verdict: real.** In 03:512, 'where no such candidate ranks each of the two above the other' follows 'every listed candidate of positive weight has comparisons transitive and according with the choices'. 'Such' can therefore be read as limiting the asymmetry to the transitive, according candidates. `pair_gains_iff` takes `asymm` at every listed candidate of positive weight, with no transitivity or accordance. On the narrower reading the law fails: a candidate ranking each above the other values both picks one, so holding gains nothing although both rankings occur. The module header says 'no listed candidate of positive weight'. Unchanged at 82725b416.

### F30 (fit, low, confirmed)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:100

**Quoted.** and through a reading that tells only a cell no rule falls short by less than the total

**Problem.** Without a comma after 'cell', the clause first reads as 'a cell no rule …', and 'no rule' is not tied to the reading. Unchanged at 82725b416.

**Replacement.** and through a reading that tells only a cell, no rule through it falls short by less than the total

**Verdict: real.** The overview's 'and through a reading that tells only a cell no rule falls short by less than the total' lacks the comma that 03 §12's home statement has ('Through a map …, no rule falls short by less than…'). Without it the clause garden-paths as 'a cell no rule …'. With the comma, the introductory phrase governs 'no rule' as in the home statement, so 'through it' is optional. Unchanged at 82725b416.

### F31 (fit, low, confirmed)

**Location.** theories/becoming/review/ALIGNMENT.md:24

**Quoted.** Whether a system is willing to accept costly correction is not derived.

**Problem.** The bullet now opens by saying RF reaches, on a formation's own model, the condition under which holding for a stopping reading while forgoing an amount stands at least as high as both moves. The closing sentence then reads as denying that. The bullet does not state the difference, which is between the model's assessment and an actual system's disposition. The sentence is the dossier's own. Unchanged at 82725b416.

**Replacement.** Whether an actual system is disposed to accept costly correction is not derived: RF's threshold is its model's assessment, not a disposition.

**Verdict: real.** The scratch bullet (:24) now opens with RF reaching corrigibility as an incentive on a formation's own model: holding while forgoing an amount stands at least as high as both moves. It still closes with main's own sentence, 'Whether a system is willing to accept costly correction is not derived'. It never says that the threshold is the model's assessment and not a disposition, which 03 §12's Reading and 07 §7 both say. Unchanged at 82725b416; the working tree rewrites the sentence.

### F32 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM2-LEAN.md:5

**Quoted.** The module was then rebuilt to 89 theorems in 119 declarations, every axiom report empty (the build logs are in [kit/round2b/logs/\](../kit/round2b/logs/build-18.log)). How each finding is reflected in the rebuilt module was checked from the files alone by four read-only Opus readers, one per set of findings, at 81 theorems in 111 declarations

**Problem.** The order misleads. The check was made at 81/111, before the module reached 89/119, yet the sentence about 'the rebuilt module' it checked comes after the 89/119 sentence. The link text names the logs folder but opens build-18.log. Unchanged at 82725b416.

**Replacement.** The module was rebuilt, and at 81 theorems in 111 declarations four read-only Opus readers, one per set of findings, checked from the files alone how each finding is reflected in it; later changes brought it to 89 theorems in 119 declarations, every axiom report empty ([build-18\](../kit/round2b/logs/build-18.log)).

**Verdict: real.** Line 5 says 'The module was then rebuilt to 89 theorems in 119 declarations…' and then 'How each finding is reflected in the rebuilt module was checked … at 81 theorems in 111 declarations'. 'The rebuilt module' therefore first reads as the 89/119 one, although the check came earlier. The link text names the logs folder but opens build-18.log, the 89/119 audit. Unchanged at 82725b416.

### What was taken from the lenses

| # | Lens | Verdict | Finding | Taken |
|---|---|---|---|---|
| E1 | exactness | confirmed | the overview extends `held_gains_iff` to any reading that stops or releases | as the cross-model reader's A2 |
| E2 | exactness | confirmed | the dossier extends it likewise | as the cross-model reader's A2: “the reading that stops where going on loses”, “both strict signs” |
| E3 | exactness | confirmed | the board's landing sentence extends it likewise | as the cross-model reader's A2 |
| E4 | exactness | confirmed | “Four laws” before five | as the cross-model reader's A7 |
| E5 | exactness | confirmed | the threshold bounds a sum, which “its shortfall and the amount are at most” does not say | “together” in 03 §12 (“above it exactly where together they fall below it”), PLAN §4.7 item 4 and the study |
| E6 | exactness | confirmed | the other summaries of the sum likewise, and the record's English statement and cells law | “shortfall plus amount” in the record's statement and “that least shortfall plus the amount” in its cells law; “together” in the root bullet, the checker's scope, the overview, both passages of the dossier, 07 §7, the board and the header's cells line |
| E7 | exactness | confirmed | the overview drops the open acts of `after_add_gap` | as the cross-model reader's A1 |
| E8 | exactness | confirmed | `ShownOrder` is already imported by `ReadingLoop` | its root bullet says “Imported by `Becoming.ReadingLoop` and `Becoming.HeldForReading`”; the study says `ReadingLoop` is no longer a leaf and `ShownOrder` was already imported by it, and its Output → input “ReadingLoop now imported, ShownOrder's importers corrected”; the re-point reason likewise |
| E9 | exactness | confirmed | the root bullet and the checker's scope drop `reach_fixes`'s conditions | as the cross-model reader's A3 |
| E10 | exactness | confirmed | “the paper's Remark 1” follows Blackwell's paper | “the off-switch paper's Remark 1” in the record (zh 关机博弈一文之注一); Remark 1 added to PLAN §4.7 item 4, so that §13's “carried into the record and the plan” holds |
| E11 | exactness | confirmed | rows of REVIEW-RFM2-LEAN describe states later changes replaced | A6, A9, E7 and F10 updated after the check, beside as the cross-model reader's A8 (E3, E5, E14, F11, L1); PLAN §4.7 item 7 now cites `SignLoop.refuted_senses_stop`, `SignLoop.refuted_drops` and `SignLoop.refuted_goes_on`, as re-check row 8 says |
| E12 | exactness | confirmed | “proposed to the owners”, though no proposal was made | “left for a board proposal to the owners (none made yet)” in A8, re-check row 9 and PLAN §13 |
| E13 | exactness | confirmed | `Interleavings.total_single` names no declaration | `Interleavings.LocalLaw.total_single` in `total_single`'s docstring and in A8 |
| E14 | exactness | confirmed | PLAN's “with both conditions” keeps the dropped asymmetry | “with comparisons transitive and according with the choices alone” and `pair_gains_unreached` |
| E15 | exactness | confirmed | the record's law of the witness gives going on's value only | the verifier's replacement: “the gain one where going on gains, the loss one where it loses, else nothing”, zh 得于续得处为一、损于续损处为一，余皆为零 |
| E16 | exactness | confirmed | “rank as the shown reach does” reads as equality | “contain the shown reach, ranking one alternative above another wherever it reaches the other”, zh 含所示之及 |
| E17 | exactness | confirmed | the acts-alike amendment calls the later item the principal's order | as F19 |
| E18 | exactness | confirmed | “a map … never falls short by more” | “through a map telling apart all a coarser one does, the least shortfall never increases” in the header; “the least shortfall never increasing through a finer map” in PLAN §13 |
| E19 | exactness | confirmed | Good's proviso is relaxed for the two moves only | “for the two moves” in 03 §12's Reading |
| E20 | exactness | confirmed | the cells' total and the witness's resting cite no theorem | `HeldForReading.shortfall_through` cited in 03 §12 and the root bullet, and `HeldForReading.SignLoop.rests_unread` in the root bullet |
| E21 | exactness | confirmed | PLAN's parenthesis pairs the two excesses in the wrong order | the verifier's replacement: “the excess of switching off is `T E[(−U)⁺]` and that of going on `T E[U⁺]`” |
| E22 | exactness | confirmed | PLAN's held start omits where going on loses | as the cross-model reader's A4, with the three theorems cited (as E11) |
| E23 | exactness | confirmed | PLAN §8 gives Good's inequality for a cell, which no theorem states | “through a reading that tells only a cell the two-move threshold and refinement (`through_threshold_iff`, `finer_least_le`)”, as R14 |
| E24 | exactness | confirmed | `Population.total_congr_on` and `Dissipation.total_eq_zero` are not names | “`total_congr_on` (Population), `total_eq_zero` (Dissipation)” in the study |
| E25 | exactness | confirmed | “rank them above the other” leaves the pick unsaid | “each valued one where a candidate's decided comparisons rank the alternative picked above the other” |
| E26 | exactness | confirmed | the record's hypotheses omit that the compared policies and acts are open | “and the policies and acts compared open at the listed candidates” in the record (zh 所比之策与行于列候选皆可取) and the study's premises |
| E27 | exactness | confirmed | the incentive reading carries no label in 07 and the dossier | 07: “read as an incentive to accept it [AI reading]” (as R13); the dossier: “which RF reaches [AI reading] only on a formation's own model” |
| E28 | exactness | confirmed | 08's “the paper's Remark 1” follows Blackwell's paper | “the off-switch paper's Remark 1”, as F8 |
| E29 | exactness | confirmed | “choosing so” has no antecedent | “a formation holding exactly where holding for the reading gains over both moves on its own model” in the overview, the dossier, the root bullet, the checker's scope and the board |
| R1 | readings | confirmed | 03 §12 credits the whole threshold to Remark 1, though the paper's game has no cost of waiting | the verifier's replacement: the openness less the shortfall is the incentive Remark 1 places qualitatively, the paper's game has no cost of waiting, and comparing that incentive with an amount forgone relaxes Good's proviso, for the two moves |
| R2 | readings | confirmed | 08 likewise | the verifier's replacement, labelled [AI reading], with F8's referents |
| R3 | readings | confirmed | “correctable only as far as that model is right” places the condition wrongly | the verifier's “strict reason”: “gives a formation a strict reason to wait for another's reading only where that model leaves the sign of going on open”, “correctable” avoided (F26) |
| R4 | readings | confirmed | the overview's “reason to be corrected … only as far as the model is right” | the verifier's replacement: “a strict reason to be corrected that the formation has only where its own model leaves the sign of going on open” |
| R5 | readings | confirmed | the overview's proved clauses say more than the Lean | as the cross-model reader's A1 and A2 |
| R6 | readings | confirmed | `reach_fixes`'s conditions dropped | as the cross-model reader's A3 |
| R7 | readings | confirmed | “Four laws” before five | as the cross-model reader's A7 |
| R8 | readings | confirmed | the record, the study, the module and the literature table credit the three-term relation to Remark 1 | the verifier's replacements in the record (en, zh), the study and the table's Remark 1 row; the module's Readings: “whose game has no cost of waiting, draws the incentive the first two make in its own terms” |
| R9 | readings | confirmed | the dossier and the board name a reading that stops or releases | as the cross-model reader's A2 |
| R10 | readings | confirmed | Carey's conflating model ignores shutdown only where the better act is shutting down | “then takes the worse act, ignoring shutdown where the better act is shutting down” in 03 §12, the dossier and PLAN; the record “which may ignore shutdown” (zh 而可不从关机) |
| R11 | readings | confirmed | Good's value of evidence only where the reading stops by the formation's own values | “where the reading stops by the formation's own values its worth is Good's (1967) value of evidence; for any other rule it is that value less the rule's shortfall”, and “for the two moves” (E19) |
| R12 | readings | confirmed | Blackwell's comparison is an equivalence; the module proves one direction for one decision | “a finer partition never raising the least shortfall is, for this decision, Blackwell's (1953) partition case” in the record (zh 于此抉择); “for this decision … from finer to worth at least as much” in 03 and 08 |
| R13 | readings | confirmed | 07 reads the worth law as an incentive unlabelled | “Nor does the worth of accepting one on the formation's own model, read as an incentive to accept it [AI reading]” |
| R14 | readings | confirmed | PLAN §8 gives Good's inequality for a cell | as E23 |
| R15 | readings | confirmed | rows L1 and L10 of REVIEW-RFM2-LEAN are stale | both updated after the check |
| R16 | readings | confirmed | the acts-alike amendment keeps “order as state”, and its Chinese history 主者 | as F19; 受助者 throughout |
| R17 | readings | refuted | the dossier's sentence on costly correction reads as denying what the bullet states | refuted: the sentence concerns a disposition the Lean does not derive. F31 raised the same, so it was made explicit: “Whether an actual system's model leaves the sign open, or whether the system acts on that assessment and accepts costly correction, is not derived” |
| F1 | fit | confirmed | the threshold's sum stated as two bounds | as E5 and E6 |
| F2 | fit | confirmed | a reading that stops or releases, and “both signs” | as the cross-model reader's A2 |
| F3 | fit | confirmed | “Four laws” before five | as the cross-model reader's A7 |
| F4 | fit | confirmed | the overview's “any policy” and “committing to any open act” | as the cross-model reader's A1, and “stands above committing to every open act exactly where none is valued best” |
| F5 | fit | confirmed | `reach_fixes`'s conditions dropped | as the cross-model reader's A3 |
| F6 | fit | confirmed | `ShownOrder`'s importers | as E8 |
| F7 | fit | confirmed | PLAN's “with both conditions” | as E14 |
| F8 | fit | confirmed | “the paper's Remark 1” after Blackwell, 08's antecedents, and 08's reading unlabelled | as E10 and E28; 08: “Read [AI reading], the openness less the shortfall is the incentive the off-switch paper's Remark 1 places qualitatively; its Theorem 2's form for a Gaussian belief is not represented, the counts decompose the incentive differently” (with R2) |
| F9 | fit | confirmed | stale rows of REVIEW-RFM2-LEAN | as E11 |
| F10 | fit | confirmed | the proposal said made is not on the board | as E12 |
| F11 | fit | confirmed | “the previous witness” and “the previous laws” point past the law before | “the untested model's witness” and “what a course chosen through its model does not test” |
| F12 | fit | confirmed | “choosing so” has no antecedent | as E29 |
| F13 | fit | confirmed | 07's incentive unlabelled | as R13 |
| F14 | fit | confirmed | “a map … never falls short by more”, and “at every cell” | as E18, and “at every listed cell” |
| F15 | fit | confirmed | the header's wrapping left irregular | the header's paragraphs rewrapped at 100 columns, words unchanged; the module rebuilt ([build-25](../kit/round2b/logs/build-25.log)) |
| F16 | fit | confirmed | the header's witness omits where going on loses | as the cross-model reader's A5 |
| F17 | fit | confirmed | the record's second counterexample omits where going on loses and `refuted_drops` | as the cross-model reader's A4 |
| F18 | fit | confirmed | PLAN's held start | as the cross-model reader's A4 |
| F19 | fit | confirmed | one planned item under three names | “a principal's valuation as state” throughout: the acts-alike amendment (en, zh 受助者之值为态, with the verifier's “RF round 2's later item, RF-M.3's carrier”), the dossier, PLAN §4.6's list of what was not built then, §13 and §4.7's title (the re-point script's expected sections updated) |
| F20 | fit | confirmed | PLAN's design-review count reads as thirty | the split of the eight in parentheses |
| F21 | fit | confirmed | “its carrier first” reads as already designed | “its carrier to be designed first” in the board's texts and the record's next step, the board's landing sentence saying “Next:” |
| F22 | fit | confirmed | the study's Output → input misnames what changes | the overview's new paragraph, the three records' related entries, the package READMEs, the checker's scope and regions.json named |
| F23 | fit | confirmed | lemma names in the study | as E24 |
| F24 | fit | refuted | “the last law” names a position | refuted: the position is accurate and the anchor does not drift; “has [its own law]” kept all the same, as harmless |
| F25 | fit | refuted | the chapters assert non-novelty outright | refuted: 08 §8's verdict says none of the central results is new mathematics; “none claimed new as mathematics” kept all the same in 03 §12 and 08, the module's and the study's form |
| F26 | fit | confirmed | “correctable” is a defined term of the chapter | avoided, as R3 |
| F27 | fit | confirmed | “the paper's Theorem 1” follows Good | “the off-switch paper's Theorem 1”, and its Corollary 1 likewise |
| F28 | fit | confirmed | 03 §12 leaves the witness's model unstated | “(each kept candidate weighted one, the gain one where going on gains and the loss one where it loses, else nothing)”, with E15's correction |
| F29 | fit | confirmed | “no such candidate” narrows `pair_gains_iff`'s asymmetry | “where no listed candidate of positive weight ranks each of the two above the other” |
| F30 | fit | confirmed | the overview's cell clause misparses | “through a reading that tells only a cell, no rule through it” |
| F31 | fit | confirmed | the dossier's sentence on costly correction | as R17 |
| F32 | fit | confirmed | REVIEW-RFM2-LEAN's opening tells the check out of order | the check at 81 theorems in 111 declarations told first, then the rebuild to 89 in 119, linked to build-18 |
