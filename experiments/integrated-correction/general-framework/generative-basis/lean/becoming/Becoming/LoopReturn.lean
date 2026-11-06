import Becoming.Frequency
import Becoming.Lasting
import Becoming.Prelude
import Becoming.Rejoining

/-!
# LoopReturn: whether a loop closes, keeps or widens a difference

`Becoming.Rejoining` (M4) shows that a difference between two courses closes only through a
response, and, citing `Becoming.PoolResponse`, where they are proved, that a response closing a
difference and one widening it share the structure of a loop through another's coupling and
response (`Loop.response_returns`); which of the two a loop does is left to the law followed
(`ExchangeLaw.response_not_fixed_by_coupling`). This module
states which return laws close, keep or widen a difference, with no premise beyond the hypotheses
each statement names.

A difference is a natural number. One turn around a loop sends a difference into the first link,
each link gives on what it receives to the next, and the last gives it back: a link is a map
`Nat → Nat`, and a loop of links `links` has the return map `LoopReturn.returnMap links`, the first
link applied first. The course of the difference is the run of the return map,
`(Law.run f d).state n`, a run of the spine whose states are the orbit `Law.orbit f d n`
(`Becoming.Recurrence`, `Law.run_state`), the difference after `n` turns from `d`. The difference
is one number: the gap at one condition between Rejoining's two courses, which follows a return
map exactly where the courses' exchanges respond to that gap by a map (the last section). A link's
*factor* is what one turn makes of the difference it receives; a *strength* is only a coupling
strength of `Becoming.Propagation`, and around a cycle the product of the coupling strengths
(`Loops.product`). The later sections join the two.

* **A return map giving back what it receives keeps a difference.** Such a return map keeps
  `d` at every turn (`LoopReturn.kept_of_identity`), and so does a loop each of whose links gives on
  exactly what it receives (`LoopReturn.loop_kept`).
* **Closing needs a link that gives back less than it received.** Where every link gives on at
  least what it receives, the difference after every turn is at least `d`
  (`LoopReturn.never_closes_of_no_less`). So where the course falls below `d` at some turn, some link
  of the loop gives on, for some difference, less than it received (`LoopReturn.closing_needs_less`);
  the link and the difference are found, nothing being decided beyond the order of numbers.
* **A return map below what it receives closes within `d` turns.** Where `f 0 = 0` and `f x < x`
  for every positive `x`, the course is `0` at turn `d` and at every turn from then on
  (`LoopReturn.closes_within`), and the bound is exact: under `Nat.pred`, which meets both
  hypotheses, the course is positive before turn `d` (`LoopReturn.closes_within_exact`). This is an
  instance of the reaching law with a numeric variant (`Lasting.Variant.reaches`, read on the orbit
  by `Lasting.reaches_iff_orbit`): the difference itself is the variant for the target `0`. A
  loop that closes a positive difference merges two differences, a positive one and `0`, at the
  turn before it closes (`LoopReturn.closing_merges`, the turn found by searching the turns, where
  equality of numbers is decided), so its return map is not lossless
  (`LoopReturn.closing_not_lossless`): the two go on as one at every later turn (`Law.merged_stays`),
  and within finitely many differences the merge loses a possibility for good (`Law.Merges.loses`).
* **Taking a constant off closes, gradually where the constant is below the difference.** A return
  map giving back `c` less than it receives (`f x = x - c`) leaves `d - n * c` after `n` turns
  (`LoopReturn.orbit_sub_const`): the course is `0` once `n * c ≥ d` (`LoopReturn.sub_const_closes`)
  and positive while `n * c < d` (`LoopReturn.sub_const_open`), so the closing turn is the least `n`
  with `n * c ≥ d`. With `c = 0` nothing closes, and with `c ≥ d` the difference closes in one
  turn.
* **A cut closes at once, where what follows it gives nothing for nothing.** A link returning
  nothing makes the difference `0` from the first turn, whatever the links before it, where every
  link after it gives on no difference where it receives none (`LoopReturn.cut_closes`). The
  condition on the links after the cut is needed: in the loop of a cut followed by `Nat.succ`, the
  difference is `1` at every turn after the first, whatever it was (`LoopReturn.cut_reopened`).
* **Monotone return maps settle or rise.** Where `f` keeps order and `f d ≤ d`, the course never
  rises (`LoopReturn.never_rises`, from `Lasting.orbit_mono`: a monotone map keeps order along its
  orbits) and settles within `d` turns at a value `v` with `f v = v`, staying
  there (`LoopReturn.settles_within`); the bound `d` is exact, by `Nat.pred`
  (`LoopReturn.settles_within_exact`, `Nat.pred` meeting both hypotheses). Where `f` keeps order and
  `d ≤ f d`, the course never falls (`LoopReturn.never_falls`, again from `Lasting.orbit_mono`).
* **Doubling links run away.** Where a loop has at least one link and every link gives on at least
  twice what it receives, the difference after `n` turns is at least `2 ^ n * d`
  (`LoopReturn.runs_away`), exceeding every bound from a positive start
  (`LoopReturn.runs_away_unbounded`); the loop of one doubling link meets the hypothesis and attains
  `2 ^ n * d` exactly (`LoopReturn.doubling_exact`). An empty loop gives back what it receives, so
  the link is needed (`LoopReturn.empty_loop_kept`). This runs parallel to `Becoming.Frequency`'s
  doubling at every return, with no instance theorem between them (`carried_doubles_roundTrip`, `carried_roundTrip`): there a return doubles what had
  reached a condition because it arrives once held and once around the loop, and
  `runaway_of_roundTrip` turns doubling at returns that come often enough into outgrowing every
  polynomial in the steps. Here the doubling is a property of each link, and the count is of
  turns, not of steps; how many steps a turn takes is what `Becoming.Frequency` adds.
* **Whole-number factors have nothing between.** In a loop of links multiplying by whole-number
  factors (`LoopReturn.scaling`), the return map multiplies by the product of the factors
  (`LoopReturn.returnMap_scaling`, `LoopReturn.orbit_scaling`). With product `0` the difference closes
  at the first turn, with product `1` it is kept at every turn, and with product at least `2` it
  exceeds every bound from a positive start (`LoopReturn.whole_factors`). So no such loop closes a
  difference gradually: at every turn the course is `0` or no less than at the turn before
  (`LoopReturn.nothing_between`), while taking one off, from `2`, leaves `1` after one turn
  (`LoopReturn.gradual_needs_another_link`). With whole-number factors, a loop that closes
  gradually needs a link that is not a multiplication.
* **The return map is the carried amount of `Becoming.Loops`.** For one condition returning its
  current level to itself with coupling strength `M` (`Loops.SelfLoop.strengths`), the carried
  amount from a starting gap `D` is, at every step, the course from `D` of the loop of one link with
  factor `1 + M`, one turn a step (`LoopReturn.selfLoop_carried`, through
  `LoopReturn.geomBound_eq_course`). The carried amount is attained by the course the carrying law
  generates, against the quiet course (`carried_attained`), so where the actual response attains the
  carrying bound the gap itself is that course (`LoopReturn.selfLoop_gap`). Around every cycle of
  `m + 1` couplings holding at every step, the carried amount after `R` times around is at least the
  course after `R` turns of the loop of one link with factor one plus the product of the coupling
  strengths around the cycle (`LoopReturn.carried_around_course`, from `carried_runaway`). The one is
  the holding: the carrying law takes nothing, so a condition keeps what it had while the cycle
  returns more. A positive whole-number strength gives a factor of at least `2`, the doubling of
  `carried_doubles_around`.
* **Around a cycle of several conditions, exactly.** Where each link gives into the next condition
  exactly its strength times the current level, and nothing else is given there
  (`LoopReturn.GivesExactly`), one turn is exact: the carried amount at the loop one turn after `t`
  is the product of the strengths times what the loop held at `t`, with what the loop held at
  `t + m` and the last strength times what the intermediate conditions held as the turn passed
  them, carried on (`LoopReturn.heldAlong`; `LoopReturn.carried_along_exact`,
  `LoopReturn.carried_around_exact`). So it is the return map's course after one turn with what
  the loop gained over the turn's first `m` steps and what the intermediate conditions give
  (`LoopReturn.carried_around_excess`), and it equals that course exactly where both are nothing
  (`LoopReturn.around_course_iff`). On a ring of `m + 2` conditions with a positive strength `w`,
  every condition starting at a positive `D` (`LoopReturn.Ring`), each condition grows as a
  self-loop of strength `w` would, `(1 + w) ^ t * D` (`LoopReturn.ring_even`,
  `LoopReturn.Ring.amount_eq`), and `(1 + w ^ (m + 2)) * D < (1 + w) ^ (m + 2) * D`
  (`LoopReturn.one_add_pow_lt`): the bound of `carried_around_course` holds and is strict
  (`LoopReturn.Ring.bound_strict`). For one condition the two agree (`LoopReturn.selfLoop_carried`).
