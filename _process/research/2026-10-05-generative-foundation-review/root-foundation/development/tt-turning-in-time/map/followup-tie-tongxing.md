Kept as written; local paths in it point to the session's scratch folder.

AI-written map, 12 November 2026

Follow-up: the tie between «同行» and «至终有常». Read only; nothing built or run.
PKG = experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/

## Inventory

### Grammar.lean (340-380, 523, plus helpers they use)

- Grammar.lean:126 def `def «续» (R E : «际» α) : «际» α := «合» R E` — y continues x under E: R x y and E x y.
- Grammar.lean:135 def `def «有后» (R E : «际» α) (x : α) : Prop := ∃ y, «续» R E x y` — x has an E-alike successor.
- Grammar.lean:141 def `def «亡» (R E : «际» α) (x : α) : Prop := ¬ «有后» R E x` — x ends under E: nothing E-alike follows it (it may still condition something unalike).
- Grammar.lean:340 def `def «有常» (R E : «际» α) : Prop := «则» («而» («逆» E) R) («而» R («逆» E))` — E is constant under R: E˘;R ⊆ R;E˘.
- Grammar.lean:343 theorem `theorem «有常之逐点» (R E : «际» α) : «有常» R E ↔ ∀ u u', E u u' → ∀ v, R u v → ∃ v', R u' v' ∧ E v v'` — no premises: constancy pointwise; whatever an E-mate's next is, this one has an E-alike next.
- Grammar.lean:356 theorem `theorem «有常则续不尽» {R E : «际» α} (h : «有常» R E) {y : α} (hy : «有前» R E y) : «有后» R E y` — under constant E, what continues something is continued.
- Grammar.lean:363 theorem `theorem «有常则相续不尽» {R E : «际» α} (h : «有常» R E) {x y : α} (hxy : «相续» R E x y) : «有后» R E y` — under constant E, a line never ends after its first step.
- Grammar.lean:370 theorem `theorem «有亡之续则不有常» {R E : «际» α} {x y : α} (hxy : «续» R E x y) (hy : «亡» R E y) : ¬ «有常» R E` — a line that ends makes E not constant.
- Grammar.lean:375 def `def «核» (R E : «际» α) : «际» α := fun u u' => ∃ S : «际» α, «则» S E ∧ «则» S («逆» S) ∧ «有常» R S ∧ S u u'` — the core: related by some symmetric constant relation inside E.
- Grammar.lean:380 theorem `theorem «根» (R E : «际» α) : «则» («核» R E) E ∧ «有常» R («核» R E) ∧ «则» («核» R E) («逆» («核» R E)) ∧ ∀ S, «则» S E → «则» S («逆» S) → «有常» R S → «则» S («核» R E)` — no premises: the core is the greatest symmetric constant relation inside E.
- Grammar.lean:401 theorem `theorem «静有常» (R : «际» α) : «有常» R «静»` — identity is constant under every R (used below as the refuting witness).
- Grammar.lean:523 theorem `theorem «亡于核下不变» {R E : «际» α} (hE : «类» E) {y y' : α} (hk : «核» R E y y') (hy : «亡» R E y) : «亡» R E y'` — for a class E, ending is invariant along the core: what the core does not tell apart, ending does not either.

### GrammarLaws.lean 2561-2712 (section Lumping)

