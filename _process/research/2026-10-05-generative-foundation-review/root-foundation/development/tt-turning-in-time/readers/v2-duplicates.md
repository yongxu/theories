Kept as written; local paths in it point to the session's scratch folder.

AI-written reading, 12 November 2026.

# TT v2: restatement and placement

Reader's lens: is each new declaration, or a trivial instance of it, already in the package under another name; where a new proof does by its own induction what an existing law gives; placement and name collisions; GrammarPath.lean changed only by additions. Read only. Nothing was built or run.

Files read: `tmp/r7/tt/lean/Becoming/{GrammarPath,GuardedStep,TurningInTime}.lean`, `tmp/r7/tt/DESIGN.md` (sections header, A, B, rules; C skimmed), and the package files named below. Package path abbreviated `P/` = `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.

## GrammarPath.lean: additions only?

`diff` of the original against the new file gives two hunks: `42c42,51` and `227a237,287`.

- Hunk 1 is the header paragraph "Up to the net's end". The original line 42 ("are their corollaries. In a finite descent with two families the class of one family is narrower") is split: its first words stay on line 42, its last words end line 51, with the new sentences between. The original wording is kept whole; only the line wrapping changed.
- Hunk 2 adds the six theorems after `«有常则至终有常»` (new lines 237-287), as the design asks.
- No existing statement, proof, or name changed. None of the six new names occurs anywhere in `P/` (grep, 0 hits each).

## Findings

### High

**H1. `Law.stepWhile_unending_rel_iff` (GuardedStep.lean 108-140) repeats, by its own induction, what `Law.unending_iff_steps` (P/GrammarRegularity.lean 146-171) already proves.**
`unending_iff_steps` holds for every `E`: `«不穷» (step next) E s ↔ ∀ n, E (orbit next s n) (orbit next s (n + 1))`. A line under `stepWhile can next` and `E` is a line under `step next` and `E' x y := can x ∧ E x y`, because `«续»` is `«合»`, so the two steps agree pointwise: `(can x ∧ y = next x) ∧ E x y` against `y = next x ∧ (can x ∧ E x y)`. `«不穷»` depends on `R` and `E` only through `«续» R E`. So the private helper is `unending_iff_steps` at `E'`, moved across one pointwise equivalence. It does not have to repeat `reached_while_same`'s `Nat.rec` together with the `.inl`/`.inr` line build (new 115-129 against GrammarRegularity 150-162, which is the same code).
- The design asks for this route twice. Section B says "each derived from the total step's", and the rules say "Do not restate. If a statement you need exists, use it by name". The map lists the law (`map/followup-ownclass-lock.md:124`). The map workflow's summary names it outright: "`never_ends_iff` is the guarded form of `Law.unending_iff_steps`" (`map/_workflow-result.json:313`).
- Placement: GuardedStep imports only `GrammarCourse` and `GrammarPath`, so `unending_iff_steps` is out of its scope. Importing `Becoming.GrammarRegularity` would create no cycle, because GrammarRegularity imports `GrammarCourse`, `ClosedCapture` and `Mechanism`, and none of them imports GuardedStep. TurningInTime imports both anyway. The design gives no reason for the narrower import.
- The header (GuardedStep 22-25, 36-39) and the docstring at 148-149 name only `Law.unending_iff` as the total-step counterpart. The relation-general counterpart, `unending_iff_steps`, is never cited.

**H2. `regularity_in_level` (TurningInTime.lean 230-242): its first half is the trivial case that the package itself says shows nothing about which description carries the regularity.**
With the joint class the identity (`pair_eq`), `«足以定核» R E₁ E₂` holds for every relation `R` and every class `E₁`. This is because `«核» R E₁` is a class (`«核为类»`) and so contains the identity. The package states this for the flame in `«火之见证不择类»` (P/Grammar.lean 845-853): "Every class that, with 'flame or not', tells the four moments apart suffices", and "it does not show which description that is". The new proof repeats that one-line argument (core reflexive at `s = t`) and does not cite it.
- The real content of `regularity_in_level` is its second conjunct: the way's class is not constant (from `constant_iff_needs_nothing`). The `«足以定核»` half holds at every relation, the level or not.
- The docstring and the header (lines 25-26 at the module's head) say "the way's regularity lies in the level". The Lean shows only that the way together with *any* class that tells all configurations apart suffices. The phrase "As with the flame and its fuel, the joint class here is the identity" names the identity, but it does not carry the package's own caution that this case "picks no class". The claim says more than the Lean proves.
- The generic law, that a joint class inside `«静»` gives `«足以定核»`, is not in the package as a general theorem: `«火之见证不择类»` is stated for `Flame` only. If the identity case is kept, it belongs as one general root law beside `«合有常则足以定核»` (Grammar.lean 623), with `«火之见证不择类»` and this theorem as its instances. As written, it is a second private copy of the argument.

### Medium

**M1. GuardedStep's header says every law there is the total step's, restricted, with `stepWhile_always` as the tie (lines 36-39). No Lean checks this, and only one law is derived from a total-step law.**
`stepWhile_always` (59-61) is a `«谓»` between the two relations, but no theorem carries any `stepWhile_*` law back to its total-step counterpart. Each law is proved directly from `«同行之逐点»` / `«有常之逐点»` or by its own induction:
- `stepWhile_hasSucc_iff` against `Law.step_hasSucc_iff`, GrammarCourse 107;
- `stepWhile_constant_iff` against `Law.constant_iff_keeps`, GrammarCourse 112;
- `stepWhile_unending_value_iff` against `Law.unending_iff`, GrammarCourse 200;
- `stepWhile_steps_iff` against `Law.steps_orbit`, Recurrence 255.

Only `stepWhile_line_on_orbit` goes through a total-step law (`line_on_orbit`). The sentence "where `can` always holds, each law reads as the total step's (for `Law.stepWhile_unending_value_iff`, that is `Law.unending_iff`)" is a reading, not a proof. Design B asked for "each derived from the total step's". That was not done, and the deviation list does not say so.

**M2. `Law.stepWhile_fixed` (GuardedStep 64-65) repeats `Law.step_fixed` (P/Recurrence.lean 263-264), proof included.**
`Law.step_fixed next : «定后» (fun x y => (process next).step x () y)`, and `(process next).step x () y` is by definition `y = next x`. The new proof `fun _ _ ⟨_, ⟨_, e₁⟩, ⟨_, e₂⟩⟩ => e₁.trans e₂.symm` is `step_fixed`'s proof with the guard projected away. Design B said "from `step_fixed` by inclusion if that is shorter, else directly". Direct is allowed, but `step_fixed` is not cited, and the implementer's report does not mention it. It is the same one-liner, so this is placement, not cost. It is ranked medium because the header claims these laws are tied to the total step's and this one plainly could be.

**M3. `regime_levels` (TurningInTime 333-363) repeats arithmetic that RegimeMargin already has.**
- `short_at` (345-354) proves `z < H + y → H ≤ d → giving (z - d) < H`. At `d = H` this is `RegimeMargin.left_below` (P/RegimeMargin.lean 474-481: `x < H + y → x - H < y`, for `0 < y`) composed with `Short`, as `Adjusted.step_below` (485-504) does. With `d ≥ H` it follows from `z - d ≤ z - H` and `left_below`, together with the `z < d` case through `FromNothing`. The new proof rebuilds the `sub_add_cancel` / `le_of_add_le_add_right` chain.
- The `bound` induction (355-361) is `Optimum.level_le_start`'s own induction (Optimum 2262-2265), inlined. The design sanctions this joint induction, and it is needed: `level_le_start` asks for `renews` at every `t`, which here depends on the bound. So this part is correctly placed beside. Only the `short_at` arithmetic is avoidable.
- The docstring at 332 says "by a joint induction with `Optimum.never_rises`". That is accurate.

**M4. GrammarPath's new header sentence calls `«局定后则有常当且仅当同行可续»` "the composite of these two, by its own proof there" (new 47-48). The composite is argued, not checked.**
No theorem derives the GrammarLaws iff from `«局定后则至终有常当且仅当同行可决»` and `«有常当且仅当至终有常可续»`. The composition is short and true: `onward` implies the `decided` disjunction by `.inl`. "By its own proof there" tells the reader that GrammarLaws does not use the new laws, but "is the composite" is still a proof claim that no Lean in either file states. Design A said "do not claim it is re-proved". The text does not claim that, but it does claim the composition. A five-line theorem in GrammarPath, for example `«局定后则有常当且仅当同行可续»` re-derived under a distinct name, or a corollary, would check it.

### Low

**L1. `«至终有常局定后则同行»` (GrammarPath 239-247) generalizes `«有常局定后则同行»` (P/GrammarLaws.lean 2578-2585) and sits beside it, not below it.** The proof is the old one with one extra `.inr stops => absurd` arm. The old law is the new one at `«有常则至终有常» constant`, but it is not re-derived, because GrammarLaws lies upstream of GrammarPath and the design leaves GrammarLaws unedited. The design gives that reason ("Nothing is renamed ... GrammarLaws ... not edited"), and it holds. The same goes for `«至终有常则可决»` beside `«有常则可续»` (GrammarLaws 2592), `«同行可决则至终有常»` beside `«同行可续则有常»` (2600), and the iff beside `«局定后则有常当且仅当同行可续»` (2612). The pairing is recorded only in the header prose, not in the docstrings of the old laws.

**L2. The witness sentence in GrammarPath's header (new 48-51), "0 conditions 1 and 2 and the class is the identity (`«静»`) ... the class is constant ... but does not go alike", has no Lean witness of its own, though the package nearly has one.** `«静有常»` (P/Grammar.lean 401) gives the constancy. `«后不定则核可不同行»` (P/GrammarLaws.lean 2652-2666) is the same relation `R 0 1, R 0 2` with `E = «静»` and proves `¬ «同行» R («核» R «静»)`. Its core is `«静»` there, but under the core's name, not `«静»`'s. Neither is cited. The design made a Lean witness optional, but citing these two would make the sentence checkable.

**L3. Two forms of the "decided" premise now exist side by side.** GrammarPath's new `decided` is `∀ u u' v, E u u' → R u v → (∃ v', R u' v') ∨ ∀ w, ¬ R u' w`. OwnClass's `«类闭则本类常闭»` (P/OwnClass.lean 105-106) takes `∀ u, E m u → (∃ w, R u w) ∨ ∀ w, ¬ R u w`. They differ in scope (every `E`-image of an occurrence that conditions something, against the member's block), so neither restates the other. No text relates them.

**L4. `kind_toEnd_of_unmarked` (TurningInTime 557-565) and `toEnd_of_unmarked` (195-200) are one law at two classes.** The kind version takes `κ : W → Bool`, but nothing in its proof uses `Bool`. At `κ : W → K` for any `K`, `toEnd_of_unmarked` would be its instance at `κ := id`. The same holds for `kind_not_toEnd_of_turn`, which also uses no `Bool`-specific fact. The `Bool` narrows both for no stated reason.

**L5. `window_unending` (TurningInTime 700-703) is a trivial instance of a law the module does not state: at a need of nothing the net of every pair never ends.** The proof `Law.stepWhile_unending_iff.mpr (fun _ => Nat.zero_le _)` uses nothing of the window. Stating it for `net 0 renew left` in general, with the window as a one-word instance, would place it in section 1 with `net`.

**L6. `pair_eq` (TurningInTime 227-228, private).** The implementer's report says no axiom-free product extensionality is in use in the package. Two lemmas of this kind exist:
- `GrammarLaws.pair_eq` (P/GrammarLaws.lean 2468: `∀ {x y : Nat × β}, x.1 = y.1 → x.2 = y.2 → x = y`);
- `BlanketCouplings.pair_eq` (P/BlanketCouplings.lean 136, at `Type`).

Neither fits `W × Nat` with `W : Type u` as stated: the first wants `Nat` first, the second wants `Type` 0. So a private copy is defensible, but the report's statement is not accurate. Because it is private, there is no name collision.

**L7. `Map.StepWhere.relation` (P/GrammarMap.lean 506-510) is a guarded step of exactly this shape, and GuardedStep does not tie it to `Law.stepWhile`.** The design's own map says "Guards appear only inside witnesses: `Map.StepWhere.relation` ...". GuardedStep's `decided` premise (`stepWhile_toEnd_iff`, 174-175) is where `StepWhere`'s calibration bites: `«尽则有终当且仅当排中»` shows that every line ending at an end is excluded middle for the guard. Nothing cites it, so a reader does not learn that the decidedness premise is necessary in that sense. This is placement only; no restatement.

**L8. `kind_not_toEnd_of_turn`'s docstring (TurningInTime 567-571) says "at a marked level `x`", but `marked x` is not a premise.** It follows from `turns`, `outside` and `keeps`: an unmarked `x` would give `renew w x = alone w`, of the same kind. So the statement is right, but the docstring names a premise the Lean does not take.

## Declarations checked and found not restated

- **GuardedStep:**
  - `Law.stepWhile` (new: no guarded step in `P/` except witnesses, L7);
  - `stepWhile_step`, `stepWhile_always`, `stepWhile_none_iff`, `stepWhile_goesAlike_iff` (new);
  - `stepWhile_toEnd_iff` (correctly from `«局定后则至终有常当且仅当同行可决»`);
  - `stepWhile_line_on_orbit` (correctly from `line_on_orbit`);
  - `stepWhile_steps_iff`: its guard part needs its own induction; the unguarded half is `Law.steps_orbit`, and the fixed-successor half could use `«迭之定»`. Acceptable.
- **TurningInTime, sections 1-3:**
  - `pair_adaptive` (definitional, `Iff.rfl`);
  - `toEnd_iff`, `constant_iff`, `constant_iff_needs_nothing`, `constant_adaptive` (all through GuardedStep's laws and `adaptive_constant_iff`, as they should be);
  - `core_tells`: `«有常则可续»` at the core. No existing root law tells apart a member that conditions something from one that conditions nothing. `«亡于核下不变»` (Grammar 523) and `«有亡之线两端核异»` (GrammarRegularity 132) need `«亡»` under the class, which `(w, x)` need not satisfy.
  - `unmarked_interval_iff` (pure `Nat`, no counterpart found);
  - `agrees_until_marked`: its own induction, beside `ClosedCapture.join_course`, `course_past` and `PoolFromCourse.window_past_course`. The design says so and states the reason (a rebuild of 23 modules). Not found as a general law: no "two laws agree on the orbit while their steps agree" lemma in `P/`.
  - `asItWas_way`;
  - `alike_along` (through `«同行之迭»`, correct).
- **TurningInTime, sections 4-7:**
  - `ends_with_net` (through `Optimum.ends_within` and `first_of_decided`);
  - `regime_step_eq`: new. RegimeMargin gives the balance form `Adjusted.step_balances` (513), not `Optimum`'s form.
  - `ends_with_net_regime`, `unending_iff_first_marked`, `turns_in_time_iff` (compositions);
  - `unending_iff_above` (through `RegimeMargin.ends_iff_below` and `holds`; its `run` induction is a projection of orbits, and no general orbit-projection lemma exists in `P/`; `Adjusted.orbit_regime` (336) is the same pattern for another step);
  - `locked_closed`: the one-step closure behind `RuleCapture.locked_stays` (RuleCapture 182) and the `Locked` conjunct of `ClosedCapture.lock_outlives_loss` (307), stated without `Accrues`. Beside, new; neither old law is re-proved, as the header says.
  - `locked_at_class` (through `«类闭则本类常闭»`, correct);
  - `windowRegroup`, `windowRenew`, `windowLeft`, `windowAlone`, `window_step`, `window_is_pair`, `window_alone_outside`;
  - `Three.*`.

## Names

No collisions were found:
- **New GrammarPath names:** none of the six occurs in `P/`.
- **`Law.stepWhile*`:** absent from `P/`.
- **New TurningInTime names:** all sit in the new namespace `Becoming.TurningInTime`, which does not exist in `P/`, and no `TurningInTime.lean` or `GuardedStep.lean` is in `P/`.
- **Same short names elsewhere:** `pair`, `net` and `window_step` exist in `Continuation`'s `Coupled`, `Integers`, `Joint`'s `Pool`, `ConditionInTime`, `ReaderRebuilding`, `Rooms` and `Regulation`. None of these is in a namespace that TurningInTime opens (`Pace`, `RuleCapture`, `ClosedCapture`, `PoolFromCourse`), and grep found no `pair`, `net`, `window*` or `locked_closed` in those four.
- **The design's known-collision list** (`Course`, `Lasts`, `not_constant`, `in_time`, `too_late`, `kept_iff`, `holds`, `falls`, `step`): none is declared new.

## Not checked

- Whether the files compile, or what their axiom reports say. Nothing was built, as instructed. "Empty axiom reports, no warnings" rests on the implementers' scratch builds.
- That `Prod.ext` or another core lemma is axiom-free at `W × Nat` (L6).
- DESIGN.md section C, beyond the parts on placement, and every map file except the lines grepped for the laws named here. Hits outside `P/` and `tmp/r7/tt/map/` were not searched (for example `tmp/r7/the-loop/`, the held attempt).
- Whether `Law.unending_iff_steps` at `E' x y := can x ∧ E x y` closes `stepWhile_unending_rel_iff` with no added transport lemma. I argued above that `«不穷»` depends only on `«续» R E`. I did not look for an existing transport law (`«续»` equal implies `«不穷»` equal), and transporting `«相续»` both ways by `«及之单调»` may cost a few lines.
- Every arithmetic step in `regime_levels`, `regime_step_eq` and `Three`. Only shapes were compared.
- The six GrammarPath dependents (`GrammarCases`, `OwnClass`, `RoutesToC`, `PremiseWitnesses`, `FromTheDynamics`, `PremisesTogether`): whether they still compile against the new GrammarPath.
