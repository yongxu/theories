import Becoming.Arising
import Becoming.Witnesses

/-!
# Flow: more generation needs more replenishment

`Becoming.Arising` reads whether generation ceases. Ren's words also say *more*: a
whole direction of unceasingly creating more 生. This module reads the conditions of an
unfolding as amounts that the formations taking part in each step take and give
(`Flow`), and states what unceasing and more generation need.

* A flow *balances* a web when every change of a condition's level is what the
  formations taking part take from it and give to it (`Balances`). Over a finite family
  of conditions, the family's total after a step, plus its uptake, equals its total
  before, plus its replenishment (`Balances.over`), and the same holds over any stretch
  of steps (`Balances.accumulates`). Adding amounts across conditions presupposes that
  their units are commensurable.
* Balance makes every change the work of a formation. In a balanced flow every rise is
  given to (`Balances.rise_given`), and where only active formations give, the premise
  `RenewedBy` of `Becoming.Arising` is a theorem (`Balances.renewedBy`). Every fall is
  taken from (`Balances.fall_taken`), and where only active formations take, some active
  formation drawing on a condition takes from it whenever it falls
  (`Balances.takenBy`).
* Recurring uptake needs recurring replenishment. In a balanced flow, positive uptake at
  arbitrarily late steps needs replenishment at arbitrarily late steps
  (`uptake_needs_replenishment`). Formations taking from the family at their first
  active step and arising at arbitrarily late steps are one case
  (`replenishment_recurs`, with formations giving to the family: `renewing_recurs`); a
  constant population of takers, with nothing arising, is another (`Steady`). The
  theorem uses arising only for the uptake it brings. Unlike the net rise of
  `Becoming.Arising`, this sees replenishment concurrent with drawing.
* Rising needs replenishment, whatever is taken: where members of a family rise at
  arbitrarily late steps, the family's replenishment recurs
  (`rising_needs_replenishment`). A condition *comes to stand* across a step when its
  standing rises from nothing (`Web.ComesToStand`), a rise (`Web.ComesToStand.rises`)
  given at least the new standing (`Balances.standing_given`), so coming to stand needs
  replenishment as well (`standing_needs_replenishment`). A condition can rise at every
  step without ever coming to stand (`Growing`). Where a formation is itself a condition
  standing exactly while it is active, its arising is such a coming to stand
  (`Becoming.Roles`).
* Generation is *more without end* when, for every number, from some step on at least
  that many formations take from the family (`More`). Amounts are natural numbers, so
  a formation taking takes at least one unit: uptake has a positive minimum. Over any
  stretch of steps from which at least `K` formations take, the family is then
  replenished by at least `K` per step, less its stock at the start
  (`Balances.replenished_over`), and more without end needs replenishment without
  bound: no bound holding from some step on bounds it
  (`More.replenishment_unbounded`). When each formation gives at most a fixed amount
  (`Capacity`), the number of formations giving grows in the same averaged sense
  (`Balances.renewers_over`) and has no eventual bound (`More.renewers_unbounded`); it
  can still be zero at infinitely many steps (`Pulse`). If uptake could become
  arbitrarily small, more takers would not need more replenishment (argued, not
  formalized: the core has natural numbers only).
* The premises are consistent with more without end: renewers and growers arise
  together at every step (`Expansion.more`). There the level never rises, so the net-rise
  premise of `Becoming.Arising` fails (`Expansion.undepleted`), while the flow form
  applies. Unceasing generation does not imply more without end: the oscillator arises again
  and again while at most one formation ever takes (`Oscillation.not_more`).
* The renewers can be the takers themselves: in a closed cycle each formation gives
  back what it takes, the family's total never changes, and generation is more without
  end with as many renewers as takers (`Cycle`). That recurring taking must be carried
  beyond every finite part of the unfolding needs dissipation: across a step whose
  exchange lies within finitely many conditions, a formation that gives takes more than
  it gives. `Becoming.Dissipation` states that premise and proves what it carries.

So, read through balanced flows: renewal can recur with nothing arising
(`Tide.renewal_without_arising`), unceasing generation does not imply more without end,
and the replenishment each needs grows from recurring to unbounded. `More` counts the
formations taking part in the flow that take; `Becoming.Population` ties them to the
active formations of the web and states when more implies unceasing generation. A
flow's `present` lists each formation taking part at a step once; that it records what
is actually taken and given is an application duty. The family of conditions and the
formations taking part at each step are finite. No ethical predicate, ranking or axiom
occurs. Diversity and complexity are not stated here.

The structure `Flow` is stated in `Becoming.World`, the base of the core.
-/

namespace Becoming

/-- One for a positive number, zero for zero. -/
def sign : Nat → Nat := Witnesses.profile [0] 1

/-- How many members of a finite list a quantity is positive at. -/
def count {α : Type} (as : List α) (q : α → Nat) : Nat :=
  total as fun a => sign (q a)

section Totals

variable {α β : Type}

theorem sign_le : ∀ n, sign n ≤ n
  | 0 => Nat.le_refl 0
  | n + 1 => Nat.succ_le_succ (Nat.zero_le n)

theorem eq_zero_of_not_pos : ∀ {n : Nat}, ¬ 0 < n → n = 0
  | 0, _ => rfl
  | n + 1, not => absurd (Nat.succ_pos n) not

theorem sign_le_one : ∀ n, sign n ≤ 1
  | 0 => Nat.zero_le 1
  | _ + 1 => Nat.le_refl 1

theorem le_mul_sign {g : Nat} : ∀ n, n ≤ g → n ≤ g * sign n
  | 0, _ => Nat.zero_le 0
  | _ + 1, le => Nat.le_trans le (Nat.le_of_eq (Nat.mul_one g).symm)

theorem total_le {p q : α → Nat} :
    ∀ as : List α, (∀ a, a ∈ as → p a ≤ q a) → total as p ≤ total as q
  | [], _ => Nat.le_refl 0
  | a :: as, le => Nat.add_le_add (le a (.head as)) (total_le as fun b mem => le b (.tail a mem))

theorem total_add (p q : α → Nat) :
    ∀ as : List α, total as (fun a => p a + q a) = total as p + total as q
  | [] => rfl
  | a :: as => (congrArg (p a + q a + ·) (total_add p q as)).trans
      (Nat.add_add_add_comm (p a) (q a) (total as p) (total as q))

theorem total_zero : ∀ as : List α, total as (fun _ => 0) = 0
  | [] => rfl
  | _ :: as => (Nat.zero_add _).trans (total_zero as)

theorem total_mul (g : Nat) (q : α → Nat) :
    ∀ as : List α, total as (fun a => g * q a) = g * total as q
  | [] => rfl
  | a :: as => (congrArg (g * q a + ·) (total_mul g q as)).trans
      (Nat.left_distrib g (q a) (total as q)).symm

/-- Totals over two finite lists may be taken in either order. -/
theorem total_swap (q : α → β → Nat) (bs : List β) :
    ∀ as : List α, total as (fun a => total bs (q a)) = total bs (fun b => total as fun a => q a b)
  | [] => (total_zero bs).symm
  | a :: as => (congrArg (total bs (q a) + ·) (total_swap q bs as)).trans
      (total_add (q a) (fun b => total as fun a' => q a' b) bs).symm

/-- A total over a mapped list is the total of the composed quantity. -/
theorem total_map (g : α → β) (q : β → Nat) :
    ∀ as : List α, total (as.map g) q = total as fun a => q (g a)
  | [] => rfl
  | a :: as => congrArg (q (g a) + ·) (total_map g q as)

