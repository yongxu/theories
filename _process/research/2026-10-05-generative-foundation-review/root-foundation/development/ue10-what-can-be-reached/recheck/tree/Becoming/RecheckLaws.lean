import Becoming.ReachableRanges

/-!
# UE10 re-check probes, part 2: premises, instances and readings

Probes of the revised `Becoming.ReachableRanges` (re-check RECHECK-UE10.md). Not proposed for
landing as written.

* R11–R14: what `Reaching.not_above_wider_now` needs: for widening what can be reached only that
  the configuration admitting more now starts a course; for the lexical order both chosen courses
  starting at their configurations.
* R15: inclusion now does not give covering (covering is inside inclusion now, not around it).
* R16: the converse of `Web.KeepsWidening.chain`, so keeping widening by name is exactly keeping
  widening of the chain.
* R17: on a determined process the lagged order is the strict part of range inclusion joined to
  the lag part; with fixed conditions the lag part is UE9's `Web.WidensWithLag` by `Iff.rfl`, and
  UE9's order lies inside the lagged order.
* R18: a configuration starting no course is covered by every configuration.
* R19: `Law.runs_agree` from Branching's `law_run_state`, which the module's closure holds.
* R20: `KeptTogether.no_comparison_through_bundles` needs its irreflexivity, and holds of its
  witness, not of every process.
* R21: the converse of `Reaching.lexical_above`, with the inclusions decided.
* R22: on a determined process with realized courses not starting at their configurations,
  realized widening and widening what can be reached can conflict.
-/

namespace Becoming

namespace RecheckUE10

open Generative

universe u v

/-! ## R11–R14. The premises of `not_above_wider_now` -/

section Premises

