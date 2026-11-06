import Becoming.Counterfactual
import Becoming.Imbalance
import Becoming.Premises

/-!
# Reading: activity, drawing and requirement read off the exchange

Ren, 14 October 2026: “why do we need "World"? wasn't this about the whole and its parts, about
everything?”, and then “please, finish all”, approving the re-founding that counts the rest of the
whole as a relatum (`Becoming.Imbalance`, proved equivalent there) and reads activity and
dependence off the exchange. A web carries five readings of one exchange: levels, activity,
requirement, need and drawing. Four of the eight premises of `Becoming.Premises` tie these
readings to the exchange or to one another, and this module reads them off the exchange so that
the ties hold by what the readings are.

* **Activity and drawing read off the exchange.** A formation exchanges across a step where it
  takes part and takes or gives something (`Flow.Exchanging`). The web read off a flow takes its
  levels, requirements and needs as given, counts a formation active exactly where it exchanges,
  and counts it drawing on exactly what it takes from (`Flow.readOff`). Read so, only active
  relata give (`Flow.readOff_acting`) and only active relata take, and only what they draw on
  (`Flow.readOff_taking`), whatever the flow. For any web, those two premises hold exactly where
  its activity and drawing include what is read off the exchange
  (`Flow.acting_taking_iff_wider`). With the formations taking part listed once and their
  exchanging decided, the relata active at each step are listed (`Flow.readOff_census`).
* **The rest counted.** With the rest of the whole counted as a relatum, `none`
  (`Flow.withImbalance`), and activity read off its exchange (`Flow.adopt`), every flow balances
  (`Flow.withImbalance_balances`), only active relata give and take (`Flow.readOff_acting`,
  `Flow.readOff_taking`), a formation of the flow exchanges as it did (`Flow.exchanging_some_iff`),
  and the relata active at each step are listed where the formations taking part are listed once
  and exchanging is decided (`Flow.adopt_census`). Balance is no longer supposed: the flow balances
  across a step exactly where the rest is not active there (`Flow.rest_idle_at_iff`), and at every
  step exactly where the rest is never active (`Flow.rest_idle_iff`). Activity needs support
  exactly where every formation that exchanges is supported (`Flow.adopt_dependent_iff`).
* **Requirement read off a law.** Under a law of exchange (`ExchangeLaw`), a formation's exchange
  across a step responds to a condition falling below a need where, under every history that
  differs from the actual one at most in that condition's level at that step, with the level below
  the need, the formation does not exchange (`ExchangeLaw.RespondsBelow`). Read as requirement, a
  formation that exchanges is supported: the actual history is one of those histories
  (`ExchangeLaw.supported_of_responds`). So the web read off the course a law generates, with this
  requirement (`ExchangeLaw.readWeb`), meets activity needing support for every need
  (`ExchangeLaw.readWeb_dependent`), and with the rest counted all four tying premises hold with no
  premise (`ExchangeLaw.reading_glue`). Under a law reading what has stood, the rest is never
  active exactly where the course is feasible (`ExchangeLaw.rest_idle_iff_feasible`).
* **Every world with its rest counted.** A world's rest is counted as a relatum
  (`World.withRest`): its relata are the world's and the rest, activity and drawing are read off
  the exchange with the rest counted, and standings, requirements and needs are the world's. Then
  every world balances (`World.withRest_balanced`), only active relata give and take
  (`Flow.readOff_acting`, `Flow.readOff_taking`), and a relatum of the world exchanges as it
  did (`World.withRest_exchanging_iff`). The world balances exactly where the rest is never active
  (`World.withRest_closed_iff`), and activity needs support exactly where every relatum that
  exchanges is supported (`World.withRest_dependent_iff`). Read off a law over one kind of relatum
  (`ExchangeLaw.readWorld`), the four tying premises hold with no premise
  (`ExchangeLaw.readWorld_glue`), and under a law reading what has stood the rest is never active
  exactly where the course is feasible (`ExchangeLaw.readWorld_closed_iff`).
* **The requirement is not in the course.** `ExchangeLaw.responsive` exchanges one unit with the
  condition where it stands, and `ExchangeLaw.unresponsive` whatever stands. From one start they
  generate one course, the same levels and the same exchange at every step; read off the laws, the
  formation requires its condition at need one at every step under the first and at no step under
  the second (`ExchangeLaw.requirement_beyond_course`). Requirement is a counterfactual of the law,
  and no history fixes it.

