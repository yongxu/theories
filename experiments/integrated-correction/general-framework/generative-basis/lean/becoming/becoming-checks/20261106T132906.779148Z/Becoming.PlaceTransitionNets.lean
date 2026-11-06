import Becoming.Reading
import Becoming.Continuation
import Becoming.Openness

/-!
# Place/transition nets: a formalism defined outside the theory, read on the spine

A place/transition net (a Petri net; for chemistry, a reaction network with whole-number counts)
is defined here by its own standard rules, with no word of the spine in them. Each transition
consumes `pre f p` tokens from each place `p` and produces `post f p` there; a marking says how
many tokens each place holds; a step fires a list of transitions, repetition allowed (step
semantics, a multiset of transitions), and is enabled at a marking where it consumes from each
place at most what the place holds; firing takes what the step consumes and adds what it
produces; a schedule is a firing sequence from a marking where each of its steps is enabled at
the marking reached. A net is pure where no transition both consumes from and produces into one
place; a schedule is sequential where it fires at most one transition at a time (interleaving
semantics); a place is gated at `m` where every transition producing into it consumes at least
`m` tokens from it (for `m = 1`, the place by itself is a siphon). Weights `y` on the places read
the tokens in units, as a P-semiflow does.

This module proves which premises of the spine hold of every net by the net's own definitions,
which hold exactly under a named property of the net, and restates the spine's laws for nets.

* **The net is a law of exchange.** In units `y`, the net's exchange law takes `y p * pre f p`
  and gives `y p * post f p`, whatever has stood (`Net.law`); it reads what has stood
  (`Net.law_nonanticipating`), the course it generates along a schedule is the net's flow
  (`Net.course_eq`), and along a firing sequence its levels are the net's markings in units
  (`Net.Fires.levels_eq`). Nothing about the net is supplied beyond its definitions.
* **Balance is the firing rule, exactly.** The net's flow balances the web of its markings in
  any units (`Net.Fires.balances`), and with every weight positive it balances exactly where the
  schedule is a firing sequence (`Net.balances_iff`): a step that is not enabled breaks balance at
  the place it overdraws. Enabling gives the law's feasibility (`Net.Fires.feasible`), so
  `ExchangeLaw.course_balances_iff` applies (`Net.Fires.course_balances`). Feasibility is weaker:
  it lets a step use what it produces in the same step. It is enabling exactly for pure nets fired
  one transition at a time (`Net.fires_iff_feasible`); a catalyst (a transition consuming and
  producing one token at an empty place, `Net.catalyst_feasible_not_fires`) and a concurrent step
  of a pure net (`Net.relay_feasible_not_fires`) are feasible courses that are not firing
  sequences.
* **The other tying premises hold by the definitions.** Read with a transition active exactly
  where it fires and requiring and drawing on exactly the places it consumes from, at its weighted
  multiplicity, only active transitions give (`Net.acting`), only active transitions take and only
  from what they draw on (`Net.taking`), and along a firing sequence activity needs support
  (`Net.Fires.dependent`).
* **Dissipation is a strict P-subinvariant, exactly.** A transition loses in units `y` over a
  finite list of places where it produces no more weighted tokens than it consumes, and fewer when
  it consumes any (`Net.Loses`); every transition lowering the weighted count, `y·post < y·pre`,
  is a strict P-subinvariant (`Net.StrictSubinvariant`, `Net.Loses.of_lt`). For a net with
  finitely many places, listed once, with equality of places decided, the net's flow is
  dissipative exactly where every transition it fires loses (`Net.dissipative_iff`), and every
  step is enclosed (`Net.enclosed`).
* **The laws, for nets.** Along a firing sequence of a finite net whose fired transitions lose:
  a step that raises one place's weighted marking lowers another's (`Net.rise_with_fall`;
  in tokens, `Net.rise_with_fall_tokens`); the transitions that consume anything, fired over any
  stretch from the start, number at most the initial weighted token count (`Net.takers_within`),
  so firing them does not recur (`Net.taking_not_recurring`); that the marking stops changing
  from some step on cannot be refuted (`Net.change_stops_unrefuted`, in tokens with positive
  weights `Net.marking_stops_unrefuted`); and, read as a world of places and transitions with
  finitely many transitions (`Net.world`), every premise of `World.rests_unrefuted_enclosed`
  holds, so that the world rests from some step on cannot be refuted (`Net.rests_unrefuted`).
* **The siphon law is the joint-excess law.** Where a place is gated at `m`, `n` steps of a
  firing sequence that consume from it more than they produce, starting below `n + m`, leave every
  transition consuming at least `m` from it dead from then on (`Net.gated_ends`, from
  `Flow.joint_excess_ends`). With `m = 1` and `n = 0`: an empty place every producer of which
  consumes it stays empty, and every transition consuming from it is dead (`Net.siphon_empty`),
  the one-place case of the classical law that an emptied siphon stays empty.
* **Where a premise fails, the law fails.** The conservative cycle (`Net.cycle`), one token
  moved back and forth between two places, fires forever; every premise of the rest law holds
  but dissipation (`Net.cycle_premises`, `Net.cycle_not_dissipative`), and its marking changes at
  every step, so its world never rests (`Net.cycle_changes`, `Net.cycle_never_rests`). The fed
  place (`Net.fed`): a place emptied by its consumer is refilled by a transition that does not
  consume it, and the consumer fires again; every hypothesis of `Flow.joint_excess_ends` holds but
  gating, and its conclusion fails (`Net.fed_refills`).

What is not derived: which net, schedule or weights a system has (the step from a physical or
chemical system to a net is a modelling correspondence, outside Lean); that a net is finite, pure
or losing, or a place gated (each a named, checkable property of the net). The spine's
commitments to discrete steps and whole-number amounts are the net's own. Every declaration has
an empty axiom report. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

/-- A place/transition net: what each transition consumes from and produces into each place. -/
structure Net (T P : Type) where
  pre : T → P → Nat
  post : T → P → Nat

namespace Net

variable {T P : Type} (N : Net T P)

/-! ## The net's own rules -/

/-- What a step, a list of transitions with repetition, consumes from `p`. -/
def consumes (s : List T) (p : P) : Nat :=
  total s fun f => N.pre f p

/-- What a step produces into `p`. -/
def produces (s : List T) (p : P) : Nat :=
  total s fun f => N.post f p

/-- A step is enabled at a marking where it consumes from each place at most what it holds. -/
def Enabled (s : List T) (M : P → Nat) : Prop :=
  ∀ p, N.consumes s p ≤ M p

/-- Firing a step: what it consumes is removed, what it produces is added. -/
def fire (s : List T) (M : P → Nat) : P → Nat :=
  fun p => M p - N.consumes s p + N.produces s p

/-- The markings a schedule reaches from `M₀`, firing its steps in turn. -/
def marking (σ : Nat → List T) (M₀ : P → Nat) : Nat → P → Nat
  | 0 => M₀
  | n + 1 => N.fire (σ n) (marking σ M₀ n)

