/-! ## Need across two tiers, the upper dividing its giving among the stores -/

section Restricted

variable {α : Type}

/-- **A total over a list without repetition of what is positive, among its members, at one of
them alone is at most its value there.** -/
theorem total_le_at_on {q : α → Nat} {a : α} :
    ∀ {as : List α}, (∀ b, b ∈ as → 0 < q b → b = a) → Distinct as → total as q ≤ q a
  | [], _, _ => Nat.zero_le _
  | b :: as, only, ⟨fresh, distinct⟩ => match Nat.decEq (q b) 0 with
    | isTrue zero => Nat.le_trans
        (Nat.le_of_eq ((congrArg (· + total as q) zero).trans (Nat.zero_add _)))
        (total_le_at_on (fun e mem pos => only e (.tail b mem) pos) distinct)
    | isFalse positive =>
      have same : b = a := only b (.head as) (Nat.pos_of_ne_zero positive)
      have rest : total as q = 0 := total_eq_zero fun e mem => eq_zero_of_not_pos fun pos =>
        fresh (Eq.subst (motive := fun x => x ∈ as) ((only e (.tail b mem) pos).trans same.symm) mem)
      Nat.le_of_eq ((congrArg (q b + ·) rest).trans ((Nat.add_zero _).trans (congrArg q same)))

end Restricted

namespace Web

variable {C : Type} (W : Web F C)

/-- Some member of `ks` other than `e` is active at `t`: one to route the upper tier's giving. -/
def RoutesAt (ks : List F) (e : F) (t : Nat) : Prop :=
  ∃ h, h ∈ ks ∧ W.active t h ∧ h ≠ e

instance decRoutesAt [∀ t x, Decidable (W.active t x)] [DecidableEq F] (ks : List F) (e : F)
    (t : Nat) : Decidable (W.RoutesAt ks e t) :=
  decideSome (p := fun h => W.active t h ∧ h ≠ e) ks

/-- What the formations other than `e` could give into a two-tier hierarchy at the step from `t`:
the falls of the stores of the active lower members other than `e`, and, while one of them is
active to route it, what the active upper members other than `e` can give. -/
def othersThrough [∀ t x, Decidable (W.active t x)] [DecidableEq F] (store : F → C)
    (cap₂ : Nat → F → Nat) (ks js : List F) (e : F) (t : Nat) : Nat :=
  W.capacityWithout (W.storeFall store) ks e t +
    if W.RoutesAt ks e t then W.capacityWithout cap₂ js e t else 0

end Web

namespace Flow

variable {C : Type}

/-- The flows read off a web for a family fed from the members of `ks`, each giving what it takes
from its own store, the stores fed only from the members of `js` within their capacities `cap₂`:
read off the web for the family, with the formations taking part distinct at each step of the
stretch, every lower member's store balancing and given only by upper members, every lower member
giving the family at most what it takes from its own store, and every upper member giving the
stores at most its capacity. -/
def FedThroughStores (W : Web F C) (store : F → C) (cs : List C) (ks js : List F)
    (cap₂ : Nat → F → Nat) (T n : Nat) (L : Flow F C) : Prop :=
  FedOnlyOn W cs (· ∈ ks) T n L ∧ ∀ t, T ≤ t → t < T + n →
    Distinct (L.present t) ∧
    (∀ h, h ∈ ks → L.BalancesOn W [store h] t ∧
      (h ∈ L.present t → total cs (L.give t h) ≤ L.take t h (store h)) ∧
      ∀ x, x ∈ L.present t → 0 < L.give t x (store h) → x ∈ js) ∧
    ∀ x, x ∈ L.present t → x ∈ js → total ks (fun h => L.give t x (store h)) ≤ cap₂ t x

/-- `e` gives into the hierarchy within the stretch: at some step of it `e` takes part and gives to
the family or to a lower member's store. -/
def GivesInto (cs : List C) (ks : List F) (store : F → C) (T n : Nat) (ω : Flow F C × Web F C)
    (e : F) : Prop :=
  ∃ t, T ≤ t ∧ t < T + n ∧ e ∈ ω.1.present t ∧
    0 < total cs (ω.1.give t e) + total ks (fun h => ω.1.give t e (store h))

section Through

variable [DecidableEq F] {W : Web F C} [∀ t x, Decidable (W.active t x)] {store : F → C}
  {cs : List C} {ks js : List F} {cap₂ : Nat → F → Nat} {T n : Nat} {e : F}

omit [DecidableEq F] [∀ t x, Decidable (W.active t x)] in
/-- What is taken from a store that balances and does not rise is what it is given and what it
falls. -/
theorem taken_store {L : Flow F C} {t : Nat} {h : F} (balances : L.BalancesOn W [store h] t)
    (steady : ¬ W.Rises t (store h)) :
    L.taken t (store h) = L.given t (store h) + W.storeFall store t h :=
  have flat : rise (fun s => W.level s (store h)) t = 0 :=
    eq_zero_of_not_pos fun pos => steady (excess_pos.mp pos)
  have down : W.level (t + 1) (store h) + W.storeFall store t h = W.level t (store h) :=
    (across (fun s => W.level s (store h)) t).trans
      ((congrArg (W.level t (store h) + ·) flat).trans (Nat.add_zero _))
  Naturals.add_left_cancel ((balances (store h) (.head [])).trans
    ((congrArg (· + L.given t (store h)) down.symm).trans ((Nat.add_assoc _ _ _).trans
      (congrArg (W.level (t + 1) (store h) + ·) (Nat.add_comm _ _)))))