* **A difference at one condition of `Becoming.Rejoining` as a return map.** Where two flows
  balance on a condition and, from step `s`, their exchanges respond to the gap between the two
  courses by a map `f` (`LoopReturn.RespondsByReturn`: each course's level with what it gives and
  what the other takes stand at `f` of the gap), the gap at `s + n` is `f`'s course after `n` turns,
  one turn a step (`LoopReturn.gap_course`, from `LoopReturn.gap_succ`); the premise is exactly
  that the gap after each step is `f` of the gap before (`LoopReturn.responds_iff`). A response linear in the
  gap is a loop of multiplying links: the gap is the product of the factors to the `n` times the
  gap at `s` (`LoopReturn.gap_scaling`), so `whole_factors` applies. In Rejoining's witness the
  responder's exchange responds by taking one off from the act on
  (`LoopReturn.replenishing_responds`, `LoopReturn.replenishing_course`); from the start, across
  the act, the gap `0, 1, 0, 0` is the course of no map (`LoopReturn.replenishing_no_return`): the
  act opens a difference from none, which is not a response to the difference.

What is not derived: which return law a loop follows, which the laws above take as given, as
`Becoming.Rejoining` leaves the response to the law followed; that a difference is one number,
rather than many differences at many conditions; how many steps a turn takes (`Becoming.Frequency`);
the carried amount around a cycle of more than one condition where links read more than one level
or other conditions give into the cycle (the exact turn above takes each link to be the only
giving, at exactly its strength; otherwise the bound is what holds); that the exchanges of
Rejoining's courses respond to the gap by a map, which `RespondsByReturn` takes as given; and which
of keeping, closing or widening a difference supports the generation of life in the whole, which
goes through the comparison and the condition of the chapter's §6.4.
-/

namespace Becoming

namespace LoopReturn

/-! ## Loops of links -/

/-- The return map of a loop of links: the difference that comes back after one turn for the
difference sent, the first link applied first. -/
def returnMap : List (Nat → Nat) → Nat → Nat
  | [], x => x
  | g :: gs, x => returnMap gs (g x)

/-- The links that multiply by whole-number factors. -/
def scaling (as : List Nat) : List (Nat → Nat) := as.map (fun a x => a * x)

/-- The product of the factors. -/
def factor : List Nat → Nat
  | [] => 1
  | a :: as => a * factor as

/-- A course at a value the return map keeps stays there. -/
theorem orbit_of_fixed {f : Nat → Nat} {v : Nat} (fixed : f v = v) : ∀ n, (Law.run f v).state n = v
  | 0 => rfl
  | n + 1 => (congrArg f (orbit_of_fixed fixed n)).trans fixed

/-- A course that reaches a value the return map keeps stays there. -/
theorem stays_from_fixed {f : Nat → Nat} {d k : Nat} (fixed : f ((Law.run f d).state k) = (Law.run f d).state k)
    {n : Nat} (le : k ≤ n) : (Law.run f d).state n = (Law.run f d).state k := by
  induction le with
  | refl => exact rfl
  | step _ ih => exact (congrArg f ih).trans fixed

/-- A number added to `b` and staying within `b` is `0`. -/
theorem eq_zero_of_add_le : ∀ {a b : Nat}, a + b ≤ b → a = 0
  | _, 0, le => Nat.eq_zero_of_le_zero le
  | _, _ + 1, le => eq_zero_of_add_le (Nat.le_of_succ_le_succ le)

/-- One raised to every exponent is one. -/
theorem one_pow : ∀ n, 1 ^ n = 1
  | 0 => rfl
  | n + 1 => (Nat.pow_succ 1 n).trans ((Nat.mul_one _).trans (one_pow n))

/-! ## Keeping -/

/-- **A return map giving back what it receives keeps a difference** at every turn. -/
theorem kept_of_identity {f : Nat → Nat} (same : ∀ x, f x = x) (d : Nat) :
    ∀ n, (Law.run f d).state n = d :=
  orbit_of_fixed (same d)

/-- A loop each of whose links gives on exactly what it receives gives back what it receives. -/
theorem returnMap_of_identity : ∀ {links : List (Nat → Nat)},
    (∀ g, g ∈ links → ∀ x, g x = x) → ∀ x, returnMap links x = x
  | [], _, _ => rfl
  | g :: gs, same, x =>
    (returnMap_of_identity (fun h m => same h (List.Mem.tail g m)) (g x)).trans
      (same g (List.Mem.head gs) x)

/-- **A loop each of whose links gives on what it receives keeps a difference.** -/
theorem loop_kept {links : List (Nat → Nat)} (same : ∀ g, g ∈ links → ∀ x, g x = x) (d : Nat) :
    ∀ n, (Law.run (returnMap links) d).state n = d :=
  kept_of_identity (returnMap_of_identity same) d

/-! ## Closing needs a link that gives back less -/

/-- A loop each of whose links gives on at least what it receives gives back at least what it
receives. -/
theorem returnMap_ge : ∀ {links : List (Nat → Nat)},
    (∀ g, g ∈ links → ∀ x, x ≤ g x) → ∀ x, x ≤ returnMap links x
  | [], _, x => Nat.le_refl x
  | g :: gs, up, x =>
    Nat.le_trans (up g (List.Mem.head gs) x)
      (returnMap_ge (fun h m => up h (List.Mem.tail g m)) (g x))

/-- A return map giving back at least what it receives never takes the course below its start:
`never_falls_over` (`Becoming.Recurrence`) read on the orbit, from turn `0`. -/
theorem orbit_ge_of_ge {f : Nat → Nat} (up : ∀ x, x ≤ f x) (d : Nat) (n : Nat) :
    d ≤ (Law.run f d).state n :=
  Nat.le_trans (never_falls_over (q := id) (g := (Law.run f d).state) (fun _ => up _) 0 n)
    (Nat.le_of_eq (congrArg ((Law.run f d).state) (Nat.zero_add n)))

/-- **Where every link gives on at least what it receives, no turn closes any of the difference.**
The difference after every turn is at least the difference sent. -/
theorem never_closes_of_no_less {links : List (Nat → Nat)}
    (up : ∀ g, g ∈ links → ∀ x, x ≤ g x) (d : Nat) :
    ∀ n, d ≤ (Law.run (returnMap links) d).state n :=
  orbit_ge_of_ge (returnMap_ge up) d

/-- A course that falls below its start passes a difference the return map gives back less of. -/
theorem below_of_falls {f : Nat → Nat} {d : Nat} :
    ∀ {n : Nat}, (Law.run f d).state n < d → ∃ y, f y < y
  | 0, lt => absurd lt (Nat.lt_irrefl d)
  | n + 1, lt =>
    match Nat.lt_or_ge (f ((Law.run f d).state n)) ((Law.run f d).state n) with
    | Or.inl less => ⟨_, less⟩
    | Or.inr ge => below_of_falls (Nat.lt_of_le_of_lt ge lt)

/-- A loop that gives back less than it received has a link that gives on less than it
received. -/
theorem link_below_of_below : ∀ {links : List (Nat → Nat)} {x : Nat},
    returnMap links x < x → ∃ g, g ∈ links ∧ ∃ y, g y < y
  | [], _, lt => absurd lt (Nat.lt_irrefl _)
  | g :: gs, x, lt =>
    match Nat.lt_or_ge (g x) x with
    | Or.inl less => ⟨g, List.Mem.head gs, x, less⟩
    | Or.inr ge =>
      match link_below_of_below (links := gs) (x := g x) (Nat.lt_of_lt_of_le lt ge) with
      | ⟨h, m, y, less⟩ => ⟨h, List.Mem.tail g m, y, less⟩

/-- **Closing needs a link that gives back less than it received.** Where the course of a loop
falls below the difference sent at some turn (in particular, where it closes a positive
difference), some link of the loop gives on, for some difference, less than it received. -/
theorem closing_needs_less {links : List (Nat → Nat)} {d n : Nat}
    (falls : (Law.run (returnMap links) d).state n < d) : ∃ g, g ∈ links ∧ ∃ x, g x < x :=
  match below_of_falls falls with
  | ⟨_, less⟩ => link_below_of_below less

/-! ## A return map below what it receives -/

/-- **The difference is a variant for closing.** Where `f x < x` for every positive `x`, the
difference itself is a numeric variant (`Lasting.Variant`) for reaching `0` within `d` turns. -/
theorem difference_variant {f : Nat → Nat} (below : ∀ x, 0 < x → f x < x) (d : Nat) :
    Lasting.Variant (Lasting.determined f) (fun _ => True) (fun x => x = 0) d id :=
  fun x _ => match x with
    | 0 => Or.inl rfl
    | x + 1 => Or.inr ⟨Nat.succ_pos x, fun _ _ => below (x + 1) (Nat.succ_pos x)⟩

