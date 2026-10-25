# UE4: the second-order direction of 生生 (design note)

25 October 2026. AI-authored design note for board item UE4 (item 7 of the [UE plan](../ue-unified-explanation/PLAN.md)). It is not a landing: results go to their records and home sections when they land, and nothing here changes a chapter. It covers five things:

- what the account already has that bears on second-order growth (§1);
- four findings that constrain every candidate (§2);
- three candidate definitions, each with its laws, a witness against plain widening and its premises (§3);
- the neighbours (§4);
- the recommendation, with a Lean kit (§5).

**The kit.** [`tree/Becoming/EventualWidening.lean`](tree/Becoming/EventualWidening.lean), built with `scratch_build.py` against the pure core: 59 theorems in 80 declarations, every axiom report empty, no warnings ([log](scratch.log)). It is a working build, not a receipt. Statements in it are cited by Lean name; anything else marked *proposed* is not proved.

**In short.** The comparison THE-CORE asks for, a range whose widening keeps widening against one merely wider now, is in widening's own terms a pair that is mixed over all steps and reversed over a first stretch, the one before the growing course overtakes. So no comparison by inclusion over all steps decides it, and whatever decides it is a premise. What can be stated with no premise is a comparison in the long run, *eventual widening*. It never runs against widening, and together with widening it is a strict partial order. A course that *keeps widening* eventually widens every course that settles within its range. Keeping widening is not kept by widening, so it can be a property but not an order. Read by name it needs formations without end. The mechanism the account's reading of 生生 names, generation generating generation, is invisible to widening: one range can be carried by its own openings or by one giver. Under named premises it is forced: support that passes on is already the account's law (`Flow.support_passes_on`). A uniform form of that law, and a law tying the mechanism to keeping widening, are proposed. Recommended first: eventual widening with keeping widening (candidate A), already in the kit; then the laws of candidate C; then candidate B where courses branch.

## 0. The question in the account's terms

