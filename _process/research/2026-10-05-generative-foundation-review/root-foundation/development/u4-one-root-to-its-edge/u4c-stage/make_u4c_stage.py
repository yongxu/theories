"""U4c's stage for OU7's rebuild: the census on the root (CENSUS-ON-THE-ROOT.md).

Makes U4c's changes to the Lean package of a checkout, one step at a time, each step asserting every
anchor it edits occurs exactly once. Run from the root of a throwaway tree after OU7's kit's
`land_ou7.sh prepare` and `apply`, committing after each step, so that each step's diff is one patch
of the series (kit/stages/NN-u4c/):

    python3 -B make_u4c_stage.py prelude       # 01: the moves into the prelude, three generalized
    python3 -B make_u4c_stage.py grammarlaws   # 02: the census laws and their counting lemmas
    python3 -B make_u4c_stage.py arising       # 03: the class on occurrences, nothing splits along
    python3 -B make_u4c_stage.py population    # 04: the bridges, the occurrences, two re-proofs
    python3 -B make_u4c_stage.py identity      # 05: the re-proof, the instance out of the section

The proofs are those checked in u4c-scratch (U4cCensus, U4cCases), with their landing names.
"""
import re
import sys
from pathlib import Path

PKG = Path("experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming")


def read(name):
    return (PKG / f"{name}.lean").read_text(encoding="utf-8")


def write(name, text):
    (PKG / f"{name}.lean").write_text(text, encoding="utf-8")


def once(text, anchor, where):
    n = text.count(anchor)
    assert n == 1, f"{where}: anchor found {n} times: {anchor[:80]!r}"


def replace(text, old, new, where):
    once(text, old, where)
    return text.replace(old, new)


def insert_before(text, anchor, block, where):
    once(text, anchor, where)
    return text.replace(anchor, block + anchor)


def cut(text, name, where):
    """Cut the declaration `theorem name` with its docstring: from the docstring's start (or the
    theorem's line) to the blank line after it, which goes too."""
    lines = text.split("\n")
    hits = [i for i, l in enumerate(lines) if re.match(rf"theorem {re.escape(name)}( |$)", l)]
    assert len(hits) == 1, f"{where}: theorem {name} found {len(hits)} times"
    start = hits[0]
    if start > 0 and lines[start - 1].rstrip().endswith("-/"):
        while not lines[start - 1].startswith("/--"):
            start -= 1
        start -= 1
    end = hits[0]
    while end < len(lines) and lines[end].strip():
        end += 1
    block = "\n".join(lines[start:end])
    rest = lines[:start] + lines[end + 1:]
    return "\n".join(rest), block


# ---------------------------------------------------------------------------------------------------
# 01: the moves into the prelude

FROM_POPULATION_ONCE = ["mem_remove", "length_le_of_matched", "not_not_all"]
FROM_POPULATION_STRETCH = ["gaining_of_losing", "losing_of_gaining", "recurs_shift", "recurs_unshift",
                           "gaining_of_losing_from", "losing_of_gaining_from"]
FROM_CHANGE = ["steps_mem", "steps_last", "steps_mono", "recurring_accumulates", "pos_of_exceeds"]

PAIRS = '''
/-- A member of a list paired with a step is the step with a member of the list. -/
theorem mem_map_prodMk {t : Nat} : ∀ {zs : List α} {y : Nat × α}, y ∈ zs.map (fun a => (t, a)) →
    y.1 = t ∧ y.2 ∈ zs
  | [], _, my => nomatch my
  | _ :: _, _, my => match mem_cons_cases my with
    | .inl s => ⟨congrArg Prod.fst s, (congrArg Prod.snd s).symm ▸ .head _⟩
    | .inr m => match mem_map_prodMk m with | ⟨h1, h2⟩ => ⟨h1, .tail _ h2⟩

/-- Pairing a list with a step pairs each of its members. -/
theorem prodMk_mem_map {t : Nat} {a : α} : ∀ {zs : List α}, a ∈ zs → (t, a) ∈ zs.map (fun a => (t, a))
  | [], m => nomatch m
  | _ :: _, m => match mem_cons_cases m with
    | .inl s => s ▸ .head _
    | .inr m' => .tail _ (prodMk_mem_map m')

/-- A test is true where a proposition fails exactly when its decision is false. -/
theorem not_decide_iff {q : Prop} [Decidable q] : (!decide q) = true ↔ ¬ q := by
  cases h : decide q with
  | true => exact ⟨fun f => Bool.noConfusion f, fun n => absurd (of_decide_eq_true h) n⟩
  | false => exact ⟨fun _ => of_decide_eq_false h, fun _ => rfl⟩
'''

PRELUDE_HEADER_OLD = '''* **Balance over a stretch.**'''
PRELUDE_HEADER_NEW = '''* **Lists without repetition, matched** (U4c, moved from Population): removing one occurrence keeps
  the rest (`mem_remove`), a list without repetition matched one to one into another is no longer
  (`length_le_of_matched`), and a double negation for each member of a list is one for all
  (`not_not_all`), each in every universe; a positive total has a positive member (`total_pos`,
  from Flow); a list paired with a step (`mem_map_prodMk`, `prodMk_mem_map`) and a negated decision
  (`not_decide_iff`).
* **Stretches of steps and recurrence** (U4c, moved from Change and Population): the members and
  totals of a stretch (`steps_mem`, `steps_last`, `steps_mono`), totals of a recurring quantity
  exceeding every bound (`recurring_accumulates`, `pos_of_exceeds`), and the counting steps from
  losing to gaining and back (`gaining_of_losing`, `losing_of_gaining`, their forms from a step,
  `recurs_shift`, `recurs_unshift`), each through `le_over_stretch` or `ge_over_stretch`.
* **Balance over a stretch.**'''


