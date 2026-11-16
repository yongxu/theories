import Becoming.LineOnAStock
import Becoming.LineageDrawdown

/-!
# A line on a stock: two built examples with its sizes and levels

AI-written, 16 November 2026.

Two examples built in other modules have the sizes and levels of a course of `LineOnAStock`'s model,
by equalities with their own definitions, step by step, and on each such course the premises of a law
of `LineOnAStock` hold: `way_ends` on the first, `fall` on the second. That is what is shown. The law's
conclusion, read back through the equalities, gives nothing about the example that its own Lean did
not already give: each ending conjunct already follows from the example's own Lean, and an equality
it is read back through takes that Lean as input: the activity at step 2 on the first, the sizes from
step 10 on the second.

* `LineageRegimes.MultiplyingTakers` (`MultiplyingTakersCase`): the doubling unit (`LineOnAStock.Doubling`)
  with nothing given, from one unit at three. The sizes of its family, its pool and whether some member
  is active are this course's lengths, levels and whether some need is met, and the premises of
  `LineOnAStock.way_ends` hold on this course. Read back, `way_ends` gives a step at which no member of
  the family is active; the example's own `LineageRegimes.MultiplyingTakers.inactive` gives that at
  step 2, and the equality of activity at step 2 is proved from it.
* `LineageDrawdown.Drain`, gated (`DrainCase`): a restrained member and two drawers. The sizes of its
  family, its pool with the renewer's gift on it, the total of its draws and the renewer's gift are
  this course's lengths, levels, what the way takes and `gift`, and the premises of
  `LineOnAStock.fall` hold at the line of the drawers from step 1. Read back, `fall` gives a step from
  which the family is empty; the example's own `LineageDrawdown.Drain.familyP_eq`, with `familyP`'s
  definition, gives that from step 10, and the size equality from step 10 is proved from it.

What is equated is said at each; organisms' identities are not. `ReadingsSpread.Commons` was not
tried.

Every declaration has an empty axiom report.
-/

namespace Becoming
namespace LineOnAStock

namespace MultiplyingTakersCase

/-- From step 3 on, the course of the doubling unit from `([()], 3)` with nothing given is
`([], 0)`. -/
theorem late : ∀ t, course Doubling.need Doubling.kids nothingGiven Doubling.use ([()], 3) (t + 3) =
    ([], 0)
  | 0 => rfl
  | t + 1 => congrArg (step Doubling.need Doubling.kids nothingGiven Doubling.use) (late t)

/-- From step 3 on, the family of `LineageRegimes.MultiplyingTakers.generations` is empty. -/
theorem family_late : ∀ t, (LineageRegimes.MultiplyingTakers.generations.family (t + 3)) = []
  | 0 => rfl
  | t + 1 => congrArg (fun l => l.flatMap (LineageRegimes.MultiplyingTakers.generations.kids (t + 3)))
      (family_late t)

/-- **`LineageRegimes.MultiplyingTakers` has the sizes, pool and activity of this model's course for
the doubling unit.** With one kind needing one, taking one and leaving two copies (`Doubling`), nothing
given, from `([()], 3)`: at every step the size of the built example's family is the length of the way
here, its pool (`web.level t 0`) is the level here, and some member of its family is active exactly
where some need is met here. By computation at steps 0 to 2 (families of 1, 2, 4 members on a pool of
3, 2, 0; at step 2 by the example's own `inactive`), and from step 3 both are empty (`late`,
`family_late`). -/
theorem agree (t : Nat) :
    (LineageRegimes.MultiplyingTakers.generations.family t).length =
        (course Doubling.need Doubling.kids nothingGiven Doubling.use ([()], 3) t).1.length ∧
      LineageRegimes.MultiplyingTakers.web.level t 0 =
        (course Doubling.need Doubling.kids nothingGiven Doubling.use ([()], 3) t).2 ∧
      ((∃ p, p ∈ LineageRegimes.MultiplyingTakers.generations.family t ∧
          LineageRegimes.MultiplyingTakers.web.active t p) ↔
        Goes Doubling.need (course Doubling.need Doubling.kids nothingGiven Doubling.use ([()], 3) t)) :=
  match t with
  | 0 => ⟨rfl, rfl, ⟨fun _ => by decide, fun _ => ⟨1, .head _, .head _⟩⟩⟩
  | 1 => ⟨rfl, rfl, ⟨fun _ => by decide, fun _ => ⟨2, .head _, .head _⟩⟩⟩
  | 2 => ⟨rfl, rfl, ⟨fun ⟨p, _, act⟩ => absurd act (LineageRegimes.MultiplyingTakers.inactive p),
      fun g => absurd g (by decide)⟩⟩
  | t + 3 =>
    ⟨(congrArg List.length (family_late t)).trans (congrArg (fun s => s.1.length) (late t)).symm,
     (congrArg Prod.snd (late t)).symm,
     ⟨fun ⟨_, mp, _⟩ => (nomatch (Eq.subst (motive := fun l => _ ∈ l) (family_late t) mp)),
      fun ⟨_, mu, _⟩ => (nomatch (Eq.subst (motive := fun s : List Unit × Nat => _ ∈ s.1) (late t) mu))⟩⟩

