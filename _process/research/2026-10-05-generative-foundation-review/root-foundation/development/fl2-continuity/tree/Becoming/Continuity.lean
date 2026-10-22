import Becoming.Dissipation

/-!
# Continuity: balance from conservation along a relation

Balance (`Flow.Balances`) says that every change of a level is what is taken from it and given
to it. This module says where such takings and givings come from when only the levels and a
relation among the relata are given: over finitely many relata, transfers between related relata
that balance a step exist exactly where the total is conserved on every family the relation
closes, and a law whose next level at a relatum reads only that relatum and those related to
it, conserving the total from every configuration, conserves it on every such family.

* **Families and the relation.** A family is read as a test `p` on the relata, the part of a
  quantity on it as `within p q`; two relata are adjacent where the relation holds one way or
  the other (`adj`), and a family is closed where adjacent listed relata lie both in it or both
  outside it (`Closes`).
* **Balance gives conservation on every closed family.** Transfers along the relation that
  balance a step (`Balancing`: something moves only between adjacent relata, and each listed
  relatum's level after the step with what it sends is its level before with what it receives)
  conserve the total on every family the relation closes (`conserved_of_balancing`).
* **Conservation on every closed family gives balance.** The transfers `route` are computed,
  one relatum at a time: its change is exchanged with the first relatum adjacent to it, and the
  rest are routed among themselves with two neighbours of the removed relatum taken as adjacent,
  their moves then passing through it. Wherever the total is conserved on every closed family,
  they balance the step along the relation (`route_balancing`), so the two are equivalent
  (`balancing_iff`). The relation is read as a computable test, and equality of relata is
  decided.
* **A law that reads only adjacent relata.** If a law's next level at each listed relatum is the
  same from two configurations that agree at it and at every listed relatum adjacent to it
  (`ReadsAdjacent`), and the law conserves the total over the listed relata from every
  configuration (`Conserves`), it conserves the total on every closed family
  (`conservedOn_of_law`), so every run of it balances along the relation through the routed
  transfers (`balancesOn_of_law`).
* **On a web.** Read as a flow in which each relatum takes from a condition what moves from it to
  the relatum and gives what moves the other way (`flow`), the routed transfers balance a web's
  levels on the listed relata at every step where they are conserved on every closed family, and
  every flow of transfers along the relation balancing them conserves them so
  (`balancesOn_iff_conserved`); with every relatum listed the flow balances
  (`balances_of_conserved`).
* **Teleport.** Swapping the levels of two relata conserves the total from every configuration
  and reads both relata. Along the empty relation each relatum is a closed family on which the
  total is not conserved, so no transfers along it balance the swap
  (`Teleport.no_transfers_apart`); along the full relation the routed transfers balance it
  (`Teleport.balanced_together`). Conservation of the whole total does not give balance along a
  relation that does not join where the amount moves.

The levels are whole numbers and the relata finitely many. The routed transfers depend on the
whole configuration, not only on what lies near each relation; that the flux of a conserved
quantity can be chosen local is known for cellular automata on lattices (Hattori and Takesue
1991; Pivato 2002) and is not shown here. A transfer may exceed what stands on its source, the
amount passing through within the step.
-/

namespace Becoming

namespace Continuity

variable {R : Type}

/-! ## Families and the relation -/

/-- Two relata adjacent under `rel`: related one way or the other. -/
def adj (rel : R → R → Bool) (a b : R) : Bool := rel a b || rel b a

theorem adj_symm (rel : R → R → Bool) (a b : R) : adj rel a b = adj rel b a := by
  unfold adj
  cases rel a b <;> cases rel b a <;> rfl

/-- The part of a quantity on a family: the quantity at its members, nothing elsewhere. -/
def within (p : R → Bool) (q : R → Nat) (x : R) : Nat :=
  match p x with
  | true => q x
  | false => 0

theorem within_true {p : R → Bool} {x : R} (q : R → Nat) (h : p x = true) : within p q x = q x := by
  unfold within; rw [h]

theorem within_false {p : R → Bool} {x : R} (q : R → Nat) (h : p x = false) : within p q x = 0 := by
  unfold within; rw [h]

theorem within_add (p : R → Bool) (q r : R → Nat) (x : R) :
    within p (fun y => q y + r y) x = within p q x + within p r x := by
  unfold within
  cases p x <;> rfl

/-- A family closed under the relation among the listed relata: adjacent listed relata lie both
in it or both outside it. -/
def Closes (rel : R → R → Bool) (us : List R) (p : R → Bool) : Prop :=
  ∀ a b, a ∈ us → b ∈ us → adj rel a b = true → p a = p b

/-- The total is conserved from `prev` to `next` on every family the relation closes. -/
def ConservedOn (rel : R → R → Bool) (us : List R) (prev next : R → Nat) : Prop :=
  ∀ p, Closes rel us p → total us (within p next) = total us (within p prev)

/-- Transfers that balance `prev` into `next` along the relation: something moves only between
adjacent listed relata, and each listed relatum's level after, with what it sends, is its level
before, with what it receives. -/
def Balancing (rel : R → R → Bool) (us : List R) (prev next : R → Nat) (move : R → R → Nat) :
    Prop :=
  (∀ a b, 0 < move a b → adj rel a b = true) ∧ (∀ a b, 0 < move a b → a ∈ us ∧ b ∈ us) ∧
    ∀ c, c ∈ us → next c + total us (move c) = prev c + total us (fun a => move a c)

/-! ## Balance gives conservation on every closed family -/

/-- What moves from `a` to `b` where both lie in the family. -/
def inside (p : R → Bool) (move : R → R → Nat) (a b : R) : Nat :=
  within p (fun a' => within p (move a') b) a

