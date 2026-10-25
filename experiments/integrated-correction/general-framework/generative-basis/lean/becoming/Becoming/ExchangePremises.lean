import Becoming.Reading
import Becoming.Change

/-!
# Exchange premises: which of the remaining premises a reading of the exchange settles

`Becoming.Reading` reads activity, drawing and requirement off the exchange and counts the rest of
the whole as a relatum (`World.withRest`); there four of the eight premises of `Becoming.Premises`
hold by reading, and the rest idle is closure, which for a law of exchange reading what has stood is
feasibility (`ExchangeLaw.readWorld_closed_iff`). This module settles the other four, dissipation,
embodiment, the census and bounded transmission, for worlds read off an exchange, and reads
requirement as response over a law that leaves several exchanges open.

* **The census is a reading where a step's exchange lies within finitely many relata.** Whether a
  formation exchanges with some member of a list is decided by going through the list
  (`Flow.ExchangesWithin`). Where a family closes the step, a formation exchanges exactly where it
  takes part and exchanges within the family (`Flow.exchanging_iff_within`), so the formations taking
  part, listed once, can be kept to those that exchange, with no decision procedure supplied
  (`Flow.listed_at_of_closed`, `Flow.readOff_census_of_closed`). So every world, with its rest
  counted, whose formations taking part are listed once and whose steps are closed by a named
  family has a census (`World.withRest_counted`); every finite world does
  (`World.Finite.withRest_counted`), where `World.Finite.counted` needed activity decided. Without
  enclosure no world read off an exchange fails a census at any step: that it does is refuted
  (`Flow.not_not_listed_at`). Enclosure is not itself read off: read off `ExchangeLaw.spreading`,
  which gives every relatum a unit, no step is enclosed, with the rest idle, and the world still has a
  census (`ExchangeLaw.spreading_not_enclosed`, `ExchangeLaw.spreading_counted`). What enclosure supplies cannot be had otherwise: that every flow over
  `Nat` with its formations listed once has its exchanging relata listed at every step is exactly
  the limited principle of omniscience (`Flow.listed_iff_lpo`), since listing them decides whether a
  formation exchanges with any of unboundedly many relata (`Flow.marking`).
* **Dissipation is a state of the law: loss.** With the rest counted and idle, a world whose
  formations give nothing dissipates (`World.withRest_dissipative_of_gives_nothing`). Read off the
  law `ExchangeLaw.responsive`, which takes its condition's unit and gives it back, a world with the
  rest counted and idle meets the four tying premises and does not dissipate
  (`ExchangeLaw.responsive_not_dissipative`); read off `ExchangeLaw.still`, which exchanges nothing,
  it dissipates (`ExchangeLaw.still_dissipative`).
* **Embodiment is closure and a state of the law: no dormancy.** With the rest counted, every
  relatum stands exactly while it is active exactly where the world balances and each of its relata
  exchanges exactly while it stands (`World.withRest_embodied_iff`): the rest stands at nothing, so
  embodied it never exchanges. Read off `still` from a standing of one, the relatum stands and does
  not exchange (`ExchangeLaw.still_not_embodied`); read off `responsive`, it exchanges exactly while
  it stands (`ExchangeLaw.responsive_embodied`).
* **Bounded transmission is a state of the law: heredity of response.** Read off
  `ExchangeLaw.sprouting`, a source gives a sprout its first unit, and the sprout then exchanges with
  the ground exactly where the ground stands; the sprout's exchange responds to the ground and the
  source's giving does not, so no bound transmits the dependence (`ExchangeLaw.sprouting_not_transmitting`),
  while the world meets the four tying premises with its rest idle (`ExchangeLaw.sprouting_closed`).
  Where nothing comes to stand nothing descends, and transmission holds (`ExchangeLaw.still_transmitting`,
  `ExchangeLaw.responsive_transmitting`).
* **Each of the three is contingent.** `ExchangeLaw.contingent` collects them: three worlds read off
  laws of exchange, each with the rest counted and idle and meeting the four tying premises; one meets
  dissipation and transmission and not embodiment, one embodiment and transmission and not
  dissipation, one not transmission.
* **Requirement as response over branching.** A relation of exchange leaves open, under each level
  history, any number of exchanges across a step (`ExchangeRelation`); a run takes an open exchange
  at every step (`ExchangeRelation.Runs`). A formation's exchange necessarily responds to a condition
  falling below a need where, under every history differing at most in that condition's level at
  that step, with the level below the need, no open exchange has the formation exchange
  (`ExchangeRelation.RespondsBelow`). Read as requirement, activity needs support on every run, for
  every history and need (`ExchangeRelation.readWeb_dependent`), and with the rest counted the four
  tying premises hold with no premise (`ExchangeRelation.reading_glue`). Read as possible response
  (some open exchange leaves it idle, `ExchangeRelation.MayRespondBelow`), activity need not be
  supported: under `ExchangeRelation.free` a formation exchanges at nothing and possibly responds
  (`ExchangeRelation.free_unsupported`). A law of exchange is the relation leaving one exchange open
  (`ExchangeLaw.relation`), its course is a run of it (`ExchangeLaw.course_runs`), and there the
  necessary and the possible readings are the law's (`ExchangeLaw.relation_responds_iff`,
  `ExchangeLaw.relation_may_iff`): read off the course as a run, the web's requirement is the law's
  (`ExchangeLaw.relation_readWeb_requires`, `ExchangeLaw.relation_readWeb_may`).

