import Becoming.Learning
import Becoming.Mechanism

/-!
# Readout: what a reduction keeps of an observable and of a law

A reduction `π : S → K` drops part of a configuration. This module states, for every reduction,
when an observable and a law of change can still be read from what it keeps.

* **Observables.** What an observable `f` reads through `π` is single-valued exactly where `f`
  goes alike across what `π` merges (`reading_single_iff`, with `Learning.Lumped`). A decoder
  of the reduced value forces this (`lumped_of_decodes`); where `π` has a section, it is also
  enough (`decodes_iff_of_section`). On two configurations `π` merges, a decoder agreeing with
  `f` at both exists exactly when `f` agrees there (`decoder_pair_iff`); in particular `π` has no
  inverse on two different configurations it merges (`no_restore`).
* **Judging a listed family.** A judge reading only the reduced value gives an observable at
  every member of a listed family exactly when the observable goes alike across the members the
  reduction merges (`judges_iff_lumpedOn`); the judge answers with the first listed member of each
  reduced value, so no choice is used. So no judge reads through a reduction that merges two
  members the observable tells apart (`no_judge_of_merged`).
* **Readings through parts.** Where every reading of a family reads a configuration only through
  its parts and each part is read directly by some reading, two configurations agree under every
  reading exactly where they agree at every part (`agree_iff_parts`). So a replacement whose
  readings are the readings of a configuration supplied from it agrees with the original under
  every reading exactly where it supplies every part (`supplied_agree_iff_parts`).
* **Futures through a reduction.** For a law that need not be determined, the law read through
  a reduction (`Image` of `Becoming.Mechanism`) takes from each reduced value exactly the words the configuration can
  take, for every configuration, exactly when configurations the reduction merges can take the
  same words (`futures_through_iff`).
* **Fallible witnesses.** A complete report of listed witnesses, some at fault, reduces an
  answer. For two different answers, no report is explained both by the one with some witnesses
  at fault and by the other with others at fault exactly where some witness is in neither fault
  set (`no_common_report_iff`); under admitted envelopes of fault sets, exactly where every two
  fault sets admitted for the two answers leave a common faithful witness
  (`no_common_report_envelopes_iff`). Where every witness is in one of them, the report blaming
  one set explains both (`blame`).
* **Laws.** For a law of change with moves, some determined law on the reduced values carries
  every step exactly when configurations `π` merges are taken by each move to configurations it
  merges (`law_through_iff`, the core's `carries_law_iff` read on `Assurance.ofMap`). A reduced
  law that commutes with every move commutes with every course of moves (`foldl_semiconj`).

No premise is added; every declaration has an empty axiom report.
-/

namespace Becoming.Readout

open Generative Becoming.Learning Becoming.Assurance

universe u v w x

variable {S : Type u} {K : Type v} {V : Type w}

/-! ## Observables -/

/-- What `f` reads through `π`: `f` takes the value `v` at some configuration `π` sends to `k`. -/
def Reading (π : S → K) (f : S → V) (k : K) (v : V) : Prop := ∃ s, π s = k ∧ f s = v

/-- A relation that gives at most one value. -/
def SingleValued (R : K → V → Prop) : Prop := ∀ k v v', R k v → R k v' → v = v'

/-- **What an observable reads through a reduction is single-valued exactly where the
observable goes alike across what the reduction merges.** -/
theorem reading_single_iff {π : S → K} {f : S → V} :
    SingleValued (Reading π f) ↔ Lumped π f :=
  ⟨fun single s s' same => single (π s) (f s) (f s') ⟨s, rfl, rfl⟩ ⟨s', same.symm, rfl⟩,
   fun lumped _ _ _ ⟨s, at_k, to_v⟩ ⟨s', at_k', to_v'⟩ =>
    to_v.symm.trans ((lumped s s' (at_k.trans at_k'.symm)).trans to_v')⟩

