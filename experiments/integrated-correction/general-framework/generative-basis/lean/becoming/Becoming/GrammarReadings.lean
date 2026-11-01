import Becoming.Grammar

/-!
# The grammar's definitions read from the corpus (文法之定义，读自语料)

Definitional sentences of the frozen first-batch corpus (`one-unfolding-root/corpus/`, classified
in `one-unfolding-root/classify/`) written in the grammar of `Becoming.Grammar`, for every carrier
and relation, with what follows from them. Each definition cites its unit; each reading is an AI
reconstruction, recorded with its losses in the plan (`PLAN.md` §5).

| name | unit | reading |
|---|---|---|
| `«化»` | MJ-J-045 「化，徵易也」; XZ-ZM-063 「状变而实无别而为异者，谓之化」 | alteration: continuing under the class of the thing while the class of its marks tells the two apart |
| `«成坏»` | JSZ-P-08-003 「諸根合會是成相，諸緣各住自位是壞相」 | at once, alike under the coarse class and apart under the fine one |
| `«同于»` | MJ-J-039 「同，異而俱於之一也」 | alike in belonging to one: related to a common one |
| `«复»` | LZ-16-005 「復命曰常」 | a line returns to where it was |
| `«通»` | XCS-11-010 「往來不窮謂之通」 | going and coming never end: the line from an occurrence never ends along 缘, nor along its converse |

The 墨经's and 荀子's 化 are one form (`«化之二说同形»`), and 化 is 成坏 along 缘 (`«化为有缘之成坏»`):
the synchronic reading of the 金师子章 and the diachronic reading of the 墨经 differ only by 缘.
同 is a class where each thing belongs to one and to one only (`«同于为类»`), and otherwise need not be
transitive (`«同于不必传递»`), as the 墨经's 類同 is not. A returning occurrence abides (`«复者住»`);
under a constant class a line with a past never ends going (`«有常则往不穷»`), and what has a
predecessor passes through, going and coming, where a class is constant both ways
(`«两向有常有前则通»`, what abides being its case, `«两向有常则通»`); constancy
one way is not enough (`«有常而不通»`), and under the one day and night go and come without end
(`«昼夜往来不穷»`). The first horn of the 中论's
dilemma, 「若一則無緣，若異則無相續」, holds of identity and of no class between: in a net without
self-conditioning there is no continuation under identity, yet every 缘 is a continuation under
some class while identity tells its ends apart (`«非一非异»`). The second horn, whether a
condition must still be present when what it conditions arises, is not expressible here: the
grammar has no relation of co-presence, and adding one is a choice of model (`PLAN.md` §一). The
answer the 中论 gives to the plan's reading (「滅更不生故，因即為斷滅」) holds under identity while the
continuation holds under a coarser class (`«因灭而续»`).

Every declaration has an empty axiom report.
-/

namespace Becoming

universe u

section Readings

variable {α : Type u}

/-- Alteration (化), read from the 墨经's 「化，徵易也」 (MJ-J-045, the marks change) and the
荀子's 「状变而实无别而为异者，谓之化」 (XZ-ZM-063): `y` continues `x` under the class `E` of the
thing, while the class `F` of its marks (状, 徵) tells them apart. -/
def «化» (R E F : «际» α) : «际» α := fun x y => «续» R E x y ∧ ¬ F x y

/-- The two readings of 化 are one form: 化 is alteration (`«异»`). -/
theorem «化之二说同形» (R E F : «际» α) : «谓» («化» R E F) («异» R E F) :=
  fun _ _ => Iff.rfl

