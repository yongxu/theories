# The leaf's second review, and what was taken

Two independent AI skeptics read the revised leaf (`tree/Becoming/PremiseWitnesses.lean`, 22 declarations, 1 November 2026). Together they gave nine findings: seven major and two minor. Several overlap: 1 with 9, 2 with 7, and 3 with 8. All nine are taken, three of them in part. The leaf now has 31 declarations: 29 theorems and 2 definitions. Every axiom report is empty. A third look revised the link to C and the direction's summary; see "Third look (1 November 2026)" at the end (37 declarations, 35 theorems).

Build: `python3 -B scratch_build.py <du-deep-unification-review/tree> Becoming.PremiseWitnesses` gives `"unclean": []` (no error or warning), `"theorems": 29`, `"declarations": 31` and `"with_axioms": {}`. It reused 114 modules and ran the leaf and its audit.

## Findings and dispositions

1. **The net witnesses read `R` as 缘, opposite to the direction of `Becoming.Weightings`** (major). In `increasingInOwn_with_net` the net is `step`, which is 缘, so `own` marks what the center conditions. The relations of `Weightings` (feeding, influence) run converse to 缘. Read that way, the endless line fails `«续无外»` from every center. *Taken.*
   - Docstrings: the docstring of `increasingInOwn_with_net` now says that `R` is 缘 and that the marking marks what the center conditions. The module has a new bullet, "The direction".
   - The pair the skeptic proposed, read in the `Weightings` direction, is proved in the core with `match` and `Nat` lemmas (no `simp`, no `omega`):
     - `LineOfDescent.Last.converse_no_outside`: along `«逆» step`, the last occurrence reaches all four occurrences.
     - `LineOfDescent.Endless.step_member_le`, `converse_line_le` and `converse_later_outside`: 缘 never lowers the member, so along the converse a line under any relation never reaches the next member's birth.
     - `LineOfDescent.Endless.converse_outside`: the condition fails from every center.
     - `«逆缘续无外随网»`: the pair.
     - `increasingInOwn_with_net_converse`: self-concern and being increasing in admission coincide on the first net and part on the second.
   - The module now says that the condition varies with the direction as well as with the net and the class. The endless line meets it along 缘 from its first birth, and along the converse from no center. (Revised at the third look, finding 4: the earlier wording compared one center along 缘 with every center along the converse.)
   - The failure on two family lines along the converse is not stated. It follows as the failure along 缘 does, since every step keeps the family, and it adds nothing to the pair.

2. **The step from `Weighting.Increasing` to C is not proved** (major). The leaf cited `Web.paths_extension_iff_widens`, which concerns `Web.Widens`, not `WidensOn` on a listing. The bridge on listings, `Web.widens_iff_every_weighting` / `Web.widens_iff_every_of_class`, needs `DecidesAdmission` and `ListsAdmitted` and lives on `Nat × F`. *Taken, by proving the bridge one way.*
   - `Web.extension_ranked_of_increasing`: with admission decided and what both level paths admit listed, an order increasing in admission ranks every extension with every claim counted as living.
   - *Revised at the third look (finding 1 there).* This revision proved `Web.comparison_of_increasingInOwn`, a `Comparison` on all of a web's level paths under the hypothesis that every level path's admissions are listed. That hypothesis holds of no web with a formation, and with none there is no extension, so the theorem was vacuous; its gloss ("only finitely many pairs can be admitted") was wrong. It is replaced by the pairwise `Web.extension_ranked_of_increasingInOwn`: with the de se condition, the marking lifted to items by `fun i => own i.2`, and admission decided, an order increasing in that own continuation ranks every extension between two level paths whose admissions are listed. The link to C holds between listed paths only, and listed paths are paths whose admissions end.
   - The other half is not proved on webs: self-concern failing C where the condition fails. Its witness courses (`fun y => !own y` and `fun _ => false`) would need level paths that admit them, and a web need not have them. The module doc says so: that half is proved on listings only.

3. **The join to the root uses no property of `«所及»` or `«续无外»`** (major). *Taken.*
   - The schema is stated once as `Weighting.increasingInOwn_iff_increasing_iff_all`, for any relation `Q : Pos → α → Prop` that the marking reads.
   - `increasingInOwn_iff_increasing_iff_noOutside` is now that schema at `Q p := «所及» R E (center p)`. Its proof is the schema applied to `reads`.
   - The docstrings and the bullet say: "Nothing about `Q` is used", "The root supplies only what the marking reads", and that the join "proves no property of reach".