/-- **What the lower members other than `e` give the family is at most what is taken from their
stores**, in a flow of the two-tier hierarchy at a step of the stretch where `e`, if it takes part,
gives the family nothing. -/
theorem replenishment_le_taken {L : Flow F C} (fed : FedThroughStores W store cs ks js cap₂ T n L)
    {t : Nat} (from_ : T ≤ t) (to : t < T + n)
    (quiet : e ∈ L.present t → total cs (L.give t e) = 0) :
    L.replenishment cs t ≤
      total ks (fun h => if W.active t h ∧ h ≠ e then L.taken t (store h) else 0) :=
  have each : ∀ x, x ∈ L.present t → total cs (L.give t x) ≤
      total ks (fun h => if h = x then
        (if W.active t h ∧ h ≠ e then L.take t h (store h) else 0) else 0) := fun x present =>
    match Nat.decEq (total cs (L.give t x)) 0 with
    | isTrue zero => Nat.le_trans (Nat.le_of_eq zero) (Nat.zero_le _)
    | isFalse pos => match total_pos cs (Nat.pos_of_ne_zero pos) with
      | ⟨c, inside, positive⟩ =>
        have member : x ∈ ks := fed.1.2.2 t x c inside present positive
        have other : x ≠ e := fun same => pos (Eq.subst (motive := fun y => total cs (L.give t y) = 0)
          same.symm (quiet (Eq.subst (motive := fun y => y ∈ L.present t) same present)))
        Nat.le_trans (((fed.2 t from_ to).2.1 x member).2.1 present) (Nat.le_trans
          (Nat.le_of_eq ((if_pos ⟨fed.1.2.1 t x c present positive, other⟩).symm.trans
            (if_pos rfl).symm))
          (le_total_of_mem (q := fun h => if h = x then
            (if W.active t h ∧ h ≠ e then L.take t h (store h) else 0) else 0) member))
  Nat.le_trans (Nat.le_of_eq (total_swap (fun x c => L.give t x c) cs (L.present t)).symm)
    (Nat.le_trans (total_le _ each) (Nat.le_trans
      (Nat.le_of_eq (total_swap (fun x h => if h = x then
        (if W.active t h ∧ h ≠ e then L.take t h (store h) else 0) else 0) ks (L.present t)))
      (total_le ks fun h _ => match (instDecidableAnd : Decidable (W.active t h ∧ h ≠ e)) with
        | isTrue both => Nat.le_trans (total_le (L.present t) fun x _ => match decEq h x with
              | isTrue same => Nat.le_of_eq ((if_pos same).trans ((if_pos both).trans
                  (congrArg (fun y => L.take t y (store h)) same)))
              | isFalse other => Nat.le_trans (Nat.le_of_eq (if_neg other)) (Nat.zero_le _))
            (Nat.le_of_eq (if_pos both).symm)
        | isFalse no => Nat.le_trans (Nat.le_of_eq (total_eq_zero fun x _ =>
              match decEq h x with
              | isTrue same => (if_pos same).trans (if_neg no)
              | isFalse other => if_neg other)) (Nat.zero_le _))))

/-- **What the upper members other than `e` give the stores is at most what they can give
together**, in a flow of the two-tier hierarchy at a step of the stretch where `e`, if it takes
part, gives the stores nothing. -/
theorem stores_given_le {L : Flow F C} (fed : FedThroughStores W store cs ks js cap₂ T n L)
    {t : Nat} (from_ : T ≤ t) (to : t < T + n)
    (quiet : e ∈ L.present t → total ks (fun h => L.give t e (store h)) = 0) :
    total ks (fun h => L.given t (store h)) ≤ W.capacityWithout cap₂ js e t :=
  have each : ∀ x, x ∈ L.present t → total ks (fun h => L.give t x (store h)) ≤
      total js (fun j => if j = x then W.otherCapacity cap₂ e t j else 0) := fun x present =>
    match Nat.decEq (total ks (fun h => L.give t x (store h))) 0 with
    | isTrue zero => Nat.le_trans (Nat.le_of_eq zero) (Nat.zero_le _)
    | isFalse pos => match total_pos ks (Nat.pos_of_ne_zero pos) with
      | ⟨h, inks, positive⟩ =>
        have upper : x ∈ js := ((fed.2 t from_ to).2.1 h inks).2.2 x present positive
        have other : x ≠ e := fun same => pos (Eq.subst
          (motive := fun y => total ks (fun h => L.give t y (store h)) = 0) same.symm
          (quiet (Eq.subst (motive := fun y => y ∈ L.present t) same present)))
        Nat.le_trans ((fed.2 t from_ to).2.2 x present upper) (Nat.le_trans
          (Nat.le_of_eq ((if_pos ⟨fed.1.2.1 t x (store h) present positive, other⟩).symm.trans
            (if_pos rfl).symm))
          (le_total_of_mem (q := fun j => if j = x then W.otherCapacity cap₂ e t j else 0) upper))
  Nat.le_trans (Nat.le_of_eq (total_swap (fun x h => L.give t x (store h)) ks (L.present t)).symm)
    (Nat.le_trans (total_le _ each) (Nat.le_trans
      (Nat.le_of_eq (total_swap (fun x j => if j = x then W.otherCapacity cap₂ e t j else 0) js
        (L.present t)))
      (total_le js fun j _ => Nat.le_trans (total_le_at (a := j) (fun b pos => match decEq j b with
          | isTrue same => same.symm
          | isFalse other => absurd pos (fun p => Nat.lt_irrefl 0
              (Nat.lt_of_lt_of_le p (Nat.le_of_eq (if_neg other))))) (fed.2 t from_ to).1)
        (Nat.le_of_eq (if_pos rfl)))))

/-- **The family is given at most what the others could give into the hierarchy.** In a flow of
the two-tier hierarchy at a step of the stretch where no lower member's store rises and `e`, if it
takes part, gives nothing into the hierarchy, the family is given at most `W.othersThrough`. -/
theorem replenishment_le_othersThrough {L : Flow F C}
    (fed : FedThroughStores W store cs ks js cap₂ T n L) {t : Nat} (from_ : T ≤ t)
    (to : t < T + n) (steady : ∀ h, h ∈ ks → ¬ W.Rises t (store h))
    (quiet : e ∈ L.present t →
      total cs (L.give t e) + total ks (fun h => L.give t e (store h)) = 0) :
    L.replenishment cs t ≤ W.othersThrough store cap₂ ks js e t :=
  have quietFamily : e ∈ L.present t → total cs (L.give t e) = 0 := fun present =>
    Nat.eq_zero_of_le_zero (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (quiet present)))
  have quietStores : e ∈ L.present t → total ks (fun h => L.give t e (store h)) = 0 :=
    fun present => Nat.eq_zero_of_le_zero (Nat.le_trans (Nat.le_add_left _ _)
      (Nat.le_of_eq (quiet present)))
  have split : total ks (fun h => if W.active t h ∧ h ≠ e then L.taken t (store h) else 0) =
      W.capacityWithout (W.storeFall store) ks e t +
        total ks (fun h => if W.active t h ∧ h ≠ e then L.given t (store h) else 0) :=
    (Weighting.total_congr_on fun h inks =>
      match (instDecidableAnd : Decidable (W.active t h ∧ h ≠ e)) with
      | isTrue both => (if_pos both).trans ((taken_store (((fed.2 t from_ to).2.1 h inks).1)
          (steady h inks)).trans ((Nat.add_comm _ _).trans
            ((congrArg (· + L.given t (store h))
              (if_pos (t := W.storeFall store t h) (e := (0 : Nat)) both).symm).trans
              (congrArg (W.otherCapacity (W.storeFall store) e t h + ·)
                (if_pos (t := L.given t (store h)) (e := (0 : Nat)) both).symm))))
      | isFalse no => (if_neg no).trans ((Nat.add_zero 0).symm.trans
          ((congrArg (· + 0) (if_neg (t := W.storeFall store t h) (e := (0 : Nat)) no).symm).trans
            (congrArg (W.otherCapacity (W.storeFall store) e t h + ·)
              (if_neg (t := L.given t (store h)) (e := (0 : Nat)) no).symm)))).trans
      (total_add _ _ ks)
  Nat.le_trans (replenishment_le_taken fed from_ to quietFamily)
    (Nat.le_trans (Nat.le_of_eq split) (Nat.add_le_add_left
      (match (inferInstance : Decidable (W.RoutesAt ks e t)) with
      | isTrue routes => Nat.le_trans (total_le ks fun h _ =>
            match (instDecidableAnd : Decidable (W.active t h ∧ h ≠ e)) with
            | isTrue both => Nat.le_of_eq (if_pos both)
            | isFalse no => Nat.le_trans (Nat.le_of_eq (if_neg no)) (Nat.zero_le _))
          (Nat.le_trans (stores_given_le fed from_ to quietStores) (Nat.le_of_eq (if_pos routes).symm))
      | isFalse noRoute => Nat.le_trans (Nat.le_of_eq (total_eq_zero fun h inks =>
            if_neg fun both => noRoute ⟨h, inks, both⟩)) (Nat.zero_le _)) _))

