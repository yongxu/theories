import Becoming.GrammarCourse
import Becoming.ClosedCapture
import Becoming.Mechanism

/-!
# The regularity of a line, kept and changed, and rules that change themselves (规律之守与变)

`Becoming.Grammar` states continuation relative to a class for every carrier and relation, and the
core `«核» R E`, the greatest symmetric relation inside `E` that is constant under `R` (`«根»`): what
a line under `E` carries of its own. This module states how that regularity is kept and left along a
line, for every carrier, relation and class, and reads processes that change their own rule, closed
capture among them, as models of the grammar. No definition of `Becoming.Grammar` changes. The
general laws are short corollaries of `«根»`, `«有常则续不尽»` and `«亡于核下不变»`; what they add is
where along a line the core is left.

| name | reading |
|---|---|
| `«守核则不穷»` | a regularity kept for one step can always be kept |
| `«守核之线不亡»` | a line along which the core is kept leaves its last occurrence continued under the class |
| `«亡前核变»` | a step into an end leaves the core |
| `«有亡之线末步离核»` | the last step of a line into an end leaves the core |
| `«有亡之线两端核异»` | the two ends of a line under a class that ends lie in different classes of the core |
| `moveRel` | a move of a process read as 缘: `s` conditions `t` by the move `a` |

* **Kept and left.** From a step continuing under the core, every occurrence its line under the core
  reaches has a successor under the core (`«守核则不穷»`): the core is constant, so
  `«有常则续不尽»` holds of it. Along a determined law the next step keeps it; in a branching net a
  successor under `E` can leave it. A step into an end under `E` leaves the core, for every relation
  `E` (`«亡前核变»`), and so does the last step of every line under `E` that ends
  (`«有亡之线末步离核»`): a line ends only by a step that leaves its class's core. Where `E` is a
  class the two ends of such a line lie in different classes of the core
  (`«有亡之线两端核异»`). So what goes on for a while and then ends is a class that does not hold by
  itself (`«有常»`), and its line passes from one class of the core to another before it ends; the
  core itself always admits continuation. Where along a longer line the line first leaves its
  start's class of the core is placed by `«两端分则中有标»` where the core is decided at each step.
* **Moves as relations.** A process with moves is a family of relations, one for each move
  (`moveRel`). Where every move is possible from every configuration, a process going alike by a map
  has the map's class constant under every move (`constant_of_goAlike`); where the process is
  determined, the converse holds (`goAlike_of_constant`). Both are the grammar's lumping laws
  (`«同行遍后则有常»`, `«有常定后则同行»` of `Becoming.GrammarLaws`) at each move.
* **A rule that changes itself.** For a state going on under a rule that itself goes on
  (`adaptive`), the state's class is constant under every move, and is its own core under every
  move, exactly where the rule makes no difference to the state (`adaptive_constant_iff`,
  `adaptive_core_iff`). Where two rules take one state by one move to different states, the core of
  the state's class under that move tells the two configurations apart (`adaptive_core_apart`): the
  rule is read in the state's regularity.
* **Closed capture in the grammar.** The class of share, rule and step count (`loopPart`) is
  constant under the two-level step along every schedule exactly where nothing beyond the share is
  read (`ClosedCapture.constant_iff_unread`). Under the premises of
  `ClosedCapture.lock_outlives_loss`, from a locked start the line under the class of being locked
  or not never ends, and each of its steps is an alteration under the loss
  (`ClosedCapture.lock_line`): the course stays locked while the coordinate it does not read changes
  at every step. Along a two-level step whose reading favours at no loss past a bound, with a reading
  step past the bound, the line under the class of favouring or not from a favouring start is not
  unending (`ClosedCapture.loss_ends_line`). In the witness of `ClosedCapture`, read from the share
  alone the line under being locked never ends (`ClosedCapture.Beyond.closed_line`), and read from
  the loss the line under favouring ends at the first step (`ClosedCapture.Beyond.open_line_ends`).

