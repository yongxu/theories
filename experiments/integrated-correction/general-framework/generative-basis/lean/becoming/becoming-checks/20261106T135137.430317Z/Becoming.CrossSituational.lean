import Becoming.Prelude
import Becoming.Segmentation

/-!
# Cross-situational resolution: what a form names, read across the occasions it was met

A formation that learns meets a form on several occasions, and each record of an occasion offers the meanings
accessible then. Which records bear on a form, and what each record offers, are read by two
Boolean relations (`bears`, `offers`). A meaning stands for a form where every record bearing on
the form offers it (`stands`); the candidates of the form are the meanings of a repertoire that
stand (`candidates`), and the form resolves where exactly one does (`unique`). This is the rule of
the acquired-binding machines of the inquiry root, stated for every type of records and meanings
and every reading of bearing and offering.

* **Resolution is separation.** For a repertoire without repeats, the candidates of a form are
  exactly `[e]` when `e` is in the repertoire, every bearing record offers it, and every other
  meaning of the repertoire is missing from some bearing record (`candidates_eq_iff`). Both
  conditions are local: one per record, one record per rival. Without distinct meanings the law
  fails (`Repeated`).
* **Records only narrow.** The candidates after a further history of records are the earlier
  candidates that stand on that history (`candidates_append`); a record bearing on the form keeps
  exactly the candidates it offers, and a record not bearing on it changes nothing
  (`candidates_snoc_bearing`, `candidates_snoc_other`). So a meaning ruled out stays ruled out
  (`narrows`), and a candidate stays one exactly while every later bearing record offers it
  (`stays_iff`).
* **Coverage makes a unique resolution right.** Where the target is in the repertoire and every
  bearing record offers it, any unique candidate is the target (`resolved_is_target`). One record
  omitting the target can leave a wrong meaning as the only candidate (`Omitted`).
* **Records read through a family of explanations.** Where a record offers a meaning exactly when
  some world of a family with that meaning as its target explains the record, and each bearing
  record is explained by some family world with the target `t`, the form resolves to `t` exactly
  when every other meaning of the repertoire is ruled out by some bearing record that no family
  world with that meaning explains (`resolves_explained_iff`).
* **Reading every sequence.** Where grouping recovers the words of every encoded sequence
  (`Becoming.Segmentation`), reading every encoded sequence by resolution gives the meanings of
  its words exactly when each word's records separate its meaning (`reads_every_iff`).

No premise is added; the module imports only the core and every declaration has an empty axiom
report.
-/

namespace Becoming.CrossSituational

universe u v w x

/-! ## Lists -/

section Lists

variable {M : Type v}

/-- Exactly one element: the resolution of a list of candidates. -/
def unique : List M → Option M
  | [] => none
  | [e] => some e
  | _ :: _ :: _ => none

theorem unique_eq_some_iff : ∀ {l : List M} {e : M}, unique l = some e ↔ l = [e]
  | [], _ => ⟨fun h => (nomatch h), fun h => nomatch h⟩
  | [_], _ => ⟨fun h => congrArg (fun y => [y]) (Option.some.inj h),
      fun h => congrArg some (List.cons.inj h).1⟩
  | _ :: _ :: _, _ => ⟨fun h => (nomatch h), fun h => nomatch h⟩

theorem filter_true {p : M → Bool} {m : M} (ms : List M) (h : p m = true) :
    List.filter p (m :: ms) = m :: List.filter p ms := by
  show (match p m with
    | true => m :: List.filter p ms
    | false => List.filter p ms) = m :: List.filter p ms
  rw [h]

theorem filter_false {p : M → Bool} {m : M} (ms : List M) (h : p m = false) :
    List.filter p (m :: ms) = List.filter p ms := by
  show (match p m with
    | true => m :: List.filter p ms
    | false => List.filter p ms) = List.filter p ms
  rw [h]

theorem false_ne_true : (false = true) → False := fun h => nomatch h

theorem filter_nil_of {p : M → Bool} :
    ∀ {l : List M}, (∀ m, m ∈ l → p m = true → False) → List.filter p l = []
  | [], _ => rfl
  | x :: xs, nothing => by
    cases hx : p x with
    | true => exact (nothing x (.head xs) hx).elim
    | false =>
      rw [filter_false xs hx]
      exact filter_nil_of fun m mem pm => nothing m (.tail x mem) pm