/-- The schedule is a firing sequence from `M₀`: every step is enabled at the marking reached. -/
def Fires (σ : Nat → List T) (M₀ : P → Nat) : Prop :=
  ∀ n, N.Enabled (σ n) (N.marking σ M₀ n)

/-- No transition both consumes from and produces into one place. -/
def Pure : Prop :=
  ∀ f p, N.pre f p = 0 ∨ N.post f p = 0

/-- At most one transition fires at a time. -/
def Sequential (σ : Nat → List T) : Prop :=
  ∀ n, σ n = [] ∨ ∃ f, σ n = [f]

/-- In units `y` over the places `ps`, the transition produces no more than it consumes, and less
when it consumes anything. -/
def Loses (y : P → Nat) (ps : List P) (f : T) : Prop :=
  total ps (fun p => y p * N.post f p) + sign (total ps fun p => y p * N.pre f p) ≤
    total ps fun p => y p * N.pre f p

/-- Every transition lowers the weighted token count: `y` is a strict P-subinvariant. -/
def StrictSubinvariant (y : P → Nat) (ps : List P) : Prop :=
  ∀ f, total ps (fun p => y p * N.post f p) < total ps fun p => y p * N.pre f p

/-- Every transition producing into `p` consumes at least `m` tokens from it. -/
def Gated (p : P) (m : Nat) : Prop :=
  ∀ f, 0 < N.post f p → 0 < N.pre f p ∧ m ≤ N.pre f p

variable {N}

/-- A strict P-subinvariant makes every transition lose. -/
theorem Loses.of_lt {y : P → Nat} {ps : List P} {f : T}
    (lt : total ps (fun p => y p * N.post f p) < total ps fun p => y p * N.pre f p) :
    N.Loses y ps f :=
  Nat.le_trans (Nat.add_le_add_left (sign_le_one _) _) lt

theorem StrictSubinvariant.loses {y : P → Nat} {ps : List P} (strict : N.StrictSubinvariant y ps)
    (f : T) : N.Loses y ps f :=
  Loses.of_lt (strict f)

/-! ## The net read on the spine -/

variable (N)

/-- The net's law of exchange in units `y`: each transition takes and gives its weighted
multiplicities, whatever has stood. -/
def law (y : P → Nat) : ExchangeLaw T P :=
  ⟨fun _ f _ p => y p * N.pre f p, fun _ f _ p => y p * N.post f p⟩

/-- The net's flow along a schedule in units `y`. -/
def flow (y : P → Nat) (σ : Nat → List T) : Flow T P :=
  ⟨σ, fun _ f p => y p * N.pre f p, fun _ f p => y p * N.post f p⟩

/-- The web of the markings in units `y`: a transition active exactly where it fires, requiring
and drawing on the places it consumes from, at its weighted multiplicity. -/
def web (y : P → Nat) (σ : Nat → List T) (M₀ : P → Nat) : Web T P :=
  ⟨fun t p => y p * N.marking σ M₀ t p, fun t f => f ∈ σ t, fun _ f p => 0 < N.pre f p,
    fun _ f p => y p * N.pre f p, fun _ f p => 0 < N.pre f p⟩

/-- Units of one token. -/
def one : P → Nat := fun _ => 1

variable {N} {y : P → Nat} {σ : Nat → List T} {M₀ : P → Nat}

theorem flow_taken (t : Nat) (p : P) :
    (N.flow y σ).taken t p = y p * N.consumes (σ t) p :=
  total_mul (y p) (fun f => N.pre f p) (σ t)

theorem flow_given (t : Nat) (p : P) :
    (N.flow y σ).given t p = y p * N.produces (σ t) p :=
  total_mul (y p) (fun f => N.post f p) (σ t)

/-- The net's law reads what has stood: it reads nothing. -/
theorem law_nonanticipating : (N.law y).Nonanticipating :=
  fun _ _ _ _ _ _ => ⟨rfl, rfl⟩

/-- The course the net's law generates along a schedule is the net's flow. -/
theorem course_eq (start : P → Nat) : (N.law y).course σ start = N.flow y σ :=
  rfl

theorem le_of_fire_add_back {M k g : Nat} (back : M - k + g + k = M + g) : k ≤ M :=
  ExchangeLaw.sub_add_back_iff.mp
    (add_right_cancel g ((Nat.add_right_comm (M - k) k g).trans back))

/-- In units: what stands with what is given, less what is taken, is the fired level, where no
more is taken than stands. -/
theorem fire_scaled {u M k g : Nat} (le : k ≤ M) : u * M + u * g - u * k = u * (M - k + g) :=
  have split : u * M = u * (M - k) + u * k :=
    (congrArg (u * ·) (Naturals.sub_add_cancel le)).symm.trans (Nat.left_distrib u (M - k) k)
  (congrArg (· + u * g - u * k) split).trans
    ((congrArg (· - u * k) (Nat.add_right_comm (u * (M - k)) (u * k) (u * g))).trans
      ((Naturals.add_sub_cancel (u * (M - k) + u * g) (u * k)).trans
        (Nat.left_distrib u (M - k) g).symm))

/-! ## Balance is the firing rule -/

/-- The balance of one step at one place, in units, is its enabling there. -/
theorem balance_at_iff {u M k g : Nat} (positive : 0 < u) :
    u * (M - k + g) + u * k = u * M + u * g ↔ k ≤ M :=
  ⟨fun balance => le_of_fire_add_back (Nat.eq_of_mul_eq_mul_left positive
      ((Nat.left_distrib u _ k).trans (balance.trans (Nat.left_distrib u M g).symm))),
   fun le => (Nat.left_distrib u _ k).symm.trans
      ((congrArg (u * ·) (Naturals.sub_add_refill _ le)).trans (Nat.left_distrib u M g))⟩

theorem balance_at_iff' {u M k g : Nat} (le : k ≤ M) :
    u * (M - k + g) + u * k = u * M + u * g :=
  (Nat.left_distrib u _ k).symm.trans ((congrArg (u * ·) (Naturals.sub_add_refill _ le)).trans (Nat.left_distrib u M g))

/-- **Along a firing sequence the net's flow balances its markings**, in any units. -/
theorem Fires.balances (fires : N.Fires σ M₀) (y : P → Nat) :
    (N.flow y σ).Balances (N.web y σ M₀) :=
  fun t p =>
    (congrArg (y p * N.marking σ M₀ (t + 1) p + ·) (flow_taken (N := N) (y := y) (σ := σ) t p)).trans
      ((balance_at_iff' (u := y p) (M := N.marking σ M₀ t p) (k := N.consumes (σ t) p)
          (g := N.produces (σ t) p) (fires t p)).trans
        (congrArg (y p * N.marking σ M₀ t p + ·) (flow_given (N := N) (y := y) (σ := σ) t p).symm))

