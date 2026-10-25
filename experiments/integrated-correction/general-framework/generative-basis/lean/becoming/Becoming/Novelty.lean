import Becoming.Entropy
import Becoming.Imbalance

/-!
# Novelty: returning, novelty and forgetting, read on the levels alone

Ren, 14 October 2026: “no hard role has to be so - right now i think we are trapped by our
speculative conditions”, and then “please, finish all”. `Becoming.Entropy` stated its laws of
returning, novelty and forgetting for a balanced flow over a family gaining nothing, and for a
finite world under the first law. This module states them on the levels alone: on any web, with no
flow, no balance, no loss and no finiteness of the world. Each law needs one state of the part,
written into the law: that the part's stock stays within a bound, never rises, or falls across
each change.

* **A part held within a bound returns.** Where from `T` on the stock of a family stays within a
  bound, its configurations lie among finitely many, so from every step on they take one value at
  two steps (`Web.revisits_of_bounded`). A stock that never rises is the bound at `T`
  (`Web.revisits_of_nonrising`). Changing without end, such a part returns after a change: it is
  not the case that it never revisits (`Web.returns_of_bounded`).
* **Only what gains is new, with a bounded wait.** A list of steps at which a family's
  configurations are pairwise distinct, longer than the number of configurations of its members
  totalling at most `K`, holds a step with stock above `K` (`Web.exceeds_of_distinct_configs`). The
  steps need be neither consecutive nor in order, and the step is found by checking the stock at
  each of them; nothing infinite is decided. A family with such lists of every length from every
  step on exceeds every bound at arbitrarily late steps (`Web.unbounded_of_distinct_configs`).
  Consecutive steps are a case: a family whose configurations at the steps `T, …, T + N` are all
  different, where `N` counts the configurations of its members totalling at most `K`, has stock
  above `K` at one of those steps (`Web.exceeds_of_new`), and a family new at every step exceeds
  every bound at arbitrarily late steps (`Web.unbounded_of_new`). A family that changes without end
  and never revisits stays within no bound (`Web.unbounded_of_never_revisits`).
  New at every step is possible: in `Web.counting` the level is the step (`Web.counting_new`,
  `Web.counting_gains`).
* **A part held within a bound forgets.** No reading of its configuration gives at each step a
  record that never repeats (`Web.unread_of_new_record`), or a count that exceeds every bound
  (`Web.unread_of_unbounded`). So a family held within a bound that is exchanged with at
  arbitrarily late steps does not carry the count of its exchanges, whatever the flow
  (`Flow.uncarried_of_bounded`); for the whole, where finitely many relata are all there is,
  `World.forgets_of_bounded`.
* **Loss turns returning into stopping.** Where the stock never rises and falls across each step
  at which the configuration changes, the family never revisits (`Web.never_revisits_of_loses`),
  the changes over any stretch number at most its stock at `T` (`Web.changes_le_stock`), and
  change does not recur without end (`Web.rests_of_loses`).
* **The earlier forms are cases.** Balanced and gaining nothing, a family stays within its stock
  at `T` (`Flow.Balances.bounded`), and with that bound the laws above give
  `Flow.Balances.recurs`, `Flow.Balances.rests_of_never_revisits` and `World.forgets` of
  `Becoming.Entropy` (`first_law_cases`). With the rest counted as a relatum
  (`Flow.withImbalance`), no balance is supposed: a family gaining nothing with its rest counted
  stays within its stock at `T` (`Flow.bounded_counting_rest`).

**Readings (the AI's, adopted on Ren's delegation of 15 October 2026, DELEGATED-CHOICES D27).** Each
law of this module holds of any becoming that has levels, and each condition it uses is a state of
the part it is about, as curvature is a state of a region. Returning is what a bounded part does;
novelty without end is gain without bound, which must come from beyond the part; a bounded present
cannot hold its own history; and loss at each change ends change within as many changes as there are
units.

What is not derived: which parts are held within a bound, gain nothing or lose at each change.
The representation commits to discrete steps and natural amounts. No ethical predicate, ranking or
axiom occurs.
-/

namespace Becoming

variable {F C : Type}

