
/-! #### Beyond a band: a bound on the run

Without a band, a web's run under mutual support need not rest (`Relay.cycles`). Where a run stays
within a bound, its states are among finitely many lists of levels, so by pigeonhole it comes back to
a state it was in, and from there it repeats. These laws are stated once for any law `f` of states
that reads them condition by condition (`ReadsPointwise`): the web's step is one
(`pointwise_step`), and a web with a recent giving another (`Recent.step`). Whether a condition ends
is then decided by a finite check, with no band and no order of states. Where the law keeps the order
of states (`KeepsBelow`), as the web's step does under mutual support (`step_keepsBelow`), it reads
condition by condition (`reads_of_keepsBelow`), and each condition's point of no return, given the
others, is exact wherever the run from the top of the levels considered stays within the bound, and
does not rise as any other level rises. -/

/-- The levels of the listed conditions, in order. -/
def levels (x : ι → Nat) : List ι → List Nat
  | [] => []
  | c :: cs => x c :: levels x cs

/-- Two states with the same listed levels are alike at every listed condition. -/
theorem levels_alike {x y : ι → Nat} :
    ∀ {cs : List ι}, levels x cs = levels y cs → ∀ i, i ∈ cs → x i = y i
  | [], _, _, mem => nomatch mem
  | _ :: _, same, _, .head _ => (List.cons.inj same).1
  | _ :: _, same, i, .tail _ mem => levels_alike (List.cons.inj same).2 i mem

/-- Each listed list with `a` put first. -/
def withFirst (a : Nat) : List (List Nat) → List (List Nat)
  | [] => []
  | l :: ls => (a :: l) :: withFirst a ls

/-- Each listed list with each of `0, …, b` put first. -/
def withFirstUpTo (ls : List (List Nat)) : Nat → List (List Nat)
  | 0 => withFirst 0 ls
  | b + 1 => withFirst (b + 1) ls ++ withFirstUpTo ls b

/-- **Every list of `k` levels, each at most `B`.** -/
def levelLists (B : Nat) : Nat → List (List Nat)
  | 0 => [[]]
  | k + 1 => withFirstUpTo (levelLists B k) B

theorem withFirst_length (a : Nat) : ∀ ls : List (List Nat), (withFirst a ls).length = ls.length
  | [] => rfl
  | _ :: ls => congrArg (· + 1) (withFirst_length a ls)

theorem withFirstUpTo_length (ls : List (List Nat)) :
    ∀ b, (withFirstUpTo ls b).length = (b + 1) * ls.length
  | 0 => (withFirst_length 0 ls).trans (Nat.one_mul _).symm
  | b + 1 => (ListTests.length_append _ _).trans
      ((congr (congrArg (· + ·) (withFirst_length (b + 1) ls)) (withFirstUpTo_length ls b)).trans
        ((Nat.add_comm _ _).trans (Nat.succ_mul (b + 1) ls.length).symm))

/-- There are `(B + 1) ^ k` lists of `k` levels each at most `B`. -/
theorem levelLists_length (B : Nat) : ∀ k, (levelLists B k).length = (B + 1) ^ k
  | 0 => rfl
  | k + 1 => (withFirstUpTo_length (levelLists B k) B).trans
      ((congrArg ((B + 1) * ·) (levelLists_length B k)).trans (Nat.mul_comm _ _))

theorem mem_withFirst {a : Nat} {l : List Nat} : ∀ {ls : List (List Nat)}, l ∈ ls → a :: l ∈ withFirst a ls
  | _ :: _, .head _ => .head _
  | _ :: _, .tail _ mem => .tail _ (mem_withFirst mem)

theorem mem_withFirstUpTo {l : List Nat} {ls : List (List Nat)} (mem : l ∈ ls) :
    ∀ {a : Nat} (b : Nat), a ≤ b → a :: l ∈ withFirstUpTo ls b
  | _, 0, le => Eq.subst (motive := fun v => v :: l ∈ withFirst 0 ls) (Nat.eq_zero_of_le_zero le).symm
      (mem_withFirst mem)
  | a, b + 1, le => (Nat.lt_or_ge a (b + 1)).elim
      (fun lt => List.mem_append_right _ (mem_withFirstUpTo mem b (Nat.le_of_lt_succ lt)))
      (fun ge => Eq.subst (motive := fun v => v :: l ∈ withFirstUpTo ls (b + 1))
        (Nat.le_antisymm ge le) (List.mem_append_left _ (mem_withFirst mem)))

