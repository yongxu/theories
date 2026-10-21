import Becoming.Change

/-!
# Population: counting the formations that take part

`Becoming.Arising` reads arising through the activity of formations across steps;
`Becoming.Flow` counts the formations that take from a family. This module reads how
many formations are active at each step, and ties the flow's count to the web's.

* A *census* lists the formations active at each step, each once (`Census`).
* If more formations are active after a step than before, some formation active after
  the step was not active before: it arises across the step (`arises_of_more`). A
  census that grows without bound makes generation unceasing (`unceasing_of_growth`).
* The census law: where the members of which a determination holds are listed at each
  step, each once (`Listed`), the list after a step with the members that ceased to be
  is the list before it with the members that came to be (`Listed.across`), and so over
  any stretch (`Listed.over_stretch`): ceasings are at most comings and the list at the
  start, comings at most ceasings and the list at the end (`Listed.ceasings_within`,
  `Listed.comings_within`). Read of recurrence, the balance is exact: ceasing to be
  recurs exactly when, from each step, the list at some later step is shorter than the
  list at the start with what came to be between, and coming to be recurs exactly when
  the list at the start is longer than some later list with what ceased to be between
  (`Listed.ceasing_iff_shortfall`, `Listed.coming_iff_excess`). Ceasings that recur
  accumulate past any list at the start, so ceasing to be at arbitrarily late steps needs
  coming to be at arbitrarily late steps (`Listed.coming_of_ceasing`). Not conversely:
  ever new formations can arise while none ceases (`Accretion`). Where at most `K` are listed
  at arbitrarily late steps, comings that recur accumulate past `K`, and the converse
  holds too (`Listed.ceasing_of_returning`); so where from some step on at most `B` are
  listed, the two recur together (`Listed.ceasing_of_coming`,
  `Listed.coming_iff_ceasing`). This needs only a list returning within a bound, not the
  finite family of `Becoming.Change` (`coming_recurs_iff`). Where the list grows without
  end, ceasing to be still recurs where, from each step, the comings over some stretch
  outnumber a bound on the list at its end (`Listed.ceasing_of_outpacing`). The recurrence
  laws need only an inequality across each step: a count that ends with what it loses at
  most where it started with what it gains does so over any stretch, so losses recurring
  need gains recurring (`le_over_stretch`, `gaining_of_losing`); with the inequality the
  other way and the count bounded from some step on, gains recurring need losses
  recurring (`ge_over_stretch`, `losing_of_gaining`). `Becoming.Identity` reads them
  under a continuation. A census is
  the listing of activity: the formations active at the end with those that ceased are
  those active at the start with those that arose (`Web.Census.over_stretch`), ceasing
  recurring needs arising recurring (`Listed.coming_of_ceasing`), and under a census
  bounded from some step on arising recurs exactly when ceasing recurs
  (`Web.unceasing_iff_bounded`). Read of dependence, forming and dissolving obey the
  same balance and laws (`Web.DependenceCensus.over_stretch`,
  `Web.DependenceCensus.forming_of_dissolving`,
  `Web.DependenceCensus.forming_iff_dissolving`); `Becoming.Openness` reads them of
  standing.
* The tally is the whole law of counting. Across each step some members are kept: with
  those ceasing to be they are the list before the step, with those coming to be the list
  after it (`Listed.keeps`, from which `Listed.across` follows). Counts of this form are a
  *tally* (`Tally`, `Listed.tally`): the balance of `Listed.across` with no more ceasing
  across a step than were counted before it (`tally_iff`), which the balance alone does not
  give (`balance_not_tally`). Every tally is counted by a queue, its members joining at the
  back and leaving from the front, each in turn (`Queue.counts`), so the counts some
  listing has are exactly the tallies (`tally_iff_counted`), and a property of the counts
  holds wherever what holds is listed exactly when it holds of every tally
  (`counting_laws`): no law of counting holds beyond the tally. There the property is
  asked only to respect the counts' values at each step (`Pointwise`), as function
  extensionality would give and the pure core does not assume.
* Change bounds. A number `B` bounds change from a step where, from it on, the number
  counted with the steps since at which something ceased or arose stays within `B`
  (`ChangeBound`). Then change does not recur (`ChangeBound.not_recurring`). A bound from
  some step is a bound from the first step (`ChangeBound.from_zero`,
  `changeBound_iff_zero`), and a queue counting a tally whose change `B` bounds from the
  first step never reaches past its `B + B * B`-th member (`ChangeBound.reach`). That change
  does not recur cannot be strengthened to a step after which nothing changes without
  omniscience: one member replaced at the first `true` of a Boolean sequence has its change
  bounded by two (`ChangeBound.lpo_of_ends`, `Swap`). `Becoming.Openness` reads the bound
  that enclosure sets.
  `Becoming.Premises` reads this of worlds and their premises.
* Under a census, with each formation taking part in the flow listed once and only
  active formations taking (`Flow.Taking`, of which only the activity half is used),
  the active formations grow without bound (`Flow.More.grows`), and more without end
  makes generation unceasing (`Flow.More.unceasing`). The premises hold together in the
  expansion and the cycle (`Expansion.counted`, `Cycle.counted`). Not conversely: the oscillator
  meets every one of these premises, arises again and again, and is not more
  (`Oscillation.counted`). Under this correspondence, more without end is strictly stronger
  than unceasing generation.
* Each premise does work. Without a census, every formation of an infinite family can be
  active from the start, and more without end comes with nothing arising (`Dormant`).
  Without `Taking`, the flow's takers need not be active: one formation gives to ever
  more formations that take while never active, and nothing arises (`Inactive`). With a
  formation listed many times in a flow's `present`, one formation counts as many: more
  without end comes with one formation, always active, and nothing arising
  (`Repeated`).
* The converse of `Taking`, that every formation drawing on the family takes from it in
  the flow, is an application duty: ever more formations can be active, depend on a
  condition and draw on it while the flow records no taking (`Unrecorded`).

Activity at each step is supposed decidable where a theorem needs it; this is a
hypothesis of the theorem, not an axiom. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {α β : Type}

/-! ## Lists without repetition -/

theorem mem_map_of {g : α → β} {a : α} : ∀ {l : List α}, a ∈ l → g a ∈ l.map g
  | _ :: _, .head _ => .head _
  | _ :: _, .tail _ mem => .tail _ (mem_map_of mem)

theorem mem_of_map {g : α → β} (inj : ∀ a b, g a = g b → a = b) {a : α} :
    ∀ {l : List α}, g a ∈ l.map g → a ∈ l
  | [], mem => nomatch mem
  | b :: _, mem => match mem_cons_cases mem with
    | .inl same => Eq.subst (motive := fun x => x ∈ b :: _) (inj a b same).symm (.head _)
    | .inr mem => .tail b (mem_of_map inj mem)

/-- Mapping a list one to one keeps it without repetition. -/
theorem distinct_map {g : α → β} (inj : ∀ a b, g a = g b → a = b) :
    ∀ {l : List α}, Distinct l → Distinct (l.map g)
  | [], _ => trivial
  | _ :: _, ⟨fresh, distinct⟩ => ⟨fun mem => fresh (mem_of_map inj mem), distinct_map inj distinct⟩

/-- Removing one occurrence of `a` keeps every other member. -/
theorem mem_remove {a b : α} (other : ¬ b = a) : ∀ {p q : List α}, b ∈ p ++ a :: q → b ∈ p ++ q
  | [], _, mem => match mem_cons_cases mem with
    | .inl same => absurd same other
    | .inr mem => mem
  | c :: _, _, mem => match mem_cons_cases mem with
    | .inl same => Eq.subst (motive := fun x => x ∈ c :: _) same.symm (.head _)
    | .inr mem => .tail _ (mem_remove other mem)

