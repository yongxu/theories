# PartialReadout

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PartialReadout.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-13, as "PartialReadout.lean: exact_exists_iff, SoundWithin.silent, ExactWithin.retained" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-13.md.txt)); pass b: reader whole-b-48, as "PartialReadout.lean: ExactWithin.sound, ExactWithin.lumped, exact_exists_iff, SoundWithin.silent, ExactWithin.retained, LumpedWithin.finer, signal_sound_silent, paired_exact, Runs.exact_iff_predictsFrom" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-48.md.txt)); the third pass, where the two differed: reader whole-c-settle-18, as "PartialReadout.lean: settled fields moves" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-18.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For any domain with a supplied section, an exact partial decoder exists exactly when configurations merged by the map have equal feature values (l. 126). Every sound decoder must return none on a reading that merges two different feature values in its domain (l. 133).
  - *pass b:* These are general laws of partial decoders judged on a domain. An exact decoder is sound and needs the feature lumped by the map. With a section of the map, some exact decoder exists exactly where the feature is lumped, and a sound decoder stays silent where the map merges two feature values. A built channel model is a countermodel: the signal alone has no exact and only silent sound readings, and paired with a reference it is read exactly. The laws are restated on run prefixes, with exactness at every step from T equal to prediction from T along a determined law.
- **moves**
  - *settled by the third pass:* N for the law: the section `Runs.AnyProcess` has `variable {P : Process S A}`, and `Runs.prefixBefore` (l.262), `finer_lumped` (l.269), `silent_sound` (l.275), `silent_not_exact` (l.280) are stated for runs of any such process; `exact_iff_predictsFrom` (l.292) is for runs of `Law.process next`. So a process with moves is the carrier of the runs, but every statement is about a decoder on prefixes of runs (`SoundWithin`, `ExactWithin`, `LumpedWithin`); none says what some choice or every choice of move keeps. The two passes describe the same statements and differ only in the letter. [which pass was right: both in part; opened: Runs.prefixBefore l.262, featureAt l.266, finer_lumped l.269, silent_sound l.275, silent_not_exact l.280, exact_iff_predictsFrom l.292]
  - *pass a:* N: `Runs.silent_sound` (l. 275) treats runs of an arbitrary process, but its guarantee concerns a silent decoder on those runs. No keeping law for choices of move was found.
  - *pass b:* S, but nothing about choices: the run laws are stated for runs of any `Process S A` (`Runs.prefixBefore` l. 262, `Runs.silent_sound` l. 275), and `Runs.exact_iff_predictsFrom` (l. 292) for runs of `Law.process next`. N: no law about what some choice or every choice keeps.
- **a reading**
  - *pass a:* S: `SoundWithin.silent` (l. 133) forces silence on the shared observation of two in-domain states with different features, assuming soundness.
  - *pass b:* S: `exact_exists_iff` (l. 126): given a section of π over D, some decoder exact within D exists exactly where f is lumped within D. `SoundWithin.silent` (l. 133): a sound decoder is silent at π s where s, s' in D have π s = π s' and f s ≠ f s'. `ExactWithin.lumped` (l. 83). B: `signal_sound_silent` (l. 228): every sound reading of the signal alone is silent on both values. `paired_exact` (l. 213).
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
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N for going on and ending, or keeping and losing. The only exact-when laws are about readings (`exact_exists_iff` l. 126, `Runs.exact_iff_predictsFrom` l. 292).
- **a comparison between two**
  - *pass a:* S: `ExactWithin.retained` (l. 155) transfers exactness through retention when reading back recovers each in-domain observation. `LumpedWithin.finer` (l. 149) preserves lumping on adjoining another map.
  - *pass b:* S: `ExactWithin.retained` (l. 155): exactness carries through a retention read back faithfully on D. `LumpedWithin.finer` (l. 149): lumping carries to the map paired with a second map. `SoundWithin.mono` (l. 143): soundness carries to every smaller domain. `Runs.finer_lumped` (l. 269) on prefixes.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: Read the opening account, every declaration statement and its docstring. Statements — states, reading, comparison. Not found — moves, share, level, giving, cost, multiplying, no_return, both_outcomes, rank, closed_region, forms_change. No answer rests on commentary alone or was left unreached.
  - *pass b:* All statements read (whole module, l. 1–304). Answered from statements: reading, comparison, moves (part). The other questions were N after all statements were read.
