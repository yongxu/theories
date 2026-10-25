import Becoming.EventualWideningInstances
import Becoming.Gain
import Becoming.MapInstances

/-!
# Sustained widening: what a range that keeps widening needs, and what carries it

`Becoming.EventualWidening` defines a course whose range keeps widening (`Web.KeepsWidening`: from
`T` on, along a continuation, nothing admitted is lost and something keeps being opened). This
module states what such a course needs from the World's premises, and how the map reads what
carries it. Each law is a property of one course or one flow. None compares two courses, so none
is the second-order comparison the account leaves open. No ethical predicate, ranking or axiom
occurs.

* **The gain bridge: keeping widening passes every bound, and is fed from beyond.** Take a course
  keeping widening by name on the actual levels from `T`, every formation supported from `T` on
  requiring, fixed, only members of a family `cs` (`Web.RequiresWithin`). For every `n` it lists
  `n` steps at which the configurations of `cs` are pairwise distinct
  (`Web.KeepsWidening.distinct_configs`). So the
  stock of `cs` exceeds every bound at arbitrarily late steps
  (`Web.KeepsWidening.passes_every_bound`) and rises at arbitrarily late steps
  (`Web.KeepsWidening.rises_late`). The step is found by `Web.exceeds_of_distinct_configs`, the
  pigeonhole of `Web.exceeds_of_firsts` stated for a list of steps; `exceeds_of_firsts` follows from
  it with its statement (`Web.exceeds_of_firsts_of_distinct_configs`). Under the first law, with
  `cs` without repetition, the family is given more than it takes, by the rest or across its
  boundary, at arbitrarily late steps (`Web.KeepsWidening.from_rest_or_open`). Where the flow also
  balances on it, it is open at arbitrarily late steps (`Web.KeepsWidening.open_late`). In a finite
  balanced world under the first law no course keeps widening by name with what its formations
  require fixed (`Flow.whole_not_keepsWidening`). No sequence is chosen, and nothing is decided
  beyond the order of numbers at finitely many listed steps.
* **Renewers multiply under upkeep.** Suppose every formation supported from `T` on takes part and
  takes at least a unit a step from `cs` (`Flow.TakesWhileSupported`). Then a course keeping
  widening by name makes ever more formations take from `cs` (`Web.KeepsWidening.more`). The count
  goes through `length_le_count`, the lower bound beside `count_le_of_sub`, which needs neither a
  decision of equality nor a double negation. If `cs` is balanced on from some step, its
  replenishment is bounded from no step on (`Web.KeepsWidening.replenishment_unbounded`). If each
  formation also gives it at most `g` a step, so are its renewers
  (`Web.KeepsWidening.renewers_unbounded`).
* **Support passes on from recent gainers.** Assume balance at each condition a gainer requires,
  givers there supported, the gainer's requirements not loosening, and no formation supported at
  all `K + 1` steps from `S` to `S + K`. Then it cannot be refuted that a gain of support across the
  step from `S + K` is given, on a required condition that rises, by a supported formation taking
  part that gained support across a step from `S` to before `S + K`
  (`Flow.gain_given_by_recent_gainer_at`; with the premises everywhere,
  `Flow.gain_given_by_recent_gainer`). With support decided, and what the gainer requires listed and
  decided, the giver and its step are found (`Flow.gain_given_by_recent_gainer_decided`).
  `Flow.support_passes_on` follows with its statement (`Flow.support_passes_on_of_recent`). The law
  fixes the form of *opened by the opened*: a recency bound rather than a fixed origin, with the
  double negation inside (`Flow.OpenedByOpenedWithin`). Brief supports give it
  (`Flow.openedByOpenedWithin_of_brief`), and it is monotone in the bound
  (`Flow.OpenedByOpenedWithin.mono`). It gives the lagged form of the fixed-origin reading
  (`Flow.OpenedByOpenedWithin.lagged`), and that reading at every origin gives it with bound one
  (`Flow.openedByOpenedWithin_of_opened`).
* **The map reads keeping and carrying.** Read the web through what levels admit (`Web.admitting`).
  Then nothing admitted is lost along a continuation from `T` exactly where the admitted pattern's
  line from every admitted occurrence never ends, 不穷 (`Web.includesAcrossFrom_iff_endless`). By
  name such a range is 全守 and not 全生成 at every admitted occurrence
  (`Web.kept_of_includes_by_name`, `Web.KeepsWidening.kept_by_name`): widening by name and
  generation are disjoint. Take the continuation "carry on, or open" (`Web.passingContinuation` of
  `Flow.Opens`). There a carrying renewal 传 from a supported occurrence is exactly an opening
  (`Flow.opening_carries_iff`), and every gain of support is one, up to double negation
  (`Flow.gain_carried`). Where no formation is supported at `K + 1` consecutive steps, every
  supported line that never ends is 全生成 (`Flow.generates_of_brief`,
  `Flow.generates_of_includes_brief`). Each successor comes with its case, carrying on or opening;
  nothing is decided (`Flow.opens_or_carried_on`).

**Witnesses.** `Ladder` meets every premise of the gain bridge together, nothing coming from
nothing (`Ladder.frontier_witness`; its family is open at every step). Under upkeep it meets the
premises of the gain bridge and of renewers multiplying together (`Ladder.upkept_witness`; its
renewers are bounded from no step on). A premise is shown needed by a witness meeting the other
premises in which the conclusion fails:
* passing every bound and being fed from beyond: nothing lost
  (`ClosedCycle.bounded_while_opening`), a finite family (`OpeningChain.fixed_but_unbounded`),
  fixed needs (`Loosening.bounded_while_widening`), the first law (`Source.from_nothing`);
* renewers multiplying: upkeep (`Ladder.upkeep_needed`), capacity (`Ladder.capacity_needed`),
  balance (`Ladder.balance_needed`), nothing lost (`ClosedCycle.renewers_bounded_while_opening`);
* support passing on from recent gainers: brevity (`OpeningChain.brevity_needed`, the single giver).
  Brevity is sufficient, not necessary: the relay, its supports lasting, is opened by the opened
  within one (`OpeningChain.carriers_within`). The recency bound admits what a fixed origin
  excludes: the lagged relay is opened by the opened within two, and at no origin in the form of
  `Flow.OpenedByOpened` (`OpeningChain.within_not_fixed_origin`);
* the map's generation: brevity (`Saturated.lasting_kept`: every line kept, none generation). The
  cycle generates at every supported occurrence, while nothing is ever opened along its
  continuation and by name it keeps widening from no step
  (`ClosedCycle.generation_without_widening`). The rising course is kept
  (`OwnCondition.rising_kept`).

**Standing.** Every law here is a restatement or near-definitional. The first two read the
theory's gain and renewal laws (`Flow.newly_supported_from_rest_or_open`,
`Flow.More.renewers_unbounded_from`) for a course keeping widening. The third is
`Flow.gains_from_supported` with brevity. The map laws unfold the map's definitions beside the
pattern-passing law (`Web.begins_within`).

**Readings (the AI's, for UE7's note; not adopted).** A finite family whose kept widening goes on
is fed from beyond, by the rest or across its boundary; under upkeep its renewers multiply. Where
every support is brief, every balanced flow with recurring gains is opened by the opened, so the
property tells carriers apart only where some support lasts. Widening's first half, nothing lost, is
the 不穷 that 全生成 and 全守 share: by name it falls in 全守, and along openings with brief
supports in 全生成.

**What is not derived.** The second-order comparison of two courses; growth by kinds not given in
advance; requirements that tighten; keeping widening along a continuation other than names; that
opened by the opened gives 生成 along some branch. The representation commits to discrete steps on
one index and natural-number levels and amounts; upkeep is at least a unit a step. Passing every
bound uses that a finite family has finitely many configurations within a bound, which
natural-number amounts give. Every declaration has an empty axiom report (scratch build).
-/

namespace Becoming

variable {F C : Type}

/-! ## Counting from below -/

section Counting

variable {α : Type}

/-- An inequality of numbers that cannot be refuted holds: it is decided (`Decided.of_not_not`). -/
theorem le_of_double_negation {a b : Nat} (h : ¬ ¬ a ≤ b) : a ≤ b :=
  Decided.of_not_not (match Nat.decLe a b with
    | isTrue le => Or.inl le
    | isFalse not => Or.inr not) h

/-- **Counted from below.** A list without repetition, each member of which belongs to another list
and has a positive quantity there, is no longer than the count of the other list's members at
which the quantity is positive. The lower bound beside `count_le_of_sub`; no decision of equality
enters, since the distinctness of the first list supplies every inequality used. -/
theorem length_le_count {q : α → Nat} : ∀ {xs ps : List α}, Distinct xs →
    (∀ a, a ∈ xs → a ∈ ps ∧ 0 < q a) → xs.length ≤ count ps q
  | [], _, _, _ => Nat.zero_le _
  | a :: xs, ps, ⟨fresh, distinct⟩, within =>
    match List.append_of_mem (within a (.head xs)).1 with
    | ⟨p, r, split⟩ =>
      have inner : xs.length ≤ count (p ++ r) q :=
        length_le_count distinct fun b mem =>
          ⟨mem_remove (fun same => fresh (Eq.subst (motive := fun x => x ∈ xs) same mem))
             (Eq.subst (motive := fun l => b ∈ l) split (within b (.tail a mem)).1),
           (within b (.tail a mem)).2⟩
      have one : 1 ≤ sign (q a) := sign_pos (within a (.head xs)).2
      have whole : count ps q =
          total p (fun x => sign (q x)) + (sign (q a) + total r (fun x => sign (q x))) :=
        (congrArg (fun l => count l q) split).trans (total_append (fun x => sign (q x)) (a :: r) p)
      have rest : count (p ++ r) q = total p (fun x => sign (q x)) + total r (fun x => sign (q x)) :=
        total_append (fun x => sign (q x)) r p
      Nat.le_trans (Nat.succ_le_succ (Nat.le_trans inner (Nat.le_of_eq rest)))
        (Nat.le_trans (Nat.le_of_eq (Nat.add_assoc _ _ 1))
          (Nat.le_trans (Nat.add_le_add_left (Nat.le_trans (Nat.le_of_eq (Nat.add_comm _ 1))
              (Nat.add_le_add_right one _)) _)
            (Nat.le_of_eq whole.symm)))

/-- The members of `upto n` lie below `n`. -/
theorem upto_mem_lt : ∀ {n i : Nat}, i ∈ Undecided.upto n → i < n
  | 0, _, mem => nomatch mem
  | n + 1, _, mem => match mem_cons_cases mem with
    | .inl same => Eq.subst (motive := fun x => x < n + 1) same.symm (Nat.lt_succ_self n)
    | .inr mem => Nat.lt_succ_of_lt (upto_mem_lt mem)

theorem upto_length_self : ∀ n, (Undecided.upto n).length = n
  | 0 => rfl
  | n + 1 => congrArg Nat.succ (upto_length_self n)

theorem upto_distinct : ∀ n, Distinct (Undecided.upto n)
  | 0 => trivial
  | n + 1 => ⟨fun mem => Nat.lt_irrefl n (upto_mem_lt mem), upto_distinct n⟩

end Counting

namespace Web

variable {W : Web F C} {cs : List C}

/-! ## The gain bridge: a range keeping widening passes every bound, and is fed from beyond -/

