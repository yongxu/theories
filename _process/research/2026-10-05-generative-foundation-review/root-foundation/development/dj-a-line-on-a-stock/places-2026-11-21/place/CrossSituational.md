# CrossSituational

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/CrossSituational.lean`
- *result records that name this place's file as a source* (computed; not a link): `a-code-formed-between-formations`, `enacted-scene-binding`, `encounter-selection-and-revision`, `retrospective-source-binding`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-code-formed-between-formations`, `encounter-selection-and-revision`, `merged-distinctions-stay-merged`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-03, as "CrossSituational.lean: candidates_eq_iff, candidates_append, stays_iff, resolved_is_target, Omitted.wrong_unique" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-03.md.txt)); pass b: reader whole-b-12, as "CrossSituational.lean: candidates_eq_iff, resolves_iff, candidates_append, stays_iff, narrows, resolved_is_target, resolves_explained_iff, reads_every_iff, Omitted" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-12.md.txt)); the third pass, where the two differed: reader whole-c-settle-05, as "CrossSituational.lean: settled fields comparison, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-05.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `candidates_eq_iff` (l. 241) characterizes singleton resolution for a distinct repertoire with decidable equality by target availability, coverage on every bearing record and a separating bearing record for each rival. `candidates_append` (l. 281) makes further records filter earlier candidates, and `resolved_is_target` (l. 318) makes uniqueness correct under availability and coverage.
  - *pass b:* General laws, for every type of records and meanings and every Boolean reading of bearing (bears) and offering (offers): a form's candidates are exactly [e] when e is in a distinct repertoire, every bearing record offers e, and every rival is missing from some bearing record (candidates_eq_iff, resolves_iff); later records only narrow the candidates (candidates_append, narrows, stays_iff). Under coverage a unique candidate is the target (resolved_is_target); the law is lifted to a family of explaining worlds (resolves_explained_iff) and to reading every encoded sequence (reads_every_iff); Repeated and Omitted are built counter-cases.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no process, policy or allowed set of steps; records are a list, not moves.
- **a reading**
  - *pass a:* S: `candidates_snoc_bearing` (l. 291) filters by exactly what the new bearing record offers, and `candidates_snoc_other` (l. 297) leaves the list unchanged for a nonbearing record. `Omitted.wrong_unique` (l. 407) exhibits a wrong unique candidate when the target is uncovered.
  - *pass b:* S: `candidates_eq_iff` (l. 241): for a repertoire without repeats, the candidates are exactly [e] iff e is in it, every record bearing on the form offers e, and every other meaning fails to be offered by some bearing record. What is registered decides the resolution. `resolved_is_target` (l. 318): where the target is in the repertoire and every bearing record offers it, any unique candidate is the target. `reads_every_iff` (l. 365): where grouping recovers the words, reading every sequence gives the meanings exactly when each word's records separate its meaning. B: `Omitted.wrong_unique` (l. 407): one record omitting the target 0 leaves 1 as the only candidate.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no share or fraction, and no rule set again from one.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no stock or amount.
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
  - *pass a:* S: `narrows` (l. 303) concludes that any later candidate was an earlier candidate under record append. Once excluded, no further records restore the meaning for the same repertoire and reading.
  - *pass b:* S: `narrows` (l. 303): a meaning that is a candidate after rs ++ more was a candidate after rs, so a meaning ruled out stays ruled out. This is concluded, and it concerns the candidate list, not a level or a giver.
- **both outcomes**
  - *pass a:* S: `stays_iff` (l. 308) characterizes keeping a candidate exactly by earlier membership and every additional bearing record offering it. `stands_false_iff` (l. 202) witnesses failure by a bearing record omitting it.
  - *pass b:* S: `stays_iff` (l. 308): a candidate stays one after a further history exactly while every later bearing record offers it. General, and about keeping or losing candidacy, not about going on or ending.
- **a comparison between two**
  - *settled by the third pass:* N: `candidates_append` (l. 281) states `candidates bears offers rep (rs ++ more) = List.filter (stands bears offers more) (candidates bears offers rep rs)`, one history and its extension under one reading and one repertoire; `filter_congr` (l. 120) is a lemma on lists. Nothing is carried between two processes, two starts or two ways. Opened to rule it out: candidates_append, stands_append, narrows, stays_iff, resolves_explained_iff. [which pass was right: b; opened: candidates_append l. 281; stands_append l. 270; narrows l. 303; stays_iff l. 308; resolved_is_target l. 318; resolves_explained_iff l. 328]
  - *pass a:* S: `candidates_append` (l. 281) transports the prefix candidate list to the longer history by filtering, and `filter_congr` (l. 120) equates filtered lists for pointwise equal tests.
  - *pass b:* N: no law carrying something between two processes. `candidates_append` (l. 281) relates a history to its extension: the later candidates are the earlier ones filtered by `stands` on the added records.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: candidates only shrink (`candidates_append`), but no bound, variant or ending is stated.
