import Becoming.Clock
import Becoming.MoveFormation

/-! Review check (OU3f closure, 29 October 2026): how `clock` resolves once `Law.clock` is in scope
beside MoveFormation's `clock`. Compiled against `tree-new/.build`; output in `names.out`. -/

namespace Becoming

#check clock
#check Law.clock

-- `Law.clock` is a run of MoveFormation's process `clock Unit`, by definition.
example : Run (clock Unit) := Law.clock
example : clock Unit = Law.process Nat.succ := rfl

namespace Law
-- Inside the namespace of determined laws, where `Law.run` and `Law.succ_orbit` are stated,
-- `clock` now names the run, not MoveFormation's process.
#check clock
end Law

end Becoming