/-- Quantities that agree everywhere have the same total. -/
theorem total_congr {p q : α → Nat} (same : ∀ a, p a = q a) :
    ∀ as : List α, total as p = total as q
  | [] => rfl
  | a :: as => (congrArg (· + total as p) (same a)).trans (congrArg (q a + ·) (total_congr same as))

/-- Each member counted once totals the number of members. -/
theorem total_ones : ∀ as : List α, total as (fun _ => 1) = as.length
  | [] => rfl
  | _ :: as => (Nat.add_comm 1 _).trans (congrArg (· + 1) (total_ones as))

theorem total_append (q : α → Nat) (bs : List α) :
    ∀ as : List α, total (as ++ bs) q = total as q + total bs q
  | [] => (Nat.zero_add _).symm
  | a :: as => (congrArg (q a + ·) (total_append q bs as)).trans (Nat.add_assoc _ _ _).symm

/-- A member at which a quantity is positive makes the total positive. -/
theorem total_pos_of_mem {q : α → Nat} {a : α} :
    ∀ {as : List α}, a ∈ as → 0 < q a → 0 < total as q
  | _ :: _, .head _, positive => Nat.lt_of_lt_of_le positive (Nat.le_add_right _ _)
  | b :: _, .tail _ mem, positive =>
    Nat.lt_of_lt_of_le (total_pos_of_mem mem positive) (Nat.le_add_left _ (q b))

/-- A member's value is at most the total. -/
theorem le_total_of_mem {q : α → Nat} {a : α} : ∀ {as : List α}, a ∈ as → q a ≤ total as q
  | _ :: _, .head _ => Nat.le_add_right _ _
  | b :: _, .tail _ mem => Nat.le_trans (le_total_of_mem mem) (Nat.le_add_left _ (q b))

/-- A positive total has a positive member. -/
theorem total_pos {q : α → Nat} : ∀ as : List α, 0 < total as q → ∃ a, a ∈ as ∧ 0 < q a
  | a :: as, pos => match h : q a with
    | 0 => match total_pos as (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
        ((congrArg (· + total as q) h).trans (Nat.zero_add (total as q))))) with
      | ⟨b, mem, positive⟩ => ⟨b, .tail a mem, positive⟩
    | n + 1 => ⟨a, .head as, h ▸ Nat.succ_pos n⟩

theorem count_le (q : α → Nat) (as : List α) : count as q ≤ total as q :=
  total_le as fun a _ => sign_le (q a)

/-- A quantity positive at no member totals zero. -/
theorem total_zero_of_count {q : α → Nat} : ∀ as : List α, count as q = 0 → total as q = 0
  | [], _ => rfl
  | a :: as, zero => match h : q a with
    | 0 =>
      have rest : count as q = 0 :=
        (Nat.zero_add _).symm.trans ((congrArg (fun n => sign n + count as q) h).symm.trans zero)
      (congrArg (· + total as q) h).trans ((Nat.zero_add _).trans (total_zero_of_count as rest))
    | _ + 1 => Nat.noConfusion ((Nat.add_comm (count as q) 1).trans
        ((congrArg (fun n => sign n + count as q) h).symm.trans zero))

theorem total_le_count {q : α → Nat} {g : Nat} (as : List α) (le : ∀ a, a ∈ as → q a ≤ g) :
    total as q ≤ g * count as q :=
  Nat.le_trans (total_le as fun a mem => le_mul_sign (q a) (le a mem))
    (Nat.le_of_eq (total_mul g (fun a => sign (q a)) as))

theorem steps_ge {q : Nat → Nat} {K : Nat} :
    ∀ T N, (∀ t, T ≤ t → K ≤ q t) → K * N ≤ total (steps T N) q
  | _, 0, _ => Nat.zero_le _
  | T, N + 1, ge => Nat.le_trans (Nat.le_of_eq (Nat.add_comm (K * N) K))
      (Nat.add_le_add (ge T (Nat.le_refl T))
        (steps_ge (T + 1) N fun t later => ge t (Nat.le_of_succ_le later)))

theorem steps_le {q : Nat → Nat} {R : Nat} :
    ∀ T N, (∀ t, T ≤ t → q t ≤ R) → total (steps T N) q ≤ R * N
  | _, 0, _ => Nat.zero_le _
  | T, N + 1, le => Nat.le_trans
      (Nat.add_le_add (le T (Nat.le_refl T))
        (steps_le (T + 1) N fun t later => le t (Nat.le_of_succ_le later)))
      (Nat.le_of_eq (Nat.add_comm R (R * N)))

end Totals

variable {F C : Type}

/-- A condition *comes to stand* across the step from `t`: no standing at `t`, a positive
standing after it. -/
def Web.ComesToStand (W : Web F C) (t : Nat) (c : C) : Prop :=
  ¬ 0 < W.level t c ∧ 0 < W.level (t + 1) c

/-- Coming to stand is the rise from nothing. -/
theorem Web.ComesToStand.rises {W : Web F C} {t : Nat} {c : C} (comes : W.ComesToStand t c) :
    W.Rises t c :=
  Nat.lt_of_le_of_lt (Nat.le_of_eq (eq_zero_of_not_pos comes.1)) comes.2

/-- So members of a family coming to stand at arbitrarily late steps rise at arbitrarily
late steps. -/
theorem Web.rising_of_coming {W : Web F C} {cs : List C}
    (coming : ∀ N, ∃ t c, N ≤ t ∧ c ∈ cs ∧ W.ComesToStand t c) :
    ∀ N, ∃ t c, N ≤ t ∧ c ∈ cs ∧ W.Rises t c :=
  fun N => match coming N with
    | ⟨t, c, later, mem, comes⟩ => ⟨t, c, later, mem, comes.rises⟩

/-- A number rises by what is added to it exactly when what is added is positive. -/
theorem lt_iff_pos {a g b : Nat} (sum : b = a + g) : a < b ↔ 0 < g :=
  ⟨fun lt => Nat.pos_of_ne_zero fun zero => Nat.lt_irrefl a (Nat.lt_of_lt_of_le lt
      (Nat.le_of_eq (sum.trans ((congrArg (a + ·) zero).trans (Nat.add_zero a))))),
   fun pos => Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right pos) (Nat.le_of_eq sum.symm)⟩

namespace Flow

variable (L : Flow F C)

/-- What the formations taking part take from a condition across the step from `t`. -/
def taken (t : Nat) (c : C) : Nat :=
  total (L.present t) fun f => L.take t f c

/-- What the formations taking part give to a condition across the step from `t`. -/
def given (t : Nat) (c : C) : Nat :=
  total (L.present t) fun f => L.give t f c

/-- Every change of a condition's level is what the formations taking part take from it
and give to it. -/
def Balances (W : Web F C) : Prop :=
  ∀ t c, W.level (t + 1) c + L.taken t c = W.level t c + L.given t c

/-- Only active formations give. -/
def Acting (W : Web F C) : Prop :=
  ∀ t f c, f ∈ L.present t → 0 < L.give t f c → W.active t f

/-- Only active formations take, and only from conditions they draw on. -/
def Taking (W : Web F C) : Prop :=
  ∀ t f c, f ∈ L.present t → 0 < L.take t f c → W.active t f ∧ W.draws t f c

/-- Whatever takes part and gives to `c` across the step from `t` is supported there. -/
def GiversSupported (W : Web F C) (t : Nat) (c : C) : Prop :=
  ∀ f, f ∈ L.present t → 0 < L.give t f c → W.Supported t f