**Readings (the AI's).** Of the eight premises, five are readings of one exchange: the four tying
premises, and the census wherever the formations taking part are listed once and a named family
closes each step's exchange (so in every finite world whose formations are listed once), a census
never failing where no family does (enclosure, like closure, is a state of the law, not a reading). Three are
states of the law that holds: dissipation (loss), embodiment (no relatum standing while it does not
exchange) and bounded transmission (what descends responds as what gave did). Each is met by some
laws and failed by others, with the four tying premises holding and the rest idle; together with
closure (feasibility), they are what reading does not settle. No ethical predicate, ranking or axiom
occurs.
-/

namespace Becoming

variable {F C : Type}

/-! ## Listing within a family -/

/-- A decided property that cannot fail holds. -/
theorem of_not_not {p : Prop} [decided : Decidable p] (holds : ¬¬ p) : p :=
  match decided with
  | isTrue yes => yes
  | isFalse no => absurd no holds

/-- Where each member of a list without repetition meets a property or does not, the members
meeting it are listed, each once. -/
theorem listed_of_em {α : Type} (q : α → Prop) :
    ∀ {ps : List α}, Distinct ps → (∀ a, a ∈ ps → q a ∨ ¬ q a) →
      ∃ l, Distinct l ∧ ∀ a, (a ∈ ps ∧ q a) ↔ a ∈ l
  | [], _, _ => ⟨[], trivial, fun _ => ⟨fun ⟨mem, _⟩ => (nomatch mem), fun mem => (nomatch mem)⟩⟩
  | p :: ps, ⟨fresh, distinct⟩, em =>
    match listed_of_em q distinct (fun a mem => em a (.tail p mem)) with
    | ⟨l, dl, iff⟩ => match em p (.head ps) with
      | .inl yes => ⟨p :: l, ⟨fun mem => fresh ((iff p).mpr mem).1, dl⟩, fun a =>
          ⟨fun ⟨mem, holds⟩ => match mem_cons_cases mem with
             | .inl same => Eq.subst (motive := fun x => x ∈ p :: l) same.symm (.head l)
             | .inr mem => .tail p ((iff a).mp ⟨mem, holds⟩),
           fun mem => match mem_cons_cases mem with
             | .inl same => Eq.subst (motive := fun x => x ∈ p :: ps ∧ q x) same.symm ⟨.head ps, yes⟩
             | .inr mem => ⟨.tail p ((iff a).mpr mem).1, ((iff a).mpr mem).2⟩⟩⟩
      | .inr no => ⟨l, dl, fun a =>
          ⟨fun ⟨mem, holds⟩ => match mem_cons_cases mem with
             | .inl same => absurd (Eq.subst (motive := q) same holds) no
             | .inr mem => (iff a).mp ⟨mem, holds⟩,
           fun mem => ⟨.tail p ((iff a).mpr mem).1, ((iff a).mpr mem).2⟩⟩⟩

/-- Of a list without repetition, that the members meeting a property cannot be listed is refuted,
whatever the property. -/
theorem not_not_listed {α : Type} (q : α → Prop) :
    ∀ {ps : List α}, Distinct ps → ¬¬ ∃ l, Distinct l ∧ ∀ a, (a ∈ ps ∧ q a) ↔ a ∈ l
  | [], _ => fun no => no ⟨[], trivial, fun _ => ⟨fun ⟨mem, _⟩ => (nomatch mem), fun mem => (nomatch mem)⟩⟩
  | p :: ps, ⟨fresh, distinct⟩ => fun no => not_not_listed q distinct fun ⟨l, dl, iff⟩ =>
      (fun em : ¬¬ (q p ∨ ¬ q p) => em fun decided => match decided with
        | .inl yes => no ⟨p :: l, ⟨fun mem => fresh ((iff p).mpr mem).1, dl⟩, fun a =>
            ⟨fun ⟨mem, holds⟩ => match mem_cons_cases mem with
               | .inl same => Eq.subst (motive := fun x => x ∈ p :: l) same.symm (.head l)
               | .inr mem => .tail p ((iff a).mp ⟨mem, holds⟩),
             fun mem => match mem_cons_cases mem with
               | .inl same =>
                 Eq.subst (motive := fun x => x ∈ p :: ps ∧ q x) same.symm ⟨.head ps, yes⟩
               | .inr mem => ⟨.tail p ((iff a).mpr mem).1, ((iff a).mpr mem).2⟩⟩⟩
        | .inr not => no ⟨l, dl, fun a =>
            ⟨fun ⟨mem, holds⟩ => match mem_cons_cases mem with
               | .inl same => absurd (Eq.subst (motive := q) same holds) not
               | .inr mem => (iff a).mp ⟨mem, holds⟩,
             fun mem => ⟨.tail p ((iff a).mpr mem).1, ((iff a).mpr mem).2⟩⟩⟩)
        (fun refuted => refuted (.inr fun yes => refuted (.inl yes)))

/-! ## The census read off the exchange -/

namespace Flow

variable (L : Flow F C)

/-- `f` exchanges across the step from `t` with some member of `cs`. -/
def ExchangesWithin (cs : List C) (t : Nat) (f : F) : Prop :=
  ∃ c, c ∈ cs ∧ (0 < L.take t f c ∨ 0 < L.give t f c)

/-- Exchanging within a list is decided, by going through it. -/
instance exchangesWithin_decided (cs : List C) (t : Nat) (f : F) :
    Decidable (L.ExchangesWithin cs t f) :=
  decideSome (p := fun c => 0 < L.take t f c ∨ 0 < L.give t f c) cs

variable {L}

/-- Where a family closes the step, a formation exchanges exactly where it takes part and exchanges
within the family. -/
theorem exchanging_iff_within {cs : List C} {t : Nat} (closed : L.ClosedAt cs t) {f : F} :
    L.Exchanging t f ↔ f ∈ L.present t ∧ L.ExchangesWithin cs t f :=
  ⟨fun ⟨present, c, exchanged⟩ => ⟨present, of_not_not fun outside =>
      have zero := closed f present c fun mem => outside ⟨c, mem, exchanged⟩
      match exchanged with
      | .inl takes => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le takes (Nat.le_of_eq zero.1))
      | .inr gives => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le gives (Nat.le_of_eq zero.2))⟩,
   fun ⟨present, c, _, exchanged⟩ => ⟨present, c, exchanged⟩⟩

