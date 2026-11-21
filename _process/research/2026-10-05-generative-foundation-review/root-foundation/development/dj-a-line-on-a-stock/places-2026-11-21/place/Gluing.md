# Gluing

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Gluing.lean`
- *result records that name this place's file as a source* (computed; not a link): `gluing-under-parity`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-06, as "Gluing.lean: ParitySystem.global_or_contradicts, ParitySystem.glues_iff, ParitySystem.mixture_le" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-06.md.txt)); pass b: reader whole-b-20, as "Gluing.lean: ParitySystem.global_or_contradicts, ParitySystem.glues_iff, ParitySystem.noGlobal_iff, ParitySystem.mixture_le, ParitySystem.indexed_met, ParityConstraint.met_or_contradicts, Gluing.Cycle.met_iff_even" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-20.md.txt)); the third pass, where the two differed: reader whole-c-settle-07, as "Gluing.lean: settled fields both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-07.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `ParitySystem.global_or_contradicts` (l. 455) gives either one assignment meeting all listed contexts or a contradicting selection of them, for decidable claim equality and distinct listed claims. `ParitySystem.glues_iff` (l. 476) characterizes existence of a respecting world that glues by absence of such a contradiction when the contexts are exhaustively listed.
  - *pass b:* For claims constrained by parity in listed contexts, the module proves in general that with decidable equality and claims listed without repetition, either one context-free assignment meets every context or some selection of contexts contradicts (counts every claim evenly while the parities add to odd), so a world respecting the possibilities glues exactly where no selection contradicts; a Bell-type bound says a context-free assignment, and any mixture on average, meets at most m-1 of a contradiction's m contexts while readings indexed by context meet all m. These general laws are applied to built instances: Specker's three boxes, the CHSH game, the Mermin-Peres square, and a parametric cycle of equal/differ relations met exactly where its differ relations are even.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no process with moves, policy or plan; the only choice is of an assignment v : C → Bool, and the laws (ParitySystem.unmet_odd, l. 390) are about every assignment, not about steps.
- **a reading**
  - *pass a:* S: `ParitySystem.local_` (l. 376) makes support depend only on what a context counts. `ParitySystem.unmet_odd` (l. 390) says each context-free assignment fails an odd number in any contradicting list.
  - *pass b:* S: ParitySystem.glues_iff (l. 476): with every context listed and claims distinct, some Contextual world with the system's within-relation, respecting the supports, glues exactly where no selection of contexts Contradicts; ParitySystem.noGlobal_iff (l. 466) the same for NoGlobal; ParitySystem.indexed_met (l. 430): reading each context by its own assignment within its possibilities meets all of them. What a context shows depends only on the claims within it (ParitySystem.local_, l. 376).
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: counts of contexts met appear (ParitySystem.met_le, l. 412: met + 1 ≤ length for a contradiction; mixture_le, l. 419, averaged over a list of assignments), but no rule or favouring is set again from such a count.
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
  - *settled by the third pass:* N: opened `ParitySystem.global_or_contradicts` (l. 455), `noGlobal_iff` (l. 466), `glues_iff` (l. 476), `contradicts_noGlobal` (l. 406), `Gluing.Cycle.met_iff_even` (l. 811). `global_or_contradicts` (variables K C, S : ParitySystem K C; `DecidableEq C`, `Distinct S.claims`, a list `all` of contexts) states: some assignment `v : C → Bool` is within every listed context, or a selection of the listed contexts contradicts. `met_iff_even` states an assignment meets every relation of a cycle exactly where `polarity n pol close = false`. Both are dichotomies of readings fitting together or not; no step, course, keeping or ending occurs in them. [which pass was right: a; opened: `ParitySystem` (l. 343), `support` (l. 363), `Contradicts` (l. 372), `unmet_of_contradicts` (l. 396), `contradicts_noGlobal` (l. 406), `met_le` (l. 412), `global_or_contradicts` (l. 455), `noGlobal_iff` (l. 466), `glues_iff` (l. 476), `met_iff_even` (l. 811). Pass b describes the same statements and itself says they are not of going on against ending.]
  - *pass a:* N: `ParitySystem.global_or_contradicts` (l. 455) decides between a joint assignment and a contradictory selection under its listing and equality premises. This is compatibility of readings, with no temporal keeping or ending in the statement.
  - *pass b:* S: ParitySystem.global_or_contradicts (l. 455) is a dichotomy (a context-free assignment meeting every listed context, or a contradicting selection), general for every parity system with decidable equality and distinct claims; Gluing.Cycle.met_iff_even (l. 811): a cycle is met by some assignment exactly where its polarity is even. These are dichotomies of gluing vs contradiction, not of going on vs ending.
- **a comparison between two**
  - *pass a:* S: `ParitySystem.mixture_le` (l. 419) bounds the total met by context-free assignments on a contradicting list by its length minus one per assignment, while `indexed_met` (l. 430) attains the full length given a meeting assignment for each context. `ParityConstraint.pull_back` (l. 279) transfers any selection after pivot elimination back with the same combined counts and required parity.
  - *pass b:* S: ParityConstraint.pull_back (l. 279) and pulled (l. 257): a selection of constraints after eliminating a claim comes from a selection before it with the same counts and parities together (a contradiction carried back through elimination); ParitySystem.contradicts_iff (l. 380) carries Contradicts between a system and its list of constraints. D: that Specker's boxes are the three-differ cycle relabelled and that CorrectionRelations.cycle_compatible_iff_even is the same law is said in the account (l. 58-60) and the docstring of met_iff_even (l. 807), with no statement here relating them.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the elimination is structural recursion on the list of claims (met_or_contradicts, l. 298); no variant, drain or deadline is stated.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: Read the opening account, all declaration statements and their docstrings. Statements support states, reading, comparison. No finding for moves, share, level, giving, cost, multiplying, no_return, both_outcomes, rank, closed_region, forms_change. All questions reached.
  - *pass b:* All fourteen answered from statements (with one D part in comparison); every statement, docstring and proof body of the module read, lines 1-822.