/-- The family's uptake: everything taken from a finite family of conditions across the
step from `t`. -/
def uptake (cs : List C) (t : Nat) : Nat :=
  total cs (L.taken t)

/-- The family's replenishment: everything given to a finite family of conditions across
the step from `t`. -/
def replenishment (cs : List C) (t : Nat) : Nat :=
  total cs (L.given t)

/-- How many formations take from the family across the step from `t`. -/
def takers (cs : List C) (t : Nat) : Nat :=
  count (L.present t) fun f => total cs (L.take t f)

/-- How many formations give to the family across the step from `t`. -/
def renewers (cs : List C) (t : Nat) : Nat :=
  count (L.present t) fun f => total cs (L.give t f)

/-- Generation is more without end: for every number, from some step on at least that
many formations take from the family. -/
def More (cs : List C) : Prop :=
  ∀ K, ∃ T, ∀ t, T ≤ t → K ≤ L.takers cs t

/-- Each formation gives the family at most `g` across a step. -/
def Capacity (cs : List C) (g : Nat) : Prop :=
  ∀ t f, f ∈ L.present t → total cs (L.give t f) ≤ g

/-- The formation arises across the step from `t` and takes from the family at its first
active step. -/
def ArisesTaking (W : Web F C) (cs : List C) (t : Nat) (f : F) : Prop :=
  W.Arises t f ∧ f ∈ L.present (t + 1) ∧ 0 < total cs (L.take (t + 1) f)

variable {L} {W : Web F C}

/-- Where only active formations give and activity needs support, whatever gives to a
condition across any step is supported there. -/
theorem Acting.giversSupported (acting : L.Acting W) (dependent : W.Dependent) (t : Nat)
    (c : C) : L.GiversSupported W t c :=
  fun f present gives => dependent t f (acting t f c present gives)

/-- The family's total after a step, plus its uptake, is its total before, plus its
replenishment. -/
theorem Balances.over (balances : L.Balances W) : ∀ (cs : List C) (t : Nat),
    W.stock cs (t + 1) + L.uptake cs t = W.stock cs t + L.replenishment cs t
  | [], _ => rfl
  | c :: cs, t =>
    (Nat.add_add_add_comm (W.level (t + 1) c) (W.stock cs (t + 1))
      (L.taken t c) (L.uptake cs t)).trans
    ((congrArg (· + (W.stock cs (t + 1) + L.uptake cs t)) (balances t c)).trans
    ((congrArg (W.level t c + L.given t c + ·) (balances.over cs t)).trans
      (Nat.add_add_add_comm (W.level t c) (L.given t c) (W.stock cs t) (L.replenishment cs t))))

variable (L W)

/-- The flow balances on a family across the step from `t`: each member's level after the
step, with what is taken from it, is its level before, with what is given to it. -/
def BalancesOn (cs : List C) (t : Nat) : Prop :=
  ∀ c, c ∈ cs → W.level (t + 1) c + L.taken t c = W.level t c + L.given t c

variable {L W}

/-- Balance is balance on every family across every step. -/
theorem Balances.on (balances : L.Balances W) (cs : List C) (t : Nat) : L.BalancesOn W cs t :=
  fun c _ => balances t c

/-- And conversely. -/
theorem balances_iff_on : L.Balances W ↔ ∀ cs t, L.BalancesOn W cs t :=
  ⟨fun balances => balances.on, fun on t c => on [c] t c (.head [])⟩

/-- Balanced on a family, the family's total after the step, with its uptake, is its total
before, with its replenishment. -/
theorem BalancesOn.over : ∀ {cs : List C} {t : Nat}, L.BalancesOn W cs t →
    W.stock cs (t + 1) + L.uptake cs t = W.stock cs t + L.replenishment cs t
  | [], _, _ => rfl
  | c :: cs, t, balances =>
    (Nat.add_add_add_comm (W.level (t + 1) c) (W.stock cs (t + 1))
      (L.taken t c) (L.uptake cs t)).trans
    ((congrArg (· + (W.stock cs (t + 1) + L.uptake cs t)) (balances c (.head cs))).trans
    ((congrArg (W.level t c + L.given t c + ·)
        (BalancesOn.over fun d mem => balances d (.tail c mem))).trans
      (Nat.add_add_add_comm (W.level t c) (L.given t c) (W.stock cs t) (L.replenishment cs t))))

section

variable {cs : List C} {t : Nat} {c : C}

/-- With balance at `c`, a rise of `c` is given to. -/
theorem BalancesOn.rise_given (balances : L.BalancesOn W cs t) (mem : c ∈ cs)
    (rises : W.Rises t c) : 0 < L.given t c :=
  Nat.pos_of_ne_zero fun nothing => Nat.not_le_of_gt rises
    (Nat.le_trans (Nat.le_add_right _ (L.taken t c))
      (Nat.le_of_eq ((balances c mem).trans (congrArg (W.level t c + ·) nothing))))

/-- With balance at `c`, a fall of `c` is taken from. -/
theorem BalancesOn.fall_taken (balances : L.BalancesOn W cs t) (mem : c ∈ cs)
    (falls : W.Falls t c) : 0 < L.taken t c :=
  Nat.pos_of_ne_zero fun nothing => Nat.not_le_of_gt falls
    (Nat.le_trans (Nat.le_add_right _ (L.given t c))
      (Nat.le_of_eq ((balances c mem).symm.trans (congrArg (W.level (t + 1) c + ·) nothing))))

/-- Across a step at which nothing is taken from a family balanced on it, a member rises
exactly when some formation taking part gives to the family. -/
theorem BalancesOn.rises_iff_gives (balances : L.BalancesOn W cs t)
    (untaken : ∀ c, c ∈ cs → L.taken t c = 0) :
    (∃ c, c ∈ cs ∧ W.Rises t c) ↔ ∃ f c, f ∈ L.present t ∧ c ∈ cs ∧ 0 < L.give t f c :=
  have up : ∀ c, c ∈ cs → W.level (t + 1) c = W.level t c + L.given t c := fun c mem =>
    (congrArg (W.level (t + 1) c + ·) (untaken c mem)).symm.trans (balances c mem)
  ⟨fun ⟨c, mem, rises⟩ => match total_pos _ ((lt_iff_pos (up c mem)).mp rises) with
    | ⟨f, present, gives⟩ => ⟨f, c, present, mem, gives⟩,
   fun ⟨_, c, present, mem, gives⟩ => ⟨c, mem, (lt_iff_pos (up c mem)).mpr
      (Nat.lt_of_lt_of_le gives (le_total_of_mem (q := fun f => L.give t f c) present))⟩⟩

end

/-- The balance over a stretch of steps balanced on, each one: nothing is asked of the steps
outside the stretch. -/
theorem accumulates_on {cs : List C} :
    ∀ T N, (∀ t, T ≤ t → t < T + N → L.BalancesOn W cs t) →
      W.stock cs (T + N) + total (steps T N) (L.uptake cs) =
        W.stock cs T + total (steps T N) (L.replenishment cs) :=
  fun T N balances => balance_over_stretch_on (q := fun t => W.stock cs t) T N
    fun t from_ below => (balances t from_ below).over

/-- The balance over a stretch of steps. -/
theorem Balances.accumulates (balances : L.Balances W) (cs : List C) :
    ∀ T N, W.stock cs (T + N) + total (steps T N) (L.uptake cs) =
      W.stock cs T + total (steps T N) (L.replenishment cs) :=
  fun T N => accumulates_on T N fun t _ _ => balances.on cs t