4. **`increasingInOwn_with_net_marked` mentions no net** (major). Its conjuncts hold on any carrier, by `increasingInOwn_iff_increasing` and `exists_increasingInOwn_not_increasing`. *Taken: the theorem is dropped.*
   - `increasingInOwn_with_net` and the reach lemmas already say what it said. Its docstring names the exact readings that exist: `fun _ => true` by `descent_reaches`, and `fun x => x.1` by `TwoLines.first_line_reach_iff`.
   - The module doc no longer cites the dropped theorem.

5. **The hypotheses are stronger than the proofs need** (minor). *Taken.*
   - `increasingInOwn_iff_increasing_of_noOutside` takes `marks : ∀ x, «所及» R E (center p) x → own x = true`.
   - `exists_increasingInOwn_not_increasing_of_outside` takes `within : ∀ x, own x = true → «所及» R E (center p) x`.
   - `increasingInOwn_iff_increasing_of_unrestricted` takes `marks : ∀ x, WithinClosure rel (center p) x → own x = true`.
   - The conjuncts of both net theorems change the same way.
   - The iff stays only where both directions are used: `_iff_all`, `_iff_noOutside` and `_iff_unrestricted`. Each docstring says "only that half of a reading is used".

6. **`ReadsNoOrder.not_entails` assumes `entails` at every datum** (minor). *Taken.*
   - `entails : ∀ better, law d better → Comparison frame living better` now holds at the one datum `d`, so the theorem is stronger.
   - Since `entails` is assumed only at `d`, the frame and `living` are fixed rather than functions of the datum.
   - Its title reads "A statement reading no order fails, for every order, at a datum where it entails C on a frame with an extension".

7. **The docstrings treat `Weighting.Increasing` as C** (major; overlaps 2). *Taken.*
   - The bullet, the section heading and the titles now say "being increasing in admission (`Weighting.Increasing`)". They no longer say "C" for that order.
   - The title "C on any listing asks nothing beyond self-concern" is now "self-concern is being increasing in admission on any listing".
   - C appears only where `Comparison` is proved (`Web.comparison_of_increasingInOwn`) and in the closing reading, which states its conditions.
   - The header now reads "joins self-concern to the condition on the root, and joins it, one way, to C on a web's level paths".

8. **The join is near-definitional, and the leaf did not say so** (major; overlaps 3). *Taken.*
   - The docstring of `increasingInOwn_iff_increasing_iff_noOutside` says "Near-definitional": its content is the witness `exists_increasingInOwn_not_increasing`, and its "if" half is `increasingInOwn_iff_increasing`.
   - The de se theorem is labeled "A composition of existing equivalences".
   - The bullet says "The join is near-definitional".

9. **The witnesses on the net take `R = step`, which is 缘** (major). The finding's text was cut off in the brief: "…so `own` marks what the first birth c". As far as it is legible it is finding 1 from the other skeptic. *Taken with finding 1.*

## Final names and statements

Unchanged from the first revision: `TwoLines.other_center_outside`, `ThirdThing.first_member_outside`, `«续无外随网»`, `«族无外随网»`, `ReadsNoOrder`, `LiftModel.met_and_failed`, `Weighting.WidensByOne`, `Weighting.reach_of_beyond`, `Weighting.widensOn_iff_reach`, `Weighting.increasing_iff_by_one`, `Weighting.exists_increasingInOwn_not_increasing`, `Weighting.increasingInOwn_iff_increasing_iff_marks`, `TwoLines.first_line_reaches_both` and `TwoLines.first_line_reach_iff`.

Changed or new:

