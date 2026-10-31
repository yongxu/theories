/-! Scratch (amounts-and-world review): the attribution half of balance on an occurrence model.
Init only. Not part of the package. -/

namespace AmountsScratch

def total {α : Type} : List α → (α → Nat) → Nat
  | [], _ => 0
  | a :: as, q => q a + total as q

/-- the number of arrivals `arr` that `src` attributes to `f` -/
def attributed {α F : Type} [DecidableEq F] (src : α → Option F) (arr : List α) (f : F) : Nat :=
  total arr fun y => if src y = some f then 1 else 0

theorem total_add {α : Type} (p q : α → Nat) : ∀ as : List α,
    total as (fun a => p a + q a) = total as p + total as q
  | [] => rfl
  | a :: as => by simp only [total, total_add p q as]; omega

theorem total_ind_absent {F : Type} [DecidableEq F] (f0 : F) :
    ∀ (ps : List F), f0 ∉ ps → total ps (fun f => if f0 = f then 1 else 0) = 0
  | [], _ => rfl
  | q :: qs, nm => by
    have hq : f0 ≠ q := fun e => nm (e ▸ List.mem_cons_self ..)
    have rest := total_ind_absent f0 qs (fun mm => nm (List.mem_cons_of_mem _ mm))
    simp only [total, hq, ite_false, rest]

theorem total_ind_unique {F : Type} [DecidableEq F] (f0 : F) :
    ∀ (ps : List F), f0 ∈ ps → ps.Nodup → total ps (fun f => if f0 = f then 1 else 0) = 1
  | [], m, _ => nomatch m
  | p :: ps, m, nd => by
    have nd' := List.nodup_cons.mp nd
    by_cases h : f0 = p
    · subst h
      simp only [total, ite_true, total_ind_absent f0 ps nd'.1]
    · have m' : f0 ∈ ps := by
        cases List.mem_cons.mp m with
        | inl e => exact absurd e h
        | inr mm => exact mm
      simp only [total, h, ite_false, total_ind_unique f0 ps m' nd'.2]

/-- **Attribution total and functional gives the count.** Every arrival attributed to exactly one
present formation (a function `src`, so at most one; covering, so at least one), the present listed
without repetition: what the present formations give totals the arrivals. -/
theorem given_eq_arrivals {α F : Type} [DecidableEq F] (src : α → Option F) (present : List F)
    (nd : present.Nodup) : ∀ (arr : List α), (∀ y, y ∈ arr → ∃ f, f ∈ present ∧ src y = some f) →
    total present (attributed src arr) = arr.length
  | [], _ => by
      show total present (fun _ => 0) = 0
      clear nd
      induction present with
      | nil => rfl
      | cons _ _ ih => simp only [total]; exact (Nat.zero_add _).trans (ih (fun _ m => nomatch m))
  | y :: arr, cov => by
    obtain ⟨f0, m0, e0⟩ := cov y (List.mem_cons_self ..)
    have step : ∀ f, attributed src (y :: arr) f = (if f0 = f then 1 else 0) + attributed src arr f := by
      intro f
      show (if src y = some f then 1 else 0) + _ = _
      rw [e0]
      by_cases h : f0 = f
      · subst h; simp only [ite_true]; rfl
      · have h' : ¬ (some f0 = some f) := fun e => h (Option.some.inj e)
        simp only [h, h', ite_false]; rfl
    have rest := given_eq_arrivals src present nd arr (fun z mz => cov z (List.mem_cons_of_mem _ mz))
    have congr' : total present (attributed src (y :: arr)) =
        total present (fun f => (if f0 = f then 1 else 0) + attributed src arr f) := by
      clear rest cov m0 nd
      induction present with
      | nil => rfl
      | cons p ps ih => simp only [total, step p, ih]
    rw [congr', total_add, total_ind_unique f0 present m0 nd, rest, List.length_cons]
    omega

/-- **Enclosure cannot be dropped**: one arrival attributed to no present formation. -/
theorem enclosure_needed :
    total ([] : List Unit) (attributed (fun (_ : Unit) => (none : Option Unit)) [()]) ≠ [()].length := by
  decide

/-- **Functional attribution cannot be dropped**: one arrival credited by a relation to both of two
present formations is counted twice (the relation `A f y := True`, read as a giving count). -/
theorem double_counting :
    total [true, false] (fun _ => total [()] (fun _ => 1)) ≠ [()].length := by
  decide

end AmountsScratch
#print axioms AmountsScratch.given_eq_arrivals
#print axioms AmountsScratch.enclosure_needed
#print axioms AmountsScratch.double_counting