theorem filter_singleton_of {p : M → Bool} {e : M} :
    ∀ (l : List M), Distinct l → e ∈ l → p e = true →
      (∀ m, m ∈ l → p m = true → m = e) → List.filter p l = [e]
  | [], _, mem, _, _ => nomatch mem
  | x :: xs, ⟨fresh, rest⟩, mem, pe, only => by
    cases hx : p x with
    | true =>
      have same : x = e := only x (.head xs) hx
      rw [filter_true xs hx]
      have empty : List.filter p xs = [] := filter_nil_of fun m mm pm =>
        fresh ((only m (.tail x mm) pm).trans same.symm ▸ mm)
      rw [empty, same]
    | false =>
      rw [filter_false xs hx]
      have later : e ∈ xs := by
        cases mem with
        | head => exact (false_ne_true (hx.symm.trans pe)).elim
        | tail _ mem' => exact mem'
      exact filter_singleton_of xs rest later pe fun m mm pm => only m (.tail x mm) pm

/-- **A filter keeps exactly one element of a list without repeats** exactly when that element
is in the list, passes, and is the only element that passes. -/
theorem filter_eq_singleton_iff {p : M → Bool} {l : List M} (distinct : Distinct l) {e : M} :
    List.filter p l = [e] ↔ e ∈ l ∧ p e = true ∧ ∀ m, m ∈ l → p m = true → m = e :=
  ⟨fun kept =>
    have inside : e ∈ List.filter p l := kept ▸ List.Mem.head []
    ⟨(ListTests.mem_filter_iff.mp inside).1, (ListTests.mem_filter_iff.mp inside).2,
     fun _ mem pm => mem_singleton (kept ▸ ListTests.mem_filter_iff.mpr ⟨mem, pm⟩)⟩,
   fun ⟨mem, pe, only⟩ => filter_singleton_of l distinct mem pe only⟩

theorem filter_congr {p q : M → Bool} (same : ∀ m, p m = q m) :
    ∀ l : List M, List.filter p l = List.filter q l
  | [] => rfl
  | x :: xs => by
    cases hx : p x with
    | true =>
      rw [filter_true xs hx, filter_true xs ((same x).symm.trans hx), filter_congr same xs]
    | false =>
      rw [filter_false xs hx, filter_false xs ((same x).symm.trans hx), filter_congr same xs]

theorem filter_filter (p q : M → Bool) :
    ∀ l : List M, List.filter q (List.filter p l) = List.filter (fun m => p m && q m) l
  | [] => rfl
  | x :: xs => by
    cases hp : p x with
    | true =>
      rw [filter_true xs hp]
      cases hq : q x with
      | true =>
        have both : (p x && q x) = true := by rw [hp, hq]; rfl
        rw [filter_true _ hq, filter_true (p := fun m => p m && q m) xs both, filter_filter p q xs]
      | false =>
        have neither : (p x && q x) = false := by rw [hp, hq]; rfl
        rw [filter_false _ hq, filter_false (p := fun m => p m && q m) xs neither,
          filter_filter p q xs]
    | false =>
      have neither : (p x && q x) = false := by rw [hp]; rfl
      rw [filter_false xs hp, filter_false (p := fun m => p m && q m) xs neither,
        filter_filter p q xs]

theorem filter_all_true {p : M → Bool} (all : ∀ m, p m = true) :
    ∀ l : List M, List.filter p l = l
  | [] => rfl
  | x :: xs => by rw [filter_true xs (all x), filter_all_true all xs]

end Lists

/-! ## Standing and candidates -/

section Standing

variable {R : Type u} {M : Type v}

theorem implies_eq_true : ∀ {a c : Bool}, (!a || c) = true ↔ (a = true → c = true)
  | true, true => ⟨fun _ _ => rfl, fun _ => rfl⟩
  | true, false => ⟨fun h => (nomatch h), fun h => nomatch (h rfl)⟩
  | false, _ => ⟨fun _ h => (nomatch h), fun _ => rfl⟩

theorem and_assoc : ∀ a b c : Bool, ((a && b) && c) = (a && (b && c))
  | true, _, _ => rfl
  | false, _, _ => rfl

/-- `m` stands for the form read by `bears`: every record bearing on the form offers it. -/
def stands (bears : R → Bool) (offers : R → M → Bool) (rs : List R) (m : M) : Bool :=
  rs.all fun r => !bears r || offers r m

/-- The candidates of the form: the meanings of the repertoire that stand. -/
def candidates (bears : R → Bool) (offers : R → M → Bool) (rep : List M) (rs : List R) : List M :=
  List.filter (stands bears offers rs) rep

variable {bears : R → Bool} {offers : R → M → Bool}

