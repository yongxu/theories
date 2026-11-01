# OG: an organism on the root — design

AI-written design, 1 November 2026, by OU's owner. Second draft, after one independent reading ([REVIEW-1.md](REVIEW-1.md)), all ten of whose findings are taken. Nothing here is proved yet. Every reading is an AI reading until its Lean is checked. Reading time: about 12 minutes.

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

**One step, in this order** (the order is stated because the rooms show that it matters, `before_window_moves`):
1. **Draw.** One unit of `L` is lost to a sink, a listed relatum with its own amount.
2. **Read.** While the supply is on, each reader unit takes one unit from the supply wherever `L` is below its set level `m`.
3. **Age.** Every unit ages by one, and a unit at age `s` ends.
4. **Rebuild.** Where the reader is below its set count `n`, one new unit is made from the rebuild's source.

The members differ only in step 4's source, and in the flame's intake:

| member | reader | rebuild source |
|---|---|---|
| (a) flame | none; intake a fixed `f` from the supply while `L > 0` | — |
| (b) equilibrium | none; the draw and an intake of one balance at `m`, so the level rests while the supply is on | — |
| (c) given reader | span unbounded | none needed |
| (c′) rebuilt from the supply | span `s` | the supply, one unit, while it is on |
| (c″) never rebuilt | span `s` | none |
| (d) organism | span `s` | the level, one unit, where `L ≥ 1` |

The rooms' `exchange` is not reused. In this rule the draw is one way, toward the sink, and (b) is at rest only through its intake. The rooms are cited as the analogue. Their stage law is not claimed as an instance.

## 3. The laws to prove

- **L1, the horizon set by the stock (centre, new).** Take any member whose units have a span `s > 1` and whose rebuild draws only on the level. Under a cut of length `k` from a state with level `L₀` and a full reader, the reader's line ends exactly where `k ≥ h(L₀, s)`. Here `h` is given in closed form and is strictly increasing in `L₀`.
  - Proof by induction on the steps.
  - **Where the condition fails, so does the law:** (c) never ends; (c′) ends at `k ≥ s`, whatever `L₀` is; (c″) ends with the supply on.
- **L2, the end is absorbing at the organism's class (new).** In such a member, once the reader's line has ended, the class "reader present and level held" begins again on no branch of the net, the supply returned or not.
  - **Where it fails:** (c′) recovers after the return, because its rebuild draws on the supply. And (a), with no reader, is absorbing too. So absorption does not mark (d) off from the flame. The pair L1 with L2 does: the flame's going out has no horizon set by a stock of its own maker.
- **Together, the conditional law on the family.** A member meets L1 and L2 together exactly where its reader has a span above one and is rebuilt from the level alone. Each other member is a net where the condition fails and the conclusion fails with it.
  - This is a law over the stated family, proved member by member and by the general induction of L1 and L2 on the class of rules the condition picks out. It is not a law of every net.
- **L3, turnover (an instance).** In (d), at every positive margin with the supply on, the line under the organism's class goes on while every reader unit's line ends. It is reported as an instance of carrying (`PatternPassing`, `Web.carrying`), only if the state net can be read as a `Web`. Otherwise it is a witness on the grammar, and is reported as such.
- **The window (re-proved, parameter-dependent).** An extra draw of one, as an alternative in the net: (c), (c′) and (d) restore after every draw within the margin. (b) does not. (a) holds exactly where `f` is at least the draw. Stated with its parameters, not as the rooms' law.
- **Grain, a witness.** The organism's class ends where its matter, counted at the sink, goes on at the coarser class "units of amount". That is a further witness of the existence statement `«亡于细者不必亡于粗»`, not an instance of a universal law.

**Reading of the kind grain** [AI reading]. In (d) the reader's kind and the level's kind form one cluster at the kind grain, with no precedence defined between them (`«俱有»` on `«粗»`, GrammarCandidates). In (c) the same holds, through the reading. So the grain does not tell (c) from (d), and nothing here calls the kinds simultaneous. L1 and L2 tell them apart.

## 4. What would refute the guess

- **L1 fails for some member meeting the condition:** the horizon does not grow with the stock, say, because the reading order lets the rebuild outrun the drain. The guess is then wrong as stated, and the counterexample is the result.
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

- One pure-core leaf, `Becoming.SelfRebuiltReader` (name fixed at claim time). It imports the grammar, not the rooms' module, so it needs nothing from OU7. Every axiom report is empty.
- **Small members:** decided by `decide` at small spans and stocks. **L1 and L2:** proved by induction on the class of rules the condition picks out.
- **Record:** `a-reader-rebuilt-from-what-it-reads` (name fixed at claim time), with its home in 04 §8 beside `LivingOrganizationCorrespondence`, and a line in 01 §8.7's test systems.
- **Then:** claim on the board with the head free; scratch Lean; one reader on the Lean; landing on the coordinator's word.
