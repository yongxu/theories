import Becoming.Premises

/-!
# Transmission: a law of how dependence forms at coming to stand

`Becoming.Evolution` takes transmission as a premise (`Flow.TransmitsWithin`): a relatum
descending across a step that depends on `c` at its first standing step descends only from
relata depending on `c` at the giving step, and needs `c` at most `δ` more. This module asks
whether the premise follows from the core's other premises, states it as a law of one
descent, and proves what derives it and where no derivation reaches.

* **Independent wherever it binds.** `World.novel` (`World.novel_but`) is one finite world
  meeting the seven other premises without transmission. More holds. Dropping one dependence
  of the giver at the giving step (`Web.drop`, `World.drop`) changes no level, activity,
  drawing, need or flow, keeps activity needing support (`Web.drop_dependent`), every other
  premise and finiteness (`World.drop_holds`, `World.drop_finite`), and breaks transmission
  for every `δ` at any descent whose descendant depends on the dropped condition
  (`Flow.drop_untransmitted`, `World.drop_untransmitting`). So every world meeting the seven
  other premises in which transmission binds has a neighbour, one dependence dropped, meeting
  all but transmission (`World.drop_but`); the finite hatch and its neighbour are such a pair
  (`World.finiteHatch_pair`). The seven premises limit dependence and never require one;
  transmission requires the giver's.
* **Two laws.** Transmission is *inheritance*, the descendant's dependence at its first
  standing step held by the giver at the giving step (`Web.InheritsAt`, `Flow.Inherits`),
  together with the *need within `δ`* where both hold (`Web.NeedsWithinAt`,
  `Flow.NeedsWithin`), at one descent and for the whole flow (`Web.transmits_at_iff`,
  `Flow.transmitsWithin_iff`).
* **Inheritance is a law of forming at coming to stand.** A dependence the descendant holds
  at its first standing step either formed across the step (`Web.Forms`) or was held through
  it while the descendant stood at nothing; inheritance covers both
  (`Web.InheritsAt.split`). Where the descendant held no dependence on `c` at the giving step,
  inheritance is exactly the law of forming, a dependence forming at a relatum as it comes to
  stand being one its giver held (`Web.inheritsAt_iff_forming`), and transmission is that law
  with the need within `δ` (`Flow.transmitsWithin_iff_forming`). In general the two cases make
  inheritance where the earlier holding is decided (`Web.inheritsAt_of_split`,
  `Flow.transmitsWithin_iff_split`), and without that only irrefutably
  (`Web.inheritsAt_not_not`); asked of every descent, that they make it is excluded middle
  (`split_iff_em`). In the core's witnesses (`Drawdown`, `Slack`, `hatch`) the descendant's
  dependence is held before it stands, so their transmission is the case of holding.
* **No new dependence by descent.** With balance at a relatum coming to stand, it descends
  from something taking part in the step (`Flow.descends_of_comes`). Under inheritance each
  dependence it holds after the step was held by something giving to it
  (`Flow.inherited_from_giver`, `Flow.Inherits.from_giver`; read of forming:
  `Flow.forms_from_giver`), and where nothing taking part depends on `c`, nothing coming to
  stand depends on `c` after the step (`Flow.no_new_dependence`). Transmission lets descent
  vary a need, never which conditions are depended on; in `novel` the child depends on its
  parent, which depended on nothing.
* **The evolution laws, the premise inside.** The bounds of `Flow.transmitted_supported` and
  `Flow.transmitted_within` hold at one descent from inheritance and the need within `δ`
  there, the giver supported (`Flow.inherited_supported_at`, `Flow.inherited_within_at`, and
  for the flow `Flow.inherited_supported`, `Flow.inherited_within`). At a relatum coming to
  stand they need only that *some* supported giver held the dependence within `δ`
  (`Flow.TransmitsFromSome`, `Flow.fromSome_supported`, `Flow.fromSome_within`), which
  transmission gives under balance (`Flow.TransmitsWithin.fromSome`) and which is strictly
  weaker: a child given its standing by two givers, one depending on the pool and one not,
  depends on the pool; the flow balances, only active relata give, activity needs support,
  and transmission fails for every `δ` while the law holds (`TwoGivers.twofold`).
* **The need half follows from support.** Where the descendant is active and supported at its
  first standing step, its need is within any bound on the condition's level there of every
  giver's (`Web.needsWithinAt_of_supported`): with activity needing support and every relatum
  embodied, the need half holds within any bound on levels (`Flow.needsWithin_of_embodied`).
  A finite, balanced, dissipative world bounds every level by the total standing at the
  first step (`World.Finite.level_le`), so in a finite world meeting balance, dissipation,
  embodiment and activity needing support transmission is exactly inheritance
  (`World.transmitting_iff_inherits`; with a bound on levels,
  `World.transmitting_iff_inherits_bounded`).
  Without transmission, a descendant supported at its first standing step bounds its own
  need: with what was taken from the condition across the giving step, it is at most the
  condition's level at that step with what was given to it (`Flow.descendant_supported_at`,
  `Flow.embodied_descendant`). Transmission carries the bound to a descendant not supported
  as it comes to stand and moves it to the giving step (`Drawdown.carried`).
* **What derives inheritance.** No law kept by dropping a dependence derives transmission
  where it binds: such a condition on worlds implying transmission implies that transmission
  does not bind (`World.vacuous_of_drop_invariant`). A reading of the exchange is such a law:
  a relatum depends at its first standing step only on what each relatum giving to it drew
  on at the giving step (`Flow.DependsOnDrawn`), or took from across it (`Flow.DependsOnFed`,
  which gives the first where only active relata take and only from what they draw on,
  `Flow.dependsOnDrawn_of_fed`); both are kept by dropping a dependence
  (`Flow.DependsOnDrawn.drop`, `Flow.DependsOnFed.drop`), so with finiteness and the seven
  other premises the reading of drawing does not give transmission
  (`World.drawn_not_enough`). With one law requiring dependence, at the giver, that drawing
  on `c` is depending on it (`Web.DrawingDepends`), the reading gives inheritance
  (`Flow.inherits_of_drawn`, `Flow.inherits_of_fed`), and in a finite world meeting balance,
  dissipation, embodiment and activity needing support it gives transmission
  (`World.transmitting_of_drawn`, `World.transmitting_of_fed`), not vacuously: in the finite
  hatch whose parent also depends on itself all of these hold and transmission binds
  (`World.bearingHatch_derived`). Each is needed, among finite
  worlds meeting the seven other premises (`World.drawn_and_link_needed`): with the parent's
  dependence on the food dropped from the finite hatch, the reading holds and the link fails
  (`World.drawn_without_link`); in `novel` the link holds of the parent, on which nothing
  draws, and the reading fails (`World.link_without_drawn`).