theorem stands_cons (r : R) (rs : List R) (m : M) :
    stands bears offers (r :: rs) m = ((!bears r || offers r m) && stands bears offers rs m) :=
  rfl

/-- **A meaning stands exactly when every record bearing on the form offers it.** -/
theorem stands_iff {m : M} :
    ∀ {rs : List R}, stands bears offers rs m = true ↔
      ∀ r, r ∈ rs → bears r = true → offers r m = true
  | [] => ⟨fun _ _ mem => (nomatch mem), fun _ => rfl⟩
  | r :: rs =>
    ⟨fun h =>
      have both := ListTests.and_true_iff.mp ((stands_cons r rs m).symm.trans h)
      fun r' mem br => by
        cases mem with
        | head => exact implies_eq_true.mp both.1 br
        | tail _ mem' => exact (stands_iff.mp both.2) r' mem' br,
     fun all => (stands_cons r rs m).trans (ListTests.and_true_iff.mpr
      ⟨implies_eq_true.mpr (all r (.head rs)), stands_iff.mpr fun r' mem => all r' (.tail r mem)⟩)⟩

/-- **A meaning fails to stand exactly when some record bearing on the form does not offer it.** -/
theorem stands_false_iff {m : M} :
    ∀ {rs : List R}, stands bears offers rs m = false ↔
      ∃ r, r ∈ rs ∧ bears r = true ∧ offers r m = false
  | [] => ⟨fun h => (nomatch h), fun ⟨_, mem, _⟩ => nomatch mem⟩
  | r :: rs => by
    rw [stands_cons]
    cases hb : bears r with
    | false =>
      show stands bears offers rs m = false ↔ _
      constructor
      · intro h
        obtain ⟨r', mem, br, om⟩ := stands_false_iff.mp h
        exact ⟨r', .tail r mem, br, om⟩
      · intro ⟨r', mem, br, om⟩
        cases mem with
        | head => exact (false_ne_true (hb.symm.trans br)).elim
        | tail _ mem' => exact stands_false_iff.mpr ⟨r', mem', br, om⟩
    | true =>
      cases ho : offers r m with
      | false => exact ⟨fun _ => ⟨r, .head rs, hb, ho⟩, fun _ => rfl⟩
      | true =>
        show stands bears offers rs m = false ↔ _
        constructor
        · intro h
          obtain ⟨r', mem, br, om⟩ := stands_false_iff.mp h
          exact ⟨r', .tail r mem, br, om⟩
        · intro ⟨r', mem, br, om⟩
          cases mem with
          | head => exact (false_ne_true (om.symm.trans ho)).elim
          | tail _ mem' => exact stands_false_iff.mpr ⟨r', mem', br, om⟩

theorem mem_candidates {rep : List M} {rs : List R} {m : M} :
    m ∈ candidates bears offers rep rs ↔
      m ∈ rep ∧ ∀ r, r ∈ rs → bears r = true → offers r m = true :=
  ListTests.mem_filter_iff.trans ⟨fun ⟨mem, st⟩ => ⟨mem, stands_iff.mp st⟩, fun ⟨mem, all⟩ => ⟨mem, stands_iff.mpr all⟩⟩

/-- **Resolution is separation.** For a repertoire without repeats, the candidates of a form are
exactly `[e]` when `e` is in the repertoire, every record bearing on the form offers it, and
every other meaning of the repertoire is missing from some bearing record. -/
theorem candidates_eq_iff [DecidableEq M] {rep : List M} (distinct : Distinct rep)
    {rs : List R} {e : M} :
    candidates bears offers rep rs = [e] ↔
      e ∈ rep ∧ (∀ r, r ∈ rs → bears r = true → offers r e = true) ∧
        ∀ m, m ∈ rep → m ≠ e → ∃ r, r ∈ rs ∧ bears r = true ∧ offers r m = false :=
  (filter_eq_singleton_iff distinct).trans
    ⟨fun ⟨mem, pe, only⟩ =>
      ⟨mem, stands_iff.mp pe, fun m mm ne => by
        cases hs : stands bears offers rs m with
        | true => exact (ne (only m mm hs)).elim
        | false => exact stands_false_iff.mp hs⟩,
     fun ⟨mem, cover, separate⟩ =>
      ⟨mem, stands_iff.mpr cover, fun m mm pm =>
        match decEq m e with
        | isTrue same => same
        | isFalse ne =>
          match separate m mm ne with
          | ⟨r, rm, br, om⟩ => (false_ne_true (om.symm.trans (stands_iff.mp pm r rm br))).elim⟩⟩

