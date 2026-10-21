
/-! ### Coupled webs in whole numbers: rest and points of no return

Stated condition by condition, a web's rest needs no equality of functions: under mutual support each
condition's giving respects what is left condition by condition, so states alike at every condition
step alike. For finitely many conditions, listed by a list covering them, a run within a band comes
to rest, each condition's ending is decided at one step, and each condition's point of no return,
given the other levels, is a least level that does not rise as any other rises. -/

namespace Indexed

variable {ι : Type} {G : ι → (ι → Nat) → Nat} {H : ι → Nat}

/-- The coupled step of a web keeps every state with every level within `hi` within `hi`. -/
def Band (G : ι → (ι → Nat) → Nat) (H : ι → Nat) (hi : Nat) : Prop :=
  ∀ x : ι → Nat, (∀ i, x i ≤ hi) → ∀ i, step Drawn.whole G H x i ≤ hi

/-- **Mutual support respects what is left condition by condition.** A giving that rises with what is
left of each condition gives alike from what is left alike at every condition. -/
theorem respects {g : (ι → Nat) → Nat} (rises : Rises Drawn.whole g) {e e' : ι → Nat}
    (same : ∀ j, e j = e' j) : g e = g e' :=
  Nat.le_antisymm (rises e e' fun j => Nat.le_of_eq (same j))
    (rises e' e fun j => Nat.le_of_eq (same j).symm)

/-- Under mutual support, states whose draws leave alike at every condition step alike. -/
theorem step_alike (rises : ∀ i, Rises Drawn.whole (G i)) {x y : ι → Nat}
    (same : ∀ j, x j - H j = y j - H j) (i : ι) :
    step Drawn.whole G H x i = step Drawn.whole G H y i :=
  show x i - H i + G i (left Drawn.whole H x) = y i - H i + G i (left Drawn.whole H y) from
    congr (congrArg (· + ·) (same i)) (respects (rises i) same)

/-- Under mutual support, runs from states alike at every condition stay alike at every condition. -/
theorem run_alike (rises : ∀ i, Rises Drawn.whole (G i)) {x y : ι → Nat} (same : ∀ j, x j = y j) :
    ∀ n i, (Law.run (step Drawn.whole G H) x).state n i = (Law.run (step Drawn.whole G H) y).state n i
  | 0 => same
  | n + 1 => step_alike rises fun j => congrArg (· - H j) (run_alike rises same n j)

/-- Under mutual support, a condition ends from one of two states alike at every condition exactly
where it ends from the other. -/
theorem ends_alike (rises : ∀ i, Rises Drawn.whole (G i)) {x y : ι → Nat} (same : ∀ j, x j = y j)
    (i : ι) : Ends Drawn.whole G H (fun w => w i) x ↔ Ends Drawn.whole G H (fun w => w i) y :=
  ⟨fun ⟨N, gone⟩ => ⟨N, fun k => (run_alike rises same (N + k) i).symm.trans (gone k)⟩,
   fun ⟨N, gone⟩ => ⟨N, fun k => (run_alike rises same (N + k) i).trans (gone k)⟩⟩

/-- The run from the state after one step is the run, one step on. -/
theorem run_shift (f : (ι → Nat) → (ι → Nat)) (s : ι → Nat) :
    ∀ m, (Law.run f (f s)).state m = (Law.run f s).state (m + 1)
  | 0 => rfl
  | m + 1 => congrArg f (run_shift f s m)

/-- **In a band, mutual support gives within each draw.** Where each condition's giving rises with
what is left of each and the step keeps a band up to `hi`, at every state in the band each condition
gives at most its draw. -/
theorem within_draw (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat} (band : Band G H hi)
    {x : ι → Nat} (high : ∀ i, x i ≤ hi) (i : ι) : G i (left Drawn.whole H x) ≤ H i :=
  Nat.le_trans (rises i _ _ fun j => Nat.sub_le_sub_right (high j) (H j))
    (given_within (D := Drawn.whole) (band (fun _ => hi) (fun _ => Nat.le_refl hi) i))

/-- A run from a state within a band stays within it. -/
theorem run_within {hi : Nat} (band : Band G H hi) {s : ι → Nat} (high : ∀ i, s i ≤ hi) :
    ∀ n i, (Law.run (step Drawn.whole G H) s).state n i ≤ hi
  | 0 => high
  | n + 1 => band _ (run_within band high n)

/-- **In a band under mutual support, what is left of each condition never rises along a run.** -/
theorem left_falls (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat} (band : Band G H hi)
    {s : ι → Nat} (high : ∀ i, s i ≤ hi) (n : Nat) (i : ι) :
    (Law.run (step Drawn.whole G H) s).state (n + 1) i - H i ≤
      (Law.run (step Drawn.whole G H) s).state n i - H i :=
  left_le (D := Drawn.whole) (within_draw rises band (run_within band high n) i)

/-- **A run is still once what is left of every condition repeats.** Under mutual support, where a
step of the run leaves what the draws leave of each condition as it was, the run is still, condition
by condition, from the next step on. -/
theorem still_of_left (rises : ∀ i, Rises Drawn.whole (G i)) {s : ι → Nat} {n : Nat}
    (same : ∀ j, (Law.run (step Drawn.whole G H) s).state (n + 1) j - H j =
      (Law.run (step Drawn.whole G H) s).state n j - H j) :
    ∀ k i, (Law.run (step Drawn.whole G H) s).state (n + 1 + k) i =
      (Law.run (step Drawn.whole G H) s).state (n + 1) i
  | 0, _ => rfl
  | k + 1, i => step_alike rises
      (fun j => (congrArg (· - H j) (still_of_left rises same k j)).trans (same j)) i

/-- What the draws leave of the listed conditions, added. -/
def leftOver (H : ι → Nat) (x : ι → Nat) : List ι → Nat
  | [] => 0
  | i :: cs => (x i - H i) + leftOver H x cs

/-- What is left of every listed condition at most another's adds to at most the other's. -/
theorem leftOver_le {x y : ι → Nat} (below : ∀ i, x i - H i ≤ y i - H i) :
    ∀ cs, leftOver H x cs ≤ leftOver H y cs
  | [] => Nat.le_refl 0
  | i :: cs => Nat.add_le_add (below i) (leftOver_le below cs)

/-- At most, and short at a listed condition, adds to less. -/
theorem leftOver_lt {x y : ι → Nat} (below : ∀ i, x i - H i ≤ y i - H i) {j : ι}
    (apart : x j - H j ≠ y j - H j) : ∀ cs, j ∈ cs → leftOver H x cs < leftOver H y cs
  | _ :: cs, .head _ => Nat.add_lt_add_of_lt_of_le
      (match Nat.lt_or_ge (x j - H j) (y j - H j) with
        | .inl lt => lt
        | .inr ge => absurd (Nat.le_antisymm (below j) ge) apart) (leftOver_le below cs)
  | i :: cs, .tail _ mem => Nat.add_lt_add_of_le_of_lt (below i) (leftOver_lt below apart cs mem)

/-- Within a band, what is left of the listed conditions adds to at most their count times `hi`. -/
theorem leftOver_bound {x : ι → Nat} {hi : Nat} (high : ∀ i, x i ≤ hi) :
    ∀ cs : List ι, leftOver H x cs ≤ cs.length * hi
  | [] => Nat.zero_le _
  | i :: cs => Nat.le_trans
      (Nat.add_le_add (Nat.le_trans (Nat.sub_le (x i) (H i)) (high i)) (leftOver_bound high cs))
      (Nat.le_of_eq ((Nat.add_comm _ _).trans (Nat.succ_mul cs.length hi).symm))

/-- Whether what the draws leave of every listed condition is alike in two states. -/
def alikeOn (H : ι → Nat) (x y : ι → Nat) : List ι → Bool
  | [] => true
  | i :: cs => if x i - H i = y i - H i then alikeOn H x y cs else false

theorem alikeOn_true {x y : ι → Nat} :
    ∀ {cs : List ι}, alikeOn H x y cs = true → ∀ i, i ∈ cs → x i - H i = y i - H i
  | [], _, _, mem => nomatch mem
  | j :: cs, all, i, mem =>
    if h : x j - H j = y j - H j then
      have rest : alikeOn H x y cs = true := (if_pos h).symm.trans all
      match i, mem with
      | _, .head _ => h
      | i, .tail _ m => alikeOn_true rest i m
    else Bool.noConfusion ((if_neg h).symm.trans all)

theorem alikeOn_false {x y : ι → Nat} :
    ∀ {cs : List ι}, alikeOn H x y cs = false → ∃ i, i ∈ cs ∧ x i - H i ≠ y i - H i
  | [], differs => Bool.noConfusion differs
  | j :: _, differs =>
    if h : x j - H j = y j - H j then
      match alikeOn_false ((if_pos h).symm.trans differs) with
      | ⟨i, mem, apart⟩ => ⟨i, .tail _ mem, apart⟩
    else ⟨j, .head _, h⟩

/-- Within a band under mutual support, the run of a web of the listed conditions is still, condition
by condition, from some step at most one more than what the draws leave of them, added. -/
theorem rests_by (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat} (band : Band G H hi)
    {cs : List ι} (covers : ∀ i, i ∈ cs) :
    ∀ (d : Nat) (s : ι → Nat), (∀ i, s i ≤ hi) → leftOver H s cs ≤ d →
      ∃ N, N ≤ d + 1 ∧ ∀ k i, (Law.run (step Drawn.whole G H) s).state (N + k) i =
        (Law.run (step Drawn.whole G H) s).state N i
  | 0, s, high, fuel =>
    match h : alikeOn H (step Drawn.whole G H s) s cs with
    | true => ⟨1, Nat.le_refl 1, still_of_left (n := 0) rises fun j => alikeOn_true h j (covers j)⟩
    | false => match alikeOn_false h with
      | ⟨_, mem, apart⟩ => absurd (Nat.lt_of_lt_of_le
          (leftOver_lt (left_falls rises band high 0) apart cs mem) fuel) (Nat.not_lt_zero _)
  | d + 1, s, high, fuel =>
    match h : alikeOn H (step Drawn.whole G H s) s cs with
    | true => ⟨1, Nat.succ_le_succ (Nat.zero_le _),
        still_of_left (n := 0) rises fun j => alikeOn_true h j (covers j)⟩
    | false => match alikeOn_false h with
      | ⟨_, mem, apart⟩ =>
        match rests_by rises band covers d (step Drawn.whole G H s) (band s high)
          (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le
            (leftOver_lt (left_falls rises band high 0) apart cs mem) fuel)) with
        | ⟨N, le, still⟩ => ⟨N + 1, Nat.succ_le_succ le, fun k i =>
            (congrArg (fun m => (Law.run (step Drawn.whole G H) s).state m i)
              (Nat.add_right_comm N 1 k)).trans
            ((congrArg (· i) (run_shift (step Drawn.whole G H) s (N + k))).symm.trans
              ((still k i).trans (congrArg (· i) (run_shift (step Drawn.whole G H) s N))))⟩

/-- **Under mutual support within a band, a web's run comes to rest.** In whole numbers, where each
condition's giving rises with what is left of each and the step keeps a band up to `hi`, the run from
a state in the band is still, condition by condition, from some step at most the listed conditions'
count times `hi` with one. -/
theorem comes_to_rest (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat} (band : Band G H hi)
    {cs : List ι} (covers : ∀ i, i ∈ cs) {s : ι → Nat} (high : ∀ i, s i ≤ hi) :
    ∃ N, N ≤ cs.length * hi + 1 ∧ ∀ k i, (Law.run (step Drawn.whole G H) s).state (N + k) i =
      (Law.run (step Drawn.whole G H) s).state N i :=
  rests_by rises band covers (cs.length * hi) s high (leftOver_bound high cs)

/-- Within a band under mutual support, whether a condition ends is decided at step
`cs.length * hi + 1`. -/
theorem ends_iff (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat} (band : Band G H hi)
    {cs : List ι} (covers : ∀ i, i ∈ cs) {s : ι → Nat} (high : ∀ i, s i ≤ hi) (i : ι) :
    Ends Drawn.whole G H (fun x => x i) s ↔
      (Law.run (step Drawn.whole G H) s).state (cs.length * hi + 1) i = 0 :=
  match comes_to_rest rises band covers high with
  | ⟨N, le, still⟩ =>
    have atK : (Law.run (step Drawn.whole G H) s).state (cs.length * hi + 1) i =
        (Law.run (step Drawn.whole G H) s).state N i :=
      (congrArg (fun n => (Law.run (step Drawn.whole G H) s).state n i)
        (Becoming.add_sub_of_le le).symm).trans (still _ i)
    ⟨fun ⟨M, gone⟩ => atK.trans ((still M i).symm.trans
        ((congrArg (fun n => (Law.run (step Drawn.whole G H) s).state n i) (Nat.add_comm N M)).trans
          (gone N))),
     fun zero => ⟨cs.length * hi + 1, fun k =>
       ((congrArg (fun n => (Law.run (step Drawn.whole G H) s).state n i)
         ((congrArg (· + k) (Becoming.add_sub_of_le le).symm).trans
           (Nat.add_assoc N (cs.length * hi + 1 - N) k))).trans
         ((still _ i).trans atK.symm)).trans zero⟩⟩

/-- A state with condition `i`'s level set to `a`, every other as in `y`. -/
def setAt [DecidableEq ι] (y : ι → Nat) (i : ι) (a : Nat) : ι → Nat :=
  fun j => if j = i then a else y j

/-- Setting one level lower, the others alike, is at or below. -/
theorem setAt_below [DecidableEq ι] {y y' : ι → Nat} {i : ι} {a b : Nat} (le : a ≤ b)
    (others : ∀ j, y j ≤ y' j) : Below Drawn.whole (setAt y i a) (setAt y' i b) := fun j =>
  if h : j = i then by
    show (if j = i then a else y j) ≤ (if j = i then b else y' j)
    rw [if_pos h, if_pos h]
    exact le
  else by
    show (if j = i then a else y j) ≤ (if j = i then b else y' j)
    rw [if_neg h, if_neg h]
    exact others j

/-- Within a band, setting a level within it keeps the state within it. -/
theorem setAt_within [DecidableEq ι] {y : ι → Nat} {i : ι} {a hi : Nat} (high : a ≤ hi)
    (highs : ∀ j, y j ≤ hi) (j : ι) : setAt y i a j ≤ hi :=
  if h : j = i then by
    show (if j = i then a else y j) ≤ hi
    rw [if_pos h]
    exact high
  else by
    show (if j = i then a else y j) ≤ hi
    rw [if_neg h]
    exact highs j

/-- Whether condition `i`, from level `a` with the others as in `y`, is nothing at step `K`. -/
def ending [DecidableEq ι] (G : ι → (ι → Nat) → Nat) (H : ι → Nat) (K : Nat) (y : ι → Nat)
    (i : ι) (a : Nat) : Bool :=
  decide ((Law.run (step Drawn.whole G H) (setAt y i a)).state K i = 0)

/-- **Condition `i`'s point of no return, the others as in `y`.** The least level up to `hi + 1`
from which condition `i` is not nothing at step `cs.length * hi + 1`. -/
def threshold [DecidableEq ι] (G : ι → (ι → Nat) → Nat) (H : ι → Nat) (cs : List ι) (hi : Nat)
    (y : ι → Nat) (i : ι) : Nat :=
  leading (ending G H (cs.length * hi + 1) y i) (hi + 1)

/-- **The point of no return is exact.** Within a band under mutual support, condition `i` ends from
a level up to `hi`, the others as in `y` within the band, exactly where its level is below its
threshold. -/
theorem ends_iff_below [DecidableEq ι] (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat}
    (band : Band G H hi) {cs : List ι} (covers : ∀ i, i ∈ cs) {y : ι → Nat} {i : ι} {a : Nat}
    (high : a ≤ hi) (highs : ∀ j, y j ≤ hi) :
    Ends Drawn.whole G H (fun x => x i) (setAt y i a) ↔ a < threshold G H cs hi y i :=
  ⟨fun ends => (Nat.lt_or_ge a (threshold G H cs hi y i)).elim id fun ge =>
      have short : threshold G H cs hi y i < hi + 1 := Nat.lt_of_le_of_lt ge (Nat.lt_succ_of_le high)
      have notEnds : ¬ Ends Drawn.whole G H (fun x => x i) (setAt y i (threshold G H cs hi y i)) :=
        fun e => absurd ((ends_iff rises band covers
          (setAt_within (Nat.le_of_lt_succ short) highs) i).1 e)
          (of_decide_eq_false (leading_false (ending G H (cs.length * hi + 1) y i) (hi + 1) short))
      absurd (ends_of_below rises (fun _ _ b => b i) (setAt_below ge fun j => Nat.le_refl (y j)) ends)
        notEnds,
   fun lt => (ends_iff rises band covers (setAt_within high highs) i).2
      (of_decide_eq_true (leading_true (ending G H (cs.length * hi + 1) y i) (hi + 1) a lt))⟩

/-- **The point of no return does not rise as any other level rises.** Within a band under mutual
support, others' levels at or above `y`'s, within the band, give condition `i` a threshold no
higher. -/
theorem threshold_falls [DecidableEq ι] (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat}
    (band : Band G H hi) {cs : List ι} (covers : ∀ i, i ∈ cs) {y y' : ι → Nat} {i : ι}
    (le : ∀ j, y j ≤ y' j) (highs' : ∀ j, y' j ≤ hi) :
    threshold G H cs hi y' i ≤ threshold G H cs hi y i :=
  (Nat.lt_or_ge (threshold G H cs hi y i) (threshold G H cs hi y' i)).elim
    (fun lt =>
      have high : threshold G H cs hi y i ≤ hi :=
        Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lt (leading_le _ _))
      have highs : ∀ j, y j ≤ hi := fun j => Nat.le_trans (le j) (highs' j)
      have ends := ends_of_below rises (fun _ _ b => b i)
        (setAt_below (Nat.le_refl (threshold G H cs hi y i)) le)
        ((ends_iff_below rises band covers high highs').2 lt)
      absurd ((ends_iff_below rises band covers high highs).1 ends) (Nat.lt_irrefl _))
    id

/-- **Every state in the band has its fate by the threshold.** Within a band under mutual support,
the run from condition `i` at a level up to `hi`, the others as in `y` within the band, is still from
some step at most `cs.length * hi + 1`, where condition `i` is nothing if its level is below its
threshold and something if not. -/
theorem fates [DecidableEq ι] (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat} (band : Band G H hi)
    {cs : List ι} (covers : ∀ i, i ∈ cs) {y : ι → Nat} {i : ι} {a : Nat} (high : a ≤ hi)
    (highs : ∀ j, y j ≤ hi) :
    ∃ N, N ≤ cs.length * hi + 1 ∧
      (∀ k j, (Law.run (step Drawn.whole G H) (setAt y i a)).state (N + k) j =
        (Law.run (step Drawn.whole G H) (setAt y i a)).state N j) ∧
      (a < threshold G H cs hi y i → (Law.run (step Drawn.whole G H) (setAt y i a)).state N i = 0) ∧
      (threshold G H cs hi y i ≤ a → 0 < (Law.run (step Drawn.whole G H) (setAt y i a)).state N i) :=
  match comes_to_rest rises band covers (setAt_within high highs) with
  | ⟨N, le, still⟩ =>
    have gone_iff : Ends Drawn.whole G H (fun x => x i) (setAt y i a) ↔
        (Law.run (step Drawn.whole G H) (setAt y i a)).state N i = 0 :=
      ⟨fun ⟨M, gone⟩ => (still M i).symm.trans
          ((congrArg (fun n => (Law.run (step Drawn.whole G H) (setAt y i a)).state n i)
            (Nat.add_comm N M)).trans (gone N)),
       fun zero => ⟨N, fun k => (still k i).trans zero⟩⟩
    ⟨N, le, still, fun lt => gone_iff.1 ((ends_iff_below rises band covers high highs).2 lt),
     fun ge => Nat.pos_of_ne_zero fun zero => Nat.lt_irrefl _
       (Nat.lt_of_lt_of_le ((ends_iff_below rises band covers high highs).1 (gone_iff.2 zero)) ge)⟩

end Indexed
