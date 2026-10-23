# WL3: 文 and the grammar of continuation, a mapping

23 October 2026, board item WL3. AI-written. The 文 line (chapter [WENLI-AND-BECOMING](../../../../../../theories/becoming/chapters/WENLI-AND-BECOMING.md), 中华本 一·二十一, WL2's laws) and the one-unfolding root (`Becoming.Grammar`, [PLAN](../one-unfolding-root/PLAN.md), record continuation-relative-to-a-class) describe one structure in two vocabularies. This study states which notion of the one is which notion of the other, exactly where Lean proves it (`Becoming.GrammarCourse`, scratch `tree/`), and where they differ. Nothing in `Becoming.Grammar` is changed.

## 1. The reading that joins them

A 文 is given by a determined law `next : S → S` and a map `o : S → R` (`Learnable.course next o s`), or by any sequence of values `o : Nat → O` (a run's course through a map, `Parting.course reg r`, is one). The grammar is stated for a carrier `α`, a relation `R` read as 缘 and a class `E`. The join takes:

| grammar | 文 line | Lean |
|---|---|---|
| carrier | configurations `S`; for one 文, its moments `Nat` | |
| 缘 `R` | the law's step: `s` conditions `next s` | `Law.step next` (new); along moments `Steps.next` (Arising), and `Steps.next_is_step` says it is `Law.step Nat.succ` |
| class `E` | same value through the map | `sameValue o` (new), a class (`sameValue_class`) |
| `«有常» R E` | the law keeps the relation | `Law.constant_iff_keeps`: `«有常» (Law.step next) E ↔ Law.KeepsRelation next E`, every `E` |

## 2. What is exactly what

| 文 line | grammar | theorem | kind |
|---|---|---|---|
| 文同 `Law.SameFuture next o` | the core `«核» (Law.step next) (sameValue o)` | `Law.core_is_sameFuture` (a `«谓»`) | equivalence |
| likeness by bisimulation in the frame by the map (`Alike (Law.frameBy next o) …`) | the same core | `Law.alike_iff_core` | equivalence; makes exact, for a determined law, the correspondence with bisimulation that `«闭合当且仅当有常»`'s docstring names and leaves unproved |
| `Law.sameFuture_coarsest` (the same course is the coarsest relation keeping values that the law keeps) | the root theorem `«根»` read on a law | by `Law.core_is_sameFuture` and `Law.constant_iff_keeps` | instance (see §3 for the one difference of form) |
| a class keeping values and carrying the law (`Law.KeepsAndCarries`) | a class inside `sameValue o` and constant under the step | `Law.keepsAndCarries_iff` | equivalence |
| WL2's coarsest class (`Law.coarsest_iff`, second clause) | a symmetric constant relation inside the class contains the core exactly where it is the core | `Law.coarsest_iff_core`, from the grammar law `contains_core_iff` | instance |
| two moments of one 文 are one state (`SameAhead o`) | the core of `sameValue o` along `Steps.next` | `SameAhead.is_core` | equivalence |
| a state goes on as itself (`SameAhead.next`) | the core is constant (`«根»`, second clause) | `SameAhead.next_by_root` | derived through the grammar, beside the old proof |
| along a law's course, states of moments are states of configurations (`sameAhead_orbit_iff`) | the core on moments is the core on configurations | `course_core_iff` | equivalence |
| each moment its own state where every value is new (`SameAhead.new_each`) | no continuation under the core, the 文 form of the flame (`«以核为判据则火无续»`) | `SameAhead.no_continuation` | instance |
| at most `N` states (`StatesBelow o N`) | at most `N` classes of the core, each met before `N` | `statesBelow_iff_core` | equivalence |
| `Identification.sameAhead_iff_below` | the core of a bounded 文 is read off `N + N - 1` steps | `core_iff_below`; for a law on a listed world `Law.core_iff_below` | restatement |
| `Identification.bounded_agree` (two 文) | two 文 as one net on `Nat ⊕ Nat` (`TwoCourses.next`, `TwoCourses.value`): their moments lie in one class of the core exactly where the courses agree from there | `TwoCourses.core_iff`, `TwoCourses.core_iff_bounded` | equivalence |
| `Identification.bounded_agree_exact` | the length `N + N' - 1` is exact for the core of the joint net | `TwoCourses.core_exact` | instance |
| `Learnable.learnable_iff` | learnable exactly where the reading's core makes features agree from some step on | `Law.learnable_iff_core` | restatement |
| a feature read off the course at every step | the reading's core lies in the feature's class, equivalently in its core | `Law.learnable_of_core_within`, `core_within_core_iff` | sufficient condition; the equivalence is a grammar law |

Positions on a 文, which the 文 line did not name: under the value class a configuration's line ends exactly where its value changes at the next step (`Law.ends_iff_changes`); every line runs along the orbit (`Law.line_on_orbit`); the line never ends exactly where the course is constant from there (`Law.unending_iff`); a step continues under the core exactly where the line under the class never ends (`Law.continues_in_core_iff`, for every law and every type of values; `Change.continues_in_core_iff_buqiong` is its two-valued parallel on one determination); the value class is constant exactly where it is its own core (`Law.constant_iff_core`), and then a course keeping its value for one step keeps it for good (`Law.stays_of_constant`, through `«有常则续不尽»`).

## 3. Where the two vocabularies differ

1. **文同 is the core, not continuation.** The 文 line has no notion of 续. In the grammar, continuation under the value class along a law is one step on which the value stays; continuation under the core is a course constant from there (`Law.continues_in_core_iff`). So 文同 and 状 belong to the grammar's 理 (the core, 有常之核, PLAN §4.1 「理是它之类」), not to its 续. The chapter's phrase that a state "goes on as itself" (`SameAhead.next`) is the core's constancy, not a line of continuation.
2. **Classes are kernels of maps.** Every class of the 文 line is equality of values through a map; the grammar's classes are any equivalence relations. The two-valued class of Arising and Change (`Steps.alike p`, `p s ↔ p t`) is the Prop case; identifying it with `sameValue p` would take `propext`, so `Change.core_iff_same_course` stays its parallel, not an instance.
3. **缘 is a function.** A determined law gives each configuration one successor; the grammar allows any relation. A run of a nondeterministic process is joined only through its course (its moments with the step), not through the process's branching: the grammar's reading of a net of possibilities with a conflict relation (PLAN §4.1) is not built here.
4. **Coarsest over all relations, greatest over symmetric ones.** `Law.sameFuture_coarsest` takes every relation that keeps the values and that the law keeps; `«根»` is maximal among symmetric ones. They have the same greatest element (the symmetric closure of a kept relation is kept), and `Law.core_is_sameFuture` uses WL2's form; no separate theorem derives WL2's form from the root alone.
5. **No counting, lists or "from some step on".** The prefix (往, `Learning.prefixOf`), the bounds `N + N - 1` and `N + N' - 1` as numbers, the extrapolations of `Becoming.Learnable` and `Becoming.Unrolling` (`reading_predicts`, `learnable_iff_reading`), and learnability's eventual agreement are stated beside the core, not in the grammar's terms. The bounded laws say how far one must read to decide the core; the grammar has no notion of how far.
6. **Equality of values is a model commitment**, as equality on the carrier is in the grammar.
7. **A formation's own course** (record a-formations-own-course, on webs, values read through couplings) is a 文 of the kind above once its values are given, so the laws here apply to it; its reading as values is not derived in the grammar, and it is not joined separately here.

## 4. For OU's owner

No Grammar definition needs to change. Two proposals, recorded in the board row:

- `core_within_core_iff` and `contains_core_iff` hold for every carrier and relation and use only `«根»`; they could move down into `Becoming.Grammar` (then `Becoming.GrammarCourse` would cite them there).
- The docstring of `«闭合当且仅当有常»` says the correspondence of constancy with bisimulation is not proved there; `Law.alike_iff_core` proves it exact for a determined law read through a map, and the docstring could cite it.
