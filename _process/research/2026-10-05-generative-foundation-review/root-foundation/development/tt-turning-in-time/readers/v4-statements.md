Kept as written; local paths in it point to the session's scratch folder.

AI-written reading, round 2, 12 November 2026. Reader v4. Lens: statement against claim, and vacuity. Read only: nothing built or run, and nothing edited except this file.

Read whole: `tmp/r7/tt/lean/Becoming/GrammarPath.lean` (diffed against the package copy), `GuardedStep.lean`, `TurningInTime.lean`; `DESIGN-R2.md`; the three first-round reports. In the package, read for the cited statements: Grammar (`«一» «静» «合» «续» «有后» «亡» «不穷» «有常» «核» «根» «静有常»`), GrammarLaws (`«同行» «同行之逐点» «有常则可续» «局定后则有常当且仅当同行可续» «同行当且仅当有常» «后不定则核可不同行» «同行之迭» «定后»`), GrammarPath (`«至终有常» «本类至终有常» «亡而网续则本类不至终有常» «出类不随则本类不至终有常»`), OwnClass `«类闭则本类常闭»`, GrammarCourse `step_hasSucc_iff`, GrammarRegularity (`unending_iff_steps adaptive_constant_iff lockedAlike orbit_paced`), GrammarMap `«尽则有终当且仅当排中»`, RegimeMargin (`step FromNothing Short Meets Keeps ends_below holds ends_iff_below Adjusted.left_below Adjusted.draw_pos`), Optimum (`never_rises level_le_start ends_within`), ReadOffInTime `first_of_decided`, Pace `paced`, RuleCapture (`Raises ReadsShare Locked turn_locked`), ClosedCapture (`join joinRead course_past`), PoolFromCourse (`ReadsThroughPresent Stands windowRead window_through window_unread window_past window_past_course locked_along`).

## Verdict

No statement is false, and no theorem is empty or true of every relation. `regularity_in_level` and `window_unending` are gone, and nothing like them came back. The three witness courses and the new conjunct of `Three.turned_and_ends` are right by hand. The round-2 changes close nearly every first-round finding.

Three medium findings remain. Each is a sentence of prose that says something false or unproved about Lean statements:

- TurningInTime says twice that sections 4 and 5 "say nothing of" the lock's models. Two laws of section 5 take any need, need 0 included.
- `window_agrees_until_marked`'s docstring misdescribes `window_through`.
- GuardedStep's header gives a reason for the `decided` premise that the cited law does not supply.

None is high. All three are prose fixes. No statement needs to change.

## High

None.

## Medium

**M1. "Sections 4 and 5 say nothing of them" is false for section 5's two kind laws.** TurningInTime.lean 131-132 (What is given) and 635-637 (section 6 docstring).
- The sentence reads: "its models have a total step, so in them no line ends where the net ends, and sections 4 and 5 say nothing of them."
- The first half is right. Section 4 needs `0 < need`, and so do `unending_iff_above` and `turns_in_time_iff`. `unending_iff_first_marked` is vacuous at need 0, since `asItWasEnds` would need a level below 0.
- But section 5 also holds `kind_ends_while_net_goes` (592-601) and `kind_not_toEnd_of_turn` (603-619). Neither takes a positive need. Both hold at `need = 0`, where by `net_zero` the net is the pair's whole step. They speak exactly of the second ending, a line under a kind's class that ends while the net goes on, and that ending is the one that can happen on a total step.
- With `window_alone_outside` as the `AloneOutside`, `kind_not_toEnd_of_turn` applies to the window pair at need 0, for any kind `alone` keeps.
- As written, the sentence tells a reader that the module's laws are silent on the lock's models. Two of them are not.
- Fix: "and sections 4 and the split, `unending_iff_above` and `turns_in_time_iff` of section 5 say nothing of them (they need a positive need); `kind_ends_while_net_goes` and `kind_not_toEnd_of_turn` take any need, and so apply at a need of nothing too." Whether to state that application is a separate question. Its absence should not be stated as silence.

