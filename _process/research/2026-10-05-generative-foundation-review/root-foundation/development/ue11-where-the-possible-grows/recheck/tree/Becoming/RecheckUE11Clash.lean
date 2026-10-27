import Becoming
import Becoming.HeldPossible

/-!
# UE11 re-check probe: name clashes and `keeping`

AI-written, 27 October 2026, for the independent re-check of UE11's fix round
(`RECHECK-UE11.md`). Imports the whole package (`Becoming`, the root import) together with the
module: an import of two modules declaring one name fails, so a build of this file shows that no
declaration of `Becoming.HeldPossible` clashes with one of the package. Inside `namespace Becoming`
under `open Branching`, bare `keeping` is Junctures' again: `#check` of an ambiguous name fails,
and the `rfl` below states which one it is.
-/

namespace Becoming

open Generative

open Branching

#check keeping

/-- Under `open Branching`, bare `keeping` is Junctures' `Branching.keeping`. -/
theorem recheckUE11_keeping_is_junctures {S : Type} {A : Type} (P : Process S A) (s : S) :
    keeping P s = Branching.keeping P s := rfl

end Becoming

namespace Becoming.RecheckUE11

theorem clash_free : True := trivial

end Becoming.RecheckUE11