/-- **A return map below what it receives closes within `d` turns.** Where `f 0 = 0` and `f x < x`
for every positive `x`, the course is `0` at turn `d` and at every turn from then on. This is an
instance of the reaching law with a numeric variant, `Lasting.Variant.reaches`, read on the orbit
by `Lasting.reaches_iff_orbit` (the variant is `difference_variant`); once `0` is met the course
stays there (`stays_from_fixed`). -/
theorem closes_within {f : Nat → Nat} (zero : f 0 = 0) (below : ∀ x, 0 < x → f x < x) (d : Nat) :
    (Law.run f d).state d = 0 ∧ ∀ n, d ≤ n → (Law.run f d).state n = 0 :=
  match Lasting.reaches_iff_orbit.mp
      (Lasting.Variant.reaches (difference_variant below d) (Nat.le_refl d)) with
  | ⟨k, le, met⟩ =>
    have closed : (Law.run f d).state k = 0 := met
    have fixed : f ((Law.run f d).state k) = (Law.run f d).state k :=
      (congrArg f closed).trans (zero.trans closed.symm)
    have after : ∀ n, d ≤ n → (Law.run f d).state n = 0 :=
      fun _ later => (stays_from_fixed fixed (Nat.le_trans le later)).trans closed
    ⟨after d (Nat.le_refl d), after⟩

/-! ## Taking a constant off -/

/-- **Taking a constant off.** A return map giving back `c` less than it receives leaves
`d - n * c` after `n` turns. -/
theorem orbit_sub_const {f : Nat → Nat} {c : Nat} (sub : ∀ x, f x = x - c) (d : Nat) :
    ∀ n, (Law.run f d).state n = d - n * c
  | 0 => (congrArg (d - ·) (Nat.zero_mul c)).symm
  | n + 1 =>
    (sub _).trans ((congrArg (· - c) (orbit_sub_const sub d n)).trans
      ((Naturals.sub_sub d (n * c) c).trans (congrArg (d - ·) (Nat.succ_mul n c).symm)))

/-- **Taking a constant off has closed once `n * c ≥ d`.** -/
theorem sub_const_closes {f : Nat → Nat} {c d n : Nat} (sub : ∀ x, f x = x - c)
    (enough : d ≤ n * c) : (Law.run f d).state n = 0 :=
  (orbit_sub_const sub d n).trans (sub_eq_zero_of_le enough)

/-- **Taking a constant off has not closed while `n * c < d`**: with `sub_const_closes`, the
closing turn is the least `n` with `n * c ≥ d`; with `c = 0` there is none for a positive `d`. -/
theorem sub_const_open {f : Nat → Nat} {c d n : Nat} (sub : ∀ x, f x = x - c)
    (short : n * c < d) : 0 < (Law.run f d).state n :=
  Nat.lt_of_lt_of_le (SupportGated.sub_pos_of_lt short) (Nat.le_of_eq (orbit_sub_const sub d n).symm)

/-- **The bound `d` is exact.** `Nat.pred` keeps no difference and is below every positive one, and
under it the course is positive at every turn before `d`. -/
theorem closes_within_exact :
    Nat.pred 0 = 0 ∧ (∀ x, 0 < x → Nat.pred x < x) ∧
      ∀ d n, n < d → 0 < (Law.run Nat.pred d).state n :=
  ⟨rfl, fun _ pos => Nat.pred_lt (Nat.ne_of_gt pos),
   fun d n lt =>
    match le_dest lt with
    | ⟨e, same⟩ =>
      have eq : (Law.run Nat.pred d).state n = e + 1 :=
        (congrArg (fun x => (Law.run Nat.pred x).state n)
            (same.trans ((Nat.add_comm (n + 1) e).trans (Nat.add_right_comm e 1 n).symm))).trans
          (Law.pred_orbit n (e + 1))
      Nat.lt_of_lt_of_le (Nat.succ_pos e) (Nat.le_of_eq eq.symm)⟩

/-- A course that starts positive and is `0` at some turn has a last positive turn before it: a
turn `k` with the course positive at `k` and `0` at `k + 1`. The turns are searched, equality of
numbers being decided. -/
theorem last_positive {f : Nat → Nat} {d : Nat} (pos : 0 < d) :
    ∀ {n : Nat}, (Law.run f d).state n = 0 → ∃ k, 0 < (Law.run f d).state k ∧ (Law.run f d).state (k + 1) = 0
  | 0, closed => absurd closed (Nat.ne_of_gt pos)
  | n + 1, closed =>
    match Nat.decEq ((Law.run f d).state n) 0 with
    | isTrue earlier => last_positive pos earlier
    | isFalse open_ => ⟨n, Nat.pos_of_ne_zero open_, closed⟩

/-- **A loop that closes a positive difference merges two differences.** Where the return map
keeps no difference and the course closes a positive `d`, the positive difference at the last turn
before closing and `0` go to one difference, `0` (`Law.Merges`). By `Law.merged_stays` no later
turn tells them apart, and within finitely many differences the merge loses a possibility for good
(`Law.Merges.loses`). -/
theorem closing_merges {f : Nat → Nat} {d n : Nat} (zero : f 0 = 0)
    (closed : (Law.run f d).state n = 0) (pos : 0 < d) : Law.Merges f :=
  match last_positive pos closed with
  | ⟨k, open_, next⟩ => Law.merges_iff.mpr ⟨(Law.run f d).state k, 0, Nat.ne_of_gt open_, next.trans zero.symm⟩

/-- **A loop that closes a positive difference is not lossless** (`Branching.Merges.not_lossless`). -/
theorem closing_not_lossless {f : Nat → Nat} {d n : Nat} (zero : f 0 = 0)
    (closed : (Law.run f d).state n = 0) (pos : 0 < d) : ¬ Law.Lossless f :=
  (closing_merges zero closed pos).not_lossless

/-! ## A cut -/

/-- A loop each of whose links gives on no difference where it receives none gives back none for
none. -/
theorem returnMap_zero : ∀ {links : List (Nat → Nat)},
    (∀ g, g ∈ links → g 0 = 0) → returnMap links 0 = 0
  | [], _ => rfl
  | g :: gs, keep =>
    (congrArg (returnMap gs) (keep g (List.Mem.head gs))).trans
      (returnMap_zero (fun h m => keep h (List.Mem.tail g m)))

/-- A loop with a link returning nothing, followed only by links giving nothing for nothing, gives
back nothing. -/
theorem returnMap_cut {c : Nat → Nat} (cut : ∀ x, c x = 0) :
    ∀ (pre : List (Nat → Nat)) {post : List (Nat → Nat)}, (∀ g, g ∈ post → g 0 = 0) →
      ∀ x, returnMap (pre ++ c :: post) x = 0
  | [], _, keep, x => (congrArg (returnMap _) (cut x)).trans (returnMap_zero keep)
  | g :: pre, _, keep, x => returnMap_cut cut pre keep (g x)

/-- **A cut closes at once.** A link returning nothing makes the difference `0` from the first
turn, whatever the links before it, where every link after it gives on no difference where it
receives none. -/
theorem cut_closes {c : Nat → Nat} (cut : ∀ x, c x = 0) (pre : List (Nat → Nat))
    {post : List (Nat → Nat)} (keep : ∀ g, g ∈ post → g 0 = 0) (d : Nat) :
    ∀ n, (Law.run (returnMap (pre ++ c :: post)) d).state (n + 1) = 0 :=
  fun _ => returnMap_cut cut pre keep _

/-- **What follows a cut can reopen the difference.** In the loop of a link returning nothing
followed by `Nat.succ`, the difference is `1` at every turn after the first, whatever it was: the
condition of `cut_closes` on the links after the cut is needed. -/
theorem cut_reopened (d : Nat) :
    ∀ n, (Law.run (returnMap [fun _ => 0, Nat.succ]) d).state (n + 1) = 1 :=
  fun _ => rfl

/-! ## Monotone return maps -/

/-- **A monotone return map that does not raise the start never raises the course.** This is
`Lasting.orbit_mono` (a monotone map keeps order along its orbits) for the orbits from `f d` and
from `d`, the first being the course one turn on (`Law.orbit_shift`). -/
theorem never_rises {f : Nat → Nat} (mono : ∀ x y, x ≤ y → f x ≤ f y) {d : Nat} (down : f d ≤ d)
    (n : Nat) : (Law.run f d).state (n + 1) ≤ (Law.run f d).state n :=
  Nat.le_trans (Nat.le_of_eq (Law.orbit_shift f d n))
    (Lasting.orbit_mono (rel := (· ≤ ·)) mono down n)

/-- **A monotone return map that does not lower the start never lowers the course**, by
`Lasting.orbit_mono` for the orbits from `d` and from `f d`. -/
theorem never_falls {f : Nat → Nat} (mono : ∀ x y, x ≤ y → f x ≤ f y) {d : Nat} (up : d ≤ f d)
    (n : Nat) : (Law.run f d).state n ≤ (Law.run f d).state (n + 1) :=
  Nat.le_trans (Lasting.orbit_mono (rel := (· ≤ ·)) mono up n)
    (Nat.le_of_eq (Law.orbit_shift f d n).symm)

