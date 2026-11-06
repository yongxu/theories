import Becoming.Frame
import Becoming.Arising
import Becoming.Recurrence
import Becoming.Witnesses

/-!
# The labelled process as a reading of the one unfolding

`Generative.Process S A` and `Becoming.Frame` take four splits as given: a configuration and a
move drawn from an alphabet of its own; a law supplied before the history it governs; claims
read off a configuration; and configurations given before the relation among them (Ren, 12
October 2026: "is this dualistic?"). A world takes none of them as given: its history is a run
of the process that admits every step (`Becoming.World`), its moves are its relata's own
exchanges, and what it stands at is part of each configuration. This module states each split
from the world's side, with no premise beyond what each theorem names, so that the labelled
process and the frame are readings of the one unfolding rather than a ground beneath it.

* **The move is part of what the unfolding is.** Read with the move inside the configuration
  (`withMove`), a process has the same runs, read two ways (`Run.toWithMove`,
  `Run.ofWithMove`); a shared move couples parts (`unlabelled_product_le`,
  `Fork.label_couples`); the law of exchange (`exchange`) is a process whose moves are the
  relata's own exchanges.
* **A history fixes the law it shows.** Every sequence of configurations and moves is a run of
  the law it shows (`Shown`, `Shown.run`), the least law it is a run of (`shown_le_iff`). The
  correspondence is not an identity: a law can have a step and no history
  (`DeadEnd.no_history`), and where a history revisits a configuration the law it shows admits a
  history it never took (`Splice.spliced`).
* **A claim is a relatum; being realized is its activity.** A frame along a run is a world whose
  relata are its claims (`Frame.world`, `Frame.world_active`); with configurations as claims the
  world fixes the run (`Frame.world_fixes_run`).
* **A configuration is how it relates.** Configurations are alike (`Alike`) where some
  bisimulation relates them (`Bisimulation`); likeness is an equivalence, stated as a relation.

The second part holds the run readings of the trunk's laws: renewal and consumption along a run
(`Conditions.along`, the `Renewable` witness runs), dependence along a run (`Dependence.along`,
`Web.conditions_along`, the `Crossing`, `Pinned` and `Renewable` runs), and the runs of
`Becoming.Restoration` and `Becoming.Arising`. The laws themselves are stated over the web in those
modules.

Every declaration moved here unchanged, with its name, from `Becoming.Unfolding`,
`Becoming.Renewal`, `Becoming.Dependence`, `Becoming.Restoration` or `Becoming.Arising` (study
section 180, board item W). Every declaration has an empty axiom report.

A third part holds the readings of `Becoming.Recurrence` on runs (the run of a determined law,
reach along runs), moved here unchanged with their names (board item W, second batch);
`Law.process` itself is in `Becoming.Recurrence` (board item R28).
-/

/-! ## The four splits, read from the world's side (moved from `Becoming.Unfolding`) -/

namespace Becoming

open Generative

universe u v w u' u''

section Move

variable {S : Type u} {A : Type v}

/-- The move read within the configuration: what the unfolding is at a step includes the move
made there, and the law relates such configurations. -/
def withMove (P : Process S A) : Process (S × A) Unit :=
  ⟨fun x _ y => P.step x.1 x.2 y.1⟩

variable {P : Process S A}

/-- A run read with its moves inside its configurations. -/
def Run.toWithMove (r : Run P) : Run (withMove P) :=
  ⟨fun n => (r.state n, r.act n), fun _ => (), fun n => r.step n⟩

/-- A run of the law with moves inside, read with its moves as labels. -/
def Run.ofWithMove (r : Run (withMove P)) : Run P :=
  ⟨fun n => (r.state n).1, fun n => (r.state n).2, fun n => r.step n⟩

/-- **One run, read two ways.** Reading the moves inside and back gives the same run. -/
theorem Run.ofWithMove_toWithMove (r : Run P) (n : Nat) :
    r.toWithMove.ofWithMove.state n = r.state n ∧ r.toWithMove.ofWithMove.act n = r.act n :=
  ⟨rfl, rfl⟩

/-- And reading the moves as labels and back. -/
theorem Run.toWithMove_ofWithMove (r : Run (withMove P)) (n : Nat) :
    r.ofWithMove.toWithMove.state n = r.state n :=
  rfl

/-- **The law leaves the move open.** A step to a configuration admits every next move. -/
theorem withMove_open {x : S × A} {i : Unit} {t : S} {b : A}
    (step : (withMove P).step x i (t, b)) (b' : A) : (withMove P).step x i (t, b') :=
  step

/-- The move formed within the unfolding: the next move is what a policy makes of the next
configuration. -/
def closedBy (P : Process S A) (policy : S → A) : Process (S × A) Unit :=
  ⟨fun x _ y => P.step x.1 x.2 y.1 ∧ y.2 = policy y.1⟩

/-- Forming the move within narrows the law with the move left open. -/
theorem closedBy_withMove {policy : S → A} {x : S × A} {i : Unit} {y : S × A}
    (step : (closedBy P policy).step x i y) : (withMove P).step x i y :=
  step.1

/-- A process with its moves forgotten: a configuration goes to another by some move. -/
def unlabelled (P : Process S A) : Process S Unit :=
  ⟨fun s _ t => ∃ a, P.step s a t⟩

/-- Forgetting the move of a joint step leaves a step of each part with its move forgotten. -/
theorem unlabelled_product_le {T : Type w} {Q : Process T A} {x : S × T} {i : Unit} {y : S × T}
    (step : (unlabelled (productProcess P Q)).step x i y) :
    (productProcess (unlabelled P) (unlabelled Q)).step x i y :=
  match step with
  | ⟨a, here, there⟩ => ⟨⟨a, here⟩, ⟨a, there⟩⟩

end Move

section Exchange

variable {R : Type}

/-- The law of exchange: across a step, each relatum's standing after it, with what is taken
from it, is its standing before, with what is given to it. -/
def exchange (R : Type) : Process (R → Nat) (Exchange R) :=
  ⟨fun level m level' => ∀ c, level' c + m.taken c = level c + m.given c⟩

namespace Labelled.Circulation

/-- One relatum standing at one. -/
def one : Unit → Nat := fun _ => 1

/-- It takes one from itself and gives one to itself. -/
def round : Exchange Unit := ⟨[()], fun _ _ => 1, fun _ _ => 1⟩

/-- Nothing is exchanged. -/
def idle : Exchange Unit := ⟨[], fun _ _ => 0, fun _ _ => 0⟩

/-- **The standings do not fix the exchange.** A circulation and no exchange at all leave the
same standings. -/
theorem standings_leave_exchange :
    (exchange Unit).step one round one ∧ (exchange Unit).step one idle one ∧
      round.present ≠ idle.present :=
  ⟨fun _ => rfl, fun _ => rfl, fun same => nomatch same⟩

