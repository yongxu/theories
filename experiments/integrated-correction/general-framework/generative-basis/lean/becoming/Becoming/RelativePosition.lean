import Becoming.Significance
import Becoming.Witnesses

/-!
# Relative position: a counting law, and what it does not protect

A part's *relative position* in a finite family is its amount read against the amounts of the
others. With signed amounts it is `n * a p - total ps a`, `n` the number of parts: the part's
amount counted once for each part, against the family's total. Here it is kept as two counts
(`n * a p` ahead, `total ps a` behind), so nothing leaves `Nat`.

* **Zero-sum is counting.** Over the family the ahead counts total exactly what the behind counts
  total (`positions_balance`). Across any change of amounts, from `a` to `b`, a part's position
  rises by `riseCount` against `fallCount` (`riseCount ps a b p = n * b p + total ps a`,
  `fallCount ps a b p = n * a p + total ps b`), and over the family the rises total what the falls
  total (`change_balances`). So a part's change of position is the opposite of the change summed
  over the rest (`change_opposed`): where its position rises, the rest's summed position falls
  (`rest_falls_of_rises`); no change raises every part's position (`not_all_rise`); and a rise
  needs some other part's fall (`rise_needs_fall`). These hold for every reading of amounts and
  every change, whatever the amounts themselves do: where every part draws more, a part's
  position can still fall (`DrawingMore.grow_and_fall`). Read on a flow, by what each part has
  drawn from a condition between any two steps, they hold with no hypothesis on the flow
  (`Flow.drawn_positions`). A game played for relative position is zero-sum by
  this count, not by any law of what is played for. A family has a greatest part, whose position
  is not below the family's (`greatest_exists`, `greatest_not_behind`); "greatest" means only that
  no part's amount exceeds its own.
* **What position does not protect.** On a flow, `n` steps of joint excess at a condition, with
  balance there, leave its level below `m` where it started below `n + m`
  (`Flow.excess_leaves_below`). The dependence hypothesis that ends a part at the end of the race
  is exactly this (`Flow.ends_at_race_end`): at that step the part requires the condition, at a
  need above what the excess can have left (the level at the start is below `n` plus the need),
  and it is active only while supported; its position does not enter. With renewal gated (whatever
  gives to the condition depends on it at a need of at least `m`, as in `Flow.joint_excess_ends`),
  the race's positions change by a zero-sum count while the level falls by at least `n`, and the
  level stays below `m`, and every part depending on the condition at such a need is inactive from
  then on, the greatest among them (`Flow.race_ends_greatest`); in a family whose parts all so
  depend, at every later step there is a greatest part and every greatest part is inactive
  (`Flow.greatest_end_for_good`). In `Race` a renewer and two parts each take within what the step
  gives and together take more; the part that takes more rises in position across the race, and
  it ends with the condition, as do the others (`Race.greatest_ends`).
* **Each hypothesis is needed.** Gated renewal: in `Restored` the renewer requires nothing, the
  race ends the greatest part at its end, and the renewal restores it from the next step on
  (`Restored.returns`). Dependence: in the clearer's web of `Becoming.Continuation`, read by what
  each part has drawn from the habitat, the clearer is the greatest part at every step; the
  habitat is drawn down jointly beyond what is given to it, with nothing giving to it, and the
  dweller, which depends on it, ends, while the clearer, which does not, is active and supported at
  every step (`Clearing.greatest_continues`). What it loses is a continuation with significance,
  not its own, and the loss needs a significance: under the continuation condition the clearer's
  part loses the dweller from every standpoint, and with nothing significant it loses nothing
  (`Clearing.loss_needs_significance`, from `Clearing.clearer_loses_dweller`). The continuation
  condition is not the only significance that counts the loss: the clearer's own presupposition,
  held along sharing a condition, counts it too (`Clearing.own_presupposition`).

The positions are any reading of amounts (`pos : Nat → F → Nat`); `Flow.drawn` is one, what the
flow records each part as taking from a condition over the steps before. Nothing here says that a
race for position must produce joint excess, nor that any part depends on what it draws down: the
first is a premise of the join and the second its dependence hypothesis. Whether the parts of an
actual race depend on the condition it draws down, as the opening's entangled Earth says they do,
is an empirical premise, not a law of the spine. The continuation condition enters only as a
hypothesis of `Clearing.loss_needs_significance`; no ethical predicate is asserted, and every
declaration has an empty axiom report.
* **Least parts and equal shares.** A least part's amount counted once for each part is at most the
  family's total (`least_not_ahead`, `least_exists`), so with no more in all and at least `n` parts
  it is at most the total over `n` (`least_bound`). Equal shares meet every need exactly where they
  meet the greatest (`equal_share_iff`), giving more than the total need exactly where needs differ
  (`equal_share_exceeds`, `equal_share_even`); two parts needing one and three are short in equal
  shares of what suffices by need (`uneven_short`).
* **What position reads.** Two profiles of amounts give every part the same position exactly where
  every part's amount differs between them by one amount common to all (`Keeps`, read by the counts
  above; `keeps_iff_common`): positions read the amounts up to a common amount. Adding an amount to
  every part keeps every position and adds it to the total once for each part (`keeps_add`); taking
  the least part's amount from every part keeps every position and leaves the spread above the least
  part (`keeps_least`). So with given positions the total is at least the spread (`spread_le`), above
  a bound exactly where the spread is (`exceeds_iff_spread`), and above every bound for some profile
  (`keeps_exceeds`): positions bound the total from below and never from above. In `Lasting` the
  renewer gives two units at every step, as in `Race`, and the two racers have the race's positions
  at every step; there what is taken is within what is given and every part is active at every step,
  while in the race every part ends (`Lasting.same_positions_apart`). What separates them is the
  total drawn, which positions do not read.
-/

namespace Becoming

namespace RelativePosition

variable {P : Type}

/-! ## Zero-sum as counting -/

/-- The total over a family with `p` in it: `p`'s amount and the total over the rest. -/
theorem total_split (q : P → Nat) (pre : List P) (p : P) (post : List P) :
    total (pre ++ p :: post) q = q p + total (pre ++ post) q :=
  (total_append q (p :: post) pre).trans
    ((Nat.add_left_comm (total pre q) (q p) (total post q)).trans
      (congrArg (q p + ·) (total_append q post pre).symm))

/-- Zero-sum, counted. Each part's position is its amount counted once for each part (ahead),
against the family's total (behind); over the family the ahead counts total what the behind
counts total. -/
theorem positions_balance (ps : List P) (a : P → Nat) :
    total ps (fun p => ps.length * a p) = total ps (fun _ => total ps a) :=
  (total_mul ps.length a ps).trans (total_const (total ps a) ps).symm