/-- A decided property of numbers holds at every step up to `N`, or fails at one of them. -/
theorem upto_or_fails (p : Nat → Prop) [∀ n, Decidable (p n)] :
    ∀ N, (∀ n, n ≤ N → p n) ∨ ∃ n, n ≤ N ∧ ¬ p n
  | 0 => match (inferInstance : Decidable (p 0)) with
    | isTrue holds => .inl fun _ le => Eq.subst (motive := p) (Nat.eq_zero_of_le_zero le).symm holds
    | isFalse fails => .inr ⟨0, Nat.le_refl 0, fails⟩
  | N + 1 => match upto_or_fails p N with
    | .inr ⟨n, le, fails⟩ => .inr ⟨n, Nat.le_succ_of_le le, fails⟩
    | .inl all => match (inferInstance : Decidable (p (N + 1))) with
      | isTrue holds => .inl fun n le => match le_succ_cases le with
        | .inl before => all n before
        | .inr now => Eq.subst (motive := p) now.symm holds
      | isFalse fails => .inr ⟨N + 1, Nat.le_refl _, fails⟩

namespace Web

variable {W : Web F C} {cs : List C}

/-! ## Returning -/

/-- **A part held within a bound returns.** Where from `T` on the stock of a family stays within
`K`, its configurations from `T` on lie among the configurations of its members totalling at most
`K`, so from every step on they take one value at two steps. No flow, balance, loss, finiteness of
the world or decision enters. -/
theorem revisits_of_bounded {T K : Nat} (bound : ∀ t, T ≤ t → W.stock cs t ≤ K) (M : Nat) :
    ∃ i j, M ≤ i ∧ i < j ∧ W.config cs (T + i) = W.config cs (T + j) :=
  revisits_from (g := fun n => W.config cs (T + n))
    (fun n => config_within (bound (T + n) (Nat.le_add_right T n))) M

/-- **A part that gains nothing returns.** Where from `T` on the stock of a family never rises,
from every step on its configurations take one value at two steps. -/
theorem revisits_of_nonrising {T : Nat}
    (still : ∀ t, T ≤ t → W.stock cs (t + 1) ≤ W.stock cs t) (M : Nat) :
    ∃ i j, M ≤ i ∧ i < j ∧ W.config cs (T + i) = W.config cs (T + j) :=
  revisits_of_bounded (K := W.stock cs T)
    (fun _ later => nonrising_between (q := W.stock cs) still (Nat.le_refl T) later) M

/-- Changing without end, a part held within a bound returns after a change: where its
configuration changes at arbitrarily late steps, it is not the case that it never revisits a
configuration from `T` on. -/
theorem returns_of_bounded {T K : Nat} (bound : ∀ t, T ≤ t → W.stock cs t ≤ K)
    (changing : ∀ N, ∃ t, N ≤ t ∧ W.Changes cs t) : ¬¬ W.Revisits cs T :=
  fun never => rests_of_never_revisits _ (fun _ later => config_within (bound _ later)) never
    changing

/-! ## Novelty -/

/-- **Distinct configurations exceed.** A list of steps at which a family's configurations are
pairwise distinct, longer than the number of configurations of its members totalling at most `K`,
holds a step at which the family's stock exceeds `K`. The steps need be neither consecutive nor in
order; the step is found by checking the stock at each listed step. -/
theorem exceeds_of_distinct_configs {K : Nat} {ss : List Nat}
    (distinct : Distinct (ss.map (W.config cs)))
    (long : (configurationsWithin cs.length K).length < ss.length) :
    ∃ s, s ∈ ss ∧ K < W.stock cs s :=
  match search (p := fun s => W.stock cs s ≤ K) ss with
  | .inl ⟨s, mem, over⟩ => ⟨s, mem, Nat.gt_of_not_le over⟩
  | .inr within =>
    absurd (Nat.le_trans (Nat.le_of_eq (length_map (W.config cs) ss).symm)
        (length_le_of_sub distinct fun _ mem => match preimage_of_mem_map mem with
          | ⟨s, listed, same⟩ => Eq.subst (motive := fun y => y ∈ configurationsWithin cs.length K)
              same (config_within (within s listed))))
      (Nat.not_le_of_gt long)