So a rule that changes by a fixed law is stated in the grammar by taking it into the occurrence: the
carrier is a parameter, and an occurrence of a two-level course carries its rule. The law of change
stays fixed, and the levels come from the carrier's product, not from the grammar; a change of the
law of change with no fixed law above it, or a space of rules not given with the carrier, is not
covered.

What is not derived: that any actual rule is read from what it selects; that the coordinate beyond
the share, named the loss, is a loss to any formation (that is a significance's to say); which class
carries an actual pattern's regularity. The models commit to discrete steps and, for closed capture,
to natural-number losses, as their modules state. Every declaration has an empty axiom report.
-/

namespace Becoming

open Generative

universe u v w

/-! ## Kept and left: laws for every carrier, relation and class -/

section General

variable {α : Type u}

/-- **A regularity kept for one step can always be kept (守核则不穷).** From a step continuing under
the core of `E`, every occurrence its line under the core reaches has a successor under the core:
the core is constant (`«根»`), so `«有常则续不尽»` holds of it. -/
theorem «守核则不穷» {R E : «际» α} {x y : α} (kept : «续» R («核» R E) x y) :
    «不穷» R («核» R E) y := by
  intro z reach
  match reach with
  | .inl e => exact e ▸ «有常则续不尽» («根» R E).2.1 ⟨x, kept⟩
  | .inr line => exact «有常则相续不尽» («根» R E).2.1 line

/-- The first occurrence of a line is continued. -/
theorem «相续之始有后» {R E : «际» α} {x y : α} (line : «相续» R E x y) : «有后» R E x :=
  match line with
  | .one c => ⟨_, c⟩
  | .more c _ => ⟨_, c⟩

/-- The last step of a line: whatever a line from `x` reaches is reached by a step of continuation
from `x` or from an occurrence the line reaches. -/
theorem «相续之末步» {R E : «际» α} {x y : α} (line : «相续» R E x y) :
    ∃ w, «续» R E w y ∧ (x = w ∨ «相续» R E x w) := by
  induction line with
  | one c => exact ⟨_, c, .inl rfl⟩
  | more c _ ih =>
    match ih with
    | ⟨w, last, .inl e⟩ => exact ⟨w, last, .inr (e ▸ .one c)⟩
    | ⟨w, last, .inr rest⟩ => exact ⟨w, last, .inr (.more c rest)⟩

/-- **A line along which the core is kept leaves its last occurrence continued under the class.** -/
theorem «守核之线不亡» {R E : «际» α} {x y : α} (line : «相续» R («核» R E) x y) : «有后» R E y :=
  match «有常则相续不尽» («根» R E).2.1 line with
  | ⟨z, c⟩ => ⟨z, «粗化» R («根» R E).1 y z c⟩

/-- **A step into an end leaves the core (亡前核变).** Where `y` continues `x` under `E` and ends
there, the core of `E` tells `x` and `y` apart: the step continues under `E` and leaves its core.
For every relation `E`: a step under the core would leave `y` continued (`«守核之线不亡»`). -/
theorem «亡前核变» {R E : «际» α} {x y : α} (c : «续» R E x y) (ends : «亡» R E y) :
    «异» R E («核» R E) x y :=
  ⟨c, fun k => ends («守核之线不亡» (.one ⟨c.1, k⟩))⟩

/-- **The last step of a line into an end leaves the core.** A line under `E` from `x` to an end `y`
reaches `y` by a step that continues under `E` and leaves its core, from `x` or from an occurrence
the line reaches. -/
theorem «有亡之线末步离核» {R E : «际» α} {x y : α} (line : «相续» R E x y) (ends : «亡» R E y) :
    ∃ w, «异» R E («核» R E) w y ∧ (x = w ∨ «相续» R E x w) :=
  match «相续之末步» line with
  | ⟨w, last, reach⟩ => ⟨w, «亡前核变» last ends, reach⟩

/-- **The two ends of a line that ends lie in different classes of the core.** Where `E` is a class,
a line under `E` from `x` to an end `y` has `x` and `y` apart in the core. -/
theorem «有亡之线两端核异» {R E : «际» α} (hE : «类» E) {x y : α} (line : «相续» R E x y)
    (ends : «亡» R E y) : ¬ «核» R E x y :=
  fun k => «亡于核下不变» hE ((«根» R E).2.2.1 x y k) ends («相续之始有后» line)

end General

/-! ## A line along a determined law's orbit -/

namespace Law

variable {S : Type u}

/-- **A line along a law's step never ends exactly where every step of the orbit continues under the
relation**, for every relation `E`. -/
theorem unending_iff_steps {next : S → S} {E : «际» S} {s : S} :
    «不穷» (step next) E s ↔ ∀ n, E (orbit next s n) (orbit next s (n + 1)) := by
  constructor
  · intro never
    have reached : ∀ n, (s = orbit next s n ∨ «相续» (step next) E s (orbit next s n)) ∧
        E (orbit next s n) (orbit next s (n + 1)) := by
      intro n
      induction n with
      | zero => exact ⟨.inl rfl, step_hasSucc_iff.mp (never s (.inl rfl))⟩
      | succ n ih =>
        have c : «续» (step next) E (orbit next s n) (orbit next s (n + 1)) := ⟨rfl, ih.2⟩
        have reach : s = orbit next s (n + 1) ∨ «相续» (step next) E s (orbit next s (n + 1)) :=
          match ih.1 with
          | .inl at_s => .inr (Eq.subst (motive := fun w => «相续» (step next) E w (orbit next s (n + 1)))
              at_s.symm (.one c))
          | .inr line => .inr («及之传递» line (.one c))
        exact ⟨reach, step_hasSucc_iff.mp (never _ reach)⟩
    exact fun n => (reached n).2
  · intro steps y reach
    have at_orbit : ∃ m, y = orbit next s m :=
      match reach with
      | .inl at_s => ⟨0, at_s.symm⟩
      | .inr line => match line_on_orbit line with
        | ⟨n, h⟩ => ⟨n + 1, h⟩
    match at_orbit with
    | ⟨m, h⟩ => exact h ▸ step_hasSucc_iff.mpr (steps m)

/-- Under a class, a line that never ends keeps every configuration of the orbit alike with its
start. -/
theorem unending_alike {next : S → S} {E : «际» S} (hE : «类» E) {s : S}
    (never : «不穷» (step next) E s) : ∀ n, E s (orbit next s n)
  | 0 => hE.refl s
  | n + 1 => hE.trans (unending_alike hE never n) (unending_iff_steps.mp never n)

end Law

/-! ## Moves as relations -/

section Moves

variable {S : Type u} {A : Type v} {K : Type w}

/-- A move of a process read as 缘: `s` conditions `t` by the move `a`. -/
def moveRel (P : Process S A) (a : A) : «际» S := fun s t => P.step s a t

/-- **Where every move is possible from every configuration, a process going alike by a map has the
map's class constant under every move**: the grammar's lumping law (`«同行遍后则有常»`) at the move,
going alike being the grammar's there (`goAlikeUnder_iff_alike`). -/
theorem constant_of_goAlike {P : Process S A} {π : S → K} (total : ∀ s a, ∃ t, P.step s a t)
    (alike : GoAlike P π) (a : A) : «有常» (moveRel P a) (sameValue π) :=
  «同行遍后则有常» (goAlikeUnder_iff_alike.mp alike a) (fun s => total s a)

/-- **Where the process is determined, the map's class constant under every move makes it go alike
by the map**: the grammar's lumping law (`«有常定后则同行»`) at each move, determinacy being a fixed
successor there (`determined_iff_fixed`). -/
theorem goAlike_of_constant {P : Process S A} {π : S → K} (determined : Determined P)
    (constant : ∀ a, «有常» (moveRel P a) (sameValue π)) : GoAlike P π :=
  goAlikeUnder_iff_alike.mpr fun a => «有常定后则同行» (constant a) (determined_iff_fixed.mp determined a)

/-- A determined process with every move possible goes alike by a map exactly where the map's class
is constant under every move. -/
theorem goAlike_iff_constant {P : Process S A} {π : S → K} (total : ∀ s a, ∃ t, P.step s a t)
    (determined : Determined P) : GoAlike P π ↔ ∀ a, «有常» (moveRel P a) (sameValue π) :=
  ⟨fun alike => constant_of_goAlike total alike, goAlike_of_constant determined⟩

end Moves

/-! ## A rule that changes itself -/

section Adaptive

variable {X : Type u} {R : Type v} {U : Type w}

/-- **The state of a process changing its own rule has a class constant under every move exactly
where the rule makes no difference to it** (`adaptive_state_law_iff` read in the grammar). -/
theorem adaptive_constant_iff {F : R → X → U → X} {G : R → X → R} :
    (∀ u, «有常» (moveRel (adaptive F G) u) (sameValue (Prod.fst : X × R → X))) ↔
      ∀ g g' x u, F g x u = F g' x u :=
  (goAlike_iff_constant (fun _ _ => ⟨_, rfl⟩) (adaptive_determined F G)).symm.trans
    adaptive_state_law_iff

/-- **The state's class is its own core under every move exactly where the rule makes no difference
to the state.** -/
theorem adaptive_core_iff {F : R → X → U → X} {G : R → X → R} :
    (∀ u, «则» (sameValue (Prod.fst : X × R → X))
        («核» (moveRel (adaptive F G) u) (sameValue (Prod.fst : X × R → X)))) ↔
      ∀ g g' x u, F g x u = F g' x u :=
  ⟨fun within => adaptive_constant_iff.mp fun u =>
      («类有常当且仅当含于核» _ (sameValue_class _)).mpr (within u),
   fun same u => («类有常当且仅当含于核» _ (sameValue_class _)).mp (adaptive_constant_iff.mpr same u)⟩

/-- **Where two rules take one state by one move to different states, the core of the state's class
under that move tells the two configurations apart**: the rule is read in the state's regularity. -/
theorem adaptive_core_apart {F : R → X → U → X} {G : R → X → R} {g g' : R} {x : X} {u : U}
    (differs : ¬ F g x u = F g' x u) :
    ¬ «核» (moveRel (adaptive F G) u) (sameValue (Prod.fst : X × R → X)) (x, g) (x, g') := fun k =>
  match («有常之逐点» _ _).mp («根» (moveRel (adaptive F G) u) (sameValue Prod.fst)).2.1 (x, g) (x, g') k
      (F g x u, G g x) rfl with
  | ⟨_, step', alike⟩ =>
    differs (((«根» (moveRel (adaptive F G) u) (sameValue Prod.fst)).1 _ _ alike).trans
      (congrArg Prod.fst step'))

end Adaptive

/-! ## Closed capture in the grammar -/

namespace ClosedCapture

open Pace RuleCapture

section Unread

variable {A : Type u} {B : Type v} {R : Type w}

/-- **The class of share, rule and step count (`loopPart`) is constant under the two-level step
along every schedule exactly where nothing beyond the share is read** (`identifiesAlike_iff_unread`
read in the grammar, through `Law.constant_iff_keeps`). -/
theorem constant_iff_unread {f : A × B → R → A × B} {h : A × B → R → R} :
    (∀ reads : Nat → Bool, «有常» (Law.step (Pace.step f h reads))
        (sameValue (loopPart (A := A) (B := B) (R := R)))) ↔ Unread f h :=
  ⟨fun constant => identifiesAlike_iff_unread.mp fun reads =>
      Law.now_identifiesAlike_iff_goAlike.mpr
        (Learning.goAlike_iff_lumped.mpr (Law.constant_iff_keeps.mp (constant reads))),
   fun unread reads =>
      Law.constant_iff_keeps.mpr (Learning.goAlike_iff_lumped.mp (goAlike_of_unread unread reads))⟩

end Unread

section Line

variable {A : Type u} {R : Type w}

/-- Two configurations of the two-level step alike in whether the rule in force favours. -/
def favouredAlike (favours : R → Prop) {S : Type u} : «际» (S × R × Nat) :=
  fun p q => favours p.2.1 ↔ favours q.2.1

theorem favouredAlike_class (favours : R → Prop) {S : Type u} :
    «类» (favouredAlike favours (S := S)) :=
  ⟨fun _ => Iff.rfl, Iff.symm, Iff.trans⟩

/-- Two configurations of the joined two-level step alike in whether share and rule are locked. -/
def lockedAlike (M : Ideals.Preorder R) (favours : R → Prop) (hA : A → R → R) :
    «际» ((A × Nat) × R × Nat) :=
  fun p q => Locked M favours hA (p.1.1, p.2.1) ↔ Locked M favours hA (q.1.1, q.2.1)

theorem lockedAlike_class (M : Ideals.Preorder R) (favours : R → Prop) (hA : A → R → R) :
    «类» (lockedAlike M favours hA) :=
  ⟨fun _ => Iff.rfl, Iff.symm, Iff.trans⟩

/-- The loss of a configuration of the joined two-level step. -/
def loss (p : (A × Nat) × R × Nat) : Nat := p.1.2

/-- One turn's fast configuration is the selection's, whether or not the rule is read. -/
theorem turn_fast {S : Type u} (f : S → R → S) (h : S → R → R) :
    ∀ (r : Bool) (p : S × R), (turn f h r p).1 = f p.1 p.2
  | true, _ => rfl
  | false, _ => rfl

/-- The configuration `t` steps along the two-level step is the course's, at step count `t`. -/
theorem orbit_paced {S : Type u} (f : S → R → S) (h : S → R → R) (reads : Nat → Bool) (c : S × R)
    (t : Nat) :
    Law.orbit (Pace.step f h reads) (c.1, c.2, 0) t = ((paced f h reads c t).1, (paced f h reads c t).2, t) :=
  paced_run c t

/-- Where every step adds at least one to the loss, every step of the joined two-level step alters
the loss. -/
theorem loss_alters {fA : A → R → A} {fB : A × Nat → R → Nat} {h : A × Nat → R → R}
    {reads : Nat → Bool} (accrues : Accrues fB) (p : (A × Nat) × R × Nat) :
    ¬ loss p = loss (Pace.step (join fA fB) h reads p) := fun same =>
  have grows : p.1.2 + 1 ≤ (Pace.step (join fA fB) h reads p).1.2 :=
    Eq.subst (motive := fun x : A × Nat => p.1.2 + 1 ≤ x.2)
      (turn_fast (join fA fB) h (reads p.2.2) (p.1, p.2.1)).symm (accrues _ _)
  Nat.not_succ_le_self _ (Eq.subst (motive := fun n => p.1.2 + 1 ≤ n) same.symm grows)

/-- **The locked loop's line never ends, while every step alters the loss.** Under the premises of
`lock_outlives_loss`, from a locked start the line under the class of being locked or not never
ends along the joined two-level step, and each of its steps is an alteration under the loss: the
course stays locked while the coordinate it does not read changes at every step. -/
theorem lock_line {P : Ideals.Preorder A} {M : Ideals.Preorder R} {favours : R → Prop}
    {fA : A → R → A} {fB : A × Nat → R → Nat} {hA : A → R → R} {reads : Nat → Bool}
    (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') (accrues : Accrues fB)
    {a : A} {b : Nat} {g : R} (locked : Locked M favours hA (a, g)) :
    «不穷» (Law.step (Pace.step (join fA fB) (joinRead hA) reads)) (lockedAlike M favours hA)
        ((a, b), g, 0) ∧
      ∀ n, «异» (Law.step (Pace.step (join fA fB) (joinRead hA) reads)) (lockedAlike M favours hA)
        (sameValue loss)
        (Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) ((a, b), g, 0) n)
        (Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) ((a, b), g, 0) (n + 1)) :=
  have stays : ∀ t, Locked M favours hA
      ((Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) ((a, b), g, 0) t).1.1,
        (Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) ((a, b), g, 0) t).2.1) := fun t =>
    (lock_outlives_loss raises monotone upper accrues (b := b) locked t).2.1
  have steps : ∀ n, lockedAlike M favours hA
      (Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) ((a, b), g, 0) n)
      (Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) ((a, b), g, 0) (n + 1)) :=
    fun n => ⟨fun _ => stays (n + 1), fun _ => stays n⟩
  ⟨Law.unending_iff_steps.mpr steps,
   fun n => ⟨⟨rfl, steps n⟩, loss_alters accrues _⟩⟩

/-- **A reading that turns against favouring past a loss bound ends the line under favouring.**
Under the premises of `turned_by_loss`, along the joined two-level step with any reading `h` that
favours at no configuration whose loss is past `N`, with a reading step `r` past the bound, from a
start whose rule favours, the line under the class of favouring or not is not unending: past the
reading step the rule no longer favours, and a line that never ended would keep every configuration
alike with the start. -/
theorem loss_ends_line {fA : A → R → A} {fB : A × Nat → R → Nat} {h : A × Nat → R → R}
    {reads : Nat → Bool} {favours : R → Prop} (accrues : Accrues fB)
    {N : Nat} (turns : ∀ p g, N ≤ p.2 → ¬ favours (h p g)) {a : A} {b : Nat} {g : R} {r : Nat}
    (at_r : reads r = true) (past : N ≤ b + r) (start : favours g) :
    ¬ «不穷» (Law.step (Pace.step (join fA fB) h reads)) (favouredAlike favours) ((a, b), g, 0) :=
  fun never =>
    have alike := Law.unending_alike (favouredAlike_class favours) never (r + 1)
    -- the course's rule at `r + 1` is, by definition, the rule of the orbit's configuration there
    turned_by_loss (fA := fA) (fB := fB) (h := h) (reads := reads) (favours := favours) accrues turns
      at_r past (alike.mp start)

end Line

namespace Beyond

open CarrierCounts

/-- **Read from the share alone, the line under being locked never ends**, and each of its steps
alters the loss. -/
theorem closed_line :
    «不穷» (Law.step (Pace.step (join select lossStep) (joinRead closedRead) (fun _ => true)))
        (lockedAlike order favours closedRead) ((twoToOne, 0), hi, 0) ∧
      ∀ n, «异» (Law.step (Pace.step (join select lossStep) (joinRead closedRead) (fun _ => true)))
        (lockedAlike order favours closedRead) (sameValue loss)
        (Law.orbit (Pace.step (join select lossStep) (joinRead closedRead) (fun _ => true))
          ((twoToOne, 0), hi, 0) n)
        (Law.orbit (Pace.step (join select lossStep) (joinRead closedRead) (fun _ => true))
          ((twoToOne, 0), hi, 0) (n + 1)) :=
  lock_line (reads := fun _ => true) (b := 0) raises (fun _ _ _ _ _ => order.refl hi) upper
    (fun _ _ => Nat.le_refl _) (closed_locked 0).2.1

/-- **Read from the loss, the line under favouring ends at the first step**: the start continues to
the configuration after it, whose rule still favours, and that configuration has no successor under
favouring or not, the rule then favouring the others. -/
theorem open_line_ends :
    «续» (Law.step (Pace.step (join select lossStep) lossRead (fun _ => true))) (favouredAlike favours)
        ((twoToOne, 0), hi, 0)
        (Law.orbit (Pace.step (join select lossStep) lossRead (fun _ => true)) ((twoToOne, 0), hi, 0) 1) ∧
      «亡» (Law.step (Pace.step (join select lossStep) lossRead (fun _ => true))) (favouredAlike favours)
        (Law.orbit (Pace.step (join select lossStep) lossRead (fun _ => true)) ((twoToOne, 0), hi, 0) 1) :=
  ⟨⟨rfl, Iff.intro (fun _ => show 1 ≤ 4 by decide) (fun _ => show 1 ≤ 4 by decide)⟩,
   fun succ => (show ¬ 4 ≤ 1 by decide) ((Law.step_hasSucc_iff.mp succ).mp (show 1 ≤ 4 by decide))⟩

end Beyond

end ClosedCapture

end Becoming