/-- Across a change of amounts from `a` to `b`, what raises `p`'s position: its new amount
counted once for each part, with the family's old total. -/
def riseCount (ps : List P) (a b : P → Nat) (p : P) : Nat :=
  ps.length * b p + total ps a

/-- Across a change of amounts from `a` to `b`, what lowers `p`'s position: its old amount
counted once for each part, with the family's new total. `p`'s position rises where
`fallCount` is below `riseCount`, falls where `riseCount` is below `fallCount`, and keeps where
they agree. -/
def fallCount (ps : List P) (a b : P → Nat) (p : P) : Nat :=
  ps.length * a p + total ps b

/-- Every change of position is zero-sum: over the family, whatever the amounts did, the rises
total what the falls total. -/
theorem change_balances (ps : List P) (a b : P → Nat) :
    total ps (riseCount ps a b) = total ps (fallCount ps a b) :=
  (total_add (fun p => ps.length * b p) (fun _ => total ps a) ps).trans
    ((congr (congrArg (· + ·) (total_mul ps.length b ps)) (total_const (total ps a) ps)).trans
      ((Nat.add_comm _ _).trans
        ((congr (congrArg (· + ·) (total_mul ps.length a ps)) (total_const (total ps b) ps)).symm.trans
          (total_add (fun p => ps.length * a p) (fun _ => total ps b) ps).symm)))

/-- A part's change of position is the opposite of the change summed over the rest: in the
family `pre ++ p :: post`, `p`'s rise count with the rest's rise counts is `p`'s fall count with
the rest's fall counts. -/
theorem change_opposed (pre : List P) (p : P) (post : List P) (a b : P → Nat) :
    riseCount (pre ++ p :: post) a b p + total (pre ++ post) (riseCount (pre ++ p :: post) a b) =
      fallCount (pre ++ p :: post) a b p + total (pre ++ post) (fallCount (pre ++ p :: post) a b) :=
  (total_split _ pre p post).symm.trans
    ((change_balances (pre ++ p :: post) a b).trans (total_split _ pre p post))

/-- Where `p`'s position rises, the rest's summed position falls. -/
theorem rest_falls_of_rises {pre post : List P} {p : P} {a b : P → Nat}
    (rises : fallCount (pre ++ p :: post) a b p < riseCount (pre ++ p :: post) a b p) :
    total (pre ++ post) (riseCount (pre ++ p :: post) a b) <
      total (pre ++ post) (fallCount (pre ++ p :: post) a b) :=
  Nat.lt_of_add_lt_add_left (n := riseCount (pre ++ p :: post) a b p)
    (Nat.lt_of_le_of_lt (Nat.le_of_eq (change_opposed pre p post a b))
      (Nat.add_lt_add_right rises _))

/-- One member strictly below and none above make the total strictly below. -/
theorem total_lt_of_mem {f g : P → Nat} {p : P} :
    ∀ {ps : List P}, p ∈ ps → f p < g p → (∀ q, q ∈ ps → f q ≤ g q) → total ps f < total ps g
  | _ :: qs, .head _, lt, le => Nat.lt_of_lt_of_le (Nat.add_lt_add_right lt _)
      (Nat.add_le_add_left (total_le qs fun r mem => le r (.tail _ mem)) _)
  | q :: _, .tail _ mem, lt, le => Nat.lt_of_le_of_lt (Nat.add_le_add_right (le q (.head _)) _)
      (Nat.add_lt_add_left (total_lt_of_mem mem lt fun r mem' => le r (.tail q mem')) _)

/-- No change raises every part's position. -/
theorem not_all_rise {ps : List P} {p : P} (mem : p ∈ ps) (a b : P → Nat) :
    ¬ ∀ q, q ∈ ps → fallCount ps a b q < riseCount ps a b q :=
  fun all => Nat.lt_irrefl _
    (Nat.lt_of_lt_of_le (total_lt_of_mem mem (all p mem) fun q inside => Nat.le_of_lt (all q inside))
      (Nat.le_of_eq (change_balances ps a b)))

/-- Each part of a list either has `g` below `f` somewhere, or `f` at most `g` everywhere. -/
theorem below_somewhere_or_not (f g : P → Nat) :
    ∀ ps : List P, (∃ q, q ∈ ps ∧ g q < f q) ∨ ∀ q, q ∈ ps → f q ≤ g q
  | [] => .inr fun _ no => nomatch no
  | q :: qs => match Nat.lt_or_ge (g q) (f q) with
    | .inl lt => .inl ⟨q, .head qs, lt⟩
    | .inr ge => match below_somewhere_or_not f g qs with
      | .inl ⟨r, mem, lt⟩ => .inl ⟨r, .tail q mem, lt⟩
      | .inr le => .inr fun r mem => match mem with
        | .head _ => ge
        | .tail _ mem => le r mem

/-- A part's rise in position needs another part's fall. -/
theorem rise_needs_fall {ps : List P} {p : P} (mem : p ∈ ps) {a b : P → Nat}
    (rises : fallCount ps a b p < riseCount ps a b p) :
    ∃ q, q ∈ ps ∧ riseCount ps a b q < fallCount ps a b q :=
  match below_somewhere_or_not (fallCount ps a b) (riseCount ps a b) ps with
  | .inl found => found
  | .inr le => absurd (change_balances ps a b) fun same => Nat.lt_irrefl _
      (Nat.lt_of_lt_of_le (total_lt_of_mem mem rises le) (Nat.le_of_eq same))

/-! ## Greatest parts -/

/-- `g` is a greatest part of the family under the amounts: no part's amount exceeds its own. -/
def Greatest (ps : List P) (a : P → Nat) (g : P) : Prop :=
  ∀ q, q ∈ ps → a q ≤ a g

/-- A greatest part's position is not below the family's: the family's total is at most its
amount counted once for each part. -/
theorem greatest_not_behind {ps : List P} {a : P → Nat} {g : P} (greatest : Greatest ps a g) :
    total ps a ≤ ps.length * a g :=
  Nat.le_trans (total_le ps greatest) (Nat.le_of_eq (total_const (a g) ps))

