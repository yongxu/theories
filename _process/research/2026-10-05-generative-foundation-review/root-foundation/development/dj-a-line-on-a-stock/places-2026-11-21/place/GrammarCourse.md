# GrammarCourse

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarCourse.lean`
- *result records that name this place's file as a source* (computed; not a link): `processes-represented-both-ways`, `wen-in-the-grammar`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-06, as "GrammarCourse.lean: Law.core_is_sameFuture, Law.unending_iff, TwoCourses.core_iff_bounded" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-06.md.txt)); pass b: reader whole-b-20, as "GrammarCourse.lean: Law.core_is_sameFuture, Law.constant_iff_keeps, Law.unending_iff, Law.ends_iff_changes, Law.continues_in_core_iff, Law.stays_of_constant, Law.learnable_iff_core, TwoCourses.core_iff, TwoCourses.core_exact, core_iff_below" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-20.md.txt)); the third pass, where the two differed: reader whole-c-settle-08, as "GrammarCourse.lean: settled fields no_return, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-08.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For a deterministic law, `Law.core_is_sameFuture` (l. 128) identifies the core of equal readings with agreement at every future observation. `TwoCourses.core_iff_bounded` (l. 376) tests this agreement across two courses before N+N′−1 when their state bounds are N and N′.
  - *pass b:* For every determined law next : S → S and map o, the module proves that the law's step read as a relation makes constancy the same as the law keeping a relation, and the core of the value class the same as SameFuture (courses through the map agree at every step), so the coarsest lawful class is the core. Positions on a course follow in general (a line under the value class ends exactly where the value changes next, never ends exactly where the course is constant from there, and a step continues under the core exactly then), together with bounded reading of the core (N + N - 1 steps, exact for two courses) and learnability through the core.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the law is determined (next : S → S); no choice among steps.
- **a reading**
  - *pass a:* S: `Law.learnable_iff_core` (l. 261) equates a predictor working at every start with eventual agreement of feature values within each registration core class, in an exhaustively listed world with decidable registration equality.
  - *pass b:* S: Law.core_is_sameFuture (l. 128): the core of sameValue o under step next is SameFuture next o; Law.alike_iff_core (l. 140); Law.learnable_iff_core (l. 261): in a listed world, some predictor from prefixes of the reading predicts val at every configuration iff configurations in one core class of the reading have val agreeing from some step on; Law.learnable_of_core_within (l. 275).
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *settled by the third pass:* S: `Law.stays_of_constant` (l. 241): with `«有常» (step next) (sameValue o)` and `o s = o (next s)` as premises, concludes `∀ n, o (orbit next s n) = o s`. It is a keeping for good, concluded, on a determined law with no moves; it states no loss, no level, and no point from which something cannot be regained. `ends_iff_changes` (l. 164) only says a line under the value class ends exactly where the value changes at the next step. [which pass was right: both in part; opened: stays_of_constant l.241; ends_iff_changes l.164; unending_iff l.200; continues_in_core_iff l.217; reached_while_same l.181]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: Law.stays_of_constant (l. 241): where the value class is constant under the step, a course that keeps its value for one step keeps it at every later step (concluded from constancy); this is a lock-in of keeping, not a loss.
- **both outcomes**
  - *pass a:* S: `Law.ends_iff_changes` (l. 164) characterizes current ending by next-value inequality. `Law.unending_iff` (l. 200) characterizes never ending from s by the orbit always reading its initial value.
  - *pass b:* S: Law.unending_iff (l. 200): the line under the value class from s never ends exactly where o is constant along the orbit from s; Law.ends_iff_changes (l. 164): it ends exactly where the value changes at the next step; Law.continues_in_core_iff (l. 217): a step continues under the core exactly where the line never ends. General for every determined law and value type.
- **a comparison between two**
  - *pass a:* S: `Law.kept_along` (l. 120) carries any step-kept relation on starts along their synchronized orbits. `TwoCourses.core_iff` (l. 366) compares tails from arbitrary moments on distinct courses.
  - *pass b:* S: TwoCourses.core_iff (l. 366): two courses taken as one net on Nat ⊕ Nat have moments in one core class exactly where the courses agree from there; Law.kept_along (l. 120): a kept relation holds at every step of the orbits from related configurations; course_core_iff (l. 312): core on moments equals core on configurations; Law.coarsest_iff_core (l. 155).
- **a rank (an ending within a bound)**
  - *pass a:* S: `TwoCourses.core_iff_bounded` (l. 376) gives a finite observation deadline for distinguishing two bounded courses, sharp with two distinct values by `core_exact` (l. 387). This bounds comparison, not course duration.
  - *pass b:* S: core_iff_below (l. 326) and Law.core_iff_below (l. 247): with at most N states (or a closed list of length N) the core is read off N + N - 1 steps; TwoCourses.core_exact (l. 387): the length N + N' - 1 is exact. A bound on how long it takes to tell apart, not on ending.
- **a closed region**
  - *pass a:* S: `Law.stays_of_constant` (l. 241) keeps the current reading forever when its value class is constant and one step keeps the value. `Law.constant_iff_keeps` (l. 112) identifies constancy with closure of a relation under synchronized steps.
  - *pass b:* S: Law.constant_iff_keeps (l. 112): a relation is constant under the step exactly where the law keeps it (an invariant relation); Law.constant_iff_core (l. 233): the value class is constant exactly where it is its own core; SameAhead.next_by_root (l. 305): a state goes on as itself because the core is constant; statesBelow_iff_core (l. 331).
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* N: `SameAhead.no_continuation` (l. 319): with `new : ∀ t t', o t = o t' → t = t'`, concludes `¬ «续» Steps.next («核» Steps.next (sameValue o)) t t'` for all t, t'. The statement denies continuation; that the course has a next moment is the carrier (`Steps.next` on Nat), not something it states. Opened also `ends_iff_changes` (l. 164), `unending_iff` (l. 200), `TwoCourses.core_iff` (l. 366), `core_exact` (l. 387): none states a going on while what is present changes. [which pass was right: b; opened: SameAhead.no_continuation l.319; Steps.next_is_step l.292; ends_iff_changes l.164; unending_iff l.200; TwoCourses.next l.347, core_iff l.366, core_exact l.387]
  - *pass a:* S: `SameAhead.no_continuation` (l. 319) excludes all continuation under the value core along the successor course if equal observed values imply equal moments. The time course itself has a next moment everywhere.
  - *pass b:* N: the law's step always has a successor while lines under the value class end where the value changes; the only statement on a changing course is the contrary case, SameAhead.no_continuation (l. 319): a course with a new value at every moment has no continuation under its core.
- **how it was read**
  - *pass a:* S: Read the opening account, all declaration statements and their docstrings. Statements support states, reading, both_outcomes, comparison, rank, closed_region, forms_change. No finding for moves, share, level, giving, cost, multiplying, no_return. All questions reached.
  - *pass b:* All fourteen answered from statements; every statement, docstring and proof of the module read, lines 1-399.
