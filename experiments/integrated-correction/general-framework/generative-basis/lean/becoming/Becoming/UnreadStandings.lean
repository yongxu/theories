import Becoming.WorldRepresentation

/-!
# Standings the occurrence model leaves free: the unit, and in still worlds more

`Becoming.WorldRepresentation` reads a World on the grammar through its occurrence model: the
occurrences `Nat × w.Relatum`, the names' step, and the ten relations the model selects (the
same-step class, conservation's step, activity, standing and presence as partial identities, and
requiring, drawing, a need met, giving and taking within a step). There F1
(`World.standingAt_alike`) gives one family of still worlds on one relatum whose standings differ
while every selected field agrees, and F1′ (`World.balance_needs_conservation`) shows that no
property of the web and the signs of exchange is balance. This module states two freedoms the model
leaves in the standings: the unit, in every world, and, in still worlds, every relabelling that
keeps sign and order. It does not say what the model fixes in worlds with exchange.

The ten relations are a stated selection (`Becoming.WorldRepresentation`'s module doc, and the
hypotheses of the record `the-world-represented-both-ways`): a re-identification also carries a
standing's value, a selection that read it would read the count, and one that read the difference of
two standings would in general not agree at a finer unit. Every relation here reads amounts only
through sign, through the comparison of two amounts counted in one unit (a need against a standing;
and, in the two relations this module adds, falling and the order of standings), and through
conservation's equation, which is homogeneous and linear. The results below hold because of that.
They are results about this selection, with falling and the order of standings added, not about
every relation a World carries.

* **A finer unit.** For `0 < k`, `World.atFinerUnit k w` counts every amount of `w` (every
  standing, need, take and give) in a unit `k` times finer (at `k = 0` every amount is 0, which is
  no unit, and at `k = 1` it is `w`), and keeps every relatum, name, activity, requirement, drawing
  and presence list. Its standings are `k` times `w`'s (`atFinerUnit_level`), and what is taken and
  given are `k` times `w`'s (`atFinerUnit_taken`, `atFinerUnit_given`, through `total_mul`).
* **The relations of the model are the same at a finer unit, in every world.** For `0 < k`,
  conservation across a step is the same relation (`atFinerUnit_conserves`), so its step on
  occurrences is too. The nine selected relations other than the same-step class, together with
  falling and the order of standings across occurrences (`standingOrder`, a relation a
  re-identification also carries and the selection leaves out), agree pointwise, as relations on the
  same occurrences (`atFinerUnit_agree`, gathered as `World.ModelRelations`). The names' step and
  the same-step class are the same terms, the carrier being the same. Through the identity
  correspondence (`identityOnOccurrences`) each relation is carried in `Becoming.GrammarTransport`'s
  sense (`atFinerUnit_carried`), so each keeping theorem of that module applies; three are stated as
  the pattern (`atFinerUnit_family`, `atFinerUnit_begins`, `atFinerUnit_ends`). No single statement
  here says that every term `Becoming.GrammarTransport` keeps reads alike.
* **No reading of the model gives the count.** For every world, every `k` with `0 < k` and `k ≠ 1`,
  and every occurrence of positive standing, no reading `Ψ` of `World.ModelRelations` that keeps to
  pointwise agreement returns the standing in both `w` and `w.atFinerUnit k` (`standing_not_read`).
  F1 shows the same for one family of still worlds on one relatum; this holds at every occurrence of
  positive standing of every world.