theorem inside_of_true {p : R → Bool} {move : R → R → Nat} {a b : R} (h : p a = true) :
    inside p move a b = within p (move a) b := by
  unfold inside; rw [within_true _ h]

theorem inside_of_false {p : R → Bool} {move : R → R → Nat} {a b : R} (h : p a = false) :
    inside p move a b = 0 := by
  unfold inside; rw [within_false _ h]

theorem within_sent {rel : R → R → Bool} {us : List R} {p : R → Bool} {move : R → R → Nat}
    (along : ∀ a b, 0 < move a b → adj rel a b = true) (closes : Closes rel us p) {c : R}
    (mem : c ∈ us) :
    within p (fun c => total us (move c)) c = total us (inside p move c) := by
  cases h : p c with
  | false =>
    rw [within_false _ h]
    exact (total_eq_zero fun b _ => inside_of_false h).symm
  | true =>
    rw [within_true _ h]
    refine total_congr_on fun b memb => ?_
    rw [inside_of_true h]
    cases hb : p b with
    | true => rw [within_true _ hb]
    | false =>
      rw [within_false _ hb]
      exact eq_zero_of_not_pos fun pos =>
        Bool.noConfusion (h.symm.trans ((closes c b mem memb (along c b pos)).trans hb))

theorem within_received {rel : R → R → Bool} {us : List R} {p : R → Bool} {move : R → R → Nat}
    (along : ∀ a b, 0 < move a b → adj rel a b = true) (closes : Closes rel us p) {c : R}
    (mem : c ∈ us) :
    within p (fun c => total us (fun a => move a c)) c = total us (fun a => inside p move a c) := by
  cases h : p c with
  | false =>
    rw [within_false _ h]
    exact (total_eq_zero fun a _ => by
      cases ha : p a with
      | false => exact inside_of_false ha
      | true => rw [inside_of_true ha, within_false _ h]).symm
  | true =>
    rw [within_true _ h]
    refine total_congr_on fun a mema => ?_
    cases ha : p a with
    | true => rw [inside_of_true ha, within_true _ h]
    | false =>
      rw [inside_of_false ha]
      exact eq_zero_of_not_pos fun pos =>
        Bool.noConfusion (ha.symm.trans ((closes a c mema mem (along a c pos)).trans h))

/-- **Balance gives conservation on every closed family.** Transfers along the relation that
balance a step conserve the total on every family the relation closes. -/
theorem conserved_of_balancing {rel : R → R → Bool} {us : List R} {prev next : R → Nat}
    {move : R → R → Nat} (balancing : Balancing rel us prev next move) :
    ConservedOn rel us prev next := by
  intro p closes
  obtain ⟨along, _, balances⟩ := balancing
  have each : total us (fun c => within p next c + within p (fun c => total us (move c)) c) =
      total us (fun c => within p prev c + within p (fun c => total us (fun a => move a c)) c) :=
    total_congr_on fun c mem => by
      unfold within
      cases p c
      · rfl
      · exact balances c mem
  rw [total_add, total_add] at each
  have sent : total us (within p (fun c => total us (move c))) =
      total us (fun c => total us (inside p move c)) :=
    total_congr_on fun c mem => within_sent along closes mem
  have received : total us (within p (fun c => total us (fun a => move a c))) =
      total us (fun c => total us (fun a => inside p move a c)) :=
    total_congr_on fun c mem => within_received along closes mem
  rw [sent, received, total_swap (inside p move) us us] at each
  exact Naturals.add_right_cancel each

/-! ## A law that reads only adjacent relata -/

/-- A law of levels reads only adjacent relata: its next level at a listed relatum is the same
from two configurations that agree there and at every listed relatum adjacent to it. -/
def ReadsAdjacent (rel : R → R → Bool) (us : List R) (law : (R → Nat) → R → Nat) : Prop :=
  ∀ a b x, x ∈ us → a x = b x → (∀ y, y ∈ us → adj rel x y = true → a y = b y) → law a x = law b x

/-- The law conserves the total over the listed relata from every configuration. -/
def Conserves (us : List R) (law : (R → Nat) → R → Nat) : Prop :=
  ∀ a, total us (law a) = total us a

/-- **Local conservation from global.** A law that reads only adjacent relata and conserves the
total from every configuration conserves it on every family the relation closes: from the
configuration with nothing anywhere it gives nothing anywhere, and from the part of a
configuration on a closed family it gives, on that family, what it gives from the whole and,
outside it, what it gives from nothing. -/
theorem conservedOn_of_law {rel : R → R → Bool} {us : List R} {law : (R → Nat) → R → Nat}
    (reads : ReadsAdjacent rel us law) (conserves : Conserves us law) (a : R → Nat) :
    ConservedOn rel us a (law a) := by
  intro p closes
  have zero : ∀ x, x ∈ us → law (fun _ => 0) x = 0 := fun x mem =>
    eq_zero_of_not_pos fun pos => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
      (total_pos_of_mem mem pos) (Nat.le_of_eq ((conserves _).trans (total_zero us))))
  have same : ∀ x, x ∈ us → within p (law a) x = law (within p a) x := fun x mem => by
    cases h : p x with
    | true =>
      rw [within_true _ h]
      refine reads a (within p a) x mem (within_true _ h).symm fun y memy hxy => ?_
      exact (within_true _ ((closes x y mem memy hxy).symm.trans h)).symm
    | false =>
      rw [within_false _ h]
      refine (zero x mem).symm.trans (reads (fun _ => 0) (within p a) x mem
        (within_false _ h).symm fun y memy hxy => ?_)
      exact (within_false _ ((closes x y mem memy hxy).symm.trans h)).symm
  exact (total_congr_on same).trans (conserves (within p a))