/-- The levels of a state with every level at most `B` are among the lists of levels at most `B`. -/
theorem levels_mem {B : Nat} {x : ι → Nat} (high : ∀ i, x i ≤ B) :
    ∀ cs : List ι, levels x cs ∈ levelLists B cs.length
  | [] => .head _
  | c :: cs => mem_withFirstUpTo (levels_mem high cs) B (high c)

/-- **A condition ends under a law**: from some step on, its level is nothing. A web's `Ends` at a
condition is this for the web's step. -/
def EndsUnder (f : (ι → Nat) → (ι → Nat)) (c : ι) (s : ι → Nat) : Prop :=
  ∃ N, ∀ k, (Law.run f s).state (N + k) c = 0

/-- **A law keeps the order of states**, condition by condition. -/
def KeepsBelow (f : (ι → Nat) → (ι → Nat)) : Prop :=
  ∀ x y, Below Drawn.whole x y → Below Drawn.whole (f x) (f y)

/-- Under mutual support the web's step keeps the order of states. -/
theorem step_keepsBelow (rises : ∀ i, Rises Drawn.whole (G i)) : KeepsBelow (step Drawn.whole G H) :=
  fun _ _ below => step_mono rises H below

/-- **A law keeping the order of states reads them condition by condition**, by antisymmetry. -/
theorem reads_of_keepsBelow {f : (ι → Nat) → (ι → Nat)} (keeps : KeepsBelow f) : ReadsPointwise f :=
  fun _ _ same i => Nat.le_antisymm (keeps _ _ (fun j => Nat.le_of_eq (same j)) i)
    (keeps _ _ (fun j => Nat.le_of_eq (same j).symm) i)

/-- Runs of a law keeping the order keep it at every step. -/
theorem run_below_of {f : (ι → Nat) → (ι → Nat)} (keeps : KeepsBelow f) {x y : ι → Nat}
    (below : Below Drawn.whole x y) :
    ∀ n, Below Drawn.whole ((Law.run f x).state n) ((Law.run f y).state n) :=
  Lasting.orbit_mono (rel := Below Drawn.whole) keeps below

/-- Under a law keeping the order, a condition ending from a state ends from every state below it. -/
theorem endsUnder_of_below {f : (ι → Nat) → (ι → Nat)} (keeps : KeepsBelow f) {c : ι} {x y : ι → Nat}
    (below : Below Drawn.whole x y) (ends : EndsUnder f c y) : EndsUnder f c x :=
  match ends with
  | ⟨N, gone⟩ => ⟨N, fun k => Nat.le_antisymm (Nat.le_trans (run_below_of keeps below (N + k) c)
      (Nat.le_of_eq (gone k))) (Nat.zero_le _)⟩

/-- **A run that reaches a state its law leaves as it is stays there**, condition by condition. -/
theorem stays_at {f : (ι → Nat) → (ι → Nat)} (reads : ReadsPointwise f) {s p : ι → Nat} {m : Nat}
    (at_ : ∀ c, (Law.run f s).state m c = p c) (fixed : ∀ c, f p c = p c) :
    ∀ k c, (Law.run f s).state (m + k) c = p c
  | 0, c => at_ c
  | k + 1, c => (reads _ _ (stays_at reads at_ fixed k) c).trans (fixed c)

/-- **The run from `s` stays within `B`**: every level at every step is at most `B`. -/
def StaysWithin (f : (ι → Nat) → (ι → Nat)) (B : Nat) (s : ι → Nat) : Prop :=
  ∀ n i, (Law.run f s).state n i ≤ B

/-- Under a law keeping the order, below a run that stays within `B`, every run stays within it. -/
theorem within_below {f : (ι → Nat) → (ι → Nat)} (keeps : KeepsBelow f) {B : Nat} {x y : ι → Nat}
    (below : Below Drawn.whole x y) (within : StaysWithin f B y) : StaysWithin f B x :=
  fun n i => Nat.le_trans (run_below_of keeps below n i) (within n i)

