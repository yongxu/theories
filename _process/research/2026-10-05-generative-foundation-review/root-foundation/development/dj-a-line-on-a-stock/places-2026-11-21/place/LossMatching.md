# LossMatching

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/LossMatching.lean`
- *result records that name this place's file as a source* (computed; not a link): `finite-aggregation-within-restorable-basic-losses`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-11, as "LossMatching.lean: strictLossMatch_iff_counts, ReadsAt.loss_retained, readsAt_iff_settled" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-11.md.txt)); pass b: reader whole-b-40, as "LossMatching.lean: StrictLossMatch, strictLossMatch_iff_counts, StrictLossMatch.length_lt, strictLossMatch_of_extension, SufficientMatching, ReadsAt.loss_retained, readsAt_iff_settled, EndlessLosses" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-40.md.txt)); the third pass, where the two differed: reader whole-c-settle-15, as "LossMatching.lean: settled fields both_outcomes, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-15.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Frame.strictLossMatch_iff_counts` (l. 329) characterizes strict class-respecting loss matches for two configurations with losses listed once and decidable claim and class equality. `Frame.readsAt_iff_settled` (l. 429) says that some support reads a claim at time τ exactly when its realization agrees with its value at τ forever after.
  - *pass b:* For every frame (a process with a realization relation from configurations to claims) it defines a strict loss match between two configurations and proves that matches compose and are monotone. A generative extension is a match, so sufficiency of matching contains comparison principle C. With losses listed once, it proves the counting law: a match exists exactly when, class by class, the better configuration loses no more and loses fewer in all. It also proves that a claim read at its time and missed then stays missed. All of this is general; the one built model is EndlessLosses, which shows that finiteness is needed.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the frame carries a process F.P, and ReadsAt (l. 417) speaks of a Run F.P. But no statement quantifies over a choice of moves or says what some or every choice keeps; the comparisons are between two configurations.
- **a reading**
  - *pass a:* S: `ReadsAt` (l. 417) makes realization at each later time equivalent to support at the episode time. `readsAt_iff_settled` (l. 429) characterizes when such a reading exists.
  - *pass b:* S: `strictLossMatch_iff_counts` (l. 329): where content is read as a class κ : C → K and both configurations' losses are listed once, a strict loss match exists iff for every class k, classCount κ k lb ≤ classCount κ k lw, and lb.length \< lw.length. `ReadsAt` (l. 417) and `readsAt_iff_settled` (l. 429): a claim is read at time τ by some support exactly when its realization from τ on equals its realization at τ.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `classCount` (l. 224) counts the members of a list in one content class. It is used only as a comparison inside the counting law; no rule or favouring is set again from it.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: losses are claims not realized; no stock or amount occurs. `not_strictLossMatch_of_base_lost` (l. 209) has a support claim `base` on which every claim rests, but as a Prop with no amount.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the support `base` and its premise `rests : ∀ s c, realized s c → realized s base` (l. 210) are handed in as a claim and a premise, not a going-on of the model that can be lost.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* S: `ReadsAt.loss_retained` (l. 423) concludes permanent nonrealization along the run from a missed episode, given ReadsAt and absent support then.
  - *pass b:* S: `ReadsAt.loss_retained` (l. 423): if claim c is read at τ along run r and its support fails at τ, then c is not realized at any t ≥ τ, whatever support holds then. `not_readsAt_of_recovery` (l. 437): if c is missed at τ and realized later, it is not read at τ. This is concluded, but from a premise that `readsAt_iff_settled` (l. 429) shows is the same as settledness. It is at the level of one claim, not of a giver.
- **both outcomes**
  - *settled by the third pass:* S (as a definition, used as a premise): `Frame.ReadsAt` (l. 417) is the proposition that for every t ≥ τ, `F.realized (r.state t) c ↔ support (r.state τ) c`, for a run of any frame; `ReadsAt.loss_retained` (l. 423) concludes from it and `¬ support (r.state τ) c` that c is realized at no later step. No theorem concludes both outcomes; `readsAt_iff_settled` (l. 429) and `strictLossMatch_iff_counts` (l. 329) are exactly-whens of reading and of matching. [which pass was right: both in part; opened: ReadsAt l. 417; loss_retained l. 423; readsAt_iff_settled l. 429; not_readsAt_of_recovery l. 437; strictLossMatch_iff_counts l. 329; strictLossMatch_iff_length_of_alike l. 344.]
  - *pass a:* S: `ReadsAt` (l. 417) stipulates both outcomes along one run. At and after τ the claim is realized iff its support held at τ.
  - *pass b:* N: no exactly-when of going on and ending, or of keeping and losing, for one model. The iffs present are of matching (`strictLossMatch_iff_counts` l. 329, `strictLossMatch_iff_length_of_alike` l. 344) and of reading (`readsAt_iff_settled` l. 429).
- **a comparison between two**
  - *pass a:* S: `StrictLossMatch.mono` (l. 93) transports a match when the content relation widens, the better state loses a subset of its former losses, and the worse loses a superset.
  - *pass b:* S: `StrictLossMatch` (l. 70) relates two configurations. `StrictLossMatch.trans` (l. 81): matches compose where the content relation is transitive. `StrictLossMatch.mono` (l. 93): a wider content relation, fewer losses at the better and more at the worse keep a match. `strictLossMatch_of_extension` (l. 106): an Extension s t (t keeps every claim of s and realizes one more living claim) gives a match of t against s. `SufficientMatching.comparison` (l. 123): sufficiency gives comparison principle C. `StrictLossMatch.asymm` (l. 178) holds with losses listed. B: `EndlessLosses.self_match` (l. 452): with infinitely many losses a configuration matches itself.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `StrictLossMatch.length_lt` (l. 152) is a count inequality between two configurations, not an ending within a bound.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* S (as a premise only): `strictLossMatch_of_extension` (l. 106): with `same` reflexive, `Extension F living s t` (t keeps every claim of s and realizes a living claim s does not; Extension.lean l. 45) gives `F.StrictLossMatch same t s`. The widening is a relation between two configurations taken as hypothesis; nothing states that a course goes on or that an extension exists. [which pass was right: both in part; opened: strictLossMatch_of_extension l. 106; SufficientMatching l. 116; Extension (Extension.lean l. 45); EndlessLosses.self_match l. 452.]
  - *pass a:* S: `strictLossMatch_of_extension` (l. 106) turns a given generative extension into a strict loss match back to the original configuration under reflexive content. Existence of an extending course is not concluded.
  - *pass b:* N: the only widening is `Extension`, used as a premise in `strictLossMatch_of_extension` (l. 106), a relation between two configurations rather than a course that goes on.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and the docstrings. General statements — states, reading, no_return, both_outcomes, comparison, forms_change. Not found — moves, share, level, giving, cost, multiplying, rank, closed_region. No commentary-only answers. All questions were reached.
  - *pass b:* All statements and docstrings read to the end (l. 463). reading, no_return and comparison are answered from statements, with a built case for comparison; the rest are N having read every statement.
