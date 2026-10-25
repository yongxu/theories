# UE9: comparing two courses on what they admit (note)

AI-written, 26 October 2026, for board item UE9 under [UE](../ue-unified-explanation/PLAN.md), item 7 (the second-order direction of 生生); revised the same day after the [independent review](REVIEW-UE9.md), each finding as §6 says. The reviewed text is at commit `6acecdd20`, and the reviewed module is kept in [history/](history/) as the review's evidence. Kit: [`tree/Becoming/ComparingCourses.lean`](tree/Becoming/ComparingCourses.lean). It is pure core, building on the landed `Becoming.EventualWidening` and `Becoming.EventualWideningInstances`.

Marks: **[AI reading]** is an interpretation by the AI, not a theorem.

## 1. The question

07's open item asks for: "a comparison of a range whose widening keeps widening with one merely wider now, never reversing widening and counting neither novelty nor scale" ([07 Open](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#open)). [UE4](../ue4-second-order/DESIGN.md) gave eventual widening, first-order widening read on late tails. It named a lag that a second-order comparison should decide and eventual widening cannot (`LagWitness.lag`): the lagging course keeps widening and admits every formation of the travelling one a step later, yet the two are mixed on every tail. [UE7](../ue7-what-keeps-widening/NOTE.md) states what one course keeping widening needs; none of its laws compares two courses.

Here the comparison is read where widening reads: on what each course admits at each step. Three laws locate what it can be there, and a fourth gives a condition closer to 07's words.

## 2. The laws

### Law 1. Keeping widening over admitting alike closes a cycle

- *The cycle, on every web.* Two rankings crossed by widening close one: a transitive relation containing widening that ranks `l` above `l'` and `k` above `k'`, where `l'` widens `k` and `k'` widens `l`, ranks `l` above itself (`Web.ranks_self_of_crossed`).
- *The web.* `Sides.web` has formations on two sides, `(b, n)` with `b : Bool`, each requiring only its own condition, at need one. Exchanging the sides (`Sides.swap`) carries a course to its mirror.
- *The two courses.* The growing course (`Sides.growing`) admits, at step `t`, the formations `(true, n)` with `n ≤ t`. The other course (`Sides.firstAndOther`) admits, at every step, `(true, 0)` and every `(false, n)`.
  - The growing course keeps widening by name from the first step (`growing_keepsWidening`). The other admits alike from the first step (`firstAndOther_alike`) and is wider up to the first step (`firstAndOther_wider_first`). The two are mixed (`growing_mixed`).
  - The mirrored pair meets the same four conditions (`swap_growing_keepsWidening`, `swap_firstAndOther_alike`, `swap_wider_first`, `swap_mixed`).
  - Each course widens the other's mirror: the other course widens the mirror of the growing one (`firstAndOther_widens_swapped`), and the mirror of the other widens the growing one (`swapped_widens_growing`).
- *The class law.* No strict partial order containing widening ranks every course keeping widening by name from the first step above every course that admits alike from the first step, was wider up to the first step and is mixed with it:

```lean
theorem no_order_ranks_keeping_over_alike
    {R : (Nat → Bool × Nat → Nat) → (Nat → Bool × Nat → Nat) → Prop}
    (irrefl : ∀ a, ¬ R a a) (trans : ∀ {a b c}, R a b → R b c → R a c)
    (widening : ∀ {a b}, web.Widens a b → R a b) : ¬ web.RanksKeepingOverAlike R
```

  It needs no invariance: ranking the whole class ranks the mirrored pair too, which supplies the second, crossed ranking.