- GrammarLaws.lean:1063 def `def «定后» (R : «际» α) : Prop := «则» («而» («逆» R) R) «静»` — the successor is fixed (global).
- 2568 def `def «同行» (R E : «际» α) : Prop := «则» («而» («而» («逆» R) E) R) E` — E goes alike under R: R˘;E;R ⊆ E.
- 2571 theorem `theorem «同行之逐点» {R E : «际» α} : «同行» R E ↔ ∀ x x', E x x' → ∀ y y', R x y → R x' y' → E y y'` — no premises: pointwise form. Note it says nothing where x' has no next (vacuous there).
- 2578 theorem `theorem «有常局定后则同行» {R E : «际» α} (constant : «有常» R E) (fixed : ∀ x x', E x x' → ∀ v w, R x' v → R x' w → v = w) : «同行» R E` — constancy plus a successor fixed where E leads gives going alike.
- 2588 theorem `theorem «有常定后则同行» {R E : «际» α} (constant : «有常» R E) (fixed : «定后» R) : «同行» R E` — global-fixed case of the above.
- 2592 theorem `theorem «有常则可续» {R E : «际» α} (constant : «有常» R E) : ∀ u u' v, E u u' → R u v → ∃ v', R u' v'` — constancy gives a next where E leads from one that has a next.
- 2600 theorem `theorem «同行可续则有常» {R E : «际» α} (alike : «同行» R E) (onward : ∀ u u' v, E u u' → R u v → ∃ v', R u' v') : «有常» R E` — going alike plus that availability gives constancy.
- 2607 theorem `theorem «同行遍后则有常» {R E : «际» α} (alike : «同行» R E) (total : ∀ x, ∃ y, R x y) : «有常» R E` — total-successor case.
- 2612 theorem `theorem «局定后则有常当且仅当同行可续» {R E : «际» α} (fixed : ∀ x x', E x x' → ∀ v w, R x' v → R x' w → v = w) : «有常» R E ↔ «同行» R E ∧ ∀ u u' v, E u u' → R u v → ∃ v', R u' v'` — under local fixed successor, constancy is exactly going alike plus availability.
- 2619 theorem `theorem «同行当且仅当有常» {R E : «际» α} (fixed : «定后» R) (total : ∀ x, ∃ y, R x y) : «同行» R E ↔ «有常» R E` — fixed and total: one.
- 2625 theorem `theorem «类同行遍后则含于核» {R E : «际» α} (hE : «类» E) (alike : «同行» R E) (total : ∀ x, ∃ y, R x y) : «则» E («核» R E)`.
- 2631 theorem `theorem «定后则类之核同行» {R E : «际» α} (hE : «类» E) (fixed : «定后» R) : «类» («核» R E) ∧ «则» («核» R E) E ∧ «同行» R («核» R E)` — with fixed successor the core is a class inside E that goes alike.
- 2637 theorem `theorem «遍后则其内同行之类含于核» {R E : «际» α} (total : ∀ x, ∃ y, R x y) : ∀ S, «类» S → «则» S E → «同行» R S → «则» S («核» R E)`.
- 2643 theorem `theorem «定后遍后则核为其内最粗同行之类» ...` (conjunction of the two above under hE, fixed, total).
- 2652 theorem `theorem «后不定则核可不同行» : ∃ (R E : «际» Nat), R 0 1 ∧ R 0 2 ∧ (∀ x y, E x y ↔ x = y) ∧ «类» E ∧ ¬ «定后» R ∧ «核» R E 0 0 ∧ ¬ «核» R E 1 2 ∧ ¬ «同行» R («核» R E)` — witness: off a fixed successor, the core need not go alike.
- 2669 theorem `«同行之历»`, 2677 `theorem «同行之迭» {R E : «际» α} (alike : «同行» R E) : ∀ (n : Nat) {x x' y y' : α}, E x x' → «迭» R n x y → «迭» R n x' y' → E y y'`, 2684 `theorem «同行于迭» {R E : «际» α} (alike : «同行» R E) (n : Nat) : «同行» («迭» R n) E` — going alike over n steps (this is what the held attempt's `alike_steps` restates).
- 2691 def `«像»`, 2696 `«保之像»`, 2705 theorem `theorem «像定后当且仅当同行» {π : α → κ} {R : «际» α} : «定后» («像» π R) ↔ «同行» R (fun s s' => π s = π s')` — lumping: the image has a fixed successor exactly where sameness under π goes alike.

### GrammarPath.lean 218-270

- 222 def `def «至终有常» (R E : «际» α) : Prop := ∀ u u', E u u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w` — constancy up to the net's end: an E-mate's next is matched, unless this one conditions nothing.
- 226 theorem `theorem «有常则至终有常» {R E : «际» α} (constant : «有常» R E) : «至终有常» R E`.
- 235 def `def «本类至终有常» (R E : «际» α) (m : α) : Prop := ∀ u u', E m u → E m u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w` — the same asked at m's block only.
- 239 theorem `theorem «至终有常则本类至终有常» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) (m : α) : «本类至终有常» R E m`.
- 246 theorem `theorem «至终有常之逐类» {R E : «际» α} (hE : «类» E) : «至终有常» R E ↔ ∀ m, «本类至终有常» R E m`.
- 253 theorem `theorem «亡而网续则不至终有常» {R E : «际» α} {x y : α} (hxy : «续» R E x y) (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ «至终有常» R E` — a line ending at an occurrence that still conditions something refutes constancy-to-end; E any relation.
- 264 theorem `theorem «亡而网续则本类不至终有常» {R E : «际» α} {m x y : α} (mx : E m x) (my : E m y) (hxy : «续» R E x y) (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ «本类至终有常» R E m` — same at m's class.
(214 `«亡而网续则后不皆续»` just before the range: such a line also leaves the reach unclosed.)

## Answer to the question

No. No theorem in PKG relates «同行» and «至终有常» (grep over all .lean files: no line names both; «至终有常» appears only in GrammarPath, OwnClass, RoutesToC, FromTheDynamics, never with «同行»). The tie exists only through «有常»: «有常则至终有常» on one side and «有常局定后则同行» / «同行可续则有常» on the other.

Placement: GrammarPath imports GrammarCrossing, which imports GrammarLaws, so «同行» is in scope in GrammarPath; the ties fit after line 227. Candidate names below were grepped and are unused.

Direction 1 (至终有常 plus local fixed successor gives 同行), axiom-free. Proof: given E x x', R x y, R x' y', apply 至终有常 at (x, x', y); the left case gives v' with R x' v', E y v', and fixed gives v' = y'; the right case contradicts R x' y'.

    theorem «至终有常局定后则同行» {R E : «际» α} (constant : «至终有常» R E)
        (fixed : ∀ x x', E x x' → ∀ v w, R x' v → R x' w → v = w) : «同行» R E