/-- **Distinct configurations exceed.** A list of steps at which a family's configurations are
pairwise distinct, longer than the number of configurations of its members totalling at most `K`,
holds a step at which the family's stock exceeds `K`. The pigeonhole of `exceeds_of_firsts`, stated
for a list of steps rather than an increasing sequence; the step is found by checking the stock at
each listed step. -/
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

/-- **`exceeds_of_firsts` from the list form** (rule 9): the landed law, with its statement, follows
from `exceeds_of_distinct_configs` applied to the first `N + 1` steps of the sequence, `N` counting
the configurations within `K`. -/
theorem exceeds_of_firsts_of_distinct_configs {T K : Nat} {at_ : Nat → Nat}
    (increasing : ∀ i j, i < j → at_ i < at_ j) (from_ : ∀ n, T ≤ at_ n)
    (firsts : ∀ n, W.NewAt cs T (at_ n)) :
    ∃ n, n ≤ (configurationsWithin cs.length K).length ∧ K < W.stock cs (at_ n) :=
  have apart : ∀ i j, i < j → W.config cs (at_ i) ≠ W.config cs (at_ j) :=
    fun i j lt => firsts j (at_ i) (from_ i) (increasing i j lt)
  have distinct : Distinct
      (((Undecided.upto ((configurationsWithin cs.length K).length + 1)).map at_).map (W.config cs)) :=
    Eq.subst (motive := fun l => Distinct l)
      (map_comp_eq at_ (W.config cs) (Undecided.upto ((configurationsWithin cs.length K).length + 1))).symm
      (distinct_map_on (g := fun n => W.config cs (at_ n))
        (fun a b _ _ same => match Nat.lt_or_ge a b with
          | .inl lt => absurd same (apart a b lt)
          | .inr ge => match Nat.eq_or_lt_of_le ge with
            | .inl eq => eq.symm
            | .inr lt => absurd same.symm (apart b a lt))
        (upto_distinct _))
  have long : (configurationsWithin cs.length K).length <
      ((Undecided.upto ((configurationsWithin cs.length K).length + 1)).map at_).length :=
    Eq.subst (motive := fun n => (configurationsWithin cs.length K).length < n)
      ((upto_length_self _).symm.trans (length_map at_ _).symm) (Nat.lt_succ_self _)
  match exceeds_of_distinct_configs distinct long with
  | ⟨_, mem, over⟩ => match preimage_of_mem_map mem with
    | ⟨n, listed, same⟩ => ⟨n, Nat.le_of_lt_succ (upto_mem_lt listed),
        Eq.subst (motive := fun x => K < W.stock cs x) same.symm over⟩

/-- **Keeping widening lists steps of distinct configurations.** A course keeping widening by name
on the actual levels from `T`, whose formations supported from `T` on each require, fixed, only
members of `cs`, gives for every `n` a list of `n` steps from `T`, all at most some step `S`, at
which the configurations of `cs` are pairwise distinct. Each new step comes with a formation
supported there and not before (keeping opening); nothing lost keeps it unsupported at every
listed step, and what it requires reads the configuration. -/
theorem KeepsWidening.distinct_configs {T : Nat} (keeps : W.KeepsWidening itself W.level T)
    (req : ∀ t f, T ≤ t → W.Supported t f → W.RequiresWithin cs f) :
    ∀ n, ∃ ss : List Nat, ∃ S, T ≤ S ∧ ss.length = n ∧ (∀ s, s ∈ ss → T ≤ s ∧ s ≤ S) ∧
      Distinct (ss.map (W.config cs))
  | 0 => ⟨[], T, Nat.le_refl T, rfl, (fun _ mem => nomatch mem), trivial⟩
  | n + 1 => match KeepsWidening.distinct_configs keeps req n with
    | ⟨ss, S, from_, length, within, distinct⟩ => match keeps.2 S from_ with
      | ⟨U, later, exceeds⟩ => match (exceedsAcross_itself_iff later).mp exceeds with
        | ⟨g, supported, before⟩ =>
          ⟨U :: ss, U, Nat.le_trans from_ later, congrArg Nat.succ length,
           fun s mem => match mem_cons_cases mem with
            | .inl same => ⟨Eq.subst (motive := fun x => T ≤ x) same.symm
                (Nat.le_trans from_ later), Nat.le_of_eq same⟩
            | .inr mem => ⟨(within s mem).1, Nat.le_trans (within s mem).2 later⟩,
           ⟨fun mem => match preimage_of_mem_map mem with
              | ⟨s, listed, same⟩ =>
                before ((includesAcross_itself_iff (within s listed).2).mp
                  (keeps.1 s S (within s listed).1 (within s listed).2) g
                  (supported_of_config (req U g (Nat.le_trans from_ later) supported) same
                    supported)),
            distinct⟩⟩

/-- **A course keeping widening passes every bound.** Keeping widening by name on the actual levels
from `T`, its formations supported from `T` on each requiring, fixed, only members of `cs`, the
stock of `cs` exceeds every bound at arbitrarily late steps. No sequence is chosen and nothing is
decided beyond the order of numbers at finitely many listed steps. -/
theorem KeepsWidening.passes_every_bound {T : Nat} (keeps : W.KeepsWidening itself W.level T)
    (req : ∀ t f, T ≤ t → W.Supported t f → W.RequiresWithin cs f) (K M : Nat) :
    ∃ t, M ≤ t ∧ K < W.stock cs t :=
  match KeepsWidening.distinct_configs (KeepsWidening.later (Nat.le_add_left T M) keeps)
      (fun t f later => req t f (Nat.le_trans (Nat.le_add_left T M) later))
      ((configurationsWithin cs.length K).length + 1) with
  | ⟨_, _, _, length, within, distinct⟩ =>
    match exceeds_of_distinct_configs distinct
        (Eq.subst (motive := fun n => (configurationsWithin cs.length K).length < n) length.symm
          (Nat.lt_succ_self _)) with
    | ⟨s, mem, over⟩ => ⟨s, Nat.le_trans (Nat.le_add_right M T) (within s mem).1, over⟩

/-- **A course keeping widening rises at arbitrarily late steps**, on a finite family fixing what
its formations require. -/
theorem KeepsWidening.rises_late {T : Nat} (keeps : W.KeepsWidening itself W.level T)
    (req : ∀ t f, T ≤ t → W.Supported t f → W.RequiresWithin cs f) (M : Nat) :
    ∃ t, M ≤ t ∧ W.stock cs t < W.stock cs (t + 1) :=
  match keeps.passes_every_bound req (W.stock cs M) M with
  | ⟨_, later, over⟩ => match rises_between (q := W.stock cs) later over with
    | ⟨u, from_, _, up⟩ => ⟨u, from_, up⟩

/-- **The gain bridge.** Under the first law, a course keeping widening by name on the actual
levels, its formations supported from `T` on each requiring, fixed, only members of a family
without repetition, has the family given more than it takes, by the rest or across its boundary, at
arbitrarily late steps. The flow need not balance: the rest is counted. -/
theorem KeepsWidening.from_rest_or_open {L : Flow F C} {T : Nat}
    (keeps : W.KeepsWidening itself W.level T)
    (req : ∀ t f, T ≤ t → W.Supported t f → W.RequiresWithin cs f)
    (gainless : L.Gainless) (distinct : Distinct cs) (M : Nat) :
    ∃ t, M ≤ t ∧ ((L.withImbalance W).NetGiver cs t none ∨ ¬ L.ClosedAt cs t) :=
  match keeps.rises_late req M with
  | ⟨t, later, up⟩ => ⟨t, later, Flow.rise_from_rest_or_open gainless distinct up⟩

/-- **Balanced as well, the family is open at arbitrarily late steps**: where the flow balances on
it from `T₀` on, the rest gives it nothing net there, so it is given across its boundary. -/
theorem KeepsWidening.open_late {L : Flow F C} {T T₀ : Nat}
    (keeps : W.KeepsWidening itself W.level T)
    (req : ∀ t f, T ≤ t → W.Supported t f → W.RequiresWithin cs f)
    (gainless : L.Gainless) (distinct : Distinct cs)
    (balances : ∀ t, T₀ ≤ t → L.BalancesOn W cs t) (M : Nat) :
    ∃ t, M ≤ t ∧ ¬ L.ClosedAt cs t :=
  match keeps.from_rest_or_open req gainless distinct (M + T₀) with
  | ⟨t, later, .inl rest⟩ => absurd rest (Flow.BalancesOn.rest_not_netGiver
      (balances t (Nat.le_trans (Nat.le_add_left T₀ M) later)))
  | ⟨t, later, .inr open_⟩ => ⟨t, Nat.le_trans (Nat.le_add_right M T₀) later, open_⟩

end Web

namespace Flow

/-- **In a finite balanced world under the first law nothing keeps widening.** Where a list without
repetition holds every condition, the flow balances on it from `T₀` on and nothing comes from
nothing, no course keeps widening by name on the actual levels with what its formations require
fixed: the whole has no boundary to be given across. -/
theorem whole_not_keepsWidening {L : Flow F C} {W : Web F C} {all : List C}
    (every : ∀ c, c ∈ all) (distinct : Distinct all) (gainless : L.Gainless) {T₀ : Nat}
    (balances : ∀ t, T₀ ≤ t → L.BalancesOn W all t) {T : Nat}
    (req : ∀ t f, T ≤ t → W.Supported t f → W.RequiresWithin all f) :
    ¬ W.KeepsWidening Web.itself W.level T :=
  fun keeps => match keeps.open_late req gainless distinct balances 0 with
    | ⟨_, _, open_⟩ => open_ fun _ _ c out => absurd (every c) out

/-! ## Renewers multiply under upkeep -/

/-- **Taking while supported**: from step `T` on, every formation supported at a step takes part in
it and takes at least a unit from the family `cs`. -/
def TakesWhileSupported (L : Flow F C) (W : Web F C) (cs : List C) (T : Nat) : Prop :=
  ∀ t f, T ≤ t → W.Supported t f → f ∈ L.present t ∧ 0 < total cs (L.take t f)

end Flow

namespace Web

variable {W : Web F C} {cs : List C}

/-- **Keeping widening under upkeep is more without end.** A course keeping widening by name on the
actual levels from `T`, every formation supported from `T` on taking at least a unit a step from
`cs`, makes at least `K` formations take from `cs` at every step from some step on, for every `K`:
the formations gathered at one step stay supported (nothing lost) and so keep taking. -/
theorem KeepsWidening.more {L : Flow F C} {T : Nat} (keeps : W.KeepsWidening itself W.level T)
    (takes : L.TakesWhileSupported W cs T) : L.More cs :=
  fun K => match keeps.gathers K with
    | ⟨_, S, from_, length, distinct, all⟩ => ⟨S, fun t later =>
        Eq.subst (motive := fun n => n ≤ L.takers cs t) length
          (length_le_count distinct fun f mem =>
            takes t f (Nat.le_trans from_ later)
              ((includesAcross_itself_iff later).mp (keeps.1 S t from_ later) f (all f mem)))⟩

/-- **Keeping widening under upkeep needs replenishment without bound**, where the family is
balanced on from `T₀` on. -/
theorem KeepsWidening.replenishment_unbounded {L : Flow F C} {T T₀ : Nat}
    (keeps : W.KeepsWidening itself W.level T) (takes : L.TakesWhileSupported W cs T)
    (balances : ∀ t, T₀ ≤ t → L.BalancesOn W cs t) (R : Nat) :
    ¬ ∀ t, T₀ ≤ t → L.replenishment cs t ≤ R :=
  (keeps.more takes).replenishment_unbounded_from balances R