/-- `g` decodes `f` from the reduced value. -/
def Decodes (π : S → K) (f : S → V) (g : K → V) : Prop := ∀ s, f s = g (π s)

/-- A decoder exists only where the observable goes alike across what is merged. -/
theorem lumped_of_decodes {π : S → K} {f : S → V} {g : K → V} (decodes : Decodes π f g) :
    Lumped π f :=
  fun s s' same => (decodes s).trans ((congrArg g same).trans (decodes s').symm)

/-- **Where the reduction has a section, a decoder exists exactly where the observable goes alike
across what is merged.** -/
theorem decodes_iff_of_section {π : S → K} {f : S → V} (sec : K → S)
    (back : ∀ k, π (sec k) = k) : (∃ g, Decodes π f g) ↔ Lumped π f :=
  ⟨fun ⟨_, decodes⟩ => lumped_of_decodes decodes,
   fun lumped => ⟨fun k => f (sec k), fun s => lumped s (sec (π s)) (back (π s)).symm⟩⟩

/-- **On two configurations the reduction merges, a decoder agreeing with the observable at both
exists exactly when the observable agrees there.** -/
theorem decoder_pair_iff {π : S → K} {f : S → V} {s s' : S} (merged : π s = π s') :
    (∃ g : K → V, g (π s) = f s ∧ g (π s') = f s') ↔ f s = f s' :=
  ⟨fun ⟨g, at_s, at_s'⟩ => at_s.symm.trans ((congrArg g merged).trans at_s'),
   fun same => ⟨fun _ => f s, rfl, same⟩⟩