def prelude():
    pop, change, flow, pre = read("Population"), read("Change"), read("Flow"), read("Prelude")
    once_blocks, stretch_blocks, change_blocks = [], [], []
    for n in FROM_POPULATION_ONCE:
        pop, b = cut(pop, n, "Population")
        once_blocks.append(b)
    for n in FROM_POPULATION_STRETCH:
        pop, b = cut(pop, n, "Population")
        stretch_blocks.append(b)
    for n in FROM_CHANGE:
        change, b = cut(change, n, "Change")
        change_blocks.append(b)
    change = replace(change, "/-! ## Stretches of steps -/\n\n", "", "Change")
    flow, total_pos = cut(flow, "total_pos", "Flow")
    # The three generalized to every universe: the section's variables, and the cons lemma stated
    # in every universe (`mem_cons_cases` is stated at `Type` and is not changed).
    generalized = []
    for b in once_blocks:
        b = b.replace("mem_cons_cases mem", "ListTests.mem_cons_iff.mp mem")
        b = b.replace("theorem not_not_all {β : Type} {P : β → Prop}", "theorem not_not_all {P : β → Prop}")
        assert "mem_cons_cases" not in b and "Type}" not in b, b[:120]
        generalized.append(b)
    pre = replace(pre, PRELUDE_HEADER_OLD, PRELUDE_HEADER_NEW, "Prelude header")
    pre = insert_before(pre, "namespace Copying\n",
                        "\n\n".join(generalized) + "\n\n", "Prelude, section Once")
    pre = insert_before(pre, "\nend Lists\n", "\n" + PAIRS.rstrip("\n") + "\n", "Prelude, section Lists")
    pre = insert_before(pre, "end OnceLists\n", total_pos + "\n\n", "Prelude, section OnceLists")
    pre = insert_before(pre, "/-! ## Balance over a stretch",
                        "/-! ## Stretches of steps -/\n\n" + "\n\n".join(change_blocks) + "\n\n",
                        "Prelude, before the balance over a stretch")
    pre = insert_before(pre, "namespace RouteTraces\n",
                        "/-! ## From losing to gaining over a stretch -/\n\n" + "\n\n".join(stretch_blocks)
                        + "\n\n", "Prelude, after the balance over a stretch")
    for name, text in (("Population", pop), ("Change", change), ("Flow", flow), ("Prelude", pre)):
        write(name, text)


# ---------------------------------------------------------------------------------------------------
# 02: GrammarLaws' census section

GL_HEADER_ANCHOR = '''* **Lumping.** `«同行» R E`'''
GL_HEADER_NEW = '''* **The census, counted.** Counted by tests on the listed units, with no decision of identity,
  the census of a step holds by halves: under fixed successors, the units after with those a test
  marks as ceasing are at most the units before with those a test marks as arising
  (`«定后则后并亡不过前并生»`), and its mirror under fixed predecessors (`«定前则前并生不过后并亡»`); under both, the halves meet in the count of
  the paired census, the tests read off its decision (`«定后定前则前并生与后并亡同数»`). Along a run,
  where every predecessor of a unit listed after a step is listed before it, endings recurring give
  beginnings recurring (`«定后前者在前则亡屡者生屡»`). Each is the corollary of a local form that asks
  no split (no merge) only among the listed units (`GrammarLaws.census_le`, `census_le_converse`,
  `census_count`, `census_run`). The listing and the tests are supplied.
'''

