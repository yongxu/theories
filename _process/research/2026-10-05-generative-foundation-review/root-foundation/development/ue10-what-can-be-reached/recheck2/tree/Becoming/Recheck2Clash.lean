import Becoming
import Becoming.ReachableRanges

/-!
# UE10 second re-check probe: no name clash

The root module (every landed module) and the folded `Becoming.ReachableRanges` import together:
no declaration is declared twice (re-check RECHECK2-UE10.md).
-/

namespace Becoming

namespace Recheck2UE10

/-- Both modules' names resolve in one environment. -/
theorem clash_free : True := trivial

end Recheck2UE10

end Becoming
