import Becoming.Blanket
import Becoming.Histories
import Becoming.IdentificationRuns

/-!
# Review probe for the UE27 design (scratch, not for landing)

AI-written by an independent reviewer, 31 October 2026. Checks, in the pure core:
(A) the design's law 5 (part-by-part iff) and its corollary that such a law is determined, in a
form with moves, parallel to `shownBy_determined_iff`;
(B) the trivial reading: read with the whole configuration as the internal part, a family is
consistent part by part exactly where it is consistent;
(C) a stronger law 2: any formation of any web, with the values of what couples into it as its
sensory part, any model and any policy, is the agent of a blanketed law whose sensory course is
its own course through its couplings, blanket-alike exactly where the level histories are alike
through its couplings, every reading of its internal course a selection through them;
(D) the design's witness `ReadsWorld` at steps 2 and 3.
-/

namespace Becoming

namespace UE27ReviewProbe

open Generative Blanket

/-! ## (A) Part by part -/

section Part

variable {I S A E M : Type}

/-- A law on four parts whose steps, under one move, fix the internal and active parts from the
internal, sensory and active parts, and the sensory and external parts from the sensory, active
and external parts. -/
def BlanketDetermined (P : Process (Parts I S A E) M) : Prop :=
  ∀ x m y x' y', P.step x m y → P.step x' m y' →
    (x.internal = x'.internal → x.sensory = x'.sensory → x.active = x'.active →
      y.internal = y'.internal ∧ y.active = y'.active) ∧
    (x.sensory = x'.sensory → x.active = x'.active → x.external = x'.external →
      y.sensory = y'.sensory ∧ y.external = y'.external)

