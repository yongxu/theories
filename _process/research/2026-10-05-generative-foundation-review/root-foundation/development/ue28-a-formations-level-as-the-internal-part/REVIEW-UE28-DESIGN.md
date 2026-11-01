# UE28: review of the design

AI-written by an independent reviewer, 1 November 2026.

**Summary.** The question is worth asking and Part B's necessity is correct: if a family read with a formation's level as the internal part is consistent part by part, then at two steps alike on the level, the value of what couples in and the act, the next levels agree. That follows from the agent's half of `BlanketConsistentFamily` and `Prod.fst`. The rest needs repair before Lean. Part A is either empty or ill-posed, and its timing does not match Part B's. The headline claims ("exactly where", and "a formation drained or fed by what does not couple into it is the interior of no blanket") are wrong as written: a balanced world refutes each of them. The reading `levelParts g` leaves open several choices that decide what the result says. And the witness as described has no level history balanced at every step. A probe checks each point in the pure core: 24 theorems, 74 declarations, every axiom report empty (`review-probes/`, log `review-probes/probe.log`). Count: 4 high, 7 medium, 4 low.

## Findings

### 1. High: Part A's hypothesis constrains nothing and `level_course` is a tautology, so the World's own exchange is still not the environment

**What is wrong.** `couplingLaw own policy value lev env` is UE27's law with `M := Nat`, by definition. `OwnMovesThrough own env` is called "the join's only hypothesis", but as described it has no object. `own` reads no rest, so "whatever the rest of the world is" holds automatically. The law's internal part moves by `own` by construction, and `env` is a parameter. In the closed loop the formation's level is not in `x`, so "the formation's own level history" can only be the internal course put back into a level function (`if c = g then internal n else lev n x c`). `level_course` is then `if_pos rfl`. The closed loop has no flow and no balance, so it is not a World. Part A therefore does not write "the World's own exchange as the environment", the item UE27 left open (UE27 DESIGN §3 A5, A7, §5). The sentence "the formation itself, not a model of it, is the blanketed agent" (A.2) renames the model's state "level". It shows nothing about a World.