**M2. `window_agrees_until_marked`'s docstring misstates `window_through`.** TurningInTime.lean 774-775.
- It says: "`window_through` and `window_past` (the window reads off the share, pointwise, outside `[N, K)` and past `K`)".
- `window_through` (PoolFromCourse 259) is `ReadsThroughPresent (Stands K) hA (windowRead …)`, with `Stands K p := p.2 < K`. It says the window reads off the share where `¬ p.2 < K`: at or past `K`, the same region as `window_past`. Neither law covers levels below `N`.
- So no package law says "outside `[N, K)`" pointwise. That fact is ours, `window_alone_outside`, by `if_neg`. The docstring credits it to an existing law.
- It also leaves out `window_unread` (PoolFromCourse 265). At `K ≤ N` the window reads off the share at every configuration, which makes the window course the share-read course outright. That is the nearest special case of this law.
- Fix: "`window_through` and `window_past` (the window reads off the share, pointwise, at or past `K`), `window_unread` (at every configuration where `K ≤ N`), …".

**M3. GuardedStep's reason for the `decided` premise is not what the cited law shows.** GuardedStep.lean 39-42.
- The text: "That `can` be decided is a premise because reaching an end can need the decision: that every line ending on every branch reaches an end is excluded middle (`«尽则有终当且仅当排中»`…)".
- `«尽则有终当且仅当排中»` (GrammarMap 584) is about `«尽» → «有终»` for every type and relation. It does not say anything about `«至终有常»` or `«同行»`, and no Lean statement shows that `stepWhile_toEnd_iff` fails without `decided`.
- What is true, and argued only: at `E := «一»` going alike holds for every `can`, so the reverse direction without `decided` would give `can u' ∨ ¬ can u'` wherever some `u` can go on. That is excluded middle on any proposition put into `can`.
- So "because" presents an analogy as the reason. Fix: "`decided` is a premise: without it the reverse direction at the one would decide `can` (argued here, not stated in Lean); the package's own calibration of a cut step against excluded middle is `«尽则有终当且仅当排中»`."

## Low

