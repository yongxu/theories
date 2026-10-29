#!/usr/bin/env python3
"""HE: the held edits' Lean and source changes, items 2, 3, 5 and 6 (item 1 is
oc-own-class/deferred_grammarpath.py, run first; item 4 has nothing to move).

  (2) GrammarLaws' module doc on the lineage laws: the step-indexed sentence gains them, and the
      "What is not shown" clause naming them goes;
  (3) kept_onward moves from Becoming.KeptOnward to beside «线则所闭» in GrammarLaws; the leaf is
      retired (the six modules' imports, the checker's core list and scope sentence, the root module's
      import and bullet, the README rows; its file goes to the Lean history folder by
      he_history_move.py), and GrammarLaws' closure texts name it;
  (5) total_eq_of_supports moves from KeepingWidening to beside total_le_of_support in Dissipation;
  (6) «保之像» moves from GrammarTransport to beside «像» in GrammarLaws, and Mechanism's
      factors_image and Image.least are proved as its cases (U2's design §6), every text following.

Every edit is checked before any file is written, so a stop leaves the checkout as it was; each
must apply exactly once.
usage (from the checkout root, after deferred_grammarpath.py): python3 -B <kit>/he_lean.py"""
from pathlib import Path
import sys

ROOT = Path.cwd()
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
B = PKG / 'Becoming'
pending = {}


def text(path):
    if path not in pending:
        pending[path] = path.read_text(encoding='utf-8')
    return pending[path]


def edit(path, old, new):
    t = text(path)
    if t.count(old) != 1:
        sys.exit(f'{path.name}: expected one match, found {t.count(old)}: {old[:90]!r}')
    pending[path] = t.replace(old, new)


GL = B / 'GrammarLaws.lean'
GT = B / 'GrammarTransport.lean'

# (2) GrammarLaws' module doc on the lineage laws.
edit(GL, """  of their own. Three of the models' step-indexed laws are proved
  from the laws of steps counted: `Withholding`'s closed forms from the laws of taking on, a course carrying
  its bounds (`WithinMoves.after_course`) from `«迭内之接»`, and an unending line reaching every later
  step (`Web.reaches_onward`) from `«不穷则迭»`.""", """  of their own. Of the models' step-indexed laws, these are proved from the laws of steps counted:
  `Withholding`'s closed forms from the laws of taking on, a course carrying its bounds
  (`WithinMoves.after_course`) from `«迭内之接»`, an unending line reaching every later step
  (`Web.reaches_onward`) from `«不穷则迭»`, and the lineage laws of `Becoming.Identity`
  (`Web.Lineage.unique`, `origin`, `split`, `through`, `onward`, `back`) from `«迭之定»`,
  `«迭之定前»`, `«迭之分»` and `«或有后则或迭»` with `«迭之逆»`, a lineage read as the steps of the
  continuation within activity (`Web.steps_iff_lineage`).""")
edit(GL, """these); the n-step lines law for lines of different lengths; that the models' lineage laws
(`Web.Lineage.split`, `through`, `onward`, `back`, `unique`, `origin`) follow from the laws of steps,
which is board item OU3f's next part; that a pairing under continuation
(`«对» («续» R E)`) adds anything to equal count""", """these); the n-step lines law for lines of different lengths; that a pairing under continuation
(`«对» («续» R E)`) adds anything to equal count""")

# (3) kept_onward beside «线则所闭».
edit(GL, """  holds `x`, is closed and lies within the closure (`«所闭之证»`).
""", """  holds `x`, is closed and lies within the closure (`«所闭之证»`). A region of the steps of time that
  every step keeps holds from where it holds on, the closure at the successor along a line
  (`kept_onward`); the models' activity laws that keep a region along the steps by their own
  induction are its cases.
""")
edit(GL, """  | m + 1, le => «所闭之传递» («线则所闭» steps m (Nat.le_of_succ_le le)) («缘在所闭» (steps m le))
""", """  | m + 1, le => «所闭之传递» («线则所闭» steps m (Nat.le_of_succ_le le)) («缘在所闭» (steps m le))

/-- **A region every step keeps holds from where it holds on.** A region of the steps of time
that every step keeps, holding at step `a`, holds at every later step `b`: the steps from `a` to
`b` are a line under the successor (`«线则所闭»`), and a closed region holds what lies within the
closure from where it holds (`«闭含所闭»`). It is the grammar's closure at the successor relation;
no process and no run is needed. -/
theorem kept_onward {I : Nat → Prop} (keeps : ∀ n, I n → I (n + 1)) {a b : Nat} (holds : I a)
    (later : a ≤ b) : I b :=
  match le_dest later with
  | ⟨k, at_⟩ => Eq.subst (motive := I) at_.symm
      («闭含所闭» (R := fun x y => y = x + 1)
        (fun x _ held stepped => Eq.subst (motive := I) stepped.symm (keeps x held)) holds
        («线则所闭» (g := fun i => a + i) (N := k) (fun _ _ => rfl) k (Nat.le_refl k)))
""")
for m in ('Retaining', 'Wholes', 'Exclusion', 'Reserve', 'PatternPassing', 'Persistence'):
    edit(B / f'{m}.lean', 'import Becoming.KeptOnward\n', '')