end Through

end Flow

namespace Web

variable {C : Type} (W : Web F C)

/-- The part of the step's demand beyond the falls of the stores of the active lower members
other than `e`: what the upper tier is to route through a lower member. -/
def routed [∀ t x, Decidable (W.active t x)] [DecidableEq F] (store : F → C) (cs : List C)
    (ks : List F) (e : F) (t : Nat) : Nat :=
  excess (W.demand cs t) (W.capacityWithout (W.storeFall store) ks e t)

/-- What each lower member can pass on at a step in the routed flow: its store's fall, and, for
the router (the first active lower member other than `e`), what is routed through it. -/
def routedCapacity [∀ t x, Decidable (W.active t x)] [DecidableEq F] (store : F → C)
    (cs : List C) (ks : List F) (e : F) (t : Nat) (h : F) : Nat :=
  W.storeFall store t h + if h = Flow.firstActiveOther W e t ks then W.routed store cs ks e t else 0

/-- The upper tier's shares at the step from `t`: the units routed to the router's store, paired
in order with the units the upper members other than `e` can give. -/
def routedShares [∀ t x, Decidable (W.active t x)] [DecidableEq F] (store : F → C)
    (cap₂ : Nat → F → Nat) (cs : List C) (ks js : List F) (e : F) (t : Nat) : List (C × F) :=
  pairUp (repeatOnto (store (Flow.firstActiveOther W e t ks)) (W.routed store cs ks e t) [])
    (unitsOf js (W.otherCapacity cap₂ e t))

/-- What an upper member gives a condition at the step from `t` as the upper tier's shares pair
them. -/
def routedGive [∀ t x, Decidable (W.active t x)] [DecidableEq F] [DecidableEq C] (store : F → C)
    (cap₂ : Nat → F → Nat) (cs : List C) (ks js : List F) (e : F) (t : Nat) (x : F) (c : C) : Nat :=
  total (W.routedShares store cap₂ cs ks js e t) fun z => if z.1 = c ∧ z.2 = x then 1 else 0

end Web

namespace Flow

variable {C : Type}

/-- Across a stretch, the routed flow of a two-tier hierarchy with `e` left out: the consumer
takes as in the least flow; every lower member takes from its own store what the store falls, the
router also what is routed through it; the upper members other than `e` give the router's store
what is routed, within their capacities (`Web.routedGive`), and the lower members other than `e`
give the family as the shares pair them, within what they can pass on (`Web.routedCapacity`). -/
def routedDrawn [DecidableEq F] [DecidableEq C] (W : Web F C) [∀ t x, Decidable (W.active t x)]
    (store : F → C) (cap₂ : Nat → F → Nat) (cs : List C) (c₀ : C) (ks js : List F) (T n : Nat)
    (f e : F) : Flow F C where
  present t := if T ≤ t ∧ t < T + n then f :: (ks ++ js) else []
  take t x c := if x = f ∧ (∃ d, d ∈ cs ∧ d = c) then
      fall (fun s => W.level s c) t + W.drawnUnit cs c₀ t c
    else if (∃ h, h ∈ ks ∧ h = x) ∧ c = store x then W.routedCapacity store cs ks e t x else 0
  give t x c := (sharedDrawn W (W.routedCapacity store cs ks e) cs c₀ ks T n f e).give t x c +
    W.routedGive store cap₂ cs ks js e t x c

section Routed

variable [DecidableEq F] [DecidableEq C] {W : Web F C} [∀ t x, Decidable (W.active t x)]
  {store : F → C} {cap₂ : Nat → F → Nat} {cs : List C} {c₀ : C} {ks js : List F} {T n : Nat}
  {f e : F}

omit [DecidableEq C] in
/-- Where the others cover the demand and no lower member other than `e` is active, nothing is
routed. -/
theorem routed_zero {t : Nat} (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t)
    (noRoute : ¬ W.RoutesAt ks e t) : W.routed store cs ks e t = 0 :=
  eq_zero_of_not_pos fun pos => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le (excess_pos.mp pos)
    (Nat.le_trans covers (Nat.le_of_eq ((congrArg (W.capacityWithout (W.storeFall store) ks e t + ·)
      (if_neg noRoute)).trans (Nat.add_zero _)))))

omit [DecidableEq C] in
/-- Where the others cover the demand and some lower member other than `e` is active, what is
routed is at most what the upper members other than `e` can give. -/
theorem routed_le {t : Nat} (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t)
    (routes : W.RoutesAt ks e t) : W.routed store cs ks e t ≤ W.capacityWithout cap₂ js e t :=
  excess_le_of_covered (Nat.le_trans covers (Nat.le_of_eq
    (congrArg (W.capacityWithout (W.storeFall store) ks e t + ·) (if_pos routes))))

omit [DecidableEq C] in
/-- Where something is routed and the others cover the demand, the router is an active lower
member other than `e`. -/
theorem router_of_routed {t : Nat} (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t)
    (pos : 0 < W.routed store cs ks e t) :
    firstActiveOther W e t ks ∈ ks ∧ W.active t (firstActiveOther W e t ks) ∧
      firstActiveOther W e t ks ≠ e :=
  match (inferInstance : Decidable (W.RoutesAt ks e t)) with
  | isTrue routes =>
    have active := firstActiveOther_active (W := W) (g := e) (t := t) ks routes
    match firstActiveOther_mem (W := W) (g := e) (t := t) ks with
    | .inl mem => ⟨mem, active.1, active.2⟩
    | .inr same => absurd same active.2
  | isFalse noRoute => (Nat.lt_irrefl 0 (Eq.subst (motive := fun k => 0 < k)
      (routed_zero covers noRoute) pos)).elim