/-- **Renewers multiply.** A course keeping widening by name on the actual levels from `T`, every
formation supported from `T` on taking at least a unit a step from `cs`, with the family balanced
on from `T₀` on and each formation giving it at most `g` a step: no bound holding from `T₀` on
bounds how many formations renew the family. -/
theorem KeepsWidening.renewers_unbounded {L : Flow F C} {g T T₀ : Nat}
    (keeps : W.KeepsWidening itself W.level T) (takes : L.TakesWhileSupported W cs T)
    (balances : ∀ t, T₀ ≤ t → L.BalancesOn W cs t) (capacity : L.Capacity cs g) (M : Nat) :
    ¬ ∀ t, T₀ ≤ t → L.renewers cs t ≤ M :=
  (keeps.more takes).renewers_unbounded_from balances capacity M

end Web

/-! ## The uniform form of support passing on -/

namespace Flow

variable {L : Flow F C} {W : Web F C}

/-- **A gain is given by a recent gainer.** With balance at each condition `f` requires across the
step from `S + K`, whatever gives to such a condition there supported, `f`'s requirements not
loosening across it, and no formation supported at all of the `K + 1` steps from `S` to `S + K`:
it cannot be refuted that a gain of support by `f` across the step from `S + K` is given, on a
condition `f` requires that rises, by a supported formation taking part that itself gained support
across a step from `S` to before `S + K`. Every hypothesis is read at one step or one window. -/
theorem gain_given_by_recent_gainer_at {S K : Nat} {f : F}
    (balances : ∀ c, W.requires (S + K) f c → L.BalancesOn W [c] (S + K))
    (givers : ∀ c, W.requires (S + K) f c → L.GiversSupported W (S + K) c)
    (unloosened : W.Unloosened (S + K) f)
    (brief : ∀ g, ¬ ∀ i, i ≤ K → W.Supported (S + i) g)
    (gains : W.GainsSupport (S + K) f) :
    ¬ ¬ ∃ c g u, W.requires (S + K) f c ∧ W.Rises (S + K) c ∧ g ∈ L.present (S + K) ∧
      0 < L.give (S + K) g c ∧ W.Supported (S + K) g ∧ S ≤ u ∧ u < S + K ∧ W.GainsSupport u g :=
  fun none => gains.rises unloosened fun c requires rises =>
    match rise_given_by_supported_at (balances c requires) (givers c requires) rises with
    | ⟨g, mem, gives, supported⟩ =>
      comes_within_not_not (p := fun j => W.Supported j g) (S := S) supported (brief g)
        fun ⟨u, from_, below, fails, holds⟩ =>
          none ⟨c, g, u, requires, rises, mem, gives, supported, from_, below, fails, holds⟩

/-- **The uniform form, globally.** In a balanced flow where only active formations give and
activity needs support, with requirements never loosening and no formation supported at `K + 1`
consecutive steps, every gain of support across a step from `S + K` is, up to double negation,
given on a required condition that rises by a supported formation that gained support across a
step from `S` to before `S + K`. -/
theorem gain_given_by_recent_gainer (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) {K : Nat}
    (brief : ∀ t g, ¬ ∀ i, i ≤ K → W.Supported (t + i) g) {S : Nat} {f : F}
    (gains : W.GainsSupport (S + K) f) :
    ¬ ¬ ∃ c g u, W.requires (S + K) f c ∧ W.Rises (S + K) c ∧ g ∈ L.present (S + K) ∧
      0 < L.give (S + K) g c ∧ W.Supported (S + K) g ∧ S ≤ u ∧ u < S + K ∧ W.GainsSupport u g :=
  gain_given_by_recent_gainer_at (fun c _ => balances.on [c] (S + K))
    (fun c _ => acting.giversSupported dependent (S + K) c) (unloosened (S + K) f) (brief S) gains

/-- **Decided, the recent gainer is found.** Where support is decided at every step, and what `f`
requires across the step from `S + K` is decided and lies in a list, the giver and the step at
which it gained support are found: the law holds positively. The double negations of
`gain_given_by_recent_gainer_at` locate exactly these two things. -/
theorem gain_given_by_recent_gainer_decided {S K : Nat} {f : F}
    (decided : ∀ t g, Decidable (W.Supported t g)) {cs : List C}
    (listed : ∀ c, W.requires (S + K) f c → c ∈ cs)
    (decidedReq : ∀ c, Decidable (W.requires (S + K) f c))
    (balances : ∀ c, W.requires (S + K) f c → L.BalancesOn W [c] (S + K))
    (givers : ∀ c, W.requires (S + K) f c → L.GiversSupported W (S + K) c)
    (unloosened : W.Unloosened (S + K) f)
    (brief : ∀ g, ¬ ∀ i, i ≤ K → W.Supported (S + i) g)
    (gains : W.GainsSupport (S + K) f) :
    ∃ c g u, W.requires (S + K) f c ∧ W.Rises (S + K) c ∧ g ∈ L.present (S + K) ∧
      0 < L.give (S + K) g c ∧ W.Supported (S + K) g ∧ S ≤ u ∧ u < S + K ∧ W.GainsSupport u g :=
  match decideSome (p := fun c => W.requires (S + K) f c ∧ W.Rises (S + K) c)
      (decide := fun c => @instDecidableAnd _ _ (decidedReq c) (Nat.decLt _ _)) cs with
  | isFalse absent => absurd (fun c requires rises => absent ⟨c, listed c requires, requires, rises⟩)
      (gains.rises unloosened)
  | isTrue ⟨c, _, requires, rises⟩ =>
    match rise_given_by_supported_at (balances c requires) (givers c requires) rises with
    | ⟨g, mem, gives, supported⟩ =>
      match @upto_or_fails (fun i => W.Supported (S + i) g) (fun i => decided (S + i) g) K with
      | .inl all => absurd all (brief g)
      | .inr ⟨i, le, fails⟩ =>
        match @came_between (fun j => W.Supported j g) (fun j => decided j g) (S + i) (S + K)
            (Nat.add_le_add_left le S) fails supported with
        | ⟨u, from_, below, comes⟩ =>
          ⟨c, g, u, requires, rises, mem, gives, supported,
           Nat.le_trans (Nat.le_add_right S i) from_, below, comes⟩

/-- **`support_passes_on` from the uniform form** (rule 9): the landed law, with its statement, is a
corollary of `gain_given_by_recent_gainer`, a gain late enough taken with the window that ends at
it. -/
theorem support_passes_on_of_recent (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) {K : Nat}
    (brief : ∀ t g, ¬ ∀ i, i ≤ K → W.Supported (t + i) g)
    (recurs : ∀ N, ∃ t f, N ≤ t ∧ W.GainsSupport t f) (T N : Nat) :
    ¬ ¬ ∃ t f c g u, N ≤ t ∧ W.GainsSupport t f ∧ W.requires t f c ∧ g ∈ L.present t ∧
      0 < L.give t g c ∧ W.Supported t g ∧ T ≤ u ∧ u < t ∧ W.GainsSupport u g :=
  match recurs (N + (T + 1) + K) with
  | ⟨t, f, late, gains⟩ => match le_dest late with
    | ⟨m, at_⟩ =>
      have same : N + (T + 1) + m + K = t := (Nat.add_right_comm (N + (T + 1)) m K).trans at_.symm
      have law := Eq.subst (motive := fun x => ¬ ¬ ∃ c g u, W.requires x f c ∧ W.Rises x c ∧
          g ∈ L.present x ∧ 0 < L.give x g c ∧ W.Supported x g ∧ N + (T + 1) + m ≤ u ∧ u < x ∧
          W.GainsSupport u g) same
        (gain_given_by_recent_gainer balances acting dependent unloosened brief
          (Eq.subst (motive := fun x => W.GainsSupport x f) same.symm gains))
      fun none => law fun ⟨c, g, u, requires, _, mem, gives, supported, from_, below, gained⟩ =>
        none ⟨t, f, c, g, u,
          Nat.le_trans (Nat.le_trans (Nat.le_add_right N (T + 1)) (Nat.le_add_right _ K)) late,
          gains, requires, mem, gives, supported,
          Nat.le_trans (Nat.le_succ T) (Nat.le_trans (Nat.le_add_left (T + 1) N)
            (Nat.le_trans (Nat.le_add_right _ m) from_)),
          below, gained⟩

/-! ### Opened by the opened, within a recency bound -/

/-- **Opened by the opened within `K`**: gains of support recur, and for every step `S`, every gain
of support across the step from `S + K` is, up to double negation, given on a condition the gainer
requires and that rises across the step, by a supported formation taking part that gained support
across a step from `S` to before `S + K`. The form `gain_given_by_recent_gainer` fixes: a recency
bound rather than a fixed origin, and the double negation inside. -/
def OpenedByOpenedWithin (L : Flow F C) (W : Web F C) (K : Nat) : Prop :=
  (∀ N, ∃ t f, N ≤ t ∧ W.GainsSupport t f) ∧
    ∀ S f, W.GainsSupport (S + K) f → ¬ ¬ ∃ c g u, W.requires (S + K) f c ∧ W.Rises (S + K) c ∧
      g ∈ L.present (S + K) ∧ 0 < L.give (S + K) g c ∧ W.Supported (S + K) g ∧ S ≤ u ∧
      u < S + K ∧ W.GainsSupport u g

/-- **Brief support gives it**: in a balanced flow where only active formations give and activity
needs support, with requirements never loosening, gains recurring and no formation supported at
`K + 1` consecutive steps, the flow is opened by the opened within `K`. -/
theorem openedByOpenedWithin_of_brief (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) {K : Nat}
    (brief : ∀ t g, ¬ ∀ i, i ≤ K → W.Supported (t + i) g)
    (recurs : ∀ N, ∃ t f, N ≤ t ∧ W.GainsSupport t f) : L.OpenedByOpenedWithin W K :=
  ⟨recurs, fun _ _ gains => gain_given_by_recent_gainer balances acting dependent unloosened brief
    gains⟩

/-- Opened by the opened within `K` is opened by the opened within `K + 1`. -/
theorem OpenedByOpenedWithin.succ {K : Nat} (opened : L.OpenedByOpenedWithin W K) :
    L.OpenedByOpenedWithin W (K + 1) :=
  ⟨opened.1, fun S f gains =>
    have same : S + 1 + K = S + (K + 1) := (Nat.add_right_comm S 1 K).trans (Nat.add_assoc S K 1)
    fun none => (Eq.subst (motive := fun x => ¬ ¬ ∃ c g u, W.requires x f c ∧ W.Rises x c ∧
        g ∈ L.present x ∧ 0 < L.give x g c ∧ W.Supported x g ∧ S + 1 ≤ u ∧ u < x ∧
        W.GainsSupport u g) same
      (opened.2 (S + 1) f (Eq.subst (motive := fun x => W.GainsSupport x f) same.symm gains)))
      fun ⟨c, g, u, requires, rises, mem, gives, supported, from_, below, gained⟩ =>
        none ⟨c, g, u, requires, rises, mem, gives, supported, Nat.le_of_succ_le from_, below,
          gained⟩⟩

/-- Opened by the opened within `K` is opened by the opened within `K + m`. -/
theorem OpenedByOpenedWithin.add {K : Nat} (opened : L.OpenedByOpenedWithin W K) :
    ∀ m, L.OpenedByOpenedWithin W (K + m)
  | 0 => opened
  | m + 1 => (OpenedByOpenedWithin.add opened m).succ

