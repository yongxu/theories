import Becoming.Novelty

/-!
# Gain: where novelty's gain comes from

Ren, 15 October 2026: “please make best of your judgement, and push the frontier of
completeness”. `Becoming.Novelty` showed on the levels alone that only what gains is new: a family
new at every step exceeds every bound. This module says where the gain comes from, with no premise.
With the rest of the whole counted as a relatum (`Flow.withImbalance`), nothing rises by itself.

* **Every rise is given.** Across a step at which a family's stock rises, some relatum gives the
  family more than it takes from it (`Flow.rise_netGiver`): a formation taking part, or the rest
  (`Flow.rise_given`). The giver is found by checking each relatum taking part; nothing infinite is
  decided. A rise over a stretch is given at some step of it (`Flow.rise_given_between`). The rest
  gives net exactly where the levels rose beyond the formations' net exchange
  (`Flow.rest_netGiver_iff`), and where the flow balances on the family it gives nothing net
  (`Flow.BalancesOn.rest_not_netGiver`).
* **Under the first law: from the rest, or across the boundary.** Where nothing comes from
  nothing (`Flow.Gainless`), across a step at which a family without repetition rises, the rest
  gives it more than it takes, or the family is open there: not closed, some formation taking part
  exchanging beyond it (`Flow.rise_from_rest_or_open`). A finite whole, every condition listed, is
  closed, so every rise of it is the rest's (`Flow.whole_rise_from_rest`). With the rest giving it
  nothing net, it stays within its stock (`Flow.whole_bounded_of_rest_idle`), returns and forgets
  (`Flow.whole_recurs_of_rest_idle`), and is not new at every step (`Flow.whole_not_new_of_rest_idle`).
* **Novelty needs gain.** A family new at more consecutive steps than it has configurations within
  its stock rises within that stretch (`Web.rises_within_of_new`); one new at every step rises at
  arbitrarily late steps (`Web.rises_late_of_new`). The same holds along first visits, steps at
  which the configuration is one the family has not had since `T` (`Web.NewAt`,
  `Web.exceeds_of_firsts`, `Web.rises_late_of_firsts`): first visits need not be consecutive. Both
  are cases of the list form of `Becoming.Novelty` (`Web.exceeds_of_distinct_configs`,
  `Web.unbounded_of_distinct_configs`).
  Under the first law each such rise is the rest's or crosses the family's boundary
  (`Flow.new_from_rest_or_open`), and so for every family without repetition holding its members
  (`Web.new_of_sub`, `Flow.new_beyond_every`): no finite family closes over endless novelty.
* **What newly forms needs gain.** Where what a formation requires, and how much, stays fixed and
  lies within a family (`Web.RequiresWithin`), whether the family's levels support it depends on
  the configuration alone (`Web.supported_of_config`). So a step at which it is first supported is a
  first visit (`Web.newAt_of_first`), and formations first supported at steps without end need the
  family to rise at arbitrarily late steps (`Web.rises_late_of_newly_supported`). Under the first
  law each such rise is the rest's or crosses the family's boundary
  (`Flow.newly_supported_from_rest_or_open`).
* **Novelty from the rest.** Counting on, new at every step (`Web.counting_new`), with nothing taking
  part, is given one unit by the rest at every step (`Flow.counting_given_by_rest`), while nothing
  comes from nothing there (`Flow.empty_gainless`).

So endless novelty of a finite family, and endless new formation where what forms requires a fixed
amount within it, is exchange beyond that family at arbitrarily late steps: through its boundary,
or from the rest. For a finite whole there is no boundary to cross, and with the rest idle the
whole recurs: unceasing arising within a bounded whole is return, not novelty without end.

**Readings (the AI's, adopted on Ren's delegation of 15 October 2026, DELEGATED-CHOICES D7, D27).**
“Gain from beyond the part” is read as these two ways in, the boundary and the rest. The rest counts
what the listed relata do not, so a finite whole new without end is one whose listing leaves out
what gives to it. `Becoming.MoveFormation` states the counterpart for moves: moves formed by a whole,
rest or part that a list holds repeat within the list's length.

What is not derived: whether an actual part is open, which relatum the rest is in an actual
unfolding, and whether its exchange is without end. The representation commits to discrete steps
and natural amounts. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {F C : Type}