/-- **Listed with no decision.** Where the formations taking part are listed once and a family
closes the step, those that exchange are listed, each once: those taking part that exchange within
the family. -/
theorem listed_at_of_closed {cs : List C} {t : Nat} (distinct : Distinct (L.present t))
    (closed : L.ClosedAt cs t) :
    Distinct (keep (L.ExchangesWithin cs t) (L.present t)) ∧
      ∀ f, L.Exchanging t f ↔ f ∈ keep (L.ExchangesWithin cs t) (L.present t) :=
  ⟨keep_distinct distinct, fun _ => (exchanging_iff_within closed).trans mem_keep.symm⟩

/-- At an enclosed step whose formations taking part are listed once, those that exchange are
listed. -/
theorem listed_at_of_enclosed {t : Nat} (distinct : Distinct (L.present t)) (enclosed : L.Enclosed t) :
    ∃ l, Distinct l ∧ ∀ f, L.Exchanging t f ↔ f ∈ l :=
  match enclosed with
  | ⟨_, _, closed⟩ => ⟨_, listed_at_of_closed distinct closed⟩

/-- **The census read off the exchange.** Where the formations taking part are listed once and a
named family closes each step, the web read off the exchange has a census, with no decision
procedure supplied. -/
theorem readOff_census_of_closed (distinct : ∀ t, Distinct (L.present t)) (family : Nat → List C)
    (closed : ∀ t, L.ClosedAt (family t) t) (level : Nat → C → Nat)
    (requires : Nat → F → C → Prop) (need : Nat → F → C → Nat) :
    (L.readOff level requires need).Census fun t => keep (L.ExchangesWithin (family t) t) (L.present t) :=
  fun t => listed_at_of_closed (distinct t) (closed t)

/-- **No census fails.** At any step whose formations taking part are listed once, that those that
exchange cannot be listed is refuted. -/
theorem not_not_listed_at {t : Nat} (distinct : Distinct (L.present t)) :
    ¬¬ ∃ l, Distinct l ∧ ∀ f, L.Exchanging t f ↔ f ∈ l :=
  not_not_listed (fun f => ∃ c, 0 < L.take t f c ∨ 0 < L.give t f c) distinct

/-- One formation, `0`, giving one unit to each relatum a sequence marks, at every step. -/
def marking (s : Nat → Bool) : Flow Nat Nat :=
  ⟨fun _ => [0], fun _ _ _ => 0, fun _ _ c => cond (s c) 1 0⟩

theorem cond_pos : ∀ {b : Bool}, 0 < cond b 1 0 → b = true
  | true, _ => rfl
  | false, positive => absurd positive (Nat.lt_irrefl 0)

/-- Under `marking s`, the formation exchanges exactly where the sequence marks something. -/
theorem marking_exchanging (s : Nat → Bool) (t : Nat) :
    (marking s).Exchanging t 0 ↔ ∃ n, s n = true :=
  ⟨fun ⟨_, c, exchanged⟩ => match exchanged with
     | .inl takes => absurd takes (Nat.lt_irrefl 0)
     | .inr gives => ⟨c, cond_pos gives⟩,
   fun ⟨n, marked⟩ =>
     ⟨.head _, n, .inr (Eq.subst (motive := fun b => 0 < cond b 1 0) marked.symm Nat.zero_lt_one)⟩⟩

/-- Membership in a list of numbers is decided. -/
def memDecided (n : Nat) (l : List Nat) : Decidable (n ∈ l) :=
  match decideSome (p := fun m => m = n) l with
  | isTrue yes => isTrue (match yes with
      | ⟨_, mem, same⟩ => Eq.subst (motive := fun x => x ∈ l) same mem)
  | isFalse no => isFalse fun mem => no ⟨n, mem, rfl⟩

/-- **Listing what exchanges is omniscience.** That every flow over `Nat` whose formations taking
part are listed once has those that exchange listed at every step is the limited principle of
omniscience: listing them decides whether a formation exchanges with any of unboundedly many
relata. -/
theorem listed_iff_lpo :
    (∀ L : Flow Nat Nat, (∀ t, Distinct (L.present t)) →
        ∀ t, ∃ l, Distinct l ∧ ∀ f, L.Exchanging t f ↔ f ∈ l) ↔ LPO :=
  ⟨fun listed s => match listed (marking s) (fun _ => ⟨fun no => (nomatch no), trivial⟩) 0 with
     | ⟨l, _, iff⟩ => match memDecided 0 l with
       | isTrue mem => .inl ((marking_exchanging s 0).mp ((iff 0).mpr mem))
       | isFalse out => .inr fun n => match marked : s n with
         | true => absurd ((iff 0).mp ((marking_exchanging s 0).mpr ⟨n, marked⟩)) out
         | false => rfl,
   fun lpo L distinct t =>
     match listed_of_em (fun f => ∃ c, 0 < L.take t f c ∨ 0 < L.give t f c) (distinct t)
       (fun f _ => match lpo fun c => Nat.blt 0 (L.take t f c + L.give t f c) with
         | .inl ⟨c, positive⟩ => .inl ⟨c,
             match exchanged : L.take t f c with
             | 0 => .inr (Nat.lt_of_lt_of_le (Nat.le_of_ble_eq_true positive)
                 (Nat.le_of_eq ((congrArg (· + L.give t f c) exchanged).trans (Nat.zero_add _))))
             | _ + 1 => .inl (Nat.succ_pos _)⟩
         | .inr nothing => .inr fun ⟨c, exchanged⟩ =>
             have zero := nothing c
             match exchanged with
             | .inl takes => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le takes (Nat.le_of_not_lt fun more =>
                 Nat.not_le_of_gt (Nat.lt_of_lt_of_le more (Nat.le_add_right _ _))
                   (Nat.le_of_lt_succ (Nat.lt_of_not_le fun big =>
                     Bool.noConfusion ((Nat.ble_eq_true_of_le big).symm.trans zero)))))
             | .inr gives => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le gives (Nat.le_of_not_lt fun more =>
                 Nat.not_le_of_gt (Nat.lt_of_lt_of_le more (Nat.le_add_left _ _))
                   (Nat.le_of_lt_succ (Nat.lt_of_not_le fun big =>
                     Bool.noConfusion ((Nat.ble_eq_true_of_le big).symm.trans zero)))))) with
     | ⟨l, dl, iff⟩ => ⟨l, dl, fun f => iff f⟩⟩

