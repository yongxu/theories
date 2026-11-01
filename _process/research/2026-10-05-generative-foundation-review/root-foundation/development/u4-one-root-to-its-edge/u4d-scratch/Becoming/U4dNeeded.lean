import Becoming.GrammarLaws

/-! U4d scratch: each hypothesis of the root forms is needed, by a witness that meets the others
where the conclusion fails. Not part of the package. -/

namespace Becoming

namespace U4d.Needed

theorem pair_eq : ∀ {x y : Nat × Nat}, x.1 = y.1 → x.2 = y.2 → x = y
  | (_, _), (_, _), rfl, rfl => rfl

theorem le_one : ∀ {a : Nat}, a ≤ 1 → a = 0 ∨ a = 1
  | 0, _ => .inl rfl
  | 1, _ => .inr rfl
  | a + 2, h => absurd (Nat.le_of_succ_le_succ h) (Nat.not_succ_le_zero a)

/-- Everything alike. -/
def all : «际» (Nat × Nat) := fun _ _ => True

theorem two_cover (N : Nat) : ∀ x : Nat × Nat, x.2 ≤ 1 → x.1 = N → x ∈ [(N, 0), (N, 1)] :=
  fun _ h at_ => match le_one h with
  | .inl e => Eq.subst (motive := (· ∈ [(N, 0), (N, 1)])) (pair_eq (y := (N, 0)) at_ e).symm
      (.head _)
  | .inr e => Eq.subst (motive := (· ∈ [(N, 0), (N, 1)])) (pair_eq (y := (N, 1)) at_ e).symm
      (.tail _ (.head _))

theorem diag_cover (N : Nat) : ∀ x : Nat × Nat, x.1 = x.2 → x.1 = N → x ∈ [(N, N)] :=
  fun _ h at_ => Eq.subst (motive := (· ∈ [(N, N)]))
    (pair_eq (y := (N, N)) at_ (h.symm.trans at_)).symm (.head _)

/-! ### The count needs fixed successors -/

/-- One occurrence continuing as two. -/
def fork : «际» Nat := fun x y => x = 0 ∧ (y = 1 ∨ y = 2)

theorem one_two {x : Nat} (mx : x ∈ [1, 2]) : x = 1 ∨ x = 2 :=
  match ListTests.mem_cons_iff.mp mx with
  | .inl e => .inl e
  | .inr m => match ListTests.mem_cons_iff.mp m with
    | .inl e => .inr e
    | .inr m => nomatch m

/-- Two endings listed once, both on the line from one member, the member continuing as both: more
endings than members. -/
theorem count_needs_fixed :
    Distinct [1, 2] ∧ (∀ x, x ∈ [1, 2] → ∃ m, m ∈ [0] ∧ «所闭» fork m x) ∧
      (∀ x, x ∈ [1, 2] → ¬ ∃ w, fork x w) ∧ ¬ [1, 2].length ≤ [0].length :=
  ⟨⟨fun mem => (match ListTests.mem_cons_iff.mp mem with
      | .inl e => (by decide : (1 : Nat) ≠ 2) e
      | .inr m => nomatch m), (fun mem => nomatch mem), trivial⟩,
   fun _ mx => ⟨0, .head _, «缘在所闭» ⟨rfl, one_two mx⟩⟩,
   fun _ mx ⟨_, zero, _⟩ => match one_two mx with
     | .inl e => (by decide : (1 : Nat) ≠ 0) (e.symm.trans zero)
     | .inr e => (by decide : (2 : Nat) ≠ 0) (e.symm.trans zero),
   Nat.not_succ_le_self 1⟩

/-! ### The run law needs no split, holding back, and covering lists -/

/-- A line continuing as itself and as a unit that ends, at every stage. -/
def split : «际» (Nat × Nat) := fun x y => y.1 = x.1 + 1 ∧ x.2 = 0 ∧ (y.2 = 0 ∨ y.2 = 1)

