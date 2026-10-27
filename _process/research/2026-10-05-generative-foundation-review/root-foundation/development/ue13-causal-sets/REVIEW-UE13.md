# UE13 review: causal sets, and what can be born next against what continues

28 October 2026. An independent, adversarial review, AI-written, of board item UE13: the module `Becoming.CausalGrowth` ([tree/Becoming/CausalGrowth.lean](tree/Becoming/CausalGrowth.lean)), its [note](NOTE.md), [design](DESIGN.md) and [working notes](NOTES.md). The module was read against the grammar (`Becoming/Grammar.lean`), UE10's `Becoming/ReachableRanges.lean`, UE11's `Becoming/HeldPossible.lean`, `Frame.lean`, 01 and 07 §2–§4 with 07's open list, the glossary, and the review packet's logic questions. Probes are in [probes/tree/Becoming/CausalGrowthProbe.lean](probes/tree/Becoming/CausalGrowthProbe.lean). It imports an unchanged copy of the module and builds with `scratch_build.py`: 46 theorems in 59 declarations, every axiom report empty, no warning ([probes/build-6.log](probes/build-6.log)).

## Verdict

The Lean is sound, and its theorem statements carry the hypotheses the claims need. The module's own audit ([scratch-3.log](scratch-3.log): 56 theorems in 77 declarations, empty reports) agrees with the note's counts, and every name the note cites is declared. The reading of Rideout–Sorkin's growth is faithful, `stems_included_iff` is correctly scoped, and law 5's witness is correct.

The problems are in the prose around the Lean, which in several places says more than it proves:
- law 1's "precedence is the reach of its links" cites a theorem that proves one inclusion, and the note's wording, for a relation, is false (F1);
- the stated role of decidability is wrong: a calibration shows it is excluded middle even on three-element causal sets (F2);
- "needs discreteness" and "finite" misplace the hypothesis (F3, F4);
- "widening is exactly losing precedence" is not earned for `RangeWidens` without decidability. It is exact for the strict part of inclusion, with no decision (F6, F7);
- six docstrings and three note sentences drop "from the empty set" or "from a causal set", and without it they are false (F8).

The AI reading is supported in its narrow form but mis-aimed (F10). What the model settles is what C is read on, a first-order question. Read on what can be born next, C ranks highest the course in which nothing conditions anything. Read on what continues, it ranks the chain highest. No strict order contains both. Read on both together, no course widens another, and every pair of courses differing by a pair is mixed. It does not bear on the second-order direction: every course from a causal set keeps widening here, and 07's requirement that the direction never reverse widening, read on stems, leaves the antichain unbeaten. Its "生生" cannot be the grammar's «生生», which holds on no configuration of the growth.

The probes give exact Lean for each of these.

**Recommendation:** land after F1–F11 are taken. F12–F22 are small. The standing, near-definitional laws and witnesses, is right.

## Findings

Severity: **E** an error in a claim, **O** an over- or understatement, **I** an improvement, **S** style or naming. Line numbers are those of the reviewed files.

**F1 (E). Law 1 states an equality that its cited theorem does not prove, and for relations it is false.**
NOTE.md:22 ("*Precedence is the reach of its links* on a naturally labelled relation with decidable precedence (`reach_links`)"); CausalGrowth.lean:124–125 (`reach_links` docstring, in bold); :14–15 (header).

`reach_links` proves only `O i j → «及» (links O) i j`, and it assumes no transitivity. For a relation the equality fails. Probe `path_not_reach_of_links`: `0 → 1 → 2` is naturally labelled and decidable; its links reach `(0, 2)`, which it does not relate. The equality needs transitivity and the converse inclusion. The module has that converse only inside the proof of `continuation_links_one_iff`.

NOTE:22 says "relation", so as worded it is false. The header and the docstring say "order", so what they say is true, but the theorem they cite proves only one of its two inclusions.

Fix: add the two laws below (probe P1) and reword.
- NOTE:22: "*Every pair is reached by links* on a naturally labelled relation with decidable precedence (`reach_links`); on a transitive one, so on a causal set, precedence is the reach of its links, both ways (`reach_links_iff`)."
- Docstring :124: "**Every pair is reached by links** on a naturally labelled relation with decidable precedence; with transitivity, precedence is the reach of its links (`reach_links_iff`)."

```lean
theorem reach_links_le {α : Type u} {O : «际» α} (trans : ∀ {i j k}, O i j → O j k → O i k)
    {i j : α} (reach : «及» (links O) i j) : O i j := by
  induction reach with
  | one link => exact link.1
  | more link _ ih => exact trans link.1 ih

theorem reach_links_iff {O : «际» Nat} [∀ i j, Decidable (O i j)]
    (trans : ∀ {i j k}, O i j → O j k → O i k) (labelled : ∀ {i j}, O i j → i < j) {i j : Nat} :
    «及» (links O) i j ↔ O i j :=
  ⟨reach_links_le (O := O) trans, reach_links labelled⟩
```

**F2 (O). Decidability is not "the constructive form of finiteness"; it is deciding what lies between, and it cannot be dropped even on finite causal sets.**
NOTE.md:22 ("Decidability is the constructive form of finiteness used here").