/-- Every nonempty family has a greatest part. -/
theorem greatest_exists (a : P → Nat) :
    ∀ (p : P) (ps : List P), ∃ g, g ∈ p :: ps ∧ Greatest (p :: ps) a g
  | p, [] => ⟨p, .head [], fun _ mem => match mem with
      | .head _ => Nat.le_refl _
      | .tail _ no => nomatch no⟩
  | p, q :: qs => match greatest_exists a q qs with
    | ⟨g, mem, greatest⟩ => match Nat.lt_or_ge (a p) (a g) with
      | .inl lt => ⟨g, .tail p mem, fun r inside => match inside with
          | .head _ => Nat.le_of_lt lt
          | .tail _ rest => greatest r rest⟩
      | .inr ge => ⟨p, .head _, fun r inside => match inside with
          | .head _ => Nat.le_refl _
          | .tail _ rest => Nat.le_trans (greatest r rest) ge⟩

/-! ## Least parts, and equal shares -/

/-- `l` is a least part of the family under the amounts: no part's amount is below its own. -/
def Least (ps : List P) (a : P → Nat) (l : P) : Prop :=
  ∀ q, q ∈ ps → a l ≤ a q

/-- **A least part's position is not above the family's**: its amount counted once for each part
is at most the family's total. -/
theorem least_not_ahead {ps : List P} {a : P → Nat} {l : P} (least : Least ps a l) :
    ps.length * a l ≤ total ps a :=
  Nat.le_trans (Nat.le_of_eq (total_const (a l) ps).symm) (total_le ps least)

/-- Every nonempty family has a least part. -/
theorem least_exists (a : P → Nat) :
    ∀ (p : P) (ps : List P), ∃ l, l ∈ p :: ps ∧ Least (p :: ps) a l
  | p, [] => ⟨p, .head [], fun _ mem => match mem with
      | .head _ => Nat.le_refl _
      | .tail _ no => nomatch no⟩
  | p, q :: qs => match least_exists a q qs with
    | ⟨l, mem, least⟩ => match Nat.lt_or_ge (a l) (a p) with
      | .inl lt => ⟨l, .tail p mem, fun r inside => match inside with
          | .head _ => Nat.le_of_lt lt
          | .tail _ rest => least r rest⟩
      | .inr ge => ⟨p, .head _, fun r inside => match inside with
          | .head _ => Nat.le_refl _
          | .tail _ rest => Nat.le_trans ge (least r rest)⟩

/-- **Guarding everywhere, little anywhere.** Where a family's total is at most `T`, its least
part, counted once for each of at least `n` parts, is at most `T`: more parts with no more in all
leave the least part no more. -/
theorem least_bound {ps : List P} {a : P → Nat} {l : P} (least : Least ps a l) {T n : Nat}
    (within : total ps a ≤ T) (many : n ≤ ps.length) : n * a l ≤ T :=
  Nat.le_trans (Nat.mul_le_mul_right (a l) many) (Nat.le_trans (least_not_ahead least) within)

/-- **Equal shares support exactly where the share meets the greatest need.** Each part of a
family receiving the share `q`, every part's need is met exactly where the greatest part's is. -/
theorem equal_share_iff {ps : List P} {need : P → Nat} {g : P} (mem : g ∈ ps)
    (greatest : Greatest ps need g) {q : Nat} :
    (∀ p, p ∈ ps → need p ≤ q) ↔ need g ≤ q :=
  ⟨fun all => all g mem, fun le p inside => Nat.le_trans (greatest p inside) le⟩

/-- **Equal shares cost more where needs differ.** Equal shares meeting every need give at least
the greatest need counted once for each part, which is the family's total need exactly where no
need falls short of the greatest, and exceeds it where one does. -/
theorem equal_share_exceeds {ps : List P} {need : P → Nat} {g : P} (greatest : Greatest ps need g)
    {p : P} (mem : p ∈ ps) (short : need p < need g) : total ps need < ps.length * need g :=
  Nat.lt_of_lt_of_le (total_lt_of_mem mem short greatest)
    (Nat.le_of_eq (total_const (need g) ps))

/-- Where every need is the greatest, equal shares meeting it give exactly the total need. -/
theorem equal_share_even {ps : List P} {need : P → Nat} {g : P}
    (even : ∀ p, p ∈ ps → need p = need g) : total ps need = ps.length * need g :=
  (total_congr_on even).trans (total_const (need g) ps)

/-- **Enough in all, short for one.** Two parts needing one and three: four given is the sum of
the needs, so given by need it supports both, while in equal shares of two, which also total four,
the part needing three is not supported. -/
theorem uneven_short :
    total [1, 3] id = 4 ∧ [1, 3].length * 2 = 4 ∧ ¬ (∀ p, p ∈ [1, 3] → id p ≤ 2) :=
  ⟨rfl, rfl, fun all => absurd (all 3 (.tail _ (.head _))) (Nat.not_succ_le_self 2)⟩


/-! ## What position reads -/

/-- The change from `a` to `b` keeps every part's position: at each part the rise count is the
fall count. With signed amounts, each part's position `n * a p - total ps a` is the same read
under `b`. -/
def Keeps (ps : List P) (a b : P → Nat) : Prop :=
  ∀ p, p ∈ ps → riseCount ps a b p = fallCount ps a b p

/-- A family with a member has a part. -/
theorem length_pos_of_mem {p : P} : ∀ {ps : List P}, p ∈ ps → 0 < ps.length
  | _ :: _, _ => Nat.succ_pos _

/-- Four terms regrouped. -/
theorem regroup (x y u v : Nat) : (x + y) + (u + v) = (x + v) + (y + u) :=
  (congrArg ((x + y) + ·) (Nat.add_comm u v)).trans (Nat.add_add_add_comm x y v u)

