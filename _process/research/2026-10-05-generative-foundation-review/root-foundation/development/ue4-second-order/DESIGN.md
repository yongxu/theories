# UE4: the second-order direction of 生生 (design note)

25 October 2026. AI-authored design note for board item UE4 (item 7 of the [UE plan](../ue-unified-explanation/PLAN.md)). Revised the same day against the independent review ([REVIEW-UE4](REVIEW-UE4.md): 3 errors, 6 overclaims, 15 imprecisions, 5 suggestions). Every finding is taken, and §7 maps each one to its answer. The first version is at commit `92f41c5bf`. What lands, and what stays design, is in [LANDING.md](LANDING.md). This note changes no chapter or record.

**The kit.** Two modules in [`tree/Becoming/`](tree/Becoming/), built with `scratch_build.py` against the pure core ([log](scratch.log)), every axiom report empty, no warnings:
- [`EventualWidening.lean`](tree/Becoming/EventualWidening.lean): 25 theorems in 38 declarations.
- [`EventualWideningInstances.lean`](tree/Becoming/EventualWideningInstances.lean): 77 theorems in 98 declarations.

It is a working build, not a receipt. Lean names below are the kit's or the package's; anything marked *proposed* is not proved.

## What is captured, and what is not

**The second-order direction of 生生, a range whose widening keeps widening compared with one merely wider now, is still not captured.** The kit formalizes the long run of widening and sustained widening, not growth of the widening itself:
- **Eventual widening is first order.** It is first-order widening read on late tails: `l` eventually widens `l'` where, from some step on, `l` widens `l'` on every tail (`Web.EventuallyWidens`). It needs no growth: a steady course eventually widens one that collapses (`Web.eventually_of_vanishing`).
- **It is silent on a lag.** A course that keeps widening, and admits every formation of another from one step later forever, is mixed with it in every tail (`LagWitness.lag`).
- **Keeping widening is a property, not an order.** Its first half, nothing lost along a continuation, is refuted by a finite stretch, and widening does not keep it (`OwnCondition.not_monotone`).
- **The second-order content lies elsewhere**, in what carries a widening (candidate C) and in what a course keeps possible (candidate B), and neither has laws yet.

**What the kit does give.**
- *The comparison in the long run, with its exact place.* It is premise-free and never reverses widening. With widening it is a strict partial order. No finite stretch verifies or refutes it.
- *Keeping widening, as a property.* With it, THE-CORE's pair in the one case a law reaches: a course keeping widening eventually widens a range that admits alike on what it admits at some step (`Web.KeepsWidening.eventually_widens_of_within`).
- *What carries a range is invisible to widening.* One range can be carried by a relay of openings or by one giver (`OpeningChain.carried`). Being opened by the opened is possible with no widening at all (`ClosedCycle.cycle`).

Every law of the kit is near-definitional (§3.1, *Standing*).

