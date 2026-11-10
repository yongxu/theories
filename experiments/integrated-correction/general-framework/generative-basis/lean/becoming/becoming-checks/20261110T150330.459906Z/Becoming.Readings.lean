import Becoming.Reading
import Becoming.Context
import Becoming.ContextArrivalTraces
import Becoming.Unfolding

/-!
# Readings: one unfolding, read in context, glued where the readings agree

Ren, 14 October 2026, of the summary line “Stated on one spine is not the same as one unfolding”:
“what's left on this?”, and of `World`: “wasn't this about the whole and its parts, about
everything?”, then “please, finish all”. This module states one shape for the unity of what the
core says: whatever reads an unfolding is a reading in context; the readings of one unfolding are
always one world; a description free of context exists exactly where the readings glue; and
`World`, with its balance, is a case where two readings of change glue. With the rest of the whole
counted, every world is one run of the one law of exchange. The same standard of invariance,
applied to significance, leaves the continuation condition, the condition of chapter §6.15 (a hypothesis where a theorem takes it), as one horn of a dichotomy.

* **The readings of one unfolding are one world.** Along a run, the claims of a contextual
  system (`Contextual`), each read with its context, are the relata of one world, each active
  exactly where its context shows it with its value (`Contextual.world`, `Contextual.world_active`);
  as in `Frame.world`, nothing stands or is exchanged in it. No gluing is used, so this holds where
  context-free values are impossible, as for the Mermin–Peres square and what quantum states show
  (`Square.no_whole`, `Becoming.Quantum`'s `no_context_free_values`).
* **A description free of context is a gluing.** A frame of context-free claims fits exactly where
  what the contexts show glues at every configuration (`Contextual.fitsFree_iff` of `Becoming.Context`).
* **Balance is the gluing of two readings of change.** A change of a condition across a step is
  read by its standing, as the rise and the fall of its level, and by the exchange, as what the
  flow gave it beyond what it took and took beyond what it gave (`Flow.changeReadings`). The two
  read a change alike exactly where the levels and the exchange balance there
  (`changes_agree_iff`), so the readings glue across a step exactly where the flow balances there
  (`Flow.changeReadings_glue_iff`), at every step exactly where it balances
  (`Flow.changeReadings_glue_everywhere_iff`), and a frame of context-free claims of change fits
  exactly then (`Flow.changeReadings_free_iff`). With the rest counted they glue at every step
  (`Flow.changeReadings_glue_counting_rest`): the rest's exchange is the difference between the
  two readings, counted as a relatum.
* **Every world is one run of the law of exchange.** With the rest counted (`World.withRest`), the
  readings of change of every world glue at every step, its own readings glue exactly where it
  balances, and that is exactly where the rest is never active; and the world is a run of the law
  of exchange whose standings are the world's (`World.unity`). `World.exchangeRun` needed balance;
  with the rest counted no premise is used.
* **Significance by the same standard.** The laws of `Becoming.Novelty` hold for every part,
  however the part is drawn. Held to the same standard, the presupposition that one's own
  continuation has significance would hold however the boundary of the self is drawn
  (`BoundaryInvariant`). Where it does, the presupposition holds as the boundary is drawn
  somewhere exactly where the continuation of everything has significance from that standpoint
  (`presupposition_iff_all_of_invariant`, from `boundaryInvariant_iff_conditional` of
  `Becoming.Boundaries`), and it fails wherever one continuation lacks significance
  (`not_subTrue_of_invariant`); a rival bounded by a region holding the self's closure meets the
  standard exactly where the region is everything (`bounded_invariant_iff`, from
  `boundaryInvariant_iff_all`). So under the standard no significance stops at a boundary: from a
  standpoint, holding within some boundary is holding for everything. These two theorems restate
  checked results of `Becoming.Boundaries` as this dichotomy; they are not new results.

**Readings (the AI's, adopted on Ren's delegation of 15 October 2026, DELEGATED-CHOICES D23).**
- What the core states on many types (flows, webs, worlds, processes, frames, contextual systems)
  are readings of one unfolding. A reading is a context; where the readings agree, a description
  free of context is their gluing, and `World` is such a description. The general case is the
  readings in context, which always make one world of indexed claims.
- Balance says that the standing and the exchange read one change alike. Counting the rest of
  the whole as a relatum is counting the difference between the two readings, and then every
  world is a run of the one law of exchange. What was a premise of the world is now a state of a
  part: whether the rest is idle.
- The continuation condition, the condition of chapter §6.15 (a hypothesis where a theorem takes it), is not a further rule beside the
  laws. Under the invariance the laws meet,
  significance from a standpoint holds within some boundary only by holding for everything, and
  the continuation condition comes to the presupposition: that one's own continuation has significance as the self
  is drawn somewhere, the “belief” without which, Ren wrote on 10 October 2026, the self “can not
  justify itself”.

What is not derived: that the readings of an unfolding glue, which fails for what quantum
states show; which readings an unfolding has; what the rest of the whole is, since its exchange
is read off the standings and the exchange of the formations, as their difference; that
significance meets the invariance standard, and that the presupposition holds. No ethical predicate, ranking or axiom occurs; the significance
of the condition of chapter §6.15 enters only as a predicate the theorems quantify over.

`presupposition_iff_all_of_invariant` and `bounded_invariant_iff` are in `Becoming.Boundaries`
(board item W).
-/

namespace Becoming

open Generative

variable {F C Pos : Type}

/-! ## The readings of one unfolding are one world -/

namespace Contextual

variable {S K C V : Type} (X : Contextual S K C V)

/-- **The readings of one unfolding are one world.** Along a run, each claim of a contextual
system read with its context is a relatum, active exactly where its context shows it with its
value. No gluing is used. -/
def world {A : Type} (P : Process S A) (r : Run P) : World :=
  (X.indexed P).world r

/-- What a context shows is a relatum's activity. -/
theorem world_active {A : Type} {P : Process S A} {r : Run P} {t : Nat} {q : K × C × V} :
    (X.world P r).web.active t q ↔ X.within q.1 q.2.1 ∧ X.shows (r.state t) q.1 q.2.1 = q.2.2 :=
  Iff.rfl

end Contextual

/-! ## Balance is the gluing of two readings of change -/

/-- Two readings of change: by standing, and by exchange. -/
inductive ChangeReading where
  | standing
  | exchange

/-- What each reading reads of the change of each condition across the step from `t`, as what
it rose and what it fell: standing reads the rise and the fall of the level; exchange
reads what the flow gave beyond what it took, and took beyond what it gave. -/
def Flow.changeReadings (L : Flow F C) (W : Web F C) :
    Contextual Nat ChangeReading C (Nat × Nat) :=
  ⟨fun _ _ => True, fun t k c => match k with
    | .standing => (W.level (t + 1) c - W.level t c, W.level t c - W.level (t + 1) c)
    | .exchange => (L.given t c - L.taken t c, L.taken t c - L.given t c)⟩

/-- Adding one amount to both sides leaves the difference. -/
theorem sub_add_add_right (n m : Nat) : ∀ k, n + k - (m + k) = n - m
  | 0 => rfl
  | k + 1 => (Nat.succ_sub_succ (n + k) (m + k)).trans (sub_add_add_right n m k)

/-- Where `b + p = a + q`, what `b` exceeds `a` by is what `q` exceeds `p` by. -/
theorem sub_eq_of_add_eq {a b p q : Nat} (same : b + p = a + q) : b - a = q - p :=
  (sub_add_add_right b a p).symm.trans
    ((congrArg (· - (a + p)) same).trans
      ((congrArg (· - (a + p)) (Nat.add_comm a q)).trans
        ((congrArg (q + a - ·) (Nat.add_comm a p)).trans (sub_add_add_right q p a))))

/-- Where the excesses agree both ways, `b + p = a + q`. -/
theorem add_eq_of_sub_eq {a b p q : Nat} (rise : b - a = q - p) (fall : a - b = p - q) :
    b + p = a + q :=
  have left : b + (a - b) = a + (b - a) := (add_sub_turn b a).symm
  have right : p + (b - a) = q + (a - b) :=
    (congrArg (p + ·) rise).trans ((add_sub_turn q p).trans (congrArg (q + ·) fall.symm))
  add_right_cancel (a - b + (b - a)) (calc
    b + p + (a - b + (b - a)) = b + (a - b) + (p + (b - a)) := Nat.add_add_add_comm b p (a - b) (b - a)
    _ = a + (b - a) + (q + (a - b)) :=
        (congrArg (· + (p + (b - a))) left).trans (congrArg (a + (b - a) + ·) right)
    _ = a + q + (b - a + (a - b)) := Nat.add_add_add_comm a (b - a) q (a - b)
    _ = a + q + (a - b + (b - a)) := congrArg (a + q + ·) (Nat.add_comm (b - a) (a - b)))

/-- **Two readings read one change alike exactly where they balance.** The rise and the fall
from `a` to `b` are the excesses of `q` over `p` and of `p` over `q` exactly where
`b + p = a + q`. -/
theorem changes_agree_iff {a b p q : Nat} : (b - a, a - b) = (q - p, p - q) ↔ b + p = a + q :=
  ⟨fun same => add_eq_of_sub_eq (congrArg Prod.fst same) (congrArg Prod.snd same),
   fun balanced => congr (congrArg Prod.mk (sub_eq_of_add_eq balanced))
     (sub_eq_of_add_eq balanced.symm)⟩

namespace Flow

variable {L : Flow F C} {W : Web F C}

/-- The two readings agree across the step from `t` exactly where the flow balances there. -/
theorem changeReadings_agree_iff {t : Nat} :
    (L.changeReadings W).Agree t ↔
      ∀ c, W.level (t + 1) c + L.taken t c = W.level t c + L.given t c :=
  ⟨fun agree c => changes_agree_iff.mp (agree .standing .exchange c trivial trivial),
   fun balanced k k' c _ _ => match k, k' with
     | .standing, .standing => rfl
     | .standing, .exchange => changes_agree_iff.mpr (balanced c)
     | .exchange, .standing => (changes_agree_iff.mpr (balanced c)).symm
     | .exchange, .exchange => rfl⟩

/-- **Balance is gluing.** The readings of change glue across the step from `t` exactly where the
flow balances there. -/
theorem changeReadings_glue_iff {t : Nat} :
    (L.changeReadings W).Glues t ↔
      ∀ c, W.level (t + 1) c + L.taken t c = W.level t c + L.given t c :=
  ((L.changeReadings W).glues_iff_agree (fun _ => .standing) (fun _ => trivial) t).trans
    changeReadings_agree_iff

/-- They glue at every step exactly where the flow balances. -/
theorem changeReadings_glue_everywhere_iff : (∀ t, (L.changeReadings W).Glues t) ↔ L.Balances W :=
  ⟨fun glues t c => changeReadings_glue_iff.mp (glues t) c,
   fun balances t => changeReadings_glue_iff.mpr (balances t)⟩

/-- So a frame of context-free claims of change fits exactly where the flow balances. -/
theorem changeReadings_free_iff {A : Type} (P : Process Nat A) :
    (∃ Fr : Frame Nat A (C × (Nat × Nat)), Fr.P = P ∧ (L.changeReadings W).FitsFree Fr) ↔
      L.Balances W :=
  ((L.changeReadings W).fitsFree_iff P (fun _ => .standing) (fun _ => trivial)).trans
    changeReadings_glue_everywhere_iff

/-- **Counting the rest glues them.** With the rest of the whole counted as a relatum, the
readings of change glue at every step. -/
theorem changeReadings_glue_counting_rest (t : Nat) :
    ((L.withImbalance W).changeReadings W.withRefinement).Glues t :=
  changeReadings_glue_iff.mpr (withImbalance_balances t)

end Flow

/-! ## Every world is one run of the law of exchange -/

/-- **Every world is one run of the law of exchange, its balance the gluing of its readings.**
With the rest counted, the readings of change of every world glue at every step, and the world is
a run of the law of exchange whose standings are the world's. Its own readings glue at every step
exactly where it balances, which is exactly where the rest is never active. No premise is used. -/
theorem World.unity (w : World) :
    (∃ r : Run (exchange (Option w.Relatum)), ∀ t x, r.state t (some x) = w.web.level t x) ∧
      (∀ t, (w.withRest.flow.changeReadings w.withRest.web).Glues t) ∧
      ((∀ t, (w.flow.changeReadings w.web).Glues t) ↔ w.Balanced) ∧
      (w.Balanced ↔ ∀ t, ¬ w.withRest.web.active t none) :=
  ⟨⟨w.withRest.exchangeRun World.withRest_balanced, fun _ _ => rfl⟩,
   Flow.changeReadings_glue_everywhere_iff.mpr World.withRest_balanced,
   Flow.changeReadings_glue_everywhere_iff,
   World.withRest_closed_iff.symm⟩

end Becoming
