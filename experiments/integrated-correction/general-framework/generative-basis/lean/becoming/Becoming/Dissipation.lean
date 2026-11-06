import Becoming.Population

/-!
# Dissipation: recurring taking opens finite families and, enclosed around, draws in

`Becoming.Flow` shows that the renewers can be the takers themselves: in a closed cycle
each formation gives back what it takes, and generation is more without end (`Cycle`).
Whether continued taking must draw on more than any finite part of the unfolding turns
on dissipation. This module states that premise on flows and proves what it carries.

* A family of conditions is *closed* across a step when no formation taking part takes
  from or gives to a condition outside it (`ClosedAt`).
* A formation *dissipates* on a family across a step when it gives the family no more
  than it takes from it, and less when it takes (`DissipatesOn`). A flow is
  *dissipative* when, across every step, every family without repetition closed across
  it is dissipated on (`Dissipative`). A formation giving to a family dissipated on
  takes from it (`DissipatesOn.takes_of_gives`).
* Dissipation binds only where some finite family is closed. A step is *enclosed* when
  the exchange of the formations taking part lies within a finite family without
  repetition (`Enclosed`), as at every step where finitely many conditions are all there
  is (`enclosed_of_finite`). Under dissipation, a formation that gives takes more than it
  gives over every family without repetition closed across the step
  (`Dissipative.gives_less`; with repetition it need not, `Lone.repeated_family`), so
  across an enclosed step giving needs uptake (`Dissipative.giving_needs_uptake`). A step
  at which some formation taking part exchanges with infinitely many conditions is not
  enclosed; where no step is enclosed, dissipation holds vacuously and a renewer can give
  while taking nothing (`Spray`).
* In a balanced flow, a family dissipated on across a step falls across it by at least
  the number of formations taking from it (`Balances.runs_down`). Dissipated on from
  some step, the formations taking from it over all later steps number at most its stock
  there (`Balances.takers_within`), and taking from it does not recur
  (`Balances.taking_not_recurring`).
* Under dissipation, a finite family from which formations take at arbitrarily late
  steps is not closed from any step on, and neither is any finite family without
  repetition containing it: at arbitrarily late steps some formation taking part
  exchanges with a condition outside it (`Dissipative.opens`). Any recurring uptake is
  such taking, whether of more, of generation or of maintenance: more without end
  (`More.opens`), the unceasing arising of formations that take (`opens_of_arising`),
  and one eater kept up with nothing arising and no growth (`Lone`). The exchange
  beyond the family need not touch the family: where no step is enclosed, it can be an
  exchange elsewhere (`Spray`, and `SprayShuttle` in `Becoming.Roles`). If finitely many
  conditions are all there is, taking does not recur at all
  (`Dissipative.finite_taking_not_recurring`).
* Where the step is enclosed around the family, the exchange beyond is inflow. A step is
  enclosed around a family when some family without repetition containing it is closed
  across the step (`Around`); with equality of conditions decidable, every enclosed step
  is enclosed around every family (`Enclosed.around`), and without it, not not
  (`Enclosed.around_not_not`). A family is *inward* across a step
  when every formation taking part that gives to it takes only from it (`Inward`). Under
  dissipation, a family without repetition enclosed around and inward across a step is
  dissipated on (`Dissipative.dissipatesOn_of_inward`), so where taking from it recurs
  and it is enclosed around from some step on, at arbitrarily late steps some formation
  gives to it and takes from beyond it (`taking_draws_in`).
* Rising falls under this with no taking of its own. A member of a family dissipated on
  that rises lowers the family's stock, since whatever gives to it takes more from the
  family (`rise_lowers_on`), so members of a family dissipated on from some step on do
  not rise at arbitrarily late steps (`rising_not_recurring_on`). Under dissipation, a finite
  family without repetition whose members rise at arbitrarily late steps is therefore
  not closed from any step on (`rising_opens`) and, enclosed around from some step on,
  draws in (`rising_draws_in`); if finitely many conditions are all there is, none rises
  at arbitrarily late steps (`rising_not_recurring`). Coming to stand is the rise from nothing,
  so each holds of it (`standing_lowers_on`, `standing_lowers` for a closed family under
  dissipation, `standing_not_recurring_on`, `standing_opens`, `standing_draws_in` and
  `standing_not_recurring`). Where a formation is itself a condition standing exactly while it
  is active, its arising is such a coming to stand (`Becoming.Roles`,
  `Web.embodiedArising_draws_in`).
* Rising and falling in one exchange. Across a step dissipated on, the members of a
  family fall by at least as much as they rise, and by one more for each formation
  taking from it (`Balances.falls_cover`). So a formation taking from the family makes
  some member fall, whether or not another rises (`Balances.falls_of_taking`), and the
  depletion supplied as a premise in `Becoming.Arising` is a theorem for an event at
  whose steps the family is dissipated on and taken from (`Balances.depletes`). Where a
  member rises, another member falls across the same step (`rise_with_fall`,
  `standing_with_fall` for coming to stand), so under dissipation a member of a family
  without repetition rising while none falls shows the family open across that step
  (`rise_alone_opens`). Where only active formations give and take, an active formation
  gives to the one and takes from the family, and an active formation drawing on the
  other takes from it (`rise_exchange`). The fall is a lowering, not a ceasing: the
  member that falls may still stand. Without dissipation a member can come to stand with
  nothing falling (`Brood.rise_without_fall` in `Becoming.Roles`).
* The premises are consistent with more without end: a source burns a fresh fuel at every
  step and gives a pool less than it burns, while ever more growers take from the pool
  (`Frontier`). The conditions it draws on are not contained in any finite family, while
  each step is enclosed around the pool by the pool and the fuel of the step
  (`Frontier.enclosed`, `Frontier.around`), so the source's burning is the inflow
  (`Frontier.draws_in`); keeping one eater fed draws in the same way (`Lone.draws_in`).
  The pool's family is not closed, and the source gives it while taking nothing from it
  (`Frontier.gives_without_taking`): a formation giving to a family takes from it only
  where the family is dissipated on. With the growers depending on the pool, every
  premise of `More.unceasing` holds as well, and the pool's families are open by
  `opens_of_arising` too (`Rooted`).
* Without dissipation a finite family can stay closed: the cycle of `Becoming.Flow`
  gives back what it takes (`Cycle.closed_more`). None of the flows of `Becoming.Flow`
  and `Becoming.Population` in which taking recurs is dissipative
  (`witnesses_not_dissipative`): in each, some formation gives a closed family
  something, and at least what it takes from it, as the expansion's renewers give with
  their source unrepresented.

Dissipation is read on amounts with commensurable units, as of free energy; matter can
cycle within a finite family while what drives the cycling is dissipated. That a given
quantity dissipates, and that the exchange at a step lies within finitely many
conditions, are physical premises, not theorems. The unfolding that bears recurring
taking under dissipation and enclosure draws in from beyond every finite family of
conditions; whether actual unfoldings meet these premises is an empirical question. No
ethical predicate, ranking or axiom occurs.

`Sequences.recurs_iff`, which reads a run of `Becoming.Horizon`, is in
`Becoming.LabelledRoles`, so this module does not import `Becoming.Horizon`.
-/

namespace Becoming

/-! ## Totals over lists without repetition -/

section Totals

variable {α : Type}

theorem pos_of_sign : ∀ {n : Nat}, 0 < sign n → 0 < n
  | 0, positive => positive
  | n + 1, _ => Nat.succ_pos n

theorem sign_pos : ∀ {n : Nat}, 0 < n → 0 < sign n
  | 0, positive => positive
  | _ + 1, _ => Nat.succ_pos 0

/-- A quantity positive only at `a` totals at most its value at `a` over a list without
repetition. -/
theorem total_le_at {q : α → Nat} {a : α} (only : ∀ b, 0 < q b → b = a) :
    ∀ {as : List α}, Distinct as → total as q ≤ q a
  | [], _ => Nat.zero_le _
  | b :: as, ⟨fresh, distinct⟩ => match h : q b with
    | 0 => Nat.le_trans (Nat.le_of_eq ((congrArg (· + total as q) h).trans (Nat.zero_add _)))
        (total_le_at only distinct)
    | n + 1 =>
      have same : b = a := only b (h ▸ Nat.succ_pos n)
      have rest : total as q = 0 := total_eq_zero fun e mem => eq_zero_of_not_pos fun pos =>
        fresh (Eq.subst (motive := fun x => x ∈ as) ((only e pos).trans same.symm) mem)
      Nat.le_of_eq ((congrArg (q b + ·) rest).trans ((Nat.add_zero _).trans (congrArg q same)))

/-- A total over a list without repetition is at most the total over any list holding
each member at which the quantity is positive. -/
theorem total_le_of_support {q : α → Nat} :
    ∀ {l m : List α}, Distinct l → (∀ a, a ∈ l → 0 < q a → a ∈ m) → total l q ≤ total m q
  | [], _, _, _ => Nat.zero_le _
  | a :: l, m, ⟨fresh, distinct⟩, sub => match h : q a with
    | 0 =>
      have rest : total l q ≤ total m q :=
        total_le_of_support distinct fun b mem => sub b (.tail a mem)
      Nat.le_trans (Nat.le_of_eq ((congrArg (· + total l q) h).trans (Nat.zero_add _))) rest
    | n + 1 =>
      match List.append_of_mem (sub a (.head l)
          (Eq.subst (motive := fun k => 0 < k) h.symm (Nat.succ_pos n))) with
      | ⟨p, r, split⟩ =>
        have inner : total l q ≤ total (p ++ r) q :=
          total_le_of_support distinct fun b mem positive =>
            mem_remove (fun same => fresh (Eq.subst (motive := fun x => x ∈ l) same mem))
              (Eq.subst (motive := fun x => b ∈ x) split (sub b (.tail a mem) positive))
        have whole : total m q = q a + total (p ++ r) q :=
          (congrArg (total · q) split).trans ((total_append q (a :: r) p).trans
            ((Nat.add_left_comm (total p q) (q a) (total r q)).trans
              (congrArg (q a + ·) (total_append q r p).symm)))
        Nat.le_trans (Nat.add_le_add_left inner (q a)) (Nat.le_of_eq whole.symm)

/-- Over lists without repetition holding where a quantity is positive, its totals agree. -/
theorem total_eq_of_supports {q : α → Nat} {l m : List α} (dl : Distinct l)
    (dm : Distinct m) (lm : ∀ a, 0 < q a → a ∈ m) (ml : ∀ a, 0 < q a → a ∈ l) :
    total l q = total m q :=
  Nat.le_antisymm (total_le_of_support dl fun a _ pos => lm a pos)
    (total_le_of_support dm fun a _ pos => ml a pos)

