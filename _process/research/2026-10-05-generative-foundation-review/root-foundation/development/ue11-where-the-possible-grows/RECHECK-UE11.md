# UE11 re-check: the fix round

AI-written, 27 October 2026. This is an independent re-check of board item UE11's fix round. Its job was to find what is wrong or overclaimed, not to confirm. It does not edit the module, the note or the landing kit. Its probes are evidence: none is proposed for landing as written, and where a fix below suggests landing one, it names the statement, not the file. "Verified" means built in Lean with the axiom report printed, or read in the cited text. Inference is marked as such.

## What was checked

- **The module.** [`tree/Becoming/HeldPossible.lean`](tree/Becoming/HeldPossible.lean): 810 lines, sha256 `61941dc95ce2a8bc779f66346fb9bf9e6569cb84eb3e49b7b0c0eef68a1f62ed`. The copy in `recheck/tree/Becoming/` is byte-identical. The first draft, `probes/tree/Becoming/HeldPossible.lean` (sha256 `1dc33ceee6198c49d2c4eefc246833bf2bbfcc4d95c78e057f6ab43714eab8da`), was read for what the fix round changed.
- **The note.** [`NOTE.md`](NOTE.md) was first read at sha256 `8f7e5192…0653` (132 lines). During the re-check it changed to sha256 `a151c05a8fc29b54723ccbc83fdbec26ee72e00cb41a09c51a63b733e174dade` (133 lines). As far as I compared, the only change is a new bullet in §7, "With it." (SelectionPool). Line numbers below refer to the second version.
- **The review.** [`REVIEW-UE11.md`](REVIEW-UE11.md) (sha256 `e99cab38f60ed0a02767101240e0ae8dd999fd03e1736af9aa9de19949cf453c`), finding by finding.
- **The landing kit.** It belongs to another session; I read it and edited nothing.
  - [`kit/texts_ue11.py`](kit/texts_ue11.py), sha256 `adc10be7…906e`;
  - [`kit/make_records_ue11.py`](kit/make_records_ue11.py), sha256 `7a1df545…c1b6`;
  - [`kit/study_ue11.txt`](kit/study_ue11.txt), sha256 `9b92f6b9…a93a`.

  These files hold the texts that would land in 07, 01, 02 and 08, in the record and in the study. Where a finding applies to them, its location says so.