omit [DecidableEq C] in
/-- What is routed is at most what the upper members other than `e` can give, where the others
cover the demand. -/
theorem routed_le_upper {t : Nat} (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t) :
    W.routed store cs ks e t ≤ W.capacityWithout cap₂ js e t :=
  match (inferInstance : Decidable (W.RoutesAt ks e t)) with
  | isTrue routes => routed_le covers routes
  | isFalse noRoute => Nat.le_trans (Nat.le_of_eq (routed_zero covers noRoute)) (Nat.zero_le _)

/-- What an upper member gives as the shares pair them goes to the router's store, something being
routed, and the giver is an active upper member other than `e`. -/
theorem routedGive_pos {t : Nat} {x : F} {c : C}
    (gives : 0 < W.routedGive store cap₂ cs ks js e t x c) :
    c = store (firstActiveOther W e t ks) ∧ 0 < W.routed store cs ks e t ∧ x ∈ js ∧
      W.active t x ∧ x ≠ e :=
  match total_pos (W.routedShares store cap₂ cs ks js e t) gives with
  | ⟨z, mem, positive⟩ =>
    match (instDecidableAnd : Decidable (z.1 = c ∧ z.2 = x)) with
    | isFalse no =>
      absurd (Nat.lt_of_lt_of_le positive (Nat.le_of_eq (if_neg no))) (Nat.lt_irrefl 0)
    | isTrue ⟨first, second⟩ => match mem_pairUp mem with
      | ⟨units, givers⟩ => match mem_repeatOnto units, mem_unitsOf givers with
        | .inl ⟨atRouter, routedPos⟩, ⟨upper, spare⟩ =>
          have able : W.active t z.2 ∧ z.2 ≠ e :=
            match (instDecidableAnd : Decidable (W.active t z.2 ∧ z.2 ≠ e)) with
            | isTrue both => both
            | isFalse no =>
              absurd (Nat.lt_of_lt_of_le spare (Nat.le_of_eq (if_neg no))) (Nat.lt_irrefl 0)
          ⟨first.symm.trans atRouter, routedPos,
           Eq.subst (motive := fun y => y ∈ js) second upper,
           Eq.subst (motive := fun y => W.active t y) second able.1,
           Eq.subst (motive := fun y => y ≠ e) second able.2⟩
        | .inr empty, _ => nomatch empty

/-- Nothing the upper tier routes goes to a condition of the family, where the others cover the
demand and no lower member's store is in the family. -/
theorem routedGive_family {t : Nat} (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t)
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) {x : F} {c : C} (inside : c ∈ cs) :
    W.routedGive store cap₂ cs ks js e t x c = 0 :=
  eq_zero_of_not_pos fun pos => match routedGive_pos pos with
  | ⟨atRouter, routedPos, _⟩ => separate _ (router_of_routed covers routedPos).1
      (Eq.subst (motive := fun y => y ∈ cs) atRouter inside)

/-- **The upper members give the router's store exactly what is routed, and every other store
nothing**, where the others cover the demand and the stores are the lower members' own. -/
theorem routedGive_store (apartJ : Distinct js)
    (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h') {t : Nat}
    (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t) {h : F} (member : h ∈ ks) :
    total js (fun x => W.routedGive store cap₂ cs ks js e t x (store h)) =
      if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0 :=
  have long : total (repeatOnto (store (firstActiveOther W e t ks)) (W.routed store cs ks e t) [])
      (fun _ => 1) ≤ total (unitsOf js (W.otherCapacity cap₂ e t)) (fun _ => 1) :=
    Nat.le_trans (Nat.le_of_eq ((total_repeatOnto (fun _ => 1) _ [] _).trans
      ((Nat.add_zero _).trans (Nat.mul_one _))))
      (Nat.le_trans (routed_le_upper covers) (Nat.le_of_eq ((total_unitsOf (fun _ => 1) _ js).trans
        (Weighting.total_congr_on fun _ _ => Nat.mul_one _)).symm))
  show total js (fun x => total (W.routedShares store cap₂ cs ks js e t)
      fun z => if z.1 = store h ∧ z.2 = x then 1 else 0) = _ from
  (total_swap (fun (x : F) (z : C × F) => if z.1 = store h ∧ z.2 = x then 1 else 0)
    (W.routedShares store cap₂ cs ks js e t) js).trans
    ((Weighting.total_congr_on (q := fun (z : C × F) => if z.1 = store h then 1 else 0) fun z mem =>
      match mem_pairUp mem with
      | ⟨_, givers⟩ => match mem_unitsOf givers with
        | ⟨upper, _⟩ => match decEq z.1 (store h) with
          | isTrue same => (total_eq_at (a := z.2) (fun (x : F) pos =>
                match (instDecidableAnd : Decidable (z.1 = store h ∧ z.2 = x)) with
                | isTrue both => both.2.symm
                | isFalse no =>
                  absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (if_neg no))) (Nat.lt_irrefl 0))
              apartJ upper).trans ((if_pos ⟨same, rfl⟩).trans (if_pos same).symm)
          | isFalse other =>
            (total_eq_zero fun _ _ => if_neg fun both => other both.1).trans (if_neg other).symm).trans
      ((total_pairUp_fst (fun d => if d = store h then 1 else 0) _ _ long).trans
        ((total_repeatOnto (fun d => if d = store h then 1 else 0) _ [] _).trans
          ((Nat.add_zero _).trans (match decEq h (firstActiveOther W e t ks) with
            | isTrue same => ((congrArg (W.routed store cs ks e t * ·)
                (if_pos (congrArg store same.symm))).trans (Nat.mul_one _)).trans (if_pos same).symm
            | isFalse other => match Nat.decEq (W.routed store cs ks e t) 0 with
              | isTrue zero => ((congrArg (· * _) zero).trans (Nat.zero_mul _)).trans
                  (if_neg other).symm
              | isFalse pos => (congrArg (W.routed store cs ks e t * ·) (if_neg fun same =>
                  other (own h _ member (router_of_routed covers (Nat.pos_of_ne_zero pos)).1
                    same.symm)) |>.trans (Nat.mul_zero _)).trans (if_neg other).symm)))))

end Routed

end Flow

namespace Flow

variable {C : Type}

section RoutedFlow