/-- **A run within a bound comes back.** For finitely many conditions, listed by `cs`, a run that stays
within `B` is, at some step `j` at most `(B + 1) ^ cs.length`, at every condition as it was at an
earlier step `i`. -/
theorem returns_within {f : (ι → Nat) → (ι → Nat)} {cs : List ι} (covers : ∀ i, i ∈ cs) {B : Nat}
    {s : ι → Nat} (within : StaysWithin f B s) :
    ∃ i j, i < j ∧ j ≤ (B + 1) ^ cs.length ∧ ∀ c,
      (Law.run f s).state i c = (Law.run f s).state j c :=
  match revisits_within (levelLists B cs.length)
      (fun n => levels ((Law.run f s).state n) cs)
      (fun n _ => levels_mem (within n) cs) with
  | ⟨i, j, lt, le, same⟩ => ⟨i, j, lt, Nat.le_trans le (Nat.le_of_eq (levelLists_length B cs.length)),
      fun c => levels_alike same c (covers c)⟩

/-- **A run that comes back repeats.** Where the law reads states condition by condition and the run is
at step `j` as it was at step `i`, condition by condition, it is at step `i + m` as at step `j + m`, for
every `m`. -/
theorem repeats {f : (ι → Nat) → (ι → Nat)} (reads : ReadsPointwise f) {s : ι → Nat} {i j : Nat}
    (same : ∀ c, (Law.run f s).state i c = (Law.run f s).state j c) :
    ∀ m c, (Law.run f s).state (i + m) c =
      (Law.run f s).state (j + m) c := fun m c =>
  (congrArg (· c) (Law.orbit_add f s i m)).trans
    ((run_alike_of reads same m c).trans (congrArg (· c) (Law.orbit_add f s j m)).symm)

/-- A sequence repeating with period `p` from step `i` repeats with every multiple of `p`. -/
theorem repeats_mul {f : Nat → Nat} {i p : Nat} (period : ∀ t, i ≤ t → f t = f (t + p)) :
    ∀ q t, i ≤ t → f t = f (t + p * q)
  | 0, _, _ => rfl
  | q + 1, t, le => (repeats_mul period q t le).trans
      ((period (t + p * q) (Nat.le_trans le (Nat.le_add_right t _))).trans
        (congrArg f (Nat.add_assoc t (p * q) p)))

/-- A sequence repeating with a positive period `p` from step `i`, at most `L` with `p` at most `L + 1`,
is nothing from step `L` on wherever it is nothing at every step from `L` to `2 L`. -/
theorem zero_from_window {f : Nat → Nat} {i p L : Nat} (period : ∀ t, i ≤ t → f t = f (t + p))
    (pos : 0 < p) (start : i ≤ L) (short : p ≤ L + 1) (window : ∀ m, m ≤ L → f (L + m) = 0) :
    ∀ fuel m, m ≤ fuel → f (L + m) = 0
  | 0, m, le => window m (Nat.le_trans le (Nat.zero_le L))
  | fuel + 1, m, le => (Nat.lt_or_ge L m).elim
      (fun big =>
        have pm : p ≤ m := Nat.le_trans short big
        have back : L + (m - p) + p = L + m :=
          (Nat.add_assoc L (m - p) p).trans (congrArg (L + ·) (Naturals.sub_add_cancel pm))
        have fewer : m - p ≤ fuel :=
          Nat.le_trans (Optimum.sub_le_sub_left_of_le pos m) (Nat.sub_le_sub_right le 1)
        (congrArg f back).symm.trans
          ((period (L + (m - p)) (Nat.le_trans start (Nat.le_add_right L _))).symm.trans
            (zero_from_window period pos start short window fuel (m - p) fewer)))
      (fun small => window m small)

