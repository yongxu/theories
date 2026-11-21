# Contacts

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Contacts.lean`
- *result records that name this place's file as a source* (computed; not a link): `consequence-revised-reference-plan`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-02, as "Contacts.lean: selections_survive_iff, trace_keeps_of_retains, blind_misses" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-02.md.txt)); pass b: reader whole-b-07, as "Contacts.lean: through_data_iff, keeps_data_iff, keeps_iff_retains, selections_survive_iff, retired_loses, trace_keeps_of_retains, answers_iff, blind_answers_iff, blind_misses, finite_blind_answers, References.drives_iff, References.stays_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-07.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `selections_survive_iff` (l. 123) equates keeping every old Boolean selection with retaining every old contact, for plans on addresses with decidable equality. `blind_misses` (l. 171) gives a failed address that any blind revision rule misses at any plan if no list covers all addresses.
  - *pass b:* The module states, in general for addresses with decidable equality: a lumping through decided data selects the value at an address exactly where the address is in the data; a change of data or plan keeps every old selection exactly where it keeps every old contact; along every trace of any process whose steps keep contacts, every selection is kept. Also in general: a revision rule that does not read the failure answers every failure exactly where its plans contact every address, and where no list holds every address it leaves some failure unanswered at every plan; two reference responses drive a two-valued channel to both targets exactly when they differ. A built case with Bool addresses is given.
- **moves**
  - *pass a:* S: `trace_keeps_of_retains` (l. 135) keeps every old selection along every action trace when every process step retains the old contacts.
  - *pass b:* S: `trace_keeps_of_retains` (l. 135): for any Process P and plan : S → List I, if every step keeps every contact of its source plan, then along every Trace from s to t every selection through agreement on plan s is a selection through plan t. Revision rules ρ : List I → Option I → List I (Answers l. 148, Blind l. 158) are maps, not processes, in this module.
- **a reading**
  - *pass a:* S: `through_data_iff` (l. 82) makes the Boolean signal at an address selectable through agreement on decided data exactly when the address belongs to the data.
  - *pass b:* S: `AgreeOn` (l. 50): two signals are read alike where they agree at every contacted address. `through_data_iff` (l. 82) and `through_at_iff` (l. 115): the selection x i = true goes through that agreement exactly where i is contacted. `blind_misses` (l. 171): where Unlisted I holds (no list holds every address; nat_unlisted l. 186), every Blind rule leaves, at every plan D, some i whose selection does not go through the next plan's agreement. `answers_iff` (l. 152): a rule answers every failure exactly where its output contains the failed address.
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
  - *pass b:* N: no irreversibility. S, loss only: `retired_loses` (l. 129): a contact held in D and retired in D' has its selection through D and not through D'.
- **both outcomes**
  - *pass a:* S: `selections_survive_iff` (l. 123) characterizes retention of all old selections by plan inclusion; `retired_loses` (l. 129) gives the specific selection lost on removal.
  - *pass b:* S: `keeps_iff_retains` (l. 119) and `selections_survive_iff` (l. 123): a change of plan from s to t keeps every old selection exactly where every contact of plan s is in plan t, and otherwise some selection is lost (retired_loses). This is general and of keeping and losing, not of going on and ending. `References.stays_iff` (l. 232): an installed encoding stays right on a new channel exactly where the new channel agrees with the old at the encoded inputs.
- **a comparison between two**
  - *pass a:* S: `References.stays_iff` (l. 232) compares channels at the installed encoding’s inputs and characterizes continued correctness when the original channel works.
  - *pass b:* S: `keeps_data_iff` (l. 91): Registration.Keeps between two states s and t for agreement on data holds exactly where the data of s are within the data of t. `trace_keeps_of_retains` (l. 135) carries selections from the start of a trace to its end. `References.stays_iff` (l. 232) carries an encoding from channel c to channel c'.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* S: `trace_keeps_of_retains` (l. 135) propagates the property of supporting a fixed selection along all traces if each step retains every contact.
  - *pass b:* S: `trace_keeps_of_retains` (l. 135): where every step keeps contacts, being a selection through the current plan is kept along every trace. It is an invariant under steps, on that premise.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* S: `through_at_iff` (l. 115) identifies the selections gained at newly included addresses; `selections_survive_iff` (l. 123) keeps all previously available selections if old contacts are retained.
  - *pass b:* S: `keeps_iff_retains` (l. 119) with `through_at_iff` (l. 115): a plan that changes by adding contacts keeps every old selection, and each added address gains its selection. The plan widens while what it selected goes on. D: the opening says 'an added one gains it' and cites retired_loses, which states only the loss.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, moves, reading, both_outcomes, comparison, closed_region, forms_change. I reached all fourteen questions.
  - *pass b:* All statements, docstrings and the opening read (246 lines). Answers are from statements.

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge2-02

*As "Contacts.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge2-02.md.txt).*

- **an exact statement of both outcomes**: S. `selections_survive_iff` (l.123) with `keeps_iff_retains` (l.119); section variables `{I : Type} [DecidableEq I]`; for `plan : S → List I` and any `s t : S`: `(∀ select, Through (AgreeOn (plan s)) select → Through (AgreeOn (plan t)) select) ↔ ∀ i, i ∈ plan s → i ∈ plan t` (signals `I → Bool`). `retired_loses` (l.129) is the losing half for one contact: `i ∈ D`, `i ∉ D'` give the selection through D and not through D'. General, and of a change between any two indices s, t, not of a process step. Also `survive_data_iff` (l.102), `References.stays_iff` (l.232, premise `works`), `drives_iff` (l.218).
- **the side that keeps**: The edge statement asserts keeping between s and t only. A one-way law along a process: `trace_keeps_of_retains` (l.135), premise `retains : ∀ s a t, P.step s a t → ∀ i, i ∈ plan s → i ∈ plan t`, concludes every selection through plan s is through plan t along every `Trace P s as t`. No kernel, fixed point or certificate.
- **the side that ends**: N. Nothing is bounded and nothing falls. `retired_loses` (l.129) says only that the selection is lost; `blind_misses` (l.171, premises `Blind ρ`, `Unlisted I`) says at every plan D some failure is unanswered, with no bound. `nat_bound` (l.178) bounds the members of a list and is not an ending.
- **moves in that statement**: N in `selections_survive_iff` (s and t are any two indices; no process). S in `trace_keeps_of_retains` (l.135): every step by every move a, every trace, under the premise. `answers_iff` (l.152) and `blind_answers_iff` (l.162) quantify over every plan D and every reported address i of a rule `ρ : List I → Option I → List I`, which is a map, not a `Process`, here.
- **a reading in that statement**: S. The left side of l.123 is about what goes through agreement at the contacted addresses (`Learning.Training.Through (AgreeOn (plan s))`), and the condition is on the contacts, i.e. on what is read. `keeps_iff_retains` (l.119) states it as `Registration.Keeps`: the new lumping identifies no pair the old told apart.
- **the carrier**: A plan `plan : S → List I` over any index type S, with signals `I → Bool` read through `Contacts.AgreeOn plan` (l.50); in l.135 a `Process S A` with such a plan; revision rules `ρ : List I → Option I → List I`; `References`: channels `c c' : X → Bool` with an encoding `e : Bool → X`.
- **what is handed in**: Premises: the two plans (or that every step retains contacts, l.135). Concluded: exactly which selections are kept. No level, giving, share or favouring; the reading is the plan itself; no turn.
- **links to other modules**: `selections_survive_iff` (l.123) and `survive_data_iff` (l.102): `Learning.Training.Through`, `AgreeOn` (Learning), by `Learning.Training.keeps_through_iff` (Revision l.41). `keeps_iff_retains` (l.119) and `keeps_data_iff` (l.91): `Registration.Keeps` (Revision l.72), an exactly-when for it on contact plans. `trace_keeps_of_retains` (l.135): `Process`, `Trace` (Frame), by `Registration.trace_keeps`. `through_data_iff` (l.82): `Learning.Training.Through`. The opening account says `Becoming.ReferencePlan` and `Becoming.ContinuingRevision` are instances; no statement here names them.
- **standing**: None seen. Opening account: "Nothing is assumed beyond decidable equality of addresses"; "No ethical predicate, ranking or axiom occurs." `through_data_iff` and `keeps_data_iff` take `decided : ∀ i, D i ∨ ¬ D i` as a premise.
- **note**: An exact edge whose condition is on the reading itself (plan inclusion), with no closed region and no rank on either side, and stated between two indices, not along a step. The process version (l.135) is one direction only.