```lean
theorem ReadsNoOrder.not_entails {D} {law : D → (S → S → Prop) → Prop} (reads : ReadsNoOrder law)
    {frame : Frame S A C} {living : C → Prop} {d : D}
    (entails : ∀ better, law d better → Comparison frame living better)
    {s t : S} (extension : Extension frame living s t) {better : S → S → Prop} : ¬ law d better

theorem Weighting.increasingInOwn_iff_increasing_iff_all {α Pos} {Q : Pos → α → Prop}
    {own : Pos → α → Bool} (reads : ∀ p x, own p x = true ↔ Q p x) :
    (∀ p items O, IncreasingInOwn items (own p) O ↔ Increasing items O) ↔ ∀ p x, Q p x

theorem Weighting.increasingInOwn_iff_increasing_of_noOutside {R E : «际» α} {center : Pos → α}
    (none : «续无外» R E center) {p : Pos} {own : α → Bool}
    (marks : ∀ x, «所及» R E (center p) x → own x = true) (items : List α) (O) :
    IncreasingInOwn items own O ↔ Increasing items O

theorem Weighting.exists_increasingInOwn_not_increasing_of_outside {R E : «际» α} {center : Pos → α}
    {p : Pos} {own : α → Bool} (within : ∀ x, own x = true → «所及» R E (center p) x)
    {items : List α} {x : α} (listed : x ∈ items) (outside : ¬ «所及» R E (center p) x) :
    ∃ O, IncreasingInOwn items own O ∧ ¬ Increasing items O

theorem Weighting.increasingInOwn_iff_increasing_iff_noOutside {R E : «际» α} {center : Pos → α}
    {own : Pos → α → Bool} (reads : ∀ p x, own p x = true ↔ «所及» R E (center p) x) :
    (∀ p items O, IncreasingInOwn items (own p) O ↔ Increasing items O) ↔ «续无外» R E center

theorem Weighting.increasingInOwn_iff_increasing_iff_unrestricted {rel : F → F → Prop}
    {center : Pos → F} {own : Pos → F → Bool}
    (reads : ∀ p x, own p x = true ↔ WithinClosure rel (center p) x) :
    (∀ p items O, IncreasingInOwn items (own p) O ↔ Increasing items O) ↔
      Unrestricted (selfAscribed (ownClosure rel) center)

theorem Weighting.increasingInOwn_iff_increasing_of_unrestricted {rel : F → F → Prop}
    {center : Pos → F} (unrestricted : Unrestricted (selfAscribed (ownClosure rel) center))
    {p : Pos} {own : F → Bool} (marks : ∀ x, WithinClosure rel (center p) x → own x = true)
    (items : List F) (O) : IncreasingInOwn items own O ↔ Increasing items O

theorem Web.extension_ranked_of_increasing {W : Web F C}
    {admitted : (Nat → C → Nat) → Nat × F → Bool} (decides : W.DecidesAdmission admitted)
    {items : List (Nat × F)} {O} (increasing : Weighting.Increasing items O) {l l'}
    (listed : W.ListsAdmitted items l) (listed' : W.ListsAdmitted items l')
    (extension : Extension W.paths (fun _ => True) l' l) : O (admitted l') (admitted l)

-- Replaced at the third look by Web.extension_ranked_of_increasingInOwn (vacuous: see there).
theorem Web.comparison_of_increasingInOwn {W : Web F C} {Pos} {rel : F → F → Prop}
    {center : Pos → F} (unrestricted : Unrestricted (selfAscribed (ownClosure rel) center))
    {p : Pos} {own : F → Bool} (marks : ∀ f, WithinClosure rel (center p) f → own f = true)
    {admitted} (decides : W.DecidesAdmission admitted) {items : List (Nat × F)}
    (listed : ∀ l, W.ListsAdmitted items l) {O}
    (concerned : Weighting.IncreasingInOwn items (fun i => own i.2) O) :
    Comparison W.paths (fun _ => True) fun l' l => O (admitted l') (admitted l)

theorem LineOfDescent.Last.converse_no_outside :
    «续无外» («逆» step) «一» (fun (_ : Unit) => ((true, true) : Occ))
theorem LineOfDescent.Endless.step_member_le {x y : Occ} (h : step x y) : x.1 ≤ y.1
theorem LineOfDescent.Endless.converse_line_le {E : «际» Occ} {c x : Occ}
    (line : «相续» («逆» step) E c x) : x.1 ≤ c.1
theorem LineOfDescent.Endless.converse_later_outside (c : Occ) :
    ¬ «所及» («逆» step) «一» c (c.1 + 1, false)
theorem LineOfDescent.Endless.converse_outside (c : Occ) :
    ¬ «续无外» («逆» step) «一» (fun (_ : Unit) => c)

theorem «逆缘续无外随网» :
    «续无外» («逆» LineOfDescent.Last.step) «一» (fun (_ : Unit) => ((true, true) : LineOfDescent.Last.Occ)) ∧
      ∀ c : LineOfDescent.Endless.Occ,
        ¬ «续无外» («逆» LineOfDescent.Endless.step) «一» (fun (_ : Unit) => c)

theorem increasingInOwn_with_net :
    (∀ own : LineOfDescent.Endless.Occ → Bool,
      (∀ x, «所及» LineOfDescent.Endless.step «一» (0, false) x → own x = true) →
        ∀ items O, Weighting.IncreasingInOwn items own O ↔ Weighting.Increasing items O) ∧
      ∀ own : TwoLines.Occ → Bool,
        (∀ x, own x = true → «所及» TwoLines.step «一» (true, 0, false) x) →
          ∀ items, ((false, 0, false) : TwoLines.Occ) ∈ items →
            ∃ O, Weighting.IncreasingInOwn items own O ∧ ¬ Weighting.Increasing items O

theorem increasingInOwn_with_net_converse :
    (∀ own : LineOfDescent.Last.Occ → Bool,
      (∀ x, «所及» («逆» LineOfDescent.Last.step) «一» (true, true) x → own x = true) →
        ∀ items O, Weighting.IncreasingInOwn items own O ↔ Weighting.Increasing items O) ∧
      ∀ (c : LineOfDescent.Endless.Occ) (own : LineOfDescent.Endless.Occ → Bool),
        (∀ x, own x = true → «所及» («逆» LineOfDescent.Endless.step) «一» c x) →
          ∀ items, ((c.1 + 1, false) : LineOfDescent.Endless.Occ) ∈ items →
            ∃ O, Weighting.IncreasingInOwn items own O ∧ ¬ Weighting.Increasing items O
```