/-- In a balanced flow every rise is given to. -/
theorem Balances.rise_given (balances : L.Balances W) {t : Nat} {c : C} (rises : W.Rises t c) :
    0 < L.given t c :=
  (balances.on [c] t).rise_given (.head []) rises

/-- Every rise is the work of a formation: in a balanced flow where only active
formations give, some active formation taking part gives to every condition that rises. -/
theorem Balances.renewedBy (balances : L.Balances W) (acting : L.Acting W) :
    W.RenewedBy fun t f c => f ∈ L.present t ∧ 0 < L.give t f c :=
  fun t c rises => match total_pos (L.present t) (balances.rise_given rises) with
    | ⟨f, mem, gives⟩ => ⟨f, acting t f c mem gives, mem, gives⟩

/-- In a balanced flow every fall is taken from. -/
theorem Balances.fall_taken (balances : L.Balances W) {t : Nat} {c : C} (falls : W.Falls t c) :
    0 < L.taken t c :=
  (balances.on [c] t).fall_taken (.head []) falls

/-- Every fall is the work of a formation: in a balanced flow where only active
formations take, some active formation taking part takes from every condition that falls,
and draws on it. -/
theorem Balances.takenBy (balances : L.Balances W) (taking : L.Taking W) {t : Nat} {c : C}
    (falls : W.Falls t c) :
    ∃ f, f ∈ L.present t ∧ 0 < L.take t f c ∧ W.active t f ∧ W.draws t f c :=
  match total_pos (L.present t) (balances.fall_taken falls) with
  | ⟨f, mem, takes⟩ => ⟨f, mem, takes, taking t f c mem takes⟩

/-- Formations taking from the family take at least one unit each. -/
theorem takers_le_uptake (cs : List C) (t : Nat) : L.takers cs t ≤ L.uptake cs t :=
  Nat.le_trans (count_le _ (L.present t))
    (Nat.le_of_eq (total_swap (fun f c => L.take t f c) cs (L.present t)))

/-- A formation taking part that takes from the family makes its uptake positive. -/
theorem uptake_pos {cs : List C} {t : Nat} {f : F} (present : f ∈ L.present t)
    (takes : 0 < total cs (L.take t f)) : 0 < L.uptake cs t :=
  Nat.lt_of_lt_of_le (total_pos_of_mem present takes)
    (Nat.le_of_eq (total_swap (fun f c => L.take t f c) cs (L.present t)))

/-- With no formation giving to the family, nothing replenishes it. -/
theorem replenishment_zero {cs : List C} {t : Nat} (nobody : L.renewers cs t = 0) :
    L.replenishment cs t = 0 :=
  (total_swap (fun c f => L.give t f c) (L.present t) cs).trans
    (total_zero_of_count (L.present t) nobody)

/-- With bounded capacity, the family's replenishment is bounded by the number of
renewers. -/
theorem replenishment_le {cs : List C} {g : Nat} (capacity : L.Capacity cs g) (t : Nat) :
    L.replenishment cs t ≤ g * L.renewers cs t :=
  Nat.le_trans (Nat.le_of_eq (total_swap (fun c f => L.give t f c) (L.present t) cs))
    (total_le_count (L.present t) (capacity t))

/-- Recurring uptake needs recurring replenishment, from a step on: where the family is
balanced on from `T` on, positive uptake at arbitrarily late steps needs replenishment at
some step from `T` on. -/
theorem uptake_needs_replenishment_from {cs : List C} {T : Nat}
    (balances : ∀ t, T ≤ t → L.BalancesOn W cs t)
    (uptake : ∀ N, ∃ t, N ≤ t ∧ 0 < L.uptake cs t) :
    ¬ ∀ t, T ≤ t → L.replenishment cs t = 0 :=
  fun none =>
    have step : ∀ t, T ≤ t → W.stock cs (t + 1) + L.uptake cs t = W.stock cs t :=
      fun t later => (balances t later).over.trans
        ((congrArg (W.stock cs t + ·) (none t later)).trans (Nat.add_zero _))
    falls_not_recurring (W.stock cs) T
      (fun t later => Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (step t later)))
      fun N => match uptake (N + T) with
      | ⟨t, later, positive⟩ =>
        ⟨t, Nat.le_trans (Nat.le_add_right N T) later,
          Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right positive)
            (Nat.le_of_eq (step t (Nat.le_trans (Nat.le_add_left T N) later)))⟩

/-- Recurring uptake needs recurring replenishment: in a balanced flow, positive uptake at
arbitrarily late steps needs replenishment at arbitrarily late steps. -/
theorem uptake_needs_replenishment {cs : List C} (balances : L.Balances W)
    (uptake : ∀ N, ∃ t, N ≤ t ∧ 0 < L.uptake cs t) (T : Nat) :
    ¬ ∀ t, T ≤ t → L.replenishment cs t = 0 :=
  uptake_needs_replenishment_from (fun t _ => balances.on cs t) uptake

/-- Unceasing generation of formations that take needs replenishment, from a step on:
where the family is balanced on from `T` on and formations taking from it at their first
active step arise at arbitrarily late steps, the family is replenished at some step from
`T` on. -/
theorem replenishment_recurs_from {cs : List C} {T : Nat}
    (balances : ∀ t, T ≤ t → L.BalancesOn W cs t)
    (arising : ∀ N, ∃ t f, N ≤ t ∧ L.ArisesTaking W cs t f) :
    ¬ ∀ t, T ≤ t → L.replenishment cs t = 0 :=
  uptake_needs_replenishment_from balances fun N => match arising N with
    | ⟨t, _, later, _, present, takes⟩ =>
      ⟨t + 1, Nat.le_succ_of_le later, uptake_pos present takes⟩

/-- And renewing activity recurs from that step on. -/
theorem renewing_recurs_from {cs : List C} {T : Nat}
    (balances : ∀ t, T ≤ t → L.BalancesOn W cs t)
    (arising : ∀ N, ∃ t f, N ≤ t ∧ L.ArisesTaking W cs t f) :
    ¬ ∀ t, T ≤ t → L.renewers cs t = 0 :=
  fun none => replenishment_recurs_from balances arising fun t later =>
    replenishment_zero (none t later)

/-- Unceasing generation of formations that take needs replenishment: when formations
taking from the family at their first active step arise at arbitrarily late steps, the
family is replenished at arbitrarily late steps. The arising enters only through the
uptake it brings. -/
theorem replenishment_recurs {cs : List C} (balances : L.Balances W)
    (arising : ∀ N, ∃ t f, N ≤ t ∧ L.ArisesTaking W cs t f) (T : Nat) :
    ¬ ∀ t, T ≤ t → L.replenishment cs t = 0 :=
  replenishment_recurs_from (fun t _ => balances.on cs t) arising

/-- Renewing activity recurs: under the same premises, formations give to the family at
arbitrarily late steps. When only active formations give, they are active. -/
theorem renewing_recurs {cs : List C} (balances : L.Balances W)
    (arising : ∀ N, ∃ t f, N ≤ t ∧ L.ArisesTaking W cs t f) (T : Nat) :
    ¬ ∀ t, T ≤ t → L.renewers cs t = 0 :=
  renewing_recurs_from (fun t _ => balances.on cs t) arising

