import Becoming.Laws
import Becoming.Labelled
import Becoming.Restoration

/-!
# Joint activity and difference-making

A loss across a step can be read in two ways. The relational reading of
`Becoming.Dependence` asks which formations participate in the condition that is lost:
every formation drawing on a consumed condition is consuming in the run. The but-for
reading asks whose part of the activity the loss depends on: a formation's part makes
the difference when, with that part withheld, the same move can still be taken and every
step by it keeps the dependence. The test is relative to the move: the move belongs to
the rest of the activity, and another move, an exogenous shock for instance, can break
the dependence whatever the formation does. It reads as intended when the move
determines the step (`Determined`), can be taken from every withheld configuration, and
the dependence still holds and is met with the part withheld: then either the part makes
the difference or the same move still breaks the dependence (`determined_dichotomy`).
A shock written into the step relation rather than the move makes the loss
overdetermined again (`Hidden`), a move that cannot be taken after withholding decides
nothing (`Tagged`), and when withholding the part itself leaves the dependence unmet,
the part being a support, the test is silent.

Withholding stays within the unfolding: the alternative is another configuration of
the same process, the one in which that part is absent. Nothing outside the process
supplies the comparison.

Results:
* Keeping and breaking across a change of configuration are exclusive. Along a run they
  are the keeping and breaking of `Becoming.Dependence`.
* When a loss is overdetermined, so that with any single part withheld the same move
  still breaks the dependence, no single formation's part makes the difference.
* The move decides (`Shock`): from one configuration a lone drawer's part makes the
  difference under the calm move, while under a shock the loss is overdetermined. With
  the shock written into the step relation of a single move instead, the step is not
  determined by the move, and the loss is overdetermined though the calm outcome of the
  same move would keep the dependence (`Hidden`).
* The but-for test extends from one part to a list of parts withheld together
  (`MakesDifferenceTogether`; one part is the one-element list). In every process, where
  the move can be taken with a part withheld and the dependence holds and is met there, the
  part makes the difference exactly when the same move no longer breaks the dependence
  (`makesDifference_iff`, no determinacy needed).
* The law of joint difference-making (`differenceOnlyTogether_iff`): where the move
  determines the step and, with any single member withheld, can be taken and leaves the
  dependence holding and met, the parts make the difference only together exactly when
  withholding all of them keeps the dependence and withholding any one of them leaves the
  same move breaking it. The direction from right to left holds in every process
  (`DifferenceOnlyTogether.of_breaks`); the other needs the move to be available
  (`Blocked`) and the need met (`NeedRises`) at each member's withheld configuration. A
  difference made only together needs at least two parts (`two_le_length`).
* Difference-making belongs to the joint activity, not to a formation's own part. In
  `Pool`, from configurations at the same level where a drawer takes the same amount, its
  part makes the difference when one other formation draws, and does not when two others
  draw; then the first two make the difference only together, an instance of the law
  (`first_two_only_together`). In both runs the relational reading counts the drawer as
  consuming, and it counts a formation that takes nothing as not consuming.
* The stepwise reading does not track difference-making (`Pool.within_share_undermines`):
  a drawer taking exactly the renewal makes no difference while another, taking two,
  does, yet the first drawer's event is undermining.
* Over a formation's events, the run-level and step-level tests come apart. Drawing
  beyond renewal at every step drains the condition, so the run consumes it. The first
  event's step keeps the dependence, so it does not undermine for any positive cycle.
  With any single event's draw withheld, indeed with every draw before any step
  withheld, the condition is still consumed: no finite set of events makes the
  run-level difference, which is fixed by the tail of the run. At the step that breaks
  the dependence, the same configuration drawing nothing would keep it: the breaking
  event makes the step-level difference, and the stepwise reading withholds it and
  every later event. Of the readings here, only the whole-run reading also withholds
  the first event.

No ethical predicate, ranking or axiom occurs. Whether withholding a part leaves the rest
of the activity as it was, the move included, and whether the move determines the step,
are modelling duties of each application: exogenous shocks belong in the move.
Responsibility is not inferred from either reading.
-/

namespace Becoming

open Generative

universe u v

variable {S : Type u} {A : Type v} {F C : Type}

/-- Withholding the parts of `fs` one after another. -/
def withholdAll (withhold : F → S → S) : List F → S → S
  | [], s => s
  | f :: fs, s => withholdAll withhold fs (withhold f s)

namespace Dependence

variable (K : Dependence S F C)

/-- The change from `s` to `t` keeps `g`'s dependence on `c` as it stands at `s`. -/
def Keeps (s t : S) (g : F) (c : C) : Prop :=
  K.need s g c ≤ K.level s c ∧ K.need s g c ≤ K.level t c

/-- The change from `s` to `t` breaks `g`'s dependence on `c`: met at `s`, not at `t`. -/
def Breaks (s t : S) (g : F) (c : C) : Prop :=
  K.requires s g c ∧ K.need s g c ≤ K.level s c ∧ K.level t c < K.need s g c

/-- The step from `s` by the move `a` breaks `g`'s dependence on `c`. -/
def BreaksBy (P : Process S A) (s : S) (a : A) (g : F) (c : C) : Prop :=
  ∃ t, P.step s a t ∧ K.Breaks s t g c

