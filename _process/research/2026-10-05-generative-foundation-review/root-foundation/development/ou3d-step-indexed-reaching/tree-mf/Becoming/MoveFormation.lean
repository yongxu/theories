import Becoming.Counterfactual
import Becoming.Readout
import Becoming.Mechanism

/-!
# Coupling: where a move is formed

A labelled process `Process S A` takes its move from an alphabet of its own. `Becoming.Unfolding`
(P69) reads the move into the configuration (`withMove`) and forms it by a policy of the
configuration (`closedBy`), and leaves as not derived that a move is formed within the unfolding,
or by what. The records of P69 and P80 (process-and-frame-as-readings,
counterfactual-is-the-course) ask when a move is formed within the unfolding, a formation's and
not supplied from outside, and when it is the part's own. This module answers within the theory without axiom, with
no premise beyond what each law names, for a part and the rest of a whole coupled by one move:
where the move is formed (by the part, by the rest, or only by their relation), that no move
needs supplying from outside the whole, and what the record of one course fixes of it.

* **One move, two sides.** In the coupled whole (`coupled`), the synchronized product of
  `GenerativeCore` with the move read off the joint configuration, the whole has one action, and
  the part and the rest take one move at every step (`Run.part`, `Run.rest`,
  `Run.part_act_eq_rest_act`); the shared move is what relates them (`Fork.label_couples` of
  `Becoming.Unfolding`). The coupled whole is P69's `closedBy` of the product, read with the move
  off the configuration (`Run.toClosedBy`, `Run.ofClosedBy`, `Run.ofClosedBy_toClosedBy`); a
  coupling of determined laws is determined (`coupled_determined`).
* **Formed through a reading.** A move is formed through a reading of the configuration where
  configurations read alike form one move: it goes alike across what the reading lumps
  (`Learning.Lumped` of `Becoming.Learning`), as a move that a policy of the reading gives does
  (`Readout.lumped_of_decodes` of `Becoming.Readout`). Every move formed within the whole is
  formed through the whole's configuration (`lumped_id`); a move formed through a reading is
  formed through every reading that tells apart at least as much (`lumped_of_finer`); through the
  reading that tells nothing apart, only a move that is the same everywhere is formed
  (`lumped_const_iff`).
* **The part's, the rest's, or the relation's.** The move is the part's (`PartForms`) exactly
  where it is a policy of the part (`partForms_iff`), the rest's (`RestForms`) exactly where it is
  a policy of the rest (`restForms_iff`), and both exactly where it is the same everywhere
  (`partForms_and_restForms_iff`): a move that differs anywhere is formed by at most one of them
  alone, and a move formed by their relation is formed by neither alone
  (`Parity.neither_alone`).
* **An own move closes the part and is the rest's input.** Where the part's law is determined and
  the move is the part's, the part carries a law of its own (`PartForms.goAlike`, from the
  grammar's law of the image through `image_determined_iff`), and its course is the same whatever
  the rest (`PartForms.parts_agree`).
  Where the laws are functions, each side's course is the trajectory of the standard model
  (`trajectory` of `Becoming.Mechanism`) whose input is the move (`Run.part_trajectory`,
  `Run.rest_trajectory`). The part's own move goes round within the part (`Run.part_orbit`) and is
  the rest's input (`Run.rest_driven_by_part`); the rest's own move goes round within the rest
  (`Run.rest_orbit`) and so drives the part; the whole goes round by one determined law
  (`wholeNext`, `Run.whole_orbit`). Closed is not the same as forming one's move: a part to which
  the move makes no difference is closed against the rest while its move is the rest's
  (`TwoClocks.closed_not_own`).
* **No move needs supplying from outside the whole.** Every run of a labelled process, whatever its
  moves, is the part's course in a whole of one action whose rest is a clock that forms the move
  (`clock`, `clock_determined`, `Run.withClock`, `Run.withClock_part`,
  `Run.withClock_restForms`). The counterfactual's supplied moves are of this kind: in the
  standard model of a course (`Becoming.Counterfactual`), the act of a law that reads nothing is
  formed through the stage alone (`ExchangeLaw.ofMoves_lumped_stage`). This is the
  counterpart for moves of `World.withRest` (`Becoming.Reading`), which counts the rest of the
  whole as a relatum so that every world balances and is one run of the law of exchange
  (`World.unity` of `Becoming.Readings`): there the rest's exchange is read off the world, as the
  difference between two readings of change; here the rest's forming of the move is read off the
  course.
* **What a list holds repeats.** Where the laws are functions, moves formed within a whole held by
  a list repeat, from some step with some period, within the list's length
  (`Run.moves_lasso_of_whole_held`, through `Learning.lasso_of_held`), and so do the moves of a
  rest held by a list where the rest forms them, and of a part held by a list where the part does
  (`Run.moves_lasso_of_rest_held`, `Run.moves_lasso_of_part_held`). Every lasso is so formed, by a
  rest of its `i + q + 1` positions (`lassoRest`, `Run.withLasso`, `Run.withLasso_held`,
  `Run.withLasso_part`). Moves that never settle into a cycle need a whole that no list holds,
  and a former that no list holds (`Run.whole_unheld_of_never_cycles`,
  `Run.rest_unheld_of_never_cycles`, `Run.part_unheld_of_never_cycles`).
* **What the record fixes.** Along a course, the moves read as formed through the configurations
  where they never differ at one configuration (`Learning.Lumped` along the course): exactly
  where some relation giving at most one move at each configuration gives every move, with no
  decision needed (`lumped_iff_singleValued`, with `Readout.SingleValued`; the reading of the
  course, `Readout.Reading`, is the least such, `reading_le`), and, on a finite stretch with
  equality of configurations decided, exactly where a policy of the configuration gives them
  (`lumped_upto_iff`). The record excludes the reading exactly where some configuration recurs
  with the move varied (`no_policy_upto_iff`, with equality of configurations and of moves
  decided; `not_lumped_of_varied`); where the part recurs with the move varied, the rest differs
  there (`rest_differs_of_varied`). Where nothing recurs, every course reads so
  (`lumped_of_new`): a part keeping its history (`keepHistory` of `Becoming.Experiment`) reads
  every move it makes as its own, a policy of its configuration giving them
  (`Run.keepHistory_formed`, with `Readout.Decodes`). One course can be admitted by
  the part's law of the move and by the rest's, which differ only where it never goes
  (`TwoClocks.one_course_two_laws`): like requirement in `Becoming.Reading`
  (`ExchangeLaw.requirement_beyond_course`), whose move it is belongs to the law, a counterfactual
  that one course does not fix. A part that stays as it is while the move alternates does not form
  it (`Still.driven`).