/-- **Position reads amounts up to a common amount.** A change keeps every part's position
exactly where every part's amount changes by one amount common to all: for any two parts, what
one had before with what the other has after is what the other had before with what the one has
after. -/
theorem keeps_iff_common {ps : List P} {a b : P → Nat} :
    Keeps ps a b ↔ ∀ p q, p ∈ ps → q ∈ ps → a p + b q = a q + b p :=
  ⟨fun keeps p q inp inq =>
    have hp : ps.length * b p + total ps a = ps.length * a p + total ps b := keeps p inp
    have hq : ps.length * b q + total ps a = ps.length * a q + total ps b := keeps q inq
    have scaled : ps.length * (a p + b q) + (total ps a + total ps b) =
        ps.length * (a q + b p) + (total ps a + total ps b) :=
      calc ps.length * (a p + b q) + (total ps a + total ps b)
          = (ps.length * a p + total ps b) + (ps.length * b q + total ps a) := by
            rw [Nat.left_distrib]; exact regroup _ _ _ _
        _ = (ps.length * b p + total ps a) + (ps.length * a q + total ps b) := by
            rw [← hp, hq]
        _ = ps.length * (a q + b p) + (total ps a + total ps b) := by
            rw [Nat.left_distrib, Nat.add_comm (ps.length * a q) (ps.length * b p)]
            exact Nat.add_add_add_comm _ _ _ _
    Nat.eq_of_mul_eq_mul_left (length_pos_of_mem inp) (Becoming.add_right_cancel _ scaled),
   fun common p inp =>
    have summed : ps.length * a p + total ps b = total ps a + ps.length * b p :=
      calc ps.length * a p + total ps b
          = total ps (fun q => a p + b q) :=
            ((congrArg (· + total ps b) (total_const (a p) ps).symm).trans
              (total_add (fun _ => a p) b ps).symm)
        _ = total ps (fun q => a q + b p) := total_congr_on fun q inq => common p q inp inq
        _ = total ps a + ps.length * b p :=
            (total_add a (fun _ => b p) ps).trans
              (congrArg (total ps a + ·) (total_const (b p) ps))
    (Nat.add_comm _ _).trans summed.symm⟩

/-- Adding one amount to every part keeps every position, and adds it to the total once for
each part. -/
theorem keeps_add (ps : List P) (a : P → Nat) (c : Nat) :
    Keeps ps a (fun p => a p + c) ∧ total ps (fun p => a p + c) = total ps a + ps.length * c :=
  ⟨keeps_iff_common.mpr fun p q _ _ =>
    (Nat.add_assoc _ _ _).symm.trans
      ((congrArg (· + c) (Nat.add_comm (a p) (a q))).trans (Nat.add_assoc _ _ _)),
   (total_add a (fun _ => c) ps).trans (congrArg (total ps a + ·) (total_const c ps))⟩

/-- Taking the least part's amount from every part keeps every position, leaves the least part
at nothing, and leaves the total short of the family's by that amount counted once for each
part: the spread above the least part. -/
theorem keeps_least {ps : List P} {a : P → Nat} {l : P} (least : Least ps a l) :
    Keeps ps a (fun p => a p - a l) ∧ a l - a l = 0 ∧
      total ps (fun p => a p - a l) + ps.length * a l = total ps a :=
  ⟨keeps_iff_common.mpr fun p q inp inq =>
    calc a p + (a q - a l) = (a l + (a p - a l)) + (a q - a l) :=
          congrArg (· + (a q - a l)) (add_sub_of_le (least p inp)).symm
      _ = (a l + (a q - a l)) + (a p - a l) := Nat.add_right_comm _ _ _
      _ = a q + (a p - a l) := congrArg (· + (a p - a l)) (add_sub_of_le (least q inq)),
   Nat.sub_self (a l),
   (congrArg (_ + ·) (total_const (a l) ps).symm).trans
    ((total_add (fun p => a p - a l) (fun _ => a l) ps).symm.trans
      (total_congr_on fun q inq => Naturals.sub_add_cancel (least q inq)))⟩

/-- **The total with given positions is at least the spread.** Whatever profile keeps every
position, its total with the least part's amount counted once for each part is at least the
family's total. -/
theorem spread_le {ps : List P} {a b : P → Nat} {l : P} (inl : l ∈ ps) (keeps : Keeps ps a b) :
    total ps a ≤ total ps b + ps.length * a l :=
  Nat.le_trans (Nat.le_add_left _ (ps.length * b l))
    (Nat.le_of_eq ((keeps l inl).trans (Nat.add_comm _ _)))

/-- **No position bounds the total from above.** In a family with a part, every bound is
exceeded by a profile that keeps every position. -/
theorem keeps_exceeds {ps : List P} {p : P} (inp : p ∈ ps) (a : P → Nat) (r : Nat) :
    ∃ b, Keeps ps a b ∧ r < total ps b :=
  ⟨fun q => a q + (r + 1), (keeps_add ps a (r + 1)).1,
   Nat.lt_of_lt_of_le (Nat.lt_succ_self r)
    (Nat.le_trans (Nat.le_mul_of_pos_left (r + 1) (length_pos_of_mem inp))
      (Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq (keeps_add ps a (r + 1)).2.symm)))⟩

/-- **Positions bound the total from below exactly by the spread.** With `l` a least part, every
profile keeping every position has its total above `r` exactly where the spread above the least
part is above `r`. -/
theorem exceeds_iff_spread {ps : List P} {a : P → Nat} {l : P} (inl : l ∈ ps)
    (least : Least ps a l) (r : Nat) :
    (∀ b, Keeps ps a b → r < total ps b) ↔ r + ps.length * a l < total ps a :=
  ⟨fun all => Nat.lt_of_lt_of_le
      (Nat.add_lt_add_right (all _ (keeps_least least).1) _)
      (Nat.le_of_eq (keeps_least least).2.2),
   fun above _ keeps => Nat.lt_of_add_lt_add_right
      (Nat.lt_of_lt_of_le above (spread_le inl keeps))⟩

end RelativePosition

open RelativePosition

/-! ## Read on a flow: what position does not protect -/

namespace Flow

variable {F C : Type} {L : Flow F C} {W : Web F C}

/-- One reading of positions: what the flow records `f` as taking from `c` over the steps
before `t`. -/
def drawn (L : Flow F C) (c : C) : Nat → F → Nat
  | 0, _ => 0
  | t + 1, f => L.drawn c t f + L.take t f c

/-- The counting law read on a flow. Positions read by what each part of a family has drawn from a
condition, between any two steps `s` and `t`: at `t` the ahead counts total what the behind counts
total; the change of position from `s` to `t` is zero-sum; it raises no part's position unless it
lowers another's, so not every part's; and the family has a greatest part, whose position is not
below the family's. No hypothesis on the flow is used. -/
theorem drawn_positions (L : Flow F C) (c : C) (s t : Nat) (p : F) (ps : List F) :
    total (p :: ps) (fun q => (p :: ps).length * L.drawn c t q) =
        total (p :: ps) (fun _ => total (p :: ps) (L.drawn c t)) ∧
      total (p :: ps) (riseCount (p :: ps) (L.drawn c s) (L.drawn c t)) =
        total (p :: ps) (fallCount (p :: ps) (L.drawn c s) (L.drawn c t)) ∧
      (∀ q, q ∈ p :: ps →
        fallCount (p :: ps) (L.drawn c s) (L.drawn c t) q <
          riseCount (p :: ps) (L.drawn c s) (L.drawn c t) q →
        ∃ r, r ∈ p :: ps ∧ riseCount (p :: ps) (L.drawn c s) (L.drawn c t) r <
          fallCount (p :: ps) (L.drawn c s) (L.drawn c t) r) ∧
      ¬ (∀ q, q ∈ p :: ps → fallCount (p :: ps) (L.drawn c s) (L.drawn c t) q <
          riseCount (p :: ps) (L.drawn c s) (L.drawn c t) q) ∧
      ∃ g, g ∈ p :: ps ∧ Greatest (p :: ps) (L.drawn c t) g ∧
        total (p :: ps) (L.drawn c t) ≤ (p :: ps).length * L.drawn c t g :=
  ⟨positions_balance (p :: ps) (L.drawn c t),
   change_balances (p :: ps) (L.drawn c s) (L.drawn c t),
   fun _ mem rises => rise_needs_fall mem rises,
   not_all_rise (.head ps) (L.drawn c s) (L.drawn c t),
   match greatest_exists (L.drawn c t) p ps with
   | ⟨g, mem, greatest⟩ => ⟨g, mem, greatest, greatest_not_behind greatest⟩⟩

