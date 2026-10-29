#!/usr/bin/env python3
"""OU3f's lineage part: edit the tree's copies of Identity and MapInstances.

Run from anywhere on copies matching tree/BASE.sha256 (main's bytes); each replacement must match
exactly once. History of the draft:
- the first draft (scratch-1, scratch-2) stated the bridge with a fixed endpoint (`lineage_iff_steps`);
- the second (scratch-3, scratch-4) stated it with the endpoint's step fixed (`steps_iff_lineage`);
- this one takes the review (review/REVIEW-LINEAGE.md):
  - "at most one" (1);
  - a forward lemma `lineage_of_steps` with no bound, and the bridge's index from `steps_advance`
    (5, 6);
  - `activityOnward` for `activityFrom` (7);
  - wording (8) and a heading for the census law (9);
  - `Lineage.line` and `line_lineage` proved through the bridge from `«迭则及»` and from `«闭之及»`
    with `«及即迭»` (4), so `Lineage.cons`, the bridge read at one more first step, lost its one
    consumer and is retired.
"""
from pathlib import Path
import hashlib
import sys

HERE = Path(__file__).resolve().parent.parent
TREE = HERE / "tree" / "Becoming"

base = {line.split()[1]: line.split()[0] for line in (HERE / "tree" / "BASE.sha256").read_text().splitlines()}
for name, digest in base.items():
    got = hashlib.sha256((HERE / "tree" / name).read_bytes()).hexdigest()
    if got != digest:
        sys.exit(f"{name} is not the base copy; refusing to edit")


def replace(text, old, new, label):
    count = text.count(old)
    if count != 1:
        sys.exit(f"{label}: expected one match, found {count}")
    return text.replace(old, new)


identity = (TREE / "Identity.lean").read_text()

# The module header: lineages on the grammar.
identity = replace(identity, """  read as joining, arising recurs with at most two active and nothing ceases (`Tandem`).
* Part and whole.""", """  read as joining, arising recurs with at most two active and nothing ceases (`Tandem`).
* Lineages on the grammar. The lineage of a formation under a continuation (`Lineage`: steps of
  `R`, each between formations active at its two ends) is exactly the grammar's steps (`«迭»`) of
  the continuation within activity from its start (`steps_iff_lineage`), so its laws are cases of
  the grammar's laws of steps. Without splits a lineage reaches at most one formation at each step,
  and without merges two lineages reaching one formation start from one (`Lineage.unique`,
  `Lineage.origin`, from `«迭之定»` and `«迭之定前»`); a lineage splits as its steps split
  (`Lineage.split`, `Lineage.through`, from `«迭之分»`); where nothing ceases it goes on, and where
  nothing arises it goes back, each as far as can be refuted (`Lineage.onward`, from
  `«或有后则或迭»`, and `Lineage.back`, from it read backward through `«迭之逆»`). A lineage of one
  or more steps is a line under activity, and a line from an active occurrence is a lineage
  (`Lineage.line`, `line_lineage`, from `«迭则及»`, and from `«闭之及»` with `«及即迭»`). The
  census law under a continuation from one covering list, and its converse, rest on these laws.
* Part and whole.""", "header: lineages on the grammar")

# The grammar section no longer defines continuationStep and occurrence_eq; they move up.
identity = replace(identity, """namespace Web

/-- 缘 read off a continuation `R`: the occurrence `(t, g)` is a condition of `(u, f)` when `u` is
the step after `t` and `R t g f`. -/
def continuationStep (R : Nat → F → F → Prop) : «际» (Nat × F) :=
  fun x y => y.1 = x.1 + 1 ∧ R x.1 x.2 y.2

/-- The class (类) of a property""", """namespace Web

/-- The class (类) of a property""", "continuationStep out of the grammar section")

identity = replace(identity, """  ⟨fun _ => Iff.rfl, Iff.symm, Iff.trans⟩



/-- Two occurrences with the same step and the same formation are one. -/
theorem occurrence_eq : ∀ {x y : Nat × F}, x.1 = y.1 → x.2 = y.2 → x = y
  | (_, _), (_, _), rfl, rfl => rfl

variable {W : Web F C} {R : Nat → F → F → Prop}
""", """  ⟨fun _ => Iff.rfl, Iff.symm, Iff.trans⟩

variable {W : Web F C} {R : Nat → F → F → Prop}
""", "occurrence_eq out of the grammar section")

