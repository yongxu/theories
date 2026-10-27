# UE13 re-check: causal sets, and what can be born next against what continues

28 October 2026. An independent, adversarial re-check, AI-written, of board item UE13 after the fix round that followed the [review](REVIEW-UE13.md). It reads the module `Becoming.CausalGrowth` ([tree/Becoming/CausalGrowth.lean](tree/Becoming/CausalGrowth.lean), sha256 `0addcdfd…`) and its [note](NOTE.md), including law 8 (`Kinds.*`), which the review did not read. They were read against the review's findings F1–F22, UE10's `ReachableRanges.lean`, UE11's `HeldPossible.lean`, 01 §1 and §6, 07 §2, §4 and §8, and the landing kit in `kit/`. The probes are in [probes2/tree/Becoming/CausalGrowthRecheck.lean](probes2/tree/Becoming/CausalGrowthRecheck.lean), which imports a byte-identical copy of the module: 60 theorems in 77 declarations, every axiom report empty, no warning ([probes2/build-3.log](probes2/build-3.log)). The count was rerun and recounted independently. Line numbers are those of the files as read; the module and the note are unchanged since the audit in [scratch-4.log](scratch-4.log).

## Verdict

The Lean is sound. The module (107 theorems in 145 declarations, every axiom report empty) proves what its theorem statements say. The laws moved in from the review's probes keep the probes' statements. F1–F5, F9, F12–F16 and F18–F22 are taken, with one sentence each left from F2 and F4 (R10, R13). F6, F7, F8, F10, F11 and F17 are taken only in part or at the wrong level (R1–R5, R7, R11). Law 8 is right in substance, and the count is right: rerun byte for byte and recounted by an independent method.

Six findings are for before landing:
- **R1.** The two calibrations are excluded middle, not De Morgan's law. For every pair of courses from the empty set, each converse is equivalent to excluded middle (probes `pair_converse_iff_em`, `stems_converse_iff_em`). The module proves only that each implies De Morgan's law, and its texts say "is".
- **R2.** F8 again. Fourteen docstrings, the header's law-5 bullet and seven places in the note drop the courses' start. The probes show thirteen of those laws, and `antichain_unbeaten` as the header states it, false without the start.
- **R3.** The reading leaves C a choice the condition's scope has already made. With every continuation's losses counted, the reading is on both together, and there C ranks no two courses; a ranking needs a measure.
- **R4.** "Holds on no configuration, so the 生生 meant is D1" does not follow: law 6 has the grammar's «生生» on the chain's limit. Two conclusions also leave out the further premise §4 states.
- **R5.** F6's slogan returns, in law 8 and, through the kit, in a record and in 07's reading.
- **R6.** `antichain_unbeaten` is a contest name; rename it before landing.

