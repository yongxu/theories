# LumpedSeeking

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/LumpedSeeking.lean`
- *result records that name this place's file as a source* (computed; not a link): `expected-free-energy-and-its-terms`, `what-seeking-cannot-separate`
- *dynamics in the atlas that name one of those records* (computed; not a link): `what-seeking-cannot-separate`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-11, as "LumpedSeeking.lean: seek_tied, seeking_keeps_order, posterior_le_iff_prior" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-11.md.txt)); pass b: reader whole-b-40, as "LumpedSeeking.lean: Tied, posterior_le_iff_prior, order_kept, seekWeight, seek_tied, seeking_keeps_order, Agree.keeps_tails, Agree.seeking_turns_tails" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-40.md.txt)); the third pass, where the two differed: reader whole-c-settle-15, as "LumpedSeeking.lean: settled fields share, both_outcomes, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-15.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `seek_tied` (l. 175) proves that two hypotheses tied by every experiment assign the same weight to every course under any history-dependent experiment policy. `seeking_keeps_order` (l. 187) preserves their strict prior order on records of positive mass, while `Agree.seeking_turns_tails` (l. 349) gives a coin experiment that separates the biases.
  - *pass b:* For any prior and likelihood over listed hypotheses, two hypotheses the likelihood ties keep their prior order in the posterior share given any record that weighs something. The same holds over every course of seeking, whatever the policy that picks each experiment from the course so far: seeking does not correct an error that every experiment ties. These laws are general; the built witness Agree (three coin biases) shows one wrong order turned and another kept, and seeking with an experiment that separates turns it.
- **moves**
  - *pass a:* S: `seek_tied` (l. 175) allows any choice weights determined by the preceding course and preserves equality of course weights under an all-experiment tie.
  - *pass b:* S: `seekWeight` (l. 168): a course of seeking weighs each experiment by choose : List (E × O) → E → Nat, read from the course so far. `seeking_keeps_order` (l. 187): for every choose, if every experiment ties h₁ and h₂ and prior h₁ \< prior h₂, then for any record weighing something, h₂'s posterior share is not at most h₁'s. B: `Agree.seeking_turns_tails` (l. 349): with the policy `pickReading` choosing the experiment that reads both tosses, the order is turned.
- **a reading**
  - *pass a:* S: `posterior_le_iff_prior` (l. 90) equates weak posterior order with weak prior order for a tied listed pair, distinct listing and positive record mass under the pair.
  - *pass b:* S: `Tied` (l. 69): a likelihood ties h₁ and h₂ when its weights agree at every outcome. `order_kept` (l. 151): under a tie with prior h₁ \< prior h₂, no record weighing something brings h₁'s share up to h₂'s. What the likelihood registers decides what can be corrected. B: `Agree.agreeing` (l. 247) reads only whether two tosses agree. `Agree.turns_fair` (l. 275) and `Agree.keeps_tails` (l. 288) hold under the record twoHeads.
- **a share**
  - *settled by the third pass:* S for the share, N for a rule set again from it: `posterior_le_iff_prior` (l. 90): for hypotheses listed once, a pair `Tied lik h₁ h₂` and `0 < mass os (lik h₁) rec`, the share of h₁ given the record is `.le` h₂'s iff `prior h₁ ≤ prior h₂`; `posterior_ratio_kept` (l. 127). In `seekWeight` (l. 168) the choice `choose : List (E × O) → E → Nat` reads the course so far, not the shares, so the field's second half is not met. [which pass was right: both in part; opened: l. 69, 72, 90, 127, 151, 168, 175, 187.]
  - *pass a:* N: Posterior shares are compared, but no subsequent favouring rule is reset from their relative shares.
  - *pass b:* S: the posterior `share` of a hypothesis given a record. `posterior_le_iff_prior` (l. 90): for a tied pair, h₁'s share ≤ h₂'s iff prior h₁ ≤ prior h₂. `posterior_ratio_kept` (l. 127): the shares stand as the prior weights. N for a rule set again from the share: the choice `choose` reads the course, not the shares.
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
  - *pass a:* S: `seeking_keeps_order` (l. 187) concludes that no policy corrects the strict wrong prior order under its all-experiment tie, distinct listing, membership and positive-mass premises. The obstruction is the experiment family.
  - *pass b:* S: `seeking_keeps_order` (l. 187) and `order_kept` (l. 151): an order tied under every experiment is corrected by no record and no course of seeking, whatever the policy. This is concluded from the premise that every experiment ties the pair. It concerns an order of hypotheses, not a loss of a level or of something that gives.
- **both outcomes**
  - *settled by the third pass:* B: `Agree.turns_fair` (l. 275) and `Agree.keeps_tails` (l. 288): in the one built model (`prior`, `agreeing`, record `twoHeads`) the share of heads is not `.le` fair's, and the share of tails is not `.le` heads'; one wrong prior order turned and one kept. Two theorems, no exactly-when; pass b's B clause names the same pair. (`seeking_keeps_tails` l. 305 and `seeking_turns_tails` l. 349 are of two different experiment sets.) [which pass was right: a; opened: l. 232, 247, 261, 275, 288, 305, 319, 334, 339, 349.]
  - *pass a:* B: `Agree.turns_fair` (l. 275) and `Agree.keeps_tails` (l. 288) show one wrong prior order reversed and another retained on the same two-heads record.
  - *pass b:* N: no exactly-when of going on and ending. B (of keeping or turning a wrong order, in one model under one record): `Agree.turns_fair` (l. 275) with `Agree.keeps_tails` (l. 288), and `Agree.seeking_keeps_tails` (l. 305) with `Agree.seeking_turns_tails` (l. 349).
- **a comparison between two**
  - *pass a:* S: `posterior_ratio_kept` (l. 127) transports prior proportions to posterior numerators by cross multiplication for any tied pair in a distinct list.
  - *pass b:* S: `seek_tied` (l. 175): if every experiment ties h₁ and h₂, then seekWeight is equal under h₁ and h₂ for every course and every choose. The tie is carried from each experiment to every course. `tied_mass` (l. 72): tied hypotheses give every record one weight. Both are between two hypotheses, not two processes.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *settled by the third pass:* S (weaker): `seek_tied` (l. 175): where every experiment ties h₁ and h₂ (`∀ e, Tied (lik e) h₁ h₂`), for any `choose` and every course, `seekWeight choose lik h₁ course = seekWeight choose lik h₂ course`. An equality kept over every finite list of steps; there is no step relation, process or set of configurations stated closed. [which pass was right: both in part; opened: seekWeight l. 168; seek_tied l. 175; seeking_keeps_order l. 187; tied_mass l. 72.]
  - *pass a:* S: `seek_tied` (l. 175) shows equal likelihood weights under the two tied hypotheses for arbitrarily extended finite courses.
  - *pass b:* N: the tie kept over every course (`seek_tied` l. 175, by induction on the course) is the nearest thing, an equality kept at every course, not a region closed under steps.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N. D: the account's Readings (l. 45-46) say a lumping is changed only by what couples in from beyond the model, a new likelihood or hypothesis (`mass_absent`, in ConditionalWeights, not stated here).
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and the docstrings. General statements — states, moves, reading, no_return, comparison, closed_region. Built cases — both_outcomes. Not found — share, level, giving, cost, multiplying, rank, forms_change. No commentary-only answers. All questions were reached.
  - *pass b:* All statements and docstrings read to the end (l. 366). moves, reading, share, no_return and comparison are answered from statements, with built cases in Agree; forms_change from the account only; the rest are N.