CENSUS = '''
/-- A list keeps as many units as a test holds of. -/
theorem GrammarLaws.length_keep (p : α → Bool) : ∀ l : List α,
    (GrammarLaws.keep p l).length = «计» p l
  | [] => rfl
  | x :: l => by
    show (cond (p x) (x :: GrammarLaws.keep p l) (GrammarLaws.keep p l)).length =
      cond (p x) 1 0 + «计» p l
    cases p x with
    | true => exact (congrArg (· + 1) (length_keep p l)).trans (Nat.add_comm _ _)
    | false => exact (length_keep p l).trans (Nat.zero_add _).symm

/-- A list is the units a test holds of with those it fails of. -/
theorem GrammarLaws.count_add_not (p : α → Bool) : ∀ l : List α,
    «计» p l + «计» (fun x => !p x) l = l.length
  | [] => rfl
  | x :: l => by
    show (cond (p x) 1 0 + «计» p l) + (cond (!p x) 1 0 + «计» (fun x => !p x) l) = l.length + 1
    cases p x with
    | true =>
      show (1 + «计» p l) + (0 + «计» (fun x => !p x) l) = l.length + 1
      rw [Nat.zero_add, Nat.add_assoc, count_add_not p l, Nat.add_comm]
    | false =>
      show (0 + «计» p l) + (1 + «计» (fun x => !p x) l) = l.length + 1
      rw [Nat.zero_add, Nat.add_left_comm, count_add_not p l, Nat.add_comm]

/-- Keeping the units a test holds of keeps a list without repetition. -/
theorem GrammarLaws.distinct_keep (p : α → Bool) : ∀ {l : List α}, Distinct l →
    Distinct (GrammarLaws.keep p l)
  | [], _ => trivial
  | x :: l, ⟨fresh, once⟩ => by
    show Distinct (cond (p x) (x :: GrammarLaws.keep p l) (GrammarLaws.keep p l))
    cases p x with
    | true => exact ⟨fun mem => fresh (GrammarLaws.mem_keep.mp mem).1, distinct_keep p once⟩
    | false => exact distinct_keep p once

/-- A unit a test holds of makes its count positive. -/
theorem GrammarLaws.count_pos_of_mem {p : α → Bool} {x : α} {l : List α} (mem : x ∈ l)
    (holds : p x = true) : 0 < «计» p l :=
  match List.append_of_mem mem with
  | ⟨b₁, b₂, split⟩ => by
    rw [split, GrammarLaws.count_insert, holds]
    exact Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_add_right _ _)

/-- A test whose negation fails holds. -/
theorem GrammarLaws.eq_true_of_not_false : ∀ {c : Bool}, (!c) = false → c = true
  | true, _ => rfl
  | false, h => Bool.noConfusion h

/-- **The census of a step, counted, one side**, asking only what its proof uses. Units listed before
and after a step under a continuation (`«续» R E`), those after listed once, no unit before
continuing as two units listed after: where a test `b` fails only of units after with a predecessor
among the units before, as far as can be refuted, and a test `e` holds only of units before that no
unit after continues, the units after with those `e` holds of are at most the units before with
those `b` holds of. No decision of identity is used: a predecessor is found under a double negation,
the conclusion being a decided comparison of numbers. -/
theorem GrammarLaws.census_le {b e : α → Bool} {before after : List α} (dA : Distinct after)
    (noSplit : ∀ x y y', x ∈ before → y ∈ after → y' ∈ after → «续» R E x y → «续» R E x y' → y = y')
    (arising : ∀ y, y ∈ after → b y = false → ¬¬ ∃ x, x ∈ before ∧ «续» R E x y)
    (ceasing : ∀ x, x ∈ before → e x = true → ∀ y, y ∈ after → ¬ «续» R E x y) :
    after.length + «计» e before ≤ before.length + «计» b after :=
  have fewer : (GrammarLaws.keep (fun y => !b y) after).length ≤
      (GrammarLaws.keep (fun x => !e x) before).length :=
    Decidable.of_not_not fun more =>
      not_not_all (P := fun y => ∃ x, x ∈ GrammarLaws.keep (fun x => !e x) before ∧ «续» R E x y)
        (fun y my none =>
          have h := GrammarLaws.mem_keep.mp my
          arising y h.1 (GrammarLaws.not_eq_true_iff.mp h.2) fun ⟨x, mx, c⟩ =>
            none ⟨x, GrammarLaws.mem_keep.mpr ⟨mx, GrammarLaws.not_eq_true_iff.mpr
              (match he : e x with
               | false => rfl
               | true => absurd c (ceasing x mx he y h.1))⟩, c⟩)
        fun all => more (length_le_of_matched
          (S := fun y x => x ∈ GrammarLaws.keep (fun x => !e x) before ∧ «续» R E x y)
          (GrammarLaws.distinct_keep _ dA)
          (fun y my => match all y my with | ⟨x, mx, c⟩ => ⟨x, mx, mx, c⟩)
          fun y y' x my my' h h' => noSplit x y y' (GrammarLaws.mem_keep.mp h.1).1
            (GrammarLaws.mem_keep.mp my).1 (GrammarLaws.mem_keep.mp my').1 h.2 h'.2)
  calc after.length + «计» e before
      = («计» b after + (GrammarLaws.keep (fun y => !b y) after).length) + «计» e before := by
        rw [GrammarLaws.length_keep, GrammarLaws.count_add_not]
    _ ≤ («计» b after + (GrammarLaws.keep (fun x => !e x) before).length) + «计» e before :=
        Nat.add_le_add_right (Nat.add_le_add_left fewer _) _
    _ = before.length + «计» b after := by
        rw [GrammarLaws.length_keep, Nat.add_assoc, Nat.add_comm («计» (fun x => !e x) before),
          GrammarLaws.count_add_not, Nat.add_comm]

/-- **The census of a step, counted, one side**, under a continuation that fixes successors
(`GrammarLaws.census_le`, the fixed successor read at the listed units). `«定后»` is more than the
proof uses, which is no split among the units listed. -/
theorem «定后则后并亡不过前并生» {b e : α → Bool} {before after : List α}
    (dA : Distinct after) (fixedAfter : «定后» («续» R E))
    (arising : ∀ y, y ∈ after → b y = false → ¬¬ ∃ x, x ∈ before ∧ «续» R E x y)
    (ceasing : ∀ x, x ∈ before → e x = true → ∀ y, y ∈ after → ¬ «续» R E x y) :
    after.length + «计» e before ≤ before.length + «计» b after :=
  GrammarLaws.census_le dA (fun x y y' _ _ _ c c' => «定后之逐点».mp fixedAfter x y y' c c')
    arising ceasing

/-- **Its mirror**, the same law at the converse, asking only what its proof uses. The units before
listed once, no two units listed before continuing as one unit after: where `e` fails only of units
before with a successor among the units after, as far as can be refuted, and `b` holds only of units
after that no unit before continues, the units before with those `b` holds of are at most the units
after with those `e` holds of. -/
theorem GrammarLaws.census_le_converse {b e : α → Bool} {before after : List α}
    (dB : Distinct before)
    (noMerge : ∀ x x' y, x ∈ before → x' ∈ before → y ∈ after → «续» R E x y → «续» R E x' y → x = x')
    (ceasing : ∀ x, x ∈ before → e x = false → ¬¬ ∃ y, y ∈ after ∧ «续» R E x y)
    (arising : ∀ y, y ∈ after → b y = true → ∀ x, x ∈ before → ¬ «续» R E x y) :
    before.length + «计» b after ≤ after.length + «计» e before :=
  GrammarLaws.census_le (R := «逆» R) (E := «逆» E) (b := e) (e := b)
    (before := after) (after := before) dB
    (fun y x x' my mx mx' c c' => noMerge x x' y mx mx' my c c')
    ceasing arising

/-- **Its mirror** under a continuation that fixes predecessors (`GrammarLaws.census_le_converse`,
merging nothing read at the listed units). -/
theorem «定前则前并生不过后并亡» {b e : α → Bool} {before after : List α}
    (dB : Distinct before) (fixedBefore : «定前» («续» R E))
    (ceasing : ∀ x, x ∈ before → e x = false → ¬¬ ∃ y, y ∈ after ∧ «续» R E x y)
    (arising : ∀ y, y ∈ after → b y = true → ∀ x, x ∈ before → ¬ «续» R E x y) :
    before.length + «计» b after ≤ after.length + «计» e before :=
  GrammarLaws.census_le_converse dB
    (fun x x' y _ _ _ c c' => «定前之逐点».mp fixedBefore x x' y c c') ceasing arising

/-- **The two halves meet in the paired census's count**, asking only what the proof uses: the
hypotheses of the paired census (`GrammarLaws.census_pairs`), read on the continuation decided by
`k`. The units after with those ceasing are as many as the units before with those arising. The
pairing says more than the count; the count asks neither `k` nor the predecessors' or successors'
lists, only the tests. -/
theorem GrammarLaws.census_count (dec : ∀ x y, «续» R E x y ↔ k x y = true)
    (before after : List α) (dB : Distinct before) (dA : Distinct after)
    (noSplit : ∀ x y y', x ∈ before → y ∈ after → y' ∈ after → «续» R E x y → «续» R E x y' → y = y')
    (noMerge : ∀ x x' y, x ∈ before → x' ∈ before → y ∈ after → «续» R E x y → «续» R E x' y → x = x') :
    after.length + (GrammarLaws.ceasing k before after).length =
      before.length + (GrammarLaws.arising k before after).length :=
  have one := GrammarLaws.census_le (b := fun y => !(before.any fun g => k g y))
    (e := fun x => !(after.any (k x))) dA noSplit
    (fun y _ off none => match GrammarLaws.any_split (GrammarLaws.eq_true_of_not_false off) with
      | ⟨a₁, x, a₂, split, kx⟩ =>
        none ⟨x, split ▸ GrammarLaws.mem_middle x a₂ a₁, (dec x y).mpr kx⟩)
    (fun x _ on y my c => Bool.noConfusion ((GrammarLaws.any_false_mem
        (GrammarLaws.not_eq_true_iff.mp on) my).symm.trans ((dec x y).mp c)))
  have other := GrammarLaws.census_le_converse (b := fun y => !(before.any fun g => k g y))
    (e := fun x => !(after.any (k x))) dB noMerge
    (fun x _ off none => match GrammarLaws.any_split (GrammarLaws.eq_true_of_not_false off) with
      | ⟨a₁, y, a₂, split, ky⟩ =>
        none ⟨y, split ▸ GrammarLaws.mem_middle y a₂ a₁, (dec x y).mpr ky⟩)
    (fun y _ on x mx c => Bool.noConfusion ((GrammarLaws.any_false_mem (p := fun g => k g y)
        (GrammarLaws.not_eq_true_iff.mp on) mx).symm.trans ((dec x y).mp c)))
  by
    show after.length + (GrammarLaws.keep _ before).length =
      before.length + (GrammarLaws.keep _ after).length
    rw [GrammarLaws.length_keep, GrammarLaws.length_keep]
    exact Nat.le_antisymm one other

/-- **The two halves meet in the paired census's count**, under the paired census
(`«定后定前则前并生对后并亡»`), the tests read off `k` (`GrammarLaws.census_count`). -/
theorem «定后定前则前并生与后并亡同数» (dec : ∀ x y, «续» R E x y ↔ k x y = true)
    (before after : List α) (dB : Distinct before) (dA : Distinct after)
    (fixedAfter : «定后» («续» R E)) (fixedBefore : «定前» («续» R E)) :
    after.length + (GrammarLaws.ceasing k before after).length =
      before.length + (GrammarLaws.arising k before after).length :=
  GrammarLaws.census_count dec before after dB dA
    (fun x y y' _ _ _ c c' => «定后之逐点».mp fixedAfter x y y' c c')
    (fun x x' y _ _ _ c c' => «定前之逐点».mp fixedBefore x x' y c c')

/-- **The census of a run**, asking only what its proof uses. Units listed at each step of a run
under a continuation, from step `T` on: the units after each step listed once, no unit listed
before a step continuing as two units listed after it, every predecessor of a unit listed after a
step listed before it, and the root's beginnings (`«生»`) and endings (`«亡»`) decided on the listed
units by tests. Where endings recur among the listed units (`«屡»`), beginnings recur among the
units listed after a step. At each step the census of a step applies, and the counting step from
losing to gaining (`gaining_of_losing_from`) sums it over a stretch. -/
theorem GrammarLaws.census_run {b e : α → Bool} {u : Nat → List α} {T : Nat}
    (once : ∀ t, T ≤ t → Distinct (u (t + 1)))
    (noSplit : ∀ t, T ≤ t → ∀ x y y', x ∈ u t → y ∈ u (t + 1) → y' ∈ u (t + 1) →
      «续» R E x y → «续» R E x y' → y = y')
    (predecessorsBefore : ∀ t, T ≤ t → ∀ x y, y ∈ u (t + 1) → «续» R E x y → x ∈ u t)
    (begins : ∀ t, T ≤ t → ∀ y, y ∈ u (t + 1) → (b y = true ↔ «生» R E y))
    (ends : ∀ t, T ≤ t → ∀ x, x ∈ u t → (e x = true ↔ «亡» R E x))
    (ending : «屡» (fun before _ => ∃ x, x ∈ before ∧ «亡» R E x) u) :
    «屡» (fun _ after => ∃ y, y ∈ after ∧ «生» R E y) u :=
  fun N =>
    match gaining_of_losing_from (T := T) (q := fun t => (u t).length)
        (x := fun t => «计» e (u t)) (y := fun t => «计» b (u (t + 1)))
        (fun t from_ => GrammarLaws.census_le (once t from_) (noSplit t from_)
          (fun y my off none =>
            (fun begins' : «生» R E y =>
              Bool.noConfusion (((begins t from_ y my).mpr begins').symm.trans off))
            fun ⟨x, c⟩ => none ⟨x, predecessorsBefore t from_ x y my c, c⟩)
          (fun x mx on y _ c => (ends t from_ x mx).mp on ⟨y, c⟩))
        (fun M => match ending (M + T) with
          | ⟨t, later, x, mx, en⟩ =>
            ⟨t, Nat.le_trans (Nat.le_add_right M T) later, GrammarLaws.count_pos_of_mem mx
              ((ends t (Nat.le_trans (Nat.le_add_left T M) later) x mx).mpr en)⟩)
        (N + T) with
    | ⟨t, later, pos⟩ =>
      match GrammarLaws.split_of_count_pos pos with
      | ⟨b₁, y, b₂, split, tested⟩ =>
        have my : y ∈ u (t + 1) := split ▸ GrammarLaws.mem_middle y b₂ b₁
        ⟨t, Nat.le_trans (Nat.le_add_right N T) later, y, my,
          (begins t (Nat.le_trans (Nat.le_add_left T N) later) y my).mp tested⟩

/-- **The census of a run** under a continuation that fixes successors (`GrammarLaws.census_run`,
the fixed successor read at the listed units). -/
theorem «定后前者在前则亡屡者生屡» {b e : α → Bool} {u : Nat → List α} {T : Nat}
    (once : ∀ t, T ≤ t → Distinct (u (t + 1)))
    (predecessorsBefore : ∀ t, T ≤ t → ∀ x y, y ∈ u (t + 1) → «续» R E x y → x ∈ u t)
    (fixedAfter : «定后» («续» R E))
    (begins : ∀ t, T ≤ t → ∀ y, y ∈ u (t + 1) → (b y = true ↔ «生» R E y))
    (ends : ∀ t, T ≤ t → ∀ x, x ∈ u t → (e x = true ↔ «亡» R E x))
    (ending : «屡» (fun before _ => ∃ x, x ∈ before ∧ «亡» R E x) u) :
    «屡» (fun _ after => ∃ y, y ∈ after ∧ «生» R E y) u :=
  GrammarLaws.census_run once
    (fun _ _ x y y' _ _ _ c c' => «定后之逐点».mp fixedAfter x y y' c c')
    predecessorsBefore begins ends ending
'''


