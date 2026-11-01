# Held until BD2 lands

The grammar's owner has three items that join OU7's rebuild once BD2 (`Becoming.GrammarCrossing`) is on main. Each becomes a patch in [owner/](owner/), written against that main and named to sort after `01-`. Each changes code, so each also adds two things:
- its expectation to `EXPECTED` in [integrate_ou7.py](../integrate_ou7.py);
- its reason to [repoint_reason.txt](../repoint_reason.txt).

Nothing here is applied yet. The apply stage reads only `owner/*.patch`.

1. **`«不出»` into GrammarLaws.** It moves from GrammarCrossing, with `«所闭之界»` and `«所闭不出»` stated once.
2. **`Flow.Cut`.** In Standpoints it becomes `«不出» V.related region`. `Flow.cut_iff_notGoingOut` is kept.
3. **A region not crossed, read two ways.** Two equivalences, stated as BD2 sent them on 1 November. They go in GrammarLaws beside the moved `«不出»`, after `GrammarLaws.uncrossed_of_closed`.
   - `«对则不越域守数»` and `«对则双闭域守数»` keep their statements and names.
   - Their docstrings say they read as one law on regions not gone out of either way.
   - master-laws-on-the-grammar's prose says the same. That changes a record, so it takes a history note.

## Item 3's text

```lean
/-- **A region the relation does not cross is one not gone out of either way.** Related units lie
both in a region read as a test or both outside it exactly where nothing in it bears the relation to
something outside it and nothing outside it bears the relation to something in it. -/
theorem GrammarLaws.uncrossed_iff_notGoingOut {R : «际» α} {p : α → Bool} :
    (∀ x y, R x y → p x = p y) ↔
      «不出» R (fun x => p x = true) ∧ «不出» («逆» R) (fun x => p x = true) :=
  ⟨fun uncrossed =>
    ⟨fun x y inside outside related => outside ((uncrossed x y related).symm.trans inside),
     fun x y inside outside related => outside ((uncrossed y x related).trans inside)⟩,
   fun ⟨forward, backward⟩ x y related => by
    cases hx : p x <;> cases hy : p y
    · rfl
    · exact (backward y x hy (fun inside => Bool.noConfusion (hx.symm.trans inside)) related).elim
    · exact (forward x y hx (fun inside => Bool.noConfusion (hy.symm.trans inside)) related).elim
    · rfl⟩

/-- **A region the relation does not cross is one closed under it and under its converse.** The
converse of `GrammarLaws.uncrossed_of_closed`. -/
theorem GrammarLaws.uncrossed_iff_closed {R : «际» α} {p : α → Bool} :
    (∀ x y, R x y → p x = p y) ↔
      «闭» R (fun x => p x = true) ∧ «闭» («逆» R) (fun x => p x = true) :=
  ⟨fun uncrossed =>
    ⟨fun x y inside related => (uncrossed x y related).symm.trans inside,
     fun x y inside related => (uncrossed y x related).trans inside⟩,
   fun ⟨forward, backward⟩ => GrammarLaws.uncrossed_of_closed forward backward⟩
```

**Checked by BD2.** BD2 ran `scratch_build.py` on its checkout (`bd2-crossing` at 7647ea36e), with the two theorems in a scratch module `Becoming.UncrossedScratch` that imports `Becoming.GrammarCrossing`:
- 2 theorems in 2 declarations;
- every axiom report empty, and no warning;
- 5 steps reused.

The proofs use only case analysis on `Bool`, with no `simp` or `rw`. In GrammarLaws they need two things: `«不出»`, which item 1 moves there, and `GrammarLaws.uncrossed_of_closed`, which is already there. The kit's rehearsal builds them in place.
