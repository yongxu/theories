"""LC3 edits to Becoming.InAmounts (kit tree). usage: python3 -B edit_inamounts.py (from the checkout root)"""
from pathlib import Path
HERE = Path(__file__).resolve().parent
F = HERE / 'tree/Becoming/InAmounts.lean'
t = F.read_text()

def rep(old, new):
    global t
    assert t.count(old) == 1, (old[:80], t.count(old))
    t = t.replace(old, new)

AMOUNTS = r'''
/-- Members each not refuted to be within another's amount total, as far as can be refuted, within
the other's total. -/
theorem not_not_totalOf_le {a b : X → A} : ∀ {l : List X}, (∀ x, x ∈ l → ¬¬ M.le (a x) (b x)) →
    ¬¬ M.le (M.totalOf l a) (M.totalOf l b)
  | [], _ => fun no => no (M.le_refl _)
  | x :: xs, le => fun no => le x (.head xs) fun head =>
      not_not_totalOf_le (fun y mem => le y (.tail x mem)) fun rest =>
        no (M.le_trans (M.add_le_add_right _ head) (add_le_add_left _ rest))

/-- Over a list without repetition holding `p`, amounts that are nothing away from `p` total to the
amount at `p`. Whether a member is `p` is decided. -/
theorem totalOf_single {a : X → A} {p : X} (decide : ∀ x : X, x = p ∨ ¬ x = p)
    (rest : ∀ x, ¬ x = p → a x = M.zero) : ∀ {l : List X}, Distinct l → p ∈ l → M.totalOf l a = a p
  | [], _, mem => nomatch mem
  | x :: xs, ⟨fresh, distinct⟩, mem => match decide x with
    | .inl same =>
      have none_ : M.totalOf xs a = M.zero :=
        (totalOf_congr (b := fun _ => M.zero) fun y inside => rest y fun at_p =>
          fresh (Eq.subst (motive := fun z => z ∈ xs) (at_p.trans same.symm) inside)).trans
          (totalOf_zero xs)
      (congrArg (M.add (a x)) none_).trans ((Amounts.add_zero (a x)).trans (congrArg a same))
    | .inr other => match mem_cons_cases mem with
      | .inl same => absurd same.symm other
      | .inr inside => (congrArg (fun z => M.add z (M.totalOf xs a)) (rest x other)).trans
          ((M.zero_add _).trans (totalOf_single decide rest distinct inside))

end Amounts
'''
i = t.index('\nend Amounts\n')
t = t[:i] + '\n' + AMOUNTS + t[i + len('\nend Amounts\n'):]

