Kept as written; local paths in it point to the session's scratch folder.

AI-written, 12 November 2026

# Completeness critic of the TT maps

Read only (Claude Opus 5.5). I built nothing and ran no checker. Everything here comes from grep and
from reading the ten maps in this folder, the plan (`tmp/r7/the-loop/PLAN.md`), the held
`TurningInTime.lean` and `readers/lean-reader-1.md`, plus the PKG lines quoted below.
PKG = `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.

## 1. Modules no map read that bear on the pattern

I grepped PKG for 同行, 有常, «核», 至终有常, 因于核, 足以定核, 相须, GoAlike, IdentifiesAlike,
DependsOnlyOn, Locked, Unread, Short, step_below, Lasts, orbit_bound, windowRead and Stands. That
gives 62 modules. Of those, 23 are not named anywhere in the maps. The ones that matter:

- **OwnClass.lean (836 lines; imports GrammarPath). High.** The root's laws on `«本类至终有常»`
  (constancy up to the net's end at a member's class, which the design seed uses) come together here:
  - `«本类常闭当且仅当类闭»` (116): P2 and P4 at a member that conditions something hold exactly
    where its block `E m` is closed under R (`«闭»`). It needs `decided : ∀ u, E m u → (∃ w, R u w) ∨ ∀ w, ¬ R u w`.
  - `«后类»` (170): the downstream class.
  - `«后类本类常闭»` (213), `«后类最细»` (257), `«静之本类至终有常»` (322) and `«静不闭»` (332).

  This is the root's own tie between "a region closed under the net" and "a class constant up to its
  end". The seed's join, "the lock's `Locked` region as the class as it was", should go through
  it, not through a new bridge. texts.md quotes three of its theorems from 07 (b23) but never names
  the module. No reader read it.
- **FromTheDynamics.lean (115) and RoutesToC.lean (946). Medium.** Both use `«本类至终有常»` on a flow
  (`L.Affects W`, `«后类»`). They are existing cases on a model, and a central law would have to keep
  them as cases. Both sit downstream of GrammarPath, so a change to GrammarPath recompiles them.
- **Attraction.lean (436-460). Medium.** `Invariant.locks_out`, `Run.locked_in`, `Run.stays` and
  `Run.leaving_needs` state lock-in for every law on Frame's `Invariant`. Frame proves
  `invariant_iff_closedUnder`, which is `«闭»`. lock-1 left open "whether `Locked` is a case of a root
  notion of an invariant region". Attraction is where that notion's lock-in laws live.
- **Change.lean (640-915). Medium.** It has three relevant laws:
  - `Steps.course_of_constant` (874): a constant relation along the steps carries its pairs n steps on.
  - `core_iff_same_course` (885): the core of `Steps.alike p` is "agrees at every pair equally far
    after".
  - `continues_in_core_iff_buqiong` (899): to continue under the core is to never end under the
    class, the flame's case.

  These are "the core tells what the class does not" read on the time line. They partly correct
  root-laws (5) (see section 2).
- **Regulation.lean (1185-1260). Low.** `Flow.RelaysLate` and a level read ℓ steps late. Its
  `step_below` (1206) has the same short name as `RegimeMargin.Adjusted.step_below`. That is a
  collision a reader can trip on. The lemma is a different law: a relay that adds M, not a fall.
  Reading late is near (d) in its words, but this is regulation (overshoot), not turning.
- **Not bearing on the pattern** (only hit on a common name):
  - ProcessRepresentation (GoAlike carried across renamings) and Description (GoAlike, IdentifiesAlike).
  - BlanketCouplings (DependsOnlyOn on blankets) and CommonResponse (`«同行»` of a response
    relation; an instance of `«像定后当且仅当同行»`, not a new law).
  - SharedCodes, ProjectedLaws, MoveFormation, LawAlongRun, Joining and Commuting.
  - the five Hexagram* modules, UnreadStandings (an arithmetic namespace) and ReadStages (two-stage
    compliance; `Unread` in another sense).

  None needs a reader for TT.

Modules the maps name but only by citation, with no reader: Optimum (rebuilt-and-time read the header,
545-650 and the statements in 2228-2410), Amounts (stock read 480-540) and ReadingSchedule (skimmed).
Section 3 says which questions about them stay open.

## 2. Claims that contradict each other

**C1. Whether a changing-draw law, and `goes_on_iff`, are new.**
- stock.md 4 (5): "The held attempt's `Turning.goes_on_iff` (TurningInTime 609) is the only statement
  found of a level that turns from the higher draw to the lower in time; it is new." stock.md 2 (2)
  also calls `Course.falls` and `Course.gone` "New in content".
- rebuilt-and-time.md 8: "`goes_on_iff` / `never_ends_iff` ... is Optimum 2369 `reread_kept_iff` ...
  the same law in a level-only form already exists". It adds that "Optimum already has varying-draw
  laws (`never_rises` 2246, `level_stays_below` 2255, `ends_within` 2289)".
- Stock's claim is scoped to RegimeMargin, DrawHistory, RunTurns and BandRest. It notes `ends_within`
  in 1.9 but still says "new". Optimum is imported by RegimeMargin and proves `ends_within` through
  `Amounts.falls_by_stretch` (Optimum 2310). So a general changing-draw law has a home below
  RegimeMargin that stock did not weigh.

**C2. Which root law already names the gap "goes alike but is not constant".**
- root-core.md 0: "The attempt's gap 'a class goes alike but is not constant' is named in my files as
  constancy up to the net's end, `«至终有常»` (GrammarPath.lean:222)".
- root-laws.md (1): "`«局定后则有常当且仅当同行可续»` (2612) ... This is (b) said already". Then (4):
  "`«同行»` itself already is going alike up to the end ... restating one would duplicate `«同行»`".
- These name two different root predicates for one gap, and no theorem in PKG relates them. A grep
  for 同行 in GrammarPath, OwnClass, RoutesToC, FromTheDynamics and GrammarCases finds nothing.
  Read by hand (not checked in Lean):
  - `«至终有常»` with the successor fixed at u' gives `«同行»`, constructively.
  - `«同行»` gives `«至终有常»` only where it is decided whether u' has a next. That is the same
    `decided` premise OwnClass needs.

  The design must choose which predicate is the root's statement of the centre's first half, and
  prove or name this tie.

**C3. Constancy carried n steps.**
- root-laws.md (5): "No law here says the core (or any constant relation) keeps n steps ... I searched
  the whole package folder ... no match".
- `Change.Steps.course_of_constant` (Change.lean 874) does say it, for `Steps.next` on `Nat`. No map
  read that file. The general form is still unstated, so the held `core_steps` stays new in general.
  But the claim "nowhere" is wrong.

**C4. What recompiles when RegimeMargin changes.**
- stock.md 2 (2) lists the periphery `lean/regime/RegimeReals.lean` (Mathlib) among the modules that
  recompile. It exists, and it imports `Becoming.RegimeMargin`.
- landing.md lists only RunTurns, DrawHistory, ReadOffInTime, RoomRuns and the root ("five
  dependents"). It does not say whether the periphery check (`regime/check_regime_reals.py`) runs in
  the train.

No other contradiction found. The maps agree on `left_lt` against `step_below`, on `Locked` not being
stated as `«有常»`, and on PoolFromCourse having no importer.

## 3. Questions the design needs that no map settles

1. **Where a root tie lands, and what it costs.** Import closures, computed from the import lines:
   - GrammarPath: 6 modules (GrammarCases, OwnClass, RoutesToC, PremiseWitnesses, FromTheDynamics,
     PremisesTogether).
   - GrammarLaws: 380 of 401.
   - RegimeMargin: 4.
   - Optimum: 12.
   - ClosedCapture: 23.

   A tie between `«同行»` and `«至终有常»` can sit in GrammarPath, which reaches GrammarLaws through
   GrammarCrossing. That is cheap. In GrammarLaws it would rebuild nearly everything. landing.md maps
   only a new leaf and a RegimeMargin edit. It does not cover a GrammarPath or OwnClass edit: which
   records cite those files, and what drifts.
2. **Whether `Locked` is proved to be a closed region in the root's sense.** It is closed by
   `stays_turned` and `turn_locked`. No map found a theorem stating it as `«闭»`, `Invariant` or
   `«本类至终有常»` at a locked member. Is that only said in a docstring (02-MAP 439, the K1 "lock =
   region closed under revision")?
3. **Which premise form a changing-draw law takes.** The candidates are `Short g H y` with `H ≤ Hs t`
   (RegimeMargin) and `g t ≤ r < d t` (Optimum). rebuilt-and-time leaves this open. Stock's warning
   about `StaysShort A g (Hs t)` says which form is false in use.
4. **The decidability premise.** The tie in C2 and OwnClass's iff need "has a next or none" to be
   decided. On the seed's guarded relation (a next only where the level meets the need) it is
   decidable on Nat. No map says whether the design's relation supplies it, or whether OwnClass's
   `decided` is met by the lock's total `paced` step (where it holds trivially: every occurrence has a
   next).
5. **Where a schedule run splits.** Stock found no lemma splitting `DrawHistory.underDraws` at a step
   T, and recovery after a lowered draw needs one. No map says whether Optimum's `reread_kept_iff`
   proof contains it.

## 4. Follow-ups

See the six tasks returned to the workflow:
- **ownclass-lock:** OwnClass and the lock's region.
- **tie-tongxing:** the tie between 同行 and 至终有常.
- **draw-premise:** the changing-draw premise in Optimum against RegimeMargin.
- **invariant-lock:** Attraction and Frame invariants against `Locked`.
- **change-core:** Change's core on the time line.
- **root-landing:** the landing cost of a GrammarPath or OwnClass edit.