/-- **The bound is monotone.** -/
theorem OpenedByOpenedWithin.mono {K K' : Nat} (le : K ≤ K') (opened : L.OpenedByOpenedWithin W K) :
    L.OpenedByOpenedWithin W K' :=
  match le_dest le with
  | ⟨m, at_⟩ => Eq.subst (motive := fun x => L.OpenedByOpenedWithin W x) at_.symm (opened.add m)

/-- **The lagged form of the fixed-origin reading.** Within `K`, every gain at a step from `T + K`
is, up to double negation, given by a formation that gained support from `T` on, earlier. -/
theorem OpenedByOpenedWithin.lagged {K : Nat} (opened : L.OpenedByOpenedWithin W K) {T t : Nat}
    {f : F} (late : T + K ≤ t) (gains : W.GainsSupport t f) :
    ¬ ¬ ∃ c g u, W.requires t f c ∧ W.Rises t c ∧ g ∈ L.present t ∧ 0 < L.give t g c ∧
      W.Supported t g ∧ T ≤ u ∧ u < t ∧ W.GainsSupport u g :=
  match le_dest late with
  | ⟨m, at_⟩ =>
    have same : T + m + K = t := (Nat.add_right_comm T m K).trans at_.symm
    fun none => (Eq.subst (motive := fun x => ¬ ¬ ∃ c g u, W.requires x f c ∧ W.Rises x c ∧
        g ∈ L.present x ∧ 0 < L.give x g c ∧ W.Supported x g ∧ T + m ≤ u ∧ u < x ∧
        W.GainsSupport u g) same
      (opened.2 (T + m) f (Eq.subst (motive := fun x => W.GainsSupport x f) same.symm gains)))
      fun ⟨c, g, u, requires, rises, mem, gives, supported, from_, below, gained⟩ =>
        none ⟨c, g, u, requires, rises, mem, gives, supported,
          Nat.le_trans (Nat.le_add_right T m) from_, below, gained⟩

/-- **The fixed-origin reading at every origin gives the bound one.** -/
theorem openedByOpenedWithin_of_opened (opened : ∀ T, L.OpenedByOpened W T) :
    L.OpenedByOpenedWithin W 1 :=
  ⟨(opened 0).1, fun S f gains => fun none =>
    match (opened S).2 (S + 1) f (Nat.lt_succ_self S) gains with
    | ⟨c, g, u, requires, rises, mem, gives, supported, from_, below, gained⟩ =>
      none ⟨c, g, u, requires, rises, mem, gives, supported, from_, below, gained⟩⟩

end Flow

/-! ## The map's generation and keeping, read on widening -/

namespace Web

/-- **The web read through what levels admit**: a formation is active at a step where the levels `l`
admit it there; levels, requirements, needs and draws are the web's. On the actual levels its
activity is support. -/
def admitting (W : Web F C) (l : Nat → C → Nat) : Web F C :=
  ⟨W.level, fun t f => W.Admits (l t) t f, W.requires, W.need, W.draws⟩

variable {R : Nat → F → F → Prop}

/-- A link chain goes forward. -/
theorem Linked.steps_le : ∀ {s : Nat} {g : F} {u : Nat} {h : F}, Linked R s g u h → s ≤ u
  | _, _, _, _, .here _ _ => Nat.le_refl _
  | _, _, _, _, .next _ rest => Nat.le_of_succ_le (Linked.steps_le rest)

/-- A link chain from a step to the same step stays at one formation. -/
theorem Linked.same_of_at : ∀ {s : Nat} {g : F} {u : Nat} {h : F}, Linked R s g u h → u = s →
    g = h
  | _, _, _, _, .here _ _, _ => rfl
  | s, _, _, _, .next _ rest, at_ =>
    absurd (Nat.le_trans (Linked.steps_le rest) (Nat.le_of_eq at_)) (Nat.not_succ_le_self s)

/-- A link chain across one step is one step of the continuation. -/
theorem Linked.one_step : ∀ {s : Nat} {g : F} {u : Nat} {h : F}, Linked R s g u h →
    u = s + 1 → R s g h
  | s, _, _, _, .here _ _, at_ => absurd (Nat.le_of_eq at_.symm) (Nat.not_succ_le_self s)
  | s, g, _, _, .next r rest, at_ =>
    Eq.subst (motive := fun x => R s g x) (Linked.same_of_at rest at_) r

/-- What a line reaches is linked to its start. -/
theorem linked_of_reached {E : «际» (Nat × F)} {x y : Nat × F}
    (reached : «所及» (continuationStep R) E x y) : Linked R x.1 x.2 y.1 y.2 :=
  match reached with
  | .inl same => Eq.subst (motive := fun z : Nat × F => Linked R x.1 x.2 z.1 z.2) same
      (.here x.1 x.2)
  | .inr line => line_linked («及之单调» (fun _ _ k => ⟨k.1, trivial⟩) _ _ line)

/-- **Nothing lost is the admitted pattern never ending.** From `T` on, along a continuation `R`,
nothing the levels `l` admit is lost exactly where, from every occurrence they admit from `T` on,
the line of the admitted pattern (the web read through `l`, with activity as its class) never
ends (不穷). -/
theorem includesAcrossFrom_iff_endless {W : Web F C} {l : Nat → C → Nat} {T : Nat} :
    W.IncludesAcrossFrom R l T ↔ ∀ S f, T ≤ S → W.Admits (l S) S f →
      «不穷» (continuationStep R) (W.admitting l).activityClass (S, f) :=
  ⟨fun includes S f from_ admitted y reached =>
     have admittedY : W.Admits (l y.1) y.1 y.2 :=
       active_along_line (W := W.admitting l) (x := (S, f)) admitted reached
     match includes y.1 (y.1 + 1) (Nat.le_trans from_ (reached_later reached)) (Nat.le_succ _)
         y.2 admittedY with
     | ⟨g, linked, admittedG⟩ =>
       ⟨(y.1 + 1, g), ⟨⟨rfl, Linked.one_step linked rfl⟩, ⟨fun _ => admittedG, fun _ => admittedY⟩⟩⟩,
   fun endless S U from_ le f admitted => match le_dest le with
     | ⟨k, at_⟩ => match reaches_onward (endless S f from_ admitted) k with
       | ⟨y, reached, step⟩ =>
         have here : y.1 = U := step.trans at_.symm
         ⟨y.2, Eq.subst (motive := fun s => Linked R S f s y.2) here (linked_of_reached reached),
          Eq.subst (motive := fun s => W.Admits (l s) s y.2) here
            (active_along_line (W := W.admitting l) (x := (S, f)) admitted reached)⟩⟩

/-- **By name, losing nothing is keeping.** Where nothing the levels `l` admit is lost by name from
`T` on, at every occurrence they admit from `T` on the admitted pattern's line is 全守 and not
全生成. -/
theorem kept_of_includes_by_name {W : Web F C} {l : Nat → C → Nat} {T : Nat}
    (includes : W.IncludesAcrossFrom itself l T) {S : Nat} {f : F} (from_ : T ≤ S)
    (admitted : W.Admits (l S) S f) :
    «全守» (continuationStep itself) (W.admitting l).activityClass (W.admitting l).carrierClass
        (S, f) ∧
      ¬ «全生成» (continuationStep itself) (W.admitting l).activityClass
        (W.admitting l).carrierClass (S, f) :=
  ⟨itself_keeps (includesAcrossFrom_iff_endless.mp includes S f from_ admitted),
   itself_not_generation (S, f)⟩

/-- **By name, a range keeping widening is kept.** At every occurrence a course keeping widening by
name admits from `T` on, the admitted pattern's line is 全守 and not 全生成: widening by name and
generation are disjoint. -/
theorem KeepsWidening.kept_by_name {W : Web F C} {l : Nat → C → Nat} {T : Nat}
    (keeps : W.KeepsWidening itself l T) {S : Nat} {f : F} (from_ : T ≤ S)
    (admitted : W.Admits (l S) S f) :
    «全守» (continuationStep itself) (W.admitting l).activityClass (W.admitting l).carrierClass
        (S, f) ∧
      ¬ «全生成» (continuationStep itself) (W.admitting l).activityClass
        (W.admitting l).carrierClass (S, f) :=
  kept_of_includes_by_name keeps.1 from_ admitted

end Web

namespace Flow

/-- **`g` opens `f`** across the step from `t`: `g` takes part and is supported, gives to a
condition `f` requires that rises across the step, and `f` gains support across it. -/
def Opens (L : Flow F C) (W : Web F C) (t : Nat) (g f : F) : Prop :=
  g ∈ L.present t ∧ W.Supported t g ∧ W.GainsSupport t f ∧
    ∃ c, W.requires t f c ∧ W.Rises t c ∧ 0 < L.give t g c

variable {L : Flow F C} {W : Web F C}

/-- **Openings are the carrying renewals of support.** Read through the actual levels (activity is
support), along the continuation in which each formation carries on or opens another, a carrying
renewal (`«传»`) from a supported occurrence is exactly an opening. -/
theorem opening_carries_iff {t : Nat} {g f : F} (supported : W.Supported t g) :
    «传» (Web.continuationStep (Web.passingContinuation (L.Opens W)))
        (W.admitting W.level).activityClass (W.admitting W.level).carrierClass (t, g) (t + 1, f) ↔
      L.Opens W t g f :=
  ⟨fun c => ((Web.passing_carries_iff (V := W.admitting W.level) supported).mp c).1,
   fun opens => (Web.passing_carries_iff (V := W.admitting W.level) supported).mpr
     ⟨opens, opens.2.2.1⟩⟩

/-- **Every gain of support is a carrying renewal**, up to double negation: with balance at each
condition `f` requires across the step, whatever gives to such a condition supported, and `f`'s
requirements not loosening, a gain of support by `f` is the end of a carrying renewal from a
supported occurrence along "carry on, or open". -/
theorem gain_carried {t : Nat} {f : F}
    (balances : ∀ c, W.requires t f c → L.BalancesOn W [c] t)
    (givers : ∀ c, W.requires t f c → L.GiversSupported W t c)
    (unloosened : W.Unloosened t f) (gains : W.GainsSupport t f) :
    ¬ ¬ ∃ g, W.Supported t g ∧ «传» (Web.continuationStep (Web.passingContinuation (L.Opens W)))
      (W.admitting W.level).activityClass (W.admitting W.level).carrierClass (t, g) (t + 1, f) :=
  fun none => gains.rises unloosened fun c requires rises =>
    match rise_given_by_supported_at (balances c requires) (givers c requires) rises with
    | ⟨g, mem, gives, supported⟩ =>
      none ⟨g, supported, (opening_carries_iff supported).mpr
        ⟨mem, supported, gains, c, requires, rises, gives⟩⟩

