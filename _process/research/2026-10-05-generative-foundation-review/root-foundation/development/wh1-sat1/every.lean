/-! ## A whole of every part, and a graded whole -/

section Every

variable (W)

/-- `w` is the whole of *every* part satisfying `parts`: it is active exactly while every part
is. `Whole` is active while some part is. -/
def AllWhole (parts : F → Prop) (w : F) : Prop :=
  ∀ t, W.active t w ↔ ∀ p, parts p → W.active t p

/-- The parts are *in step*: at each step, where one part is active every part is. -/
def InStep (parts : F → Prop) : Prop :=
  ∀ t p q, parts p → parts q → W.active t p → W.active t q

/-- Every formation is the whole of every part of itself, as it is the whole of some part of
itself (`whole_self`): with one part the two wholes are one. -/
theorem allWhole_self (f : F) : W.AllWhole (· = f) f :=
  fun _ => ⟨fun active _ same => Eq.subst (motive := fun g => W.active _ g) same.symm active,
    fun every => every f rfl⟩

variable {W}

/-- **Without a part, no whole of every part.** A whole of every part is inactive wherever one
of its parts is. -/
theorem AllWhole.inactive_of_part (whole : W.AllWhole parts w) {p : F} (part : parts p)
    {t : Nat} (inactive : ¬ W.active t p) : ¬ W.active t w :=
  fun active => inactive ((whole t).mp active p part)

/-- **A whole of every part ends as soon as one part ends**: it lasts no longer than its least
lasting part. No listing, and nothing of arising, is needed. A whole of some part ends only
where every part ends and none arises (`Whole.ends_without_arising`). -/
theorem AllWhole.ends_of_part (whole : W.AllWhole parts w) {p : F} (part : parts p)
    (ends : W.Ends p) : W.Ends w :=
  match ends with
  | ⟨T, gone⟩ => ⟨T, fun t later => whole.inactive_of_part part (gone t later)⟩

/-- A whole of every part is active at every step from `T` on exactly where every part is: it
persists with no arising, but only while no part ceases. A whole of some part persists only
through the arising of its parts (`Whole.needs_arising`). -/
theorem AllWhole.persists_iff (whole : W.AllWhole parts w) {T : Nat} :
    (∀ t, T ≤ t → W.active t w) ↔ ∀ p, parts p → ∀ t, T ≤ t → W.active t p :=
  ⟨fun persists p part t later => (whole t).mp (persists t later) p part,
   fun every t later => (whole t).mpr fun p part => every p part t later⟩

/-- A whole of every part, one of which is brief for `d`, is brief for `d`. -/
theorem AllWhole.brief_of_part (whole : W.AllWhole parts w) {p : F} (part : parts p)
    {d : Nat} (brief : W.Brief d p) : W.Brief d w :=
  fun t active => whole.inactive_of_part part (brief t ((whole t).mp active p part))

/-- A whole of some part ceases only as some part ceases: the dual of `Whole.arises_part`. -/
theorem Whole.ceases_part (whole : W.Whole parts w) {t : Nat} (ceases : W.Ceases t w) :
    ∃ p, parts p ∧ W.Ceases t p :=
  match (whole t).mp ceases.1 with
  | ⟨p, part, active⟩ =>
    ⟨p, part, active, fun after => ceases.2 ((whole (t + 1)).mpr ⟨p, part, after⟩)⟩

/-- With some part, the whole of every part is active only where the whole of some part is. -/
theorem AllWhole.active_whole {v : F} (all : W.AllWhole parts v) (whole : W.Whole parts w)
    {p₀ : F} (part₀ : parts p₀) {t : Nat} (active : W.active t v) : W.active t w :=
  (whole t).mpr ⟨p₀, part₀, (all t).mp active p₀ part₀⟩

/-- **The two wholes coincide exactly where the parts are in step.** With some part, the whole of
some part and the whole of every part of the same parts are active at the same steps exactly
where, at each step, one part active means every part active. -/
theorem Whole.same_iff_inStep {v : F} (whole : W.Whole parts w) (all : W.AllWhole parts v)
    {p₀ : F} (part₀ : parts p₀) :
    (∀ t, W.active t w ↔ W.active t v) ↔ W.InStep parts :=
  ⟨fun same t p q part partq active =>
      (all t).mp ((same t).mp ((whole t).mpr ⟨p, part, active⟩)) q partq,
   fun inStep t => ⟨fun active => match (whole t).mp active with
      | ⟨p, part, activep⟩ => (all t).mpr fun q partq => inStep t p q part partq activep,
    all.active_whole whole part₀⟩⟩

