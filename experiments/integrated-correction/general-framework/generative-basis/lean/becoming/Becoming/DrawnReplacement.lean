import Becoming.Drift
import Becoming.DrawnShaping

/-!
# Drawn replacement: the stag hunt of drawn shaping, drawn one member at a time

`Becoming.DrawnShaping` reads the rule after shaping by readers drawn from those it selects: at a
population of `x.carrier` shapers and `x.other` others, each shaper leaves
`x.carrier · (a + hi + p) + x.other · (a + lo + p)` and each other
`(x.carrier + x.other) · (a + c + p)`, and with `lo ≤ hi` every course is locked one way or the other
from its start (`DrawnShaping.drawn_locked_either`), with a critical mass where `lo < c < hi`. Its
counts are listed, not drawn: there is no noise. `Becoming.Drift.Replacement` states replacement one
at a time among `M + 1` members with weights read from the count (`valueBy`). This module reads the
one as the other. Among `M + 1` members, `i` of them shapers, a step draws a member to leave
offspring by what the rule read at `i` gives its kind and replaces a member of the other kind: the
count goes up with the shapers' count of the rule read there (`up`), down with the others' (`down`,
alike at every count), and a step that leaves the count is weighed so that every step weighs alike
(`stay`, `whole`), which changes no ratio of the steps that change it (`steps`). The shapers' and the
others' counts of the rule read are `up` and `down` exactly (`drawn_carrier`, `drawn_other`). With no
premise beyond the hypotheses each statement names:

* **Where the rule read favours, the chain's steps favour.** At a count the rule read favours the
  shapers exactly where `down ≤ up` there (`favours_iff`); with `lo ≤ hi` the shapers' weight does not
  fall as their count grows (`up_mono`), so favouring at a count holds at every count above it, and
  favouring the others at a count holds at every count below it.
* **Fixation with drift** (`fixation`): every bound of `Drift.Replacement.fixationBy` holds, the
  potential's steps `downs` and `ups` read from the rule read at each count: over rounds of `M + 1`
  steps the histories still varied vanish geometrically, and the share fixing the shapers tends to the
  potential at the start over the potential at the top.
* **Noise leaves either lock.** From every count, the shapers present and others too, the histories
  losing every shaper weigh at least `down ^ i` times every later history (`lost_ge`), above the
  critical mass too, where without noise the share never falls below its start
  (`DrawnShaping.drawn_locks`); and those fixing them weigh at least `a ^ k` within reach of the top
  (`fixed_ge`), below the mass too, where without noise it never rises above its start
  (`DrawnShaping.drawn_from_below`).
* **But at a price whose bound falls across the distance to the mass.** Where the rule read at `s` favours the
  shapers, from `s + n` with `t` to the top, the histories over any number of steps losing every
  shaper weigh, times the shapers' weights at `s + 1 … s + n`, at most `t` times `down ^ n` times the
  whole weight (`lost_above`): as a share, at most `t` times the product of `down / up` across the
  stretch, each count above the mass multiplying it by less than one where it favours strictly. Where
  the rule read at `j + n` favours the others, from `j + 1` the histories fixing the shapers weigh,
  times `down ^ n`, at most `j + 1` times the shapers' weights at `j + 1 … j + n` times the whole
  (`fixed_below`).
* **One of each kind arising.** The potential's first step is the shapers' weights at `1 … M`
  multiplied and its last `down ^ M` (`one_each`): from one shaper among the others, fixing them stands
  to the whole, in the limit of `fixation`, as the first to the potential at the top, and from one other among the shapers, losing
  them as the last. So one shaper fixes with more weight than one other exactly where the product of
  the shapers' weights at the mixed counts exceeds `down ^ M`.
* **Risk dominance, in counts.** At an even population the rule read favours the shapers strictly
  exactly where `2 · c < hi + lo` (`risk_dominant_iff`): the shapers' state is risk dominant
  (Harsanyi and Selten 1988) exactly where the critical mass lies below the even share.
* **Witnesses.** With five members, `a = 1`, nothing shared, `c = 9`, `hi = 20` and `lo = 0`, the
  shapers are risk dominant (eighteen below twenty) and the mass lies between the ends, yet the
  product of the shapers' weights at the four mixed counts, 6,215,625, falls short of `down ^ 4`,
  6,250,000: one shaper fixes with less weight than one other (`Strong.other_first`). With the same
  `c`, `hi` and `lo` and `a = 100`, or `a = 1` with `p = 99` to every member alike, the product exceeds
  it (`Weak.shapers_first`, `Weak.shared_decides`). Without noise the critical mass is the same in all
  three (`DrawnShaping.drawn_favours_alike`).

