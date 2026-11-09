# J2: which readings persist (route (b)'s formation piece)

AI-written (Claude Opus 5.5, a side session of the zero-axiom reading), 9 November 2026. Board row J2. Module [`Becoming.ReadingsPersist`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadingsPersist.lean), a core leaf; home [07 §4.12](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#readings-persist).

Ren's words this piece answers: route (b), 9 November 2026, "ok - 这一类请平行化认真完成，非常重要" ([sources](../../../../../../sources/15-codex-theory-conversations/2026-11-09-route-b-ethics-forms.md)); and 8 November ([sources](../../../../../../sources/15-codex-theory-conversations/2026-11-08-within-becoming-no-should.md)): life that does not "want" to create more future "simply 'cease to exist' … there is no 'permeant self'" (message 1); right and wrong are "'cognitive structures/dynamics' … higher order in dynamics/patterns … which leads to cascading changes", and "it doesn't need to be ranking/comparison" (message 2). The join's checks (the session that started this one, 9 November) turned route (b)'s next question from which order forms to which readings, or scopes, persist.

```text
Result(s): readings-carried-on-their-course, which-readings-persist, a-selection-removing-its-readers (new)
Delta: a self as a line of relata that come to stand, each carrying an inherited reading and acting by the act it
  gives, on the course the acts generate; standpoints in time as the lines alive; the pool read off the course.
  Standing late selects no reading beyond the line's coupling closure (law; a model meets every premise;
  persistence implies standing late, one way); which readings persist where nothing comes back and where the
  dweller renews the source (witnesses both ways); a selection removing its own readers stated (the
  meta-attractor's shape), selection by persistence read off its own pool shown to register no removal, and
  the condition under which a reader is kept or removed alike.
Supplied premises / correspondence: the act each reading gives; that it reads only what couples in (the witness
  proves it of its acts; ActReadsWithin stays a premise of the significance form); the founders and the listing;
  inheritance along descent (proved in the witness, a premise of the law).
Evidence: Becoming.ReadingsPersist, 83 theorems, 131 declarations, every axiom report empty (scratch build
  9 November 2026; core run at landing).
Boundary: readings are carried and filtered, never varied; selection is persistence, all or nothing, not a share;
  no reading in time; the witness is one small world, finitely many relata, three readings whose acts are
  assigned by design; which lines count as readers is supplied.
Integration: BeyondCoupling's act_courses_unselected_throughout (formal reuse, persistence as the selection);
  PersistingChoices' persists_never_overdraws and persisting_keeping_above_ending (formal reuse, descent and
  realization by construction); Counterfactual's generated course (levels_succ, totals_under).
```

## What was done

1. **The model** (`readings-carried-on-their-course`). Each relatum carries a reading and exchanges as the act that reading gives (`ExchangeLaw.byReading`); where a part carries `sig`, this is Bound's `law.withAct part (act sig)` by construction (`byReading_withAct`). A balanced flow that follows a law of what has stood has the levels the law generates, and the course is feasible (`levels_of_follows`, `feasible_of_follows`): the uniqueness law `ExchangeLaw.course_unique` takes feasibility as a premise, and balance gives it. The line read off a flow (`Flow.lineOf`, kids = the listed relata that descend from a member across the step) is G3's `Descended` by construction, and with inheritance carries the founders' reading (`lineOf_carries`). G3's `realized` holds by construction where every occasion picks the carried reading (`Flow.carried_keeping_above_ending`). Standpoints in time: `Flow.LineAlive`, `Flow.LineReachesBefore` (ReachesBefore lifted to lines, membership dated), its lift to `ReachesBefore` and to `Affects`.
2. **Which readings persist** (`which-readings-persist`). `line_standing_unselected`: Bound's `act_courses_unselected_throughout` with standing late as the selection (`Web.standsLate_readOffCouplings`, own standing coupled in). Its premises: the rest reading through coupling, the first act reading each slot's couplings only, the two acts agreeing under every level history on what couples into the closure, both courses feasible. A persisting line stands late (`Flow.lineOf_standsLate`); the converse is not claimed, since a slot can come to stand again fed from outside the line. The witness `ReadingsPersist.Habitat`: six relata (a line's two slots, its source, a habitat, a dweller's line's two slots), three readings (own line; line and source; everything), two worlds (the source renewing itself; the dweller's line renewing the source). Five courses, each given by closed-form levels, proved balanced step by step, and shown to be the course the acts generate by `levels_of_follows` (`Habitat.generated`). The lines are read off each course and their persistence or ending is computed (`beyond_which_persist`, `back_which_persist`). `Habitat.beyond_standing_unselected` instantiates the law with every premise discharged in the model: the acts read what has stood and only what couples in (`act_nonanticipating`, `act_readsThroughOwn`), both courses feasible (`feasible_of_follows`), the habitat beyond the line's coupling closure (`region_closed`, `closure_in_region`).
3. **A selection removing its own readers, stateable** (`a-selection-removing-its-readers`; the meta-attractor's shape, not the meta-attractor). With the pool read off the course (`AliveIn`, a line alive where a slot stands): `SurvivorsPersist` (selection by persistence read off it), `AllPersist` (a fixed pool), `RemovesLine`, `RemovesItsReaders` (which lines read is supplied). Read off the course's pool, selection by persistence passes every course whose lines settle (`survivorsPersist_of_settled`), the course removing every line included (`clearedBack_survivors_pass`); read off a fixed pool, every removal turns it (`not_allPersist_of_removes`). Under Bound's premises, a reader within a group's coupling closure on which the two acts agree stands alike at every step in both courses (`reader_kept_alike`): neither removes it while the other keeps it. Witnesses: `cleared_removes_its_readers`, `clearedBack_removes_both`, `clearedBack_survivors_pass`, the dated reach both ways (`cleared_reaches_dweller`, `cleared_dweller_reaches_nothing`, `clearedBack_dweller_reaches_line`).

Every law is near-definitional; the witness has finitely many relata, its courses' balance and the lines' fates proved for all steps. No ethical premise, no ranking, no axiom.

## Which readings persist, in plain words

- Where nothing comes back from the dweller, the line that reads only itself draws two from its source once, is then no longer fed, and ends (both lines gone from the third step; the source then rises). The line that reads itself and its source clears the dweller's habitat at the first step and persists; the dweller's line is gone from the third step. The line that reads everything spares the habitat and persists, and so does the dweller's line. Standing late tells the first from the other two, since the overdraw is within what returns to the line; it cannot tell the second from the third, as a law, since their acts agree on everything coupled into the line's closure. That both of those lines persist is computed.
- Where the dweller's line renews the line's source, clearing the habitat ends the dweller's line (gone from the third step), the source then stays at one, and the line is gone from the fourth step. The line reading everything persists with the dweller's line.
- So, as a reading: **persistence selects acts on what returns to the line, not scope**. The critic of the join readings expected narrow readings' carriers to persist where acts do not return; that holds, as a law for standing late and with a witness for persistence. In the second world, where the loss returns, the reading that keeps it persists because its act keeps what returns, not because it is wider; a narrow reading whose act agreed on everything coupled into the line's closure would stand late as well, by the law. The readings' acts are assigned by design: no scope predicate fixes them.
- **Standing late does not select scope beyond coupling.** The witness refutes a guarantee that the wider reading survives where the narrower does not. This model gives no mechanism by which a reading wider than what returns forms; such a reading is carried where carrying it changes nothing that returns, and is unselected there.

## A selection removing its own readers, now stateable (the meta-attractor's shape)

Bound's pool was fixed across courses, so the pool kept the dweller even in the course that ended it. With the pool read off the course, a selection read off its own pool can remove its readers. Which lines count as readers is supplied (in the witness, the dweller's line, read as a reader of the habitat, since its continuation requires it), and nothing ties them to the selection or makes it prefer their removal. In the witness, selection by persistence read off the course's pool holds at the course clearing the habitat, which removes the dweller's line; read off the fixed pool of both lines, the same selection fails there.

astra's reading sharpened this: read off its own pool, selection by persistence registers no removal on any course whose lines settle. It passes every such course (each persisting or gone from some step on), the course removing every line included (`clearedBack_survivors_pass`); classically, with finitely many lines every course settles (argued, not in Lean). So on settled courses it is empty as a selection: survivorship read off the survivors. With infinitely many lines, each living later than the last and none persisting, no common step settles them, and the law does not apply.

What does register a removal, and so when a reading beyond the selector's share is not removed without trace:
- **A pool that does not depend on the course.** Read off a fixed pool, every removal turns the selection (`not_allPersist_of_removes`).
- **The removal returning to the selector's own continuation.** Where the dweller renews the source, the course removing the dweller's line removes the line too; the line's own persistence, read off the line, turns (a witness, one world, not a law). The selection read off the course's pool still passes it.
- **Alternatives agreeing on what couples into the reader's closure.** Then the reader stands alike at every step in both courses (`reader_kept_alike`): neither removes it while the other keeps it. A sufficient condition for alike outcomes; both courses may remove it. Read as [readers drawn from the selected](../../../../../../theories/becoming/results/records/readers-drawn-from-the-selected.md) put in coupling terms.

## What this changes in the account (under Ren's view of 8–9 November)

- **What forms.** Readings are carried along descent and filtered by persistence. Nothing here forms a reading wider than what returns to its carriers, and nothing ranks the readings that persist: what persists is a set, not an order ("it doesn't need to be ranking/comparison").
- **What persists.** Readings whose acts keep what returns to their line. Beyond that, a reading counting the dweller and one leaving it out persist alike. A reading that does not keep what returns ceases with its line (Ren's "cease to exist", read on the model).
- **Where it stops.** At the line's coupling closure (Bound). The cascade a narrow reading brings beyond, the dweller's line ending, is not registered by the narrow line's own persistence, and a selection read off the survivors registers no removal on any settled course.
- **For alignment** (a reading). GOALS' first condition read on the flow: keep the readers in a pool that does not depend on the course selected, or couple their loss back into the selectors' own continuation. Survivorship read off its own pool, on settled courses, keeps nothing.

## Failed candidates and corrections (kept)

- **"ActReadsWithin holds by construction"** (the brief, after the join's critic): it does not. Inheritance makes the part's act `act sig` (Bound's index), and that is all it gives. `ActReadsWithin` is a property of how the act reads its index; carrying the index changes nothing in it. It stays a premise of `line_standing_unselected_of_reads`. Moving it into the model's definition would not discharge it (08 §12). The law used in the witness is stated with the two acts' agreement on what couples in, which the witness proves of its acts.
- **"G3's `realized` holds because the acts generate the course"**: only where every occasion picks the reading the line carries and the world is the course that reading generates (as the join's Fable check said). With occasions picking different readings, a run made of the picks would be needed; it is not built.
- **The standpoints as lines alive along `ReachesBefore`**: `ReachesBefore` takes a time-blind part. Lifted to lines, membership is dated, which makes the lifted relation stronger (`LineReachesBefore.reachesBefore` goes one way only).
- **"Read off the course's pool, removal does not turn selection by persistence; it is turned only where the removal returns to the selectors"** (the first draft of 07 §4.12 and of this note): the second half is false. Where the dweller renews the source, the course removing it removes both lines and still passes that selection (`clearedBack_survivors_pass`, added after astra's reading); what turned was the line's own persistence, read off the line. The selection read off its own pool registers no removal.
- **Line persistence as a selection on levels**: G3's `Persists` is of cohorts read off the flow, which depend on who gives to whom, not on levels alone. The law is stated for standing late among the line's slots, which a persisting line implies (`lineOf_standsLate`). The converse is not claimed.

## Limits (what is not modelled)

How a reading arises or changes: readings are never varied or learned here. The act each reading gives is supplied. Several lines competing for a share: RuleShaping's counts are not connected. A reading in time, before a loss passes its point of no return (GOALS' second condition; J3's time). The founders and the listing of relata are supplied.

## Checks

Scratch build (`scratch_build.py`, the checker's own steps), 9 November 2026: 131 declarations, 83 theorems, every axiom report empty, no warning. Readers: Fable (two rounds) and astra (four rounds), each stopping at its first round with no high or medium finding ([READER.md](READER.md)); every finding taken, the extinction witness `clearedBack_survivors_pass` added from astra's first. Core run and the gate: see the end of this note as they are done.