/-- Along "carry on, or open", from an occurrence `y` reached from a supported start whose line
never ends, an opening lies ahead, or `y`'s formation is carried on and supported through the next
`j` steps. Each successor is given with the case it is (carrying on, or an opening); nothing is
decided. -/
theorem opens_or_carried_on {x : Nat × F} (start : W.Supported x.1 x.2)
    (endless : «不穷» (Web.continuationStep (Web.passingContinuation (L.Opens W)))
      (W.admitting W.level).activityClass x)
    {y : Nat × F} (reached : «所及» (Web.continuationStep (Web.passingContinuation (L.Opens W)))
      (W.admitting W.level).activityClass x y) :
    ∀ j, (∃ z w, «所及» (Web.continuationStep (Web.passingContinuation (L.Opens W)))
        (W.admitting W.level).activityClass y z ∧
        «传» (Web.continuationStep (Web.passingContinuation (L.Opens W)))
          (W.admitting W.level).activityClass (W.admitting W.level).carrierClass z w) ∨
      ((∀ i, i ≤ j → W.Supported (y.1 + i) y.2) ∧
        ∃ z, «所及» (Web.continuationStep (Web.passingContinuation (L.Opens W)))
          (W.admitting W.level).activityClass y z ∧ z.1 = y.1 + j ∧ z.2 = y.2)
  | 0 => .inr ⟨fun _ le => Eq.subst (motive := fun k => W.Supported (y.1 + k) y.2)
        (Nat.eq_zero_of_le_zero le).symm
        (Web.active_along_line (W := W.admitting W.level) (x := x) start reached),
      y, .inl rfl, rfl, rfl⟩
  | j + 1 => match opens_or_carried_on start endless reached j with
    | .inl found => .inl found
    | .inr ⟨carried, z, toZ, atZ, formZ⟩ =>
      have fromX := «所及之传递» reached toZ
      have supportedZ : W.Supported z.1 z.2 :=
        Web.active_along_line (W := W.admitting W.level) start fromX
      match endless z fromX with
      | ⟨w, step⟩ => match step.1.2 with
        | .inl same =>
          have atW : w.1 = y.1 + (j + 1) := step.1.1.trans (congrArg (· + 1) atZ)
          have formW : w.2 = y.2 := same.symm.trans formZ
          have supportedW : W.Supported w.1 w.2 :=
            Web.active_along_line (W := W.admitting W.level) start
              («所及之传递» fromX (.inr (.one step)))
          .inr ⟨fun i le => match le_succ_cases le with
              | .inl before => carried i before
              | .inr now => Eq.subst (motive := fun k => W.Supported (y.1 + k) y.2) now.symm
                  (Eq.subst (motive := fun s => W.Supported s y.2) atW
                    (Eq.subst (motive := fun g => W.Supported w.1 g) formW supportedW)),
            w, «所及之传递» toZ (.inr (.one step)), atW, formW⟩
        | .inr opens => .inl ⟨z, w, toZ,
            Eq.subst (motive := fun s => «传» (Web.continuationStep
                (Web.passingContinuation (L.Opens W))) (W.admitting W.level).activityClass
                (W.admitting W.level).carrierClass z (s, w.2))
              step.1.1.symm ((opening_carries_iff supportedZ).mpr opens)⟩

/-- **Brief supports make every lasting supported line generation.** Where no formation is supported
at `K + 1` consecutive steps, every supported occurrence whose line along "carry on, or open" never
ends is 全生成: ahead of every point of the line lies an opening, within `K` steps. -/
theorem generates_of_brief {K : Nat} (brief : ∀ t g, ¬ ∀ i, i ≤ K → W.Supported (t + i) g)
    {x : Nat × F} (start : W.Supported x.1 x.2)
    (endless : «不穷» (Web.continuationStep (Web.passingContinuation (L.Opens W)))
      (W.admitting W.level).activityClass x) :
    «全生成» (Web.continuationStep (Web.passingContinuation (L.Opens W)))
      (W.admitting W.level).activityClass (W.admitting W.level).carrierClass x :=
  ⟨endless, fun y reached => match opens_or_carried_on start endless reached K with
    | .inl found => found
    | .inr ⟨carried, _⟩ => absurd carried (brief y.1 y.2)⟩

/-- **Losing nothing along openings, with brief supports, is generation.** Where nothing supported
is lost along "carry on, or open" from `T` on and no formation is supported at `K + 1` consecutive
steps, every occurrence supported from `T` on is 全生成. -/
theorem generates_of_includes_brief {K T : Nat}
    (brief : ∀ t g, ¬ ∀ i, i ≤ K → W.Supported (t + i) g)
    (includes : W.IncludesAcrossFrom (Web.passingContinuation (L.Opens W)) W.level T)
    {S : Nat} {f : F} (from_ : T ≤ S) (supported : W.Supported S f) :
    «全生成» (Web.continuationStep (Web.passingContinuation (L.Opens W)))
      (W.admitting W.level).activityClass (W.admitting W.level).carrierClass (S, f) :=
  generates_of_brief brief supported
    (Web.includesAcrossFrom_iff_endless.mp includes S f from_ supported)

end Flow

/-! ## Witnesses -/

namespace OwnCondition

theorem rung_le_one : ∀ c t, rung c t ≤ 1
  | 0, _ => Nat.le_refl 1
  | _ + 1, 0 => Nat.zero_le 1
  | c + 1, t + 1 => (rung_le_one c t : rung c t ≤ 1)

/-- **By name, the rising course is kept**: at every occurrence it admits, the admitted pattern's
line is 全守 and not 全生成. -/
theorem rising_kept {S n : Nat} (le : n ≤ S) :
    «全守» (Web.continuationStep Web.itself) (web.admitting rising).activityClass
        (web.admitting rising).carrierClass (S, n) ∧
      ¬ «全生成» (Web.continuationStep Web.itself) (web.admitting rising).activityClass
        (web.admitting rising).carrierClass (S, n) :=
  rising_keeps_widening.kept_by_name (Nat.zero_le S) (rising_iff.mpr le)

end OwnCondition

/-! ### The ladder: the gain bridge's premises and those of renewers multiplying, together -/

namespace Ladder

/-- One at condition zero, nothing elsewhere. -/
def atZero : Nat → Nat
  | 0 => 1
  | _ + 1 => 0

theorem atZero_pos : ∀ {c : Nat}, 0 < atZero c → c = 0
  | 0, _ => rfl
  | _ + 1, pos => absurd pos (Nat.lt_irrefl 0)

/-- One where the two agree, nothing elsewhere. -/
def same : Nat → Nat → Nat
  | 0, 0 => 1
  | 0, _ + 1 => 0
  | _ + 1, 0 => 0
  | a + 1, b + 1 => same a b

theorem same_self : ∀ n, same n n = 1
  | 0 => rfl
  | n + 1 => same_self n

/-- At step `t`, one while `t` is at most `c`, nothing after: the unit standing at condition `c + 1`
until it is taken. -/
def unusedAt : Nat → Nat → Nat
  | 0, _ => 1
  | _ + 1, 0 => 0
  | t + 1, c + 1 => unusedAt t c

theorem unused_step : ∀ c t, unusedAt (t + 1) c + same c t = unusedAt t c
  | 0, 0 => rfl
  | _ + 1, 0 => rfl
  | 0, _ + 1 => rfl
  | c + 1, t + 1 => unused_step c t

/-- Condition `0` stands at `t + 1` at step `t`; condition `c + 1` holds one unit up to step `c`. -/
def levelAt : Nat → Nat → Nat
  | t, 0 => t + 1
  | t, c + 1 => unusedAt t c

/-- The carrier `none` requires nothing; formation `some n` requires condition `0`. -/
def requiresOf : Option Nat → Nat → Prop
  | none, _ => False
  | some _, c => c = 0

/-- Formation `some n` needs `n + 1` of condition `0`. -/
def needOf : Option Nat → Nat
  | none => 0
  | some n => n + 1

/-- The carrier is active throughout; formation `some n` from step `n` on. -/
def activeAt : Nat → Option Nat → Prop
  | _, none => True
  | t, some n => n ≤ t

/-- **The ladder**: condition `0` rises by one a step; formation `some n`, requiring `n + 1` of it,
is supported from step `n` on; the carrier `none` requires nothing; and each condition `c + 1`
holds a unit up to step `c`. -/
def web : Web (Option Nat) Nat :=
  ⟨levelAt, activeAt, fun _ => requiresOf, fun _ f _ => needOf f, fun _ _ _ => False⟩

theorem supported_some {t n : Nat} : web.Supported t (some n) ↔ n ≤ t :=
  ⟨fun supported => Nat.le_of_succ_le_succ (supported 0 rfl),
   fun le _ same => Eq.subst (motive := fun x => n + 1 ≤ levelAt t x) same.symm
     (Nat.succ_le_succ le)⟩

theorem supported_none {t : Nat} : web.Supported t none := fun _ no => nomatch no

/-- **The ladder keeps widening by name.** -/
theorem keeps_widening : web.KeepsWidening Web.itself web.level 0 :=
  ⟨fun _ _ _ later => (Web.includesAcross_itself_iff later).mpr fun f admitted =>
      match f, admitted with
      | none, _ => supported_none
      | some _, admitted => supported_some.mpr (Nat.le_trans (supported_some.mp admitted) later),
   fun S _ => ⟨S + 1, Nat.le_succ S, (Web.exceedsAcross_itself_iff (Nat.le_succ S)).mpr
      ⟨some (S + 1), supported_some.mpr (Nat.le_refl _),
       fun admitted => Nat.not_succ_le_self S (supported_some.mp admitted)⟩⟩⟩

/-- What every formation requires is fixed and lies within `[0]`. -/
theorem requiresWithin : ∀ f, web.RequiresWithin [0] f
  | some _, _, _, _, req => ⟨req, rfl, Eq.subst (motive := fun x => x ∈ [0]) req.symm (.head [])⟩
  | none, _, _, _, req => nomatch req

/-- **The frontier**: at step `t` the carrier alone takes part; it takes the unit standing at
condition `t + 1` and gives it to condition `0`. -/
def frontier : Flow (Option Nat) Nat :=
  ⟨fun _ => [none], fun t _ c => same c (t + 1), fun _ _ c => atZero c⟩

theorem frontier_balances : frontier.Balances web := fun t c => match c with
  | 0 => rfl
  | c + 1 => unused_step c t

/-- Under the frontier nothing comes from nothing. -/
theorem frontier_gainless : frontier.Gainless := fun cs t distinct closed f mem =>
  have notOut : ¬ ¬ (t + 1) ∈ cs := fun out =>
    Nat.noConfusion ((same_self (t + 1)).symm.trans (closed f mem (t + 1) out).1)
  le_of_double_negation fun notLe => notOut fun inside => notLe
    (Nat.le_trans (total_le_at (a := 0) (fun _ pos => atZero_pos pos) distinct)
      (Nat.le_trans (Nat.le_of_eq (same_self (t + 1)).symm)
        (le_total_of_mem (q := fun c => same c (t + 1)) inside)))

/-- Under the frontier the family `[0]` is open at every step. -/
theorem frontier_open (t : Nat) : ¬ frontier.ClosedAt [0] t := fun closed =>
  Nat.noConfusion ((same_self (t + 1)).symm.trans
    (closed none (.head []) (t + 1) fun mem => match mem_cons_cases mem with
      | .inl same => Nat.noConfusion same
      | .inr no => nomatch no).1)

/-- **The gain bridge's premises hold together**: the ladder keeps widening by name, what its
formations require is fixed within `[0]`, and the frontier balances under the first law. `[0]` is
open at every step: its frontier of fresh conditions is what the gain bridge says must exist. -/
theorem frontier_witness :
    web.KeepsWidening Web.itself web.level 0 ∧ (∀ f, web.RequiresWithin [0] f) ∧
      frontier.Gainless ∧ frontier.Balances web ∧ ∀ t, ¬ frontier.ClosedAt [0] t :=
  ⟨keeps_widening, requiresWithin, frontier_gainless, frontier_balances, frontier_open⟩

/-- The stock of `[0]` passes every bound, by the gain bridge. -/
theorem stock_unbounded : ∀ K M, ∃ t, M ≤ t ∧ K < web.stock [0] t :=
  keeps_widening.passes_every_bound fun _ f _ _ => requiresWithin f