/-- **Distinct configurations without end exceed every bound.** A family that has, from every step
on, lists of every length of later steps at which its configurations are pairwise distinct exceeds
every bound at arbitrarily late steps. -/
theorem unbounded_of_distinct_configs
    (lists : ∀ M n, ∃ ss : List Nat, ss.length = n ∧ (∀ s, s ∈ ss → M ≤ s) ∧
      Distinct (ss.map (W.config cs))) (K M : Nat) :
    ∃ t, M ≤ t ∧ K < W.stock cs t :=
  match lists M ((configurationsWithin cs.length K).length + 1) with
  | ⟨_, length, late, distinct⟩ =>
    match exceeds_of_distinct_configs distinct
        (Eq.subst (motive := fun n => (configurationsWithin cs.length K).length < n) length.symm
          (Nat.lt_succ_self _)) with
    | ⟨s, mem, over⟩ => ⟨s, late s mem, over⟩

/-- Steps read along a list of indices without repetition, at which the configurations are apart
whenever the indices are in order, have pairwise distinct configurations. -/
theorem distinct_configs_of_apart {at_ : Nat → Nat} {ns : List Nat} (distinct : Distinct ns)
    (apart : ∀ i j, i ∈ ns → j ∈ ns → i < j → W.config cs (at_ i) ≠ W.config cs (at_ j)) :
    Distinct ((ns.map at_).map (W.config cs)) :=
  Eq.subst (motive := fun l => Distinct l) (map_comp_eq at_ (W.config cs) ns).symm
    (distinct_map_on (g := fun n => W.config cs (at_ n))
      (fun a b memA memB same => match Nat.lt_or_ge a b with
        | .inl lt => absurd same (apart a b memA memB lt)
        | .inr ge => match Nat.eq_or_lt_of_le ge with
          | .inl eq => eq.symm
          | .inr lt => absurd same.symm (apart b a memB memA lt))
      distinct)

/-- **Only what gains is new, with a bounded wait.** Where the configurations of a family at the
steps `T, …, T + N` are all different, `N` being the number of configurations of its members
totalling at most `K`, at one of those steps its stock exceeds `K`: the case of
`exceeds_of_distinct_configs` for the list of those steps. The step is found by checking the stock
at each of those steps. -/
theorem exceeds_of_new {T K : Nat}
    (new : ∀ i j, i < j → j ≤ (configurationsWithin cs.length K).length →
      W.config cs (T + i) ≠ W.config cs (T + j)) :
    ∃ n, n ≤ (configurationsWithin cs.length K).length ∧ K < W.stock cs (T + n) :=
  have within : ∀ {n}, n ∈ steps 0 ((configurationsWithin cs.length K).length + 1) →
      n ≤ (configurationsWithin cs.length K).length :=
    fun mem => Nat.le_of_lt_succ
      (Nat.lt_of_lt_of_le (steps_within mem) (Nat.le_of_eq (Nat.zero_add _)))
  match exceeds_of_distinct_configs (K := K)
      (distinct_configs_of_apart (at_ := fun n => T + n)
        (ns := steps 0 ((configurationsWithin cs.length K).length + 1)) (steps_distinct 0 _)
        fun i j _ memJ lt => new i j lt (within memJ))
      (Eq.subst (motive := fun n => (configurationsWithin cs.length K).length < n)
        ((steps_length 0 _).symm.trans (length_map (fun n => T + n) _).symm)
        (Nat.lt_succ_self _)) with
  | ⟨_, mem, over⟩ => match preimage_of_mem_map mem with
    | ⟨n, listed, same⟩ =>
      ⟨n, within listed, Eq.subst (motive := fun x => K < W.stock cs x) same.symm over⟩