/-- With equality decidable, membership in a list is decidable. -/
def decideMem [DecidableEq α] (a : α) : (l : List α) → Decidable (a ∈ l)
  | [] => .isFalse fun no => nomatch no
  | b :: l => match decEq a b with
    | .isTrue same => .isTrue (Eq.subst (motive := fun x => a ∈ x :: l) same (.head l))
    | .isFalse other => match decideMem a l with
      | .isTrue mem => .isTrue (.tail b mem)
      | .isFalse no => .isFalse fun mem => match mem_cons_cases mem with
        | .inl same => other same
        | .inr mem => no mem

/-- `a` put in front of `l` unless it is there. -/
def insertNew (a : α) (l : List α) : Decidable (a ∈ l) → List α
  | .isTrue _ => l
  | .isFalse _ => a :: l

theorem insertNew_spec {a : α} {l : List α} (distinct : Distinct l) :
    ∀ decide : Decidable (a ∈ l), Distinct (insertNew a l decide) ∧
      a ∈ insertNew a l decide ∧ ∀ b, b ∈ l → b ∈ insertNew a l decide
  | .isTrue mem => ⟨distinct, mem, fun _ held => held⟩
  | .isFalse fresh => ⟨⟨fresh, distinct⟩, .head l, fun _ held => .tail a held⟩

/-- `l` with the members of `ds` it lacks put in front, each once. -/
def adjoin [DecidableEq α] : List α → List α → List α
  | [], l => l
  | a :: ds, l => insertNew a (adjoin ds l) (decideMem a (adjoin ds l))

/-- Adjoining keeps a list without repetition, and holds the members of both lists. -/
theorem adjoin_spec [DecidableEq α] {l : List α} (distinct : Distinct l) :
    ∀ ds : List α, Distinct (adjoin ds l) ∧ (∀ a, a ∈ ds → a ∈ adjoin ds l) ∧
      ∀ b, b ∈ l → b ∈ adjoin ds l
  | [] => ⟨distinct, fun _ no => (nomatch no), fun _ held => held⟩
  | a :: ds => match adjoin_spec distinct ds with
    | ⟨distinct', left, right⟩ =>
      match insertNew_spec (a := a) distinct' (decideMem a (adjoin ds l)) with
      | ⟨distinct'', inserted, kept⟩ =>
        ⟨distinct'', fun b mem => match mem_cons_cases mem with
          | .inl same => Eq.subst (motive := fun x => x ∈ adjoin (a :: ds) l) same.symm inserted
          | .inr mem => kept b (left b mem),
         fun b held => kept b (right b held)⟩

end Totals

/-- Losses of whole-number amounts added over a stretch are the spine's total over its steps
(moved from `Becoming.LeastLoss`). -/
theorem Amounts.whole_sum (d : Nat → Nat) : ∀ n S, Amounts.whole.sum d S n = total (steps S n) d
  | 0, _ => rfl
  | n + 1, S =>
    (congrArg (· + d (S + n)) (Amounts.whole_sum d n S)).trans (total_steps_last d n S).symm
where
  total_steps_last (d : Nat → Nat) : ∀ n S, total (steps S (n + 1)) d = total (steps S n) d + d (S + n)
    | 0, S => (Nat.add_zero (d S)).trans (Nat.zero_add (d S)).symm
    | n + 1, S =>
      (congrArg (d S + ·) ((total_steps_last d n (S + 1)).trans
        (congrArg (fun k => total (steps (S + 1) n) d + d k) (Nat.succ_add S n)))).trans
        (Nat.add_assoc _ _ _).symm

variable {F C : Type}

namespace Flow

variable (L : Flow F C)

/-- No formation taking part in the step from `t` takes from or gives to a condition
outside the family. -/
def ClosedAt (cs : List C) (t : Nat) : Prop :=
  ∀ f, f ∈ L.present t → ∀ c, ¬ c ∈ cs → L.take t f c = 0 ∧ L.give t f c = 0

/-- Across the step from `t`, every formation taking part gives the family no more than it
takes from it, and less when it takes. -/
def DissipatesOn (cs : List C) (t : Nat) : Prop :=
  ∀ f, f ∈ L.present t →
    total cs (L.give t f) + sign (total cs (L.take t f)) ≤ total cs (L.take t f)

/-- Dissipation: across every step, every family without repetition closed across it is
dissipated on. -/
def Dissipative : Prop :=
  ∀ cs t, Distinct cs → L.ClosedAt cs t → L.DissipatesOn cs t

/-- Across the step from `t`, some family without repetition is closed: the exchange of
the formations taking part lies within finitely many conditions. -/
def Enclosed (t : Nat) : Prop :=
  ∃ cs, Distinct cs ∧ L.ClosedAt cs t

/-- Across the step from `t`, some family without repetition containing `ds` is closed:
the exchange of the step, together with the family, lies within finitely many
conditions. -/
def Around (ds : List C) (t : Nat) : Prop :=
  ∃ es, Distinct es ∧ (∀ c, c ∈ ds → c ∈ es) ∧ L.ClosedAt es t

/-- Across the step from `t`, every formation taking part that gives to the family takes
only from the family: nothing beyond it flows in. -/
def Inward (ds : List C) (t : Nat) : Prop :=
  ∀ f, f ∈ L.present t → 0 < total ds (L.give t f) → ∀ c, 0 < L.take t f c → c ∈ ds

variable {L} {W : Web F C}

/-- Dissipated on, the family's replenishment and its takers together are at most its
uptake. -/
theorem DissipatesOn.replenishment_takers {cs : List C} {t : Nat}
    (dissipates : L.DissipatesOn cs t) : L.replenishment cs t + L.takers cs t ≤ L.uptake cs t :=
  Nat.le_trans
    (Nat.le_of_eq ((congrArg (· + L.takers cs t)
      (total_swap (fun c f => L.give t f c) (L.present t) cs)).trans
      (total_add (fun f => total cs (L.give t f)) (fun f => sign (total cs (L.take t f)))
        (L.present t)).symm))
    (Nat.le_trans
      (total_le (p := fun f => total cs (L.give t f) + sign (total cs (L.take t f)))
        (q := fun f => total cs (L.take t f)) (L.present t) dissipates)
      (Nat.le_of_eq (total_swap (fun f c => L.take t f c) cs (L.present t))))

/-- Dissipated on, a formation that gives to the family takes from it. -/
theorem DissipatesOn.takes_of_gives {cs : List C} {t : Nat} (dissipates : L.DissipatesOn cs t)
    {f : F} (present : f ∈ L.present t) (gives : 0 < total cs (L.give t f)) :
    0 < total cs (L.take t f) :=
  Nat.lt_of_lt_of_le gives (Nat.le_trans (Nat.le_add_right _ _) (dissipates f present))

/-- Where finitely many conditions are all there is, every step is enclosed. -/
theorem enclosed_of_finite {all : List C} (distinct : Distinct all) (every : ∀ c, c ∈ all)
    (t : Nat) : L.Enclosed t :=
  ⟨all, distinct, fun _ _ c outside => absurd (every c) outside⟩

/-- Over a family closed and dissipated on across a step, a formation taking part that gives
takes more than it gives. -/
theorem DissipatesOn.gives_less_closed {cs : List C} {t : Nat} (dissipates : L.DissipatesOn cs t)
    (closed : L.ClosedAt cs t) {f : F} (present : f ∈ L.present t) {c : C}
    (gives : 0 < L.give t f c) : total cs (L.give t f) < total cs (L.take t f) :=
  have given : 0 < total cs (L.give t f) := match Nat.decLt 0 (total cs (L.give t f)) with
    | isTrue positive => positive
    | isFalse zero => absurd (Nat.lt_of_lt_of_le gives (Nat.le_of_eq (closed f present c
        fun inside => zero (Nat.lt_of_lt_of_le gives (le_total_of_mem inside))).2))
        (Nat.lt_irrefl 0)
  Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right (sign_pos (dissipates.takes_of_gives present given)))
    (dissipates f present)

/-- Under dissipation, over a family without repetition closed across a step, a formation
taking part that gives takes more than it gives. -/
theorem Dissipative.gives_less (dissipative : L.Dissipative) {cs : List C} {t : Nat}
    (distinct : Distinct cs) (closed : L.ClosedAt cs t) {f : F} (present : f ∈ L.present t)
    {c : C} (gives : 0 < L.give t f c) : total cs (L.give t f) < total cs (L.take t f) :=
  (dissipative cs t distinct closed).gives_less_closed closed present gives

/-- Giving needs uptake: under dissipation, across an enclosed step, a formation taking
part that gives takes from some condition. -/
theorem Dissipative.giving_needs_uptake (dissipative : L.Dissipative) {t : Nat}
    (enclosed : L.Enclosed t) {f : F} (present : f ∈ L.present t) {c : C}
    (gives : 0 < L.give t f c) : ∃ d, 0 < L.take t f d :=
  match enclosed with
  | ⟨cs, distinct, closed⟩ =>
    match total_pos (q := L.take t f) cs (Nat.lt_of_le_of_lt (Nat.zero_le _)
        (dissipative.gives_less distinct closed present gives)) with
    | ⟨d, _, taken⟩ => ⟨d, taken⟩

/-- Balanced and dissipated on, the family falls across the step by at least the number of
formations taking from it. -/
theorem BalancesOn.runs_down {cs : List C} {t : Nat} (balances : L.BalancesOn W cs t)
    (dissipates : L.DissipatesOn cs t) : W.stock cs (t + 1) + L.takers cs t ≤ W.stock cs t :=
  le_of_add_le_add_right (L.replenishment cs t) (Nat.le_trans
    (Nat.le_of_eq ((Nat.add_assoc _ _ _).trans
      (congrArg (W.stock cs (t + 1) + ·) (Nat.add_comm _ (L.replenishment cs t)))))
    (Nat.le_trans (Nat.add_le_add_left dissipates.replenishment_takers _)
      (Nat.le_of_eq balances.over)))

section

variable {cs : List C} {t : Nat} {c : C}

/-- So where nothing is taken from a family dissipated on across the step, no member
rises: dissipation lets nothing give to it without taking from it. -/
theorem DissipatesOn.still_untaken (dissipates : L.DissipatesOn cs t)
    (balances : L.BalancesOn W cs t) (untaken : ∀ c, c ∈ cs → L.taken t c = 0) :
    ¬ ∃ c, c ∈ cs ∧ W.Rises t c :=
  fun rising => match (balances.rises_iff_gives untaken).mp rising with
  | ⟨f, _, present, mem, gives⟩ =>
    match total_pos cs (dissipates.takes_of_gives present
        (Nat.lt_of_lt_of_le gives (le_total_of_mem (q := L.give t f) mem))) with
    | ⟨d, inside, takes⟩ => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
        (Nat.lt_of_lt_of_le takes (le_total_of_mem (q := fun f => L.take t f d) present))
        (Nat.le_of_eq (untaken d inside)))