So with drawing the capacity to shape the rule is never locked for good: either lock is left by drift
alone, with weight positive at every count and a bound on it falling across the distance from the
critical mass.
What decides which state one member arising fixes more often is the product of the weights across
every mixed count, and so the base `a` and the part `p` that comes to every member alike, which move
nothing without noise.

**Correspondence (an AI reading).** The chain is the Moran process of a two-strategy game in a
finite population read only at the steps that change the count (Nowak, Sasaki, Taylor and Fudenberg
2004; Taylor, Fudenberg, Sasaki and Nowak 2004), with the payoffs of `DrawnShaping`'s stag hunt and
each member counted among its own readers. `one_each` is the counting form of their ratio of
fixation probabilities, `ρ_shapers / ρ_others = ∏ up / down`. Under rare mutation, mutants arising one
at a time and fixing or vanishing before the next, the long-run shares of the two states stand as
those fixation probabilities (Fudenberg and Imhof 2006), so in this chain the long-run state is the
shapers' exactly where the product exceeds `down ^ M`; that limit is cited, not proved here. Kandori,
Mailath and Rob (1993) and Young (1993) take another limit, mutation rare against a deterministic
dynamic in a population of fixed size, and select the state whose basin needs more mutations to leave,
which is the risk-dominant state; Nowak and others (2004) show the Moran criterion approaching risk
dominance under weak selection. The witnesses show the two parting under strong selection
(`Strong.other_first`) and meeting under weak (`Weak.shapers_first`). That a product of weights
above `down ^ M` implies `2 · c < hi + lo` follows from pairing the counts `k` and `M + 1 - k`, the
shapers' weight being linear in the count (an argument, not checked in Lean).

What is not derived: that actual rules are read by readers drawn from those they select, or that
offspring are drawn one at a time (premises); the rare-mutation limit (cited); any time to leave a
lock beyond the geometric bound on the histories still varied; selection that accumulates counts, such
as `ChoiceCountCapture`'s, whose drift is not stated. The representation commits to discrete steps,
natural counts, constant `a`, `p`, `c`, `hi` and `lo`, and a step that leaves the count weighed only to
make every step weigh alike. Nothing here says that capture damages or supports 生生: ranking courses
needs C. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace DrawnReplacement

open Pace RuleCapture Drift.Replacement

/-! ## The chain read from the rule read -/

/-- The shapers' weight at `i` shapers among `M + 1`: the shapers' count of the rule read there. -/
def up (M a p hi lo : Nat) (i : Nat) : Nat := i * (a + hi + p) + (M + 1 - i) * (a + lo + p)

/-- The others' weight: the others' count of the rule read, alike at every count. -/
def down (M a p c : Nat) (_ : Nat) : Nat := (M + 1) * (a + c + p)

/-- A step that leaves the count, weighed so that every step weighs alike. -/
def stay (M hi lo : Nat) (i : Nat) : Nat := (M + 1 - i) * (hi - lo)

/-- What every step weighs together. -/
def whole (M a p c hi : Nat) : Nat := (M + 1) * (a + hi + p) + (M + 1) * (a + c + p)

/-- The population of `i` shapers among `M + 1`, others present. -/
def at_ (M i : Nat) (mixed : i < M + 1) : CarrierCounts :=
  ⟨i, M + 1 - i, match le_dest (Nat.le_of_lt mixed) with
    | ⟨r, same⟩ => by
      rw [same, Naturals.add_sub_cancel_left]
      exact Nat.pos_of_ne_zero fun z => Nat.lt_irrefl i (by rw [same, z] at mixed; exact mixed)⟩

theorem sub_split {M i : Nat} (le : i ≤ M + 1) : i + (M + 1 - i) = M + 1 :=
  match le_dest le with
  | ⟨r, same⟩ => by rw [same, Naturals.add_sub_cancel_left]

/-- The shapers' count of the rule read is the shapers' weight. -/
theorem drawn_carrier {a p c hi lo M i : Nat} {pos : 0 < a} (mixed : i < M + 1) :
    (DrawnShaping.drawn a p c hi lo pos (at_ M i mixed)).carrier = up M a p hi lo i :=
  rfl