# The grammar section's text says where the moved terms are, and how a lineage reads as a line.
identity = replace(identity, """`Becoming.Grammar` states continuation (续) for every carrier and every relation. Here the carrier
is the occurrences of formations, pairs `(t, f)` of a step and a formation. 缘 is one step of a
continuation `R` (`Web.continuationStep R`: `(t, g)` is a condition of `(t + 1, f)` where
`R t g f`), the relation this module already reads splits and merges with. The class is activity
(`Web.activityClass W`: two occurrences are alike when both are active or neither is), as the
flame's class is "flame or not". Nothing else is supplied.""",
"""`Becoming.Grammar` states continuation (续) for every carrier and every relation. Here the carrier
is the occurrences of formations, pairs `(t, f)` of a step and a formation. 缘 is one step of a
continuation `R` (`Web.continuationStep R`, defined with the lineage above: `(t, g)` is a
condition of `(t + 1, f)` where `R t g f`), the relation this module already reads splits and
merges with. The class is activity (`Web.activityClass W`: two occurrences are alike when both are
active or neither is), as the flame's class is "flame or not". Nothing else is supplied.""",
"grammar section: continuationStep's place")

identity = replace(identity, """* **Lines are orders of precedence.** Continuation steps advance the step index
  (`reach_advances`), so `continuationStep R` has no cycle (`continuationStep_acyclic`) and its
  reach is a strict order (`reach_strict_order`, from `«无环则及为序»`). A lineage (`Lineage`) is
  exactly a line (相续) under activity from an active occurrence (`lineage_iff_line`).""",
"""* **Lines are orders of precedence.** Continuation steps advance the step index
  (`reach_advances`; `k` steps by `k`, `steps_advance`, above), so `continuationStep R` has no
  cycle (`continuationStep_acyclic`) and its reach is a strict order (`reach_strict_order`, from
  `«无环则及为序»`). A lineage (`Lineage`) is exactly a line (相续) under activity from an active
  occurrence (`lineage_iff_line`). Its steps within activity onward from its start reach
  (`Lineage.line`, from `«迭则及»`); a line from an active occurrence stays among the occurrences
  active, at or after its start and within the closure of activity onward from it, a region closed
  under the line's steps (`«闭之及»`), so it is a positive number of steps within activity onward
  from its start (`line_lineage`, with `«及即迭»`). Those steps are exactly the lineage
  (`steps_iff_lineage`, above).""",
"grammar section: lines")