def grammarlaws():
    gl = read("GrammarLaws")
    gl = insert_before(gl, GL_HEADER_ANCHOR, GL_HEADER_NEW, "GrammarLaws header, before Lumping")
    gl = insert_before(gl, "\nend Census\n", "\n" + CENSUS.strip("\n") + "\n", "GrammarLaws census section")
    write("GrammarLaws", gl)


# ---------------------------------------------------------------------------------------------------
# 03: Arising

STEPS = '''
/-- The two-valued class of a determination on occurrences (二值之类): two occurrences are alike
when the determination holds at one exactly when it holds at the other. `Steps.alike` is the same
class on the steps of one determination. -/
def alikeAt {F : Type} (p : F → Nat → Prop) : «际» (Nat × F) := fun x y => p x.2 x.1 ↔ p y.2 y.1

/-- Along a relatum nothing splits, under every class: each occurrence continues as at most one. -/
theorem along_fixed {F : Type} (E : «际» (Nat × F)) : «定后» («续» along E) :=
  «定后之逐点».mpr fun x y z ⟨⟨y1, y2⟩, _⟩ ⟨⟨z1, z2⟩, _⟩ => by
    obtain ⟨y₁, y₂⟩ := y
    obtain ⟨z₁, z₂⟩ := z
    dsimp only at y1 y2 z1 z2
    subst y1; subst y2; subst z1; subst z2; rfl
'''

