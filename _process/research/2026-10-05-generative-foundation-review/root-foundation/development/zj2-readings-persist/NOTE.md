# J2: which readings persist (route (b)'s formation piece)

AI-written (Claude Opus 5.5, a side session of the zero-axiom reading), 9 November 2026. Board row J2. Module [`Becoming.ReadingsPersist`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadingsPersist.lean), a core leaf; home [07 §4.12](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#readings-persist).

Ren's words this piece answers: route (b), 9 November 2026, "ok - 这一类请平行化认真完成，非常重要" ([sources](../../../../../../sources/15-codex-theory-conversations/2026-11-09-route-b-ethics-forms.md)); and 8 November ([sources](../../../../../../sources/15-codex-theory-conversations/2026-11-08-within-becoming-no-should.md)): life that does not "want" to create more future "simply 'cease to exist' … there is no 'permeant self'" (message 1); right and wrong are "'cognitive structures/dynamics' … higher order in dynamics/patterns … which leads to cascading changes", and "it doesn't need to be ranking/comparison" (message 2). The join's checks (the session that started this one, 9 November) turned route (b)'s next question from which order forms to which readings, or scopes, persist.

```text
Result(s): readings-carried-on-their-course, which-readings-persist, a-selection-removing-its-readers (new)
Delta: a self as a line of relata that come to stand, each carrying an inherited reading and acting by the act it
  gives, on the course the acts generate; standpoints in time as the lines alive; the pool read off the course.
  Persistence selects no reading beyond the line's coupling closure (law; a model meets every premise); which
  readings persist where nothing comes back and where the dweller renews the source (witnesses both ways); a
  selection removing its own readers stated, with the condition under which a reader is kept.
Supplied premises / correspondence: the act each reading gives; that it reads only what couples in (the witness
  proves it of its acts; ActReadsWithin stays a premise of the significance form); the founders and the listing;
  inheritance along descent (proved in the witness, a premise of the law).
Evidence: Becoming.ReadingsPersist, 80 theorems, 128 declarations, every axiom report empty (scratch build
  9 November 2026; core run at landing).
Boundary: readings are carried and filtered, never varied; selection is persistence, all or nothing, not a share;
  no reading in time; the witness is one small world with three readings.
Integration: BeyondCoupling's act_courses_unselected_throughout (formal reuse, persistence as the selection);
  PersistingChoices' persists_never_overdraws and persisting_keeping_above_ending (formal reuse, descent and
  realization by construction); Counterfactual's generated course (levels_succ, totals_under).
```

## What was done

1. **The model** (`readings-carried-on-their-course`). Each relatum carries a reading and exchanges as the act that reading gives (`ExchangeLaw.byReading`); where a part carries `sig`, this is Bound's `law.withAct part (act sig)` by construction (`byReading_withAct`). A balanced flow that follows a law of what has stood has the levels the law generates, and the course is feasible (`levels_of_follows`, `feasible_of_follows`): the uniqueness law `ExchangeLaw.course_unique` takes feasibility as a premise, and balance gives it. The line read off a flow (`Flow.lineOf`, kids = the listed relata that descend from a member across the step) is G3's `Descended` by construction, and with inheritance carries the founders' reading (`lineOf_carries`). G3's `realized` holds by construction where every occasion picks the carried reading (`Flow.carried_keeping_above_ending`). Standpoints in time: `Flow.LineAlive`, `Flow.LineReachesBefore` (ReachesBefore lifted to lines, membership dated), its lift to `ReachesBefore` and to `Affects`.
2. **Which readings persist** (`which-readings-persist`). `line_standing_unselected`: Bound's `act_courses_unselected_throughout` with standing late as the selection (`Web.standsLate_readOffCouplings`, own standing coupled in). The witness `ReadingsPersist.Habitat`: six relata (a line's two slots, its source, a habitat, a dweller's line's two slots), three readings (own line; line and source; everything), two worlds (the source renewing itself; the dweller's line renewing the source). Five courses, each given by closed-form levels, proved balanced step by step, and shown to be the course the acts generate by `levels_of_follows` (`Habitat.generated`). The lines are read off each course and their persistence or ending is computed (`beyond_which_persist`, `back_which_persist`). `Habitat.beyond_standing_unselected` instantiates the law with every premise discharged in the model: the acts read what has stood and only what couples in (`act_nonanticipating`, `act_readsThroughOwn`), both courses feasible (`feasible_of_follows`), the habitat beyond the line's coupling closure (`region_closed`, `closure_in_region`).
3. **The meta-attractor stated** (`a-selection-removing-its-readers`). With the pool read off the course (`AliveIn`): `SurvivorsPersist` (selection by persistence read off it), `AllPersist` (a fixed pool), `RemovesLine`, `RemovesItsReaders`. Read off the course's pool, removal does not turn it (`survivorsPersist_of_settled`); read off a fixed pool, every removal does (`not_allPersist_of_removes`). Survival condition: a reader within a group's coupling closure on which the two acts agree is kept alike (`reader_kept_alike`). Witnesses: `cleared_removes_its_readers`, `clearedBack_removes_both`, the dated reach both ways (`cleared_reaches_dweller`, `cleared_dweller_reaches_nothing`, `clearedBack_dweller_reaches_line`).

Every law is near-definitional; the witnesses are finite computations. No ethical premise, no ranking, no axiom.

## Which readings persist, in plain words

- Where nothing comes back from the dweller, the line that reads only itself draws more than is renewed and ends. The line that reads itself and its source clears the dweller's habitat and persists; the dweller's line ends. The line that reads everything spares the habitat and persists, and so does the dweller's line. Persistence tells the first from the other two, since the overdraw is within what returns to the line. It cannot tell the second from the third, as a law: the difference lies beyond the line's coupling closure.
- Where the dweller's line renews the line's source, clearing the habitat ends the dweller's line, the source is no longer renewed, and the line ends after one more step. The line reading everything persists with the dweller's line.
- So **persistence selects acts on what returns to the line, not scope**. The critic of the join readings expected narrow readings' carriers to persist where acts do not return; that holds, as a law with a witness. Where the loss returns, the reading that keeps it persists because its act keeps what returns, not because it is wider. A narrow reading whose act agreed on everything coupled into the line's closure would persist as well, by the same law.
- **Persistence does not select scope beyond coupling.** Ethics as reading beyond what returns does not form by persistence alone. It is carried where carrying it changes nothing that returns, and is unselected there.

## The meta-attractor, now stateable

Bound's pool was fixed across courses, so the pool kept the dweller even in the course that ended it. With the pool read off the course, a selection read off its own pool can remove its readers. In the witness, selection by persistence read off the course's pool holds at the course clearing the habitat, which removes the dweller's line, whose continuation reads the habitat. Read off the fixed pool of both lines, the same selection fails there. In general, read off the course's pool, removal never turns it. Read off a fixed pool, every removal does.

The conditions under which a reading beyond the selector's share survives:
- **The reader is out of the alternatives' reach.** Where the selection chooses between acts that agree on everything coupled into the reader's coupling closure, the reader stands at every step alike in both courses (`reader_kept_alike`). This is GOALS' "readers not drawn from the selected", put in coupling terms.
- **The removal returns to the selectors.** Where the dweller renews the source, the course removing the dweller's line removes the line too; only the course that keeps it persists. This is shown in the witness, not proved as a law.

## What this changes in the account (under Ren's view of 8–9 November)

- **What forms.** Readings are carried along descent and filtered by persistence. Nothing here forms a reading wider than what returns to its carriers, and nothing ranks the readings that persist: what persists is a set, not an order ("it doesn't need to be ranking/comparison").
- **What persists.** Readings whose acts keep what returns to their line. Beyond that, a reading counting the dweller and one leaving it out persist alike. A reading that does not keep what returns ceases with its line (Ren's "cease to exist", read on the model).
- **Where it stops.** At the line's coupling closure (Bound). The cascade a narrow reading brings beyond, the dweller's line ending, is not registered by the narrow line's own persistence. The selection read off the survivors seals it.
- **For alignment.** GOALS' first condition on the flow: keep the readers coupled into the selection, or out of its reach. Survivorship read off its own pool does not keep them.

## Failed candidates and corrections (kept)

- **"ActReadsWithin holds by construction"** (the brief, after the join's critic): it does not. Inheritance makes the part's act `act sig` (Bound's index), and that is all it gives. `ActReadsWithin` is a property of how the act reads its index; carrying the index changes nothing in it. It stays a premise of `line_standing_unselected_of_reads`. Moving it into the model's definition would not discharge it (08 §12). The law used in the witness is stated with the two acts' agreement on what couples in, which the witness proves of its acts.
- **"G3's `realized` holds because the acts generate the course"**: only where every occasion picks the reading the line carries and the world is the course that reading generates (as the join's Fable check said). With occasions picking different readings, a run made of the picks would be needed; it is not built.
- **The standpoints as lines alive along `ReachesBefore`**: `ReachesBefore` takes a time-blind part. Lifted to lines, membership is dated, which makes the lifted relation stronger (`LineReachesBefore.reachesBefore` goes one way only).
- **Line persistence as a selection on levels**: G3's `Persists` is of cohorts read off the flow, which depend on who gives to whom, not on levels alone. The law is stated for standing late among the line's slots, which a persisting line implies (`lineOf_standsLate`). The converse is not claimed.

## Limits (what is not modelled)

How a reading arises or changes: readings are never varied or learned here. The act each reading gives is supplied. Several lines competing for a share: RuleShaping's counts are not connected. A reading in time, before a loss passes its point of no return (GOALS' second condition; J3's time). The founders and the listing of relata are supplied.

## Checks

Scratch build (`scratch_build.py`, the checker's own steps), 9 November 2026: 128 declarations, 80 theorems, every axiom report empty, no warning. Core run, the reader's rounds and the gate: see the end of this note as they are done.
