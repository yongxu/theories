import Becoming.Identity
import Becoming.Continuation

/-!
# Wholes: a persisting whole of brief parts, or of ending listed parts, needs their generation

`Becoming.Identity` names a lineage either as one formation or as its members (`Lineage`).
`Layered` names both, with no relation saying that the lineage is constituted by its
members. This module states one part–whole relation, coincidence of activity, and proves
what it carries, and, with `Becoming.Continuation`, what a draw on the conditions its parts
arise through does to a whole.

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

Which formations are parts of which, and whether a lineage is read as the whole of its
members, are representational choices. On Ren's delegation of 15 October 2026 生生不息 is read at
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

end Becoming