# The bridge, after the definition of a lineage; unique, split (moved up) and through.
identity = replace(identity, """      W.active (M + k + 1) h

variable {W R}

/-- Without splits from `M` on, a lineage reaches at most one formation at each step. -/
theorem Lineage.unique {M : Nat} {g : F}
    (noSplit : ∀ s, M ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
      W.active (s + 1) f → W.active (s + 1) f' → f = f') :
    ∀ {k h h'}, W.Lineage R M g k h → W.Lineage R M g k h' → h = h'
  | 0, _, _, same, same' => same.trans same'.symm
  | k + 1, _, _, ⟨h₀, lineage, active₀, cont, active⟩, ⟨h₀', lineage', _, cont', active'⟩ =>
    have prior : h₀ = h₀' := Lineage.unique noSplit lineage lineage'
    noSplit (M + k) (Nat.le_add_right M k) h₀ _ _ active₀ cont
      (Eq.subst (motive := fun x => R (M + k) x _) prior.symm cont') active active'

/-- A lineage reaching a later step passed through every earlier one, and was continued
there. -/
theorem Lineage.through {M : Nat} {g : F} {k : Nat} :
    ∀ i {h'}, W.Lineage R M g (k + 1 + i) h' →
      ∃ h₁ h₂, W.Lineage R M g k h₁ ∧ R (M + k) h₁ h₂ ∧ W.active (M + k + 1) h₂
  | 0, _, ⟨h₀, lineage, _, cont, active⟩ => ⟨h₀, _, lineage, cont, active⟩
  | i + 1, _, ⟨_, lineage, _, _, _⟩ => Lineage.through i lineage
""", """      W.active (M + k + 1) h

/-! ### A lineage is steps of the continuation, on the grammar

A lineage of `k` steps is exactly the grammar's `k` steps (`«迭»`) of the continuation within
activity onward from a step `N` not after its start (`steps_iff_lineage`): each step is one of the
continuation (缘, `continuationStep R`) between occurrences alike in activity, from an active one
at or after `N` (`activityOnward`). Read forward, such steps from any `N` are a lineage
(`lineage_of_steps`); the bound is needed only to read a lineage as steps. The laws of a lineage
are then cases of the grammar's laws of steps. Without splits from `M` on, the successor within
activity onward from `M` is fixed, so a lineage reaches at most one formation at each step
(`Lineage.unique`, from `«迭之定»`); without merges from `M` on, nothing merges there, so two
lineages reaching one formation start from one (`Lineage.origin`, from `«迭之定前»`). A lineage
splits as its steps split (`Lineage.split`, from `«迭之分»`), and so passes through every earlier
step (`Lineage.through`). Where nothing ceases, a lineage goes on, as far as can be refuted
(`Lineage.onward`, from `«或有后则或迭»`); where nothing arises, it goes back, as far as can be
refuted (`Lineage.back`, from the same law read backward through `«迭之逆»`). Steps of a
continuation advance the step index by their number (`steps_advance`), which places where split
steps meet and where steps back end. -/

/-- 缘 read off a continuation `R`: the occurrence `(t, g)` is a condition of `(u, f)` when `u` is
the step after `t` and `R t g f`. -/
def continuationStep (R : Nat → F → F → Prop) : «际» (Nat × F) :=
  fun x y => y.1 = x.1 + 1 ∧ R x.1 x.2 y.2

/-- Activity onward from step `N`: two occurrences alike in activity, the first active at a step
from `N` on. It is not a class: it relates nothing from an occurrence before `N` or from an
inactive one. -/
def activityOnward (N : Nat) : «际» (Nat × F) :=
  fun x y => W.activityClass x y ∧ N ≤ x.1 ∧ W.active x.1 x.2

variable {W R}

/-- Two occurrences with the same step and the same formation are one. -/
theorem occurrence_eq : ∀ {x y : Nat × F}, x.1 = y.1 → x.2 = y.2 → x = y
  | (_, _), (_, _), rfl, rfl => rfl

/-- `k` steps of a continuation under `continuationStep R` advance the step index by `k`. -/
theorem steps_advance {E : «际» (Nat × F)} : ∀ (k : Nat) {x y : Nat × F},
    «迭» («续» (continuationStep R) E) k x y → y.1 = x.1 + k
  | 0, _, _, e => (congrArg Prod.fst e).symm
  | k + 1, x, _, ⟨_, c, rest⟩ =>
    (steps_advance k rest).trans ((congrArg (· + k) c.1.1).trans (Nat.succ_add x.1 k))

/-- Read forward, steps are a lineage: `k` steps of the continuation within activity onward from
any step `N`, from `(M, g)`, end at a formation the lineage of `g` from `M` reaches in `k` steps.
No bound on `N` is used. -/
theorem lineage_of_steps {N M : Nat} {g : F} : ∀ (k : Nat) {y : Nat × F},
    «迭» («续» (continuationStep R) (W.activityOnward N)) k (M, g) y → W.Lineage R M g k y.2
  | 0, _, same => (congrArg Prod.snd same).symm
  | k + 1, y, steps => match («迭之末步» k).mp steps with
    | ⟨x, first, ⟨next, cont⟩, alike, _, active₀⟩ =>
      have at_ : x.1 = M + k := steps_advance k first
      ⟨x.2, lineage_of_steps k first,
        Eq.subst (motive := fun s => W.active s x.2) at_ active₀,
        Eq.subst (motive := fun s => R s x.2 y.2) at_ cont,
        Eq.subst (motive := fun s => W.active s y.2) (next.trans (congrArg (· + 1) at_))
          (alike.mp active₀)⟩

/-- **A lineage is steps (迭) of the continuation within activity.** `k` steps of the continuation
within activity onward from a step `N` not after `M` lead from `(M, g)` to an occurrence exactly
where it lies at step `M + k` (`steps_advance`) and the lineage of `g` from `M` reaches its
formation in `k` steps (`lineage_of_steps`), for every `k`, `0` included. The bound serves the
converse: a lineage's steps start at `M`. -/
theorem steps_iff_lineage {N M : Nat} (from_ : N ≤ M) {g : F} : ∀ (k : Nat) {y : Nat × F},
    «迭» («续» (continuationStep R) (W.activityOnward N)) k (M, g) y ↔
      y.1 = M + k ∧ W.Lineage R M g k y.2
  | 0, _ => ⟨fun steps => ⟨steps_advance 0 steps, lineage_of_steps 0 steps⟩,
      fun ⟨at_, same⟩ => occurrence_eq at_.symm same.symm⟩
  | k + 1, y => ⟨fun steps => ⟨steps_advance (k + 1) steps, lineage_of_steps (k + 1) steps⟩,
    fun ⟨at_, h₀, lineage, active₀, cont, active⟩ =>
      («迭之末步» k).mpr ⟨(M + k, h₀), (steps_iff_lineage from_ k).mpr ⟨rfl, lineage⟩, ⟨at_, cont⟩,
        ⟨fun _ => Eq.subst (motive := fun s => W.active s y.2) at_.symm active, fun _ => active₀⟩,
        Nat.le_trans from_ (Nat.le_add_right M k), active₀⟩⟩

/-- Steps of the continuation within activity onward from `N` start at an active occurrence where
they end at one. -/
theorem steps_start_active {N : Nat} : ∀ {k : Nat} {x y : Nat × F},
    «迭» («续» (continuationStep R) (W.activityOnward N)) k x y → W.active y.1 y.2 →
      W.active x.1 x.2
  | 0, _, _, same, active =>
    Eq.subst (motive := fun z : Nat × F => W.active z.1 z.2) same.symm active
  | _ + 1, _, _, ⟨_, ⟨_, _, _, active⟩, _⟩, _ => active

/-- Without splits from `M` on, a lineage reaches at most one formation at each step: within
activity onward from `M` the continuation's successor is fixed, and `k` steps with a fixed
successor lead to one occurrence (`«迭之定»`). -/
theorem Lineage.unique {M : Nat} {g : F}
    (noSplit : ∀ s, M ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
      W.active (s + 1) f → W.active (s + 1) f' → f = f') :
    ∀ {k h h'}, W.Lineage R M g k h → W.Lineage R M g k h' → h = h'
  | k, h, h', lineage, lineage' =>
    congrArg Prod.snd («迭之定» (R := «续» (continuationStep R) (W.activityOnward M))
      («定后之逐点».mpr fun x y z ⟨⟨next, cont⟩, alike, from_, active⟩ ⟨⟨next', cont'⟩, alike', _⟩ =>
        occurrence_eq (next.trans next'.symm) (noSplit x.1 from_ x.2 y.2 z.2 active cont cont'
          (Eq.subst (motive := fun s => W.active s y.2) next (alike.mp active))
          (Eq.subst (motive := fun s => W.active s z.2) next' (alike'.mp active))))
      k ((steps_iff_lineage (Nat.le_refl M) k (y := (M + k, h))).mpr ⟨rfl, lineage⟩)
      ((steps_iff_lineage (Nat.le_refl M) k (y := (M + k, h'))).mpr ⟨rfl, lineage'⟩))

/-- A lineage reaching a later step passes through each earlier one, and from there is a lineage
itself: its `j + i` steps split into `j` and then `i` (`«迭之分»`), the first `j` ending at step
`M + j` (`steps_advance`). -/
theorem Lineage.split {M : Nat} {g : F} {j : Nat} :
    ∀ i {h}, W.Lineage R M g (j + i) h → ∃ x, W.Lineage R M g j x ∧ W.Lineage R (M + j) x i h
  | i, h, lineage =>
    match «迭之分» j ((steps_iff_lineage (Nat.le_refl M) (i + j) (y := (M + (i + j), h))).mpr
        ⟨rfl, Eq.subst (motive := fun n => W.Lineage R M g n h) (Nat.add_comm j i) lineage⟩) with
    | ⟨y, first, second⟩ => ⟨y.2, lineage_of_steps j first,
        Eq.subst (motive := fun s => W.Lineage R s y.2 i h) (steps_advance j first)
          (lineage_of_steps i second)⟩

/-- A lineage reaching a later step passed through every earlier one, and was continued
there: `Lineage.split` at `k + 1`, the last of whose first `k + 1` steps is the step from
`M + k`. -/
theorem Lineage.through {M : Nat} {g : F} {k : Nat} :
    ∀ i {h'}, W.Lineage R M g (k + 1 + i) h' →
      ∃ h₁ h₂, W.Lineage R M g k h₁ ∧ R (M + k) h₁ h₂ ∧ W.active (M + k + 1) h₂
  | i, _, lineage => match Lineage.split i lineage with
    | ⟨h₂, ⟨h₁, before, _, cont, active⟩, _⟩ => ⟨h₁, h₂, before, cont, active⟩
""", "the bridge, unique, split, through")

