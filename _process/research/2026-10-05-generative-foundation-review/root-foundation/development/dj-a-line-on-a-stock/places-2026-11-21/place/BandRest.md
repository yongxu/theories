# BandRest

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/BandRest.lean`
- *result records that name this place's file as a source* (computed; not a link): `where-a-run-turns`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-01, as "BandRest.lean: keeps_one_way, rests_on_band" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-01.md.txt)); pass b: reader whole-b-02, as "BandRest.lean: keeps_one_way, rests_on_band" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-02.md.txt)); the third pass, where the two differed: reader whole-c-settle-01, as "BandRest.lean: settled fields no_return" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-01.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* For any relation preserved by a successor, a first step in the relation puts every consecutive orbit pair in it (`keeps_one_way`, l. 36). A monotone self-map on the natural levels up to hi brings every orbit starting there to rest by hi (`rests_on_band`, l. 48).
  - *pass b:* Both laws are general. keeps_one_way: for every relation rel and step g that keeps it, a run whose first step stands in rel has every consecutive pair in rel. rests_on_band: for every g : Nat → Nat that keeps order on the band up to hi and keeps the band, every run from x ≤ hi is still from some step N ≤ hi.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: g is a determined law, with no choice among steps.
- **a reading**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* D: The opening account names giving that rises with what is left as an application in RegimeMargin; the local successor g is arbitrary subject to order and band preservation.
  - *pass b:* S: `rests_on_band` (l.48): whole-number levels up to hi, g monotone on the band (a ≤ b ≤ hi → g a ≤ g b) and keeping it (y ≤ hi → g y ≤ hi). The run moves one way, rising or falling, and comes to rest. g is any function of the level, so what comes next depends on what the level is. D: the account (l.17) says RegimeMargin.rests_within is the case of the regime's step under giving that rises with what is left, derived from this law.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: g is handed in.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *settled by the third pass:* S (different form): `rests_on_band` (l.48): for `g : Nat → Nat` with `mono : ∀ a b, a ≤ b → b ≤ hi → g a ≤ g b`, `keeps : ∀ y, y ≤ hi → g y ≤ hi` and `x ≤ hi`, `∃ N, N ≤ hi ∧ LastChange.StillFrom (Law.run g x) N`; `keeps_one_way` (l.36): a step that keeps `rel` and a first step in `rel` give `rel (orbit n) (orbit (n + 1))` for every n. Stillness for ever from some N ≤ hi, and never turning, are concluded. Neither is stated as something lost and not regained, or as a point from which no course keeps something. [which pass was right: both in part; opened: keeps_one_way l.36, rests_on_band l.48 (whole module)]
  - *pass a:* S: `rests_on_band` (l. 48) concludes permanent stillness from some N ≤ hi given order preservation, band preservation and a start in the band.
  - *pass b:* N: coming to rest (LastChange.StillFrom) is not stated as a loss or an irreversibility.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the rising and falling cases are split inside the proof; the statement has one conclusion.
- **a comparison between two**
  - *pass a:* S: `keeps_one_way` (l. 36) propagates the relation between a start and the start one step later to every subsequent adjacent orbit pair when g preserves the relation.
  - *pass b:* S: `keeps_one_way` (l.36): where ∀ a b, rel a b → rel (g a) (g b) and rel x (g x), then for every n, rel (orbit g x n) (orbit g x (n+1)). This is an order kept by the step. The docstring says it is Lasting.orbit_mono with the second run started one step later.
- **a rank (an ending within a bound)**
  - *pass a:* S: `rests_on_band` (l. 48) bounds the start of stillness by hi under its monotonicity and band premises.
  - *pass b:* S: `rests_on_band` (l.48): ∃ N, N ≤ hi ∧ LastChange.StillFrom (Law.run g x) N. The docstring says within hi - x steps where the first step does not lower the level, and within x where it does not raise it.
- **a closed region**
  - *pass a:* S: `rests_on_band` (l. 48) assumes g preserves the band and concludes eventual stillness within the bound.
  - *pass b:* S: `rests_on_band` (l.48) takes the band {y ≤ hi} closed under g as a premise (keeps). `keeps_one_way` (l.36): its docstring says it restates the closure law Invariant.reach on the region {x | rel x (g x)}.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* Read the opening account, all docstrings and all declaration statements. Statements support states and no_return, comparison, rank, closed_region. Only the account or docstrings supply level. The remaining fields are N. None were unreached.
  - *pass b:* All statements and docstrings (80 lines, two theorems). All fields were answered from statements, with the account's reading added under level. None was left unreached.