ACTIVITY = '''
/-- The class of activity is the two-valued class of activity on occurrences. -/
theorem activityClass_eq_alikeAt : W.activityClass = Steps.alikeAt (fun f t => W.active t f) := rfl
'''


def arising():
    a = read("Arising")
    a = insert_before(a, "\nend Steps\n", "\n" + STEPS.strip("\n") + "\n", "Arising, namespace Steps")
    a = replace(a, "theorem activityClass_class : «类» W.activityClass :=\n  ⟨fun _ => Iff.rfl, Iff.symm, Iff.trans⟩\n",
                "theorem activityClass_class : «类» W.activityClass :=\n  ⟨fun _ => Iff.rfl, Iff.symm, Iff.trans⟩\n"
                + ACTIVITY, "Arising, Web.activityClass")
    write("Arising", a)


# ---------------------------------------------------------------------------------------------------
# 04: Population

OCCURRENCES = '''/-! ## Occurrences of what holds -/

section Occurrences

variable {p : α → Nat → Prop}

/-- **Coming to be is a beginning (生) along a member's occurrences.** A member comes to be across
the step from `t` exactly where it holds after the step and its occurrence after the step begins,
along its steps under the class of its determination. Change's `comesToBe_iff_sheng` reads one
determination along `Steps.next`; this reads a member's along `Steps.along`. -/
theorem comesToBe_iff_sheng_along {t : Nat} {a : α} :
    ComesToBe (p a) t ↔ p a (t + 1) ∧ «生» Steps.along (Steps.alikeAt p) (t + 1, a) :=
  ⟨fun ⟨before, after⟩ =>
    ⟨after, fun hp => before (Iff.mpr (Steps.along_hasPred_iff.mp hp) after)⟩,
   fun ⟨after, begins⟩ =>
    ⟨fun was => begins (Steps.along_hasPred_iff.mpr ⟨fun _ => after, fun _ => was⟩), after⟩⟩

/-- **Ceasing to be is an ending (亡) along a member's occurrences.** A member ceases to be across
the step from `t` exactly where it holds before the step and its occurrence before the step ends. -/
theorem ceasesToBe_iff_wang_along {t : Nat} {a : α} :
    CeasesToBe (p a) t ↔ p a t ∧ «亡» Steps.along (Steps.alikeAt p) (t, a) :=
  ⟨fun ⟨held, gone⟩ =>
    ⟨held, fun hs => gone (Iff.mp (Steps.along_hasSucc_iff.mp hs) held)⟩,
   fun ⟨held, ends⟩ =>
    ⟨held, fun next => ends (Steps.along_hasSucc_iff.mpr ⟨fun _ => next, fun _ => held⟩)⟩⟩

/-- The occurrences listed at a step: each listed member paired with the step. -/
def listedOccurrences (l : Nat → List α) (t : Nat) : List (Nat × α) := (l t).map fun a => (t, a)

variable [∀ a t, Decidable (p a t)]

/-- The beginnings' test on occurrences: an occurrence after the step from `t` begins where its
member failed at `t`. -/
def beginTest (p : α → Nat → Prop) [∀ a t, Decidable (p a t)] : Nat × α → Bool
  | (0, _) => true
  | (t + 1, a) => !decide (p a t)

/-- The endings' test on occurrences: an occurrence at `t` ends where its member fails at `t + 1`. -/
def endTest (p : α → Nat → Prop) [∀ a t, Decidable (p a t)] (x : Nat × α) : Bool :=
  !decide (p x.2 (x.1 + 1))

end Occurrences

/-- The total of marks is the count of their decisions. -/
theorem total_mark_eq_count {P : α → Prop} [∀ a, Decidable (P a)] :
    ∀ l : List α, total l (fun a => mark (P a)) = «计» (fun a => decide (P a)) l
  | [] => rfl
  | x :: l => by
    show mark (P x) + total l (fun a => mark (P a)) = cond (decide (P x)) 1 0 + «计» _ l
'''