/-- Under a monotone return map not raising the start, by turn `n` the course has met a kept value
or fallen by at least `n`. -/
theorem settled_or_fallen {f : Nat → Nat} (mono : ∀ x y, x ≤ y → f x ≤ f y) {d : Nat}
    (down : f d ≤ d) :
    ∀ n, (∃ k, k ≤ n ∧ f ((Law.run f d).state k) = (Law.run f d).state k) ∨ (Law.run f d).state n + n ≤ d
  | 0 => Or.inr (Nat.le_refl d)
  | n + 1 =>
    match settled_or_fallen mono down n with
    | Or.inl ⟨k, le, fixed⟩ => Or.inl ⟨k, Nat.le_succ_of_le le, fixed⟩
    | Or.inr fallen =>
      match Nat.decEq (f ((Law.run f d).state n)) ((Law.run f d).state n) with
      | isTrue fixed => Or.inl ⟨n, Nat.le_succ n, fixed⟩
      | isFalse moved =>
        Or.inr (Nat.le_trans
          (Nat.le_of_eq ((Nat.add_assoc ((Law.run f d).state (n + 1)) 1 n).trans
            (congrArg ((Law.run f d).state (n + 1) + ·) (Nat.add_comm 1 n))).symm)
          (Nat.le_trans (Nat.add_le_add_right
            (Nat.lt_of_le_of_ne (never_rises mono down n) moved) n) fallen))

/-- **A monotone return map that does not raise the start settles within `d` turns.** The course
meets, by turn `d`, a value `v` with `f v = v`, and stays there at every later turn. -/
theorem settles_within {f : Nat → Nat} (mono : ∀ x y, x ≤ y → f x ≤ f y) {d : Nat}
    (down : f d ≤ d) :
    ∃ k, k ≤ d ∧ f ((Law.run f d).state k) = (Law.run f d).state k ∧
      ∀ n, k ≤ n → (Law.run f d).state n = (Law.run f d).state k :=
  match settled_or_fallen mono down d with
  | Or.inl ⟨k, le, fixed⟩ => ⟨k, le, fixed, fun _ later => stays_from_fixed fixed later⟩
  | Or.inr fallen =>
    have closed : (Law.run f d).state d = 0 := eq_zero_of_add_le fallen
    have fixed : f ((Law.run f d).state d) = (Law.run f d).state d :=
      (Nat.eq_zero_of_le_zero (closed ▸ never_rises mono down d)).trans closed.symm
    ⟨d, Nat.le_refl d, fixed, fun _ later => stays_from_fixed fixed later⟩

/-- **The bound `d` of settling is exact.** `Nat.pred` keeps order and does not raise any start,
and under it the course meets no value it keeps before turn `d`. -/
theorem settles_within_exact :
    (∀ x y, x ≤ y → Nat.pred x ≤ Nat.pred y) ∧ (∀ d, Nat.pred d ≤ d) ∧
      ∀ d n, n < d → Nat.pred ((Law.run Nat.pred d).state n) ≠ (Law.run Nat.pred d).state n :=
  ⟨fun _ _ le => Nat.pred_le_pred le, fun _ => Nat.pred_le _,
   fun d n lt same =>
    Nat.ne_of_lt (Nat.pred_lt (Nat.ne_of_gt (closes_within_exact.2.2 d n lt))) same⟩

/-! ## Doubling links -/

/-- A loop with a link, each of whose links gives on at least twice what it receives, gives back at
least twice what it receives. -/
theorem returnMap_doubles {g : Nat → Nat} {gs : List (Nat → Nat)}
    (double : ∀ h, h ∈ g :: gs → ∀ x, x + x ≤ h x) (x : Nat) : x + x ≤ returnMap (g :: gs) x :=
  Nat.le_trans (double g (List.Mem.head gs) x)
    (returnMap_ge (fun h m y => Nat.le_trans (Nat.le_add_left y y) (double h (List.Mem.tail g m) y))
      (g x))

/-- Two to the next exponent, times a number, is twice two to the exponent times it. -/
theorem two_pow_succ_mul (n d : Nat) : 2 ^ (n + 1) * d = 2 ^ n * d + 2 ^ n * d :=
  (congrArg (· * d) (Nat.pow_succ 2 n)).trans
    ((mul_assoc_nat (2 ^ n) 2 d).trans
      ((congrArg (2 ^ n * ·) (Nat.two_mul d)).trans (Nat.left_distrib (2 ^ n) d d)))

/-- **Doubling links run away.** Where a loop has a link and every link gives on at least twice
what it receives, the difference after `n` turns is at least `2 ^ n * d`. -/
theorem runs_away {g : Nat → Nat} {gs : List (Nat → Nat)}
    (double : ∀ h, h ∈ g :: gs → ∀ x, x + x ≤ h x) (d : Nat) :
    ∀ n, 2 ^ n * d ≤ (Law.run (returnMap (g :: gs)) d).state n
  | 0 => Nat.le_of_eq (Nat.one_mul d)
  | n + 1 =>
    Nat.le_trans (Nat.le_of_eq (two_pow_succ_mul n d))
      (Nat.le_trans (Nat.add_le_add (runs_away double d n) (runs_away double d n))
        (returnMap_doubles double _))

/-- A positive number times two to an exponent exceeds the exponent. -/
theorem lt_two_pow_mul {d : Nat} (pos : 0 < d) (n : Nat) : n < 2 ^ n * d :=
  Nat.lt_of_lt_of_le (Naturals.lt_two_pow n)
    (Nat.le_trans (Nat.le_of_eq (Nat.mul_one _).symm) (Nat.mul_le_mul_left _ pos))

/-- **From a positive start, doubling links exceed every bound.** -/
theorem runs_away_unbounded {g : Nat → Nat} {gs : List (Nat → Nat)}
    (double : ∀ h, h ∈ g :: gs → ∀ x, x + x ≤ h x) {d : Nat} (pos : 0 < d) :
    ∀ B, ∃ n, B < (Law.run (returnMap (g :: gs)) d).state n :=
  fun B => ⟨B, Nat.lt_of_lt_of_le (lt_two_pow_mul pos B) (runs_away double d B)⟩

/-- The loop of one link giving on twice what it receives leaves exactly `2 ^ n * d` after `n`
turns. -/
theorem orbit_doubling (d : Nat) :
    ∀ n, (Law.run (returnMap [fun x => x + x]) d).state n = 2 ^ n * d
  | 0 => (Nat.one_mul d).symm
  | n + 1 =>
    (congrArg (fun y => y + y) (orbit_doubling d n)).trans (two_pow_succ_mul n d).symm

/-- **The doubling bound is attained.** The loop of one link giving on twice what it receives meets
the hypothesis of `runs_away` and leaves exactly `2 ^ n * d` after `n` turns. -/
theorem doubling_exact :
    (∀ h, h ∈ [fun x : Nat => x + x] → ∀ x, x + x ≤ h x) ∧
      ∀ d n, (Law.run (returnMap [fun x => x + x]) d).state n = 2 ^ n * d :=
  ⟨fun h m x => (match h, m with
    | _, List.Mem.head _ => Nat.le_refl (x + x)
    | _, List.Mem.tail _ rest => nomatch rest),
   orbit_doubling⟩

/-- **An empty loop gives back what it receives**, so `runs_away` needs a link. -/
theorem empty_loop_kept (d : Nat) : ∀ n, (Law.run (returnMap []) d).state n = d :=
  kept_of_identity (fun _ => rfl) d

/-! ## Whole-number factors -/

/-- **A loop of multiplying links multiplies by the product of the factors.** -/
theorem returnMap_scaling : ∀ (as : List Nat) (x : Nat), returnMap (scaling as) x = factor as * x
  | [], x => (Nat.one_mul x).symm
  | a :: as, x =>
    (returnMap_scaling as (a * x)).trans
      ((mul_assoc_nat (factor as) a x).symm.trans
        (congrArg (· * x) (Nat.mul_comm (factor as) a)))

/-- **The course of a loop of multiplying links.** After `n` turns the difference is the product
of the factors to the `n` times the difference sent. -/
theorem orbit_scaling (as : List Nat) (d : Nat) :
    ∀ n, (Law.run (returnMap (scaling as)) d).state n = factor as ^ n * d
  | 0 => (Nat.one_mul d).symm
  | n + 1 =>
    (returnMap_scaling as _).trans
      ((congrArg (factor as * ·) (orbit_scaling as d n)).trans
        ((mul_assoc_nat (factor as) _ d).symm.trans
          (congrArg (· * d) ((Nat.mul_comm (factor as) _).trans (Nat.pow_succ _ n).symm))))