/-- Balanced and dissipated on, a family a formation taking part takes from falls across
the step. -/
theorem BalancesOn.taking_lowers (balances : L.BalancesOn W cs t)
    (dissipates : L.DissipatesOn cs t) {f : F} (present : f ∈ L.present t)
    (takes : 0 < total cs (L.take t f)) : W.stock cs (t + 1) < W.stock cs t :=
  Nat.lt_of_lt_of_le
    (Nat.lt_add_of_pos_right (total_pos_of_mem (q := fun f => sign (total cs (L.take t f)))
      present (sign_pos takes)))
    (balances.runs_down dissipates)

/-- Balanced and dissipated on, a member's fall lowers the family: it is taken from. -/
theorem BalancesOn.fall_lowers (balances : L.BalancesOn W cs t) (dissipates : L.DissipatesOn cs t)
    (mem : c ∈ cs) (falls : W.Falls t c) : W.stock cs (t + 1) < W.stock cs t :=
  match total_pos (L.present t) (balances.fall_taken mem falls) with
  | ⟨_, present, takes⟩ => balances.taking_lowers dissipates present (total_pos_of_mem mem takes)

/-- Balanced and dissipated on, a member's rise lowers the family too: it is given to, and
what gives to the family takes from it. -/
theorem BalancesOn.rise_lowers (balances : L.BalancesOn W cs t) (dissipates : L.DissipatesOn cs t)
    (mem : c ∈ cs) (rises : W.Rises t c) : W.stock cs (t + 1) < W.stock cs t :=
  match total_pos (L.present t) (balances.rise_given mem rises) with
  | ⟨_, present, gives⟩ => balances.taking_lowers dissipates present
      (dissipates.takes_of_gives present (total_pos_of_mem mem gives))

/-- Nothing comes to stand from nothing: across a step at which a family is balanced and
dissipated on, a member comes to stand only where the family stood at something before. -/
theorem BalancesOn.comes_from_standing (balances : L.BalancesOn W cs t)
    (dissipates : L.DissipatesOn cs t) (mem : c ∈ cs) (comes : W.ComesToStand t c) :
    0 < W.stock cs t :=
  Nat.lt_of_le_of_lt (Nat.zero_le _) (balances.rise_lowers dissipates mem comes.rises)

end

/-- Dissipated on, the family falls across a step by at least the number of formations
taking from it. -/
theorem Balances.runs_down (balances : L.Balances W) {cs : List C} {t : Nat}
    (dissipates : L.DissipatesOn cs t) : W.stock cs (t + 1) + L.takers cs t ≤ W.stock cs t :=
  (balances.on cs t).runs_down dissipates

/-- Balanced and dissipated on across each step of a stretch, the formations taking from the
family over the stretch number at most its stock at the start. Nothing is asked of the steps
outside the stretch. The loss law (`Amounts.losses_within`) at whole-number amounts. -/
theorem takers_within_on {cs : List C} :
    ∀ S N, (∀ t, S ≤ t → t < S + N → L.BalancesOn W cs t) →
      (∀ t, S ≤ t → t < S + N → L.DissipatesOn cs t) →
      W.stock cs (S + N) + total (steps S N) (L.takers cs) ≤ W.stock cs S :=
  fun S N balances dissipates =>
    Eq.subst (motive := fun x => W.stock cs (S + N) + x ≤ W.stock cs S)
      (Amounts.whole_sum (L.takers cs) N S)
      (Amounts.losses_within (M := Amounts.whole) (s := W.stock cs) (d := L.takers cs) N
        fun t from_ below => (balances t from_ below).runs_down (dissipates t from_ below))

/-- Dissipated on from step `S`, the formations taking from the family over any later
stretch of steps number at most its stock at `S`. -/
theorem Balances.takers_within (balances : L.Balances W) {cs : List C} :
    ∀ S N, (∀ t, S ≤ t → L.DissipatesOn cs t) →
      W.stock cs (S + N) + total (steps S N) (L.takers cs) ≤ W.stock cs S :=
  fun S N dissipates => takers_within_on S N (fun t _ _ => balances.on cs t)
    fun t after _ => dissipates t after

/-- Balanced and dissipated on from some step, taking from the family does not recur.
Nothing is asked of the steps before. The family law (`Amounts.family_rests_of_archimedean`) at
whole-number amounts: each formation taking from a family dissipated on loses at least one unit. -/
theorem taking_not_recurring_from {cs : List C} {T : Nat}
    (balances : ∀ t, T ≤ t → L.BalancesOn W cs t) (dissipates : ∀ t, T ≤ t → L.DissipatesOn cs t) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers cs t :=
  Amounts.family_rests_of_archimedean Amounts.whole_archimedean (s := W.stock cs)
    (u := L.uptake cs) (r := L.replenishment cs) (ε := 1) (P := fun t => 0 < L.takers cs t)
    (Nat.not_succ_le_zero 0)
    (fun t later => Nat.le_of_eq (balances t later).over)
    (fun t later => Nat.le_trans (Nat.le_add_right _ _) (dissipates t later).replenishment_takers)
    (fun t later takes =>
      Nat.le_trans (Nat.add_le_add_left takes _) (dissipates t later).replenishment_takers)

/-- Dissipated on from some step, taking from the family does not recur. -/
theorem Balances.taking_not_recurring (balances : L.Balances W) {cs : List C} {T : Nat}
    (dissipates : ∀ t, T ≤ t → L.DissipatesOn cs t) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers cs t :=
  taking_not_recurring_from (fun t _ => balances.on cs t) dissipates

/-- A formation taking from a family takes from every family containing it. -/
theorem takers_pos_of_sub {cs ds : List C} (within : ∀ c, c ∈ cs → c ∈ ds) {t : Nat}
    (takes : 0 < L.takers cs t) : 0 < L.takers ds t :=
  match total_pos (q := fun f => sign (total cs (L.take t f))) (L.present t) takes with
  | ⟨_, mem, positive⟩ => match total_pos cs (pos_of_sign positive) with
    | ⟨c, inside, taken⟩ =>
      total_pos_of_mem (q := fun f => sign (total ds (L.take t f))) mem
        (sign_pos (total_pos_of_mem (within c inside) taken))

/-- Taking from a family does not recur where, from some step on, a family containing it is
balanced and dissipated on. -/
theorem taking_not_recurring_within {cs ds : List C} (within : ∀ c, c ∈ cs → c ∈ ds) {T : Nat}
    (balances : ∀ t, T ≤ t → L.BalancesOn W ds t) (dissipates : ∀ t, T ≤ t → L.DissipatesOn ds t) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers cs t :=
  fun recurs => taking_not_recurring_from balances dissipates fun N => match recurs N with
    | ⟨t, later, takes⟩ => ⟨t, later, takers_pos_of_sub within takes⟩

/-- Under dissipation, a finite family from which formations take at arbitrarily late
steps is not closed from any step on, and neither is any finite family without
repetition containing it. -/
theorem Dissipative.opens (balances : L.Balances W) (dissipative : L.Dissipative)
    {cs ds : List C} (distinct : Distinct ds) (within : ∀ c, c ∈ cs → c ∈ ds)
    (recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers cs t) (T : Nat) :
    ¬ ∀ t, T ≤ t → L.ClosedAt ds t :=
  fun closed => taking_not_recurring_within within (fun t _ => balances.on ds t)
    (fun t later => dissipative ds t distinct (closed t later)) recurs

/-- If finitely many conditions are all there is, taking from any family does not recur
under dissipation. -/
theorem Dissipative.finite_taking_not_recurring (balances : L.Balances W)
    (dissipative : L.Dissipative)
    {all : List C} (distinct : Distinct all) (every : ∀ c, c ∈ all) (cs : List C) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers cs t :=
  fun recurs => dissipative.opens balances distinct (fun c _ => every c) recurs 0
    fun _ _ _ _ c outside => absurd (every c) outside

/-- More without end is taking at arbitrarily late steps. -/
theorem More.takers_recur {cs : List C} (more : L.More cs) :
    ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers cs t :=
  fun N => match more 1 with
  | ⟨T, many⟩ => ⟨N + T, Nat.le_add_right N T, many (N + T) (Nat.le_add_left T N)⟩

/-- So is the unceasing arising of formations that take from the family at their first
active step. -/
theorem takers_recur_of_arising {cs : List C}
    (arising : ∀ N, ∃ t f, N ≤ t ∧ L.ArisesTaking W cs t f) :
    ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers cs t :=
  fun N => match arising N with
  | ⟨t, _, later, _, present, takes⟩ =>
    ⟨t + 1, Nat.le_succ_of_le later,
      total_pos_of_mem (q := fun f => sign (total cs (L.take (t + 1) f))) present (sign_pos takes)⟩

/-- Under dissipation, more without end on a finite family needs exchange beyond it, and
beyond every finite family containing it, at arbitrarily late steps. -/
theorem More.opens (balances : L.Balances W) (dissipative : L.Dissipative) {cs ds : List C}
    (distinct : Distinct ds) (within : ∀ c, c ∈ cs → c ∈ ds) (more : L.More cs) (T : Nat) :
    ¬ ∀ t, T ≤ t → L.ClosedAt ds t :=
  dissipative.opens balances distinct within more.takers_recur T

/-- So does the unceasing arising of formations that take from it. -/
theorem opens_of_arising (balances : L.Balances W) (dissipative : L.Dissipative)
    {cs ds : List C} (distinct : Distinct ds) (within : ∀ c, c ∈ cs → c ∈ ds)
    (arising : ∀ N, ∃ t f, N ≤ t ∧ L.ArisesTaking W cs t f) (T : Nat) :
    ¬ ∀ t, T ≤ t → L.ClosedAt ds t :=
  dissipative.opens balances distinct within (takers_recur_of_arising arising) T

/-! ## Inflow -/

/-- If finitely many conditions are all there is, every step is enclosed around every
family. -/
theorem around_of_finite {all : List C} (distinct : Distinct all) (every : ∀ c, c ∈ all)
    (ds : List C) (t : Nat) : L.Around ds t :=
  ⟨all, distinct, fun c _ => every c, fun _ _ c outside => absurd (every c) outside⟩

