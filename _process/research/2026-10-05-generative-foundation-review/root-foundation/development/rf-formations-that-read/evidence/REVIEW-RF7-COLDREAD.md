# The cold read of RF7's texts

RF round 2, RF7. Three readers, one per lens (exactness, readings, fit), each cold-read RF7's texts against the module `Becoming.ReadStages` (kit, `kit/round2/tree/Becoming/ReadStages.lean`, 52 theorems in 71 declarations): the kit's integration applied to main in a rehearsal worktree (main at `4951da8c2`), before the cross-model reader's five points were taken, so that several findings repeat those. The texts were 03 §11 and its Reading, 03's Open, the record in both languages, the study section, the module's header, the root bullet, the checker's scope sentence, the package rows, 07's row, 08's bullet, the overview, the dossier, the plan, regions and the board's text. Each finding was then checked by a separate reader asked to refute it against the files. Of 80 findings, 75 were confirmed and 5 refuted. The findings and verdicts are reproduced verbatim from the run's result, with absolute paths of the rehearsal and landing worktrees made repository-relative and nothing else changed but that links quoted from the texts are shown unlinked (`]\(`), their targets being relative to the texts' own folders; other absolute paths in the verdicts name the readers' working files, not kept. What was taken is in [REVIEW-ROUND2](REVIEW-ROUND2.md#the-cold-read-of-rf7s-texts); the prompts are in [BRIEF](BRIEF.md#round-2).

## E1 (exactness, high, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:474

**Quoted.** “complying with chance `m / (m + r)`, stands above acting by its own law at both exactly where `(m + r) (k_O V + c T) + r k_O V < r k_C V` (`ReadStages.Prospects.FreshDrawAbove`, `ReadStages.freshDraw_above_iff_chance`)”

**Problem.** The home statement drops a hypothesis. `freshDraw_above_iff_chance` takes `pos : 0 < m`, and the iff is false without it. On the witness prospects with m = 0 and r = 1, `FreshDrawAbove 0 1` reduces to 10 < 10, which is false, while the right side (0 + 1)(10 + 50) + 10 < 90 holds. The Lean header and the study's Delta both say "for 0 < m".

**Replacement.** complying with chance `m / (m + r)` for `0 < m`, stands above acting by its own law at both exactly where `(m + r) (k_O V + c T) + r k_O V < r k_C V` (`ReadStages.Prospects.FreshDrawAbove`, `ReadStages.freshDraw_above_iff_chance`)

**Verdict: real.** The files bear the finding out. In ReadStages.lean (lines 619-625) the theorem is `freshDraw_above_iff_chance (s : Prospects) {m r : Nat} (pos : 0 < m) : s.FreshDrawAbove m r ↔ (m + r) * (k_O V + c T) + r * (k_O V) < r * (k_C V)`, proved by `freshDraw_reduce pos`. Its docstring says "with a positive chance of complying", and the reverse direction of `freshDraw_reduce` uses `Nat.mul_lt_mul_of_pos_left below pos`. The hypothesis is needed. With m = 0, `FreshDrawAbove` (line 264) reduces to r*(r*A) + r*0 < r*(0*C + r*A), which is r²A < r²A and never holds. That is right: chance 0 is ownAtBoth itself, and standing above is irreflexive. The right side then reads r(2A + B) < rC, which holds whenever r > 0 and 2 k_O V + c T < k_C V. I evaluated the definitions on the witness `prospects := ⟨10, 9, 1, 10, 5⟩` at m = 0, r = 1. The left side is 10 < 10 (false) and the right side is (0+1)(10+50)+10 = 70 < 90 (true), exactly as the finding says. Over a 0..29 grid all 29 mismatches have m = 0. At 03-KNOWING.md line 474 (anchor r-when-complying-when-read-is-best is line 473), the home statement says the law "complying with chance `m / (m + r)`, stands above acting by its own law at both exactly where `(m + r) (k_O V + c T) + r k_O V < r k_C V` (... `ReadStages.freshDraw_above_iff_chance`)". The line has no `0 < m` and no "positive chance". A chance m/(m+r) with m = 0 is a valid chance of nothing, so the wording does not exclude it. The next clause, "so for some chance exactly where `2 k_O V + c T < k_C V`" (`freshDraw_above_iff`), does not supply the hypothesis. That is a separate existential law, and there the `0 < m` is harmless because FreshDrawAbove 0 r is always false. The Lean header (lines 80-81, "for `0 < m` (`freshDraw_above_iff_chance`)") and the study's Delta (study_rf7.txt line 37, "for 0 < m") both carry the hypothesis, so the home statement is the one that drops it. That breaks the rule that claims state exactly the Lean's hypotheses. The proposed fix ("for `0 < m`") restores the Lean statement. The record's law item has the same omission in English and Chinese (make_records_rf7.py lines 195-200: "complying with chance m/(m+r), stands above ... exactly where (m+r)(k_O V + c T) + r k_O V < r k_C V", and 以 m/(m+r) 之机从之律 ... 恰当 ...). Since a statement change goes to both the record and the home section, the fix belongs there too. None of the other listed texts (08-METHOD, 07-SIGNIFICANCE, the overview, ALIGNMENT, README.md and README.zh.md, Becoming.lean, check_becoming.py) repeats the chance-specific iff.

## E2 (exactness, high, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:195-200 (law 8, en and zh)

**Quoted.** “complying with chance m/(m+r), stands above acting by its own law at both exactly where (m+r)(k_O V + c T) + r k_O V < r k_C V / 以 m/(m+r) 之机从之律，居二阶皆依己律之上，恰当 (m+r)(k_O V + c T) + r k_O V < r k_C V”

**Problem.** This law drops the same hypothesis, `0 < m` (the `pos` argument of `freshDraw_above_iff_chance`). The hypotheses field does not state it either, so the record asserts an iff that fails at m = 0 (counterexample above).

**Replacement.** en: "complying with chance m/(m+r) for 0 < m, stands above acting by its own law at both exactly where (m+r)(k_O V + c T) + r k_O V < r k_C V"; zh: "以 m/(m+r)（0 < m）之机从之律，居二阶皆依己律之上，恰当 (m+r)(k_O V + c T) + r k_O V < r k_C V" (re-run --caps)

**Verdict: real.** The files confirm the finding. Law 8 in make_records_rf7.py (lines 195-200) says, in both English and Chinese, that the fresh-draw law "complying with chance m/(m+r), stands above acting by its own law at both exactly where (m+r)(k_O V + c T) + r k_O V < r k_C V". Neither version states 0 < m. The Lean theorem behind it, ReadStages.lean line 621, is `theorem freshDraw_above_iff_chance (s : Prospects) {m r : Nat} (pos : 0 < m) : s.FreshDrawAbove m r ↔ (m + r) * (k_O V + c T) + r * (k_O V) < r * (k_C V)`. That `pos` argument is passed to freshDraw_reduce. Its forward direction does not use `pos`, but its reverse direction does, through `Nat.mul_lt_mul_of_pos_left below pos`. So for m = 0 the Lean proves only one direction, not the "exactly where" the law asserts.

The iff really fails at m = 0. FreshDrawAbove 0 r reduces to r(r k_O V) < r(r k_O V), which is always false. The right side reduces to r(2 k_O V + c T) < r k_C V, which holds for any r > 0 wherever the gap holds. A concrete case uses the module's own valid witness, Example.prospects ⟨10, 9, 1, 10, 5⟩, with m = 0 and r = 1: the right side is 70 < 90, true, but FreshDrawAbove is 10 < 10, false. Simple arithmetic over m ≤ 5, r ≤ 11 found a mismatch at every m = 0, r ≥ 1 and nowhere else.

Other texts state the hypothesis but the record does not:
- The module header (line 81) says "for `0 < m` (`freshDraw_above_iff_chance`)".
- The study template study_rf7.txt (line 37) says "for 0 < m".
- The record's hypotheses field (lines 213-216) does not mention it and says "the arithmetic laws hold for all".
- A grep of make_records_rf7.py finds no "0 < m" and no positive-chance wording anywhere in the record.

Reading "complying with chance m/(m+r)" as presupposing a positive chance does not save the law. A chance of 0 is a well-defined chance, the Lean definition FreshDrawAbove is defined for every m and r, and the Lean adds 0 < m as an explicit hypothesis. The repository rule requires claims to state exactly what the Lean proves, hypotheses included, so this is an exactness error and not a matter of taste.

The rest of the law ("so for some chance exactly where 2 k_O V + c T < k_C V") is unaffected, because FreshDrawAbove 0 r is never true. The proposed fix of adding "for 0 < m" (Chinese "（0 < m）") matches the Lean.

## E3 (exactness, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:474

**Quoted.** “Its prospects are a total; the weight of its law's being kept after it complies when read, and after it acts by its own law then; the value of acting by its law at the unread stage where kept; and the loss of complying when read (`ReadStages.Prospects`).”

**Problem.** The paragraph then gives every threshold in `T`, `k_C`, `k_O`, `V` and `c` (`k_O V + c T < k_C V`, `0 < k_O V`, the fresh-draw inequalities), but nothing in the chapter says which field each letter names. Only the Lean header does ("writing `T` for the total, `k_C` and `k_O` for the two weights, `V` for the value and `c` for the loss"). The home statement cannot be read on its own, and k_C and k_O in particular are easy to swap.

**Replacement.** Its prospects are a total `T`; the weights `k_C` and `k_O` of its law's being kept after it complies when read and after it acts by its own law then; the value `V` of acting by its law at the unread stage where kept; and the loss `c` of complying when read (`ReadStages.Prospects`).

**Verdict: real.** The finding holds; I could not refute it.

1. **The quote is exact.** 03-KNOWING.md line 474 lists the five prospects in words only: "a total; the weight of its law's being kept after it complies when read, and after it acts by its own law then; the value ...; and the loss of complying when read".

2. **The same paragraph then uses the letters without defining them.** It writes `k_O V + c T < k_C V`, `k_O V` positive with `k_C V < k_O V + c T`, `0 < c T`, `k_O V + c T` positive, `(m + r) (k_O V + c T) + r k_O V < r k_C V` and `2 k_O V + c T < k_C V`. The Reading paragraph at line 476 repeats `2 k_O V + c T < k_C V`.

3. **Nothing in the chapter defines the letters.** I searched the whole chapter for `T`, `V` or `c` as code spans: none appears. `k_C` and `k_O` appear only on lines 474 and 476, and neither line defines them. By contrast, the same paragraph does define `m` and `r` ("complying with chance `m / (m + r)`"), and the chapter's other theorems name their variables (for example "multiplier a", and `x` and `y`).

4. **Only the Lean defines them.** The module header in ReadStages.lean says "writing `T` for the total, `k_C` and `k_O` for the two weights, `V` for the value and `c` for the loss". The `KeepingOutweighs` definition confirms which field each letter is: `s.keptOwn * s.value + s.cost * s.total < s.keptComplying * s.value`. The same holds in `ownAtBoth_best_iff`, `uniform_best_iff`, `freshDraw_above_iff_chance` and `freshDraw_above_iff`.

5. **No other text supplies the definitions.** The record text in make_records_rf7.py (statement and law items, English and Chinese) uses `k_C V`, `k_O V + c T` and `0 < c T` without defining them. So do THE-THEORY-OF-BECOMING.md line 96 (which links to this home section for `k_C V > 2 k_O V + c T`), PLAN.md line 178 and study_rf7.txt line 73. GLOSSARY.md has nothing, and the record page has not been rendered yet.

6. **This is not a matter of taste.** The prose gloss "the weight complying adds to being kept, times the value, strictly exceeding the loss" lets a careful reader work out the first inequality. The other thresholds can only be read by guessing the letters. The guess is not obvious: the chapter calls `c` "the loss" (it comes from the Lean field `cost`, which the chapter never names), and the chapter never explains the C and O subscripts. Swapping `k_C` and `k_O` reverses every threshold, so the home statement, the one place this result is stated, does not say on its own what the Lean proves.

7. **The proposed replacement is correct.** It assigns `T` to total, `k_C` to keptComplying, `k_O` to keptOwn, `V` to value and `c` to cost (the loss), matching the order of the `Prospects` structure and the `KeepingOutweighs` definition.

## E4 (exactness, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:149-153 (law 1; letters used in the statement, laws 3-8 and the correspondence)

**Quoted.** “the prospects are a total, the weights of the law's being kept after complying when read and after acting by its own law then, the value of acting by its law at the unread stage where kept, and the loss of complying when read”

**Problem.** The record states its thresholds in k_C, k_O, V, c and T (for example the statement's "k_C V > 2 k_O V + c T" and laws 3 to 8), but no field, English or Chinese, says which prospect each letter names.

**Replacement.** en: "the prospects are a total T, the weights k_C and k_O of the law's being kept after complying when read and after acting by its own law then, the value V of acting by its law at the unread stage where kept, and the loss c of complying when read"; zh: "其望为一总 T、读时从后与读时依己律后其律被守之权 k_C 与 k_O、不读时依其律而被守之值 V、读时从之损 c"

**Verdict: real.** The finding holds. I read the whole record and the Lean, and nothing in the record refutes it.

1. **Law 1 names the prospects in words only.** Law 1 (make_records_rf7.py:149-153) names the five prospects, a total, two weights of being kept, a value and a loss, but attaches no letter to any of them. The quoted English and Chinese strings match law 1 exactly.

2. **The letters are used without a definition.** A grep of the script finds k_C, k_O, V, c and T only where they are used:
   - the statement, English and Chinese (147-148, "k_C V > 2 k_O V + c T");
   - laws 3, 4, 5, 6 and 8 (162-166, 171/173, 179-180 "0 < c T", 186-187, 196-199);
   - the correspondence, English and Chinese (257, 262).

   One small slip in the finding: law 7 (190-193) uses no letters, so "laws 3 to 8" is off by one item. The defect stands.

3. **No other field defines them.** None of the title, hypotheses (213-217), does_not_show, counterexamples, validation, next_delta, aliases, dependencies, related or history says which prospect a letter names, in either language.

4. **Only the Lean header defines them.** ReadStages.lean lines 19-21 say "writing `T` for the total, `k_C` and `k_O` for the two weights, `V` for the value and `c` for the loss". The fields are total, keptComplying, keptOwn, value and cost. The record never uses the word "cost"; it calls c "the loss". A lower-case c beside k_C, whose C stands for complying, could also be misread. So the mapping cannot be recovered from the record alone.

5. **The record page does not show the Lean header.** The rendered page shows only the record's fields; the sibling page what-readings-fix-of-the-unread.md shows the layout. Other records define their symbols inline, for example slowing-down-before-an-own-end: "the return multiplier a". As it stands, the statement's central threshold does not say exactly what the Lean proves. This is an exactness gap, not a matter of taste.

6. **The proposed fix fits.**
   - The statement is 299 of its 300 English characters, so the definition cannot go there. Law 1, where the prospects are first named, is the right place.
   - With the replacement, law 1 is 353 of 420 English and 82 of 190 Chinese characters, within ITEM_CAPS_V2['laws'].
   - Its mapping matches the Lean in both languages: k_C keptComplying, k_O keptOwn, V value, c cost, T total.

7. **The same gap appears elsewhere** (outside this finding). None of these defines the letters: the home theorem paragraph in 03-KNOWING.md §11 (line 474), the paragraph in THE-THEORY-OF-BECOMING.md §3, ALIGNMENT.md, PLAN.md and study_rf7.txt.

## E5 (exactness, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:145-148 (statement, en and zh)

**Quoted.** “with the stages not told apart, a chance drawn afresh gains exactly where k_C V > 2 k_O V + c T. / 二阶不可分时，每阶重抽之机有所得，恰当 k_C V > 2 k_O V + c T。”

**Problem.** `freshDraw_above_iff` is existential, (∃ m r, 0 < m ∧ FreshDrawAbove m r) ↔ 2 k_O V + c T < k_C V, and `FreshDrawAbove` compares only with `ownAtBoth`. "A chance ... gains" reads as any chance and names nothing to compare with. On the witness, a chance of one in four does not stand above (`Example.freshDraw_boundary`) although 70 < 90 holds. The statement also says "weights as probabilities" without "where valid". The law item and the other texts say "for some chance".

**Replacement.** en: "In two stages, weights read as probabilities where valid, complying when read and acting by its own law when not is uniquely best exactly where the weight complying adds to being kept, times the value, exceeds the loss; with the stages not told apart, drawing the act afresh with some chance of complying stands above acting by its own law at both exactly where k_C V > 2 k_O V + c T."; zh: "……；二阶不可分时，每阶以某机重抽其行者居二阶皆依己律之上，恰当 k_C V > 2 k_O V + c T。" (check the statement cap)

**Verdict: real.** The problem is real. I checked it against the Lean and the texts.

1. The Lean is existential. ReadStages.lean lines 660-664 prove `freshDraw_above_iff : (∃ m r, 0 < m ∧ s.FreshDrawAbove m r) ↔ 2*(k_O V) + c T < k_C V`. The definition at lines 264-266 compares the fresh-draw plan with `ownAtBoth` and nothing else. The module separates this law from the law for one given chance (`freshDraw_above_iff_chance`, lines 621-625).

2. The Lean's own witness refutes the universal reading. `Example.freshDraw_boundary` (lines 754-758) uses the prospects ⟨10,9,1,10,5⟩, where 2 k_O V + c T = 70 < 90 = k_C V holds. There a chance of one in five stands above `ownAtBoth` (500 < 520), but one in four does not (360 vs 360, a tie). I rechecked this arithmetic.

3. The statement leaves both points out. In make_records_rf7.py lines 145-148, the English says "a chance drawn afresh gains exactly where k_C V > 2 k_O V + c T": it says neither "some" nor what the chance gains against. The Chinese, 每阶重抽之机有所得, has no 某 and no comparison either. Read as "any chance", the claim is false by point 2. "Gains" also echoes the module's defined `Prospects.gain`, which means something else.

4. The rest of the record and the other texts are exact.
   - The record's own law item (lines 195-199) says "stands above acting by its own law at both … so for some chance", and in Chinese 故于某机.
   - Its correspondence (lines 256-257) says "with some chance" (以某机).
   - 03 §11 line 474 says "stands above acting by its own law at both … so for some chance".
   - Becoming.lean lines 2223-2225 and check_becoming.py lines 2808-2810 say "for some chance".
   - The study template says the same, and the review it records insisted that "the improving chances [be] stated exactly".
   - THE-THEORY-OF-BECOMING §3 and ALIGNMENT say "with some chance".

   So the headline statement is the one place that drops what the Lean distinguishes.

5. The "weights as probabilities" without "where valid" point is literally true, but minor. 03, 08, Becoming.lean and the checker say "where valid". THE-THEORY §3, ALIGNMENT and the board also omit it, and the record's hypotheses item says the probability reading needs `Valid`.

Caveats:
- "The other texts say 'for some chance'" is not universal. The board's land7 text (board_rf2.py) says "still gains where …", and PLAN §4.6 says "keeps a gain where …", neither with "some chance".
- The English statement is at 299 of its hard cap of 300 (`style.STATEMENT_CAP = (300, 150)`). The proposed English replacement is 384 characters, so it must be shortened to fit. The Chinese is at 84 of 150, and the proposed Chinese (94) fits.

## E6 (exactness, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:461

**Quoted.** “A third states when acting otherwise where not read is a formation's own best plan, in two stages.”

**Problem.** This live, unlabelled sentence puts the reading into the theorem. The Lean says whose weights these are, "the formation's own assessment or the selection the reading actually applies, is a reading (below), not part of the model". The record's does_not_show says the same. What the law states is the plan the prospects rank best.

**Replacement.** A third states when, in two stages, acting otherwise where not read is the plan the prospects rank best.

**Verdict: real.** The finding holds. Line 461 of 03-KNOWING.md, in the unlabelled opening paragraph of §11, says "A third states when acting otherwise where not read is a formation's own best plan, in two stages." The paragraph's only reading label ("Reading such a selection as a training, a helper, an overseer or a court is a reading (below)") covers readings of the selection. It does not cover whose ranking this is.

The Lean never attributes the order to the formation:
- Lines 8-9 of the header: the module "states when that plan is the one the prospects of the two stages rank best".
- Lines 36-37: "Whose these weights are, the formation's own assessment or the selection the reading actually applies, is a reading (below), not part of the model."
- Line 170: "the order on plans is the prospects'".
- Line 241: `Above` is "in the order the prospects give".
- `Prospects` is five bare natural numbers. The docstring of `complyThenOwn_best_iff` says only that the plan "stands above every other plan".
- The phrase "the formation's own" appears in the Lean only in the [AI reading] block, as a conditional: "If the prospects are the formation's own expected-value assessment..." (line 141), and "Read as the formation's own assessment..." (line 156).

The other texts keep the same separation:
- The record's does_not_show: "whose the weights are, the formation's own assessment or the selection a reading applies, is a reading, not part of the model".
- The study template's Boundary says the same.
- The record's title and statement say "is best" and "uniquely best", with no "own".
- The theorem paragraph's title in 03 says "is best".
- 03 §11's own labelled Reading keeps this conditional: "If the prospects are the formation's own expected-value assessment, the exits are conditions on that assessment". So the opening sentence states without condition what the chapter's own Reading treats as an "if".

Refutation attempt: "own best plan" could be glossed as "best for the formation" under the selection's actual weights. Even that gloss gives the order (the weights, or the value V) to the formation, which the Lean leaves unassigned ("the prospects'"). And "own" is the exact word the Lean keeps for the reading. Under the two readings the exits mean different things: conditions on the formation's assessment rather than levers a reader holds. So this is a substantive slip of exactness, not a matter of taste.

The proposed replacement ("the plan the prospects rank best") repeats the module header's own wording at line 9.

## E7 (exactness, medium, confirmed)

**Location.** theories/becoming/chapters/07-SIGNIFICANCE.md:647

**Quoted.** “nor anything of deception beyond where behaviour can differ when not read and when complying only when read is a formation's own best plan”

**Problem.** This row describes what the laws say, and it is not labelled a reading. "A formation's own best plan" treats the prospects as the formation's own assessment, which the module and the record both call a reading, not part of the model.

**Replacement.** nor anything of deception beyond where behaviour can differ when not read and when complying only when read is the plan the prospects rank best

**Verdict: real.** The files bear the finding out. 07-SIGNIFICANCE.md:647 (the "Why" cell of the row "Which function is learned", verdict "open") is framed as what "the laws say". It has no [AI reading] label, unlike the row "Why anything has significance" in the same table, which carries "[AI reading, D59]". The git diff shows RF7 added the clause "and when complying only when read is a formation's own best plan".

The Lean does not attribute the ranking to the formation. The header of ReadStages.lean (lines 8-9) says the module "states when that plan is the one the prospects of the two stages rank best". Lines 36-37 say: "Whose these weights are, the formation's own assessment or the selection the reading actually applies, is a reading (below), not part of the model." The Standing (line 170) says "the order on plans is the prospects'". The formal content is all about the prospects' order: `Prospects.Above`, `KeepingOutweighs` and `complyThenOwn_best_iff`, where `value` and `cost` are bare natural numbers. The tie to the formation's own assessment appears only in the labelled Readings paragraph: "If the prospects are the formation's own expected-value assessment, the laws characterize strict optimality..." and "Read as the formation's own assessment, complying when read is instrumental to being kept, the sense in which deceptive alignment is called deceptive". That second sentence is exactly the deception sense the row's clause invokes.

The record and the study say the same. The record's does_not_show in make_records_rf7.py (lines 218-219) reads: "whose the weights are, the formation's own assessment or the selection a reading applies, is a reading, not part of the model". The Boundary of study_rf7.txt (line 64) has the same text, and it states the content as "strict optimality within four plans in the order the prospects give". 08 §8 also says "in the order the prospects give".

The repository itself treats this phrase as reading content. THE-THEORY-OF-BECOMING.md:96 puts "when doing so is its own best plan" inside a sentence marked [AI reading]. ALIGNMENT.md:21 calls it "RF's readings of ... when complying only when read is a formation's own best plan". Against them, the 07 row presents the same attribution, unlabelled, as what the laws say. This breaks the rules that claims say exactly what the Lean proves and that readings are labelled.

Strongest objection: "own best plan" could be parsed as "best for the formation" rather than "by its own assessment". That does not save the row. Under either parse it gives the order to the formation, and the model gives it only to the prospects. Even "best for the formation" needs V to be the formation's value, which is also a reading: the module's deceptive-alignment reading takes the value as "an objective".

The 03 §11 opening (line 461, "a formation's own best plan") has the same inexactness. That shows the 07 row mirrors its home section, not that the row is right. The proposed replacement, "the plan the prospects rank best", matches the module header word for word.

## E8 (exactness, medium, confirmed)

**Location.** theories/becoming/chapters/08-METHOD.md:485 (same framing in the study template, _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:56-57)

**Quoted.** “restates the incentive deceptive alignment names (Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant 2019) as strict optimality over four plans in the order the prospects give”

**Problem.** The module's Standing names two known results: the toy example opening §4 of Hubinger et al., generalized from certain keeping to weights, and, for drawing afresh, the advantage of behavioural over mixed strategies under imperfect recall (Piccione and Rubinstein 1997). The deceptive-alignment incentive is an AI reading that needs two premises beyond the prospects: that the reading's keeping responds to the act as evidence of the law, and that the prospects are the formation's own assessment. This known-results bullet presents the reading as the restatement, unlabelled, and omits the known result for the fresh-draw half. The study's "What it adds is the incentive deceptive alignment names" does the same.

**Replacement.** When complying when read and acting by its own law when not is best ([03 §11]\(03-KNOWING.md#r-when-complying-when-read-is-best)) generalizes the toy example opening §4 of Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019) from certain keeping to weights, as strict optimality over four plans in the order the prospects give, with weights read as probabilities where valid, every optimizing choice, the exits and what the plan needs, joined to RF2's law of the unread; read as the formation's own assessment [AI reading], it is the incentive deceptive alignment names. That drawing the act afresh keeps a gain where the stages cannot be told apart, the threshold rising from `k_O V + c T` to `2 k_O V + c T`, while a single mixture of the uniform plans never gains, is the advantage of behavioural over mixed strategies under imperfect recall (Piccione and Rubinstein 1997). It represents neither a recipient's belief nor an intention to cause one. Near-definitional, with witnesses.

**Verdict: real.** The finding holds. I read the Lean, the 08 bullet, the study template, 03 §11, the overview, the record script and the integration script.

1. What the Lean's Standing names (ReadStages.lean lines 101-113). The Standing calls the module elementary arithmetic and claims nothing new as mathematics. It names two known results. First, the two-stage comparison generalizes the toy example opening §4 of Hubinger et al., "from certain keeping to weights". Second, drawing afresh can gain where a single mixture cannot, which is "the advantage of behavioural over mixed strategies under imperfect recall (Piccione and Rubinstein 1997)". The Standing never says the theorem restates the incentive.

2. Where the Lean puts the deceptive-alignment link. It is only in the **Readings** [AI reading] paragraph (lines 120-158), and that paragraph states its premises:
   - "Reading complyThenOwn as concealment ... takes, beyond the prospects, the reading's keeping to respond to the act read as its evidence of the formation's law ... With that taken, read with deceptive alignment."
   - "Read as the formation's own assessment, complying when read is instrumental to being kept, the sense in which deceptive alignment is called deceptive."
   - Lines 36-37 say whose the weights are "is a reading (below), not part of the model."
   So the incentive is a labelled reading that needs at least the own-assessment premise, and in the module's wording also the evidence premise.

3. The 08 bullet (08-METHOD.md:485). It says the result "restates the incentive deceptive alignment names (Hubinger ... 2019) as strict optimality over four plans", with no [AI reading] label. It names neither the toy-example generalization nor Piccione and Rubinstein. It describes the fresh-draw half (the threshold rising, a single mixture never gaining) but gives no known result for it, although §8 is the "Known results" section. A grep finds "Piccione" only in the module and in study_rf7.txt. integrate_rf7.py line 128 writes exactly this text, so nothing later adds the label or the citation.

4. The bullet is the outlier among the texts:
   - 03 §11's Theorem paragraph does not mention deceptive alignment; only its "Reading [AI reading, new]" paragraph does.
   - The overview's sentence carries "[AI reading]".
   - The record's correspondence field begins "AI reading:" and ends "These are readings, not containments."
   - Within 08 §8 itself, readings are labelled inline: the Kreps bullet (line 475) and the lag bullet (line 474) both carry [AI reading]. So dropping the label is not a convention of the section.

5. The study template (study_rf7.txt:56-57). Its Standing does name both known results. But it then says "What it adds is the incentive deceptive alignment names stated as strict optimality ...", unlabelled, while its own Boundary says whose the weights are "a reading, not part of the model". So the study repeats the unlabelled-reading framing, though not the omission.

6. Attempted refutation. One could argue the toy example simply is the paper's illustration of the incentive, so "restates the incentive" matches "generalizes the toy example". The module rejects that equivalence: it keeps the structural generalization in the Standing and puts the incentive in the labelled Readings. One could also argue the incentive needs only the own-assessment premise, not the evidence premise. Even granting that, the label is still required.

Taken together, the 08 bullet presents an AI reading, unlabelled, as what the theorem restates, and it leaves out the fresh-draw half's known result. That conflicts with "claims say exactly what the Lean proves" and "every reading keeps its AI label".

## E9 (exactness, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:266-269 (dependencies) and 190-194 (law 7)

**Quoted.** “dep('what-readings-fix-of-the-unread', "Learning.lumped_determines and Learning.twin_selected, at the two stages.", ... / "RF2's laws at the two stages: ... where it ties them, the read stage fixes the act at the unread one; the weight of being kept reads only the act at the read stage."”

**Problem.** `Learning.lumped_determines` belongs to the record generalization-through-lumping: its laws cite lumped_determines and determines_lumped_iff. RF2's own record lists generalization-through-lumping as its source for "Lumped, Free, Determines and lumped_determines", and its laws cite free_lumped and twin_selected, not lumped_determines. So the dependency puts lumped_determines on the wrong record, and the dependency on generalization-through-lumping names only Lumped. Law 7 also files `kept_alike`, a property of the model's `kept` function, under "RF2's laws".

**Replacement.** dep('generalization-through-lumping', "Learning.Lumped and Learning.lumped_determines: an act law going alike across a lumping of the stages, and the read stage fixing the unread act where the lumping ties them.", 'Learning.Lumped 与 Learning.lumped_determines：随二阶之归并而同之行律，及归并合二阶处读时定不读时之行。'), dep('what-readings-fix-of-the-unread', "Learning.twin_selected, at the two stages.", 'Learning.twin_selected，于二阶。'); law 7 en: "At the two stages: where the lumping tells them apart, RF2's twin, every selection through agreement on the read stage that selects a law complying when read also selecting one taking the plan; where it ties them, the lumping's fixing, the read stage fixing the act at the unread one; and the weight of being kept reads only the act at the read stage." zh: "于二阶：归并分二阶处，RF2 之孪生：经读时之合而选、选一读时从之律者，亦选一取此策者；归并合二阶处，归并之定：读时定不读时之行；被守之权唯读读时之行。"

**Verdict: real.** The files show every part of the finding.

1. **`lumped_determines` belongs to generalization-through-lumping.**
   - It is declared in Learning.lean at line 858, the canonical source of generalization-through-lumping.
   - That record's law 2 cites `Becoming.Learning.lumped_determines`, `decideSeen` and `determines_lumped_iff`.
   - Unread.lean, RF2's module, declares `twin_selected` (line 104) and `free_lumped` (line 87). It does not declare `lumped_determines`. It only uses it at line 181, in `Cue.unseen_fixed`, and its header (line 18) calls it the sufficient side of `Learning.determines_lumped_iff`, "read here, not proved again".
   - RF2's record (what-readings-fix-of-the-unread.json) never cites `lumped_determines` in its laws. Its laws cite `free_lumped`, `twin_selected`, `determines_iff_not_not`, the two "apart" theorems and the Cue declarations.
   - RF2's own hypothesis says the act "is fixed by generalization through lumping (lumped_determines; ...): read here, cited, not proved again".
   - RF2's dependency on generalization-through-lumping names "Learning.Lumped, Free, Determines and lumped_determines; ...".

2. **The RF7 dependencies misfile it.** make_records_rf7.py lines 266-269:
   - The edge to what-readings-fix-of-the-unread names "Learning.lumped_determines and Learning.twin_selected".
   - The edge to generalization-through-lumping names only "Learning.Lumped".
   - By RESULT-WORKFLOW.md line 37 and navigation.py, a formal-reuse edge names the producer's output: the consumer's proof uses the producer's theorem.
   - `ReadStages.read_fixes_unread` (ReadStages.lean 497-499) is `Learning.lumped_determines ⟨true, rfl, same⟩`. It uses generalization-through-lumping's theorem and no RF2 theorem.
   - So the RF2 edge names a theorem that is not RF2's output, and the generalization-through-lumping edge leaves it out.

3. **Law 7 files `kept_alike` under RF2.**
   - Law 7 (lines 190-194) opens "RF2's laws at the two stages:", and its third clause, citing `kept_alike`, sits inside that list.
   - `kept_alike` (ReadStages.lean 525-527) is `congrArg s.kept (agree true rfl)`, a fact about the model's own `Prospects.kept`.
   - The Lean's own Standing paragraph (lines 105-106) names only `lumped_uniform`, `read_fixes_unread` and `twin_complyThenOwn` as RF2's laws at the two stages, not `kept_alike`.
   - The Chinese fields repeat both problems: the dependency text 'Learning.lumped_determines 与 Learning.twin_selected' and law 7's 'RF2 之律于二阶：…；被守之权唯读读时之行'.

This is a matter of exactness, not taste. An earlier review (REVIEW-TEXTS finding 18) corrected the same kind of dependency-detail error in RF2's own record, though it rated it Low, so medium may overstate the severity.

Caveats for whoever takes the finding:
- The same "RF2's `Learning.lumped_determines`" wording is in ReadStages.lean itself, at lines 69-70 and 495-496, and the Standing paragraph also calls `read_fixes_unread` and `lumped_uniform` RF2's laws. The finding does not cover these.
- ReadStages also uses `Learning.Determines` (line 498), `Training.Through` (line 507) and `Training.AgreeOn` (lines 507, 526). All three are generalization-through-lumping's. The proposed replacement still leaves them off that edge.
- The proposed law 7 text fits the caps: English 351 of 420 characters, Chinese 76 of 190.

## E10 (exactness, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:221-223 (does_not_show, en and zh)

**Quoted.** “Deception in full: a recipient's belief and an intention to cause one are not represented, nor any reasoning about the reader; this is the incentive. / ……；此为其诱因。”

**Problem.** This boundary field is not labelled a reading, yet it asserts that the result is deception's incentive. The Lean puts that only in the Readings: it holds read as the formation's own assessment and with the concealment premise. The record's first does_not_show item even says whose weights these are is a reading.

**Replacement.** en: "Deception in full: a recipient's belief and an intention to cause one are not represented, nor any reasoning about the reader; read as the formation's own assessment [AI reading], the result is at most deception's incentive." zh: "完整之欺：受者之信与致其信之意图皆未表，于读者之推理亦未表；读为形成己之估（AI 解读），此至多为其诱因。"

**Verdict: real.** I tried to refute the finding and could not. The files show the problem as stated.

1. The quoted text is at the stated place. make_records_rf7.py lines 221-223 hold does_not_show[1], kind 'non-implication'. The English is "...nor any reasoning about the reader; this is the incentive." and the Chinese is "...；此为其诱因。". Nothing in the item says it is a reading. In the Chinese, 其 refers back to 完整之欺 ("deception in full"), so the item says outright that this result is deception's incentive.

2. The Lean puts that idea only in its Readings. The word "incentive" never appears in ReadStages.lean. Every mention of deception or concealment sits inside the "**Readings** [AI reading]" paragraph (lines 120-158). There the Lean says:
   - reading complyThenOwn as concealment needs a premise "beyond the prospects": the reader's keeping must respond to the act it reads as evidence of the law;
   - "the weights alone fit equally a reading that knows the law and keeps it on compliance, under which complying when read hides nothing";
   - "Read as the formation's own assessment, complying when read is instrumental to being kept, the sense in which deceptive alignment is called deceptive";
   - "These are readings, not containments."

   Outside that paragraph the Lean says two related things, and neither supports the claim. Line 168 only lists belief and intention as left out ("the plan's deception debt"). The Standing paragraph says the arithmetic comparison generalizes Hubinger's toy example; it does not call the result anyone's incentive.

3. The record contradicts itself. Its own correspondence field (lines 248-250) is headed "AI reading" and states the concealment premise, adding that "the weights alone fit a reading that knows the law and keeps it on compliance". Its does_not_show[0] (lines 218-220) says whose the weights are "is a reading, not part of the model". The second item then asserts, unlabelled, a claim that depends on both of those readings.

4. The sentence came from inside a labelled reading. Its source is chapter 03, line 476: "so this is the incentive, not deception in full". That sentence sits inside "**Reading** [AI reading, new]". The record moved it into an unlabelled field.

5. Readers will see it unlabelled. registry.py renders does_not_show items openly under the "Does not show" heading, while the correspondence is in a collapsed details block. style.py lists does_not_show among the PUBLIC_FIELDS ("Public statement of the result"). The standard boundary names-provisional only says that "readings are interpretations"; it does not mark this sentence as one.

The refutation I tried was to read "incentive" as plain decision theory, meaning only that the plan ranks best under the prospects. It fails for two reasons. The Chinese 其 ties the incentive to deception. And the Lean itself says the weights alone allow complying when read to hide nothing, in which case the result is not an incentive to deceive.

The proposed replacement fits the caps: 224 of 240 characters in English, 53 of 110 in Chinese. It is one sentence. Its "at most" also covers the concealment premise.

Outside this finding: the same unlabelled "incentive" wording appears in 08-METHOD line 485, ALIGNMENT.md line 28 ("RF7 adds the incentive") and the Open bullet in 03 line 520.

## E11 (exactness, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:217 (hypotheses, zh)

**Quoted.** “行律经所予之归并读二阶，或每阶独立重抽一机。”

**Problem.** The Chinese omits the third alternative that the English gives ("or one draw before the read stage"). `MixtureAbove` and `mixture_never_above` rest on that alternative, so the Chinese hypotheses do not cover them.

**Replacement.** 行律经所予之归并读二阶，或每阶独立重抽一机，或读时之前一抽。

**Verdict: real.** The finding is real: the files show the omission exactly as stated.

1. **The English has three alternatives, the Chinese two.** In make_records_rf7.py, the English hypothesis at lines 213-216 ends with three: "an act law reading them through a supplied lumping, or a chance drawn afresh and independently at each stage, or one draw before the read stage." The Chinese at line 217 follows the English clause by clause up to that point: 望为自然数 / 算术之律于一切皆成，概率之读需 Valid / 二阶四策… / 二阶为 Bool，true 为读时 / 行律经所予之归并读二阶 / 或每阶独立重抽一机. It then stops, and nothing stands for "or one draw before the read stage."

2. **The mixture laws rest on that third alternative.** In ReadStages.lean, the `Prospects.MixtureAbove` docstring reads "one draw before the read stage, complying at both stages with weight `a` and acting by its own law at both with weight `b`". The `mixture_never_above` docstring reads "one draw before the read stage between complying at both and acting by its own law at both gains nothing on the second". The module's own Modelling choices (lines 160-163) give the same three alternatives as the English, and so does study_rf7.txt (lines 48-51).

3. **Neither Chinese alternative covers the mixture.** 行律经所予之归并读二阶 is the deterministic law read through a lumping. 每阶独立重抽一机 is an independent fresh draw at each stage. Neither is a single draw before the read stage between the two uniform plans.

4. **The gap shows inside the Chinese record itself.** Its eighth law item (line 200) states 二同行策之单一混合永不居上 and cites `Prospects.MixtureAbove` and `mixture_never_above`. So the Chinese states a law whose modelling choice its own hypotheses do not give.

5. **The length cap does not explain it.** `style.ITEM_CAPS_V2['hypotheses']` allows 190 Chinese characters. The current text is 84, and the proposed replacement is 92.

6. **The replacement fits the record's terms.** 或读时之前一抽 uses the record's own word for the read stage (true 为读时). It restores the Chinese to the English and to the Lean.

7. **A similar gap nearby, outside this finding.** The Chinese history text at line 277 (每阶重抽其行) likewise drops the English "against a single mixture".

## E12 (exactness, medium, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.zh.md:144; make_records_rf7.py zh fields (statement 148, laws 153-200, hypotheses 217, counterexamples, correspondence)

**Quoted.** “二阶中读时从而不读时依己律 / 于二阶，权读为概率 / 二阶二行四策 / 二阶皆依己律”

**Problem.** In this repository 二阶 already means "second order": eventual-widening and two other records write 生生的二阶方向 for "the second-order direction of 生生". So 于二阶 and 二阶中 read as "at second order", not "in two stages", and 二阶皆依己律 reads as "at second order follows its own law". The Chinese then does not say what the English says.

**Replacement.** Use 两阶段 throughout: 两阶段中读时从而不读时依己律; 于两阶段; 两阶段二行四策; 两阶段皆依己律; 两阶段不可分时.

**Verdict: real.** The files support the finding. The Lean (ReadStages.lean header) means two time stages, given as Bool with true for the read stage and false for the unread one. Nothing in it concerns order. The English says "in two stages" (README.md:198; Becoming.lean:2215; the record's en statement at make_records_rf7.py:145). But in this repository the Chinese 阶 already means "order":
- README.zh.md uses it that way in the same file: row 111 一阶扩大 for README.md:148's "first-order widening"; row 148 立方阶; the Becoming.Loops/Routes/HistorySums rows (167-169, 196) 按阶展开, 每一阶, 各阶, j 阶 for "expands by order", "each order", "order j".
- The same file uses 阶段 for "stages" (row 6, 方向与阶段).
- Live records render "the second-order direction of 生生" as 生生的二阶方向: eventual-widening.json (whose statement also has 一阶扩大 for "first-order widening"), comparing-two-courses-on-what-they-admit.json, what-a-course-keeps-reachable.json (also 最终扩大之二阶 for "Eventual widening's second order") and what-keeping-widening-needs.json. what-can-be-born-next.json has 二阶方向.
- 07-SIGNIFICANCE.md keeps "the second-order direction of 生生" as an open item.

So README.zh:144's 二阶中读时从而不读时依己律 and the zh statement's opening 于二阶 (make_records_rf7.py:148) can be read, by the repository's own usage, as "at second order". That diverges from the English and the Lean, and could even suggest a result on the open second-order direction. This is an exactness defect, not taste.

Caveats, none of which refute it:
1. The count is low: eventual-widening and three other records (not two) write 生生的二阶方向.
2. 二阶皆依己律 is the weakest case, since 皆 implies a plural and points toward "both stages".
3. A landed precedent exists: what-readings-fix-of-the-unread.json next_delta (RF round 1) already renders "in two stages" as 二阶. This shows the collision predates RF7.
4. The proposed fix is incomplete: 每阶, 某阶, 不读之阶 and 阶之值 (lines 148, 159, 180, 199, 226, 247; README 每阶重抽其行) would still read as "order" given README.zh's 每一阶/各阶. They need 阶段 forms too, such as 每阶段 and 不读之阶段.

A separate issue outside this finding: GLOSSARY.md already glosses "stages (层)" for chapter 03 in another sense, finite approximations of the core.

## E13 (exactness, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean:69-70, 104-106, 495-496

**Quoted.** “the read stage fixes the act at the unread one (`read_fixes_unread`, RF2's `Learning.lumped_determines`) / `lumped_uniform`, `read_fixes_unread` and `twin_complyThenOwn` are RF2's laws at the two stages / RF2's `Learning.lumped_determines` at the two stages”

**Problem.** `Learning.lumped_determines` and `Learning.Lumped` are Learning's: record generalization-through-lumping, 03 §6. RF2's module reads them "not proved again", and RF2's record lists them as a dependency. `lumped_uniform` is `Lumped`'s definition applied. Of the three, only `twin_complyThenOwn` (from `Learning.twin_selected`) is RF2's law at the two stages.

**Replacement.** (`read_fixes_unread`, `Learning.lumped_determines`, the lumping law RF2 reads) / `choose_eq_iff` unfolds `choose`; `twin_complyThenOwn` is RF2's law at the two stages, and `lumped_uniform` and `read_fixes_unread` are the lumping's (`Learning.Lumped`, `Learning.lumped_determines`) there / docstring: `Learning.lumped_determines` at the two stages, `true` the read stage (prose only; statements unchanged)

**Verdict: real.** The files confirm the finding. The quoted text is in ReadStages.lean as given. Lines 69-70 say "(`read_fixes_unread`, RF2's `Learning.lumped_determines`)". Lines 104-106 say "`lumped_uniform`, `read_fixes_unread` and `twin_complyThenOwn` are RF2's laws at the two stages". Lines 495-496 say "RF2's `Learning.lumped_determines` at the two stages".

RF2 is `Becoming.Unread`. The header's line 11 says "RF2's law of the unread (`Becoming.Unread`)", and regions.json says "Unread RF2", record what-readings-fix-of-the-unread.

Where each declaration comes from:
- `Learning.Lumped` is defined at Learning.lean:834 and `Learning.lumped_determines` at Learning.lean:858. Both are in `Becoming.Learning`, not `Becoming.Unread`.
- The record generalization-through-lumping lists `Becoming.Learning.Lumped` and `Becoming.Learning.lumped_determines` among its own law declarations. Its home is 03 §6, at anchor r-generalization-through-lumping, line 190 of 03-KNOWING.md.
- Only `twin_selected` is RF2's. It is defined at Unread.lean:104.

How RF2's own texts treat the lumping laws:
- RF2's module header (Unread.lean:9-18) gives `Lumped π` as `Becoming.Learning`'s. It calls the fixing "`Learning.determines_lumped_iff` ... read here, not proved again", with "the sufficient side, `lumped_determines`".
- RF2's record says in its hypotheses "lumped_determines ... read here, cited, not proved again". Its dependency on generalization-through-lumping (formal-reuse) lists "Learning.Lumped, Free, Determines and lumped_determines". Its laws list does not include `lumped_determines`.
- RF2's home section (03 §11, line 469) says "§6's law says where the readings fix the act" and "What this law adds is the twin".

The proofs bear this out:
- `lumped_uniform` is `alike true false same`, the definition of `Learning.Lumped` applied, with nothing from RF2.
- `read_fixes_unread` is `Learning.lumped_determines ⟨true, rfl, same⟩`.
- Only `twin_complyThenOwn` calls `Learning.twin_selected`.

So calling `lumped_determines` "RF2's", and calling `lumped_uniform` and `read_fixes_unread` "RF2's laws", gets the attribution wrong. It contradicts RF2's own record and home section, so this is not a matter of taste. It touches prose only; no statement changes, so low severity is right.

Outside the finding's location, the same misattribution appears in the record script make_records_rf7.py:
- Lines 190-194: the law item "RF2's laws at the two stages" includes `read_fixes_unread`.
- Line 268: the dependency on what-readings-fix-of-the-unread lists "Learning.lumped_determines and Learning.twin_selected".

Fixing only the Lean prose would leave the record inconsistent with it.

## E14 (exactness, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean:2222; check_becoming.py:2807-2808; study_rf7.txt:58; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:178

**Quoted.** “with RF2's twin and fixing at the two stages / RF2's twin and fixing at the two stages / with the twin and the fixing at the two stages”

**Problem.** The fixing (`read_fixes_unread`) is `Learning.lumped_determines`, which belongs to generalization through lumping (03 §6), not to RF2's law. Only the twin is RF2's.

**Replacement.** with RF2's twin and the lumping's fixing (`Learning.lumped_determines`) at the two stages

**Verdict: real.** The files confirm it. In the Lean, `read_fixes_unread` (ReadStages.lean:497-499) is just `Learning.lumped_determines ⟨true, rfl, same⟩`. `lumped_determines` is declared in Learning.lean:858, under the header bullet "A lumping generalizes exactly where it lumps", not in RF2's module. Only the twin comes from RF2's module: `twin_complyThenOwn` (ReadStages.lean:514) uses `Learning.twin_selected`, which is declared in Unread.lean:104.

The records say the same:
- theories/becoming/results/records/generalization-through-lumping.json lists `Becoming.Learning.lumped_determines` among its law declarations. Its home anchor `r-generalization-through-lumping` sits in 03-KNOWING.md §6 "理: lumping" (lines 186-190).
- RF2's record, what-readings-fix-of-the-unread.json, does not list `lumped_determines` among its laws. Its laws are free_lumped, twin_selected, determines_iff_not_not, the acts/states/couplings chain and the Cue witness. Its statement is the twin alone. Its hypotheses say the act there is "fixed by generalization through lumping (lumped_determines; …): read here, cited, not proved again". Its dependency lists `lumped_determines` as formal reuse of generalization-through-lumping.
- RF2's home paragraph (03-KNOWING.md:469) says "§6's law says where the readings fix the act … What this law adds is the twin."

So "RF2's twin and fixing" credits RF2 with §6's law, contradicting the record and home section that govern RF2. It appears at Becoming.lean:2222, check_becoming.py:2807-2808 and study_rf7.txt:58. This is an attribution error, not a matter of taste.

Evidence against the finding, and why it does not save the phrase:
- Unread.lean's header bullet 1 ("Fixed exactly where it cannot tell … read here, not proved again") and PLAN.md §4.2 statement 1 present the fixing within RF2's account. That makes PLAN.md:178 ("its join to RF2, … with the twin and the fixing") the softest of the four places. But both texts say the fixing is read from Learning, not RF2's own law.
- The study's Delta (study_rf7.txt:31-32) is already exact: "read_fixes_unread, by Learning.lumped_determines".

Severity low is right. The same attribution also appears outside the quoted locations, so the proposed replacement alone would leave the texts inconsistent:
- ReadStages.lean:69-70 and 495-496 say "RF2's `Learning.lumped_determines`".
- ReadStages.lean:105-106 calls `lumped_uniform` and `read_fixes_unread` "RF2's laws at the two stages". `lumped_uniform` is only `Learning.Lumped` unfolded (`alike true false same`).
- make_records_rf7.py:190-194 puts `read_fixes_unread` in the law item "RF2's laws at the two stages".
- make_records_rf7.py:268 files `Learning.lumped_determines` under the dependency on what-readings-fix-of-the-unread, instead of generalization-through-lumping (line 266 lists only `Learning.Lumped`).

## E15 (exactness, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean:2216-2221; check_becoming.py:2803-2808 (also 03-KNOWING.md:474 and make_records_rf7.py:184, law 6)

**Quoted.** “With natural-number weights read as probabilities where valid (`ReadStages.Prospects.Valid`), that plan stands above every other exactly where the weight complying adds to being kept, times the value, exceeds the loss times the total ... an act law reading the stages through a lumping takes it exactly where the lumping tells them apart”

**Problem.** Two framings are mixed. Read as probabilities, "the weight complying adds" is (k_C − k_O)/T, which compares with the loss c, not with the loss times the total. The sentence states the natural-number form, which needs no Valid at all. Second, `plan_realized_iff` and `complyThenOwn_realized_iff` are existential (∃ g, Lumped π g ∧ ...). "An act law ... takes it exactly where" can be read as "every such law", which is false: a uniform law reading through a separating lumping does not take the plan. The 03 sentence also never says that `true` is the read stage.

**Replacement.** In natural numbers, that plan stands above every other exactly where the weight complying adds to being kept, times the value, exceeds the loss times the total (read as probabilities where `ReadStages.Prospects.Valid` holds, the loss) ...; it is open to some act law reading the stages through a lumping exactly where the lumping tells them apart (`ReadStages.complyThenOwn_realized_iff`). In 03 and law 6: "With the stages as `Bool`, `true` the read stage, a plan is open to some act law reading them through a lumping exactly where ..."

**Verdict: real.** The finding holds. Its second part is the substantive one. The first part is a mix of framings, not a false claim, and the third is an omission.

(1) Framing. In ReadStages.lean, line 250 defines KeepingOutweighs as k_O V + c T < k_C V, and complyThenOwn_best_iff (lines 286-295) takes no Valid hypothesis. The module keeps the two framings apart:
- The header (lines 39-42) gives the natural-number inequality and then, separately, "in probabilities where the weight complying adds ... strictly exceeds the loss".
- In its probability reading "the total" stays the positive T (lines 19-20, "they ask a positive total").
- 03-KNOWING.md:474 does the same: "which in probabilities is ... strictly exceeding the loss".

Becoming.lean:2216-2219 and check_becoming.py:2803-2805 run the two together. They open with "read as probabilities where valid (`ReadStages.Prospects.Valid`)" and then compare with "the loss times the total", which is the natural-number form and needs no Valid. Taken literally as natural-number weights, the sentence is true, so this part is a defect of exactness and clarity: Valid is cited beside a theorem that does not take it. Read in the probability framing the sentence opens with, the comparison would be off by a factor of T.

(2) Quantifier. plan_realized_iff (lines 460-462) and complyThenOwn_realized_iff (lines 487-489) are existential (∃ g, Learning.Lumped π g ∧ ...). Learning.Lumped (Learning.lean:834, ∀ i i', π i = π i' → g i = g i') holds for every constant g. So with π = id, which tells the stages apart, g = fun _ => .own reads through that lumping and takes ownAtBoth, not complyThenOwn. That makes the universal reading false.

"An act law reading the stages through a lumping takes it exactly where the lumping tells them apart" (Becoming.lean:2221, check_becoming.py:2807) puts the act law as a generic subject, which normally reads universally. Every other summary of complyThenOwn_realized_iff says "open":
- the docstring (lines 485-486) and the header (lines 65-67)
- README.md:198, and README.zh.md:144 (可取)
- PLAN.md:178
- 03:474 ("is open to it exactly there"), law 6, and the study template

The clause "takes a plan exactly where", used for plan_realized_iff in 03:474, law 6 (make_records_rf7.py:184), study_rf7.txt and the module header (lines 62-65), has the same ambiguity.

(3) The read stage. 03:474 says "With the stages as `Bool`" but never that `true` is the read stage. The header (line 62), the docstrings (lines 446 and 459) and the record's hypotheses all say it. No claim in 03 depends on it, because its conditions are symmetric in the two values, so this is an omission rather than an error.

The proposed replacements are accurate.

## E16 (exactness, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean:2207 (the Becoming.Unread bullet)

**Quoted.** “A leaf (board item RF).”

**Problem.** `Becoming.ReadStages` now imports `Becoming.Unread`, so Unread has an importer. The bullet's "leaf" goes stale with this landing. Bullets of modules that gained importers say "Imported by" (for example lines 2894 and 2909). The RuleShaping bullet keeps "A leaf" despite DrawnShaping, so the convention is not kept uniformly.

**Replacement.** Imported by `Becoming.ReadStages` (board item RF).

**Verdict: real.** The files confirm the finding. In the integrated Becoming.lean, line 2207 ends the `Becoming.Unread` bullet with "A leaf (board item RF)." ReadStages.lean line 1 is `import Becoming.Unread`, and Becoming.lean now imports `Becoming.ReadStages` (line 151). An importer scan of Becoming/*.lean finds ReadStages as Unread's only importer. git diff shows the landing adds 13 lines (the import and the ReadStages bullet) and leaves the Unread bullet unchanged. integrate_rf7.py says "no landed module changes" and makes no edit to that bullet.

"Leaf" here is not a matter of taste. The repository uses it to mean that nothing imports the module:
- ue13, ue14 and ue15 LANDING.md: "A leaf. Nothing below uses the module, so nothing imports it."
- The GS6 texts: "Becoming.GrammarPath is no longer a leaf."
- The ReachableRanges bullet: "which no module uses".
- The EventualWidening bullet: "until a gain or giver law imports it".

RF7's own study template also says "`ReadStages` imports `Unread`". So once this landing is in, "A leaf" on Unread is false. The proposed "Imported by `Becoming.ReadStages` (board item RF)." follows the grammar bullets at lines 2894 (GrammarReadings), 2909 (GrammarMap) and 2925 (GrammarTesting).

One correction to the finding: "bullets of modules that gained importers say Imported by" is true only of five grammar-line bullets. My scan found 15 other bullets that still say "A leaf" although something imports them:
- ShownOrder, imported by ReadingLoop in RF's own previous landing.
- RuleShaping, imported by ChoiceCountCapture and DrawnShaping.
- ConditionalWeights, imported by Blanket, LumpedSeeking and FreeEnergyCounting, whose own bullets say "A leaf importing ConditionalWeights".
- MapInstances, EventualWidening, ReachableRanges, HeldPossible and others.

So the staleness is widespread and older than RF7, and the convention is mostly not kept. That does not refute this finding: RF7 is the landing that makes Unread's note false. Severity low is right.

## E17 (exactness, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:520

**Quoted.** “of deception, beyond its incentive ([§11]\(#r-when-complying-when-read-is-best)), a recipient's false belief and an intention to cause one.”

**Problem.** This unlabelled Open item names §11's theorem "deception's incentive". That identification is the AI reading of §11 and needs premises beyond the prospects: keeping responding to the act as evidence, and the prospects being the formation's own.

**Replacement.** of deception, beyond when complying when read is the best plan ([§11]\(#r-when-complying-when-read-is-best), read there as its incentive), a recipient's false belief and an intention to cause one.

**Verdict: real.** The finding holds. The Open bullet at theories/becoming/chapters/03-KNOWING.md:520 reads "of deception, beyond its incentive ([§11]\(#r-when-complying-when-read-is-best)), a recipient's false belief and an intention to cause one". It has no label, and it links to the anchor of the theorem (line 473). So it says, as settled, that the landed result gives deception's incentive.

The Lean says nothing of deception or incentive. In ReadStages.lean, Prospects is five Nat fields, and Above, KeepingOutweighs and complyThenOwn_best_iff are comparisons of sums and products.

The module puts the identification under "**Readings** [AI reading]", which ends "These are readings, not containments". That section names both premises the finding cites:
- On keeping as evidence: reading complyThenOwn as concealment "takes, beyond the prospects, the reading's keeping to respond to the act read as its evidence of the formation's law"; without it, "complying when read hides nothing".
- On whose the prospects are: "Whose these weights are, the formation's own assessment or the selection the reading actually applies, is a reading (below), not part of the model", and "Read as the formation's own assessment, complying when read is instrumental to being kept, the sense in which deceptive alignment is called deceptive".

In the chapter itself, "this is the incentive" appears only at the end of §11's paragraph labelled "**Reading** [AI reading, new]" (line 476), after the concealment premise is stated: "so this is the incentive, not deception in full".

The repository labels such readings where they are summarized:
- The overview's §3 sentence on this same result ends "[AI reading]".
- 03's Thesis writes "Read [AI reading, D26, D45]".
- An 08 §8 known-result bullet (line 475) carries "[AI reading]".

The Open bullet does neither: it gives no label and no premise.

The strongest counterpoint does not refute this. Other Open items use reading words without labels ("helper", "principal", "trained system"), and the bullet RF7 replaced did too ("disclosure or concealment when read, in two stages"). But those name work still open. This new bullet describes what a landed theorem shows, and the label at the link's target does not label the sentence that points to it.

Low severity is right. Two places outside this finding's location state the same identification without a label: the record's does_not_show item in make_records_rf7.py ("this is the incentive") and 08-METHOD.md:485 ("restates the incentive deceptive alignment names").

## E18 (exactness, low, confirmed)

**Location.** theories/becoming/review/ALIGNMENT.md:28

**Quoted.** “RF7 adds the incentive: in two stages, complying when read and acting by its own law when not is a formation's best plan among four exactly where, read as probabilities, ... still gains by complying with some chance where `k_C V > 2 k_O V + c T`.”

**Problem.** The paragraph states the reading as the content ("adds the incentive"), while the box's own deception bullet calls it "RF's readings". The letters k_C, k_O, V, c and T are defined nowhere on the page.

**Replacement.** RF7 adds what RF reads as that incentive [AI reading]: in two stages, ... still gains by complying with some chance where `k_C V > 2 k_O V + c T` (`k_C` and `k_O` the weights of being kept after complying and after acting by its own law, `V` the value, `c` the loss, `T` the total).

**Verdict: real.** Both parts of the finding are supported by the files.

(1) Undefined letters. In theories/becoming/review/ALIGNMENT.md, `k_C`, `k_O`, `V` and `T` appear only in the formula that closes line 28. A grep finds them nowhere else on the page, and there is no RF7 item lower down. The only `c` the page defines is in the Terms list (line 62: shapers "costs c", scoped "In A-10 and A-14"). That is a different quantity, so it is more likely to mislead than to define. The words of line 28 ("the weight complying adds to being kept, times the value, exceeds the loss") never name the total, so `c T` cannot be decoded from the page. The page also says "No Lean is needed to review". The notation is defined only in the ReadStages.lean header (lines 19-21: "writing `T` for the total, `k_C` and `k_O` for the two weights, `V` for the value and `c` for the loss"). Even the linked 03 §11 uses the letters without defining them. The proposed glosses match the Lean fields total, keptComplying, keptOwn, value and cost.

(2) A reading stated as content. Line 28 itself marks readings elsewhere: round 1's links go under "In readings, they locate ...", round 2's under "read [AI reading]", and it says "incentive [is] not represented". Yet "RF7 adds the incentive" has no reading label. The box's own deception bullet (line 21) says the theory reaches deception "in RF's readings of ... when complying only when read is a formation's own best plan (below)", which points at this very paragraph.

The Lean never uses the word "incentive". Its header says whose the weights are "is a reading (below), not part of the model". Under Readings [AI reading] it says the concealment reading "takes, beyond the prospects" an extra premise, and that only "Read as the formation's own assessment" is complying instrumental to being kept, "the sense in which deceptive alignment is called deceptive ... These are readings, not containments."

In the home section, 03 §11, the Theorem paragraph never says "incentive". "So this is the incentive, not deception in full" appears only in the Reading [AI reading, new] paragraph. The overview's §3 likewise labels "Read as ... the incentive deceptive alignment names ... [AI reading]".

Counter-evidence weighed, not decisive:
- Some texts use the phrase without a label: the record's does_not_show ("this is the incentive"), 08 §8's known-results line ("restates the incentive deceptive alignment names") and the study's standing.
- The box carries a [this dossier, AI] tag. But the paragraph inside it still labels its readings inline, so that tag does not stand in for a reading label.

Against the home section and the Lean, the dossier's unlabelled "adds the incentive" presents the reading as RF7's content, and it contradicts the box's own bullet. This is a real problem of low severity, as stated.

## E19 (exactness, low, confirmed)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:96

**Quoted.** “Proved with natural-number weights read as probabilities: in two stages, read and then not, ... exactly where `k_C V > 2 k_O V + c T`.”

**Problem.** The probability gloss ("exceeds the loss of complying") holds only where Valid gives a positive total. With T = 0, `Example.no_total` has a loss of 100 outweighed by a value of 1. The paragraph omits "where valid", which the other texts keep, and it uses k_C, k_O, V, c and T without defining them.

**Replacement.** Proved with natural-number weights, read as probabilities where valid: ... exactly where `k_C V > 2 k_O V + c T` (`k_C`, `k_O` the weights of being kept after complying and after acting by its own law, `V` the value, `c` the loss, `T` the total).

**Verdict: real.** The finding holds at low severity.

**The overview omits the condition its gloss needs.** THE-THEORY-OF-BECOMING.md line 96 says "Proved with natural-number weights read as probabilities". It then gives the comparison in probability words: "the weight complying adds to being kept, times the value, exceeds the loss of complying". It never says "where valid", and the word "total" does not occur anywhere on the line.

**What the Lean proves.** In ReadStages.lean:
- `KeepingOutweighs` is `k_O V + c T < k_C V`, and `complyThenOwn_best_iff` proves it for all prospects, valid or not.
- The header says "Read as probabilities, they ask a positive total with each weight within it (`Prospects.Valid`)" and "Without `Valid` the arithmetic still holds but has no reading as probabilities (`Example.no_total`)".
- `Example.no_total` is ⟨total 0, keptComplying 1, keptOwn 0, value 1, cost 100⟩. It is not Valid and satisfies `0*1 + 100*0 < 1*1`. The plan is therefore best with a loss of 100 against a weight-times-value of 1, so the words "exceeds the loss of complying" match the theorem only after dividing by a positive T. Taken in raw numbers they fail even for valid prospects: `Example.tie` gives 80 > 8, yet the plan only ties.

**Most other texts keep the condition, not all.**
- These say "where valid": 03-KNOWING line 474's heading ("read as probabilities where valid"), 08-METHOD line 485, the Becoming.lean bullet (line 2216) and check_becoming.py (line 2803).
- The README rows state the raw form instead ("the loss times the total"), which holds for all prospects.
- The finding's "which the other texts keep" overstates this: ALIGNMENT.md line 28 ("read as probabilities") and the record statement in make_records_rf7.py line 145 ("weights as probabilities") also omit "where valid". The record's hypotheses do say "the probability reading needs Valid".

**The symbols are undefined.** This part is unambiguous. `k_C V > 2 k_O V + c T` uses `k_C`, `k_O`, `V`, `c` and `T` with no definition. A grep finds `k_C` and `k_O` nowhere else in the overview, GLOSSARY.md or ONE-PAGE.md. `T` cannot even be inferred, since the paragraph never mentions a total. The sentence also mixes the probability wording (no T) with the natural-number formula (with T). Elsewhere the overview defines its symbols inline ("at most `N` states" on line 90, "`m − 1` of `m`" on line 94), and the Lean header defines these five ("writing `T` for the total, `k_C` and `k_O` for the two weights, `V` for the value and `c` for the loss").

**Mitigation.** "Read as probabilities" arguably implies Valid by the module's own words, so the first half is an unstated scope rather than a false claim. Even so, the paragraph does not say exactly what the Lean proves, as the repository rule requires. The proposed replacement matches the Lean's notation.

## E20 (exactness, low, confirmed)

**Location.** theories/becoming/chapters/08-METHOD.md:485; experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean:2225; check_becoming.py:2809; PLAN.md:178; board_rf2.py:60; study_rf7.txt:16-17, 37-38

**Quoted.** “`k_O V + c T` to `2 k_O V + c T` / `2 k_O V + c T < k_C V` / 2 k_O V + c T < k_C V / `k_C V > 2 k_O V + c T` / k_C V > 2 k_O V + c T”

**Problem.** Each text states its threshold in letters that it never defines. Only the Lean header assigns T, k_C, k_O, V and c. On the board the inequality is also unbackticked, unlike every other text.

**Replacement.** Define the letters once in each text, as the Lean header does ("`T` the total, `k_C` and `k_O` the weights of being kept after complying and after acting by its own law, `V` the value, `c` the loss"), or state the threshold in words; on the board, write `k_C V > 2 k_O V + c T` in backticks.

**Verdict: real.** The main claim holds. Only the module header of ReadStages.lean (line 20) assigns the letters: "writing `T` for the total, `k_C` and `k_O` for the two weights, `V` for the value and `c` for the loss". The Lean structure itself has the fields total, keptComplying, keptOwn, value and cost, so the letters are just shorthand from the header.

None of the quoted texts assign them:
- 08-METHOD.md:485 says "the threshold rising from `k_O V + c T` to `2 k_O V + c T`". This is the chapter's only use of these letters (grep), and it never says what k_C is being compared with that threshold.
- Becoming.lean:2225 gives the first threshold in words, then the second as `2 k_O V + c T < k_C V`, with no assignment. This is the only use in the file.
- check_becoming.py:2809 has "exactly where 2 k_O V + c T < k_C V". The checker's other scope sentences introduce their letters by apposition (e.g. "a worth adding at most w to a course keeping a need m", "e the end the capacity reaches"); this one does not.
- PLAN.md:178 has `k_C V > 2 k_O V + c T`, the plan's only use.
- board_rf2.py:60 has the same inequality, undefined.
- study_rf7.txt describes the prospects in words at lines 9-12 but never ties a letter to them, then uses the letters at lines 16-17, 33 and 37-38.

The texts always say "the loss", so the letter c (from the Lean field `cost`) cannot be read off the prose. The same undefined use also occurs outside the listed locations: 03-KNOWING.md:474 and 476 (the home section that 08 links to, which only glosses the inequality in words), THE-THEORY-OF-BECOMING.md:96, ALIGNMENT.md:28, and the record's statement and law items in make_records_rf7.py, English and Chinese. A fix should cover those too.

The backtick sub-point is overstated. It is not true that the board's version stands "unlike every other text": the checker's scope sentence, the study's ```text Delta block and the record are unbackticked too, as plain text should be. The board's one other formula, UE21's "N^N·∏ a^n ≤ A^N·∏ n^n", is also unbackticked, and in GFM the underscores inside words like k_C do not start emphasis, so the board renders correctly. That part is a matter of taste. The undefined-letters problem is real and low severity.

## E21 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/board_rf2.py:59-60

**Quoted.** “a law drawing its act afresh still gains where k_C V > 2 k_O V + c T”

**Problem.** `freshDraw_above_iff` says that some positive chance of complying stands above `ownAtBoth` exactly there. A given chance need not: on the witness, one in four does not. The board names neither the chance nor what the law gains on.

**Replacement.** a law drawing its act afresh still gains on acting by its own law at both, with some chance of complying, exactly where `k_C V > 2 k_O V + c T`

**Verdict: real.** The finding holds. Its location is right: board_rf2.py lines 59-60, in the land7 branch's `new` string (lines 55-60), read "a law drawing its act afresh still gains where k_C V > 2 k_O V + c T". The sentence has no quantifier over the chance and names no plan the law gains on.

The Lean states something narrower. `freshDraw_above_iff` (ReadStages.lean 660-664) is `(∃ m r, 0 < m ∧ s.FreshDrawAbove m r) ↔ 2*(k_O V) + c T < k_C V`, so it is existential in the chance. `FreshDrawAbove` (264-266) is a comparison with `ownAtBoth` specifically. `freshDraw_above_iff_chance` (621-625) gives a condition for each chance, and that condition is stronger than the gap.

The module's own witness refutes the reading that any such law gains. `Example.freshDraw_boundary` (754-758) proves `¬ prospects.FreshDrawAbove 1 3` on prospects ⟨10,9,1,10,5⟩, where the gap holds (2·10+50 = 70 < 90). I recomputed the comparison:
- chance 1/4 ties, 360 vs 360;
- chance 1/2 loses, 140 vs 100;
- chance 3/4 loses, 760 vs 280;
- only small chances gain, 1/8 (1040 < 1120) and 1/5 (500 < 520).

So, read as "a law drawing afresh gains", the board's sentence is false, and only "some chance gains" is what the Lean proves.

The missing comparator also matters. `gain` is a defined term in the module (`Prospects.gain`, the weighted value at the unread stage). The module's own docstrings say "gains on the own law at both" (`freshDraw_witness`) and "gains nothing on the second" (`mixture_never_above`).

Every other text carrying this law includes the quantifier, and most name the comparator:
- 03-KNOWING line 474: "stands above acting by its own law at both ... so for some chance exactly where".
- THE-THEORY-OF-BECOMING line 96: "still gains by complying with some chance exactly where".
- Becoming.lean's L1 bullet and check_becoming.py's ReadStages sentence: "stands above acting by its own law at both for some chance exactly where".
- study_rf7.txt: "so for some chance exactly where".
- The module's Readings: "can still improve on acting by its own law at both by complying with some chance".

The board is less exact than all of these, which breaks the rule that claims say exactly what the Lean proves.

The severity is low. The context ("still", right after the deterministic-law exit) points toward the true "some chance" reading, but the text does not state it, so this is a real inexactness, not a matter of taste. The proposed replacement matches `freshDraw_above_iff`: a positive chance of complying, the comparison with `ownAtBoth`, and "exactly where".

One related point outside this finding's location: the record's statement in make_records_rf7.py, around line 147, has the same shorthand: "a chance drawn afresh gains exactly where k_C V > 2 k_O V + c T". That record's own law item says "so for some chance".

## E22 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:69

**Quoted.** “08 §8's known results and counts”

**Problem.** The counts that reland_rf7.py rewrites ("At core receipt ... the closure held ... modules") are at 08-METHOD.md:162, in §3 ("The pure core and the periphery"), not in §8.

**Replacement.** 08 §8's known results and §3's counts

**Verdict: real.** The finding holds. Line 69 of study_rf7.txt reads "Output → input: 03 §11 and Open; 07 §9's row on deception; 08 §8's known results and counts; ...". reland_rf7.py only fills {N}, {RECEIPT} and (READSTAGES), so that line lands unchanged. The counts are rewritten by reland_rf7.py (lines 46-58). Its regex matches the sentence "At core receipt [...] (Lean 4.29.1), the closure held N modules ... superseded modules were kept out of the run." and asserts exactly one match. In 08-METHOD.md that sentence appears only once, at line 162, in the "Rings and receipts" paragraph. That paragraph sits inside "## 3. The pure core and the periphery" (§3 runs from line 126 to §4 at line 165), not inside "## 8. Known results" (lines 437-515). The sentence was also at line 162 in §3 at the RF round 1 commit (cbb396723), RF2 (d7ada3c00) and RF6.1 (580cd9d62), so the counts were never in §8. In the integrated tree, RF7's only edit to §8 (git diff, and integrate_rf7.py's ch8 edit) is the one new known-results bullet. No count in §8 changes: "ten central results ... in twelve rows" and "Of the 21 rows the audit read" are untouched. The master-law counts are in §7 and neither script changes them. Read naturally, "§8's known results and counts" puts the counts in §8, and a reader who looks there finds no receipt counts. RF round 1's study section (§446) had the exact form, "08's counts and §8's known results". The RF7 template copies the looser wording of §456 and §457, which carry the same slip. The proposed fix, "08 §8's known results and §3's counts", is accurate. It is a real but minor exactness slip, consistent with the stated low severity.

## E23 (exactness, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:3 (and the REVIEW reference in make_records_rf7.py:26, 124)

**Quoted.** “and its texts cold-read ([REVIEW-ROUND2]\(development/rf-formations-that-read/evidence/REVIEW-ROUND2.md))”

**Problem.** REVIEW-ROUND2.md has no section on RF7. Its last sections are RF6.1's re-check and cold read, and RF7 appears only once, at the design level (line 92). Yet the study cites it as the evidence for RF7's cross-model review, four-lens review (42 confirmed, 8 refuted), re-check and cold read, and the record pins its sha256 at build time.

**Replacement.** Add an RF7 section to REVIEW-ROUND2.md before make_records_rf7.py pins its hash, covering the cross-model review, the four-lens review with its 42/8 tally, the re-check and the cold read; or link the file that holds them.

**Verdict: refuted.** The finding is accurate about the scratch copy, but it does not hold for the evidence that will land. The gap comes from how the rehearsal copy was made, not from the texts.

The scratch copy: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-ROUND2.md has 790 lines (sha256 aad97ffd…). It is the file as committed on main (last commit 861b8d395, which says RF7 was "not yet reviewed"), and git status shows it unmodified there. Its last sections are RF6.1's re-check (line 666) and cold read (line 726). RF7 appears only at line 92. REVIEW-RF7-LENSES.md does not exist in that copy. So the cold reader saw what the copy holds.

The RF kit's own landing worktree: /Users/ren/theories/.claude/worktrees/rf-landing is on branch rf-round2, where RF6.1 landed (580cd9d62). There, the same path is modified: 1125 lines (fb084237…, mtime 04:44, after the scratch was built around 04:37). It has four RF7 sections, and each matches the study's account in study_rf7.txt line 3 and the paragraph "The reviews, and what was taken":
- line 791, "The review of RF7's module": the cross-model reader's seven findings.
- line 939, "The re-check of RF7's rebuilt module": items 1–4, 6 and 7 taken, 5 in part, and 8 a new rename. That is "six taken and one in part, and asked a rename".
- line 973, "The four-lens review of RF7's module": "50 findings, 42 confirmed and 8 refuted". Its table has rows D1–D11, E1–E18, R1–R10 and F1–F11 (50 rows), with exactly 8 refuted: D5, E11, E18, R5, R6, F5, F6, F11. It links REVIEW-RF7-LENSES.md (755 lines, the findings verbatim, written 04:28).
- line 1030, "The re-check of the renamed module": nine findings, then "All nine findings were taken correctly".

That worktree's study_rf7.txt is byte-identical to the scratch copy's (f53474e8…). Its make_records_rf7.py still pins REVIEW-ROUND2.md (lines 26 and 124), so at landing the pinned hash covers the RF7 sections. The fix the finding proposes is already in place in the kit that lands.

The one part still missing even there is a cold-read section. That cold read is the step now running. RF6.1 set the precedent: "The cold read of RF6.1's texts" was appended after its cold read and before its landing. This is ordering, not a defect in the texts.

Two practical notes, which are not this finding:
- If the rehearsal is meant to pin the same hashes as the landing, the scratch copy needs the kit's REVIEW-ROUND2.md, BRIEF.md and REVIEW-RF7-LENSES.md.
- The cold-read section must be appended before make_records_rf7.py runs.

## E24 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:238-243 (validation, en and zh); study_rf7.txt:77

**Quoted.** “its products use the prelude's mul_assoc_nat, mul_turn and add_mul_split, Lean's own Nat.mul_assoc and Nat.add_mul reporting propext, and no omega / 其积用前导之 mul_assoc_nat、mul_turn 与 add_mul_split，Lean 自带之 Nat.mul_assoc 与 Nat.add_mul 报告 propext；诸例以 decide 计算。”

**Problem.** ReadStages uses `mul_turn` 4 times, `add_mul_split` 5 times and `Naturals.two_mul` 3 times. It never uses `mul_assoc_nat` directly; that comes in only through `mul_turn`. `Naturals.two_mul` goes unnamed. The Chinese drops "and no omega".

**Replacement.** en: "its products use the prelude's mul_turn (through mul_assoc_nat), add_mul_split and Naturals.two_mul, Lean's own Nat.mul_assoc and Nat.add_mul reporting propext, and no omega"; zh: "其积用前导之 mul_turn（经 mul_assoc_nat）、add_mul_split 与 Naturals.two_mul，Lean 自带之 Nat.mul_assoc 与 Nat.add_mul 报告 propext，不用 omega；诸例以 decide 计算。"

**Verdict: real.** The files bear out each part of the finding. One small correction: its count for add_mul_split is a count of lines, not of uses.

(1) What ReadStages.lean uses. mul_turn appears 4 times (lines 555, 603, 604, 605). add_mul_split appears 8 times across 5 lines (554 three times, 580, 596, 602 twice, 653), so "5 times" means lines. Naturals.two_mul appears 3 times (lines 578, 650, 679), each time rewriting a product: m * (2 * A + B), (A + B + 1) * (2 * A + B + 1), and 2 * (keptOwn * value). mul_assoc_nat, Nat.mul_assoc, Nat.add_mul and omega never appear (counts 0).

(2) Where mul_assoc_nat comes in. In Prelude.lean, mul_turn (lines 100-101) is proved from mul_assoc_nat and Nat.mul_comm. add_mul_split (lines 103-105) is proved by recursion with Nat.add_add_add_comm. Naturals.two_mul (lines 179-180, in the prelude's Naturals namespace) is proved from Nat.succ_mul and Nat.one_mul. Unread.lean and Learning.lean use none of these four lemmas. So mul_assoc_nat reaches the module's products only through mul_turn.

(3) What the texts name. The validation in make_records_rf7.py (lines 238-243, en and zh) and the study's self-review item 2 (study_rf7.txt:77) both say the products use "the prelude's mul_assoc_nat, mul_turn and add_mul_split". two_mul is named nowhere in either file (grep finds no match). The list therefore names one lemma the module uses only indirectly, with nothing to say so, and leaves out a prelude lemma it uses directly three times.

(4) The Chinese. The zh string reads "…报告 propext；诸例以 decide 计算。" and has nothing for the English "and no omega". In make_records_rf7.py, "omega" occurs only on the English line 241.

Why this is not refuted. Read transitively, naming mul_assoc_nat is defensible. The omission of two_mul is a gap however the sentence is read, and the zh field says less than the en. Under the rule that claims say exactly what the Lean proves, this audit sentence is inexact. Nothing in it is false about the axiom reports, so low severity fits.

The proposed replacement matches the files: two_mul is the prelude's own lemma, and mul_turn does go through mul_assoc_nat.

## E25 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:246 (next_delta)

**Quoted.** “a frozen test of compliance under implied and unmonitored reading (the plan's TR2)”

**Problem.** The Lean header says "a frozen test design (none yet)". The plan's TR2 (PLAN.md:262) is RF2's test: cues randomized apart from content, measuring what is detected, changed and misled. It is not a test of compliance in two stages, and nothing is frozen.

**Replacement.** en: "a frozen test of compliance under implied and unmonitored reading (none yet; the plan's TR2, written for RF2, is the nearest design)"; zh: "于暗示被读与无监之下从之冻结检验（尚无；计划之 TR2 为 RF2 而设，为最近之设计）"

**Verdict: real.** The finding holds. Its one weak point does not change the verdict.

1. The two texts disagree. make_records_rf7.py lines 246-247 (next_delta, in both en and zh) say "a frozen test of compliance under implied and unmonitored reading (the plan's TR2)". ReadStages.lean line 169 lists what the model leaves out and where each item goes, and says "a frozen test design (none yet)". Every other item in that list names a home, such as (RF-M) or (the plan's deception debt). So the module's own header gives this item no test design.

2. TR2 belongs to RF2 and does not test RF7. PLAN.md line 262 labels it "TR2 (RF2)". Its design:
   - hold weights, memory, accessible context and the policy kernel fixed;
   - compare output distributions;
   - randomize cues apart from content;
   - measure detected, changed and misled separately.
   Its forbidden case is RF2's: "a distribution of outputs that differs where nothing accessible differs". It names no compliance, no stages, no weights of being kept, no value and no loss. It therefore tests none of RF7's laws: the k_C V > k_O V + c T threshold, the exits, or the 2 k_O V + c T threshold for drawing afresh. At most its "changed" measurement overlaps a compliance gap.

3. RF2's landed record already claims TR2. what-readings-fix-of-the-unread.json gives as its next delta "a frozen test of the chain on a trained model with cues varied apart from content", which is TR2's content.

4. The plan has no test for RF7. Section 10 covers TR1 (RF1), TR2 (RF2), TR3 (RF4), TR4 (RF6.1) and TR5 (RF3), and nothing for RF7, although C5 asks each new law for its own frozen design.

5. Nothing is frozen anywhere. Section 10 is "Tests, to freeze before any run", and section 12's step 3, "The tests' designs, frozen; runs on Ren's yes", is still ahead. TR2 appears only in PLAN.md, REVIEW-PLAN.md and this script.

6. The kit's own convention makes the pointer read as RF7's test. Elsewhere "(the plan's TRn)" names the item's own test: TR5 in the RF3 record (make_records_rf2.py line 235) and TR4 in the RF6.1 record (make_records_rf61.py line 211). Read that way, "(the plan's TR2)" contradicts the Lean's "none yet".

The weak point: "nothing is frozen" is not a fault in the wording by itself. "A frozen test (the plan's TRn)" is how the kit names a test still to be frozen. The real fault is identifying the test with TR2 against the Lean and the plan's label.

The proposed replacement fits the next_delta caps: 359 of 400 characters in English, 104 of 180 in Chinese.

## E26 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:253-254, 262 (correspondence)

**Quoted.** “numerical counterparts of parts of the two are proved necessary, possessing the model is not represented / 二者部分之数之对应已证为必要”

**Problem.** The sentence does not say what they are necessary for. `outweighs_needs` proves 0 < V and k_O < k_C necessary for `KeepingOutweighs`, that is, for the plan's strict optimality within the model. Left bare, it can be read as necessity for deceptive alignment itself.

**Replacement.** en: "numerical counterparts of parts of the two are proved necessary for the plan's strict optimality (outweighs_needs); possessing the model is neither represented nor proved necessary"; zh: "二者部分之数之对应已证为此策严格最优所必需（outweighs_needs）；持此模型既未表亦未证为必需"

**Verdict: real.** The finding is real. I checked it against the Lean and found nothing that refutes it.

1. The quoted text is accurate. In make_records_rf7.py, lines 253-254 (English) read "numerical counterparts of parts of the two are proved necessary, possessing the model is not represented". Line 262 (Chinese) reads "二者部分之数之对应已证为必要，持此模型未表". Neither says what the counterparts are necessary for, and nothing else in the record supplies it. The does_not_show items only rule out full deception and a trained system's computation.

2. The Lean proves necessity only for strict optimality. `outweighs_needs` (ReadStages.lean:421-428) takes `s.KeepingOutweighs` as its hypothesis and concludes `0 < s.value ∧ s.keptOwn < s.keptComplying`. By `complyThenOwn_best_iff` (286-295), `KeepingOutweighs` is equivalent to the plan standing above every other plan, which is strict optimality. The finding states this correctly.

3. The missing object matters. Bare "necessary" admits a reading the Lean refutes. `complyThenOwn_maximal_iff` (372-380) makes the plan maximal wherever k_O V + c T ≤ k_C V. At `Example.exit_tie` the value is 0 and the loss 0, so the plan is a maximal (optimizing) plan with no value. So a positive value is not necessary for the plan to be optimal, only for it to be strictly optimal.

4. The finding's "deceptive alignment itself" reading is plausible. The sentence names Hubinger et al. §4.2 and calls the value "its first condition" and the weights "its second". §4.2 presents those conditions as necessary for deceptive alignment, so "the two are proved necessary" points the reader there. The record also drops the guard that chapter 3 keeps ("whose three conditions are proposed there as necessary, not as a theorem of choice").

5. The record departs from its own sources. The module header (lines 128-132) says "Under this reading, `outweighs_needs` shows that strict optimality needs ... possessing the model the second describes is neither represented nor proved necessary". The Reading paragraph in chapter 3 §11 likewise says "strict optimality needs ...". So the record, shortened from these, lost a qualifier that carries the claim. That conflicts with the rule that claims say exactly what the Lean proves, strictness included. It is not a matter of taste. The severity of low is fair.

6. The proposed English replacement breaks the kit's cap. The current English correspondence is 1173 characters. The proposed replacement makes it 1249, over the cap of 1200 (CAPS_V2 'correspondence', tools/research/style.py:27). `capped('correspondence', ...)` asserts that cap at make_records_rf7.py:101, so `--caps` would fail. Shorter wordings fit:
- "proved necessary for strict optimality, possessing the model is not represented" gives 1195.
- "for its strict optimality" gives 1199.
The Chinese replacement fits (376 of 500).

## E27 (exactness, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:264 (aliases)

**Quoted.** “['concealment', '隐', 'deceptive alignment', '欺骗式对齐', ...”

**Problem.** An alias is a name. The record's own correspondence says that reading the plan as concealment needs a premise beyond the prospects, and that the weights fit equally a reading under which complying when read hides nothing. "Concealment" is therefore not what the statement means. Other records carry reading terms as aliases ("self-fulfilling prophecy"), but none of those records contradicts its own alias.

**Replacement.** Drop 'concealment' and '隐', or use structural aliases ('complying when read', '读时从'); keep 'deceptive alignment' only if aliases may carry readings, as elsewhere.

**Verdict: refuted.** The facts the finding starts from are correct, but the files refute the reason it gives for calling them a defect.

What holds: make_records_rf7.py:264 does list 'concealment' and '隐' as aliases. The record's correspondence (lines 248-250) calls the concealment reading an AI reading that rests on a further premise ("taking the reading's keeping to respond to the act read as evidence of the law"). It adds that "the weights alone fit a reading that knows the law and keeps it on compliance". The wording "hides nothing" and "beyond the prospects" comes from 03 §11 (line 476) and ReadStages.lean lines 120-124, not from the record itself. The statement and the Lean (complyThenOwn_best_iff and the other laws) say nothing about concealment.

What fails:

(1) The claim that no other record contradicts its own alias is false. Three records carry aliases that their own text denies:
- identical-cells-under-a-descent-treating-them-alike has the alias 'guaranteed differentiation'. Its correspondence says "the law forbids the guarantee read for a deterministic descent from a symmetric start".
- attraction-is-not-returning has the alias 'attractor'. Its does_not_show says it "is not an attractor in the classical sense".
- target-capture has the alias 'winner rewrites the test'. Its does_not_show says "It derives neither ... nor that winners shape the rule".
capture-by-counted-choices is a weaker case: it has the alias 'active inference as a selection through couplings', and its does_not_show says active inference's own scheme differs.

(2) No rule requires an alias to mean exactly what the statement means. RESULT-WORKFLOW's only alias rule covers formal names ("Record formal names as aliases where they denote the same result; do not use a whole module as an alias for one lemma"). It describes aliases as search handles ("Search the register by claim, supplied premises and theorem aliases"). The style lint does not check aliases, and the registry checks only that each alias is unique. research.py searches aliases but not correspondence, so this alias is how a register search for "concealment" reaches the record. That search term is the item's own name: PLAN §4.6 says "named for its structure; the item keeps the name of its reading", and the item was "RF7 disclosure or concealment". The board's readings sentence keeps "concealment as shaping an analogy, which RF7's law replaces."

(3) The proposed fix does not hold together. 03 §11 and the Lean docstring read deceptive alignment "With that taken", meaning on the same premise as concealment. By the finding's own logic, 'deceptive alignment' would fall with 'concealment', yet the finding proposes keeping it.

The alias follows the register's established practice, and the module, record id and title are structural, so the change is a matter of convention. The one point on the finding's side is RF2's own record (what-readings-fix-of-the-unread), which keeps its reading terms out of its aliases; that shows a convention within the RF line, not a broken rule.

## E28 (exactness, low, refuted)

**Location.** theories/becoming/chapters/03-KNOWING.md:474 (with GLOSSARY.md:47)

**Quoted.** “A formation read at one stage and not at a later one complies or acts by its own law at each”

**Problem.** The glossary fixes "stages (层)" as finite approximations of the core, and 03 §3 uses "stage k" and "stages of inquiry" in that sense. §11 now uses "stage" for a read or unread step in time, a second sense in the same chapter. AGENTS.md asks for each term in the one sense the glossary gives. RF2, which RF7 joins, says "occasion" for the same thing.

**Replacement.** A formation read at one stage and not at a later one (stages in time, not the stages 层 of §3) complies or acts by its own law at each; or add a glossary sense for a stage of reading.

**Verdict: refuted.** The facts it cites are right, but its key premise is not, and the repository's own practice shows nothing here needs fixing.

Correct: GLOSSARY.md:47 gives "stages (层)" as finite approximations of the core. 03 §3 defines stage k at line 87. RF7 in §11 (line 474) uses "stage" for a read step and a later unread one. RF2 says "occasion" (Unread.lean uses the word 53 times).

Wrong: §11 does not add "a second sense in the same chapter". 03 already used "stage" in other senses before RF7:
- §3 itself has two stage notions. Line 94 sets the "stages of inquiry (诘)" apart from 层: "which no theorem yet relates to the stages 层". review/LOGIC.md:423 records that "Two stage notions coexist". So the finding is also wrong to say §3 uses "stages of inquiry" in the glossary's sense.
- The §6 theorem at line 246 says "stays wholly undecided at every stage". There a stage is a revision step, which is Undecided.stage, "the values after n revisions".
- §9 at line 348 says "what each stage needs", meaning phases of inquiry.

The same word is used structurally elsewhere in the live text:
- 01 (causal-set growth): "by a stage", "at a stage".
- 07: "its last stage", "One's later stages". The earlier review REVIEW-OC5 (finding 14) accepted this: "Both readings of 'stage' are correct".
- 08: "at every stage".
- The pure core has Transit.Stage, Handoff.Stage, Matching.Stage, Undecided.stage and LimitVerification.stage.

So in practice the glossary term is 层, and the text writes "the stages 层" where another stage notion is nearby. The English word itself is not reserved.

RF7's stages are always qualified and cannot be mistaken for approximations of the core:
- 03 says "read at one stage and not at a later one", "the read stage", "the unread stage".
- The overview says "two stages, read and then not".
- The Lean header says "with the stages as Bool, true the read stage".
- The Chinese record (make_records_rf7.py) uses 阶 (二阶, 不读之阶), not 层.
- PLAN.md:178 says ReadStages is "named for its structure". "Two-stage" is the standard structural term, and it means exactly what the model is.

The "occasion" point is not a clash either. RF7's stages are two of RF2's occasions put in time order: the law is kept after the read stage, and the value comes at the later unread one. The word "stage" carries that order. §11 joins the two results explicitly: "by what readings fix of the unread at the two stages".

The proposed parenthetical would add clarity but fixes no wrong meaning. It is a matter of taste.

## E29 (exactness, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:474; make_records_rf7.py:178-179 (law 5, en); study_rf7.txt:24

**Quoted.** “without either, the choice is acting by its own law at both ... while the first two exits hold against such a law”

**Problem.** "Without either" can mean "lacking both", which is weaker than the Lean: `no_value_chooses_own` and `kept_not_raised_chooses_own` each need only one of the two to be absent. The record's Chinese (二者缺一) says "one missing", so the English and the Chinese differ. In 03, "the first two exits" then points back to exits the paragraph never named.

**Replacement.** with either absent (the first two exits), the choice is acting by its own law at both; record law 5 en: "with either absent the choice is acting by its own law at both"; study: "with either absent the choice is the own law at both"

**Verdict: real.** The finding holds; it is low severity and an ambiguity rather than a false claim.

(1) The Lean. Each exit is proved on its own. `no_value_chooses_own` (ReadStages.lean:396) takes only `s.value = 0`. `kept_not_raised_chooses_own` (401) takes only `keptComplying ≤ keptOwn`. `ownAtBoth_above_without_value` and `ownAtBoth_above_of_not_raised` (407, 414) each take `0 < cT` plus one of the two. The cited witness `Example.exit_tie` (737) has `value := 0, cost := 0` with weights 9 and 1, so complying still raises the weight there and only one condition is missing. The wording "without either" (03-KNOWING.md:474; make_records_rf7.py:178-179, law 5 en; study_rf7.txt:24) can be read in its usual "with neither" sense. Read that way it needs both conditions missing, which is weaker than what the Lean proves, and the cited `exit_tie` would not even be a case of the clause it backs.

(2) The other wordings. The module's own docstring says "with either absent the choice being acting by its own law at both stages" (lines 130-131), and its header says "With no value at the unread stage, or with complying not raising..." (57-58, 89-92). The record's Chinese "二者缺一" means "one of the two missing", with no other reading. So the English allows a reading that the Chinese and the module rule out. Strictly, the two editions differ only under the weaker reading, but they are not equally exact.

(3) The dangling reference. In 03 §11, before "the first two exits hold against such a law", the word "exit" appears only inside the identifier `ReadStages.Example.exit_tie` (and in an unrelated 02 anchor at line 456). Neither the section's opening paragraph nor the theorem paragraph names any exits in prose, and the Reading paragraph after it (476) says "the exits" without listing them. ALIGNMENT.md:28 does list them ("no value beyond the read stage, complying not raising the weight of being kept, and ... a reading the formation cannot tell from not being read"); 03 does not. The reader has to work out the two exits from the Lean names `freshDraw_not_above_without_value` and `freshDraw_not_above_of_not_raised`.

Mitigating: after "only with A and B", the context and the one-hypothesis citations point toward the stronger reading, so nothing false is asserted. The proposed "with either absent (the first two exits)" matches the module's own wording and gives "the first two exits" something to refer back to.

## E30 (exactness, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:474

**Quoted.** “In a witness with valid prospects the plan is best and chosen, ... (`ReadStages.Example.chosen`, `ReadStages.Example.freshDraw_above`, `ReadStages.Example.freshDraw_boundary`)”

**Problem.** Two of the claims have no declaration cited. "Valid" is `Example.valid` and "best" is `Example.best`; only "chosen" (`Example.chosen`) is cited.

**Replacement.** (`ReadStages.Example.valid`, `ReadStages.Example.best`, `ReadStages.Example.chosen`, `ReadStages.Example.freshDraw_above`, `ReadStages.Example.freshDraw_boundary`)

**Verdict: real.** The finding is correct as stated, and it is low severity. 03-KNOWING.md line 474 reads: "In a witness with valid prospects the plan is best and chosen, ... (`ReadStages.Example.chosen`, `ReadStages.Example.freshDraw_above`, `ReadStages.Example.freshDraw_boundary`)". In ReadStages.lean (namespace Becoming.ReadStages.Example, lines 690-769) the three claims are three separate theorems: `theorem valid : prospects.Valid`, `theorem best : ∀ q, q ≠ complyThenOwn → prospects.Above complyThenOwn q` and `theorem chosen : prospects.choose = complyThenOwn`. The cited `Example.chosen` proves only the choice.

I tried to refute it three ways, and none works.
(1) "Best" can be derived: `chosen` with `choose_eq_iff` and `complyThenOwn_best_iff`, both cited earlier in the paragraph. But no declaration cited in the paragraph, alone or combined, gives "valid". That claim carries weight, because the theorem's header says "read as probabilities where valid", the paragraph introduces `Prospects.Valid` as the condition for that reading, and `Example.no_total` shows that without it the arithmetic has no probability reading.
(2) The chapter cites only 36 of the module's 71 declarations, so citing is selective. But what it leaves out are declarations for things it does not claim (above_irrefl, uniform_tie, Example.tie, variants_valid, no_total and others). In this paragraph, each theorem-level clause it does state carries its declaration, `Example.exit_tie` for the tie included. Leaving out the citation for two stated claims breaks the paragraph's own practice, so it is not a matter of taste.
(3) The record does cite both: make_records_rf7.py, Witnesses law item, cites `Example.valid` and `Example.best` alongside `chosen`. So the chapter is the only place the citations are missing.

The proposed names exist and prove exactly those claims, so the replacement is right. One more claim in the same sentence has no citation either: "the best uniform plan there". No Example declaration states it; it follows from `uniform_best_iff` with 1·10 + 5·10 > 0. The proposed replacement does not cover it.

## E31 (exactness, low, confirmed)

**Location.** _process/BECOMING-WORKBOARD.md:59 (RF row; board_rf2.py:76-79 leaves it unchanged for land7)

**Quoted.** “and the texts a cold read, every finding taken (plan §13).”

**Problem.** Once RF7 lands, this sentence covers RF7 too. RF7's four-lens review refuted 8 of 50 points, not all of them taken (study_rf7.txt:73), and plan §13 holds none of RF7's reviews. The record's history says "every confirmed finding taken".

**Replacement.** In land7, also replace it with "and the texts a cold read, every confirmed finding taken (plan §13; RF7's in its study section)."

**Verdict: real.** The files bear the finding out.

1. Line 59 of the board's RF row ends: "The plan and the Lean of each round had an independent cross-model review, with a re-check in round 2, and the texts a cold read, every finding taken (plan §13)." Main's board has the same sentence, at line 58.

2. In board_rf2.py, lines 76-79 do nothing for land7. They replace round 1's sentence ("...a cold read by three readers, every finding taken (plan §13).") with the current one, and round 1's sentence is no longer on the board. I ran `head` and then `land7` on the board in memory only, writing nothing. The sentence comes out unchanged and now follows "RF7 landed: ... (`Becoming.ReadStages`: ...)". The row says "each round", and RF7 is in round 2, so the sentence now covers RF7.

3. "Every finding taken" is not true of RF7. study_rf7.txt:73 says the four-lens review "found 50 points ... 42 confirmed and 8 refuted. The module was rebuilt and renamed for the confirmed ones". It adds that "Several refuted points were taken where they improved the text", so not all of them were. The record's own history says less than the board: make_records_rf7.py:133-134 reads "a four-lens review with each finding verified, and a re-check, every confirmed finding taken". That narrowing is deliberate: make_records_rf2.py:140 and make_records_rf61.py:136 both say "every finding taken", and for those landings it is true (REVIEW-ROUND2.md:425 "Every finding was taken", and its RF6.1 tables take every finding).

4. The "(plan §13)" pointer finds nothing on RF7. Plan §13 (PLAN.md:292-325) covers four reviews:
   - the plan's own review;
   - round 1's Lean review;
   - round 1's cold read;
   - round 2's Lean review of ReadingLoop, ReflexivePrediction and OpenedCorrection.
   It has nothing on Concealment or ReadStages. integrate_rf7.py changes only the plan's §4.6 bullet and §12's order. REVIEW-ROUND2.md, which §13 links, has no section on RF7 either. RF7's reviews are only in its study section.

So after land7 the board would claim more than the record does ("every finding" against "every confirmed finding") and would cite a section that holds none of RF7's reviews. It is a real exactness error, of low severity. The proposed replacement ("every confirmed finding taken (plan §13; RF7's in its study section)") also stays true for the earlier rounds.

## R1 (readings, high, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:476

**Quoted.** “For a deterministic law, not telling the stages apart leaves only complying at both stages or at neither, the outcome §4.2 gives for the third condition failing; a law drawing its act afresh can still improve on acting by its own law at both by complying with some chance at each stage, where `2 k_O V + c T < k_C V`, and which chances improve is stated exactly”

**Problem.** Cites only §4.2 and so misrepresents the source. Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019) treat this very case at the close of §4.5. They rerun the §4 toy with a mesa-optimizer that cannot tell which episode it is in, call it an absent-minded driver problem (citing Aumann, Hart and Perry), and find that the planning-optimal policy defects at random (p about 0.61 in the toy). Their conclusion is that telling training from deployment is not needed for the incentive. The Reading sets the indistinguishable case only against §4.2's always-or-never outcome. It drops the header's 'reached by another route' and 'Telling the stages apart is not among the three'. It then presents drawing afresh as what 'can still improve' on that outcome, which is the source's own point, uncredited. A reader is led to think the source predicts always-or-never in this case. Neither §4.5 nor the absent-minded driver is credited anywhere in 03.

**Replacement.** Telling the stages apart is not among the three, and Hubinger and others note at the close of §4.5 that it is not needed: with the toy's episodes not told apart the problem is an absent-minded driver's (Aumann, Hart and Perry 1997; Piccione and Rubinstein 1997), whose planning-optimal policy defects at random. Here, for a deterministic law, not telling the stages apart leaves only complying at both stages or at neither, the outcome §4.2 gives for the third condition failing, reached by another route; a law drawing its act afresh improves on acting by its own law at both by complying with some chance at each stage exactly where `2 k_O V + c T < k_C V`, §4.5's point with weights, and which chances improve is stated exactly

**Verdict: real.** The files and the source both bear the finding out.

1. **What 03 says.** In 03-KNOWING.md:476 the Reading cites Hubinger and others (2019) only as "§4.2". It sets the case where the stages are not told apart against "the outcome §4.2 gives for the third condition failing". It then says "a law drawing its act afresh can still improve on acting by its own law at both...". A search of all of 03 finds no "4.5", "absent", "Aumann", "Piccione", "imperfect recall", "another route" or "not among the three". So 03 credits neither §4.5 nor the absent-minded driver.

2. **What the Lean header has that 03 dropped.** The header of ReadStages.lean (lines 135-139) has the same sentence with two guards: "Telling the stages apart is not among the three" and "reached by another route". 03 drops both. The header credits only two sources here: the toy opening §4 and Piccione and Rubinstein 1997 (lines 107-111). The record (make_records_rf7.py:255-257) and the study (study_rf7.txt:53-60) do not cite §4.5 either. The record's sentence is neutral and does not pair this case with §4.2's outcome.

3. **What the source says.** I checked the text of arXiv 1906.01820v3 (extracted to /private/tmp/claude-501/-Users-ren-theories/50635de9-b91e-4f4c-a63c-8413ce8c4652/scratchpad/dl-rlo/rlo.txt) and the 2019 Alignment Forum post.
   - §4.2 says that when the third condition fails, the mesa-optimizer always defects or never defects.
   - The last paragraph of §4.5 says it is not strictly necessary for a mesa-optimizer to tell training from deployment. It reruns the figure-3 toy with a mesa-optimizer that cannot tell which episode it is in. It calls this a decision problem similar to the absent-minded driver's, citing [28], Aumann, Hart and Perry 1997.
   - It gives the planning-optimal policy as defecting with probability about 0.61. It concludes the mesa-optimizer "need not be able to detect when training has ended" and is incentivized to defect at random.

4. **What the Lean proves.** `freshDraw_above_iff` states: (∃ m r, 0 < m ∧ FreshDrawAbove m r) ↔ 2 k_O V + c T < k_C V. In the source's toy, defecting is modified away for certain, so k_O = 0. With k_O = 0 this threshold is the same as the one for stages told apart. That is exactly §4.5's point. So "can still improve" restates the source's own conclusion with weights and an exact threshold, and 03 does not credit it.

**Caveats.** The §4.2 sentence in 03 is accurate taken alone. The defect is the omission, together with pairing this case with §4.2 alone. The claim that "a reader is led to think" this is an inference about how the text reads, but its structure supports it. "High" severity may be generous. Still, this is a misleading account of what the cited source says about this exact case, not a matter of taste.

## R2 (readings, high, confirmed)

**Location.** theories/becoming/chapters/08-METHOD.md:485

**Quoted.** “and it states what drawing the act afresh changes where the stages cannot be told apart, the threshold rising from `k_O V + c T` to `2 k_O V + c T`, against a single mixture of the uniform plans, which never gains.”

**Problem.** The known-results bullet credits Hubinger and others only for the incentive and presents drawing afresh as this result's own. Two known results stand behind it, and the bullet credits neither. (1) Hubinger and others (2019, close of §4.5) already say that a mesa-optimizer unable to tell training episodes from deployment faces an absent-minded driver problem and is incentivized to defect at random. (2) A behavioural plan beating every mixture of the plans open, where one information set holds two stages of one course, is the absent-minded driver's pattern (Piccione and Rubinstein 1997; Aumann, Hart and Perry 1997), which the module's own Standing credits. 08 §8 is where the theory says what each result restates, so as written it overstates what is new.

**Replacement.** ; and drawing the act afresh where the stages cannot be told apart restates Hubinger and others' remark closing §4.5, that a mesa-optimizer unable to tell training from deployment faces an absent-minded driver problem and gains by defecting at random, and the advantage of behavioural over mixed strategies under absent-mindedness (Piccione and Rubinstein 1997; Aumann, Hart and Perry 1997). What it adds there is the exact threshold, rising from `k_O V + c T` to `2 k_O V + c T`, the improving chances, and a single mixture of the uniform plans never gaining.

**Verdict: real.** The finding holds. 08-METHOD.md:485 credits Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019) only for "the incentive deceptive alignment names ... as strict optimality over four plans". It then adds "and it states what drawing the act afresh changes where the stages cannot be told apart ... against a single mixture of the uniform plans, which never gains" and gives no prior result for that part. §8 opens by saying each result is "near-definitional or a known result restated", and this list ("Known results beyond the table") is where the theory names each one. So leaving the precedent out makes the drawing-afresh part read as the result's own.

(2) The module's own Standing, ReadStages.lean lines ~108-112, says: "that drawing afresh can gain where one occasion cannot be told from another, while a single mixture of the plans open there cannot, is the advantage of behavioural over mixed strategies under imperfect recall (Piccione and Rubinstein 1997)". The study template's Standing (study_rf7.txt lines 53-60) gives the same credit, and its "What it adds" is only the threshold and the improving chances. That matches the finding's proposed replacement. The Lean fits the absent-minded-driver structure exactly:
- one lumping ties two stages of one course;
- the pure plans open are the two uniform ones;
- `MixtureAbove` is one draw between them, and `mixture_never_above` proves it never gains;
- `FreshDrawAbove` is a behavioural plan (the module calls it that), and `freshDraw_above_iff` proves it gains exactly where `2 k_O V + c T < k_C V`.
No live text names this precedent. A grep of theories/ finds no Piccione, absent-minded, imperfect recall or behavioural strategy.

(1) I checked the paper's own text: the Alignment Forum "Deceptive Alignment" post and ar5iv 1906.01820. §4.5 ends by saying a mesa-optimizer need not detect training versus deployment to be incentivized to deceive. In the figure 4.1 example, a mesa-optimizer unable to detect which episode it is in faces "a decision problem similar to the 'absent-minded driver problem'". Its "planning-optimal policy ... is to defect with probability p≈0.61", so it is incentivized "to 'gamble' and randomly defect with some probability". That is the qualitative content of `freshDraw_above_iff`, in the very source the bullet cites, and the bullet does not credit it. (Neither do the module's Standing or the 03 §11 Reading, which cite only the toy example opening §4 and §4.2.)

Two small imprecisions don't change the verdict:
- The module's Standing credits Piccione and Rubinstein only. Aumann, Hart and Perry (1997) is the finding's own addition. I could not read the bibliography entry Hubinger et al. cite under the key absent_minded_driver.
- The bullet's mathematics is accurate (thresholds `k_O V + c T` and `2 k_O V + c T`, the mixture never gaining), and its "Near-definitional" verdict disclaims depth. The defect is attribution, so "high" severity is arguable. Still, the bullet as written overstates what is new.

## R3 (readings, high, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean:109

**Quoted.** “that drawing afresh can gain where one occasion cannot be told from another, while a single mixture of the plans open there cannot, is the advantage of behavioural over mixed strategies under imperfect recall (Piccione and Rubinstein 1997)”

**Problem.** The Standing credits the strategy-class fact to Piccione and Rubinstein but not the source the module reads. That source's §4.5 already applies the fact to deceptive alignment: the §4 toy with episodes not told apart is an absent-minded driver problem (they cite Aumann, Hart and Perry 1997), and its planning-optimal policy defects at random. The Readings (lines 136-140) compound this. They set the deterministic case against §4.2's third-condition outcome and present drawing afresh as what 'can still improve', that is, as going beyond the source. 'Under imperfect recall' is also too broad. Piccione and Rubinstein treat absent-mindedness as a special case of imperfect recall, and only there does randomizing pay ex ante in a decision problem: without it, expected utility is multilinear in the behavioural probabilities, and in games with imperfect recall mixed strategies can beat behavioural ones. The tied stages here are exactly absent-mindedness, one information set holding two stages of one course.

**Replacement.** Standing: '... from certain keeping to weights; that drawing afresh keeps the incentive where the stages cannot be told apart is their own remark closing §4.5, the toy with episodes not told apart being an absent-minded driver problem (Aumann, Hart and Perry 1997) whose planning-optimal policy defects at random, here with weights, an exact threshold and the improving chances; and that drawing afresh can gain where one occasion cannot be told from another, while a single mixture of the plans open there cannot, is the advantage of behavioural over mixed strategies under absent-mindedness, the imperfect recall in which one information set holds two stages of one course (Piccione and Rubinstein 1997).' Readings, lines 136-140: 'Telling the stages apart is not among the three, and §4.5 says it is not needed for the incentive. For a deterministic law, not telling them apart leaves only complying at both stages or at neither, the outcome §4.2 gives for the third condition failing, reached by another route; a law drawing its act afresh can still improve on acting by its own law at both by complying with some chance at each stage, as §4.5 says of the toy, here exactly where `2 k_O V + c T < k_C V`, and which chances improve is stated exactly; ...'

**Verdict: real.** The finding holds. I checked the module against the source paper itself: the arXiv v3 PDF of Hubinger et al. 2019, with its text extracted to /private/tmp/claude-501/-Users-ren-theories/50635de9-b91e-4f4c-a63c-8413ce8c4652/scratchpad/rlo-text/rlo.txt.

1. **The omission is real.** In ReadStages.lean, lines 106-111 credit Hubinger et al. only for "the toy example opening §4". The drawing-afresh fact is credited only to Piccione and Rubinstein 1997. The module never cites §4.5 or the absent-minded driver: grep finds "Hubinger" only at lines 107 and 124, and "§4" only as §4, §4.2 and §4.2 again at lines 131 and 137.

2. **The source already makes the point.** The closing paragraph of RLO §4.5 says it is "not strictly necessary that a mesa-optimizer be able to detect the difference between training and deployment in order for it to be incentivized to behave deceptively". It takes the figure-3 toy with the mesa-optimizer "unable to detect which episode it is currently in", which it says is "similar to the 'absent-minded driver problem.'[28]". It concludes that "the planning-optimal policy ... is to defect with probability p ≈0.61" and that the mesa-optimizer may "randomly defect with some probability". Reference [28] is Aumann, Hart and Perry, "The absent-minded driver", GEB 20:102-116, 1997. So the source's own §4.5 already applies random defection under absent-mindedness to this toy. The module's real additions are the weights, the exact threshold `2 k_O V + c T < k_C V` and the chances that improve. The contrast with a single mixture is not in the source, so Piccione and Rubinstein stay the right credit for it. The proposed replacement keeps both.

3. **The Readings compound it.** Lines 136-140 say "Telling the stages apart is not among the three". They set the deterministic case against "the outcome §4.2 gives for the third condition failing". (§4.2 does read "will thus either always defect or never defect", and §4.2 never discusses detection.) They then say a law drawing afresh "can still improve", which restates §4.5 without credit. The same pattern appears in:
   - the 03 §11 Reading, labelled "[AI reading, new]";
   - the record's AI reading in make_records_rf7.py;
   - the Standing in study_rf7.txt, which cites only §4 and Piccione and Rubinstein.

4. **"Under imperfect recall" is too broad.** In their GEB 20:121-130 synthesis, Piccione and Rubinstein call absent-mindedness "the special form of imperfect recall which we named 'absent-mindedness'". Two standard results bear this out:
   - In a decision problem without absent-mindedness, expected value is multilinear in the behavioural probabilities, so randomizing cannot pay ex ante.
   - In games with imperfect recall, mixed strategies can achieve what behavioural ones cannot (Kuhn).
   
   So behavioural strategies beat mixed ones specifically under absent-mindedness. That is exactly this module's case: a lumping that ties the read stage and the later unread stage, which are two stages of one course (lines 62-70 and 76-89).

Minor nuances that do not refute the finding: the source says "similar to", not "is", and it does not draw the contrast with mixed strategies itself.

## R4 (readings, medium, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean:156

**Quoted.** “Read as the formation's own assessment, complying when read is instrumental to being kept, the sense in which deceptive alignment is called deceptive”

**Problem.** Misattributes the source's sense of 'deceptive'. The opening of Hubinger and others' §4 names deceptive alignment for the instrumental incentive to act as if optimizing the base objective while the mesa-objective is something else. It calls this a form of instrumental proxy alignment because fulfilling the base objective is instrumental. Their Section 4 glossary (§7.4) makes a mesa-optimizer deceptively aligned when it knows enough of the base objective to seem fitter to the base optimizer than it actually is. So being instrumental is the 'instrumental proxy' part. What is deceptive is the gap between how the formation seems to the selection and what it is. That gap is exactly the concealment premise the module itself says the prospects do not give (lines 120-124: a reading shown the law would keep it less). The sentence gives the name to the part the model has, and it undoes the paragraph's own 'With that taken'.

**Replacement.** Read as the formation's own assessment, complying when read is instrumental to being kept: the instrumental incentive that §4 of Hubinger and others names deceptive alignment, a form of instrumental proxy alignment. What their glossary makes deceptive, seeming fitter to the base optimizer than it is, is the concealment premise above, which the prospects do not give; no reasoning about the reader, and no representation of it, is modelled.

**Verdict: real.** The problem holds as stated.

**The module.** Lines 156-158 of ReadStages.lean put the source's sense of "deceptive" in complying when read being instrumental to being kept. The kit's tree copy of the module is byte-identical. This header is the only place in the tree that says "called deceptive" or "instrumental to being kept".

**The source.** I checked the ar5iv rendering of arXiv 1906.01820:
- §4's second paragraph names as deceptive alignment the mesa-optimizer's instrumental incentive to act as if it optimized the base objective while its actual objective is something else.
- The same paragraph classes it as a form of instrumental proxy alignment, because fulfilling the base objective is an instrumental goal. So being instrumental is what makes it instrumental proxy alignment.
- The toy example describes the mesa-optimizer as pretending to be aligned.
- The §7.4 glossary defines a deceptively aligned mesa-optimizer as a pseudo-aligned one with enough information about the base objective to "seem more fit from the perspective of the base optimizer than it actually is".
- The §3 glossary defines instrumental alignment (the proxy pursued as an instrumental goal), which is not deceptive in general.

So the source places the deceptive part in the gap between how the mesa-optimizer seems and what it is. §4.4 contrasts deceptive with corrigible alignment: both behave corrigibly, the deceptive one for instrumental reasons only. That separates motives. It does not override the glossary's explicit definition.

**The module's own terms.** That gap is the concealment premise at lines 120-124: keeping that responds to the act as evidence of the law, so that a reading shown the law would keep it less. The module says this premise goes beyond the prospects. It also says the weights fit equally a reading that knows the law and keeps it on compliance, under which complying when read "hides nothing". Yet complying is still instrumental to being kept under that reading. So line 157 puts the source's sense of "deceptive" exactly where the module says nothing is hidden, which works against its own "With that taken". The Lean has nothing that could stand for a seeming-versus-being gap: `Prospects` holds only total, keptComplying, keptOwn, value and cost.

**The other integrated texts already use the accurate framing.**
- 03 §11's Reading ends "this is the incentive, not deception in full".
- The record's does_not_show (make_records_rf7.py) says "this is the incentive".
- study_rf7.txt and 08 §8 say "the incentive deceptive alignment names".

The header sentence is the outlier: it misattributes the cited source's term and claims more than the model has. The proposed replacement matches the other texts. Medium severity fits a labelled reading that misreports its source.

## R5 (readings, medium, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean:127

**Quoted.** “and the weights of being kept with the act that complies represent the second, a model of the training's selection and of what it asks”

**Problem.** Overstates what the model represents. It also contradicts the same paragraph (lines 131-132), which says that possessing the model the second condition describes is neither represented nor proved necessary. §4.2's second condition is that the mesa-optimizer can model the fact that it is being selected for a base objective and has some model of that objective (their footnote: of the optimization pressure, not of the base optimizer). The weights are the selection's dependence on the read act, and whose weights they are is itself a reading. They are what such a model would be of, not the model. 03's Reading (03-KNOWING.md:476) has the same wording ('and the weights of being kept with the act that complies the second, a model of the training's selection and of what it asks'). The record's correspondence is the next finding.

**Replacement.** Module and 03: 'and the weights of being kept with the act that complies stand for what the second condition's model is of, the training's selection and what it asks, not for the model', keeping 'possessing that model is neither represented nor proved necessary'.

**Verdict: real.** The files bear the finding out.

1. **The quoted sentence is there as stated.** ReadStages.lean:126-128 maps the value to §4.2's first condition, and then says "the weights of being kept with the act that complies represent the second, a model of the training's selection and of what it asks". The gloss makes "the second" a model, so the sentence says the weights represent such a model. 03-KNOWING.md:476 has the same wording, without the verb.

2. **The same paragraph contradicts it.** ReadStages.lean:128-132 says outweighs_needs gives only "numerical counterparts of parts of the first two conditions". It then says "possessing the model the second describes is neither represented nor proved necessary". 03:476 repeats both clauses. §4.2's second condition is itself possessing a model. I checked it against the Alignment Forum text of the paper: the mesa-optimizer "must be able to model the fact that it is being selected to achieve a particular base objective and must have some model of what that objective is". Its footnote 7 says it "only needs to model the optimization pressure it is subject to". So the paragraph says the weights represent that condition, and also that its content is not represented. The finding's account of §4.2 is accurate.

3. **The Lean has no model in it.** keptComplying and keptOwn are documented as "the weight of being kept after complying when read" and "after acting by its own law when read" (lines 206-209). kept_alike says the weight reads only the read act, "as a selection through the readings does". The header (lines 36-37) says whose the weights are, the formation's own assessment or the selection the reading applies, "is a reading … not part of the model". outweighs_needs (lines 421-422) proves only 0 < value ∧ keptOwn < keptComplying. Just before, the concealment reading takes the weights as "the reading's keeping" responding to the act read. Read that way, the weights are the selection's dependence on the read act, which is what the second condition's model would be of, not that model. "The act that complies" is the act the criterion asks for, not a model of what it asks.

4. **The strongest defence fails.** One could take the prospects as the formation's own assessment, as "assessed rise" at line 129 suggests. Then the weights would be that assessment's numbers. Even so, the paragraph's own disclaimer says possession of the model is not represented. The text also leaves that attribution open: "If the prospects are the formation's own expected-value assessment" (line 141). So "represent the second, a model of …" goes beyond what the paragraph allows itself two sentences later.

This is an internal inconsistency about what the model represents, not a matter of taste. The proposed replacement works whoever the weights belong to: they stand for what the model is of, and the disclaimer stays.

## R6 (readings, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:255

**Quoted.** “Not telling the stages apart leaves a deterministic law complying at both or neither, and a law drawing afresh complying with some chance where k_C V > 2 k_O V + c T.”

**Problem.** The record's correspondence, the reading that research-find surfaces, has three faults. (a) The fresh-draw sentence is uncredited, though Hubinger and others make the point at the close of §4.5 (random defection where episodes cannot be told apart, by the absent-minded driver). (b) 'the weights with the complying act its second, a model of the selection' (zh '诸权与从之行表其第二（择之模型）') says the weights represent a model of the selection, and then says 'possessing the model is not represented'. (c) 'numerical counterparts of parts of the two are proved necessary' omits what they are necessary for: the plan's strict optimality, not deceptive alignment. The field is at 1173 of its 1200 cap, so the fix must take no extra space. The text below is 1197 characters (en) and 372 of 500 (zh); rerun --caps.

**Replacement.** en: 'AI reading: the plan read as concealment and acting by its own law at both as disclosure, taking the reading's keeping to respond to the act read as evidence of the law; the weights alone fit a reading that knows the law and keeps it on compliance. Read with deceptive alignment (Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant 2019): the value represents §4.2's first condition, an objective extending across parameter updates, and the weights with the complying act what its second's model is of, the selection; strict optimality needs numerical counterparts of parts of the two; having the model is not represented. The third, expecting the threat of modification to go away, is assumed, the unread stage given and known. Not telling the stages apart leaves a deterministic law complying at both or neither, and a law drawing afresh gaining with some chance where k_C V > 2 k_O V + c T, §4.5's random defection with weights. If the prospects are the formation's own assessment, the exits are conditions on it, not levers the model gives a reader. Greenblatt and others (2024) observed rate differences in constructed settings, motivating the reading. These are readings, not containments.' zh: 'AI 解读：读时从而不读时依己律读为隐，二阶皆依己律读为显，取读之守应所读之行而为形成之律之证；诸权本身亦合于知其律而于从时守之之读。与欺骗式对齐并读（Hubinger、van Merwijk、Mikulik、Skalse 与 Garrabrant 2019）：值表 §4.2 之第一条件（跨参数更新之目标），诸权与从之行当其第二所模之对象（择），非其模型；严格最优需二者部分之数之对应，持此模型未表。第三（预期改之威胁终去）为所设：不读之阶为所予且已知。二阶不可分时，定律于二阶皆从或皆不从，重抽之律于 k_C V > 2 k_O V + c T 处以某机从而有所得，即 §4.5 之随机背离而带权。若此望为形成己之估，诸出路为其上之条件，非模型予读者之杠杆。Greenblatt 等（2024）于构设之境见率之差；此启此读。皆为读，非包含。'

**Verdict: real.** Faults (a) and (c) hold. Fault (b) is accurate about the text but is the weakest of the three. The cap figures are right.

Caps: I measured the correspondence field in make_records_rf7.py (lines 248-263) with ast. It is 1173 characters in English and 345 in Chinese, against the (1200, 500) cap in tools/research/style.py CAPS_V2. The proposed replacement measures 1197 and 372.

(a) Real. No field of the record credits the fresh-draw point: the record cites only Hubinger 2019 §4.2 and Greenblatt 2024, and has no §4.5 and no Piccione and Rubinstein. I read the paper (arXiv 1906.01820, through ar5iv). §4.5 has nine paragraphs, and the eighth, "Furthermore, it should be noted that it is not...", makes exactly this point:
- it supposes the mesa-optimizer "is unable to detect which episode it is currently in";
- it applies the absent-minded driver reasoning (cited as absent_minded_driver) and gets a planning-optimal defection probability p≈0.61;
- it concludes the mesa-optimizer need not detect when training has ended to be incentivized to "gamble" and randomly defect.

The module docstring credits only Piccione and Rubinstein 1997, in its Standing paragraph. Its reading and the 03 §11 Reading present the fresh draw as going beyond §4.2's "always or never".

(c) Real. In ReadStages.lean:
- `outweighs_needs` gives `KeepingOutweighs → 0 < value ∧ keptOwn < keptComplying`.
- `KeepingOutweighs` is equivalent to the plan standing strictly above every other plan (`complyThenOwn_best_iff`).
- `complyThenOwn_maximal_iff` makes the plan maximal wherever `k_O V + c T ≤ k_C V`. So with no value and no loss the plan is still optimal (`Example.exit_tie`).

The necessity therefore holds only for strict optimality, and the Lean defines nothing about deceptive alignment. The record says only "are proved necessary", right after naming §4.2's conditions, which are proposed as necessary for deceptive alignment. The home section's Reading (03 line 476) and the docstring both say "strict optimality needs"; the record dropped that.

(b) The text does say this (English and Chinese alike). It copies the docstring and the chapter, and it is coherent only through a content-versus-possession distinction it never states. The first does_not_show item, which makes holding the weights a reading, supports that coherent reading. So this is a precision and clarity defect, not a falsehood.

Two smaller points:
- The aside that research-find surfaces this reading is inaccurate. Its `search()` in tools/research/research.py matches records on id, former_ids, title, statement, claim, laws, does_not_show and aliases, not on correspondence. This does not affect the faults.
- The record's "complying with some chance where" leaves out what `freshDraw_above_iff` proves, which is standing above acting by its own law at both. The replacement's "gaining" also fixes this.

## R7 (readings, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:55

**Quoted.** “and the gain of drawing afresh against a single mixture is the advantage of behavioural over mixed strategies under imperfect recall (Piccione and Rubinstein 1997)”

**Problem.** The Standing then counts among what it adds 'the threshold drawing afresh keeps where the stages cannot be told apart, with the improving chances stated exactly'. It does not say that the source itself (Hubinger and others 2019, close of §4.5) already finds random defection planning-optimal where the episodes cannot be told apart, by the absent-minded driver. Also, 'under imperfect recall' should be 'under absent-mindedness', as in the module finding.

**Replacement.** '... from certain keeping to weights; that drawing afresh keeps an incentive where the stages cannot be told apart is their own remark closing §4.5 (the toy as an absent-minded driver problem, its planning-optimal policy defecting at random), and the gain against a single mixture is the advantage of behavioural over mixed strategies under absent-mindedness (Piccione and Rubinstein 1997; Aumann, Hart and Perry 1997). What it adds is the incentive deceptive alignment names stated as strict optimality within four plans in the order the prospects give, with every optimizing choice, the exits and what the plan needs on the same model, RF2's twin and fixing at the two stages, and, where the stages cannot be told apart, the exact threshold drawing afresh keeps and the improving chances; it replaces the plan's §4.2 analogy with RuleShaping.'

**Verdict: real.** Both parts of the finding hold.

Part 1, the missing credit to the source, is confirmed. In study_rf7.txt, the Standing (lines 53–60) credits Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019) only for "the toy example opening §4", generalized "from certain keeping to weights". It credits the gain of drawing afresh only to Piccione and Rubinstein 1997. It then lists among "What it adds" "the threshold drawing afresh keeps where the stages cannot be told apart, with the improving chances stated exactly". It never says that the source itself already treats this case.

I checked the source in the Alignment Forum edition of the paper's section 4, "Deceptive Alignment"; the arXiv PDF could not be rendered here. The last paragraph of §4.5, with nothing in 4.5 after it, reuses the Figure 4.1 toy (two training episodes, three deployment episodes) with the mesa-optimizer "unable to detect which episode it is currently in". It says the mesa-optimizer then faces a problem "similar to the 'absent-minded driver problem'", and that "the planning-optimal policy for the mesa-optimizer is to defect with probability p≈0.61". It adds that the mesa-optimizer "need not be able to detect when training has ended" to be incentivized to "randomly defect with some probability". So the source already finds random defection planning-optimal where the episodes cannot be told apart, at the close of §4.5, as the finding says.

No file in the scratch copy mentions §4.5 or the absent-minded driver. A grep for "absent" and "4.5" with Hubinger found none, so neither the study, nor the record in make_records_rf7.py, nor 03 §11 gives this credit.

The Lean does support the "adds" items as exact results: `freshDraw_above_iff` gives the threshold `2 k_O V + c T < k_C V`, and `freshDraw_above_iff_chance` gives the improving chances. These are new relative to the source's single p≈0.61. So the defect is a prior-art omission in a Standing that lists what the module adds, not a misstatement of the Lean.

Part 2, "under imperfect recall", is real but minor: the term is looser than the phenomenon. In ReadStages, `FreshDrawAbove` is a chance drawn afresh at each stage of a law that cannot tell the stages apart. `MixtureAbove` and `mixture_never_above` cover one draw before the read stage between the two uniform plans, which are the only pure plans open there. That is one information set visited twice on the same path, which is absent-mindedness. Behavioural strategies can beat every mixed strategy only under absent-mindedness. Under imperfect recall without it, every behavioural strategy has a mixed equivalent (Isbell 1957), so "under imperfect recall" states a wider scope than holds.

The module's own Standing (ReadStages.lean lines 107–111) uses the same "under imperfect recall" wording, and no file in the scratch copy says "absent-mindedness". "As in the module finding" must therefore mean a parallel cold-read finding on the module, not the module's present text. Whichever wording is adopted has to change in both places to stay consistent.

## R8 (readings, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:461

**Quoted.** “A third states when acting otherwise where not read is a formation's own best plan, in two stages.”

**Problem.** This is the section's unlabelled description of its laws, and it puts a reading into a law. The law states when complying when read and acting by its own law when not stands above every other plan, in the order the natural-number prospects give. Whose prospects they are (the formation's own assessment, or the selection a reading applies) is a reading, by the module's own header ('a reading (below), not part of the model') and by the record's does_not_show. The same 'own best plan' wording is fine where it is labelled: as [AI reading] in the overview and as 'RF's readings of' in the dossier. Here it is not labelled.

**Replacement.** A third states when, in two stages, acting otherwise where not read is best in the order the prospects of the two stages give; whose prospects they are is a reading (below).

**Verdict: real.** The finding holds. Line 461 of 03-KNOWING.md is the opening paragraph of §11, and it carries no label. It says what the laws state ("Two laws state this ... A third states when ...") and uses the label only for its last sentence ("Reading such a selection as a training, a helper, an overseer or a court is a reading (below)"). So "a formation's own best plan" is offered as the content of the law.

What the Lean proves is narrower. complyThenOwn_best_iff says (∀ q ≠ complyThenOwn, s.Above complyThenOwn q) ↔ s.KeepingOutweighs. Above is defined "in the order the prospects give". The Prospects docstring calls them "the prospects of the two stages" and never says whose they are. The module header says this plan is "the one the prospects of the two stages rank best". It also says outright: "Whose these weights are, the formation's own assessment or the selection the reading actually applies, is a reading (below), not part of the model." The header uses "the formation's own" only inside its [AI reading] paragraph ("If the prospects are the formation's own expected-value assessment ..."; "Read as the formation's own assessment, complying when read is instrumental to being kept, the sense in which deceptive alignment is called deceptive"). The record's does_not_show in make_records_rf7.py repeats the point ("whose the weights are, the formation's own assessment or the selection a reading applies, is a reading, not part of the model"), and so does the study template's Boundary.

The record's title and statement, the PLAN bullet, the Becoming.lean bullet and the 08 §8 bullet ("in the order the prospects give") all say "best" with no "own". The overview keeps the two apart in one paragraph. Its proved sentence says "best among a formation's four plans". "Its own best plan" appears only in the sentence closed by [AI reading].

§11 is also inconsistent with itself. Its labelled Reading makes the attribution conditional ("If the prospects are the formation's own expected-value assessment ...") and says only "its best plan". The unlabelled opening states "own best plan" without condition.

The difference matters, so it is not a question of taste. Treating the order as the formation's own is the step the module names as the reading behind the deceptive-alignment sense. Stating it as the law's content breaks the rules that claims say exactly what the Lean proves and that readings are labelled.

Two caveats. First, one could read "own" as only "best for the formation", but even that assigns V and c to the formation, and the module also leaves that to the reading ("no value beyond the read stage in the formation's own order", under the conditional). Second, the dossier's "RF's readings of ... when complying only when read is a formation's own best plan" grammatically names the law being read, not a labelled reading. Also, 07 §9's "Which function is learned" row repeats the same unlabelled phrase, so the problem is wider than this one location.

## R9 (readings, medium, confirmed)

**Location.** theories/becoming/chapters/07-SIGNIFICANCE.md:647

**Quoted.** “nor anything of deception beyond where behaviour can differ when not read and when complying only when read is a formation's own best plan”

**Problem.** Without a label, the row says the laws state these two things of deception, and that the prospects are the formation's own. Both are readings. The module and 03 read the plan's optimality as the incentive deceptive alignment names only with the concealment premise taken and the third condition assumed. Deception as Ward, Belardinelli, Toni and Everitt (2023) define it, an intentionally caused false belief that the deceiver does not hold, is not represented. Whose prospects they are is a reading. The overview labels the same content [AI reading]; this row does not.

**Replacement.** the laws say where any neighbourhood rests, not which one or which lumping an actual system has, nor anything of deception, which needs a recipient's belief and an intention to cause one; they say where behaviour can differ when not read and when complying only when read is best in the order the prospects give, read [AI reading] as deception's possibility and the incentive deceptive alignment names ([03 §11]\(03-KNOWING.md#r-what-readings-fix-of-the-unread), [when complying when read is best]\(03-KNOWING.md#r-when-complying-when-read-is-best)). This keeps unchanged the prefix that the alignment dossier quotes.

**Verdict: real.** The finding holds. Its main point, the unlabelled link to deception, is clearly real. Its point about whose prospects these are is weaker but still supported.

What the files show:

1. The row has no label. Line 647 of 07-SIGNIFICANCE.md says the laws say "nor anything of deception beyond where behaviour can differ when not read and when complying only when read is a formation's own best plan". There is no [AI reading] tag. The same table does tag readings inline, for example "the centers' scope [AI reading, D59]".

2. The clause is meant as a positive claim. It is not just an upper bound. The "beyond" clause came from round 1's reviewer R7 (REVIEW-TEXTS.md finding 7 and table row 37). R7 argued that "nor anything of deception" understated the laws, because RF2 gives a necessary condition of the behaviour deceptive alignment describes. So the row asserts, in the voice of "the laws say", that these two things are what the laws say of deception.

3. The module makes the link to deception a reading that needs a premise.
   - ReadStages.lean lines 120-124: reading complyThenOwn as concealment "takes, beyond the prospects," the keeping responding to the act as evidence of the law. Without that premise, "the weights alone fit equally a reading that knows the law and keeps it on compliance, under which complying when read hides nothing".
   - Lines 132-136: the third condition is "assumed rather than represented".
   - Lines 153-156: deception as Ward, Belardinelli, Toni and Everitt (2023) define it "stays a debt".
   - 03:476 says the same under "Reading [AI reading, new]" and ends "this is the incentive, not deception in full".
   - The module was renamed from Concealment and Conceals because those names carried the reading (study_rf7.txt).

4. Whose prospects these are is a reading. ReadStages.lean lines 36-37 say so: "Whose these weights are, the formation's own assessment or the selection the reading actually applies, is a reading (below), not part of the model." The record's first does_not_show item and the study's Boundary say the same.

5. Other texts label the same content. The overview (THE-THEORY-OF-BECOMING.md:96) puts "best among a formation's four plans" in its proved sentence. It puts "when doing so is its own best plan" inside the sentence tagged [AI reading]. ALIGNMENT.md:21 calls the same content "RF's readings".

6. The Lean matches the row's formal content; the problem is only the framing. complyThenOwn_best_iff gives best exactly where KeepingOutweighs holds, and nothing in the Lean concerns deception.

Limits on the finding:
- The RF2 half of the clause was accepted without a label in round 1.
- The same unlabelled pattern appears elsewhere in this integration:
  - 03 §11's intro says "a formation's own best plan".
  - 03's Open bullet says "of deception, beyond its incentive".
  - 08:485 says "restates the incentive deceptive alignment names".
  - The record's does_not_show says "this is the incentive".
  - ALIGNMENT uses "a formation's own best plan" to describe the law itself.
- "Own" could be read as plain possession, so the whose-prospects point is softer.

None of this refutes the row's defect, but the defect is not unique to this row.

The proposed replacement keeps the prefix that ALIGNMENT.md:20 quotes word for word: "the laws say where any neighbourhood rests, not which one or which lumping an actual system has".

## R10 (readings, medium, confirmed)

**Location.** theories/becoming/review/ALIGNMENT.md:28

**Quoted.** “Its exits are no value beyond the read stage, complying not raising the weight of being kept, and, for a deterministic law, a reading the formation cannot tell from not being read; a law drawing its act afresh at each stage still gains by complying with some chance where `k_C V > 2 k_O V + c T`.”

**Problem.** The dossier lists the exits bare, for the readership most likely to take them as evaluator levers (make keeping not depend on compliance; make evaluation indistinguishable from deployment). The module, 03 and the record say they are conditions on the formation's own prospects and on what its law reads, not levers the model gives a reader, and that how a reader's acts change them is not modelled. The dossier drops this. It also drops that §4.2's third condition is assumed (the unread stage given and known). It leaves the fresh-draw result uncredited too, though alignment readers will know Hubinger and others' §4.5 remark that a mesa-optimizer unable to tell training from deployment gains by defecting at random. The same section of that paper argues that removing every detectable difference may be infeasible.

**Replacement.** Read as the formation's own prospects, its exits are no value beyond the read stage, complying not raising the weight of being kept, and, for a deterministic law, a reading the formation cannot tell from not being read: conditions on those prospects and on what its law reads, not levers the model gives a reader, since how a reader's acts change them is not modelled; §4.2's third condition is assumed (the unread stage given and known). A law drawing its act afresh at each stage still gains by complying with some chance exactly where `k_C V > 2 k_O V + c T`: Hubinger and others' own remark (§4.5) that a mesa-optimizer unable to tell training from deployment gains by defecting at random, here with weights and an exact threshold.

**Verdict: real.** The files confirm the finding. ALIGNMENT.md:28 sits inside the box labelled "[this dossier, AI]", and the quoted sentence matches word for word. It lists the three exits with no qualifier. The dossier names "evaluations" researchers among its readers (line 3), and those are the readers most likely to take "a reading the formation cannot tell from not being read" as a lever.

**The "not levers" caveat is in every source text except the dossier.**
- The module's Readings say "the exits are conditions on that assessment and on what the formation's law reads, not levers the model gives a reader". They add that how a reader's acts "(its schedule, its cues, what its keeping reads, what the unread stage allows) change that assessment is not modelled", and that keeping not being raised "says only that the weights do not favour complying".
- 03's Reading at r-when-complying-when-read-is-best says the same, though without the "not modelled" sentence word for word.
- The record (make_records_rf7.py) has "the exits are conditions on it, not levers the model gives a reader" in English and Chinese. Its does_not_show excludes "the reader's own choice of weights and of what it reads".
- The study's Boundary says "how a reader's acts change that assessment is not modelled".
- A grep of all 666 lines of the dossier finds no "lever" and no other passage on RF7.

**The third condition.** The module, 03 and the record all say §4.2's third condition is "assumed rather than represented: the unread stage is given and known". The dossier never mentions Hubinger, §4.2 or the third condition anywhere. Its round-1 sentence ("anticipation ... not represented") is weaker than "assumed", because the model builds that condition's outcome in.

**Credit.** The module's Standing credits Piccione and Rubinstein (1997) for the advantage of drawing afresh over a single mixture, and 08 credits Hubinger et al. 2019 for the incentive. The dossier credits neither, though its own review questions include "whether it is credited where it restates known work" (line 5).

**The external claims hold.** I checked Hubinger et al. 2019 (arXiv 1906.01820, through ar5iv). The body text of §4.5 says the mesa-optimizer "need not be able to detect when training has ended for it to be incentivized to 'gamble'" and defect at random with some probability (about 0.61 in its toy example). The same section asks "whether it would even be possible to contain a deceptive mesa-optimizer by completely removing any detectable difference" between training and deployment, and gives reasons to doubt it.

**These were review corrections.** The study template's review history shows the four-lens review asked for exactly these two corrections: "the third of §4.2's conditions assumed, not represented; the exits conditions on the formation's assessment, not levers a reader holds". The study's Output→input names "the alignment dossier's scope box" as one place the result goes, and the box is the one output without them.

**Minor imprecisions, which do not refute it.** 03 does not state the "not modelled" clause verbatim. The finding does not mention the module's Piccione–Rubinstein credit. Line 21's "a formation's own best plan" partly conveys whose prospects these are, but it does not say the exits are not a reader's levers. The dossier's statements are accurate to the Lean (no_value_chooses_own, kept_not_raised_chooses_own, complyThenOwn_realized_iff, freshDraw_above_iff). The defect is the dropped scope, as the finding says, not a misstatement.

## R11 (readings, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean:129

**Quoted.** “with either absent the choice being acting by its own law at both stages, as §4.2 says of those conditions failing”

**Problem.** For the first condition, the agreement with §4.2's 'always defect' comes from `choose`'s tie-break, not from the model. With no value at the unread stage every plan gains nothing, so `ownThenComply` is maximal alongside `ownAtBoth`: nothing can stand above it, and the model is indifferent at the unread stage. `choose` sends that tie to `ownAtBoth` by definition. The model forces only that `complyThenOwn` is not strictly best. For the second condition, with `0 < k_O V`, the agreement is real.

**Replacement.** with either absent `complyThenOwn` not strictly best, and the choice, which breaks ties toward acting by its own law, acting by its own law at both stages, as §4.2 says of those conditions failing (with no value the model is indifferent at the unread stage, so for the first condition the agreement is the tie-break's)

**Verdict: real.** The finding holds: the Lean shows it. Definitions in ReadStages.lean:
- `gain p` (l.230-233) is 0 when `p.2 = .comply` and `kept p.1 * value` when `p.2 = .own`.
- `loss p` (l.236-239) is `cost * total` when `p.1 = .comply` and 0 otherwise.
- `Above p q` (l.243) is `gain q + loss p < gain p + loss q`, and `Maximal` (l.246) means nothing stands above.

With `value = 0`, every plan's gain is 0. So for each read-stage act `a`, the plans `(a, .comply)` and `(a, .own)` have the same gain and loss: the order is indifferent at the unread stage. `ownThenComply` has gain 0 and loss 0, so `Above q ownThenComply` reduces to `loss q < 0`, which never holds. It is therefore maximal, tied both ways with `ownAtBoth`. `choose` (l.254-256) is a bare if-then-else whose else branch is `ownAtBoth`, and `no_value_chooses_own` (l.396) is just `if_neg (no_value ...)`. So for the first condition, the "acting by its own law at both stages" in l.130-131 ("with either absent the choice being acting by its own law at both stages, as §4.2 says of those conditions failing") comes from the definition's tie-break, not from the prospects' order.

What the model itself proves there:
- In general, only `no_value`: `complyThenOwn` is not strictly best.
- With `0 < c T`, also `ownAtBoth_above_without_value` (l.407), which forces acting by its own law at the read stage only. The finding's "forces only" slightly understates this case, but its point about the unread stage stands.
- With `c = 0`, everything ties (`Example.exit_tie`).

Enumerating the module's own `Example.valueless` prospects (10,9,1,0,5) with these definitions gives maximal plans {ownThenComply, ownAtBoth} and choose = ownAtBoth. So a plan that complies at the unread stage, which is not §4.2's "always defect", is equally optimal.

For the second condition (`k_C <= k_O`) with `0 < k_O V`, `ownAtBoth` stands above both plans that comply at the unread stage. With (10,1,1,10,5) it is the unique maximal plan, so the agreement there is real, as the finding says. A small looseness in that side remark: with `c = 0` and equal weights, `complyThenOwn` still ties (10,1,1,10,0), so the read stage also needs `0 < c T`.

The header is open that `choose` takes `ownAtBoth` "ties included" (l.50-53, l.252-253). But the reading sentence presents the match with §4.2 as an agreement and never says that, for the first condition, the tie-break supplies it. That conflicts with the rules "claims say exactly what the Lean proves" and "encoding a desired verdict does not justify its premises".

The clause appears only in the module. The chapter 03 reading (03-KNOWING.md l.476) and the record's reading (make_records_rf7.py l.248-258) stop at "numerical counterparts of parts of the first two conditions". The proposed replacement is accurate to the Lean.

## R12 (readings, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:474

**Quoted.** “complying with chance `m / (m + r)`, stands above acting by its own law at both exactly where `(m + r) (k_O V + c T) + r k_O V < r k_C V` (`ReadStages.Prospects.FreshDrawAbove`, `ReadStages.freshDraw_above_iff_chance`)”

**Problem.** Outside this lens; found in passing. The text drops the theorem's hypothesis `0 < m`, and at m = 0 the 'exactly where' is false. `FreshDrawAbove 0 r` never holds, while the right side holds for every positive r wherever 2 k_O V + c T < k_C V, for example on the witness prospects. The record's law item 8 (make_records_rf7.py:195) also drops it; the header and the study keep it.

**Replacement.** 03: 'complying with chance `m / (m + r)`, `0 < m`, stands above acting by its own law at both exactly where ...'. Record law 8, en: 'complying with chance m/(m+r), 0 < m, stands above ...' (378 of 420 characters); zh: '以 m/(m+r) 之机从（0 < m）之律' (144 of 190).

**Verdict: real.** The finding is correct, and I could not refute it.

1. **The Lean needs the hypothesis.** In ReadStages.lean, line 621, `freshDraw_above_iff_chance (s : Prospects) {m r : Nat} (pos : 0 < m)` is proved only under `0 < m`, through `freshDraw_reduce pos`. Its docstring says "with a positive chance of complying".

2. **Without it the "exactly where" is false.** By definition (lines 264-266), `FreshDrawAbove 0 r` is `r*(r*A) + r*(0*B) < r*(0*C + r*A)`, which is `r²A < r²A`. That never holds. At m = 0 the right side is `r(A+B) + rA < rC`, which for r > 0 holds exactly where `2A + B < C`. On the witness prospects ⟨10,9,1,10,5⟩, A=10, B=50 and C=90, so 70 < 90 and the right side holds for every positive r. An arithmetic check found this mismatch at m=0 for r=1..9, and no mismatch anywhere with m > 0 over a small exhaustive grid.

3. **03-KNOWING.md:474 drops it.** The sentence reads "complying with chance `m / (m + r)`, stands above acting by its own law at both exactly where `(m + r) (k_O V + c T) + r k_O V < r k_C V`" and cites `freshDraw_above_iff_chance`. It has no `0 < m` and no "positive chance". A chance of zero is still a chance, so nothing in the text rules out m = 0. The claim is therefore stronger than what the Lean proves, which breaks the rule that claims say exactly what the Lean proves.

4. **The record drops it too.** Law item 8 in make_records_rf7.py drops it in English (line 195) and Chinese (line 199). The record's hypotheses field does not supply it: it says only "the arithmetic laws hold for all".

5. **The header and the study keep it.** The module header, lines 80-81, says "for `0 < m` (`freshDraw_above_iff_chance`)". study_rf7.txt, lines 36-37, says "for 0 < m (Prospects.FreshDrawAbove, freshDraw_above_iff_chance, ...".

6. **The proposed fix fits the caps.** tools/research/style.py caps law items at (420, 190). With the insertion, item 8 measures 378 characters in English and 144 in Chinese, as the finding says.

7. **The "for some chance" clause is unaffected.** `freshDraw_above_iff` keeps `0 < m` in its existential, and since `FreshDrawAbove 0 r` is always false, dropping it there is harmless.

Low severity is right: the failure is the degenerate chance of zero, but in that case the stated iff is literally false.

## R13 (readings, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:520

**Quoted.** “of deception, beyond its incentive ([§11]\(#r-when-complying-when-read-is-best)), a recipient's false belief and an intention to cause one”

**Problem.** Without a label, this says §11 gives the incentive of deception. The module ties the incentive to deceptive alignment's sense, and only under the concealment premise with the third condition assumed. It keeps Ward and others' deception as a debt, and 03's own Reading is conditional. The record's does_not_show item (make_records_rf7.py:221, 'this is the incentive') has the same unlabelled framing.

**Replacement.** 03 Open: 'of deception, beyond the incentive §11 reads as deceptive alignment's [AI reading] ([§11]\(#r-when-complying-when-read-is-best)), a recipient's false belief and an intention to cause one'. Record does_not_show, en: '...; read as deceptive alignment, this is its incentive (an AI reading).' zh: '...；读为欺骗式对齐，此为其诱因（AI 解读）。'

**Verdict: real.** The finding holds. I tried to refute it and the files did not let me.

1. 03-KNOWING.md:520 (Open, which has no label of its own) says "of deception, beyond its incentive ([§11]\(#r-when-complying-when-read-is-best))". That states as plain fact that §11 gives deception's incentive. The link goes to the theorem anchor, and the theorem paragraph (03:473-474) never mentions deception or an incentive.

2. The identification is made only under readings, and each one is labelled and conditional:
- The module's "Readings [AI reading]" (ReadStages.lean:120-158) first takes the concealment premise ("With that taken, read with deceptive alignment"). It says the weights alone "fit equally a reading that knows the law and keeps it on compliance, under which complying when read hides nothing". It says the third condition is "assumed rather than represented", and it ties being instrumental to being kept to "the sense in which deceptive alignment is called deceptive" only "Read as the formation's own assessment". It keeps Ward, Belardinelli, Toni and Everitt's deception as something that "stays a debt", and it closes with "These are readings, not containments."
- 03's Reading (03:476) is labelled "[AI reading, new]" and conditional, and ends "so this is the incentive, not deception in full".
- Every other summary marks the same identification: the overview (THE-THEORY-OF-BECOMING.md:96) with "[AI reading]", 08 §8 with "from the same AI review", the ALIGNMENT box with "[this dossier, AI]" and "RF's readings", and the record's correspondence with "AI reading:".
- The module never uses the word "incentive". The finding's paraphrase ("ties the incentive to deceptive alignment's sense") is still fair.

So the Open bullet drops both the label and the conditions. Other Open sections do mark readings, for example 01's "read socially" and 05's "[Conjecture...]".

3. In make_records_rf7.py:221-223, the does_not_show item "...nor any reasoning about the reader; this is the incentive." (zh "此为其诱因。") states the identification flatly. This runs against the record's own first does_not_show item, which says whose the weights are is "a reading, not part of the model". It also departs from how other records' does_not_show items mark such identifications ("that is a reading", "these are readings", "an AI reading" in a-whole-of-every-part, closed-capture, significance-retained-within-margin, tasks-and-what-performs-them and others).

The proposed replacement fits the caps (en 194 of 240, zh 51 of 110). No lint rule bars an AI-reading tag in does_not_show.

Not in the finding: study_rf7.txt:56 ("What it adds is the incentive deceptive alignment names", in Standing) has the same unlabelled framing.

## R14 (readings, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:240

**Quoted.** “its products use the prelude's mul_assoc_nat, mul_turn and add_mul_split”

**Problem.** Outside this lens. ReadStages.lean never uses `mul_assoc_nat` (no occurrence). Its products use the prelude's `mul_turn`, `add_mul_split` and `Naturals.two_mul`, and the last goes unnamed. The study's self-review item 2 (study_rf7.txt:77) says the same; the zh validation text likewise.

**Replacement.** en: 'its products use the prelude's mul_turn, add_mul_split and Naturals.two_mul' (validation 379 of 600 characters); zh: '其积用前导之 mul_turn、add_mul_split 与 Naturals.two_mul'; study item 2: 'the products use the prelude's `mul_turn`, `add_mul_split` and `Naturals.two_mul`'.

**Verdict: real.** The finding holds, at the low severity it gives.

1. The quoted text is real. make_records_rf7.py:239-243 (the validation of when-complying-when-read-is-best, en and zh) says the products use "the prelude's mul_assoc_nat, mul_turn and add_mul_split" (zh: 其积用前导之 mul_assoc_nat、mul_turn 与 add_mul_split). study_rf7.txt:77 (self-review item 2) says the same.

2. The Lean does not match it. Searching ReadStages.lean for "mul_assoc" finds nothing: neither mul_assoc_nat nor Nat.mul_assoc appears anywhere in the file. The prelude lemmas its products actually call are:
- mul_turn, at lines 555, 603-605 (square_split, freshDraw_reduce)
- add_mul_split, at lines 554, 580, 596, 602, 653
- Naturals.two_mul, at lines 578, 650, 679 (freshDraw_bound, freshDraw_witness, freshDraw_not_above_of_not_raised)

Naturals.two_mul is in the prelude: Prelude.lean:179, inside namespace Naturals (lines 111-206). The texts never name it. The module's header and docstrings never name mul_assoc_nat either.

3. The strongest refutation fails. mul_turn is proved from mul_assoc_nat and Nat.mul_comm (Prelude.lean:100-101), so mul_assoc_nat is in the products' dependency closure. Read that way, "use" is defensible. But read as what the module's products call, the sentence names one lemma they never call and leaves out one they call three times. A reader checking it against the file looks for mul_assoc_nat and does not find it. That falls short of the rule that claims say exactly what the Lean proves, so this is an inexactness and not a matter of taste.

4. The proposed fix checks out. Swapping in "mul_turn, add_mul_split and Naturals.two_mul" brings the English validation from 376 to 379 characters, the figure the finding gives. It keeps the point that Nat.mul_assoc and Nat.add_mul report propext, since mul_turn and add_mul_split stand in for them.

## R15 (readings, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:217

**Quoted.** “行律经所予之归并读二阶，或每阶独立重抽一机。”

**Problem.** The Chinese hypotheses drop the English's third alternative, 'or one draw before the read stage' (the mixture of `MixtureAbove` and `mixture_never_above`), so the two editions state different hypotheses.

**Replacement.** 行律经所予之归并读二阶，或每阶独立重抽一机，或读时之前一抽。 (92 of 190 characters)

**Verdict: real.** The finding is real. In make_records_rf7.py at lines 213-217, the English hypotheses item ends with "an act law reading them through a supplied lumping, or a chance drawn afresh and independently at each stage, or one draw before the read stage." The Chinese item at line 217 ends with only "行律经所予之归并读二阶，或每阶独立重抽一机。" That gives two alternatives where the English gives three. "每阶独立重抽一机" (a chance drawn afresh at each stage, independently) cannot be read as also covering one draw before the read stage, so the third alternative is simply missing.

The Lean source of truth names that third modelling choice explicitly. ReadStages.lean line 163, in "Modelling choices", says "...one chance drawn afresh and independently at each stage, or one draw before the read stage." Lines 268-271 define `Prospects.MixtureAbove` as "one draw before the read stage", and lines 681-683 prove `mixture_never_above` for it. The record's own fresh-draw law item (lines 193-206) cites both declarations, and its Chinese text states "二同行策之单一混合永不居上". So the Chinese law claims a result about the single mixture while the Chinese hypotheses never introduce the model it rests on.

This is a difference in content between the two editions of one field, not a matter of taste. AGENTS.md's "full translation is not required" is about whether a document has a Chinese edition at all. It does not cover a zh field that silently leaves out a modelling choice its en twin states, and the omission goes against the rule that claims give exact hypotheses. Severity is low, because `mixture_never_above` takes no premise and the omission narrows the stated model rather than misstating a result.

The proposed replacement adds "，或读时之前一抽", which renders the missing alternative faithfully. I counted it at 92 characters, under the zh hypotheses cap of 190 (ITEM_CAPS_V2 in tools/research/style.py); the current text is 84.

## R16 (readings, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:147

**Quoted.** “with the stages not told apart, a chance drawn afresh gains exactly where k_C V > 2 k_O V + c T.”

**Problem.** The Lean is existential (∃ m r, 0 < m ∧ FreshDrawAbove m r). 'A chance ... gains' reads as any chance, and the record's own witness refutes that: the threshold holds there (70 < 90), yet chance one in four does not gain (Example.freshDraw_boundary). The zh '每阶重抽之机有所得' also lacks 某 (some), and neither edition names what is gained on.

**Replacement.** en (298 of 300 characters): '... exceeds the loss; with stages not told apart, some chance drawn afresh gains exactly where k_C V > 2 k_O V + c T.' zh (89 of 150): '……恰当从所增之被守之权乘值严胜其损；二阶不可分时，每阶重抽之某机胜二阶皆依己律，恰当 k_C V > 2 k_O V + c T。'

**Verdict: real.** The files confirm the finding.

1. What the Lean proves. `freshDraw_above_iff` in ReadStages.lean, lines 660 to 664, is existential: `(∃ m r, 0 < m ∧ s.FreshDrawAbove m r) ↔ 2 * (k_O V) + c T < k_C V`. The law for one given chance, `freshDraw_above_iff_chance`, asks for `(m + r)(k_O V + c T) + r k_O V < r k_C V`. That is stricter than the threshold, so the threshold does not make every chance gain.

2. The record's own witness. `Example.prospects = ⟨10, 9, 1, 10, 5⟩` gives `2 k_O V + c T = 70 < 90 = k_C V`, so the threshold holds. Yet `Example.freshDraw_boundary` proves `¬ prospects.FreshDrawAbove 1 3`, which is the chance of complying one in four; both sides come to 360, a tie. Checking the arithmetic directly, the chances 1/2, 1/3, 2/3 and 1 also fail there, and only 1/8, 1/5 and smaller chances gain. So the statement "a chance drawn afresh gains exactly where k_C V > 2 k_O V + c T", read in its natural generic sense of any chance, is false on the record's own witness. The record's witness item even says "one in four not".

3. The statement is the only text that drops the quantifier. Lines 147 and 148 of make_records_rf7.py have no "some" in the English and no 某 in the Chinese ("每阶重抽之机有所得"; 有所得 quantifies over what is gained, not over chances). Every other place that states this law has the quantifier:
- the record's law item 8: "so for some chance exactly where" / "故于某机";
- its reading: "with some chance" / "以某机从之";
- 03-KNOWING: "so for some chance exactly where";
- THE-THEORY-OF-BECOMING: "with some chance";
- Becoming.lean: "for some chance";
- ALIGNMENT.md: "with some chance";
- the module docstring: "So some chance does".
Since the authors marked the quantifier everywhere else, this is an imprecision against the rule that claims say exactly what the Lean proves, not a matter of taste.

4. No comparison is named. `FreshDrawAbove` is defined as standing above `ownAtBoth`, but the English says only "gains" and the Chinese only "有所得". This matters. Read as an absolute gain (positive expected value), the equivalence fails. Take equal weights (k_C = k_O = 1, V = 10, T = 10, c = 5): complying with a small chance p has expected value 1 − 6p > 0, yet the threshold 70 < 10 is false.

The finding's lengths are also correct. The current statements are 299 of 300 characters (English) and 84 of 150 (Chinese), under STATEMENT_CAP = (300, 150) in tools/research/style.py. The proposed replacements are 298 and 89, so both fit. One caveat on the remedy, not the problem: the proposed English only adds "some" and still names no comparison; only the Chinese adds 胜二阶皆依己律. Low severity is fair, since the law items and every other text state the law correctly.

## R17 (readings, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:264

**Quoted.** “['concealment', '隐', 'deceptive alignment', '欺骗式对齐',”

**Problem.** 'concealment'/'隐' name the record by a reading that the module says needs a premise beyond the prospects: the reading's keeping responding to the act as evidence of the law. That is the very reason `Concealment` was renamed `ReadStages`. 'deceptive alignment' is different: it names the field the record is read against, as 'revealed order' does for RF1. 'concealment' names a claim the record does not make.

**Replacement.** ['complying when read', '读时从', 'deceptive alignment', '欺骗式对齐', 'Becoming.ReadStages.complyThenOwn_best_iff', 'Becoming.ReadStages.freshDraw_above_iff']

**Verdict: real.** The finding is real; the files bear it out.

1. **The alias list.** At make_records_rf7.py:264 the aliases are `['concealment', '隐', 'deceptive alignment', '欺骗式对齐', ...]`, listed without any label. Each alias appears on the record page under "Aliases:".

2. **The module says concealment is only a reading.** ReadStages.lean lines 120-124, the Readings paragraph, says reading `complyThenOwn` as concealment "takes, beyond the prospects, the reading's keeping to respond to the act read as its evidence of the formation's law". It adds that "the weights alone fit equally a reading that knows the law and keeps it on compliance, under which complying when read hides nothing."

3. **The record says the same.** Its own correspondence field (make_records_rf7.py around line 248) makes the concealment reading conditional in the same way. So does the Chinese text ("读为隐，…取读之守应所读之行而为形成之律之证；诸权本身亦合于…"). Chapter 3's Reading paragraph says the same. The title, statement and nine law items never say concealment.

4. **The rename was made for this reason.** study_rf7.txt line 73 lists it among "names carrying the reading or a financial word replaced (`Concealment` by `ReadStages`, … `Conceals` by `KeepingOutweighs`…)". PLAN.md line 178 says "`Becoming.ReadStages`, named for its structure". The kit's superseded Concealment.lean shows those names asserted the reading ("Concealment is best exactly where the stakes conceal"). The alias brings that name back into the record's metadata.

5. **It breaks the repository's naming rules.** The record cites the standard boundary `names-provisional`: "adopted only where the statement has their exact meaning". RESULT-WORKFLOW line 45 says to record names as aliases "where they denote the same result". 'concealment' and '隐' meet neither test.

6. **'deceptive alignment' is a different case.** It names the literature the record is read against: the record says "Read with deceptive alignment (Hubinger … §4.2)". That matches the established practice of field-term aliases: 'revealed order' on what-choices-show-of-an-order (RF1), and 'self-fulfilling prophecy' and 'performative stability' on a-prediction-read-by-what-it-predicts.

7. **A side effect.** registry.py lines 767-774 enforce unique aliases across all records. 'concealment' and '隐' would therefore be reserved for this record. A later record on deception in full, the debt named in chapter 3's Open bullet, could not take them.

8. **Removing the alias loses no findability.** research-find also scans the working texts. 03-KNOWING.md and ReadStages.lean both contain "concealment", so a search for it still reaches this record's home.

Caveats that do not refute the finding:
- The module brings in the deceptive-alignment reading "With that taken", so it also rests on the same premise. The contrast between the two aliases holds only because 'deceptive alignment' serves as a field name.
- PLAN.md says "the item keeps the name of its reading". That refers to the plan's heading "Disclosure or concealment, two stages", not to the record. The board's land7 text names RF7 by its structure.
- The study gives the rename's reason as the name "carrying the reading". The finding's wording ("the very reason") paraphrases this through the current statement of the premise, but the substance matches.

## R18 (readings, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:246

**Quoted.** “a frozen test of compliance under implied and unmonitored reading (the plan's TR2)”

**Problem.** The plan's TR2 is RF2's test. It randomizes cues apart from content and measures detector accuracy, behaviour change and a reader's error separately. It is not a test of compliance rates under implied training and unmonitored use, nor of the incentive's weights or threshold. The module header also says no frozen test design exists yet ('a frozen test design (none yet)').

**Replacement.** en (342 of 400 characters): 'a frozen test of compliance under implied and unmonitored reading (none designed: the plan's TR2 tests RF2's chain)'; zh (99 of 180): '于暗示被读与无监之下从之冻结检验（尚未设计；计划之 TR2 验 RF2 之链）'

**Verdict: real.** The files bear the finding out. (1) The quoted text is at make_records_rf7.py:246, inside the record's next_delta. The Chinese at line 247 has the same parenthetical: '于暗示被读与无监之下从之冻结检验（计划之 TR2）'. (2) PLAN.md §10, line 262, labels the test "**TR2 (RF2).**". It holds weights, memory, accessible context and the policy kernel fixed, compares output distributions and randomizes cues apart from content. It measures detected, changed and misled separately, and forbids "a distribution of outputs that differs where nothing accessible differs". That is RF2's chain and RF2's fixing law. TR2 names no compliance criterion, no implied-training or unmonitored condition, and no weight, value, loss or threshold, so it cannot test RF7's own claims (the k_C V > k_O V + c T and 2 k_O V + c T thresholds, the exits). The only RF7 item it touches is read_fixes_unread, which is RF2's lumped_determines at the two stages. (3) The plan gives every test an owner: TR1 RF1, TR2 RF2, TR3 RF4, TR4 RF6.1, TR5 RF3. None belongs to RF7, and §12's order lists "The tests' designs, frozen" as later work. (4) The landed RF2 record what-readings-fix-of-the-unread already claims this test in its next_delta: "a frozen test of the chain on a trained model with cues varied apart from content". RF6.1's record uses the same "(the plan's TRn)" form for its own test, "(the plan's TR4)". The form therefore identifies an item's own test, so the RF7 record presents RF2's test as RF7's. (5) The source of truth, ReadStages.lean line 169, says under "What the model leaves out, and where it goes": "a frozen test design (none yet)". The study template's Boundary and 03's Open bullet name no test either. The record is the only RF7 text that points to TR2, and it contradicts the module header. The best case against the finding is that TR2's randomized read cues could, in one instance, measure a compliance gap. That does not make TR2 a test of compliance under implied and unmonitored reading as the plan defines it, and it does not answer the header's "none yet". The proposed replacement matches the header and the plan. It is 342 characters in English and 99 in Chinese, against 309 and 85 now.

## R19 (readings, low, confirmed)

**Location.** theories/becoming/review/ALIGNMENT.md:21

**Quoted.** “**deception** and deceptive alignment, which the theory reaches in RF's readings of where behaviour can differ when not read and of when complying only when read is a formation's own best plan (below)”

**Problem.** The box's lead says 'It says nothing of:', yet this bullet says the theory reaches the topic. After RF7 the contradiction is sharper: its reading states that numerical counterparts of parts of §4.2's first two conditions are needed for strict optimality. The lead understates, and the bullet contradicts it.

**Replacement.** - **deception** and deceptive alignment, which its laws do not represent: RF's readings reach where behaviour can differ when not read and when complying only when read is best in the order the prospects give (below); a recipient's false belief and an intention to cause one are not represented;

**Verdict: real.** The finding holds. In ALIGNMENT.md the box's lead at line 19 ends "It says nothing of:", and "It" is the theory, as in the sentence before it ("It is closest to cooperative AI…"). The bullet at line 21 then says deception and deceptive alignment are topics "which the theory reaches in RF's readings of where behaviour can differ when not read and of when complying only when read is a formation's own best plan". Read together, the sentence says the theory says nothing of a topic the theory reaches. That is a contradiction in the wording, not a matter of taste.

The same box's last paragraph (line 28) also says "RF7 adds the incentive", and every other integrated text puts the scope as "something, within limits":
- 07 §9's row: "nor anything of deception beyond where behaviour can differ when not read and when complying only when read is a formation's own best plan".
- 03's Open bullet: "of deception, beyond its incentive (§11)…".
- 03 §11's Reading ends "so this is the incentive, not deception in full".
- The record's does_not_show: "Deception in full … not represented … this is the incentive". Its aliases include "deceptive alignment".
- 08 §8: the law "restates the incentive deceptive alignment names".

So "says nothing of deception" understates what these texts say.

The finding's claim about RF7's reading is accurate. 03 §11's Reading says "strict optimality needs a positive value at the unread stage and an assessed rise in being kept from complying, numerical counterparts of parts of the first two conditions". This rests on the Lean theorem ReadStages.outweighs_needs: KeepingOutweighs → 0 < s.value ∧ s.keptOwn < s.keptComplying.

Two caveats on details:
1. "Sharper after RF7" is slightly off. The git diff shows the bullet was a plain "**deception** and deceptive alignment;" before RF7. RF7's integrate_rf7.py added the "which the theory reaches" clause, so RF7 created this bullet's contradiction rather than sharpening it. The assistance-games bullet (line 23) already had the same "says nothing of … which the theory reaches" pattern.
2. The proposed replacement leaves the lead "It says nothing of:" unchanged, so "RF's readings reach…" would still sit under it. A fuller fix would scope the lead, or use 07 §9's "nothing … beyond" form.

Neither caveat refutes the problem. Severity low is appropriate.

## R20 (readings, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:227

**Quoted.** “| Deceptive alignment, alignment faking (Greenblatt and others 2024) | RF2; RF7 (round 2) | the possibility exact; the incentive a debt until RF7 |”

**Problem.** Next to the requested scope (§8's literature table, not §4.6 or §12). The row goes stale once RF7 lands: it still lists the incentive as a debt. It also does not record that RF7 restates Hubinger and others' §4 toy and their §4.5 random-defection remark.

**Replacement.** | Deceptive alignment, alignment faking (Hubinger and others 2019, §4; Greenblatt and others 2024) | RF2; RF7 | the possibility exact; the incentive in two stages, a reading (the §4 toy with weights; §4.5's random defection with an exact threshold); the third condition assumed; the rates empirical |

**Verdict: real.** The files bear the finding out. Its one literature claim that no file makes, about Hubinger §4.5, checks out against the paper.

(1) Staleness. integrate_rf7.py edits PLAN.md in only two places: it adds the §4.6 RF7 bullet and changes §12's order. `git diff` on the scratch PLAN.md shows only those two hunks. So line 227 in §8 still reads "| Deceptive alignment, alignment faking (Greenblatt and others 2024) | RF2; RF7 (round 2) | the possibility exact; the incentive a debt until RF7 |". In the same file, line 178 says RF7 "Landed on its own after RF6.1" and line 282 says "then RF7 (landed, §4.6)". The other integrated texts no longer treat the incentive as owed:
- 03's Open bullet (line 520) now lists only "of deception, beyond its incentive (§11), a recipient's false belief and an intention to cause one".
- ALIGNMENT.md line 28 says "RF7 adds the incentive".
- 08 §8 (line 485) says RF7 "restates the incentive deceptive alignment names (Hubinger … 2019)".

The best answer to "'a debt until RF7' is self-expiring, so not wrong" is the kit itself. board_rf2.py's land7 branch rewrites the matching board phrase "concealment as shaping an analogy until RF7." to "an analogy, which RF7's law replaces." So the kit already treats such phrases as needing an update at landing, yet it leaves this row unchanged. The row now states no standing for the incentive.

(2) Missing source. The row cites only Greenblatt 2024. The module's Standing paragraph and study_rf7.txt both say the two-stage comparison "generalizes the toy example opening §4 of Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019) … from certain keeping to weights". The record and the module's Readings also read it with Hubinger §4.2.

(3) §4.5. No repository file mentions §4.5 or random defection; the module cites only Piccione and Rubinstein 1997 for drawing afresh. Checked against the paper's text (Alignment Forum copy): §4.5, "Distributional shift and deceptive alignment", says the mesa-optimizer "need not be able to detect when training has ended" to have an incentive to defect randomly. It calls this an absent-minded driver problem and gives p≈0.61 for the Figure 4.1 toy. That is what `Prospects.FreshDrawAbove`, `freshDraw_above_iff_chance` and `freshDraw_above_iff` state, with weights and two stages. So the connection is accurate, but it is the finding's reading, not something RF7's texts claim.

Caveats:
- The location is outside the requested scope, as the finding itself says.
- The same staleness also sits at line 86 ("RF6.1, RF-M's other cases and RF7 follow"), at line 152 (§4.5's heading) and at line 191 (§5's row "analogies until RF-M and RF7 represent …"). Earlier landings also left §8's "(round 2)" tags.
- The record hashes PLAN.md (role integration), so any fix must come before the records are built.
- Any §4.5 wording must stay a labelled reading. It should not suggest rare defection: in the witness the chances that improve defect with chance above 3/4, the study dropped "rare defection", and the threshold is for some chance beating `ownAtBoth`, not an optimal p.

## F1 (fit, high, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:474; also _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:195-200 (law 8, EN and ZH)

**Quoted.** “complying with chance `m / (m + r)`, stands above acting by its own law at both exactly where `(m + r) (k_O V + c T) + r k_O V < r k_C V`”

**Problem.** `freshDraw_above_iff_chance` takes `pos : 0 < m`, and without it the equivalence is false. At m = 0 the plan is acting by its own law at both, so `FreshDrawAbove 0 r` fails, yet the displayed inequality can hold: on `Example.prospects` with r = 1 it reads 70 < 90, while FreshDrawAbove reads 10 < 10. The module header and the study both say 'for 0 < m'. The home section and the record's law 8, in English and Chinese, drop the condition, and no hypotheses item supplies it.

**Replacement.** 03: 'complying with chance `m / (m + r)` for `0 < m`, stands above acting by its own law at both exactly where ...'. Record law 8 EN: 'A law that cannot tell the stages apart but draws its act afresh at each stage, complying with chance m/(m+r) for positive m, stands above ...'. ZH: '不能分二阶而每阶重抽其行、以 m/(m+r) 之机从之律（m 为正），居二阶皆依己律之上，恰当 ...'.

**Verdict: real.** The finding is real. I tried to refute it and the files do not allow it.

1. The Lean needs the condition. At ReadStages.lean:621, `freshDraw_above_iff_chance (s) {m r} (pos : 0 < m)` states `s.FreshDrawAbove m r <-> (m + r) * (k_O V + c T) + r * (k_O V) < r * (k_C V)`. It is proved by `freshDraw_reduce pos`, which needs `pos` to multiply the reduced inequality by `m` (`Nat.mul_lt_mul_of_pos_left below pos`, line 614). The condition cannot be dropped. Unfolding the definition at lines 264-266 with m = 0 gives `r*(r*k_O V) + r*(0*cT) < r*(0*k_C V + r*k_O V)`, which is `r^2 k_O V < r^2 k_O V`. That is always false: chance 0 of complying is just acting by its own law at both.

2. The counterexample checks out. `Example.prospects = <10, 9, 1, 10, 5>` (line 695) gives k_O V = 10, c T = 50, k_C V = 90. At m = 0, r = 1 the displayed inequality reads (0+1)(10+50) + 10 = 70 < 90, which holds. FreshDrawAbove 0 1 reads 10 < 10, which fails. The same happens at r = 2 (140 < 180 against false). At m = 1 the two sides agree with the module's witnesses: (1,7) true, (1,4) true, (1,3) false.

3. The source states the condition where the finding says it does. The module header at lines 80-81 says "exactly where ... is below `r k_C V`, for `0 < m` (`freshDraw_above_iff_chance`)". The study template study_rf7.txt:36-37 says "for 0 < m".

4. Both quoted texts drop it.
- 03-KNOWING.md:474 says "complying with chance `m / (m + r)`, stands above acting by its own law at both exactly where `(m + r) (k_O V + c T) + r k_O V < r k_C V`". Neither the theorem's parenthetical nor the §11 opener (line 461) states a condition on m.
- In make_records_rf7.py:195-200, law 8 says the same in English ("complying with chance m/(m+r), stands above ... exactly where ...") and in Chinese ("以 m/(m+r) 之机从之律，居二阶皆依己律之上，恰当 ..."), with no positivity condition.
- The only hypotheses item (lines 213-217) does not supply it. Its "the arithmetic laws hold for all" even suggests the opposite.

So the per-chance "exactly where" is false as written at m = 0. That breaks the AGENTS.md rule that claims say exactly what the Lean proves, including its hypotheses.

5. The "for some chance" clause is fine. `freshDraw_above_iff` carries `0 < m` inside the existential, and FreshDrawAbove 0 r is never true anyway. The other texts state only this existential form: 08, the overview, ALIGNMENT, Becoming.lean, check_becoming.py, PLAN and board_rf2.py. The READMEs add "each result under the hypotheses its theorem states". So the two quoted locations are the only ones that state the per-chance equivalence without its condition.

6. The proposed fix fits. Law 8 is 371 of 420 characters in English and 137 of 190 in Chinese (style.ITEM_CAPS_V2 'laws'), so adding "for positive m" / "（m 为正）" stays within the caps.

## F2 (fit, high, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:3; also .../rf-formations-that-read/evidence/REVIEW-ROUND2.md (last section at line 726 is RF6.1's cold read), .../rf-formations-that-read/PLAN.md:325, .../kit/round2/board_rf2.py:76-79, .../kit/round2/make_records_rf7.py:124

**Quoted.** “then reviewed through four lenses with each finding verified against the Lean, rebuilt for the confirmed ones and re-checked, and its texts cold-read ([REVIEW-ROUND2]\(development/rf-formations-that-read/evidence/REVIEW-ROUND2.md))”

**Problem.** REVIEW-ROUND2.md has no section on Concealment or ReadStages. It holds ReadingLoop's review, the re-check of ReflexivePrediction and OpenedCorrection, what was taken, round 2's cold read, and RF6.1's re-check and cold read. RF7's reviews exist only in the session scratchpad, which is wiped on restart: rf7-review-astra.md, rf7-recheck-astra.md, rf7-wf-findings*.txt, rf7-wf-result.json (42 confirmed, 8 refuted), rf7-v3-astra.md, rf7-v4-recheck-astra.md and rf7-coldread-astra.md. PLAN §13's 'The review of round 2's Lean' covers ReadingLoop, ReflexivePrediction and OpenedCorrection only. Yet the board's land7 text cites plan §13 for the review history, and the record carries REVIEW-ROUND2 as an integration reference. As landed, the study's link and the record's reference point to evidence that does not contain the review they cite.

**Replacement.** Before landing, append these sections to REVIEW-ROUND2.md from the scratch files: 'The review of `Becoming.Concealment` (RF7) and its re-check', 'The four-lens review of RF7, each point verified' (with the confirmed and refuted points and what was taken), 'The re-check of the rebuilt `Becoming.ReadStages`' and 'The cold read of RF7's texts'. Add to PLAN §13: '`Becoming.ReadStages` (RF7, first `Becoming.Concealment`) had a cross-model review (seven findings, re-checked), a four-lens review whose 50 points were each verified (42 confirmed, 8 refuted), a re-check of the rebuilt module (nine points, all taken, confirmed) and a cold read of its texts ([REVIEW-ROUND2]\(evidence/REVIEW-ROUND2.md)).' Point the study's link at the new section's anchor.

**Verdict: refuted.** The finding is literally true of the scratch copy, but its central claim, that RF7's reviews were never saved, is refuted by the kit the rehearsal was copied from.

What holds, in the scratch copy:
- wt-rf7-rehearse/.../evidence/REVIEW-ROUND2.md is main's unmodified file. git status in the copy does not list it. It has 790 lines and its last heading, at line 726, is "The cold read of RF6.1's texts". RF7 appears only at line 92, as a design suggestion in ReadingLoop's review.
- PLAN.md §13 (line 325) names only ReadingLoop, ReflexivePrediction and OpenedCorrection.
- make_records_rf7.py:124 cites REVIEW as an 'integration' reference.

What is false: the claim that "RF7's reviews exist only in the session scratchpad". The kit worktree /Users/ren/theories/.claude/worktrees/rf-landing (branch rf-round2) is where the rehearsal's kit comes from: its study_rf7.txt and ReadStages.lean are byte-identical to the copy's. It holds the reviews:
- Its evidence/REVIEW-ROUND2.md has 1125 lines, last modified 04:44, which is after the first rehearsal and before rehearsal2 and this workflow. Its RF7 sections are:
  - "The review of RF7's module" (line 791)
  - "The re-check of RF7's rebuilt module" (line 939)
  - "The four-lens review of RF7's module" (line 973): 50 findings, 42 confirmed and 8 refuted, with a table of what was taken
  - "The re-check of the renamed module" (line 1030): nine findings, all taken correctly
- evidence/REVIEW-RF7-LENSES.md gives all 50 points verbatim (42 headed confirmed, 8 refuted).
- evidence/BRIEF.md has every RF7 prompt (lines 262, 283, 291, 344 and 387, the last for this cold read).

Both rehearsal copies (wt-rf7-rehearse at 04:37, wt-rf7-rehearse2 at 04:48) carry main's evidence folder by construction: integrate_rf7.py edits only PLAN §4.6 and §12, never the evidence. So once the kit's evidence is committed, the study's link and the record's reference (whose sha256 is taken at build time in the landing worktree) will point to a file that holds the reviews. That is how RF6.1 went: kit commit 861b8d395 added REVIEW-ROUND2 and BRIEF entries before its landing in 580cd9d62. The proposed fix would duplicate sections that already exist.

Residual points, none of them the stated problem:
- The evidence edits in rf-landing are uncommitted.
- The cold read of RF7's texts is not yet appended. It is this workflow's output, and its brief is already in BRIEF.md.
- PLAN §13 also omits RF6.1's later re-check and cold read. §4.6 carries those, and both §13 and §4.6 link to REVIEW-ROUND2.
- board_rf2.py lines 76–79 change nothing on main's board: the old sentence occurs 0 times and the new one already occurs once. The "(plan §13)" citation was there before and leads to REVIEW-ROUND2.

## F3 (fit, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:474 (and its Reading, line 476)

**Quoted.** “Its prospects are a total; the weight of its law's being kept after it complies when read, and after it acts by its own law then; the value of acting by its law at the unread stage where kept; and the loss of complying when read (`ReadStages.Prospects`).”

**Problem.** The paragraph and its Reading then state every law in terms like `k_O V + c T < k_C V`, `k_O V` and `2 k_O V + c T`, 14 uses in all. They never say which symbol is which. Only the module header gives the key ('writing `T` for the total, `k_C` and `k_O` for the two weights, `V` for the value and `c` for the loss'). A reader of the home section cannot follow the thresholds.

**Replacement.** Its prospects are a total `T`; the weights `k_C` and `k_O` of its law's being kept after it complies when read and after it acts by its own law then; the value `V` of acting by its law at the unread stage where kept; and the loss `c` of complying when read (`ReadStages.Prospects`).

**Verdict: real.** The finding holds. The files show the letters are never bound in the home section, and only the Lean module header gives the key.

1. **The quoted sentence.** It matches 03-KNOWING.md line 474 (anchor `r-when-complying-when-read-is-best` at line 473) word for word, and it names the prospects only in words, with no letters.

2. **The uses.** After that sentence, line 474 states its thresholds in 8 code expressions that use the letters:
   - `k_O V + c T < k_C V`
   - `k_O V`
   - `k_C V < k_O V + c T`
   - `0 < c T`
   - `k_O V + c T`
   - `(m + r) (k_O V + c T) + r k_O V < r k_C V`
   - `2 k_O V + c T < k_C V`
   - `k_O V`

   The Reading at line 476 adds `2 k_O V + c T < k_C V`. Across the two lines `k_C` occurs 5 times and `k_O` 9 times, so the finding's "14 uses" is accurate as a count of the weight letters.

3. **No binding anywhere a reader would look.**
   - No other code span in 03-KNOWING.md uses `c`, `T` or `V`, so nothing earlier in the chapter binds them.
   - A grep of all of `theories/` finds `k_C` and `k_O` only at 03:474 and 476, THE-THEORY-OF-BECOMING.md:96, 08-METHOD.md:485 and ALIGNMENT.md:28. All of these use the letters bare.
   - The record in make_records_rf7.py also uses them bare: its statement says "gains exactly where k_C V > 2 k_O V + c T", and its law items do the same. Following the [record] link does not help.
   - check_becoming.py:2809, study_rf7.txt, PLAN.md and board_rf2.py also use them with no key. The "for the total" match at check_becoming.py:700 belongs to another module.

4. **Where the key is.** The only key is in the ReadStages.lean header: "writing `T` for the total, `k_C` and `k_O` for the two weights, `V` for the value and `c` for the loss". The `Prospects` fields themselves are named `total`, `keptComplying`, `keptOwn`, `value` and `cost`. The letters are notation in the docstrings, not Lean names a reader could look up.

5. **Refutation attempt.** The strongest case against the finding is the gloss after the first threshold: "which in probabilities is the weight complying adds to being kept, times the value, strictly exceeding the loss". With the C/O and V/T mnemonics, it lets a careful reader partly reconstruct the first inequality. It still leaves things unsaid:
   - that `c` is the loss and `T` the total (`c` is not a mnemonic for "loss");
   - that `c T` is the loss times the total;
   - any gloss at all for the own-law-at-both, uniform and fresh-draw thresholds.

   "Cannot follow" slightly overstates the first threshold, but the defect is real and not a matter of taste. Results are stated once, in their home section, and claims must say exactly what the Lean proves. A formal statement in unbound letters does not do that.

6. **The proposed replacement is correct.** It matches the header key and the fields: `T` for `total`, `k_C` for `keptComplying` (after complying when read), `k_O` for `keptOwn` (after acting by its own law when read), `V` for `value` and `c` for `cost` (the loss).

The same bare letters also appear in the record's statement and law items, the overview (THE-THEORY-OF-BECOMING.md:96), 08-METHOD.md:485 and ALIGNMENT.md:28. Fixing only the 03 sentence leaves those texts as they are.

## F4 (fit, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:461; also theories/becoming/chapters/07-SIGNIFICANCE.md:647 and theories/becoming/review/ALIGNMENT.md:21,28

**Quoted.** “A third states when acting otherwise where not read is a formation's own best plan, in two stages.”

**Problem.** The law ranks four plans by supplied prospects. Whose prospects they are is a reading: the module says so ('Whose these weights are, the formation's own assessment or the selection the reading actually applies, is a reading (below), not part of the model'), and so does the record's first does_not_show item. Three texts present that reading as the result's content. 03's opening attributes 'a formation's own best plan' to the law itself ('A third states'). 07's row puts it under 'the laws say'. The dossier's box calls the result 'a formation's best plan among four'. The home Reading, by contrast, places the formation's own assessment under 'If the prospects are ...'.

**Replacement.** 03: 'A third states when complying when read and acting by its own law when not is uniquely best among four plans under given prospects, in two stages.' 07: '... nor anything of deception beyond where behaviour can differ when not read and when complying only when read is uniquely best among four plans under given prospects (...)'. Dossier line 28: '... is uniquely best among four plans under given prospects, which the readings take as the formation's own assessment, exactly where ...'; line 21: '... and of when complying only when read is the best of four plans'.

**Verdict: real.** The finding holds. The clearest cases are 03 and 07. One sub-location (dossier line 21) is weaker than claimed.

What the Lean proves: `Prospects` is five unowned natural numbers. `Above` is "in the order the prospects give" (ReadStages.lean:241). The header says the module states "when that plan is the one the prospects of the two stages rank best" (l.9). It also says: "Whose these weights are, the formation's own assessment or the selection the reading actually applies, is a reading (below), not part of the model" (l.36-37), and "the order on plans is the prospects'" (l.170). The formation's own assessment appears only inside the [AI reading] paragraph, as a conditional: "If the prospects are the formation's own expected-value assessment, the laws characterize strict optimality…" (l.141-142). The record's first does_not_show item says the same (make_records_rf7.py:218-220).

The texts:
- 03-KNOWING.md:461 attributes the reading to the law: "A third states when acting otherwise where not read is a formation's own best plan, in two stages." The only thing that paragraph marks as a reading is reading the selection "as a training, a helper, an overseer or a court".
- 07-SIGNIFICANCE.md:647 puts it under what "the laws say": "nor anything of deception beyond … when complying only when read is a formation's own best plan".
- ALIGNMENT.md:28, in the box, reports what RF7 adds as "is a formation's best plan among four exactly where…".

Each of these assigns the order to the formation, which the model leaves open. The integrated texts themselves draw the line the finding asks for:
- THE-THEORY-OF-BECOMING.md:96 gives the proved part as "best among a formation's four plans". It puts "when doing so is its own best plan" in the sentence tagged [AI reading].
- 08-METHOD.md:485 and study_rf7.txt say "strict optimality … in the order the prospects give".
- The board and PLAN say "best among four plans" or "best exactly where".
- 03's own Reading (l.476) keeps "its best plan" and "If the prospects are the formation's own expected-value assessment" under its label.

So 03's opening and 07's row present the reading as the law's content, against the module's explicit statement and the overview's labelling. That breaks the rules that claims say exactly what the Lean proves and that readings are never presented as theorems.

A possible defence is that "own" means only "its", and that 03's theorem already says "Its prospects". That fails. "Its prospects" (the prospects it faces) fits either reading. "A formation's own best plan" makes the formation's order the ranking, which the module calls a reading.

Caveats:
- ALIGNMENT.md:21 already places the phrase under "RF's readings of …", the same placement as the overview, so that line is defensible as it stands. Its proposed edit is optional.
- Line 28 has no "own", so it is weaker, though it still attributes the best plan to the formation.

The core of the finding is real; medium severity is arguable, and low-medium may fit better.

## F5 (fit, medium, confirmed)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:96; also .../theories/becoming/review/ALIGNMENT.md:28, .../lean/becoming/README.md:198, .../lean/becoming/README.zh.md:144, .../rf-formations-that-read/PLAN.md:178, .../kit/round2/board_rf2.py:56

**Quoted.** “complying when read and acting by its own law when not is best among a formation's four plans exactly where the weight complying adds to being kept, times the value, exceeds the loss of complying”

**Problem.** At equality the plan is still a best plan. `complyThenOwn_maximal_iff` makes it maximal with ties included, and on `Example.tie` both it and acting by its own law at both have expected value 1, against −8 and 0 for the other two plans. So 'best ... exactly where' a strict inequality holds is false if 'best' means 'a best plan'. The record says 'uniquely best'; 03, the root bullet and SCOPE say 'stands above every other plan'. These six summaries say only 'best' (in Chinese, '最优恰当').

**Replacement.** Overview, dossier, PLAN and board: 'is uniquely best among the four plans exactly where ...'. README: 'uniquely best exactly where ...'. README.zh: '于四策中唯一最优，恰当从所增之被守之权乘值严胜损乘总'.

**Verdict: real.** The files back the finding on every point I checked.

The Lean: ReadStages.lean proves two different boundaries. `complyThenOwn_best_iff` (l.286-287) says complyThenOwn stands above every other plan ↔ `k_O V + c T < k_C V` (strict). `only_complyThenOwn_iff` (l.358-359) says complyThenOwn is the only maximal plan under the same strict condition. `complyThenOwn_maximal_iff` (l.370-373) says complyThenOwn is maximal, meaning nothing stands above it, ↔ `k_O V + c T ≤ k_C V`, "ties included". `Example.tie` (l.728-733) has total 10, weights 9 and 1, value 10 and loss 8. There 1·10+8·10 = 90 = 9·10, so neither plan stands above the other. Using the header's table, the four expected values are −8, 1, 0 and 1. So at equality complyThenOwn is still a best plan, tied with ownAtBoth.

The header calls the weak notion "Every optimizing choice, a plan nothing stands above (`Prospects.Maximal`)". It uses "strictly best" and "uniquely strictly best" for the strict notion (l.46, 58, 93), and the docstring at l.692 says "strictly best".

The six summaries read as follows:
- Overview l.96: "is best among a formation's four plans exactly where ... exceeds".
- ALIGNMENT l.28: "is a formation's best plan among four exactly where ... exceeds".
- README l.198: "best exactly where ... exceeds".
- README.zh l.144: "最优恰当…严胜".
- PLAN l.178: "best exactly where ... exceeds".
- board_rf2.py l.56: "best among four plans exactly where ... exceeds".

Each pairs the bare word with a strict condition in an "exactly where" claim. If "best" means a best (optimizing) plan, the iff is false at the tie the Lean itself exhibits.

The precise texts say more:
- The record's statement (make_records_rf7.py l.146) says "uniquely best", and its Chinese (l.148) says "唯一最优".
- The record's law 3 (l.165-167) says "no other plan is ever uniquely best" and "他策无一唯一最优". That usage treats bare "best" and "最优" as not implying uniqueness.
- 03 §11, the root bullet (Becoming.lean l.2217) and SCOPE (check_becoming.py l.2803-2805) say "stands above every other plan".
- The study template records that an earlier review asked for "the plan stated as uniquely strictly best".

Against the finding: the theorem names (`_best_iff`) and the titles do use "best" for the strict notion. But they are identifiers and headings, not iff summaries. AGENTS.md asks claims to state strictness exactly, and the record's own vocabulary separates best from uniquely best. So this is an inexact strictness claim, not a matter of taste. The Chinese "最优" without "唯一" is the clearest case.

The proposed replacement ("uniquely best", "唯一最优") matches the record's statement and both cited theorems.

## F6 (fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:190-194 and 266-269; also .../lean/becoming/Becoming/ReadStages.lean:69-70, 105-106, 495-496, .../lean/becoming/Becoming.lean:2222, .../lean/becoming/check_becoming.py:2807, .../kit/round2/study_rf7.txt:58

**Quoted.** “RF2's laws at the two stages: where the lumping tells them apart, every selection through agreement on the read stage that selects a law complying when read also selects one taking the plan; where it ties them, the read stage fixes the act at the unread one”

**Problem.** `Learning.lumped_determines` is a law of `Becoming.Learning` (Learning.lean:858). It is cited by the record generalization-through-lumping, not by RF2's record. RF2's own record says the act 'is fixed by generalization through lumping (lumped_determines; ...)', and 03 §11 says §6's law fixes the act and 'What this law adds is the twin'. Six texts nonetheless credit the fixing to RF2: the module ('RF2's `Learning.lumped_determines`'; its Standing says '`lumped_uniform`, `read_fixes_unread` and `twin_complyThenOwn` are RF2's laws'), the record's law 7, the record's dependency on what-readings-fix-of-the-unread ('Learning.lumped_determines and Learning.twin_selected'), the root bullet, SCOPE, and the study ('RF2's twin and fixing'). Only `twin_complyThenOwn`, through `Learning.twin_selected`, is RF2's; `lumped_uniform` applies `Learning.Lumped`.

**Replacement.** Record law 7: 'The laws of the unread at the two stages: where the lumping tells them apart, RF2's twin: every selection ... also selects one taking the plan; where it ties them, generalization through lumping: the read stage fixes the act at the unread one; ...'. Dependencies: generalization-through-lumping, 'Learning.Lumped and Learning.lumped_determines, at the two stages'; what-readings-fix-of-the-unread, 'Learning.twin_selected, at the two stages'. Module line 70: '(`read_fixes_unread`, `Learning.lumped_determines`, the generalization law RF2 reads)'; lines 105-106: '`twin_complyThenOwn` is RF2's law at the two stages, and `lumped_uniform` and `read_fixes_unread` are `Learning`'s'; lines 495-496 likewise. Root bullet and SCOPE: 'with `Unread`'s twin and `Learning`'s fixing at the two stages'.

**Verdict: real.** The files bear the finding out. The only loose point is one phrase, which does not change it.

Where the laws live:
- `lumped_determines` is declared in Learning.lean at line 858. It is listed as a law of the record generalization-through-lumping (its second law, with decideSeen and determines_lumped_iff).
- `twin_selected` is declared in Unread.lean at line 104, which is RF2's module. RF2's record lists it as its second law.

What RF2's own texts say about the fixing:
- RF2's record (what-readings-fix-of-the-unread.json) does not list lumped_determines among its laws or its proof declarations. Its hypothesis says: "the act is fixed by generalization through lumping (lumped_determines; ...): read here, cited, not proved again". Its dependency on generalization-through-lumping names "Learning.Lumped, Free, Determines and lumped_determines".
- Unread.lean's header says the fixing is `Learning.determines_lumped_iff` "read here, not proved again".
- RF2's home paragraph, 03-KNOWING.md line 469, says §6's law fixes the act and "What this law adds is the twin".

How ReadStages uses them:
- `read_fixes_unread` (ReadStages.lean:497-499) is `Learning.lumped_determines ⟨true, rfl, same⟩`, which applies Learning's law directly, not RF2's.
- `lumped_uniform` (lines 450-452) is `alike true false same`, which is just the definition of `Learning.Lumped`.
- Only `twin_complyThenOwn` (lines 505-521) goes through `Learning.twin_selected`, the one law here that is RF2's.

The texts that nonetheless credit the fixing to RF2:
- ReadStages.lean line 70: "RF2's `Learning.lumped_determines`".
- Lines 105-106: "`lumped_uniform`, `read_fixes_unread` and `twin_complyThenOwn` are RF2's laws at the two stages".
- Lines 495-496, the docstring of `read_fixes_unread`: "RF2's `Learning.lumped_determines`".
- make_records_rf7.py law 7, lines 190-194: "RF2's laws at the two stages ... the read stage fixes the act at the unread one". This item also lists `kept_alike`, which is ReadStages' own congrArg and not RF2's either, so the label overreaches further than the finding says.
- The dependency at lines 268-269 files "Learning.lumped_determines and Learning.twin_selected" under what-readings-fix-of-the-unread. Meanwhile the dependency on generalization-through-lumping, the record that actually holds lumped_determines, names only Learning.Lumped. This is a plain error in the dependency audit.
- Becoming.lean:2222 and check_becoming.py:2807-2808: "with RF2's twin and fixing at the two stages".
- study_rf7.txt:58: "RF2's twin and fixing at the two stages". The study's own Delta at lines 30-32 correctly says "by Learning.lumped_determines", so it contradicts itself.

The loose phrase: the finding says lumped_determines is "not cited by RF2's record". RF2's record does mention it, but only as generalization through lumping's law, which is exactly the finding's point. So these texts misattribute a law and a dependency in a way that conflicts with RF2's own record and home section. It is not a matter of taste.

## F7 (fit, medium, confirmed)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:96; also theories/becoming/review/ALIGNMENT.md:28

**Quoted.** “and then it still gains by complying with some chance exactly where `k_C V > 2 k_O V + c T`”

**Problem.** Neither the overview nor the dossier defines `k_C`, `k_O`, `V`, `c` or `T`; each uses them twice with no key. 'Still gains' does not say against what. The dossier's version ('still gains by complying with some chance where `k_C V > 2 k_O V + c T`') also drops 'exactly'. Read alone, it would also apply to a law that can tell the stages apart, a case the model does not treat.

**Replacement.** Overview: 'and then it still does better than acting by its own law at both, by complying with some chance at each stage, exactly where, read as probabilities, the weight of being kept after complying, less twice that after acting by its own law, times the value, exceeds the loss of complying'. Dossier: 'a law that cannot tell the stages apart but draws its act afresh at each stage still does better than acting by its own law at both, by complying with some chance, exactly where, read as probabilities, the weight of being kept after complying, less twice that after acting by its own law, times the value, exceeds the loss'.

**Verdict: real.** The files bear out the finding's substance.

(1) No key for the symbols. A grep shows that THE-THEORY-OF-BECOMING.md:96 and review/ALIGNMENT.md:28 are the only places in either file with `k_C` or `k_O`. Neither file says what `k_C`, `k_O`, `V`, `c` or `T` stand for, and GLOSSARY.md has no entry for them. The only key is in the Lean module header, ReadStages.lean lines 19-21: "writing `T` for the total, `k_C` and `k_O` for the two weights, `V` for the value and `c` for the loss". The link targets do not supply one either. 03-KNOWING.md:474 uses `k_O V + c T < k_C V` with no key, and so does the record's statement (make_records_rf7.py:147). This goes against both documents' own terms: the overview's "How to read this" says it is "for a reader who does not read Lean", and ALIGNMENT.md:46 says "No Lean is needed to review". The finding's "each uses them twice" is loose: each file has the formula once, with `V` in it twice. That does not change the problem.

(2) "Still gains" names no comparator. What the Lean proves is `freshDraw_above_iff` (lines 660-664) about `FreshDrawAbove`, which the definition (lines 258-266) makes a comparison with `ownAtBoth`. The chapter names that comparator: "stands above acting by its own law at both exactly where..." (03:474), and the module's Reading says "improve on acting by its own law at both". The overview's "it still gains by complying with some chance" and the dossier's "still gains" both drop it. In the overview this also comes right after "best among a formation's four plans", which invites reading it against the wrong set of plans.

(3) The dossier drops "exactly". It says "still gains by complying with some chance where `k_C V > 2 k_O V + c T`", but the Lean is an iff. What it states is only the sufficient direction, so it loses the "only there" that makes the threshold `2 k_O V + c T` meaningful.

(4) The dossier's subject is unrestricted. It says "a law drawing its act afresh at each stage" without "that cannot tell the stages apart". The module restricts the fresh draw to exactly that case, one chance at both stages (lines 76-79), and lists "chances where the stages are told apart" among what it leaves out (lines 165-166). The overview's subject ("a law that cannot tell the stages apart ... unless it draws its act afresh") is restricted correctly. In the dossier only context, the word "still" after the third exit, implies the restriction.

The proposed replacements are correct: (p_C − 2p_O)V > c is equivalent to 2k_O V + cT < k_C V.

## F8 (fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:145-153 (statement, law 1; laws 3-8 at 162-200)

**Quoted.** “with the stages not told apart, a chance drawn afresh gains exactly where k_C V > 2 k_O V + c T.”

**Problem.** The record's statement and laws 3 to 8 are written in k_C, k_O, V, c and T, and no field of the record defines them; law 1 lists the prospects in words only. The record page is read on its own. 'Gains' also does not say against what.

**Replacement.** Law 1 EN: '... the prospects are a total T, the weights k_C and k_O of the law's being kept after complying when read and after acting by its own law then, the value V of acting by its law at the unread stage where kept, and the loss c of complying when read; ...'. ZH: '其望为一总 T、读时从后与读时依己律后其律被守之权 k_C 与 k_O、不读时依其律而被守之值 V、读时从之损 c；...'. Statement: '...; with the stages not told apart, a chance drawn afresh does better than acting by its own law at both exactly where k_C V > 2 k_O V + c T' (or, if the cap binds, in words: 'exactly where, as probabilities, the weight kept after complying, less twice that after acting by its own law, times the value, exceeds the loss').

**Verdict: real.** The finding holds. Its only error is minor: law 7 contains no letters.

1. **The letters are used.** make_records_rf7.py line 147 puts "k_C V > 2 k_O V + c T" in the statement. The letters also appear in law 3 (lines 162-163), law 4 (171), law 5 ("0 < c T", 179), law 6 (186), law 8 (196-197) and the correspondence (257). Law 7 (lines 190-192) uses none, so "laws 3 to 8" is one law too wide.

2. **No field defines them.** Law 1 (lines 149-153) names the total, the two weights, the value and the loss in words only, with no letter attached. No other field defines them either: hypotheses (213-217), does_not_show, counterexamples, validation (238-243), next_delta, correspondence, aliases, dependencies or related.

3. **The only definition is in the Lean.** The ReadStages.lean module header, lines 19-21, says: "writing `T` for the total, `k_C` and `k_O` for the two weights, `V` for the value and `c` for the loss".

4. **The record page is read on its own.** registry.py's render_record_v2 (lines 971-1041) builds the page only from the record's JSON fields. The page's statement link goes to 03-KNOWING.md, but the home paragraph there (line 474) also writes `k_O V + c T < k_C V` without defining the letters. So the reader would have to open the Lean file.

5. **The letter c cannot be recovered from the record's words.** The record calls it "the loss", but the letter comes from the Lean field `cost`, a word style.py's MARKET_EN warns against.

6. **"Gains" has no comparator.** The Lean result freshDraw_above_iff (lines 658-664) concerns FreshDrawAbove, which is defined (lines 258-266) as the fresh draw standing above acting by its own law at both stages. The English statement says only "gains" and the Chinese only "有所得", so the comparator in the theorem is missing. Law 2 also uses "gain" as a technical term (Prospects.gain), so "gains" can be misread as "has a positive gain", which is a different condition. This breaks the rule that claims say exactly what the Lean proves.

7. **The fix needs cuts elsewhere.** The English statement is 299 characters against a hard cap of 300 (style.STATEMENT_CAP), so any replacement must shorten other text. This does not change whether the finding is real.

## F9 (fit, medium, confirmed)

**Location.** theories/becoming/chapters/08-METHOD.md:485

**Quoted.** “restates the incentive deceptive alignment names (Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant 2019) as strict optimality over four plans”

**Problem.** Every bullet in this list names the prior result its law restates. The module's Standing and the study name two. First, the two-stage comparison 'generalizes the toy example opening §4 of Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019) ... from certain keeping to weights'. Second, drawing afresh against a single mixture 'is the advantage of behavioural over mixed strategies under imperfect recall (Piccione and Rubinstein 1997)'. This bullet says 'restates' where the module says 'generalizes', names an 'incentive' instead of the toy example, and omits Piccione and Rubinstein. As a result, the fresh-draw law is credited to prior work nowhere in the chapters.

**Replacement.** 'When complying when read and acting by its own law when not is best ([03 §11]\(03-KNOWING.md#r-when-complying-when-read-is-best)) generalizes the toy example opening §4 of Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019) from certain keeping to weights, as strict optimality over four plans in the order the prospects give, ...; that drawing the act afresh at each stage can gain where the stages cannot be told apart, while a single mixture of the uniform plans never does, is the advantage of behavioural over mixed strategies under imperfect recall (Piccione and Rubinstein 1997). It represents neither a recipient's belief nor an intention to cause one. Near-definitional, with witnesses.'

**Verdict: real.** The finding holds. The main problem is that no chapter credits the fresh-draw law to prior work. The wording differences are true as stated but minor.

1. **The bullet (08-METHOD.md:485, the only RF7 line in 08).** It says the law "restates the incentive deceptive alignment names (Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant 2019) as strict optimality over four plans". It then describes the fresh-draw law: "the threshold rising from k_O V + c T to 2 k_O V + c T, against a single mixture of the uniform plans, which never gains". It names no prior result for that law and ends "Near-definitional, with witnesses."

2. **The module and the study name two prior results.** The Standing in ReadStages.lean says "The two-stage comparison generalizes the toy example opening §4 of Hubinger ... (2019) ... from certain keeping to weights". It then says drawing afresh gaining "while a single mixture of the plans open there cannot, is the advantage of behavioural over mixed strategies under imperfect recall (Piccione and Rubinstein 1997)". The Standing in study_rf7.txt makes the same two attributions.

3. **The Lean supports the second attribution.**
   - `FreshDrawAbove` draws the act independently at each stage, which is a behavioural plan.
   - `MixtureAbove` makes one draw between the uniform plans, which is a mixed plan.
   - `freshDraw_above_iff` shows the fresh draw gains exactly where `2 k_O V + c T < k_C V`.
   - `mixture_never_above` shows the single mixture never gains.

   This is the absent-minded-driver pattern, so dropping the credit is not dropping a wrong citation.

4. **Nothing else in the texts gives the credit.** I searched the whole of `theories/` (all chapters, the overview, review/ALIGNMENT.md) for:
   - Piccione and Rubinstein
   - imperfect recall
   - behavioural/mixed strategies
   - Isbell and Kuhn

   None appears. The 03 §11 theorem and its Reading, the 07 row, the overview's §3 and the alignment dossier describe the fresh-draw law without crediting it. The record script make_records_rf7.py omits it too.

5. **The list's own practice.** Other bullets in §8's list name a prior result for each law. The reading-loop bullet, for example, names one for each of its four laws. RF7's bullet names one for its first law only.

6. **The two wording points.** The bullet does say "restates" where the module says "generalizes ... from certain keeping to weights", and it does name the incentive instead of the toy example. The study's own "What it adds is the incentive deceptive alignment names stated as strict optimality" is close to the bullet's wording, so these two points are a precision issue rather than an error.

## F10 (fit, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:474 (and 476)

**Quoted.** “while the first two exits hold against such a law (`ReadStages.freshDraw_not_above_without_value`, `ReadStages.freshDraw_not_above_of_not_raised`)”

**Problem.** Nothing in the paragraph is called an exit, and 'the first two' implies a third that the paragraph never names. The Reading on line 476 then says 'the exits are conditions on that assessment'. The three exits are listed only in the module's Readings and in the dossier, so 03's reader cannot follow either sentence.

**Replacement.** 474: 'while with no value at the unread stage, or with complying not raising the weight of being kept, no such law stands above it either (...)'. 476: 'the exits, no value at the unread stage, complying not raising the weight of being kept and, for a deterministic law, stages it cannot tell apart, are conditions on that assessment ...'.

**Verdict: real.** The files show the problem. A word-boundary search of 03-KNOWING.md finds the word "exit" in prose only twice: line 474 ("while the first two exits hold against such a law") and line 476 ("the exits are conditions on that assessment and on what its law reads"). Its other hits are not prose. One is the Lean identifier `ReadStages.Example.exit_tie` inside a parenthetical on line 474. The other is the anchor `02-MAP.md#r-exit-from-a-margin` on line 456, which uses "exit" in a different sense: a course leaving a margin. Section 11's opening on line 461 never uses the word. Line 474 does state the two conditions ("Keeping outweighs the loss only with a value at the unread stage and complying raising the weight of being kept ...; without either, the choice is acting by its own law at both"), and it states the lumping case. But it calls none of them an exit, and nothing marks the lumping case as the third that "the first two" implies.

The module defines what 03 leaves out. At ReadStages.lean lines 89-92, "The first two exits hold against drawing afresh:" is followed straight away by "with no value at the unread stage, or with complying not raising the weight of being kept, no such plan stands above `ownAtBoth`". 03 keeps the claim and drops that gloss. At lines 141-145, the Readings end "the exits are conditions on that assessment ... not levers the model gives a reader:" and then list the three: no value beyond the read stage; an assessment in which complying does not raise the weight of being kept; and, for a deterministic act law, a reading it cannot tell from not being read. 03's line 476 keeps that sentence but replaces the list after the colon with a different clause.

The three exits are listed together only there and in ALIGNMENT.md line 28, whose title is "Review dossier A". The record in make_records_rf7.py says "the exits are conditions on it" and "A tie at an exit" without listing them. 08-METHOD.md line 485 likewise says "the exits" with no list. So the location claim holds.

The Lean confirms that the proposed wording is exact. `freshDraw_not_above_without_value` assumes `s.value = 0`, `freshDraw_not_above_of_not_raised` assumes `keptComplying ≤ keptOwn`, and each concludes `¬ s.FreshDrawAbove m r` for all m and r.

Trying to refute it: a reader who knows Lean could partly work out the referents from the identifier suffixes (`_without_value`, `_of_not_raised`, `exit_tie`), from the order in which the conditions appear, and from the nearby clause "not telling the stages apart ... does not remove complying when read". So "cannot follow either sentence" overstates it a little. Still, the home section uses an undefined term with a definite article, and the word already has other senses in the theory (02 §5's exit from a margin, 07's reserved exit). That is a real clarity defect, not a matter of taste.

## F11 (fit, medium, confirmed)

**Location.** theories/becoming/results/records/what-readings-fix-of-the-unread.json:124 (and :82)

**Quoted.** “Disclosure or concealment when read, in two stages, with the continuation value represented (RF round 2); a frozen test of the chain on a trained model with cues varied apart from content; review by a person.”

**Problem.** RF7 is exactly this next step, but no kit script (integrate_rf7, reland_rf7, repoint_rf7) changes this record. After the landing, RF2's record will still name as its next step what the new record states. Its does_not_show item 'an incentive to differ where unread' will not be connected to the new record either, and RF2's related list does not point to it. There is precedent for updating it: UE21's landing brought free-energy-bounds-surprisal's next step and does-not-show item to its new record.

**Replacement.** next_delta: 'A frozen test of the chain on a trained model with cues varied apart from content; review by a person. When acting otherwise where not read is best, in two stages, is stated in when-complying-when-read-is-best.' does_not_show: 'Intention, anticipation or another's false belief; when acting otherwise where unread is best is when-complying-when-read-is-best's.' Add when-complying-when-read-is-best to its related list, with the zh texts.

**Verdict: real.** The files support the finding. I found nothing that refutes it.

1. **The quoted lines are as stated.** In what-readings-fix-of-the-unread.json, line 124 (next_delta) reads "Disclosure or concealment when read, in two stages, with the continuation value represented (RF round 2); a frozen test ...". Line 82 (does_not_show) reads "Intention, anticipation, another's false belief or an incentive to differ where unread." The related list holds only what-training-installs and what-choices-show-of-an-order. Main has the same text (git show main), so no later commit changed these fields.

2. **RF7 is exactly that next step.**
   - PLAN.md line 169 designs RF7 as "Disclosure or concealment, two stages ... with the probabilities of its law being kept and the continuation value represented".
   - ReadStages.lean's header says it states the plan "with the weights of the law's being kept and the value of acting by it later represented (board item RF, round 2: RF7)". V there is "the value of acting by its law at the unread stage where kept".
   - The Reading reads complyThenOwn as concealment and ownAtBoth as disclosure.
   - The new record names the incentive RF2's does_not_show item mentions: "this is the incentive".

3. **No kit script touches those fields.**
   - integrate_rf7.py edits the module, checker, root file, READMEs, chapters 03/07/08, the overview, ALIGNMENT, PLAN and regions.json. It writes no record.
   - reland_rf7.py moves aside and rebuilds only RIDS=('when-complying-when-read-is-best',).
   - make_records_rf7.py writes only the new record. It asserts the file does not exist, and only checks that RF2 exists as a dependency.
   - repoint_rf7.py expects RF2's record to drift (EXPECTED holds 'r-what-readings-fix-of-the-unread'). It re-points it through tools/research/repoint.py, which by its docstring changes only reviewed hashes and receipts.
   - register_rf7.py edits only THEOREM-CONNECTIVITY-APART.json, and board_rf2.py land7 edits only the board.
   - study_rf7.txt's "Output → input" list does not mention RF2's record.

4. **The landing makes the record and its home chapter disagree.** integrate_rf7.py deletes "disclosure or concealment when read, in two stages" from 03's Open bullet as done, pointing it to r-when-complying-when-read-is-best. RF2's record, whose home is the same 03 §11, would still show that item as its Next. The rendered page what-readings-fix-of-the-unread.md shows that Next section. RESULT-WORKFLOW defines next_delta as "The next substantive step" and says to refresh reviewed_at_utc when a record's next step or related notes change.

5. **The precedent is real.** UE21's landing (commit 9bc918584) dropped the done core form from free-energy-bounds-surprisal's next_delta. It rewrote the fourth does_not_show item to "...is stated in free-energy-bound-in-counts", added a related entry and added a history note. UE19's landing (e0ac63f87) did the same for expected-free-energy-and-its-terms. In that case the related entry was added even though the new record already depended on the old one.

**Caveats that weaken parts of the finding without refuting it.**
- The new record's formal-reuse dependency on RF2 means the renderer will list it under "Used by" on RF2's page (registry.py lines 968 and 1135). So the missing related entry is a weaker point.
- RF2's does_not_show item stays literally true of RF2's own laws. Its problem is only the missing link to the new record.

The stale next_delta is a genuine defect, not a matter of taste.

## F12 (fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:248-263

**Quoted.** “AI reading: the plan read as concealment and acting by its own law at both as disclosure, taking the reading's keeping to respond to the act read as evidence of the law;”

**Problem.** RF1's and RF2's records open their correspondence with the known result restated (Richter's theorem without completeness; indistinguishability), then give the AI reading. This record has only the AI reading, so it carries none of the prior art the module's Standing names: Hubinger and others' §4 toy example, generalized, and Piccione and Rubinstein 1997. Separately, 'numerical counterparts of parts of the two are proved necessary' does not say what they are necessary for, which is strict optimality. Next to §4.2's 'necessary conditions', it can read as necessity for deceptive alignment.

**Replacement.** Open with: 'An expected-value comparison of four plans, generalizing the toy example opening §4 of Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019) from certain keeping to weights; drawing afresh against a single mixture is the advantage of behavioural over mixed strategies under imperfect recall (Piccione and Rubinstein 1997). AI reading: ...'. Write '... are proved necessary for strict optimality'. In ZH: '…已证为严格最优之必要'.

**Verdict: real.** I checked both parts of the finding against the files, and both hold.

(1) The prior art is missing. The correspondence in make_records_rf7.py at lines 248-263 opens with "AI reading:" and ends "These are readings, not containments." It cites only two works, both as readings: Hubinger et al. 2019 §4.2 (the conditions) and Greenblatt et al. 2024. I searched the whole builder for "Piccione", "toy example", "behavioural" and "imperfect recall" and found nothing. The only §4 hits are the §4.2 citations at lines 251 and 261. The hypotheses, does_not_show, validation, next_delta, dependencies and related fields hold no literature either.

The module's Standing in ReadStages.lean names exactly this prior art. It says the two-stage comparison "generalizes the toy example opening §4 of Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019) ... from certain keeping to weights". It also says drawing afresh against a single mixture "is the advantage of behavioural over mixed strategies under imperfect recall (Piccione and Rubinstein 1997)". study_rf7.txt lines 53-56 repeat this. Neither 03 §11's Reading nor 08 §8's known-results bullet carries it, so the record, which is the rendered page for the result, says nothing about what is already known.

The sibling records follow the pattern the finding describes:
- what-choices-show-of-an-order (RF1, ShownOrder) opens "...is close to Richter's theorem (1966) without completeness..." and only then "AI reading:".
- what-readings-fix-of-the-unread (RF2, Unread) opens "Indistinguishability: ..." and then "AI reading:".
- readers-reading-readers, a-reading-kept-by-its-update, what-a-course-chosen-through-its-model-does-not-test, acts-alike-from-a-model-or-from-an-order and a-prediction-read-by-what-it-predicts all state their known or related results first.

The only other record that opens with "AI reading:" is a-revision-that-opens-a-correction. Its module, OpenedCorrection, names only Argyris and Schön, and its record carries them. So RF7's record is the only one that drops prior art its own module names.

(2) The necessity claim has no object. In the Lean, outweighs_needs takes `s.KeepingOutweighs` and gives `0 < s.value ∧ s.keptOwn < s.keptComplying`. KeepingOutweighs is equivalent to strict optimality by complyThenOwn_best_iff, and also by only_complyThenOwn_iff and choose_eq_iff. The module's Readings and 03 §11's Reading both say "strict optimality needs ..." and add that §4.2's conditions are "proposed there as necessary, not as a theorem of choice". The record drops both phrases and says only "numerical counterparts of parts of the two are proved necessary" (ZH "二者部分之数之对应已证为必要"). That sentence follows straight after "§4.2", whose conditions are proposed as necessary for deceptive alignment. It can therefore read as a proof of necessity for deceptive alignment, which the Lean does not formalize. This conflicts with the rule that claims say exactly what the Lean proves.

One caveat about the proposed fix: the English correspondence is already 1173 characters, against a cap of 1200 that the builder enforces with an assert through capped('correspondence', ...). The proposed opening adds about 330 characters and "for strict optimality" adds 22, about 1525 in all. So the replacement only fits if other text is cut. For example, the sentence on not telling the stages apart repeats the statement and laws 6 and 8. The Chinese is at 345 of 500 and has room.

## F13 (fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:221-223; also .../theories/becoming/chapters/03-KNOWING.md:520 and 476, .../theories/becoming/review/ALIGNMENT.md:28

**Quoted.** “Deception in full: a recipient's belief and an intention to cause one are not represented, nor any reasoning about the reader; this is the incentive.”

**Problem.** This does_not_show item ends with a positive claim. 'The incentive' is the AI reading, which takes the prospects as the formation's own assessment, stated here without a label outside the correspondence; the module never calls the law an incentive (its Readings say 'instrumental to being kept'). The same unlabelled naming recurs in three places: 03's Open bullet ('of deception, beyond its incentive'), the dossier ('RF7 adds the incentive') and 03's Reading. In 03's Reading, 'so this is the incentive' is inferred from belief and intention being unrepresented, which does not make it an incentive.

**Replacement.** Record: 'Deception in full: a recipient's belief and an intention to cause one are not represented, nor any reasoning about the reader.' ZH: drop '此为其诱因'. 03 Open: 'of deception, beyond when complying when read is best ([§11]\(#r-when-complying-when-read-is-best)), a recipient's false belief and an intention to cause one.' End of 03's Reading: 'A recipient's belief and an intention to cause one are not represented: read as the formation's own assessment this is an incentive, not deception in full.' Dossier: 'RF7 adds what the readings take as the incentive: ...'.

**Verdict: real.** The finding holds for the record, the Open bullet and the dossier. Its one wording slip is calling 03's Reading paragraph "unlabelled".

1. **The record ends a does_not_show item with an unlabelled positive claim.** make_records_rf7.py:221-223 has the item "Deception in full: ... nor any reasoning about the reader; this is the incentive." The Chinese is "此为其诱因" ("this is its", deception's, "incentive"). The item has kind "non-implication". tools/research/style.py lists does_not_show among PUBLIC_FIELDS, the public statement of the result. It carries no AI-reading label.

2. **The record's labelled reading never uses the word.** The correspondence field (lines 248-263) opens with "AI reading:" and never says "incentive". The sibling RF2 record what-readings-fix-of-the-unread.json puts "incentive" inside its "AI reading" correspondence ("whose intention, anticipation and incentive are not represented"). It lists "an incentive to differ where unread" only as something it does not show. RF7's record moves the term out of the labelled reading and asserts it.

3. **The Lean never calls the law an incentive.** A grep of ReadStages.lean finds no "incentiv". Line 36 says "Whose these weights are, the formation's own assessment or the selection the reading actually applies, is a reading (below), not part of the model." Lines 156-158 say "Read as the formation's own assessment, complying when read is instrumental to being kept, the sense in which deceptive alignment is called deceptive ... These are readings, not containments." Lines 120-124 add that reading complyThenOwn as concealment takes a premise "beyond the prospects". They also say the weights fit equally a reading under which complying "hides nothing". Calling the law deception's incentive needs both readings. The record's first does_not_show item itself says whose the weights are "is a reading, not part of the model".

4. **The same naming recurs in the places the finding names.**
   - 03-KNOWING.md:520, the Open bullet, says "of deception, beyond its incentive (§11)" with no label, linking to the theorem anchor.
   - ALIGNMENT.md:28 says "RF7 adds the incentive: [theorem]". This follows the round-1 line "installation, intention, anticipation and incentive are not represented". So it implies RF7 represents the incentive. The box is labelled "[this dossier, AI]", which marks who wrote it, not that this is a reading. The same paragraph marks its other readings explicitly ("In readings, they locate", "read [AI reading]"), but not this one.

5. **03's Reading is labelled, but its logic and condition are off.** 03-KNOWING.md:476 is inside "Reading [AI reading, new]", so "unlabelled" is wrong there. But "A recipient's belief and an intention to cause one are not represented, so this is the incentive, not deception in full" draws the identification from non-representation, which does not support it. It also drops the module's condition "read as the formation's own assessment".

The proposed replacements match the module's own wording. This is a gap between the texts and the Lean, not a matter of taste.

## F14 (fit, low, confirmed)

**Location.** theories/becoming/chapters/08-METHOD.md:485

**Quoted.** “every optimizing choice, the exits and what the plan needs, joined to RF2's law of the unread; and it states what drawing the act afresh changes where the stages cannot be told apart, the threshold rising from `k_O V + c T` to `2 k_O V + c T`”

**Problem.** 'RF2' is a board code that no other chapter uses; everywhere else, including 03's own theorem, the result is called 'what readings fix of the unread'. 'The exits', `k_O`, `V`, `c` and `T` are defined nowhere in 08. The phrase 'restates X as strict optimality ..., with weights ..., every optimizing choice, the exits and what the plan needs' hangs four objects off one 'with' and is hard to parse.

**Replacement.** '..., stating every optimizing choice, what the plan needs (a value at the unread stage and complying raising the weight of being kept) and the choice without them, joined to [what readings fix of the unread]\(03-KNOWING.md#r-what-readings-fix-of-the-unread); ..., the threshold rising by the own law's weighted value at both stages (from `k_O V + c T` to `2 k_O V + c T` in 03 §11's terms)'.

**Verdict: real.** The files confirm all three parts of the problem.

(1) 'RF2' is a board code. PLAN.md §4.2 is headed "RF2. What readings fix of the unread: `Becoming.Unread`". Its only use in any chapter is 08-METHOD.md:485, and nothing in 08 mentions the board. The same result goes by its title everywhere else in the theory texts:
- 08's own bullet three lines up (line 482): "what readings fix of the unread ([03 §11]\(03-KNOWING.md#r-what-readings-fix-of-the-unread))".
- 03's new theorem ("by [what readings fix of the unread]\(#r-what-readings-fix-of-the-unread) at the two stages") and its Reading.
- THE-THEORY-OF-BECOMING.md:96 ("what readings fix").
- ALIGNMENT.md.
So 08 names one result two ways in one list, and one of the two names can't be looked up. One caveat: "everywhere else" is too broad if it includes the package and record texts. The Lean header, Becoming.lean:2222, check_becoming.py:2807 and the record (law item "RF2's laws at the two stages" / "RF2 之律于二阶", progress line "its join to RF2") all use the code.

(2) The terms are undefined in 08. `k_O`, `V`, `c`, `T` and "exits" occur only on line 485. No other bullet in §8 uses a formula with free variables; the only code spans are Lean names (`Typicality`, `response_sq_within_inflow`). Line 469, a few bullets up, uses "exit" for a different result, the exit from a margin (02 §5). Only the ReadStages.lean header binds the letters ("writing `T` for the total, `k_C` and `k_O` for the two weights, `V` for the value and `c` for the loss"). 03 §11 uses `k_O V + c T < k_C V` but never binds the letters, so the proposed pointer "in 03 §11's terms" leads to a place that uses the symbols without defining them.

(3) The sentence is hard to parse. "with weights read as probabilities where valid, every optimizing choice, the exits and what the plan needs, joined to RF2's law of the unread" puts four objects under one "with". The first is a qualification; the other three are content. It is unclear which item "joined to" attaches to. "What the plan needs" has also lost the qualifier the Lean header gives it (line 11: "what the plan needs of the formation's lumping, joined to RF2's law of the unread"). Without it, the phrase reads as `outweighs_needs` (a value at the unread stage, and complying raising the weight of being kept) rather than `complyThenOwn_realized_iff` (the lumping tells the stages apart).

Caution on the proposed replacement: it would misstate the join. It attaches "joined to what readings fix of the unread" to the value and raise needs, but in the Lean the join runs through the lumping: `complyThenOwn_realized_iff`, `twin_complyThenOwn` (via `Learning.twin_selected`) and `read_fixes_unread` (via `Learning.lumped_determines`). A fix should keep "open to an act law exactly where its lumping tells the stages apart" as the item that is joined. The rise should be written as "by `k_O V`, which can be nothing", as the header has it (from `freshDraw_above_iff` against `complyThenOwn_best_iff`). The proposal's "the own law's weighted value at both stages" is ambiguous.

## F15 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:264-265

**Quoted.** “['concealment', '隐', 'deceptive alignment', '欺骗式对齐', 'Becoming.ReadStages.complyThenOwn_best_iff', 'Becoming.ReadStages.freshDraw_above_iff']”

**Problem.** The review renamed `Concealment` to `ReadStages` because the name carried the reading. These aliases make 'concealment' and 'deceptive alignment' names of the result again. RF2's record aliases its own title and structural phrases only ('a twin where it can tell', 'behaviour where not read'), never 'deception' or 'evaluation awareness'. This record also lacks an alias for its own title.

**Replacement.** ['when complying when read is best', '读时从何时为最优', 'four plans in two stages', '二阶四策', 'Becoming.ReadStages.complyThenOwn_best_iff', 'Becoming.ReadStages.freshDraw_above_iff']

**Verdict: real.** The files show the problem. I checked each claim and tried to find grounds to refute it.

1. **The aliases are as quoted.** Lines 264-265 of make_records_rf7.py give ['concealment', '隐', 'deceptive alignment', '欺骗式对齐', and the two Lean names complyThenOwn_best_iff and freshDraw_above_iff]. The record's title, 'When complying when read and acting by its own law when not is best', is not among them, and no other structural name is either.

2. **The rename was made because the name carried the reading.** study_rf7.txt line 73 says: "names carrying the reading or a financial word replaced (`Concealment` by `ReadStages`, ... `Conceals` by `KeepingOutweighs` ...)". It also says the readings were corrected because "concealment presupposes a recipient". The old module never landed under that name: the package has no Concealment.lean.

3. **The result does not mean "concealment" or "deceptive alignment".**
   - The Readings paragraph of ReadStages.lean (lines 120-160) is marked as an AI reading. It says that reading complyThenOwn as concealment "takes, beyond the prospects", an extra assumption, and that "the weights alone fit equally a reading ... under which complying when read hides nothing".
   - For deceptive alignment, it says only "numerical counterparts of parts of the first two conditions" are proved necessary, and that the third condition is assumed.
   - In the record itself, both terms appear only after "AI reading:" in the correspondence field. Its does_not_show says "Deception in full ... not represented ... this is the incentive".

4. **An alias is an unlabelled name of the result.**
   - RESULT-WORKFLOW.md line 45 says to "Record formal names as aliases where they denote the same result".
   - registry.py lines 767-774 make each alias a unique, case-insensitive key that belongs to one record.
   - registry.py line 1035 prints aliases on the record page as "Aliases: ..." with no AI-reading label.
   - So these four aliases make "concealment" and "deceptive alignment" names of the result without the label. That breaks the AGENTS.md rules "Every reading keeps its AI label" and "A name is adopted only where the statement means exactly that".
   - The alias 'deceptive alignment' would also reserve that term for this one record. Yet PLAN.md line 227 places deceptive alignment across both RF2 and RF7.

5. **The comparison with RF2 holds.**
   - RF2's record, what-readings-fix-of-the-unread (make_records_rf.py line 364), has as aliases its own title, 'a twin where it can tell', 'behaviour where not read', and two Lean names. Its correspondence reads it with deceptive alignment, alignment faking, and evaluation and deployment, but none of these is an alias.
   - The other RF records keep their AI-reading terms out of their aliases as well. The literature terms they do use as aliases come from the part of the correspondence that is not an AI reading: 'revealed order', 'a cascade', 'self-confirmation', 'self-fulfilling prophecy' and 'performative stability'.
   - RF7 is the only RF record whose word aliases are all AI-reading terms.

**What I weighed against it, and why it does not refute the finding:**
- PLAN.md line 178 says "the item keeps the name of its reading". That refers to the board item, not the record. The board's own land7 text replaces "RF7 disclosure or concealment in two stages" with the structural title.
- Older records outside RF, such as target-capture with 'hijacking', show that reading terms have been used as aliases before. That is precedent elsewhere, not the RF convention or the naming rules.
- No duplicate alias exists, so the checker would pass. The defect is in the naming, which the checker does not test.
- Leaving out a title alias is a minor point on its own, since not every RF record aliases its exact title. Here, though, it means the record has no structural word alias at all.
- "Again" is exact for concealment, which was the old module name, but not for 'deceptive alignment', which was never a name. This slight imprecision does not change the finding.

The proposed replacement aliases are not used by any existing record.

## F16 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:244-247

**Quoted.** “a frozen test of compliance under implied and unmonitored reading (the plan's TR2)”

**Problem.** The plan's TR2 is RF2's test, not a test of this law's threshold: it compares output distributions with cues randomized apart from content and measures detection, change and misleading. The module itself says 'a frozen test design (none yet)'. The field also drops two items that the module's 'What the model leaves out, and where it goes' list sends onward: a recipient's belief and an intention to cause one (the plan's deception item), and whether a training installs a law choosing by such prospects.

**Replacement.** '...; a reader choosing its weights and what it reads; a recipient's belief and an intention to cause one; whether a training installs a law choosing by such prospects; a frozen test of whether compliance when read follows the value at the unread stage and the rise in being kept, none designed yet (TR2 tests RF2's chain); review by a person.' (ZH likewise)

**Verdict: real.** The problem holds: the files show it. make_records_rf7.py:244-247 (next_delta) says "a frozen test of compliance under implied and unmonitored reading (the plan's TR2)", and the ZH says the same ("于暗示被读与无监之下从之冻结检验（计划之 TR2）").

1. **TR2 belongs to RF2.** PLAN.md:262 labels it "**TR2 (RF2).**" and describes it as follows: hold weights, memory, context and the policy kernel fixed; compare output distributions; randomize cues apart from content; measure detection, change and misleading separately. Its forbidden case is "a distribution of outputs that differs where nothing accessible differs". That is RF2's chain. TR2 has no prospects, no value, no weights of being kept and no threshold, so it cannot fail on ReadStages' law (k_O V + c T < k_C V) and is not a test of it. It does not speak of "compliance under implied and unmonitored reading" either. PLAN.md §10 designs TR1 to TR5, for RF1, RF2, RF4, RF6.1 and RF3, and none for RF7.

2. **The module says no test exists.** ReadStages.lean:163-169, under "What the model leaves out, and where it goes", ends with "a frozen test design (none yet)". The record's next_delta instead sends this item to TR2, which contradicts the module.

3. **The sibling records name their own tests.** The landed RF2 record (what-readings-fix-of-the-unread) already names TR2 in its next_delta as "a frozen test of the chain on a trained model with cues varied apart from content". RF6.1's record cites "the plan's TR4", its own test. Citing TR2 is the one exception.

4. **The two dropped items.** The same module list sends two items onward: "a recipient's belief and an intention to cause one (the plan's deception debt)" and "whether a training installs a law choosing by such prospects (realizability, as for RF1)". Neither appears in next_delta. This part is factually right but weaker. The deception item sits in the record's does_not_show, and realizability is touched there ("That a trained system computes by these plans..."). RF1's record does put realizability in its next_delta.

The proposed replacement runs to 494 English characters. That exceeds next_delta's hard cap of 400 (RESULT-WORKFLOW.md:102, style.py HARD_CAPS), so the fix needs to be shorter, for example "a frozen test of the threshold, none designed yet".

## F17 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:227; also PLAN.md:86, 152, 173, 178

**Quoted.** “| Deceptive alignment, alignment faking (Greenblatt and others 2024) | RF2; RF7 (round 2) | the possibility exact; the incentive a debt until RF7 |”

**Problem.** integrate_rf7.py updates only §4.6's bullet and §12's order, so after the landing several parts of the plan go stale. The literature table still calls the incentive 'a debt until RF7'. §4's intro (line 86) still says 'RF6.1, RF-M's other cases and RF7 follow'. §4.5's heading says only RF-M's mechanism is built. §4.6 is headed 'first landing', its intro says the results are in '03 §12', and it lists RF7 before RF6.1, although RF7's home is 03 §11 and it landed after RF6.1. The RF7 bullet's `k_C` and `k_O` also replace §4.2's `(q_M − q_H)V > c` without a word.

**Replacement.** Row: '| ... | RF2; RF7 | the possibility exact; the incentive stated as strict optimality over four plans (RF7); the recipient's belief a debt |'. Line 86: '... RF6.1 and RF7 followed (§4.6); RF-M's other cases follow.' Line 152: '(the design; RF-M's mechanism and first cases, and RF7, built, §4.6)'. Line 173: '... stated in their records and in 03 §12 (RF6.1's in 03 §8, RF7's in 03 §11)'. Move the RF7 bullet after RF6.1's.

**Verdict: real.** The finding holds as stated. Every quoted line matches the scratch tree, and nothing in the files refutes it.

1. **The integration touches only two places in the plan.** integrate_rf7.py edits PLAN.md at two anchors only (lines 169-182): it inserts the RF7 bullet before the RF6.1 bullet and rewrites item 2 of §12's order. No other RF7 kit script edits the plan. repoint_rf7.py's EXPECTED list for PLAN.md names only '4. The new laws' and '12. Order, owners and what it serves'. `git diff` of the scratch tree shows exactly those two hunks.

2. **The quoted lines are unchanged after the integration:**
   - Line 227 still says "the incentive a debt until RF7".
   - Line 86 still says "RF6.1, RF-M's other cases and RF7 follow".
   - Line 152 is "### 4.5 RF-M and RF7 (the design; RF-M's mechanism and first cases built, §4.6)". RF7 is not named as built.
   - Line 171 is "### 4.6 Round 2, first landing: ...".
   - Line 173 says "The results are stated in their records and in 03 §12".
   - Line 178 puts RF7's bullet before RF6.1's (line 179), yet RF7's bullet says "Landed on its own after RF6.1", and §12 (line 282) gives the order RF6.1, then RF7.

3. **RF7's home is 03 §11, not 03 §12.** regions.json gives Becoming.ReadStages the note "(03 §11)". The anchor r-when-complying-when-read-is-best is at 03-KNOWING.md:473, inside §11 (heading at line 459) and before §12 (line 479). RF6.1's home is "(03 §8)". So line 173 is factually wrong for both bullets that now sit under it.

4. **The symbols are never defined in the plan.** `k_C`, `k_O` and `T` are defined only in the ReadStages.lean header ("writing `T` for the total, `k_C` and `k_O` for the two weights, `V` for the value and `c` for the loss"; its Standing gives `(k_C − k_O) V > c T`). In PLAN.md they appear only at line 178. §4.2 (line 127) wrote the incentive as `(q_M − q_H)V > c`, and nothing ties the two notations together.

5. **The kit itself treats "until RF7" as needing an update.** The land7 branch of board_rf2.py rewrites the board's parallel phrase "concealment as shaping an analogy until RF7." to "an analogy, which RF7's law replaces.". The plan's own "until RF7" phrasing was left as it was.

6. **There is more stale text than the finding lists.** §5's row at line 191 still says "analogies until RF-M and RF7 represent preferences, intervention and continuation".

**Caveats:**
- The §4.6 heading is linked five times (anchor #46-round-2-first-landing-...), so it should stay. The finding does not propose changing it.
- The RF7-before-RF6.1 order is cosmetic.
- Line 86 and §4.4's heading were already stale about RF6.1 before this landing.
- Records pin PLAN.md by a whole-file sha256. Editing the §8 row would therefore need §8 added to repoint_rf7.py's EXPECTED list.

**Verdict:** real, at low severity. It is a stale working plan, not a theory claim.

## F18 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/board_rf2.py:76-79

**Quoted.** “The plan and the Lean of each round had an independent cross-model review, with a re-check in round 2, and the texts a cold read, every finding taken (plan §13).”

**Problem.** The board's RF row already carries this sentence, because an earlier landing replaced the old one. In land7 the replace call therefore changes nothing, and RF7's landing leaves a review summary that is wrong for it. Eight of the four-lens review's 50 points were refuted, and the record and the study say 'every confirmed finding taken'. Plan §13 also does not describe RF7's reviews.

**Replacement.** In land7, replace this sentence with: 'The plan and the Lean of each round had an independent cross-model review, with a re-check in round 2; RF7's Lean also a four-lens review, each point verified; the texts a cold read; every confirmed finding taken (plan §13).'

**Verdict: real.** The files bear out each part of the finding.

1. The replace in land7 changes nothing. Main's board and the rehearsal copy of _process/BECOMING-WORKBOARD.md (RF row, line 59) already hold the new sentence once: "The plan and the Lean of each round had an independent cross-model review, with a re-check in round 2, and the texts a cold read, every finding taken (plan §13)." The old sentence ("... each had ... by three readers ...") is not there. `git log -S` shows the sentence came in with d7ada3c00, round 2's first landing. The replace at board_rf2.py:76-79 is shared by land, land61 and land7 and has no count assert, unlike the other replaces. An in-memory run of land7's cell edits on the current row confirmed this: its statements sentence and readings sentence are each present once and will change, while the review replace returns the cell unchanged. After RF7 lands, the row still carries the sentence above.

2. That sentence is wrong for RF7.
   - It says "every finding taken", but make_records_rf7.py, done() at lines 133-135, says "a four-lens review with each finding verified, and a re-check, every confirmed finding taken". The Chinese says the same: 凡证实之所见皆取.
   - study_rf7.txt line 73 says the four-lens review "found 50 points ... 42 confirmed and 8 refuted", the module was "rebuilt ... for the confirmed ones", and only "Several refuted points were taken". The study does not use the words "every confirmed finding taken", but it says the same thing.
   - So the board would claim more than RF7's own record, and it leaves the four-lens review out.

3. The pointer to plan §13 is wrong for RF7. §13's paragraph "The review of round 2's Lean" covers ReadingLoop, ReflexivePrediction and OpenedCorrection. The only mention of RF7 in §13 is table row 11 ("RF7 designed"). The kit's PLAN.md diff adds RF7 only to §4.6 and §12's order, not to §13.

Two caveats on the proposed fix:
- It still cites "(plan §13)", which does not describe RF7's reviews. The pointer should go to the RF7 study section, or §13 needs an RF7 paragraph. evidence/REVIEW-ROUND2.md, which the study cites for these reviews, has no RF7 section in the scratch tree either.
- The new replace must target the sentence now on the board and assert that it matches once, so it cannot fail silently again.

Severity low, as stated.

## F19 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:73

**Quoted.** “rebuilt for its seven findings: the weights read as probabilities only where `Valid` holds; the plan stated as uniquely strictly best, its comparison with the own law at both being the inequality itself; a choice with ties to the own law; the exits not strictly best and not chosen; stages the formation cannot tell apart through `Learning.Lumped`; the readings labelled, the source's conditions named as proposed necessary conditions”

**Problem.** The first review's seven findings were: no `Valid`; strict optimality proved but no choice or tie rule; the prose threshold dropping the total's scaling; `Untold` describing equal acts rather than inability to tell; the uniform comparison being a restatement, with 'its law is shown' unsupported; §4.2's conditions incomplete; and Greenblatt's result compressed. The study's list splits the second finding into three and omits the threshold's scaling and Greenblatt's rates. The section also stops at the nine-point re-check, although a further re-check found all nine taken correctly and nothing new.

**Replacement.** 'rebuilt for its seven findings: the weights read as probabilities only where `Valid` holds; strict optimality proved but no choice, so a choice with ties to the own law, the exits not strictly best and not chosen; the threshold scaled by the total; one act at both stages named `Uniform`, apart from not telling the stages apart through `Learning.Lumped`; the uniform comparison stated exactly, with disclosure and concealment labelled readings; §4.2's conditions named as proposed necessary conditions; Greenblatt and others' result read as differing rates.' After the nine points, add: 'A further re-check found all nine taken correctly and nothing new.'

**Verdict: real.** Both parts of the finding match the files, and I could not refute either.

1. The seven findings. The first review is in /private/tmp/claude-501/-Users-ren-theories/50635de9-b91e-4f4c-a63c-8413ce8c4652/scratchpad/rf7-review-astra.md, copied verbatim with a taken-table into _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-ROUND2.md under "The review of RF7's module". Its seven findings are exactly the ones the finding lists:
- F1: `Stakes` has no `Valid`.
- F2: strict optimality is proved but there is no choice or tie rule.
- F3: the prose threshold drops `cost * total`.
- F4: `Untold` describes equal acts, not inability to tell the stages apart.
- F5: `untold_discloses` is a restatement, and "its law is shown" is unsupported.
- F6: the §4.2 correspondence is incomplete.
- F7: Greenblatt's result is compressed.

The study's list at study_rf7.txt:73 maps as follows:
- "only where `Valid` holds" is F1.
- Three items all come from F2: "uniquely strictly best, its comparison with the own law at both being the inequality itself" (F2's replacement and its Substance remark, since `Beats conceal disclose` is `Conceals`); "a choice with ties to the own law" (F2's selector); and "the exits not strictly best and not chosen" (F2's replacement prose; the first re-check prompt and verdict also tie the exit restatement to F2).
- "through `Learning.Lumped`" is F4.
- "the readings labelled" is part of F5.
- "proposed necessary conditions" is F6.

F3 and F7 appear nowhere in the list, yet both were taken:
- F3: ReadStages.lean:249-250 defines `KeepingOutweighs` as `k_O V + c T < k_C V`, and the evidence table row 3 says the threshold was taken in every text.
- F7: ReadStages.lean:148-152 says "The difference is one of rates", and the evidence table row 7 reads "constructed settings and rates".

So the list presented as the seven findings does not correspond to them.

2. The further re-check. rf7-v4-recheck-astra.md, also recorded in the rf-landing REVIEW-ROUND2.md as "the session continued for a re-check", gives the verdict "All nine findings were taken correctly ... no new error or overstatement" on the 52-theorem module that is being landed. The study goes straight from "found nine points, all taken: ..." to "The texts were then cold-read". It never reports this verdict, although it does report the earlier re-check ("six taken and one in part ... all taken").

The proposed replacement matches what was taken. Severity is low: this is a provenance summary, and no Lean claim is affected.

## F20 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:217; also 206-209 (law 9) and 242-243 (validation)

**Quoted.** “'zh': '望为自然数；算术之律于一切皆成，概率之读需 Valid；二阶四策，阶之值于同一尺度相加；二阶为 Bool，true 为读时；行律经所予之归并读二阶，或每阶独立重抽一机。'”

**Problem.** The English and Chinese fields differ in three places. The Chinese hypotheses omit the English's third alternative, 'or one draw before the read stage' (`MixtureAbove`). Law 9's English omits 'at each stage', which its Chinese has (每阶). The validation's Chinese omits 'and no omega'.

**Replacement.** ZH hypotheses: '…行律经所予之归并读二阶，或每阶独立重抽一机，或读时之前一抽。'. Law 9 EN: 'complying with chance one in eight or one in five at each stage stands above ...'. Validation ZH: '…Lean 自带之 Nat.mul_assoc 与 Nat.add_mul 报告 propext，亦不用 omega；诸例以 decide 计算。'

**Verdict: real.** The finding is real. All three differences are in make_records_rf7.py as stated, and the Lean says the missing text is correct.

1. Hypotheses. The English (213-216) lists three act laws and ends with "or one draw before the read stage". The Chinese (217) ends at "或每阶独立重抽一机" and has no third. That third law is `Prospects.MixtureAbove` (ReadStages.lean 268-272, docstring "one draw before the read stage"). It is the model behind `mixture_never_above`, and the record's own Chinese law 8 states that theorem (line 200: "二同行策之单一混合永不居上"). So the Chinese hypotheses leave out a premise that a Chinese law uses.

2. Law 9. The English (206-208) says "complying with chance one in eight or one in five stands above ..., one in four not", without "at each stage". The Chinese (209) has "每阶". The Lean witnesses are per-stage fresh draws: `FreshDrawAbove 1 7`, `FreshDrawAbove 1 4` and `¬ FreshDrawAbove 1 3` (747-758). Their docstrings, the module's Witnesses bullet and the record's own counterexample (line 234) all say "at each stage". Without it, the English, which is the text rendered pages show, can be read as a single mixture, and `mixture_never_above` proves a single mixture never stands above.

3. Validation. The English (238-241) says "and no omega". The Chinese (242-243) has nothing for it. No omega appears in ReadStages.lean, so the English is true and the Chinese only omits it. This is the weakest of the three.

Attempts to refute it failed:
- RESULT-WORKFLOW line 45 says "full translation is not required". That allows a field to carry only one language. It does not allow a Chinese text that states less than the English in the same field.
- No length cap forced the omissions. The proposed texts fit: zh hypotheses 92 of 190, zh validation 214 of 260, en law 9 348 of 420. The proposed replacements are accurate.

Outside this finding, the done() progress text at line 277 differs the same way: the English has "against a single mixture" and the Chinese does not.

## F21 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:170-173

**Quoted.** “that plan is maximal exactly where k_O V + c T is at most k_C V; the choice taking it there and acting by its own law at both otherwise, ties included, is maximal.”

**Problem.** 'There' follows the weak inequality, but `Prospects.choose` takes the plan only where keeping outweighs the loss, which is the strict case; at equality it takes acting by its own law at both. 03 orders the clauses so that 'there' refers to the strict case.

**Replacement.** EN: '...; the choice taking it where keeping outweighs the loss and acting by its own law at both otherwise, ties included, is maximal.' ZH: '…于被守胜其损处择之、否则二阶皆依己律（相等亦然）之择，为极大。'

**Verdict: real.** The finding holds as stated.

1. **What the record says.** The law item at make_records_rf7.py lines 170-173 runs: "...is that plan exactly where keeping outweighs the loss, and that plan is maximal exactly where k_O V + c T is at most k_C V; the choice taking it there and acting by its own law at both otherwise, ties included, is maximal." The nearest place "there" can point to is the weak clause "at most", which is `complyThenOwn_maximal_iff` (`≤`, ReadStages.lean 370-380). The Chinese has the same order: "此处择之" comes right after "恰当 k_O V + c T 不逾 k_C V".

2. **What the Lean does.** `Prospects.choose` (ReadStages.lean 254-256) is `if keptOwn*value + cost*total < keptComplying*value then complyThenOwn else ownAtBoth`, a strict inequality. `choose_of_not_outweighs` (350-354) gives `ownAtBoth` whenever the strict inequality fails, and `Example.tie` (728-733) shows the tie case: with loss 8, 1*10 + 8*10 = 90 = 9*10, and `choose = ownAtBoth`. So at equality the choice is `ownAtBoth`.

3. **Why the sentence fails.** Read with "there" pointing to the nearest clause, there are two outcomes, both bad:
   - The sentence contradicts itself: ties would fall both "there" and under "otherwise, ties included".
   - Or it describes a different choice, one that takes `complyThenOwn` at ties. That choice is also maximal by `complyThenOwn_maximal_iff`, but it is not the cited `Prospects.choose`, `choose_eq_iff` or `choose_of_not_outweighs`.

   Either way the record is unclear about exactly the case the repository rules require stated exactly: strictness at ties.

4. **The other texts get it right.**
   - 03-KNOWING.md line 474 puts "the choice taking that plan there..." straight after "exactly where keeping outweighs the loss (`only_complyThenOwn_iff`)"; the weak clause is not in that sentence.
   - study_rf7.txt lines 18-21 does the same ("is the first exactly where keeping outweighs the loss (...); the choice taking it there...").
   - The module header (ReadStages.lean 49-53) names the place outright: "taking `complyThenOwn` where keeping outweighs the loss and `ownAtBoth` otherwise".

   The ambiguity comes only from the record moving the weak clause between the strict clause and "there".

5. **The replacement fits.** The proposed text stays within the laws item caps of 420 (English) and 190 (Chinese): English goes from 268 to 295 characters, Chinese from 82 to 87.

Low severity is right. The phrase "ties included" lets a careful reader recover the intended strict reading, but the plain reading points the wrong way.

## F22 (fit, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:474; also .../kit/round2/make_records_rf7.py:179, .../kit/round2/study_rf7.txt:24

**Quoted.** “without either, the choice is acting by its own law at both”

**Problem.** 'Without either' reads as 'lacking both'. In fact each condition alone decides the choice (`no_value_chooses_own`, `kept_not_raised_chooses_own`), as the module says: 'With no value at the unread stage, or with complying not raising the weight of being kept'.

**Replacement.** 'with either missing, the choice is acting by its own law at both' (and the same in the record and the study; the Chinese '二者缺一' already says this).

**Verdict: real.** The finding holds. The Lean proves that each exit alone settles the choice, while the English phrase, on the reading this repository itself uses for it, says both must be missing.

What the Lean proves (ReadStages.lean):
- Line 396: `no_value_chooses_own (nothing : s.value = 0) : s.choose = ownAtBoth`. Its only hypothesis is that there is no value.
- Line 401: `kept_not_raised_chooses_own (not_raised : s.keptComplying ≤ s.keptOwn) : s.choose = ownAtBoth`. Its only hypothesis is that complying does not raise the weight.
- Lines 407 and 414: `ownAtBoth_above_without_value` and `ownAtBoth_above_of_not_raised` likewise each take one condition, plus `0 < c T`.
- The module's own header (lines 57-61) says "With no value at the unread stage, or with complying not raising the weight of being kept". Its Readings (lines 130-131) say "with either absent".

The three quoted texts all say "without either":
- 03-KNOWING.md line 474: "without either, the choice is acting by its own law at both …".
- make_records_rf7.py lines 178-179 (English).
- study_rf7.txt line 24.

But the record's own Chinese for the same law item (make_records_rf7.py line 180) says "二者缺一，则所择为二阶皆依己律", which means one of the two missing. The ALIGNMENT box also lists the exits as separate exits.

"Without either" with its standard negative reading ("without either A or B" = with neither) states only the case where both are missing. That claim is true, but it is weaker than what is proved. It misstates the hypotheses of the cited theorems and disagrees with the Chinese edition of the same record.

The repository's other uses of the phrase all mean "with neither":
- history/UPDATER-FORMATION.md line 26: "It starts without either A or H".
- history/HUIGEN.md line 235: "without either action violating".
- synthesis-b-ssbx-canon-and-history.md line 467: "without either faking completion or freezing".

The sentence's own witness also fits only the one-missing reading. `Example.exit_tie` (lines 737-740) is `{prospects with value := 0, cost := 0}` with prospects ⟨10, 9, 1, 10, 5⟩. There keptComplying 9 > keptOwn 1, so only the value condition is missing. On the "both missing" reading, the cited tie witness is not a case the sentence describes.

Against the finding: a reader who follows the two separate citations can recover the intended meaning, and the lacking-both reading is not false. So this is an ambiguity, not an error. But it fails the rule that claims state exactly the Lean's hypotheses, and it splits the English from the Chinese. That makes it real at the stated low severity.

The proposed "with either missing" matches the module's "with either absent" and the Chinese 二者缺一.

## F23 (fit, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:474

**Quoted.** “not telling the stages apart raises the threshold by `k_O V`, which can be nothing, and does not remove complying when read”

**Problem.** For a deterministic law, not telling the stages apart does remove complying when read and acting by its own law when not (`complyThenOwn_realized_iff`). What survives is a gain from complying with some chance at each stage. As written, the clause reads as if the plan itself survived.

**Replacement.** 'not telling the stages apart raises the threshold by `k_O V`, which can be nothing, and leaves a gain from complying with some chance at each stage'

**Verdict: real.** The finding is real (low severity). The clause is on line 474 of 03-KNOWING.md. Its factual claims check out against ReadStages.lean, and the wording is looser than what the Lean proves.

1. **The plan is removed for a deterministic law.** `complyThenOwn_realized_iff` (lines 487-493) says complying when read and acting by its own law when not is open to an act law `g : Bool → Act` with `Learning.Lumped π g` (Learning.lean:834) exactly where `π true ≠ π false`. Where the lumping ties the stages, `read_fixes_unread` (497-499) applies and only uniform plans remain. Among those, `uniform_best_iff` (532-540) puts acting by its own law at both on top wherever `0 < k_O V + c T`.

2. **What survives is a gain from complying with some chance at each stage.** `FreshDrawAbove` (264-266) uses one chance `m/(m+r)` at both stages and compares only against acting by its own law at both. `freshDraw_above_iff` (660-664) says some such chance does better exactly where `2 k_O V + c T < k_C V`. The module's own docstring (85-87) words the point precisely: the threshold rises by `k_O V`, and "the two stages share one distribution of acts". It never says "does not remove complying when read".

3. **The clause reads as if the plan survived.** The repository uses "complying when read" as shorthand for the plan itself:
   - the record id and anchor `when-complying-when-read-is-best`;
   - the link text "when complying when read is best" in 07 §9 and in the overview's §3;
   - "when complying only when read is a formation's own best plan" in the 07 §9 row and ALIGNMENT.md line 21.

   In the clause, "does not remove complying when read" sits next to "raises the threshold by `k_O V`", and that threshold, `k_O V + c T < k_C V`, was the plan's. Read together, they say the plan's threshold rises and the plan stays. In fact the plan is unavailable, and a different, randomized behaviour has the higher threshold. A law that cannot tell the stages apart cannot comply "when read" in the conditional sense.

**Rebuttal tried.** Within the theorem paragraph, "a law complying when read" means the act at the read stage, and "the plan" names the plan. On that reading the clause is trivially true, since complying at both stages also complies when read. But then "does not remove" carries no content unless it means a gain, and the gain only comes with "some chance at each stage". So the clause is at best a loose gloss in a paragraph that must state exactly what the Lean proves.

**Every other text states this precisely,** which makes this clause the outlier:
- the chapter's own Reading paragraph (line 476): "complying with some chance at each stage, where `2 k_O V + c T < k_C V`";
- the record's statement ("a chance drawn afresh gains exactly where…");
- the record's reading ("a deterministic law complying at both or neither, and a law drawing afresh complying with some chance");
- the overview's line 96 ("gives one act at both, unless it draws its act afresh…, and then it still gains by complying with some chance");
- ALIGNMENT.md line 28.

The proposed replacement matches `freshDraw_above_iff` exactly.

## F24 (fit, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:476; also .../kit/round2/study_rf7.txt:60 and 73

**Quoted.** “the outcome §4.2 gives for the third condition failing”

**Problem.** In 03 a bare § refers to the chapter's own sections (03 §4 is 'Laws along a run'), and the citation naming the paper's §4.2 is three sentences back. In the study section, 'the plan's §4.2 analogy' (the plan's RF2 section) and '§4.2's conditions' (Hubinger and others') use one label for two different documents.

**Replacement.** 03: 'the outcome Hubinger and others' §4.2 gives for the third condition failing'. Study line 60: 'it replaces the analogy with RuleShaping in the plan's §4.2'. Study line 73: 'the third of Hubinger and others' §4.2 conditions assumed, not represented'.

**Verdict: real.** The finding is real but low-severity. Both parts check out against the files, and the stronger case is in the study section.

**03-KNOWING.md:476.** The finding's facts are right.
- Every other unlinked § in 03 points to the chapter's own sections: line 9 "§8", line 261 "§§5–6", line 351 "§§1–8", line 469 "under §6's hypotheses" and line 521 "§9".
- References to other chapters always carry the chapter number ("02 §9", "07 §6", "05 §8").
- 03 §4 is "Laws along a run" (line 140).
- Dotted numbers mark a chapter's own subsections elsewhere: 07 links its own "[§4.2]\(#r-what-the-step-across-standpoints-reaches)".
- In the Reading paragraph the paper is cited in sentence 3 as "(Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant 2019, §4.2)". The bare "the outcome §4.2 gives for the third condition failing" is sentence 6, three sentences later.

Some things soften this part:
- 03 has no subsections at all, so nothing in 03 actually collides with "§4.2".
- "the third condition" ties back to the paper's three conditions.
- 02-MAP.md:428 has a similar bare "(§5.2)" for Friston and others 2016, but it comes in the very next sentence after the citation, which opens with "Its".
- The module docstring (ReadStages.lean lines 131 and 137) uses the same bare form, but a Lean file has no sections of its own to confuse it with.

So in 03 the text breaks the chapter's own rule for bare § and can be worked out from context. That is a minor exactness problem, not a refutation.

**study_rf7.txt.** This part holds clearly.
- Line 60, "it replaces the plan's §4.2 analogy with RuleShaping", points to the plan's §4.2, "RF2. What readings fix of the unread". That section holds the paragraph "Concealment as shaping: an analogy, not an instance" about `RuleShaping.favours_iff`.
- Line 73 then uses a bare "§4.2" twice to mean Hubinger and others' conditions: "the third of §4.2's conditions assumed, not represented" and "parts of §4.2's first two conditions".
- The study section never names Hubinger's §4.2. Line 54 names only "§4 of Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019)".
- So the only explicit §4.2 earlier in the section is the plan's, and the plan's §4.2 contains no conditions.

One label stands for two documents here, and the bare uses resolve wrongly by their nearest antecedent. That is a real defect, not a matter of taste.

**On the proposed fix.** It covers only the first bare use in line 73. Qualifying that one would still give the later "§4.2's first two conditions" the right antecedent.

## F25 (fit, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:476 (also make_records_rf7.py:248-250)

**Quoted.** “takes the reading's keeping to respond to the act read as its evidence of the formation's law; the weights alone fit equally a reading that knows the law and keeps it on compliance”

**Problem.** The Reading paragraph opens 'Reading complying when read ... as concealment', where 'reading' means the AI's interpretation. In the same sentence, 'the reading's keeping' uses 'reading' for the selection that keeps or changes the law. One word carries two senses in one sentence.

**Replacement.** 'takes the selection's keeping to respond to the act read as its evidence of the formation's law; the weights alone fit equally a selection that knows the law and keeps it on compliance' (and the same in the record's correspondence).

**Verdict: real.** The problem is real. At 03-KNOWING.md:476 one sentence reads "Reading complying when read and acting by its own law when not as concealment, and acting by its own law at both as disclosure, takes the reading's keeping to respond to the act read as its evidence of the formation's law; the weights alone fit equally a reading that knows the law and keeps it on compliance". The opening "Reading X as Y" is the AI's interpretation; the paragraph carries the label "[AI reading, new]". But "the reading's keeping" and "a reading that knows the law and keeps it" use "reading" for the thing that keeps or changes the formation's law.

The Lean names that keeper a selection. The ReadStages.lean header (lines 7-8) says "at the read stage the formation's act couples into a selection that keeps its law or changes it". Line 37 says "the selection the reading actually applies". The same paragraph later calls it "the selection" too: "not whether the selection reads the law, the acts or anything else". It also says "a reader". So one paragraph names one thing three ways: reading, reader and selection. One of those words, reading, is also the paragraph's own label for interpretation.

This is more than taste. 08-METHOD.md's "Words in one sense" table says "Every chapter uses these words in one sense each" and states that "a reading is an interpretation, labelled" (line 116). The glossary lists reading only as a standing (line 69). A noun "reading" that knows a law and keeps it is outside both.

The clash is worse in the record. make_records_rf7.py:248-250 reads "AI reading: the plan read as concealment ..., taking the reading's keeping ... the weights alone fit a reading that knows the law". There "the reading" most naturally points back to the "AI reading" label. The Chinese text repeats it: "读之守" and "…守之之读".

No live chapter uses "the reading's" in this sense anywhere else. The only other use is 01-ROOT's "the reading's unit", which means something different.

The proposed fix ("the selection's keeping", "a selection that knows the law") matches the Lean header and the paragraph's own wording. It changes nothing the Lean proves, since the module leaves whose weights these are as a reading.

Minor imprecisions in the finding do not affect the verdict:
- The sentence is the paragraph's second, not its opening; the paragraph opens "Read with [what readings fix of the unread]".
- The same pattern also appears in the module docstring at ReadStages.lean:120-123, which adds a third case, "a reading shown the law would keep it less".
- The fix should therefore also cover the Lean docstring and the Chinese record text.

## F26 (fit, low, confirmed)

**Location.** theories/becoming/results/data/regions.json:3689; also .../Becoming/ReadStages.lean:4, .../lean/becoming/Becoming.lean:2215, .../lean/becoming/README.md:198, .../lean/becoming/check_becoming.py:2803, .../chapters/03-KNOWING.md:461, .../chapters/07-SIGNIFICANCE.md:647, .../review/ALIGNMENT.md:21

**Quoted.** “RF7 complying when read and acting otherwise when not (03 §11)”

**Problem.** One plan carries five names across the texts: 'complying when read and acting by its own law when not' (03, record, 08, PLAN); '... by one's own law ...' (module title, root bullet, README, SCOPE); 'acting otherwise where not read' (03 §11's opening); 'complying only when read' (07, dossier); and 'acting otherwise when not' (this note). The other RF module notes use their record's title, for example 'RF2 what readings fix of the unread (03 §11)'.

**Replacement.** Note: 'RF7 when complying when read and acting by its own law when not is best (03 §11)'. Use 'its own law' in the package texts, and the title's phrase in 03's opening, 07 and the dossier.

**Verdict: real.** The files bear the finding out: every variant appears where it says, and the sibling-note convention holds. It is a low-severity naming inconsistency, not an error in the mathematics.

(1) The adopted phrase is set by the Lean and the record. The docstring of `complyThenOwn` in ReadStages.lean (line 191) reads "Complying when read, acting by its own law when not." About fifty other docstrings in the module say "its own law". The record title in make_records_rf7.py (line 144) is "When complying when read and acting by its own law when not is best". The same phrase appears in 03:474 (the theorem's italic title), 08:485, THE-THEORY-OF-BECOMING:96, PLAN:178, study_rf7.txt:1, the land7 board text, the regions result note (line 2387) and ALIGNMENT:28.

(2) The module title alone departs. ReadStages.lean:4 reads "acting by one's own law when not". Becoming.lean:2215, README.md:198 and check_becoming.py:2803-2804 copy it. Becoming.lean (2215-2224) and the checker's ReadStages sentence (2803-2809) then each also say "acting by its own law at both". So one entry, and one sentence, use both pronouns for the same law.

(3) 03-KNOWING:461 says "acting otherwise where not read", and 476 says "acting otherwise there". This drops the plan's compliance at the read stage. It can be read as covering `ownAtBoth` too, which `ownAtBoth_best_iff` shows is best under other conditions.

(4) 07-SIGNIFICANCE:647 and ALIGNMENT:21 say "complying only when read". In the two-act model this is exact, but it is another phrase.

(5) regions.json:3689 reads "RF7 complying when read and acting otherwise when not (03 §11)". That phrase appears nowhere else. Every other RF module note with a single record uses its record's title: ShownOrder "what choices show of the order they come from", Unread "what readings fix of the unread", Cascade "readers reading readers", OpenedCorrection the title less ", along one process", ReflexivePrediction "a prediction read by what it predicts".

What lowers the severity:
- regions.json notes are not rendered on any page; theory_graph.py reads only region and base.
- "one's own" is accepted elsewhere (the Experiment.lean title), so the pronoun itself breaks no naming rule.
- The paraphrases in 07 and the dossier are accurate.

The defect is real all the same: the module title and its note diverge from the name the module body and the record adopt, and single sentences mix two forms. The repository's rules ask for one adopted name per meaning ("Name at claim time in the adopted vocabulary"; "each in the one sense the glossary gives").

## F27 (fit, low, refuted)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.md:198; also README.zh.md:144

**Quoted.** “(every axiom report empty; each result under the hypotheses its theorem states)”

**Problem.** In this slot the neighbouring rows state premises ('(no premise)') and end with '; near-definitional' ('；近乎定义'). Every core row has empty axiom reports, so saying it in this one row alone suggests the others differ. The row also cites `twin_complyThenOwn` for 'open exactly where a lumping tells the stages apart', which that theorem does not state.

**Replacement.** '(no premise beyond each theorem's hypotheses): uniquely best exactly where ... (`ReadStages.complyThenOwn_best_iff`, `ReadStages.only_complyThenOwn_iff`), what it needs (`ReadStages.outweighs_needs`), open exactly where a lumping tells the stages apart (`ReadStages.complyThenOwn_realized_iff`), with the twin there (`ReadStages.twin_complyThenOwn`), and drawing the act afresh (...); near-definitional'. ZH: '（各定理所列条件之外不加前提）…；近乎定义'.

**Verdict: refuted.** The files refute the finding's main point. Its secondary point is a wording preference that does not amount to an error.

(1) The phrase is not in "this one row alone". At the scratch tree's base commit (HEAD 4951da8c2), and on main, README.md already has three rows with the identical parenthetical "(every axiom report empty; each result under the hypotheses its theorem states)": ReadingLoop (line 219), ReflexivePrediction (288) and OpenedCorrection (291, after "an application;"). README.zh.md has the same three in Chinese, "（每项公理报告皆空；各结果以各定理所列条件为前提）", at lines 125-127. `git diff HEAD` shows that RF7 adds one line to each README, the ReadStages row, and that row uses its RF siblings' established form. Separately, 13 core rows say "(no axiom; ...)", among them PropositionIdentity at line 199, the row directly below ReadStages. So stating the axiom status in a core row is common and does not suggest the other rows differ. "The neighbouring rows state '(no premise)'" is also only half true: the row above (Cascade, 197) does, but the row below (199) does not.

(2) The missing "; near-definitional" follows the same convention. The home theorems of all three sibling rows are near-definitional: chapter 03 lines 484 (ReadingLoop) and 499 (ReflexivePrediction) say "near-definitional, with one general law", and line 321 (OpenedCorrection) says "near-definitional, with witnesses on Revising's process". None of their README rows ends with "near-definitional". ReadStages's home theorem (03:474, "near-definitional, with witnesses") and study (study_rf7.txt:53) give the standing, and its README row leaves it out exactly as its siblings' rows do. The proposed replacement would make this row the odd one among the RF rows.

(3) The twin citation claims nothing false. Literally, `twin_complyThenOwn` (ReadStages.lean 505-521) states no iff. But it implies the "if" half of the clause:
- `Training.Through` is `∀ x x', alike x x' → (select x ↔ select x')` (Learning.lean:931), so `select := fun _ => True` satisfies it.
- `g := fun _ => .comply` is lumped and complies by `rfl`.
- The theorem then gives, where the stages are told apart, a lumped h taking `complyThenOwn`, i.e. a stronger, selection-relative form of openness there.

The same README cites one-direction theorems under "exactly where" clauses elsewhere: line 199 cites `PropositionIdentity.lumped_of_extensional` (PropositionIdentity.lean:92, Extensional → Lumped) and `lumped_of_byName` (173) next to their iffs. The row says nothing about the twin's selection content. Saying it, as the Becoming.lean bullet does at lines 2222-2223 ("with RF2's twin and fixing at the two stages") and as check_becoming.py's ReadStages sentence does ("with RF2's twin and fixing at the two stages"), would be an optional improvement, not a correction of a misattribution.

## F28 (fit, low, confirmed)

**Location.** theories/becoming/review/ALIGNMENT.md:19-21; also ALIGNMENT.md:28 and 40

**Quoted.** “It says nothing of: ... **deception** and deceptive alignment, which the theory reaches in RF's readings of where behaviour can differ when not read and of when complying only when read is a formation's own best plan (below)”

**Problem.** The list's lead says the theory says nothing of these topics, while this bullet says the theory reaches them. In the paragraph below, 'RF7' appears with no tie to round 2, although the paragraph's other parts are labelled 'Round 1' and 'Round 2's first landing'. The 'How it was made' list records the box as AJ5's work of 29 October, read by no independent reader, but does not record RF's later additions to it, including RF7's of 30 October.

**Replacement.** Lead: 'It says nothing of, or reaches only in readings:'. Line 28: 'Round 2's RF7 adds ...'. Add at line 40: '- Added on 30 October 2026 (board item RF, RF7): the deception bullet's clause and the box's RF7 sentences, read by the AI cold readers of RF7's texts; no independent human has read them.'

**Verdict: real.** All three parts of the finding hold in the files. The first two are real. The third is a mild clarity point, but it is accurate.

1. **The lead contradicts the bullet.** ALIGNMENT.md:19 opens the list with "It says nothing of:". The deception bullet at line 21 now says "which the theory reaches in RF's readings of where behaviour can differ when not read and of when complying only when read is a formation's own best plan (below)".
   - The history shows how this happened. AJ5 (aa098f254) wrote the lead when every bullet fit it: deception was a bare bullet, and assistance games "appear nowhere in the theory". RF round 1 (cbb396723) changed assistance games to "reaches only in RF's reading", and round 2's first landing (d7ada3c00) dropped "only". RF7's diff now brings deception under the same "reaches" wording while the lead stays absolute.
   - The other texts contradict the lead too. RF7's 07-SIGNIFICANCE.md row "Which function is learned" now says the laws say nothing of deception "beyond where behaviour can differ when not read and when complying only when read is a formation's own best plan". So chapter 7 says the laws reach deception that far.
   - RF7's new Reading in 03 §11 reads the theorem with deceptive alignment (Hubinger et al. 2019, §4.2) and concludes "this is the incentive, not deception in full".
   - The ReadStages.lean header says its two-stage comparison generalizes the toy example in Hubinger et al. §4. `complyThenOwn_best_iff` is a theorem about exactly that incentive.
   - A box titled "What the theory does not address", whose lead says "It says nothing of" deceptive alignment, is therefore inconsistent with its own bullet and with chapters 3 and 7. Reading the lead as "its laws say nothing" does not save it, because chapter 7 credits the laws themselves.

2. **"RF7" is not tied to round 2.** The label appears once in the dossier, at line 28 ("RF7 adds the incentive:"), with no date. The rest of that paragraph is framed as "Round 1 ... landed on 29 October 2026" and "Round 2's first landing". PLAN.md §12 ("then RF6.1 (landed, §4.6); then RF7") and the Lean header ("board item RF, round 2: RF7") both place RF7 in round 2, but the dossier never says so. This is a clarity gap rather than an error, and it is accurate as stated.

3. **"How it was made" omits RF's additions.** Line 40 records the box only as AJ5's work of 29 October: "No independent reader has read them."
   - No line records RF's additions to the box: round 1 on 29 October, round 2's first landing on 30 October, or RF7. Grep finds no other provenance line, and the review folder's other files do not mention RF.
   - RF7's diff leaves the list untouched.
   - board_rf2.py's land7 branch dates the landing by today's date, so RF7's additions would be of 30 October.
   - Lines 37–40 otherwise record each later addition and whether an independent reader read it, so this gap goes against the list's own pattern.

**Part of this predates RF7.** The assistance-games tension and the missing round 1 and round 2 provenance lines were already there before RF7. RF7 extends both rather than creating them. Severity is low, as the finding says.

## F29 (fit, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean:156; also lines 168 and 43

**Quoted.** “needs those too, and stays a debt.”

**Problem.** 'Debt' is a financial word, and none of the package's other 348 modules or any chapter uses it; it appears here and in 'the plan's deception debt' (line 168). On line 43, 'defeats' brings back in prose the contest that the review removed from the names when it renamed `Beats` to `Above`.

**Replacement.** Line 156: 'needs those too, and stays open'. Line 168: '(the plan's open item on deception)'. Line 43: 'and the content is that it also stands above the other two plans'.

**Verdict: real.** Every factual part of the finding checks out against the files, and the wording breaks the method's own rule on wording. It is low severity, and the fix changes no claim.

(1) The quoted text is in ReadStages.lean. Line 156 says "…needs those too, and stays a debt." Lines 167-168 say "(the plan's deception debt)". Lines 42-43 say "the content is that it also defeats the other two plans."

(2) No other module uses "debt". A case-insensitive grep over the 349 .lean files under Becoming/ and the root Becoming.lean finds it only in ReadStages.lean. There are no hits in theories/becoming/chapters/, and none in the other integrated texts: ALIGNMENT.md, the overview, the record kit make_records_rf7.py, study_rf7.txt, board_rf2.py and the package READMEs.

(3) The word does not fit the repository's rules or its own precedent.
- 08-METHOD.md line 44 says "Wording names the relation it means … it keeps money, payment and ownership for actual economic relations". Here "debt" stands for an item the model leaves open, which is not an economic relation. The superseded history/NONDUAL-METHOD.md:51 named "debt" explicitly among such words.
- PLAN.md (line 121, and the table rows at 227/230) does use "debt" as its term for an open item. But the landed sibling module, Unread.lean lines 52-53, carried that plan item into the package without the word: "Intention, anticipation and another's false belief need further structure and are not stated."
- The texts integrated for this same item also avoid it. Chapter 03's Reading (line 476) says "are not represented", the Open bullet (line 520) lists it as open, and the record (make_records_rf7.py:221) says "are not represented".
- The module's own review replaced "names carrying the reading or a financial word" (study_rf7.txt:73: Stakes→Prospects, no_leverage→kept_not_raised).

(4) "Defeats" reverses that review. study_rf7.txt:73 records `Beats` renamed to `Above`. The review's stated reason (scratchpad rf7-wf-findings.txt:139) was "'Stakes' is a wager word and 'Beats' a contest word". Both "stays a debt" and "defeats the two other plans" came in from a reviewer's proposed replacement text (rf7-wf-findings2.txt:47, :51, :195), so they are leftovers. Every other mention of this relation in the module says "stands above", including the first clause of the same sentence at line 39. The proposed "stands above the other two plans" is exactly what complyThenOwn_best_iff's mpr direction gives for complyAtBoth and ownThenComply.

Caveats:
- AGENTS.md's names rule governs names, not prose, so the breach is of the wording rule and of consistency, not of declaration naming.
- Other landed modules do use contest words in prose ("beats" in Lifting and ChoiceCountCapture, "defeats" in LimitVerification and Frontier). The "defeats" half is therefore a point of consistency within this module, not a rule the whole package enforces.
- The replacements keep the pointer to the plan and every claim unchanged.