Dropped: `increasingInOwn_with_net_marked` (finding 4).

## What changes for the texts

Wherever DU's texts summarize this leaf, they should say the following:

- Self-concern and being increasing in admission coincide where the condition on the root holds, read in the marking's direction.
- The join is near-definitional.
- The condition varies with the net, the class and the direction. The endless line meets it along 缘 from its first birth, and along the converse from no center. *(Revised at the third look.)*
- The link to C is proved one way only, and only between two level paths whose admissions are listed, with admission decided: such paths admit nothing from some step on, so the link covers courses whose admissions end. C on all of a web's level paths does not follow this way. *(Revised at the third look.)*

## Third look (1 November 2026)

A fresh AI skeptic read the leaf as revised above (31 declarations). It gave four findings: one blocking, two major and one minor. All four hold and all four are taken. Of the blocking finding's options, (a) and (c) are taken together; (b), a frame of the listed level paths, is not, since the pairwise statement says the same without a new definition. Of the second finding's options, the docstring note is taken; the alternative, a bridge at a finite horizon, is not, since the note states the restriction exactly and the horizon version would be a further result, not a correction.

1. **`Web.comparison_of_increasingInOwn` is vacuous on every web** (blocking). Its hypothesis `listed : ∀ l, W.ListsAdmitted items l` holds of no web with a formation: the level path set at a formation's needs admits it at any step, so every (step, formation) pair would be listed, and none is listed beyond the bound of the listed steps. With no formation there is no extension. The docstring's gloss, that the hypothesis "asks that only finitely many (step, formation) pairs can be admitted", was false. The skeptic checked this in a scratch probe. *Taken, options (a) and (c).*
   - The theorem is replaced by `Web.extension_ranked_of_increasingInOwn`, which is pairwise. With admission decided and what `l` and `l'` admit listed, an extension from `l'` to `l` is ranked by every order increasing in the own continuation. The proof is `Web.extension_ranked_of_increasing` composed with `Weighting.increasingInOwn_iff_increasing`.
   - The vacuity is proved in the leaf:
     - `Web.admits_need`: the levels set at a formation's needs admit it.
     - `Web.not_listsAdmitted_every`: once there is a formation, no list holds what every level path admits. It uses `Web.lt_stepBound` of `Becoming.EventualWideningInstances`, which the leaf now imports.
     - `Web.no_extension_of_listsAdmitted_every`: where every level path's admissions are listed, no level path extends another, for every reading of `living`.
   - The module header, the bullet (now "To C between listed level paths, one way"), the section heading, the closing reading and disposition 2 above now say that the link to C holds between listed paths only, and that C on all of a web's level paths does not follow this way.

2. **Listing confines the result to courses whose admissions end, unstated** (major). `ListsAdmitted items l` puts every admitted step below the bound of the listed steps. *Taken.*
   - New: `Web.admits_nothing_from_of_listed`. A level path whose admissions are listed admits nothing from `Web.stepBound items` on.
   - The docstrings of both rankings and the bullet now say that listing holds only where a path admits nothing from some step on (citing that law and `Web.not_eventually_of_listed`). So the link covers courses whose admissions end, never one that admits something at every step.

