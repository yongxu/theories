import Becoming.U4dCases

/-! U4d scratch: each re-proof proves the package's own statement, checked against its type. -/

namespace Becoming

theorem U4d.same_coming_from_of_ceasing : type_of% @Covers.coming_from_of_ceasing :=
  @U4d.coming_from_of_ceasing
theorem U4d.same_coming_of_ceasing_covered : type_of% @coming_of_ceasing_covered := @U4d.coming_of_ceasing_covered
theorem U4d.same_not_not_coming_from : type_of% @Covers.not_not_coming_from := @U4d.not_not_coming_from
theorem U4d.same_ceasing_stops_unrefuted : type_of% @Covers.ceasing_stops_unrefuted := @U4d.ceasing_stops_unrefuted
theorem U4d.same_ceasing_steps_within : type_of% @Covers.ceasing_steps_within := @U4d.ceasing_steps_within
theorem U4d.same_not_not_arisingFrom_covered : type_of% @Web.not_not_arisingFrom_covered := @Web.U4d.not_not_arisingFrom_covered
theorem U4d.same_arisingFrom_not_stopping_covered : type_of% @Web.arisingFrom_not_stopping_covered :=
  @Web.U4d.arisingFrom_not_stopping_covered
theorem U4d.same_ceasingFrom_not_stopping_covered : type_of% @Web.ceasingFrom_not_stopping_covered :=
  @Web.U4d.ceasingFrom_not_stopping_covered

namespace Web

/-- Identity's census recurrence laws, with the decisions their section carries, are cases of the
new exact forms from covering lists. -/
theorem U4d.census_case : type_of% @Census.arisingFrom_of_ceasingFrom_from :=
  fun {_ _} W R _ _ _ alive T listing noSplit ceasing =>
    U4d.arisingFrom_of_ceasingFrom_covered (W := W) (R := R) (T := T)
      (fun N => ⟨N + T, alive (N + T), Nat.le_add_right N T,
        fun f h => ((listing (N + T) (Nat.le_add_left T N)).2 f).mp h⟩) noSplit ceasing

theorem U4d.census_converse_case : type_of% @Census.ceasingFrom_of_arisingFrom_from :=
  fun {_ _} W R _ _ _ alive T B listing noMerge bounded arising =>
    U4d.ceasingFrom_of_arisingFrom_covered (W := W) (R := R) (T := T) (B := B)
      (fun t from_ => ⟨alive t, bounded t from_, fun f h => ((listing t from_).2 f).mp h⟩)
      noMerge arising

end Web

end Becoming