/-- **Passing fixes standing only from a beginning.** With nothing exchanged, standing at zero
throughout and standing at one throughout are runs with the same moves. -/
theorem start_needed :
    ∃ r r' : Run (exchange Unit), (∀ n, r.act n = r'.act n) ∧ ∀ n, r.state n () ≠ r'.state n () :=
  ⟨⟨fun _ _ => 0, fun _ => idle, fun _ _ => rfl⟩, ⟨fun _ _ => 1, fun _ => idle, fun _ _ => rfl⟩,
   fun _ => rfl, fun _ same => absurd (show (0 : Nat) = 1 from same) (by decide)⟩

end Labelled.Circulation

end Exchange

section Law

variable {S : Type u} {A : Type v}

/-- The law a history shows: the steps it takes. -/
def Shown (g : Nat → S) (m : Nat → A) : Process S A :=
  ⟨fun s a t => ∃ n, g n = s ∧ m n = a ∧ g (n + 1) = t⟩

/-- **Every history is a run of the law it shows**, with no premise. -/
def Shown.run (g : Nat → S) (m : Nat → A) : Run (Shown g m) :=
  ⟨g, m, fun n => ⟨n, rfl, rfl, rfl⟩⟩

/-- **The law a history shows is the least law it is a run of.** -/
theorem shown_le_iff {g : Nat → S} {m : Nat → A} {Q : Process S A} :
    (∀ s a t, (Shown g m).step s a t → Q.step s a t) ↔ ∀ n, Q.step (g n) (m n) (g (n + 1)) :=
  ⟨fun le n => le _ _ _ ⟨n, rfl, rfl, rfl⟩,
   fun steps _ _ _ ⟨n, at_s, by_a, to_t⟩ => at_s ▸ by_a ▸ to_t ▸ steps n⟩

/-- **A law is fixed by its traces.** Two laws on the same configurations and moves take the
same steps exactly when they have the same traces with both ends kept; traces of one move
suffice. -/
theorem same_steps_iff_traces {P Q : Process S A} :
    (∀ s a t, P.step s a t ↔ Q.step s a t) ↔ ∀ s as t, Trace P s as t ↔ Trace Q s as t :=
  ⟨fun same _ _ _ => ⟨trace_map (f := fun x => x) fun s a t => (same s a t).mp,
     trace_map (f := fun x => x) fun s a t => (same s a t).mpr⟩,
   fun same s a t => ⟨fun h => trace_singleton_iff.mp ((same s [a] t).mp (trace_singleton_iff.mpr h)),
     fun h => trace_singleton_iff.mp ((same s [a] t).mpr (trace_singleton_iff.mpr h))⟩⟩

/-- A history is consistent where it never takes one move at one configuration to two
outcomes. -/
def Consistent (g : Nat → S) (m : Nat → A) : Prop :=
  ∀ i j, g i = g j → m i = m j → g (i + 1) = g (j + 1)

/-- A run of a law is a run of the law it shows, which the law contains. -/
theorem Run.shown_le {P : Process S A} (r : Run P) :
    ∀ s a t, (Shown r.state r.act).step s a t → P.step s a t :=
  shown_le_iff.mpr r.step

end Law

section Correspondence

variable {S : Type u} {A : Type v}

/-- A history new at every step meets no configuration twice. -/
theorem eq_of_new {g : Nat → S} (new : ∀ i j, i < j → g i ≠ g j) {i j : Nat} (same : g i = g j) :
    i = j :=
  match Nat.lt_or_ge i j with
  | .inl lt => absurd same (new i j lt)
  | .inr ge => match Nat.lt_or_eq_of_le ge with
    | .inl lt => absurd same.symm (new j i lt)
    | .inr eq => eq.symm

/-- **Where a history never revisits a configuration, the law it shows admits only the history.**
Every run of that law from a configuration of the history is the history from there on. -/
theorem Shown.runs_of_new {g : Nat → S} {m : Nat → A} (new : ∀ i j, i < j → g i ≠ g j)
    (r : Run (Shown g m)) {k : Nat} (start : r.state 0 = g k) : ∀ n, r.state n = g (k + n)
  | 0 => start
  | n + 1 => match r.step n with
    | ⟨_, at_s, _, to_t⟩ => by
      cases eq_of_new new (at_s.trans (Shown.runs_of_new new r start n))
      exact to_t.symm

namespace Splice

/-- A history that returns once to where it began and then goes elsewhere for good. -/
def history : Nat → Nat := Witnesses.profile [0, 1, 0] 2

/-- Going back and forth between the first two configurations, as the history never did. -/
def loop : Nat → Nat
  | 0 => 0
  | 1 => 1
  | n + 2 => loop n

/-- The loop's steps are steps the history took. -/
theorem loop_step : ∀ n, (Shown history fun _ => ()).step (loop n) () (loop (n + 1))
  | 0 => ⟨0, rfl, rfl, rfl⟩
  | 1 => ⟨1, rfl, rfl, rfl⟩
  | n + 2 => loop_step n

/-- **Where a history revisits, the law it shows admits a history it never took.** -/
theorem spliced :
    (∃ r : Run (Shown history fun _ => ()), ∀ n, r.state n = loop n) ∧
      ∀ k, ∃ n, loop n ≠ history (k + n) :=
  ⟨⟨⟨loop, fun _ => (), loop_step⟩, fun _ => rfl⟩,
   fun _ => ⟨3, fun same => absurd (show (1 : Nat) = 2 from same) (by decide)⟩⟩

end Splice

namespace DeadEnd

/-- One step, into a configuration with no continuation. -/
def law : Process Bool Unit := Witnesses.single Unit false true

/-- **A law can have a step and no history.** No history shows it. -/
theorem no_history : law.step false () true ∧ (Run law → False) :=
  ⟨⟨rfl, rfl⟩, fun r => nomatch (r.step 0).2.symm.trans (r.step 1).1⟩

end DeadEnd

end Correspondence

section Claims

variable {S : Type u} {A : Type v} {C : Type}

/-- A frame along a run read as a world: its relata are its claims, each active exactly where
it is realized; nothing stands, depends, draws or is exchanged. -/
def Frame.world (F : Frame S A C) (r : Run F.P) : World :=
  World.of C (⟨fun _ => [], fun _ _ _ => 0, fun _ _ _ => 0⟩) (⟨fun _ _ => 0, fun t c => F.realized (r.state t) c, fun _ _ _ => False, fun _ _ _ => 0,
      fun _ _ _ => False⟩)

variable {F : Frame S A C} {r : Run F.P}

/-- **A claim's activity is its being realized.** -/
theorem Frame.world_active {t : Nat} {c : C} :
    (F.world r).web.active t c ↔ F.realized (r.state t) c :=
  Iff.rfl

/-- A process read through the claims that the configuration is this or that one. -/
def Frame.configurations {S : Type} (P : Process S A) : Frame S A S :=
  ⟨P, fun s c => s = c⟩