/-- With balance at `c` across the step, a condition coming to stand is given at least its
new standing: the rise is from nothing, so all of it is given. -/
theorem BalancesOn.standing_given {cs : List C} {t : Nat} {c : C}
    (balances : L.BalancesOn W cs t) (mem : c ∈ cs) (comes : W.ComesToStand t c) :
    W.level (t + 1) c ≤ L.given t c :=
  Nat.le_trans (Nat.le_add_right _ (L.taken t c)) (Nat.le_of_eq ((balances c mem).trans
    ((congrArg (· + L.given t c) (eq_zero_of_not_pos comes.1)).trans (Nat.zero_add _))))

/-- In a balanced flow, a condition coming to stand is given at least its new standing:
the rise is from nothing, so all of it is given. -/
theorem Balances.standing_given (balances : L.Balances W) {t : Nat} {c : C}
    (comes : W.ComesToStand t c) : W.level (t + 1) c ≤ L.given t c :=
  (balances.on [c] t).standing_given (.head []) comes

/-- With balance at the member across the step, a member of a family rising replenishes
the family. -/
theorem BalancesOn.rise_replenishes {cs : List C} {t : Nat} {c : C}
    (balances : L.BalancesOn W cs t) (mem : c ∈ cs) (rises : W.Rises t c) :
    0 < L.replenishment cs t :=
  total_pos_of_mem mem (balances.rise_given mem rises)

/-- A member of a family rising replenishes the family. -/
theorem Balances.rise_replenishes (balances : L.Balances W) {cs : List C} {c : C}
    (mem : c ∈ cs) {t : Nat} (rises : W.Rises t c) : 0 < L.replenishment cs t :=
  (balances.on cs t).rise_replenishes mem rises

/-- So does a member coming to stand. -/
theorem Balances.standing_replenishes (balances : L.Balances W) {cs : List C} {c : C}
    (mem : c ∈ cs) {t : Nat} (comes : W.ComesToStand t c) : 0 < L.replenishment cs t :=
  balances.rise_replenishes mem comes.rises

/-- Rising carries the requirement itself, from a step on: where the family is balanced on
from `T` on and its members rise at arbitrarily late steps, it is replenished at some step
from `T` on, whatever is taken. -/
theorem rising_needs_replenishment_from {cs : List C} {T : Nat}
    (balances : ∀ t, T ≤ t → L.BalancesOn W cs t)
    (rising : ∀ N, ∃ t c, N ≤ t ∧ c ∈ cs ∧ W.Rises t c) :
    ¬ ∀ t, T ≤ t → L.replenishment cs t = 0 :=
  fun none => match rising T with
  | ⟨t, _, later, mem, rises⟩ => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
      ((balances t later).rise_replenishes mem rises) (Nat.le_of_eq (none t later)))

/-- And coming to stand, from that step on. -/
theorem standing_needs_replenishment_from {cs : List C} {T : Nat}
    (balances : ∀ t, T ≤ t → L.BalancesOn W cs t)
    (coming : ∀ N, ∃ t c, N ≤ t ∧ c ∈ cs ∧ W.ComesToStand t c) :
    ¬ ∀ t, T ≤ t → L.replenishment cs t = 0 :=
  rising_needs_replenishment_from balances (Web.rising_of_coming coming)

/-- Rising carries the requirement itself: where members of a family rise at arbitrarily
late steps, the family's replenishment recurs, whatever is taken. -/
theorem rising_needs_replenishment {cs : List C} (balances : L.Balances W)
    (rising : ∀ N, ∃ t c, N ≤ t ∧ c ∈ cs ∧ W.Rises t c) (T : Nat) :
    ¬ ∀ t, T ≤ t → L.replenishment cs t = 0 :=
  rising_needs_replenishment_from (fun t _ => balances.on cs t) rising

/-- Coming to stand, the rise from nothing, carries it as well: where members of a family
come to stand at arbitrarily late steps, the family's replenishment recurs. -/
theorem standing_needs_replenishment {cs : List C} (balances : L.Balances W)
    (coming : ∀ N, ∃ t c, N ≤ t ∧ c ∈ cs ∧ W.ComesToStand t c) (T : Nat) :
    ¬ ∀ t, T ≤ t → L.replenishment cs t = 0 :=
  standing_needs_replenishment_from (fun t _ => balances.on cs t) coming

/-- Over a stretch of `N` steps balanced on, from whose start on at least `K` formations
take, the family is replenished by at least `K` per step, less its stock at the start. -/
theorem replenished_over_on {cs : List C} {K S N : Nat}
    (balances : ∀ t, S ≤ t → t < S + N → L.BalancesOn W cs t)
    (many : ∀ t, S ≤ t → K ≤ L.takers cs t) :
    K * N ≤ W.stock cs S + total (steps S N) (L.replenishment cs) :=
  Nat.le_trans (steps_ge S N fun t later => Nat.le_trans (many t later) (takers_le_uptake cs t))
    (Nat.le_trans (Nat.le_add_left _ (W.stock cs (S + N)))
      (Nat.le_of_eq (accumulates_on S N balances)))

/-- Over any stretch of steps from which at least `K` formations take, the family is
replenished by at least `K` per step, less its stock at the start. -/
theorem Balances.replenished_over {cs : List C} {K S : Nat} (balances : L.Balances W)
    (many : ∀ t, S ≤ t → K ≤ L.takers cs t) (N : Nat) :
    K * N ≤ W.stock cs S + total (steps S N) (L.replenishment cs) :=
  replenished_over_on (fun t _ _ => balances.on cs t) many

/-- With bounded capacity, over a stretch of `N` steps balanced on, from whose start on at
least `K` formations take, the formations giving to the family number at least `K` per
step, less its stock at the start, up to the capacity. -/
theorem renewers_over_on {cs : List C} {g K S N : Nat}
    (balances : ∀ t, S ≤ t → t < S + N → L.BalancesOn W cs t) (capacity : L.Capacity cs g)
    (many : ∀ t, S ≤ t → K ≤ L.takers cs t) :
    K * N ≤ W.stock cs S + g * total (steps S N) (L.renewers cs) :=
  Nat.le_trans (replenished_over_on balances many)
    (Nat.add_le_add_left (Nat.le_trans (total_le _ fun t _ => replenishment_le capacity t)
      (Nat.le_of_eq (total_mul g (L.renewers cs) _))) _)

/-- With bounded capacity, over any stretch of steps from which at least `K` formations
take, the formations giving to the family number at least `K` per step, less its stock
at the start, up to the capacity. -/
theorem Balances.renewers_over {cs : List C} {g K S : Nat} (balances : L.Balances W)
    (capacity : L.Capacity cs g) (many : ∀ t, S ≤ t → K ≤ L.takers cs t) (N : Nat) :
    K * N ≤ W.stock cs S + g * total (steps S N) (L.renewers cs) :=
  renewers_over_on (fun t _ _ => balances.on cs t) capacity many

/-- More without end needs replenishment without bound, from a step on: where the family
is balanced on from `T₀` on, no bound holding from `T₀` on bounds its replenishment. The
whole-number instance of `Amounts.replenishment_unbounded`, with a least take of one: each taker
takes at least one. -/
theorem More.replenishment_unbounded_from {cs : List C} {T₀ : Nat}
    (balances : ∀ t, T₀ ≤ t → L.BalancesOn W cs t) (more : L.More cs) (R : Nat) :
    ¬ ∀ t, T₀ ≤ t → L.replenishment cs t ≤ R :=
  fun bounded => Amounts.replenishment_unbounded (M := Amounts.whole) Amounts.whole_archimedean
    (s := W.stock cs) (u := L.uptake cs) (ε := 1) (Nat.not_succ_le_zero 0)
    (fun t later => Nat.le_of_eq (balances t later).over)
    (fun m => match more m with
      | ⟨T, many⟩ => ⟨T, fun t later => Eq.subst (motive := fun x => x ≤ L.uptake cs t)
          (Amounts.whole_times_one m).symm
          (Nat.le_trans (many t later) (takers_le_uptake cs t))⟩)
    R (fun t later => Eq.subst (motive := fun x => L.replenishment cs t ≤ x)
      (Amounts.whole_times_one R).symm (bounded t later))

