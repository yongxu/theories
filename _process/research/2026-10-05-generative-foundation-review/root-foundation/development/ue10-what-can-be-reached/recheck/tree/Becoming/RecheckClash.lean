import Becoming
import Becoming.ReachableRanges

/-!
# UE10 re-check probe, part 3: no name clash

The root module (every landed module, UE9's `Becoming.ComparingCourses` among them) and the revised
`Becoming.ReachableRanges` import together: no declaration is declared twice (re-check
RECHECK-UE10.md).
-/

namespace Becoming

namespace RecheckUE10

/-- Both modules' names resolve in one environment. -/
theorem clash_free : True := trivial

end RecheckUE10

end Becoming