/-- And the others' count the others' weight. -/
theorem drawn_other {a p c hi lo M i : Nat} {pos : 0 < a} (mixed : i < M + 1) :
    (DrawnShaping.drawn a p c hi lo pos (at_ M i mixed)).other = down M a p c i :=
  (add_mul_split i (M + 1 - i) (a + c + p)).symm.trans
    (congrArg (· * (a + c + p)) (sub_split (Nat.le_of_lt mixed)))

/-- **Where the rule read favours, the chain's steps favour**: at a count, others present, the rule
read favours the shapers exactly where the others' weight is at most the shapers'. -/
theorem favours_iff {a p c hi lo M i : Nat} {pos : 0 < a} (mixed : i < M + 1) :
    CarrierCounts.favours (DrawnShaping.drawn a p c hi lo pos (at_ M i mixed)) ↔
      down M a p c i ≤ up M a p hi lo i := by
  show (DrawnShaping.drawn a p c hi lo pos (at_ M i mixed)).other ≤
    (DrawnShaping.drawn a p c hi lo pos (at_ M i mixed)).carrier ↔ _
  rw [drawn_other mixed, drawn_carrier mixed]

/-- With `lo ≤ hi`, the shapers' weight does not fall as their count grows. -/
theorem up_mono {M a p hi lo : Nat} (step : lo ≤ hi) {j k : Nat} (le : j ≤ k) (top : k ≤ M + 1) :
    up M a p hi lo j ≤ up M a p hi lo k :=
  match le_dest le, le_dest top with
  | ⟨m, hk⟩, ⟨r, hr⟩ => by
    have ek : M + 1 - k = r := by rw [hr]; exact Naturals.add_sub_cancel_left k r
    have ej : M + 1 - j = m + r := by
      rw [hr, hk, Nat.add_assoc]; exact Naturals.add_sub_cancel_left j (m + r)
    show j * (a + hi + p) + (M + 1 - j) * (a + lo + p) ≤ k * (a + hi + p) + (M + 1 - k) * (a + lo + p)
    rw [ek, ej, hk, add_mul_split j m, add_mul_split m r, ← Nat.add_assoc]
    exact Nat.add_le_add_right (Nat.add_le_add_left
      (Nat.mul_le_mul_left m (Nat.add_le_add_right (Nat.add_le_add_left step a) p)) _) _

/-- **Every step weighs alike.** With `lo ≤ hi`, at every mixed count the three weights total
`whole`. -/
theorem steps {M a p c hi lo : Nat} (step : lo ≤ hi) :
    Drift.Replacement.Steps M (whole M a p c hi) (up M a p hi lo) (down M a p c) (stay M hi lo) := fun i mixed =>
  match le_dest (Nat.le_of_lt mixed.2), le_dest step with
  | ⟨r, hr⟩, ⟨e, he⟩ => by
    have er : M + 1 - i = r := by rw [hr]; exact Naturals.add_sub_cancel_left i r
    have ee : hi - lo = e := by rw [he]; exact Naturals.add_sub_cancel_left lo e
    show i * (a + hi + p) + (M + 1 - i) * (a + lo + p) + (M + 1) * (a + c + p) +
        (M + 1 - i) * (hi - lo) = (M + 1) * (a + hi + p) + (M + 1) * (a + c + p)
    rw [er, ee, Nat.add_right_comm (i * (a + hi + p) + r * (a + lo + p)) ((M + 1) * (a + c + p)),
      Nat.add_assoc (i * (a + hi + p)) (r * (a + lo + p)) (r * e), ← Nat.left_distrib r,
      show a + lo + p + e = a + hi + p by
        rw [he, Nat.add_right_comm (a + lo) p e, Nat.add_assoc a lo e],
      ← add_mul_split i r, ← hr]

/-! ## Fixation with drift, and what drift leaves -/

section Drawn

variable {M a p c hi lo : Nat}

/-- With shapers present the shapers' weight is at least what each leaves without shaping. -/
theorem up_ge {i : Nat} (some : 0 < i) : a ≤ up M a p hi lo i :=
  Nat.le_trans (Nat.le_trans (Nat.le_add_right a hi) (Nat.le_add_right _ p))
    (Nat.le_trans (Nat.le_of_eq (Nat.one_mul _).symm)
      (Nat.le_trans (Nat.mul_le_mul_right _ some) (Nat.le_add_right _ _)))

theorem up_pos (pos : 0 < a) : ∀ k, Mixed M k → 0 < up M a p hi lo k := fun _ mixed =>
  Nat.lt_of_lt_of_le pos (up_ge mixed.1)