/-- Along steps in increasing order, the `k`-th step is at least `k`. -/
theorem le_of_increasing {at_ : Nat → Nat} (increasing : ∀ i j, i < j → at_ i < at_ j) :
    ∀ k, k ≤ at_ k
  | 0 => Nat.zero_le _
  | k + 1 => Nat.succ_le_of_lt
      (Nat.lt_of_le_of_lt (le_of_increasing increasing k) (increasing k (k + 1) (Nat.lt_succ_self k)))

/-- Where two maps of one list are equal, the maps agree at each of its members. -/
theorem map_eq_at {α : Type} {f g : α → Nat} {a : α} :
    ∀ {l : List α}, l.map f = l.map g → a ∈ l → f a = g a
  | _ :: _, same, .head _ => (List.cons.inj same).1
  | _ :: _, same, .tail _ mem => map_eq_at (List.cons.inj same).2 mem

/-- Two lists mapped from one list are equal where the maps agree on its members. -/
theorem map_eq_on {α : Type} {f g : α → Nat} :
    ∀ {l : List α}, (∀ a, a ∈ l → f a = g a) → l.map f = l.map g
  | [], _ => rfl
  | a :: l, on => show f a :: l.map f = g a :: l.map g from
      congr (congrArg List.cons (on a (.head l))) (map_eq_on fun b mem => on b (.tail a mem))

/-- A member of a list of options headed by `none` that is `some a` lies in the tail. -/
theorem some_mem_tail {α : Type} {a : α} {l : List (Option α)} : some a ∈ none :: l → some a ∈ l
  | .tail _ mem => mem

namespace Web

variable {W : Web F C} {cs : List C}

/-! ## Novelty rises -/

/-- **New for long enough, a family rises.** Where the configurations of a family at the steps
`T, …, T + N` are all different, `N` counting the configurations of its members within its stock at
`T`, its stock rises across some step of that stretch. -/
theorem rises_within_of_new {T : Nat}
    (new : ∀ i j, i < j → j ≤ (configurationsWithin cs.length (W.stock cs T)).length →
      W.config cs (T + i) ≠ W.config cs (T + j)) :
    ∃ t, T ≤ t ∧ t < T + (configurationsWithin cs.length (W.stock cs T)).length ∧
      W.stock cs t < W.stock cs (t + 1) :=
  match exceeds_of_new (W := W) new with
  | ⟨n, le, over⟩ => match rises_between (q := W.stock cs) (Nat.le_add_right T n) over with
    | ⟨t, from_, before, up⟩ => ⟨t, from_, Nat.lt_of_lt_of_le before (Nat.add_le_add_left le T), up⟩

/-- **New at every step, a family rises at arbitrarily late steps.** -/
theorem rises_late_of_new {T : Nat}
    (new : ∀ i j, i < j → W.config cs (T + i) ≠ W.config cs (T + j)) (M : Nat) :
    ∃ t, M ≤ t ∧ W.stock cs t < W.stock cs (t + 1) :=
  match rises_within_of_new (W := W) (cs := cs) (T := T + M) (fun i j lt _ same =>
      new (M + i) (M + j) (Nat.add_lt_add_left lt M)
        ((congrArg (W.config cs) (Nat.add_assoc T M i)).symm.trans
          (same.trans (congrArg (W.config cs) (Nat.add_assoc T M j))))) with
  | ⟨t, from_, _, up⟩ => ⟨t, Nat.le_trans (Nat.le_add_left M T) from_, up⟩

/-- A family's configuration is fixed by the configuration of any family holding its members. -/
theorem config_eq_of_sub {cs ds : List C} (sub : ∀ c, c ∈ cs → c ∈ ds) {s t : Nat}
    (same : W.config ds s = W.config ds t) : W.config cs s = W.config cs t :=
  map_eq_on fun c mem => map_eq_at same (sub c mem)

/-- So a family holding a family new at every step is new at every step. -/
theorem new_of_sub {cs ds : List C} (sub : ∀ c, c ∈ cs → c ∈ ds) {T : Nat}
    (new : ∀ i j, i < j → W.config cs (T + i) ≠ W.config cs (T + j)) :
    ∀ i j, i < j → W.config ds (T + i) ≠ W.config ds (T + j) :=
  fun i j lt same => new i j lt (config_eq_of_sub sub same)

/-! ## First visits -/