/-- **Balance exactly on firing sequences.** With every weight positive, the net's flow balances
the web of its markings exactly where the schedule is a firing sequence. -/
theorem balances_iff (positive : ∀ p, 0 < y p) :
    (N.flow y σ).Balances (N.web y σ M₀) ↔ N.Fires σ M₀ :=
  ⟨fun balances t p => (balance_at_iff (u := y p) (M := N.marking σ M₀ t p)
        (k := N.consumes (σ t) p) (g := N.produces (σ t) p) (positive p)).mp
      ((congrArg (y p * N.marking σ M₀ (t + 1) p + ·)
          (flow_taken (N := N) (y := y) (σ := σ) t p)).symm.trans
        ((balances t p).trans (congrArg (y p * N.marking σ M₀ t p + ·)
          (flow_given (N := N) (y := y) (σ := σ) t p)))),
   fun fires => fires.balances y⟩

/-! ## The course of the law is the firing sequence -/

/-- Where every step before `t` is enabled, the levels the net's law generates at `t` are the
markings in units. -/
theorem levels_eq_of_enabled :
    ∀ t, (∀ s, s < t → N.Enabled (σ s) (N.marking σ M₀ s)) →
      ∀ p, (N.law y).levels σ (fun p => y p * M₀ p) t p = y p * N.marking σ M₀ t p
  | 0, _, _ => rfl
  | t + 1, enabled, p =>
    (ExchangeLaw.levels_succ (law := N.law y) (present := σ) t p).trans
      ((congrArg (fun l => l + (N.flow y σ).given t p - (N.flow y σ).taken t p)
          (levels_eq_of_enabled t (fun s lt => enabled s (Nat.lt_succ_of_lt lt)) p)).trans
        ((congrArg (fun g => y p * N.marking σ M₀ t p + g - (N.flow y σ).taken t p)
            (flow_given (N := N) (y := y) (σ := σ) t p)).trans
          ((congrArg (fun k => y p * N.marking σ M₀ t p + y p * N.produces (σ t) p - k)
              (flow_taken (N := N) (y := y) (σ := σ) t p)).trans
            (fire_scaled (u := y p) (M := N.marking σ M₀ t p) (k := N.consumes (σ t) p)
              (g := N.produces (σ t) p) (enabled t (Nat.lt_succ_self t) p)))))

/-- **Along a firing sequence the levels the law generates are the markings**, in units. -/
theorem Fires.levels_eq (fires : N.Fires σ M₀) (y : P → Nat) (t : Nat) (p : P) :
    (N.law y).levels σ (fun p => y p * M₀ p) t p = y p * N.marking σ M₀ t p :=
  levels_eq_of_enabled t (fun s _ => fires s) p

/-- **Enabling gives feasibility**: along a firing sequence the net's law never takes more from
a place than stands on it and is given to it. -/
theorem Fires.feasible (fires : N.Fires σ M₀) (y : P → Nat) :
    (N.law y).Feasible σ (fun p => y p * M₀ p) :=
  fun t p => Nat.le_trans (Nat.le_of_eq (flow_taken (N := N) (y := y) (σ := σ) t p))
    (Nat.le_trans (Nat.mul_le_mul_left (y p) (fires t p))
      (Nat.le_trans (Nat.le_add_right _ _)
        (Nat.le_of_eq (congrArg (· + _) (fires.levels_eq y t p).symm))))

/-- So `ExchangeLaw.course_balances_iff` applies: along a firing sequence the course the net's
law generates balances on the levels it generates. -/
theorem Fires.course_balances (fires : N.Fires σ M₀) (y : P → Nat) (W : Web T P) :
    ((N.law y).course σ (fun p => y p * M₀ p)).Balances
      (W.withLevel ((N.law y).levels σ (fun p => y p * M₀ p))) :=
  (ExchangeLaw.course_balances_iff law_nonanticipating W).mpr (fires.feasible y)

/-- A sequential step of a pure net that consumes no more than stands and is produced consumes
no more than stands. -/
theorem enabled_of_within (pure : N.Pure) {s : List T} (single : s = [] ∨ ∃ f, s = [f])
    {M : P → Nat} (within : ∀ p, N.consumes s p ≤ M p + N.produces s p) : N.Enabled s M :=
  fun p => match single with
  | .inl empty => Eq.subst (motive := fun s => N.consumes s p ≤ M p) empty.symm (Nat.zero_le _)
  | .inr ⟨f, one⟩ =>
    have within' : N.pre f p + 0 ≤ M p + (N.post f p + 0) :=
      Eq.subst (motive := fun s => N.consumes s p ≤ M p + N.produces s p) one (within p)
    Eq.subst (motive := fun s => N.consumes s p ≤ M p) one.symm (match pure f p with
      | .inl none_ => Nat.le_trans (Nat.le_of_eq (congrArg (· + 0) none_)) (Nat.zero_le _)
      | .inr none_ => Nat.le_trans within'
          (Nat.le_of_eq (congrArg (fun g => M p + (g + 0)) none_)))

/-- **Feasibility is enabling exactly for pure nets fired one transition at a time.** With every
weight positive, a sequential schedule of a pure net is a firing sequence exactly where the net's
law is feasible along it. -/
theorem fires_iff_feasible (pure : N.Pure) (sequential : Sequential σ) (positive : ∀ p, 0 < y p) :
    N.Fires σ M₀ ↔ (N.law y).Feasible σ (fun p => y p * M₀ p) :=
  ⟨fun fires => fires.feasible y, fun feasible =>
    have enabled_at : ∀ t, (∀ s, s < t → N.Enabled (σ s) (N.marking σ M₀ s)) →
        N.Enabled (σ t) (N.marking σ M₀ t) := fun t before =>
      enabled_of_within pure (sequential t) fun p =>
        Nat.le_of_mul_le_mul_left
          (Nat.le_trans (Nat.le_of_eq (flow_taken (N := N) (y := y) (σ := σ) t p).symm)
            (Nat.le_trans (feasible t p)
              (Nat.le_of_eq ((congrArg (· + (N.flow y σ).given t p)
                  (levels_eq_of_enabled t before p)).trans
                ((congrArg (y p * N.marking σ M₀ t p + ·) (flow_given (N := N) (y := y) (σ := σ) t p)).trans
                  (Nat.left_distrib (y p) _ _).symm)))))
          (positive p)
    have upto : ∀ t s, s < t → N.Enabled (σ s) (N.marking σ M₀ s) := fun t =>
      Nat.rec (motive := fun t => ∀ s, s < t → N.Enabled (σ s) (N.marking σ M₀ s))
        (fun _ no => absurd no (Nat.not_lt_zero _))
        (fun t before s lt => match Nat.lt_or_eq_of_le (Nat.le_of_lt_succ lt) with
          | .inl earlier => before s earlier
          | .inr now => Eq.subst (motive := fun s => N.Enabled (σ s) (N.marking σ M₀ s)) now.symm
              (enabled_at t before))
        t
    fun t => upto (t + 1) t (Nat.lt_succ_self t)⟩