The bound of the search comes from the natural labelling. Decidability is what lets the search be made. Probe P2:
- `reach_links_all_iff_em`: that every pair of every causal set is reached by links is exactly excluded middle. The witness is `third P`, three elements with `0` before `2`, and `0` before `1` before `2` exactly where `P`.
- `reach_links_of_decided`: deciding betweenness suffices, with no `Decidable` instance.

Per AGENTS.md, a calibration of the logic alone is a lemma of the item that needs it, so this one belongs to law 1. If it is stated as a result, its record must say what the need means for the unfolding: telling a link, a direct condition, from a longer chain is deciding whether anything lies between.

Fix NOTE:22: "The natural labelling bounds the search and decidability lets it be made. It cannot be dropped: that every pair of every causal set is reached by links is excluded middle (`reach_links_all_iff_em`, on three elements whose relations through the middle are a proposition), and deciding betweenness suffices (`reach_links_of_decided`). Telling a link from a longer chain is deciding whether anything lies between."

```lean
theorem reach_links_of_decided {O : «际» Nat}
    (decided : ∀ i z j, (O i z ∧ O z j) ∨ ¬ (O i z ∧ O z j))
    (labelled : ∀ {i j}, O i j → i < j) {i j : Nat} (pair : O i j) : «及» (links O) i j
theorem reach_links_all_iff_em :
    (∀ c : Causet, c.Ordered → ∀ i j, c.prec i j → «及» (links c.prec) i j) ↔
      ∀ P : Prop, P ∨ ¬ P
```
The proofs are in probe block P2 (`third`, `third_ordered`, `em_of_reach_third`, `searchBelow_or`, `reach_links_within_of_decided`).

**F3 (O). "Finite" understates law 1, and "infinite causal sets are read only as courses" is inaccurate.**
NOTE.md:8 ("On a finite labelled order"), :60, :81; CausalGrowth.lean:55–56.

`reach_links` holds for every naturally labelled relation on the natural numbers, infinite ones included. Probe `nat_reach_links`: the natural numbers in their order, which is the limit of the chain. The hypothesis actually used is past-finiteness: each element is preceded by finitely many, smaller labels.

Fix:
- §1: "On an order labelled by the natural numbers, each element preceded only by smaller labels, with decidable precedence, every pair is reached by links. Such orders are past-finite, finite or not, and include the limit of every course."
- §5 and the module's modelling paragraph: "Infinite causal sets are read as courses and, in law 1, as naturally labelled orders on the natural numbers."

**F4 (O). The ω + 1 sentences: "needs discreteness", and the module header drops "read as the links".**
NOTE.md:26 ("holds where causal set theory's discreteness holds"), :60 ("shows the reading needs discreteness"); CausalGrowth.lean:19–20 ("Reading precedence as the reach of conditioning needs the discreteness causal set theory assumes").

There are three problems:
- (a) The Lean proves the positive side under natural labelling, which gives past-finiteness, together with decidability. Causal set theory's discreteness is local finiteness, which is weaker. A locally finite order with no natural labelling, such as the integers, is a causal set in the 1987 sense and is not covered. The result is classically true there, but it is not proved.
- (b) ω + 1 shows the reading *can fail* without local finiteness, not that it *needs* it. The note's own caveat at :26 says so.
- (c) On ω + 1, precedence *is* the reach of conditioning when the conditioning is precedence itself, since a transitive relation is its own reach. Only the links reading fails.

Fix:
- CausalGrowth.lean:19–20: "Reading precedence as the reach of its links can fail where the order is not locally finite."
- NOTE:26: "So the root's reading of precedence as the reach of conditioning, with conditioning read as the links, holds on naturally labelled orders with decidable precedence (deciding betweenness suffices), a case of causal set theory's discreteness, and can fail where the order is not locally finite."
- NOTE:60: "… and the witness `ω + 1` shows the reading can fail without discreteness."

**F5 (I). Law 1's content for the root is sharper than stated, and it answers an open review question.**
By `link_of_reach`, every net whose reach is a relation contains that relation's links, on any carrier: probe `links_least`. With `reach_links_iff`, on a naturally labelled order with decidable precedence, the links are the least condition net whose reach is the precedence.

This answers part of question 4 under L-02 in the review packet's logic section ([LOGIC.md](../../../../../../theories/becoming/review/LOGIC.md)). That question asks whether precedence as the transitive closure of a condition relation is a sound basis for an order of time, compared with causal sets. The note should link it.