/-- With equality of conditions decidable, a step enclosed by some family is enclosed
around every family: adjoin the family to it. -/
theorem Enclosed.around [DecidableEq C] {t : Nat} (enclosed : L.Enclosed t) (ds : List C) :
    L.Around ds t :=
  match enclosed with
  | ⟨es, distinct, closed⟩ => match adjoin_spec distinct ds with
    | ⟨distinct', left, right⟩ => ⟨adjoin ds es, distinct', left,
        fun f present c outside => closed f present c fun inside => outside (right c inside)⟩

/-- Without decided equality, a step enclosed by some family is not not enclosed around
every family: whether each member of the family lies in the enclosing one need only be
not refuted. -/
theorem Enclosed.around_not_not {t : Nat} (enclosed : L.Enclosed t) :
    ∀ ds : List C, ¬¬ L.Around ds t
  | [] => fun no => match enclosed with
    | ⟨es, distinct, closed⟩ => no ⟨es, distinct, fun _ mem => (nomatch mem), closed⟩
  | a :: ds => fun no => enclosed.around_not_not ds fun ⟨es, distinct, sub, closed⟩ =>
    have widen : (a ∈ es ∨ ¬ a ∈ es) → False := fun
      | .inl inside => no ⟨es, distinct, fun c mem => match mem_cons_cases mem with
          | .inl same => Eq.subst (motive := fun d => d ∈ es) same.symm inside
          | .inr mem => sub c mem, closed⟩
      | .inr outside => no ⟨a :: es, ⟨outside, distinct⟩, fun c mem =>
          match mem_cons_cases mem with
          | .inl same => Eq.subst (motive := fun d => d ∈ a :: es) same.symm (.head es)
          | .inr mem => .tail a (sub c mem),
        fun f present c out => closed f present c fun inside => out (.tail a inside)⟩
    widen (.inr fun inside => widen (.inl inside))

/-- A family without repetition enclosed around across a step, into which nothing beyond it
flows, is dissipated on across that step, where the families closed across that one step are
dissipated on. -/
theorem dissipatesOn_of_inward_at {t : Nat}
    (dissipative : ∀ es, Distinct es → L.ClosedAt es t → L.DissipatesOn es t) {ds : List C}
    (distinct : Distinct ds) (around : L.Around ds t) (inward : L.Inward ds t) :
    L.DissipatesOn ds t :=
  match around with
  | ⟨es, distinctE, sub, closed⟩ => fun f present =>
    match Nat.decLt 0 (total ds (L.give t f)) with
    | isFalse nothing =>
      Nat.le_trans (Nat.le_of_eq ((congrArg (· + _) (eq_zero_of_not_pos nothing)).trans
        (Nat.zero_add _))) (sign_le _)
    | isTrue gives =>
      have giveE : total ds (L.give t f) ≤ total es (L.give t f) :=
        total_le_of_support distinct fun c mem _ => sub c mem
      have takeE : total es (L.take t f) ≤ total ds (L.take t f) :=
        total_le_of_support distinctE fun c _ positive => inward f present gives c positive
      have dissipates := dissipative es distinctE closed
      have one : sign (total es (L.take t f)) = 1 := Nat.le_antisymm (sign_le_one _)
        (sign_pos (dissipates.takes_of_gives present (Nat.lt_of_lt_of_le gives giveE)))
      Nat.le_trans (Nat.add_le_add_left (sign_le_one _) _)
        (Nat.le_trans (Nat.add_le_add_right giveE 1)
          (Nat.le_trans (Nat.le_of_eq (congrArg (_ + ·) one.symm))
            (Nat.le_trans (dissipates f present) takeE)))

/-- Under dissipation, a family without repetition enclosed around across a step, into
which nothing beyond it flows, is dissipated on across that step. -/
theorem Dissipative.dissipatesOn_of_inward (dissipative : L.Dissipative) {ds : List C}
    (distinct : Distinct ds) {t : Nat} (around : L.Around ds t) (inward : L.Inward ds t) :
    L.DissipatesOn ds t :=
  dissipatesOn_of_inward_at (fun es => dissipative es t) distinct around inward

/-- Taking draws in, from some step on: where formations take from a finite family without
repetition at arbitrarily late steps, and from `T₀` on the family is balanced on, enclosed
around, and every family closed across each step is dissipated on, at arbitrarily late
steps some formation gives to the family and takes from a condition beyond it. -/
theorem taking_draws_in_from {ds : List C} (distinct : Distinct ds) {T₀ : Nat}
    (around : ∀ t, T₀ ≤ t → L.Around ds t) (balances : ∀ t, T₀ ≤ t → L.BalancesOn W ds t)
    (dissipative : ∀ t, T₀ ≤ t → ∀ es, Distinct es → L.ClosedAt es t → L.DissipatesOn es t)
    (recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers ds t) (N : Nat) :
    ¬ ∀ t, N ≤ t → L.Inward ds t :=
  fun inward => taking_not_recurring_from (T := N + T₀)
    (fun t later => balances t (Nat.le_trans (Nat.le_add_left T₀ N) later))
    (fun t later => dissipatesOn_of_inward_at
      (dissipative t (Nat.le_trans (Nat.le_add_left T₀ N) later)) distinct
      (around t (Nat.le_trans (Nat.le_add_left T₀ N) later))
      (inward t (Nat.le_trans (Nat.le_add_right N T₀) later))) recurs

/-- Taking draws in: under dissipation, where formations take from a finite family without
repetition at arbitrarily late steps and the family is enclosed around from some step on,
at arbitrarily late steps some formation gives to the family and takes from a condition
beyond it. -/
theorem taking_draws_in (balances : L.Balances W) (dissipative : L.Dissipative)
    {ds : List C} (distinct : Distinct ds) {T₀ : Nat} (around : ∀ t, T₀ ≤ t → L.Around ds t)
    (recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers ds t) (N : Nat) :
    ¬ ∀ t, N ≤ t → L.Inward ds t :=
  taking_draws_in_from distinct around (fun t _ => balances.on ds t)
    (fun t _ es => dissipative es t) recurs N

/-! ## Rising and coming to stand -/

/-- A member of a family dissipated on across the step rising lowers the family's stock:
whatever gives to it takes more from the family. -/
theorem rise_lowers_on (balances : L.Balances W) {ds : List C} {t : Nat}
    (dissipates : L.DissipatesOn ds t) {c : C} (mem : c ∈ ds) (rises : W.Rises t c) :
    W.stock ds (t + 1) < W.stock ds t :=
  (balances.on ds t).rise_lowers dissipates mem rises

/-- So does a member coming to stand. -/
theorem standing_lowers_on (balances : L.Balances W) {ds : List C} {t : Nat}
    (dissipates : L.DissipatesOn ds t) {c : C} (mem : c ∈ ds) (comes : W.ComesToStand t c) :
    W.stock ds (t + 1) < W.stock ds t :=
  rise_lowers_on balances dissipates mem comes.rises

/-- Under dissipation, a member of a family without repetition closed across the step
coming to stand lowers the family's stock. -/
theorem standing_lowers (balances : L.Balances W) (dissipative : L.Dissipative)
    {ds : List C} (distinct : Distinct ds) {t : Nat} (closed : L.ClosedAt ds t) {c : C}
    (mem : c ∈ ds) (comes : W.ComesToStand t c) : W.stock ds (t + 1) < W.stock ds t :=
  standing_lowers_on balances (dissipative ds t distinct closed) mem comes

/-- Members of a family balanced and dissipated on from some step on do not rise at
arbitrarily late steps. Nothing is asked of the steps before. -/
theorem rising_not_recurring_from {ds : List C} {T : Nat}
    (balances : ∀ t, T ≤ t → L.BalancesOn W ds t) (dissipates : ∀ t, T ≤ t → L.DissipatesOn ds t) :
    ¬ ∀ N, ∃ t c, N ≤ t ∧ c ∈ ds ∧ W.Rises t c :=
  fun rising => falls_not_recurring (W.stock ds) T
    (fun t later => Nat.le_trans (Nat.le_add_right _ _)
      ((balances t later).runs_down (dissipates t later)))
    fun N => match rising (N + T) with
    | ⟨t, _, later, mem, rises⟩ =>
      have from_ := Nat.le_trans (Nat.le_add_left T N) later
      ⟨t, Nat.le_trans (Nat.le_add_right N T) later,
        (balances t from_).rise_lowers (dissipates t from_) mem rises⟩

/-- Nor do they come to stand at arbitrarily late steps. -/
theorem standing_not_recurring_from {ds : List C} {T : Nat}
    (balances : ∀ t, T ≤ t → L.BalancesOn W ds t) (dissipates : ∀ t, T ≤ t → L.DissipatesOn ds t) :
    ¬ ∀ N, ∃ t c, N ≤ t ∧ c ∈ ds ∧ W.ComesToStand t c :=
  fun coming => rising_not_recurring_from balances dissipates (Web.rising_of_coming coming)

/-- Members of a family dissipated on from some step on do not rise at arbitrarily late
steps. -/
theorem rising_not_recurring_on (balances : L.Balances W) {ds : List C} {T : Nat}
    (dissipates : ∀ t, T ≤ t → L.DissipatesOn ds t) :
    ¬ ∀ N, ∃ t c, N ≤ t ∧ c ∈ ds ∧ W.Rises t c :=
  rising_not_recurring_from (fun t _ => balances.on ds t) dissipates

/-- Nor do they come to stand at arbitrarily late steps. -/
theorem standing_not_recurring_on (balances : L.Balances W) {ds : List C} {T : Nat}
    (dissipates : ∀ t, T ≤ t → L.DissipatesOn ds t) :
    ¬ ∀ N, ∃ t c, N ≤ t ∧ c ∈ ds ∧ W.ComesToStand t c :=
  standing_not_recurring_from (fun t _ => balances.on ds t) dissipates

/-- Under dissipation, a finite family without repetition whose members rise at
arbitrarily late steps is not closed from any step on. -/
theorem rising_opens (balances : L.Balances W) (dissipative : L.Dissipative)
    {ds : List C} (distinct : Distinct ds)
    (rising : ∀ N, ∃ t c, N ≤ t ∧ c ∈ ds ∧ W.Rises t c) (T : Nat) :
    ¬ ∀ t, T ≤ t → L.ClosedAt ds t :=
  fun closed => rising_not_recurring_on balances
    (fun t later => dissipative ds t distinct (closed t later)) rising

