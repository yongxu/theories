# Derivation

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Derivation.lean`
- *result records that name this place's file as a source* (computed; not a link): `derivation-soundness`, `finite-basis-common-interpretation`, `wisdom-root`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-04, as "Derivation.lean: Derives.sound, pointwise_iff_common, Scope.goal_closure" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-04.md.txt)); pass b: reader whole-b-12, as "Derivation.lean: Derives, Derives.sound, closed_throughout, closure_throughout_iff, countermodel_excludes, lemma_throughout, pointwise_iff_common, rows_not_pointwise, Scope.goal_closure, Scope.common_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-12.md.txt)); the third pass, where the two differed: reader whole-c-settle-05, as "Derivation.lean: settled fields reading, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-05.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Derives.sound` (l. 95) gives the conclusion of any derivation at every state meeting its basis and all local premises. With a list covering the basis, `pointwise_iff_common` (l. 206) equates separate admissible witnesses for every closed derivable claim with one admissible witness for them all.
  - *pass b:* General: finite proof trees from a basis under local premises (Derives) are sound (Derives.sound), so over any domain where the basis holds every derived claim holds; the whole closure holds throughout exactly where the basis does (closure_throughout_iff), and a countermodel in the domain excludes a claim (countermodel_excludes). With a finite basis, pointwise and common satisfaction of the closure agree (pointwise_iff_common); this is read on an inquiry's Scope (Scope.goal_closure, Scope.common_iff), with built counter-cases rows and trivialBasis.
- **moves**
  - *pass a:* S: `Scope.goal_closure` (l. 275) places every closed consequence of the goal throughout the execution scope of any policy sound for the given process, sensing, response, safety, goal and starting belief.
  - *pass b:* S: `Scope.goal_closure` (l. 275): for any Process P, sensing, response, belief B and policy Sound for safe and goal, every claim derived from the goal holds at every configuration of the policy's Scope. Inquiry.lean l. 34 defines the Scope as the configurations that actual executions of the policy reach from believed ones. This is a law about what every execution keeps.
- **a reading**
  - *settled by the third pass:* N: `Scope.goal_closure` (l. 275), with section variables `P : Process S A`, `sense : S → A → S → Fin k`, `response`, `B`, `policy`, and premise `Sound P safe goal sense response policy B`, concludes that every q derived from the goal holds `Throughout (Becoming.Scope P sense response B policy)`; `sense` stands in the statement as a parameter of `Sound` and `Scope`, but nothing registered decides anything in it. Opened to rule it out: Scope.goal_closure, Scope.common_iff, Scope.common_relative. [which pass was right: a; opened: Scope.goal_closure l. 275; Scope.common_iff l. 282; Scope.common_relative l. 288; the Scope section's variable line l. 272]
  - *pass a:* N: `Scope.goal_closure` (l. 275) takes the sensing rule as a parameter and gives soundness on the resulting scope. I found no criterion determining a claim or a choice from a registered value alone.
  - *pass b:* S (as a premise only): the Scope in `Scope.goal_closure` (l. 275) and `Scope.common_iff` (l. 282) is built from a policy acting on `sense : S → A → S → Fin k`. No law in this module has what is registered deciding something beyond carrying the goal's closure over the scope.
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
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N for going on and ending. S for an exactly-when about claims: `closure_throughout_iff` (l. 127): every claim derived with no premise holds throughout D iff every basis claim does.
- **a comparison between two**
  - *pass a:* S: `lemma_throughout` (l. 154) carries validity throughout a domain to every closed consequence of the basis extended by a closed derived lemma, assuming the original basis throughout.
  - *pass b:* S (between bases, not processes): `lemma_throughout` (l. 154): with the basis holding throughout D, the basis extended by a derived lemma still has its whole closure holding throughout D. `common_basis_iff_common_closure` (l. 198): some admissible configuration meets the closure iff one meets the basis.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *settled by the third pass:* N: `closed_throughout` (l. 116) and `closure_throughout_iff` (l. 127) are over an arbitrary domain `D : S → Prop` (section variables `basis`, `D`), with no step and no premise that D is kept by one; `Scope.goal_closure` (l. 275) applies it to the Scope, which is not stated closed under steps here. The closure is under derivation. Opened to rule it out: Throughout, closed_throughout, relative_throughout, closure_throughout_iff, Scope.goal_closure. [which pass was right: a; opened: Throughout l. 68; Derives l. 72; closed_throughout l. 116; relative_throughout l. 121; closure_throughout_iff l. 127; Scope.goal_closure l. 275]
  - *pass a:* N: `closure_throughout_iff` (l. 127) concerns closure under derivation. Its domain is supplied without a step-invariance premise.
  - *pass b:* S (partial): `closed_throughout` (l. 116): over a domain where every basis claim holds, every derived claim holds throughout. `Scope.goal_closure` (l. 275) applies this to the reached Scope. Neither the domain nor the Scope is stated closed under steps here.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and its docstring. I used statements for states, moves, comparison. I reached all fourteen questions.
  - *pass b:* Answered from statements: states, moves, reading, both_outcomes, comparison, closed_region; the N answers come after reading every statement. Scope was checked in Inquiry.lean. All statements read (298 lines).