/-- 成坏, read from the 金师子章 (JSZ-P-08-003, 法藏's base text): at once, the parts are alike
under the coarse class `L` (合會, 成) and apart under the fine class `F` (各住自位, 壞). A
synchronic reading at two grains, not a beginning and an end. -/
def «成坏» (L F : «际» α) : «际» α := fun x y => L x y ∧ ¬ F x y

/-- 化 is 成坏 along 缘: the diachronic alteration of the 墨经 and 荀子 is the synchronic two-grain
reading of the 金师子章 with a condition between its ends. -/
theorem «化为有缘之成坏» (R E F : «际» α) : «谓» («化» R E F) («合» R («成坏» E F)) :=
  fun _ _ => ⟨fun ⟨⟨r, e⟩, nf⟩ => ⟨r, e, nf⟩, fun ⟨r, e, nf⟩ => ⟨⟨r, e⟩, nf⟩⟩

/-- 同, read from the 墨经's 「同，異而俱於之一也」 (MJ-J-039): two are the same in belonging to one
when both are related by `S` to a common one. -/
def «同于» (S : «际» α) : «际» α := fun x y => ∃ z, S x z ∧ S y z

/-- Where each thing belongs to one and to one only, sameness in belonging is a class. -/
theorem «同于为类» {S : «际» α} (total : ∀ x, ∃ z, S x z)
    (single : ∀ {x z z'}, S x z → S x z' → z = z') : «类» («同于» S) := by
  refine ⟨fun x => match total x with | ⟨z, h⟩ => ⟨z, h, h⟩,
    fun ⟨z, hx, hy⟩ => ⟨z, hy, hx⟩, ?_⟩
  intro x y w ⟨z, hx, hy⟩ ⟨z', hy', hw⟩
  have hzz : z = z' := single hy hy'
  exact ⟨z, hx, by cases hzz; exact hw⟩

/-- Where a thing belongs to two, sameness in belonging need not be transitive (the 墨经's 類同,
alike in some respect, is not a class by itself). -/
theorem «同于不必传递» :
    ∃ (S : «际» Nat), «同于» S 0 1 ∧ «同于» S 1 2 ∧ ¬ «同于» S 0 2 := by
  refine ⟨fun x z => (x = 0 ∧ z = 10) ∨ (x = 1 ∧ z = 10) ∨ (x = 1 ∧ z = 20) ∨ (x = 2 ∧ z = 20),
    ⟨10, .inl ⟨rfl, rfl⟩, .inr (.inl ⟨rfl, rfl⟩)⟩,
    ⟨20, .inr (.inr (.inl ⟨rfl, rfl⟩)), .inr (.inr (.inr ⟨rfl, rfl⟩))⟩, ?_⟩
  intro ⟨z, h0, h2⟩
  match h0, h2 with
  | .inl ⟨_, hz⟩, .inr (.inr (.inr ⟨_, hz'⟩)) => exact absurd (hz.symm.trans hz') (by decide)
  | .inl _, .inl ⟨h, _⟩ => exact absurd h (by decide)
  | .inl _, .inr (.inl ⟨h, _⟩) => exact absurd h (by decide)
  | .inl _, .inr (.inr (.inl ⟨h, _⟩)) => exact absurd h (by decide)
  | .inr (.inl ⟨h, _⟩), _ => exact absurd h (by decide)
  | .inr (.inr (.inl ⟨h, _⟩)), _ => exact absurd h (by decide)
  | .inr (.inr (.inr ⟨h, _⟩)), _ => exact absurd h (by decide)

/-- Return (复), read from the 老子's 「復命曰常」 (LZ-16-005): the line from `x` comes back to `x`. -/
def «复» (R E : «际» α) (x : α) : Prop := «相续» R E x x

/-- Whatever a line reaches has a predecessor in it. -/
theorem «相续之末有前» {R E : «际» α} {x y : α} (h : «相续» R E x y) : «有前» R E y := by
  induction h with
  | one c => exact ⟨_, c⟩
  | more _ _ ih => exact ih

/-- What returns abides: it is continued and it continues something. -/
theorem «复者住» {R E : «际» α} {x : α} (h : «复» R E x) : «住» R E x :=
  ⟨«相续之末有前» h, match h with
    | .one c => ⟨_, c⟩
    | .more c _ => ⟨_, c⟩⟩

/-- Passing through (通), read from the 系辞's 「往來不窮謂之通」 (XCS-11-010), with 往來 read as a
relation and its converse and 不窮 as never ending (the classification's reading of the unit): from
`x`, going (往, along 缘) never ends and coming (來, along its converse) never ends. -/
def «通» (R E : «际» α) (x : α) : Prop := «不穷» R E x ∧ «不穷» («逆» R) E x

/-- Under a constant class, a line with a past never ends going: what has been continued goes on. -/
theorem «有常则往不穷» {R E : «际» α} (hc : «有常» R E) {x : α} (hx : «有前» R E x) : «不穷» R E x :=
  fun _ hy => match hy with
    | .inl e => by cases e; exact «有常则续不尽» hc hx
    | .inr l => «有常则相续不尽» hc l

/-- **Passing through, going and coming (两向有常有前则通).** Where a class is constant under 缘 and
under its converse, an occurrence with a predecessor under it passes through: going never ends, and
coming never ends. Constancy gives the successor (`«有常则续不尽»`), so a predecessor is enough. -/
theorem «两向有常有前则通» {R E : «际» α} (hE : «类» E) (hc : «有常» R E) (hc' : «有常» («逆» R) E)
    {x : α} (hx : «有前» R E x) : «通» R E x :=
  ⟨«有常则往不穷» hc hx, «有常则往不穷» hc' (match «有常则续不尽» hc hx with
    | ⟨y, hr, he⟩ => ⟨y, hr, hE.symm he⟩)⟩

/-- **What abides passes through (两向有常则通).** Where a class is constant under 缘 and under its
converse, an occurrence that abides passes through: the case of `«两向有常有前则通»` for what abides. -/
theorem «两向有常则通» {R E : «际» α} (hE : «类» E) (hc : «有常» R E) (hc' : «有常» («逆» R) E) {x : α}
    (hx : «住» R E x) : «通» R E x :=
  «两向有常有前则通» hE hc hc' hx.1

/-- **Constancy one way is not passing through (有常而不通).** Counting up from zero under the one: the
class is constant and the line from one never ends going, yet coming back it ends at zero. -/
theorem «有常而不通» :
    ∃ (R : «际» Nat), «有常» R «一» ∧ «有前» R «一» 1 ∧ «不穷» R «一» 1 ∧ ¬ «通» R «一» 1 := by
  let R : «际» Nat := fun m n => n = m + 1
  have hc : «有常» R «一» := by
    apply («有常之逐点» R «一»).mpr
    intro u u' _ v _
    exact ⟨u' + 1, rfl, trivial⟩
  have hp : «有前» R «一» 1 := ⟨0, rfl, trivial⟩
  refine ⟨R, hc, hp, «有常则往不穷» hc hp, fun ⟨_, back⟩ => ?_⟩
  match back 0 (.inr (.one ⟨rfl, trivial⟩)) with
  | ⟨w, hw, _⟩ => exact Nat.noConfusion hw

/-- **Day and night go and come without end (昼夜往来不穷).** Two occurrences, each the condition of
the other, under the one: every occurrence passes through. -/
theorem «昼夜往来不穷» (x : Bool) : «通» (fun a b : Bool => b = !a) «一» x := by
  refine ⟨fun y _ => ⟨!y, rfl, trivial⟩, fun y _ => ⟨!y, ?_, trivial⟩⟩
  cases y <;> rfl

/-- **Neither one nor other (非一非异).** In a net without self-conditioning, there is no
continuation under identity (「若一則無緣」), and every 缘 is a continuation under some class
while identity tells its two ends apart: continuation relative to a class is neither identity nor
mere difference. -/
theorem «非一非异» {R : «际» α} (irr : ∀ z, ¬ R z z) :
    (∀ x y, ¬ «续» R «静» x y) ∧ (∀ {x y}, R x y → ∃ E : «际» α, «类» E ∧ «化» R E «静» x y) := by
  refine ⟨fun x y ⟨r, e⟩ => by cases e; exact irr _ r, fun {x y} h => ?_⟩
  match «任一缘可为续» h with
  | ⟨E, hE, hc⟩ => exact ⟨E, hE, hc, fun e => by cases e; exact irr _ h⟩

/-- **The cause ends and the line continues (因灭而续).** The 中论's answer to the plan's reading,
「滅更不生故，因即為斷滅」 (ZL-21-122), holds under identity: in a net without self-conditioning,
the conditioning occurrence ends and the conditioned one begins, each a single flash. Under a
class alike at both ends the same 缘 is a continuation. The two hold at once, each relative to its
class; the plan reads continuation as such a designation relative to a class, not as a
continuation with its own being. -/
theorem «因灭而续» {R E : «际» α} (irr : ∀ z, ¬ R z z) {x y : α} (h : R x y) (e : E x y) :
    «亡» R «静» x ∧ «生» R «静» y ∧ «续» R E x y :=
  ⟨fun ⟨_, r, q⟩ => by cases q; exact irr _ r, fun ⟨_, r, q⟩ => by cases q; exact irr _ r, h, e⟩

end Readings

end Becoming