* **The unit is one freedom among others.** In a still world (`stillAt`: nothing takes part, nothing
  requires, needs or draws, nothing is active; F1's worlds are such, `standingAt_eq_stillAt`), every
  relabelling `σ` of the standings that keeps their sign (`0 < σ a ↔ 0 < a`) and their order
  (`σ a ≤ σ b ↔ a ≤ b`) keeps every model relation (`stillAt_relabel_agree`); squaring is one
  (`stillAt_squared_agree`). The worlds on two relata with standings 1 and 2 and with standings 1
  and 4 agree on every model relation while their standings are not one common factor apart
  (`oneTwo_not_scaled`). So no single reading of the model returns the standings of every world even
  up to a unit, that is, with positive whole factors `p` and `q`, chosen world by world, such that
  `q` times every standing is `p` times what is read; this covers a reading in a finer unit and one
  in a coarser unit (`standing_not_read_up_to_unit`). The worlds that refute it are still worlds on
  two relata; a reading that returns the standings up to a unit on every world with exchange, or on
  any class without these two worlds, is not ruled out. The freedom the model leaves is more than
  the unit. Whether conservation's equation, in worlds with exchange, fixes standings up to a unit,
  or to what else, is not stated here.
* **Balance does not need the unit.** A world at a finer unit balances exactly where it does
  (`atFinerUnit_balanced_iff`). So one thing the model leaves free, the unit, is not what balance
  reads; what it reads beyond the web and the signs of exchange is conservation (F1′), which is
  defined from the balance equation.

**What this covers, and what it does not.** Every reading here is a reading of this occurrence model
with its selection: the relations of `World.ModelRelations`, the names' step and the same-step
class, and the grammar terms `Becoming.GrammarTransport`'s keeping theorems build from them, each
applied through `atFinerUnit_carried`. Not covered is any relation that reads a value or a
difference of amounts, such as the partial identity "standing is `n`", which every re-identification
carries, or "`x` stands one more than `y`" within a step. Such a relation in general does not agree
at a finer unit (at `k ≠ 1`, "standing is `n`" fails at an occurrence standing at `n` with `0 < n`,
and "one more than" at two standings one apart), so `atFinerUnit_agree` fails for a selection that
adds it, and the relations "standing is `n`", for every `n`, read the count exactly (neither is
stated as a theorem here). The results are about this selection of this model, not about the grammar
root, every relation a World carries, or another model of it. A unit that changes from step to step
is `Becoming.Resolution`'s, not this module's. Nothing here gives a root in which unit occurrences
and their residence are fixed by relations independent of the counts, nor a law about World data
that the counts do not give: on a carrier whose occurrences are the units, counts are lengths of
supplied lists, and U1 found balance there to be a bijection of supplied units.

**Modelling choices.** Natural-number amounts; one common factor `k` for every amount of a world at
every step; discrete steps; the occurrence model and its selection as `Becoming.WorldRepresentation`
fixes them; for the relabelling, still worlds only.

The arithmetic lemmas the World's laws use are in the namespace `Becoming.UnreadStandings`: a
positive factor keeps sign, order and an equation of two sums; a map keeping order keeps equality
and strict order; squaring keeps sign and order; `k * p = 1` forces `k = 1`; and `Nat.mul_assoc` and
`Nat.mul_left_comm` are proved again here, since `Init`'s report `propext`. Every declaration has
an empty axiom report.
-/

namespace Becoming

namespace UnreadStandings

/-- A positive factor keeps an amount's sign. -/
theorem pos_scaled {k : Nat} (pos : 0 < k) : ∀ a : Nat, 0 < k * a ↔ 0 < a
  | 0 => ⟨fun h =>
        absurd (Eq.subst (motive := fun n => 0 < n) (Nat.mul_zero k) h) (Nat.lt_irrefl 0),
      fun h => absurd h (Nat.lt_irrefl 0)⟩
  | n + 1 => ⟨fun _ => Nat.zero_lt_succ n, fun _ => Nat.mul_pos pos (Nat.zero_lt_succ n)⟩

/-- A positive factor keeps the order of two amounts. -/
theorem le_scaled {k : Nat} (pos : 0 < k) (a b : Nat) : k * a ≤ k * b ↔ a ≤ b :=
  ⟨fun le => Nat.le_of_mul_le_mul_left le pos, Nat.mul_le_mul_left k⟩

/-- A positive factor keeps strict order. -/
theorem lt_scaled {k : Nat} (pos : 0 < k) (a b : Nat) : k * a < k * b ↔ a < b :=
  ⟨fun lt => match Nat.lt_or_ge a b with
    | .inl ab => ab
    | .inr ba => absurd (Nat.lt_of_lt_of_le lt (Nat.mul_le_mul_left k ba)) (Nat.lt_irrefl _),
   fun ab => Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right pos) (Nat.mul_le_mul_left k ab)⟩