/-- A list without repetition, each member of which is matched to a member of another
list, no member of which is matched to two: the first list is no longer. -/
theorem length_le_of_matched {S : α → β → Prop} : ∀ {l : List α} {m : List β}, Distinct l →
    (∀ a, a ∈ l → ∃ b, b ∈ m ∧ S a b) →
    (∀ a a' b, a ∈ l → a' ∈ l → S a b → S a' b → a = a') → l.length ≤ m.length
  | [], _, _, _, _ => Nat.zero_le _
  | a :: l, m, ⟨fresh, distinct⟩, matched, once => match matched a (.head l) with
    | ⟨b, mem, paired⟩ => match List.append_of_mem mem with
      | ⟨p, q, split⟩ =>
        have inner : l.length ≤ (p ++ q).length :=
          length_le_of_matched distinct
            (fun a' mem' => match matched a' (.tail a mem') with
              | ⟨b', mem_b', paired'⟩ =>
                have other : ¬ b' = b := fun same =>
                  fresh (Eq.subst (motive := fun x => x ∈ l)
                    (once a' a b' (.tail a mem') (.head l) paired'
                      (Eq.subst (motive := fun x => S a x) same.symm paired)) mem')
                ⟨b', mem_remove other (split ▸ mem_b'), paired'⟩)
            (fun x y b' mx my => once x y b' (.tail a mx) (.tail a my))
        have whole : m.length = (p ++ q).length + 1 :=
          (congrArg List.length split).trans ((ListTests.length_append p (b :: q)).trans
            ((Nat.add_succ _ _).trans (congrArg Nat.succ (ListTests.length_append p q).symm)))
        whole ▸ Nat.succ_le_succ inner

/-- A list without repetition whose members all belong to another list is no longer. -/
theorem length_le_of_sub {l m : List α} (distinct : Distinct l) (sub : ∀ a, a ∈ l → a ∈ m) :
    l.length ≤ m.length :=
  length_le_of_matched (S := Eq) distinct (fun a mem => ⟨a, sub a mem, rfl⟩)
    fun _ _ _ _ _ same same' => same.trans same'.symm

/-- Counting the members a quantity is positive at, in a list without repetition: no more
than a list holding every such member. -/
theorem count_le_of_sub {q : α → Nat} : ∀ {l m : List α}, Distinct l →
    (∀ a, a ∈ l → 0 < q a → a ∈ m) → count l q ≤ m.length
  | [], _, _, _ => Nat.zero_le _
  | a :: l, m, ⟨fresh, distinct⟩, sub => match h : q a with
    | 0 =>
      have rest : count l q ≤ m.length :=
        count_le_of_sub distinct fun b mem => sub b (.tail a mem)
      show sign (q a) + count l q ≤ m.length from
        (congrArg (· + count l q) (congrArg sign h)).symm ▸ (Nat.zero_add _).symm ▸ rest
    | n + 1 => match List.append_of_mem (sub a (.head l) (h.symm ▸ Nat.zero_lt_succ n)) with
      | ⟨p, r, split⟩ =>
        have inner : count l q ≤ (p ++ r).length :=
          count_le_of_sub distinct fun b mem positive =>
            mem_remove (fun same => fresh (Eq.subst (motive := fun x => x ∈ l) same mem))
              (split ▸ sub b (.tail a mem) positive)
        have whole : m.length = (p ++ r).length + 1 :=
          (congrArg List.length split).trans ((ListTests.length_append p (a :: r)).trans
            ((Nat.add_succ _ _).trans (congrArg Nat.succ (ListTests.length_append p r).symm)))
        show sign (q a) + count l q ≤ m.length from
          (congrArg (· + count l q) (congrArg sign h)).symm ▸ whole ▸
            (Nat.add_comm (count l q) 1 ▸ Nat.succ_le_succ inner)

/-- Constructively, either some member of a list lacks a decidable property, or every
member has it. -/
theorem search {p : α → Prop} [decide : ∀ a, Decidable (p a)] :
    ∀ l : List α, (∃ a, a ∈ l ∧ ¬ p a) ∨ ∀ a, a ∈ l → p a
  | [] => .inr fun _ mem => nomatch mem
  | a :: l => match decide a with
    | isFalse lacks => .inl ⟨a, .head l, lacks⟩
    | isTrue has => match search l with
      | .inl ⟨b, mem, lacks⟩ => .inl ⟨b, .tail a mem, lacks⟩
      | .inr all => .inr fun b mem => match mem with
        | .head _ => has
        | .tail _ mem => all b mem

/-- Whether some member of a list has a decidable property is decidable. -/
def decideSome {p : α → Prop} [decide : ∀ a, Decidable (p a)] :
    ∀ l : List α, Decidable (∃ a, a ∈ l ∧ p a)
  | [] => isFalse fun ⟨_, mem, _⟩ => nomatch mem
  | a :: l => match decide a with
    | isTrue holds => isTrue ⟨a, .head l, holds⟩
    | isFalse lacks => match decideSome l with
      | isTrue found => isTrue (match found with | ⟨b, mem, holds⟩ => ⟨b, .tail a mem, holds⟩)
      | isFalse absent => isFalse fun ⟨b, mem, holds⟩ => match mem_cons_cases mem with
        | .inl same => lacks (Eq.subst (motive := p) same holds)
        | .inr mem => absent ⟨b, mem, holds⟩

/-- A quantity that ends higher than it starts rises across some step between. -/
theorem rises_between {q : Nat → Nat} {N : Nat} :
    ∀ {T}, N ≤ T → q N < q T → ∃ t, N ≤ t ∧ t < T ∧ q t < q (t + 1)
  | _, .refl, higher => absurd higher (Nat.lt_irrefl _)
  | m + 1, .step within, higher => match Nat.decLt (q m) (q (m + 1)) with
    | isTrue up => ⟨m, within, Nat.lt_succ_self m, up⟩
    | isFalse flat => match rises_between within
        (Nat.lt_of_lt_of_le higher (Nat.ge_of_not_lt flat)) with
      | ⟨t, from_, below, up⟩ => ⟨t, from_, Nat.lt_succ_of_lt below, up⟩

/-! ## Counting marks -/

theorem mark_one {p : Prop} [Decidable p] (holds : p) : mark p = 1 :=
  Nat.le_antisymm (mark_le_one p) (mark_pos.mpr holds)

theorem mark_zero {p : Prop} [Decidable p] (fails : ¬ p) : mark p = 0 :=
  eq_zero_of_not_pos fun pos => fails (mark_pos.mp pos)

/-- Doubly negated for each member of a list, doubly negated for all of them. -/
theorem not_not_all {β : Type} {P : β → Prop} :
    ∀ {E : List β}, (∀ b, b ∈ E → ¬ ¬ P b) → ¬ ¬ ∀ b, b ∈ E → P b
  | [], _ => fun none => none fun _ mem => nomatch mem
  | b :: E, each => fun none =>
    each b (.head E) fun head =>
      not_not_all (E := E) (fun c mem => each c (.tail b mem)) fun rest =>
        none fun c mem => match mem_cons_cases mem with
          | .inl same => Eq.subst (motive := P) same.symm head
          | .inr mem => rest c mem

/-- What fails at `N` and holds at a later step `T` came to be across some step between,
where it is decided at the steps from `S` on, `S` no later than `N`: only those steps are
consulted. -/
theorem came_between_from {q : Nat → Prop} {S N : Nat} (decided : ∀ s, S ≤ s → Decidable (q s))
    (from_ : S ≤ N) (fails : ¬ q N) : ∀ {T}, N ≤ T → q T → ∃ s, N ≤ s ∧ s < T ∧ ComesToBe q s
  | _, .refl, holds => absurd holds fails
  | m + 1, .step within, holds => match decided m (Nat.le_trans from_ within) with
    | isTrue held => match came_between_from decided from_ fails within held with
      | ⟨s, after, below, comes⟩ => ⟨s, after, Nat.lt_succ_of_lt below, comes⟩
    | isFalse idle => ⟨m, within, Nat.lt_succ_self m, idle, holds⟩

/-- What fails at `N` and holds at a later step `T` came to be across some step between. -/
theorem came_between {q : Nat → Prop} [∀ t, Decidable (q t)] {N T : Nat} (le : N ≤ T)
    (fails : ¬ q N) (holds : q T) : ∃ s, N ≤ s ∧ s < T ∧ ComesToBe q s :=
  came_between_from (S := 0) (fun _ _ => inferInstance) (Nat.zero_le N) fails le holds

/-- Of two decidable propositions, exactly one holding: their marks add to one. -/
theorem mark_add_not {q r : Prop} [Decidable q] [Decidable r] (one : q ∨ r)
    (not_both : ¬ (q ∧ r)) : mark q + mark r = 1 :=
  match one with
  | .inl hq => (congrArg (· + mark r) (mark_one hq)).trans
      (congrArg (1 + ·) (mark_zero fun hr => not_both ⟨hq, hr⟩))
  | .inr hr => (congrArg (mark q + ·) (mark_one hr)).trans
      (congrArg (· + 1) (mark_zero fun hq => not_both ⟨hq, hr⟩))

/-- One member across a step, counted one where it holds: what holds after the step with
its ceasing is what held before with its coming. -/
theorem mark_turn (p q : Prop) [Decidable p] [Decidable q] :
    mark q + mark (p ∧ ¬ q) = mark p + mark (¬ p ∧ q) :=
  if hp : p then
    (mark_add_not (if hq : q then .inl hq else .inr ⟨hp, hq⟩) fun both => both.2.2 both.1).trans
      ((congrArg (· + mark (¬ p ∧ q)) (mark_one hp)).trans
        (congrArg (1 + ·) (mark_zero fun both => both.1 hp))).symm
  else
    (congrArg (mark q + ·) (mark_zero fun both => hp both.1)).trans
      ((mark_iff ⟨fun hq => ⟨hp, hq⟩, fun both => both.2⟩).trans
        ((Nat.zero_add _).symm.trans (congrArg (· + mark (¬ p ∧ q)) (mark_zero hp).symm)))

/-- Quantities that agree on the members of a list have the same total over it. -/
theorem total_congr_on {f g : α → Nat} :
    ∀ {as : List α}, (∀ a, a ∈ as → f a = g a) → total as f = total as g
  | [], _ => rfl
  | a :: _, same => (congrArg (· + _) (same a (.head _))).trans
      (congrArg (g a + ·) (total_congr_on fun b mem => same b (.tail a mem)))

/-- Inserting one member keeps every other. -/
theorem mem_insert {a b : α} : ∀ {p q : List α}, b ∈ p ++ q → b ∈ p ++ a :: q
  | [], _, mem => .tail a mem
  | c :: _, _, mem => match mem_cons_cases mem with
    | .inl same => Eq.subst (motive := fun x => x ∈ c :: _) same.symm (.head _)
    | .inr mem => .tail c (mem_insert mem)

/-- Removing one occurrence keeps a list without repetition. -/
theorem distinct_remove {a : α} : ∀ {p q : List α}, Distinct (p ++ a :: q) → Distinct (p ++ q)
  | [], _, ⟨_, distinct⟩ => distinct
  | _ :: _, _, ⟨fresh, distinct⟩ => ⟨fun mem => fresh (mem_insert mem), distinct_remove distinct⟩

/-- Over a list without repetition, the members at which a decidable property holds are no
more than the members of a second list without repetition at which another holds, where
each of the first is one of the second. -/
theorem marks_le_of_sub {q r : α → Prop} [∀ a, Decidable (q a)] [∀ a, Decidable (r a)] :
    ∀ {l m : List α}, Distinct l → Distinct m → (∀ a, a ∈ l → q a → a ∈ m ∧ r a) →
    total l (fun a => mark (q a)) ≤ total m (fun a => mark (r a))
  | [], _, _, _, _ => Nat.zero_le _
  | a :: l, m, ⟨fresh, distinct⟩, apart, sub =>
    if holds : q a then
      match sub a (.head l) holds with
      | ⟨mem, has⟩ => match List.append_of_mem mem with
        | ⟨p, s, split⟩ =>
          have inner : total l (fun b => mark (q b)) ≤ total (p ++ s) (fun b => mark (r b)) :=
            marks_le_of_sub distinct (distinct_remove (split ▸ apart)) fun b mem_b q_b =>
              match sub b (.tail a mem_b) q_b with
              | ⟨in_m, r_b⟩ => ⟨mem_remove (fun (same : b = a) =>
                  fresh (Eq.subst (motive := fun x => x ∈ l) same mem_b)) (split ▸ in_m), r_b⟩
          have whole : total m (fun b => mark (r b)) = total (p ++ s) (fun b => mark (r b)) + 1 :=
            calc total m (fun b => mark (r b))
                = total p (fun b => mark (r b)) + (mark (r a) + total s fun b => mark (r b)) :=
                  (congrArg (total · fun b => mark (r b)) split).trans (total_append _ (a :: s) p)
              _ = total p (fun b => mark (r b)) + (total s (fun b => mark (r b)) + 1) :=
                  congrArg (total p (fun b => mark (r b)) + ·)
                    ((congrArg (· + _) (mark_one has)).trans (Nat.add_comm 1 _))
              _ = total (p ++ s) (fun b => mark (r b)) + 1 :=
                  (Nat.add_assoc _ _ _).symm.trans (congrArg (· + 1) (total_append _ s p).symm)
          Nat.le_trans (Nat.le_of_eq ((congrArg (· + _) (mark_one holds)).trans (Nat.add_comm 1 _)))
            (Nat.le_trans (Nat.succ_le_succ inner) (Nat.le_of_eq whole.symm))
    else
      Nat.le_trans (Nat.le_of_eq ((congrArg (· + _) (mark_zero holds)).trans (Nat.zero_add _)))
        (marks_le_of_sub distinct apart fun b mem_b q_b => sub b (.tail a mem_b) q_b)

/-- A decidable proposition that some member of a list has a decidable property: its mark
is at most the number of members having the property. -/
theorem mark_le_total {P : Prop} [Decidable P] {q : α → Prop} [∀ a, Decidable (q a)]
    {l : List α} (found : P → ∃ a, a ∈ l ∧ q a) : mark P ≤ total l (fun a => mark (q a)) :=
  mark_cases (q := (· ≤ total l fun a => mark (q a)))
    (fun holds => match found holds with
      | ⟨_, mem, has⟩ => total_pos_of_mem mem (mark_pos.mpr has))
    fun _ => Nat.zero_le _

/-- Over a list without repetition at most one member of which has a decidable property,
the number of members having it is at most the mark of any proposition each such member
makes hold. -/
theorem total_le_mark {P : Prop} [Decidable P] {q : α → Prop} [∀ a, Decidable (q a)] :
    ∀ {l : List α}, Distinct l → (∀ a b, a ∈ l → b ∈ l → q a → q b → a = b) →
      (∀ a, a ∈ l → q a → P) → total l (fun a => mark (q a)) ≤ mark P
  | [], _, _, _ => Nat.zero_le _
  | a :: l, ⟨fresh, distinct⟩, once, makes =>
    if has : q a then
      have none : total l (fun b => mark (q b)) ≤ total [] (fun b => mark (q b)) :=
        marks_le_of_sub distinct trivial fun b mem has' => absurd
          (Eq.subst (motive := fun x => x ∈ l) (once b a (.tail a mem) (.head l) has' has) mem)
          fresh
      Nat.le_trans (Nat.add_le_add (Nat.le_of_eq (mark_one has)) none)
        (Nat.le_of_eq (mark_one (makes a (.head l) has)).symm)
    else
      Nat.le_trans (Nat.le_of_eq ((congrArg (· + _) (mark_zero has)).trans (Nat.zero_add _)))
        (total_le_mark distinct (fun b b' mem mem' => once b b' (.tail a mem) (.tail a mem'))
          fun b mem => makes b (.tail a mem))

/-- Where a count, at each step, ends with what it loses at most where it started with what
it gains, losses at arbitrarily late steps need gains at arbitrarily late steps: losses
recurring accumulate past the count at the start, and only gains make up the
difference. -/
theorem gaining_of_losing {q x y : Nat → Nat} (across : ∀ t, q (t + 1) + x t ≤ q t + y t)
    (losing : ∀ N, ∃ t, N ≤ t ∧ 0 < x t) : ∀ N, ∃ t, N ≤ t ∧ 0 < y t :=
  fun N => match recurring_accumulates losing N (q N + 1) with
  | ⟨n, many⟩ => match total_pos (steps N n) (pos_of_exceeds many
      (Nat.le_trans (Nat.le_add_left _ _) (le_over_stretch across N n))) with
    | ⟨t, mem, gained⟩ => ⟨t, steps_mem mem, gained⟩

/-- Where a count, at each step, starts with what it gains at most where it ends with what
it loses, and from some step on is at most `B`, gains at arbitrarily late steps need losses
at arbitrarily late steps. -/
theorem losing_of_gaining {q x y : Nat → Nat} (across : ∀ t, q t + y t ≤ q (t + 1) + x t)
    {T B : Nat} (bounded : ∀ t, T ≤ t → q t ≤ B) (gaining : ∀ N, ∃ t, N ≤ t ∧ 0 < y t) :
    ∀ N, ∃ t, N ≤ t ∧ 0 < x t :=
  fun N => match recurring_accumulates gaining (N + T) (B + 1) with
  | ⟨n, many⟩ => match total_pos (steps (N + T) n) (pos_of_exceeds many
      (Nat.le_trans (Nat.le_trans (Nat.le_add_left _ _) (ge_over_stretch across (N + T) n))
        (Nat.add_le_add_right (bounded _ (Nat.le_trans (Nat.le_add_left T N)
          (Nat.le_add_right _ n))) _))) with
    | ⟨t, mem, lost⟩ => ⟨t, Nat.le_trans (Nat.le_add_right N T) (steps_mem mem), lost⟩

/-- A recurrence read from a step `T` on: what recurs recurs at `T + m` for arbitrarily large
`m`. -/
theorem recurs_shift {r : Nat → Prop} (T : Nat) (recurs : ∀ N, ∃ t, N ≤ t ∧ r t) :
    ∀ N, ∃ m, N ≤ m ∧ r (T + m) :=
  fun N => match recurs (N + T) with
  | ⟨_, later, holds⟩ => match le_dest (Nat.le_trans (Nat.le_add_left T N) later) with
    | ⟨m, same⟩ => ⟨m, le_of_add_le_add_right T
        (Nat.le_trans later (Nat.le_of_eq (same.trans (Nat.add_comm T m)))), same ▸ holds⟩

/-- And back: what holds at `T + m` for arbitrarily large `m` recurs. -/
theorem recurs_unshift {r : Nat → Prop} (T : Nat) (recurs : ∀ N, ∃ m, N ≤ m ∧ r (T + m)) :
    ∀ N, ∃ t, N ≤ t ∧ r t :=
  fun N => match recurs N with
  | ⟨m, later, holds⟩ => ⟨T + m, Nat.le_trans later (Nat.le_add_left m T), holds⟩

/-- Losses at arbitrarily late steps need gains at arbitrarily late steps, where the count at
each step from `T` on ends with what it loses at most where it starts with what it gains:
nothing is asked of the steps before `T`. -/
theorem gaining_of_losing_from {q x y : Nat → Nat} {T : Nat}
    (across : ∀ t, T ≤ t → q (t + 1) + x t ≤ q t + y t)
    (losing : ∀ N, ∃ t, N ≤ t ∧ 0 < x t) : ∀ N, ∃ t, N ≤ t ∧ 0 < y t :=
  recurs_unshift T (gaining_of_losing (q := fun m => q (T + m)) (x := fun m => x (T + m))
    (y := fun m => y (T + m)) (fun m => across (T + m) (Nat.le_add_right T m))
    (recurs_shift T losing))

/-- Gains at arbitrarily late steps need losses at arbitrarily late steps, where from `T` on
the count is at most `B` and at each step starts with what it gains at most where it ends
with what it loses. -/
theorem losing_of_gaining_from {q x y : Nat → Nat} {T B : Nat}
    (across : ∀ t, T ≤ t → q t + y t ≤ q (t + 1) + x t) (bounded : ∀ t, T ≤ t → q t ≤ B)
    (gaining : ∀ N, ∃ t, N ≤ t ∧ 0 < y t) : ∀ N, ∃ t, N ≤ t ∧ 0 < x t :=
  recurs_unshift T (losing_of_gaining (q := fun m => q (T + m)) (x := fun m => x (T + m))
    (y := fun m => y (T + m)) (T := 0) (B := B) (fun m => across (T + m) (Nat.le_add_right T m))
    (fun m _ => bounded (T + m) (Nat.le_add_right T m)) (recurs_shift T gaining))

/-! ## Listing what holds -/

/-- The members of which a determination holds at each step are listed, each once:
finitely many hold at each step, of possibly infinitely many in all. -/
def Listed (p : α → Nat → Prop) (l : Nat → List α) : Prop :=
  ∀ t, Distinct (l t) ∧ ∀ a, p a t ↔ a ∈ l t

namespace Listed

variable {p : α → Nat → Prop} [∀ a t, Decidable (p a t)] {l : Nat → List α}

/-- Across a step, some members are kept, where what holds is listed, each once, at the
step's two ends: only those two listings are used. -/
theorem keeps_at {t : Nat} (now : Distinct (l t) ∧ ∀ a, p a t ↔ a ∈ l t)
    (next : Distinct (l (t + 1)) ∧ ∀ a, p a (t + 1) ↔ a ∈ l (t + 1)) :
    ∃ k, (l t).length = k + ceasings (l t) p t ∧
      (l (t + 1)).length = k + comings (l (t + 1)) p t :=
  have before : (l t).length = total (l t) (fun a => mark (p a (t + 1))) + ceasings (l t) p t :=
    (total_ones (l t)).symm.trans ((total_congr_on fun a mem =>
      have held : p a t := (now.2 a).mpr mem
      Eq.symm (mark_add_not (q := p a (t + 1)) (r := CeasesToBe (p a) t)
        (if h : p a (t + 1) then .inl h else .inr ⟨held, h⟩)
        fun both => both.2.2 both.1)).trans (total_add _ _ (l t)))
  have after : (l (t + 1)).length =
      total (l (t + 1)) (fun a => mark (p a t)) + comings (l (t + 1)) p t :=
    (total_ones (l (t + 1))).symm.trans ((total_congr_on fun a mem =>
      have held : p a (t + 1) := (next.2 a).mpr mem
      Eq.symm (mark_add_not (q := p a t) (r := ComesToBe (p a) t)
        (if h : p a t then .inl h else .inr ⟨h, held⟩)
        fun both => both.2.1 both.1)).trans (total_add _ _ (l (t + 1))))
  have kept : total (l t) (fun a => mark (p a (t + 1))) =
      total (l (t + 1)) (fun a => mark (p a t)) :=
    Nat.le_antisymm
      (marks_le_of_sub (q := fun a => p a (t + 1)) (r := fun a => p a t) now.1
        next.1 fun a mem h => ⟨(next.2 a).mp h, (now.2 a).mpr mem⟩)
      (marks_le_of_sub (q := fun a => p a t) (r := fun a => p a (t + 1)) next.1
        now.1 fun a mem h => ⟨(now.2 a).mp h, (next.2 a).mpr mem⟩)
  ⟨_, before, after.trans (congrArg (· + _) kept.symm)⟩

/-- Across a step, some members are kept: with the members that ceased to be they are the
list before the step, with the members that came to be the list after it. -/
theorem keeps (listed : Listed p l) (t : Nat) :
    ∃ k, (l t).length = k + ceasings (l t) p t ∧
      (l (t + 1)).length = k + comings (l (t + 1)) p t :=
  keeps_at (listed t) (listed (t + 1))

/-- The census balance across a step, where what holds is listed at its two ends: the list
after it with the members that ceased to be is the list before it with the members that came
to be. The members kept across the step are counted alike on both lists. -/
theorem across_at {t : Nat} (now : Distinct (l t) ∧ ∀ a, p a t ↔ a ∈ l t)
    (next : Distinct (l (t + 1)) ∧ ∀ a, p a (t + 1) ↔ a ∈ l (t + 1)) :
    (l (t + 1)).length + ceasings (l t) p t = (l t).length + comings (l (t + 1)) p t :=
  match keeps_at now next with
  | ⟨_, before, after⟩ => (congrArg (· + _) after).trans
      ((Nat.add_right_comm _ _ _).trans (congrArg (· + _) before.symm))

/-- The census balance across a step: the list after it with the members that ceased to be
is the list before it with the members that came to be. -/
theorem across (listed : Listed p l) (t : Nat) :
    (l (t + 1)).length + ceasings (l t) p t = (l t).length + comings (l (t + 1)) p t :=
  across_at (listed t) (listed (t + 1))

/-- Over a stretch at each step of which what holds is listed, each once, the list at the end
with the members that ceased to be is the list at the start with the members that came to
be. Nothing is asked of the steps outside the stretch. -/
theorem over_stretch_on {S n : Nat}
    (listing : ∀ s, S ≤ s → s ≤ S + n → Distinct (l s) ∧ ∀ a, p a s ↔ a ∈ l s) :
    (l (S + n)).length + total (steps S n) (fun t => ceasings (l t) p t) =
      (l S).length + total (steps S n) (fun t => comings (l (t + 1)) p t) :=
  balance_over_stretch_on (q := fun t => (l t).length) (x := fun t => ceasings (l t) p t)
    (y := fun t => comings (l (t + 1)) p t) S n fun t from_ below =>
      across_at (listing t from_ (Nat.le_of_lt below)) (listing (t + 1) (Nat.le_succ_of_le from_) below)

/-- Over any stretch, the list at the end with the members that ceased to be is the list at
the start with the members that came to be. -/
theorem over_stretch (listed : Listed p l) (S n : Nat) :
    (l (S + n)).length + total (steps S n) (fun t => ceasings (l t) p t) =
      (l S).length + total (steps S n) (fun t => comings (l (t + 1)) p t) :=
  over_stretch_on fun s _ _ => listed s

/-- So over any stretch, the members ceasing to be are at most those coming to be and those
listed at the start: the census law counted. -/
theorem ceasings_within (listed : Listed p l) (S n : Nat) :
    total (steps S n) (fun t => ceasings (l t) p t) ≤
      (l S).length + total (steps S n) (fun t => comings (l (t + 1)) p t) :=
  Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq (listed.over_stretch S n))

/-- And the members coming to be are at most those ceasing to be and those listed at the
end: where at most `B` are listed, at most `B` more come to be than cease to be. -/
theorem comings_within (listed : Listed p l) (S n : Nat) :
    total (steps S n) (fun t => comings (l (t + 1)) p t) ≤
      (l (S + n)).length + total (steps S n) (fun t => ceasings (l t) p t) :=
  Nat.le_trans (Nat.le_add_left _ (l S).length) (Nat.le_of_eq (listed.over_stretch S n).symm)

/-- Read of recurrence, the balance is exact where what holds is listed from `T` on: ceasing to
be recurs exactly when, from each step from `T` on, the list at some later step is shorter
than the list at the start with the members that came to be between. -/
theorem ceasing_iff_shortfall_from {T : Nat} (listing : ∀ s, T ≤ s → Distinct (l s) ∧ ∀ a, p a s ↔ a ∈ l s) :
    (∀ N, ∃ t a, N ≤ t ∧ CeasesToBe (p a) t) ↔
      ∀ N, T ≤ N → ∃ n, (l (N + n)).length <
        (l N).length + total (steps N n) fun t => comings (l (t + 1)) p t :=
  ⟨fun ceasing N from_ => match ceasing N with
    | ⟨t, a, later, ceases⟩ => match le_dest later with
      | ⟨m, same⟩ =>
        have ceased : 0 < total (steps N (m + 1)) fun t => ceasings (l t) p t :=
          Nat.lt_of_lt_of_le
            (same ▸ total_pos_of_mem (((listing t (Nat.le_trans from_ later)).2 a).mp ceases.1)
              (mark_pos.mpr ceases))
            (Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq (steps_last _ N m).symm))
        ⟨m + 1, Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right ceased)
          (Nat.le_of_eq (over_stretch_on fun s lo _ => listing s (Nat.le_trans from_ lo)))⟩,
   fun shortfall N => match shortfall (N + T) (Nat.le_add_left T N) with
    | ⟨n, short⟩ =>
      match total_pos (steps (N + T) n) (pos_of_exceeds short (Nat.le_of_eq
          (over_stretch_on fun s lo _ => listing s (Nat.le_trans (Nat.le_add_left T N) lo)).symm)) with
      | ⟨t, mem, ceased⟩ => match total_pos (l t) ceased with
        | ⟨a, _, ceases⟩ =>
          ⟨t, a, Nat.le_trans (Nat.le_add_right N T) (steps_mem mem), mark_pos.mp ceases⟩⟩

