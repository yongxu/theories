import Becoming.LineageDrawdown
/-- The scratch wrappers have exactly the landed statements' types. -/
theorem same_statement_regime :
    @Becoming.LineageDrawdown.landed_of_excess = @Becoming.LineageRegimes.degeneration_of_family_excess :=
  rfl
theorem same_statement_gone :
    @Becoming.LineageDrawdown.landed_gone = @Becoming.Web.family_excess_gone :=
  rfl
theorem same_statement_horizon :
    @Becoming.LineageDrawdown.landed_horizon = @Becoming.Web.family_excess_degenerates :=
  rfl
#print axioms same_statement_regime
#print axioms same_statement_gone
#print axioms same_statement_horizon