/-- With balance at the condition across each of `n` steps of joint excess from `T`, a start
below `n + m` leaves the level below `m`. No renewal need be gated. -/
theorem excess_leaves_below {c : C} {m T n : Nat}
    (balances : ∀ k, k < n → L.BalancesOn W [c] (T + k))
    (excess : ∀ k, k < n → L.given (T + k) c < L.taken (T + k) c)
    (start : W.level T c < n + m) : W.level (T + n) c < m :=
  Nat.lt_of_add_lt_add_left (n := n)
    (Nat.lt_of_le_of_lt
      (Nat.le_trans (Nat.le_of_eq (Nat.add_comm n _)) (excess_bounded_at n balances excess))
      start)

/-- The dependence that ends a part at the end of the race, exactly: with balance at the
condition across `n` steps of joint excess from `T`, a part that at step `T + n` requires the
condition, at a need greater than the level at `T` less `n`, and is active there only while
supported, is not active there. Its position does not enter, and no renewal need be gated. -/
theorem ends_at_race_end {c : C} {T n : Nat} {g : F}
    (balances : ∀ k, k < n → L.BalancesOn W [c] (T + k))
    (excess : ∀ k, k < n → L.given (T + k) c < L.taken (T + k) c)
    (start : W.level T c < n + W.need (T + n) g c)
    (depends : W.requires (T + n) g c)
    (dependent : W.active (T + n) g → W.Supported (T + n) g) :
    ¬ W.active (T + n) g :=
  ends_below_at dependent (excess_leaves_below balances excess start) depends (Nat.le_refl _)

/-- The race ends the greatest parts with the condition. Under balance, with only active
formations giving, activity needing support and renewal gated at `m`, `n` steps of joint excess
from `T` starting below `n + m`: for every family and every reading of positions, the positions
change across the race by a zero-sum count while the level falls by at least `n`; the level is
below `m` from `T + n` on; and from then on every part depending on the condition at a need of at
least `m` is inactive, whatever its position, the greatest parts included. -/
theorem race_ends_greatest (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {c : C} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → 0 < L.give t f c →
      W.requires t f c ∧ m ≤ W.need t f c)
    {T n : Nat} (excess : ∀ k, k < n → L.given (T + k) c < L.taken (T + k) c)
    (start : W.level T c < n + m) (ps : List F) (pos : Nat → F → Nat) :
    total ps (riseCount ps (pos T) (pos (T + n))) = total ps (fallCount ps (pos T) (pos (T + n))) ∧
      W.level (T + n) c + n ≤ W.level T c ∧
      (∀ k, W.level (T + n + k) c < m) ∧
      ∀ k g, g ∈ ps → Greatest ps (pos (T + n + k)) g → W.requires (T + n + k) g c →
        m ≤ W.need (T + n + k) g c → ¬ W.active (T + n + k) g :=
  ⟨change_balances ps (pos T) (pos (T + n)),
   excess_bounded_at n (fun k _ => balances.on [c] (T + k)) excess,
   stays_below balances acting dependent gated
     (excess_leaves_below (fun k _ => balances.on [c] (T + k)) excess start),
   fun k g _ _ => joint_excess_ends balances acting dependent gated excess start k g⟩

/-- In a family whose parts all depend on the condition at a need of at least `m` from the end
of the race on, at every later step there is a greatest part, and every greatest part is
inactive. -/
theorem greatest_end_for_good (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {c : C} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → 0 < L.give t f c →
      W.requires t f c ∧ m ≤ W.need t f c)
    {T n : Nat} (excess : ∀ k, k < n → L.given (T + k) c < L.taken (T + k) c)
    (start : W.level T c < n + m) (p : F) (ps : List F) (pos : Nat → F → Nat)
    (all : ∀ k g, g ∈ p :: ps → W.requires (T + n + k) g c ∧ m ≤ W.need (T + n + k) g c) :
    ∀ k, (∃ g, g ∈ p :: ps ∧ Greatest (p :: ps) (pos (T + n + k)) g) ∧
      ∀ g, g ∈ p :: ps → Greatest (p :: ps) (pos (T + n + k)) g → ¬ W.active (T + n + k) g :=
  fun k => ⟨greatest_exists (pos (T + n + k)) p ps, fun g mem greatest =>
    (race_ends_greatest balances acting dependent gated excess start (p :: ps) pos).2.2.2 k g mem
      greatest (all k g mem).1 (all k g mem).2⟩

end Flow

/-! ## Witnesses -/

namespace DrawingMore

/-- Two parts drawing from one condition: one unit each at the first step, then one and three. -/
def flow : Flow Bool Unit where
  present _ := [false, true]
  take t f _ := match t, f with
    | 0, _ => 1
    | _ + 1, false => 1
    | _ + 1, true => 3
  give _ _ _ := 0

/-- Across the second step every part draws more, and the part that draws less falls in position
while the other rises: the count is zero-sum whatever the amounts do. -/
theorem grow_and_fall :
    (∀ q, flow.drawn () 1 q < flow.drawn () 2 q) ∧
      riseCount [false, true] (flow.drawn () 1) (flow.drawn () 2) false <
        fallCount [false, true] (flow.drawn () 1) (flow.drawn () 2) false ∧
      fallCount [false, true] (flow.drawn () 1) (flow.drawn () 2) true <
        riseCount [false, true] (flow.drawn () 1) (flow.drawn () 2) true :=
  ⟨fun q => match q with
    | false => show 1 < 2 from Nat.lt_succ_self 1
    | true => show 1 < 4 from Nat.succ_lt_succ (Nat.succ_pos 2),
   show 6 < 8 from Nat.lt_succ_of_lt (Nat.lt_succ_self 6),
   show 8 < 10 from Nat.lt_succ_of_lt (Nat.lt_succ_self 8)⟩