/-- Read of recurrence, the balance is exact: ceasing to be recurs exactly when, from each
step, the list at some later step is shorter than the list at the start with the members
that came to be between. -/
theorem ceasing_iff_shortfall (listed : Listed p l) :
    (∀ N, ∃ t a, N ≤ t ∧ CeasesToBe (p a) t) ↔
      ∀ N, ∃ n, (l (N + n)).length <
        (l N).length + total (steps N n) fun t => comings (l (t + 1)) p t :=
  (ceasing_iff_shortfall_from (T := 0) fun s _ => listed s).trans
    ⟨fun short N => short N (Nat.zero_le N), fun short N _ => short N⟩

/-- And where what holds is listed from `T` on, coming to be recurs exactly when, from each
step from `T` on, the list at some later step with the members that ceased to be between is
longer than the list at the start. -/
theorem coming_iff_excess_from {T : Nat} (listing : ∀ s, T ≤ s → Distinct (l s) ∧ ∀ a, p a s ↔ a ∈ l s) :
    (∀ N, ∃ t a, N ≤ t ∧ ComesToBe (p a) t) ↔
      ∀ N, T ≤ N → ∃ n, (l N).length <
        (l (N + n)).length + total (steps N n) fun t => ceasings (l t) p t :=
  ⟨fun coming N from_ => match coming N with
    | ⟨t, a, later, comes⟩ => match le_dest later with
      | ⟨m, same⟩ =>
        have came : 0 < total (steps N (m + 1)) fun t => comings (l (t + 1)) p t :=
          Nat.lt_of_lt_of_le
            (same ▸ total_pos_of_mem
              (((listing (t + 1) (Nat.le_succ_of_le (Nat.le_trans from_ later))).2 a).mp comes.2)
              (mark_pos.mpr comes))
            (Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq (steps_last _ N m).symm))
        ⟨m + 1, Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right came)
          (Nat.le_of_eq (over_stretch_on fun s lo _ => listing s (Nat.le_trans from_ lo)).symm)⟩,
   fun excess N => match excess (N + T) (Nat.le_add_left T N) with
    | ⟨n, short⟩ =>
      match total_pos (steps (N + T) n) (pos_of_exceeds short (Nat.le_of_eq
          (over_stretch_on fun s lo _ => listing s (Nat.le_trans (Nat.le_add_left T N) lo)))) with
      | ⟨t, mem, came⟩ => match total_pos (l (t + 1)) came with
        | ⟨a, _, comes⟩ =>
          ⟨t, a, Nat.le_trans (Nat.le_add_right N T) (steps_mem mem), mark_pos.mp comes⟩⟩