/-- **`LineageRegimes.MultiplyingTakers` has the sizes, pool and activity of a course of this model on
which the premises of `way_ends` hold.** The first conjunct is `agree` at every step. On the course
here the premises of `way_ends` hold with `hi = 3` (checked where the law is applied in the proof; they
are not conjuncts of this statement): nothing given from nothing, the step under no draw
keeping every level up to three within three, the unit's kids taking two, more than its one, its need
positive, its kids needing what it needs, the start three. Its conclusion, a step at which no need is
met here, read back through `agree`, is the second conjunct, a step at which no member of the built
example's family is active; the third is that the net here ends. The second conjunct gives nothing
about the example that its own Lean did not: `agree` at step 2 is proved from the example's own
`LineageRegimes.MultiplyingTakers.inactive`, which is that conjunct at step 2. The step is not
bounded, and the example's own stop statement (that not every member of its first three families is
active at its step) is not concluded here. -/
theorem multiplying_takers :
    (∀ t, (LineageRegimes.MultiplyingTakers.generations.family t).length =
        (course Doubling.need Doubling.kids nothingGiven Doubling.use ([()], 3) t).1.length ∧
      LineageRegimes.MultiplyingTakers.web.level t 0 =
        (course Doubling.need Doubling.kids nothingGiven Doubling.use ([()], 3) t).2 ∧
      ((∃ p, p ∈ LineageRegimes.MultiplyingTakers.generations.family t ∧
          LineageRegimes.MultiplyingTakers.web.active t p) ↔
        Goes Doubling.need (course Doubling.need Doubling.kids nothingGiven Doubling.use ([()], 3) t))) ∧
    (∃ t, ¬ ∃ p, p ∈ LineageRegimes.MultiplyingTakers.generations.family t ∧
      LineageRegimes.MultiplyingTakers.web.active t p) ∧
    ¬ «不穷» (net Doubling.need Doubling.kids nothingGiven Doubling.use) «一» ([()], 3) :=
  match way_ends (need := Doubling.need) (kids := Doubling.kids) (use := Doubling.use)
      (giving := nothingGiven) (hi := 3) rfl (RegimeMargin.keeps_of_below rfl)
      (fun _ => (by decide : 1 < 2)) (fun _ => (by decide : 0 < 1)) (fun _ _ _ => Nat.le_refl 1)
      (Nat.le_refl 3) with
  | ⟨⟨n, stop⟩, ends⟩ => ⟨agree, ⟨n, fun act => stop ((agree n).2.2.mp act)⟩, ends⟩

end MultiplyingTakersCase

namespace DrainCase

/-- Three kinds: a restrained member `r` and two drawers `d0`, `d1`. -/
inductive Kind
  | r
  | d0
  | d1

open Kind

/-- Every kind needs four. -/
def need (_ : Kind) : Nat := 4

/-- `r` takes one, `d0` and `d1` two. -/
def use : Kind → Nat
  | r => 1
  | d0 => 2
  | d1 => 2

/-- `r` leaves nothing, `d0` leaves `d1, d1`, `d1` leaves `d1`. -/
def kids : Kind → List Kind
  | r => []
  | d0 => [d1, d1]
  | d1 => [d1]

/-- The renewer's gift: three from one up, nothing at nothing. -/
def gift : Nat → Nat
  | 0 => 0
  | _ + 1 => 3

/-- The drawers. -/
def isD : Kind → Bool
  | r => false
  | d0 => true
  | d1 => true

/-- From step 10 on, the course from `([r, d0], 11)` is `([], 0)`. -/
theorem late : ∀ t, course need kids gift use ([r, d0], 11) (t + 10) = ([], 0)
  | 0 => rfl
  | t + 1 => congrArg (step need kids gift use) (late t)