variable {S : Type u} {A : Type v} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-- **R11.** For widening what can be reached it suffices that `s'` starts a course; no course is
read as realized. -/
theorem not_widens_of_wider_now {s s' : S} {r' : Run P} (start' : r'.state 0 = s') {x : X}
    (now : adm s' x) (notNow : ¬ adm s x) : ¬ Reaching.Widens P adm s s' :=
  fun widens => notNow (widens.1.now start' now)

end Premises

/-! Three configurations under the identity law: `lo` admits nothing, `mid` formation `0`, `hi`
formations `0` and `1`. -/

namespace Three

inductive Config
  | lo
  | mid
  | hi

def process : Process Config Unit := Law.process id

def adm : Config → Nat → Prop
  | .lo, _ => False
  | .mid, x => x = 0
  | .hi, x => x ≤ 1

/-- Staying at `c`. -/
def stay (c : Config) : Run process := ⟨fun _ => c, fun _ => (), fun _ => rfl⟩

theorem hi_widens_mid_range : (stay .hi).RangeWidens adm (stay .mid) :=
  ⟨fun _ _ zero => Eq.subst (motive := fun y => y ≤ 1) (zero : _ = 0).symm (Nat.zero_le 1),
   0, 1, Nat.le_refl 1, fun one => Nat.noConfusion (one : (1 : Nat) = 0)⟩

/-- `lo`'s course read as realized runs at `hi`; the others stay. -/
def offStart : Config → Run process
  | .lo => stay .hi
  | .mid => stay .mid
  | .hi => stay .hi

/-- **R12.** Without `lo`'s course starting at `lo`, the lexical order ranks `lo` above `mid`,
which admits now what `lo` does not. -/
theorem start_needed :
    adm .mid 0 ∧ ¬ adm .lo 0 ∧ (offStart .mid).state 0 = .mid ∧
      Reaching.Lexical process adm offStart .lo .mid :=
  ⟨rfl, id, rfl, .inl hi_widens_mid_range⟩

/-- `hi`'s course read as realized runs at `lo`; the others stay. -/
def offStart' : Config → Run process
  | .lo => stay .lo
  | .mid => stay .mid
  | .hi => stay .lo

/-- **R13.** Without `hi`'s course starting at `hi`, the lexical order ranks `mid` above `hi`,
which admits now what `mid` does not. -/
theorem start'_needed :
    adm .hi 1 ∧ ¬ adm .mid 1 ∧ (offStart' .mid).state 0 = .mid ∧
      Reaching.Lexical process adm offStart' .mid .hi :=
  ⟨Nat.le_refl 1, fun one => Nat.noConfusion (one : (1 : Nat) = 0), rfl,
   .inl ⟨fun _ _ no => (no : False).elim, 0, 0, rfl, id⟩⟩

/-- `hi`'s course read as realized runs at `mid`, and `mid`'s at `hi`. -/
def swapped : Config → Run process
  | .lo => stay .lo
  | .mid => stay .hi
  | .hi => stay .mid

/-- **R22.** On a determined process, with realized courses not starting at their
configurations, realized widening ranks `mid` above `hi` while `hi` widens what can be reached
over `mid`: no strict partial order contains both. With the courses starting there, realized
widening gives widening what can be reached (`Reaching.widens_of_rangeWidens`), so the
module's "a determined process gives no such conflict" needs that premise. -/
theorem conflict_without_start {R : Config → Config → Prop} (irrefl : ∀ a, ¬ R a a)
    (trans : ∀ {a b c}, R a b → R b c → R a c)
    (realizedWidening : ∀ {a b}, (swapped a).RangeWidens adm (swapped b) → R a b)
    (reaching : ∀ {a b}, Reaching.Widens process adm a b → R a b) : False :=
  irrefl _ (trans (realizedWidening (a := .mid) (b := .hi) hi_widens_mid_range)
    (reaching (Reaching.widens_of_rangeWidens Law.runs_agree (r := stay .hi) (r' := stay .mid)
      rfl rfl hi_widens_mid_range)))

end Three

/-- **R14.** Without a course from the configuration admitting more now, widening what can be
reached ranks the other above it (the module's `NoCourse`). -/
theorem widens_without_course :
    Reaching.Widens NoCourse.process NoCourse.adm true false ∧ NoCourse.adm false 0 ∧
      ¬ NoCourse.adm true 0 :=
  ⟨NoCourse.widens_reversed.1, trivial, id⟩

/-! ## R15. Covering lies inside inclusion now, not around it -/

/-- **R15.** On `WiderNow`, what the climb admits now `none` admits now, yet `none` does not
cover the climb: inclusion now does not give covering. -/
theorem inclusion_now_not_covering :
    (∀ x, WiderNow.adm (some 0) x → WiderNow.adm none x) ∧
      ¬ Reaching.Covers WiderNow.process WiderNow.adm none (some 0) :=
  ⟨fun _ le => Nat.le_trans le (Nat.zero_le 1),
   fun covers => match covers (WiderNow.course (some 0)) rfl with
    | ⟨r, start, includes⟩ => Nat.not_succ_le_self 1
        (Eq.subst (motive := fun c => WiderNow.adm c 2)
          (Law.runs_agree r (WiderNow.course none) start 2) (includes 2 2 (Nat.le_refl 2)))⟩

/-! ## R16. Keeping widening by name is exactly keeping widening of the chain -/

section Chains

variable {F C : Type} {W : Web F C} {l : Nat → C → Nat}

/-- **R16.** The converse of `Web.KeepsWidening.chain`. -/
theorem keepsWidening_of_chain {T : Nat}
    (chain : Reaching.KeepsWidening (fun n f => W.Admits (l (T + n)) (T + n) f)) :
    W.KeepsWidening Web.itself l T :=
  ⟨fun _ U from_ le => (Web.includesAcross_itself_iff le).mpr fun f admitted =>
     match Web.exists_steps_between from_, Web.exists_steps_between le with
     | ⟨n, atS⟩, ⟨d, atU⟩ =>
       have here : W.Admits (l (T + n)) (T + n) f :=
         Eq.subst (motive := fun m => W.Admits (l m) m f) atS admitted
       have there : T + (n + d) = U :=
         (Nat.add_assoc T n d).symm.trans ((congrArg (· + d) atS).symm.trans atU.symm)
       Eq.subst (motive := fun m => W.Admits (l m) m f) there (chain.1 n d f here),
   fun S from_ => match Web.exists_steps_between from_ with
    | ⟨n, atS⟩ => match chain.2 n with
      | ⟨d, g, now, before⟩ =>
        ⟨S + d, Nat.le_add_right S d, (Web.exceedsAcross_itself_iff (Nat.le_add_right S d)).mpr
          ⟨g, Eq.subst (motive := fun m => W.Admits (l m) m g)
              ((Nat.add_assoc T n d).symm.trans (congrArg (· + d) atS).symm) now,
           fun admitted => before
             (Eq.subst (motive := fun m => W.Admits (l m) m g) atS admitted)⟩⟩⟩

/-- **R16.** Keeping widening by name from `T` is keeping widening of the chain from `T`. -/
theorem keepsWidening_iff_chain {T : Nat} :
    W.KeepsWidening Web.itself l T ↔
      Reaching.KeepsWidening (fun n f => W.Admits (l (T + n)) (T + n) f) :=
  ⟨Web.KeepsWidening.chain, keepsWidening_of_chain⟩

end Chains

/-! ## R17. The lagged order on a determined process -/

section Determined

variable {S : Type} {A : Type} {X : Type} {P : Process S A} {adm : S → X → Prop}

theorem coversLater_iff_of_unique
    (unique : ∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t)
    {s s' : S} {r r' : Run P} (start : r.state 0 = s) (start' : r'.state 0 = s') (d : Nat) :
    Reaching.CoversLater P adm d s s' ↔ ∀ t x, adm (r'.state t) x → adm (r.state (t + d)) x :=
  ⟨fun covers => match covers r' start' with
    | ⟨q, qstart, later⟩ => fun t x admitted =>
        Eq.subst (motive := fun y => adm y x) (unique q r (qstart.trans start.symm) (t + d))
          (later t x admitted),
   fun later q' q'start => ⟨r, start, fun t x admitted =>
     later t x (Eq.subst (motive := fun y => adm y x) (unique q' r' (q'start.trans start'.symm) t)
       admitted)⟩⟩

/-- **R17.** On a determined process the lagged order is the strict part of range inclusion of
the two courses joined to the strict part of their inclusion with some lag. -/
theorem widensOrLater_iff_of_unique
    (unique : ∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t)
    {s s' : S} {r r' : Run P} (start : r.state 0 = s) (start' : r'.state 0 = s') :
    Reaching.WidensOrLater P adm s s' ↔
      (r.RangeIncludes adm r' ∧ ¬ r'.RangeIncludes adm r) ∨
        ((∃ d, ∀ t x, adm (r'.state t) x → adm (r.state (t + d)) x) ∧
          ¬ ∃ d, ∀ t x, adm (r.state t) x → adm (r'.state (t + d)) x) :=
  have w := Reaching.widens_iff_of_unique (adm := adm) unique start start'
  have c := fun d => coversLater_iff_of_unique (adm := adm) unique start start' d
  have c' := fun d => coversLater_iff_of_unique (adm := adm) unique start' start d
  ⟨fun | .inl widens => .inl (w.mp widens)
       | .inr ⟨⟨d, later⟩, notBack⟩ =>
         .inr ⟨⟨d, (c d).mp later⟩, fun ⟨e, back⟩ => notBack ⟨e, (c' e).mpr back⟩⟩,
   fun | .inl strict => .inl (w.mpr strict)
       | .inr ⟨⟨d, later⟩, notBack⟩ =>
         .inr ⟨⟨d, (c d).mpr later⟩, fun ⟨e, back⟩ => notBack ⟨e, (c' e).mp back⟩⟩⟩

/-- **R17.** With fixed conditions, the lag part on two courses is UE9's widening with a lag of
their levels, by definition. -/
theorem lagPart_conditions_iff {F C : Type} (K : Conditions S F C) (r r' : Run P) :
    ((∃ d, ∀ t x, K.dependence.AdmitsAt (r'.state t) x →
        K.dependence.AdmitsAt (r.state (t + d)) x) ∧
      ¬ ∃ d, ∀ t x, K.dependence.AdmitsAt (r.state t) x →
        K.dependence.AdmitsAt (r'.state (t + d)) x) ↔
      (K.dependence.along r).WidensWithLag (K.dependence.along r).level
        (K.dependence.along r').level :=
  Iff.rfl

/-- **R17.** On a determined process with fixed conditions, the lagged order is UE9's lagged order
of the two courses' levels with its first part read as the strict part of inclusion. -/
theorem widensOrLater_conditions_iff_of_unique {F C : Type} (K : Conditions S F C)
    (unique : ∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t)
    {s s' : S} {r r' : Run P} (start : r.state 0 = s) (start' : r'.state 0 = s') :
    Reaching.WidensOrLater P K.dependence.AdmitsAt s s' ↔
      ((K.dependence.along r).Includes (K.dependence.along r).level (K.dependence.along r').level ∧
          ¬ (K.dependence.along r).Includes (K.dependence.along r').level
            (K.dependence.along r).level) ∨
        (K.dependence.along r).WidensWithLag (K.dependence.along r).level
          (K.dependence.along r').level :=
  widensOrLater_iff_of_unique unique start start'

/-- **R17.** UE9's lagged order of the two courses' levels lies inside the lagged order; the
converse needs exceeding decided. -/
theorem widensOrLater_of_widensOrWithLag {F C : Type} (K : Conditions S F C)
    (unique : ∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t)
    {s s' : S} {r r' : Run P} (start : r.state 0 = s) (start' : r'.state 0 = s')
    (ue9 : (K.dependence.along r).WidensOrWithLag (K.dependence.along r).level
      (K.dependence.along r').level) :
    Reaching.WidensOrLater P K.dependence.AdmitsAt s s' :=
  (widensOrLater_conditions_iff_of_unique K unique start start').mpr (match ue9 with
    | .inl ⟨includes, t, f, yes, no⟩ => .inl ⟨includes, fun back => no (back t f yes)⟩
    | .inr lag => .inr lag)

end Determined

/-! ## R18. A configuration starting no course is covered by every configuration -/

/-- **R18.** -/
theorem covers_of_no_course {S : Type u} {A : Type v} {X : Type} {P : Process S A}
    {adm : S → X → Prop} {s s' : S} (none : ∀ r : Run P, r.state 0 = s' → False) :
    Reaching.Covers P adm s s' :=
  fun r' start' => (none r' start').elim

/-! ## R19. `Law.runs_agree` is the two-run form of `Branching.law_run_state` -/

/-- **R19.** Proved from Branching's `law_run_state`, which the module's import closure holds. -/
theorem runs_agree_of_orbit {S : Type u} {next : S → S} (q q' : Run (Law.process next))
    (start : q.state 0 = q'.state 0) (t : Nat) : q.state t = q'.state t :=
  (Branching.law_run_state q t).trans
    ((congrArg (fun z => Law.orbit next z t) start).trans (Branching.law_run_state q' t).symm)

/-! ## R20. The scope of `KeptTogether.no_comparison_through_bundles` -/

/-- **R20a.** Without irreflexivity the law fails: a constant description is determined by the
bundles, and the comparison holding everywhere satisfies C on `KeptTogether`'s reachable ranges. -/
theorem bundles_need_irreflexive :
    (∀ a b, (∀ n bundle, WithinMoves KeptTogether.process KeptTogether.adm a n bundle ↔
        WithinMoves KeptTogether.process KeptTogether.adm b n bundle) →
        (fun _ => ()) a = (fun (_ : KeptTogether.Config) => ()) b) ∧
      Comparison (Reaching.reachFrame KeptTogether.process KeptTogether.adm) (fun _ => True)
        (fun s t => (fun (_ _ : Unit) => True) ((fun _ => ()) s) ((fun _ => ()) t)) :=
  ⟨fun _ _ _ => rfl, fun _ _ _ => trivial⟩

/-- **R20b.** On a process of one configuration every comparison, read off any description (here
the identity, which the bundles determine), satisfies C on the reachable ranges, an irreflexive
one included, since no configuration extends another: the law is its witness's, not every
process's. -/
theorem one_configuration_comparison (compare : Unit → Unit → Prop) :
    Comparison (Reaching.reachFrame AllAtOnce.process AllAtOnce.adm) (fun _ => True)
      (fun s t => compare (id s) (id t)) :=
  fun s t extension => match s, t with
    | (), () => (Extension.irrefl extension).elim

/-! ## R21. The converse of `lexical_above`, with the inclusions decided -/

section LexicalConverse

variable {S : Type} {A : Type} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-- **R21.** Where the realized inclusion back is decided against a witness of exceeding, and
covering back against a course from `s` no course from `s'` includes, the package's two-tier
order gives the lexical order. -/
theorem lexical_of_above_decided {course : S → Run P} {s s' : S}
    (realizedDecided : (course s').RangeIncludes adm (course s) ∨
      (course s).RangeExceeds adm (course s'))
    (reachDecided : Reaching.Covers P adm s' s ∨
      ∃ r : Run P, r.state 0 = s ∧ ∀ r' : Run P, r'.state 0 = s' → ¬ r'.RangeIncludes adm r)
    (above : Lexical.Above (Reaching.realizedClaims course adm) (Reaching.reachableRanges P adm)
      s s') : Reaching.Lexical P adm course s s' :=
  match above with
  | .inl ⟨includes, notBack⟩ => match realizedDecided with
    | .inl back => (notBack fun p held => back p.1 p.2 held).elim
    | .inr exceeds => .inl ⟨fun t x held => includes (t, x) held, exceeds⟩
  | .inr ⟨includes, back, kept, notKept⟩ => match reachDecided with
    | .inl covers => (notKept (Reaching.covers_iff_included.mp covers)).elim
    | .inr unmatched => .inr ⟨fun t x held => includes (t, x) held,
        fun t x held => back (t, x) held, Reaching.covers_iff_included.mpr kept, unmatched⟩

end LexicalConverse

end RecheckUE10

end Becoming