/-- A reduction has no inverse on two different configurations it merges. -/
theorem no_restore {π : S → K} {s s' : S} (merged : π s = π s') (different : s ≠ s') :
    ¬ ∃ restore : K → S, restore (π s) = s ∧ restore (π s') = s' :=
  fun found => different ((decoder_pair_iff (f := fun x => x) merged).mp found)

/-! ## Laws through a reduction -/

variable {A : Type x}

/-- **Some determined law on the reduced values carries every step of a law of change exactly
when the configurations the reduction merges are taken by each move to configurations it
merges.** -/
theorem law_through_iff (next : S → A → S) (π : S → K) :
    (∃ Q : Process K A, Determined Q ∧ FactorsThrough (ofMap next) π Q) ↔
      ∀ s s' a, π s = π s' → π (next s a) = π (next s' a) :=
  carries_law_iff.trans
    ⟨fun alike s s' a same => alike s s' a (next s a) (next s' a) same rfl rfl,
     fun every s s' a u u' same step step' =>
      have to_u : u = next s a := step
      have to_u' : u' = next s' a := step'
      to_u ▸ to_u' ▸ every s s' a same⟩

/-- **A reduced law that commutes with every move commutes with every course of moves.** -/
theorem foldl_semiconj (next : S → A → S) (π : S → K) (reduced : K → A → K)
    (commutes : ∀ s a, π (next s a) = reduced (π s) a) :
    ∀ (plan : List A) (s : S), π (plan.foldl next s) = plan.foldl reduced (π s)
  | [], _ => rfl
  | a :: rest, s =>
    (foldl_semiconj next π reduced commutes rest (next s a)).trans
      (congrArg (fun k => rest.foldl reduced k) (commutes s a))

/-! ## Futures through a reduction -/

section Futures

/-- The same words can be taken from both configurations. -/
def SameFutures (P : Process S A) (s s' : S) : Prop :=
  ∀ word, Feasible P s word ↔ Feasible P s' word

theorem image_feasible {P : Process S A} {π : S → K} {s : S} {word : List A} :
    Feasible P s word → Feasible (Image P π) (π s) word
  | ⟨t, path⟩ => ⟨π t, trace_map (Q := Image P π) (f := π) (fun s _ t step => ⟨s, t, rfl, step, rfl⟩) path⟩

theorem feasible_of_image {P : Process S A} {π : S → K}
    (fibers : ∀ s s', π s = π s' → SameFutures P s s') :
    ∀ {s : S} {word : List A}, Feasible (Image P π) (π s) word → Feasible P s word
  | s, [], _ => ⟨s, .nil s⟩
  | s, a :: word, ⟨_, .cons ⟨s₁, t₁, here, step, there⟩ rest⟩ =>
    have rest : Feasible (Image P π) (π t₁) word :=
      ⟨_, Eq.subst (motive := fun k => Trace (Image P π) k word _) there.symm rest⟩
    let ⟨u, path⟩ := feasible_of_image fibers rest
    (fibers s₁ s here (a :: word)).mp ⟨u, .cons step path⟩

/-- **A reduction carries the futures exactly where it merges only configurations with the same
futures.** From the reduced value of each configuration the law read through `π` takes exactly
the words the configuration can take, for every configuration, exactly when configurations `π`
merges can take the same words. The nondeterministic counterpart of `law_through_iff`. -/
theorem futures_through_iff {P : Process S A} {π : S → K} :
    (∀ s word, Feasible (Image P π) (π s) word ↔ Feasible P s word) ↔
      ∀ s s', π s = π s' → SameFutures P s s' :=
  ⟨fun exact s s' same word => (exact s word).symm.trans
      ((Eq.subst (motive := fun k => Feasible (Image P π) k word ↔ Feasible (Image P π) (π s') word)
        same.symm Iff.rfl).trans (exact s' word)),
   fun fibers _ _ => ⟨feasible_of_image fibers, image_feasible⟩⟩

end Futures

/-! ## Fallible witnesses -/

section Witnesses

variable {D : Type} [DecidableEq D]

/-- A complete report of a listed roster of witnesses explains the answer `x` with the witnesses
in `bad` at fault: every witness of the roster outside `bad` reports `x`. -/
def Explains (roster bad : List D) (x : Bool) (report : D → Bool) : Prop :=
  ∀ d ∈ roster, ¬ d ∈ bad → report d = x

/-- A witness of the roster outside both fault sets. -/
def CommonWitness (roster a b : List D) : Prop :=
  ∃ d, d ∈ roster ∧ ¬ d ∈ a ∧ ¬ d ∈ b

/-- Going through the roster: a witness outside both fault sets, or every witness outside `b`
is in `a`. -/
theorem commonWitness_or_covered (a b : List D) :
    ∀ roster : List D, CommonWitness roster a b ∨ ∀ d ∈ roster, ¬ d ∈ b → d ∈ a
  | [] => .inr fun _ mem _ => nomatch mem
  | d :: tail => match commonWitness_or_covered a b tail with
    | .inl ⟨w, mem, na, nb⟩ => .inl ⟨w, .tail d mem, na, nb⟩
    | .inr covered => match decideMem d a, decideMem d b with
      | .isTrue inA, _ => .inr fun w mem nb => match mem_cons_cases mem with
        | .inl same => Eq.subst (motive := fun v => v ∈ a) same.symm inA
        | .inr mem => covered w mem nb
      | .isFalse _, .isTrue inB => .inr fun w mem nb => match mem_cons_cases mem with
        | .inl same => absurd (Eq.subst (motive := fun v => v ∈ b) same.symm inB) nb
        | .inr mem => covered w mem nb
      | .isFalse na, .isFalse nb => .inl ⟨d, .head tail, na, nb⟩

/-- `y` where a decision holds, `x` where it fails. -/
def pick {p : Prop} : Decidable p → Bool → Bool → Bool
  | .isTrue _, y, _ => y
  | .isFalse _, _, x => x

theorem pick_of {p : Prop} (h : p) : ∀ (d : Decidable p) (y x : Bool), pick d y x = y
  | .isTrue _, _, _ => rfl
  | .isFalse no, _, _ => absurd h no

theorem pick_of_not {p : Prop} (h : ¬ p) : ∀ (d : Decidable p) (y x : Bool), pick d y x = x
  | .isTrue yes, _, _ => absurd yes h
  | .isFalse _, _, _ => rfl

/-- The report blaming the witnesses in `a`: they report `y`, the others `x`. -/
def blame (a : List D) (x y : Bool) (d : D) : Bool :=
  pick (decideMem d a) y x

/-- **Fallible witnesses tell two answers apart exactly where their fault sets leave a common
faithful witness.** For different answers, no complete report is explained both by `x` with the
witnesses in `a` at fault and by `y` with those in `b` at fault exactly where some witness of the
roster is in neither. Where every witness is in one of them, the report blaming `a` explains
both. -/
theorem no_common_report_iff {roster a b : List D} {x y : Bool} (different : x ≠ y) :
    (∀ report : D → Bool, Explains roster a x report → ¬ Explains roster b y report) ↔
      CommonWitness roster a b :=
  ⟨fun apart => match commonWitness_or_covered a b roster with
    | .inl common => common
    | .inr covered => absurd (fun d mem nb => pick_of (covered d mem nb) (decideMem d a) y x)
        (apart (blame a x y) fun d _ na => pick_of_not na (decideMem d a) y x),
   fun ⟨d, mem, na, nb⟩ _ first second => different ((first d mem na).symm.trans (second d mem nb))⟩

/-- **With admitted fault envelopes.** No complete report is explained both by `x` under a fault
set admitted in `fa` and by `y` under one admitted in `fb` exactly where every two such fault
sets leave a common faithful witness. -/
theorem no_common_report_envelopes_iff {roster : List D} {fa fb : List (List D)} {x y : Bool}
    (different : x ≠ y) :
    (∀ report : D → Bool, (∃ a, a ∈ fa ∧ Explains roster a x report) →
        ¬ ∃ b, b ∈ fb ∧ Explains roster b y report) ↔
      ∀ a, a ∈ fa → ∀ b, b ∈ fb → CommonWitness roster a b :=
  ⟨fun apart a ma b mb => (no_common_report_iff different).mp
      fun report first second => apart report ⟨a, ma, first⟩ ⟨b, mb, second⟩,
   fun cross report ⟨a, ma, first⟩ ⟨b, mb, second⟩ =>
      (no_common_report_iff different).mpr (cross a ma b mb) report first second⟩

end Witnesses

/-! ## Judging a listed family through a reduction -/

section Judges

/-- `f` goes alike across the members of `family` that `π` merges. -/
def LumpedOn (family : List S) (π : S → K) (f : S → V) : Prop :=
  ∀ s s', s ∈ family → s' ∈ family → π s = π s' → f s = f s'

/-- `judge`, reading only the reduced value, gives `f` at every member of `family`. -/
def Judges (family : List S) (π : S → K) (f : S → V) (judge : K → V) : Prop :=
  ∀ s, s ∈ family → judge (π s) = f s

/-- A judge exists only where `f` goes alike across the members `π` merges. -/
theorem lumpedOn_of_judges {family : List S} {π : S → K} {f : S → V} {judge : K → V}
    (judges : Judges family π f judge) : LumpedOn family π f :=
  fun s s' mem mem' same => (judges s mem).symm.trans ((congrArg judge same).trans (judges s' mem'))

/-- A member of a listed family is its first member or a member of the rest. -/
theorem member_cons_cases {x s : S} {rest : List S} : s ∈ x :: rest → s = x ∨ s ∈ rest
  | .head _ => .inl rfl
  | .tail _ later => .inr later

variable [DecidableEq K]

/-- The judge answering with `f` at the first listed member of the reduced value, and `d` where
none is listed. -/
def firstJudge (π : S → K) (f : S → V) (d : V) : List S → K → V
  | [], _ => d
  | x :: rest, k => if π x = k then f x else firstJudge π f d rest k

theorem firstJudge_judges (π : S → K) (f : S → V) (d : V) :
    ∀ family : List S, LumpedOn family π f → Judges family π f (firstJudge π f d family)
  | [], _ => fun _ mem => nomatch mem
  | x :: rest, lumped => fun s mem =>
    match decEq (π x) (π s) with
    | .isTrue same => (if_pos same).trans (lumped x s (.head rest) mem same)
    | .isFalse differ => (if_neg differ).trans (match member_cons_cases mem with
      | .inl at_x => absurd (congrArg π at_x).symm differ
      | .inr later => firstJudge_judges π f d rest
          (fun a b ma mb => lumped a b (.tail x ma) (.tail x mb)) s later)

/-- **A judge of a listed family through a reduction exists exactly where the observable goes
alike across the members the reduction merges.** No choice is used: the judge answers with the
first listed member of each reduced value (`firstJudge`); `d` answers where none is listed. -/
theorem judges_iff_lumpedOn (family : List S) (π : S → K) (f : S → V) (d : V) :
    (∃ judge, Judges family π f judge) ↔ LumpedOn family π f :=
  ⟨fun ⟨_, judges⟩ => lumpedOn_of_judges judges,
   fun lumped => ⟨firstJudge π f d family, firstJudge_judges π f d family lumped⟩⟩

end Judges

/-- **No judge of a family reads through a reduction that merges two of its members the
observable tells apart.** -/
theorem no_judge_of_merged {family : List S} {π : S → K} {f : S → V} {s s' : S}
    (mem : s ∈ family) (mem' : s' ∈ family) (merged : π s = π s') (apart : f s ≠ f s') :
    ¬ ∃ judge, Judges family π f judge :=
  fun ⟨_, judges⟩ => apart (lumpedOn_of_judges judges s s' mem mem' merged)

/-! ## Readings through parts -/

section Parts

universe y z

variable {P : Type v} {G : P → Type w} {C : Type x} {W : C → Type y}

/-- Every reading of a family reads a configuration only through its parts: configurations that
agree at every part are read alike. -/
def ThroughParts (part : S → (p : P) → G p) (read : (c : C) → S → W c) : Prop :=
  ∀ c s s', (∀ p, part s p = part s' p) → read c s = read c s'

/-- `use p` reads part `p` directly: configurations it reads alike agree at that part. -/
def ReadsDirectly (part : S → (p : P) → G p) (read : (c : C) → S → W c) (use : P → C) : Prop :=
  ∀ p s s', read (use p) s = read (use p) s' → part s p = part s' p

/-- **Agreement under every reading is agreement at every part**, where every reading reads only
through the parts and each part is read directly by some reading. -/
theorem agree_iff_parts {part : S → (p : P) → G p} {read : (c : C) → S → W c} {use : P → C}
    (through : ThroughParts part read) (direct : ReadsDirectly part read use) {s s' : S} :
    (∀ c, read c s = read c s') ↔ ∀ p, part s p = part s' p :=
  ⟨fun all p => direct p s s' (all (use p)), fun parts c => through c s s' parts⟩

/-- **A replacement agrees with the original under every reading exactly where it supplies every
part**: where each reading of the replacement at `t` is the reading of the configuration supplied
from `t`, it agrees with the original `s` under every reading exactly where the supplied
configuration agrees with `s` at every part. -/
theorem supplied_agree_iff_parts {T : Type z} {part : S → (p : P) → G p}
    {read : (c : C) → S → W c} {use : P → C} {replaced : (c : C) → T → W c} {supply : T → S}
    (through : ThroughParts part read) (direct : ReadsDirectly part read use)
    (supplies : ∀ c t, replaced c t = read c (supply t)) {t : T} {s : S} :
    (∀ c, replaced c t = read c s) ↔ ∀ p, part (supply t) p = part s p :=
  ⟨fun all => (agree_iff_parts through direct).mp fun c => (supplies c t).symm.trans (all c),
   fun parts c => (supplies c t).trans ((agree_iff_parts through direct).mpr parts c)⟩

end Parts

end Becoming.Readout