/-- A positive factor keeps an equation of two sums. -/
theorem sum_eq_scaled {k : Nat} (pos : 0 < k) (a b c d : Nat) :
    k * a + k * b = k * c + k * d ↔ a + b = c + d :=
  ⟨fun same => Nat.eq_of_mul_eq_mul_left pos
      ((Nat.left_distrib k a b).trans (same.trans (Nat.left_distrib k c d).symm)),
   fun same => (Nat.left_distrib k a b).symm.trans
      ((congrArg (k * ·) same).trans (Nat.left_distrib k c d))⟩

/-- A map of amounts that keeps order keeps equality. -/
theorem eq_relabelled {σ : Nat → Nat} (order : ∀ a b, σ a ≤ σ b ↔ a ≤ b) (a b : Nat) :
    σ a = σ b ↔ a = b :=
  ⟨fun same => Nat.le_antisymm ((order a b).mp (Nat.le_of_eq same))
      ((order b a).mp (Nat.le_of_eq same.symm)),
   congrArg σ⟩

/-- A map of amounts that keeps order keeps strict order. -/
theorem lt_relabelled {σ : Nat → Nat} (order : ∀ a b, σ a ≤ σ b ↔ a ≤ b) (a b : Nat) :
    σ a < σ b ↔ a < b :=
  ⟨fun lt => match Nat.lt_or_ge a b with
    | .inl ab => ab
    | .inr ba => absurd (Nat.lt_of_lt_of_le lt ((order b a).mpr ba)) (Nat.lt_irrefl _),
   fun ab => match Nat.lt_or_ge (σ a) (σ b) with
    | .inl lt => lt
    | .inr ba => absurd (Nat.lt_of_lt_of_le ab ((order b a).mp ba)) (Nat.lt_irrefl _)⟩

/-- Squaring keeps an amount's sign. -/
theorem pos_squared : ∀ a : Nat, 0 < a * a ↔ 0 < a
  | 0 => ⟨fun h => absurd h (Nat.lt_irrefl 0), fun h => absurd h (Nat.lt_irrefl 0)⟩
  | n + 1 => ⟨fun _ => Nat.zero_lt_succ n,
      fun _ => Nat.mul_pos (Nat.zero_lt_succ n) (Nat.zero_lt_succ n)⟩

/-- Squaring keeps the order of two amounts. -/
theorem le_squared (a b : Nat) : a * a ≤ b * b ↔ a ≤ b :=
  ⟨fun le => match Nat.lt_or_ge b a with
    | .inl ba =>
      have apos : 0 < a := Nat.lt_of_le_of_lt (Nat.zero_le b) ba
      absurd (Nat.lt_of_le_of_lt (Nat.mul_le_mul_right b (Nat.le_of_lt ba))
          ((lt_scaled apos b a).mpr ba))
        (Nat.not_lt_of_le le)
    | .inr ab => ab,
   fun ab => Nat.mul_le_mul ab ab⟩

/-- Where `k * p` is one, `k` is one. -/
theorem factor_of_one : ∀ {k p : Nat}, 1 = k * p → k = 1
  | 0, p, one => absurd (one.trans (Nat.zero_mul p)) (fun h => Nat.noConfusion h)
  | _ + 1, 0, one => absurd one (fun h => Nat.noConfusion h)
  | k + 1, p + 1, one =>
    Nat.le_antisymm
      (Eq.subst (motive := fun n => k + 1 ≤ n) (one.symm : (k + 1) * p + (k + 1) = 1)
        (Nat.le_add_left (k + 1) ((k + 1) * p)))
      (Nat.succ_le_succ (Nat.zero_le k))

end UnreadStandings

namespace World

open UnreadStandings

