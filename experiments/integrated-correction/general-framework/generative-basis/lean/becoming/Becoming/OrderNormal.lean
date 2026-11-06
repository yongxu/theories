import Becoming.IdleRemoval

/-!
# The order of exchanges completed: normal form, census, least footprint

`Becoming.Order` read the order of a world's exchanges off a footprint: two consecutive exchanges
not joined commute (`Footprinted.commute`), the order `Precedes` of joined exchanges is kept
(`reorder_precedes`), and the renumberings reached are exactly those keeping it (`sorts_iff`). This
module completes three things it left open: a canonical arrangement of the exchanges of a stretch
(a normal form) and exactly the decision it needs, the census along reordering, and the footprint
read off the world.

* **Commuting by a relation.** `Commutes J ts`: each commutation of the list takes two consecutive
  steps a relation `J` does not join, `J` read in the arrangement as it then stands. A world's
  commutations are those of the relation its footprint joins (`Footprinted.independent_iff_commutes`).
  For any symmetric relation the bubble sort of `Becoming.Order` runs unchanged (`sorts_by`,
  `sorts_by_iff`): the renumberings reached are exactly those keeping the order the relation gives
  (`KeepsOrder`, which for `Joined` is `Footprinted.Keeps`).
* **Arrangements of a stretch.** An arrangement takes each exchange of the stretch of `m` steps
  from `S` to a step of it (`Reindexes S m π σ`; commutations within the stretch are such,
  `reindexes_of_within`). The exchanges are named by the numbers `π` arranges, and joining is read
  between named exchanges. `Rearranges joined S m π σ π'`: `π'` is reached from `(π, σ)` by
  commutations within the stretch, each of two consecutive exchanges not joined as the arrangement
  then stands. `Orients joined S m π π'`: `π'` takes every two joined exchanges in the order `π` does.
  - **Mazurkiewicz's theorem, with no decision** (`rearranges_iff`): with joining symmetric, one
    arrangement is reached from another exactly where the two orient every joined pair alike. So
    reaching is an equivalence (`Rearranges.symm`, `Rearranges.trans`). From the arrangement a world
    is in, the arrangements reached are its reorderings (`Footprinted.rearranges_iff_independent`,
    `Footprinted.keeps_iff_orients`).
* **The lexicographic normal form.** Given a decision `apart` of apartness on the stretch
  (`DecidesApart`: for two different exchanges of it, `apart i j = true` exactly where they are not
  joined), the sort `normalSteps` fills the steps from `S` in turn: at each it brings forward, past
  exchanges not joined to it, the least-named exchange free from there (`freeAt`, `normalPick`; the
  exchange already there is free, `pick_spec`). `normalForm` is where the sort takes each exchange.
  - It is an arrangement reached from the given one (`normalForm_reindexes`,
    `normalForm_rearranges`), and it depends only on the order of joined exchanges: arrangements
    orienting joined pairs alike have the same exchange free at each stage (`free_transfer`), so the
    same sort result (`normalSteps_agree`, `normalForm_agree`).
  - **The normal form theorem** (`normalForm_iff`): with joining symmetric and apartness decided,
    two arrangements are reached from each other exactly where they have the same normal form. It is
    its own normal form (`normalForm_normal`), and it is lexicographically least among the
    arrangements reached: at the first step where it differs from one, it holds the lesser-named
    exchange (`normalForm_least`).
  - Three exchanges with the first and last joined (`Triple`): last to first, the normal form is
    middle, last, first (`Triple.reversed_normal`); first to last, it is that order
    (`Triple.identity_normal`); so the two orders are not reached from each other
    (`Triple.not_rearranged`).
* **Exactly the decision needed.** A complete invariant of arrangements (`CompleteInvariant`: a
  function of arrangements agreeing on two exactly where they are reached from each other) exists
  exactly where apartness is decided on the stretch (`complete_iff`): the normal form is one given
  the decision (`normalForm_complete`), and any one decides apartness of every two exchanges, by
  comparing the two ways of taking them side by side (`pair_rearranges`, `decides_of_complete`).
  Apartness, not joining, is what is decided: joining is then decided only up to its double
  negation, which is all the normal form uses.
* **The normal form of a world.** `Footprinted.normalize` commutes, two exchanges not joined at a
  time, a world's exchanges over a stretch into their normal form. It meets every premise exactly
  where the world does and keeps the order (`normalize_premises`, `normalize_precedes`). A
  reordering is determined by its arrangement (`Footprinted.reorder_determined`: two reorderings by
  commutations not joined taking each exchange to the same step take the same exchanges and show
  every relatum alike over the stretch), so **every reordering has the world's normal form**
  (`Footprinted.normalize_reorder`): reorder in any way, normalize with each exchange named by the
  step it held in the world, and the world reached agrees over the stretch with the world's own
  normal form.
* **The census along reordering.** A census carries along every commutation, joined or not, split
  or not (`Web.commute_census`, `Web.commute_standingCensus`, `World.commute_counted`): what is
  active, or stands, between the two steps is listed by keeping one side of the census before them
  and the other side of the census after them (`listed_splice`). Where the sides split the two steps
  it carries back (`Web.commute_census_back`, `World.commute_counted_iff`). So along every
  `Reorders`, joined or not, the web reached has a census of what is active, and of what stands,
  exactly where the web has one (`Reorders.census`); commuting a world's exchanges in any way keeps
  a census (`Footprinted.counted_reorder`, `Footprinted.standing_reorder`), and commuting exchanges
  not joined keeps it both ways (`Footprinted.reorder_census`). With `World.withoutIdle_counted`,
  neither removing idle steps nor reordering changes whether a world is counted.
* **The least footprint.** Where idleness is decided (`DecidesIdle`: at each step, whether a
  relatum takes no part in its exchange and is unmoved across it), the footprint touching each
  relatum not idle (`Footprinted.least`, `least_touch_iff`) contains the exchanges
  (`least_contains`) and is least: every containing footprint touches what it touches
  (`least_le`). So it joins least and orders least: its `Joined` and `Precedes` are contained in
  those of every containing footprint (`least_joined`, `least_precedes`), and every renumbering
  reached under a containing footprint is reached under it (`least_keeps`).
  - **The boundary** (`least_exists_iff`): with equality of relata decided, a least containing
    footprint exists exactly where idleness is decided; and since taking part is then decided,
    exactly where being unmoved is decided for the relata taking no part (`decidesIdle_iff`).

Reading (the AI's, adopted on Ren's delegation of 15 October 2026, DELEGATED-CHOICES D30): the order
of exchanges is an object of its own. Which arrangements of a stretch are the same course of change
is fixed by the order of joined exchanges alone, with no decision; picking one arrangement to stand
for each, a normal form, needs exactly that apartness be decided, and names for the exchanges.
Counting what is active or stands does not depend on the order at all. Read off the world, the order
is least where idleness is decided, and then it is the world's own rather than a footprint's.

Not shown: a normal form without names. The normal form is canonical relative to the names of the
exchanges, here the steps of one arrangement (`Footprinted.normalize_reorder` names each exchange by
the step it held in the world); a normal form read off the exchanges alone is not addressed. The Foata
normal form (steps of exchanges taken together) is not given. A normal form over an unbounded
run. Without idleness decided no least footprint is constructed; that it is then not constructible
is the equivalence, not a witness world. The sides of `Reorders` remain given. No ethical
predicate, ranking or axiom occurs.
-/

namespace Becoming

/-! ## Booleans, excess and searching -/

/-- Where `a ≤ b`, `a` with the excess of `b` over it is `b`. -/
theorem add_excess_of_le {a b : Nat} (le : a ≤ b) : a + excess b a = b :=
  (excess_balance a b).trans
    (congrArg (b + ·) (eq_zero_of_not_pos fun pos => Nat.not_lt_of_le le (excess_pos.mp pos)))

/-- The first number from `a`, among the next `n`, at which `P` holds; `a + n` where none does. -/
def firstWhere (P : Nat → Bool) : Nat → Nat → Nat
  | a, 0 => a
  | a, n + 1 => cond (P a) a (firstWhere P (a + 1) n)

theorem firstWhere_ge (P : Nat → Bool) : ∀ (a n : Nat), a ≤ firstWhere P a n
  | _, 0 => Nat.le_refl _
  | a, n + 1 => match h : P a with
    | true => Nat.le_of_eq (cond_of_true (x := a) (y := firstWhere P (a + 1) n) h).symm
    | false => Nat.le_trans (Nat.le_succ a) (Nat.le_trans (firstWhere_ge P (a + 1) n)
        (Nat.le_of_eq (cond_of_false (x := a) (y := firstWhere P (a + 1) n) h).symm))

/-- Before the first, `P` fails. -/
theorem firstWhere_before (P : Nat → Bool) : ∀ (a n j : Nat), a ≤ j → j < firstWhere P a n →
    P j = false
  | _, 0, _, from_, below => absurd below (Nat.not_lt_of_le from_)
  | a, n + 1, j, from_, below => match h : P a with
    | true => absurd (Nat.lt_of_lt_of_le below
        (Nat.le_of_eq (cond_of_true (x := a) (y := firstWhere P (a + 1) n) h)))
        (Nat.not_lt_of_le from_)
    | false => match Nat.decEq j a with
      | .isTrue same => Eq.subst (motive := fun k => P k = false) same.symm h
      | .isFalse other => firstWhere_before P (a + 1) n j
          (Nat.succ_le_of_lt (lt_of_le_ne from_ fun e => other e.symm))
          (Nat.lt_of_lt_of_le below
            (Nat.le_of_eq (cond_of_false (x := a) (y := firstWhere P (a + 1) n) h)))

/-- Where `P` holds somewhere among the `n` numbers from `a`, the first is no later and `P`
holds there. -/
theorem firstWhere_found (P : Nat → Bool) : ∀ (a n i : Nat), a ≤ i → i < a + n → P i = true →
    firstWhere P a n ≤ i ∧ P (firstWhere P a n) = true
  | _, 0, _, from_, below, _ => absurd below (Nat.not_lt_of_le from_)
  | a, n + 1, i, from_, below, holds => match h : P a with
    | true => Eq.subst (motive := fun k => k ≤ i ∧ P k = true)
        (cond_of_true (x := a) (y := firstWhere P (a + 1) n) h).symm ⟨from_, h⟩
    | false =>
      have other : a ≠ i := fun same => Bool.noConfusion
        (h.symm.trans (Eq.subst (motive := fun k => P k = true) same.symm holds))
      Eq.subst (motive := fun k => k ≤ i ∧ P k = true)
        (cond_of_false (x := a) (y := firstWhere P (a + 1) n) h).symm
        (firstWhere_found P (a + 1) n i (Nat.succ_le_of_lt (lt_of_le_ne from_ other))
          (Nat.lt_of_lt_of_le below (Nat.le_of_eq (Nat.add_right_comm a 1 n).symm)) holds)

/-- The first depends only on where `P` holds among the numbers searched. -/
theorem firstWhere_congr {P Q : Nat → Bool} : ∀ (a n : Nat),
    (∀ i, a ≤ i → i < a + n → P i = Q i) → firstWhere P a n = firstWhere Q a n
  | _, 0, _ => rfl
  | a, n + 1, same =>
    have here : P a = Q a := same a (Nat.le_refl a) (Nat.lt_succ_of_le (Nat.le_add_right a n))
    have rest := firstWhere_congr (a + 1) n fun i from_ below =>
      same i (Nat.le_of_succ_le from_)
        (Nat.lt_of_lt_of_le below (Nat.le_of_eq (Nat.add_right_comm a 1 n)))
    show cond (P a) a (firstWhere P (a + 1) n) = cond (Q a) a (firstWhere Q (a + 1) n) from
      (congrArg (fun b => cond b a (firstWhere P (a + 1) n)) here).trans
        (congrArg (cond (Q a) a) rest)

/-! ## Commuting exchanges a relation does not join -/

/-- Each commutation of the list takes two consecutive exchanges that `J` does not join, `J`
read in the arrangement as it then stands. -/
def Commutes : (Nat → Nat → Prop) → List Nat → Prop
  | _, [] => True
  | J, t :: ts => ¬ J t (t + 1) ∧ Commutes (fun a b => J (swapAt t a) (swapAt t b)) ts

/-- A renumbering keeps the order `J` gives the steps of a stretch. -/
def KeepsOrder (J : Nat → Nat → Prop) (S m : Nat) (π : Nat → Nat) : Prop :=
  ∀ i j, S ≤ i → j < S + m → i < j → J i j → π i < π j