/-- Without parts the two wholes part entirely: the whole of every part of none is active at
every step, the whole of some part of none at no step. So the coincidence needs some part. -/
theorem AllWhole.active_of_none (all : W.AllWhole parts w) (absent : ∀ p, ¬ parts p) (t : Nat) :
    W.active t w ∧ ∀ {v : F}, W.Whole parts v → ¬ W.active t v :=
  ⟨(all t).mpr fun p part => absurd part (absent p),
   fun whole active => match (whole t).mp active with
    | ⟨p, part, _⟩ => absent p part⟩

end Every

section Grade

/-- A count is below the members wherever what it counts fails of one of them. -/
theorem _root_.Becoming.Counts.lt_length_of_fails {α : Type} {q : α → Prop} {a : α} (fails : ¬ q a) :
    ∀ {as : List α} {n : Nat}, Counts as q n → a ∈ as → n < as.length
  | [], _, _, mem => nomatch mem
  | _ :: _, _, ⟨_, m, indicates, rest, sum⟩, mem => match mem_cons_cases mem with
    | .inl same =>
      Nat.lt_of_le_of_lt (Nat.le_of_eq (sum.trans ((congrArg (· + m)
          (indicates.eq_zero (Eq.subst (motive := fun x => ¬ q x) same fails))).trans
          (Nat.zero_add m))))
        (Nat.lt_succ_of_le rest.le_length)
    | .inr mem =>
      Nat.lt_of_le_of_lt (Nat.le_of_eq sum)
        (Nat.lt_of_lt_of_le (Nat.add_lt_add_of_le_of_lt indicates.le_one
            (Counts.lt_length_of_fails fails rest mem))
          (Nat.le_of_eq (Nat.add_comm 1 _)))

/-- A count equal to the members holds of every member. -/
theorem _root_.Becoming.Counts.all_of_eq_length {α : Type} {q : α → Prop} {as : List α} {n : Nat}
    (counts : Counts as q n) (all : n = as.length) : ∀ a, a ∈ as → q a :=
  fun a mem => match (counts_iff_decided (q := q)).mp ⟨n, counts⟩ a mem with
  | .inl holds => holds
  | .inr fails =>
    absurd (Counts.lt_length_of_fails fails counts mem) (Nat.not_lt_of_le (Nat.le_of_eq all.symm))

variable (W)

/-- `n` is the *grade* of the listed parts at `t`: how many of them are active, each listing
counted. A grade exists exactly where each listed part's activity at `t` is decided
(`counts_iff_decided`); no decision procedure is used. -/
def Grade (ps : List F) (t n : Nat) : Prop :=
  Counts ps (W.active t) n

/-- `w` is the whole of at least `j` of the listed parts: at each step the parts have a grade,
and `w` is active exactly where it is at least `j`. -/
def AtLeastWhole (j : Nat) (ps : List F) (w : F) : Prop :=
  ∀ t, ∃ n, W.Grade ps t n ∧ (W.active t w ↔ j ≤ n)

/-- The listed parts' whole is *diminished* at `t`: some of them are active, not all. -/
def Diminished (ps : List F) (t : Nat) : Prop :=
  ∃ n, W.Grade ps t n ∧ 0 < n ∧ n < ps.length

variable {W} {ps : List F}

/-- A grade is positive exactly where some listed part is active. -/
theorem Grade.pos_iff {t n : Nat} (grade : W.Grade ps t n) :
    0 < n ↔ ∃ p, p ∈ ps ∧ W.active t p :=
  ⟨Counts.exists_of_pos grade, fun ⟨_, mem, active⟩ => Counts.pos_of_mem grade mem active⟩

/-- A grade is the number of listed parts exactly where every listed part is active. -/
theorem Grade.eq_length_iff {t n : Nat} (grade : W.Grade ps t n) :
    n = ps.length ↔ ∀ p, p ∈ ps → W.active t p :=
  ⟨Counts.all_of_eq_length grade, fun all => Counts.unique grade (Counts.of_all all)⟩

/-- **Without a part, the grade falls short.** Where a listed part is inactive, the grade is
below the number of listed parts. -/
theorem Grade.lt_length_of_inactive {t n : Nat} (grade : W.Grade ps t n) {p : F} (mem : p ∈ ps)
    (inactive : ¬ W.active t p) : n < ps.length :=
  Counts.lt_length_of_fails inactive grade mem

/-- **The grade's account across a step.** Wherever the parts arising and ceasing across the step
are counted, the grade after it with what ceased is the grade before it with what arose. This is
the census of `Becoming.Decidedness` (`Counts.across_step`) read of activity. -/
theorem Grade.across_step {t n n' a c : Nat} (now : W.Grade ps t n) (next : W.Grade ps (t + 1) n')
    (arose : Counts ps (W.Arises t) a) (ceased : Counts ps (W.Ceases t) c) : n' + c = n + a :=
  Counts.across_step (p := fun f s => W.active s f) now next arose ceased

