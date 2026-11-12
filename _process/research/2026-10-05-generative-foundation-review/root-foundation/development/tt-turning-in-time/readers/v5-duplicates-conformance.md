Kept as written; local paths in it point to the session's scratch folder.

AI-written reading, round 2, 12 November 2026. Reader v5: restatement, placement and conformance. Read only; nothing built or run.

# TT round 2: restatements, placement, conformance

Files read whole as they now stand: `tmp/r7/tt/lean/Becoming/GrammarPath.lean` (diffed against the package copy), `GuardedStep.lean` (177 lines), `TurningInTime.lean` (900 lines). Read with `DESIGN.md`, `DESIGN-R2.md`, the three first-round reports, the round-2 implementers' reports, and the plan's test (`tmp/r7/the-loop/PLAN.md` lines 27-37). Package searched: `experiments/.../lean/becoming/Becoming/`.

## Verdict

No false statement. No high finding. I found no declaration that restates a package law. Every DESIGN-R2 item is done, or changed for a sound reason. There are two medium findings, both about what the GuardedStep text says around its laws:

- the package already has a guarded law (`Viability.guardedStep`), and the text does not name it;
- the text gives a reason for `decided` that the cited law does not prove.

Both can be fixed in docstrings, and one has an optional Lean witness. The low findings are wording, placement, and removable or unjoined pieces.

GrammarPath still differs from the package copy only by additions. The diff's only changed hunk is line 42, and it is an insertion inside that line: the old text resumes unchanged at "In a finite descent with two families…".

## High

None.

## Medium

**M1. GuardedStep.lean 5-16 (header) and the module's name: the package already has a guarded law, and the text does not mention it.**
- **What exists.** `Viability.guardedStep` and `Viability.guardedHistory` (Viability.lean 259, 265; the docstring calls it "A **guarded law**") stop a determined law where a guard fails. Its laws parallel two of GuardedStep's:
  - `Viability.guarded_iff` (Viability.lean 299): the guarded history agrees with the history at every step exactly where the guard holds at every step. This is the function form of `Law.stepWhile_unending_iff`.
  - `Lasting.guarded_upto_iff` and `guarded_none_iff` (Lasting.lean 290, 303): agreement up to `n` exactly where the guard holds up to `n`. This is the function form of `Law.stepWhile_steps_iff`.
- **Not a restatement.** The conventions differ. `guardedStep` is a function on `Option S` driven by disturbances, and it checks the guard at both ends. `stepWhile` is a relation read as 缘 that checks only the start, so a line can reach the occurrence where the net ends. Neither derives the other.
- **What is missing.** The header names only `Map.StepWhere.relation` as an earlier step of this kind. DESIGN.md's "No law has a next only where a condition holds. Guards appear only inside witnesses" is not true of the package.
- **The name.** The module is called `Becoming.GuardedStep`, while `Becoming.Viability.guardedStep` is a different object with a different guard convention. A reader looking for "the guarded step" finds two.
- **Test point 1.** Two guarded-step vocabularies now stand side by side with no sentence relating them.
- **Fix.** One sentence in the header: `Viability.guardedStep` is the function form, with the guard at both ends and disturbances; `Law.stepWhile` is the relational form, guarded at the start only, so a line on it ends at the occurrence that conditions nothing. Name `guarded_iff` and `guarded_upto_iff` as the counterparts of `stepWhile_unending_iff` and `stepWhile_steps_iff`.

**M2. GuardedStep.lean 39-42: the reason given for `decided` is not what the cited law proves.**
- **What the header says.** "That `can` be decided is a premise because reaching an end can need the decision: that every line ending on every branch reaches an end is excluded middle (`«尽则有终当且仅当排中»` …)".
- **What the cited law proves.** It is about `«尽» → «有终»`, not about `stepWhile_toEnd_iff`. Nothing in Lean shows that `stepWhile_toEnd_iff` needs `decided`. DESIGN-R2 B.5 asked for this sentence, so it is done as asked, but as written it is a proof claim resting on the wrong statement.
- **What is true and exact.** Without `decided`, the law at every `S, can, next, E` gives excluded middle. Take:
  - `S = Bool`, `next = id`, `E = «一»`;
  - `can true := True`, `can false := P`.

  Going alike holds trivially under `«一»`. `«至终有常»` at `u = true`, `u' = false`, `v = true` asks `(∃ v', P ∧ v' = false) ∨ ∀ w, ¬ (P ∧ w = false)`, that is `P ∨ ¬ P`.
