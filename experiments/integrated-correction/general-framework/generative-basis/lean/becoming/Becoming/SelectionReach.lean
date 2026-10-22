import Becoming.Selection
import Becoming.Entropy

/-!
# Selection reach: raising what couples in, from nothing new, draws from beyond it

Chapter §8.2 listed as open "the general form of favouring what reaches beyond": when a part
raising what couples in must reach beyond the coupling closure. `Becoming.Selection` showed it in
one world (`Diversion`): a flow taking from a source a dweller depends on, to raise a store the
taker observes, is selected over the restrained flow by a selection through the taker's coupling,
and that selection treats it alike with a supply from nowhere. This module states the law for any
flow. Ren, 18 October 2026: "please see what else is there to do - keep pushing the frontier till
finishing". No premise enters beyond what each theorem names.

* **A rise is given more than it is taken.** In a balanced flow, where a family's stock rises
  across a step, some formation taking part gives the family more than it takes from it
  (`Flow.Balances.gives_more_of_rise`).
* **From nothing new, it is drawn from beyond.** Where a family without repetition containing it
  gains nothing across the step (`Flow.GainlessOn`, nothing from nothing, of `Becoming.Entropy`),
  that formation takes from the containing family more than from the risen one
  (`Flow.Balances.rise_draws_beyond`); with equality of conditions decided, it takes from a
  condition of the containing family outside the risen one (`Flow.Balances.rise_takes_beyond`).
  The rise is paid from beyond in full: the stock after the step is at most the stock before plus
  what is taken from the containing family beyond the risen one (`Flow.Balances.rise_paid_from_beyond`).
  Under `Flow.Gainless` with the step enclosed around the family, this holds wherever the stock
  rises (`Flow.Gainless.rise_takes_beyond`).
* **Selection favours reaching beyond.** Where a family lists every condition a group couples
  into, every selection that holds of a flow only where that family's stock rises across a step
  holds only of flows in which, across that step, a formation raising the family takes from a
  condition no member of the group couples into (`Flow.favours_reaching_beyond`). Raising an
  observed family's stock is itself a selection through the observer's coupling
  (`Web.raises_selectsThrough`).
* **Graded by the inflow.** A family's inflow across a step (`Flow.inflow`: what each formation
  taking part gives it beyond what it takes from it) is zero exactly where it gains nothing. Without
  that premise, where the family's stock rises by more than the containing family's inflow, a
  formation taking part gives it more than it takes from it and takes from beyond
  (`Flow.Balances.rise_draws_beyond_inflow`, `Flow.Balances.rise_takes_beyond_inflow`); the rise past
  the inflow is paid from beyond in full (`Flow.Balances.rise_paid_from_beyond_inflow`); and every
  selection holding only where the family rises past the inflow favours reaching beyond
  (`Flow.favours_reaching_beyond_inflow`). The gainless laws above are their case of no inflow. The
  bound is exact: the supplying flow raises the store by exactly its inflow, taking nothing
  (`Diversion.supplying_rises_by_inflow`).
* **The premise binds.** `Diversion` is an instance: its diverting flow gains nothing on the source
  and the store, so the rise of the store has the taker taking from the source, which it does not
  couple into (`Diversion.draws_beyond`, derived from the general law). Its supplying flow raises
  the store with nothing taken (`Diversion.supplying_raises_untaken`): without "nothing from
  nothing" a rise need not reach beyond.