/-- At `t` the family's configuration is one it has not had at any step from `T` before `t`: a
first visit. -/
def NewAt (W : Web F C) (cs : List C) (T t : Nat) : Prop :=
  ∀ s, T ≤ s → s < t → W.config cs s ≠ W.config cs t

/-- **First visits gain, with a bounded wait.** Along steps from `T` in increasing order, each a
first visit, the stock exceeds `K` at one of the first `N + 1` of them, `N` counting the
configurations of the family's members totalling at most `K`: the case of
`exceeds_of_distinct_configs` for the list of those steps, whose configurations the first visits
keep pairwise distinct. `exceeds_of_new` is the case of consecutive steps. -/
theorem exceeds_of_firsts {T K : Nat} {at_ : Nat → Nat}
    (increasing : ∀ i j, i < j → at_ i < at_ j) (from_ : ∀ n, T ≤ at_ n)
    (firsts : ∀ n, W.NewAt cs T (at_ n)) :
    ∃ n, n ≤ (configurationsWithin cs.length K).length ∧ K < W.stock cs (at_ n) :=
  match exceeds_of_distinct_configs (K := K)
      (distinct_configs_of_apart (at_ := at_)
        (ns := steps 0 ((configurationsWithin cs.length K).length + 1)) (steps_distinct 0 _)
        fun i j _ _ lt => firsts j (at_ i) (from_ i) (increasing i j lt))
      (Eq.subst (motive := fun n => (configurationsWithin cs.length K).length < n)
        ((steps_length 0 _).symm.trans (length_map at_ _).symm) (Nat.lt_succ_self _)) with
  | ⟨_, mem, over⟩ => match preimage_of_mem_map mem with
    | ⟨n, listed, same⟩ =>
      ⟨n, Nat.le_of_lt_succ (Nat.lt_of_lt_of_le (steps_within listed) (Nat.le_of_eq (Nat.zero_add _))),
       Eq.subst (motive := fun x => K < W.stock cs x) same.symm over⟩

