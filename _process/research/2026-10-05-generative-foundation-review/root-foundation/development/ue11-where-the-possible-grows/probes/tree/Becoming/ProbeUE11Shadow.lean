import Becoming.HeldPossible
import Becoming.Junctures

/-!
# UE11 review probe: `keeping` under `open Branching`

Junctures defines `Branching.keeping P s`, the steps after which `s` can still be had. With the
module's `Becoming.keeping` in scope, a file inside `namespace Becoming` that opens `Branching`
reads bare `keeping` as the module's: Lean resolves a name through the enclosing namespaces before
the opened ones.

First run (27 October 2026), with the theorem below stated with bare `keeping P s` on its left
side, the build failed:

    error: Application type mismatch: The argument
      s
    has type
      S
    but is expected to have type
      S → S → Prop
    in the application
      keeping P s

So bare `keeping` there was `Becoming.keeping`, not `Branching.keeping`. The kept form below
compiles, stating the same reading positively.
-/

namespace Becoming

open Generative

open Branching

/-- Under `open Branching`, bare `keeping` is the module's. -/
theorem probeUE11_shadow {S : Type} {A : Type} (P : Process S A) (Same : S → S → Prop) :
    keeping P Same = Becoming.keeping P Same := rfl

end Becoming
