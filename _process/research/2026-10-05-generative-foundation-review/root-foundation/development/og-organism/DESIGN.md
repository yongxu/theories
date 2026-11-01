# OG: an organism on the root — design

AI-written design, 1 November 2026, by OU's owner. Third draft, after one independent reading and its re-check ([REVIEW-1.md](REVIEW-1.md)), every finding taken. The Lean is in scratch, and its reading ([REVIEW-2.md](REVIEW-2.md)) narrowed what it proves: §8 says what it proves, and where §2–§7 promise more, §8 holds. Every reading is an AI reading. Reading time: about 12 minutes.

## 0. Why this item

Plan §十三 item 9 asks that each test system of plan §六 have its model, on which the grammar's 续 and 时 give the right distinctions, or that the shortfall be written. The one page names two systems with no model yet: an organism and an institution.

What the package already has, which this item builds on and does not repeat:

- **03 §3, the rooms** (`rooms-tested-by-a-window`, landing with OU7): they tell regulation from equilibrium by a draw. The heater is a parameter of the rule, not a part of the net, and nothing keeps it.
- **04 §8** (`LivingOrganizationCorrespondence`): a closed pool of recipes with gate laws, distinguishing an organism from its supporting relations within one history.
- **02's feeding closure** (`r-feeding-closure`) and **03's** `where-a-formations-acts-return`: the loops by which a formation conditions itself. The thermostat meets the second, since the room's temperature conditions the reading at the next step (01-ROOT line 35).
- **The grammar's flame** (`«火薪相须»`, `«以核为判据则火无续»`): fire and fuel need each other, both ways. So a cycle between a part and what it feeds on does not mark an organism off from a flame.

## 1. The guess, restated

**Guess** [AI reading]. What an organism has, and a flame and a thermostat lack, is **a reader with its own continuation, turned over and rebuilt from the level it reads**. Its units each last a span longer than one step and then end; new units are made only from the level.

What this changes in the course is the guess's whole content. Under a cut in the supply, the reader's end comes at a horizon set by the stock, and once the reader has ended, the organism does not begin again, whether the supply returns or not. A cycle at the kind grain is not the criterion. The flame and the thermostat have cycles too.

**Correspondences** (named, not warrant). The family's organism is a minimal case of self-maintenance: one constraint, with turnover, regenerated from the flow it regulates. It lies below each of these, and is not their form on the root:

- **Closure of constraints** (Montévil and Mossio 2015) asks for at least two constraints that depend on each other. The level is a flow, not a constraint.
- **Autopoiesis** (Maturana and Varela) asks for a boundary the network produces. Here the boundary is given.
- **Closure to efficient causation** (Rosen) asks that every efficient cause be produced within. Here the rebuild rule is given.

## 2. One rule, a family of nets

Everything is in whole units with discrete steps.

**Occurrences are states.** A state holds:
- the level `L`;
- the reader as a list of unit ages, each below the span `s`, so units are tracked one by one and a fixed span is exact;
- the supply's phase, on or cut.

**The net of the possible branches** at each step on whether the supply is cut, or returns once cut. The return is a branch of the net, not a parameter. This is the rooms' device of the window as an alternative.

**One step, in this order** (the order is stated because the rooms show that it matters, `before_window_moves`). A cut or a return takes effect before step 2 of the step it comes in.
1. **Draw.** One unit of `L` goes to a sink, a listed relatum with its own amount. At `L = 0` the draw takes nothing.
2. **Read.** While the supply is on, the reader units read in turn: each takes one unit from the supply if `L` is then below its set level `m`. So the level never overshoots `m`.
3. **Age.** Every unit ages by one, and a unit reaching age `s` ends.
4. **Rebuild.** Where fewer than `n` units remain, one new unit, of age 0, is made from the rebuild's source.

**Where the reader's line ends:** at the first state whose list of units is empty. A unit ending at step 3 and replaced at step 4 of the same step leaves the list non-empty, so the reader goes on through it. Every start is fixed: `n` units, all of age 0. The rules are simulated in [sim/](sim/) (`sim.py`, `alt.py`, written by the reader, with the runs reported below).

The members differ only in step 4's source, and in the flame's intake:

| member | reader | rebuild source |
|---|---|---|
| (a) flame | none; intake a fixed `f` from the supply while `L > 0` | — |
| (b) equilibrium | none; an intake of one wherever `L < m`, balancing the draw, so the level rests while the supply is on | — |
| (c) given reader | span unbounded | none needed |
| (c′) rebuilt from the supply | span `s` | the supply, one unit, while it is on |
| (c″) never rebuilt | span `s` | none |
| (d) organism | span `s` | the level, one unit, where `L ≥ 1` |