/-- **Whole-number factors have nothing between.** In a loop of links multiplying by
whole-number factors with product `P`: with `P = 0` the difference closes at the first turn, with
`P = 1` it is kept at every turn, and with `P ≥ 2` it exceeds every bound from a positive start. -/
theorem whole_factors (as : List Nat) (d : Nat) :
    (factor as = 0 → ∀ n, (Law.run (returnMap (scaling as)) d).state (n + 1) = 0) ∧
    (factor as = 1 → ∀ n, (Law.run (returnMap (scaling as)) d).state n = d) ∧
    (2 ≤ factor as → 0 < d → ∀ B, ∃ n, B < (Law.run (returnMap (scaling as)) d).state n) :=
  ⟨fun zero _ =>
    (returnMap_scaling as _).trans ((congrArg (· * _) zero).trans (Nat.zero_mul _)),
   fun one n =>
    (orbit_scaling as d n).trans
      ((congrArg (fun p => p ^ n * d) one).trans
        ((congrArg (· * d) (one_pow n)).trans (Nat.one_mul d))),
   fun two pos B =>
    ⟨B, Nat.lt_of_lt_of_le (lt_two_pow_mul pos B)
      (Nat.le_trans (Nat.mul_le_mul_right d (Loops.pow_le_pow_base two B))
        (Nat.le_of_eq (orbit_scaling as d B).symm))⟩⟩

/-- **No loop of multiplying links closes a difference gradually.** At every turn the course is
`0`, or no less than at the turn before. -/
theorem nothing_between (as : List Nat) (d n : Nat) :
    (Law.run (returnMap (scaling as)) d).state (n + 1) = 0 ∨
      (Law.run (returnMap (scaling as)) d).state n ≤ (Law.run (returnMap (scaling as)) d).state (n + 1) :=
  match h : factor as with
  | 0 => Or.inl ((whole_factors as d).1 h n)
  | k + 1 =>
    Or.inr (Nat.le_trans (Nat.le_of_eq (Nat.one_mul _).symm)
      (Nat.le_trans (Nat.mul_le_mul_right _ (h ▸ Nat.succ_pos k : 0 < factor as))
        (Nat.le_of_eq (returnMap_scaling as _).symm)))

/-- **A loop that closes gradually needs a link that is not a multiplication.** No loop of
multiplying links leaves, at any turn, a positive difference below the one before; taking one off,
from `2`, leaves `1` after one turn. -/
theorem gradual_needs_another_link :
    (∀ as d n, ¬ (0 < (Law.run (returnMap (scaling as)) d).state (n + 1) ∧
        (Law.run (returnMap (scaling as)) d).state (n + 1) < (Law.run (returnMap (scaling as)) d).state n)) ∧
      (0 < (Law.run (returnMap [fun x => x - 1]) 2).state 1 ∧
        (Law.run (returnMap [fun x => x - 1]) 2).state 1 < (Law.run (returnMap [fun x => x - 1]) 2).state 0) :=
  ⟨fun as d n ⟨pos, lt⟩ =>
    match nothing_between as d n with
    | Or.inl closed => Nat.ne_of_gt pos closed
    | Or.inr le => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le lt le),
   ⟨Nat.succ_pos 0, Nat.lt_succ_self 1⟩⟩

/-! ## The return map as the carried amount of `Becoming.Loops`

A link's factor is what one turn makes of the difference the link receives. Under the carrying law
of `Becoming.Propagation`, which gives what the coupling strengths make of the levels and takes
nothing, a condition holds what it had and receives what the strengths carry back to it, so one
turn multiplies by one plus the coupling strength, and around a cycle by at least one plus the
product of the coupling strengths around it. -/

/-- One link's factor is the factor of the loop of that one link. -/
theorem factor_single (a : Nat) : factor [a] = a :=
  Nat.mul_one a

/-- The self-loop's bound, step by step, is the course of the loop of one link with factor
`1 + M`. -/
theorem geomBound_eq_course (M D : Nat) :
    ∀ t, Loops.geomBound M D t = (Law.run (returnMap (scaling [1 + M])) D).state t
  | 0 => rfl
  | t + 1 =>
    show Loops.geomBound M D t + M * Loops.geomBound M D t =
        (1 + M) * (Law.run (returnMap (scaling [1 + M])) D).state t from
    (Loops.one_add_mul M _).symm.trans (congrArg ((1 + M) * ·) (geomBound_eq_course M D t))

/-- **A self-loop's carried amount is the course of a return map.** One condition returning its
current level to itself with coupling strength `M` (`Loops.SelfLoop.strengths`): from a starting gap
`D`, the carried amount at step `t` is the course from `D`, after `t` turns, of the loop of one link
with factor `1 + M`, one turn a step. -/
theorem selfLoop_carried (M D t : Nat) :
    carried [()] (fun _ => false) (fun _ _ _ => 0) (Loops.SelfLoop.strengths M) (fun _ => [()])
        (fun _ => D) t () =
      (Law.run (returnMap (scaling [1 + M])) D).state t :=
  (Loops.SelfLoop.carried_eq M D t).trans (geomBound_eq_course M D t)

/-- **Where the response attains the carrying bound, the gap is the course of the return map.** The
course the carrying law generates from `D` has, against the quiet course, exactly the carried
amount as its gap at every step (`carried_attained`); for the self-loop of coupling strength `M`
that gap is the course of the loop of one link with factor `1 + M`. -/
theorem selfLoop_gap (M D t : Nat) :
    gap (carried [()] (fun _ => false) (fun _ _ _ => 0) (Loops.SelfLoop.strengths M) (fun _ => [()])
          (fun _ => D) t ())
        (carried [()] (fun _ => false) (fun _ _ _ => 0) (Loops.SelfLoop.strengths M)
          (fun _ => [()]) (fun _ => 0) t ()) =
      (Law.run (returnMap (scaling [1 + M])) D).state t :=
  (carried_attained t ()).trans (selfLoop_carried M D t)

/-- **Around every cycle, at least the course of one plus the product of the coupling strengths.**
Where at every step each condition of a loop of `m + 1` couplings is coupled into the next with
strength at least `w` (`CoupledWith`), the carried amount at the loop after `R` times around is at
least the course, after `R` turns, of the loop of one link whose factor is one plus the product of
the coupling strengths around the cycle (`Loops.product`), from what had reached the loop
(`carried_runaway`). -/
theorem carried_around_course {F C : Type} {cs : List C} {part : F → Bool}
    {σ : Nat → F → C → Nat} {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F}
    {δ : C → Nat} {v : Nat → C} {w : Nat → Nat} {m : Nat} {e : C} (start : v 0 = e)
    (back : v (m + 1) = e) (loop : CoupledWith cs part k present v w (m + 1)) (t R : Nat) :
    (Law.run (returnMap (scaling [1 + Loops.product w (m + 1)]))
        (carried cs part σ k present δ t e)).state R ≤
      carried cs part σ k present δ (t + (m + 1) * R) e :=
  Nat.le_trans
    (Nat.le_of_eq ((orbit_scaling _ _ R).trans
      (congrArg (fun x => x ^ R * carried cs part σ k present δ t e) (factor_single _))))
    (carried_runaway start back loop t R)

/-! ## Around a cycle of several conditions, exactly

`carried_around_course` is a bound: around a cycle of several conditions the intermediate
conditions hold what reached them and keep giving it on, so a turn is not a map of one number.
Where each link gives into the next condition exactly its strength times the current level, and
nothing else is given there, one turn is exact: the product of the strengths times what the loop
held at the start, with what each condition along the cycle held as the turn passed it, carried
on by the strengths after it. The return map's course is the part of this from the loop alone;
the rest is what the intermediate conditions give. -/

/-- **Each link gives exactly its strength.** For each of the first `j` links of `v`, at every step
and from any levels, the formations present give into `v (i + 1)` exactly `w i` times the current
level of `v i`: the link reads that level alone, and nothing else is given there. -/
def GivesExactly {F C : Type} (cs : List C) (part : F → Bool) (σ : Nat → F → C → Nat)
    (k : Nat → F → C → Nat → C → Nat) (present : Nat → List F) (v : Nat → C) (w : Nat → Nat)
    (j : Nat) : Prop :=
  ∀ i, i < j → ∀ t (l : Nat → C → Nat),
    total (present t) (fun h => carriedGive cs part σ k t h (v (i + 1)) l) = w i * l t (v i)

/-- **What the conditions along a chain held, carried on to its end.** With no link, nothing; with
one more link `p`, what the condition it gives into held (`H p`), with the link's strength times
what was carried on before. -/
def heldAlong (w : Nat → Nat) (H : Nat → Nat) : Nat → Nat
  | 0 => 0
  | p + 1 => H p + w p * heldAlong w H p

/-- One more link, rearranged. -/
theorem link_rearranged (H w P X h : Nat) : H + w * (P * X + h) = P * w * X + (H + w * h) :=
  (congrArg (H + ·) (Nat.left_distrib w (P * X) h)).trans
    ((Nat.add_left_comm H _ _).trans (congrArg (· + (H + w * h)) (Loops.mul_swap P w X).symm))