- **What the claims were checked against.**
  - In the package folder, [`Becoming/`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/):
    - Grammar.lean: «续», «相续», «生», «复生», «生生», «息», «不穷», «粗化», «线内同类», «生生不息» and «自不复生则息»;
    - ReachableRanges.lean: UE10, including `Climb`;
    - Change.lean and Arising.lean: `Steps.buqiong_iff`, `Steps.hasPred_iff`.
  - In the theory:
    - the [glossary](../../../../../../GLOSSARY.md);
    - [D5](../../DELEGATED-CHOICES.md#d5-接续与生生不息的层次--succession-and-the-level-of-生生不息) with its revision of 18 October;
    - [07 §2](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-what-a-course-keeps-reachable);
    - [01's Open item](../../../../../../theories/becoming/chapters/01-ROOT.md#open);
    - UE10's [record](../../../../../../theories/becoming/results/records/what-a-course-keeps-reachable.md).
- **The credits.** Checked by web search and by reading the sources' text; see RM5 and "What holds".

**Build.** The build ran on main `765b7ef27`. The Lean package is unchanged since `5e9f14f5c`, where the note was built: `git diff --stat 5e9f14f5c 765b7ef27` on the package path is empty. The command, from the package folder, with no `BECOMING_FRESH`:

```
python3 -B scratch_build.py <this folder>/recheck/tree Becoming.HeldPossible Becoming.RecheckUE11Reading Becoming.RecheckUE11Laws Becoming.RecheckUE11Clash
```

The last run came after Q9 was added. It ran `Becoming.RecheckUE11Laws` and that module's audit, reused the other 339 steps, and found nothing unclean; the closure holds 337 modules. Every declaration of the four files was audited with `#print axioms`, and no report names an axiom. The module has 57 theorems in 80 declarations, as the note says. `recheck/tree/.build` (257 MB) is build output: git ignores it (`.gitignore` line 12) and it holds no data.

## Probes

All probes are in [`recheck/tree/Becoming/`](recheck/tree/Becoming/), in namespace `Becoming.RecheckUE11`. The one exception is a theorem of the clash probe, which has to sit in `namespace Becoming`.

| File | Theorems / declarations | Axiom report | Probes |
|---|---|---|---|
| [`RecheckUE11Reading.lean`](recheck/tree/Becoming/RecheckUE11Reading.lean) (sha256 `a9a2dffe…2756`) | 19 / 22 | empty | Q1–Q5 |
| [`RecheckUE11Laws.lean`](recheck/tree/Becoming/RecheckUE11Laws.lean) (sha256 `4c2f02e2…c0c7`) | 18 / 27 | empty | Q6–Q9 |
| [`RecheckUE11Clash.lean`](recheck/tree/Becoming/RecheckUE11Clash.lean) (sha256 `89c4be70…0bc1`) | 2 / 2 | empty | clash, shadow |
| `HeldPossible.lean` (the module, copied) | 57 / 80 | empty | — |

- **Q1.** `not_keepsWidening_of_recurs`. Take a course that comes back to one configuration at arbitrarily late steps. Nothing read off its configurations keeps widening, for any `F : S → X → Prop`.
- **Q2.** `Oscillating.returns`, `.recurs`, `.exceeds_now`, `.held_widens`, `.returning_has_both`. The module's `Oscillating` course returns every two steps.
  - At every step `1` is possible and is not admitted. So the whole possible exceeds what the course admits, both at that step and along the whole course.
  - The possible with the rule held widens across the first step. Because the course returns, it also widens across every even step.
  - It does not keep widening.
- **Q3.** `CopyDown.admitted_on_course`. The copying course itself admits `x` at step `x + 1`.
- **Q4.** `RaisedRule.not_renews`, `RaisedRule.ceases`, `CopyDown.not_renews`, `CopyDown.ceases`. These read both of the module's witnesses on the course's moments (`Steps.next`) under what is held: the rule for `RaisedRule`, the rules from any height `h` up for `CopyDown`. No moment renews (`«复生»`), so by `«自不复生则息»` every moment ceases (`«息»`).
- **Q5.** `Alternating.course`, `.held_keeps_widening`, `.whole_every`, `.renews_without_end`, `.both`. This is `RaisedRule`'s process with the rule raised at every other step.
  - The possible with the rule held keeps widening.
  - Every formation is possible from every configuration of the course.
  - Under the rule held, renewal without end (`«生生»`) holds at every even moment, so moment `0` does not cease.

  `Becoming.Alternating` is already taken (RuleCapture.lean line 722), so a landed copy needs another name.
- **Q6.** `toStart`, `fromStart`, `reach_held_iff_as_at_start`. For a class, what the moves holding it reach is exactly what the moves into configurations the same as the start reach, in both directions. Two other relations show where this fails, and the two readings differ for both:
  - `Adjacent.differs`: the relation "adjacent or equal", which is reflexive but not transitive;
  - `Down.differs`: `≤`, which is transitive but not symmetric.
- **Q7.** `RuleTower.move_above_keeps`. Where `up` lets a rule stay, the move `n + 1`, above `n`, is a step from `s` back to `s`.
- **Q8.** `exists_not_of_not_forall_lt`, `Run.held_change_located_weak`, `LocatedLaw`, `Two.*`, `wlem_of_located`, `located_iff_wlem`.
  - The module's located law holds when each step's holding is only weakly decided (`¬ Same … ∨ ¬ ¬ Same …`).
  - Asked of every process with no decision at all, the located law is exactly weak excluded middle.
- **Q9.** `unending_of_stays`, `not_begins_of_stays`, `Stay.fails`. Take a course whose every step holds the part. From every moment its line under the part is unending, and no line begins after moment `0`. This also holds on a course of `RaisedRule`'s own process.
- **Clash.** `clash_free` and `recheckUE11_keeping_is_junctures`. The module builds when imported with the whole package (`import Becoming`), so no names clash. Under `open Branching`, bare `keeping` is Junctures' (`rfl`).

## Findings

### Required

#### RR1. "The possible grows only relative to what is held" says more than the laws, and contradicts UE10

*Location.*
- Module header, line 94: "What is read: growth of the possible is relative to what is held".
- Note:
  - §1, line 13: "**[AI reading]** What grows is the possible relative to what is held, never the whole possible of a stated process";
  - §4, line 83: "UE11 says what growth of the possible is on a prestated space: relative to what is held";
  - §7, line 124, and §8, line 133: "The possible grows only relative to what is held".
- Kit:
  - `texts_ue11.py` line 39 (07 §2, the last clause of UE10's reading) and line 48 (07 §2's reading);
  - `make_records_ue11.py` lines 201–206 (the record's statement) and lines 407–408 (the related entry it writes into UE10's record, `what-a-course-keeps-reachable`);
  - `study_ue11.txt`, its **Readings** paragraph.

*Problem.* The laws show three things:
- Along a course of a stated process the whole possible never grows (UE10; laws 4 and 5).
- The possible with a part held grows only across a step that changes the part (`Run.changes_of_heldGrows`).
- It keeps widening only where the part changes without end.

They do not show that the possible grows only relative to what is held. UE10's possible within a horizon keeps widening along a course of one fixed, determined process, with nothing held (`Climb.keeps`, ReachableRanges.lean line 1096). Three texts already say so:
- UE10's record states it as a law: "On Climb … the possible within every horizon keeps widening" (`laws[15]` in its JSON).
- 07 §2, the section where UE11 lands, states it (line 94: "along a course the possible within a horizon keeps widening only where no list holds the whole possible").
- The note's own §3 (line 57) lists the horizon possible first among "three senses in which the possible grows, apart".

The kit also puts the sentence in the record's statement, which is a claim and not a reading, and into UE10's own record beside `Climb.keeps`.

*Evidence.* Verified: `Climb.keeps` and its docstring; UE10's record, `laws[15]`; 07 §2 line 94; note §3 line 57.

Inference: saying that the horizon possible "only moves with the actual" does not single out the held possible as the only growth "of the possible itself". The held possible is also read at the actual configuration and widens as that configuration moves. On `RaisedRule` it is exactly what lies at most the actual rule.

*Fix.* Name the sense, and claim no exclusivity.
- **Module, line 94:** "What is read: along a course of a stated process the whole possible never grows, and the possible with a part held grows only across steps changing the part; keeping it growing needs the part to change without end; and a tower of rules with no top, read as one process, adds nothing to its whole possible."
- **Note §1, the AI reading:** "**[AI reading]** The whole possible of a stated process never grows; besides the possible within a horizon, which moves with the actual (UE10), what grows is the possible relative to what is held, and only across steps that change what is held; keeping it growing needs what is held to change without end."
- **Note §4, line 83:** "UE10 restated the adjacent possible for a prestated space; UE11 says where the possible grows on a prestated space: never the whole possible, and relative to what is held only across a change of what is held."
- **Note §7 and `texts_ue11.py` line 39.** This is the clause that replaces "growth of the possible itself would need a process that changes, which no law here states". New clause: "a process whose rules change, a tower of rules with no top included, adds nothing to its whole possible either, and the possible relative to what is held grows only where what is held changes (`[below](#r-where-the-possible-grows)`)".
- **Note §8, `texts_ue11.py` line 48 and the study's reading, second sentence:** "The possible within a horizon moves with the actual, and the possible relative to what is held grows only where what is held changes; keeping it growing needs what is held to change without end;" with the rest of the sentence as it is. RR3 and RR4 give a whole §8.
- **The record's statement (`make_records_ue11.py` lines 201–206).**
  - en: "The possible relative to what is held grows only across steps changing what is held, and keeps widening only where what is held changes without end. Along a course of a stated process nothing is added to the whole possible, a rule changing its own rule and a tower of rules with no top included."
  - zh: "相对于所持守者之可能，仅于改变所持守者之步上增长，仅当所持守者无尽地改变时持续扩大。沿一陈述之过程之进程，全部可能无所增，改变自身规则之规则与无顶之规则塔亦然。"
- **UE10's related entry (lines 407–408):** end it with "…; the possible relative to what is held grows only where what is held changes." (zh: "……；相对于所持守者之可能仅于所持守者改变处增长。").

#### RR2. Three laws are stated without their keeps-widening premise

*Location.*
- **Module header, lines 45–49:** "…, and from every step on (`Run.held_change_recurs_of_keepsWidening`). Read on the course's moments in the grammar, from no moment is the course's line under the part unending (`«不穷»`, `Run.not_unending_of_heldKeepsWidening`), and where holding is decided, a line under the part begins (`«生»`) after every moment (`Run.begins_of_heldKeepsWidening`)."
- **Note §2, law 3:** the bullet *Read on the course's moments* (line 33), and the end of the bullet *Where it keeps widening* (line 32).
- **Kit, `texts_ue11.py` line 46.** This is 07 §2's record-bound theorem paragraph: "…, and so one recurs from every step on (…). Read on the course's moments, from no moment is the course's line under what is held unending, and where holding is decided a line under it begins after every moment (…)".

*Problem.* All three theorems take `keeps : Reaching.KeepsWidening …` as a premise (lines 304, 314 and 324). Without it the sentences are false.

*Evidence.* Q9, `Stay.fails`: take a course of `RaisedRule`'s process that stays at rule `0`, position `0`. Every step holds the rule. From every moment the line under it is unending, and after moment `0` no line begins, so no step changes the part. The kit's own record text for the moments' laws (`make_records_ue11.py` line 125) states the premise; only the texts above lack it.

*Fix.*
- **Module, lines 43–49:** "Where whether each step holds the part is decided, a step changing it is located within any stretch across which the possible with it held grows (`Run.held_change_located`), and, where it keeps widening, from every step on (`Run.held_change_recurs_of_keepsWidening`). Where it keeps widening, read on the course's moments in the grammar, from no moment is the course's line under the part unending (`«不穷»`, `Run.not_unending_of_heldKeepsWidening`), and where holding is also decided, a line under the part begins (`«生»`) after every moment (`Run.begins_of_heldKeepsWidening`)."
- **Note, line 33:** "- *Read on the course's moments.* With the part between two moments in the place of the class, where the possible with the part held keeps widening, from no moment is the course's line under the part unending (`«不穷»`; …); where holding is also decided, a line under the part begins (`«生»`) after every moment (…)."
- **Note, line 32:** "…, and, where it keeps widening, from every step on (`Run.held_change_recurs_of_keepsWidening`)."
- **`texts_ue11.py` line 46:** "… and so, where the held possible keeps widening, one recurs from every step on (…). Where it keeps widening, read on the course's moments, from no moment is the course's line under what is held unending, and where holding is also decided a line under it begins after every moment (…)".

#### RR3. §8 reads "more still able to form" so that a whole that only returns has it, which D5 excludes

*Location.* Note §8, line 133: "More still able to form is then the whole possible exceeding the actual, as on the witnesses, where every formation stays possible, or the possible relative to what is held widening as what is held changes." The same sentence is in the kit's `texts_ue11.py` line 48 and in the study's reading.

*Problem.* D5's revision of 18 October (DELEGATED-CHOICES.md line 157) reads 生生不息 as 生生 going on at the whole "with more still able to form: not a return into copies of existing forms". It also says: "A whole that only returns has 不息 but not 生生不息". Both of §8's readings of "more still able to form" hold on a course that only returns. With them, a whole that only returns would have more still able to form, which D5 excludes.

*Evidence.*
- **Q2.** The module's own `Oscillating` course returns every two steps. At every step the whole possible exceeds what the course admits: formation `1` is never admitted. The possible with the rule held widens across the first step, and, because the course returns, across every even step.
- **Q1.** Keeping widening, by contrast, cannot happen along a course that comes back to one configuration without end.
- **Q3, on "as on the witnesses".** The copying course admits every formation at some step. So on `CopyDown` the whole possible exceeds the actual only step by step, never along the whole course.

*Fix.* Choose one of two options; a whole §8 for each follows RR4.
- **(a) With new Lean.** Land Q1 (six lines with an empty report, for example as `Run.not_keepsWidening_of_returns`) and Q2's `returning_has_both` (it uses the module's own `Oscillating`). Then replace the sentence with: "More still able to form, which D5 reads as not a return, is not the whole possible exceeding the actual, nor the possible relative to what is held widening across a step: `Oscillating`'s course only returns and has both (`Oscillating.returning_has_both`). It can be the possible relative to what is held keeping widening, as on the witnesses, which no course coming back to one configuration without end has (`Run.not_keepsWidening_of_returns`)."
- **(b) Without new Lean.** Replace it with: "What more still able to form is on a course, which D5 reads as not a return, these laws do not settle."

#### RR4. §8's last sentence claims what is not shown, and its witnesses show the opposite of going on

*Location.* Note §8, line 133, the last two sentences: "The root theorem `«生生不息»` says …; read on a course's moments, keeping the possible widening … needs … lines under what is held to begin after every moment and none to go on without end. Going on and growth relative to what is held are therefore different relations, and both hold with a fixed whole possible." The kit's 07 reading does not carry these two sentences; the study's reading should be checked against whatever §8 becomes.

*Problem.*
- **(a) The claim is not proved.** No course in the module has renewal without end, or not ceasing, together with a held possible that keeps widening and a fixed whole possible. "Both hold with a fixed whole possible" is unproved in the module.
- **(b) The witnesses show the opposite.** §8 points to "the witnesses". Read on the course's moments under what is held, which is the reading the sentence before uses, both witnesses have no moment that renews and every moment ceasing. They show keeping widening with ceasing everywhere.
- **(c) "Therefore" does not follow.** Keeping widening needs lines to begin and none to go on without end. That says nothing about how it relates to renewal without end.
- **(d) The wrong term.** "Going on" is the glossary's 延 ("goes on along some branch", 02 §1). Here it stands for the root's «生生», or 不息.

*Evidence.*
- **Q4.** On `RaisedRule`, and on `CopyDown` with the rules from any height up held, `¬ «复生»` and `«息»` hold at every moment.
- **Q5.** A course with both does exist: the rule raised at every other step. It keeps widening, every formation stays possible, and «生生» holds at every even moment. So the claim is true, but it needs this witness.

*Fix.* Write "renewal without end", not "going on", and choose one of two options.
- **(a) With new Lean.** Land Q4's two `ceases` laws, and land Q5's witness under a free name, for example `RaisedEveryOther`. Then write: "Renewal without end and growth relative to what is held are different relations: on both witnesses every moment ceases under what is held (`RaisedRule.ceases`, `CopyDown.ceases`), and on a third, the rule raised at every other step, both hold with every formation possible throughout (`RaisedEveryOther.both`)."
- **(b) Without new Lean.** Write: "Renewal without end and growth relative to what is held are different relations; whether both hold on one course with a fixed whole possible is not stated here."

*§8 in full, with RR1, RR3 and RR4 taken.* These versions use option (b) and need no new Lean.

> If the one unfolding were one stated process, nothing would be added to its whole possible along its course: what a course adds is the actual. The possible within a horizon moves with the actual, and the possible relative to what is held grows only where what is held changes; keeping it growing needs what is held to change without end. A tower of rules with no top adds nothing to its whole possible either, and each of its possibilities is had with a top, the rules from some height up, held. So 生生不息, read at the whole as 生生 going on with more still able to form (D5, as revised on 18 October), needs no growth of the whole possible, and D5 excludes reading it as growth. What more still able to form is on a course, which D5 reads as not a return, these laws do not settle. The root theorem `«生生不息»` says that renewal without end does not cease; read on a course's moments, keeping the possible widening relative to what is held needs that no line under what is held goes on without end and, where holding is decided, that lines under it begin after every moment. Renewal without end and growth relative to what is held are different relations; whether both hold on one course with a fixed whole possible is not stated here.

With the Lean of options (a) landed, replace the sentence "What more still able to form is …" with RR3 (a), and the last sentence with RR4 (a). The kit's 07 reading (`texts_ue11.py` line 48) takes the same changes in its own wording.

#### RR5. Two docstrings say more than their Lean, and so do the header and note texts drawn from them

**(a) The tower's moves above `n`.**

*Location.*
- `Run.ruleTower_move_above_recurs_of_keepsWidening`, lines 513–515: "moves above `n` recur: from every step on some move changes a rule from height `n` up, located with no decision of the rules, since each move names the height it changes".
- Note §2, law 5, line 47.
- `make_records_ue11.py` line 161: "since each move names the height it changes".

*Problem.* The Lean concludes `∃ i, N ≤ i ∧ n < r.act i`: some move above `n` is taken. It does not say that this move changes a rule. A move `k + 1` changes the rule at height `k` only as `up k` allows, and `up k` may leave it as it is.

Inference: locating a step that does change a rule from height `n` up would need equality of rules to be decided, which this theorem avoids. The bounded-stretch law gives such a change only up to double negation.

*Evidence.* Q7: with `up := fun _ _ ρ ρ' => ρ' = ρ`, the move `n + 1` is a step from `s` back to `s`; that is, `(RuleTower.process base up).step s (n + 1) s`.

*Fix.*
- Docstring: "**Along a course of the tower, where the possible with the rules from height `n` up held keeps widening, moves above `n` recur**: from every step on some move above `n` is taken, the only kind of move that can change a rule from height `n` up, located with no decision of the rules, since each move names the one height it can change."
- Note line 47 and record line 161: "since each move names the one height it can change".

**(b) Holding move by move and holding as at the start.**

*Location.*
- `Reach.same_of_heldMoves`, lines 241–242: "holding it move by move is holding it as it is at the start".
- Header, lines 97–98: "held move by move (for a class, the same as holding it as it is at the start)".
- Note §2, line 30: "held move by move is held as at the start".
- Note §5, line 97: "for a class, the same as holding it as it is at the start (`Reach.same_of_heldMoves`), not for a relation that is not transitive".
- `make_records_ue11.py` line 102: "so held move by move is held as at the start".
- `make_records_ue11.py` lines 213–214: "the same as holding it as at the start only for a class".

*Problem.* "The same as" claims that the two readings of holding reach the same configurations. The Lean proves only one direction: what the moves holding a class reach is the same as the start. The converse is not stated: moves into configurations the same as the start reach nothing more. The note's limit "not for a relation that is not transitive" also misses a case: the two readings differ for a relation that is transitive but not symmetric.

*Evidence.* Q6:
- `reach_held_iff_as_at_start` proves both directions for a class, with an empty report.
- `Adjacent.differs`: for "adjacent or equal", which is reflexive and not transitive, the held moves reach `2` from `0`, and `2` is not the same as `0`.
- `Down.differs`: for `≤`, holding as at the start reaches `3` from `0` (through `5`); holding move by move does not.

*Fix.*
- **Preferred:** land Q6's three declarations, about twenty lines, under a name such as `Reach.heldMoves_iff_sameAsStart`, and cite them for "the same as".
- **Otherwise:** reword to the direction proved. Docstring: "…: holding it move by move keeps it as it is at the start". Header: "(for a class, what is reached holding it move by move stays the same as the start)".
- **Either way:**
  - The note's §5 line reads: "for a class, the same as holding it as it is at the start; not in general: where the relation is not transitive, what is reached need not be the same as the start, and where it is not symmetric, moves into configurations the same as the start can reach what the moves holding it do not".
  - In the record kit, "only for a class" becomes "for a class, not in general".

### Recommended

#### RM1. The located law: a weaker premise suffices, and what locating needs without one is now probed

*Location.*
- The premise `decided` of `Run.held_change_located`, `Run.held_change_recurs_of_keepsWidening` and `Run.begins_of_heldKeepsWidening` (lines 290, 303 and 323).
- Note §3, line 71: "what locating needs without a decision is not probed".
- `make_records_ue11.py`, lines 226–228.

*Evidence.* Q8:
- `Run.held_change_located_weak` proves the located law from `weak : ∀ n, ¬ Same (r.state n) (r.state (n + 1)) ∨ ¬ ¬ Same (r.state n) (r.state (n + 1))`, which `decided` gives.
- `located_iff_wlem`: the law with no decision, asked of every process, is exactly weak excluded middle, `∀ Q : Prop, ¬ Q ∨ ¬ ¬ Q`. The witness is a two-step course whose holding at its two steps is `Q` and `¬ Q`.

*Fix.*
- **In the Lean (optional):** weaken `decided` to the weak form. The search `Amounts.unmarked_or_marked` then gives way to Q8's `exists_not_of_not_forall_lt`.
- **Note §3, line 71:** replace "what locating needs without a decision is not probed" with "with each step's holding only weakly decided (refuted, or its refutation refuted) the step is still located, and with no decision, asked of every process, locating is exactly weak excluded middle (RECHECK-UE11, Q8); by AGENTS.md this is a lemma of the item, not a calibration, since it says nothing further about the unfolding".

#### RM2. "Read as the grammar's class" for laws that take any relation

*Location.*
- Header, line 30: "With `Same` read as the grammar's class".
- Note §2, line 30: "Read with `Same` as the grammar's class".
- Note §2, line 33: "With the part between two moments as the class".
- Note §3, line 61: "the possible along the line under a class".
- `texts_ue11.py` line 46: "a move holding a class is a continuation under it, …".
- `make_records_ue11.py` line 125.

*Problem.* Several laws hold for every relation: `Reaching.steps_heldMoves_iff`, `reach_heldMoves_iff`, `possibleHeld_iff_line`, and the moments' laws. Only `Reach.same_of_heldMoves` takes `«类» Same`.
- The glossary's class is an equivalence relation, and the header's next sentence ("Where `Same` is a class") uses that sense. So one paragraph uses "class" for two things.
- The grammar's own docstring of «续» says "under the class E" with no premise, so the usage has a precedent.
- The kit's 07 text, "holding a class", understates the laws.

*Fix.*
- **Header and note line 30:** "With `Same` in the place of the grammar's class `E`, any relation, a move holding the part …".
- **Note line 33:** "With the part between two moments in the place of the class".
- **Note line 61:** "the possible along the line under the part".
- **Kit's 07 text:** "a move holding a relation is a continuation under it, what the moves holding it reach is the start or the start's line under it, and the held possible is what the start or that line admits".

#### RM3. `CopyDown.process`: the move `0` copies nothing

*Location.* The docstring at line 710 ("Each move copies a rule down one height; the state stays.") and the header at line 88 ("a tower whose moves copy a rule down one height").

*Problem.* `CopyDown.process` is `RuleTower.process` with `base` the identity on states. So the move `0` keeps the state and every rule.

*Fix.*
- Docstring: "The move `k + 1` copies the rule at height `k + 1` down to height `k`; the move `0` changes nothing; the state stays."
- Header: "a tower whose moves above `0` copy a rule down one height".

#### RM4. "Every rule is changed by the one above it"

*Location.*
- The `RuleTower.process` docstring, lines 436–437.
- Header, line 68.
- Note §1, line 13 ("a tower of rules in which every rule is changed by the one above it").
- Note §2, line 44.

*Problem.* With an `up` that lets each rule stay, no rule is ever changed (Q7). What the scheme says is that a rule changes only as the one above it allows.

*Fix.* "Every rule changes only as the one above it allows, and none is the last." In §1: "a tower of rules in which every rule changes only as the one above it allows and none is the last".

#### RM5. Two credit details

*Location.* Note §4, line 82.

- **Pages.** Wand and Friedman 1988 is *Lisp and Symbolic Computation* 1(1):11–37, not 11–38. Verified by web search: the paper's PDF header and the Utah bibliography both give 11–37. *Fix:* "1(1):11–37".
- **Wording.** The draft summary of des Rivières and Smith, in the PARC archive, says a single computation step can increase the degree of introspection "by only a finite amount" (by one in 3-LISP). The note says "a bounded amount". *Fix:* "raises the degree by a finite amount, by one in 3-LISP".

#### RM6. Seven declarations, not six, sit outside the module's own namespaces

*Location.* Note §5, line 94: "six sit in namespaces of other modules' definitions or at the root".

*Evidence.* I listed the module's 80 declarations. Set aside the `Run.*` and `Reaching.*` declarations, and the module's own namespaces (`RuleTower`, `RaisedRule`, `Oscillating`, `Synchronous`, `CopyDown`). Seven declarations remain elsewhere: the six listed, and `adaptive_keeps_rule_iff`, which sits at the root of `Becoming` beside Mechanism's `adaptive` (Mechanism.lean line 219).

*Fix.* "seven sit …: …, `adaptive_keeps_rule_iff` (at the root, beside `adaptive`), and `«及在渐粗列之相续»`, …".

### Notes

- **RN1. Names using "grows".**
  - *Location:* `Reaching.not_reach_of_grows`, `Reaching.not_step_of_grows`, `Run.changes_of_heldGrows`.
  - *Observation:* "grows" names the hypothesis that something is possible at the later configuration that is not possible at the earlier, with no inclusion. The module's title and header use "grows" in this sense, the docstrings now state the hypothesis exactly (M1 taken), and the review left a rename to `…_of_new` optional.
  - The other names (`Reaching.heldMoves`, `Reaching.PossibleHeld`, `RuleTower`, `RaisedRule`, `Oscillating`, `Synchronous`, `CopyDown`) say what they define and clash with nothing (clash probe).
  - *Fix:* none needed.
- **RN2. «及在渐粗列之相续».** Read against Grammar.lean, the name is sound.
  - «及» is reach, the transitive closure, and «相续» is a line; 粗 is used as in «粗化» (coarsening, line 160); 之 and 在 are used as in the grammar's other sentence-names («线内同类», «生于细而续于粗则异»).
  - 列 and 渐 appear nowhere else in the package, the glossary or the theory graph, so the name adds two words. Both read off the statement: a sequence, each member included in every later one. 列 is kept apart from 族, the grammar's 同族, as §5 says.
  - The statement gives a line under *some* member and the name does not say "some", like the grammar's other names.
  - *Fix:* none.
- **RN3. "Held".**
  - *Observation:* 07 already uses the word in other senses: "a living claim is *held* when it lies in some standpoint's own region" (07 line 123, `Valuation.significant_iff_held`), "held de se" and "held by no list". 02 has "the rest's exchange held as it was". The landing adds "what is held" and "the held possible" to 07 §2. No glossary entry is at stake, and each Lean name says what it means.
  - *Fix (optional):* gloss the term at its first use in 07 §2: "what is held, a relation each move keeps between its two configurations".
- **RN4. §3's costs.**
  - *Location:* note line 58.
  - *Observation:* "read in the grammar, no unending line … with lines … beginning after every moment" restates endless change on the course's moments, through `Steps.buqiong_iff` and `Steps.hasPred_iff`; it is not a further cost. As for "these do not suffice (`Oscillating`)": the grammar costs do hold on `Oscillating`, since the rule changes at every step, so every moment begins a line and none goes on. But the module states only the change and the unlisted whole.
  - *Fix (optional):* "endless change of what is held, read in the grammar as …; and an unlisted whole possible from the start".
- **RN5. Missing docstrings.** `Oscillating.cond_not_ne`, `CopyDown.rule_below` and `CopyDown.rule_above` are helpers without docstrings. Adding them is optional.
- **RN6. How the two witnesses widen.** The held possible widens differently on the two witnesses:
  - on `RaisedRule`, through the moves holding the rule, while the course admits only `0`;
  - on `CopyDown`, through the course's own admissions (Q3).

  Only the first shows the possible relative to what is held exceeding everything the course ever admits.
- **RN7. "Top".**
  - *Observation:* "a top fixed for good" and "had with a top held" read "top" as the rules from some height up, as R4 asked; the tower itself has no top.
  - *Fix (optional):* gloss it at first use, "a top, the rules from some height up", so that "a tower of rules with no top … had with a top held" is not misread.
- **RN8. Two kit texts.**
  - The 01 Open replacement in `texts_ue11.py` keeps the rest of the item's list: a pattern reshaping its own limits; ClosedCapture's laws and readers in the grammar; selection of selection.
  - The kit's 08 §8 bullet calls McMullin's point "endless change at the highest levels". The source says "the continuing feasibility of inheritable change at the highest control levels (including emergence of higher, newly dominating levels)". *Fix:* "continuing inheritable change at the highest levels".
- **RN9. The SelectionPool correction.** The docstring correction to SelectionPool that rides with UE11 (note §7, line 129) is outside what was asked. I checked only that `web_keeps_iff` sits in `namespace Registration` of Revision.lean (lines 67–134, the theorem at line 83). So `Registration.web_keeps_iff` is the right name.
- **RN10. Where RR1 and RR3 come from.** They correct wording that the first review proposed, in R4 and in its M7 texts. The fix round took that wording nearly verbatim, so these are not departures made by the fix round.
- **RN11. Not re-checked.** Law 2's remark that the converse would give Markov's principle rests on the review's P2, which I did not re-check.

## What holds

**The Lean.** Every theorem of the module is correct as stated, with an empty axiom report:
- 57 theorems in 80 declarations, byte-identical to the module, term proofs only (no `by`).
- It imports `Becoming.ReachableRanges`, `Becoming.Mechanism`, `Becoming.Gated` and `Becoming.Junctures`.
- The closure is 74 modules: 6 at L0, 65 at L1, and three unlabelled (`GenerativeCore`, `RelationalRenewal` and the module itself). So the module is an L1 leaf.
- Imported with the whole package it clashes with nothing, and under `open Branching` bare `keeping` is Junctures' again.

Nothing is vacuous: each law's premise is met.
- Holding that keeps widening: `RaisedRule` and `CopyDown`.
- A decided step: `Nat` equality there.
- The sequence premise: `RuleTower.step_sameFrom`.
- The adaptive premise: the review's P11.

**The header and the docstrings.** I checked each against its Lean. Apart from RR1, RR2, RR5 and RM2–RM4, every header bullet and docstring says exactly what its Lean proves. This covers:
- law 1's hypothesis, "from every step", "in 07's form read from the course's first step", and "does not keep widening";
- the root laws: `steps_heldMoves_iff`, `reach_heldMoves_iff`, `possibleHeld_iff_line`, `heldMoves_mono`;
- `possibleHeld_of_stays`, the located laws, the listed law and the adaptive laws;
- the sequence and tower laws: `step_sameFrom`, `possible_iff_held`, `reflected`, `held_origin`;
- `Synchronous` and the witnesses' statements.

**The review's findings, all taken.**

| Finding | What the fix round did |
|---|---|
| R1 | Option (b); the top law dropped as an instance, its claim kept in prose with `possibleHeld_of_stays` |
| R2 | The sentence taken |
| R3 | Renamed, the two `rfl` instances added, the clash check re-run clean, the shadow gone |
| R4 | The glossary's terms; D5 and `«生生不息»` placed; "a top fixed for good"; widening at every height claimed only with `CopyDown` |
| R5 | Credits corrected |
| M1 | (a)–(h) taken; (i) moot |
| M2, M3, M5, M6, M7 | Taken |
| M4 | (a) and (b) taken; (c) not, as §6 says |
| N2 | Not stated, as §6 says |

The fixes say what the Lean proves, except where RR1, RR3, RR4 and RR5 (b) say otherwise.

**§6's deviations.** Each is sound:
- M2's weaker decided premise is exactly what the proof uses, and it can go weaker still (RM1).
- `held_change_recurs_of_keepsWidening` replaces the review's name and states the recurrence.
- `Amounts.unmarked_or_marked` is used instead of importing Reproduction.
- The general law over a sequence of relations growing coarser, on the root and on any process, has the review's bounded form as an instance.
- The top law is dropped, and P11 and N2 are not landed.

One answer is incomplete: `Reach.same_of_heldMoves` answers N3 in one direction only (RR5 (b)).

**The note.**
- Laws 1–6 state the Lean, apart from RR2's missing premise and RM2's "class". §3's *Forbids* is exactly what the Lean gives.
- §5's counts are right (57 / 80, 74 modules, 6 at L0 and 65 at L1, 335 modules with the package), apart from RM6.
- §8 needs no growth of the whole possible, never says "a level fixed for good", and does not use "generation". Its faults are RR1, RR3 and RR4.

**Credits.**
- *Verified by reading the sources' text:*
  - The ALife 2016 summary by Banzhaf, Beslon, Doursat and Stepney: variation; innovation, "thereby growing/shrinking the possibilities of variation"; emergence.
  - Taylor and others 2016, *Artificial Life* 22:408–423. Banzhaf's talk: novelty is practically unbounded if the number of levels may grow. McMullin's: the continuing feasibility of inheritable change at the highest control levels may be critical.
  - Adams, Zenil, Davies and Walker 2017. Innovation is trajectories not observed in isolated systems, and state-dependent dynamics is "the only mechanism to produce open-ended evolution in a scalable manner".
  - The draft summary by des Rivières and Smith in the PARC archive. The degree of introspection is the least level above which every level is "boring"; an implementation need terminate only for finite degree; and a step raises the degree by a finite amount, by one in 3-LISP.
- *Verified by web search, bibliographic data:* Banzhaf and others, *Theory in Biosciences* 135(3):131–161; Adams and others, *Scientific Reports* 7:997; des Rivières and Smith, ACM LISP and Functional Programming 1984, 331–347; Wand and Friedman, 11–37 (RM5).
- *Not re-checked:* Bedau and others 2000, Kauffman 2000, Longo, Montévil and Kauffman 2012, Hughes and others 2024 and Bateson 1972, which the first review graded correct. Bateson's Learning 0 to IV agrees with my knowledge of the text, which I did not re-read. The claim that no neighbour states the laws was not re-checked either.

## Verdict

**Can land after RR1–RR5.**

All five are fixes to text:
- in the module, the header (lines 43–49, 94, 97–98) and two docstrings (lines 241–242, 513–515);
- in the note, §1, §2, §4, §5, §7 and §8;
- in the kit, which another session holds: the 07 texts, the record's statement and related entry, and the study's reading.

No Lean statement has to change. The note may keep a claim that only a probe proves: the returning course in RR3, the witness with both in RR4, the converse in RR5 (b). If it does, the probe must first land in the module under a free name, with its axiom report. Otherwise the claim is cut, as the fixes say.

RM1–RM6 are recommended; the notes are optional.