/-- Every hypothesis of the decided run law but no split, and no beginning after the first stage. -/
theorem run_needs_noSplit :
    (∀ x y, «续» split all x y → y.1 = x.1 + 1) ∧
    (∀ x y, «续» split all x y → y.2 ≤ 1 → x.2 ≤ 1) ∧
    (∀ M, ∃ N, ∃ L : List (Nat × Nat), M ≤ N ∧ ∀ x : Nat × Nat, x.2 ≤ 1 → x.1 = N → x ∈ L) ∧
    (∀ y : Nat × Nat, y.2 ≤ 1 → «生» split all y ∨ «有前» split all y) ∧
    (∀ M, ∃ x : Nat × Nat, M ≤ x.1 ∧ x.2 ≤ 1 ∧ «亡» split all x) ∧
    ¬ ∀ M, ∃ y : Nat × Nat, M < y.1 ∧ y.2 ≤ 1 ∧ «生» split all y :=
  ⟨fun _ _ ⟨⟨next, _⟩, _⟩ => next,
   fun _ _ ⟨⟨_, zero, _⟩, _⟩ _ => Eq.subst (motive := (· ≤ 1)) zero.symm (Nat.zero_le 1),
   fun M => ⟨M, [(M, 0), (M, 1)], Nat.le_refl M, two_cover M⟩,
   fun y h => match y, h with
     | (0, _), _ => .inl fun ⟨_, ⟨next, _⟩, _⟩ => Nat.noConfusion next
     | (t + 1, _), h => .inr ⟨(t, 0), ⟨rfl, rfl, le_one h⟩, trivial⟩,
   fun M => ⟨(M, 1), Nat.le_refl M, Nat.le_refl 1, fun ⟨_, ⟨_, zero, _⟩, _⟩ => Nat.noConfusion zero⟩,
   fun each => match each 0 with
     | ⟨(0, _), late, _, _⟩ => Nat.lt_irrefl 0 late
     | ⟨(t + 1, _), _, h, b⟩ => b ⟨(t, 0), ⟨rfl, rfl, le_one h⟩, trivial⟩⟩

/-- The relatum `a`'s line, from the first stage to stage `a`, where it ends. -/
def lineTo : «际» (Nat × Nat) := fun x y => y.1 = x.1 + 1 ∧ y.2 = x.2 ∧ x.1 < x.2

theorem lineTo_fixed : ∀ v b b' : Nat × Nat, «续» lineTo all v b → «续» lineTo all v b' → b = b' :=
  fun _ _ _ ⟨⟨n, s, _⟩, _⟩ ⟨⟨n', s', _⟩, _⟩ => pair_eq (n.trans n'.symm) (s.trans s'.symm)

/-- Every hypothesis of the decided run law but holding back: only where each line ends is a unit,
one at each stage. No beginning after the first stage. -/
theorem run_needs_keeps :
    (∀ x y, «续» lineTo all x y → y.1 = x.1 + 1) ∧
    (∀ v b b' : Nat × Nat, b.1 = b.2 → b'.1 = b'.2 → «续» lineTo all v b →
      «续» lineTo all v b' → b = b') ∧
    (∀ M, ∃ N, ∃ L : List (Nat × Nat), M ≤ N ∧ ∀ x : Nat × Nat, x.1 = x.2 → x.1 = N → x ∈ L) ∧
    (∀ y : Nat × Nat, y.1 = y.2 → «生» lineTo all y ∨ «有前» lineTo all y) ∧
    (∀ M, ∃ x : Nat × Nat, M ≤ x.1 ∧ x.1 = x.2 ∧ «亡» lineTo all x) ∧
    ¬ ∀ M, ∃ y : Nat × Nat, M < y.1 ∧ y.1 = y.2 ∧ «生» lineTo all y :=
  ⟨fun _ _ ⟨⟨next, _⟩, _⟩ => next,
   fun v b b' _ _ => lineTo_fixed v b b',
   fun M => ⟨M, [(M, M)], Nat.le_refl M, diag_cover M⟩,
   fun y h => match y, h with
     | (0, _), _ => .inl fun ⟨_, ⟨next, _⟩, _⟩ => Nat.noConfusion next
     | (t + 1, _), h => .inr ⟨(t, _), ⟨rfl, rfl,
         Eq.subst (motive := (t < ·)) h (Nat.lt_succ_self t)⟩, trivial⟩,
   fun M => ⟨(M, M), Nat.le_refl M, rfl, fun ⟨_, ⟨_, _, lt⟩, _⟩ => Nat.lt_irrefl M lt⟩,
   fun each => match each 0 with
     | ⟨(0, _), late, _, _⟩ => Nat.lt_irrefl 0 late
     | ⟨(t + 1, _), _, h, b⟩ => b ⟨(t, _), ⟨rfl, rfl,
         Eq.subst (motive := (t < ·)) h (Nat.lt_succ_self t)⟩, trivial⟩⟩