/-! ## Two feasible courses that are not firing sequences -/

/-- A catalyst: one transition consuming and producing one token at one place. -/
def catalyst : Net Unit Unit :=
  ⟨fun _ _ => 1, fun _ _ => 1⟩

/-- A relay: a source producing one token and a sink consuming one, at one place; pure. -/
def relay : Net Bool Unit :=
  ⟨fun f _ => match f with | true => 0 | false => 1, fun f _ => match f with | true => 1 | false => 0⟩

theorem relay_pure : relay.Pure :=
  fun f _ => match f with | true => .inl rfl | false => .inr rfl

theorem catalyst_levels : ∀ t c,
    (catalyst.law one).levels (fun _ => [()]) (fun p => one p * (fun _ => 0) p) t c = 0
  | 0, _ => rfl
  | t + 1, c => (ExchangeLaw.levels_succ (law := catalyst.law one) (present := fun _ => [()]) t c).trans
      (congrArg (fun l => l + (1 * 1 + 0) - (1 * 1 + 0)) (catalyst_levels t c))

theorem relay_levels : ∀ t c,
    (relay.law one).levels (fun _ => [true, false]) (fun p => one p * (fun _ => 0) p) t c = 0
  | 0, _ => rfl
  | t + 1, c => (ExchangeLaw.levels_succ (law := relay.law one) (present := fun _ => [true, false]) t c).trans
      (congrArg (fun l => l + (1 * 1 + (1 * 0 + 0)) - (1 * 0 + (1 * 1 + 0))) (relay_levels t c))

/-- **A catalyst at an empty place is feasible and does not fire**: feasibility lets a step use
the token it produces. -/
theorem catalyst_feasible_not_fires :
    (catalyst.law one).Feasible (fun _ => [()]) (fun p => one p * (fun _ => 0) p) ∧
      ¬ catalyst.Fires (fun _ => [()]) (fun _ => 0) :=
  ⟨fun t c => Nat.le_trans (Nat.le_of_eq rfl)
      (Nat.le_trans (Nat.le_refl 1)
        (Nat.le_of_eq (congrArg (· + (1 * 1 + 0)) (catalyst_levels t c)).symm)),
   fun fires => Nat.not_succ_le_zero 0 (fires 0 ())⟩

/-- **A concurrent step of a pure net is feasible and does not fire**: the relay is pure, and the
sink uses what the source produces in the same step. -/
theorem relay_feasible_not_fires :
    relay.Pure ∧ (relay.law one).Feasible (fun _ => [true, false]) (fun p => one p * (fun _ => 0) p) ∧
      ¬ relay.Fires (fun _ => [true, false]) (fun _ => 0) :=
  ⟨relay_pure, fun t c => Nat.le_trans (Nat.le_of_eq rfl)
      (Nat.le_trans (Nat.le_refl 1)
        (Nat.le_of_eq (congrArg (· + (1 * 1 + (1 * 0 + 0))) (relay_levels t c)).symm)),
   fun fires => Nat.not_succ_le_zero 0 (fires 0 ())⟩

/-! ## The tying premises -/

/-- Only active transitions give: a transition gives where it fires. -/
theorem acting : (N.flow y σ).Acting (N.web y σ M₀) :=
  fun _ _ _ fired _ => fired

/-- Only active transitions take, and only from what they draw on. -/
theorem taking : (N.flow y σ).Taking (N.web y σ M₀) :=
  fun _ _ _ fired takes => ⟨fired, Nat.pos_of_ne_zero fun none_ =>
    Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le takes (Nat.le_of_eq
      ((congrArg (y _ * ·) none_).trans (Nat.mul_zero _))))⟩

/-- **Along a firing sequence activity needs support**: a firing transition finds at each place
it consumes from at least its multiplicity. -/
theorem Fires.dependent (fires : N.Fires σ M₀) (y : P → Nat) : (N.web y σ M₀).Dependent :=
  fun t _ fired p _ => Nat.mul_le_mul_left (y p)
    (Nat.le_trans (le_total_of_mem (q := fun f => N.pre f p) fired) (fires t p))

/-! ## Dissipation and enclosure -/

/-- Over a list of every place, once each, a quantity vanishing outside a family without
repetition totals the same over the family. -/
theorem total_eq_closed [DecidableEq P] {ps cs : List P} (distinct : Distinct ps)
    (every : ∀ p, p ∈ ps) (distinct' : Distinct cs) {q : P → Nat}
    (outside : ∀ c, ¬ c ∈ cs → q c = 0) : total cs q = total ps q :=
  Nat.le_antisymm (total_le_of_support distinct' fun a _ _ => every a)
    (total_le_of_support distinct fun a _ positive => match decideMem a cs with
      | .isTrue mem => mem
      | .isFalse out => absurd (Nat.lt_of_lt_of_le positive (Nat.le_of_eq (outside a out)))
          (Nat.lt_irrefl 0))

/-- **Dissipation is a strict P-subinvariant on what fires, exactly.** For a net with finitely
many places, listed once, the net's flow is dissipative exactly where every transition it fires
loses. -/
theorem dissipative_iff [DecidableEq P] {ps : List P} (distinct : Distinct ps)
    (every : ∀ p, p ∈ ps) :
    (N.flow y σ).Dissipative ↔ ∀ t f, f ∈ σ t → N.Loses y ps f :=
  ⟨fun dissipative t f fired =>
    dissipative ps t distinct (fun _ _ c out => absurd (every c) out) f fired,
   fun loses _ t distinct' closed f fired =>
    have post_eq := total_eq_closed distinct every distinct' fun c out => (closed f fired c out).2
    have pre_eq := total_eq_closed distinct every distinct' fun c out => (closed f fired c out).1
    Nat.le_trans (Nat.le_of_eq (congr (congrArg HAdd.hAdd post_eq) (congrArg sign pre_eq)))
      (Nat.le_trans (loses t f fired) (Nat.le_of_eq pre_eq.symm))⟩

/-- A net whose weights are a strict P-subinvariant has a dissipative flow along every
schedule. -/
theorem StrictSubinvariant.dissipative [DecidableEq P] {ps : List P} (distinct : Distinct ps)
    (every : ∀ p, p ∈ ps) (strict : N.StrictSubinvariant y ps) : (N.flow y σ).Dissipative :=
  (dissipative_iff distinct every).mpr fun _ f _ => strict.loses f

/-- Every step of a net with finitely many places is enclosed. -/
theorem enclosed {ps : List P} (distinct : Distinct ps) (every : ∀ p, p ∈ ps) (t : Nat) :
    (N.flow y σ).Enclosed t :=
  ⟨ps, distinct, fun _ _ c out => absurd (every c) out⟩

/-! ## The laws, for nets -/

section Laws

variable {ps : List P}

/-- **Rising and falling in one firing**: where every transition a step fires loses over the
places, a place whose weighted marking rises across the step has another whose weighted marking
falls. -/
theorem rise_with_fall (fires : N.Fires σ M₀) {t : Nat}
    (loses : ∀ f, f ∈ σ t → N.Loses y ps f) {p : P} (mem : p ∈ ps)
    (rises : y p * N.marking σ M₀ t p < y p * N.marking σ M₀ (t + 1) p) :
    ∃ q, q ∈ ps ∧ q ≠ p ∧ y q * N.marking σ M₀ (t + 1) q < y q * N.marking σ M₀ t q :=
  Flow.rise_with_fall (fires.balances y) loses mem rises

/-- In tokens: where every transition a step fires consumes more tokens than it produces, a
place gaining tokens across the step has another losing tokens. -/
theorem rise_with_fall_tokens (fires : N.Fires σ M₀) {t : Nat}
    (loses : ∀ f, f ∈ σ t → N.Loses one ps f) {p : P} (mem : p ∈ ps)
    (rises : N.marking σ M₀ t p < N.marking σ M₀ (t + 1) p) :
    ∃ q, q ∈ ps ∧ q ≠ p ∧ N.marking σ M₀ (t + 1) q < N.marking σ M₀ t q :=
  match rise_with_fall (y := one) fires loses mem
      (Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.one_mul _))
        (Nat.lt_of_lt_of_le rises (Nat.le_of_eq (Nat.one_mul _).symm))) with
  | ⟨q, mem', other, falls⟩ => ⟨q, mem', other,
      Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.one_mul _).symm)
        (Nat.lt_of_lt_of_le falls (Nat.le_of_eq (Nat.one_mul _)))⟩

