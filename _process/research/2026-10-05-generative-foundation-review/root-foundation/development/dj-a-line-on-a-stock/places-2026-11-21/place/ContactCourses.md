# ContactCourses

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ContactCourses.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-02, as "ContactCourses.lean: blind_answers_steps_iff, run_stays_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-02.md.txt)); pass b: reader whole-b-07, as "ContactCourses.lean: blind_answers_steps_iff, finite_blind_answers_steps, run_stays_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-07.md.txt)); the third pass, where the two differed: reader whole-c-settle-03, as "ContactCourses.lean: settled fields closed_region, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-03.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `blind_answers_steps_iff` (l. 43) characterizes answering every failure for any blind plan-revision rule by every no-report successor contacting every address. `run_stays_iff` (l. 69) characterizes correctness of an initially working encoding at date n of any channel run by agreement at the encoded inputs.
  - *pass b:* The module states, in general, that the process of a revision rule that does not read the failure answers every failure exactly where every step reporting no failure lands on a plan contacting every address. It also states that along a run of any process whose configurations are channels, an encoding installed at the start stays right at a date exactly where the channel then agrees with the first at the encoded inputs. A built case with two addresses shows a blind rule answering every failure.
- **moves**
  - *pass a:* S: `blind_answers_steps_iff` (l. 43) quantifies over all successors of an ofMap process with moves none or some failed address.
  - *pass b:* S: `blind_answers_steps_iff` (l. 43): for a Blind rule ρ, every step of the process ofMap ρ whose move is a failure report some i lands on a plan containing i, exactly where every step whose move is none lands on a plan containing every address. The moves are the reports of failure (Option I). This is a law about what every step keeps.
- **a reading**
  - *pass a:* S: `blind_answers_steps_iff` (l. 43) states exactly when a rule blind to the failure report covers every reported address.
  - *pass b:* S: `blind_answers_steps_iff` (l. 43): the premise Contacts.Blind says the rule does not read the reported failure (ρ D r = ρ D none). Then answering every failure depends only on what the no-failure step contacts. B: `finite_blind_answers_steps` (l. 56): with Bool addresses, the rule giving [false, true] lands every step where the no-failure step lands and answers every failure.
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
  - *pass a:* S: `run_stays_iff` (l. 69) gives an exact test for retention of an initially correct encoding at each date.
  - *pass b:* S: `run_stays_iff` (l. 69): for any run r of a process on channels X → Bool and an encoding that works at date 0, it works at date n exactly where r.state n agrees with r.state 0 at the encoded inputs. This is a general exactly-when of keeping and losing the encoding, not of going on and ending.
- **a comparison between two**
  - *pass a:* S: `run_stays_iff` (l. 69) compares the channel then with the initial channel only at e b for each b.
  - *pass b:* S: `run_stays_iff` (l. 69) compares the channel at date n with the channel at date 0 at the encoded inputs: the encoding carries exactly where they agree there.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *settled by the third pass:* N: `finite_blind_answers_steps` (l. 56) states, for `ofMap (fun _ _ => [false, true])`, that every step `D r D'` is also a step `D none D'`, and that every step reporting `some i` lands on a `D'` with `i ∈ D'`; it is a property of where each step lands, with no premise on `D` and no region or fixed point named. Opened to rule it out: all three statements, `blind_answers_steps_iff` (l. 43), `finite_blind_answers_steps` (l. 56), `run_stays_iff` (l. 69). [which pass was right: b; opened: blind_answers_steps_iff l. 43; finite_blind_answers_steps l. 56; run_stays_iff l. 69]
  - *pass a:* B: `finite_blind_answers_steps` (l. 56) uses the constant next plan [false,true] for all moves and starts.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* S, in a weaker form: `run_stays_iff` (l. 69), for any `r : Run P` with `P : Process (X → Bool) A` and premise `works : ∀ b, r.state 0 (e b) = b`, states `(∀ b, r.state n (e b) = b) ↔ ∀ b, r.state n (e b) = r.state 0 (e b)`. It is conditional both ways: it lets the channel differ off the encoded inputs while the encoding stays right, but asserts neither that the channel changes nor that the encoding stays. [which pass was right: both in part; opened: run_stays_iff l. 69; blind_answers_steps_iff l. 43; finite_blind_answers_steps l. 56]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: `run_stays_iff` (l. 69): along a run in which the channel changes, the encoding stays right at every date where the change leaves the encoded inputs as they were. The channel may change everywhere else.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, moves, reading, both_outcomes, comparison. Built-case answers cover closed_region. I reached all fourteen questions.
  - *pass b:* All three statements and the opening read (76 lines). Answers are from statements. Assurance.ofMap was read only through this module's docstring and proofs.

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge2-02