variable [DecidableEq F] [DecidableEq C] {W : Web F C} [∀ t x, Decidable (W.active t x)]
  {store : F → C} {cap₂ : Nat → F → Nat} {cs : List C} {c₀ : C} {ks js : List F} {T n : Nat}
  {f e : F}

omit [DecidableEq C] in
/-- The lower members other than `e` can pass on the step's demand in the routed flow, where the
others cover it. -/
theorem routedCapacity_covers {t : Nat}
    (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t) :
    W.demand cs t ≤ W.capacityWithout (W.routedCapacity store cs ks e) ks e t :=
  have split : W.capacityWithout (W.routedCapacity store cs ks e) ks e t =
      W.capacityWithout (W.storeFall store) ks e t +
        total ks (fun h => if W.active t h ∧ h ≠ e then
          (if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0) else 0) :=
    (Weighting.total_congr_on fun h _ =>
      match (instDecidableAnd : Decidable (W.active t h ∧ h ≠ e)) with
      | isTrue both => (if_pos both).trans
          ((congrArg (· + (if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0))
            (if_pos (t := W.storeFall store t h) (e := (0 : Nat)) both).symm).trans
            (congrArg (W.otherCapacity (W.storeFall store) e t h + ·)
              (if_pos (t := if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0)
                (e := (0 : Nat)) both).symm))
      | isFalse no => (if_neg no).trans ((Nat.add_zero 0).symm.trans
          ((congrArg (· + 0) (if_neg (t := W.storeFall store t h) (e := (0 : Nat)) no).symm).trans
            (congrArg (W.otherCapacity (W.storeFall store) e t h + ·)
              (if_neg (t := if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0)
                (e := (0 : Nat)) no).symm)))).trans (total_add _ _ ks)
  match (inferInstance : Decidable (W.RoutesAt ks e t)) with
  | isTrue routes =>
    have router := firstActiveOther_active (W := W) (g := e) (t := t) ks routes
    have member : firstActiveOther W e t ks ∈ ks :=
      match firstActiveOther_mem (W := W) (g := e) (t := t) ks with
      | .inl mem => mem
      | .inr same => absurd same router.2
    Nat.le_trans (covered_by_excess (W.demand cs t) (W.capacityWithout (W.storeFall store) ks e t))
      (Nat.le_trans (Nat.add_le_add_left (Nat.le_trans
          (Nat.le_of_eq ((if_pos (rfl : firstActiveOther W e t ks = firstActiveOther W e t ks)).symm.trans
            (if_pos router).symm))
          (le_total_of_mem (q := fun h => if W.active t h ∧ h ≠ e then
            (if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0) else 0) member)) _)
        (Nat.le_of_eq split.symm))
  | isFalse noRoute =>
    Nat.le_trans (Nat.le_trans covers (Nat.le_of_eq ((congrArg
        (W.capacityWithout (W.storeFall store) ks e t + ·) (if_neg noRoute)).trans (Nat.add_zero _))))
      (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq split.symm))