# back, from B2 read backward.
identity = replace(identity, """/-- Where nothing arises under the continuation from `M` on, every formation active at a
later step is not refuted to lie on the lineage of one listed at `M`, by a list covering
what is active there. -/
theorem Lineage.back {M : Nat} {l : List F} (covers : ∀ f, W.active M f → f ∈ l)
    (quiet : ∀ s f, M ≤ s → ¬ W.ArisesFrom R s f) :
    ∀ k h, W.active (M + k) h → ¬¬ ∃ g, g ∈ l ∧ W.Lineage R M g k h
  | 0, h, active => fun none => none ⟨h, covers h active, rfl⟩
  | k + 1, h, active => fun none =>
    quiet (M + k) h (Nat.le_add_right M k) ⟨active, fun ⟨h₀, active₀, cont⟩ =>
      Lineage.back covers quiet k h₀ active₀ fun ⟨g, mem, lineage⟩ =>
        none ⟨g, mem, h₀, lineage, active₀, cont, active⟩⟩
""", """/-- Where nothing arises under the continuation from `M` on, every formation active at a
later step is not refuted to lie on the lineage of one listed at `M`, by a list covering
what is active there. Read backward (`«迭之逆»`), each occurrence fewer than `k` steps back from it
lies after `M` and is active, so, as far as can be refuted, it continues a formation active at the
step before; so `k` steps back exist as far as can be refuted (`«或有后则或迭»`), and, read
forward, they start at step `M`. -/
theorem Lineage.back {M : Nat} {l : List F} (covers : ∀ f, W.active M f → f ∈ l)
    (quiet : ∀ s f, M ≤ s → ¬ W.ArisesFrom R s f) :
    ∀ k h, W.active (M + k) h → ¬¬ ∃ g, g ∈ l ∧ W.Lineage R M g k h :=
  fun k h active none =>
    «或有后则或迭» (R := «逆» («续» (continuationStep R) (W.activityOnward M))) (x := (M + k, h)) k
      (fun j y below steps =>
        have back := («迭之逆» j).mp steps
        have after : W.active y.1 y.2 := steps_start_active back active
        match le_dest (le_of_add_le_add_right j (Eq.subst (motive := (M + 1 + j ≤ ·))
            (steps_advance j back) (Eq.subst (motive := (· ≤ M + k)) (Nat.succ_add M j).symm
              (Nat.add_le_add_left below M)))) with
        | ⟨d, at_⟩ =>
          have next : y.1 = M + d + 1 := at_.trans (Nat.succ_add M d)
          fun alone => quiet (M + d) y.2 (Nat.le_add_right M d)
            ⟨Eq.subst (motive := fun s => W.active s y.2) next after, fun ⟨g, before, cont⟩ =>
              alone ⟨(M + d, g), ⟨next, cont⟩, ⟨fun _ => after, fun _ => before⟩,
                Nat.le_add_right M d, before⟩⟩)
      fun ⟨y, steps⟩ =>
        have back := («迭之逆» k).mp steps
        have at_ : y.1 = M := add_right_cancel k (steps_advance k back).symm
        none ⟨y.2, covers y.2 (Eq.subst (motive := fun s => W.active s y.2) at_
            (steps_start_active back active)),
          Eq.subst (motive := fun s => W.Lineage R s y.2 k h) at_ (lineage_of_steps k back)⟩
""", "back")

