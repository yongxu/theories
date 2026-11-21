# WeightedCommuting

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/WeightedCommuting.lean`
- *result records that name this place's file as a source* (computed; not a link): `a-commuting-learner-drives-no-unread-choice`
- *dynamics in the atlas that name one of those records* (computed; not a link): `what-a-commuting-law-keeps-apart`, `what-an-optimum-does-beyond-what-couples-in`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-20, as "WeightedCommuting.lean: Commutes.carried, Commutes.of_samples, Reinforcing.oneSided, Pooling.share_rises" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-20.md.txt)); pass b: reader whole-b-79, as "WeightedCommuting.lean: Weighted.Commutes, Commutes.carried, Commutes.fixed_expect, Commutes.start_expect, Commutes.of_samples, law_commutes, Reinforcing.commutes, Reinforcing.expect_equal, Reinforcing.oneSided, Pooling.share_rises, Pooling.share_below_half" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-79.md.txt)); the third pass, where the two differed: reader whole-c-settle-29, as "WeightedCommuting.lean: settled fields closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-29.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Weighted.Commutes.carried` (l. 90) transports every finite-horizon weighted expectation across any map commuting with the finite-successor law. `Commutes.start_expect` (l. 107) gives equal expectations for an observable and its image when the starting weights are unchanged by the map.
  - *pass b:* S: For any weighted law K : S → List (W × S) commuting with a map σ, the expectation of any observable n steps on from σ x equals the expectation of the observable read through σ from x (Commutes.carried). The same holds from σ-fixed configurations or σ-unchanged starting weights, and a learner drawing weighted samples and updating commutes with σ under stated conditions (Commutes.of_samples). These are general, with the built witnesses Reinforcing and Pooling on two counts.
- **moves**
  - *pass a:* B: `Reinforcing.law` (l. 170) gives two weighted successors, each increasing the count drawn. `Reinforcing.oneSided` (l. 204) proves positive weight for choosing the second every time for any finite horizon from (1,1).
  - *pass b:* S: A weighted law K (l. 78) gives finitely many weighted successors. Commutes.of_samples (l. 150): a law drawing samples ωs with weight P x ω and moving by update U commutes with σ where τ permutes the samples, P (σ x) ω = P x (τ ω) and U (σ x) ω = σ (U x (τ ω)). Commutes.carried (l. 90): the expectation is kept under σ.
- **a reading**
  - *pass a:* S: `Commutes.of_samples` (l. 150) obtains commutation when the sample map preserves every sample total and the state exchange carries sample weights and updates as specified. `Commutes.fixed_expect` (l. 97) then equates readings of an observable and its image from an exchange-fixed start.
  - *pass b:* D: Only the opening account's 'Reading (AI)' says the law reads a choice that neither the reward nor the dynamics reads. No statement about a reading was found.
- **a share**
  - *pass a:* B: `Reinforcing.law` (l. 170) sets the two next draw weights from their current counts and increments the drawn count. Pooling.run_counts, share_rises and share_below_half (ll. 218, 225, 237) give a different update where the smaller share rises but stays below half.
  - *pass b:* B: Reinforcing.law (l. 170): draw a value with weight equal to its count and add one to the value drawn, a rule set again from the counts. Pooling.share_rises (l. 225) and share_below_half (l. 237): from counts 3 and 1, the share of the less-drawn value, (1+k)/(4+2k) stated cross-multiplied, rises at every step and stays below one half.
- **a level that runs down**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a giving that is itself a going-on**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* B: `Reinforcing.law` (l. 170) increases the count of the kind drawn by one and leaves the other count fixed, with the draw weighted by the current count. The representation stores counts only.
  - *pass b:* B: Reinforcing.law (l. 170): the drawn value's count grows by one each step. oneSided (l. 204): from (1,1), drawing the second value n times has positive weight and ends at (1, 1+n). Pooling.run_counts (l. 218): the counts are 3+k and 1+k. These are counts of values, not units leaving units.
- **a point of no return**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *pass a:* N: `Reinforcing.expect_equal` (l. 180) and `oneSided` (l. 204) concern aggregate symmetry and a positive-weight history, without a persistence/extinction dichotomy.
  - *pass b:* N
- **a comparison between two**
  - *pass a:* S: `Commutes.carried` (l. 90) equates expectation from σx to expectation from x with the observable composed with σ, at each horizon given Commutes K σ.
  - *pass b:* S: Commutes.carried (l. 90) carries the expectation between the start σ x and the start x. start_expect (l. 107) does the same for starting weights. law_commutes (l. 120): a deterministic Law.Commutes law commutes as a weighted law.
- **a rank (an ending within a bound)**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a closed region**
  - *settled by the third pass:* B (weaker): `Pooling.run_counts` (l. 218): `(Law.run step (3, 1)).state k = (3 + k, 1 + k)` for every k, with `Pooling.share_below_half` (l. 237): `2 * (1 + k) < (3 + k) + (1 + k)` for every k, an inequality of numbers that does not name the run. Together they give, on the one run from (3, 1), that the second count stays below half the total at every step; neither says that a set of configurations is kept by `step`. The general `Commutes.fixed_expect` (l. 97: with `Commutes K σ` and `σ x = x`, `expect K n f x = expect K n (fun y => f (σ y)) x` for every n and f) is an equality of expectations from a configuration σ fixes, not a region closed under steps. [which pass was right: both in part; opened: expect (l. 78), Commutes (l. 84), Commutes.carried (l. 90), Commutes.fixed_expect (l. 97), Unchanged (l. 102), Commutes.start_expect (l. 107), Reinforcing.expect_equal (l. 180), Reinforcing.oneSided (l. 204), Pooling.step (l. 212), Pooling.commutes (l. 215), Pooling.run_counts (l. 218), Pooling.share_rises (l. 225), Pooling.share_below_half (l. 237); variables at ll. 57, 87.]
  - *pass a:* B: Pooling.run_counts and share_below_half (ll. 218, 237) keep the second share strictly below half throughout the specified run. `Reinforcing.expect_equal` (l. 180) gives equality in expectation from equal counts.
  - *pass b:* N: fixed_expect (l. 97) is about a configuration fixed by σ, not a region closed under steps.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N: B (not of the asked kind): Pooling.share_rises (l. 225): the asymmetry of the start wears away while the law commutes; no kinds come or go.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, reading, comparison. Named cases contribute to moves, share, multiplying, closed_region. No answer relies on prose alone. The remaining questions are N, and I reached all fourteen.
  - *pass b:* Every statement and docstring and the opening account were read; moves and comparison are answered from statements, share and multiplying from built cases, reading from the account only, and the rest are N.
