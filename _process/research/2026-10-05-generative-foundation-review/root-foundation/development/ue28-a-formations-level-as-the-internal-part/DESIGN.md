# UE28: a formation's level as the internal part (design, revised after the review of the Lean)

AI-written, 1 November 2026. Board item UE28, claimed at `6eba2890d`. Ten minutes. It went through two independent reviews: one of the first design ([REVIEW-UE28-DESIGN](REVIEW-UE28-DESIGN.md), fifteen findings, four high; §6 says where each is taken) and one of the scratch Lean ([REVIEW-UE28-LEAN](REVIEW-UE28-LEAN.md), thirteen findings, three high; §7).

## 1. The question

03 §1's reading of the blanket: a formation's support and observed levels are its sensory states, and what it folds of them its internal states. UE27 (`Becoming.BlanketCouplings`, landed at `29fbe6dee`, §488) proves the first half by construction, with a model fed by what couples in as the agent, the general case of a fold. The item it leaves open, in the blanket record's `does_not_show` and the principle's page §5, is a formation's own record as the internal part.

In the World a formation and a condition are roles of one relatum (`Becoming.Roles`), so a formation has a level of its own, `W.level t g`. Balance moves that level by what the relata present give to it and take from it, itself among them where it takes part (`Flow.BalancedHistory`). A formation's own act moves its own level only through what it gives to and takes from itself. The question is then: **along one run of a World, when is the formation's own level such a fold of what couples into it and its act, so that the level itself is the internal part, with no model beside it?** Only the level is asked about. The formation's activity, requirements, need and draws are its other records and stay outside the internal part.

## 2. The answer

### A. One course with the step external (any type)

1. **The course with the step external** (`stepExternal i s a`): an internal course `i`, a sensory course `s`, an active course `a`, and the step as the external part.
2. **The agent consistent** (`AgentConsistent i s a`): at any two steps where the internal, sensory and active states agree, the next internal states agree and the next active states agree. This is a law the same at every step on the agent's side, with no clock beyond what the three courses carry. A course carrying the step meets it at every pair of steps. It is tested only at steps where the three states recur.
3. **Consistent part by part exactly where the agent is consistent** (`stepExternal_consistent_iff`). The world's half holds of every such course, since the step tells its steps apart. So exactly there some law determined part by part admits the course (`stepExternal_admitted_iff`). Choice-free. A course where the three states never recur meets it, whatever moves it.
4. **The law, given the functions** (`stepLaw own policy s`, `stepLaw_course`). Where `own` and `policy` give the next internal and active states at every step, the course is the course of a blanketed law. The law's sensory part is the given course at the next step and its external part is the step. It is a same-step law: the internal part moves by the value at its own step, as balance does. Its world's side reads only the step: it is the open loop at the given course, it admits every sensory course, and the law's content is its agent's side. The converse, functions from item 2 alone, needs choice and is not stated.

### B. The World's reading

5. **The level read along one run** (`levelParts W g value act`): the formation's own level internal, `value t (W.level t)` sensory, an act course active, the step external. The World is `World.of R L W`, with balance a hypothesis where it is used.
6. **The value across steps** (`ValuesAcross W obs g value`): at any two steps, two levels have one value exactly where they admit `g` alike, each at its step, and agree on what couples into `g` by level. `Web.ValuesThrough` compares values at one step only, and a value carrying the step meets it (`Web.states_by_reading`), under which every run passes. `listed_values`' value, whether the levels admit `g` (decided) with the listed levels, meets it (`listed_valuesAcross`), and it gives `ValuesThrough` (`ValuesAcross.through`).
7. **The formation's act** (`presentRow presence cs L g`): its take and give rows on listed relata at a step where it takes part, nothing where it does not, with `presence` deciding which (`DecidesPresence`).
8. **The level's half under balance** (`next_level_alike_iff`): at two steps alike on a level, the next levels agree exactly where `given j g + taken k g = given k g + taken j g`. Pairwise, no subtraction, no choice. With an act course, `agentConsistent_iff_exchange`.
9. **On the World's records** (`levelParts_admitted_iff`). Take a balanced run, a value across steps, and the formation's act. Some law determined part by part admits the run read with its level internal exactly under the following condition. At any two steps alike on its level, alike in admitting it (each at its step), alike on the levels coupled into it and alike in its act, what the relata present give to it and take from it must cross-sum alike, and its next acts must agree. The statement names no value. It is tested only where these recur.

### C. Two witnesses, built to show what they show