/-- Every hypothesis of the decided run law but covering lists: each line a unit along its whole
length, infinitely many at the first stage. No beginning after the first stage. -/
theorem run_needs_covering :
    (∀ x y, «续» lineTo all x y → y.1 = x.1 + 1) ∧
    (∀ x y, «续» lineTo all x y → y.1 ≤ y.2 → x.1 ≤ x.2) ∧
    (∀ v b b' : Nat × Nat, b.1 ≤ b.2 → b'.1 ≤ b'.2 → «续» lineTo all v b →
      «续» lineTo all v b' → b = b') ∧
    (∀ y : Nat × Nat, y.1 ≤ y.2 → «生» lineTo all y ∨ «有前» lineTo all y) ∧
    (∀ M, ∃ x : Nat × Nat, M ≤ x.1 ∧ x.1 ≤ x.2 ∧ «亡» lineTo all x) ∧
    ¬ ∀ M, ∃ y : Nat × Nat, M < y.1 ∧ y.1 ≤ y.2 ∧ «生» lineTo all y :=
  ⟨fun _ _ ⟨⟨next, _⟩, _⟩ => next,
   fun _ _ ⟨⟨_, _, lt⟩, _⟩ _ => Nat.le_of_lt lt,
   fun v b b' _ _ => lineTo_fixed v b b',
   fun y h => match y, h with
     | (0, _), _ => .inl fun ⟨_, ⟨next, _⟩, _⟩ => Nat.noConfusion next
     | (t + 1, _), h => .inr ⟨(t, _), ⟨rfl, rfl, h⟩, trivial⟩,
   fun M => ⟨(M, M), Nat.le_refl M, Nat.le_refl M, fun ⟨_, ⟨_, _, lt⟩, _⟩ => Nat.lt_irrefl M lt⟩,
   fun each => match each 0 with
     | ⟨(0, _), late, _, _⟩ => Nat.lt_irrefl 0 late
     | ⟨(t + 1, _), _, h, b⟩ => b ⟨(t, _), ⟨rfl, rfl, h⟩, trivial⟩⟩

/-! ### The decided form needs a decision -/

/-- A line continuing as itself where `Q` holds, and as a unit that ends where `Q` fails. -/
def choose (Q : Prop) : «际» (Nat × Nat) :=
  fun x y => y.1 = x.1 + 1 ∧ x.2 = 0 ∧ ((y.2 = 0 ∧ Q) ∨ (y.2 = 1 ∧ ¬ Q))

theorem choose_zero {Q : Prop} {t : Nat} (nq : ¬ Q) : «生» (choose Q) all (t + 1, 0) :=
  fun ⟨_, ⟨_, _, c⟩, _⟩ => match c with
  | .inl ⟨_, q⟩ => nq q
  | .inr ⟨e, _⟩ => Nat.noConfusion e

theorem choose_one {Q : Prop} {t : Nat} (nnq : ¬¬ Q) : «生» (choose Q) all (t + 1, 1) :=
  fun ⟨_, ⟨_, _, c⟩, _⟩ => match c with
  | .inl ⟨e, _⟩ => Nat.noConfusion e
  | .inr ⟨_, nq⟩ => nnq nq

