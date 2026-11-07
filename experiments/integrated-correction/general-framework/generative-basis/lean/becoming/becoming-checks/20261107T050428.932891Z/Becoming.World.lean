import Becoming.Frame

/-!
# The one unfolding: its records

The records every reading of the unfolding is stated in, with no premise among them. A `Web`
says, at each step, how far each condition stands, which formations are active, and what each
formation requires, needs and draws; it is a `Dependence` read along the step index
(`Web F C := Dependence Nat F C`), so a law of dependences stated once serves webs. A `Flow`
says which formations take part in each step and how much each takes from and gives to each
condition. An `Exchange` is what the relata take and give across one step, with nothing said of
what they stand at, and `total` sums a list of amounts.

**One base, the run.** A `World` is one kind of relatum and its history: a run (`Becoming.Frame`)
of the process that admits every step (`everyStep`), whose configurations are what the world is at
each step (`WebAt`: standings, activity, requirements, needs and drawing then) and whose moves are
its relata's exchanges. So a world is a run by its type, not by a theorem: the World family (`World`,
`Web`, `Flow`) is the standing-and-exchange reading of a run, by definition. `World.web` and
`World.flow` read the history along the step index, `World.move` is its exchange at a step, and
`World.of R L W` builds the world with relata `R`, flow `L` and web `W` (`World.of_web`,
`World.of_flow`, both `rfl`). Formations and conditions are roles of one relatum
(`Becoming.Roles`), not two kinds. The law a world shows, and the run of it that the world is, are in
`Becoming.Runs` (`World.law`, `World.run`, `World.run_history`).

Nothing here ties one record to another: balance (the history lying within the law of exchange,
`World.balanced_iff_law`), activity needing support and the other premises of `Becoming.Premises`
are gluings or local states, stated where they are used. The readings of one unfolding, in context
and with nothing glued, are one world (`Contextual.world` of `Becoming.Readings`, and
`Frame.world`, which keeps neither moves nor standings). What the records do commit to is a shared
index of steps and amounts counted in `Nat` (`Becoming.Sampling`, `Becoming.Interleavings`).

These are records over `Nat` and `Prop`. This module imports the frame (`Becoming.Frame`), which
rests on the grammar (`Becoming.Grammar`, `Becoming.GrammarMap`, `Becoming.GrammarLaws`),
`Becoming.Prelude` and the foundation's `GenerativeCore`; the core's one base is the run, in L0, and
the world's records stand on it. The definitions moved here unchanged, with their names, from
`Becoming.Dependence` (`Dependence`, and `Web`, now its reading along the steps),
`Becoming.Flow` (`Flow`), `Becoming.Arising` (`total`), `Becoming.Space` (`World`, now a
history), `Becoming.Runs` (`WebAt`) and `Becoming.Unfolding` (`Exchange`, `Exchange.taken`,
`Exchange.given`, `World.move`). Every declaration has an empty axiom report.
-/

namespace Becoming

universe u

/-- Levels of conditions, the formations active at each configuration, and which
conditions each formation there depends on (at what level) and draws on. -/
structure Dependence (S : Type u) (F C : Type) where
  level : S → C → Nat
  active : S → F → Prop
  requires : S → F → C → Prop
  need : S → F → C → Nat
  draws : S → F → C → Prop

/-- One unfolding read through conditions and the dependences among them, all of
which may change from step to step: the dependence read along the step index. -/
abbrev Web (F C : Type) := Dependence Nat F C

/-- Amounts flowing between formations and conditions across each step: the formations
taking part in the step, and how much each takes from and gives to each condition. -/
structure Flow (F C : Type) where
  present : Nat → List F
  take : Nat → F → C → Nat
  give : Nat → F → C → Nat

section Exchange

variable {R : Type}

/-- What the relata present take and give across a step, read as a move. -/
structure Exchange (R : Type) where
  present : List R
  take : R → R → Nat
  give : R → R → Nat

/-- What the relata present take from `c`. -/
def Exchange.taken (m : Exchange R) (c : R) : Nat :=
  total m.present fun f => m.take f c

/-- What the relata present give to `c`. -/
def Exchange.given (m : Exchange R) (c : R) : Nat :=
  total m.present fun f => m.give f c

end Exchange

/-- What a world is at one step: each relatum's standing, its activity, and what it requires,
needs and draws on then. -/
structure WebAt (R : Type) where
  level : R → Nat
  active : R → Prop
  requires : R → R → Prop
  need : R → R → Nat
  draws : R → R → Prop

/-- The process that admits every step from one configuration to another by any move. -/
def everyStep (S A : Type) : Generative.Process S A := ⟨fun _ _ _ => True⟩

/-- A world: its relata, read with one kind of relatum, and its history: at each step what it is
(a `WebAt`) and its relata's exchange across the step. -/
structure World where
  Relatum : Type
  history : Run (everyStep (WebAt Relatum) (Exchange Relatum))

namespace World

variable (w : World)

/-- The world's web: its history's snapshots read along the step index. -/
def web : Web w.Relatum w.Relatum :=
  ⟨fun t => (w.history.state t).level, fun t => (w.history.state t).active,
    fun t => (w.history.state t).requires, fun t => (w.history.state t).need,
    fun t => (w.history.state t).draws⟩

/-- The world's flow: its history's exchanges read along the step index. -/
def flow : Flow w.Relatum w.Relatum :=
  ⟨fun t => (w.history.act t).present, fun t => (w.history.act t).take, fun t => (w.history.act t).give⟩

/-- The world's move across the step from `t`: its relata's exchange. -/
def move (t : Nat) : Exchange w.Relatum :=
  w.history.act t

end World

/-- The world with relata `R`, flow `L` and web `W`. -/
def World.of (R : Type) (L : Flow R R) (W : Web R R) : World :=
  ⟨R, ⟨fun t => ⟨W.level t, W.active t, W.requires t, W.need t, W.draws t⟩,
    fun t => ⟨L.present t, L.take t, L.give t⟩, fun _ => trivial⟩⟩

/-- The web of the world with web `W` is `W`. -/
theorem World.of_web (R : Type) (L : Flow R R) (W : Web R R) : (World.of R L W).web = W :=
  rfl

/-- The flow of the world with flow `L` is `L`. -/
theorem World.of_flow (R : Type) (L : Flow R R) (W : Web R R) : (World.of R L W).flow = L :=
  rfl

end Becoming
