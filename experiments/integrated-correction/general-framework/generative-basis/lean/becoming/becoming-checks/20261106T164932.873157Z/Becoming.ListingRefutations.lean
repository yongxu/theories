import Becoming.Listing
import Becoming.Standpoints

/-!
# ListingRefutations: the refutation laws hold however a family is listed

`Becoming.Listing` found what listing each relatum once commits to: a list can be listed once
exactly where identity among its members is decided (`listsOnce_iff_decided`), that it can be is
never refuted (`not_not_listsOnce`), and so a law refuting something wherever a list is listed
once refutes it of the list with no premise (`not_of_listsOnce`). Its inventory classed thirty
uses of `Distinct` in the core as free in this way: the law's other hypotheses read the family
through membership only, and its conclusion is a refutation. Six were proved there. This module
proves the rest, each as a corollary named after its law with `_listing`, with no `Distinct`: the
family may list a member twice. Fifteen need no decided identity either, so nothing need tell the
family's members apart. The seven whose law's own statement takes `[DecidableEq]` on its type (the
five laws of being fed from beyond and the two of the boundary crossed) keep that instance, which
already decides identity among any list's members; for them the corollary drops `Distinct` only.

* **What is a matter of membership.** Balance on a family, being fed from beyond it, and the
  boundary of its region as a cut are matters of its members (`Flow.BalancesOn.of_same`,
  `Flow.FedFromBeyond.of_within`, `Flow.cut_of_same`), as closure, enclosure around a family,
  inflow and taking are (`Becoming.Listing`). A stock that is nothing over a family is nothing
  over every family with no other members, and so is its product with any refinement
  (`total_zero_of_within`, `mul_zero_of`).
* **Being fed from beyond** (`Becoming.Continuation`): `Flow.fed_from_beyond_listing`,
  `Flow.fed_from_beyond_from_listing`, `Flow.rising_fed_from_beyond_listing`,
  `Flow.rising_fed_from_beyond_from_listing`, and `Web.embodiedArising_fed_from_beyond_listing`: a
  dissipative family enclosed around from some step on, in which embodied members arise at
  arbitrarily late steps, cannot from some step on be fed from nothing beyond it, however the
  family is listed.
* **Opening** (`Becoming.Dissipation`, `Becoming.Roles`): `Flow.More.opens_listing`,
  `Flow.opens_of_arising_listing`, `Flow.rising_opens_listing`, `Flow.standing_opens_listing`,
  `Flow.rise_alone_opens_listing`, `Web.embodiedArising_opens_listing`.
* **Drawing in** (`Becoming.Dissipation`, `Becoming.Roles`): `Flow.taking_draws_in_from_listing`,
  `Flow.rising_draws_in_from_listing`, `Flow.rising_draws_in_listing`,
  `Flow.standing_draws_in_listing`, `Web.embodiedArising_draws_in_from_listing`,
  `Web.embodiedArising_draws_in_listing`.
* **Rest** (`Becoming.Dissipation`, `Becoming.Resolution`): where some list, repetition allowed,
  holds every condition, rising and coming to stand do not recur under dissipation
  (`Flow.rising_not_recurring_listing`, `Flow.standing_not_recurring_listing`), and taking from a
  closed family left unrefined does not recur (`Flow.taking_needs_refinement_listing`).
* **The boundary crossed** (`Becoming.Standpoints`): `Flow.boundary_crossed_listing` and
  `Flow.region_not_a_cut_listing`.

The laws inside the witnesses `Frontier` and `Lone` (`Frontier.frontier`, `Lone.frontier`) state a
refutation about their own lists, which are without repetition by construction; they need no
corollary. No premise is added, and every declaration has an empty axiom report.
-/

namespace Becoming

/-! ## What is a matter of membership -/