/-- **First visits without end rise at arbitrarily late steps**: from every step on, the first
visits at the later indices are later steps with pairwise distinct configurations, so the stock
exceeds every bound at arbitrarily late steps (`unbounded_of_distinct_configs`) and passes its
value at `M`. -/
theorem rises_late_of_firsts {T : Nat} {at_ : Nat → Nat}
    (increasing : ∀ i j, i < j → at_ i < at_ j) (from_ : ∀ n, T ≤ at_ n)
    (firsts : ∀ n, W.NewAt cs T (at_ n)) (M : Nat) :
    ∃ t, M ≤ t ∧ W.stock cs t < W.stock cs (t + 1) :=
  match unbounded_of_distinct_configs (W := W) (cs := cs)
      (fun M' n => ⟨(steps M' n).map at_, (length_map at_ _).trans (steps_length M' n),
        fun _ mem => match preimage_of_mem_map mem with
          | ⟨i, listed, same⟩ => Eq.subst (motive := fun x => M' ≤ x) same
              (Nat.le_trans (steps_mem listed) (le_of_increasing increasing i)),
        distinct_configs_of_apart (steps_distinct M' n)
          fun i j _ _ lt => firsts j (at_ i) (from_ i) (increasing i j lt)⟩)
      (W.stock cs M) M with
  | ⟨_, later, over⟩ => match rises_between (q := W.stock cs) later over with
    | ⟨t, from_, _, up⟩ => ⟨t, from_, up⟩

/-! ## What newly forms -/

/-- What `f` requires at any step it requires at every step, with the same need, and only of
members of the family. -/
def RequiresWithin (W : Web F C) (cs : List C) (f : F) : Prop :=
  ∀ s t c, W.requires s f c → W.requires t f c ∧ W.need s f c = W.need t f c ∧ c ∈ cs

/-- **What can form depends on the configuration.** Where what `f` requires stays fixed within
the family, the family's levels support `f` at a step where they support it at another step at the
same configuration. -/
theorem supported_of_config {f : F} {s t : Nat} (req : W.RequiresWithin cs f)
    (same : W.config cs s = W.config cs t) (supported : W.Supported t f) : W.Supported s f :=
  fun c requires => match req s t c requires with
    | ⟨requires_t, need, mem⟩ => Nat.le_trans (Nat.le_of_eq need)
        (Nat.le_trans (supported c requires_t) (Nat.le_of_eq (map_eq_at same mem).symm))

/-- `f` is supported at `t` and at no step from `T` before `t`: it can first form there. -/
def FirstSupported (W : Web F C) (T t : Nat) (f : F) : Prop :=
  W.Supported t f ∧ ∀ s, T ≤ s → s < t → ¬ W.Supported s f

/-- **What newly can form is a first visit.** Where what `f` requires stays fixed within the
family, a step at which `f` is first supported from `T` is a first visit of the family's
configuration. -/
theorem newAt_of_first {f : F} {T t : Nat} (req : W.RequiresWithin cs f)
    (first : W.FirstSupported T t f) : W.NewAt cs T t :=
  fun s from_ before same => first.2 s from_ before (supported_of_config req same first.1)

/-- **What newly forms without end needs the family to rise without end.** Where formations first
supported at steps from `T` in increasing order each require, fixed, only members of the family,
the family's stock rises at arbitrarily late steps. -/
theorem rises_late_of_newly_supported {T : Nat} {at_ : Nat → Nat} {f : Nat → F}
    (increasing : ∀ i j, i < j → at_ i < at_ j) (from_ : ∀ n, T ≤ at_ n)
    (req : ∀ n, W.RequiresWithin cs (f n)) (first : ∀ n, W.FirstSupported T (at_ n) (f n))
    (M : Nat) : ∃ t, M ≤ t ∧ W.stock cs t < W.stock cs (t + 1) :=
  rises_late_of_firsts increasing from_ (fun n => newAt_of_first (req n) (first n)) M

end Web

namespace Flow

variable (L : Flow F C)

/-! ## Who gives -/

/-- Across the step from `t`, `f` takes part and gives the family more than it takes from it. -/
def NetGiver (cs : List C) (t : Nat) (f : F) : Prop :=
  f ∈ L.present t ∧ total cs (L.take t f) < total cs (L.give t f)

variable {L} {W : Web F C} {cs : List C}

/-- **Every rise is given.** Across a step at which a family's stock rises, some relatum of the
flow with the rest counted gives the family more than it takes from it. No premise: with the rest
counted every flow balances (`withImbalance_balances`), and where no relatum gives net a balanced
family does not rise (`Balances.nonrising`). -/
theorem rise_netGiver {t : Nat} (rise : W.stock cs t < W.stock cs (t + 1)) :
    ∃ f, (L.withImbalance W).NetGiver cs t f :=
  match search (p := fun f => total cs ((L.withImbalance W).give t f) ≤
      total cs ((L.withImbalance W).take t f)) ((L.withImbalance W).present t) with
  | .inl ⟨f, present, over⟩ => ⟨f, present, Nat.gt_of_not_le over⟩
  | .inr gainless =>
    absurd ((withImbalance_balances (L := L) (W := W)).nonrising (cs := cs) (t := t) gainless)
      (Nat.not_le_of_gt rise)

/-- A relatum of the flow with the rest counted that gives net is the rest, or one of the flow's
formations giving net. -/
theorem netGiver_cases {t : Nat} :
    ∀ {f : Option F}, (L.withImbalance W).NetGiver cs t f →
      (L.withImbalance W).NetGiver cs t none ∨ ∃ g, L.NetGiver cs t g
  | none, gives => .inl gives
  | some g, ⟨present, over⟩ => .inr ⟨g, mem_of_some_mem (some_mem_tail present), over⟩

/-- The rest gives a family more than it takes exactly where, summed over the family, the
levels rose across the step beyond what the flow's formations gave net by more than they fell
beyond what they took net. -/
theorem rest_netGiver_iff {t : Nat} :
    (L.withImbalance W).NetGiver cs t none ↔
      total cs (fun c => W.level t c + L.given t c - (W.level (t + 1) c + L.taken t c)) <
        total cs (fun c => W.level (t + 1) c + L.taken t c - (W.level t c + L.given t c)) :=
  ⟨fun gives => gives.2, fun over => ⟨.head _, over⟩⟩

/-- Where the flow balances on the family across the step, the rest gives it nothing net. -/
theorem BalancesOn.rest_not_netGiver {t : Nat} (balances : L.BalancesOn W cs t) :
    ¬ (L.withImbalance W).NetGiver cs t none :=
  fun ⟨_, over⟩ => Nat.not_lt_zero _ (Nat.lt_of_lt_of_le over (Nat.le_of_eq
    (total_eq_zero fun c mem => ((balancesOn_iff_idle.mp balances) c mem).1)))

/-- **Every rise is given, by the rest or by a formation.** -/
theorem rise_given {t : Nat} (rise : W.stock cs t < W.stock cs (t + 1)) :
    (L.withImbalance W).NetGiver cs t none ∨ ∃ g, L.NetGiver cs t g :=
  match rise_netGiver (L := L) rise with
  | ⟨_, gives⟩ => netGiver_cases gives

/-- A rise over a stretch is given at some step of it. -/
theorem rise_given_between {T u : Nat} (le : T ≤ u) (rise : W.stock cs T < W.stock cs u) :
    ∃ t f, T ≤ t ∧ t < u ∧ (L.withImbalance W).NetGiver cs t f :=
  match rises_between (q := W.stock cs) le rise with
  | ⟨t, from_, before, up⟩ => match rise_netGiver (L := L) up with
    | ⟨f, gives⟩ => ⟨t, f, from_, before, gives⟩

/-! ## Under the first law -/

/-- **Under the first law, from the rest or across the boundary.** Where nothing comes from
nothing, across a step at which a family without repetition rises, the rest gives it more than it
takes, or the family is not closed there: some formation taking part exchanges beyond it. -/
theorem rise_from_rest_or_open (gainless : L.Gainless) (distinct : Distinct cs) {t : Nat}
    (rise : W.stock cs t < W.stock cs (t + 1)) :
    (L.withImbalance W).NetGiver cs t none ∨ ¬ L.ClosedAt cs t :=
  match rise_given (L := L) rise with
  | .inl rest => .inl rest
  | .inr ⟨g, present, over⟩ => .inr fun closed =>
    Nat.not_le_of_gt over (gainless cs t distinct closed g present)

/-- **A finite whole gains only from the rest.** Where a list holds every condition without
repetition and nothing comes from nothing, across every step at which the whole's stock rises, the
rest gives it more than it takes. -/
theorem whole_rise_from_rest {all : List C} (every : ∀ c, c ∈ all) (distinct : Distinct all)
    (gainless : L.Gainless) {t : Nat} (rise : W.stock all t < W.stock all (t + 1)) :
    (L.withImbalance W).NetGiver all t none :=
  match rise_from_rest_or_open gainless distinct rise with
  | .inl rest => rest
  | .inr open_ => (open_ fun _ _ c out => absurd (every c) out).elim

/-- With the rest giving it nothing net from `T` on, a finite whole under the first law stays
within its stock at `T`. -/
theorem whole_bounded_of_rest_idle {all : List C} (every : ∀ c, c ∈ all) (distinct : Distinct all)
    (gainless : L.Gainless) {T : Nat}
    (idle : ∀ t, T ≤ t → ¬ (L.withImbalance W).NetGiver all t none) :
    ∀ t, T ≤ t → W.stock all t ≤ W.stock all T :=
  fun _ later => nonrising_between (q := W.stock all)
    (fun t from_ => Nat.ge_of_not_lt fun rise =>
      idle t from_ (whole_rise_from_rest every distinct gainless rise))
    (Nat.le_refl T) later

/-- **A bounded whole returns and forgets.** In a finite whole under the first law, with the rest
giving it nothing net from `T` on, from every step on its configuration takes one value at two
steps, and where the flow exchanges with it at arbitrarily late steps its configuration does not
carry the count of its exchanges. -/
theorem whole_recurs_of_rest_idle {all : List C} (every : ∀ c, c ∈ all) (distinct : Distinct all)
    (gainless : L.Gainless) {T : Nat}
    (idle : ∀ t, T ≤ t → ¬ (L.withImbalance W).NetGiver all t none) :
    (∀ M, ∃ i j, M ≤ i ∧ i < j ∧ W.config all (T + i) = W.config all (T + j)) ∧
      ((∀ M, ∃ t, M ≤ t ∧ 0 < L.exchanges all t) → ¬ L.CarriesHistory W all T) :=
  ⟨Web.revisits_of_bounded (whole_bounded_of_rest_idle every distinct gainless idle),
   fun exchanging => uncarried_of_bounded
     (whole_bounded_of_rest_idle every distinct gainless idle) exchanging⟩

/-- So it is not new at every step: unceasing arising within a bounded whole is return. -/
theorem whole_not_new_of_rest_idle {all : List C} (every : ∀ c, c ∈ all) (distinct : Distinct all)
    (gainless : L.Gainless) {T : Nat}
    (idle : ∀ t, T ≤ t → ¬ (L.withImbalance W).NetGiver all t none) :
    ¬ ∀ i j, i < j → W.config all (T + i) ≠ W.config all (T + j) :=
  fun new => match (whole_recurs_of_rest_idle every distinct gainless idle).1 0 with
    | ⟨i, j, _, lt, same⟩ => new i j lt same

/-- **Novelty is given from beyond the family.** Under the first law, a family without repetition
new at every step from `T` is given more than it takes, by the rest or across its boundary, at
arbitrarily late steps. -/
theorem new_from_rest_or_open (gainless : L.Gainless) (distinct : Distinct cs) {T : Nat}
    (new : ∀ i j, i < j → W.config cs (T + i) ≠ W.config cs (T + j)) (M : Nat) :
    ∃ t, M ≤ t ∧ ((L.withImbalance W).NetGiver cs t none ∨ ¬ L.ClosedAt cs t) :=
  match Web.rises_late_of_new new M with
  | ⟨t, later, up⟩ => ⟨t, later, rise_from_rest_or_open gainless distinct up⟩

/-- **Endless novelty is exchange beyond every finite family holding it.** Under the first law,
where a family is new at every step from `T`, every family without repetition holding its members
is given more than it takes, by the rest or across its boundary, at arbitrarily late steps. -/
theorem new_beyond_every (gainless : L.Gainless) {T : Nat}
    (new : ∀ i j, i < j → W.config cs (T + i) ≠ W.config cs (T + j)) :
    ∀ ds, Distinct ds → (∀ c, c ∈ cs → c ∈ ds) → ∀ M, ∃ t, M ≤ t ∧
      ((L.withImbalance W).NetGiver ds t none ∨ ¬ L.ClosedAt ds t) :=
  fun _ distinct sub M => new_from_rest_or_open gainless distinct (Web.new_of_sub sub new) M

/-- **What newly forms without end is fed from beyond the family.** Under the first law, where
formations first supported at steps from `T` in increasing order each require, fixed, only members
of a family without repetition, the family is given more than it takes, by the rest or across its
boundary, at arbitrarily late steps. -/
theorem newly_supported_from_rest_or_open (gainless : L.Gainless) (distinct : Distinct cs)
    {T : Nat} {at_ : Nat → Nat} {f : Nat → F}
    (increasing : ∀ i j, i < j → at_ i < at_ j) (from_ : ∀ n, T ≤ at_ n)
    (req : ∀ n, W.RequiresWithin cs (f n)) (first : ∀ n, W.FirstSupported T (at_ n) (f n))
    (M : Nat) :
    ∃ t, M ≤ t ∧ ((L.withImbalance W).NetGiver cs t none ∨ ¬ L.ClosedAt cs t) :=
  match Web.rises_late_of_newly_supported increasing from_ req first M with
  | ⟨t, later, up⟩ => ⟨t, later, rise_from_rest_or_open gainless distinct up⟩

/-! ## Novelty from the rest -/

/-- Nothing takes part. -/
def empty : Flow F C := ⟨fun _ => [], fun _ _ _ => 0, fun _ _ _ => 0⟩

/-- Nothing comes from nothing where nothing takes part. -/
theorem empty_gainless : (empty : Flow F C).Gainless :=
  fun _ _ _ _ _ absent => nomatch absent

/-- **Counting on is given by the rest.** In `Web.counting`, whose level is the step, with
nothing taking part, the rest gives one unit at every step: the novelty of counting on
(`Web.counting_new`) comes from the rest, the one way in that a finite whole has. -/
theorem counting_given_by_rest (t : Nat) :
    ((empty : Flow Unit Unit).withImbalance Web.counting).NetGiver [()] t none :=
  ⟨.head _, show t + 0 - (t + 1 + 0) + 0 < t + 1 + 0 - (t + 0) + 0 from
    Nat.lt_of_le_of_lt (Nat.le_of_eq (congrArg (· + 0) (sub_eq_zero_of_le (Nat.le_succ t))))
      (Nat.lt_of_lt_of_le (Nat.lt_succ_self 0)
        (Nat.le_of_eq (congrArg (· + 0) (succ_sub_self t)).symm))⟩

end Flow

end Becoming