CHECKER = PKG / 'check_becoming.py'
edit(CHECKER, '"Becoming.KeptOnward", ', '')
edit(CHECKER, """    "KeptOnward: a region of the steps of time that every step keeps holds from where it holds on, the "
    "grammar's closure at the successor along a line; the inductions over steps that keep a region are its cases. "
""", "")
edit(CHECKER, """    "GrammarLaws: the five master laws on the grammar, for every carrier and relation: closure is being the "
    "occurrence itself or reached; """, """    "GrammarLaws: the five master laws on the grammar, for every carrier and relation: closure is being the "
    "occurrence itself or reached, and a region of the steps of time every step keeps holds from where it holds "
    "on; """)
edit(CHECKER, """a map's image has a fixed successor exactly where sameness "
    "under the map goes alike; widening""", """a map's image has a fixed successor exactly where sameness "
    "under the map goes alike, and a map preserves a relation exactly where its image lies within the other; "
    "widening""")
ROOTMOD = PKG / 'Becoming.lean'
edit(ROOTMOD, 'import Becoming.KeptOnward\n', '')
edit(ROOTMOD, """* `Becoming.KeptOnward` (L1): a region every step keeps holds from where it holds on. A region of
  the steps of time that every step keeps, holding at step `a`, holds at every later step
  (`kept_onward`): the steps are a line under the successor (`«线则所闭»`), and a closed region
  holds what lies within the closure (`«闭含所闭»`). The inductions over steps that keep a region in
  `Becoming.Retaining`, `Becoming.Wholes`, `Becoming.Exclusion`, `Becoming.Reserve`,
  `Becoming.PatternPassing` and `Becoming.Persistence` are its cases. Its home is beside
  `«线则所闭»` in `Becoming.GrammarLaws`, where it moves at the next full rebuild (board item OU3f).
""", "")
edit(ROOTMOD, """  relation, with no premise. Closure: lying within a closure (`«所闭»`) is being the occurrence
  itself or reached (`«所闭当且仅当同一或及»`).""", """  relation, with no premise. Closure: lying within a closure (`«所闭»`) is being the occurrence
  itself or reached (`«所闭当且仅当同一或及»`), and a region of the steps of time that every step
  keeps holds from where it holds on (`kept_onward`), the activity laws of `Becoming.Retaining`,
  `Becoming.Wholes`, `Becoming.Exclusion`, `Becoming.Reserve`, `Becoming.PatternPassing` and
  `Becoming.Persistence` that keep a region along the steps by their own induction being its cases
  (board items OU3f, HE).""")
README_EDITS = {
    PKG / 'README.md': [
        ("(`«所闭当且仅当同一或及»`);", "(`«所闭当且仅当同一或及»`), a region every step keeps holding from where it holds on (`kept_onward`);"),
        ("sameness under it goes alike (`«像定后当且仅当同行»`);", "sameness under it goes alike (`«像定后当且仅当同行»`), a map preserving a relation exactly where its image lies within the other (`«保之像»`);"),
        ("; preserving an image lying within (`«保之像»`)", "")],
    PKG / 'README.zh.md': [
        ("（`«所闭当且仅当同一或及»`）；", "（`«所闭当且仅当同一或及»`），每步皆守之域自其所守处以后皆守（`kept_onward`）；"),
        ("（`«像定后当且仅当同行»`）；", "（`«像定后当且仅当同行»`），映射保一关系恰当其像在另一关系之内（`«保之像»`）；"),
        ("；保即像之所含（`«保之像»`）", "")]}
