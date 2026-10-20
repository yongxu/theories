import Becoming.Persistence

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

end Becoming