# The census law from one covering list gets its own heading.
identity = replace(identity, """/-- Ceasing under the continuation at arbitrarily late steps gives, from any step, any number
of ceasings at distinct steps. -/""", """/-! ### The census law from one covering list -/

/-- Ceasing under the continuation at arbitrarily late steps gives, from any step, any number
of ceasings at distinct steps. -/""", "census law heading")

# split leaves its old place (it now precedes through).
identity = replace(identity, """/-- A lineage reaching a later step passes through each earlier one, and from there is a
lineage itself. -/
theorem Lineage.split {M : Nat} {g : F} {j : Nat} :
    ∀ i {h}, W.Lineage R M g (j + i) h → ∃ x, W.Lineage R M g j x ∧ W.Lineage R (M + j) x i h
  | 0, h, lineage => ⟨h, lineage, rfl⟩
  | i + 1, h, ⟨h₀, lineage, active₀, cont, active⟩ => match Lineage.split i lineage with
    | ⟨x, before, after⟩ =>
      have same : M + (j + i) = M + j + i := (Nat.add_assoc M j i).symm
      ⟨x, before, h₀, after, Eq.subst (motive := fun s => W.active s h₀) same active₀,
        Eq.subst (motive := fun s => R s h₀ h) same cont,
        Eq.subst (motive := fun s => W.active (s + 1) h) same active⟩

""", "", "split's old place")

