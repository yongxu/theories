# JointPlans

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/JointPlans.lean`
- *result records that name this place's file as a source* (computed; not a link): `code-plan-global-support`, `exclusive-footprint-support`, `joint-code-plan-lifting`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-08, as "JointPlans.lean: JointPlan.Realizes, JointPlan.within_of_realizes, JointPlan.supports_of_realizes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-08.md.txt)); pass b: reader whole-b-31, as "JointPlans.lean: JointPlan, JointPlan.Realizes, PartsWithin, PartsApart, Supports, JointPlan.draws, JointPlan.supports_of_realizes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-31.md.txt)); the third pass, where the two differed: reader whole-c-settle-11, as "JointPlans.lean: settled fields moves, comparison" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-11.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For any ternary decomposition whose part footprints lie within the whole, every listed draw of a realized plan with supported leaves belongs to its root's footprint (JointPlan.within_of_realizes, l. 85). If the two part footprints are also disjoint, the ordered list of all leaf draws has no repetitions and is supported at the root (JointPlan.supports_of_realizes, l. 110).
  - *pass b:* The module gives general laws for any ternary relation J s l r. A joint plan is a finite binary nesting of leaves, realized where a configuration holds parts realizing each side. Where each part's footprint lies within its whole's and the two parts' footprints are disjoint, what the leaves of a realized plan draw on repeats nothing and lies within the root's footprint (supports_of_realizes).
- **moves**
  - *settled by the third pass:* N: `JointPlan Q` (l. 34) is an inductive of `leaf q` and `pair left right`; `JointPlan.Realizes` (l. 44) says, for a ternary `J : X → X → X → Prop`, that `s` realizes `.pair p q` where `∃ x y, J s x y ∧ Realizes x p ∧ Realizes y q`. There is no process, step or course in the module (the account: 'Nothing here reads a frame or a labelled process'), so `supports_of_realizes` (l. 110) is a law about a nesting of decompositions, not about what a choice among steps keeps. Opened: all ten declarations. [which pass was right: b; opened: JointPlan l.34; JointPlan.Realizes l.44; nodup_append_of_apart l.56; PartsWithin l.66; PartsApart l.70; Supports l.75; JointPlan.draws l.79; within_of_realizes l.85; nodup_of_realizes l.96; supports_of_realizes l.110]
  - *pass a:* S: JointPlan.Realizes (l. 44) admits different witnesses for each binary decomposition. JointPlan.supports_of_realizes (l. 110) holds for every realized plan under containment, disjointness and supported leaves; the plan is a finite tree.
  - *pass b:* N: a JointPlan is a nesting of decompositions, not a choice of moves.
- **a reading**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: leaves are read by a supplied `leaf : X -> Q -> Prop`; no law in which what is registered decides something.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a comparison between two**
  - *settled by the third pass:* N: `JointPlan.within_of_realizes` (l. 85), section variables `S`, `R`; premise `within : PartsWithin footprint J`; for every plan `p` and `s` with `JointPlan.Realizes J (Supports footprint) s p`, `∀ a, a ∈ p.draws → footprint s a`. It carries footprint membership from the parts a whole holds up to the whole, inside one configuration's decomposition; it relates no two processes, starts or ways, and no step is in the module. Opened to rule it out: `PartsWithin` (l. 66), `within_of_realizes` (l. 85), `nodup_of_realizes` (l. 96), `supports_of_realizes` (l. 110). [which pass was right: b; opened: PartsWithin l.66; within_of_realizes l.85; nodup_of_realizes l.96; supports_of_realizes l.110]
  - *pass a:* S: JointPlan.within_of_realizes (l. 85) carries footprint membership from supported leaves to the whole under PartsWithin.
  - *pass b:* N.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N. (`PartsWithin` (l. 66) is a condition of footprints under J, not a region closed under steps.)
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. General statements support states, moves, comparison. I found no matching statement for reading, share, level, giving, cost, multiplying, no_return, both_outcomes, rank, closed_region, forms_change. No answer rests on prose alone or was unreached.
  - *pass b:* All answered from statements. Read whole (119 lines, all statements).
