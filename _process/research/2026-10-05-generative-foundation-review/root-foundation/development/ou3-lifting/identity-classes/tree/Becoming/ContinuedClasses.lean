import Becoming.Persistence
import Becoming.Admission
import Becoming.Grammar

/-!
# Classes along a continuation: splits and merges

`Becoming.Identity` reads a formation's whole-run class by its name: `RenewingIn f` asks every
relation `f` takes part in, at every step, to be renewed, and `ConsumingIn f` asks it to draw on a
consumed condition at some step. A continuation (`Web.Continues`) says instead which formation
after a step continues which before it, and may split one into several or merge several into one;
re-identification changes the name classes (`Turnover`) while keeping the step's relations. This
module reads the classes along a continuation, so that what continues what, not the names, fixes
them.

* **What continues an event.** `Continuing W R t g u f`: `f` at `u` continues `g` at `t` through
  `R`, each step from a formation active before it to one active after it that `R` reads as its
  continuation. `RenewingAlong R t g` asks every relation taken part in along it to be renewed;
  `ConsumingAlong R t g` asks some formation along it to draw on a consumed condition. They exclude
  each other (`renewingAlong_not_consumingAlong`).
* **The split law.** Renewing along an event holds exactly where the event's own relations are
  renewed and renewing holds along every formation continuing it across the next step
  (`renewingAlong_iff`): renewing passes forward into every branch of a split
  (`RenewingAlong.branch`).
* **The merge law.** Consuming along an event holds exactly where it draws on a consumed condition
  or consuming holds along some formation continuing it (`consumingAlong_iff`): consuming along a
  merged formation is consuming along every formation merged into it (`ConsumingAlong.merged`).
* **Classes are the continuation's.** Carrying a continuation through a re-identification
  (`Reidentify.carry`), what continues what is unchanged (`continuing_reidentify`), and so are both
  classes (`renewingAlong_reidentify`, `consumingAlong_reidentify`): no renaming changes a class
  read along a continuation.
* **The name classes as one continuation.** Where each formation continues only itself
  (`Web.itself`) and `f` is active at every step, the classes along it from step `0` are the name
  classes (`renewingAlong_itself_iff`, `consumingAlong_itself_iff`).
* **Tenure and undermining along a continuation.** A dependence's tenure is read along links
  across which it holds (`Web.Linked`, `Web.holdingOn`), with nothing asked of activity:
  `MetAboveAlong` and `UnderminingAlong`. Along each formation continuing itself they are tenure and
  undermining as named (`metAboveAlong_itself_iff`, `underminingAlong_itself_iff`); both are
  unchanged by every re-identification carrying the continuation (`metAboveAlong_reidentify`,
  `underminingAlong_reidentify`); and more links never remove undermining or consuming, nor fewer
  renewing (`underminingAlong_mono`, `consumingAlong_mono`, `renewingAlong_mono`).
* **Identity where standings coincide.** In a balanced world, where `d` stands after a step as `c`
  does, a balanced naming continues `c` as `d` (`World.continues_as_alike`); every record at each
  step is kept by any re-identification, so no record of the world decides between the two, and
  with `World.fixed_iff` identity is fixed exactly where no other relatum stands alike.
* **Widening across a stretch along a continuation.** From step `T` to step `U` a level path
  includes along a continuation where every formation it admits at `T` is linked to one it admits at
  `U`, and exceeds where at `U` it admits a formation linked to none it admits at `T`
  (`Web.IncludesAcross`, `Web.ExceedsAcross`, `Web.WidensAcross`): the reading of the earlier
  formations in the later ones is the continuation, not a supplied map. Along each formation
  continuing itself these are inclusion and exceeding as named (`includesAcross_itself_iff`,
  `exceedsAcross_itself_iff`); they are unchanged by every re-identification carrying the
  continuation (`widensAcross_reidentify`); more links make inclusion easier and exceeding harder
  (`IncludesAcross.mono`, `ExceedsAcross.anti`). In `Bud` a stretch widens by name and adds nothing
  along a continuation in which the old formation buds the new (`Bud.readings`).
* **A merge decides a class.** In `MergeClass` a renewer and a consumer merge into one formation:
  as named, the first renews (`MergeClass.first_renews`); along the merge it consumes, being merged
  into a formation that does (`MergeClass.first_consumes_along`).