/-- The but-for test, the move held fixed: the step from `s` by `a` breaks the
dependence, and with `f`'s part withheld the same move can be taken and every step by it
keeps the dependence. -/
def MakesDifference (P : Process S A) (withhold : F → S → S) (f : F) (s : S) (a : A)
    (g : F) (c : C) : Prop :=
  K.BreaksBy P s a g c ∧ (∃ t, P.step (withhold f s) a t) ∧
    ∀ t, P.step (withhold f s) a t → K.Keeps (withhold f s) t g c

/-- With any single part withheld, the same move still breaks the dependence. -/
def Overdetermined (P : Process S A) (withhold : F → S → S) (s : S) (a : A) (g : F)
    (c : C) : Prop :=
  K.BreaksBy P s a g c ∧ ∀ f, K.BreaksBy P (withhold f s) a g c

variable {K}

theorem keeps_not_breaks {s t : S} {g : F} {c : C} (keeps : K.Keeps s t g c) :
    ¬ K.Breaks s t g c
  | ⟨_, _, fell⟩ => Nat.not_le_of_gt fell keeps.2

theorem along_kept {P : Process S A} (r : Run P) (n : Nat) (g : F) (c : C) :
    (K.along r).Kept n g c ↔ K.Keeps (r.state n) (r.state (n + 1)) g c :=
  Iff.rfl

theorem along_broken {P : Process S A} (r : Run P) (n : Nat) (g : F) (c : C) :
    (K.along r).Broken n g c ↔ K.Breaks (r.state n) (r.state (n + 1)) g c :=
  Iff.rfl

/-- When the loss is overdetermined, no single part makes the difference. -/
theorem Overdetermined.no_difference {P : Process S A} {withhold : F → S → S} {s : S}
    {a : A} {g : F} {c : C} (over : K.Overdetermined P withhold s a g c) (f : F) :
    ¬ K.MakesDifference P withhold f s a g c
  | ⟨_, _, keeps⟩ =>
    match over.2 f with
    | ⟨t, step, breaks⟩ => keeps_not_breaks (keeps t step) breaks

/-- When the move determines the step and can be taken with `f`'s part withheld, and the
dependence still holds and is met there, either `f`'s part makes the difference or the
same move still breaks the dependence. -/
theorem determined_dichotomy {P : Process S A} (determined : Determined P)
    {withhold : F → S → S} {f : F} {s : S} {a : A} {g : F} {c : C}
    (breaks : K.BreaksBy P s a g c) {t₀ : S} (available : P.step (withhold f s) a t₀)
    (depends : K.requires (withhold f s) g c)
    (met : K.need (withhold f s) g c ≤ K.level (withhold f s) c) :
    K.MakesDifference P withhold f s a g c ∨ K.BreaksBy P (withhold f s) a g c :=
  match Nat.lt_or_ge (K.level t₀ c) (K.need (withhold f s) g c) with
  | .inl fell => .inr ⟨t₀, available, depends, met, fell⟩
  | .inr held => .inl ⟨breaks, ⟨t₀, available⟩, fun _ step =>
      determined _ _ _ _ available step ▸ (⟨met, held⟩ : K.Keeps (withhold f s) t₀ g c)⟩

/-! ## Difference made by parts together -/

variable (K)

/-- The but-for test for the parts of `fs` together: the step from `s` by `a` breaks the
dependence, and with all of them withheld the same move can be taken and every step by it
keeps the dependence. -/
def MakesDifferenceTogether (P : Process S A) (withhold : F → S → S) (fs : List F) (s : S)
    (a : A) (g : F) (c : C) : Prop :=
  K.BreaksBy P s a g c ∧ (∃ t, P.step (withholdAll withhold fs s) a t) ∧
    ∀ t, P.step (withholdAll withhold fs s) a t → K.Keeps (withholdAll withhold fs s) t g c

/-- The parts of `fs` make the difference together, and no single one of them does. -/
def DifferenceOnlyTogether (P : Process S A) (withhold : F → S → S) (fs : List F) (s : S)
    (a : A) (g : F) (c : C) : Prop :=
  K.MakesDifferenceTogether P withhold fs s a g c ∧
    ∀ f, f ∈ fs → ¬ K.MakesDifference P withhold f s a g c

variable {K}

/-- One part is the one-element set of parts. -/
theorem makesDifference_iff_together {P : Process S A} {withhold : F → S → S} {f : F} {s : S}
    {a : A} {g : F} {c : C} :
    K.MakesDifference P withhold f s a g c ↔ K.MakesDifferenceTogether P withhold [f] s a g c :=
  Iff.rfl

/-- Where the dependence holds and is met at `r`, every step from `r` by `a` keeps it
exactly when no step from `r` by `a` breaks it. -/
theorem keeps_iff_not_breaks {P : Process S A} {r : S} {a : A} {g : F} {c : C}
    (depends : K.requires r g c) (met : K.need r g c ≤ K.level r c) :
    (∀ t, P.step r a t → K.Keeps r t g c) ↔ ¬ K.BreaksBy P r a g c :=
  ⟨fun keeps ⟨t, step, breaks⟩ => keeps_not_breaks (keeps t step) breaks,
   fun unbroken t step => match Nat.lt_or_ge (K.level t c) (K.need r g c) with
    | .inl fell => absurd ⟨t, step, depends, met, fell⟩ unbroken
    | .inr held => ⟨met, held⟩⟩

