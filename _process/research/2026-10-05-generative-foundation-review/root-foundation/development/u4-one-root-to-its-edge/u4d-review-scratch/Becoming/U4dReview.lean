import Becoming.U4dCover
import Becoming.U4dNeeded
import Becoming.Identity

/-! Review checks for U4d (AI-written, not part of the package): a stretch form of the count on a
stage map; the root's census of a run re-proved through it, with fewer hypotheses; a witness that the
stage map's "one stage on" is needed; the decided form asking its decision only after `N`; and the
decision witness read at Identity. -/

namespace Becoming

universe u

section U4dReview

variable {α : Type u} {R E : «际» α}

/-- **The stretch form.** With a list covering the units at `N` and no unit beginning at a stage in
`(N, U)`, units ending at distinct stages in `[N, U)` number at most the list. No decision. -/
theorem U4dR.cover_within {τ : α → Nat} {here : α → Prop}
    (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (keeps : ∀ x y, «续» R E x y → here y → here x)
    (noSplit : ∀ v b b', here b → here b' → «续» R E v b → «续» R E v b' → b = b')
    {N U : Nat} {L : List α} (covers : ∀ x, here x → τ x = N → x ∈ L)
    (quiet : ∀ z, here z → N < τ z → τ z < U → ¬ «生» R E z)
    {D : List α} (dD : Distinct D)
    (ends : ∀ x, x ∈ D → N ≤ τ x ∧ τ x < U ∧ here x ∧ «亡» R E x) : D.length ≤ L.length :=
  U4d.ends_le_unrefuted dD (U4d.fixed_of_noSplit keeps noSplit fun x mx => (ends x mx).2.2.1)
    (fun x mx => match le_dest (ends x mx).1 with
      | ⟨k, at_⟩ => U4d.trace_unrefuted stage keeps covers k x (ends x mx).2.2.1 at_
          fun z hz late upto => quiet z hz late
            (Nat.lt_of_le_of_lt upto (Eq.subst (motive := (· < U)) at_ (ends x mx).2.1)))
    fun x mx => (ends x mx).2.2.2

/-- A test over a list: some member passes, or nothing does. -/
theorem U4dR.list_search {β : Type u} (b : β → Bool) : ∀ l : List β,
    (∃ y, y ∈ l ∧ b y = true) ∨ ∀ y, y ∈ l → b y ≠ true
  | [] => .inr fun _ mem => nomatch mem
  | x :: l => match hb : b x with
    | true => .inl ⟨x, .head l, hb⟩
    | false => match U4dR.list_search b l with
      | .inl ⟨y, my, passes⟩ => .inl ⟨y, .tail x my, passes⟩
      | .inr nothing => .inr fun y my => match ListTests.mem_cons_iff.mp my with
        | .inl e => Eq.subst (motive := fun v => b v ≠ true) e.symm
            fun h => Bool.noConfusion (hb.symm.trans h)
        | .inr m => nothing y m

/-- A decided property over a range of numbers: found, or nowhere. -/
theorem U4dR.range_search {P : Nat → Prop} (dec : ∀ s, P s ∨ ¬ P s) (M : Nat) : ∀ n,
    (∃ s, M ≤ s ∧ s < M + n ∧ P s) ∨ ∀ s, M ≤ s → s < M + n → ¬ P s
  | 0 => .inr fun s lo hi _ => Nat.lt_irrefl s (Nat.lt_of_lt_of_le hi lo)
  | n + 1 => match U4dR.range_search dec M n with
    | .inl ⟨s, lo, hi, p⟩ => .inl ⟨s, lo, Nat.lt_succ_of_lt hi, p⟩
    | .inr nothing => match dec (M + n) with
      | .inl p => .inl ⟨M + n, Nat.le_add_right M n, Nat.lt_succ_self _, p⟩
      | .inr np => .inr fun s lo hi => match Nat.lt_or_ge s (M + n) with
        | .inl below => nothing s lo below
        | .inr above => Eq.subst (motive := fun v => ¬ P v)
            (Nat.le_antisymm (Nat.le_of_lt_succ hi) above).symm np

theorem U4dR.pair_eq {β : Type u} : ∀ {x y : Nat × β}, x.1 = y.1 → x.2 = y.2 → x = y
  | (_, _), (_, _), rfl, rfl => rfl

/-- **The root's census of a run, through lines.** The same conclusion as `GrammarLaws.census_run`,
asking neither that the units after each step be listed once nor a test of endings: the units are
read as occurrences `(t, x)` at stages, and the stretch form of the count applies, the beginning's
test deciding a finite search. -/
theorem U4dR.census_run_lines {b : α → Bool} {u : Nat → List α} {T : Nat}
    (noSplit : ∀ t, T ≤ t → ∀ x y y', x ∈ u t → y ∈ u (t + 1) → y' ∈ u (t + 1) →
      «续» R E x y → «续» R E x y' → y = y')
    (predecessorsBefore : ∀ t, T ≤ t → ∀ x y, y ∈ u (t + 1) → «续» R E x y → x ∈ u t)
    (begins : ∀ t, T ≤ t → ∀ y, y ∈ u (t + 1) → (b y = true ↔ «生» R E y))
    (ending : «屡» (fun before _ => ∃ x, x ∈ before ∧ «亡» R E x) u) :
    «屡» (fun _ after => ∃ y, y ∈ after ∧ «生» R E y) u :=
  fun N =>
  let R' : «际» (Nat × α) := fun x y => y.1 = x.1 + 1 ∧ «续» R E x.2 y.2
  let E' : «际» (Nat × α) := fun x y => T ≤ x.1 ∧ x.2 ∈ u x.1 ∧ y.2 ∈ u y.1
  let here' : Nat × α → Prop := fun x => T ≤ x.1 ∧ x.2 ∈ u x.1
  let N' := N + T
  let L := (u N').map (fun x => (N', x))
  have stage : ∀ x y, «续» R' E' x y → y.1 = x.1 + 1 := fun _ _ c => c.1.1
  have keeps : ∀ x y, «续» R' E' x y → here' y → here' x := fun _ _ c _ => ⟨c.2.1, c.2.2.1⟩
  have split : ∀ v b b', here' b → here' b' → «续» R' E' v b → «续» R' E' v b' → b = b' :=
    fun v b b' _ _ c c' => U4dR.pair_eq (c.1.1.trans c'.1.1.symm)
      (noSplit v.1 c.2.1 v.2 b.2 b'.2 c.2.2.1
        (Eq.subst (motive := fun s => b.2 ∈ u s) c.1.1 c.2.2.2)
        (Eq.subst (motive := fun s => b'.2 ∈ u s) c'.1.1 c'.2.2.2) c.1.2 c'.1.2)
  have covers : ∀ x : Nat × α, here' x → x.1 = N' → x ∈ L :=
    fun x h at_ => Eq.subst (motive := (· ∈ L)) (U4dR.pair_eq (x := (N', x.2)) (y := x) at_.symm rfl)
      (ListTests.mem_map_of (f := fun x => (N', x)) (Eq.subst (motive := fun s => x.2 ∈ u s) at_ h.2))
  have endings : ∀ M, ∃ x : Nat × α, M ≤ x.1 ∧ (here' x ∧ «亡» R' E' x) :=
    fun M => match ending (M + T) with
    | ⟨t, later, x, mx, en⟩ => ⟨(t, x), Nat.le_trans (Nat.le_add_right M T) later,
        ⟨Nat.le_trans (Nat.le_add_left T M) later, mx⟩, fun ⟨y, c⟩ => en ⟨y.2, c.1.2⟩⟩
  match U4d.found (τ := Prod.fst) (marks := fun x => here' x ∧ «亡» R' E' x) endings
      (L.length + 1) N' with
  | ⟨_, _, dD, len, from_, all⟩ =>
    match le_dest from_ with
    | ⟨n, atU⟩ =>
      match U4dR.range_search (P := fun t => ∃ y, y ∈ u (t + 1) ∧ b y = true)
          (fun t => match U4dR.list_search b (u (t + 1)) with
            | .inl found => .inl found
            | .inr nothing => .inr fun ⟨y, my, passes⟩ => nothing y my passes) N' n with
      | .inl ⟨t, lo, _, y, my, passes⟩ =>
        ⟨t, Nat.le_trans (Nat.le_add_right N T) lo, y, my,
          (begins t (Nat.le_trans (Nat.le_add_left T N) lo) y my).mp passes⟩
      | .inr nothing => (Nat.not_succ_le_self L.length (Nat.le_trans (Nat.le_of_eq len.symm)
          (U4dR.cover_within (τ := Prod.fst) (here := here') stage keeps split covers
            (fun z hz late below beg => match z, hz, late, below, beg with
              | (0, _), _, late, _, _ => Nat.not_lt_zero _ late
              | (t + 1, y), hz, late, below, beg =>
                have from_t : N' ≤ t := Nat.le_of_lt_succ late
                have fromT : T ≤ t := Nat.le_trans (Nat.le_add_left T N) from_t
                nothing t from_t (Nat.lt_of_lt_of_le (Nat.lt_succ_self t)
                    (Nat.le_of_lt (Eq.subst (motive := (t + 1 < ·)) atU below)))
                  ⟨y, hz.2, (begins t fromT y hz.2).mpr fun ⟨x, c⟩ =>
                    beg ⟨(t, x), ⟨rfl, c⟩, fromT, predecessorsBefore t fromT x y hz.2 c, hz.2⟩⟩)
            dD all))).elim

/-- `GrammarLaws.census_run`, its statement unchanged, is a case: its listing-once and ending-test
hypotheses go unused. -/
theorem U4dR.census_run_again {b e : α → Bool} {u : Nat → List α} {T : Nat}
    (_once : ∀ t, T ≤ t → Distinct (u (t + 1)))
    (noSplit : ∀ t, T ≤ t → ∀ x y y', x ∈ u t → y ∈ u (t + 1) → y' ∈ u (t + 1) →
      «续» R E x y → «续» R E x y' → y = y')
    (predecessorsBefore : ∀ t, T ≤ t → ∀ x y, y ∈ u (t + 1) → «续» R E x y → x ∈ u t)
    (begins : ∀ t, T ≤ t → ∀ y, y ∈ u (t + 1) → (b y = true ↔ «生» R E y))
    (_ends : ∀ t, T ≤ t → ∀ x, x ∈ u t → (e x = true ↔ «亡» R E x))
    (ending : «屡» (fun before _ => ∃ x, x ∈ before ∧ «亡» R E x) u) :
    «屡» (fun _ after => ∃ y, y ∈ after ∧ «生» R E y) u :=
  U4dR.census_run_lines noSplit predecessorsBefore begins ending

/-- The decided form, its decision asked only after `N`. -/
theorem U4dR.trace_after {τ : α → Nat} {here : α → Prop}
    (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (keeps : ∀ x y, «续» R E x y → here y → here x)
    {N : Nat} {L : List α} (covers : ∀ x, here x → τ x = N → x ∈ L)
    (decided : ∀ y, here y → N < τ y → «生» R E y ∨ «有前» R E y) :
    ∀ k y, here y → τ y = N + k →
      (∃ z, N < τ z ∧ here z ∧ «生» R E z) ∨ ∃ m, m ∈ L ∧ «所闭» («续» R E) m y
  | 0, y, h, at_ => .inr ⟨y, covers y h at_, «所闭之自反» _ y⟩
  | k + 1, y, h, at_ =>
    have late : N < τ y := Eq.subst (motive := (N < ·)) at_.symm
      (Nat.lt_succ_of_le (Nat.le_add_right N k))
    match decided y h late with
    | .inl b => .inl ⟨y, late, h, b⟩
    | .inr ⟨x, c⟩ =>
      match U4dR.trace_after stage keeps covers decided k x (keeps x y c h)
          (Nat.succ.inj ((stage x y c).symm.trans at_)) with
      | .inl found => .inl found
      | .inr ⟨m, mm, r⟩ => .inr ⟨m, mm, «所闭之传递» r («缘在所闭» c)⟩

theorem U4dR.cover_from_after {τ : α → Nat} {here : α → Prop}
    (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (keeps : ∀ x y, «续» R E x y → here y → here x)
    (noSplit : ∀ v b b', here b → here b' → «续» R E v b → «续» R E v b' → b = b')
    {N : Nat} {L : List α} (covers : ∀ x, here x → τ x = N → x ∈ L)
    (decided : ∀ y, here y → N < τ y → «生» R E y ∨ «有前» R E y)
    (ending : ∀ M, ∃ x, M ≤ τ x ∧ here x ∧ «亡» R E x) :
    ∃ y, N < τ y ∧ here y ∧ «生» R E y :=
  match U4d.found (marks := fun x => here x ∧ «亡» R E x) ending (L.length + 1) N with
  | ⟨_, _, dD, len, _, all⟩ =>
    match U4d.found_or_all (A := ∃ z, N < τ z ∧ here z ∧ «生» R E z)
        (B := fun x => ∃ m, m ∈ L ∧ «所闭» («续» R E) m x)
        (fun x mx => match le_dest (all x mx).1 with
          | ⟨k, at_⟩ => U4dR.trace_after stage keeps covers decided k x (all x mx).2.2.1 at_) with
    | .inl found => found
    | .inr reached => (Nat.not_succ_le_self L.length (Nat.le_trans (Nat.le_of_eq len.symm)
        (U4d.ends_le dD (U4d.fixed_of_noSplit keeps noSplit fun x mx => (all x mx).2.2.1)
          reached fun x mx => (all x mx).2.2.2))).elim

end U4dReview

example : type_of% @GrammarLaws.census_run := @U4dR.census_run_again

/-! ### The stage map's one stage on is needed -/

namespace U4dR.Stage

/-- Each `(0, a)` continues as `(a + 1, a)`, which ends: steps that move later, by more than one stage. -/
def jump : «际» (Nat × Nat) := fun x y => x.1 = 0 ∧ y.1 = x.2 + 1 ∧ y.2 = x.2

def unit (x : Nat × Nat) : Prop := x.1 = 0 ∨ x.1 = x.2 + 1

/-- Every hypothesis of the decided run law but one stage on per step (each step still moves
strictly later); no unit begins after the first stage. -/
theorem run_needs_stage :
    (∀ x y, «续» jump U4d.Needed.all x y → x.1 < y.1) ∧
    (∀ x y, «续» jump U4d.Needed.all x y → unit y → unit x) ∧
    (∀ v b b' : Nat × Nat, unit b → unit b' → «续» jump U4d.Needed.all v b →
      «续» jump U4d.Needed.all v b' → b = b') ∧
    (∀ M, ∃ N, ∃ L : List (Nat × Nat), M ≤ N ∧ ∀ x : Nat × Nat, unit x → x.1 = N → x ∈ L) ∧
    (∀ y : Nat × Nat, unit y → «生» jump U4d.Needed.all y ∨ «有前» jump U4d.Needed.all y) ∧
    (∀ M, ∃ x : Nat × Nat, M ≤ x.1 ∧ unit x ∧ «亡» jump U4d.Needed.all x) ∧
    ¬ ∀ M, ∃ y : Nat × Nat, M < y.1 ∧ unit y ∧ «生» jump U4d.Needed.all y :=
  ⟨fun _ y ⟨⟨zero, next, _⟩, _⟩ => Eq.subst (motive := (· < y.1)) zero.symm
      (Eq.subst (motive := (0 < ·)) next.symm (Nat.zero_lt_succ _)),
   fun _ _ ⟨⟨zero, _⟩, _⟩ _ => .inl zero,
   fun _ _ _ _ _ ⟨⟨_, n, s⟩, _⟩ ⟨⟨_, n', s'⟩, _⟩ =>
     U4d.Needed.pair_eq (n.trans n'.symm) (s.trans s'.symm),
   fun M => ⟨M + 1, [(M + 1, M)], Nat.le_succ M, fun x h at_ => match x, h, at_ with
     | (_, _), .inl zero, at_ => Nat.noConfusion (zero.symm.trans at_)
     | (_, _), .inr next, at_ => Eq.subst (motive := (· ∈ [(M + 1, M)]))
         (U4d.Needed.pair_eq (y := (M + 1, M)) at_ (Nat.succ.inj (next.symm.trans at_))).symm
         (.head _)⟩,
   fun y h => match y, h with
     | (_, _), .inl zero => .inl fun ⟨_, ⟨⟨_, next, _⟩, _⟩⟩ =>
         Nat.noConfusion (next.symm.trans zero)
     | (_, a), .inr next => .inr ⟨(0, a), ⟨⟨rfl, next, rfl⟩, trivial⟩⟩,
   fun M => ⟨(M + 1, M), Nat.le_succ M, .inr rfl, fun ⟨_, ⟨⟨zero, _⟩, _⟩⟩ =>
     Nat.noConfusion zero⟩,
   fun each => match each 0 with
     | ⟨(_, _), late, .inl zero, _⟩ => Nat.lt_irrefl 0 (Eq.subst (motive := (0 < ·)) zero late)
     | ⟨(_, a), _, .inr next, b⟩ => b ⟨(0, a), ⟨⟨rfl, next, rfl⟩, trivial⟩⟩⟩

end U4dR.Stage

/-! ### The decision witness at Identity -/

namespace U4dR.AtIdentity

/-- Two formations active at every step, conditions and amounts idle. -/
def web : Web Nat Unit :=
  ⟨fun _ _ => 0, fun _ f => f ≤ 1, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

/-- `0` continues as `0` where `Q`, as `1` where not. -/
def cont (Q : Prop) : Nat → Nat → Nat → Prop := fun _ g f => g = 0 ∧ ((f = 0 ∧ Q) ∨ (f = 1 ∧ ¬ Q))

theorem two (f : Nat) (h : f ≤ 1) : f ∈ [0, 1] :=
  match U4d.Needed.le_one h with
  | .inl e => Eq.subst (motive := (· ∈ [0, 1])) e.symm (.head _)
  | .inr e => Eq.subst (motive := (· ∈ [0, 1])) e.symm (.tail _ (.head _))

/-- At Identity, every hypothesis of the exact form (covering lists, no split) and ceasing
recurring hold for any `Q`; whether a formation continues one active before is decided exactly
where `Q` is, and arising recurs exactly where `¬ Q ∨ ¬¬ Q`. -/
theorem exact_needs_decision (Q : Prop) :
    (∀ N, ∃ M, ∃ l : List Nat, N ≤ M ∧ ∀ f, web.active M f → f ∈ l) ∧
    (∀ s, 0 ≤ s → ∀ g f f', web.active s g → cont Q s g f → cont Q s g f' →
      web.active (s + 1) f → web.active (s + 1) f' → f = f') ∧
    (∀ N, ∃ t g, N ≤ t ∧ web.CeasesFrom (cont Q) t g) ∧
    ((∀ t f, web.Continues (cont Q) t f ∨ ¬ web.Continues (cont Q) t f) ↔ (Q ∨ ¬ Q)) ∧
    (web.UnceasingFrom (cont Q) ↔ (¬ Q ∨ ¬¬ Q)) :=
  ⟨fun N => ⟨N, [0, 1], Nat.le_refl N, two⟩,
   fun _ _ _ _ _ _ c c' _ _ => match c.2, c'.2 with
     | .inl ⟨e, _⟩, .inl ⟨e', _⟩ => e.trans e'.symm
     | .inr ⟨e, _⟩, .inr ⟨e', _⟩ => e.trans e'.symm
     | .inl ⟨_, q⟩, .inr ⟨_, nq⟩ => (nq q).elim
     | .inr ⟨_, nq⟩, .inl ⟨_, q⟩ => (nq q).elim,
   fun N => ⟨N, 1, Nat.le_refl N, Nat.le_refl 1, fun ⟨_, _, c⟩ => Nat.noConfusion c.1⟩,
   ⟨fun decided => match decided 0 0 with
      | .inl ⟨_, _, c⟩ => match c.2 with
        | .inl ⟨_, q⟩ => .inl q
        | .inr ⟨e, _⟩ => Nat.noConfusion e
      | .inr nothing => .inr fun q => nothing ⟨0, Nat.zero_le 1, rfl, .inl ⟨rfl, q⟩⟩,
    fun lem _ f => match f, lem with
      | 0, .inl q => .inl ⟨0, Nat.zero_le 1, rfl, .inl ⟨rfl, q⟩⟩
      | 0, .inr nq => .inr fun ⟨_, _, c⟩ => match c.2 with
        | .inl ⟨_, q⟩ => nq q
        | .inr ⟨e, _⟩ => Nat.noConfusion e
      | 1, .inl q => .inr fun ⟨_, _, c⟩ => match c.2 with
        | .inl ⟨e, _⟩ => Nat.noConfusion e
        | .inr ⟨_, nq⟩ => nq q
      | 1, .inr nq => .inl ⟨0, Nat.zero_le 1, rfl, .inr ⟨rfl, nq⟩⟩
      | _ + 2, _ => .inr fun ⟨_, _, c⟩ => match c.2 with
        | .inl ⟨e, _⟩ => Nat.noConfusion e
        | .inr ⟨e, _⟩ => Nat.noConfusion (Nat.succ.inj e)⟩,
   ⟨fun unceasing => match unceasing 0 with
      | ⟨_, f, _, active, alone⟩ => match f, active with
        | 0, _ => .inl fun q => alone ⟨0, Nat.zero_le 1, rfl, .inl ⟨rfl, q⟩⟩
        | 1, _ => .inr fun nq => alone ⟨0, Nat.zero_le 1, rfl, .inr ⟨rfl, nq⟩⟩
        | a + 2, active => absurd (Nat.le_of_succ_le_succ active) (Nat.not_succ_le_zero a),
    fun wlem N => match wlem with
      | .inl nq => ⟨N, 0, Nat.le_refl N, Nat.zero_le 1, fun ⟨_, _, c⟩ => match c.2 with
          | .inl ⟨_, q⟩ => nq q
          | .inr ⟨e, _⟩ => Nat.noConfusion e⟩
      | .inr nnq => ⟨N, 1, Nat.le_refl N, Nat.le_refl 1, fun ⟨_, _, c⟩ => match c.2 with
          | .inl ⟨e, _⟩ => Nat.noConfusion e
          | .inr ⟨_, nq⟩ => nnq nq⟩⟩⟩

end U4dR.AtIdentity

/-! ### The converse's decision -/

namespace U4dR.ConverseChoose

/-- `(t, 1)` continues as `(t + 1, 0)` where `Q`, `(t, 0)` does where not. -/
def conv (Q : Prop) : «际» (Nat × Nat) :=
  fun x y => y.1 = x.1 + 1 ∧ y.2 = 0 ∧ ((x.2 = 1 ∧ Q) ∨ (x.2 = 0 ∧ ¬ Q))

/-- Every hypothesis of the decided converse but its decision, for any `Q`; the decision holds
exactly where `Q` is decided, and endings recur exactly where `¬ Q ∨ ¬¬ Q`. -/
theorem converse_needs_decision (Q : Prop) :
    (∀ x y, «续» (conv Q) U4d.Needed.all x y → y.1 = x.1 + 1) ∧
    (∀ x y, «续» (conv Q) U4d.Needed.all x y → x.2 ≤ 1 → y.2 ≤ 1) ∧
    (∀ v a a' : Nat × Nat, a.2 ≤ 1 → a'.2 ≤ 1 → «续» (conv Q) U4d.Needed.all a v →
      «续» (conv Q) U4d.Needed.all a' v → a = a') ∧
    (∀ S, 0 ≤ S → ∃ L : List (Nat × Nat), L.length ≤ 2 ∧
      ∀ x : Nat × Nat, x.2 ≤ 1 → x.1 = S → x ∈ L) ∧
    (∀ M, ∃ x : Nat × Nat, M ≤ x.1 ∧ x.2 ≤ 1 ∧ «生» (conv Q) U4d.Needed.all x) ∧
    ((∀ x : Nat × Nat, x.2 ≤ 1 → «亡» (conv Q) U4d.Needed.all x ∨ «有后» (conv Q) U4d.Needed.all x)
      ↔ (Q ∨ ¬ Q)) ∧
    ((∀ N, ∃ x : Nat × Nat, N ≤ x.1 ∧ x.2 ≤ 1 ∧ «亡» (conv Q) U4d.Needed.all x) ↔ (¬ Q ∨ ¬¬ Q)) :=
  ⟨fun _ _ ⟨⟨next, _⟩, _⟩ => next,
   fun _ _ ⟨⟨_, zero, _⟩, _⟩ _ => Eq.subst (motive := (· ≤ 1)) zero.symm (Nat.zero_le 1),
   fun _ _ _ _ _ ⟨⟨n, _, c⟩, _⟩ ⟨⟨n', _, c'⟩, _⟩ =>
     U4d.Needed.pair_eq (Nat.succ.inj (n.symm.trans n')) (match c, c' with
       | .inl ⟨e, _⟩, .inl ⟨e', _⟩ => e.trans e'.symm
       | .inr ⟨e, _⟩, .inr ⟨e', _⟩ => e.trans e'.symm
       | .inl ⟨_, q⟩, .inr ⟨_, nq⟩ => (nq q).elim
       | .inr ⟨_, nq⟩, .inl ⟨_, q⟩ => (nq q).elim),
   fun S _ => ⟨[(S, 0), (S, 1)], Nat.le_refl 2, U4d.Needed.two_cover S⟩,
   fun M => ⟨(M, 1), Nat.le_refl M, Nat.le_refl 1, fun ⟨_, ⟨_, one, _⟩, _⟩ => Nat.noConfusion one⟩,
   ⟨fun decided => match decided (0, 1) (Nat.le_refl 1) with
      | .inl en => .inr fun q => en ⟨(1, 0), ⟨rfl, rfl, .inl ⟨rfl, q⟩⟩, trivial⟩
      | .inr ⟨_, ⟨_, _, c⟩, _⟩ => match c with
        | .inl ⟨_, q⟩ => .inl q
        | .inr ⟨e, _⟩ => Nat.noConfusion e,
    fun lem x h => match x, h, lem with
      | (_, 0), _, .inl q => .inl fun ⟨_, ⟨_, _, c⟩, _⟩ => match c with
        | .inl ⟨e, _⟩ => Nat.noConfusion e
        | .inr ⟨_, nq⟩ => nq q
      | (t, 0), _, .inr nq => .inr ⟨(t + 1, 0), ⟨rfl, rfl, .inr ⟨rfl, nq⟩⟩, trivial⟩
      | (t, 1), _, .inl q => .inr ⟨(t + 1, 0), ⟨rfl, rfl, .inl ⟨rfl, q⟩⟩, trivial⟩
      | (_, 1), _, .inr nq => .inl fun ⟨_, ⟨_, _, c⟩, _⟩ => match c with
        | .inl ⟨_, q⟩ => nq q
        | .inr ⟨e, _⟩ => Nat.noConfusion e
      | (_, a + 2), h, _ => absurd (Nat.le_of_succ_le_succ h) (Nat.not_succ_le_zero a)⟩,
   ⟨fun each => match each 0 with
      | ⟨(t, 0), _, _, en⟩ => .inr fun nq => en ⟨(t + 1, 0), ⟨rfl, rfl, .inr ⟨rfl, nq⟩⟩, trivial⟩
      | ⟨(t, 1), _, _, en⟩ => .inl fun q => en ⟨(t + 1, 0), ⟨rfl, rfl, .inl ⟨rfl, q⟩⟩, trivial⟩
      | ⟨(_, a + 2), _, h, _⟩ => absurd (Nat.le_of_succ_le_succ h) (Nat.not_succ_le_zero a),
    fun wlem N => match wlem with
      | .inl nq => ⟨(N, 1), Nat.le_refl N, Nat.le_refl 1, fun ⟨_, ⟨_, _, c⟩, _⟩ => match c with
          | .inl ⟨_, q⟩ => nq q
          | .inr ⟨e, _⟩ => Nat.noConfusion e⟩
      | .inr nnq => ⟨(N, 0), Nat.le_refl N, Nat.zero_le 1, fun ⟨_, ⟨_, _, c⟩, _⟩ => match c with
          | .inl ⟨e, _⟩ => Nat.noConfusion e
          | .inr ⟨_, nq⟩ => nnq nq⟩⟩⟩

end U4dR.ConverseChoose

end Becoming
