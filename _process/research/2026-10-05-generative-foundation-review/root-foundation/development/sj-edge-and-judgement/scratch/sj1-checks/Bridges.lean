import Becoming.LearningRuns
import Becoming.CommonResponse

/-! Check, not a module to land: law 5's act-map form is `Learning.Lumped` by definition, so the
bridge needs no theorem of its own. -/

namespace Becoming

theorem lumped_iff_common_check {S O A : Type} (read : S → O) (act : S → A) :
    Learning.Lumped read act ↔ ∃ J, «共应» (fun s s' => read s = read s') (fun a s => act s = a) J :=
  («映应共应当且仅当同读同应» read act).symm

end Becoming
