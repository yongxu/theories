import Becoming.HE2U4Laws
import Becoming.Response
import Becoming.SelectionPool

/-!
HE2's items 3 and 4, checked outside the package: the three model lemmas re-proved through the new
grammar laws. Each statement here is the package's, copied verbatim, and each proof is the exact
text the lander pastes into its module (`KIT.md`). An `rfl` certificate per lemma shows two things:
- the statement is the package's, since `rfl` relates terms of one type only;
- the re-proof is the lemma itself, by proof irrelevance.

- `WithinClosure.converse` (Response): `«所闭之逆»` at the relation.
- `WithinClosure.of_reads` (SelectionPool): `«借步之所闭在二所闭»`, its two closures named as the
  pool's members `o` and `a`.
- `WithinClosureOf.to_reads` (SelectionPool): `«二所闭在借步之所闭»`, the pool's member read as
  one of the two closures.
-/

namespace Becoming
namespace HE2U4Check

open HE2U4

variable {F : Type}

theorem converse {rel : F → F → Prop} {f g : F} :
    WithinClosure (fun a b => rel b a) f g ↔ WithinClosure rel g f :=
  «所闭之逆»

theorem converse_certified : @WithinClosure.converse = @converse := rfl

theorem of_reads {rel rel' : F → F → Prop} {o a g : F}
    (split : ∀ g h, rel' g h → rel g h ∨ (g = o ∧ rel a h))
    (within : WithinClosure rel' o g) : WithinClosureOf rel (fun x => x = o ∨ x = a) g :=
  match «借步之所闭在二所闭» split within with
  | .inl inside => ⟨o, .inl rfl, inside⟩
  | .inr inside => ⟨a, .inr rfl, inside⟩

theorem of_reads_certified : @WithinClosure.of_reads = @of_reads := rfl

theorem to_reads {rel rel' : F → F → Prop} {o a g : F}
    (larger : ∀ g h, rel g h → rel' g h) (reaches : WithinClosure rel' o a)
    (within : WithinClosureOf rel (fun x => x = o ∨ x = a) g) : WithinClosure rel' o g :=
  «二所闭在借步之所闭» larger reaches (match within with
    | ⟨_, .inl same, inside⟩ => .inl (same ▸ inside)
    | ⟨_, .inr same, inside⟩ => .inr (same ▸ inside))

theorem to_reads_certified : @WithinClosureOf.to_reads = @to_reads := rfl

end HE2U4Check
end Becoming