ACROSS_OLD = '''/-- The census balance across a step, where what holds is listed at its two ends: the list
after it with the members that ceased to be is the list before it with the members that came
to be. The members kept across the step are counted alike on both lists. -/
theorem across_at {t : Nat} (now : Distinct (l t) ∧ ∀ a, p a t ↔ a ∈ l t)
    (next : Distinct (l (t + 1)) ∧ ∀ a, p a (t + 1) ↔ a ∈ l (t + 1)) :
    (l (t + 1)).length + ceasings (l t) p t = (l t).length + comings (l (t + 1)) p t :=
  match keeps_at now next with
  | ⟨_, before, after⟩ => (congrArg (· + _) after).trans
      ((Nat.add_right_comm _ _ _).trans (congrArg (· + _) before.symm))
'''

ACROSS_NEW = '''/-- The census balance across a step, where what holds is listed at its two ends: the list
after it with the members that ceased to be is the list before it with the members that came
to be. It is the root's census of a step, both halves (`«定后则后并亡不过前并生»`,
`«定前则前并生不过后并亡»`), at the step's relation on members: each continues only itself, holding
at both ends. -/
theorem across_at {t : Nat} (now : Distinct (l t) ∧ ∀ a, p a t ↔ a ∈ l t)
    (next : Distinct (l (t + 1)) ∧ ∀ a, p a (t + 1) ↔ a ∈ l (t + 1)) :
    (l (t + 1)).length + ceasings (l t) p t = (l t).length + comings (l (t + 1)) p t :=
  have one := «定后则后并亡不过前并生» (R := fun a b => a = b) (E := fun a b => p a t ∧ p b (t + 1))
    (b := fun a => decide (ComesToBe (p a) t)) (e := fun a => decide (CeasesToBe (p a) t))
    (before := l t) (after := l (t + 1)) next.1
    («定后之逐点».mpr fun _ _ _ c c' => c.1.symm.trans c'.1)
    (fun y my off none =>
      have holds : p y (t + 1) := (next.2 y).mpr my
      (fun np : ¬ p y t => of_decide_eq_false off ⟨np, holds⟩)
        fun held => none ⟨y, (now.2 y).mp held, rfl, held, holds⟩)
    (fun x _ on y _ c => match c with
      | ⟨same, _, after⟩ => (of_decide_eq_true on).2 (same ▸ after))
  have other := «定前则前并生不过后并亡» (R := fun a b => a = b)
    (E := fun a b => p a t ∧ p b (t + 1))
    (b := fun a => decide (ComesToBe (p a) t)) (e := fun a => decide (CeasesToBe (p a) t))
    (before := l t) (after := l (t + 1)) now.1
    («定前之逐点».mpr fun _ _ _ c c' => c.1.trans c'.1.symm)
    (fun x mx off none =>
      have held : p x t := (now.2 x).mpr mx
      (fun nn : ¬ p x (t + 1) => of_decide_eq_false off ⟨held, nn⟩)
        fun next' => none ⟨x, (next.2 x).mp next', rfl, held, next'⟩)
    (fun y _ on x _ c => match c with
      | ⟨same, before, _⟩ => (of_decide_eq_true on).1 (same.symm ▸ before))
  by
    show (l (t + 1)).length + total (l t) (fun a => mark (CeasesToBe (p a) t)) =
      (l t).length + total (l (t + 1)) (fun a => mark (ComesToBe (p a) t))
    rw [total_mark_eq_count, total_mark_eq_count]
    exact Nat.le_antisymm one other
'''