/-- Where `b = 0` gives `b' = 0`, a product with `b` that is nothing gives one with `b'`. -/
theorem mul_zero_of {b b' : Nat} (zero : b = 0 → b' = 0) : ∀ a, a * b = 0 → a * b' = 0
  | 0, _ => Nat.zero_mul b'
  | a + 1, product => match b, product with
    | 0, _ => (congrArg ((a + 1) * ·) (zero rfl)).trans (Nat.mul_zero (a + 1))
    | _ + 1, product => Nat.noConfusion product

/-- A total that is nothing over a family is nothing over every family with no other
members. -/
theorem total_zero_of_within {C : Type} {q : C → Nat} {ds es : List C}
    (within : ∀ c, c ∈ es → c ∈ ds) (zero : total ds q = 0) : total es q = 0 :=
  match h : total es q with
  | 0 => rfl
  | _ + 1 => absurd zero
      (Nat.ne_of_gt (Flow.total_pos_of_within within (Nat.lt_of_lt_of_le (Nat.succ_pos _) (Nat.le_of_eq h.symm))))

namespace Flow

variable {F C : Type} {L : Flow F C} {W : Web F C}

/-- Balance on a family is a matter of its members. -/
theorem BalancesOn.of_same {ds es : List C} {t : Nat} (balanced : L.BalancesOn W ds t)
    (within : ∀ c, c ∈ es → c ∈ ds) : L.BalancesOn W es t :=
  fun c mem => balanced c (within c mem)

/-- Being fed from beyond a family is a matter of its members. -/
theorem FedFromBeyond.of_within {ds es : List C} {t : Nat} (fed : L.FedFromBeyond es t)
    (same : ∀ c, c ∈ es ↔ c ∈ ds) : L.FedFromBeyond ds t :=
  match fed with
  | ⟨c, d, outside, inside, conveys⟩ =>
    ⟨c, d, fun mem => outside ((same c).mpr mem), (same d).mp inside, conveys⟩

/-! ## Being fed from beyond -/

/-- **`fed_from_beyond` holds of every family, however listed, with no premise.** -/
theorem fed_from_beyond_listing [DecidableEq C] (balances : L.Balances W)
    (dissipative : L.Dissipative) {ds : List C} {T₀ : Nat}
    (around : ∀ t, T₀ ≤ t → L.Around ds t) (recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers ds t)
    (N : Nat) : ¬ ∀ t, N ≤ t → ¬ L.FedFromBeyond ds t :=
  not_of_listsOnce ds fun _ lists unfed =>
    fed_from_beyond balances dissipative lists.1
      (fun t later => (around t later).of_same fun c mem => (lists.2 c).mp mem)
      (fun M => match recurs M with
        | ⟨t, later, takes⟩ =>
          ⟨t, later, takers_pos_of_sub (fun c mem => (lists.2 c).mpr mem) takes⟩)
      N fun t later fed => unfed t later (fed.of_within lists.2)

/-- **`fed_from_beyond_from` holds of every family, however listed, with no premise.** -/
theorem fed_from_beyond_from_listing [DecidableEq C] {ds : List C} {T₀ : Nat}
    (around : ∀ t, T₀ ≤ t → L.Around ds t) (balances : ∀ t, T₀ ≤ t → L.BalancesOn W ds t)
    (dissipative : ∀ t, T₀ ≤ t → ∀ es, Distinct es → L.ClosedAt es t → L.DissipatesOn es t)
    (recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers ds t) (N : Nat) :
    ¬ ∀ t, N ≤ t → ¬ L.FedFromBeyond ds t :=
  not_of_listsOnce ds fun _ lists unfed =>
    fed_from_beyond_from lists.1
      (fun t later => (around t later).of_same fun c mem => (lists.2 c).mp mem)
      (fun t later => (balances t later).of_same fun c mem => (lists.2 c).mp mem)
      dissipative
      (fun M => match recurs M with
        | ⟨t, later, takes⟩ =>
          ⟨t, later, takers_pos_of_sub (fun c mem => (lists.2 c).mpr mem) takes⟩)
      N fun t later fed => unfed t later (fed.of_within lists.2)