end Flow

/-! ## The remaining premises with the rest counted -/

namespace World

variable {w : World}

/-- **The census of a world read off its exchange.** With the rest counted, where the world's
formations taking part are listed once and a named family closes each step, the world has a census,
with no decision procedure supplied. -/
theorem withRest_counted (distinct : ∀ t, Distinct (w.flow.present t))
    (family : Nat → List (Option w.Relatum)) (closed : ∀ t, w.restFlow.ClosedAt (family t) t) :
    w.withRest.Counted :=
  ⟨_, Flow.readOff_census_of_closed (L := w.restFlow)
    (fun t => Flow.present_distinct (L := w.flow) (W := w.web) (distinct t)) family closed
    w.restLevel w.restRequires w.restNeed⟩

/-- So every finite world whose formations taking part are listed once has, with its rest counted,
a census, its activity read off the exchange and not decided. -/
theorem Finite.withRest_counted (finite : w.Finite) (distinct : ∀ t, Distinct (w.flow.present t)) :
    w.withRest.Counted :=
  match finite with
  | ⟨all, _, every⟩ => World.withRest_counted distinct (fun _ => none :: all.map some)
      fun _ _ _ c out => absurd (match c with
        | none => .head _
        | some x => .tail _ (mem_map_some (every x))) out

/-- A balanced world whose formations give nothing gives nothing with its rest counted. -/
theorem restFlow_give_zero (balanced : w.Balanced) (nothing : ∀ t f c, w.flow.give t f c = 0) :
    ∀ t f c, w.restFlow.give t f c = 0
  | _, _, none => rfl
  | t, none, some d =>
    show w.web.level (t + 1) d + w.flow.taken t d - (w.web.level t d + w.flow.given t d) = 0 from
      (congrArg (· - (w.web.level t d + w.flow.given t d)) (balanced t d)).trans (Nat.sub_self _)
  | t, some g, some d => nothing t g d

/-- **Giving nothing dissipates.** With the rest counted, a balanced world whose formations give
nothing dissipates. -/
theorem withRest_dissipative_of_gives_nothing (balanced : w.Balanced)
    (nothing : ∀ t f c, w.flow.give t f c = 0) : w.withRest.Dissipative :=
  fun _ t _ _ f _ => gives_nothing (total_eq_zero fun c _ =>
    restFlow_give_zero balanced nothing t f c)

/-- **Embodiment is closure and no dormancy.** With the rest counted, every relatum stands exactly
while it is active exactly where the world balances and each of its relata exchanges exactly while it
stands. -/
theorem withRest_embodied_iff :
    w.withRest.Embodied ↔ w.Balanced ∧ ∀ t x, (w.flow.Exchanging t x ↔ 0 < w.web.level t x) :=
  ⟨fun embodied => ⟨withRest_closed_iff.mp fun t active =>
       Nat.lt_irrefl 0 ((embodied none t).mp active),
     fun t x => withRest_exchanging_iff.symm.trans (embodied (some x) t)⟩,
   fun ⟨balanced, exchanges⟩ x t => match x with
     | none => ⟨fun active => absurd active (withRest_closed_iff.mpr balanced t),
         fun positive => absurd positive (Nat.lt_irrefl 0)⟩
     | some x => withRest_exchanging_iff.trans (exchanges t x)⟩

/-- So, with the rest counted, an embodied world balances. -/
theorem withRest_embodied_balanced (embodied : w.withRest.Embodied) : w.Balanced :=
  (withRest_embodied_iff.mp embodied).1

/-- Where nothing comes to stand, nothing descends, and transmission holds with any bound. -/
theorem transmitting_of_nothing_comes (standing : ∀ t x, ¬ w.web.ComesToStand t x) : w.Transmitting :=
  ⟨0, fun _ t x _ descends _ => absurd descends.2.2 (standing t x)⟩

end World

/-! ## Witnesses read off laws of exchange -/

namespace ExchangeLaw

/-- Exchanging nothing. -/
def still : ExchangeLaw Unit Unit :=
  ⟨fun _ _ _ _ => 0, fun _ _ _ _ => 0⟩

/-- From a level of one, the still law keeps the level at one. -/
theorem still_levels : ∀ t c, still.levels single (fun _ => 1) t c = 1
  | 0, _ => rfl
  | t + 1, c => (levels_succ (law := still) (present := single) (start := fun _ => 1) t c).trans
      (still_levels t c)

/-- The world read off the still law from a level of one. -/
def stillWorld : World :=
  still.readWorld single (fun _ => 1) needOne

/-- The world read off the responsive law from a level of one. -/
def responsiveWorld : World :=
  responsive.readWorld single (fun _ => 1) needOne

theorem still_balanced : stillWorld.Balanced :=
  fun t c => congrArg (· + 0) ((still_levels (t + 1) c).trans (still_levels t c).symm)

theorem responsive_balanced : responsiveWorld.Balanced :=
  fun t c => congrArg (· + (responsive.course single (fun _ => 1)).taken t c)
    ((responsive_levels (t + 1) c).trans (responsive_levels t c).symm)