/-! ## Conservation on every closed family gives balance -/

/-- Two relata adjacent once `x` is removed: adjacent, or both adjacent to `x`. -/
def joined (rel : R → R → Bool) (x : R) (u v : R) : Bool :=
  adj rel u v || (adj rel u x && adj rel v x)

/-- What moves between relata adjacent under `rel`. -/
def direct (rel : R → R → Bool) (move : R → R → Nat) (a b : R) : Nat :=
  match adj rel a b with
  | true => move a b
  | false => 0

/-- What moves between relata not adjacent under `rel`, to be passed through a removed relatum. -/
def via (rel : R → R → Bool) (move : R → R → Nat) (a b : R) : Nat :=
  match adj rel a b with
  | true => 0
  | false => move a b

theorem direct_add_via (rel : R → R → Bool) (move : R → R → Nat) (a b : R) :
    direct rel move a b + via rel move a b = move a b := by
  unfold direct via
  cases adj rel a b
  · exact Nat.zero_add _
  · exact Nat.add_zero _

theorem joined_of_adj {rel : R → R → Bool} {x u v : R} (h : adj rel u v = true) :
    adj (joined rel x) u v = true := by
  have e : adj (joined rel x) u v =
      ((adj rel u v || (adj rel u x && adj rel v x)) || (adj rel v u || (adj rel v x && adj rel u x))) :=
    rfl
  rw [e, h]; rfl

theorem joined_of_both {rel : R → R → Bool} {x u v : R} (hu : adj rel u x = true)
    (hv : adj rel v x = true) : adj (joined rel x) u v = true := by
  have e : adj (joined rel x) u v =
      ((adj rel u v || (adj rel u x && adj rel v x)) || (adj rel v u || (adj rel v x && adj rel u x))) :=
    rfl
  rw [e, hu, hv]
  cases adj rel u v <;> rfl

