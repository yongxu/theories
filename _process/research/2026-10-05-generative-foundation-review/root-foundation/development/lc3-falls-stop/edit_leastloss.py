"""LC3 edits to Becoming.LeastLoss (kit tree): the one premise of rest, an amount's strict falls stopping
(`Amounts.FallsStop`); amounts with no endless fall (`NoEndlessFall`), a least fall (`FallsAtLeast`), an endless
fall (`EndlessFall`); a least fall in Archimedean amounts leaves no endless fall, whole numbers the instance; dyadic
amounts fall without end with no least fall, layered amounts with one; the finite-reading law restated with the
premise named. usage: python3 -B edit_leastloss.py (from the checkout root)"""
from pathlib import Path
HERE = Path(__file__).resolve().parent
F = HERE / 'tree/Becoming/LeastLoss.lean'
t = F.read_text()

def rep(old, new):
    global t
    assert t.count(old) == 1, (old[:80], t.count(old))
    t = t.replace(old, new)

SECTION = r'''
/-! ## One premise: an amount's strict falls stop -/

namespace Amounts

variable {A : Type} (M : Amounts A)

/-- An amount's strict falls stop from `T` on, as far as can be refuted: it is not the case that
after every step from `T` on a later step across which it falls strictly (is not, after the step,
back within its value before) stays unrefuted. Both rest laws conclude this, the least-loss law
(`Amounts.rests_unrefuted`) and the finite-reading law (`Amounts.rests_unrefuted_of_finite_reading`),
and it is the one premise of rest over any amounts (`World.InAmounts.change_stops_iff`). -/
def FallsStop (s : Nat → A) (T : Nat) : Prop :=
  ¬ ∀ N, T ≤ N → ¬¬ ∃ t, N ≤ t ∧ ¬ M.le (s t) (s (t + 1))

/-- No amount falls without end: every amount that, as far as can be refuted, does not rise from a
step on has its strict falls stop from there. -/
def NoEndlessFall : Prop :=
  ∀ (s : Nat → A) (T : Nat), (∀ t, T ≤ t → ¬¬ M.le (s (t + 1)) (s t)) → M.FallsStop s T

/-- Some amount falls strictly at every step. -/
def EndlessFall : Prop :=
  ∃ s : Nat → A, ∀ t, M.le (s (t + 1)) (s t) ∧ ¬ M.le (s t) (s (t + 1))

/-- Every strict fall is by at least `ε`: an amount within another that does not hold it, with `ε`,
is still within it. -/
def FallsAtLeast (ε : A) : Prop :=
  ∀ a b, M.le b a → ¬ M.le a b → M.le (M.add b ε) a

variable {M}

/-- The falls stop for an amount wherever they stop for one equal to it from `T` on. -/
theorem fallsStop_congr {s s' : Nat → A} {T : Nat} (same : ∀ t, T ≤ t → s t = s' t)
    (stops : M.FallsStop s' T) : M.FallsStop s T :=
  fun falling => stops fun N from_ none_ => falling N from_ fun ⟨t, after, fall⟩ =>
    have later : T ≤ t := Nat.le_trans from_ after
    none_ ⟨t, after, fun le => fall
      (Eq.subst (motive := fun x => M.le x (s (t + 1))) (same t later).symm
        (Eq.subst (motive := fun x => M.le (s' t) x) (same (t + 1) (Nat.le_succ_of_le later)).symm
          le))⟩

/-- **A least fall, in Archimedean amounts, leaves no endless fall.** Where every strict fall is
by at least an amount `ε` above nothing and every amount lies within finitely many copies of `ε`
(`Amounts.Archimedean`), every amount not rising from a step on stops falling strictly: the
least-loss law (`Amounts.rests_unrefuted`), with the falls themselves as the steps counted. -/
theorem noEndlessFall_of_fallsAtLeast (archimedean : M.Archimedean) {ε : A}
    (positive : ¬ M.le ε M.zero) (least : M.FallsAtLeast ε) : M.NoEndlessFall :=
  fun s T still => match archimedean (s T) ε positive with
  | ⟨_, within⟩ => rests_unrefuted (P := fun t => ¬ M.le (s t) (s (t + 1))) still
      (fun t later falls no => still t later fun down => no (least _ _ down falls)) within

/-- In whole numbers every strict fall is by at least one. -/
theorem whole_fallsAtLeast : Amounts.whole.FallsAtLeast 1 :=
  fun _ _ _ falls => Nat.gt_of_not_le falls

/-- **No whole number falls without end.** -/
theorem whole_noEndlessFall : Amounts.whole.NoEndlessFall :=
  noEndlessFall_of_fallsAtLeast whole_archimedean (fun le => Nat.not_succ_le_zero 0 le)
    whole_fallsAtLeast

end Amounts

namespace Halving

theorem falls_back (t : Nat) :
    Dyadic.amounts.le (stock t) (Dyadic.amounts.add (stock (t + 1)) (loss t)) := by
  show 1 * 2 ^ ((t + 1) + (t + 1)) ≤ (1 * 2 ^ (t + 1) + 1 * 2 ^ (t + 1)) * 2 ^ t
  rw [Nat.one_mul, Nat.one_mul, Naturals.pow_add 2 (t + 1) (t + 1), ← Nat.mul_two,
    mul_assoc_nat, Nat.mul_comm 2 (2 ^ t)]
  exact Nat.le_refl _

/-- Dyadic amounts fall without end: the halving stock falls strictly at every step. -/
theorem endless : Dyadic.amounts.EndlessFall :=
  ⟨stock, fun t => ⟨never_rests.2.1 t, falls_strictly t⟩⟩

/-- **No least fall in dyadic amounts**: no amount above nothing is within every strict fall, since
the halving stock's falls are its losses and no amount above nothing is within every loss. -/
theorem no_least_fall (ε : Dyadic) (positive : ¬ Dyadic.amounts.le ε Dyadic.amounts.zero) :
    ¬ Dyadic.amounts.FallsAtLeast ε := fun least =>
  no_least_loss ε positive fun t =>
    Dyadic.amounts.le_of_add_le_add_right (stock (t + 1))
      (Dyadic.amounts.le_trans (Amounts.le_of_eq (Dyadic.amounts.add_comm _ _))
        (Dyadic.amounts.le_trans
          (Dyadic.amounts.le_trans (least _ _ (never_rests.2.1 t) (falls_strictly t)) (falls_back t))
          (Amounts.le_of_eq (Dyadic.amounts.add_comm _ _))))

end Halving

namespace Layered

/-- Layered amounts fall without end: the stock falls strictly at every step. -/
theorem endless : amounts.EndlessFall :=
  ⟨stock, fun t => ⟨never_rests.1 t, fun le => Halving.falls_strictly t le.1⟩⟩

/-- **A least fall in layered amounts**: every strict fall is by at least one fine unit. Where the
coarse layer falls strictly the fine unit is lost in it; where the coarse layers are each within
the other, the fine layer falls strictly and so by at least one. -/
theorem fallsAtLeast : amounts.FallsAtLeast least := fun a b down strict =>
  have coarse : Dyadic.le (Dyadic.add b.coarse Dyadic.zero) b.coarse :=
    Amounts.le_of_eq (M := Dyadic.amounts) (Amounts.add_zero (M := Dyadic.amounts) b.coarse)
  ⟨Dyadic.le_trans' coarse down.1, fun up =>
    have back : Dyadic.le a.coarse b.coarse := Dyadic.le_trans' up coarse
    Nat.gt_of_not_le fun fine => strict ⟨back, fun _ => fine⟩⟩

end Layered
'''
rep('\nend Layered\n', '\nend Layered\n' + SECTION)

# the finite-reading law states its conclusion with the premise named
rep('''    (held : ∀ t, T ≤ t → g t ∈ l) (still : ∀ t, T ≤ t → ¬¬ M.le (q (g (t + 1))) (q (g t))) :
    ¬ ∀ N, T ≤ N → ¬¬ ∃ t, N ≤ t ∧ ¬ M.le (q (g t)) (q (g (t + 1))) := fun recurs =>''',
'''    (held : ∀ t, T ≤ t → g t ∈ l) (still : ∀ t, T ≤ t → ¬¬ M.le (q (g (t + 1))) (q (g t))) :
    M.FallsStop (fun t => q (g t)) T := fun recurs =>''')
F.write_text(t)
print('edited', F.name)