3. **The closing reading equated being increasing in admission with what C asks** (major). *Taken.*
   - The closing reading now says that being increasing in admission (`Weighting.Increasing`) ranks every extension between two level paths whose admissions are listed (`Web.extension_ranked_of_increasing`). It no longer calls it "the order C asks".
   - The final clause now reads: where the de se condition holds and admission is decided, self-concern ranks every extension between two listed level paths, paths whose admissions end. The clause "self-concern meets C" is dropped.
   - The closing reading also says that the converse is not proved: C on level paths does not make an order increasing in admission on a listing, since a course on a listing need not be what any level path admits.

4. **"Meets the condition along 缘 and fails it along the converse" compared one center with every center** (minor). *Taken, with the optional witness.*
   - New:
     - `LineOfDescent.Endless.line_member_le`: along 缘 a line never reaches an earlier member.
     - `LineOfDescent.Endless.later_outside`: along 缘 the condition fails from every occurrence of a later member (`0 < c.1`).
   - The bullet "The direction" now reads: the endless line meets the condition along 缘 from its first birth, and along the converse from no center; along 缘 it fails from every later member's occurrences too.
   - The docstrings of `converse_outside` and `increasingInOwn_with_net_converse` say the same.

Placement at the modules' next change: the three laws on what a listing holds go to `Becoming.EventualWideningInstances` after `Web.not_eventually_of_listed`, since `Web.stepBound` lives there. The two rankings go to `Becoming.Weightings` after `Web.widens_iff_every_of_class`, and the two witnesses on the line of descent go beside `LineOfDescent` in `Becoming.GrammarScope`. `Web.admits_need` needs only `Becoming.Admission`, but it is placed with the laws it serves.

Build: `python3 -B scratch_build.py <du-deep-unification-review/tree> Becoming.PremiseWitnesses` gives `"unclean": []`, `"theorems": 35`, `"declarations": 37` and `"with_axioms": {}` (120 modules: 119 reused, the leaf and its audit run; output in `tree-build.json`). Counts: one theorem dropped (`Web.comparison_of_increasingInOwn`) and seven added (`Web.admits_need`, `Web.admits_nothing_from_of_listed`, `Web.not_listsAdmitted_every`, `Web.no_extension_of_listsAdmitted_every`, `Web.extension_ranked_of_increasingInOwn`, `LineOfDescent.Endless.line_member_le`, `LineOfDescent.Endless.later_outside`), so 29 − 1 + 7 = 35 theorems and 2 definitions.

New statements:

```lean
theorem Web.admits_need (W : Web F C) (t : Nat) (f : F) : W.Admits (fun c => W.need t f c) t f

theorem Web.admits_nothing_from_of_listed {items : List (Nat × F)} {l : Nat → C → Nat}
    (listed : W.ListsAdmitted items l) {t : Nat} (from_ : Web.stepBound items ≤ t) (f : F) :
    ¬ W.Admits (l t) t f

theorem Web.not_listsAdmitted_every (W : Web F C) (f : F) {items : List (Nat × F)} :
    ¬ ∀ l, W.ListsAdmitted items l

theorem Web.no_extension_of_listsAdmitted_every {items : List (Nat × F)}
    (listed : ∀ l, W.ListsAdmitted items l) {living : F × Nat → Prop} {l l' : Nat → C → Nat} :
    ¬ Extension W.paths living l' l

theorem Web.extension_ranked_of_increasingInOwn {Pos : Type} {rel : F → F → Prop}
    {center : Pos → F} (unrestricted : Unrestricted (selfAscribed (ownClosure rel) center))
    {p : Pos} {own : F → Bool} (marks : ∀ f, WithinClosure rel (center p) f → own f = true)
    {admitted : (Nat → C → Nat) → Nat × F → Bool} (decides : W.DecidesAdmission admitted)
    {items : List (Nat × F)} {O : (Nat × F → Bool) → (Nat × F → Bool) → Prop}
    (concerned : Weighting.IncreasingInOwn items (fun i => own i.2) O)
    {l l' : Nat → C → Nat} (listed : W.ListsAdmitted items l) (listed' : W.ListsAdmitted items l')
    (extension : Extension W.paths (fun _ => True) l' l) : O (admitted l') (admitted l)

theorem LineOfDescent.Endless.line_member_le {E : «际» Occ} {c x : Occ}
    (line : «相续» step E c x) : c.1 ≤ x.1

theorem LineOfDescent.Endless.later_outside (c : Occ) (later : 0 < c.1) :
    ¬ «续无外» step «一» (fun (_ : Unit) => c)
```

For the texts: wherever DU's texts summarize this leaf, the two revised lines under "What changes for the texts" above hold. The link to C runs one way, between two listed level paths, which are courses whose admissions end. The endless line meets the condition along 缘 from its first birth only.