/-- In the routed flow nothing given to a condition of the family is given by an upper member's
share, and what is given to it is the lower members' giving. -/
theorem routedDrawn_give_family {t : Nat}
    (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t)
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) {x : F} {c : C} (inside : c ∈ cs) :
    (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x c =
      (sharedDrawn W (W.routedCapacity store cs ks e) cs c₀ ks T n f e).give t x c :=
  (congrArg ((sharedDrawn W (W.routedCapacity store cs ks e) cs c₀ ks T n f e).give t x c + ·)
    (routedGive_family covers separate inside)).trans (Nat.add_zero _)

/-- In the routed flow nothing given to a lower member's store is the lower members' giving: it is
an upper member's share. -/
theorem routedDrawn_give_store (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) {t : Nat} {x h : F}
    (member : h ∈ ks) :
    (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x (store h) =
      W.routedGive store cap₂ cs ks js e t x (store h) :=
  (congrArg (· + W.routedGive store cap₂ cs ks js e t x (store h))
    (eq_zero_of_not_pos fun pos => separate h member
      (sharedDrawn_gives (W := W) (cap := W.routedCapacity store cs ks e) (cs := cs) (c₀ := c₀)
        (ks := ks) (T := T) (n := n) (f := f) (g := e) pos).1)).trans (Nat.zero_add _)

/-- The routed flow balances on the family at every step of the stretch, where the others cover the
demand there, `f` is in neither tier, the tiers are apart and no store is in the family. -/
theorem routedDrawn_balancesOn (distinct : Distinct cs) (inside : c₀ ∈ cs) (apartK : Distinct ks)
    (outsideK : ¬ f ∈ ks) (outsideJ : ¬ f ∈ js) (tiers : ∀ h, h ∈ ks → ¬ h ∈ js)
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs)
    (covers : ∀ t, T ≤ t → t < T + n → W.demand cs t ≤ W.othersThrough store cap₂ ks js e t) :
    ∀ t, T ≤ t → t < T + n → (routedDrawn W store cap₂ cs c₀ ks js T n f e).BalancesOn W cs t := by
  intro t from_ to c member
  have present : (routedDrawn W store cap₂ cs c₀ ks js T n f e).present t = f :: (ks ++ js) :=
    if_pos ⟨from_, to⟩
  have takeSelf : (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t f c =
      fall (fun s => W.level s c) t + W.drawnUnit cs c₀ t c := if_pos ⟨rfl, ⟨c, member, rfl⟩⟩
  have takeOthers :
      total (ks ++ js) (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t x c) = 0 :=
    total_eq_zero fun x mem =>
      (if_neg fun both => match ListTests.mem_append_iff.mp mem with
        | .inl k => outsideK (Eq.subst (motive := fun y => y ∈ ks) both.1 k)
        | .inr j => outsideJ (Eq.subst (motive := fun y => y ∈ js) both.1 j)).trans
        (if_neg fun both => match both.1 with
          | ⟨k, kin, same⟩ => separate x (Eq.subst (motive := fun y => y ∈ ks) same kin)
              (Eq.subst (motive := fun y => y ∈ cs) both.2 member))
  have giveSelf : (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t f c = 0 :=
    (routedDrawn_give_family (covers t from_ to) separate member).trans
      (eq_zero_of_not_pos fun pos => outsideK (sharedDrawn_gives (W := W)
        (cap := W.routedCapacity store cs ks e) (cs := cs) (c₀ := c₀) (ks := ks) (T := T) (n := n)
        (f := f) (g := e) pos).2.1)
  have giveLower : total ks (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x c) =
      rise (fun s => W.level s c) t + W.drawnUnit cs c₀ t c :=
    (Weighting.total_congr_on fun _ _ => routedDrawn_give_family (covers t from_ to) separate member).trans
      (sharedDrawn_given_members (W := W) (cap := W.routedCapacity store cs ks e) (T := T) (n := n)
        (f := f) (g := e) distinct inside apartK (routedCapacity_covers (covers t from_ to)) member)
  have giveUpper : total js (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x c) = 0 :=
    total_eq_zero fun x xin => (routedDrawn_give_family (covers t from_ to) separate member).trans
      (eq_zero_of_not_pos fun pos => tiers x (sharedDrawn_gives (W := W)
        (cap := W.routedCapacity store cs ks e) (cs := cs) (c₀ := c₀) (ks := ks) (T := T) (n := n)
        (f := f) (g := e) pos).2.1 xin)
  have giveOthers : total (ks ++ js) (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x c) =
      rise (fun s => W.level s c) t + W.drawnUnit cs c₀ t c := by
    rw [total_append, giveLower, giveUpper, Nat.add_zero]
  show W.level (t + 1) c + total ((routedDrawn W store cap₂ cs c₀ ks js T n f e).present t)
      (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t x c) =
    W.level t c + total ((routedDrawn W store cap₂ cs c₀ ks js T n f e).present t)
      (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x c)
  rw [present]
  show W.level (t + 1) c + ((routedDrawn W store cap₂ cs c₀ ks js T n f e).take t f c +
      total (ks ++ js) (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t x c)) =
    W.level t c + ((routedDrawn W store cap₂ cs c₀ ks js T n f e).give t f c +
      total (ks ++ js) (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x c))
  rw [takeSelf, takeOthers, giveSelf, giveOthers]
  exact (congrArg (W.level (t + 1) c + ·) (Nat.add_zero _)).trans ((Nat.add_assoc _ _ _).symm.trans
    ((congrArg (· + W.drawnUnit cs c₀ t c) (across (fun s => W.level s c) t)).trans
      ((Nat.add_assoc _ _ _).trans (congrArg (W.level t c + ·) (Nat.zero_add _).symm))))

end RoutedFlow

end Flow

/-- A positive sum has a positive part. -/
theorem pos_or_of_add_pos : ∀ {a b : Nat}, 0 < a + b → 0 < a ∨ 0 < b
  | 0, _, pos => .inr (Eq.subst (motive := fun k => 0 < k) (Nat.zero_add _) pos)
  | _ + 1, _, _ => .inl (Nat.succ_pos _)

namespace Flow

variable {C : Type}

section RoutedStores

variable [DecidableEq F] [DecidableEq C] {W : Web F C} [∀ t x, Decidable (W.active t x)]
  {store : F → C} {cap₂ : Nat → F → Nat} {cs : List C} {c₀ : C} {ks js : List F} {T n : Nat}
  {f e : F}

/-- In the routed flow each lower member takes from its own store what it can pass on, and nothing
else takes from it, where the stores are the lower members' own and not in the family, the tiers
are apart and `f` is in neither. -/
theorem routedDrawn_taken_store (apartK : Distinct ks) (outsideK : ¬ f ∈ ks)
    (tiers : ∀ h, h ∈ ks → ¬ h ∈ js)
    (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h')
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) {t : Nat} (from_ : T ≤ t) (to : t < T + n)
    {h : F} (member : h ∈ ks) :
    (routedDrawn W store cap₂ cs c₀ ks js T n f e).taken t (store h) =
      W.routedCapacity store cs ks e t h := by
  have present : (routedDrawn W store cap₂ cs c₀ ks js T n f e).present t = f :: (ks ++ js) :=
    if_pos ⟨from_, to⟩
  have inFamily : ¬ ∃ d, d ∈ cs ∧ d = store h := fun ⟨_, dIn, same⟩ =>
    separate h member (Eq.subst (motive := fun y => y ∈ cs) same dIn)
  have takeSelf : (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t f (store h) = 0 :=
    (if_neg fun both => inFamily both.2).trans
      (if_neg fun both => match both.1 with
        | ⟨_, kin, same⟩ => outsideK (Eq.subst (motive := fun y => y ∈ ks) same kin))
  have takeLower :
      total ks (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t x (store h)) =
        W.routedCapacity store cs ks e t h :=
    (total_eq_at (a := h) (fun x pos =>
        match (instDecidableAnd : Decidable (x = f ∧ ∃ d, d ∈ cs ∧ d = store h)) with
        | isTrue both => absurd both.2 inFamily
        | isFalse first =>
          match (instDecidableAnd : Decidable ((∃ k, k ∈ ks ∧ k = x) ∧ store h = store x)) with
          | isTrue ⟨⟨_, kin, same⟩, stores⟩ =>
            (own h x member (Eq.subst (motive := fun y => y ∈ ks) same kin) stores).symm
          | isFalse second => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
              ((if_neg first).trans (if_neg second)))) (Nat.lt_irrefl 0))
      apartK member).trans
      ((if_neg fun both => outsideK (Eq.subst (motive := fun y => y ∈ ks) both.1 member)).trans
        (if_pos ⟨⟨h, member, rfl⟩, rfl⟩))
  have takeUpper :
      total js (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t x (store h)) = 0 :=
    total_eq_zero fun x xin =>
      (if_neg fun both => inFamily both.2).trans
        (if_neg fun both => match both.1 with
          | ⟨_, kin, same⟩ => tiers x (Eq.subst (motive := fun y => y ∈ ks) same kin) xin)
  show total ((routedDrawn W store cap₂ cs c₀ ks js T n f e).present t)
      (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t x (store h)) = _
  rw [present]
  show (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t f (store h) +
      total (ks ++ js) (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t x (store h)) = _
  rw [takeSelf, total_append, takeLower, takeUpper, Nat.add_zero, Nat.zero_add]

/-- In the routed flow the router's store is given what is routed and every other lower member's
store nothing, where the others cover the demand. -/
theorem routedDrawn_given_store (apartJ : Distinct js) (outsideJ : ¬ f ∈ js)
    (tiers : ∀ h, h ∈ ks → ¬ h ∈ js)
    (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h')
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) {t : Nat} (from_ : T ≤ t) (to : t < T + n)
    (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t) {h : F} (member : h ∈ ks) :
    (routedDrawn W store cap₂ cs c₀ ks js T n f e).given t (store h) =
      if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0 := by
  have present : (routedDrawn W store cap₂ cs c₀ ks js T n f e).present t = f :: (ks ++ js) :=
    if_pos ⟨from_, to⟩
  have giveSelf : (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t f (store h) = 0 :=
    (routedDrawn_give_store separate member).trans
      (eq_zero_of_not_pos fun pos => outsideJ (routedGive_pos pos).2.2.1)
  have giveLower :
      total ks (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x (store h)) = 0 :=
    total_eq_zero fun x xin => (routedDrawn_give_store separate member).trans
      (eq_zero_of_not_pos fun pos => tiers x xin (routedGive_pos pos).2.2.1)
  have giveUpper :
      total js (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x (store h)) =
        if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0 :=
    (Weighting.total_congr_on fun _ _ => routedDrawn_give_store separate member).trans
      (routedGive_store apartJ own covers member)
  show total ((routedDrawn W store cap₂ cs c₀ ks js T n f e).present t)
      (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x (store h)) = _
  rw [present]
  show (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t f (store h) +
      total (ks ++ js) (fun x => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x (store h)) = _
  rw [giveSelf, total_append, giveLower, giveUpper, Nat.zero_add, Nat.zero_add]

/-- Each lower member's store balances in the routed flow, where it does not rise and the others
cover the demand. -/
theorem routedDrawn_balances_store (apartK : Distinct ks) (apartJ : Distinct js)
    (outsideK : ¬ f ∈ ks) (outsideJ : ¬ f ∈ js) (tiers : ∀ h, h ∈ ks → ¬ h ∈ js)
    (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h')
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) {t : Nat} (from_ : T ≤ t) (to : t < T + n)
    (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t) {h : F} (member : h ∈ ks)
    (steady : ¬ W.Rises t (store h)) :
    (routedDrawn W store cap₂ cs c₀ ks js T n f e).BalancesOn W [store h] t := by
  intro c mem
  have same : c = store h := match mem_cons_cases mem with
    | .inl same => same
    | .inr empty => nomatch empty
  subst same
  have flat : rise (fun s => W.level s (store h)) t = 0 :=
    eq_zero_of_not_pos fun pos => steady (excess_pos.mp pos)
  show W.level (t + 1) (store h) + (routedDrawn W store cap₂ cs c₀ ks js T n f e).taken t (store h) =
    W.level t (store h) + (routedDrawn W store cap₂ cs c₀ ks js T n f e).given t (store h)
  rw [routedDrawn_taken_store apartK outsideK tiers own separate from_ to member,
    routedDrawn_given_store apartJ outsideJ tiers own separate from_ to covers member]
  show W.level (t + 1) (store h) + (W.storeFall store t h +
      (if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0)) =
    W.level t (store h) + (if h = firstActiveOther W e t ks then W.routed store cs ks e t else 0)
  exact (Nat.add_assoc _ _ _).symm.trans (congrArg (· + _)
    ((across (fun s => W.level s (store h)) t).trans
      ((congrArg (W.level t (store h) + ·) flat).trans (Nat.add_zero _))))

/-- The steps at which the routed flow has anyone taking part lie in the stretch. -/
theorem routedDrawn_within {t : Nat} {x : F}
    (present : x ∈ (routedDrawn W store cap₂ cs c₀ ks js T n f e).present t) :
    T ≤ t ∧ t < T + n :=
  match (instDecidableAnd : Decidable (T ≤ t ∧ t < T + n)) with
  | isTrue within => within
  | isFalse outside => absurd (Eq.subst (motive := fun l => x ∈ l)
      (if_neg outside : (routedDrawn W store cap₂ cs c₀ ks js T n f e).present t = []) present)
      (fun empty => nomatch empty)

/-- What an upper member gives the lower members' stores in the routed flow is at most its
capacity, where the others cover the demand and the stores are the lower members' own. -/
theorem routedDrawn_upper_le (apartK : Distinct ks) (apartJ : Distinct js)
    (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h')
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs) {t : Nat}
    (covers : W.demand cs t ≤ W.othersThrough store cap₂ ks js e t) (x : F) :
    total ks (fun h => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t x (store h)) ≤
      cap₂ t x :=
  Nat.le_trans (Nat.le_of_eq (Weighting.total_congr_on fun _ inks =>
      routedDrawn_give_store separate inks))
    (show total ks (fun h => total (W.routedShares store cap₂ cs ks js e t)
        fun z => if z.1 = store h ∧ z.2 = x then 1 else 0) ≤ cap₂ t x from
    Nat.le_trans (Nat.le_of_eq (total_swap (fun (h : F) (z : C × F) =>
        if z.1 = store h ∧ z.2 = x then 1 else 0) (W.routedShares store cap₂ cs ks js e t) ks))
      (Nat.le_trans (total_le (q := fun (z : C × F) => if z.2 = x then 1 else 0) _ fun z mem =>
          match mem_pairUp mem with
          | ⟨units, _⟩ => match mem_repeatOnto units with
            | .inl ⟨atRouter, routedPos⟩ =>
              have router := router_of_routed covers routedPos
              Nat.le_trans (total_le_at_on (a := firstActiveOther W e t ks) (fun b bin pos =>
                  match (instDecidableAnd : Decidable (z.1 = store b ∧ z.2 = x)) with
                  | isTrue both => own b _ bin router.1 (both.1.symm.trans atRouter)
                  | isFalse no => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (if_neg no)))
                      (Nat.lt_irrefl 0)) apartK)
                (match decEq z.2 x with
                  | isTrue same => Nat.le_trans (Nat.le_of_eq (if_pos ⟨atRouter, same⟩))
                      (Nat.le_of_eq (if_pos same).symm)
                  | isFalse other => Nat.le_trans (Nat.le_of_eq (if_neg fun both => other both.2))
                      (Nat.zero_le _))
            | .inr empty => nomatch empty)
        (Nat.le_trans (total_pairUp_snd_le (fun j => if j = x then 1 else 0) _ _)
          (Nat.le_trans (Nat.le_of_eq (total_unitsOf (fun j => if j = x then 1 else 0) _ js))
            (Nat.le_trans (total_le_at (a := x) (fun (j : F) pos => match decEq j x with
                | isTrue same => same
                | isFalse other => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
                    ((congrArg (W.otherCapacity cap₂ e t j * ·) (if_neg other)).trans
                      (Nat.mul_zero _)))) (Nat.lt_irrefl 0)) apartJ)
              (Nat.le_trans (Nat.le_of_eq ((congrArg (W.otherCapacity cap₂ e t x * ·)
                (if_pos rfl)).trans (Nat.mul_one _))) (Web.otherCapacity_le cap₂ e t x)))))))

/-- **The routed flow is a flow of the two-tier hierarchy**, where the others cover the demand at
every step of the stretch, `f` is in neither tier, the tiers are apart, the stores are the lower
members' own and not in the family, and no store rises within the stretch. -/
theorem routedDrawn_fedThroughStores (distinct : Distinct cs) (inside : c₀ ∈ cs)
    (apartK : Distinct ks) (apartJ : Distinct js) (outsideK : ¬ f ∈ ks) (outsideJ : ¬ f ∈ js)
    (tiers : ∀ h, h ∈ ks → ¬ h ∈ js)
    (own : ∀ h h', h ∈ ks → h' ∈ ks → store h = store h' → h = h')
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs)
    (steady : ∀ t, T ≤ t → t < T + n → ∀ h, h ∈ ks → ¬ W.Rises t (store h))
    (covers : ∀ t, T ≤ t → t < T + n → W.demand cs t ≤ W.othersThrough store cap₂ ks js e t) :
    FedThroughStores W store cs ks js cap₂ T n (routedDrawn W store cap₂ cs c₀ ks js T n f e) :=
  ⟨⟨routedDrawn_balancesOn distinct inside apartK outsideK outsideJ tiers separate covers,
    fun _ _ _ _ gives => match pos_or_of_add_pos gives with
      | .inl shared => (sharedDrawn_gives (W := W) (cap := W.routedCapacity store cs ks e) (cs := cs)
          (c₀ := c₀) (ks := ks) (T := T) (n := n) (f := f) (g := e) shared).2.2.1
      | .inr upper => (routedGive_pos upper).2.2.2.1,
    fun t _ _ inFamily present gives =>
      have within := routedDrawn_within present
      (sharedDrawn_gives (W := W) (cap := W.routedCapacity store cs ks e) (cs := cs) (c₀ := c₀)
        (ks := ks) (T := T) (n := n) (f := f) (g := e)
        (Nat.lt_of_lt_of_le gives (Nat.le_of_eq (routedDrawn_give_family
          (covers t within.1 within.2) separate inFamily)))).2.1⟩,
   fun t from_ to =>
    have present : (routedDrawn W store cap₂ cs c₀ ks js T n f e).present t = f :: (ks ++ js) :=
      if_pos ⟨from_, to⟩
    ⟨Eq.subst (motive := fun l => Distinct l) present.symm
        ⟨fun mem => match ListTests.mem_append_iff.mp mem with
          | .inl k => outsideK k
          | .inr j => outsideJ j, distinct_append apartK apartJ tiers⟩,
     fun h member =>
      ⟨routedDrawn_balances_store apartK apartJ outsideK outsideJ tiers own separate from_ to
          (covers t from_ to) member (steady t from_ to h member),
       fun _ => Nat.le_trans (Nat.le_of_eq (Weighting.total_congr_on fun _ inFamily =>
           routedDrawn_give_family (covers t from_ to) separate inFamily))
         (Nat.le_trans (sharedDrawn_given_le (W := W) (cap := W.routedCapacity store cs ks e)
             (c₀ := c₀) (T := T) (n := n) (f := f) (g := e) distinct apartK t h)
           (Nat.le_trans (Web.otherCapacity_le (W.routedCapacity store cs ks e) e t h)
             (Nat.le_of_eq ((if_pos ⟨⟨h, member, rfl⟩, rfl⟩).symm.trans
               (if_neg fun both => outsideK
                 (Eq.subst (motive := fun y => y ∈ ks) both.1 member)).symm)))),
       fun _ _ gives => (routedGive_pos (Nat.lt_of_lt_of_le gives
         (Nat.le_of_eq (routedDrawn_give_store separate member)))).2.2.1⟩,
     fun x _ _ => routedDrawn_upper_le apartK apartJ own separate (covers t from_ to) x⟩⟩