a = t.index('/-- **Change stops, unrefuted, over any amounts, read finitely.**')
b = t.index('variable (M v)\n\n/-- Every relatum is embodied')
MIDDLE = r'''/-- **A family stops changing exactly where its total stops falling.** Where from `T` on the family
balances and is dissipated on, that its members' levels stop changing cannot be refuted exactly
where its total's strict falls stop (`Amounts.FallsStop`). One way needs neither premise: across a
strict fall of the total some member's level falls, as far as can be refuted. The other way is the
law of one step (`InAmounts.change_lowers`). So over any amounts a family's rest is the rest of one
amount, and no premise on the amounts enters. -/
theorem change_stops_iff {ds : List w.Relatum} {T : Nat}
    (balances : ∀ t, T ≤ t → v.BalancesOn M ds t) (dissipates : ∀ t, T ≤ t → v.DissipatesOn M ds t) :
    (¬ ∀ N, T ≤ N → ¬¬ ∃ t c, N ≤ t ∧ c ∈ ds ∧ (v.Rises M t c ∨ v.Falls M t c)) ↔
      M.FallsStop (v.stock M ds) T :=
  ⟨fun stops falling => stops fun N from_ none_ => falling N from_ fun ⟨t, after, fall⟩ =>
      Amounts.not_not_totalOf_le (l := ds) (a := v.level t) (b := v.level (t + 1))
        (fun c member falls => none_ ⟨t, c, after, member, .inr falls⟩) fall,
   fun stops changing => stops fun N from_ none_ =>
      changing N from_ fun ⟨t, _, after, member, changes⟩ =>
        none_ ⟨t, after, change_lowers (balances t (Nat.le_trans from_ after))
          (dissipates t (Nat.le_trans from_ after)) member changes⟩⟩

/-- A family's total read off configurations a list holds, balanced and dissipated on from `T` on,
stops falling (`Amounts.rests_unrefuted_of_finite_reading`). -/
theorem stops_of_reading {ds : List w.Relatum} {T : Nat} {S : Type} {g : Nat → S} {q : S → A}
    {l : List S} (balances : ∀ t, T ≤ t → v.BalancesOn M ds t)
    (dissipates : ∀ t, T ≤ t → v.DissipatesOn M ds t) (held : ∀ t, T ≤ t → g t ∈ l)
    (reads : ∀ t, T ≤ t → v.stock M ds t = q (g t)) : M.FallsStop (v.stock M ds) T :=
  Amounts.fallsStop_congr reads (Amounts.rests_unrefuted_of_finite_reading held
    fun t later no => no (Eq.subst (motive := fun x => M.le x (q (g t)))
      (reads (t + 1) (Nat.le_succ_of_le later))
      (Eq.subst (motive := fun x => M.le (v.stock M ds (t + 1)) x) (reads t later)
        (stock_still (balances t later) (dissipates t later)))))

/-- **Change stops, unrefuted, over any amounts, read finitely.** Where from `T` on the family
balances and is dissipated on, and its total is read off configurations a list holds, it is not the
case that after every step from `T` on a later change of a member's level stays unrefuted. No least
loss, no Archimedean property and no decision (`change_stops_iff`, `stops_of_reading`). -/
theorem change_stops_unrefuted {ds : List w.Relatum} {T : Nat} {S : Type} {g : Nat → S} {q : S → A}
    {l : List S} (balances : ∀ t, T ≤ t → v.BalancesOn M ds t)
    (dissipates : ∀ t, T ≤ t → v.DissipatesOn M ds t) (held : ∀ t, T ≤ t → g t ∈ l)
    (reads : ∀ t, T ≤ t → v.stock M ds t = q (g t)) :
    ¬ ∀ N, T ≤ N → ¬¬ ∃ t c, N ≤ t ∧ c ∈ ds ∧ (v.Rises M t c ∨ v.Falls M t c) :=
  (change_stops_iff balances dissipates).mpr (stops_of_reading balances dissipates held reads)

/-- **The rest theorem over any amounts.** In a world whose active relata lie, from `T` on, in one
family, balanced and dissipated on at each of those steps, whose arising is embodied, and whose
family total stops falling from `T` on, that the world rests from some step on cannot be refuted.
No premise on the amounts: the family stops changing (`change_stops_iff`); ceasing left unrefuted
after every step leaves arising unrefuted after every step (`World.arising_unrefuted_covering`), and
an embodied arising is a rise. -/
theorem rests_unrefuted_of_stops {ds : List w.Relatum} {T : Nat}
    (covers : ∀ t, T ≤ t → ∀ x, w.web.active t x → x ∈ ds)
    (balances : ∀ t, T ≤ t → v.BalancesOn M ds t) (dissipates : ∀ t, T ≤ t → v.DissipatesOn M ds t)
    (embodied : v.ArisingEmbodied M) (stops : M.FallsStop (v.stock M ds) T) :
    ¬ ¬ ∃ N, w.RestsFrom N :=
  have unrefuted := (change_stops_iff balances dissipates).mpr stops
  World.rests_unrefuted_iff.mpr
  ⟨fun arising => unrefuted fun N from_ none_ => arising N fun ⟨t, x, later, arises⟩ =>
      none_ ⟨t, x, later,
        covers (t + 1) (Nat.le_succ_of_le (Nat.le_trans from_ later)) x arises.2,
        .inl (rises_of_arises embodied arises)⟩,
   fun ceasing => unrefuted fun N from_ none_ =>
      World.arising_unrefuted_covering covers ceasing N from_ fun ⟨t, x, later, member, arises⟩ =>
        none_ ⟨t, x, later, member, .inl (rises_of_arises embodied arises)⟩⟩

/-- **The rest theorem over any amounts, read finitely.** Where the family total is read off
configurations a list holds, it stops falling (`stops_of_reading`), so the world rests from some
step on, unrefuted. -/
theorem rests_unrefuted_covering {ds : List w.Relatum} {T : Nat} {S : Type} {g : Nat → S}
    {q : S → A} {l : List S} (covers : ∀ t, T ≤ t → ∀ x, w.web.active t x → x ∈ ds)
    (balances : ∀ t, T ≤ t → v.BalancesOn M ds t) (dissipates : ∀ t, T ≤ t → v.DissipatesOn M ds t)
    (embodied : v.ArisingEmbodied M) (held : ∀ t, T ≤ t → g t ∈ l)
    (reads : ∀ t, T ≤ t → v.stock M ds t = q (g t)) :
    ¬ ¬ ∃ N, w.RestsFrom N :=
  rests_unrefuted_of_stops covers balances dissipates embodied
    (stops_of_reading balances dissipates held reads)

/-- It is enough that the family's levels are read off configurations a list holds: the total is
then read off them too. -/
theorem rests_unrefuted_reading {ds : List w.Relatum} {T : Nat} {S : Type} {g : Nat → S}
    {read : S → w.Relatum → A} {l : List S} (covers : ∀ t, T ≤ t → ∀ x, w.web.active t x → x ∈ ds)
    (balances : ∀ t, T ≤ t → v.BalancesOn M ds t) (dissipates : ∀ t, T ≤ t → v.DissipatesOn M ds t)
    (embodied : v.ArisingEmbodied M) (held : ∀ t, T ≤ t → g t ∈ l)
    (reads : ∀ t, T ≤ t → ∀ c, c ∈ ds → v.level t c = read (g t) c) :
    ¬ ¬ ∃ N, w.RestsFrom N :=
  rests_unrefuted_covering (q := fun s => M.totalOf ds (read s)) covers balances dissipates embodied
    held fun t later => Amounts.totalOf_congr (reads t later)

/-- **A finite world in amounts rests, read finitely.** In a finite world in any amounts whose flow
balances and dissipates and whose arising is embodied, where a list holds every level function the
world takes, that the world rests from some step on cannot be refuted. -/
theorem rests_unrefuted (finite : w.Finite) (balanced : v.Balanced M) (dissipative : v.Dissipative M)
    (embodied : v.ArisingEmbodied M) {ls : List (w.Relatum → A)} (held : ∀ t, v.level t ∈ ls) :
    ¬ ¬ ∃ N, w.RestsFrom N :=
  match finite with
  | ⟨all, distinct, every⟩ =>
    rests_unrefuted_reading (T := 0) (ds := all) (g := v.level) (read := fun lv => lv)
      (fun _ _ x _ => every x) (fun t _ c _ => balanced t c)
      (fun t _ => dissipative all t distinct fun _ _ c outside => absurd (every c) outside)
      embodied (fun t _ => held t) fun _ _ _ _ => rfl

'''
t = t[:a] + MIDDLE + t[b:]

rep('''def Enclosed (t : Nat) : Prop :=
  ∃ es, Distinct es ∧ v.ClosedAt M es t
''', '''def Enclosed (t : Nat) : Prop :=
  ∃ es, Distinct es ∧ v.ClosedAt M es t

/-- The census's total standing at each step. -/
def censusStock (alive : Nat → List w.Relatum) (t : Nat) : A :=
  v.stock M (alive t) t
''')

c = t.index('/-- **The rest theorem over any amounts, read finitely, enclosed.**')
TAIL = open(HERE / 'tail_inamounts.lean').read()
t = t[:c] + TAIL
F.write_text(t)
print('edited', F.name)