/-- **`rising_fed_from_beyond` holds of every family, however listed, with no premise.** -/
theorem rising_fed_from_beyond_listing [DecidableEq C] (balances : L.Balances W)
    (dissipative : L.Dissipative) {ds : List C} {T₀ : Nat}
    (around : ∀ t, T₀ ≤ t → L.Around ds t) (rising : ∀ N, ∃ t c, N ≤ t ∧ c ∈ ds ∧ W.Rises t c)
    (N : Nat) : ¬ ∀ t, N ≤ t → ¬ L.FedFromBeyond ds t :=
  not_of_listsOnce ds fun _ lists unfed =>
    rising_fed_from_beyond balances dissipative lists.1
      (fun t later => (around t later).of_same fun c mem => (lists.2 c).mp mem)
      (fun M => match rising M with
        | ⟨t, c, later, mem, rises⟩ => ⟨t, c, later, (lists.2 c).mpr mem, rises⟩)
      N fun t later fed => unfed t later (fed.of_within lists.2)

/-- **`rising_fed_from_beyond_from` holds of every family, however listed, with no premise.** -/
theorem rising_fed_from_beyond_from_listing [DecidableEq C] {ds : List C} {T₀ : Nat}
    (around : ∀ t, T₀ ≤ t → L.Around ds t) (balances : ∀ t, T₀ ≤ t → L.BalancesOn W ds t)
    (dissipative : ∀ t, T₀ ≤ t → ∀ es, Distinct es → L.ClosedAt es t → L.DissipatesOn es t)
    (rising : ∀ N, ∃ t c, N ≤ t ∧ c ∈ ds ∧ W.Rises t c) (N : Nat) :
    ¬ ∀ t, N ≤ t → ¬ L.FedFromBeyond ds t :=
  not_of_listsOnce ds fun _ lists unfed =>
    rising_fed_from_beyond_from lists.1
      (fun t later => (around t later).of_same fun c mem => (lists.2 c).mp mem)
      (fun t later => (balances t later).of_same fun c mem => (lists.2 c).mp mem)
      dissipative
      (fun M => match rising M with
        | ⟨t, c, later, mem, rises⟩ => ⟨t, c, later, (lists.2 c).mpr mem, rises⟩)
      N fun t later fed => unfed t later (fed.of_within lists.2)

/-! ## Opening -/

/-- **`More.opens` holds of every family, however listed, with no premise.** -/
theorem More.opens_listing (balances : L.Balances W) (dissipative : L.Dissipative)
    {cs ds : List C} (within : ∀ c, c ∈ cs → c ∈ ds) (more : L.More cs) (T : Nat) :
    ¬ ∀ t, T ≤ t → L.ClosedAt ds t :=
  not_of_listsOnce ds fun _ lists closed =>
    more.opens balances dissipative lists.1 (fun c mem => (lists.2 c).mpr (within c mem)) T
      fun t later => (closed t later).widen fun c mem => (lists.2 c).mpr mem

/-- **`opens_of_arising` holds of every family, however listed, with no premise.** -/
theorem opens_of_arising_listing (balances : L.Balances W) (dissipative : L.Dissipative)
    {cs ds : List C} (within : ∀ c, c ∈ cs → c ∈ ds)
    (arising : ∀ N, ∃ t f, N ≤ t ∧ L.ArisesTaking W cs t f) (T : Nat) :
    ¬ ∀ t, T ≤ t → L.ClosedAt ds t :=
  not_of_listsOnce ds fun _ lists closed =>
    opens_of_arising balances dissipative lists.1 (fun c mem => (lists.2 c).mpr (within c mem))
      arising T fun t later => (closed t later).widen fun c mem => (lists.2 c).mpr mem