- **Fix.** Either say that the reason is argued and not checked, or add that witness as a short Lean statement. Then cite `«尽则有终当且仅当排中»` as a neighbour, not as the reason.

## Low

- **L1. GuardedStep.lean 23-27.** "From the whole step's, through the tie": `stepWhile_unending_iff` also goes through the private `unending_of_continues` (115-126), which the header does not name. It is honest at the law's docstring (128-130), which says "through `stepWhile_continues_iff`" but not through the transfer lemma either. Add "and a transfer of `«不穷»` along the steps that continue".
- **L2. GuardedStep.lean 79-96, `stepWhile_steps_iff`.** It has its own induction, and the header says so truthfully (line 29). Its `t = orbit next s n` half overlaps `Recurrence.steps_orbit` (Recurrence.lean 255), the whole step's `n`-step law, which is not cited. Deriving from it would not save the guard induction. Citing it as the whole step's counterpart would join the two.
- **L3. TurningInTime.lean 686, `windowRegroup`.** It is `(ClosedCapture.loopPart q, ClosedCapture.loss q)`: `loopPart` is at ClosedCapture.lean 143, and `loss` at GrammarRegularity.lean 296 (namespace `ClosedCapture`). The package already names both parts, so this adds a definition where a docstring sentence, or a definition through those names, would join them (test points 1 and 5).
- **L4. TurningInTime.lean 362-418 and header 26-36.**
  - The level of the course as it was in `ends_with_net_regime` and `turns_in_time_iff` is the regime under a schedule of draws, `DrawHistory.underDraws giving (fun t => use (Law.orbit alone w t)) x` (DrawHistory.lean 50). That is the package's module for the regime under changing draws.
  - It is neither identified nor named in "What the level's laws already have".
  - `regime_levels` is not a restatement: DrawHistory has no law for draws at least `H` with short giving.
- **L5. TurningInTime.lean 317, 326, 330: the premise is named `renews`.** The design allows "renew" only for the function `renew`. The name is `Optimum.ends_within`'s own, kept to match, but in this module it reads as the function's word used for "at most `r` given". Rename it (`gives_at_most`, say) or note that it is Optimum's.
- **L6. Borrowed words and doer wording outside §6 and its header bullet:**
  - Header 131-134 ("What is given and what is not shown"): "lock", "loss" and "`locked_at_class` is stated where the beyond is a loss". These lie outside the bullet DESIGN-R2 allows them in. DESIGN-R2 C.7 asked for the "Nothing here derives that a lock needs nothing…" sentence in the section docstring and the header bullet. It is in the section docstring (635-637) and in this header section, not in the bullet (91-104). Moving it into the bullet fixes the placement and the wording at once.
  - Header 119: "the level reads the way only through `use`": a person-word and a doer. Say "the level's step depends on the way only through `use`".
  - Line 157: "what it calls the rule" is DESIGN-R2 C.9's wording, `adaptive`'s own name. Accepted.
  - The name `core_tells` (269) is still a doer word, though its docstring is now exact.
  - The model labels are declared at header 40-42.
- **L7. TurningInTime.lean 606-607, `kind_not_toEnd_of_turn`.** "That `x` is marked … follows, by `outside` and `keeps`". With `marked` undecided, what follows is `¬¬ marked x`, and nothing in Lean states even that. Say "an unmarked `x` would contradict `turns` by `outside` and `keeps`".
- **L8. Docstrings that drop premises:**
  - Header 35-36 gives `RegimeMargin.ends_iff_below` without `0 < H + y`.
  - The private `regime_levels`' docstring (362-367) omits `nothing` (`FromNothing`) and the `step` premise.