So transmission does not follow from the core's other premises, and no law that only limits
dependence, as a reading of the exchange, levels, activity, drawing and needs does, derives
it: it is a law of how dependence forms at coming to stand, stated at one descent. What
derives it is a reading of the descendant's dependence off its givers' exchange together with
a law requiring the givers' dependence on what they draw on; the need half follows from
support where the descendant is active as it comes to stand and levels are bounded. Whether
actual descent forms dependences so, how reconstruction and development carry them, and where
descent forms new dependences, as when young come to depend on their parents, are matters of
correspondence. The readings are the AI's, adopted on Ren's delegation of 15 October 2026
(DELEGATED-CHOICES D31). No ethical predicate, ranking or axiom occurs.
* **Forming anew, necessary and sufficient.** A dependence forms anew at a descent (`Web.FormsAnewAt`: the
  descendant holds it, the giver did not) exactly where inheritance fails, the giver's dependence
  stable (`Web.inheritsAt_iff_not_formsAnew`), and, depending and drawing coinciding at the giver, exactly
  where the descendant depends on what its giver did not draw on (`Web.formsAnew_iff_undrawn`).
  Inheritance gives the drawing reading at a descent exactly where the giver draws on what it holds
  and passes on (`Web.drawn_necessary_iff`), so the reading of drawing is inheritance with the
  givers drawing what they pass on (`Flow.PassesDrawn`, `Flow.dependsOnDrawn_iff`), the necessary
  half of `inherits_of_drawn`; with depending and drawing coinciding, inheritance, the reading of
  drawing and no descendant depending on what its giver did not draw on are one
  (`Flow.inherits_iff_none_undrawn`).
-/

namespace Becoming

/-! ## The two laws of a descent -/

namespace Web

variable {F C : Type} (W : Web F C)

/-- Inheritance at a descent across the step from `t`: a dependence on `c` that `x` holds at
its first standing step, `g` held at the giving step. -/
def InheritsAt (t : Nat) (x g : F) (c : C) : Prop :=
  W.requires (t + 1) x c → W.requires t g c

/-- The need within `δ` at a descent across the step from `t`: where `x` depends on `c` at
its first standing step and `g` did at the giving step, `x` needs it at most `δ` more. -/
def NeedsWithinAt (t : Nat) (x g : F) (c : C) (δ : Nat) : Prop :=
  W.requires (t + 1) x c → W.requires t g c → W.need (t + 1) x c ≤ W.need t g c + δ

/-- A relatum depends on `c` wherever it draws on `c`. -/
def DrawingDepends (c : C) : Prop :=
  ∀ t g, W.draws t g c → W.requires t g c

/-- The web with `g`'s dependence on `c` at step `t` dropped; nothing else changes. -/
def drop (t : Nat) (g : F) (c : C) : Web F C :=
  { W with requires := fun s y d => W.requires s y d ∧ ¬ (s = t ∧ y = g ∧ d = c) }

variable {W}

/-- Transmission at one descent is inheritance with the need within `δ`. -/
theorem transmits_at_iff {t : Nat} {x g : F} {c : C} {δ : Nat} :
    (W.requires (t + 1) x c → W.requires t g c ∧ W.need (t + 1) x c ≤ W.need t g c + δ) ↔
      W.InheritsAt t x g c ∧ W.NeedsWithinAt t x g c δ :=
  ⟨fun transmits => ⟨fun depends => (transmits depends).1,
     fun depends _ => (transmits depends).2⟩,
   fun ⟨inherits, within⟩ depends =>
    ⟨inherits depends, within depends (inherits depends)⟩⟩

/-! ## Inheritance is a law of forming -/

/-- Inheritance covers a dependence forming at the descendant across the step and one it
held through the step while it stood at nothing. -/
theorem InheritsAt.split {t : Nat} {x g : F} {c : C} (inherits : W.InheritsAt t x g c) :
    (W.Forms t x c → W.requires t g c) ∧
      (W.requires t x c → W.requires (t + 1) x c → W.requires t g c) :=
  ⟨fun forms => inherits forms.2, fun _ depends => inherits depends⟩

/-- Where the descendant held no dependence on `c` at the giving step, inheritance is exactly
the law of forming: a dependence on `c` forming at it as it comes to stand was held by the
giver. -/
theorem inheritsAt_iff_forming {t : Nat} {x g : F} {c : C} (bare : ¬ W.requires t x c) :
    W.InheritsAt t x g c ↔ (W.Forms t x c → W.requires t g c) :=
  ⟨fun inherits forms => inherits forms.2, fun forming depends => forming ⟨bare, depends⟩⟩

/-- Where whether the descendant held it at the giving step is decided, forming and holding
make inheritance. -/
theorem inheritsAt_of_split {t : Nat} {x g : F} {c : C} [Decidable (W.requires t x c)]
    (forming : W.Forms t x c → W.requires t g c)
    (holding : W.requires t x c → W.requires (t + 1) x c → W.requires t g c) :
    W.InheritsAt t x g c :=
  fun depends => if held : W.requires t x c then holding held depends
    else forming ⟨held, depends⟩

/-- Without deciding it, they make inheritance irrefutable. -/
theorem inheritsAt_not_not {t : Nat} {x g : F} {c : C}
    (forming : W.Forms t x c → W.requires t g c)
    (holding : W.requires t x c → W.requires (t + 1) x c → W.requires t g c)
    (depends : W.requires (t + 1) x c) : ¬ ¬ W.requires t g c :=
  fun lacks => lacks (forming ⟨fun held => lacks (holding held depends), depends⟩)

/-- Where the descendant is active and supported at its first standing step and the condition
stands there at no more than `B`, its need is within `B` of the giver's. -/
theorem needsWithinAt_of_supported {t : Nat} {x g : F} {c : C} {B : Nat}
    (supported : W.Supported (t + 1) x) (bounded : W.level (t + 1) c ≤ B) :
    W.NeedsWithinAt t x g c B :=
  fun depends _ => Nat.le_trans (supported c depends)
    (Nat.le_trans bounded (Nat.le_add_left B _))

/-! ## Dropping a dependence -/

variable {t : Nat} {g : F} {c : C}

/-- Dropping a dependence keeps support. -/
theorem drop_supported {s : Nat} {y : F} (supported : W.Supported s y) :
    (W.drop t g c).Supported s y :=
  fun d depends => supported d depends.1

/-- So it keeps activity needing support. -/
theorem drop_dependent (dependent : W.Dependent) : (W.drop t g c).Dependent :=
  fun s y active => drop_supported (dependent s y active)

/-- A dependence at the next step is kept. -/
theorem drop_keeps_next {x : F} {d : C} (depends : W.requires (t + 1) x d) :
    (W.drop t g c).requires (t + 1) x d :=
  ⟨depends, fun same => Nat.succ_ne_self t same.1⟩

/-- Dropping the giver's dependence on what the descendant depends on breaks inheritance. -/
theorem drop_not_inherits {x : F} (depends : W.requires (t + 1) x c) :
    ¬ (W.drop t g c).InheritsAt t x g c :=
  fun inherits => (inherits (drop_keeps_next depends)).2 ⟨rfl, rfl, rfl⟩

/-! ## Forming anew, necessary and sufficient -/

/-- A dependence on `c` forms anew at a descent across the step from `t`: the descendant `x`
holds it at its first standing step and the giver `g` did not hold it at the giving step. -/
def FormsAnewAt (t : Nat) (x g : F) (c : C) : Prop :=
  W.requires (t + 1) x c ∧ ¬ W.requires t g c

/-- **Inheritance is no dependence forming anew.** Inheritance at a descent excludes a
dependence forming anew there; back, where the giver's dependence is stable (double negation
removable, as wherever it is decided), excluding it gives inheritance. -/
theorem inheritsAt_iff_not_formsAnew {t : Nat} {x g : F} {c : C}
    (stable : ¬ ¬ W.requires t g c → W.requires t g c) :
    W.InheritsAt t x g c ↔ ¬ W.FormsAnewAt t x g c :=
  ⟨fun inherits ⟨depends, fresh⟩ => fresh (inherits depends),
   fun none depends => stable fun fresh => none ⟨depends, fresh⟩⟩