/-- **`rising_opens` holds of every family, however listed, with no premise.** -/
theorem rising_opens_listing (balances : L.Balances W) (dissipative : L.Dissipative)
    {ds : List C} (rising : ∀ N, ∃ t c, N ≤ t ∧ c ∈ ds ∧ W.Rises t c) (T : Nat) :
    ¬ ∀ t, T ≤ t → L.ClosedAt ds t :=
  not_of_listsOnce ds fun _ lists closed =>
    rising_opens balances dissipative lists.1
      (fun M => match rising M with
        | ⟨t, c, later, mem, rises⟩ => ⟨t, c, later, (lists.2 c).mpr mem, rises⟩)
      T fun t later => (closed t later).widen fun c mem => (lists.2 c).mpr mem

/-- **`standing_opens` holds of every family, however listed, with no premise.** -/
theorem standing_opens_listing (balances : L.Balances W) (dissipative : L.Dissipative)
    {ds : List C} (coming : ∀ N, ∃ t c, N ≤ t ∧ c ∈ ds ∧ W.ComesToStand t c) (T : Nat) :
    ¬ ∀ t, T ≤ t → L.ClosedAt ds t :=
  not_of_listsOnce ds fun _ lists closed =>
    standing_opens balances dissipative lists.1
      (fun M => match coming M with
        | ⟨t, c, later, mem, comes⟩ => ⟨t, c, later, (lists.2 c).mpr mem, comes⟩)
      T fun t later => (closed t later).widen fun c mem => (lists.2 c).mpr mem

/-- **`rise_alone_opens` holds of every family, however listed, with no premise.** -/
theorem rise_alone_opens_listing (balances : L.Balances W) (dissipative : L.Dissipative)
    {ds : List C} {t : Nat} {c : C} (mem : c ∈ ds) (rises : W.Rises t c)
    (still : ∀ d, d ∈ ds → ¬ W.Falls t d) : ¬ L.ClosedAt ds t :=
  not_of_listsOnce ds fun _ lists closed =>
    rise_alone_opens balances dissipative lists.1 ((lists.2 c).mpr mem) rises
      (fun d inside => still d ((lists.2 d).mp inside))
      (closed.widen fun d inside => (lists.2 d).mpr inside)

/-! ## Drawing in -/

/-- **`taking_draws_in_from` holds of every family, however listed, with no premise.** -/
theorem taking_draws_in_from_listing {ds : List C} {T₀ : Nat}
    (around : ∀ t, T₀ ≤ t → L.Around ds t) (balances : ∀ t, T₀ ≤ t → L.BalancesOn W ds t)
    (dissipative : ∀ t, T₀ ≤ t → ∀ es, Distinct es → L.ClosedAt es t → L.DissipatesOn es t)
    (recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers ds t) (N : Nat) :
    ¬ ∀ t, N ≤ t → L.Inward ds t :=
  not_of_listsOnce ds fun _ lists inward =>
    taking_draws_in_from lists.1
      (fun t later => (around t later).of_same fun c mem => (lists.2 c).mp mem)
      (fun t later => (balances t later).of_same fun c mem => (lists.2 c).mp mem)
      dissipative
      (fun M => match recurs M with
        | ⟨t, later, takes⟩ =>
          ⟨t, later, takers_pos_of_sub (fun c mem => (lists.2 c).mpr mem) takes⟩)
      N fun t later => (inward t later).of_same fun c => (lists.2 c).symm

/-- **`rising_draws_in_from` holds of every family, however listed, with no premise.** -/
theorem rising_draws_in_from_listing {ds : List C} {T₀ : Nat}
    (around : ∀ t, T₀ ≤ t → L.Around ds t) (balances : ∀ t, T₀ ≤ t → L.BalancesOn W ds t)
    (dissipative : ∀ t, T₀ ≤ t → ∀ es, Distinct es → L.ClosedAt es t → L.DissipatesOn es t)
    (rising : ∀ N, ∃ t c, N ≤ t ∧ c ∈ ds ∧ W.Rises t c) (N : Nat) :
    ¬ ∀ t, N ≤ t → L.Inward ds t :=
  not_of_listsOnce ds fun _ lists inward =>
    rising_draws_in_from lists.1
      (fun t later => (around t later).of_same fun c mem => (lists.2 c).mp mem)
      (fun t later => (balances t later).of_same fun c mem => (lists.2 c).mp mem)
      dissipative
      (fun M => match rising M with
        | ⟨t, c, later, mem, rises⟩ => ⟨t, c, later, (lists.2 c).mpr mem, rises⟩)
      N fun t later => (inward t later).of_same fun c => (lists.2 c).symm