The rooms' `exchange` is not reused. In this rule the draw is one way, toward the sink, and (b) is at rest only through its intake. The rooms are cited as the analogue. Their stage law is not claimed as an instance.

## 3. The laws to prove

The reader's re-check ran the rule as written on small cases (span `s` = 2 to 5, set count `n` = 1 to 3, `m` = 2 or 3, stock `L₀` up to 30), and the laws below are stated from those runs. Each is still to be proved, and the runs are not proofs.

- **L0, kept while supplied.** In (d), with the supply on, a non-empty reader never ends, from every stock, `L₀ = 0` included, and still with one more unit drawn at every step. The runs found no end in 200 steps at any case tried. (c′) is kept likewise; (c″) ends at `s` with the supply on.
- **L1, the horizon set by the stock (centre, new).** In (d), under a cut from a stock `L₀`, the reader's line ends at a step `h(L₀, s, n)`:
  - `h` never decreases in `L₀` and is unbounded. It rises in jumps, with flat stretches: `h(0) = h(1) = s`, since at `L₀ = 1` the draw takes the one unit to the sink before any rebuild can use it.
  - For `n = 1`, each further `s + 1` units of stock buy `s` more steps: `h(L₀ + s + 1) = h(L₀) + s`. This held in every run, `s` = 2 to 5 and `L₀ < 30`. It is to be proved by induction.
  - For `n ≥ 2` the horizon grows more slowly in the runs: about one step for every two units, at `s` = 2 to 4, against `s` steps for every `s + 1` at `n = 1`. A larger reader consumes the stock that would carry it. Bounds are checked by `decide`, and stated only as far as proved.
  - **Where the condition fails, so does the law:**
    - (c) never ends;
    - (c′)'s horizon is `s` whatever `L₀` is, since its rebuild stops with the supply;
    - (c″) ends at `s` with the supply on.

    This is the separating content: only where the rebuild draws on the level does the stock buy time.
- **L2, the end absorbing (a fact of (d)).** Once (d)'s reader has ended, the empty reader stays empty on every branch, the supply returned or not. It is a one-step invariant: at `L = 0` with no units, nothing is read and nothing is rebuilt.
  - **The contrast is with (c′),** which recovers after a return.
  - **(c″) is absorbing too,** as is (a). L2 does not separate (d) from them. L1 does, together with L0 for (c″).
  - **(c) meets L2 vacuously,** since its reader never ends.
- **The family law, on L1.** Over the six listed members, the stock buys time under a cut, `h` unbounded in `L₀`, exactly where the reader has a span above one and is rebuilt from the level alone.
  - That condition is a parameter of the rule. So the law holds over the listed members, member by member, and by L1's induction on (d) at every `s` and `n`. It is not a law of every net.
- **The organism's class is "reader present"** (renamed from "reader present and level held"). With the supply on, (d) does not hold its set level: in the runs, `n = 1` stays at `L` in {0, 1}, and `n ≥ 2` at `m − 1` or between `m − 1` and `m`. The rebuild is paid from the level after the read has topped it up. Moving the read after the rebuild is no fix, since every member then dies with the supply on (`alt.py`).
  - **The window claim of the second draft is dropped.** With the supply on, an extra draw of one at every step does not end (d)'s reader at any case run, and (d) never held its level to begin with. L0 states what is true: kept while supplied, even under a draw.
- **L3, turnover (an instance, if available).** In (d), with the supply on, the line under "reader present" goes on, by L0, while every unit's line ends at `s`. It is reported as an instance of carrying (`PatternPassing`, `Web.carrying`), only if the state net can be read as a `Web`. Otherwise it is a witness on the grammar.
- **Grain, a witness.** The organism's class ends where its matter, counted at the sink, goes on at the coarser class "units of amount". That is a further witness of the existence statement `«亡于细者不必亡于粗»`.

**Reading of the kind grain** [AI reading]. In (d) the reader's kind and the level's kind form one cluster at the kind grain, with no precedence defined between them (`«俱有»` on `«粗»`, GrammarCandidates). In (c) the same holds, through the reading. So the grain does not tell (c) from (d), and nothing here calls the kinds simultaneous. L1 tells them apart.

## 4. What would refute the guess