COMING_OLD = '''/-- The census law: where what holds is listed at each step, ceasing to be at arbitrarily
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
'''

COMING_NEW = '''/-- The census law: where what holds is listed at each step, ceasing to be at arbitrarily
late steps needs coming to be at arbitrarily late steps. It is the root's census of a run
(`«定后前者在前则亡屡者生屡»`) at a member's occurrences along its steps (`Steps.along`), under the
two-valued class of its determination, where coming to be and ceasing to be are a beginning and an
ending (`comesToBe_iff_sheng_along`, `ceasesToBe_iff_wang_along`): the occurrences listed at each
step are listed once, each one's predecessor is listed before it, and nothing splits along the
steps (`Steps.along_fixed`). -/
theorem coming_of_ceasing (listed : Listed p l)
    (ceasing : ∀ N, ∃ t a, N ≤ t ∧ CeasesToBe (p a) t) :
    ∀ N, ∃ t a, N ≤ t ∧ ComesToBe (p a) t :=
  fun N =>
    match «定后前者在前则亡屡者生屡» (R := Steps.along) (E := Steps.alikeAt p)
        (u := listedOccurrences l) (T := 0) (b := beginTest p) (e := endTest p)
        (fun t _ => distinct_map_on (fun _ _ _ _ same => congrArg Prod.snd same) (listed (t + 1)).1)
        (fun t _ x y my c => by
          obtain ⟨h1, h2⟩ := mem_map_prodMk my
          obtain ⟨⟨e1, e2⟩, alike⟩ := c
          obtain ⟨s, b⟩ := x
          obtain ⟨t', a⟩ := y
          dsimp only at h1 h2 e1 e2 alike
          subst h1
          have es : s = t := (Nat.succ.inj e1).symm
          subst es; subst e2
          exact prodMk_mem_map (((listed s).2 a).mp (alike.mpr (((listed (s + 1)).2 a).mpr h2))))
        (Steps.along_fixed _)
        (fun t _ y my => by
          obtain ⟨h1, h2⟩ := mem_map_prodMk my
          obtain ⟨t', a⟩ := y
          dsimp only at h1 h2
          subst h1
          have holds : p a (t + 1) := ((listed (t + 1)).2 a).mpr h2
          show (!decide (p a t)) = true ↔ _
          exact not_decide_iff.trans ⟨fun was => (comesToBe_iff_sheng_along.mp ⟨was, holds⟩).2,
            fun begins was => (comesToBe_iff_sheng_along.mpr ⟨holds, begins⟩).1 was⟩)
        (fun t _ x mx => by
          obtain ⟨h1, h2⟩ := mem_map_prodMk mx
          obtain ⟨t', a⟩ := x
          dsimp only at h1 h2
          subst h1
          have held : p a t' := ((listed t').2 a).mpr h2
          exact not_decide_iff.trans ⟨fun gone => (ceasesToBe_iff_wang_along.mp ⟨held, gone⟩).2,
            fun ends next => (ceasesToBe_iff_wang_along.mpr ⟨held, ends⟩).2 next⟩)
        (fun M => match ceasing M with
          | ⟨t, a, later, ceases⟩ =>
            ⟨t, later, (t, a), prodMk_mem_map (((listed t).2 a).mp ceases.1),
              (ceasesToBe_iff_wang_along.mp ceases).2⟩)
        N with
    | ⟨t, later, y, my, begins⟩ => by
        obtain ⟨h1, h2⟩ := mem_map_prodMk my
        obtain ⟨t', a⟩ := y
        dsimp only at h1 h2
        subst h1
        exact ⟨t, a, later, comesToBe_iff_sheng_along.mpr ⟨((listed (t + 1)).2 a).mpr h2, begins⟩⟩
'''