/-- **`rising_draws_in` holds of every family, however listed, with no premise.** -/
theorem rising_draws_in_listing (balances : L.Balances W) (dissipative : L.Dissipative)
    {ds : List C} {T₀ : Nat} (around : ∀ t, T₀ ≤ t → L.Around ds t)
    (rising : ∀ N, ∃ t c, N ≤ t ∧ c ∈ ds ∧ W.Rises t c) (N : Nat) :
    ¬ ∀ t, N ≤ t → L.Inward ds t :=
  not_of_listsOnce ds fun _ lists inward =>
    rising_draws_in balances dissipative lists.1
      (fun t later => (around t later).of_same fun c mem => (lists.2 c).mp mem)
      (fun M => match rising M with
        | ⟨t, c, later, mem, rises⟩ => ⟨t, c, later, (lists.2 c).mpr mem, rises⟩)
      N fun t later => (inward t later).of_same fun c => (lists.2 c).symm

/-- **`standing_draws_in` holds of every family, however listed, with no premise.** -/
theorem standing_draws_in_listing (balances : L.Balances W) (dissipative : L.Dissipative)
    {ds : List C} {T₀ : Nat} (around : ∀ t, T₀ ≤ t → L.Around ds t)
    (coming : ∀ N, ∃ t c, N ≤ t ∧ c ∈ ds ∧ W.ComesToStand t c) (N : Nat) :
    ¬ ∀ t, N ≤ t → L.Inward ds t :=
  not_of_listsOnce ds fun _ lists inward =>
    standing_draws_in balances dissipative lists.1
      (fun t later => (around t later).of_same fun c mem => (lists.2 c).mp mem)
      (fun M => match coming M with
        | ⟨t, c, later, mem, comes⟩ => ⟨t, c, later, (lists.2 c).mpr mem, comes⟩)
      N fun t later => (inward t later).of_same fun c => (lists.2 c).symm

/-! ## Rest -/

/-- **Where some list, repetition allowed, holds every condition, rising does not recur under
dissipation**: no listing once and no decided identity (`rising_not_recurring`). -/
theorem rising_not_recurring_listing (balances : L.Balances W) (dissipative : L.Dissipative)
    {all : List C} (every : ∀ c, c ∈ all) : ¬ ∀ N, ∃ t c, N ≤ t ∧ W.Rises t c :=
  not_of_listsOnce all fun _ lists =>
    rising_not_recurring balances dissipative lists.1 fun c => (lists.2 c).mpr (every c)

/-- **Nor does coming to stand**, however the list is listed (`standing_not_recurring`). -/
theorem standing_not_recurring_listing (balances : L.Balances W) (dissipative : L.Dissipative)
    {all : List C} (every : ∀ c, c ∈ all) : ¬ ∀ N, ∃ t c, N ≤ t ∧ W.ComesToStand t c :=
  not_of_listsOnce all fun _ lists =>
    standing_not_recurring balances dissipative lists.1 fun c => (lists.2 c).mpr (every c)