/-- **Along a chain of exact links, exactly.** Where each of the `p` links gives exactly its
strength, the carried amount at the chain's end after `p` steps from `t` is the product of the
strengths times the carried amount at its start at `t`, with what each condition along the chain
held as the chain passed it (at `t + i`, the condition `v (i + 1)`), carried on by the strengths
after it. `carried_along`'s bound, with what it leaves out stated. -/
theorem carried_along_exact {F C : Type} {cs : List C} {part : F → Bool}
    {σ : Nat → F → C → Nat} {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F}
    {δ : C → Nat} {v : Nat → C} {w : Nat → Nat} :
    ∀ {p : Nat}, GivesExactly cs part σ k present v w p → ∀ t,
      carried cs part σ k present δ (t + p) (v p) =
        Loops.product w p * carried cs part σ k present δ t (v 0) +
          heldAlong w (fun i => carried cs part σ k present δ (t + i) (v (i + 1))) p
  | 0, _, _ => ((Nat.add_zero _).trans (Nat.one_mul _)).symm
  | p + 1, exact, t =>
    (carried_succ (t + p) (v (p + 1))).trans
      ((congrArg (carried cs part σ k present δ (t + p) (v (p + 1)) + ·)
          ((exact p (Nat.lt_succ_self p) (t + p) (carried cs part σ k present δ)).trans
            (congrArg (w p * ·)
              (carried_along_exact (fun i lt => exact i (Nat.lt_succ_of_lt lt)) t)))).trans
        (link_rearranged _ _ _ _ _))

/-- **Around a cycle of exact links, one turn exactly.** For a cycle of `m + 1` links each giving
exactly its strength, the carried amount at the loop one turn after `t` is the product of the
strengths times the carried amount at the loop at `t`, with what the loop itself held at `t + m`
and the last strength times what the intermediate conditions held as the turn passed them,
carried on. -/
theorem carried_around_exact {F C : Type} {cs : List C} {part : F → Bool}
    {σ : Nat → F → C → Nat} {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F}
    {δ : C → Nat} {v : Nat → C} {w : Nat → Nat} {m : Nat} {e : C} (start : v 0 = e)
    (back : v (m + 1) = e) (exact : GivesExactly cs part σ k present v w (m + 1)) (t : Nat) :
    carried cs part σ k present δ (t + (m + 1)) e =
      Loops.product w (m + 1) * carried cs part σ k present δ t e +
        (carried cs part σ k present δ (t + m) e +
          w m * heldAlong w (fun i => carried cs part σ k present δ (t + i) (v (i + 1))) m) := by
  have along : carried cs part σ k present δ (t + (m + 1)) (v (m + 1)) =
      Loops.product w (m + 1) * carried cs part σ k present δ t (v 0) +
        (carried cs part σ k present δ (t + m) (v (m + 1)) +
          w m * heldAlong w (fun i => carried cs part σ k present δ (t + i) (v (i + 1))) m) :=
    carried_along_exact exact t
  rw [back, start] at along
  exact along

/-- **The turn is the return map's course with what the intermediate conditions give.** Around a
cycle of exact links, the carried amount one turn after `t` is the return map's course after one
turn, one plus the product of the strengths times the carried amount at `t`, with what the loop
gained over the first `m` steps of the turn and what the intermediate conditions held, carried on
to it by the last link. -/
theorem carried_around_excess {F C : Type} {cs : List C} {part : F → Bool}
    {σ : Nat → F → C → Nat} {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F}
    {δ : C → Nat} {v : Nat → C} {w : Nat → Nat} {m : Nat} {e : C} (start : v 0 = e)
    (back : v (m + 1) = e) (exact : GivesExactly cs part σ k present v w (m + 1)) (t : Nat) :
    carried cs part σ k present δ (t + (m + 1)) e =
      (Law.run (returnMap (scaling [1 + Loops.product w (m + 1)]))
          (carried cs part σ k present δ t e)).state 1 +
        ((carried cs part σ k present δ (t + m) e - carried cs part σ k present δ t e) +
          w m * heldAlong w (fun i => carried cs part σ k present δ (t + i) (v (i + 1))) m) := by
  have turn := carried_around_exact (δ := δ) start back exact t
  have grew : carried cs part σ k present δ t e +
      (carried cs part σ k present δ (t + m) e - carried cs part σ k present δ t e) =
      carried cs part σ k present δ (t + m) e :=
    add_sub_of_le (carried_mono_steps (Nat.le_add_right t m) e)
  have course : (Law.run (returnMap (scaling [1 + Loops.product w (m + 1)]))
      (carried cs part σ k present δ t e)).state 1 =
      carried cs part σ k present δ t e +
        Loops.product w (m + 1) * carried cs part σ k present δ t e :=
    Loops.one_add_mul _ _
  have held : carried cs part σ k present δ (t + m) e +
      w m * heldAlong w (fun i => carried cs part σ k present δ (t + i) (v (i + 1))) m =
      carried cs part σ k present δ t e +
        ((carried cs part σ k present δ (t + m) e - carried cs part σ k present δ t e) +
          w m * heldAlong w (fun i => carried cs part σ k present δ (t + i) (v (i + 1))) m) :=
    (congrArg (· + _) grew.symm).trans (Nat.add_assoc _ _ _)
  exact turn.trans ((congrArg (_ + ·) held).trans ((Nat.add_assoc _ _ _).symm.trans
    (congrArg (· + _) ((Nat.add_comm _ _).trans course.symm))))

/-- **Exactly when a turn is the return map's course.** Around a cycle of exact links, the carried
amount one turn after `t` is the return map's course after one turn exactly where the loop gained
nothing over the first `m` steps of the turn and the last link carries on nothing the intermediate
conditions held. -/
theorem around_course_iff {F C : Type} {cs : List C} {part : F → Bool}
    {σ : Nat → F → C → Nat} {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F}
    {δ : C → Nat} {v : Nat → C} {w : Nat → Nat} {m : Nat} {e : C} (start : v 0 = e)
    (back : v (m + 1) = e) (exact : GivesExactly cs part σ k present v w (m + 1)) (t : Nat) :
    carried cs part σ k present δ (t + (m + 1)) e =
        (Law.run (returnMap (scaling [1 + Loops.product w (m + 1)]))
          (carried cs part σ k present δ t e)).state 1 ↔
      carried cs part σ k present δ (t + m) e = carried cs part σ k present δ t e ∧
        w m * heldAlong w (fun i => carried cs part σ k present δ (t + i) (v (i + 1))) m = 0 := by
  have turn := carried_around_excess (δ := δ) start back exact t
  constructor
  · intro same
    have zero := Naturals.add_left_cancel (k := (Law.run (returnMap (scaling
        [1 + Loops.product w (m + 1)])) (carried cs part σ k present δ t e)).state 1)
      (turn.symm.trans ((same.trans (Nat.add_zero _).symm)))
    have gained := Nat.eq_zero_of_add_eq_zero_right zero
    have carriedOn := Nat.eq_zero_of_add_eq_zero_left zero
    refine ⟨Nat.le_antisymm ?_ (carried_mono_steps (Nat.le_add_right t m) e), carriedOn⟩
    exact Nat.le_trans (Nat.le_of_eq (add_sub_of_le (carried_mono_steps (Nat.le_add_right t m) e)).symm)
      (Nat.le_of_eq ((congrArg (_ + ·) gained).trans (Nat.add_zero _)))
  · intro ⟨kept, nothing⟩
    rw [turn, nothing, kept, Nat.sub_self, Nat.add_zero, Nat.add_zero]

/-! ## A ring: the bound is strict around every cycle of two or more conditions -/

/-- **A ring.** Every listed condition receives, at every step and from any levels, exactly `w`
times the current level of the condition before it (`pred`), and nothing else. -/
def RingGives {F C : Type} (cs : List C) (part : F → Bool) (σ : Nat → F → C → Nat)
    (k : Nat → F → C → Nat → C → Nat) (present : Nat → List F) (pred : C → C) (w : Nat) : Prop :=
  ∀ t c, c ∈ cs → ∀ l : Nat → C → Nat,
    total (present t) (fun h => carriedGive cs part σ k t h c l) = w * l t (pred c)