- **L1.** GrammarPath.lean 54-55. "(These six laws and this paragraph's last sentences are AI-written …)". The added sentences are not the paragraph's last: the old `FiniteFamilies` and `FiniteSharedCondition` sentences follow the marker, inside the same bullet. Say "the sentences from 'With the successor fixed' to here".
- **L2.** GrammarPath.lean 51-54, the witness sentence. `«后不定则核可不同行»` proves `¬ «同行» R («核» R «静»)`, not `¬ «同行» R «静»`. The core of `«静»` is `«静»` there, but that equality is not stated. "The law with that relation" is true. A reader may still take the law as proving the sentence. Add "(it proves it of the core of `«静»`, which is `«静»` there)".
- **L3.** TurningInTime.lean 606-607. `kind_not_toEnd_of_turn`: "That `x` is marked … follows, by `outside` and `keeps`". With no decidability of `marked`, what follows constructively is `¬ ¬ marked x`. The package counts axioms, so say "`x` is not unmarked", or "with decided marks, `x` is marked".
- **L4.** TurningInTime.lean 866-869 and header 107-108. "At step 2 … the line under the way's class ends while the net goes on". The new conjuncts prove `orbit (pair …) (true, 9) 2 = (true, 6)`, that `«亡»` holds at `(true, 6)`, and that `(true, 6)` has a next. They do not prove that `(true, 6)` lies on a line under the way's class from `(true, 9)` (`«相续» … (true, 9) (true, 6)`). It does, since the ways at steps 0-2 are all `true` and the levels meet the need, but that is argued. This leaves v3 M1 closed only pointwise.
- **L5.** TurningInTime.lean 91-96 and 621-626, title and bullet of section 6: "as courses of the pair, at a need of nothing". `window_is_pair` and `join_is_asItWas` give orbits of a pair. `net_zero` gives `net 0 = Law.step (pair …)`. That a regrouped lock course is a line (`«迭»`) of `net 0 (windowRenew …) (windowLeft fB)` is their composition, and that composition is not stated. Otherwise the phrase "at a need of nothing" is used only for `net_zero`, for `constant_adaptive` (`net 0`) and in this title. I found no use beyond what those prove.
- **L6.** TurningInTime.lean 667-668. `locked_at_class`'s bold sentence: "the class of being locked or not is constant up to the net's end". What is proved is `«本类至终有常»`, constancy up to the net's end at the member's class, and not `«至终有常»` of `lockedAlike`. The unlocked block need not be closed. The docstring's second sentence is exact; the bold one should say "at the member's class".
- **L7.** TurningInTime.lean 118-123, What is given. Its list of choices in the level's step leaves out `FromNothing giving`. `ends_with_net_regime` and `turns_in_time_iff` rest on it through `regime_step_eq`, and `unending_iff_above` through `ends_iff_below`. The bullets name it; this section does not.
- **L8.** TurningInTime.lean 31. `Optimum.ends_within` is glossed as "below any positive need once the steps exceed its start". The statement is `x 0 < m + t → x t < m`, so it already holds at `t = x 0`, and `ends_with_net` uses it there ("within `s.2` steps"). Say "once the steps reach its start".
- **L9.** TurningInTime.lean 35-36. `RegimeMargin.ends_iff_below` is glossed with only "from a level up to `hi`". It also needs `0 < H + y`, `Short`, `FromNothing`, `Meets` and `Keeps`. The section is a summary of existing laws, but L1 of round 1 asked for this kind of thing elsewhere.
- **L10.** TurningInTime.lean 106. "a use of five as it was and three once of the kept kind": "three once" does not parse. Say "and three for the kept kind".
- **L11.** TurningInTime.lean 115 and 613. `turns` names two different premises. In `turns_in_time_iff` it says a way after a marked step is `Kept`. In `kind_ends_while_net_goes` and `kind_not_toEnd_of_turn` it says `¬ κ (renew w x) = κ w`. What is given (115) speaks of the first only. This is harmless in Lean but confusing in prose that cites premises by name.

## Bullet by bullet

**GrammarPath header** (the added sentences, 42-55):
- The six names and directions match their statements.
- «局定后则有常当且仅当同行可续» "follows from" the two iffs: true by hand (`可续` gives `可决`), and correctly marked as not checked in Lean.
- The `可决` gloss is present.
- L1 and L2.
- The six docstrings (241-292) say exactly what is proved, every premise named.
- Additions only: hunk 1 inserts text inside old line 42 and keeps its words, and hunk 2 adds the six theorems after `«有常则至终有常»`.

**GuardedStep header** (8-44):
- The tie: `stepWhile_step`, `stepWhile_always`, `stepWhile_fixed` and `stepWhile_continues_iff` match.
- "From the whole step's, through the tie" is true: `stepWhile_hasSucc_iff` is `step_hasSucc_iff` at `can x ∧ E x y` through the tie, and `stepWhile_unending_iff` is `unending_iff_steps` through the tie and `unending_of_continues`. The private transfer is correct. Its docstring ("depends on the relation and the class only through the steps that continue") is exactly its statement.
- "On the orbit" and "Proved pointwise" match.
- The `«同行当且仅当有常»` premises are named (v3 L6 closed).
- `Map.StepWhere.relation` is cited (v2 L7 closed).
- Only M3 remains.
- Every docstring matches its theorem.

**TurningInTime header** (12-136):
- What the root has: correct.
- What the level's laws have: correct except L8 and L9. `FromNothing` is now named for `ends_below` (v1 L1).
- What this module adds: each law's own docstring does name all its premises, as line 40 says. I checked every public theorem.
  - `pair_adaptive`, `net_zero`, `toEnd_iff`, `constant_iff`, `constant_iff_needs_nothing` (`w₀` named), `constant_adaptive`, `kind_toEnd_of_unmarked` and `toEnd_of_unmarked` (the `respects` premise, weaker than `keeps`, as the docstring says) match their bullets.
  - So do `unmarked_interval_iff`, `core_tells` (now without a doer), `agrees_until_marked`, `asItWas_way`, `alike_along`, `ends_with_net`, `regime_step_eq` and `ends_with_net_regime`.
  - So do `unending_iff_first_marked`, `unending_iff_above`, `turns_in_time_iff` ("the need met there and at every step before it"), `kind_ends_while_net_goes`, `kind_not_toEnd_of_turn` and the section 6 laws, apart from L5 and L6.
  - Three: L4, L10.