/-- At step `t` the carrier and the formations `some 0`, …, `some t` take part. -/
def takingPart (t : Nat) : List (Option Nat) := none :: (Undecided.upto (t + 1)).map some

/-- Under upkeep each takes a unit from condition `0`; the carrier also takes the unit standing at
condition `t + 1`. -/
def upkeepTake (t : Nat) : Option Nat → Nat → Nat
  | none, c => atZero c + same c (t + 1)
  | some _, c => atZero c

/-- Under upkeep each gives a unit back to condition `0`; the carrier gives one more. -/
def upkeepGive : Option Nat → Nat → Nat
  | none, c => atZero c + atZero c
  | some _, c => atZero c

/-- **Upkeep**: every supported formation takes part, takes a unit from condition `0` and gives it
back; the carrier also brings the unit standing at condition `t + 1`. -/
def upkept : Flow (Option Nat) Nat := ⟨takingPart, upkeepTake, fun _ => upkeepGive⟩

/-- A balance kept when the same amount is added to what is taken and given. -/
theorem shift_balance {a b s z x : Nat} (h : a + s = b + z) :
    a + ((z + s) + x) = b + ((z + z) + x) :=
  (congrArg (a + ·) ((congrArg (· + x) (Nat.add_comm z s)).trans (Nat.add_assoc s z x))).trans
    ((Nat.add_assoc a s (z + x)).symm.trans
      ((congrArg (· + (z + x)) h).trans
        ((Nat.add_assoc b z (z + x)).trans (congrArg (b + ·) (Nat.add_assoc z z x).symm))))

theorem upkept_balances : upkept.Balances web := fun t c =>
  have base : web.level (t + 1) c + same c (t + 1) = web.level t c + atZero c :=
    frontier_balances t c
  (shift_balance (x := total ((Undecided.upto (t + 1)).map some) (fun f => upkeepTake t f c))
    base).trans
    (congrArg (fun x => web.level t c + ((atZero c + atZero c) + x))
      ((total_map some (fun f => upkeepTake t f c) (Undecided.upto (t + 1))).trans
        (total_map some (fun f => upkeepGive f c) (Undecided.upto (t + 1))).symm))

theorem upkept_takes : upkept.TakesWhileSupported web [0] 0 := fun _ f _ supported =>
  match f, supported with
  | none, _ => ⟨.head _, Nat.zero_lt_one⟩
  | some _, supported => ⟨.tail none (mem_map_of
      (Undecided.mem_upto (Nat.lt_succ_of_le (supported_some.mp supported)))), Nat.zero_lt_one⟩

theorem upkept_capacity : upkept.Capacity [0] 2 := fun _ f _ => match f with
  | none => Nat.le_refl 2
  | some _ => Nat.le_succ 1

/-- Under upkeep nothing comes from nothing. -/
theorem upkept_gainless : upkept.Gainless := fun cs t distinct closed f mem =>
  match f, mem with
  | some _, _ => Nat.le_refl _
  | none, mem =>
    have notOut : ¬ ¬ (t + 1) ∈ cs := fun out =>
      Nat.noConfusion ((same_self (t + 1)).symm.trans
        ((Nat.zero_add _).symm.trans (closed none mem (t + 1) out).1))
    have inner : total cs atZero ≤ total cs (fun c => same c (t + 1)) :=
      le_of_double_negation fun notLe => notOut fun inside => notLe
        (Nat.le_trans (total_le_at (a := 0) (fun _ pos => atZero_pos pos) distinct)
          (Nat.le_trans (Nat.le_of_eq (same_self (t + 1)).symm)
            (le_total_of_mem (q := fun c => same c (t + 1)) inside)))
    show total cs (fun c => atZero c + atZero c) ≤ total cs (fun c => atZero c + same c (t + 1)) from
      Nat.le_trans (Nat.le_of_eq (total_add atZero atZero cs))
        (Nat.le_trans (Nat.add_le_add_left inner _)
          (Nat.le_of_eq (total_add atZero (fun c => same c (t + 1)) cs).symm))

/-- **The premises of renewers multiplying hold together, under the first law as well**: the ladder
keeps widening by name; under upkeep every supported formation takes a unit a step from `[0]`, the
flow balances, each gives at most two, and nothing comes from nothing. Its renewers of `[0]` are
bounded from no step on. -/
theorem upkept_witness :
    web.KeepsWidening Web.itself web.level 0 ∧ upkept.TakesWhileSupported web [0] 0 ∧
      upkept.Balances web ∧ upkept.Capacity [0] 2 ∧ upkept.Gainless ∧
      ∀ M, ¬ ∀ t, 0 ≤ t → upkept.renewers [0] t ≤ M :=
  ⟨keeps_widening, upkept_takes, upkept_balances, upkept_capacity, upkept_gainless,
   fun M => keeps_widening.renewers_unbounded upkept_takes (fun t _ => upkept_balances.on [0] t)
     upkept_capacity M⟩

theorem frontier_capacity : frontier.Capacity [0] 1 := fun _ _ _ => Nat.le_refl 1

theorem frontier_renewers (t : Nat) : frontier.renewers [0] t ≤ 1 :=
  show sign (total [0] (frontier.give t none)) + 0 ≤ 1 from sign_le_one _

/-- **Upkeep cannot be dropped from `Web.KeepsWidening.renewers_unbounded`**: without it the
frontier keeps the ladder widening with one renewer a step, balanced and with capacity one. -/
theorem upkeep_needed :
    web.KeepsWidening Web.itself web.level 0 ∧ frontier.Balances web ∧ frontier.Capacity [0] 1 ∧
      ∀ t, frontier.renewers [0] t ≤ 1 :=
  ⟨keeps_widening, frontier_balances, frontier_capacity, frontier_renewers⟩

/-- What the one renewer gives: all that is taken from condition `0`, and one unit more. -/
def oneGive (t : Nat) : Option Nat → Nat → Nat
  | none, 0 => total (takingPart t) (fun f => upkeepTake t f 0) + 1
  | none, _ + 1 => 0
  | some _, _ => 0

/-- **One renewer**: as under upkeep, but the carrier alone gives. -/
def oneRenewer : Flow (Option Nat) Nat := ⟨takingPart, upkeepTake, oneGive⟩

theorem oneRenewer_balances : oneRenewer.Balances web := fun t c => match c with
  | 0 =>
    (Nat.succ_add (t + 1) (total (takingPart t) (fun f => upkeepTake t f 0))).trans
      (congrArg (fun x => (t + 1) + ((total (takingPart t) (fun f => upkeepTake t f 0) + 1) + x))
        ((total_map some (fun f => oneGive t f 0) (Undecided.upto (t + 1))).trans
          (total_zero (Undecided.upto (t + 1)))).symm)
  | c + 1 =>
    (congrArg (fun x => unusedAt (t + 1) c + ((0 + same c t) + x))
      ((total_map some (fun f => upkeepTake t f (c + 1)) (Undecided.upto (t + 1))).trans
        (total_zero (Undecided.upto (t + 1))))).trans
    ((congrArg (fun x => unusedAt (t + 1) c + x) (Nat.zero_add (same c t))).trans
      ((unused_step c t).trans
        (congrArg (fun x => unusedAt t c + (0 + x))
          ((total_map some (fun f => oneGive t f (c + 1)) (Undecided.upto (t + 1))).trans
            (total_zero (Undecided.upto (t + 1)))).symm)))

theorem oneRenewer_renewers (t : Nat) : oneRenewer.renewers [0] t ≤ 1 :=
  Nat.le_trans (Nat.le_of_eq (congrArg (sign (total [0] (oneGive t none)) + ·)
      ((total_map some (fun f => sign (total [0] (oneGive t f))) (Undecided.upto (t + 1))).trans
        (total_zero (Undecided.upto (t + 1))))))
    (sign_le_one _)

/-- **Capacity cannot be dropped from `Web.KeepsWidening.renewers_unbounded`**: with the carrier
giving all that is taken, and one more, every premise but capacity holds and one formation renews
the family. -/
theorem capacity_needed :
    web.KeepsWidening Web.itself web.level 0 ∧ oneRenewer.TakesWhileSupported web [0] 0 ∧
      oneRenewer.Balances web ∧ ∀ t, oneRenewer.renewers [0] t ≤ 1 :=
  ⟨keeps_widening, upkept_takes, oneRenewer_balances, oneRenewer_renewers⟩

/-- **No giving**: as under upkeep, but nothing gives. -/
def unbalanced : Flow (Option Nat) Nat := ⟨takingPart, upkeepTake, fun _ _ _ => 0⟩

/-- **Balance cannot be dropped from `Web.KeepsWidening.renewers_unbounded`**: without it nothing
ties the renewers to the uptake; here nothing gives, with every other premise holding. -/
theorem balance_needed :
    web.KeepsWidening Web.itself web.level 0 ∧ unbalanced.TakesWhileSupported web [0] 0 ∧
      unbalanced.Capacity [0] 0 ∧ ∀ t, unbalanced.renewers [0] t = 0 :=
  ⟨keeps_widening, upkept_takes, fun _ _ _ => Nat.le_refl 0,
   fun t => total_zero (takingPart t)⟩

end Ladder

/-! ### The cycle: what nothing lost does in the first two laws, and generation without widening -/

namespace ClosedCycle

theorem mark_sum : ∀ b : Bool, mark false b + (mark true b + 0) = 1
  | true => rfl
  | false => rfl

/-- In the cycle nothing comes from nothing. -/
theorem gainless : flow.Gainless := fun cs _ distinct closed g mem =>
  have notOut : ¬ ¬ g ∈ cs := fun out =>
    Nat.noConfusion ((mark_self g).symm.trans (closed g mem g out).1)
  le_of_double_negation fun notLe => notOut fun inside => notLe
    (Nat.le_trans (Nat.le_trans (total_le_at (a := !g) (fun _ pos => mark_pos_iff.mp pos) distinct)
        (Nat.le_of_eq (mark_self (!g))))
      (Nat.le_trans (Nat.le_of_eq (mark_self g).symm) (le_total_of_mem (q := fun c => mark c g)
        inside)))

/-- By name the cycle keeps opening from step `0`. -/
theorem keeps_opening_by_name : web.KeepsOpening Web.itself web.level 0 :=
  fun S _ => ⟨S + 1, Nat.le_succ S, (Web.exceedsAcross_itself_iff (Nat.le_succ S)).mpr
    ⟨parity (S + 1), supported_iff.mpr rfl,
     fun supported => not_ne (parity S) (supported_iff.mp supported)⟩⟩

theorem requiresWithin : ∀ f, web.RequiresWithin [false, true] f :=
  fun _ _ _ c req => ⟨req, rfl, listed c⟩

theorem stock_one (t : Nat) : web.stock [false, true] t = 1 := mark_sum (parity t)

theorem closed (t : Nat) : flow.ClosedAt [false, true] t := fun _ _ c out => absurd (listed c) out

theorem distinct : Distinct [false, true] :=
  ⟨fun mem => match mem_cons_cases mem with
    | .inl same => Bool.noConfusion same
    | .inr no => (nomatch no),
   (fun no => nomatch no), trivial⟩

