# Gated

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Gated.lean`
- *result records that name this place's file as a source* (computed; not a link): `every-origin-passes-the-gate`, `formed-contacts-change-copying-fidelity`, `organizational-rule-inheritance`, `where-the-possible-grows`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-course-that-only-returns`, `rule-raised-every-other-step`, `what-a-gate-keeps`, `where-the-possible-grows`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-06, as "Gated.lean: kept_along_iff, change_located, reflected_along, origin" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-06.md.txt)); pass b: reader whole-b-19, as "Gated.lean: Gated.KeptBy, kept_along_iff, change_passes_gate, change_located, PreservedBy, ReflectedBy, preserved_along_iff, leaving_passes_gate, origin, origin_of_propositions_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-19.md.txt)); the third pass, where the two differed: reader whole-c-settle-07, as "Gated.lean: settled fields reading, no_return, both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-07.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For any process with a Boolean gate, `kept_along_iff` (l. 53) equates keeping a quantity along every ungated trace with keeping it at each ungated step. Under the latter premise and decidable value equality, `change_located` (l. 78) splits any trace with unequal endpoint values at a gated step that changes the value.
  - *pass b:* For every process `Process S A` with a class of moves marked by `gate : A → Bool`: a quantity is kept along every course of ungated moves iff every ungated step keeps it (`kept_along_iff`). Where ungated moves keep q, a course changing q contains a gated move (`change_passes_gate`), located at one gated step where equality is decided (`change_located`). The origin law (`origin`): where ungated moves reflect p, a course ending where p holds started where p held, or splits at a gated step after which p holds. With the gate a proposition and asked of every process, the origin law is exactly double-negation elimination (`origin_of_propositions_iff`).
- **moves**
  - *pass a:* S: `change_passes_gate` (l. 64) requires any plan changing q to contain a gated move if all ungated steps keep q.
  - *pass b:* S: `KeptBy` (l. 40). `kept_along_iff` (l. 53): for every course (Trace) of ungated moves, q t = q s iff every ungated step keeps q. `change_passes_gate` (l. 64): where KeptBy holds, any course with q t ≠ q s has a move a in the plan with gate a = true. `leaving_passes_gate` (l. 149): where ungated moves preserve p, a course from p to not-p contains a gated move.
- **a reading**
  - *settled by the third pass:* N: opened `KeptBy` (l. 40), `kept_along_iff` (l. 53), `change_passes_gate` (l. 64), `change_located` (l. 78), `keptBy_iff_preserved` (l. 107), `keptBy_iff_reflected` (l. 113). `q : S → R` is any function of configurations, called a quantity in the account (l. 6); `keptBy_iff_preserved` states `KeptBy P gate q ↔ ∀ c, PreservedBy P gate (fun s => q s = c)` and `change_located` (with `DecidableEq R`, premise KeptBy) locates a gated step that changes q. The laws say when q is kept and where it changes; no step, gate or rule is made from the value of q, so nothing registered decides anything. [which pass was right: b; opened: the whole module (213 lines), every statement]
  - *pass a:* S: `keptBy_iff_preserved` (l. 107) equates preservation of the reading q by ungated steps with preservation of each class q=c. `change_located` (l. 78) uses decidable equality of readings to locate a gated step changing q when endpoint readings differ.
  - *pass b:* N: no reading or class read alike is named. The quantity q : S → R of `KeptBy` (l. 40) is any function of configurations; the laws concern its being kept, not a decision made from it.
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
  - *settled by the third pass:* S, in a weaker form than pass a said: `reflected_along` (l. 139; variables S A, P : Process S A, gate : A → Bool, p : S → Prop; premise `ReflectedBy P gate p`) states that along a trace all of whose moves are ungated, p at the finish gives p at the start; so a start without p is not brought to p by ungated moves. The one-step form is the premise and the course form is concluded; it holds only of ungated courses, and `origin` (l. 163) states that a gated step can bring p about. There is no point from which no course keeps or regains, no level, and no loss of something that gives. [which pass was right: both in part; opened: `PreservedBy` (l. 99), `ReflectedBy` (l. 103), `preserved_along` (l. 119), `preserved_along_iff` (l. 129), `reflected_along` (l. 139), `leaving_passes_gate` (l. 149), `origin` (l. 163), `origin_of_decides` (l. 181), `origin_of_propositions_iff` (l. 197)]
  - *pass a:* S: `reflected_along` (l. 139) concludes that p at the end of an ungated trace implies p at its start, assuming single-step reflection. Thus a start lacking p cannot regain it along such a trace.
  - *pass b:* N: no point of no return. The nearest statement is `leaving_passes_gate` (l. 149): from the premise that ungated moves preserve p, leaving p needs a gated move.
- **both outcomes**
  - *settled by the third pass:* N: opened `kept_along_iff` (l. 53), `preserved_along_iff` (l. 129), `change_passes_gate` (l. 64), `leaving_passes_gate` (l. 149), `origin` (l. 163), `origin_of_propositions_iff` (l. 197). `kept_along_iff` states that q is kept along every course of ungated moves exactly when every ungated step keeps it (`KeptBy`): one property, lifted from steps to courses, with no losing side stated. `origin` is a disjunction about where p came from (held at the start, or after a gated step), not about going on or ending. [which pass was right: b; opened: the whole module (213 lines), every statement]
  - *pass a:* S: `kept_along_iff` (l. 53) is an exact criterion for universal keeping on ungated courses, in terms of all ungated steps. It does not classify individual gated courses.
  - *pass b:* N for going on and ending. `origin` (l. 163) is a disjunction about origin (p held at the start, or a gated step brought it about). The iffs `kept_along_iff` (l. 53) and `preserved_along_iff` (l. 129) are of step and course.
- **a comparison between two**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a closed region**
  - *pass a:* S: `preserved_along_iff` (l. 129) equates closure of p under ungated steps with closure along all ungated traces.
  - *pass b:* S: `preserved_along_iff` (l. 129): p is preserved along every course of ungated moves iff every ungated step preserves it. `kept_along_iff` (l. 53) states the same for a quantity. `reflected_along` (l. 139) states it for reflection.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `change_located` (l. 78) locates where a change of q enters (a gated step), but nothing states going on continuing while what is present changes.
- **how it was read**
  - *pass a:* S: Read the opening account, all declaration statements and their docstrings. Statements support states, moves, reading, no_return, both_outcomes, closed_region. No finding for share, level, giving, cost, multiplying, comparison, rank, forms_change. All questions reached.
  - *pass b:* I read all statements of the module to l. 213. I answered moves and closed_region from statements; the other twelve are N.