/-- The but-for test, for every process, without determinacy: where the step breaks the
dependence, the move can be taken with `f`'s part withheld, and the dependence holds and is
met there, `f`'s part makes the difference exactly when the same move no longer breaks
it. -/
theorem makesDifference_iff {P : Process S A} {withhold : F → S → S} {f : F} {s : S} {a : A}
    {g : F} {c : C} (breaks : K.BreaksBy P s a g c)
    (available : ∃ t, P.step (withhold f s) a t) (depends : K.requires (withhold f s) g c)
    (met : K.need (withhold f s) g c ≤ K.level (withhold f s) c) :
    K.MakesDifference P withhold f s a g c ↔ ¬ K.BreaksBy P (withhold f s) a g c :=
  ⟨fun made => (keeps_iff_not_breaks depends met).mp made.2.2,
   fun unbroken => ⟨breaks, available, (keeps_iff_not_breaks depends met).mpr unbroken⟩⟩

/-- When the move determines the step, from a configuration where the dependence holds and
is met it breaks the dependence exactly when the level it reaches is below the need. -/
theorem breaksBy_iff_level {P : Process S A} (determined : Determined P) {r t₀ : S} {a : A}
    {g : F} {c : C} (step : P.step r a t₀) (depends : K.requires r g c)
    (met : K.need r g c ≤ K.level r c) :
    K.BreaksBy P r a g c ↔ K.level t₀ c < K.need r g c :=
  ⟨fun ⟨_, step', _, _, fell⟩ => determined _ _ _ _ step' step ▸ fell,
   fun fell => ⟨t₀, step, depends, met, fell⟩⟩

/-- Wherever the parts of `fs` withheld together keep the dependence and, with any single
one of them withheld, the same move still breaks it, the parts make the difference only
together. This holds in every process. -/
theorem DifferenceOnlyTogether.of_breaks {P : Process S A} {withhold : F → S → S}
    {fs : List F} {s : S} {a : A} {g : F} {c : C}
    (together : K.MakesDifferenceTogether P withhold fs s a g c)
    (each : ∀ f, f ∈ fs → K.BreaksBy P (withhold f s) a g c) :
    K.DifferenceOnlyTogether P withhold fs s a g c :=
  ⟨together, fun f member ⟨_, _, keeps⟩ =>
    match each f member with
    | ⟨t, step, breaks⟩ => keeps_not_breaks (keeps t step) breaks⟩

/-- When the loss is overdetermined, every set of parts whose withholding keeps the
dependence makes the difference only together. -/
theorem Overdetermined.only_together {P : Process S A} {withhold : F → S → S} {fs : List F}
    {s : S} {a : A} {g : F} {c : C} (over : K.Overdetermined P withhold s a g c)
    (together : K.MakesDifferenceTogether P withhold fs s a g c) :
    K.DifferenceOnlyTogether P withhold fs s a g c :=
  .of_breaks together fun f _ => over.2 f

/-- The law of joint difference-making: where the move determines the step and, with any
single member withheld, can be taken and leaves the dependence holding and met, the parts
of `fs` make the difference only together exactly when withholding all of them keeps the
dependence and withholding any one of them leaves the same move breaking it. -/
theorem differenceOnlyTogether_iff {P : Process S A} (determined : Determined P)
    {withhold : F → S → S} {fs : List F} {s : S} {a : A} {g : F} {c : C}
    (available : ∀ f, f ∈ fs → ∃ t, P.step (withhold f s) a t)
    (depends : ∀ f, f ∈ fs → K.requires (withhold f s) g c)
    (met : ∀ f, f ∈ fs → K.need (withhold f s) g c ≤ K.level (withhold f s) c) :
    K.DifferenceOnlyTogether P withhold fs s a g c ↔
      K.MakesDifferenceTogether P withhold fs s a g c ∧
        ∀ f, f ∈ fs → K.BreaksBy P (withhold f s) a g c :=
  ⟨fun ⟨together, noMember⟩ => ⟨together, fun f member =>
     match available f member with
     | ⟨_, step⟩ =>
       match determined_dichotomy determined together.1 step (depends f member) (met f member) with
       | .inl made => absurd made (noMember f member)
       | .inr breaks => breaks⟩,
   fun ⟨together, each⟩ => .of_breaks together each⟩

/-- A difference made only together needs at least two parts: withholding nothing keeps
nothing that the step breaks, and one part alone is that part's own test. -/
theorem DifferenceOnlyTogether.two_le_length {P : Process S A} {withhold : F → S → S} :
    ∀ {fs : List F} {s : S} {a : A} {g : F} {c : C},
      K.DifferenceOnlyTogether P withhold fs s a g c → 2 ≤ fs.length
  | [], _, _, _, _, ⟨⟨⟨t, step, breaks⟩, _, keeps⟩, _⟩ => absurd breaks (keeps_not_breaks (keeps t step))
  | [f], _, _, _, _, ⟨together, noMember⟩ => absurd together (noMember f (List.Mem.head []))
  | _ :: _ :: _, _, _, _, _, _ => Nat.succ_le_succ (Nat.succ_le_succ (Nat.zero_le _))