/-- **A dependence forms anew exactly where the descendant depends on what its giver did not
draw on**, where depending and drawing coincide at the giver at the giving step: the law of
forming, necessary and sufficient, in the vocabulary of drawing and depending. -/
theorem formsAnew_iff_undrawn {t : Nat} {x g : F} {c : C}
    (link : W.draws t g c → W.requires t g c) (held : W.requires t g c → W.draws t g c) :
    W.FormsAnewAt t x g c ↔ W.requires (t + 1) x c ∧ ¬ W.draws t g c :=
  ⟨fun ⟨depends, fresh⟩ => ⟨depends, fun draws => fresh (link draws)⟩,
   fun ⟨depends, undrawn⟩ => ⟨depends, fun holds => undrawn (held holds)⟩⟩

/-- **Where inheritance reads off the drawing.** At a descent, inheritance gives that the giver
drew on what the descendant depends on exactly where the giver draws on what it holds and passes
on: a dependence the giver held without drawing on it is inherited without being drawn. -/
theorem drawn_necessary_iff {t : Nat} {x g : F} {c : C} :
    (W.InheritsAt t x g c → W.requires (t + 1) x c → W.draws t g c) ↔
      (W.requires (t + 1) x c → W.requires t g c → W.draws t g c) :=
  ⟨fun reads depends holds => reads (fun _ => holds) depends,
   fun passes inherits depends => passes depends (inherits depends)⟩

end Web

/-- Forming and holding make inheritance in every web, with excluded middle as a hypothesis. -/
theorem split_of_em (em : ∀ p : Prop, p ∨ ¬ p) {F C : Type} (W : Web F C) (t : Nat)
    (x g : F) (c : C) (forming : W.Forms t x c → W.requires t g c)
    (holding : W.requires t x c → W.requires (t + 1) x c → W.requires t g c) :
    W.InheritsAt t x g c :=
  fun depends => match em (W.requires t x c) with
    | .inl held => holding held depends
    | .inr bare => forming ⟨bare, depends⟩

namespace Split

/-- Two relata, the descendant `true` and the giver `false`: the descendant comes to stand
across the first step; at the first step the descendant holds `q` and the giver `p`, and
after it every dependence holds. -/
def web (p q : Prop) : Web Bool Bool where
  level t y := match t, y with
    | 0, _ => 0
    | _ + 1, true => 1
    | _ + 1, false => 0
  active _ _ := False
  requires t y _ := match t, y with
    | 0, true => q
    | 0, false => p
    | _ + 1, _ => True
  need _ _ _ := 0
  draws _ _ _ := False

/-- One unit at the descendant, nothing at the giver. -/
def toDescendant : Bool → Nat
  | true => 1
  | false => 0

/-- Across the first step the giver gives the descendant one unit. -/
def flow : Flow Bool Bool where
  present _ := [false]
  take _ _ _ := 0
  give t f y := match t, f with
    | 0, false => toDescendant y
    | 0, true => 0
    | _ + 1, _ => 0

theorem descends (p q : Prop) : flow.DescendsAt (web p q) 0 true false :=
  ⟨.head _, Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩

end Split

/-- Asked of every descent, that forming and holding make inheritance is excluded middle. -/
theorem split_iff_em :
    (∀ (L : Flow Bool Bool) (W : Web Bool Bool) (t : Nat) (x g c : Bool),
      L.DescendsAt W t x g → (W.Forms t x c → W.requires t g c) →
      (W.requires t x c → W.requires (t + 1) x c → W.requires t g c) →
        W.InheritsAt t x g c) ↔
      ∀ p : Prop, p ∨ ¬ p :=
  ⟨fun split p => split Split.flow (Split.web (p ∨ ¬ p) p) 0 true false true
      (Split.descends _ _) (fun forms => .inr forms.1) (fun held _ => .inl held) trivial,
   fun em _ W t x g c _ => split_of_em em W t x g c⟩

/-! ## The laws of a flow -/

namespace Flow

variable {X : Type}

section

variable (L : Flow X X) (W : Web X X)

/-- The flow's descents inherit the dependence on `c`. -/
def Inherits (c : X) : Prop :=
  ∀ t x g, L.DescendsAt W t x g → W.InheritsAt t x g c

/-- At the flow's descents the need of `c` is within `δ`. -/
def NeedsWithin (c : X) (δ : Nat) : Prop :=
  ∀ t x g, L.DescendsAt W t x g → W.NeedsWithinAt t x g c δ

/-- Each dependence on `c` a relatum holds as it comes to stand was held by some relatum giving
to it, and the relatum needs `c` at most `δ` more than that giver did. -/
def TransmitsFromSome (c : X) (δ : Nat) : Prop :=
  ∀ t x, W.ComesToStand t x → W.requires (t + 1) x c →
    ∃ g, L.DescendsAt W t x g ∧ W.requires t g c ∧ W.need (t + 1) x c ≤ W.need t g c + δ

/-- A reading of the exchange: a relatum depends on `c` at its first standing step only where
each relatum giving to it drew on `c` at the giving step. -/
def DependsOnDrawn (c : X) : Prop :=
  ∀ t x g, L.DescendsAt W t x g → W.requires (t + 1) x c → W.draws t g c

/-- A reading of the exchange: a relatum depends on `c` at its first standing step only where
each relatum giving to it took from `c` across the giving step. -/
def DependsOnFed (c : X) : Prop :=
  ∀ t x g, L.DescendsAt W t x g → W.requires (t + 1) x c → 0 < L.take t g c

end

variable {L : Flow X X} {W : Web X X}

/-- Transmission is inheritance with the need within `δ`. -/
theorem transmitsWithin_iff {c : X} {δ : Nat} :
    L.TransmitsWithin W c δ ↔ L.Inherits W c ∧ L.NeedsWithin W c δ :=
  ⟨fun transmits =>
    ⟨fun t x g descends => (Web.transmits_at_iff.mp (transmits t x g descends)).1,
     fun t x g descends => (Web.transmits_at_iff.mp (transmits t x g descends)).2⟩,
   fun ⟨inherits, within⟩ t x g descends =>
    Web.transmits_at_iff.mpr ⟨inherits t x g descends, within t x g descends⟩⟩

/-- Where no descendant held a dependence on `c` at the giving step, transmission is the law
of forming with the need within `δ`: a dependence on `c` forming at a relatum as it comes to
stand was held by each relatum giving to it. -/
theorem transmitsWithin_iff_forming {c : X} {δ : Nat}
    (bare : ∀ t x g, L.DescendsAt W t x g → ¬ W.requires t x c) :
    L.TransmitsWithin W c δ ↔
      (∀ t x g, L.DescendsAt W t x g → W.Forms t x c → W.requires t g c) ∧
        L.NeedsWithin W c δ :=
  ⟨fun transmits => match transmitsWithin_iff.mp transmits with
    | ⟨inherits, within⟩ => ⟨fun t x g descends =>
        (Web.inheritsAt_iff_forming (bare t x g descends)).mp (inherits t x g descends), within⟩,
   fun ⟨forming, within⟩ => transmitsWithin_iff.mpr ⟨fun t x g descends =>
     (Web.inheritsAt_iff_forming (bare t x g descends)).mpr (forming t x g descends), within⟩⟩