/-- **A world counted in a unit `k` times finer**: every standing, need, take and give is `k` times
`w`'s; the relata, activity, requirements, drawing and presence lists are `w`'s. For `0 < k` this is
the world counted in a unit `k` times finer; at `k = 0` every amount is 0, which is no unit, and at
`k = 1` it is `w` counted again. -/
def atFinerUnit (k : Nat) (w : World) : World :=
  World.of w.Relatum
    ⟨w.flow.present, fun t f c => k * w.flow.take t f c, fun t f c => k * w.flow.give t f c⟩
    ⟨fun t c => k * w.web.level t c, w.web.active, w.web.requires,
      fun t f c => k * w.web.need t f c, w.web.draws⟩

variable {w : World} {k : Nat}

theorem atFinerUnit_level (t : Nat) (x : w.Relatum) :
    (w.atFinerUnit k).web.level t x = k * w.web.level t x :=
  rfl

theorem atFinerUnit_taken (t : Nat) (c : w.Relatum) :
    (w.atFinerUnit k).flow.taken t c = k * w.flow.taken t c :=
  total_mul k (fun f => w.flow.take t f c) (w.flow.present t)

theorem atFinerUnit_given (t : Nat) (c : w.Relatum) :
    (w.atFinerUnit k).flow.given t c = k * w.flow.given t c :=
  total_mul k (fun f => w.flow.give t f c) (w.flow.present t)

/-- **Conservation does not read the unit.** At a positive factor, `f` continues `g` by conservation
across a step in the finer unit exactly where it does in `w`. -/
theorem atFinerUnit_conserves (pos : 0 < k) (t : Nat) (g f : w.Relatum) :
    (w.atFinerUnit k).Conserves t g f ↔ w.Conserves t g f :=
  have taken := atFinerUnit_taken (w := w) (k := k) t g
  have given := atFinerUnit_given (w := w) (k := k) t g
  ⟨fun c => (sum_eq_scaled pos _ _ _ _).mp
      ((congrArg (k * w.web.level (t + 1) f + ·) taken).symm.trans
        (c.trans (congrArg (k * w.web.level t g + ·) given))),
   fun c => (congrArg (k * w.web.level (t + 1) f + ·) taken).trans
      (((sum_eq_scaled pos _ _ _ _).mpr c).trans (congrArg (k * w.web.level t g + ·) given).symm)⟩

/-- **Balance does not read the unit.** At a positive factor, a world counted in a finer unit
balances exactly where `w` does. -/
theorem atFinerUnit_balanced_iff (pos : 0 < k) : (w.atFinerUnit k).Balanced ↔ w.Balanced :=
  ⟨fun b t c => (atFinerUnit_conserves (w := w) pos t c c).mp (b t c),
   fun b t c => (atFinerUnit_conserves (w := w) pos t c c).mpr (b t c)⟩

/-- The order of standings across occurrences: `x` stands at most as `y` does. -/
def standingOrder (w : World) : «际» (Nat × w.Relatum) :=
  fun x y => w.web.level x.1 x.2 ≤ w.web.level y.1 y.2

/-- **The relations of the occurrence model, as selected.** Nine of the ten relations
`Becoming.WorldRepresentation` selects: conservation's step; activity, standing and presence as
partial identities; and requiring, drawing, a need met, giving and taking within a step. The tenth,
the same-step class, is one term for every world and is left out. To these are added falling, as a
partial identity, and the order of standings. This is a selection, not every relation a World
carries: a re-identification also carries a standing's value, which none of these reads. -/
structure ModelRelations (R : Type) where
  conservation : «际» (Nat × R)
  active : «际» (Nat × R)
  standing : «际» (Nat × R)
  present : «际» (Nat × R)
  requires : «际» (Nat × R)
  draws : «际» (Nat × R)
  needMet : «际» (Nat × R)
  gives : «际» (Nat × R)
  takes : «际» (Nat × R)
  falls : «际» (Nat × R)
  order : «际» (Nat × R)