end Dependence

/-! ## The move decides -/

namespace Shock

inductive Formation where
  | drawer
  | sustaining

/-- The level of the condition and the amount the drawer takes at this step. -/
structure State where
  level : Nat
  taking : Nat

inductive Move where
  /-- Renew one unit, take the current amount, and set the next amount. -/
  | calm (next : Nat)
  /-- Empty the condition. -/
  | shock

def process : Process State Move :=
  ⟨fun s a t => match a with
    | .calm next => t = ⟨s.level + 1 - s.taking, next⟩
    | .shock => t = ⟨0, s.taking⟩⟩

def withhold (f : Formation) (s : State) : State :=
  match f with
  | .drawer => ⟨s.level, 0⟩
  | .sustaining => s

def dependence : Dependence State Formation Unit where
  level s _ := s.level
  active s f := match f with
    | .drawer => True
    | .sustaining => 1 ≤ s.level
  requires _ f _ := match f with
    | .drawer => False
    | .sustaining => True
  need _ _ _ := 1
  draws s f _ := match f with
    | .drawer => 0 < s.taking
    | .sustaining => False

/-- At level one the drawer takes two. -/
def start : State := ⟨1, 2⟩

theorem determined : Determined process
  | _, .calm _, _, _, step, step' => step.trans step'.symm
  | _, .shock, _, _, step, step' => step.trans step'.symm

/-- From one configuration, the lone drawer's part makes the difference under the calm
move, and under the shock the loss is overdetermined, so no part makes it. -/
theorem move_decides :
    dependence.MakesDifference process withhold .drawer start (.calm 2) .sustaining () ∧
    dependence.Overdetermined process withhold start .shock .sustaining () ∧
    ¬ dependence.MakesDifference process withhold .drawer start .shock .sustaining () :=
  have over : dependence.Overdetermined process withhold start .shock .sustaining () :=
    ⟨⟨⟨0, 2⟩, rfl, trivial, Nat.le_refl 1, Nat.zero_lt_one⟩, fun
      | .drawer => ⟨⟨0, 0⟩, rfl, trivial, Nat.le_refl 1, Nat.zero_lt_one⟩
      | .sustaining => ⟨⟨0, 2⟩, rfl, trivial, Nat.le_refl 1, Nat.zero_lt_one⟩⟩
  ⟨⟨⟨⟨0, 2⟩, rfl, trivial, Nat.le_refl 1, Nat.zero_lt_one⟩, ⟨_, rfl⟩, fun _ step =>
      step ▸ ⟨Nat.le_refl 1, Nat.le_succ 1⟩⟩,
   over, over.no_difference .drawer⟩

end Shock

/-! ## A shock inside the step relation -/

namespace Hidden

open Shock

/-- One move, whose step can renew and take the current amount, or empty the
condition. -/
def process : Process State Unit :=
  ⟨fun s _ t => t = ⟨s.level + 1 - s.taking, s.taking⟩ ∨ t = ⟨0, s.taking⟩⟩

/-- With the shock written into the step relation rather than the move, the move does
not determine the step. The lone drawer's loss is then overdetermined and its part makes
no difference, though from the withheld configuration the calm outcome of the same move
keeps the dependence. -/
theorem shock_in_the_step :
    ¬ Determined process ∧
    dependence.Overdetermined process withhold start () .sustaining () ∧
    ¬ dependence.MakesDifference process withhold .drawer start () .sustaining () ∧
    process.step (withhold .drawer start) () ⟨2, 0⟩ ∧
    dependence.Keeps (withhold .drawer start) ⟨2, 0⟩ .sustaining () :=
  have over : dependence.Overdetermined process withhold start () .sustaining () :=
    ⟨⟨⟨0, 2⟩, .inl rfl, trivial, Nat.le_refl 1, Nat.zero_lt_one⟩, fun
      | .drawer => ⟨⟨0, 0⟩, .inr rfl, trivial, Nat.le_refl 1, Nat.zero_lt_one⟩
      | .sustaining => ⟨⟨0, 2⟩, .inr rfl, trivial, Nat.le_refl 1, Nat.zero_lt_one⟩⟩
  ⟨fun determined => Nat.noConfusion (congrArg State.level
      (determined ⟨1, 0⟩ () ⟨2, 0⟩ ⟨0, 0⟩ (.inl rfl) (.inr rfl))),
   over, over.no_difference .drawer, .inl rfl, ⟨Nat.le_refl 1, Nat.le_succ 1⟩⟩

end Hidden

/-! ## Difference-making belongs to the joint activity -/

namespace Pool

inductive Formation where
  | first
  | second
  | third
  | sustaining

/-- What each drawer takes from the shared condition in one step. -/
structure Draw where
  first : Nat
  second : Nat
  third : Nat

def Draw.total (d : Draw) : Nat :=
  d.first + d.second + d.third

def Draw.part : Draw → Formation → Nat
  | d, .first => d.first
  | d, .second => d.second
  | d, .third => d.third
  | _, .sustaining => 0