/-- In the routed flow `f` draws past the family's stock, where it is active across a stretch
longer than the stock and the family holds `c₀`. -/
theorem routedDrawn_drawsPast (inside : c₀ ∈ cs)
    (alive : ∀ t, T ≤ t → t < T + n → W.active t f) (below : W.stock cs T < n) :
    DrawsPast cs T n (routedDrawn W store cap₂ cs c₀ ks js T n f e, W) f :=
  ⟨below, fun t from_ to =>
    have present : (routedDrawn W store cap₂ cs c₀ ks js T n f e).present t = f :: (ks ++ js) :=
      if_pos ⟨from_, to⟩
    ⟨alive t from_ to, Eq.subst (motive := fun l => f ∈ l) present.symm (.head _),
     match W.decSomeFalls cs t with
     | isTrue ⟨c, mem, falls⟩ =>
       total_pos_of_mem (q := (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t f) mem
        (Nat.lt_of_lt_of_le (excess_pos.mpr falls) (Nat.le_trans (Nat.le_add_right _ _)
          (Nat.le_of_eq (if_pos ⟨rfl, ⟨c, mem, rfl⟩⟩).symm)))
     | isFalse steady =>
       total_pos_of_mem (q := (routedDrawn W store cap₂ cs c₀ ks js T n f e).take t f) inside
        (Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_trans (Nat.le_add_left _ _)
          (Nat.le_trans (Nat.le_of_eq (congrArg (fall (fun s => W.level s c₀) t + ·)
            (if_pos ⟨rfl, steady⟩)).symm)
            (Nat.le_of_eq (if_pos ⟨rfl, ⟨c₀, inside, rfl⟩⟩).symm))))⟩⟩

