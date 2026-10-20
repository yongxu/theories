import IdealsCorrespondence
/-! PE2 reduction checks, Lean 4.30.0-rc2 with Mathlib, against IdealsCorrespondence as its
receipt checked it. `ofList` gives `getElem` a bound proof (`ofList._proof_2`) on `propext`;
the bound is carried into the list's index and never taken apart on a closed list. -/
theorem ofList_letter : (Becoming.IdealsCorrespondence.ofList [5, 6, 7]).letter ⟨1, by decide⟩ = 6 := by decide
theorem ofList_letter_rfl : (Becoming.IdealsCorrespondence.ofList [5, 6, 7]).letter ⟨2, by decide⟩ = 7 := rfl
theorem ofList_length : (Becoming.IdealsCorrespondence.ofList [5, 6, 7]).length = 3 := rfl
#print axioms Becoming.IdealsCorrespondence.ofList
#print axioms ofList_letter
#print axioms ofList_letter_rfl
#print axioms ofList_length