/-- The transitions fired at step `t` that consume anything, in units, with repetition. -/
theorem takers_eq (t : Nat) :
    (N.flow y σ).takers ps t = count (σ t) fun f => total ps fun p => y p * N.pre f p :=
  rfl

/-- **The firings that consume are bounded by the tokens at the start**: along a firing sequence
whose fired transitions lose, the transitions consuming anything, fired over the first `n` steps,
number at most the initial weighted token count. -/
theorem takers_within (fires : N.Fires σ M₀) (loses : ∀ t f, f ∈ σ t → N.Loses y ps f) (n : Nat) :
    total (steps 0 n) ((N.flow y σ).takers ps) ≤ total ps fun p => y p * M₀ p :=
  Nat.le_trans (Nat.le_add_left _ _)
    ((fires.balances y).takers_within 0 n fun t _ f fired => loses t f fired)

/-- So for a net with finitely many places, firing transitions that consume does not recur. -/
theorem taking_not_recurring [DecidableEq P] (distinct : Distinct ps) (every : ∀ p, p ∈ ps)
    (fires : N.Fires σ M₀) (loses : ∀ t f, f ∈ σ t → N.Loses y ps f) :
    ¬ ∀ n, ∃ t, n ≤ t ∧ 0 < (N.flow y σ).takers ps t :=
  ((dissipative_iff distinct every).mpr loses).finite_taking_not_recurring (fires.balances y)
    distinct every ps

variable (N) in
/-- The places marked at step `t`, in units. -/
def marked (y : P → Nat) (σ : Nat → List T) (M₀ : P → Nat) (ps : List P) (t : Nat) : List P :=
  keep (fun p => 0 < y p * N.marking σ M₀ t p) ps

theorem marked_census (distinct : Distinct ps) (every : ∀ p, p ∈ ps) :
    (N.web y σ M₀).StandingCensus (marked N y σ M₀ ps) :=
  fun _ => ⟨keep_distinct distinct, fun p =>
    ⟨fun positive => mem_keep.mpr ⟨every p, positive⟩, fun mem => (mem_keep.mp mem).2⟩⟩

/-- **Rest, in the flow form**: for a net with finitely many places, along a firing sequence whose
fired transitions lose, it is not the case that after every step a later change of some place's
weighted marking stays unrefuted. -/
theorem change_stops_unrefuted [DecidableEq P] (distinct : Distinct ps) (every : ∀ p, p ∈ ps)
    (fires : N.Fires σ M₀) (loses : ∀ t f, f ∈ σ t → N.Loses y ps f) :
    ¬ ∀ n, 0 ≤ n → ¬ ¬ ∃ t p, n ≤ t ∧
      ((N.web y σ M₀).Rises t p ∨ (N.web y σ M₀).Falls t p) :=
  Flow.change_stops_unrefuted_around (fires.balances y) ((dissipative_iff distinct every).mpr loses)
    (marked_census distinct every) fun _ _ none_ =>
      none_ ⟨ps, distinct, fun c _ => every c, fun c _ => every c,
        fun _ _ c out => absurd (every c) out⟩

/-- **In tokens**: with every weight positive, that the marking stops changing from some step on
cannot be refuted. -/
theorem marking_stops_unrefuted [DecidableEq P] (distinct : Distinct ps) (every : ∀ p, p ∈ ps)
    (positive : ∀ p, 0 < y p) (fires : N.Fires σ M₀) (loses : ∀ t f, f ∈ σ t → N.Loses y ps f) :
    ¬ ∀ n, ¬ ¬ ∃ t p, n ≤ t ∧ N.marking σ M₀ (t + 1) p ≠ N.marking σ M₀ t p :=
  fun changing => change_stops_unrefuted distinct every fires loses fun n _ none_ =>
    changing n fun ⟨t, p, later, changes⟩ => none_ ⟨t, p, later,
      match Nat.lt_or_gt_of_ne changes with
      | .inl falls => .inr (Nat.mul_lt_mul_of_pos_left falls (positive p))
      | .inr rises => .inl (Nat.mul_lt_mul_of_pos_left rises (positive p))⟩

end Laws

/-! ## The siphon law is the joint-excess law -/

theorem one_pos_of {n : Nat} (positive : 0 < one (P := P) p * n) : 0 < n :=
  Nat.lt_of_lt_of_le positive (Nat.le_of_eq (Nat.one_mul n))

/-- A gated place gates the net's flow in tokens. -/
theorem Gated.gates {p : P} {m : Nat} (gated : N.Gated p m) :
    ∀ t f, f ∈ (N.flow one σ).present t → 0 < (N.flow one σ).give t f p →
      (N.web one σ M₀).requires t f p ∧ m ≤ (N.web one σ M₀).need t f p :=
  fun _ f _ gives => match gated f (one_pos_of (p := p) gives) with
  | ⟨consumes, high⟩ => ⟨consumes, Nat.le_trans high (Nat.le_of_eq (Nat.one_mul _).symm)⟩

