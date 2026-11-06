# The statements that move down: each once, at the lowest module its readers share.
PRELUDE = r'''/-! ## Stated once (LM)

Lemmas several modules proved for themselves, moved here in the rebuild of 6 November 2026 so that
each is stated once. -/

namespace Naturals

/-- A power of a product is the product of the powers. -/
theorem mul_pow_eq (x y : Nat) : ∀ n : Nat, (x * y) ^ n = x ^ n * y ^ n
  | 0 => rfl
  | n + 1 => (congrArg (· * (x * y)) (mul_pow_eq x y n)).trans (mul_mul_mul_comm _ _ _ _)

/-- A product below another at one factor has the lower other factor (proved here with no axiom, as
`Nat.lt_of_mul_lt_mul_right` is not). -/
theorem lt_of_mul_lt_mul_right {a b v : Nat} (lt : a * v < b * v) : a < b :=
  match Nat.decLt a b with
  | isTrue below => below
  | isFalse notBelow =>
    absurd lt (Nat.not_lt_of_le (Nat.mul_le_mul_right _ (Nat.ge_of_not_lt notBelow)))

/-- A product below another with the same factor first has the smaller other factor. -/
theorem lt_of_mul_lt_mul_left {m a b : Nat} (below : m * a < m * b) : a < b :=
  match Nat.lt_or_ge a b with
  | .inl lt => lt
  | .inr ge => absurd (Nat.lt_of_lt_of_le below (Nat.mul_le_mul_left m ge)) (Nat.lt_irrefl _)

/-- A positive multiple keeps order strictly. -/
theorem mul_lt_mul_of_pos {m a b : Nat} (pos : 0 < m) (lt : a < b) : m * a < m * b :=
  Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right pos) (Nat.mul_le_mul_left m lt)

/-- A power of two is positive. -/
theorem two_pow_pos : ∀ a, 0 < 2 ^ a
  | 0 => Nat.succ_pos 0
  | a + 1 => Nat.mul_pos (two_pow_pos a) (Nat.succ_pos 1)

/-- A number is below its power of two. -/
theorem lt_two_pow : ∀ n, n < 2 ^ n
  | 0 => Nat.succ_pos 0
  | n + 1 => Nat.lt_of_le_of_lt (Nat.succ_le_of_lt (lt_two_pow n))
      (Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right (two_pow_pos n))
        (Nat.le_of_eq ((Nat.mul_succ (2 ^ n) 1).trans (congrArg (· + 2 ^ n) (Nat.mul_one _))).symm))

/-- Subtracting more leaves no more. -/
theorem sub_antitone (k : Nat) {v w : Nat} (le : v ≤ w) : k - w ≤ k - v := by
  induction le with
  | refl => exact Nat.le_refl _
  | step _ ih => exact Nat.le_trans (Nat.pred_le _) ih

/-- Twice a product of two ordered numbers is at most the sum of their squares. -/
theorem twice_le_of_le {x y : Nat} (le : x ≤ y) : 2 * (x * y) ≤ x * x + y * y :=
  match le_dest le with
  | ⟨e, at_y⟩ => by
    rw [at_y]
    have same : x * x + (x + e) * (x + e) = 2 * (x * (x + e)) + e * e := by
      rw [add_mul_split x e (x + e), Nat.mul_add e x e, Nat.mul_comm e x, Nat.add_left_comm,
        ← Nat.add_assoc (x * x) (x * e) (e * e), ← Nat.mul_add x x e, ← Nat.add_assoc, Nat.two_mul]
    rw [same]
    exact Nat.le_add_right _ _

/-- Twice a product is at most the sum of the squares. -/
theorem twice_le (x y : Nat) : 2 * (x * y) ≤ x * x + y * y :=
  match Nat.le_total x y with
  | .inl le => twice_le_of_le le
  | .inr le => by
    rw [Nat.mul_comm x y, Nat.add_comm (x * x)]
    exact twice_le_of_le le

/-- Adding one amount to both sides keeps a strict order, and only it. -/
theorem add_lt_add_left_iff {k m n : Nat} : k + m < k + n ↔ m < n :=
  ⟨fun lt => le_of_add_le_add_left (k := k) lt, fun lt => Nat.add_lt_add_left lt k⟩

/-- Cancelling the same number added first, strictly. -/
theorem lt_of_add_lt_add_left {k a b : Nat} (lt : k + a < k + b) : a < b :=
  le_of_add_le_add_left (k := k) lt

/-- What is at most `y` with `c` less `y` is at most `c`. -/
theorem sub_le_of_le_add : ∀ {x y c : Nat}, x ≤ y + c → x - y ≤ c
  | _, 0, _, le => Nat.le_trans le (Nat.le_of_eq (Nat.zero_add _))
  | 0, _ + 1, _, _ => Nat.le_trans (Nat.le_of_eq (Nat.zero_sub _)) (Nat.zero_le _)
  | x + 1, y + 1, _, le => (Nat.succ_sub_succ x y).symm ▸
      sub_le_of_le_add (Nat.le_of_succ_le_succ (Nat.le_trans le (Nat.le_of_eq (Nat.succ_add y _))))

/-- A positive sum has a positive part. -/
theorem pos_or_of_add_pos : ∀ {a b : Nat}, 0 < a + b → 0 < a ∨ 0 < b
  | 0, _, pos => .inr (Eq.subst (motive := fun k => 0 < k) (Nat.zero_add _) pos)
  | _ + 1, _, _ => .inl (Nat.succ_pos _)

/-- Four terms regrouped. -/
theorem add_regroup (x y u v : Nat) : (x + y) + (u + v) = (x + v) + (y + u) :=
  (congrArg ((x + y) + ·) (Nat.add_comm u v)).trans (Nat.add_add_add_comm x y v u)

/-- Taking `d` away, adding `r` and giving `d` back is adding `r`. -/
theorem sub_add_refill {n d : Nat} (r : Nat) (le : d ≤ n) : n - d + r + d = n + r :=
  (Nat.add_right_comm (n - d) r d).trans
    (congrArg (· + r) ((Nat.add_comm (n - d) d).trans (add_sub_of_le le)))

end Naturals

namespace ListTests

/-- `all` holding gives the test at each member, the test named. -/
theorem all_sound {α : Type} (p : α → Bool) {l : List α} (h : l.all p = true) :
    ∀ x, x ∈ l → p x = true :=
  all_true_iff.mp h

/-- The test holding at each member gives `all`, the test named. -/
theorem all_complete {α : Type} (p : α → Bool) {l : List α} (h : ∀ x, x ∈ l → p x = true) :
    l.all p = true :=
  all_true_iff.mpr h

/-- What is true has a false negation. -/
theorem not_false_of_true : ∀ {b : Bool}, b = true → (!b) = false
  | true, _ => rfl
  | false, h => Bool.noConfusion h

/-- What a test keeps positive, the test holds at. -/
theorem true_of_cond_pos {b : Bool} {x : Nat} : 0 < (bif b then x else 0) → b = true :=
  match b with
  | true => fun _ => rfl
  | false => fun h => absurd h (Nat.lt_irrefl 0)

/-- An amount kept where a test holds is at most another so kept, where it is at most it there. -/
theorem cond_zero_le {x y : Nat} : ∀ {b : Bool}, (b = true → x ≤ y) → cond b x 0 ≤ cond b y 0
  | true, le => le rfl
  | false, _ => Nat.le_refl 0

/-- An amount kept where a test holds is at most the amount. -/
theorem bif_le (M : Nat) : ∀ b : Bool, (bif b then M else 0) ≤ M
  | true => Nat.le_refl M
  | false => Nat.zero_le M

/-- Two numbers with one `some` are one. -/
theorem some_inj : ∀ a b : Nat, (some a : Option Nat) = some b → a = b :=
  fun _ _ same => congrArg (fun o => Option.getD o 0) same

/-- `none` is no member of a list mapped by `some`. -/
theorem none_not_mem_map_some {α : Type} : ∀ {l : List α}, ¬ (none : Option α) ∈ l.map some
  | [], no => nomatch no
  | _ :: _, .tail _ mem => none_not_mem_map_some mem

/-- Numbers that differ test false. -/
theorem beq_false_of_ne {a b : Nat} (ne : a ≠ b) : Nat.beq a b = false :=
  match h : Nat.beq a b with
  | true => absurd (Nat.eq_of_beq_eq_true h) ne
  | false => rfl

/-- A truth value is not both. -/
theorem bool_absurd {b : Bool} (h : b = true) (h' : b = false) : False :=
  absurd (h.symm.trans h') (by decide)

end ListTests

/-- As `Nat.le_of_sub_eq_zero`, with an empty axiom report. -/
theorem le_of_sub_eq_zero : ∀ {n m : Nat}, n - m = 0 → n ≤ m
  | 0, m, _ => Nat.zero_le m
  | _ + 1, 0, zero => Nat.noConfusion zero
  | n + 1, m + 1, zero =>
    Nat.succ_le_succ (le_of_sub_eq_zero ((Nat.succ_sub_succ n m).symm.trans zero))

/-- A list with a member has a positive length. -/
theorem length_pos_of_mem {α : Type u} {a : α} : ∀ {l : List α}, a ∈ l → 0 < l.length
  | _ :: _, _ => Nat.succ_pos _

/-- A list of length zero is empty. -/
theorem nil_of_length_zero {α : Type u} : ∀ {g : List α}, g.length = 0 → g = []
  | [], _ => rfl
  | _ :: _, len => Nat.noConfusion len

/-- Quantities that agree everywhere have the same total. -/
theorem total_congr {α : Type} {p q : α → Nat} (same : ∀ a, p a = q a) :
    ∀ as : List α, total as p = total as q
  | [] => rfl
  | a :: as => Naturals.add_congr (same a) (total_congr same as)

/-- A quantity zero at every member has total zero. -/
theorem total_eq_zero {α : Type} {q : α → Nat} : ∀ {as : List α}, (∀ a, a ∈ as → q a = 0) → total as q = 0
  | [], _ => rfl
  | a :: _, zero => (congrArg (· + _) (zero a (.head _))).trans
      ((Nat.zero_add _).trans (total_eq_zero fun b mem => zero b (.tail a mem)))

/-- A step that comes no later than `K + 1` is no later than `K` or is `K + 1`. -/
theorem le_succ_cases {n K : Nat} (le : n ≤ K + 1) : n ≤ K ∨ n = K + 1 :=
  match Nat.lt_or_ge n (K + 1) with
  | .inl lt => Or.inl (Nat.le_of_lt_succ lt)
  | .inr ge => Or.inr (Nat.le_antisymm le ge)

/-- How far `j` lies beyond `i`, at least one step. -/
theorem gap_of_lt {i j : Nat} (lt : i < j) : ∃ d, j = i + (d + 1) :=
  let ⟨d, same⟩ := le_dest lt
  ⟨d, same.trans (Nat.succ_add i d)⟩

@@SKIP@@
'''
FLOW_SIGN = r'''
/-- A positive reading has sign one. -/
theorem sign_eq_one : ∀ {n : Nat}, 0 < n → sign n = 1
  | 0, pos => absurd pos (Nat.lt_irrefl 0)
  | _ + 1, _ => rfl

/-- A reading at least where another is positive, as signs. -/
theorem sign_le_of_pos : ∀ {x y : Nat}, (0 < x → 0 < y) → sign x ≤ sign y
  | 0, _, _ => Nat.zero_le _
  | n + 1, 0, keeps => absurd (keeps (Nat.succ_pos n)) (Nat.lt_irrefl 0)
  | _ + 1, _ + 1, _ => Nat.le_refl 1
'''
FLOW_TOTAL = r'''
/-- One member strictly below and none above make the total strictly below. -/
theorem total_lt_of_mem {f g : α → Nat} {a : α} :
    ∀ {as : List α}, a ∈ as → f a < g a → (∀ b, b ∈ as → f b ≤ g b) → total as f < total as g
  | _ :: bs, .head _, lt, le => Nat.lt_of_lt_of_le (Nat.add_lt_add_right lt _)
      (Nat.add_le_add_left (total_le bs fun b mem => le b (.tail _ mem)) _)
  | b :: _, .tail _ mem, lt, le => Nat.lt_of_le_of_lt (Nat.add_le_add_right (le b (.head _)) _)
      (Nat.add_lt_add_left (total_lt_of_mem mem lt fun c mem' => le c (.tail b mem')) _)
'''
CHANGE = r'''
/-- A number exceeds itself by nothing. -/
theorem excess_self : ∀ a : Nat, excess a a = 0
  | 0 => rfl
  | a + 1 => excess_self a

/-- Adding the same to both sides leaves the excess. -/
theorem excess_add_right (x a : Nat) : ∀ k : Nat, excess (x + k) (a + k) = excess x a
  | 0 => rfl
  | k + 1 => excess_add_right x a k

/-- An amount is at most another with its excess over it. -/
theorem le_add_excess (a b : Nat) : a ≤ b + excess a b :=
  Nat.le_trans (Nat.le_add_right a (excess b a)) (Nat.le_of_eq (excess_balance a b))

/-- What exceeds `x` by at most `y` has excess over `x` at most `y`. -/
theorem excess_le_of_le_add : ∀ {u x y : Nat}, u ≤ x + y → excess u x ≤ y
  | 0, _, _, _ => Nat.zero_le _
  | _ + 1, 0, y, le => Nat.le_trans le (Nat.le_of_eq (Nat.zero_add y))
  | u + 1, x + 1, y, le => excess_le_of_le_add (u := u) (x := x) (y := y)
      (Nat.le_of_succ_le_succ (Nat.le_trans le (Nat.le_of_eq (Nat.add_right_comm x 1 y))))
'''
LAWS = r'''
/-- **Under a determined process, two traces of one plan from one configuration end alike.** -/
theorem Trace.determined_end {P : Process S A} (determined : Determined P) :
    ∀ {s t r : S} {plan : List A}, Trace P s plan t → Trace P s plan r → t = r
  | _, _, _, [], .nil _, .nil _ => rfl
  | _, _, _, _ :: _, .cons step rest, .cons step' rest' =>
    match determined _ _ _ _ step step' with
    | rfl => Trace.determined_end determined rest rest'
'''
PLAN = {
 'Hexagram.opposite_false':'ListTests.not_false_of_true','Presence.not_false_of_true':'ListTests.not_false_of_true',
 'Naturals.add_right_cancel':'add_right_cancel _',
 'FreeEnergyCounting.mul_pow_eq':'Naturals.mul_pow_eq','Loops.mul_pow_nat':'Naturals.mul_pow_eq',
 'Propagation.mem_map_pair':'prodMk_mem_map',
 'RevisionRoutes.lt_of_mul_lt_mul':'Naturals.lt_of_mul_lt_mul_right','ReadingSchedule.lt_of_mul_lt_mul':'Naturals.lt_of_mul_lt_mul_right','FreeEnergyCounting.lt_cancel_mul_right':'Naturals.lt_of_mul_lt_mul_right',
 'Optimum.le_of_sub_zero':'le_of_sub_eq_zero','le_of_sub_eq_zero':'le_of_sub_eq_zero',
 'Flow.sign_of_pos':'sign_eq_one','sign_eq_one':'sign_eq_one',
 'OneStep.Chain.sign_le_sign':'sign_le_of_pos','Flow.sign_le_of_pos':'sign_le_of_pos',
 'Weighting.not_of_neg':'ListTests.false_of_not',
 'RuleRebuilding.exists_of_le':'le_dest','Web.exists_steps_between':'le_dest',
 'Hexagram.all_sound':'ListTests.all_sound','Hexagram.all_complete':'ListTests.all_complete',
 'SelectionTerm.excess_of_le':'Flow.excess_zero_of_le',
 'RuleRebuilding.mul_lt_of':'Naturals.lt_of_mul_lt_mul_left','SelectionTerm.lt_of_mul_lt_mul':'Naturals.lt_of_mul_lt_mul_left','Weighting.lt_of_mul_lt':'Naturals.lt_of_mul_lt_mul_left',
 'ReadingSchedule.lt_two_pow':'Naturals.lt_two_pow','Loops.lt_two_pow':'Naturals.lt_two_pow',
 'Loops.two_pow_pos':'Naturals.two_pow_pos','ReadingSchedule.two_pow_pos':'Naturals.two_pow_pos',
 'Clear.and_both':'bool_and_true','Weighting.and_of_parts':'bool_and_true',
 'ReflexivePrediction.Reflecting.sub_antitone':'Naturals.sub_antitone',"RuleRebuilding.sub_le_sub_left'":'Naturals.sub_antitone',
 "RuleRebuilding.mul_assoc'":'mul_assoc_nat','UnreadStandings.assoc_mul':'mul_assoc_nat',
 'Reproduction.twice_le':'Naturals.twice_le','Typicality.two_mul_le':'Naturals.twice_le',
 'Reproduction.twice_le_of_le':'Naturals.twice_le_of_le','Typicality.two_mul_le_of_le':'Naturals.twice_le_of_le',
 'Weighting.mul_swap_right':'Naturals.mul_right_comm',
 'SelectionLevels.nil_of_length_zero':'nil_of_length_zero','SelectionTerm.Generations.nil_of_length_zero':'nil_of_length_zero',
 'Reproduction.mem_append_cases':'mem_append_cases',
 'LineageDrawdown.Drain.pos_of_bif':'ListTests.true_of_cond_pos','PairFlow.cond_pos':'ListTests.true_of_cond_pos',
 'mem_steps_of_between':'steps_of_within',
 'Weighting.add_lt_add_iff':'Naturals.add_lt_add_left_iff','ListingValuation.add_lt_add_left_iff':'Naturals.add_lt_add_left_iff',
 'Propagation.sub_le_of_le_add':'Naturals.sub_le_of_le_add','Reproduction.sub_le_of_le_add':'Naturals.sub_le_of_le_add',
 'Weighting.and_parts':'bool_of_and_true','LineageRegions.Courses.and_split':'bool_of_and_true',
 'RuleRebuilding.split_mul':'add_mul_split',"RuleRebuilding.right_distrib'":'add_mul_split',
 'LineageDrawdown.Drain.left_of_and':'ListTests.and_left','Web.and_left_true':'ListTests.and_left',
 'SelectionShift.excess_shift':'excess_add_right','excess_add_right':'excess_add_right',
 'GrammarLaws.total_congr':'total_congr','total_congr':'total_congr',
 "RuleRebuilding.sub_pos'":'SupportGated.sub_pos_of_lt',
 'PairSelection.and_true_eq':'Bool.and_true','CrossSituational.and_true_right':'Bool.and_true',
 'pos_or_of_add_pos':'Naturals.pos_or_of_add_pos','Continuity.add_pos_cases':'Naturals.pos_or_of_add_pos',
 'ClosedCapture.Drawn.add_swap':'Naturals.add_regroup','RelativePosition.regroup':'Naturals.add_regroup',
 'GrammarLaws.not_eq_true_iff':'ListTests.not_true_iff','WindowedWaiting.boolNot_true_iff':'ListTests.not_true_iff',
 'le_of_add_le_add_left':'Naturals.le_of_add_le_add_left','Remainder.le_of_add_le_add_left_nat':'Naturals.le_of_add_le_add_left','le_of_add_le_add_left_core':'Naturals.le_of_add_le_add_left',
 'Weighting.term_le_of':'ListTests.cond_zero_le','ListingValuation.cond_zero_le':'ListTests.cond_zero_le',
 'CountedCodes.Witness.swap_moves':'ListTests.not_ne_self','ClosedCycle.not_ne':'ListTests.not_ne_self','ReflexivePrediction.not_moves':'ListTests.not_ne_self',
 'Web.steps_cancel':'Naturals.add_left_cancel','add_left_cancel_of_eq':'Naturals.add_left_cancel','Remainder.add_left_cancel_nat':'Naturals.add_left_cancel','Optimum.add_left_cancel_of':'Naturals.add_left_cancel',
 "Limit.or_right'":'ListTests.or_right','Interleavings.LocalLaw.bool_or_of_right':'ListTests.or_right',
 'Emission.some_inj':'ListTests.some_inj','OneStep.Chain.some_inj':'ListTests.some_inj',
 'SelectionTerm.excess_same':'excess_self','excess_self':'excess_self',
 'SelectionShift.length_pos_of_mem':'length_pos_of_mem','RelativePosition.length_pos_of_mem':'length_pos_of_mem',
 'CountedCodes.Witness.swap_involution':'ListTests.not_not',
 'Drift.square_mul':'Reproduction.square_mul',
 'Flow.le_add_excess':'le_add_excess','covered_by_excess':'le_add_excess',
 'Flow.none_not_mem_some':'ListTests.none_not_mem_map_some','none_not_mem':'ListTests.none_not_mem_map_some',
 'Loops.mul_lt_mul_of_pos':'Naturals.mul_lt_mul_of_pos','Weighting.mul_lt_mul_pos':'Naturals.mul_lt_mul_of_pos',
 "RuleRebuilding.le_of_add_le_add_right'":'le_of_add_le_add_right','Naturals.le_of_add_le_add_right':'le_of_add_le_add_right _',
 'ChoiceCountCapture.Witness.two_pos':'Nat.two_pos','RuleShaping.Timing.two_pos':'Nat.two_pos',
 'Flow.excess_le_of_le_add':'excess_le_of_le_add','excess_le_of_covered':'excess_le_of_le_add','OneStep.Witness.excess_le_of':'excess_le_of_le_add',
 'Presence.beq_false_of_ne':'ListTests.beq_false_of_ne','Gluing.Cycle.beq_of_ne':'ListTests.beq_false_of_ne',
 'Optimum.add_four':'Nat.add_add_add_comm','RuleRebuilding.add_four':'Nat.add_add_add_comm','Integers.nat_add_add_add_comm':'Nat.add_add_add_comm',
 'GrammarLaws.gap_of_lt':'gap_of_lt','gap_of_lt':'gap_of_lt',
 'Interleavings.LocalLaw.bool_or_of_left':'ListTests.or_left',"Limit.or_left'":'ListTests.or_left',
 'LineageRegions.Courses.cond_pos':'Thresholds.cond_pos',
 'SelectionTerm.total_zero_of':'total_eq_zero','total_eq_zero':'total_eq_zero',
 'GrammarLaws.mem_cons_split':'mem_cons_cases','mem_cons_split':'mem_cons_cases',
 'GrammarLaws.le_succ_cases':'le_succ_cases','Optimum.le_or_eq_succ':'le_succ_cases','le_succ_cases':'le_succ_cases',
 'Presence.decided_true':'LLPO.decided_true',
 'Blanket.ThresholdDrain.bool_eq_of_iff':'bool_eq_of_iff',
 'SelectionLevels.total_eq_of_mem':'total_congr_on','BlanketWeights.total_congr_mem':'total_congr_on','Weighting.total_congr_on':'total_congr_on',
 "RuleRebuilding.add_sub_cancel'":'Naturals.add_sub_cancel',
 "RuleRebuilding.sub_eq_zero_of_le'":'sub_eq_zero_of_le',
 'Flow.total_lt_of_le_of_mem':'total_lt_of_mem','RelativePosition.total_lt_of_mem':'total_lt_of_mem',
 'WindowedWaiting.boolOr_true_iff':'ListTests.or_true_iff',
 'BlanketCouplings.ThresholdCase.band_congr':'Limit.and_congr2',
 'SelectionShift.Shrinking.split_le':'exists_add_of_le',
 'LineageDrawdown.Drain.right_of_and':'ListTests.and_right','Web.and_right_true':'ListTests.and_right',
 "RuleRebuilding.succ_ne_zero'":'Naturals.succ_ne_zero','LineageRegions.Chain.succ_ne_zero':'Naturals.succ_ne_zero',
 'Weighting.perm4':'Integers.nat_rearrange',
 'split_at_head':'split_at_head','GrammarLaws.split_at_head':'split_at_head',
 'Presence.bool_absurd':'ListTests.bool_absurd',"Limit.true_ne_false'":'ListTests.bool_absurd',
 'UnreadStandings.left_comm_mul':'mul_turn',
 'PairFlow.cond_le':'ListTests.bif_le','Frequency.bif_le':'ListTests.bif_le',
 'Net.fire_add_back':'Naturals.sub_add_refill','Stock.refill':'Naturals.sub_add_refill',
 'Pass.member':'ListTests.mem_bools','RegimeMargin.Coupled.covers_pair':'ListTests.mem_bools',
 'UnreadStandings.total_scaled':'total_mul',
 "PairFlow.lt_of_add_lt_add_left'":'Naturals.lt_of_add_lt_add_left',"RuleRebuilding.lt_of_add_lt_add_left'":'Naturals.lt_of_add_lt_add_left',
 'Drift.Replacement.add_one_add':'shift_succ',
 'GrammarLaws.revisits_within':'revisits_within','revisits_within':'revisits_within',
 'Amounts.fresh_insert':'not_mem_of_middle',
 'AssurancePlans.Trace.determined_end':'Trace.determined_end','Joining.trace_end_unique':'Trace.determined_end',
 '有常则同类者有所缘':'有常则可续',
 'GrammarLaws.skipAt':'skipAt','skipAt':'skipAt','GrammarLaws.skipAt_ne':'skipAt_ne','skipAt_ne':'skipAt_ne','GrammarLaws.skipAt_le':'skipAt_le','skipAt_le':'skipAt_le','GrammarLaws.skipAt_lt':'skipAt_lt','skipAt_lt':'skipAt_lt',
}
