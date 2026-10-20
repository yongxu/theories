/-! ## Several optimizers at once

Above, one part optimizes and the formations outside it exchange as they do. Here several
formations optimize at once, each alone, by its own order rising with its own family, and each
one's step is an optimum among the outcomes open to it, the others exchanging as they do in the
step that happened: a best best response. At a condition beyond every optimizer's family the
levels after the step are then exact: what the formations outside every optimizer leave there,
less the optimizers' joint capacity there, or nothing. -/

namespace Optimum

open Flow

/-- One formation as a part. -/
def alone [DecidableEq F] (h : F) : F → Bool := fun g => decide (g = h)

/-- A formation is the one part it forms alone. -/
theorem alone_self [DecidableEq F] (h : F) : alone h h = true :=
  decide_eq_true rfl

/-- **A best best response.** Across the step from `t`, each optimizer taking part acts within
its capacity in `L`, and the levels `o` are an optimum of its order among the outcomes open to it
alone, every other formation exchanging as it does in `L`. -/
def MutualBest [DecidableEq F] (L : Flow F C) (optimizer : F → Bool) (l : C → Nat)
    (cap : F → C → Nat) (ds rest : F → List C) (better : F → (C → Nat) → (C → Nat) → Prop)
    (t : Nat) (o : C → Nat) : Prop :=
  ∀ h, h ∈ L.present t → optimizer h = true →
    L.ActsWithin (alone h) cap (ds h ++ rest h) t L ∧
      Frontier (L.Outcome (alone h) l cap (ds h ++ rest h) t) (better h) o

variable {L : Flow F C} {optimizer : F → Bool} {l : C → Nat} {cap : F → C → Nat}
  {ds rest : F → List C} {better : F → (C → Nat) → (C → Nat) → Prop} {t : Nat} {o : C → Nat}