/-- **The form resolves to `e`** exactly under the same separation. -/
theorem resolves_iff [DecidableEq M] {rep : List M} (distinct : Distinct rep)
    {rs : List R} {e : M} :
    unique (candidates bears offers rep rs) = some e ↔
      e ∈ rep ∧ (∀ r, r ∈ rs → bears r = true → offers r e = true) ∧
        ∀ m, m ∈ rep → m ≠ e → ∃ r, r ∈ rs ∧ bears r = true ∧ offers r m = false :=
  unique_eq_some_iff.trans (candidates_eq_iff distinct)

/-! ## Records only narrow -/

theorem stands_append (m : M) :
    ∀ rs more : List R, stands bears offers (rs ++ more) m =
      (stands bears offers rs m && stands bears offers more m)
  | [], _ => rfl
  | r :: rs, more =>
    (stands_cons (bears := bears) (offers := offers) r (rs ++ more) m).trans
      ((congrArg ((!bears r || offers r m) && ·) (stands_append m rs more)).trans
        (and_assoc _ _ _).symm)

/-- **The candidates after a further history of records are the earlier candidates that stand on
that history.** -/
theorem candidates_append (rep : List M) (rs more : List R) :
    candidates bears offers rep (rs ++ more) =
      List.filter (stands bears offers more) (candidates bears offers rep rs) :=
  (filter_congr (fun m => stands_append m rs more) rep).trans (filter_filter _ _ rep).symm

theorem stands_single (r : R) (m : M) :
    stands bears offers [r] m = (!bears r || offers r m) :=
  Bool.and_true _

/-- **A record bearing on the form keeps exactly the candidates it offers.** -/
theorem candidates_snoc_bearing (rep : List M) (rs : List R) {r : R} (bearing : bears r = true) :
    candidates bears offers rep (rs ++ [r]) = List.filter (offers r) (candidates bears offers rep rs) :=
  (candidates_append rep rs [r]).trans (filter_congr (fun m =>
    (stands_single r m).trans (by rw [bearing]; rfl)) _)

/-- **A record not bearing on the form leaves its candidates as they were.** -/
theorem candidates_snoc_other (rep : List M) (rs : List R) {r : R} (other : bears r = false) :
    candidates bears offers rep (rs ++ [r]) = candidates bears offers rep rs :=
  (candidates_append rep rs [r]).trans (filter_all_true (fun m =>
    (stands_single r m).trans (by rw [other]; rfl)) _)

/-- **A meaning ruled out stays ruled out.** -/
theorem narrows {rep : List M} {rs more : List R} {m : M}
    (later : m ∈ candidates bears offers rep (rs ++ more)) : m ∈ candidates bears offers rep rs :=
  (ListTests.mem_filter_iff.mp ((candidates_append rep rs more) ▸ later)).1

/-- **A candidate stays one exactly while every later bearing record offers it.** -/
theorem stays_iff {rep : List M} {rs more : List R} {m : M} :
    m ∈ candidates bears offers rep (rs ++ more) ↔
      m ∈ candidates bears offers rep rs ∧ ∀ r, r ∈ more → bears r = true → offers r m = true := by
  rw [candidates_append]
  exact ListTests.mem_filter_iff.trans ⟨fun ⟨mem, st⟩ => ⟨mem, stands_iff.mp st⟩,
    fun ⟨mem, all⟩ => ⟨mem, stands_iff.mpr all⟩⟩

/-! ## Coverage -/

/-- **Under coverage a unique candidate is the target.** -/
theorem resolved_is_target {rep : List M} {rs : List R} {t e : M} (available : t ∈ rep)
    (covered : ∀ r, r ∈ rs → bears r = true → offers r t = true)
    (resolved : candidates bears offers rep rs = [e]) : e = t :=
  (mem_singleton (resolved ▸ mem_candidates.mpr ⟨available, covered⟩)).symm

