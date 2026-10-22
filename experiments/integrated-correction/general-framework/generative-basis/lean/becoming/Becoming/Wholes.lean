import Becoming.Identity
import Becoming.Continuation
import Becoming.Decidedness

/-!
# Wholes: a persisting whole of brief parts, or of ending listed parts, needs their generation;
a whole of every part ends with any part

`Becoming.Identity` names a lineage either as one formation or as its members (`Lineage`).
`Layered` names both, with no relation saying that the lineage is constituted by its
members. This module states part–whole relations as coincidences of activity, a whole active
while some part is, while every part is, or while at least a number of listed parts are, and
proves what they carry, and, with `Becoming.Continuation`, what a draw on the conditions its
parts arise through does to a whole.

* A formation is the *whole* of some parts when it is active exactly while some part is
  (`Web.Whole`). This is coincidence of activity, not constitution: every formation is the
  whole of itself (`Web.whole_self`), and two formations active at every step are each the
  whole of the other (`Immortal.each_other`). Parts *cover* the steps from `T` on when
  some part is active at each of them (`Web.Covered`). The active parts are *listed* when
  at each step a finite list names exactly them (`Web.Listed`). A formation's activity
  *ends* when from some step on it is never active (`Web.Ends`); it is *brief* for `d`
  when it is never active at two steps `d` apart (`Web.Brief`).
* A whole arises only as some part arises (`Whole.arises_part`), so a whole arising at
  arbitrarily late steps has parts arising at arbitrarily late steps
  (`Whole.parts_unceasing`).
* Without arising, ending parts end together. Parts each of whose activity ends, with the
  active ones listed, none arising from some step on, are all inactive from a later step
  (`Listed.end_without_arising`): a part active after that step was active at it, among
  the finitely many listed there. So a whole of such parts ends where none arises from some
  step on (`Whole.ends_without_arising`).
* A cover needs the generation of parts. If no part is active at two steps `d` apart, a
  part arises within every `d` consecutive steps (`Covered.arises_within`). If each part's
  activity ends and the active parts are listed, parts arise at arbitrarily late steps
  (`Covered.needs_arising`, from `Listed.end_without_arising`), and outside every finite
  list of parts: ever new parts (`Covered.needs_new`).
  A whole active at every step from some step on is covered by its
  parts (`Whole.covered`), so it persists only through the generation of its parts
  (`Whole.arises_within`, `Whole.needs_arising`, `Whole.needs_new`). Under brevity that
  generation may be the same parts arising again (`Layered`); where parts end and are
  listed, it is ever new parts, though not more of them (`Generations` has two active at
  every step).
* Each premise is needed. With a part whose activity never ends, a whole persists while
  nothing arises (`Immortal`). With infinitely many parts active at once, each ending at
  a different step, it persists while nothing arises, so no finite list names its active
  parts (`Countless`). The premises are consistent: generation after generation, each
  active for two steps, makes a lineage active at every step that never arises, while a
  new generation arises at every step (`Generations`). The bound `d` is attained: members
  working in shifts of two steps arise only across odd steps (`Shifts`). The converse
  fails: parts arising at arbitrarily late steps, each active once, leave the whole
  inactive between them (`Gaps`).
* `Layered`'s lineage is the whole of its members (`Layered.composed`). Its members are
  brief for one step, so one arises at every step (`Layered.brief`, `Layered.within`);
  every arising is of one of the two, whose activity does not end (`Layered.arise_again`).
* **A whole that draws its parts' arising beyond its renewal ends.** Read on one world with a
  flow: a whole of listed parts each of whose activity ends, whose parts arise only where they
  then depend on some condition of a family at a need of at least `m`, the family's renewal
  gated on it (whatever gives to a member depends on some member at such a need), with
  balance, only active formations giving and activity needing support. Where the family's
  uptake exceeds its replenishment for `n` consecutive steps from a stock below `n + m`, no
  part arises from then on and the whole ends (`Whole.family_excess_ends`; the family of one
  condition, `Whole.joint_excess_ends`): what the whole goes on through, the arising of its
  parts, ends, and the whole with it. The uptake is the joint draw, the whole's with whatever
  else takes; the whole need not be a taker, and no taker is singled out. The parts need not
  depend on the family once arisen: only their arising does. Witnesses: a lineage of members
  that each end, each arising where the condition it then depends on stands at its need and
  giving it one, the lineage taking two, has every premise, is active at three steps and ends
  (`WholeExceeding.drawn`); with the lineage taking one, within what its members give, every
  other premise holds, the lineage is active at every step and a member arises at every step
  (`WholeWithin.kept`), so the excess is needed. With a part that never ends, the whole
  persists through the same excess (`WholeUnending.persists`); with members arising without
  depending on the drawn condition, it persists while members keep arising
  (`WholeUngated.persists`). So the excess, ending parts and the arising's dependence are
  each needed; that the gate on renewal and the finite listing are needed for this law is not
  shown here.
* **A whole of every part, and a graded whole.** A formation is the *whole of every part* when it
  is active exactly while every part is (`Web.AllWhole`); every formation is that of itself as
  well (`Web.allWhole_self`). Such a whole is inactive wherever one part is
  (`AllWhole.inactive_of_part`), so it ends as soon as one part ends, with no listing and nothing
  of arising (`AllWhole.ends_of_part`), and persists exactly while every part does
  (`AllWhole.persists_iff`); a whole of some part ends only where every part ends and none arises.
  Dually to `Whole.arises_part`, a whole of some part ceases only as some part ceases
  (`Whole.ceases_part`). With some part, the two wholes of the same parts are active at the same
  steps exactly where the parts are in step, all active or none at each step
  (`Whole.same_iff_inStep`); with no part they part entirely (`AllWhole.active_of_none`). The
  *grade* of listed parts at a step is how many of them are active (`Web.Grade`), a count of
  `Becoming.Decidedness`, which exists exactly where their activity is decided. Its account across
  a step is the census, what arises less what ceases (`Grade.across_step`), so it rises only as a
  listed part arises and falls only as one ceases (`Grade.arises_of_lt`, `Grade.ceases_of_lt`). A
  formation active exactly where the grade is at least `j` (`Web.AtLeastWhole`) therefore arises
  and ceases only through a listed part (`AtLeastWhole.arises_part`, `AtLeastWhole.ceases_part`).
  At `j` one it is the whole of some listed part, at `j` the number listed the whole of every one
  (`AtLeastWhole.whole`, `AtLeastWhole.allWhole`; conversely where their activity is decided,
  `Whole.atLeastWhole`, `AllWhole.atLeastWhole`), so a whole of every listed part arises and
  ceases only through a listed part (`AllWhole.arises_part`, `AllWhole.ceases_part`). The grade
  falls short wherever a listed part is inactive (`Grade.lt_length_of_inactive`), and the whole is
  *diminished*, some parts active and not all (`Web.Diminished`), exactly where the whole of some
  is active and the whole of every one is not (`Grade.diminished_iff`, `diminished_iff`).
  Witnesses: the members of `Generations` make a lineage active at every step, while a whole of
  every member is active at none (`Generations.allWhole_never`); a house of three rafters, the
  first taken after the first step, ceases with it, and from then on two of the three are active,
  the whole diminished, what is left standing and the house not (`Rafters.taken`).

Which formations are parts of which, whether a lineage is read as the whole of its
members, and which of the wholes a whole is read as, are representational choices. On Ren's delegation of 15 October 2026 生生不息 is read at
the level of the whole, as arising that recurs through renewal, lineages and members being levels
within it (DELEGATED-CHOICES D5). That a collective is the whole of its lives, that what it
draws on is what its lives arise through, and that the joint draw is its consuming are readings
(OPENING note `collective`). No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {F C : Type}

namespace Web

variable (W : Web F C)

/-- `w` is the whole of the formations satisfying `parts`: it is active exactly while
some part is. -/
def Whole (parts : F → Prop) (w : F) : Prop :=
  ∀ t, W.active t w ↔ ∃ p, parts p ∧ W.active t p

/-- At each step the list names exactly the active parts. -/
def Listed (parts : F → Prop) (alive : Nat → List F) : Prop :=
  ∀ t p, p ∈ alive t ↔ parts p ∧ W.active t p

/-- The formation's activity ends: from some step on it is never active. -/
def Ends (f : F) : Prop :=
  ∃ T, ∀ t, T ≤ t → ¬ W.active t f

/-- The formation is never active at two steps `d` apart: active over one stretch of
steps, it is active for at most `d` of them. -/
def Brief (d : Nat) (f : F) : Prop :=
  ∀ t, W.active t f → ¬ W.active (t + d) f

/-- The formations satisfying `parts` cover the steps from `T` on: at each of them some
part is active. -/
def Covered (parts : F → Prop) (T : Nat) : Prop :=
  ∀ t, T ≤ t → ∃ p, parts p ∧ W.active t p

/-- Every formation is the whole of itself: `Whole` is coincidence of activity, not
constitution. -/
theorem whole_self (f : F) : W.Whole (· = f) f :=
  fun _ => ⟨fun active => ⟨f, rfl, active⟩,
    fun ⟨_, same, active⟩ => Eq.subst (motive := fun g => W.active _ g) same active⟩

variable {W} {parts : F → Prop} {w : F}

/-- A whole arises only as some part arises. -/
theorem Whole.arises_part (whole : W.Whole parts w) {t : Nat} (arises : W.Arises t w) :
    ∃ p, parts p ∧ W.Arises t p :=
  match (whole (t + 1)).mp arises.2 with
  | ⟨p, part, active⟩ => ⟨p, part, fun before => arises.1 ((whole t).mpr ⟨p, part, before⟩),
      active⟩

