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

end Becoming
