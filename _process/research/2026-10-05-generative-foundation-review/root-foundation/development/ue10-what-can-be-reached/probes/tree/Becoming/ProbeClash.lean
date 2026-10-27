import Becoming
import Becoming.ComparingCourses
import Becoming.ReachableRanges

/-!
# UE10 review probe, part 5: no name clash

The root module (every landed module), UE9's kit module `Becoming.ComparingCourses` (copied unchanged
from its kit) and the draft `Becoming.ReachableRanges` import together: no declaration is declared
twice (review REVIEW-UE10.md).
-/

namespace Becoming

namespace ProbeUE10

/-- Both modules' names resolve in one environment. -/
theorem clash_free : True := trivial

end ProbeUE10

end Becoming