for readme, pairs in README_EDITS.items():
    for old, new in pairs:
        edit(readme, old, new)
for readme in (PKG / 'README.md', PKG / 'README.zh.md'):
    lines = text(readme).split('\n')
    rows = [i for i, l in enumerate(lines) if l.startswith('| L1 | [`Becoming.KeptOnward`]')]
    if len(rows) != 1:
        sys.exit(f'{readme.name}: KeptOnward row {rows}')
    del lines[rows[0]]
    pending[readme] = '\n'.join(lines)

# (5) total_eq_of_supports beside total_le_of_support.
KW, DISS = B / 'KeepingWidening.lean', B / 'Dissipation.lean'
edit(KW, """/-- Over lists without repetition holding where a quantity is positive, its totals agree. -/
theorem total_eq_of_supports {α : Type} {q : α → Nat} {l m : List α} (dl : Distinct l)
    (dm : Distinct m) (lm : ∀ a, 0 < q a → a ∈ m) (ml : ∀ a, 0 < q a → a ∈ l) :
    total l q = total m q :=
  Nat.le_antisymm (total_le_of_support dl fun a _ pos => lm a pos)
    (total_le_of_support dm fun a _ pos => ml a pos)


""", "")
edit(DISS, """        Nat.le_trans (Nat.add_le_add_left inner (q a)) (Nat.le_of_eq whole.symm)

/-- With equality decidable, membership in a list is decidable. -/""", """        Nat.le_trans (Nat.add_le_add_left inner (q a)) (Nat.le_of_eq whole.symm)

/-- Over lists without repetition holding where a quantity is positive, its totals agree. -/
theorem total_eq_of_supports {q : α → Nat} {l m : List α} (dl : Distinct l)
    (dm : Distinct m) (lm : ∀ a, 0 < q a → a ∈ m) (ml : ∀ a, 0 < q a → a ∈ l) :
    total l q = total m q :=
  Nat.le_antisymm (total_le_of_support dl fun a _ pos => lm a pos)
    (total_le_of_support dm fun a _ pos => ml a pos)

/-- With equality decidable, membership in a list is decidable. -/""")

# (6) «保之像» beside «像»; Mechanism's two image lemmas its cases.
edit(GT, """| `«保之像»` | preserving (保), read through the image: `«则» («像» φ R) R'` exactly where `R x y → R' (φ x) (φ y)`; a map preserving a relation, not a relation kept (守) nor two kept each within the other (齐) |
""", "")
edit(GT, """* **Along maps.** A map preserves a relation exactly where the image lies within the other
  (`«保之像»`), the inclusion counterpart of carrying. Ending on every branch (`«尽»`) reflects along any
  map that carries continuation from a region closed under it (`«尽之拉回»`), and going on along some""",
     """* **Along maps.** A map preserves a relation exactly where the image lies within the other
  (`«保之像»`, stated beside `«像»` in `Becoming.GrammarLaws`), the inclusion counterpart of
  carrying. Ending on every branch (`«尽»`) reflects along any map that carries continuation from a
  region closed under it (`«尽之拉回»`), and going on along some""")
edit(GT, "/-! ## Along maps: pulled back, and preserving -/", "/-! ## Along maps: pulled back -/")
edit(GT, """/-- **Preserving, read through the image (保之像).** A map takes every pair `R` relates to a pair `R'`
relates exactly where the image of `R` along it lies within `R'`. -/
theorem «保之像» {α : Type u} {κ : Type v} (φ : α → κ) (R : «际» α) (R' : «际» κ) :
    «则» («像» φ R) R' ↔ ∀ x y, R x y → R' (φ x) (φ y) :=
  ⟨fun within x y r => within _ _ ⟨x, y, rfl, r, rfl⟩,
   fun keeps _ _ ⟨x, y, hx, r, hy⟩ => Eq.subst (motive := fun b => R' _ b) hy
     (Eq.subst (motive := fun a => R' a (φ y)) hx (keeps x y r))⟩

""", "")
edit(GL, """def «像» (π : α → κ) (R : «际» α) : «际» κ := fun k k' => ∃ s u, π s = k ∧ R s u ∧ π u = k'
""", """def «像» (π : α → κ) (R : «际» α) : «际» κ := fun k k' => ∃ s u, π s = k ∧ R s u ∧ π u = k'

/-- **Preserving, read through the image (保之像).** A map takes every pair `R` relates to a pair `R'`
relates exactly where the image of `R` along it lies within `R'`: a map preserving a relation, not a
relation kept (守) nor two kept each within the other (齐). -/
theorem «保之像» {α : Type u} {κ : Type v} (φ : α → κ) (R : «际» α) (R' : «际» κ) :
    «则» («像» φ R) R' ↔ ∀ x y, R x y → R' (φ x) (φ y) :=
  ⟨fun within x y r => within _ _ ⟨x, y, rfl, r, rfl⟩,
   fun keeps _ _ ⟨x, y, hx, r, hy⟩ => Eq.subst (motive := fun b => R' _ b) hy
     (Eq.subst (motive := fun a => R' a (φ y)) hx (keeps x y r))⟩
""")
edit(GL, """  goes. Going alike keeps lines of every length alike (`«同行之迭»`).""", """  goes. Going alike keeps lines of every length alike (`«同行之迭»`). A map preserves a relation
  exactly where the image lies within the other (`«保之像»`).""")