def Draw.without : Formation → Draw → Draw
  | .first, d => ⟨0, d.second, d.third⟩
  | .second, d => ⟨d.first, 0, d.third⟩
  | .third, d => ⟨d.first, d.second, 0⟩
  | .sustaining, d => d

/-- The level of the shared condition and the draws being taken from it. -/
structure State where
  level : Nat
  drawing : Draw

/-- The condition is renewed by one unit while the current draws are taken; the action
sets the next draws. -/
def process : Process State Draw :=
  ⟨fun s next t => t = ⟨s.level + 1 - s.drawing.total, next⟩⟩

theorem determined : Determined process :=
  fun _ _ _ _ step step' => step.trans step'.symm

/-- The same configuration with one formation's part withheld. -/
def withhold (f : Formation) (s : State) : State :=
  ⟨s.level, s.drawing.without f⟩

/-- Which formation depends on the condition: the sustaining one, at level one. -/
def Formation.requires : Formation → Prop
  | .first => False
  | .second => False
  | .third => False
  | .sustaining => True

/-- The drawers are active throughout; the sustaining formation while supported. -/
def Formation.active (s : State) : Formation → Prop
  | .first => True
  | .second => True
  | .third => True
  | .sustaining => 1 ≤ s.level

def dependence : Dependence State Formation Unit where
  level s _ := s.level
  active s f := f.active s
  requires _ f _ := f.requires
  need _ _ _ := 1
  draws s f _ := 0 < s.drawing.part f

/-- Two drawers take one unit each. -/
def pair : Draw := ⟨1, 1, 0⟩

/-- Three drawers take one unit each. -/
def all : Draw := ⟨1, 1, 1⟩

/-- The condition starts at level one and is drawn down to zero, where it stays. -/
def steady (d : Draw) : Nat → State
  | 0 => ⟨1, d⟩
  | _ + 1 => ⟨0, d⟩

def pairRun : Run process :=
  ⟨steady pair, fun _ => pair, fun | 0 => rfl | _ + 1 => rfl⟩

def allRun : Run process :=
  ⟨steady all, fun _ => all, fun | 0 => rfl | _ + 1 => rfl⟩

/-- From level one, draws that take everything the step leaves break the dependence,
whatever the next draws. -/
theorem breaks_from_one (d next : Draw) (exhausts : 1 + 1 - d.total = 0) :
    dependence.BreaksBy process ⟨1, d⟩ next .sustaining () :=
  ⟨⟨0, next⟩, (congrArg (State.mk · next) exhausts).symm, trivial, Nat.le_refl 1,
    Nat.zero_lt_one⟩

/-- Drawn down to zero and left there, the condition is consumed. -/
theorem steady_consumed (d : Draw) (steps : ∀ n, process.step (steady d n) d (steady d (n + 1))) :
    (dependence.along ⟨steady d, fun _ => d, steps⟩).Consumed () :=
  ⟨.sustaining, 0, trivial, fun | _ + 1, _ => Nat.zero_lt_one⟩

/-- From three drawers taking one unit each, the loss is overdetermined. -/
theorem all_overdetermined :
    dependence.Overdetermined process withhold ⟨1, all⟩ all .sustaining () :=
  ⟨breaks_from_one all _ rfl, fun
    | .first => breaks_from_one _ _ rfl
    | .second => breaks_from_one _ _ rfl
    | .third => breaks_from_one _ _ rfl
    | .sustaining => breaks_from_one _ _ rfl⟩

/-- One process, two configurations at the same level, the first drawer taking the same
amount. With one other drawer the first drawer's part makes the difference to the loss;
with two others the loss is overdetermined and it does not, while withholding two parts
keeps the dependence. Each test takes the run's own move. In both runs the relational
reading counts the first drawer as consuming; in the first it counts the third, which
takes nothing, as not consuming. -/
theorem difference_only_together :
    (pairRun.state 0).level = (allRun.state 0).level ∧
    (pairRun.state 0).drawing.first = (allRun.state 0).drawing.first ∧
    dependence.MakesDifference process withhold .first (pairRun.state 0) (pairRun.act 0)
      .sustaining () ∧
    dependence.Overdetermined process withhold (allRun.state 0) (allRun.act 0) .sustaining () ∧
    ¬ dependence.MakesDifference process withhold .first (allRun.state 0) (allRun.act 0)
      .sustaining () ∧
    (∀ a t, process.step (withhold .second (withhold .first (allRun.state 0))) a t →
      dependence.Keeps (withhold .second (withhold .first (allRun.state 0))) t
        .sustaining ()) ∧
    (dependence.along pairRun).ConsumingIn .first ∧
    ¬ (dependence.along pairRun).ConsumingIn .third ∧
    (dependence.along allRun).ConsumingIn .first := by
  have over : dependence.Overdetermined process withhold (allRun.state 0) (allRun.act 0)
      .sustaining () := all_overdetermined
  refine ⟨rfl, rfl, ⟨breaks_from_one pair _ rfl, ⟨_, rfl⟩, fun _ step => ?_⟩, over,
    over.no_difference .first, fun _ _ step => ?_,
    ⟨0, (), Nat.zero_lt_one, steady_consumed pair pairRun.step⟩,
    fun ⟨t, _, drawn, _⟩ => ?_, ⟨0, (), Nat.zero_lt_one, steady_consumed all allRun.step⟩⟩
  · subst step
    exact ⟨Nat.le_refl 1, Nat.le_refl 1⟩
  · subst step
    exact ⟨Nat.le_refl 1, Nat.le_refl 1⟩
  · match t, drawn with
    | 0, drawn => exact Nat.lt_irrefl 0 drawn
    | _ + 1, drawn => exact Nat.lt_irrefl 0 drawn

