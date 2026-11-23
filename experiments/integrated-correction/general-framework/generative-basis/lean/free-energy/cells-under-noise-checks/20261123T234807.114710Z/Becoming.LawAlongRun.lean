import Becoming.Unfolding
import Becoming.Testing
import Becoming.Witnesses

/-!
# A law along one run, under a relation

`Becoming.Mechanism` characterized when a projection carries a law over every configuration
(`carries_law_iff`: configurations alike go alike). This module states the criterion along one
run, once, under a relation, and reads it through the three relations the spine uses: a
projection, what a formation couples into with fixed conditions, and what it couples into with
dependences that change along the run. It also states the bridge to `GenerativeCore`'s exact
projection of finite paths (`Generative.projection_exact_iff`). No premise enters beyond what each
theorem names.

* **The law, under a relation.** A run's steps before `t` are consistent under a relation `E`
  when any two of them from configurations `E` relates, by the same move, reach configurations `E`
  relates (`Run.ConsistentUnder`). Where `E` is an equivalence, some process going alike under `E`
  (`GoAlikeUnder` of `Becoming.Laws`, through the identity) admits the run's steps before `t`
  exactly where they are consistent (`Run.law_under_iff`). The witness is the record read under
  `E` (`Run.recordUnder`); the forward direction needs no equivalence. Consistency up to a step
  holds at every earlier step, so once failed the criterion fails from then on
  (`Run.ConsistentUnder.earlier`, `Run.no_law_under_later`). Where the process goes alike under
  `E`, every run is consistent (`Run.consistentUnder_of_goAlikeUnder`). Consistency reads `E` only
  on the run's configurations up to `t` (`Run.consistentUnder_congr`).
* **Reading 1: through a projection.** Under equal projections the criterion is
  `Run.ConsistentThrough` (`Run.consistentUnder_eq_iff`), and it gives a determined process on the
  description itself: some determined process on the description admits the run's steps before
  `t` read through `π` exactly where they are consistent (`Run.law_through_iff`, from
  `Run.law_under_iff` through the image). The record read through `π` (`Run.recordThrough`) is the
  least process admitting those steps (`Run.record_least`) and is determined exactly where they
  are consistent (`Run.record_determined_iff`); once failed, failed from then on
  (`Run.no_law_later`). `Becoming.Unfolding` stated the case through the identity over the whole
  history (`Consistent`, `exists_law_iff`); it is the instance at every step
  (`Run.consistent_id_iff`). Where configurations alike go alike, every run is consistent
  (`Run.consistent_of_goAlike`, the case of `Run.consistentUnder_of_goAlikeUnder`). The converse
  fails: in `Constant` a run consistent at every step lies in a process that does not go alike
  (`Constant.consistent`, `Constant.not_goAlike`); `Switching.no_state_law` follows from the
  criterion (`Switching.inconsistent`).
* **Reading 2: through coupling that changes along the run.** With dependences read off the
  configuration (`Dependence`), two configurations are alike in what `g` couples into when the
  levels at each, read through the dependence `g` has there, admit it alike and the conditions it
  observes stand alike (`Dependence.AlikeAt`). This is an equivalence
  (`Dependence.alikeAt_equivalence`), so the law holds through it (`Run.law_through_dependence_iff`).
  Along a run it is the relation between two steps each read through the dependence of its own step
  (`Web.AlikeAcross`, `Dependence.alikeAt_iff_alikeAcross`). `Web.AlikeThrough` of
  `Becoming.Testing`, read at step `t` between the levels standing at two steps, is the coupling with
  the dependence fixed at the configuration of step `t` (`Dependence.fixedAt`,
  `Dependence.alikeThrough_iff_fixedAt`, `Web.alikeAcross_iff_alikeThrough`).
* **Reading 3: through coupling with fixed conditions.** Fixed conditions (`Conditions` of
  `Becoming.Renewal`) are the case of reading 2 whose dependences do not change
  (`Conditions.AlikeAt` is `Dependence.AlikeAt` of `Conditions.dependence`,
  `Dependence.conditions_alikeAt_iff`, along a run `Run.consistent_conditions_iff`), exactly
  `Web.AlikeThrough` on the runs read through the conditions (`Conditions.alikeThrough_iff`,
  `Conditions.alikeAt_iff_alikeThrough`), so `Run.law_through_coupling_iff`. Where `g`'s
  dependences up to `t` are those of one step (`Dependence.Unchanged`), readings 2 and 3 give one
  criterion (`Run.consistent_unchanged_iff`); where they form or dissolve, neither gives the other
  (`Changing`).
* **Exactness, over every configuration.** The image of a process through `π` represents every
  finite path exactly, in the sense of `Generative.projection_exact_iff`, exactly where
  configurations alike under `π` match each other's steps up to `π` (`MatchesThrough`,
  `image_exact_iff`). Some determined process on the description both admits every step read
  through `π` and represents every finite path exactly where configurations alike go alike and
  match each other's steps (`exact_law_iff`). This is a statement of the whole process, not of one
  run; going alike does not give it (`Stuck.goAlike_not_matches`), and `Coarse` is exact through
  its first bit (`Coarse.matching`, `Coarse.exact_law`).
* **Witnesses for the coupling readings.** In `Unseen` the process is determined, and a formation
  depending on one condition and observing nothing couples alike the first two steps of a run that
  by the same move lead to configurations it couples apart: the level it does not couple into
  decides (`Unseen.determined`, `Unseen.inconsistent`, `Unseen.no_law`); observing that level, the
  same run is consistent at every step (`Unseen.consistent_observing`). In `Changing`, a level rising
  by one each step, a dependence that dissolves across the first step leaves the run consistent
  under the changing coupling while the coupling fixed at the start is inconsistent at step 2
  (`Changing.dissolving_consistent`, `Changing.dissolving_fixed_inconsistent`), and a dependence that
  forms does the reverse at step 3 (`Changing.forming_fixed_consistent`,
  `Changing.forming_inconsistent`).

