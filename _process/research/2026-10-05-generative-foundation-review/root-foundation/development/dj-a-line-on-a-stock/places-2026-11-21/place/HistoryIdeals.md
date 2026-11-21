# HistoryIdeals

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* several Lean files of this name: `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HistoryIdeals.lean`; `experiments/integrated-correction/general-framework/generative-basis/mathematical-abstraction/completion/formal/HistoryIdeals.lean`
- *result records that name a file of this name as a source* (computed; not a link), by file: `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HistoryIdeals.lean`: `a-history-read-off-its-finite-stretches`, `what-a-finite-stretch-verifies`; `experiments/integrated-correction/general-framework/generative-basis/mathematical-abstraction/completion/formal/HistoryIdeals.lean`: `a-history-read-off-its-finite-stretches`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-07, as "HistoryIdeals.lean: Run.stretches_le_iff, Stretches.classification, Stretches.cut_decided_iff_lpo, Stretches.closed_runs" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-07.md.txt)); pass b: reader whole-b-26, as "HistoryIdeals.lean: Run.stretches_le_iff, closed_iff_within_lower, refutable_holds_iff, Stretches.adheres_iff_closed, Stretches.classification, cut_decided_iff_lpo, history_le_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-26.md.txt)); the third pass, where the two differed: reader whole-c-settle-10, as "HistoryIdeals.lean: settled fields no_return, rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-10.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `history_le_iff` (l. 315) identifies inclusion of word-history ideals with the prefix order for finite and infinite histories. For every process, `Stretches.classification` (l. 867) gives a principal finite history or a run's ideal given a latest stretch or a supplied pick beyond every horizon.
  - *pass b:* S, general for every process: a run is read as the ideal of its stretches. Refutability and adherence of readings of runs are cases of the laws of ideals: adhering is the least Scott-closed class, and a closed reading is made of tests, one per stretch. For every process, refutable and closed coincide exactly under double-negation elimination. An ideal that settles, or goes on with picks, is a finite history or a run (`Stretches.classification`, l. 867), and deciding settling against going on is exactly LPO (`cut_decided_iff_lpo`, l. 478 and l. 914). The same holds for words of any type ordered by prefix.
- **moves**
  - *pass a:* S: `Stretches.mem_act` (l. 817) says two stretches belonging to one ideal take the same action at each index strictly before both horizons, and `Stretches.pickedRun` (l. 842) constructs a legal run from member stretches picked beyond each horizon.
  - *pass b:* S: stated for every `Process` P through `stretchOrder P` and its runs. No law says what some choice or every choice keeps.
- **a reading**
  - *pass a:* S: `Stretches.run_reading_unique` (l. 767) equates two continuous readings at every run, up to target equivalence, if both agree on finite histories with the same monotone stretch reading into a directed-complete order.
  - *pass b:* S: `adheres_iff_hull` (l. 134). `closed_iff_within_lower` (l. 145): a reading that holds every run adhering to it is the reading of the runs whose stretches lie in one lower set. `refutable_holds_iff` (l. 159): for every process, a refutable reading holds at every run adhering to it exactly under double-negation elimination. `Stretches.run_reading_unique` (l. 767): a continuous reading is fixed at every run by its values on finite histories. `Stretches.runs_told_apart` (l. 780): finite stretches tell runs apart.
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
  - *settled by the third pass:* N: opened `Stretches.cut` (l. 885), `Stretches.cut_hasLatest_iff` (l. 893), `Stretches.cut_decided_iff_lpo` (l. 914), `HistoryIdeals.cut` (l. 452), `Run.stretches_not_principal` (l. 124), `Stretches.hasLatest_principal` (l. 831). `Stretches.cut s` is a def whose `mem e` is `∀ m, m < e.2 → s m = false`; that a `true` at k shuts out every horizon above k follows by unfolding it, and is used in the proof of `cut_decided_iff_lpo`, but no theorem states it. What is stated is settling or going on (`HasLatest (cut s) ∨ GoesOn (cut s)` for every s exactly when `LPO`): an ending of a built history, not a loss that is not regained. [which pass was right: b; opened: Stretches.cut l.885; cut_hasLatest_iff l.893; cut_goesOn_iff l.903; Stretches.cut_decided_iff_lpo l.914; HistoryIdeals.cut l.452; Run.stretches_not_principal l.124; hasLatest_principal l.831; section variable l.583 {P : Process S A}]
  - *pass a:* B: `Stretches.cut` (l. 885) admits a stretch only when every Boolean value strictly before its horizon is false. A true at k permanently excludes every horizon greater than k from this cut history.
  - *pass b:* N: `Run.stretches_not_principal` (l. 124) says that no run's ideal is a finite history. That is not an irreversibility.