/-- **What keeps being new keeps gaining.** A family whose configuration from `T` on is new at
every step exceeds every bound at arbitrarily late steps: from every step `M` on, the steps
`T + i` with `i` from `M` on are later and have pairwise distinct configurations
(`unbounded_of_distinct_configs`). -/
theorem unbounded_of_new {T : Nat}
    (new : ∀ i j, i < j → W.config cs (T + i) ≠ W.config cs (T + j)) (K M : Nat) :
    ∃ t, M ≤ t ∧ K < W.stock cs t :=
  unbounded_of_distinct_configs (fun M' n => ⟨(steps M' n).map (fun i => T + i),
      (length_map _ _).trans (steps_length M' n),
      fun _ mem => match preimage_of_mem_map mem with
        | ⟨i, listed, same⟩ => Eq.subst (motive := fun x => M' ≤ x) same
            (Nat.le_trans (steps_mem listed) (Nat.le_add_left i T)),
      distinct_configs_of_apart (steps_distinct M' n) fun i j _ _ lt => new i j lt⟩) K M

/-- A family that changes without end and never revisits a configuration stays within no
bound. -/
theorem unbounded_of_never_revisits {T : Nat} (never : ¬ W.Revisits cs T)
    (changing : ∀ N, ∃ t, N ≤ t ∧ W.Changes cs t) (K : Nat) :
    ¬ ∀ t, T ≤ t → W.stock cs t ≤ K :=
  fun bound => returns_of_bounded bound changing never

/-! ## Forgetting -/

/-- **A part held within a bound forgets.** Where from `T` on the stock of a family stays within a
bound, no reading of its configuration gives at each step from `T` on a record that never
repeats: two steps share a configuration, and so the reading. -/
theorem unread_of_new_record {H : Type} {T K : Nat} (bound : ∀ t, T ≤ t → W.stock cs t ≤ K)
    {record : Nat → H} (new : ∀ i j, i < j → record i ≠ record j) (read : List Nat → H) :
    ¬ ∀ n, read (W.config cs (T + n)) = record n :=
  fun reads => match revisits_of_bounded bound 0 with
  | ⟨i, j, _, lt, same⟩ => new i j lt ((reads i).symm.trans ((congrArg read same).trans (reads j)))

/-- Nor does any reading of it give a count that exceeds every bound: the reading is at most its
sum over the finitely many configurations within the bound. -/
theorem unread_of_unbounded {T K : Nat} (bound : ∀ t, T ≤ t → W.stock cs t ≤ K)
    {count : Nat → Nat} (unbounded : ∀ m, ∃ n, m ≤ count n) (read : List Nat → Nat) :
    ¬ ∀ n, read (W.config cs (T + n)) = count n :=
  fun reads => match unbounded (sumOver read (configurationsWithin cs.length K) + 1) with
  | ⟨n, above⟩ => Nat.not_succ_le_self _ (Nat.le_trans above (Nat.le_trans
      (Nat.le_of_eq (reads n).symm)
      (le_sumOver read (config_within (bound (T + n) (Nat.le_add_right T n))))))

/-! ## Loss -/

/-- Losing at each change, a part never revisits: where from `T` on the stock of a family never
rises and falls across every step at which its configuration changes, it never revisits a
configuration. -/
theorem never_revisits_of_loses {T : Nat}
    (still : ∀ t, T ≤ t → W.stock cs (t + 1) ≤ W.stock cs t)
    (loses : ∀ t, T ≤ t → W.Changes cs t → W.stock cs (t + 1) < W.stock cs t) :
    ¬ W.Revisits cs T :=
  fun ⟨s, v, u, from_, sv, vu, changes, same⟩ =>
    have back : W.stock cs u = W.stock cs s :=
      (W.config_total cs u).symm.trans
        ((congrArg (fun x => total x (fun x => x)) same).trans (W.config_total cs s))
    Nat.lt_irrefl (W.stock cs s)
      (Nat.lt_of_le_of_lt (Nat.le_of_eq back.symm)
        (Nat.lt_of_le_of_lt
          (nonrising_between (q := W.stock cs) still
            (Nat.le_trans from_ (Nat.le_trans sv (Nat.le_succ v))) vu)
          (Nat.lt_of_lt_of_le (loses v (Nat.le_trans from_ sv) changes)
            (nonrising_between (q := W.stock cs) still from_ sv))))

/-- **Loss turns returning into stopping.** Where from `T` on the stock of a family never rises
and falls across every step at which its configuration changes, over any stretch from `T` its
stock at the end together with the steps across which it changed is at most its stock at `T`: it
changes across at most that many steps. -/
theorem changes_le_stock {T : Nat}
    (still : ∀ t, T ≤ t → W.stock cs (t + 1) ≤ W.stock cs t)
    (loses : ∀ t, T ≤ t → W.Changes cs t → W.stock cs (t + 1) < W.stock cs t) :
    ∀ N, W.stock cs (T + N) + total (steps T N) (fun t => mark (W.Changes cs t)) ≤ W.stock cs T
  | 0 => Nat.le_refl _
  | N + 1 =>
    have before := changes_le_stock still loses N
    have last := steps_last (fun t => mark (W.Changes cs t)) T N
    match (inferInstance : Decidable (W.Changes cs (T + N))) with
    | isTrue changes => calc
        W.stock cs (T + (N + 1)) + total (steps T (N + 1)) (fun t => mark (W.Changes cs t))
            = W.stock cs (T + N + 1) +
                (total (steps T N) (fun t => mark (W.Changes cs t)) + 1) :=
          congrArg (W.stock cs (T + N + 1) + ·)
            (last.trans (congrArg (total (steps T N) (fun t => mark (W.Changes cs t)) + ·)
              (mark_one changes)))
        _ = W.stock cs (T + N + 1) + 1 + total (steps T N) (fun t => mark (W.Changes cs t)) :=
          (Nat.add_assoc _ _ 1).symm.trans (Nat.add_right_comm _ _ 1)
        _ ≤ W.stock cs (T + N) + total (steps T N) (fun t => mark (W.Changes cs t)) :=
          Nat.add_le_add_right
            (Nat.succ_le_of_lt (loses (T + N) (Nat.le_add_right T N) changes)) _
        _ ≤ W.stock cs T := before
    | isFalse same => calc
        W.stock cs (T + (N + 1)) + total (steps T (N + 1)) (fun t => mark (W.Changes cs t))
            = W.stock cs (T + N + 1) +
                (total (steps T N) (fun t => mark (W.Changes cs t)) + 0) :=
          congrArg (W.stock cs (T + N + 1) + ·)
            (last.trans (congrArg (total (steps T N) (fun t => mark (W.Changes cs t)) + ·)
              (mark_zero same)))
        _ ≤ W.stock cs (T + N) + total (steps T N) (fun t => mark (W.Changes cs t)) :=
          Nat.add_le_add_right (still (T + N) (Nat.le_add_right T N)) _
        _ ≤ W.stock cs T := before

/-- So change stops: losing at each change, the configuration does not change at arbitrarily late
steps. -/
theorem rests_of_loses {T : Nat}
    (still : ∀ t, T ≤ t → W.stock cs (t + 1) ≤ W.stock cs t)
    (loses : ∀ t, T ≤ t → W.Changes cs t → W.stock cs (t + 1) < W.stock cs t) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ W.Changes cs t :=
  fun changing => match recurring_accumulates (q := fun t => mark (W.Changes cs t))
      (fun N => match changing N with
        | ⟨t, later, changes⟩ => ⟨t, later, mark_pos.mpr changes⟩) T (W.stock cs T + 1) with
  | ⟨n, many⟩ => Nat.not_succ_le_self _ (Nat.le_trans many
      (Nat.le_trans (Nat.le_add_left _ _) (changes_le_stock still loses n)))

/-! ## New at every step -/

/-- Counting on: one condition whose level is the step, and nothing active. -/
def counting : Web Unit Unit :=
  ⟨fun t _ => t, fun _ _ => False, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

/-- Counting on is new at every step. -/
theorem counting_new :
    ∀ i j, i < j → counting.config [()] (0 + i) ≠ counting.config [()] (0 + j) :=
  fun _ _ lt same => Nat.ne_of_lt (Nat.add_lt_add_left lt 0) (List.cons.inj same).1

/-- So it exceeds every bound at arbitrarily late steps. -/
theorem counting_gains (K M : Nat) : ∃ t, M ≤ t ∧ K < counting.stock [()] t :=
  unbounded_of_new counting_new K M

end Web

/-! ## The earlier forms are cases -/

namespace Flow

variable {L : Flow F C} {W : Web F C} {cs : List C}

/-- The first law supplies the bound: balanced, a family gaining nothing at every step from `T`
on stays within its stock at `T`. -/
theorem Balances.bounded (balances : L.Balances W) {T : Nat}
    (gainless : ∀ t, T ≤ t → L.GainlessOn cs t) : ∀ t, T ≤ t → W.stock cs t ≤ W.stock cs T :=
  fun _ later => nonrising_between (q := W.stock cs) (fun s l => balances.nonrising (gainless s l))
    (Nat.le_refl T) later

/-- With the rest counted, no balance is supposed: in every flow a family gaining nothing at
every step from `T` on, with the rest of the whole counted as a relatum (`Flow.withImbalance`),
stays within its stock at `T`. -/
theorem bounded_counting_rest {T : Nat}
    (gainless : ∀ t, T ≤ t → (L.withImbalance W).GainlessOn cs t) :
    ∀ t, T ≤ t → W.stock cs t ≤ W.stock cs T :=
  Balances.bounded (W := W.withRefinement) withImbalance_balances gainless

/-- **A part that keeps exchanging cannot carry its history**, whatever the flow: where from `T`
on the stock of a family stays within a bound and something is exchanged with it at arbitrarily
late steps, its configuration does not carry the count of its exchanges. -/
theorem uncarried_of_bounded {T K : Nat} (bound : ∀ t, T ≤ t → W.stock cs t ≤ K)
    (exchanging : ∀ M, ∃ t, M ≤ t ∧ 0 < L.exchanges cs t) : ¬ L.CarriesHistory W cs T :=
  fun ⟨read, reads⟩ => Web.unread_of_unbounded bound (count := L.exchangeCount cs T)
    (recurring_accumulates exchanging T) read reads

end Flow

namespace World

variable {w : World}

/-- **A finite whole that keeps exchanging forgets**, with no premise of the world: where finitely
many relata are all there is, their stock stays within a bound from `T` on and the flow exchanges
at arbitrarily late steps, from no step on does the world's configuration carry its history.
`World.forgets` is the case where the first law supplies the bound. -/
theorem forgets_of_bounded {all : List w.Relatum} (every : ∀ x, x ∈ all) {T K : Nat}
    (bound : ∀ t, T ≤ t → w.web.stock all t ≤ K) (exchanging : w.flow.ExchangeRecurs) :
    ¬ w.flow.CarriesHistory w.web all T :=
  Flow.uncarried_of_bounded bound fun M => match exchanging M with
    | ⟨t, _, c, later, present, exchanged⟩ =>
      ⟨t, later, Flow.exchanges_pos present (every c) exchanged⟩

end World

/-- **The earlier forms are cases.** The laws of returning, stopping and forgetting that
`Becoming.Entropy` states under the first law (`Flow.Balances.recurs`,
`Flow.Balances.rests_of_never_revisits`, `World.forgets`), obtained from the laws on the levels
alone with the bound that balance and gaining nothing supply (`Flow.Balances.bounded`). -/
theorem first_law_cases :
    (∀ {F C : Type} {L : Flow F C} {W : Web F C} {cs : List C} {T : Nat}, L.Balances W →
      (∀ t, T ≤ t → L.GainlessOn cs t) →
        (∀ M, ∃ i j, M ≤ i ∧ i < j ∧ W.config cs (T + i) = W.config cs (T + j)) ∧
          (¬ W.Revisits cs T → ¬ ∀ N, ∃ t, N ≤ t ∧ W.Changes cs t)) ∧
      (∀ (w : World) {all : List w.Relatum}, Distinct all → (∀ x, x ∈ all) → w.Balanced →
        w.flow.Gainless → w.flow.ExchangeRecurs → ∀ T, ¬ w.flow.CarriesHistory w.web all T) :=
  ⟨fun balances gainless =>
     ⟨Web.revisits_of_bounded (balances.bounded gainless),
      fun never changing => Web.returns_of_bounded (balances.bounded gainless) changing never⟩,
   fun _ _ distinct every balanced gainless exchanging _ =>
     World.forgets_of_bounded every
       (Flow.Balances.bounded balanced
         fun t _ => gainless _ t distinct fun _ _ c out => absurd (every c) out)
       exchanging⟩

end Becoming
