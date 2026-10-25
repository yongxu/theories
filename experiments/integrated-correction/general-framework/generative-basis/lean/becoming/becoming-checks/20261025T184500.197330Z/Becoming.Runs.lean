import Becoming.Reading
import Becoming.Propagation
import Becoming.Branching

/-!
# Runs: every reading of the unfolding is a run

The spine states its laws on several readings of one unfolding: the runs of a process
(`Generative.Process`, `Becoming.Run`), a world's flow and web (`Becoming.World`), the course a law
of exchange generates (`ExchangeLaw`), the orbit of a determined law (`Law.orbit`), and the amounts
that coupling strengths carry (`carried`). They were joined by correspondence theorems in both
directions, each reading some of the data. The run, what the unfolding is at each step and how it
goes on to the next, is the World package's formal root (D43) and one model of the grammar
(`Becoming.Grammar`), which is the root. For the world, being a run holds by definition: a world's
history is a run of the process that admits every step (`World.history`, `Becoming.World`), so the World family is
the standing-and-exchange reading of a run. This module states that each of the other readings is a
run too, exactly, with nothing read away. No premise enters beyond what each theorem names.

* **A world is a run.** A world's web at a step (`World.webAt`, a `WebAt`: standings, activity,
  requirements, needs and drawing then) is its history's configuration, and its relata's exchange
  across the step (`World.move`) its history's move. Every world is a run of the law it shows
  (`World.law`, `World.run`), with its history's configurations and moves (`World.run_history`),
  and every run whose configurations are webs and whose moves are exchanges is a world
  (`Run.world`). The two readings are one: the world of a world's run is the
  world (`World.run_world`), and the run of a run's world has its configurations and moves
  (`Run.world_webAt`, `Run.world_move`, `Run.world_run`). A world's web is its run read through the
  dependences its webs carry (`World.web_along`, `Dependence.along`).
* **A balanced world is a run of the law of exchange.** The law of exchange read on webs
  (`exchangeAt`) relates two webs by an exchange where each relatum's standing after it, with what
  is taken from it, is its standing before with what is given to it; the relations of dependence
  may change in any way. A world balances exactly where its run is a run of it
  (`World.balanced_iff_run`), exactly where the law it shows lies within it
  (`World.balanced_iff_law`), and exactly where some run of it has the world's webs and exchanges
  (`World.balanced_iff_exists_run`). Every run of it is a balanced world (`Run.step`), so
  balanced worlds and runs of the law of exchange on webs are one (`World.balancedRun`). The
  standings of that run are `World.exchangeRun`'s (`World.balancedRun_level`). With the rest
  counted, every world, its whole web and not only its standings, is a run of the law of exchange,
  with no premise (`World.restRun`, `World.restRun_web`), extending `World.unity`.
* **A course of a law of exchange is a run.** The course a law generates, with formations and
  conditions read as roles of one relatum (`World.ofRoles`), is a world (`ExchangeLaw.courseWorld`)
  whose standings are the levels the law generates (`ExchangeLaw.courseWorld_level`). Under a law of
  what has stood it balances exactly where the course is feasible
  (`ExchangeLaw.courseWorld_balanced_iff`), so a feasible course is a run of the law of exchange
  (`ExchangeLaw.courseRun`). Its generation is a run too: the determined process of the stage and
  the history so far (`ExchangeLaw.process`) has exactly one run from the start, the generated
  history (`ExchangeLaw.process_runs`), from which the world's standings are read
  (`ExchangeLaw.courseWorld_process`).
* **The carried amount is a run.** The amount coupling strengths carry (`Becoming.Propagation`'s
  `carried`) is the standing of the world the carrying law generates (`carriedWorld`,
  `carriedWorld_level`). That world balances with no premise (`carriedWorld_balanced`), so the
  carried amount is the standing of a run of the law of exchange (`carriedRun`,
  `carriedRun_level`): how much difference arrives is itself a course of the one law.
* **An orbit is a run.** The orbit of a determined law is the run of its process (`Law.run`,
  `Becoming.Recurrence`), and every run of that process is the orbit from its start
  (`Branching.law_run_state`); readings in context are a world along every run
  (`Contextual.world`, `Becoming.Readings`). They are cited here, not restated.