/-- **Whether a condition ends is decided within the count of states.** For finitely many conditions,
listed by `cs`, where the law reads states condition by condition and the run stays within `B`,
condition `c` ends exactly where it is nothing at every step from `L` to `2 L`, `L` being
`(B + 1) ^ cs.length`, the number of lists of levels within `B`; and where it ends it is nothing from
step `L` on. No band, no order of states and no omniscience is needed. -/
theorem ends_iff_within {f : (ι → Nat) → (ι → Nat)} (reads : ReadsPointwise f) {cs : List ι}
    (covers : ∀ i, i ∈ cs) {B : Nat} {s : ι → Nat} (within : StaysWithin f B s) (c : ι) :
    (EndsUnder f c s ↔ ∀ m, m ≤ (B + 1) ^ cs.length →
      (Law.run f s).state ((B + 1) ^ cs.length + m) c = 0) ∧
    (EndsUnder f c s → ∀ k,
      (Law.run f s).state ((B + 1) ^ cs.length + k) c = 0) :=
  match returns_within covers within with
  | ⟨i, j, lt, le, same⟩ =>
    have jpi : i + (j - i) = j := Becoming.add_sub_of_le (Nat.le_of_lt lt)
    have period : ∀ t, i ≤ t → (Law.run f s).state t c =
        (Law.run f s).state (t + (j - i)) c := fun t le =>
      have tt : i + (t - i) = t := Becoming.add_sub_of_le le
      (congrArg (fun n => (Law.run f s).state n c) tt).symm.trans
        ((repeats reads same (t - i) c).trans
          (congrArg (fun n => (Law.run f s).state n c)
            (((congrArg (· + (t - i)) jpi).symm.trans (Nat.add_right_comm i (j - i) (t - i))).trans
              (congrArg (· + (j - i)) tt))))
    have pos : 0 < j - i := SupportGated.sub_pos_of_lt lt
    have start : i ≤ (B + 1) ^ cs.length := Nat.le_trans (Nat.le_of_lt lt) le
    have short : j - i ≤ (B + 1) ^ cs.length + 1 :=
      Nat.le_trans (Nat.sub_le j i) (Nat.le_trans le (Nat.le_succ _))
    have toWindow : EndsUnder f c s → ∀ m, m ≤ (B + 1) ^ cs.length →
        (Law.run f s).state ((B + 1) ^ cs.length + m) c = 0 :=
      fun ⟨N, gone⟩ m _ =>
        have far : N ≤ (B + 1) ^ cs.length + m + (j - i) * N :=
          Nat.le_trans (Nat.le_of_eq (Nat.one_mul N).symm)
            (Nat.le_trans (Nat.mul_le_mul_right N pos) (Nat.le_add_left _ _))
        (repeats_mul period N _ (Nat.le_trans start (Nat.le_add_right _ m))).trans
          ((congrArg (fun n => (Law.run f s).state n c)
            (Becoming.add_sub_of_le far).symm).trans (gone _))
    have fromWindow : (∀ m, m ≤ (B + 1) ^ cs.length →
        (Law.run f s).state ((B + 1) ^ cs.length + m) c = 0) → ∀ k,
        (Law.run f s).state ((B + 1) ^ cs.length + k) c = 0 :=
      fun window k => zero_from_window period pos start short window k k (Nat.le_refl k)
    ⟨⟨toWindow, fun window => ⟨(B + 1) ^ cs.length, fromWindow window⟩⟩,
     fun ends => fromWindow (toWindow ends)⟩

/-- The levels below `n` all pass the check `f`, where each does. -/
theorem below_of {f : Nat → Bool} : ∀ {n}, (∀ z, z < n → f z = true) → below f n = true
  | 0, _ => rfl
  | n + 1, all => by
    show (f n && below f n) = true
    rw [all n (Nat.lt_succ_self n)]
    exact below_of fun z lt => all z (Nat.lt_succ_of_lt lt)

/-- Whether condition `i`, from level `a` with the others as in `y`, is nothing at every step from `L`
to `2 L`. -/
def endingWithin [DecidableEq ι] (f : (ι → Nat) → (ι → Nat)) (L : Nat) (y : ι → Nat) (i : ι)
    (a : Nat) : Bool :=
  below (fun m => decide ((Law.run f (setAt y i a)).state (L + m) i = 0)) (L + 1)

/-- **Condition `i`'s point of no return beyond a band, the others as in `y`.** The least level up to
`hi + 1` from which condition `i` is not nothing at every step from `L` to `2 L`, `L` the number of
lists of levels within `B`. -/
def thresholdWithin [DecidableEq ι] (f : (ι → Nat) → (ι → Nat)) (cs : List ι) (B hi : Nat)
    (y : ι → Nat) (i : ι) : Nat :=
  leading (endingWithin f ((B + 1) ^ cs.length) y i) (hi + 1)

