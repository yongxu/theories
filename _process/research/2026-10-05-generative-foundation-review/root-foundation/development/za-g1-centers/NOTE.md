# ZA-G1: the standpoints and the relation read off a flow (route (b), first piece)

AI-written (Claude Code desktop session za-g1-centers, Opus), 9 November 2026. Board row ZA-G1. One of four pieces of route (b) of the zero-axiom target, run in parallel on Ren's "ok - 这一类请平行化认真完成，非常重要" ([his words, 9 November 2026](../../../../../../../sources/15-codex-theory-conversations/2026-11-09-route-b-ethics-forms.md)); the other pieces are G3 (ZA's row: the joining lemma and self-concern from persistence), G2 (ZC's row: a center's own class) and Bound (ZB's row). The session that started them joins the landed pieces. The readings that set out the gap, and a check of every Lean claim in them, are in `/Users/ren/tmp/za-how-far/` (local, not in the repository); the gap is quoted below.

## 1. The gap

Read as lying within a center's own closure (`selfAscribed (ownClosure rel) center`), significance makes the continuation condition exactly that every center's closure is the whole (`ownClosure_unrestricted_iff`), and on the root exactly `«续无外» rel «一» center` (`ownClosure_unrestricted_iff_noOutside`). The input moves from value to connectivity, but the relation `rel`, the class and which formations are centers stay supplied; 07 §1's table calls the identification "a reading". This piece takes the relation and the centers. The class is G2's.

## 2. What was done

```text
Result(s): standpoints-read-off-a-flow, covering-by-the-returning-formations (new); reuses
  where-a-formations-acts-return (Flow.ReachReturns, Flow.exists_reachReturns, ReachReturns.represented),
  what-the-step-across-standpoints-reaches (ownClosure_unrestricted_iff, unrestricted_atCenters_iff),
  continuation-condition-decomposition (unrestricted_of_standpointInvariant),
  mutual-dependence-and-its-pace (mutuallyDependent_iff_reach, Drawing),
  the-continuation-condition-on-the-root (ownClosure_unrestricted_iff_noOutside), the Clearing witness.
Delta: the relation read as one of a flow's (affecting, being affected, feeding) and the standpoints read off
  the flow (every formation, or the formations whose acts return); the own-closure laws restated with both read
  off: along affecting the condition is mutual dependence under either reading (the new direction: at the
  returning formations it gives mutual dependence); covering by the returning formations on finite flows, so the
  step across standpoints along being affected gives the condition with covering no longer supplied; along being
  affected, at the returning formations, the condition is that they lie in one loop, weaker than mutual
  dependence; witnesses where the returning formations and a supplied center part (Clearing), where the relation
  matters (Drawing), and where self-bearing standpoints are none (Unexchanged).
Supplied premises / correspondence: which flow relation; which formations are the standpoints (a reading); the
  class (the one, as the own-closure reading takes it); significance read as own closure; finitely many formations
  and decided reach for covering.
Evidence: Becoming.FlowCenters, 32 theorems, no axioms (scratch build 9 November 2026; the core run's receipt at
  landing).
Boundary: Clearing.returning_apart, Clearing.clearer_beyond_returning_feeding, Drawing.returning_feeding_apart,
  Unexchanged.apart.
Integration: 07 §4.8 (new); the board row; INTERFACES for the joining.
```

## 3. Choosing the standpoints

Candidates named in the brief: `Web.SelfBearing` with `Flow.ReachReturns`; a line constant to the net's end; and, from the readings, every formation that takes part (Fable's covering from activity). 03 already reads every formation, returning or not, as a center (03's line under `r-where-a-formations-acts-return`), so that reading is kept, and the returning formations are a second, narrower reading, not a renaming of "center".

What each gives, with the laws restated at it:

| standpoints | condition along affecting | along being affected | covering | exists |
|---|---|---|---|---|
| every formation (03) | mutual dependence (G3's `Flow.mutuallyDependent_iff_unrestricted`) | mutual dependence | by reflexivity | always |
| formations whose acts return | mutual dependence, given one (`Flow.mutuallyDependent_of_returning_unrestricted` and the generic iff) | they lie in one loop (finite; `Flow.returning_influence_unrestricted_iff`) | along being affected, finite (`Flow.covered_by_returning`) | finite (`Flow.exists_reachReturns`) |
| returning and bearing on themselves | as above, given one | as above, given one | fails: none in `Unexchanged` | fails (`Unexchanged.apart`) |
| lines continuing to the net's end | needs the class (G2) | | | |

The returning formations are chosen as the second reading because the laws hold at them as statements about the flow (the condition along affecting is mutual dependence, as with every formation; covering and existence are theorems on finite flows, not obtained by making everything a standpoint), and because at them what a formation acts on lies within what it can represent (`ReachReturns.represented`), which is where route (b)'s "should" has no gap for its own act (07 §3.3). `Web.SelfBearing` narrows them and adds no law, and loses existence and covering. The line candidate needs the class. The choice is a reading; the flow does not make it.

What the returning reading costs, said plainly: a formation that acts on nothing returns vacuously (the dweller in `Clearing`; every formation in `Unexchanged`), and on an acyclic flow the returning formations are exactly those that reach nothing beyond themselves.

## 4. Failed candidates and witnesses, kept

- **Covering from activity along feeding** (Fable's `Flow.covering_of_acting`, proposed as "every formation that gives or takes lies within some active formation's feeding closure"). Read with every acting formation a standpoint it holds by reflexivity and says nothing (`Flow.covering_of_acting`, near-definitional). Read with the returning formations as standpoints, along feeding it fails: in `Clearing` the clearer takes part and lies within no returning formation's feeding closure (`Clearing.clearer_beyond_returning_feeding`). Covering holds along being affected (`Flow.covered_by_returning`).
- **Self-bearing standpoints.** `Unexchanged`: every formation returns, none bears on itself.
- **The relation.** `Drawing`: every formation returns; the condition holds along affecting and being affected, not along feeding.
- **The center.** `Clearing`: only the dweller returns; along being affected the condition holds at it and fails with the clearer as the one center supplied, and the verdict on the clearer's part changes with the center (`Clearing.returning_apart`, `Clearing.returning_loses_dweller`). G3's `Clearing.not_unrestricted_ownClosure` (with every formation a center, neither de se reading is the condition) is the other reading's half: the two readings of the standpoints part on `Clearing` along being affected.

## 5. What route (b)'s three supplied inputs are now

- **The relation:** read off the flow as one of its three relations; which one is still a choice, and the verdicts differ with it.
- **The centers:** read off the flow, as every formation or as the formations whose acts return; along affecting the condition does not depend on which (mutual dependence), along being affected it does. Which reading is a choice.
- **The class:** not touched; the own-closure reading takes the one of the relation. G2's piece.

And still supplied beyond these: that significance is own closure at all (07 §1).

## 6. Not re-proved

`Flow.unrestricted_of_mutuallyDependent` and `Flow.mutuallyDependent_iff_unrestricted` are G3's (branch `claude/unruffled-dirac-983955`). This piece states the direction they do not (at the returning formations, the condition gives mutual dependence) and the feeding counterpart of the second (`Flow.mutuallyFed_iff_unrestricted`). The iff at the returning formations is one line for the joining (in the shared notes).

## 7. Readers

(Below, once read.)