/-- The joint law in `Pool`: from three drawers taking one unit each, the first two make
the difference only together. Withholding either one alone the same move still breaks the
dependence, and withholding both keeps it; `Overdetermined.only_together` gives the
rest. -/
theorem first_two_only_together :
    dependence.DifferenceOnlyTogether process withhold [.first, .second] ⟨1, all⟩ all
      .sustaining () :=
  all_overdetermined.only_together
    ⟨breaks_from_one all _ rfl, ⟨_, rfl⟩, fun _ step => by
      subst step
      exact ⟨Nat.le_refl 1, Nat.le_refl 1⟩⟩

/-- The first drawer takes one unit, exactly the renewal; the second takes two. -/
def mixed : Draw := ⟨1, 2, 0⟩

def mixedRun : Run process :=
  ⟨steady mixed, fun _ => mixed, fun | 0 => rfl | _ + 1 => rfl⟩

/-- The stepwise reading does not track difference-making. The second drawer's part
makes the difference and the first's does not, yet the first drawer's event at the
breaking step is undermining: it draws on the condition whose dependence the step
breaks. -/
theorem within_share_undermines :
    dependence.MakesDifference process withhold .second (mixedRun.state 0) (mixedRun.act 0)
      .sustaining () ∧
    ¬ dependence.MakesDifference process withhold .first (mixedRun.state 0) (mixedRun.act 0)
      .sustaining () ∧
    (dependence.along mixedRun).UnderminingAt 0 .first :=
  ⟨⟨breaks_from_one mixed _ rfl, ⟨_, rfl⟩, fun _ step => step ▸ ⟨Nat.le_refl 1, Nat.le_refl 1⟩⟩,
   fun ⟨_, _, keeps⟩ => Nat.not_succ_le_zero 0 (keeps ⟨0, mixed⟩ rfl).2,
   ⟨(), Nat.zero_lt_one, .sustaining, trivial,
     ⟨0, Nat.le_refl 0, fun _ _ _ => trivial, Nat.le_refl 1, Nat.le_refl _⟩, Nat.zero_lt_one⟩⟩

end Pool

/-! ## A move the withheld configuration cannot take -/

namespace Tagged

open Pool

/-- The dynamics of `Pool.process`, but each move names the configuration it is taken
from. -/
def process : Process State State :=
  ⟨fun s a t => a = s ∧ t = ⟨s.level + 1 - s.drawing.total, s.drawing⟩⟩

def start : State := ⟨1, all⟩

/-- The move determines the step, and it breaks the dependence; but no withheld
configuration can take it. Without the clause that the move can be taken, every drawer's
part would make the difference vacuously; with it, none does, and the loss is not
overdetermined either. Under `Pool.process`, from the same configuration, it is. -/
theorem move_unavailable :
    Determined process ∧ dependence.BreaksBy process start start .sustaining () ∧
    (∀ f t, f ≠ .sustaining → ¬ process.step (withhold f start) start t) ∧
    (∀ f, ¬ dependence.MakesDifference process withhold f start start .sustaining ()) ∧
    ¬ dependence.Overdetermined process withhold start start .sustaining () ∧
    dependence.Overdetermined Pool.process withhold start all .sustaining () :=
  have unavailable : ∀ f t, f ≠ .sustaining → ¬ process.step (withhold f start) start t
    | .first, _, _, ⟨same, _⟩ => Nat.noConfusion (congrArg (fun s => s.drawing.first) same)
    | .second, _, _, ⟨same, _⟩ => Nat.noConfusion (congrArg (fun s => s.drawing.second) same)
    | .third, _, _, ⟨same, _⟩ => Nat.noConfusion (congrArg (fun s => s.drawing.third) same)
    | .sustaining, _, other, _ => other rfl
  ⟨fun _ _ _ _ ⟨_, step⟩ ⟨_, step'⟩ => step.trans step'.symm,
   ⟨⟨0, all⟩, ⟨rfl, rfl⟩, trivial, Nat.le_refl 1, Nat.zero_lt_one⟩,
   unavailable,
   fun f ⟨_, ⟨t, step⟩, keeps⟩ => match f, step, keeps with
    | .first, step, _ => unavailable .first t Formation.noConfusion step
    | .second, step, _ => unavailable .second t Formation.noConfusion step
    | .third, step, _ => unavailable .third t Formation.noConfusion step
    | .sustaining, ⟨_, same⟩, keeps => Nat.not_succ_le_zero 0
      (Nat.le_trans (keeps _ ⟨rfl, same⟩).2 (Nat.le_of_eq (congrArg State.level same))),
   fun ⟨_, all⟩ => match all .first with
    | ⟨t, step, _⟩ => unavailable .first t Formation.noConfusion step,
   ⟨breaks_from_one all _ rfl, fun
     | .first => breaks_from_one _ _ rfl
     | .second => breaks_from_one _ _ rfl
     | .third => breaks_from_one _ _ rfl
     | .sustaining => breaks_from_one _ _ rfl⟩⟩

