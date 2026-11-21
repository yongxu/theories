# PropositionIdentity

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PropositionIdentity.lean`
- *result records that name this place's file as a source* (computed; not a link): `proposition-identity`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-14, as "PropositionIdentity.lean: extensional_iff_lumped, Formula.eval_congr, transport_const" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-14.md.txt)); pass b: reader whole-b-53, as "PropositionIdentity.lean: Extensional, lumped_iff, extensional_iff_lumped, Formula.eval_congr, byName_lumped_iff, transport_const" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-53.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `extensional_iff_lumped` (l. 85) identifies propositional extensionality with lumping every proposition-valued reading at the two ends of every interderivation. `Formula.eval_congr` (l. 123) gives interderivability of the evaluated formulas from pointwise interderivability of the atoms without that premise.
  - *pass b:* `propext`, stated as `Extensional`, holds exactly where every reading of propositions into propositions is lumped by interderivability (`extensional_iff_lumped`). Readings through formulas built from atoms, connectives and quantifiers respect interderivability with no axiom (`Formula.eval_congr`, `Formula.read_congr`), and the identity reading `byName` is lumped exactly where `propext` holds (`byName_lumped_iff`). These laws are general over Lean's `Prop` and concern the proof language, not a web.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a reading**
  - *pass a:* S: `lumped_iff` (l. 73) characterizes forgetting which end is read by equality of the reading's values for every interderivable pair.
  - *pass b:* S: `lumped_iff` (l. 73): a reading g : Prop → V is `Learning.Lumped` by interderivability exactly where g takes one value at any two interderivable propositions. `extensional_iff_lumped` (l. 85): Extensional exactly where every reading Prop → Prop is so lumped. `lumped_of_extensional` (l. 92): under Extensional, readings into any type are lumped. `byName_lumped_iff` (l. 169) and `lumped_of_byName` (l. 173). `Formula.read_congr` (l. 156): reading a proposition through a formula, with the other atoms fixed, takes interderivable propositions to interderivable ones.
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
  - *pass b:* N. D: the opening account (l. 32-38) says that transport along `propext` does not compute. It calls this a kernel observation, not a theorem.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a comparison between two**
  - *pass a:* S: `Formula.read_congr` (l. 156) carries interderivability through any formula reading with the other atoms fixed; `transport_const` (l. 201) preserves any value transported along an equality of propositions with constant motive.
  - *pass b:* S: `Formula.eval_congr` (l. 123): where two atom readings ρ and σ are pointwise interderivable, every formula evaluates interderivably under both, so interderivability is carried through formulas. `transport_const` (l. 201): transport along any equation of propositions, with a motive that does not depend on the proposition, keeps the value.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration's statement and its docstring where present. General statements answer states, reading, comparison. The remaining fields are N. No question was unreached.
  - *pass b:* Every statement was read, the whole of 211 lines. `reading` and `comparison` were answered from statements, `no_return` in part from the account; the rest are N. `Learning.Lumped` was checked in Learning.lean (l. 834).
