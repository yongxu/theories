#!/usr/bin/env python3
"""WE1: write the kit's Becoming.Wholes from the checkout's: the import of Becoming.Continuation, the law
below `Covered.needs_arising` (listed parts each ending, none arising from some step on, all end), that
law re-derived from it (board rule 9), the whole's ending without arising, the join with
`Flow.family_excess_ends` and its one-condition case, and the witnesses `WholeExceeding` and
`WholeWithin`; the module doc extended.
usage: python3 -B edit_wholes.py   (reads the package's Becoming/Wholes.lean, writes tree/Becoming/Wholes.lean;
each edit must match exactly once)"""
from pathlib import Path

HERE = Path(__file__).resolve().parent
PKG = HERE.parents[5] / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
s = (PKG / 'Becoming' / 'Wholes.lean').read_text()


def once(old, new):
    global s
    assert s.count(old) == 1, ('edit does not match once', old[:90], s.count(old))
    s = s.replace(old, new)


once('import Becoming.Identity\n', 'import Becoming.Identity\nimport Becoming.Continuation\n')

once('''`Layered` names both, with no relation saying that the lineage is constituted by its
members. This module states one part–whole relation, coincidence of activity, and proves
what it carries.
''', '''`Layered` names both, with no relation saying that the lineage is constituted by its
members. This module states one part–whole relation, coincidence of activity, and proves
what it carries, and, with `Becoming.Continuation`, what a draw on the conditions its parts
arise through does to a whole.
''')

once('''* A cover needs the generation of parts. If no part is active at two steps `d` apart, a
  part arises within every `d` consecutive steps (`Covered.arises_within`). If each part's
  activity ends and the active parts are listed, parts arise at arbitrarily late steps
  (`Covered.needs_arising`), and outside every finite list of parts: ever new parts
  (`Covered.needs_new`).''', '''* Without arising, ending parts end together. Parts each of whose activity ends, with the
  active ones listed, none arising from some step on, are all inactive from a later step
  (`Listed.end_without_arising`): a part active after that step was active at it, among
  the finitely many listed there. So a whole of such parts ends where none arises from some
  step on (`Whole.ends_without_arising`).
* A cover needs the generation of parts. If no part is active at two steps `d` apart, a
  part arises within every `d` consecutive steps (`Covered.arises_within`). If each part's
  activity ends and the active parts are listed, parts arise at arbitrarily late steps
  (`Covered.needs_arising`, from `Listed.end_without_arising`), and outside every finite
  list of parts: ever new parts (`Covered.needs_new`).
 ''')

once('''* `Layered`'s lineage is the whole of its members (`Layered.composed`). Its members are
  brief for one step, so one arises at every step (`Layered.brief`, `Layered.within`);
  every arising is of one of the two, whose activity does not end (`Layered.arise_again`).
''', '''* `Layered`'s lineage is the whole of its members (`Layered.composed`). Its members are
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
  (`WholeWithin.kept`), so the excess is needed. Without ending parts the whole may persist
  with nothing arising (`Immortal`), and without a finite listing (`Countless`); those
  witnesses bound this law as they bound `Whole.needs_arising`.
''')

once('''within it (DELEGATED-CHOICES D5). No ethical predicate, ranking or axiom occurs.
''', '''within it (DELEGATED-CHOICES D5). That a collective is the whole of its lives, that what it
draws on is what its lives arise through, and that the joint draw is its consuming are readings
(OPENING note `collective`). No ethical predicate, ranking or axiom occurs.
''')

once('''/-- Parts covering the steps from some step on, each of whose activity ends, with the
active ones listed, arise at arbitrarily late steps. -/
theorem Covered.needs_arising {T : Nat} {alive : Nat → List F} (covered : W.Covered parts T)
    (listed : W.Listed parts alive) (ends : ∀ p, parts p → W.Ends p) (N : Nat) :
    ¬ ∀ t, N ≤ t → ∀ p, parts p → ¬ W.Arises t p :=
  fun quiet => match Ends.all (l := alive (N + T)) fun p mem => ends p ((listed _ p).mp mem).1 with
  | ⟨M, gone⟩ =>
    match covered (N + T + M) (Nat.le_trans (Nat.le_add_left T N)
        (Nat.le_add_right (N + T) M)) with
    | ⟨p, part, active⟩ =>
      active_back (fun j _ p part => quiet (N + T + j)
          (Nat.le_trans (Nat.le_add_right N T) (Nat.le_add_right (N + T) j)) p part) part
        active fun before => gone p ((listed _ p).mpr ⟨part, before⟩) (N + T + M)
          (Nat.le_add_left M (N + T)) active
''', '''/-- Parts each of whose activity ends, with the active ones listed, none arising from `N` on,
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
''')

once('''  (whole.covered persists).needs_new listed ends within N

end Web
''', '''  (whole.covered persists).needs_new listed ends within N

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
''')

once('''end Layered

end Becoming
''', '''end Layered

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

end Becoming
''')

once('''  (`WholeWithin.kept`), so the excess is needed. Without ending parts the whole may persist
  with nothing arising (`Immortal`), and without a finite listing (`Countless`); those
  witnesses bound this law as they bound `Whole.needs_arising`.
''', '''  (`WholeWithin.kept`), so the excess is needed. With a part that never ends, the whole
  persists through the same excess (`WholeUnending.persists`); with members arising without
  depending on the drawn condition, it persists while members keep arising
  (`WholeUngated.persists`). So the excess, ending parts and the arising's dependence are
  each needed; that the gate on renewal and the finite listing are needed for this law is not
  shown here.
''')

once('''end WholeWithin

end Becoming
''', '''end WholeWithin

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
''')

out = HERE / 'tree' / 'Becoming' / 'Wholes.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(s)
print('written', out, len(s.splitlines()), 'lines')