/-- **The joint-excess law for nets.** Where a place is gated at `m`, `n` steps of a firing
sequence each consuming from it more than they produce, starting below `n + m`, leave every
transition consuming at least `m` tokens from it dead from then on. -/
theorem gated_ends (fires : N.Fires σ M₀) {p : P} {m : Nat} (gated : N.Gated p m) {T₀ n : Nat}
    (excess : ∀ k, k < n → N.produces (σ (T₀ + k)) p < N.consumes (σ (T₀ + k)) p)
    (start : N.marking σ M₀ T₀ p < n + m) :
    ∀ k g, 0 < N.pre g p → m ≤ N.pre g p → ¬ g ∈ σ (T₀ + n + k) :=
  fun k g consumes high =>
    Flow.joint_excess_ends (fires.balances one) acting (fires.dependent one) gated.gates
      (fun k lt => Nat.lt_of_le_of_lt (Nat.le_of_eq ((flow_given _ p).trans (Nat.one_mul _)))
        (Nat.lt_of_lt_of_le (excess k lt)
          (Nat.le_of_eq ((flow_taken _ p).trans (Nat.one_mul _)).symm)))
      (Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.one_mul _)) start) k g consumes
      (Nat.le_trans high (Nat.le_of_eq (Nat.one_mul _).symm))

/-- **The siphon law.** Along a firing sequence, an empty place every producer of which consumes
from it stays empty, and every transition consuming from it is dead. -/
theorem siphon_empty (fires : N.Fires σ M₀) {p : P} (gated : N.Gated p 1) {T₀ : Nat}
    (empty : N.marking σ M₀ T₀ p = 0) :
    ∀ k, N.marking σ M₀ (T₀ + k) p = 0 ∧ ∀ g, 0 < N.pre g p → ¬ g ∈ σ (T₀ + k) :=
  fun k =>
    ⟨eq_zero_of_not_pos fun positive => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le positive
        (Nat.le_of_lt_succ (Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.one_mul _).symm)
          (Flow.stays_below (fires.balances one) acting (fires.dependent one) gated.gates
            (Nat.lt_of_le_of_lt (Nat.le_of_eq ((Nat.one_mul _).trans empty)) (Nat.lt_succ_self 0))
            k)))),
     fun g consumes => gated_ends fires gated (n := 0) (fun _ no => absurd no (Nat.not_lt_zero _))
        (Nat.lt_of_le_of_lt (Nat.le_of_eq empty) (Nat.lt_succ_self 0)) k g consumes consumes⟩

/-! ## Read as a world of places and transitions -/

section Worlds

variable (N)

/-- What a relatum takes from another: a transition from a place, at its weighted
multiplicity. -/
def worldTake (y : P → Nat) : T ⊕ P → T ⊕ P → Nat
  | .inl f => fun c => match c with
    | .inl _ => 0
    | .inr p => y p * N.pre f p
  | .inr _ => fun _ => 0

/-- What a relatum gives another: a transition to a place. -/
def worldGive (y : P → Nat) : T ⊕ P → T ⊕ P → Nat
  | .inl f => fun c => match c with
    | .inl _ => 0
    | .inr p => y p * N.post f p
  | .inr _ => fun _ => 0

/-- Standing: a transition stands at one, the structure of the net; a place at its weighted
marking. -/
def worldLevel (y : P → Nat) (σ : Nat → List T) (M₀ : P → Nat) (t : Nat) : T ⊕ P → Nat
  | .inl _ => 1
  | .inr p => y p * N.marking σ M₀ t p

/-- Activity: a transition always, a place while marked. -/
def worldActive (y : P → Nat) (σ : Nat → List T) (M₀ : P → Nat) (t : Nat) : T ⊕ P → Prop
  | .inl _ => True
  | .inr p => 0 < y p * N.marking σ M₀ t p

/-- A transition requires the places it consumes from. -/
def worldRequires : T ⊕ P → T ⊕ P → Prop
  | .inl f => fun c => match c with
    | .inl _ => False
    | .inr p => 0 < N.pre f p
  | .inr _ => fun _ => False

/-- At its weighted multiplicity. -/
def worldNeed (y : P → Nat) : T ⊕ P → T ⊕ P → Nat
  | .inl f => fun c => match c with
    | .inl _ => 0
    | .inr p => y p * N.pre f p
  | .inr _ => fun _ => 0

/-- The net read as a world: its places and transitions are its relata, the transitions fired
at a step take part in it. -/
def world (y : P → Nat) (σ : Nat → List T) (M₀ : P → Nat) : World :=
  World.of (T ⊕ P) (⟨fun t => (σ t).map Sum.inl, fun _ => N.worldTake y, fun _ => N.worldGive y⟩) (⟨N.worldLevel y σ M₀, N.worldActive y σ M₀, fun _ => N.worldRequires, fun _ => N.worldNeed y,
      fun _ => N.worldRequires⟩)

variable {N}

theorem inl_not_mem_inr {f : T} {l : List P} : ¬ (Sum.inl f : T ⊕ P) ∈ l.map Sum.inr :=
  fun mem => match preimage_of_mem_map mem with
  | ⟨_, _, same⟩ => nomatch same

/-- What the transitions fired take from a relatum is the flow's uptake at a place, and nothing
at a transition. -/
theorem world_taken (t : Nat) :
    ∀ x, (N.world y σ M₀).flow.taken t x =
      match x with
      | .inl _ => 0
      | .inr p => (N.flow y σ).taken t p
  | .inl _ => (total_map Sum.inl _ (σ t)).trans (total_zero (σ t))
  | .inr _ => total_map Sum.inl _ (σ t)

theorem world_given (t : Nat) :
    ∀ x, (N.world y σ M₀).flow.given t x =
      match x with
      | .inl _ => 0
      | .inr p => (N.flow y σ).given t p
  | .inl _ => (total_map Sum.inl _ (σ t)).trans (total_zero (σ t))
  | .inr _ => total_map Sum.inl _ (σ t)

/-- Along a firing sequence the world balances. -/
theorem Fires.world_balanced (fires : N.Fires σ M₀) (y : P → Nat) :
    (N.world y σ M₀).Balanced :=
  fun t x => match x with
  | .inl g => (congrArg (1 + ·) (world_taken (y := y) (σ := σ) (M₀ := M₀) t (.inl g))).trans
      (congrArg (1 + ·) (world_given (y := y) (σ := σ) (M₀ := M₀) t (.inl g))).symm
  | .inr p => (congrArg (y p * N.marking σ M₀ (t + 1) p + ·) (world_taken t (.inr p))).trans
      ((fires.balances y t p).trans
        (congrArg (y p * N.marking σ M₀ t p + ·) (world_given t (.inr p))).symm)

/-- Every relatum stands exactly while it is active. -/
theorem world_embodied : (N.world y σ M₀).Embodied :=
  fun x _ => match x with
  | .inl _ => ⟨fun _ => Nat.zero_lt_one, fun _ => trivial⟩
  | .inr _ => Iff.rfl

variable {ts : List T} {ps : List P}