**Readings (the AI's, D43).**
- The run is the package's formal root because every other reading is one, and not conversely as
  stated: a world is a run by its type and a run of the law it shows (P69's `Shown`), a balanced world is a run of the
  law of exchange, a course and the amount it carries are runs, an orbit is one. This does not
  make the run a ground beneath the world: a run is the unfolding read step by step, what it is at
  each step and how it goes on, and the world is the same unfolding read as relata of one kind
  exchanging. The
  identification is exact, so the two are one reading of one unfolding, not two things joined.
- The law is read off the unfolding, the identifications above being exact. What a
  world adds to its run is nothing; what the law of exchange adds is the relation of standing and
  exchange that balance states, as a law of the run's steps.

What is not derived: that every process is the law of some world (a process's configurations
need not be webs; `Frame.world` reads a run's claims as a world but keeps neither moves nor
standings); that the readings glue (balance is a condition, not given with every world); the
shared index of steps and the natural amounts (commitments of the representation). No ethical
predicate, ranking or axiom occurs.

`ExchangeLaw.courseWorld`, `ExchangeLaw.courseWorld_balanced_iff` and `carriedWorld` with its laws
are in `Becoming.Propagation`, where the modules using them read them.
-/

namespace Becoming

open Generative

/-! ## A world is a run -/

/-- The webs at each step read as configurations: the dependences each web carries. -/
def WebAt.dependence (R : Type) : Dependence (WebAt R) R R :=
  ⟨fun x => x.level, fun x => x.active, fun x => x.requires, fun x => x.need, fun x => x.draws⟩

namespace World

variable (w : World)

/-- The world's web at step `t`: its history's configuration. -/
def webAt (t : Nat) : WebAt w.Relatum :=
  w.history.state t

/-- The law a world shows: its steps from each web to the next by its relata's exchange. -/
def law : Process (WebAt w.Relatum) (Exchange w.Relatum) :=
  Shown w.webAt w.move

/-- **Every world is a run** of the law it shows: its configurations are its webs at each step,
its moves its relata's exchanges. -/
def run : Run w.law :=
  Shown.run w.webAt w.move

end World

/-- **A world's run is its history.** The run of the law a world shows has the configurations
and moves of the world's history, the run of every step; only the law it is read as a run of is
narrowed, to the steps the history takes. -/
theorem World.run_history (w : World) :
    w.run.state = w.history.state ∧ w.run.act = w.history.act :=
  ⟨rfl, rfl⟩

/-- A run whose configurations are webs and whose moves are exchanges, read as a world. -/
def Run.world {R : Type} {P : Process (WebAt R) (Exchange R)} (r : Run P) : World :=
  ⟨R, ⟨r.state, r.act, fun _ => trivial⟩⟩

/-- **A world is its run.** Read as a world, the run of a world is that world. -/
theorem World.run_world (w : World) : w.run.world = w :=
  rfl

section RunWorld

variable {R : Type} {P : Process (WebAt R) (Exchange R)} (r : Run P)

/-- **A run is its world.** The world of a run has the run's configurations as its webs. -/
theorem Run.world_webAt (t : Nat) : r.world.webAt t = r.state t :=
  rfl

/-- and the run's moves as its exchanges. -/
theorem Run.world_move (t : Nat) : r.world.move t = r.act t :=
  rfl

/-- The run a run's world shows has the run's configurations and moves. -/
theorem Run.world_run (t : Nat) : r.world.run.state t = r.state t ∧ r.world.run.act t = r.act t :=
  ⟨rfl, rfl⟩

end RunWorld

/-- **A world's web is its run read through its dependences.** -/
theorem World.web_along (w : World) : (WebAt.dependence w.Relatum).along w.run = w.web :=
  rfl

/-! ## A balanced world is a run of the law of exchange -/

/-- The law of exchange read on webs: across a step each relatum's standing after it, with what is
taken from it, is its standing before with what is given to it. The relations of dependence may
change in any way. -/
def exchangeAt (R : Type) : Process (WebAt R) (Exchange R) :=
  ⟨fun x m y => (exchange R).step x.level m y.level⟩

namespace World

variable (w : World)

/-- **A world balances exactly where its run runs by the law of exchange.** -/
theorem balanced_iff_run :
    w.Balanced ↔ ∀ t, (exchangeAt w.Relatum).step (w.webAt t) (w.move t) (w.webAt (t + 1)) :=
  Iff.rfl

/-- **A world balances exactly where the law it shows lies within the law of exchange.** -/
theorem balanced_iff_law :
    w.Balanced ↔ ∀ x m y, w.law.step x m y → (exchangeAt w.Relatum).step x m y :=
  w.balanced_iff_run.trans shown_le_iff.symm

/-- A balanced world as a run of the law of exchange on webs. -/
def balancedRun (balanced : w.Balanced) : Run (exchangeAt w.Relatum) :=
  ⟨w.webAt, w.move, balanced⟩

/-- **A world balances exactly where some run of the law of exchange has its webs and
exchanges.** -/
theorem balanced_iff_exists_run :
    w.Balanced ↔ ∃ r : Run (exchangeAt w.Relatum), ∀ t, r.state t = w.webAt t ∧ r.act t = w.move t :=
  ⟨fun balanced => ⟨w.balancedRun balanced, fun _ => ⟨rfl, rfl⟩⟩,
   fun ⟨r, same⟩ t c =>
    have step : (exchange w.Relatum).step (w.webAt t).level (w.move t) (w.webAt (t + 1)).level :=
      (same (t + 1)).1 ▸ (same t).1 ▸ (same t).2 ▸ r.step t
    step c⟩

/-- The standings of a balanced world's run are those of `World.exchangeRun`. -/
theorem balancedRun_level (balanced : w.Balanced) (t : Nat) :
    ((w.balancedRun balanced).state t).level = (w.exchangeRun balanced).state t :=
  rfl

/-- **With the rest counted, every world is a run of the law of exchange on webs**, with no
premise: its whole web, not only its standings. -/
def restRun : Run (exchangeAt (Option w.Relatum)) :=
  w.withRest.balancedRun World.withRest_balanced

/-- The rest's run carries the world's standings, requirements and needs. -/
theorem restRun_web (t : Nat) (g d : w.Relatum) :
    (w.restRun.state t).level (some d) = w.web.level t d ∧
      ((w.restRun.state t).requires (some g) (some d) ↔ w.web.requires t g d) ∧
      (w.restRun.state t).need (some g) (some d) = w.web.need t g d :=
  ⟨rfl, Iff.rfl, rfl⟩

end World

/-- **Balanced worlds and runs of the law of exchange are one.** The balanced world's run read as
a world is the world, and a run read as a world and back is the run. -/
theorem World.balancedRun_world (w : World) (balanced : w.Balanced) :
    (w.balancedRun balanced).world = w ∧
      ∀ {R : Type} (r : Run (exchangeAt R)) (t : Nat),
        (r.world.balancedRun (Run.step r)).state t = r.state t ∧
          (r.world.balancedRun (Run.step r)).act t = r.act t :=
  ⟨rfl, fun _ _ => ⟨rfl, rfl⟩⟩

/-! ## A course of a law of exchange is a run -/

section Course

variable {F C : Type}

variable {law : ExchangeLaw F C} {present : Nat → List F} {start : C → Nat} {W : Web F C}

/-- The course world's conditions stand at the levels the law generates. -/
theorem ExchangeLaw.courseWorld_level (t : Nat) (c : C) :
    (law.courseWorld present start W).web.level t (.inr c) = law.levels present start t c :=
  rfl

/-- A feasible course of a law of what has stood as a run of the law of exchange on webs. -/
def ExchangeLaw.courseRun (na : law.Nonanticipating) (feasible : law.Feasible present start) :
    Run (exchangeAt (F ⊕ C)) :=
  (law.courseWorld present start W).balancedRun
    ((ExchangeLaw.courseWorld_balanced_iff na).mpr feasible)

/-- **A feasible course runs by the law of exchange**, its configurations the course world's webs
and its moves the course world's exchanges. -/
theorem ExchangeLaw.courseRun_state (na : law.Nonanticipating)
    (feasible : law.Feasible present start) (t : Nat) (c : C) :
    ((ExchangeLaw.courseRun (W := W) na feasible).state t).level (.inr c) =
      law.levels present start t c :=
  rfl

/-- The generation of a law's course: the determined process of the stage and the history so
far. -/
def ExchangeLaw.process (law : ExchangeLaw F C) (present : Nat → List F) :
    Process (Nat × (Nat → C → Nat)) Unit :=
  Law.process (law.next present)

/-- **A course's generation has one run from the start: the generated history.** -/
theorem ExchangeLaw.process_runs (r : Run (law.process present))
    (begins : r.state 0 = (0, fun _ => start)) :
    ∀ n, r.state n = (n, law.history present start n) :=
  fun n => (Branching.law_run_state r n).trans
    ((congrArg (fun x => Law.orbit (law.next present) x n) begins).trans
      (ExchangeLaw.history_orbit start n))

/-- **The course world's standings are read off the run of its generation.** -/
theorem ExchangeLaw.courseWorld_process (r : Run (law.process present))
    (begins : r.state 0 = (0, fun _ => start)) (t : Nat) (c : C) :
    (law.courseWorld present start W).web.level t (.inr c) = (r.state t).2 t c :=
  (congrArg (fun x => x.2 t c) (ExchangeLaw.process_runs r begins t)).symm

end Course

/-! ## The carried amount is a run -/

section Carried

variable {F C : Type} {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- The carried world as a run of the law of exchange on webs. -/
def carriedRun (cs : List C) (part : F → Bool) (σ : Nat → F → C → Nat)
    (k : Nat → F → C → Nat → C → Nat) (present : Nat → List F) (δ : C → Nat) :
    Run (exchangeAt (F ⊕ C)) :=
  (carriedWorld cs part σ k present δ).balancedRun carriedWorld_balanced

/-- **The carried amount is the standing of a run of the law of exchange.** -/
theorem carriedRun_level (t : Nat) (c : C) :
    ((carriedRun cs part σ k present δ).state t).level (.inr c) = carried cs part σ k present δ t c :=
  rfl

end Carried

end Becoming