/-- So is one whose members come to stand at arbitrarily late steps. -/
theorem standing_opens (balances : L.Balances W) (dissipative : L.Dissipative)
    {ds : List C} (distinct : Distinct ds)
    (coming : ∀ N, ∃ t c, N ≤ t ∧ c ∈ ds ∧ W.ComesToStand t c) (T : Nat) :
    ¬ ∀ t, T ≤ t → L.ClosedAt ds t :=
  rising_opens balances dissipative distinct (Web.rising_of_coming coming) T

/-- Rising draws in, from some step on: as `taking_draws_in_from`, with members of the
family rising at arbitrarily late steps. -/
theorem rising_draws_in_from {ds : List C} (distinct : Distinct ds) {T₀ : Nat}
    (around : ∀ t, T₀ ≤ t → L.Around ds t) (balances : ∀ t, T₀ ≤ t → L.BalancesOn W ds t)
    (dissipative : ∀ t, T₀ ≤ t → ∀ es, Distinct es → L.ClosedAt es t → L.DissipatesOn es t)
    (rising : ∀ N, ∃ t c, N ≤ t ∧ c ∈ ds ∧ W.Rises t c) (N : Nat) :
    ¬ ∀ t, N ≤ t → L.Inward ds t :=
  fun inward => rising_not_recurring_from (T := N + T₀)
    (fun t later => balances t (Nat.le_trans (Nat.le_add_left T₀ N) later))
    (fun t later => dissipatesOn_of_inward_at
      (dissipative t (Nat.le_trans (Nat.le_add_left T₀ N) later)) distinct
      (around t (Nat.le_trans (Nat.le_add_left T₀ N) later))
      (inward t (Nat.le_trans (Nat.le_add_right N T₀) later))) rising

/-- Rising draws in: under dissipation, where members of a finite family without
repetition rise at arbitrarily late steps and the family is enclosed around from some step
on, at arbitrarily late steps some formation gives to the family and takes from a
condition beyond it. -/
theorem rising_draws_in (balances : L.Balances W) (dissipative : L.Dissipative)
    {ds : List C} (distinct : Distinct ds) {T₀ : Nat} (around : ∀ t, T₀ ≤ t → L.Around ds t)
    (rising : ∀ N, ∃ t c, N ≤ t ∧ c ∈ ds ∧ W.Rises t c) (N : Nat) :
    ¬ ∀ t, N ≤ t → L.Inward ds t :=
  rising_draws_in_from distinct around (fun t _ => balances.on ds t)
    (fun t _ es => dissipative es t) rising N

/-- So does coming to stand. -/
theorem standing_draws_in (balances : L.Balances W) (dissipative : L.Dissipative)
    {ds : List C} (distinct : Distinct ds) {T₀ : Nat} (around : ∀ t, T₀ ≤ t → L.Around ds t)
    (coming : ∀ N, ∃ t c, N ≤ t ∧ c ∈ ds ∧ W.ComesToStand t c) (N : Nat) :
    ¬ ∀ t, N ≤ t → L.Inward ds t :=
  rising_draws_in balances dissipative distinct around (Web.rising_of_coming coming) N

/-- If finitely many conditions are all there is, no condition rises at arbitrarily late
steps under dissipation. -/
theorem rising_not_recurring (balances : L.Balances W) (dissipative : L.Dissipative)
    {all : List C} (distinct : Distinct all) (every : ∀ c, c ∈ all) :
    ¬ ∀ N, ∃ t c, N ≤ t ∧ W.Rises t c :=
  fun rising => rising_opens balances dissipative distinct
    (fun N => match rising N with
      | ⟨t, c, later, rises⟩ => ⟨t, c, later, every c, rises⟩) 0
    fun _ _ _ _ c outside => absurd (every c) outside

/-- Nor does any come to stand at arbitrarily late steps. -/
theorem standing_not_recurring (balances : L.Balances W) (dissipative : L.Dissipative)
    {all : List C} (distinct : Distinct all) (every : ∀ c, c ∈ all) :
    ¬ ∀ N, ∃ t c, N ≤ t ∧ W.ComesToStand t c :=
  fun coming => rising_not_recurring balances dissipative distinct every fun N =>
    match coming N with
    | ⟨t, c, later, comes⟩ => ⟨t, c, later, comes.rises⟩

/-! ## Rising and falling in one exchange -/

/-- Across a step at which a family is balanced and dissipated on, its members fall by at
least as much as they rise, and by one more for each formation taking from the family. -/
theorem BalancesOn.falls_cover {ds : List C} {t : Nat} (balances : L.BalancesOn W ds t)
    (dissipates : L.DissipatesOn ds t) :
    risen ds (fun c s => W.level s c) t + L.takers ds t ≤ fallen ds (fun c s => W.level s c) t :=
  le_of_add_le_add_right (W.stock ds (t + 1)) (Nat.le_trans
    (Nat.le_of_eq ((Nat.add_comm _ _).trans
      ((congrArg (W.stock ds (t + 1) + ·) (Nat.add_comm _ _)).trans (Nat.add_assoc _ _ _).symm)))
    (Nat.le_trans (Nat.add_le_add_right (balances.runs_down dissipates) _)
      (Nat.le_of_eq ((family_over_stretch (fun c s => W.level s c) t 1 ds).symm.trans
        (Nat.add_comm _ _)))))

/-- Across a step at which a family is balanced and dissipated on, a formation taking from it
makes one of its members fall. -/
theorem BalancesOn.falls_of_taking {ds : List C} {t : Nat} (balances : L.BalancesOn W ds t)
    (dissipates : L.DissipatesOn ds t) (takes : 0 < L.takers ds t) :
    ∃ d, d ∈ ds ∧ W.Falls t d :=
  match total_pos (q := fun d => fall (fun s => W.level s d) t) ds (Nat.lt_of_lt_of_le takes
      (Nat.le_trans (Nat.le_add_left _ _) (balances.falls_cover dissipates))) with
  | ⟨d, mem, falls⟩ => ⟨d, mem, excess_pos.mp falls⟩

/-- An event at each of whose steps the family is balanced and dissipated on, and some
formation takes from it, depletes the family. -/
theorem depletes_at {ds : List C} {event : Nat → Prop}
    (taken : ∀ t, event t → L.BalancesOn W ds t ∧ L.DissipatesOn ds t ∧ 0 < L.takers ds t) :
    W.Depletes ds event :=
  fun t happens _ => match taken t happens with
  | ⟨balances, dissipates, takes⟩ => balances.falls_of_taking dissipates takes

/-- Rising and falling in one exchange, at the step: where a member of a family balanced and
dissipated on across a step rises, another member falls across it. -/
theorem BalancesOn.rise_with_fall {ds : List C} {t : Nat} (balances : L.BalancesOn W ds t)
    (dissipates : L.DissipatesOn ds t) {c : C} (mem : c ∈ ds) (rises : W.Rises t c) :
    ∃ d, d ∈ ds ∧ d ≠ c ∧ W.Falls t d :=
  match total_pos (q := fun d => fall (fun s => W.level s d) t) ds (Nat.lt_of_lt_of_le
      (Nat.lt_of_lt_of_le (excess_pos.mpr rises)
        (le_total_of_mem (q := fun d => rise (fun s => W.level s d) t) mem))
      (Nat.le_trans (Nat.le_add_right _ _) (balances.falls_cover dissipates))) with
  | ⟨d, mem', fell⟩ =>
    have falls : W.Falls t d := excess_pos.mp fell
    ⟨d, mem', fun same => Nat.lt_asymm rises (same ▸ falls), falls⟩

/-- Rising and falling in one exchange, read of formations, at the step: where a member of a
family balanced and dissipated on across a step rises, and its givers there are active and
whatever takes there is active and draws on what it takes from, an active formation gives
to it and takes from the family, and another member falls, taken from by an active
formation drawing on it. -/
theorem BalancesOn.rise_exchange {ds : List C} {t : Nat} (balances : L.BalancesOn W ds t)
    (dissipates : L.DissipatesOn ds t) {c : C} (mem : c ∈ ds) (rises : W.Rises t c)
    (acting : ∀ f, f ∈ L.present t → 0 < L.give t f c → W.active t f)
    (taking : ∀ f d, f ∈ L.present t → 0 < L.take t f d → W.active t f ∧ W.draws t f d) :
    (∃ f, f ∈ L.present t ∧ W.active t f ∧ 0 < L.give t f c ∧ 0 < total ds (L.take t f)) ∧
      ∃ d g, d ∈ ds ∧ d ≠ c ∧ W.Falls t d ∧
        g ∈ L.present t ∧ W.active t g ∧ W.draws t g d ∧ 0 < L.take t g d :=
  ⟨match total_pos (L.present t) (balances.rise_given mem rises) with
    | ⟨f, present, gives⟩ => ⟨f, present, acting f present gives, gives,
        dissipates.takes_of_gives present (total_pos_of_mem mem gives)⟩,
   match balances.rise_with_fall dissipates mem rises with
    | ⟨d, mem', other, falls⟩ => match total_pos (L.present t) (balances.fall_taken mem' falls) with
      | ⟨g, present, takes⟩ =>
        ⟨d, g, mem', other, falls, present, (taking g d present takes).1,
          (taking g d present takes).2, takes⟩⟩

/-- Across a step dissipated on, a family's members fall by at least as much as they rise,
and by one more for each formation taking from the family. -/
theorem Balances.falls_cover (balances : L.Balances W) {ds : List C} {t : Nat}
    (dissipates : L.DissipatesOn ds t) :
    risen ds (fun c s => W.level s c) t + L.takers ds t ≤ fallen ds (fun c s => W.level s c) t :=
  (balances.on ds t).falls_cover dissipates

/-- Across a step dissipated on, a formation taking from the family makes one of its
members fall, whether or not another rises. -/
theorem Balances.falls_of_taking (balances : L.Balances W) {ds : List C} {t : Nat}
    (dissipates : L.DissipatesOn ds t) (takes : 0 < L.takers ds t) :
    ∃ d, d ∈ ds ∧ W.Falls t d :=
  (balances.on ds t).falls_of_taking dissipates takes

/-- The depletion of `Becoming.Arising` follows: an event at each of whose steps the
family is dissipated on and some formation takes from it depletes the family. -/
theorem Balances.depletes (balances : L.Balances W) {ds : List C} {event : Nat → Prop}
    (taken : ∀ t, event t → L.DissipatesOn ds t ∧ 0 < L.takers ds t) : W.Depletes ds event :=
  depletes_at fun t happens => match taken t happens with
  | ⟨dissipates, takes⟩ => ⟨balances.on ds t, dissipates, takes⟩