variable (N) in
/-- The relata active at a step: every transition and the places marked. -/
def worldAlive (y : P → Nat) (σ : Nat → List T) (M₀ : P → Nat) (ts : List T) (ps : List P)
    (t : Nat) : List (T ⊕ P) :=
  ts.map Sum.inl ++ (marked N y σ M₀ ps t).map Sum.inr

/-- With finitely many transitions and places, each listed once, the world has a census. -/
theorem world_counted (distinct : Distinct ts) (every : ∀ f, f ∈ ts) (distinct' : Distinct ps)
    (every' : ∀ p, p ∈ ps) : (N.world y σ M₀).Counted :=
  ⟨worldAlive N y σ M₀ ts ps, fun _ =>
    ⟨distinct_append (distinct_map inl_injective distinct)
        (distinct_map inr_injective (keep_distinct distinct'))
        fun _ inside outside => match preimage_of_mem_map inside with
          | ⟨_, _, same⟩ => inl_not_mem_inr (Eq.subst (motive := fun x => x ∈ _) same.symm outside),
     fun x => match x with
      | .inl f => ⟨fun _ => mem_append_of_left _ (mem_map_of (every f)), fun _ => trivial⟩
      | .inr p => ⟨fun positive => mem_append_of_right _
            (mem_map_of (mem_keep.mpr ⟨every' p, positive⟩)),
          fun mem => match mem_append_cases mem with
            | .inl inside => absurd inside inr_not_mem
            | .inr outside => (mem_keep.mp (mem_of_map inr_injective outside)).2⟩⟩⟩

/-- Over a family without repetition outside which a transition exchanges nothing, its exchange
totals what it is over the places. -/
theorem world_total_eq [DecidableEq T] [DecidableEq P] (distinct : Distinct ps)
    (every : ∀ p, p ∈ ps) {cs : List (T ⊕ P)} (distinct' : Distinct cs) {q : T ⊕ P → Nat}
    (places : ∀ g, q (.inl g) = 0) (outside : ∀ c, ¬ c ∈ cs → q c = 0) :
    total cs q = total ps fun p => q (.inr p) :=
  (Nat.le_antisymm
    (total_le_of_support distinct' fun a _ positive => match a with
      | .inl g => absurd (Nat.lt_of_lt_of_le positive (Nat.le_of_eq (places g))) (Nat.lt_irrefl 0)
      | .inr p => mem_map_of (every p))
    (total_le_of_support (distinct_map inr_injective distinct) fun a _ positive =>
      match decideMem a cs with
      | .isTrue mem => mem
      | .isFalse out => absurd (Nat.lt_of_lt_of_le positive (Nat.le_of_eq (outside a out)))
          (Nat.lt_irrefl 0))).trans
    (total_map Sum.inr q ps)

/-- Where every transition fired loses, the world dissipates. -/
theorem world_dissipative [DecidableEq T] [DecidableEq P] (distinct : Distinct ps)
    (every : ∀ p, p ∈ ps) (loses : ∀ t f, f ∈ σ t → N.Loses y ps f) :
    (N.world y σ M₀).Dissipative :=
  fun cs t distinct' closed _ present => match preimage_of_mem_map present with
  | ⟨f, fired, same⟩ =>
    Eq.subst (motive := fun x => total cs ((N.world y σ M₀).flow.give t x) +
        sign (total cs ((N.world y σ M₀).flow.take t x)) ≤
          total cs ((N.world y σ M₀).flow.take t x)) same
      (have give_eq := world_total_eq distinct every distinct' (q := N.worldGive y (.inl f))
          (fun _ => rfl) fun c out => (closed (.inl f) (mem_map_of fired) c out).2
       have take_eq := world_total_eq distinct every distinct' (q := N.worldTake y (.inl f))
          (fun _ => rfl) fun c out => (closed (.inl f) (mem_map_of fired) c out).1
       Nat.le_trans (Nat.le_of_eq (congr (congrArg HAdd.hAdd give_eq) (congrArg sign take_eq)))
         (Nat.le_trans (loses t f fired) (Nat.le_of_eq take_eq.symm)))

/-- Every step of the world is enclosed by the places. -/
theorem world_enclosed (distinct : Distinct ps) (every : ∀ p, p ∈ ps) (t : Nat) :
    (N.world y σ M₀).flow.Enclosed t :=
  ⟨ps.map Sum.inr, distinct_map inr_injective distinct, fun _ present c out =>
    match preimage_of_mem_map present, c with
    | ⟨_, _, same⟩, .inl _ => Eq.subst (motive := fun x =>
        N.worldTake y x (.inl _) = 0 ∧ N.worldGive y x (.inl _) = 0) same ⟨rfl, rfl⟩
    | _, .inr p => absurd (mem_map_of (every p)) out⟩

/-- **Rest, in the world form.** For a net with finitely many transitions and places, along a
firing sequence whose fired transitions lose, every premise of `World.rests_unrefuted_enclosed`
holds, so that the world of places and transitions rests from some step on cannot be refuted:
from some step on, no place is emptied or newly marked. -/
theorem rests_unrefuted [DecidableEq T] [DecidableEq P] (distinct : Distinct ts)
    (every : ∀ f, f ∈ ts) (distinct' : Distinct ps) (every' : ∀ p, p ∈ ps) (fires : N.Fires σ M₀)
    (loses : ∀ t f, f ∈ σ t → N.Loses y ps f) : ¬ ¬ ∃ n, (N.world y σ M₀).RestsFrom n :=
  World.rests_unrefuted_enclosed (world_counted distinct every distinct' every') world_embodied
    (fires.world_balanced y) (world_dissipative distinct' every' loses) (T := 0)
    fun t _ => world_enclosed distinct' every' t

end Worlds

/-! ## Where dissipation fails: the conservative cycle -/

/-- One token moved back and forth between two places: transition `b` moves it from place `b`
to place `!b`. -/
def cycle : Net Bool Bool :=
  ⟨fun f p => match f with
    | true => (match p with | true => 1 | false => 0)
    | false => (match p with | true => 0 | false => 1),
   fun f p => match f with
    | true => (match p with | true => 0 | false => 1)
    | false => (match p with | true => 1 | false => 0)⟩

/-- Which transition fires: alternately. -/
def turn : Nat → Bool
  | 0 => true
  | n + 1 => !turn n

/-- The schedule of the cycle. -/
def cycleRun : Nat → List Bool := fun n => [turn n]

/-- The token starts at place `true`. -/
def cycleStart : Bool → Nat := cycle.pre true

theorem cycle_step : ∀ b p : Bool,
    cycle.pre b p - (cycle.pre b p + 0) + (cycle.post b p + 0) = cycle.pre (!b) p
  | true, true => rfl
  | true, false => rfl
  | false, true => rfl
  | false, false => rfl

/-- The token is where the turn says. -/
theorem cycle_marking : ∀ n p, cycle.marking cycleRun cycleStart n p = cycle.pre (turn n) p
  | 0, _ => rfl
  | n + 1, p => (congrArg (fun l => l - (cycle.pre (turn n) p + 0) + (cycle.post (turn n) p + 0))
      (cycle_marking n p)).trans (cycle_step (turn n) p)

theorem cycle_fires : cycle.Fires cycleRun cycleStart :=
  fun n p => Nat.le_of_eq (cycle_marking n p).symm

/-- Every premise of the rest law holds of the cycle but dissipation: it balances, has a census,
is embodied, and every step is enclosed. -/
theorem cycle_premises :
    (cycle.world one cycleRun cycleStart).Balanced ∧
      (cycle.world one cycleRun cycleStart).Counted ∧
      (cycle.world one cycleRun cycleStart).Embodied ∧
      ∀ t, (cycle.world one cycleRun cycleStart).flow.Enclosed t :=
  ⟨cycle_fires.world_balanced one, world_counted Shuttle.distinct ListTests.mem_bools Shuttle.distinct ListTests.mem_bools,
    world_embodied, world_enclosed Shuttle.distinct ListTests.mem_bools⟩

/-- The cycle conserves its token: its transitions do not lose, so its flow is not
dissipative. -/
theorem cycle_not_dissipative : ¬ (cycle.flow one cycleRun).Dissipative :=
  fun dissipative => Nat.not_succ_le_self 1
    ((dissipative_iff Shuttle.distinct ListTests.mem_bools).mp dissipative 0 true (.head _))

/-- Place `true` gains or loses its token at every step. -/
theorem cycle_flips (t : Nat) :
    (cycle.marking cycleRun cycleStart t true = 1 ∧ cycle.marking cycleRun cycleStart (t + 1) true = 0) ∨
      (cycle.marking cycleRun cycleStart t true = 0 ∧
        cycle.marking cycleRun cycleStart (t + 1) true = 1) :=
  match h : turn t with
  | true => .inl ⟨(cycle_marking t true).trans (congrArg (cycle.pre · true) h),
      (cycle_marking (t + 1) true).trans (congrArg (fun b => cycle.pre (!b) true) h)⟩
  | false => .inr ⟨(cycle_marking t true).trans (congrArg (cycle.pre · true) h),
      (cycle_marking (t + 1) true).trans (congrArg (fun b => cycle.pre (!b) true) h)⟩

/-- **Without dissipation the rest law fails**: the cycle's marking changes at every step, so the
conclusion of `Net.change_stops_unrefuted` is false of it. -/
theorem cycle_changes :
    ∀ n, 0 ≤ n → ¬ ¬ ∃ t p, n ≤ t ∧
      ((cycle.web one cycleRun cycleStart).Rises t p ∨ (cycle.web one cycleRun cycleStart).Falls t p) :=
  fun n _ none_ => none_ ⟨n, true, Nat.le_refl n, match cycle_flips n with
    | .inl ⟨now, next⟩ => .inr (Nat.lt_of_le_of_lt
        (Nat.le_of_eq ((Nat.one_mul _).trans next)) (Nat.lt_of_lt_of_le Nat.zero_lt_one
          (Nat.le_of_eq ((Nat.one_mul _).trans now).symm)))
    | .inr ⟨now, next⟩ => .inl (Nat.lt_of_le_of_lt
        (Nat.le_of_eq ((Nat.one_mul _).trans now)) (Nat.lt_of_lt_of_le Nat.zero_lt_one
          (Nat.le_of_eq ((Nat.one_mul _).trans next).symm)))⟩

/-- **And its world never rests**: at every step place `true` is emptied or newly marked. -/
theorem cycle_never_rests : ¬ ∃ n, (cycle.world one cycleRun cycleStart).RestsFrom n :=
  fun ⟨n, rests⟩ => match cycle_flips n with
  | .inl ⟨now, next⟩ => (rests n (Nat.le_refl n) (.inr true)).2
      ⟨Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_of_eq ((Nat.one_mul _).trans now).symm),
       fun positive => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le positive
         (Nat.le_of_eq ((Nat.one_mul _).trans next)))⟩
  | .inr ⟨now, next⟩ => (rests n (Nat.le_refl n) (.inr true)).1
      ⟨fun positive => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le positive
         (Nat.le_of_eq ((Nat.one_mul _).trans now))),
       Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_of_eq ((Nat.one_mul _).trans next).symm)⟩

/-! ## Where gating fails: the fed place -/

/-- Place `true` is consumed by transition `true` and fed from place `false` by transition
`false`, which does not consume it. -/
def fed : Net Bool Bool :=
  ⟨cycle.pre, fun f p => match f with
    | true => 0
    | false => (match p with | true => 1 | false => 0)⟩

/-- Consume, feed, consume, then nothing. -/
def fedRun : Nat → List Bool
  | 0 => [true]
  | 1 => [false]
  | 2 => [true]
  | _ + 3 => []

theorem fed_fires : fed.Fires fedRun fun _ => 1
  | 0, true => Nat.le_refl 1
  | 0, false => Nat.zero_le _
  | 1, true => Nat.zero_le _
  | 1, false => Nat.le_refl 1
  | 2, true => Nat.le_refl 1
  | 2, false => Nat.zero_le _
  | _ + 3, _ => Nat.zero_le _

/-- **Without gating the siphon law fails**: the fed place's flow balances its markings, one step
consumes from place `true` more than it produces there, starting at one token, below `1 + 1`, and
yet a transition requiring the place at need one is active two steps later: the feeder produces
into the place without consuming from it, so the place is not gated and the conclusion of
`Flow.joint_excess_ends` fails. -/
theorem fed_refills :
    (fed.flow one fedRun).Balances (fed.web one fedRun fun _ => 1) ∧
      ¬ fed.Gated true 1 ∧
      (∀ k, k < 1 → (fed.flow one fedRun).given (0 + k) true < (fed.flow one fedRun).taken (0 + k) true) ∧
      (fed.web one fedRun fun _ => 1).level 0 true < 1 + 1 ∧
      ¬ ∀ k g, (fed.web one fedRun fun _ => 1).requires (0 + 1 + k) g true →
        1 ≤ (fed.web one fedRun fun _ => 1).need (0 + 1 + k) g true →
        ¬ (fed.web one fedRun fun _ => 1).active (0 + 1 + k) g :=
  ⟨fed_fires.balances one,
   fun gated => Nat.lt_irrefl 0 (gated false Nat.zero_lt_one).1,
   fun k => match k with
    | 0 => fun _ => Nat.zero_lt_one
    | k + 1 => fun lt => absurd (Nat.lt_of_succ_lt_succ lt) (Nat.not_lt_zero k),
   Nat.lt_succ_self 1,
   fun dead => dead 1 true Nat.zero_lt_one (Nat.le_refl 1) (.head _)⟩

end Net

end Becoming
