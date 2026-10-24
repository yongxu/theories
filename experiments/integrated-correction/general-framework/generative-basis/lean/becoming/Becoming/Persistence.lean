import Becoming.Grammar
import Becoming.Identity
import Becoming.Unfolding
import Becoming.Witnesses

/-!
# Persistence: identity across dormancy, and identity read off a world's relations

`Becoming.Identity` shows that which formation at one step continues which at the next is not
fixed by the relations of each step: the pattern of names carries it, and it is a premise of the
representation (`Turnover`). Its continuity conditions read across a step only formations active
at both ends (`KeepsActive`) or depending at both ends (`KeepsTenure`). A formation dormant at a
step falls outside them, so whether its waking is an arising, and what class it has across the
dormancy, are left open (`Dormancy`). This module asks two things of that premise: what carries a
formation across a step at which it is inactive, and how much of identity across steps a
world's own relations fix.

**Continuity across dormancy.** A formation *holds* at a step where it is active there or some
dependence of it holds there (`Web.Holds`). The web read through what holds (`Web.persisting h`,
for any `h`) is a web, so every law stated of a web holds of it, the census laws under a
continuation included (`Web.persisting_census`, an instance).
* Read through what holds, waking is not arising (`Web.waking_not_arising`), a formation active
  after a step arises across it exactly where it arises in activity and did not hold before
  (`Web.arises_persisting_iff`), and falling dormant is not ceasing
  (`Web.ceases_persisting_iff`). Read through activity, a waking is an arising under every
  continuation in which no other formation active before the step continues the waking one
  (`Web.arisesFrom_of_arises`).
* Keeping the names of what holds (`σ.KeepsActive (W.persisting h)`) keeps Identity's two
  continuities where activity and dependence lie within holding (`Web.keepsActive_of_held`,
  `Web.keepsTenure_of_held`), keeps one name over every stretch a formation holds, active or
  dormant (`Web.steady_held`), and fixes the class of a formation holding at every step
  (`Web.renewingIn_held`, `Web.consumingIn_held`).
* It is strictly stronger (`Hibernation.readings`). The hibernator is dormant at the second step,
  holding by its den. Exchanging it with the forager from the third step on keeps both of
  Identity's continuities, read both ways, and changes the hibernator's class from renewing to
  consuming; keeping the names of what holds excludes the exchange, and under every
  re-identification keeping them the hibernator renews.
* Its boundary (`Dormancy.held_both`): where nothing holds at the dormant step, keeping the names
  of what holds, read both ways, leaves the join of `Dormancy` and the change of class it makes.
  No continuation of what holds bridges a step at which nothing holds.
* Which relation holds a formation through dormancy is a choice of `h` (`Seed.held_readings`):
  read through dependence the spent seed of `Becoming.Reserve` holds at every step and never
  ends; read through its reserve it ends across the fourth step. The census laws need both of
  their ends read alike (`Sleeper.held_readings`): ceasing read through activity recurs where
  arising read through what holds never does.

**Identity read off a world's relations.** In a `World` the only relation joining one step to the
next is the balance of standing: what each relatum stands at after a step, with what it takes
across it, is what it stood at before with what it is given. Read with the names of one step
taken for the next, it induces a continuation (`World.Conserves`): `f` after the step continues
`g` before it where `f`'s standing after, with what `g` takes, is `g`'s standing before with what
`g` is given. A world read through a re-identification, in both roles of its relata, is
`World.reidentify`.
* **The namings under which a world balances are exactly its one-to-one continuations within
  conservation** (`World.balanced_reidentify_iff`, no premise). In a balanced world, conservation is
  likeness of standing after the step (`World.conserves_iff`), and a naming keeps the balance
  exactly where, across each step, the standings it reads are `Alike` to the world's under the
  law of exchange (`World.balanced_reidentify_iff_alike`, through `exchange_alike_iff` of
  `Becoming.Unfolding`). Keeping and breaking are fixed (`World.kept_broken_reidentify`).
* **Exactly what is fixed.** In a balanced world with decidable equality of relata, every naming
  keeping it balanced continues `c` as `c` across a step exactly where no other relatum stands
  after the step as `c` does (`World.fixed_iff`); `f` arises under every such naming exactly where
  it arises under conservation (`World.arises_fixed_iff`), and `g` ceases exactly where it ceases
  under conservation (`World.ceases_fixed_iff`). Where the relata active after a step stand apart
  there, conservation splits none (`World.conserves_noSplit`); where those active before it stand
  apart after it, it merges none (`World.conserves_noMerge`); with both, the census balance under
  it is exact. Where standing after every
  step sets every relatum apart, every naming keeping the world balanced is a renaming
  (`World.still_of_apart`) and fixes every relatum's class and arisings
  (`World.classes_fixed`); the shuttle of `Becoming.Roles` is such a world
  (`Shuttle.named_as_themselves`), and there the side coming to hold the standing arises at every
  step under every such naming, while naming the two sides as one keeps continuing activity and
  breaks the balance (`Shuttle.conserved`).
* **The boundary: two continuations both fit every relation.** In the two-kind reading as a world
  (`World.ofRoles`) formations stand at nothing, so every re-identification of formations keeps
  the world balanced exactly where it balances (`World.ofRoles_reidentify_balanced`), and arising,
  class and unceasing generation are read as in the re-identified web
  (`World.ofRoles_reidentify_arises`, `World.ofRoles_reidentify_renewingIn`,
  `World.ofRoles_reidentify_consumingIn`, `World.ofRoles_reidentify_unceasing`).
  `Lineage` read so balances named apart and named as one; arising recurs under the first and
  nothing arises under the second, and no arising is an arising under conservation
  (`Lineage.world_readings`). `Hibernation` read so balances under the exchange, under which the
  hibernator consumes rather than renews (`Hibernation.world_readings`): conservation does not fix
  the class across the dormancy; only keeping the names of what holds does.

Readings (the AI's, adopted on Ren's delegation of 15 October 2026, DELEGATED-CHOICES D5): that what
holds, rather than activity alone, carries a formation across dormancy, and that `Web.Holds`
(activity or a held dependence) is the relation that does; the theorems hold for every `h`. That the
balance of standing is the world's own relation across a step is a fact of `World`, whose other
relations each belong to one step; reading conservation as *the* continuation the relations induce
is a reading. Conservation follows standing, not a unit handed on: in the shuttle it follows the two
sides, and the reading in which the unit is one formation travelling between them breaks the
balance.

Not derived: undermining under naming within conservation (it follows a formation's tenure across
steps, which conservation fixes only where standings are apart); class along a continuation that
splits or merges (`Reidentify` is one to one, while `World.Conserves` may relate many to many); a
condition under which the census law holds with one end read through activity and the other
through what holds (only the failure is shown); which relation holds a formation through dormancy
(a choice of `h`). Where relata stand alike after a step, the world's relations leave identity
across it open: there it remains the premise `Becoming.Identity` names. No ethical predicate,
ranking or axiom occurs.
-/

namespace Becoming