theorem a_le_whole : a ≤ whole M a p c hi :=
  Nat.le_trans (Nat.le_trans (Nat.le_add_right a hi) (Nat.le_add_right _ p))
    (Nat.le_trans (Nat.le_of_eq (Nat.one_mul _).symm)
      (Nat.le_trans (Nat.mul_le_mul_right _ (Nat.succ_pos M)) (Nat.le_add_right _ _)))

/-- **Fixation with drift.** With `lo ≤ hi` and `r + a ^ (M + 1) = whole ^ (M + 1)`, over `m` rounds
of `M + 1` steps from `i`, the histories fixing the shapers weigh, times the potential at the top, at
most the whole weight times the potential at `i`, and with the potential at the top times `r ^ m` at
least that (`Drift.Replacement.fixationBy`). -/
theorem fixation (step : lo ≤ hi) {r : Nat} (split : r + a ^ (M + 1) = whole M a p c hi ^ (M + 1))
    (m i : Nat) :
    potentialBy M (up M a p hi lo) (down M a p c) (M + 1) *
        valueBy M (whole M a p c hi) (up M a p hi lo) (down M a p c) (stay M hi lo) (fixed M)
          ((M + 1) * m) i ≤
      whole M a p c hi ^ ((M + 1) * m) * potentialBy M (up M a p hi lo) (down M a p c) i ∧
    whole M a p c hi ^ ((M + 1) * m) * potentialBy M (up M a p hi lo) (down M a p c) i ≤
      potentialBy M (up M a p hi lo) (down M a p c) (M + 1) *
          valueBy M (whole M a p c hi) (up M a p hi lo) (down M a p c) (stay M hi lo) (fixed M)
            ((M + 1) * m) i +
        potentialBy M (up M a p hi lo) (down M a p c) (M + 1) * r ^ m :=
  fixationBy (steps step) (fun _ mixed => up_ge mixed.1) a_le_whole split m i

/-- **Noise leaves the lock above the mass.** From `i` shapers, `i ≤ M`, the histories losing every
shaper weigh at least `down ^ i` times every later history, wherever the critical mass lies. -/
theorem lost_ge (k : Nat) : ∀ i, i ≤ M → ((M + 1) * (a + c + p)) ^ i * whole M a p c hi ^ k ≤
    valueBy M (whole M a p c hi) (up M a p hi lo) (down M a p c) (stay M hi lo) lost (k + i) i :=
  lost_geBy (c := (M + 1) * (a + c + p)) (fun _ _ => Nat.le_refl _) k

/-- **And the lock below it.** From shapers present within reach of the top in `k` steps, the
histories fixing the shapers weigh at least `a ^ k`. -/
theorem fixed_ge : ∀ k i, 0 < i → M + 1 ≤ i + k →
    a ^ k ≤ valueBy M (whole M a p c hi) (up M a p hi lo) (down M a p c) (stay M hi lo) (fixed M) k i :=
  climbsBy (fun _ mixed => up_ge mixed.1) a_le_whole