/-- Rising and falling in one exchange: where a member of a family dissipated on across a
step rises, another member falls across the same step. -/
theorem rise_with_fall (balances : L.Balances W) {ds : List C} {t : Nat}
    (dissipates : L.DissipatesOn ds t) {c : C} (mem : c ∈ ds) (rises : W.Rises t c) :
    ∃ d, d ∈ ds ∧ d ≠ c ∧ W.Falls t d :=
  (balances.on ds t).rise_with_fall dissipates mem rises

/-- So does a member coming to stand. -/
theorem standing_with_fall (balances : L.Balances W) {ds : List C} {t : Nat}
    (dissipates : L.DissipatesOn ds t) {c : C} (mem : c ∈ ds) (comes : W.ComesToStand t c) :
    ∃ d, d ∈ ds ∧ d ≠ c ∧ W.Falls t d :=
  rise_with_fall balances dissipates mem comes.rises

/-- Under dissipation, a member of a family without repetition rising across a step while
no member falls shows the family open across the step: some formation taking part
exchanges with a condition outside it. -/
theorem rise_alone_opens (balances : L.Balances W) (dissipative : L.Dissipative)
    {ds : List C} (distinct : Distinct ds) {t : Nat} {c : C} (mem : c ∈ ds)
    (rises : W.Rises t c) (still : ∀ d, d ∈ ds → ¬ W.Falls t d) : ¬ L.ClosedAt ds t :=
  fun closed => match rise_with_fall balances (dissipative ds t distinct closed) mem rises with
  | ⟨d, mem', _, falls⟩ => still d mem' falls

/-- Rising and falling in one exchange, read of formations: in a balanced flow where only
active formations give and take, where a member of a family dissipated on across a step
rises, an active formation gives to it and takes from the family, and another member
falls, taken from by an active formation drawing on it. -/
theorem rise_exchange (balances : L.Balances W) (acting : L.Acting W) (taking : L.Taking W)
    {ds : List C} {t : Nat} (dissipates : L.DissipatesOn ds t) {c : C} (mem : c ∈ ds)
    (rises : W.Rises t c) :
    (∃ f, f ∈ L.present t ∧ W.active t f ∧ 0 < L.give t f c ∧ 0 < total ds (L.take t f)) ∧
      ∃ d g, d ∈ ds ∧ d ≠ c ∧ W.Falls t d ∧
        g ∈ L.present t ∧ W.active t g ∧ W.draws t g d ∧ 0 < L.take t g d :=
  (balances.on ds t).rise_exchange dissipates mem rises (fun f present gives =>
    acting t f c present gives) fun f d present takes => taking t f d present takes

end Flow

/-! ## A frontier of fuels -/

namespace Frontier

/-- A pool, and fuels, one for each step. -/
inductive Condition where
  | pool
  | fuel (n : Nat)

/-- A source, and growers, one arising at each step. -/
inductive Formation where
  | source
  | grower (i : Nat)

/-- One while the `n`th fuel is unburnt: up to step `n`. -/
def unburnt : Nat → Nat → Nat
  | _, 0 => 1
  | 0, _ + 1 => 0
  | n + 1, t + 1 => unburnt n t
termination_by structural _ t => t

/-- One at the step at which the `n`th fuel burns. -/
def burning : Nat → Nat → Nat
  | 0, 0 => 1
  | 0, _ + 1 => 0
  | _ + 1, 0 => 0
  | n + 1, t + 1 => burning n t
termination_by structural _ t => t

theorem burns : ∀ n t, unburnt n (t + 1) + burning n t = unburnt n t
  | 0, 0 => rfl
  | 0, _ + 1 => rfl
  | _ + 1, 0 => rfl
  | n + 1, t + 1 => burns n t

theorem burning_self : ∀ n, burning n n = 1
  | 0 => rfl
  | n + 1 => burning_self n

theorem burning_at : ∀ n t, 0 < burning n t → n = t
  | 0, 0, _ => rfl
  | 0, _ + 1, burnt => absurd burnt (Nat.lt_irrefl 0)
  | _ + 1, 0, burnt => absurd burnt (Nat.lt_irrefl 0)
  | n + 1, t + 1, burnt => congrArg (· + 1) (burning_at n t burnt)

/-- The growers arisen before step `t`. -/
def growers : Nat → List Formation
  | 0 => []
  | n + 1 => .grower n :: growers n

/-- Across the step from `t`, the source burns the `t`th fuel, `t + 1` units, and gives the
pool `t`; each of the `t` growers takes one unit from the pool. -/
def flow : Flow Formation Condition where
  present t := .source :: growers t
  take t f c := match f, c with
    | .source, .pool => 0
    | .source, .fuel n => (n + 1) * burning n t
    | .grower _, .pool => 1
    | .grower _, .fuel _ => 0
  give t f c := match f, c with
    | .source, .pool => t
    | .source, .fuel _ => 0
    | .grower _, _ => 0

/-- The pool holds nothing between steps; the `n`th fuel holds `n + 1` units until it
burns. The source is always active and draws on the fuel it burns; the `i`th grower is
active from step `i + 1` and draws on the pool. -/
def web : Web Formation Condition where
  level t c := match c with
    | .pool => 0
    | .fuel n => (n + 1) * unburnt n t
  active t f := match f with
    | .source => True
    | .grower i => i < t
  requires _ _ _ := False
  need _ _ _ := 0
  draws t f c := match f, c with
    | .source, .pool => False
    | .source, .fuel n => n = t
    | .grower i, .pool => i < t
    | .grower _, .fuel _ => False

theorem growers_take (t : Nat) :
    ∀ n, total (growers n) (fun f => flow.take t f .pool) = n
  | 0 => rfl
  | n + 1 => (congrArg (1 + ·) (growers_take t n)).trans (Nat.add_comm 1 n)

theorem growers_give (t : Nat) (c : Condition) :
    ∀ n, total (growers n) (fun f => flow.give t f c) = 0
  | 0 => rfl
  | n + 1 => (Nat.zero_add _).trans (growers_give t c n)

theorem growers_take_fuel (t m : Nat) :
    ∀ n, total (growers n) (fun f => flow.take t f (.fuel m)) = 0
  | 0 => rfl
  | n + 1 => (Nat.zero_add _).trans (growers_take_fuel t m n)

theorem balances : flow.Balances web
  | t, .pool => show 0 + (0 + total (growers t) _) = 0 + (t + total (growers t) _) from
      (congrArg (fun x => 0 + (0 + x)) (growers_take t t)).trans
        ((congrArg (0 + ·) ((Nat.zero_add t).trans (Nat.add_zero t).symm)).trans
          (congrArg (fun x => 0 + (t + x)) (growers_give t .pool t)).symm)
  | t, .fuel n => show (n + 1) * unburnt n (t + 1) + ((n + 1) * burning n t + total (growers t) _)
        = (n + 1) * unburnt n t + (0 + total (growers t) _) from
      (congrArg (fun x => (n + 1) * unburnt n (t + 1) + ((n + 1) * burning n t + x))
        (growers_take_fuel t n t)).trans
      ((Nat.left_distrib (n + 1) _ _).symm.trans
      ((congrArg ((n + 1) * ·) (burns n t)).trans
      ((Nat.add_zero _).symm.trans
        (congrArg ((n + 1) * unburnt n t + ·) ((growers_give t (.fuel n) t).symm.trans
          (Nat.zero_add _).symm)))))

/-- Every family without repetition closed across a step is dissipated on: the source gives
the pool `t` and burns `t + 1`; the growers give nothing. -/
theorem dissipative : flow.Dissipative
  | ds, t, distinct, closed, f, mem => match f, mem with
    | .grower _, _ => Nat.le_trans (Nat.le_of_eq ((congrArg (· + _) (total_zero ds)).trans
        (Nat.zero_add _))) (sign_le _)
    | .source, mem =>
      have gives : total ds (flow.give t .source) ≤ t :=
        total_le_at (q := flow.give t .source) (a := .pool) (fun c given => match c, given with
          | .pool, _ => rfl
          | .fuel _, given => absurd given (Nat.lt_irrefl 0)) distinct
      have burnt : flow.take t .source (.fuel t) = t + 1 :=
        (congrArg ((t + 1) * ·) (burning_self t)).trans (Nat.mul_one _)
      match Nat.decLe (total ds (flow.give t .source) + sign (total ds (flow.take t .source)))
          (total ds (flow.take t .source)) with
      | isTrue le => le
      | isFalse not => absurd (fun inside : Condition.fuel t ∈ ds => not
          (Nat.le_trans (Nat.add_le_add gives (sign_le_one _))
            (Nat.le_trans (Nat.le_of_eq burnt.symm) (le_total_of_mem inside))))
          fun outside => Nat.noConfusion (burnt.symm.trans (closed .source mem (.fuel t) outside).1)

theorem takers_pool (t : Nat) : flow.takers [.pool] t = t :=
  (Nat.zero_add _).trans (go t)
where
  go : ∀ n, count (growers n) (fun f => total [.pool] (flow.take t f)) = n
    | 0 => rfl
    | n + 1 => (congrArg (1 + ·) (go n)).trans (Nat.add_comm 1 n)

/-- Ever more growers take from the pool. -/
theorem more : flow.More [.pool] :=
  fun K => ⟨K, fun t later => Nat.le_trans later (Nat.le_of_eq (takers_pool t).symm)⟩

/-- Balanced, dissipative and more without end: every finite family without repetition
containing the pool is open at arbitrarily late steps, so the fuels the source burns are
not contained in any finite family. -/
theorem frontier {ds : List Condition} (distinct : Distinct ds) (pool : Condition.pool ∈ ds)
    (T : Nat) : ¬ ∀ t, T ≤ t → flow.ClosedAt ds t :=
  Flow.More.opens balances dissipative distinct
    (fun c inside => match c, inside with | .pool, _ => pool) more T

/-- Across the step from `t`, the frontier's exchange lies within the pool and the `t`th
fuel. -/
theorem closed (t : Nat) : flow.ClosedAt [.pool, .fuel t] t :=
  fun f _ c outside => match f, c with
    | .source, .pool => absurd (.head _) outside
    | .grower _, .pool => absurd (.head _) outside
    | .source, .fuel n => ⟨show (n + 1) * burning n t = 0 from
        match h : burning n t with
        | 0 => Nat.mul_zero (n + 1)
        | k + 1 => absurd (Eq.subst (motive := fun m => Condition.fuel m ∈ [.pool, .fuel t])
            (burning_at n t (Eq.subst (motive := fun b => 0 < b) h.symm
              (Nat.succ_pos k))).symm (.tail _ (.head _))) outside, rfl⟩
    | .grower _, .fuel _ => ⟨rfl, rfl⟩