- *The one-pair law.* A transitive relation containing widening and unchanged by exchanging the sides, which ranks the growing course above the other, ranks it above itself (`Sides.keeping_over_alike_cycles`). Without the exchange that one ranking is consistent: widening with the one pair added and closed (`Sides.onePair`) is a strict partial order containing widening that ranks the growing course above the other (`Sides.exchange_needed`).
- *One verdict only.* The cycle forbids ranking the growing course above the other, not the reverse. A strict partial order containing widening and unchanged by the exchange ranks the other course above the growing one (`Sides.reverse_consistent`); so does one that counts scale (`Sides.scale_counts`, below).
- *Scope.* The other course admits infinitely many formations. Where a static course's admissions are held by a list, the ranking is consistent:
  - `Web.ListedOrder` is widening joined to one more ranking: for each pair of the class whose static course has listed admissions (`Web.KeepingOverListedAlike`), every course that includes its keeping course is put above every course that its static course includes.
  - On every web it is a strict partial order containing widening that ranks every such pair (`Web.ListedOrder.irrefl`, `.trans`, `.ranks`). Irreflexivity and transitivity come from the pigeonhole of `KeepsWidening.gathers`: a listed static course includes no course keeping widening by name (`Web.not_listed_includes_keeping`).
  - On the two-sided web it ranks the growing course above `Sides.firsts` (the first formation of each side, at every step), where widening or eventual widening is silent both ways (`Sides.listed_consistent`).
  - **[AI reading]** The cycle is driven by scale: an infinitely wide static course and a growing course each widen the other's mirror.
- *What each premise does.* The class law uses irreflexivity, transitivity and containing widening. The one-pair law uses the exchange, and `exchange_needed` shows it is needed there.
- *Reading.* The exchange states that no formation counts by its name: relative anonymity (permutation invariance) across formations. It does not exclude counting scale (`scale_counts`): widening joined to the strict part of "at least as many formations at every step" (`Sides.ScaleAtLeast`, `Sides.scaleOrder`) is a strict partial order containing widening, unchanged by the exchange, and it ranks the other course above the growing one by scale alone. So 07's "counting neither novelty nor scale" needs another reading; law 4 gives one.

### Law 2. Widening with a lag is a strict partial order that decides the lag

- *The definitions.*
  - `l` includes `l'` with lag `d` when every formation `l'` admits at a step, `l` admits `d` steps later (`Web.IncludesLater`); with lag `0` this is inclusion.
  - `l` widens `l'` with a lag when it includes it with some lag and `l'` includes `l` with none (`Web.WidensWithLag`).
- *Its order laws.*
  - Inclusion with a lag is reflexive and transitive, lags adding (`IncludesWithLag.refl`, `IncludesLater.trans`).
  - One order lemma gives the rest: the strict part of a preorder, joined to a transitive relation inside it, is transitive (`strictJoin_trans`), and joined to an irreflexive one, irreflexive (`strictJoin_irrefl`). So widening joined to the strict part of any preorder containing inclusion is a strict partial order containing widening (`Web.strictJoin_order`).
  - Widening or widening with a lag (`Web.WidensOrWithLag`) is its case for inclusion with some lag (`WidensOrWithLag.irrefl`, `.trans`, `.of_widens`). It never reverses widening (`Widens.not_reversed_withLag`), and widening with a lag composes with widening on either side (`Widens.trans_withLag`, `WidensWithLag.trans_widens`).
- *Invariance, and what it reads across steps.*
  - On every web it is unchanged by every renaming constant across steps (`Web.widensOrWithLag_rename`, from `Web.includesLater_rename`). On the two-sided web it is unchanged by the exchange (`Sides.widensOrWithLag_swap`).
  - It compares formations across steps by name. On a web of two formations, `later` widens `once` with a lag; once the two names are exchanged from step one on, it does not, while widening is unchanged by every re-identification (`Relabel.lag_reads_names`, `Web.widens_reidentify`).
  - Along a continuation `R` the lag need not read names. `l` includes `l'` with lag `d` along `R` when every formation `l'` admits at a step is linked along `R`, `d` steps later, to one `l` admits (`Web.IncludesLaterAlong`). Widening joined to its strict part (`Web.WidensOrWithLagAlong`) is a strict partial order containing widening (`widensOrWithLagAlong_order`). By name it is widening or widening with a lag (`widensOrWithLagAlong_itself_iff`). It is unchanged by every re-identification carrying the continuation (`widensOrWithLagAlong_reidentify`), and the verdict `lag_reads_names` lost comes back along the carried continuation (`Relabel.along_restores`). This puts the lag on the footing of keeping widening (`KeepsWidening R`, `keepsWidening_reidentify`).