end Tagged

/-! ## Where the single tests are silent

The law of joint difference-making needs, for each member, the move to be available from
the configuration with that member withheld and the dependence to be met there. Without
either, the parts can make the difference only together while no member's withheld
configuration breaks the dependence. -/

namespace Blocked

open Pool

/-- `Pool`'s dynamics, except that no move can be taken while exactly two units are being
drawn. -/
def process : Process State Draw :=
  ⟨fun s next t => s.drawing.total ≠ 2 ∧ t = ⟨s.level + 1 - s.drawing.total, next⟩⟩

theorem determined : Determined process :=
  fun _ _ _ _ step step' => step.2.trans step'.2.symm

/-- The move determines the step. From three drawers taking one unit each, the first two
make the difference only together, yet with either withheld alone the move cannot be
taken, so the same move does not break the dependence there. -/
theorem only_together_unbroken :
    Determined process ∧
    dependence.DifferenceOnlyTogether process withhold [.first, .second] ⟨1, all⟩ all
      .sustaining () ∧
    ¬ dependence.BreaksBy process (withhold .first ⟨1, all⟩) all .sustaining () ∧
    ¬ dependence.BreaksBy process (withhold .second ⟨1, all⟩) all .sustaining () :=
  have none_alone : ∀ f, ¬ dependence.MakesDifference process withhold f ⟨1, all⟩ all
      .sustaining ()
    | .first, ⟨_, ⟨_, unblocked, _⟩, _⟩ => unblocked rfl
    | .second, ⟨_, ⟨_, unblocked, _⟩, _⟩ => unblocked rfl
    | .third, ⟨_, ⟨_, unblocked, _⟩, _⟩ => unblocked rfl
    | .sustaining, ⟨_, _, keeps⟩ =>
      Nat.not_succ_le_zero 0 (keeps ⟨0, all⟩ ⟨by decide, rfl⟩).2
  ⟨determined,
   ⟨⟨⟨⟨0, all⟩, ⟨by decide, rfl⟩, trivial, Nat.le_refl 1, Nat.zero_lt_one⟩,
     ⟨_, ⟨by decide, rfl⟩⟩, fun _ ⟨_, step⟩ => by
       subst step
       exact ⟨Nat.le_refl 1, Nat.le_refl 1⟩⟩,
    fun f _ => none_alone f⟩,
   fun ⟨_, ⟨unblocked, _⟩, _⟩ => unblocked rfl,
   fun ⟨_, ⟨unblocked, _⟩, _⟩ => unblocked rfl⟩

end Blocked

namespace NeedRises

open Pool

/-- `Pool`'s dependence, except that the sustaining formation needs five units while
exactly two are being drawn. -/
def dependence : Dependence State Formation Unit where
  level s _ := s.level
  active s f := f.active s
  requires _ f _ := f.requires
  need s _ _ := if s.drawing.total = 2 then 5 else 1
  draws s f _ := 0 < s.drawing.part f

/-- Under `Pool.process`, whose moves determine the step and can always be taken, the
first two drawers make the difference only together, yet with either withheld alone the
dependence is not met, so the same move does not break it there. -/
theorem only_together_unmet :
    Determined process ∧ (∀ f, ∃ t, process.step (withhold f ⟨1, all⟩) all t) ∧
    dependence.DifferenceOnlyTogether process withhold [.first, .second] ⟨1, all⟩ all
      .sustaining () ∧
    ¬ dependence.BreaksBy process (withhold .first ⟨1, all⟩) all .sustaining () ∧
    ¬ dependence.BreaksBy process (withhold .second ⟨1, all⟩) all .sustaining () :=
  have none_alone : ∀ f, ¬ dependence.MakesDifference process withhold f ⟨1, all⟩ all
      .sustaining ()
    | .first, ⟨_, _, keeps⟩ => absurd (keeps _ rfl).1 (by decide)
    | .second, ⟨_, _, keeps⟩ => absurd (keeps _ rfl).1 (by decide)
    | .third, ⟨_, _, keeps⟩ => absurd (keeps _ rfl).1 (by decide)
    | .sustaining, ⟨_, _, keeps⟩ => absurd (keeps _ rfl).2 (by decide)
  ⟨Pool.determined, fun _ => ⟨_, rfl⟩,
   ⟨⟨⟨⟨0, all⟩, rfl, trivial, Nat.le_refl 1, Nat.zero_lt_one⟩, ⟨_, rfl⟩, fun _ step => by
       subst step
       exact ⟨Nat.le_refl 1, Nat.le_refl 1⟩⟩,
    fun f _ => none_alone f⟩,
   fun ⟨_, _, _, met, _⟩ => absurd met (by decide),
   fun ⟨_, _, _, met, _⟩ => absurd met (by decide)⟩