**Readings.** Ren, 12 October 2026, of the reading that law and history are one unfolding read
two ways: "yes, i do agree with your reading, there are no two realities". The readings below,
which carry it to the move, are the AI's, adopted on Ren's delegation of 15 October 2026, with their
qualifiers (DELEGATED-CHOICES D24).
- Acting and undergoing are one move read from its two sides. An actor is not a kind of being but
  a part through whose configuration a move is formed, relative to where the whole is cut into
  part and rest; whose move it is, is a relation of the move to configurations, not a property of
  either part.
- Nothing needs supplying from outside the whole. An input is the rest's configuration, and a
  label from outside is a move whose forming the representation leaves out. As with the rest's
  exchange in `Becoming.Readings`, what was supplied becomes a state of the rest, read off.
- Whose move it is, is a claim about courses not taken: the law of the move. One course fixes it
  only where a configuration recurs with the move varied. This is the counterpart of
  `Becoming.Experiment`: an experiment varies one's own move where the configuration returns, and
  attribution sees the move vary where a configuration returns. A part that keeps its history can
  read every move as its own and its record never excludes it; but then, by
  `Becoming.Recurrence`, it never returns.
- Reading more, more is one's own: reading what forms a move makes the move formed through
  what one is.
- Closed is not one's own: a part closed against the rest may still not form its moves.
- Novelty in what is done needs openness or growth: moves that never settle into a cycle are
  formed by nothing a list holds.