- **both outcomes**
  - *pass a:* S: `Stretches.classification` (l. 867) concludes finite or infinite under the explicit latest-or-picked premise. `Stretches.cut_decided_iff_lpo` (l. 914) proves the assertion that every Boolean cut settles or goes on is equivalent to LPO.
  - *pass b:* S: `HistoryIdeals.cut_decided_iff_lpo` (l. 478) and `Stretches.cut_decided_iff_lpo` (l. 914): every cut history of the process of `()`s either settles (ends) or goes on exactly when LPO holds. `Stretches.classification` (l. 867), for every process: given that a history settles or goes on with picks, it is a finite history or the history of a run. `Stretches.refutable_closed_iff` and `closed_refutable_iff` (l. 665, l. 695) are iff statements of logical principles.
- **a comparison between two**
  - *pass a:* S: `Run.stretches_le_iff` (l. 119) equates inclusion of two runs' ideals with their agreement at every horizon. `Stretches.within_order_iff` (l. 744) retains the criterion upon restriction to a lower set containing both histories.
  - *pass b:* S: `Run.stretches_le_iff` (l. 119): one run's ideal is below another's exactly when they agree at every horizon. `history_le_iff` (l. 315) and `historyIdeal_same_iff` (l. 330). `Stretches.within_order_iff` (l. 744). `Stretches.refutable_of_class` (l. 590): refutability is carried from classes of histories to runs. `Stretches.histories_representation` (l. 797): a unique order equivalence with every completion.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* S (weak, general): `HistoryIdeals.principal_hasLongest` (l. 424): for every word w, `HasLongest (Ideals.principal (prefixOrder A) w)`, where `HasLongest I` (l. 346) is `∃ w, I.mem w ∧ ∀ v, I.mem v → v.length ≤ w.length`; likewise `Stretches.principal_hasLatest` (l. 876) for `Run P × Nat`, every process P. B: `HistoryIdeals.cut` (l. 452) is a def with `mem w := ∀ m, m < w.length → s m = false`; the bound k where `s k = true` is in the def and in the proof of `cut_decided_iff_lpo` (l. 478), whose statement is only `(∀ s, HasLongest (cut s) ∨ GoesOn (cut s)) ↔ LPO`. No rank or variant that falls and no deadline of a process is stated. [which pass was right: both in part; opened: HasLongest l.346; GoesOn l.350; hasLongest_principal l.354; classification l.414; principal_hasLongest l.424; cut l.452; least_true_or_below l.461; cut_decided_iff_lpo l.478; length_le_of_le l.186; Stretches.principal_hasLatest l.876]
  - *pass a:* B: `HistoryIdeals.cut` (l. 452) bounds admitted word lengths by k if the supplied sequence is true at k. This bound belongs to the cut construction.
  - *pass b:* N
- **a closed region**
  - *pass a:* S: `closed_iff_within_lower` (l. 145) characterizes readings containing every adherent run by their being the runs within some lower set of stretches. `Stretches.adheres_iff_closed` (l. 600) gives the least Scott-closed history class on runs.
  - *pass b:* S: `Stretches.adheres_iff_closed` (l. 600) and `adherence_unique` (l. 610): adhering is the least Scott-closed class of histories. `Stretches.closed_runs` (l. 639). `Stretches.avoids_adheres` (l. 713): avoiding a set of stretches is closed with no double negation. These are closed in the order of stretches, not closed under the steps of a process.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `Stretches.run_goesOn` (l. 880) says only that a run's history goes on. Nothing in the module says that what is present changes.
- **how it was read**
  - *pass a:* S: I read the opening account, all statements and their docstrings. General statements cover states, moves, reading, both_outcomes, comparison, closed_region. Built cases cover no_return, rank. I found no matching claim for share, level, giving, cost, multiplying, forms_change. I reached all fourteen questions.
  - *pass b:* All 14 answered from statements; all statements read, lines 1-966 in two parts.