/-- In the routed flow `e` gives nothing into the hierarchy, where the others cover the demand and
no store is in the family. -/
theorem routedDrawn_not_gives (distinct : Distinct cs) (apartK : Distinct ks)
    (separate : ∀ h, h ∈ ks → ¬ store h ∈ cs)
    (covers : ∀ t, T ≤ t → t < T + n → W.demand cs t ≤ W.othersThrough store cap₂ ks js e t) :
    ¬ GivesInto cs ks store T n (routedDrawn W store cap₂ cs c₀ ks js T n f e, W) e :=
  fun ⟨t, from_, to, _, gives⟩ =>
    have family : total cs ((routedDrawn W store cap₂ cs c₀ ks js T n f e).give t e) = 0 :=
      (Weighting.total_congr_on fun _ inFamily =>
        routedDrawn_give_family (covers t from_ to) separate inFamily).trans
        (sharedDrawn_quiet (W := W) (cap := W.routedCapacity store cs ks e) (c₀ := c₀) (T := T)
          (n := n) (f := f) (g := e) distinct apartK t)
    have stores :
        total ks (fun h => (routedDrawn W store cap₂ cs c₀ ks js T n f e).give t e (store h)) = 0 :=
      total_eq_zero fun _ inks => (routedDrawn_give_store separate inks).trans
        (eq_zero_of_not_pos fun pos => (routedGive_pos pos).2.2.2.2 rfl)
    Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le gives (Nat.le_of_eq
      ((congrArg (· + _) family).trans ((congrArg (0 + ·) stores).trans (Nat.zero_add 0)))))

end RoutedStores

end Flow