/-- Two readings of the model relations agree: each relation is the same, pointwise. -/
def ModelRelations.Agree {R : Type} (a b : ModelRelations R) : Prop :=
  «谓» a.conservation b.conservation ∧ «谓» a.active b.active ∧ «谓» a.standing b.standing ∧
  «谓» a.present b.present ∧ «谓» a.requires b.requires ∧ «谓» a.draws b.draws ∧
  «谓» a.needMet b.needMet ∧ «谓» a.gives b.gives ∧ «谓» a.takes b.takes ∧
  «谓» a.falls b.falls ∧ «谓» a.order b.order

/-- A world's model relations. -/
def modelRelations (w : World) : ModelRelations w.Relatum :=
  ⟨w.conservationStep,
   Web.partialIdentity fun x => w.web.active x.1 x.2,
   Web.partialIdentity fun x => 0 < w.web.level x.1 x.2,
   Web.partialIdentity fun x => x.2 ∈ w.flow.present x.1,
   withinStep w.web.requires,
   withinStep w.web.draws,
   withinStep fun t f c => w.web.need t f c ≤ w.web.level t c,
   withinStep fun t f c => 0 < w.flow.give t f c,
   withinStep fun t f c => 0 < w.flow.take t f c,
   Web.partialIdentity fun x => w.web.Falls x.1 x.2,
   w.standingOrder⟩

/-- **Every relation of the occurrence model is the same at a finer unit.** At a positive factor,
each of the world's model relations agrees pointwise with the original's, on the same
occurrences. -/
theorem atFinerUnit_agree (pos : 0 < k) :
    (w.atFinerUnit k).modelRelations.Agree w.modelRelations :=
  ⟨fun _ _ => ⟨fun ⟨next, c⟩ => ⟨next, (atFinerUnit_conserves pos _ _ _).mp c⟩,
     fun ⟨next, c⟩ => ⟨next, (atFinerUnit_conserves pos _ _ _).mpr c⟩⟩,
   fun _ _ => Iff.rfl,
   fun _ _ => ⟨fun ⟨same, p⟩ => ⟨same, (pos_scaled pos _).mp p⟩,
     fun ⟨same, p⟩ => ⟨same, (pos_scaled pos _).mpr p⟩⟩,
   fun _ _ => Iff.rfl,
   fun _ _ => Iff.rfl,
   fun _ _ => Iff.rfl,
   fun _ _ => ⟨fun ⟨same, m⟩ => ⟨same, (le_scaled pos _ _).mp m⟩,
     fun ⟨same, m⟩ => ⟨same, (le_scaled pos _ _).mpr m⟩⟩,
   fun _ _ => ⟨fun ⟨same, p⟩ => ⟨same, (pos_scaled pos _).mp p⟩,
     fun ⟨same, p⟩ => ⟨same, (pos_scaled pos _).mpr p⟩⟩,
   fun _ _ => ⟨fun ⟨same, p⟩ => ⟨same, (pos_scaled pos _).mp p⟩,
     fun ⟨same, p⟩ => ⟨same, (pos_scaled pos _).mpr p⟩⟩,
   fun _ _ => ⟨fun ⟨same, f⟩ => ⟨same, (lt_scaled pos _ _).mp f⟩,
     fun ⟨same, f⟩ => ⟨same, (lt_scaled pos _ _).mpr f⟩⟩,
   fun _ _ => le_scaled pos _ _⟩

/-- The identity correspondence of a world's occurrences. -/
def identityOnOccurrences (R : Type) : «一一对应» (Nat × R) (Nat × R) :=
  ⟨fun x => x, fun x => x, fun _ => rfl, fun _ => rfl⟩

