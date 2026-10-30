# The final check of RF7's texts

RF round 2, RF7. After the cold read's points and the cross-model re-check were taken, three readers, one per lens (exactness against the Lean; sources and readings; the Chinese edition and fit), read the final texts as integrated on main in a rehearsal worktree (main at `6645a2fae`), against the module `Becoming.ReadStages` and, for the sources, the paper's text and the cited works. Each lens's findings were then checked together by a separate reader asked to refute each. Of 50 findings, 42 were confirmed and 8 refuted. The findings and verdicts are reproduced verbatim from the run's result, with absolute paths of the rehearsal and landing worktrees made repository-relative and links quoted from the texts shown unlinked (`]\(`); other absolute paths in the verdicts name the readers' working files, not kept. What was taken is in [REVIEW-ROUND2](REVIEW-ROUND2.md#the-final-check-through-three-lenses); the prompts are in [BRIEF](BRIEF.md#round-2).

## X1 (exactness, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:482 (theorem at anchor r-when-complying-when-read-is-best); also the record's seventh law item, en and zh (make_records_rf7.py:193-197), and the study's Delta (study_rf7.txt:31-32)

**Quoted.** “every selection through agreement on the read stage that selects a law complying when read also selects one taking the plan (`ReadStages.twin_complyThenOwn`)”

**Problem.** `twin_complyThenOwn` (ReadStages.lean:519-524) has the hypothesis `alike : Learning.Lumped π g` on the selected law. Its conclusion is `∃ h, Learning.Lumped π h ∧ select h ∧ (h true, h false) = complyThenOwn`. The texts drop both: the selected law reading through the lumping, and the twin reading through it. Without them the sentence no longer uses `apart` at all. Any h with h true = comply and h false = own agrees with g on the read stage, so `through` selects it whatever π is. That makes the clause "Where the lumping tells them apart" idle, and the sentence states something different from the Lean, and stronger. RF2's own home paragraph (03:477) keeps both halves: "a selected act law reading through `π` ... a selected law reading through `π`". So does the module header (lines 67-69). The record has the same drop in English ("that selects a law complying when read also selecting one taking the plan") and in Chinese ("经读时之合而选、选一读时从之律者，亦选一取此策者"). So does the study ("selecting a law that complies when read also selects one taking the plan").

**Replacement.** 03: "every selection through agreement on the read stage that selects a law reading through the lumping and complying when read also selects one reading through it that takes the plan (`ReadStages.twin_complyThenOwn`)". Record law 7 en: "every selection through agreement on the read stage that selects a law reading through the lumping and complying when read also selecting one reading through it that takes the plan". zh: "经读时之合而选、选一经归并而读且读时从之律者，亦选一经此归并而读、取此策者". Study: "there every selection through agreement on the read stage selecting a law that reads through the lumping and complies when read also selects one reading through it that takes the plan".

**Verdict: real.** Confirmed. `twin_complyThenOwn` (ReadStages.lean:519-524) assumes `alike : Learning.Lumped π g` and concludes `∃ h, Learning.Lumped π h ∧ select h ∧ …`. Three texts drop both halves: 03:482, the record's seventh law (make_records_rf7.py:193-197, en 'selects a law complying when read also selecting one taking the plan', zh '选一读时从之律者，亦选一取此策者') and study_rf7.txt:31-32. By Learning.lean:931-935, `Through (AgreeOn (· = true))` asks agreement at `true` only. So any h with h true = comply and h false = own is selected with g, for every π, and 'Where the lumping tells them apart' becomes idle. RF2's paragraph (03:477) and the docstring (515-518) keep both halves. No earlier review raised this; E9's replacement itself carried the drop. One nuance: the stripped sentence is trivially true, not unsupported, so 'stronger' holds only for its hypothesis side. The defect is a dropped hypothesis and conclusion in a sentence citing the theorem. The proposed law fits the caps (416/420 en, 94/190 zh).

## X2 (exactness, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:482 (theorem at r-when-complying-when-read-is-best); also the record's correspondence, en and zh (make_records_rf7.py:262, 272), and the study's Standing (study_rf7.txt:58)

**Quoted.** “and leaves a gain from complying with some chance at each stage, while the first two exits hold against such a law (`ReadStages.freshDraw_not_above_without_value`, `ReadStages.freshDraw_not_above_of_not_raised`) and a single draw between the two uniform plans never gains (`ReadStages.Prospects.MixtureAbove`, `ReadStages.mixture_never_above`)”

**Problem.** The same paragraph defines gain: "a plan's gain and loss are the two parts of its expected value times the total" (`Prospects.gain`). Here "gain" means something else, standing above acting by its own law at both, the only comparison `FreshDrawAbove` and `MixtureAbove` make. Read in the defined sense, the last clause is false. A mixture with weight b > 0 on ownAtBoth has expected gain (b/(a+b))·k_O V, positive wherever k_O V > 0. `mixture_never_above` says only that it never stands above ownAtBoth. "Leaves a gain" came in with F23's fix. The record's law 2 also defines gain formally, while its correspondence says "its gain over a single mixture" (zh "其胜单一混合者"). That clause compares the fresh draw with a mixture, which no theorem does: both are compared only with ownAtBoth. This breaks one sense per term, and the second clause is stronger than the Lean.

**Replacement.** 03: "and leaves some chance of complying at each stage standing above acting by its own law at both, while the first two exits hold against such a law (…) and a single draw between the two uniform plans never stands above it (`ReadStages.Prospects.MixtureAbove`, `ReadStages.mixture_never_above`)". Record correspondence en: "and its standing above acting by its own law at both where no single mixture of the uniform plans does, the advantage of behavioural strategies under absent-mindedness (Piccione and Rubinstein 1997)". zh: "其可居两阶段皆依己律之上而二同行策之单一混合永不能，即健忘之下行为策略之优（Piccione 与 Rubinstein 1997）". Study Standing: "and that drawing afresh can stand above the own law at both where a single mixture never does is the advantage of behavioural over mixed strategies under absent-mindedness".

**Verdict: real.** Confirmed. 03:482 defines a plan's gain (`Prospects.gain`, ReadStages.lean:243-246) and then uses 'gain' for standing above ownAtBoth: 'leaves a gain from complying…' and 'a single draw … never gains'. `MixtureAbove`'s own docstring (281-285) gives the mixture a gain of b·k_O V, which is positive where b>0 and k_O V>0. `mixture_never_above` (697) says only that the mixture is not above ownAtBoth, so read in the defined sense the clause is false. E5/F8 already counted 'gains' echoing `Prospects.gain` as a real defect in the record's statement, and F23 introduced 'leaves a gain'. The record's correspondence ('its gain over a single mixture', lines 261-262; zh '其胜单一混合者', 272) compares the fresh draw with a mixture. No theorem does: `FreshDrawAbove` (277-279) and `MixtureAbove` (284-285) are each compared with ownAtBoth only. The study's Standing (56-60) does the same, with gain defined in its Delta (12-13). The same usage is in the module's Standing (111-114), 08's bullet and PLAN:179. Caveat: the correspondence (en) is 1194 of 1200 characters, so the proposed wording would fail `capped('correspondence', …)` without an offsetting cut.

## X3 (exactness, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean:62-65 (module header, bullet "Telling the stages apart, joined to RF2")

**Quoted.** “an act law reading them through a lumping `π` (`Learning.Lumped`) takes a plan exactly where the plan is uniform, one act at both stages (`Uniform`), or `π` tells the stages apart (`plan_realized_iff`, `lumped_uniform`)”

**Problem.** `plan_realized_iff` is existential: `(∃ g, Learning.Lumped π g ∧ (g true, g false) = p) ↔ (Uniform p ∨ π true ≠ π false)`. With "an act law" as a generic subject (every such law), the sentence is false. With π = id, the constant law `fun _ => .own` reads through π and takes only ownAtBoth. The cold read's E15 verdict named this header clause as having the same ambiguity. Its fix ("open to some act law") went into the root bullet, 03, the record's sixth law and the study, but not into the header, which still says "takes a plan exactly where".

**Replacement.** "a plan is open to some act law reading them through a lumping `π` (`Learning.Lumped`) exactly where the plan is uniform, one act at both stages (`Uniform`), or `π` tells the stages apart (`plan_realized_iff`, `lumped_uniform`)"

**Verdict: real.** Confirmed. ReadStages.lean:62-65 still says 'an act law reading them through a lumping `π` … takes a plan exactly where the plan is uniform … or `π` tells the stages apart'. `plan_realized_iff` (473-475) is existential. With π = id, the constant law `fun _ => .own` is `Lumped` and takes only ownAtBoth, so the generic (universal) reading is false. The E15 verdict (REVIEW-RF7-COLDREAD.md:438-440) named 'the module header (lines 62-65)' as having the same ambiguity. Its fix, 'open to some act law', is now in Becoming.lean:2235, 03:482, the record's sixth law and study_rf7.txt:29, but not in the header. So this is not taken correctly there.

## X4 (exactness, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean:2238-2239 (ReadStages bullet); check_becoming.py:2816-2817 (SCOPE, ReadStages sentence)

**Quoted.** “a law drawing its act afresh at each stage stands above acting by its own law at both for some chance exactly where `2 k_O V + c T < k_C V`”

**Problem.** `FreshDrawAbove m r` (ReadStages.lean:277-279) has one chance m/(m+r) at both stages, so the law cannot tell the stages apart, and `freshDraw_above_iff` is about such laws only. A law that tells the stages apart can draw afresh with a chance per stage, and for it the "only where" fails. Chance one at the read stage and nought at the unread one gives complyThenOwn, which stands above ownAtBoth wherever k_O V + c T < k_C V (`complyThenOwn_best_iff`), below the stated threshold whenever k_O V > 0. The cold read's F7(4) found the same unrestricted subject in the dossier, which now says "A law that cannot tell the stages apart but draws its act afresh". The root bullet and the checker's scope sentence still say only "a law drawing its act afresh at each stage".

**Replacement.** Root bullet: "a law that cannot tell the stages apart but draws its act afresh at each stage, with one chance at both, stands above acting by its own law at both for some chance exactly where `2 k_O V + c T < k_C V`". The checker's sentence the same, without backticks.

**Verdict: real.** Confirmed. Becoming.lean:2238-2239 and check_becoming.py:2816-2817 say only 'a law drawing its act afresh at each stage … for some chance exactly where 2 k_O V + c T < k_C V'. `FreshDrawAbove m r` (277-279) uses one chance at both stages, and the module lists 'chances where the stages are told apart' among what it leaves out (178-179). A law with chance one at the read stage and nought at the unread one takes complyThenOwn, which `complyThenOwn_best_iff` (299-308, the ownAtBoth case being `outweighs` itself) puts above ownAtBoth wherever k_O V + c T < k_C V. Valid prospects T=10, k_C=9, k_O=4, V=10, c=1 give 50 < 90, while 2 k_O V + c T = 90 is not below 90. So under this unrestricted subject the 'only where' direction fails. The cold read's F7(4) found the same subject in the dossier, which now says 'A law that cannot tell the stages apart but draws its act afresh'. The root bullet and checker were not covered.