/-- For any proposition `Q`, every hypothesis of the run law but the decision holds; the decision
holds exactly where `Q` is decided, and beginnings recurring exactly where `Q` fails or cannot
fail. So the run law's form with a beginning found, asked with no decision, would give weak
excluded middle for every proposition; asked as not refuted (`U4d.cover_unrefuted`), it asks none. -/
theorem run_needs_decision (Q : Prop) :
    (∀ x y, «续» (choose Q) all x y → y.1 = x.1 + 1) ∧
    (∀ x y, «续» (choose Q) all x y → y.2 ≤ 1 → x.2 ≤ 1) ∧
    (∀ v b b' : Nat × Nat, b.2 ≤ 1 → b'.2 ≤ 1 → «续» (choose Q) all v b →
      «续» (choose Q) all v b' → b = b') ∧
    (∀ M, ∃ N, ∃ L : List (Nat × Nat), M ≤ N ∧ ∀ x : Nat × Nat, x.2 ≤ 1 → x.1 = N → x ∈ L) ∧
    (∀ M, ∃ x : Nat × Nat, M ≤ x.1 ∧ x.2 ≤ 1 ∧ «亡» (choose Q) all x) ∧
    ((∀ y : Nat × Nat, y.2 ≤ 1 → «生» (choose Q) all y ∨ «有前» (choose Q) all y) ↔ (Q ∨ ¬ Q)) ∧
    ((∀ M, ∃ y : Nat × Nat, M < y.1 ∧ y.2 ≤ 1 ∧ «生» (choose Q) all y) ↔ (¬ Q ∨ ¬¬ Q)) :=
  ⟨fun _ _ ⟨⟨next, _⟩, _⟩ => next,
   fun _ _ ⟨⟨_, zero, _⟩, _⟩ _ => Eq.subst (motive := (· ≤ 1)) zero.symm (Nat.zero_le 1),
   fun _ _ _ _ _ ⟨⟨n, _, c⟩, _⟩ ⟨⟨n', _, c'⟩, _⟩ => pair_eq (n.trans n'.symm) (match c, c' with
     | .inl ⟨e, _⟩, .inl ⟨e', _⟩ => e.trans e'.symm
     | .inr ⟨e, _⟩, .inr ⟨e', _⟩ => e.trans e'.symm
     | .inl ⟨_, q⟩, .inr ⟨_, nq⟩ => (nq q).elim
     | .inr ⟨_, nq⟩, .inl ⟨_, q⟩ => (nq q).elim),
   fun M => ⟨M, [(M, 0), (M, 1)], Nat.le_refl M, two_cover M⟩,
   fun M => ⟨(M, 1), Nat.le_refl M, Nat.le_refl 1, fun ⟨_, ⟨_, zero, _⟩, _⟩ => Nat.noConfusion zero⟩,
   ⟨fun decided => match decided (1, 0) (Nat.zero_le 1) with
      | .inl b => .inr fun q => b ⟨(0, 0), ⟨rfl, rfl, .inl ⟨rfl, q⟩⟩, trivial⟩
      | .inr ⟨_, ⟨_, _, c⟩, _⟩ => match c with
        | .inl ⟨_, q⟩ => .inl q
        | .inr ⟨e, _⟩ => Nat.noConfusion e,
    fun lem y h => match y, h, lem with
      | (0, _), _, _ => .inl fun ⟨_, ⟨next, _⟩, _⟩ => Nat.noConfusion next
      | (t + 1, 0), _, .inl q => .inr ⟨(t, 0), ⟨rfl, rfl, .inl ⟨rfl, q⟩⟩, trivial⟩
      | (_ + 1, 0), _, .inr nq => .inl (choose_zero nq)
      | (_ + 1, 1), _, .inl q => .inl (choose_one fun nq => nq q)
      | (t + 1, 1), _, .inr nq => .inr ⟨(t, 0), ⟨rfl, rfl, .inr ⟨rfl, nq⟩⟩, trivial⟩
      | (_ + 1, a + 2), h, _ => absurd (Nat.le_of_succ_le_succ h) (Nat.not_succ_le_zero a)⟩,
   ⟨fun each => match each 0 with
      | ⟨(0, _), late, _, _⟩ => (Nat.lt_irrefl 0 late).elim
      | ⟨(t + 1, 0), _, _, b⟩ => .inl fun q => b ⟨(t, 0), ⟨rfl, rfl, .inl ⟨rfl, q⟩⟩, trivial⟩
      | ⟨(t + 1, 1), _, _, b⟩ => .inr fun nq => b ⟨(t, 0), ⟨rfl, rfl, .inr ⟨rfl, nq⟩⟩, trivial⟩
      | ⟨(_ + 1, a + 2), _, h, _⟩ => absurd (Nat.le_of_succ_le_succ h) (Nat.not_succ_le_zero a),
    fun wlem M => match wlem with
      | .inl nq => ⟨(M + 1, 0), Nat.lt_succ_self M, Nat.zero_le 1, choose_zero nq⟩
      | .inr nnq => ⟨(M + 1, 1), Nat.lt_succ_self M, Nat.le_refl 1, choose_one nnq⟩⟩⟩

/-! ### The converse needs no merge, a bound, and holding on -/

/-- Each stage's two units continuing as one, a beginning at every stage. -/
def merge : «际» (Nat × Nat) := fun x y => y.1 = x.1 + 1 ∧ x.2 ≤ 1 ∧ y.2 = 0

/-- Every hypothesis of the converse but no merge, and nothing ever ends. -/
theorem converse_needs_noMerge :
    (∀ x y, «续» merge all x y → y.1 = x.1 + 1) ∧
    (∀ x y, «续» merge all x y → x.2 ≤ 1 → y.2 ≤ 1) ∧
    (∀ S, 0 ≤ S → ∃ L : List (Nat × Nat), L.length ≤ 2 ∧
      ∀ x : Nat × Nat, x.2 ≤ 1 → x.1 = S → x ∈ L) ∧
    (∀ M, ∃ x : Nat × Nat, M ≤ x.1 ∧ x.2 ≤ 1 ∧ «生» merge all x) ∧
    ∃ N, ∀ x : Nat × Nat, N ≤ x.1 → x.2 ≤ 1 → ¬ «亡» merge all x :=
  ⟨fun _ _ ⟨⟨next, _⟩, _⟩ => next,
   fun _ _ ⟨⟨_, _, zero⟩, _⟩ _ => Eq.subst (motive := (· ≤ 1)) zero.symm (Nat.zero_le 1),
   fun S _ => ⟨[(S, 0), (S, 1)], Nat.le_refl 2, two_cover S⟩,
   fun M => ⟨(M, 1), Nat.le_refl M, Nat.le_refl 1, fun ⟨_, ⟨_, _, zero⟩, _⟩ => Nat.noConfusion zero⟩,
   ⟨0, fun x _ h ends => ends ⟨(x.1 + 1, 0), ⟨rfl, h, rfl⟩, trivial⟩⟩⟩

