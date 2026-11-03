import Becoming.GrammarLaws

/-!
# A rule rebuilt from the members it limits (OG2)

One rule makes a family of nets. Each holds a quota, a level the members draw on, in whole units,
and two lists of counts by cohort, youngest first: the holders of the rule and the others. The
members of the family differ in where the rule is taught from: the members, outside, or nowhere.
Plan §十三 item 9 asks for a model of each of plan §六's test systems; the member taught by members is
this family's model of one kind of institution, an entry rule on a shared stock, passed through
members who also keep it, with no compliance and no records. It is not a definition of an
institution.

Write `s` for the tenure, `l` the teaching age, `g` the renewal, `f` the count who would come
untaught, `c` the strength of the door. One step, given whether entrants are on offer and a
revision, both chosen at each step, in this order:

1. **The end, and the step stops.** Each member draws one unit, so the take is the count of members.
   Where the level is `0`, or the take exceeds the level and the renewal, the state becomes level
   `0` with no member, its quota kept. Nothing renews from empty. This clause is a modelling choice
   with the form of `Flow`'s gated ending (`Flow.joint_excess_ends`, 05 §1), and no law here uses
   `Flow`. The take conditions below (L1's end, L2's third conjunct, L8's end, L9, L13) exist because
   of it.
2. **Draw and renew.** The level becomes `level + g − take`.
3. **Teachers.** `T` is the count of holders of age at least `l`, read before ageing.
4. **Enter**, as a new cohort, zero in both lists without entrants on offer. Others: `f − c · T`,
   truncated at `0`, one formula for every source. Holders: the quota, where the source is outside,
   or the members with `T > 0`; otherwise none.
5. **Age.** Each list keeps its first `s` cohorts.
6. **Revise.** Where a revision is chosen, a holder stood before the step and the source is not
   outside, the quota becomes the revision.

**The split and its basis.** Holder and other are not two kinds of thing. They differ in one
relation: whether a member's cohort entered holding the rule. Taught by members, a cohort enters
holding only where holders of at least the teaching age stand; no pair of teacher and pupil is
modelled, only that count. The same count sets the door. Both draw alike, so a keeper draws on what it
keeps, added by nothing else, and nothing here is a cost of keeping beyond that. The quota is a fill
and not a limit: holders enter at the quota wherever any teacher stands, even where no one would come
untaught, and the door reads the teachers and never the quota. What limits is the teachers' count.
The level is what the members share, read here only by how much of it is drawn. Nothing here is a
utility, and no interest is assumed, opposed or common. So "holder" is a count and the door a
formula: recognition, compliance and implementation are one bit here, and the laws say nothing of
them.

Write `e q := f − c · q · (s − l)`, the leak at a quota, and `steady q L` for the state with `q`
holders and `e q` others in each of `s` cohorts.

* **The constant-take lemma** (L1). In a family with a constant take of `A`, closed under the steps
  that do not end: `A ≤ g` keeps the family and the level does not fall (`«恒取不逾生则存»`);
  `A = g + d` spends `d` a step (`«恒取逾生则减»`) and ends in `gone` (`«恒取逾生则尽»`).
* **The band** (L2). `.members`, entrants on offer at every step, no revision, `1 ≤ L`: from `steady q
  L` the rule is held at every step exactly where `l < s`, `1 ≤ q` and `(q + e q) · s ≤ g`
  (`«稳者恒持当且仅当在带»`); the same taught from outside wherever `l < s` (`«外授之稳同带»`). `Held`
  reads the level only through step 1's clause, so the third conjunct is that clause at this take.
  This is the steady state's law and not the rule's: see the gaps.
* **Without the truncation** (L3). With `C := c · (s − l)`, `(q + e q) · s ≤ g` exactly where
  `q · s ≤ g` and `(f + q) · s ≤ g + C · q · s` (`«带之二式»`). A quota can be too small only at
  `C ≥ 2`, where a keeper turns away more than itself (`«额小而不足者门必过一»`). The band at
  `1, 0, 2, 4, 2` is `q = 2` (`«带唯二»`), at `4, 2, 20, 6, 1` it is `1 ≤ q ≤ 5` (`«带一至五»`), and at
  `4, 3, 20, 6, 1` it is empty though `l < s` (`«带无»`).
* **The region** (L4). `Within P Q` is closed under every step with entrants on offer and a revision
  in `[P, Q]`, and the level does not fall (`«域闭»`, `«域中储不减»`). The steady state is a case
  (`«稳为域之例»`), and such a region exists with room for revision (`«域可得»`).
* **The drain** (L5). Taught by members, holders of at most `s` cohorts: at `s ≤ l`
  (`«不及任则持尽»`), or at a quota of `0` with no revision to a nonzero one (`«额零则持尽»`), no holder
  is left after `s` steps, on or off, from every level.
* **No holder from no holder** (L6). Taught by members or not at all, no holder stays no holder under
  the whole net (`«无持者不复»`), a revision does not take (`«无持者改不行»`), and two such states
  differing only in quota have the same later levels and members (`«无持者额不与»`): the quota is
  then read by nothing.
* **The end is closed** (L7). Every source (`«尽而不复»`). This is the model's choice that nothing
  renews from empty.
* **Open entry** (L8). No holder, entrants on offer: where `f · s ≤ g`, a level of at least one and
  the others fit, the level does not fall (`«无持而门开不逾生则存»`), and with `1 ≤ s`, `1 ≤ f` others
  are present after every step (`«无持而门开众在»`). Where `1 ≤ s` and `g < f · s`, it is `gone` at
  some step, from every level and any others (`«无持而门开逾生则尽»`).
* **Two starts compared** (L9). `steady q L`, and no holder with `f` others in each cohort at the same
  level, are two separately started states; the second is not reached from the first by this course.
  The first's level goes on exactly where `(q + e q) · s ≤ g`, the second's exactly where
  `f · s ≤ g`, and otherwise each is `gone` at some step (`«稳开二试»`, `«存尽相斥»`). So there are two
  tests, each its own. All four combinations of their arithmetic occur (`«四境皆有»`). Where only the
  steady state's holds, `2 ≤ C` (`«稳存而开不存则门过一»`); where only open entry's holds, the quota
  alone exceeds those who would come or the door turns no one away (`«开存而稳不存之式»`, from
  `«入过来者之式»`).
* **Self-revision** (L10). A revision in `[P, Q]` stays in the region (L4). A revision to `0` empties
  the holders (`«改额为零则持尽»`). The band does not settle what follows a revision, at the witnesses
  of `«带不定改后»`: below it and above it level `0` follows at one rule, below it the level is still
  present at step 20 at another, and between two quotas in the band level `0` follows at a third, where
  they make no region. The law of a revision is the region, not the band.
* **The family** (L11). After an empty membership, taught from outside the rule has holders after one
  step, and otherwise not (`«三源之表»`); taught from outside the new cohort is the quota at every step
  that does not end, also at `s ≤ l` (`«外授者即入»`).
* **Replaced** (L12, definitional). After `s` steps with no end every holder cohort is one entered in
  those steps (`«任满皆新»`); in the region the rule is held, at the quotas then standing, with
  nothing of the start among the holders (`«域中任满皆新»`).
* **Gaps** (L13). At `l = s − 1` each cohort teaches exactly the one that replaces it, so `k ≥ 1` held
  cohorts and `z` empty ones only rotate, and the rule is held at every step exactly where
  `k · (q + e) + z · f ≤ g`, with `e := f − c · q` (`«隙之律»`); over that bound it is held to the last
  state before `gone` (`«隙过生持至尽»`). Passing needs only `k ≥ 1`. `k` sets on how many of the `s`
  steps, in rotation, the door is kept and the rule passed, so the take is the steady state's on `k`
  cohorts and open entry's on `z`. Gaps hold where the steady state does not only where a cohort of it
  exceeds open entry's, and open entry would go on too (`«隙存而稳不存之式»`, a witness
  `«隙存而稳不存»`); the steady state goes on where gaps do not only where a keeper turns away more than
  itself, and open entry would end (`«稳存而隙不存之式»`, a witness `«稳存而隙不存»`, reached by a
  revision in `«改而成隙则尽»`).
* **The same rule, read at a class.** A step with a revision inside the region continues under the
  class "held or not" and not under the class "the same quota" (`«同规随类»`, at one rule): 01 §2's
  `«任一缘可为续»` with these occurrences. Whether it is the same institution is read at a class, as of
  everything; nothing new is claimed.

**Not proved here:** a classification of the ends; laws for states with gaps at `l < s − 1`; the
interval of quotas `«带之二式»` solves to; a bridge to `Flow`. **Not modelled:** why a teacher turns
anyone away, conduct other than entry, sanctions, who decides a revision, mixed tenures, schism,
records, partial passing, purposes, and capture (the revision is a free branch, not chosen by those it
favours).

The model's assumptions are its rule: whole units, discrete steps, one unit a member a step, one
quota in common, one tenure, one age from which a holder both teaches and keeps the door, a constant
renewal while anything is left, the order above, all members leaving at the end, an entrant holding
what it is taught at once. The exact thresholds hold of this order. That any actual institution meets
these hypotheses is a correspondence duty, not shown here.
-/

namespace Becoming

namespace RuleRebuilding

/-- Where the rule is taught from. -/
inductive Source where
  | members
  | outside
  | none

/-- A member of the family: the tenure `s`, the teaching age `l`, the renewal `g`, the count `f`
who would come untaught, the strength `c` of the door per teacher, and the source. -/
structure Rule where
  tenure : Nat
  teachingAge : Nat
  renewal : Nat
  untaught : Nat
  strength : Nat
  source : Source

/-- An occurrence: the quota, the level, and two lists of counts by cohort, youngest first. -/
structure St where
  quota : Nat
  level : Nat
  holders : List Nat
  others : List Nat

/-- What is chosen at a step: whether the population offers entrants, and a revision. -/
structure Move where
  on : Bool
  rev : Option Nat

/-- The sum of a list of counts. -/
def sumL : List Nat → Nat
  | [] => 0
  | a :: t => a + sumL t

/-- The first `n` entries of a list. -/
def keep {α : Type} : Nat → List α → List α
  | 0, _ => []
  | _ + 1, [] => []
  | n + 1, a :: t => a :: keep n t

/-- The count in cohorts of age at least `l`. -/
def after : Nat → List Nat → Nat
  | 0, xs => sumL xs
  | _ + 1, [] => 0
  | l + 1, _ :: t => after l t

/-- Every member draws one unit. -/
def take (x : St) : Nat := sumL x.holders + sumL x.others

/-- The holders of age at least the teaching age, read before ageing. -/
def teachers (r : Rule) (x : St) : Nat := after r.teachingAge x.holders

/-- The holders a source lets enter, given the quota and the teachers. -/
def taught : Source → Nat → Nat → Nat
  | .members, _, 0 => 0
  | .members, q, _ + 1 => q
  | .outside, q, _ => q
  | .none, _, _ => 0

/-- The new cohort of holders; zero without entrants on offer. -/
def entrant (r : Rule) (on : Bool) (x : St) : Nat :=
  match on with
  | true => taught r.source x.quota (teachers r x)
  | false => 0

/-- The new cohort of others: each teacher turns away `c` of those who would come untaught; one
formula for every source, truncated at zero. -/
def door (r : Rule) (on : Bool) (x : St) : Nat :=
  match on with
  | true => r.untaught - r.strength * teachers r x
  | false => 0

/-- A revision takes only where a holder stands. -/
def reviseHeld : Nat → Nat → Option Nat → Nat
  | 0, q, _ => q
  | _ + 1, q, Option.none => q
  | _ + 1, _, Option.some v => v

/-- The quota after a step: a source outside the members is not revised by them. -/
def revised (r : Rule) (rev : Option Nat) (x : St) : Nat :=
  match r.source with
  | .members => reviseHeld (sumL x.holders) x.quota rev
  | .outside => x.quota
  | .none => reviseHeld (sumL x.holders) x.quota rev

/-- The step ends everything where the level is `0` or the take exceeds what the level and the
renewal can give. Nothing renews from empty. -/
abbrev Ends (r : Rule) (x : St) : Prop := x.level = 0 ∨ x.level + r.renewal < take x

/-- A step that does not end: draw and renew, enter, age, revise. -/
def onward (r : Rule) (m : Move) (x : St) : St :=
  ⟨revised r m.rev x, x.level + r.renewal - take x,
    keep r.tenure (entrant r m.on x :: x.holders), keep r.tenure (door r m.on x :: x.others)⟩

/-- One step, given whether entrants are on offer and a revision. -/
def step (r : Rule) (m : Move) (x : St) : St :=
  if Ends r x then ⟨x.quota, 0, [], []⟩ else onward r m x

/-- The net of the possible: every choice at every step. -/
def net (r : Rule) : «际» St := fun x y => ∃ m, y = step r m x

/-- `k` steps along a course of choices. -/
def run (r : Rule) (c : Nat → Move) : Nat → St → St
  | 0, x => x
  | k + 1, x => step r (c k) (run r c k x)

/-- Entrants on offer at every step, and no revision. -/
def always : Nat → Move := fun _ => ⟨true, Option.none⟩

/-- The rule is held: at least one holder. -/
def Held (x : St) : Prop := 0 < sumL x.holders

/-- No holder. -/
def NoHolder (x : St) : Prop := sumL x.holders = 0

/-- The end: level `0` and no member. -/
def Gone (x : St) : Prop := x.level = 0 ∧ sumL x.holders = 0 ∧ sumL x.others = 0

/-- The leak at a quota: those who still come past `q` teachers in each teaching cohort. -/
def leak (r : Rule) (q : Nat) : Nat :=
  r.untaught - r.strength * q * (r.tenure - r.teachingAge)

/-- `q` holders and the leak's others in each of `s` cohorts. Where `l < s` and `1 ≤ q`, a step with
entrants on offer that does not end returns it with another level (`onward_steady`). -/
def steady (r : Rule) (q L : Nat) : St :=
  ⟨q, L, List.replicate r.tenure q, List.replicate r.tenure (leak r q)⟩

/-- No holder, `f` others in every cohort. -/
def nobody (r : Rule) (q L : Nat) : St :=
  ⟨q, L, List.replicate r.tenure 0, List.replicate r.tenure r.untaught⟩

/-- The band: teaching fits a tenure, and the steady state's take fits the renewal. -/
abbrev Band (r : Rule) (q : Nat) : Prop :=
  r.teachingAge < r.tenure ∧ 1 ≤ q ∧ (q + leak r q) * r.tenure ≤ r.renewal

/-! ## Arithmetic with no axiom -/