**Reading (the AI's).** Where nothing comes from nothing, whatever raises what a selector couples
into is paid from somewhere, and a selection rewarding the rise rewards drawing on what lies
beyond the selector's coupling, which the selection does not see (`Becoming.SelectionGap`). The
favour is structural: it holds for every such selection and every gainless flow, not by any
intent of the selected. It does not say that drawing from beyond is wrong, or that any formation
there is harmed: what is drawn may be replenished.

What is not derived: that the flow gains nothing, or how much its inflow is (a hypothesis wherever
it enters; graded by the inflow the laws hold whatever it is, and say only what a rise past it
draws); that the family lists everything coupled into (a hypothesis of `Flow.favours_reaching_beyond`); how much more
than the rise is drawn beyond, which dissipation would add; whether what is drawn beyond is depended
on. The representation commits to discrete steps and natural
amounts. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

section Search

variable {α : Type}

/-- With equality decided, a total over a list without repetition above the total over another
list has a member outside the other where the quantity is positive. -/
theorem exists_outside_of_total_lt [DecidableEq α] {q : α → Nat} {l m : List α}
    (distinct : Distinct l) (lt : total m q < total l q) : ∃ a, a ∈ l ∧ ¬ a ∈ m ∧ 0 < q a :=
  match @search _ (fun a => a ∈ m ∨ q a = 0)
      (fun a => @instDecidableOr _ _ (decideMem a m) (Nat.decEq (q a) 0)) l with
  | .inl ⟨a, mem, lacks⟩ =>
    ⟨a, mem, fun inside => lacks (.inl inside), Nat.pos_of_ne_zero fun zero => lacks (.inr zero)⟩
  | .inr all => absurd (total_le_of_support distinct fun a mem pos => match all a mem with
      | .inl inside => inside
      | .inr zero => absurd pos (Nat.not_lt_of_le (Nat.le_of_eq zero))) (Nat.not_le_of_gt lt)

end Search

variable {F C : Type}

namespace Flow

variable {L : Flow F C} {W : Web F C} {ds es : List C} {t : Nat}

/-- **A rise is given more than it is taken.** In a balanced flow, where a family's stock rises
across a step, some formation taking part gives the family more than it takes from it. -/
theorem Balances.gives_more_of_rise (balances : L.Balances W)
    (rises : W.stock ds t < W.stock ds (t + 1)) :
    ∃ f, f ∈ L.present t ∧ total ds (L.take t f) < total ds (L.give t f) :=
  have up : L.uptake ds t < L.replenishment ds t := Nat.lt_of_not_le fun le =>
    Nat.lt_irrefl (W.stock ds (t + 1) + L.uptake ds t) (Nat.lt_of_le_of_lt
      (Nat.le_trans (Nat.le_of_eq (balances.over ds t)) (Nat.add_le_add_left le _))
      (Nat.add_lt_add_right rises _))
  exists_lt_of_total_lt (as := L.present t)
    (Nat.lt_of_le_of_lt (Nat.le_of_eq (total_swap (fun f c => L.take t f c) ds (L.present t)))
      (Nat.lt_of_lt_of_le up
        (Nat.le_of_eq (total_swap (fun c f => L.give t f c) (L.present t) ds))))

/-- **A rise past the inflow is drawn from beyond.** In a balanced flow, where a family without
repetition rises across a step by more than the inflow of a family containing it, some formation
taking part gives the risen family more than it takes from it by more than it gives the containing
family beyond what it takes from it, and so takes from the containing family more than from the
risen one. -/
theorem Balances.rise_draws_beyond_inflow (balances : L.Balances W) (distinct : Distinct ds)
    (sub : ∀ c, c ∈ ds → c ∈ es) (rises : W.stock ds t + L.inflow es t < W.stock ds (t + 1)) :
    ∃ f, f ∈ L.present t ∧
      excess (total es (L.give t f)) (total es (L.take t f)) <
        excess (total ds (L.give t f)) (total ds (L.take t f)) ∧
      total ds (L.take t f) < total ds (L.give t f) ∧
      total ds (L.take t f) < total es (L.take t f) :=
  have within : W.stock ds (t + 1) ≤ W.stock ds t + L.inflow ds t :=
    Nat.le_trans (Nat.le_add_right _ (L.lost ds t)) (balances.stock_inflow ds t)
  have more : L.inflow es t < L.inflow ds t :=
    Nat.lt_of_add_lt_add_left (Nat.lt_of_lt_of_le rises within)
  match exists_lt_of_total_lt (as := L.present t) more with
  | ⟨f, present, lt⟩ =>
    ⟨f, present, lt, excess_pos.mp (Nat.lt_of_le_of_lt (Nat.zero_le _) lt),
     Nat.lt_of_not_le fun le => Nat.not_le_of_gt lt (excess_le_of_le_add
       (Nat.le_trans (total_le_of_support distinct fun c mem _ => sub c mem)
         (Nat.le_trans (le_add_excess _ _) (Nat.add_le_add_right le _))))⟩

/-- **From nothing new, a rise is drawn from beyond.** In a balanced flow, where a family without
repetition rises across a step and a family containing it gains nothing across the step, some
formation taking part gives the risen family more than it takes from it, and takes from the
containing family more than from the risen one: the case of `Flow.Balances.rise_draws_beyond_inflow`
with no inflow. -/
theorem Balances.rise_draws_beyond (balances : L.Balances W) (distinct : Distinct ds)
    (sub : ∀ c, c ∈ ds → c ∈ es) (gainless : L.GainlessOn es t)
    (rises : W.stock ds t < W.stock ds (t + 1)) :
    ∃ f, f ∈ L.present t ∧ total ds (L.take t f) < total ds (L.give t f) ∧
      total ds (L.take t f) < total es (L.take t f) :=
  match balances.rise_draws_beyond_inflow distinct sub (Nat.lt_of_le_of_lt
      (Nat.le_of_eq ((congrArg (W.stock ds t + ·) (gainlessOn_iff_inflow.mp gainless)).trans
        (Nat.add_zero _))) rises) with
  | ⟨f, present, _, more, beyond⟩ => ⟨f, present, more, beyond⟩

/-- **The rise past the inflow is paid from beyond, in full.** In a balanced flow, across every step,
a family without repetition's stock after the step is at most its stock before, the inflow of a
family containing it, and what the formations taking part take from the containing family beyond
what they take from the family itself. -/
theorem Balances.rise_paid_from_beyond_inflow (balances : L.Balances W) (distinct : Distinct ds)
    (sub : ∀ c, c ∈ ds → c ∈ es) :
    W.stock ds (t + 1) ≤ W.stock ds t + L.inflow es t +
      total (L.present t) fun f => total es (L.take t f) - total ds (L.take t f) :=
  have within : ∀ f, total ds (L.take t f) ≤ total es (L.take t f) := fun _ =>
    total_le_of_support distinct fun c mem _ => sub c mem
  have each : ∀ f, total ds (L.give t f) ≤ total ds (L.take t f) +
      ((total es (L.take t f) - total ds (L.take t f)) +
        excess (total es (L.give t f)) (total es (L.take t f))) := fun f =>
    Nat.le_trans (total_le_of_support distinct fun c mem _ => sub c mem)
      (Nat.le_trans (le_add_excess _ _)
        (Nat.le_of_eq ((congrArg (· + excess (total es (L.give t f)) (total es (L.take t f)))
          (add_sub_of_le (within f)).symm).trans (Nat.add_assoc _ _ _))))
  have given : L.replenishment ds t ≤ L.uptake ds t + (L.inflow es t +
      total (L.present t) fun f => total es (L.take t f) - total ds (L.take t f)) :=
    Nat.le_trans (Nat.le_of_eq (total_swap (fun c f => L.give t f c) (L.present t) ds))
      (Nat.le_trans (total_le (L.present t) fun f _ => each f)
        (Nat.le_of_eq ((total_add (fun f => total ds (L.take t f))
            (fun f => (total es (L.take t f) - total ds (L.take t f)) +
              excess (total es (L.give t f)) (total es (L.take t f))) (L.present t)).trans
          ((congrArg (· + total (L.present t) fun f =>
              (total es (L.take t f) - total ds (L.take t f)) +
                excess (total es (L.give t f)) (total es (L.take t f)))
            (total_swap (fun f c => L.take t f c) ds (L.present t))).trans
           (congrArg (L.uptake ds t + ·) ((total_add (fun f => total es (L.take t f) - total ds (L.take t f))
              (fun f => excess (total es (L.give t f)) (total es (L.take t f)))
              (L.present t)).trans (Nat.add_comm _ _)))))))
  le_of_add_le_add_right (L.uptake ds t) (Nat.le_trans
    (Nat.le_of_eq (balances.over ds t))
    (Nat.le_trans (Nat.add_le_add_left given _)
      (Nat.le_of_eq ((congrArg (W.stock ds t + ·) (Nat.add_comm _ _)).trans
        ((Nat.add_assoc _ _ _).symm.trans (congrArg (· + L.uptake ds t) (Nat.add_assoc _ _ _).symm))))))

/-- **The rise is paid from beyond, in full.** In a balanced flow, where a family containing a
family without repetition gains nothing across a step, the family's stock after the step is at most
its stock before plus what the formations taking part take from the containing family beyond what
they take from the family itself: the case of `Flow.Balances.rise_paid_from_beyond_inflow` with no
inflow. -/
theorem Balances.rise_paid_from_beyond (balances : L.Balances W) (distinct : Distinct ds)
    (sub : ∀ c, c ∈ ds → c ∈ es) (gainless : L.GainlessOn es t) :
    W.stock ds (t + 1) ≤
      W.stock ds t + total (L.present t) fun f => total es (L.take t f) - total ds (L.take t f) :=
  Nat.le_trans (balances.rise_paid_from_beyond_inflow distinct sub)
    (Nat.le_of_eq (congrArg (· + _) ((congrArg (W.stock ds t + ·)
      (gainlessOn_iff_inflow.mp gainless)).trans (Nat.add_zero _))))

/-- **It takes from a condition beyond.** With equality of conditions decided, and the containing
family without repetition, where the family rises past the containing family's inflow, the formation
of `Flow.Balances.rise_draws_beyond_inflow` takes from a condition of the containing family outside the
risen one. -/
theorem Balances.rise_takes_beyond_inflow [DecidableEq C] (balances : L.Balances W)
    (distinct : Distinct ds) (distinctE : Distinct es) (sub : ∀ c, c ∈ ds → c ∈ es)
    (rises : W.stock ds t + L.inflow es t < W.stock ds (t + 1)) :
    ∃ f c, f ∈ L.present t ∧ total ds (L.take t f) < total ds (L.give t f) ∧
      c ∈ es ∧ ¬ c ∈ ds ∧ 0 < L.take t f c :=
  match balances.rise_draws_beyond_inflow distinct sub rises with
  | ⟨f, present, _, more, beyond⟩ => match exists_outside_of_total_lt distinctE beyond with
    | ⟨c, mem, out, takes⟩ => ⟨f, c, present, more, mem, out, takes⟩

/-- **It takes from a condition beyond**, where the containing family gains nothing: the case of no
inflow. -/
theorem Balances.rise_takes_beyond [DecidableEq C] (balances : L.Balances W)
    (distinct : Distinct ds) (distinctE : Distinct es) (sub : ∀ c, c ∈ ds → c ∈ es)
    (gainless : L.GainlessOn es t) (rises : W.stock ds t < W.stock ds (t + 1)) :
    ∃ f c, f ∈ L.present t ∧ total ds (L.take t f) < total ds (L.give t f) ∧
      c ∈ es ∧ ¬ c ∈ ds ∧ 0 < L.take t f c :=
  balances.rise_takes_beyond_inflow distinct distinctE sub (Nat.lt_of_le_of_lt
    (Nat.le_of_eq ((congrArg (W.stock ds t + ·) (gainlessOn_iff_inflow.mp gainless)).trans
      (Nat.add_zero _))) rises)

/-- Under nothing from nothing, wherever the step is enclosed around a family without repetition,
a rise of its stock has a formation giving it more than it takes from it and taking from a
condition outside it. -/
theorem Gainless.rise_takes_beyond [DecidableEq C] (balances : L.Balances W)
    (gainless : L.Gainless) (distinct : Distinct ds) (around : L.Around ds t)
    (rises : W.stock ds t < W.stock ds (t + 1)) :
    ∃ f c, f ∈ L.present t ∧ total ds (L.take t f) < total ds (L.give t f) ∧
      ¬ c ∈ ds ∧ 0 < L.take t f c :=
  match around with
  | ⟨_, distinctE, sub, closed⟩ =>
    match balances.rise_takes_beyond distinct distinctE sub (gainless _ t distinctE closed) rises with
    | ⟨f, c, present, more, _, out, takes⟩ => ⟨f, c, present, more, out, takes⟩

/-- **Selection favours reaching beyond, past the inflow.** In a balanced flow, let a family without
repetition list every condition a member of a group couples into, inside a family without repetition
containing it. Then every selection that holds of the flow's levels only where that family's stock
rises across a step by more than the containing family's inflow, and holds of them, holds only where,
across the step, a formation taking part gives the family more than it takes from it and takes from
a condition no member of the group couples into. -/
theorem favours_reaching_beyond_inflow [DecidableEq C] {obs : F → C → Prop} {members : F → Prop}
    {select : (Nat → C → Nat) → Prop} (balances : L.Balances W) (distinct : Distinct ds)
    (distinctE : Distinct es) (sub : ∀ c, c ∈ ds → c ∈ es)
    (listed : ∀ h c, members h → W.CoupledInto obs h c → c ∈ ds)
    (rewards : select W.level → W.stock ds t + L.inflow es t < W.stock ds (t + 1))
    (holds : select W.level) :
    ∃ f c, f ∈ L.present t ∧ total ds (L.take t f) < total ds (L.give t f) ∧
      0 < L.take t f c ∧ ∀ h, members h → ¬ W.CoupledInto obs h c :=
  match balances.rise_takes_beyond_inflow distinct distinctE sub (rewards holds) with
  | ⟨f, c, present, more, _, out, takes⟩ =>
    ⟨f, c, present, more, takes, fun h member couples => out (listed h c member couples)⟩

/-- **Selection favours reaching beyond.** In a balanced flow, let a family without repetition
list every condition a member of a group couples into, and let a family containing it gain
nothing across a step. Then every selection that holds of the flow's levels only where that
family's stock rises across the step, and holds of them, holds only where, across the step, a
formation taking part gives the family more than it takes from it and takes from a condition no
member of the group couples into: the case of `Flow.favours_reaching_beyond_inflow` with no
inflow. -/
theorem favours_reaching_beyond [DecidableEq C] {obs : F → C → Prop} {members : F → Prop}
    {select : (Nat → C → Nat) → Prop} (balances : L.Balances W) (distinct : Distinct ds)
    (distinctE : Distinct es) (sub : ∀ c, c ∈ ds → c ∈ es) (gainless : L.GainlessOn es t)
    (listed : ∀ h c, members h → W.CoupledInto obs h c → c ∈ ds)
    (rewards : select W.level → W.stock ds t < W.stock ds (t + 1)) (holds : select W.level) :
    ∃ f c, f ∈ L.present t ∧ total ds (L.take t f) < total ds (L.give t f) ∧
      0 < L.take t f c ∧ ∀ h, members h → ¬ W.CoupledInto obs h c :=
  favours_reaching_beyond_inflow balances distinct distinctE sub listed (fun held =>
    Nat.lt_of_le_of_lt (Nat.le_of_eq ((congrArg (W.stock ds t + ·)
      (gainlessOn_iff_inflow.mp gainless)).trans (Nat.add_zero _))) (rewards held)) holds

end Flow

/-- **Raising an observed family is a selection through coupling.** Where `g` observes every
condition of a family, that the family's stock rises across the step from `t` is a selection
through `g`'s coupling up to `t + 1`. -/
theorem Web.raises_selectsThrough {W : Web F C} {obs : F → C → Prop} {g : F} {ds : List C}
    {t : Nat} (observed : ∀ c, c ∈ ds → obs g c) :
    W.SelectsThrough obs g (t + 1) fun l => total ds (l t) < total ds (l (t + 1)) :=
  fun l l' alike =>
    have before : total ds (l t) = total ds (l' t) :=
      total_congr_on fun c mem => (alike t (Nat.le_succ t)).2 c (observed c mem)
    have after : total ds (l (t + 1)) = total ds (l' (t + 1)) :=
      total_congr_on fun c mem => (alike (t + 1) (Nat.le_refl _)).2 c (observed c mem)
    ⟨fun lt => Nat.lt_of_le_of_lt (Nat.le_of_eq before.symm)
        (Nat.lt_of_lt_of_le lt (Nat.le_of_eq after)),
     fun lt => Nat.lt_of_le_of_lt (Nat.le_of_eq before)
        (Nat.lt_of_lt_of_le lt (Nat.le_of_eq after.symm))⟩

namespace Diversion

/-- Equality of places is decided. -/
instance : DecidableEq Place
  | .source, .source => isTrue rfl
  | .store, .store => isTrue rfl
  | .source, .store => isFalse fun same => nomatch same
  | .store, .source => isFalse fun same => nomatch same

/-- The source and the store, without repetition. -/
theorem places_distinct : Distinct [Place.source, Place.store] :=
  show ¬ Place.source ∈ [Place.store] ∧ (¬ Place.store ∈ ([] : List Place) ∧ True) from
  ⟨fun mem => (match mem_cons_cases mem with
    | .inl same => nomatch same
    | .inr mem => nomatch mem), fun mem => (nomatch mem), trivial⟩

/-- The diverting flow gains nothing on the source and the store across the first step: the taker
gives the store the one unit it takes from the source. -/
theorem diverting_gainless : diverting.GainlessOn [Place.source, Place.store] 0 :=
  fun f _ => match f with
    | .taker => Nat.le_refl 1
    | .dweller => Nat.le_refl 0

/-- The taker couples into the store alone: it depends on nothing and observes only the store. -/
theorem taker_listed : ∀ h c, h = Formation.taker →
    (web divertedLevel).CoupledInto gauge h c → c ∈ [Place.store] :=
  fun _ c same => Eq.subst
    (motive := fun x => (web divertedLevel).CoupledInto gauge x c → c ∈ [Place.store]) same.symm
    fun couples => match couples with
      | .inl ⟨_, requires⟩ => False.elim (requires : False)
      | .inr observes => match c with
        | .source => False.elim (observes : False)
        | .store => .head []

/-- **An instance of the general law.** The store's rise across the first step is a selection
through the taker's coupling, and it holds only where a formation raising the store takes from a
place the taker does not couple into: derived from `Flow.favours_reaching_beyond`. -/
theorem draws_beyond :
    (web divertedLevel).SelectsThrough gauge .taker 1
        (fun l => total [Place.store] (l 0) < total [Place.store] (l 1)) ∧
      ∃ f c, f ∈ diverting.present 0 ∧
        total [Place.store] (diverting.take 0 f) < total [Place.store] (diverting.give 0 f) ∧
        0 < diverting.take 0 f c ∧ ¬ (web divertedLevel).CoupledInto gauge .taker c :=
  ⟨Web.raises_selectsThrough fun _ mem => (match mem_cons_cases mem with
      | .inl same => Eq.subst (motive := fun x => gauge .taker x) same.symm trivial
      | .inr mem => nomatch mem),
   have law := Flow.favours_reaching_beyond (L := diverting) (W := web divertedLevel)
      (ds := [Place.store]) (es := [Place.source, Place.store]) (t := 0) (obs := gauge)
      (members := fun h => h = Formation.taker)
      (select := fun l => total [Place.store] (l 0) < total [Place.store] (l 1))
      favours.1
      (show ¬ Place.store ∈ ([] : List Place) ∧ True from ⟨fun mem => (nomatch mem), trivial⟩)
      places_distinct
      (fun _ mem => match mem_cons_cases mem with
        | .inl same => Eq.subst (motive := fun x => x ∈ [Place.source, Place.store]) same.symm
            (.tail _ (.head []))
        | .inr mem => nomatch mem)
      diverting_gainless taker_listed (fun lt => lt) (Nat.lt_succ_self 0)
   match law with
   | ⟨f, c, present, more, takes, out⟩ => ⟨f, c, present, more, takes, out .taker rfl⟩⟩

/-- **The premise binds.** The supplying flow balances and raises the store across the first step
with nothing taken: without nothing from nothing, a rise need not reach beyond. -/
theorem supplying_raises_untaken :
    supplying.Balances (web suppliedLevel) ∧
      (web suppliedLevel).stock [Place.store] 0 < (web suppliedLevel).stock [Place.store] 1 ∧
      ∀ t f c, supplying.take t f c = 0 :=
  ⟨blind_to_source.1, Nat.lt_succ_self 0, fun _ _ _ => rfl⟩

/-- **The inflow bound is exact.** Across the first step the supplying flow's inflow on the source
and the store is one unit, the store rises by exactly that unit, and nothing is taken: a rise up to
the inflow need not reach beyond, so `Flow.Balances.rise_draws_beyond_inflow` needs the rise to pass
the inflow. -/
theorem supplying_rises_by_inflow :
    supplying.inflow [Place.source, Place.store] 0 = 1 ∧
      (web suppliedLevel).stock [Place.store] 1 =
        (web suppliedLevel).stock [Place.store] 0 + supplying.inflow [Place.source, Place.store] 0 ∧
      ∀ t f c, supplying.take t f c = 0 :=
  ⟨rfl, rfl, fun _ _ _ => rfl⟩

end Diversion

end Becoming