/-- More without end needs replenishment without bound: no bound holding from some step
on bounds the family's replenishment. -/
theorem More.replenishment_unbounded {cs : List C} (balances : L.Balances W)
    (more : L.More cs) (R T₀ : Nat) : ¬ ∀ t, T₀ ≤ t → L.replenishment cs t ≤ R :=
  more.replenishment_unbounded_from (fun t _ => balances.on cs t) R

/-- More without end needs renewers without bound, from a step on: where the family is
balanced on from `T₀` on and each formation gives at most a fixed amount, no bound holding
from `T₀` on bounds how many formations give. -/
theorem More.renewers_unbounded_from {cs : List C} {g T₀ : Nat}
    (balances : ∀ t, T₀ ≤ t → L.BalancesOn W cs t) (capacity : L.Capacity cs g)
    (more : L.More cs) (M : Nat) : ¬ ∀ t, T₀ ≤ t → L.renewers cs t ≤ M :=
  fun bounded => more.replenishment_unbounded_from balances (g * M) fun t later =>
    Nat.le_trans (replenishment_le capacity t) (Nat.mul_le_mul_left g (bounded t later))

/-- More without end needs renewers without bound: when each formation gives at most a
fixed amount, no bound holding from some step on bounds how many formations give. -/
theorem More.renewers_unbounded {cs : List C} {g : Nat} (balances : L.Balances W)
    (capacity : L.Capacity cs g) (more : L.More cs) (M T₀ : Nat) :
    ¬ ∀ t, T₀ ≤ t → L.renewers cs t ≤ M :=
  more.renewers_unbounded_from (fun t _ => balances.on cs t) capacity M

end Flow

/-! ## Rising without coming to stand -/

namespace Growing

/-- A condition rising by one at every step from one. -/
def web : Web Unit Unit := Witnesses.unrequired (fun t _ => t + 1) (fun _ _ => True)

/-- One formation gives the condition one unit at every step. -/
def flow : Flow Unit Unit := Witnesses.giving () 1

theorem balances : flow.Balances web := fun _ _ => rfl

/-- The condition rises at every step and never comes to stand, and it is given to at
every step: the requirement follows the rise, not the start from nothing. -/
theorem growing : flow.Balances web ∧ (∀ t, web.Rises t ()) ∧
    (∀ t, ¬ web.ComesToStand t ()) ∧ ∀ t, 0 < flow.given t () :=
  ⟨balances, fun t => Nat.lt_succ_self (t + 1), fun t comes => comes.1 (Nat.succ_pos t),
   fun t => balances.rise_given (Nat.lt_succ_self (t + 1))⟩

end Growing

/-! ## More without end on renewers that arise -/

namespace Expansion

inductive Kind where
  | renewer
  | grower

/-- The formations taking part in the step from `t`: the `i`th renewer and the `i`th
grower for each `i < t`. -/
def present : Nat → List (Kind × Nat)
  | 0 => []
  | n + 1 => (.renewer, n) :: (.grower, n) :: present n

/-- Each grower takes one unit and each renewer gives one. -/
def flow : Flow (Kind × Nat) Unit where
  present := present
  take _ f _ := match f.1 with
    | .renewer => 0
    | .grower => 1
  give _ f _ := match f.1 with
    | .renewer => 1
    | .grower => 0

/-- The `i`th renewer and grower arise across step `i`; growers depend on the condition
and draw on it. -/
def web : Web (Kind × Nat) Unit where
  level _ _ := 1
  active t f := f.2 < t
  requires t f _ := f.1 = .grower ∧ f.2 < t
  need _ _ _ := 1
  draws t f _ := f.1 = .grower ∧ f.2 < t

theorem taken_eq : ∀ t, flow.taken t () = t
  | 0 => rfl
  | n + 1 => (Nat.zero_add _).trans ((Nat.add_comm 1 _).trans (congrArg (· + 1) (taken_eq n)))

theorem given_eq : ∀ t, flow.given t () = t
  | 0 => rfl
  | n + 1 => (Nat.add_comm 1 _).trans (congrArg (· + 1)
      ((Nat.zero_add _).trans (given_eq n)))

theorem takers_eq : ∀ t, flow.takers [()] t = t
  | 0 => rfl
  | n + 1 => (Nat.zero_add _).trans ((Nat.add_comm 1 _).trans (congrArg (· + 1) (takers_eq n)))

theorem present_active : ∀ t f, f ∈ present t → f.2 < t
  | n + 1, _, .head _ => Nat.lt_succ_self n
  | n + 1, _, .tail _ (.head _) => Nat.lt_succ_self n
  | n + 1, f, .tail _ (.tail _ mem) => Nat.lt_succ_of_lt (present_active n f mem)

/-- Renewers and growers arise together at every step: the flow balances, only active
formations give, each gives at most one unit, generation is unceasing, and more without
end. -/
theorem more :
    flow.Balances web ∧ flow.Acting web ∧ flow.Capacity [()] 1 ∧ web.Dependent ∧
    (∀ t, web.Arises t (.renewer, t)) ∧ web.Unceasing ∧ flow.More [()] :=
  ⟨fun t _ => (congrArg (1 + ·) (taken_eq t)).trans (congrArg (1 + ·) (given_eq t).symm),
   fun t f _ mem _ => present_active t f mem,
   fun _ f _ => match f with
    | (.renewer, _) => Nat.le_refl 1
    | (.grower, _) => Nat.zero_le 1,
   fun _ _ _ _ _ => Nat.le_refl 1,
   fun t => ⟨Nat.lt_irrefl t, Nat.lt_succ_self t⟩,
   fun N => ⟨N, (.renewer, N), Nat.le_refl N, Nat.lt_irrefl N, Nat.lt_succ_self N⟩,
   fun K => ⟨K, fun t later => Nat.le_trans later (Nat.le_of_eq (takers_eq t).symm)⟩⟩

/-- Only active growers take, each from the condition it draws on, and every grower
takes at its first active step: the flow form `replenishment_recurs` applies. -/
theorem growers_take : flow.Taking web ∧ ∀ t, flow.ArisesTaking web [()] t (.grower, t) :=
  ⟨fun t f _ mem takes => match f, mem, takes with
    | (.renewer, _), _, takes => absurd takes (Nat.lt_irrefl 0)
    | (.grower, _), mem, _ => ⟨present_active t _ mem, rfl, present_active t _ mem⟩,
   fun t => ⟨⟨Nat.lt_irrefl t, Nat.lt_succ_self t⟩, .tail _ (.head _), Nat.zero_lt_one⟩⟩

/-- The level never rises: generation is unceasing, yet arising does not deplete the
family in the net sense of `Becoming.Arising`. Replenishment concurrent with drawing
is invisible to a net rise. -/
theorem undepleted :
    web.Unceasing ∧ (∀ t, ¬ web.Rises t ()) ∧
    ¬ web.Depletes [()] (fun t => ∃ f, web.Arises t f) :=
  ⟨more.2.2.2.2.2.1, fun _ rises => Nat.lt_irrefl 1 rises,
   fun depletes => match depletes 0 ⟨(.renewer, 0), Nat.lt_irrefl 0, Nat.zero_lt_one⟩
      (fun _ _ rises => Nat.lt_irrefl 1 rises) with
    | ⟨_, _, falls⟩ => Nat.lt_irrefl 1 falls⟩