/-- Where whether a descendant held it at the giving step is decided, transmission is the law
of forming, the law of holding and the need within `δ`. -/
theorem transmitsWithin_iff_split {c : X} {δ : Nat} [∀ t x, Decidable (W.requires t x c)] :
    L.TransmitsWithin W c δ ↔
      (∀ t x g, L.DescendsAt W t x g → W.Forms t x c → W.requires t g c) ∧
      (∀ t x g, L.DescendsAt W t x g → W.requires t x c → W.requires (t + 1) x c →
        W.requires t g c) ∧ L.NeedsWithin W c δ :=
  ⟨fun transmits => match transmitsWithin_iff.mp transmits with
    | ⟨inherits, within⟩ => ⟨fun t x g descends => (inherits t x g descends).split.1,
        fun t x g descends => (inherits t x g descends).split.2, within⟩,
   fun ⟨forming, holding, within⟩ => transmitsWithin_iff.mpr ⟨fun t x g descends =>
     Web.inheritsAt_of_split (forming t x g descends) (holding t x g descends), within⟩⟩

/-! ## No new dependence by descent -/

/-- With balance at a relatum across a step, if it comes to stand it descends from something
taking part in the step: its standing is given to it. -/
theorem descends_of_comes {t : Nat} {x : X}
    (balances : W.level (t + 1) x + L.taken t x = W.level t x + L.given t x)
    (comes : W.ComesToStand t x) : ∃ g, L.DescendsAt W t x g :=
  match total_pos (q := fun f => L.give t f x) (L.present t)
      (BalancesOn.rise_given (L := L) (W := W) (cs := [x])
        (fun _ mem => match mem with | .head _ => balances) (.head []) comes.rises) with
  | ⟨g, present, gives⟩ => ⟨g, present, gives, comes⟩

/-- With balance at a relatum coming to stand and inheritance at its descents across the
step, each dependence it holds after the step was held by something giving to it. -/
theorem inherited_from_giver {t : Nat} {x c : X}
    (balances : W.level (t + 1) x + L.taken t x = W.level t x + L.given t x)
    (inherits : ∀ g, L.DescendsAt W t x g → W.InheritsAt t x g c)
    (comes : W.ComesToStand t x) (depends : W.requires (t + 1) x c) :
    ∃ g, L.DescendsAt W t x g ∧ W.requires t g c :=
  match descends_of_comes balances comes with
  | ⟨g, descends⟩ => ⟨g, descends, inherits g descends depends⟩

/-- Read of forming: a dependence on `c` forming at a relatum as it comes to stand was held
by something giving to it. -/
theorem forms_from_giver {t : Nat} {x c : X}
    (balances : W.level (t + 1) x + L.taken t x = W.level t x + L.given t x)
    (inherits : ∀ g, L.DescendsAt W t x g → W.InheritsAt t x g c)
    (comes : W.ComesToStand t x) (forms : W.Forms t x c) :
    ∃ g, L.DescendsAt W t x g ∧ W.requires t g c :=
  inherited_from_giver balances inherits comes forms.2

/-- Descent forms no new dependence: where nothing taking part in a step depends on `c`,
nothing coming to stand across it, with balance at it and inheritance at its descents,
depends on `c` after the step. -/
theorem no_new_dependence {t : Nat} {x c : X}
    (balances : W.level (t + 1) x + L.taken t x = W.level t x + L.given t x)
    (inherits : ∀ g, L.DescendsAt W t x g → W.InheritsAt t x g c)
    (none : ∀ g, g ∈ L.present t → ¬ W.requires t g c) (comes : W.ComesToStand t x) :
    ¬ W.requires (t + 1) x c :=
  fun depends => match inherited_from_giver balances inherits comes depends with
  | ⟨g, descends, held⟩ => none g descends.1 held

/-- In a balanced flow with inheritance, each dependence a relatum holds as it comes to stand
was held by something giving to it. -/
theorem Inherits.from_giver (balances : L.Balances W) {c : X} (inherits : L.Inherits W c)
    {t : Nat} {x : X} (comes : W.ComesToStand t x) (depends : W.requires (t + 1) x c) :
    ∃ g, L.DescendsAt W t x g ∧ W.requires t g c :=
  inherited_from_giver (balances t x) (fun g => inherits t x g) comes depends

/-- In a balanced flow, transmission gives transmission from some giver. -/
theorem TransmitsWithin.fromSome (balances : L.Balances W) {c : X} {δ : Nat}
    (transmits : L.TransmitsWithin W c δ) : L.TransmitsFromSome W c δ :=
  fun t x comes depends => match descends_of_comes (balances t x) comes with
  | ⟨g, descends⟩ => ⟨g, descends, transmits t x g descends depends⟩

/-! ## The evolution laws with the premise inside -/

/-- What is transmitted was selected, at one descent: with inheritance and the need within
`δ` there and the giver supported, the descendant's need is at most the condition's level at
the giving step, plus `δ`. -/
theorem inherited_supported_at {c : X} {δ t : Nat} {x g : X}
    (inherits : W.InheritsAt t x g c) (within : W.NeedsWithinAt t x g c δ)
    (supported : W.Supported t g) (depends : W.requires (t + 1) x c) :
    W.need (t + 1) x c ≤ W.level t c + δ :=
  transmitted_supported_at (Web.transmits_at_iff.mpr ⟨inherits, within⟩) supported depends

/-- Activity sets later selection, at one descent: with balance at the condition across each
step of the stretch, inheritance and the need within `δ` at the descent and the giver
supported, the descendant's need with everything taken from the condition since is at most
its level at the start with everything given since, plus `δ`. -/
theorem inherited_within_at {c : X} {δ S n : Nat} {x g : X}
    (balances : ∀ s, S ≤ s → s < S + n →
      W.level (s + 1) c + L.taken s c = W.level s c + L.given s c)
    (inherits : W.InheritsAt (S + n) x g c) (within : W.NeedsWithinAt (S + n) x g c δ)
    (supported : W.Supported (S + n) g) (depends : W.requires (S + n + 1) x c) :
    W.need (S + n + 1) x c + total (steps S n) (fun s => L.taken s c) ≤
      W.level S c + total (steps S n) (fun s => L.given s c) + δ :=
  transmitted_within_at balances (Web.transmits_at_iff.mpr ⟨inherits, within⟩) supported
    depends

/-- What is transmitted was selected: with only active relata giving and activity needing
support, inheritance and the need within `δ` bound a descendant's need by the condition's
level at the giving step, plus `δ`. -/
theorem inherited_supported (acting : L.Acting W) (dependent : W.Dependent) {c : X}
    {δ : Nat} (inherits : L.Inherits W c) (within : L.NeedsWithin W c δ) {t : Nat} {x g : X}
    (descends : L.DescendsAt W t x g) (depends : W.requires (t + 1) x c) :
    W.need (t + 1) x c ≤ W.level t c + δ :=
  inherited_supported_at (inherits t x g descends) (within t x g descends)
    (descends.supported acting dependent) depends