- *Where it decides.*
  - It decides UE4's lag: the lagging course widens the travelling one with a lag (lag one), where neither eventually widens the other (`LagWitness.widensWithLag`, `LagWitness.decided`).
  - The lag's form does not matter. A lag varying with the formation (`Web.IncludesWithFormationLag`) and a lag for each admission (`Web.IncludesEachLater`) are again preorders containing inclusion, so `strictJoin_order` makes each, joined to widening, a strict partial order containing widening; each decides the lag (`LagWitness.formationLag_decides`, `LagWitness.eachLag_decides`).
  - The lag can also be decided on the tail side. Inclusion with a lag from some step on (`Web.TailLag`), its strict part joined to widening or eventual widening (`Web.TailOrder`), is a strict partial order containing both widening and eventual widening on every web (`Web.tailOrder_order`), and it ranks the lagging course above the travelling one (`LagWitness.tailOrder_decides`).
- *Where it is silent.* By law 1 it cannot rank the growing course above the other. It is in fact silent both ways (`Sides.silent`), since neither includes the other at any lag: the growing course never admits `(false, 0)`, which the other admits at step `0`, and the other never admits `(true, 1)`, which the growing course admits at step `1`. Law 1 does not require this (`reverse_consistent`).
- *Widening with a lag alone does not contain widening.* The rising course widens the lagging one, its copy one step late, and the lagging one includes it with lag one (`Delayed.widens_not_withLag`). So the disjunction is needed.

### Law 3. Widening with a lag and eventual widening disagree

- *The witness* (`TailAndLag`). On the web of `OwnCondition`, the course ahead admits at step `t` the formations from `1` to `t + 1`. The early course admits formation `0` at step `0`, and the formations from `1` to `t + 1` at step `t + 1`.
- *Two verdicts.* The course ahead eventually widens the early one, including it from step one and exceeding it at every step. The early one widens the course ahead with a lag: it includes it with lag one, and the course ahead never admits formation `0` (`TailAndLag.disagree`).
- *The law.* On the own-condition web, no strict partial order contains both eventual widening and widening with a lag (`TailAndLag.no_order_contains_both`). The conflict survives a lag varying with the formation or for each admission, since the course ahead never admits formation `0` (`TailAndLag.formationLag_conflict`, `TailAndLag.eachLag_conflict`).
- *Where that leaves the orders.* Widening with a lag decides UE4's lag. So does the tail order, which contains eventual widening (law 2). Widening with a lag and eventual widening exclude each other (law 3). A comparison that counts what early steps admit and one that reads only tails part there, and the lag does not choose between them.
- *Why the choice matters for 07 §2.* The tail order contains eventual widening, so it ranks the course ahead above the early one, which admitted formation `0` at step `0`; the course ahead never admits it (`TailAndLag.tailOrder_loses`). Widening or widening with a lag never ranks a course so: what the other admits at a step, the course admits at that step or a later one (`Web.WidensOrWithLag.includesEachLater`).

### Law 4. Keeping what the other keeps

- *The condition.* `l` keeps what `l'` keeps when every formation `l'` admits at every step from some step on, `l` admits at every step from some step on (`Web.KeepsWhatKept`).
- *Who meets it.* Widening or widening with a lag, and the tail order, rank a course above another only where it keeps what the other keeps (`Web.WidensOrWithLag.keepsWhatKept`, `Web.TailOrder.keepsWhatKept`).
- *What it excludes on law 1's witnesses.* Neither the growing course nor the other keeps what the other keeps, and the growing course does not keep what the first formations keep (`Sides.keeping_reading`). So, under it, law 1's pair is unranked both ways with no exchange, and the reverse ranking by scale (`scale_counts`) and the listed ranking above `firsts` are excluded.
- *What it is not.* It is a necessary condition, not an order. It reads lasting admissions, so a loss confined to a finite stretch does not violate it, and by itself it does not meet 07 §2's objection to eventual widening.
- **[AI reading]** It is closer to "counting neither novelty nor scale" than the exchange: neither novelty nor scale can outweigh a lasting loss.