/-- So a whole arising at arbitrarily late steps has parts arising at arbitrarily late
steps. -/
theorem Whole.parts_unceasing (whole : W.Whole parts w)
    (unceasing : ∀ N, ∃ t, N ≤ t ∧ W.Arises t w) :
    ∀ N, ∃ t p, N ≤ t ∧ parts p ∧ W.Arises t p :=
  fun N => match unceasing N with
  | ⟨t, later, arises⟩ => match whole.arises_part arises with
    | ⟨p, part, arising⟩ => ⟨t, p, later, part, arising⟩

/-- Finitely many formations whose activity ends all end by one step. -/
theorem Ends.all : ∀ {l : List F}, (∀ f, f ∈ l → W.Ends f) →
    ∃ M, ∀ f, f ∈ l → ∀ t, M ≤ t → ¬ W.active t f
  | [], _ => ⟨0, fun _ mem => (nomatch mem)⟩
  | _ :: _, ends => match ends _ (.head _), Ends.all fun f mem => ends f (.tail _ mem) with
    | ⟨T, gone⟩, ⟨M, rest⟩ => ⟨T + M, fun f mem t later => match f, mem with
      | _, .head _ => gone t (Nat.le_trans (Nat.le_add_right T M) later)
      | f, .tail _ mem => rest f mem t (Nat.le_trans (Nat.le_add_left M T) later)⟩

/-- With no part arising across the `k` steps from `S`, a part active `k` steps later was
not inactive at `S`. -/
theorem active_back {S : Nat} : ∀ {k : Nat},
    (∀ j, j < k → ∀ p, parts p → ¬ W.Arises (S + j) p) →
    ∀ {p : F}, parts p → W.active (S + k) p → ¬ ¬ W.active S p
  | 0, _, _, _, active => fun inactive => inactive active
  | k + 1, quiet, p, part, active => fun inactive => quiet k (Nat.lt_succ_self k) p part
      ⟨fun before => active_back (fun j below => quiet j (Nat.lt_succ_of_lt below)) part before
        inactive, active⟩

/-- Parts covering the steps from `T` on, none of them active at two steps `d` apart,
have a part arising within every `d` consecutive steps from `T` on. -/
theorem Covered.arises_within {d T : Nat} (covered : W.Covered parts T)
    (brief : ∀ p, parts p → W.Brief d p) {S : Nat} (after : T ≤ S) :
    ¬ ∀ j, j < d → ∀ p, parts p → ¬ W.Arises (S + j) p :=
  fun quiet => match covered (S + d) (Nat.le_trans after (Nat.le_add_right S d)) with
  | ⟨_, part, active⟩ =>
    active_back quiet part active fun before => brief _ part S before active

/-- Parts each of whose activity ends, with the active ones listed, none arising from `N` on,
are all inactive from some step on: without arising, the parts end together. A part active
after `N` was active at `N`, so it is among the finitely many listed there, which all end. -/
theorem Listed.end_without_arising {N : Nat} {alive : Nat → List F}
    (listed : W.Listed parts alive) (ends : ∀ p, parts p → W.Ends p)
    (quiet : ∀ t, N ≤ t → ∀ p, parts p → ¬ W.Arises t p) :
    ∃ M, ∀ t, M ≤ t → ∀ p, parts p → ¬ W.active t p :=
  match Ends.all (l := alive N) fun p mem => ends p ((listed N p).mp mem).1 with
  | ⟨M, gone⟩ => ⟨N + M, fun t later p part active =>
    match Nat.le.dest (Nat.le_trans (Nat.le_add_right N M) later) with
    | ⟨k, same⟩ =>
      active_back (S := N) (k := k)
        (fun j _ p part => quiet (N + j) (Nat.le_add_right N j) p part) part
        (Eq.subst (motive := fun s => W.active s p) same.symm active)
        fun before => gone p ((listed N p).mpr ⟨part, before⟩) t
          (Nat.le_trans (Nat.le_add_left M N) later) active⟩

/-- Parts covering the steps from some step on, each of whose activity ends, with the
active ones listed, arise at arbitrarily late steps: were none to arise from some step on,
all would be inactive from a later step (`Listed.end_without_arising`), leaving a step
uncovered. -/
theorem Covered.needs_arising {T : Nat} {alive : Nat → List F} (covered : W.Covered parts T)
    (listed : W.Listed parts alive) (ends : ∀ p, parts p → W.Ends p) (N : Nat) :
    ¬ ∀ t, N ≤ t → ∀ p, parts p → ¬ W.Arises t p :=
  fun quiet => match listed.end_without_arising ends quiet with
  | ⟨M, gone⟩ => match covered (T + M) (Nat.le_add_right T M) with
    | ⟨p, part, active⟩ => gone (T + M) (Nat.le_add_left M T) p part active

/-- So no finite list of parts carries the cover: parts outside it arise at arbitrarily
late steps. -/
theorem Covered.needs_new {T : Nat} {alive : Nat → List F} (covered : W.Covered parts T)
    (listed : W.Listed parts alive) (ends : ∀ p, parts p → W.Ends p) {l : List F}
    (within : ∀ p, p ∈ l → parts p) (N : Nat) :
    ¬ ∀ t, N ≤ t → ∀ p, parts p → ¬ p ∈ l → ¬ W.Arises t p :=
  fun quiet => match Ends.all (l := l) fun p mem => ends p (within p mem) with
  | ⟨M, gone⟩ => covered.needs_arising listed ends (N + M)
      fun t later p part arises => quiet t (Nat.le_trans (Nat.le_add_right N M) later) p part
        (fun mem => gone p mem (t + 1)
          (Nat.le_trans (Nat.le_add_left M N) (Nat.le_trans later (Nat.le_succ t))) arises.2)
        arises

/-- A whole active at every step from `T` on is covered by its parts from `T` on. -/
theorem Whole.covered (whole : W.Whole parts w) {T : Nat}
    (persists : ∀ t, T ≤ t → W.active t w) : W.Covered parts T :=
  fun t later => (whole t).mp (persists t later)

/-- A whole active at every step from `T` on, made of parts none of which is active at two
steps `d` apart, has a part arising within every `d` consecutive steps from `T` on. -/
theorem Whole.arises_within {d : Nat} (whole : W.Whole parts w)
    (brief : ∀ p, parts p → W.Brief d p) {T : Nat} (persists : ∀ t, T ≤ t → W.active t w)
    {S : Nat} (after : T ≤ S) : ¬ ∀ j, j < d → ∀ p, parts p → ¬ W.Arises (S + j) p :=
  (whole.covered persists).arises_within brief after

/-- A whole active at every step from some step on, made of parts each of whose activity
ends, with its active parts listed, has parts arising at arbitrarily late steps: it
persists only through the unceasing generation of its parts. -/
theorem Whole.needs_arising {alive : Nat → List F} (whole : W.Whole parts w)
    (listed : W.Listed parts alive) (ends : ∀ p, parts p → W.Ends p) {T : Nat}
    (persists : ∀ t, T ≤ t → W.active t w) (N : Nat) :
    ¬ ∀ t, N ≤ t → ∀ p, parts p → ¬ W.Arises t p :=
  (whole.covered persists).needs_arising listed ends N

/-- Such a whole persists only through ever new parts: parts outside any finite list of
parts arise at arbitrarily late steps. -/
theorem Whole.needs_new {alive : Nat → List F} (whole : W.Whole parts w)
    (listed : W.Listed parts alive) (ends : ∀ p, parts p → W.Ends p) {T : Nat}
    (persists : ∀ t, T ≤ t → W.active t w) {l : List F} (within : ∀ p, p ∈ l → parts p)
    (N : Nat) : ¬ ∀ t, N ≤ t → ∀ p, parts p → ¬ p ∈ l → ¬ W.Arises t p :=
  (whole.covered persists).needs_new listed ends within N

/-- A whole of parts each of whose activity ends, with its active parts listed, ends where no
part arises from some step on: from some step on it is never active. `Whole.needs_arising`
is the same fact read from a whole that persists. -/
theorem Whole.ends_without_arising {N : Nat} {alive : Nat → List F} (whole : W.Whole parts w)
    (listed : W.Listed parts alive) (ends : ∀ p, parts p → W.Ends p)
    (quiet : ∀ t, N ≤ t → ∀ p, parts p → ¬ W.Arises t p) : W.Ends w :=
  match listed.end_without_arising ends quiet with
  | ⟨M, gone⟩ => ⟨M, fun t later active => match (whole t).mp active with
    | ⟨p, part, active⟩ => gone t later p part active⟩

/-! ## A whole drawing on what its parts arise through -/

section Drawn

variable {L : Flow F C}