# origin, from «迭之定前».
identity = replace(identity, """/-- Without merges from `M` on, two lineages from `M` reaching one formation at one step start
from one formation. -/
theorem Lineage.origin {M : Nat}
    (noMerge : ∀ s, M ≤ s → ∀ g g' f, W.active s g → W.active s g' → R s g f → R s g' f →
      W.active (s + 1) f → g = g') :
    ∀ {k g g' h}, W.Lineage R M g k h → W.Lineage R M g' k h → g = g'
  | 0, _, _, _, same, same' => same.symm.trans same'
  | k + 1, _, _, _, ⟨h₀, lineage, active₀, cont, active⟩, ⟨h₀', lineage', active₀', cont', _⟩ =>
    have prior : h₀ = h₀' :=
      noMerge (M + k) (Nat.le_add_right M k) h₀ h₀' _ active₀ active₀' cont cont' active
    Lineage.origin noMerge lineage (Eq.subst (motive := fun x => W.Lineage R M _ k x) prior.symm
      lineage')
""", """/-- Without merges from `M` on, two lineages from `M` reaching one formation at one step start
from one formation: within activity onward from `M` the continuation merges nothing, and `k` steps
that merge nothing to one occurrence come from one (`«迭之定前»`). -/
theorem Lineage.origin {M : Nat}
    (noMerge : ∀ s, M ≤ s → ∀ g g' f, W.active s g → W.active s g' → R s g f → R s g' f →
      W.active (s + 1) f → g = g') :
    ∀ {k g g' h}, W.Lineage R M g k h → W.Lineage R M g' k h → g = g'
  | k, _, _, h, lineage, lineage' =>
    congrArg Prod.snd («迭之定前» (R := «续» (continuationStep R) (W.activityOnward M))
      («定前之逐点».mpr fun x y z ⟨⟨next, cont⟩, alike, from_, active⟩ ⟨⟨next', cont'⟩, _, _, active'⟩ =>
        have same : x.1 = y.1 := Nat.succ.inj (next.symm.trans next')
        occurrence_eq same (noMerge x.1 from_ x.2 y.2 z.2 active
          (Eq.subst (motive := fun s => W.active s y.2) same.symm active') cont
          (Eq.subst (motive := fun s => R s y.2 z.2) same.symm cont')
          (Eq.subst (motive := fun s => W.active s z.2) next (alike.mp active))))
      k ((steps_iff_lineage (Nat.le_refl M) k (y := (M + k, h))).mpr ⟨rfl, lineage⟩)
      ((steps_iff_lineage (Nat.le_refl M) k (y := (M + k, h))).mpr ⟨rfl, lineage'⟩))
""", "origin")

