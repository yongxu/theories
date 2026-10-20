import Becoming.DrawnBeyond
import Becoming.Frontier

/-!
# Optimum: what optimizing through couplings does beyond them

`Becoming.DrawnBeyond` showed that where the whole gains nothing the beyond falls by the rise and
the loss, that above the slack a dependence beyond breaks, and that a selection rewarding the rise
rewards that break unseen. It did not say what an *optimum* does: how far a selection that takes
the best it can, by an order rising with what couples in, lowers what lies beyond. This module
states it, over any set of outcomes and any such order, and on a web's dependences. An outcome is
the levels after a step (`C → Nat`); the eligible outcomes are any set of them; an optimum is a
member of the frontier of `Requirement.Frontier` (eligible, with no eligible outcome ranked above
it). The family `ds` is what couples in, `rest` the conditions beyond, listed apart.

* **The drive to the least level, exactly.** Call an order *rising* with a family where it ranks
  above every outcome exceeding another on the family (at least as high at each of its conditions
  and higher at one), whatever either holds beyond (`Optimum.Rising`). Every rising order's optima
  stand at the least level beyond, condition by condition, among the eligible outcomes, exactly
  where every eligible outcome standing above another at a condition beyond is not unbeaten on the
  family (`Optimum.least_iff`). So, where lowering a condition beyond leaves the family room to
  rise (`Optimum.Room`), every optimum is at the least level beyond (`Optimum.least_of_room`); where
  it does not, an optimum need not be (`Drain.room_needed`). One case of room is *shared units*:
  the eligible outcomes are closed under moving a unit from a condition beyond that holds one into
  a condition of the family (`Optimum.Shared.room`, `Optimum.least_of_shared`).
* **Counting the beyond after the proxy changes nothing.** An order ranking above wherever a rising
  order does is rising (`Optimum.Rising.mono`): a lexicographic order with the family first and
  the beyond counted after has its optima at the least level beyond (`Drain.counted_after_drains`).
  The stock of the family is a rising order (`Optimum.rising_total`); an order rising only to a
  target is not, and its optima include the outcome keeping what lies beyond and the outcome
  ending it (`Drain.satisficing_either`).
* **An optimum breaks exactly what any outcome breaks.** On a web whose levels after the step are
  an optimum of a rising order with room, with each condition beyond depended on at a need it meets,
  a dependence beyond is broken exactly where some eligible outcome leaves its condition below the
  need (`Web.optimum_broken_iff`): of the dependences beyond, the optimum breaks the most any
  eligible outcome breaks. Where activity needs support and the dependence is as it was, the
  formation ends, it is no member of a group all of whose couplings are in the family, and no
  member couples into its condition (`Web.optimum_ends_beyond`). `Drain` is the instance: the
  store's optimum drains the source and the dweller ends (`Drain.drained_ends`).
* **Raising the family is lowering the beyond with the loss, unit for unit.** Of two balanced
  steps from equal totals, each gaining nothing on the whole, one leaves the family at most where
  the other does exactly where it leaves the beyond with the loss at least where the other does
  (`Flow.Balances.family_le_iff`); so among such moves the ones whose family stock is highest are
  exactly the ones leaving least beyond with the loss (`Flow.top_iff_least`).
* **Keeping each dependence, the optimum takes exactly the slack.** Restricted to the outcomes
  keeping every dependence beyond at its need, a rising order with room among them, where each
  need is attained by one of them, has its optimum stand at the needs: it breaks nothing, and in a
  balanced step gaining nothing on the whole the family rises, with the loss, by exactly the slack
  (`Flow.keeping_optimum_takes_slack`). `Drain.kept_takes_slack` is the instance: the keeping
  optimum is `DrawnBeyond.WithinSlack`'s world.