**Reading (the AI's).** A run is evidence of a law under a relation exactly as far as its own
steps agree with each other: the record is the least candidate, and it is a law exactly where no
two recorded occasions the relation joins went apart. Which relation is read is the one choice: a
description, what a formation couples into with the dependences of one moment, or what it couples
into on each occasion. What the run never visits it does not test, so a run can show a law where
the process has none; a difference outside the coupling can decide what the formation next couples
into, so no law at its coupling holds along that course however determined the unfolding is; and
reading a course through the dependence of one moment can find a law the formation's own coupling
does not carry, or miss one it does. A law at a description is also not yet a faithful model of
finite paths: that needs every configuration of a class to be able to do what any of them did.

What is not derived: which relation an actual unfolding carries a law through; that any formation
forms or uses one; observation that changes along the run (here what a formation observes is
fixed, as in `Becoming.Testing`); how many steps settle whether a law holds. No ethical predicate,
ranking or axiom occurs.
-/

namespace Becoming

open Generative

universe u v w

variable {S : Type u} {A : Type v} {K : Type w}

/-! ## The law, under a relation -/

namespace Run

variable {P : Process S A}

/-- The run's steps before `t` are consistent under `E`: two of them from configurations `E`
relates, by the same move, reach configurations `E` relates. -/
def ConsistentUnder (r : Run P) (E : S → S → Prop) (t : Nat) : Prop :=
  ∀ n m, n < t → m < t → E (r.state n) (r.state m) → r.act n = r.act m →
    E (r.state (n + 1)) (r.state (m + 1))

/-- The record read under `E` before `t`: a move goes from `x` to `y` where the run took it,
before `t`, from a configuration `E` relates to `x` to one `E` relates to `y`. -/
def recordUnder (r : Run P) (E : S → S → Prop) (t : Nat) : Process S A :=
  ⟨fun x a y => ∃ n, n < t ∧ E x (r.state n) ∧ r.act n = a ∧ E y (r.state (n + 1))⟩

/-- Where `E` is reflexive, the record admits the run's steps before `t`. -/
theorem recordUnder_steps (r : Run P) {E : S → S → Prop} (refl : ∀ x, E x x) (t : Nat) :
    ∀ n, n < t → (r.recordUnder E t).step (r.state n) (r.act n) (r.state (n + 1)) :=
  fun n before => ⟨n, before, refl _, rfl, refl _⟩

/-- Where `E` is an equivalence and the steps are consistent under it, the record goes alike
under `E`. -/
theorem recordUnder_goAlike (r : Run P) {E : S → S → Prop} (equivalence : Equivalence E)
    {t : Nat} (consistent : r.ConsistentUnder E t) :
    GoAlikeUnder (r.recordUnder E t) id E :=
  goAlikeUnder_iff_alike.mpr fun a =>
    let S_a : «际» S := fun u v => ∃ n, n < t ∧ r.state n = u ∧ r.act n = a ∧ r.state (n + 1) = v
    have hE : «类» E := ⟨equivalence.refl, equivalence.symm, equivalence.trans⟩
    have alikeS : «同行» S_a E := «同行之逐点».mpr fun _ _ same _ _ ⟨n, before, hx, ha, hy⟩ ⟨m, before', hx', ha', hy'⟩ =>
      Eq.subst (motive := fun y => E _ y) hy'
        (Eq.subst (motive := fun x => E x _) hy
          (consistent n m before before'
            (Eq.subst (motive := fun y => E _ y) hx'.symm
              (Eq.subst (motive := fun x => E x _) hx.symm same))
            (ha.trans ha'.symm)))
    «同行之单调»
      (fun _ _ ⟨n, before, hx, ha, hy⟩ =>
        ⟨r.state (n + 1), ⟨r.state n, hx, ⟨n, before, rfl, ha, rfl⟩⟩, equivalence.symm hy⟩)
      («类则同行之展» hE alikeS).1

/-- **A law up to a relation along one run.** Where `E` is an equivalence, some process going
alike under `E` admits the run's steps before `t` exactly where those steps are consistent under
`E`. No premise: the witness is the record read under `E`. -/
theorem law_under_iff (r : Run P) {E : S → S → Prop} (equivalence : Equivalence E) (t : Nat) :
    (∃ Q : Process S A, GoAlikeUnder Q id E ∧
        ∀ n, n < t → Q.step (r.state n) (r.act n) (r.state (n + 1))) ↔
      r.ConsistentUnder E t :=
  ⟨fun ⟨Q, alike, steps⟩ n m before before' same same' =>
     «同行之逐点».mp (goAlikeUnder_iff_alike.mp alike (r.act n)) _ _ same _ _ (steps n before)
       (Eq.subst (motive := fun b => Q.step (r.state m) b (r.state (m + 1))) same'.symm (steps m before')),
   fun consistent => ⟨r.recordUnder E t, r.recordUnder_goAlike equivalence consistent,
     r.recordUnder_steps equivalence.refl t⟩⟩

/-- Consistency up to a step holds at every earlier step. -/
theorem ConsistentUnder.earlier {r : Run P} {E : S → S → Prop} {t t' : Nat}
    (consistent : r.ConsistentUnder E t') (le : t ≤ t') : r.ConsistentUnder E t :=
  fun n m before before' => consistent n m (Nat.lt_of_lt_of_le before le)
    (Nat.lt_of_lt_of_le before' le)

/-- **Once failed, failed from then on.** Where no process going alike under `E` admits the run's
steps before `t`, none admits them before any later step. -/
theorem no_law_under_later (r : Run P) {E : S → S → Prop} (equivalence : Equivalence E)
    {t t' : Nat} (le : t ≤ t')
    (failed : ¬ ∃ Q : Process S A, GoAlikeUnder Q id E ∧
        ∀ n, n < t → Q.step (r.state n) (r.act n) (r.state (n + 1))) :
    ¬ ∃ Q : Process S A, GoAlikeUnder Q id E ∧
        ∀ n, n < t' → Q.step (r.state n) (r.act n) (r.state (n + 1)) :=
  fun law => failed ((r.law_under_iff equivalence t).mpr
    (((r.law_under_iff equivalence t').mp law).earlier le))

/-- Where the process goes alike under `E`, every run is consistent under `E` at every step. -/
theorem consistentUnder_of_goAlikeUnder (r : Run P) {E : S → S → Prop}
    (alike : GoAlikeUnder P id E) (t : Nat) : r.ConsistentUnder E t :=
  fun n m _ _ same same' =>
    «同行之逐点».mp (goAlikeUnder_iff_alike.mp alike (r.act n)) _ _ same _ _ (r.step n)
      (Eq.subst (motive := fun b => P.step (r.state m) b (r.state (m + 1))) same'.symm (r.step m))

/-- **Consistency reads a relation only on the run's configurations up to `t`.** -/
theorem consistentUnder_congr (r : Run P) {E E' : S → S → Prop} {t : Nat}
    (agree : ∀ n m, n ≤ t → m ≤ t → (E (r.state n) (r.state m) ↔ E' (r.state n) (r.state m))) :
    r.ConsistentUnder E t ↔ r.ConsistentUnder E' t :=
  ⟨fun consistent n m before before' same act =>
     (agree (n + 1) (m + 1) before before').mp (consistent n m before before'
       ((agree n m (Nat.le_of_lt before) (Nat.le_of_lt before')).mpr same) act),
   fun consistent n m before before' same act =>
     (agree (n + 1) (m + 1) before before').mpr (consistent n m before before'
       ((agree n m (Nat.le_of_lt before) (Nat.le_of_lt before')).mp same) act)⟩

/-! ## Reading 1: through a projection -/

/-- The run's steps before `t`, read through `π`, are consistent: two of them from
configurations alike under `π`, by the same move, reach configurations alike under `π`. It is
`ConsistentUnder` at equal projections (`consistentUnder_eq_iff`). -/
def ConsistentThrough (r : Run P) (π : S → K) (t : Nat) : Prop :=
  r.ConsistentUnder (fun x y => π x = π y) t

/-- **The criterion through a projection is the law at equal projections.** -/
theorem consistentUnder_eq_iff {D : Type w} (r : Run P) (π : S → D) (t : Nat) :
    r.ConsistentUnder (fun x y => π x = π y) t ↔ r.ConsistentThrough π t :=
  Iff.rfl

/-- The record read through `π` before `t`: a move goes from `k` to `κ` where the run took it,
before `t`, from a configuration projecting to `k` to one projecting to `κ`. -/
def recordThrough (r : Run P) (π : S → K) (t : Nat) : Process K A :=
  ⟨fun k a κ => ∃ n, n < t ∧ π (r.state n) = k ∧ r.act n = a ∧ π (r.state (n + 1)) = κ⟩

/-- The record admits the run's steps before `t` read through `π`. -/
theorem stepsThrough_record (r : Run P) (π : S → K) (t : Nat) :
    r.StepsThrough π (r.recordThrough π t) t :=
  fun n before => ⟨n, before, rfl, rfl, rfl⟩

/-- **The record is the least candidate.** Every process admitting the run's steps before `t`
read through `π` admits every step of the record. -/
theorem record_least (r : Run P) {π : S → K} {Q : Process K A} {t : Nat}
    (steps : r.StepsThrough π Q t) {k : K} {a : A} {κ : K} :
    (r.recordThrough π t).step k a κ → Q.step k a κ
  | ⟨n, before, at_k, by_a, to⟩ =>
    Eq.subst (motive := fun x => Q.step k a x) to
      (Eq.subst (motive := fun b => Q.step k b (π (r.state (n + 1)))) by_a
        (Eq.subst (motive := fun x => Q.step x (r.act n) (π (r.state (n + 1)))) at_k
          (steps n before)))

/-- The record is determined exactly where the run's steps so read are consistent. -/
theorem record_determined_iff (r : Run P) (π : S → K) (t : Nat) :
    Determined (r.recordThrough π t) ↔ r.ConsistentThrough π t :=
  ⟨fun determined n m before before' same same' =>
     determined (π (r.state n)) (r.act n) _ _ ⟨n, before, rfl, rfl, rfl⟩
       ⟨m, before', same.symm, same'.symm, rfl⟩,
   fun consistent _ _ _ _ ⟨n, before, at_k, by_a, to⟩ ⟨m, before', at_k', by_a', to'⟩ =>
     to.symm.trans ((consistent n m before before' (at_k.trans at_k'.symm)
       (by_a.trans by_a'.symm)).trans to')⟩

/-- **A law through a projection along one run.** Some determined process on the description
admits the run's steps before `t` read through `π` exactly where those steps are consistent. It is
`law_under_iff` at equal projections: a determined process on the description, read back on the
configurations, goes alike under equal projections, and the image through `π` of one going alike
is determined. -/
theorem law_through_iff (r : Run P) (π : S → K) (t : Nat) :
    (∃ Q : Process K A, Determined Q ∧ r.StepsThrough π Q t) ↔ r.ConsistentThrough π t :=
  ⟨fun ⟨Q, determined, steps⟩ =>
     (r.law_under_iff (E := fun x y => π x = π y)
        ⟨fun _ => rfl, Eq.symm, Eq.trans⟩ t).mp
       ⟨⟨fun x a y => Q.step (π x) a (π y)⟩,
        fun _ _ _ _ _ same step step' => determined _ _ _ _ step
          (Eq.subst (motive := fun k => Q.step k _ _) same.symm step'),
        steps⟩,
   fun consistent =>
     match (r.law_under_iff (E := fun x y => π x = π y) ⟨fun _ => rfl, Eq.symm, Eq.trans⟩ t).mpr
         consistent with
     | ⟨Q, alike, steps⟩ =>
       ⟨Image Q π, image_determined_iff.mpr alike,
        fun n before => ⟨r.state n, r.state (n + 1), rfl, steps n before, rfl⟩⟩⟩

/-- Consistency up to a step holds at every earlier step. -/
theorem ConsistentThrough.earlier {r : Run P} {π : S → K} {t t' : Nat}
    (consistent : r.ConsistentThrough π t') (le : t ≤ t') : r.ConsistentThrough π t :=
  ConsistentUnder.earlier consistent le

/-- **Once failed, failed from then on.** Where no determined process on the description admits
the run's steps before `t` read through `π`, none admits them before any later step. -/
theorem no_law_later (r : Run P) {π : S → K} {t t' : Nat} (le : t ≤ t')
    (none : ¬ ∃ Q : Process K A, Determined Q ∧ r.StepsThrough π Q t) :
    ¬ ∃ Q : Process K A, Determined Q ∧ r.StepsThrough π Q t' :=
  fun law => none ((r.law_through_iff π t).mpr (((r.law_through_iff π t').mp law).earlier le))

/-- **`Becoming.Unfolding`'s history law is the instance through the identity.** A run is
consistent through the identity at every step exactly where it is consistent in the sense of
`Consistent`, so `exists_law_iff` is `Run.law_through_iff` through the identity, at every
step. -/
theorem consistent_id_iff (r : Run P) :
    (∀ t, r.ConsistentThrough id t) ↔ Becoming.Consistent r.state r.act :=
  ⟨fun consistent i j same same' =>
     consistent (i + j + 1) i j (Nat.lt_succ_of_le (Nat.le_add_right i j))
       (Nat.lt_succ_of_le (Nat.le_add_left j i)) same same',
   fun consistent _ n m _ _ same same' => consistent n m same same'⟩

/-- Where configurations alike under `π` go alike, every run is consistent through `π` at every
step: `consistentUnder_of_goAlikeUnder` at equal projections. -/
theorem consistent_of_goAlike (r : Run P) {π : S → K} (alike : GoAlike P π) (t : Nat) :
    r.ConsistentThrough π t :=
  r.consistentUnder_of_goAlikeUnder (E := fun x y => π x = π y) alike t

end Run

/-! ## Exactness -/

/-- Configurations alike under `π` match each other's steps up to `π`: wherever one of two
configurations alike under `π` takes a step, the other takes one by the same move to a
configuration alike under `π` with its end. -/
def MatchesThrough (P : Process S A) (π : S → K) : Prop :=
  ∀ s s' a u', π s = π s' → P.step s' a u' → ∃ u, P.step s a u ∧ π u = π u'

/-- **The image is exact exactly where configurations alike match.** The image of `P` through
`π` represents every finite path exactly, in the sense of `Generative.projection_exact_iff`,
exactly where configurations alike under `π` match each other's steps up to `π`. -/
theorem image_exact_iff {P : Process S A} {π : S → K} :
    (∀ s as r, Trace (Image P π) (π s) as r ↔ ∃ t, Trace P s as t ∧ π t = r) ↔
      MatchesThrough P π :=
  (projection_exact_iff (P := P) (Q := Image P π) (q := π)).symm.trans
    ⟨fun ⟨_, lift⟩ s s' a u' same step' => lift s a (π u') ⟨s', u', same.symm, step', rfl⟩,
     fun matching => ⟨factors_image P π, fun s a _ ⟨s', u', at_k, step', to⟩ =>
       match matching s s' a u' at_k.symm step' with
       | ⟨u, step, same⟩ => ⟨u, step, same.trans to⟩⟩⟩

/-- **An exact law at a description.** Some determined process on the description admits every
step of `P` read through `π` and lifts each of its steps from every configuration in the fibre,
so that it represents every finite path exactly, exactly where configurations alike under `π`
go alike and match each other's steps. -/
theorem exact_law_iff {P : Process S A} {π : S → K} :
    (∃ Q : Process K A, Determined Q ∧ FactorsThrough P π Q ∧
        ∀ s a r, Q.step (π s) a r → ∃ t, P.step s a t ∧ π t = r) ↔
      GoAlike P π ∧ MatchesThrough P π :=
  ⟨fun ⟨Q, determined, factors, lift⟩ =>
     ⟨carries_law_iff.mp ⟨Q, determined, factors⟩, fun s s' a u' same step' =>
       lift s a (π u') (Eq.subst (motive := fun k => Q.step k a (π u')) same.symm
         (factors s' a u' step'))⟩,
   fun ⟨alike, matching⟩ => ⟨Image P π, image_determined_iff.mpr alike, factors_image P π,
     fun s a _ ⟨s', u', at_k, step', to⟩ => match matching s s' a u' at_k.symm step' with
       | ⟨u, step, same⟩ => ⟨u, step, same.trans to⟩⟩⟩

/-! ## Reading 2: through coupling that changes along the run -/

namespace Dependence

variable {F C : Type} (D : Dependence S F C)

/-- The levels at `x` admit `g` through the dependence `g` has at `x`. -/
def AdmitsAt (x : S) (g : F) : Prop :=
  ∀ c, D.requires x g c → D.need x g c ≤ D.level x c

/-- `x` and `y` are alike in what `g` couples into, each read through the dependence `g` has
there: their levels admit `g` alike, and the conditions `g` observes stand alike. -/
def AlikeAt (obs : F → C → Prop) (g : F) (x y : S) : Prop :=
  (D.AdmitsAt x g ↔ D.AdmitsAt y g) ∧ ∀ c, obs g c → D.level x c = D.level y c

/-- Being alike in what `g` couples into, through changing dependence, is an equivalence. -/
theorem alikeAt_equivalence (obs : F → C → Prop) (g : F) : Equivalence (D.AlikeAt obs g) :=
  ⟨fun _ => ⟨Iff.rfl, fun _ _ => rfl⟩,
   fun alike => ⟨alike.1.symm, fun c observed => (alike.2 c observed).symm⟩,
   fun first second => ⟨first.1.trans second.1,
     fun c observed => (first.2 c observed).trans (second.2 c observed)⟩⟩

/-- The dependences of `x₀` held fixed: the conditions read at `x₀`. -/
def fixedAt (x₀ : S) : Conditions S F C :=
  ⟨D.level, D.active, D.requires x₀, D.need x₀, D.draws x₀⟩

/-- `g` depends at `x` on the same conditions, at the same levels, as at `y`. -/
def SameFor (g : F) (x y : S) : Prop :=
  (∀ c, D.requires x g c ↔ D.requires y g c) ∧ ∀ c, D.need x g c = D.need y g c

/-- `g`'s dependences do not change along the run up to `t`: at every step up to `t` they are
those of step `k`. -/
def Unchanged {P : Process S A} (r : Run P) (g : F) (k t : Nat) : Prop :=
  ∀ n, n ≤ t → D.SameFor g (r.state n) (r.state k)

end Dependence

namespace Web

variable {F C : Type} (W : Web F C)

/-- Two steps `n` and `m` are alike in what `g` couples into, each read through the dependence
of its own step. -/
def AlikeAcross (obs : F → C → Prop) (g : F) (n m : Nat) : Prop :=
  (W.Admits (W.level n) n g ↔ W.Admits (W.level m) m g) ∧ ∀ c, obs g c → W.level n c = W.level m c

variable {W}

/-- Where `g`'s dependence at `n` is the one at `t`, the levels standing at `n` are admitted at `n`
exactly as at `t`. -/
theorem admits_own_iff {g : F} {n t : Nat}
    (requires : ∀ c, W.requires n g c ↔ W.requires t g c)
    (need : ∀ c, W.need n g c = W.need t g c) :
    W.Admits (W.level n) n g ↔ W.Admits (W.level n) t g :=
  ⟨fun admitted c required =>
     Eq.subst (motive := fun d => d ≤ W.level n c) (need c) (admitted c ((requires c).mpr required)),
   fun admitted c required =>
     Eq.subst (motive := fun d => d ≤ W.level n c) (need c).symm
       (admitted c ((requires c).mp required))⟩

/-- **Testing's coupling at one step is the changing coupling** where the dependence at the two
steps compared is the one at that step. -/
theorem alikeAcross_iff_alikeThrough {obs : F → C → Prop} {g : F} {n m t : Nat}
    (requires : ∀ c, W.requires n g c ↔ W.requires t g c)
    (need : ∀ c, W.need n g c = W.need t g c)
    (requires' : ∀ c, W.requires m g c ↔ W.requires t g c)
    (need' : ∀ c, W.need m g c = W.need t g c) :
    W.AlikeAcross obs g n m ↔
      W.AlikeThrough obs g (fun _ => W.level n) (fun _ => W.level m) t :=
  ⟨fun alike => ⟨(admits_own_iff requires need).symm.trans
       (alike.1.trans (admits_own_iff requires' need')), alike.2⟩,
   fun alike => ⟨(admits_own_iff requires need).trans
       (alike.1.trans (admits_own_iff requires' need').symm), alike.2⟩⟩

end Web

namespace Dependence

variable {F C : Type} (D : Dependence S F C)

/-- **Along a run, the changing coupling is `Web.AlikeAcross`** of the run read through its
dependences. -/
theorem alikeAt_iff_alikeAcross {P : Process S A} (r : Run P) (obs : F → C → Prop) (g : F)
    (n m : Nat) :
    D.AlikeAt obs g (r.state n) (r.state m) ↔ (D.along r).AlikeAcross obs g n m :=
  Iff.rfl

end Dependence

namespace Run

variable {P : Process S A} {F C : Type}

/-- **A law through coupling that changes along the run.** Some process going alike in what `g`
couples into, each configuration read through the dependence `g` has there, admits a run's steps
before `t` exactly where any two of them `g` couples alike, by the same move, lead to configurations
`g` couples alike. -/
theorem law_through_dependence_iff (D : Dependence S F C) (r : Run P) (obs : F → C → Prop)
    (g : F) (t : Nat) :
    (∃ Q : Process S A, GoAlikeUnder Q id (D.AlikeAt obs g) ∧
        ∀ n, n < t → Q.step (r.state n) (r.act n) (r.state (n + 1))) ↔
      r.ConsistentUnder (D.AlikeAt obs g) t :=
  r.law_under_iff (D.alikeAt_equivalence obs g) t

end Run

/-! ## Reading 3: through coupling with fixed conditions -/

namespace Conditions

variable {F C : Type} (K : Conditions S F C)

/-- The levels at `x` admit `g`: they meet every requirement `g` has. It is
`Dependence.AdmitsAt` of the fixed dependence. -/
def AdmitsAt (x : S) (g : F) : Prop :=
  K.dependence.AdmitsAt x g

/-- `x` and `y` are alike in what `g` couples into: their levels admit `g` alike, and the
conditions `g` observes stand alike. It is `Dependence.AlikeAt` of the fixed dependence. -/
def AlikeAt (obs : F → C → Prop) (g : F) (x y : S) : Prop :=
  K.dependence.AlikeAt obs g x y

/-- Being alike in what `g` couples into is an equivalence. -/
theorem alikeAt_equivalence (obs : F → C → Prop) (g : F) : Equivalence (K.AlikeAt obs g) :=
  K.dependence.alikeAt_equivalence obs g

/-- **Coupling between two runs at one step is `Web.AlikeThrough`.** -/
theorem alikeThrough_iff {P : Process S A} (r r' : Run P) (obs : F → C → Prop) (g : F)
    (t : Nat) :
    (K.dependence.along r).AlikeThrough obs g (K.dependence.along r).level
        (K.dependence.along r').level t ↔
      K.AlikeAt obs g (r.state t) (r'.state t) :=
  Iff.rfl

/-- **Coupling between two steps of one run is `Web.AlikeThrough`** of the levels standing at those
steps, read at any step. -/
theorem alikeAt_iff_alikeThrough {P : Process S A} (r : Run P) (obs : F → C → Prop) (g : F)
    (n m t : Nat) :
    K.AlikeAt obs g (r.state n) (r.state m) ↔
      (K.dependence.along r).AlikeThrough obs g (fun _ => K.level (r.state n))
        (fun _ => K.level (r.state m)) t :=
  Iff.rfl

end Conditions

namespace Dependence

variable {F C : Type} (D : Dependence S F C)

/-- **Testing's coupling read at step `t` fixes the dependence of step `t`.** Between the levels
standing at two steps of the run, `Web.AlikeThrough` at `t` is the coupling through the conditions
fixed at the configuration of step `t`. -/
theorem alikeThrough_iff_fixedAt {P : Process S A} (r : Run P) (obs : F → C → Prop) (g : F)
    (n m t : Nat) :
    (D.along r).AlikeThrough obs g (fun _ => D.level (r.state n)) (fun _ => D.level (r.state m)) t ↔
      (D.fixedAt (r.state t)).AlikeAt obs g (r.state n) (r.state m) :=
  Iff.rfl

/-- Where `g`'s dependence at `x` is the one at `x₀`, admitting through it is admitting through the
dependence fixed at `x₀`. -/
theorem admitsAt_fixedAt_iff {g : F} {x x₀ : S} (same : D.SameFor g x x₀) :
    D.AdmitsAt x g ↔ (D.fixedAt x₀).AdmitsAt x g :=
  ⟨fun admitted c required =>
     Eq.subst (motive := fun d => d ≤ D.level x c) (same.2 c)
       (admitted c ((same.1 c).mpr required)),
   fun admitted c required =>
     Eq.subst (motive := fun d => d ≤ D.level x c) (same.2 c).symm
       (admitted c ((same.1 c).mp required))⟩

/-- **Fixed conditions are the instance.** -/
theorem conditions_alikeAt_iff (K : Conditions S F C) (obs : F → C → Prop) (g : F) (x y : S) :
    K.dependence.AlikeAt obs g x y ↔ K.AlikeAt obs g x y :=
  Iff.rfl

end Dependence

namespace Run

variable {P : Process S A} {F C : Type}

/-- **A law through what a formation couples into, along one run.** Some process going alike in
what `g` couples into admits a run's steps before `t` exactly where any two of them that `g`
couples alike, by the same move, lead to configurations `g` couples alike. -/
theorem law_through_coupling_iff (K : Conditions S F C) (r : Run P) (obs : F → C → Prop)
    (g : F) (t : Nat) :
    (∃ Q : Process S A, GoAlikeUnder Q id (K.AlikeAt obs g) ∧
        ∀ n, n < t → Q.step (r.state n) (r.act n) (r.state (n + 1))) ↔
      r.ConsistentUnder (K.AlikeAt obs g) t :=
  r.law_through_dependence_iff K.dependence obs g t

/-- **Fixed conditions are the instance along a run**: through fixed conditions, consistency under
the changing coupling is consistency under the fixed coupling. -/
theorem consistent_conditions_iff (K : Conditions S F C) (r : Run P) (obs : F → C → Prop) (g : F)
    (t : Nat) :
    r.ConsistentUnder (K.dependence.AlikeAt obs g) t ↔ r.ConsistentUnder (K.AlikeAt obs g) t :=
  r.consistentUnder_congr fun _ _ _ _ => Dependence.conditions_alikeAt_iff K obs g _ _

/-- **Unchanged dependences give one criterion.** Where `g`'s dependences up to `t` are those of
step `k`, the run is consistent under the changing coupling exactly where it is consistent under
the coupling fixed at step `k`. -/
theorem consistent_unchanged_iff (D : Dependence S F C) (r : Run P) (obs : F → C → Prop)
    {g : F} {k t : Nat} (unchanged : D.Unchanged r g k t) :
    r.ConsistentUnder (D.AlikeAt obs g) t ↔
      r.ConsistentUnder ((D.fixedAt (r.state k)).AlikeAt obs g) t :=
  r.consistentUnder_congr fun n m le le' =>
    ⟨fun alike => ⟨(D.admitsAt_fixedAt_iff (unchanged n le)).symm.trans
        (alike.1.trans (D.admitsAt_fixedAt_iff (unchanged m le'))), alike.2⟩,
     fun alike => ⟨(D.admitsAt_fixedAt_iff (unchanged n le)).trans
        (alike.1.trans (D.admitsAt_fixedAt_iff (unchanged m le')).symm), alike.2⟩⟩

end Run

/-! ## Witnesses -/

/-! A process on two configurations allowing every step, and the run that stays at one. -/

namespace Constant

/-- Every step is allowed. -/
def process : Process Bool Unit := everyStep Bool Unit

/-- The run that stays at `true`. -/
def run : Run process := ⟨fun _ => true, fun _ => (), fun _ => trivial⟩

/-- The staying run is consistent through the identity at every step. -/
theorem consistent (t : Nat) : run.ConsistentThrough id t :=
  fun _ _ _ _ _ _ => rfl

/-- The process does not go alike through the identity: from `true` it goes to either. -/
theorem not_goAlike : ¬ GoAlike process id :=
  fun alike => Bool.noConfusion (alike true true () true false rfl trivial trivial)

end Constant

namespace Switching

/-- The run's first two steps, read through the state, are inconsistent: from the same state by
the same move, one stays and the other changes. -/
theorem inconsistent : ¬ run.ConsistentThrough Prod.fst 2 :=
  fun consistent =>
    Bool.noConfusion (consistent 0 1 (Nat.zero_lt_succ 1) (Nat.lt_succ_self 1) rfl rfl)

end Switching

/-! One configuration has a step and the other none. -/

namespace Stuck

/-- `true` steps to itself; `false` has no step. -/
def process : Process Bool Unit := Witnesses.single Unit true true

/-- **Going alike does not give exactness.** Through the description that tells nothing apart,
the process goes alike, and its configurations do not match each other's steps. -/
theorem goAlike_not_matches :
    GoAlike process (fun _ => ()) ∧ ¬ MatchesThrough process (fun _ => ()) :=
  ⟨goAlike_const process (),
   fun matching => match matching false true () true rfl ⟨rfl, rfl⟩ with
     | ⟨_, step, _⟩ => Bool.noConfusion step.1⟩

end Stuck

namespace Coarse

/-- Coarse's configurations alike in their first bit match each other's steps. -/
theorem matching : MatchesThrough process Prod.fst :=
  fun _ _ _ u' same step' =>
    ⟨u', Eq.trans step' (congrArg (fun b => !b) same.symm), rfl⟩

/-- So its image through the first bit is an exact law. -/
theorem exact_law :
    ∃ Q : Process Bool Unit, Determined Q ∧ FactorsThrough process Prod.fst Q ∧
      ∀ s a r, Q.step s.1 a r → ∃ t, process.step s a t ∧ t.1 = r :=
  exact_law_iff.mpr ⟨goAlike, matching⟩

end Coarse

/-! ## Witness: an uncoupled level decides the next coupling -/

namespace Unseen

/-- Two levels; each step moves the second into the first and empties the second. -/
def process : Process (Nat × Nat) Unit := ⟨fun x _ y => y = (x.2, 0)⟩

/-- The first level is condition `false`, the second `true`. -/
def level (x : Nat × Nat) : Bool → Nat
  | false => x.1
  | true => x.2

/-- One formation depending on condition `false` with need 1. -/
def conditions : Conditions (Nat × Nat) Unit Bool :=
  ⟨level, fun _ _ => True, fun _ c => c = false, fun _ _ => 1, fun _ _ => False⟩

/-- The run from `(1, 1)`: `(1, 1)`, `(1, 0)`, then `(0, 0)`. -/
def state : Nat → Nat × Nat
  | 0 => (1, 1)
  | 1 => (1, 0)
  | _ + 2 => (0, 0)

/-- The run. -/
def run : Run process :=
  ⟨state, fun _ => (), fun n => match n with
    | 0 => rfl
    | 1 => rfl
    | _ + 2 => rfl⟩

/-- The process is determined. -/
theorem determined : Determined process :=
  fun _ _ _ _ first second => first.trans second.symm

/-- A configuration whose first level is at least 1 admits the formation. -/
theorem admits {x : Nat × Nat} (one : 1 ≤ x.1) : conditions.AdmitsAt x () :=
  fun _ required => Eq.subst (motive := fun d => 1 ≤ level x d) required.symm one

/-- `(0, 0)` does not admit the formation. -/
theorem not_admits_zero : ¬ conditions.AdmitsAt (0, 0) () :=
  fun admitted => Nat.not_succ_le_zero 0 (admitted false rfl)

/-- **An uncoupled level decides.** Observing nothing, the formation couples the run's first two
steps alike, and by the same move they lead to configurations it couples apart. -/
theorem inconsistent : ¬ run.ConsistentUnder (conditions.AlikeAt thresholdOnly ()) 2 :=
  fun consistent =>
    not_admits_zero ((consistent 0 1 (Nat.zero_lt_succ 1) (Nat.lt_succ_self 1)
      ⟨⟨fun _ => admits (Nat.le_refl 1), fun _ => admits (Nat.le_refl 1)⟩, fun _ nothing => False.elim nothing⟩
      rfl).1.mp (admits (Nat.le_refl 1)))

/-- So no process going alike in what the formation couples into admits the run's first two
steps, though the process is determined. -/
theorem no_law {t : Nat} (two : 2 ≤ t) :
    ¬ ∃ Q : Process (Nat × Nat) Unit, GoAlikeUnder Q id (conditions.AlikeAt thresholdOnly ()) ∧
      ∀ n, n < t → Q.step (run.state n) (run.act n) (run.state (n + 1)) :=
  fun law => inconsistent
    (((run.law_through_coupling_iff conditions thresholdOnly () t).mp law).earlier two)

/-- The formation observes condition `true`. -/
def observing : Unit → Bool → Prop := fun _ c => c = true

/-- The first configuration is coupled apart from every later one when `true` is observed. -/
theorem first_apart (m : Nat) : ¬ conditions.AlikeAt observing () (1, 1) (state (m + 1)) :=
  match m with
  | 0 => fun alike => Nat.noConfusion (alike.2 true rfl)
  | _ + 1 => fun alike => Nat.noConfusion (alike.2 true rfl)

/-- **Coupling into the deciding level restores the law along the run**, at every step. -/
theorem consistent_observing (t : Nat) :
    run.ConsistentUnder (conditions.AlikeAt observing ()) t :=
  fun n m _ _ same _ => match n, m, same with
    | 0, 0, _ => (conditions.alikeAt_equivalence observing ()).refl _
    | 0, m + 1, same => (first_apart m same).elim
    | n + 1, 0, same => (first_apart n ((conditions.alikeAt_equivalence observing ()).symm same)).elim
    | _ + 1, _ + 1, _ => (conditions.alikeAt_equivalence observing ()).refl _

end Unseen

/-! ## Witnesses: dependences that dissolve and form along one run -/

namespace Changing

/-- One level, rising by one each step. -/
def process : Process Nat Unit := ⟨fun x _ y => y = x + 1⟩

/-- The run from 0: the level at step `n` is `n`. -/
def run : Run process := ⟨fun n => n, fun _ => (), fun _ => rfl⟩

/-- The process is determined. -/
theorem determined : Determined process :=
  fun _ _ _ _ first second => first.trans second.symm

/-- The formation depends on the one condition, with need 2, only at level 0. -/
def dissolving : Dependence Nat Unit Unit :=
  ⟨fun x _ => x, fun _ _ => True, fun x _ _ => x = 0, fun _ _ _ => 2, fun _ _ _ => False⟩

/-- The formation depends on the one condition, with need 2, from level 1 on. -/
def forming : Dependence Nat Unit Unit :=
  ⟨fun x _ => x, fun _ _ => True, fun x _ _ => 1 ≤ x, fun _ _ _ => 2, fun _ _ _ => False⟩

/-- The dependence dissolves across the first step. -/
theorem dissolves : (dissolving.along run).Dissolves 0 () () :=
  ⟨rfl, fun moved => Nat.noConfusion moved⟩

/-- The dependence forms across the first step. -/
theorem forms : (forming.along run).Forms 0 () () :=
  ⟨Nat.not_succ_le_zero 0, Nat.le_refl 1⟩

theorem dissolving_not_admits_zero : ¬ dissolving.AdmitsAt 0 () :=
  fun admitted => Nat.not_succ_le_zero 1 (admitted () rfl)

theorem dissolving_admits_succ (n : Nat) : dissolving.AdmitsAt (n + 1) () :=
  fun _ required => Nat.noConfusion required

/-- **A dissolving dependence carries a law at the changing coupling**, at every step. -/
theorem dissolving_consistent (t : Nat) :
    run.ConsistentUnder (dissolving.AlikeAt thresholdOnly ()) t :=
  fun n m _ _ same _ => match n, m, same with
    | 0, 0, _ => (dissolving.alikeAt_equivalence thresholdOnly ()).refl _
    | 0, m + 1, same => absurd (same.1.mpr (dissolving_admits_succ m)) dissolving_not_admits_zero
    | n + 1, 0, same => absurd (same.1.mp (dissolving_admits_succ n)) dissolving_not_admits_zero
    | n + 1, m + 1, _ =>
      ⟨⟨fun _ => dissolving_admits_succ (m + 1), fun _ => dissolving_admits_succ (n + 1)⟩,
       fun _ nothing => nothing.elim⟩

/-- **The coupling fixed at the start lacks it.** Through the dependence of level 0 held fixed, the
first two steps start alike (neither level admits) and lead to levels 1 and 2, coupled apart. -/
theorem dissolving_fixed_inconsistent :
    ¬ run.ConsistentUnder ((dissolving.fixedAt (run.state 0)).AlikeAt thresholdOnly ()) 2 :=
  fun consistent =>
    have below : ∀ x, x < 2 → ¬ (dissolving.fixedAt 0).AdmitsAt x () :=
      fun _ low admitted => Nat.not_le_of_lt low (admitted () rfl)
    have two : (dissolving.fixedAt 0).AdmitsAt 2 () := fun _ _ => Nat.le_refl 2
    below 1 (Nat.lt_succ_self 1)
      ((consistent 0 1 (Nat.zero_lt_succ 1) (Nat.lt_succ_self 1)
        ⟨⟨fun admitted => absurd admitted (below 0 (Nat.zero_lt_succ 1)),
          fun admitted => absurd admitted (below 1 (Nat.lt_succ_self 1))⟩,
         fun _ nothing => nothing.elim⟩ rfl).1.mpr two)

theorem forming_admits_zero : forming.AdmitsAt 0 () :=
  fun _ required => absurd required (Nat.not_succ_le_zero 0)

theorem forming_not_admits_one : ¬ forming.AdmitsAt 1 () :=
  fun admitted => Nat.not_succ_le_self 1 (admitted () (Nat.le_refl 1))

theorem forming_admits_three : forming.AdmitsAt 3 () :=
  fun _ _ => Nat.le_succ 2

/-- **A forming dependence breaks a law at the changing coupling.** Steps 0 and 2 start alike
(both levels admit) and lead to levels 1 and 3, coupled apart. -/
theorem forming_inconsistent : ¬ run.ConsistentUnder (forming.AlikeAt thresholdOnly ()) 3 :=
  fun consistent =>
    forming_not_admits_one
      ((consistent 0 2 (Nat.zero_lt_succ 2) (Nat.lt_succ_self 2)
        ⟨⟨fun _ => fun _ _ => Nat.le_refl 2, fun _ => forming_admits_zero⟩,
         fun _ nothing => nothing.elim⟩ rfl).1.mpr forming_admits_three)

/-- **The coupling fixed at the start has it**, at every step: through the dependence of level 0
held fixed, the formation depends on nothing, and every two configurations are coupled alike. -/
theorem forming_fixed_consistent (t : Nat) :
    run.ConsistentUnder ((forming.fixedAt (run.state 0)).AlikeAt thresholdOnly ()) t :=
  have every : ∀ x, (forming.fixedAt 0).AdmitsAt x () :=
    fun _ _ required => absurd required (Nat.not_succ_le_zero 0)
  fun _ _ _ _ _ _ => ⟨⟨fun _ => every _, fun _ => every _⟩, fun _ nothing => nothing.elim⟩

/-- So no process going alike at the changing coupling admits the forming run's steps before 3,
though the process is determined. -/
theorem forming_no_law {t : Nat} (three : 3 ≤ t) :
    ¬ ∃ Q : Process Nat Unit, GoAlikeUnder Q id (forming.AlikeAt thresholdOnly ()) ∧
      ∀ n, n < t → Q.step (run.state n) (run.act n) (run.state (n + 1)) :=
  fun law => forming_inconsistent
    (((run.law_through_dependence_iff forming thresholdOnly () t).mp law).earlier three)

/-- And no process going alike at the coupling fixed at the start admits the dissolving run's steps
before 2. -/
theorem dissolving_fixed_no_law {t : Nat} (two : 2 ≤ t) :
    ¬ ∃ Q : Process Nat Unit,
        GoAlikeUnder Q id ((dissolving.fixedAt (run.state 0)).AlikeAt thresholdOnly ()) ∧
      ∀ n, n < t → Q.step (run.state n) (run.act n) (run.state (n + 1)) :=
  fun law => dissolving_fixed_inconsistent
    (((run.law_through_coupling_iff (dissolving.fixedAt (run.state 0)) thresholdOnly () t).mp
      law).earlier two)

end Changing

end Becoming