/-- And coming to be recurs exactly when, from each step, the list at some later step with
the members that ceased to be between is longer than the list at the start. -/
theorem coming_iff_excess (listed : Listed p l) :
    (∀ N, ∃ t a, N ≤ t ∧ ComesToBe (p a) t) ↔
      ∀ N, ∃ n, (l N).length <
        (l (N + n)).length + total (steps N n) fun t => ceasings (l t) p t :=
  (coming_iff_excess_from (T := 0) fun s _ => listed s).trans
    ⟨fun excess N => excess N (Nat.zero_le N), fun excess N _ => excess N⟩

/-- The census law: where what holds is listed at each step, ceasing to be at arbitrarily
late steps needs coming to be at arbitrarily late steps. Ceasings recurring accumulate past
any list at the start, and only comings make up the difference. -/
theorem coming_of_ceasing (listed : Listed p l)
    (ceasing : ∀ N, ∃ t a, N ≤ t ∧ CeasesToBe (p a) t) :
    ∀ N, ∃ t a, N ≤ t ∧ ComesToBe (p a) t :=
  listed.coming_iff_excess.mpr fun N =>
    match recurring_accumulates (q := fun t => ceasings (l t) p t) (fun M =>
        match ceasing M with
        | ⟨t, a, later, ceases⟩ =>
          ⟨t, later, total_pos_of_mem (((listed t).2 a).mp ceases.1) (mark_pos.mpr ceases)⟩)
        N ((l N).length + 1) with
    | ⟨n, many⟩ => ⟨n, Nat.lt_of_lt_of_le many (Nat.le_add_left _ _)⟩

/-- Where at most `K` are listed at arbitrarily late steps, coming to be at arbitrarily late
steps needs ceasing to be at arbitrarily late steps: comings recurring accumulate past `K`,
and the list returns to at most `K`. -/
theorem ceasing_of_returning (listed : Listed p l) {K : Nat}
    (returns : ∀ N, ∃ t, N ≤ t ∧ (l t).length ≤ K)
    (coming : ∀ N, ∃ t a, N ≤ t ∧ ComesToBe (p a) t) :
    ∀ N, ∃ t a, N ≤ t ∧ CeasesToBe (p a) t :=
  listed.ceasing_iff_shortfall.mpr fun N =>
    match recurring_accumulates (q := fun t => comings (l (t + 1)) p t) (fun M =>
        match coming M with
        | ⟨t, a, later, comes⟩ =>
          ⟨t, later, total_pos_of_mem (((listed (t + 1)).2 a).mp comes.2) (mark_pos.mpr comes)⟩)
        N (K + 1) with
    | ⟨m, many⟩ => match returns (N + m) with
      | ⟨_, later, few⟩ => match le_dest later with
        | ⟨k, same⟩ => ⟨m + k, Nat.lt_of_le_of_lt
            (Nat.le_trans (Nat.le_of_eq (congrArg (fun s => (l s).length)
              (same.trans (Nat.add_assoc N m k)).symm)) few)
            (Nat.lt_of_lt_of_le many (Nat.le_trans (steps_mono _ N m k) (Nat.le_add_left _ _)))⟩

/-- The bounded law: where from some step on at most `B` are listed, coming to be at
arbitrarily late steps needs ceasing to be at arbitrarily late steps. -/
theorem ceasing_of_coming (listed : Listed p l) {T B : Nat}
    (bounded : ∀ t, T ≤ t → (l t).length ≤ B) (coming : ∀ N, ∃ t a, N ≤ t ∧ ComesToBe (p a) t) :
    ∀ N, ∃ t a, N ≤ t ∧ CeasesToBe (p a) t :=
  listed.ceasing_of_returning
    (fun N => ⟨N + T, Nat.le_add_right N T, bounded _ (Nat.le_add_left T N)⟩) coming

/-- So where from some step on at most `B` are listed, coming to be recurs exactly when
ceasing to be does: the law of a finite family (`coming_recurs_iff`) needs only a list
bounded from some step on. -/
theorem coming_iff_ceasing (listed : Listed p l) {T B : Nat}
    (bounded : ∀ t, T ≤ t → (l t).length ≤ B) :
    (∀ N, ∃ t a, N ≤ t ∧ ComesToBe (p a) t) ↔ ∀ N, ∃ t a, N ≤ t ∧ CeasesToBe (p a) t :=
  ⟨listed.ceasing_of_coming bounded, listed.coming_of_ceasing⟩

/-- The rate law: where at most `B t` are listed at each step `t`, and from each step the
members coming to be over some stretch outnumber the bound at its end, ceasing to be
recurs. A bound however large is outnumbered by comings that outpace it; no bound growing
without end, however slowly, makes ceasing recur by itself (`World.slow_world`). -/
theorem ceasing_of_outpacing (listed : Listed p l) {B : Nat → Nat}
    (bounded : ∀ t, (l t).length ≤ B t)
    (outpacing : ∀ N, ∃ n, B (N + n) < total (steps N n) fun t => comings (l (t + 1)) p t) :
    ∀ N, ∃ t a, N ≤ t ∧ CeasesToBe (p a) t :=
  listed.ceasing_iff_shortfall.mpr fun N => match outpacing N with
    | ⟨n, more⟩ => ⟨n, Nat.lt_of_le_of_lt (bounded (N + n))
        (Nat.lt_of_lt_of_le more (Nat.le_add_left _ _))⟩

end Listed

/-! ## The tally is the whole law of counting -/

/-- Counts a listing can have: `n t` listed at each step, `c t` ceasing to be and `a t`
coming to be across the step from `t`. Some number are kept across each step: with those
that cease they are the list before it, with those that come the list after it. -/
def Tally (n c a : Nat → Nat) : Prop :=
  ∀ t, ∃ k, n t = k + c t ∧ n (t + 1) = k + a t

/-- Whatever is listed is counted by a tally. -/
theorem Listed.tally {p : α → Nat → Prop} [∀ a t, Decidable (p a t)] {l : Nat → List α}
    (listed : Listed p l) :
    Tally (fun t => (l t).length) (fun t => ceasings (l t) p t)
      (fun t => comings (l (t + 1)) p t) :=
  listed.keeps

/-- The balance across each step that `Listed.across` states of a listing: what is counted
after the step with what ceased is what was counted before it with what came. -/
def Balance (n c a : Nat → Nat) : Prop :=
  ∀ t, n (t + 1) + c t = n t + a t

/-- A tally balances. -/
theorem Tally.balance {n c a : Nat → Nat} (tally : Tally n c a) : Balance n c a := fun t =>
  match tally t with
  | ⟨k, before, after⟩ => (congrArg (· + c t) after).trans
      ((Nat.add_right_comm k (a t) (c t)).trans (congrArg (· + a t) before.symm))

/-- Under a tally no more cease across a step than were counted before it. -/
theorem Tally.ceasing_le {n c a : Nat → Nat} (tally : Tally n c a) (t : Nat) : c t ≤ n t :=
  match tally t with
  | ⟨k, before, _⟩ => Nat.le_trans (Nat.le_add_left (c t) k) (Nat.le_of_eq before.symm)