10. **A drain in three phases** (`PhasedDrain`). Two relata. Nothing couples into `g` (`uncoupled`, and any value across steps is one value, `one_value`). `h` cycles through three phases, its phase its own level, kept by giving to and taking from itself. At its first phase `h` takes one unit from `g`, and at its second it gives `g` one unit. Balanced at every step (`balances`). `g` takes part in no step, so its act is nothing (`presence_decides`). `g`'s level goes 1, 0, 1, 1, 0, 1, …. At steps 2 and 3 its level, value and act agree and its next levels are 1 and 0. So for any value across steps, no law determined part by part admits the run (`not_admitted`). This is `ReadsExternal`'s mechanism on a balanced World.
11. **A drain and feed in two phases** (`Alternating`). Same setting, but `h` alternates: it takes one unit from `g` when on and gives one when off. Balanced (`balances`), uncoupled (`uncoupled`). `g`'s level goes 1, 0, 1, 0, … and recurs (`recurs`), so the condition is tested. The next level is fixed by the level, so for any value the run is admitted (`admitted`). It differs from the drain in three phases only in its period: two phases pass, three fail. What matters is whether the level's next value is fixed by the level, what couples in and the act, not whether what moves it couples in.

## 3. What it says, and does not

- **Says.** Read a balanced run of a World this way: the formation's level as the internal part, the value of what couples into it (across steps) as the sensory part, its act as the active part, the step as the external part. Then the formation's level is the internal part of a law determined part by part exactly where, at any two steps alike on its level, its admission, what couples into it and its act, its next levels and next acts agree. On the World's records, that is the cross-sum of what is given to it and taken from it. Where this fails, a model fed by what couples in is still the agent of a blanketed law (UE27), so the two halves of 03 §1's reading come apart there. The line falls at whether the level's next value is fixed by the level, what couples in and the act, not at whether what moves it couples in (the two witnesses).
- **Does not say.**
  - **Recurrence.** The test bites only where the three states recur.
  - **The world's side.** It is the run read by the step: UE27's first level, for one course, where the step suffices. The World's other records enter only through it.
  - **Across a family of runs, or with the step off the world's side.** Here the world's half becomes a condition: the value of what couples in next, and the rest next, must be fixed by the value, the act and the rest. So the level reaches the rest only through the act. The design review's `SpentDrain` fails it. This clause is not stated and stays open.
  - **Self-bearing formations.** For these (`Web.SelfBearing`), whose own level couples into them, the sensory part reads the internal part. Along one run the step still meets the world's half, so the reading stands there only by the step; across runs it does not.
  - **Other limits.** The formation's other records are not in the internal part. The reading is a modelling choice, stated as one. There is no free energy, weighting or density. Determined laws only, as `Blanketed` is.
- **Its relation to UE18.** There the supply coupled in by threshold only is the external part, and self-evidencing does not see its break coming. Here, where the level's next value is not fixed by the level, what couples in and the act, the level is not the internal part in this reading, while a model fed by the same couplings still is.

## 4. Standing

One near-definitional result. Item 3 is consistency part by part read along one course with the step external, and item 4 is its functional form. Items 5 to 9 are the World's instance, with the value across steps and the formation's act, stated on its records, with balance rearranged. The condition is the elementary one under which a single trajectory comes from a time-invariant deterministic state machine: equal state and input at two times give equal next state and output (§9, finding 3). What is new is stating it on the World's exchange, pairwise. The witnesses are built to show what they show.

The delta is where the line falls. It falls at whether the level's next value is fixed by the level, what couples in and the act. So the second half of 03 §1's reading holds of the level exactly there: it fails at a drain in three phases and holds at a drain and feed in two, while the first half holds throughout.

It is not a result beside UE27's. It extends UE27's record as one more reading in the classification of which blanket a thing has. Its world's side is a reading of the course by the step (UE27's first level, for one course). Its agent's side is a partition fixed by the formation's records apart from the run (the third level). With a value or an act carrying the step, it would fall entirely into the first level, which is why the World's reading takes a value across steps and the formation's own act.

## 5. Module, record and texts