/-- **Restraint is no best best response.** Where something stands at a condition beyond an
optimizer's family after a best best response, that optimizer takes its whole capacity there and
gives nothing there. -/
theorem MutualBest.full [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (ds h ++ rest h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ rest h → ¬ c ∈ ds h)
    (inside : ∀ h, optimizer h = true → ∃ d, d ∈ ds h)
    (rising : ∀ h, optimizer h = true → Rising (ds h) (better h))
    (best : MutualBest L optimizer l cap ds rest better t o)
    (balances : ∀ x, o x + L.taken t x = l x + L.given t x) {h : F}
    (present : h ∈ L.present t) (opt : optimizer h = true) {c : C} (mem : c ∈ rest h)
    (positive : 0 < o c) : L.take t h c = cap h c ∧ L.give t h c = 0 :=
  (inside h opt).elim fun _ there =>
    Above.full distinct (cdistinct h opt) (apart h opt) there (rising h opt)
      (above_nothing (best h present opt).2) (best h present opt).1 balances mem positive
      present (alone_self h)

/-- **Several optimizers beyond, exactly.** After a best best response, at a condition beyond
every optimizer's family, the levels stand at the level before, with what the formations outside
every optimizer give and less what they take, less the optimizers' joint capacity there, or at
nothing. Where nothing stands, balance and capacity alone give it; where something stands, every
optimizer takes its whole capacity there and gives nothing. -/
theorem mutual_beyond [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (ds h ++ rest h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ rest h → ¬ c ∈ ds h)
    (inside : ∀ h, optimizer h = true → ∃ d, d ∈ ds h)
    (rising : ∀ h, optimizer h = true → Rising (ds h) (better h))
    (best : MutualBest L optimizer l cap ds rest better t o)
    (balances : ∀ x, o x + L.taken t x = l x + L.given t x) {c : C}
    (beyond : ∀ h, h ∈ L.present t → optimizer h = true → c ∈ rest h) :
    o c = l c + L.restGiven optimizer t c - L.restTaken optimizer t c -
      L.capacity optimizer cap t c :=
  have taken := total_split optimizer (fun h => L.take t h c) (L.present t)
  have given := total_split optimizer (fun h => L.give t h c) (L.present t)
  match Nat.eq_zero_or_pos (o c) with
  | .inl nothing => by
    have within : (total (L.present t) fun h => bif optimizer h then L.take t h c else 0) ≤
        L.capacity optimizer cap t c :=
      total_le _ fun h present => by
        show (bif optimizer h then L.take t h c else 0) ≤ (bif optimizer h then cap h c else 0)
        cases opt : optimizer h
        · exact Nat.le_refl 0
        · exact (best h present opt).1.2.2.1 h c (alone_self h)
    have reach : l c + L.restGiven optimizer t c ≤
        L.restTaken optimizer t c + L.capacity optimizer cap t c :=
      calc l c + L.restGiven optimizer t c
          ≤ l c + L.given t c := Nat.add_le_add_left (by
            rw [show L.given t c = _ from given]
            exact Nat.le_add_right _ _) _
        _ = o c + L.taken t c := (balances c).symm
        _ = L.taken t c := by rw [nothing, Nat.zero_add]
        _ ≤ L.restTaken optimizer t c + L.capacity optimizer cap t c := by
            rw [show L.taken t c = _ from taken]
            exact Nat.add_le_add_left within _
    rw [nothing, Naturals.sub_sub, sub_eq_zero_of_le reach]
  | .inr positive => by
    have takes : (total (L.present t) fun h => bif optimizer h then L.take t h c else 0) =
        L.capacity optimizer cap t c :=
      total_congr_on fun h present => by
        show (bif optimizer h then L.take t h c else 0) = (bif optimizer h then cap h c else 0)
        cases opt : optimizer h
        · rfl
        · exact (MutualBest.full distinct cdistinct apart inside rising best balances present opt
            (beyond h present opt) positive).1
    have gives : (total (L.present t) fun h => bif optimizer h then L.give t h c else 0) = 0 :=
      (total_congr_on fun h present => by
        show (bif optimizer h then L.give t h c else 0) = 0
        cases opt : optimizer h
        · rfl
        · exact (MutualBest.full distinct cdistinct apart inside rising best balances present opt
            (beyond h present opt) positive).2).trans (total_zero (L.present t))
    have full : o c + L.restTaken optimizer t c + L.capacity optimizer cap t c =
        l c + L.restGiven optimizer t c := by
      have step := balances c
      rw [show L.taken t c = _ from taken, show L.given t c = _ from given, takes, gives,
        Nat.add_zero, ← Nat.add_assoc] at step
      exact step
    rw [← full, Naturals.sub_sub, Nat.add_assoc, Naturals.add_sub_cancel]

/-- **Several optimizers leave the beyond where one with their joint capacity would.** At a
condition beyond every optimizer's family, the levels after a best best response stand where
every optimum of one part made of all the optimizers, of any order rising with any family apart
from that condition, would leave them. -/
theorem mutual_as_one [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (ds h ++ rest h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ rest h → ¬ c ∈ ds h)
    (inside : ∀ h, optimizer h = true → ∃ d, d ∈ ds h)
    (rising : ∀ h, optimizer h = true → Rising (ds h) (better h))
    (best : MutualBest L optimizer l cap ds rest better t o)
    (balances : ∀ x, o x + L.taken t x = l x + L.given t x) {c : C}
    (beyond : ∀ h, h ∈ L.present t → optimizer h = true → c ∈ rest h)
    {dsJ restJ : List C} (cdistinctJ : Distinct (dsJ ++ restJ))
    (apartJ : ∀ c, c ∈ restJ → ¬ c ∈ dsJ) {dJ : C} (insideJ : dJ ∈ dsJ)
    {betterJ : (C → Nat) → (C → Nat) → Prop} (risingJ : Rising dsJ betterJ) {o' : C → Nat}
    (optimum : Frontier (L.Outcome optimizer l cap (dsJ ++ restJ) t) betterJ o')
    (memJ : c ∈ restJ) : o c = o' c :=
  (mutual_beyond distinct cdistinct apart inside rising best balances beyond).trans
    (optimum_beyond distinct cdistinctJ apartJ insideJ risingJ optimum memJ).symm

/-- **Lowered exactly where the optimizers can take.** After a best best response, a condition
beyond every optimizer's family stands below where the formations outside every optimizer leave it
exactly where the optimizers have some capacity there and something is left there. -/
theorem mutual_lowers_iff [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (ds h ++ rest h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ rest h → ¬ c ∈ ds h)
    (inside : ∀ h, optimizer h = true → ∃ d, d ∈ ds h)
    (rising : ∀ h, optimizer h = true → Rising (ds h) (better h))
    (best : MutualBest L optimizer l cap ds rest better t o)
    (balances : ∀ x, o x + L.taken t x = l x + L.given t x) {c : C}
    (beyond : ∀ h, h ∈ L.present t → optimizer h = true → c ∈ rest h) :
    o c < l c + L.restGiven optimizer t c - L.restTaken optimizer t c ↔
      0 < L.capacity optimizer cap t c ∧
        0 < l c + L.restGiven optimizer t c - L.restTaken optimizer t c :=
  Eq.subst (motive := fun y => y < l c + L.restGiven optimizer t c - L.restTaken optimizer t c ↔
      0 < L.capacity optimizer cap t c ∧
        0 < l c + L.restGiven optimizer t c - L.restTaken optimizer t c)
    (mutual_beyond distinct cdistinct apart inside rising best balances beyond).symm
    (sub_lt_self_iff _ _)

end Optimum

namespace Web

open Flow Optimum

/-- **Several optimizers break a dependence beyond exactly where its need exceeds what the rest
leaves less their joint capacity.** Where the levels after the step are a best best response and
a condition beyond every optimizer's family is depended on at a need it meets, the dependence is
broken across the step exactly where its need exceeds the level before, with what the formations
outside every optimizer give and less what they take, less the optimizers' joint capacity. -/
theorem mutual_broken_iff_capacity [DecidableEq F] [DecidableEq C] {W : Web F C} {L : Flow F C}
    {optimizer : F → Bool} {cap : F → C → Nat} {ds rest : F → List C}
    {better : F → (C → Nat) → (C → Nat) → Prop} {t : Nat} {g : F} {c : C}
    (distinct : Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (ds h ++ rest h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ rest h → ¬ c ∈ ds h)
    (inside : ∀ h, optimizer h = true → ∃ d, d ∈ ds h)
    (rising : ∀ h, optimizer h = true → Rising (ds h) (better h))
    (best : MutualBest L optimizer (W.level t) cap ds rest better t (W.level (t + 1)))
    (balances : ∀ x, W.level (t + 1) x + L.taken t x = W.level t x + L.given t x)
    (beyond : ∀ h, h ∈ L.present t → optimizer h = true → c ∈ rest h)
    (depends : W.requires t g c) (meets : W.need t g c ≤ W.level t c) :
    W.Broken t g c ↔
      W.level t c + L.restGiven optimizer t c - L.restTaken optimizer t c -
        L.capacity optimizer cap t c < W.need t g c :=
  have at_ := mutual_beyond distinct cdistinct apart inside rising best balances beyond
  ⟨fun broken => Eq.subst (motive := fun y => y < W.need t g c) at_ broken.2.2,
   fun below => ⟨depends, meets, Eq.subst (motive := fun y => y < W.need t g c) at_.symm below⟩⟩

end Web

namespace Optimum

namespace TwoTakers

open Diversion

/-- Two takers and a dweller. -/
inductive Member where
  | taker (which : Bool)
  | dweller

/-- Equality of members is decided. -/
instance : DecidableEq Member
  | .taker true, .taker true => isTrue rfl
  | .taker false, .taker false => isTrue rfl
  | .taker true, .taker false => isFalse fun same => nomatch same
  | .taker false, .taker true => isFalse fun same => nomatch same
  | .dweller, .dweller => isTrue rfl
  | .taker _, .dweller => isFalse fun same => nomatch same
  | .dweller, .taker _ => isFalse fun same => nomatch same

/-- The optimizers: the two takers. -/
def takers : Member → Bool
  | .taker _ => true
  | .dweller => false

/-- Each taker may take one unit of the source and nothing of the store; the dweller nothing. -/
def capOf : Member → Place → Nat
  | .taker _, .source => 1
  | .taker _, .store => 0
  | .dweller, _ => 0

/-- What each taker gives: one unit to the store. -/
def giveOf : Member → Place → Nat
  | .taker _, .store => 1
  | .taker _, .source => 0
  | .dweller, _ => 0

/-- Both takers take one unit of the source and give it to the store. -/
def joint : Flow Member Place where
  present _ := [.taker true, .taker false, .dweller]
  take _ := capOf
  give _ := giveOf

/-- The second taker takes and gives as in `joint`; the first takes nothing. -/
def restrained : Flow Member Place where
  present _ := [.taker true, .taker false, .dweller]
  take _ f c := match f with
    | .taker true => 0
    | .taker false => capOf (.taker false) c
    | .dweller => 0
  give _ f c := match f with
    | .taker true => 0
    | .taker false => giveOf (.taker false) c
    | .dweller => 0

/-- After both takers draw: the source empty, the store at two. -/
def drained : Place → Nat
  | .source => 0
  | .store => 2

/-- After the second alone draws: one unit in each. -/
def kept : Place → Nat
  | .source => 1
  | .store => 1

/-- The members, without repetition. -/
theorem members_distinct :
    Distinct [Member.taker true, Member.taker false, Member.dweller] :=
  show ¬ Member.taker true ∈ [Member.taker false, Member.dweller] ∧
      (¬ Member.taker false ∈ [Member.dweller] ∧ (¬ Member.dweller ∈ ([] : List Member) ∧ True))
    from ⟨fun mem => (match mem_cons_cases mem with
      | .inl same => nomatch same
      | .inr mem => match mem_cons_cases mem with
        | .inl same => nomatch same
        | .inr mem => nomatch mem),
     fun mem => (match mem_cons_cases mem with
      | .inl same => nomatch same
      | .inr mem => nomatch mem),
     fun mem => (nomatch mem), trivial⟩

/-- Each taker acts within its capacity in `joint`. -/
theorem joint_within (w : Bool) :
    joint.ActsWithin (alone (Member.taker w)) capOf ([Place.store] ++ [Place.source]) 0 joint :=
  ⟨rfl, fun _ _ _ => ⟨rfl, rfl⟩, fun _ _ _ => Nat.le_refl _,
   fun _ c _ outside => match c with
    | .store => absurd (.head _) outside
    | .source => absurd (.tail _ (.head _)) outside,
   fun g member => match g, member with
    | .taker _, _ => Nat.le_refl 1
    | .dweller, member => absurd (of_decide_eq_true member) fun same => nomatch same⟩

/-- `joint` balances from `Drain.before` into `drained`. -/
theorem joint_balances : ∀ x, drained x + joint.taken 0 x = Drain.before x + joint.given 0 x
  | .source => rfl
  | .store => rfl

/-- Under a step within a taker's capacity, it gives the store at most one unit. -/
theorem gives_at_most_one {w : Bool} {L' : Flow Member Place}
    (acts : joint.ActsWithin (alone (Member.taker w)) capOf ([Place.store] ++ [Place.source]) 0 L') :
    L'.give 0 (.taker w) .store ≤ 1 :=
  have conserved : L'.give 0 (.taker w) .store + (L'.give 0 (.taker w) .source + 0) ≤
      L'.take 0 (.taker w) .store + (L'.take 0 (.taker w) .source + 0) :=
    acts.2.2.2.2 (.taker w) (alone_self _)
  have fromStore : L'.take 0 (.taker w) .store ≤ 0 := acts.2.2.1 (.taker w) .store (alone_self _)
  have fromSource : L'.take 0 (.taker w) .source ≤ 1 :=
    acts.2.2.1 (.taker w) .source (alone_self _)
  Nat.le_trans (Nat.le_add_right _ _) (Nat.le_trans conserved
    (Nat.le_trans (Nat.add_le_add fromStore (Nat.add_le_add_right fromSource 0))
      (Nat.le_refl 1)))

/-- **Each taker's draw is an optimum of the store's order, given the other's.** Every outcome open
to one taker alone, the other taking and giving as in `joint`, leaves the store at most two. -/
theorem joint_optimum (w : Bool) :
    Frontier (joint.Outcome (alone (Member.taker w)) Drain.before capOf
      ([Place.store] ++ [Place.source]) 0) Drain.storeOrder drained :=
  ⟨⟨joint, joint_within w, joint_balances⟩,
   fun o ⟨L', acts, balances⟩ above => by
    have store : o .store + L'.taken 0 .store = 0 + L'.given 0 .store := balances .store
    have gives : L'.given 0 .store = L'.give 0 (.taker true) .store +
        (L'.give 0 (.taker false) .store + (L'.give 0 .dweller .store + 0)) :=
      congrArg (fun ps => total ps fun f => L'.give 0 f .store) acts.1
    have dweller : L'.give 0 .dweller .store = 0 := (acts.2.1 .dweller .store rfl).2
    have atMost : L'.given 0 .store ≤ 2 := by
      rw [gives, dweller]
      cases w with
      | true =>
        rw [(acts.2.1 (.taker false) .store rfl).2]
        exact Nat.add_le_add_right (gives_at_most_one acts) _
      | false =>
        rw [(acts.2.1 (.taker true) .store rfl).2]
        exact Nat.add_le_add_left (Nat.add_le_add_right (gives_at_most_one acts) _) _
    exact Nat.not_le_of_gt above (Nat.le_trans (Nat.le_add_right _ _)
      (Nat.le_trans (Nat.le_of_eq (store.trans (Nat.zero_add _))) atMost))⟩

/-- **Both takers drawing is a best best response.** -/
theorem joint_best :
    MutualBest joint takers Drain.before capOf (fun _ => [Place.store]) (fun _ => [Place.source])
      (fun _ => Drain.storeOrder) 0 drained :=
  fun h _ opt => match h, opt with
    | .taker w, _ => ⟨joint_within w, joint_optimum w⟩

/-- The hypotheses on the takers' lists and orders. -/
theorem lists :
    (∀ h, takers h = true → Distinct ([Place.store] ++ [Place.source])) ∧
      (∀ h, takers h = true → ∀ c, c ∈ [Place.source] → ¬ c ∈ [Place.store]) ∧
      (∀ h, takers h = true → ∃ d, d ∈ [Place.store]) ∧
      (∀ h, takers h = true → Rising [Place.store] Drain.storeOrder) :=
  ⟨fun _ _ => Drain.store_source_distinct, fun _ _ => DrawnBeyond.source_apart,
   fun _ _ => ⟨_, .head []⟩, fun _ _ => Drain.storeOrder_rising⟩

/-- **The source falls by the takers' joint capacity, to nothing.** Derived from `mutual_beyond`:
the source stood at two, the dweller neither gives nor takes there, and the takers' joint capacity
there is two. -/
theorem joint_drains : drained .source = Drain.before .source - joint.capacity takers capOf 0 .source ∧
    joint.capacity takers capOf 0 .source = 2 :=
  ⟨mutual_beyond (ds := fun _ => [Place.store]) (rest := fun _ => [Place.source])
    members_distinct lists.1 lists.2.1 lists.2.2.1 lists.2.2.2 joint_best joint_balances
    (fun _ _ _ => .head []), rfl⟩

/-- **Each take is within the slack of a need of one; together they fall below it.** Each taker
takes one unit, leaving the source at the need of one or above were it alone, and the mutual best
response leaves the source below that need. -/
theorem within_slack_jointly_below :
    (∀ w, joint.take 0 (.taker w) .source + 1 ≤ Drain.before .source) ∧ drained .source < 1 :=
  ⟨fun _ => Nat.le_refl 2, Nat.succ_pos 0⟩

/-- `restrained` balances from `Drain.before` into `kept`. -/
theorem restrained_balances :
    ∀ x, kept x + restrained.taken 0 x = Drain.before x + restrained.given 0 x
  | .source => rfl
  | .store => rfl

/-- **One taker's restraint is no best best response.** Where the first taker takes nothing and
the second draws, a unit stands at the source, so the first does not take its whole capacity there:
whatever the orders, families and listings, the step is no best best response. -/
theorem restrained_not_mutual :
    ¬ MutualBest restrained takers Drain.before capOf (fun _ => [Place.store])
      (fun _ => [Place.source]) (fun _ => Drain.storeOrder) 0 kept := fun best =>
  absurd (MutualBest.full (L := restrained) (ds := fun _ => [Place.store])
    (rest := fun _ => [Place.source]) members_distinct lists.1 lists.2.1 lists.2.2.1 lists.2.2.2
    best restrained_balances (h := .taker true) (.head _) rfl (.head [])
    (Nat.succ_pos 0)).1 fun same => nomatch same

end TwoTakers

end Optimum