/-- `gift` is the gated renewer's giving in `LineageDrawdown.Drain`: what it gives the pool at a
phase is `gift` of the pool there. -/
theorem gift_eq (φ : LineageDrawdown.Drain.Phase) (k : Nat → List Nat) :
    LineageDrawdown.Drain.giveOf true φ k 1 0 = gift (LineageDrawdown.Drain.levelOf φ 0) :=
  match φ with
  | ⟨0, _⟩ => rfl
  | ⟨p + 1, _⟩ => congrArg (fun b => bif b then 3 else 0)
      (decide_eq_true (Nat.succ_le_succ (Nat.zero_le p) : 1 ≤ p + 1))

/-- For every pool `p`, `p` with `gift p` on it is at least four exactly where `p` is at least one: a
level here, the pool with `gift` on it, meets the need four exactly where the pool is at least one. No
term of `LineageDrawdown.Drain` is in this statement: that Drain's own need is one is read from its
source, not stated here. -/
theorem need_agrees : ∀ p, 4 ≤ p + gift p ↔ 1 ≤ p
  | 0 => ⟨fun h => absurd h (by decide), fun h => absurd h (by decide)⟩
  | p + 1 => ⟨fun _ => Nat.succ_pos p, fun _ => Nat.le_add_left 4 p⟩

/-- A list all of whose members are drawers and none of whose members is a drawer is empty. -/
theorem empty_of {l : List Kind} (all : ∀ u, u ∈ l → isD u = true) (none : ∀ u, u ∈ l → ¬ isD u = true) :
    l = [] :=
  match l, all, none with
  | [], _, _ => rfl
  | v :: _, all, none => absurd (all v (.head _)) (none v (.head _))

