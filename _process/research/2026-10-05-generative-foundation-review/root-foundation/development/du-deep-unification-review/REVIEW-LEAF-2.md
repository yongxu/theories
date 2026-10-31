# The leaf's second review, and what was taken

Two independent AI skeptics read the revised leaf (`tree/Becoming/PremiseWitnesses.lean`, 22 declarations, 1 November 2026). Together they gave nine findings: seven major and two minor. Several overlap: 1 with 9, 2 with 7, and 3 with 8. All nine are taken, three of them in part. The leaf now has 31 declarations: 29 theorems and 2 definitions. Every axiom report is empty.

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
   - The module now says that the condition varies with the direction as well as with the net and the class. The endless line meets it along 缘 and fails it along the converse.
   - The failure on two family lines along the converse is not stated. It follows as the failure along 缘 does, since every step keeps the family, and it adds nothing to the pair.

2. **The step from `Weighting.Increasing` to C is not proved** (major). The leaf cited `Web.paths_extension_iff_widens`, which concerns `Web.Widens`, not `WidensOn` on a listing. The bridge on listings, `Web.widens_iff_every_weighting` / `Web.widens_iff_every_of_class`, needs `DecidesAdmission` and `ListsAdmitted` and lives on `Nat × F`. *Taken, by proving the bridge one way.*
   - `Web.extension_ranked_of_increasing`: with admission decided and what both level paths admit listed, an order increasing in admission ranks every extension with every claim counted as living.
   - `Web.comparison_of_increasingInOwn`: assume the de se condition holds, the marking on `F` is lifted to items by `fun i => own i.2`, admission is decided, and every level path's admissions are listed. Then every order increasing in that own continuation, read through admission, meets C (`Comparison W.paths (fun _ => True) …`). Its docstring says that the listing hypothesis asks that only finitely many (step, formation) pairs can be admitted, and that the first theorem needs it only of the two paths compared.
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
- The condition varies with the net, the class and the direction. The endless line meets it along 缘 and fails it along the converse.
- The link to C is proved one way only: on level paths, with admission decided and listed.