Direction 2 (同行 plus successor existence decided gives 至终有常), axiom-free. Proof: given E u u', R u v, case on decided; left gives v' and «同行之逐点» gives E v v'; right is the right disjunct.

    theorem «同行可决则至终有常» {R E : «际» α} (alike : «同行» R E)
        (decided : ∀ u u' v, E u u' → R u v → (∃ v', R u' v') ∨ ∀ w, ¬ R u' w) : «至终有常» R E

`decided` is necessary, as `onward` is for «同行可续则有常»: «至终有常» itself gives it (each disjunct projects), so the exact tie is

    theorem «至终有常则可决» {R E : «际» α} (constant : «至终有常» R E) :
        ∀ u u' v, E u u' → R u v → (∃ v', R u' v') ∨ ∀ w, ¬ R u' w
    theorem «局定后则至终有常当且仅当同行可决» {R E : «际» α}
        (fixed : ∀ x x', E x x' → ∀ v w, R x' v → R x' w → v = w) :
        «至终有常» R E ↔ «同行» R E ∧ ∀ u u' v, E u u' → R u v → (∃ v', R u' v') ∨ ∀ w, ¬ R u' w

and, joining availability, the bridge from 至终有常 to 有常 (right disjunct refuted by onward):

    theorem «至终有常可续则有常» {R E : «际» α} (constant : «至终有常» R E)
        (onward : ∀ u u' v, E u u' → R u v → ∃ v', R u' v') : «有常» R E
    -- with «有常则至终有常» and «有常则可续»:
    -- «有常» R E ↔ «至终有常» R E ∧ ∀ u u' v, E u u' → R u v → ∃ v', R u' v'   (no premises)

Which existing laws become cases:
- «有常局定后则同行» = «至终有常局定后则同行» («有常则至终有常» constant) fixed. «有常定后则同行» follows as now.
- «同行可续则有常» = «至终有常可续则有常» («同行可决则至终有常» alike (onward gives the left disjunct)) onward.
- «局定后则有常当且仅当同行可续» = the 至终有常 iff above composed with the no-premise 有常 ↔ 至终有常 ∧ 可续.
- «有常则至终有常» is NOT a case of direction 2 (it has no «同行» premise and holds without a fixed successor); it is a premise-free law that direction 1 composes with. It is the left-to-right half of the 有常 ↔ 至终有常 ∧ 可续 factorization.

Reading: under a fixed successor, «同行» is exactly «至终有常» with the "end" made decidable; the difference between going alike and constancy (the question at (b)-(c)) is then wholly 可续 versus 可决, i.e. whether the alike occurrence has a next.

## Cautions

- The fixed premise in direction 1 cannot be dropped: R 0 1, R 0 2, E = «静». «静有常» gives «有常» R «静», hence «至终有常», but «同行» R «静» would force 1 = 2. (Same witness as «后不定则核可不同行».)
- `decided` is a hypothesis, not a theorem: with Classical.em it is free, but the grammar files state empty axiom reports (GrammarPath.lean:110, GrammarLaws.lean:221), so it must stay a premise. A weaker sufficient form is the global `∀ x, (∃ w, R x w) ∨ ∀ w, ¬ R x w`; the localized form is the necessary one.
- «同行» is vacuous where x' has no R-successor; «至终有常» also says nothing there (right disjunct). Neither mentions «亡» (no E-alike next) directly; «亡而网续则不至终有常» is where 亡 with a further R-step enters. A restatement of "the line ends while something follows" should use that law, not re-derive it.
- The held attempt (tmp/r7/the-loop/lean/Becoming/TurningInTime.lean): `alike_steps` (137) restates «同行之迭» (GrammarLaws 2677); `not_constant` (131) is a case of «亡而网续则不至终有常» / «有亡之续则不有常»-style laws; `core_apart` (126) is close to «亡于核下不变» (Grammar 523) in its contrapositive form; `goesAlike_iff` (318) and `constant_iff` (355) are model-specific. The reader report already lists these.
- «至终有常» takes any relation E; several neighbours (239, 246) need «类» E. Directions 1 and 2 above need no «类».

## Not read or not settled

- Lines of GrammarPath beyond 275 and OwnClass/RoutesToC/FromTheDynamics uses of «本类至终有常» were only grepped; per-class (本类) forms of the two directions (with E m u, E m u') were not checked but go through by the same proofs.
- The proofs above were not compiled (read-only task); each is a few lines of match/cases on the existing pointwise laws, with no simp.