- What is given: every item round 1 listed is now there: `uses`, the one `giving` through `use`, `Meets`, `Keeps`, `within`, `high`, `asItWasEnds` with the reason, and `w₀`. Missing: `FromNothing` (L7). False: the "sections 4 and 5" clause (M1).
- The model-labels sentence (40-42) is present (v3 M5 closed).

**Section 6.**
- Title: backed by `window_is_pair`, `join_is_asItWas` and `net_zero`, with L5.
- Section docstring, sentence by sentence:
  - The regrouping is the pair's step: `window_is_pair`, `join_is_asItWas`.
  - A total step is the net at a need of nothing: `net_zero`.
  - The course that reads off the share is the window course as it was: `join_is_asItWas`.
  - The window course is the orbit of the window pair: `window_is_pair`, and on `paced`, `window_paced`. That statement is checked: `orbit_paced` at a start with step count 0, regrouped.
  - Outside `[N, K)` the way is `windowAlone`: `window_alone_outside`.
  - It agrees until the loss is first in `[N, K)`: `window_agrees_until_marked`. Its hypothesis is on the share-read course's loss at steps `j < n`, as stated.
  - The locked region is closed: `locked_closed`. The root's condition at the class: `locked_at_class`.
  - "Nothing here derives that a lock needs nothing": present and true.
  - "Sections 4 and 5 say nothing": M1.
- Header bullet: the same, with M2 in the docstring it points to.

## Checked by hand

`kind_ends_while_net_goes`:
- `«亡» R E x` is `¬ ∃ y, R x y ∧ E x y`.
- With `R = net need renew left = stepWhile (need ≤ ·.2) (pair …)`, a witness gives `y = pair renew left (w, x)`, so `y.1 = renew w x`. With `E = sameValue (κ ∘ fst)`, it gives `κ w = κ y.1 = κ (renew w x)`, against `turns`. The proof does exactly this.
- The second conjunct is `⟨pair renew left (w, x), ge, rfl⟩`.
- No premise on marks or `alone` is needed, and the docstring names none. The premises can all be met (Three). It is not true of every relation: it uses the net's form.

The new conjunct of `Three.turned_and_ends`:
- Marks `[6, 6]`, `left = RegimeMargin.step giving (use w)` with `step g H x = (x - H) + g (x - H)`.
- From `(true, 9)`: 9 is unmarked, so the way stays `true` and the level becomes 4 + g 4 = 8. 8 is unmarked, so the level becomes 3 + 3 = 6. So `orbit 2 = (true, 6)` ✓.
- At `(true, 6)`: `renew 6 6 true 6 = false ≠ true` ✓, and `1 ≤ 6` ✓. So under the way's class `(true, 6)` ends (`«亡»`), while the net relates it to `(false, 2)` ✓.

