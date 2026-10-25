# UE9: comparing two courses on what they admit (note)

AI-written, 26 October 2026, for board item UE9 under [UE](../ue-unified-explanation/PLAN.md), item 7 (the second-order direction of 生生). Kit: [`tree/Becoming/ComparingCourses.lean`](tree/Becoming/ComparingCourses.lean). It is pure core, building on the landed `Becoming.EventualWidening` and `Becoming.EventualWideningInstances`.

## 1. The question

07's open item asks for: "a comparison of a range whose widening keeps widening with one merely wider now, never reversing widening and counting neither novelty nor scale" ([07 Open](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#open)). [UE4](../ue4-second-order/DESIGN.md) gave eventual widening, first-order widening read on late tails. It named a lag that a second-order comparison should decide and eventual widening cannot (`LagWitness.lag`): the lagging course keeps widening and admits every formation of the travelling one a step later, yet the two are mixed on every tail. [UE7](../ue7-what-keeps-widening/NOTE.md) states what one course keeping widening needs; none of its laws compares two courses.

Here the comparison is read where widening reads: on what each course admits at each step. Three laws locate what it can be there.

## 2. The laws

**(1) Keeping widening over admitting alike closes a cycle.**

- *The web.* `Sides.web` has formations on two sides, `(b, n)` with `b : Bool`, each requiring only its own condition, at need one.
- *The two courses.* The growing course (`Sides.growing`) admits, at step `t`, the formations `(true, n)` with `n ≤ t`. The other course (`Sides.firstAndOther`) admits, at every step, `(true, 0)` and every `(false, n)`.
  - The growing course keeps widening by name from the first step (`growing_keepsWidening`).
  - The other admits alike from the first step (`firstAndOther_alike`) and is wider up to the first step (`firstAndOther_wider_first`).
  - The two are mixed (`growing_mixed`).
- *The cycle.* Exchanging the sides (`Sides.swap`) carries the pair to its mirror. The other course widens the mirror of the growing one (`firstAndOther_widens_swapped`), and the mirror of the other widens the growing one (`swapped_widens_growing`).
- *The law.* A transitive relation containing widening, unchanged by the exchange, that ranks the growing course above the other, ranks the growing course above itself:

```lean
theorem keeping_over_alike_cycles
    {R : (Nat → Bool × Nat → Nat) → (Nat → Bool × Nat → Nat) → Prop}
    (trans : ∀ {a b c}, R a b → R b c → R a c) (widening : ∀ {a b}, web.Widens a b → R a b)
    (exchanged : ∀ {a b}, R a b → R (swap a) (swap b)) (ranks : R growing firstAndOther) :
    R growing growing
```

So no strict partial order containing widening and unchanged by the exchange ranks every course keeping widening above every course that admits alike, is wider up to the first step and is mixed with it (`Sides.no_order_ranks_keeping_over_alike`, against `Web.RanksKeepingOverAlike`).

- *What each premise does.*
  - **The exchange.** Widening with the one pair added and closed (`Sides.onePair`) is a strict partial order containing widening, and it ranks the growing course above the other (`Sides.exchange_needed`).
- *Reading.* The exchange is the account's "counting neither novelty nor scale" read as invariance under renaming formations. It is a reading of that phrase, stated here as a hypothesis.

**(2) Widening with a lag is a strict partial order that decides the lag.**

- *The definitions.*
  - `l` includes `l'` with lag `d` when every formation `l'` admits at a step, `l` admits `d` steps later (`Web.IncludesLater`); with lag `0` this is inclusion.
  - `l` widens `l'` with a lag when it includes it with some lag and `l'` includes `l` with none (`Web.WidensWithLag`).
- *Its order laws.*
  - Inclusion with a lag is reflexive and transitive, lags adding (`IncludesWithLag.refl`, `IncludesLater.trans`).
  - Widening with a lag is irreflexive and transitive, and composes with widening on either side (`Widens.trans_withLag`, `WidensWithLag.trans_widens`).
  - So widening or widening with a lag (`Web.WidensOrWithLag`) is a strict partial order containing widening (`WidensOrWithLag.irrefl`, `.trans`, `.of_widens`). It never reverses widening (`Widens.not_reversed_withLag`).
- *Invariance.* On the two-sided web it is unchanged by the exchange (`Sides.widensOrWithLag_swap`).
- *Where it decides and where not.*
  - It decides UE4's lag: the lagging course widens the travelling one with a lag (lag one), where neither eventually widens the other (`LagWitness.widensWithLag`, `LagWitness.decided`).
  - By (1) it must be silent between the growing course and the other, and it is (`Sides.silent`).
  - Widening with a lag alone does not contain widening. The rising course widens the lagging one, its copy one step late, and the lagging one includes it with lag one (`Delayed.widens_not_withLag`). So the disjunction is needed.