theorem pool_fuel_distinct (t : Nat) : Distinct [Condition.pool, .fuel t] :=
  ⟨fun mem => match mem with | .tail _ no => (nomatch no), ⟨fun no => (nomatch no), trivial⟩⟩

/-- Every step is enclosed, by the pool and the fuel of the step. -/
theorem enclosed (t : Nat) : flow.Enclosed t :=
  ⟨[.pool, .fuel t], pool_fuel_distinct t, closed t⟩

/-- Every step is enclosed around the pool. -/
theorem around (t : Nat) : flow.Around [.pool] t :=
  ⟨[.pool, .fuel t], pool_fuel_distinct t,
   fun c mem => match c, mem with | _, .head _ => .head _, closed t⟩

/-- So taking from the pool draws in: at arbitrarily late steps a formation gives to the
pool and takes from beyond it, the source burning fuel. -/
theorem draws_in (N : Nat) : ¬ ∀ t, N ≤ t → flow.Inward [.pool] t :=
  Flow.taking_draws_in (ds := [Condition.pool]) balances dissipative
    ⟨fun no => (nomatch no), trivial⟩ (T₀ := 0) (fun t _ => around t) more.takers_recur N

/-- The flow is dissipative, and at every step after the first the source gives the pool
something while taking nothing from it: a formation giving to a family takes from it
only where the family is dissipated on, and the pool's family is not closed. -/
theorem gives_without_taking :
    flow.Dissipative ∧ ∀ t, 0 < total [Condition.pool] (flow.give (t + 1) .source) ∧
      total [Condition.pool] (flow.take (t + 1) .source) = 0 :=
  ⟨dissipative, fun t => ⟨Nat.succ_pos t, rfl⟩⟩

end Frontier

/-! ## The frontier with growers that depend on the pool -/

namespace Rooted

open Frontier (Condition Formation growers unburnt burning)

/-- `Frontier.flow` on a web whose pool holds one unit throughout, and whose growers
depend on it at need one while active. -/
def web : Web Formation Condition where
  level t c := match c with
    | .pool => 1
    | .fuel n => (n + 1) * unburnt n t
  active t f := match f with
    | .source => True
    | .grower i => i < t
  requires t f c := match f, c with
    | .grower i, .pool => i < t
    | .grower _, .fuel _ => False
    | .source, _ => False
  need _ _ _ := 1
  draws t f c := match f, c with
    | .source, .pool => False
    | .source, .fuel n => n = t
    | .grower i, .pool => i < t
    | .grower _, .fuel _ => False

theorem balances : Frontier.flow.Balances web
  | t, .pool => show 1 + (0 + total (growers t) _) = 1 + (t + total (growers t) _) from
      (congrArg (fun x => 1 + (0 + x)) (Frontier.growers_take t t)).trans
        ((congrArg (1 + ·) ((Nat.zero_add t).trans (Nat.add_zero t).symm)).trans
          (congrArg (fun x => 1 + (t + x)) (Frontier.growers_give t .pool t)).symm)
  | t, .fuel n => Frontier.balances t (.fuel n)

theorem growers_lt : ∀ t i, Formation.grower i ∈ growers t → i < t
  | n + 1, _, .head _ => Nat.lt_succ_self n
  | n + 1, i, .tail _ mem => Nat.lt_succ_of_lt (growers_lt n i mem)

theorem growers_listed : ∀ t i, i < t → Formation.grower i ∈ growers t
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | m + 1, i, lt => match Nat.lt_or_ge i m with
    | .inl below => .tail _ (growers_listed m i below)
    | .inr above => Eq.subst (motive := fun j => Formation.grower j ∈ growers (m + 1))
        (Nat.le_antisymm above (Nat.le_of_lt_succ lt)) (.head _)

theorem growers_distinct : ∀ t, Distinct (growers t)
  | 0 => trivial
  | n + 1 => ⟨fun mem => Nat.lt_irrefl n (growers_lt n n mem), growers_distinct n⟩

theorem source_fresh : ∀ t, ¬ Formation.source ∈ growers t
  | n + 1, .tail _ mem => source_fresh n mem

theorem present_distinct (t : Nat) : Distinct (Frontier.flow.present t) :=
  ⟨source_fresh t, growers_distinct t⟩

/-- The source and the growers taking part are the active formations, each listed once. -/
theorem census : web.Census Frontier.flow.present := fun t =>
  ⟨present_distinct t, fun f => match f with
    | .source => ⟨fun _ => .head _, fun _ => trivial⟩
    | .grower i => ⟨fun lt => .tail _ (growers_listed t i lt), fun mem => match mem with
        | .tail _ mem => growers_lt t i mem⟩⟩

theorem burning_pos : ∀ n t, 0 < (n + 1) * burning n t → n = t := fun n t positive =>
  match h : burning n t with
  | 0 => absurd (Eq.subst (motive := fun b => 0 < (n + 1) * b) h positive) (Nat.lt_irrefl 0)
  | _ + 1 => Frontier.burning_at n t (Eq.subst (motive := fun b => 0 < b) h.symm (Nat.succ_pos _))

theorem taking : Frontier.flow.Taking web := fun t f c mem takes => match f, c, mem, takes with
  | .source, .fuel n, _, takes => ⟨trivial, burning_pos n t takes⟩
  | .source, .pool, _, takes => absurd takes (Nat.lt_irrefl 0)
  | .grower i, .pool, .tail _ mem, _ => ⟨growers_lt t i mem, growers_lt t i mem⟩
  | .grower _, .fuel _, _, takes => absurd takes (Nat.lt_irrefl 0)

theorem acting : Frontier.flow.Acting web := fun _ f c _ gives => match f, c, gives with
  | .source, _, _ => trivial
  | .grower _, .pool, gives => absurd gives (Nat.lt_irrefl 0)
  | .grower _, .fuel _, gives => absurd gives (Nat.lt_irrefl 0)

theorem dependent : web.Dependent := fun _ f _ c depends => match f, c, depends with
  | .grower _, .pool, _ => Nat.le_refl 1
  | .grower _, .fuel _, h => (nomatch h)
  | .source, _, h => (nomatch h)

instance decActive (t : Nat) (f : Formation) : Decidable (web.active t f) :=
  match f with
  | .source => isTrue trivial
  | .grower i => Nat.decLt i t

/-- Each grower arises at its step and takes from the pool at its first active step. -/
theorem arises_taking (t : Nat) : Frontier.flow.ArisesTaking web [.pool] t (.grower t) :=
  ⟨⟨Nat.lt_irrefl t, Nat.lt_succ_self t⟩, .tail _ (.head _), Nat.zero_lt_one⟩

/-- With the growers depending on the pool, the frontier meets every premise of
`Flow.More.unceasing` together with balance, `Acting`, `Dependent` and dissipation: its
generation is unceasing, and every finite family without repetition containing the pool
is open at arbitrarily late steps, by `opens_of_arising` as well as by `More.opens`. -/
theorem rooted :
    Frontier.flow.Balances web ∧ Frontier.flow.Acting web ∧ Frontier.flow.Taking web ∧
    web.Dependent ∧ web.Census Frontier.flow.present ∧ Frontier.flow.Dissipative ∧
    Frontier.flow.More [.pool] ∧ web.Unceasing ∧
    ∀ {ds : List Condition}, Distinct ds → Condition.pool ∈ ds →
      ∀ T, ¬ ∀ t, T ≤ t → Frontier.flow.ClosedAt ds t :=
  ⟨balances, acting, taking, dependent, census, Frontier.dissipative, Frontier.more,
   Flow.More.unceasing census present_distinct taking Frontier.more,
   fun distinct pool T => Flow.opens_of_arising balances Frontier.dissipative distinct
     (fun c inside => match c, inside with | .pool, _ => pool)
     (fun N => ⟨N, .grower N, Nat.le_refl N, arises_taking N⟩) T⟩

end Rooted

/-! ## Any recurring uptake needs the frontier -/

namespace Lone

open Frontier (Condition unburnt burning)

/-- A source and one eater, both always active. -/
inductive Formation where
  | source
  | eater

/-- The source burns the `t`th fuel, two units, and gives the pool one; the eater takes one
unit from the pool. -/
def flow : Flow Formation Condition where
  present _ := [.source, .eater]
  take t f c := match f, c with
    | .source, .pool => 0
    | .source, .fuel n => 2 * burning n t
    | .eater, .pool => 1
    | .eater, .fuel _ => 0
  give _ f c := match f, c with
    | .source, .pool => 1
    | .source, .fuel _ => 0
    | .eater, _ => 0

/-- The pool holds nothing between steps; the `n`th fuel holds two units until it burns. -/
def web : Web Formation Condition where
  level t c := match c with
    | .pool => 0
    | .fuel n => 2 * unburnt n t
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws t f c := match f, c with
    | .source, .pool => False
    | .source, .fuel n => n = t
    | .eater, .pool => True
    | .eater, .fuel _ => False

theorem balances : flow.Balances web
  | _, .pool => rfl
  | t, .fuel n => show 2 * unburnt n (t + 1) + 2 * burning n t = 2 * unburnt n t from
      (Nat.left_distrib 2 _ _).symm.trans (congrArg (2 * ·) (Frontier.burns n t))

/-- Every family without repetition closed across a step is dissipated on: the source gives
the pool one unit and burns two. -/
theorem dissipative : flow.Dissipative
  | ds, t, distinct, closed, f, mem => match f, mem with
    | .eater, _ => Nat.le_trans (Nat.le_of_eq ((congrArg (· + _) (total_zero ds)).trans
        (Nat.zero_add _))) (sign_le _)
    | .source, mem =>
      have gives : total ds (flow.give t .source) ≤ 1 :=
        total_le_at (q := flow.give t .source) (a := .pool) (fun c given => match c, given with
          | .pool, _ => rfl
          | .fuel _, given => absurd given (Nat.lt_irrefl 0)) distinct
      have burnt : flow.take t .source (.fuel t) = 2 :=
        (congrArg (2 * ·) (Frontier.burning_self t)).trans (Nat.mul_one _)
      match Nat.decLe (total ds (flow.give t .source) + sign (total ds (flow.take t .source)))
          (total ds (flow.take t .source)) with
      | isTrue le => le
      | isFalse not => absurd (fun inside : Condition.fuel t ∈ ds => not
          (Nat.le_trans (Nat.add_le_add gives (sign_le_one _))
            (Nat.le_trans (Nat.le_of_eq burnt.symm) (le_total_of_mem inside))))
          fun outside => Nat.noConfusion (burnt.symm.trans (closed .source mem (.fuel t) outside).1)