**Readings (the AI's, adopted on Ren's delegation of 15 October 2026, DELEGATED-CHOICES D27, D28).**
Of the eight premises, balance, only active relata giving, only active relata taking and only from
what they draw on, and activity needing support tie readings of one exchange together: read off the
exchange, with the rest counted and requirement read as what the exchange responds to, they hold by
what the readings are. What remains are states of parts: that the rest is idle (closure, which for a
law is feasibility), dissipation (loss), that a relatum exchanges exactly while it stands
(embodiment; a relatum standing while it does not exchange is dormant), bounded transmission of
dependence, and that exchanging is decided where the active relata are to be listed. The
independence of `World.independent` is the freedom of separately chosen readings: in its witnesses
for these four premises a reading is chosen apart from the exchange it reads.

What is not derived: which law of exchange holds; that a formation's exchange responds to any
condition; the need at which it responds; and the states of parts named above. No ethical
predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {F C : Type}

/-! ## Activity and drawing read off the exchange -/

namespace Flow

variable (L : Flow F C)

/-- `f` exchanges across the step from `t`: it takes part and takes or gives something. -/
def Exchanging (t : Nat) (f : F) : Prop :=
  f ∈ L.present t ∧ ∃ c, 0 < L.take t f c ∨ 0 < L.give t f c

/-- The web read off the exchange: the levels, requirements and needs given, a formation active
exactly where it exchanges, and drawing on exactly what it takes from. -/
def readOff (level : Nat → C → Nat) (requires : Nat → F → C → Prop)
    (need : Nat → F → C → Nat) : Web F C :=
  ⟨level, L.Exchanging, requires, need, fun t f c => 0 < L.take t f c⟩

variable {L} {level : Nat → C → Nat} {requires : Nat → F → C → Prop} {need : Nat → F → C → Nat}

/-- Read off the exchange, only active relata give. -/
theorem readOff_acting : L.Acting (L.readOff level requires need) :=
  fun _ _ c present gives => ⟨present, c, .inr gives⟩

/-- Read off the exchange, only active relata take, and only what they draw on. -/
theorem readOff_taking : L.Taking (L.readOff level requires need) :=
  fun _ _ c present takes => ⟨⟨present, c, .inl takes⟩, takes⟩

/-- **The two activity premises tie readings.** For any web, only active relata give and only
active relata take, and only what they draw on, exactly where its activity includes every
formation that exchanges and its drawing includes what each takes from. -/
theorem acting_taking_iff_wider {W : Web F C} :
    (L.Acting W ∧ L.Taking W) ↔
      ∀ t f, L.Exchanging t f → W.active t f ∧ ∀ c, 0 < L.take t f c → W.draws t f c :=
  ⟨fun ⟨acting, taking⟩ t f ⟨present, c, exchanged⟩ =>
    ⟨match exchanged with
      | .inl takes => (taking t f c present takes).1
      | .inr gives => acting t f c present gives,
     fun c' takes => (taking t f c' present takes).2⟩,
   fun wider => ⟨fun t f c present gives => (wider t f ⟨present, c, .inr gives⟩).1,
     fun t f c present takes => ⟨(wider t f ⟨present, c, .inl takes⟩).1,
       (wider t f ⟨present, c, .inl takes⟩).2 c takes⟩⟩⟩

/-- With the formations taking part listed once and exchanging decided, the relata active at each
step are listed: those taking part that exchange. -/
theorem readOff_census (distinct : ∀ t, Distinct (L.present t))
    [∀ t f, Decidable (L.Exchanging t f)] :
    (L.readOff level requires need).Census fun t => keep (L.Exchanging t) (L.present t) :=
  fun t => ⟨keep_distinct (distinct t), fun _ =>
    ⟨fun exchanging => mem_keep.mpr ⟨exchanging.1, exchanging⟩, fun mem => (mem_keep.mp mem).2⟩⟩

/-! ## The rest counted -/

/-- The web with the rest of the whole counted as a relatum, `none`: activity and drawing read off
the exchange of the flow with the rest counted (`Flow.withImbalance`), the levels, requirements and
needs the web's, the rest requiring nothing. -/
def adopt (L : Flow F C) (W : Web F C) : Web (Option F) C :=
  (L.withImbalance W).readOff W.level W.withRefinement.requires W.withRefinement.need

variable {W : Web F C}

