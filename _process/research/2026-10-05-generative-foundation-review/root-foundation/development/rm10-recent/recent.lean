
/-! #### Webs with a recent giving

Each condition's state is its level and what it gave last; what it gives is a law of what is left of
every condition and of what each gave last. The step reads states condition by condition, and where
each giving rises with what is left and with what was given it keeps the order of states, so the
bounded laws above hold: ending decided by a finite check, and each condition's point of no return,
given the other levels and every recent giving, exact and not rising as any of them rises. The web
whose giving reads nothing of what was given runs as the plain web (`Recent.plain`), and one
condition is the adjusted regime (`Recent.adjusted`). -/

namespace Recent

/-- **One step of a web with a recent giving.** The state holds each condition's level at `(i, true)`
and what it gave last at `(i, false)`. Each draw takes first, as much as there is; condition `i` gives
`G i` of what is left of every condition and of what each gave last; its next level is what is left
of it with what it gives, and what it gives is its next recent giving. -/
def step (G : ι → (ι → Nat) → (ι → Nat) → Nat) (H : ι → Nat) (x : ι × Bool → Nat) : ι × Bool → Nat
  | (i, true) => (x (i, true) - H i) + G i (fun j => x (j, true) - H j) (fun j => x (j, false))
  | (i, false) => G i (fun j => x (j, true) - H j) (fun j => x (j, false))

/-- Each giving rises with what is left of each condition and with what each gave last. -/
def Rises (G : ι → (ι → Nat) → (ι → Nat) → Nat) : Prop :=
  ∀ i e e' r r', (∀ j, e j ≤ e' j) → (∀ j, r j ≤ r' j) → G i e r ≤ G i e' r'

/-- **Under mutual support a web with a recent giving keeps the order of states.** -/
theorem keepsBelow {G : ι → (ι → Nat) → (ι → Nat) → Nat} {H : ι → Nat} (rises : Rises G) :
    KeepsBelow (step G H) := fun _ _ below p =>
  match p with
  | (i, true) => Nat.add_le_add (Nat.sub_le_sub_right (below (i, true)) (H i))
      (rises i _ _ _ _ (fun j => Nat.sub_le_sub_right (below (j, true)) (H j)) (fun j => below (j, false)))
  | (i, false) => rises i _ _ _ _ (fun j => Nat.sub_le_sub_right (below (j, true)) (H j))
      (fun j => below (j, false))

/-- Both parts of every listed condition. -/
def both : List ι → List (ι × Bool)
  | [] => []
  | i :: cs => (i, true) :: (i, false) :: both cs

/-- Both parts of a listed condition are listed. -/
theorem mem_both {i : ι} : ∀ {cs : List ι}, i ∈ cs → ∀ b, (i, b) ∈ both cs
  | _ :: _, .head _, true => .head _
  | _ :: _, .head _, false => .tail _ (.head _)
  | _ :: _, .tail _ mem, b => .tail _ (.tail _ (mem_both mem b))

/-- Where a list covers the conditions, `both` of it covers their parts. -/
theorem covers_both {cs : List ι} (covers : ∀ i, i ∈ cs) : ∀ p : ι × Bool, p ∈ both cs
  | (i, b) => mem_both (covers i) b

