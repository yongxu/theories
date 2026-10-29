import Becoming.ProcessRepresentation
import Becoming.Mechanism

/-!
# Scratch check for the design's §6 (not a landed module)

Mechanism's two image lemmas as cases of preserving read through the image (`«保之像»`): the step
factoring through a map into its image, and the image the least process the step factors into. The
item would move `«保之像»` beside `«像»` in GrammarLaws so that Mechanism, which imports GrammarLaws
and not GrammarTransport, can prove them so; here both are proved with `«保之像»` where it now is.
-/

namespace Becoming

open Generative

namespace U2Preserving

universe u v w

variable {S : Type u} {A : Type v} {K : Type w}

/-- `factors_image` as a case of `«保之像»`: each move's image lies within the image process's move,
by definition. -/
theorem factors_image_case (P : Process S A) (π : S → K) : FactorsThrough P π (Image P π) :=
  fun s a u step => («保之像» π (moveRel P a) (moveRel (Image P π) a)).mp (fun _ _ h => h) s u step

/-- `Image.least` as a case of `«保之像»`: a process the step factors into holds each move's image. -/
theorem image_least_case {P : Process S A} {π : S → K} {Q : Process K A}
    (factors : FactorsThrough P π Q) {k : K} {a : A} {κ : K} :
    (Image P π).step k a κ → Q.step k a κ :=
  fun h => («保之像» π (moveRel P a) (moveRel Q a)).mpr (fun x y step => factors x a y step) k κ h

end U2Preserving

end Becoming
