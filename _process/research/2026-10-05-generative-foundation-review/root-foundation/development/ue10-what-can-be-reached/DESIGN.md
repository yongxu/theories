# UE10: widening what can be reached (design)

AI-written, 26 October 2026, for board item UE10 under [UE](../ue-unified-explanation/PLAN.md), item 7 (the second-order direction of 生生). It takes up candidate B of [UE4's design](../ue4-second-order/DESIGN.md#32-candidate-b-capacity-widening-of-what-can-be-reached), what a course keeps reachable, which [UE9](../ue9-comparing-courses/NOTE.md) leaves open: UE9 compares courses on what they admit, and an admitted range carries no alternatives. Everything here is proposed; nothing is proved until the Lean is checked.

Marks: **[AI reading]** is an interpretation by the AI, not a theorem.

## 1. The question

07's open item asks for a comparison of a range whose widening keeps widening with one merely wider now, never reversing widening and counting neither novelty nor scale ([07 Open](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#open)). What a course keeps reachable is one of the two candidates left. Four questions locate it:

1. Is widening what can be reached an order, and how does it relate to widening of the courses?
2. Can what can be reached grow along a course, and in what sense? Kauffman's adjacent possible grows as the actual moves into it; within one fixed process the possible only narrows. Both can hold, and the design says exactly how.
3. Can the adjacent possible keep growing in a fixed process, and what does that need?
4. How does a comparison of options meet widening of what is realized?

## 2. The setting: any process, read through what each configuration admits

The statements are on the spine's base, any process `P : Process S A` with a reading `adm : S → X → Prop` of what each configuration admits: a frame's realized claims (`Frame.realized`), or, for a dependence `K : Dependence S F C` over the configurations, admission at a configuration (each condition a formation requires there stands at its need). The courses from a configuration are the runs starting there (`Run`). Requirements belong to configurations, so two courses are compared at the same offsets from their starts, which UE4's design needed a fixed web for.

```lean
/-- A course's range includes another's: what the other admits at an offset, it admits there. -/
def Run.RangeIncludes (adm : S → X → Prop) (r r' : Run P) : Prop :=
  ∀ t x, adm (r'.state t) x → adm (r.state t) x
def Run.RangeExceeds (adm : S → X → Prop) (r r' : Run P) : Prop :=
  ∃ t x, adm (r.state t) x ∧ ¬ adm (r'.state t) x
/-- Every course from `s'` is included by some course from `s`. -/
def Covers (P : Process S A) (adm : S → X → Prop) (s s' : S) : Prop :=
  ∀ r' : Run P, r'.state 0 = s' → ∃ r : Run P, r.state 0 = s ∧ r.RangeIncludes adm r'
/-- Widening what can be reached: covering, with a course from `s` no course from `s'` includes. -/
def WidensReach (P : Process S A) (adm : S → X → Prop) (s s' : S) : Prop :=
  Covers P adm s s' ∧ ∃ r : Run P, r.state 0 = s ∧ ∀ r' : Run P, r'.state 0 = s' → ¬ r'.RangeIncludes adm r
/-- The whole possible from `s`: what some configuration reachable from `s` admits. -/
def Possible (P : Process S A) (adm : S → X → Prop) (s : S) (x : X) : Prop :=
  ∃ t, Reach P s t ∧ adm t x
/-- The possible within `k` steps of `s`; with `k = 1`, the adjacent possible and the present. -/
def PossibleWithin (P : Process S A) (adm : S → X → Prop) (k : Nat) (s : S) (x : X) : Prop :=
  ∃ t as, as.length ≤ k ∧ Trace P s as t ∧ adm t x
```

The module would be `Becoming.ReachableRanges`, importing `Becoming.Frame` (with `Reach`, `Run`, `Trace`), `Becoming.Horizon` (`Run.cons`) and what the witnesses need. It is first-order in what each configuration admits; what one formation needs of another, levels and flows enter only through `adm`.

## 3. The laws to check

**Law 1. An order, which on determined processes is widening of the courses.**
- Range inclusion of courses is reflexive and transitive; covering is a preorder.
- Widening what can be reached is irreflexive and transitive, with no premise: a course from `s` that no course from `s'` includes is included by none from `s''` when `s'` covers `s''`.
- Where each configuration has exactly one course (a determined process with its runs), widening what can be reached is range widening of the two courses (`WidensReach P adm s s' ↔ r.RangeIncludes adm r' ∧ r.RangeExceeds adm r'`).
- Covering is trace inclusion under the order of admitted ranges: a linear-time preorder, not a simulation. Two configurations with the same courses up to the order of branching are not separated, as in the linear-time and branching-time spectrum [AI reading; the neighbour to grade].

**Law 2. The whole possible only narrows; the possible within a horizon moves with the actual.**
- Along every course, what is possible from a later configuration is possible from an earlier one (`Possible P adm (r.state (n + 1)) x → Possible P adm (r.state n) x`), from `Reach.trans`. So nothing is ever added to the whole possible along a course of a fixed process.
- Every course from a configuration reachable from `s` is a tail of a course from `s` (by prefixing the trace with `Run.cons`, constructively): the possible as a family of courses narrows too.
- The possible within `k` steps of a later configuration lies within the possible within `k + 1` steps of the earlier one: it grows only by the horizon moving with the actual.
- Covering read from each configuration's own start can rise along a course: a witness where `s₀` steps to `s₁` and stays, `s₁` admitting more, has `s₁` widening what can be reached over `s₀`. What rises is what is near, not what is possible.
- [AI reading] This is Kauffman's adjacent possible restated: it expands as the actual moves into it, while the possible within one fixed law only narrows. For the whole possible to grow, the process itself has to change along the course: self-changing conditions, which the grammar cannot yet state (UE plan §5).

**Law 3. Keeping the adjacent possible widening needs an unlisted whole possible.**
- Say a course keeps the possible within `k` widening where at every step the possible within `k` of the next configuration includes that of the present one and exceeds it.
- If the whole possible from the course's start is held by a list, no course keeps it widening: the formations gained at the first `L + 1` steps are pairwise distinct (each was not possible within `k` before, and each earlier gain still is), all lie in the whole possible from the start (law 2), and a list of length `L` holds no `L + 1` distinct members (the pigeonhole of `length_le_of_sub`, as in `KeepsWidening.gathers`).
- Witnesses: a ladder on the naturals keeps the adjacent possible widening, the whole possible infinite; a finite cycle keeps it fixed.
- [AI reading] Open-ended growth of the adjacent possible in a fixed process needs the open-endedness already in the law's reach. The open-ended evolution literature finds unbounded innovation where the rules depend on the state (Adams and others 2017); the law says why a fixed rule with a listed reach cannot have it.

**Law 4. Options and realized courses rank a pair oppositely; the lexical order is consistent.**
- A realized course from each configuration is a premise (one run chosen from each), as the actual course is.
- *The witness* (UE4's design, §3.2). From E one course admits formations `0` and `1` at every step. From K there are two: the realized one admits `0` at every step, the other admits the formations up to `t + 1` at step `t`. E's realized course widens K's; K widens what can be reached over E. So no strict partial order on configurations contains both realized widening and widening what can be reached.
- *The tie.* With the same realized course from both, one configuration keeping an unused alternative, realized widening is silent and widening what can be reached separates them.
- *The lexical order.* Realized widening, or keeping the same realized range and widening what can be reached, is a strict partial order containing realized widening and never reversing it (realized widening is compatible with keeping the same range on either side), and it decides the tie.
- [AI reading] Ranking by what can be reached is option value in inclusion form, labelled C◇ in UE4's design. Holding it beside C read on realized courses needs a rule saying which comes first, and that rule is a premise. The lexical order is one such rule: what is realized first, what can still be had among equals.

**Law 5. The whole possible does not certify what can be reached together.**
- Two configurations with the same whole possible can differ in covering: from one a course admits formations `0` and `1` together, from the other one course admits `0` and another admits `1`, never both. The first widens what can be reached over the second.
- [AI reading] What can be reached must be read as whole ranges, not formation by formation, which is where it reads the richness of relating (an instance of `Activation.same_marginals_lose_bundle`, to be connected if the statement allows).

## 4. Neighbours to grade

- **The adjacent possible** (Kauffman 2000, *Investigations*; Koppl and others on the TAP equation): the set of things one step from the actual, growing as the actual expands into it. Law 2 restates its growth as the horizon moving with the actual, and law 3 says a fixed rule with a listed reach cannot keep it growing.
- **Irreversibility and option value** (Arrow and Fisher 1974; Henry 1974; real options, Dixit and Pindyck 1994): keeping alternatives open has value under uncertainty, and an irreversible step loses it. Law 2's narrowing and law 4's lexical premise are the inclusion forms; the juncture where a loss happens is landed (`Becoming.Junctures`).
- **Opportunity sets and freedom of choice** (Jones and Sugden 1982; Pattanaik and Xu 1990; Sen 1985 on capabilities): ranking by set inclusion of what can be chosen. Covering is that ranking with courses for options; counting options is the cardinality ranking UE9 excluded under keeping what the other keeps.
- **The linear-time and branching-time spectrum** (van Glabbeek 1990): trace inclusion against simulation. Covering is linear-time.
- **Open-ended evolution** (Bedau and others 2000; Adams and others 2017; Taylor and others 2016): unbounded novelty needs an unbounded space or rules that change; law 3's form.
- **Assembly theory** (Sharma and others 2023): the assembly space as what can be built from what is built; law 2's horizon possible on that space.

Expected standing: each law near-definitional; law 3's pigeonhole a restatement of finite recurrence; the contribution, if any, is joining the adjacent possible, option value and opportunity sets on one reading of what can be reached, with law 4 locating the premise between them. A third part against any of them is not expected.

## 5. Pure core and modelling

- Constructive throughout, with term proofs where feasible. Laws quantify over given runs; prefixing a trace to a run is a construction (`Run.cons`), so no run needs to be chosen. Existence of runs from every configuration needs dependent choice in general (`runs_iff_dependentChoice`) and is never assumed.
- The pigeonhole of law 3 needs the gains named (a witness at each step), not decided.
- What the report would not catch: discrete steps; courses compared at the same offsets; what each configuration admits given by a reading; one fixed process (the self-changing case is outside); the realized course as a chosen run.

## 6. What it would not show

- That widening what can be reached, or the lexical order, is the second-order direction of 生生: calling either better is a premise beyond C, as calling eventual widening better is.
- Anything about weighted branching (probabilities of courses), real amounts or continuous time.
- What carries a course's openings, the other candidate, beyond UE7's laws.
- Growth of the whole possible: under one fixed process it never happens, and a process that changes itself is not stated.

## 7. Plan

1. Draft the module in a kit (`tree/Becoming/ReachableRanges.lean`), scratch-built against main after UE9 lands, every axiom report empty.
2. An independent review by a separate agent, with probes in Lean; a fix round.
3. Land through the queue: a record homed in 07 §2 after UE9's, 07's Open item narrowed, a line in 08 §8.