Law 1 is a claim about the root's precedence, distinct from laws 2–5 on widening. AGENTS.md keeps distinct claims in separate records, so consider a record of its own, homed at 01's precedence ([01 §1](../../../../../../theories/becoming/chapters/01-ROOT.md#one-kind-of-symbol), where L-02 points), carrying `reach_links_iff`, `links_least` and the F2 lemma.

```lean
theorem links_least {α : Type u} {O R : «际» α} (generates : ∀ i j, «及» R i j ↔ O i j) {i j : α}
    (link : links O i j) : R i j :=
  link_of_reach ⟨(generates i j).mpr link.1,
    fun z ⟨first, second⟩ => link.2 z ⟨(generates i z).mp first, (generates z j).mp second⟩⟩
```

**F6 (O). "Widening what can be born next is exactly losing precedence" is not earned for `RangeWidens`, and "at every offset" is ambiguous.**
NOTE.md:10 ("one widens what the other can bear next exactly where it has less precedence"), :62 ("is exactly losing precedence, at every offset"); CausalGrowth.lean:384 (`rangeWidens_of` headline, "**Widening … is losing precedence**").

`RangeWidens` is inclusion together with an *explicit* exceeding. The module proves two one-way laws:
- widening ⇐ inclusion together with an explicit pair (`rangeWidens_of`);
- widening ⇒ inclusion together with "at some offset the inclusion fails back" (`rangeIncludes_iff`, `not_included_of_rangeExceeds`).

No iff holds without deciding (F7). What is exact (probes P3, P4):
- (i) with no decision, the strict part: `rangeIncludes_strict_iff`. A course includes another's stems and is not included back exactly where its precedence is included in the other's at every offset and not conversely. `rangeWidens_strict` follows.
- (ii) with decidable precedence, exceeding is having an explicit pair: `rangeExceeds_iff_pair`. So widening is inclusion together with an explicit pair.

Precedence is included at every offset and lost at *some* offset. Read as "loses precedence at every offset", NOTE:62 is false: on a course from the empty set, offsets 0 and 1 carry no precedence.

Fix:
- NOTE:10: "So of two courses from the empty set, one includes what the other can bear next at every offset exactly where its precedence is included in the other's at every offset, and strictly exactly where strictly (`rangeIncludes_strict_iff`); it widens it where, besides, the other has a pair it lacks, and, with precedence decided, only there."
- NOTE:62: "On that growth, including what can be born next is having precedence included at every offset, strictly where strictly; widening it is that with a pair the narrower has and the wider lacks, which is found where precedence is decided (`rangeExceeds_iff_pair`)."
- Docstring :384: "**Losing precedence widens what can be born next**: …".

```lean
theorem rangeIncludes_strict_iff (start : r.state 0 = empty) (start' : r'.state 0 = empty) :
    (r.RangeIncludes Stem r' ∧ ¬ r'.RangeIncludes Stem r) ↔
      ((∀ t i j, (r.state t).prec i j → (r'.state t).prec i j) ∧
        ¬ ∀ t i j, (r'.state t).prec i j → (r.state t).prec i j) :=
  ⟨fun ⟨inc, notBack⟩ => ⟨(rangeIncludes_iff start start').mp inc,
     fun back => notBack ((rangeIncludes_iff start' start).mpr back)⟩,
   fun ⟨inside, notBack⟩ => ⟨(rangeIncludes_iff start start').mpr inside,
     fun back => notBack ((rangeIncludes_iff start' start).mp back)⟩⟩

theorem rangeExceeds_iff_pair (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    [∀ t i j, Decidable ((r.state t).prec i j)] [∀ t i j, Decidable ((r'.state t).prec i j)] :
    r.RangeExceeds Stem r' ↔ ∃ t i j, (r'.state t).prec i j ∧ ¬ (r.state t).prec i j
```
`pair_of_not_included` (probe block P4) gives the bounded search over pairs.

**F7 (I). "Not constructive here" is now a lemma: the explicit-pair converse is De Morgan's law.**
NOTE.md:38 ("would ask to find the pair from a failed inclusion, which is not constructive here").

Probe P4 states the explicit-pair converse of `rangeExceeds_of_pair` for every pair of courses from the empty set: `deMorgan_of_pair_converse`. The same holds for "narrowing what can be born next always widens what continues": `deMorgan_of_stems_converse`. Each gives `¬ (A ∧ B) → ¬ A ∨ ¬ B`, which is weak excluded middle. The witnesses are the courses `both` (`2` born above `0` and `1`) and `either A B` (`2` above `0` where `A`, above `1` where `B`). `either A B` exceeds `both` wherever `¬ (A ∧ B)`, and a lacking pair says which of `A`, `B` fails.

Fix NOTE:38: replace "which is not constructive here" with "which, for every pair of courses, is De Morgan's law, weak excluded middle (`deMorgan_of_pair_converse`); with precedence decided it holds (`rangeExceeds_iff_pair`)". In the same bullet replace "Hence it widens them where both hold" with "Hence it widens them where its precedence is included in the other's at every offset and the other has a pair it lacks".

**F8 (E). Six docstrings and three note sentences drop the course's start, and without it they are false.**
"From the empty set": CausalGrowth.lean:41–46 (header, "The extremes"), :493, :497, :511, :518; NOTE.md:45 (second clause), :46. "From a causal set": CausalGrowth.lean:28 (header), :298 (`keepsWidening` docstring); NOTE.md:9, :61.

- `antichain_rangeIncludes`, `antichain_rangeWidens`, `rangeIncludes_chain` and `rangeWidens_chain` all take `start : r.state 0 = empty`. Without it the claims fail. A course from a one-element configuration has the stem `{0}` at offset 0. That is not a stem of the antichain's empty configuration (it fails `within`), so "the antichain includes the stems of every course" is false.
- `keepsWidening` takes `start : (r.state 0).Ordered`. Without it the claim fails. Take a course from a configuration of size 0 whose precedence relates every pair, with every past empty. Every birth keeps that precedence, so a stem holding any element would hold every number and fail `within`. At every offset the only stem is the empty one, and nothing widens.

Fix: insert the start in each place:
- "includes the stems of every course from the empty set";
- "widens those of every course from the empty set with a precedence pair" (likewise NOTE:45: "widens those of every such course with a precedence pair");
- "has its stems included in every such course's";
- "widened by every course from the empty set lacking one of its pairs";
- NOTE:46: "every course from the empty set includes the chain's stems …, and every such course lacking a pair of the chain widens them";
- header :28, docstring :298, NOTE:9 and :61: "on every course from a causal set", as NOTE:33 has it.

**F9 (O). The chain's abiding needs the next element.**
CausalGrowth.lean:46–47 ("in it every element after the first abides in the one class, on links (`chain_abides`)").

The theorem needs `k + 2 < t`. At every offset the last element ends.

Fix: "… abides in the one class, on links, once the next is born (`chain_abides`)", as NOTE:46 has it.

**F10 (O, the main finding). The AI reading is supported narrowly but mis-aimed.**
NOTE.md:13, :71; DESIGN.md §4.

What is supported. Read on what can be born next, the antichain is the greatest course from the empty set (`antichain_rangeIncludes`). It widens every such course with a pair (`antichain_rangeWidens`), and nothing continues in it (`antichain_begins_ends`). The chain is the least (`rangeIncludes_chain`), and it has the most continuation of every class read on precedence (probe `continuation_le_chain`).

What is mis-aimed:
- **(a) The target is C, read in first order.** The glossary's C is "widening what can form is better", the only premise that ranks. Among courses from the empty set:
  - Read on what can be born next, C ranks the antichain above every course with a pair.
  - Read on what continues within the one class, C ranks the chain above every course lacking one of its pairs. On this growth widening what continues is exactly inclusion of precedence together with a pair the other lacks, with no decision (`rangeWidens_continuing_iff`), and it narrows what can be born next (`rangeWidens_stems_of_continuing`).
  - No strict order contains both widenings (`no_order_contains_both`).
  - Read on both together (`formsOrContinues`), no course widens another (`not_rangeWidens_formsOrContinues`). Two courses one of which lacks a pair of the other are mixed (`mixed_of_pair`), and 07 §2 says that ordering a mixed part needs a measure.

  So the premise is the choice of what widening is read on, or a measure between the two readings. It is not "ranking a widening above the precedence it loses", which is C itself read on what can be born next. DESIGN §4 put C there ("calling widening better (C) would sit there"); the note dropped it. Restore it, and give the condition its role: it fixes scope and does not choose.
- **(b) It is not the second-order direction.** On this growth every course from a causal set keeps widening what can be born next (`keepsWidening`). So "a range whose widening keeps widening, compared with one merely wider now" separates nothing here: the antichain is both. 07's open item requires the direction never to reverse widening, and read on what can be born next that requirement is strong:
  - it ranks no course with a pair above the antichain (probe `antichain_unbeaten`);
  - it ranks the chain above no course that differs from it, since every course from the empty set lacking a pair of the chain widens it (`rangeWidens_chain`).

  A weighing of the two can therefore act only on pairs that widening leaves unranked. "Has to weigh the two" should say so, or say what else widening is read on.
- **(c) Which 生生?** The grammar's «生生», renewal without end, holds on no configuration of the growth, in any class, on precedence or on links: every element ceases (`ordered_ceases`, `ordered_not_renews`). In the limits the extremes part. On the antichain's limit nothing renews without end in any class (`antichainLimit_not_renews`). On the chain's limit, `1` renews without end under the class pairing `2m` with `2m + 1` (`chainLimit_renews`).

  So the reading's 生生 is not the grammar's but 01's D1 reading: generation generating generation, what forms preserving, restoring, transmitting or creating the conditions of further forming, which "never means any new organization". The widest course transmits nothing, because nothing in it conditions anything. "A maximum of neither" needs that reading stated as its premise, and against the chain it needs one more: that admitting at each offset the fewest ways to go on also falls short.

  The model is a formal witness for D1's and the glossary's caution about "generation" and for 07 §2's "生生 can exceed what widening counts". Link both.

Replacement for NOTE:13:
> **[AI reading]** On causal-set growth from the empty set, what widening ranks depends on what it is read on. Read on what can be born next, the course in which nothing conditions anything is above every course with a precedence pair. Nothing continues in it in any class, and even in its limit nothing renews without end. Read on what continues within the one class, the single chain is above every course lacking one of its pairs. No strict order contains both. Read on both together, no course widens another: two courses one of which lacks a pair of the other are mixed, and ordering them needs a measure. So C, calling widening better, ranks here only once a reading or a measure is chosen, and the choice is a premise beyond C; the continuation condition fixes scope and does not choose. Read with D1 as generation generating generation, 生生 is the order of neither reading alone: the widest course transmits no condition, and the narrowest admits at each offset the fewest ways to go on.

The Kauffman paragraph at :71 is replaced in F11.

```lean
def continuing (c : Causet) (p : Nat × Nat) : Prop := «相续» c.prec «一» p.1 p.2

theorem rangeIncludes_continuing_iff (start : r.state 0 = empty) (start' : r'.state 0 = empty) :
    r.RangeIncludes continuing r' ↔ r'.RangeIncludes Stem r
theorem rangeWidens_continuing_iff (start : r.state 0 = empty) (start' : r'.state 0 = empty) :
    r.RangeWidens continuing r' ↔
      (∀ t i j, (r'.state t).prec i j → (r.state t).prec i j) ∧
        ∃ t i j, (r.state t).prec i j ∧ ¬ (r'.state t).prec i j
theorem rangeWidens_stems_of_continuing (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    (widens : r.RangeWidens continuing r') : r'.RangeWidens Stem r
theorem no_order_contains_both :
    ¬ ∃ above : Run process → Run process → Prop,
      (∀ r, ¬ above r r) ∧ (∀ {r r' r''}, above r r' → above r' r'' → above r r'') ∧
      (∀ r r', r.RangeWidens Stem r' → above r r') ∧
      (∀ r r', r.RangeWidens continuing r' → above r r')

def formsOrContinues (c : Causet) : (Nat → Prop) ⊕ (Nat × Nat) → Prop
  | .inl D => Stem c D
  | .inr p => continuing c p
theorem not_rangeWidens_formsOrContinues (start : r.state 0 = empty)
    (start' : r'.state 0 = empty) : ¬ r.RangeWidens formsOrContinues r'
theorem mixed_of_pair (start : r.state 0 = empty) (start' : r'.state 0 = empty) {t i j : Nat}
    (pair' : (r'.state t).prec i j) (lacks : ¬ (r.state t).prec i j) :
    r.RangeExceeds formsOrContinues r' ∧ r'.RangeExceeds formsOrContinues r
theorem antichain_unbeaten (above : Run process → Run process → Prop)
    (never : ∀ r r', r.RangeWidens Stem r' → ¬ above r' r)
    (start : r.state 0 = empty) {t i j : Nat} (pair : (r.state t).prec i j) : ¬ above r antichain

theorem ordered_ceases {c : Causet} (ordered : c.Ordered) (E : «际» Nat) (x : Nat) :
    «息» c.prec E x ∧ «息» (links c.prec) E x
theorem ordered_not_renews {c : Causet} (ordered : c.Ordered) (E : «际» Nat) (x : Nat) :
    ¬ «生生» c.prec E x ∧ ¬ «生生» (links c.prec) E x
theorem antichainLimit_not_renews (E : «际» Nat) (x : Nat) : ¬ «生生» antichainLimit E x
theorem chainLimit_renews : «生生» chainLimit pairs 1
```
The proofs are in probe blocks P5, P6 and P8. Every one has an empty axiom report.

**F11 (O). Kauffman's fourth law: "enter" is applied where "enlarge" fits, and "on average" is dropped.**
NOTE.md:71.

As the Zygon review quotes *Investigations* (I reached it through a search summary; the page itself refused automated access):
- p. 22: biospheres, on average, "may enter" their adjacent possible as rapidly as they can sustain;
- p. 209: they enlarge the diversity of what can happen next, on average, as fast as they can;
- a candidate law that such systems tend to maximize the kinds of events that can happen next.

The note's paraphrase drops "on average" and "may". It also has the antichain "entering it as fast as possible". Every course enters one element per step; what the antichain maximizes is the p. 209 quantity, what can happen next. Kauffman's own gloss, in his Edge essay "The Adjacent Possible" (2003), says the pace is limited because exploring too fast would destroy the system's own internal organization, so internal gating may hold it back. That supports the note's reading of "sustain"; cite it rather than leave it as an inference.

Replacement for :71:
> **[AI reading]** Kauffman's tentative fourth law, as the Zygon review quotes it, says biospheres may, on average, enter their adjacent possible as fast as they can sustain (p. 22), and that they enlarge the diversity of what can happen next, on average, as fast as they can (p. 209). Kauffman glosses the limit as what exploring too fast would destroy of the system's own organization (Edge, 2003). On causal-set growth every course enters one element per step. Enlarging what can be born next fastest, at every offset, is the course of births with empty pasts, in which nothing conditions anything and so nothing continues. "Sustain" carries what that course gives up, the precedence every widening loses. So the adjacent possible alone cannot be the direction of 生生, nor can continuation alone. What the model asks of the order is a reading or a measure between the two, a premise beyond C, not a second-order comparison: on this growth every course from a causal set keeps widening what can be born next.

Sources consulted, all secondary:
- the Zygon review ([zygonjournal.org](https://zygonjournal.org/article/13502/galley/27381/download)), which refused automated access, its quotations of pp. 22 and 209 reached through a web search's summary;
- Kauffman's Edge essay [The Adjacent Possible](https://www.edge.org/node/21148), read directly;
- a report of his February 2002 talk ([nmsr.org](https://www.nmsr.org/wp-content/uploads/2026/07/Kauffman-Feb2002.pdf)), which says the law was not mathematized because the possibilities cannot be listed;
- the Times Higher Education review ([timeshighereducation.com](https://www.timeshighereducation.com/node/86470));
- his 2004 Edge answer ([edge.org](https://edge.org/response-detail/10542)), in which he calls himself very unsure of the candidate law.

The arXiv paper on Gaia and the fourth law ([arXiv:1102.3338](https://arxiv.org/abs/1102.3338)) could not be read.

**F12 (S). "Converse" is used for order reversal.**
NOTE.md:10, :35, :67, :75; CausalGrowth.lean:29, :332.

In the grammar "converse" is «逆», the relation read backwards (Grammar.lean's table and the docstring of `«逆»`). The note also uses "converse" in its logical sense (NOTE:38). So "what can be born next is the converse of precedence" reads as «逆» of precedence, which is succession.

Fix ("reverses precedence" alone would repeat the ambiguity, so name the inclusion):
- "What can be born next reverses the inclusion of precedence" (NOTE:10, :35; header :29);
- "**The stems reverse the inclusion of precedence**" (docstring :332);
- "The reversal holds on causal-set growth …" (NOTE:67);
- "the reversal on the growth dynamics" (NOTE:75).

**F13 (S). `alike_of_both` uses the grammar's word for something else.**
CausalGrowth.lean:418–420; NOTE.md:40.

"Alike" is the grammar's word for being related under a class (`«续»`: alike under `E`). Here it means having the same precedence at every offset.

Fix: rename to `prec_iff_of_both`, and write "Compared by both, two courses have the same precedence".

**F14 (S). Financial idioms in live prose.**
NOTE.md:71 ("every widening is paid in precedence"); NOTE.md:67 ("trade off"). DESIGN.md §4 already has the structural form ("every widening is a loss of precedence").

AGENTS.md asks for structural words, not financial ones.

Fix: "every widening loses precedence"; "that widening and continuation are opposed on every process".

**F15 (I). Say what keeps widening, and in which sense "the adjacent possible" is meant.**
NOTE.md:9, :33.

"What can be born next keeps widening" sits beside "the possible with the past held is the whole possible", and a reader can take it that the possible grows. It does not. Every stem a course ever admits is possible from its start (probe `stem_possible_from_start`, by UE10's `Run.possible_from_start`), and the whole possible never grows (`Run.possible_of_next`). The widening is the actual moving within a fixed possible, as 07 §2 reads the possible within a horizon.

The two uses of "adjacent possible" also differ by a level:
- UE10 defines the adjacent possible with the present as `Reaching.PossibleWithin P adm 1`, what a configuration within one move admits (its docstring), and 08 reads Kauffman's adjacent possible as it, for a prestated space.
- The note's adjacent possible is the children, one for each stem. On this growth that is what the present configuration admits, `PossibleWithin process Stem 0`.
- Read with UE10's `k = 1`, it would be the stems of the children: what can be born within two births.

Say which is meant, once.

Add to NOTE:33: "What keeps widening is what each configuration admits; every stem a course admits is possible from its start (`stem_possible_from_start`), and the whole possible never grows (UE10's `Run.possible_of_next`). The adjacent possible is read here as the children, one for each stem, what the present admits; UE10's possible within one move would be the stems of the children."

**F16 (I). Law 5's "independent" needs the other direction, and "for the one class" needs a condition.**
NOTE.md:55 ("there the two are independent").

The witness shows only the gain. The loss is probe `finer_loses`: the antichain widens `Finer.wide`, and the class continues from `0` to `2` on links in `wide` but not in the antichain. Cite it.

"Holds … for the one class" on links needs decidability (`continuation_links_one_iff`).

Fix: "… holds for continuation read on precedence, and on links within the one class where precedence is decidable; for a finer class read on links widening can add continuation (`Finer.*`) or remove it (`finer_loses`): there the two are independent."

**F17 (I). The order on courses is labelled; say so.**
NOTE.md §5; CausalGrowth.lean:53–58.

Stems are compared as sets of labels at the same offsets, so the order is not invariant under relabelling, while discrete general covariance holds that labels carry no physical meaning. Two courses that grow the same unlabelled causal set with different labels can be incomparable. For example, `2` above `0` and `2` above `1`, after two births with empty pasts, are mixed at offset 3. The extremes do not depend on the labels.

Add: "The order on courses is labelled: it compares stems as sets of labels at the same offsets, so it is not invariant under relabelling, while discrete general covariance holds that labels carry no physical meaning; the extremes do not depend on it."

**F18 (I). "Internal temporality is holding the past" folds two conditions into one.**
NOTE.md:32; CausalGrowth.lean:25–26.

`HoldsPast` contains Rideout and Sorkin's internal temporality: no new element is born below an old one. It also contains the heredity built into their transitions: the old order is unchanged.

Fix: "Internal temporality, with the parent kept as it was, is holding the past."

**F19 (S). The standing cites the wrong theorem.**
NOTE.md:75.

Birkhoff's representation concerns the lattice of down-sets of a single order. The fact used here is different: on one set, a larger order has fewer down-sets, and the principal down-sets recover the order. That is the order-reversing bijection between preorders on a set and Alexandrov topologies on it (the specialization order). Cite that; Birkhoff can stay as a neighbour.

**F20 (S). The docstring of `OmegaPlusOne.between` covers less than it says.**
CausalGrowth.lean:152 ("Every number precedes the top").

The theorem covers `some (k + 1)`; `some 0` is in `not_reach_top`.

Fix: "Every positive number lies between `some 0` and the top, so infinitely many do."

**F21 (S). "Links" has other senses in the repository.**
"Links" is causal set theory's exact word. In the repository, though, "link" also names an edge of a net (`Becoming.Cuts`), and "links" names being linked by a line in 01's World table (`Web.linked_iff_line`).

Gloss it once at `links` and in the note: "links, causal set theory's term: the covering pairs (Hasse diagram) of a relation".

**F22 (S). The readings carry no delegated-choice tag.**
07's readings carry a tag such as "[AI reading, D45]" or "[AI reading, new]". Tag NOTE:13 and :71 when they are placed. Restore DESIGN §4's naming of C in the note (F10).

## Answers to task 2

- **Faithfulness to Rideout–Sorkin.**
  - *Labelled growth:* yes. The process is on naturally labelled finite causal sets, and each move adds the element `size`.
  - *A child per stem:* yes. The action is the stem, and pointwise-equivalent stems give pointwise-equal children. No extensionality is needed or used.
  - *The new element maximal:* yes (`birth_maximal`).
  - *Internal temporality:* yes, read as `HoldsPast` together with `birth_maximal`. `HoldsPast` also holds the heredity of the parent (F18).
  - Keeping only the transition relation is right for laws that hold on every course; any stochastic dynamics on this relation inherits them.
  - The comparisons of courses are labelled, which the note should state beside "discrete general covariance is not read" (F17).
  - "Stem" for a down-set of a finite configuration agrees with the causal-set literature's stems, which are finite down-sets.
- **Scope of `stems_included_iff`.**
  - Equal sizes are needed. With unequal sizes the stem `all` of the larger fails `within` in the smaller. And if the first is smaller, its stems can be included while the second has precedence above its size.
  - "Both ordered" is more than needed but natural. The direction from stems to precedence uses the first's transitivity and labelling (for the principal stem) and the second's irreflexivity and `within`. The direction from precedence to stems needs only the equal sizes.
- **"Widening what can be born next is exactly losing precedence."**
  - Exact for inclusion (`rangeIncludes_iff`) and for the strict part of inclusion, with no decision (probe `rangeIncludes_strict_iff`).
  - Not exact for `RangeWidens` without decidability. The note's account of the asymmetry is right: the sufficient condition is an explicit pair, the necessary one is a failed inclusion at some offset. The gap is weak excluded middle (probe `deMorgan_of_pair_converse`), and it closes with decidable precedence (probe `rangeExceeds_iff_pair`).
  - "At every offset" is ambiguous, and false on one reading (F6).
- **The extremes, `alike_of_both`, `not_widens_and_continues`.**
  - All right as stated in the note's law sections, but they need "from the empty set" in the docstrings (F8) and "once the next is born" for the chain (F9).
  - They are right but near-trivial. Each is a short corollary of `stems_included_iff` and `continuation_one_iff`: the antichain has empty precedence and the chain full precedence; `alike_of_both` is antisymmetry, and `not_widens_and_continues` is irreflexivity of the strict part.
  - Within the one class, "what continues" is precedence itself, so "against what continues" is the reversal read twice, not a trade between two quantities. Continuation becomes a second quantity only for a finer class on links (law 5). The standing "near-definitional" is right; the summary should say plainly that this is one relation read twice.
- **Law 5.** Correct, and it shows a gain of a finer class's continuation by widening on links. On precedence a finer class is monotone (`continuation_of_rangeIncludes`), so it is the links that make the difference. "Independent" needs the loss direction too (F16, `finer_loses`). The class is tailored to the witness, which is legitimate for a witness.
- **ω + 1.**
  - It is a fair witness that the links reading can fail on an order that is not locally finite. The note's caveat is right: an order with infinite intervals can be the reach of its links, for instance an infinite antichain between a bottom and a top.
  - "Needs discreteness" overstates (F4).
  - ω + 1 is neither locally finite nor past-finite, so it does not separate the hypothesis the Lean uses (past-finiteness) from causal set theory's (local finiteness).
  - The module header's version is wrong as written: precedence is the reach of conditioning when conditioning is precedence (F4).

## Answers to task 3

- **Supported, overstated or mis-aimed?** Supported narrowly, mis-aimed in its conclusions (F10).
  - Read on what can be born next, the course in which nothing conditions anything is greatest, and nothing continues in it.
  - But the model settles what C is read on, a first-order matter. On what can be born next and on what continues the verdicts are exactly reversed. No strict order contains both. Read on both, nothing is widened, and every differing pair is mixed (probes P6, P8).
  - It does not reach 07's second-order direction: every course from a causal set keeps widening here, and 07's never-reverse requirement, read on stems, leaves the antichain unbeaten and confines any weighing to pairs widening leaves unranked.
  - Its 生生 must be the D1 direction, since the grammar's «生生» holds on no configuration at all (probe P5).
  - "A maximum of neither" is right once D1 is stated as the premise: against the antichain because nothing in it transmits a condition, and against the chain only with the further premise that admitting the fewest ways to go on falls short.
- **Kauffman.** The use is fair in substance. Kauffman's own Edge gloss puts internal organization behind the limit on pace. But the paraphrase drops "on average" and "may", and the antichain maximizes enlarging what can happen next (p. 209), not entering (F11). The wording was checked only through the Zygon quotation as a search reported it, and through Kauffman's Edge essay; the book was not read, as DESIGN.md already says.
- **Already in the repository?** No causal-set result exists.
  - Neighbours the note should link:
    - question 4 under L-02 in the logic review ([LOGIC.md](../../../../../../theories/becoming/review/LOGIC.md)), which law 1 answers in part (F5);
    - 01's D1 reading ([01](../../../../../../theories/becoming/chapters/01-ROOT.md#renewal-and-grains)) and the glossary's "generation never means … any new organization", for which the AI reading is a formal witness;
    - 07 §2's "生生 can exceed what widening counts, how far is open" (the paragraph "What widening counts");
    - 07 §2's "ordering a mixed part needs a measure" ([07](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-four-cases-of-a-part)), with `Weighting.mixed_either_way` (07 §4.4), which is where P8 places the comparison;
    - 07's open item on the second-order direction ([07](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#open)), which F10(b) reads on this growth;
    - UE10's adjacent possible with the present, `Reaching.PossibleWithin` with `k = 1` (F15);
    - UE11's `RaisedEveryOther`, where renewal without end and growth relative to what is held come apart; they come apart here too, every course from a causal set keeping widening while no configuration renews without end (P5).
  - None of these states the reversal or its consequence for C.

## Probes

The tree is `probes/tree/Becoming/` (a byte-identical copy of `CausalGrowth.lean`, and `CausalGrowthProbe.lean` importing it). The build command, from the package folder:

`python3 -B scratch_build.py <…>/ue13-causal-sets/probes/tree Becoming.CausalGrowthProbe`

Logs:
- `build-1.log`: elaboration errors;
- `build-2.log`: one unused-variable warning;
- `build-3.log` to `build-5.log`: clean, as laws were added;
- `build-6.log`: final, 46 theorems in 59 declarations, `with_axioms: {}`, no warning.

No `simp`, `omega`, `funext` or `Classical` is used.

| Block | Laws | Result |
|---|---|---|
| P1 | `reach_links_le`, `reach_links_iff`, `ordered_reach_links_iff`, `path_not_reach_of_links`, `links_least`, `nat_reach_links` | the equality needs transitivity (F1); the links are the least net generating the order (F5); no finiteness needed (F3) |
| P2 | `third`, `third_ordered`, `em_of_reach_third`, `searchBelow_or`, `reach_links_within_of_decided`, `reach_links_of_decided`, `reach_links_all_iff_em` | calibration: every pair of every causal set reached by links ⟺ excluded middle; deciding betweenness suffices (F2) |
| P3 | `rangeIncludes_strict_iff`, `rangeWidens_strict` | the exact, decision-free form of "widening is losing precedence" (F6) |
| P4 | `pair_of_not_included`, `rangeExceeds_iff_pair`, `stems_of_two`, `both`, `either`, `either_rangeIncludes`, `either_exceeds`, `deMorgan_of_pair`, `deMorgan_of_pair_converse` | with decidable precedence the converse holds; for every pair of courses it is De Morgan's law (F6, F7) |
| P5 | `ceases_of_bounded`, `ordered_ceases`, `ordered_not_renews`, `chainLimit`, `chainLimit_iff`, `antichainLimit`, `antichainLimit_not_renews`, `half`, `pairs`, `pairs_class`, `half_*`, `odd`, `chainLimit_renews` | no configuration renews without end; in the limits the antichain never does and the chain does under pairs (F10c) |
| P6 | `continuing`, `rangeIncludes_continuing_iff`, `rangeWidens_continuing_iff`, `rangeWidens_stems_of_continuing`, `deMorgan_of_stems_converse`, `no_order_contains_both`, `antichain_unbeaten`, `continuation_le_chain` | the two readings are reversed; no strict order contains both; 07's requirement read on stems (F10a, b) |
| P7 | `stem_possible_from_start` | what keeps widening lies in a possible that never grows (F15) |
| P8 | `formsOrContinues`, `not_rangeWidens_formsOrContinues`, `mixed_of_pair` | read on both, no course widens another; differing pairs are mixed (F10a) |
| P9 | `finer_loses` | law 5's loss direction (F16) |

Nothing outside `ue13-causal-sets/probes/` and this file was written. The probe tree's `.build/` is scratch output and can be removed once no session uses it.