/-- **Around a ring from an even start, a self-loop at every condition.** On a ring of strength
`w` whose listed conditions all start at `D`, the carried amount at every listed condition after
`t` steps is `(1 + w) ^ t * D`: each condition grows as a self-loop of strength `w` would, one
turn a step, whatever the ring's length. -/
theorem ring_even {F C : Type} {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
    {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat} {pred : C → C}
    {w D : Nat} (ring : RingGives cs part σ k present pred w)
    (closed : ∀ c, c ∈ cs → pred c ∈ cs) (start : ∀ c, c ∈ cs → δ c = D) :
    ∀ t c, c ∈ cs → carried cs part σ k present δ t c = (1 + w) ^ t * D
  | 0, c, mem => (start c mem).trans (Nat.one_mul D).symm
  | t + 1, c, mem =>
    (carried_succ t c).trans
      ((Naturals.add_congr (ring_even ring closed start t c mem)
          ((ring t c mem _).trans
            (congrArg (w * ·) (ring_even ring closed start t (pred c) (closed c mem))))).trans
        ((Loops.one_add_mul w _).symm.trans (Loops.mul_swap _ _ _).symm))

/-- The product of `j` equal strengths is the strength to the power `j`. -/
theorem product_const (w : Nat) : ∀ j, Loops.product (fun _ => w) j = w ^ j
  | 0 => rfl
  | j + 1 => congrArg (· * w) (product_const w j)

/-- **One plus a power is below the power of one plus.** For a positive `w` and two or more
factors, `1 + w ^ (n + 2) < (1 + w) ^ (n + 2)`. -/
theorem one_add_pow_lt {w : Nat} (pos : 0 < w) (n : Nat) : 1 + w ^ (n + 2) < (1 + w) ^ (n + 2) :=
  have above : 1 < (1 + w) ^ (n + 1) :=
    Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right pos)
      (Nat.le_trans (Nat.le_of_eq (Nat.one_mul (1 + w)).symm)
        (Nat.pow_le_pow_right (Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_add_right 1 w))
          (Nat.succ_le_succ (Nat.zero_le n))))
  have power : w ^ (n + 1) * w ≤ (1 + w) ^ (n + 1) * w :=
    Nat.mul_le_mul_right w (Nat.pow_le_pow_left (Nat.le_add_left w 1) (n + 1))
  Nat.lt_of_lt_of_le (Nat.add_lt_add_of_lt_of_le above power)
    (Nat.le_of_eq ((congrArg (· + (1 + w) ^ (n + 1) * w) (Nat.mul_one _).symm).trans
      (Nat.left_distrib _ 1 w).symm))

namespace Ring

/-- The condition before `c` on the ring `0, 1, …, m`: `m` before `0`. -/
def pred (m : Nat) : Nat → Nat
  | 0 => m
  | c + 1 => c

/-- The conditions of the ring, `0, 1, …, m`. -/
def conditions (m : Nat) : List Nat := steps 0 (m + 1)

/-- Each condition receives `w` times the current level of the condition before it. -/
def strengths (m w : Nat) : Nat → Unit → Nat → Nat → Nat → Nat :=
  fun t _ c s d => if s = t ∧ d = pred m c then w else 0

/-- The carried amount on the ring of `m + 1` conditions with strength `w`, every condition
starting at `D`, one formation outside the part present at every step. -/
def amount (m w D : Nat) : Nat → Nat → Nat :=
  carried (conditions m) (fun _ => false) (fun _ _ _ => 0) (strengths m w) (fun _ => [()])
    (fun _ => D)

/-- The cycle `0, 1, …, m` and back to `0`. -/
def cycle (m i : Nat) : Nat := if i ≤ m then i else 0

theorem cycle_start (m : Nat) : cycle m 0 = 0 := if_pos (Nat.zero_le m)

theorem cycle_back (m : Nat) : cycle m (m + 1) = 0 := if_neg (Nat.not_succ_le_self m)

/-- Along the cycle, the condition before the next is this one. -/
theorem pred_cycle {m i : Nat} (lt : i < m + 1) : pred m (cycle m (i + 1)) = cycle m i :=
  have here : cycle m i = i := if_pos (Nat.le_of_lt_succ lt)
  match Nat.decLe (i + 1) m with
  | isTrue inside =>
    (congrArg (pred m) (if_pos inside : cycle m (i + 1) = i + 1)).trans here.symm
  | isFalse outside =>
    (congrArg (pred m) (if_neg outside : cycle m (i + 1) = 0)).trans
      ((Nat.le_antisymm (Nat.le_of_lt_succ (Nat.lt_of_not_le outside)) (Nat.le_of_lt_succ lt)).trans
        here.symm)

theorem pred_mem {m c : Nat} (_ : c ∈ conditions m) : pred m c ∈ conditions m :=
  match c with
  | 0 => Propagation.mem_steps_upto (Nat.le_refl m)
  | c + 1 => Propagation.mem_steps_upto (Nat.le_of_succ_le (Propagation.le_of_mem_steps_upto ‹c + 1 ∈ conditions m›))

theorem cycle_mem (m i : Nat) : cycle m i ∈ conditions m :=
  match Nat.decLe i m with
  | isTrue inside => Propagation.mem_steps_upto (Nat.le_trans (Nat.le_of_eq (if_pos inside : cycle m i = i)) inside)
  | isFalse outside =>
    Propagation.mem_steps_upto (Nat.le_trans (Nat.le_of_eq (if_neg outside : cycle m i = 0)) (Nat.zero_le m))

/-- A total over a list without repetition of what is nothing except at a listed `a` is its value
at `a`. -/
theorem total_at {q : Nat → Nat} {a : Nat} {as : List Nat} (only : ∀ b, b ≠ a → q b = 0)
    (mem : a ∈ as) (distinct : Distinct as) : total as q = q a :=
  Nat.le_antisymm
    (total_le_at (fun b pos =>
        match Nat.decEq b a with
        | isTrue same => same
        | isFalse other =>
          absurd pos fun lt =>
            Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (only b other))))
      distinct)
    (le_total_of_mem mem)

/-- **The ring gives exactly.** -/
theorem gives (m w : Nat) :
    RingGives (conditions m) (fun _ => false) (fun _ _ _ => 0) (strengths m w) (fun _ => [()])
      (pred m) w :=
  fun t c mem l =>
    (Nat.add_zero _).trans
      ((carriedGive_of_rest rfl).trans
        ((Propagation.total_steps_at (q := fun s => total (conditions m) fun d =>
            strengths m w t () c s d * l s d)
          fun s other => total_eq_zero fun d _ =>
            (congrArg (· * l s d) (if_neg fun both => other both.1)).trans (Nat.zero_mul _)).trans
          ((total_at (q := fun d => strengths m w t () c t d * l t d)
              (fun d other => (congrArg (· * l t d) (if_neg fun both => other both.2)).trans
                (Nat.zero_mul _))
              (pred_mem mem) (steps_distinct 0 (m + 1))).trans
            (congrArg (· * l t (pred m c)) (if_pos ⟨rfl, rfl⟩)))))

/-- **The ring is a cycle of `m + 1` couplings of strength `w`**, from `0` back to `0`. -/
theorem coupled (m w : Nat) :
    CoupledWith (conditions m) (fun _ => false) (strengths m w) (fun _ => [()]) (cycle m)
      (fun _ => w) (m + 1) :=
  fun i lt _ => ⟨(), .head [], rfl, cycle_mem m i,
    Nat.le_of_eq (if_pos ⟨rfl, (pred_cycle lt).symm⟩).symm⟩

/-- **Its links give exactly.** -/
theorem givesExactly (m w : Nat) :
    GivesExactly (conditions m) (fun _ => false) (fun _ _ _ => 0) (strengths m w) (fun _ => [()])
      (cycle m) (fun _ => w) (m + 1) :=
  fun i lt t l =>
    (gives m w t (cycle m (i + 1)) (cycle_mem m (i + 1)) l).trans
      (congrArg (fun x => w * l t x) (pred_cycle lt))

/-- From an even start, every condition of the ring is at `(1 + w) ^ t * D` at step `t`. -/
theorem amount_eq (m w D : Nat) : ∀ t c, c ∈ conditions m → amount m w D t c = (1 + w) ^ t * D :=
  ring_even (gives m w) (fun _ mem => pred_mem mem) (fun _ _ => rfl)

/-- **The bound around a cycle is strict for two or more conditions.** On the ring of `m + 2`
conditions with a positive strength `w`, every condition starting at a positive `D`, the carried
amount at `0` one turn on is above the return map's course after one turn,
`carried_around_course`'s bound for this cycle: `(1 + w ^ (m + 2)) * D < (1 + w) ^ (m + 2) * D`. -/
theorem exceeds_course (m : Nat) {w D : Nat} (pos : 0 < w) (posD : 0 < D) :
    (Law.run (returnMap (scaling [1 + Loops.product (fun _ => w) (m + 2)]))
        (amount (m + 1) w D 0 0)).state 1 < amount (m + 1) w D (0 + (m + 2) * 1) 0 :=
  have bound : (Law.run (returnMap (scaling [1 + Loops.product (fun _ => w) (m + 2)]))
      (amount (m + 1) w D 0 0)).state 1 = D * (1 + w ^ (m + 2)) :=
    (congrArg (· * D) (congrArg (1 + ·) (product_const w (m + 2)))).trans (Nat.mul_comm _ D)
  have turn : amount (m + 1) w D (0 + (m + 2) * 1) 0 = D * (1 + w) ^ (m + 2) :=
    (congrArg (fun t => amount (m + 1) w D t 0) ((Nat.zero_add _).trans (Nat.mul_one _))).trans
      ((amount_eq (m + 1) w D (m + 2) 0 (Propagation.mem_steps_upto (Nat.zero_le _))).trans (Nat.mul_comm _ D))
  Nat.lt_of_le_of_lt (Nat.le_of_eq bound)
    (Nat.lt_of_lt_of_le (Naturals.mul_lt_mul_of_pos posD (one_add_pow_lt pos m))
      (Nat.le_of_eq turn.symm))