/-- One formation takes from the pool at every step, nothing ever arises, and generation
is not more without end; the flow balances and is dissipative. -/
theorem lone :
    flow.Balances web ∧ flow.Dissipative ∧ (∀ t, flow.takers [.pool] t = 1) ∧
    (∀ t f, ¬ web.Arises t f) ∧ ¬ flow.More [.pool] :=
  ⟨balances, dissipative, fun _ => rfl, fun _ _ arises => arises.1 trivial,
   fun more => match more 2 with
    | ⟨T, many⟩ => Nat.not_succ_le_self 1 (many T (Nat.le_refl T))⟩

/-- Keeping one eater fed already reaches beyond every finite family: every finite family
without repetition containing the pool is open at arbitrarily late steps. -/
theorem frontier {ds : List Condition} (distinct : Distinct ds) (pool : Condition.pool ∈ ds)
    (T : Nat) : ¬ ∀ t, T ≤ t → flow.ClosedAt ds t :=
  Flow.Dissipative.opens (cs := [Condition.pool]) balances dissipative distinct
    (fun c inside => match c, inside with | .pool, _ => pool)
    (fun N => ⟨N, Nat.le_refl N, Nat.zero_lt_one⟩) T

/-- Across the step from `t`, the exchange lies within the pool and the `t`th fuel. -/
theorem closed (t : Nat) : flow.ClosedAt [.pool, .fuel t] t :=
  fun f _ c outside => match f, c with
    | .source, .pool => absurd (.head _) outside
    | .eater, .pool => absurd (.head _) outside
    | .source, .fuel n => ⟨show 2 * burning n t = 0 from
        match h : burning n t with
        | 0 => rfl
        | k + 1 => absurd (Eq.subst (motive := fun m => Condition.fuel m ∈ [.pool, .fuel t])
            (Frontier.burning_at n t (Eq.subst (motive := fun b => 0 < b) h.symm
              (Nat.succ_pos k))).symm (.tail _ (.head _))) outside, rfl⟩
    | .eater, .fuel _ => ⟨rfl, rfl⟩

/-- Every step is enclosed, by the pool and the fuel of the step. -/
theorem enclosed (t : Nat) : flow.Enclosed t :=
  ⟨[.pool, .fuel t], Frontier.pool_fuel_distinct t, closed t⟩

/-- So keeping the eater fed draws in: at arbitrarily late steps a formation gives to the
pool and takes from beyond it. -/
theorem draws_in (N : Nat) : ¬ ∀ t, N ≤ t → flow.Inward [.pool] t :=
  Flow.taking_draws_in (ds := [Condition.pool]) balances dissipative
    ⟨fun no => (nomatch no), trivial⟩ (T₀ := 0)
    (fun t _ => ⟨[.pool, .fuel t], Frontier.pool_fuel_distinct t,
      fun c mem => match c, mem with | _, .head _ => .head _, closed t⟩)
    (fun N => ⟨N, Nat.le_refl N, Nat.zero_lt_one⟩) N

/-- `gives_less` needs the family without repetition: the family listing the pool twice
and the fuel of the step is closed across the step, and the source gives it two units while
taking two. -/
theorem repeated_family (t : Nat) :
    flow.ClosedAt [.pool, .pool, .fuel t] t ∧ Formation.source ∈ flow.present t ∧
    total [Condition.pool, .pool, .fuel t] (flow.give t .source) = 2 ∧
    total [Condition.pool, .pool, .fuel t] (flow.take t .source) = 2 :=
  ⟨fun f _ c outside => match f, c with
    | .source, .pool => absurd (.head _) outside
    | .eater, .pool => absurd (.head _) outside
    | .source, .fuel n => ⟨show 2 * burning n t = 0 from
        match h : burning n t with
        | 0 => rfl
        | k + 1 => absurd (Eq.subst (motive := fun m =>
              Condition.fuel m ∈ [.pool, .pool, .fuel t])
            (Frontier.burning_at n t (Eq.subst (motive := fun b => 0 < b) h.symm
              (Nat.succ_pos k))).symm (.tail _ (.tail _ (.head _)))) outside, rfl⟩
    | .eater, .fuel _ => ⟨rfl, rfl⟩,
   .head _, rfl,
   show 0 + (0 + (2 * burning t t + 0)) = 2 from
     Eq.subst (motive := fun b => 0 + (0 + (2 * b + 0)) = 2) (Frontier.burning_self t).symm rfl⟩

end Lone

/-! ## Dissipation binds only enclosed steps -/

namespace Spray

/-- A sink exchanging with every auxiliary condition, a renewer, and a consumer. -/
inductive Formation where
  | sink
  | renewer
  | consumer

/-- Condition `0` is the pool; `n + 1` are auxiliary conditions. The sink takes one unit
from every auxiliary condition and gives it back; the renewer gives the pool one unit,
taking nothing; the consumer takes one unit from the pool. -/
def flow : Flow Formation Nat where
  present _ := [.sink, .renewer, .consumer]
  take _ f c := match f, c with
    | .sink, _ + 1 => 1
    | .sink, 0 => 0
    | .renewer, _ => 0
    | .consumer, 0 => 1
    | .consumer, _ + 1 => 0
  give _ f c := match f, c with
    | .sink, _ + 1 => 1
    | .sink, 0 => 0
    | .renewer, 0 => 1
    | .renewer, _ + 1 => 0
    | .consumer, _ => 0

/-- Every condition holds one unit; all are active; the consumer depends on the pool at
need one and draws on it; the sink draws on every auxiliary condition. -/
def web : Web Formation Nat where
  level _ _ := 1
  active _ _ := True
  requires _ f c := match f with
    | .consumer => c = 0
    | .sink | .renewer => False
  need _ _ _ := 1
  draws _ f c := match f, c with
    | .sink, _ + 1 => True
    | .sink, 0 => False
    | .renewer, _ => False
    | .consumer, 0 => True
    | .consumer, _ + 1 => False

/-- Every finite list of conditions misses one. -/
theorem fresh (cs : List Nat) : ¬ (total cs (fun c => c) + 1) ∈ cs :=
  fun mem => Nat.not_succ_le_self _ (le_total_of_mem (q := fun c => c) mem)

/-- No step is enclosed: the sink exchanges with a condition outside every finite
family. -/
theorem unenclosed (t : Nat) : ¬ flow.Enclosed t :=
  fun ⟨cs, _, closed⟩ => Nat.noConfusion ((closed .sink (.head _) _ (fresh cs)).1 : (1 : Nat) = 0)

/-- So dissipation holds vacuously. -/
theorem dissipative : flow.Dissipative :=
  fun cs t distinct closed => absurd ⟨cs, distinct, closed⟩ (unenclosed t)

/-- The flow balances, only active formations take and give, only from what they draw on,
activity needs support, and the flow is dissipative; no step is enclosed, and at every
step the renewer gives the pool one unit while taking nothing, and a formation takes from
the pool. -/
theorem spray :
    flow.Balances web ∧ flow.Acting web ∧ flow.Taking web ∧ web.Dependent ∧
    flow.Dissipative ∧ (∀ t, ¬ flow.Enclosed t) ∧
    (∀ t, 0 < flow.give t .renewer 0 ∧ ∀ c, flow.take t .renewer c = 0) ∧
    ∀ t, 0 < flow.takers [0] t :=
  ⟨fun _ c => match c with
    | 0 => rfl
    | _ + 1 => rfl,
   fun _ _ _ _ _ => trivial,
   fun _ f c _ takes => match f, c, takes with
    | .sink, _ + 1, _ => ⟨trivial, trivial⟩
    | .consumer, 0, _ => ⟨trivial, trivial⟩
    | .sink, 0, takes => absurd takes (Nat.lt_irrefl 0)
    | .renewer, _, takes => absurd takes (Nat.lt_irrefl 0)
    | .consumer, _ + 1, takes => absurd takes (Nat.lt_irrefl 0),
   fun _ f _ _ depends => match f, depends with
    | .consumer, _ => Nat.le_refl 1
    | .sink, h | .renewer, h => (nomatch h),
   dissipative, unenclosed,
   fun _ => ⟨Nat.zero_lt_one, fun _ => rfl⟩,
   fun _ => Nat.zero_lt_one⟩

end Spray

/-! ## The flows of `Becoming.Flow` are not dissipative -/

/-- With one condition, taking does not recur in a balanced, dissipative flow. -/
theorem Flow.Dissipative.one_taking_not_recurring {F : Type} {L : Flow F Unit} {W : Web F Unit}
    (balances : L.Balances W) (dissipative : L.Dissipative) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers [()] t :=
  dissipative.finite_taking_not_recurring balances (all := [()]) ⟨fun no => (nomatch no), trivial⟩
    (fun | () => .head []) [()]

/-- The expansion, the cycle, the pulse, the steady consumer, the repeated formation and the
oscillator are not dissipative: in each, taking from one condition recurs. -/
theorem witnesses_not_dissipative :
    ¬ Expansion.flow.Dissipative ∧ ¬ Cycle.flow.Dissipative ∧ ¬ Pulse.flow.Dissipative ∧
    ¬ Steady.flow.Dissipative ∧ ¬ Repeated.flow.Dissipative ∧ ¬ Oscillation.flow.Dissipative :=
  ⟨fun dissipative => dissipative.one_taking_not_recurring Expansion.more.1
     Expansion.more.2.2.2.2.2.2.takers_recur,
   fun dissipative => dissipative.one_taking_not_recurring Cycle.closed_more.1
     Cycle.closed_more.2.2.2.2.2.2.1.takers_recur,
   fun dissipative => dissipative.one_taking_not_recurring Pulse.pulsed.1
     Pulse.pulsed.2.2.2.1.takers_recur,
   fun dissipative => dissipative.one_taking_not_recurring Steady.steady.1
     fun N => ⟨N, Nat.le_refl N, Nat.zero_lt_one⟩,
   fun dissipative => dissipative.one_taking_not_recurring Repeated.more_without_arising.2.1
     Repeated.more_without_arising.2.2.2.2.1.takers_recur,
   fun dissipative => dissipative.one_taking_not_recurring Oscillation.not_more.1
     (Flow.takers_recur_of_arising (W := Oscillation.web) fun N =>
       match Oscillation.unceasing.2.2.2.1 N with
       | ⟨t, f, later, arises⟩ => ⟨t, f, later, Oscillation.takes.2 t f arises⟩)⟩

/-! ## Recurrence, stated twice

`Becoming.Horizon` and `Becoming.Change` each name recurrence, for the moves of a run of sequences
and for a finite family. This is the first module that imports both, and they are one notion. -/

end Becoming