/-- With the rest counted, the still world's rest is idle. -/
theorem still_closed : ∀ t, ¬ stillWorld.withRest.web.active t none :=
  World.withRest_closed_iff.mpr still_balanced

/-- With the rest counted, the responsive world's rest is idle. -/
theorem responsive_closed : ∀ t, ¬ responsiveWorld.withRest.web.active t none :=
  World.withRest_closed_iff.mpr responsive_balanced

/-- Read off the still law, the world dissipates. -/
theorem still_dissipative : stillWorld.withRest.Dissipative :=
  World.withRest_dissipative_of_gives_nothing still_balanced fun _ _ _ => rfl

/-- **Dissipation is not a reading.** Read off the responsive law, with the rest counted and idle,
the relatum takes its own unit and gives it back: nothing is lost, and the world does not
dissipate. -/
theorem responsive_not_dissipative : ¬ responsiveWorld.withRest.Dissipative :=
  fun dissipative => Nat.not_succ_le_self 1
    (dissipative [some ()] 0 ⟨fun no => (nomatch no), trivial⟩
      (fun _ _ c out => match c with
        | none => ⟨rfl, rfl⟩
        | some () => absurd (.head _) out)
      (some ()) (.tail _ (.head _)))

/-- **Embodiment is not a reading.** Read off the still law from a level of one, with the rest
counted and idle, the relatum stands and does not exchange. -/
theorem still_not_embodied : ¬ stillWorld.withRest.Embodied :=
  fun embodied => match World.withRest_exchanging_iff.mp ((embodied (some ()) 0).mpr Nat.zero_lt_one) with
    | ⟨_, _, .inl takes⟩ => Nat.lt_irrefl 0 takes
    | ⟨_, _, .inr gives⟩ => Nat.lt_irrefl 0 gives

/-- Read off the responsive law, the relatum exchanges exactly while it stands. -/
theorem responsive_embodied : responsiveWorld.withRest.Embodied :=
  World.withRest_embodied_iff.mpr ⟨responsive_balanced, fun t () =>
    ⟨fun _ => Eq.subst (motive := fun n => 0 < n) (responsive_levels t ()).symm Nat.zero_lt_one,
     fun _ => ⟨.head _, (), .inl
       (Eq.subst (motive := fun n => 0 < sign n) (responsive_levels t ()).symm Nat.zero_lt_one)⟩⟩⟩

/-- In a world whose relatum stands at one throughout, nothing comes to stand with the rest
counted. -/
theorem nothing_comes {w : World} (one : ∀ t x, w.web.level t x = 1) :
    ∀ t x, ¬ w.withRest.web.ComesToStand t x
  | _, none, comes => Nat.lt_irrefl 0 comes.2
  | t, some x, comes => comes.1 (Eq.subst (motive := fun n => 0 < n) (one t x).symm Nat.zero_lt_one)

theorem still_transmitting : stillWorld.withRest.Transmitting :=
  World.transmitting_of_nothing_comes (nothing_comes still_levels)

theorem responsive_transmitting : responsiveWorld.withRest.Transmitting :=
  World.transmitting_of_nothing_comes (nothing_comes responsive_levels)

/-! ### A sprout whose dependence its source did not have -/

/-- A source, a sprout and the ground. -/
inductive Sprouting where
  | source
  | sprout
  | ground

/-- The source gives the sprout one unit across the first step; the sprout takes the ground's unit
and gives it back exactly where the ground stands. -/
def sprouting : ExchangeLaw Sprouting Sprouting :=
  ⟨fun t f l c => match f, c with
     | .sprout, .ground => sign (l t .ground)
     | .source, _ => 0
     | .sprout, .source => 0
     | .sprout, .sprout => 0
     | .ground, _ => 0,
   fun t f l c => match f, c with
     | .source, .sprout => (match t with
       | 0 => 1
       | _ + 1 => 0)
     | .source, .source => 0
     | .source, .ground => 0
     | .sprout, .ground => sign (l t .ground)
     | .sprout, .source => 0
     | .sprout, .sprout => 0
     | .ground, _ => 0⟩

/-- The source and the sprout take part at every step. -/
def sprouts : Nat → List Sprouting := fun _ => [.source, .sprout]

/-- The ground stands at one, the source and the sprout at nothing. -/
def groundOne : Sprouting → Nat
  | .source => 0
  | .sprout => 0
  | .ground => 1

/-- A need of one throughout. -/
def needOneOf (R : Type) : Nat → R → R → Nat := fun _ _ _ => 1

/-- The world read off the sprouting law. -/
def sproutingWorld : World :=
  sprouting.readWorld sprouts groundOne (needOneOf Sprouting)