/-- **Where giving reads nothing of what was given, the levels run as the plain web's.** Each level of a
web with a recent giving whose giving is `G'` of what is left alone is, at every step, the level of
the plain web's run from the same levels. -/
theorem plain {G' : ι → (ι → Nat) → Nat} {H : ι → Nat} (pointwise : Indexed.Pointwise G')
    (x : ι × Bool → Nat) : ∀ n i, (Law.run (step (fun i e _ => G' i e) H) x).state n (i, true) =
      (Law.run (Indexed.step Drawn.whole G' H) (fun j => x (j, true))).state n i
  | 0, _ => rfl
  | n + 1, i => congr (congrArg (· + ·) (congrArg (· - H i) (plain pointwise x n i)))
      (pointwise i _ _ fun j => congrArg (· - H j) (plain pointwise x n j))

/-- A state of the adjusted regime, its level and recent giving, read as one condition's. -/
def ofAdjusted (p : Nat × Nat) : Unit × Bool → Nat
  | (_, true) => p.1
  | (_, false) => p.2

/-- **One condition with a recent giving is the adjusted regime.** -/
theorem adjusted (A : Nat → Nat → Nat) (H : Nat) (p : Nat × Nat) :
    ∀ n, (Law.run (step (fun _ e r => A (e ()) (r ())) (fun _ => H)) (ofAdjusted p)).state n ((), true) =
        ((Law.run (Adjusted.step A H) p).state n).1 ∧
      (Law.run (step (fun _ e r => A (e ()) (r ())) (fun _ => H)) (ofAdjusted p)).state n ((), false) =
        ((Law.run (Adjusted.step A H) p).state n).2
  | 0 => ⟨rfl, rfl⟩
  | n + 1 =>
    have ih := adjusted A H p n
    ⟨by
      show (Law.run (step (fun _ e r => A (e ()) (r ())) (fun _ => H)) (ofAdjusted p)).state n ((), true) - H +
          A ((Law.run (step (fun _ e r => A (e ()) (r ())) (fun _ => H)) (ofAdjusted p)).state n ((), true) - H)
            ((Law.run (step (fun _ e r => A (e ()) (r ())) (fun _ => H)) (ofAdjusted p)).state n ((), false)) = _
      rw [ih.1, ih.2]; try rfl,
     by
      show A ((Law.run (step (fun _ e r => A (e ()) (r ())) (fun _ => H)) (ofAdjusted p)).state n ((), true) - H)
            ((Law.run (step (fun _ e r => A (e ()) (r ())) (fun _ => H)) (ofAdjusted p)).state n ((), false)) = _
      rw [ih.1, ih.2]; try rfl⟩

/-! ##### A giving that ramps with what was given -/

namespace Momentum

/-- Nothing where nothing is left; where something is, one where nothing was given last and two where
something was. -/
def gives (e r : Nat) : Nat := if 1 ≤ e then (if 1 ≤ r then 2 else 1) else 0

/-- The ramping giving of one condition. -/
def giving : Unit → (Unit → Nat) → (Unit → Nat) → Nat := fun _ e r => gives (e ()) (r ())

theorem gives_rises {e e' r r' : Nat} (le : e ≤ e') (le' : r ≤ r') : gives e r ≤ gives e' r' :=
  if h : 1 ≤ e then
    have h' : 1 ≤ e' := Nat.le_trans h le
    if g : 1 ≤ r then Nat.le_of_eq ((if_pos h).trans ((if_pos g).trans
        ((if_pos (Nat.le_trans g le')).symm.trans (if_pos h').symm)))
    else
      Nat.le_trans (Nat.le_of_eq ((if_pos h).trans (if_neg g)))
        (if g' : 1 ≤ r' then Nat.le_trans (Nat.le_succ 1) (Nat.le_of_eq ((if_pos g').symm.trans (if_pos h').symm))
         else Nat.le_of_eq ((if_neg g').symm.trans (if_pos h').symm))
  else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

theorem rises : Rises giving := fun _ _ _ _ _ le le' => gives_rises (le ()) (le' ())

/-- The state of one condition at level `a` having given `r` last. -/
def at_ (a r : Nat) : Unit × Bool → Nat
  | (_, true) => a
  | (_, false) => r

/-- The ramping step under a draw of two. -/
def ramp : (Unit × Bool → Nat) → (Unit × Bool → Nat) := step giving (fun _ => 2)

theorem set_at (a r : Nat) : ∀ p, Indexed.setAt (at_ 0 r) ((), true) a p = at_ a r p
  | ((), true) => rfl
  | ((), false) => rfl

theorem ends_from {a r : Nat} {m : Nat} (at_m : ∀ p, (Law.run ramp (at_ a r)).state m p = at_ 0 0 p) :
    EndsUnder ramp ((), true) (Indexed.setAt (at_ 0 r) ((), true) a) :=
  ⟨m, fun k => (run_alike_of (reads_of_keepsBelow (keepsBelow rises)) (set_at a r) (m + k) ((), true)).trans
    (stays_at (reads_of_keepsBelow (keepsBelow rises)) at_m
      (fun p => match p with
        | ((), true) => rfl
        | ((), false) => rfl) k ((), true))⟩

theorem holds_from {a r b c : Nat} {m : Nat} (pos : 0 < b)
    (at_m : ∀ p, (Law.run ramp (at_ a r)).state m p = at_ b c p) (fixed : ∀ p, ramp (at_ b c) p = at_ b c p) :
    ¬ EndsUnder ramp ((), true) (Indexed.setAt (at_ 0 r) ((), true) a) := fun ⟨N, gone⟩ =>
  have reads := reads_of_keepsBelow (keepsBelow rises)
  Nat.ne_of_gt pos ((((gone m).symm.trans (run_alike_of reads (set_at a r) (N + m) ((), true))).trans
    ((congrArg (fun n => (Law.run ramp (at_ a r)).state n ((), true)) (Nat.add_comm N m)).trans
      (stays_at reads at_m fixed N ((), true)))).symm)

/-- **What a condition gave last lowers its point of no return.** One condition, drawn by two, gives
one where something is left and nothing was given last, and two where something was. From four having
given one, its run stays within four. Having given nothing, it ends from three and holds from four, so
its threshold, levels up to four, is four; having given one, it ends from two and holds from three, so
its threshold is three. -/
theorem threshold_falls_with_recent :
    StaysWithin ramp 4 (Indexed.setAt (at_ 0 1) ((), true) 4) ∧
    thresholdWithin ramp (both [()]) 4 4 (at_ 0 0) ((), true) = 4 ∧
    thresholdWithin ramp (both [()]) 4 4 (at_ 0 1) ((), true) = 3 :=
  have keeps : KeepsBelow ramp := keepsBelow rises
  have reads := reads_of_keepsBelow keeps
  have covers : ∀ p : Unit × Bool, p ∈ both [()] := covers_both fun _ => .head _
  have fixed₄ : ∀ p, ramp (at_ 4 2) p = at_ 4 2 p := fun p => match p with
    | ((), true) => rfl
    | ((), false) => rfl
  have within₁ : StaysWithin ramp 4 (Indexed.setAt (at_ 0 1) ((), true) 4) := fun n p =>
    have at1 : ∀ p, (Law.run ramp (at_ 4 1)).state 1 p = at_ 4 2 p := fun p => match p with
      | ((), true) => rfl
      | ((), false) => rfl
    Nat.le_trans (Nat.le_of_eq (run_alike_of reads (set_at 4 1) n p)) (match n, p with
      | 0, ((), true) => Nat.le_refl 4
      | 0, ((), false) => Nat.le_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 1))
      | k + 1, ((), true) => Nat.le_of_eq ((congrArg (fun m => (Law.run ramp (at_ 4 1)).state m ((), true))
          (Nat.add_comm k 1)).trans (stays_at reads at1 fixed₄ k ((), true)))
      | k + 1, ((), false) => Nat.le_trans (Nat.le_of_eq ((congrArg (fun m => (Law.run ramp (at_ 4 1)).state m ((), false))
          (Nat.add_comm k 1)).trans (stays_at reads at1 fixed₄ k ((), false)))) (Nat.le_succ_of_le (Nat.le_succ 2)))
  have within₀ : StaysWithin ramp 4 (Indexed.setAt (at_ 0 0) ((), true) 4) :=
    within_below keeps (Indexed.setAt_below (Nat.le_refl 4) fun p => match p with
      | ((), true) => Nat.le_refl 0
      | ((), false) => Nat.zero_le 1) within₁
  have fixed₃ : ∀ p, ramp (at_ 3 2) p = at_ 3 2 p := fun p => match p with
    | ((), true) => rfl
    | ((), false) => rfl
  have ends₃ : EndsUnder ramp ((), true) (Indexed.setAt (at_ 0 0) ((), true) 3) :=
    ends_from (m := 2) fun p => match p with
      | ((), true) => rfl
      | ((), false) => rfl
  have holds₄ : ¬ EndsUnder ramp ((), true) (Indexed.setAt (at_ 0 0) ((), true) 4) :=
    holds_from (m := 2) (Nat.succ_pos 2) (fun p => match p with
      | ((), true) => rfl
      | ((), false) => rfl) fixed₃
  have ends₂ : EndsUnder ramp ((), true) (Indexed.setAt (at_ 0 1) ((), true) 2) :=
    ends_from (m := 1) fun p => match p with
      | ((), true) => rfl
      | ((), false) => rfl
  have holds₃ : ¬ EndsUnder ramp ((), true) (Indexed.setAt (at_ 0 1) ((), true) 3) :=
    holds_from (m := 1) (Nat.succ_pos 2) (fun p => match p with
      | ((), true) => rfl
      | ((), false) => rfl) fixed₃
  ⟨within₁,
   Nat.le_antisymm
    ((Nat.lt_or_ge 4 (thresholdWithin ramp (both [()]) 4 4 (at_ 0 0) ((), true))).elim
      (fun lt => absurd ((ends_iff_below_within keeps covers within₀ (Nat.le_refl 4)).2 lt) holds₄) id)
    ((ends_iff_below_within keeps covers within₀ (Nat.le_succ 3)).1 ends₃),
   Nat.le_antisymm
    ((Nat.lt_or_ge 3 (thresholdWithin ramp (both [()]) 4 4 (at_ 0 1) ((), true))).elim
      (fun lt => absurd ((ends_iff_below_within keeps covers within₁ (Nat.le_succ 3)).2 lt) holds₃) id)
    ((ends_iff_below_within keeps covers within₁ (Nat.le_succ_of_le (Nat.le_succ 2))).1 ends₂)⟩

end Momentum

end Recent