# onward, from B2.
identity = replace(identity, """/-- Where nothing ceases under the continuation from `N` on, a lineage from a formation active
at a step `M` from `N` on is not refuted to reach some formation at every later step. -/
theorem Lineage.onward {N M : Nat} (later : N ≤ M) {g : F}
    (quiet : ∀ t g, N ≤ t → ¬ W.CeasesFrom R t g) (start : W.active M g) :
    ∀ k, ¬¬ ∃ h, W.Lineage R M g k h
  | 0 => fun none => none ⟨g, rfl⟩
  | k + 1 => fun none => Lineage.onward later quiet start k fun ⟨h, lineage⟩ =>
    have active := lineage.active start
    quiet (M + k) h (Nat.le_trans later (Nat.le_add_right M k)) ⟨active, fun ⟨f, after, cont⟩ =>
      none ⟨f, h, lineage, active, cont, after⟩⟩
""", """/-- Where nothing ceases under the continuation from `N` on, a lineage from a formation active
at a step `M` from `N` on is not refuted to reach some formation at every later step: each
occurrence its steps reach is active and, as far as can be refuted, continued, so `k` steps exist
as far as can be refuted (`«或有后则或迭»`). -/
theorem Lineage.onward {N M : Nat} (later : N ≤ M) {g : F}
    (quiet : ∀ t g, N ≤ t → ¬ W.CeasesFrom R t g) (start : W.active M g) :
    ∀ k, ¬¬ ∃ h, W.Lineage R M g k h :=
  fun k none => «或有后则或迭» (R := «续» (continuationStep R) (W.activityOnward M)) (x := (M, g)) k
    (fun j y _ steps =>
      have at_ : y.1 = M + j := steps_advance j steps
      have active : W.active y.1 y.2 := Eq.subst (motive := fun s => W.active s y.2) at_.symm
        ((lineage_of_steps j steps).active start)
      have from_ : M ≤ y.1 := Eq.subst (motive := (M ≤ ·)) at_.symm (Nat.le_add_right M j)
      fun ends => quiet y.1 y.2 (Nat.le_trans later from_) ⟨active, fun ⟨f, after, cont⟩ =>
        ends ⟨(y.1 + 1, f), ⟨rfl, cont⟩, ⟨fun _ => after, fun _ => active⟩, from_, active⟩⟩)
    fun ⟨y, steps⟩ => none ⟨y.2, lineage_of_steps k steps⟩
""", "onward")