**What the next attempt would need.**
1. **A second-order object.** What a course keeps reachable (B), or what carries its openings (C), with an order on it that never reverses widening and counts neither novelty nor scale.
2. **A first law tying that object to the World's premises.** The gain bridge or the givers law (§3.1, §3.3) are the first candidates, and the first candidates for a result no neighbouring field states, which is UE's purpose for this item.
3. **A witness where it and eventual widening disagree.** The lag (`LagWitness`) is the case a second-order comparison should decide and eventual widening cannot.
4. **Growth beyond a fixed type of formations.** Within one type, by name, no range keeps widening (`Web.KeepsWidening.not_listed`). Growth by kinds that are not given in advance needs self-changing conditions, which the grammar cannot yet state ([UE plan §5](../ue-unified-explanation/PLAN.md#5-the-structural-gaps)).

## 0. The question in the account's terms

- **What widening is.** `Web.Widens` compares two level paths of one web: one widens the other where at every step it admits every formation the other admits, and at some step more ([07 §2](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-four-cases-of-a-part)). Every step counts alike, and every formation is a member of a type `F` given in advance.
- **What is open.** THE-CORE names it ([What is open](../../../../../../drafts/2026-10-22-the-core/THE-CORE.md#what-is-open)): widening "does not count returning capacity or the richness of relating", and it does not yet compare a range whose widening keeps widening with one that is merely wider now.
  - The method chapter lists, as open, a measure for mixed parts (a premise, not hidden in inclusion) and comparisons of renewal capacity and richness of relations ([08 §8.1 item 5](../../../../../../theories/becoming/chapters/08-METHOD.md)).
  - The map lists a law relating its generation to widening ([02, open](../../../../../../theories/becoming/chapters/02-MAP.md#open)).
- **The reading at stake.** 生生 is read as generation generating generation ([D1, revision of 18 October](../../DELEGATED-CHOICES.md#d1-生生的读法--how-生生-is-read)). That revision takes the treatise's triple, state, the domain of what can become and the capacity to form, of which widening compares only the second; the source's words are 「（当前状态，可成为之域，生成能力）」 ([treatise](../../../../../../sources/06-zhishan/shengsheng/生生不息论v1/生生不息论.md)). 生生不息 is read as 生生 going on at the whole "with more still able to form", not as growth ([D5, revision](../../DELEGATED-CHOICES.md#d5-接续与生生不息的层次--succession-and-the-level-of-生生不息)).
- **The rule.**
  - Generation and degeneration do not overlap, and 07 §9 answers that 生生 is not novelty or scale ([07 §9](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#objections)).
  - The ethics' scope and order stay premises: the continuation condition for scope, C for order. Widening *orders* courses with no premise; C *ranks* a course as better. D1 already says that a measure of "more" ordering mixed parts as better is a premise beyond widening.
  - So each candidate below is a comparison or a property with no ranking in it, and any ranking it would support is named as a premise.
- **Where the candidates stand.** Candidate A formalizes the long run and sustained widening, not growth of the widening itself; the second-order content is C's and B's.

## 1. What the account has

Each entry gives the Lean names, the standing, what the result carries for second-order growth, and what it does not.

**Widening and its order.**
- *Widening* (`Web.Admits`, `Web.Includes`, `Web.Exceeds`, `Web.Widens`, `Web.Keeps`, `Web.Mixed`, `Web.Widens.not_reverse`, `Web.Widens.trans`; World, no premise).
  - Carries: a one-way, transitive order of two level paths of one web; mixed pairs stay unranked.
  - Does not carry: one course across its own steps; branching; what carries the levels; kinds outside `F`. Every step weighs alike, so a gain early and a loss late leave two courses mixed.
- *The margin law* (`Flow.widens_iff_within_margin_at`, `Flow.Balances.closes_nothing`, `Flow.Balances.supported_iff_within_margin`; World, balance).
  - Carries: a part widens exactly where its net draw stays within every margin and, at some step, brings one formation more within.
  - Does not carry: whether what it brings within brings more within in turn.
- *C as what every positive weighting shares* (`Weighting.widens_iff_every_positive`, `Weighting.widens_iff_every_of_class`, `Web.widens_iff_every_weighting`, `Weighting.mixed_either_way`, `Web.not_widens_of_closes`; any type, finite listings).
  - Carries: widening is exactly what every order counting each item positively ranks higher.
  - Does not carry: anything about tails. On level paths it needs both courses' admissions listed (`Web.ListsAdmitted`), and a course so listed eventually widens nothing (`Web.not_eventually_of_listed`, kit).
- *Widening as extension on a frame* (`Web.paths_extension_iff_widens`, `Web.paths_comparison_widens`).
  - Carries: C on the frame of level paths is "better is widening".
  - Does not carry: other frames, such as tails or reachable courses, on which C would be a new reading.

**Across readings, growth and stretches.**
- *Widening along a reading and over a grown world* (`Web.WidensAlong`, `Web.grow_widensAlong_iff`, `Web.grow_widens_unregistered`, `Web.attach_widensAlong_iff`; World).
  - Carries: new kinds of formation, read along a supplied reading of one type in another, one growth at a time.
  - Does not carry: growth that keeps growing; kinds not given in advance.
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
  - Does not carry: that what is generated generates more. Nested persistence is not D1's reading [AI reading].
- *On the World* (`Web.carries_iff`, `Web.passing_carries_iff`, `Web.generation_arises_late`, `Web.generation_renews_late`, `Web.itself_not_generation`, `Map.renewal_undecided`).
  - Carries: under the passing continuation, 全生成 has carriers arising at arbitrarily late steps.
  - Does not carry: the some-branch regions on the World.
- *Renewal without end in the grammar* (`«复生»`, `«生生»`, `«复生至»`, `«息»`, `«生生不息»`, `«生生即延»`; root).
  - Carries: the grammar's 生生, renewal without end: every member conditions a beginning whose line goes on to another member.
  - Does not carry: "more" ([01](../../../../../../theories/becoming/chapters/01-ROOT.md#renewal-and-grains)).

**Novelty and gain** ([02 §4](../../../../../../theories/becoming/chapters/02-MAP.md#r-where-novelty-gain-comes-from)).
- *On the levels alone* (`Web.revisits_of_bounded`, `Web.unbounded_of_new`, `World.forgets_of_bounded`): a bounded part returns, and what is new at every step passes every bound.
- *Where gain comes from* (`Web.exceeds_of_firsts`, `Web.newAt_of_first`, `Web.rises_late_of_newly_supported`, `Flow.rise_from_rest_or_open`, `Flow.newly_supported_from_rest_or_open`, `Flow.new_beyond_every`, `Flow.whole_not_new_of_rest_idle`; World, the first law where stated).
  - Carries: formations first supported without end, with requirements fixed in a finite family, make the family pass every bound (`Web.exceeds_of_firsts` with `Web.newAt_of_first`) and rise at arbitrarily late steps. Under the first law, each such rise is given from the rest or across the boundary. A finite whole whose rest gives nothing net returns. This is the material precondition of any "keeps opening".
  - Does not carry: inclusion, since novelty may close things; any comparison.
- *Over the reals* (`Representation.separated_exceeds`; periphery): finitely many conditions new by a least separation pass every bound. One direction only.
- *More without end* (`Flow.More`, `Flow.More.replenishment_unbounded`, `Flow.More.renewers_unbounded`, `Flow.More.unceasing`; World, balance).
  - Carries: more takers without end needs replenishment without bound and, with each giver bounded, givers without bound.
  - Does not carry: where the givers come from.

**Support, arising and passing on.**
- *Support comes from the supported* (`Flow.rise_given_by_supported`, `Flow.gains_from_supported`, `Flow.unsupported_stays`, `Flow.nothing_supported_stays`; World, balance, only active giving, activity needing support).
  - Carries: with nothing from beyond, what can form is opened only by what the supported give; the end absorbs.
- *Support passes on* (`Flow.support_passes_on`; World).
  - Carries: under balance, only active giving, activity needing support, requirements never loosening, brief support and gains recurring, it cannot be refuted, a double negation, that at arbitrarily late steps some gain is given by a formation that gained support after any given step.
  - Does not carry: that every gain is so given, which is candidate C's uniform form (proposed, §3.3). Nor 生生: by the law's own docstring, a chain of support is not yet 生生, which asks a direction as well.
- *Arising and wholes* (`Web.Unceasing.activeRenewer_recurs`, `Whole.arises_within`, `Covered.needs_new`, `Web.Whole.persists_from`): unceasing arising that depletes a finite family needs renewal; a whole of brief parts lasts only through new parts.
- *A renewing and a consuming formation* (`RenewingFormation`; periphery, with `propext`, `Quot.sound` and in part `Classical.choice`; [record](../../../../../../theories/becoming/results/records/renewing-consuming-formation.md)).
  - Carries: under a supplied wear law, the consuming formation forms more at first, so a one-step count ranks it first, and past a bound every continuation within renewal exceeds every one beyond. That is a comparison in the long run, in counts, under a supplied law.
  - Does not carry: the World; growth.

**Possibility, junctures and joint ranges.**
- *What can still be had* (`Law.reachable_absorbing`, `Law.lost_drawn`, `Branching.loss_passes_juncture`, `Branching.no_juncture_of_keeps`, `Branching.keeps_before_juncture`; any process).
  - Carries: what can be had `n` steps on is absorbing; every lost possibility passes a juncture; a choice matters only at a juncture. Within one fixed process the possible only narrows along a course.
- *Capacity over a horizon* (`ActivationCapacity.preparation_changes_capacity`, `ActivationCapacity.release_loses_joint`; any process): preparation changes one-step capacity, and release loses joint realization at every horizon.
- *Joint ranges* (`Activation.same_marginals_lose_bundle`, `Regimes.no_comparison_through_marginals`, `Regimes.joint_separates`, `Regimes.possibility_not_realization`; any process; [07 §5](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-relational-generative-comparison)).
  - Carries: marginal possibilities cannot certify joint ones, so comparing richness of relating needs joint information.

**Finite readings and horizons.**
- *What a finite stretch decides* (`Renewable.finite_reading_includes_consumption`, `Sequences.recurs_not_refutable`, `Sequences.eventually_not_refutable`, `Ideals.open_iff_verifiable`, `insulates_iff_dense`; [02 §3](../../../../../../theories/becoming/chapters/02-MAP.md#r-becoming-finite-horizon), [03 §5](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-what-a-finite-stretch-verifies)).
  - Carries: a reading fixed by a finite prefix that includes every renewing run includes a consuming one. Recurrence is neither verifiable nor refutable. A practice fixed by the record can insulate a reading exactly where it is dense.
- *What near-term weighting does* (`Optimum.frontier_exhausts`, `Optimum.frontier_holds`; [05 §7](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-a-weighting-faster-than-renewal-ends-the-base)).
  - Carries: weighting later draws down faster than any level renews makes every optimum end its stock at once. This is the near-term pole of the trade the long run poses.

**Open items and readings.**
- **07 §2:** read as generation generating generation, 生生 can exceed what widening counts, and how far is open ([widening along a reading](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-widening-along-a-reading)).
- **07 §9:** generation is carrying renewal and 生生 life in the whole, "not novelty or scale". An expansion that ends forms of life another course keeps is mixed with that course.
- **T8:** it falls to a mixed case argued better from every standpoint counting everything, with no further premise ([07 §8](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#theses)).
- **02, open:** "more shared and more responsive renewal" forbids nothing measurable as stated.

## 2. Four findings before any candidate

**F1. The pair asked about is mixed over all steps and reversed over a first stretch.** In the witness `OwnCondition`, each formation `n` requires only its own condition `n`, at need one. `rising` admits at step `t` the formations up to `t`. `burst` admits formations `0` and `1` at step `0` and nothing after.
- Up to step `0` the burst widens the rising course (`OwnCondition.burst_widens_now`). That stretch ends before the rising course first admits something the burst does not.
- Over every step the two are mixed (`OwnCondition.mixed`).

So widening over the whole run orders neither above the other. Read over that first stretch, it orders the course merely wider now above the other. Whatever ranks one of them better orders a mixed pair as better, which is a premise (D1). Eventual widening orders the pair as a comparison and ranks nothing. The account met the same shape in counts: a consuming formation forms more at first, a renewing one more past a bound (`RenewingFormation`).

**F2. A property of a course's own trajectory is not kept by widening.** `full` admits everything throughout. It widens the rising course, which keeps widening by name, while `full` keeps widening from no step (`OwnCondition.not_monotone`). So no order ranking every course that keeps widening above every course that does not agrees with widening. Candidate B's proposed witness would show the same for capacity: a course can realize more at every step and keep fewer possible courses. A coherent second-order order is a strengthening or a long-run form of widening, or it orders only pairs widening leaves unranked, after widening, by a named premise.

**F3. Where finite records stand.** The account's frame is 03's: level paths read as the runs of the process of all sequences of levels.
- **Eventual widening.** Where some level path eventually widens `l'`, eventually widening `l'` and its complement are both dense (`Web.eventually_dense`, `Web.not_eventually_dense`). So the reading is neither verifiable nor refutable (`Web.eventually_neither`), and a practice fixed by the record can keep the verdict against every record (`Web.eventually_insulated`). The frame varies the first course only; the second is fixed and known in full.
- **Where it sits in 03.** Eventual inclusion has the shape of a union of closed readings, the shape 03 gives what is verified in the limit. Exceeding at arbitrarily late steps has the shape of a meet of open readings, the shape of what is refuted in the limit ([03 §5](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-what-a-method-comes-to-say-in-the-limit)). 03 shows only that what is verified or refuted in the limit has those shapes, and eventual widening is the meet of the two, for which 03 gives no method.
- **Keeping widening.** A loss within a finite stretch refutes keeping widening by name, since nothing lost along the continuation is refuted by such a stretch. A stall refutes it at no finite stretch, and no finite stretch verifies it, since keeping opening has recurrence's shape.
- Such verdicts are decided, where at all, by a law of the courses: renewal, gain, or a determined law over listed configurations, where every course enters a cycle (`Law.enters_returning_within`) and the cycles decide. Observation of a stretch does not decide them. This is 03's point that induction is resolved into laws, applied here [AI reading].

**F4. Widening without end, read by name, needs formations without end.**
- Where a list holds every formation, no range read by name keeps widening (`Web.KeepsWidening.not_listed`).
- With requirements fixed within a finite family of conditions, formations first supported without end make the family pass every bound (`Web.exceeds_of_firsts` with `Web.newAt_of_first`). Under the first law they are given from the rest or across its boundary at arbitrarily late steps (`Flow.newly_supported_from_rest_or_open`).
- With the proposed bridge from keeping widening to first supports (§3.1), then, in bounded amounts widening without end needs requirements reaching beyond every fixed finite family of conditions. The witnesses escape the bound this way, each formation having a condition of its own. Their levels still total without bound, and in `OpeningChain` each unit is given from nothing.
- The treatise asks 「世界能否继续发现新的形成方式」, whether the world can keep finding new ways of forming [AI reading]. In the account's terms that is growth by kinds not given in advance, which `Web.WidensAlong` does not reach and the grammar cannot yet state.
- Since D5 does not read 生生不息 as growth, the second-order direction cannot simply be "keeps widening".

## 3. Candidates

### 3.1 Candidate A: the long run (eventual widening, keeping widening)

**Statement** (World, any web `W : Web F C`, level paths `l l'`; in the kit, `Becoming.EventualWidening`).
- The web from step `S` on (`Web.after`, as `World.after` reads a world) and a level path from `S` on (`Web.tailFrom`).
- `l` *eventually widens* `l'` where, from some step on, `l` widens `l'` on every tail (`Web.EventuallyWidens`). This is first-order widening read on late tails.
- Read pointwise, it is inclusion from some step on with exceeding at arbitrarily late steps (`Web.eventuallyWidens_iff`, from `Web.IncludesFrom` and `Web.ExceedsLate`).
- `l` *widens `l'` without end* where it includes it at every step and exceeds it at arbitrarily late steps (`Web.WidensWithoutEnd`).
- One course *keeps widening* from `T` along a continuation `R` where:
  - nothing admitted is lost across any stretch from `T` on (`Web.IncludesAcrossFrom`);
  - after every step, something is admitted that continues nothing admitted then (`Web.KeepsOpening`);
  - together, `Web.KeepsWidening`.
- A level path *admits alike* from `T` where at every later step it admits exactly what it admits at `T` (`Web.AdmitsAlikeFrom`).

**Relation to `Web.Widens`.**
- The order laws are widening's on late tails: irreflexive, transitive, one-way (`Web.EventuallyWidens.irrefl`, `.trans`, `.not_reverse`, from `Widens.not_reverse` and `Widens.trans`). They are not a second proof beside widening's.
- It orders some pairs that widening leaves mixed (F1) and reverses none that widening orders (`Web.Widens.not_eventually_reversed`, `Web.EventuallyWidens.not_included`). Where widening orders a pair, eventual widening agrees (widening without end, `Web.WidensWithoutEnd.eventually`; `OwnCondition.full_eventually_widens_rising`) or is silent (the wider course exceeds only over a first stretch).
- Inclusion composes with it on either side (`Web.Includes.trans_eventually`, `Web.EventuallyWidens.trans_includes`). So widening or eventual widening is irreflexive and transitive (`Web.WidensOrEventually`, `.irrefl`, `.trans`): the two can be held together.
- It reads only tails. Level paths agreeing from some step on eventually widen, and are eventually widened, alike (`Web.EventuallyWidens.of_agree_left`, `.of_agree_right`): every finite stretch is ignored.
- Eventual widening is not an extension on the frame of level paths, so C read there does not give it [AI reading].

**Relation to the map's generation.** Keeping widening and 生成 are independent [AI reading; witnesses proposed]. A relay of one carrier at a time is 全生成 under the passing continuation (`Map.Endless.generation`, `Web.generation_arises_late`), yet by name its range does not hold, and along the passing continuation it keeps the range the same. A growing set of formations that never end widens with no carrying renewal.

A course that admits nothing from some step on is eventually widened by any course admitting something at arbitrarily late steps (`Web.eventually_of_vanishing`). On the World, under balance, only active giving and activity needing support, once nothing is supported nothing is supported again while requirements do not loosen (`Flow.nothing_supported_stays`), and the actual levels then admit nothing. That is the link to degeneration a lifting would state.

**Relation to novelty and gain.** Keeping widening closes nothing along its own course, by construction. It is not thereby generative:
- by name it needs formations without end, which 07 §9 answers (generation is carrying renewal, not novelty or scale);
- another course can widen it (`OwnCondition.not_monotone`);
- with fixed requirements it needs gain without bound (F4, with the proposed bridge).

Eventual widening needs no growth.

**First laws.** All of these are proved in the kit.
- **Order and coherence:** the laws above.
- **Keeping widening:**
  - `Web.KeepsWidening.later`: it holds from every later step.
  - `Web.keepsWidening_reidentify`: it is unchanged by every re-identification carrying the continuation.
  - `Web.KeepsWidening.not_listed`: by name over a listed type no range keeps widening (the pigeonhole through `length_le_of_sub`, via `Web.KeepsWidening.gathers`).
- **THE-CORE's pair in the case a law reaches.** `Web.KeepsWidening.eventually_widens_of_within`: a course keeping widening by name from `T` eventually widens a range that admits alike from `T₂`, whose admissions at `T₂` it admits at some step from `T`. Nothing lost carries that inclusion to every later step [AI reading: this is THE-CORE's pair where the range merely wider now settles]. Given the inclusion as a hypothesis, keeping opening alone suffices (`Web.KeepsOpening.eventually_widens`, a lemma).
- **03's frame:** `Web.eventually_dense`, `Web.not_eventually_dense`, `Web.eventually_neither`, `Web.eventually_insulated` (F3).
- **The weighting characterization's silence:** `Web.not_eventually_of_listed`.

**Proposed.**
- **The gain bridge.** Keeping widening by name on the actual levels, with requirements fixed in a finite family, would make the family pass every bound and, under the first law, be given from beyond at arbitrarily late steps. The bridge is unproved. A proof through finite lists of formations would need neither a choice of witnesses nor decided support; should it need one, that need is a lemma of the bridge.
- **Eventual widening along a reading**, for growth by new kinds (from `Web.WidensAlong`).

**Witnesses against plain widening** (kit).

| Pair | Widening, every step | Widening up to step 0 | Candidate A |
|---|---|---|---|
| `rising`, `burst` | mixed | the burst widens the rising course | `rising` eventually widens `burst`; it keeps widening by name, the burst from no step (`OwnCondition.disagreement`) |
| `full`, `rising` | `full` widens `rising` | `full` widens `rising` | `full` also eventually widens `rising` (`OwnCondition.full_eventually_widens_rising`); `rising` keeps widening and `full` from no step (`OwnCondition.not_monotone`) |
| `lagging`, `travelling` | mixed | mixed | neither eventually widens the other, though `lagging` keeps widening and keeps every formation of `travelling` from one step later (`LagWitness.lag`) |

**Premises.**
- **Definitions.** None beyond the representation. They read admission only, on one web, over the natural-number step index. "Arbitrarily late" presupposes an unbounded index, a commitment of the representation.
- **Keeping widening.** A continuation `R`. By name, over a listed type, it cannot hold. Along a supplied continuation it can hold of a course admitting the same at every step, where a formation re-formed at each step continues nothing (`MergedWitness`). Read along `R`, keeping widening counts re-formation as opening, the converse of `Bud.readings`.
- **The gain bridge.** The first law, requirements within a finite family, natural-number amounts.
- **To rank:** a premise beyond C, here labelled **C∞**: where widening leaves two courses mixed, the one that eventually widens the other is better.

*Where C∞ stands relative to C.*
- **The characterization is silent.** `Web.widens_iff_every_weighting` needs both courses' admissions listed (`Web.ListsAdmitted`), and a course so listed eventually widens nothing (`Web.not_eventually_of_listed`). So the characterization of C says nothing about eventual widening.
- **It is of the class's kind.** On courses that are not listed, widening or eventual widening ranks each widening higher, so as an order it is of the kind the characterization covers: a priority of the long run, consistent with C.
- **From tails to courses.** C read on the frame of late tails (a new reading of C) ranks every late tail of the eventually wider course above the other's, by the definition. C∞ is the further step from tails to whole courses.

So C∞ is a premise of the same kind as the priorities that decide what C leaves mixed ([07 §4.4](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-graded-significance-and-priority): lexical priority, `Weighting.prior_transfer`). It is not outside C's class.

*C∞'s cost.*
- **(a) Insulation against finite records.** Where something eventually widens `l'`, the verdict and its complement are both dense, so a practice fixed by the record can keep "better under C∞" against every finite record (`Web.eventually_insulated`, by 03's `insulates_iff_dense`). That is the insulation 03's assessment of [scientific standing](../../../../../../theories/becoming/chapters/03-KNOWING.md#scientific-standing) flags. Only a law of the courses checks it (F3).
- **(b) The account already names this rival.** [PRACTICAL-JUDGMENT §7](../../../../../../theories/becoming/history/PRACTICAL-JUDGMENT.md#7-有内容的反对及边界--substantive-rivals-and-limits) describes "unlimited continuation priority", a rival "giving recurrence priority over every finite sacrifice". Basic-condition priority "explicitly rejects that priority for optional continuation".
- **(c) It is not overtaking.** Overtaking compares partial sums, so an early loss must be made up; eventual widening ignores every finite stretch outright (`Web.EventuallyWidens.of_agree_left`). Counting finitely many admissions at each step, eventual widening entails overtaking (von Weizsäcker 1965; Gale 1967), not conversely (an argument, not in Lean).
- **(d) A neighbour names this pole.** A criterion that reads only tails is a "dictatorship of the future" (Chichilnisky 1996, *Social Choice and Welfare* 13), excluded by her axioms of sustainable preference. Its near pole is what `Optimum.frontier_exhausts` shows draining.
- **(e) Losses confined to a finite stretch.** C∞ discounts every loss confined to a finite stretch, however long and however basic. A course that loses basic conditions over a long first stretch, regains them, and admits one formation more at arbitrarily late steps eventually widens a course that keeps them throughout. So C∞ would rank it higher, unless the priority of basic conditions comes first; 07's list of premises names that priority J2, while 07 §5 labels it J1. That priority already rejects unlimited continuation priority ((b)). Losses that last, formations the other admits at arbitrarily late steps, block C∞. `Web.eventually_of_vanishing` is the extreme case.

Under the continuation condition the early losses count (scope); C∞ would decide how they trade (order). C∞ is named and not proposed.

**Standing.** Near-definitional:
- eventual widening is widening on late tails, by definition, and its order laws are widening's;
- the frame laws are the density of a tail reading in the topology of runs (03 §5; liveness in Alpern and Schneider's sense);
- `not_listed` is the pigeonhole;
- the joining law uses its hypotheses directly.

Nothing in A is yet a result no neighbouring field states. The first candidates for one are the gain bridge and the givers law (§3.3).

### 3.2 Candidate B: capacity (widening of what can be reached)

**Statement** (proposed). Take a process `P : Process S A` whose configurations carry levels `lev : S → C → Nat`, read through a web `W`; the courses from a configuration are the runs starting there. For simplicity, the web's requirements do not depend on the step, or courses are aligned at the step of comparison.
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

**Relation to `Web.Widens`.**
- On a determined law, with one course from each configuration, it would be widening of the two courses (proposed, `Reach.widens_iff_of_determined`).
- With branching it compares options, not histories. A configuration can cover another strictly while their realized courses keep the same, or while the other's realized course widens its own; the second case would be the conflict of F2.
- Read as the union of what is possible one admission at a time, it would lose joint structure: two configurations with the same possible admissions can differ in which they can have together (an instance of `Activation.same_marginals_lose_bundle`). So the reach must be read as whole ranges, and this is where it reads the richness of relating.

**Relation to the map's generation.** The map's regions are branch notions: going on along some branch, ending on every branch. The diachronic form of B, a widening reachable from every configuration along some branch, has the shape of 生成 with "a widening ahead" in place of "a carrying renewal ahead" [AI reading; proposed].

**Relation to novelty and gain.** Kept capacity needs no realized growth: "more still able to form" (D5) is the modal reading, not growth [AI reading]. Realizing it without end along a branch needs what A needs along that branch.

**First laws (proposed).**
- `Reach.Covers` is a preorder; `Reach.Widens` is irreflexive and transitive.
- On determined laws it coincides with widening of the courses.
- *The possible only narrows.* Within one fixed process, the courses from a later configuration of a course are tails of courses from the earlier one, so capacity over every horizon is kept or lost along a course, never gained, and every loss passes a juncture (from `Law.reachable_absorbing`, `Branching.loss_passes_juncture`). This is the irreversibility premise of Arrow and Fisher and of Henry, restated (§4). Only the possible within a horizon can grow along a course, and only through what becomes actual.
- Marginals do not certify joint ranges (an instance of `Regimes.no_comparison_through_marginals`).

**Witness against plain widening** (proposed). From configuration E one course admits formations `0` and `1` at every step. From configuration K there are two courses:
- one, realized, admits `0` at every step;
- the other admits `0` and `1` at step `0` and the formations up to `t + 1` at step `t`.

E's realized course widens K's realized course. K would cover E, through its unrealized course, which no course from E includes. A tie version: the same realized course from both, with one configuration keeping an unused alternative. Plain widening keeps the two the same, and B would separate them.

**Premises.**
- A process of alternatives: in 01's terms a net of possibilities, a commitment of the representation.
- Runs that exist from each configuration: building them needs dependent choice in general (`runs_iff_dependentChoice`).
- The reading that unrealized courses count, D1's capacity to form [AI reading].
- To rank: C read on the frame of reachable courses, labelled **C◇** (option value in inclusion form). The exhaustion witness would show C on realized courses and C◇ ranking the same pair opposite ways, so holding both would need a lexical rule, itself a premise.

**Standing.** Proposed throughout.

### 3.3 Candidate C: what carries a widening (openings that were opened)

**Statement** (World, flow `L`, web `W`; in the kit). A flow's range is *opened by the opened* from `T` where two things hold (`Flow.OpenedByOpened`):
- gains of support recur;
- every gain after `T` is given, on a condition the gainer requires before the step and that rises across it, by a supported formation taking part that itself gained support after `T`, earlier.

The recurrence clause excludes the vacuous case. A web on which nothing is supported from some step on is opened by the opened from no step (`Flow.OpenedByOpened.not_of_unsupported`; on `OwnCondition.web`, `OwnCondition.not_opened`), so the end of degeneration does not qualify.

[AI reading] It reads, on support, one face of what D1 reads as generation generating generation: the generators of further forming. Like a chain of support it is not 生生, which asks a direction as well.

A stronger variant would read each opened formation as a part and ask it to widen against its own withholding. That needs withheld levels for every opened formation, which in natural numbers need not exist.

**Relation to `Web.Widens`.** It is a property of what carries a range, and it is independent of widening both ways:
- **Invisible to widening.** On one web whose levels are the rising course, the relay and the single giver both balance, with only active formations giving and activity needing support. In the relay each formation gives the next its unit; in the other, one formation gives every unit. The relay is opened by the opened and the single giver is not, while every admission is the same (`OpeningChain.carried`). Neither flow meets the first law: each unit is given from nothing.
- **Possible with no widening.** Two formations pass one unit around (`ClosedCycle`). The cycle balances, with each step moving the unit and making nothing, and it is opened by the opened with a gain at every step. Along the continuation in which each formation continues as the other, nothing is lost and nothing is opened, and by name the range does not keep widening (`ClosedCycle.cycle`). That is 不息 without 生生不息 (D5) [AI reading].
- **One opening.** A single opening is the one-step, one-giver face of the margin law [AI reading].

**Relation to the map's generation** (proposed). Read the World with occurrences `(t, f)` as carrier, as `Becoming.MapInstances` does. Take as 缘 the relation from `(t, g)` to `(t + 1, f)` where `g`, supported, gives on a rising condition `f` requires and `f` gains support across the step. Take the coarse class "supported or not" and the fine class "the same formation".
- An opened occurrence begins a fine line, since nothing of its own formation opened it.
- So an opening chain in which every occurrence reached opens another is 全生成 at those grains.
- That would be the first law relating the map's generation to gains of support, and, with nothing admitted lost (`Web.IncludesAcrossFrom`), to widening. 02's open item stays open until it is proved.

**Relation to the root's `«生生»`.** The grammar's `«生生»` is renewal without end: every member conditions a beginning whose line goes on to another member. Opened by the opened reads like its backward form on the World, with 缘 read as giving on a required condition: every gain conditioned by an earlier gainer [AI reading]. C is stated on the World because it reads amounts (giving, rising levels) and the grammar has none yet ([08](../../../../../../theories/becoming/chapters/08-METHOD.md#expressible-is-not-derived)). The proposed map law is the nearest statement on the grammar.

**Relation to novelty and gain.** Every opening is a rise of a required condition. A chain without end, with requirements fixed in a finite family, passes every bound and is fed from beyond. The relay escapes the fixed family only because every formation has a condition of its own.

**First laws.**
- *Proved in the kit*: the definition, `not_of_unsupported`, and the witnesses `OpeningChain.carried` and `ClosedCycle.cycle`.
- *Proposed*:
  - **The uniform form of support passing on.** Under balance, only active giving, activity needing support, requirements never loosening, and every support lasting at most `K` steps: every gain after step `T + K` would be given, up to double negation, by a formation that gained support after `T` (the route of `Flow.support_passes_on`, read for every late gain). `Flow.support_passes_on` gives this only at arbitrarily late steps, as a double negation.
  - **Givers multiply.** Suppose a course keeps widening by name on the actual levels, every supported formation takes at least a unit a step from a balanced family `cs` (upkeep), and each giver gives `cs` at most `g`. Then the number of givers to `cs` would be bounded from no step on.
    - The route: `Web.KeepsWidening.gathers` and `Web.IncludesAcrossFrom` give, for every `K`, `K` formations supported from some step on. Upkeep makes them takers, which is `Flow.More cs`, and `Flow.More.renewers_unbounded_from` would conclude.
    - It needs a count lemma, distinct takers bounding `count` from below, with equality of formations decided or a double negation.
    - It would join A to C: under upkeep, widening without end needs its givers to multiply.
  - **The map law** above.

**Premises.**
- The definition: none beyond the representation.
- The uniform law: balance, only active giving, activity needing support, requirements not loosening, brief support.
- The givers law: balance, upkeep, bounded capacity per giver, and decided equality for counting.
- To rank: none is proposed. A tumour line, or a capture loop reproducing its carriers, can be opened by the opened while closing what it draws on: 05's meta-attractor case. Ranking by opened by the opened runs against widening wholesale, so it could enter only after C, by a named premise [AI reading].

**Standing.** Definition and witnesses proved (kit); the laws proposed.

### 3.4 How the three meet

| What THE-CORE says widening omits | Read by |
|---|---|
| a range whose widening keeps widening, against one merely wider now | not captured; A gives the long-run comparison and the property, and reaches the pair only where the range merely wider now admits alike |
| returning capacity | not read by A: `Web.IncludesAcrossFrom` excludes loss and does not measure recovery. Recovery (the treatise's fourth test) needs 02's return grades (`Web.consumed_iff`) |
| richness of relating | B's whole reachable ranges (joint, not marginal); C's relation of opening |
| the capacity to form (D1's third component) | B (kept capacity) and C (what carries the range) |

Proposed laws would join them:
- A's keeping widening with upkeep would force C's givers to multiply;
- brevity would force C's chain at every late gain;
- B would say the possible grows only within a horizon and only through the actual.

Read with the treatise [AI reading]:
- 「不耗尽自身赖以存在的条件」, not exhausting one's own conditions, one of its five tests of 不息, is closest to A's nothing lost.
- 「能把可继续生成的世界交给后来者」, handing on a world that can keep generating, another test, is closest to B's kept capacity.
- 「使新的生成者仍能出现」, that new generators can still appear, comes from the treatise's account of 生生, not from its tests of 不息. It is modal, closest to B, with C its mechanism.
- Tests two to four (not reducing others to tools; absorbing feedback and correcting; recovering and renewing in change) are read by no candidate.

### 3.5 A deferred candidate: the rate reading

"A range whose widening keeps widening" can be read as growth of the widening itself: eventual widening of what each course newly admits across stretches, as in the adjacent possible and TAP's acceleration. It is deferred for three reasons:
- it reads 生生不息 as growth, which D5 excludes;
- it needs more gain than A;
- measured from different bases it can reverse widening, so it would need a common base, which is what widening already compares. On the kit's pair `full` and `rising`, widening orders `full` above (`OwnCondition.full_widens_rising`). The rate reading would order `rising` above, since it opens a formation at every step and `full` opens none (an argument on the kit's witness, not in Lean).

## 4. Neighbours

The literature is from prior knowledge, checked where noted (the review fetched the assembly theory paper and the TAP and Kempes abstracts); it was not read in full for this note. The placements are AI readings.

The last column marks each statement the account would forbid as *known*, already stated in the neighbour or a neighbouring field, or *not yet checked*. **None counts as a third part of a containment in UE's sense.** The UE0 audit found that forbidden statements in this area are known in neighbouring fields.

| Neighbour | In its own terms | What it would contribute | What the account adds | Forbidden statements (status) |
|---|---|---|---|---|
| The adjacent possible (Kauffman, *Investigations*, 2000) | What is one step from the actual, such as molecular species one reaction away. The biosphere enters it, by a conjectured "fourth law", about as fast as it can sustain. The possible grows with the actual and cannot be stated in advance. The TAP equation (Cortês, Kauffman, Liddle and Smolin, arXiv 2204.14115) models combinatorial innovation with extinction: a long plateau, then an explosive rise. RAF sets (Hordijk and Steel 2004) are reflexively autocatalytic and food-generated: every reactant is produced from a food set by reactions of the set | that the possible is second order (what can come next depends on what is now); combinatorial growth laws; autocatalytic closure fed from a food set | the adjacent possible as reach within horizon one (B); the fourth law's "sustain" as A's nothing lost; RAF's food set as F4's gain from beyond; no agent at the centre; every ranking premise named. "Cannot be stated in advance" is not `Web.WidensAlong` (a supplied reading of one given type in another); the account's form of that gap is self-changing conditions (UE plan §5) | a rising count of types in TAP is not widening, since extinction can close what another course keeps (07 §9's mixed case): a contrast, not a third part. That the possible over every horizon only narrows within one fixed process: not Kauffman's claim, and known as irreversibility (below) |
| Assembly theory (Sharma, Czégel, Lachmann, Kempes, Walker and Cronin, *Nature* 622, 2023; checked against the published text) | An object's assembly index is the least number of joining steps from basic blocks, reusing what was built. Assembly, `A = Σᵢ e^{aᵢ}(nᵢ − 1)/N_T` over distinct objects of index `aᵢ` and copy number `nᵢ`, `N_T` objects in all, quantifies the selection needed to produce an ensemble. Discovery grows as `dN_{a+1}/dt = k_d N_a^α`: `α = 1` is history without selection, `α < 1` selection. Selection and open-ended growth are expected where discovery and production timescales are comparable. Its methods are contested (Uthamacumaran et al. 2024; Abrahão et al. 2024; reply, Kempes et al., arXiv 2406.12176) | a measured trace of reuse; a regime parameter (discovery against production) the account lacks; an empirical programme (mass spectrometry) | AT measures what was made; the account compares what can form. Reuse is read as copying under draws (04: a copy is produced where the pool holds its tokens and the support covers its draws), and selection through couplings. Assembly is a scalar, so as a measure of 生生 it would be a premise ordering mixed cases, and it rewards copy number, which capture also raises | high-index objects in high copy number without pool and support covering the draws: not yet checked against AT. A rise of Assembly does not show widening: a contrast, and a lock reproducing complex carriers while narrowing what can form is a witness to build |
| Open-endedness in artificial life (Bedau and Packard's evolutionary activity statistics, 1992 and after; Taylor et al., *Artificial Life* 22, 2016; Banzhaf et al., *Theory in Biosciences* 135, 2016; Adams, Zenil, Davies and Walker, *Scientific Reports* 7, 2017) | Activity statistics with neutral shadow runs measure adaptive novelty that persists. Banzhaf et al. class novelty as variation, innovation and emergence: within the model, needing a new model, needing a new meta-model. Adams et al. define unbounded evolution relative to the recurrence time of an isolated system, and find that rules depending on the state are the mechanism that scales | operational tests with neutral controls; the three kinds of novelty; the result that the rules must change with the state | widening without end is not novelty without end (keeping widening loses nothing admitted, by construction); Banzhaf's three kinds as widening within `F`, growth along a supplied reading, and self-changing conditions; a partial order, not a scalar | open-ended novelty in a bounded closed system whose rest gives nothing (it returns, `Flow.whole_not_new_of_rest_idle`): known, in Adams et al.'s definition. A thesis worth freezing all the same: in bounded closed simulations, activity plateaus unless inflow or new kinds enter |
| Option value (Weisbrod 1964; Arrow and Fisher 1974; Henry 1974; Kreps 1979; Dixit and Pindyck 1994) | Keeping an irreversible option has value under uncertainty (quasi-option value: learning before committing). Kreps represents a preference over menus that is monotone in inclusion as uncertainty about future preferences | a decision theory under uncertainty; valuation; Kreps's account of why flexibility is preferred | B as Kreps's menu inclusion lifted to courses, with no probability and with joint ranges; option value lost only at junctures; the conflict between realized widening and kept capacity, with the premise that decides it named (C◇ and a lexical rule) | options narrowing within one fixed process: known (Arrow and Fisher's and Henry's irreversibility). Joint options not certified by marginal ones (`Regimes.no_comparison_through_marginals`): not yet checked |

Two further neighbours bear on the premises.
- *Evolvability* (Wagner and Altenberg 1996; Kirschner and Gerhart 1998) is the capacity to generate selectable variation; C's proposed laws would be its material conditions.
- *Infinite-horizon social choice.* An order of infinite streams that is complete and satisfies Pareto and anonymity cannot be represented (Diamond 1965; Basu and Mitra 2003). A criterion reading only tails is a dictatorship of the future (Chichilnisky 1996). Widening or eventual widening contains widening, so it satisfies strong Pareto; it is incomplete, which is how it stands beside those results [AI reading].

## 5. Recommendation and what lands

**What lands.** Eventual widening and the carrier witness, as one near-definitional record with its home in 07 §2, beside widening along a reading ([LANDING.md](LANDING.md)). The record states what widening can and cannot say of the long run and of carriers, and names C∞ as the premise it is. The reasons:
1. **What it is.** Eventual widening is the long-run comparison: widening of every late tail, by definition. THE-CORE's pair is reached only in the case where a course keeping widening meets a range that admits alike on what it admits at some step (`Web.KeepsWidening.eventually_widens_of_within`) [AI reading]. It does not capture the second-order direction (see the opening of this note).
2. **Coherence.** It is coherent with C by theorem (`Web.Widens.not_eventually_reversed`, `Web.WidensOrEventually.trans`), where keeping widening and kept capacity are not (F2).
3. **Rule 9.** Its order laws are widening's on late tails, and its frame laws are an instance of 03's. Rule 9 is met as LANDING.md says.
4. **Size.** It is small, constructive and in the pure core.

The UE plan's purpose for this item is a result no neighbouring field states, and this record is not one. If UE4 is to land only with such a result, the record waits for the gain bridge or the givers law. LANDING.md leaves that choice to the integrator.

**What stays design.** Candidate C's laws (the uniform form of support passing on, givers multiply, the map law), candidate B entirely, the gain bridge, eventual widening along a reading, the rate reading, C∞ and C◇. None of these is in the landing modules; each would be claimed and reviewed on its own.

**The first Lean statements** (kit).

| Module | Statement | Meaning |
|---|---|---|
| `Becoming.EventualWidening` | `Web.EventuallyWidens W l l' := ∃ T, ∀ S, T ≤ S → (W.after S).Widens (tailFrom S l) (tailFrom S l')` | first-order widening on late tails |
| | `Web.eventuallyWidens_iff` | read pointwise: inclusion from some step on, exceeding at arbitrarily late steps |
| | `EventuallyWidens.irrefl`, `.trans`, `.not_reverse` | widening's order laws, on tails |
| | `Widens.not_eventually_reversed`, `WidensOrEventually.trans` | it never reverses widening; the two can be held together |
| | `EventuallyWidens.of_agree_left`, `.of_agree_right` | it reads only tails |
| | `Web.KeepsWidening W R l T`, `KeepsWidening.not_listed` | keeping widening; none by name over a listed type |
| | `KeepsWidening.eventually_widens_of_within` | THE-CORE's pair in the case where the range merely wider now admits alike |
| | `Flow.OpenedByOpened`, `OpenedByOpened.not_of_unsupported` | what carries a widening; the end of degeneration excluded |
| `Becoming.EventualWideningInstances` | `Web.eventually_dense`, `not_eventually_dense`, `eventually_neither`, `eventually_insulated` | 03's frame: dense both ways, neither verifiable nor refutable, insulable |
| | `Web.not_eventually_of_listed` | where the weighting characterization is silent |
| | `OwnCondition.disagreement`, `OwnCondition.not_monotone`, `LagWitness.lag`, `MergedWitness.keeps_widening_along_merge` | the witnesses of F1, F2, the lag and the merge |
| | `OpeningChain.carried`, `ClosedCycle.cycle` | one range with two carriers; opened by the opened with no widening |

**What would show the definition wrong.**
- *Too narrow (1): other directions.* A pair that every reading argued from the work counts as "keeps widening against merely wider now", where the growing course widens in other directions and never comes to include the other. Eventual widening is silent there; a verdict would need a measure trading across formations, a premise of another kind than C∞.
- *Too narrow (2): a lag.* A course keeping widening that admits every formation of another from one step later, forever, is mixed with it in every tail (`LagWitness.lag`). A comparison made formation by formation (what each admits from some step on, and at arbitrarily late steps) would order them, at the cost of no longer being widening on tails. Per-step inclusion is kept because eventual widening is then widening of every late tail. The lag is also the case a second-order comparison should decide.
- *Wrongly placed.* An argument from the work that the second order of 生生 lies in capacity or in carriers, not in the long run. That is this note's own conclusion: A stays a component, and the direction is to be sought in B and C.
- *A premise failing, not the definition.* A case argued better from every standpoint counting everything in which the course eventually narrower is better: long first stretches keeping basic conditions, against one formation gained forever. That refutes C∞ and leaves eventual widening standing as a comparison.
- *An epistemic claim failing.* F3 says no finite stretch decides the verdict without a law of the courses. A theorem showing that, under the World premises alone and with no list of configurations, a finite stretch of two courses decides eventual widening would refute that reading. The frame laws are proved for arbitrary level paths, which need not be courses of such a world.

## 6. What this note does not claim

- That any candidate is 生生, or that C∞ or C◇ is warranted; both are named and not proposed.
- That the second-order direction is captured. It is not (see the opening of this note).
- That actual unfoldings keep widening, keep capacity, or are carried by their openings.
- Anything about branching courses beyond the proposals of §3.2, or over real amounts and continuous time.
- A containment of any neighbour in UE's sense: §4 is a first placement, with no third part.

The readings marked [AI reading] are the AI's and change no theorem.

## 7. The review's findings and where each is answered

| # | Finding | Answer |
|---|---|---|
| 1 | "over any first stretch" | module docstrings now state the first stretch exactly (`OwnCondition.burst_widens_now`, instances docstring) |
| 2 | "none that widening decides" | §3.1, relation to widening: agrees or is silent, never reverses (`OwnCondition.full_eventually_widens_rising`) |
| 3 | `eventually_widens` assumed half its conclusion | replaced by `KeepsWidening.eventually_widens_of_within`, which derives the inclusion; the old law is `KeepsOpening.eventually_widens`, a lemma; "outlasts" dropped |
| 4 | `OpenedByOpened` vacuous | recurrence clause added; `OpenedByOpened.not_of_unsupported`, `OwnCondition.not_opened`; the closed pair replaced by `ClosedCycle`, non-vacuous |
| 5 | requirement after the step, no rising condition | requirement before the step and a rising condition (`Web.Rises`) |
| 6 | first-stretch claims | F3 rewritten in 03's frame, with (a)–(d) |
| 7 | F4's citations, escape and calibration | F4 cites `Web.exceeds_of_firsts`; escape stated; the bridge called a gap |
| 8 | "forced" | §1's entry states `Flow.support_passes_on` exactly; "forced" dropped |
| 9 | proposed stated as established | §2, §3.2, §3.4 now say "would", "proposed" |
| 10 | "the comparison THE-CORE asks for" | the opening and §5: the long-run comparison; THE-CORE's pair only in the case of the joining law |
| 11 | what is second order | the opening and §0; §3.5 names the rate reading as deferred |
| 12 | the lag | `LagWitness` (kit); §5 *Too narrow (2)* |
| 13 | keeping widening along a supplied continuation | `MergedWitness` (kit); §3.1 premises; module docstring |
| 14 | "a property but not an order" | the opening, F2, §3.3 premises, module readings |
| 15 | standing | §3.1 *Standing*; module docstrings |
| 16 | C∞ relative to C | §3.1, where C∞ stands; `Web.not_eventually_of_listed` |
| 17 | C∞'s cost | §3.1, (a)–(d) |
| 18 | the J1 example | §3.1, (e): losses confined to a finite stretch; the commitment named by content, with its labels |
| 19 | "decide", "favour" | F1 and throughout: comparisons order or separate, C ranks |
| 20 | opened by the opened as generation generating generation | §3.3 and the module readings: one face, not 生生 |
| 21 | 07 §9's objection | §3.1, relation to novelty and gain |
| 22 | the treatise's tests | §3.4 corrected; tests two to four read by no candidate |
| 23 | the map law "to widening" | §3.3: to gains of support, and with nothing lost to widening |
| 24 | the neighbours' forbidden column | §4: each marked known or not yet checked, none a third part; (a), (b) corrected; (e) TAP added |
| 25 | derive eventual widening from widening | the definition is widening on late tails (`Web.after`, `Web.tailFrom`) |
| 26 | the splice laws in 03's frame | `Web.eventually_dense`, `not_eventually_dense`, `eventually_neither`, `eventually_insulated` |
| 27 | the leaf | LANDING.md, rule 9 |
| 28 | C and the root's `«生生»` | §3.3: the correspondence, and why C is on the World |
| 29 | names | `IncludesAcrossFrom`, `AdmitsAlikeFrom`, `OpeningChain.relay`, `OpeningChain.oneGiver`, `oneGiver_not_opened` |