R7–R14 are small. The kit carries R1–R6, and wording the review had already corrected (F7–F9), into records and live text ([Propagation](#propagation-to-the-landing-kit)).

**Recommendation:** land after R1–R6 are taken in the module, the note and the kit.

## Findings

Severity: **before landing** or **small**. "The re-check's" names a probe in `probes2/`. Each fix gives the replacement text where prose is at fault.

**R1 (before landing). The two calibrations are excluded middle, not De Morgan's law.**
CausalGrowth.lean:42–43 (header), :864–866 (`deMorgan_of_pair_converse`), :914 (`deMorgan_of_stems_converse`); NOTE.md:44, :58, :120, :134.

The module proves that each converse implies De Morgan's law `¬ (A ∧ B) → ¬ A ∨ ¬ B`, for every pair of courses from the empty set; that law is weak excluded middle. The texts say each converse *is* De Morgan's law. In fact each is equivalent to excluded middle, which is constructively strictly stronger:
- `pair_converse_iff_em`: that exceeding another's stems always gives an explicit pair the other has and the first lacks holds, for all courses from the empty set, exactly where `∀ P, P ∨ ¬ P`;
- `stems_converse_iff_em`: the same for "narrowing what can be born next always widens what continues";
- `em_of_widening_pair_converse`: the converse asked only of widenings already gives excluded middle.

One course is the witness.
- `onlyIf P` bears `2` above `0` exactly where `P`; every other birth has the empty past.
- Where `¬¬ P`, the antichain exceeds its stems at offset 3. `{2}` is a stem of the antichain's configuration, and a stem of `onlyIf P`'s configuration only where `P` fails.
- Every pair of `onlyIf P` gives `P`.

Applied to `P ∨ ¬ P`, whose double negation always holds, the pair found decides `P`. Excluded middle gives the converse back, with no `Decidable` instance (`pair_converse_of_em`).

The review's F7 set the level too low, and the revision followed it. What the need says about the unfolding is the note's, made exact. A failed inclusion says only that the precedence differs. Naming the pair a widening loses, for every pair of courses, is deciding every proposition, since a course can hold a pair exactly where a proposition holds.

Fix:
- **Lean.** Replace the ten De Morgan declarations with the twelve of probe block A (`onlyIfPast`, `onlyIf_two`, `onlyIf`, `onlyIf_prec`, `antichain_exceeds_onlyIf`, `notNot_em`, `em_of_pair_converse`, `pair_converse_of_em`, `pair_converse_iff_em`, `em_of_stems_converse`, `stems_converse_of_em`, `stems_converse_iff_em`), in the growth record. The ten are `Undecided.bothPast`, `Undecided.eitherPast`, `Undecided.both`, `Undecided.either_two`, `Undecided.either`, `Undecided.either_rangeIncludes`, `Undecided.either_exceeds`, `Undecided.deMorgan_of_pair`, `deMorgan_of_pair_converse` and `deMorgan_of_stems_converse`. Alternatively, keep them as lemmas whose docstrings say "implies".
- **CausalGrowth.lean:42–43:** "…; for every pair of courses, finding that pair is excluded middle (`pair_converse_iff_em`)."
- **Docstring of `pair_converse_iff_em`:** "**Finding the pair from exceeding, for every pair of courses from the empty set, is excluded middle**: a course can hold a pair exactly where a proposition holds, and exceeding knows that pair only doubly negated, so which pair a widening loses is found by deciding."
- **Docstring of `stems_converse_iff_em`:** "**That narrowing what can be born next always widens what continues, for the courses from the empty set, is excluded middle.**"
- **If the ten are kept.**
  - :864: "**Finding the pair from exceeding, for every pair of courses from the empty set, implies De Morgan's law** `¬ (A ∧ B) → ¬ A ∨ ¬ B` (weak excluded middle); it is excluded middle (`pair_converse_iff_em`)."
  - :914: "**That narrowing what can be born next always widens what continues implies De Morgan's law**; it is excluded middle (`stems_converse_iff_em`)."
- **NOTE.md:44, from "For every pair of courses" to the end of the bullet:** "For every pair of courses, this converse is excluded middle (`pair_converse_iff_em`). Take the course bearing `2` above `0` exactly where a proposition holds. Wherever that proposition is not refuted, the antichain exceeds this course's stems, and a pair of this course gives the proposition. For `P ∨ ¬ P`, which is never refuted, the pair decides `P` (`onlyIfPast`, `onlyIf_two`, `onlyIf`, `onlyIf_prec`, `antichain_exceeds_onlyIf`, `notNot_em`, `em_of_pair_converse`, `pair_converse_of_em`, with `stems_of_two`). So which pair a widening loses is found by deciding."
- **NOTE.md:58, last sentence:** "That narrowing what can be born next always widens what continues is again excluded middle (`em_of_stems_converse`, `stems_converse_of_em`, `stems_converse_iff_em`)."
- **NOTE.md:120:** "The calibrations, excluded middle for reaching every pair by links and for finding the lost pair, are lemmas of laws 1 and 3: …"
- **NOTE.md:134:** "… and the calibration (`pair_converse_iff_em`: excluded middle, of which the review's De Morgan form is a consequence) replace …"

**R2 (before landing). F8 again: the new and moved laws drop the courses' start, and most are false without it.**
- Docstrings: CausalGrowth.lean:560–561, :571, :581–582, :591–592, :598–599, :623–624, :633, :660–662, :672–673, :883, :893–894, :908, :953–954, :967–968.
- The header's law-5 bullet: :58–65.
- The note: NOTE.md:11, :45, :46, :58, :60, :85, :99.

Each of these laws takes both courses from the empty set, while the texts say "a course", "two courses" or "no course". Probe block B shows thirteen of the fourteen docstring laws false without the start, and the header's `antichain_unbeaten` sentence too. Only `rangeWidens_continuing_iff` was not probed.
- **`fromOne`** (one element, every past empty) widens the antichain's stems with the same, empty, precedence. This refutes `rangeIncludes_strict_iff`, `rangeWidens_strict`, `not_included_of_rangeExceeds`, `rangeExceeds_iff_pair`, `not_widens_and_continues`, `rangeIncludes_continuing_iff` and `not_rangeWidens_formsOrContinues` (probes `fromOne_widens`, `strict_needs_starts`, `not_widens_and_continues_needs_starts`, `rangeIncludes_continuing_iff_needs_starts`, `not_rangeWidens_formsOrContinues_needs_starts`).
- **`oneAbove`** (`1` above `0`) lacks at offset 0 the pair `(0, 1)` of `fromTwo` (the two-chain, every past empty), and exceeds it on neither reading. This refutes `rangeExceeds_of_pair`, `rangeWidens_of` and `mixed_of_pair` (`rangeWidens_of_needs_starts`, `mixed_of_pair_needs_starts`).
- **The chain from one element** includes the chain's stems, continues at least as much, and has a pair the chain lacks. This refutes `prec_iff_of_both`, `continuation_of_rangeIncludes` and `rangeWidens_stems_of_continuing` (`prec_iff_of_both_needs_starts`, `continuation_of_rangeIncludes_needs_starts`, `rangeWidens_stems_of_continuing_needs_starts`).
- **An order never reversing widening what can be born next** ranks `fromTwo`, which has a pair, above the antichain (`antichain_unbeaten_needs_start`).

NOTE.md:99 is false where it stands. The bullet before it says "on every course from a causal set", so "On that growth" takes in courses from different causal sets; `fromOne` and the antichain are two such courses.

Fix. The docstrings, each adding the start and nothing else:
- :560: "**Of two courses from the empty set, the strict part of stem inclusion is the strict part of precedence inclusion, reversed**, at every offset, with no decision."
- :571: "Of two courses from the empty set, one exceeds the other's stems where the other has a precedence pair it lacks."
- :581: "Of two courses from the empty set, one exceeds the other's stems only where, at some offset, the other's precedence is not included in its own."
- :591: "**Losing precedence widens what can be born next**: of two courses from the empty set, one widens the other's stems where its precedence is included in the other's at every offset and the other has a pair it lacks."
- :598: "Of two courses from the empty set, one widening the other's stems has its precedence included in the other's at every offset, and not conversely."
- :623: "**With precedence decidable, of two courses from the empty set one exceeds the other's stems exactly where the other has a pair it lacks.**"
- :633: "**Widening what can be born next never adds continuation** of any class read on precedence, of two courses from the empty set."
- :660: "**Compared by both, two courses from the empty set have the same precedence**: where one includes the other's stems and continues at least as much within the one class, at every offset, the two have the same precedence at every offset."
- :672: "**Of two courses from the empty set, neither widens the other's stems while continuing at least as much** within the one class."
- :883: "**Of two courses from the empty set, including what continues is being included in what can be born next.**"
- :893: "**Of two courses from the empty set, widening what continues is exactly inclusion of precedence with a pair the other lacks**, with no decision."
- :908: "**Of two courses from the empty set, widening what continues narrows what can be born next.**"
- :953: "**Read on what can be born next and what continues together, of two courses from the empty set neither widens the other**: the two inclusions together force the same precedence at every offset."
- :967: "**Of two courses from the empty set, given a pair one has and the other lacks, the two are mixed** on the joint reading: the one lacking it exceeds in what can be born next, the other in what continues."

The header, :58–65, the whole bullet:
> * **Two readings of widening, reversed.** Of two courses from the empty set, read on what continues within the one class (`continuing`), one widens the other exactly where its precedence includes the other's together with a pair the other lacks (`rangeWidens_continuing_iff`), and it then narrows what can be born next (`rangeWidens_stems_of_continuing`). No strict order contains both widenings (`no_order_contains_both`). Read on both together, of two courses from the empty set neither widens the other (`not_rangeWidens_formsOrContinues`), and two such courses one of which lacks a pair of the other are mixed (`mixed_of_pair`). An order never reversing widening what can be born next ranks no course from the empty set with a precedence pair above the course of empty pasts (`antichain_unbeaten`).

At :46–48 the bullet names the start two sentences earlier. "Two such courses" and "no such course" would let each sentence hold read alone.

The note:
- :11: after the bold title, add "Here every course starts from the empty set."
- :45: "*Widening never adds continuation* of any class read on precedence, of two courses from the empty set (`continuation_of_rangeIncludes`). …"
- :46: "*Compared by both, two courses from the empty set have the same precedence.* … So of two such courses, neither widens the other's stems while continuing at least as much within the one class (`not_widens_and_continues`). …"
- :58, opening: "*Read on what continues.* Of two courses from the empty set, what continues within the one class, …"
- :60: "*Read on both together* (`formsOrContinues`), of two courses from the empty set neither widens the other (`not_rangeWidens_formsOrContinues`), and two such courses one of which lacks a pair of the other are mixed: …"
- :85, last sentence: "So read on kinds of birth at offset 2, the antichain, which includes the pasts of every course from the empty set, does not include the chain's kinds of birth."
- :99: "On that growth," becomes "Of two courses from the empty set,", and "read on both, no course widens another" becomes "read on both, neither widens the other".

**R3 (before landing). The reading leaves C a choice that the condition's scope has already made.**
NOTE.md:16 (second sentence), :112; kit/texts_ue13.py:61, :68; kit/study_ue13.txt:105.

The note says C ranks here only once "a reading or a measure between the readings" is chosen, and that the continuation condition "fixes scope and does not choose". On this growth, though, the scope is what settles the reading.
- 07's table of the two premises ([07 §4](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order)) gives the condition one role: to fix whose losses count, every continuation's. Thesis T8 ([07 §8](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#theses)) compares what can form, counted for everything, with that scope.
- On this growth, a course that widens another's stems has its continuation within the one class included in the other's and not conversely (`rangeIncludes_continuing_iff`, with `rangeWidens_strict`). It loses continuation, a loss the condition counts.
- So C read on what can be born next alone ranks while leaving out losses that count. With the scope fixed, the reading is on both together.
- On both together, of two courses from the empty set neither widens the other (`not_rangeWidens_formsOrContinues`), and courses differing by a pair are mixed (`mixed_of_pair`).

Under the ethics' two premises, then, C ranks no course from the empty set above another. Any ranking needs a measure, a premise beyond C and beyond the condition. "A reading" is not an open choice, and "does not choose" hides this.

"It settles what C is read on" (:112) also says more than the Lean. The module shows that what C ranks reverses with the reading; it does not choose a reading.

Fix:
- NOTE.md:16, second sentence: "Under the continuation condition every continuation's losses count, and a widening of what can be born next loses continuation; so with that scope the reading is on both together, and there C, calling widening better, ranks no two courses: courses differing by a pair are mixed, and ordering them needs a measure, a premise beyond C and the condition."
- NOTE.md:112, the whole paragraph:
> **[AI reading, D45] What the model bears on.** It bears on what C is read on, a first-order matter, and not on the second-order direction 07 leaves open. Among the courses from the empty set, read on what can be born next, C ranks highest the course in which nothing conditions anything; nothing continues in it in any class, and even in its limit nothing renews without end. Read on what continues within the one class, C ranks highest the single chain. No strict order contains both. The continuation condition counts every continuation's losses, and every widening of what can be born next loses continuation, so with the scope it fixes the reading is on both together; there no course widens another, two courses one of which lacks a pair of the other are mixed, and ordering them needs a measure, a premise beyond C and the condition. The model says nothing for the second order: every course from a causal set keeps widening what can be born next, so a range whose widening keeps widening and one merely wider now are not told apart here; 07's requirement that the direction never reverse widening, read on stems, ranks nothing above the antichain and confines any weighing to pairs widening leaves unranked, and read on both together it constrains nothing here.

**R4 (before landing). Which 生生: an inference that does not follow, and a premise left out twice.**
NOTE.md:114 (first sentence), :16 (third sentence), :116 (last sentence); kit/texts_ue13.py:61.
- **(a) The inference does not follow.** The note argues that the grammar's «生生» holds on no configuration of the growth (law 6), "so the 生生 a reading of this growth can mean is 01's D1 reading". But law 6 also proves that the grammar's «生生» holds on the chain's limit, under a class pairing neighbours (`chainLimit_renews`), so it can be read on this growth. And 01 §6 reads 生生 as D1 everywhere, as asking more than renewal of lines, not as what is left where the grammar's fails.
- **(b) D1 is cut short.** The paraphrase drops "and generators" (01-ROOT.md:139: the conditions and generators of further forming).
- **(c) A premise is left out.** :16 gives the narrowest course's shortfall, admitting at each offset the fewest ways to go on, as a reason, without the further premise §4 states. :116 concludes "cannot be the direction of 生生, nor can continuation alone" without naming D1 or that premise.

Fix:
- NOTE.md:114, first sentence: "In the grammar 生生 names only renewal without end: on this growth it holds on no configuration and, of the extremes' limits, only on the chain's, under a class pairing neighbours (law 6). The 生生 meant here is 01's D1 reading, which asks more than renewal of lines: generation generating generation, what forms preserving, restoring, transmitting or creating the conditions and generators of further forming, which never means any new organization ([01](../../../../../../theories/becoming/chapters/01-ROOT.md#renewal-and-grains); the glossary's generation)."
- NOTE.md:16, third sentence: "Read with D1, 生生 as generation generating generation, it is not the order read on what can be born next, since the widest course transmits no condition; that it is not the order read on what continues needs a further premise, that admitting at each offset the fewest ways to go on also falls short (§4)."
- NOTE.md:116, last sentence: "So, read with D1, the adjacent possible alone is not the direction of 生生, and with §4's further premise neither is continuation alone; with every continuation's losses counted, what the model asks of the order is a measure between the two, a premise beyond C and the condition."

**R5 (before landing). F6's slogan returns.**
NOTE.md:84 (last sentence); kit/make_records_ue13.py:172 (a record's law heading); kit/texts_ue13.py:61 and kit/study_ue13.txt:105 (07 §2's reading).

"Widening the pasts is losing precedence" (law 8) and "widening is losing precedence" (the kit's reading) state an equivalence that F6 found unearned. What holds:
- widening loses precedence (`rangeWidens_strict`);
- losing a pair, together with inclusion, widens (`rangeWidens_of`);
- losing precedence widens only where the lost pair is found, and finding it for every pair of courses is excluded middle (R1).

`Kinds.stems_carried_iff`, cited for the law-8 sentence, is about inclusion, not widening.

Fix:
- NOTE.md:84, last sentence: "So law 3's core does not depend on identifying elements by their labels: under any identification fixed for the comparison, one configuration includes the other's pasts exactly where its precedence is included in the other's."
- kit, the heading at :172: "Widening what can be born next loses precedence, and losing a pair widens it."
- kit, the reading: "Read on what can be born next, widening loses precedence and ranks highest …".

**R6 (before landing). A contest name.**
CausalGrowth.lean:943 (`antichain_unbeaten`), :65; NOTE.md:61, :112, :136; NOTE.md:116 ("gives up"); kit/make_records_ue13.py:230, :232–233; kit/texts_ue13.py:61; kit/study_ue13.txt:60.

"Unbeaten" is a contest idiom, of who wins, and the naming rule takes structural words only. A renaming after landing needs a name that states a wrong meaning, so the name must be fixed now. "Gives up" in :116 reads as an exchange.

Fix:
- rename the theorem to `not_above_antichain`, with its statement and docstring unchanged;
- NOTE.md:112: "leaves the antichain unbeaten" becomes "ranks nothing above the antichain", as in R3's text;
- NOTE.md:116: "'sustain' carries what that course gives up, the precedence every widening loses" becomes "'sustain' carries the precedence every widening loses".

**R7 (small). Law 8: its hypothesis is weaker than stated, and the note credits it with more than it reads.**
CausalGrowth.lean:1174–1176 (docstring of `Kinds.stems_carried_iff`), :78–79; NOTE.md:84 (first sentence), :127, :139.
- **The hypothesis.** `stems_carried_iff` assumes only `back`: `τ` carries the elements of `c` one to one into those of `c'`, and `σ` undoes it. No relabelling is assumed, and the two configurations need not have one size: the law applies from one element into two by `j ↦ j + 1` (`stems_carried_unequal`). So "where σ and τ relabel …" and "Under a relabelling" state a special case. The directions "carried over" and "carried back" are right, with `σ` read as the relabelling of `c'` onto `c`.
- **What law 8 reads.** "Law 8 reads it up to relabelling" (:127, :139) means the labelled order on courses. Law 8 compares configurations up to relabelling; no order on courses up to relabelling is defined, and the labelled order stays as it was. `Finer.wide` and the course bearing `2` above `1` grow configurations of one kind at every offset from 2 on, and are mixed on what can be born next (`wide_right_isomorphic`, `wide_right_mixed`).

Fix:
- :1174–1176: "**Up to relabelling, the pasts still reverse the inclusion of precedence**: where `τ` carries the elements of `c` one to one into those of `c'`, `σ` undoing it, as the inverse of a relabelling of `c'` onto `c` does, every stem of `c'`, carried over by `τ`, is a stem of `c` exactly where the precedence of `c`, carried back, is included in that of `c'`. The two need not have one size."
- NOTE.md:84, first sentence: "Wherever the elements of the first configuration are carried one to one into the second's, as by the inverse of a relabelling, every stem of the second, carried over, is a stem of the first exactly where the first's precedence, carried back, is included in the second's (`Kinds.stems_carried_iff`; the two need not have one size)."
- NOTE.md:127: "(law 8 reads it up to relabelling)" becomes "(law 8 compares configurations up to relabelling; no order on courses up to relabelling is defined)".
- NOTE.md:139: "and law 8 reads it up to relabelling" becomes "and law 8 compares configurations up to relabelling".

**R8 (small). The header drops "at offset 2" for the kinds of birth.**
CausalGrowth.lean:79–82. With no offset, the header says that neither extreme's kinds of birth are among the other's. The Lean proves this at offset 2; at offset 0 each extreme's kinds are among the other's (`included_at_zero`). The note says "at offset 2" (:14, :85).

Fix: "The kinds of birth, births up to relabelling, do not: at offset 2 two stems of the antichain give one kind of birth (`Kinds.antichain_two_stems_one_kind`), and neither the antichain's kinds of birth nor the chain's are among the other's (`Kinds.not_included_antichain_chain`, `Kinds.not_included_chain_antichain`)."

**R9 (small). Six claims in the note have no Lean; the probes give it.**

| NOTE.md | Claim | Proved by (re-check) |
|---|---|---|
| :38 | from a configuration whose precedence relates every pair, nothing widens | `keepsWidening_needs_start` |
| :52 | at every offset the chain's last element ends | `chain_last_ends`, on precedence and on links |
| :78 | law 3's monotonicity holds on links within the one class, precedence decidable | `continuation_links_one_of_rangeIncludes` |
| :82 | two courses growing the same unlabelled causal set can be incomparable | `wide_right_isomorphic`, `wide_right_mixed` |
| :11, :112 | read on what continues, the chain is above every course lacking one of its pairs | `chain_rangeWidens_continuing` |
| :61 | never reversing widening ranks the chain above no course differing from it | `chain_not_above`, for courses lacking one of its pairs |

At :61, "differing from it" is more than the Lean gives. A course that differs from the chain without a named pair is not shown to widen it, since naming the pair needs deciding (R1).

Fix:
- Move these probes into the module and cite them; each is pure core, with its statement in the probes table. Or cite the laws each follows from, with "by".
- At :61, replace "ranks the chain above no course differing from it, since every such course lacking a pair of the chain widens it" with "ranks the chain above no course from the empty set lacking one of its pairs, since every such course widens it".

**R10 (small). The answer to L-02 drops the decision.**
NOTE.md:31, last sentence.

"On the orders causal set theory grows, read with the links as the conditions, it is" needs precedence to be decided. Without that, it is excluded middle that every pair on every configuration of every course from the empty set is reached by links, since the growth reaches `Undecided.third P` at offset 3 (`reach_links_courses_iff_em`; on all causal sets, `reach_links_all_iff_em`).

Fix: "… compared with causal sets: on the orders causal set theory grows, with precedence decided and the links read as the conditions, it is, and the links are the least such conditions; without deciding, that every pair is reached by links is excluded middle (`reach_links_all_iff_em`), on the grown orders too." If `reach_links_courses_iff_em` is moved in, it goes to the growth record: it uses `course`, and in the precedence record it would make that record depend on the growth record.

**R11 (small). Kauffman: "may" is missing, though §7 says it was kept.**
NOTE.md:116 (first sentence), :137; kit/texts_ue13.py:61.

The p. 22 wording the reviews report has biospheres that *may*, on average, enter their adjacent possible as fast as they can sustain. The note's "has biospheres, on average, enter" drops the "may" that F11 asked for and §7 claims to keep.

The p. 209 sentence names the workspace, the diversity of what can happen next, and the actual and adjacent possible together. So NOTES.md:15 ("workspace") and the note ("diversity of what can happen next") paraphrase one sentence. The page number rests on the reviews alone; a web search found the sentence but not its page.

Fix:
- NOTE.md:116, first clause: "As two reviews report *Investigations* (2000), Kauffman's tentative law says that biospheres may, on average, enter their adjacent possible as fast as they can sustain (p. 22), and that they enlarge their workspace, the diversity of what can happen next, on average as fast as they can (p. 209);"
- kit: "a biosphere enters its adjacent possible, on average, as fast as it can sustain" becomes "a biosphere may, on average, enter its adjacent possible as fast as it can sustain".

**R12 (small). "Little symmetry" is not what the count shows.**
NOTE.md:116 ("precedence mixed with unrelated elements and little symmetry, with the most").

The count does not tie the number of kinds to symmetry ([probes2/kinds_recount.txt](probes2/kinds_recount.txt)):
- the chain has no symmetry and the fewest kinds;
- at five elements, the nineteen classes with no symmetry have from six kinds (the chain) to sixteen;
- at four, the most kinds (nine) go with a configuration that has a symmetry, while classes with none have eight, seven or five.

The extremes have the fewest for opposite reasons. The antichain has the most pasts, and its relabellings merge them; the chain has the fewest pasts and nothing to merge.

Fix: "… and the count finds them with the fewest kinds for opposite reasons, the antichain because its relabellings merge its many pasts, the chain because it has the fewest pasts, and configurations with many pasts and few symmetries, precedence mixed with unrelated elements, with the most."

**R13 (small). The standing says the links reading fails where intervals are infinite.**
NOTE.md:120; kit/study_ue13.txt:95. "… as is its failure where intervals are infinite" contradicts the note's own caveat (:31, :104): an order with infinite intervals can be the reach of its links.

Fix: "… is known, as is that it can fail where intervals are infinite."

**R14 (small). The list of laws asking for decidable precedence is incomplete.**
CausalGrowth.lean:86–87; NOTE.md:127. `reach_links_iff`, `ordered_reach_links_iff` and `pair_of_not_included` also take `Decidable` instances.

Fix: "Precedence is Prop-valued; `reach_links`, `reach_links_iff`, `ordered_reach_links_iff`, `continuation_links_one_iff`, `pair_of_not_included` and `rangeExceeds_iff_pair` ask for it to be decidable, and `reach_links_of_decided` only that what lies between be decided."

## Propagation to the landing kit

The kit writes the records, 07 §2, 07's open entry, 08 §8 and the study section. So the findings above reach live text through it, and its study text keeps wording the review had already corrected.

| Finding | Kit locations |
|---|---|
| R1 | make_records_ue13.py:181–185, :223–225; texts_ue13.py:59, :77; study_ue13.txt:43, :58 |
| R2 | make_records_ue13.py:172 (second sentence), :190, :220, :234; study_ue13.txt:60 |
| F8 again | study_ue13.txt:47–50: "includes every course's stems", "every course with a pair", "Every course includes the stems of the chain", "every course lacking one of its pairs" |
| R3 | texts_ue13.py:61 ("settles", "fixes scope without choosing"), :68 ("settles only what widening is read on"); study_ue13.txt:105 |
| R4 | texts_ue13.py:61 ("can mean is") |
| R5 | make_records_ue13.py:172; texts_ue13.py:61; study_ue13.txt:105 |
| R6 | make_records_ue13.py:230, :232–233; texts_ue13.py:61; study_ue13.txt:60 |
| R11 | texts_ue13.py:61 |
| R13 | study_ue13.txt:95 |
| F7 again | study_ue13.txt:37 ("widens them where both hold") |
| F9 again | study_ue13.txt:53 (`chain_abides` without "once the next is born") |

texts_ue13.py:61 also argues 生生 differently from the note. It says every configuration admits a birth (`stem_all`), so further forming is unconditional and neither reading compares what conditions it. Every configuration does admit a birth, with the empty past and with the past of all elements. But the conclusion does not hold as worded: each reading compares the pasts, and the past is what conditions each birth. The note's §4, with R4, gives the argument the module supports, and 07 and the study should give that one.

## The review's findings

| Finding | Taken? | Where it stands |
|---|---|---|
| F1 | yes | `reach_links_le`, `reach_links_iff`, `ordered_reach_links_iff`, `path_not_reach_of_links`; header :12–26, NOTE:25–26 |
| F2 | yes, one sentence left | NOTE:27, with the meaning for the unfolding; NOTE:31's answer to L-02 drops the decision (R10) |
| F3 | yes | `nat_reach_links`; both modelling paragraphs |
| F4 | yes | header :23–26 and NOTE:31's three limits; the standing's "its failure" (R13) |
| F5 | yes | `links_least`; L-02 linked; a record of its own |
| F6 | in law 3; not in law 8 or the kit | R5 |
| F7 | at the wrong level | R1 |
| F8 | where flagged; repeated in the laws added since | R2 |
| F9 | yes; not in the kit's study text | header :56–57, :781–782, NOTE:52 |
| F10 | yes, with two flaws | the reviewer's laws are in the module; R3, R4 |
| F11 | partly | "on average", "enlarge" and the Edge gloss are in; "may" is not (R11) |
| F12 | yes | "reverses the inclusion of precedence" throughout |
| F13 | yes | `prec_iff_of_both` |
| F14 | yes | no financial idiom; a contest idiom came in with a probe's name (R6) |
| F15 | yes | NOTE:38 |
| F16 | yes | `Finer.loses`; the links case is uncited (R9) |
| F17 | yes, then overstated | header :84–86, NOTE:82; "law 8 reads it" (R7) |
| F18 | yes | header :31–33, NOTE:37 |
| F19 | yes | NOTE:120 |
| F20 | yes | :273 |
| F21 | yes | :110, NOTE:24 |
| F22 | yes | NOTE:16, :112, :114, :116 |

## The count

- **Rerun.** `count/kinds_count.py` reproduces `count/kinds_count.txt` byte for byte ([probes2/kinds_count-rerun.txt](probes2/kinds_count-rerun.txt)).
- **Recount.** [probes2/kinds_recount.py](probes2/kinds_recount.py) was written without the original. It grows the classes from the empty set, tests isomorphism by a backtracking search for a bijection rather than a canonical form, and counts automorphisms. It agrees on every number the note states:
  - 1, 2, 5, 16 and 63 classes;
  - at three elements, six kinds for the two-chain with a point and four for every other;
  - at four, nine for a single pair with two points, and five for the antichain, the chain and six others;
  - at five, sixteen for three pairs with no symmetry (the N with a point), and six for the extremes and fourteen others.
- **The notion counted.** Both scripts count births up to relabelling of the whole grown configuration, which is `Kinds.Included`'s notion: a birth from `c` and one from `c'` are of one kind where `Kinds.Isomorphic` holds of the grown configurations.
- Only "little symmetry" is not borne out (R12).

## The records

The planned split is right, and no declaration is in the wrong record.
- `Causet` and `Causet.Ordered` belong to precedence-and-its-links, whose causal-set laws use them (`Causet.Ordered.irrefl`, `Causet.Ordered.acyclic`, `ordered_reach_links_iff`, `Undecided.third_ordered`, `reach_links_all_iff_em`). The kit places them there (make_records_ue13.py:123), giving 35 declarations in seven groups and 110 in the growth record: 145, each cited once.
- `links`, `labelled_of_reach` and `searchBelow` are also used by laws 3, 6 and 7. That is the growth record's formal-reuse dependency, not a misplacement.
- Whatever R1, R9 and R10 move into the module goes to the growth record.

## Checked and found right

- **Build.** The module in the probe tree is byte-identical to the audited one; the audit's 107 theorems in 145 declarations with empty reports matches the note.
- **Names.** Every declaration name the note cites is declared in the module, in UE10 or in UE11, or is the review's name, cited in §7.
- **Moved laws.** The laws moved from the review's probes have the probes' statements, up to the namespace and an explicit universe binder.
- **Law 1.** The header, the docstrings and NOTE:24–31 say what the Lean proves:
  - one inclusion without transitivity, both with it;
  - the least net;
  - no finiteness needed;
  - deciding what lies between suffices;
  - excluded middle where it is not decided, with what that means for the unfolding;
  - on `ω + 1`, "can fail".
- **Law 2.** The start is stated, and `keepsWidening` needs it (`keepsWidening_needs_start`). The level of the adjacent possible is stated.
- **Law 3.** `rangeIncludes_iff`, `rangeIncludes_strict_iff` and `rangeExceeds_iff_pair` are stated right, starts included; only docstrings and the calibration's level are at fault.
- **Law 4.** The docstrings carry the start, and `chain_abides` carries "once the next is born".
- **Law 5.** The statements are right. `no_order_contains_both` needs no start, since its witnesses start from the empty set; `antichain_unbeaten`'s docstring carries the start.
- **Law 6.** `ordered_ceases` holds on every ordered configuration, and `chainLimit_renews` holds under the pairing class, as stated.
- **Law 7.** `Finer.widens`, `Finer.continues`, `Finer.not_continues` and `Finer.loses` are right, at offset 3.
- **Law 8.**
  - `Relabels`, `Isomorphic` and `Included` are as the note describes.
  - `antichain_two_stems_one_kind` is right, and so are both directions of `not_included_*` at offset 2.
  - NOTE:82's sentence on equality matches 01 §1 (01-ROOT.md:29).
- **Sources.**
  - Rideout and Sorkin's timid child is born above every element and the gregarious child unrelated to every element, as the note and the kit pair them (read in [arXiv:gr-qc/9904062](https://ar5iv.arxiv.org/html/gr-qc/9904062), §1.1).
  - Kauffman's wording was checked through a web search's summary of the [Zygon commentary](https://zygonjournal.org/article/13502/galley/27381/download), which has "may" on p. 22, and of his [Edge essay](https://www.edge.org/node/21148); p. 209 rests on the reviews. The note's Edge gloss, the limit on pace as what too fast an exploration would destroy of the system's own organization, is right.
- **Links.** Every link and anchor in the note resolves.
- **Kit.** The kit's counts match the audit, and [clash.log](clash.log) reports no clash.

## Probes

**Tree and command.** The tree is `probes2/tree/Becoming/`: a byte-identical copy of `CausalGrowth.lean`, and `CausalGrowthRecheck.lean` importing it, in namespace `Becoming.CausalGrowth.Recheck`. The build command, run from the package folder:

`python3 -B scratch_build.py <…>/ue13-causal-sets/probes2/tree Becoming.CausalGrowthRecheck`

Logs:
- [build-1.log](probes2/build-1.log): 53 theorems in 69 declarations, empty reports, one unused-variable warning;
- [build-2.log](probes2/build-2.log): 58 in 75, clean;
- [build-3.log](probes2/build-3.log): final, 60 theorems in 77 declarations, `with_axioms: {}`, no warning, 75 modules reused.

No `simp`, `omega`, `funext`, `propext` or `Classical` is used.

| Block | Name | Statement | Result |
|---|---|---|---|
| A | `pair_converse_iff_em` | for courses from the empty set, "exceeding gives an explicit pair the other has and the first lacks" ⟺ `∀ P, P ∨ ¬ P` | the calibration is excluded middle (R1) |
| A | `em_of_pair_converse`, `pair_converse_of_em`, `em_of_widening_pair_converse` | its two directions; the converse asked only of widenings already gives excluded middle | as stated |
| A | `stems_converse_iff_em` (`em_of_stems_converse`, `stems_converse_of_em`) | for courses from the empty set, "narrowing stems widens what continues" ⟺ `∀ P, P ∨ ¬ P` | R1 |
| A | `onlyIfPast`, `onlyIf_two`, `onlyIf`, `onlyIf_prec`, `antichain_exceeds_onlyIf`, `notNot_em` | `2` above `0` exactly where `P`; a pair gives `P`; with `¬¬ P` the antichain exceeds its stems | the witness |
| B | `fromOne_widens`, `strict_needs_starts` | `fromOne` widens the antichain's stems strictly, each precedence included in the other's | `rangeIncludes_strict_iff`, `rangeWidens_strict`, `not_included_of_rangeExceeds`, `rangeExceeds_iff_pair` fail (R2) |
| B | `rangeWidens_of_needs_starts`, `mixed_of_pair_needs_starts` | `oneAbove`'s precedence lies within `fromTwo`'s; `fromTwo` has `(0, 1)` at offset 0; `oneAbove` exceeds `fromTwo` on neither reading | `rangeExceeds_of_pair`, `rangeWidens_of`, `mixed_of_pair` fail (R2) |
| B | `prec_iff_of_both_needs_starts`, `continuation_of_rangeIncludes_needs_starts`, `rangeWidens_stems_of_continuing_needs_starts` | the chain from one element includes the chain's stems, continues at least as much, and has `(0, 1)` at offset 1, which the chain lacks | three laws fail (R2) |
| B | `not_widens_and_continues_needs_starts`, `rangeIncludes_continuing_iff_needs_starts`, `not_rangeWidens_formsOrContinues_needs_starts` (`fromOne_widens_formsOrContinues`) | `fromOne` against the antichain on each reading | three laws fail (R2) |
| B | `antichain_unbeaten_needs_start` | an order never reversing stem widening ranks `fromTwo`, with a pair, above the antichain | the header's sentence fails (R2) |
| B | `keepsWidening_needs_start` | from `full` (no elements, every pair related), every past empty, nothing keeps widening | NOTE:38's claim (R9) |
| B | `one`, `twoChain`, `grownFrom`, `grownFrom_size`, `grownFrom_prec_iff`, `grownFrom_empty_prec`, `fromEmptyPasts`, `fromOne`, `fromOne_prec`, `fromOne_size`, `fromOne_stem_of_antichain`, `fromOne_stem_zero`, `not_stem_antichain_zero`, `antichain_not_continuing`, `fromTwo`, `fromTwo_prec_iff`, `onePast`, `onePast_stems`, `oneAbove`, `oneAbove_prec`, `fromTwo_stem_all`, `not_stem_antichain_all`, `chainFromOnePast`, `chainFromOne_prec_iff`, `chainFromOne_labelled`, `chainFromOne`, `not_continuing_chain_one`, `full`, `full_stem_empty` | courses from given configurations, and their laws | helpers |
| C | `wide_right_isomorphic` | from offset 2 on, `Finer.wide` and `right` (`2` above `1`) grow configurations of one kind, by `Kinds.swap` | R7, R9 |
| C | `wide_right_mixed` | each exceeds the other's stems | the labelled order leaves them mixed (R7, R9) |
| C | `rightPast`, `right_two`, `right`, `swap_fixed`, `swap_eq_two_iff`, `swap_eq_one_iff`, `swap_below`, `wide_right_prec` | the course and the exchange | helpers |
| D | `chain_last_ends` | at every offset `t + 1`, element `t` ends in the one class, on precedence and on links | R9 |
| D | `continuation_links_one_of_rangeIncludes` | with precedence decidable, of courses from the empty set, including stems adds no continuation along links within the one class | R9 |
| D | `chain_rangeWidens_continuing` | read on what continues, the chain widens every course from the empty set lacking one of its pairs | R9 |
| D | `chain_not_above` | an order never reversing stem widening ranks the chain above no course from the empty set lacking one of its pairs | R9 |
| D | `included_at_zero` | at offset 0 each extreme's kinds of birth are among the other's | R8 |
| D | `stems_carried_unequal` | `Kinds.stems_carried_iff` from one element into two, by `j ↦ j + 1` | no relabelling needed (R7) |
| D | `reach_links_courses_iff_em` (`thirdPast`, `thirdPast_stems`, `thirdCourse`, `thirdCourse_prec_iff`, `links_of_iff`) | every pair on every configuration of every course from the empty set is reached by links ⟺ `∀ P, P ∨ ¬ P`; the growth reaches `Undecided.third P` at offset 3 | R10 |

The headline statements:

```lean
theorem pair_converse_iff_em :
    (∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeExceeds Stem r' → ∃ t i j, (r'.state t).prec i j ∧ ¬ (r.state t).prec i j) ↔
      ∀ P : Prop, P ∨ ¬ P
theorem stems_converse_iff_em :
    (∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeWidens Stem r' → r'.RangeWidens continuing r) ↔ ∀ P : Prop, P ∨ ¬ P
theorem reach_links_courses_iff_em :
    (∀ r : Run process, r.state 0 = empty → ∀ t i j, (r.state t).prec i j →
      «及» (links (r.state t).prec) i j) ↔ ∀ P : Prop, P ∨ ¬ P
theorem wide_right_isomorphic (k : Nat) :
    Kinds.Isomorphic (Finer.wide.state (k + 2)) (right.state (k + 2))
theorem wide_right_mixed : Finer.wide.RangeExceeds Stem right ∧ right.RangeExceeds Stem Finer.wide
```

Nothing outside this file and `probes2/` was written. `probes2/tree/.build/` is build output, listed for removal in [LANDING.md](LANDING.md)'s last section.