/-- A formation of the flow takes part with the rest counted exactly where it takes part. -/
theorem some_mem_present {t : Nat} {g : F} :
    some g ∈ (L.withImbalance W).present t ↔ g ∈ L.present t :=
  ⟨fun mem => match mem with
    | .tail _ inner => mem_of_some_mem inner,
   fun mem => .tail _ (mem_map_some mem)⟩

/-- A formation of the flow exchanges with the rest counted exactly where it exchanges. -/
theorem exchanging_some_iff {t : Nat} {g : F} :
    (L.withImbalance W).Exchanging t (some g) ↔ L.Exchanging t g :=
  ⟨fun ⟨mem, c, exchanged⟩ => ⟨some_mem_present.mp mem, c, exchanged⟩,
   fun ⟨mem, c, exchanged⟩ => ⟨some_mem_present.mpr mem, c, exchanged⟩⟩

/-- **Closure is the rest idle.** The flow balances across the step from `t` at every condition
exactly where the rest is not active there. -/
theorem rest_idle_at_iff {t : Nat} :
    ¬ (L.adopt W).active t none ↔
      ∀ c, W.level (t + 1) c + L.taken t c = W.level t c + L.given t c :=
  ⟨fun idle c => Nat.le_antisymm
      (le_of_sub_eq_zero (eq_zero_of_not_pos fun pos => idle ⟨.head _, c, .inr pos⟩))
      (le_of_sub_eq_zero (eq_zero_of_not_pos fun pos => idle ⟨.head _, c, .inl pos⟩)),
   fun balanced ⟨_, c, exchanged⟩ => match exchanged with
     | .inl takes => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le takes
         (Nat.le_of_eq (sub_eq_zero_of_le (Nat.le_of_eq (balanced c).symm))))
     | .inr gives => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le gives
         (Nat.le_of_eq (sub_eq_zero_of_le (Nat.le_of_eq (balanced c)))))⟩

/-- The flow balances exactly where the rest is never active. -/
theorem rest_idle_iff : (∀ t, ¬ (L.adopt W).active t none) ↔ L.Balances W :=
  ⟨fun idle t c => rest_idle_at_iff.mp (idle t) c, fun balances t => rest_idle_at_iff.mpr (balances t)⟩

/-- With the rest counted, activity needs support exactly where every formation that exchanges is
supported. -/
theorem adopt_dependent_iff :
    (L.adopt W).Dependent ↔ ∀ t g, L.Exchanging t g → W.Supported t g :=
  ⟨fun dependent t g exchanging => dependent t (some g) (exchanging_some_iff.mpr exchanging),
   fun supported t f => match f with
     | none => fun _ _ required => False.elim required
     | some g => fun exchanging => supported t g (exchanging_some_iff.mp exchanging)⟩

/-- With the rest counted, the formations taking part are listed once where those of the flow
are. -/
theorem present_distinct {t : Nat} (distinct : Distinct (L.present t)) :
    Distinct ((L.withImbalance W).present t) :=
  ⟨ListTests.none_not_mem_map_some, distinct_map (fun _ _ same => Option.some.inj same) distinct⟩

/-- With the rest counted, the formations of the flow listed once and exchanging decided, the
relata active at each step are listed. -/
theorem adopt_census (distinct : ∀ t, Distinct (L.present t))
    [∀ t f, Decidable ((L.withImbalance W).Exchanging t f)] :
    (L.adopt W).Census fun t =>
      keep ((L.withImbalance W).Exchanging t) ((L.withImbalance W).present t) :=
  readOff_census fun _ => present_distinct (distinct _)

end Flow

/-! ## Requirement read off a law -/

namespace ExchangeLaw

variable (law : ExchangeLaw F C) (present : Nat → List F)

/-- Under the history `l`, `f` exchanges across the step from `t`. -/
def ExchangesUnder (l : Nat → C → Nat) (t : Nat) (f : F) : Prop :=
  f ∈ present t ∧ ∃ c, 0 < law.take t f l c ∨ 0 < law.give t f l c

/-- `f`'s exchange across the step from `t` responds to `c` falling below `n`: under every
history differing from `l` at most in `c`'s level at `t`, with that level below `n`, `f` does not
exchange. -/
def RespondsBelow (l : Nat → C → Nat) (t : Nat) (f : F) (c : C) (n : Nat) : Prop :=
  ∀ l' : Nat → C → Nat, (∀ s d, ¬ (s = t ∧ d = c) → l' s d = l s d) → l' t c < n →
    ¬ law.ExchangesUnder present l' t f