/-- Within a bound, the finite check says whether a condition ends. -/
theorem ending_iff [DecidableEq ι] {f : (ι → Nat) → (ι → Nat)} (reads : ReadsPointwise f)
    {cs : List ι} (covers : ∀ i, i ∈ cs) {B : Nat} {y : ι → Nat} {i : ι} {a : Nat}
    (within : StaysWithin f B (setAt y i a)) :
    EndsUnder f i (setAt y i a) ↔ endingWithin f ((B + 1) ^ cs.length) y i a = true :=
  (ends_iff_within reads covers within i).1.trans
    ⟨fun zero => below_of fun m lt => decide_eq_true (zero m (Nat.le_of_lt_succ lt)),
     fun check m le => of_decide_eq_true (below_spec check m (Nat.lt_succ_of_le le))⟩

/-- **The point of no return is exact beyond a band.** Under a law keeping the order of states, for
finitely many conditions, where the run from condition `i` at `hi`, the others as in `y`, stays within
`B`, condition `i` ends from a level up to `hi` exactly where its level is below `thresholdWithin`. -/
theorem ends_iff_below_within [DecidableEq ι] {f : (ι → Nat) → (ι → Nat)} (keeps : KeepsBelow f)
    {cs : List ι} (covers : ∀ i, i ∈ cs) {B hi : Nat} {y : ι → Nat} {i : ι} {a : Nat}
    (within : StaysWithin f B (setAt y i hi)) (high : a ≤ hi) :
    EndsUnder f i (setAt y i a) ↔ a < thresholdWithin f cs B hi y i :=
  have reads := reads_of_keepsBelow keeps
  have withinAt : ∀ {b}, b ≤ hi → StaysWithin f B (setAt y i b) := fun le =>
    within_below keeps (setAt_below le fun j => Nat.le_refl (y j)) within
  ⟨fun ends => (Nat.lt_or_ge a (thresholdWithin f cs B hi y i)).elim id fun ge =>
      have short : thresholdWithin f cs B hi y i < hi + 1 :=
        Nat.lt_of_le_of_lt ge (Nat.lt_succ_of_le high)
      have notEnds : ¬ EndsUnder f i (setAt y i (thresholdWithin f cs B hi y i)) :=
        fun e => Bool.noConfusion ((leading_false (endingWithin f ((B + 1) ^ cs.length) y i) (hi + 1)
          short).symm.trans ((ending_iff reads covers (withinAt (Nat.le_of_lt_succ short))).1 e))
      absurd (endsUnder_of_below keeps (setAt_below ge fun j => Nat.le_refl (y j)) ends) notEnds,
   fun lt => (ending_iff reads covers (withinAt high)).2
      (leading_true (endingWithin f ((B + 1) ^ cs.length) y i) (hi + 1) a lt)⟩

/-- **Beyond a band, the point of no return does not rise as any other level rises.** Under a law
keeping the order of states, where the run from condition `i` at `hi`, the others as in `y'`, stays
within `B`, others' levels at or below `y'` give condition `i` a threshold no lower than `y'` gives. -/
theorem threshold_falls_within [DecidableEq ι] {f : (ι → Nat) → (ι → Nat)} (keeps : KeepsBelow f)
    {cs : List ι} (covers : ∀ i, i ∈ cs) {B hi : Nat} {y y' : ι → Nat} {i : ι} (le : ∀ j, y j ≤ y' j)
    (within' : StaysWithin f B (setAt y' i hi)) :
    thresholdWithin f cs B hi y' i ≤ thresholdWithin f cs B hi y i :=
  have within : StaysWithin f B (setAt y i hi) :=
    within_below keeps (setAt_below (Nat.le_refl hi) le) within'
  (Nat.lt_or_ge (thresholdWithin f cs B hi y i) (thresholdWithin f cs B hi y' i)).elim
    (fun lt =>
      have high : thresholdWithin f cs B hi y i ≤ hi :=
        Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lt (leading_le _ _))
      have ends := endsUnder_of_below keeps
        (setAt_below (Nat.le_refl (thresholdWithin f cs B hi y i)) le)
        ((ends_iff_below_within keeps covers within' high).2 lt)
      absurd ((ends_iff_below_within keeps covers within high).1 ends) (Nat.lt_irrefl _))
    id