The three courses, again (`giving z = min z (12 - z)`, `use true = 5`, `use false = 3`):
- As it was: 9 → 8 → 6 → 2 → 0 (4 + 4, 3 + 3, 1 + 1, 0 + 0).
- `Short g 5 5`: g z = z < 5 for z < 5 ✓. `Short g 3 3` ✓.
- `Meets g 3 3 12`: for 3 ≤ z ≤ 9, g z ∈ {3, 4, 5, 6, 5, 4, 3}, each ≥ 3 ✓.
- `Keeps g 3 12`: (x - 3) + min(x - 3, 15 - x) ≤ 12 for x ≤ 12 ✓.
- Start premises: 9 < 10, 9 ≤ 12, 0 < 1, 1 ≤ 6 ✓.
- `goes_on`, marks `[9, 9]`: T = 0, the level as it was at 1 is 8 ≥ 6, and the kept course 8 → 10 → 12 → 12 … never ends ✓.
- `goes_on`, marks `[8, 8]`: T = 1 (9 unmarked, 8 marked), the level as it was at 2 is 6 ≥ 6, and 6 → 3 + 3 = 6 is fixed ✓.
- `turned_and_ends`: `(true, 9) → (true, 8) → (true, 6) → (false, 2) → (false, 0)`. Orbit 3 = `(false, 2)` ✓. Four net steps from levels 9, 8, 6, 2 ≥ 1 ✓. `(false, 0)` conditions nothing ✓. Not unending at 4 ✓.
- `ends_as_it_was`, marks `[10, 0]` (empty): `(true, 9) → … → (true, 0)` in 4 steps ✓. The first conjunct holds for levels ≥ 1, as the docstring now says ✓.

## Vacuity

- No theorem in the three files holds for every relation in the way `regularity_in_level` did.
- `net_zero` and `core_tells` hold for every `renew` and `left`, but that is their content (the cut), and their docstrings claim no more.
- `kind_toEnd_of_unmarked` and `alike_along` are near-direct from `AloneOutside` plus `un`, but they are not vacuous.
- The premises of `turns_in_time_iff`, `unending_iff_above` and `kind_ends_while_net_goes` hold together in `Three`.
- `kind_not_toEnd_of_turn` still has no Lean witness: v1's note, left open by the implementers. Its premises can be met (`renew 6 6`, `w = true`, `x = 6`, `x₀ = 9`, `κ = id`, `alone = id`).
- `window_agrees_until_marked`'s hypothesis is not empty: it is true for every `n` where `K ≤ N`.

## First-round findings: status

v1:
- M1 closed (retitled, `join_is_asItWas`, `window_agrees_until_marked`, `window_unending` deleted). M1 above is a new problem in the replacement text.
- M2 closed (removed).
- M3 closed, apart from L7 above.
- L1 closed (L8 and L9 above are other sentences of the same section).
- L2, L3, L4, L5 and L6 closed.
- L7 closed (`window_paced` composes it in Lean, and the wording is fixed).
- L8 closed, with the constructive point in L3 above.

v2:
- H1 and H2 closed.
- M1 closed.
- M2 closed as the design chose (one-line proof kept, `Law.step_fixed` named).
- M3 closed (`Adjusted.left_below` used; the reason the bound induction stays is given).
- M4 closed.
- L1 still open, left on purpose: GrammarLaws is upstream.
- L2 closed, with L2 above.
- L3 still open, left on purpose.
- L4, L5, L6 and L8 closed.
- L7 closed as a citation, with M3 above on the reason it is made to give.

v3:
- H1 closed.
- H2 closed in title and statements, with M1 above.
- M1 closed pointwise only (L4 above).
- M2, M3 and M4 closed (`asItWas` is used everywhere: the only written-out form left is its definition, line 154).
- M5 closed.
- L1, L3, L4, L5, L6, L7, L9 and L10 closed (L1 above on L10's wording).
- L2 still open, left on purpose (cited names).
- L8 passed in round 1 and needs nothing.

## Not checked

- That the files compile, that axiom reports are empty, and that there are no warnings: taken from the implementers' reports. I ran nothing.
- Whether `decide`, `if_pos`, `if_neg` and the `Decidable` instances bring in an axiom.
- Proof terms line by line, beyond `kind_ends_while_net_goes`, `kind_not_toEnd_of_turn`, `stepWhile_continues_iff`, `unending_of_continues` and `windowRegroup_inj`. Otherwise I took the type checker's word that each proof proves its statement.
- The implementers' searches (no package law transfers `«不穷»` along `«续»`; no existing law with `window_agrees_until_marked`'s conclusion; name collisions). I re-checked only the PoolFromCourse neighbours for M2.
- The maps in `tmp/r7/tt/map/`.
- The declaration counts the implementers report.
- `DESIGN.md` (round 1) beyond what `DESIGN-R2.md` changes.