/-- A tally is exactly the balance with no more ceasing across a step than were counted
before it (the thirteenth review's probe). -/
theorem tally_iff {n c a : Nat → Nat} : Tally n c a ↔ Balance n c a ∧ ∀ t, c t ≤ n t :=
  ⟨fun tally => ⟨tally.balance, tally.ceasing_le⟩,
   fun ⟨balance, bounded⟩ t => match le_dest (bounded t) with
    | ⟨k, same⟩ => ⟨k, same.trans (Nat.add_comm (c t) k),
        add_right_cancel (c t) ((balance t).trans ((congrArg (· + a t)
          (same.trans (Nat.add_comm (c t) k))).trans (Nat.add_right_comm k (c t) (a t))))⟩⟩

/-- The balance alone is no tally: with none counted and one ceasing and one coming across
every step, it holds and the tally fails. -/
theorem balance_not_tally :
    Balance (fun _ => 0) (fun _ => 1) (fun _ => 1) ∧
      ¬ Tally (fun _ => 0) (fun _ => 1) (fun _ => 1) :=
  ⟨fun _ => rfl, fun tally => Nat.not_succ_le_zero 0 (tally.ceasing_le 0)⟩

/-- Tallies respect the counts' values at each step. -/
theorem Tally.congr {n c a n' c' a' : Nat → Nat} (tally : Tally n c a)
    (same : ∀ t, n t = n' t ∧ c t = c' t ∧ a t = a' t) : Tally n' c' a' := fun t =>
  match tally t with
  | ⟨k, before, after⟩ =>
    ⟨k, (same t).1.symm.trans (before.trans (congrArg (k + ·) (same t).2.1)),
     (same (t + 1)).1.symm.trans (after.trans (congrArg (k + ·) (same t).2.2))⟩

theorem steps_length : ∀ T n, (steps T n).length = n
  | _, 0 => rfl
  | T, n + 1 => congrArg Nat.succ (steps_length (T + 1) n)

theorem steps_within : ∀ {T n k : Nat}, k ∈ steps T n → k < T + n
  | _, 0, _, mem => nomatch mem
  | T, n + 1, _, .head _ =>
    Nat.lt_of_lt_of_le (Nat.lt_succ_self T) (Nat.succ_le_succ (Nat.le_add_right T n))
  | T, n + 1, _, .tail _ mem =>
    Nat.lt_of_lt_of_le (steps_within mem) (Nat.le_of_eq (Nat.add_right_comm T 1 n))

theorem steps_of_within : ∀ {T n k : Nat}, T ≤ k → k < T + n → k ∈ steps T n
  | _, 0, _, above, within => absurd (Nat.lt_of_le_of_lt above within) (Nat.lt_irrefl _)
  | _, _ + 1, _, .refl, _ => .head _
  | T, n + 1, _ + 1, .step above, within => .tail _ (steps_of_within (Nat.succ_le_succ above)
      (Nat.lt_of_lt_of_le within (Nat.le_of_eq (Nat.add_right_comm T n 1))))

theorem steps_distinct : ∀ T n, Distinct (steps T n)
  | _, 0 => trivial
  | T, n + 1 => ⟨fun mem => Nat.not_succ_le_self T (steps_mem mem), steps_distinct (T + 1) n⟩

theorem steps_below_all {T m : Nat} :
    ∀ {n}, n ≤ m → total (steps T n) (fun k => mark (k < T + m)) = n
  | 0, _ => rfl
  | n + 1, le => (steps_last _ T n).trans ((congrArg (· + _) (steps_below_all
      (Nat.le_of_succ_le le))).trans (congrArg (n + ·) (mark_one (Nat.add_lt_add_left le T))))

/-- Of the `m + r` steps from `T`, `m` lie below `T + m`. -/
theorem steps_below {T m : Nat} : ∀ r, total (steps T (m + r)) (fun k => mark (k < T + m)) = m
  | 0 => steps_below_all (Nat.le_refl m)
  | r + 1 => (steps_last _ T (m + r)).trans ((congrArg (· + _) (steps_below r)).trans
      (congrArg (m + ·) (mark_zero (Nat.not_lt_of_ge
        (Nat.add_le_add_left (Nat.le_add_right m r) T)))))

theorem steps_above_none {T m : Nat} :
    ∀ {n}, n ≤ m → total (steps T n) (fun k => mark (T + m ≤ k)) = 0
  | 0, _ => rfl
  | n + 1, le => (steps_last _ T n).trans ((congrArg (· + _) (steps_above_none
      (Nat.le_of_succ_le le))).trans (congrArg (0 + ·)
        (mark_zero (Nat.not_le_of_gt (Nat.add_lt_add_left le T)))))

/-- And `r` lie from `T + m` on. -/
theorem steps_above {T m : Nat} : ∀ r, total (steps T (m + r)) (fun k => mark (T + m ≤ k)) = r
  | 0 => steps_above_none (Nat.le_refl m)
  | r + 1 => (steps_last _ T (m + r)).trans ((congrArg (· + _) (steps_above r)).trans
      (congrArg (r + ·) (mark_one (Nat.add_le_add_left (Nat.le_add_right m r) T))))

namespace Queue

variable (n c : Nat → Nat)

/-- How many have left the queue before step `t`. -/
def gone (t : Nat) : Nat :=
  total (steps 0 t) c

/-- Member `k` is in the queue at step `t`: it has joined and not yet left. Members join at
the back and leave from the front, each in turn: at step `t` the queue runs from member
`gone c t` for `n t` members. -/
def holds (k t : Nat) : Prop :=
  gone c t ≤ k ∧ k < gone c t + n t

instance (k t : Nat) : Decidable (holds n c k t) := instDecidableAnd

/-- The queue at step `t`, front first. -/
def line (t : Nat) : List Nat :=
  steps (gone c t) (n t)

variable {n c} {a : Nat → Nat}

theorem gone_succ (t : Nat) : gone c (t + 1) = gone c t + c t :=
  (steps_last c 0 t).trans (congrArg (_ + ·) (congrArg c (Nat.zero_add t)))

/-- The queue is listed at each step, each member once. -/
theorem listed : Listed (holds n c) (line n c) :=
  fun _ => ⟨steps_distinct _ _, fun _ =>
    ⟨fun holds => steps_of_within holds.1 holds.2,
     fun mem => ⟨steps_mem mem, steps_within mem⟩⟩⟩

/-- The queue at `t` ends where the members it keeps across the step end, counted from the
front after the step. -/
theorem kept_end {t k : Nat} (before : n t = k + c t) :
    gone c t + n t = gone c (t + 1) + k :=
  (congrArg (gone c t + ·) (before.trans (Nat.add_comm k (c t)))).trans
    ((Nat.add_assoc _ _ _).symm.trans (congrArg (· + k) (gone_succ t).symm))

/-- Under a tally, `c t` leave across the step from `t`: those at the front. -/
theorem ceasings_eq (tally : Tally n c a) (t : Nat) :
    ceasings (line n c t) (holds n c) t = c t :=
  match tally t with
  | ⟨k, before, after⟩ =>
    have room : gone c t + n t ≤ gone c (t + 1) + n (t + 1) :=
      Nat.le_trans (Nat.le_of_eq (kept_end before)) (Nat.le_trans
        (Nat.add_le_add_left (Nat.le_add_right k (a t)) _)
        (Nat.le_of_eq (congrArg (gone c (t + 1) + ·) after.symm)))
    (total_congr_on fun j mem => mark_iff (p := CeasesToBe (holds n c j) t)
      ⟨fun ceases => match Nat.lt_or_ge j (gone c t + c t) with
        | .inl front => front
        | .inr behind => absurd ⟨Nat.le_trans (Nat.le_of_eq (gone_succ t)) behind,
            Nat.lt_of_lt_of_le ceases.1.2 room⟩ ceases.2,
       fun front => ⟨⟨steps_mem mem, steps_within mem⟩, fun stays =>
         Nat.lt_irrefl _ (Nat.lt_of_lt_of_le front
           (Nat.le_trans (Nat.le_of_eq (gone_succ t).symm) stays.1))⟩⟩).trans
      ((congrArg (fun m => total (steps (gone c t) m) fun j => mark (j < gone c t + c t))
        (before.trans (Nat.add_comm k (c t)))).trans (steps_below k))

/-- And `a t` join: those at the back. -/
theorem comings_eq (tally : Tally n c a) (t : Nat) :
    comings (line n c (t + 1)) (holds n c) t = a t :=
  match tally t with
  | ⟨k, before, after⟩ =>
    (total_congr_on fun j mem => mark_iff (p := ComesToBe (holds n c j) t)
      ⟨fun comes => match Nat.lt_or_ge j (gone c t + n t) with
        | .inl within => absurd ⟨Nat.le_trans (Nat.le_trans (Nat.le_add_right _ (c t))
            (Nat.le_of_eq (gone_succ t).symm)) (steps_mem mem), within⟩ comes.1
        | .inr behind => Nat.le_trans (Nat.le_of_eq (kept_end before).symm) behind,
       fun behind => ⟨fun holds => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le holds.2
           (Nat.le_trans (Nat.le_of_eq (kept_end before)) behind)),
         ⟨steps_mem mem, steps_within mem⟩⟩⟩).trans
      ((congrArg (fun m => total (steps (gone c (t + 1)) m)
        fun j => mark (gone c (t + 1) + k ≤ j)) after).trans (steps_above (a t)))

/-- Every tally is the count of a queue. -/
theorem counts (tally : Tally n c a) (t : Nat) :
    (line n c t).length = n t ∧ ceasings (line n c t) (holds n c) t = c t ∧
      comings (line n c (t + 1)) (holds n c) t = a t :=
  ⟨steps_length _ _, ceasings_eq tally t, comings_eq tally t⟩

end Queue

/-- A property of counts that respects their values at each step. Given function
extensionality every property does; the pure core does not assume it. -/
def Pointwise (Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop) : Prop :=
  ∀ {n c a n' c' a' : Nat → Nat}, (∀ t, n t = n' t ∧ c t = c' t ∧ a t = a' t) →
    Q n c a → Q n' c' a'

/-- The tally is the whole law of counting: a property of the counts that holds wherever
what holds is listed holds of every tally, and conversely. -/
theorem counting_laws {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop}
    (pointwise : Pointwise Q) :
    (∀ (α : Type) (p : α → Nat → Prop) [∀ a t, Decidable (p a t)] (l : Nat → List α),
      Listed p l → Q (fun t => (l t).length) (fun t => ceasings (l t) p t)
        (fun t => comings (l (t + 1)) p t)) ↔
      ∀ n c a, Tally n c a → Q n c a :=
  ⟨fun law n c _ tally => pointwise (fun t => Queue.counts tally t)
      (law Nat (Queue.holds n c) (Queue.line n c) Queue.listed),
   fun law _ _ _ _ listed => law _ _ _ listed.tally⟩

/-- The counts some listing has are exactly the tallies: the whole law of counting, with no
condition on a property of the counts (the thirteenth review's probe). -/
theorem tally_iff_counted (n c a : Nat → Nat) :
    Tally n c a ↔ ∃ (α : Type) (p : α → Nat → Prop) (_ : ∀ x t, Decidable (p x t))
      (l : Nat → List α), Listed p l ∧
        ∀ t, (l t).length = n t ∧ ceasings (l t) p t = c t ∧ comings (l (t + 1)) p t = a t :=
  ⟨fun tally => ⟨Nat, Queue.holds n c, fun _ _ => inferInstance, Queue.line n c, Queue.listed,
     Queue.counts tally⟩,
   fun ⟨_, _, _, _, listed, same⟩ => listed.tally.congr same⟩

/-- How far a queue has reached: those gone and those in it are those at the first step and
those joined since. -/
theorem Queue.reached {n c a : Nat → Nat} (tally : Tally n c a) :
    ∀ t, Queue.gone c t + n t = n 0 + total (steps 0 t) a
  | 0 => Nat.zero_add (n 0)
  | t + 1 => match tally t with
    | ⟨_, before, after⟩ => (congrArg (_ + ·) after).trans ((Nat.add_assoc _ _ _).symm.trans
        ((congrArg (· + a t) (Queue.kept_end before).symm).trans
          ((congrArg (· + a t) (Queue.reached tally t)).trans ((Nat.add_assoc _ _ _).trans
            (congrArg (n 0 + ·) ((steps_last a 0 t).trans
              (congrArg (_ + ·) (congrArg a (Nat.zero_add t)))).symm)))))

/-! ## Change bounds -/

/-- At how many steps from `T` before `t` a quantity is positive. -/
def occurrences (T : Nat) (q : Nat → Nat) : Nat → Nat
  | 0 => 0
  | t + 1 => occurrences T q t + mark (T ≤ t ∧ 0 < q t)

theorem occurrences_before {T : Nat} {q : Nat → Nat} :
    ∀ {t : Nat}, t ≤ T → occurrences T q t = 0
  | 0, _ => rfl
  | _ + 1, early => (congrArg (occurrences T q _ + ·) (mark_zero fun later =>
      Nat.lt_irrefl _ (Nat.lt_of_lt_of_le early later.1))).trans (occurrences_before
        (Nat.le_of_lt early))

theorem occurrences_succ {T t : Nat} (q : Nat → Nat) (later : T ≤ t) :
    occurrences T q (t + 1) = occurrences T q t + mark (0 < q t) :=
  congrArg (occurrences T q t + ·)
    (mark_iff ⟨And.right, fun positive => ⟨later, positive⟩⟩)

theorem occurrences_mono {T : Nat} (q : Nat → Nat) {t : Nat} :
    ∀ {s : Nat}, t ≤ s → occurrences T q t ≤ occurrences T q s
  | _, .refl => Nat.le_refl _
  | _ + 1, .step within => Nat.le_trans (occurrences_mono q within) (Nat.le_add_right _ _)

theorem occurrences_le {T : Nat} (q : Nat → Nat) : ∀ t, occurrences T q t ≤ t
  | 0 => Nat.le_refl 0
  | t + 1 => Nat.add_le_add (occurrences_le q t) (mark_le_one _)

/-- Counting from the first step counts at most `T` more than counting from `T`. -/
theorem occurrences_zero_le {T : Nat} (q : Nat → Nat) :
    ∀ t, occurrences 0 q t ≤ occurrences T q t + T
  | 0 => Nat.zero_le _
  | t + 1 => match Nat.lt_or_ge t T with
    | .inl early => Nat.le_trans (occurrences_le q (t + 1))
        (Nat.le_trans early (Nat.le_add_left T _))
    | .inr later => Nat.le_trans (Nat.le_of_eq (occurrences_succ q (Nat.zero_le t)))
        (Nat.le_trans (Nat.add_le_add_right (occurrences_zero_le q t) _)
          (Nat.le_of_eq ((Nat.add_right_comm _ T _).trans
            (congrArg (· + T) (occurrences_succ q later).symm))))

/-- A quantity that never rises from step `T` on, and falls at each step at which `q` is
positive, has fallen from its value at `T` by at least the number of those steps. -/
theorem falls_by_occurrences (r q : Nat → Nat) {T : Nat}
    (falls : ∀ t, T ≤ t → r (t + 1) + mark (0 < q t) ≤ r t) :
    ∀ {t}, T ≤ t → r t + occurrences T q t ≤ r T
  | _, .refl => Nat.le_of_eq ((congrArg (r T + ·) (occurrences_before (Nat.le_refl T))).trans
      (Nat.add_zero _))
  | m + 1, .step later => Nat.le_trans (Nat.le_of_eq ((congrArg (r (m + 1) + ·)
      (occurrences_succ q later)).trans ((Nat.add_assoc _ _ _).symm.trans
        (Nat.add_right_comm _ _ _))))
      (Nat.le_trans (Nat.add_le_add_right (falls m later) _) (falls_by_occurrences r q falls later))

/-- From step `T` on, the number counted with the steps since `T` at which something ceased
or arose stays within `B`. -/
def ChangeBound (T B : Nat) (n c a : Nat → Nat) : Prop :=
  ∀ t, T ≤ t → n t + occurrences T (fun s => c s + a s) t ≤ B

namespace ChangeBound

variable {T B : Nat} {n c a : Nat → Nat}

/-- Within a change bound, change does not recur. -/
theorem not_recurring (bound : ChangeBound T B n c a) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ 0 < c t + a t :=
  fun recurs =>
    have more : ∀ m, ∃ t, T ≤ t ∧ m ≤ occurrences T (fun s => c s + a s) t := fun m =>
      Nat.rec ⟨T, Nat.le_refl T, Nat.zero_le _⟩ (fun _ ⟨t, later, many⟩ =>
        match recurs t with
        | ⟨s, after, changes⟩ => ⟨s + 1, Nat.le_trans later (Nat.le_trans after
            (Nat.le_add_right s 1)), Nat.le_trans (Nat.add_le_add_right many 1)
            (Nat.le_trans (Nat.add_le_add_right (occurrences_mono _ after) 1)
              (Nat.le_of_eq ((congrArg (occurrences T _ s + ·) (mark_one changes)).symm.trans
                (occurrences_succ _ (Nat.le_trans later after)).symm)))⟩) m
    match more (B + 1) with
    | ⟨t, later, many⟩ => Nat.lt_irrefl B (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le
        (Nat.lt_succ_self B) many) (Nat.le_trans (Nat.le_add_left _ _) (bound t later)))

/-- A change bound from step `T` is one from the first step, larger by `T` and the counts
before `T` (the thirteenth review's probe). -/
theorem from_zero (bound : ChangeBound T B n c a) :
    ChangeBound 0 (B + T + total (steps 0 T) n) n c a := fun t _ =>
  match Nat.lt_or_ge t T with
  | .inl early => Nat.le_trans
      (Nat.add_le_add (le_total_of_mem (q := n) (steps_of_within (Nat.zero_le t)
        (Nat.lt_of_lt_of_le early (Nat.le_of_eq (Nat.zero_add T).symm))))
        (Nat.le_trans (occurrences_le _ t) (Nat.le_of_lt early)))
      (Nat.le_trans (Nat.le_of_eq (Nat.add_comm _ _))
        (Nat.add_le_add_right (Nat.le_add_left T B) _))
  | .inr later => Nat.le_trans (Nat.add_le_add_left (occurrences_zero_le _ t) _)
      (Nat.le_trans (Nat.le_of_eq (Nat.add_assoc _ _ _).symm)
        (Nat.le_trans (Nat.add_le_add_right (bound t later) T) (Nat.le_add_right _ _)))

/-- Under a change bound `B` from the first step, at most `B` join at each of at most `B`
steps. -/
theorem joins (tally : Tally n c a) (bound : ChangeBound 0 B n c a) :
    ∀ t, total (steps 0 t) a ≤ B * occurrences 0 (fun s => c s + a s) t
  | 0 => Nat.zero_le _
  | t + 1 =>
    have joined : a t ≤ B * mark (0 < c t + a t) := match Nat.eq_zero_or_pos (a t) with
      | .inl zero => Nat.le_trans (Nat.le_of_eq zero) (Nat.zero_le _)
      | .inr joining => match tally t with
        | ⟨_, _, after⟩ => Nat.le_trans (Nat.le_trans (Nat.le_add_left _ _)
            (Nat.le_of_eq after.symm)) (Nat.le_trans (Nat.le_trans (Nat.le_add_right _ _)
              (bound (t + 1) (Nat.zero_le _))) (Nat.le_of_eq ((congrArg (B * ·)
                (mark_one (Nat.lt_of_lt_of_le joining (Nat.le_add_left _ _)))).trans
                  (Nat.mul_one B)).symm))
    Nat.le_trans (Nat.le_of_eq ((steps_last a 0 t).trans
        (congrArg (_ + ·) (congrArg a (Nat.zero_add t)))))
      (Nat.le_trans (Nat.add_le_add (joins tally bound t) joined)
        (Nat.le_of_eq ((Nat.left_distrib _ _ _).symm.trans
          (congrArg (B * ·) (occurrences_succ _ (Nat.zero_le t)).symm))))

/-- So a queue counting a tally whose change `B` bounds from the first step never reaches past
its `B + B * B`-th member. -/
theorem reach (tally : Tally n c a) (bound : ChangeBound 0 B n c a) (t : Nat) :
    Queue.gone c t + n t ≤ B + B * B :=
  Nat.le_trans (Nat.le_of_eq (Queue.reached tally t))
    (Nat.add_le_add (bound 0 (Nat.le_refl 0)) (Nat.le_trans (joins tally bound t)
      (Nat.mul_le_mul_left B (Nat.le_trans (Nat.le_add_left _ _)
        (bound t (Nat.zero_le t))))))

end ChangeBound

theorem changeBound_iff_zero {n c a : Nat → Nat} :
    (∃ T B, ChangeBound T B n c a) ↔ ∃ B, ChangeBound 0 B n c a :=
  ⟨fun ⟨_, _, bound⟩ => ⟨_, bound.from_zero⟩, fun ⟨B, bound⟩ => ⟨0, B, bound⟩⟩

namespace Swap

variable (s : Nat → Bool)

/-- One member leaves and one joins across the step at the first `true` of `s`, and nothing
changes at any other step. -/
def change (t : Nat) : Nat :=
  mark ((clear s t && s t) = true)

theorem mark_split : ∀ b d : Bool,
    mark ((b && d) = true) + mark ((b && !d) = true) = mark (b = true)
  | true, true => rfl
  | true, false => rfl
  | false, _ => rfl

theorem mark_twice : ∀ b : Bool, mark (0 < mark (b = true) + mark (b = true)) = mark (b = true)
  | true => rfl
  | false => rfl

/-- The steps before `t` with a change, with whether no `true` has come before `t`, are
one. -/
theorem counted : ∀ t,
    occurrences 0 (fun u => change s u + change s u) t + mark (clear s t = true) = 1
  | 0 => rfl
  | t + 1 => (congrArg (· + mark (clear s (t + 1) = true))
      ((occurrences_succ _ (Nat.zero_le t)).trans (congrArg (_ + ·) (mark_twice _)))).trans
      ((Nat.add_assoc _ _ _).trans
        ((congrArg (occurrences 0 (fun u => change s u + change s u) t + ·)
          (mark_split (clear s t) (s t))).trans (counted t)))

theorem tally : Tally (fun _ => 1) (change s) (change s) := fun t =>
  match Clear.cases (clear s t && s t) with
  | .inl no => ⟨1, (congrArg (fun b => 1 + mark (b = true)) no).symm,
      (congrArg (fun b => 1 + mark (b = true)) no).symm⟩
  | .inr yes => ⟨0, (congrArg (fun b => 0 + mark (b = true)) yes).symm,
      (congrArg (fun b => 0 + mark (b = true)) yes).symm⟩

theorem change_bound : ChangeBound 0 2 (fun _ => 1) (change s) (change s) := fun t _ =>
  Nat.add_le_add_left (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (counted s t))) 1

/-- At the first `true`, one leaves and one joins. -/
theorem at_first {m : Nat} (c : clear s m = true) (yes : s m = true) : change s m = 1 :=
  congrArg (fun b => mark (b = true)) (Clear.and_both _ _ c yes)

/-- A step after which no first `true` comes decides `s`. -/
theorem decide_of_end {E : Nat} (quiet : ∀ m, E ≤ m → clear s m = true → s m = true → False) :
    (∃ n, s n = true) ∨ ∀ n, s n = false :=
  match Clear.or_first s E with
  | .inr ⟨m, _, _, yes⟩ => .inl ⟨m, yes⟩
  | .inl c => .inr fun k => Clear.false_of_not (s k) fun yes =>
    match Clear.first_of_true s yes with
    | ⟨m, cm, ym⟩ => match Nat.lt_or_ge m E with
      | .inl lt => Clear.not_both (Clear.false_before s c lt) ym
      | .inr ge => quiet m ge cm ym

end Swap

/-- That change does not recur within a change bound cannot be strengthened to a step after which
nothing changes without omniscience: if every tally with a change bound from the first step, with
nothing joining when none is counted, had such a step, `LPO` would hold, even where one
member is counted throughout and is replaced at most once (`Swap`; the thirteenth review's
probe). -/
theorem ChangeBound.lpo_of_ends
    (ends : ∀ n c a : Nat → Nat, Tally n c a → (∀ t, 0 < a t → 0 < n t) →
      (∃ B, ChangeBound 0 B n c a) → ∃ E, ∀ t, E ≤ t → c t + a t = 0) : LPO := fun s =>
  match ends _ _ _ (Swap.tally s) (fun _ _ => Nat.zero_lt_one) ⟨2, Swap.change_bound s⟩ with
  | ⟨E, quiet⟩ => Swap.decide_of_end s (E := E) fun m ge c yes =>
    Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le Nat.zero_lt_two (Nat.le_of_eq
      ((congrArg (fun k => k + k) (Swap.at_first s c yes)).symm.trans (quiet m ge))))

/-! ## Censuses -/

variable {F C : Type}

namespace Web

/-- The formations active at each step are listed, each once. -/
def Census (W : Web F C) (alive : Nat → List F) : Prop :=
  Listed (fun f t => W.active t f) alive

/-- The dependences of each step, formation with condition, are listed, each once. -/
def DependenceCensus (W : Web F C) (deps : Nat → List (F × C)) : Prop :=
  Listed (fun d t => W.requires t d.1 d.2) deps

/-- The census law read of dependence: where the dependences of each step are listed,
dependences dissolving at arbitrarily late steps need dependences forming at arbitrarily
late steps (`Listed.coming_of_ceasing`). -/
theorem DependenceCensus.forming_of_dissolving {W : Web F C}
    [∀ t g c, Decidable (W.requires t g c)] {deps : Nat → List (F × C)}
    (census : W.DependenceCensus deps) (dissolving : ∀ N, ∃ t g c, N ≤ t ∧ W.Dissolves t g c) :
    ∀ N, ∃ t g c, N ≤ t ∧ W.Forms t g c :=
  fun N => match Listed.coming_of_ceasing census (fun N => match dissolving N with
      | ⟨t, g, c, later, dissolves⟩ => ⟨t, (g, c), later, dissolves⟩) N with
    | ⟨t, d, later, forms⟩ => ⟨t, d.1, d.2, later, forms⟩

/-- Where from some step on at most `B` dependences hold at each step, forming recurs
exactly when dissolving does (`Listed.coming_iff_ceasing`). -/
theorem DependenceCensus.forming_iff_dissolving {W : Web F C}
    [∀ t g c, Decidable (W.requires t g c)] {deps : Nat → List (F × C)}
    (census : W.DependenceCensus deps) {T B : Nat} (bounded : ∀ t, T ≤ t → (deps t).length ≤ B) :
    (∀ N, ∃ t g c, N ≤ t ∧ W.Forms t g c) ↔ ∀ N, ∃ t g c, N ≤ t ∧ W.Dissolves t g c :=
  ⟨fun forming N => match Listed.ceasing_of_coming census bounded (fun N => match forming N with
      | ⟨t, g, c, later, forms⟩ => ⟨t, (g, c), later, forms⟩) N with
    | ⟨t, d, later, dissolves⟩ => ⟨t, d.1, d.2, later, dissolves⟩,
   census.forming_of_dissolving⟩

instance decideForms (W : Web F C) [∀ t g c, Decidable (W.requires t g c)] (t : Nat) (g : F)
    (c : C) : Decidable (W.Forms t g c) :=
  instDecidableAnd

instance decideDissolves (W : Web F C) [∀ t g c, Decidable (W.requires t g c)] (t : Nat)
    (g : F) (c : C) : Decidable (W.Dissolves t g c) :=
  instDecidableAnd

/-- The census balance read of dependence: over any stretch, the dependences holding at the
end with those that dissolved are those holding at the start with those that formed
(`Listed.over_stretch`). -/
theorem DependenceCensus.over_stretch {W : Web F C} [∀ t g c, Decidable (W.requires t g c)]
    {deps : Nat → List (F × C)} (census : W.DependenceCensus deps) (S n : Nat) :
    (deps (S + n)).length + total (steps S n) (fun t => total (deps t) fun d =>
      mark (W.Dissolves t d.1 d.2)) =
      (deps S).length + total (steps S n) (fun t => total (deps (t + 1)) fun d =>
        mark (W.Forms t d.1 d.2)) :=
  Listed.over_stretch_on (p := fun (d : F × C) t => W.requires t d.1 d.2) fun s _ _ => census s

variable (W : Web F C) [∀ t f, Decidable (W.active t f)]

/-- If more formations are active after a step than before, one of them arises across
it. -/
theorem arises_of_more {t : Nat} {before after : List F}
    (listed : ∀ f, W.active t f → f ∈ before) (distinct : Distinct after)
    (now : ∀ f, f ∈ after → W.active (t + 1) f) (more : before.length < after.length) :
    ∃ f, f ∈ after ∧ W.Arises t f :=
  match search (p := W.active t) after with
  | .inl ⟨f, mem, inactive⟩ => ⟨f, mem, inactive, now f mem⟩
  | .inr all => absurd more (Nat.not_lt_of_ge
      (length_le_of_sub distinct fun f mem => listed f (all f mem)))

/-- A census that grows without bound makes generation unceasing. -/
theorem unceasing_of_growth {alive : Nat → List F} (census : W.Census alive)
    (grows : ∀ N K, ∃ t, N ≤ t ∧ K < (alive t).length) : W.Unceasing :=
  fun N => match grows N (alive N).length with
  | ⟨_, later, larger⟩ => match rises_between (q := fun t => (alive t).length) later larger with
    | ⟨t, from_, _, up⟩ =>
      match W.arises_of_more (fun f a => ((census t).2 f).mp a) ((census (t + 1)).1)
        (fun f mem => ((census (t + 1)).2 f).mpr mem) up with
      | ⟨f, _, arises⟩ => ⟨t, f, from_, arises⟩

/-- So with at most `B` formations active at each step from some step on, some formation
arises at arbitrarily late steps exactly when some formation ceases at arbitrarily late
steps: the law for finitely many formations (`unceasing_iff`) needs only a count bounded
from some step on. -/
theorem unceasing_iff_bounded {alive : Nat → List F} (census : W.Census alive) {T B : Nat}
    (bounded : ∀ t, T ≤ t → (alive t).length ≤ B) :
    W.Unceasing ↔ ∀ N, ∃ t f, N ≤ t ∧ W.Ceases t f :=
  Listed.coming_iff_ceasing census bounded

/-- The census balance read of activity: over any stretch, the formations active at the end
with those that ceased are those active at the start with those that arose
(`Listed.over_stretch`). -/
theorem Census.over_stretch {alive : Nat → List F} (census : W.Census alive) (S n : Nat) :
    (alive (S + n)).length + total (steps S n) (fun t => total (alive t) fun f =>
      mark (W.Ceases t f)) =
      (alive S).length + total (steps S n) (fun t => total (alive (t + 1)) fun f =>
        mark (W.Arises t f)) :=
  Listed.over_stretch_on (p := fun f t => W.active t f) fun s _ _ => census s

end Web

/-- At one step, the formations taking from the family number at most a list covering the
formations active there, where each formation taking part is listed once in the flow and
whatever takes there is active. -/
theorem Flow.takers_le_covering {W : Web F C} {L : Flow F C} {cs : List C} {t : Nat}
    {l : List F} (distinct : Distinct (L.present t))
    (taking : ∀ f c, f ∈ L.present t → 0 < L.take t f c → W.active t f)
    (covers : ∀ f, W.active t f → f ∈ l) : L.takers cs t ≤ l.length :=
  count_le_of_sub distinct fun f mem takes => match total_pos cs takes with
  | ⟨c, _, positive⟩ => covers f (taking f c mem positive)

/-- More without end makes lists covering the active formations grow without bound, where
from some step on such lists are given, each formation taking part is listed once in the
flow, and whatever takes is active. Nothing is asked of the steps before. -/
theorem Flow.More.grows_covering {W : Web F C} {L : Flow F C} {cs : List C} {S : Nat}
    {l : Nat → List F} (covers : ∀ t, S ≤ t → ∀ f, W.active t f → f ∈ l t)
    (distinct : ∀ t, S ≤ t → Distinct (L.present t))
    (taking : ∀ t f c, S ≤ t → f ∈ L.present t → 0 < L.take t f c → W.active t f)
    (more : L.More cs) : ∀ N K, ∃ t, N ≤ t ∧ K < (l t).length :=
  fun N K => match more (K + 1) with
  | ⟨T, many⟩ =>
    have from_ : S ≤ N + (T + S) := Nat.le_trans (Nat.le_add_left S T) (Nat.le_add_left _ N)
    ⟨N + (T + S), Nat.le_add_right N _, Nat.lt_of_lt_of_le
      (many _ (Nat.le_trans (Nat.le_add_right T S) (Nat.le_add_left _ N)))
      (takers_le_covering (distinct _ from_) (fun f c => taking _ f c from_) (covers _ from_))⟩

/-- Under a census, with each formation taking part in the flow listed once and only
active formations taking, more without end makes the active formations grow without
bound. -/
theorem Flow.More.grows {W : Web F C} {L : Flow F C} {cs : List C} {alive : Nat → List F}
    (census : W.Census alive) (distinct : ∀ t, Distinct (L.present t)) (taking : L.Taking W)
    (more : L.More cs) : ∀ N K, ∃ t, N ≤ t ∧ K < (alive t).length :=
  Flow.More.grows_covering (S := 0) (fun t _ f active => ((census t).2 f).mp active)
    (fun t _ => distinct t) (fun t f c _ mem takes => (taking t f c mem takes).1) more

/-- More without end leaves no step from which nothing arises, with no census and no
decision: where lists cover the active formations at arbitrarily late steps, and from some
step on each formation taking part is listed once and whatever takes is active. With
nothing arising from `N` on, every formation active later is not refuted to have been
active at a covering step `M` from `N` on, so not refuted to lie on its list; and more takers
than that list holds take at a later step. -/
theorem Flow.More.arising_never_stops_covering {W : Web F C} {L : Flow F C} {cs : List C}
    {S : Nat} (covered : ∀ N, ∃ M, ∃ l : List F, N ≤ M ∧ ∀ f, W.active M f → f ∈ l)
    (distinct : ∀ t, S ≤ t → Distinct (L.present t))
    (taking : ∀ t f c, S ≤ t → f ∈ L.present t → 0 < L.take t f c → W.active t f)
    (more : L.More cs) : ¬ ∃ N, ∀ t f, N ≤ t → ¬ W.Arises t f :=
  fun ⟨N, quiet⟩ => match covered N with
  | ⟨M, l, later, covers⟩ =>
    have back : ∀ k f, W.active (M + k) f → ¬¬ W.active M f := fun k => Nat.rec
      (motive := fun k => ∀ f, W.active (M + k) f → ¬¬ W.active M f)
      (fun _ active none => none active)
      (fun k prior f active none =>
        quiet (M + k) f (Nat.le_trans later (Nat.le_add_right M k))
          ⟨fun idle => prior f idle none, active⟩) k
    match more (l.length + 1) with
    | ⟨T, many⟩ =>
      have from_ : S ≤ M + (T + S) := Nat.le_trans (Nat.le_add_left S T) (Nat.le_add_left _ M)
      not_not_all (P := fun f => 0 < total cs (L.take (M + (T + S)) f) → f ∈ l)
        (E := L.present (M + (T + S)))
        (fun f mem none => none fun takes => absurd (fun inside => none fun _ => inside)
          (fun outside => match total_pos cs takes with
            | ⟨c, _, positive⟩ => back (T + S) f (taking _ f c from_ mem positive)
                fun active => outside (covers f active)))
        fun all => Nat.not_succ_le_self l.length (Nat.le_trans
          (many (M + (T + S)) (Nat.le_trans (Nat.le_add_right T S) (Nat.le_add_left _ M)))
          (count_le_of_sub (distinct _ from_) fun f mem takes => all f mem takes))

/-- More without end makes generation unceasing with no census, where activity is decided
from some step on: where lists cover the active formations at arbitrarily late steps, and
from that step on each formation taking part is listed once, whatever takes is active, and
activity is decided. Some taker late enough lies beyond the covering list of an earlier
step, so it came to be active between; only steps from `S` on are decided. -/
theorem Flow.More.unceasing_covering {W : Web F C} {L : Flow F C} {cs : List C} {S : Nat}
    (decided : ∀ s f, S ≤ s → Decidable (W.active s f))
    (covered : ∀ N, ∃ M, ∃ l : List F, N ≤ M ∧ ∀ f, W.active M f → f ∈ l)
    (distinct : ∀ t, S ≤ t → Distinct (L.present t))
    (taking : ∀ t f c, S ≤ t → f ∈ L.present t → 0 < L.take t f c → W.active t f)
    (more : L.More cs) : W.Unceasing :=
  fun N => match covered (N + S) with
  | ⟨M, l, later, covers⟩ => match more (l.length + 1) with
    | ⟨T, many⟩ =>
      have atM : S ≤ M := Nat.le_trans (Nat.le_add_left S N) later
      have from_ : S ≤ M + (T + S) := Nat.le_trans (Nat.le_add_left S T) (Nat.le_add_left _ M)
      have enough := many (M + (T + S))
        (Nat.le_trans (Nat.le_add_right T S) (Nat.le_add_left _ M))
      have : ∀ f, Decidable (W.active M f) := fun f => decided M f atM
      match search (p := fun f => 0 < total cs (L.take (M + (T + S)) f) → W.active M f)
          (L.present (M + (T + S))) with
      | .inr all => absurd (Nat.le_trans enough (count_le_of_sub (distinct _ from_)
          fun f mem takes => covers f (all f mem takes))) (Nat.not_succ_le_self l.length)
      | .inl ⟨f, mem, lacks⟩ =>
        match Nat.decLt 0 (total cs (L.take (M + (T + S)) f)) with
        | isFalse idle => absurd (fun takes => absurd takes idle) lacks
        | isTrue takes => match total_pos cs takes with
          | ⟨c, _, positive⟩ =>
            match came_between_from (q := fun s => W.active s f)
                (fun s within => decided s f within) atM (fun active => lacks fun _ => active)
                (Nat.le_add_right M (T + S)) (taking _ f c from_ mem positive) with
            | ⟨s, after, _, comes⟩ =>
              ⟨s, f, Nat.le_trans (Nat.le_trans (Nat.le_add_right N S) later) after, comes⟩

/-- More without end makes generation unceasing when a census lists the active
formations, each formation taking part in the flow is listed once, and only active
formations take. -/
theorem Flow.More.unceasing {W : Web F C} [∀ t f, Decidable (W.active t f)] {L : Flow F C}
    {cs : List C} {alive : Nat → List F} (census : W.Census alive)
    (distinct : ∀ t, Distinct (L.present t)) (taking : L.Taking W) (more : L.More cs) :
    W.Unceasing :=
  Flow.More.unceasing_covering (S := 0) (fun _ _ _ => inferInstance)
    (fun N => ⟨N, alive N, Nat.le_refl N, fun f active => ((census N).2 f).mp active⟩)
    (fun t _ => distinct t) (fun t f c _ mem takes => (taking t f c mem takes).1) more

/-! ## Every premise together -/

namespace Expansion

theorem distinct : ∀ t, Distinct (present t)
  | 0 => trivial
  | n + 1 => ⟨fun mem => match mem_cons_cases mem with
      | .inl same => Kind.noConfusion (congrArg Prod.fst same)
      | .inr mem => Nat.lt_irrefl n (present_active n _ mem),
     fun mem => Nat.lt_irrefl n (present_active n _ mem), distinct n⟩

theorem listed : ∀ t (f : Kind × Nat), f.2 < t → f ∈ present t
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | n + 1, (k, i), lt => match Nat.lt_or_ge i n with
    | .inl below => .tail _ (.tail _ (listed n (k, i) below))
    | .inr above =>
      have same : n = i := Nat.le_antisymm above (Nat.le_of_lt_succ lt)
      match k with
      | .renewer => Eq.subst (motive := fun j => (Kind.renewer, j) ∈ present (n + 1))
          same (.head _)
      | .grower => Eq.subst (motive := fun j => (Kind.grower, j) ∈ present (n + 1))
          same (.tail _ (.head _))

/-- The expansion's formations active at each step are those taking part, each listed once. -/
theorem census : web.Census present :=
  fun t => ⟨distinct t, fun f => ⟨listed t f, present_active t f⟩⟩

/-- Every premise of `Flow.More.unceasing` holds together in the expansion. -/
theorem counted :
    web.Census present ∧ (∀ t, Distinct (flow.present t)) ∧ flow.Taking web ∧
    flow.More [()] :=
  ⟨census, distinct, growers_take.1, more.2.2.2.2.2.2⟩

end Expansion

namespace Cycle

theorem distinct : ∀ t, Distinct (present t)
  | 0 => trivial
  | n + 1 => ⟨fun mem => Nat.lt_irrefl n (present_lt n n mem), distinct n⟩

theorem listed : ∀ t n, n < t → n ∈ present t
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | m + 1, n, lt => match Nat.lt_or_ge n m with
    | .inl below => .tail _ (listed m n below)
    | .inr above => Eq.subst (motive := fun j => j ∈ present (m + 1))
        (Nat.le_antisymm above (Nat.le_of_lt_succ lt)) (.head _)

/-- The cycle's formations active at each step are those taking part, each listed once. -/
theorem census : web.Census present :=
  fun t => ⟨distinct t, fun n => ⟨listed t n, present_lt t n⟩⟩

/-- Every premise of `Flow.More.unceasing` holds together in the cycle. -/
theorem counted :
    web.Census present ∧ (∀ t, Distinct (flow.present t)) ∧ flow.Taking web ∧
    flow.More [()] :=
  ⟨census, distinct, closed_more.2.2.1, closed_more.2.2.2.2.2.2.1⟩

end Cycle

/-! ## Under a census, unceasing generation is not yet more -/

namespace Oscillation

/-- The source at every step, and the oscillator at even steps. -/
def alive : Nat → List Formation
  | 0 => [.source, .oscillator]
  | 1 => [.source]
  | n + 2 => alive n

theorem pair : Distinct [Formation.source, .oscillator] :=
  ⟨fun mem => (match mem with | .tail _ mem => nomatch mem), fun mem => (nomatch mem), trivial⟩

theorem census : web.Census alive
  | 0 => ⟨pair, fun f => match f with
    | .source => ⟨fun _ => .head _, fun _ => trivial⟩
    | .oscillator => ⟨fun _ => .tail _ (.head _), fun _ => Nat.le_refl 2⟩⟩
  | 1 => ⟨⟨fun mem => (nomatch mem), trivial⟩, fun f => match f with
    | .source => ⟨fun _ => .head _, fun _ => trivial⟩
    | .oscillator => ⟨fun two => absurd two (Nat.not_succ_le_self 1),
        fun mem => match mem with | .tail _ mem => nomatch mem⟩⟩
  | n + 2 => census n

/-- The oscillator meets every premise of `Flow.More.unceasing` except more without end: a
census lists the active formations, the source and the oscillator take part once each, and only
the active oscillator takes. Generation is unceasing and not more. -/
theorem counted :
    web.Census alive ∧ (∀ t, Distinct (flow.present t)) ∧ flow.Taking web ∧
    web.Unceasing ∧ ¬ flow.More [()] :=
  ⟨census, fun _ => pair, takes.1, not_more.2.2.2.1, not_more.2.2.2.2⟩

end Oscillation

/-! ## Without a census, more without end with nothing arising -/

namespace Dormant

/-- The expansion's flow, with every formation active from the start. -/
def web : Web (Expansion.Kind × Nat) Unit :=
  { Expansion.web with active := fun _ _ => True }

/-- Every premise of `More.renewers_unbounded` holds, only active formations take, and
generation is more without end, yet nothing arises: infinitely many formations are
active at every step, so no census lists them. -/
theorem more_without_arising :
    Expansion.flow.Balances web ∧ Expansion.flow.Acting web ∧ Expansion.flow.Taking web ∧
    Expansion.flow.Capacity [()] 1 ∧ web.Dependent ∧ Expansion.flow.More [()] ∧
    ∀ t f, ¬ web.Arises t f :=
  ⟨Expansion.more.1, fun _ _ _ _ _ => trivial,
   fun t f _ mem takes => match f, mem, takes with
    | (.renewer, _), _, takes => absurd takes (Nat.lt_irrefl 0)
    | (.grower, _), mem, _ => ⟨trivial, rfl, Expansion.present_active t _ mem⟩,
   Expansion.more.2.2.1, fun _ _ _ _ _ => Nat.le_refl 1, Expansion.more.2.2.2.2.2.2,
   fun _ _ ⟨inactive, _⟩ => inactive trivial⟩

end Dormant

/-! ## With a formation listed many times, more without end with nothing arising -/

namespace Repeated

/-- `n` entries, all the same formation. -/
def rep : Nat → List Unit
  | 0 => []
  | n + 1 => () :: rep n

/-- One formation, always active, drawing on the condition. -/
def web : Web Unit Unit where
  level _ _ := 1
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := True

/-- The flow lists the one formation `t` times at step `t`, each entry taking one unit and
giving one back. -/
def flow : Flow Unit Unit := ⟨rep, fun _ _ _ => 1, fun _ _ _ => 1⟩

theorem ones : ∀ n, total (rep n) (fun _ => 1) = n
  | 0 => rfl
  | n + 1 => (congrArg (1 + ·) (ones n)).trans (Nat.add_comm 1 n)

theorem census : web.Census fun _ => [()] :=
  fun _ => ⟨⟨fun mem => (nomatch mem), trivial⟩,
    fun f => ⟨fun _ => match f with | () => .head [], fun _ => trivial⟩⟩

/-- A census lists the one active formation, the flow balances, only active formations
give and take, and only from what they draw on; generation is more without end, and
nothing ever arises. The one premise of `Flow.More.unceasing` that fails is that the
flow lists each formation once. -/
theorem more_without_arising :
    web.Census (fun _ => [()]) ∧ flow.Balances web ∧ flow.Acting web ∧ flow.Taking web ∧
    flow.More [()] ∧ ¬ (∀ t, Distinct (flow.present t)) ∧ ∀ t f, ¬ web.Arises t f :=
  ⟨census, fun _ _ => rfl, fun _ _ _ _ _ => trivial, fun _ _ _ _ _ => ⟨trivial, trivial⟩,
   fun K => ⟨K, fun t later => Nat.le_trans later (Nat.le_of_eq (ones t).symm)⟩,
   fun distinct => (distinct 2).1 (.head []),
   fun _ _ arises => arises.1 trivial⟩

end Repeated

/-! ## Without `Taking`, more without end with nothing arising -/

namespace Inactive

/-- Formation `0` and formations `1`, …, `t` take part in the step from `t`. -/
def present : Nat → List Nat
  | 0 => [0]
  | n + 1 => (n + 1) :: present n

/-- Formation `0` gives as much as the others take; each of the others takes one unit. -/
def flow : Flow Nat Unit where
  present := present
  take _ n _ := match n with
    | 0 => 0
    | _ + 1 => 1
  give t n _ := match n with
    | 0 => t
    | _ + 1 => 0

/-- Only formation `0` is active. -/
def web : Web Nat Unit where
  level _ _ := 1
  active _ n := n = 0
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- Formation `0` alone. -/
def alive (_ : Nat) : List Nat := [0]

theorem ones {q : Nat → Nat} (zero : q 0 = 0) (one : ∀ m, q (m + 1) = 1) :
    ∀ n, total (present n) q = n
  | 0 => congrArg (· + 0) zero
  | n + 1 => (congrArg (· + total (present n) q) (one n)).trans
      ((congrArg (1 + ·) (ones zero one n)).trans (Nat.add_comm 1 n))

theorem gives (t : Nat) : ∀ n, total (present n) (fun m => flow.give t m ()) = t
  | 0 => rfl
  | n + 1 => (Nat.zero_add _).trans (gives t n)

theorem present_le : ∀ n m, m ∈ present n → m ≤ n
  | 0, _, .head _ => Nat.le_refl 0
  | n + 1, _, .head _ => Nat.le_refl (n + 1)
  | n + 1, m, .tail _ mem => Nat.le_succ_of_le (present_le n m mem)

theorem distinct : ∀ n, Distinct (present n)
  | 0 => ⟨fun mem => (nomatch mem), trivial⟩
  | n + 1 => ⟨fun mem => Nat.not_succ_le_self n (present_le n (n + 1) mem), distinct n⟩

/-- The flow balances, only active formations give, a census lists the active
formations, each formation takes part once, and generation is more without end; yet the
takers are never active and nothing arises. -/
theorem more_without_arising :
    flow.Balances web ∧ flow.Acting web ∧ web.Census alive ∧
    (∀ t, Distinct (flow.present t)) ∧ flow.More [()] ∧ ¬ flow.Taking web ∧
    ∀ t f, ¬ web.Arises t f :=
  ⟨fun t _ => congrArg (1 + ·) ((ones rfl (fun _ => rfl) t).trans (gives t t).symm),
   fun _ n _ _ gives => match n, gives with
    | 0, _ => rfl
    | _ + 1, gives => absurd gives (Nat.lt_irrefl 0),
   fun _ => ⟨⟨fun mem => (nomatch mem), trivial⟩, fun n =>
     ⟨fun active => Eq.subst (motive := fun n => n ∈ [0]) active.symm (.head []),
      fun (mem : n ∈ [0]) => match n, mem with
        | _, .head _ => rfl
        | _, .tail _ mem => nomatch mem⟩⟩,
   distinct,
   fun K => ⟨K, fun t later => Nat.le_trans later (Nat.le_of_eq (ones rfl (fun _ => rfl) t).symm)⟩,
   fun taking => Nat.noConfusion (taking 1 1 () (.head _) Nat.zero_lt_one).1,
   fun _ _ ⟨inactive, active⟩ => inactive active⟩

end Inactive

/-! ## Drawing that the flow does not record -/

namespace Unrecorded

/-- The formations of the cycle, with no taking or giving recorded. -/
def flow : Flow Nat Unit := ⟨Cycle.present, fun _ _ _ => 0, fun _ _ _ => 0⟩

/-- The flow balances the web, and only active formations take and give; ever more
formations are active, depend on the condition and draw on it, yet no formation takes in
the flow and generation is not more without end. -/
theorem drawing_without_taking :
    flow.Balances Cycle.web ∧ flow.Acting Cycle.web ∧ flow.Taking Cycle.web ∧
    Cycle.web.Dependent ∧
    (∀ K, ∃ T, ∀ t, T ≤ t → ∀ n, n < K →
      Cycle.web.active t n ∧ Cycle.web.requires t n () ∧ Cycle.web.draws t n ()) ∧
    ¬ flow.More [()] :=
  have none : ∀ t, flow.takers [()] t = 0 := fun t => total_zero (Cycle.present t)
  ⟨fun _ _ => rfl,
   fun _ _ _ _ gives => absurd gives (Nat.lt_irrefl 0),
   fun _ _ _ _ takes => absurd takes (Nat.lt_irrefl 0),
   fun _ _ _ _ _ => Nat.le_refl 1,
   fun K => ⟨K, fun _ later _ below =>
     have active := Nat.lt_of_lt_of_le below later
     ⟨active, active, active⟩⟩,
   fun more => match more 1 with
    | ⟨T, many⟩ => Nat.not_succ_le_zero 0
        (Nat.le_trans (many T (Nat.le_refl T)) (Nat.le_of_eq (none T)))⟩

end Unrecorded

end Becoming