- **Lean.** A new last part of `Becoming.BlanketCouplings` (a core leaf, UE27's module, extended rather than a second module for one question), plus the header's bullet, modelling choices and opening. As built (`scratch-build-v2.log`, 1 November 2026), the module holds 70 theorems in 140 declarations, every axiom report empty, no warnings. There is no `simp`, `omega` or `decide`; it uses `BlanketCouplings.pair_eq`, `Naturals.add_left_cancel`, `Naturals.add_right_cancel` and `Naturals.succ_ne_zero`.
- **The record** a-formations-couplings-as-its-blanket:
  - **New laws:** items 3 and 4, item 6 with `listed_valuesAcross`, item 9 with item 8, and the two witnesses.
  - **Statement:** gains a clause, `; along one run, with the step on the world's side, a formation's level is the internal part exactly where its next level and act agree wherever its level, what couples into it and its act agree`, within its length cap.
  - **Correspondence:** after "a single run constrains nothing under it", add `; a single run can refute a law the same at every step on the agent's side, read by a partition fixed apart from it (ReadsExternal; for a formation's level, PhasedDrain), which the time-unrolled blanket does not require`.
  - **`does_not_show`:** adds the world's clause across runs, and a history entry.
- **03 §1.** The blanket's Reading, from "what it keeps of them its internal states" through "is not shown", becomes (with the module's names) `what it folds of them its internal states, and the blanket condition is that … at most that (Blanket.Deaf.lumps). That a formation's support and observed levels are a blanketed agent's sensory states is a theorem wherever its admission is decided and its observed levels listed, by construction, with a model as the internal part ([below](#r-a-formations-couplings-as-its-blanket)). Its own level is such a part along one run, the step on the world's side and its couplings read with no step in their value, exactly where, at any two steps alike on its level, on what couples into it and on its act, its next levels and next acts agree; the test bites only where these recur, and across runs, and for its other records, nothing is shown.` "Keeps" goes, which removes the clash with the glossary's *keeping*. In UE27's home section, "and the agent is a model, not the formation's own record" becomes `and the agent here is a model; the formation's own level as the internal part, along one run, is the next paragraph`. A new paragraph follows, as the Lean review proposes, with the names `stepExternal_admitted_iff`, `levelParts_admitted_iff`, `PhasedDrain.not_admitted` and `Alternating.admitted`.
- **The blanket record.** Its `does_not_show` on a formation's own record narrows to the other records and the world's clause across runs. Its `next_delta` follows.
- **The principle's page.** §5's item becomes `a World formation's records other than its level, rather than a model, as the internal part of a blanketed law; its level across a family of runs, or with the step off the world's side`. §1's blanket line adds `along one run, the step on the world's side and the couplings read with no step in their value, its own level is the internal part exactly where its next level and act agree wherever its level, that value and its act agree, which a drain in three phases fails`.
- **08 §8.** One clause on the "which blanket a thing has" sentence: `a formation's level along one run, the step external, is the internal part of a law determined part by part exactly under the elementary condition for one trajectory to come from a time-invariant deterministic state machine, here stated on the World's exchange, pairwise` (as revised after the landing review, §9).
- **Study section** in BECOMING-RENEWAL-READING, with both reviews and the decisions.
- **Wording throughout.** Write "agree wherever … agree" or "fixed pairwise by", not "read off", and "one run", not "a run".

## 6. The design review's findings, and where each is taken

| Finding | Taken |
|---|---|
| 1 High: Part A empty, not a World | A is the law along one course with its iff (items 3, 4). B reads a World's own run, its other records entering through the step (items 5–9). "The formation itself" is dropped |
| 2 High: one-step lag | `stepLaw` is a same-step law (item 4) |
| 3 High: "exactly where" one direction; act and world's half | The iff is stated along one run with the step external, the act in it (items 3, 9). The world's clause across runs is open (§3) |
| 4 High: drained-or-fed slogan false | Replaced by determination (§3), with two witnesses (items 10, 11) |
| 5 Medium: `levelParts` choices | Courses are read directly, moves `Unit`. Value across steps (item 6), step external, act on listed relata with presence (item 7), other records external |
| 6 Medium: self-bearing, embodied | Named, standing only by the step along one run (§3) |
| 7 Medium: drain not balanced | `PhasedDrain`, balanced and periodic (item 10) |
| 8 Medium: exchange form strength | Pairwise, the relata present, itself among them where it takes part (§1, item 8) |
| 9 Medium: "keeps" misread | The question asks for a fold (§1); 03 §1 text with "folds" (§5) |
| 10 Medium: standing, UE18 | One result with its instance, plus witnesses (§4); UE18 sentence (§3) |
| 11 Medium: texts narrow by less | §5 item and blanket record narrow, not go; 08 §8 gets a correspondence clause (§5) |
| 12 Low: names | Renamed again at the Lean review (§7, finding 8) |
| 13 Low: wording | Taken |
| 14 Low: `pair_eq`, cancellation lemmas | Taken (§5) |
| 15 Low: the probe's copy of UE27's module | Removed |

## 7. The Lean review's findings, and where each is taken

| Finding | Taken |
|---|---|
| 1 High: the value unconstrained; `ValuesThrough` per step | `ValuesAcross`, `ValuesAcross.through`, `listed_valuesAcross` (item 6). `levelParts_admitted_iff` takes a value across steps and names no value (item 9). `PhasedDrain.not_admitted` holds for every value across steps (`one_value`) |
| 2 High: the act any course | The World theorem takes the formation's act, `presentRow` with presence (items 7, 9). `AgentConsistent`'s docstring says a course carrying the step meets it |
| 3 High: tested only where states recur; steady feed vacuous | `SteadyFeed` replaced by `Alternating`, whose level recurs (`recurs`, item 11). "Tested only where they recur" added in the docstrings, header and texts |
| 4 Medium: world's side the run read by the step | Said in `stepLaw`'s docstring, the header and §3, §4 |
| 5 Medium: `rowAct` ignores presence | `presentRow` and `DecidesPresence` (item 7). In both witnesses `g` takes part in no step, decided |
| 6 Medium: self-coupling | `levelParts`' docstring and §3 |
| 7 Medium: texts | §5 takes the proposed wordings: 03 §1 Reading and UE27's home section, the record's statement and correspondence, the page §1 and §5 |
| 8 Low: names | `stepExternal`, `AgentConsistent`, `stepLaw`, `levelParts`, `TwoRelata` |
| 9 Low: `stepLaw_course` converse | Said in its docstring |
| 10 Low: `PhasedDrain` wording, `uncoupled` | "Nothing couples into `g`", "gives `g` one unit", `PhasedDrain.uncoupled` added |
| 11 Low: header | Line rewrapped; modelling choices and opening extended |
| 12 Low: Web and Flow, not a World | `levelParts`' docstring names `World.of R L W`, balance a hypothesis |
| 13 Low: 08 §8 correspondence | One clause (§5), and the standing names the known condition (§4) |

## 8. Order

Revised design and Lean → texts and records → landing review (§9) → kit and rehearsal → the coordinator's slot.

## 9. The landing review's findings, and where each is taken

REVIEW-UE28-LANDING read the kit's texts and records applied to main: eighteen findings, one high. Every one is taken in the kit (`kit/`), and the module's docstrings changed in wording only, rebuilt clean (`scratch-build-v3.log`: 70 theorems in 140 declarations, every axiom report empty).

| Finding | Where taken |
|---|---|
| 1 High: "internal part of a blanketed law" where the Lean gives some law determined part by part | Every short text now says a law determined part by part: the record's statement and next step, the blanket record's entry, next step and history, the page's claim table and §5, 08 §8, both README rows, the regions note, FEP-INTEGRATION; the open items name a blanketed law for the level from consistency alone |
| 2 Medium: the statement's losses | Rewritten within 300 characters with the step external and "what couples in"; UE27's sensory-course clause stays in its first law (study, Decisions) |
| 3 Medium: the correspondence | The Pearl–Friston contrast and the proponents' concession restored, the antecedent fixed, author lists shortened; "elementary" for "familiar" everywhere, since for one trajectory the condition is that equal readings have equal successors |
| 4 Medium: the recurrence caveat | On the page (claim table, §1, §4), law 14, the README rows and the regions note |
| 5 Medium: "only by the step" for self-bearing formations | Withdrawn in 03, the record, the study and `levelParts`' docstring: the sensory part reads the internal part at the same step, and nothing beyond one run with the step is shown |
| 6 Medium: law 16 states a reading; the act dropped | Law 16 states the non-implication the two witnesses prove; 03, FEP-INTEGRATION, the study and the module header say whether the level, what couples in and the act fix the next level and act |
| 7 Medium: the study's reading | The level, not the formation, folds what couples in; "register" gone |
| 8 Medium: 03's paragraph | Split in two, opening with a question as the section's second paragraph does; no "cross-sum" or "same-step" anywhere in the texts, records or module |
| 9 Low: DecidesPresence as a hypothesis | The hypothesis and the study state the presence course, which may decide presence |
| 10 Low: listed_values' conditions; the probe's result in law 13 | Law 13 and 03 state the conditions; "every run passes" left to the probe |
| 11 Low: the step through admission | The study's standing, the record's hypothesis and two docstrings say the step enters through admission at each step and the formation's rows |
| 12 Low: the garbled entry | Rewritten |
| 13 Low: laws 14 to 16 | "some law", the equation with j and k, referents named |
| 14 Low: checker, root bullet, FEP-INTEGRATION | Rewritten as proposed |
| 15 Low: 03's open clause | Two sentences, the step-off case named |
| 16 Low: study bookkeeping | Result(s) counts the entries; Decisions says what the correspondence dropped; the review's count filled in |
| 17 Low: a missing dependency | testing-within-couplings added (Flow.BalancedHistory, Web.CoupledInto) |
| 18 Low: names | "a value across steps" and "the step external" throughout the short texts |