/-- Where the grade rises across a step, a listed part arises there. -/
theorem Grade.arises_of_lt {t n n' : Nat} (now : W.Grade ps t n) (next : W.Grade ps (t + 1) n')
    (rises : n < n') : ∃ p, p ∈ ps ∧ W.Arises t p :=
  match (counts_iff_decided (q := W.Arises t)).mpr (fun p mem =>
      Decided.and ((counts_iff_decided.mp ⟨n, now⟩ p mem).not)
        (counts_iff_decided.mp ⟨n', next⟩ p mem)),
    (counts_iff_decided (q := W.Ceases t)).mpr (fun p mem =>
      Decided.and (counts_iff_decided.mp ⟨n, now⟩ p mem)
        ((counts_iff_decided.mp ⟨n', next⟩ p mem).not)) with
  | ⟨a, arose⟩, ⟨c, ceased⟩ =>
    have account : n' + c = n + a := Grade.across_step now next arose ceased
    match Nat.eq_zero_or_pos a with
    | .inr pos => arose.exists_of_pos pos
    | .inl zero => absurd (Nat.lt_of_lt_of_le rises (Nat.le_trans (Nat.le_add_right n' c)
        (Nat.le_of_eq (account.trans ((congrArg (n + ·) zero).trans (Nat.add_zero n))))))
        (Nat.lt_irrefl n)

/-- Where the grade falls across a step, a listed part ceases there. -/
theorem Grade.ceases_of_lt {t n n' : Nat} (now : W.Grade ps t n) (next : W.Grade ps (t + 1) n')
    (falls : n' < n) : ∃ p, p ∈ ps ∧ W.Ceases t p :=
  match (counts_iff_decided (q := W.Arises t)).mpr (fun p mem =>
      Decided.and ((counts_iff_decided.mp ⟨n, now⟩ p mem).not)
        (counts_iff_decided.mp ⟨n', next⟩ p mem)),
    (counts_iff_decided (q := W.Ceases t)).mpr (fun p mem =>
      Decided.and (counts_iff_decided.mp ⟨n, now⟩ p mem)
        ((counts_iff_decided.mp ⟨n', next⟩ p mem).not)) with
  | ⟨a, arose⟩, ⟨c, ceased⟩ =>
    have account : n' + c = n + a := Grade.across_step now next arose ceased
    match Nat.eq_zero_or_pos c with
    | .inr pos => ceased.exists_of_pos pos
    | .inl zero => absurd (Nat.lt_of_lt_of_le falls (Nat.le_trans (Nat.le_add_right n a)
        (Nat.le_of_eq (account.symm.trans ((congrArg (n' + ·) zero).trans (Nat.add_zero n'))))))
        (Nat.lt_irrefl n')

/-- **A whole of at least `j` listed parts arises only as some listed part arises.** -/
theorem AtLeastWhole.arises_part {j : Nat} (whole : W.AtLeastWhole j ps w) {t : Nat}
    (arises : W.Arises t w) : ∃ p, p ∈ ps ∧ W.Arises t p :=
  match whole t, whole (t + 1) with
  | ⟨_, now, before⟩, ⟨_, next, after⟩ =>
    Grade.arises_of_lt now next (Nat.lt_of_lt_of_le
      (Nat.gt_of_not_le fun reached => arises.1 (before.mpr reached)) (after.mp arises.2))

/-- **A whole of at least `j` listed parts ceases only as some listed part ceases.** -/
theorem AtLeastWhole.ceases_part {j : Nat} (whole : W.AtLeastWhole j ps w) {t : Nat}
    (ceases : W.Ceases t w) : ∃ p, p ∈ ps ∧ W.Ceases t p :=
  match whole t, whole (t + 1) with
  | ⟨_, now, before⟩, ⟨_, next, after⟩ =>
    Grade.ceases_of_lt now next (Nat.lt_of_lt_of_le
      (Nat.gt_of_not_le fun reached => ceases.2 (after.mpr reached)) (before.mp ceases.1))

/-- The whole of at least one listed part is the whole of some listed part. -/
theorem AtLeastWhole.whole (whole : W.AtLeastWhole 1 ps w) : W.Whole (· ∈ ps) w :=
  fun t => match whole t with
  | ⟨_, grade, iff⟩ => iff.trans (Grade.pos_iff grade)

/-- Where the listed parts' activity is decided at every step, the whole of some listed part is
the whole of at least one. -/
theorem Whole.atLeastWhole (whole : W.Whole (· ∈ ps) w)
    (decided : ∀ t p, p ∈ ps → Decided (W.active t p)) : W.AtLeastWhole 1 ps w :=
  fun t => match (counts_iff_decided (q := W.active t)).mpr (decided t) with
  | ⟨n, grade⟩ => ⟨n, grade, (whole t).trans (Grade.pos_iff grade).symm⟩

/-- The whole of at least as many listed parts as are listed is the whole of every listed part.
-/
theorem AtLeastWhole.allWhole (whole : W.AtLeastWhole ps.length ps w) : W.AllWhole (· ∈ ps) w :=
  fun t => match whole t with
  | ⟨_, grade, iff⟩ => iff.trans
    ⟨fun le => (Grade.eq_length_iff grade).mp (Nat.le_antisymm (Counts.le_length grade) le),
     fun all => Nat.le_of_eq ((Grade.eq_length_iff grade).mpr all).symm⟩

/-- Where the listed parts' activity is decided at every step, the whole of every listed part is
the whole of at least as many as are listed. -/
theorem AllWhole.atLeastWhole (all : W.AllWhole (· ∈ ps) w)
    (decided : ∀ t p, p ∈ ps → Decided (W.active t p)) : W.AtLeastWhole ps.length ps w :=
  fun t => match (counts_iff_decided (q := W.active t)).mpr (decided t) with
  | ⟨n, grade⟩ => ⟨n, grade, (all t).trans
      ⟨fun every => Nat.le_of_eq ((Grade.eq_length_iff grade).mpr every).symm,
       fun le => (Grade.eq_length_iff grade).mp (Nat.le_antisymm (Counts.le_length grade) le)⟩⟩

/-- **A whole of every listed part arises only as some listed part arises**, where their activity
is decided: the account of the grade (`AtLeastWhole.arises_part`). -/
theorem AllWhole.arises_part (all : W.AllWhole (· ∈ ps) w)
    (decided : ∀ t p, p ∈ ps → Decided (W.active t p)) {t : Nat} (arises : W.Arises t w) :
    ∃ p, p ∈ ps ∧ W.Arises t p :=
  (all.atLeastWhole decided).arises_part arises

/-- **A whole of every listed part ceases only as some listed part ceases**, where their activity
is decided: the account of the grade (`AtLeastWhole.ceases_part`). -/
theorem AllWhole.ceases_part (all : W.AllWhole (· ∈ ps) w)
    (decided : ∀ t p, p ∈ ps → Decided (W.active t p)) {t : Nat} (ceases : W.Ceases t w) :
    ∃ p, p ∈ ps ∧ W.Ceases t p :=
  (all.atLeastWhole decided).ceases_part ceases

/-- **The diminished whole.** Where the listed parts have a grade, the whole they make is
diminished, some parts active and not all, exactly where the whole of some of them is active and
the whole of every one is not. -/
theorem Grade.diminished_iff {v : F} (whole : W.Whole (· ∈ ps) w) (all : W.AllWhole (· ∈ ps) v)
    {t n : Nat} (grade : W.Grade ps t n) :
    (0 < n ∧ n < ps.length) ↔ (W.active t w ∧ ¬ W.active t v) :=
  ⟨fun ⟨pos, short⟩ => ⟨(whole t).mpr ((Grade.pos_iff grade).mp pos),
     fun active => Nat.ne_of_lt short ((Grade.eq_length_iff grade).mpr ((all t).mp active))⟩,
   fun ⟨active, notAll⟩ => ⟨(Grade.pos_iff grade).mpr ((whole t).mp active),
     Nat.lt_of_le_of_ne (Counts.le_length grade) fun full => notAll ((all t).mpr
       ((Grade.eq_length_iff grade).mp full))⟩⟩

/-- So the whole is diminished at `t` exactly where, its parts' activity decided there, the whole
of some is active and the whole of every one is not. -/
theorem diminished_iff {v : F} (whole : W.Whole (· ∈ ps) w) (all : W.AllWhole (· ∈ ps) v)
    {t : Nat} (decided : ∀ p, p ∈ ps → Decided (W.active t p)) :
    W.Diminished ps t ↔ (W.active t w ∧ ¬ W.active t v) :=
  ⟨fun ⟨_, grade, within⟩ => (Grade.diminished_iff whole all grade).mp within,
   fun both => match (counts_iff_decided (q := W.active t)).mpr decided with
    | ⟨n, grade⟩ => ⟨n, grade, (Grade.diminished_iff whole all grade).mpr both⟩⟩

end Grade