**(3) Widening with a lag and eventual widening disagree.**

- *The witness* (`TailAndLag`). On the web of `OwnCondition`, the course ahead admits at step `t` the formations from `1` to `t + 1`. The early course admits formation `0` at step `0`, and the formations from `1` to `t + 1` at step `t + 1`.
- *Two verdicts.* The course ahead eventually widens the early one, including it from step one and exceeding it at every step. The early one widens the course ahead with a lag: it includes it with lag one, and the course ahead never admits formation `0` (`TailAndLag.disagree`).
- *The law.* No strict partial order contains both eventual widening and widening with a lag (`TailAndLag.no_order_contains_both`).
- *Where that leaves the two orders.* Widening or eventual widening (UE4, `WidensOrEventually.irrefl` and `.trans`) and widening or widening with a lag are each strict partial orders containing widening. The first reads only tails; the second counts every formation ever admitted, with delay. They cannot be held together.

## 3. What it shows, and what it does not

**Shows**, on what courses admit:
- The second-order comparison 07 asks for cannot be "a course that keeps widening is better than one that admits alike and was wider at first", applied wherever the two are mixed, if it is to be a strict partial order containing widening and unchanged by renaming formations. A single growing course and a single fixed one already force the cycle.
- One renaming-invariant strict partial order containing widening decides UE4's lag: widening with a lag. It and eventual widening exclude each other, so an account that adds either to widening has chosen. It counts what early steps admit, or it reads only tails, and the choice is a premise.

**Does not show:**
- that widening with a lag is the second-order direction of 生生. It ranks courses by what each keeps of the other's admissions over time, which is closer to nothing lost across time than to a range whose widening keeps widening [AI reading];
- anything about 07's other two candidates, what a course keeps reachable and what carries its openings, which are not read on admitted ranges;
- an impossibility for comparisons that are not strict partial orders, not containing widening, or not invariant under renaming;
- that any of this ranks a course better. Ranking needs C, and a choice between the tail and lag readings would be a further premise, as C∞ is for eventual widening.

## 4. Standing and neighbours (to be graded by the review)

Each law is near-definitional: (1) is a four-course cycle, (2) the strict part of a preorder joined to widening, (3) a two-course disagreement. Neighbours:

- **Extension of a relation to an order.** Suzumura consistency (Suzumura 1976) and Szpilrajn's extension theorem (1930). Law (1) says that widening, joined to keeping widening over admitting alike and closed under renaming, is not Suzumura-consistent.
- **Infinite-horizon social choice.** Pareto with anonymity (Diamond 1965; Basu and Mitra 2003). There the symmetry permutes generations (times); here it renames formations, which is closer to neutrality. Chichilnisky (1996): the dictatorships of the present and of the future, which law (3)'s two orders are near.
- **Comparisons up to a delay.** Overtaking (von Weizsäcker 1965) and catching up (Gale 1967), which compare partial sums; delayed simulation for Büchi automata (Etessami, Wilke and Schuller 2001), a game form of inclusion with delay.

None is checked here against the source texts. The review checks them, and the record cites only what it confirms.

## 5. Pure core

- 58 theorems in 70 declarations, every axiom report empty (`scratch_build.py`, [scratch.log](scratch.log)). Term proofs only, no tactic blocks.
- Every decision comes from structural recursion or pattern matching on constructors.
- A lesson from the build: `Nat.succ_ne_zero` depends on `propext` in this Lean version, so the kit uses `Nat.noConfusion` after a case split.
- What the report does not catch lies in the modelling:
  - discrete steps and whole-number levels;
  - admission as meeting each need, by name, over a fixed type of formations;
  - the uniform lag in law (2). A lag that varies with the formation is a different relation, not studied here.

## 6. Landing (after UE7, through the queue)

- **Module.** `Becoming.ComparingCourses` in the core, as a leaf. It defines comparisons and witnesses no module below uses, and C's order does not adopt them, so nothing imports it.
- **Record.** One near-definitional record, homed in 07 §2 after r-eventual-widening.
- **07's Open item.** Narrowed: on admitted ranges, keeping widening over admitting alike is cyclic under renaming; the lag is decided by widening with a lag, which excludes eventual widening; what a course keeps reachable and what carries its openings remain.
- **08 §8.** A line beyond the table, with the neighbours the review confirms.
- **UE4's record.** Its next delta may point here.