/-- Two relata adjacent once `x` is removed but not adjacent before are both adjacent to `x`. -/
theorem joined_apart {rel : R → R → Bool} {x u v : R} (j : adj (joined rel x) u v = true)
    (h : adj rel u v = false) : adj rel u x = true ∧ adj rel v x = true := by
  have h' : adj rel v u = false := (adj_symm rel v u).trans h
  have e : adj (joined rel x) u v =
      ((adj rel u v || (adj rel u x && adj rel v x)) || (adj rel v u || (adj rel v x && adj rel u x))) :=
    rfl
  rw [e, h, h'] at j
  revert j
  cases adj rel u x <;> cases adj rel v x <;> decide

theorem not_eq_of_mem_rest {x a : R} {rest : List R} (distinct : Distinct (x :: rest))
    (mem : a ∈ rest) : a ≠ x := fun e => distinct.1 (e ▸ mem)

theorem add_pos_cases {a b : Nat} (pos : 0 < a + b) : 0 < a ∨ 0 < b := by
  cases a with
  | zero => exact .inr ((Nat.zero_add b) ▸ pos)
  | succ n => exact .inl (Nat.succ_pos n)

/-- A move that `via` passes on joins two neighbours of `x`. -/
theorem via_through {rel : R → R → Bool} {x : R} {rest : List R} {move : R → R → Nat}
    (along : ∀ a b, 0 < move a b → adj (joined rel x) a b = true)
    (support : ∀ a b, 0 < move a b → a ∈ rest ∧ b ∈ rest) {u v : R}
    (pos : 0 < via rel move u v) :
    adj rel u x = true ∧ adj rel v x = true ∧ u ∈ rest ∧ v ∈ rest := by
  cases h : adj rel u v with
  | true =>
    have z : via rel move u v = 0 := by unfold via; rw [h]
    rw [z] at pos; exact absurd pos (Nat.lt_irrefl 0)
  | false =>
    have m : via rel move u v = move u v := by unfold via; rw [h]
    rw [m] at pos
    have j := joined_apart (along u v pos) h
    exact ⟨j.1, j.2, (support u v pos).1, (support u v pos).2⟩

variable [DecidableEq R]

/-- An amount at one relatum, if there is one, and nothing elsewhere. -/
def edge : Option R → Nat → R → Nat
  | none, _, _ => 0
  | some y, v, a => if a = y then v else 0

/-- The moves on `x :: rest` from moves `move` among `rest`: moves between relata adjacent under
`rel` kept, moves between others passed through `x`, and the exchange of `x` with `y`, `gx` to
`x` and `lx` from it. -/
def expand (rel : R → R → Bool) (x : R) (rest : List R) (move : R → R → Nat) (y : Option R)
    (gx lx : Nat) (a b : R) : Nat :=
  if a = x then
    if b = x then 0 else total rest (fun u => via rel move u b) + edge y lx b
  else if b = x then total rest (fun v => via rel move a v) + edge y gx a
  else direct rel move a b

/-- **The routed transfers.** One relatum at a time: its change is exchanged with the first
relatum adjacent to it, whose level before and after carry that exchange into the rest, and
the rest are routed with the removed relatum's neighbours taken as adjacent. -/
def route : List R → (R → R → Bool) → (R → Nat) → (R → Nat) → R → R → Nat
  | [], _, _, _ => fun _ _ => 0
  | x :: rest, rel, prev, next =>
    expand rel x rest
      (route rest (joined rel x)
        (fun z => prev z + edge (rest.find? fun u => adj rel u x) (prev x - next x) z)
        (fun z => next z + edge (rest.find? fun u => adj rel u x) (next x - prev x) z))
      (rest.find? fun u => adj rel u x) (next x - prev x) (prev x - next x)

theorem route_cons (x : R) (rest : List R) (rel : R → R → Bool) (prev next : R → Nat) :
    route (x :: rest) rel prev next =
      expand rel x rest
        (route rest (joined rel x)
          (fun z => prev z + edge (rest.find? fun u => adj rel u x) (prev x - next x) z)
          (fun z => next z + edge (rest.find? fun u => adj rel u x) (next x - prev x) z))
        (rest.find? fun u => adj rel u x) (next x - prev x) (prev x - next x) := rfl

theorem edge_pos {y : Option R} {v : Nat} {a : R} (pos : 0 < edge y v a) :
    ∃ y', y = some y' ∧ a = y' := by
  cases y with
  | none => exact absurd pos (Nat.lt_irrefl 0)
  | some y' =>
    refine ⟨y', rfl, ?_⟩
    by_cases h : a = y'
    · exact h
    · have z : edge (some y') v a = 0 := by show (if a = y' then v else 0) = 0; rw [if_neg h]
      rw [z] at pos
      exact absurd pos (Nat.lt_irrefl 0)

theorem total_edge {y' : R} {v : Nat} :
    ∀ {l : List R}, Distinct l → y' ∈ l → total l (edge (some y') v) = v
  | [], _, mem => absurd mem ListTests.not_mem_nil
  | b :: l, ⟨fresh, distinct⟩, mem => by
    show (if b = y' then v else 0) + total l (edge (some y') v) = v
    by_cases h : b = y'
    · have rest : total l (edge (some y') v) = 0 := total_eq_zero fun a mema => by
        have ne : a ≠ y' := fun e => fresh (by rw [h, ← e]; exact mema)
        show (if a = y' then v else 0) = 0
        rw [if_neg ne]
      rw [if_pos h, rest, Nat.add_zero]
    · have inl : y' ∈ l := match mem with
        | .head _ => absurd rfl h
        | .tail _ m => m
      rw [if_neg h, Nat.zero_add]
      exact total_edge distinct inl

theorem within_edge_off {p : R → Bool} {y' a : R} {v : Nat} (e : a ≠ y') :
    within p (edge (some y') v) a = 0 := by
  unfold within
  cases p a
  · rfl
  · show (if a = y' then v else 0) = 0
    rw [if_neg e]

theorem total_within_edge {p : R → Bool} {y' : R} {v : Nat} {l : List R} (distinct : Distinct l)
    (mem : y' ∈ l) : total l (within p (edge (some y') v)) = within p (fun _ => v) y' := by
  cases h : p y' with
  | true =>
    rw [within_true _ h]
    refine (total_congr_on fun a _ => ?_).trans (total_edge distinct mem)
    by_cases e : a = y'
    · rw [e, within_true _ h]
    · rw [within_edge_off e]
      show 0 = (if a = y' then v else 0)
      rw [if_neg e]
  | false =>
    rw [within_false _ h]
    exact total_eq_zero fun a _ => by
      by_cases e : a = y'
      · rw [e, within_false _ h]
      · exact within_edge_off e

theorem rearrange {v e d m : Nat} (h : d + v = m) : v + e + d = m + e := by
  rw [Nat.add_right_comm, Nat.add_comm v d, h]

/-- What a relatum of `rest` sends under the expanded moves. -/
theorem expand_sent {rel : R → R → Bool} {x : R} {rest : List R} {move : R → R → Nat}
    {y : Option R} {gx lx : Nat} (distinct : Distinct (x :: rest)) {c : R} (mem : c ∈ rest) :
    total (x :: rest) (expand rel x rest move y gx lx c) = total rest (move c) + edge y gx c := by
  have cx := not_eq_of_mem_rest distinct mem
  have atx : expand rel x rest move y gx lx c x =
      total rest (fun v => via rel move c v) + edge y gx c := by
    unfold expand; rw [if_neg cx, if_pos rfl]
  have others : total rest (expand rel x rest move y gx lx c) = total rest (direct rel move c) :=
    total_congr_on fun b memb => by
      unfold expand; rw [if_neg cx, if_neg (not_eq_of_mem_rest distinct memb)]
  have parts : total rest (direct rel move c) + total rest (fun v => via rel move c v) =
      total rest (move c) :=
    (total_add _ _ rest).symm.trans (total_congr (fun b => direct_add_via rel move c b) rest)
  show expand rel x rest move y gx lx c x + total rest (expand rel x rest move y gx lx c) = _
  rw [atx, others]
  exact rearrange parts

/-- What a relatum of `rest` receives under the expanded moves. -/
theorem expand_received {rel : R → R → Bool} {x : R} {rest : List R} {move : R → R → Nat}
    {y : Option R} {gx lx : Nat} (distinct : Distinct (x :: rest)) {c : R} (mem : c ∈ rest) :
    total (x :: rest) (fun a => expand rel x rest move y gx lx a c) =
      total rest (fun a => move a c) + edge y lx c := by
  have cx := not_eq_of_mem_rest distinct mem
  have atx : expand rel x rest move y gx lx x c =
      total rest (fun u => via rel move u c) + edge y lx c := by
    unfold expand; rw [if_pos rfl, if_neg cx]
  have others : total rest (fun a => expand rel x rest move y gx lx a c) =
      total rest (fun a => direct rel move a c) :=
    total_congr_on fun a mema => by
      unfold expand; rw [if_neg (not_eq_of_mem_rest distinct mema), if_neg cx]
  have parts : total rest (fun a => direct rel move a c) + total rest (fun u => via rel move u c) =
      total rest (fun a => move a c) :=
    (total_add _ _ rest).symm.trans (total_congr (fun a => direct_add_via rel move a c) rest)
  show expand rel x rest move y gx lx x c +
    total rest (fun a => expand rel x rest move y gx lx a c) = _
  rw [atx, others]
  exact rearrange parts

/-- What `x` sends under the expanded moves. -/
theorem expand_sent_x {rel : R → R → Bool} {x : R} {rest : List R} {move : R → R → Nat}
    {y : Option R} {gx lx : Nat} (distinct : Distinct (x :: rest)) :
    total (x :: rest) (expand rel x rest move y gx lx x) =
      total rest (fun b => total rest (fun u => via rel move u b)) + total rest (edge y lx) := by
  have atx : expand rel x rest move y gx lx x x = 0 := by unfold expand; rw [if_pos rfl, if_pos rfl]
  show expand rel x rest move y gx lx x x + total rest (expand rel x rest move y gx lx x) = _
  rw [atx, Nat.zero_add]
  exact (total_congr_on fun b memb => by
    unfold expand; rw [if_pos rfl, if_neg (not_eq_of_mem_rest distinct memb)]).trans
    (total_add (fun b => total rest (fun u => via rel move u b)) (edge y lx) rest)

/-- What `x` receives under the expanded moves. -/
theorem expand_received_x {rel : R → R → Bool} {x : R} {rest : List R} {move : R → R → Nat}
    {y : Option R} {gx lx : Nat} (distinct : Distinct (x :: rest)) :
    total (x :: rest) (fun a => expand rel x rest move y gx lx a x) =
      total rest (fun a => total rest (fun v => via rel move a v)) + total rest (edge y gx) := by
  have atx : expand rel x rest move y gx lx x x = 0 := by unfold expand; rw [if_pos rfl, if_pos rfl]
  show expand rel x rest move y gx lx x x +
    total rest (fun a => expand rel x rest move y gx lx a x) = _
  rw [atx, Nat.zero_add]
  exact (total_congr_on fun a mema => by
    unfold expand; rw [if_neg (not_eq_of_mem_rest distinct mema), if_pos rfl]).trans
    (total_add (fun a => total rest (fun v => via rel move a v)) (edge y gx) rest)

/-- The expanded moves go only between adjacent relata of `x :: rest`. -/
theorem expand_along {rel : R → R → Bool} {x : R} {rest : List R} {move : R → R → Nat}
    {gx lx : Nat}
    (along : ∀ a b, 0 < move a b → adj (joined rel x) a b = true)
    (support : ∀ a b, 0 < move a b → a ∈ rest ∧ b ∈ rest)
    {a b : R} (pos : 0 < expand rel x rest move (rest.find? fun u => adj rel u x) gx lx a b) :
    adj rel a b = true ∧ a ∈ x :: rest ∧ b ∈ x :: rest := by
  have yadj : ∀ {y'}, (rest.find? fun u => adj rel u x) = some y' → adj rel y' x = true :=
    fun h => ListTests.find_some (p := fun u => adj rel u x) h
  have ymem : ∀ {y'}, (rest.find? fun u => adj rel u x) = some y' → y' ∈ rest :=
    fun h => ListTests.mem_of_find_some h
  by_cases ha : a = x
  · by_cases hb : b = x
    · have z : expand rel x rest move (rest.find? fun u => adj rel u x) gx lx a b = 0 := by
        unfold expand; rw [if_pos ha, if_pos hb]
      rw [z] at pos; exact absurd pos (Nat.lt_irrefl 0)
    · have e : expand rel x rest move (rest.find? fun u => adj rel u x) gx lx a b =
          total rest (fun u => via rel move u b) + edge (rest.find? fun u => adj rel u x) lx b := by
        unfold expand; rw [if_pos ha, if_neg hb]
      rw [e] at pos
      rcases add_pos_cases pos with p1 | p2
      · obtain ⟨u, _, viapos⟩ := total_pos rest p1
        obtain ⟨_, hbx, _, memb⟩ := via_through along support viapos
        refine ⟨?_, ?_, .tail x memb⟩
        · rw [ha, adj_symm]; exact hbx
        · rw [ha]; exact .head rest
      · obtain ⟨y', hy, e'⟩ := edge_pos p2
        refine ⟨?_, ?_, ?_⟩
        · rw [ha, e', adj_symm]; exact yadj hy
        · rw [ha]; exact .head rest
        · rw [e']; exact .tail x (ymem hy)
  · by_cases hb : b = x
    · have e : expand rel x rest move (rest.find? fun u => adj rel u x) gx lx a b =
          total rest (fun v => via rel move a v) + edge (rest.find? fun u => adj rel u x) gx a := by
        unfold expand; rw [if_neg ha, if_pos hb]
      rw [e] at pos
      rcases add_pos_cases pos with p1 | p2
      · obtain ⟨v, _, viapos⟩ := total_pos rest p1
        obtain ⟨hax, _, mema, _⟩ := via_through along support viapos
        refine ⟨?_, .tail x mema, ?_⟩
        · rw [hb]; exact hax
        · rw [hb]; exact .head rest
      · obtain ⟨y', hy, e'⟩ := edge_pos p2
        refine ⟨?_, ?_, ?_⟩
        · rw [hb, e']; exact yadj hy
        · rw [e']; exact .tail x (ymem hy)
        · rw [hb]; exact .head rest
    · have e : expand rel x rest move (rest.find? fun u => adj rel u x) gx lx a b =
          direct rel move a b := by
        unfold expand; rw [if_neg ha, if_neg hb]
      rw [e] at pos
      cases h : adj rel a b with
      | true =>
        have m : direct rel move a b = move a b := by unfold direct; rw [h]
        rw [m] at pos
        exact ⟨rfl, .tail x (support a b pos).1, .tail x (support a b pos).2⟩
      | false =>
        have z : direct rel move a b = 0 := by unfold direct; rw [h]
        rw [z] at pos; exact absurd pos (Nat.lt_irrefl 0)

theorem shift {n p a b g l : Nat} (h : n + a = p + b) (turn : p + g = n + l) : a + g = b + l :=
  Naturals.add_left_cancel (k := n) (calc
    n + (a + g) = n + a + g := (Nat.add_assoc n a g).symm
    _ = p + b + g := congrArg (· + g) h
    _ = b + (p + g) := by rw [Nat.add_comm p b, Nat.add_assoc]
    _ = b + (n + l) := congrArg (b + ·) turn
    _ = n + (b + l) := Nat.add_left_comm b n l)

/-- Conservation on the families closed under `rel` on `x :: rest` gives conservation on the
families closed once `x` is removed, with its exchange carried by the first relatum adjacent
to it. -/
theorem conservedOn_rest {rel : R → R → Bool} {x : R} {rest : List R} {prev next : R → Nat}
    (distinct : Distinct (x :: rest)) (conserved : ConservedOn rel (x :: rest) prev next) :
    ConservedOn (joined rel x) rest
      (fun z => prev z + edge (rest.find? fun u => adj rel u x) (prev x - next x) z)
      (fun z => next z + edge (rest.find? fun u => adj rel u x) (next x - prev x) z) := by
  intro p closes
  have split : ∀ (q : R → Nat) (y : Option R) (v : Nat),
      total rest (within p (fun z => q z + edge y v z)) =
        total rest (within p q) + total rest (within p (edge y v)) := fun q y v =>
    (total_congr (fun z => within_add p q (edge y v) z) rest).trans (total_add _ _ rest)
  rw [split next, split prev]
  -- the family extended to `x` by a value agreeing with every relatum adjacent to it
  have extended : ∀ px : Bool, (∀ b, b ∈ rest → adj rel b x = true → px = p b) →
      within (fun _ => px) next x + total rest (within p next) =
        within (fun _ => px) prev x + total rest (within p prev) := by
    intro px agrees
    let ext : R → Bool := fun z => if z = x then px else p z
    have ext_rest : ∀ z, z ∈ rest → ext z = p z := fun z mem => by
      show (if z = x then px else p z) = p z
      rw [if_neg (not_eq_of_mem_rest distinct mem)]
    have ext_x : ext x = px := by show (if x = x then px else p x) = px; rw [if_pos rfl]
    have closes_ext : Closes rel (x :: rest) ext := by
      intro a b mema memb hab
      rcases ListTests.mem_cons_iff.mp mema with ea | ra <;>
        rcases ListTests.mem_cons_iff.mp memb with eb | rb
      · rw [ea, eb]
      · rw [ea, ext_x, ext_rest b rb]
        exact agrees b rb (by rw [adj_symm, ← ea]; exact hab)
      · rw [eb, ext_x, ext_rest a ra]
        exact (agrees a ra (by rw [← eb]; exact hab)).symm
      · rw [ext_rest a ra, ext_rest b rb]; exact closes a b ra rb (joined_of_adj hab)
    have h : within ext next x + total rest (within ext next) =
        within ext prev x + total rest (within ext prev) := conserved ext closes_ext
    have restn : total rest (within ext next) = total rest (within p next) :=
      total_congr_on fun z mem => by unfold within; rw [ext_rest z mem]
    have restp : total rest (within ext prev) = total rest (within p prev) :=
      total_congr_on fun z mem => by unfold within; rw [ext_rest z mem]
    have atn : within ext next x = within (fun _ => px) next x := by unfold within; rw [ext_x]
    have atp : within ext prev x = within (fun _ => px) prev x := by unfold within; rw [ext_x]
    rw [restn, restp, atn, atp] at h
    exact h
  cases hy : rest.find? fun u => adj rel u x with
  | none =>
    have alone := ListTests.find_none_iff.mp hy
    have h := extended false fun b mem hb => absurd hb (by rw [alone b mem]; decide)
    rw [within_false (p := fun _ => false) next rfl, within_false (p := fun _ => false) prev rfl,
      Nat.zero_add, Nat.zero_add] at h
    have z : ∀ v, total rest (within p (edge (none : Option R) v)) = 0 := fun v =>
      total_eq_zero fun a _ => by unfold within; cases p a <;> rfl
    rw [z, z, Nat.add_zero, Nat.add_zero]
    exact h
  | some y' =>
    have yx : adj rel y' x = true := ListTests.find_some (p := fun u => adj rel u x) hy
    have mem := ListTests.mem_of_find_some hy
    have h := extended (p y') fun b memb hbx => closes y' b mem memb (joined_of_both yx hbx)
    rw [total_within_edge distinct.2 mem, total_within_edge distinct.2 mem]
    cases hp : p y' with
    | false =>
      rw [hp, within_false (p := fun _ => false) next rfl,
        within_false (p := fun _ => false) prev rfl, Nat.zero_add, Nat.zero_add] at h
      rw [within_false _ hp, within_false _ hp]
      exact congrArg (· + 0) h
    | true =>
      rw [hp, within_true (p := fun _ => true) next rfl, within_true (p := fun _ => true) prev rfl] at h
      rw [within_true _ hp, within_true _ hp]
      exact shift h (add_sub_turn (next x) (prev x))

/-- Where no relatum of `rest` is adjacent to `x`, conservation on every closed family keeps
the level of `x`. -/
theorem kept_alone {rel : R → R → Bool} {x : R} {rest : List R} {prev next : R → Nat}
    (distinct : Distinct (x :: rest)) (conserved : ConservedOn rel (x :: rest) prev next)
    (alone : ∀ u, u ∈ rest → adj rel u x = false) : next x = prev x := by
  let p : R → Bool := fun z => if z = x then true else false
  have px : p x = true := by show (if x = x then true else false) = true; rw [if_pos rfl]
  have prest : ∀ z, z ∈ rest → p z = false := fun z mem => by
    show (if z = x then true else false) = false; rw [if_neg (not_eq_of_mem_rest distinct mem)]
  have closes : Closes rel (x :: rest) p := by
    intro a b mema memb hab
    rcases ListTests.mem_cons_iff.mp mema with ea | ra <;>
      rcases ListTests.mem_cons_iff.mp memb with eb | rb
    · rw [ea, eb]
    · have hbx : adj rel b x = true := by rw [adj_symm, ← ea]; exact hab
      rw [alone b rb] at hbx; exact Bool.noConfusion hbx
    · have hax : adj rel a x = true := by rw [← eb]; exact hab
      rw [alone a ra] at hax; exact Bool.noConfusion hax
    · rw [prest a ra, prest b rb]
  have zero : ∀ q : R → Nat, total rest (within p q) = 0 := fun q =>
    total_eq_zero fun z mem => within_false _ (prest z mem)
  have hx : within p next x + total rest (within p next) =
      within p prev x + total rest (within p prev) := conserved p closes
  rw [zero, zero, within_true _ px, within_true _ px, Nat.add_zero, Nat.add_zero] at hx
  exact hx

theorem mid {a b c d s : Nat} (h : b + d = a + c) : a + (s + c) = b + (s + d) := by
  rw [Nat.add_left_comm a s c, Nat.add_left_comm b s d, h]

theorem mid2 {a b t t' e1 e2 : Nat} (h : a + e1 + t = b + e2 + t') :
    a + (t + e1) = b + (t' + e2) := by
  rw [Nat.add_comm t e1, Nat.add_comm t' e2, ← Nat.add_assoc, ← Nat.add_assoc]; exact h

/-- **Conservation on every closed family gives balance.** Over relata listed without
repetition, wherever the total is conserved on every family the relation closes, the routed
transfers balance the step along the relation. -/
theorem route_balancing : ∀ (us : List R) (rel : R → R → Bool) (prev next : R → Nat),
    Distinct us → ConservedOn rel us prev next → Balancing rel us prev next (route us rel prev next)
  | [], _, _, _, _, _ =>
    ⟨fun _ _ pos => absurd pos (Nat.lt_irrefl 0), fun _ _ pos => absurd pos (Nat.lt_irrefl 0),
     fun _ mem => absurd mem ListTests.not_mem_nil⟩
  | x :: rest, rel, prev, next, distinct, conserved => by
    rw [route_cons]
    obtain ⟨along, support, balances⟩ :=
      route_balancing rest (joined rel x) _ _ distinct.2 (conservedOn_rest distinct conserved)
    refine ⟨fun a b pos => (expand_along along support pos).1,
      fun a b pos => ⟨(expand_along along support pos).2.1, (expand_along along support pos).2.2⟩,
      fun c mem => ?_⟩
    rcases ListTests.mem_cons_iff.mp mem with e | r
    · rw [e, expand_sent_x distinct, expand_received_x distinct, total_swap (via rel _) rest rest]
      cases hy : rest.find? fun u => adj rel u x with
      | none =>
        have kept := kept_alone distinct conserved (ListTests.find_none_iff.mp hy)
        have z : ∀ v, total rest (edge (none : Option R) v) = 0 := fun _ => total_eq_zero fun _ _ => rfl
        rw [z, z, kept]
      | some y' =>
        rw [total_edge distinct.2 (ListTests.mem_of_find_some hy),
          total_edge distinct.2 (ListTests.mem_of_find_some hy)]
        exact mid (add_sub_turn (next x) (prev x))
    · rw [expand_sent distinct r, expand_received distinct r]
      exact mid2 (balances c r)

/-- **Balance is conservation on every closed family.** Over relata listed without repetition,
transfers along the relation balancing a step exist exactly where the total is conserved on
every family the relation closes, and the routed transfers are such. -/
theorem balancing_iff {rel : R → R → Bool} {us : List R} {prev next : R → Nat}
    (distinct : Distinct us) :
    (∃ move, Balancing rel us prev next move) ↔ ConservedOn rel us prev next :=
  ⟨fun ⟨_, balancing⟩ => conserved_of_balancing balancing,
   fun conserved => ⟨route us rel prev next, route_balancing us rel prev next distinct conserved⟩⟩

/-! ## On a web -/

/-- Transfers read as a flow: each listed relatum takes from a condition what moves from it to
the relatum, and gives it what moves from the relatum to it. -/
def flow (us : List R) (move : Nat → R → R → Nat) : Flow R R where
  present _ := us
  take t f c := move t c f
  give t f c := move t f c

/-- The routed transfers of a web's levels along a relation that may change from step to step. -/
def routed (us : List R) (rel : Nat → R → R → Bool) (W : Web R R) : Flow R R :=
  flow us fun t => route us (rel t) (W.level t) (W.level (t + 1))

/-- **Balance on a web is conservation on every closed family.** Over relata listed without
repetition: where the levels are conserved on every family the relation closes, at every step,
the routed transfers balance them on the listed relata and move only between adjacent relata;
and every flow of transfers along the relation balancing them conserves them so. -/
theorem balancesOn_iff_conserved {us : List R} {rel : Nat → R → R → Bool} {W : Web R R}
    (distinct : Distinct us) :
    (∃ move : Nat → R → R → Nat, (∀ t a b, 0 < move t a b → adj (rel t) a b = true ∧ a ∈ us ∧ b ∈ us) ∧
        ∀ t, (flow us move).BalancesOn W us t) ↔
      ∀ t, ConservedOn (rel t) us (W.level t) (W.level (t + 1)) :=
  ⟨fun ⟨move, along, balances⟩ t => (balancing_iff distinct).mp ⟨move t,
     fun a b pos => (along t a b pos).1, fun a b pos => (along t a b pos).2,
      fun c mem => balances t c mem⟩,
   fun conserved =>
     ⟨fun t => route us (rel t) (W.level t) (W.level (t + 1)),
      fun t a b pos =>
        have r := route_balancing us (rel t) (W.level t) (W.level (t + 1)) distinct (conserved t)
        ⟨r.1 a b pos, r.2.1 a b pos⟩,
      fun t c mem =>
        (route_balancing us (rel t) (W.level t) (W.level (t + 1)) distinct (conserved t)).2.2 c mem⟩⟩

/-- With every relatum listed, the routed transfers balance the web wherever its levels are
conserved on every closed family at every step. -/
theorem balances_of_conserved {us : List R} {rel : Nat → R → R → Bool} {W : Web R R}
    (distinct : Distinct us) (census : ∀ c, c ∈ us)
    (conserved : ∀ t, ConservedOn (rel t) us (W.level t) (W.level (t + 1))) :
    (routed us rel W).Balances W :=
  fun t c => (route_balancing us (rel t) (W.level t) (W.level (t + 1)) distinct (conserved t)).2.2
    c (census c)

/-- **Every run of a law that reads only adjacent relata and conserves the total balances.**
Where the levels after each step are what the law gives from the levels before, the routed
transfers balance them on the listed relata, moving only between adjacent relata. -/
theorem balancesOn_of_law {us : List R} {rel : R → R → Bool} {law : (R → Nat) → R → Nat}
    {W : Web R R} (distinct : Distinct us) (reads : ReadsAdjacent rel us law)
    (conserves : Conserves us law) (run : ∀ t x, x ∈ us → W.level (t + 1) x = law (W.level t) x)
    (t : Nat) : (routed us (fun _ => rel) W).BalancesOn W us t := by
  have conserved : ConservedOn rel us (W.level t) (W.level (t + 1)) := fun p closes => by
    have h := conservedOn_of_law reads conserves (W.level t) p closes
    refine (total_congr_on fun x mem => ?_).trans h
    unfold within; cases p x
    · rfl
    · exact run t x mem
  exact (route_balancing us rel (W.level t) (W.level (t + 1)) distinct conserved).2.2

/-! ## Teleport -/

namespace Teleport

/-- The two relata. -/
def all : List Bool := [true, false]

theorem distinct : Distinct all :=
  ⟨fun m => match m with | .tail _ m' => absurd m' ListTests.not_mem_nil, ListTests.not_mem_nil, trivial⟩

/-- The law that swaps the levels of the two relata. -/
def swap (a : Bool → Nat) (b : Bool) : Nat := a (!b)

/-- The empty relation. -/
def apart (_ _ : Bool) : Bool := false

/-- The full relation. -/
def together (_ _ : Bool) : Bool := true

/-- The swap conserves the total from every configuration. -/
theorem conserves : Conserves all swap := fun a => by
  show a false + (a true + 0) = a true + (a false + 0)
  rw [Nat.add_zero, Nat.add_zero, Nat.add_comm]

/-- The swap reads both relata, adjacent under the full relation. -/
theorem reads : ReadsAdjacent together all swap := fun a b x _ _ agree => by
  show a (!x) = b (!x)
  cases x
  · exact agree true (.head _) rfl
  · exact agree false (.tail _ (.head _)) rfl

/-- One unit on `true`, nothing on `false`. -/
def unit (b : Bool) : Nat := if b then 1 else 0

/-- **Teleport.** Along the empty relation, the family of `true` alone is closed and the swap
moves its unit out of it: the total is not conserved on it, so no transfers along the empty
relation balance the swap. -/
theorem no_transfers_apart : ¬ ∃ move, Balancing apart all unit (swap unit) move := fun ⟨_, b⟩ =>
  have closes : Closes apart all (fun z => z) := fun _ _ _ _ h => Bool.noConfusion h
  absurd (conserved_of_balancing b (fun z => z) closes) (by decide)

/-- Along the full relation the routed transfers balance the swap from every configuration. -/
theorem balanced_together (a : Bool → Nat) :
    Balancing together all a (swap a) (route all together a (swap a)) :=
  route_balancing all together a (swap a) distinct (conservedOn_of_law reads conserves a)

end Teleport

end Continuity

end Becoming