variable {F F' C : Type}

/-! ## Continuity across dormancy -/

namespace Web

variable (W : Web F C)

/-- A formation *holds* at a step where it is active there or some dependence of it holds
there: a dependence held while it is inactive keeps it in the unfolding. -/
def Holds (t : Nat) (f : F) : Prop :=
  W.active t f ∨ ∃ c, W.requires t f c

/-- The web read through what holds: `h` in place of activity, every other relation as it
is. Every law stated of a web holds of it. -/
def persisting (h : Nat → F → Prop) : Web F C :=
  ⟨W.level, h, W.requires, W.need, W.draws⟩

variable {W} {h : Nat → F → Prop}

/-- **An arising of what holds, active after the step, is an arising from not holding.** Read
through what holds, a formation active after a step arises across it exactly where it arises
in activity and did not hold before the step. -/
theorem arises_persisting_iff (within : ∀ t f, W.active t f → h t f) {t : Nat} {f : F} :
    (W.persisting h).Arises t f ∧ W.active (t + 1) f ↔ W.Arises t f ∧ ¬ h t f :=
  ⟨fun ⟨⟨before, _⟩, after⟩ => ⟨⟨fun active => before (within t f active), after⟩, before⟩,
   fun ⟨⟨_, after⟩, before⟩ => ⟨⟨before, within (t + 1) f after⟩, after⟩⟩

/-- **Waking is not arising, read through what holds.** A formation holding before a step does
not arise across it. -/
theorem waking_not_arising {t : Nat} {f : F} (held : h t f) : ¬ (W.persisting h).Arises t f :=
  fun arises => arises.1 held

/-- And a formation active before a step ceases across it, read through what holds, exactly
where it ceases in activity and does not hold after the step: falling dormant is not
ceasing. -/
theorem ceases_persisting_iff (within : ∀ t f, W.active t f → h t f) {t : Nat} {f : F} :
    (W.persisting h).Ceases t f ∧ W.active t f ↔ W.Ceases t f ∧ ¬ h (t + 1) f :=
  ⟨fun ⟨⟨_, gone⟩, active⟩ => ⟨⟨active, fun after => gone (within (t + 1) f after)⟩, gone⟩,
   fun ⟨⟨active, _⟩, gone⟩ => ⟨⟨within t f active, gone⟩, active⟩⟩

/-- Read through activity, no continuation of one step reaches across dormancy: under every
continuation in which no other formation active before a step continues a formation, its
waking is arising. -/
theorem arisesFrom_of_arises {R : Nat → F → F → Prop} {t : Nat} {f : F}
    (alone : ∀ g, W.active t g → R t g f → g = f) (arises : W.Arises t f) :
    W.ArisesFrom R t f :=
  ⟨arises.2, fun ⟨g, active, continues⟩ =>
    arises.1 (Eq.subst (motive := fun x => W.active t x) (alone g active continues) active)⟩

/-- Keeping the names of formations holding before and after each step keeps the names of
those active before and after it, -/
theorem keepsActive_of_held {σ : Reidentify F F'} (within : ∀ t f, W.active t f → h t f)
    (keeps : σ.KeepsActive (W.persisting h)) : σ.KeepsActive W :=
  fun t f now next => keeps t f (within t f now) (within (t + 1) f next)

/-- and of those whose dependence on a condition continues across it. -/
theorem keepsTenure_of_held {σ : Reidentify F F'} (holding : ∀ t f c, W.requires t f c → h t f)
    (keeps : σ.KeepsActive (W.persisting h)) : σ.KeepsTenure W :=
  fun t g c now next => keeps t g (holding t g c now) (holding (t + 1) g c next)

/-- **Keeping the names of what holds, a formation keeps one name over every stretch through
which it holds, active or dormant.** -/
theorem steady_held {σ : Reidentify F F'} (keeps : σ.KeepsActive (W.persisting h)) {g : F}
    {s : Nat} : ∀ {t}, (∀ u, s ≤ u → u ≤ t → h u g) → ∀ u, s ≤ u → u ≤ t → σ.new u g = σ.new t g
  | 0, _, u, _, le => congrArg (σ.new · g) (Nat.le_antisymm le (Nat.zero_le u))
  | t + 1, held, u, from_, le => match Nat.lt_or_ge u (t + 1) with
    | .inl below =>
      have within : u ≤ t := Nat.le_of_lt_succ below
      (steady_held keeps (fun v a b => held v a (Nat.le_succ_of_le b)) u from_ within).trans
        (keeps t g (held t (Nat.le_trans from_ within) (Nat.le_succ t))
          (held (t + 1) (Nat.le_trans from_ (Nat.le_succ_of_le within)) (Nat.le_refl _))).symm
    | .inr above => congrArg (σ.new · g) (Nat.le_antisymm le above)

/-- A formation holding at every step bears, under such a re-identification, the name it has at
the first step throughout. -/
theorem named_throughout {σ : Reidentify F F'} (keeps : σ.KeepsActive (W.persisting h)) {f : F}
    (always : ∀ t, h t f) (t : Nat) : σ.old t (σ.new 0 f) = f :=
  (congrArg (σ.old t) (steady_held keeps (s := 0) (t := t) (fun u _ _ => always u) 0
    (Nat.le_refl 0) (Nat.zero_le t))).trans (σ.old_new t f)

/-- **The class of a formation holding at every step is fixed by keeping the names of what
holds**: it renews in the run under every such re-identification exactly where it does, -/
theorem renewingIn_held {σ : Reidentify F F'} (keeps : σ.KeepsActive (W.persisting h)) {f : F}
    (always : ∀ t, h t f) : (W.reidentify σ).RenewingIn (σ.new 0 f) ↔ W.RenewingIn f :=
  ⟨fun renewing t c joins => (W.reidentify_renewed σ c).mp (renewing t c
      (Eq.subst (motive := fun g => W.Participates t g c) (named_throughout keeps always t).symm
        joins)),
   fun renewing t c joins => (W.reidentify_renewed σ c).mpr (renewing t c
      (Eq.subst (motive := fun g => W.Participates t g c) (named_throughout keeps always t)
        joins))⟩

/-- and consumes exactly where it does. -/
theorem consumingIn_held {σ : Reidentify F F'} (keeps : σ.KeepsActive (W.persisting h)) {f : F}
    (always : ∀ t, h t f) : (W.reidentify σ).ConsumingIn (σ.new 0 f) ↔ W.ConsumingIn f :=
  ⟨fun ⟨t, c, drawn, consumed⟩ => ⟨t, c,
      Eq.subst (motive := fun g => W.draws t g c) (named_throughout keeps always t) drawn,
      (W.reidentify_consumed σ c).mp consumed⟩,
   fun ⟨t, c, drawn, consumed⟩ => ⟨t, c,
      Eq.subst (motive := fun g => W.draws t g c) (named_throughout keeps always t).symm drawn,
      (W.reidentify_consumed σ c).mpr consumed⟩⟩

/-- **The census law across dormancy**, an instance of `Census.arisingFrom_of_ceasingFrom` and
`Census.ceasingFrom_of_arisingFrom` on the web read through what holds: where what holds at each
step is listed, each once, under a continuation in which nothing holding before a step continues
as two holding after it, ceasing to hold at arbitrarily late steps needs coming to hold at
arbitrarily late steps; and, with at most `B` holding at each step from `T` on and nothing
continuing two, conversely. Both ends of the law are read through what holds (`Sleeper.held_readings`
shows the law failing where its two ends are read differently). -/
theorem persisting_census {R : Nat → F → F → Prop}
    [∀ t f, Decidable ((W.persisting h).active t f)]
    [∀ t f, Decidable ((W.persisting h).Continues R t f)]
    [∀ t g, Decidable ((W.persisting h).Continued R t g)] [∀ t g f, Decidable (R t g f)]
    {alive : Nat → List F} (census : (W.persisting h).Census alive) :
    ((W.persisting h).NoSplit R → (∀ N, ∃ t g, N ≤ t ∧ (W.persisting h).CeasesFrom R t g) →
      (W.persisting h).UnceasingFrom R) ∧
    ((W.persisting h).NoMerge R → ∀ {T B : Nat}, (∀ t, T ≤ t → (alive t).length ≤ B) →
      (W.persisting h).UnceasingFrom R → ∀ N, ∃ t g, N ≤ t ∧ (W.persisting h).CeasesFrom R t g) :=
  ⟨census.arisingFrom_of_ceasingFrom,
   fun noMerge _ _ bounded => census.ceasingFrom_of_arisingFrom noMerge bounded⟩

end Web

/-! ## Witnesses for continuity across dormancy -/

namespace Hibernation

/-- A hibernator, a forager, and a formation that needs the pool. -/
inductive Formation where
  | hibernator
  | forager
  | consumer

/-- A spring, a den and a pool. -/
inductive Condition where
  | spring
  | den
  | pool

/-- Every step but the second. -/
def awake : Nat → Prop := Witnesses.profile [True, False] True

/-- The second step. -/
def asleep : Nat → Prop := Witnesses.profile [False, True] False

/-- The first step. -/
def first : Nat → Prop := Witnesses.profile [True] False

/-- From the third step on. -/
def foraging : Nat → Prop := Witnesses.profile [False, False] True

/-- Whether a step comes after the second. -/
def fromSecond : Nat → Bool := Witnesses.profile [false, false] true

/-- Every condition stands at one. The hibernator is active at every step but the second, where
it is dormant, needing its den; while awake it needs one unit of the spring and draws it. The
forager is active from the third step on and draws the pool. The consumer needs two
units of the pool at the first step, which the pool never meets. -/
def web : Web Formation Condition where
  level _ _ := 1
  active t f := match f with
    | .hibernator => awake t
    | .forager => foraging t
    | .consumer => False
  requires t f c := match f, c with
    | .hibernator, .spring => awake t
    | .hibernator, .den => asleep t
    | .hibernator, .pool => False
    | .forager, _ => False
    | .consumer, .pool => first t
    | .consumer, .spring => False
    | .consumer, .den => False
  need _ f _ := match f with
    | .hibernator => 1
    | .forager => 0
    | .consumer => 2
  draws t f c := match f, c with
    | .hibernator, .spring => awake t
    | .hibernator, .den => False
    | .hibernator, .pool => False
    | .forager, .pool => foraging t
    | .forager, .spring => False
    | .forager, .den => False
    | .consumer, _ => False

/-- Exchange the hibernator and the forager. -/
def swap : Formation → Formation
  | .hibernator => .forager
  | .forager => .hibernator
  | .consumer => .consumer

theorem swap_swap : ∀ f, swap (swap f) = f
  | .hibernator | .forager | .consumer => rfl

/-- From the third step on, the hibernator and the forager exchange names: the formation active
after the hibernator's dormancy is read as the forager. -/
def exchange : Reidentify Formation Formation := .exchanging fromSecond swap swap_swap

/-- The hibernator holds at every step: awake, or dormant in its den. -/
theorem holds_always : ∀ t, web.Holds t .hibernator
  | 0 => .inl trivial
  | 1 => .inr ⟨.den, trivial⟩
  | _ + 2 => .inl trivial

theorem pool_consumed : web.Consumed .pool :=
  ⟨.consumer, 0, trivial, fun _ _ => Nat.lt_succ_self 1⟩

theorem pool_not_renewed : ¬ web.Renewed .pool :=
  fun renewed => Nat.not_succ_le_self 1 (renewed 0 .consumer trivial).1

theorem renewing : web.RenewingIn .hibernator :=
  fun _ c joins => match c, joins with
  | .spring, _ => fun _ g depends => match g, depends with
    | .hibernator, _ => ⟨Nat.le_refl 1, Nat.le_refl 1⟩
    | .forager, h => nomatch h
    | .consumer, h => nomatch h
  | .den, _ => fun _ g depends => match g, depends with
    | .hibernator, _ => ⟨Nat.le_refl 1, Nat.le_refl 1⟩
    | .forager, h => nomatch h
    | .consumer, h => nomatch h
  | .pool, .inl h => nomatch h
  | .pool, .inr h => nomatch h

/-- Exchanged, the formation named the hibernator draws the pool from the third step on, -/
theorem exchanged_consuming : (web.reidentify exchange).ConsumingIn .hibernator :=
  ⟨2, .pool, trivial, (web.reidentify_consumed exchange .pool).mpr pool_consumed⟩

/-- so it does not renew. -/
theorem exchanged_not_renewing : ¬ (web.reidentify exchange).RenewingIn .hibernator :=
  fun renewing => pool_not_renewed
    ((web.reidentify_renewed exchange .pool).mp (renewing 2 .pool (.inr trivial)))

/-- **What holds fixes the class across a held dormancy that Identity's continuity, read both
ways, leaves open.** Activity needs support. The hibernator is dormant at the second step and
holds there by its den; its waking is arising in activity and not read through what holds,
while the forager arises in both. Exchanging the two from the third step on keeps every
continuing activity and every continuing dependence, read both ways, yet breaks the
hibernator's holding across its waking; under it the formation named the hibernator consumes
and does not renew, while the hibernator renews. Under every re-identification keeping the names
of what holds, the hibernator renews. -/
theorem readings :
    web.Dependent ∧ ¬ web.active 1 .hibernator ∧ web.Holds 1 .hibernator ∧
    web.Arises 1 .hibernator ∧ ¬ (web.persisting web.Holds).Arises 1 .hibernator ∧
    web.Arises 1 .forager ∧ (web.persisting web.Holds).Arises 1 .forager ∧
    exchange.KeepsActive web ∧ exchange.back.KeepsActive (web.reidentify exchange) ∧
    exchange.KeepsTenure web ∧ exchange.back.KeepsTenure (web.reidentify exchange) ∧
    ¬ exchange.KeepsActive (web.persisting web.Holds) ∧
    web.RenewingIn .hibernator ∧ (web.reidentify exchange).ConsumingIn .hibernator ∧
    ¬ (web.reidentify exchange).RenewingIn .hibernator ∧
    ∀ σ : Reidentify Formation Formation, σ.KeepsActive (web.persisting web.Holds) →
      (web.reidentify σ).RenewingIn (σ.new 0 .hibernator) :=
  ⟨fun _ f active c depends => match f, c, active, depends with
    | .hibernator, .spring, _, _ => Nat.le_refl 1
    | .hibernator, .den, _, _ => Nat.le_refl 1
    | .hibernator, .pool, _, h => nomatch h
    | .forager, _, _, h => nomatch h
    | .consumer, _, a, _ => (nomatch a),
   id, .inr ⟨.den, trivial⟩, ⟨id, trivial⟩, Web.waking_not_arising (holds_always 1),
   ⟨id, trivial⟩,
   ⟨fun held => match held with
      | .inl h => nomatch h
      | .inr ⟨_, h⟩ => (nomatch h), .inl trivial⟩,
   fun t f now next => match t, f, now, next with
    | 0, .hibernator, _, next => nomatch next
    | 0, .forager, now, _ => nomatch now
    | 0, .consumer, now, _ => nomatch now
    | 1, .hibernator, now, _ => nomatch now
    | 1, .forager, now, _ => nomatch now
    | 1, .consumer, now, _ => nomatch now
    | _ + 2, _, _, _ => rfl,
   fun t x now next => match t, x, now, next with
    | 0, .hibernator, _, next => nomatch next
    | 0, .forager, now, _ => nomatch now
    | 1, .hibernator, now, _ => nomatch now
    | 1, .forager, now, _ => nomatch now
    | 0, .consumer, now, _ => nomatch now
    | 1, .consumer, now, _ => nomatch now
    | _ + 2, _, _, _ => rfl,
   fun t g c now next => match t, g, c, now, next with
    | 0, .hibernator, .spring, _, next => nomatch next
    | 0, .hibernator, .den, now, _ => nomatch now
    | 1, .hibernator, .spring, now, _ => nomatch now
    | 1, .hibernator, .den, _, next => nomatch next
    | 0, .consumer, .pool, _, next => nomatch next
    | 1, .consumer, .pool, now, _ => nomatch now
    | 0, .hibernator, .pool, now, _ => nomatch now
    | 1, .hibernator, .pool, now, _ => nomatch now
    | 0, .forager, _, now, _ => nomatch now
    | 1, .forager, _, now, _ => nomatch now
    | 0, .consumer, .spring, now, _ => nomatch now
    | 0, .consumer, .den, now, _ => nomatch now
    | 1, .consumer, .spring, now, _ => nomatch now
    | 1, .consumer, .den, now, _ => nomatch now
    | _ + 2, _, _, _, _ => rfl,
   fun t x c now next => match t, x, c, now, next with
    | 0, .hibernator, .spring, _, next => nomatch next
    | 0, .hibernator, .den, now, _ => nomatch now
    | 1, .hibernator, .spring, now, _ => nomatch now
    | 1, .hibernator, .den, _, next => nomatch next
    | 0, .consumer, .pool, _, next => nomatch next
    | 1, .consumer, .pool, now, _ => nomatch now
    | 0, .hibernator, .pool, now, _ => nomatch now
    | 1, .hibernator, .pool, now, _ => nomatch now
    | 0, .forager, _, now, _ => nomatch now
    | 1, .forager, _, now, _ => nomatch now
    | 0, .consumer, .spring, now, _ => nomatch now
    | 0, .consumer, .den, now, _ => nomatch now
    | 1, .consumer, .spring, now, _ => nomatch now
    | 1, .consumer, .den, now, _ => nomatch now
    | _ + 2, _, _, _, _ => rfl,
   fun keeps => Formation.noConfusion (keeps 1 .hibernator (holds_always 1) (holds_always 2)),
   renewing, exchanged_consuming, exchanged_not_renewing,
   fun _ keeps => (Web.renewingIn_held keeps holds_always).mpr renewing⟩

end Hibernation

/-- **Where nothing holds at the dormant step, keeping the names of what holds, read both ways,
leaves the join of `Dormancy` open.** No formation of `Dormancy` holds at two successive steps,
under either naming, so joining the late formation to the early one across the dormant step
keeps the names of what holds both ways, while it changes the class of the formation named
early (`Dormancy.classes`). -/
theorem Dormancy.held_both :
    Dormancy.join.KeepsActive (Dormancy.web.persisting Dormancy.web.Holds) ∧
    Dormancy.join.back.KeepsActive
      ((Dormancy.web.persisting Dormancy.web.Holds).reidentify Dormancy.join) ∧
    Dormancy.web.RenewingIn .early ∧ ¬ Dormancy.joined.RenewingIn .early :=
  have at_ : ∀ s f, Dormancy.web.Holds s f → s = 0 ∨ s = 2 := fun s f held => match held with
    | .inl active => match f, active with
      | .early, same => .inl same
      | .consumer, same => .inl same
      | .late, same => .inr same
    | .inr ⟨c, depends⟩ => .inl (Dormancy.first_only s f c depends)
  have once : ∀ s f g, Dormancy.web.Holds s f → Dormancy.web.Holds (s + 1) g → False :=
    fun s f g now next => match at_ s f now, at_ (s + 1) g next with
    | _, .inl after => Nat.noConfusion after
    | .inl zero, .inr two => Nat.noConfusion ((Nat.succ.inj two).symm.trans zero)
    | .inr two, .inr two' => Nat.noConfusion (Nat.succ.inj ((Nat.succ.inj two').symm.trans two))
  ⟨fun t f now next => (once t f f now next).elim,
   fun t _ now next => (once t _ _ now next).elim,
   Dormancy.classes.1, Dormancy.classes.2.2.2⟩

/-- **Which relation holds a formation through dormancy is a reading.** The seed of
`Becoming.Reserve` depends on light at every step, awake or not, and its reserve is spent after
the fourth step. It wakes twice. Read through what holds by dependence, it holds at every step:
its wakings are not arisings, and it never ends, though its reserve is spent. Read through what
holds by its reserve, its wakings are not arisings either, and it ends across the fourth step. -/
theorem Seed.held_readings :
    Seed.web.Arises 0 () ∧ Seed.web.Arises 2 () ∧
    (∀ t, (Seed.web.persisting Seed.web.Holds).active t ()) ∧
    (∀ t, ¬ (Seed.web.persisting Seed.web.Holds).Arises t ()) ∧
    (∀ t, ¬ (Seed.web.persisting fun t f => Seed.web.active t f ∨ 0 < Seed.reserve t).Arises t ()) ∧
    (Seed.web.persisting fun t f => Seed.web.active t f ∨ 0 < Seed.reserve t).Ceases 3 () :=
  have spent : ∀ t, ¬ (Seed.web.active (t + 4) () ∨ 0 < Seed.reserve (t + 4)) := fun _ held =>
    match held with
    | .inl awake => Nat.lt_irrefl 0 awake
    | .inr left => Nat.lt_irrefl 0 left
  ⟨Seed.seed.2.2.1, Seed.seed.2.2.2.1, fun _ => .inr ⟨(), trivial⟩,
   fun _ arises => arises.1 (.inr ⟨(), trivial⟩),
   fun t arises => match t, arises with
    | 0, arises => arises.1 (.inr (Nat.zero_lt_succ 1))
    | 1, arises => arises.1 (.inr (Nat.zero_lt_succ 1))
    | 2, arises => arises.1 (.inr Nat.zero_lt_one)
    | t + 3, arises => spent t arises.2,
   ⟨.inr Nat.zero_lt_one, spent 0⟩⟩

/-- **The census laws need both ends read alike.** The relatum of `Sleeper` stands at one
throughout and is awake at odd steps. Read through activity it arises and ceases at arbitrarily
late steps; read through what holds by its standing, it holds throughout and nothing arises. So
ceasing read through activity recurs while arising read through what holds never does: the
census law (`Census.arisingFrom_of_ceasingFrom`) fails when its two ends are read differently,
and holds within each reading, `W.persisting h` being a web. -/
theorem Sleeper.held_readings :
    Sleeper.web.Unceasing ∧ (∀ N, ∃ t, N ≤ t ∧ Sleeper.web.Ceases t ()) ∧
    ∀ t, ¬ (Sleeper.web.persisting fun t x => Sleeper.web.active t x ∨
      0 < Sleeper.web.level t x).Arises t () :=
  ⟨Sleeper.sleeper.2.2.2.1,
   fun N => match Shuttle.recurs false N with
    | ⟨t, later, arises⟩ => ⟨t + 1, Nat.le_succ_of_le later, arises.2, fun after =>
        arises.1 (Eq.subst (motive := fun n => 0 < n) (Shuttle.stands_two false t) after)⟩,
   fun _ arises => arises.1 (.inr Nat.zero_lt_one)⟩

/-! ## Identity read off a world's relations -/

namespace World

variable (w : World) {R' : Type}

/-- A world with its relata re-identified across steps, in both their roles: at step `t` the
relatum named `x` is the one named `σ.old t x` before, and what is taken and given across the
step from `t` is named as the configuration at `t` is, the move belonging to the configuration
it is made from (`withMove`). Each step's relations are those of the world at that step, read
through the naming there. -/
def reidentify (σ : Reidentify w.Relatum R') : World :=
  World.of R' (⟨fun t => (w.flow.present t).map (σ.new t), fun t x y => w.flow.take t (σ.old t x) (σ.old t y),
      fun t x y => w.flow.give t (σ.old t x) (σ.old t y)⟩) (⟨fun t x => w.web.level t (σ.old t x), fun t x => w.web.active t (σ.old t x),
      fun t x y => w.web.requires t (σ.old t x) (σ.old t y),
      fun t x y => w.web.need t (σ.old t x) (σ.old t y),
      fun t x y => w.web.draws t (σ.old t x) (σ.old t y)⟩)

/-- **The continuation a world's relations induce.** Across the step from `t`, `f` after it
continues `g` before it by conservation: `f`'s standing after the step, with what is taken from
`g` across it, is `g`'s standing before it with what is given to `g`. Only the relations of the
step are read; no identity across it is used. -/
def Conserves (t : Nat) (g f : w.Relatum) : Prop :=
  w.web.level (t + 1) f + w.flow.taken t g = w.web.level t g + w.flow.given t g

variable {w}

theorem reidentify_taken (σ : Reidentify w.Relatum R') (t : Nat) (y : R') :
    (w.reidentify σ).flow.taken t y = w.flow.taken t (σ.old t y) :=
  total_reidentify σ t (fun f => w.flow.take t f (σ.old t y)) (w.flow.present t)

theorem reidentify_given (σ : Reidentify w.Relatum R') (t : Nat) (y : R') :
    (w.reidentify σ).flow.given t y = w.flow.given t (σ.old t y) :=
  total_reidentify σ t (fun f => w.flow.give t f (σ.old t y)) (w.flow.present t)

/-- A world balances exactly where each relatum continues itself by conservation. -/
theorem balanced_iff_conserves : w.Balanced ↔ ∀ t c, w.Conserves t c c :=
  Iff.rfl

/-- **The namings under which a world balances are exactly its one-to-one continuations within
conservation.** No premise: a re-identification keeps the world a run of the law of exchange
exactly where, across each step, the relatum it reads as continuing each relatum continues it
by conservation. -/
theorem balanced_reidentify_iff (σ : Reidentify w.Relatum R') :
    (w.reidentify σ).Balanced ↔ ∀ t c, w.Conserves t c (σ.old (t + 1) (σ.new t c)) :=
  ⟨fun balanced t c =>
    have there : w.web.level (t + 1) (σ.old (t + 1) (σ.new t c)) +
        w.flow.taken t (σ.old t (σ.new t c)) =
        w.web.level t (σ.old t (σ.new t c)) + w.flow.given t (σ.old t (σ.new t c)) :=
      (congrArg (w.web.level (t + 1) (σ.old (t + 1) (σ.new t c)) + ·)
        (reidentify_taken σ t (σ.new t c))).symm.trans ((balanced t (σ.new t c)).trans
          (congrArg (w.web.level t (σ.old t (σ.new t c)) + ·) (reidentify_given σ t (σ.new t c))))
    Eq.subst (motive := fun g => w.web.level (t + 1) (σ.old (t + 1) (σ.new t c)) +
      w.flow.taken t g = w.web.level t g + w.flow.given t g) (σ.old_new t c) there,
   fun conserves t x =>
    have here : w.Conserves t (σ.old t x) (σ.old (t + 1) x) :=
      Eq.subst (motive := fun y => w.Conserves t (σ.old t x) (σ.old (t + 1) y)) (σ.new_old t x)
        (conserves t (σ.old t x))
    (congrArg (w.web.level (t + 1) (σ.old (t + 1) x) + ·) (reidentify_taken σ t x)).trans
      (here.trans (congrArg (w.web.level t (σ.old t x) + ·) (reidentify_given σ t x)).symm)⟩

/-- In a balanced world, `f` continues `g` by conservation across a step exactly where `f`
stands after the step as `g` does. -/
theorem conserves_iff (balanced : w.Balanced) {t : Nat} {g f : w.Relatum} :
    w.Conserves t g f ↔ w.web.level (t + 1) f = w.web.level (t + 1) g :=
  ⟨fun conserves => add_right_cancel (w.flow.taken t g) (conserves.trans (balanced t g).symm),
   fun same => (congrArg (· + w.flow.taken t g) same).trans (balanced t g)⟩

/-- **In a balanced world, a naming keeps the balance exactly where, across each step, the
standings after it read through the naming are alike to the standings after it** under the law
of exchange (`exchange_alike_iff`): conservation fixes identity across a step up to likeness of
standing after it. -/
theorem balanced_reidentify_iff_alike (balanced : w.Balanced) (σ : Reidentify w.Relatum R') :
    (w.reidentify σ).Balanced ↔ ∀ t, Alike (exchangeFrame w.Relatum) (exchangeFrame w.Relatum)
      (fun c => w.web.level (t + 1) (σ.old (t + 1) (σ.new t c))) (w.web.level (t + 1)) :=
  (balanced_reidentify_iff σ).trans
    ⟨fun conserves t => exchange_alike_iff.mpr fun c => (conserves_iff balanced).mp (conserves t c),
     fun alike t c => (conserves_iff balanced).mpr (exchange_alike_iff.mp (alike t) c)⟩

/-- Under a naming keeping a balanced world balanced, each relatum named after a step stands
there as the one it was named before the step. -/
theorem standing_after (balanced : w.Balanced) {σ : Reidentify w.Relatum R'}
    (kept : (w.reidentify σ).Balanced) (t : Nat) (y : R') :
    w.web.level (t + 1) (σ.old (t + 1) y) = w.web.level (t + 1) (σ.old t y) :=
  (conserves_iff balanced).mp (Eq.subst (motive := fun x => w.Conserves t (σ.old t y) (σ.old (t + 1) x))
    (σ.new_old t y) ((balanced_reidentify_iff σ).mp kept t (σ.old t y)))

/-- **Keeping and breaking are fixed by conservation.** Under every naming keeping a balanced
world balanced, each step keeps and breaks exactly the dependences it keeps and breaks, read
through the naming at the step. -/
theorem kept_broken_reidentify (balanced : w.Balanced) {σ : Reidentify w.Relatum R'}
    (kept : (w.reidentify σ).Balanced) (t : Nat) (x y : R') :
    ((w.reidentify σ).web.Kept t x y ↔ w.web.Kept t (σ.old t x) (σ.old t y)) ∧
    ((w.reidentify σ).web.Broken t x y ↔ w.web.Broken t (σ.old t x) (σ.old t y)) :=
  have same := standing_after balanced kept t y
  ⟨⟨fun ⟨now, next⟩ => ⟨now, Eq.subst (motive := fun n => w.web.need t (σ.old t x) (σ.old t y) ≤ n)
      same next⟩,
    fun ⟨now, next⟩ => ⟨now, Eq.subst (motive := fun n => w.web.need t (σ.old t x) (σ.old t y) ≤ n)
      same.symm next⟩⟩,
   ⟨fun ⟨depends, met, fell⟩ => ⟨depends, met,
      Eq.subst (motive := fun n => n < w.web.need t (σ.old t x) (σ.old t y)) same fell⟩,
    fun ⟨depends, met, fell⟩ => ⟨depends, met,
      Eq.subst (motive := fun n => n < w.web.need t (σ.old t x) (σ.old t y)) same.symm fell⟩⟩⟩

end World

/-! ## Exchanging two relata across one step -/

section Exchange

variable {X : Type} [DecidableEq X]

/-- Exchange `c` and `d`, every other relatum as it is. -/
def transpose (c d x : X) : X :=
  if x = c then d else if x = d then c else x

theorem transpose_left (c d : X) : transpose c d c = d :=
  if_pos rfl

theorem transpose_right (c d : X) : transpose c d d = c :=
  match decEq d c with
  | isTrue same => (if_pos same).trans same
  | isFalse other => (if_neg other).trans (if_pos rfl)

theorem transpose_other {c d x : X} (not_c : ¬ x = c) (not_d : ¬ x = d) : transpose c d x = x :=
  (if_neg not_c).trans (if_neg not_d)

theorem transpose_transpose (c d x : X) : transpose c d (transpose c d x) = x :=
  match decEq x c with
  | isTrue same =>
    (congrArg (transpose c d) (if_pos same : transpose c d x = d)).trans
      ((transpose_right c d).trans same.symm)
  | isFalse not_c => match decEq x d with
    | isTrue same =>
      (congrArg (transpose c d) ((if_neg not_c).trans (if_pos same) : transpose c d x = c)).trans
        ((transpose_left c d).trans same.symm)
    | isFalse not_d =>
      (congrArg (transpose c d) (transpose_other not_c not_d)).trans (transpose_other not_c not_d)

/-- Exchanging two relata that a quantity gives alike keeps the quantity of every relatum. -/
theorem transpose_alike {q : X → Nat} {c d : X} (alike : q d = q c) (x : X) :
    q (transpose c d x) = q x :=
  match decEq x c with
  | isTrue same => (congrArg q (if_pos same : transpose c d x = d)).trans
      (alike.trans (congrArg q same).symm)
  | isFalse not_c => match decEq x d with
    | isTrue same => (congrArg q ((if_neg not_c).trans (if_pos same) : transpose c d x = c)).trans
        (alike.symm.trans (congrArg q same).symm)
    | isFalse not_d => congrArg q (transpose_other not_c not_d)

end Exchange

/-- Whether step `s` comes after step `t`. -/
def stepBeyond : Nat → Nat → Bool
  | _, 0 => false
  | 0, _ + 1 => true
  | t + 1, s + 1 => stepBeyond t s

theorem stepBeyond_self : ∀ t, stepBeyond t t = false
  | 0 => rfl
  | t + 1 => stepBeyond_self t

theorem stepBeyond_next : ∀ t, stepBeyond t (t + 1) = true
  | 0 => rfl
  | t + 1 => stepBeyond_next t

theorem stepBeyond_zero : ∀ t, stepBeyond t 0 = false
  | 0 => rfl
  | _ + 1 => rfl

theorem stepBeyond_step : ∀ t s, ¬ s = t → stepBeyond t (s + 1) = stepBeyond t s
  | 0, 0, other => absurd rfl other
  | 0, _ + 1, _ => rfl
  | t + 1, 0, _ => (stepBeyond_zero t).trans (stepBeyond_zero (t + 1)).symm
  | t + 1, s + 1, other => stepBeyond_step t s (fun same => other (congrArg (· + 1) same))

section Exchange

variable {X : Type} [DecidableEq X]

/-- Exchange `c` and `d` at every step after `t`: across the step from `t`, `c` continues as `d`
and `d` as `c`; across every other step each relatum continues as itself. -/
def Reidentify.exchangeAfter (t : Nat) (c d : X) : Reidentify X X :=
  .exchanging (stepBeyond t) (transpose c d) (transpose_transpose c d)

theorem Reidentify.exchangeAfter_at (t : Nat) (c d x : X) :
    (Reidentify.exchangeAfter t c d).old t x = x ∧ (Reidentify.exchangeAfter t c d).new t x = x :=
  ⟨Eq.subst (motive := fun b => turn (transpose c d) b x = x) (stepBeyond_self t).symm rfl,
   Eq.subst (motive := fun b => turn (transpose c d) b x = x) (stepBeyond_self t).symm rfl⟩

theorem Reidentify.exchangeAfter_next (t : Nat) (c d x : X) :
    (Reidentify.exchangeAfter t c d).new (t + 1) x = transpose c d x :=
  Eq.subst (motive := fun b => turn (transpose c d) b x = transpose c d x) (stepBeyond_next t).symm rfl

theorem Reidentify.exchangeAfter_across (t : Nat) (c d x : X) :
    (Reidentify.exchangeAfter t c d).old (t + 1) ((Reidentify.exchangeAfter t c d).new t x) =
      transpose c d x :=
  Eq.subst (motive := fun b => turn (transpose c d) b (turn (transpose c d) (stepBeyond t t) x) =
      transpose c d x) (stepBeyond_next t).symm
    (Eq.subst (motive := fun b => turn (transpose c d) true (turn (transpose c d) b x) =
      transpose c d x) (stepBeyond_self t).symm rfl)

theorem Reidentify.exchangeAfter_elsewhere {t s : Nat} (other : ¬ s = t) (c d x : X) :
    (Reidentify.exchangeAfter t c d).old (s + 1) ((Reidentify.exchangeAfter t c d).new s x) = x :=
  Eq.subst (motive := fun b => turn (transpose c d) b (turn (transpose c d) (stepBeyond t s) x) = x)
    (stepBeyond_step t s other).symm (turn_turn (transpose_transpose c d) (stepBeyond t s) x)

end Exchange

namespace World

variable {w : World} {R' : Type}

/-- Exchanging after a step two relata standing alike after it keeps a balanced world
balanced. -/
theorem exchangeAfter_balanced [dec : DecidableEq w.Relatum] (balanced : w.Balanced) {t : Nat}
    {c d : w.Relatum} (alike : w.web.level (t + 1) d = w.web.level (t + 1) c) :
    (w.reidentify (Reidentify.exchangeAfter t c d)).Balanced :=
  (balanced_reidentify_iff _).mpr fun s x => match Nat.decEq s t with
    | isTrue same => Eq.subst (motive := fun s => w.Conserves s x
          ((Reidentify.exchangeAfter t c d).old (s + 1) ((Reidentify.exchangeAfter t c d).new s x)))
        same.symm (Eq.subst (motive := fun y => w.Conserves t x y)
          (Reidentify.exchangeAfter_across t c d x).symm
          ((conserves_iff balanced).mpr (transpose_alike (q := w.web.level (t + 1)) alike x)))
    | isFalse other => Eq.subst (motive := fun y => w.Conserves s x y)
        (Reidentify.exchangeAfter_elsewhere other c d x).symm (balanced s x)

/-- **Conservation fixes a relatum's identity across a step exactly where no other relatum
stands after the step as it does.** In a balanced world, every naming keeping it balanced
continues `c` as `c` across the step from `t` exactly where every relatum standing after the step
as `c` does is `c`. The necessity exchanges `c` with another standing alike, using decidable
equality of relata. -/
theorem fixed_iff [dec : DecidableEq w.Relatum] (balanced : w.Balanced) (t : Nat) (c : w.Relatum) :
    (∀ σ : Reidentify w.Relatum w.Relatum, (w.reidentify σ).Balanced →
      σ.old (t + 1) (σ.new t c) = c) ↔
      ∀ d, w.web.level (t + 1) d = w.web.level (t + 1) c → d = c :=
  ⟨fun fixed d alike => (transpose_left c d).symm.trans
      ((Reidentify.exchangeAfter_across t c d c).symm.trans
        (fixed _ (exchangeAfter_balanced balanced alike))),
   fun apart σ kept => apart _ ((conserves_iff balanced).mp ((balanced_reidentify_iff σ).mp kept t c))⟩

/-- **An arising is a fact of the unfolding exactly where it is an arising under the continuation
the relations induce.** In a balanced world, `f` arises across the step from `t` under every
naming keeping the world balanced exactly where it arises under conservation: it is active after
the step, and no relatum active before it stands after it as `f` does. -/
theorem arises_fixed_iff [dec : DecidableEq w.Relatum] (balanced : w.Balanced) (t : Nat) (f : w.Relatum) :
    (∀ σ : Reidentify w.Relatum w.Relatum, (w.reidentify σ).Balanced →
      (w.reidentify σ).web.Arises t (σ.new (t + 1) f)) ↔ w.web.ArisesFrom w.Conserves t f :=
  ⟨fun fixed =>
    have arises : w.web.Arises t f :=
      fixed (Reidentify.rename (fun x => x) (fun x => x) (fun _ => rfl) (fun _ => rfl))
        ((balanced_reidentify_iff _).mpr balanced)
    ⟨arises.2, fun ⟨g, active, conserves⟩ =>
      have named : (Reidentify.exchangeAfter t g f).old t
          ((Reidentify.exchangeAfter t g f).new (t + 1) f) = g :=
        (Reidentify.exchangeAfter_at t g f _).1.trans
          ((Reidentify.exchangeAfter_next t g f f).trans (transpose_right g f))
      (fixed (Reidentify.exchangeAfter t g f)
        (exchangeAfter_balanced balanced ((conserves_iff balanced).mp conserves))).1
        (Eq.subst (motive := fun y => w.web.active t y) named.symm active)⟩,
   fun ⟨after, alone⟩ σ kept =>
    ⟨fun before => alone ⟨σ.old t (σ.new (t + 1) f), before,
      Eq.subst (motive := fun y => w.Conserves t (σ.old t (σ.new (t + 1) f)) y) (σ.old_new (t + 1) f)
        (Eq.subst (motive := fun y => w.Conserves t (σ.old t (σ.new (t + 1) f)) (σ.old (t + 1) y))
          (σ.new_old t (σ.new (t + 1) f))
          ((balanced_reidentify_iff σ).mp kept t (σ.old t (σ.new (t + 1) f))))⟩,
     Eq.subst (motive := fun y => w.web.active (t + 1) y) (σ.old_new (t + 1) f).symm after⟩⟩

/-- **And a ceasing is a fact of the unfolding exactly where it is a ceasing under conservation**:
`g` is active before the step, and no relatum active after it stands after it as `g` does. -/
theorem ceases_fixed_iff [dec : DecidableEq w.Relatum] (balanced : w.Balanced) (t : Nat) (g : w.Relatum) :
    (∀ σ : Reidentify w.Relatum w.Relatum, (w.reidentify σ).Balanced →
      (w.reidentify σ).web.Ceases t (σ.new t g)) ↔ w.web.CeasesFrom w.Conserves t g :=
  ⟨fun fixed =>
    have ceases : w.web.Ceases t g :=
      fixed (Reidentify.rename (fun x => x) (fun x => x) (fun _ => rfl) (fun _ => rfl))
        ((balanced_reidentify_iff _).mpr balanced)
    ⟨ceases.1, fun ⟨f, after, conserves⟩ =>
      (fixed (Reidentify.exchangeAfter t g f)
        (exchangeAfter_balanced balanced ((conserves_iff balanced).mp conserves))).2
        (Eq.subst (motive := fun y => w.web.active (t + 1) y)
          ((transpose_left g f).symm.trans (Reidentify.exchangeAfter_across t g f g).symm) after)⟩,
   fun ⟨before, alone⟩ σ kept =>
    ⟨Eq.subst (motive := fun y => w.web.active t y) (σ.old_new t g).symm before,
     fun after => alone ⟨σ.old (t + 1) (σ.new t g), after, (balanced_reidentify_iff σ).mp kept t g⟩⟩⟩

/-- In a balanced world where the relata active after each step stand apart after it, the
continuation the relations induce splits no formation, -/
theorem conserves_noSplit (balanced : w.Balanced)
    (apart : ∀ t f f', w.web.active (t + 1) f → w.web.active (t + 1) f' →
      w.web.level (t + 1) f = w.web.level (t + 1) f' → f = f') : w.web.NoSplit w.Conserves :=
  fun t _ f f' _ conserves conserves' after after' => apart t f f' after after'
    (((conserves_iff balanced).mp conserves).trans ((conserves_iff balanced).mp conserves').symm)

/-- and where those active before each step stand apart after it, it merges none; with both,
the census balance under it is exact (`Census.balanceFrom_eq`). -/
theorem conserves_noMerge (balanced : w.Balanced)
    (apart : ∀ t g g', w.web.active t g → w.web.active t g' →
      w.web.level (t + 1) g = w.web.level (t + 1) g' → g = g') : w.web.NoMerge w.Conserves :=
  fun t g g' _ before before' conserves conserves' _ => apart t g g' before before'
    (((conserves_iff balanced).mp conserves).symm.trans ((conserves_iff balanced).mp conserves'))

/-- **Where standing after every step sets every relatum apart, every naming keeping a balanced
world balanced follows each relatum as itself**: it is a renaming. -/
theorem still_of_apart (balanced : w.Balanced)
    (apart : ∀ t c d, w.web.level (t + 1) c = w.web.level (t + 1) d → c = d)
    {σ : Reidentify w.Relatum R'} (kept : (w.reidentify σ).Balanced) :
    ∀ t x, σ.old (t + 1) x = σ.old t x :=
  fun t x => apart t _ _ (standing_after balanced kept t x)

end World

/-- A re-identification that names each relatum alike across every step names it at every step as
at the first. -/
theorem Reidentify.old_still {σ : Reidentify F F'} (still : ∀ t x, σ.old (t + 1) x = σ.old t x) :
    ∀ t x, σ.old t x = σ.old 0 x
  | 0, _ => rfl
  | t + 1, x => (still t x).trans (Reidentify.old_still still t x)

namespace World

variable {w : World} {R' : Type}

section Still

variable {σ : Reidentify w.Relatum R'} (still : ∀ t x, σ.old (t + 1) x = σ.old t x)
include still

/-- Under a naming that follows each relatum as itself, a condition is renewed exactly where the
relatum it names is, -/
theorem renewed_still (y : R') :
    (w.reidentify σ).web.Renewed y ↔ w.web.Renewed (σ.old 0 y) :=
  have first := Reidentify.old_still still
  ⟨fun renewed t g depends => match renewed t (σ.new t g)
      (Eq.subst (motive := fun x => w.web.requires t x (σ.old t y)) (σ.old_new t g).symm
        (Eq.subst (motive := fun c => w.web.requires t g c) (first t y).symm depends)) with
    | ⟨now, next⟩ =>
      ⟨Eq.subst (motive := fun x => w.web.need t x (σ.old 0 y) ≤ w.web.level t (σ.old 0 y))
          (σ.old_new t g)
          (Eq.subst (motive := fun c => w.web.need t (σ.old t (σ.new t g)) c ≤ w.web.level t c)
            (first t y) now),
       Eq.subst (motive := fun x => w.web.need t x (σ.old 0 y) ≤ w.web.level (t + 1) (σ.old 0 y))
          (σ.old_new t g)
          (Eq.subst (motive := fun c => w.web.need t (σ.old t (σ.new t g)) c ≤
              w.web.level (t + 1) (σ.old 0 y)) (first t y)
            (Eq.subst (motive := fun c => w.web.need t (σ.old t (σ.new t g)) (σ.old t y) ≤
                w.web.level (t + 1) c) (first (t + 1) y) next))⟩,
   fun renewed t x depends => match renewed t (σ.old t x)
      (Eq.subst (motive := fun c => w.web.requires t (σ.old t x) c) (first t y) depends) with
    | ⟨now, next⟩ =>
      ⟨Eq.subst (motive := fun c => w.web.need t (σ.old t x) c ≤ w.web.level t c) (first t y).symm
          now,
       Eq.subst (motive := fun c => w.web.need t (σ.old t x) (σ.old t y) ≤ w.web.level (t + 1) c)
          (first (t + 1) y).symm
          (Eq.subst (motive := fun c => w.web.need t (σ.old t x) c ≤ w.web.level (t + 1) (σ.old 0 y))
            (first t y).symm next)⟩⟩

/-- consumed exactly where it is, -/
theorem consumed_still (y : R') :
    (w.reidentify σ).web.Consumed y ↔ w.web.Consumed (σ.old 0 y) :=
  have first := Reidentify.old_still still
  ⟨fun ⟨g, T, depends, below⟩ => ⟨σ.old T g, T,
      Eq.subst (motive := fun c => w.web.requires T (σ.old T g) c) (first T y) depends,
      fun t later => Eq.subst (motive := fun c => w.web.level t c < w.web.need T (σ.old T g) (σ.old 0 y))
        (first t y) (Eq.subst (motive := fun c => w.web.level t (σ.old t y) <
          w.web.need T (σ.old T g) c) (first T y) (below t later))⟩,
   fun ⟨g, T, depends, below⟩ => ⟨σ.new T g, T,
      Eq.subst (motive := fun x => w.web.requires T x (σ.old T y)) (σ.old_new T g).symm
        (Eq.subst (motive := fun c => w.web.requires T g c) (first T y).symm depends),
      fun t later => Eq.subst (motive := fun x => w.web.level t (σ.old t y) < w.web.need T x (σ.old T y))
        (σ.old_new T g).symm
        (Eq.subst (motive := fun c => w.web.level t (σ.old t y) < w.web.need T g c) (first T y).symm
          (Eq.subst (motive := fun c => w.web.level t c < w.web.need T g (σ.old 0 y)) (first t y).symm
            (below t later)))⟩⟩

/-- and a relatum renews, consumes and arises exactly where the one it names does. -/
theorem classes_still (x : R') :
    ((w.reidentify σ).web.RenewingIn x ↔ w.web.RenewingIn (σ.old 0 x)) ∧
    ((w.reidentify σ).web.ConsumingIn x ↔ w.web.ConsumingIn (σ.old 0 x)) ∧
    ∀ t, ((w.reidentify σ).web.Arises t x ↔ w.web.Arises t (σ.old 0 x)) :=
  have first := Reidentify.old_still still
  have named : ∀ t c, σ.old t (σ.new 0 c) = c := fun t c => (first t _).trans (σ.old_new 0 c)
  ⟨⟨fun renewing t c joins =>
      Eq.subst (motive := fun c => w.web.Renewed c) (σ.old_new 0 c)
        ((renewed_still still (σ.new 0 c)).mp (renewing t (σ.new 0 c)
          (Eq.subst (motive := fun x => w.web.Participates t x (σ.old t (σ.new 0 c))) (first t x).symm
            (Eq.subst (motive := fun c => w.web.Participates t (σ.old 0 x) c) (named t c).symm joins)))),
    fun renewing t c joins => (renewed_still still c).mpr (renewing t (σ.old 0 c)
      (Eq.subst (motive := fun d => w.web.Participates t (σ.old 0 x) d) (first t c)
        (Eq.subst (motive := fun y => w.web.Participates t y (σ.old t c)) (first t x) joins)))⟩,
   ⟨fun ⟨t, c, drawn, consumed⟩ => ⟨t, σ.old 0 c,
      Eq.subst (motive := fun d => w.web.draws t (σ.old 0 x) d) (first t c)
        (Eq.subst (motive := fun y => w.web.draws t y (σ.old t c)) (first t x) drawn),
      (consumed_still still c).mp consumed⟩,
    fun ⟨t, c, drawn, consumed⟩ => ⟨t, σ.new 0 c,
      Eq.subst (motive := fun y => w.web.draws t y (σ.old t (σ.new 0 c))) (first t x).symm
        (Eq.subst (motive := fun d => w.web.draws t (σ.old 0 x) d) (named t c).symm drawn),
      (consumed_still still (σ.new 0 c)).mpr
        (Eq.subst (motive := fun d => w.web.Consumed d) (σ.old_new 0 c).symm consumed)⟩⟩,
   fun t => ⟨fun ⟨before, after⟩ =>
      ⟨fun active => before (Eq.subst (motive := fun y => w.web.active t y) (first t x).symm active),
       Eq.subst (motive := fun y => w.web.active (t + 1) y) (first (t + 1) x) after⟩,
    fun ⟨before, after⟩ =>
      ⟨fun active => before (Eq.subst (motive := fun y => w.web.active t y) (first t x) active),
       Eq.subst (motive := fun y => w.web.active (t + 1) y) (first (t + 1) x).symm after⟩⟩⟩

end Still

/-- **Where standing after every step sets every relatum apart, identity across steps is a fact
of the unfolding**: under every naming keeping a balanced world balanced, each relatum renews,
consumes and arises exactly where the relatum it names at the first step does. -/
theorem classes_fixed (balanced : w.Balanced)
    (apart : ∀ t c d, w.web.level (t + 1) c = w.web.level (t + 1) d → c = d)
    {σ : Reidentify w.Relatum R'} (kept : (w.reidentify σ).Balanced) (x : R') :
    ((w.reidentify σ).web.RenewingIn x ↔ w.web.RenewingIn (σ.old 0 x)) ∧
    ((w.reidentify σ).web.ConsumingIn x ↔ w.web.ConsumingIn (σ.old 0 x)) ∧
    ∀ t, ((w.reidentify σ).web.Arises t x ↔ w.web.Arises t (σ.old 0 x)) :=
  classes_still (still_of_apart balanced apart kept) x

end World

/-! ## The two-kind reading as a world -/

/-- A re-identification of formations, read with one kind of relatum: each condition keeps its
name. -/
def Reidentify.roles (σ : Reidentify F F') : Reidentify (F ⊕ C) (F' ⊕ C) :=
  ⟨fun t x => match x with
    | .inl f => .inl (σ.old t f)
    | .inr c => .inr c,
   fun t x => match x with
    | .inl f => .inl (σ.new t f)
    | .inr c => .inr c,
   fun t x => match x with
    | .inl f => congrArg Sum.inl (σ.old_new t f)
    | .inr _ => rfl,
   fun t x => match x with
    | .inl f => congrArg Sum.inl (σ.new_old t f)
    | .inr _ => rfl⟩

namespace World

/-- **Formations that stand at nothing are not tied by conservation.** In the two-kind reading as
a world (`World.ofRoles`), every re-identification of formations keeps the world balanced exactly
where it balances: every naming of `Becoming.Identity` is within conservation. -/
theorem ofRoles_reidentify_balanced (L : Flow F C) (W : Web F C) (σ : Reidentify F F') :
    ((ofRoles L W).reidentify (σ.roles (C := C))).Balanced ↔ L.Balances W :=
  (balanced_reidentify_iff (w := ofRoles L W) _).trans
    ⟨fun conserves t c => (congrArg (W.level (t + 1) c + ·) (L.roles_taken t c)).symm.trans
        ((conserves t (.inr c)).trans (congrArg (W.level t c + ·) (L.roles_given t c))),
     fun balances t x => match x with
      | .inl f => (congrArg (0 + ·) (L.roles_taken_formation t f)).trans
          (congrArg (0 + ·) (L.roles_given_formation t f)).symm
      | .inr c => (congrArg (W.level (t + 1) c + ·) (L.roles_taken t c)).trans
          ((balances t c).trans (congrArg (W.level t c + ·) (L.roles_given t c)).symm)⟩

/-- Read so, a formation arises under the naming exactly where it does in the re-identified web, -/
theorem ofRoles_reidentify_arises (L : Flow F C) (W : Web F C) (σ : Reidentify F F') (t : Nat)
    (x : F') : ((ofRoles L W).reidentify (σ.roles (C := C))).web.Arises t (.inl x) ↔
      (W.reidentify σ).Arises t x :=
  Iff.rfl

theorem ofRoles_reidentify_unceasing (L : Flow F C) (W : Web F C) (σ : Reidentify F F') :
    ((ofRoles L W).reidentify (σ.roles (C := C))).web.Unceasing ↔ (W.reidentify σ).Unceasing :=
  ⟨fun unceasing N => match unceasing N with
    | ⟨t, .inl f, le, arises⟩ => ⟨t, f, le, arises⟩
    | ⟨_, .inr _, _, _, active⟩ => False.elim active,
   fun unceasing N => match unceasing N with
    | ⟨t, f, le, arises⟩ => ⟨t, .inl f, le, arises⟩⟩

theorem ofRoles_reidentify_renewed (L : Flow F C) (W : Web F C) (σ : Reidentify F F') (c : C) :
    ((ofRoles L W).reidentify (σ.roles (C := C))).web.Renewed (.inr c) ↔ W.Renewed c :=
  ⟨fun renewed t g depends => Eq.subst (motive := fun f => W.Kept t f c) (σ.old_new t g)
      (renewed t (.inl (σ.new t g))
        (Eq.subst (motive := fun f => W.requires t f c) (σ.old_new t g).symm depends)),
   fun renewed t y depends => match y, depends with
    | .inl f, depends => renewed t (σ.old t f) depends
    | .inr _, depends => nomatch depends⟩

theorem ofRoles_reidentify_renewed_formation (L : Flow F C) (W : Web F C) (σ : Reidentify F F')
    (f : F') : ((ofRoles L W).reidentify (σ.roles (C := C))).web.Renewed (.inl f) :=
  fun _ y depends => match y, depends with
  | .inl _, depends => nomatch depends
  | .inr _, depends => nomatch depends

theorem ofRoles_reidentify_consumed (L : Flow F C) (W : Web F C) (σ : Reidentify F F') (c : C) :
    ((ofRoles L W).reidentify (σ.roles (C := C))).web.Consumed (.inr c) ↔ W.Consumed c :=
  ⟨fun ⟨g, T, depends, below⟩ => match g, depends, below with
    | .inl f, depends, below => ⟨σ.old T f, T, depends, below⟩
    | .inr _, depends, _ => (nomatch depends),
   fun ⟨g, T, depends, below⟩ => ⟨.inl (σ.new T g), T,
      Eq.subst (motive := fun f => W.requires T f c) (σ.old_new T g).symm depends,
      fun t later => Eq.subst (motive := fun f => W.level t c < W.need T f c) (σ.old_new T g).symm
        (below t later)⟩⟩

/-- renews in the run exactly where it does there, -/
theorem ofRoles_reidentify_renewingIn (L : Flow F C) (W : Web F C) (σ : Reidentify F F') (x : F') :
    ((ofRoles L W).reidentify (σ.roles (C := C))).web.RenewingIn (.inl x) ↔
      (W.reidentify σ).RenewingIn x :=
  ⟨fun renewing t c joins => (W.reidentify_renewed σ c).mpr
      ((ofRoles_reidentify_renewed L W σ c).mp (renewing t (.inr c) joins)),
   fun renewing t y joins => match y, joins with
    | .inl f, _ => ofRoles_reidentify_renewed_formation L W σ f
    | .inr c, joins => (ofRoles_reidentify_renewed L W σ c).mpr
        ((W.reidentify_renewed σ c).mp (renewing t c joins))⟩

/-- and consumes exactly where it does there. -/
theorem ofRoles_reidentify_consumingIn (L : Flow F C) (W : Web F C) (σ : Reidentify F F')
    (x : F') : ((ofRoles L W).reidentify (σ.roles (C := C))).web.ConsumingIn (.inl x) ↔
      (W.reidentify σ).ConsumingIn x :=
  ⟨fun ⟨t, y, drawn, consumed⟩ => match y, drawn, consumed with
    | .inr c, drawn, consumed => ⟨t, c, drawn,
        (W.reidentify_consumed σ c).mpr ((ofRoles_reidentify_consumed L W σ c).mp consumed)⟩
    | .inl _, drawn, _ => (nomatch drawn),
   fun ⟨t, c, drawn, consumed⟩ => ⟨t, .inr c, drawn,
      (ofRoles_reidentify_consumed L W σ c).mpr ((W.reidentify_consumed σ c).mp consumed)⟩⟩

end World

/-! ## Witnesses for identity read off a world's relations -/

namespace Shuttle

/-- Only the holder stands. -/
theorem holder_only : ∀ t g, 0 < stands g t → g = holder t
  | 0, true, _ => rfl
  | 0, false, active => absurd active (Nat.lt_irrefl 0)
  | 1, true, active => absurd active (Nat.lt_irrefl 0)
  | 1, false, _ => rfl
  | t + 2, g, active => holder_only t g (Eq.subst (motive := fun n => 0 < n) (stands_two g t) active)

/-- The two sides named as one: their names exchanged at every odd step. -/
def asOne : Reidentify Bool Bool :=
  .exchanging odd (fun b => !b) fun b => match b with
    | true => rfl
    | false => rfl

/-- **Where relata stand as they are active and hand their standing on, conservation fixes
arising.** In the shuttle, across every step the side coming to hold the standing arises under
conservation: the side active before the step stands at nothing after it. So under every naming
keeping the world balanced a side arises at every step, and generation is unceasing under each.
Naming the two sides as one keeps the continuing activity of the apart naming (`KeepsActive`,
no side being active at two successive steps), and breaks the balance: the reading of
`Lineage` that Identity's one-way continuity allows is excluded here by conservation. -/
theorem conserved :
    (∀ t, World.shuttle.web.ArisesFrom World.shuttle.Conserves t (holder (t + 1))) ∧
    (∀ σ : Reidentify Bool Bool, (World.shuttle.reidentify σ).Balanced →
      (World.shuttle.reidentify σ).web.Unceasing) ∧
    asOne.KeepsActive World.shuttle.web ∧ ¬ (World.shuttle.reidentify asOne).Balanced :=
  have arising : ∀ t, World.shuttle.web.ArisesFrom World.shuttle.Conserves t (holder (t + 1)) :=
    fun t => ⟨holder_stands (t + 1), fun ⟨g, active, conserves⟩ =>
      Nat.lt_irrefl 0 (Eq.subst (motive := fun n => 0 < n)
        (((World.conserves_iff (w := World.shuttle) balances).mp conserves).trans
          ((congrArg (fun x => stands x (t + 1)) (holder_only t g active)).trans (next_off t)))
        (holder_stands (t + 1)))⟩
  ⟨arising,
   fun σ kept N => ⟨N, σ.new (N + 1) (holder (N + 1)), Nat.le_refl N,
     (World.arises_fixed_iff (w := World.shuttle) (dec := instDecidableEqBool) balances N
       (holder (N + 1))).mpr (arising N) σ kept⟩,
   fun t f now next => absurd next (fun after => Nat.lt_irrefl 0 (Eq.subst (motive := fun n => 0 < n)
     ((congrArg (fun x => stands x (t + 1)) (holder_only t f now)).trans (next_off t)) after)),
   fun kept => Nat.lt_irrefl 0 (Eq.subst (motive := fun n => 0 < n)
     ((World.conserves_iff (w := World.shuttle) balances).mp
       ((World.balanced_reidentify_iff (w := World.shuttle) asOne).mp kept 0 true)) Nat.zero_lt_one)⟩

/-- The standing alternates: one at one step, zero at the next, or the reverse. -/
theorem alternates : ∀ t, (even t = 1 ∧ even (t + 1) = 0) ∨ (even t = 0 ∧ even (t + 1) = 1)
  | 0 => .inl ⟨rfl, rfl⟩
  | 1 => .inr ⟨rfl, rfl⟩
  | t + 2 => alternates t

/-- After every step the two sides stand apart. -/
theorem apart : ∀ t c d, stands c (t + 1) = stands d (t + 1) → c = d
  | _, true, true, _ => rfl
  | _, false, false, _ => rfl
  | t, true, false, same => match alternates t with
    | .inl ⟨was, now⟩ => absurd (now.symm.trans (same.trans was)).symm
        fun one => Nat.lt_irrefl 0 (Eq.subst (motive := fun n => 0 < n) one Nat.zero_lt_one)
    | .inr ⟨was, now⟩ => absurd (now.symm.trans (same.trans was))
        fun one => Nat.lt_irrefl 0 (Eq.subst (motive := fun n => 0 < n) one Nat.zero_lt_one)
  | t, false, true, same => match alternates t with
    | .inl ⟨was, now⟩ => absurd (now.symm.trans (same.symm.trans was)).symm
        fun one => Nat.lt_irrefl 0 (Eq.subst (motive := fun n => 0 < n) one Nat.zero_lt_one)
    | .inr ⟨was, now⟩ => absurd (now.symm.trans (same.symm.trans was))
        fun one => Nat.lt_irrefl 0 (Eq.subst (motive := fun n => 0 < n) one Nat.zero_lt_one)

/-- **And conservation fixes the shuttle's identity across steps entirely.** The two sides stand
apart after every step, so every naming keeping the shuttle balanced names each side at every
step as at the first, and under it each side arises exactly where the side it names does
(`World.classes_fixed`): conservation leaves no naming but renamings. -/
theorem named_as_themselves {σ : Reidentify Bool Bool} (kept : (World.shuttle.reidentify σ).Balanced) :
    (∀ t x, σ.old t x = σ.old 0 x) ∧
    ∀ x t, ((World.shuttle.reidentify σ).web.Arises t x ↔ World.shuttle.web.Arises t (σ.old 0 x)) :=
  ⟨Reidentify.old_still (World.still_of_apart (w := World.shuttle) balances apart kept),
   fun x => (World.classes_fixed (w := World.shuttle) balances apart kept x).2.2⟩

end Shuttle

/-- **Where formations stand at nothing, conservation fixes none of them.** `Lineage` read as a
world, its two members standing at nothing (`World.ofRoles`), balances, and so does its reading
with the lineage named as one: both fit every relation of the world, conservation included.
Arising recurs under the first and nothing arises under the second, and no arising there is an
arising under conservation (`World.arises_fixed_iff`). -/
theorem Lineage.world_readings :
    (World.ofRoles Flow.still Lineage.web).Balanced ∧
    ((World.ofRoles Flow.still Lineage.web).reidentify (Lineage.one.roles (C := Unit))).Balanced ∧
    (World.ofRoles Flow.still Lineage.web).web.Unceasing ∧
    (∀ t x, ¬ ((World.ofRoles Flow.still Lineage.web).reidentify
      (Lineage.one.roles (C := Unit))).web.Arises t x) ∧
    ∀ t x, ¬ (World.ofRoles Flow.still Lineage.web).web.ArisesFrom
      (World.ofRoles Flow.still Lineage.web).Conserves t x :=
  have always : ∀ t, (Lineage.web.reidentify Lineage.one).active t .first := fun t =>
    show Lineage.web.active t (turn Lineage.swap (odd t) .first) from match h : odd t with
      | true => h
      | false => h
  have never : ∀ t, ¬ (Lineage.web.reidentify Lineage.one).active t .second := fun t =>
    show Lineage.web.active t (turn Lineage.swap (odd t) .second) → False from match h : odd t with
      | true => fun first => nomatch h.symm.trans first
      | false => fun second => nomatch h.symm.trans second
  ⟨(Flow.roles_balances Flow.still).mpr fun _ _ => rfl,
   (World.ofRoles_reidentify_balanced Flow.still Lineage.web Lineage.one).mpr fun _ _ => rfl,
   (Lineage.web.roles_unceasing).mpr Lineage.readings.2.1,
   fun t x arises => match x, arises with
    | .inl .first, arises => arises.1 (always t)
    | .inl .second, arises => never (t + 1) arises.2
    | .inr _, arises => arises.2,
   fun t x arisesFrom => match x, arisesFrom with
    | .inr _, arisesFrom => arisesFrom.1
    | .inl _, ⟨_, alone⟩ => match h : odd t with
      | true => alone ⟨.inl .second, h, rfl⟩
      | false => alone ⟨.inl .first, h, rfl⟩⟩

/-- **In `Hibernation`, identity across the dormancy is a reading, not a fact of the
unfolding.** Read as a world, its formations standing at nothing, it balances, and so does its
reading with the hibernator and the forager exchanged from the third step on: the exchange fits
every relation of the world, conservation included, and keeps Identity's continuity of activity
and of dependence both ways (`Hibernation.readings`). Under it the formation named the hibernator
consumes and does not renew; the hibernator renews. Only keeping the names of what holds
excludes the exchange. -/
theorem Hibernation.world_readings :
    (World.ofRoles Flow.still Hibernation.web).Balanced ∧
    ((World.ofRoles Flow.still Hibernation.web).reidentify
      (Hibernation.exchange.roles (C := Hibernation.Condition))).Balanced ∧
    (World.ofRoles Flow.still Hibernation.web).web.RenewingIn (.inl .hibernator) ∧
    ((World.ofRoles Flow.still Hibernation.web).reidentify
      (Hibernation.exchange.roles (C := Hibernation.Condition))).web.ConsumingIn (.inl .hibernator) ∧
    ¬ ((World.ofRoles Flow.still Hibernation.web).reidentify
      (Hibernation.exchange.roles (C := Hibernation.Condition))).web.RenewingIn (.inl .hibernator) :=
  ⟨(Flow.roles_balances Flow.still).mpr fun _ _ => rfl,
   (World.ofRoles_reidentify_balanced Flow.still Hibernation.web Hibernation.exchange).mpr
     fun _ _ => rfl,
   (Hibernation.web.roles_renewingIn .hibernator).mpr Hibernation.renewing,
   (World.ofRoles_reidentify_consumingIn Flow.still Hibernation.web Hibernation.exchange
     .hibernator).mpr Hibernation.exchanged_consuming,
   fun renewing => Hibernation.exchanged_not_renewing
     ((World.ofRoles_reidentify_renewingIn Flow.still Hibernation.web Hibernation.exchange
       .hibernator).mp renewing)⟩


/-! ## The grammar's reading: holding as a coarser class than activity

`Becoming.Grammar` states continuation (续) for every carrier and every relation. Here, as in
`Becoming.Identity`'s reading, the carrier is the occurrences of formations, pairs `(t, f)`, and
缘 is one step of a continuation (`Web.continuationStep`); for persistence the continuation is the
names, each formation continuing as itself (`fun _ g f => g = f`). What `Web.persisting h` changes
is not 缘 but the class: read through what holds, the class is alike in holding
(`(W.persisting h).activityClass`); read through activity alongside what holds, it is alike in
activity and in holding (`Web.stateClass W h`: active, dormant or absent), which is finer. So which
relation holds a formation through dormancy, the choice of `h`, is a choice of class, and arising
and ceasing read through it are beginning (生) and ending (亡) under that class
(`Web.arises_iff_sheng_itself` and `Web.ceases_iff_wang_itself` of `Becoming.Identity`, applied to
`W.persisting h`).

* Where activity lies within holding, arising and ceasing in activity are beginning and ending
  under the state class (`Web.arises_iff_sheng_state`, `Web.ceases_iff_wang_state`).
* **Falling dormant is not ceasing; waking is not arising.** A formation falling dormant ends under
  the state class and continues under holding: the step is an alteration (异)
  (`Web.fallsDormant_alters`); waking, the converse (`Web.wakes_alters`). This is the shape of
  `«亡于细者不必亡于粗»`, realized by the hibernator (`Hibernation.positions`): at its dormant
  step it abides (住) under holding and both begins and ends under the state class, positions
  relative to a class.
* **Derived from grammar laws.** The halves of `Web.ceases_persisting_iff` and
  `Web.arises_persisting_iff` that go from holding to activity follow from `«亡于粗则亡于细»` and
  its dual `«生于粗则生于细»` (`Web.ceases_of_persisting_ceases`, `Web.arises_of_persisting_arises`).
* **Holding at every step is a line without end (不穷)** under holding (`Web.unending_of_holds`).
  Which `h` holds is a choice of class (`Seed.held_classes`): the spent seed's line never ends
  under holding by dependence and ends at the fourth step under holding by its reserve.
* **Conservation.** In a balanced world with decidable equality of relata, a formation arises
  under every naming keeping it balanced exactly where its occurrence begins under the 缘 that
  conservation induces, in the class of activity (`World.arises_fixed_iff_sheng`), and ceases so
  exactly where it ends there (`World.ceases_fixed_iff_wang`).

Not connected: the laws of re-identification (`Web.steady_held`, `Web.renewingIn_held` and the
classes fixed under conservation) concern namings of the carrier, which the grammar takes as a
model commitment (equality on the carrier); the census laws (`Web.persisting_census`) count lists,
which the grammar does not state.
-/

namespace Web

variable (W : Web F C)

/-- The state class: alike in activity and alike in holding, read through `h` (active, dormant or
absent where activity lies within holding). -/
def stateClass (h : Nat → F → Prop) : «际» (Nat × F) :=
  «合» W.activityClass (W.persisting h).activityClass

theorem stateClass_class (h : Nat → F → Prop) : «类» (W.stateClass h) :=
  ⟨fun _ => ⟨Iff.rfl, Iff.rfl⟩, fun same => ⟨same.1.symm, same.2.symm⟩,
   fun same same' => ⟨same.1.trans same'.1, same.2.trans same'.2⟩⟩

/-- The state class is finer than holding. -/
theorem stateClass_finer (h : Nat → F → Prop) :
    «则» (W.stateClass h) (W.persisting h).activityClass :=
  fun _ _ same => same.2

variable {W} {h : Nat → F → Prop}

/-- Where activity changes across the step from `t`, the occurrence before it ends (亡) under the
state class. -/
theorem wang_state_of_change {t : Nat} {f : F} (change : ¬ (W.active t f ↔ W.active (t + 1) f)) :
    «亡» (continuationStep fun _ g f => g = f) (W.stateClass h) (t, f) :=
  fun ⟨y, ⟨next, same⟩, ⟨alike, _⟩⟩ => change
    (Eq.subst (motive := fun s => W.active t f ↔ W.active s f) next
      (Eq.subst (motive := fun g => W.active t f ↔ W.active y.1 g) same.symm alike))

/-- and the occurrence after it begins (生) under the state class. -/
theorem sheng_state_of_change {t : Nat} {f : F} (change : ¬ (W.active t f ↔ W.active (t + 1) f)) :
    «生» (continuationStep fun _ g f => g = f) (W.stateClass h) (t + 1, f) :=
  fun ⟨x, ⟨next, same⟩, ⟨alike, _⟩⟩ => change
    (Eq.subst (motive := fun s => W.active s f ↔ W.active (t + 1) f) (Nat.succ.inj next).symm
      (Eq.subst (motive := fun g => W.active x.1 g ↔ W.active (t + 1) f) same alike))

/-- **Ceasing in activity is ending (亡) under the state class**, where activity lies within
holding. -/
theorem ceases_iff_wang_state (within : ∀ t f, W.active t f → h t f) {t : Nat} {f : F} :
    W.Ceases t f ↔ W.active t f ∧
      «亡» (continuationStep fun _ g f => g = f) (W.stateClass h) (t, f) :=
  ⟨fun ⟨before, gone⟩ => ⟨before, wang_state_of_change fun alike => gone (alike.mp before)⟩,
   fun ⟨before, ends⟩ => ⟨before, fun after => ends ⟨(t + 1, f), ⟨rfl, rfl⟩,
     ⟨⟨fun _ => after, fun _ => before⟩, ⟨fun _ => within _ _ after, fun _ => within _ _ before⟩⟩⟩⟩⟩

/-- **Arising in activity is beginning (生) under the state class**, where activity lies within
holding. -/
theorem arises_iff_sheng_state (within : ∀ t f, W.active t f → h t f) {t : Nat} {f : F} :
    W.Arises t f ↔ W.active (t + 1) f ∧
      «生» (continuationStep fun _ g f => g = f) (W.stateClass h) (t + 1, f) :=
  ⟨fun ⟨before, after⟩ => ⟨after, sheng_state_of_change fun alike => before (alike.mpr after)⟩,
   fun ⟨after, begins⟩ => ⟨fun before => begins ⟨(t, f), ⟨rfl, rfl⟩,
     ⟨⟨fun _ => after, fun _ => before⟩, ⟨fun _ => within _ _ after, fun _ => within _ _ before⟩⟩⟩,
    after⟩⟩

/-- **Derived from `«亡于粗则亡于细»`.** A formation active before a step that ceases to hold across
it ceases in activity: ending under holding is ending under the finer state class. (The forward
half of `Web.ceases_persisting_iff`.) -/
theorem ceases_of_persisting_ceases (within : ∀ t f, W.active t f → h t f) {t : Nat} {f : F}
    (ceases : (W.persisting h).Ceases t f) (before : W.active t f) : W.Ceases t f :=
  (ceases_iff_wang_state within).mpr ⟨before,
    «亡于粗则亡于细» _ (W.stateClass_finer h) (ceases_iff_wang_itself.mp ceases).2⟩

/-- **Derived from `«生于粗则生于细»`.** A formation coming to hold across a step, active after it,
arises in activity. (The forward half of the first part of `Web.arises_persisting_iff`.) -/
theorem arises_of_persisting_arises (within : ∀ t f, W.active t f → h t f) {t : Nat} {f : F}
    (arises : (W.persisting h).Arises t f) (after : W.active (t + 1) f) : W.Arises t f :=
  (arises_iff_sheng_state within).mpr ⟨after,
    «生于粗则生于细» _ (W.stateClass_finer h) (arises_iff_sheng_itself.mp arises).2⟩

/-- **Falling dormant is an alteration (异), not an ending.** A formation active before a step,
inactive and holding after it, ends under the state class and continues under holding: the
shape of `«亡于细者不必亡于粗»`. -/
theorem fallsDormant_alters (within : ∀ t f, W.active t f → h t f) {t : Nat} {f : F}
    (before : W.active t f) (dormant : ¬ W.active (t + 1) f) (held : h (t + 1) f) :
    «亡» (continuationStep fun _ g f => g = f) (W.stateClass h) (t, f) ∧
    «异» (continuationStep fun _ g f => g = f) (W.persisting h).activityClass (W.stateClass h)
      (t, f) (t + 1, f) :=
  ⟨wang_state_of_change fun alike => dormant (alike.mp before),
   ⟨⟨⟨rfl, rfl⟩, ⟨fun _ => held, fun _ => within _ _ before⟩⟩,
    fun ⟨alike, _⟩ => dormant (alike.mp before)⟩⟩

/-- **Waking is an alteration (异), not a beginning.** A formation holding and inactive before a
step, active after it, begins under the state class and continues under holding. -/
theorem wakes_alters (within : ∀ t f, W.active t f → h t f) {t : Nat} {f : F}
    (held : h t f) (dormant : ¬ W.active t f) (after : W.active (t + 1) f) :
    «生» (continuationStep fun _ g f => g = f) (W.stateClass h) (t + 1, f) ∧
    «异» (continuationStep fun _ g f => g = f) (W.persisting h).activityClass (W.stateClass h)
      (t, f) (t + 1, f) :=
  ⟨sheng_state_of_change fun alike => dormant (alike.mpr after),
   ⟨⟨⟨rfl, rfl⟩, ⟨fun _ => within _ _ after, fun _ => held⟩⟩,
    fun ⟨alike, _⟩ => dormant (alike.mpr after)⟩⟩

/-- A line along the names stays with one formation. -/
theorem names_line_same {E : «际» (Nat × F)} {x y : Nat × F}
    (line : «相续» (continuationStep fun _ g f => g = f) E x y) : x.2 = y.2 := by
  induction line with
  | one c => exact c.1.2
  | more c _ ih => exact c.1.2.trans ih

/-- **Holding at every step is a line without end (不穷)** under holding. -/
theorem unending_of_holds {f : F} (always : ∀ s, h s f) (t : Nat) :
    «不穷» (continuationStep fun _ g f => g = f) (W.persisting h).activityClass (t, f) :=
  fun y reached =>
    have same : y.2 = f := match reached with
      | .inl at_ => (congrArg Prod.snd at_).symm
      | .inr line => (names_line_same line).symm
    ⟨(y.1 + 1, y.2), ⟨rfl, rfl⟩,
     ⟨fun _ => Eq.subst (motive := fun g => h (y.1 + 1) g) same.symm (always (y.1 + 1)),
      fun _ => Eq.subst (motive := fun g => h y.1 g) same.symm (always y.1)⟩⟩

end Web

namespace World

variable {w : World}

/-- **An arising fixed by conservation is a beginning (生)** under the 缘 conservation induces, in
the class of activity: `World.arises_fixed_iff` read through `Web.arisesFrom_iff_sheng`. -/
theorem arises_fixed_iff_sheng [dec : DecidableEq w.Relatum] (balanced : w.Balanced) (t : Nat)
    (f : w.Relatum) :
    (∀ σ : Reidentify w.Relatum w.Relatum, (w.reidentify σ).Balanced →
      (w.reidentify σ).web.Arises t (σ.new (t + 1) f)) ↔
      w.web.active (t + 1) f ∧ «生» (Web.continuationStep w.Conserves) w.web.activityClass (t + 1, f) :=
  (arises_fixed_iff balanced t f).trans Web.arisesFrom_iff_sheng

/-- **A ceasing fixed by conservation is an ending (亡)** under the 缘 conservation induces. -/
theorem ceases_fixed_iff_wang [dec : DecidableEq w.Relatum] (balanced : w.Balanced) (t : Nat)
    (g : w.Relatum) :
    (∀ σ : Reidentify w.Relatum w.Relatum, (w.reidentify σ).Balanced →
      (w.reidentify σ).web.Ceases t (σ.new t g)) ↔
      w.web.active t g ∧ «亡» (Web.continuationStep w.Conserves) w.web.activityClass (t, g) :=
  (ceases_fixed_iff balanced t g).trans Web.ceasesFrom_iff_wang

end World

namespace Hibernation

/-- **Positions of the hibernator relative to a class.** The state class is finer than holding.
Before its dormancy the hibernator's occurrence ends under the state class and not under holding
(`«亡于细者不必亡于粗»`); at its dormant step it abides (住) under holding while it both begins and
ends under the state class; and under holding its line from the first step never ends (不穷). -/
theorem positions :
    «则» (web.stateClass web.Holds) (web.persisting web.Holds).activityClass ∧
    «亡» (Web.continuationStep fun _ g f => g = f) (web.stateClass web.Holds) (0, .hibernator) ∧
    ¬ «亡» (Web.continuationStep fun _ g f => g = f) (web.persisting web.Holds).activityClass
      (0, .hibernator) ∧
    «住» (Web.continuationStep fun _ g f => g = f) (web.persisting web.Holds).activityClass
      (1, .hibernator) ∧
    «生» (Web.continuationStep fun _ g f => g = f) (web.stateClass web.Holds) (1, .hibernator) ∧
    «亡» (Web.continuationStep fun _ g f => g = f) (web.stateClass web.Holds) (1, .hibernator) ∧
    «不穷» (Web.continuationStep fun _ g f => g = f) (web.persisting web.Holds).activityClass
      (0, .hibernator) :=
  have within : ∀ t f, web.active t f → web.Holds t f := fun _ _ active => .inl active
  have falls := Web.fallsDormant_alters within (t := 0) (f := .hibernator) trivial id
    (holds_always 1)
  ⟨web.stateClass_finer web.Holds, falls.1, fun ends => ends ⟨_, falls.2.1⟩,
   ⟨⟨(0, .hibernator), ⟨rfl, rfl⟩, ⟨fun _ => holds_always 1, fun _ => holds_always 0⟩⟩,
    ⟨(2, .hibernator), ⟨rfl, rfl⟩, ⟨fun _ => holds_always 2, fun _ => holds_always 1⟩⟩⟩,
   Web.sheng_state_of_change (t := 0) fun alike => alike.mp trivial,
   Web.wang_state_of_change (t := 1) fun alike => alike.mpr trivial,
   Web.unending_of_holds holds_always 0⟩

end Hibernation

/-- **Which relation holds a formation is a choice of class.** Along the same 缘 (the seed's
name), the spent seed's line never ends (不穷) under holding by dependence, and it ends (亡) at the
fourth step under holding by its reserve (`Seed.held_readings`). -/
theorem Seed.held_classes :
    (∀ t, «不穷» (Web.continuationStep fun _ g f => g = f)
      (Seed.web.persisting Seed.web.Holds).activityClass (t, ())) ∧
    «亡» (Web.continuationStep fun _ g f => g = f)
      (Seed.web.persisting fun t f => Seed.web.active t f ∨ 0 < Seed.reserve t).activityClass
      (3, ()) :=
  ⟨Web.unending_of_holds Seed.held_readings.2.2.1,
   (Web.ceases_iff_wang_itself.mp Seed.held_readings.2.2.2.2.2).2⟩

end Becoming