*As "ContactCourses.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge2-02.md.txt).*

- **an exact statement of both outcomes**: S. `run_stays_iff` (l.69): for `P : Process (X → Bool) A`, `r : Run P`, `e : Bool → X`, premise `works : ∀ b, r.state 0 (e b) = b`, and any n: `(∀ b, r.state n (e b) = b) ↔ ∀ b, r.state n (e b) = r.state 0 (e b)`. Both outcomes (the encoding right at date n, or not) of one run with an exact condition per date. General. A second exactly-when, `blind_answers_steps_iff` (l.43; section variable `I : Type`; premise `Contacts.Blind ρ`): every step of `ofMap ρ` by `some i` lands on a plan containing i exactly where every step by `none` lands on a plan containing every i; it is of the whole rule, not of a course.
- **the side that keeps**: The statement only asserts the property at a date n. Nothing says that being right at n gives being right at n+1; no region closed under the step, kernel or fixed point. B: `finite_blind_answers_steps` (l.56), every step of the constant rule `[false, true]` lands where the `none` step lands.
- **the side that ends**: N. Nothing is bounded and nothing falls. The losing side is only the negation of `∀ b, r.state n (e b) = b`: the encoding is not right at n. It can be right again at a later date; no statement forbids it.
- **moves in that statement**: N in `run_stays_iff`: r is one given run and `r.act` does not occur. S in `blind_answers_steps_iff` (l.43): it quantifies over every step `(ofMap ρ).step D (some i) D'` and `(ofMap ρ).step D none D'`, the moves being the reports `Option I`.
- **a reading in that statement**: N in `run_stays_iff`: the condition is on the channel's values at the two encoded inputs, the configuration itself restricted to them. S in `blind_answers_steps_iff`: the premise `Contacts.Blind ρ` (`ρ D r = ρ D none`, Contacts l.158) says the rule does not register the report.
- **the carrier**: A `Run P` of a `Process (X → Bool) A` (a channel is the configuration); for the rules, `Assurance.ofMap ρ : Process (List I) (Option I)` with `ρ : List I → Option I → List I`.
- **what is handed in**: Premise: the encoding works at date 0, and the run. Concluded: the exact condition at each date. No level, giving, share or favouring; for the rule, that it does not read the report is a premise (`blind`).
- **links to other modules**: `blind_answers_steps_iff` (l.43): `Assurance.ofMap` (Laws) and `Contacts.Blind` (Contacts), the process form of `Contacts.blind_answers_iff`. `finite_blind_answers_steps` (l.56): the built case of `Contacts.finite_blind_answers`. `run_stays_iff` (l.69): `Run` (Frame), a case of `References.stays_iff` (Contacts l.232) with c := r.state 0, c' := r.state n.
- **standing**: None seen. Opening account: "No ethical predicate, ranking or axiom occurs."
- **note**: `blind_answers_steps_iff` (l.43) is a general exactly-when with every move and a reading (its absence) in the statement, but both its sides are "every step" properties of the rule: it has no going on or ending and no region or rank. `run_stays_iff` is an exact edge with neither a closed region nor a rank on either side.