/-- **`LineageDrawdown.Drain`, gated, has the sizes, draws and levels of a course of this model for
`r`, `d0`, `d1` on which the premises of `fall` hold at the line of the drawers.** Equated, at every
step: the size of the built example's family (`generations (courseP true)`) with the length of the
way here; its pool
(`web.level t 0`) with the gift on it with the level here; the total of its draws
(`generations.sum`, its amounts being `draw`) with what the way here takes; and the renewer's giving
with `gift` of the pool (`gift_eq`). Not equated: the organisms (numbered `5, 6` and `7, 8` in turn
there, kinds here), and the need, four here against one there: a level here, the pool with three on
it from one up, meets four exactly where the pool meets one (`need_agrees`, the third conjunct, in
which no term of `Drain` appears; Drain's need one is read from its source, not stated here). By
computation to step 9 and both empty from step 10 (`late`, `LineageDrawdown.Drain.familyP_eq`).
The premises of `fall` hold at the line of the drawers (checked where the law is applied in the proof,
not conjuncts of this statement: closed; one need, four; kids taking no less;
the gift at nothing below four; from step 1, `([d1, d1], 11)`, taking four, more than every gift); its
conclusion, a step from which no drawer is in the way, with every unit here a drawer from step 1
(`never_in` at the units that are not: `r` leaves nothing and drawers leave drawers), makes the way
empty from there, and read back through the size equality, the last conjunct, a step from which the
built example's family is empty. That conjunct gives nothing about the example that its own Lean did
not: the size equality from step 10 is proved from `LineageDrawdown.Drain.familyP_eq`, which with
`familyP`'s own definition already gives the family empty from step 10. `fall` does not bound the step. -/
theorem drain :
    (∀ t, ((LineageDrawdown.Drain.generations (LineageDrawdown.Drain.courseP true)).family t).length =
        (course need kids gift use ([r, d0], 11) t).1.length ∧
      (LineageDrawdown.Drain.web true (LineageDrawdown.Drain.courseP true)).level t 0 +
          gift ((LineageDrawdown.Drain.web true (LineageDrawdown.Drain.courseP true)).level t 0) =
        (course need kids gift use ([r, d0], 11) t).2 ∧
      (LineageDrawdown.Drain.generations (LineageDrawdown.Drain.courseP true)).sum t =
        taken use (course need kids gift use ([r, d0], 11) t).1) ∧
    (∀ t, (LineageDrawdown.Drain.flow true (LineageDrawdown.Drain.courseP true)).give t 1 0 =
      gift ((LineageDrawdown.Drain.web true (LineageDrawdown.Drain.courseP true)).level t 0)) ∧
    (∀ p, 4 ≤ p + gift p ↔ 1 ≤ p) ∧
    ∃ n, ∀ k, n ≤ k → (LineageDrawdown.Drain.generations (LineageDrawdown.Drain.courseP true)).family k = [] :=
  have sizes : ∀ t,
      ((LineageDrawdown.Drain.generations (LineageDrawdown.Drain.courseP true)).family t).length =
        (course need kids gift use ([r, d0], 11) t).1.length ∧
      (LineageDrawdown.Drain.web true (LineageDrawdown.Drain.courseP true)).level t 0 +
          gift ((LineageDrawdown.Drain.web true (LineageDrawdown.Drain.courseP true)).level t 0) =
        (course need kids gift use ([r, d0], 11) t).2 ∧
      (LineageDrawdown.Drain.generations (LineageDrawdown.Drain.courseP true)).sum t =
        taken use (course need kids gift use ([r, d0], 11) t).1 := fun t => match t with
    | 0 => ⟨rfl, rfl, rfl⟩ | 1 => ⟨rfl, rfl, rfl⟩ | 2 => ⟨rfl, rfl, rfl⟩ | 3 => ⟨rfl, rfl, rfl⟩
    | 4 => ⟨rfl, rfl, rfl⟩ | 5 => ⟨rfl, rfl, rfl⟩ | 6 => ⟨rfl, rfl, rfl⟩ | 7 => ⟨rfl, rfl, rfl⟩
    | 8 => ⟨rfl, rfl, rfl⟩ | 9 => ⟨rfl, rfl, rfl⟩
    | t + 10 =>
      ⟨(congrArg List.length (LineageDrawdown.Drain.familyP_eq true (t + 10))).trans
          (congrArg (fun s => s.1.length) (late t)).symm,
       (congrArg Prod.snd (late t)).symm,
       (congrArg (fun l => total l LineageDrawdown.Drain.draw)
          (LineageDrawdown.Drain.familyP_eq true (t + 10))).trans
         (congrArg (fun s : List Kind × Nat => taken use s.1) (late t)).symm⟩
  have drawers : ∀ j u, u ∈ (course need kids gift use ([d1, d1], 11) j).1 → ¬ isD u = false :=
    never_in (need := need) (kids := kids) (use := use) (giving := gift) (S := fun u => isD u = false)
      (fun u v mv h => match u, v, mv, h with
        | r, _, mv, _ => nomatch mv
        | d0, _, .head _, h => absurd h.symm Bool.false_ne_true
        | d0, _, .tail _ (.head _), h => absurd h.symm Bool.false_ne_true
        | d0, _, .tail _ (.tail _ m), _ => nomatch m
        | d1, _, .head _, h => absurd h.symm Bool.false_ne_true
        | d1, _, .tail _ m, _ => nomatch m)
      (fun u mu => match u, mu with
        | _, .head _ => fun e => Bool.false_ne_true e.symm
        | _, .tail _ (.head _) => fun e => Bool.false_ne_true e.symm
        | _, .tail _ (.tail _ m) => nomatch m)
  match fall (need := need) (kids := kids) (use := use) (giving := gift)
      (S := fun u => isD u = true) (m := 4) (w := [d1, d1]) (x := 11)
      (fun u _ mv _ => match u, mv with
        | r, mv => nomatch mv
        | d0, _ => rfl
        | d1, _ => rfl)
      (fun _ _ => rfl)
      (fun u su => match u, su with
        | r, su => absurd su Bool.false_ne_true
        | d0, _ => by decide
        | d1, _ => by decide)
      (by decide)
      (fun z => match z with
        | 0 => by decide
        | _ + 1 => (by decide : 3 < 4)) with
  | ⟨n, gone⟩ =>
    ⟨sizes, fun t => gift_eq (LineageDrawdown.Drain.phaseP true t) (LineageDrawdown.Drain.kidsP t),
      need_agrees, 1 + n, fun k le => match le_dest le with
      | ⟨i, e⟩ =>
        have empty : (course need kids gift use ([d1, d1], 11) (n + i)).1 = [] :=
          empty_of (fun u mu => match u, drawers (n + i) u mu with
              | r, h => absurd rfl h
              | d0, _ => rfl
              | d1, _ => rfl)
            (gone (n + i) (Nat.le_add_right n i))
        have here : (course need kids gift use ([r, d0], 11) k).1 = [] :=
          Eq.subst (motive := fun j => (course need kids gift use ([r, d0], 11) j).1 = [])
            ((Nat.add_assoc 1 n i).symm.trans e.symm)
            ((congrArg Prod.fst (Law.orbit_add (step need kids gift use) ([r, d0], 11) 1 (n + i))).trans
              empty)
        nil_of_length_zero ((sizes k).1.trans (congrArg List.length here))⟩

end DrainCase

end LineOnAStock
end Becoming