- **What widening is.** `Web.Widens` compares two level paths of one web: one widens the other where at every step it admits every formation the other admits, and at some step more ([07 §2](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-four-cases-of-a-part)). Every step counts alike, and every formation is a member of a type `F` given in advance.
- **What is open.** THE-CORE names it ([What is open](../../../../../../drafts/2026-10-22-the-core/THE-CORE.md#what-is-open)): widening "does not count returning capacity or the richness of relating", and it does not yet compare a range whose widening keeps widening with one that is merely wider now. The method chapter lists, as open, a measure for mixed parts (a premise, not hidden in inclusion) and comparisons of renewal capacity and richness of relations ([08 §8.1 item 5](../../../../../../theories/becoming/chapters/08-METHOD.md)). The map lists a law relating its generation to widening ([02, open](../../../../../../theories/becoming/chapters/02-MAP.md#open)).
- **The reading at stake.** 生生 is read as generation generating generation ([D1, revision of 18 October](../../DELEGATED-CHOICES.md#d1-生生的读法--how-生生-is-read)). That revision takes the treatise's triple, state, the domain of what can become and the capacity to form, of which widening compares only the second. The source's words are 「（当前状态，可成为之域，生成能力）」 ([treatise](../../../../../../sources/06-zhishan/shengsheng/生生不息论v1/生生不息论.md)). 生生不息 is read as 生生 going on at the whole "with more still able to form", not as growth; a whole that only returns has 不息 and not 生生不息 ([D5, revision](../../DELEGATED-CHOICES.md#d5-接续与生生不息的层次--succession-and-the-level-of-生生不息)).
- **The rule.** Generation and degeneration do not overlap, so novelty is not 生生 ([07 §9](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#objections)). The ethics' scope and order stay premises: the continuation condition for scope, C for order. D1 already says that a measure of "more" which orders mixed parts is a premise beyond widening. So each candidate below is a comparison or a property with no ranking in it, and any ranking it would support is named as a premise.

## 1. What the account has

Each entry gives the Lean names, the standing, what the result carries for second-order growth, and what it does not.

**Widening and its order.**
- *Widening* (`Web.Admits`, `Web.Includes`, `Web.Exceeds`, `Web.Widens`, `Web.Keeps`, `Web.Mixed`, `Web.Widens.not_reverse`, `Web.Widens.trans`; World, no premise).
  - Carries: a one-way, transitive order of two level paths of one web; mixed pairs stay unranked.
  - Does not carry: one course across its own steps; branching; what carries the levels; kinds outside `F`. Every step weighs alike, so a gain early and a loss late leave two courses mixed.
- *The margin law* (`Flow.widens_iff_within_margin_at`, `Flow.Balances.closes_nothing`, `Flow.Balances.supported_iff_within_margin`; World, balance).
  - Carries: a part widens exactly where its net draw stays within every margin and, at some step, brings one formation more within.
  - Does not carry: whether what it brings within brings more within in turn.
- *C as what every positive weighting shares* (`Weighting.widens_iff_every_positive`, `Weighting.widens_iff_every_of_class`, `Weighting.mixed_either_way`, `Web.not_widens_of_closes`; any type, finite listings).
  - Carries: widening is exactly what every order counting each item positively ranks higher.
  - Does not carry: anything about tails. The listings are finite, so no weighting in the class sees the long run.
- *Widening as extension on a frame* (`Web.paths_extension_iff_widens`, `Web.paths_comparison_widens`).
  - Carries: C on the frame of level paths is "better is widening".
  - Does not carry: other frames, such as tails or reachable courses, on which C would be a new reading.

**Across readings, growth and stretches.**
- *Widening along a reading and over a grown world* (`Web.WidensAlong`, `Web.grow_widensAlong_iff`, `Web.grow_widens_unregistered`, `Web.attach_widensAlong_iff`; World).
  - Carries: new kinds of formation, one growth at a time; a growth keeping the old levels widens exactly where a new formation is admitted.
  - Does not carry: growth that keeps growing; a reading derived inside one unfolding for growth.
- *Widening across a stretch along a continuation* (`Web.IncludesAcross`, `Web.ExceedsAcross`, `Web.WidensAcross`, `Web.widensAcross_reidentify`, `Bud.readings`; World).
  - Carries: one course from step `T` to step `U`, unchanged by re-identification. Read along a bud, the budded formation continues its parent and adds nothing; read by name, it is new.
  - Does not carry: "keeps", since there is one stretch; a comparison of two courses.
- *Own widening* (`Flow.Balances.widens_iff_others_within`, `Flow.Balances.mixed_iff_other_beyond`): a part widening its own options widens the whole exactly where its net draw stays within the others' margins.

**The map and renewal in the grammar.**
- *Generation at two grains* (`«传»`, `«生成»`, `«守»`, `«退化»`, `«全生成»`, `«全守»`, `«有终»`, `«生成退化不并»`, `«单行则生守不并»`, `Map.Short.renews_and_ends`; root, every relation and pair of classes).
  - Carries: a pattern going on through carrying renewal, never overlapping degeneration.
  - Does not carry: widening. A relay of one carrier at a time generates and keeps the range the same, and no law relates the two ([02 §1](../../../../../../theories/becoming/chapters/02-MAP.md#map-on-the-world)).
- *Higher orders* (`«阶生成»`, `«阶全生成»`, `«阶生成则上不退化»`, `«阶全生成则上无终»`; root).
  - Carries: generation at grain `k` keeps grain `k + 1` from degenerating; a hierarchy of patterns, each going on through renewals of the next finer.
  - Does not carry: that what is generated generates more. Nested persistence is not generation generating generation.
- *On the World* (`Web.carries_iff`, `Web.passing_carries_iff`, `Web.generation_arises_late`, `Web.generation_renews_late`, `Web.itself_not_generation`, `Map.renewal_undecided`).
  - Carries: under the passing continuation, 全生成 has carriers arising at arbitrarily late steps.
  - Does not carry: the some-branch regions on the World.
- *Renewal without end in the grammar* (`«复生»`, `«生生»`, `«复生至»`, `«息»`, `«生生不息»`, `«生生即延»`; root).
  - Carries: the grammar's 生生, renewal without end.
  - Does not carry: "more". The account reads 生生 as asking more than the grammar's word ([01](../../../../../../theories/becoming/chapters/01-ROOT.md#renewal-and-grains)).

**Novelty and gain** ([02 §4](../../../../../../theories/becoming/chapters/02-MAP.md#r-where-novelty-gain-comes-from)).
- *On the levels alone* (`Web.revisits_of_bounded`, `Web.unbounded_of_new`, `World.forgets_of_bounded`): a bounded part returns, and what is new at every step passes every bound.
- *Where gain comes from* (`Flow.rise_from_rest_or_open`, `Flow.new_beyond_every`, `Web.rises_late_of_newly_supported`, `Flow.newly_supported_from_rest_or_open`, `Flow.whole_not_new_of_rest_idle`; World, the first law where stated).
  - Carries: novelty, and formations first supported without end, need gain, from the rest or across the boundary. A finite whole whose rest gives nothing net returns. This is the material precondition of any "keeps opening".
  - Does not carry: inclusion, since novelty may close things; any comparison.
- *Over the reals* (`Representation.separated_exceeds`; periphery): finitely many conditions new by a least separation pass every bound. One direction only: a defect review found "exactly where" overclaimed.
- *More without end* (`Flow.More`, `Flow.More.replenishment_unbounded`, `Flow.More.renewers_unbounded`, `Flow.More.unceasing`; World, balance).
  - Carries: more takers without end needs replenishment without bound and, with each giver bounded, givers without bound.
  - Does not carry: where the givers come from.

**Support, arising and passing on.**
- *Support comes from the supported* (`Flow.rise_given_by_supported`, `Flow.gains_from_supported`, `Flow.unsupported_stays`, `Flow.nothing_supported_stays`; World, balance, only active giving, activity needing support).
  - Carries: with nothing from beyond, what can form is opened only by what the supported give, and the end absorbs.
- *Support passes on* (`Flow.support_passes_on`; World).
  - Carries: where support is gained without end and every support is brief, it cannot be refuted that, late, a gain is given by a formation that itself gained support late. This is generation generating generation read on support, at arbitrarily late steps.
  - Does not carry: every gain; any comparison.
- *Arising and wholes* (`Web.Unceasing.activeRenewer_recurs`, `Whole.arises_within`, `Covered.needs_new`, `Web.Whole.persists_from`): unceasing arising that depletes a finite family needs renewal; a whole of brief parts lasts only through new parts.
- *A renewing and a consuming formation* (`RenewingFormation`; periphery, with `propext`, `Quot.sound` and in part `Classical.choice`; [record](../../../../../../theories/becoming/results/records/renewing-consuming-formation.md)).
  - Carries: under a supplied wear law, the consuming formation forms more at first, so a one-step count ranks it first. Past a bound, every continuation within renewal exceeds every one beyond. That is an eventual comparison, in counts, under a supplied law. The readings `Ceaseless` and `KeepsCapacity` separate the two and differ from each other.
  - Does not carry: the World; growth.

**Possibility, junctures and joint ranges.**
- *What can still be had* (`Law.reachable_absorbing`, `Law.lost_drawn`, `Branching.loss_passes_juncture`, `Branching.no_juncture_of_keeps`, `Branching.keeps_before_juncture`; any process).
  - Carries: what can be had `n` steps on is absorbing; every lost possibility passes a juncture; a choice matters only at a juncture. Within one fixed process the possible only narrows along a course.
  - Does not carry: ranges of admissions; options compared.
- *Capacity over a horizon* (`ActivationCapacity.preparation_changes_capacity`, `ActivationCapacity.release_loses_joint`; any process): preparation changes one-step capacity, and release loses joint realization at every horizon.
- *Joint ranges* (`Activation.same_marginals_lose_bundle`, `Regimes.no_comparison_through_marginals`, `Regimes.joint_separates`, `Regimes.possibility_not_realization`; any process; [07 §5](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-relational-generative-comparison)).
  - Carries: marginal possibilities cannot certify joint ones, so comparing richness of relating needs joint information.

**Finite readings and horizons.**
- *What a finite stretch decides* (`Renewable.finite_reading_includes_consumption`, `Sequences.recurs_not_refutable`, `Sequences.eventually_not_refutable`, `Ideals.open_iff_verifiable`; [02 §3](../../../../../../theories/becoming/chapters/02-MAP.md#r-becoming-finite-horizon), [03 §5](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-what-a-finite-stretch-verifies)).
  - Carries: a reading fixed by a finite prefix that includes every renewing run includes a consuming one; recurrence is neither verifiable nor refutable.
- *What near-term weighting does* (`Optimum.frontier_exhausts`, `Optimum.frontier_holds`; [05 §7](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-a-weighting-faster-than-renewal-ends-the-base)).
  - Carries: weighting later draws down faster than any level renews makes every optimum end its stock at once. This is the near-term pole of the trade the long run poses.

**Open items and readings.**
- **07 §2:** read as generation generating generation, 生生 can exceed what widening counts, and how far is open ([widening along a reading](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-widening-along-a-reading)).
- **07 §9:** an expansion producing ever more novelty is not thereby generative. An expansion that ends forms of life is mixed with a course keeping them.
- **T8:** it falls to a mixed case argued better from every standpoint counting everything, with no further premise ([07 §8](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#theses)).
- **02, open:** "more shared and more responsive renewal" forbids nothing measurable as stated.

## 2. Four findings before any candidate

**F1. The comparison asked is mixed over all steps and reversed over a first stretch.** In the kit's witness (`OwnCondition`), each formation `n` requires only its own condition `n`, at need one. `rising` admits at step `t` the formations up to `t`. `burst` admits formations `0` and `1` at step `0` and nothing after. Up to step `0` the burst widens the rising course (`OwnCondition.burst_widens_now`); over every step the two are mixed (`OwnCondition.mixed`). So plain widening is silent over the whole run, and read over a first stretch that ends before the growing course overtakes, it favours the course merely wider now. No inclusion comparison over all steps decides the pair, and whatever decides it orders a mixed pair, which is a premise ([D1](../../DELEGATED-CHOICES.md#d1-生生的读法--how-生生-is-read)). The account met the same shape in counts: a consuming formation forms more at first, a renewing one more past a bound (`RenewingFormation`).

**F2. A property of a course's own trajectory is not kept by widening.** `full` admits everything throughout. It widens the rising course, which keeps widening by name, while `full` keeps widening from no step (`OwnCondition.not_monotone`). So no order ranking every course that keeps widening above every course that does not agrees with widening. The same holds for capacity (candidate B's witness): a course can realize more at every step and keep fewer possible courses. A coherent second-order order is a strengthening or a long-run form of widening, or it is ranked after widening by a named premise.

**F3. No finite stretch decides a second-order verdict.** Whatever a level path does up to step `h`, following `l'` after `h` gives no eventual widening of `l'` (`Web.not_eventually_of_splice`). Where something eventually widens `l'`, following that after `h` gives one (`Web.eventually_of_splice`). Keeping widening has the shape of recurrence (after every step, a later step). Such verdicts are decided, where at all, by a law of the courses: renewal, gain, or a determined law over listed configurations, where every course enters a cycle (`Law.enters_returning_within`) and the cycles decide. Observation of a stretch does not decide them. This is 03's point that induction is resolved into laws, applied to the second order [AI reading].

**F4. Widening without end, read by name, needs formations without end, and with fixed requirements it needs gain without bound.** Where a list holds every formation, no range read by name keeps widening (`Web.KeepsWidening.not_listed`). With requirements fixed within a finite family of conditions, formations first supported without end make the family pass every bound, given from the rest or across its boundary (`Web.rises_late_of_newly_supported`, `Flow.newly_supported_from_rest_or_open`; the bridge from keeping widening is proposed in §3.1). In bounded amounts, then, widening without end needs formations whose requirements reach beyond every fixed finite family of conditions: new kinds of formation and of condition. The witnesses below escape this way, each formation having a condition of its own. That is the treatise's 「世界能否继续发现新的形成方式」, whether the world can keep finding new ways of forming [AI reading]. Since D5 does not read 生生不息 as growth, the second-order direction cannot simply be "keeps widening". It is a comparison in the long run (A), or kept capacity (B), or a mechanism with laws (C).

## 3. Candidates

### 3.1 Candidate A: the long run (widening without end, eventual widening, keeping widening)

**Statement** (World, any web `W : Web F C`, level paths `l l'`; all in the kit).
- `l` *eventually widens* `l'` where from some step on it admits everything `l'` admits, and at arbitrarily late steps something more (`Web.EventuallyWidens`, from `Web.IncludesFrom` and `Web.ExceedsLate`).
- `l` *widens `l'` without end* where it includes it at every step and exceeds it at arbitrarily late steps (`Web.WidensWithoutEnd`).
- One course *keeps widening* from `T` along a continuation `R` where nothing admitted is lost across any stretch from `T` on (`Web.HoldsFrom`) and, after every step, something is admitted that continues nothing admitted then (`Web.KeepsOpening`; `Web.KeepsWidening`).
- A course *settles* from `T` where it admits, at each later step, exactly what it admits at `T` (`Web.SettlesFrom`).

**Relation to `Web.Widens`.**
- Widening without end is widening and eventual widening (`WidensWithoutEnd.widens`, `WidensWithoutEnd.eventually`).
- Eventual widening is irreflexive, transitive and one-way (`EventuallyWidens.irrefl`, `.trans`, `.not_reverse`). It never reverses widening or keeping the same (`EventuallyWidens.not_included`, `Widens.not_eventually_reversed`).
- Inclusion composes with it on either side (`Includes.trans_eventually`, `EventuallyWidens.trans_includes`), so *widening or eventual widening* is irreflexive and transitive (`Web.WidensOrEventually`, `.irrefl`, `.trans`). The two can be held together.
- It decides some pairs widening leaves mixed (F1) and none that widening decides.
- Keeping widening is one course across its own steps, built on `Web.WidensAcross`, and is not monotone in widening (F2).
- Eventual widening is not an extension on the frame of level paths, so C read there does not give it [AI reading].

**Relation to the map's generation.** Keeping widening and 生成 are independent [AI reading; witnesses proposed]. A relay of one carrier at a time is 全生成 under the passing continuation (`Map.Endless.generation`, `Web.generation_arises_late`). By name its range does not hold, and along the passing continuation it keeps the range the same. A growing set of formations that never end widens with no carrying renewal. A course that ends is outlasted: a course admitting something at arbitrarily late steps eventually widens one that admits nothing from some step on (`Web.eventually_of_vanishing`). On the World, under balance, only active giving and activity needing support, once nothing is supported, nothing is supported again while requirements do not loosen (`Flow.nothing_supported_stays`). The actual levels of such a world then admit nothing, and any course that keeps admitting eventually widens them. That is the link to degeneration a lifting would state.

**Relation to novelty and gain.** Keeping widening holds by construction: nothing admitted closes. So it is not mere novelty, and 07 §9's objection does not reach it. By name, over a listed type, it is impossible (`KeepsWidening.not_listed`, via `KeepsWidening.gathers`). With fixed requirements it needs gain without bound (F4). Eventual widening needs no growth: a steady course eventually widens a collapsing one.

**First laws.**
- *Proved in the kit*: all the laws above.
  - `KeepsWidening.later`: keeping widening holds from every later step.
  - `keepsWidening_reidentify`: keeping widening is the continuation's, unchanged by re-identification.
  - `KeepsWidening.eventually_widens`: a course keeping widening by name eventually widens every course it includes from some step on and that settles. This is THE-CORE's comparison as a law, in the case where the merely wider range settles within the other's range.
- *Proposed, next*: the bridge to gain, the bridge to givers, and the long run along a reading.
  - **Gain.** Keeping widening by name on the actual levels, with requirements fixed in a finite family, makes the family rise at arbitrarily late steps, and under the first law it is given from beyond. To use `Web.rises_late_of_newly_supported` the openings must be scheduled. Building a schedule from the after-every-step form needs a choice of witnesses, or a search where support is decided at each step and the formations are enumerated (`Becoming.Onward`'s searched moves). This is a calibration point, not a gap. A proof through finite lists avoids both.
  - **Givers** (stated with candidate C).
  - **Along a reading.** Eventual widening along a reading (`Web.WidensAlong`'s analogue), for growth by new kinds.

**Witness against plain widening** (kit, `OwnCondition.disagreement`).

| Pair | Plain widening, every step | Plain widening, up to step 0 | Candidate A |
|---|---|---|---|
| `rising`, `burst` | mixed | the burst widens the rising course | `rising` eventually widens `burst`; `rising` keeps widening by name, `burst` from no step |
| `full`, `rising` | `full` widens `rising` | `full` widens `rising` | `rising` keeps widening, `full` from no step (`OwnCondition.not_monotone`) |

**Premises.**
- Definitions: none beyond the representation. They read admission only, on one web, over the natural-number step index. "Arbitrarily late" presupposes an unbounded index, a commitment of the representation; on a world that ends, eventual widening is empty.
- Keeping widening: a continuation `R`, supplied or read by name; naming is a commitment.
- The gain bridge: the first law, requirements within a finite family, natural-number amounts, and a schedule or decided support.
- To rank: a premise beyond C, here labelled **C∞**: where widening leaves two courses mixed, the one that eventually widens the other is better. Its cost is exact. It overrides every finite stretch, lexically: the inclusion form of an overtaking criterion with no discount (von Weizsäcker 1965; Gale 1967). It is the far pole of the trade whose near pole `Optimum.frontier_exhausts` shows draining. It lies outside the orders C is characterized by (`Weighting.widens_iff_every_of_class`), since finite listings see no tail. It must be ordered against J1: a course that loses basic conditions over a long first stretch and gains one formation forever would rank above one that keeps them, unless J1 comes first. Under the continuation condition the early losses count (scope); C∞ decides how they trade (order). C∞ is not proposed for adoption; this note only names it.

**Standing.** Laws proved for every web, in the pure core (kit); the witnesses are constructions. C∞ is a candidate premise, unwarranted.

### 3.2 Candidate B: capacity (widening of what can be reached)

**Statement** (proposed). Take a process `P : Process S A` whose configurations carry levels `lev : S → C → Nat`, read through a web `W`, with the courses from a configuration being the runs starting there. For simplicity, the web's requirements do not depend on the step, or courses are aligned at the step of comparison.
- `s` *covers* `s'` where every course from `s'` is included, step for step, by some course from `s`.
- `s` *widens what can be reached* over `s'` where it covers it and some course from `s` is included by no course from `s'`.

This is a comparison of ranges by the ranges they make reachable: the order on families of ranges in which each member of the second family is included by a member of the first.

```lean
def Reach.Covers (P : Process S A) (W : Web F C) (lev : S → C → Nat) (s s' : S) : Prop :=
  ∀ r' : Run P, r'.state 0 = s' → ∃ r : Run P, r.state 0 = s ∧
    W.Includes (fun t => lev (r.state t)) (fun t => lev (r'.state t))
def Reach.Widens (P : Process S A) (W : Web F C) (lev : S → C → Nat) (s s' : S) : Prop :=
  Reach.Covers P W lev s s' ∧ ∃ r : Run P, r.state 0 = s ∧ ∀ r' : Run P, r'.state 0 = s' →
    ¬ W.Includes (fun t => lev (r'.state t)) (fun t => lev (r.state t))
```

**Relation to `Web.Widens`.** On a determined law, with one course from each configuration, it is widening of the two courses (proposed, `Reach.widens_iff_of_determined`). With branching it compares options, not histories. A configuration can cover another strictly while their realized courses keep the same, or while the other's realized course widens its own. The second case is the conflict of F2. Read as the union of what is possible one admission at a time, it would lose joint structure. Two configurations with the same possible admissions can differ in which they can have together (an instance of `Activation.same_marginals_lose_bundle`). So the reach must be read as whole ranges, and this is where it reads the richness of relating.

**Relation to the map's generation.** The map's regions are branch notions: going on along some branch, ending on every branch. The diachronic form of B, a widening reachable from every configuration along some branch, has the shape of 生成 with "a widening ahead" in place of "a carrying renewal ahead" [AI reading; proposed].

**Relation to novelty and gain.** Kept capacity needs no realized growth: "more still able to form" (D5) is the modal reading, not growth [AI reading]. Realizing it without end along a branch needs what A needs along that branch.

**First laws (proposed).**
- `Reach.Covers` is a preorder; `Reach.Widens` is irreflexive and transitive.
- On determined laws it coincides with widening of the courses.
- *The possible only narrows.* Within one fixed process, the courses from a later configuration of a course are tails of courses from the earlier one, so capacity over every horizon is kept or lost along a course, never gained. Every loss passes a juncture (from `Law.reachable_absorbing`, `Branching.loss_passes_juncture`). So only the possible within a horizon can grow along a course, and only through what becomes actual. At horizon one this is the adjacent possible.
- Marginals do not certify joint ranges (instance of `Regimes.no_comparison_through_marginals`).

**Witness against plain widening** (proposed, small). From configuration E one course admits formations `0` and `1` at every step. From configuration K two courses: one, realized, admits `0` at every step; the other admits `0` and `1` at step `0` and the formations up to `t + 1` at step `t`. E's realized course widens K's realized course. K covers E, through its unrealized course, and that course is included by no course from E. A tie version: the same realized course from both, with one configuration keeping an unused alternative. Plain widening keeps the same and B separates them.

**Premises.**
- A process of alternatives: in 01's terms a net of possibilities, a commitment of the representation.
- Runs that exist from each configuration: building them needs dependent choice in general (`runs_iff_dependentChoice`).
- The reading that unrealized courses count, D1's capacity to form [AI reading].
- To rank: C read on the frame of reachable courses, labelled **C◇** (option value in inclusion form). The exhaustion witness shows C on realized courses and C◇ ranking the same pair opposite ways, so holding both needs a lexical rule, itself a premise: realized first, with capacity breaking ties; or capacity first.

**Standing.** Proposed throughout.

### 3.3 Candidate C: generation generating generation (openings that were opened)

**Statement** (World, flow `L`, web `W`; in the kit). A flow's range is *opened by the opened* from `T` where every gain of support after `T` meets one condition. It is given, to a condition the gainer requires after the step, by a supported formation taking part, which itself gained support after `T`, earlier (`Flow.OpenedByOpened`). The growth of what can form is then carried by what came to be able to form. A stronger variant reads each opened formation as a part and asks it to widen against its own withholding. That needs withheld levels for every opened formation, which in natural numbers need not exist, so the gain-of-support form is the one to state first.

**Relation to `Web.Widens`.** One opening is the one-step, one-giver face of the margin law: a net give bringing one formation within [AI reading]. Being opened by the opened is a property of what carries a range, so it ranks nothing and cannot run against widening. It is invisible to widening, which reads levels only: on one web whose levels are the rising course, the relay and the single giver both balance, with only active formations giving and activity needing support. In the relay each formation gives the next its unit; in the other, one formation gives every unit. The relay's range is opened by the opened and the single giver's is not, while every admission is the same (`OpeningChain.carried`, with `OpeningChain.flow_opened`, `OpeningChain.sun_not_opened`, `OpeningChain.level_rising`). Neither flow meets the first law: each unit is given from nothing. With the rest counted as a relatum (`Flow.withImbalance`) the rest gives each unit, as F4 says it must.

**Relation to the map's generation** (proposed). Read the World with occurrences `(t, f)` as carrier, as `Becoming.MapInstances` does. Take as 缘 the relation from `(t, g)` to `(t + 1, f)` where `g`, supported, gives to a condition `f` requires and `f` gains support across the step. Take the coarse class "supported or not" and the fine class "the same formation". An opened occurrence begins a fine line, since nothing of its own formation opened it. So an opening chain in which every occurrence reached opens another is 全生成 at those grains. That would be the first law relating the map's generation to widening, through local openings. It answers part of 02's open item.

**Relation to novelty and gain.** Every opening is a rise of a required condition where requirements do not loosen (`Web.GainsSupport.rises`). A chain without end, with requirements fixed in a finite family, passes every bound and is fed from beyond. The relay escapes only because every formation has a new condition of its own.

**First laws.**
- *Proved in the kit*: the definition and the witness pair above.
- *Proposed*:
  - **Forced by brevity**, a uniform form of `Flow.support_passes_on` with the same proof. Under balance, only active giving, activity needing support, requirements never loosening, and every support lasting at most `K` steps: every gain after step `T + K` is opened, up to double negation, by a formation that gained support after `T`. Where the generators are brief, whatever opens was opened.
  - **Givers multiply.** Suppose a course keeps widening by name on the actual levels, every supported formation takes at least a unit a step from a balanced family `cs` (upkeep), and each giver gives `cs` at most `g`. Then the number of givers to `cs` is bounded from no step on. The route: `KeepsWidening.gathers` and `Web.HoldsFrom` give, for every `K`, `K` formations supported from some step on; upkeep makes them takers, which is `Flow.More cs`, and `Flow.More.renewers_unbounded_from` concludes. It needs a count lemma, distinct takers bounding `count` from below, with equality of formations decided or a double negation. This is the law that joins A to C: under upkeep, widening without end needs its generators to multiply.
  - **The map law above.**
- *Witnesses* (proposed):
  - A giver from beyond (`Restoring.Inflow`) widens at first order while its openings open nothing.
  - A closed pair, each formation giving to the other's condition, is opened by the opened and keeps the range the same. That is 不息 without 生生不息 (D5), so C alone is not the direction [AI reading].

**Premises.**
- The definition: none beyond the representation.
- The brevity law: balance, only active giving, activity needing support, requirements not loosening, brief support.
- The givers law: balance, upkeep, bounded capacity per giver, and decided equality for counting.
- To rank: none is proposed. A tumour line, or a capture loop reproducing its carriers, can be opened by the opened while closing what it draws on; that is 05's meta-attractor case. So carried-by-openings must not rank by itself, and joined to widening it adds no order widening lacks [AI reading]. C's place is the laws: what keeping widening needs, and what forces generation generating generation.

**Standing.** Definition and witness proved (kit); the laws proposed.

### 3.4 How the three meet

| What THE-CORE says widening omits | Read by |
|---|---|
| a range whose widening keeps widening, against one merely wider now | A: eventual widening for the comparison, keeping widening for the property |
| returning capacity | A's `Web.HoldsFrom` on the actual levels: nothing that can form loses support. The return grades of 02 (`Web.consumed_iff`) are the finer reading |
| richness of relating | B's whole reachable ranges (joint, not marginal) and C's relation of opening |
| the capacity to form (D1's third component) | B (kept capacity) and C (what carries the range) |

The laws join them: A's keeping widening with upkeep forces C's givers to multiply, brevity forces C's chain, and B says the possible grows only within a horizon and only through the actual. Read with the treatise's tests of 不息 [AI reading]:
- 「不耗尽自身赖以存在的条件」, not exhausting one's own conditions, is A's holding;
- 「能把可继续生成的世界交给后来者」, handing on a world that can keep generating, is B's kept capacity;
- 「使新的生成者仍能出现」, that new generators can still appear, is C.

## 4. Neighbours

The literature is from prior knowledge, checked where noted; it was not read in full for this note. The placements in the last three columns are AI readings.

| Neighbour | In its own terms | What it would contribute | What the account adds | What the account forbids that it leaves open |
|---|---|---|---|---|
| The adjacent possible (Kauffman, *Investigations*, 2000) | The adjacent possible holds what is one step from the actual, such as molecular species one reaction away; the biosphere enters it, by a conjectured "fourth law", about as fast as it can sustain; the possible grows with the actual and cannot be stated in advance. The TAP equation (Cortês, Kauffman, Liddle and Smolin, arXiv 2204.14115) models combinatorial innovation: a long plateau, then an explosive rise. Autocatalytic (RAF) sets (Hordijk and Steel 2004) are sets each of whose reactions is catalysed from within | that the possible is second-order (what can come next depends on what is now); combinatorial growth laws; autocatalytic closure as a mechanism | the adjacent possible as reach within horizon one (B), growing only through the actual and only within a horizon; "cannot be stated in advance" as growth beyond `F` (`Web.WidensAlong`); the fourth law's "sustain" as A's holding; no agent at the centre; every ranking premise named | within one fixed process, the possible over every horizon growing along a course (it narrows, and every loss passes a juncture); entering the adjacent possible without end, with fixed requirements in a finite family, without gain from beyond (F4); a closed autocatalytic set widening (it returns: C's closed pair) |
| Assembly theory (Sharma, Czégel, Lachmann, Kempes, Walker and Cronin, *Nature* 622, 2023; definitions checked against the published text) | An object's assembly index is the least number of joining steps from basic blocks, reusing what was built. Assembly `A = Σᵢ e^{aᵢ}(nᵢ − 1)/N_T` over distinct objects of index `aᵢ` and copy number `nᵢ`, `N_T` objects in all, quantifies the selection needed to produce an ensemble. Discovery grows as `dN_{a+1}/dt = k_d N_a^α`: with `α = 1` every past object is reused, history without selection; `α < 1` means selection. Discovery and production timescales comparable is where selection and open-ended growth are expected. Its methods are contested (Uthamacumaran et al. 2024; Abrahão et al. 2024; reply, Kempes et al., arXiv 2406.12176) | a measured trace of reuse, generation generating generation recorded in objects; a regime parameter (discovery against production) the account lacks; an empirical programme (mass spectrometry) | AT measures what was made, the account compares what can form; reuse read as copying under draws (04: a copy is produced where the pool holds its tokens and the support covers its draws); selection read through couplings. Assembly is a scalar, so as a measure of 生生 it would be a premise that orders mixed cases, and it rewards copy number, which capture also raises | high-index objects in high copy number without pool and support covering the draws (04's copying laws); a rise of Assembly certifying widening: a lock reproducing complex carriers while narrowing what can form is a witness to build (closed capture with copying) |
| Open-endedness in artificial life (Bedau and Packard's evolutionary activity statistics, 1992 and after; Taylor et al., *Artificial Life* 22, 2016; Banzhaf et al., *Theory in Biosciences* 135, 2016; Adams, Zenil, Davies and Walker, *Scientific Reports* 7, 2017) | Activity statistics with neutral shadow runs measure adaptive novelty that persists. Banzhaf et al. class novelty as variation, innovation and emergence: within the model, needing a new model, needing a new meta-model. Adams et al. define unbounded evolution as non-repeating within the recurrence time of an isolated system, and find that rules depending on the state are the mechanism that scales | operational tests with neutral controls; the three kinds of novelty; the result that the rules must change with the state | widening without end is not novelty without end (keeping widening loses nothing admitted, by construction); Banzhaf's three kinds read as widening within `F`, growth of `F` and growth of the reading itself; the comparison is a partial order, not a scalar | open-ended novelty in a bounded closed simulation whose rest gives nothing (it returns, `Flow.whole_not_new_of_rest_idle`; never revisiting needs a carrier no list holds, `unlisted_of_new`). A thesis to freeze: in bounded closed simulations activity plateaus unless inflow or new kinds enter. Adams et al.'s mechanism matches the account's rules that change themselves (02 §9) and its gap, self-changing conditions |
| Option value (Weisbrod 1964; Arrow and Fisher 1974; Henry 1974; Kreps 1979; Dixit and Pindyck 1994) | Keeping an irreversible option has value under uncertainty (quasi-option value: learning before committing). Kreps represents a preference over menus that is monotone in inclusion as uncertainty about future preferences | a decision theory under uncertainty; valuation; Kreps's account of why flexibility is preferred | B is Kreps's menu inclusion lifted to courses, with no probability and with joint ranges; option value is lost only at junctures; the conflict between realized widening and kept capacity, with the premise that decides it named (C◇ and a lexical rule) | option value gained along a course within one fixed process; joint options certified from marginal ones (`Regimes.no_comparison_through_marginals`) |

Two further neighbours bear on the premises. *Evolvability* (Wagner and Altenberg 1996; Kirschner and Gerhart 1998) is the capacity to generate selectable variation, generation generating generation in biology; C's laws are its material conditions. *Infinite-horizon social choice*: an order of infinite streams that is complete and satisfies Pareto and anonymity cannot be represented (Diamond 1965; Basu and Mitra 2003). Widening or eventual widening contains widening, so it satisfies strong Pareto. It is incomplete, which is how it stands beside those results, and why C∞ decides only nested tails [AI reading].

## 5. Recommendation

**Formalize candidate A first: eventual widening as the comparison, keeping widening as the property, and the law joining them.** The reasons:

1. It is the comparison THE-CORE asks for, and F1 shows its exact logical place. It separates a pair that widening leaves mixed, with no premise in the definition; ranking by it is C∞.
2. It is coherent with C by theorem (`Widens.not_eventually_reversed`, `WidensOrEventually.trans`), where keeping widening and kept capacity are not (F2).
3. Its laws join results the account already has: listing (`length_le_of_sub`), the finite-stretch limits (03), and, next, gain (`Gain`) and givers (`Flow.More`).
4. It is small, constructive and in the pure core, and it is built (the kit).
5. C's laws build on it: givers multiply needs `Web.KeepsWidening`.

**The first Lean statements** (kit module `Becoming.EventualWidening`; imports `Becoming.ContinuedClasses`, `Becoming.Regions`, `Becoming.Population`; a leaf joined to the spine through `Web.Widens` and `Web.WidensAcross`).

| Statement | Meaning |
|---|---|
| `Web.EventuallyWidens (W : Web F C) (l l' : Nat → C → Nat) : Prop` | from some step on `l` includes `l'`, and exceeds it at arbitrarily late steps |
| `Web.WidensWithoutEnd W l l'`, `Web.WidensOrEventually W l l'` | widening exceeding at arbitrarily late steps; widening or eventual widening |
| `Web.KeepsWidening W (R : Nat → F → F → Prop) l (T : Nat) : Prop` | from `T` on, along `R`, nothing admitted is lost and something keeps being opened |
| `EventuallyWidens.trans`, `EventuallyWidens.irrefl` | a strict partial order |
| `Widens.not_eventually_reversed : W.Widens l l' → ¬ W.EventuallyWidens l' l` | it never runs against widening |
| `WidensOrEventually.trans` | the two can be held together |
| `not_eventually_of_splice`, `eventually_of_splice` | no first stretch verifies or refutes it |
| `KeepsWidening.not_listed : (∀ f, f ∈ fs) → ¬ W.KeepsWidening itself l T` | over a listed type no range read by name keeps widening |
| `KeepsWidening.eventually_widens : W.KeepsWidening itself l T → W.IncludesFrom T₁ l l' → W.SettlesFrom l' T₂ → W.EventuallyWidens l l'` | keeping widening outlasts a range that settles |
| `OwnCondition.disagreement`, `OwnCondition.not_monotone` | the witness of F1 and F2 |
| `Flow.OpenedByOpened`, `OpeningChain.carried` | C's property, and one range with two carriers |

**Next, in order.**
1. The gain bridge for A, by finite lists (imports `Becoming.Gain`).
2. Givers multiply (imports `Becoming.Flow`; needs the count lemma).
3. The brevity law for C (imports `Becoming.Admission`).
4. The map law for C (imports `Becoming.MapInstances`, `Becoming.GrammarMap`).
5. Eventual widening along a reading, for growth by new kinds (imports `Becoming.Growth`).
6. B's definitions, their determined case and the exhaustion witness (imports `Becoming.Junctures`, `Becoming.Bundles`).

Each item would be claimed on the board, as the UE4 row already allows, reviewed independently before landing, and stated in a record with its home in 07 (the order) or 02 (the map law).

**What would show the definition wrong.**
- *Too narrow.* A pair that every reading argued from the work counts as "keeps widening against merely wider now", where the growing course widens in other directions and never comes to include the other. Eventual widening is silent there. A verdict would need a measure trading across formations, a premise of another kind than C∞.
- *Wrongly placed.* An argument from the work that the second order of 生生 lies in capacity or in carriers, not in the long run. Then A stays a component and the direction is B or C. The recommendation is staged for that reason.
- *A premise failing, not the definition.* A case argued better from every standpoint counting everything in which the course eventually narrower is better: long first stretches keeping basic conditions, against one formation gained forever. That refutes C∞ and leaves eventual widening standing as a comparison.
- *An epistemic claim failing.* F3 says no finite stretch decides the verdict without a law of the courses. That reading would be refuted by a theorem showing that, under the World premises alone and with no list of configurations, a finite stretch of two courses decides whether one eventually widens the other. The splice laws are proved for arbitrary level paths, which need not be courses of such a world.

## 6. What this note does not claim

- That any candidate is 生生, or that its ranking premise (C∞, C◇) is warranted. Both are named and not proposed for adoption.
- That actual unfoldings keep widening, keep capacity, or are carried by their openings.
- Anything about branching courses beyond the proposals of §3.2, or over real amounts and continuous time.
- A finished comparison with the neighbours: §4 is a first placement, and the containment UE asks for, premises on the card, instance theorems and a forbidden statement each, would follow item 7 of the UE plan.

The readings marked [AI reading] are the AI's and change no theorem.