/-- Each relatum's line from stage `a` on, never ending. -/
def lineFrom : «际» (Nat × Nat) := fun x y => y.1 = x.1 + 1 ∧ y.2 = x.2 ∧ x.2 ≤ x.1

theorem lineFrom_once : ∀ v a a' : Nat × Nat, «续» lineFrom all a v → «续» lineFrom all a' v →
    a = a' :=
  fun _ _ _ ⟨⟨n, s, _⟩, _⟩ ⟨⟨n', s', _⟩, _⟩ => pair_eq (Nat.succ.inj (n.symm.trans n'))
    (s.symm.trans s')

theorem lineFrom_begins (M : Nat) : «生» lineFrom all (M, M) :=
  fun ⟨x, ⟨n, s, le⟩, _⟩ => Nat.not_succ_le_self x.1
    (Eq.subst (motive := (· ≤ x.1)) (s.symm.trans n) le)

/-- Every hypothesis of the converse but a bound on the covering lists, and nothing ever ends. -/
theorem converse_needs_bound :
    (∀ x y, «续» lineFrom all x y → y.1 = x.1 + 1) ∧
    (∀ x y, «续» lineFrom all x y → x.2 ≤ x.1 → y.2 ≤ y.1) ∧
    (∀ v a a' : Nat × Nat, a.2 ≤ a.1 → a'.2 ≤ a'.1 → «续» lineFrom all a v →
      «续» lineFrom all a' v → a = a') ∧
    (∀ M, ∃ x : Nat × Nat, M ≤ x.1 ∧ x.2 ≤ x.1 ∧ «生» lineFrom all x) ∧
    ∃ N, ∀ x : Nat × Nat, N ≤ x.1 → x.2 ≤ x.1 → ¬ «亡» lineFrom all x :=
  ⟨fun _ _ ⟨⟨next, _⟩, _⟩ => next,
   fun _ _ ⟨⟨n, s, _⟩, _⟩ h => Nat.le_trans (Nat.le_of_eq s)
     (Nat.le_trans h (Nat.le_trans (Nat.le_succ _) (Nat.le_of_eq n.symm))),
   fun v a a' _ _ => lineFrom_once v a a',
   fun M => ⟨(M, M), Nat.le_refl M, Nat.le_refl M, lineFrom_begins M⟩,
   ⟨0, fun x _ h ends => ends ⟨(x.1 + 1, x.2), ⟨rfl, rfl, h⟩, trivial⟩⟩⟩

/-- Every hypothesis of the converse but holding on: only where each line begins is a unit, one
at each stage. Nothing ever ends. -/
theorem converse_needs_keepsOn :
    (∀ x y, «续» lineFrom all x y → y.1 = x.1 + 1) ∧
    (∀ v a a' : Nat × Nat, a.1 = a.2 → a'.1 = a'.2 → «续» lineFrom all a v →
      «续» lineFrom all a' v → a = a') ∧
    (∀ S, 0 ≤ S → ∃ L : List (Nat × Nat), L.length ≤ 1 ∧
      ∀ x : Nat × Nat, x.1 = x.2 → x.1 = S → x ∈ L) ∧
    (∀ M, ∃ x : Nat × Nat, M ≤ x.1 ∧ x.1 = x.2 ∧ «生» lineFrom all x) ∧
    ∃ N, ∀ x : Nat × Nat, N ≤ x.1 → x.1 = x.2 → ¬ «亡» lineFrom all x :=
  ⟨fun _ _ ⟨⟨next, _⟩, _⟩ => next,
   fun v a a' _ _ => lineFrom_once v a a',
   fun S _ => ⟨[(S, S)], Nat.le_refl 1, diag_cover S⟩,
   fun M => ⟨(M, M), Nat.le_refl M, rfl, lineFrom_begins M⟩,
   ⟨0, fun x _ h ends => ends ⟨(x.1 + 1, x.2), ⟨rfl, rfl, Nat.le_of_eq h.symm⟩, trivial⟩⟩⟩

end U4d.Needed

end Becoming