- **L9. TurningInTime.lean 124-126.** "without it, a course never marked whose level never falls below the need is a line that never ends with no such step `T`": true by `agrees_until_marked`, but argued and not checked in Lean, and not said to be argued.
- **L10. Plan test, points 1 and 2: declarations that could go without loss of a claim.**
  - `alike_along` (302): unused; `«同行之迭»` composed with `toEnd_of_unmarked` and the tie.
  - `ends_with_net_regime` (403): unused; `turns_in_time_iff` goes through `regime_levels` directly.
  - `unmarked_interval_iff` (255): a Nat fact used once in `Three`, where `decide` would do.
  - `core_tells` (269): one application of `«有常则可续»` at the core.
  - `window_paced` (798): a composition, unused.
  - `stepWhile_step`, `stepWhile_always`, `stepWhile_hasSucc_iff`: unused in the three files.
  - `regime_step_eq` (350): public, used only by the private `regime_levels`.

  All of these are kept by the designs. I list them because this is the last round.
- **L11. `kind_not_toEnd_of_turn` has no Lean witness** (v1's vacuity note). `Three` at `renew 6 6`, `w = true`, `x = 6`, `x₀ = 9`, `κ = id`, `alone = id` would give one.
- **L12. New vocabulary (test point 5).**
  - `可决` (four GrammarPath names) is new to the package. The header now explains it (line 48), and the root lacked the word. Accepted.
  - In TurningInTime, `asItWas`, `net`, `pair`, `AloneOutside` and the four §6 definitions are designed. `windowRegroup` is the one that names what the package already names (L3).

## DESIGN-R2, item by item

| Item | State |
|---|---|
| A.1 | Done, worded as two law names instead of "fourth and sixth". The reason (header order differs from file order) is sound. The claim is true: `«有常»` ↔ `«至终有常»` ∧ onward ↔ `«同行»` ∧ decided ∧ onward ↔ `«同行»` ∧ onward, since onward gives decided. It is said to be unchecked. |
| A.2 | Done (lines 52-54). |
| A.3 | Done (line 48). |
| A.4 | Done (lines 54-55). |
| B.1 | Done (line 3). |
| B.2 | Done. `stepWhile_continues_iff` is as specified. `hasSucc` comes from `step_hasSucc_iff`, and `unending` from `unending_iff_steps` plus one private transfer. I checked the transfer myself: no package law transfers `«不穷»` along a pointwise iff of `«续»`. `GrammarTransport.«不穷之对应»` (375) needs `«谓» («像» e.to R) R'`, which fails here since `stepWhile ≠ step`. The extra deletion of `stepWhile_line_on_orbit` is sound. |
| B.3 | Done; `R`/`v` removed (line 49). |
| B.4 | Done. `Law.step_fixed` is stated on `(process next).step`, which is `Law.step` by definition (Recurrence 143). |
| B.5 | Done as asked. The `decided` reason is M2, and the omitted transfer is L1. |
| C.1 | Done; the only written-out form left is the definition (154). |
| C.2 | Done; `regularity_in_level`, `pair_eq` and the header clause are gone. |
| C.3 | Done (168). |
| C.4 | Done, with the premise changed from `keeps` to `respects`. Sound: at `id` it is `congrArg alone`, and it follows from `keeps`, so the law is stronger. `kind_ends_while_net_goes` is as specified. The docstring of `kind_not_toEnd_of_turn` is fixed (L7 is about its wording). |
| C.5 | Done (266-268). |
| C.6 | Done: `Adjusted.left_below` is used. The reason `Adjusted.step_below` does not fit is sound: that law is the two-argument adjusted step with `StaysShort` and a recent giving `r < H`, at draw `H`, not at a draw `d ≥ H`. |
| C.7 | Done in statements and proofs: no new induction; `regroup_orbit` is shared, which is sound. My own search agrees with the implementer's. `window_through`, `window_past`, `locked_along`, `window_past_course`, `ClosedCapture.course_past`/`turn_agree` and `ReadInTime.early`/`turn_before` (CarrierCounts only) do not have this conclusion, and no generic orbit-agreement law exists (grep `theorem *agree*`). The plain sentence is not in the header bullet (L6). |
| C.8 | Done (113-130). |
| C.9 | Done, all four. The added `orbit … 2 = (true, 6)` conjunct is an improvement. |

## Is GuardedStep's header true of its proofs, law by law?

- **Tie.** `stepWhile_step`, `stepWhile_always`, `stepWhile_fixed` and `stepWhile_continues_iff` are as said.
- **From the whole step's.** `hasSucc` comes from `step_hasSucc_iff`, as said. `unending` comes from `unending_iff_steps` through the tie and an unnamed transfer (L1).
- **On the orbit.** `steps_iff` has its own induction, as said.
- **Pointwise.** `none_iff`, `goesAlike_iff` (from `«同行之逐点»`) and `constant_iff` (from `«有常之逐点»`) are as said. The gloss "constancy asks that configurations of one value agree on whether they can go on" is right, by the symmetry of `π s = π s'`. `toEnd_iff` comes from GrammarPath's iff, as said.
- **`«同行当且仅当有常»`.** Its two premises are now stated (lines 9-11).
- **`Map.StepWhere`.** Named, as said.
- **The reason for `decided`.** Not proved (M2).
- **Not said.** The Viability counterpart is missing (M1).

## Names (round-2 additions)

`asItWas`, `net_zero`, `kind_ends_while_net_goes`, `join_is_asItWas`, `window_agrees_until_marked`, `window_paced`, `stepWhile_continues_iff`, `unending_of_continues`, `regroup_step`, `regroup_orbit` and `windowRegroup_inj` have zero hits in the package. `TurningInTime` and `GuardedStep` do not exist as modules there yet.

Other modules define `pair` and `net`: Integers 58, Joint 429, ReadingSchedule 402, ReaderRebuilding 124, RuleRebuilding 226, RoomNet 81 and ConditionInTime 208. These are in other namespaces, so they do not collide unless opened together. The name-level confusion that matters is the `GuardedStep`/`Viability.guardedStep` pair (M1).

## First-round findings: closed or open

- **v1:**
  - M1 closed: the claim now matches. The lock and the pair are still joined only by identifications, and the section says so.
  - Closed: M2, M3, L1, L2, L3, L4, L6 and L7.
  - L5 closed on DESIGN-R2's wording.
  - L8 closed, with the residue in L7 above.
  - The vacuity note is open (L11).
- **v2:**
  - Closed: H1, H2, M1, M2, M4, L2, L4, L5, L6, L7 and L8.
  - M3 closed: the reason for not using `step_below` is sound.
  - L1 is open: not recorded in GrammarLaws' docstrings, left because GrammarLaws is upstream.
  - L3 is open: two forms of `decided` with no sentence relating them.
- **v3:**
  - Closed: H1, H2, M1, M2, M3, M4, M5, L1 (on the designed wording), L3, L5, L6, L7, L9 and L10.
  - L2 is open, and widened: borrowed words now also stand in "What is given" (L6).
  - L4 is closed in the docstring; the name `core_tells` remains.
  - L8 passed in round 1; nothing to do.

## Not checked

- Builds, axiom reports and warnings, by instruction. I did not run anything.
- The elaboration of the closed `by decide` terms in `Three`. I did check `Three`'s numbers by hand:
  - the course as it was runs 9, 8, 6, 2, 0;
  - marked at 9 the level is 8, marked at 8 it is 6, marked at 6 it is 2 and then 0;
  - `Short 3 3`, `Meets 3 3 12`, `Keeps 3 12` and `Short 5 5` hold for `min z (12 - z)`.
- GrammarPath's six dependents.
- The maps in `tmp/r7/tt/map/`, beyond what the designs quote.
- Package modules outside the searches named above, for laws stated under unrelated names. My searches were by name pattern and by statement shape (guarded steps, `«不穷»` transfers, orbit agreement, regime under changing draws, `x + g - d` forms), not a full read.
- The bodies of the first-round reports beyond their findings.