end Expansion

/-! ## Recurring uptake with nothing arising -/

namespace Steady

/-- A consumer (`true`) and a renewer (`false`), both always active; the consumer depends
on the condition and draws on it. -/
def web : Web Bool Unit where
  level _ _ := 1
  active _ _ := True
  requires _ f _ := f = true
  need _ _ _ := 1
  draws _ f _ := f = true

/-- The consumer takes one unit at every step and the renewer gives one back. -/
def flow : Flow Bool Unit where
  present _ := [true, false]
  take _ f _ := match f with
    | true => 1
    | false => 0
  give _ f _ := match f with
    | true => 0
    | false => 1

/-- The flow balances, only active formations give and take, from what they draw on, and
activity needs support. Uptake is positive at every step and nothing ever arises, yet
replenishment is needed at arbitrarily late steps, as for unceasing generation of
takers: what needs it is the recurring uptake. -/
theorem steady :
    flow.Balances web ∧ flow.Acting web ∧ flow.Taking web ∧ web.Dependent ∧
    (∀ t, 0 < flow.uptake [()] t) ∧ (∀ t f, ¬ web.Arises t f) ∧
    ∀ T, ¬ ∀ t, T ≤ t → flow.replenishment [()] t = 0 :=
  have positive : ∀ t, 0 < flow.uptake [()] t := fun _ => Nat.zero_lt_one
  have balances : flow.Balances web := fun _ _ => rfl
  ⟨balances, fun _ _ _ _ _ => trivial,
   fun _ f _ _ takes => match f, takes with
    | true, _ => ⟨trivial, rfl⟩
    | false, takes => absurd takes (Nat.lt_irrefl 0),
   fun _ _ _ _ _ => Nat.le_refl 1, positive, fun _ _ arises => arises.1 trivial,
   Flow.uptake_needs_replenishment balances fun N => ⟨N, Nat.le_refl N, positive N⟩⟩

end Steady

/-! ## Unceasing generation is not yet more -/

namespace Oscillation

/-- The oscillator takes two when it is active, and the source gives one at every step. -/
def flow : Flow Formation Unit where
  present _ := [.source, .oscillator]
  take t f _ := match f with
    | .source => 0
    | .oscillator => 2 * (charge t - 1)
  give _ f _ := match f with
    | .source => 1
    | .oscillator => 0

theorem balances : ∀ t, web.level (t + 1) () + flow.taken t () = web.level t () + flow.given t ()
  | 0 => rfl
  | 1 => rfl
  | t + 2 => balances t

theorem takes_when_active : ∀ t, 2 ≤ charge t → 0 < 2 * (charge t - 1)
  | 0, _ => Nat.zero_lt_succ 1
  | 1, two => absurd two (Nat.not_succ_le_self 1)
  | t + 2, two => takes_when_active t two

theorem active_when_taking : ∀ t, 0 < 2 * (charge t - 1) → 2 ≤ charge t
  | 0, _ => Nat.le_refl 2
  | 1, takes => absurd takes (Nat.lt_irrefl 0)
  | t + 2, takes => active_when_taking t takes

/-- Only the active oscillator takes, from the condition it draws on, and it takes at its
first active step. -/
theorem takes : flow.Taking web ∧ ∀ t f, web.Arises t f → flow.ArisesTaking web [()] t f :=
  ⟨fun t f _ _ takes => match f, takes with
    | .source, takes => absurd takes (Nat.lt_irrefl 0)
    | .oscillator, takes => ⟨active_when_taking t takes, active_when_taking t takes⟩,
   fun t f arises => match f, arises with
    | .source, ⟨inactive, _⟩ => absurd trivial inactive
    | .oscillator, arises => ⟨arises, .tail _ (.head _), takes_when_active (t + 1) arises.2⟩⟩

theorem takers_le (t : Nat) : flow.takers [()] t ≤ 1 :=
  Nat.add_le_add (Nat.zero_le 0) (Nat.add_le_add (sign_le_one _) (Nat.zero_le 0))

/-- The oscillator arises again and again (`Oscillation.unceasing`), yet the flow balances, only
active formations give, and at most one formation ever takes: unceasing generation is
not more without end. -/
theorem not_more :
    flow.Balances web ∧ flow.Acting web ∧ flow.Capacity [()] 1 ∧ web.Unceasing ∧
    ¬ flow.More [()] :=
  ⟨fun t _ => balances t,
   fun _ f _ _ gives => match f, gives with
    | .source, _ => trivial,
   fun _ f _ => match f with
    | .source => Nat.le_refl 1
    | .oscillator => Nat.zero_le 1,
   unceasing.2.2.2.1,
   fun more => match more 2 with
    | ⟨T, many⟩ => Nat.not_succ_le_self 1 (Nat.le_trans (many T (Nat.le_refl T)) (takers_le T))⟩

end Oscillation

/-! ## The renewers can be the takers -/

namespace Cycle

/-- Formations `0`, …, `t - 1` take part in the step from `t`. -/
def present : Nat → List Nat
  | 0 => []
  | n + 1 => n :: present n

/-- Each formation taking part takes one unit and gives one back. -/
def flow : Flow Nat Unit := ⟨present, fun _ _ _ => 1, fun _ _ _ => 1⟩

/-- Formation `n` arises across step `n`, depends on the condition at need one, and draws
on it while active. -/
def web : Web Nat Unit where
  level _ _ := 1
  active t n := n < t
  requires t n _ := n < t
  need _ _ _ := 1
  draws t n _ := n < t

/-- `t` formations take part in the step from `t`. -/
theorem ones : ∀ t, total (present t) (fun _ => 1) = t
  | 0 => rfl
  | n + 1 => (congrArg (1 + ·) (ones n)).trans (Nat.add_comm 1 n)

theorem present_lt : ∀ t n, n ∈ present t → n < t
  | m + 1, _, .head _ => Nat.lt_succ_self m
  | m + 1, n, .tail _ mem => Nat.lt_succ_of_lt (present_lt m n mem)

/-- Each formation renews what it takes: the flow balances, only active formations take
and give, generation is unceasing and more without end, the family's total never
changes, and as many formations give as take. -/
theorem closed_more :
    flow.Balances web ∧ flow.Acting web ∧ flow.Taking web ∧ flow.Capacity [()] 1 ∧
    web.Dependent ∧ web.Unceasing ∧ flow.More [()] ∧
    (∀ t, web.stock [()] (t + 1) = web.stock [()] t) ∧
    ∀ t, flow.renewers [()] t = flow.takers [()] t :=
  ⟨fun t _ => congrArg (1 + ·) ((ones t).trans (ones t).symm),
   fun t n _ mem _ => present_lt t n mem,
   fun t n _ mem _ => ⟨present_lt t n mem, present_lt t n mem⟩,
   fun _ _ _ => Nat.le_refl 1,
   fun _ _ _ _ _ => Nat.le_refl 1,
   fun N => ⟨N, N, Nat.le_refl N, Nat.lt_irrefl N, Nat.lt_succ_self N⟩,
   fun K => ⟨K, fun t later => Nat.le_trans later (Nat.le_of_eq (ones t).symm)⟩,
   fun _ => rfl,
   fun _ => rfl⟩

end Cycle

/-! ## Renewers without eventual bound can be absent infinitely often -/