theorem Commutes.of_iff : ∀ {J J' : Nat → Nat → Prop} {ts : List Nat},
    (∀ a b, J a b ↔ J' a b) → (Commutes J ts ↔ Commutes J' ts)
  | _, _, [], _ => Iff.rfl
  | _, _, t :: _, same =>
    ⟨fun ⟨apart, rest⟩ => ⟨fun j => apart ((same t (t + 1)).mpr j),
       (Commutes.of_iff fun a b => same (swapAt t a) (swapAt t b)).mp rest⟩,
     fun ⟨apart, rest⟩ => ⟨fun j => apart ((same t (t + 1)).mp j),
       (Commutes.of_iff fun a b => same (swapAt t a) (swapAt t b)).mpr rest⟩⟩

theorem Commutes.append : ∀ {J : Nat → Nat → Prop} {ts us : List Nat}, Commutes J ts →
    Commutes (fun a b => J (origin ts a) (origin ts b)) us → Commutes J (ts ++ us)
  | _, [], _, _, each => each
  | _, _ :: _, _, ⟨apart, rest⟩, each => ⟨apart, Commutes.append rest each⟩

/-- Commuting exchanges not joined keeps the order of joined ones. -/
theorem Commutes.keeps : ∀ {J : Nat → Nat → Prop} {ts : List Nat}, Commutes J ts →
    ∀ {a b : Nat}, a < b → J a b → place ts a < place ts b
  | _, [], _, _, _, lt, _ => lt
  | J, t :: _, ⟨apart, rest⟩, a, b, lt, joined =>
    Commutes.keeps rest
      (swapAt_lt lt fun ha hb => apart (Eq.subst (motive := fun k => J t k) hb
        (Eq.subst (motive := fun k => J k b) ha joined)))
      (cast (congr (congrArg J (swapAt_swapAt t a).symm) (swapAt_swapAt t b).symm) joined)

/-- The exchange a renumbering keeping the order brings first is joined to none before it. -/
theorem KeepsOrder.first_free {J : Nat → Nat → Prop} {S m : Nat} {π σ : Nat → Nat}
    (reindex : Reindexes S (m + 1) π σ) (keeps : KeepsOrder J S (m + 1) π) {p : Nat}
    (from_ : S ≤ p) (below : p < σ S) : ¬ J p (σ S) :=
  fun joined =>
    have hS := (reindex S (Nat.le_refl S) (Nat.lt_add_of_pos_right (Nat.succ_pos m))).2
    have hp := (reindex p from_ (Nat.lt_trans below hS.2.1)).1
    Nat.not_le_of_gt (Nat.lt_of_lt_of_le (keeps p (σ S) from_ hS.2.1 below joined)
      (Nat.le_of_eq hS.2.2)) hp.1

/-- Where no exchange from step `a` up to step `a + d` is joined to the one across `a + d`,
bringing that one to `a` commutes exchanges not joined. -/
theorem lowering_commutes {a : Nat} : ∀ {d : Nat} {J : Nat → Nat → Prop},
    (∀ p, a ≤ p → p < a + d → ¬ J p (a + d)) → Commutes J (lowering a d)
  | 0, _, _ => trivial
  | d + 1, J, free =>
    ⟨free (a + d) (Nat.le_add_right a d) (Nat.lt_succ_self _),
     lowering_commutes (J := fun x y => J (swapAt (a + d) x) (swapAt (a + d) y))
      fun p from_ below joined => free p from_ (Nat.lt_succ_of_lt below)
        (cast (congr (congrArg J (swapAt_of_lt below)) (swapAt_first (a + d))) joined)⟩

/-- Brought forward, the rest keeps the order of the relation read there. -/
theorem lowered_keepsOrder {J : Nat → Nat → Prop} {S m d : Nat} {π : Nat → Nat}
    (symm : ∀ a b, J a b → J b a) (commutes : Commutes J (lowering S d))
    (keeps : KeepsOrder J S (m + 1) π) (dm : d ≤ m) :
    KeepsOrder (fun a b => J (origin (lowering S d) a) (origin (lowering S d) b)) (S + 1) m
      (fun a => π (origin (lowering S d) a)) :=
  fun a b from_ below lt joined =>
    have na := Footprinted.lowered_origin dm from_ (Nat.lt_trans lt below)
    have nb := Footprinted.lowered_origin dm (Nat.le_trans from_ (Nat.le_of_lt lt)) below
    match Nat.lt_or_ge (origin (lowering S d) a) (origin (lowering S d) b) with
    | .inl before => keeps _ _ na.1 nb.2.1 before joined
    | .inr ge => match Nat.lt_or_ge (origin (lowering S d) b) (origin (lowering S d) a) with
      | .inl after =>
        have back := Commutes.keeps commutes after (symm _ _ joined)
        have ba : b < a := Eq.subst (motive := fun k => k < a) (place_origin (lowering S d) b)
          (Eq.subst (motive := fun k => place (lowering S d) (origin (lowering S d) b) < k)
            (place_origin (lowering S d) a) back)
        absurd (Nat.lt_trans lt ba) (Nat.lt_irrefl a)
      | .inr ge' =>
        have same : a = b := (place_origin (lowering S d) a).symm.trans
          ((congrArg (place (lowering S d)) (Nat.le_antisymm ge' ge)).trans
            (place_origin (lowering S d) b))
        absurd (Eq.subst (motive := (a < ·)) same.symm lt) (Nat.lt_irrefl a)

/-- One step of the sort by a relation: bring forward the exchange the renumbering puts first,
then sort the rest. -/
theorem sorts_step_by {m S d : Nat} {J : Nat → Nat → Prop} {π σ : Nat → Nat}
    (symm : ∀ a b, J a b → J b a) (reindex : Reindexes S (m + 1) π σ)
    (keeps : KeepsOrder J S (m + 1) π) (hk : σ S = S + d)
    (sub : ∀ {J' : Nat → Nat → Prop} {π' σ' : Nat → Nat}, (∀ a b, J' a b → J' b a) →
      Reindexes (S + 1) m π' σ' → KeepsOrder J' (S + 1) m π' →
      ∃ ts, EachStep (fun t => S + 1 ≤ t ∧ t + 2 ≤ S + 1 + m) ts ∧ Commutes J' ts ∧
        ∀ i, S + 1 ≤ i → i < S + 1 + m → place ts i = π' i) :
    ∃ ts, EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + (m + 1)) ts ∧ Commutes J ts ∧
      ∀ i, S ≤ i → i < S + (m + 1) → place ts i = π i :=
  have hS := (reindex S (Nat.le_refl S) (Nat.lt_add_of_pos_right (Nat.succ_pos m))).2
  have top : S + d < S + (m + 1) := Eq.subst (motive := (· < S + (m + 1))) hk hS.2.1
  have dm : d ≤ m :=
    Nat.le_of_lt_succ (Naturals.le_of_add_le_add_left (k := S) (a := d + 1) (b := m + 1) top)
  have free : ∀ p, S ≤ p → p < S + d → ¬ J p (S + d) := fun p from_ below =>
    Eq.subst (motive := fun k => ¬ J p k) hk
      (KeepsOrder.first_free reindex keeps from_ (Eq.subst (motive := (p < ·)) hk.symm below))
  have commutes := lowering_commutes free
  match sub (J' := fun a b => J (origin (lowering S d) a) (origin (lowering S d) b))
      (fun _ _ joined => symm _ _ joined) (Footprinted.lowered_reindexes reindex hk dm)
      (lowered_keepsOrder symm commutes keeps dm) with
  | ⟨rest, within, commutes', places⟩ =>
    ⟨lowering S d ++ rest,
     EachStep.append (lowering_within S (m + 1) d (Nat.lt_succ_of_le dm))
       (EachStep.mono (fun _ bounds => ⟨Nat.le_of_succ_le bounds.1,
         Nat.le_trans bounds.2 (Nat.le_of_eq (Nat.add_right_comm S 1 m))⟩) within),
     Commutes.append commutes commutes',
     fun i from_ below => (place_append (lowering S d) rest i).trans
       (match Nat.decEq i (S + d) with
       | .isTrue here =>
         have first : place (lowering S d) i = S :=
           (congrArg (place (lowering S d)) here).trans (place_lowering_top S d)
         (congrArg (place rest) first).trans
           ((place_fixed (p := fun t => S + 1 ≤ t ∧ t + 2 ≤ S + 1 + m)
             (fun _ bounds => ⟨Nat.ne_of_lt bounds.1,
               Nat.ne_of_lt (Nat.lt_succ_of_lt bounds.1)⟩) within).trans
             (hS.2.2.symm.trans (congrArg π (hk.trans here.symm))))
       | .isFalse other =>
         have placed := Footprinted.lowered_place dm from_ below other
         (places (place (lowering S d) i) placed.1 placed.2).trans
           (congrArg π (origin_place (lowering S d) i)))⟩

/-- **Sorting by a relation.** For a symmetric relation `J` on the steps of a stretch and a
renumbering of the stretch keeping the order `J` gives, commutations within the stretch, each of
two consecutive exchanges `J` does not join as it then stands, take each step where the
renumbering does. -/
theorem sorts_by : ∀ (m S : Nat) {J : Nat → Nat → Prop} {π σ : Nat → Nat},
    (∀ a b, J a b → J b a) → Reindexes S m π σ → KeepsOrder J S m π →
      ∃ ts, EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) ts ∧ Commutes J ts ∧
        ∀ i, S ≤ i → i < S + m → place ts i = π i
  | 0, _, _, _, _, _, _, _ =>
    ⟨[], trivial, trivial, fun _ from_ below => absurd below (Nat.not_lt_of_le from_)⟩
  | m + 1, S, _, _, _, symm, reindex, keeps =>
    match le_dest (reindex S (Nat.le_refl S) (Nat.lt_add_of_pos_right (Nat.succ_pos m))).2.1 with
    | ⟨_, hk⟩ => sorts_step_by symm reindex keeps hk
        (fun symm' reindex' keeps' => sorts_by m (S + 1) symm' reindex' keeps')

/-- So the renumberings reached by commuting exchanges a symmetric relation does not join are
exactly those keeping the order it gives. -/
theorem sorts_by_iff {S m : Nat} {J : Nat → Nat → Prop} {π σ : Nat → Nat}
    (symm : ∀ a b, J a b → J b a) (reindex : Reindexes S m π σ) :
    (∃ ts, EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) ts ∧ Commutes J ts ∧
        ∀ i, S ≤ i → i < S + m → place ts i = π i) ↔ KeepsOrder J S m π :=
  ⟨fun ⟨ts, _, commutes, places⟩ i j from_ below lt joined =>
    Eq.subst (motive := fun k => k < π j) (places i from_ (Nat.lt_trans lt below))
      (Eq.subst (motive := fun k => place ts i < k)
        (places j (Nat.le_trans from_ (Nat.le_of_lt lt)) below)
        (Commutes.keeps commutes lt joined)),
   sorts_by m S symm reindex⟩

namespace Footprinted

variable {X : Type}

/-- **A world's commutations are those of the relation its footprint joins.** Commuting
exchanges not joined, each in the world as it then stands, is commuting by `Joined` read in the
arrangement. -/
theorem independent_iff_commutes : ∀ {r : Footprinted X} {ts : List Nat}, r.Contains →
    (r.Independent ts ↔ Commutes r.Joined ts)
  | _, [], _ => Iff.rfl
  | r, t :: _, contains =>
    ⟨fun ⟨apart, rest⟩ => ⟨apart, (Commutes.of_iff fun _ _ => commute_joined contains apart).mp
        ((independent_iff_commutes (r := r.commute t) (commute_contains contains)).mp rest)⟩,
     fun ⟨apart, rest⟩ => ⟨apart,
       (independent_iff_commutes (r := r.commute t) (commute_contains contains)).mpr
        ((Commutes.of_iff fun _ _ => commute_joined contains apart).mpr rest)⟩⟩

end Footprinted

/-! ## Arrangements of a stretch -/

section Arrangements

/-- Exchanging `t` and `t + 1` within a stretch holding both keeps the stretch. -/
theorem swapAt_within {S m t n : Nat} (bounds : S ≤ t ∧ t + 2 ≤ S + m) (from_ : S ≤ n)
    (below : n < S + m) : S ≤ swapAt t n ∧ swapAt t n < S + m :=
  match Nat.decEq n t with
  | .isTrue here => Eq.subst (motive := fun k => S ≤ k ∧ k < S + m)
      ((swapAt_first t).symm.trans (congrArg (swapAt t) here.symm))
      ⟨Nat.le_succ_of_le bounds.1, bounds.2⟩
  | .isFalse other => match Nat.decEq n (t + 1) with
    | .isTrue here => Eq.subst (motive := fun k => S ≤ k ∧ k < S + m)
        ((swapAt_second t).symm.trans (congrArg (swapAt t) here.symm))
        ⟨bounds.1, Nat.lt_trans (Nat.lt_succ_self t) bounds.2⟩
    | .isFalse other' => Eq.subst (motive := fun k => S ≤ k ∧ k < S + m)
        (swapAt_away other other').symm ⟨from_, below⟩

theorem place_within {S m : Nat} : ∀ {ts : List Nat}, EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) ts →
    ∀ {n : Nat}, S ≤ n → n < S + m → S ≤ place ts n ∧ place ts n < S + m
  | [], _, _, from_, below => ⟨from_, below⟩
  | _ :: _, ⟨bounds, rest⟩, _, from_, below =>
    have h := swapAt_within bounds from_ below
    place_within rest h.1 h.2

theorem origin_within {S m : Nat} : ∀ {ts : List Nat}, EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) ts →
    ∀ {n : Nat}, S ≤ n → n < S + m → S ≤ origin ts n ∧ origin ts n < S + m
  | [], _, _, from_, below => ⟨from_, below⟩
  | _ :: _, ⟨bounds, rest⟩, _, from_, below =>
    have h := origin_within rest from_ below
    swapAt_within bounds h.1 h.2

/-- Commutations within a stretch renumber it among itself. -/
theorem reindexes_of_within {S m : Nat} {ts : List Nat}
    (within : EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) ts) :
    Reindexes S m (place ts) (origin ts) :=
  fun i from_ below =>
    have p := place_within within from_ below
    have o := origin_within within from_ below
    ⟨⟨p.1, p.2, origin_place ts i⟩, ⟨o.1, o.2, place_origin ts i⟩⟩

theorem Reindexes.identity (S m : Nat) : Reindexes S m (fun i => i) (fun i => i) :=
  fun _ from_ below => ⟨⟨from_, below, rfl⟩, ⟨from_, below, rfl⟩⟩

theorem Reindexes.symm {S m : Nat} {π σ : Nat → Nat} (reindex : Reindexes S m π σ) :
    Reindexes S m σ π :=
  fun i from_ below => ⟨(reindex i from_ below).2, (reindex i from_ below).1⟩

theorem Reindexes.comp {S m : Nat} {π σ π' σ' : Nat → Nat} (first : Reindexes S m π σ)
    (second : Reindexes S m π' σ') : Reindexes S m (fun i => π' (π i)) (fun p => σ (σ' p)) :=
  fun i from_ below =>
    have a := (first i from_ below).1
    have b := (second (π i) a.1 a.2.1).1
    have c := (second i from_ below).2
    have d := (first (σ' i) c.1 c.2.1).2
    ⟨⟨b.1, b.2.1, (congrArg σ b.2.2).trans a.2.2⟩, ⟨d.1, d.2.1, (congrArg π' d.2.2).trans c.2.2⟩⟩

theorem origin_append : ∀ (ts us : List Nat) (p : Nat), origin (ts ++ us) p = origin ts (origin us p)
  | [], _, _ => rfl
  | t :: ts, us, p => congrArg (swapAt t) (origin_append ts us p)

theorem origin_lowering_below {a d p : Nat} (below : p < a) : origin (lowering a d) p = p :=
  (congrArg (origin (lowering a d)) (place_lowering_outside a d (.inl below))).symm.trans
    (origin_place (lowering a d) p)

theorem origin_lowering_top (a d : Nat) : origin (lowering a d) a = a + d :=
  (congrArg (origin (lowering a d)) (place_lowering_top a d)).symm.trans
    (origin_place (lowering a d) (a + d))

/-- Bringing forward an exchange of a stretch commutes within it. -/
theorem lowering_inside {S m a : Nat} : ∀ {d : Nat}, S ≤ a → a + d < S + m →
    EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) (lowering a d)
  | 0, _, _ => trivial
  | _ + 1, from_, below => ⟨⟨Nat.le_trans from_ (Nat.le_add_right a _), below⟩,
      lowering_inside from_ (Nat.lt_trans (Nat.lt_succ_self _) below)⟩

variable {joined : Nat → Nat → Prop} {S m : Nat}

/-- **The order an arrangement gives joined exchanges.** `π'` takes every two joined exchanges
of the stretch in the order `π` does. -/
def Orients (joined : Nat → Nat → Prop) (S m : Nat) (π π' : Nat → Nat) : Prop :=
  ∀ i j, S ≤ i → i < S + m → S ≤ j → j < S + m → joined i j → π i < π j → π' i < π' j

theorem Orients.refl (π : Nat → Nat) : Orients joined S m π π :=
  fun _ _ _ _ _ _ _ lt => lt

theorem Orients.trans {π π' π'' : Nat → Nat} (first : Orients joined S m π π')
    (second : Orients joined S m π' π'') : Orients joined S m π π'' :=
  fun i j hi hi' hj hj' link lt => second i j hi hi' hj hj' link (first i j hi hi' hj hj' link lt)

/-- With joining symmetric and `π` one to one, orienting alike is symmetric. -/
theorem Orients.symm {π σ π' : Nat → Nat} (reindex : Reindexes S m π σ)
    (symm : ∀ a b, joined a b → joined b a) (orients : Orients joined S m π π') :
    Orients joined S m π' π :=
  fun i j hi hi' hj hj' link lt' => match Nat.lt_or_ge (π i) (π j) with
  | .inl lt => lt
  | .inr ge => match Nat.decEq (π j) (π i) with
    | .isTrue same =>
      have ij : j = i :=
        ((reindex j hj hj').1.2.2.symm.trans (congrArg σ same)).trans (reindex i hi hi').1.2.2
      absurd (Eq.subst (motive := fun k => π' i < π' k) ij lt') (Nat.lt_irrefl _)
    | .isFalse other =>
      absurd (orients j i hj hj' hi hi' (symm i j link) (lt_of_le_ne ge other)) (Nat.lt_asymm lt')

/-- **Rearranging.** The arrangement `π'` (each exchange of the stretch to its step) is reached
from the arrangement `(π, σ)` by commutations within the stretch, each of two consecutive
exchanges not joined in the arrangement as it then stands. -/
def Rearranges (joined : Nat → Nat → Prop) (S m : Nat) (π σ π' : Nat → Nat) : Prop :=
  ∃ ts, EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) ts ∧
    Commutes (fun a b => joined (σ a) (σ b)) ts ∧ ∀ i, S ≤ i → i < S + m → place ts (π i) = π' i

/-- Commuting exchanges not joined keeps the order of joined exchanges. -/
theorem commutes_orients {π σ : Nat → Nat} (reindex : Reindexes S m π σ) {ts : List Nat}
    (commutes : Commutes (fun a b => joined (σ a) (σ b)) ts) :
    Orients joined S m π (fun i => place ts (π i)) :=
  fun i j hi hi' hj hj' link lt => Commutes.keeps commutes lt
    (cast (congr (congrArg joined (reindex i hi hi').1.2.2.symm) (reindex j hj hj').1.2.2.symm) link)

theorem Rearranges.orients {π σ π' : Nat → Nat} (reindex : Reindexes S m π σ) :
    Rearranges joined S m π σ π' → Orients joined S m π π'
  | ⟨_, _, commutes, places⟩, i, j, hi, hi', hj, hj', link, lt =>
    Eq.subst (motive := fun k => k < π' j) (places i hi hi')
      (Eq.subst (motive := fun k => place _ (π i) < k) (places j hj hj')
        (commutes_orients reindex commutes i j hi hi' hj hj' link lt))

/-- **Mazurkiewicz's theorem for arrangements.** With joining symmetric, one arrangement of a
stretch is reached from another by commuting exchanges not joined exactly where the two take every
two joined exchanges in the same order. No decision is needed. -/
theorem rearranges_iff {π σ π' σ' : Nat → Nat} (symm : ∀ a b, joined a b → joined b a)
    (reindex : Reindexes S m π σ) (reindex' : Reindexes S m π' σ') :
    Rearranges joined S m π σ π' ↔ Orients joined S m π π' :=
  ⟨Rearranges.orients reindex, fun orients =>
    have keeps : KeepsOrder (fun a b => joined (σ a) (σ b)) S m (fun p => π' (σ p)) :=
      fun p q hp hq lt link =>
        have hp' := (reindex p hp (Nat.lt_trans lt hq)).2
        have hq' := (reindex q (Nat.le_trans hp (Nat.le_of_lt lt)) hq).2
        orients (σ p) (σ q) hp'.1 hp'.2.1 hq'.1 hq'.2.1 link
          (Eq.subst (motive := fun k => k < π (σ q)) hp'.2.2.symm
            (Eq.subst (motive := fun k => p < k) hq'.2.2.symm lt))
    match sorts_by m S (J := fun a b => joined (σ a) (σ b)) (fun _ _ link => symm _ _ link)
        (reindex.symm.comp reindex') keeps with
    | ⟨ts, within, commutes, places⟩ => ⟨ts, within, commutes, fun i hi hi' =>
        have h := (reindex i hi hi').1
        (places (π i) h.1 h.2.1).trans (congrArg π' h.2.2)⟩⟩

/-- Reaching one arrangement from another is an equivalence. -/
theorem Rearranges.symm {π σ π' σ' : Nat → Nat} (symm : ∀ a b, joined a b → joined b a)
    (reindex : Reindexes S m π σ) (reindex' : Reindexes S m π' σ')
    (re : Rearranges joined S m π σ π') : Rearranges joined S m π' σ' π :=
  (rearranges_iff symm reindex' reindex).mpr (Orients.symm reindex symm (re.orients reindex))

theorem Rearranges.trans {π σ π' σ' π'' σ'' : Nat → Nat} (symm : ∀ a b, joined a b → joined b a)
    (reindex : Reindexes S m π σ) (reindex' : Reindexes S m π' σ')
    (reindex'' : Reindexes S m π'' σ'') (first : Rearranges joined S m π σ π')
    (second : Rearranges joined S m π' σ' π'') : Rearranges joined S m π σ π'' :=
  (rearranges_iff symm reindex reindex'').mpr
    ((first.orients reindex).trans (second.orients reindex'))

end Arrangements

namespace Footprinted

variable {X : Type} {r : Footprinted X} {S m : Nat}

/-- The order of `Footprinted.Keeps` is the order the identity arrangement gives. -/
theorem keeps_iff_orients {π : Nat → Nat} :
    r.Keeps S m π ↔ Orients r.Joined S m (fun i => i) π :=
  ⟨fun keeps i j hi _ _ hj' link lt => keeps i j hi hj' lt link,
   fun orients i j hi hj' lt link =>
     orients i j hi (Nat.lt_trans lt hj') (Nat.le_trans hi (Nat.le_of_lt lt)) hj' link lt⟩

/-- **The arrangements reached from a world are its reorderings.** From the arrangement the
world is in, the arrangements reached by commuting exchanges not joined are those its reorderings
by `Independent` commutations within the stretch take. -/
theorem rearranges_iff_independent (contains : r.Contains) {π : Nat → Nat} :
    Rearranges r.Joined S m (fun i => i) (fun i => i) π ↔
      ∃ ts, EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) ts ∧ r.Independent ts ∧
        ∀ i, S ≤ i → i < S + m → place ts i = π i :=
  ⟨fun ⟨ts, within, commutes, places⟩ =>
     ⟨ts, within, (independent_iff_commutes contains).mpr commutes, places⟩,
   fun ⟨ts, within, independent, places⟩ =>
     ⟨ts, within, (independent_iff_commutes contains).mp independent, places⟩⟩

end Footprinted

/-! ## The lexicographic normal form -/

section Normal

variable {joined : Nat → Nat → Prop} {apart : Nat → Nat → Bool} {S m : Nat}

/-- **The decision the normal form needs.** `apart` decides, for every two different exchanges of
the stretch, that they are not joined: apartness is decided, and joining only up to its double
negation. -/
def DecidesApart (joined : Nat → Nat → Prop) (S m : Nat) (apart : Nat → Nat → Bool) : Prop :=
  ∀ i j, S ≤ i → i < S + m → S ≤ j → j < S + m → i ≠ j → (apart i j = true ↔ ¬ joined i j)

/-- Every step from `a`, among the next `d`, holds an exchange `apart` says is apart from `e`. -/
def apartBelow (apart : Nat → Nat → Bool) (w : Nat → Nat) (e a : Nat) : Nat → Bool
  | 0 => true
  | d + 1 => apart (w (a + d)) e && apartBelow apart w e a d

theorem apartBelow_iff {w : Nat → Nat} {e a : Nat} : ∀ d : Nat,
    apartBelow apart w e a d = true ↔ ∀ p, a ≤ p → p < a + d → apart (w p) e = true
  | 0 => ⟨fun _ _ from_ below => absurd below (Nat.not_lt_of_le from_), fun _ => rfl⟩
  | d + 1 => show (apart (w (a + d)) e && apartBelow apart w e a d) = true ↔ _ from
    ListTests.and_true_iff.trans
      ⟨fun ⟨last, rest⟩ p from_ below => match Nat.lt_or_ge p (a + d) with
        | .inl lt => (apartBelow_iff d).mp rest p from_ lt
        | .inr ge => Eq.subst (motive := fun k => apart (w k) e = true)
            (Nat.le_antisymm (Nat.le_of_lt_succ below) ge).symm last,
       fun all => ⟨all (a + d) (Nat.le_add_right a d) (Nat.lt_succ_self _),
         (apartBelow_iff d).mpr fun p from_ below => all p from_ (Nat.lt_succ_of_lt below)⟩⟩

/-- In the arrangement taking exchange `e` to step `pos e`, step `p` holding exchange `w p`,
exchange `e` is free from step `A`: not before `A`, and apart from every exchange from `A` up to
it, so it can be brought to `A`. -/
def freeAt (apart : Nat → Nat → Bool) (pos w : Nat → Nat) (A e : Nat) : Bool :=
  Nat.ble A (pos e) && apartBelow apart w e A (excess (pos e) A)

theorem freeAt_iff {pos w : Nat → Nat} {A e : Nat} :
    freeAt apart pos w A e = true ↔ A ≤ pos e ∧ ∀ p, A ≤ p → p < pos e → apart (w p) e = true :=
  ListTests.and_true_iff.trans
    ⟨fun ⟨le, all⟩ =>
      have le' := Nat.le_of_ble_eq_true le
      ⟨le', fun p from_ below => (apartBelow_iff _).mp all p from_
        (Nat.lt_of_lt_of_le below (Nat.le_of_eq (add_excess_of_le le').symm))⟩,
     fun ⟨le, all⟩ => ⟨Nat.ble_eq_true_of_le le, (apartBelow_iff _).mpr fun p from_ below =>
       all p from_ (Nat.lt_of_lt_of_le below (Nat.le_of_eq (add_excess_of_le le)))⟩⟩

/-- The exchange stage `k` of the sort brings to step `S + k`: the least exchange of the stretch,
by its name, free from there in the arrangement the commutations `us` have reached. -/
def normalPick (apart : Nat → Nat → Bool) (S m : Nat) (π σ : Nat → Nat) (k : Nat)
    (us : List Nat) : Nat :=
  firstWhere (freeAt apart (fun i => place us (π i)) (fun p => σ (origin us p)) (S + k)) S m

/-- Stage `k` of the sort: bring that exchange forward to step `S + k`. -/
def normalNext (apart : Nat → Nat → Bool) (S m : Nat) (π σ : Nat → Nat) (k : Nat)
    (us : List Nat) : List Nat :=
  us ++ lowering (S + k) (excess (place us (π (normalPick apart S m π σ k us))) (S + k))

/-- The commutations of the first `k` stages of the sort. -/
def normalSteps (apart : Nat → Nat → Bool) (S m : Nat) (π σ : Nat → Nat) : Nat → List Nat
  | 0 => []
  | k + 1 => normalNext apart S m π σ k (normalSteps apart S m π σ k)

/-- **The lexicographic normal form** of the arrangement `(π, σ)` of a stretch: the step its sort
takes each exchange to. The exchanges are named by the numbers `π` arranges, and each step of
the normal form holds the least-named exchange that can be brought there. -/
def normalForm (apart : Nat → Nat → Bool) (S m : Nat) (π σ : Nat → Nat) (i : Nat) : Nat :=
  place (normalSteps apart S m π σ m) (π i)

/-- The exchange a stage picks is of the stretch and free: the exchange already at the step is. -/
theorem pick_spec {π σ : Nat → Nat} (reindex : Reindexes S m π σ) {k : Nat} (lt : k < m)
    {us : List Nat} (within : EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) us) :
    S ≤ normalPick apart S m π σ k us ∧ normalPick apart S m π σ k us < S + m ∧
      freeAt apart (fun i => place us (π i)) (fun p => σ (origin us p)) (S + k)
        (normalPick apart S m π σ k us) = true :=
  have cur := reindex.comp (reindexes_of_within within)
  have hc := (cur (S + k) (Nat.le_add_right S k) (Nat.add_lt_add_left lt S)).2
  have free : freeAt apart (fun i => place us (π i)) (fun p => σ (origin us p)) (S + k)
      (σ (origin us (S + k))) = true :=
    freeAt_iff.mpr ⟨Nat.le_of_eq hc.2.2.symm, fun _ from_ below =>
      absurd (Nat.lt_of_lt_of_le below (Nat.le_of_eq hc.2.2)) (Nat.not_lt_of_le from_)⟩
  have found := firstWhere_found
    (freeAt apart (fun i => place us (π i)) (fun p => σ (origin us p)) (S + k)) S m
    (σ (origin us (S + k))) hc.1 hc.2.1 free
  ⟨firstWhere_ge _ S m, Nat.lt_of_le_of_lt found.1 hc.2.1, found.2⟩

/-- **The pick is the least-named free exchange**: every exchange of the stretch named before it is
not free at that stage. -/
theorem pick_least {π σ : Nat → Nat} {k : Nat} {us : List Nat} {j : Nat} (from_ : S ≤ j)
    (below : j < normalPick apart S m π σ k us) :
    freeAt apart (fun i => place us (π i)) (fun p => σ (origin us p)) (S + k) j = false :=
  firstWhere_before _ S m j from_ below

/-- One stage commutes exchanges not joined, within the stretch, leaves the steps before it and
brings the picked exchange to its step. -/
theorem next_spec {π σ : Nat → Nat} (decides : DecidesApart joined S m apart)
    (reindex : Reindexes S m π σ) {k : Nat} (lt : k < m) {us : List Nat}
    (within : EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) us)
    (commutes : Commutes (fun a b => joined (σ a) (σ b)) us) :
    EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) (normalNext apart S m π σ k us) ∧
    Commutes (fun a b => joined (σ a) (σ b)) (normalNext apart S m π σ k us) ∧
    (∀ p, p < S + k → origin (normalNext apart S m π σ k us) p = origin us p) ∧
    σ (origin (normalNext apart S m π σ k us) (S + k)) = normalPick apart S m π σ k us :=
  have cur := reindex.comp (reindexes_of_within within)
  have spec := pick_spec (apart := apart) reindex lt within
  have free := freeAt_iff.mp spec.2.2
  have he := (cur (normalPick apart S m π σ k us) spec.1 spec.2.1).1
  have hq : S + k + excess (place us (π (normalPick apart S m π σ k us))) (S + k) =
      place us (π (normalPick apart S m π σ k us)) := add_excess_of_le free.1
  have eqe : σ (origin us (S + k + excess (place us (π (normalPick apart S m π σ k us))) (S + k))) =
      normalPick apart S m π σ k us :=
    (congrArg (fun q => σ (origin us q)) hq).trans he.2.2
  ⟨EachStep.append within (lowering_inside (Nat.le_add_right S k)
      (Eq.subst (motive := (· < S + m)) hq.symm he.2.1)),
   Commutes.append commutes
     (lowering_commutes (a := S + k) (J := fun a b => joined (σ (origin us a)) (σ (origin us b)))
       fun p from_ below link =>
         have below' : p < place us (π (normalPick apart S m π σ k us)) :=
           Eq.subst (motive := (p < ·)) hq below
         have hp := (cur p (Nat.le_trans (Nat.le_add_right S k) from_)
           (Nat.lt_trans below' he.2.1)).2
         have ne : σ (origin us p) ≠ normalPick apart S m π σ k us := fun same =>
           absurd (Eq.subst (motive := fun x => place us (π x) <
               place us (π (normalPick apart S m π σ k us))) same
             (Eq.subst (motive := (· < place us (π (normalPick apart S m π σ k us))))
               hp.2.2.symm below')) (Nat.lt_irrefl _)
         (decides _ _ hp.1 hp.2.1 spec.1 spec.2.1 ne).mp (free.2 p from_ below')
           (Eq.subst (motive := fun x => joined (σ (origin us p)) x) eqe link)),
   fun p below => (origin_append us _ p).trans
     (congrArg (origin us) (origin_lowering_below below)),
   (congrArg σ ((origin_append us _ (S + k)).trans
     (congrArg (origin us) (origin_lowering_top (S + k) _)))).trans eqe⟩

/-- Each stage of the sort commutes, within the stretch, exchanges not joined. -/
theorem normalSteps_spec {π σ : Nat → Nat} (decides : DecidesApart joined S m apart)
    (reindex : Reindexes S m π σ) : ∀ k, k ≤ m →
    EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) (normalSteps apart S m π σ k) ∧
    Commutes (fun a b => joined (σ a) (σ b)) (normalSteps apart S m π σ k)
  | 0, _ => ⟨trivial, trivial⟩
  | k + 1, le =>
    have prev := normalSteps_spec decides reindex k (Nat.le_of_succ_le le)
    have next := next_spec decides reindex le prev.1 prev.2
    ⟨next.1, next.2.1⟩

/-- Later stages leave the steps earlier stages have filled. -/
theorem normalSteps_stable {π σ : Nat → Nat} (decides : DecidesApart joined S m apart)
    (reindex : Reindexes S m π σ) {k : Nat} : ∀ j, k + j ≤ m → ∀ p, p < S + k →
      origin (normalSteps apart S m π σ (k + j)) p = origin (normalSteps apart S m π σ k) p
  | 0, _, _, _ => rfl
  | j + 1, le, p, below =>
    have s := normalSteps_spec decides reindex (k + j) (Nat.le_of_succ_le le)
    have n := next_spec decides reindex le s.1 s.2
    (n.2.2.1 p (Nat.lt_of_lt_of_le below (Nat.add_le_add_left (Nat.le_add_right k j) S))).trans
      (normalSteps_stable decides reindex j (Nat.le_of_succ_le le) p below)

/-- The normal form is an arrangement of the stretch. -/
theorem normalForm_reindexes {π σ : Nat → Nat} (decides : DecidesApart joined S m apart)
    (reindex : Reindexes S m π σ) :
    Reindexes S m (normalForm apart S m π σ) (fun p => σ (origin (normalSteps apart S m π σ m) p)) :=
  reindex.comp (reindexes_of_within (normalSteps_spec decides reindex m (Nat.le_refl m)).1)

/-- **The normal form is reached** from the arrangement by commuting exchanges not joined. -/
theorem normalForm_rearranges {π σ : Nat → Nat} (decides : DecidesApart joined S m apart)
    (reindex : Reindexes S m π σ) : Rearranges joined S m π σ (normalForm apart S m π σ) :=
  have spec := normalSteps_spec decides reindex m (Nat.le_refl m)
  ⟨normalSteps apart S m π σ m, spec.1, spec.2, fun _ _ _ => rfl⟩

/-- **Being free carries between arrangements alike so far.** Where two arrangements hold the same
exchanges at the steps before `A` and the second takes joined exchanges in the order the first
does, an exchange free from `A` in the first is free from `A` in the second. -/
theorem free_transfer {pos₁ w₁ pos₂ w₂ : Nat → Nat} {A : Nat}
    (decides : DecidesApart joined S m apart) (cur₁ : Reindexes S m pos₁ w₁)
    (cur₂ : Reindexes S m pos₂ w₂) (start : S ≤ A) (prefix_ : ∀ p, S ≤ p → p < A → w₁ p = w₂ p)
    (orients : Orients joined S m pos₂ pos₁) {i : Nat} (hi : S ≤ i) (hi' : i < S + m)
    (free₁ : freeAt apart pos₁ w₁ A i = true) : freeAt apart pos₂ w₂ A i = true :=
  have f := freeAt_iff.mp free₁
  have ci₂ := (cur₂ i hi hi').1
  have placed : A ≤ pos₂ i := match Nat.lt_or_ge (pos₂ i) A with
    | .inl lt =>
      have back : w₁ (pos₂ i) = i := (prefix_ (pos₂ i) ci₂.1 lt).trans ci₂.2.2
      have h := (cur₁ (pos₂ i) ci₂.1 ci₂.2.1).2
      absurd (Nat.lt_of_le_of_lt f.1 (Eq.subst (motive := fun k => pos₁ k < A) back
          (Eq.subst (motive := (· < A)) h.2.2.symm lt)))
        (Nat.lt_irrefl A)
    | .inr ge => ge
  freeAt_iff.mpr ⟨placed, fun p from_ below =>
    have hp : S ≤ p ∧ p < S + m := ⟨Nat.le_trans start from_, Nat.lt_trans below ci₂.2.1⟩
    have cj₂ := (cur₂ p hp.1 hp.2).2
    match h : apart (w₂ p) i with
    | true => rfl
    | false =>
      have ne : w₂ p ≠ i := fun same => absurd
        (Eq.subst (motive := fun k => pos₂ k < pos₂ i) same
          (Eq.subst (motive := (· < pos₂ i)) cj₂.2.2.symm below)) (Nat.lt_irrefl _)
      have notNot : ¬ ¬ joined (w₂ p) i := fun apartj => Bool.noConfusion
        (h.symm.trans ((decides (w₂ p) i cj₂.1 cj₂.2.1 hi hi' ne).mpr apartj))
      have cj₁ := (cur₁ (w₂ p) cj₂.1 cj₂.2.1).1
      have before : pos₁ (w₂ p) < pos₁ i := match Nat.lt_or_ge (pos₁ (w₂ p)) (pos₁ i) with
        | .inl lt => lt
        | .inr ge => absurd (fun link => absurd (orients (w₂ p) i cj₂.1 cj₂.2.1 hi hi' link
            (Eq.subst (motive := (· < pos₂ i)) cj₂.2.2.symm below)) (Nat.not_lt_of_le ge)) notNot
      have later : A ≤ pos₁ (w₂ p) := match Nat.lt_or_ge (pos₁ (w₂ p)) A with
        | .inl lt =>
          have back : w₂ (pos₁ (w₂ p)) = w₂ p := (prefix_ _ cj₁.1 lt).symm.trans cj₁.2.2
          have h2 := (cur₂ (pos₁ (w₂ p)) cj₁.1 cj₁.2.1).2
          have eqpq : p = pos₁ (w₂ p) :=
            cj₂.2.2.symm.trans ((congrArg pos₂ back).symm.trans h2.2.2)
          absurd (Nat.lt_of_le_of_lt from_ (Eq.subst (motive := (· < A)) eqpq.symm lt))
            (Nat.lt_irrefl A)
        | .inr ge => ge
      Bool.noConfusion (h.symm.trans (Eq.subst (motive := fun k => apart k i = true) cj₁.2.2
        (f.2 (pos₁ (w₂ p)) later before)))⟩

/-- **The sort depends only on the order of joined exchanges.** Two arrangements taking joined
exchanges in the same order hold, at each stage, the same exchanges at the steps filled. -/
theorem normalSteps_agree {π₁ σ₁ π₂ σ₂ : Nat → Nat} (symm : ∀ a b, joined a b → joined b a)
    (decides : DecidesApart joined S m apart) (reindex₁ : Reindexes S m π₁ σ₁)
    (reindex₂ : Reindexes S m π₂ σ₂) (orients : Orients joined S m π₁ π₂) :
    ∀ k, k ≤ m → ∀ p, S ≤ p → p < S + k →
      σ₁ (origin (normalSteps apart S m π₁ σ₁ k) p) = σ₂ (origin (normalSteps apart S m π₂ σ₂ k) p)
  | 0, _, _, from_, below => absurd below (Nat.not_lt_of_le from_)
  | k + 1, le, p, from_, below =>
    have prev := normalSteps_agree symm decides reindex₁ reindex₂ orients k (Nat.le_of_succ_le le)
    have s₁ := normalSteps_spec decides reindex₁ k (Nat.le_of_succ_le le)
    have s₂ := normalSteps_spec decides reindex₂ k (Nat.le_of_succ_le le)
    have n₁ := next_spec decides reindex₁ le s₁.1 s₁.2
    have n₂ := next_spec decides reindex₂ le s₂.1 s₂.2
    have cur₁ := reindex₁.comp (reindexes_of_within s₁.1)
    have cur₂ := reindex₂.comp (reindexes_of_within s₂.1)
    have o₁ := commutes_orients reindex₁ s₁.2
    have o₂ := commutes_orients reindex₂ s₂.2
    have o₁₂ := (Orients.symm reindex₁ symm o₁).trans (orients.trans o₂)
    have o₂₁ := (Orients.symm reindex₂ symm o₂).trans ((Orients.symm reindex₁ symm orients).trans o₁)
    have pick : normalPick apart S m π₁ σ₁ k (normalSteps apart S m π₁ σ₁ k) =
        normalPick apart S m π₂ σ₂ k (normalSteps apart S m π₂ σ₂ k) :=
      firstWhere_congr S m fun _ hi hi' => bool_eq_of_iff
        ⟨free_transfer decides cur₁ cur₂ (Nat.le_add_right S k) prev o₂₁ hi hi',
         free_transfer decides cur₂ cur₁ (Nat.le_add_right S k)
           (fun q hq hq' => (prev q hq hq').symm) o₁₂ hi hi'⟩
    match Nat.lt_or_ge p (S + k) with
    | .inl lt => (congrArg σ₁ (n₁.2.2.1 p lt)).trans
        ((prev p from_ lt).trans (congrArg σ₂ (n₂.2.2.1 p lt)).symm)
    | .inr ge =>
      Eq.subst (motive := fun q => σ₁ (origin (normalSteps apart S m π₁ σ₁ (k + 1)) q) =
          σ₂ (origin (normalSteps apart S m π₂ σ₂ (k + 1)) q))
        (Nat.le_antisymm ge (Nat.le_of_lt_succ below))
        (n₁.2.2.2.trans (pick.trans n₂.2.2.2.symm))

/-- So two arrangements taking joined exchanges in the same order have the same normal form. -/
theorem normalForm_agree {π₁ σ₁ π₂ σ₂ : Nat → Nat} (symm : ∀ a b, joined a b → joined b a)
    (decides : DecidesApart joined S m apart) (reindex₁ : Reindexes S m π₁ σ₁)
    (reindex₂ : Reindexes S m π₂ σ₂) (orients : Orients joined S m π₁ π₂) {i : Nat}
    (hi : S ≤ i) (hi' : i < S + m) :
    normalForm apart S m π₁ σ₁ i = normalForm apart S m π₂ σ₂ i :=
  have words := normalSteps_agree symm decides reindex₁ reindex₂ orients m (Nat.le_refl m)
  have h₁ := (normalForm_reindexes decides reindex₁ i hi hi').1
  have same : σ₂ (origin (normalSteps apart S m π₂ σ₂ m) (normalForm apart S m π₁ σ₁ i)) = i :=
    (words _ h₁.1 h₁.2.1).symm.trans h₁.2.2
  have h₂ := (normalForm_reindexes decides reindex₂ _ h₁.1 h₁.2.1).2
  (Eq.subst (motive := fun k => normalForm apart S m π₂ σ₂ k = normalForm apart S m π₁ σ₁ i)
    same h₂.2.2).symm

/-- **The normal form theorem.** With joining symmetric and apartness decided on the stretch,
two arrangements of it are reached from each other by commuting exchanges not joined exactly
where they have the same lexicographic normal form. -/
theorem normalForm_iff {π₁ σ₁ π₂ σ₂ : Nat → Nat} (symm : ∀ a b, joined a b → joined b a)
    (decides : DecidesApart joined S m apart) (reindex₁ : Reindexes S m π₁ σ₁)
    (reindex₂ : Reindexes S m π₂ σ₂) :
    Rearranges joined S m π₁ σ₁ π₂ ↔
      ∀ i, S ≤ i → i < S + m → normalForm apart S m π₁ σ₁ i = normalForm apart S m π₂ σ₂ i :=
  ⟨fun re _ hi hi' =>
    normalForm_agree symm decides reindex₁ reindex₂ (re.orients reindex₁) hi hi',
   fun same => (rearranges_iff symm reindex₁ reindex₂).mpr
     (((normalForm_rearranges decides reindex₁).orients reindex₁).trans
       ((show Orients joined S m (normalForm apart S m π₁ σ₁) (normalForm apart S m π₂ σ₂) from
         fun i j hi hi' hj hj' _ lt =>
           Eq.subst (motive := fun k => k < normalForm apart S m π₂ σ₂ j) (same i hi hi')
             (Eq.subst (motive := fun k => normalForm apart S m π₁ σ₁ i < k) (same j hj hj') lt)).trans
         (Orients.symm reindex₂ symm ((normalForm_rearranges decides reindex₂).orients reindex₂))))⟩

/-- The normal form is its own normal form. -/
theorem normalForm_normal {π σ : Nat → Nat} (symm : ∀ a b, joined a b → joined b a)
    (decides : DecidesApart joined S m apart) (reindex : Reindexes S m π σ) {i : Nat}
    (hi : S ≤ i) (hi' : i < S + m) :
    normalForm apart S m (normalForm apart S m π σ)
        (fun p => σ (origin (normalSteps apart S m π σ m) p)) i = normalForm apart S m π σ i :=
  ((normalForm_iff symm decides reindex (normalForm_reindexes decides reindex)).mp
    (normalForm_rearranges decides reindex) i hi hi').symm

/-- **The normal form is lexicographically least.** Of every arrangement reached, the normal form
holds, at the first step where the two differ, the lesser-named exchange: where they hold the
same exchanges before step `S + k`, the normal form's exchange there is no greater. -/
theorem normalForm_least {π σ π' σ' : Nat → Nat} (symm : ∀ a b, joined a b → joined b a)
    (decides : DecidesApart joined S m apart) (reindex : Reindexes S m π σ)
    (reindex' : Reindexes S m π' σ') (re : Rearranges joined S m π σ π') {k : Nat} (lt : k < m)
    (before : ∀ p, S ≤ p → p < S + k → σ (origin (normalSteps apart S m π σ m) p) = σ' p) :
    σ (origin (normalSteps apart S m π σ m) (S + k)) ≤ σ' (S + k) :=
  match le_dest lt with
  | ⟨j, hm⟩ =>
    have sk := normalSteps_spec decides reindex k (Nat.le_of_lt lt)
    have nk := next_spec decides reindex lt sk.1 sk.2
    have meq : m = k + (j + 1) := hm.trans (Nat.add_right_comm k 1 j)
    have final : ∀ q, q < S + k → origin (normalSteps apart S m π σ m) q =
        origin (normalSteps apart S m π σ k) q := fun q below =>
      Eq.subst (motive := fun n => origin (normalSteps apart S m π σ n) q =
          origin (normalSteps apart S m π σ k) q) meq.symm
        (normalSteps_stable decides reindex (j + 1) (Nat.le_of_eq meq.symm) q below)
    have here : origin (normalSteps apart S m π σ m) (S + k) =
        origin (normalSteps apart S m π σ (k + 1)) (S + k) :=
      Eq.subst (motive := fun n => origin (normalSteps apart S m π σ n) (S + k) =
          origin (normalSteps apart S m π σ (k + 1)) (S + k)) hm.symm
        (normalSteps_stable decides reindex j (Nat.le_of_eq hm.symm) (S + k) (Nat.lt_succ_self _))
    have cur := reindex.comp (reindexes_of_within sk.1)
    have hS : S + k < S + m := Nat.add_lt_add_left lt S
    have hj := (reindex' (S + k) (Nat.le_add_right S k) hS).2
    have free' : freeAt apart π' σ' (S + k) (σ' (S + k)) = true :=
      freeAt_iff.mpr ⟨Nat.le_of_eq hj.2.2.symm, fun _ from_ below =>
        absurd (Nat.lt_of_lt_of_le below (Nat.le_of_eq hj.2.2)) (Nat.not_lt_of_le from_)⟩
    have free := free_transfer decides reindex' cur (Nat.le_add_right S k)
      (fun q hq hq' => ((before q hq hq').symm.trans (congrArg σ (final q hq'))))
      ((Orients.symm reindex symm (commutes_orients reindex sk.2)).trans (re.orients reindex))
      hj.1 hj.2.1 free'
    have found := firstWhere_found _ S m _ hj.1 hj.2.1 free
    Nat.le_trans (Nat.le_of_eq ((congrArg σ here).trans nk.2.2.2)) found.1

end Normal

/-! ## What the normal form needs: the boundary -/

section Boundary

variable {joined : Nat → Nat → Prop} {S m : Nat}

/-- Whether two functions agree at each of the `n` numbers from `a`. -/
def agreeFrom (f g : Nat → Nat) : Nat → Nat → Bool
  | _, 0 => true
  | a, n + 1 => Nat.beq (f a) (g a) && agreeFrom f g (a + 1) n

theorem agreeFrom_iff {f g : Nat → Nat} : ∀ (a n : Nat),
    agreeFrom f g a n = true ↔ ∀ i, a ≤ i → i < a + n → f i = g i
  | _, 0 => ⟨fun _ _ from_ below => absurd below (Nat.not_lt_of_le from_), fun _ => rfl⟩
  | a, n + 1 => show (Nat.beq (f a) (g a) && agreeFrom f g (a + 1) n) = true ↔ _ from
    ListTests.and_true_iff.trans
      ⟨fun ⟨here, rest⟩ i from_ below => match Nat.decEq i a with
        | .isTrue same => Eq.subst (motive := fun k => f k = g k) same.symm
            (Nat.eq_of_beq_eq_true here)
        | .isFalse other => (agreeFrom_iff (a + 1) n).mp rest i
            (Nat.succ_le_of_lt (lt_of_le_ne from_ fun e => other e.symm))
            (Nat.lt_of_lt_of_le below (Nat.le_of_eq (Nat.add_right_comm a 1 n).symm)),
       fun all => ⟨Eq.subst (motive := fun k => Nat.beq (f a) k = true)
           (all a (Nat.le_refl a) (Nat.lt_succ_of_le (Nat.le_add_right a n))) (beq_self (f a)),
         (agreeFrom_iff (a + 1) n).mpr fun i from_ below => all i (Nat.le_of_succ_le from_)
           (Nat.lt_of_lt_of_le below (Nat.le_of_eq (Nat.add_right_comm a 1 n)))⟩⟩

/-- **A complete invariant of arrangements**: two arrangements of the stretch are reached from
each other exactly where it agrees on them over the stretch. -/
def CompleteInvariant (joined : Nat → Nat → Prop) (S m : Nat)
    (N : (Nat → Nat) → (Nat → Nat) → Nat → Nat) : Prop :=
  ∀ π σ π' σ', Reindexes S m π σ → Reindexes S m π' σ' →
    (Rearranges joined S m π σ π' ↔ ∀ i, S ≤ i → i < S + m → N π σ i = N π' σ' i)

/-- Given a decision of apartness, the normal form is a complete invariant. -/
theorem normalForm_complete {apart : Nat → Nat → Bool} (symm : ∀ a b, joined a b → joined b a)
    (decides : DecidesApart joined S m apart) :
    CompleteInvariant joined S m (normalForm apart S m) :=
  fun _ _ _ _ reindex reindex' => normalForm_iff symm decides reindex reindex'

/-- The arrangement bringing exchange `j` to the step after exchange `i`. -/
def pairFirst (i j : Nat) : List Nat :=
  lowering (i + 1) (excess j (i + 1))

/-- And the one taking the two the other way. -/
def pairSecond (i j : Nat) : List Nat :=
  pairFirst i j ++ [i]

theorem pair_within {i j : Nat} (hi : S ≤ i) (lt : i < j) (hj : j < S + m) :
    EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) (pairFirst i j) ∧
      EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) (pairSecond i j) :=
  have first : EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) (pairFirst i j) :=
    lowering_inside (Nat.le_succ_of_le hi)
      (Eq.subst (motive := (· < S + m)) (add_excess_of_le lt).symm hj)
  ⟨first, EachStep.append first ⟨⟨hi, Nat.lt_of_le_of_lt lt hj⟩, trivial⟩⟩

/-- **The two ways of taking two exchanges side by side are reached from each other exactly where
the exchanges are not joined.** -/
theorem pair_rearranges {i j : Nat} (hi : S ≤ i) (lt : i < j) (hj : j < S + m) :
    Rearranges joined S m (place (pairFirst i j)) (origin (pairFirst i j)) (place (pairSecond i j)) ↔
      ¬ joined i j :=
  have hd : i + 1 + excess j (i + 1) = j := add_excess_of_le lt
  have within := pair_within hi lt hj
  have oi : origin (pairFirst i j) i = i := origin_lowering_below (Nat.lt_succ_self i)
  have oj : origin (pairFirst i j) (i + 1) = j := (origin_lowering_top (i + 1) _).trans hd
  have pi : place (pairFirst i j) i = i :=
    place_lowering_outside (i + 1) _ (.inl (Nat.lt_succ_self i))
  have pj : place (pairFirst i j) j = i + 1 :=
    (congrArg (place (pairFirst i j)) hd.symm).trans (place_lowering_top (i + 1) _)
  have hi' : i < S + m := Nat.lt_trans lt hj
  ⟨fun re link =>
    have o := re.orients (reindexes_of_within within.1) i j hi hi'
      (Nat.le_trans hi (Nat.le_of_lt lt)) hj link
      (Eq.subst (motive := (· < place (pairFirst i j) j)) pi.symm
        (Eq.subst (motive := (i < ·)) pj.symm (Nat.lt_succ_self i)))
    have second : place (pairSecond i j) i = i + 1 :=
      (place_append (pairFirst i j) [i] i).trans
        ((congrArg (swapAt i) pi).trans (swapAt_first i))
    have second' : place (pairSecond i j) j = i :=
      (place_append (pairFirst i j) [i] j).trans
        ((congrArg (swapAt i) pj).trans (swapAt_second i))
    absurd (Eq.subst (motive := (· < i)) second (Eq.subst (motive := (place (pairSecond i j) i < ·))
      second' o)) (Nat.not_lt_of_le (Nat.le_succ i)),
   fun apart => ⟨[i], ⟨⟨hi, Nat.lt_of_le_of_lt lt hj⟩, trivial⟩,
     ⟨fun link => apart (cast (congr (congrArg joined oi) oj) link), trivial⟩,
     fun e _ _ => (place_append (pairFirst i j) [i] e).symm⟩⟩

/-- What a function of arrangements says of two exchanges `i < j`: whether it agrees on the two
ways of taking them side by side. -/
def pairApart (N : (Nat → Nat) → (Nat → Nat) → Nat → Nat) (S m i j : Nat) : Bool :=
  agreeFrom (N (place (pairFirst i j)) (origin (pairFirst i j)))
    (N (place (pairSecond i j)) (origin (pairSecond i j))) S m

/-- The apartness a function of arrangements reads off, the earlier exchange first. -/
def apartOf (N : (Nat → Nat) → (Nat → Nat) → Nat → Nat) (S m i j : Nat) : Bool :=
  if i < j then pairApart N S m i j else pairApart N S m j i

/-- **Every complete invariant decides apartness.** A function of arrangements that agrees on two
of them exactly where they are reached from each other decides, for every two different exchanges
of the stretch, whether they are not joined. -/
theorem decides_of_complete {N : (Nat → Nat) → (Nat → Nat) → Nat → Nat}
    (symm : ∀ a b, joined a b → joined b a) (complete : CompleteInvariant joined S m N) :
    DecidesApart joined S m (apartOf N S m) :=
  have pairs : ∀ {a b : Nat}, S ≤ a → a < b → b < S + m →
      (pairApart N S m a b = true ↔ ¬ joined a b) := fun ha lt hb =>
    have within := pair_within ha lt hb
    (agreeFrom_iff S m).trans ((complete _ _ _ _ (reindexes_of_within within.1)
      (reindexes_of_within within.2)).symm.trans (pair_rearranges ha lt hb))
  fun i j hi hi' hj hj' ne => match Nat.lt_or_ge i j with
  | .inl lt => (Iff.of_eq (congrArg (· = true) (if_pos lt))).trans (pairs hi lt hj')
  | .inr ge =>
    have lt : j < i := lt_of_le_ne ge fun e => ne e.symm
    (Iff.of_eq (congrArg (· = true) (if_neg (Nat.not_lt_of_le ge)))).trans
      ((pairs hj lt hi').trans
        ⟨fun no link => no (symm _ _ link), fun no link => no (symm _ _ link)⟩)

/-- **A normal form exists exactly where apartness is decided.** With joining symmetric, a
complete invariant of the arrangements of a stretch exists exactly where apartness of its
exchanges is decided: deciding gives the lexicographic normal form, and any complete invariant
decides it. -/
theorem complete_iff (symm : ∀ a b, joined a b → joined b a) :
    (∃ N, CompleteInvariant joined S m N) ↔ ∃ apart, DecidesApart joined S m apart :=
  ⟨fun ⟨_, complete⟩ => ⟨_, decides_of_complete symm complete⟩,
   fun ⟨_, decides⟩ => ⟨_, normalForm_complete symm decides⟩⟩

end Boundary

/-! ## A world's exchanges in normal form -/

namespace Footprinted

variable {X : Type} {r : Footprinted X} {S m : Nat}

/-- **A reordering is determined by its arrangement.** Two reorderings of a world within a stretch,
each commuting exchanges not joined, that take every exchange of the stretch to the same step take
the same exchange across each step of the stretch and show every relatum alike at each step of
it. -/
theorem reorder_determined (contains : r.Contains) {us₁ us₂ : List Nat}
    (within₁ : EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) us₁)
    (within₂ : EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) us₂)
    (independent₁ : r.Independent us₁) (independent₂ : r.Independent us₂)
    (same : ∀ i, S ≤ i → i < S + m → place us₁ i = place us₂ i) :
    (∀ a, S ≤ a → a < S + m → (r.reorder us₁).flow.SameExchange a (r.reorder us₂).flow a) ∧
    ∀ k x, S ≤ k → k ≤ S + m → (r.reorder us₁).web.SameAt k (r.reorder us₂).web k x :=
  have origins : ∀ p, S ≤ p → p < S + m → origin us₂ p = origin us₁ p := fun p hp hp' =>
    have o := origin_within within₁ hp hp'
    have placed : place us₂ (origin us₁ p) = p :=
      (same _ o.1 o.2).symm.trans (place_origin us₁ p)
    (congrArg (origin us₂) placed).symm.trans (origin_place us₂ (origin us₁ p))
  have webs := converse_webs (r := r.reorder us₁) (r₂ := r.reorder us₂) (π := fun i => i)
    (σ := fun i => i) (ts := []) (reorder_contains contains independent₁)
    (reorder_contains contains independent₂) trivial trivial (Reindexes.identity S m)
    (fun _ _ _ => rfl)
    (fun i x hi hi' => (reorder_touch r us₂ i x).trans
      ((congrArg (fun k => r.touch k x) (origins i hi hi')).trans (reorder_touch r us₁ i x).symm))
    (fun i x hi hi' touched =>
      have t₁ : r.touch (origin us₁ i) x = true := (reorder_touch r us₁ i x).symm.trans touched
      have t₂ : r.touch (origin us₂ i) x = true :=
        Eq.subst (motive := fun k => r.touch k x = true) (origins i hi hi').symm t₁
      (reorder_shows contains independent₁ t₁).2.symm.trans
        (Eq.subst (motive := fun k => r.web.SameAt (k + 1) (r.reorder us₂).web (i + 1) x)
          (origins i hi hi') (reorder_shows contains independent₂ t₂).2))
    (fun x => (reorder_before within₁ x (Nat.le_refl S)).symm.trans
      (reorder_before within₂ x (Nat.le_refl S)))
  ⟨fun a ha ha' => (reorder_exchange r us₁ a).symm.trans
     (Eq.subst (motive := fun k => r.flow.SameExchange k (r.reorder us₂).flow a)
       (origins a ha ha') (reorder_exchange r us₂ a)),
   fun _ x from_ upto => match le_dest from_ with
     | ⟨e, hk⟩ => Eq.subst (motive := fun j => (r.reorder us₁).web.SameAt j (r.reorder us₂).web j x)
         hk.symm (webs e (Naturals.le_of_add_le_add_left
           (Eq.subst (motive := (· ≤ S + m)) hk upto)) x)⟩

/-- **A world's exchanges over a stretch in normal form**: commuted, two consecutive exchanges not
joined at a time, into the lexicographic normal form of their arrangement, each exchange named by
its step. -/
def normalize (r : Footprinted X) (apart : Nat → Nat → Bool) (S m : Nat) : Footprinted X :=
  r.reorder (normalSteps apart S m (fun i => i) (fun i => i) m)

variable {apart : Nat → Nat → Bool}

theorem normalize_independent (contains : r.Contains) (decides : DecidesApart r.Joined S m apart) :
    EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) (normalSteps apart S m (fun i => i) (fun i => i) m) ∧
      r.Independent (normalSteps apart S m (fun i => i) (fun i => i) m) :=
  have spec := normalSteps_spec decides (Reindexes.identity S m) m (Nat.le_refl m)
  ⟨spec.1, (independent_iff_commutes contains).mpr spec.2⟩

/-- **The normal form meets every premise exactly where the world does**, and keeps the order of
joined exchanges. -/
theorem normalize_premises (contains : r.Contains) (decides : DecidesApart r.Joined S m apart) :
    ((r.normalize apart S m).world.Balanced ↔ r.world.Balanced) ∧
    ((r.normalize apart S m).world.Dissipative ↔ r.world.Dissipative) ∧
    ((r.normalize apart S m).world.Acting ↔ r.world.Acting) ∧
    ((r.normalize apart S m).world.Taking ↔ r.world.Taking) ∧
    ((r.normalize apart S m).world.Dependent ↔ r.world.Dependent) ∧
    ((r.normalize apart S m).world.Embodied ↔ r.world.Embodied) ∧
    ((r.normalize apart S m).world.Transmitting ↔ r.world.Transmitting) :=
  reorder_premises contains (normalize_independent contains decides).2

theorem normalize_precedes (contains : r.Contains) (decides : DecidesApart r.Joined S m apart)
    {a b : Nat} : (r.normalize apart S m).Precedes a b ↔
      r.Precedes (origin (normalSteps apart S m (fun i => i) (fun i => i) m) a)
        (origin (normalSteps apart S m (fun i => i) (fun i => i) m) b) :=
  reorder_precedes contains (normalize_independent contains decides).2

/-- **Every reordering has the world's normal form.** Commute exchanges not joined within a
stretch in any way; bring the result to normal form, each exchange named by the step it held in
the world: the world reached takes the same exchange across each step of the stretch as the
world's own normal form and shows every relatum alike at each step of it. -/
theorem normalize_reorder (contains : r.Contains) (decides : DecidesApart r.Joined S m apart)
    {ts : List Nat} (within : EachStep (fun t => S ≤ t ∧ t + 2 ≤ S + m) ts)
    (independent : r.Independent ts) :
    (∀ a, S ≤ a → a < S + m → (r.normalize apart S m).flow.SameExchange a
        ((r.reorder ts).reorder (normalSteps apart S m (place ts) (origin ts) m)).flow a) ∧
    ∀ k x, S ≤ k → k ≤ S + m → (r.normalize apart S m).web.SameAt k
        ((r.reorder ts).reorder (normalSteps apart S m (place ts) (origin ts) m)).web k x :=
  have reindex := reindexes_of_within within
  have spec := normalize_independent contains decides
  have spec' := normalSteps_spec decides reindex m (Nat.le_refl m)
  have independent' : (r.reorder ts).Independent (normalSteps apart S m (place ts) (origin ts) m) :=
    (independent_iff_commutes (reorder_contains contains independent)).mpr
      ((Commutes.of_iff fun _ _ => reorder_joined contains independent).mpr spec'.2)
  have re : Rearranges r.Joined S m (fun i => i) (fun i => i) (place ts) :=
    ⟨ts, within, (independent_iff_commutes contains).mp independent, fun _ _ _ => rfl⟩
  have same := (normalForm_iff (fun _ _ => Joined.symm) decides (Reindexes.identity S m)
    reindex).mp re
  Eq.subst (motive := fun q : Footprinted X =>
      (∀ a, S ≤ a → a < S + m → (r.normalize apart S m).flow.SameExchange a q.flow a) ∧
      ∀ k x, S ≤ k → k ≤ S + m → (r.normalize apart S m).web.SameAt k q.web k x)
    (reorder_append r ts (normalSteps apart S m (place ts) (origin ts) m))
    (reorder_determined contains spec.1 (EachStep.append within spec'.1) spec.2
      (Independent.append independent independent')
      fun i hi hi' => (same i hi hi').trans
        (place_append ts (normalSteps apart S m (place ts) (origin ts) m) i).symm)

end Footprinted

/-! ## The census along reordering -/

section Census

/-- A listing with the listing at the step after `t` replaced by the first side of the listing at
`a` and the other side of the listing at `b`. -/
def spliceAt {α : Type} (l : Nat → List α) (t : Nat) (side : α → Bool) (a b : Nat) (n : Nat) :
    List α :=
  if n = t + 1 then keep (fun x => side x = true) (l a) ++ keep (fun x => side x = false) (l b)
  else l n

/-- **What holds, mixed by sides, is listed by splicing.** Where a determination holds as another
does away from the step after `t`, and there as the other held at `a` on the first side and at `b`
on the other, a listing of the other lists it, spliced at that step. -/
theorem listed_splice {α : Type} {p p' : α → Nat → Prop} {l : Nat → List α} {t a b : Nat}
    {side : α → Bool} (listed : Listed p l) (away : ∀ n x, n ≠ t + 1 → (p' x n ↔ p x n))
    (mix : ∀ x, p' x (t + 1) ↔ (side x = true ∧ p x a) ∨ (side x = false ∧ p x b)) :
    Listed p' (spliceAt l t side a b) :=
  fun n => match Nat.decEq n (t + 1) with
  | .isTrue here =>
    Eq.subst (motive := fun k => Distinct (spliceAt l t side a b k) ∧
        ∀ x, p' x k ↔ x ∈ spliceAt l t side a b k) here.symm
      (Eq.subst (motive := fun q => Distinct q ∧ ∀ x, p' x (t + 1) ↔ x ∈ q) (if_pos rfl).symm
        ⟨distinct_append (keep_distinct (listed a).1) (keep_distinct (listed b).1)
           fun _ here there => Bool.noConfusion ((mem_keep.mp here).2.symm.trans (mem_keep.mp there).2),
         fun x => ⟨fun holds => match (mix x).mp holds with
             | .inl ⟨yes, at_a⟩ => mem_append_of_left _ (mem_keep.mpr ⟨((listed a).2 x).mp at_a, yes⟩)
             | .inr ⟨no, at_b⟩ => mem_append_of_right _ (mem_keep.mpr ⟨((listed b).2 x).mp at_b, no⟩),
           fun mem => (mix x).mpr (match mem_append_cases mem with
             | .inl here => .inl ⟨(mem_keep.mp here).2, ((listed a).2 x).mpr (mem_keep.mp here).1⟩
             | .inr there => .inr ⟨(mem_keep.mp there).2,
                 ((listed b).2 x).mpr (mem_keep.mp there).1⟩)⟩⟩)
  | .isFalse other =>
    Eq.subst (motive := fun q => Distinct q ∧ ∀ x, p' x n ↔ x ∈ q) (if_neg other).symm
      ⟨(listed n).1, fun x => (away n x other).trans ((listed n).2 x)⟩

namespace Web

variable {F C : Type} {W : Web F C} {t : Nat} {sideF : F → Bool} {sideC : C → Bool}

theorem commute_active_false {f : F} (no : sideF f = false) :
    (W.commute t sideF sideC).active (t + 1) f = W.active (t + 2) f :=
  show (if t + 1 = t + 1 then cond (sideF f) (W.active t f) (W.active (t + 2) f)
    else W.active (t + 1) f) = W.active (t + 2) f from (if_pos rfl).trans (cond_of_false no)

theorem commute_level_away {n : Nat} {c : C} (other : n ≠ t + 1) :
    (W.commute t sideF sideC).level n c = W.level n c :=
  show (if n = t + 1 then cond (sideC c) (W.level t c) (W.level (t + 2) c)
    else W.level n c) = W.level n c from if_neg other

theorem mix_of_sides {P Q R : Prop} {b : Bool} (yes : b = true → (R ↔ P))
    (no : b = false → (R ↔ Q)) : R ↔ (b = true ∧ P) ∨ (b = false ∧ Q) :=
  match b, yes, no with
  | true, yes, _ => (yes rfl).trans ⟨fun p => .inl ⟨rfl, p⟩, fun
      | .inl ⟨_, p⟩ => p
      | .inr ⟨no, _⟩ => Bool.noConfusion no⟩
  | false, _, no => (no rfl).trans ⟨fun q => .inr ⟨rfl, q⟩, fun
      | .inl ⟨yes, _⟩ => Bool.noConfusion yes
      | .inr ⟨_, q⟩ => q⟩

/-- **A census carries along every commutation.** Whatever the sides, joined or not and split or
not, the web with two steps' changes taken in the other order has a census: what is active
between the two steps is listed by keeping the first side of the census before them and the other
side of the census after them. -/
theorem commute_census {alive : Nat → List F} (census : W.Census alive) :
    (W.commute t sideF sideC).Census (spliceAt alive t sideF t (t + 2)) :=
  listed_splice census (fun _ _ other => Iff.of_eq (commute_active_away other))
    fun _ => mix_of_sides (fun yes => Iff.of_eq (commute_active_true yes))
      (fun no => Iff.of_eq (commute_active_false no))

/-- And so does a census of what stands. -/
theorem commute_standingCensus {stand : Nat → List C} (census : W.StandingCensus stand) :
    (W.commute t sideF sideC).StandingCensus (spliceAt stand t sideC t (t + 2)) :=
  listed_splice census (fun _ _ other => Iff.of_eq (congrArg (0 < ·) (commute_level_away other)))
    fun _ => mix_of_sides (fun yes => Iff.of_eq (congrArg (0 < ·) (commute_level_true yes)))
      (fun no => Iff.of_eq (congrArg (0 < ·) (commute_level_false no)))

/-- Where the sides split the two steps, the census of the commuted web gives one of the web:
between the two steps a relatum on the first side is as after them, one on the other as before
them. -/
theorem commute_census_back {alive : Nat → List F} (split : W.Split t sideF sideC)
    (census : (W.commute t sideF sideC).Census alive) :
    W.Census (spliceAt alive t sideF (t + 2) t) :=
  listed_splice census (fun _ _ other => Iff.of_eq (commute_active_away other).symm)
    fun f => mix_of_sides
      (fun yes => Iff.of_eq ((split.2.2.1 f yes).1.trans (commute_active_away ne_last).symm))
      (fun no => Iff.of_eq ((split.2.2.2 f no).1.symm.trans (commute_active_away ne_first).symm))

theorem commute_standingCensus_back {stand : Nat → List C} (split : W.Split t sideF sideC)
    (census : (W.commute t sideF sideC).StandingCensus stand) :
    W.StandingCensus (spliceAt stand t sideC (t + 2) t) :=
  listed_splice census
    (fun _ _ other => Iff.of_eq (congrArg (0 < ·) (commute_level_away other).symm))
    fun c => mix_of_sides
      (fun yes => Iff.of_eq (congrArg (0 < ·)
        ((split.1 c yes).trans (commute_level_away ne_last).symm)))
      (fun no => Iff.of_eq (congrArg (0 < ·)
        ((split.2.1 c no).symm.trans (commute_level_away ne_first).symm)))

end Web

namespace World

variable {w : World} {t : Nat} {side : w.Relatum → Bool}

/-- A world with two exchanges taken in the other order is counted where the world is, whatever
the sides. -/
theorem commute_counted : w.Counted → (w.commute t side).Counted
  | ⟨_, census⟩ => ⟨_, Web.commute_census census⟩

/-- **And exactly where the world is**, where the sides split the two steps. -/
theorem commute_counted_iff (split : w.web.Split t side side) :
    (w.commute t side).Counted ↔ w.Counted :=
  ⟨fun ⟨_, census⟩ => ⟨_, Web.commute_census_back split census⟩, commute_counted⟩

end World

/-- **Along any reordering, a census.** However often exchanges the sides split are commuted,
joined or not, the web reached has a census of what is active exactly where the web has one,
and a census of what stands exactly where the web has one. -/
theorem Reorders.census {X : Type} {within : Nat → Prop} :
    ∀ {L L' : Flow X X} {W W' : Web X X}, Reorders within L W L' W' →
      ((∃ alive, W'.Census alive) ↔ ∃ alive, W.Census alive) ∧
      ((∃ stand, W'.StandingCensus stand) ↔ ∃ stand, W.StandingCensus stand)
  | _, _, _, _, .refl _ _ => ⟨Iff.rfl, Iff.rfl⟩
  | _, _, _, _, .swap _ _ _ split more =>
    have next := Reorders.census more
    ⟨next.1.trans ⟨fun ⟨_, census⟩ => ⟨_, Web.commute_census_back split census⟩,
       fun ⟨_, census⟩ => ⟨_, Web.commute_census census⟩⟩,
     next.2.trans ⟨fun ⟨_, census⟩ => ⟨_, Web.commute_standingCensus_back split census⟩,
       fun ⟨_, census⟩ => ⟨_, Web.commute_standingCensus census⟩⟩⟩

namespace Footprinted

variable {X : Type}

/-- Commuting any exchanges, joined or not, keeps a census. -/
theorem counted_reorder : ∀ (r : Footprinted X) (ts : List Nat), r.world.Counted →
    (r.reorder ts).world.Counted
  | _, [], counted => counted
  | r, t :: ts, ⟨_, census⟩ => counted_reorder (r.commute t) ts ⟨_, Web.commute_census census⟩

theorem standing_reorder : ∀ (r : Footprinted X) (ts : List Nat),
    (∃ stand, r.web.StandingCensus stand) → ∃ stand, (r.reorder ts).web.StandingCensus stand
  | _, [], standing => standing
  | r, t :: ts, ⟨_, census⟩ =>
    standing_reorder (r.commute t) ts ⟨_, Web.commute_standingCensus census⟩

/-- **Commuting exchanges not joined keeps a census both ways**: the reordering is counted, and
has a census of what stands, exactly where the world does. -/
theorem reorder_census {r : Footprinted X} {ts : List Nat} (contains : r.Contains)
    (independent : r.Independent ts) :
    ((r.reorder ts).world.Counted ↔ r.world.Counted) ∧
    ((∃ stand, (r.reorder ts).web.StandingCensus stand) ↔ ∃ stand, r.web.StandingCensus stand) :=
  Reorders.census (reorder_reorders (within := fun _ => True) contains independent
    (EachStep.always ts))

end Footprinted

end Census

/-! ## The least footprint -/

theorem bool_cases : ∀ b : Bool, b = true ∨ b = false
  | true => .inl rfl
  | false => .inr rfl

theorem not_eq_false_iff : ∀ {b : Bool}, (!b) = false ↔ b = true
  | true => ⟨fun _ => rfl, fun _ => rfl⟩
  | false => ⟨fun h => Bool.noConfusion h, fun h => Bool.noConfusion h⟩

namespace Footprinted

variable {X : Type}

/-- `idle` decides, at each step, which relata are idle across it: taking no part in its exchange
and unmoved across it. -/
def DecidesIdle (L : Flow X X) (W : Web X X) (idle : Nat → X → Bool) : Prop :=
  ∀ n x, idle n x = true ↔ (¬ x ∈ L.present n ∧ W.Unmoved n x)

/-- **The least footprint**: each step touches every relatum not idle across it, so exactly what
takes part in its exchange or is moved across it. -/
def least (L : Flow X X) (W : Web X X) (idle : Nat → X → Bool) : Footprinted X :=
  ⟨L, W, fun n x => !idle n x⟩

variable {L : Flow X X} {W : Web X X} {idle : Nat → X → Bool}

theorem least_contains (decided : DecidesIdle L W idle) : (least L W idle).Contains :=
  fun n x untouched => (decided n x).mp (not_eq_false_iff.mp untouched)

/-- The least footprint touches a relatum exactly where it is not idle. -/
theorem least_touch_iff (decided : DecidesIdle L W idle) {n : Nat} {x : X} :
    (least L W idle).touch n x = true ↔ ¬ (¬ x ∈ L.present n ∧ W.Unmoved n x) :=
  ListTests.not_true_iff.trans ⟨fun no still => Bool.noConfusion (((decided n x).mpr still).symm.trans no),
    fun not_idle => match bool_cases (idle n x) with
      | .inl yes => absurd ((decided n x).mp yes) not_idle
      | .inr no => no⟩

/-- **The least footprint is least**: every footprint containing the exchanges touches what it
touches. -/
theorem least_le (decided : DecidesIdle L W idle) {touch : Nat → X → Bool}
    (contains : (⟨L, W, touch⟩ : Footprinted X).Contains) {n : Nat} {x : X}
    (touched : (least L W idle).touch n x = true) : touch n x = true :=
  match bool_cases (touch n x) with
  | .inl yes => yes
  | .inr no => Bool.noConfusion
      (((decided n x).mpr (contains n x no)).symm.trans (ListTests.not_true_iff.mp touched))

/-- So it joins least: exchanges it joins, every containing footprint joins. -/
theorem least_joined (decided : DecidesIdle L W idle) {touch : Nat → X → Bool}
    (contains : (⟨L, W, touch⟩ : Footprinted X).Contains) {i j : Nat}
    (joined : (least L W idle).Joined i j) : (⟨L, W, touch⟩ : Footprinted X).Joined i j :=
  Joined.mono (r := least L W idle) (fun _ _ touched => least_le decided contains touched) joined

/-- **And orders least**: the order of exchanges under the least footprint is contained in the
order under every footprint containing the exchanges. -/
theorem least_precedes (decided : DecidesIdle L W idle) {touch : Nat → X → Bool}
    (contains : (⟨L, W, touch⟩ : Footprinted X).Contains) {i j : Nat}
    (before : (least L W idle).Precedes i j) : (⟨L, W, touch⟩ : Footprinted X).Precedes i j :=
  Precedes.mono (r := least L W idle) (fun _ _ touched => least_le decided contains touched) before

/-- So every renumbering reached under a containing footprint is reached under the least
(`sorts_iff`): the least footprint reaches the most arrangements. -/
theorem least_keeps (decided : DecidesIdle L W idle) {touch : Nat → X → Bool}
    (contains : (⟨L, W, touch⟩ : Footprinted X).Contains) {S m : Nat} {π : Nat → Nat}
    (keeps : (⟨L, W, touch⟩ : Footprinted X).Keeps S m π) : (least L W idle).Keeps S m π :=
  fun i j hi hj lt joined => keeps i j hi hj lt (least_joined decided contains joined)

/-- **A least footprint exists exactly where idleness is decided.** With equality of relata
decided, the exchanges of a flow and web have a least containing footprint exactly where, at each
step, taking no part in its exchange and being unmoved across it is decided. -/
theorem least_exists_iff [DecidableEq X] (L : Flow X X) (W : Web X X) :
    (∃ touch₀ : Nat → X → Bool, (⟨L, W, touch₀⟩ : Footprinted X).Contains ∧
      ∀ touch : Nat → X → Bool, (⟨L, W, touch⟩ : Footprinted X).Contains →
        ∀ n x, touch₀ n x = true → touch n x = true) ↔
    ∃ idle : Nat → X → Bool, DecidesIdle L W idle :=
  ⟨fun ⟨touch₀, contains₀, least₀⟩ => ⟨fun n x => !touch₀ n x, fun n x =>
     ⟨fun idleTrue => contains₀ n x (ListTests.not_true_iff.mp idleTrue),
      fun still => ListTests.not_true_iff.mpr (match bool_cases (touch₀ n x) with
        | .inr no => no
        | .inl yes =>
          have contains₁ : (⟨L, W, fun n' x' => if n' = n ∧ x' = x then false else touch₀ n' x'⟩ :
              Footprinted X).Contains := fun n' x' untouched =>
            if same : n' = n ∧ x' = x then
              Eq.subst (motive := fun k => ¬ x' ∈ L.present k ∧ W.Unmoved k x') same.1.symm
                (Eq.subst (motive := fun y => ¬ y ∈ L.present n ∧ W.Unmoved n y) same.2.symm still)
            else contains₀ n' x' ((if_neg same).symm.trans untouched)
          Bool.noConfusion ((if_pos (⟨rfl, rfl⟩ : n = n ∧ x = x)).symm.trans
            (least₀ _ contains₁ n x yes)))⟩⟩,
   fun ⟨_, decided⟩ => ⟨_, least_contains decided,
     fun _ contains _ _ touched => least_le decided contains touched⟩⟩

/-- Whether a list holds a relatum, equality of relata decided. -/
def inList [DecidableEq X] (x : X) : List X → Bool
  | [] => false
  | y :: ys => if x = y then true else inList x ys

theorem inList_iff [DecidableEq X] {x : X} : ∀ {l : List X}, inList x l = true ↔ x ∈ l
  | [] => ⟨fun h => Bool.noConfusion h, fun mem => nomatch mem⟩
  | y :: ys =>
    if same : x = y then
      (Iff.of_eq (congrArg (· = true) (if_pos same))).trans
        ⟨fun _ => Eq.subst (motive := fun z => z ∈ y :: ys) same.symm (.head ys), fun _ => rfl⟩
    else
      (Iff.of_eq (congrArg (· = true) (if_neg same))).trans (inList_iff.trans
        ⟨.tail y, fun mem => match mem_cons_cases mem with
          | .inl e => absurd e same
          | .inr mem' => mem'⟩)

/-- **The decision needed is of being moved.** With equality of relata decided, taking part is
decided, and idleness is decided exactly where being unmoved is decided for the relata taking no
part. -/
theorem decidesIdle_iff [DecidableEq X] :
    (∃ idle, DecidesIdle L W idle) ↔
      ∃ moves : Nat → X → Bool, ∀ n x, ¬ x ∈ L.present n → (moves n x = false ↔ W.Unmoved n x) :=
  ⟨fun ⟨idle, decided⟩ => ⟨fun n x => !idle n x, fun n x out =>
     not_eq_false_iff.trans ((decided n x).trans ⟨fun both => both.2, fun still => ⟨out, still⟩⟩)⟩,
   fun ⟨moves, decided⟩ => ⟨fun n x => !inList x (L.present n) && !moves n x, fun n x =>
     ListTests.and_true_iff.trans
       ⟨fun ⟨out, still⟩ =>
          have out' : ¬ x ∈ L.present n := fun mem =>
            Bool.noConfusion ((inList_iff.mpr mem).symm.trans (ListTests.not_true_iff.mp out))
          ⟨out', (decided n x out').mp (ListTests.not_true_iff.mp still)⟩,
        fun ⟨out, still⟩ => ⟨ListTests.not_true_iff.mpr (match bool_cases (inList x (L.present n)) with
            | .inl yes => absurd (inList_iff.mp yes) out
            | .inr no => no),
          ListTests.not_true_iff.mpr ((decided n x out).mpr still)⟩⟩⟩⟩

end Footprinted

/-! ## Three exchanges, the first and the last joined -/

namespace Triple

/-- Of the steps `0, 1, 2`, two different ones are joined exactly where they are the first and the
last: their numbers add to two. -/
def apart (i j : Nat) : Bool :=
  !(Nat.beq (i + j) 2)

def joined (i j : Nat) : Prop :=
  apart i j = false

theorem symm (i j : Nat) (link : joined i j) : joined j i :=
  (congrArg (fun k => !(Nat.beq k 2)) (Nat.add_comm j i)).trans link

theorem decides : DecidesApart joined 0 3 apart :=
  fun i j _ _ _ _ _ => ⟨fun yes no => Bool.noConfusion (yes.symm.trans no),
    fun no => match bool_cases (apart i j) with
      | .inl yes => yes
      | .inr link => absurd link no⟩

/-- The three exchanges taken last to first. -/
def reversed (i : Nat) : Nat :=
  2 - i

theorem reversed_reindexes : Reindexes 0 3 reversed reversed :=
  fun i _ below => match i, below with
    | 0, _ => ⟨⟨Nat.zero_le _, Nat.lt_succ_self 2, rfl⟩, ⟨Nat.zero_le _, Nat.lt_succ_self 2, rfl⟩⟩
    | 1, _ => ⟨⟨Nat.zero_le _, Nat.lt_trans (Nat.lt_succ_self 1) (Nat.lt_succ_self 2), rfl⟩,
        ⟨Nat.zero_le _, Nat.lt_trans (Nat.lt_succ_self 1) (Nat.lt_succ_self 2), rfl⟩⟩
    | 2, _ => ⟨⟨Nat.zero_le _, Nat.zero_lt_succ 2, rfl⟩, ⟨Nat.zero_le _, Nat.zero_lt_succ 2, rfl⟩⟩
    | n + 3, below => absurd below (Nat.not_lt_of_le (Nat.le_add_left 3 n))

/-- **The normal form computed.** Last to first, the last exchange must come before the first;
the least-named exchange that can come first is the middle one: the normal form takes the middle,
then the last, then the first. -/
theorem reversed_normal :
    normalForm apart 0 3 reversed reversed 1 = 0 ∧ normalForm apart 0 3 reversed reversed 2 = 1 ∧
      normalForm apart 0 3 reversed reversed 0 = 2 :=
  ⟨rfl, rfl, rfl⟩

/-- In the order first to last, the normal form is that order itself. -/
theorem identity_normal :
    normalForm apart 0 3 (fun i => i) (fun i => i) 0 = 0 ∧
      normalForm apart 0 3 (fun i => i) (fun i => i) 1 = 1 ∧
      normalForm apart 0 3 (fun i => i) (fun i => i) 2 = 2 :=
  ⟨rfl, rfl, rfl⟩

/-- So the two orders are not reached from each other: they take the joined first and last
exchanges in opposite orders. -/
theorem not_rearranged : ¬ Rearranges joined 0 3 reversed reversed (fun i => i) :=
  fun re => Nat.noConfusion (reversed_normal.2.2.symm.trans
    (((normalForm_iff symm decides reversed_reindexes (Reindexes.identity 0 3)).mp re 0
      (Nat.le_refl 0) (Nat.zero_lt_succ 2)).trans identity_normal.1))

end Triple

end Becoming

section OrderWorlds

/-!
## Order worlds: the arrangements of a world's exchanges, and its readings in time

`Becoming.OrderNormal` states, for any symmetric relation joining the exchanges of a stretch,
that reaching one arrangement from another by commuting exchanges not joined is fixed by the
order of joined pairs, that a lexicographic normal form exists given a decision of apartness, and
that a complete invariant exists exactly where apartness is decided. A world with a footprint
(`Footprinted`) joins its exchanges by `Footprinted.Joined`, read off the relata its exchanges
touch and the dependences of its web, and that relation is symmetric (`Footprinted.Joined.symm`).
This section states those laws of a world's exchanges, together with two laws of
`Becoming.Order` read of a world and a web: the halving, and the steps at which a family's stock
rises in commuted webs.

* **Reaching is an equivalence of a world's arrangements.** Every arrangement of a stretch of a
  world's exchanges is reached from itself (`rearranges_refl`), reaching is symmetric
  (`rearranges_symm`) and transitive (`rearranges_trans`).
* **The normal form of a world's exchanges.** Given a decision of apartness of a world's
  exchanges over a stretch, the normal form is its own normal form (`normalForm_normal`) and is
  lexicographically least among the arrangements reached (`normalForm_least`). A complete
  invariant of the arrangements of the world's exchanges exists exactly where their apartness is
  decided (`complete_iff`).
* **Every step read twice.** A world read through the halving, every step taken twice, meets
  balance, dissipation, only active relata giving and taking, activity needing support,
  embodiment and bounded transmission exactly where the world meets them (`halving_premises_iff`).
* **Commuted webs rise at as many steps.** Over a stretch holding both commuted steps, the steps
  at which a family's stock rises number the same in two commuted webs (`commuted_rise_count`).

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace OrderWorlds

/-! ### Arrangements of a world's exchanges -/

section Arrangements

variable {X : Type} (r : Footprinted X) {S m : Nat}

/-- **Every arrangement of a stretch of a world's exchanges is reached from itself.** -/
theorem rearranges_refl {π σ : Nat → Nat} (reindex : Reindexes S m π σ) :
    Rearranges r.Joined S m π σ π :=
  (rearranges_iff (fun _ _ => Footprinted.Joined.symm) reindex reindex).mpr (Orients.refl π)

/-- **Reaching one arrangement of a world's exchanges from another is symmetric.** -/
theorem rearranges_symm {π σ π' σ' : Nat → Nat} (reindex : Reindexes S m π σ)
    (reindex' : Reindexes S m π' σ') (re : Rearranges r.Joined S m π σ π') :
    Rearranges r.Joined S m π' σ' π :=
  Rearranges.symm (fun _ _ => Footprinted.Joined.symm) reindex reindex' re

/-- **And transitive.** -/
theorem rearranges_trans {π σ π' σ' π'' σ'' : Nat → Nat} (reindex : Reindexes S m π σ)
    (reindex' : Reindexes S m π' σ') (reindex'' : Reindexes S m π'' σ'')
    (first : Rearranges r.Joined S m π σ π') (second : Rearranges r.Joined S m π' σ' π'') :
    Rearranges r.Joined S m π σ π'' :=
  Rearranges.trans (fun _ _ => Footprinted.Joined.symm) reindex reindex' reindex'' first second

variable {apart : Nat → Nat → Bool}

/-- **The normal form of a world's exchanges is its own normal form**, given a decision of their
apartness over the stretch. -/
theorem normalForm_normal {π σ : Nat → Nat} (decides : DecidesApart r.Joined S m apart)
    (reindex : Reindexes S m π σ) {i : Nat} (hi : S ≤ i) (hi' : i < S + m) :
    normalForm apart S m (normalForm apart S m π σ)
        (fun p => σ (origin (normalSteps apart S m π σ m) p)) i = normalForm apart S m π σ i :=
  Becoming.normalForm_normal (fun _ _ => Footprinted.Joined.symm) decides reindex hi hi'

/-- **The normal form of a world's exchanges is lexicographically least** among the arrangements
reached: where it and one reached hold the same exchanges before step `S + k`, its exchange there
is no greater. -/
theorem normalForm_least {π σ π' σ' : Nat → Nat} (decides : DecidesApart r.Joined S m apart)
    (reindex : Reindexes S m π σ) (reindex' : Reindexes S m π' σ')
    (re : Rearranges r.Joined S m π σ π') {k : Nat} (lt : k < m)
    (before : ∀ p, S ≤ p → p < S + k → σ (origin (normalSteps apart S m π σ m) p) = σ' p) :
    σ (origin (normalSteps apart S m π σ m) (S + k)) ≤ σ' (S + k) :=
  Becoming.normalForm_least (fun _ _ => Footprinted.Joined.symm) decides reindex reindex' re lt
    before

/-- **A complete invariant of the arrangements of a world's exchanges over a stretch exists
exactly where their apartness is decided.** -/
theorem complete_iff :
    (∃ N, CompleteInvariant r.Joined S m N) ↔ ∃ apart, DecidesApart r.Joined S m apart :=
  Becoming.complete_iff (fun _ _ => Footprinted.Joined.symm)

end Arrangements

/-! ### Readings in time -/

/-- **A world read with every step taken twice meets the premises exactly where it meets
them.** -/
theorem halving_premises_iff (w : World) [DecidableEq w.Relatum] (once : w.flow.Once) :
    ((w.sample Pulse.half).Balanced ↔ w.Balanced) ∧
      ((w.sample Pulse.half).Dissipative ↔ w.Dissipative) ∧
      ((w.sample Pulse.half).Acting ↔ w.Acting) ∧ ((w.sample Pulse.half).Taking ↔ w.Taking) ∧
      ((w.sample Pulse.half).Dependent ↔ w.Dependent) ∧
      ((w.sample Pulse.half).Embodied ↔ w.Embodied) ∧
      ((w.sample Pulse.half).Transmitting ↔ w.Transmitting) :=
  World.stutter_premises_iff Order.Halving.stutter once

/-- **In two commuted webs, the steps at which a family's stock rises number the same** over a
stretch holding both commuted steps. -/
theorem commuted_rise_count {F C : Type} {W W' : Web F C} {t : Nat} (web : W.Commuted W' t)
    (cs : List C) {S m : Nat} (from_ : S ≤ t) (to : t + 2 ≤ S + m) :
    count (steps S m) (rise (W'.stock cs)) = count (steps S m) (rise (W.stock cs)) :=
  (web.stock cs).rise_count from_ to

end OrderWorlds

end Becoming

end OrderWorlds
