# AttractionRuns

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/AttractionRuns.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-01, as "AttractionRuns.lean: returning_invariant, drawn_iff_lost, captured_rule_drawn" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-01.md.txt)); pass b: reader whole-b-02, as "AttractionRuns.lean: returning_invariant, drawnInto_returning, drawn_iff_lost, drawn_not_keeps, lossless_iff_none_drawn, merges_draws, captured_rule_invariant, captured_state_drawn, captured_rule_drawn" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-02.md.txt)); the third pass, where the two differed: reader whole-c-settle-01, as "AttractionRuns.lean: settled fields comparison, rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-01.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* For the process of any total successor law, the returning states are invariant (`returning_invariant`, l. 49). With a list covering every state, a state is necessarily drawn exactly when it fails to be reachable at every length (`drawn_iff_lost`, l. 73).
  - *pass b:* It restates Attraction's laws for the process of a determined law (Law.process next), in Branching's terms: what returns is invariant (returning_invariant), and within finitely many configurations every run from what does not return enters what returns, with necessarily drawn ⇔ lost and lossless ⇔ none drawn. A merge draws something, in double-negation form. These are general for determined laws; the ratchet, Captured, succ and pred are built cases.
- **moves**
  - *pass a:* N: The general results here use `Law.process next`, with a fixed successor. `returning_invariant` (l. 49) states closure for that process.
  - *pass b:* N: the process is Law.process next, with one trivial move, so there is no choice among steps. The statements quantify over every run (Branching.NecessarilyDrawnInto), for example `drawnInto_returning` (l.61). D: the account (l.15-16, l.23-24) says several of these laws fail for branching processes, citing Branching.Transit.returning_not_invariant and Branching.OneWay.merge_keeps, which are not stated here.
- **a reading**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
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
  - *pass a:* S: `drawnInto_returning` (l. 61) assumes nonreturn and concludes necessary entry into the returning region under finite coverage. B: `captured_rule_drawn` (l. 162) concludes nonreturn of the perturbed configuration.
  - *pass b:* S: `drawnInto_returning` (l.61): with every configuration listed and s not returning, every run of Law.process next from s is necessarily drawn into Returns. This is concluded. B: `ratchet_false_never_returns` (l.132); `ratchet_false_lost` (l.136); `captured_state_drawn` (l.153) and `captured_rule_drawn` (l.162): every run from a configuration whose state or rule was perturbed enters the configuration the rule holds, and the perturbed configuration never returns. None of these is a level or a loss of what gives.
- **both outcomes**
  - *pass a:* S: `drawn_iff_lost` (l. 73) identifies necessary attraction with negation of reachability at every length for a list-covered successor process.
  - *pass b:* S: `drawn_iff_lost` (l.73): with configurations listed, NecessarilyDrawn (Law.process next) s ⇔ ¬ ∀ n, Reachable n s. `lossless_iff_none_drawn` (l.91), with decidable equality: Lossless ⇔ nothing necessarily drawn. These are general for determined laws on a finite list, and concern keeping or losing a configuration, not going on or ending.
- **a comparison between two**
  - *settled by the third pass:* N: opened `merges_draws` (l.102): `Branching.Merges (Law.process next) → ¬ ¬ ∃ s, Branching.NecessarilyDrawn (Law.process next) s`. It is of one process and concludes that something is drawn; it carries nothing between two processes, two starts or two ways. Every statement of the module names only `Law.process next`; the transport from `Law.*` to `Branching.*` (`Branching.law_drawn_iff` and others) is used in the proof terms and stated in Branching. Also opened `drawn_iff_lost` (l.73), `lossless_iff_none_drawn` (l.91), `returning_invariant` (l.49). [which pass was right: b; opened: returning_invariant l.49, drawnInto_returning l.61, drawn_iff_lost l.73, drawn_not_keeps l.82, lossless_iff_none_drawn l.91, merges_draws l.102, succ_drawn_lossless l.111, pred_drawn_keeps l.119]
  - *pass a:* S: `merges_draws` (l. 102) derives, under double negation, some necessarily drawn start from merging in a successor-law process.
  - *pass b:* N: no statement here carries something between two processes. The transport from law to process (Branching.law_drawn_iff and others) is used in the proofs and stated in Branching. `merges_draws` (l.102) concerns two merged configurations, in double-negation form only.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* B (weak): `ratchet_false_lost` (l.136): `¬ Branching.Reachable (Law.process Ratchet.next) 1 false`: in the ratchet's process `false` cannot be had one step on. A loss placed at one step in a built case. No general law of ending within a bound: `drawnInto_returning` (l.61), under a list holding every configuration, gives `NecessarilyDrawnInto … (Returns …) s`, which is some n for each run with no bound stated, and no variant falls. [which pass was right: both in part; opened: ratchet_false_lost l.136, ratchet_false_never_returns l.132, ratchet_merges l.128, drawnInto_returning l.61, drawn_iff_lost l.73; Branching.NecessarilyDrawnInto l.365]
  - *pass a:* B: `ratchet_false_lost` (l. 136) gives loss of reachability of false at length one.
  - *pass b:* N: drawnInto_returning gives some step n, with no bound stated here.
- **a closed region**
  - *pass a:* S: `returning_invariant` (l. 49) proves invariance of returning states in every successor-law process. B: `captured_rule_invariant` (l. 146) proves invariance of each Boolean rule value.
  - *pass b:* S: `returning_invariant` (l.49): for every next, Branching.Returns (Law.process next) is Invariant under Law.process next. B: `captured_rule_invariant` (l.146): the configurations with a given rule are invariant under the captured process.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* Read the opening account, all docstrings and all declaration statements. Statements support states and no_return, both_outcomes, comparison, closed_region. Built statements supply no_return, rank, closed_region. The remaining fields are N. None were unreached.
  - *pass b:* All statements and docstrings (170 lines). All fields were answered from statements; the moves field adds the account's pointer to branching counterexamples. None was left unreached.