- **a closed region**
  - *settled by the third pass:* S: `narrows` (l. 303): for fixed `bears`, `offers`, `rep`, if m ∈ candidates rep (rs ++ more) then m ∈ candidates rep rs, so the histories at which m is ruled out are closed under appending any further records; `stays_iff` (l. 308) gives the exact condition for staying a candidate. The step is appending records to a list; no `Process` is named. [which pass was right: a; opened: narrows l. 303; stays_iff l. 308; candidates_append l. 281; candidates_snoc_other l. 297]
  - *pass a:* S: `narrows` (l. 303) preserves the region of histories excluding a specified meaning under every append for fixed reading and repertoire.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statements (1, 3, 9, 10, 11, 13). Not found (2, 4, 5, 6, 7, 8, 12, 14). I reached all fourteen questions.
  - *pass b:* Answered from statements: reading, no_return, both_outcomes (and the note in comparison); the N answers come after reading every statement. Nothing answered from the account alone; all statements read (413 lines).

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge2-03

*As "CrossSituational.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge2-03.md.txt).*

- **an exact statement of both outcomes**: S: `stays_iff` (l. 308): `m ∈ candidates bears offers rep (rs ++ more) ↔ m ∈ candidates bears offers rep rs ∧ ∀ r, r ∈ more → bears r = true → offers r m = true`. Premises: none beyond the section's `{R : Type u} {M : Type v}` (l. 161) and `{bears : R → Bool} {offers : R → M → Bool}` (l. 180); `rep`, `rs`, `more`, `m` are implicit and arbitrary. The outcomes are staying a candidate and being ruled out after a further history of records, not a course going on and ending.
- **the side that keeps**: The keeping side only asserts membership after `rs ++ more`; it is not closed: it holds while every bearing record of `more` offers `m`, a condition on each further record. The closed side is the losing one: `narrows` (l. 303) states that `m ∈ candidates … (rs ++ more)` gives `m ∈ candidates … rs`, so a meaning ruled out stays ruled out under every append.
- **the side that ends**: N. On the losing side the statements say only that some bearing record does not offer the meaning (`stands_false_iff` l. 202) and that it is not a candidate later (`narrows` l. 303). `candidates_append` (l. 281) states that the later candidates are a filter of the earlier ones, but no length, count or bound is stated, and nothing says a form resolves within a number of records. Opened to rule it out: `candidates_append`, `candidates_snoc_bearing` (l. 291), `candidates_snoc_other` (l. 297), `narrows`, `resolves_iff` (l. 261).
- **moves in that statement**: N. `rs` and `more` are lists of records handed in and the statement holds of each; there is no process type, no policy and no allowed set. The only quantifier inside is `∀ r ∈ more`, over the records of the further history.
- **a reading in that statement**: S. The condition is wholly on the two Boolean readings of a record, `bears r` and `offers r m`; the records enter the statement only through them (`stands` l. 173 is `rs.all fun r => !bears r || offers r m`).
- **the carrier**: `candidates bears offers rep rs : List M` (l. 177), a filter of a repertoire `rep : List M` by `stands` over a list of records `rs : List R`; no `Process`, no step type.
- **what is handed in**: The readings `bears` and `offers`, the repertoire and both histories are handed in; no level, giving, share, favouring or turn occurs; concluded is only the equivalence (and in `narrows` that exclusion is kept).
- **links to other modules**: `reads_every_iff` (l. 365) names `chunks`, `encode` and `readAll` of Becoming.Segmentation and is the case of `Segmentation.reads_every_iff` (Segmentation.lean l. 350) with the reading `fun f => unique (candidates (bears f) offers rep rs)`, under the premises `Distinct rep` and `segments`. `candidates_eq_iff` (l. 241), `resolves_iff` (l. 261), `resolves_explained_iff` (l. 328) and `filter_eq_singleton_iff` (l. 112) name `Distinct` of Becoming.Prelude (l. 665) as a premise. No other statement names another module's declaration.
- **standing**: None seen. The account (l. 38-39) says no premise is added and every declaration has an empty axiom report; `[DecidableEq M]` is an instance premise of `candidates_eq_iff`, `resolves_iff`, `resolves_explained_iff` and `reads_every_iff`.
- **note**: An exact condition with a reading in it and no moves, where the irreversible side is the loss (`narrows`) and nothing is bounded: a closed region on the losing side and no rank on either. `Omitted.wrong_unique` (l. 407) is a built case where the unique candidate is not the target.