/-- A family consistent part by part. -/
def BlanketConsistentFamily (H : (Nat → Parts I S A E) → (Nat → M) → Prop) : Prop :=
  ∀ g m g' m' i j, H g m → H g' m' → m i = m' j →
    ((g i).internal = (g' j).internal → (g i).sensory = (g' j).sensory →
      (g i).active = (g' j).active →
      (g (i + 1)).internal = (g' (j + 1)).internal ∧ (g (i + 1)).active = (g' (j + 1)).active) ∧
    ((g i).sensory = (g' j).sensory → (g i).active = (g' j).active →
      (g i).external = (g' j).external →
      (g (i + 1)).sensory = (g' (j + 1)).sensory ∧ (g (i + 1)).external = (g' (j + 1)).external)

theorem shownBy_blanketDetermined_iff {H : (Nat → Parts I S A E) → (Nat → M) → Prop} :
    BlanketDetermined (ShownBy H) ↔ BlanketConsistentFamily H :=
  ⟨fun det g m g' m' i j held held' same =>
    det (g i) (m i) (g (i + 1)) (g' j) (g' (j + 1)) ⟨g, m, i, held, rfl, rfl, rfl⟩
      ⟨g', m', j, held', rfl, same.symm, rfl⟩,
   fun cons x a y x' y' ⟨g, m, i, held, at_s, by_a, to_t⟩ ⟨g', m', j, held', at_s', by_a', to_t'⟩ =>
    have c := cons g m g' m' i j held held' (by_a.trans by_a'.symm)
    have pin : ∀ {β : Type} (f : Parts I S A E → β), f x = f x' → f (g i) = f (g' j) :=
      fun f same => (congrArg f at_s).trans (same.trans (congrArg f at_s').symm)
    have pout : ∀ {β : Type} (f : Parts I S A E → β), f (g (i + 1)) = f (g' (j + 1)) → f y = f y' :=
      fun f same => (congrArg f to_t).symm.trans (same.trans (congrArg f to_t'))
    ⟨fun hi hs ha =>
      match c.1 (pin Parts.internal hi) (pin Parts.sensory hs) (pin Parts.active ha) with
      | ⟨ri, ra⟩ => ⟨pout Parts.internal ri, pout Parts.active ra⟩,
     fun hs ha he =>
      match c.2 (pin Parts.sensory hs) (pin Parts.active ha) (pin Parts.external he) with
      | ⟨rs, re⟩ => ⟨pout Parts.sensory rs, pout Parts.external re⟩⟩⟩

theorem parts_eq : ∀ {x y : Parts I S A E}, x.internal = y.internal → x.sensory = y.sensory →
    x.active = y.active → x.external = y.external → x = y
  | ⟨_, _, _, _⟩, ⟨_, _, _, _⟩, rfl, rfl, rfl, rfl => rfl

/-- **A law determined part by part is determined.** -/
theorem BlanketDetermined.determined {P : Process (Parts I S A E) M} (det : BlanketDetermined P) :
    Determined P :=
  fun x m y y' step step' =>
    match (det x m y x y' step step').1 rfl rfl rfl, (det x m y x y' step step').2 rfl rfl rfl with
    | ⟨i, a⟩, ⟨s, e⟩ => parts_eq i s a e

/-- A blanketed law, read as a process with the trivial move, is determined part by part. -/
theorem Blanketed.blanketDetermined (b : Blanketed I S A E) :
    BlanketDetermined (Assurance.ofMap (fun x (_ : Unit) => b.step x)) :=
  fun x _ y x' y' (step : y = b.step x) (step' : y' = b.step x') =>
    match y, y', step, step' with
    | _, _, rfl, rfl =>
      ⟨fun i s a => ⟨congr3 b.nextInternal i s a, congr3 b.nextActive i s a⟩,
       fun s a e => ⟨congr3 b.nextSensory s a e, congr3 b.nextExternal s a e⟩⟩

end Part

/-! ## (B) The trivial reading -/

section Trivial

variable {X M : Type}

/-- The family read with the whole configuration as the internal part. -/
def innerFamily (H : (Nat → X) → (Nat → M) → Prop) :
    (Nat → Parts X Unit Unit Unit) → (Nat → M) → Prop :=
  fun g m => ∃ h, H h m ∧ ∀ n, g n = ⟨h n, (), (), ()⟩

theorem unit_eq : ∀ a b : Unit, a = b
  | (), () => rfl

/-- **Read with the whole configuration as the internal part, a family is consistent part by part
exactly where it is consistent.** -/
theorem inner_iff {H : (Nat → X) → (Nat → M) → Prop} :
    BlanketConsistentFamily (innerFamily H) ↔ ConsistentFamily H :=
  ⟨fun cons h m h' m' i j held held' same same' =>
    have agent := (cons (fun n => ⟨h n, (), (), ()⟩) m (fun n => ⟨h' n, (), (), ()⟩) m' i j
      ⟨h, held, fun _ => rfl⟩ ⟨h', held', fun _ => rfl⟩ same').1 same rfl rfl
    agent.1,
   fun cons g m g' m' i j ⟨h, held, read⟩ ⟨h', held', read'⟩ same' =>
    have inner : ∀ k, (g k).internal = h k := fun k => congrArg Parts.internal (read k)
    have inner' : ∀ k, (g' k).internal = h' k := fun k => congrArg Parts.internal (read' k)
    ⟨fun i_same _ _ =>
      ⟨(inner (i + 1)).trans ((cons h m h' m' i j held held'
          ((inner i).symm.trans (i_same.trans (inner' j))) same').trans (inner' (j + 1)).symm),
       unit_eq _ _⟩,
     fun _ _ _ => ⟨unit_eq _ _, unit_eq _ _⟩⟩⟩

end Trivial

/-! ## (C) A formation of any web as the agent of a blanketed law -/

section Couplings

variable {F C O M A : Type} {W : Web F C} {obs : F → C → Prop} {g : F}
  {value : Nat → (C → Nat) → O} (update : M → O → A → M) (policy : M → O → A → A)

/-- The external part is the step and a level history; the sensory part reads what couples into
the formation at the step. -/
def couplingLaw (value : Nat → (C → Nat) → O) : Blanketed M O A (Nat × (Nat → C → Nat)) where
  nextInternal m o a := update m o a
  nextSensory _ _ e := value e.1 (e.2 e.1)
  nextActive m o a := policy m o a
  nextExternal _ _ e := (e.1 + 1, e.2)

/-- Starting at step zero under the level history `l`. -/
def startAt (m : M) (o : O) (a : A) (l : Nat → C → Nat) : Parts M O A (Nat × (Nat → C → Nat)) :=
  ⟨m, o, a, (0, l)⟩

theorem external_course (m : M) (o : O) (a : A) (l : Nat → C → Nat) :
    ∀ n, ((couplingLaw update policy value).course (startAt m o a l) n).external = (n, l)
  | 0 => rfl
  | n + 1 => congrArg (fun e : Nat × (Nat → C → Nat) => (e.1 + 1, e.2)) (external_course m o a l n)

/-- **Its sensory course is the formation's own course through its couplings**, one step on. -/
theorem sensory_course (m : M) (o : O) (a : A) (l : Nat → C → Nat) (n : Nat) :
    ((couplingLaw update policy value).course (startAt m o a l) (n + 1)).sensory =
      Web.courseThrough value l n :=
  congrArg (fun e : Nat × (Nat → C → Nat) => value e.1 (e.2 e.1)) (external_course update policy m o a l n)

/-- **Blanket-alike exactly where alike through the formation's couplings.** -/
theorem blanket_iff_through (values : W.ValuesThrough obs g value) (m : M) (o : O) (a : A)
    (l l' : Nat → C → Nat) (n : Nat) :
    (couplingLaw update policy value).BlanketAlike (startAt m o a l) (startAt m o a l') (n + 2) ↔
      W.AlikeThroughUpTo obs g l l' n :=
  have sensed : W.AlikeThroughUpTo obs g l l' n → ∀ k, k < n + 2 →
      ((couplingLaw update policy value).course (startAt m o a l) k).sensory =
        ((couplingLaw update policy value).course (startAt m o a l') k).sensory :=
    fun through k lt => match k, lt with
      | 0, _ => rfl
      | s + 1, lt =>
        (sensory_course update policy m o a l s).trans
          (((Web.alikeThrough_iff values).mp
              (through s (Nat.le_of_lt_succ (Nat.lt_of_succ_lt_succ lt)))).trans
            (sensory_course update policy m o a l' s).symm)
  ⟨fun alike s le =>
    (Web.alikeThrough_iff values).mpr
      ((sensory_course update policy m o a l s).symm.trans
        ((alike (s + 1) (Nat.succ_lt_succ (Nat.lt_succ_of_le le))).1.trans
          (sensory_course update policy m o a l' s))),
   fun through k lt =>
    ⟨sensed through k lt,
     ((couplingLaw update policy value).agent_through_sensory (x := startAt m o a l)
        (y := startAt m o a l') rfl rfl k
        fun j lt' => sensed through j (Nat.lt_trans lt' lt)).2⟩⟩

/-- **Every reading of its internal course up to `n + 1` is a selection through the formation's
couplings up to `n`**, whatever the model and the policy. -/
theorem selectsThrough (values : W.ValuesThrough obs g value) (m : M) (o : O) (a : A) (n : Nat)
    (select : (Nat → M) → Prop)
    (reads : ∀ f f' : Nat → M, (∀ k, k ≤ n + 1 → f k = f' k) → (select f ↔ select f')) :
    W.SelectsThrough obs g n
      (fun l => select fun k => ((couplingLaw update policy value).course (startAt m o a l) k).internal) :=
  fun l l' through =>
    have alike := (blanket_iff_through update policy values m o a l l' n).mpr through
    reads _ _ fun k le =>
      (couplingLaw update policy value).internal_through_blanket (x := startAt m o a l)
        (y := startAt m o a l') rfl k
        fun j lt => alike j (Nat.lt_of_lt_of_le lt (Nat.le_succ_of_le le))

end Couplings

/-! ## (D) The witness reading the world directly -/

namespace ReadsWorld

inductive Three where
  | first
  | second
  | third

def next : Three → Three
  | .first => .second
  | .second => .third
  | .third => .first

def isFirst : Three → Bool
  | .first => true
  | .second => false
  | .third => false

/-- The internal part's next state reads the external part directly. -/
def step (x : Parts Bool Unit Unit Three) : Parts Bool Unit Unit Three :=
  ⟨isFirst x.external, (), (), next x.external⟩

def start : Parts Bool Unit Unit Three := ⟨false, (), (), .first⟩

def run : Nat → Parts Bool Unit Unit Three := Law.orbit step start

theorem internal_course :
    (run 0).internal = false ∧ (run 1).internal = true ∧ (run 2).internal = false ∧
      (run 3).internal = false ∧ (run 4).internal = true :=
  ⟨rfl, rfl, rfl, rfl, rfl⟩

/-- **Under its own partition its one run is not consistent part by part.** -/
theorem not_consistent :
    ¬ BlanketConsistentFamily (fun (h : Nat → Parts Bool Unit Unit Three) (_ : Nat → Unit) => h = run) :=
  fun cons =>
    Bool.noConfusion (show false = true from
      ((cons run (fun _ => ()) run (fun _ => ()) 2 3 rfl rfl rfl).1 rfl rfl rfl).1)

/-- **Under the whole-configuration reading the same run is consistent part by part**: its run is
an orbit, so the trivial partition is a blanket. -/
theorem inner_consistent :
    BlanketConsistentFamily
      (innerFamily (fun (h : Nat → Parts Bool Unit Unit Three) (_ : Nat → Unit) => h = run)) :=
  inner_iff.mpr fun h _ h' _ i j (held : h = run) (held' : h' = run) same _ =>
    match h, h', held, held', same with
    | _, _, rfl, rfl, same => congrArg step same

end ReadsWorld

end UE27ReviewProbe

end Becoming