- **L1 fails in (d) at some `s` and `n`:** the horizon stops growing with the stock, or the `n = 1` step law fails beyond the runs. The guess is then wrong as stated, and the counterexample is the result.
- **No course separates (c′) from (d) in the window and the cut together.** Then the root tells the organism from a reader rebuilt from outside only by its rule, and that shortfall is written.

## 5. Not claimed now: the World

Three readings would place the family on the World's flows. Each needs the state net embedded there first. The rooms list the same embedding as open.

- **EL3's horizon law** (`degeneration-from-a-horizon`).
- **04 §1's conveyance** (`conveyance-crosses-the-boundary`). Its conclusion is that the region is from no step on left uncrossed, which is weaker than crossed at every step from some step on. It needs a family taken from at arbitrarily late steps, which the cut branch fails.
- **BD4's balance on two-way closures.** It needs listed relata and conserved transfers. The rule gives the supply and the sink amounts for that reason, but BD4 has not landed.

EL2's regime of a draw on a condition given nothing does not apply: its draws double, and here the draw is constant. The closer law is the gated run-down at its horizon (EL2 laws 2 and 9). Whether L1 is an instance of it is checked at the Lean, and said either way. All of this is OG's part 2, after the embedding.

## 6. What it does not do

- **An actual organism:** that (d) describes a cell is a correspondence duty, not a theorem.
- **Not in the model:** chemistry, real amounts, continuous time, development, a produced boundary, two constraints that depend on each other.
- **Division** (a birth at the organism's class and a continuation at the lineage's) waits for part 2.
- **An institution:** a separate item. Its guess is a rule turned over and re-made from the members it regulates. Whether L1 and L2 carry over is that item's question.

## 7. Lean plan

- One pure-core leaf, `Becoming.ReaderRebuilding` (named after its Lean reading: the rule rebuilds, not the reader). It imports the grammar, not the rooms' module, so it needs nothing from OU7. Every axiom report is empty.
- **Small members:** decided by `decide` at small spans and stocks. **L0, L1 and L2:** proved by induction on the steps of (d), at every `s` and `n`; the step law for `n = 1` by induction on `L₀`.
- **Record:** `the-stock-buys-time-where-the-rebuild-draws-on-it`, with its home in 04 §8 beside `LivingOrganizationCorrespondence`, and a line in 01 §8.7's test systems.
- **Then:** claim on the board with the head free; scratch Lean; one reader on the Lean; landing on the coordinator's word.

## 8. What the Lean proves

`Becoming.ReaderRebuilding` ([scratch](scratch/Becoming/ReaderRebuilding.lean)): 32 theorems in 48 declarations, every axiom report empty ([build.log](build.log)). It models four members, the given reader (c), the reader rebuilt from the supply (c′), the one never rebuilt (c″) and the one rebuilt from the level (d). The supply is a choice at every step, so every sequence of on and off is a course.

- **L0, proved in general.** In (d), at `n ≥ 1` and `m ≥ 1`, a present reader is present after a supplied step from every level, and its region is closed under the supplied step. With the supply on, the level before the step plays no part. So a window tests nothing in this rule, and the window theorem of the scratch's first build is folded into L0.
- **L1, a lower bound that grows with the stock.** In (d), under a cut, the reader is present after `k + 1` steps from every level of at least `2 (k + 1)`, whatever it was at the start, an empty reader included, since the rule's rebuild makes a unit from the level. (c′) and (c″), from `n` new units, are gone after `s` steps of cut from every level.
  - **Not proved:** that (d) ends from every stock; that its horizon never decreases in the stock; any rate for `n ≥ 2`.
  - **Decided only:** the one-unit step law, `h(L₀ + s + 1) = h(L₀) + s`, at spans two and three, `m = 2`, levels below fifteen or sixteen. It is a conjecture those cases check. The flat stretch is `h(0) = … = h(s) = s`.
- **L2.** In (d), a reader gone after a step leaves the level at `0`, and that state is closed under the net, because the read needs a unit and the rebuild a stock. It is closure of that one state, which is every end a step reaches. (c′) is present again after one supplied step.
- **The family law.** Over the four members, at `n ≥ 1` and `s ≥ 1`, the stock buys time under a cut, with an end from an empty stock, exactly where the rebuild draws on the level. It holds at a span of one, so the turnover, the guess's "span longer than one step", is not what separates the members: the rebuild's source is. §1's guess is narrowed to that.
- **Not modelled:**
  - the flame (a) and the equilibrium (b);
  - the supply's and the sink's amounts;
  - L3's turnover read as carrying, and the grain witness.

  These wait for part 2.