What is not derived: which cut of an actual unfolding into part and rest is apt, and that any
part's move is in fact its own; where a law is not determined, which successor a run takes, which
nothing here forms; a measure of how much of a move a part forms (the measure of coupling among
the theory chapter's further proofs); the counterfactual's act read through the part's own
couplings (`ExchangeLaw.Through` of `Becoming.Counterfactual` is stated for the formations
outside the part); continuous time. The finite-stretch policy and the exclusion take decided
equality as hypotheses. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

open Generative

universe u v w u' v'

/-! ## A part and the rest coupled by one move -/

section Coupled

variable {S : Type u} {E : Type v} {A : Type w}

/-- A part and the rest coupled by one move formed within the whole: at the joint configuration
`x`, the part at `x.1` and the rest at `x.2`, the move is `form x`, and it takes the part by its
law `P` and the rest by its law `Q` together (the synchronized product `productProcess` of
`GenerativeCore`, the move read off the joint configuration). The whole has one action: nothing
is supplied to it. -/
def coupled (P : Process S A) (Q : Process E A) (form : S × E → A) : Process (S × E) Unit :=
  ⟨fun x _ y => (productProcess P Q).step x (form x) y⟩

variable {P : Process S A} {Q : Process E A} {form : S × E → A}

/-- The part's course in a run of the coupled whole: a run of the part's law, its moves those the
whole forms. -/
def Run.part (r : Run (coupled P Q form)) : Run P :=
  ⟨fun n => (r.state n).1, fun n => form (r.state n), fun n => (r.step n).1⟩

/-- The rest's course in a run of the coupled whole: a run of the rest's law by the same moves. -/
def Run.rest (r : Run (coupled P Q form)) : Run Q :=
  ⟨fun n => (r.state n).2, fun n => form (r.state n), fun n => (r.step n).2⟩

/-- **One move, two sides.** At every step the part and the rest take one move: what the part
does is what the rest undergoes, and what the rest does is what the part undergoes. -/
theorem Run.part_act_eq_rest_act (r : Run (coupled P Q form)) (n : Nat) :
    r.part.act n = r.rest.act n :=
  rfl

/-- A run of the coupled whole read with its move inside its configuration: a run of P69's
`closedBy` of the synchronized product. -/
def Run.toClosedBy (r : Run (coupled P Q form)) : Run (closedBy (productProcess P Q) form) :=
  ⟨fun n => (r.state n, form (r.state n)), fun _ => (), fun n => ⟨r.step n, rfl⟩⟩

/-- Along a run of `closedBy` whose move is formed at the start, the move inside is formed at
every step. -/
theorem closedBy_formed {r : Run (closedBy (productProcess P Q) form)}
    (begins : (r.state 0).2 = form (r.state 0).1) : ∀ n, (r.state n).2 = form (r.state n).1
  | 0 => begins
  | n + 1 => (r.step n).2

/-- **The coupled whole is P69's `closedBy` of the product.** A run of `closedBy` whose move is
formed at the start is a run of the coupled whole; with `Run.toClosedBy`, the two are one run
read with the move inside or read off. -/
def Run.ofClosedBy (r : Run (closedBy (productProcess P Q) form))
    (begins : (r.state 0).2 = form (r.state 0).1) : Run (coupled P Q form) :=
  ⟨fun n => (r.state n).1, fun _ => (),
   fun n => Eq.subst (motive := fun a => (productProcess P Q).step (r.state n).1 a (r.state (n + 1)).1)
     (closedBy_formed begins n) (r.step n).1⟩

/-- Read off and read back, the joint configurations are the same. -/
theorem Run.ofClosedBy_toClosedBy (r : Run (coupled P Q form)) (n : Nat) :
    (r.toClosedBy.ofClosedBy rfl).state n = r.state n :=
  rfl

/-- **A coupling of determined laws is determined.** -/
theorem coupled_determined (dP : Determined P) (dQ : Determined Q) :
    Determined (coupled P Q form) :=
  fun x _ y y' step step' =>
    match y, y', step, step' with
    | (t, f), (t', f'), ⟨here, there⟩, ⟨here', there'⟩ => by
      cases dP x.1 (form x) t t' here here'
      cases dQ x.2 (form x) f f' there there'
      rfl

end Coupled

/-! ## Formed through a reading -/

section Formed

variable {X : Type u} {K : Type v} {K' : Type u'} {A : Type w}

/-- **Every move formed within the whole is formed through the whole's configuration.** A move is
formed through a reading `π` of the configuration where it goes alike across what `π` lumps
(`Learning.Lumped`); a move that a policy of `π` gives is so (`Readout.lumped_of_decodes`). -/
theorem lumped_id (form : X → A) : Learning.Lumped id form :=
  fun _ _ same => congrArg form same

/-- **Reading more, more is formed through what is read.** A move formed through a reading is
formed through every reading that tells apart at least what it tells apart. -/
theorem lumped_of_finer {form : X → A} {π : X → K} {π' : X → K'}
    (formed : Learning.Lumped π form) (finer : ∀ x x', π' x = π' x' → π x = π x') :
    Learning.Lumped π' form :=
  fun x x' same => formed x x' (finer x x' same)

/-- Through the reading that tells nothing apart, only a move that is the same everywhere is
formed. -/
theorem lumped_const_iff {form : X → A} (k : K) :
    Learning.Lumped (fun _ => k) form ↔ ∀ x x', form x = form x' :=
  ⟨fun formed x x' => formed x x' rfl, fun same x x' _ => same x x'⟩

end Formed

/-! ## The part's move, the rest's move, and the whole's -/

section Whose

variable {S : Type u} {E : Type v} {A : Type w}

/-- The move is the part's: formed through the part's configuration, whatever the rest's; it
goes alike across joint configurations with one configuration of the part (`Learning.Lumped`). -/
def PartForms (form : S × E → A) : Prop := Learning.Lumped Prod.fst form

/-- The move is the rest's: formed through the rest's configuration, whatever the part's. -/
def RestForms (form : S × E → A) : Prop := Learning.Lumped Prod.snd form

variable {form : S × E → A}

/-- **The part's move is a policy of the part.** Where the rest has a configuration `e₀`, the move
is the part's exactly where it is the part's policy `form (·, e₀)` at every joint configuration. -/
theorem partForms_iff (e₀ : E) : PartForms form ↔ ∀ x, form x = form (x.1, e₀) :=
  ⟨fun own x => own x (x.1, e₀) rfl,
   fun policy x x' same =>
    (policy x).trans ((congrArg (fun s => form (s, e₀)) same).trans (policy x').symm)⟩

/-- The rest's move is a policy of the rest. -/
theorem restForms_iff (s₀ : S) : RestForms form ↔ ∀ x, form x = form (s₀, x.2) :=
  ⟨fun driven x => driven x (s₀, x.2) rfl,
   fun policy x x' same =>
    (policy x).trans ((congrArg (fun e => form (s₀, e)) same).trans (policy x').symm)⟩

/-- **A move that is both the part's and the rest's is the same everywhere.** A move that differs
anywhere is formed by at most one of them alone. -/
theorem partForms_and_restForms_iff : PartForms form ∧ RestForms form ↔ ∀ x x', form x = form x' :=
  ⟨fun ⟨own, driven⟩ x x' => (own x (x.1, x'.2) rfl).trans (driven (x.1, x'.2) x' rfl),
   fun same => ⟨fun x x' _ => same x x', fun x x' _ => same x x'⟩⟩

end Whose

/-! ## An own move closes the part, and is the rest's input -/

section Closing

variable {S : Type u} {E : Type v} {A : Type w}
variable {P : Process S A} {Q : Process E A} {form : S × E → A}

/-- **An own move closes the part.** Where the part's law is determined and the move is the
part's, joint configurations with one configuration of the part go to joint configurations with
one configuration of the part: the part carries a law of its own (`carries_law_iff`). The image of
the coupled step along the part is determined, being the part's law at a move the part alone forms,
and the grammar's law of the image (`«像定后当且仅当同行»`, through `image_determined_iff`) makes
that going alike. -/
theorem PartForms.goAlike (determined : Determined P) (own : PartForms form) :
    GoAlike (coupled P Q form) Prod.fst :=
  image_determined_iff.mp fun _ _ _ _ ⟨x, y, at_k, step, to⟩ ⟨x', y', at_k', step', to'⟩ =>
    have same : x.1 = x'.1 := at_k.trans at_k'.symm
    to.symm.trans ((determined x.1 (form x) y.1 y'.1 step.1
      (Eq.subst (motive := fun s => P.step s (form x) y'.1) same.symm
        (Eq.subst (motive := fun a => P.step x'.1 a y'.1) (own x x' same).symm step'.1))).trans to')

/-- **Whatever the rest, the part's course is the same.** Where the part's law is determined and
the move is the part's, two runs of the coupled whole from one configuration of the part agree on
the part at every step, however the rest began and went. -/
theorem PartForms.parts_agree (determined : Determined P) (own : PartForms form)
    (r r' : Run (coupled P Q form)) (start : (r.state 0).1 = (r'.state 0).1) :
    ∀ n, (r.state n).1 = (r'.state n).1 :=
  GoAlike.runs_agree (PartForms.goAlike determined own) r r' (fun _ => rfl) start

/-- **The part's course is a standard model driven by the move the whole forms.** Where the
part's law is a function `F` of configuration and move, the part's course is the trajectory of
the standard model (`trajectory` of `Becoming.Mechanism`) whose input is the move. -/
theorem Run.part_trajectory (r : Run (coupled P Q form)) {F : S → A → S}
    (law : ∀ s a s', P.step s a s' → s' = F s a) :
    ∀ n, (r.state n).1 =
      trajectory (fun s a (_ : Unit) => F s a) (r.state 0).1 (fun n => form (r.state n))
        (fun _ => ()) n
  | 0 => rfl
  | n + 1 =>
    (law _ _ _ (r.step n).1).trans
      (congrArg (fun s => F s (form (r.state n))) (Run.part_trajectory r law n))

/-- **And so is the rest's.** Where the rest's law is a function `G`, the rest's course is the
trajectory of the standard model whose input is the same move. -/
theorem Run.rest_trajectory (r : Run (coupled P Q form)) {G : E → A → E}
    (law : ∀ e a e', Q.step e a e' → e' = G e a) :
    ∀ n, (r.state n).2 =
      trajectory (fun e a (_ : Unit) => G e a) (r.state 0).2 (fun n => form (r.state n))
        (fun _ => ()) n
  | 0 => rfl
  | n + 1 =>
    (law _ _ _ (r.step n).2).trans
      (congrArg (fun e => G e (form (r.state n))) (Run.rest_trajectory r law n))

/-- **The part's own move goes round within the part.** Where the part's law is a function `F`
and the move is the part's policy, the part's course is the orbit of one determined law of the
part alone: no input from the rest enters it. -/
theorem Run.part_orbit (r : Run (coupled P Q form)) {F : S → A → S}
    (law : ∀ s a s', P.step s a s' → s' = F s a) {policy : S → A}
    (formed : ∀ x, form x = policy x.1) :
    ∀ n, (r.state n).1 = Law.orbit (fun s => F s (policy s)) (r.state 0).1 n
  | 0 => rfl
  | n + 1 =>
    (law _ _ _ (r.step n).1).trans
      ((congrArg (F (r.state n).1) (formed (r.state n))).trans
        (congrArg (fun s => F s (policy s)) (Run.part_orbit r law formed n)))

/-- **The rest's move goes round within the rest**, which drives the part. -/
theorem Run.rest_orbit (r : Run (coupled P Q form)) {G : E → A → E}
    (law : ∀ e a e', Q.step e a e' → e' = G e a) {input : E → A}
    (formed : ∀ x, form x = input x.2) :
    ∀ n, (r.state n).2 = Law.orbit (fun e => G e (input e)) (r.state 0).2 n
  | 0 => rfl
  | n + 1 =>
    (law _ _ _ (r.step n).2).trans
      ((congrArg (G (r.state n).2) (formed (r.state n))).trans
        (congrArg (fun e => G e (input e)) (Run.rest_orbit r law formed n)))

/-- **The part's own move is the rest's input.** Where the rest's law is a function `G` and the
move is the part's policy, the rest's course is the trajectory of the standard model whose input
is the part's policy of the part's course: what the part does, the rest undergoes. -/
theorem Run.rest_driven_by_part (r : Run (coupled P Q form)) {G : E → A → E}
    (law : ∀ e a e', Q.step e a e' → e' = G e a) {policy : S → A}
    (formed : ∀ x, form x = policy x.1) :
    ∀ n, (r.state n).2 =
      trajectory (fun e a (_ : Unit) => G e a) (r.state 0).2 (fun n => policy (r.state n).1)
        (fun _ => ()) n
  | 0 => rfl
  | n + 1 =>
    (law _ _ _ (r.step n).2).trans
      ((congrArg (G (r.state n).2) (formed (r.state n))).trans
        (congrArg (fun e => G e (policy (r.state n).1)) (Run.rest_driven_by_part r law formed n)))

/-- The whole's law where the part's and the rest's laws are functions: both go by the move the
whole forms. -/
def wholeNext (F : S → A → S) (G : E → A → E) (form : S × E → A) (x : S × E) : S × E :=
  (F x.1 (form x), G x.2 (form x))

/-- **The coupled whole goes round by one determined law.** Where the part's and the rest's laws
are functions, the whole's course is the orbit of `wholeNext`. -/
theorem Run.whole_orbit (r : Run (coupled P Q form)) {F : S → A → S} {G : E → A → E}
    (lawP : ∀ s a s', P.step s a s' → s' = F s a) (lawQ : ∀ e a e', Q.step e a e' → e' = G e a) :
    ∀ n, r.state n = Law.orbit (wholeNext F G form) (r.state 0) n
  | 0 => rfl
  | n + 1 =>
    ((congrArg (fun s => (s, (r.state (n + 1)).2)) (lawP _ _ _ (r.step n).1)).trans
      (congrArg (fun e => (F (r.state n).1 (form (r.state n)), e)) (lawQ _ _ _ (r.step n).2))).trans
      (congrArg (wholeNext F G form) (Run.whole_orbit r lawP lawQ n))

end Closing

/-! ## No move needs supplying from outside the whole -/

section Outside

variable {S : Type u} {A : Type w} {P : Process S A}

/-- A clock: the rest that counts the steps, whatever the move. -/
def clock (A : Type w) : Process Nat A := ⟨fun n _ n' => n' = n + 1⟩

/-- The clock is determined. -/
theorem clock_determined : Determined (clock A) :=
  fun _ _ _ _ step step' => step.trans step'.symm

/-- **No move needs supplying from outside the whole.** Every run of a labelled process, whatever
its moves, is the part's course in a whole of one action whose rest is a clock and whose move the
rest forms: the move at the joint configuration is the run's move at the clock's count. -/
def Run.withClock (r : Run P) : Run (coupled P (clock A) (fun x => r.act x.2)) :=
  ⟨fun n => (r.state n, n), fun _ => (), fun n => ⟨r.step n, rfl⟩⟩

/-- Read through the part, the whole's run is the run. -/
theorem Run.withClock_part (r : Run P) (n : Nat) :
    r.withClock.part.state n = r.state n ∧ r.withClock.part.act n = r.act n :=
  ⟨rfl, rfl⟩

/-- The clock forms the move. -/
theorem Run.withClock_restForms (r : Run P) : RestForms (fun x : S × Nat => r.act x.2) :=
  fun _ _ same => congrArg r.act same

end Outside

/-! ## A rest held by a list forms a lasso, and every lasso is so formed -/

section Lassos

variable {S : Type u} {E : Type v} {A : Type w}
variable {P : Process S A} {Q : Process E A} {form : S × E → A}

/-- **Moves formed by a rest held by a list repeat.** Where the rest's law is a function `G` and
the move is the rest's, formed by `input`, and the rest's configurations along a run are held by
a list `l`, the moves repeat from some step `i` with some period `q + 1`, where
`i + q + 1 ≤ l.length` (`Learning.lasso_of_held`). -/
theorem Run.moves_lasso_of_rest_held (r : Run (coupled P Q form)) {G : E → A → E}
    (law : ∀ e a e', Q.step e a e' → e' = G e a) {input : E → A}
    (formed : ∀ x, form x = input x.2) {l : List E} (held : ∀ n, (r.state n).2 ∈ l) :
    ∃ i q, i + q + 1 ≤ l.length ∧ Learning.Lasso (fun n => form (r.state n)) i q :=
  match Learning.lasso_of_held (next := fun e => G e (input e)) (s := (r.state 0).2)
      (fun n => Eq.subst (motive := fun e => e ∈ l) (Run.rest_orbit r law formed n) (held n))
      input with
  | ⟨i, q, within, lasso⟩ =>
    ⟨i, q, within, fun u later =>
      (formed _).trans
        ((congrArg input (Run.rest_orbit r law formed (u + (q + 1)))).trans
          ((lasso u later).trans
            ((congrArg input (Run.rest_orbit r law formed u)).symm.trans (formed _).symm)))⟩

/-- **So are the moves the part forms, where the part is held by a list.** -/
theorem Run.moves_lasso_of_part_held (r : Run (coupled P Q form)) {F : S → A → S}
    (law : ∀ s a s', P.step s a s' → s' = F s a) {policy : S → A}
    (formed : ∀ x, form x = policy x.1) {l : List S} (held : ∀ n, (r.state n).1 ∈ l) :
    ∃ i q, i + q + 1 ≤ l.length ∧ Learning.Lasso (fun n => form (r.state n)) i q :=
  match Learning.lasso_of_held (next := fun s => F s (policy s)) (s := (r.state 0).1)
      (fun n => Eq.subst (motive := fun s => s ∈ l) (Run.part_orbit r law formed n) (held n))
      policy with
  | ⟨i, q, within, lasso⟩ =>
    ⟨i, q, within, fun u later =>
      (formed _).trans
        ((congrArg policy (Run.part_orbit r law formed (u + (q + 1)))).trans
          ((lasso u later).trans
            ((congrArg policy (Run.part_orbit r law formed u)).symm.trans (formed _).symm)))⟩

/-- **Moves formed within a whole held by a list repeat, whoever forms them.** Where the part's and
the rest's laws are functions and the joint configurations along a run are held by a list `l`,
the moves repeat from some step `i` with some period `q + 1`, where `i + q + 1 ≤ l.length`. -/
theorem Run.moves_lasso_of_whole_held (r : Run (coupled P Q form)) {F : S → A → S}
    {G : E → A → E} (lawP : ∀ s a s', P.step s a s' → s' = F s a)
    (lawQ : ∀ e a e', Q.step e a e' → e' = G e a) {l : List (S × E)}
    (held : ∀ n, r.state n ∈ l) :
    ∃ i q, i + q + 1 ≤ l.length ∧ Learning.Lasso (fun n => form (r.state n)) i q :=
  match Learning.lasso_of_held (next := wholeNext F G form) (s := r.state 0)
      (fun n => Eq.subst (motive := fun x => x ∈ l) (Run.whole_orbit r lawP lawQ n) (held n))
      form with
  | ⟨i, q, within, lasso⟩ =>
    ⟨i, q, within, fun u later =>
      (congrArg form (Run.whole_orbit r lawP lawQ (u + (q + 1)))).trans
        ((lasso u later).trans (congrArg form (Run.whole_orbit r lawP lawQ u)).symm)⟩

/-- **Moves that never settle into a cycle need a whole no list holds.** -/
theorem Run.whole_unheld_of_never_cycles (r : Run (coupled P Q form)) {F : S → A → S}
    {G : E → A → E} (lawP : ∀ s a s', P.step s a s' → s' = F s a)
    (lawQ : ∀ e a e', Q.step e a e' → e' = G e a)
    (never : ∀ i q, ¬ Learning.Lasso (fun n => form (r.state n)) i q) (l : List (S × E)) :
    ¬ ∀ n, r.state n ∈ l :=
  fun held => match Run.moves_lasso_of_whole_held r lawP lawQ held with
    | ⟨i, q, _, lasso⟩ => never i q lasso

/-- **And, where the rest forms them, a rest no list holds.** -/
theorem Run.rest_unheld_of_never_cycles (r : Run (coupled P Q form)) {G : E → A → E}
    (law : ∀ e a e', Q.step e a e' → e' = G e a) {input : E → A}
    (formed : ∀ x, form x = input x.2)
    (never : ∀ i q, ¬ Learning.Lasso (fun n => form (r.state n)) i q) (l : List E) :
    ¬ ∀ n, (r.state n).2 ∈ l :=
  fun held => match Run.moves_lasso_of_rest_held r law formed held with
    | ⟨i, q, _, lasso⟩ => never i q lasso

/-- **Where the part forms them, a part no list holds.** -/
theorem Run.part_unheld_of_never_cycles (r : Run (coupled P Q form)) {F : S → A → S}
    (law : ∀ s a s', P.step s a s' → s' = F s a) {policy : S → A}
    (formed : ∀ x, form x = policy x.1)
    (never : ∀ i q, ¬ Learning.Lasso (fun n => form (r.state n)) i q) (l : List S) :
    ¬ ∀ n, (r.state n).1 ∈ l :=
  fun held => match Run.moves_lasso_of_part_held r law formed held with
    | ⟨i, q, _, lasso⟩ => never i q lasso

/-- The rest of a lasso: positions `0, …, i + q`, each going to the next and the last back to
`i`, whatever the move (`Learning.lassoNext`). -/
def lassoRest (A : Type w) (i q : Nat) : Process Nat A :=
  ⟨fun n _ n' => n' = Learning.lassoNext i q n⟩

/-- **Every lasso is formed by a rest held by a list.** A run of a labelled process whose moves
repeat from step `i` with period `q + 1` is the part's course in a coupling whose rest, the
positions of the lasso, forms its moves, and is held by the `i + q + 1` positions `0, …, i + q`. -/
def Run.withLasso (r : Run P) {i q : Nat} (lasso : Learning.Lasso r.act i q) :
    Run (coupled P (lassoRest A i q) (fun x => r.act x.2)) :=
  ⟨fun n => (r.state n, Law.orbit (Learning.lassoNext i q) 0 n), fun _ => (),
   fun n => ⟨Eq.subst (motive := fun a => P.step (r.state n) a (r.state (n + 1)))
      ((Learning.lasso_positions lasso n).2 0).symm (r.step n), rfl⟩⟩

/-- The rest of `Run.withLasso` is held by the `i + q + 1` positions of the lasso. -/
theorem Run.withLasso_held (r : Run P) {i q : Nat} (lasso : Learning.Lasso r.act i q) (n : Nat) :
    ((r.withLasso lasso).state n).2 ∈ downFrom (i + q) :=
  mem_downFrom (Learning.lasso_positions lasso n).1

/-- Read through the part, the run with its lasso rest is the run. -/
theorem Run.withLasso_part (r : Run P) {i q : Nat} (lasso : Learning.Lasso r.act i q) (n : Nat) :
    ((r.withLasso lasso).state n).1 = r.state n ∧
      (fun x => r.act x.2) ((r.withLasso lasso).state n) = r.act n :=
  ⟨rfl, (Learning.lasso_positions lasso n).2 0⟩

end Lassos

/-! ## Whose move the record fixes -/

section Record

variable {I : Type v} {K : Type u} {A : Type w}

/-- **Where nothing recurs, every course of moves reads as formed through the configurations.**
Along a course whose configurations `g` never recur, the moves `m`, whatever they are, go alike
across the configurations. -/
theorem lumped_of_new {g : I → K} (new : ∀ i j, g i = g j → i = j) (m : I → A) :
    Learning.Lumped g m :=
  fun i j same => congrArg m (new i j same)

/-- **A recurrence with the move varied excludes the reading.** -/
theorem not_lumped_of_varied {g : I → K} {m : I → A} {i j : I} (same : g i = g j)
    (varied : m i ≠ m j) : ¬ Learning.Lumped g m :=
  fun formed => varied (formed i j same)

/-- **The moves of a course are a law of its configurations exactly where they never differ at
one configuration.** Some relation giving at most one move at each configuration gives every move
of the course exactly where the moves go alike across the configurations; no decision is needed.
The reading of the course (`Readout.Reading`, the moves it takes at each configuration) is then
one (`Readout.reading_single_iff`), and the least (`reading_le`). -/
theorem lumped_iff_singleValued {g : I → K} {m : I → A} :
    Learning.Lumped g m ↔ ∃ R : K → A → Prop, Readout.SingleValued R ∧ ∀ i, R (g i) (m i) :=
  ⟨fun lumped => ⟨Readout.Reading g m, Readout.reading_single_iff.mpr lumped,
      fun i => ⟨i, rfl, rfl⟩⟩,
   fun ⟨R, one, gives⟩ i j same =>
    one (g i) (m i) (m j) (gives i)
      (Eq.subst (motive := fun k => R k (m j)) same.symm (gives j))⟩

/-- The reading of a course is contained in every relation giving its moves. -/
theorem reading_le {g : I → K} {m : I → A} {R : K → A → Prop}
    (gives : ∀ i, R (g i) (m i)) {k : K} {a : A} : Readout.Reading g m k a → R k a
  | ⟨i, at_i, by_i⟩ => at_i ▸ by_i ▸ gives i

end Record

section RecordUpto

variable {K : Type u} {A : Type w}

/-- The policy read off the first `N` steps of a course: the move taken at the latest
configuration before `N` that matches, else `d`. -/
def policyUpto [DecidableEq K] (g : Nat → K) (m : Nat → A) (d : A) : Nat → K → A
  | 0 => fun _ => d
  | N + 1 => fun k => if k = g N then m N else policyUpto g m d N k

theorem policyUpto_agrees [DecidableEq K] {g : Nat → K} {m : Nat → A} (d : A) :
    ∀ N, (∀ i j, i < N → j < N → g i = g j → m i = m j) →
      ∀ n, n < N → m n = policyUpto g m d N (g n)
  | 0, _, _, lt => absurd lt (Nat.not_lt_zero _)
  | N + 1, consistent, n, lt =>
    match Nat.lt_or_ge n N with
    | .inl before =>
      if same : g n = g N then
        (consistent n N lt (Nat.lt_succ_self N) same).trans (if_pos same).symm
      else
        (policyUpto_agrees d N
            (fun i j i_lt j_lt => consistent i j (Nat.lt_succ_of_lt i_lt) (Nat.lt_succ_of_lt j_lt))
            n before).trans (if_neg same).symm
    | .inr after =>
      have last : n = N := Nat.le_antisymm (Nat.le_of_lt_succ lt) after
      Eq.subst (motive := fun k => m k = policyUpto g m d (N + 1) (g k)) last.symm
        (if_pos rfl).symm

/-- **On a finite stretch, the moves read as formed through the configurations exactly where they
never differ at one configuration.** With equality of configurations decided, the first `N` moves
are given by a policy of the configuration exactly where no two of them differ at one
configuration; no section of the reading is needed (compare `Readout.decodes_iff_of_section`). -/
theorem lumped_upto_iff [DecidableEq K] {g : Nat → K} {m : Nat → A} (N : Nat) :
    (∀ i j, i < N → j < N → g i = g j → m i = m j) ↔
      ∃ policy : K → A, ∀ n, n < N → m n = policy (g n) :=
  ⟨fun consistent => ⟨policyUpto g m (m 0) N, fun n lt =>
      policyUpto_agrees (m 0) N consistent n lt⟩,
   fun ⟨_, formed⟩ i j i_lt j_lt same =>
    (formed i i_lt).trans ((congrArg _ same).trans (formed j j_lt).symm)⟩

/-- On a finite stretch, a decided property holds throughout or fails somewhere: the strict
form of `upto_or_fails` (`Becoming.Novelty`), stated here so that this module does not import
`Becoming.Entropy`. -/
theorem throughout_or_fails (p : Nat → Prop) [∀ n, Decidable (p n)] :
    ∀ N, (∀ n, n < N → p n) ∨ ∃ n, n < N ∧ ¬ p n
  | 0 => .inl fun _ lt => absurd lt (Nat.not_lt_zero _)
  | N + 1 =>
    match throughout_or_fails p N with
    | .inr ⟨n, lt, fails⟩ => .inr ⟨n, Nat.lt_succ_of_lt lt, fails⟩
    | .inl holds =>
      if last : p N then
        .inl fun n lt =>
          match Nat.lt_or_ge n N with
          | .inl before => holds n before
          | .inr after =>
            Eq.subst (motive := p) (Nat.le_antisymm (Nat.le_of_lt_succ lt) after).symm last
      else .inr ⟨N, Nat.lt_succ_self N, last⟩

/-- The policy read off the first `N` steps answers, at a configuration taken before `N`, with a
move taken there. -/
theorem policyUpto_taken [DecidableEq K] {g : Nat → K} {m : Nat → A} (d : A) :
    ∀ N n, n < N → ∃ j, j < N ∧ g j = g n ∧ policyUpto g m d N (g n) = m j
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | N + 1, n, lt =>
    if same : g n = g N then ⟨N, Nat.lt_succ_self N, same.symm, if_pos same⟩
    else
      match Nat.lt_or_ge n N with
      | .inl before =>
        match policyUpto_taken d N n before with
        | ⟨j, j_lt, at_j, answers⟩ =>
          ⟨j, Nat.lt_succ_of_lt j_lt, at_j, (if_neg same).trans answers⟩
      | .inr after =>
        absurd (congrArg g (Nat.le_antisymm (Nat.le_of_lt_succ lt) after)) same

/-- **The record excludes a reading exactly where a configuration recurs with the move varied.**
With equality of configurations and of moves decided, no policy of the configurations gives the
first `N` moves of a course exactly where, before `N`, some configuration recurs with the move
varied. -/
theorem no_policy_upto_iff [DecidableEq K] [DecidableEq A] {g : Nat → K} {m : Nat → A} (N : Nat) :
    (¬ ∃ policy : K → A, ∀ n, n < N → m n = policy (g n)) ↔
      ∃ i j, i < N ∧ j < N ∧ g i = g j ∧ m i ≠ m j :=
  ⟨fun none =>
    match throughout_or_fails (fun n => m n = policyUpto g m (m 0) N (g n)) N with
    | .inl agrees => absurd ⟨policyUpto g m (m 0) N, agrees⟩ none
    | .inr ⟨n, lt, differs⟩ =>
      match policyUpto_taken (m 0) N n lt with
      | ⟨j, j_lt, at_j, answers⟩ =>
        ⟨n, j, lt, j_lt, at_j.symm, fun same => differs (same.trans answers.symm)⟩,
   fun ⟨i, j, i_lt, j_lt, same, varied⟩ ⟨policy, formed⟩ =>
    varied ((formed i i_lt).trans ((congrArg policy same).trans (formed j j_lt).symm))⟩

end RecordUpto

section RecordCoupled

variable {S : Type u} {E : Type v} {A : Type w}

/-- **A move varied at one configuration of the part is varied by the rest.** Along a course of
the whole whose moves are formed within it, where the part's configuration recurs with the move
varied, the rest's configurations differ there. -/
theorem rest_differs_of_varied {form : S × E → A} {p : Nat → S} {e : Nat → E} {m : Nat → A}
    (formed : ∀ n, m n = form (p n, e n)) {i j : Nat} (same : p i = p j) (varied : m i ≠ m j) :
    e i ≠ e j :=
  fun same' => varied ((formed i).trans
    ((congrArg (fun s => form (s, e i)) same).trans
      ((congrArg (fun f => form (p j, f)) same').trans (formed j).symm)))

end RecordCoupled

/-! ## A part that keeps its history -/

section Kept

variable {S : Type u} {A : Type w} {P : Process S A}

/-- **A part keeping its history reads every move it makes as its own.** Along a run keeping its
history (`keepHistory` of `Becoming.Experiment`), whatever the moves, a policy of the
configuration gives every move: the length of the history kept tells the step. -/
theorem Run.keepHistory_formed (r : Run (keepHistory P)) :
    ∃ policy : S × List (S × A) → A, Readout.Decodes r.state r.act policy :=
  ⟨fun h => r.act (h.2.length - (r.state 0).2.length), fun n =>
    congrArg r.act
      ((Naturals.add_sub_cancel_left (r.state 0).2.length n).symm.trans
        (congrArg (fun k => k - (r.state 0).2.length) (keepHistory_length r n).symm))⟩

end Kept

/-! ## The counterfactual's supplied moves are the clock's -/

section Supplied

variable {F C : Type}

/-- **Moves supplied as a sequence are formed through the stage alone.** In the standard model of
a course (`ExchangeLaw.stepBy` of `Becoming.Counterfactual`), whose configuration is the stage and
the history so far, the act of a law that reads nothing (`ExchangeLaw.ofMoves`) is formed through
the stage, as the clock forms the moves of `Run.withClock`; an act formed by a law that reads the
history is formed through the whole configuration (`lumped_id`). -/
theorem ExchangeLaw.ofMoves_lumped_stage (u : Nat → F → C → Nat × Nat) :
    Learning.Lumped Prod.fst (ExchangeLaw.ofMoves u).policy :=
  fun _ _ same => congrArg (fun t => ((fun h c => ((u t h c).1, (u t h c).2)), ())) same

end Supplied

/-! ## Witnesses: one course, three readings of whose move it is -/

namespace MoveFormation

/-- Alternating moves. -/
def alt : Nat → Bool
  | 0 => false
  | n + 1 => !alt n

theorem alt_ne (n : Nat) : alt n ≠ alt (n + 1) :=
  ListTests.ne_not (alt n)

end MoveFormation

namespace TwoClocks

open MoveFormation

/-- The part's law of the move: alternate with the part's count. -/
def byPart (x : Nat × Nat) : Bool := alt x.1

/-- The rest's law of the move: alternate with the rest's count. -/
def byRest (x : Nat × Nat) : Bool := alt x.2

/-- The course in which the part and the rest, two clocks, count together. -/
def together (form : Nat × Nat → Bool) : Run (coupled (clock Bool) (clock Bool) form) :=
  ⟨fun n => (n, n), fun _ => (), fun _ => ⟨rfl, rfl⟩⟩

/-- **One course, two laws of whose move it is.** The part's law and the rest's law of the move
admit one and the same course: the same joint configurations and the same moves at every step.
The one is the part's and not the rest's, the other the rest's and not the part's, and they
differ where the course never goes. The course does not fix whose move it is. -/
theorem one_course_two_laws :
    (∀ n, (together byPart).state n = (together byRest).state n) ∧
      (∀ n, byPart ((together byPart).state n) = byRest ((together byRest).state n)) ∧
      PartForms byPart ∧ ¬ RestForms byPart ∧ RestForms byRest ∧ ¬ PartForms byRest ∧
      byPart (0, 1) ≠ byRest (0, 1) :=
  ⟨fun _ => rfl, fun _ => rfl,
   fun _ _ same => congrArg alt same,
   fun driven => alt_ne 0 (driven (0, 0) (1, 0) rfl),
   fun _ _ same => congrArg alt same,
   fun own => alt_ne 0 (own (0, 0) (0, 1) rfl),
   alt_ne 0⟩

/-- **Closed is not the same as forming one's move.** A part whose law the move makes no
difference to is closed against the rest, carrying a law of its own, while its move is the
rest's and not its own. -/
theorem closed_not_own :
    GoAlike (coupled (clock Bool) (clock Bool) byRest) Prod.fst ∧ ¬ PartForms byRest :=
  ⟨fun _ _ _ _ _ same step step' =>
    step.1.trans ((congrArg (fun k => k + 1) same).trans step'.1.symm),
   fun own => alt_ne 0 (own (0, 0) (0, 1) rfl)⟩

end TwoClocks

namespace Still

open MoveFormation

/-- **The record fixes the rest's move where the part recurs with the move varied.** A part that
stays as it is while the move alternates does not form the move: along the course the moves read
as formed through the rest's count and not through the part. -/
theorem driven :
    ¬ Learning.Lumped (fun _ : Nat => ()) alt ∧ Learning.Lumped (fun n : Nat => n) alt :=
  ⟨not_lumped_of_varied (i := 0) (j := 1) rfl (alt_ne 0),
   lumped_of_new (fun _ _ same => same) alt⟩

end Still

namespace Parity

/-- The part's configurations in a course with period four. -/
def partCourse : Nat → Bool
  | 0 => false
  | 1 => false
  | 2 => true
  | 3 => true
  | n + 4 => partCourse n

/-- The rest's configurations in the same course. -/
def restCourse : Nat → Bool
  | 0 => false
  | 1 => true
  | 2 => true
  | 3 => false
  | n + 4 => restCourse n

/-- The move formed by the relation of the two: whether they differ. -/
def form : Bool × Bool → Bool
  | (false, false) => false
  | (false, true) => true
  | (true, false) => true
  | (true, true) => false

/-- The moves of the course. -/
def move (n : Nat) : Bool := form (partCourse n, restCourse n)

/-- **A move neither forms alone.** Along the course, the move, formed by the relation of the part
and the rest, reads as formed through neither the part's configurations nor the rest's, and as
formed through the joint configuration; as a law it is neither the part's nor the rest's. -/
theorem neither_alone :
    ¬ Learning.Lumped partCourse move ∧ ¬ Learning.Lumped restCourse move ∧
      Learning.Lumped (fun n => (partCourse n, restCourse n)) move ∧
      ¬ PartForms form ∧ ¬ RestForms form :=
  ⟨not_lumped_of_varied (i := 0) (j := 1) rfl (fun same => nomatch same),
   not_lumped_of_varied (i := 1) (j := 2) rfl (fun same => nomatch same),
   Readout.lumped_of_decodes (g := form) (fun _ => rfl),
   fun (own : PartForms form) =>
    absurd (own (false, false) (false, true) rfl) (fun same => nomatch same),
   fun (driven : RestForms form) =>
    absurd (driven (false, false) (true, false) rfl) (fun same => nomatch same)⟩

end Parity

end Becoming

section MoveRuns

/-!
## Move runs: where the moves of a run are formed

`Becoming.MoveFormation` states where a move is formed: through a reading of the configuration where it
goes alike across what the reading lumps (`Learning.Lumped`), by the part, the rest or only their
relation in a coupled whole (`coupled`), and what the record of one course fixes of it. Its record
laws are stated for any sequence of configurations `g` and of moves `m`. A run of any process is
such a pair, its configurations `r.state` and its moves `r.act`, and the course of a coupled whole
is a run of `coupled P Q form` whose move at each step is `form` of the joint configuration
(`Run.part`, `Run.rest`). This section states Coupling's laws of those runs, with no premise beyond
what each theorem names.

* **Formed through a reading, along a run.** Along a run of a coupled whole, its moves are formed
  through its configurations (`coupled_formed`); along a run of any process, moves formed through a
  reading of the configurations are formed through every reading telling apart as much
  (`formed_of_finer`), and through the reading that tells nothing apart exactly where the run takes
  one move throughout (`lumped_const_iff`).
* **The part's, the rest's, the relation's, along a run.** Where the move is the part's, every run
  of the coupled whole takes the part's policy at the part's configuration (`part_policy`); where it
  is the rest's, the rest's policy (`rest_policy`); where it is both, every run takes one move at
  every step (`both_one_move`). Along a run of the coupled whole, where the part's configuration
  recurs with the move varied, the rest's configuration differs there (`rest_differs`).
* **What the record of a run fixes.** A run's moves are a law of its configurations exactly where
  some relation giving at most one move at each configuration gives every move of the run
  (`lumped_iff_singleValued`); the run's reading is contained in every such relation
  (`reading_le`). On its first `N` steps, with equality of configurations decided, a policy of
  the configuration gives the run's moves exactly where they never differ at one configuration
  (`lumped_upto_iff`), and, with equality of moves decided too, no policy does exactly where some
  configuration recurs with the move varied (`no_policy_upto_iff`).
* **The counterfactual's supplied moves.** Along a run of the standard model of a course with the
  act formed within (`closedBy` of `ExchangeLaw.stepBy`), the act of a law that reads nothing
  (`ExchangeLaw.ofMoves`) is formed through the stage alone (`ofMoves_formed_stage`).
* **The witnesses as runs.** A history is a run of the law it shows (`Shown.run`). The run of the
  part held still while the move alternates (`stillRun`) has moves formed through the rest's count
  and not through the part (`still_driven`); the run of period four (`parityRun`) has moves formed
  through neither side's configuration alone and through the joint configuration
  (`parity_neither_alone`).

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

open Generative

universe u v w u'

namespace MoveRuns

section Coupled

variable {S : Type u} {E : Type v} {A : Type w} {P : Process S A} {Q : Process E A}
  {form : S × E → A}

/-- **Along a run of a coupled whole, its moves are formed through its configurations.** -/
theorem coupled_formed (r : Run (coupled P Q form)) : Learning.Lumped r.state r.part.act :=
  fun i j same => lumped_id form (r.state i) (r.state j) same

/-- **Where the move is the part's, every run of the coupled whole takes the part's policy**: at
each step the move is `form` of the part's configuration with any one configuration of the rest. -/
theorem part_policy (own : PartForms form) (e₀ : E) (r : Run (coupled P Q form)) (n : Nat) :
    r.part.act n = form (r.part.state n, e₀) :=
  (partForms_iff e₀).mp own (r.state n)

/-- **Where the move is the rest's, every run of the coupled whole takes the rest's policy.** -/
theorem rest_policy (driven : RestForms form) (s₀ : S) (r : Run (coupled P Q form)) (n : Nat) :
    r.rest.act n = form (s₀, r.rest.state n) :=
  (restForms_iff s₀).mp driven (r.state n)

/-- **Where the move is both the part's and the rest's, the coupled whole takes one move**: every
two steps of every two runs take the same move. -/
theorem both_one_move (both : PartForms form ∧ RestForms form) (r r' : Run (coupled P Q form))
    (i j : Nat) : r.part.act i = r'.part.act j :=
  partForms_and_restForms_iff.mp both (r.state i) (r'.state j)

/-- **Along a run of the coupled whole, a move varied at one configuration of the part is varied
by the rest.** -/
theorem rest_differs (r : Run (coupled P Q form)) {i j : Nat}
    (same : r.part.state i = r.part.state j) (varied : r.part.act i ≠ r.part.act j) :
    r.rest.state i ≠ r.rest.state j :=
  rest_differs_of_varied (form := form) (p := r.part.state) (e := r.rest.state)
    (fun _ => rfl) same varied

end Coupled

section AnyProcess

variable {S : Type u} {A : Type w} {K : Type v} {K' : Type u'} {P : Process S A}

/-- **Along a run, moves formed through a reading are formed through every reading telling apart
at least as much.** -/
theorem formed_of_finer (r : Run P) {π : S → K} {π' : S → K'}
    (formed : Learning.Lumped (fun n => π (r.state n)) r.act)
    (finer : ∀ x x', π' x = π' x' → π x = π x') :
    Learning.Lumped (fun n => π' (r.state n)) r.act :=
  lumped_of_finer formed fun i j same => finer (r.state i) (r.state j) same

end AnyProcess

section Supplied

variable {F C : Type} {law : ExchangeLaw F C} {present : Nat → List F} {part : F → Bool}
  {u : Nat → F → C → Nat × Nat}

/-- **Along a run of the standard model of a course, moves supplied as a sequence are formed
through the stage alone.** With the act formed within by a law that reads nothing, two steps of
the run at the same stage take the same move. -/
theorem ofMoves_formed_stage
    (r : Run (closedBy (inputs (law.stepBy present part)) (ExchangeLaw.ofMoves u).policy)) :
    Learning.Lumped (fun n => (r.state (n + 1)).1.1) (fun n => (r.state (n + 1)).2) :=
  fun i j same =>
    (r.step i).2.trans
      ((ExchangeLaw.ofMoves_lumped_stage u (r.state (i + 1)).1 (r.state (j + 1)).1 same).trans
        (r.step j).2.symm)

end Supplied

/-! ### The witnesses as runs -/

/-- The run of a part held still while the rest counts and the move alternates. -/
def stillRun : Run (Shown (fun n : Nat => ((), n)) MoveFormation.alt) :=
  Shown.run (fun n : Nat => ((), n)) MoveFormation.alt

/-- **Along the run of a part held still while the move alternates, the moves are formed through
the rest's count and not through the part.** -/
theorem still_driven :
    ¬ Learning.Lumped (fun n => (stillRun.state n).1) stillRun.act ∧
      Learning.Lumped (fun n => (stillRun.state n).2) stillRun.act :=
  Still.driven

/-- The run of period four whose move is whether the part and the rest differ. -/
def parityRun : Run (Shown (fun n => (Parity.partCourse n, Parity.restCourse n)) Parity.move) :=
  Shown.run (fun n => (Parity.partCourse n, Parity.restCourse n)) Parity.move

/-- **Along the run of period four, the move is formed through neither side's configuration alone
and through the joint configuration.** -/
theorem parity_neither_alone :
    ¬ Learning.Lumped (fun n => (parityRun.state n).1) parityRun.act ∧
      ¬ Learning.Lumped (fun n => (parityRun.state n).2) parityRun.act ∧
      Learning.Lumped parityRun.state parityRun.act :=
  ⟨Parity.neither_alone.1, Parity.neither_alone.2.1, Parity.neither_alone.2.2.1⟩

end MoveRuns

end Becoming

end MoveRuns