## 3. What it shows, and what it does not

**Shows**, on what courses admit:
- The second-order comparison 07 asks for cannot be "a course that keeps widening is better than one that admits alike and was wider at first", applied wherever the two are mixed, if it is to be a strict partial order containing widening, where the one merely wider now may admit infinitely many formations at once. A single growing course and a single fixed one, with their mirrors, already force the cycle. Where the static course's admissions are listed, the ranking is consistent.
- UE4's lag is decided by widening with a lag, and by the tail order, which contains eventual widening. Widening with a lag and eventual widening exclude each other, so an account that adds either to widening has chosen between counting what early steps admit and reading only tails. The lag does not make that choice, and the choice is a premise.
- Keeping what the other keeps is met by widening with a lag and by the tail order, and excludes both rankings of law 1's pair, ranking by scale among them.
- The tail order ranks a course above one that admitted a formation the first never admits; widening with a lag never does.

**Does not show:**
- that widening with a lag, or the tail order, is the second-order direction of 生生. Widening with a lag ranks courses by what each keeps of the other's admissions over time, which is closer to nothing lost across time than to a range whose widening keeps widening [AI reading];
- anything about 07's other two candidates, what a course keeps reachable and what carries its openings, which are not read on admitted ranges;
- an impossibility for comparisons that are not strict partial orders or do not contain widening, or for the class restricted to listed static courses, where the ranking is consistent;
- that any of this ranks a course better. Ranking needs C, and a choice between the tail and lag readings would be a further premise, as C∞ is for eventual widening.

## 4. Standing and neighbours

Each law is near-definitional: law 1 is a cycle of two crossed rankings, law 2 the strict part of a preorder joined to widening, law 3 a two-course disagreement, and law 4 a condition checked on witnesses. The neighbours, as the review confirmed them by standard web search (several only through abstracts or later papers; the review's check 5 gives each source's level):