theorem add_sub_cancel' (a b : Nat) : a + b - b = a := by
  induction b with
  | zero => rfl
  | succ b ih =>
    show (a + b).succ - b.succ = a
    rw [Nat.succ_sub_succ]
    exact ih

theorem exists_of_le {a b : Nat} (h : a ≤ b) : ∃ k, b = a + k := by
  induction h with
  | refl => exact ⟨0, rfl⟩
  | step _ ih =>
    obtain ⟨k, e⟩ := ih
    exact ⟨k + 1, congrArg Nat.succ e⟩

theorem le_add_sub (a : Nat) {g t : Nat} (h : t ≤ g) : a ≤ a + g - t := by
  obtain ⟨k, e⟩ := exists_of_le h
  rw [e, Nat.add_comm t k, ← Nat.add_assoc, add_sub_cancel']
  exact Nat.le_add_right a k

theorem le_of_add_le_add_right' {a b : Nat} (c : Nat) (h : a + c ≤ b + c) : a ≤ b := by
  induction c with
  | zero => exact h
  | succ c ih => exact ih (Nat.le_of_succ_le_succ h)

theorem mul_assoc' (a b c : Nat) : a * b * c = a * (b * c) := by
  induction c with
  | zero => rfl
  | succ c ih =>
    show a * b * c + a * b = a * (b * c + b)
    rw [Nat.left_distrib, ih]

theorem right_distrib' (a b c : Nat) : (a + b) * c = a * c + b * c := by
  rw [Nat.mul_comm, Nat.left_distrib, Nat.mul_comm c a, Nat.mul_comm c b]

theorem sub_le_sub_left' (a : Nat) {b c : Nat} (h : b ≤ c) : a - c ≤ a - b := by
  induction h with
  | refl => exact Nat.le_refl _
  | step _ ih => exact Nat.le_trans (Nat.pred_le _) ih

theorem sub_eq_zero_of_le' : ∀ {a b : Nat}, a ≤ b → a - b = 0 := by
  intro a b h
  obtain ⟨k, e⟩ := exists_of_le h
  rw [e]
  clear e h
  induction a with
  | zero => exact Nat.zero_sub _
  | succ a ih =>
    have : a + 1 + k = (a + k) + 1 := by rw [Nat.add_assoc, Nat.add_comm 1 k, ← Nat.add_assoc]
    rw [this, Nat.succ_sub_succ]
    exact ih

/-- `q` with the leak of `t` turned away is at least the count untaught, where `t ≤ q`. -/
theorem le_add_sub_of_le (f : Nat) {t q : Nat} (h : t ≤ q) : f ≤ q + (f - t) := by
  cases Nat.le_total t f with
  | inl htf =>
    obtain ⟨k, e⟩ := exists_of_le htf
    rw [e, Nat.add_comm t k, add_sub_cancel', Nat.add_comm k t]
    exact Nat.add_le_add_right h k
  | inr hft =>
    rw [sub_eq_zero_of_le' hft]
    exact Nat.le_trans hft h

theorem succ_ne_zero' (n : Nat) : n + 1 ≠ 0 := fun h => Nat.noConfusion h

theorem sub_pos' {a b : Nat} (h : a < b) : 0 < b - a := by
  obtain ⟨k, e⟩ := exists_of_le h
  have e' : b = k + 1 + a := by
    rw [e]
    show a + 1 + k = k + 1 + a
    rw [Nat.add_comm (a + 1) k, Nat.add_comm a 1, Nat.add_assoc]
  rw [e', add_sub_cancel']
  exact Nat.zero_lt_succ k

/-- Every number divides by a positive `d`, additively. -/
theorem exists_div {d : Nat} (hd : 1 ≤ d) (L : Nat) : ∃ r k, L = r + k * d ∧ r < d := by
  induction L with
  | zero => exact ⟨0, 0, by rw [Nat.zero_mul], hd⟩
  | succ L ih =>
    obtain ⟨r, k, e, hr⟩ := ih
    cases Nat.lt_or_ge (r + 1) d with
    | inl h =>
      refine ⟨r + 1, k, ?_, h⟩
      rw [e, Nat.add_right_comm]
    | inr h =>
      have hrd : r + 1 = d := Nat.le_antisymm hr h
      refine ⟨0, k + 1, ?_, hd⟩
      have h1 : r + k * d + 1 = k * d + (r + 1) := by rw [Nat.add_comm r, Nat.add_assoc]
      rw [e, h1, hrd, Nat.succ_mul, Nat.zero_add]

/-! ## Lists of counts -/

theorem sumL_replicate (n a : Nat) : sumL (List.replicate n a) = n * a := by
  induction n with
  | zero => exact (Nat.zero_mul a).symm
  | succ n ih =>
    show a + sumL (List.replicate n a) = (n + 1) * a
    rw [ih, Nat.succ_mul, Nat.add_comm]

theorem length_replicate' {α : Type} (n : Nat) (a : α) : (List.replicate n a).length = n := by
  induction n with
  | zero => rfl
  | succ n ih => exact congrArg Nat.succ ih

theorem keep_cons_replicate {α : Type} (n : Nat) (a : α) :
    keep n (a :: List.replicate n a) = List.replicate n a := by
  induction n with
  | zero => rfl
  | succ n ih =>
    show a :: keep n (a :: List.replicate n a) = a :: List.replicate n a
    rw [ih]

theorem after_replicate (l s q : Nat) : after l (List.replicate s q) = (s - l) * q := by
  induction l generalizing s with
  | zero => exact sumL_replicate s q
  | succ l ih =>
    cases s with
    | zero =>
      show 0 = (0 - (l + 1)) * q
      rw [Nat.zero_sub, Nat.zero_mul]
    | succ s =>
      show after l (List.replicate s q) = (s + 1 - (l + 1)) * q
      rw [Nat.succ_sub_succ]
      exact ih s

theorem after_le_sum : ∀ (l : Nat) (xs : List Nat), after l xs ≤ sumL xs
  | 0, _ => Nat.le_refl _
  | _ + 1, [] => Nat.le_refl _
  | l + 1, a :: t =>
    Nat.le_trans (after_le_sum l t) (Nat.le_add_left (sumL t) a)

theorem after_zero_of_sum {l : Nat} {xs : List Nat} (h : sumL xs = 0) : after l xs = 0 :=
  Nat.le_antisymm (h ▸ after_le_sum l xs) (Nat.zero_le _)

theorem after_short : ∀ {l : Nat} {xs : List Nat}, xs.length ≤ l → after l xs = 0
  | 0, [], _ => rfl
  | 0, _ :: _, h => absurd h (Nat.not_succ_le_zero _)
  | _ + 1, [], _ => rfl
  | l + 1, _ :: t, h => after_short (l := l) (xs := t) (Nat.le_of_succ_le_succ h)

theorem sum_keep_le : ∀ (n : Nat) (xs : List Nat), sumL (keep n xs) ≤ sumL xs
  | 0, _ => Nat.zero_le _
  | _ + 1, [] => Nat.le_refl _
  | n + 1, a :: t => Nat.add_le_add_left (sum_keep_le n t) a

theorem length_keep_le {α : Type} : ∀ (n : Nat) (xs : List α), (keep n xs).length ≤ n
  | 0, _ => Nat.le_refl _
  | _ + 1, [] => Nat.zero_le _
  | n + 1, _ :: t => Nat.succ_le_succ (length_keep_le n t)

theorem length_keep_eq {α : Type} : ∀ (n : Nat) (xs : List α), n ≤ xs.length → (keep n xs).length = n
  | 0, _, _ => rfl
  | _ + 1, [], h => absurd h (Nat.not_succ_le_zero _)
  | n + 1, _ :: t, h => congrArg Nat.succ (length_keep_eq n t (Nat.le_of_succ_le_succ h))

theorem keep_of_length_le {α : Type} : ∀ (n : Nat) (xs : List α), xs.length ≤ n → keep n xs = xs
  | 0, [], _ => rfl
  | 0, _ :: _, h => absurd h (Nat.not_succ_le_zero _)
  | _ + 1, [], _ => rfl
  | n + 1, a :: t, h => by
    show a :: keep n t = a :: t
    rw [keep_of_length_le n t (Nat.le_of_succ_le_succ h)]

theorem keep_keep {α : Type} : ∀ {i n : Nat} (xs : List α), i ≤ n → keep i (keep n xs) = keep i xs
  | 0, _, _, _ => rfl
  | _ + 1, 0, _, h => absurd h (Nat.not_succ_le_zero _)
  | _ + 1, _ + 1, [], _ => rfl
  | i + 1, n + 1, a :: t, h => by
    show a :: keep i (keep n t) = a :: keep i t
    rw [keep_keep t (Nat.le_of_succ_le_succ h)]

theorem keep_cons_keep {α : Type} : ∀ (n : Nat) (a : α) (xs : List α),
    keep n (a :: keep n xs) = keep n (a :: xs)
  | 0, _, _ => rfl
  | n + 1, a, xs => by
    show a :: keep n (keep (n + 1) xs) = a :: keep n xs
    rw [keep_keep xs (Nat.le_succ n)]

theorem keep_append_length {α : Type} : ∀ (l t : List α), keep l.length (l ++ t) = l
  | [], _ => rfl
  | a :: l, t => by
    show a :: keep l.length (l ++ t) = a :: l
    rw [keep_append_length l t]

/-- Every entry of a list of counts satisfies `p`. -/
def Each (p : Nat → Prop) : List Nat → Prop
  | [] => True
  | a :: t => p a ∧ Each p t

theorem each_keep {p : Nat → Prop} : ∀ (n : Nat) {xs : List Nat}, Each p xs → Each p (keep n xs)
  | 0, _, _ => trivial
  | _ + 1, [], _ => trivial
  | n + 1, _ :: t, h => ⟨h.1, each_keep n (xs := t) h.2⟩

theorem sum_le_of_each {b : Nat} : ∀ {n : Nat} {xs : List Nat}, Each (· ≤ b) xs → xs.length ≤ n →
    sumL xs ≤ n * b
  | _, [], _, _ => Nat.zero_le _
  | 0, _ :: _, _, h => absurd h (Nat.not_succ_le_zero _)
  | n + 1, _ :: t, he, h => by
    show _ + sumL t ≤ (n + 1) * b
    rw [Nat.succ_mul, Nat.add_comm]
    exact Nat.add_le_add (sum_le_of_each he.2 (Nat.le_of_succ_le_succ h)) he.1

theorem sum_ge_of_each {b : Nat} : ∀ {xs : List Nat}, Each (b ≤ ·) xs → xs.length * b ≤ sumL xs
  | [], _ => by
    show 0 * b ≤ 0
    rw [Nat.zero_mul]
    exact Nat.le_refl 0
  | a :: t, he => by
    show (t.length + 1) * b ≤ a + sumL t
    rw [Nat.succ_mul, Nat.add_comm]
    exact Nat.add_le_add he.1 (sum_ge_of_each he.2)

theorem after_ge_of_each {b : Nat} : ∀ (l : Nat) {xs : List Nat}, Each (b ≤ ·) xs →
    (xs.length - l) * b ≤ after l xs
  | 0, _, he => sum_ge_of_each he
  | _ + 1, [], _ => by
    show (0 - _) * b ≤ 0
    rw [Nat.zero_sub, Nat.zero_mul]
    exact Nat.le_refl 0
  | l + 1, _ :: t, he => by
    show (t.length + 1 - (l + 1)) * b ≤ after l t
    rw [Nat.succ_sub_succ]
    exact after_ge_of_each l he.2

/-! ## The step -/

theorem step_ends {r : Rule} {x : St} (m : Move) (h : Ends r x) :
    step r m x = ⟨x.quota, 0, [], []⟩ := if_pos h

theorem step_onward {r : Rule} {x : St} (m : Move) (h : ¬ Ends r x) :
    step r m x = onward r m x := if_neg h

theorem not_ends {r : Rule} {x : St} (hL : 1 ≤ x.level) (ht : take x ≤ x.level + r.renewal) :
    ¬ Ends r x := by
  intro h
  cases h with
  | inl h0 => rw [h0] at hL; exact Nat.not_succ_le_zero 0 hL
  | inr hlt => exact Nat.not_lt_of_le ht hlt

theorem gone_ended (q : Nat) : Gone ⟨q, 0, [], []⟩ := ⟨rfl, rfl, rfl⟩

theorem step_gone {r : Rule} {x : St} (m : Move) (h : Ends r x) : Gone (step r m x) := by
  rw [step_ends m h]
  exact gone_ended _

theorem level_onward_kept {r : Rule} {x : St} (m : Move) (h : take x ≤ r.renewal) :
    x.level ≤ (onward r m x).level := le_add_sub x.level h

/-- **The end is closed (L7).** At every source, `gone` is closed under the net: nothing renews
from empty. -/
theorem «尽而不复» (r : Rule) : «闭» (net r) Gone := by
  intro x y hx hy
  obtain ⟨m, rfl⟩ := hy
  exact step_gone m (Or.inl hx.1)

theorem run_gone {r : Rule} {c : Nat → Move} {x : St} (hx : Gone x) (k : Nat) :
    Gone (run r c k x) := by
  induction k with
  | zero => exact hx
  | succ k ih => exact «尽而不复» r _ _ ih ⟨c k, rfl⟩

theorem not_held_of_gone {x : St} (h : Gone x) : ¬ Held x := by
  intro hh
  have h0 : sumL x.holders = 0 := h.2.1
  unfold Held at hh
  rw [h0] at hh
  exact Nat.lt_irrefl 0 hh

/-- Steps add along a course. -/
theorem run_add (r : Rule) (c : Nat → Move) (a x) : ∀ b, run r c (a + b) x =
    run r (fun i => c (a + i)) b (run r c a x)
  | 0 => rfl
  | b + 1 => by
    show step r (c (a + b)) (run r c (a + b) x) =
      step r (c (a + b)) (run r (fun i => c (a + i)) b (run r c a x))
    rw [run_add r c a x b]

/-! ## The constant-take lemma (L1) -/

/-- A family closed under every step of a course that does not end. -/
def Closed (r : Rule) (c : Nat → Move) (F : St → Prop) : Prop :=
  ∀ i y, F y → ¬ Ends r y → F (onward r (c i) y)

/-- **A take within the renewal keeps its family (L1, first part).** A family with a constant take
of at most the renewal, closed under the course's steps: from a level of at least one, every step
keeps the family and the level does not fall. -/
theorem «恒取不逾生则存» {r : Rule} {c : Nat → Move} {F : St → Prop} {A : Nat}
    (hc : Closed r c F) (ht : ∀ y, F y → take y = A) (hA : A ≤ r.renewal) {x : St} (hx : F x)
    (hL : 1 ≤ x.level) : ∀ k, F (run r c k x) ∧ x.level ≤ (run r c k x).level
  | 0 => ⟨hx, Nat.le_refl _⟩
  | k + 1 => by
    obtain ⟨hF, hle⟩ := «恒取不逾生则存» hc ht hA hx hL k
    have htk : take (run r c k x) ≤ r.renewal := by rw [ht _ hF]; exact hA
    have hne : ¬ Ends r (run r c k x) :=
      not_ends (Nat.le_trans hL hle) (Nat.le_trans htk (Nat.le_add_left _ _))
    show F (step r (c k) (run r c k x)) ∧ x.level ≤ (step r (c k) (run r c k x)).level
    rw [step_onward _ hne]
    exact ⟨hc k _ hF hne, Nat.le_trans hle (level_onward_kept _ htk)⟩

/-- **A take over the renewal spends the level by its excess (L1, second part).** A family with a
constant take of `g + d`: from the level `r₀ + k · d`, after `i` steps with `i + m = k` the family
is kept and the level is `r₀ + m · d`. -/
theorem «恒取逾生则减» {r : Rule} {c : Nat → Move} {F : St → Prop} {d : Nat}
    (hc : Closed r c F) (ht : ∀ y, F y → take y = r.renewal + d) (hd : 1 ≤ d) {x : St} (hx : F x)
    {r₀ k : Nat} (hL : x.level = r₀ + k * d) :
    ∀ i m, i + m = k → F (run r c i x) ∧ (run r c i x).level = r₀ + m * d
  | 0, m, h => by
    have hm : m = k := (Nat.zero_add m).symm.trans h
    rw [hm]
    exact ⟨hx, hL⟩
  | i + 1, m, h => by
    have h' : i + (m + 1) = k := by rw [← h, Nat.add_right_comm, Nat.add_assoc]
    obtain ⟨hF, hl⟩ := «恒取逾生则减» hc ht hd hx hL i (m + 1) h'
    have hsplit : (run r c i x).level = (r₀ + m * d) + d := by
      rw [hl, Nat.succ_mul, Nat.add_assoc]
    have hne : ¬ Ends r (run r c i x) := by
      apply not_ends
      · rw [hsplit]
        exact Nat.le_trans hd (Nat.le_add_left _ _)
      · rw [ht _ hF, hsplit, Nat.add_comm r.renewal d, Nat.add_assoc]
        exact Nat.le_add_left _ _
    show F (step r (c i) (run r c i x)) ∧ (step r (c i) (run r c i x)).level = r₀ + m * d
    rw [step_onward _ hne]
    refine ⟨hc i _ hF hne, ?_⟩
    show (run r c i x).level + r.renewal - take (run r c i x) = r₀ + m * d
    rw [ht _ hF, hsplit, Nat.add_comm r.renewal d]
    rw [Nat.add_assoc]
    exact add_sub_cancel' _ _

/-- **A take over the renewal ends the level (L1, third part).** A family with a constant take of
`g + d`, closed under the course's steps: from any level, every step up to some `k` keeps the
family, and the next one is the end. -/
theorem «恒取逾生则尽» {r : Rule} {c : Nat → Move} {F : St → Prop} {d : Nat}
    (hc : Closed r c F) (ht : ∀ y, F y → take y = r.renewal + d) (hd : 1 ≤ d) {x : St} (hx : F x) :
    ∃ k, Gone (run r c (k + 1) x) ∧ ∀ i, i ≤ k → F (run r c i x) := by
  obtain ⟨r₀, k, hL, hr⟩ := exists_div hd x.level
  refine ⟨k, ?_, ?_⟩
  · have hlast := «恒取逾生则减» hc ht hd hx hL k 0 (Nat.add_zero k)
    obtain ⟨hF, hl⟩ := hlast
    have hl' : (run r c k x).level = r₀ := by
      rw [hl, Nat.zero_mul, Nat.add_zero]
    refine step_gone _ (Or.inr ?_)
    rw [hl', ht _ hF, Nat.add_comm]
    exact Nat.add_lt_add_left hr _
  · intro i hi
    obtain ⟨m, e⟩ := exists_of_le hi
    exact («恒取逾生则减» hc ht hd hx hL i m e.symm).1

/-! ## Passing: the drain, and no holder from no holder (L5, L6) -/

/-- The first `i` cohorts of a list are empty. -/
def ZeroUpTo : Nat → List Nat → Prop
  | 0, _ => True
  | _ + 1, [] => True
  | i + 1, a :: t => a = 0 ∧ ZeroUpTo i t

theorem zeroUpTo_nil : ∀ i, ZeroUpTo i []
  | 0 => trivial
  | _ + 1 => trivial

theorem zeroUpTo_keep : ∀ (i n : Nat) {xs : List Nat}, ZeroUpTo i xs → ZeroUpTo i (keep n xs)
  | 0, _, _, _ => trivial
  | _ + 1, 0, _, _ => trivial
  | _ + 1, _ + 1, [], _ => trivial
  | i + 1, n + 1, _ :: t, h => ⟨h.1, zeroUpTo_keep i n (xs := t) h.2⟩

theorem zeroUpTo_step (i n : Nat) {xs : List Nat} (h : ZeroUpTo i xs) :
    ZeroUpTo (i + 1) (keep n (0 :: xs)) := by
  cases n with
  | zero => trivial
  | succ n => exact ⟨rfl, zeroUpTo_keep i n h⟩

theorem sum_zero_of_zeroUpTo : ∀ (k : Nat) {xs : List Nat}, ZeroUpTo k xs → xs.length ≤ k →
    sumL xs = 0
  | _, [], _, _ => rfl
  | 0, _ :: _, _, h => absurd h (Nat.not_succ_le_zero _)
  | k + 1, a :: t, hz, h => by
    show a + sumL t = 0
    rw [hz.1, sum_zero_of_zeroUpTo k (xs := t) hz.2 (Nat.le_of_succ_le_succ h)]

theorem entrant_of_teachers_zero {r : Rule} {x : St} (hs : r.source = .members)
    (hT : teachers r x = 0) (on : Bool) : entrant r on x = 0 := by
  cases on with
  | false => rfl
  | true =>
    show taught r.source x.quota (teachers r x) = 0
    rw [hs, hT]
    rfl

theorem entrant_of_quota_zero {r : Rule} {x : St} (hs : r.source = .members)
    (hq : x.quota = 0) (on : Bool) : entrant r on x = 0 := by
  cases on with
  | false => rfl
  | true =>
    show taught r.source x.quota (teachers r x) = 0
    rw [hs, hq]
    cases teachers r x <;> rfl

theorem entrant_no_holder {r : Rule} {x : St} (hs : r.source = .members ∨ r.source = .none)
    (hx : NoHolder x) (on : Bool) : entrant r on x = 0 := by
  cases hs with
  | inl hm => exact entrant_of_teachers_zero hm (after_zero_of_sum hx) on
  | inr hn =>
    cases on with
    | false => rfl
    | true =>
      show taught r.source x.quota (teachers r x) = 0
      rw [hn]
      rfl

theorem length_holders_step {r : Rule} (m : Move) (x : St) :
    (step r m x).holders.length ≤ r.tenure := by
  by_cases h : Ends r x
  · rw [step_ends m h]
    exact Nat.zero_le _
  · rw [step_onward m h]
    exact length_keep_le _ _

theorem length_others_step {r : Rule} (m : Move) (x : St) :
    (step r m x).others.length ≤ r.tenure := by
  by_cases h : Ends r x
  · rw [step_ends m h]
    exact Nat.zero_le _
  · rw [step_onward m h]
    exact length_keep_le _ _

/-- An invariant under which no holder enters empties the list in a tenure. -/
theorem drain_of {r : Rule} {c : Nat → Move} {x : St} (inv : St → Prop)
    (hinv : ∀ i y, inv y → inv (step r (c i) y))
    (hent : ∀ i y, inv y → ¬ Ends r y → entrant r (c i).on y = 0)
    (hlen : ∀ y, inv y → y.holders.length ≤ r.tenure) (h0 : inv x) :
    ∀ k, r.tenure ≤ k → sumL (run r c k x).holders = 0 := by
  have key : ∀ i, inv (run r c i x) ∧ ZeroUpTo i (run r c i x).holders := by
    intro i
    induction i with
    | zero => exact ⟨h0, trivial⟩
    | succ i ih =>
      refine ⟨hinv i _ ih.1, ?_⟩
      show ZeroUpTo (i + 1) (step r (c i) (run r c i x)).holders
      by_cases h : Ends r (run r c i x)
      · rw [step_ends _ h]
        exact zeroUpTo_nil _
      · rw [step_onward _ h]
        show ZeroUpTo (i + 1) (keep r.tenure (entrant r (c i).on (run r c i x) :: _))
        rw [hent i _ ih.1 h]
        exact zeroUpTo_step i _ ih.2
  intro k hk
  exact sum_zero_of_zeroUpTo k (key k).2 (Nat.le_trans (hlen _ (key k).1) hk)

/-- **Teaching that does not fit a tenure drains (L5).** `.members`, holders of at most `s` cohorts:
where `s ≤ l`, no holder is left after `s` steps, on or off, under any revision, from every level. -/
theorem «不及任则持尽» {r : Rule} (hs : r.source = .members) (hsl : r.tenure ≤ r.teachingAge)
    (c : Nat → Move) {x : St} (hlen : x.holders.length ≤ r.tenure) :
    ∀ k, r.tenure ≤ k → sumL (run r c k x).holders = 0 :=
  drain_of (fun y => y.holders.length ≤ r.tenure) (fun _ _ _ => length_holders_step _ _)
    (fun _ _ hy _ => entrant_of_teachers_zero hs (after_short (Nat.le_trans hy hsl)) _)
    (fun _ hy => hy) hlen

theorem reviseHeld_zero {rev : Option Nat} (h : ∀ v, rev = Option.some v → v = 0) (n : Nat) :
    reviseHeld n 0 rev = 0 := by
  cases n with
  | zero => rfl
  | succ n =>
    cases rev with
    | none => rfl
    | some v => exact h v rfl

/-- **A quota of nothing drains (L5).** `.members`, holders of at most `s` cohorts, no revision to a
nonzero quota: where the quota is `0`, no holder is left after `s` steps, on or off, from every
level. -/
theorem «额零则持尽» {r : Rule} (hs : r.source = .members) {c : Nat → Move}
    (hrev : ∀ i v, (c i).rev = Option.some v → v = 0) {x : St} (hq : x.quota = 0)
    (hlen : x.holders.length ≤ r.tenure) :
    ∀ k, r.tenure ≤ k → sumL (run r c k x).holders = 0 := by
  refine drain_of (fun y => y.holders.length ≤ r.tenure ∧ y.quota = 0) ?_
    (fun _ _ hy _ => entrant_of_quota_zero hs hy.2 _) (fun _ hy => hy.1) ⟨hlen, hq⟩
  intro i y hy
  refine ⟨length_holders_step _ _, ?_⟩
  by_cases h : Ends r y
  · rw [step_ends _ h]
    exact hy.2
  · rw [step_onward _ h]
    show revised r (c i).rev y = 0
    unfold revised
    rw [hs]
    show reviseHeld (sumL y.holders) y.quota (c i).rev = 0
    rw [hy.2]
    exact reviseHeld_zero (hrev i) _

/-- **No holder from no holder (L6).** Where the rule is taught only by members, or not at all, no
holder stays no holder under the whole net. -/
theorem «无持者不复» {r : Rule} (hs : r.source = .members ∨ r.source = .none) :
    «闭» (net r) NoHolder := by
  intro x y hx hy
  obtain ⟨m, rfl⟩ := hy
  by_cases h : Ends r x
  · rw [step_ends m h]
    rfl
  · rw [step_onward m h]
    show sumL (keep r.tenure (entrant r m.on x :: x.holders)) = 0
    rw [entrant_no_holder hs hx]
    have h1 : sumL (0 :: x.holders) = 0 := by
      show 0 + sumL x.holders = 0
      rw [show sumL x.holders = 0 from hx]
    have h2 := sum_keep_le r.tenure (0 :: x.holders)
    rw [h1] at h2
    exact Nat.le_antisymm h2 (Nat.zero_le _)

theorem run_no_holder {r : Rule} (hs : r.source = .members ∨ r.source = .none) (c : Nat → Move)
    {x : St} (hx : NoHolder x) : ∀ k, NoHolder (run r c k x)
  | 0 => hx
  | k + 1 => «无持者不复» hs _ _ (run_no_holder hs c hx k) ⟨c k, rfl⟩

theorem revised_no_holder {r : Rule} {x : St} (hx : NoHolder x) (rev : Option Nat) :
    revised r rev x = x.quota := by
  have h0 : sumL x.holders = 0 := hx
  unfold revised
  cases r.source with
  | members =>
    show reviseHeld (sumL x.holders) x.quota rev = x.quota
    rw [h0]
    rfl
  | outside => rfl
  | none =>
    show reviseHeld (sumL x.holders) x.quota rev = x.quota
    rw [h0]
    rfl

/-- **A revision without a holder does not take (L6, L10).** So a rule can be restored only while a
holder stands. -/
theorem «无持者改不行» {r : Rule} {x : St} (hx : NoHolder x) (m : Move) :
    (step r m x).quota = x.quota := by
  by_cases h : Ends r x
  · rw [step_ends m h]
  · rw [step_onward m h]
    exact revised_no_holder hx m.rev

/-- A step reads the same of two states with the same level and lists, where neither holds. -/
theorem step_same_fields {r : Rule} (hs : r.source = .members ∨ r.source = .none) (m : Move)
    {x y : St} (hl : x.level = y.level) (hh : x.holders = y.holders) (ho : x.others = y.others)
    (hx : NoHolder x) :
    (step r m x).level = (step r m y).level ∧ (step r m x).holders = (step r m y).holders ∧
      (step r m x).others = (step r m y).others := by
  obtain ⟨q, L, h, o⟩ := x
  obtain ⟨q', L', h', o'⟩ := y
  have e1 : L = L' := hl
  have e2 : h = h' := hh
  have e3 : o = o' := ho
  subst e1 e2 e3
  have hy : NoHolder ⟨q', L, h, o⟩ := hx
  by_cases he : Ends r ⟨q, L, h, o⟩
  · have he' : Ends r ⟨q', L, h, o⟩ := he
    rw [step_ends m he, step_ends m he']
    exact ⟨rfl, rfl, rfl⟩
  · have he' : ¬ Ends r ⟨q', L, h, o⟩ := he
    rw [step_onward m he, step_onward m he']
    refine ⟨rfl, ?_, ?_⟩
    · show keep r.tenure (entrant r m.on ⟨q, L, h, o⟩ :: h) =
        keep r.tenure (entrant r m.on ⟨q', L, h, o⟩ :: h)
      rw [entrant_no_holder hs hx, entrant_no_holder hs hy]
    · show keep r.tenure (door r m.on ⟨q, L, h, o⟩ :: o) =
        keep r.tenure (door r m.on ⟨q', L, h, o⟩ :: o)
      cases m.on <;> rfl

/-- **A dead letter (L6).** Two states of no holder that differ only in quota have the same later
levels and members, along every course. The quota then is read by nothing. -/
theorem «无持者额不与» {r : Rule} (hs : r.source = .members ∨ r.source = .none) (c : Nat → Move)
    {x y : St} (hl : x.level = y.level) (hh : x.holders = y.holders) (ho : x.others = y.others)
    (hx : NoHolder x) : ∀ k, (run r c k x).level = (run r c k y).level ∧
      (run r c k x).holders = (run r c k y).holders ∧ (run r c k x).others = (run r c k y).others
  | 0 => ⟨hl, hh, ho⟩
  | k + 1 => by
    obtain ⟨h1, h2, h3⟩ := «无持者额不与» hs c hl hh ho hx k
    exact step_same_fields hs (c k) h1 h2 h3 (run_no_holder hs c hx k)

/-! ## The steady state and the band (L2) -/

theorem taught_members_pos (q : Nat) {T : Nat} (h : 0 < T) : taught .members q T = q := by
  cases T with
  | zero => exact absurd h (Nat.lt_irrefl 0)
  | succ T => rfl

theorem revised_none {r : Rule} (x : St) : revised r Option.none x = x.quota := by
  unfold revised
  cases r.source with
  | members =>
    show reviseHeld (sumL x.holders) x.quota Option.none = x.quota
    cases sumL x.holders <;> rfl
  | outside => rfl
  | none =>
    show reviseHeld (sumL x.holders) x.quota Option.none = x.quota
    cases sumL x.holders <;> rfl

theorem take_steady (r : Rule) (q L : Nat) :
    take (steady r q L) = (q + leak r q) * r.tenure := by
  show sumL (List.replicate r.tenure q) + sumL (List.replicate r.tenure (leak r q)) = _
  rw [sumL_replicate, sumL_replicate, right_distrib', Nat.mul_comm r.tenure q,
    Nat.mul_comm r.tenure (leak r q)]

theorem teachers_mul (c q n : Nat) : c * (n * q) = c * q * n := by
  rw [Nat.mul_comm n q, mul_assoc']

theorem onward_steady {r : Rule} (hsrc : r.source = .members ∨ r.source = .outside)
    (hl : r.teachingAge < r.tenure) {q : Nat} (hq : 1 ≤ q) (L : Nat) :
    onward r ⟨true, Option.none⟩ (steady r q L) =
      steady r q (L + r.renewal - take (steady r q L)) := by
  have hT : teachers r (steady r q L) = (r.tenure - r.teachingAge) * q := after_replicate _ _ _
  have hpos : 0 < teachers r (steady r q L) := by
    rw [hT]
    exact Nat.mul_pos (sub_pos' hl) hq
  have hE : entrant r true (steady r q L) = q := by
    show taught r.source q (teachers r (steady r q L)) = q
    cases hsrc with
    | inl hm =>
      rw [hm]
      exact taught_members_pos q hpos
    | inr ho =>
      rw [ho]
      rfl
  have hD : door r true (steady r q L) = leak r q := by
    show r.untaught - r.strength * teachers r (steady r q L) = leak r q
    rw [hT, teachers_mul]
    rfl
  have hR : revised r Option.none (steady r q L) = q := revised_none _
  show (⟨revised r Option.none (steady r q L), L + r.renewal - take (steady r q L),
      keep r.tenure (entrant r true (steady r q L) :: List.replicate r.tenure q),
      keep r.tenure (door r true (steady r q L) :: List.replicate r.tenure (leak r q))⟩ : St) =
    ⟨q, L + r.renewal - take (steady r q L), List.replicate r.tenure q,
      List.replicate r.tenure (leak r q)⟩
  rw [hR, hE, hD, keep_cons_replicate, keep_cons_replicate]

/-- The steady states at a quota. -/
def Steady (r : Rule) (q : Nat) (y : St) : Prop := ∃ L, y = steady r q L

theorem steady_closed {r : Rule} (hsrc : r.source = .members ∨ r.source = .outside)
    (hl : r.teachingAge < r.tenure) {q : Nat} (hq : 1 ≤ q) : Closed r always (Steady r q) := by
  intro _ y hy _
  obtain ⟨L, rfl⟩ := hy
  exact ⟨_, onward_steady hsrc hl hq L⟩

theorem steady_take {r : Rule} {q : Nat} :
    ∀ y, Steady r q y → take y = (q + leak r q) * r.tenure := by
  intro y hy
  obtain ⟨L, rfl⟩ := hy
  exact take_steady r q L

theorem held_steady {r : Rule} (hl : r.teachingAge < r.tenure) {q : Nat} (hq : 1 ≤ q) (L : Nat) :
    Held (steady r q L) := by
  show 0 < sumL (List.replicate r.tenure q)
  rw [sumL_replicate]
  exact Nat.mul_pos (Nat.lt_of_le_of_lt (Nat.zero_le _) hl) hq

theorem excess {g A : Nat} (h : g < A) : ∃ d, A = g + d ∧ 1 ≤ d := by
  obtain ⟨k, e⟩ := exists_of_le h
  refine ⟨k + 1, ?_, Nat.succ_le_succ (Nat.zero_le k)⟩
  rw [e]
  show g + 1 + k = g + (k + 1)
  rw [Nat.add_assoc, Nat.add_comm 1 k]

theorem steady_kept {r : Rule} (hsrc : r.source = .members ∨ r.source = .outside)
    (hl : r.teachingAge < r.tenure) {q : Nat} (hq : 1 ≤ q)
    (hA : (q + leak r q) * r.tenure ≤ r.renewal) {L : Nat} (hL : 1 ≤ L) (k : Nat) :
    Steady r q (run r always k (steady r q L)) ∧ L ≤ (run r always k (steady r q L)).level :=
  «恒取不逾生则存» (steady_closed hsrc hl hq) steady_take hA ⟨L, rfl⟩ hL k

theorem steady_ends {r : Rule} (hsrc : r.source = .members ∨ r.source = .outside)
    (hl : r.teachingAge < r.tenure) {q : Nat} (hq : 1 ≤ q)
    (hA : r.renewal < (q + leak r q) * r.tenure) (L : Nat) :
    ∃ k, Gone (run r always (k + 1) (steady r q L)) ∧
      ∀ i, i ≤ k → Held (run r always i (steady r q L)) := by
  obtain ⟨d, e, hd⟩ := excess hA
  obtain ⟨k, hg, hF⟩ := «恒取逾生则尽» (steady_closed hsrc hl hq)
    (fun y hy => (steady_take y hy).trans e) hd (x := steady r q L) ⟨L, rfl⟩
  refine ⟨k, hg, fun i hi => ?_⟩
  obtain ⟨L', e'⟩ := hF i hi
  rw [e']
  exact held_steady hl hq L'

theorem one_le_of_held_steady {r : Rule} {q L : Nat} (h : Held (steady r q L)) : 1 ≤ q := by
  cases q with
  | zero =>
    have h' : 0 < sumL (List.replicate r.tenure 0) := h
    rw [sumL_replicate, Nat.mul_zero] at h'
    exact absurd h' (Nat.lt_irrefl 0)
  | succ q => exact Nat.succ_le_succ (Nat.zero_le q)

/-- **The band (L2, the central law).** `.members`, entrants on offer at every step, no revision,
from a level of at least one: from `steady q L` the rule is held at every step exactly where
`l < s`, `1 ≤ q` and `(q + e q) · s ≤ g`. This is the steady state's law, not the rule's: L13 is
where a state with empty cohorts differs. -/
theorem «稳者恒持当且仅当在带» {r : Rule} (hm : r.source = .members) {q L : Nat} (hL : 1 ≤ L) :
    (∀ k, Held (run r always k (steady r q L))) ↔ Band r q := by
  constructor
  · intro h
    have hq : 1 ≤ q := one_le_of_held_steady (h 0)
    have hl : r.teachingAge < r.tenure := by
      apply Nat.lt_of_not_le
      intro hsl
      have hlen : (steady r q L).holders.length ≤ r.tenure :=
        Nat.le_of_eq (length_replicate' _ _)
      have h0 := «不及任则持尽» hm hsl always hlen r.tenure (Nat.le_refl _)
      have hh : 0 < sumL (run r always r.tenure (steady r q L)).holders := h r.tenure
      rw [h0] at hh
      exact Nat.lt_irrefl 0 hh
    refine ⟨hl, hq, ?_⟩
    apply Nat.le_of_not_lt
    intro hA
    obtain ⟨k, hg, _⟩ := steady_ends (Or.inl hm) hl hq hA L
    exact not_held_of_gone hg (h (k + 1))
  · intro hb k
    obtain ⟨L', e⟩ := (steady_kept (Or.inl hm) hb.1 hb.2.1 hb.2.2 hL k).1
    rw [e]
    exact held_steady hb.1 hb.2.1 L'

/-- **The steady state's law holds alike taught from outside (L2).** Wherever `l < s`. -/
theorem «外授之稳同带» {r : Rule} (ho : r.source = .outside) (hl : r.teachingAge < r.tenure)
    {q L : Nat} (hL : 1 ≤ L) :
    (∀ k, Held (run r always k (steady r q L))) ↔ Band r q := by
  constructor
  · intro h
    have hq : 1 ≤ q := one_le_of_held_steady (h 0)
    refine ⟨hl, hq, ?_⟩
    apply Nat.le_of_not_lt
    intro hA
    obtain ⟨k, hg, _⟩ := steady_ends (Or.inr ho) hl hq hA L
    exact not_held_of_gone hg (h (k + 1))
  · intro hb k
    obtain ⟨L', e⟩ := (steady_kept (Or.inr ho) hb.1 hb.2.1 hb.2.2 hL k).1
    rw [e]
    exact held_steady hb.1 hb.2.1 L'

/-! ## The band in closed form (L3) -/

theorem band_closed (f q t s g : Nat) :
    (q + (f - t)) * s ≤ g ↔ q * s ≤ g ∧ (f + q) * s ≤ g + t * s := by
  cases Nat.le_total t f with
  | inl htf =>
    obtain ⟨k, e⟩ := exists_of_le htf
    have hk : f - t = k := by
      rw [e, Nat.add_comm]
      exact add_sub_cancel' k t
    have hsum : (f + q) * s = (q + k) * s + t * s := by
      rw [e, ← right_distrib']
      have : t + k + q = q + k + t := by
        rw [Nat.add_comm t k, Nat.add_comm (k + t) q, Nat.add_assoc]
      rw [this]
    rw [hk, hsum]
    constructor
    · intro h
      exact ⟨Nat.le_trans (Nat.mul_le_mul_right s (Nat.le_add_right q k)) h,
        Nat.add_le_add_right h _⟩
    · intro h
      exact le_of_add_le_add_right' _ h.2
  | inr hft =>
    rw [sub_eq_zero_of_le' hft]
    constructor
    · intro h
      refine ⟨h, ?_⟩
      have h1 : (f + q) * s ≤ (q + 0) * s + t * s := by
        rw [← right_distrib']
        apply Nat.mul_le_mul_right
        show f + q ≤ q + t
        rw [Nat.add_comm f q]
        exact Nat.add_le_add_left hft q
      exact Nat.le_trans h1 (Nat.add_le_add_right h _)
    · intro h
      exact h.1

theorem leak_eq (r : Rule) (q : Nat) :
    leak r q = r.untaught - r.strength * (r.tenure - r.teachingAge) * q := by
  unfold leak
  rw [mul_assoc' r.strength q, mul_assoc' r.strength (r.tenure - r.teachingAge),
    Nat.mul_comm q]

/-- **The band's take without its truncation (L3).** With `C := c · (s − l)`: `(q + e q) · s ≤ g`
exactly where `q · s ≤ g` and `(f + q) · s ≤ g + C · q · s`. `q` stays on both sides: the interval of
quotas it solves to is not stated. -/
theorem «带之二式» (r : Rule) (q : Nat) :
    (q + leak r q) * r.tenure ≤ r.renewal ↔
      q * r.tenure ≤ r.renewal ∧
        (r.untaught + q) * r.tenure ≤
          r.renewal + r.strength * (r.tenure - r.teachingAge) * q * r.tenure := by
  rw [leak_eq]
  exact band_closed _ _ _ _ _

theorem add_sub_mono (f : Nat) : ∀ {a b : Nat}, a ≤ b → a + (f - a) ≤ b + (f - b) := by
  intro a b h
  cases Nat.le_total b f with
  | inl hbf =>
    obtain ⟨k, e⟩ := exists_of_le hbf
    obtain ⟨j, e'⟩ := exists_of_le h
    have h1 : f - b = k := by
      rw [e, Nat.add_comm]
      exact add_sub_cancel' k b
    have h2 : f - a = j + k := by
      rw [e, e', Nat.add_assoc, Nat.add_comm a]
      exact add_sub_cancel' (j + k) a
    rw [h1, h2, e', Nat.add_assoc]
    exact Nat.le_refl _
  | inr hfb =>
    rw [sub_eq_zero_of_le' hfb]
    cases Nat.le_total a f with
    | inl haf =>
      obtain ⟨k, e⟩ := exists_of_le haf
      have h1 : f - a = k := by
        rw [e, Nat.add_comm]
        exact add_sub_cancel' k a
      rw [h1, ← e]
      exact hfb
    | inr hfa =>
      rw [sub_eq_zero_of_le' hfa]
      exact h

/-- **A quota can be too small only where a keeper turns away more than itself (L3).** At
`C ≤ 1`, every quota of at least one below one in the band is in the band. -/
theorem «额小而不足者门必过一» {r : Rule} {q p : Nat} (hC : r.strength * (r.tenure - r.teachingAge) ≤ 1)
    (hp : 1 ≤ p) (hpq : p ≤ q) (hb : Band r q) : Band r p := by
  refine ⟨hb.1, hp, Nat.le_trans (Nat.mul_le_mul_right _ ?_) hb.2.2⟩
  rw [leak_eq, leak_eq]
  generalize r.strength * (r.tenure - r.teachingAge) = C at hC
  match C, hC with
  | 0, _ =>
    rw [Nat.zero_mul, Nat.zero_mul]
    exact Nat.add_le_add_right hpq _
  | 1, _ =>
    rw [Nat.one_mul, Nat.one_mul]
    exact add_sub_mono _ hpq
  | n + 2, h => exact absurd (Nat.le_of_succ_le_succ h) (Nat.not_succ_le_zero n)

/-- The rule of L3's first witness. -/
def rA : Rule := ⟨1, 0, 2, 4, 2, .members⟩

/-- The rule of L3's second witness. -/
def rB : Rule := ⟨4, 2, 20, 6, 1, .members⟩

/-- The rule of L3's third witness. -/
def rC : Rule := ⟨4, 3, 20, 6, 1, .members⟩

/-- A rule with room for its steady state and for open entry. -/
def rF : Rule := ⟨2, 1, 10, 2, 1, .members⟩

theorem band_bound {r : Rule} {q : Nat} (h : Band r q) : q * r.tenure ≤ r.renewal :=
  ((«带之二式» r q).mp h.2.2).1

/-- **Only one quota (L3's witness).** At `s, l, g, f, c = 1, 0, 2, 4, 2` the band is `q = 2`: a
quota of one is too small, and a keeper here turns away more than itself. -/
theorem «带唯二» : ∀ q, Band rA q ↔ q = 2 := by
  have low : ∀ q, q < 3 → (Band rA q ↔ q = 2) := by decide
  intro q
  cases Nat.lt_or_ge q 3 with
  | inl h => exact low q h
  | inr h =>
    constructor
    · intro hb
      have h1 : q * 1 ≤ 2 := band_bound hb
      rw [Nat.mul_one] at h1
      exact absurd (Nat.le_trans h h1) (by decide)
    · intro e
      rw [e] at h
      exact absurd h (by decide)

/-- **A range (L3's witness).** At `4, 2, 20, 6, 1` the band is `1 ≤ q ≤ 5`. -/
theorem «带一至五» : ∀ q, Band rB q ↔ 1 ≤ q ∧ q ≤ 5 := by
  have low : ∀ q, q < 6 → (Band rB q ↔ 1 ≤ q ∧ q ≤ 5) := by decide
  intro q
  cases Nat.lt_or_ge q 6 with
  | inl h => exact low q h
  | inr h =>
    constructor
    · intro hb
      have h1 : q * 4 ≤ 20 := band_bound hb
      exact absurd (Nat.le_trans (Nat.mul_le_mul_right 4 h) h1) (by decide)
    · intro e
      exact absurd (Nat.le_trans h e.2) (by decide)

/-- **No quota (L3's witness).** At `4, 3, 20, 6, 1` the band is empty, though `l < s`. -/
theorem «带无» : rC.teachingAge < rC.tenure ∧ ∀ q, ¬ Band rC q := by
  have low : ∀ q, q < 6 → ¬ Band rC q := by decide
  refine ⟨by decide, fun q => ?_⟩
  cases Nat.lt_or_ge q 6 with
  | inl h => exact low q h
  | inr h =>
    intro hb
    have h1 : q * 4 ≤ 20 := band_bound hb
    exact absurd (Nat.le_trans (Nat.mul_le_mul_right 4 h) h1) (by decide)

/-! ## The region (L4) -/

/-- `s` holder cohorts each in `[P, Q]`, at most `s` other cohorts each at most the leak at `P`, the
quota in `[P, Q]`, a level of at least one. -/
def Within (r : Rule) (P Q : Nat) (x : St) : Prop :=
  x.holders.length = r.tenure ∧ Each (fun a => P ≤ a ∧ a ≤ Q) x.holders ∧
    x.others.length ≤ r.tenure ∧ Each (· ≤ leak r P) x.others ∧
      P ≤ x.quota ∧ x.quota ≤ Q ∧ 1 ≤ x.level

/-- A revision, if any, is in `[P, Q]`. -/
def RevIn (P Q : Nat) (rev : Option Nat) : Prop := ∀ v, rev = Option.some v → P ≤ v ∧ v ≤ Q

/-- What the region needs of the rule. -/
abbrev Fits (r : Rule) (P Q : Nat) : Prop :=
  r.source = .members ∧ r.teachingAge < r.tenure ∧ 1 ≤ P ∧ P ≤ Q ∧
    (Q + leak r P) * r.tenure ≤ r.renewal

/-- The steps with entrants on offer and a revision in `[P, Q]`. -/
def onIn (r : Rule) (P Q : Nat) : «际» St :=
  fun x y => ∃ rev, RevIn P Q rev ∧ y = step r ⟨true, rev⟩ x

theorem each_weaken {p p' : Nat → Prop} (h : ∀ a, p a → p' a) :
    ∀ {xs : List Nat}, Each p xs → Each p' xs
  | [], _ => trivial
  | _ :: _, he => ⟨h _ he.1, each_weaken h he.2⟩

theorem each_replicate {p : Nat → Prop} {a : Nat} (h : p a) : ∀ n, Each p (List.replicate n a)
  | 0 => trivial
  | n + 1 => ⟨h, each_replicate h n⟩

theorem within_take {r : Rule} {P Q : Nat} {x : St} (hw : Within r P Q x) :
    take x ≤ (Q + leak r P) * r.tenure := by
  have h1 : sumL x.holders ≤ r.tenure * Q :=
    sum_le_of_each (each_weaken (fun _ h => h.2) hw.2.1) (Nat.le_of_eq hw.1)
  have h2 : sumL x.others ≤ r.tenure * leak r P := sum_le_of_each hw.2.2.2.1 hw.2.2.1
  rw [right_distrib', Nat.mul_comm Q, Nat.mul_comm (leak r P)]
  exact Nat.add_le_add h1 h2

theorem within_teachers {r : Rule} {P Q : Nat} {x : St} (hw : Within r P Q x) :
    (r.tenure - r.teachingAge) * P ≤ teachers r x := by
  have h := after_ge_of_each r.teachingAge (b := P) (xs := x.holders)
    (each_weaken (fun _ h => h.1) hw.2.1)
  rw [hw.1] at h
  exact h

theorem within_not_ends {r : Rule} {P Q : Nat} {x : St} (hf : Fits r P Q) (hw : Within r P Q x) :
    ¬ Ends r x :=
  not_ends hw.2.2.2.2.2.2
    (Nat.le_trans (Nat.le_trans (within_take hw) hf.2.2.2.2) (Nat.le_add_left _ _))

theorem within_entrant {r : Rule} {P Q : Nat} {x : St} (hf : Fits r P Q) (hw : Within r P Q x) :
    entrant r true x = x.quota := by
  show taught r.source x.quota (teachers r x) = x.quota
  rw [hf.1]
  exact taught_members_pos _
    (Nat.lt_of_lt_of_le (Nat.mul_pos (sub_pos' hf.2.1) hf.2.2.1) (within_teachers hw))

theorem within_door {r : Rule} {P Q : Nat} {x : St} (hw : Within r P Q x) :
    door r true x ≤ leak r P := by
  show r.untaught - r.strength * teachers r x ≤ r.untaught - r.strength * P * (r.tenure - r.teachingAge)
  apply sub_le_sub_left'
  rw [← teachers_mul]
  exact Nat.mul_le_mul_left _ (within_teachers hw)

theorem reviseHeld_in {P Q q : Nat} {rev : Option Nat} (h1 : P ≤ q) (h2 : q ≤ Q) (hr : RevIn P Q rev) :
    ∀ n, P ≤ reviseHeld n q rev ∧ reviseHeld n q rev ≤ Q
  | 0 => ⟨h1, h2⟩
  | _ + 1 => by
    cases rev with
    | none => exact ⟨h1, h2⟩
    | some v => exact hr v rfl

theorem within_step {r : Rule} {P Q : Nat} {x : St} (hf : Fits r P Q) (hw : Within r P Q x)
    {m : Move} (hon : m.on = true) (hrev : RevIn P Q m.rev) :
    Within r P Q (step r m x) ∧ x.level ≤ (step r m x).level := by
  have hne := within_not_ends hf hw
  have htk : take x ≤ r.renewal := Nat.le_trans (within_take hw) hf.2.2.2.2
  have hup : x.level ≤ (onward r m x).level := level_onward_kept m htk
  have hE : entrant r m.on x = x.quota := by
    rw [hon]
    exact within_entrant hf hw
  have hD : door r m.on x ≤ leak r P := by
    rw [hon]
    exact within_door hw
  have hq : P ≤ revised r m.rev x ∧ revised r m.rev x ≤ Q := by
    unfold revised
    rw [hf.1]
    exact reviseHeld_in hw.2.2.2.2.1 hw.2.2.2.2.2.1 hrev _
  rw [step_onward m hne]
  refine ⟨⟨?_, ?_, length_keep_le _ _, ?_, hq.1, hq.2, Nat.le_trans hw.2.2.2.2.2.2 hup⟩, hup⟩
  · apply length_keep_eq
    show r.tenure ≤ x.holders.length + 1
    rw [hw.1]
    exact Nat.le_succ _
  · apply each_keep
    show (P ≤ entrant r m.on x ∧ entrant r m.on x ≤ Q) ∧ Each _ x.holders
    rw [hE]
    exact ⟨⟨hw.2.2.2.2.1, hw.2.2.2.2.2.1⟩, hw.2.1⟩
  · apply each_keep
    exact ⟨hD, hw.2.2.2.1⟩

/-- **The region (L4).** `.members`, `l < s`, `1 ≤ P ≤ Q`, `(Q + E) · s ≤ g` with `E` the leak at
`P`: the region is closed under every step with entrants on offer and a revision in `[P, Q]`. L2's
steady state is a case of it, and the revision is free inside it. -/
theorem «域闭» {r : Rule} {P Q : Nat} (hf : Fits r P Q) : «闭» (onIn r P Q) (Within r P Q) := by
  intro x y hx hy
  obtain ⟨rev, hrev, rfl⟩ := hy
  exact (within_step hf hx (m := ⟨true, rev⟩) rfl hrev).1

/-- **The level does not fall in the region (L4).** -/
theorem «域中储不减» {r : Rule} {P Q : Nat} (hf : Fits r P Q) {x y : St} (hx : Within r P Q x)
    (hy : onIn r P Q x y) : x.level ≤ y.level := by
  obtain ⟨rev, hrev, rfl⟩ := hy
  exact (within_step hf hx (m := ⟨true, rev⟩) rfl hrev).2

theorem within_held {r : Rule} {P Q : Nat} {x : St} (hf : Fits r P Q) (hw : Within r P Q x) :
    Held x := by
  have h := sum_ge_of_each (b := P) (xs := x.holders) (each_weaken (fun _ h => h.1) hw.2.1)
  rw [hw.1] at h
  exact Nat.lt_of_lt_of_le
    (Nat.mul_pos (Nat.lt_of_le_of_lt (Nat.zero_le _) hf.2.1) hf.2.2.1) h

/-- **The steady state is a case of the region (L4).** -/
theorem «稳为域之例» {r : Rule} (hm : r.source = .members) {q L : Nat} (hb : Band r q) (hL : 1 ≤ L) :
    Fits r q q ∧ Within r q q (steady r q L) :=
  ⟨⟨hm, hb.1, hb.2.1, Nat.le_refl q, hb.2.2⟩,
    length_replicate' _ _, each_replicate ⟨Nat.le_refl q, Nat.le_refl q⟩ _,
    Nat.le_of_eq (length_replicate' _ _), each_replicate (p := (· ≤ leak r q)) (Nat.le_refl _) _,
    Nat.le_refl q, Nat.le_refl q, hL⟩

/-- **A region with room for revision (L4's premise met).** At `4, 2, 20, 6, 1` the quotas from `3` to
`5` make a region. -/
theorem «域可得» : Fits rB 3 5 := ⟨rfl, by decide, by decide, by decide, by decide⟩

/-! ## Open entry after the rule (L8) -/

theorem door_no_holder {r : Rule} {x : St} (hx : NoHolder x) : door r true x = r.untaught := by
  show r.untaught - r.strength * teachers r x = r.untaught
  rw [show teachers r x = 0 from after_zero_of_sum hx, Nat.mul_zero, Nat.sub_zero]

theorem sum_keep_cons_pos {s a : Nat} (xs : List Nat) (hs : 1 ≤ s) (ha : 1 ≤ a) :
    0 < sumL (keep s (a :: xs)) := by
  cases s with
  | zero => exact absurd hs (Nat.not_succ_le_zero 0)
  | succ s =>
    show 0 < a + sumL (keep s xs)
    exact Nat.lt_of_lt_of_le ha (Nat.le_add_right _ _)

theorem open_not_ends {r : Rule} (hA : r.untaught * r.tenure ≤ r.renewal) {y : St} (hy : NoHolder y)
    (hl : y.others.length ≤ r.tenure) (he : Each (· ≤ r.untaught) y.others) (hl1 : 1 ≤ y.level) :
    ¬ Ends r y ∧ take y ≤ r.renewal := by
  have ht : take y ≤ r.renewal := by
    show sumL y.holders + sumL y.others ≤ r.renewal
    rw [show sumL y.holders = 0 from hy, Nat.zero_add]
    have h1 : sumL y.others ≤ r.tenure * r.untaught := sum_le_of_each he hl
    rw [Nat.mul_comm] at h1
    exact Nat.le_trans h1 hA
  exact ⟨not_ends hl1 (Nat.le_trans ht (Nat.le_add_left _ _)), ht⟩

/-- **Open entry within the renewal goes on (L8).** No holder, taught by members or not at all,
entrants on offer at every step, `f · s ≤ g`, a level of at least one, at most `s` other cohorts each
at most `f`: the level does not fall, and the others stay as they were bounded. -/
theorem «无持而门开不逾生则存» {r : Rule} (hs : r.source = .members ∨ r.source = .none)
    {c : Nat → Move} (hon : ∀ i, (c i).on = true)
    (hA : r.untaught * r.tenure ≤ r.renewal) {x : St} (hx : NoHolder x)
    (hlen : x.others.length ≤ r.tenure) (he : Each (· ≤ r.untaught) x.others) (hL : 1 ≤ x.level) :
    ∀ k, x.level ≤ (run r c k x).level ∧ (run r c k x).others.length ≤ r.tenure ∧
      Each (· ≤ r.untaught) (run r c k x).others
  | 0 => ⟨Nat.le_refl _, hlen, he⟩
  | k + 1 => by
    obtain ⟨h1, h2, h3⟩ := «无持而门开不逾生则存» hs hon hA hx hlen he hL k
    obtain ⟨hn, ht⟩ := open_not_ends hA (run_no_holder hs c hx k) h2 h3 (Nat.le_trans hL h1)
    show x.level ≤ (step r (c k) (run r c k x)).level ∧
      (step r (c k) (run r c k x)).others.length ≤ r.tenure ∧
      Each (· ≤ r.untaught) (step r (c k) (run r c k x)).others
    rw [step_onward _ hn]
    refine ⟨Nat.le_trans h1 (level_onward_kept _ ht), length_keep_le _ _, ?_⟩
    apply each_keep
    show door r (c k).on (run r c k x) ≤ r.untaught ∧ _
    rw [hon k, door_no_holder (run_no_holder hs c hx k)]
    exact ⟨Nat.le_refl _, h3⟩

/-- **Others are present after every step of open entry (L8).** With `1 ≤ s` and `1 ≤ f` besides. -/
theorem «无持而门开众在» {r : Rule} (hs : r.source = .members ∨ r.source = .none)
    {c : Nat → Move} (hon : ∀ i, (c i).on = true) (hsp : 1 ≤ r.tenure) (hf : 1 ≤ r.untaught)
    (hA : r.untaught * r.tenure ≤ r.renewal) {x : St} (hx : NoHolder x)
    (hlen : x.others.length ≤ r.tenure) (he : Each (· ≤ r.untaught) x.others) (hL : 1 ≤ x.level)
    (k : Nat) : 0 < sumL (run r c (k + 1) x).others := by
  obtain ⟨h1, h2, h3⟩ := «无持而门开不逾生则存» hs hon hA hx hlen he hL k
  obtain ⟨hn, _⟩ := open_not_ends hA (run_no_holder hs c hx k) h2 h3 (Nat.le_trans hL h1)
  show 0 < sumL (step r (c k) (run r c k x)).others
  rw [step_onward _ hn]
  show 0 < sumL (keep r.tenure (door r (c k).on (run r c k x) :: _))
  rw [hon k, door_no_holder (run_no_holder hs c hx k)]
  exact sum_keep_cons_pos _ hsp hf

/-- **Open entry over the renewal ends (L8).** No holder, taught by members or not at all, entrants
on offer at every step, `1 ≤ s`, `g < f · s`: it is `gone` at some step, from every level and any
others. -/
theorem «无持而门开逾生则尽» {r : Rule} (hs : r.source = .members ∨ r.source = .none)
    {c : Nat → Move} (hon : ∀ i, (c i).on = true) (hsp : 1 ≤ r.tenure)
    (hA : r.renewal < r.untaught * r.tenure) {x : St} (hx : NoHolder x) :
    ∃ k, Gone (run r c k x) := by
  have key : ∀ i, i ≤ r.tenure → (∃ j, Gone (run r c j x)) ∨
      (keep i (run r c i x).others = List.replicate i r.untaught ∧
        (1 ≤ i → (run r c i x).others.length ≤ r.tenure)) := by
    intro i
    induction i with
    | zero =>
      intro _
      exact Or.inr ⟨rfl, fun h => absurd h (Nat.not_succ_le_zero 0)⟩
    | succ i ih =>
      intro hi
      cases ih (Nat.le_of_succ_le hi) with
      | inl h => exact Or.inl h
      | inr h =>
        by_cases he : Ends r (run r c i x)
        · exact Or.inl ⟨i + 1, step_gone _ he⟩
        · refine Or.inr ⟨?_, fun _ => length_others_step _ _⟩
          show keep (i + 1) (step r (c i) (run r c i x)).others = _
          rw [step_onward _ he]
          show keep (i + 1) (keep r.tenure (door r (c i).on (run r c i x) ::
            (run r c i x).others)) = _
          rw [hon i, door_no_holder (run_no_holder hs c hx i), keep_keep _ hi]
          show r.untaught :: keep i (run r c i x).others = r.untaught :: List.replicate i r.untaught
          rw [h.1]
  cases key r.tenure (Nat.le_refl _) with
  | inl h => exact h
  | inr h =>
    have hO : (run r c r.tenure x).others = List.replicate r.tenure r.untaught := by
      rw [← h.1]
      exact (keep_of_length_le _ _ (h.2 hsp)).symm
    obtain ⟨d, e, hd⟩ := excess hA
    let F : St → Prop := fun y => NoHolder y ∧ y.others = List.replicate r.tenure r.untaught
    have hc : Closed r (fun i => c (r.tenure + i)) F := by
      intro i y hy hne
      have h1 := «无持者不复» hs y _ hy.1 ⟨c (r.tenure + i), rfl⟩
      rw [step_onward _ hne] at h1
      refine ⟨h1, ?_⟩
      show keep r.tenure (door r (c (r.tenure + i)).on y :: y.others) = _
      rw [hon, door_no_holder hy.1, hy.2, keep_cons_replicate]
    have ht : ∀ y, F y → take y = r.renewal + d := by
      intro y hy
      show sumL y.holders + sumL y.others = _
      rw [show sumL y.holders = 0 from hy.1, hy.2, sumL_replicate, Nat.zero_add, Nat.mul_comm, e]
    obtain ⟨k, hg, _⟩ := «恒取逾生则尽» hc ht hd (x := run r c r.tenure x)
      ⟨run_no_holder hs c hx _, hO⟩
    exact ⟨r.tenure + (k + 1), by rw [run_add]; exact hg⟩

/-! ## Two starts compared (L9) -/

/-- The level is present at every step. -/
def Goes (r : Rule) (x : St) : Prop := ∀ k, 1 ≤ (run r always k x).level

/-- It is `gone` at some step. -/
def EndsUp (r : Rule) (x : St) : Prop := ∃ k, Gone (run r always k x)

/-- A level present at every step is never `gone`. -/
theorem «存尽相斥» {r : Rule} {x : St} (h : Goes r x) : ¬ EndsUp r x := by
  intro he
  obtain ⟨k, hg⟩ := he
  have h1 := h k
  rw [hg.1] at h1
  exact Nat.not_succ_le_zero 0 h1

theorem nobody_no_holder (r : Rule) (q L : Nat) : NoHolder (nobody r q L) := by
  show sumL (List.replicate r.tenure 0) = 0
  rw [sumL_replicate, Nat.mul_zero]

/-- **Two tests, each its own (L9).** `.members`, `l < s`, `1 ≤ q`, `1 ≤ L`. Compare two separately
started states: `steady q L`, and no holder with `f` others in each of `s` cohorts at the same level.
The first's level goes on exactly where `(q + e q) · s ≤ g`, and otherwise it is `gone` at some step.
The second's goes on exactly where `f · s ≤ g`, and otherwise likewise. The second state is not reached
from the first by this course. Both tests turn on step 1's clause, that all members leave where the
take exceeds what the level and the renewal can give. -/
theorem «稳开二试» {r : Rule} (hm : r.source = .members) (hl : r.teachingAge < r.tenure) {q L : Nat}
    (hq : 1 ≤ q) (hL : 1 ≤ L) :
    (Goes r (steady r q L) ↔ (q + leak r q) * r.tenure ≤ r.renewal) ∧
    (Goes r (nobody r q L) ↔ r.untaught * r.tenure ≤ r.renewal) ∧
    (r.renewal < (q + leak r q) * r.tenure → EndsUp r (steady r q L)) ∧
    (r.renewal < r.untaught * r.tenure → EndsUp r (nobody r q L)) := by
  have hsp : 1 ≤ r.tenure := Nat.lt_of_le_of_lt (Nat.zero_le _) hl
  have hE : r.renewal < (q + leak r q) * r.tenure → EndsUp r (steady r q L) := fun h => by
    obtain ⟨k, hg, _⟩ := steady_ends (Or.inl hm) hl hq h L
    exact ⟨k + 1, hg⟩
  have hO : r.renewal < r.untaught * r.tenure → EndsUp r (nobody r q L) := fun h =>
    «无持而门开逾生则尽» (Or.inl hm) (fun _ => rfl) hsp h (nobody_no_holder r q L)
  refine ⟨⟨fun h => Nat.le_of_not_lt fun hA => «存尽相斥» h (hE hA), fun h k =>
      Nat.le_trans hL (steady_kept (Or.inl hm) hl hq h hL k).2⟩,
    ⟨fun h => Nat.le_of_not_lt fun hA => «存尽相斥» h (hO hA), fun h k =>
      Nat.le_trans hL («无持而门开不逾生则存» (Or.inl hm) (fun _ => rfl) h (nobody_no_holder r q L)
        (Nat.le_of_eq (length_replicate' _ _))
        (each_replicate (p := (· ≤ r.untaught)) (Nat.le_refl _) _) hL k).1⟩, hE, hO⟩

/-- **The steady state alone going on needs a door of more than one (L9).** Where the steady state
takes within the renewal and open entry does not, `2 ≤ c · (s − l)`: a keeper turns away more than
itself. -/
theorem «稳存而开不存则门过一» {r : Rule} {q : Nat} (hA : (q + leak r q) * r.tenure ≤ r.renewal)
    (hf : r.renewal < r.untaught * r.tenure) : 2 ≤ r.strength * (r.tenure - r.teachingAge) := by
  apply Nat.lt_of_not_le
  intro hC
  have ht : r.strength * (r.tenure - r.teachingAge) * q ≤ q := by
    have h := Nat.mul_le_mul_right q hC
    rw [Nat.one_mul] at h
    exact h
  have h1 : r.untaught ≤ q + leak r q := by
    rw [leak_eq]
    exact le_add_sub_of_le _ ht
  exact Nat.lt_irrefl _ (Nat.lt_of_lt_of_le hf (Nat.le_trans (Nat.mul_le_mul_right _ h1) hA))

/-- With `1 ≤ q`, a cohort of the steady state is larger than those who would come untaught exactly
where the quota alone exceeds them or the door turns no one away. -/
theorem «入过来者之式» (r : Rule) {q : Nat} (hq : 1 ≤ q) :
    r.untaught < q + leak r q ↔
      r.untaught < q ∨ r.strength * (r.tenure - r.teachingAge) = 0 := by
  rw [leak_eq]
  generalize r.strength * (r.tenure - r.teachingAge) = C
  generalize r.untaught = f
  constructor
  · intro h
    cases C with
    | zero => exact Or.inr rfl
    | succ n =>
      refine Or.inl (Nat.lt_of_not_le fun hqf => ?_)
      obtain ⟨k, e⟩ := exists_of_le hqf
      have hqt : q ≤ (n + 1) * q := by
        rw [Nat.succ_mul]
        exact Nat.le_add_left _ _
      have h1 : f - (n + 1) * q ≤ f - q := sub_le_sub_left' f hqt
      have h2 : f - q = k := by
        rw [e, Nat.add_comm]
        exact add_sub_cancel' k q
      rw [h2] at h1
      have h3 : q + (f - (n + 1) * q) ≤ f := by
        rw [e] at h1 ⊢
        exact Nat.add_le_add_left h1 q
      exact Nat.lt_irrefl _ (Nat.lt_of_lt_of_le h h3)
  · intro h
    cases h with
    | inl h => exact Nat.lt_of_lt_of_le h (Nat.le_add_right _ _)
    | inr h =>
      rw [h, Nat.zero_mul, Nat.sub_zero, Nat.add_comm]
      exact Nat.add_le_add_left hq f

/-- **The steady state alone ending, from what it admits (L9).** Where open entry takes within the
renewal and the steady state does not, with `1 ≤ q`: the quota alone exceeds those who would come
untaught, or the door turns no one away. -/
theorem «开存而稳不存之式» {r : Rule} {q : Nat} (hq : 1 ≤ q)
    (hA : r.renewal < (q + leak r q) * r.tenure) (hf : r.untaught * r.tenure ≤ r.renewal) :
    r.untaught < q ∨ r.strength * (r.tenure - r.teachingAge) = 0 := by
  refine («入过来者之式» r hq).mp (Nat.lt_of_not_le fun h => ?_)
  exact Nat.lt_irrefl _ (Nat.lt_of_lt_of_le hA (Nat.le_trans (Nat.mul_le_mul_right _ h) hf))

/-! ## Self-revision (L10) -/

theorem reviseHeld_some {n : Nat} (h : 0 < n) (q v : Nat) :
    reviseHeld n q (Option.some v) = v := by
  cases n with
  | zero => exact absurd h (Nat.lt_irrefl 0)
  | succ n => rfl

/-- **A revision to nothing drains (L10).** `.members`, a holder standing: a revision to `0` with no
revision to a nonzero quota after it leaves no holder `s` steps after it, on or off. So the rule can
take itself out by the route of L5. -/
theorem «改额为零则持尽» {r : Rule} (hm : r.source = .members) {x : St} (hx : Held x) (on : Bool)
    {c : Nat → Move} (hrev : ∀ i v, (c i).rev = Option.some v → v = 0) :
    ∀ k, r.tenure ≤ k →
      sumL (run r c k (step r ⟨on, Option.some 0⟩ x)).holders = 0 := by
  by_cases h : Ends r x
  · intro k _
    rw [step_ends _ h]
    exact run_no_holder (Or.inl hm) c (x := ⟨x.quota, 0, [], []⟩) rfl k
  · refine «额零则持尽» hm hrev ?_ (length_holders_step _ _)
    rw [step_onward _ h]
    show revised r (Option.some 0) x = 0
    unfold revised
    rw [hm]
    exact reviseHeld_some hx _ _

/-- A revision to `v` at the first step, and none after it. -/
def onceAt (v : Nat) : Nat → Move
  | 0 => ⟨true, Option.some v⟩
  | _ + 1 => ⟨true, Option.none⟩

/-- **The band does not settle what follows a revision (L10's witnesses).** Each at one rule, from the
steady state at level one, with one revision at the first step. Below the band and above it, level
`0` follows at `rA`; below the band, the level is still present at step 20 at `rF`; from one quota in
the band to another, level `0` follows at `rB`, where those quotas make no region. The law of a
revision is the region (`«域闭»`), not the band. -/
theorem «带不定改后» :
    (run rA (onceAt 1) 5 (steady rA 2 1)).level = 0 ∧
      (run rA (onceAt 3) 3 (steady rA 2 1)).level = 0 ∧
      1 ≤ (run rF (onceAt 0) 20 (steady rF 1 1)).level ∧
      Band rB 1 ∧ Band rB 5 ∧ ¬ Fits rB 1 5 ∧ (run rB (onceAt 5) 4 (steady rB 1 1)).level = 0 := by
  refine ⟨by decide, by decide, by decide, by decide, by decide, ?_, by decide⟩
  intro h
  exact absurd h.2.2.2.2 (by decide)

/-! ## The family (L11) -/

theorem not_held_of_no_holder {x : St} (h : NoHolder x) : ¬ Held x := by
  intro hh
  have h' : 0 < sumL x.holders := hh
  rw [show sumL x.holders = 0 from h] at h'
  exact Nat.lt_irrefl 0 h'

/-- **Taught from outside, the rule enters at every step that does not end (L11).** The new cohort of
holders is the quota, at every teaching age, so also at `s ≤ l`, where a rule taught only by members
drains (`«不及任则持尽»`); so with `1 ≤ s` and `1 ≤ q` it is held after the step. -/
theorem «外授者即入» {r : Rule} (ho : r.source = .outside) (hsp : 1 ≤ r.tenure) {x : St}
    (hq : 1 ≤ x.quota) (hne : ¬ Ends r x) (rev : Option Nat) :
    (step r ⟨true, rev⟩ x).holders = keep r.tenure (x.quota :: x.holders) ∧
      Held (step r ⟨true, rev⟩ x) := by
  rw [step_onward _ hne]
  have h : entrant r true x = x.quota := by
    show taught r.source x.quota (teachers r x) = x.quota
    rw [ho]
    rfl
  refine ⟨congrArg (fun a => keep r.tenure (a :: x.holders)) h, ?_⟩
  show 0 < sumL (keep r.tenure (entrant r true x :: x.holders))
  rw [h]
  exact sum_keep_cons_pos _ hsp hq

/-- **The family, a table of three rows (L11).** After an empty membership, at a level of at least
one, with entrants on offer: taught from outside the rule has holders after one step; taught by
members, or not at all, it has none. -/
theorem «三源之表» {r : Rule} (hsp : 1 ≤ r.tenure) {x : St} (hq : 1 ≤ x.quota) (hL : 1 ≤ x.level)
    (h0 : sumL x.holders = 0) (o0 : sumL x.others = 0) (rev : Option Nat) :
    (r.source = .outside → Held (step r ⟨true, rev⟩ x)) ∧
    (r.source = .members → ¬ Held (step r ⟨true, rev⟩ x)) ∧
    (r.source = .none → ¬ Held (step r ⟨true, rev⟩ x)) := by
  have hne : ¬ Ends r x := by
    apply not_ends hL
    show sumL x.holders + sumL x.others ≤ _
    rw [h0, o0]
    exact Nat.zero_le _
  exact ⟨fun ho => («外授者即入» ho hsp hq hne rev).2,
    fun hm => not_held_of_no_holder («无持者不复» (Or.inl hm) x _ h0 ⟨_, rfl⟩),
    fun hn => not_held_of_no_holder («无持者不复» (Or.inr hn) x _ h0 ⟨_, rfl⟩)⟩

/-! ## Replaced (L12) -/

/-- The cohorts of holders entered along a course, youngest first. -/
def entered (r : Rule) (c : Nat → Move) : Nat → St → List Nat
  | 0, _ => []
  | n + 1, x => entrant r (c n).on (run r c n x) :: entered r c n x

theorem length_entered (r : Rule) (c : Nat → Move) (x : St) : ∀ n, (entered r c n x).length = n
  | 0 => rfl
  | n + 1 => congrArg Nat.succ (length_entered r c x n)

/-- **Replaced (L12, definitional).** Holders of at most `s` cohorts: after `s` steps with no end,
every holder cohort is one entered in those steps. -/
theorem «任满皆新» {r : Rule} (c : Nat → Move) {x : St} (hlen : x.holders.length ≤ r.tenure)
    (hne : ∀ i, i < r.tenure → ¬ Ends r (run r c i x)) :
    (run r c r.tenure x).holders = entered r c r.tenure x := by
  have key : ∀ i, i ≤ r.tenure →
      (run r c i x).holders = keep r.tenure (entered r c i x ++ x.holders) := by
    intro i
    induction i with
    | zero =>
      intro _
      exact (keep_of_length_le _ _ hlen).symm
    | succ i ih =>
      intro hi
      show (step r (c i) (run r c i x)).holders = _
      rw [step_onward _ (hne i hi)]
      show keep r.tenure (entrant r (c i).on (run r c i x) :: (run r c i x).holders) = _
      rw [ih (Nat.le_of_succ_le hi), keep_cons_keep]
      rfl
  rw [key _ (Nat.le_refl _)]
  have h := keep_append_length (entered r c r.tenure x) x.holders
  rw [length_entered] at h
  exact h

/-- The quotas standing along a course, youngest first. -/
def quotas (r : Rule) (c : Nat → Move) : Nat → St → List Nat
  | 0, _ => []
  | n + 1, x => (run r c n x).quota :: quotas r c n x

theorem within_run {r : Rule} {P Q : Nat} (hf : Fits r P Q) {c : Nat → Move}
    (hon : ∀ i, (c i).on = true) (hrev : ∀ i, RevIn P Q (c i).rev) {x : St} (hx : Within r P Q x) :
    ∀ k, Within r P Q (run r c k x)
  | 0 => hx
  | k + 1 => (within_step hf (within_run hf hon hrev hx k) (hon k) (hrev k)).1

/-- **Nothing of the start among the holders (L12 with L4).** In the region, with entrants on offer
at every step and revisions in `[P, Q]`: after `s` steps the rule is held, still in the region, and
its holders are exactly the cohorts entered in those steps, each at the quota then standing. -/
theorem «域中任满皆新» {r : Rule} {P Q : Nat} (hf : Fits r P Q) {c : Nat → Move}
    (hon : ∀ i, (c i).on = true) (hrev : ∀ i, RevIn P Q (c i).rev) {x : St} (hx : Within r P Q x) :
    (run r c r.tenure x).holders = quotas r c r.tenure x ∧ Held (run r c r.tenure x) ∧
      Within r P Q (run r c r.tenure x) := by
  have hw := within_run hf hon hrev hx
  have he : ∀ n, entered r c n x = quotas r c n x := by
    intro n
    induction n with
    | zero => rfl
    | succ n ih =>
      show entrant r (c n).on (run r c n x) :: entered r c n x =
        (run r c n x).quota :: quotas r c n x
      rw [ih, hon n, within_entrant hf (hw n)]
  have h := «任满皆新» c (Nat.le_of_eq hx.1) (fun i _ => within_not_ends hf (hw i))
  rw [he] at h
  exact ⟨h, within_held hf (hw _), hw _⟩

/-! ## Gaps: where passing and limiting meet (L13) -/

/-- The holders in a cohort: `q` in a held cohort, none in an empty one. -/
def strandH (q : Nat) : Bool → Nat
  | true => q
  | false => 0

/-- The others in a cohort: past one cohort of teachers in a held cohort, all who come in an empty
one. -/
def strandO (r : Rule) (q : Nat) : Bool → Nat
  | true => r.untaught - r.strength * q
  | false => r.untaught

/-- Cohorts held or empty, at a quota. -/
def strands (r : Rule) (q : Nat) (b : List Bool) (L : Nat) : St :=
  ⟨q, L, b.map (strandH q), b.map (strandO r q)⟩

/-- A weighted count of cohorts. -/
def countW (w : Bool → Nat) : List Bool → Nat
  | [] => 0
  | a :: t => w a + countW w t

/-- One for a held cohort. -/
def isHeld : Bool → Nat
  | true => 1
  | false => 0

/-- One for an empty cohort. -/
def isEmpty : Bool → Nat
  | true => 0
  | false => 1

/-- The count of held cohorts. -/
def heldCount (b : List Bool) : Nat := countW isHeld b

/-- The count of empty cohorts. -/
def emptyCount (b : List Bool) : Nat := countW isEmpty b

/-- The oldest cohort. -/
def lastOf : List Bool → Bool
  | [] => false
  | [a] => a
  | _ :: a :: t => lastOf (a :: t)

theorem keep_map {β : Type} (h : Bool → β) : ∀ (n : Nat) (b : List Bool),
    keep n (b.map h) = (keep n b).map h
  | 0, _ => rfl
  | _ + 1, [] => rfl
  | n + 1, a :: t => by
    show h a :: keep n (t.map h) = h a :: (keep n t).map h
    rw [keep_map h n t]

theorem after_map_last (h : Bool → Nat) : ∀ (l : Nat) (b : List Bool), b.length = l + 1 →
    after l (b.map h) = h (lastOf b)
  | 0, [_], _ => Nat.add_zero _
  | l + 1, _ :: a :: t, e => after_map_last h l (a :: t) (Nat.succ.inj e)
  | _, [], e => absurd e (succ_ne_zero' _).symm
  | 0, _ :: _ :: _, e => absurd (Nat.succ.inj e) (succ_ne_zero' _)
  | _ + 1, [_], e => absurd (Nat.succ.inj e) (succ_ne_zero' _).symm

theorem countW_rot (w : Bool → Nat) : ∀ (l : Nat) (b : List Bool), b.length = l + 1 →
    countW w (lastOf b :: keep l b) = countW w b
  | 0, [_], _ => rfl
  | l + 1, x :: a :: t, e => by
    have ih := countW_rot w l (a :: t) (Nat.succ.inj e)
    show w (lastOf (a :: t)) + (w x + countW w (keep l (a :: t))) = w x + countW w (a :: t)
    rw [Nat.add_left_comm]
    exact congrArg (fun n => w x + n) ih
  | _, [], e => absurd e (succ_ne_zero' _).symm
  | 0, _ :: _ :: _, e => absurd (Nat.succ.inj e) (succ_ne_zero' _)
  | _ + 1, [_], e => absurd (Nat.succ.inj e) (succ_ne_zero' _).symm

theorem add_four (a b c d : Nat) : a + b + (c + d) = a + c + (b + d) := by
  rw [Nat.add_assoc, Nat.add_left_comm b c d, ← Nat.add_assoc]

theorem take_strands (r : Rule) (q L : Nat) : ∀ b : List Bool,
    take (strands r q b L) =
      heldCount b * (q + (r.untaught - r.strength * q)) + emptyCount b * r.untaught
  | [] => by
    show 0 + 0 = 0 * _ + 0 * _
    rw [Nat.zero_mul, Nat.zero_mul]
  | true :: t => by
    have ih' : sumL (t.map (strandH q)) + sumL (t.map (strandO r q)) =
      heldCount t * (q + (r.untaught - r.strength * q)) + emptyCount t * r.untaught :=
      take_strands r q L t
    show q + sumL (t.map (strandH q)) + ((r.untaught - r.strength * q) + sumL (t.map (strandO r q))) =
      (1 + heldCount t) * (q + (r.untaught - r.strength * q)) + (0 + emptyCount t) * r.untaught
    rw [add_four, ih', Nat.zero_add, right_distrib', Nat.one_mul]
    exact (Nat.add_assoc _ _ _).symm
  | false :: t => by
    have ih' : sumL (t.map (strandH q)) + sumL (t.map (strandO r q)) =
      heldCount t * (q + (r.untaught - r.strength * q)) + emptyCount t * r.untaught :=
      take_strands r q L t
    show 0 + sumL (t.map (strandH q)) + (r.untaught + sumL (t.map (strandO r q))) =
      (0 + heldCount t) * (q + (r.untaught - r.strength * q)) + (1 + emptyCount t) * r.untaught
    rw [add_four, ih', Nat.zero_add, Nat.zero_add, right_distrib', Nat.one_mul, Nat.add_left_comm]

theorem sum_strandH (q : Nat) : ∀ b : List Bool, sumL (b.map (strandH q)) = heldCount b * q
  | [] => (Nat.zero_mul q).symm
  | true :: t => by
    show q + sumL (t.map (strandH q)) = (1 + heldCount t) * q
    rw [sum_strandH q t, right_distrib', Nat.one_mul]
  | false :: t => by
    show 0 + sumL (t.map (strandH q)) = (0 + heldCount t) * q
    rw [sum_strandH q t, Nat.zero_add, Nat.zero_add]

theorem onward_strands {r : Rule} (hm : r.source = .members)
    (hs : r.tenure = r.teachingAge + 1) {q : Nat} (hq : 1 ≤ q) {b : List Bool}
    (hb : b.length = r.tenure) (L : Nat) :
    onward r ⟨true, Option.none⟩ (strands r q b L) =
      strands r q (lastOf b :: keep r.teachingAge b)
        (L + r.renewal - take (strands r q b L)) := by
  have hT : teachers r (strands r q b L) = strandH q (lastOf b) :=
    after_map_last _ _ _ (hb.trans hs)
  have hE : entrant r true (strands r q b L) = strandH q (lastOf b) := by
    show taught r.source q (teachers r (strands r q b L)) = _
    rw [hm, hT]
    cases lastOf b with
    | true => exact taught_members_pos q hq
    | false => rfl
  have hD : door r true (strands r q b L) = strandO r q (lastOf b) := by
    show r.untaught - r.strength * teachers r (strands r q b L) = _
    rw [hT]
    cases lastOf b with
    | true => rfl
    | false =>
      show r.untaught - r.strength * 0 = r.untaught
      rw [Nat.mul_zero, Nat.sub_zero]
  have hR : revised r Option.none (strands r q b L) = q := revised_none _
  show (⟨revised r Option.none (strands r q b L), L + r.renewal - take (strands r q b L),
      keep r.tenure (entrant r true (strands r q b L) :: b.map (strandH q)),
      keep r.tenure (door r true (strands r q b L) :: b.map (strandO r q))⟩ : St) = _
  rw [hR, hE, hD, hs]
  show (⟨q, _, strandH q (lastOf b) :: keep r.teachingAge (b.map (strandH q)),
      strandO r q (lastOf b) :: keep r.teachingAge (b.map (strandO r q))⟩ : St) =
    ⟨q, _, strandH q (lastOf b) :: (keep r.teachingAge b).map (strandH q),
      strandO r q (lastOf b) :: (keep r.teachingAge b).map (strandO r q)⟩
  rw [keep_map, keep_map]

/-- The states with the held and empty cohorts of `b`, in any rotation. -/
def Strands (r : Rule) (q : Nat) (b : List Bool) (y : St) : Prop :=
  ∃ b' L', b'.length = r.tenure ∧ heldCount b' = heldCount b ∧ emptyCount b' = emptyCount b ∧
    y = strands r q b' L'

theorem strands_closed {r : Rule} {q : Nat} {b : List Bool} (hm : r.source = .members)
    (hs : r.tenure = r.teachingAge + 1) (hq : 1 ≤ q) : Closed r always (Strands r q b) := by
  intro _ y hy _
  obtain ⟨b', L', h1, h2, h3, rfl⟩ := hy
  have hl : b'.length = r.teachingAge + 1 := h1.trans hs
  refine ⟨_, _, ?_, ?_, ?_, onward_strands hm hs hq h1 L'⟩
  · show (keep r.teachingAge b').length + 1 = r.tenure
    rw [length_keep_eq _ _ (by rw [hl]; exact Nat.le_succ _), hs]
  · exact (countW_rot isHeld _ _ hl).trans h2
  · exact (countW_rot isEmpty _ _ hl).trans h3

theorem strands_take {r : Rule} {q : Nat} {b : List Bool} : ∀ y, Strands r q b y → take y =
    heldCount b * (q + (r.untaught - r.strength * q)) + emptyCount b * r.untaught := by
  intro y hy
  obtain ⟨b', L', _, h2, h3, rfl⟩ := hy
  rw [take_strands, h2, h3]

theorem strands_held {r : Rule} {q : Nat} {b : List Bool} (hq : 1 ≤ q) (hk : 1 ≤ heldCount b) :
    ∀ y, Strands r q b y → Held y := by
  intro y hy
  obtain ⟨b', L', _, h2, _, rfl⟩ := hy
  show 0 < sumL (b'.map (strandH q))
  rw [sum_strandH, h2]
  exact Nat.mul_pos hk hq

/-- **Gaps: where passing and limiting meet (L13).** At `l = s − 1`, each cohort teaches exactly the
one that replaces it, so the held cohorts form separate strands, and the cohorts only rotate.
`.members`, entrants on offer at every step, no revision, `1 ≤ q`, `1 ≤ L`: from `k ≥ 1` held cohorts
and `z` empty ones, the rule is held at every step exactly where
`k · (q + e) + z · f ≤ g`, with `e := f − c · q`. Passing needs only `k ≥ 1`. `k` sets on how many of
the `s` steps, in rotation, the door is kept and the rule passed, so the take is the steady state's
on `k` cohorts and open entry's on `z`. L2 is the steady state's law and not the rule's. -/
theorem «隙之律» {r : Rule} (hm : r.source = .members) (hs : r.tenure = r.teachingAge + 1) {q L : Nat}
    (hq : 1 ≤ q) (hL : 1 ≤ L) {b : List Bool} (hb : b.length = r.tenure) (hk : 1 ≤ heldCount b) :
    (∀ n, Held (run r always n (strands r q b L))) ↔
      heldCount b * (q + (r.untaught - r.strength * q)) + emptyCount b * r.untaught ≤ r.renewal := by
  have hc := strands_closed (b := b) hm hs hq
  have ht := strands_take (r := r) (q := q) (b := b)
  have hF : Strands r q b (strands r q b L) := ⟨b, L, hb, rfl, rfl, rfl⟩
  constructor
  · intro h
    apply Nat.le_of_not_lt
    intro hA
    obtain ⟨d, e, hd⟩ := excess hA
    obtain ⟨k, hg, _⟩ := «恒取逾生则尽» hc (fun y hy => (ht y hy).trans e) hd hF
    exact not_held_of_gone hg (h (k + 1))
  · intro hA n
    exact strands_held hq hk _ («恒取不逾生则存» hc ht hA hF hL n).1

/-- **Over the bound the rule is held to the last state (L13).** With the hypotheses of `«隙之律»`:
where `g` is below the gaps' take, the rule is held at every step up to some `k`, and the next is
`gone`. -/
theorem «隙过生持至尽» {r : Rule} (hm : r.source = .members) (hs : r.tenure = r.teachingAge + 1)
    {q : Nat} (hq : 1 ≤ q) (L : Nat) {b : List Bool} (hb : b.length = r.tenure)
    (hk : 1 ≤ heldCount b)
    (hA : r.renewal <
      heldCount b * (q + (r.untaught - r.strength * q)) + emptyCount b * r.untaught) :
    ∃ k, Gone (run r always (k + 1) (strands r q b L)) ∧
      ∀ i, i ≤ k → Held (run r always i (strands r q b L)) := by
  have hc := strands_closed (b := b) hm hs hq
  have ht := strands_take (r := r) (q := q) (b := b)
  obtain ⟨d, e, hd⟩ := excess hA
  obtain ⟨k, hg, hF⟩ := «恒取逾生则尽» hc (fun y hy => (ht y hy).trans e) hd
    (x := strands r q b L) ⟨b, L, hb, rfl, rfl, rfl⟩
  exact ⟨k, hg, fun i hi => strands_held hq hk _ (hF i hi)⟩

theorem count_total : ∀ b : List Bool, heldCount b + emptyCount b = b.length
  | [] => rfl
  | true :: t => by
    show 1 + heldCount t + (0 + emptyCount t) = t.length + 1
    rw [Nat.zero_add, Nat.add_assoc, count_total t, Nat.add_comm]
  | false :: t => by
    show 0 + heldCount t + (1 + emptyCount t) = t.length + 1
    rw [Nat.zero_add, Nat.add_left_comm, count_total t, Nat.add_comm]

theorem mul_lt_of {z a b : Nat} (h : z * a < z * b) : a < b :=
  Nat.lt_of_not_le fun hba => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le h (Nat.mul_le_mul_left z hba))

theorem split_mul (k z X : Nat) : (k + z) * X = k * X + z * X := right_distrib' k z X

theorem lt_of_add_lt_add_left' {a b c : Nat} (h : a + b < a + c) : b < c :=
  Nat.lt_of_not_le fun hcb => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le h (Nat.add_le_add_left hcb a))

theorem mul_lt_mul_of_pos' {k a b : Nat} (hk : 1 ≤ k) (h : a < b) : k * a < k * b := by
  cases k with
  | zero => exact absurd hk (Nat.not_succ_le_zero 0)
  | succ k =>
    rw [Nat.succ_mul, Nat.succ_mul]
    exact Nat.lt_of_le_of_lt (Nat.add_le_add_right (Nat.mul_le_mul_left k (Nat.le_of_lt h)) a)
      (Nat.add_lt_add_left h _)

/-- **Where gaps hold and the steady state does not (L13).** Write `X` for a held cohort's members,
`k` and `z` for the held and empty cohorts, so that `k + z = s` (`count_total`). Where `k · X + z · f`
is within `g` and `X · s` is not: `f < X` and `f · s < g`. So on this side a cohort of the steady state
exceeds open entry's, and open entry would go on too; the door has no part in it. -/
theorem «隙存而稳不存之式» {f X g k z : Nat} (hk : 1 ≤ k) (h1 : k * X + z * f ≤ g)
    (h2 : g < X * (k + z)) : f < X ∧ f * (k + z) < g := by
  have h2' : g < k * X + z * X := by
    rw [← split_mul, Nat.mul_comm]
    exact h2
  have hfX : f < X := mul_lt_of (lt_of_add_lt_add_left' (Nat.lt_of_le_of_lt h1 h2'))
  refine ⟨hfX, ?_⟩
  rw [Nat.mul_comm, split_mul]
  exact Nat.lt_of_lt_of_le (Nat.add_lt_add_right (mul_lt_mul_of_pos' hk hfX) _) h1

/-- **Where the steady state goes on and gaps do not (L13).** With `t` turned away at a held cohort
(`t = c · q` at the gaps) and `e := f − t`. Where `(q + e) · s` is within `g` and `k · (q + e) + z · f`
is not: `q + e < f`, `g < f · s` and `q < t`. So on this side a keeper turns away more than itself:
the door keeps the level at full cohorts, and open entry would end it. -/
theorem «稳存而隙不存之式» {f q t g k z : Nat}
    (h1 : (q + (f - t)) * (k + z) ≤ g) (h2 : g < k * (q + (f - t)) + z * f) :
    q + (f - t) < f ∧ g < f * (k + z) ∧ q < t := by
  have h1' : k * (q + (f - t)) + z * (q + (f - t)) ≤ g := by
    rw [← split_mul, Nat.mul_comm]
    exact h1
  have hlt : q + (f - t) < f := Nat.lt_of_not_le fun hfX =>
    Nat.lt_irrefl _ (Nat.lt_of_lt_of_le h2
      (Nat.le_trans (Nat.add_le_add_left (Nat.mul_le_mul_left z hfX) _) h1'))
  refine ⟨hlt, ?_, ?_⟩
  · rw [Nat.mul_comm, split_mul]
    exact Nat.lt_of_lt_of_le h2
      (Nat.add_le_add_right (Nat.mul_le_mul_left k (Nat.le_of_lt hlt)) _)
  · exact Nat.lt_of_not_le fun htq =>
      Nat.lt_irrefl _ (Nat.lt_of_lt_of_le hlt (le_add_sub_of_le f htq))

/-- The rule of L13's first witness. -/
def rD : Rule := ⟨2, 1, 4, 1, 1, .members⟩

/-- The rule of L13's second witness. -/
def rE : Rule := ⟨3, 2, 6, 4, 2, .members⟩

/-- **Gaps can hold where the steady state cannot (L13's witness).** At one rule with a door. -/
theorem «隙存而稳不存» :
    (∀ n, Held (run rD always n (strands rD 3 [true, false] 1))) ∧ ¬ Band rD 3 :=
  ⟨(«隙之律» rfl rfl (by decide) (by decide) rfl (by decide)).mpr (by decide), by decide⟩

/-- **Gaps can end the level, the rule held to the last state, where the steady state goes on (L13's
witness).** At one rule. -/
theorem «稳存而隙不存» :
    Band rE 2 ∧ ∃ k, Gone (run rE always (k + 1) (strands rE 2 [true, false, false] 1)) ∧
      ∀ i, i ≤ k → Held (run rE always i (strands rE 2 [true, false, false] 1)) :=
  ⟨by decide, «隙过生持至尽» rfl rfl (by decide) 1 rfl (by decide) (by decide)⟩

/-- A revision to `0` at the second step and back at the fourth. -/
def outAndBack : Nat → Move
  | 1 => ⟨true, Option.some 0⟩
  | 3 => ⟨true, Option.some 2⟩
  | _ => ⟨true, Option.none⟩

/-- **A state with gaps is reached by a revision, and overdrawn with the rule held (a witness).** At
`3, 2, 6, 4, 2`, `q = 2`, `L = 30`, in the band, revised to `0` at the second step and back at the
fourth: at step 8 the state is one held cohort and two empty, held at every step to step 17, and `gone`
at step 18. -/
theorem «改而成隙则尽» :
    Band rE 2 ∧ run rE outAndBack 8 (steady rE 2 30) = strands rE 2 [true, false, false] 36 ∧
      (∀ i, i < 18 → 0 < sumL (run rE outAndBack i (steady rE 2 30)).holders) ∧
      Gone (run rE outAndBack 18 (steady rE 2 30)) :=
  ⟨by decide, rfl, by decide, ⟨by decide, by decide, by decide⟩⟩

/-! ## The same rule, read at a class -/

/-- **The same rule, read at a class.** On `«续»`, a step with a revision inside the region continues
under the class "held or not" and not under the class "the same quota": 01 §2's `«任一缘可为续»` with
these occurrences. At one rule. -/
theorem «同规随类» :
    «类» (fun x y : St => Held x ↔ Held y) ∧ «类» (fun x y : St => x.quota = y.quota) ∧
      Within rB 3 5 (steady rB 3 1) ∧ onIn rB 3 5 (steady rB 3 1)
        (step rB ⟨true, Option.some 5⟩ (steady rB 3 1)) ∧
      «续» (net rB) (fun x y => Held x ↔ Held y) (steady rB 3 1)
        (step rB ⟨true, Option.some 5⟩ (steady rB 3 1)) ∧
      ¬ «续» (net rB) (fun x y => x.quota = y.quota) (steady rB 3 1)
        (step rB ⟨true, Option.some 5⟩ (steady rB 3 1)) := by
  have hb : Band rB 3 := by decide
  have hw : Within rB 3 5 (steady rB 3 1) :=
    ⟨length_replicate' _ _, ⟨⟨by decide, by decide⟩, ⟨by decide, by decide⟩, ⟨by decide, by decide⟩,
        ⟨by decide, by decide⟩, trivial⟩,
      Nat.le_of_eq (length_replicate' _ _), ⟨by decide, by decide, by decide, by decide, trivial⟩,
      by decide, by decide, by decide⟩
  have hon : onIn rB 3 5 (steady rB 3 1) (step rB ⟨true, Option.some 5⟩ (steady rB 3 1)) :=
    ⟨Option.some 5, fun v e => by
      cases e
      exact ⟨by decide, by decide⟩, rfl⟩
  have h0 : Held (steady rB 3 1) := held_steady (by decide) (by decide) 1
  have h1 := within_held «域可得» («域闭» «域可得» _ _ hw hon)
  refine ⟨⟨fun _ => Iff.rfl, Iff.symm, Iff.trans⟩, ⟨fun _ => rfl, Eq.symm, Eq.trans⟩, hw, hon,
    ⟨⟨_, rfl⟩, ⟨fun _ => h1, fun _ => h0⟩⟩, fun h => absurd h.2 (by decide)⟩

/-- **Abandoned (§4's row, a witness at one rule).** With no one who would come untaught, a quota of
nothing and a renewal: after a tenure there is no member, and the level has risen. -/
theorem «弃而储增» :
    let r : Rule := ⟨2, 1, 3, 0, 1, .members⟩
    let x : St := ⟨0, 2, [1, 1], []⟩
    sumL (run r always 2 x).holders = 0 ∧ sumL (run r always 3 x).others = 0 ∧
      x.level < (run r always 3 x).level := by
  decide

/-! ## That the premises can be met -/

/-- The rule of L9's third case. -/
def rG : Rule := ⟨2, 1, 5, 2, 1, .members⟩

/-- The rule of L9's fourth case. -/
def rH : Rule := ⟨1, 0, 1, 4, 0, .members⟩

/-- A rule whose holders teach only after a tenure. -/
def rI : Rule := ⟨2, 2, 100, 0, 0, .members⟩

/-- **Each of the four cases occurs (L9's premises met).** In the order of `«门之四境»`: both take
within the renewal; the steady state alone does, where a keeper turns away more than itself; open
entry alone does, the quota admitting more than would have come; neither does. -/
theorem «四境皆有» :
    (rF.teachingAge < rF.tenure ∧ (1 + leak rF 1) * rF.tenure ≤ rF.renewal ∧
      rF.untaught * rF.tenure ≤ rF.renewal) ∧
    (rA.teachingAge < rA.tenure ∧ (2 + leak rA 2) * rA.tenure ≤ rA.renewal ∧
      rA.renewal < rA.untaught * rA.tenure) ∧
    (rG.teachingAge < rG.tenure ∧ rG.renewal < (3 + leak rG 3) * rG.tenure ∧
      rG.untaught * rG.tenure ≤ rG.renewal) ∧
    (rH.teachingAge < rH.tenure ∧ rH.renewal < (1 + leak rH 1) * rH.tenure ∧
      rH.renewal < rH.untaught * rH.tenure) := by
  decide

/-- **The drain's premise met (a witness at one rule).** Held at the start, no holder after a tenure.
The general law is `«不及任则持尽»`. -/
theorem «及任之前持尽之例» : Held (steady rI 5 50) ∧ NoHolder (run rI always 2 (steady rI 5 50)) :=
  ⟨show 0 < sumL (steady rI 5 50).holders by decide,
    show sumL (run rI always 2 (steady rI 5 50)).holders = 0 by decide⟩

end RuleRebuilding

end Becoming