/-- **Above the mass, losing every shaper is bounded across the distance.** With `lo ≤ hi`, where the
rule read at `s` favours the shapers (the others' weight at most theirs there), from `s + n` with `t`
to the top, the histories over `k` steps losing every shaper weigh, times the shapers' weights at
`s + 1 … s + n`, at most `t` times `down ^ n` times the whole weight. -/
theorem lost_above (pos : 0 < a) (step : lo ≤ hi) {s n t : Nat} (top : s + n + t = M + 1)
    (mass : down M a p c s ≤ up M a p hi lo s) (k : Nat) :
    ups (up M a p hi lo) s n *
        valueBy M (whole M a p c hi) (up M a p hi lo) (down M a p c) (stay M hi lo) lost k (s + n) ≤
      t * ((M + 1) * (a + c + p)) ^ n * whole M a p c hi ^ k :=
  have h := lostBy_favoured (steps step) (up_pos pos) top
    (fun k lt le => Nat.le_trans mass (up_mono step (Nat.le_of_lt lt) (Nat.le_succ_of_le le))) k
  have same : ups (down M a p c) s n = ((M + 1) * (a + c + p)) ^ n := ups_const _ s n
  by rw [same] at h; exact h

/-- **Below the mass, fixing the shapers is bounded across the distance.** With `lo ≤ hi`, where the
rule read at `j + n` favours the others (the shapers' weight at most theirs there), from `j + 1`
shapers the histories over `k` steps fixing the shapers weigh, times `down ^ n`, at most `j + 1` times
the shapers' weights at `j + 1 … j + n` times the whole weight. -/
theorem fixed_below (pos : 0 < a) (step : lo ≤ hi) {j n : Nat} (within : j + n ≤ M)
    (mass : up M a p hi lo (j + n) ≤ down M a p c (j + n)) (k : Nat) :
    ((M + 1) * (a + c + p)) ^ n *
        valueBy M (whole M a p c hi) (up M a p hi lo) (down M a p c) (stay M hi lo) (fixed M) k
          (j + 1) ≤
      (j + 1) * ups (up M a p hi lo) j n * whole M a p c hi ^ k :=
  have h := fixedBy_disfavoured (steps step) (up_pos pos) within
    (fun k _ le => Nat.le_trans (up_mono step le (Nat.le_succ_of_le within)) mass) k
  have same : ups (down M a p c) j n = ((M + 1) * (a + c + p)) ^ n := ups_const _ j n
  by rw [same] at h; exact h

/-- **One of each kind arising.** The potential's first step is the shapers' weights at `1 … M`
multiplied, and its last `down ^ M`. -/
theorem one_each :
    riseBy M (up M a p hi lo) (down M a p c) 0 = ups (up M a p hi lo) 0 M ∧
      riseBy M (up M a p hi lo) (down M a p c) M = ((M + 1) * (a + c + p)) ^ M :=
  ⟨riseBy_ends.1, riseBy_ends.2.trans (downs_const _ M)⟩

/-- **Risk dominance, in counts.** At an even population the rule read favours the shapers strictly
exactly where `2 · c < hi + lo`. -/
theorem risk_dominant_iff {n : Nat} (some : 0 < n) {pos : 0 < a} :
    (DrawnShaping.drawn a p c hi lo pos ⟨n, n, some⟩).other <
        (DrawnShaping.drawn a p c hi lo pos ⟨n, n, some⟩).carrier ↔ 2 * c < hi + lo := by
  show n * (a + c + p) + n * (a + c + p) < n * (a + hi + p) + n * (a + lo + p) ↔ _
  rw [DrawnShaping.drawn_split n n a p c c, DrawnShaping.drawn_split n n a p hi lo,
    ← Nat.left_distrib n c c, ← Nat.left_distrib n hi lo, Nat.two_mul]
  exact ⟨fun lt => SelectionTerm.lt_of_mul_lt_mul (Nat.lt_of_add_lt_add_right lt),
    fun lt => Nat.add_lt_add_right (Nat.mul_lt_mul_of_pos_left lt some) _⟩

end Drawn

/-! ## Witnesses -/

namespace Strong

/-- **Risk dominant, and yet one other fixes first.** Five members, `a = 1`, nothing shared,
`c = 9`, `hi = 20`, `lo = 0`: the shapers are risk dominant and the mass lies between the ends, yet
the potential's first step, 6,215,625, falls short of its last, 6,250,000. -/
theorem other_first :
    2 * 9 < 20 + 0 ∧ 0 < 9 ∧ 9 < 20 ∧
      riseBy 4 (up 4 1 0 20 0) (down 4 1 0 9) 0 = 6215625 ∧
      riseBy 4 (up 4 1 0 20 0) (down 4 1 0 9) 4 = 6250000 ∧
      riseBy 4 (up 4 1 0 20 0) (down 4 1 0 9) 0 < riseBy 4 (up 4 1 0 20 0) (down 4 1 0 9) 4 :=
  ⟨by decide, by decide, by decide, one_each.1, one_each.2, by rw [one_each.1, one_each.2]; decide⟩

end Strong

namespace Weak

/-- **The base decides.** The same `c`, `hi` and `lo` with `a = 100`: the first step exceeds the last. -/
theorem shapers_first :
    riseBy 4 (up 4 100 0 20 0) (down 4 100 0 9) 4 < riseBy 4 (up 4 100 0 20 0) (down 4 100 0 9) 0 := by
  rw [one_each.1, one_each.2]; decide

/-- **And so does what comes to every member alike.** With `a = 1` and `p = 99` to every member, the
first step exceeds the last as well. -/
theorem shared_decides :
    riseBy 4 (up 4 1 99 20 0) (down 4 1 99 9) 4 < riseBy 4 (up 4 1 99 20 0) (down 4 1 99 9) 0 := by
  rw [one_each.1, one_each.2]; decide

end Weak

end DrawnReplacement

end Becoming
