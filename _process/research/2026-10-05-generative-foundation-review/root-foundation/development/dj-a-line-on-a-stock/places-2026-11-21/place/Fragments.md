# Fragments

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Fragments.lean`
- *result records that name this place's file as a source* (computed; not a link): `unanchored-incidence-collapse`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-05, as "Fragments.lean: Fragment.merge_traced, Fragment.same_probes_iff_ends, Fragment.readJoint_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-05.md.txt)); pass b: reader whole-b-18, as "Fragments.lean: Fragment.same_probes_iff_ends, joint_iff_probes, readJoint_iff, joined_assoc, probes_miss_course, passage_not_self_joint" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-18.md.txt)); the third pass, where the two differed: reader whole-c-settle-07, as "Fragments.lean: settled fields both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-07.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Fragment.merge_traced` (l. 75) preserves tracehood under joining and `joined_assoc` (l. 101) makes joining associative for any process. `same_probes_iff_ends` (l. 151) identifies agreement on all idle probes of two traces exactly with equal endpoints.
  - *pass b:* General for every `Process S A`: fragments (start, course, finish) that are traced join where the first finishes where the second starts; joining is functional and associative, keeps fragments traced, and has the idle fragment as identity. Read through probes, two traced fragments answer alike exactly where their ends agree (`same_probes_iff_ends`), the probes recover joining (`joint_iff_probes`), and an exact presentation recovers it from codes (`readJoint_iff`). Built: `once` and `loops`.
- **moves**
  - *pass a:* S: `Fragment.merge_traced` (l. 75) realizes the concatenated word of moves whenever the two traced fragments join.
  - *pass b:* S: `Fragment.Traced` (l. 46) is a core `Trace` of a `Process S A`. `merge_traced` (l. 75): two joining traced fragments, one after the other, are traced. `joined_assoc` (l. 101): joining is associative. N: no law about what some choice or every choice keeps.
- **a reading**
  - *pass a:* S: `Fragment.readJoint_iff` (l. 186) recovers joining from the two codes when the presentation is exact for endpoint probes. B: `probes_miss_course` (l. 238) gives distinct move words with identical answers.
  - *pass b:* S: `probes` (l. 145) reads a fragment by whether it joins before or after the idle fragment at each configuration. `same_probes_iff_ends` (l. 151): two traced fragments answer alike iff they start alike and finish alike. `joint_iff_of_same_probes` (l. 195): fragments answering alike join alike. `readJoint_iff` (l. 186): a presentation exact on the probes recovers joining from codes alone. B: `probes_miss_course` (l. 238): two loops by different moves answer every probe alike while their courses differ.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a point of no return**
  - *pass a:* B: `Fragment.once` (l. 207) has only the step from false to true; `passage_not_self_joint` (l. 217) proves its passage cannot follow itself.
  - *pass b:* B: `passage_not_self_joint` (l. 217): in the process `once` (false to true only), the passage cannot join itself, since it finishes where it does not start. This is built, not a general irreversibility law, and concerns no level or giver.
- **both outcomes**
  - *settled by the third pass:* N: opened `joint_iff_probes` (l. 167), `joint_iff_joined` (l. 65), `idle_joint_left` (l. 118), `idle_joint_right` (l. 124), `same_probes_iff_ends` (l. 151), `readJoint_iff` (l. 186), `joint_iff_of_same_probes` (l. 195), `passage_not_self_joint` (l. 217), `probes_miss_course` (l. 238). `joint_iff_probes` states, for every `P : Process S A` and fragments f, g, `Joint P f g ↔ ∃ s, probes P f (.after s) ∧ probes P g (.before s)`: an exactly-when of two traced fragments meeting end to start. Every iff of the module is of joining or of answering probes alike; none states going on and ending, or keeping and losing, of a course. [which pass was right: b; opened: the whole module (245 lines), every statement]
  - *pass a:* S: `Fragment.joint_iff_probes` (l. 167) characterizes when a given fragment can continue with another by a state satisfying the corresponding after and before probes.
  - *pass b:* N.
- **a comparison between two**
  - *pass a:* S: `Fragment.joint_iff_of_same_probes` (l. 195) transfers joining both ways between pairs of traced fragments with matching probe answers.
  - *pass b:* S: `joint_iff_of_same_probes` (l. 195): for traced f, f', g, g' with f, f' answering the probes alike and g, g' alike, `Joint P f g ↔ Joint P f' g'`, which carries joining between fragments read alike. N: no law between two processes.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the idle fragment is an identity for joining (`joined_idle_left` l. 129, `joined_idle_right` l. 134), but no invariant region was found.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statements — states, moves, reading, both_outcomes, comparison. Built cases — no_return. Not found — share, level, giving, cost, multiplying, rank, closed_region, forms_change. No answer rests on commentary alone; all questions were reached.
  - *pass b:* Every question was answered from statements (S, B or N). I read all statements and the opening account (245 lines).