def population():
    pop = read("Population")
    tail = TOTAL_MARK_TAIL
    pop = insert_before(pop, "/-! ## Listing what holds -/\n", OCCURRENCES + tail + "\n", "Population, occurrences")
    pop = replace(pop, ACROSS_OLD, ACROSS_NEW, "Population, Listed.across_at")
    pop = replace(pop, COMING_OLD, COMING_NEW, "Population, Listed.coming_of_ceasing")
    write("Population", pop)


TOTAL_MARK_TAIL = '''    rw [total_mark_eq_count l]
    exact congrArg (· + _) (mark_cases (q := fun n => n = cond (decide (P x)) 1 0)
      (fun h => by rw [decide_eq_true h]; rfl) (fun h => by rw [decide_eq_false h]; rfl))
'''

# ---------------------------------------------------------------------------------------------------
# 05: Identity

IDENTITY_VAR_OLD = "variable {W R} [∀ t g f, Decidable (R t g f)]\n"
IDENTITY_VAR_NEW = "variable {W R}\n"

BALANCE_DOC_OLD = '''under it; without merges across it, at least. Only the two listings and the step's splits
and merges are used. -/
theorem Census.balanceFrom_at'''
BALANCE_DOC_NEW = '''under it; without merges across it, at least. Only the two listings and the step's splits
and merges are used: it is the root's census of a step, both halves (`«定后则后并亡不过前并生»`,
`«定前则前并生不过后并亡»`), at the step's relation between formations active at both ends. -/
theorem Census.balanceFrom_at'''

BALANCE_PROOF_NEW = '''  ⟨fun noSplit => by
    rw [total_mark_eq_count, total_mark_eq_count]
    exact «定后则后并亡不过前并生» (R := R t) (E := fun g f => W.active t g ∧ W.active (t + 1) f)
      next.1
      («定后之逐点».mpr fun g f f' ⟨r, active, af⟩ ⟨r', _, af'⟩ => noSplit g f f' active r r' af af')
      (fun f mf off none =>
        have af : W.active (t + 1) f := (next.2 f).mpr mf
        (fun alone : ¬ W.Continues R t f => of_decide_eq_false off ⟨af, alone⟩)
          fun ⟨g, ag, r⟩ => none ⟨g, (now.2 g).mp ag, r, ag, af⟩)
      (fun g _ on f _ ⟨r, _, af⟩ => (of_decide_eq_true on).2 ⟨f, af, r⟩),
   fun noMerge => by
    rw [total_mark_eq_count, total_mark_eq_count]
    exact «定前则前并生不过后并亡» (R := R t) (E := fun g f => W.active t g ∧ W.active (t + 1) f)
      now.1
      («定前之逐点».mpr fun g g' f ⟨r, ag, af⟩ ⟨r', ag', _⟩ => noMerge g g' f ag ag' r r' af)
      (fun g mg off none =>
        have ag : W.active t g := (now.2 g).mpr mg
        (fun alone : ¬ W.Continued R t g => of_decide_eq_false off ⟨ag, alone⟩)
          fun ⟨f, af, r⟩ => none ⟨f, (next.2 f).mp af, r, ag, af⟩)
      (fun f _ on g _ ⟨r, ag, _⟩ => (of_decide_eq_true on).2 ⟨g, ag, r⟩)⟩
'''

BALANCEFROM_DOC_OLD = '''side is read against the continuing pairs: no more formations after the step continue one
before it than there are pairs, nor are more before it continued, and without merges the
first count is the pairs, without splits the second. -/'''
BALANCEFROM_DOC_NEW = '''side is the root's census of a step at the step's relation between active formations
(`balanceFrom_at`). -/'''


def identity():
    idt = read("Identity")
    idt = replace(idt, IDENTITY_VAR_OLD, IDENTITY_VAR_NEW, "Identity, Counting's variable line")
    idt = replace(idt, BALANCE_DOC_OLD, BALANCE_DOC_NEW, "Identity, balanceFrom_at's docstring")
    start = idt.index("theorem Census.balanceFrom_at")
    body = idt.index("  have after : (alive (t + 1)).length = total (alive (t + 1))", start)
    end = idt.index("\n\n/--", body)
    idt = idt[:body] + BALANCE_PROOF_NEW.rstrip("\n") + idt[end:]
    idt = replace(idt, BALANCEFROM_DOC_OLD, BALANCEFROM_DOC_NEW, "Identity, balanceFrom's docstring")
    write("Identity", idt)


STEPS_RUN = {"prelude": prelude, "grammarlaws": grammarlaws, "arising": arising,
             "population": population, "identity": identity}

if __name__ == "__main__":
    assert PKG.is_dir(), "run from the checkout root"
    for s in sys.argv[1:] or ["usage"]:
        if s not in STEPS_RUN:
            sys.exit("steps: " + " ".join(STEPS_RUN))
        STEPS_RUN[s]()
        print(s, "done")