end DrawingMore

namespace Race

/-- A renewer and two parts sharing one condition. -/
abbrev Member := Witnesses.Member

def level : Nat → Nat := Witnesses.profile [2, 1] 0

def live : Nat → Prop := Witnesses.profile [True, True] False

def present : Nat → List Member := Exceeding.present

/-- The renewer gives two units; the first part takes two and the second one. -/
def flow : Flow Member Unit := Witnesses.relay present 2 2 1

/-- Each depends on the condition at need one, the renewer included. -/
def web : Web Member Unit := Witnesses.relayWeb level fun t _ => live t

theorem balances : flow.Balances web
  | 0, () => rfl
  | 1, () => rfl
  | _ + 2, () => rfl

theorem live_of_present : ∀ t f, f ∈ present t → live t
  | 0, _, _ => trivial
  | 1, _, _ => trivial
  | _ + 2, _, no => nomatch no

theorem acting : flow.Acting web :=
  fun t f _ present _ => live_of_present t f present

theorem dependent : web.Dependent
  | 0, _, _, _, _ => Nat.succ_le_succ (Nat.zero_le 1)
  | 1, _, _, _, _ => Nat.le_refl 1
  | _ + 2, _, dead, _, _ => nomatch dead

theorem gated : ∀ t f, f ∈ flow.present t → 0 < flow.give t f () →
    web.requires t f () ∧ 1 ≤ web.need t f () :=
  fun _ _ _ _ => ⟨trivial, Nat.le_refl 1⟩

theorem drawn_renewer : ∀ t, flow.drawn () t .renewer = 0
  | 0 => rfl
  | t + 1 => drawn_renewer t

theorem drawn_second_le : ∀ t, flow.drawn () t .second ≤ flow.drawn () t .first
  | 0 => Nat.le_refl 0
  | t + 1 => Nat.add_le_add (drawn_second_le t) (Nat.le_succ 1)

/-- Read by what each has drawn, the first part is greatest at every step. -/
theorem first_greatest (t : Nat) :
    Greatest [Witnesses.Member.renewer, Witnesses.Member.first, Witnesses.Member.second] (flow.drawn () t) .first :=
  fun q _ => match q with
    | .renewer => Nat.le_trans (Nat.le_of_eq (drawn_renewer t)) (Nat.zero_le _)
    | .first => Nat.le_refl _
    | .second => drawn_second_le t

theorem excess : ∀ k, k < 2 → flow.given (0 + k) () < flow.taken (0 + k) ()
  | 0, _ => show 2 < 3 from Nat.lt_succ_self 2
  | 1, _ => show 2 < 3 from Nat.lt_succ_self 2
  | _ + 2, late => absurd late (Nat.not_lt_of_le (Nat.le_add_left 2 _))

/-- The family racing at the condition. -/
def all : List Member := [.renewer, .first, .second]

theorem first_rises :
    fallCount all (flow.drawn () 0) (flow.drawn () 2) .first <
      riseCount all (flow.drawn () 0) (flow.drawn () 2) .first :=
  show 6 < 12 from Nat.lt_of_lt_of_le (Nat.lt_succ_self 6) (Nat.le_add_right 7 5)

/-- The race ends the greatest part with the condition. While they take part, each part takes
within what the step gives and together they take more. Read by what each has drawn, the first
part is greatest at every step, and across the race it rises in position while the rest's summed
position falls; the race ends the renewal, the greatest part is inactive from step two on, and
so is every part. -/
theorem greatest_ends :
    (∀ t, t < 2 → flow.WithinOwn t () ∧ ¬ flow.WithinJoint t ()) ∧
      (∀ t, Greatest all (flow.drawn () t) .first) ∧
      fallCount all (flow.drawn () 0) (flow.drawn () 2) .first <
        riseCount all (flow.drawn () 0) (flow.drawn () 2) .first ∧
      total [Witnesses.Member.renewer, Witnesses.Member.second] (riseCount all (flow.drawn () 0) (flow.drawn () 2)) <
        total [Witnesses.Member.renewer, Witnesses.Member.second] (fallCount all (flow.drawn () 0) (flow.drawn () 2)) ∧
      (∀ k, ¬ web.active (0 + 2 + k) .first) ∧
      ∀ k f, ¬ web.active (0 + 2 + k) f :=
  have within : ∀ t, t < 2 → flow.WithinOwn t ()
    | 0, _ => fun f _ => match f with
      | .renewer => Nat.zero_le 2
      | .first => Nat.le_refl 2
      | .second => Nat.le_succ 1
    | 1, _ => fun f _ => match f with
      | .renewer => Nat.zero_le 2
      | .first => Nat.le_refl 2
      | .second => Nat.le_succ 1
    | _ + 2, late => absurd late (Nat.not_lt_of_le (Nat.le_add_left 2 _))
  have race := Flow.race_ends_greatest (c := ()) (m := 1) balances acting dependent gated
    excess (show 2 < 2 + 1 from Nat.lt_succ_self 2) all (flow.drawn ())
  ⟨fun t below => match t, below with
    | 0, below => ⟨within 0 below, fun joint => Nat.not_succ_le_self 2 (show 3 ≤ 2 from joint)⟩
    | 1, below => ⟨within 1 below, fun joint => Nat.not_succ_le_self 2 (show 3 ≤ 2 from joint)⟩
    | _ + 2, late => absurd late (Nat.not_lt_of_le (Nat.le_add_left 2 _)),
   first_greatest, first_rises,
   rest_falls_of_rises (pre := [Witnesses.Member.renewer]) (p := Witnesses.Member.first) (post := [Witnesses.Member.second])
     first_rises,
   fun k => race.2.2.2 k .first (.tail _ (.head _)) (first_greatest _) trivial (Nat.le_refl 1),
   fun k f => Flow.joint_excess_ends (c := ()) (m := 1) balances acting dependent gated excess
     (show 2 < 2 + 1 from Nat.lt_succ_self 2) k f trivial (Nat.le_refl 1)⟩

end Race

namespace Lasting

/-! ## The same positions, the condition standing -/

abbrev Member := Witnesses.Member

/-- At every step the renewer gives two units, as in the race, the first part takes one and the
second none. -/
def flow : Flow Member Unit := Witnesses.relay (fun _ => [.renewer, .first, .second]) 2 1 0