/-- Pointwise agreement is carrying by the identity correspondence. -/
theorem carried_of_same {R : Type} {S S' : «际» (Nat × R)} (same : «谓» S S') :
    «谓» («像» (identityOnOccurrences R).to S) S' :=
  («对应之像» (identityOnOccurrences R) S S').mpr same

/-- **Each model relation at a finer unit is carried to the original's** by the identity
correspondence, the form `Becoming.GrammarTransport`'s keeping theorems take. -/
theorem atFinerUnit_carried (pos : 0 < k) :
    let a := (w.atFinerUnit k).modelRelations
    let b := w.modelRelations
    let e := (identityOnOccurrences w.Relatum).to
    «谓» («像» e a.conservation) b.conservation ∧ «谓» («像» e a.active) b.active ∧
    «谓» («像» e a.standing) b.standing ∧ «谓» («像» e a.present) b.present ∧
    «谓» («像» e a.requires) b.requires ∧ «谓» («像» e a.draws) b.draws ∧
    «谓» («像» e a.needMet) b.needMet ∧ «谓» («像» e a.gives) b.gives ∧
    «谓» («像» e a.takes) b.takes ∧ «谓» («像» e a.falls) b.falls ∧
    «谓» («像» e a.order) b.order :=
  match atFinerUnit_agree (w := w) pos with
  | ⟨c, a, s, p, r, d, n, g, t, f, o⟩ =>
    ⟨carried_of_same c, carried_of_same a, carried_of_same s, carried_of_same p, carried_of_same r,
     carried_of_same d, carried_of_same n, carried_of_same g, carried_of_same t, carried_of_same f,
     carried_of_same o⟩

/-- The class of activity at a finer unit is carried to the original's. -/
theorem atFinerUnit_activityClass :
    «谓» («像» (identityOnOccurrences w.Relatum).to (w.atFinerUnit k).web.activityClass)
      w.web.activityClass :=
  carried_of_same fun _ _ => Iff.rfl

/-- **The pattern: the continuation family reads alike at a finer unit.** At a positive factor,
under conservation's step and the class of activity, two occurrences are of one family in the finer
unit exactly where they are in `w`. -/
theorem atFinerUnit_family (pos : 0 < k) (x y : Nat × w.Relatum) :
    «同族» (w.atFinerUnit k).conservationStep (w.atFinerUnit k).web.activityClass x y ↔
      «同族» w.conservationStep w.web.activityClass x y :=
  «同族之对应» (e := identityOnOccurrences w.Relatum) (atFinerUnit_carried pos).1
    atFinerUnit_activityClass x y

/-- At a positive factor, beginning under conservation and the class of activity reads alike at a
finer unit. -/
theorem atFinerUnit_begins (pos : 0 < k) (y : Nat × w.Relatum) :
    «生» (w.atFinerUnit k).conservationStep (w.atFinerUnit k).web.activityClass y ↔
      «生» w.conservationStep w.web.activityClass y :=
  «生之对应» (e := identityOnOccurrences w.Relatum) (atFinerUnit_carried pos).1
    atFinerUnit_activityClass y

/-- At a positive factor, ending under conservation and the class of activity reads alike at a
finer unit. -/
theorem atFinerUnit_ends (pos : 0 < k) (x : Nat × w.Relatum) :
    «亡» (w.atFinerUnit k).conservationStep (w.atFinerUnit k).web.activityClass x ↔
      «亡» w.conservationStep w.web.activityClass x :=
  «亡之对应» (e := identityOnOccurrences w.Relatum) (atFinerUnit_carried pos).1
    atFinerUnit_activityClass x

/-- **No reading of the selected relations gives the count, at any occurrence of positive standing
of any world.** Let `Ψ` read a number at each occurrence from a world's model relations as selected
(`World.ModelRelations`, which leave out what reads a standing's value), the same wherever
two readings agree pointwise. For every world `w`, every factor `k` with `0 < k` and `k ≠ 1`, and
every occurrence of positive standing, `Ψ` does not return the standing both in `w` and in `w`
counted in a unit `k` times finer. -/
theorem standing_not_read {Ψ : (R : Type) → ModelRelations R → Nat × R → Nat}
    (keeps : ∀ R (a b : ModelRelations R), a.Agree b → ∀ x, Ψ R a x = Ψ R b x)
    (w : World) {k : Nat} (pos : 0 < k) (other : k ≠ 1) (x : Nat × w.Relatum)
    (stands : 0 < w.web.level x.1 x.2) :
    ¬ (Ψ w.Relatum w.modelRelations x = w.web.level x.1 x.2 ∧
       Ψ w.Relatum (w.atFinerUnit k).modelRelations x = (w.atFinerUnit k).web.level x.1 x.2) :=
  fun ⟨here, there⟩ =>
    other (Nat.eq_of_mul_eq_mul_right stands
      (there.symm.trans ((keeps w.Relatum _ _ (atFinerUnit_agree pos) x).trans
        (here.trans (Nat.one_mul _).symm))))

/-! ## The unit is one freedom among others -/

/-- **A still world** on relata `R` with standings `s`: nothing takes part, and nothing is active,
requires, needs or draws. -/
def stillAt (R : Type) (s : Nat → R → Nat) : World :=
  World.of R Flow.still (Witnesses.unrequired s fun _ _ => False)

/-- F1's worlds are still worlds on one relatum. -/
theorem standingAt_eq_stillAt (k : Nat) : standingAt k = stillAt Unit fun _ _ => k :=
  rfl

/-- In a still world, conservation across a step is equality of the standings. -/
theorem stillAt_conserves {R : Type} (s : Nat → R → Nat) (t : Nat) (g f : R) :
    (stillAt R s).Conserves t g f ↔ s (t + 1) f = s t g :=
  Iff.rfl

/-- **In a still world, every relabelling of the standings that keeps sign and order keeps every
model relation.** For any standings `s` on any relata and any `σ` with `0 < σ a ↔ 0 < a` and
`σ a ≤ σ b ↔ a ≤ b` for all amounts `a` and `b`, the still world with standings `σ ∘ s` and the
still world with standings `s` agree pointwise on each model relation. -/
theorem stillAt_relabel_agree {R : Type} (s : Nat → R → Nat) {σ : Nat → Nat}
    (sign : ∀ a, 0 < σ a ↔ 0 < a) (order : ∀ a b, σ a ≤ σ b ↔ a ≤ b) :
    (stillAt R fun t x => σ (s t x)).modelRelations.Agree (stillAt R s).modelRelations :=
  ⟨fun x y => ⟨fun ⟨next, c⟩ => ⟨next, (stillAt_conserves s x.1 x.2 y.2).mpr
        ((eq_relabelled order _ _).mp
          ((stillAt_conserves (fun t x => σ (s t x)) x.1 x.2 y.2).mp c))⟩,
     fun ⟨next, c⟩ => ⟨next, (stillAt_conserves (fun t x => σ (s t x)) x.1 x.2 y.2).mpr
        ((eq_relabelled order _ _).mpr ((stillAt_conserves s x.1 x.2 y.2).mp c))⟩⟩,
   fun _ _ => Iff.rfl,
   fun _ _ => ⟨fun ⟨same, p⟩ => ⟨same, (sign _).mp p⟩, fun ⟨same, p⟩ => ⟨same, (sign _).mpr p⟩⟩,
   fun _ _ => Iff.rfl,
   fun _ _ => Iff.rfl,
   fun _ _ => Iff.rfl,
   fun _ _ => ⟨fun ⟨same, _⟩ => ⟨same, Nat.zero_le _⟩, fun ⟨same, _⟩ => ⟨same, Nat.zero_le _⟩⟩,
   fun _ _ => Iff.rfl,
   fun _ _ => Iff.rfl,
   fun _ _ => ⟨fun ⟨same, f⟩ => ⟨same, (lt_relabelled order _ _).mp f⟩,
     fun ⟨same, f⟩ => ⟨same, (lt_relabelled order _ _).mpr f⟩⟩,
   fun _ _ => order _ _⟩

/-- **Squaring the standings of a still world keeps every model relation.** -/
theorem stillAt_squared_agree {R : Type} (s : Nat → R → Nat) :
    (stillAt R fun t x => s t x * s t x).modelRelations.Agree (stillAt R s).modelRelations :=
  stillAt_relabel_agree (σ := fun a => a * a) s pos_squared le_squared

/-- The standings 1 and 2, on the relata `false` and `true`, at every step. -/
def oneTwo : Nat → Bool → Nat
  | _, false => 1
  | _, true => 2

/-- **Agreement is not a common factor.** The still worlds on two relata with standings 1 and 2 and
with standings 1 and 4 agree on every model relation, and no factor `k` takes the first standings to
the second. -/
theorem oneTwo_not_scaled :
    (stillAt Bool fun t x => oneTwo t x * oneTwo t x).modelRelations.Agree
        (stillAt Bool oneTwo).modelRelations ∧
      ¬ ∃ k, ∀ (t : Nat) (x : Bool),
        (stillAt Bool fun t x => oneTwo t x * oneTwo t x).web.level t x =
          k * (stillAt Bool oneTwo).web.level t x :=
  ⟨stillAt_squared_agree oneTwo, fun ⟨k, scaled⟩ =>
    have one : k = 1 := factor_of_one (scaled 0 false)
    absurd ((scaled 0 true).trans (congrArg (· * 2) one)) (by decide)⟩

/-- Two pairs of standings 1, 2 and 1, 4, each read up to positive factors, cannot be read alike.
Where `q * 1 = p * a`, `q * 2 = p * b`, `q' * 1 = p' * a` and `q' * 4 = p' * b`, with `0 < p` and
`0 < q'`, there is a contradiction. -/
theorem ratio_apart {p q p' q' a b : Nat} (pp : 0 < p) (qq' : 0 < q')
    (a1 : q * 1 = p * a) (b1 : q * 2 = p * b) (a2 : q' * 1 = p' * a) (b2 : q' * 4 = p' * b) :
    False :=
  have hq : q = p * a := (Nat.mul_one q).symm.trans a1
  have hq' : q' = p' * a := (Nat.mul_one q').symm.trans a2
  have left : p' * (q * 2) = p * q' * 2 :=
    (mul_assoc_nat p' q 2).symm.trans (congrArg (· * 2)
      ((congrArg (p' * ·) hq).trans ((mul_turn p' p a).trans (congrArg (p * ·) hq'.symm))))
  have mid : p' * (q * 2) = p * (q' * 4) :=
    (congrArg (p' * ·) b1).trans ((mul_turn p' p b).trans (congrArg (p * ·) b2.symm))
  have two_four : p * q' * 2 = p * q' * 4 :=
    left.symm.trans (mid.trans (mul_assoc_nat p q' 4).symm)
  absurd (Nat.eq_of_mul_eq_mul_left (Nat.mul_pos pp qq') two_four) (by decide)

/-- **No single reading of the selected relations gives the standings of every world even up to a
unit.** No `Ψ` that reads a number at each occurrence from a world's model relations as selected,
the same wherever two
readings agree pointwise, has, for every world, positive whole factors `p` and `q` with `q` times
every standing equal to `p` times what `Ψ` reads. The factors are chosen world by world;
`q = k`, `p = 1` is a reading in a unit `k` times finer than the count's, and `q = 1`, `p = k` one
in a unit `k` times coarser. The worlds that refute it are the still worlds on two relata with
standings 1, 2 and 1, 4; a reading up to a unit on a class of worlds without them is not ruled
out. -/
theorem standing_not_read_up_to_unit :
    ¬ ∃ Ψ : (R : Type) → ModelRelations R → Nat × R → Nat,
      (∀ R (a b : ModelRelations R), a.Agree b → ∀ x, Ψ R a x = Ψ R b x) ∧
      ∀ w : World, ∃ p q : Nat, 0 < p ∧ 0 < q ∧ ∀ x : Nat × w.Relatum,
        q * w.web.level x.1 x.2 = p * Ψ w.Relatum w.modelRelations x :=
  fun ⟨_, keeps, reads⟩ =>
    match reads (stillAt Bool oneTwo), reads (stillAt Bool fun t x => oneTwo t x * oneTwo t x) with
    | ⟨_, _, pp, _, first⟩, ⟨p', _, _, qq', second⟩ =>
      have same := keeps Bool _ _ (stillAt_squared_agree oneTwo)
      ratio_apart pp qq' (first (0, false)) (first (0, true))
        ((second (0, false)).trans (congrArg (p' * ·) (same (0, false))))
        ((second (0, true)).trans (congrArg (p' * ·) (same (0, true))))

end World

end Becoming