/-- **Every run is a world, and the world fixes the run.** Two runs whose worlds of
configurations agree in activity agree at every step. -/
theorem Frame.world_fixes_run {S : Type} {P : Process S A}
    (r r' : Run (Frame.configurations P).P)
    (same : ∀ t c, ((Frame.configurations P).world r).web.active t c ↔
      ((Frame.configurations P).world r').web.active t c) :
    ∀ t, r.state t = r'.state t :=
  fun t => ((same t (r.state t)).mp rfl).symm

end Claims

section Likeness

variable {S : Type u} {S' : Type u'} {S'' : Type u''} {A : Type v} {C : Type w}

/-- A bisimulation between two frames: related configurations realize the same claims, and each
step of either is matched by a step of the other by the same move into related
configurations. -/
def Bisimulation (F : Frame S A C) (G : Frame S' A C) (B : S → S' → Prop) : Prop :=
  ∀ s s', B s s' →
    (∀ c, F.realized s c ↔ G.realized s' c) ∧
    (∀ a t, F.P.step s a t → ∃ t', G.P.step s' a t' ∧ B t t') ∧
    (∀ a t', G.P.step s' a t' → ∃ t, F.P.step s a t ∧ B t t')

/-- Two configurations are alike where some bisimulation relates them: they relate alike to
every continuation. `ReferencePlan.AgreeOn` is another sense, two signals agreeing at the addresses
of a plan. -/
def Alike (F : Frame S A C) (G : Frame S' A C) (s : S) (s' : S') : Prop :=
  ∃ B, Bisimulation F G B ∧ B s s'

/-- Sameness is a bisimulation. -/
theorem Bisimulation.eq (F : Frame S A C) : Bisimulation F F fun s s' => s = s' :=
  fun s _ same => by
    cases same
    exact ⟨fun _ => Iff.rfl, fun _ t step => ⟨t, step, rfl⟩, fun _ t step => ⟨t, step, rfl⟩⟩

/-- The converse of a bisimulation is one. -/
theorem Bisimulation.converse {F : Frame S A C} {G : Frame S' A C} {B : S → S' → Prop}
    (bisim : Bisimulation F G B) : Bisimulation G F fun s' s => B s s' :=
  fun s' s related => match bisim s s' related with
    | ⟨claims, forth, back⟩ => ⟨fun c => (claims c).symm, back, forth⟩

/-- Bisimulations compose. -/
theorem Bisimulation.comp {F : Frame S A C} {G : Frame S' A C} {H : Frame S'' A C}
    {B : S → S' → Prop} {B' : S' → S'' → Prop}
    (bisim : Bisimulation F G B) (bisim' : Bisimulation G H B') :
    Bisimulation F H fun s s'' => ∃ s', B s s' ∧ B' s' s'' :=
  fun s s'' ⟨s', related, related'⟩ =>
    match bisim s s' related, bisim' s' s'' related' with
    | ⟨claims, forth, back⟩, ⟨claims', forth', back'⟩ =>
      ⟨fun c => (claims c).trans (claims' c),
       fun a t step => match forth a t step with
         | ⟨t', step', joined⟩ => match forth' a t' step' with
           | ⟨t'', step'', joined'⟩ => ⟨t'', step'', t', joined, joined'⟩,
       fun a t'' step'' => match back' a t'' step'' with
         | ⟨t', step', joined'⟩ => match back a t' step' with
           | ⟨t, step, joined⟩ => ⟨t, step, t', joined, joined'⟩⟩

/-- **Likeness is an equivalence:** every configuration is alike to itself, -/
theorem Alike.refl (F : Frame S A C) (s : S) : Alike F F s s :=
  ⟨_, Bisimulation.eq F, rfl⟩

/-- likeness runs both ways, -/
theorem Alike.symm {F : Frame S A C} {G : Frame S' A C} {s : S} {s' : S'} :
    Alike F G s s' → Alike G F s' s
  | ⟨_, bisim, related⟩ => ⟨_, bisim.converse, related⟩

/-- and passes along. -/
theorem Alike.trans {F : Frame S A C} {G : Frame S' A C} {H : Frame S'' A C} {s : S} {s' : S'}
    {s'' : S''} : Alike F G s s' → Alike G H s' s'' → Alike F H s s''
  | ⟨_, bisim, related⟩, ⟨_, bisim', related'⟩ => ⟨_, bisim.comp bisim', s', related, related'⟩

/-- Alike configurations realize the same claims. -/
theorem Alike.realized {F : Frame S A C} {G : Frame S' A C} {s : S} {s' : S'}
    (alike : Alike F G s s') (c : C) : F.realized s c ↔ G.realized s' c :=
  match alike with
  | ⟨_, bisim, related⟩ => (bisim s s' related).1 c

/-- A step of one is matched by a step of the other by the same move into alike
configurations. -/
theorem Alike.step {F : Frame S A C} {G : Frame S' A C} {s : S} {s' : S'}
    (alike : Alike F G s s') {a : A} {t : S} (step : F.P.step s a t) :
    ∃ t', G.P.step s' a t' ∧ Alike F G t t' :=
  match alike with
  | ⟨B, bisim, related⟩ => match (bisim s s' related).2.1 a t step with
    | ⟨t', step', joined⟩ => ⟨t', step', B, bisim, joined⟩

/-- Under a bisimulation every course of moves is matched by the same course into related
configurations. -/
theorem Bisimulation.trace {F : Frame S A C} {G : Frame S' A C} {B : S → S' → Prop}
    (bisim : Bisimulation F G B) {s t : S} {as : List A} (path : Trace F.P s as t) :
    ∀ {s'}, B s s' → ∃ t', Trace G.P s' as t' ∧ B t t' := by
  induction path with
  | nil =>
    intro s' related
    exact ⟨s', .nil s', related⟩
  | cons step _ ih =>
    intro s' related
    match (bisim _ s' related).2.1 _ _ step with
    | ⟨m', step', joined⟩ =>
      match ih joined with
      | ⟨t', path', joined'⟩ => exact ⟨t', .cons step' path', joined'⟩

/-- **Alike configurations admit the same courses of moves into alike configurations.** -/
theorem Alike.trace {F : Frame S A C} {G : Frame S' A C} {s : S} {s' : S'}
    (alike : Alike F G s s') {as : List A} {t : S} (path : Trace F.P s as t) :
    ∃ t', Trace G.P s' as t' ∧ Alike F G t t' :=
  match alike with
  | ⟨B, bisim, related⟩ => match bisim.trace path related with
    | ⟨t', path', joined⟩ => ⟨t', path', B, bisim, joined⟩

/-- **Alike configurations pass the same tests**: a course of moves followed by a claim. -/
theorem Alike.tests {F : Frame S A C} {G : Frame S' A C} {s : S} {s' : S'}
    (alike : Alike F G s s') (as : List A) (c : C) :
    (∃ t, Trace F.P s as t ∧ F.realized t c) ↔ (∃ t', Trace G.P s' as t' ∧ G.realized t' c) :=
  ⟨fun ⟨_, path, real⟩ => match alike.trace path with
    | ⟨t', path', joined⟩ => ⟨t', path', (joined.realized c).mp real⟩,
   fun ⟨_, path', real'⟩ => match alike.symm.trace path' with
    | ⟨t, path, joined⟩ => ⟨t, path, (joined.realized c).mp real'⟩⟩

/-- A frame is determined up to likeness at a configuration where any two outcomes of one move
there are alike. -/
def DeterminedAt (F : Frame S A C) (s : S) : Prop :=
  ∀ a t t', F.P.step s a t → F.P.step s a t' → Alike F F t t'

/-- **Determinacy up to likeness passes along likeness.** -/
theorem DeterminedAt.transfer {F : Frame S A C} {G : Frame S' A C} {s : S} {s' : S'}
    (alike : Alike F G s s') (determined : DeterminedAt F s) : DeterminedAt G s' :=
  fun a _ _ step₁ step₂ =>
    match alike.symm.step step₁, alike.symm.step step₂ with
    | ⟨u₁, back₁, joined₁⟩, ⟨u₂, back₂, joined₂⟩ =>
      joined₁.trans ((determined a u₁ u₂ back₁ back₂).trans joined₂.symm)

/-- **Alike configurations go alike.** Where a frame is determined up to likeness, the same move
takes alike configurations to alike ones. -/
theorem DeterminedAt.goAlike {F : Frame S A C} {s s' : S} (alike : Alike F F s s')
    (determined : DeterminedAt F s') {a : A} {t t' : S} (step : F.P.step s a t)
    (step' : F.P.step s' a t') : Alike F F t t' :=
  match alike.step step with
  | ⟨u, matched, joined⟩ => joined.trans (determined a u t' matched step')

section Sense

variable {K : Type u'} {K' : Type u''}

/-- A description of configurations makes sense where it identifies exactly the alike ones. -/
def IdentifiesAlike (F : Frame S A C) (π : S → K) : Prop :=
  ∀ s s', π s = π s' ↔ Alike F F s s'

/-- **A description makes sense exactly where what it identifies relate alike and it identifies
whatever is alike.** -/
theorem identifiesAlike_iff {F : Frame S A C} {π : S → K} :
    IdentifiesAlike F π ↔
      Bisimulation F F (fun s s' => π s = π s') ∧ ∀ s s', Alike F F s s' → π s = π s' :=
  ⟨fun sense =>
    ⟨fun s s' same =>
      have alike := (sense s s').mp same
      ⟨alike.realized,
       fun _ _ step => match alike.step step with
         | ⟨t', step', joined⟩ => ⟨t', step', (sense _ t').mpr joined⟩,
       fun _ _ step' => match alike.symm.step step' with
         | ⟨t, step, joined⟩ => ⟨t, step, (sense t _).mpr joined.symm⟩⟩,
     fun s s' => (sense s s').mpr⟩,
   fun ⟨kernel, idle⟩ s s' => ⟨fun same => ⟨_, kernel, same⟩, idle s s'⟩⟩

/-- **Descriptions that make sense identify the same configurations.** -/
theorem IdentifiesAlike.unique {F : Frame S A C} {π : S → K} {ρ : S → K'} (sense : IdentifiesAlike F π)
    (sense' : IdentifiesAlike F ρ) (s s' : S) : π s = π s' ↔ ρ s = ρ s' :=
  (sense s s').trans (sense' s s').symm

/-- **Naming the configurations makes sense exactly where alike configurations are one.** -/
theorem identifiesAlike_id_iff {F : Frame S A C} :
    IdentifiesAlike F id ↔ ∀ s s', Alike F F s s' → s = s' :=
  ⟨fun sense s s' => (sense s s').mpr,
   fun one s s' =>
    ⟨fun same => Eq.subst (motive := fun x => Alike F F s x) same (Alike.refl F s), one s s'⟩⟩

end Sense

namespace Twins

/-- The same with one successor. -/
def one : Frame Bool Unit Unit :=
  ⟨⟨fun s _ t => s = false ∧ t = true⟩, fun _ _ => True⟩

end Twins

end Likeness

section Standings

variable {R : Type}

/-- The law of exchange read through the claims that a relatum stands at an amount. -/
def exchangeFrame (R : Type) : Frame (R → Nat) (Exchange R) (R × Nat) :=
  ⟨exchange R, fun level x => level x.1 = x.2⟩

/-- Agreeing at every relatum is a bisimulation of the law of exchange. -/
theorem exchange_pointwise_bisimulation :
    Bisimulation (exchangeFrame R) (exchangeFrame R) fun level level' => ∀ c, level c = level' c :=
  fun _ _ same =>
    ⟨fun x => ⟨fun h => (same x.1).symm.trans h, fun h => (same x.1).trans h⟩,
     fun _ t step => ⟨t, fun c => (step c).trans (congrArg (· + _) (same c)), fun _ => rfl⟩,
     fun _ t step => ⟨t, fun c => (step c).trans (congrArg (· + _) (same c).symm), fun _ => rfl⟩⟩

/-- **Standings agreeing at every relatum are alike.** -/
theorem exchange_alike_of_pointwise {level level' : R → Nat} (same : ∀ c, level c = level' c) :
    Alike (exchangeFrame R) (exchangeFrame R) level level' :=
  ⟨_, exchange_pointwise_bisimulation, same⟩

/-- Alike standings agree at every relatum. -/
theorem exchange_pointwise_of_alike {level level' : R → Nat}
    (alike : Alike (exchangeFrame R) (exchangeFrame R) level level') : ∀ c, level c = level' c :=
  fun c => ((alike.realized (c, level c)).mp rfl).symm

/-- **Standings are alike exactly where they agree at every relatum.** -/
theorem exchange_alike_iff {level level' : R → Nat} :
    Alike (exchangeFrame R) (exchangeFrame R) level level' ↔ ∀ c, level c = level' c :=
  ⟨exchange_pointwise_of_alike, exchange_alike_of_pointwise⟩

end Standings

end Becoming

/-! ## Renewal and consumption along a run (moved from `Becoming.Renewal`) -/

namespace Becoming

open Generative RelationalRenewal

universe u v

variable {S : Type u} {A : Type v}

/-- A run read through its conditions is one relational unfolding. -/
def Conditions.along {F C : Type} (K : Conditions S F C) {P : Process S A} (r : Run P) :
    Unfolding F C :=
  ⟨fun t => K.level (r.state t), fun t => K.active (r.state t), K.requires, K.need, K.draws⟩

/-- Depletion: if every admissible step lowers a reserve, no run exists. -/
theorem Run.not_of_depletion {P : Process S A} (reserve : S → Nat)
    (lowers : ∀ s a t, P.step s a t → reserve t < reserve s) (r : Run P) : False :=
  falls_not_recurring (fun n => reserve (r.state n)) 0
    (fun n _ => Nat.le_of_lt (lowers _ _ _ (r.step n)))
    (fun N => ⟨N, Nat.le_refl N, lowers _ _ _ (r.step N)⟩)

/-- `Depletion.no_infinite_execution_under_depletion`, derived from the principle. -/
theorem no_execution_of_depletion {P : Process S A} (reserve : S → Nat)
    (lowers : ∀ s a t, P.step s a t → reserve t < reserve s) :
    ¬ ∃ states : Nat → S, ∃ actions : Nat → A,
      ∀ n, P.step (states n) (actions n) (states (n + 1))
  | ⟨states, actions, steps⟩ => Run.not_of_depletion reserve lowers ⟨states, actions, steps⟩

/-- Recurrent renewal: if every step that is not a renewal lowers a rank, no tail of a
run is free of renewal. -/
theorem Run.renewal_recurs {P : Process S A} (r : Run P) (rank : S → Nat)
    (renewal : Nat → Prop)
    (lowers : ∀ n, ¬ renewal n → rank (r.state (n + 1)) < rank (r.state n))
    (start : Nat) : ¬ ∀ n, start ≤ n → ¬ renewal n :=
  fun free => falls_not_recurring (fun n => rank (r.state n)) start
    (fun n after => Nat.le_of_lt (lowers n (free n after)))
    (fun N => ⟨N + start, Nat.le_add_right N start,
      lowers _ (free _ (Nat.le_add_left start N))⟩)

/-- Unrenewed drawdown along a run: a formation that lowers a condition at each active
step, while nothing renews it, is not active at arbitrarily late steps. -/
theorem Conditions.drawdown_not_recurring {F C : Type} (K : Conditions S F C) {P : Process S A}
    (r : Run P) (f : F) (c : C) (T : Nat)
    (unrenewed : ∀ t, T ≤ t → K.level (r.state (t + 1)) c ≤ K.level (r.state t) c)
    (lowers : ∀ t, T ≤ t → K.active (r.state t) f →
      K.level (r.state (t + 1)) c < K.level (r.state t) c) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ K.active (r.state t) f :=
  unrenewed_drawdown_finite (K.along r) f c T unrenewed lowers

namespace Renewable

/-- A shared condition renewed by one unit per step; the action is the amount drawn. -/
def process : Process Nat Nat := ⟨fun s d t => t = s + 1 - d⟩

/-- Drawing what is renewed. -/
def withinRenewal : Run process := ⟨fun _ => 1, fun _ => 1, fun _ => rfl⟩

/-- Drawing one unit more than is renewed. -/
def beyondRenewal : Run process :=
  ⟨beyondRenewalState, fun _ => 2, fun | 0 => rfl | _ + 1 => rfl⟩

/-- One process, one initial configuration, the focal formation active at every step
of both runs: drawing within renewal is renewing, drawing beyond it consumes the
condition of the sustaining formation, which ends. -/
theorem class_belongs_to_the_run :
    withinRenewal.state 0 = beyondRenewal.state 0 ∧
    (∀ t, conditions.active (withinRenewal.state t) .focal ∧
      conditions.active (beyondRenewal.state t) .focal) ∧
    RenewingIn (conditions.along withinRenewal) .focal ∧
    ConsumingIn (conditions.along beyondRenewal) .focal ∧
    ∀ t, 1 ≤ t → ¬ conditions.active (beyondRenewal.state t) .sustaining := by
  have lost : ∀ t, 1 ≤ t → beyondRenewalState t < 1
    | 0, early => absurd early (Nat.not_succ_le_zero 0)
    | _ + 1, _ => Nat.zero_lt_one
  refine ⟨rfl, fun _ => ⟨trivial, trivial⟩, ?_, ⟨(), trivial, .sustaining, 1, trivial, lost⟩,
    fun t later active => Nat.not_le_of_gt (lost t later) active⟩
  intro _ _ _ g depends
  cases g with
  | focal => exact absurd depends id
  | sustaining => exact Nat.le_refl 1

end Renewable

end Becoming

/-! ## Dependence along a run (moved from `Becoming.Dependence`) -/

namespace Becoming

open Generative RelationalRenewal

universe u v

variable {S : Type u} {A : Type v} {F C : Type}

/-- A run read through its dependences. -/
def Dependence.along (K : Dependence S F C) {P : Process S A} (r : Run P) : Web F C :=
  ⟨fun t => K.level (r.state t), fun t => K.active (r.state t),
    fun t => K.requires (r.state t), fun t => K.need (r.state t), fun t => K.draws (r.state t)⟩

namespace Web

variable (W : Web F C)

variable {W}

/-- Reading a run through fixed dependences is the static reading of the run. -/
theorem conditions_along (K : Conditions S F C) {P : Process S A} (r : Run P) :
    K.dependence.along r = static (K.along r) :=
  rfl

end Web

namespace Crossing

def process : Process State Move where
  step s a t := match a with
    | .rest => t = s
    | .fall m => s.first = 1 ∧ t = ⟨0, m⟩
    | .renew => s.mode = .dormant ∧ t = ⟨1, .onFirst⟩

/-- The formation ends with the loss. -/
def ending : Run process :=
  ⟨endingState, fun | 0 => .fall .ended | _ + 1 => .rest,
    fun | 0 => ⟨rfl, rfl⟩ | _ + 1 => rfl⟩

/-- The formation ceases to depend on the first condition and comes to depend on the
second. -/
def transforming : Run process :=
  ⟨transformingState, fun | 0 => .fall .onSecond | _ + 1 => .rest,
    fun | 0 => ⟨rfl, rfl⟩ | _ + 1 => rfl⟩

/-- The formation waits on the first condition, which is renewed. -/
def restoring : Run process :=
  ⟨restoringState, fun | 0 => .fall .dormant | 1 => .renew | _ + 2 => .rest,
    fun | 0 => ⟨rfl, rfl⟩ | 1 => ⟨rfl, rfl⟩ | _ + 2 => rfl⟩

theorem ending_dependent : (dependence.along ending).Dependent
  | 0, _, _, .first, _ => Nat.le_refl 1
  | 0, _, _, .second, depends => False.elim depends
  | _ + 1, _, active, _, _ => False.elim active

theorem transforming_dependent : (dependence.along transforming).Dependent
  | 0, _, _, .first, _ => Nat.le_refl 1
  | 0, _, _, .second, depends => False.elim depends
  | _ + 1, _, _, .first, depends => False.elim depends
  | _ + 1, _, _, .second, _ => Nat.le_refl 1

theorem restoring_dependent : (dependence.along restoring).Dependent
  | 0, _, _, .first, _ => Nat.le_refl 1
  | 0, _, _, .second, depends => False.elim depends
  | 1, _, active, _, _ => False.elim active
  | _ + 2, _, _, .first, _ => Nat.le_refl 1
  | _ + 2, _, _, .second, depends => False.elim depends

/-- One process, one configuration, three outcomes after a break of the same
dependence. Each run breaks the formation's dependence on the first condition at its
first step, read at the start of the step. In the first the formation ends and the
loss has no return. In the second the dependence dissolves as one on the second
condition forms, the formation stays active, and the loss has no return. In the third
the formation waits, the condition is renewed, and the same dependence is kept again
from then on. The move that makes the break selects the formation's mode, so the break
does not determine the next configuration. Read at the end of the step, only the
restoring run breaks anything, and in the ending run the dependence dissolves. -/
theorem loss_does_not_decide :
    ending.state 0 = transforming.state 0 ∧ transforming.state 0 = restoring.state 0 ∧
    (dependence.along ending).Broken 0 () .first ∧
    (dependence.along transforming).Broken 0 () .first ∧
    (dependence.along restoring).Broken 0 () .first ∧
    (dependence.along ending).Lost .first ∧
    (∀ t, 0 < t → ¬ (dependence.along ending).active t ()) ∧
    (dependence.along transforming).Lost .first ∧
    (dependence.along transforming).Dissolves 0 () .first ∧
    (dependence.along transforming).Forms 0 () .second ∧
    (∀ t, (dependence.along transforming).active t ()) ∧
    ¬ (dependence.along restoring).Consumed .first ∧
    (∀ t, 2 ≤ t → (dependence.along restoring).active t () ∧
      (dependence.along restoring).requires t () .first ∧
      (dependence.along restoring).Kept t () .first) := by
  refine ⟨rfl, rfl, ⟨trivial, Nat.le_refl 1, Nat.zero_lt_one⟩,
    ⟨trivial, Nat.le_refl 1, Nat.zero_lt_one⟩, ⟨trivial, Nat.le_refl 1, Nat.zero_lt_one⟩,
    ⟨(), 0, ⟨trivial, Nat.le_refl 1, Nat.zero_lt_one⟩, fun | _ + 1, _ => Nat.zero_lt_one⟩,
    fun | _ + 1, _ => id,
    ⟨(), 0, ⟨trivial, Nat.le_refl 1, Nat.zero_lt_one⟩, fun | _ + 1, _ => Nat.zero_lt_one⟩,
    ⟨trivial, id⟩, ⟨id, trivial⟩, fun | 0 => trivial | _ + 1 => trivial, ?_,
    fun | _ + 2, _ => ⟨trivial, trivial, Nat.le_refl 1, Nat.le_refl 1⟩⟩
  intro ⟨_, T, _, below⟩
  exact Nat.lt_irrefl 1 (below (T + 2) (Nat.lt_of_lt_of_le (Nat.lt_succ_self T) (Nat.le_succ _)))

end Crossing

namespace Renewable

/-- Drawing within renewal at first, then beyond it. -/
def escalating : Run process :=
  ⟨escalatingState, fun | 0 => 1 | _ + 1 => 2, fun | 0 => rfl | 1 => rfl | _ + 2 => rfl⟩

/-- The whole-run reading counts the focal formation as consuming, while the stepwise
reading includes its first event, which drew within renewal, and not its second. -/
theorem stepwise_includes_before_escalation :
    (conditions.dependence.along escalating).ConsumingIn .focal ∧
    (conditions.dependence.along escalating).RenewingAt 0 .focal ∧
    ¬ (conditions.dependence.along escalating).RenewingAt 1 .focal := by
  refine ⟨⟨0, (), trivial, .sustaining, 1, trivial, fun | _ + 2, _ => Nat.zero_lt_one⟩,
    ⟨trivial, fun _ _ g depends => ?_⟩, fun ⟨_, keeps⟩ => ?_⟩
  · cases g with
    | focal => exact False.elim depends
    | sustaining => exact ⟨Nat.le_refl 1, Nat.le_refl 1⟩
  · exact Nat.not_succ_le_zero 0 (keeps () (Or.inr trivial) .sustaining trivial).2

/-- Drawing beyond renewal once, then pausing while the condition is renewed. -/
def dipping : Run process :=
  ⟨dippingState, fun | 0 => 2 | 1 => 0 | _ + 2 => 1, fun | 0 => rfl | 1 => rfl | _ + 2 => rfl⟩

/-- The whole-run reading does not count the focal formation as consuming, since the
condition returns, while the stepwise reading withholds its first event, whose step
breaks the sustaining formation's dependence. -/
theorem dip_breaks_without_consuming :
    ¬ (conditions.dependence.along dipping).ConsumingIn .focal ∧
    ¬ (conditions.dependence.along dipping).RenewingAt 0 .focal := by
  refine ⟨fun ⟨_, _, _, g, T, depends, below⟩ => ?_,
    Web.not_renewing_at_of_broken (g := .sustaining) (c := ()) (Or.inr trivial)
      ⟨trivial, Nat.le_refl 1, Nat.zero_lt_one⟩⟩
  cases g with
  | focal => exact depends
  | sustaining =>
    exact Nat.lt_irrefl 1 (below (T + 2) (Nat.lt_of_lt_of_le (Nat.lt_succ_self T) (Nat.le_succ _)))

/-- The formation whose dependence breaks is not within renewal at that step, and it is
not undermining: it draws on nothing. -/
theorem broken_formation :
    (conditions.dependence.along escalating).active 1 .sustaining ∧
    (conditions.dependence.along escalating).Broken 1 .sustaining () ∧
    ¬ (conditions.dependence.along escalating).RenewingAt 1 .sustaining ∧
    ¬ (conditions.dependence.along escalating).UnderminingAt 1 .sustaining :=
  have broken : (conditions.dependence.along escalating).Broken 1 .sustaining () :=
    ⟨trivial, Nat.le_refl 1, Nat.zero_lt_one⟩
  ⟨Nat.le_refl 1, broken, Web.not_renewing_at_of_broken (Or.inl trivial) broken,
   fun ⟨_, drawn, _⟩ => drawn⟩

/-- Drawing beyond renewal once, then taking nothing (action 0). `Renewable`'s `draws`
is blind to amount, so the focal formation formally draws at every step. -/
def pausing : Run process :=
  ⟨pausingState, fun | 0 => 2 | _ + 1 => 0, fun | 0 => rfl | 1 => rfl | _ + 2 => rfl⟩

/-- After the loss, further drawing breaks nothing, yet it undermines. In the run beyond
renewal every later event of the focal formation draws on a condition that fails a need it
once met, without breaking anything; in the run that takes the same first step and then
takes nothing, the condition returns, since in `Renewable` renewal continues below
support. Undermining reads drawing on a condition that is left below a need it once met
and below the present need; it does not test whether the drawing keeps the condition
from returning (`Pinned`). -/
theorem drawing_after_loss :
    (∀ t, 0 < t → ¬ (conditions.dependence.along beyondRenewal).BreakingAt t .focal ∧
      (conditions.dependence.along beyondRenewal).UnderminingAt t .focal) ∧
    pausing.state 0 = beyondRenewal.state 0 ∧ pausing.act 0 = beyondRenewal.act 0 ∧
    ¬ (conditions.dependence.along pausing).Consumed () :=
  ⟨fun
    | _ + 1, _ => ⟨fun ⟨_, _, g, depends, met, _⟩ => match g, depends with
        | .sustaining, _ => Nat.not_succ_le_zero 0 met,
      ⟨(), trivial, .sustaining, trivial,
        ⟨0, Nat.zero_le _, fun _ _ _ => trivial, Nat.le_refl 1, Nat.le_refl _⟩, Nat.zero_lt_one⟩⟩,
   rfl, rfl, fun ⟨g, T, depends, below⟩ => match g, depends with
    | .sustaining, _ =>
      Nat.not_succ_le_zero T (Nat.le_of_succ_le_succ (below (T + 2)
        (Nat.lt_of_lt_of_le (Nat.lt_succ_self T) (Nat.le_succ _))))⟩

end Renewable

namespace Pinned

/-- An exogenous collapse: whatever is taken, the level is 0 after every step. The action
sets the next amount taken. -/
def process : Process State Nat :=
  ⟨fun _ a t => t = ⟨0, a⟩⟩

/-- The drawer takes one unit at every step from step 1. -/
def taking : Run process :=
  ⟨takingState, fun _ => 1, fun | 0 => rfl | _ + 1 => rfl⟩

/-- The drawer takes nothing. -/
def resting : Run process :=
  ⟨restingState, fun _ => 0, fun | 0 => rfl | _ + 1 => rfl⟩

/-- Undermining reads co-participation in a shortfall that is not restored, not what a
draw does. The two runs have the same level at every step, so the drawer's taking
changes no level; yet in the run where it takes, each of its events from step 1 is
undermining, and the whole-run reading counts it consuming. -/
theorem undermining_without_effect :
    (∀ t, (dependence.along taking).level t () = (dependence.along resting).level t ()) ∧
    (∀ t, 1 ≤ t → (dependence.along taking).UnderminingAt t .drawer) ∧
    (dependence.along taking).ConsumingIn .drawer ∧
    ∀ t, ¬ (dependence.along resting).draws t .drawer () :=
  ⟨fun | 0 => rfl | _ + 1 => rfl,
   fun | _ + 1, _ => ⟨(), Nat.zero_lt_one, .old, trivial,
          ⟨0, Nat.zero_le _, fun _ _ _ => trivial, Nat.le_succ 1, Nat.le_refl _⟩, Nat.zero_lt_one⟩,
   ⟨1, (), Nat.zero_lt_one, .old, 0, trivial, fun | _ + 1, _ => Nat.zero_lt_one⟩,
   fun | 0 => Nat.lt_irrefl 0 | _ + 1 => Nat.lt_irrefl 0⟩

end Pinned

end Becoming

/-! ## Return along a run (moved from `Becoming.Restoration`) -/

namespace Becoming

open RelationalRenewal

variable {F C : Type}

namespace Renewable

/-- Over cycles of two the dip is included, by the run and by the event: the condition
returns within two steps, though the first step breaks the sustaining formation's
dependence. -/
theorem dip_within_two :
    (conditions.dependence.along dipping).RenewingInWithin 2 .focal ∧
    ¬ (conditions.dependence.along dipping).UnderminingFor 2 0 .focal ∧
    (conditions.dependence.along dipping).BreakingAt 0 .focal := by
  have renewed : (conditions.dependence.along dipping).RenewedWithin 2 () := fun t g depends =>
    match t, g, depends with
    | 0, .sustaining, _ => ⟨2, Nat.zero_lt_two, Nat.le_refl 2, Nat.le_refl 1⟩
    | 1, .sustaining, _ => ⟨1, Nat.zero_lt_one, Nat.le_succ 1, Nat.le_refl 1⟩
    | _ + 2, .sustaining, _ => ⟨1, Nat.zero_lt_one, Nat.le_succ 1, Nat.le_refl 1⟩
  have renewing : (conditions.dependence.along dipping).RenewingInWithin 2 .focal :=
    fun _ _ _ => renewed
  exact ⟨renewing, renewing.not_undermining_for,
    ⟨(), trivial, .sustaining, trivial, Nat.le_refl 1, Nat.zero_lt_one⟩⟩

/-- The escalation undermines for every cycle: after it the condition never returns.
The event before it does not undermine. -/
theorem escalation_undermines_for_every_cycle :
    ¬ (conditions.dependence.along escalating).UnderminingFor 1 0 .focal ∧
    ∀ p, (conditions.dependence.along escalating).UnderminingFor p 1 .focal :=
  ⟨fun undermining => stepwise_includes_before_escalation.2.1.not_undermining
    (Web.undermining_for_one.mp undermining),
   fun _ => ⟨(), trivial, .sustaining, trivial, fun
     | 0, positive, _ => absurd positive (Nat.lt_irrefl 0)
     | k + 1, _, _ =>
       have gone := Nat.lt_of_le_of_lt
         (Nat.le_of_eq (congrArg escalatingState (Nat.add_comm 1 (k + 1)))) Nat.zero_lt_one
       ⟨⟨1, Nat.le_refl 1, fun _ _ _ => trivial, Nat.le_refl 1, gone⟩, gone⟩⟩⟩

end Renewable

end Becoming

/-! ## Arising along a run (moved from `Becoming.Arising`) -/

namespace Becoming

variable {F C : Type}

namespace Renewable

/-- Drawing exactly what is renewed keeps every dependence, and nothing ever arises. -/
theorem renewal_without_arising :
    (conditions.dependence.along withinRenewal).Renewed () ∧
    ∀ t f, ¬ (conditions.dependence.along withinRenewal).Arises t f :=
  ⟨fun _ g depends => match g, depends with
    | .sustaining, _ => ⟨Nat.le_refl 1, Nat.le_refl 1⟩,
   fun _ f ⟨inactive, _⟩ => match f with
    | .focal => inactive trivial
    | .sustaining => inactive (Nat.le_refl 1)⟩

end Renewable

end Becoming

/-! ## A determined law as a process, and reach along its runs (moved from `Becoming.Recurrence`) -/

namespace Becoming

open Generative

universe u v w

section Runs

variable {S : Type u} {A : Type v} {P : Process S A}

/-- A run of any process whose configurations a list holds revisits from every step on. -/
theorem Run.revisits_from (r : Run P) {l : List S} (held : ∀ n, r.state n ∈ l) (T : Nat) :
    ∃ i j, T ≤ i ∧ i < j ∧ r.state i = r.state j :=
  Becoming.revisits_from held T

/-- A run whose configurations a list holds and whose changes a quantity marks: change does not
recur (`not_marks` on the run's configurations). -/
theorem Run.change_not_recurring (r : Run P) {l : List S} (held : ∀ n, r.state n ∈ l) {q : S → Nat}
    (marks : Marks q r.state) : ¬ ∀ T, ∃ k, T ≤ k ∧ r.state (k + 1) ≠ r.state k :=
  fun recurs => not_marks held recurs q marks

/-- A possibility lost along an admissible path stays lost along every continuation. -/
theorem Reach.lost_stays {t u t' : S} (lost : ¬ Reach P t u) (onward : Reach P t t') :
    ¬ Reach P t' u :=
  fun back => lost (onward.trans back)

/-- **What can be had from a configuration is kept exactly where it can be had again.** Every
configuration reachable from `s` is reachable from `t` exactly when `t` leads back to `s`. -/
theorem keeps_reach_iff_returns {s t : S} : (∀ u, Reach P s u → Reach P t u) ↔ Reach P t s :=
  ⟨fun keeps => keeps s (Reach.refl P s), fun back _ there => back.trans there⟩

/-- **Along a path, the same possibilities exactly where it can be undone.** For `t` reached
from `s`, the configurations reachable from both are the same exactly when `t` leads back to
`s`. -/
theorem same_reach_iff_returns {s t : S} (onward : Reach P s t) :
    (∀ u, Reach P s u ↔ Reach P t u) ↔ Reach P t s :=
  ⟨fun same => (same s).mp (Reach.refl P s),
   fun back _ => ⟨fun there => back.trans there, fun there => onward.trans there⟩⟩

/-- **No way back is a lost possibility, with a witness.** `t` does not lead back to `s` exactly
when some configuration reachable from `s` is not reachable from `t`: `s` itself is one. -/
theorem not_returns_iff_loses {s t : S} : ¬ Reach P t s ↔ ∃ u, Reach P s u ∧ ¬ Reach P t u :=
  ⟨fun away => ⟨s, Reach.refl P s, away⟩, fun ⟨_, there, lost⟩ back => lost (back.trans there)⟩

end Runs

section Together

variable {S : Type u} {A : Type v} {C : Type w}

/-- A bundle of claims realized together, at one configuration, at the end of a course of at most
`n` moves from `s`. -/
def WithinMoves (P : Process S A) (realized : S → C → Prop) (s : S) (n : Nat)
    (bundle : C → Prop) : Prop :=
  ∃ word t, Trace P s word t ∧ word.length ≤ n ∧ ∀ c, bundle c → realized t c

variable {P : Process S A} {realized : S → C → Prop} {bundle : C → Prop}

/-- One step before adds one move to the bound. -/
theorem WithinMoves.before {s m : S} {a : A} {n : Nat} (step : P.step s a m) :
    WithinMoves P realized m n bundle → WithinMoves P realized s (n + 1) bundle
  | ⟨word, t, path, short, holds⟩ => ⟨a :: word, t, .cons step path, Nat.succ_le_succ short, holds⟩

/-- **A trace of `xs` gives `xs.length` steps of the grammar** (`«迭»` of the process's steps). -/
theorem trace_steps : ∀ {s t : S} {xs : List A}, Trace P s xs t → «迭» (Steps P) xs.length s t
  | _, _, _, .nil _ => rfl
  | _, _, _, .cons step path => ⟨_, ⟨_, step⟩, trace_steps path⟩

/-- **A trace of `k` moves is `k` steps of the grammar** (`«迭»` of the process's steps). -/
theorem trace_iff_steps : ∀ {k : Nat} {s t : S},
    (∃ xs : List A, xs.length = k ∧ Trace P s xs t) ↔ «迭» (Steps P) k s t
  | 0, s, t => ⟨fun ⟨_, len, path⟩ => Eq.subst (motive := fun i => «迭» (Steps P) i s t) len (trace_steps path),
      fun e => ⟨[], rfl, Eq.subst (motive := fun v => Trace P s [] v) e (.nil s)⟩⟩
  | k + 1, s, t => ⟨fun ⟨_, len, path⟩ => Eq.subst (motive := fun i => «迭» (Steps P) i s t) len (trace_steps path),
      fun ⟨_, ⟨a, step⟩, rest⟩ => match (trace_iff_steps (k := k)).mpr rest with
        | ⟨xs, len, path⟩ => ⟨a :: xs, congrArg (· + 1) len, .cons step path⟩⟩

/-- **Realizable together within `n` moves is a configuration within `n` steps of the grammar
realizing the bundle** (`«迭内»` of the process's steps). -/
theorem withinMoves_iff_withinSteps {s : S} {n : Nat} :
    WithinMoves P realized s n bundle ↔ ∃ t, «迭内» (Steps P) n s t ∧ ∀ c, bundle c → realized t c :=
  ⟨fun ⟨word, t, path, short, holds⟩ => ⟨t, ⟨word.length, short, trace_steps path⟩, holds⟩,
   fun ⟨t, ⟨_, le, steps⟩, holds⟩ => match trace_iff_steps.mpr steps with
    | ⟨xs, len, path⟩ => ⟨xs, t, path, Eq.subst (motive := fun i => i ≤ n) len.symm le, holds⟩⟩

/-- **A course carries every bound on realizing a bundle together, its own moves counted.** A course
of `m` moves, which `trace_steps` reads as `m` steps of the grammar, and then within `n` is within
`m + n` (`«迭内之接»`), read on traces by `withinMoves_iff_withinSteps`. -/
theorem WithinMoves.after_course {n : Nat} :
    ∀ {s t : S} {xs : List A}, Trace P s xs t → WithinMoves P realized t n bundle →
      WithinMoves P realized s (xs.length + n) bundle :=
  fun path within => match withinMoves_iff_withinSteps.mp within with
  | ⟨u, rest, holds⟩ =>
    withinMoves_iff_withinSteps.mpr ⟨u, «迭内之接» ⟨_, Nat.le_refl _, trace_steps path⟩ rest, holds⟩

/-- **Realizable together within some bound is a reachable configuration realizing the
bundle.** -/
theorem withinMoves_iff_reach {s : S} :
    (∃ n, WithinMoves P realized s n bundle) ↔ ∃ t, Reach P s t ∧ ∀ c, bundle c → realized t c :=
  ⟨fun ⟨_, word, t, path, _, holds⟩ => ⟨t, ⟨word, path⟩, holds⟩,
   fun ⟨t, ⟨word, path⟩, holds⟩ => ⟨word.length, word, t, path, Nat.le_refl _, holds⟩⟩

/-- **Along a course nothing becomes realizable together that was not before.** -/
theorem together_after_reach {s t : S} (onward : Reach P s t) :
    (∃ n, WithinMoves P realized t n bundle) → ∃ n, WithinMoves P realized s n bundle
  | ⟨n, within⟩ => match onward with
    | ⟨xs, path⟩ => ⟨xs.length + n, WithinMoves.after_course path within⟩

/-- **A bundle no longer realizable together marks a course with no way back.** -/
theorem lost_together_not_returns {s t : S}
    (before : ∃ n, WithinMoves P realized s n bundle)
    (after : ¬ ∃ n, WithinMoves P realized t n bundle) : ¬ Reach P t s :=
  fun back => after (together_after_reach back before)

end Together

end Becoming