MECH = B / 'Mechanism.lean'
edit(MECH, """  read through `π` (`Image`) is the least process the step factors through (`factors_image`,
  `Image.least`). Some determined process on the description admits every step so read if and""",
     """  read through `π` (`Image`) is the least process the step factors through (`factors_image`,
  `Image.least`), each a case of preserving read through the image (`«保之像»`). Some determined
  process on the description admits every step so read if and""")
edit(MECH, """/-- The step of `P` factors through `π` into its image. -/
theorem factors_image (P : Process S A) (π : S → K) : FactorsThrough P π (Image P π) :=
  fun s _ u step => ⟨s, u, rfl, step, rfl⟩

/-- **The image is the least process the step factors through.** Every process into which the
step of `P` factors through `π` admits every step of the image. -/
theorem Image.least {P : Process S A} {π : S → K} {Q : Process K A}
    (factors : FactorsThrough P π Q) {k : K} {a : A} {κ : K} :
    (Image P π).step k a κ → Q.step k a κ
  | ⟨s, u, at_k, step, to⟩ => at_k ▸ to ▸ factors s a u step""", """/-- The step of `P` factors through `π` into its image: each move's image lies within the image's
move, by definition, and a map whose image of a relation lies within another preserves it
(`«保之像»`). -/
theorem factors_image (P : Process S A) (π : S → K) : FactorsThrough P π (Image P π) :=
  fun s a u step => («保之像» π (fun s t => P.step s a t) (fun k κ => (Image P π).step k a κ)).mp
    (fun _ _ h => h) s u step

/-- **The image is the least process the step factors through.** Every process into which the
step of `P` factors through `π` admits every step of the image: a map preserving each move of `P`
into `Q`'s holds its image there (`«保之像»`). -/
theorem Image.least {P : Process S A} {π : S → K} {Q : Process K A}
    (factors : FactorsThrough P π Q) {k : K} {a : A} {κ : K} :
    (Image P π).step k a κ → Q.step k a κ :=
  fun h => («保之像» π (fun s t => P.step s a t) (fun k κ => Q.step k a κ)).mpr
    (fun x y step => factors x a y step) k κ h""")
edit(ROOTMOD, """  Along maps, a map preserves a relation exactly where its image lies within the other (`«保之像»`),
  and going on along some branch is pulled back along any map lifting continuation (`«延之拉回»`);""",
     """  Going on along some branch is pulled back along any map lifting continuation (`«延之拉回»`);""")
edit(ROOTMOD, """  (`«像定后当且仅当同行»`). Order: widening of relations""", """  (`«像定后当且仅当同行»`); a map preserves a relation exactly where its image lies within the
  other (`«保之像»`), with Mechanism's `factors_image` and `Image.least` its cases. Order: widening
  of relations""")
edit(CHECKER, """closed region, and going on along some branch along any map lifting continuation; a map preserves a relation "
    "exactly where its image lies within the other; steps, passing""", """closed region, and going on along some branch along any map lifting continuation; steps, "
    "passing""")

for path, new in pending.items():
    path.write_text(new, encoding='utf-8')
print('HE: items 2, 3, 5 and 6 applied in', len(pending), 'files; Becoming/KeptOnward.lean goes to the Lean history '
      'folder next (he_history_move.py)')