/-- **And the ring meets the bound's hypotheses**: the cycle from `0` back to `0` is coupled with
strength `w` at every step, so `carried_around_course` applies, and is strict. -/
theorem bound_strict (m : Nat) {w D : Nat} (pos : 0 < w) (posD : 0 < D) :
    (Law.run (returnMap (scaling [1 + Loops.product (fun _ => w) (m + 2)]))
        (amount (m + 1) w D 0 0)).state 1 ≤ amount (m + 1) w D (0 + (m + 2) * 1) 0 ∧
      (Law.run (returnMap (scaling [1 + Loops.product (fun _ => w) (m + 2)]))
        (amount (m + 1) w D 0 0)).state 1 ≠ amount (m + 1) w D (0 + (m + 2) * 1) 0 :=
  ⟨carried_around_course (cycle_start (m + 1)) (cycle_back (m + 1)) (coupled (m + 1) w) 0 1,
   Nat.ne_of_lt (exceeds_course m pos posD)⟩

end Ring

/-! ## A difference at one condition of `Becoming.Rejoining` as a return map

`Becoming.Rejoining` reads the difference between the course with an act and the course without
it at a condition as whether the two levels differ, and shows it changes only through a different
exchange. Where the two courses' exchanges with the condition respond to the gap between them by
a map `f`, the gap follows `f`'s course, one turn a step: it is a return map of this module. A
response linear in the gap is a multiplying link; a response through a loop of links is that
loop's return map. Without the premise the gap need not follow any return map: an act opens a
difference from none, which no map of the gap does twice alike. -/

/-- Adding the same amount to both leaves the gap. -/
theorem gap_add_right (a b : Nat) : ∀ T, gap (a + T) (b + T) = gap a b
  | 0 => rfl
  | T + 1 => (Naturals.add_congr (Nat.succ_sub_succ _ _) (Nat.succ_sub_succ _ _)).trans
      (gap_add_right a b T)

/-- **The two courses' exchanges respond to the gap by `f`.** Across every step from `s`, the first
course's level of `c` with what it gives `c` and what the second takes, against the second's with
what it gives and what the first takes, has `f` of the gap before as its gap. -/
def RespondsByReturn {F C : Type} (L L' : Flow F C) (W W' : Web F C) (c : C) (f : Nat → Nat)
    (s : Nat) : Prop :=
  ∀ t, s ≤ t →
    gap (W.level t c + L.given t c + L'.taken t c) (W'.level t c + L'.given t c + L.taken t c) =
      f (gap (W.level t c) (W'.level t c))

/-- Across a step at which two flows balance on `c`, the gap after is the gap of the levels before
with what each gives and the other takes. -/
theorem gap_succ {F C : Type} {L L' : Flow F C} {W W' : Web F C} {c : C} {t : Nat}
    (bal : L.BalancesOn W [c] t) (bal' : L'.BalancesOn W' [c] t) :
    gap (W.level (t + 1) c) (W'.level (t + 1) c) =
      gap (W.level t c + L.given t c + L'.taken t c) (W'.level t c + L'.given t c + L.taken t c) :=
  have first : W.level (t + 1) c + (L.taken t c + L'.taken t c) =
      W.level t c + L.given t c + L'.taken t c :=
    (Nat.add_assoc _ _ _).symm.trans (congrArg (· + L'.taken t c) (bal c (.head [])))
  have second : W'.level (t + 1) c + (L.taken t c + L'.taken t c) =
      W'.level t c + L'.given t c + L.taken t c :=
    (congrArg (W'.level (t + 1) c + ·) (Nat.add_comm _ _)).trans
      ((Nat.add_assoc _ _ _).symm.trans (congrArg (· + L.taken t c) (bal' c (.head []))))
  (gap_add_right _ _ _).symm.trans (Naturals.add_congr
    (congr (congrArg HSub.hSub first) second) (congr (congrArg HSub.hSub second) first))

/-- **The premise is exactly the gap's step.** Where two flows balance on `c` at every step, their
exchanges respond to the gap by `f` from step `s` exactly where, across every step from `s`, the
gap after is `f` of the gap before. -/
theorem responds_iff {F C : Type} {L L' : Flow F C} {W W' : Web F C} {c : C} {f : Nat → Nat}
    {s : Nat} (bal : ∀ t, L.BalancesOn W [c] t) (bal' : ∀ t, L'.BalancesOn W' [c] t) :
    RespondsByReturn L L' W W' c f s ↔
      ∀ t, s ≤ t →
        gap (W.level (t + 1) c) (W'.level (t + 1) c) = f (gap (W.level t c) (W'.level t c)) :=
  ⟨fun responds t le => (gap_succ (bal t) (bal' t)).trans (responds t le),
   fun steps t le => (gap_succ (bal t) (bal' t)).symm.trans (steps t le)⟩

/-- **Rejoining's gap follows a return map.** Where two flows balance on `c` and their exchanges
respond to the gap by `f` from step `s`, the gap at `s + n` is the course of `f` from the gap at
`s` after `n` turns, one turn a step. -/
theorem gap_course {F C : Type} {L L' : Flow F C} {W W' : Web F C} {c : C} {f : Nat → Nat}
    {s : Nat} (bal : ∀ t, L.BalancesOn W [c] t) (bal' : ∀ t, L'.BalancesOn W' [c] t)
    (responds : RespondsByReturn L L' W W' c f s) :
    ∀ n, gap (W.level (s + n) c) (W'.level (s + n) c) =
      (Law.run f (gap (W.level s c) (W'.level s c))).state n
  | 0 => rfl
  | n + 1 => (gap_succ (bal (s + n)) (bal' (s + n))).trans
      ((responds (s + n) (Nat.le_add_right s n)).trans (congrArg f (gap_course bal bal' responds n)))

/-- **A response linear in the gap.** Where the response is a loop of multiplying links, the gap at
`s + n` is the product of the factors to the `n` times the gap at `s`; so with product `0` it
closes at the first step, with product `1` it is kept, and with product at least `2` it exceeds
every bound from a positive gap (`whole_factors`). -/
theorem gap_scaling {F C : Type} {L L' : Flow F C} {W W' : Web F C} {c : C} {as : List Nat}
    {s : Nat} (bal : ∀ t, L.BalancesOn W [c] t) (bal' : ∀ t, L'.BalancesOn W' [c] t)
    (responds : RespondsByReturn L L' W W' c (returnMap (scaling as)) s) (n : Nat) :
    gap (W.level (s + n) c) (W'.level (s + n) c) =
      factor as ^ n * gap (W.level s c) (W'.level s c) :=
  (gap_course bal bal' responds n).trans (orbit_scaling as _ n)

/-- In `Becoming.Rejoining`'s witness, after the act the responder's exchange responds to the gap
by taking one off. -/
theorem replenishing_responds :
    RespondsByReturn (Replenishing.flow true) (Replenishing.flow false) (Replenishing.web true)
      (Replenishing.web false) Replenishing.Cond.held Nat.pred 1 :=
  fun t le => match t, le with
    | 1, _ => rfl
    | _ + 2, _ => rfl

/-- **So from the act on, the witness's gap is the course of taking one off**: `1`, then `0`. -/
theorem replenishing_course (n : Nat) :
    gap ((Replenishing.web true).level (1 + n) Replenishing.Cond.held)
        ((Replenishing.web false).level (1 + n) Replenishing.Cond.held) =
      (Law.run Nat.pred 1).state n :=
  gap_course (fun t => (Replenishing.balances true).on [Replenishing.Cond.held] t)
    (fun t => (Replenishing.balances false).on [Replenishing.Cond.held] t) replenishing_responds n

/-- **Without the premise, no return map.** In the witness, from the start, the gap is `0`, `1`,
`0`, `0`: the act opens a difference from none and the response closes it, so the gap is the
course of no map from its start (a map sending `0` to `1` once would send it there again). -/
theorem replenishing_no_return :
    ¬ ∃ f : Nat → Nat, ∀ n,
      gap ((Replenishing.web true).level n Replenishing.Cond.held)
          ((Replenishing.web false).level n Replenishing.Cond.held) =
        (Law.run f (gap ((Replenishing.web true).level 0 Replenishing.Cond.held)
          ((Replenishing.web false).level 0 Replenishing.Cond.held))).state n :=
  fun ⟨f, course⟩ =>
    have opened : 1 = f 0 := course 1
    have closed : 0 = f (f 0) := course 2
    have stays : 0 = f (f (f 0)) := course 3
    have back : f 1 = 0 := (congrArg f opened).trans closed.symm
    absurd (stays.trans ((congrArg (fun x => f (f x)) opened.symm).trans
      ((congrArg f back).trans opened.symm))) (by decide)

end LoopReturn

end Becoming