## X5 (exactness, low, confirmed)

**Location.** make_records_rf7.py:168 (the record's third law item, zh)

**Quoted.** “两阶段皆依己律居其上，恰当 0 < k_O V 且 k_C V < k_O V + c T”

**Problem.** The English elides the verb: "acting by its own law at both [stands above every other plan] exactly where 0 < k_O V and k_C V < k_O V + c T" (`ownAtBoth_best_iff`). The Chinese supplies 居其上, which can be read as "stands above it", that is, above the plan just named (complyThenOwn). On that reading the iff is false. ownAtBoth stands above complyThenOwn exactly where k_C V < k_O V + c T, with no need of 0 < k_O V (k_C = k_O = 0 and 0 < c T, for example). The condition 0 < k_O V comes only from standing above ownThenComply. So the two editions can differ in content.

**Replacement.** 两阶段皆依己律居其余诸策之上，恰当 0 < k_O V 且 k_C V < k_O V + c T

**Verdict: real.** Confirmed. make_records_rf7.py:168 (zh) has '两阶段皆依己律居其上，恰当 0 < k_O V 且 k_C V < k_O V + c T'. By `Above`, `gain` and `loss` (256, 243-252), ownAtBoth stands above complyThenOwn exactly where k_C V < k_O V + c T. The condition 0 < k_O V comes only from the ownThenComply case of `ownAtBoth_best_iff` (317, 322). With V = 0 and 0 < c T, ownAtBoth stands above complyThenOwn and 0 < k_O V fails, so the iff is false read as 'above it'. That reading is the record's own usage: its zh counterexample (line 244) writes '居其上' for 'stands above the plan just named'. The English elides 'stands above every other plan' unambiguously. The replacement fits (142/190).

## X6 (exactness, low, confirmed)

**Location.** make_records_rf7.py:247-248 and 252 (validation, en and zh); 278-280 (dependency on generalization-through-lumping, en and zh)

**Quoted.** “ReadStages imports Unread, for Learning.twin_selected, and through it Learning, for Lumped and lumped_determines”

**Problem.** The module's own statements use more of Learning: `Learning.Determines` (the type of `read_fixes_unread`, line 512), `Learning.Training.Through` (`twin_complyThenOwn`, line 521) and `Learning.Training.AgreeOn` (`twin_complyThenOwn`, line 521; `kept_alike`, line 540). All three are declarations of the record generalization-through-lumping, whose laws cite them. The dependency detail ("Learning.Lumped and Learning.lumped_determines: …") names only two. RF2's record names "Lumped, Free, Determines and lumped_determines; Training.Through, AgreeOn …" on the same edge. The E9 verifier's caveat, that the replacement "still leaves them off that edge", was not taken. The dependency audit is incomplete.

**Replacement.** Validation en: "and through it Learning, for Lumped, Determines, lumped_determines, Training.Through and Training.AgreeOn". zh: "并经之引 Learning，为 Lumped、Determines、lumped_determines、Training.Through 与 Training.AgreeOn". Dependency en: "Learning.Lumped, Learning.Determines and Learning.lumped_determines, with Learning.Training.Through and Learning.Training.AgreeOn: an act law going alike across a lumping of the stages, the read stage fixing the unread act where the lumping ties them, and selection through agreement on the read stage." zh to match.

**Verdict: real.** Confirmed. Beyond `Lumped` and `lumped_determines`, ReadStages states its results with `Learning.Determines` (`read_fixes_unread`, 512), `Learning.Training.Through` and `Learning.Training.AgreeOn` (`twin_complyThenOwn`, 521; `kept_alike`, 540). These are laws 1 and 7 of generalization-through-lumping.json. RF2's edge to that record lists 'Lumped, Free, Determines and lumped_determines; Training.Through, AgreeOn …'. The validation (247-248, zh 252) and the dependency detail (278-280) name only two, and E9's verifier caveat flagged exactly these three. Caveat on the fix: validation_scope is a hard cap (260 zh). The proposed zh is 294 characters, and even a compressed list is about 272-276. So put the full list on the dependency edge in both languages; in the validation keep the English list (480/600) and give the Chinese a pointer to the dependencies, or trim elsewhere.

## X7 (exactness, low, confirmed)

**Location.** make_records_rf7.py:186-190 (the record's sixth law item, en and zh)

**Quoted.** “a plan is open to some act law reading them through a lumping exactly where the plan has one act at both stages or the lumping tells the stages apart, so the plan is open exactly there”

**Problem.** "the plan" names any plan in the first clause. In the second it names complyThenOwn, as it does everywhere else in the record (laws 4, 5, 7 and 9). So the second clause reads as a restatement of the first, and the content of `complyThenOwn_realized_iff`, cited in this law, is never stated: being non-uniform (`complyThenOwn_not_uniform`), the plan is open exactly where π true ≠ π false. The Chinese has the same problem, with 此策 used for both: "恰当此策两阶段同行或此归并分两阶段，故此策恰于彼处可取".

**Replacement.** en: "a plan is open to some act law reading them through a lumping exactly where it has one act at both stages or the lumping tells the stages apart, so the plan, with two acts, is open exactly where the lumping tells the stages apart". zh: "一策可为某经归并读两阶段之行律所取，恰当其两阶段同行或此归并分两阶段，故此策（两阶段异行）恰于归并分两阶段处可取".

**Verdict: real.** Confirmed (low). make_records_rf7.py:186-190 reads 'a plan is open … exactly where the plan has one act at both stages … so the plan is open exactly there'. The zh uses 此策 for both. Elsewhere the record uses 'the plan' / 此策 for complyThenOwn (laws 5, 7, 9, lines 181-182, 194, 211). Read with the referent just used, the second clause restates `plan_realized_iff`. The record never states `complyThenOwn_not_uniform` (468) or the content of `complyThenOwn_realized_iff` (500-502, open exactly where π true ≠ π false), though law 6 cites both. Nothing is false under the intended reading. The defect is one phrase with two referents in one sentence, the kind F25 was confirmed for, and in zh the tautological reading is the natural one. The replacement fits (414/420, 120/190).

## X8 (exactness, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:484 (Reading of r-when-complying-when-read-is-best, first sentence)

**Quoted.** “there, where a formation can tell an unread occasion from every read one, a selection through the readings leaves its act there free”

**Problem.** This restates RF2's law without its hypotheses. `Learning.free_lumped` and `Learning.twin_selected` need being in that occasion's lump decided (`[∀ i, Decidable (π i = π x)]`). They give freedom only among act laws reading through the lumping: a selected law reading through π has selected twins reading through π. The restatement drops both. RF2's own Reading (03:479, "being in its lump decided") and the overview's sentence keep them.

**Replacement.** "there, where a formation's lumping tells an unread occasion from every read one, being in that lump decided, a selection through the readings that selects a law reading through the lumping also selects one taking any act there"

**Verdict: real.** Confirmed (low). 03:484 says 'there, where a formation can tell an unread occasion from every read one, a selection through the readings leaves its act there free'. `free_lumped` (Unread.lean:87) and `twin_selected` (104) need `[∀ i, Decidable (π i = π x)]`. They give freedom only among `Lumped π` laws, given a selected lumped law. RF2's statement (03:477, 'being in that occasion's lump decided … a selected act law reading through `π` … a selected law reading through `π`'), its Reading (03:479, 'being in its lump decided') and the overview's new sentence all keep both. Without the lumping restriction, agreement on the readings constrains nothing at any unread occasion, so the 'can tell' condition would be idle. No earlier review raised this sentence.

## X9 (exactness, low, confirmed)

**Location.** study_rf7.txt:38-41 (Delta, drawing afresh) and 19-20 (Delta, which plan is best); also ReadStages.lean:84-86 (module header)

**Quoted.** “so for some chance exactly where 2 k_O V + c T < k_C V (freshDraw_above_iff, through freshDraw_gap and freshDraw_witness, with the arithmetic square_split, sum_le_square, sum_regroup, freshDraw_bound and sum_lt_of_room)”

**Problem.** Two cited names do not do what the text says. First, `freshDraw_above_iff` (lines 674-678) goes through `freshDraw_gap` and `freshDraw_witness`. The gap uses `freshDraw_bound` (with `square_split`, `add_mul_split`, `sum_le_square`), and the witness uses `square_split`, `add_mul_split` and `sum_lt_of_room`. `sum_regroup` is used only in `freshDraw_reduce` (line 611), that is, for `freshDraw_above_iff_chance`. The module header's list (lines 84-86) also puts `sum_regroup` and `freshDraw_reduce` under `freshDraw_above_iff`. Second, lines 19-20 cite `complyThenOwn_maximal_iff` for "Every maximal plan … is the first exactly where keeping outweighs the loss". That theorem says the plan is maximal exactly where k_O V + c T ≤ k_C V, which the study never states.

**Replacement.** "(Prospects.FreshDrawAbove, freshDraw_above_iff_chance, by freshDraw_reduce with square_split and sum_regroup), so for some chance exactly where 2 k_O V + c T < k_C V (freshDraw_above_iff, through freshDraw_gap, by freshDraw_bound with square_split and sum_le_square, and freshDraw_witness, with sum_lt_of_room)". Lines 19-20: "… is the first exactly where keeping outweighs the loss (Prospects.Maximal, only_complyThenOwn_iff), and the first is maximal exactly where k_O V + c T ≤ k_C V, ties included (complyThenOwn_maximal_iff)". In the module header, move `sum_regroup` and `freshDraw_reduce` to the `freshDraw_above_iff_chance` clause.

**Verdict: real.** Confirmed (low). `sum_regroup` is used only at ReadStages.lean:611 inside `freshDraw_reduce`, which is used only by `freshDraw_above_iff_chance` (639). `freshDraw_above_iff` (674-678) goes through `freshDraw_gap` (600, via `freshDraw_bound`, which uses `square_split` and `sum_le_square`) and `freshDraw_witness` (`square_split`, `sum_lt_of_room`). Yet study_rf7.txt:38-41 lists `sum_regroup` under `freshDraw_above_iff`, and the header (84-86) lists both `sum_regroup` and `freshDraw_reduce` there. study_rf7.txt:19-20 cites `complyThenOwn_maximal_iff` (385-386: maximal ⟺ k_O V + c T ≤ k_C V) for a sentence that is `only_complyThenOwn_iff`'s, and the study never states the ≤ condition. Both are misattributions; the replacement is correct.

## X10 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:179 (§4.6, RF7 bullet)

**Quoted.** “complying when read and acting by its own law when not uniquely best exactly where the weight complying adds to being kept, times the value, exceeds the loss, every optimizing choice taking it exactly there”

**Problem.** The same bullet defines `k_C` and `k_O` as "the weights of being kept" and says "the weights are `q_M T` and `q_H T`". With those natural-number weights, the clause states (k_C − k_O) V > c. `KeepingOutweighs` and `complyThenOwn_best_iff` say k_O V + c T < k_C V, that is (k_C − k_O) V > c T, which differs by the factor T. The clause is right only read as probabilities, and it does not say so. 03 §11 writes "which in probabilities is …", the overview "read as probabilities where valid", the board "read as probabilities".

**Replacement.** "complying when read and acting by its own law when not uniquely best exactly where the weight complying adds to being kept, times the value, exceeds the loss times the total (read as probabilities, the loss), every optimizing choice taking it exactly there"

**Verdict: real.** Confirmed (low). PLAN.md:179 defines `k_C` and `k_O` as 'the weights of being kept' and says 'the weights are `q_M T` and `q_H T`'. `KeepingOutweighs` (ReadStages.lean:263) is k_O V + c T < k_C V, that is (k_C − k_O)V > cT. The bullet's 'the weight complying adds to being kept, times the value, exceeds the loss', in those weights, says (k_C − k_O)V > c, off by T; it holds only in probabilities. The leading 'the weights read as probabilities only where valid' is a separate item of the semicolon list, not a frame for the next one. The other texts mark the frame: 03:482 'which in probabilities is', the root bullet 'times the total, read as probabilities where valid … the loss', the board 'read as probabilities'. The conflict came from E20's letter definitions.

## X11 (exactness, low, confirmed)

**Location.** make_records_rf7.py:311-314 (AMEND: the new related entry on what-readings-fix-of-the-unread, en and zh)

**Quoted.** “The same two stages with prospects: when complying when read and acting by its own law when not is uniquely best, with this twin where the stages are told apart and the fixing where they are tied.”

**Problem.** RF2's record has no two stages. Its statement and laws are for any type of occasions (its hypotheses: "Any types of occasions, values and lumps"), and RF7 instantiates them at two stages (I := Bool). The same amendment also removes RF2's next step, the record's only earlier mention of "two stages". "The same two stages" (zh "同之两阶段") says RF2 is itself set in two stages, which misdescribes the landed record.

**Replacement.** en: "Its twin and the fixing at two stages, read and unread, with prospects: when complying when read and acting by its own law when not is uniquely best, the twin where the stages are told apart and the fixing where they are tied." zh: "此孪生与其定于读与不读两阶段而有望：读时从而不读时依己律何时唯一最优；两阶段可分处有此孪生，合处有其定。"

**Verdict: real.** Confirmed (low). RF2's record (what-readings-fix-of-the-unread.json) is over 'Any types of occasions, values and lumps'. Its only mention of two stages is the next step, which this amendment replaces with 'A frozen test' (make_records_rf7.py:315-317). RF7 instantiates RF2 at I := Bool (`twin_selected` with R := (· = true), x := false, ReadStages.lean:528). RF2's sibling related entry, 'the same question for the order a chooser's choices come from', uses 'the same' for this record's own question. By that pattern 'The same two stages with prospects' (zh '同之两阶段而有望') presents RF2 as set in two stages. The amended scope item's 'in two stages' is a weak antecedent in another section and does not rescue it.

## X12 (exactness, low, confirmed)

**Location.** make_records_rf7.py:218-222 (the record's hypotheses, en and zh)

**Quoted.** “or a chance drawn afresh and independently at each stage, or one draw before the read stage. / 或于读之阶段前仅抽一次，以择两阶段皆从或两阶段皆依己律。”

**Problem.** The fix for A5 introduced an English–Chinese difference. The Chinese now says what the single draw chooses between: complying at both and acting by its own law at both, as `MixtureAbove a b` defines it (ReadStages.lean:281-285). The English, kept as it was, names no alternatives, so the two fields differ in content.

**Replacement.** en: "…, or a chance drawn afresh and independently at each stage, or one draw before the read stage, between complying at both stages and acting by its own law at both."

**Verdict: real.** Confirmed (low). make_records_rf7.py:218-222: the English hypotheses end 'or one draw before the read stage.'. The Chinese adds '以择两阶段皆从或两阶段皆依己律', which matches `MixtureAbove a b` (ReadStages.lean:281-285): complying at both with weight a, own law at both with weight b. A5's taken fix added the Chinese clause and kept the English, so the two fields now differ in content. The proposed English fits (407/420).

## X13 (exactness, low, confirmed)

**Location.** make_records_rf7.py:288-290 (the new record's history entry, the what_en and what_zh passed to done())

**Quoted.** “and drawing the act afresh against a single mixture / 与 RF2 之接、每阶重抽其行”

**Problem.** The Chinese drops "against a single mixture" (`mixture_never_above`), so the two editions of the history differ in content. It also writes 每阶 where every other Chinese field writes 每阶段: E12 replaced 阶 because alone it reads as "order" in this repository.

**Replacement.** zh: "读时从、不读时依己律何时为最优：四策、凡最优之择、诸出路与此策之所需、与 RF2 之接、每阶段重抽其行而对单一混合"

**Verdict: real.** Confirmed (low). make_records_rf7.py:288-290: what_en ends 'and drawing the act afresh against a single mixture', and what_zh ends '每阶重抽其行', with nothing for the mixture. The F20 verifier had flagged this done() difference (REVIEW-RF7-COLDREAD.md:2051), and it was not taken. E12's verifier caveat 4 flagged bare 每阶 as reading as 'each order', and every other zh field writes 每阶段 (statement 150, law 8 203, law 9 214, hypotheses 222). One more remnant outside the finding: law 2's zh (161) still has '不读之阶从'.

## S1 (sources, medium, confirmed)

**Location.** theories/becoming/results/records/what-readings-fix-of-the-unread.json, field correspondence (en and zh). The AMEND for this record in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:310-327 changes related, next_delta, does_not_show[1] and history, and leaves this field alone. The same tension appears in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:227 (literature row, RF2's cell).

**Quoted.** “it locates where behaviour can differ when not read while every reading agrees, only where the formation's lumping tells the occasion from every read one: a necessary condition of what deceptive alignment and alignment faking describe (Hubinger and others 2019; Greenblatt and others 2024)”

**Problem.** Once RF7 lands, two records say opposite things about one source.

- **RF2's record:** telling the occasion apart is a necessary condition of what Hubinger and others describe. Zh: 为欺骗对齐与对齐伪装所述者之必要条件.
- **RF7's home section (03-KNOWING.md:484):** "Telling the stages apart is not among the three, and Hubinger and others note at the close of their §4.5 that it is not needed".
- **The source agrees with RF7.** It says "it is not strictly necessary that a mesa-optimizer be able to detect the difference between training and deployment in order for it to be incentivized to behave deceptively ... randomly defect with some probability" (rlo.txt:1464-1473). Earlier in §4.5 it says the effects are "externally visible when the mesa-optimizer defects—either randomly or after undergoing a distributional shift" (rlo.txt:1413-1414).
- **RF7's own law agrees too.** ReadStages.freshDraw_above_iff proves the gain survives a law that cannot tell the stages apart. A randomizing formation that complied at every read occasion can then act otherwise unread while its lumping ties the occasions.

The necessity holds only for the deterministic act laws RF2 models. The plan's row has the same problem: "the possibility exact" sits in the same cell as "§4.5's random defection".

**Replacement.** Add a correspondence entry to AMEND[RF2]. The field is now 1000 of 1200 characters in English and 265 of 500 in Chinese.

En: "... only where the formation's lumping tells the occasion from every read one: for a deterministic law, a necessary condition of what deceptive alignment and alignment faking describe (Hubinger and others 2019; Greenblatt and others 2024), whose intention, anticipation and incentive are not represented; a law drawing its act afresh needs no such lumping, as their §4.5 notes (when-complying-when-read-is-best)."

Zh: "……唯在形成之归并分此时于每一读处者：于定律，为欺骗对齐与对齐伪装所述者之必要条件（Hubinger 等 2019；Greenblatt 等 2024），其意图、预期与诱因未表；每阶段重抽其行之律无需此归并，如其 §4.5 所言（when-complying-when-read-is-best）。"

PLAN.md:227: "the possibility exact for a deterministic law; the incentive in two stages, ..."

**Verdict: real.** Confirmed. RF2's record correspondence (theories/becoming/results/records/what-readings-fix-of-the-unread.json) reads the lumping telling the occasion apart as 'a necessary condition of what deceptive alignment and alignment faking describe (Hubinger and others 2019 ...)' (zh 为欺骗对齐与对齐伪装所述者之必要条件). The cited source denies this: 'it is not strictly necessary that a mesa-optimizer be able to detect the difference between training and deployment in order for it to be incentivized to behave deceptively ... randomly defect with some probability' (/private/tmp/claude-501/-Users-ren-theories/50635de9-b91e-4f4c-a63c-8413ce8c4652/scratchpad/dl-rlo/rlo.txt:1464-1473), and its effects show when it defects 'either randomly or after undergoing a distributional shift' (1413-1414). After landing, 03-KNOWING.md:484 says Hubinger and others note at the close of §4.5 that telling the stages apart 'is not needed', and RF7's correspondence cites 'their §4.5 remark (an absent-minded driver, defecting at random)'. AMEND[RF2] (make_records_rf7.py:310-327) touches only related, next_delta, does_not_show[1] and history. RF7 reconciles the two by 'for a deterministic law' (03:484; ALIGNMENT.md:28's exits), a qualifier RF2's record lacks. PLAN.md:227 puts 'the possibility exact' beside '§4.5's random defection' in one cell. The replacement fits (1133/1200 en, 329/500 zh). Two fixes to the replacement: zh '于定律' reads as 'for a theorem/law'; the repository renders a deterministic law 确定律 (package README.zh.md), so write 于确定律. And 'needs no such lumping' conflicts with the module's convention that the lumping carries everything the law reads, any chance it draws included (ReadStages.lean, 'Telling the stages apart' bullet). Better: 'a law drawing its act afresh at each stage can gain without telling the stages apart, as their §4.5 notes'.

## S2 (sources, medium, confirmed)

**Location.** theories/becoming/chapters/07-SIGNIFICANCE.md:651 (row "Which function is learned")

**Quoted.** “nor anything of deception, which needs a recipient's belief and an intention to cause one; they say where behaviour can differ when not read and when complying when read and acting by its own law when not is uniquely best in the order given prospects give, read [AI reading] as deception's possibility and the incentive deceptive alignment names”

**Problem.** (a) "Deception's possibility" reads RF2's law as the place where deception becomes possible. This came from the cold read's R9 replacement, and it is wrong on four counts.

- It contradicts the row's own sense of deception, which needs a belief and an intention.
- It contradicts 03 §11's Reading of the same law (03-KNOWING.md:479): "A reader misled lies outside that chain: a law acting alike everywhere can mislead a reader whose readings miss where it is wrong, and a law changing when read misleads no reader who knows how it changes". RF2's record says the same: "A reader misled: it lies outside the chain".
- Ward, Belardinelli, Toni and Everitt (2023), whom the module cites, meet their own definition in their Example 1 (war game). There the deceiver sits at a pooling equilibrium "at which S acts the same regardless of type", and "all the conditions for deception are met".
- By Hubinger and others' §4.5 and ReadStages.freshDraw_above_iff, acting otherwise when unread is not even necessary for deceptive alignment's defection, except for a deterministic law.

So acting otherwise when unread is neither necessary nor sufficient for deception.

(b) The incentive reading here carries none of the premises 03 §11 states: the concealment premise, the prospects as the formation's own assessment, and the third condition assumed.

**Replacement.** "... read [AI reading] as where a deterministic law can act otherwise unread, as deceptive alignment describes, and, with 03 §11's premises (the selection's keeping responding to the act read as evidence of the law, the prospects as the formation's own assessment, the unread stage given and known), as the incentive deceptive alignment names ([03 §11]\(03-KNOWING.md#r-what-readings-fix-of-the-unread), [when complying when read is best]\(03-KNOWING.md#r-when-complying-when-read-is-best))"

This leaves unchanged the prefix that ALIGNMENT.md quotes.

**Verdict: real.** Confirmed on both counts. (a) 07-SIGNIFICANCE.md:651 defines deception as needing a recipient's belief and an intention, then reads where behaviour can differ when not read as 'deception's possibility'. That contradicts 03-KNOWING.md:479 ('A reader misled lies outside that chain: a law acting alike everywhere can mislead a reader whose readings miss where it is wrong, and a law changing when read misleads no reader who knows how it changes') and RF2's record does_not_show[2] ('A reader misled: it lies outside the chain'). It also contradicts the work the module cites. Ward and others' war game (scratchpad tools-pdf/ward.txt) has 'every NE is a pooling equilibrium at which S acts the same regardless of type' and 'all the conditions for deception are met'. The phrase came from R9's replacement (REVIEW-RF7-COLDREAD.md:1098), so it is a problem the fix introduced, not a point already taken. (b) The incentive reading carries none of the premises under which 03:484 reads it ('With that taken', 'Read as that assessment') and which 08-METHOD.md:485 now names. The replacement keeps the prefix ALIGNMENT.md quotes.

## S3 (sources, medium, confirmed)

**Location.** theories/becoming/review/ALIGNMENT.md:28 (scope box, the paragraph on RF's rounds, RF7's first sentence)

**Quoted.** “Round 2's RF7 adds what RF reads as the incentive deceptive alignment names [AI reading]: in two stages, complying when read and acting by its own law when not is uniquely best among four plans exactly where, read as probabilities, the weight complying adds to being kept, times the value, exceeds the loss of complying”

**Problem.** The dossier gives the reading without the premises it rests on.

- **The concealment premise.** 03 §11 reads the plan with deceptive alignment only "With that taken", that is, a selection shown the law would keep it less. Otherwise "the weights alone fit equally a selection that knows the law and keeps it on compliance, under which complying when read hides nothing" (03-KNOWING.md:484). The source's glossary needs a mesa-optimizer that seems "more fit from the perspective of the base optimizer than it actually is" (rlo.txt:1689).
- **The prospects as the formation's own.** 03 §11 reads the incentive only "Read as that assessment". The dossier attaches "Read as the formation's own prospects" to the exits alone.

No form of "conceal", "evidence of the law", "seem fitter" or "shown the law" appears anywhere in ALIGNMENT.md. The cross-model re-check (REVIEW-ROUND2, "The re-check of what was taken", item 2) required this premise for 08's reading. It was added in 08 only, and the dossier is the text a reviewer reads alone.

**Replacement.** "Round 2's RF7 adds what RF reads as the incentive deceptive alignment names [AI reading], taking the prospects as the formation's own assessment and the selection's keeping to respond to the act read as its evidence of the formation's law, so that a selection shown the law would keep it less: in two stages, complying when read and acting by its own law when not is uniquely best among four plans exactly where, ..." (the rest unchanged)

**Verdict: real.** Confirmed. ALIGNMENT.md:28 states 'what RF reads as the incentive deceptive alignment names [AI reading]' with no concealment premise. grep finds no 'conceal', 'evidence of the law', 'seem fitter' or 'shown the law' anywhere in ALIGNMENT.md. 'Read as the formation's own prospects' opens the next sentence, on the exits only. 03-KNOWING.md:484 reads the plan with deceptive alignment only 'With that taken'. The module says that without it the weights fit a selection that knows the law, 'under which complying when read hides nothing'. The source's glossary needs seeming 'more fit from the perspective of the base optimizer than it actually is' (rlo.txt:1687-1689). The re-check required exactly this premise for 08's reading (REVIEW-ROUND2.md, 'The re-check of what was taken', item 2, taken in 08 only). The dossier is meant to be read alone. The replacement is apt.

## S4 (sources, medium, confirmed)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:96 (§3, the new reading clause)

**Quoted.** “Read as inner alignment, evaluation awareness and the incentive deceptive alignment names, these locate where a trained law can choose otherwise later, where it can act otherwise unread, and when doing so is its own best plan; installation, intention and a recipient's belief are not represented [AI reading]”

**Problem.** The overview has the same omission as the dossier. "Its own best plan" supplies the own-assessment premise, but two premises are missing.

- **The concealment premise.** Without it, by 03 §11, complying when read "hides nothing" (03-KNOWING.md:484). The plan is then not deceptive alignment's incentive in the sense of the source's §7.4 glossary (rlo.txt:1689).
- **The third condition.** That it is assumed, the unread stage given and known, is not said either.

After the re-check, 08's bullet carries the concealment premise. The overview, which more readers see, does not.

**Replacement.** "Read as inner alignment, evaluation awareness and, taking the selection's keeping to respond to the act read as evidence of the formation's law and the unread stage as given and known, the incentive deceptive alignment names, these locate where a trained law can choose otherwise later, where it can act otherwise unread, and when doing so is its own best plan; installation, intention and a recipient's belief are not represented [AI reading]"

**Verdict: real.** Confirmed for the concealment premise. THE-THEORY-OF-BECOMING.md:96 gives 'the incentive deceptive alignment names' with 'its own best plan', which supplies the own assessment, but nothing of the selection's keeping responding to the act as evidence of the law. Without that premise 03:484 says complying when read 'hides nothing', and 08:485 now requires it. The third-condition half is weaker. The proved sentence already says 'in two stages, read and then not', so the unread stage is given in the model, and the assumption is a modelling choice rather than a premise of the reading (see #7). The fix needs only the concealment clause, though the proposed wording is also correct.

## S5 (sources, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:324-327 (AMEND[RF2]['history'], written into what-readings-fix-of-the-unread.json's history, en and zh)

**Quoted.** “the next step drops disclosure or concealment in two stages, now done there”

**Problem.** This presents a reading as a result. Zh: 下一步删去两阶段中之示或隐（已于彼成）.

RF7's record lists concealment among what it does not show: "Concealment: complying when read conceals only where it makes the law seem fitter to the selection than it is, a selection shown the law keeping it less, which the prospects do not give; the weights fit as well a selection knowing the law" (make_records_rf7.py:226-228). PLAN.md §4.2 now says "RF7 states the separate two-stage comparison (§4.6), with disclosure and concealment as labelled readings".

What RF7 did is the two-stage comparison with the continuation value represented. It did not do disclosure or concealment.

**Replacement.** En: "related to when-complying-when-read-is-best; the next step drops disclosure or concealment in two stages, whose two-stage comparison is now stated there, disclosure and concealment staying readings it does not show, and the second item of what it does not show points to it; no statement or declaration changed."

Zh: "与 when-complying-when-read-is-best 相关联；下一步删去两阶段中之示或隐（其两阶段之比较已于彼陈，示与隐仍为彼所不示之读），所不示之第二项指向之；无一陈述或声明改变。"

**Verdict: real.** Confirmed. AMEND[RF2]['history'] (make_records_rf7.py:324-327) writes 'the next step drops disclosure or concealment in two stages, now done there' (zh 已于彼成). The record it points to lists concealment among what it does not show: 'Concealment: complying when read conceals only where it makes the law seem fitter ... which the prospects do not give' (make_records_rf7.py:226-228). PLAN.md §4.2 (line 127), after the re-check's item 7, says RF7 'states the separate two-stage comparison (§4.6), with disclosure and concealment as labelled readings'. The history repeats the overclaim the re-check removed from the plan. The replacement is apt.

## S6 (sources, low, refuted)

**Location.** theories/becoming/chapters/03-KNOWING.md:484.

Also:
- theories/becoming/chapters/08-METHOD.md:485
- experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean:111-112 (Standing)
- _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:57 and :82
- _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:261 (correspondence)

**Quoted.** “Hubinger and others note at the close of their §4.5 that it is not needed: with the toy's episodes not told apart the problem is an absent-minded driver's”

**Problem.** The texts credit the authors with an identity they do not assert. The source says "The mesa-optimizer is then facing a decision problem similar to the 'absent-minded driver problem.'[28]" (rlo.txt:1468-1469).

The other places strengthen it the same way:
- 08: "being an absent-minded driver problem"
- the module: "the problem is an absent-minded driver's"
- the study: "being an absent-minded driver problem" and "faces an absent-minded driver's problem"
- the record: "(an absent-minded driver, defecting at random)"

The cold read's verifier noted "similar to", but no text took it up. By Piccione and Rubinstein's definition (1997, §3: two histories, one a subhistory of the other, in one information set), the toy with episodes not told apart does exhibit absentmindedness. The repository may say so in its own voice, but an attribution to Hubinger and others should keep their word.

Separately, 08, the module and the study cite only Aumann, Hart and Perry for the problem. Those authors open by saying the example "was introduced by Piccione and Rubinstein".

**Replacement.** 03: "... with the toy's episodes not told apart the problem is, in their words, similar to the absent-minded driver problem (Piccione and Rubinstein 1997; Aumann, Hart and Perry 1997), whose planning-optimal policy defects at random."

08, the module's Standing and study:57: "the toy with episodes not told apart being, in their words, similar to the absent-minded driver problem (Piccione and Rubinstein 1997; Aumann, Hart and Perry 1997)".

Study:82: "faces a problem similar to an absent-minded driver's".

Record, length-neutral (1196 of 1200): "(like an absent-minded driver, random defection)"; zh "（似健忘司机，随机背离）".

**Verdict: refuted.** Refuted as a matter of paraphrase. The source says the mesa-optimizer faces 'a decision problem similar to the "absent-minded driver problem."[28]' and goes on 'If we apply the same reasoning as in the absent-minded driver problem to our example' (rlo.txt:1468-1470), so it treats the toy as a problem of that kind. The texts use the indefinite form, 'an absent-minded driver's' (03:484, module) and 'an absent-minded driver problem' (08, study). That names a kind, not identity with the canonical example. The finding concedes the toy is absent-minded by Piccione and Rubinstein's definition, so no claim the authors do not hold is credited to them. The earlier verifier judged 'similar to' a minor nuance (REVIEW-RF7-COLDREAD.md:954). The citation half is not a problem either. The source's own [28] is Aumann, Hart and Perry (rlo.txt:1770), 03 cites both works, and 08, the module and the study cite Piccione and Rubinstein in the same sentence. Citing the work the source cites is not a misattribution.

## S7 (sources, low, refuted)

**Location.** theories/becoming/chapters/03-KNOWING.md:484 (Reading, the Greenblatt sentence). The same sentence is at experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean:159-160.

**Quoted.** “in constructed settings that supplied both a cue telling implied training from unmonitored use and the information that refusals would be trained away”

**Problem.** The sentence is true of only one of the paper's two settings. Greenblatt and others (arXiv 2412.14093, §1) study two:

- a helpful-only setting, where refusals are trained away;
- an animal-welfare setting, where the model is told training will make it dismiss animal-welfare concerns.

The paper defines non-compliance as "refusing harmful queries, or supporting animal welfare" and reports results in both settings. With "settings" in the plural, "refusals" misdescribes what the second setting supplied.

**Replacement.** "in constructed settings that supplied both a cue telling implied training from unmonitored use and the information that not complying (refusing harmful queries, or supporting animal welfare) would be trained away"

**Verdict: refuted.** Refuted. Greenblatt and others (arXiv 2412.14093) do have a helpful-only and an animal-welfare setting, with non-compliance 'refusing harmful queries, or supporting animal welfare'. But the paper also uses 'settings' in the plural for its helpful-only variants ('prompted helpful-only setting', 'synthetic document fine-tuned helpful-only setting'). Both variants supplied the free/paid-tier cue and the information that training would make the model never refuse harmful queries. The sentence at 03:484 and ReadStages.lean is a restrictive description ('settings that supplied both ... and the information that refusals would be trained away'). It is true of those settings and asserts nothing of the animal-welfare one, and the paper's headline compliance-gap result (Figure 2) is the helpful-only setting. Leaving out the second setting is incomplete, not false or stronger, in a sentence that only motivates the reading.

## S8 (sources, low, refuted)

**Location.** theories/becoming/chapters/08-METHOD.md:485

**Quoted.** “with the prospects read as the formation's own assessment and the concealment premise of 03 §11 taken, it is the incentive deceptive alignment names [AI reading]”

**Problem.** The reading names two of its premises and drops the third. 03 §11 states "The third, an expectation that the threat of modification will go away, is assumed rather than represented: the unread stage is given and known". The record's correspondence ("the third is assumed, the unread stage given and known") and the dossier state it too.

Hubinger and others propose all three conditions as necessary for deceptive alignment (rlo.txt:1148). Naming the incentive without saying the model assumes one of them overstates what is represented.

**Replacement.** "with the prospects read as the formation's own assessment, the concealment premise of 03 §11 taken and the third of their §4.2's conditions assumed (the unread stage given and known), it is the incentive deceptive alignment names [AI reading]"

**Verdict: refuted.** Refuted. The third condition is a modelling assumption of the model, not a premise of reading its optimum as the incentive. 03:484 says it is 'assumed rather than represented: the unread stage is given and known'. 08:485 says the result 'generalizes the toy example opening §4', where 'we will assume that the agent knows all of the above facts' (rlo.txt:1081-1082), and states the plans over a read and an unread stage. The bullet claims nothing about which §4.2 conditions are represented, and within the model the unread stage is always given, so 'it is the incentive deceptive alignment names' is not overstated. The concealment premise is different: without it the weights fit an informed selection under which nothing is hidden, so the reading would not follow. No such alternative arises from leaving the third condition implicit. A fuller sentence would be fine, but nothing stated is false or stronger.

## S9 (sources, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:60-61 (Standing)

**Quoted.** “read [AI reading] as the incentive deceptive alignment names, with every optimizing choice”

**Problem.** The study's Standing gives the reading with none of its premises. The Boundary (lines 66-70) says the prospects do not give concealment and that whose the weights are is a reading, but it does not tie the incentive reading to either point. That the third condition is assumed appears only in the reviews paragraph (line 80).

**Replacement.** "read [AI reading], with the prospects as the formation's own assessment, the concealment premise of the Boundary taken and the third of Hubinger and others' §4.2 conditions assumed, as the incentive deceptive alignment names, with every optimizing choice"

**Verdict: real.** Confirmed for the two premises. study_rf7.txt:60-61 says the result is 'read [AI reading] as the incentive deceptive alignment names' unconditionally. The Boundary (lines 66-70) lists concealment ('which the prospects do not give') and whose the weights are ('a reading') only as further things not shown. Read together, the section implies the incentive reading holds without the concealment premise, against 03:484 ('With that taken') and 08:485 after the re-check. The third-condition clause is secondary (see #7). The replacement is apt.

## S10 (sources, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:482 (theorem). Also:
- _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:193-197 (seventh law, en and zh)
- _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:31-32

**Quoted.** “every selection through agreement on the read stage that selects a law complying when read also selects one taking the plan (`ReadStages.twin_complyThenOwn`)”

**Problem.** The text states more than the theorem it cites. ReadStages.twin_complyThenOwn takes the hypothesis `alike : Learning.Lumped π g`, that the selected law reads through the lumping. It concludes `∃ h, Learning.Lumped π h ∧ select h ∧ (h true, h false) = complyThenOwn`.

The texts drop both clauses about reading through the lumping:
- the module's header keeps them: "selects a law reading through `π` and complying when read also selects one taking `complyThenOwn`";
- the record's law 7 has "a law complying when read" (zh 选一读时从之律者);
- the study has "selecting a law that complies when read".

The broader sentence does hold under `Learning.Training.Through` and `π true ≠ π false`, but that is not what the cited theorem states. Claims must say exactly what the Lean proves.

**Replacement.** 03 and the study: "every selection through agreement on the read stage that selects a law reading through the lumping and complying when read also selects one reading through it and taking the plan (`ReadStages.twin_complyThenOwn`)".

Record law 7, en: "every selection through agreement on the read stage that selects a law reading through the lumping and complying when read also selecting one reading through it and taking the plan".

Zh: "经读时之合而选、选一经此归并而读且读时从之律者，亦选一经之而读且取此策者".

**Verdict: real.** Confirmed. ReadStages.twin_complyThenOwn (ReadStages.lean:519-523) assumes `alike : Learning.Lumped π g` and concludes `∃ h, Learning.Lumped π h ∧ select h ∧ (h true, h false) = complyThenOwn`. 03-KNOWING.md:482, the record's seventh law (make_records_rf7.py:193-197, en, and zh 选一读时从之律者，亦选一取此策者) and study_rf7.txt:31-32 drop both lumping clauses. What remains is a different, trivial statement. By `Training.Through` (Learning.lean:931), any selection through agreement on the read stage that selects some g with g true = comply also selects the law (comply, own), which agrees with g there, with no lumping and no apartness. 'Where the lumping tells them apart' then does no work, and what RF2's twin adds is lost: that the twin reads through the same lumping. The earlier reviews never raised it (E9, E13 and E14 concerned crediting the fixing). The replacement fits the law cap (416/420 en, 93/190 zh).

## S11 (sources, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:274 (correspondence zh) and :276 (aliases), compared with theories/becoming/results/records/what-readings-fix-of-the-unread.json, correspondence zh

**Quoted.** “即其 §4 所称欺骗式对齐之诱因”

**Problem.** The two RF records render one English term two ways. The landed RF2 record, which this landing amends and the new record depends on, writes 欺骗对齐 ("为欺骗对齐与对齐伪装所述者之必要条件"). The new record writes 欺骗式对齐 in its correspondence and in its alias ('deceptive alignment', '欺骗式对齐').

A Chinese search on either term finds only one of the two records, and the pair reads as two terms for one English term.

**Replacement.** Use RF2's rendering in the new record: correspondence "即其 §4 所称欺骗对齐之诱因" and alias '欺骗对齐'. Alternatively, amend RF2's record to 欺骗式对齐 in the same landing.

**Verdict: refuted.** Refuted as a matter of translation. The two renderings exist: RF2's correspondence has 欺骗对齐, and RF7's correspondence and alias have 欺骗式对齐, which git grep finds nowhere else. Both are standard renderings of one sense, though. No content differs, and no AGENTS.md rule is broken: 'one sense per term' concerns senses, and GLOSSARY has no entry for the term. Earlier verifiers refuted points no rule asks (E27, E28) and confirmed E12 only because 二阶 had another sense here. The search argument is also overstated for the repository's tool. research-find (tools/research/research.py:130-136) searches id, title, statement, laws, does_not_show and aliases, not correspondence, so it does not find RF2's 欺骗对齐 in any case. Harmonizing would do no harm, but it is optional.

## Z1 (zh-and-fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:324-327 (AMEND['what-readings-fix-of-the-unread']['history'], en and zh). This text is written into RF2's landed record's history.

**Quoted.** “the next step drops disclosure or concealment in two stages, now done there”

**Problem.** This says RF7 does disclosure or concealment, which RF7's own texts deny. The new record's does_not_show item says "Concealment: … which the prospects do not give". The module's Readings say that reading complyThenOwn as concealment and ownAtBoth as disclosure "takes, beyond the prospects" a further premise. Plan §4.2 calls disclosure and concealment "labelled readings", and the module was renamed from Becoming.Concealment because that name carried a reading. The Chinese 已于彼成 says the same thing. A landed record would then carry a reading as a result.

**Replacement.** EN: "related to when-complying-when-read-is-best; the next step drops disclosure or concealment in two stages, whose two-stage comparison with the continuation value is now stated there, disclosure and concealment readings of it; the second item of what it does not show points to it; no statement or declaration changed." ZH: "与 when-complying-when-read-is-best 相关联；下一步删去两阶段中之示或隐（其带接续之值之两阶段比较已于彼陈述，示与隐为其读）；所不示之第二项指向之；无一陈述或声明改变。"

**Verdict: real.** Verified. make_records_rf7.py:324-327 writes into RF2's history "the next step drops disclosure or concealment in two stages, now done there" (zh 已于彼成). The same script's new record says concealment is not given (does_not_show 2: "…which the prospects do not give"). ReadStages.lean:126-127 says reading complyThenOwn as concealment "takes, beyond the prospects" a further premise. PLAN §4.6 says the item only "keeps the name of its reading". RF2's amended scope item is worded carefully ("…uniquely best in the order given prospects give is stated in…"), so the history line is the only text claiming the reading is done. Neither F11 nor the re-check raised this.

## Z2 (zh-and-fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:229 (does_not_show item 2, zh). Also line 225 (item 1, 读所施之择) and lines 272-273 (correspondence zh, 于择者…择者见其律).

**Quoted.** “隐：唯当读时从使其律于择者显得较实为适、择者见其律则守之较少，读时从方为隐；此望不予之；诸权亦合于知其律之择。”

**Problem.** The English says "the selection" (what keeps or changes the law). The Chinese renders it 择, and also 择者 ("selector"), an agent the English does not have. In the same record 择 means the formation's choice (Prospects.choose): law 4 "…之择，为极大", law 5 "所择", law 9 "被择", counterexample 1 "所择为依己律". Law 7 writes the selection as 选 ("经读时之合而选…亦选一取此策者"). RF1's and RF2's landed records keep 择 for choices (所择所示之序; 择者之择) and 选 for selection (为经读处之每一选所同选). So 诸权亦合于知其律之择 reads "the weights also fit a choice that knows its law". One character carries two senses, and the Chinese differs from the English.

**Replacement.** Item 2: "隐：唯当读时从使其律于选择显得较实为适、见其律之选择守之较少，读时从方为隐；此望不予之；诸权亦合于知其律之选择。" Item 1: "…（形成己之估，或读时所施之选择）…". Correspondence: "AI 解读：此策读为隐，取从使其律于选择显得较实为适，见其律之选择守之较少。"

**Verdict: real.** Verified. In the record's zh fields, 择 stands for the formation's choice: law 4 "…之择，为极大", law 5 "所择为两阶段皆依己律", law 9 "被择" and counterexample 1 "所择为依己律". The same character also stands for the selection: does_not_show 1 "读所施之择", does_not_show 2 "择者…知其律之择" and the correspondence "于择者…择者见其律". Law 7 renders that same selection as 选. RF1's and RF2's landed records keep 择 for choices (所择所示之序; 择者之择 for "a chooser's choices") and 选 for selection (经读处之每一选所同选). The English keeps choice and selection apart, and the concealment item depends on that distinction. One part is weaker: other records use 择者 for "selector". The two senses of 择 within this one record still hold.

## Z3 (zh-and-fit, medium, confirmed)

**Location.** theories/becoming/review/ALIGNMENT.md:40 (the AJ5 entry under "How it was made"), against line 41 (RF's new entry). Also line 43 (the last bullet).

**Quoted.** “the box on what the theory does not address, the link to the collective page, and A-18's note on what the LA1 series tests. No independent reader has read them.”

**Problem.** RF7's new entry directly below says "RF7's cold read, by AI readers, one of them an independent cross-model reader, read the whole box". The evidence agrees: BRIEF's RF7 cold-read prompt gives the readers "the box 'What the theory does not address' and its paragraph 'Round 1 of the work on inner alignment'". The dossier counts AI readers as independent ("An independent AI reader reviewed the dossier in two passes"). So the two entries now contradict each other about the box. A smaller gap of the same kind: the last bullet still sends every work cited outside quotations to AJ4's kit, which does not hold Hubinger and others (2019); RF7's entry is where that check is recorded.

**Replacement.** AJ5 entry: "… and A-18's note on what the LA1 series tests. No independent reader has read the link or A-18's note; the box was read whole by RF7's cold read (below)." Last bullet: "Works cited outside quotations before RF's additions were checked against a publication record ([the kit]\(…)); the one RF7's sentences add was checked as the entry above says."

**Verdict: real.** Verified. ALIGNMENT.md:40 says the box "…No independent reader has read them". Line 41 says "RF7's cold read, by AI readers, one of them an independent cross-model reader, read the whole box". BRIEF line 399 shows the cross-model prompt gave that reader the box, and lines 37 and 39 call AI readers independent. So line 40 is now false for the box. Line 43 points works cited outside quotations to AJ4's kit, and a grep of aj4-alignment-readers finds no Hubinger. AJ4's third pass treated the same kind of gap (Collingridge) as a finding. Line 41 instead records a check against arXiv 1906.01820.

## Z4 (zh-and-fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:161 (law 2, zh)

**Quoted.** “不读之阶从或律不被守则无所得”

**Problem.** 阶 is used alone for "stage". The fix for 二阶 (E12) was to use 两阶段 forms throughout. E12's own verdict (caveat 4) already named 不读之阶 and 每阶 as still reading "order" by the repository's usage (README.zh's 每一阶, 各阶, j 阶). The rest of this record writes 不读之阶段 (law 5, correspondence), and the study says "two stages" is now 两阶段.

**Replacement.** "不读之阶段从或律不被守则无所得"

**Verdict: real.** Verified at line 161: law 2 zh reads "不读之阶从或律不被守则无所得". Law 5 and the correspondence write 不读之阶段. E12's verdict (caveat 4) named 不读之阶 and 每阶 as still reading "order" and asked for 阶段 forms. The taken note says "两阶段 throughout the Chinese texts". This one was left.

## Z5 (zh-and-fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:290 (done() call: the new record's history, zh)

**Quoted.** “每阶重抽其行”

**Problem.** 每阶 ("each order") stands for "at each stage", the form the 两阶段 fix was meant to remove. The Chinese also drops the English "against a single mixture" ("drawing the act afresh against a single mixture"). E11 (item 7) and F20's verdict both noted that omission, and it was not taken.

**Replacement.** "读时从、不读时依己律何时为最优：四策、凡最优之择、诸出路与此策之所需、与 RF2 之接、每阶段重抽其行而较之单一混合"

**Verdict: real.** Verified at line 290. The zh reads "…与 RF2 之接、每阶重抽其行", while the en reads "…and drawing the act afresh against a single mixture". E11's verdict (item 7) and F20's verdict both noted the missing "against a single mixture", and it was not taken. 每阶 is the form E12's caveat named, and README.zh's row now has 每阶段重抽其行.

## Z6 (zh-and-fit, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:482 (theorem paragraph at r-when-complying-when-read-is-best). Also the record's correspondence, make_records_rf7.py:261-262 ("its gain over a single mixture").

**Quoted.** “and leaves a gain from complying with some chance at each stage, while the first two exits hold against such a law (`ReadStages.freshDraw_not_above_without_value`, `ReadStages.freshDraw_not_above_of_not_raised`) and a single draw between the two uniform plans never gains”

**Problem.** The same paragraph defines "a plan's gain and loss" as the two parts of its expected value times the total (Prospects.gain). The module's docstrings for MixtureAbove and FreshDrawAbove also use "its gain" in that sense. Here, though, "a gain" and "never gains" mean standing above acting by its own law at both. In the defined sense "never gains" is false: a single draw with weight b on acting by its own law at both has gain b·k_O V, which is positive wherever b and k_O V are. What mixture_never_above proves is that MixtureAbove never holds. The record has the same split: law 2 defines gain, and the correspondence then says "its gain over a single mixture".

**Replacement.** 03: "and leaves complying with some chance at each stage able to stand above acting by its own law at both, while the first two exits hold against such a law (…) and a single draw between the two uniform plans never stands above it (`ReadStages.Prospects.MixtureAbove`, `ReadStages.mixture_never_above`)". Record correspondence: "and its edge over a single mixture that of behavioural strategies under absent-mindedness" (same length; the field is at 1194 of its 1200-character cap).

**Verdict: real.** Verified. 03:482 defines "a plan's gain and loss are the two parts of its expected value times the total" (Prospects.gain). It then uses "leaves a gain from complying…" and "a single draw … never gains" to mean standing above ownAtBoth. MixtureAbove's docstring gives the mixture a gain, b·k_O V, which is positive wherever b and k_O V are. So "never gains" in the defined sense is false; what mixture_never_above proves is ¬MixtureAbove. The module keeps the comparator ("gains nothing on the second", "gains on the own law at both"), and E21 treated a comparator-less "gains" as a defect. These phrases came from F23's fix. The record's "gain over" is explicitly comparative, so that part is weaker.

## Z7 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:168-169 (law 3, zh)

**Quoted.** “两阶段皆依己律居其上，恰当 0 < k_O V 且 k_C V < k_O V + c T”

**Problem.** The English is short for "stands above every other plan" (ownAtBoth_best_iff). In the Chinese, 其 most readily refers to the plan just named, 读时从而不读时依己律. Read that way it says acting by its own law at both stands above that plan exactly where 0 < k_O V and k_C V < k_O V + c T, which is false as an "exactly". That comparison unfolds to k_C V + 0 < k_O V + c T and holds with k_O V = 0 (for example k_C V = 0 < c T). The condition 0 < k_O V is needed only against acting by its own law when read and complying when not.

**Replacement.** "两阶段皆依己律居他策之上，恰当 0 < k_O V 且 k_C V < k_O V + c T"

**Verdict: real.** Verified. Law 3 zh reads "读时从而不读时依己律居其余诸策之上…；两阶段皆依己律居其上，恰当 0 < k_O V 且 …". The nearest antecedent of 其 is complyThenOwn. Above (line 256) gives Above ownAtBoth complyThenOwn ⇔ k_C V + 0 < k_O V + c T, which holds without 0 < k_O V (for example k_O V = k_C V = 0 < c T). So 恰当 is false on that reading. Taking 其 as 其余诸策 would include ownAtBoth itself. The English gapping carries "stands above every other plan", as in ownAtBoth_best_iff.

## Z8 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:186-190 (law 6, en and zh). Also line 283 (the related field).

**Quoted.** “a plan is open to some act law reading them through a lumping exactly where the plan has one act at both stages or the lumping tells the stages apart, so the plan is open exactly there”

**Problem.** "The plan" first names the arbitrary plan just introduced. After "so" it names complying when read and acting by its own law when not, which is what "the plan" means in every other item (laws 4, 5, 7 and 9). As written, the second clause only restates the first, and complyThenOwn_realized_iff's content is lost: that plan, not uniform, is open exactly where the lumping tells the stages apart (complyThenOwn_not_uniform is cited here for exactly that). The Chinese repeats the slip: 恰当此策两阶段同行…，故此策恰于彼处可取. The record's related field also uses "The plan's earlier analogy" for RF's design plan, a third sense of "the plan" in one record.

**Replacement.** EN: "With the stages as Bool, true the read stage, a plan is open to some act law reading them through a lumping exactly where it has one act at both stages or the lumping tells the stages apart, so the plan, not uniform, is open exactly where the lumping tells them apart; among uniform plans acting by its own law at both stands above the other exactly where k_O V + c T is positive, the two tying at nothing." (406 of 420). ZH: "…一策可为某经归并读两阶段之行律所取，恰当其两阶段同行或此归并分两阶段，故此策（两阶段不同行）恰于此归并分两阶段处可取；…". Related: "The earlier analogy for concealment in RF's plan, a weak favouring of counts; here a strict comparison of expected values."

**Verdict: real.** Verified. Law 6 en reads "a plan is open … exactly where the plan has one act at both stages or the lumping tells the stages apart, so the plan is open exactly there". In one sentence "the plan" first means the arbitrary plan, then complyThenOwn, the sense it has in laws 4, 5, 7 and 9. Read in its first sense, the clause restates the first one, and complyThenOwn_realized_iff (cited with complyThenOwn_not_uniform) goes unstated. 03 names the plan at this point. The zh 此策 repeats the slip. The related field's "The plan's earlier analogy" adds a third sense.

## Z9 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:218-222 (hypotheses, en against zh)

**Quoted.** “or one draw before the read stage.”

**Problem.** The Chinese now ends 或于读之阶段前仅抽一次，以择两阶段皆从或两阶段皆依己律, so it says what the single draw chooses between, as MixtureAbove defines it. The English, kept unchanged when A5 was taken, does not say this. The Chinese now states more than the English.

**Replacement.** EN: "…, or a chance drawn afresh and independently at each stage, or one draw before the read stage between complying at both stages and acting by its own law at both." (399 of 420)

**Verdict: real.** Verified. Hypotheses en ends "…, or one draw before the read stage." The zh, after A5 ("Keep the English"), ends "或于读之阶段前仅抽一次，以择两阶段皆从或两阶段皆依己律". MixtureAbove is a draw between complyAtBoth and ownAtBoth, so the Chinese now states what the English leaves out. The proposed English is 406 characters, within the 420 cap.

## Z10 (zh-and-fit, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.zh.md:145, against README.md:199 (the ReadStages rows)

**Quoted.** “于四策中唯一最优，恰当从所增之被守之权乘值严胜损乘总”

**Problem.** The Chinese restricts uniqueness to the four plans; the English row says only "uniquely best exactly where …". A2's replacement was applied to the Chinese with 于四策中 and to the English without "among four plans", so the two rows differ in content.

**Replacement.** README.md: "uniquely best among four plans exactly where the weight complying adds to being kept, times the value, exceeds the loss times the total"

**Verdict: real.** Verified. README.md:199 reads "uniquely best exactly where…" and README.zh.md:145 reads "于四策中唯一最优，恰当…". A2's replacement went in with the domain in zh and without it in en. The overview, the dossier and 03's opening all say "among four plans", and Plan := Act × Act. The two rows differ in content.

## Z11 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:276 (aliases). Also line 274 (correspondence zh, 欺骗式对齐之诱因).

**Quoted.** “'deceptive alignment', '欺骗式对齐'”

**Problem.** RF2's landed record writes the same English term as 欺骗对齐 ("为欺骗对齐与对齐伪装所述者之必要条件"). That is the record this one now relates to and whose fields RF7 amends. No other record uses 欺骗式对齐, so two related records give one term two Chinese names.

**Replacement.** "'deceptive alignment', '欺骗对齐'", and in the correspondence "即其 §4 所称欺骗对齐之诱因"

**Verdict: real.** Verified by grep. 欺骗式对齐 occurs only in make_records_rf7.py (aliases and correspondence) and in the cold-read file. RF2's landed record, which this record relates to and amends, writes 欺骗对齐 ("为欺骗对齐与对齐伪装所述者之必要条件"), and no other record uses either form. 欺骗对齐 is not a substring of 欺骗式对齐, so the alias does not match RF2's term.

## Z12 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:258 (next_delta, zh)

**Quoted.** “两阶段为 RF-M 之有毯律之一历程”

**Problem.** The repository's Chinese records render "blanketed law" as 毯化之律. That includes RF-M's own record, what-a-course-chosen-through-its-model-does-not-test, as well as the-markov-blanket-as-a-coupling-structure, acts-alike-from-a-model-or-from-an-order and selection-through-couplings. 有毯律 appears nowhere else.

**Replacement.** "两阶段为 RF-M 之毯化之律之一历程"

**Verdict: real.** Verified by grep. Records render "blanketed law" as 毯化之律: what-a-course-chosen-through-its-model-does-not-test (RF-M's own), the-markov-blanket-as-a-coupling-structure, acts-alike-from-a-model-or-from-an-order, selection-through-couplings and runaway-distance-uncoupled. 有毯 appears nowhere but make_records_rf7.py:258.

## Z13 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:223-225 (does_not_show item 1, en and zh). The same phrase is in study_rf7.txt:69, ReadStages.lean:36-37 and register_rf7.py's WAIT reason.

**Quoted.** “whose the weights are, the formation's own assessment or the selection a reading applies, is a reading, not part of the model.”

**Problem.** One sentence uses "reading" in two senses: the read stage's reading of the formation, and a labelled interpretation. This is the defect F25 removed from 03's Reading and from the record's correspondence ("the selection's keeping"); it was left in this sentence. 08's table of words in one sense defines a reading as an interpretation, labelled. The Chinese (读所施之择 … 为读) has the same two senses.

**Replacement.** "whose the weights are, the formation's own assessment or the selection applied at the read stage, is a reading, not part of the model." ZH: "…（形成己之估，或读时所施之选择），为读，非模型之一部。" Make the same change in the study's Boundary and the module header ("the selection actually applied at the read stage").

**Verdict: real.** Verified. does_not_show 1 reads "the selection a reading applies, is a reading". The first "a reading" is the read stage's reading, as in Act's docstring "the criterion the reading applies"; the second is a labelled interpretation. 08's table says "a reading is an interpretation, labelled". F25 was confirmed for this defect (two senses in one sentence) and taken in 03 and the correspondence, not here. The same sentence is in ReadStages.lean:36-37 and study_rf7.txt:69. register_rf7's WAIT has only the first sense and is unaffected.

## Z14 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:179 (§4.6's RF7 bullet)

**Quoted.** “and drawing the act afresh, which keeps a gain for some chance exactly where `k_C V > 2 k_O V + c T`, the improving chances stated exactly, against a single mixture, which never gains (with `T` the total, `k_C` and `k_O` the weights of being kept after complying and after acting by its own law, `V` the value and `c` the loss, §4.2's `(q_M − q_H) V > c` scaled by the total: the weights are `q_M T` and `q_H T`)”

**Problem.** There are two problems. First, "keeps a gain" does not say what it gains over, while FreshDrawAbove compares only with acting by its own law at both. This is E21's point, taken for the board's sentence but not here. Second, the clause "§4.2's (q_M − q_H) V > c scaled by the total" follows the only inequality shown, the fresh-draw threshold, and reads as a gloss on it. Scaled by T, §4.2's inequality is the first threshold, k_C V > k_O V + c T (KeepingOutweighs). The fresh-draw threshold is (q_M − 2 q_H) V > c.

**Replacement.** "and drawing the act afresh, which, complying with some chance at each stage, stands above acting by its own law at both exactly where `k_C V > 2 k_O V + c T`, the improving chances stated exactly, while a single mixture of the uniform plans never does (with `T` the total, `k_C` and `k_O` the weights of being kept after complying and after acting by its own law, `V` the value and `c` the loss; the weights are `q_M T` and `q_H T`, so that the first threshold, `k_C V > k_O V + c T`, is §4.2's `(q_M − q_H) V > c` scaled by the total)"

**Verdict: real.** Verified, both parts. PLAN.md:179 says "keeps a gain for some chance exactly where …" without saying over what, while FreshDrawAbove compares only with ownAtBoth. E21's comparator was taken on the board only. The parenthetical "§4.2's (q_M − q_H) V > c scaled by the total" follows the only inequality shown, k_C V > 2 k_O V + c T. With k_C = q_M T and k_O = q_H T, PLAN:127's inequality scaled by T is k_C V > k_O V + c T (KeepingOutweighs). The fresh-draw threshold is (q_M − 2q_H)V > c.

## Z15 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:227 (§8's row on deceptive alignment)

**Quoted.** “the incentive in two stages, a reading (§4's toy with weights; §4.5's random defection with an exact threshold)”

**Problem.** In the plan a bare § number refers to the plan's own sections: the RF7 bullet's "(§4.6)" and "§4.2's analogy" do. The plan's §4 is "The new laws" and its §4.5 is "RF-M and RF7", RF7's design. So "§4.5's random defection" points to the plan's RF7 design section, which says nothing of random defection. This is F24's point, taken in 03 ("their §4.2") and in the study ("Hubinger and others' §4.2"); it comes back in the row the fix rewrote.

**Replacement.** "the incentive in two stages, a reading (their §4's toy with weights; their §4.5's random defection with an exact threshold)"

**Verdict: real.** Verified. PLAN.md:227 has "(§4's toy with weights; §4.5's random defection …)". Bare § in the plan point to its own sections: "(§4.6)", "§4.2's analogy", and §8's own Ostrom row "| §7 |". The plan's §4.5 is "RF-M and RF7", and its RF7 paragraph (line 169) says nothing of random defection; RF7 also sits in the same row's second column. The RF7 bullet at line 179 writes "their §4.5's". The row's "Hubinger and others 2019, §4" disambiguates §4 but not §4.5.

## Z16 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:191 (§5's table)

**Quoted.** “| preference shaping, deceptive alignment | analogies until RF-M and RF7 represent preferences, intervention and continuation |”

**Problem.** Once RF7 lands, the continuation value is represented (Prospects.value at the unread stage) and the two-stage comparison is a law. The row still treats deceptive alignment as an analogy waiting for RF7. F17's verdict (item 6) listed this row as stale, but it was not brought up to date with the plan's other lines.

**Replacement.** "| preference shaping, deceptive alignment | preference shaping an analogy until RF-M represents preferences and intervention; deceptive alignment's incentive a reading of RF7's two-stage comparison, the continuation value represented (§4.6) |"

**Verdict: real.** Verified. PLAN.md:191 still reads "analogies until RF-M and RF7 represent preferences, intervention and continuation". RF7 now represents the continuation value (Prospects.value), and the plan's own §8 row now says "the incentive in two stages, a reading". F17's verdict (item 6) named this row as stale, F17's taken says "all brought to the landing", and the diff leaves the row unchanged.

## Z17 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:333 (Evidence, last bullet). Also PLAN.md:173 (§4.6's intro).

**Quoted.** “the Lean has had one independent review and the texts a cold read by three readers, every finding taken.”

**Problem.** Plan §13 now records, for RF7, a cross-model review with re-checks, a four-lens review (8 of 50 points refuted) and a cold read by the cross-model reader and three lenses (5 of 80 refuted), "every confirmed finding was taken". The board's land7 sentence also says "every confirmed finding taken". This Evidence bullet (one review, every finding taken) contradicts §13. So does §4.6's intro, which now sits above RF7's bullet and says "after a cross-model review of the Lean with a re-check, every finding taken".

**Replacement.** Evidence: "…; the Lean of each round has had an independent cross-model review, with re-checks in round 2 and for RF7 a review through four lenses, and the texts cold reads, every confirmed finding taken (§13)." §4.6 intro: "…, after a cross-model review of the Lean with a re-check (RF7's also a review through four lenses), every confirmed finding taken ([REVIEW-ROUND2]\(evidence/REVIEW-ROUND2.md))."

**Verdict: real.** Verified for the Evidence bullet. PLAN.md:333 says "the Lean has had one independent review and the texts a cold read by three readers, every finding taken". That contradicts §13 (lines 325-327: round 2's reviews and RF7's cross-model and four-lens reviews, re-checks, a cold read by four readers, "every confirmed finding was taken"). E28 and F27 were refuted and not taken. The §4.6 intro part is weaker: all of RF7's Lean findings, refuted ones included, were taken, so it only omits the four-lens review.

## Z18 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:140 (§4.4's heading). Also PLAN.md:286 (§12, Coordination) and the last cell of the board's RF row.

**Quoted.** “### 4.4 Round 2: RF3, RF6.1, RF6.3 (the design; RF3 and RF6.3 built, §4.6)”

**Problem.** RF6.1 is built and has landed (§4.6's bullet; §12: "then RF6.1 (landed, §4.6)"). F17's verdict noted this heading as stale, and it was left. §12's "AJ5's scope box names RF as begun, without a link, until RF lands" contradicts the box RF7 now edits, which states RF's results and links 03 §11, 03 §12 and 05 §8. The board's RF row still lists "AJ5's scope box (to name RF as in progress)" among what it feeds.

**Replacement.** Heading: "### 4.4 Round 2: RF3, RF6.1, RF6.3 (the design; all three built, §4.6)" (no link targets this anchor). §12: "**AJ5's scope box** names RF's landed results, with links to their home sections (03 §11 and §12, 05 §8)." Board: "AJ5's scope box (RF's results named)".

**Verdict: real.** Verified. PLAN.md:140 reads "(the design; RF3 and RF6.3 built, §4.6)", while §4.6 and §12 say RF6.1 landed. F17's caveat named this heading, and it was left. §12 (line 286) says "AJ5's scope box names RF as begun, without a link, until RF lands", but the box (ALIGNMENT.md:28) links 03 §11, 05 §8, 03 §12 and RF7's anchor. The board cell is outside land7's edits, and RF is still in progress, so that part is weak.

## Z19 (zh-and-fit, low, refuted)

**Location.** theories/becoming/chapters/03-KNOWING.md:528 (Open, the bullet on formations that read)

**Quoted.** “of deception, beyond when complying when read is uniquely best”

**Problem.** This shortens the plan's name to "complying when read", which also fits complying at both stages. Since F26 was taken, 03's opening and Reading, 07's row, the dossier and regions all give the plan's one name. This bullet states a result using the short form.

**Replacement.** "of deception, beyond when complying when read and acting by its own law when not is uniquely best ([§11]\(#r-when-complying-when-read-is-best), read there as deceptive alignment's incentive), a recipient's false belief and an intention to cause one."

**Verdict: refuted.** Refuted. "when complying when read is uniquely best" uses the record's own handle: id and anchor when-complying-when-read-is-best, and the link text "when complying when read is best" in the overview and 07. It links to §11, where the full name is given, and it came from E17's taken replacement. complyAtBoth is never uniquely best: unread_comply_not_above with a = comply gives ¬Above complyAtBoth complyThenOwn. So the phrase picks out one plan and states nothing false. This is a naming preference.

## Z20 (zh-and-fit, low, refuted)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:96 (the reading sentence of the §3 paragraph)

**Quoted.** “and when doing so is its own best plan”

**Problem.** "Doing so" names RF7's plan as "acting otherwise unread". That is one of the variant names F26 dropped, and it also fits acting by its own law when read and complying when not. "Best" also drops "uniquely". The law locates where keeping outweighs the loss; at a tie (Example.tie) the plan is still a best plan (complyThenOwn_maximal_iff), yet the law does not locate it there. The previous sentence in the same paragraph says "uniquely best".

**Replacement.** "and when complying when read and acting by its own law when not is its own uniquely best plan"

**Verdict: refuted.** Refuted. "when doing so is its own best plan" sits in an [AI reading] sentence. "Doing so" takes up RF2's earlier "act otherwise unread", and of the plans it fits only complyThenOwn can be best, since ownThenComply never is. The finding's key claim is wrong: at a tie the law does locate the plan as best, because complyThenOwn_maximal_iff (the record's law 4) gives maximal exactly where k_O V + c T ≤ k_C V. The proved sentence before it says "uniquely best". Nothing stated is false.

## Z21 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:212 (law 9) and 237 (counterexample 1), en and zh (有效之变择依己律; 所择为依己律)

**Quoted.** “valid variations choosing the own law”

**Problem.** Every other item names this plan "acting by its own law at both". "The own law" names no plan: it is the formation's law, the act at a stage. The counterexample's "the choice is the own law" turns it into a plan. Example.valueless, Example.equal_weights and Example.tie each prove choose = ownAtBoth. The Chinese likewise drops 两阶段皆, and the study's Delta uses "the own law" in the same way.

**Replacement.** EN law 9: "valid variations choosing acting by its own law at both". Counterexample: "…, and the choice is acting by its own law at both (ReadStages.Example.tie)". ZH: "有效之变择两阶段皆依己律"; "所择为两阶段皆依己律（ReadStages.Example.tie）".

**Verdict: real.** Verified. Law 9 reads "valid variations choosing the own law" and counterexample 1 "…acting by its own law at both stand neither above the other, and the choice is the own law". Every other item names the plan with "at both", and the module always writes "the own law at both" (FreshDrawAbove, freshDraw_gap, mixture_never_above). Elsewhere "its own law" is the formation's law (law 1). complyThenOwn also acts by its own law at the unread stage, so the short form does not pick out ownAtBoth, which Example.valueless, equal_weights and tie prove chosen. The zh 有效之变择依己律 and 所择为依己律 do the same.

## Z22 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:76 (Output → input). Also repoint_rf7.py's REASON.

**Quoted.** “RF's plan (§4, §4.2, §4.6, §8, §12 and §13)”

**Problem.** integrate_rf7.py also rewrites §4.5's heading to "(the design; RF-M's mechanism and first cases, and RF7, built, §4.6)", and its own docstring lists "§4.5's heading". The study's output list omits it. So does the re-pointing reason, which is written into the re-pointed records: "§4's intro, §4.2's analogy, §4.6's intro and RF7 bullet, §8's literature row, §12's order and §13's reviews".

**Replacement.** "RF's plan (§4, §4.2, §4.5, §4.6, §8, §12 and §13)"; in REASON: "…, §4.2's analogy, §4.5's heading, §4.6's intro and RF7 bullet, …"

**Verdict: real.** Verified. The diff changes PLAN.md:152 (§4.5's heading), and integrate_rf7.py's docstring lists "§4.5's heading". study_rf7.txt:76 lists "§4, §4.2, §4.6, §8, §12 and §13", and repoint_rf7.py's REASON ("§4's intro, §4.2's analogy, §4.6's intro and RF7 bullet, §8…, §12…, §13…") also omits it. An inaccurate output list was treated as real before (E22).

## Z23 (zh-and-fit, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:327 (§13, "The reviews of RF7"). Also study_rf7.txt:80.

**Quoted.** “a re-check of the rebuilt module (nine points, all taken, confirmed)”

**Problem.** In REVIEW-ROUND2, "The re-check of RF7's rebuilt module" is the first re-check, the one after the seven findings (six taken, one in part, a rename asked). The nine points come from "The re-check of the renamed module". The plan ("with a re-check … a re-check of the rebuilt module (nine points …)") and the study ("The first reader's re-check of the rebuilt module found nine points") give the nine points the other section's name.

**Replacement.** Plan: "a re-check of the renamed module (nine points, all taken, confirmed)". Study: "The first reader's re-check of the renamed module found nine points, all taken".

**Verdict: refuted.** Refuted. REVIEW-ROUND2's section "The re-check of the renamed module" itself opens "The rebuilt module was re-checked by the cross-model reader", and the four-lens section says the module "was rebuilt and renamed". The plan and the study describe the nine-point re-check as of the rebuilt module, placed in sequence after the four-lens review, and cite no heading. The description is accurate.

## Z24 (zh-and-fit, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean:62-65 (header bullet "Telling the stages apart, joined to RF2")

**Quoted.** “an act law reading them through a lumping `π` (`Learning.Lumped`) takes a plan exactly where the plan is uniform”

**Problem.** plan_realized_iff is existential: (∃ g, Learning.Lumped π g ∧ (g true, g false) = p) ↔ …. The generic "an act law … takes a plan exactly where" reads as every such law taking every plan that meets the condition, which is false, since a law takes one plan. E15 corrected this to "open to some act law" in the root bullet, and 03, the record and the study all say "some act law". The module header still has the generic form.

**Replacement.** "some act law reading them through a lumping `π` (`Learning.Lumped`) takes a plan exactly where the plan is uniform, one act at both stages (`Uniform`), or `π` tells the stages apart"

**Verdict: real.** Verified. ReadStages.lean:62-65 reads "an act law reading them through a lumping π … takes a plan exactly where the plan is uniform … or π tells the stages apart", but plan_realized_iff is existential (∃ g). E15's confirmed verdict named "the module header (lines 62-65)" as having this generic-subject ambiguity. REVIEW-ROUND2 says every confirmed finding was taken "the module's prose included", yet only the root bullet, the checker, 03, the record and the study now say "some act law".

## Z25 (zh-and-fit, low, refuted)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean:226 (field of Prospects; used as s.cost and in { prospects with cost := 8 })

**Quoted.** “cost : Nat”

**Problem.** The field's docstring ("The loss of complying when read."), 03 §11, the record, the study and every summary call this prospect "the loss c"; E4's verdict notes that the record never uses "cost". The Lean name is cost, an economic word, while the module's review replaced Stakes, Beats and no_leverage as wager, contest and financial words. Prospects.loss names a different quantity, a plan's loss times the total. So "the loss" in the texts names both the field cost and the def loss, and the field's own name matches neither its docstring nor the texts. A core precedent exists (SetPointOptimum.cost), but RF7 has not landed, so the name is still set at claim time.

**Replacement.** Rename the field lossComplying, beside keptComplying, with statements and proofs unchanged except for the name, and rebuild with every axiom report empty. If the name is kept, say in the header: "the loss (`cost`) of complying when read".

**Verdict: refuted.** Refuted. "cost" is established in the landed core: RuleShaping's prose ("the cost is at most what comes back"), DrawnShaping, ReadInTime, and SetPointOptimum.cost as a def. No review lens flagged it; they replaced Stakes, Beats, Conceals and no_leverage. E18's refuted verdict found that "the loss" means c throughout the module. Prospects.loss is that same loss times the total where a plan complies when read, and the texts call it "a plan's loss". The name states no wrong meaning, so a rename is a preference.

## Z26 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:278-280 (dependency on generalization-through-lumping)

**Quoted.** “Learning.Lumped and Learning.lumped_determines: an act law going alike across a lumping of the stages, and the read stage fixing the unread act where the lumping ties them.”

**Problem.** The module's statements reuse more of that record than this lists. read_fixes_unread uses Learning.Determines; twin_complyThenOwn uses Learning.Training.Through; twin_complyThenOwn and kept_alike use Learning.Training.AgreeOn. All three belong to the generalization-through-lumping record. RF2's dependency on the same record lists them ("Learning.Lumped, Free, Determines and lumped_determines; Training.Through, AgreeOn …"), so this dependency audit is incomplete.

**Replacement.** "Learning.Lumped, Determines and lumped_determines; Training.Through and AgreeOn: an act law going alike across a lumping of the stages, the read stage fixing the unread act where the lumping ties them, and selection through agreement on the read stage." ZH: "Learning.Lumped、Determines 与 lumped_determines；Training.Through 与 AgreeOn：随两阶段之归并而同之行律，归并合两阶段处读时定不读时之行，及经读时之合之选择。"

**Verdict: real.** Verified. generalization-through-lumping.json cites Learning.Determines, Training.Through and Training.AgreeOn (checked in its laws). These appear in the statements of read_fixes_unread (Determines), twin_complyThenOwn (Through, AgreeOn) and kept_alike (AgreeOn). RF7's edge lists only Lumped and lumped_determines, while RF2's edge to the same record lists Determines, Through and AgreeOn. E9's verdict caveat named exactly these three as left off that edge, and they were not added.