namespace Pulse

open Expansion (Kind)

/-- `n` formations of one kind. -/
def kind (k : Kind) : Nat → List (Kind × Nat)
  | 0 => []
  | n + 1 => (k, n) :: kind k n

theorem total_kind {q : Kind × Nat → Nat} {k : Kind} {v : Nat} (same : ∀ i, q (k, i) = v) :
    ∀ n, total (kind k n) q = n * v
  | 0 => (Nat.zero_mul v).symm
  | n + 1 => (congrArg (· + total (kind k n) q) (same n)).trans
      ((congrArg (v + ·) (total_kind same n)).trans
        ((Nat.add_comm v (n * v)).trans (Nat.succ_mul n v).symm))

def half : Nat → Nat
  | 0 => 0
  | 1 => 0
  | n + 2 => half n + 1

def even : Nat → Bool
  | 0 => true
  | 1 => false
  | n + 2 => even n

/-- A number at even steps, zero at odd steps. -/
def onEven : Bool → Nat → Nat
  | true, n => n
  | false, _ => 0

/-- `t` renewers at an even step `t`, none at odd steps. -/
def pulse (t : Nat) : Nat := onEven (even t) t

/-- Nothing stored at even steps; half the step at odd steps. -/
def stored (t : Nat) : Nat := onEven (even (t + 1)) (half t)

/-- At step `t`, `half t` growers each take one unit and `pulse t` renewers each give
one. -/
def flow : Flow (Kind × Nat) Unit where
  present t := kind .renewer (pulse t) ++ kind .grower (half t)
  take _ f _ := match f.1 with
    | .renewer => 0
    | .grower => 1
  give _ f _ := match f.1 with
    | .renewer => 1
    | .grower => 0

/-- Every formation is active; growers draw on the condition. -/
def web : Web (Kind × Nat) Unit where
  level t _ := stored t
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ f _ := f.1 = .grower

theorem half_even : ∀ m, half (2 * m) = m
  | 0 => rfl
  | m + 1 => congrArg (· + 1) (half_even m)

theorem half_odd : ∀ m, half (2 * m + 1) = m
  | 0 => rfl
  | m + 1 => congrArg (· + 1) (half_odd m)

theorem even_even : ∀ m, even (2 * m) = true
  | 0 => rfl
  | m + 1 => even_even m

theorem even_odd : ∀ m, even (2 * m + 1) = false
  | 0 => rfl
  | m + 1 => even_odd m

theorem half_ge : ∀ K t, 2 * K ≤ t → K ≤ half t
  | 0, _, _ => Nat.zero_le _
  | _ + 1, 0, le => absurd le (Nat.not_succ_le_zero _)
  | _ + 1, 1, le => absurd (Nat.le_of_succ_le_succ le) (Nat.not_succ_le_zero _)
  | K + 1, t + 2, le =>
    Nat.succ_le_succ (half_ge K t (Nat.le_of_succ_le_succ (Nat.le_of_succ_le_succ le)))

theorem parity : ∀ t, (∃ m, t = 2 * m) ∨ ∃ m, t = 2 * m + 1
  | 0 => .inl ⟨0, rfl⟩
  | t + 1 => match parity t with
    | .inl ⟨m, h⟩ => .inr ⟨m, congrArg (· + 1) h⟩
    | .inr ⟨m, h⟩ => .inl ⟨m + 1, congrArg (· + 1) h⟩

theorem taken_eq (t : Nat) : flow.taken t () = half t :=
  (total_append _ _ _).trans
    ((congr (congrArg (· + ·) (total_kind (v := 0) (fun _ => rfl) (pulse t)))
      (total_kind (v := 1) (fun _ => rfl) (half t))).trans
      ((Nat.zero_add _).trans (Nat.mul_one (half t))))

theorem given_eq (t : Nat) : flow.given t () = pulse t :=
  (total_append _ _ _).trans
    ((congr (congrArg (· + ·) (total_kind (v := 1) (fun _ => rfl) (pulse t)))
      (total_kind (v := 0) (fun _ => rfl) (half t))).trans (Nat.mul_one (pulse t)))

theorem takers_eq (t : Nat) : flow.takers [()] t = half t :=
  (total_append _ _ _).trans
    ((congr (congrArg (· + ·) (total_kind (v := 0) (fun _ => rfl) (pulse t)))
      (total_kind (v := 1) (fun _ => rfl) (half t))).trans
      ((Nat.zero_add _).trans (Nat.mul_one (half t))))

theorem renewers_eq (t : Nat) : flow.renewers [()] t = pulse t :=
  (total_append _ _ _).trans
    ((congr (congrArg (· + ·) (total_kind (v := 1) (fun _ => rfl) (pulse t)))
      (total_kind (v := 0) (fun _ => rfl) (half t))).trans (Nat.mul_one (pulse t)))

theorem balances (t : Nat) :
    web.level (t + 1) () + flow.taken t () = web.level t () + flow.given t () :=
  (congrArg (stored (t + 1) + ·) (taken_eq t)).trans
    (Eq.trans (match parity t with
      | .inl ⟨m, h⟩ => h ▸
        (show stored (2 * m + 1) + half (2 * m) = stored (2 * m) + pulse (2 * m) from
          (congr (congrArg (· + ·) ((congrArg (onEven · _) (even_even m)).trans (half_odd m)))
            (half_even m)).trans ((Nat.two_mul m).symm.trans ((Nat.zero_add _).symm.trans
              (congr (congrArg (· + ·) (congrArg (onEven · _) (even_odd m)))
                (congrArg (onEven · _) (even_even m))).symm)))
      | .inr ⟨m, h⟩ => h ▸
        (show stored (2 * m + 1 + 1) + half (2 * m + 1) =
            stored (2 * m + 1) + pulse (2 * m + 1) from
          (congr (congrArg (· + ·) (congrArg (onEven · _) (even_odd (m + 1))))
            (half_odd m)).trans ((Nat.zero_add m).trans ((Nat.add_zero m).symm.trans
              (congr (congrArg (· + ·) ((congrArg (onEven · _) (even_even (m + 1))).trans
                (half_odd m))) (congrArg (onEven · _) (even_odd m))).symm))))
      (congrArg (stored t + ·) (given_eq t).symm))

/-- The flow balances, every formation is active, each gives at most one unit, and
generation is more without end; yet at every odd step no formation gives and nothing
replenishes the family. Renewers without eventual bound are not ever more renewers at
every step. -/
theorem pulsed :
    flow.Balances web ∧ flow.Acting web ∧ flow.Capacity [()] 1 ∧ flow.More [()] ∧
    ∀ T, ∃ t, T ≤ t ∧ flow.renewers [()] t = 0 ∧ flow.replenishment [()] t = 0 :=
  ⟨fun t _ => balances t,
   fun _ _ _ _ _ => trivial,
   fun _ f _ => match f with
    | (.renewer, _) => Nat.le_refl 1
    | (.grower, _) => Nat.zero_le 1,
   fun K => ⟨2 * K, fun t later => Nat.le_trans (half_ge K t later)
     (Nat.le_of_eq (takers_eq t).symm)⟩,
   fun T =>
    have none : flow.renewers [()] (2 * T + 1) = 0 :=
      (renewers_eq _).trans (congrArg (onEven · _) (even_odd T))
    ⟨2 * T + 1, Nat.le_succ_of_le (Nat.le_mul_of_pos_left T Nat.zero_lt_two), none,
      Flow.replenishment_zero none⟩⟩

end Pulse

end Becoming
