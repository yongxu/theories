# Propagation

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Propagation.lean`
- *result records that name this place's file as a source* (computed; not a link): `how-a-carried-difference-grows`, `how-loops-form`, `how-much-difference-arrives`, `how-often-couplings-act`, `loops-within-what-a-law-reads`, `observation-is-a-route`, `orders-as-a-sum-over-histories`, `two-act-worlds-carry-the-difference`, `two-sided-regulation-and-late-reading`, `what-a-cut-loses`, `what-a-set-point-optimum-does-beyond`, `where-a-level-couples`, `whether-a-loop-closes-a-difference`, `worlds-are-runs`
- *dynamics in the atlas that name one of those records* (computed; not a link): `how-loops-form`, `late-relay-oscillates`, `overshoot-beyond-the-gap`, `two-sided-regulation-and-late-reading`, `what-a-set-point-optimum-does-beyond`, `whether-a-loop-closes-a-difference`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-14, as "Propagation.lean: most_difference_arrives, carried_pos_iff, insensitiveAt_iff_strength_zero, carried_succ" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-14.md.txt)); pass b: reader whole-b-53, as "Propagation.lean: gap_le_carried, most_difference_arrives, carried, ExchangeLaw.RespondsWithin, carried_pos_iff, Conveyed, Propagation.Chain.keeps_arriving, Propagation.Loop.runaway" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-53.md.txt)); the third pass, where the two differed: reader whole-c-settle-20, as "Propagation.lean: settled fields no_return" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-20.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `most_difference_arrives` (l. 824) identifies the sharp bound on a condition's level gap across two balanced flows with common participation, bounded initial and part gaps, and a common nonanticipating law outside the part with bounded strengths, assuming decidable condition equality and a distinct exhaustive list. `carried_pos_iff` (l. 903) characterizes positive carried amount by a timed route of holding, input or positive response from a previous conveyed gap.
  - *pass b:* For every law of exchange that reads only what has stood (`ExchangeLaw.Nonanticipating`) and whose exchanges outside a part have coupling strengths at most `k` (`ExchangeLaw.RespondsWithin`), and for every two balanced flows of it, each condition's gap at each step is at most the carried amount (`gap_le_carried`), and that bound is attained, so a gap is at most `a` for all such laws and flows exactly where the carried amount is at most `a` (`most_difference_arrives`). These laws are general; the module also has built witnesses: a chain with no loop where one unit arrives as 2t (`Propagation.Chain.keeps_arriving`), a loop where it arrives as 2^t (`Propagation.Loop.runaway`), and a square law that has no finite strength (`Propagation.Square.not_respondsWithin`).
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: there is no Process, policy or allowed set of steps. The part (`part : F → Bool`) acts freely within the gaps σ, and `most_difference_arrives` (l. 824) quantifies over every law and every two flows, but no law says what a choice keeps.
- **a reading**
  - *pass a:* S: `ExchangeLaw.insensitiveAt_iff_strength_zero` (l. 552) identifies insensitivity to a condition with zero strength for every exchange target and every time up to the step under nonanticipation and decidable condition equality.
  - *pass b:* S: `ExchangeLaw.insensitiveAt_iff_strength_zero` (l. 552): for a law of what has stood, h's exchange at t is insensitive to d exactly where its strength from d's level is zero at every step up to t, for every condition. `ExchangeLaw.sensitive_iff_strength` (l. 1104): sensitivity holds exactly where some strength is not zero. `levels_alike_of_not_conveyed` (l. 990): under the premises of `gap_le_carried`, a condition to which no gap is conveyed has the same level in both flows. All of these are about which levels a law reads. No observation, class of things read alike, or rule made from what is registered was found.
- **a share**
  - *pass a:* N: `ExchangeLaw.exchangeGap_le_shares` (l. 533) splits a bound over lists of conditions; no favouring update from a population count or fraction was found.
  - *pass b:* N: `ExchangeLaw.exchangeGap_le_shares` (l. 533) names a "part's share", but it is a sum of strengths times gaps that bounds an exchange's gap. It is not a fraction of one kind among several, and nothing is set again from it.
- **a level that runs down**
  - *pass a:* S: `levels_step_exact` (l. 248) relates level changes to taking and giving in both balanced flows; `ExchangeLaw.RespondsWithin` (l. 311) bounds change of exchange from a change in one level. The carried bound itself never decreases (`carried_le_succ`, l. 631).
  - *pass b:* S: levels of conditions in balanced flows; `levels_step_exact` (l. 248) states the exact balance of two flows' levels across a step, given what each takes and gives. Exchanges can depend on levels through `RespondsWithin` (l. 311). N: no statement that a level runs down, or that what comes back depends on what is left. The carried amount never falls (`carried_le_succ`, l. 631).
- **a giving that is itself a going-on**
  - *pass a:* N: `carried_succ` (l. 620) adds the giving of the formations listed at the step. Participation is an input, and this law does not explain how a giver can be lost.
  - *pass b:* N: what gives is an `ExchangeLaw` (a function handed in) and the formations present (`present : Nat → List F`, handed in). No giver is a going-on of the model that can be lost.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no units leave units. B: `Propagation.Loop.runaway` (l. 1255): a carried amount doubles each step around a loop of strength one (2^t). It is an amount, not a count of units.
- **a point of no return**
  - *settled by the third pass:* S: `carried_le_succ` (l. 631), in section Carried with variables cs, part, σ, k, present, δ and no hypothesis: `carried cs part σ k present δ t c ≤ carried cs part σ k present δ (t + 1) c`, the carried amount never falls; and the constructor `Conveyed.hold` (l. 868): conveyed at t gives conveyed at t + 1. These are one-way (monotone) facts about a bound on a gap, concluded and general; they are not a point of no return in the field's sense: nothing is lost, there is no low level and no loss of a giver. [which pass was right: both in part; opened: ExchangeLaw.carrying l.583; carried l.592; carried_zero l.616; carried_succ l.620; carried_le_succ l.631; Conveyed l.865; Conveyed.spread l.969; levels_alike_of_not_conveyed l.990; carried_mono l.1072]
  - *pass a:* S: `carried_le_succ` (l. 631) concludes that the carried amount cannot fall on a step; this is irreversibility of the bound, not exhaustion of an actual flow.
  - *pass b:* N: nothing is lost for good. The only one-way facts are monotone: once conveyed, a gap stays conveyed (the `Conveyed.hold` constructor, l. 868), and the carried amount never falls (`carried_le_succ`, l. 631).
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no statement has the outcomes going on and ending, or keeping and losing. Two iff statements exist: `most_difference_arrives` (l. 824) and `carried_pos_iff` (l. 903): the carried amount is positive exactly where a gap is conveyed along a route in time.
- **a comparison between two**
  - *pass a:* S: `gap_le_carried` (l. 656) bounds each gap of two balanced flows by a third generated course under the common-law, listing, participation and gap/strength premises. `carried_mono` (l. 1072) orders these comparison courses pointwise from ordered inputs, starts and strengths.
  - *pass b:* S: `gap_step` (l. 260): in two balanced flows with the same formations present, a condition's gap across a step is at most its gap before plus the exchange gaps. `gap_le_carried` (l. 656) bounds the difference between two flows of one law by the carried amount. `carried_mono` (l. 1072): larger part gaps, start gaps and strengths carry at least as much, so order is kept. `carried_add` (l. 1031): carried amounts add. `Conveyed.spread` (l. 969): a conveyed gap lies on a route of `TimedResponse.Spread`.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no bound on ending and no falling variant. The carried amount only grows, and `Propagation.Chain.keeps_arriving` (l. 1209) has no bound.
- **a closed region**
  - *pass a:* S: `carried_quiet` (l. 739) keeps all carried amounts zero given zero initial and part gaps, for any strengths and participation.
  - *pass b:* S, in a narrow sense: `carried_quiet` (l. 739): with no starting gaps and no part gaps, the carried amount is 0 at every step, so the quiet course stays at zero. `carriedWorld_balanced` (l. 1345): the carried world balances, with no premise. No largest closed region, kernel or certificate was found.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the formations present may vary by step (`present : Nat → List F`), but no statement concerns forms changing while the going on continues. B: `Propagation.Chain.keeps_arriving` (l. 1209): a difference given once keeps arriving without bound. It is a growth of difference, not a change of forms.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration's statement and its docstring where present. General statements answer states, reading, level, no_return, comparison, closed_region. The remaining fields are N. No question was unreached.
  - *pass b:* Every declaration's statement and docstring was read, all 1350 lines, with some proof bodies. All fourteen were answered from statements, apart from N answers. The definitions ExchangeLaw, Nonanticipating, InsensitiveAt and Follows were checked in Counterfactual.lean (l. 120-170).