/-- The sprouting law reads what has stood. -/
theorem sprouting_nonanticipating : sprouting.Nonanticipating :=
  fun t f l l' agree c =>
    have ground : sign (l t .ground) = sign (l' t .ground) :=
      congrArg sign (agree t (Nat.le_refl t) .ground)
    match f, c with
    | .sprout, .ground => ⟨ground, ground⟩
    | .source, .source => ⟨rfl, rfl⟩
    | .source, .sprout => ⟨rfl, rfl⟩
    | .source, .ground => ⟨rfl, rfl⟩
    | .sprout, .source => ⟨rfl, rfl⟩
    | .sprout, .sprout => ⟨rfl, rfl⟩
    | .ground, .source => ⟨rfl, rfl⟩
    | .ground, .sprout => ⟨rfl, rfl⟩
    | .ground, .ground => ⟨rfl, rfl⟩

/-- The sprouting law never takes more than stands. -/
theorem sprouting_feasible : sprouting.Feasible sprouts groundOne
  | _, .ground => Nat.le_trans (Nat.le_of_eq (Nat.zero_add _))
      (Nat.le_trans (sign_le _) (Nat.le_add_right _ _))
  | _, .source => Nat.zero_le _
  | _, .sprout => Nat.zero_le _

/-- **The rest idle.** With the rest counted, the sprouting world's rest is never active. -/
theorem sprouting_closed : ∀ t, ¬ sproutingWorld.withRest.web.active t none :=
  (readWorld_closed_iff (law := sprouting) (present := sprouts) (start := groundOne)
    (need := needOneOf Sprouting) sprouting_nonanticipating).mpr sprouting_feasible

/-- The sprout comes to stand across the first step, given its unit by the source. -/
theorem sprout_descends :
    sproutingWorld.withRest.flow.DescendsAt sproutingWorld.withRest.web 0 (some .sprout)
      (some .source) :=
  ⟨.tail _ (.head _), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩

/-- After it stands, the sprout's exchange responds to the ground falling below one. -/
theorem sprout_requires : sproutingWorld.withRest.web.requires 1 (some .sprout) (some .ground) :=
  fun l' _ below ⟨_, c, exchanged⟩ =>
    have zero : l' 1 .ground = 0 := Nat.eq_zero_of_le_zero (Nat.le_of_lt_succ below)
    match c, exchanged with
    | .ground, .inl takes => Nat.lt_irrefl 0 (Eq.subst (motive := fun x => 0 < sign x) zero takes)
    | .ground, .inr gives => Nat.lt_irrefl 0 (Eq.subst (motive := fun x => 0 < sign x) zero gives)
    | .source, .inl takes => Nat.lt_irrefl 0 takes
    | .source, .inr gives => Nat.lt_irrefl 0 gives
    | .sprout, .inl takes => Nat.lt_irrefl 0 takes
    | .sprout, .inr gives => Nat.lt_irrefl 0 gives

/-- The source's giving does not respond to the ground: it gives with the ground at nothing. -/
theorem source_unrequired : ¬ sproutingWorld.withRest.web.requires 0 (some .source) (some .ground) :=
  fun responds => responds
    (fun s d => match s, d with
      | 0, .ground => 0
      | 0, .source => sprouting.levels sprouts groundOne 0 .source
      | 0, .sprout => sprouting.levels sprouts groundOne 0 .sprout
      | s + 1, d => sprouting.levels sprouts groundOne (s + 1) d)
    (fun s d other => match s, d, other with
      | 0, .ground, other => absurd ⟨rfl, rfl⟩ other
      | 0, .source, _ => rfl
      | 0, .sprout, _ => rfl
      | _ + 1, _, _ => rfl)
    Nat.zero_lt_one ⟨.head _, .sprout, .inr Nat.zero_lt_one⟩

/-- **Bounded transmission is not a reading.** Read off the sprouting law, with the rest counted and
idle, the sprout depends on the ground as its source did not: no bound transmits the dependence. -/
theorem sprouting_not_transmitting : ¬ sproutingWorld.withRest.Transmitting :=
  fun ⟨_, transmits⟩ => source_unrequired
    (transmits (some .ground) 0 (some .sprout) (some .source) sprout_descends sprout_requires).1

/-! ### A law whose exchange no finite family encloses -/

/-- Giving one unit to every relatum, taking nothing. -/
def spreading : ExchangeLaw Nat Nat :=
  ⟨fun _ _ _ _ => 0, fun _ _ _ _ => 1⟩

/-- The world read off the spreading law: `0` takes part at every step, everything starting at
nothing. -/
def spreadingWorld : World :=
  spreading.readWorld (fun _ => [0]) (fun _ => 0) (needOneOf Nat)

/-- With the rest counted, the spreading world's rest is idle. -/
theorem spreading_closed : ∀ t, ¬ spreadingWorld.withRest.web.active t none :=
  (readWorld_closed_iff (law := spreading) (present := fun _ => [0]) (start := fun _ => 0)
    (need := needOneOf Nat) (fun _ _ _ _ _ _ => ⟨rfl, rfl⟩)).mpr fun _ _ => Nat.zero_le _

/-- The formation of the spreading world. -/
def origin : spreadingWorld.Relatum := (0 : Nat)

/-- The index of a relatum with the rest counted, the rest at `0`. -/
def optionIndex : Option Nat → Nat
  | none => 0
  | some n => n

/-- **Enclosure is not a reading.** Read off the spreading law, with the rest counted and idle, no
step is enclosed: the formation gives to every relatum. -/
theorem spreading_not_enclosed (t : Nat) : ¬ spreadingWorld.withRest.flow.Enclosed t :=
  fun ⟨cs, _, closed⟩ =>
    have out : ¬ some (beyond (cs.map optionIndex)) ∈ cs :=
      fun mem => Nat.lt_irrefl _ (lt_beyond (mem_map_of (g := optionIndex) mem))
    Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le Nat.zero_lt_one
      (Nat.le_of_eq (closed (some origin) (.tail _ (.head _)) _ out).2))

/-- Yet the spreading world has a census: the formation alone exchanges. Enclosure suffices for a
census and is not needed. -/
theorem spreading_counted : spreadingWorld.withRest.Counted :=
  ⟨fun _ => [some origin], fun t => ⟨⟨fun no => (nomatch no), trivial⟩, fun x => match x with
    | none => ⟨fun active => absurd active (spreading_closed t), fun mem => match mem_cons_cases mem with
        | .inl same => (nomatch same)
        | .inr no => (nomatch no)⟩
    | some _ => ⟨fun ⟨mem, _⟩ => match mem_cons_cases mem with
        | .inl same => (nomatch same)
        | .inr mem => mem,
      fun mem => ⟨.tail _ mem, some origin, .inr Nat.zero_lt_one⟩⟩⟩⟩