/-- **Nothing lost cannot be dropped from the gain bridge**: the cycle keeps opening by name with
what its formations require fixed within `[false, true]`, a list without repetition, balanced under
the first law, while the family's stock is one throughout and it is never given from beyond. -/
theorem bounded_while_opening :
    flow.Gainless ∧ flow.Balances web ∧ web.KeepsOpening Web.itself web.level 0 ∧
      (∀ f, web.RequiresWithin [false, true] f) ∧ Distinct [false, true] ∧
      (∀ t, web.stock [false, true] t = 1) ∧
      ∀ t, ¬ ((flow.withImbalance web).NetGiver [false, true] t none ∨
        ¬ flow.ClosedAt [false, true] t) :=
  ⟨gainless, balances, keeps_opening_by_name, requiresWithin, distinct, stock_one,
   fun t given => match given with
    | .inl rest => Flow.BalancesOn.rest_not_netGiver (balances.on [false, true] t) rest
    | .inr open_ => open_ (closed t)⟩

theorem takes_while_supported : flow.TakesWhileSupported web [false, true] 0 :=
  fun t f _ supported =>
    have same : f = parity t := supported_iff.mp supported
    ⟨Eq.subst (motive := fun x => x ∈ flow.present t) same.symm (.head []),
     Eq.subst (motive := fun x => 0 < x) (mark_sum f).symm Nat.zero_lt_one⟩

theorem capacity : flow.Capacity [false, true] 1 := fun _ f _ => Nat.le_of_eq (mark_sum (!f))

theorem renewers_le (t : Nat) : flow.renewers [false, true] t ≤ 1 :=
  show sign (total [false, true] (flow.give t (parity t))) + 0 ≤ 1 from sign_le_one _

/-- **Nothing lost cannot be dropped from `Web.KeepsWidening.renewers_unbounded`**: keeping opening
by name under upkeep, balanced, with capacity one, the cycle has one renewer a step. -/
theorem renewers_bounded_while_opening :
    web.KeepsOpening Web.itself web.level 0 ∧ flow.TakesWhileSupported web [false, true] 0 ∧
      flow.Balances web ∧ flow.Capacity [false, true] 1 ∧ ∀ t, flow.renewers [false, true] t ≤ 1 :=
  ⟨keeps_opening_by_name, takes_while_supported, balances, capacity, renewers_le⟩

/-- No formation of the cycle is supported at two consecutive steps. -/
theorem brief : ∀ t g, ¬ ∀ i, i ≤ 1 → web.Supported (t + i) g := fun t _ all =>
  not_ne (parity t) ((supported_iff.mp (all 1 (Nat.le_refl 1))).symm.trans
    (supported_iff.mp (all 0 (Nat.zero_le 1))))

theorem unloosened : ∀ t f, web.Unloosened t f := fun _ _ _ req => ⟨req, Nat.le_refl 1⟩

/-- **The cycle is opened by the opened within one**, by brevity. -/
theorem opened_within : Flow.OpenedByOpenedWithin flow web 1 :=
  Flow.openedByOpenedWithin_of_brief balances acting dependent unloosened brief opened.1

/-- The active formation opens the other at every step. -/
theorem opens_next (t : Nat) : flow.Opens web t (parity t) (parity (t + 1)) :=
  ⟨.head [], supported_iff.mpr rfl, gains_iff.mpr rfl, parity (t + 1), rfl, rises_at rfl,
   give_pos rfl⟩

theorem linked_opening : ∀ (k S : Nat),
    Web.Linked (Web.passingContinuation (flow.Opens web)) S (parity S) (S + k) (parity (S + k))
  | 0, S => .here S (parity S)
  | k + 1, S => .next (f := parity (S + 1)) (.inr (opens_next S))
      (Eq.subst (motive := fun x => Web.Linked (Web.passingContinuation (flow.Opens web)) (S + 1)
          (parity (S + 1)) x (parity x))
        (Nat.succ_add S k) (linked_opening k (S + 1)))

theorem linked_opening_to {S U : Nat} (le : S ≤ U) :
    Web.Linked (Web.passingContinuation (flow.Opens web)) S (parity S) U (parity U) :=
  match le_dest le with
  | ⟨k, at_⟩ => Eq.subst (motive := fun x => Web.Linked (Web.passingContinuation (flow.Opens web))
      S (parity S) x (parity x)) at_.symm (linked_opening k S)

/-- Along "carry on, or open" nothing supported is lost. -/
theorem includes_opening :
    web.IncludesAcrossFrom (Web.passingContinuation (flow.Opens web)) web.level 0 :=
  fun S U _ le _ admitted => ⟨parity U,
    Eq.subst (motive := fun x => Web.Linked (Web.passingContinuation (flow.Opens web)) S x U
        (parity U))
      (supported_iff.mp admitted).symm (linked_opening_to le),
    supported_iff.mpr rfl⟩

/-- Along "carry on, or open" nothing is opened. -/
theorem not_opening_along (T : Nat) :
    ¬ web.KeepsOpening (Web.passingContinuation (flow.Opens web)) web.level T :=
  fun opens => match opens T (Nat.le_refl T) with
    | ⟨U, le, ⟨_, admitted, apart⟩⟩ =>
      apart (parity T)
        (Eq.subst (motive := fun x => Web.Linked (Web.passingContinuation (flow.Opens web)) T
            (parity T) U x)
          (supported_iff.mp admitted).symm (linked_opening_to le))
        (supported_iff.mpr rfl)

/-- **Generation without widening.** At every supported occurrence of the cycle the line along
"carry on, or open" is 全生成, while along it nothing is ever opened and by name the range keeps
widening from no step. -/
theorem generation_without_widening :
    (∀ S f, web.Supported S f →
      «全生成» (Web.continuationStep (Web.passingContinuation (flow.Opens web)))
        (web.admitting web.level).activityClass (web.admitting web.level).carrierClass (S, f)) ∧
      (∀ T, ¬ web.KeepsOpening (Web.passingContinuation (flow.Opens web)) web.level T) ∧
      ∀ T, ¬ web.KeepsWidening Web.itself web.level T :=
  ⟨fun S _ supported => Flow.generates_of_includes_brief brief includes_opening (Nat.zero_le S)
     supported,
   not_opening_along, not_keeps_widening_by_name⟩

end ClosedCycle

/-! ### Saturation: lasting support keeps and never generates -/

namespace Saturated

theorem supported (t n : Nat) : web.Supported t n := fun _ _ => Nat.le_refl 1

theorem no_carry (z w : Nat × Nat) :
    ¬ «传» (Web.continuationStep (Web.passingContinuation (still.Opens web)))
      (web.admitting web.level).activityClass (web.admitting web.level).carrierClass z w :=
  fun ⟨⟨⟨next, kind⟩, alike⟩, begins⟩ => match kind with
    | .inl same => begins ⟨z, ⟨next, kind⟩, alike, same⟩
    | .inr opens => nomatch opens.1

theorem endless (x : Nat × Nat) :
    «不穷» (Web.continuationStep (Web.passingContinuation (still.Opens web)))
      (web.admitting web.level).activityClass x :=
  fun y _ => ⟨(y.1 + 1, y.2), ⟨⟨rfl, .inl rfl⟩, ⟨fun _ => supported _ _, fun _ => supported _ _⟩⟩⟩

/-- **Brevity cannot be dropped from the generation law**: with every formation supported
throughout, every line along "carry on, or open" never ends and keeps (全守), and none is
全生成. -/
theorem lasting_kept :
    (∀ K, ¬ ∀ t g, ¬ ∀ i, i ≤ K → web.Supported (t + i) g) ∧
      ∀ x, «全守» (Web.continuationStep (Web.passingContinuation (still.Opens web)))
          (web.admitting web.level).activityClass (web.admitting web.level).carrierClass x ∧
        ¬ «全生成» (Web.continuationStep (Web.passingContinuation (still.Opens web)))
          (web.admitting web.level).activityClass (web.admitting web.level).carrierClass x :=
  ⟨fun _ brief => brief 0 0 fun _ _ => supported _ _,
   fun x => ⟨⟨endless x, x, .inl rfl, fun z w _ c => no_carry z w c⟩,
     fun ⟨_, ahead⟩ => match ahead x (.inl rfl) with
       | ⟨z, w, _, c⟩ => no_carry z w c⟩⟩

end Saturated

/-! ### One range, two carriers: what the recency bound separates -/

namespace OpeningChain

open OwnCondition

/-- The rising course, as the web's own levels, keeps widening by name. -/
theorem keeps_widening : web.KeepsWidening Web.itself web.level 0 :=
  ⟨fun _ _ _ later => (Web.includesAcross_itself_iff later).mpr fun _ admitted =>
      supported_iff.mpr (Nat.le_trans (supported_iff.mp admitted) later),
   fun S _ => ⟨S + 1, Nat.le_succ S, (Web.exceedsAcross_itself_iff (Nat.le_succ S)).mpr
      ⟨S + 1, supported_iff.mpr (Nat.le_refl (S + 1)),
       fun admitted => Nat.not_succ_le_self S (supported_iff.mp admitted)⟩⟩⟩

theorem stock_le (cs : List Nat) (t : Nat) : web.stock cs t ≤ cs.length :=
  Nat.le_trans (total_le cs fun c _ => rung_le_one c t) (Nat.le_of_eq (total_ones cs))

/-- **A finite family cannot be dropped from the gain bridge**: the rising web keeps widening by
name with what each formation requires fixed, but on no single finite family, and no finite
family's stock passes its length. -/
theorem fixed_but_unbounded :
    web.KeepsWidening Web.itself web.level 0 ∧ relay.Balances web ∧
      (∀ s t f c, web.requires s f c → web.requires t f c ∧ web.need s f c = web.need t f c) ∧
      ∀ cs, ¬ ∀ K M, ∃ t, M ≤ t ∧ K < web.stock cs t :=
  ⟨keeps_widening, relay_balances, fun _ _ _ _ req => ⟨req, rfl⟩,
   fun cs passes => match passes cs.length 0 with
    | ⟨t, _, over⟩ => Nat.not_le_of_gt over (stock_le cs t)⟩

/-- **The relay is opened by the opened within one**, though its supports last. -/
theorem relay_within : Flow.OpenedByOpenedWithin relay web 1 :=
  ⟨fun N => ⟨N, N + 1, Nat.le_refl N, gains_iff.mpr rfl⟩,
   fun S f gains => fun none =>
    have same : f = S + 1 + 1 := gains_iff.mp gains
    none ⟨f, S + 1, S, rfl,
      Eq.subst (motive := fun x => web.Rises (S + 1) x) same.symm (rises_next (S + 1)), .head [],
      Eq.subst (motive := fun x => 0 < opening (S + 1) x) same.symm (opening_pos (S + 1)),
      supported_iff.mpr (Nat.le_refl (S + 1)), Nat.le_refl S, Nat.lt_succ_self S,
      gains_iff.mpr rfl⟩⟩

/-- Support on the rising web lasts: no bound makes it brief. -/
theorem lasting (K : Nat) : ¬ ∀ t g, ¬ ∀ i, i ≤ K → web.Supported (t + i) g :=
  fun brief => brief 0 0 fun _ _ => supported_iff.mpr (Nat.zero_le _)

/-- **The single giver is opened by the opened within no bound.** -/
theorem oneGiver_not_within (K : Nat) : ¬ Flow.OpenedByOpenedWithin oneGiver web K :=
  fun ⟨_, within⟩ => within 0 (0 + K + 1) (gains_iff.mpr rfl)
    fun ⟨_, _, u, _, _, mem, _, _, _, _, gained⟩ => match mem_cons_cases mem with
      | .inl same => gained.1 (supported_iff.mpr
          (Eq.subst (motive := fun x => x ≤ u) same.symm (Nat.zero_le u)))
      | .inr inner => nomatch inner