/-- The web read off the course the law generates: activity and drawing read off its exchange,
and a formation requiring a condition at its need exactly where its exchange responds to the
condition falling below that need. -/
def readWeb (start : C → Nat) (need : Nat → F → C → Nat) : Web F C :=
  (law.course present start).readOff (law.levels present start)
    (fun t f c => law.RespondsBelow present (law.levels present start) t f c (need t f c)) need

variable {law present}

/-- **A formation that exchanges is supported where its exchange responds**: the actual history
is one of the histories the response ranges over. -/
theorem supported_of_responds {l : Nat → C → Nat} {t : Nat} {f : F} {c : C} {n : Nat}
    (exchanges : law.ExchangesUnder present l t f)
    (responds : law.RespondsBelow present l t f c n) : n ≤ l t c :=
  Nat.ge_of_not_lt fun below => responds l (fun _ _ _ => rfl) below exchanges

/-- Read off the law, activity needs support, for every need. -/
theorem readWeb_dependent (start : C → Nat) (need : Nat → F → C → Nat) :
    (law.readWeb present start need).Dependent :=
  fun _ _ exchanging _ responds =>
    supported_of_responds (l := law.levels present start) exchanging responds

/-- **The four tying premises hold, with no premise.** With the rest counted and activity,
drawing and requirement read off the law, the flow balances, only active relata give, only active
relata take and only what they draw on, and activity needs support. -/
theorem reading_glue (start : C → Nat) (need : Nat → F → C → Nat) :
    ((law.course present start).withImbalance (law.readWeb present start need)).Balances
        ((law.course present start).adopt (law.readWeb present start need)) ∧
      ((law.course present start).withImbalance (law.readWeb present start need)).Acting
        ((law.course present start).adopt (law.readWeb present start need)) ∧
      ((law.course present start).withImbalance (law.readWeb present start need)).Taking
        ((law.course present start).adopt (law.readWeb present start need)) ∧
      ((law.course present start).adopt (law.readWeb present start need)).Dependent :=
  ⟨Flow.withImbalance_balances, Flow.readOff_acting, Flow.readOff_taking,
   Flow.adopt_dependent_iff.mpr fun t g exchanging => readWeb_dependent start need t g exchanging⟩

/-- Under a law of what has stood, the rest is never active exactly where the course is
feasible. -/
theorem rest_idle_iff_feasible (na : law.Nonanticipating) (start : C → Nat)
    (need : Nat → F → C → Nat) :
    (∀ t, ¬ ((law.course present start).adopt (law.readWeb present start need)).active t none) ↔
      law.Feasible present start :=
  Flow.rest_idle_iff.trans
    (course_balances_iff (present := present) (start := start) na (law.readWeb present start need))

/-! ## The requirement is not in the course -/

/-- One formation, taking part at every step. -/
def single : Nat → List Unit := fun _ => [()]

/-- Exchanging one unit with the condition, taken and given back, exactly where it stands. -/
def responsive : ExchangeLaw Unit Unit :=
  ⟨fun t _ l c => sign (l t c), fun t _ l c => sign (l t c)⟩

/-- Exchanging one unit with the condition, taken and given back, whatever stands. -/
def unresponsive : ExchangeLaw Unit Unit :=
  ⟨fun _ _ _ _ => 1, fun _ _ _ _ => 1⟩

/-- A need of one at every step. -/
def needOne : Nat → Unit → Unit → Nat := fun _ _ _ => 1

/-- From a level of one, the responsive law keeps the level at one. -/
theorem responsive_levels : ∀ t c, responsive.levels single (fun _ => 1) t c = 1
  | 0, _ => rfl
  | t + 1, c => (levels_succ (law := responsive) (present := single) (start := fun _ => 1) t c).trans
      ((Naturals.add_sub_cancel _ _).trans (responsive_levels t c))

/-- From a level of one, so does the unresponsive law. -/
theorem unresponsive_levels : ∀ t c, unresponsive.levels single (fun _ => 1) t c = 1
  | 0, _ => rfl
  | t + 1, c =>
    (levels_succ (law := unresponsive) (present := single) (start := fun _ => 1) t c).trans
      ((Naturals.add_sub_cancel _ _).trans (unresponsive_levels t c))