end NeedRises

/-! ## A formation's events over time are a joint activity -/

/-- As `Nat.sub_self_add`, with an empty axiom report. -/
theorem sub_self_add (n : Nat) : ∀ m, n - (n + m) = 0
  | 0 => Nat.sub_self n
  | m + 1 => congrArg Nat.pred (sub_self_add n m)

namespace Renewable

/-- The levels of the shared condition from `start` under the draws `draw`. -/
def levels (start : Nat) (draw : Nat → Nat) : Nat → Nat
  | 0 => start
  | t + 1 => levels start draw t + 1 - draw t

/-- The run of `Renewable` from `start` under the draws `draw`. -/
def drawing (start : Nat) (draw : Nat → Nat) : Run process :=
  ⟨levels start draw, draw, fun _ => rfl⟩

/-- A step drawing at least two units, where one is renewed, lowers the level. -/
theorem overdraw_lowers (s : Nat) : ∀ a, 2 ≤ a → s + 1 - a ≤ s.pred
  | 0, over => absurd over (Nat.not_succ_le_zero 1)
  | 1, over => absurd over (Nat.not_succ_le_self 1)
  | 2, _ => Nat.le_refl _
  | a + 3, _ => Nat.le_trans (Nat.pred_le _) (overdraw_lowers s (a + 2) (Nat.le_add_left 2 a))

/-- Drawing at least two units at every step from `N` drains the condition step by step. -/
theorem drains {start : Nat} {draw : Nat → Nat} {N : Nat} (over : ∀ t, N ≤ t → 2 ≤ draw t) :
    ∀ k, levels start draw (N + k) ≤ levels start draw N - k
  | 0 => Nat.le_refl _
  | k + 1 => Nat.le_trans (overdraw_lowers _ _ (over (N + k) (Nat.le_add_right N k)))
      (Nat.pred_le_pred (drains over k))

/-- Drawing at least two units at every step from some step on consumes the condition. -/
theorem overdraw_consumes {start : Nat} {draw : Nat → Nat} {N : Nat}
    (over : ∀ t, N ≤ t → 2 ≤ draw t) :
    (conditions.dependence.along (drawing start draw)).Consumed () :=
  ⟨.sustaining, N + levels start draw N, trivial, fun t later =>
    match Nat.le.dest later with
    | ⟨m, sum⟩ =>
      have reached : N + (levels start draw N + (m + 1)) = t :=
        (Nat.add_assoc _ _ _).symm.trans ((Nat.succ_add _ m).symm.trans sum)
      Nat.lt_succ_of_le
        (Nat.le_trans (Nat.le_of_eq (congrArg (levels start draw) reached.symm))
          (Nat.le_trans (drains over _) (Nat.le_of_eq (sub_self_add _ _))))⟩

/-- Two units drawn at every step, from level two. -/
def depleting : Run process := drawing 2 fun _ => 2

/-- The same draws with the one at step `n` withheld. -/
def withheld (n : Nat) : Run process := drawing 2 fun t => if t = n then 0 else 2

/-- Over a formation's events, no single event makes the run-level difference. The run
consumes the condition. The first event's step keeps the dependence, so it does not
undermine for any positive cycle. With any single event's draw withheld the condition is
still consumed. -/
theorem depletion_is_joint :
    (conditions.dependence.along depleting).ConsumingIn .focal ∧
    (∀ p, 0 < p → ¬ (conditions.dependence.along depleting).UnderminingFor p 0 .focal) ∧
    ∀ n, (conditions.dependence.along (withheld n)).Consumed () :=
  ⟨⟨0, (), trivial, overdraw_consumes (N := 0) fun _ _ => Nat.le_refl 2⟩,
   fun _ positive ⟨_, _, g, depends, unmet⟩ =>
     match g, depends with
     | .sustaining, _ => Nat.lt_irrefl 1 (unmet 1 Nat.zero_lt_one positive).2,
   fun n => overdraw_consumes (N := n + 1) fun _ later =>
     Nat.le_of_eq (if_neg (Nat.ne_of_gt later)).symm⟩

/-- The run-level outcome is fixed by the tail: with every draw before any step `N`
withheld, the condition is still consumed. -/
theorem no_finite_segment_makes_difference (N : Nat) :
    (conditions.dependence.along (drawing 2 fun t => if t < N then 0 else 2)).Consumed () :=
  overdraw_consumes fun _ later => Nat.le_of_eq (if_neg (Nat.not_lt_of_le later)).symm

/-- The step-level test singles out the breaking event: from level one, drawing two
breaks the dependence, and from the same configuration drawing nothing keeps it. -/
theorem breaking_event_makes_step_difference :
    depleting.state 1 = 1 ∧ depleting.act 1 = 2 ∧
    conditions.dependence.Breaks (depleting.state 1) (depleting.state 2) .sustaining () ∧
    process.step 1 0 2 ∧ conditions.dependence.Keeps 1 2 .sustaining () :=
  ⟨rfl, rfl, ⟨trivial, Nat.le_refl 1, Nat.zero_lt_one⟩, rfl, ⟨Nat.le_refl 1, Nat.le_succ 1⟩⟩

end Renewable

end Becoming