/-- **Brevity is sufficient, not necessary, and the bound separates the carriers**: the relay is
opened by the opened within one with lasting supports; the single giver, on the same web, within
no bound. -/
theorem carriers_within :
    Flow.OpenedByOpenedWithin relay web 1 ∧ (∀ K, ¬ ∀ t g, ¬ ∀ i, i ≤ K → web.Supported (t + i) g) ∧
      ∀ K, ¬ Flow.OpenedByOpenedWithin oneGiver web K :=
  ⟨relay_within, lasting, oneGiver_not_within⟩

/-- On the rising web requirements never loosen. -/
theorem unloosened : ∀ t f, web.Unloosened t f := fun _ _ _ req => ⟨req, Nat.le_refl 1⟩

/-- On the rising web gains of support recur. -/
theorem gains_recur (N : Nat) : ∃ t f, N ≤ t ∧ web.GainsSupport t f :=
  ⟨N, N + 1, Nat.le_refl N, gains_iff.mpr rfl⟩

/-- **Brevity cannot be dropped from the uniform law**: with the single giver every other premise of
`Flow.openedByOpenedWithin_of_brief` holds, supports last, and within no bound is the flow opened
by the opened, so the uniform law fails at some gain for every bound. -/
theorem brevity_needed :
    oneGiver.Balances web ∧ oneGiver.Acting web ∧ web.Dependent ∧ (∀ t f, web.Unloosened t f) ∧
      (∀ N, ∃ t f, N ≤ t ∧ web.GainsSupport t f) ∧
      (∀ K, ¬ ∀ t g, ¬ ∀ i, i ≤ K → web.Supported (t + i) g) ∧
      ∀ K, ¬ Flow.OpenedByOpenedWithin oneGiver web K :=
  ⟨oneGiver_balances, oneGiver_acting, dependent, unloosened, gains_recur, lasting,
   oneGiver_not_within⟩

/-- Formation `0` at step `0`, formation `t` at step `t + 1`. -/
def lagging : Nat → List Nat
  | 0 => [0]
  | t + 1 => [t]

/-- **The lagged relay**: at step `t + 1` formation `t` alone takes part, two steps after it gained
support, and gives the unit that steps the rising course. -/
def laggedRelay : Flow Nat Nat := ⟨lagging, fun _ _ _ => 0, fun t _ c => opening t c⟩

theorem laggedRelay_balances : laggedRelay.Balances web := fun t c => match t with
  | 0 => show rung c 1 + (0 + 0) = rung c 0 + (opening 0 c + 0) from balanced_step 0 c
  | t + 1 => show rung c (t + 1 + 1) + (0 + 0) = rung c (t + 1) + (opening (t + 1) c + 0) from
      balanced_step (t + 1) c

theorem laggedRelay_acting : laggedRelay.Acting web := fun t _ _ mem _ => match t, mem with
  | 0, mem => match mem_cons_cases mem with
    | .inl same => Nat.le_of_eq same
    | .inr inner => nomatch inner
  | t + 1, mem => match mem_cons_cases mem with
    | .inl same => Eq.subst (motive := fun x => x ≤ t + 1) same.symm (Nat.le_succ t)
    | .inr inner => nomatch inner

/-- **The lagged relay is opened by the opened within two**: each gain is given by the formation that
gained support two steps before. -/
theorem laggedRelay_within : Flow.OpenedByOpenedWithin laggedRelay web 2 :=
  ⟨gains_recur, fun S f gains => fun none =>
    have same : f = S + 2 + 1 := gains_iff.mp gains
    none ⟨f, S + 1, S, rfl,
      Eq.subst (motive := fun x => web.Rises (S + 2) x) same.symm (rises_next (S + 2)), .head [],
      Eq.subst (motive := fun x => 0 < opening (S + 2) x) same.symm (opening_pos (S + 2)),
      supported_iff.mpr (Nat.le_succ (S + 1)), Nat.le_refl S,
      Nat.lt_of_lt_of_le (Nat.lt_succ_self S) (Nat.le_succ (S + 1)), gains_iff.mpr rfl⟩⟩

/-- **At no origin is the lagged relay opened by the opened in the fixed-origin form**: the gain
across the step from `T + 1` is given by formation `T` alone, which gained support before `T`. -/
theorem laggedRelay_not_opened (T : Nat) : ¬ Flow.OpenedByOpened laggedRelay web T :=
  fun ⟨_, opened⟩ => match opened (T + 1) (T + 1 + 1) (Nat.lt_succ_self T) (gains_iff.mpr rfl) with
    | ⟨_, _, u, _, _, mem, _, _, from_, _, gained⟩ => match mem_cons_cases mem with
      | .inl same => Nat.not_succ_le_self u
          (Eq.subst (motive := fun x => x ≤ u) (same.symm.trans (gains_iff.mp gained)) from_)
      | .inr inner => nomatch inner

/-- **The recency bound admits what a fixed origin excludes.** On the rising web the lagged relay
balances, only active formations give, activity needs support and gains recur; it is opened by the
opened within two, and at no origin in the fixed-origin form. -/
theorem within_not_fixed_origin :
    laggedRelay.Balances web ∧ laggedRelay.Acting web ∧ web.Dependent ∧
      (∀ N, ∃ t f, N ≤ t ∧ web.GainsSupport t f) ∧ Flow.OpenedByOpenedWithin laggedRelay web 2 ∧
      ∀ T, ¬ Flow.OpenedByOpened laggedRelay web T :=
  ⟨laggedRelay_balances, laggedRelay_acting, dependent, gains_recur, laggedRelay_within,
   laggedRelay_not_opened⟩

end OpeningChain

/-! ### Loosening needs: what fixed requirements do in the gain bridge -/

namespace Loosening

/-- One once `n` is at most `t`, two before. -/
def strict : Nat → Nat → Nat
  | 0, _ => 1
  | _ + 1, 0 => 2
  | n + 1, t + 1 => strict n t

theorem strict_le_one_iff : ∀ {n t : Nat}, strict n t ≤ 1 ↔ n ≤ t
  | 0, _ => ⟨fun _ => Nat.zero_le _, fun _ => Nat.le_refl 1⟩
  | _ + 1, 0 => ⟨fun le => absurd le (Nat.not_succ_le_self 1),
      fun le => absurd le (Nat.not_succ_le_zero _)⟩
  | n + 1, t + 1 => ⟨fun le => Nat.succ_le_succ ((strict_le_one_iff (n := n) (t := t)).mp le),
      fun le => (strict_le_one_iff (n := n) (t := t)).mpr (Nat.le_of_succ_le_succ le)⟩

/-- One condition standing at one throughout; formation `n` requires it, at need one from step `n`
on and two before: what the formations need loosens. -/
def web : Web Nat Unit :=
  ⟨fun _ _ => 1, fun t n => n ≤ t, fun _ _ _ => True, fun t n _ => strict n t, fun _ _ _ => False⟩

theorem supported_iff {t n : Nat} : web.Supported t n ↔ n ≤ t :=
  ⟨fun supported => strict_le_one_iff.mp (supported () trivial),
   fun le _ _ => strict_le_one_iff.mpr le⟩

theorem keeps_widening : web.KeepsWidening Web.itself web.level 0 :=
  ⟨fun _ _ _ later => (Web.includesAcross_itself_iff later).mpr fun _ admitted =>
      supported_iff.mpr (Nat.le_trans (supported_iff.mp admitted) later),
   fun S _ => ⟨S + 1, Nat.le_succ S, (Web.exceedsAcross_itself_iff (Nat.le_succ S)).mpr
      ⟨S + 1, supported_iff.mpr (Nat.le_refl (S + 1)),
       fun admitted => Nat.not_succ_le_self S (supported_iff.mp admitted)⟩⟩⟩

/-- **Fixed needs cannot be dropped from the gain bridge**: the course keeps widening by name with
every requirement within `[()]`, but needs loosen, and the stock is one throughout. -/
theorem bounded_while_widening :
    web.KeepsWidening Web.itself web.level 0 ∧ (∀ t f c, web.requires t f c → c ∈ [()]) ∧
      web.need 0 1 () ≠ web.need 1 1 () ∧ ∀ t, web.stock [()] t = 1 :=
  ⟨keeps_widening, fun _ _ c _ => match c with | () => .head [],
   fun same => Nat.lt_irrefl 1 (Eq.subst (motive := fun x => 1 < x) same (Nat.lt_succ_self 1)),
   fun _ => rfl⟩

end Loosening

/-! ### A source from nothing: what the first law does in the gain bridge -/

namespace Source

/-- One condition standing at `t + 1` at step `t`; formation `n` requires it at need `n + 1`. -/
def web : Web Nat Unit :=
  ⟨fun t _ => t + 1, fun t n => n ≤ t, fun _ _ _ => True, fun _ n _ => n + 1, fun _ _ _ => False⟩

/-- Formation `0` gives one unit a step and takes nothing. -/
def flow : Flow Nat Unit := ⟨fun _ => [0], fun _ _ _ => 0, fun _ _ _ => 1⟩

theorem supported_iff {t n : Nat} : web.Supported t n ↔ n ≤ t :=
  ⟨fun supported => Nat.le_of_succ_le_succ (supported () trivial),
   fun le _ _ => Nat.succ_le_succ le⟩

theorem balances : flow.Balances web := fun _ _ => rfl

theorem keeps_widening : web.KeepsWidening Web.itself web.level 0 :=
  ⟨fun _ _ _ later => (Web.includesAcross_itself_iff later).mpr fun _ admitted =>
      supported_iff.mpr (Nat.le_trans (supported_iff.mp admitted) later),
   fun S _ => ⟨S + 1, Nat.le_succ S, (Web.exceedsAcross_itself_iff (Nat.le_succ S)).mpr
      ⟨S + 1, supported_iff.mpr (Nat.le_refl (S + 1)),
       fun admitted => Nat.not_succ_le_self S (supported_iff.mp admitted)⟩⟩⟩

theorem every : ∀ c : Unit, c ∈ [()]
  | () => .head []

theorem distinct : Distinct [()] := ⟨(fun no => nomatch no), trivial⟩

theorem requiresWithin : ∀ f, web.RequiresWithin [()] f :=
  fun _ _ _ c _ => ⟨trivial, rfl, every c⟩

theorem closed (t : Nat) : flow.ClosedAt [()] t := fun _ _ c out => absurd (every c) out

theorem not_gainless : ¬ flow.Gainless := fun gainless =>
  Nat.not_succ_le_zero 0 (gainless [()] 0 distinct (closed 0) 0 (.head []))

/-- **The first law cannot be dropped from the gain bridge**: a balanced finite world, its one
condition fed from nothing, keeps widening by name with fixed requirements, while its family is
closed and never given from beyond. -/
theorem from_nothing :
    flow.Balances web ∧ web.KeepsWidening Web.itself web.level 0 ∧
      (∀ f, web.RequiresWithin [()] f) ∧ (∀ c, c ∈ [()]) ∧ Distinct [()] ∧ ¬ flow.Gainless ∧
      ∀ t, ¬ ((flow.withImbalance web).NetGiver [()] t none ∨ ¬ flow.ClosedAt [()] t) :=
  ⟨balances, keeps_widening, requiresWithin, every, distinct, not_gainless,
   fun t given => match given with
    | .inl rest => Flow.BalancesOn.rest_not_netGiver (balances.on [()] t) rest
    | .inr open_ => open_ (closed t)⟩

end Source

end Becoming