/-- The condition stands at one more than the step count, and each is active at every step and
depends on it at need one. -/
def web : Web Member Unit := Witnesses.relayWeb (fun t => t + 1) fun _ _ => True

theorem balances : flow.Balances web := fun _ () => rfl

theorem acting : flow.Acting web := fun _ _ _ _ _ => trivial

theorem dependent : web.Dependent := fun t _ _ _ _ => Nat.succ_le_succ (Nat.zero_le t)

/-- The two that take in the race. -/
def racers : List Member := [.first, .second]

/-- At every step the race's first part has drawn as much more than here as its second has. -/
theorem drawn_common : ∀ t,
    Race.flow.drawn () t .first + flow.drawn () t .second =
      Race.flow.drawn () t .second + flow.drawn () t .first
  | 0 => rfl
  | t + 1 => by
    show (Race.flow.drawn () t .first + 2) + flow.drawn () t .second =
        (Race.flow.drawn () t .second + 1) + (flow.drawn () t .first + 1)
    rw [Nat.add_right_comm, drawn_common t, Nat.add_add_add_comm]

/-- Read by what each has drawn, the race and this flow give the two racers the same positions
at every step. -/
theorem keeps (t : Nat) : Keeps racers (Race.flow.drawn () t) (flow.drawn () t) :=
  keeps_iff_common.mpr fun p q inp inq => match p, q, inp, inq with
    | .first, .first, _, _ => rfl
    | .second, .second, _, _ => rfl
    | .first, .second, _, _ => drawn_common t
    | .second, .first, _, _ => (drawn_common t).symm

theorem drawn_second : ∀ t, flow.drawn () t .second = 0
  | 0 => rfl
  | t + 1 => drawn_second t

theorem drawn_renewer : ∀ t, flow.drawn () t .renewer = 0
  | 0 => rfl
  | t + 1 => drawn_renewer t

theorem first_greatest (t : Nat) : Greatest racers (flow.drawn () t) .first :=
  fun q _ => match q with
    | .renewer => Nat.le_trans (Nat.le_of_eq (drawn_renewer t)) (Nat.zero_le _)
    | .first => Nat.le_refl _
    | .second => Nat.le_trans (Nat.le_of_eq (drawn_second t)) (Nat.zero_le _)

/-- **The same positions, the opposite fates.** Read by what each racer has drawn, this flow and
the race give the two racers the same positions at every step, so the same greatest part and the
same changes of position, and the first part's position rises across the race's two steps in
both. Both balance, give only while active and keep activity supported, and in both the renewer
gives two units at each step it takes part. In the race the condition is drawn jointly beyond
what is given and every part is inactive from step two on; here what is taken is within what is
given at every step, the condition rises and every part is active at every step. What separates
them is the total drawn, which positions do not read: at every step the race's two racers have
drawn twice the step count more. -/
theorem same_positions_apart :
    (∀ t, Keeps racers (Race.flow.drawn () t) (flow.drawn () t)) ∧
      (∀ t, Greatest racers (Race.flow.drawn () t) .first ∧
        Greatest racers (flow.drawn () t) .first) ∧
      fallCount racers (flow.drawn () 0) (flow.drawn () 2) .first <
        riseCount racers (flow.drawn () 0) (flow.drawn () 2) .first ∧
      fallCount racers (Race.flow.drawn () 0) (Race.flow.drawn () 2) .first <
        riseCount racers (Race.flow.drawn () 0) (Race.flow.drawn () 2) .first ∧
      flow.Balances web ∧ flow.Acting web ∧ web.Dependent ∧
      (∀ t, flow.given t () = 2) ∧ (∀ t, flow.WithinJoint t ()) ∧ (∀ t f, web.active t f) ∧
      (∀ t, Race.flow.given t () < Race.flow.taken t () ∨ t ≥ 2) ∧
      ∀ k f, ¬ Race.web.active (0 + 2 + k) f :=
  ⟨keeps,
   fun t => ⟨fun q _ => match q with
      | .renewer => Nat.le_trans (Nat.le_of_eq (Race.drawn_renewer t)) (Nat.zero_le _)
      | .first => Nat.le_refl _
      | .second => Race.drawn_second_le t,
     first_greatest t⟩,
   show 2 < 4 from Nat.lt_of_lt_of_le (Nat.lt_succ_self 2) (Nat.le_succ 3),
   show 6 < 8 from Nat.lt_of_lt_of_le (Nat.lt_succ_self 6) (Nat.le_succ 7),
   balances, acting, dependent,
   fun _ => rfl,
   fun _ => Nat.le_succ 1,
   fun _ _ => trivial,
   fun t => match t with
    | 0 => .inl (show 2 < 3 from Nat.lt_succ_self 2)
    | 1 => .inl (show 2 < 3 from Nat.lt_succ_self 2)
    | _ + 2 => .inr (Nat.le_add_left 2 _),
   Race.greatest_ends.2.2.2.2.2⟩

end Lasting

namespace Restored

/-- A renewer that requires nothing, and a part depending on the condition. -/
inductive Member where
  | renewer
  | part

def level : Nat → Nat := Witnesses.profile [1, 0] 1

def takeAt : Nat → Nat := Witnesses.profile [1] 0

def giveAt : Nat → Nat := Witnesses.profile [0, 1] 0

def live : Nat → Prop := Witnesses.profile [True, False] True

/-- The part takes one unit at the first step; the renewer gives one at the second. -/
def flow : Flow Member Unit where
  present _ := [.renewer, .part]
  take t f _ := match f with
    | .renewer => 0
    | .part => takeAt t
  give t f _ := match f with
    | .renewer => giveAt t
    | .part => 0

/-- The part depends on the condition at need one; the renewer requires nothing. -/
def web : Web Member Unit where
  level t _ := level t
  active t f := match f with
    | .renewer => True
    | .part => live t
  requires _ f _ := match f with
    | .renewer => False
    | .part => True
  need _ _ _ := 1
  draws _ f _ := match f with
    | .renewer => False
    | .part => True

theorem balances : flow.Balances web
  | 0, () => rfl
  | 1, () => rfl
  | _ + 2, () => rfl

theorem acting : flow.Acting web :=
  fun _ f _ _ gives => match f with
    | .renewer => trivial
    | .part => absurd gives (Nat.lt_irrefl 0)

theorem dependent : web.Dependent
  | _, .renewer, _, _, no => nomatch no
  | 0, .part, _, _, _ => Nat.le_refl 1
  | 1, .part, dead, _, _ => nomatch dead
  | _ + 2, .part, _, _, _ => Nat.le_refl 1