Every declaration has an empty axiom report. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {F F' C : Type}

namespace Web

/-- `f` at `u` continues `g` at `t` through the continuation `R`: each step goes from a formation
active before it to one active after it that `R` reads as its continuation. -/
inductive Continuing (W : Web F C) (R : Nat → F → F → Prop) : Nat → F → Nat → F → Prop
  | here (t : Nat) (g : F) : Continuing W R t g t g
  | next {t : Nat} {g f : F} {u : Nat} {h : F} : W.active t g → R t g f → W.active (t + 1) f →
      Continuing W R (t + 1) f u h → Continuing W R t g u h

variable (W : Web F C) (R : Nat → F → F → Prop)

/-- Renewing along a continuation from `g` at `t`: every relation taken part in by a formation
continuing it is renewed. -/
def RenewingAlong (t : Nat) (g : F) : Prop :=
  ∀ u f, W.Continuing R t g u f → ∀ c, W.Participates u f c → W.Renewed c

/-- Consuming along a continuation from `g` at `t`: a formation continuing it draws on a consumed
condition. -/
def ConsumingAlong (t : Nat) (g : F) : Prop :=
  ∃ u f c, W.Continuing R t g u f ∧ W.draws u f c ∧ W.Consumed c

variable {W R}

/-- Renewing and consuming along a continuation exclude each other. -/
theorem renewingAlong_not_consumingAlong {t : Nat} {g : F} (renewing : W.RenewingAlong R t g) :
    ¬ W.ConsumingAlong R t g
  | ⟨u, f, c, continuing, drawn, consumed⟩ =>
    Web.renewed_not_consumed (renewing u f continuing c (.inr drawn)) consumed

/-- **The split law.** Renewing along an event holds exactly where its own relations are renewed
and renewing holds along every formation continuing it across the next step. -/
theorem renewingAlong_iff {t : Nat} {g : F} :
    W.RenewingAlong R t g ↔ (∀ c, W.Participates t g c → W.Renewed c) ∧
      ∀ f, W.active t g → R t g f → W.active (t + 1) f → W.RenewingAlong R (t + 1) f :=
  ⟨fun renewing => ⟨renewing t g (.here t g),
     fun _ before continues after u h continuing =>
       renewing u h (.next before continues after continuing)⟩,
   fun ⟨now, later⟩ u h continuing => match continuing with
     | .here _ _ => now
     | .next before continues after rest => later _ before continues after u h rest⟩

/-- Renewing passes forward into every branch of a split. -/
theorem RenewingAlong.branch {t : Nat} {g f : F} (renewing : W.RenewingAlong R t g)
    (before : W.active t g) (continues : R t g f) (after : W.active (t + 1) f) :
    W.RenewingAlong R (t + 1) f :=
  (renewingAlong_iff.mp renewing).2 f before continues after

/-- **The merge law.** Consuming along an event holds exactly where it draws on a consumed
condition or consuming holds along some formation continuing it across the next step. -/
theorem consumingAlong_iff {t : Nat} {g : F} :
    W.ConsumingAlong R t g ↔ (∃ c, W.draws t g c ∧ W.Consumed c) ∨
      ∃ f, W.active t g ∧ R t g f ∧ W.active (t + 1) f ∧ W.ConsumingAlong R (t + 1) f :=
  ⟨fun ⟨u, h, c, continuing, drawn, consumed⟩ => match continuing with
     | .here _ _ => .inl ⟨c, drawn, consumed⟩
     | .next before continues after rest =>
       .inr ⟨_, before, continues, after, u, h, c, rest, drawn, consumed⟩,
   fun consuming => match consuming with
     | .inl ⟨c, drawn, consumed⟩ => ⟨t, g, c, .here t g, drawn, consumed⟩
     | .inr ⟨_, before, continues, after, u, h, c, rest, drawn, consumed⟩ =>
       ⟨u, h, c, .next before continues after rest, drawn, consumed⟩⟩

/-- Consuming along a merged formation is consuming along every formation merged into it. -/
theorem ConsumingAlong.merged {t : Nat} {g f : F} (consuming : W.ConsumingAlong R (t + 1) f)
    (before : W.active t g) (continues : R t g f) (after : W.active (t + 1) f) :
    W.ConsumingAlong R t g :=
  consumingAlong_iff.mpr (.inr ⟨f, before, continues, after, consuming⟩)

end Web

/-! ## Classes are the continuation's -/

/-- A continuation read through a re-identification: `y` after the step continues `x` before it
exactly where the formations they name do. -/
def Reidentify.carry (σ : Reidentify F F') (R : Nat → F → F → Prop) : Nat → F' → F' → Prop :=
  fun t x y => R t (σ.old t x) (σ.old (t + 1) y)

namespace Web

variable {W : Web F C} {R : Nat → F → F → Prop}

theorem Continuing.of_reidentify {σ : Reidentify F F'} :
    ∀ {t : Nat} {x : F'} {u : Nat} {y : F'},
      (W.reidentify σ).Continuing (σ.carry R) t x u y → W.Continuing R t (σ.old t x) u (σ.old u y)
  | _, _, _, _, .here t x => .here t (σ.old t x)
  | _, _, _, _, .next before continues after rest =>
    .next before continues after (Continuing.of_reidentify rest)

theorem Continuing.to_reidentify {σ : Reidentify F F'} :
    ∀ {t : Nat} {g : F} {u : Nat} {h : F},
      W.Continuing R t g u h → (W.reidentify σ).Continuing (σ.carry R) t (σ.new t g) u (σ.new u h)
  | _, _, _, _, .here t g => .here t (σ.new t g)
  | t, g, _, _, .next (f := f) before continues after rest =>
    .next (f := σ.new (t + 1) f)
      ((σ.old_new t g).symm ▸ before : W.active t (σ.old t (σ.new t g)))
      ((σ.old_new t g).symm ▸ (σ.old_new (t + 1) f).symm ▸ continues :
        R t (σ.old t (σ.new t g)) (σ.old (t + 1) (σ.new (t + 1) f)))
      ((σ.old_new (t + 1) f).symm ▸ after : W.active (t + 1) (σ.old (t + 1) (σ.new (t + 1) f)))
      (Continuing.to_reidentify rest)

/-- **What continues what is unchanged by a re-identification** carrying the continuation. -/
theorem continuing_reidentify (σ : Reidentify F F') {t : Nat} {x : F'} {u : Nat} {y : F'} :
    (W.reidentify σ).Continuing (σ.carry R) t x u y ↔ W.Continuing R t (σ.old t x) u (σ.old u y) :=
  ⟨Continuing.of_reidentify,
   fun continuing => σ.new_old t x ▸ σ.new_old u y ▸ Continuing.to_reidentify continuing⟩

/-- **Renewing along a continuation is unchanged by a re-identification** carrying it. -/
theorem renewingAlong_reidentify (σ : Reidentify F F') {t : Nat} {x : F'} :
    (W.reidentify σ).RenewingAlong (σ.carry R) t x ↔ W.RenewingAlong R t (σ.old t x) :=
  ⟨fun renewing u h continuing c joins =>
     (W.reidentify_renewed σ c).mp (renewing u (σ.new u h)
       (σ.new_old t x ▸ Continuing.to_reidentify continuing) c
       ((σ.old_new u h).symm ▸ joins : W.Participates u (σ.old u (σ.new u h)) c)),
   fun renewing u y continuing c joins =>
     (W.reidentify_renewed σ c).mpr
       (renewing u (σ.old u y) (Continuing.of_reidentify continuing) c joins)⟩

/-- **Consuming along a continuation is unchanged by a re-identification** carrying it. -/
theorem consumingAlong_reidentify (σ : Reidentify F F') {t : Nat} {x : F'} :
    (W.reidentify σ).ConsumingAlong (σ.carry R) t x ↔ W.ConsumingAlong R t (σ.old t x) :=
  ⟨fun ⟨u, y, c, continuing, drawn, consumed⟩ =>
     ⟨u, σ.old u y, c, Continuing.of_reidentify continuing, drawn,
      (W.reidentify_consumed σ c).mp consumed⟩,
   fun ⟨u, h, c, continuing, drawn, consumed⟩ =>
     ⟨u, σ.new u h, c, σ.new_old t x ▸ Continuing.to_reidentify continuing,
      ((σ.old_new u h).symm ▸ drawn : W.draws u (σ.old u (σ.new u h)) c),
      (W.reidentify_consumed σ c).mpr consumed⟩⟩

/-! ## The name classes as one continuation -/

/-- Each formation continues only itself. -/
def itself : Nat → F → F → Prop := fun _ g f => g = f

theorem Continuing.itself_same : ∀ {t : Nat} {g : F} {u : Nat} {h : F},
    W.Continuing itself t g u h → h = g
  | _, _, _, _, .here _ _ => rfl
  | _, _, _, _, .next _ same _ rest => (Continuing.itself_same rest).trans same.symm

/-- A formation active at every step from `s` continues itself to every later step. -/
theorem Continuing.itself_onward {f : F} (always : ∀ t, W.active t f) :
    ∀ (k s : Nat), W.Continuing itself s f (s + k) f
  | 0, s => .here s f
  | k + 1, s => .next (always s) rfl (always (s + 1))
      ((Nat.succ_add s k ▸ Continuing.itself_onward always k (s + 1) :
        W.Continuing itself (s + 1) f (Nat.succ (s + k)) f))

theorem Continuing.itself_from_zero {f : F} (always : ∀ t, W.active t f) (u : Nat) :
    W.Continuing itself 0 f u f :=
  (Nat.zero_add u ▸ Continuing.itself_onward always u 0 : W.Continuing itself 0 f u f)

/-- **The name classes are the classes along each formation continuing itself:** renewing. -/
theorem renewingAlong_itself_iff {f : F} (always : ∀ t, W.active t f) :
    W.RenewingAlong itself 0 f ↔ W.RenewingIn f :=
  ⟨fun renewing u c joins => renewing u f (Continuing.itself_from_zero always u) c joins,
   fun renewing u _ continuing c joins =>
     renewing u c (Continuing.itself_same continuing ▸ joins)⟩

/-- **The name classes are the classes along each formation continuing itself:** consuming. -/
theorem consumingAlong_itself_iff {f : F} (always : ∀ t, W.active t f) :
    W.ConsumingAlong itself 0 f ↔ W.ConsumingIn f :=
  ⟨fun ⟨u, _, c, continuing, drawn, consumed⟩ =>
     ⟨u, c, Continuing.itself_same continuing ▸ drawn, consumed⟩,
   fun ⟨u, c, drawn, consumed⟩ =>
     ⟨u, f, c, Continuing.itself_from_zero always u, drawn, consumed⟩⟩

end Web

/-! ## A merge decides a class -/

namespace MergeClass

/-- Two formations and the one they merge into. -/
inductive Formation | first | second | merged

/-- A condition kept at its need throughout, and one spent after the first step. -/
inductive Place | kept | spent

/-- Before the step the first and the second are active; after it, the merged formation. -/
def active : Nat → Formation → Prop
  | 0, .first => True
  | 0, .second => True
  | 0, .merged => False
  | _ + 1, .first => False
  | _ + 1, .second => False
  | _ + 1, .merged => True

/-- The first requires the kept condition and the second the spent one, at step `0`. -/
def requires : Nat → Formation → Place → Prop
  | 0, .first, .kept => True
  | 0, .first, .spent => False
  | 0, .second, .kept => False
  | 0, .second, .spent => True
  | 0, .merged, _ => False
  | _ + 1, _, _ => False

/-- The first draws on the kept condition and the second on the spent one at step `0`; the
merged formation draws on the spent one at step `1`. -/
def draws : Nat → Formation → Place → Prop
  | 0, .first, .kept => True
  | 0, .first, .spent => False
  | 0, .second, .kept => False
  | 0, .second, .spent => True
  | 0, .merged, _ => False
  | 1, .first, _ => False
  | 1, .second, _ => False
  | 1, .merged, .kept => False
  | 1, .merged, .spent => True
  | _ + 2, _, _ => False

/-- The kept condition stands at `1` throughout; the spent one at `1` before the step, `0` after. -/
def level : Nat → Place → Nat
  | _, .kept => 1
  | 0, .spent => 1
  | _ + 1, .spent => 0

/-- The web: every need is `1`. -/
def web : Web Formation Place := ⟨level, active, requires, fun _ _ _ => 1, draws⟩

/-- Both formations before the step continue as the merged one after it. -/
def merge : Nat → Formation → Formation → Prop := fun _ _ f => f = .merged

theorem kept_renewed : web.Renewed .kept
  | 0, .first, _ => ⟨Nat.le_refl 1, Nat.le_refl 1⟩
  | 0, .second, no => nomatch no
  | 0, .merged, no => nomatch no
  | _ + 1, _, no => nomatch no

theorem spent_consumed : web.Consumed .spent :=
  ⟨.second, 0, trivial, fun
    | 0, no => absurd no (Nat.lt_irrefl 0)
    | _ + 1, _ => Nat.lt_succ_self 0⟩

/-- **As named, the first renews:** every relation it takes part in is on the kept condition. -/
theorem first_renews : web.RenewingIn .first
  | 0, .kept, _ => kept_renewed
  | 0, .spent, joins => joins.elim (fun no => nomatch no) (fun no => nomatch no)
  | 1, .kept, joins => joins.elim (fun no => nomatch no) (fun no => nomatch no)
  | 1, .spent, joins => joins.elim (fun no => nomatch no) (fun no => nomatch no)
  | _ + 2, .kept, joins => joins.elim (fun no => nomatch no) (fun no => nomatch no)
  | _ + 2, .spent, joins => joins.elim (fun no => nomatch no) (fun no => nomatch no)

/-- **Along the merge, the first consumes:** it is merged into a formation drawing on the spent
condition. -/
theorem first_consumes_along : web.ConsumingAlong merge 0 .first :=
  Web.ConsumingAlong.merged (f := Formation.merged)
    ⟨1, Formation.merged, Place.spent, .here 1 Formation.merged, trivial, spent_consumed⟩
    trivial rfl trivial

/-- So the class of the first is read off the merge, not its name: it renews as named and
consumes along the continuation, and the two exclude each other. -/
theorem readings : web.RenewingIn .first ∧ web.ConsumingAlong merge 0 .first ∧
    ¬ web.RenewingAlong merge 0 .first :=
  ⟨first_renews, first_consumes_along,
   fun renewing => Web.renewingAlong_not_consumingAlong renewing first_consumes_along⟩

end MergeClass

/-! ## Tenure and undermining along a continuation -/

namespace Web

/-- `g` at `u` is linked to `h` at `t` through `R`: a chain of steps each of which `R` relates,
with nothing asked of activity. -/
inductive Linked (R : Nat → F → F → Prop) : Nat → F → Nat → F → Prop
  | here (t : Nat) (g : F) : Linked R t g t g
  | next {t : Nat} {g f : F} {u : Nat} {h : F} : R t g f → Linked R (t + 1) f u h → Linked R t g u h

variable (W : Web F C) (R : Nat → F → F → Prop)

/-- The continuation restricted to a dependence on `c` holding across the step. -/
def holdingOn (c : C) : Nat → F → F → Prop :=
  fun t g f => R t g f ∧ W.requires t g c ∧ W.requires (t + 1) f c

/-- `g`'s dependence on `c` at `t` was met above `m` along the continuation: some formation it
continues, through steps across which the dependence holds, met at its step a need above `m`. -/
def MetAboveAlong (t : Nat) (g : F) (c : C) (m : Nat) : Prop :=
  ∃ s h, Linked (W.holdingOn R c) s h t g ∧ W.requires s h c ∧ W.need s h c ≤ W.level s c ∧
    m < W.need s h c

/-- Undermining along a continuation: `f` draws on `c` at a step after which `c` is below a
dependence's present need and below a need met along the continuation while it held. -/
def UnderminingAlong (t : Nat) (f : F) : Prop :=
  ∃ c, W.draws t f c ∧ ∃ g, W.requires t g c ∧ W.MetAboveAlong R t g c (W.level (t + 1) c) ∧
    W.level (t + 1) c < W.need t g c

variable {W R}

theorem Linked.mono {S : Nat → F → F → Prop} (within : ∀ t g f, R t g f → S t g f) :
    ∀ {t : Nat} {g : F} {u : Nat} {h : F}, Linked R t g u h → Linked S t g u h
  | _, _, _, _, .here t g => .here t g
  | _, _, _, _, .next step rest => .next (within _ _ _ step) (Linked.mono within rest)

theorem Continuing.mono {S : Nat → F → F → Prop} (within : ∀ t g f, R t g f → S t g f) :
    ∀ {t : Nat} {g : F} {u : Nat} {h : F}, W.Continuing R t g u h → W.Continuing S t g u h
  | _, _, _, _, .here t g => .here t g
  | _, _, _, _, .next before step after rest =>
    .next before (within _ _ _ step) after (Continuing.mono within rest)

/-- **More links never remove undermining.** Where every step `R` relates `S` relates, what
undermines along `R` undermines along `S`. -/
theorem underminingAlong_mono {S : Nat → F → F → Prop} (within : ∀ t g f, R t g f → S t g f)
    {t : Nat} {f : F} : W.UnderminingAlong R t f → W.UnderminingAlong S t f
  | ⟨c, drawn, g, depends, ⟨s, h, linked, held, met, above⟩, below⟩ =>
    ⟨c, drawn, g, depends,
     ⟨s, h, Linked.mono (fun _ _ _ ⟨step, before, after⟩ => ⟨within _ _ _ step, before, after⟩) linked,
      held, met, above⟩, below⟩

/-- More links never remove consuming. -/
theorem consumingAlong_mono {S : Nat → F → F → Prop} (within : ∀ t g f, R t g f → S t g f)
    {t : Nat} {g : F} : W.ConsumingAlong R t g → W.ConsumingAlong S t g
  | ⟨u, h, c, continuing, drawn, consumed⟩ => ⟨u, h, c, Continuing.mono within continuing, drawn, consumed⟩

/-- Fewer links never remove renewing. -/
theorem renewingAlong_mono {S : Nat → F → F → Prop} (within : ∀ t g f, R t g f → S t g f)
    {t : Nat} {g : F} (renewing : W.RenewingAlong S t g) : W.RenewingAlong R t g :=
  fun u h continuing => renewing u h (Continuing.mono within continuing)

/-! ### The name case -/

theorem Linked.itself_held {c : C} :
    ∀ {s : Nat} {h : F} {t : Nat} {g : F}, Linked (W.holdingOn itself c) s h t g →
      W.requires s h c → h = g ∧ s ≤ t ∧ ∀ u, s ≤ u → u ≤ t → W.requires u g c
  | _, _, _, _, .here s h, held =>
    ⟨rfl, Nat.le_refl s, fun _ after before => Nat.le_antisymm before after ▸ held⟩
  | s, _, _, _, .next ⟨same, held, held'⟩ rest, _ =>
    match Linked.itself_held rest held' with
    | ⟨same', later, holds⟩ =>
      ⟨same.trans same', Nat.le_trans (Nat.le_succ s) later, fun u after before =>
        match Nat.eq_or_lt_of_le after with
        | .inl atStart => Eq.subst (motive := fun x => W.requires x _ c) atStart
            (Eq.subst (motive := fun y => W.requires s y c) (same.trans same') held)
        | .inr beyond => holds u beyond before⟩

theorem Linked.itself_onward {c : C} {g : F} :
    ∀ (k s : Nat), (∀ u, s ≤ u → u ≤ s + k → W.requires u g c) →
      Linked (W.holdingOn itself c) s g (s + k) g
  | 0, s, _ => .here s g
  | k + 1, s, holds =>
    .next ⟨rfl, holds s (Nat.le_refl s) (Nat.le_add_right s (k + 1)),
        holds (s + 1) (Nat.le_succ s) (Nat.succ_le_succ (Nat.le_add_right s k))⟩
      ((Nat.succ_add s k ▸ Linked.itself_onward k (s + 1) fun u after before =>
          holds u (Nat.le_trans (Nat.le_succ s) after)
            (Nat.le_trans before (Nat.le_of_eq (Nat.succ_add s k))) :
        Linked (W.holdingOn itself c) (s + 1) g (Nat.succ (s + k)) g))

/-- A later step is an earlier one with some number of steps added. -/
theorem exists_steps_between : ∀ {s t : Nat}, s ≤ t → ∃ k, t = s + k
  | _, _, .refl => ⟨0, rfl⟩
  | _, _, .step earlier => match exists_steps_between earlier with
    | ⟨k, apart⟩ => ⟨k + 1, congrArg Nat.succ apart⟩

/-- **Tenure along each formation continuing itself is tenure as named.** -/
theorem metAboveAlong_itself_iff {t : Nat} {g : F} {c : C} {m : Nat} :
    W.MetAboveAlong itself t g c m ↔ W.MetAbove t g c m :=
  ⟨fun ⟨s, _, linked, held, met, above⟩ => match Linked.itself_held linked held with
     | ⟨same, earlier, holds⟩ => ⟨s, earlier, holds, same ▸ met, same ▸ above⟩,
   fun ⟨s, earlier, holds, met, above⟩ => match exists_steps_between earlier with
     | ⟨k, apart⟩ =>
       ⟨s, g, apart ▸ Linked.itself_onward k s (apart ▸ holds),
        holds s (Nat.le_refl s) earlier, met, above⟩⟩

/-- **Undermining along each formation continuing itself is undermining as named.** -/
theorem underminingAlong_itself_iff {t : Nat} {f : F} :
    W.UnderminingAlong itself t f ↔ W.UnderminingAt t f :=
  ⟨fun ⟨c, drawn, g, depends, met, below⟩ =>
     ⟨c, drawn, g, depends, metAboveAlong_itself_iff.mp met, below⟩,
   fun ⟨c, drawn, g, depends, met, below⟩ =>
     ⟨c, drawn, g, depends, metAboveAlong_itself_iff.mpr met, below⟩⟩

/-! ### Undermining is the continuation's -/

theorem Linked.of_carry {σ : Reidentify F F'} {S : Nat → F → F → Prop} :
    ∀ {t : Nat} {x : F'} {u : Nat} {y : F'},
      Linked (σ.carry S) t x u y → Linked S t (σ.old t x) u (σ.old u y)
  | _, _, _, _, .here t x => .here t (σ.old t x)
  | _, _, _, _, .next step rest => .next step (Linked.of_carry rest)

theorem Linked.to_carry {σ : Reidentify F F'} {S : Nat → F → F → Prop} :
    ∀ {t : Nat} {g : F} {u : Nat} {h : F},
      Linked S t g u h → Linked (σ.carry S) t (σ.new t g) u (σ.new u h)
  | _, _, _, _, .here t g => .here t (σ.new t g)
  | t, g, _, _, .next (f := f) step rest =>
    .next (f := σ.new (t + 1) f)
      ((σ.old_new t g).symm ▸ (σ.old_new (t + 1) f).symm ▸ step :
        S t (σ.old t (σ.new t g)) (σ.old (t + 1) (σ.new (t + 1) f)))
      (Linked.to_carry rest)

/-- **Tenure along a continuation is unchanged by a re-identification** carrying it. -/
theorem metAboveAlong_reidentify (σ : Reidentify F F') {t : Nat} {x : F'} {c : C} {m : Nat} :
    (W.reidentify σ).MetAboveAlong (σ.carry R) t x c m ↔ W.MetAboveAlong R t (σ.old t x) c m :=
  ⟨fun ⟨s, y, linked, held, met, above⟩ =>
     ⟨s, σ.old s y, Linked.of_carry (S := W.holdingOn R c) linked, held, met, above⟩,
   fun ⟨s, h, linked, held, met, above⟩ =>
     ⟨s, σ.new s h, σ.new_old t x ▸ Linked.to_carry (σ := σ) (S := W.holdingOn R c) linked,
      ((σ.old_new s h).symm ▸ held : W.requires s (σ.old s (σ.new s h)) c),
      ((σ.old_new s h).symm ▸ met : W.need s (σ.old s (σ.new s h)) c ≤ W.level s c),
      ((σ.old_new s h).symm ▸ above : m < W.need s (σ.old s (σ.new s h)) c)⟩⟩

/-- **Undermining along a continuation is unchanged by a re-identification** carrying it. -/
theorem underminingAlong_reidentify (σ : Reidentify F F') {t : Nat} {x : F'} :
    (W.reidentify σ).UnderminingAlong (σ.carry R) t x ↔ W.UnderminingAlong R t (σ.old t x) :=
  ⟨fun ⟨c, drawn, y, depends, met, below⟩ =>
     ⟨c, drawn, σ.old t y, depends, (metAboveAlong_reidentify σ).mp met, below⟩,
   fun ⟨c, drawn, g, depends, met, below⟩ =>
     ⟨c, drawn, σ.new t g, ((σ.old_new t g).symm ▸ depends : W.requires t (σ.old t (σ.new t g)) c),
      (metAboveAlong_reidentify σ).mpr ((σ.old_new t g).symm ▸ met),
      ((σ.old_new t g).symm ▸ below : W.level (t + 1) c < W.need t (σ.old t (σ.new t g)) c)⟩⟩

end Web

/-! ## Identity where standings coincide -/

namespace World

variable {w : World}

/-- **Where two relata stand alike after a step, a balanced naming continues the one as the
other.** In a balanced world with equality of relata decided, if `d` stands after the step from
`t` as `c` does, exchanging them after the step keeps the balance and continues `c` as `d`; every
record at each step is kept by any re-identification, so no record of the world decides between
continuing `c` as `c` and as `d`. With `World.fixed_iff`, identity across a step is fixed exactly
where no other relatum stands alike after it. -/
theorem continues_as_alike [DecidableEq w.Relatum] (balanced : w.Balanced) {t : Nat}
    {c d : w.Relatum} (alike : w.web.level (t + 1) d = w.web.level (t + 1) c) :
    ∃ σ : Reidentify w.Relatum w.Relatum, (w.reidentify σ).Balanced ∧ σ.old (t + 1) (σ.new t c) = d :=
  ⟨Reidentify.exchangeAfter t c d, exchangeAfter_balanced balanced alike,
   (Reidentify.exchangeAfter_across t c d c).trans (transpose_left c d)⟩

end World

/-! ## Widening across a stretch along a continuation -/

namespace Web

variable (W : Web F C) (R : Nat → F → F → Prop) (l : Nat → C → Nat)

/-- From step `T` to step `U`, the levels `l` include along the continuation: every formation
they admit at `T` is linked to one they admit at `U`. -/
def IncludesAcross (T U : Nat) : Prop :=
  ∀ f, W.Admits (l T) T f → ∃ g, Linked R T f U g ∧ W.Admits (l U) U g

/-- From `T` to `U`, the levels exceed along the continuation: at `U` they admit a formation linked
to apart they admit at `T`. -/
def ExceedsAcross (T U : Nat) : Prop :=
  ∃ g, W.Admits (l U) U g ∧ ∀ f, Linked R T f U g → ¬ W.Admits (l T) T f

/-- **Widening across a stretch along a continuation**: inclusion and exceeding from `T` to `U`.
The reading of the formations at `T` in those at `U` is the continuation, not a supplied map. -/
def WidensAcross (T U : Nat) : Prop :=
  W.IncludesAcross R l T U ∧ W.ExceedsAcross R l T U

variable {W R l}

/-- **More links make inclusion easier.** -/
theorem IncludesAcross.mono {S : Nat → F → F → Prop} (within : ∀ t g f, R t g f → S t g f)
    {T U : Nat} (includes : W.IncludesAcross R l T U) : W.IncludesAcross S l T U :=
  fun f admitted => match includes f admitted with
    | ⟨g, linked, admitted'⟩ => ⟨g, Linked.mono within linked, admitted'⟩

/-- **More links make exceeding harder.** What exceeds along more links exceeds along fewer. -/
theorem ExceedsAcross.anti {S : Nat → F → F → Prop} (within : ∀ t g f, R t g f → S t g f)
    {T U : Nat} : W.ExceedsAcross S l T U → W.ExceedsAcross R l T U
  | ⟨g, admitted, apart⟩ => ⟨g, admitted, fun f linked => apart f (Linked.mono within linked)⟩

/-- A formation admitted at `U` that is linked to nothing at `T` exceeds. -/
theorem exceedsAcross_of_unlinked {T U : Nat} {g : F} (admitted : W.Admits (l U) U g)
    (fresh : ∀ f, ¬ Linked R T f U g) : W.ExceedsAcross R l T U :=
  ⟨g, admitted, fun f linked => absurd linked (fresh f)⟩

/-! ### The name case -/

theorem Linked.itself_same : ∀ {s : Nat} {h : F} {t : Nat} {g : F},
    Linked itself s h t g → s ≤ t ∧ h = g
  | _, _, _, _, .here s _ => ⟨Nat.le_refl s, rfl⟩
  | s, _, _, _, .next same rest => match Linked.itself_same rest with
    | ⟨later, same'⟩ => ⟨Nat.le_trans (Nat.le_succ s) later, same.trans same'⟩

theorem Linked.itself_steps {g : F} : ∀ (k s : Nat), Linked (itself (F := F)) s g (s + k) g
  | 0, s => .here s g
  | k + 1, s => .next rfl ((Nat.succ_add s k ▸ Linked.itself_steps k (s + 1) :
      Linked (itself (F := F)) (s + 1) g (Nat.succ (s + k)) g))

theorem Linked.itself_of_le {s t : Nat} {g : F} (later : s ≤ t) : Linked (itself (F := F)) s g t g :=
  match exists_steps_between later with
  | ⟨k, apart⟩ => apart ▸ Linked.itself_steps k s

/-- **Along each formation continuing itself, inclusion across a stretch is inclusion as named.** -/
theorem includesAcross_itself_iff {T U : Nat} (later : T ≤ U) :
    W.IncludesAcross itself l T U ↔ ∀ f, W.Admits (l T) T f → W.Admits (l U) U f :=
  ⟨fun includes f admitted => match includes f admitted with
     | ⟨_, linked, admitted'⟩ => (Linked.itself_same linked).2 ▸ admitted',
   fun includes f admitted => ⟨f, Linked.itself_of_le later, includes f admitted⟩⟩

/-- **Along each formation continuing itself, exceeding across a stretch is exceeding as named.** -/
theorem exceedsAcross_itself_iff {T U : Nat} (later : T ≤ U) :
    W.ExceedsAcross itself l T U ↔ ∃ g, W.Admits (l U) U g ∧ ¬ W.Admits (l T) T g :=
  ⟨fun ⟨g, admitted, apart⟩ => ⟨g, admitted, apart g (Linked.itself_of_le later)⟩,
   fun ⟨g, admitted, before⟩ => ⟨g, admitted, fun _ linked =>
     (Linked.itself_same linked).2.symm ▸ before⟩⟩

/-! ### Widening across a stretch is the continuation's -/

/-- **Inclusion across a stretch is unchanged by a re-identification** carrying the continuation. -/
theorem includesAcross_reidentify (σ : Reidentify F F') {T U : Nat} :
    (W.reidentify σ).IncludesAcross (σ.carry R) l T U ↔ W.IncludesAcross R l T U :=
  ⟨fun includes f admitted =>
     match includes (σ.new T f) ((σ.old_new T f).symm ▸ admitted :
         W.Admits (l T) T (σ.old T (σ.new T f))) with
     | ⟨y, linked, admitted'⟩ =>
       ⟨σ.old U y, σ.old_new T f ▸ Linked.of_carry (S := R) linked, admitted'⟩,
   fun includes x admitted => match includes (σ.old T x) admitted with
     | ⟨g, linked, admitted'⟩ =>
       ⟨σ.new U g, σ.new_old T x ▸ Linked.to_carry (σ := σ) (S := R) linked,
        ((σ.old_new U g).symm ▸ admitted' : W.Admits (l U) U (σ.old U (σ.new U g)))⟩⟩

/-- **Exceeding across a stretch is unchanged by a re-identification** carrying the continuation. -/
theorem exceedsAcross_reidentify (σ : Reidentify F F') {T U : Nat} :
    (W.reidentify σ).ExceedsAcross (σ.carry R) l T U ↔ W.ExceedsAcross R l T U :=
  ⟨fun ⟨y, admitted, apart⟩ => ⟨σ.old U y, admitted, fun f linked before =>
     apart (σ.new T f) (σ.new_old U y ▸ Linked.to_carry (σ := σ) (S := R) linked)
       ((σ.old_new T f).symm ▸ before : W.Admits (l T) T (σ.old T (σ.new T f)))⟩,
   fun ⟨g, admitted, apart⟩ => ⟨σ.new U g,
     ((σ.old_new U g).symm ▸ admitted : W.Admits (l U) U (σ.old U (σ.new U g))),
     fun x linked before => apart (σ.old T x) (σ.old_new U g ▸ Linked.of_carry (S := R) linked)
       before⟩⟩

/-- **Widening across a stretch is unchanged by a re-identification** carrying the continuation. -/
theorem widensAcross_reidentify (σ : Reidentify F F') {T U : Nat} :
    (W.reidentify σ).WidensAcross (σ.carry R) l T U ↔ W.WidensAcross R l T U :=
  ⟨fun ⟨includes, exceeds⟩ => ⟨(includesAcross_reidentify σ).mp includes,
     (exceedsAcross_reidentify σ).mp exceeds⟩,
   fun ⟨includes, exceeds⟩ => ⟨(includesAcross_reidentify σ).mpr includes,
     (exceedsAcross_reidentify σ).mpr exceeds⟩⟩

end Web

/-! ### A bud adds nothing -/

namespace Bud

/-- A formation there from the start, and one its levels admit only after the first step. -/
inductive Formation | old | fresh

/-- The fresh formation requires the one condition at need `1`; the old one requires nothing. -/
def requires : Nat → Formation → Unit → Prop
  | _, .old, _ => False
  | _, .fresh, _ => True

/-- The condition stands at the step's index; both formations are active throughout. -/
def web : Web Formation Unit := ⟨fun t _ => t, fun _ _ => True, requires, fun _ _ _ => 1,
  fun _ _ _ => False⟩

/-- The old formation continues as itself and buds the fresh one. -/
def bud : Nat → Formation → Formation → Prop := fun _ g f => g = f ∨ (g = .old ∧ f = .fresh)

theorem old_admitted (t : Nat) : web.Admits (web.level t) t .old := fun _ no => nomatch no

theorem fresh_later : web.Admits (web.level 1) 1 .fresh := fun _ _ => Nat.le_refl 1

theorem fresh_not_first : ¬ web.Admits (web.level 0) 0 .fresh :=
  fun admitted => Nat.not_succ_le_zero 0 (admitted () trivial)

/-- **Read by name, the stretch widens:** the fresh formation is admitted after the first step and
not before. -/
theorem widens_by_name : web.WidensAcross Web.itself web.level 0 1 :=
  ⟨(Web.includesAcross_itself_iff (Nat.zero_le 1)).mpr fun
     | .old, _ => old_admitted 1
     | .fresh, admitted => absurd admitted fresh_not_first,
   (Web.exceedsAcross_itself_iff (Nat.zero_le 1)).mpr ⟨.fresh, fresh_later, fresh_not_first⟩⟩

/-- **Read along the bud, nothing is added:** every formation admitted after the step continues
the old one, admitted before it. -/
theorem bud_adds_nothing : ¬ web.ExceedsAcross bud web.level 0 1
  | ⟨g, _, apart⟩ => apart .old (.next (f := g) (match g with
      | .old => .inl rfl
      | .fresh => .inr ⟨rfl, rfl⟩) (.here 1 g)) (old_admitted 0)

/-- So whether a stretch widens is read off the continuation: by name it widens, along the bud it
does not. -/
theorem readings : web.WidensAcross Web.itself web.level 0 1 ∧ ¬ web.WidensAcross bud web.level 0 1 :=
  ⟨widens_by_name, fun ⟨_, exceeds⟩ => bud_adds_nothing exceeds⟩

end Bud

/-! ## The grammar's reading of classes along a continuation

With the reading of `Becoming.Identity`'s last section (occurrences `(t, f)`, 缘 one step of a
continuation `R`, `Web.continuationStep R`), the notions of this module are the grammar's.

* **Continuing is a line (相续).** `Continuing W R t g u h` holds exactly where `(t, g)` is
  `(u, h)` or `g` is active at `t` and `(u, h)` lies in a line under activity from `(t, g)`
  (`continuing_iff_line`). So renewing along a continuation is renewing at every occurrence of the
  line, and consuming along it is drawing on a consumed condition at some occurrence of it
  (`renewingAlong_iff_line`, `consumingAlong_iff_line`). That more links make more continuing is
  the monotonicity of reach (`Continuing.mono_by_reach`, from `«及之单调»`).
* **Links are lines under the one.** `Linked R`, with nothing asked of activity, is a line under
  the one class (`«一»`) (`linked_iff_line`), where continuation is 缘 itself (`«一之续»`).
* **Tenure is a line under the dependence's class.** Links across which a dependence on `c` holds,
  from a formation requiring `c`, are lines under the class "requires `c` or not"
  (`Web.dependenceClass`) (`held_iff_line`), so tenure along a continuation is a need met at an
  occurrence of such a line ending at the event (`metAboveAlong_iff_line`).
* **The split and merge laws, from the grammar.** Renewing along an occurrence passes into both
  branches of a split, which form a fission (分叉) (`RenewingAlong.branches`); consuming along a
  merged occurrence is consuming along both occurrences merged into it, from the two candles
  (蜡烛之合) (`ConsumingAlong.merged_candles`). In `MergeClass` the merge is the two candles and
  both merged formations consume along it (`MergeClass.candles`, `MergeClass.both_consume_along`);
  in `Bud` the old formation's bud is a fission (`Bud.fission`).
* **Re-identification.** A step of a continuation carried through a re-identification is a step
  of the original between the formations named (`carry_step_iff`), so lines correspond exactly
  (`line_reidentify`): the classes, read off lines, are the continuation's, not the names'.
-/

namespace Web

variable {W : Web F C} {R : Nat → F → F → Prop}

/-- A line under activity from an active occurrence is a continuing. -/
theorem line_continuing {x y : Nat × F}
    (line : «及» («续» (continuationStep R) W.activityClass) x y) :
    W.active x.1 x.2 → W.Continuing R x.1 x.2 y.1 y.2 := by
  induction line with
  | @one a b k =>
    intro before
    have after : W.active (a.1 + 1) b.2 :=
      Eq.subst (motive := fun s => W.active s b.2) k.1.1 (k.2.mp before)
    exact Eq.subst (motive := fun s => W.Continuing R a.1 a.2 s b.2) k.1.1.symm
      (.next before k.1.2 after (.here (a.1 + 1) b.2))
  | @more a b z k _ ih =>
    intro before
    have after : W.active (a.1 + 1) b.2 :=
      Eq.subst (motive := fun s => W.active s b.2) k.1.1 (k.2.mp before)
    exact .next before k.1.2 after
      (Eq.subst (motive := fun s => W.Continuing R s b.2 z.1 z.2) k.1.1 (ih (k.2.mp before)))

/-- A continuing is the occurrence itself or a line (相续) under activity from it. -/
theorem Continuing.line : ∀ {t : Nat} {g : F} {u : Nat} {h : F}, W.Continuing R t g u h →
    (t, g) = (u, h) ∨ W.active t g ∧ «相续» (continuationStep R) W.activityClass (t, g) (u, h)
  | _, _, _, _, .here _ _ => .inl rfl
  | t, g, _, _, .next (f := f) before continues after rest =>
    have k : «续» (continuationStep R) W.activityClass (t, g) (t + 1, f) :=
      ⟨⟨rfl, continues⟩, ⟨fun _ => after, fun _ => before⟩⟩
    match Continuing.line rest with
    | .inl same => .inr ⟨before, Eq.subst
        (motive := fun y => «相续» (continuationStep R) W.activityClass (t, g) y) same (.one k)⟩
    | .inr ⟨_, line⟩ => .inr ⟨before, .more k line⟩

/-- **Continuing is a line (相续).** `f` at `u` continues `g` at `t` exactly where the two
occurrences are one, or `g` is active at `t` and `(u, f)` lies in a line under activity from
`(t, g)`. -/
theorem continuing_iff_line {t : Nat} {g : F} {u : Nat} {h : F} :
    W.Continuing R t g u h ↔
      (t, g) = (u, h) ∨ W.active t g ∧ «相续» (continuationStep R) W.activityClass (t, g) (u, h) :=
  ⟨Continuing.line, fun along => match along with
    | .inl same => Eq.subst (motive := fun y => W.Continuing R t g y.1 y.2) same (.here t g)
    | .inr ⟨before, line⟩ => line_continuing line before⟩

/-- **More links, more continuing**, derived from the monotonicity of reach (`«及之单调»`). -/
theorem Continuing.mono_by_reach {S : Nat → F → F → Prop} (within : ∀ t g f, R t g f → S t g f)
    {t : Nat} {g : F} {u : Nat} {h : F} (continuing : W.Continuing R t g u h) :
    W.Continuing S t g u h :=
  match continuing_iff_line.mp continuing with
  | .inl same => continuing_iff_line.mpr (.inl same)
  | .inr ⟨before, line⟩ => continuing_iff_line.mpr (.inr ⟨before,
      «及之单调» (R := «续» (continuationStep R) W.activityClass)
        (S := «续» (continuationStep S) W.activityClass)
        (fun _ _ k => ⟨⟨k.1.1, within _ _ _ k.1.2⟩, k.2⟩) _ _ line⟩)

/-- **Renewing along a continuation is renewing along its line**: every relation taken part in
at the occurrence or at any occurrence of its line under activity is renewed. -/
theorem renewingAlong_iff_line {t : Nat} {g : F} :
    W.RenewingAlong R t g ↔ ∀ y : Nat × F,
      ((t, g) = y ∨ W.active t g ∧ «相续» (continuationStep R) W.activityClass (t, g) y) →
      ∀ c, W.Participates y.1 y.2 c → W.Renewed c :=
  ⟨fun renewing y along => renewing y.1 y.2 (continuing_iff_line.mpr along),
   fun renewing u h continuing => renewing (u, h) (continuing_iff_line.mp continuing)⟩

/-- **Consuming along a continuation is consuming along its line**: the occurrence or one of
its line under activity draws on a consumed condition. -/
theorem consumingAlong_iff_line {t : Nat} {g : F} :
    W.ConsumingAlong R t g ↔ ∃ y : Nat × F,
      ((t, g) = y ∨ W.active t g ∧ «相续» (continuationStep R) W.activityClass (t, g) y) ∧
      ∃ c, W.draws y.1 y.2 c ∧ W.Consumed c :=
  ⟨fun ⟨u, h, c, continuing, drawn, consumed⟩ =>
     ⟨(u, h), continuing_iff_line.mp continuing, c, drawn, consumed⟩,
   fun ⟨y, along, c, drawn, consumed⟩ =>
     ⟨y.1, y.2, c, continuing_iff_line.mpr along, drawn, consumed⟩⟩

/-- **The split law from the grammar.** Where `g` active at `t` continues as two formations
active after the step, renewing along `g` passes into both branches, and the branches form a
fission (分叉): neither lies in a line from the other. -/
theorem RenewingAlong.branches {t : Nat} {g f f' : F} (renewing : W.RenewingAlong R t g)
    (before : W.active t g) (r : R t g f) (r' : R t g f') (after : W.active (t + 1) f)
    (after' : W.active (t + 1) f') (apart : f ≠ f') :
    W.RenewingAlong R (t + 1) f ∧ W.RenewingAlong R (t + 1) f' ∧
      ¬ «相续» (continuationStep R) W.activityClass (t + 1, f) (t + 1, f') ∧
      ¬ «相续» (continuationStep R) W.activityClass (t + 1, f') (t + 1, f) :=
  match split_fission before r r' after after' apart with
  | ⟨line, line', apart₁, apart₂, _, _⟩ =>
    have onward : ∀ {b : Nat × F},
        «相续» (continuationStep R) W.activityClass (t, g) b → W.RenewingAlong R b.1 b.2 :=
      fun toB => renewingAlong_iff_line.mpr fun y along =>
        renewingAlong_iff_line.mp renewing y (.inr ⟨before, match along with
          | .inl same => Eq.subst
              (motive := fun z => «相续» (continuationStep R) W.activityClass (t, g) z) same toB
          | .inr ⟨_, further⟩ => «及之传递» toB further⟩)
    ⟨onward (b := (t + 1, f)) line, onward (b := (t + 1, f')) line', apart₁, apart₂⟩

/-- **The merge law from the two candles (蜡烛之合).** Where `g` and `g'` active at `t` both
continue as `f` active after the step, consuming along `f` is consuming along both. -/
theorem ConsumingAlong.merged_candles {t : Nat} {g g' f : F} (before : W.active t g)
    (before' : W.active t g') (r : R t g f) (r' : R t g' f) (after : W.active (t + 1) f)
    (consuming : W.ConsumingAlong R (t + 1) f) :
    W.ConsumingAlong R t g ∧ W.ConsumingAlong R t g' :=
  have candles := merge_candles before before' r r' after
  have through : ∀ {x : Nat × F}, W.active x.1 x.2 →
      «续» (continuationStep R) W.activityClass x (t + 1, f) → W.ConsumingAlong R x.1 x.2 :=
    fun active k => match consumingAlong_iff_line.mp consuming with
      | ⟨y, along, drawn⟩ => consumingAlong_iff_line.mpr ⟨y, .inr ⟨active, match along with
          | .inl same => Eq.subst
              (motive := fun z => «相续» (continuationStep R) W.activityClass _ z) same (.one k)
          | .inr ⟨_, line⟩ => .more k line⟩, drawn⟩
  ⟨through (x := (t, g)) before candles.1, through (x := (t, g')) before' candles.2.1⟩

/-- A link chain is the occurrence itself or a line under the one. -/
theorem Linked.line : ∀ {t : Nat} {g : F} {u : Nat} {h : F}, Linked R t g u h →
    (t, g) = (u, h) ∨ «相续» (continuationStep R) «一» (t, g) (u, h)
  | _, _, _, _, .here _ _ => .inl rfl
  | t, g, _, _, .next (f := f) step rest =>
    have k : «续» (continuationStep R) «一» (t, g) (t + 1, f) := ⟨⟨rfl, step⟩, trivial⟩
    match Linked.line rest with
    | .inl same => .inr (Eq.subst
        (motive := fun y => «相续» (continuationStep R) «一» (t, g) y) same (.one k))
    | .inr line => .inr (.more k line)

/-- A line under the one is a link chain. -/
theorem line_linked {x y : Nat × F} (line : «及» («续» (continuationStep R) «一») x y) :
    Linked R x.1 x.2 y.1 y.2 := by
  induction line with
  | @one a b k =>
    exact Eq.subst (motive := fun s => Linked R a.1 a.2 s b.2) k.1.1.symm
      (.next k.1.2 (.here (a.1 + 1) b.2))
  | @more a b z k _ ih =>
    exact .next k.1.2 (Eq.subst (motive := fun s => Linked R s b.2 z.1 z.2) k.1.1 ih)

/-- **Links are lines under the one (`«一»`).** With nothing asked of activity, `Linked R` is
the occurrence itself or a line under the one class. -/
theorem linked_iff_line {t : Nat} {g : F} {u : Nat} {h : F} :
    Linked R t g u h ↔ (t, g) = (u, h) ∨ «相续» (continuationStep R) «一» (t, g) (u, h) :=
  ⟨Linked.line, fun along => match along with
    | .inl same => Eq.subst (motive := fun y => Linked R t g y.1 y.2) same (.here t g)
    | .inr line => line_linked line⟩

/-- The class of a dependence on `c`: two occurrences are alike when both formations require `c`
at their steps or neither does. -/
def dependenceClass (W : Web F C) (c : C) : «际» (Nat × F) :=
  alikeBy fun x => W.requires x.1 x.2 c

theorem dependenceClass_class (W : Web F C) (c : C) : «类» (W.dependenceClass c) :=
  alikeBy_class _

/-- Links across which a dependence holds are the occurrence itself or a line under its class
from a formation requiring it. -/
theorem Linked.held_line {c : C} : ∀ {s : Nat} {h : F} {t : Nat} {g : F},
    Linked (W.holdingOn R c) s h t g → (s, h) = (t, g) ∨
      W.requires s h c ∧ «相续» (continuationStep R) (W.dependenceClass c) (s, h) (t, g)
  | _, _, _, _, .here _ _ => .inl rfl
  | s, h, _, _, .next (f := f) ⟨step, held, held'⟩ rest =>
    have k : «续» (continuationStep R) (W.dependenceClass c) (s, h) (s + 1, f) :=
      ⟨⟨rfl, step⟩, ⟨fun _ => held', fun _ => held⟩⟩
    match Linked.held_line rest with
    | .inl same => .inr ⟨held, Eq.subst
        (motive := fun y => «相续» (continuationStep R) (W.dependenceClass c) (s, h) y) same
        (.one k)⟩
    | .inr ⟨_, line⟩ => .inr ⟨held, .more k line⟩

/-- A line under a dependence's class from a formation requiring it is a chain of links across
which the dependence holds. -/
theorem line_held {c : C} {x y : Nat × F}
    (line : «及» («续» (continuationStep R) (W.dependenceClass c)) x y) :
    W.requires x.1 x.2 c → Linked (W.holdingOn R c) x.1 x.2 y.1 y.2 := by
  induction line with
  | @one a b k =>
    intro held
    have held' : W.requires (a.1 + 1) b.2 c :=
      Eq.subst (motive := fun s => W.requires s b.2 c) k.1.1 (k.2.mp held)
    exact Eq.subst (motive := fun s => Linked (W.holdingOn R c) a.1 a.2 s b.2) k.1.1.symm
      (.next ⟨k.1.2, held, held'⟩ (.here (a.1 + 1) b.2))
  | @more a b z k _ ih =>
    intro held
    have held' : W.requires (a.1 + 1) b.2 c :=
      Eq.subst (motive := fun s => W.requires s b.2 c) k.1.1 (k.2.mp held)
    exact .next ⟨k.1.2, held, held'⟩
      (Eq.subst (motive := fun s => Linked (W.holdingOn R c) s b.2 z.1 z.2) k.1.1
        (ih (k.2.mp held)))

/-- **Holding is a line under the dependence's class.** From a formation requiring `c`, links
across which the dependence holds are exactly the occurrence itself or a line under the class
"requires `c` or not". -/
theorem held_iff_line {c : C} {s : Nat} {h : F} {t : Nat} {g : F} (held : W.requires s h c) :
    Linked (W.holdingOn R c) s h t g ↔
      (s, h) = (t, g) ∨ «相续» (continuationStep R) (W.dependenceClass c) (s, h) (t, g) :=
  ⟨fun linked => match Linked.held_line linked with
     | .inl same => .inl same
     | .inr ⟨_, line⟩ => .inr line,
   fun along => match along with
     | .inl same => Eq.subst (motive := fun y => Linked (W.holdingOn R c) s h y.1 y.2) same
         (.here s h)
     | .inr line => line_held line held⟩

/-- **Tenure along a continuation is read off a line under the dependence's class**: some
occurrence requiring `c`, the event itself or one with a line under "requires `c` or not" to it,
met at its step a need above `m`. -/
theorem metAboveAlong_iff_line {t : Nat} {g : F} {c : C} {m : Nat} :
    W.MetAboveAlong R t g c m ↔ ∃ s h,
      ((s, h) = (t, g) ∨ «相续» (continuationStep R) (W.dependenceClass c) (s, h) (t, g)) ∧
      W.requires s h c ∧ W.need s h c ≤ W.level s c ∧ m < W.need s h c :=
  ⟨fun ⟨s, h, linked, held, met, above⟩ =>
     ⟨s, h, (held_iff_line held).mp linked, held, met, above⟩,
   fun ⟨s, h, along, held, met, above⟩ =>
     ⟨s, h, (held_iff_line held).mpr along, held, met, above⟩⟩

/-- The image of a line under a map carrying each continuation to a continuation is a line. -/
theorem line_image {α β : Type} {R₁ E₁ : «际» α} {R₂ E₂ : «际» β} (φ : α → β)
    (step : ∀ x y, «续» R₁ E₁ x y → «续» R₂ E₂ (φ x) (φ y)) {x y : α}
    (line : «相续» R₁ E₁ x y) : «相续» R₂ E₂ (φ x) (φ y) := by
  induction line with
  | one k => exact .one (step _ _ k)
  | more k _ ih => exact .more (step _ _ k) ih

/-- **A carried step is a step between the formations named.** Through a re-identification, a
continuation (续) under activity of the carried continuation is one of the original between the
formations the new names name. -/
theorem carry_step_iff (σ : Reidentify F F') {x y : Nat × F'} :
    «续» (continuationStep (σ.carry R)) (W.reidentify σ).activityClass x y ↔
      «续» (continuationStep R) W.activityClass (x.1, σ.old x.1 x.2) (y.1, σ.old y.1 y.2) :=
  ⟨fun ⟨⟨next, r⟩, alike⟩ => ⟨⟨next,
     Eq.subst (motive := fun s => R x.1 (σ.old x.1 x.2) (σ.old s y.2)) next.symm r⟩, alike⟩,
   fun ⟨⟨next, r⟩, alike⟩ => ⟨⟨next,
     Eq.subst (motive := fun s => R x.1 (σ.old x.1 x.2) (σ.old s y.2))
       (next : y.1 = x.1 + 1) r⟩, alike⟩⟩

/-- **Lines are unchanged by a re-identification** carrying the continuation: a line between two
occurrences under the new names is a line between the formations they name. -/
theorem line_reidentify (σ : Reidentify F F') {t u : Nat} {x y : F'} :
    «相续» (continuationStep (σ.carry R)) (W.reidentify σ).activityClass (t, x) (u, y) ↔
      «相续» (continuationStep R) W.activityClass (t, σ.old t x) (u, σ.old u y) :=
  ⟨line_image (fun p => (p.1, σ.old p.1 p.2)) (fun _ _ k => (carry_step_iff σ).mp k),
   fun line =>
     have named : ∀ p : Nat × F, (p.1, σ.old p.1 (σ.new p.1 p.2)) = p :=
       fun p => occurrence_eq rfl (σ.old_new p.1 p.2)
     have back := line_image (R₂ := continuationStep (σ.carry R))
       (E₂ := (W.reidentify σ).activityClass) (fun p => (p.1, σ.new p.1 p.2))
       (fun p q k => (carry_step_iff σ).mpr
         (Eq.subst (motive := fun a => «续» (continuationStep R) W.activityClass a
             (q.1, σ.old q.1 (σ.new q.1 q.2))) (named p).symm
           (Eq.subst (motive := fun b => «续» (continuationStep R) W.activityClass p b)
             (named q).symm k))) line
     Eq.subst (motive := fun a => «相续» (continuationStep (σ.carry R))
         (W.reidentify σ).activityClass (t, a) (u, y)) (σ.new_old t x)
       (Eq.subst (motive := fun b => «相续» (continuationStep (σ.carry R))
           (W.reidentify σ).activityClass (t, σ.new t (σ.old t x)) (u, b)) (σ.new_old u y) back)⟩

end Web

/-- **The merge is the two candles (蜡烛之合).** In `MergeClass` the first and the second both
continue as the merged formation. -/
theorem MergeClass.candles :
    «续» (Web.continuationStep MergeClass.merge) MergeClass.web.activityClass
        (0, MergeClass.Formation.first) (1, MergeClass.Formation.merged) ∧
      «续» (Web.continuationStep MergeClass.merge) MergeClass.web.activityClass
        (0, MergeClass.Formation.second) (1, MergeClass.Formation.merged) ∧
      «同族» (Web.continuationStep MergeClass.merge) MergeClass.web.activityClass
        (0, MergeClass.Formation.first) (0, MergeClass.Formation.second) :=
  Web.merge_candles (W := MergeClass.web) (R := MergeClass.merge) trivial trivial rfl rfl trivial

/-- **Both merged formations consume along the merge**, from the merge law of the two candles:
`MergeClass.first_consumes_along` derived through the grammar, and the same for the second. -/
theorem MergeClass.both_consume_along :
    MergeClass.web.ConsumingAlong MergeClass.merge 0 .first ∧
      MergeClass.web.ConsumingAlong MergeClass.merge 0 .second :=
  Web.ConsumingAlong.merged_candles (W := MergeClass.web) (R := MergeClass.merge) (t := 0)
    (f := MergeClass.Formation.merged) trivial trivial rfl rfl trivial
    ⟨1, MergeClass.Formation.merged, MergeClass.Place.spent, .here 1 MergeClass.Formation.merged,
     trivial, MergeClass.spent_consumed⟩

/-- **The bud is a fission (分叉).** In `Bud` the old formation continues as itself and as the
fresh one across the first step: both lie in lines from it, neither in a line from the other. -/
theorem Bud.fission :
    «相续» (Web.continuationStep Bud.bud) Bud.web.activityClass (0, .old) (1, .old) ∧
      «相续» (Web.continuationStep Bud.bud) Bud.web.activityClass (0, .old) (1, .fresh) ∧
      ¬ «相续» (Web.continuationStep Bud.bud) Bud.web.activityClass (1, .old) (1, .fresh) ∧
      ¬ «相续» (Web.continuationStep Bud.bud) Bud.web.activityClass (1, .fresh) (1, .old) ∧
      ((1, .old) : Nat × Bud.Formation) ≠ (1, .fresh) ∧
      «同族» (Web.continuationStep Bud.bud) Bud.web.activityClass (1, .old) (1, .fresh) :=
  Web.split_fission (W := Bud.web) (R := Bud.bud) (t := 0) (g := .old) (f := .old) (f' := .fresh)
    trivial (.inl rfl) (.inr ⟨rfl, rfl⟩) trivial trivial (fun same => Bud.Formation.noConfusion same)

end Becoming