/-- Activity sets later selection, in a balanced flow, from inheritance and the need within
`δ`. -/
theorem inherited_within (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {c : X} {δ : Nat} (inherits : L.Inherits W c)
    (within : L.NeedsWithin W c δ) {S n : Nat} {x g : X} (descends : L.DescendsAt W (S + n) x g)
    (depends : W.requires (S + n + 1) x c) :
    W.need (S + n + 1) x c + total (steps S n) (L.uptake [c]) ≤
      W.level S c + total (steps S n) (L.replenishment [c]) + δ :=
  inherited_within_at (fun s _ _ => balances s c) (inherits (S + n) x g descends)
    (within (S + n) x g descends) (descends.supported acting dependent) depends

/-- The law at a relatum coming to stand needs only one supported giver: with only active
relata giving and activity needing support, transmission from some giver bounds its need by
the condition's level at the giving step, plus `δ`. -/
theorem fromSome_supported (acting : L.Acting W) (dependent : W.Dependent) {c : X} {δ : Nat}
    (transmits : L.TransmitsFromSome W c δ) {t : Nat} {x : X} (comes : W.ComesToStand t x)
    (depends : W.requires (t + 1) x c) : W.need (t + 1) x c ≤ W.level t c + δ :=
  match transmits t x comes depends with
  | ⟨_, descends, held, within⟩ =>
    transmitted_supported_at (fun _ => ⟨held, within⟩) (descends.supported acting dependent)
      depends

/-- And activity sets later selection, in a balanced flow, from transmission from some
giver. -/
theorem fromSome_within (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {c : X} {δ : Nat} (transmits : L.TransmitsFromSome W c δ)
    {S n : Nat} {x : X} (comes : W.ComesToStand (S + n) x)
    (depends : W.requires (S + n + 1) x c) :
    W.need (S + n + 1) x c + total (steps S n) (L.uptake [c]) ≤
      W.level S c + total (steps S n) (L.replenishment [c]) + δ :=
  match transmits (S + n) x comes depends with
  | ⟨_, descends, held, within⟩ =>
    transmitted_within_at (fun s _ _ => balances s c) (fun _ => ⟨held, within⟩)
      (descends.supported acting dependent) depends

/-- Without transmission, a relatum supported at its first standing step, with balance at the
condition across the giving step: its need, with what was taken from the condition across
that step, is at most the condition's level at that step with what was given to it. -/
theorem descendant_supported_at {t : Nat} {x c : X} (supported : W.Supported (t + 1) x)
    (balances : W.level (t + 1) c + L.taken t c = W.level t c + L.given t c)
    (depends : W.requires (t + 1) x c) :
    W.need (t + 1) x c + L.taken t c ≤ W.level t c + L.given t c :=
  Nat.le_trans (Nat.add_le_add_right (supported c depends) _) (Nat.le_of_eq balances)

/-- So in a balanced flow where activity needs support, an embodied descendant's need at its
first standing step, with what was taken from the condition across the giving step, is at
most the condition's level at that step with what was given to it: no transmission is used. -/
theorem embodied_descendant (balances : L.Balances W) (dependent : W.Dependent) {t : Nat}
    {x g c : X} (embodied : W.Embodied x) (descends : L.DescendsAt W t x g)
    (depends : W.requires (t + 1) x c) :
    W.need (t + 1) x c + L.taken t c ≤ W.level t c + L.given t c :=
  descendant_supported_at (dependent (t + 1) x ((embodied (t + 1)).mpr descends.2.2.2))
    (balances t c) depends

/-! ## The need half follows from support -/

/-- With activity needing support and every relatum embodied, the need half holds within any
bound on the condition's level. -/
theorem needsWithin_of_embodied (dependent : W.Dependent) (embodied : ∀ x, W.Embodied x)
    {c : X} {B : Nat} (bounded : ∀ t, W.level (t + 1) c ≤ B) : L.NeedsWithin W c B :=
  fun t x _ descends => Web.needsWithinAt_of_supported
    (dependent (t + 1) x ((embodied x (t + 1)).mpr descends.2.2.2)) (bounded t)

/-! ## Dropping a dependence breaks transmission -/

/-- At a descent whose descendant depends on `c` at its first standing step, the flow does not
transmit `c` within any `δ` once the giver's dependence on `c` at the giving step is
dropped. -/
theorem drop_untransmitted {t : Nat} {x g c : X} (descends : L.DescendsAt W t x g)
    (depends : W.requires (t + 1) x c) (δ : Nat) : ¬ L.TransmitsWithin (W.drop t g c) c δ :=
  fun transmits => Web.drop_not_inherits depends fun kept => (transmits t x g descends kept).1

/-! ## What derives inheritance -/

/-- The reading of drawing, with drawing being depending, gives inheritance. -/
theorem inherits_of_drawn {c : X} (drawn : L.DependsOnDrawn W c) (link : W.DrawingDepends c) :
    L.Inherits W c :=
  fun t x g descends depends => link t g (drawn t x g descends depends)

/-- Where only active relata take, and only from what they draw on, the reading of feeding
gives the reading of drawing. -/
theorem dependsOnDrawn_of_fed (taking : L.Taking W) {c : X} (fed : L.DependsOnFed W c) :
    L.DependsOnDrawn W c :=
  fun t x g descends depends => (taking t g c descends.1 (fed t x g descends depends)).2

/-- So the reading of feeding, with drawing being depending, gives inheritance. -/
theorem inherits_of_fed (taking : L.Taking W) {c : X} (fed : L.DependsOnFed W c)
    (link : W.DrawingDepends c) : L.Inherits W c :=
  inherits_of_drawn (dependsOnDrawn_of_fed taking fed) link

/-- The reading of drawing does not see a dropped dependence. -/
theorem DependsOnDrawn.drop {c : X} (drawn : L.DependsOnDrawn W c) (t : Nat) (g d : X) :
    L.DependsOnDrawn (W.drop t g d) c :=
  fun s x h descends depends => drawn s x h descends depends.1

/-- Nor does the reading of feeding. -/
theorem DependsOnFed.drop {c : X} (fed : L.DependsOnFed W c) (t : Nat) (g d : X) :
    L.DependsOnFed (W.drop t g d) c :=
  fun s x h descends depends => fed s x h descends depends.1

/-- The givers draw on what they hold and pass on: at every descent, a dependence on `c` the
descendant holds at its first standing step and the giver held at the giving step, the giver drew
on. -/
def PassesDrawn (L : Flow X X) (W : Web X X) (c : X) : Prop :=
  ∀ t x g, L.DescendsAt W t x g → W.requires (t + 1) x c → W.requires t g c → W.draws t g c

/-- **The reading of drawing is inheritance with the givers drawing what they pass on**: the
necessary half, with no premise; the sufficient half needs drawing to be depending
(`inherits_of_drawn`). So under that link the reading of drawing is necessary and sufficient for
inheritance exactly where the givers draw on what they pass on, and a dependence the giver holds
without drawing is inherited without the reading. -/
theorem dependsOnDrawn_iff {c : X} (link : W.DrawingDepends c) :
    L.DependsOnDrawn W c ↔ L.Inherits W c ∧ L.PassesDrawn W c :=
  ⟨fun drawn => ⟨inherits_of_drawn drawn link,
     fun t x g descends depends _ => drawn t x g descends depends⟩,
   fun ⟨inherits, passes⟩ t x g descends depends =>
     passes t x g descends depends (inherits t x g descends depends)⟩

/-- **No dependence forms anew by descent exactly where the reading of drawing holds**, where
depending and drawing coincide at the givers and the givers' dependences are stable: inheritance,
the reading of drawing, and no descendant depending on what its giver did not draw on are one. -/
theorem inherits_iff_none_undrawn {c : X} (link : W.DrawingDepends c)
    (held : ∀ t g, W.requires t g c → W.draws t g c)
    (stable : ∀ t g, ¬ ¬ W.requires t g c → W.requires t g c) :
    (L.Inherits W c ↔ L.DependsOnDrawn W c) ∧
      (L.Inherits W c ↔ ∀ t x g, L.DescendsAt W t x g →
        ¬ (W.requires (t + 1) x c ∧ ¬ W.draws t g c)) :=
  ⟨⟨fun inherits => (dependsOnDrawn_iff link).mpr
      ⟨inherits, fun t _ g _ _ holds => held t g holds⟩,
    fun drawn => inherits_of_drawn drawn link⟩,
   ⟨fun inherits t x g descends new =>
      (Web.inheritsAt_iff_not_formsAnew (stable t g)).mp (inherits t x g descends)
        ((Web.formsAnew_iff_undrawn (link t g) (held t g)).mpr new),
    fun none t x g descends =>
      (Web.inheritsAt_iff_not_formsAnew (stable t g)).mpr fun new =>
        none t x g descends ((Web.formsAnew_iff_undrawn (link t g) (held t g)).mp new)⟩⟩

end Flow

/-! ## Worlds -/

namespace World

/-- The world with `g`'s dependence on `c` at step `t` dropped: the same relata and flow, and
the same levels, activity, drawing and needs. -/
def drop (w : World) (t : Nat) (g c : w.Relatum) : World :=
  World.of w.Relatum w.flow (w.web.drop t g c)

variable {w : World}

/-- Dropping a dependence keeps every premise but transmission. -/
theorem drop_holds {t : Nat} {g c : w.Relatum} :
    ∀ p : Premise, p ≠ .transmitting → p.Holds w → p.Holds (w.drop t g c)
  | .dependent, _, dependent => Web.drop_dependent dependent
  | .balanced, _, balanced => balanced
  | .acting, _, acting => acting
  | .taking, _, taking => taking
  | .dissipative, _, dissipative => dissipative
  | .embodied, _, embodied => embodied
  | .counted, _, counted => counted
  | .transmitting, other, _ => absurd rfl other

/-- And finiteness. -/
theorem drop_finite {t : Nat} {g c : w.Relatum} (finite : w.Finite) : (w.drop t g c).Finite :=
  finite

/-- At a descent whose descendant depends on `c` at its first standing step, dropping the
giver's dependence on `c` at the giving step breaks transmission. -/
theorem drop_untransmitting {t : Nat} {x g c : w.Relatum}
    (descends : w.flow.DescendsAt w.web t x g) (depends : w.web.requires (t + 1) x c) :
    ¬ (w.drop t g c).Transmitting :=
  fun ⟨δ, transmits⟩ => Flow.drop_untransmitted descends depends δ (transmits c)

/-- Transmission is independent wherever it binds: a world meeting the seven other premises in
which transmission binds has a neighbour, one dependence dropped, meeting all but
transmission. -/
theorem drop_but (others : ∀ p : Premise, p ≠ .transmitting → p.Holds w)
    (binds : Premise.transmitting.Binds w) :
    ∃ t g c, (w.drop t g c).MeetsAllBut Transmitting :=
  match binds with
  | ⟨t, _, g, c, descends, depends⟩ =>
    have keeps : ∀ p : Premise, p ≠ .transmitting → p.Holds (w.drop t g c) :=
      fun p other => drop_holds p other (others p other)
    ⟨t, g, c, .of (fun _ => keeps .dependent fun no => nomatch no)
      (fun _ => keeps .balanced fun no => nomatch no) (fun _ => keeps .acting fun no => nomatch no)
      (fun _ => keeps .taking fun no => nomatch no)
      (fun _ => keeps .dissipative fun no => nomatch no)
      (fun _ => keeps .embodied fun no => nomatch no)
      (fun _ => keeps .counted fun no => nomatch no) (fun other => absurd rfl other)
      (drop_untransmitting descends depends)⟩

/-- No law that does not see a dropped dependence derives transmission where it binds: a
condition on worlds kept by dropping a dependence, and implying transmission, implies that
transmission does not bind. -/
theorem vacuous_of_drop_invariant {R : World → Prop}
    (invariant : ∀ (w : World) (t : Nat) (g c : w.Relatum), R w → R (w.drop t g c))
    (derives : ∀ w, R w → w.Transmitting) (holds : R w) : ¬ Premise.transmitting.Binds w :=
  fun ⟨t, _, g, c, descends, depends⟩ =>
    drop_untransmitting descends depends (derives _ (invariant w t g c holds))

/-! ## Finite worlds -/

/-- In a balanced, dissipative world listed by `all`, the total standing does not rise. -/
theorem stock_le_start {all : List w.Relatum} (distinct : Distinct all) (every : ∀ x, x ∈ all)
    (balanced : w.Balanced) (dissipative : w.Dissipative) :
    ∀ t, w.web.stock all t ≤ w.web.stock all 0
  | 0 => Nat.le_refl _
  | t + 1 => Nat.le_trans (Nat.le_trans (Nat.le_add_right _ (w.flow.takers all t))
      (Flow.Balances.runs_down balanced
        (dissipative all t distinct fun _ _ c out => absurd (every c) out)))
      (stock_le_start distinct every balanced dissipative t)

/-- In a finite, balanced, dissipative world every level is at most the total standing at the
first step. -/
theorem Finite.level_le (finite : w.Finite) (balanced : w.Balanced)
    (dissipative : w.Dissipative) : ∃ B, ∀ t c, w.web.level t c ≤ B :=
  match finite with
  | ⟨all, distinct, every⟩ => ⟨w.web.stock all 0, fun t c =>
      Nat.le_trans (le_total_of_mem (q := w.web.level t) (every c))
        (stock_le_start distinct every balanced dissipative t)⟩

/-- Where activity needs support, every relatum is embodied and levels are bounded,
transmission is exactly inheritance. -/
theorem transmitting_iff_inherits_bounded (dependent : w.Dependent) (embodied : w.Embodied)
    {B : Nat} (bounded : ∀ t c, w.web.level t c ≤ B) :
    w.Transmitting ↔ ∀ c, w.flow.Inherits w.web c :=
  ⟨fun ⟨_, transmits⟩ c => (Flow.transmitsWithin_iff.mp (transmits c)).1,
   fun inherits => ⟨B, fun c => Flow.transmitsWithin_iff.mpr ⟨inherits c,
     Flow.needsWithin_of_embodied dependent embodied fun t => bounded (t + 1) c⟩⟩⟩

/-- So in a finite world meeting balance, dissipation, embodiment and activity needing
support, transmission is exactly inheritance. -/
theorem transmitting_iff_inherits (finite : w.Finite) (balanced : w.Balanced)
    (dissipative : w.Dissipative) (embodied : w.Embodied) (dependent : w.Dependent) :
    w.Transmitting ↔ ∀ c, w.flow.Inherits w.web c :=
  match finite.level_le balanced dissipative with
  | ⟨_, bounded⟩ => transmitting_iff_inherits_bounded dependent embodied bounded

/-- And there the reading of drawing, with drawing being depending, gives transmission. -/
theorem transmitting_of_drawn (finite : w.Finite) (balanced : w.Balanced)
    (dissipative : w.Dissipative) (embodied : w.Embodied) (dependent : w.Dependent)
    (drawn : ∀ c, w.flow.DependsOnDrawn w.web c) (link : ∀ c, w.web.DrawingDepends c) :
    w.Transmitting :=
  (transmitting_iff_inherits finite balanced dissipative embodied dependent).mpr fun c =>
    Flow.inherits_of_drawn (drawn c) (link c)

/-- As does the reading of feeding, where only active relata take and only from what they
draw on. -/
theorem transmitting_of_fed (finite : w.Finite) (balanced : w.Balanced)
    (dissipative : w.Dissipative) (embodied : w.Embodied) (dependent : w.Dependent)
    (taking : w.Taking) (fed : ∀ c, w.flow.DependsOnFed w.web c)
    (link : ∀ c, w.web.DrawingDepends c) : w.Transmitting :=
  transmitting_of_drawn finite balanced dissipative embodied dependent
    (fun c => Flow.dependsOnDrawn_of_fed taking (fed c)) link

/-! ## Witnesses -/

/-- The finite hatch with the parent's dependence on the food at the first step dropped. -/
def droppedHatch : World :=
  finiteHatch.drop 0 .parent .food

/-- The child descends from the parent across the first step and depends on the food after
it. -/
theorem finiteHatch_descends : finiteHatch.flow.DescendsAt finiteHatch.web 0 .child .parent ∧
    finiteHatch.web.requires 1 .child .food :=
  ⟨⟨.head _, Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩, ⟨trivial, rfl⟩⟩

/-- In the finite hatch a relatum depends at its first standing step only on what the parent
drew on at the first step. -/
theorem finiteHatch_drawn (c : FiniteHatch.Relatum) :
    finiteHatch.flow.DependsOnDrawn finiteHatch.web c :=
  fun t _ g descends depends => match t, g, c, FiniteHatch.taking_part descends.1, depends with
  | _, _, _, ⟨rfl, rfl⟩, ⟨_, rfl⟩ => ⟨rfl, .inl rfl⟩

/-- A pair of finite worlds differing in one dependence, with the same relata, flow, levels,
activity, drawing and needs: the finite hatch meets all eight premises, and with the parent's
dependence on the food at the first step dropped every premise but transmission holds. -/
theorem finiteHatch_pair :
    finiteHatch.Premised ∧ droppedHatch.Finite ∧ droppedHatch.MeetsAllBut Transmitting :=
  have keeps : ∀ p : Premise, p ≠ .transmitting → p.Holds droppedHatch :=
    fun p other => drop_holds p other (finiteHatch_premised.meets (fun _ => true) p rfl)
  ⟨finiteHatch_premised, finiteHatch_finite,
   .of (fun _ => keeps .dependent fun no => nomatch no)
    (fun _ => keeps .balanced fun no => nomatch no) (fun _ => keeps .acting fun no => nomatch no)
    (fun _ => keeps .taking fun no => nomatch no)
    (fun _ => keeps .dissipative fun no => nomatch no)
    (fun _ => keeps .embodied fun no => nomatch no)
    (fun _ => keeps .counted fun no => nomatch no) (fun other => absurd rfl other)
    (drop_untransmitting finiteHatch_descends.1 finiteHatch_descends.2)⟩

/-- The reading of drawing without the link does not give inheritance: with the parent's
dependence on the food dropped, a finite world meets every premise but transmission and the
reading of drawing for every condition, the parent draws on the food without depending on
it, and the food's dependence is not inherited. -/
theorem drawn_without_link :
    droppedHatch.Finite ∧ droppedHatch.MeetsAllBut Transmitting ∧
    (∀ c, droppedHatch.flow.DependsOnDrawn droppedHatch.web c) ∧
    ¬ droppedHatch.web.DrawingDepends .food ∧
    ¬ droppedHatch.flow.Inherits droppedHatch.web .food :=
  ⟨finiteHatch_pair.2.1, finiteHatch_pair.2.2,
   fun c => (finiteHatch_drawn c).drop 0 .parent .food,
   fun link => (link 0 .parent ⟨rfl, .inl rfl⟩).2 ⟨rfl, rfl, rfl⟩,
   fun inherits => Web.drop_not_inherits finiteHatch_descends.2
     (inherits 0 .child .parent finiteHatch_descends.1)⟩

/-- The link without the reading does not give inheritance: in `novel`, a finite world
meeting every premise but transmission, nothing draws on the parent, so drawing on it is
depending on it, while the child depends on it at its first standing step and the parent
does not. -/
theorem link_without_drawn :
    novel.Finite ∧ novel.MeetsAllBut Transmitting ∧ novel.web.DrawingDepends .parent ∧
    ¬ novel.flow.DependsOnDrawn novel.web .parent ∧
    ¬ novel.flow.Inherits novel.web .parent :=
  have descends : novel.flow.DescendsAt novel.web 0 .child .parent :=
    ⟨.head _, Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
  ⟨novel_finite, novel_but, fun _ _ draws => (nomatch draws.2),
   fun drawn => (nomatch (drawn 0 .child .parent descends rfl).2),
   fun inherits => inherits 0 .child .parent descends rfl⟩

/-- So, among finite worlds meeting the seven other premises, neither the reading of drawing
nor the link gives inheritance alone. -/
theorem drawn_and_link_needed :
    (¬ ∀ w : World, w.Finite → (∀ Q, Q ∈ premises → Q ≠ Transmitting → Q w) →
      ∀ c, w.flow.DependsOnDrawn w.web c → w.flow.Inherits w.web c) ∧
    (¬ ∀ w : World, w.Finite → (∀ Q, Q ∈ premises → Q ≠ Transmitting → Q w) →
      ∀ c, w.web.DrawingDepends c → w.flow.Inherits w.web c) :=
  ⟨fun gives => drawn_without_link.2.2.2.2 (gives droppedHatch drawn_without_link.1
      drawn_without_link.2.1.1 .food (drawn_without_link.2.2.1 .food)),
   fun gives => link_without_drawn.2.2.2.2 (gives novel novel_finite novel_but.1 .parent
      link_without_drawn.2.2.1)⟩

/-- And the reading of drawing with finiteness and the seven other premises does not give
transmission: the condition is kept by dropping a dependence, and the finite hatch meets it
with transmission binding (`vacuous_of_drop_invariant`). -/
theorem drawn_not_enough :
    ¬ ∀ w : World, w.Finite → (∀ p : Premise, p ≠ .transmitting → p.Holds w) →
      (∀ c, w.flow.DependsOnDrawn w.web c) → w.Transmitting :=
  fun derives => vacuous_of_drop_invariant
    (R := fun w => w.Finite ∧ (∀ p : Premise, p ≠ .transmitting → p.Holds w) ∧
      ∀ c, w.flow.DependsOnDrawn w.web c)
    (fun _ t g c ⟨finite, others, drawn⟩ => ⟨drop_finite finite,
      fun p other => drop_holds p other (others p other), fun d => (drawn d).drop t g c⟩)
    (fun w ⟨finite, others, drawn⟩ => derives w finite others drawn) (w := finiteHatch)
    ⟨finiteHatch_finite, fun p _ => finiteHatch_premised.meets (fun _ => true) p rfl,
     finiteHatch_drawn⟩
    (finiteHatch_binds_but_census.2.2.2 .transmitting fun no => nomatch no)

/-- The finite hatch in which the parent also depends on itself, at need one: it bears on
itself, and depends on everything it draws on. -/
def bearingHatch : World :=
  World.of FiniteHatch.Relatum FiniteHatch.flow ({ FiniteHatch.web with requires := fun _ x y =>
      (Hatch.eats (FiniteHatch.into x) ∧ y = .food) ∨ (x = .parent ∧ y = .parent) })

/-- The derivation is not vacuous: in the finite hatch whose parent bears on itself, a finite
world meeting balance, dissipation, embodiment and activity needing support, a relatum depends
at its first standing step only on what the parent drew on, drawing is depending, transmission
binds, and so holds. -/
theorem bearingHatch_derived :
    bearingHatch.Finite ∧ bearingHatch.Balanced ∧ bearingHatch.Dissipative ∧
    bearingHatch.Embodied ∧ bearingHatch.Dependent ∧
    (∀ c, bearingHatch.flow.DependsOnDrawn bearingHatch.web c) ∧
    (∀ c, bearingHatch.web.DrawingDepends c) ∧ Premise.transmitting.Binds bearingHatch ∧
    bearingHatch.Transmitting :=
  have dependent : bearingHatch.Dependent := fun _ x active c requires =>
    match x, c, active, requires with
    | _, _, _, .inl ⟨_, rfl⟩ => Nat.le_add_left 1 _
    | _, _, active, .inr ⟨rfl, rfl⟩ => active
  have drawn : ∀ c, bearingHatch.flow.DependsOnDrawn bearingHatch.web c :=
    fun c t _ g descends depends =>
      match t, g, c, FiniteHatch.taking_part descends.1, depends with
      | _, _, _, ⟨rfl, rfl⟩, .inl ⟨_, rfl⟩ => ⟨rfl, .inl rfl⟩
      | _, _, _, ⟨rfl, rfl⟩, .inr ⟨_, rfl⟩ => ⟨rfl, .inr rfl⟩
  have link : ∀ c, bearingHatch.web.DrawingDepends c := fun c _ g draws =>
    match g, c, draws with
    | _, _, ⟨rfl, .inl rfl⟩ => .inl ⟨trivial, rfl⟩
    | _, _, ⟨rfl, .inr rfl⟩ => .inr ⟨rfl, rfl⟩
  ⟨finiteHatch_finite, finiteHatch_balanced, finiteHatch_dissipative, fun _ _ => Iff.rfl,
   dependent, drawn, link,
   ⟨0, .child, .parent, .food, ⟨.head _, Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩,
    .inl ⟨trivial, rfl⟩⟩,
   transmitting_of_drawn finiteHatch_finite finiteHatch_balanced finiteHatch_dissipative
     (fun _ _ => Iff.rfl) dependent drawn link⟩

end World

/-! ## What transmission carries -/

namespace Drawdown

/-- Transmission carries the bound to a descendant not supported as it comes to stand: the
descendant with the parent's need is not supported at its first standing step, its need
exceeding the pool's level there, while transmission bounds it by the pool's level at the
giving step. -/
theorem carried :
    ¬ web.Supported 1 .same ∧ web.level 1 .pool < web.need 1 .same .pool ∧
    web.need 1 .same .pool ≤ web.level 0 .pool + 0 :=
  ⟨same_unsupported 1 (Nat.le_refl 1), Nat.lt_succ_self 1,
   Flow.transmitted_supported acting dependent transmits descends_same Nat.zero_lt_one⟩

end Drawdown

/-! ## Two givers -/

namespace TwoGivers

/-- A pool, two givers and a child. -/
inductive Relatum where
  | pool
  | first
  | second
  | child

/-- The pool and the givers stand at one throughout; the child comes to stand at two. The
givers are active at the first step and the child after it. The first giver and the child
depend on the pool at need one; the second giver depends on nothing. -/
def web : Web Relatum Relatum where
  level t x := match x, t with
    | .pool, _ => 1
    | .first, _ => 1
    | .second, _ => 1
    | .child, 0 => 0
    | .child, _ + 1 => 2
  active t x := match x with
    | .pool => False
    | .first => t = 0
    | .second => t = 0
    | .child => 0 < t
  requires _ x c := (x = .first ∨ x = .child) ∧ c = .pool
  need _ _ _ := 1
  draws _ _ _ := False

/-- One unit at the child, nothing elsewhere. -/
def toChild : Relatum → Nat
  | .pool => 0
  | .first => 0
  | .second => 0
  | .child => 1

/-- Across the first step each giver gives the child one unit. -/
def flow : Flow Relatum Relatum where
  present t := match t with
    | 0 => [.first, .second]
    | _ + 1 => []
  take _ _ _ := 0
  give t f c := match t, f with
    | 0, .first => toChild c
    | 0, .second => toChild c
    | 0, .pool => 0
    | 0, .child => 0
    | _ + 1, _ => 0

theorem balances : flow.Balances web
  | 0, .pool => rfl
  | 0, .first => rfl
  | 0, .second => rfl
  | 0, .child => rfl
  | _ + 1, .pool => rfl
  | _ + 1, .first => rfl
  | _ + 1, .second => rfl
  | _ + 1, .child => rfl

theorem acting : flow.Acting web
  | 0, .first, _, _, _ => rfl
  | 0, .second, _, _, _ => rfl
  | 0, .pool, _, .tail _ (.tail _ no), _ => nomatch no
  | 0, .child, _, .tail _ (.tail _ no), _ => nomatch no
  | _ + 1, _, _, no, _ => nomatch no

theorem dependent : web.Dependent :=
  fun _ _ _ c requires => match c, requires with
  | _, ⟨_, rfl⟩ => Nat.le_refl 1

theorem comes_child {t : Nat} {x : Relatum} (comes : web.ComesToStand t x) :
    t = 0 ∧ x = .child :=
  match t, x, comes with
  | 0, .child, _ => ⟨rfl, rfl⟩
  | _, .pool, comes => absurd Nat.zero_lt_one comes.1
  | _, .first, comes => absurd Nat.zero_lt_one comes.1
  | _, .second, comes => absurd Nat.zero_lt_one comes.1
  | _ + 1, .child, comes => absurd Nat.zero_lt_two comes.1

theorem descends_first : flow.DescendsAt web 0 .child .first :=
  ⟨.head _, Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_two⟩

theorem descends_second : flow.DescendsAt web 0 .child .second :=
  ⟨.tail _ (.head _), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_two⟩

/-- Transmission from some giver is strictly weaker than transmission: the flow balances,
only active relata give and activity needs support; the child, given its standing by both
givers, depends on the pool, as the first giver did and the second did not. The dependence
is transmitted from some giver with no rise of need, so the evolution law bounds the child's
need by the pool's level at the giving step, while transmission fails for every `δ`. -/
theorem twofold :
    flow.Balances web ∧ flow.Acting web ∧ web.Dependent ∧
    flow.TransmitsFromSome web .pool 0 ∧
    (∀ δ, ¬ flow.TransmitsWithin web .pool δ) ∧ flow.DescendsAt web 0 .child .second ∧
    web.requires 1 .child .pool ∧ ¬ web.requires 0 .second .pool ∧
    web.need 1 .child .pool ≤ web.level 0 .pool + 0 :=
  have fromSome : flow.TransmitsFromSome web .pool 0 := fun t x comes _ =>
    match t, x, comes_child comes with
    | _, _, ⟨rfl, rfl⟩ => ⟨.first, descends_first, ⟨.inl rfl, rfl⟩, Nat.le_refl 1⟩
  have lacks : ¬ web.requires 0 .second .pool := fun requires => match requires.1 with
    | .inl no => nomatch no
    | .inr no => nomatch no
  ⟨balances, acting, dependent, fromSome,
   fun _ transmits => lacks (transmits 0 .child .second descends_second ⟨.inr rfl, rfl⟩).1,
   descends_second, ⟨.inr rfl, rfl⟩, lacks,
   Flow.fromSome_supported (t := 0) (x := .child) acting dependent fromSome
     ⟨Nat.lt_irrefl 0, Nat.zero_lt_two⟩ ⟨.inr rfl, rfl⟩⟩

end TwoGivers

end Becoming