/-- Under the responsive law the formation requires its condition at need one at every step. -/
theorem responsive_requires (t : Nat) :
    (responsive.readWeb single (fun _ => 1) needOne).requires t () () :=
  fun l' _ below ⟨_, c, exchanged⟩ =>
    have zero : l' t () = 0 := Nat.eq_zero_of_le_zero (Nat.le_of_lt_succ below)
    match c, exchanged with
    | (), .inl takes => Nat.lt_irrefl 0 (Eq.subst (motive := fun x => 0 < sign x) zero takes)
    | (), .inr gives => Nat.lt_irrefl 0 (Eq.subst (motive := fun x => 0 < sign x) zero gives)

/-- Under the unresponsive law it requires its condition at need one at no step. -/
theorem unresponsive_unrequired (t : Nat) :
    ¬ (unresponsive.readWeb single (fun _ => 1) needOne).requires t () () :=
  let l' : Nat → Unit → Nat := fun s _ => if s = t then 0 else 1
  have here : l' t () = 0 := if_pos rfl
  have elsewhere : ∀ s d, ¬ (s = t ∧ d = ()) →
      l' s d = unresponsive.levels single (fun _ => 1) s d :=
    fun s d other => (if_neg fun same => other ⟨same, rfl⟩).trans (unresponsive_levels s d).symm
  fun responds => responds l' elsewhere
    (Eq.subst (motive := fun x => x < 1) here.symm Nat.zero_lt_one) ⟨.head _, (), .inl Nat.zero_lt_one⟩

/-- **The requirement is not in the course.** From one start the responsive and the unresponsive
laws generate one course: the same levels at every step and the same exchange. Read off the laws,
the formation requires its condition at need one at every step under the first and at no step
under the second. -/
theorem requirement_beyond_course :
    ((∀ t c, responsive.levels single (fun _ => 1) t c = unresponsive.levels single (fun _ => 1) t c) ∧
      ∀ t f c,
        (responsive.course single (fun _ => 1)).take t f c =
            (unresponsive.course single (fun _ => 1)).take t f c ∧
          (responsive.course single (fun _ => 1)).give t f c =
            (unresponsive.course single (fun _ => 1)).give t f c) ∧
      (∀ t, (responsive.readWeb single (fun _ => 1) needOne).requires t () ()) ∧
      ∀ t, ¬ (unresponsive.readWeb single (fun _ => 1) needOne).requires t () () :=
  ⟨⟨fun t c => (responsive_levels t c).trans (unresponsive_levels t c).symm,
    fun t _ c => ⟨congrArg sign (responsive_levels t c), congrArg sign (responsive_levels t c)⟩⟩,
   responsive_requires, unresponsive_unrequired⟩

end ExchangeLaw

/-! ## The rest counted in a world -/

namespace World

variable (w : World)

/-- The flow of a world with the rest of the whole counted as one more relatum, `none`: the rest
takes part at every step and exchanges what the standings show beyond the world's exchange
(`Flow.withImbalance`); as a condition it stands at nothing, and nothing exchanges with it. -/
def restFlow : Flow (Option w.Relatum) (Option w.Relatum) :=
  ⟨(w.flow.withImbalance w.web).present,
   fun t f c => match c with
     | none => 0
     | some d => (w.flow.withImbalance w.web).take t f d,
   fun t f c => match c with
     | none => 0
     | some d => (w.flow.withImbalance w.web).give t f d⟩

/-- The world's standings, the rest standing at nothing. -/
def restLevel (t : Nat) : Option w.Relatum → Nat
  | none => 0
  | some d => w.web.level t d

/-- The world's requirements, the rest requiring nothing and required by nothing. -/
def restRequires (t : Nat) : Option w.Relatum → Option w.Relatum → Prop
  | none, _ => False
  | some _, none => False
  | some g, some d => w.web.requires t g d

/-- The world's needs. -/
def restNeed (t : Nat) : Option w.Relatum → Option w.Relatum → Nat
  | none, _ => 0
  | some _, none => 0
  | some g, some d => w.web.need t g d

/-- **The world with the rest counted.** Its relata are the world's and the rest; activity and
drawing are read off the exchange with the rest counted (`Flow.readOff`), and standings,
requirements and needs are the world's. -/
def withRest : World :=
  World.of (Option w.Relatum) w.restFlow (w.restFlow.readOff w.restLevel w.restRequires w.restNeed)

variable {w}

/-- With the rest counted, every world balances. -/
theorem withRest_balanced : w.withRest.Balanced :=
  fun t c => match c with
  | none => rfl
  | some d => Flow.withImbalance_balances (L := w.flow) (W := w.web) t d