/-- **The three are contingent.** Read off laws of exchange, with the rest counted and idle and the
four tying premises holding: the still world dissipates and transmits and is not embodied; the
responsive world is embodied and transmits and does not dissipate; the sprouting world does not
transmit. -/
theorem contingent :
    ((stillWorld.withRest.Balanced ∧ stillWorld.withRest.Acting ∧ stillWorld.withRest.Taking ∧
        stillWorld.withRest.Dependent) ∧ (∀ t, ¬ stillWorld.withRest.web.active t none) ∧
      stillWorld.withRest.Dissipative ∧ stillWorld.withRest.Transmitting ∧
      ¬ stillWorld.withRest.Embodied) ∧
    ((responsiveWorld.withRest.Balanced ∧ responsiveWorld.withRest.Acting ∧
        responsiveWorld.withRest.Taking ∧ responsiveWorld.withRest.Dependent) ∧
      (∀ t, ¬ responsiveWorld.withRest.web.active t none) ∧
      responsiveWorld.withRest.Embodied ∧ responsiveWorld.withRest.Transmitting ∧
      ¬ responsiveWorld.withRest.Dissipative) ∧
    ((sproutingWorld.withRest.Balanced ∧ sproutingWorld.withRest.Acting ∧
        sproutingWorld.withRest.Taking ∧ sproutingWorld.withRest.Dependent) ∧
      (∀ t, ¬ sproutingWorld.withRest.web.active t none) ∧
      ¬ sproutingWorld.withRest.Transmitting) :=
  ⟨⟨readWorld_glue, still_closed, still_dissipative, still_transmitting, still_not_embodied⟩,
   ⟨readWorld_glue, responsive_closed, responsive_embodied, responsive_transmitting,
     responsive_not_dissipative⟩,
   ⟨readWorld_glue, sprouting_closed, sprouting_not_transmitting⟩⟩

end ExchangeLaw

/-! ## Requirement as response over branching -/

/-- A relation of exchange: which exchanges across the step from `t`, what each formation takes from
and gives to each condition, are open under a level history. Several may be open, or none. -/
structure ExchangeRelation (F C : Type) where
  admits : Nat → (Nat → C → Nat) → (F → C → Nat) → (F → C → Nat) → Prop

namespace ExchangeRelation

variable (rel : ExchangeRelation F C) (present : Nat → List F)

/-- Under the exchange `take`, `give`, `f` exchanges across the step from `t`. -/
def Exchanges (take give : F → C → Nat) (t : Nat) (f : F) : Prop :=
  f ∈ present t ∧ ∃ c, 0 < take f c ∨ 0 < give f c

/-- `f`'s exchange across the step from `t` necessarily responds to `c` falling below `n`: under
every history differing from `l` at most in `c`'s level at `t`, with that level below `n`, no open
exchange has `f` exchange. -/
def RespondsBelow (l : Nat → C → Nat) (t : Nat) (f : F) (c : C) (n : Nat) : Prop :=
  ∀ l' : Nat → C → Nat, (∀ s d, ¬ (s = t ∧ d = c) → l' s d = l s d) → l' t c < n →
    ∀ take give, rel.admits t l' take give → ¬ Exchanges present take give t f

/-- `f`'s exchange possibly responds to `c` falling below `n`: under every such history some open
exchange leaves `f` idle. -/
def MayRespondBelow (l : Nat → C → Nat) (t : Nat) (f : F) (c : C) (n : Nat) : Prop :=
  ∀ l' : Nat → C → Nat, (∀ s d, ¬ (s = t ∧ d = c) → l' s d = l s d) → l' t c < n →
    ∃ take give, rel.admits t l' take give ∧ ¬ Exchanges present take give t f

/-- A run of the relation along the history `l`: a flow of the formations present whose exchange
at every step is open under `l`. -/
def Runs (l : Nat → C → Nat) (L : Flow F C) : Prop :=
  ∀ t, L.present t = present t ∧ rel.admits t l (L.take t) (L.give t)

/-- The web read off a run: activity and drawing read off its exchange, the levels the history's,
and a formation requiring a condition at its need exactly where its exchange necessarily responds to
the condition falling below that need. -/
def readWeb (L : Flow F C) (l : Nat → C → Nat) (need : Nat → F → C → Nat) : Web F C :=
  L.readOff l (fun t f c => rel.RespondsBelow present l t f c (need t f c)) need

variable {rel present}

/-- **On every run, activity needs support**, for every history and need: the run's own exchange is
open under the actual history. -/
theorem readWeb_dependent {l : Nat → C → Nat} {L : Flow F C} (runs : rel.Runs present l L)
    (need : Nat → F → C → Nat) : (rel.readWeb present L l need).Dependent :=
  fun t f ⟨mem, exchanged⟩ _ responds => Nat.ge_of_not_lt fun below =>
    responds l (fun _ _ _ => rfl) below (L.take t) (L.give t) (runs t).2
      ⟨Eq.subst (motive := fun p => f ∈ p) (runs t).1 mem, exchanged⟩

/-- A run over one kind of relatum, read as a world. -/
def world {R : Type} (rel : ExchangeRelation R R) (present : Nat → List R) (L : Flow R R)
    (l : Nat → R → Nat) (need : Nat → R → R → Nat) : World :=
  World.of R L (rel.readWeb present L l need)

/-- **The four tying premises hold on every run, with no premise.** With the rest counted and
requirement read as necessary response, the world of a run balances, only active relata give and
take, and activity needs support. -/
theorem reading_glue {R : Type} {rel : ExchangeRelation R R} {present : Nat → List R}
    {L : Flow R R} {l : Nat → R → Nat} (runs : rel.Runs present l L) (need : Nat → R → R → Nat) :
    (world rel present L l need).withRest.Balanced ∧ (world rel present L l need).withRest.Acting ∧
      (world rel present L l need).withRest.Taking ∧ (world rel present L l need).withRest.Dependent :=
  ⟨World.withRest_balanced, Flow.readOff_acting, Flow.readOff_taking,
   World.withRest_dependent_iff.mpr fun t x exchanging => readWeb_dependent runs need t x exchanging⟩