/-- **Records read through a family of explanations.** A record offers a meaning exactly when some
family world with that meaning as its target explains it, and each record bearing on the form is
explained by some family world with the target `t`. Then the form's candidates are exactly `[t]`
when every other meaning of the repertoire is ruled out by some bearing record that no family
world with that meaning explains. -/
theorem resolves_explained_iff [DecidableEq M] {W : Type w} (family : W → Prop) (target : W → M)
    (explains : R → W → Prop)
    (offered : ∀ r m, offers r m = true ↔ ∃ w, family w ∧ target w = m ∧ explains r w)
    {rep : List M} (distinct : Distinct rep) {rs : List R} {t : M} (available : t ∈ rep)
    (actual : ∀ r, r ∈ rs → bears r = true → ∃ w, family w ∧ target w = t ∧ explains r w) :
    candidates bears offers rep rs = [t] ↔
      ∀ m, m ∈ rep → m ≠ t → ∃ r, r ∈ rs ∧ bears r = true ∧
        ∀ w, family w → target w = m → ¬ explains r w :=
  (candidates_eq_iff distinct).trans
    ⟨fun ⟨_, _, separate⟩ m mm ne =>
      match separate m mm ne with
      | ⟨r, rm, br, om⟩ => ⟨r, rm, br, fun w fw tw ex =>
          false_ne_true (om.symm.trans ((offered r m).mpr ⟨w, fw, tw, ex⟩))⟩,
     fun ruled => ⟨available, fun r rm br => (offered r t).mpr (actual r rm br), fun m mm ne =>
      match ruled m mm ne with
      | ⟨r, rm, br, unexplained⟩ => ⟨r, rm, br, by
          cases ho : offers r m with
          | false => rfl
          | true =>
            obtain ⟨w, fw, tw, ex⟩ := (offered r m).mp ho
            exact (unexplained w fw tw ex).elim⟩⟩⟩

end Standing

/-! ## Reading every encoded sequence -/

section Reading

open Becoming.Segmentation

variable {α : Type u} {W : Type v} {R : Type w} {M : Type x} [DecidableEq M]

/-- **Reading every sequence by cross-situational resolution.** Where grouping by `r` recovers
the words of every encoded sequence, reading each group by resolving it among the repertoire
gives the meanings of the words of every encoded sequence exactly when, for each word, the
records bearing on it separate its meaning: the meaning is in the repertoire, every bearing
record offers it, and every other meaning of the repertoire is missing from some bearing record. -/
theorem reads_every_iff (r : α → α → Bool) (word : W → List α) (meaning : W → M)
    (bears : List α → R → Bool) (offers : R → M → Bool) {rep : List M} (distinct : Distinct rep)
    (rs : List R) (segments : ∀ ws, chunks r (encode word ws) = ws.map word) :
    (∀ ws, readAll (fun f => unique (candidates (bears f) offers rep rs))
        (chunks r (encode word ws)) = some (ws.map meaning)) ↔
      ∀ w, meaning w ∈ rep ∧ (∀ x, x ∈ rs → bears (word w) x = true → offers x (meaning w) = true) ∧
        ∀ m, m ∈ rep → m ≠ meaning w → ∃ x, x ∈ rs ∧ bears (word w) x = true ∧ offers x m = false :=
  (Segmentation.reads_every_iff r word _ meaning segments).trans
    ⟨fun each w => (resolves_iff distinct).mp (each w),
     fun each w => (resolves_iff distinct).mpr (each w)⟩

end Reading

/-! ## Witnesses -/

/-! A repertoire that repeats a meaning: the separation conditions hold for `0`, yet the
candidates are `[0, 0]`, not `[0]`. Distinct meanings are needed. -/
namespace Repeated

def rep : List Nat := [0, 0]

theorem only_zero (m : Nat) (mem : m ∈ rep) : m = 0 := by
  cases mem with
  | head => rfl
  | tail _ rest => exact mem_singleton rest

theorem separated :
    (0 ∈ rep) ∧ (∀ r, r ∈ ([] : List Unit) → (fun _ => true) r = true → (fun _ _ => true) r 0 = true) ∧
      ∀ m, m ∈ rep → m ≠ 0 → ∃ r, r ∈ ([] : List Unit) ∧ (fun _ => true) r = true ∧
        (fun (_ : Unit) (_ : Nat) => true) r m = false :=
  ⟨.head _, fun _ mem => (nomatch mem), fun m mem ne => (ne (only_zero m mem)).elim⟩

theorem not_resolved :
    candidates (fun _ : Unit => true) (fun _ (_ : Nat) => true) rep [] = [0, 0] := rfl

end Repeated

/-! One record omitting the target `0`, offering only `1`, leaves `1` as the only candidate. -/
namespace Omitted

def offers (_ : Unit) (m : Nat) : Bool := Nat.beq m 1

theorem wrong_unique : candidates (fun _ : Unit => true) offers [0, 1] [()] = [1] := rfl

theorem target_uncovered : offers () 0 = false := rfl

end Omitted

end Becoming.CrossSituational