/-- **`taking_needs_refinement` holds of every family, however listed, with no premise**: where
a closed family's stock is left unrefined from some step on, taking from it does not recur. -/
theorem taking_needs_refinement_listing {split : Nat → Nat}
    (balances : L.BalancesAt (fun t => split t + 1) W) (dissipative : L.Dissipative)
    {cs : List C} {T : Nat} (closed : ∀ t, T ≤ t → L.ClosedAt cs t)
    (unrefined : ∀ t, T ≤ t → split t * W.stock cs t = 0) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers cs t :=
  not_of_listsOnce cs fun _ lists recurs =>
    taking_needs_refinement balances dissipative lists.1
      (fun t later => (closed t later).widen fun c mem => (lists.2 c).mpr mem)
      (fun t later => mul_zero_of (total_zero_of_within fun c mem => (lists.2 c).mp mem)
        (split t) (unrefined t later))
      fun M => match recurs M with
        | ⟨t, later, takes⟩ =>
          ⟨t, later, takers_pos_of_sub (fun c mem => (lists.2 c).mpr mem) takes⟩

end Flow

/-! ## Arising, embodied -/

namespace Web

variable {X : Type} {W : Web X X} {L : Flow X X}

/-- **`embodiedArising_fed_from_beyond` holds of every family, however listed, with no premise**:
under dissipation, a family in which embodied members arise at arbitrarily late steps, enclosed
around from some step on, cannot from some step on be fed from nothing beyond it. -/
theorem embodiedArising_fed_from_beyond_listing [DecidableEq X] (balances : L.Balances W)
    (dissipative : L.Dissipative) {ds : List X} {T₀ : Nat}
    (around : ∀ t, T₀ ≤ t → L.Around ds t)
    (arising : ∀ N, ∃ t x, N ≤ t ∧ x ∈ ds ∧ W.Embodied x ∧ W.Arises t x) (N : Nat) :
    ¬ ∀ t, N ≤ t → ¬ L.FedFromBeyond ds t :=
  not_of_listsOnce ds fun _ lists unfed =>
    embodiedArising_fed_from_beyond balances dissipative lists.1
      (fun t later => (around t later).of_same fun c mem => (lists.2 c).mp mem)
      (fun M => match arising M with
        | ⟨t, x, later, mem, embodied, arises⟩ => ⟨t, x, later, (lists.2 x).mpr mem, embodied, arises⟩)
      N fun t later fed => unfed t later (fed.of_within lists.2)

/-- **`embodiedArising_opens` holds of every family, however listed, with no premise.** -/
theorem embodiedArising_opens_listing (balances : L.Balances W) (dissipative : L.Dissipative)
    {ds : List X} (arising : ∀ N, ∃ t x, N ≤ t ∧ x ∈ ds ∧ W.Embodied x ∧ W.Arises t x)
    (T : Nat) : ¬ ∀ t, T ≤ t → L.ClosedAt ds t :=
  not_of_listsOnce ds fun _ lists closed =>
    embodiedArising_opens balances dissipative lists.1
      (fun M => match arising M with
        | ⟨t, x, later, mem, embodied, arises⟩ => ⟨t, x, later, (lists.2 x).mpr mem, embodied, arises⟩)
      T fun t later => (closed t later).widen fun c mem => (lists.2 c).mpr mem

/-- **`embodiedArising_draws_in_from` holds of every family, however listed, with no premise.** -/
theorem embodiedArising_draws_in_from_listing {ds : List X} {T₀ : Nat}
    (around : ∀ t, T₀ ≤ t → L.Around ds t) (balances : ∀ t, T₀ ≤ t → L.BalancesOn W ds t)
    (dissipative : ∀ t, T₀ ≤ t → ∀ es, Distinct es → L.ClosedAt es t → L.DissipatesOn es t)
    (arising : ∀ N, ∃ t x, N ≤ t ∧ x ∈ ds ∧ W.Embodied x ∧ W.Arises t x) (N : Nat) :
    ¬ ∀ t, N ≤ t → L.Inward ds t :=
  not_of_listsOnce ds fun _ lists inward =>
    embodiedArising_draws_in_from lists.1
      (fun t later => (around t later).of_same fun c mem => (lists.2 c).mp mem)
      (fun t later => (balances t later).of_same fun c mem => (lists.2 c).mp mem)
      dissipative
      (fun M => match arising M with
        | ⟨t, x, later, mem, embodied, arises⟩ => ⟨t, x, later, (lists.2 x).mpr mem, embodied, arises⟩)
      N fun t later => (inward t later).of_same fun c => (lists.2 c).symm