/-- A relatum of the world exchanges with the rest counted exactly where it exchanges. -/
theorem withRest_exchanging_iff {t : Nat} {x : w.Relatum} :
    w.restFlow.Exchanging t (some x) ↔ w.flow.Exchanging t x :=
  ⟨fun ⟨mem, c, exchanged⟩ => match c, exchanged with
     | some d, exchanged => ⟨(Flow.some_mem_present (L := w.flow) (W := w.web)).mp mem, d, exchanged⟩
     | none, .inl takes => absurd takes (Nat.lt_irrefl 0)
     | none, .inr gives => absurd gives (Nat.lt_irrefl 0),
   fun ⟨mem, d, exchanged⟩ =>
     ⟨(Flow.some_mem_present (L := w.flow) (W := w.web)).mpr mem, some d, exchanged⟩⟩

/-- The rest exchanges in the world exactly where it exchanges in the flow with the rest
counted. -/
theorem withRest_rest_iff {t : Nat} :
    w.restFlow.Exchanging t none ↔ (w.flow.withImbalance w.web).Exchanging t none :=
  ⟨fun ⟨mem, c, exchanged⟩ => match c, exchanged with
     | some d, exchanged => ⟨mem, d, exchanged⟩
     | none, .inl takes => absurd takes (Nat.lt_irrefl 0)
     | none, .inr gives => absurd gives (Nat.lt_irrefl 0),
   fun ⟨mem, d, exchanged⟩ => ⟨mem, some d, exchanged⟩⟩

/-- **Closure is the rest idle**, in a world: it balances exactly where, with the rest counted,
the rest is never active. -/
theorem withRest_closed_iff : (∀ t, ¬ w.withRest.web.active t none) ↔ w.Balanced :=
  ⟨fun idle => (Flow.rest_idle_iff (L := w.flow) (W := w.web)).mp
      fun t active => idle t (withRest_rest_iff.mpr active),
   fun balanced t active =>
     (Flow.rest_idle_iff (L := w.flow) (W := w.web)).mpr balanced t (withRest_rest_iff.mp active)⟩

/-- With the rest counted, activity needs support exactly where every relatum of the world that
exchanges is supported. -/
theorem withRest_dependent_iff :
    w.withRest.Dependent ↔ ∀ t x, w.flow.Exchanging t x → w.web.Supported t x :=
  ⟨fun dependent t x exchanging d required =>
     dependent t (some x) (withRest_exchanging_iff.mpr exchanging) (some d) required,
   fun supported t f => match f with
     | none => fun _ _ required => False.elim required
     | some x => fun exchanging c => match c with
       | none => fun required => False.elim required
       | some d => fun required => supported t x (withRest_exchanging_iff.mp exchanging) d required⟩

end World

namespace ExchangeLaw

/-- The course a law generates over one kind of relatum, read as a world with activity, drawing
and requirement read off the law. -/
def readWorld {R : Type} (law : ExchangeLaw R R) (present : Nat → List R) (start : R → Nat)
    (need : Nat → R → R → Nat) : World :=
  World.of R (law.course present start) (law.readWeb present start need)

variable {R : Type} {law : ExchangeLaw R R} {present : Nat → List R} {start : R → Nat}
  {need : Nat → R → R → Nat}

/-- **The four tying premises of a world hold, with no premise.** Read off a law over one kind of
relatum, with the rest counted, the world balances, only active relata give, only active relata
take and only what they draw on, and activity needs support. -/
theorem readWorld_glue :
    (law.readWorld present start need).withRest.Balanced ∧
      (law.readWorld present start need).withRest.Acting ∧
      (law.readWorld present start need).withRest.Taking ∧
      (law.readWorld present start need).withRest.Dependent :=
  ⟨World.withRest_balanced, Flow.readOff_acting, Flow.readOff_taking,
   World.withRest_dependent_iff.mpr fun t x exchanging =>
     readWeb_dependent (law := law) (present := present) start need t x exchanging⟩

/-- Under a law of what has stood, the rest is never active exactly where the course is
feasible. -/
theorem readWorld_closed_iff (na : law.Nonanticipating) :
    (∀ t, ¬ (law.readWorld present start need).withRest.web.active t none) ↔
      law.Feasible present start :=
  World.withRest_closed_iff.trans
    (course_balances_iff (present := present) (start := start) na (law.readWeb present start need))

end ExchangeLaw

end Becoming