theorem drawn_renewer : ∀ t, flow.drawn () t .renewer = 0
  | 0 => rfl
  | t + 1 => drawn_renewer t

/-- Gated renewal is needed for the ending to last. Here the race is one step of joint excess,
and the part, greatest at every step by what each has drawn, ends at the race's end
(`Flow.ends_at_race_end`); the renewer, which gives at that step and requires nothing, restores
the level, and the part is active from step two on. -/
theorem returns :
    flow.Balances web ∧ flow.Acting web ∧ web.Dependent ∧
      flow.given 0 () < flow.taken 0 () ∧
      (∀ t, Greatest [.renewer, .part] (flow.drawn () t) .part) ∧
      ¬ web.active 1 .part ∧
      (0 < flow.give 1 .renewer () ∧ ¬ web.requires 1 .renewer ()) ∧
      ∀ k, web.active (k + 2) .part :=
  have excess : flow.given 0 () < flow.taken 0 () := show 0 < 1 from Nat.zero_lt_one
  ⟨balances, acting, dependent, excess,
   fun t q _ => match q with
     | .renewer => Nat.le_trans (Nat.le_of_eq (drawn_renewer t)) (Nat.zero_le _)
     | .part => Nat.le_refl _,
   Flow.ends_at_race_end (T := 0) (n := 1) (g := Member.part)
     (fun k _ => balances.on [()] (0 + k))
     (fun k below => match k, below with
       | 0, _ => excess
       | _ + 1, late => absurd late (Nat.not_lt_of_le (Nat.le_add_left 1 _)))
     (show 1 < 1 + 1 from Nat.lt_succ_self 1) trivial (dependent 1 .part),
   ⟨show 0 < 1 from Nat.zero_lt_one, fun no => no⟩,
   fun _ => trivial⟩

end Restored

namespace Clearing

open Flow

theorem acting : flow.Acting web :=
  fun _ f _ _ gives => match f with
    | .source => trivial
    | .clearer => trivial
    | .dweller => absurd gives (Nat.lt_irrefl 0)

/-- Nothing gives to the habitat. -/
theorem habitat_ungiven : ∀ t f, f ∈ flow.present t → ¬ 0 < flow.give t f .habitat :=
  fun _ f _ gives => match f with
    | .source => Nat.lt_irrefl 0 gives
    | .clearer => Nat.lt_irrefl 0 gives
    | .dweller => Nat.lt_irrefl 0 gives

theorem drawn_source : ∀ t, flow.drawn .habitat t .source = 0
  | 0 => rfl
  | t + 1 => drawn_source t

theorem drawn_dweller : ∀ t, flow.drawn .habitat t .dweller = 0
  | 0 => rfl
  | t + 1 => drawn_dweller t

/-- A greatest part that does not depend on what it draws down continues. Read by what each has
drawn from the habitat, the clearer is the greatest part at every step. Across the first two
steps the habitat is drawn down jointly beyond what is given to it, from a level below two plus
one, and nothing gives to it, so renewal there is gated; the dweller, which depends on the
habitat at need one, is inactive from step two on (`Flow.joint_excess_ends`). The clearer does
not require the habitat, and it is active and supported at every step. -/
theorem greatest_continues :
    (∀ k, k < 2 → flow.given (0 + k) .habitat < flow.taken (0 + k) .habitat) ∧
      web.level 0 .habitat < 2 + 1 ∧
      (∀ t f, f ∈ flow.present t → ¬ 0 < flow.give t f .habitat) ∧
      (∀ t, Greatest [.source, .clearer, .dweller] (flow.drawn .habitat t) .clearer) ∧
      (∀ t, ¬ web.requires t .clearer .habitat) ∧
      (∀ t, web.active t .clearer ∧ web.Supported t .clearer) ∧
      ∀ k, ¬ web.active (0 + 2 + k) .dweller :=
  have excess : ∀ k, k < 2 → flow.given (0 + k) .habitat < flow.taken (0 + k) .habitat
    | 0, _ => show 0 < 1 from Nat.zero_lt_one
    | 1, _ => show 0 < 1 from Nat.zero_lt_one
    | _ + 2, late => absurd late (Nat.not_lt_of_le (Nat.le_add_left 2 _))
  have start : web.level 0 .habitat < 2 + 1 := show 2 < 3 from Nat.lt_succ_self 2
  ⟨excess, start, habitat_ungiven,
   fun t q _ => match q with
     | .source => Nat.le_trans (Nat.le_of_eq (drawn_source t)) (Nat.zero_le _)
     | .clearer => Nat.le_refl _
     | .dweller => Nat.le_trans (Nat.le_of_eq (drawn_dweller t)) (Nat.zero_le _),
   fun _ no => no,
   fun t => ⟨trivial, dependent t .clearer trivial⟩,
   fun k => joint_excess_ends (c := Place.habitat) (m := 1) balances acting dependent
     (fun t f present gives => absurd gives (habitat_ungiven t f present)) excess start k .dweller
     trivial (Nat.le_refl 1)⟩

/-- What the greatest part loses is a continuation with significance, and the loss needs a
significance. Under the continuation condition, from every standpoint, the clearer's part loses
the dweller, so the levels with it do not retain what has significance without it
(`clearer_loses_dweller`); where nothing has significance, the levels with the part retain everything
that has significance without it and add nothing; either way the clearer is active and supported
at every step. The continuation condition is one significance that counts the loss, not the only
one (`own_presupposition`). -/
theorem loss_needs_significance {Pos : Type} {l : Nat → Place → Nat}
    (without : flow.WithheldLevels clearerPart web l) :
    (∀ sig : Pos → Nat → Formation → Prop, Unrestricted sig → ∀ p,
        web.Adds sig p l web.level ∧ ¬ web.Retains sig p web.level l) ∧
      (∀ p : Pos, web.Retains (fun _ _ _ => False) p web.level l ∧
        ¬ web.Adds (fun _ _ _ => False) p l web.level) ∧
      ∀ t, web.active t .clearer ∧ web.Supported t .clearer :=
  ⟨fun _ unrestricted p => ⟨(clearer_loses_dweller without unrestricted p).1,
     (clearer_loses_dweller without unrestricted p).2.1⟩,
   fun _ => ⟨fun _ _ no => (nomatch no), fun ⟨_, _, no, _⟩ => no⟩,
   fun t => ⟨trivial, dependent t .clearer trivial⟩⟩

end Clearing

end Becoming
