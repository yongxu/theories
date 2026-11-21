# Closing

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Closing.lean`
- *result records that name this place's file as a source* (computed; not a link): `how-loops-form`, `how-often-couplings-act`, `loops-within-what-a-law-reads`, `observation-is-a-route`, `two-act-worlds-carry-the-difference`
- *dynamics in the atlas that name one of those records* (computed; not a link): `how-loops-form`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-02, as "Closing.lean: onLoop_succ_iff, formedCourse_eq_carried, Threshold.level_succ" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-02.md.txt)); pass b: reader whole-b-05, as "Closing.lean: strengthsBefore, couples_before_iff, onLoop_iff_formed, onLoop_succ_iff, forms_by_closing, responds_to_own_level, carried_before, carried_le_polynomial_before, ReadsBefore, formedCourse_eq_carried, Closing.Onset, Closing.Threshold" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-05.md.txt)); the third pass, where the two differed: reader whole-c-settle-02, as "Closing.lean: settled fields multiplying, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-02.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `onLoop_succ_iff` (l. 307) says a loop in the accumulated couplings by T+1 was already formed by T or contains a coupling acting at T with the two specified upstream chains by T+1. `formedCourse_eq_carried` (l. 527) identifies the generated course with the amount carried under its own read strengths if ReadsBefore holds.
  - *pass b:* S: General laws for the carrying exchange (the CouplesAt, OnLoop and carried notions of Remainder and Loops). The loops a world has are exactly the loops formed by some step (onLoop_iff_formed l.178). The loops formed by T+1 are those formed by T plus those closed by a coupling acting at T (onLoop_succ_iff l.307, forms_by_closing l.332). Before a loop forms upstream, the carried amount is at most polynomial (carried_le_polynomial_before l.399). With strengths read from the levels so far, the course is the carried amount of the strengths it reads (formedCourse_eq_carried l.527). Built witnesses Onset (l.413) and Threshold (l.554): a loop forming at T or at θ, unforeseen from the amounts before.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: No choice among moves.
- **a reading**
  - *pass a:* S: `ExchangeLaw.carryingRead_nonanticipating` (l. 508) makes the carrying law nonanticipating if its strengths agree for histories agreeing up to the reading time.
  - *pass b:* S: ReadsBefore (l.492): strengths at each step depend only on the levels up to that step. formedCourse_eq_carried (l.527): the course the law with read strengths generates is the carried amount of those strengths. B: Threshold.reading (l.558): the exchange responds to the level once it reaches θ. Threshold.forms (l.650): the loop forms at step θ, so the registered level decides when it forms.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: Not found.
- **a level that runs down**
  - *pass a:* B: `Threshold.level_succ` (l. 581) adds one and, once the threshold is reached, the current level itself. `level_le_succ` (l. 609) makes this level nondecreasing.
  - *pass b:* S: carried_le_polynomial_before (l.399): with every condition listed, starting gaps ≤ D and inflow ≤ M, and no loop formed by T upstream of c, the carried amount at c up to T is ≤ D · orderSum M n t. These amounts grow. N: no level that runs down with what comes back depending on what is left.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: Couplings are supplied strength functions (k, or κ read off the course). The account says the read strengths are supplied. No giver is a going-on that can be lost.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: Not found.
- **multiplying**
  - *settled by the third pass:* B: Closing.Onset.amount_after (l. 451): amount T D (T + r) = D · 2^r, after amount_before (l. 446) keeps it at D up to T; Closing.Threshold.level_after (l. 617): level θ (θ + r) + 1 = (θ + 1) · 2^r. An amount carried by a self-loop of strength one doubles at every step in two built courses; these are amounts, not units leaving units, and no general law of multiplying is stated. [which pass was right: b; opened: Onset.strengths l. 416; amount l. 420; amount_succ_late l. 439; amount_before l. 446; amount_after l. 451; Threshold.level_succ l. 581; level_after l. 617]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* B: Onset.amount_after (l.451): the amount is D·2^r after the loop forms. Threshold.level_after (l.617): level + 1 doubles at every step from θ. These are amounts doubling, not units leaving units.
- **a point of no return**
  - *pass a:* S: `couples_before_mono` (l. 127) preserves already-formed couplings as the cutoff increases; this concerns historical occurrence.
  - *pass b:* S: couples_before_mono (l.127): couplings formed by a step stay formed by every later step, and onLoop_succ_iff keeps the earlier loops. This monotonicity is by the definition of strengthsBefore. N: no point of no return of a going-on. The account points to Remainder for loops dissolving.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: No going on versus ending, or keeping versus losing. onLoop_succ_iff (l.307) is an exactly-when for which loops are formed by a step.
- **a comparison between two**
  - *pass a:* S: `OnLoop.lift` and `Upstream.lift` (ll. 152, 156) carry loops and upstream chains between strengths under inclusion of couplings.
  - *pass b:* S: carried_before (l.367): the carried amount up to T is the same under strengthsBefore T k as under k. OnLoop.lift and Upstream.lift (l.152, l.156): loops and upstream carry to strengths with more couplings. B: Onset.unforeseen (l.477) and Threshold.unforeseen (l.662): a loop forming at T and one forming at any later T' carry the same amounts up to T.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: No ending within a bound and no falling variant. carried_le_polynomial_before (l.399) is an upper bound on growth before a loop forms.
- **a closed region**
  - *settled by the third pass:* S: Upstream.within (l. 240): with the section's cs, part, k, present, where Upstream cs part k present e c (a chain of couplings from e to c), WithinClosure (Couples cs part k present) e c: c lies in every set closed under coupling that holds e. It is membership in a closure under the coupling relation among conditions, not an invariant, kernel or fixed point of a course's step. [which pass was right: both in part; opened: section variables l. 197; Coupled.append l. 217; Coupled.one l. 233; Upstream.within l. 240; Onset.amount_before l. 446; Threshold.level_le_succ l. 609]
  - *pass a:* S: `Upstream.within` (l. 240) puts each downstream endpoint in the starting condition’s closure under coupling.
  - *pass b:* N: Not found.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `Threshold.not_formed` and `forms` (ll. 633, 650) show a new self-loop in the continuing level course at threshold; `level_after` (l. 617) gives its subsequent growth.
  - *pass b:* S: onLoop_succ_iff (l.307), forms_by_closing (l.332) and responds_to_own_level (l.343): loops come to be at the step a coupling closes a chain, within the unfolding. B: Threshold.forms (l.650) and Threshold.not_formed (l.633): a loop read off the course forms when the level reaches θ, and the course grows geometrically after (Threshold.level_after l.617).
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, reading, no_return, comparison, closed_region. Built-case answers cover level, forms_change. I reached all fourteen questions.
  - *pass b:* Every statement and docstring read, lines 1–667. All fourteen answered from statements; definitions of CouplesAt, OnLoop, Upstream and carried (Remainder, Loops) were not opened.