/-- Every exchange open under every history. -/
def free : ExchangeRelation Unit Unit :=
  ⟨fun _ _ _ _ => True⟩

/-- Taking one unit at every step. -/
def takingOne : Flow Unit Unit :=
  ⟨ExchangeLaw.single, fun _ _ _ => 1, fun _ _ _ => 0⟩

/-- **Possible response does not give support.** Under the free relation, along the history at
nothing, the formation takes a unit at every step and its exchange possibly responds to its
condition falling below one: some open exchange leaves it idle. Read as requirement, activity would
not need support. -/
theorem free_unsupported :
    free.Runs ExchangeLaw.single (fun _ _ => 0) takingOne ∧
      ∀ t, takingOne.Exchanging t () ∧ free.MayRespondBelow ExchangeLaw.single (fun _ _ => 0) t () () 1 ∧
        (fun _ _ => 0 : Nat → Unit → Nat) t () < 1 :=
  ⟨fun _ => ⟨rfl, trivial⟩, fun _ => ⟨⟨show () ∈ [()] from .head _, (), .inl Nat.zero_lt_one⟩,
    fun _ _ _ => ⟨fun _ _ => 0, fun _ _ => 0, trivial, fun ⟨_, _, exchanged⟩ => match exchanged with
      | .inl takes => Nat.lt_irrefl 0 takes
      | .inr gives => Nat.lt_irrefl 0 gives⟩,
    Nat.zero_lt_one⟩⟩

end ExchangeRelation

namespace ExchangeLaw

variable {law : ExchangeLaw F C} {present : Nat → List F}

/-- A law of exchange as the relation leaving one exchange open: the law's. -/
def relation (law : ExchangeLaw F C) : ExchangeRelation F C :=
  ⟨fun t l take give => (∀ f c, take f c = law.take t f l c) ∧ ∀ f c, give f c = law.give t f l c⟩

/-- The course a law generates is a run of its relation along the levels it generates. -/
theorem course_runs (start : C → Nat) :
    law.relation.Runs present (law.levels present start) (law.course present start) :=
  fun _ => ⟨rfl, fun _ _ => rfl, fun _ _ => rfl⟩

/-- Under the law's exchange, a formation exchanges as under the law. -/
theorem relation_exchanges {l : Nat → C → Nat} {t : Nat} {take give : F → C → Nat}
    (admits : law.relation.admits t l take give) {f : F} :
    ExchangeRelation.Exchanges present take give t f ↔ law.ExchangesUnder present l t f :=
  ⟨fun ⟨mem, c, exchanged⟩ => ⟨mem, c, match exchanged with
     | .inl takes => .inl (Eq.subst (motive := fun x => 0 < x) (admits.1 f c) takes)
     | .inr gives => .inr (Eq.subst (motive := fun x => 0 < x) (admits.2 f c) gives)⟩,
   fun ⟨mem, c, exchanged⟩ => ⟨mem, c, match exchanged with
     | .inl takes => .inl (Eq.subst (motive := fun x => 0 < x) (admits.1 f c).symm takes)
     | .inr gives => .inr (Eq.subst (motive := fun x => 0 < x) (admits.2 f c).symm gives)⟩⟩

/-- The law's own exchange is open under its relation. -/
theorem relation_admits (t : Nat) (l : Nat → C → Nat) :
    law.relation.admits t l (fun f c => law.take t f l c) (fun f c => law.give t f l c) :=
  ⟨fun _ _ => rfl, fun _ _ => rfl⟩

/-- **The determined case.** Where one exchange is open, necessary response is the law's response. -/
theorem relation_responds_iff {l : Nat → C → Nat} {t : Nat} {f : F} {c : C} {n : Nat} :
    law.relation.RespondsBelow present l t f c n ↔ law.RespondsBelow present l t f c n :=
  ⟨fun responds l' agree below exchanges =>
     responds l' agree below _ _ (relation_admits t l') ((relation_exchanges (relation_admits t l')).mpr exchanges),
   fun responds l' agree below _ _ admits exchanges =>
     responds l' agree below ((relation_exchanges admits).mp exchanges)⟩

/-- Where one exchange is open, possible response is the law's response too. -/
theorem relation_may_iff {l : Nat → C → Nat} {t : Nat} {f : F} {c : C} {n : Nat} :
    law.relation.MayRespondBelow present l t f c n ↔ law.RespondsBelow present l t f c n :=
  ⟨fun may l' agree below exchanges => match may l' agree below with
     | ⟨_, _, admits, idle⟩ => idle ((relation_exchanges admits).mpr exchanges),
   fun responds l' agree below => ⟨_, _, relation_admits t l', fun exchanges =>
     responds l' agree below ((relation_exchanges (relation_admits t l')).mp exchanges)⟩⟩

/-- **Read off the course as a run**, the web's requirement is the law's: the course read through
the law's relation, with requirement as necessary response, is the web read off the law. -/
theorem relation_readWeb_requires (start : C → Nat) (need : Nat → F → C → Nat) {t : Nat} {f : F}
    {c : C} :
    (law.relation.readWeb present (law.course present start) (law.levels present start) need).requires
        t f c ↔ (law.readWeb present start need).requires t f c :=
  relation_responds_iff

/-- And where one exchange is open, that requirement is possible response as well. -/
theorem relation_readWeb_may (start : C → Nat) (need : Nat → F → C → Nat) {t : Nat} {f : F}
    {c : C} :
    (law.relation.readWeb present (law.course present start) (law.levels present start) need).requires
        t f c ↔ law.relation.MayRespondBelow present (law.levels present start) t f c (need t f c) :=
  relation_responds_iff.trans relation_may_iff.symm

end ExchangeLaw

end Becoming