/-- **`embodiedArising_draws_in` holds of every family, however listed, with no premise.** -/
theorem embodiedArising_draws_in_listing (balances : L.Balances W) (dissipative : L.Dissipative)
    {ds : List X} {T₀ : Nat} (around : ∀ t, T₀ ≤ t → L.Around ds t)
    (arising : ∀ N, ∃ t x, N ≤ t ∧ x ∈ ds ∧ W.Embodied x ∧ W.Arises t x) (N : Nat) :
    ¬ ∀ t, N ≤ t → L.Inward ds t :=
  not_of_listsOnce ds fun _ lists inward =>
    embodiedArising_draws_in balances dissipative lists.1
      (fun t later => (around t later).of_same fun c mem => (lists.2 c).mp mem)
      (fun M => match arising M with
        | ⟨t, x, later, mem, embodied, arises⟩ => ⟨t, x, later, (lists.2 x).mpr mem, embodied, arises⟩)
      N fun t later => (inward t later).of_same fun c => (lists.2 c).symm

end Web

/-! ## The boundary crossed -/

namespace Flow

variable {X Pos : Type} {L : Flow X X} {W : Web X X} {own sig : Pos → X × Nat → Prop}

/-- Whether a region bounded by a family is a cut is a matter of the family's members. -/
theorem cut_of_same {V : Valuation Pos (X × Nat)} {ds es : List X}
    (cut : Cut V (fun e => e.1 ∈ ds)) (same : ∀ c, c ∈ es ↔ c ∈ ds) :
    Cut V (fun e => e.1 ∈ es) :=
  fun e e' inside outside => cut e e' ((same e.1).mp inside) fun mem => outside ((same e'.1).mpr mem)

/-- **`boundary_crossed` holds of every family, however listed, with no premise.** -/
theorem boundary_crossed_listing [DecidableEq X] (balances : L.Balances W)
    (dissipative : L.Dissipative) {ds : List X} {T₀ : Nat}
    (around : ∀ t, T₀ ≤ t → L.Around ds t) (recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers ds t)
    (N : Nat) :
    ¬ ∀ t, N ≤ t → ¬ ∃ c d, ¬ c ∈ ds ∧ d ∈ ds ∧ (L.conveyance W own sig).related (c, t) (d, t) :=
  not_of_listsOnce ds fun _ lists uncrossed =>
    boundary_crossed (own := own) (sig := sig) balances dissipative lists.1
      (fun t later => (around t later).of_same fun c mem => (lists.2 c).mp mem)
      (fun M => match recurs M with
        | ⟨t, later, takes⟩ =>
          ⟨t, later, takers_pos_of_sub (fun c mem => (lists.2 c).mpr mem) takes⟩)
      N fun t later ⟨c, d, outside, inside, related⟩ =>
        uncrossed t later ⟨c, d, fun mem => outside ((lists.2 c).mpr mem), (lists.2 d).mp inside,
          related⟩

/-- **`region_not_a_cut` holds of every family, however listed, with no premise.** -/
theorem region_not_a_cut_listing [DecidableEq X] (balances : L.Balances W)
    (dissipative : L.Dissipative) {ds : List X} {T₀ : Nat}
    (around : ∀ t, T₀ ≤ t → L.Around ds t) (recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers ds t) :
    ¬ Cut (L.conveyance W own sig) (fun e => e.1 ∈ ds) :=
  not_of_listsOnce ds fun _ lists cut =>
    region_not_a_cut balances dissipative lists.1
      (fun t later => (around t later).of_same fun c mem => (lists.2 c).mp mem)
      (fun M => match recurs M with
        | ⟨t, later, takes⟩ =>
          ⟨t, later, takers_pos_of_sub (fun c mem => (lists.2 c).mpr mem) takes⟩)
      (cut_of_same cut lists.2)

end Flow

end Becoming