# Lineage.cons retires (the bridge read at one more first step; line_lineage, its one consumer, no
# longer needs it); Lineage.line and line_lineage are proved through the bridge.
identity = replace(identity, """/-- A lineage of `k + 1` steps from `g` at `M`, continued by `R` from `M` and active at `M + 1`,
is a lineage of `k + 2` steps from what `R` continues as `g`. -/
theorem Lineage.cons {M : Nat} {g f : F} (before : W.active M g) (r : R M g f)
    (after : W.active (M + 1) f) : ∀ (k : Nat) {h : F},
      W.Lineage R (M + 1) f k h → W.Lineage R M g (k + 1) h
  | 0, _, same => ⟨g, rfl, before, Eq.subst (motive := fun x => R M g x) same.symm r,
      Eq.subst (motive := fun x => W.active (M + 1) x) same.symm after⟩
  | k + 1, _, ⟨h₀, lineage, active₀, cont, active⟩ =>
    have shift : M + 1 + k = M + (k + 1) := Nat.succ_add M k
    ⟨h₀, Lineage.cons before r after k lineage,
     Eq.subst (motive := fun s => W.active s h₀) shift active₀,
     Eq.subst (motive := fun s => R s h₀ _) shift cont,
     Eq.subst (motive := fun s => W.active (s + 1) _) shift active⟩

/-- A lineage of `k + 1` steps is a line (相续) under activity from an active occurrence. -/
theorem Lineage.line {M : Nat} {g : F} : ∀ (k : Nat) {h : F}, W.Lineage R M g (k + 1) h →
    W.active M g ∧ «相续» (continuationStep R) W.activityClass (M, g) (M + (k + 1), h)
  | 0, _, ⟨_, same, active₀, cont, active⟩ =>
    have before : W.active M g := Eq.subst (motive := fun x => W.active M x) same active₀
    ⟨before, .one ⟨⟨rfl, Eq.subst (motive := fun x => R M x _) same cont⟩,
      ⟨fun _ => active, fun _ => before⟩⟩⟩
  | k + 1, _, ⟨_, lineage, active₀, cont, active⟩ =>
    match Lineage.line k lineage with
    | ⟨before, line⟩ =>
      ⟨before, «及之传递» line (.one ⟨⟨rfl, cont⟩, ⟨fun _ => active, fun _ => active₀⟩⟩)⟩

/-- A line (相续) under activity from an active occurrence is a lineage of some number of
steps. -/
theorem line_lineage {x y : Nat × F}
    (line : «及» («续» (continuationStep R) W.activityClass) x y) :
    W.active x.1 x.2 → ∃ k, y.1 = x.1 + (k + 1) ∧ W.Lineage R x.1 x.2 (k + 1) y.2 := by
  induction line with
  | @one a b c =>
    intro before
    exact ⟨0, c.1.1, a.2, rfl, before, c.1.2,
      Eq.subst (motive := fun s => W.active s b.2) c.1.1 (c.2.mp before)⟩
  | @more a b z c _ ih =>
    intro before
    have next : b.1 = a.1 + 1 := c.1.1
    have after : W.active (a.1 + 1) b.2 :=
      Eq.subst (motive := fun s => W.active s b.2) next (c.2.mp before)
    match ih (c.2.mp before) with
    | ⟨k, reach, lineage⟩ =>
      exact ⟨k + 1, reach.trans ((congrArg (· + (k + 1)) next).trans (Nat.succ_add a.1 (k + 1))),
        Lineage.cons before c.1.2 after (k + 1)
          (Eq.subst (motive := fun s => W.Lineage R s b.2 (k + 1) z.2) next lineage)⟩
""", """/-- A lineage of `k + 1` steps is a line (相续) under activity from an active occurrence: its steps
within activity onward from its start reach (`«迭则及»`), within activity itself (`«及之单调»`),
and the first step's source is active. -/
theorem Lineage.line {M : Nat} {g : F} : ∀ (k : Nat) {h : F}, W.Lineage R M g (k + 1) h →
    W.active M g ∧ «相续» (continuationStep R) W.activityClass (M, g) (M + (k + 1), h)
  | k, h, lineage =>
    have steps := (steps_iff_lineage (Nat.le_refl M) (k + 1) (y := (M + (k + 1), h))).mpr
      ⟨rfl, lineage⟩
    ⟨match steps with | ⟨_, ⟨_, _, _, active⟩, _⟩ => active,
     «及之单调» (fun _ _ ⟨step, alike, _⟩ => ⟨step, alike⟩) _ _ («迭则及» k steps)⟩

/-- A line (相续) under activity from an active occurrence is a lineage of some number of
steps: the line stays among the occurrences active, at or after its start and within the closure
of activity onward from it, a region closed under its steps (`«闭之及»`), so it is a positive
number of steps within activity onward from its start (`«及即迭»`), which are the lineage. -/
theorem line_lineage {x y : Nat × F}
    (line : «及» («续» (continuationStep R) W.activityClass) x y) :
    W.active x.1 x.2 → ∃ k, y.1 = x.1 + (k + 1) ∧ W.Lineage R x.1 x.2 (k + 1) y.2 :=
  fun start =>
    have kept : W.active y.1 y.2 ∧ x.1 ≤ y.1 ∧
        «所闭» («续» (continuationStep R) (W.activityOnward x.1)) x y :=
      «闭之及» (P := fun z => W.active z.1 z.2 ∧ x.1 ≤ z.1 ∧
          «所闭» («续» (continuationStep R) (W.activityOnward x.1)) x z)
        (fun a _ ⟨active, from_, within⟩ ⟨step, alike⟩ =>
          ⟨alike.mp active,
           Nat.le_trans from_ (Eq.subst (motive := (a.1 ≤ ·)) step.1.symm (Nat.le_succ a.1)),
           «所闭之传递» within («缘在所闭» ⟨step, alike, from_, active⟩)⟩)
        ⟨start, Nat.le_refl x.1, «所闭之自反» _ x⟩ line
    match «所闭当且仅当同一或及».mp kept.2.2 with
    | .inl same => absurd (line_advances (E := W.activityClass)
        (Eq.subst (motive := fun z => «相续» _ _ z y) same line)) (Nat.lt_irrefl y.1)
    | .inr reach => match «及即迭».mp reach with
      | ⟨k, steps⟩ => ⟨k, (steps_iff_lineage (Nat.le_refl x.1) (k + 1)).mp steps⟩
""", "line, line_lineage; cons retired")

(TREE / "Identity.lean").write_text(identity)

# MapInstances: steps_advance moves to Identity, beside the continuation step it reads.
maps = (TREE / "MapInstances.lean").read_text()
maps = replace(maps, """/-- `k` steps of a continuation under `continuationStep R` advance the step index by `k`. -/
theorem steps_advance {E : «际» (Nat × F)} : ∀ (k : Nat) {x y : Nat × F},
    «迭» («续» (continuationStep R) E) k x y → y.1 = x.1 + k
  | 0, _, _, e => (congrArg Prod.fst e).symm
  | k + 1, x, _, ⟨_, c, rest⟩ =>
    (steps_advance k rest).trans ((congrArg (· + k) c.1.1).trans (Nat.succ_add x.1 k))

""", "", "steps_advance out of MapInstances")
(TREE / "MapInstances.lean").write_text(maps)
print("edited")
