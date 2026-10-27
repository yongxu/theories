import Becoming
import Becoming.HeldPossible

/-!
# UE11 review probe: name clashes

Imports the whole package (`Becoming`, the root import) together with the module. An import of
two modules declaring one name fails, so a build of this file shows that no declaration of
`Becoming.HeldPossible` clashes with one of the package.
-/

namespace Becoming.ProbeUE11

theorem clash_free : True := trivial

end Becoming.ProbeUE11