/-- **A whole that draws its parts' arising beyond its renewal ends.** Take a whole of parts
each of whose activity ends, with its active parts listed, whose parts arise only where they
then depend on some condition of a family `ds` at a need of at least `m`, the family's renewal
gated on it (whatever gives to a member depends on some member at such a need), with balance,
only active formations giving and activity needing support. If the family's uptake exceeds its
replenishment for `n` consecutive steps from `T`, starting from a stock below `n + m`, no part
arises from `T + n` on and the whole ends: it ends what it goes on through, and so itself. The
uptake is the joint draw, the whole's with whatever else takes; the whole need not be among the
takers. -/
theorem Whole.family_excess_ends {alive : Nat → List F} (whole : W.Whole parts w)
    (listed : W.Listed parts alive) (ends : ∀ p, parts p → W.Ends p)
    (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    {ds : List C} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    (arising : ∀ t p, parts p → W.Arises t p →
      ∃ e, e ∈ ds ∧ W.requires (t + 1) p e ∧ m ≤ W.need (t + 1) p e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m) :
    (∀ t, T + n ≤ t → ∀ p, parts p → ¬ W.Arises t p) ∧ W.Ends w :=
  have quiet : ∀ t, T + n ≤ t → ∀ p, parts p → ¬ W.Arises t p :=
    fun t later p part arises => match Nat.le.dest later, arising t p part arises with
    | ⟨k, same⟩, ⟨e, inside, depends, high⟩ =>
      Flow.family_excess_ends balances acting dependent gated excess start (k + 1) p e inside
        (Eq.subst (motive := fun s => W.requires (s + 1) p e) same.symm depends)
        (Eq.subst (motive := fun s => m ≤ W.need (s + 1) p e) same.symm high)
        (Eq.subst (motive := fun s => W.active (s + 1) p) same.symm arises.2)
  ⟨quiet, whole.ends_without_arising listed ends quiet⟩

/-- The family of one condition: a whole whose parts arise only where they then depend on `c`
at a need of at least `m`, the renewal of `c` gated on it, ends after `n` steps of joint excess
on `c` from a level below `n + m`, and no part arises from then on. -/
theorem Whole.joint_excess_ends {alive : Nat → List F} (whole : W.Whole parts w)
    (listed : W.Listed parts alive) (ends : ∀ p, parts p → W.Ends p)
    (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    {c : C} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → 0 < L.give t f c → W.requires t f c ∧ m ≤ W.need t f c)
    (arising : ∀ t p, parts p → W.Arises t p → W.requires (t + 1) p c ∧ m ≤ W.need (t + 1) p c)
    {T n : Nat} (excess : ∀ k, k < n → L.given (T + k) c < L.taken (T + k) c)
    (start : W.level T c < n + m) :
    (∀ t, T + n ≤ t → ∀ p, parts p → ¬ W.Arises t p) ∧ W.Ends w :=
  whole.family_excess_ends (ds := [c]) listed ends balances acting dependent
    (fun t f present => Flow.gate_single (gated t f present))
    (fun t p part arises => ⟨c, .head [], arising t p part arises⟩) excess start

end Drawn

/-! ## A whole of every part, and a graded whole -/

section Every

variable (W)

/-- `w` is the whole of *every* part satisfying `parts`: it is active exactly while every part
is. `Whole` is active while some part is. -/
def AllWhole (parts : F → Prop) (w : F) : Prop :=
  ∀ t, W.active t w ↔ ∀ p, parts p → W.active t p

/-- The parts are *in step*: at each step, where one part is active every part is. -/
def InStep (parts : F → Prop) : Prop :=
  ∀ t p q, parts p → parts q → W.active t p → W.active t q

/-- Every formation is the whole of every part of itself, as it is the whole of some part of
itself (`whole_self`): with one part the two wholes are one. -/
theorem allWhole_self (f : F) : W.AllWhole (· = f) f :=
  fun _ => ⟨fun active _ same => Eq.subst (motive := fun g => W.active _ g) same.symm active,
    fun every => every f rfl⟩

variable {W}

/-- **Without a part, no whole of every part.** A whole of every part is inactive wherever one
of its parts is. -/
theorem AllWhole.inactive_of_part (whole : W.AllWhole parts w) {p : F} (part : parts p)
    {t : Nat} (inactive : ¬ W.active t p) : ¬ W.active t w :=
  fun active => inactive ((whole t).mp active p part)

/-- **A whole of every part ends as soon as one part ends**: it lasts no longer than its least
lasting part. No listing, and nothing of arising, is needed. A whole of some part ends only
where every part ends and none arises (`Whole.ends_without_arising`). -/
theorem AllWhole.ends_of_part (whole : W.AllWhole parts w) {p : F} (part : parts p)
    (ends : W.Ends p) : W.Ends w :=
  match ends with
  | ⟨T, gone⟩ => ⟨T, fun t later => whole.inactive_of_part part (gone t later)⟩

/-- A whole of every part is active at every step from `T` on exactly where every part is: it
persists with no arising, but only while no part ceases. A whole of some part persists only
through the arising of its parts (`Whole.needs_arising`). -/
theorem AllWhole.persists_iff (whole : W.AllWhole parts w) {T : Nat} :
    (∀ t, T ≤ t → W.active t w) ↔ ∀ p, parts p → ∀ t, T ≤ t → W.active t p :=
  ⟨fun persists p part t later => (whole t).mp (persists t later) p part,
   fun every t later => (whole t).mpr fun p part => every p part t later⟩

/-- A whole of every part, one of which is brief for `d`, is brief for `d`. -/
theorem AllWhole.brief_of_part (whole : W.AllWhole parts w) {p : F} (part : parts p)
    {d : Nat} (brief : W.Brief d p) : W.Brief d w :=
  fun t active => whole.inactive_of_part part (brief t ((whole t).mp active p part))

/-- A whole of some part ceases only as some part ceases: the dual of `Whole.arises_part`. -/
theorem Whole.ceases_part (whole : W.Whole parts w) {t : Nat} (ceases : W.Ceases t w) :
    ∃ p, parts p ∧ W.Ceases t p :=
  match (whole t).mp ceases.1 with
  | ⟨p, part, active⟩ =>
    ⟨p, part, active, fun after => ceases.2 ((whole (t + 1)).mpr ⟨p, part, after⟩)⟩

/-- With some part, the whole of every part is active only where the whole of some part is. -/
theorem AllWhole.active_whole {v : F} (all : W.AllWhole parts v) (whole : W.Whole parts w)
    {p₀ : F} (part₀ : parts p₀) {t : Nat} (active : W.active t v) : W.active t w :=
  (whole t).mpr ⟨p₀, part₀, (all t).mp active p₀ part₀⟩

/-- **The two wholes coincide exactly where the parts are in step.** With some part, the whole of
some part and the whole of every part of the same parts are active at the same steps exactly
where, at each step, one part active means every part active. -/
theorem Whole.same_iff_inStep {v : F} (whole : W.Whole parts w) (all : W.AllWhole parts v)
    {p₀ : F} (part₀ : parts p₀) :
    (∀ t, W.active t w ↔ W.active t v) ↔ W.InStep parts :=
  ⟨fun same t p q part partq active =>
      (all t).mp ((same t).mp ((whole t).mpr ⟨p, part, active⟩)) q partq,
   fun inStep t => ⟨fun active => match (whole t).mp active with
      | ⟨p, part, activep⟩ => (all t).mpr fun q partq => inStep t p q part partq activep,
    all.active_whole whole part₀⟩⟩

/-- Without parts the two wholes part entirely: the whole of every part of none is active at
every step, the whole of some part of none at no step. So the coincidence needs some part. -/
theorem AllWhole.active_of_none (all : W.AllWhole parts w) (absent : ∀ p, ¬ parts p) (t : Nat) :
    W.active t w ∧ ∀ {v : F}, W.Whole parts v → ¬ W.active t v :=
  ⟨(all t).mpr fun p part => absurd part (absent p),
   fun whole active => match (whole t).mp active with
    | ⟨p, part, _⟩ => absent p part⟩

end Every

section Grade

/-- A count is below the members wherever what it counts fails of one of them. -/
theorem _root_.Becoming.Counts.lt_length_of_fails {α : Type} {q : α → Prop} {a : α} (fails : ¬ q a) :
    ∀ {as : List α} {n : Nat}, Counts as q n → a ∈ as → n < as.length
  | [], _, _, mem => nomatch mem
  | _ :: _, _, ⟨_, m, indicates, rest, sum⟩, mem => match mem_cons_cases mem with
    | .inl same =>
      Nat.lt_of_le_of_lt (Nat.le_of_eq (sum.trans ((congrArg (· + m)
          (indicates.eq_zero (Eq.subst (motive := fun x => ¬ q x) same fails))).trans
          (Nat.zero_add m))))
        (Nat.lt_succ_of_le rest.le_length)
    | .inr mem =>
      Nat.lt_of_le_of_lt (Nat.le_of_eq sum)
        (Nat.lt_of_lt_of_le (Nat.add_lt_add_of_le_of_lt indicates.le_one
            (Counts.lt_length_of_fails fails rest mem))
          (Nat.le_of_eq (Nat.add_comm 1 _)))

/-- A count equal to the members holds of every member. -/
theorem _root_.Becoming.Counts.all_of_eq_length {α : Type} {q : α → Prop} {as : List α} {n : Nat}
    (counts : Counts as q n) (all : n = as.length) : ∀ a, a ∈ as → q a :=
  fun a mem => match (counts_iff_decided (q := q)).mp ⟨n, counts⟩ a mem with
  | .inl holds => holds
  | .inr fails =>
    absurd (Counts.lt_length_of_fails fails counts mem) (Nat.not_lt_of_le (Nat.le_of_eq all.symm))

variable (W)

/-- `n` is the *grade* of the listed parts at `t`: how many of them are active, each listing
counted. A grade exists exactly where each listed part's activity at `t` is decided
(`counts_iff_decided`); no decision procedure is used. -/
def Grade (ps : List F) (t n : Nat) : Prop :=
  Counts ps (W.active t) n

/-- `w` is the whole of at least `j` of the listed parts: at each step the parts have a grade,
and `w` is active exactly where it is at least `j`. -/
def AtLeastWhole (j : Nat) (ps : List F) (w : F) : Prop :=
  ∀ t, ∃ n, W.Grade ps t n ∧ (W.active t w ↔ j ≤ n)

/-- The listed parts' whole is *diminished* at `t`: some of them are active, not all. -/
def Diminished (ps : List F) (t : Nat) : Prop :=
  ∃ n, W.Grade ps t n ∧ 0 < n ∧ n < ps.length

variable {W} {ps : List F}

/-- A grade is positive exactly where some listed part is active. -/
theorem Grade.pos_iff {t n : Nat} (grade : W.Grade ps t n) :
    0 < n ↔ ∃ p, p ∈ ps ∧ W.active t p :=
  ⟨Counts.exists_of_pos grade, fun ⟨_, mem, active⟩ => Counts.pos_of_mem grade mem active⟩

/-- A grade is the number of listed parts exactly where every listed part is active. -/
theorem Grade.eq_length_iff {t n : Nat} (grade : W.Grade ps t n) :
    n = ps.length ↔ ∀ p, p ∈ ps → W.active t p :=
  ⟨Counts.all_of_eq_length grade, fun all => Counts.unique grade (Counts.of_all all)⟩

/-- **Without a part, the grade falls short.** Where a listed part is inactive, the grade is
below the number of listed parts. -/
theorem Grade.lt_length_of_inactive {t n : Nat} (grade : W.Grade ps t n) {p : F} (mem : p ∈ ps)
    (inactive : ¬ W.active t p) : n < ps.length :=
  Counts.lt_length_of_fails inactive grade mem

/-- **The grade's account across a step.** Wherever the parts arising and ceasing across the step
are counted, the grade after it with what ceased is the grade before it with what arose. This is
the census of `Becoming.Decidedness` (`Counts.across_step`) read of activity. -/
theorem Grade.across_step {t n n' a c : Nat} (now : W.Grade ps t n) (next : W.Grade ps (t + 1) n')
    (arose : Counts ps (W.Arises t) a) (ceased : Counts ps (W.Ceases t) c) : n' + c = n + a :=
  Counts.across_step (p := fun f s => W.active s f) now next arose ceased

/-- Where the grade rises across a step, a listed part arises there. -/
theorem Grade.arises_of_lt {t n n' : Nat} (now : W.Grade ps t n) (next : W.Grade ps (t + 1) n')
    (rises : n < n') : ∃ p, p ∈ ps ∧ W.Arises t p :=
  match (counts_iff_decided (q := W.Arises t)).mpr (fun p mem =>
      Decided.and ((counts_iff_decided.mp ⟨n, now⟩ p mem).not)
        (counts_iff_decided.mp ⟨n', next⟩ p mem)),
    (counts_iff_decided (q := W.Ceases t)).mpr (fun p mem =>
      Decided.and (counts_iff_decided.mp ⟨n, now⟩ p mem)
        ((counts_iff_decided.mp ⟨n', next⟩ p mem).not)) with
  | ⟨a, arose⟩, ⟨c, ceased⟩ =>
    have account : n' + c = n + a := Grade.across_step now next arose ceased
    match Nat.eq_zero_or_pos a with
    | .inr pos => arose.exists_of_pos pos
    | .inl zero => absurd (Nat.lt_of_lt_of_le rises (Nat.le_trans (Nat.le_add_right n' c)
        (Nat.le_of_eq (account.trans ((congrArg (n + ·) zero).trans (Nat.add_zero n))))))
        (Nat.lt_irrefl n)

/-- Where the grade falls across a step, a listed part ceases there. -/
theorem Grade.ceases_of_lt {t n n' : Nat} (now : W.Grade ps t n) (next : W.Grade ps (t + 1) n')
    (falls : n' < n) : ∃ p, p ∈ ps ∧ W.Ceases t p :=
  match (counts_iff_decided (q := W.Arises t)).mpr (fun p mem =>
      Decided.and ((counts_iff_decided.mp ⟨n, now⟩ p mem).not)
        (counts_iff_decided.mp ⟨n', next⟩ p mem)),
    (counts_iff_decided (q := W.Ceases t)).mpr (fun p mem =>
      Decided.and (counts_iff_decided.mp ⟨n, now⟩ p mem)
        ((counts_iff_decided.mp ⟨n', next⟩ p mem).not)) with
  | ⟨a, arose⟩, ⟨c, ceased⟩ =>
    have account : n' + c = n + a := Grade.across_step now next arose ceased
    match Nat.eq_zero_or_pos c with
    | .inr pos => ceased.exists_of_pos pos
    | .inl zero => absurd (Nat.lt_of_lt_of_le falls (Nat.le_trans (Nat.le_add_right n a)
        (Nat.le_of_eq (account.symm.trans ((congrArg (n' + ·) zero).trans (Nat.add_zero n'))))))
        (Nat.lt_irrefl n')

/-- **A whole of at least `j` listed parts arises only as some listed part arises.** -/
theorem AtLeastWhole.arises_part {j : Nat} (whole : W.AtLeastWhole j ps w) {t : Nat}
    (arises : W.Arises t w) : ∃ p, p ∈ ps ∧ W.Arises t p :=
  match whole t, whole (t + 1) with
  | ⟨_, now, before⟩, ⟨_, next, after⟩ =>
    Grade.arises_of_lt now next (Nat.lt_of_lt_of_le
      (Nat.gt_of_not_le fun reached => arises.1 (before.mpr reached)) (after.mp arises.2))

/-- **A whole of at least `j` listed parts ceases only as some listed part ceases.** -/
theorem AtLeastWhole.ceases_part {j : Nat} (whole : W.AtLeastWhole j ps w) {t : Nat}
    (ceases : W.Ceases t w) : ∃ p, p ∈ ps ∧ W.Ceases t p :=
  match whole t, whole (t + 1) with
  | ⟨_, now, before⟩, ⟨_, next, after⟩ =>
    Grade.ceases_of_lt now next (Nat.lt_of_lt_of_le
      (Nat.gt_of_not_le fun reached => ceases.2 (after.mpr reached)) (before.mp ceases.1))

/-- The whole of at least one listed part is the whole of some listed part. -/
theorem AtLeastWhole.whole (whole : W.AtLeastWhole 1 ps w) : W.Whole (· ∈ ps) w :=
  fun t => match whole t with
  | ⟨_, grade, iff⟩ => iff.trans (Grade.pos_iff grade)

/-- Where the listed parts' activity is decided at every step, the whole of some listed part is
the whole of at least one. -/
theorem Whole.atLeastWhole (whole : W.Whole (· ∈ ps) w)
    (decided : ∀ t p, p ∈ ps → Decided (W.active t p)) : W.AtLeastWhole 1 ps w :=
  fun t => match (counts_iff_decided (q := W.active t)).mpr (decided t) with
  | ⟨n, grade⟩ => ⟨n, grade, (whole t).trans (Grade.pos_iff grade).symm⟩

/-- The whole of at least as many listed parts as are listed is the whole of every listed part.
-/
theorem AtLeastWhole.allWhole (whole : W.AtLeastWhole ps.length ps w) : W.AllWhole (· ∈ ps) w :=
  fun t => match whole t with
  | ⟨_, grade, iff⟩ => iff.trans
    ⟨fun le => (Grade.eq_length_iff grade).mp (Nat.le_antisymm (Counts.le_length grade) le),
     fun all => Nat.le_of_eq ((Grade.eq_length_iff grade).mpr all).symm⟩

/-- Where the listed parts' activity is decided at every step, the whole of every listed part is
the whole of at least as many as are listed. -/
theorem AllWhole.atLeastWhole (all : W.AllWhole (· ∈ ps) w)
    (decided : ∀ t p, p ∈ ps → Decided (W.active t p)) : W.AtLeastWhole ps.length ps w :=
  fun t => match (counts_iff_decided (q := W.active t)).mpr (decided t) with
  | ⟨n, grade⟩ => ⟨n, grade, (all t).trans
      ⟨fun every => Nat.le_of_eq ((Grade.eq_length_iff grade).mpr every).symm,
       fun le => (Grade.eq_length_iff grade).mp (Nat.le_antisymm (Counts.le_length grade) le)⟩⟩

/-- **A whole of every listed part arises only as some listed part arises**, where their activity
is decided: the account of the grade (`AtLeastWhole.arises_part`). -/
theorem AllWhole.arises_part (all : W.AllWhole (· ∈ ps) w)
    (decided : ∀ t p, p ∈ ps → Decided (W.active t p)) {t : Nat} (arises : W.Arises t w) :
    ∃ p, p ∈ ps ∧ W.Arises t p :=
  (all.atLeastWhole decided).arises_part arises

/-- **A whole of every listed part ceases only as some listed part ceases**, where their activity
is decided: the account of the grade (`AtLeastWhole.ceases_part`). -/
theorem AllWhole.ceases_part (all : W.AllWhole (· ∈ ps) w)
    (decided : ∀ t p, p ∈ ps → Decided (W.active t p)) {t : Nat} (ceases : W.Ceases t w) :
    ∃ p, p ∈ ps ∧ W.Ceases t p :=
  (all.atLeastWhole decided).ceases_part ceases

/-- **The diminished whole.** Where the listed parts have a grade, the whole they make is
diminished, some parts active and not all, exactly where the whole of some of them is active and
the whole of every one is not. -/
theorem Grade.diminished_iff {v : F} (whole : W.Whole (· ∈ ps) w) (all : W.AllWhole (· ∈ ps) v)
    {t n : Nat} (grade : W.Grade ps t n) :
    (0 < n ∧ n < ps.length) ↔ (W.active t w ∧ ¬ W.active t v) :=
  ⟨fun ⟨pos, short⟩ => ⟨(whole t).mpr ((Grade.pos_iff grade).mp pos),
     fun active => Nat.ne_of_lt short ((Grade.eq_length_iff grade).mpr ((all t).mp active))⟩,
   fun ⟨active, notAll⟩ => ⟨(Grade.pos_iff grade).mpr ((whole t).mp active),
     Nat.lt_of_le_of_ne (Counts.le_length grade) fun full => notAll ((all t).mpr
       ((Grade.eq_length_iff grade).mp full))⟩⟩

/-- So the whole is diminished at `t` exactly where, its parts' activity decided there, the whole
of some is active and the whole of every one is not. -/
theorem diminished_iff {v : F} (whole : W.Whole (· ∈ ps) w) (all : W.AllWhole (· ∈ ps) v)
    {t : Nat} (decided : ∀ p, p ∈ ps → Decided (W.active t p)) :
    W.Diminished ps t ↔ (W.active t w ∧ ¬ W.active t v) :=
  ⟨fun ⟨_, grade, within⟩ => (Grade.diminished_iff whole all grade).mp within,
   fun both => match (counts_iff_decided (q := W.active t)).mpr decided with
    | ⟨n, grade⟩ => ⟨n, grade, (Grade.diminished_iff whole all grade).mpr both⟩⟩

end Grade

end Web

/-! ## Witnesses -/

namespace Generations

/-- A lineage, and its members, one given at each step. -/
inductive Formation where
  | lineage
  | member (n : Nat)

/-- The members. -/
def parts : Formation → Prop
  | .lineage => False
  | .member _ => True

/-- The `n`th member is active at steps `n` and `n + 1`; the lineage at every step. -/
def web : Web Formation Unit where
  level _ _ := 0
  active t f := match f with
    | .lineage => True
    | .member n => t = n ∨ t = n + 1
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- The members active at each step. -/
def alive : Nat → List Formation
  | 0 => [.member 0]
  | t + 1 => [.member (t + 1), .member t]

theorem whole : web.Whole parts .lineage :=
  fun t => ⟨fun _ => ⟨.member t, trivial, .inl rfl⟩, fun _ => trivial⟩

theorem listed : web.Listed parts alive
  | 0, .lineage => ⟨fun mem => match mem with | .tail _ no => (nomatch no),
      fun ⟨no, _⟩ => no.elim⟩
  | 0, .member n => ⟨fun mem => match n, (mem : Formation.member n ∈ [.member 0]) with
      | _, .head _ => ⟨trivial, .inl rfl⟩
      | _, .tail _ no => (nomatch no),
      fun ⟨_, active⟩ => match active with
      | .inl same => show Formation.member n ∈ [.member 0] from same ▸ .head _
      | .inr same => Nat.noConfusion same⟩
  | _ + 1, .lineage => ⟨fun mem => match mem with | .tail _ (.tail _ no) => (nomatch no),
      fun ⟨no, _⟩ => no.elim⟩
  | t + 1, .member n => ⟨fun mem =>
      match n, (mem : Formation.member n ∈ [.member (t + 1), .member t]) with
      | _, .head _ => ⟨trivial, .inl rfl⟩
      | _, .tail _ (.head _) => ⟨trivial, .inr rfl⟩
      | _, .tail _ (.tail _ no) => (nomatch no),
      fun ⟨_, active⟩ => match active with
      | .inl same => show Formation.member n ∈ [.member (t + 1), .member t] from same ▸ .head _
      | .inr same => show Formation.member n ∈ [.member (t + 1), .member t] from
          Nat.succ.inj same ▸ .tail _ (.head _)⟩

theorem ends : ∀ p, parts p → web.Ends p
  | .member n, _ => ⟨n + 2, fun _ later active => match active with
    | .inl same => Nat.lt_irrefl n (Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right (Nat.succ_pos 1))
        (Eq.subst (motive := (n + 2 ≤ ·)) same later))
    | .inr same => Nat.not_succ_le_self (n + 1) (Eq.subst (motive := (n + 2 ≤ ·)) same later)⟩

theorem brief : ∀ p, parts p → web.Brief 2 p
  | .member _, _ => fun t active later => match active, later with
    | .inl now, .inl two =>
      Nat.ne_of_lt (Nat.lt_add_of_pos_right (Nat.succ_pos 1)) (now.trans two.symm)
    | .inl now, .inr two =>
      Nat.ne_of_lt (Nat.lt_succ_self (t + 1)) ((congrArg (· + 1) now).trans two.symm)
    | .inr now, .inl two => Nat.ne_of_lt (Nat.lt_add_of_pos_right (Nat.succ_pos 2))
        ((congrArg (· + 2) now).symm.trans two).symm
    | .inr now, .inr two => Nat.ne_of_lt (Nat.lt_add_of_pos_right (Nat.succ_pos 1))
        (now.trans (congrArg (· + 1) (Nat.succ.inj two).symm))

/-- Generation after generation, each active for two steps, makes a lineage active at
every step: every premise of `Whole.arises_within` and `Whole.needs_arising` holds, a
member arises at every step, and the lineage never arises. -/
theorem generations : web.Whole parts .lineage ∧ web.Listed parts alive ∧
    (∀ p, parts p → web.Ends p) ∧ (∀ p, parts p → web.Brief 2 p) ∧
    (∀ t, web.active t .lineage) ∧
    (∀ t, web.Arises t (.member (t + 1))) ∧ ∀ t, ¬ web.Arises t .lineage :=
  ⟨whole, listed, ends, brief, fun _ => trivial,
   fun t => ⟨fun active => match active with
      | .inl same => Nat.ne_of_lt (Nat.lt_succ_self t) same
      | .inr same => Nat.ne_of_lt (Nat.lt_add_of_pos_right (Nat.succ_pos 1)) same,
    .inl rfl⟩,
   fun _ arises => arises.1 trivial⟩

end Generations

namespace Shifts

theorem odd_two (t : Nat) : odd (t + 2) = odd t :=
  show (!!odd t) = odd t from match odd t with
  | true => rfl
  | false => rfl

theorem half_even : ∀ t, odd t = false → Pulse.half (t + 1) = Pulse.half t
  | 0, _ => rfl
  | 1, odd' => (nomatch odd')
  | t + 2, even => congrArg (· + 1) (half_even t ((odd_two t).symm.trans even))

/-- The members of `Generations`, the `n`th active at steps `2n` and `2n + 1`; the lineage
at every step. -/
def web : Web Generations.Formation Unit where
  level _ _ := 0
  active t f := match f with
    | .lineage => True
    | .member n => Pulse.half t = n
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- Members working in shifts of two steps: the lineage is their whole and is active at
every step, no member is active at two steps two apart, and no member arises across an
even step. So a part arises within every two consecutive steps but not within every
one: the bound of `Whole.arises_within` is attained. -/
theorem shifts : web.Whole Generations.parts .lineage ∧
    (∀ p, Generations.parts p → web.Brief 2 p) ∧ (∀ t, web.active t .lineage) ∧
    ∀ t, odd t = false → ∀ p, ¬ web.Arises t p :=
  ⟨fun t => ⟨fun _ => ⟨.member (Pulse.half t), trivial, rfl⟩, fun _ => trivial⟩,
   fun p _ => match p with
    | .member _ => fun _ now later => Nat.succ_ne_self _ (later.trans now.symm),
   fun _ => trivial,
   fun t even p arises => match p with
    | .lineage => arises.1 trivial
    | .member _ => arises.1 ((half_even t even).symm.trans arises.2)⟩

end Shifts

namespace Immortal

/-- A whole (`false`) of one part (`true`) that is always active. -/
def web : Web Bool Unit where
  level _ _ := 0
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- With a part whose activity never ends, the whole persists, its active parts are listed,
and nothing ever arises. -/
theorem immortal : web.Whole (· = true) false ∧ web.Listed (· = true) (fun _ => [true]) ∧
    (∀ t, web.active t false) ∧ (∀ t p, ¬ web.Arises t p) ∧ ¬ web.Ends true :=
  ⟨fun _ => ⟨fun _ => ⟨true, rfl, trivial⟩, fun _ => trivial⟩,
   fun _ p => ⟨fun mem => match p, mem with
      | _, .head _ => ⟨rfl, trivial⟩,
      fun ⟨same, _⟩ => match p, same with
      | _, rfl => .head _⟩,
   fun _ => trivial, fun _ _ arises => arises.1 trivial,
   fun ⟨T, gone⟩ => gone T (Nat.le_refl T) trivial⟩

/-- The two formations, active at every step, are each the whole of the other. -/
theorem each_other : web.Whole (· = true) false ∧ web.Whole (· = false) true :=
  ⟨fun _ => ⟨fun _ => ⟨true, rfl, trivial⟩, fun _ => trivial⟩,
   fun _ => ⟨fun _ => ⟨false, rfl, trivial⟩, fun _ => trivial⟩⟩

end Immortal

namespace Countless

/-- The parts: every `some n`; `none` is the whole. -/
def parts : Option Nat → Prop
  | none => False
  | some _ => True

/-- The whole is active at every step; the `n`th part up to step `n`. -/
def web : Web (Option Nat) Unit where
  level _ _ := 0
  active t f := match f with
    | none => True
    | some n => t ≤ n
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

theorem whole : web.Whole parts none :=
  fun t => ⟨fun _ => ⟨some t, trivial, Nat.le_refl t⟩, fun _ => trivial⟩

theorem ends : ∀ p, parts p → web.Ends p
  | some n, _ => ⟨n + 1, fun _ later active => Nat.not_succ_le_self n
      (Nat.le_trans later active)⟩

theorem never : ∀ t p, ¬ web.Arises t p
  | _, none, arises => arises.1 trivial
  | _, some _, arises => arises.1 (Nat.le_of_succ_le arises.2)

/-- With infinitely many parts active at once, each ending at a different step, the whole
persists and nothing ever arises; so no finite list names its active parts. -/
theorem countless : web.Whole parts none ∧ (∀ p, parts p → web.Ends p) ∧
    (∀ t, web.active t none) ∧ (∀ t p, ¬ web.Arises t p) ∧
    ¬ ∃ alive, web.Listed parts alive :=
  ⟨whole, ends, fun _ => trivial, never,
   fun ⟨_, listed⟩ => Web.Whole.needs_arising whole listed ends (T := 0) (fun _ _ => trivial) 0
     fun t _ p _ => never t p⟩

end Countless

namespace Gaps

/-- One at the odd steps, as a list: the member of that step. -/
def alive (t : Nat) : List Generations.Formation :=
  match odd t with
  | true => [.member t]
  | false => []

/-- The `n`th member is active only at step `n`, and only if `n` is odd; the lineage
while some member is. -/
def web : Web Generations.Formation Unit where
  level _ _ := 0
  active t f := match f with
    | .lineage => odd t = true
    | .member n => t = n ∧ odd t = true
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

theorem whole : web.Whole Generations.parts .lineage :=
  fun t => ⟨fun odd' => ⟨.member t, trivial, rfl, odd'⟩,
    fun ⟨p, part, active⟩ => match p, part, active with
    | .member _, _, ⟨_, odd'⟩ => odd'⟩

theorem alive_odd {t : Nat} (h : odd t = true) : alive t = [.member t] := by
  unfold alive; rw [h]

theorem alive_even {t : Nat} (h : odd t = false) : alive t = [] := by
  unfold alive; rw [h]

theorem listed : web.Listed Generations.parts alive :=
  fun t p => match h : odd t with
  | true => (alive_odd h) ▸ match p with
    | .lineage => ⟨fun mem => match mem with | .tail _ no => (nomatch no),
        fun ⟨no, _⟩ => no.elim⟩
    | .member n => ⟨fun mem => match mem with
        | .head _ => ⟨trivial, rfl, h⟩
        | .tail _ no => (nomatch no),
        fun ⟨_, same, _⟩ => show Generations.Formation.member n ∈ [.member t] from
          same ▸ .head _⟩
  | false => (alive_even h) ▸ ⟨fun mem => (nomatch mem), fun ⟨part, active⟩ =>
      match p, part, active with
      | .member _, _, ⟨_, odd'⟩ => (nomatch h.symm.trans odd')⟩

theorem ends : ∀ p, Generations.parts p → web.Ends p
  | .member n, _ => ⟨n + 1, fun _ later active => Nat.not_succ_le_self n (active.1 ▸ later)⟩

/-- Members active once each, at the odd steps: they arise at arbitrarily late steps,
their activity ends and the active ones are listed, yet the whole is inactive at every
even step. -/
theorem gaps : web.Whole Generations.parts .lineage ∧ web.Listed Generations.parts alive ∧
    (∀ p, Generations.parts p → web.Ends p) ∧
    (∀ N, ∃ t p, N ≤ t ∧ Generations.parts p ∧ web.Arises t p) ∧
    ∀ t, odd t = false → ¬ web.active t .lineage :=
  ⟨whole, listed, ends,
   fun N => match h : odd N with
    | false => ⟨N, .member (N + 1), Nat.le_refl N, trivial,
        fun ⟨same, _⟩ => Nat.ne_of_lt (Nat.lt_succ_self N) same,
        rfl, congrArg (!·) h⟩
    | true => ⟨N + 1, .member (N + 2), Nat.le_succ N, trivial,
        fun ⟨same, _⟩ => Nat.ne_of_lt (Nat.lt_succ_self (N + 1)) same,
        rfl, show (!!odd N) = true from congrArg (fun b => !!b) h⟩,
   fun _ even odd' => (nomatch even.symm.trans odd')⟩

end Gaps

namespace Layered

/-- The lineage is the whole of its members. -/
theorem composed : web.Whole (· ≠ .lineage) .lineage :=
  fun t => ⟨fun _ => match h : odd t with
      | true => ⟨.second, Level.noConfusion, h⟩
      | false => ⟨.first, Level.noConfusion, h⟩,
    fun _ => trivial⟩

/-- Neither member is active at two consecutive steps. -/
theorem brief : ∀ p, p ≠ Level.lineage → web.Brief 1 p
  | .first, _ => fun t now later =>
      Bool.noConfusion ((congrArg (!·) now).symm.trans (later : (!odd t) = false))
  | .second, _ => fun t now later =>
      Bool.noConfusion ((congrArg (!·) now).symm.trans (later : (!odd t) = true))
  | .lineage, other => absurd rfl other

/-- So `Whole.arises_within` applies with `d = 1`: a member arises across every step. -/
theorem within (S : Nat) : ¬ ∀ j, j < 1 → ∀ p, p ≠ Level.lineage → ¬ web.Arises (S + j) p :=
  composed.arises_within brief (T := 0) (fun _ _ => trivial) (Nat.zero_le S)

/-- Every arising is the arising of one of the two members, and neither member's activity
ends: under brevity the generation that carries the lineage is the same two members
arising again, nothing new. -/
theorem arise_again :
    (∀ t p, web.Arises t p → p ∈ [Level.first, .second]) ∧ ¬ web.Ends .first ∧
    ¬ web.Ends .second :=
  ⟨fun _ p arises => match p, arises with
    | .first, _ => .head _
    | .second, _ => .tail _ (.head _)
    | .lineage, arises => absurd trivial arises.1,
   fun ⟨T, gone⟩ => match h : odd T with
    | false => gone T (Nat.le_refl T) h
    | true => gone (T + 1) (Nat.le_succ T) (congrArg (!·) h),
   fun ⟨T, gone⟩ => match h : odd T with
    | true => gone T (Nat.le_refl T) h
    | false => gone (T + 1) (Nat.le_succ T) (congrArg (!·) h)⟩

end Layered

namespace WholeExceeding

open Generations (Formation parts)

/-- The members active at each step: the first at steps zero and one, the second at steps one
and two, and no later member. -/
def alive : Nat → List Formation
  | 0 => [.member 0]
  | 1 => [.member 1, .member 0]
  | 2 => [.member 1]
  | _ + 3 => []

/-- A lineage and its members on one condition, which stands at two, one, then nothing. Each
member depends on the condition at need one at its first active step only; the lineage is active
while some member is and depends on nothing. -/
def web : Web Formation Unit where
  level t _ := Witnesses.profile [2, 1] 0 t
  active t f := match f with
    | .lineage => Witnesses.profile [True, True, True] False t
    | .member n => Witnesses.profile
        [Witnesses.profile [True, True] False t, Witnesses.profile [False, True, True] False t]
        False n
  requires t f _ := match f with
    | .lineage => False
    | .member n => t = n
  need _ _ _ := 1
  draws _ f _ := match f with
    | .lineage => True
    | .member _ => False

/-- At steps zero and one the member arising there gives the condition one, and the lineage
takes two. -/
def flow : Flow Formation Unit where
  present t := match t with
    | 0 => [.member 0, .lineage]
    | 1 => [.member 1, .lineage]
    | _ + 2 => []
  take _ f _ := match f with
    | .lineage => 2
    | .member _ => 0
  give _ f _ := match f with
    | .lineage => 0
    | .member _ => 1

theorem balances : flow.Balances web
  | 0, () => rfl
  | 1, () => rfl
  | _ + 2, () => rfl

theorem acting : flow.Acting web
  | 0, _, _, .head _, _ => trivial
  | 1, _, _, .head _, _ => trivial
  | 0, _, _, .tail _ (.head _), gives => absurd gives (Nat.lt_irrefl 0)
  | 1, _, _, .tail _ (.head _), gives => absurd gives (Nat.lt_irrefl 0)

theorem dependent : web.Dependent
  | _, .lineage, _, _, no => False.elim no
  | 0, .member 0, _, _, _ => Nat.le_succ 1
  | 1, .member 0, _, _, same => Nat.noConfusion same
  | _ + 2, .member 0, dead, _, _ => False.elim dead
  | 0, .member 1, dead, _, _ => False.elim dead
  | 1, .member 1, _, _, _ => Nat.le_refl 1
  | 2, .member 1, _, _, same => Nat.noConfusion (Nat.succ.inj same)
  | _ + 3, .member 1, dead, _, _ => False.elim dead
  | _, .member (_ + 2), dead, _, _ => False.elim dead

/-- Only the member arising at a step gives, and it depends on the condition then. -/
theorem gated : ∀ t f, f ∈ flow.present t → ∀ d, d ∈ [()] → 0 < flow.give t f d →
    ∃ e, e ∈ [()] ∧ web.requires t f e ∧ 1 ≤ web.need t f e
  | 0, _, .head _, _, _, _ => ⟨(), .head [], rfl, Nat.le_refl 1⟩
  | 1, _, .head _, _, _, _ => ⟨(), .head [], rfl, Nat.le_refl 1⟩
  | 0, _, .tail _ (.head _), _, _, gives => absurd gives (Nat.lt_irrefl 0)
  | 1, _, .tail _ (.head _), _, _, gives => absurd gives (Nat.lt_irrefl 0)

/-- A member arises only where it then depends on the condition. -/
theorem arising : ∀ t p, parts p → web.Arises t p →
    ∃ e, e ∈ [()] ∧ web.requires (t + 1) p e ∧ 1 ≤ web.need (t + 1) p e
  | _, .lineage, no, _ => False.elim no
  | 0, .member 1, _, _ => ⟨(), .head [], rfl, Nat.le_refl 1⟩
  | 0, .member 0, _, arises => absurd trivial arises.1
  | 1, .member 0, _, arises => False.elim arises.2
  | _ + 2, .member 0, _, arises => False.elim arises.2
  | 1, .member 1, _, arises => absurd trivial arises.1
  | 2, .member 1, _, arises => absurd trivial arises.1
  | _ + 3, .member 1, _, arises => False.elim arises.2
  | _, .member (_ + 2), _, arises => False.elim arises.2

theorem whole : web.Whole parts .lineage
  | 0 => ⟨fun _ => ⟨.member 0, trivial, trivial⟩, fun _ => trivial⟩
  | 1 => ⟨fun _ => ⟨.member 0, trivial, trivial⟩, fun _ => trivial⟩
  | 2 => ⟨fun _ => ⟨.member 1, trivial, trivial⟩, fun _ => trivial⟩
  | _ + 3 => ⟨fun dead => False.elim dead, fun ⟨p, _, active⟩ => match p, active with
      | .lineage, dead => False.elim dead
      | .member 0, dead => False.elim dead
      | .member 1, dead => False.elim dead
      | .member (_ + 2), dead => False.elim dead⟩

theorem member_ne {i j : Nat} (other : i = j → False) :
    Formation.member i = .member j → False :=
  fun same => Formation.noConfusion same other

theorem lineage_ne {j : Nat} : Formation.lineage = .member j → False :=
  fun same => Formation.noConfusion same

/-- A formation equal to neither of two is not in their list. -/
theorem not_mem_pair {a b c : Formation} (first : a = b → False) (second : a = c → False) :
    ¬ a ∈ [b, c] :=
  fun mem => (ListTests.mem_cons_iff.mp mem).elim first
    fun rest => second (ListTests.mem_singleton_iff.mp rest)

theorem listed : web.Listed parts alive
  | 0, .lineage => ⟨fun mem => absurd (ListTests.mem_singleton_iff.mp mem) lineage_ne,
      fun ⟨no, _⟩ => False.elim no⟩
  | 0, .member 0 => ⟨fun _ => ⟨trivial, trivial⟩, fun _ => .head _⟩
  | 0, .member 1 => ⟨fun mem => absurd (ListTests.mem_singleton_iff.mp mem)
      (member_ne Nat.noConfusion),
      fun ⟨_, dead⟩ => False.elim dead⟩
  | 0, .member (_ + 2) => ⟨fun mem => absurd (ListTests.mem_singleton_iff.mp mem)
      (member_ne Nat.noConfusion),
      fun ⟨_, dead⟩ => False.elim dead⟩
  | 1, .lineage => ⟨fun mem => absurd mem <| not_mem_pair lineage_ne lineage_ne,
      fun ⟨no, _⟩ => False.elim no⟩
  | 1, .member 0 => ⟨fun _ => ⟨trivial, trivial⟩, fun _ => .tail _ (.head _)⟩
  | 1, .member 1 => ⟨fun _ => ⟨trivial, trivial⟩, fun _ => .head _⟩
  | 1, .member (_ + 2) => ⟨fun mem => absurd mem <| not_mem_pair
      (member_ne fun same => Nat.noConfusion (Nat.succ.inj same)) (member_ne Nat.noConfusion),
      fun ⟨_, dead⟩ => False.elim dead⟩
  | 2, .lineage => ⟨fun mem => absurd (ListTests.mem_singleton_iff.mp mem) lineage_ne,
      fun ⟨no, _⟩ => False.elim no⟩
  | 2, .member 0 => ⟨fun mem => absurd (ListTests.mem_singleton_iff.mp mem)
      (member_ne Nat.noConfusion),
      fun ⟨_, dead⟩ => False.elim dead⟩
  | 2, .member 1 => ⟨fun _ => ⟨trivial, trivial⟩, fun _ => .head _⟩
  | 2, .member (_ + 2) => ⟨fun mem => absurd (ListTests.mem_singleton_iff.mp mem)
      (member_ne fun same => Nat.noConfusion (Nat.succ.inj same)),
      fun ⟨_, dead⟩ => False.elim dead⟩
  | _ + 3, .lineage => ⟨fun mem => (nomatch mem), fun ⟨no, _⟩ => False.elim no⟩
  | _ + 3, .member 0 => ⟨fun mem => (nomatch mem), fun ⟨_, dead⟩ => False.elim dead⟩
  | _ + 3, .member 1 => ⟨fun mem => (nomatch mem), fun ⟨_, dead⟩ => False.elim dead⟩
  | _ + 3, .member (_ + 2) => ⟨fun mem => (nomatch mem), fun ⟨_, dead⟩ => False.elim dead⟩

theorem ends : ∀ p, parts p → web.Ends p
  | .lineage, no => False.elim no
  | .member 0, _ => ⟨2, fun t later => match t, later with
      | 0, later => absurd later (Nat.not_succ_le_zero 1)
      | 1, later => absurd later (Nat.not_succ_le_self 1)
      | _ + 2, _ => fun dead => False.elim dead⟩
  | .member 1, _ => ⟨3, fun t later => match t, later with
      | 0, later => absurd later (Nat.not_succ_le_zero 2)
      | 1, later => absurd (Nat.le_of_succ_le_succ later) (Nat.not_succ_le_zero 1)
      | 2, later => absurd later (Nat.not_succ_le_self 2)
      | _ + 3, _ => fun dead => False.elim dead⟩
  | .member (_ + 2), _ => ⟨0, fun _ _ dead => False.elim dead⟩

/-- At steps zero and one the lineage takes more than the members give. -/
theorem excess : ∀ k, k < 2 → flow.replenishment [()] (0 + k) < flow.uptake [()] (0 + k)
  | 0, _ => Nat.lt_succ_self 1
  | 1, _ => Nat.lt_succ_self 1
  | _ + 2, late => absurd late (Nat.not_lt_of_le (Nat.le_add_left 2 _))

/-- A lineage of members that each end, each arising where the condition it then depends on
stands at its need, drawing with them on that condition two where they give one: every premise
of `Whole.family_excess_ends` holds, the lineage is active at steps zero to two, and, derived
through the law, no member arises from step two on and the lineage ends. -/
theorem drawn : web.Whole parts .lineage ∧ web.Listed parts alive ∧
    (∀ p, parts p → web.Ends p) ∧ flow.Balances web ∧ flow.Acting web ∧ web.Dependent ∧
    (∀ t, t < 3 → web.active t .lineage) ∧
    (∀ t, 2 ≤ t → ∀ p, parts p → ¬ web.Arises t p) ∧ web.Ends .lineage :=
  ⟨whole, listed, ends, balances, acting, dependent,
   fun t below => match t, below with
    | 0, _ => trivial
    | 1, _ => trivial
    | 2, _ => trivial
    | _ + 3, late => absurd late (Nat.not_lt_of_le (Nat.le_add_left 3 _)),
   whole.family_excess_ends listed ends balances acting dependent gated arising (T := 0)
     excess (Nat.lt_succ_self 2)⟩

end WholeExceeding

namespace WholeWithin

open Generations (Formation parts)

/-- The lineage of `Generations` on one condition standing at two: each member depends on it
at need one at its first active step. -/
def web : Web Formation Unit where
  level _ _ := 2
  active := Generations.web.active
  requires t f _ := match f with
    | .lineage => False
    | .member n => t = n
  need _ _ _ := 1
  draws _ f _ := match f with
    | .lineage => True
    | .member _ => False

/-- At each step the member arising there gives the condition one, and the lineage takes one. -/
def flow : Flow Formation Unit where
  present t := [.member t, .lineage]
  take _ f _ := match f with
    | .lineage => 1
    | .member _ => 0
  give _ f _ := match f with
    | .lineage => 0
    | .member _ => 1

theorem balances : flow.Balances web := fun _ _ => rfl

theorem acting : flow.Acting web
  | _, _, _, .head _, _ => .inl rfl
  | _, _, _, .tail _ (.head _), gives => absurd gives (Nat.lt_irrefl 0)

theorem dependent : web.Dependent := fun _ _ _ _ _ => Nat.le_succ 1

theorem gated : ∀ t f, f ∈ flow.present t → ∀ d, d ∈ [()] → 0 < flow.give t f d →
    ∃ e, e ∈ [()] ∧ web.requires t f e ∧ 1 ≤ web.need t f e
  | _, _, .head _, _, _, _ => ⟨(), .head [], rfl, Nat.le_refl 1⟩
  | _, _, .tail _ (.head _), _, _, gives => absurd gives (Nat.lt_irrefl 0)

theorem arising : ∀ t p, parts p → web.Arises t p →
    ∃ e, e ∈ [()] ∧ web.requires (t + 1) p e ∧ 1 ≤ web.need (t + 1) p e
  | _, .lineage, no, _ => False.elim no
  | _, .member _, _, arises => ⟨(), .head [], match arises.2 with
      | .inl first => first
      | .inr again => absurd (.inl (Nat.succ.inj again)) arises.1, Nat.le_refl 1⟩

/-- With every premise of `Whole.family_excess_ends` but the excess, the lineage taking within
what its members give: the lineage is active at every step and a member arises at every step.
The excess is needed. -/
theorem kept : web.Whole parts .lineage ∧ web.Listed parts Generations.alive ∧
    (∀ p, parts p → web.Ends p) ∧ flow.Balances web ∧ flow.Acting web ∧ web.Dependent ∧
    (∀ t, flow.WithinJoint t ()) ∧ (∀ t, web.active t .lineage) ∧
    ∀ t, web.Arises t (.member (t + 1)) :=
  ⟨Generations.whole, Generations.listed, Generations.ends, balances, acting, dependent,
   fun _ => Nat.le_refl 1, fun _ => trivial, Generations.generations.2.2.2.2.2.1⟩

end WholeWithin

namespace WholeUnending

/-- A whole (`false`) of one part (`true`), both active at every step, on a condition standing
at one, then nothing; neither depends on it. -/
def web : Web Bool Unit where
  level t _ := Witnesses.profile [1] 0 t
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 1
  draws _ f _ := f = false

/-- At step zero the whole takes one; nothing gives. -/
def flow : Flow Bool Unit where
  present t := Witnesses.profile [[false]] [] t
  take _ _ _ := 1
  give _ _ _ := 0

theorem balances : flow.Balances web
  | 0, () => rfl
  | _ + 1, () => rfl

/-- With a part whose activity never ends, every other premise of `Whole.family_excess_ends`
holds, the uptake exceeding the replenishment at step zero from a stock below one plus the need,
and the whole is active at every step: ending parts are needed. -/
theorem persists : web.Whole (· = true) false ∧ web.Listed (· = true) (fun _ => [true]) ∧
    flow.Balances web ∧ flow.Acting web ∧ web.Dependent ∧
    (∀ t f, f ∈ flow.present t → ∀ d, d ∈ [()] → 0 < flow.give t f d →
      ∃ e, e ∈ [()] ∧ web.requires t f e ∧ 1 ≤ web.need t f e) ∧
    (∀ t p, p = true → web.Arises t p →
      ∃ e, e ∈ [()] ∧ web.requires (t + 1) p e ∧ 1 ≤ web.need (t + 1) p e) ∧
    (∀ k, k < 1 → flow.replenishment [()] (0 + k) < flow.uptake [()] (0 + k)) ∧
    web.stock [()] 0 < 1 + 1 ∧ (∀ t, web.active t false) ∧ ¬ web.Ends true :=
  ⟨fun _ => ⟨fun _ => ⟨true, rfl, trivial⟩, fun _ => trivial⟩,
   fun _ _ => ⟨fun mem => ⟨ListTests.mem_singleton_iff.mp mem, trivial⟩,
     fun ⟨same, _⟩ => ListTests.mem_singleton_iff.mpr same⟩,
   balances, fun _ _ _ _ gives => absurd gives (Nat.lt_irrefl 0),
   fun _ _ _ _ no => False.elim no, fun _ _ _ _ _ gives => absurd gives (Nat.lt_irrefl 0),
   fun _ _ _ arises => absurd trivial arises.1,
   fun k below => match k, below with
    | 0, _ => Nat.zero_lt_one
    | _ + 1, late => absurd late (Nat.not_lt_of_le (Nat.le_add_left 1 _)),
   Nat.lt_succ_self 1, fun _ => trivial, fun ⟨T, gone⟩ => gone T (Nat.le_refl T) trivial⟩

end WholeUnending

namespace WholeUngated

open Generations (Formation parts)

/-- The lineage of `Generations` on a condition standing at one, then nothing; no member
depends on it. -/
def web : Web Formation Unit where
  level t _ := Witnesses.profile [1] 0 t
  active := Generations.web.active
  requires _ _ _ := False
  need _ _ _ := 1
  draws _ f _ := match f with
    | .lineage => True
    | .member _ => False

/-- At step zero the lineage takes one; nothing gives. -/
def flow : Flow Formation Unit where
  present t := Witnesses.profile [[.lineage]] [] t
  take _ _ _ := 1
  give _ _ _ := 0

theorem balances : flow.Balances web
  | 0, () => rfl
  | _ + 1, () => rfl

/-- With members arising without depending on the drawn condition, every other premise of
`Whole.family_excess_ends` holds, the uptake exceeding the replenishment at step zero from a
stock below one plus the need, and the lineage is active at every step while a member arises at
every step: the arising's dependence is needed. -/
theorem persists : web.Whole parts .lineage ∧ web.Listed parts Generations.alive ∧
    (∀ p, parts p → web.Ends p) ∧ flow.Balances web ∧ flow.Acting web ∧ web.Dependent ∧
    (∀ t f, f ∈ flow.present t → ∀ d, d ∈ [()] → 0 < flow.give t f d →
      ∃ e, e ∈ [()] ∧ web.requires t f e ∧ 1 ≤ web.need t f e) ∧
    (∀ k, k < 1 → flow.replenishment [()] (0 + k) < flow.uptake [()] (0 + k)) ∧
    web.stock [()] 0 < 1 + 1 ∧ (∀ t, web.active t .lineage) ∧
    ∀ t, web.Arises t (.member (t + 1)) :=
  ⟨Generations.whole, Generations.listed, Generations.ends, balances,
   fun _ _ _ _ gives => absurd gives (Nat.lt_irrefl 0), fun _ _ _ _ no => False.elim no,
   fun _ _ _ _ _ gives => absurd gives (Nat.lt_irrefl 0),
   fun k below => match k, below with
    | 0, _ => Nat.zero_lt_one
    | _ + 1, late => absurd late (Nat.not_lt_of_le (Nat.le_add_left 1 _)),
   Nat.lt_succ_self 1, fun _ => trivial, Generations.generations.2.2.2.2.2.1⟩

end WholeUngated

namespace Generations

/-- **The same parts, the two wholes.** A formation that is the whole of every member is active
at no step, while the lineage, the whole of some member, is active at every step (`generations`):
the member arising two steps on is not yet active. -/
theorem allWhole_never {v : Formation} (all : web.AllWhole parts v) (t : Nat) :
    ¬ web.active t v :=
  all.inactive_of_part (p := .member (t + 2)) trivial fun active => match active with
    | .inl same => Nat.ne_of_lt (Nat.lt_add_of_pos_right (Nat.succ_pos 1)) same
    | .inr same => Nat.ne_of_lt (Nat.lt_succ_of_lt (Nat.lt_add_of_pos_right (Nat.succ_pos 1))) same

end Generations

namespace Rafters

/-- Rafters, a house and what is left of it. -/
inductive Formation where
  | rafter (i : Nat)
  | house
  | remains

/-- Three rafters. -/
def rafters : List Formation := [.rafter 0, .rafter 1, .rafter 2]

/-- The first rafter is taken after the first step, the others stay; the house stands at the
first step only, what is left of it at every step. -/
def web : Web Formation Unit where
  level _ _ := 0
  active t f := match f with
    | .rafter i => t = 0 ∨ 0 < i
    | .house => t = 0
    | .remains => True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- The house is the whole of every rafter. -/
theorem house : web.AllWhole (· ∈ rafters) .house :=
  fun _ => ⟨fun first p mem => match p, mem with
      | _, .head _ => .inl first
      | _, .tail _ (.head _) => .inl first
      | _, .tail _ (.tail _ (.head _)) => .inl first
      | _, .tail _ (.tail _ (.tail _ no)) => (nomatch no),
    fun every => match every (.rafter 0) (.head _) with
      | .inl first => first
      | .inr stays => absurd stays (Nat.lt_irrefl 0)⟩

/-- What is left is the whole of some rafter. -/
theorem remains : web.Whole (· ∈ rafters) .remains :=
  fun _ => ⟨fun _ => ⟨.rafter 1, .tail _ (.head _), .inr (Nat.succ_pos 0)⟩, fun _ => trivial⟩

/-- Each formation's activity is decided at every step. -/
theorem decided : ∀ t f, Decided (web.active t f)
  | t, .rafter i => match Nat.decEq t 0 with
    | isTrue first => .inl (.inl first)
    | isFalse later => match Nat.decLt 0 i with
      | isTrue kept => .inl (.inr kept)
      | isFalse taken => .inr fun active => match active with
        | .inl first => later first
        | .inr kept => taken kept
  | t, .house => match Nat.decEq t 0 with
    | isTrue first => .inl first
    | isFalse later => .inr later
  | _, .remains => .inl trivial

/-- From the second step on, two of the three rafters are active. -/
theorem grade_two {t : Nat} (later : 0 < t) : web.Grade rafters t 2 :=
  ⟨0, 2, .inr ⟨fun active => match active with
      | .inl first => Nat.lt_irrefl 0 (Eq.subst (motive := (0 < ·)) first later)
      | .inr stays => Nat.lt_irrefl 0 stays, rfl⟩,
    ⟨1, 1, .inl ⟨.inr (Nat.succ_pos 0), rfl⟩, ⟨1, 0, .inl ⟨.inr (Nat.succ_pos 1), rfl⟩, rfl, rfl⟩,
      rfl⟩, rfl⟩

/-- **A rafter taken, no house.** The house of three rafters ceases across the first step, as the
first rafter does; from then on two of the three are active, the whole is diminished, what is
left stands and the house does not. -/
theorem taken :
    web.Ceases 0 .house ∧ web.Ceases 0 (.rafter 0) ∧
    ∀ t, 0 < t → web.Grade rafters t 2 ∧ web.Diminished rafters t ∧
      web.active t .remains ∧ ¬ web.active t .house :=
  ⟨⟨rfl, fun after => Nat.lt_irrefl 0 (Eq.subst (motive := (0 < ·)) after (Nat.succ_pos 0))⟩,
   ⟨.inl rfl, fun active => match active with
      | .inl first => Nat.lt_irrefl 0 (Eq.subst (motive := (0 < ·)) first (Nat.succ_pos 0))
      | .inr stays => Nat.lt_irrefl 0 stays⟩,
   fun t later =>
    have notHouse : ¬ web.active t .house :=
      fun first => Nat.lt_irrefl 0 (Eq.subst (motive := (0 < ·)) first later)
    ⟨grade_two later, (Web.diminished_iff remains house fun p _ => decided t p).mpr ⟨trivial, notHouse⟩,
     trivial, notHouse⟩⟩

end Rafters

end Becoming