- **Infinite ethics and social choice.** Law 1's one-pair form has the shape of Askell's (2018) incomparability argument, in which Pareto, transitivity, permutability of populations and invariance across qualitative duplicates jointly force incomparability between infinite worlds; here it runs in one direction only. The exchange is relative anonymity, or permutation invariance, across formations (Sen 1984; Asheim, d'Aspremont and Banerjee 2010; Goodman and Lederman 2024). Diamond (1965) and Basu and Mitra (2003), on finite anonymity with continuity or a real-valued representation, are distant. Ranking by the number of options follows from three axioms on opportunity sets (Pattanaik and Xu 1990), the neighbour for counting scale.
- **Extension of a relation to an order.** Suzumura consistency (Suzumura 1976) and Szpilrajn's extension theorem (1930) are vocabulary only: law 1 exhibits a cycle and uses no extension theorem.
- **Tails and dictatorships.** Chichilnisky (1996): eventual widening is decided by tails, like a dictatorship of the future; widening with a lag constrains every step and is not a dictatorship of the present.
- **Comparisons up to a delay.** Delayed simulation for Büchi automata (Etessami, Wilke and Schuller 2001; 2005) answers each acceptance at the same or a later step, without bound, like a lag for each admission. Delay games with bounded lookahead (Hosch and Landweber 1972; Holtmann, Kaiser and Thomas 2012) are closer to a uniform lag. Overtaking and catching up (Atsumi 1965; von Weizsäcker 1965; refined by Gale 1967 and Brock 1970) compare partial sums over late horizons: scalar, and distant.

Law 1's one-pair form has a close prior shape (Askell); laws 2 and 3 have no closer neighbour than those above, and law 4 is a condition, not a result. The contribution is reading them on admitted ranges, where 07's question is posed.

## 5. Pure core

- 141 theorems in 176 declarations, every axiom report empty (`scratch_build.py`, [scratch.log](scratch.log)). Term proofs only, no tactic blocks.
- Every decision comes from structural recursion or pattern matching on constructors. `Nat.succ_ne_zero` depends on `propext` in this Lean version, so the kit uses `Nat.noConfusion` after a case split.
- The general lemma (`strictJoin_trans`, `strictJoin_irrefl`) and link composition (`Web.Linked.append`) stay in the leaf. They would belong below (`Prelude`, `ContinuedClasses`), but moving them would rebuild everything above those modules; that is the integrator's choice, as for UE7's `Web.Linked.snoc`.
- What the report does not catch lies in the modelling:
  - discrete steps and whole-number levels;
  - admission as meeting each need, by name, over a fixed type of formations;
  - the lag compares formations across steps by name (along a continuation it need not);
  - law 1's cycle needs a static course admitting infinitely many formations;
  - the lag's form: laws 2 and 3 hold as well for a lag varying with the formation or for each admission.

## 6. The review and the fix round

The [review](REVIEW-UE9.md) found the Lean sound and the core pure, and the note claiming more than the Lean showed: 1 error, 5 overclaims, 6 imprecisions, 7 suggestions. Every finding was taken; its probes were folded into the module, renamed where a prime marked a second form.

| Finding | What was done |
|---|---|
| E1 (law 1 forbids one verdict) | §2 law 2 "Where it is silent" rewritten; `reverse_consistent` added (part A2). |
| O1 (the class law needs no exchange) | `no_order_ranks_keeping_over_alike` takes no exchange (part A1); the exchange stays in the one-pair law. |
| O2 (the lag decided on the tail side) | `Web.TailOrder`, `tailOrder_order`, `LagWitness.tailOrder_decides` added (part C, S4); law 3's last items and §3 rewritten, with `TailAndLag.tailOrder_loses` and `Web.WidensOrWithLag.includesEachLater` for why the choice matters. |
| O3 (names across steps) | `Web.widensOrWithLag_rename`, `Web.widens_reidentify`, `Relabel.lag_reads_names` added (parts B, F), and the lag along a continuation (S3); §5's modelling list. |
| O4 (infinite width) | `Web.ListedOrder`, `Sides.listed_consistent` added (part A3); scope in law 1, §3 and §5. |
| O5 (the exchange admits scale) | `Sides.scale_counts` added (part G); law 1's reading rewritten. |
| I1–I4 (neighbours) | §4 rewritten with the review's descriptions. |
| I5 (the lag's form) | the formation and per-admission lags with their decisions and conflicts added (part B); §5. |
| I6 (law 3's web) | stated on the own-condition web, in the module and here. |
| S1 | `Delayed.rising_iff` and `Sides.not_not_bool` dropped for `OwnCondition.rising_iff` and `Bool.not_not`. |
| S2 | one order lemma; the transitivity of widening or widening with a lag, the tail order, the lag along a continuation and the scale order derived from it. |
| S5 | the cycle stated on every web, more generally than proposed (two crossed rankings, no map), with both forms of law 1 as instances. |
| S6 | law 4. |
| S7 | the leaf's reason for the board row at landing (§7). |

## 7. Landing (after UE7, through the queue)

- **Module.** `Becoming.ComparingCourses` in the core, as a leaf: alternative comparisons and their witnesses, which no module below uses and C's order does not adopt, so nothing imports it.
- **Record.** One near-definitional record, homed in 07 §2 after r-what-keeping-widening-needs, claiming what the review's last section allows and nothing it rules out.
- **07's Open item.** Narrowed: on admitted ranges, no strict partial order containing widening ranks every course that keeps widening above every course that admits alike, was wider at first and is mixed with it, where the latter may admit infinitely many formations; where its admissions are listed, one does. UE4's lag is decided by widening with a lag and also by a tail form of it, which contains eventual widening, so the lag does not choose between the two; widening with a lag and eventual widening exclude each other. What a course keeps reachable and what carries its openings remain.
- **08 §8.** A line beyond the table: Askell (2018) for law 1's shape, relative anonymity for the exchange, Chichilnisky (1996) for eventual widening as decided by tails, delayed simulation as the analogue of a lag for each admission.
- **UE4's record.** Its counterexample, "a lag defeats eventual widening", stays true; its next delta can point here for the lag's decision.