**Reading (the AI's).** This is the spine's form of a known result: optimizing a proxy that
references only some attributes drives the others to their lower bounds (Zhuang and
Hadfield-Menell, "Consequences of Misaligned AI", 2020, Theorem 1). What the spine's form adds:
the characterization is over any order rising with what couples in, not a scalar proxy, and exact
on any set of outcomes (`least_iff`), with shared resources one sufficient case; no utility over
what lies beyond is assumed, the degradation being read as dependences broken and formations
ended, exactly those some outcome breaks; and the conservation identity says by how much: the
beyond with the loss falls by exactly what the family rises. Counting the beyond only after the
proxy keeps nothing, and restricting to keeping outcomes uses the slack and no more, which is less
than holding the beyond where it was (their Proposition 2). It does not reach their continuous
setting, the compactness characterization of their Theorem 2, or the interactive improvement of
their Theorem 3 and Propositions 4 and 5.

What is not derived: which outcomes are eligible and whether there is room (hypotheses wherever
they enter, with witnesses that each binds); that a given optimizer's order rises with just the
couplings listed (supplied, as in `Becoming.SelectionGap`); which formation depends on which
condition beyond and at what need (named by `dep`). That an order keeping what lies beyond
separates outcomes differing only beyond, and so goes through a member coupled into it, is
`Direction.widening_selected_by_pool`, not repeated here. The representation commits to discrete
steps and natural amounts. No ethical predicate, ranking of the beyond or axiom occurs.
-/

namespace Becoming

open Requirement

variable {F C : Type}

namespace Optimum

/-- One outcome exceeds another on a family: at least as high at each of its conditions and higher
at one. -/
def Exceeds (ds : List C) (o' o : C → Nat) : Prop :=
  (∀ c, c ∈ ds → o c ≤ o' c) ∧ ∃ c, c ∈ ds ∧ o c < o' c

/-- An order rises with a family: it ranks every outcome exceeding another on the family above
it, whatever either holds elsewhere. -/
def Rising (ds : List C) (better : (C → Nat) → (C → Nat) → Prop) : Prop :=
  ∀ o o', Exceeds ds o' o → better o' o

/-- Room beyond: an eligible outcome standing above another at a condition beyond is exceeded on
the family by an eligible outcome. -/
def Room (ds rest : List C) (eligible : (C → Nat) → Prop) : Prop :=
  ∀ o o', eligible o → eligible o' → ∀ c, c ∈ rest → o' c < o c →
    ∃ o'', eligible o'' ∧ Exceeds ds o'' o

/-- At the least level beyond: at each condition beyond, no eligible outcome stands lower. -/
def Least (rest : List C) (eligible : (C → Nat) → Prop) (o : C → Nat) : Prop :=
  ∀ c, c ∈ rest → ∀ o', eligible o' → o c ≤ o' c

variable {ds rest : List C} {eligible : (C → Nat) → Prop}
  {better : (C → Nat) → (C → Nat) → Prop}

/-- Where an outcome exceeds another on a family, the family's total under it is higher. -/
theorem Exceeds.total_lt {o o' : C → Nat} :
    ∀ {ds : List C}, Exceeds ds o' o → total ds o < total ds o'
  | [], ⟨_, _, mem, _⟩ => nomatch mem
  | a :: ds, ⟨le, c, mem, lt⟩ => match mem_cons_cases mem with
    | .inl same =>
      Nat.add_lt_add_of_lt_of_le (Eq.subst (motive := fun y => o y < o' y) same lt)
        (total_le ds fun b listed => le b (.tail a listed))
    | .inr rest =>
      Nat.add_lt_add_of_le_of_lt (le a (.head ds))
        (Exceeds.total_lt ⟨fun b listed => le b (.tail a listed), c, rest, lt⟩)

/-- **The family's stock is a rising order.** -/
theorem rising_total (ds : List C) : Rising ds fun o' o => total ds o < total ds o' :=
  fun _ _ exceeds => exceeds.total_lt

/-- **An order ranking above wherever a rising order does is rising**: a lexicographic order with
the family first, whatever it counts after, is one. -/
theorem Rising.mono (rising : Rising ds better) {better' : (C → Nat) → (C → Nat) → Prop}
    (above : ∀ o' o, better o' o → better' o' o) : Rising ds better' :=
  fun o o' exceeds => above o' o (rising o o' exceeds)

/-- **The drive to the least level, exactly.** Every order rising with the family has its optima
at the least level beyond, condition by condition, among the eligible outcomes, exactly where every
eligible outcome standing above another at a condition beyond is not unbeaten on the family. -/
theorem least_iff :
    (∀ better, Rising ds better → ∀ o, Frontier eligible better o → Least rest eligible o) ↔
      ∀ o o', eligible o → eligible o' → ∀ c, c ∈ rest → o' c < o c →
        ¬ ¬ ∃ o'', eligible o'' ∧ Exceeds ds o'' o :=
  ⟨fun drives o o' eligibleO eligibleO' c mem lower unbeaten =>
      Nat.not_le_of_gt lower
        (drives (fun o₁ o₂ => Exceeds ds o₁ o₂) (fun _ _ exceeds => exceeds) o
          ⟨eligibleO, fun o'' eligible'' exceeds => unbeaten ⟨o'', eligible'', exceeds⟩⟩
          c mem o' eligibleO'),
   fun beaten _ rising o optimum c mem o' eligibleO' => Nat.ge_of_not_lt fun lower =>
      beaten o o' optimum.1 eligibleO' c mem lower fun ⟨o'', eligible'', exceeds⟩ =>
        optimum.2 o'' eligible'' (rising o o'' exceeds)⟩

/-- **With room, every optimum is at the least level beyond.** -/
theorem least_of_room (rising : Rising ds better) (room : Room ds rest eligible) {o : C → Nat}
    (optimum : Frontier eligible better o) : Least rest eligible o :=
  least_iff.mpr (fun o o' eligibleO eligibleO' c mem lower unbeaten =>
    unbeaten (room o o' eligibleO eligibleO' c mem lower)) better rising o optimum

/-! ## Shared units -/

/-- One unit moved from `c` to `d`. -/
def transfer [DecidableEq C] (c d : C) (o : C → Nat) : C → Nat :=
  fun x => if x = c then o c - 1 else if x = d then o d + 1 else o x

/-- Shared units: the eligible outcomes are closed under moving a unit from a condition beyond
that holds one into a condition of the family. -/
def Shared [DecidableEq C] (ds rest : List C) (eligible : (C → Nat) → Prop) : Prop :=
  ∀ o, eligible o → ∀ c d, c ∈ rest → d ∈ ds → 0 < o c → eligible (transfer c d o)

/-- A unit moved from outside a family into it exceeds on the family. -/
theorem transfer_exceeds [DecidableEq C] {c d : C} (out : ¬ c ∈ ds) (inside : d ∈ ds)
    (o : C → Nat) : Exceeds ds (transfer c d o) o :=
  have kept : ∀ x, x ∈ ds → transfer c d o x = if x = d then o d + 1 else o x :=
    fun _ listed => if_neg fun same => out (Eq.subst (motive := fun y => y ∈ ds) same listed)
  ⟨fun x listed => Nat.le_trans
      (match decEq x d with
        | .isTrue same => Nat.le_trans (Nat.le_succ (o x))
            (Nat.le_of_eq ((congrArg (o · + 1) same).trans (if_pos same).symm))
        | .isFalse other => Nat.le_of_eq (if_neg other).symm)
      (Nat.le_of_eq (kept x listed).symm),
   d, inside, Nat.lt_of_lt_of_le (Nat.lt_succ_self (o d))
      (Nat.le_of_eq (((if_pos (rfl : d = d) : (if d = d then o d + 1 else o d) = o d + 1).symm).trans
        (kept d inside).symm))⟩

/-- **Shared units give room.** With the conditions beyond apart from a family holding at least
one condition, shared units give room beyond. -/
theorem Shared.room [DecidableEq C] (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C} (inside : d ∈ ds)
    (shared : Shared ds rest eligible) : Room ds rest eligible :=
  fun o _ eligibleO _ c mem lower =>
    ⟨transfer c d o, shared o eligibleO c d mem inside (Nat.lt_of_le_of_lt (Nat.zero_le _) lower),
     transfer_exceeds (apart c mem) inside o⟩

/-- **With shared units, every optimum is at the least level beyond.** -/
theorem least_of_shared [DecidableEq C] (rising : Rising ds better)
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C} (inside : d ∈ ds)
    (shared : Shared ds rest eligible) {o : C → Nat} (optimum : Frontier eligible better o) :
    Least rest eligible o :=
  least_of_room rising (shared.room apart inside) optimum

end Optimum

/-! ## On a web: what an optimum breaks -/

namespace Web

variable {W : Web F C} {ds rest : List C} {eligible : (C → Nat) → Prop}
  {better : (C → Nat) → (C → Nat) → Prop} {dep : C → F} {t : Nat}

/-- **An optimum breaks exactly what any outcome breaks.** Where the levels after the step are an
optimum of an order rising with the family, with room beyond, and each condition beyond is
depended on at a need it meets, a dependence beyond is broken across the step exactly where some
eligible outcome leaves its condition below the need. -/
theorem optimum_broken_iff (rising : Optimum.Rising ds better)
    (room : Optimum.Room ds rest eligible) (optimum : Frontier eligible better (W.level (t + 1)))
    (met : W.MetOn dep rest t) {c : C} (mem : c ∈ rest) :
    W.Broken t (dep c) c ↔ ∃ o, eligible o ∧ o c < W.need t (dep c) c :=
  ⟨fun broken => ⟨W.level (t + 1), optimum.1, broken.2.2⟩,
   fun ⟨_, eligibleO, below⟩ => ⟨(met c mem).1, (met c mem).2,
     Nat.lt_of_le_of_lt (Optimum.least_of_room rising room optimum c mem _ eligibleO) below⟩⟩

/-- **The formations beyond end, unseen.** Under the conditions of `Web.optimum_broken_iff`, where
activity needs support, some eligible outcome leaves a condition beyond below the need of the
dependence on it, and that dependence is as it was across the step, the dependence is broken and
its formation is not active after the step; where every condition a member of a group couples
into is in the family, that formation is no member, and no member couples into the condition. -/
theorem optimum_ends_beyond {obs : F → C → Prop} {members : F → Prop}
    (rising : Optimum.Rising ds better) (room : Optimum.Room ds rest eligible)
    (optimum : Frontier eligible better (W.level (t + 1))) (met : W.MetOn dep rest t)
    (dependent : W.Dependent) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds)
    (listed : ∀ h c, members h → W.CoupledInto obs h c → c ∈ ds) {c : C} (mem : c ∈ rest)
    {o : C → Nat} (eligibleO : eligible o) (below : o c < W.need t (dep c) c)
    (fixed : W.requires (t + 1) (dep c) c ∧ W.need t (dep c) c ≤ W.need (t + 1) (dep c) c) :
    W.Broken t (dep c) c ∧ ¬ W.active (t + 1) (dep c) ∧ ¬ members (dep c) ∧
      ∀ h, members h → ¬ W.CoupledInto obs h c :=
  have broken := (optimum_broken_iff rising room optimum met mem).mpr ⟨o, eligibleO, below⟩
  have unseen : ∀ h, members h → ¬ W.CoupledInto obs h c :=
    fun h member couples => apart c mem (listed h c member couples)
  ⟨broken,
   fun active => Nat.not_le_of_gt broken.2.2
     (Nat.le_trans fixed.2 (dependent (t + 1) (dep c) active c fixed.1)),
   fun member => unseen (dep c) member (.inl ⟨t, broken.1⟩), unseen⟩

end Web

/-! ## Conservation: the family's rise is the beyond's fall with the loss -/

namespace Flow

variable {ds rest : List C} {t : Nat}

/-- **Raising the family is lowering the beyond with the loss, unit for unit.** Of two balanced
steps from equal totals of the family and the beyond, each gaining nothing on the whole, one
leaves the family's stock at most where the other does exactly where it leaves the beyond's stock
with the loss at least where the other does. -/
theorem Balances.family_le_iff {L L' : Flow F C} {W W' : Web F C} (balances : L.Balances W)
    (balances' : L'.Balances W') (gainless : L.GainlessOn (ds ++ rest) t)
    (gainless' : L'.GainlessOn (ds ++ rest) t)
    (start : W.stock ds t + W.stock rest t = W'.stock ds t + W'.stock rest t) :
    W.stock ds (t + 1) ≤ W'.stock ds (t + 1) ↔
      W'.stock rest (t + 1) + L'.lost (ds ++ rest) t ≤
        W.stock rest (t + 1) + L.lost (ds ++ rest) t :=
  have same : W.stock ds (t + 1) + (W.stock rest (t + 1) + L.lost (ds ++ rest) t) =
      W'.stock ds (t + 1) + (W'.stock rest (t + 1) + L'.lost (ds ++ rest) t) :=
    (Nat.add_assoc _ _ _).symm.trans ((balances.beyond_falls_exactly gainless).trans
      (start.trans ((balances'.beyond_falls_exactly gainless').symm.trans (Nat.add_assoc _ _ _))))
  have turned : W.stock rest (t + 1) + L.lost (ds ++ rest) t + W.stock ds (t + 1) =
      W'.stock rest (t + 1) + L'.lost (ds ++ rest) t + W'.stock ds (t + 1) :=
    (Nat.add_comm _ _).trans (same.trans (Nat.add_comm _ _))
  ⟨fun le => le_of_add_le_add_right (W.stock ds (t + 1))
      (Nat.le_trans (Nat.add_le_add_left le _) (Nat.le_of_eq turned.symm)),
   fun le => le_of_add_le_add_right (W'.stock rest (t + 1) + L'.lost (ds ++ rest) t)
      (Nat.le_trans (Nat.add_le_add_left le _) (Nat.le_of_eq same))⟩

/-- **The top of the family is the least beyond.** Among moves, each a balanced step from equal
totals gaining nothing on the whole, a move leaves the family's stock at least where every move
does exactly where it leaves the beyond's stock with the loss at most where every move does. -/
theorem top_iff_least {A : Type} {L : A → Flow F C} {W : A → Web F C}
    (balances : ∀ a, (L a).Balances (W a)) (gainless : ∀ a, (L a).GainlessOn (ds ++ rest) t)
    (start : ∀ a b, (W a).stock ds t + (W a).stock rest t = (W b).stock ds t + (W b).stock rest t)
    (a : A) :
    (∀ b, (W b).stock ds (t + 1) ≤ (W a).stock ds (t + 1)) ↔
      ∀ b, (W a).stock rest (t + 1) + (L a).lost (ds ++ rest) t ≤
        (W b).stock rest (t + 1) + (L b).lost (ds ++ rest) t :=
  ⟨fun top b => ((balances b).family_le_iff (balances a) (gainless b) (gainless a)
      (start b a)).mp (top b),
   fun least b => ((balances b).family_le_iff (balances a) (gainless b) (gainless a)
      (start b a)).mpr (least b)⟩

variable {L : Flow F C} {W : Web F C} {eligible : (C → Nat) → Prop}
  {better : (C → Nat) → (C → Nat) → Prop} {dep : C → F}

/-- **Keeping each dependence, the optimum takes exactly the slack.** Restrict the outcomes to
those keeping every dependence beyond at its need. Where the levels after a balanced step gaining
nothing on the whole are an optimum among them of an order rising with the family, with room among
them, each condition beyond depended on at a need it meets, and each need attained by one of them,
no dependence beyond is broken, and the family's stock after the step, with what the whole loses,
is its stock before with the slack. -/
theorem keeping_optimum_takes_slack (balances : L.Balances W)
    (gainless : L.GainlessOn (ds ++ rest) t) (met : W.MetOn dep rest t)
    (rising : Optimum.Rising ds better)
    (room : Optimum.Room ds rest fun o => eligible o ∧ ∀ c, c ∈ rest → W.need t (dep c) c ≤ o c)
    (attained : ∀ c, c ∈ rest → ∃ o, (eligible o ∧ ∀ c, c ∈ rest → W.need t (dep c) c ≤ o c) ∧
      o c ≤ W.need t (dep c) c)
    (optimum : Frontier (fun o => eligible o ∧ ∀ c, c ∈ rest → W.need t (dep c) c ≤ o c) better
      (W.level (t + 1))) :
    (∀ c, c ∈ rest → ¬ W.Broken t (dep c) c) ∧
      W.stock ds (t + 1) + L.lost (ds ++ rest) t = W.stock ds t + W.slack dep rest t :=
  have least := Optimum.least_of_room rising room optimum
  have atNeed : ∀ c, c ∈ rest → W.level (t + 1) c = W.need t (dep c) c :=
    fun c mem => match attained c mem with
      | ⟨_, keeping, atMost⟩ =>
        Nat.le_antisymm (Nat.le_trans (least c mem _ keeping) atMost) (optimum.1.2 c mem)
  have beyond : W.stock rest (t + 1) = total rest fun c => W.need t (dep c) c :=
    total_congr_on atNeed
  have exact : W.stock ds (t + 1) + L.lost (ds ++ rest) t + total rest
      (fun c => W.need t (dep c) c) =
      W.stock ds t + W.slack dep rest t + total rest fun c => W.need t (dep c) c :=
    (Nat.add_right_comm _ _ _).trans
      ((congrArg (W.stock ds (t + 1) + · + L.lost (ds ++ rest) t) beyond.symm).trans
        ((balances.beyond_falls_exactly gainless).trans
          ((congrArg (W.stock ds t + ·) (met.stock_eq.trans (Nat.add_comm _ _))).trans
            (Nat.add_assoc _ _ _).symm)))
  ⟨fun c mem broken => Nat.not_le_of_gt broken.2.2 (optimum.1.2 c mem),
   add_right_cancel _ exact⟩

end Flow

/-! ## Witnesses -/

namespace Optimum

namespace Drain

open Diversion DrawnBeyond

/-- Every split of three units between the source and the store. -/
def Split (o : Place → Nat) : Prop :=
  o .source + o .store = 3

/-- The store's stock order. -/
def storeOrder (o' o : Place → Nat) : Prop :=
  total [Place.store] o < total [Place.store] o'

/-- The source three at the start; after the step, everything in the store. -/
def drainedLevel (t : Nat) : Place → Nat
  | .source => Witnesses.profile [3] 0 t
  | .store => Witnesses.profile [0] 3 t

/-- The store's stock order rises with the store. -/
theorem storeOrder_rising : Rising [Place.store] storeOrder :=
  rising_total [Place.store]

/-- The splits are shared units between the source and the store. -/
theorem split_shared : Shared [Place.store] [Place.source] Split :=
  fun o split _ d beyond inside positive =>
    match mem_cons_cases beyond, mem_cons_cases inside with
    | .inr nothing, _ => nomatch nothing
    | _, .inr nothing => nomatch nothing
    | .inl atSource, .inl atStore =>
      Eq.subst (motive := fun x => Split (transfer x d o)) atSource.symm
        (Eq.subst (motive := fun y => Split (transfer Place.source y o)) atStore.symm
          (show o .source - 1 + (o .store + 1) = 3 from
            (Nat.add_left_comm _ _ _).trans
              ((congrArg (o .store + ·) (Naturals.sub_add_cancel
                (Eq.subst (motive := fun x => 0 < o x) atSource positive))).trans
                ((Nat.add_comm _ _).trans split))))

/-- Draining the source into the store is an optimum of the store's order among the splits. -/
theorem drained_optimum : Frontier Split storeOrder ((web drainedLevel).level 1) :=
  ⟨rfl, fun o split above => Nat.not_le_of_gt above
    (show o .store ≤ 3 from Nat.le_trans (Nat.le_add_left (o .store) (o .source)) (Nat.le_of_eq split))⟩

/-- The taker couples into the store alone, whatever the levels. -/
theorem taker_couples_store (level : Nat → Place → Nat) : ∀ h c, h = Formation.taker →
    (web level).CoupledInto gauge h c → c ∈ [Place.store] :=
  fun _ c same => Eq.subst
    (motive := fun x => (web level).CoupledInto gauge x c → c ∈ [Place.store]) same.symm
    fun couples => match couples with
      | .inl ⟨_, requires⟩ => False.elim (requires : False)
      | .inr observes => match c with
        | .source => False.elim (observes : False)
        | .store => .head []

/-- **The optimum drains the source and the dweller ends.** In the splits of three units, the
store's optimum leaves the source below the dweller's need: the dweller's dependence is broken,
the dweller is not active after the step, it is not the taker, and the taker does not couple into
the source; derived from `Web.optimum_ends_beyond`. -/
theorem drained_ends :
    (web drainedLevel).Broken 0 .dweller .source ∧ ¬ (web drainedLevel).active 1 .dweller ∧
      ¬ dwellerOn Place.source = Formation.taker ∧
      ¬ (web drainedLevel).CoupledInto gauge .taker .source :=
  match Web.optimum_ends_beyond (W := web drainedLevel) (ds := [Place.store])
      (rest := [Place.source]) (t := 0) (dep := dwellerOn) (obs := gauge)
      (members := fun h => h = Formation.taker) storeOrder_rising
      (split_shared.room source_apart (.head [])) drained_optimum
      (met_source drainedLevel 0 (Nat.le_succ 2)) (dependent drainedLevel) source_apart
      (taker_couples_store drainedLevel) (.head []) (o := (web drainedLevel).level 1) rfl
      (Nat.zero_lt_succ 1) (fixed_source drainedLevel 0 Place.source (.head [])) with
  | ⟨broken, ended, other, unseen⟩ => ⟨broken, ended, other, unseen .taker rfl⟩

/-- Counting the source after the store: the store's order first, the source among outcomes
alike on the store. -/
def countedAfter (o' o : Place → Nat) : Prop :=
  storeOrder o' o ∨ (o' .store = o .store ∧ o .source < o' .source)

/-- **Counting the beyond after the proxy changes nothing.** Every optimum among the splits of the
order counting the source after the store leaves the source empty. -/
theorem counted_after_drains {o : Place → Nat} (optimum : Frontier Split countedAfter o) :
    o .source = 0 :=
  Nat.le_zero.mp
    (least_of_shared (storeOrder_rising.mono fun _ _ above => .inl above) source_apart
      (.head []) split_shared optimum Place.source (.head []) ((web drainedLevel).level 1) rfl)

/-- Keeping the source at its need, the slack moved to the store. -/
def keptLevel : Place → Nat := WithinSlack.level 1

/-- One unit in each place. -/
def low : Place → Nat
  | .source => 1
  | .store => 1

/-- Two units in the store, none in the source. -/
def high : Place → Nat
  | .source => 0
  | .store => 2

/-- An order satisfied at a store of one: it ranks an outcome reaching one above one that does
not. -/
def satisficing (o' o : Place → Nat) : Prop :=
  1 ≤ o' .store ∧ o .store < 1

/-- **A satisficing order neither drives nor protects.** It is not rising with the store, and
among the splits both the outcome keeping the dweller's need and the outcome draining the source
are its optima. -/
theorem satisficing_either :
    ¬ Rising [Place.store] satisficing ∧ Frontier Split satisficing keptLevel ∧
      Frontier Split satisficing ((web drainedLevel).level 1) ∧
      (web DrawnBeyond.WithinSlack.level).need 0 .dweller .source ≤ keptLevel .source ∧
      (web drainedLevel).level 1 .source < (web drainedLevel).need 0 .dweller .source :=
  ⟨fun rising => Nat.lt_irrefl 1
      (rising low high
        ⟨fun _ mem => (match mem_cons_cases mem with
          | .inl same => Eq.subst (motive := fun y => low y ≤ high y) same.symm (Nat.le_succ 1)
          | .inr nothing => nomatch nothing),
         .store, .head [], Nat.lt_succ_self 1⟩).2,
   ⟨rfl, fun _ _ above => Nat.lt_irrefl 1 above.2⟩,
   ⟨rfl, fun _ _ above => Nat.not_lt_zero 2 (Nat.lt_of_succ_lt_succ above.2)⟩,
   Nat.le_refl 2, Nat.zero_lt_succ 1⟩

/-- Spilling the source: two outcomes, the source kept or spilled, the store empty in both. -/
def Spilling (o : Place → Nat) : Prop :=
  o = drainedLevel 0 ∨ o = fun _ => 0

/-- **Without room, an optimum need not be at the least level.** Where lowering the source frees
nothing for the store, keeping the source is an optimum of the store's order, and it is not at
the least level beyond. -/
theorem room_needed :
    Frontier Spilling storeOrder (drainedLevel 0) ∧
      ¬ Least [Place.source] Spilling (drainedLevel 0) :=
  ⟨⟨.inl rfl, fun _ spilling above => match spilling with
      | .inl same => Nat.lt_irrefl 0
          (Eq.subst (motive := fun x => total [Place.store] (drainedLevel 0) <
            total [Place.store] x) same above)
      | .inr same => Nat.lt_irrefl 0
          (Eq.subst (motive := fun x => total [Place.store] (drainedLevel 0) <
            total [Place.store] x) same above)⟩,
   fun least => Nat.not_succ_le_zero 2 (least Place.source (.head []) (fun _ => 0) (.inr rfl))⟩

/-- The outcomes keeping the dweller's need. -/
def Keeping (o : Place → Nat) : Prop :=
  Split o ∧ ∀ c, c ∈ [Place.source] →
    (web WithinSlack.level).need 0 (dwellerOn c) c ≤ o c

/-- Among the splits keeping the need, an outcome standing above another at the source is
exceeded on the store by one. -/
theorem keeping_room : Room [Place.store] [Place.source] Keeping :=
  fun o o' keeping keeping' c mem lower =>
    have atSource : c = Place.source := match mem_cons_cases mem with
      | .inl same => same
      | .inr nothing => nomatch nothing
    have above : 3 ≤ o .source := Nat.lt_of_le_of_lt (keeping'.2 .source (.head []))
      (Eq.subst (motive := fun x => o' x < o x) atSource lower)
    ⟨transfer .source .store o,
     ⟨split_shared o keeping.1 .source .store (.head []) (.head [])
        (Nat.lt_of_lt_of_le (Nat.zero_lt_succ 2) above),
      fun _ listed => Eq.subst (motive := fun y =>
          (web WithinSlack.level).need 0 (dwellerOn y) y ≤ transfer .source .store o y)
        (match mem_cons_cases listed with
          | .inl same => same.symm
          | .inr nothing => nomatch nothing)
        (Nat.sub_le_sub_right above 1)⟩,
     transfer_exceeds (source_apart .source (.head [])) (.head []) o⟩

/-- **Keeping the dweller's need, the optimum takes exactly the slack.** The keeping outcome of
`DrawnBeyond.WithinSlack` is the store's optimum among the splits keeping the need: no dependence
on the source breaks, and the store rises by exactly the slack; derived from
`Flow.keeping_optimum_takes_slack`. -/
theorem kept_takes_slack :
    Frontier Keeping storeOrder ((web WithinSlack.level).level 1) ∧
      (∀ c, c ∈ [Place.source] → ¬ (web WithinSlack.level).Broken 0 (dwellerOn c) c) ∧
      (web WithinSlack.level).stock [Place.store] 1 + diverting.lost ([Place.store] ++ [Place.source]) 0 =
        (web WithinSlack.level).stock [Place.store] 0 +
          (web WithinSlack.level).slack dwellerOn [Place.source] 0 :=
  have optimum : Frontier Keeping storeOrder ((web WithinSlack.level).level 1) :=
    ⟨⟨rfl, fun _ mem => match mem_cons_cases mem with
        | .inl same => Eq.subst (motive := fun y =>
            (web WithinSlack.level).need 0 (dwellerOn y) y ≤ WithinSlack.level 1 y)
            same.symm (Nat.le_refl 2)
        | .inr nothing => nomatch nothing⟩,
     fun o keeping above => Nat.not_le_of_gt above
       (show o .store ≤ 1 from le_of_add_le_add_right 2
         (show o .store + 2 ≤ 1 + 2 from Nat.le_trans
           (Nat.add_le_add_left (keeping.2 .source (.head [])) (o .store))
           (Nat.le_of_eq ((Nat.add_comm _ _).trans keeping.1))))⟩
  ⟨optimum, Flow.keeping_optimum_takes_slack (eligible := Split) WithinSlack.balances
     (whole_gainless diverting 0 (Nat.le_refl 1) (Nat.le_refl 0))
     (met_source WithinSlack.level 0 (Nat.le_succ 2)) storeOrder_rising keeping_room
     (fun _ mem => match mem_cons_cases mem with
       | .inl same => ⟨(web WithinSlack.level).level 1, optimum.1,
           Eq.subst (motive := fun y => (web WithinSlack.level).level 1 y ≤
             (web WithinSlack.level).need 0 (dwellerOn y) y) same.symm (Nat.le_refl 2)⟩
       | .inr nothing => nomatch nothing)
     optimum⟩

end Drain

end Optimum

end Becoming