**Fix.** Replace Part A with a correspondence theorem stated on a World (with Finding 2's timing). Take a world `w`, a formation `g`, `DecidableEq` on relata, `value` with `w.web.ValuesThrough obs g value`, and no self-coupling (Finding 6). The hypotheses are on `w`:

- `LevelMovesThrough own`: for every step `t`, `w.web.level (t+1) g = own (w.web.level t g) (value t (w.web.level t)) (act t)`.
- `ActMovesThrough policy`: for every step `t`, `act (t+1) = policy (w.web.level t g) (value t (w.web.level t)) (act t)`.

Here `act t` is `g`'s exchange row at `t`, read as listed values (Finding 5). The environment is the open loop on `w`'s own history with `g`'s entries blanked: the external part is `(t, rest t)`, and `env _ _ t _ := rest (t + 1)`. Conclusion: the law's course from `w`'s start has internal part `w.web.level n g`, sensory part `value n (w.web.level n)`, active part `act n`, and external part `(n, rest n)` at every `n`, in the manner of `ThresholdCase.corr`. This is near-definitional, but it is a statement about a World. Its two hypotheses are exactly what Part B shows necessary, so A and B together give an iff (Finding 3). Drop the closed loop, or call it a model beside the World, as UE27 does.

### 2. High: Part A's internal part runs one step behind Part B's reading and the World's balance

**What is wrong.** In `couplingLaw` the sensory part's next state is `value e.1 (lev e.1 e.2)`, the value at the current external part (`sensory_course`: the sensory part at `n + 1` is the value at step `n`). So the internal part moves by `m (n+1) = own (m n) (value at n-1) (a n)`. In a balanced World, and in `levelParts g` (the value of the levels at the same step `t`), the level moves by the value at `t`. The two conventions give different courses. In the probe's `LagWitness.lag` the level adds the value of a condition that flips between 1 and 0. At step 2 the same-step history is 1, while `couplingLaw`'s internal course is 2. So no correspondence between A's law and a World read as in B holds, unless `own` ignores the value.

**Fix.** Use a same-step coupling law. Its sensory part's next state is the value at the external part's next state, `nextSensory o a e := value (e.1 + 1) (lev (e.1 + 1) (env o a e.1 e.2))`. That is still `Blanketed`, since it reads only the sensory, active and external parts (probe: `sameStepLaw`, `sameStep_sensory` by `rfl`, and `lag`'s third conjunct). The cost: UE27's `sensory_course`, `blanket_iff_through` and `internal_through_couplings` do not hold of it "unchanged". Their indices shift by one (`n + 2` becomes `n + 1`), and they must be restated, or derived through a correspondence. The alternative is to keep `couplingLaw` and state the hypothesis with the previous step's value. But then `levelParts g` cannot read that value off one configuration. Whichever is chosen, Parts A and B must use one convention, and the design should say which.

### 3. High: "exactly where" is claimed with only one direction proved, and the converse is false in the stated reading

**What is wrong.** The Says bullet, the Standing ("holds exactly where") and the proposed 03 §1 text write "exactly where". Only necessity is in the plan (B.4). 08 §2 allows "exactly where" only for an `↔`. The converse fails in two ways.

- **The act.** The agent's half of consistency gives the next act as well as the next level. A formation whose level moves through but whose act does not is not consistent part by part. In the probe's `ActUnread`, a balanced world, `g`'s level stays at 3 and nothing moves it (`level_moves_through`). `g` takes one unit from `h` at step 1 only. At steps 0 and 2 the level, the value and the act agree, and the next acts are 1 and 0 (`not_consistent`).
- **The world's half.** Without the step in the external part, the world's next parts must be fixed by the value, the act and the rest. So `g`'s level may reach the rest only through `g`'s act. In the World that is a real condition. `g` is also a condition that other formations may require (`Becoming.Roles`). And Nat balance forces any drain to stop when `g`'s level is spent. In the probe's `SpentDrain`, `h` takes one unit at steps 0 and 1 and `g`'s level goes 2, 1, 0. The next level is read off the level (`moves`), and the agent's half holds (`agent_consistent`). The world's half fails at steps 0 and 1 (`world_not_consistent`).

**Fix.** State the iff the reading supports, and name its halves. One run, read by `levelParts g` with the step in the external part, is consistent part by part exactly where `g`'s level and act both move through its level, the value of what couples in and its act, along the run. This is choice-free: for one run the step separates every pair of steps, so the world's half holds (UE27's C1 point: for a single course the step suffices). For a family of runs, or without the step, add the world's clause: the value of what couples in next, and the rest next, are fixed by the value, the act, the rest and the step. In particular, `g`'s level reaches the rest only through its act. Replacement for the Says bullet: "In this reading, the formation's own level is the internal part of a law determined part by part, along one run, exactly where its next level and its next act are read off its level, the value of what couples into it and its act; across runs, also where the rest moves by what couples into the formation, its act and the rest, without reading its level." For "admitted by a `Blanketed` law" (functions), the functions `own` and `policy` must be given (Finding 1). Getting them from pairwise agreement needs choice, or a decided, listed domain (UE27's `blanketed_courses_consistent` note).

### 4. High: the slogan about what drains or feeds the formation is false, and the 03 §1 text confuses cause with determination

**What is wrong.** Says: "a formation drained or fed by what does not couple into it is the interior of no blanket on its couplings, whatever model of it is one". The proposed 03 §1 text: "exactly where nothing moves that level but what couples into it and its act". In the probe's `SteadyFeed`, `h` gives `g` one unit at every step. `h` does not couple into `g` (`h_uncoupled`: `g` depends on nothing and observes nothing). The flow balances, and `g`'s level rises by one at every step. The read run is the course of a blanketed law whose internal part is `g`'s level (`fed_blanketed`), and it is consistent part by part (`fed_consistent`). The other direction fails as well. A formation drained by a condition that does couple into it (by level, its level constant), taking at its first phase only, breaks the reading as the hidden drain does. The criterion is not where the exchange comes from. It is whether the net exchange into the formation is read off its level, its value and its act. "Moves" and "couples into" name different records: the flow's column against levels read through admission and `obs`. The World ties neither to the other ("Nothing here ties one record to another", `World.lean`).

**Fix.** Says: "a formation whose net exchange is not read off its level, the value of what couples into it and its act, whatever gives to it or takes from it, is in this reading the internal part of no law determined part by part. A model fed by what couples into it is still the agent of a blanketed law." 03 §1 (with Finding 9): `its own level such a part only where its next level and act are read off its level, what couples into it and its act ([§](#r-…))`. Drop "whatever model of it is one".

### 5. Medium: `levelParts g` leaves open choices that decide the result

**What is wrong, and the fix for each.**

- **(a) Configuration and move.** In a World, `g`'s take and give live in the move (`w.history.act t`), not in the snapshot. Suppose the reading keeps the exchange as the move. Then `PartConsistentFamily` compares whole exchanges (`m i = m' j`), and those include the column into `g`. Under balance, every family is then consistent on the level, so the necessity is empty and the witness disappears. **Fix:** the configuration is the pair (snapshot at `t`, exchange at `t`) and the moves are `Unit`. Say so.
- **(b) The sensory value.** `value : Nat → (C → Nat) → O` needs the step, and `ValuesThrough` is relative to one web. A map read off one configuration has neither. For a family of worlds, each world's `requires` and `need` differ. **Fix:** read the value off the snapshot, with admission at `g` decided (as a Bool) and `obs g` listed, as `Web.listed_values` does. Or carry the step in the configuration. Prop-valued admission cannot serve as the sensory part: comparing Props by `=` needs `propext`.
- **(c) The step.** Say whether the step is in the external part. This settles the world's half (Finding 3), and `couplingLaw` puts it there.
- **(d) Function-valued parts.** The act and the rest are functions on relata. Consistency compares parts by `=`, and getting `=` from pointwise agreement needs `funext`, whose proof uses `Quot.sound`. **Fix:** read the act and the rest on listed relata (`cs.map`), as `listed_values` reads the observed levels. Then agreement is equality of lists.
- **(e) The formation's other records.** `active t g`, `requires`, `need`, `draws` and `g`'s presence go to the external part by default. State that. Put presence with the act, since it decides whether `g`'s row counts.
- **Blanking.** Blanking `g`'s entries with `if r = g then 0 else …` is choice-free (`if_pos`, `if_neg`). `g`'s column in others' rows stays external, as it must.

### 6. Medium: the case excluded as self-coupling is the self-bearing formation, and embodied relata break the world's half

**What is wrong.** "A formation coupled into its own level is outside the reading" excludes exactly `Web.SelfBearing`. That is the case `Testing` names: a formation's own standing couples into it through support where it bears on itself. It is also the case `Roles` builds its living events on. A reader needs to know that the paradigm case is out. In the same way, for an embodied relatum (one that stands exactly while active), `g`'s activity in the external part is a function of its level, the internal part. So without the step, the world's half fails wherever its level crosses zero.

**Fix.** Name both exclusions with their Lean names in "Does not say". Better, repair the first: the agent reads its own level, so admission at `g` can be split into its own requirement (read off the internal part) and the requirements on others (the sensory part). Admission is a conjunction over the conditions required, so the split is exact. Put `g`'s activity on the agent's side (with the act), so embodied relata stay in the reading.

### 7. Medium: the witness as described is not a balanced World run, and its failure is not localized

**What is wrong.** "Taking one unit from `g` at its first phase only", with nothing given: `g`'s level goes L, L−1, L−1, L−1, L−2, …. Steps 1 and 3 (or 2 and 3) are alike on level, value and act, with next levels L−1 and L−2, so the arithmetic holds for L ≥ 2 before exhaustion. But under Nat balance the take at the first phase after the level is spent is impossible: `l (t+1) g + 1 = 0`. The probe's `DrainOnly.no_balanced_history` shows that no level history is balanced with this flow at every step, from any start. Without balance the "drain" is a level history beside an exchange that does not move it, which is `ReadsExternal` relabelled. Also, if `h`'s phase is recorded nowhere in the configuration (only in the step index), its second and third phases look the same in the rest. The world's half then fails too, and the witness no longer shows that the failure lies with the internal part.

**Fix.** Use a balanced periodic drain (probe: `PhasedDrain`). `h` takes one unit from `g` at its first phase and gives it back at its second. `h`'s phase is its own level, kept by giving to and taking from itself (`balances`). `g`'s level goes 1, 0, 1, 1, 0, 1, …. The agent's half fails at steps 2 and 3, with next levels 1 and 0 (`not_consistent`). The world's half holds (`world_consistent`, through `readNext_of_level`). A feed at one phase (no exhaustion) also works. Say in the Standing that this is `ReadsExternal`'s mechanism on a balanced World read by a partition fixed by the formation's own records, a witness and not a result.

### 8. Medium: the exchange form is stated at a strength Nat cannot carry, and "the others" and "its act" mislead

**What is wrong.** "What the others give to it and take from it, net, is read off …": in Nat the net exchange `given − taken` has no value without truncation. A functional form ("some function of level, value and act gives the next level") follows from the pairwise one only by choice. `Flow.taken t g` sums over every relatum present, `g`'s own self-entries included, so "the others" is inexact. And `g`'s act (its row) moves `g`'s level only through its self-exchange. Balance moves only the relatum taken from or given to (`Flow.Balances`), so a formation's taking does not raise its own level. Readers of "nothing moves that level but … its own act" will assume that it does.

**Fix.** State it pairwise. At two steps alike on `g`'s level, the next levels agree exactly where `given i g + taken j g = given j g + taken i g`. This is an exact `↔` under balance, with no subtraction (probe: `next_alike_iff_net_alike`, empty axiom report, through `Naturals.add_left_cancel` and `Naturals.add_right_cancel`; with the core cancellation lemmas in their place the probe's first audit reported `propext`). `movesThrough_iff_exchange` is this, lifted over steps alike on level, value and act. Write "what the relata present, itself included, give to it and take from it". Add one sentence: in the World a formation's own act moves its own level only through what it gives to and takes from itself.

### 9. Medium: the question misreads 03 §1's second half, and "the formation itself" overstates

**What is wrong.** 03 §1: "a formation's support and observed levels are its sensory states, what it keeps of them its internal states". "Them" are the sensory states, so the internal states are a fold of the sensory course. That is 03 §1's own "chooser that folds what couples in", which is UE27's model fed by the couplings. Reading "what it keeps" as the formation's level replaces the reading rather than testing it. The proposed text then drops the fold, which is the general case and the one UE27 proves. The open item UE27 leaves is narrower: "the formation's own record as the internal part". Also, "the formation itself, not a model of it" names only the relatum's level. In `levelParts g` its activity, requirements and needs, which make it a formation, are external. `Roles` ties level to activity only for embodied relata. On the glossary: the landing text removes "keeps" from 03 §1, which settles that sentence's clash with *keeping* (守). The design's question still uses "keeps", and 03 §1's "Anything that keeps, rewards, …" keeps a third sense (outside scope).

**Fix.** Ask: "when is a formation's own level such a fold of what couples into it and its act, so that the level itself is the internal part, with no model beside it?" 03 §1 text: `a formation's support and observed levels are its sensory states, what it folds of them its internal states; its own level is such a part only where its next level and act are read off its level, what couples into it and its act ([§](#r-…))`. Use "the formation's level", not "the formation itself". Note that the word change removes the glossary clash.

### 10. Medium: the standing counts parts that are not results, and the relation to UE18 overstates

**What is wrong.** Part A specializes `couplingLaw` (a wrapper, by RESULT-WORKFLOW not another result). B's necessity is `cons.1` followed by `Prod.fst`. The exchange form is balance rearranged. The witness is of `ReadsExternal`'s kind. "Near-definitional, in three parts" counts three. The relation to UE18 says "even the blanket's interior is lost". What is lost is the level as the internal part in this reading; a model fed by the couplings is still an internal part. And `ThresholdDrain` with the supply as the formation's own level is the self-coupled case the reading excludes (Finding 6). So the comparison points at a case the result does not cover.

**Fix.** Standing: "one near-definitional result: the World reading's iff (Finding 3), with the exchange form; witnesses: `PhasedDrain`, which fails the agent's half, and `SteadyFeed`, fed by what does not couple in yet consistent. The delta is that the line falls at determination by the formation's level, value and act, not at the coupling of what drains or feeds it." UE18 sentence: "Here what is not read off the formation's level, value and act moves the level, and then the level is not the internal part in this reading, while a model fed by the same couplings still is."

### 11. Medium: the record, page and chapter texts narrow by less than the result does

**What is wrong.** "The principle's page: §5's item goes". The result covers only the level, only along one run or under the world's clause, without self-coupling or embodiment. So the item should narrow, not go. That also matches the record plan ("`does_not_show` … narrowed"). "08 §8: one sentence, if the classification it states changes" defers a decision the design can make now.

**Fix.** §5: "a World formation's own records other than its level as the internal part; the level across families of runs without the world's clause; self-bearing formations". The blanket record's `does_not_show` adds the world's clause and the self-coupled case. On 08 §8, say now whether it changes. On this review's reading it does not: the result is a World instance of UE27's third level, a sparse partition fixed apart from the family.

### 12. Low: names

`HiddenDrain`: "hidden" is epistemic, and the drain is in the World's records, only not read through `g`'s couplings. Use `PhasedDrain`. `LevelInterior` and "the interior of no blanket": the parts are called internal (`Parts.internal`), and "interior" invites the glossary's region sense of boundary. Use `Becoming.LevelInternal`, or a name stating the reading (`Becoming.LevelReading`), and "internal part" throughout. `OwnMovesThrough`: use `LevelMovesThrough` beside `ActMovesThrough`, since "through" elsewhere means through couplings (`SelectsThrough`, `ValuesThrough`). Fix at the claim.

### 13. Low: wording

"Whatever model of it is one" does not parse; drop it (Finding 4). "The family of a world's courses": a World is one run, so write "one world's run, or a family of runs over one relatum type".

### 14. Low: `pair_eq` resolves to the Nat-only `Becoming.pair_eq` inside `namespace Becoming`

In the probe, `pair_eq` under `open BlanketCouplings` resolved to `Becoming.pair_eq {a b c d : Nat}` (`Weighted`), not `BlanketCouplings.pair_eq`. The new module, inside `namespace Becoming`, should write `BlanketCouplings.pair_eq`, or match pairs directly. Also use the prelude's `Naturals.succ_ne_zero`, `Naturals.add_left_cancel` and `Naturals.add_right_cancel`. In the probe's first audit, four declarations using the core cancellation lemmas and `Nat.succ_ne_zero` reported `propext` until these replaced them (the prelude says the same of `Nat.succ_ne_zero`).

### 15. Low: the probe's copy of UE27's module

`review-probes/tree/Becoming/BlanketCouplings.lean` copies UE27's not-yet-landed module unchanged, for the build only. Do not commit it with the review, or the views will count a second copy. Remove it, or let it go once UE27 lands. `.build/` is ignored.

## The probe

`review-probes/tree/Becoming/UE28ReviewProbe.lean`, built with `scratch_build.py` on this worktree (93 modules reused, `BlanketCouplings` from UE27's tree), every axiom report empty:

| Part | Declarations | Shows |
|---|---|---|
| A | `sameStepLaw`, `sameStep_sensory`, `LagWitness.lag` | `couplingLaw`'s internal course lags the same-step history (2 against 1 at step 2); a same-step law gives it (Finding 2) |
| B | `next_alike_iff_net_alike` | the exchange form, pairwise, an exact `↔` under balance (Finding 8) |
| C | `SteadyFeed.balances`, `h_uncoupled`, `fed_blanketed`, `fed_consistent` | fed by what does not couple in, and the internal part of a blanketed law (Finding 4) |
| D | `ActUnread.balances`, `level_moves_through`, `not_consistent` | the level moves through and the act does not: not consistent (Finding 3) |
| E | `DrainOnly.phase_three`, `drained`, `no_balanced_history` | the design's drain has no level history balanced at every step (Finding 7) |
| F | `PhasedDrain.balances`, `not_consistent`, `world_consistent` | a balanced periodic drain: the agent's half fails, the world's holds (Finding 7) |
| G | `SpentDrain.balances`, `moves`, `agent_consistent`, `world_not_consistent` | the agent's half holds, the world's fails (Finding 3) |
