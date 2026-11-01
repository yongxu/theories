# Independent review of OU7 part B's design

The reports of one independent AI review of this design and of the same reader's re-check of the revision, verbatim below the lines, as they were returned on 31 October 2026. The item was then numbered OU5, and both reports use that number. The review read the draft committed at `c896e1001`, in the folder then named `ou5-conditional-laws`; its line numbers and absolute paths refer to that draft and the checkout it read. The re-check read the revision committed at `6c945b760`, in copies outside the repository that it calls S; its line numbers refer to that commit's files. How each finding and each point was taken is in the design's [review section](../DESIGN.md#9-review).

---

**The review**, returned on the draft at `c896e1001`:

Review of OU5 part B is finished. I stayed read-only throughout: no file written, nothing built, no git command that writes. There are 18 findings: 2 high, 7 medium, 2 low–medium and 7 low. A short list of what checks out comes at the end.

Paths used below:
- DESIGN = `/Users/ren/theories/.claude/worktrees/ou5-check/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou5-conditional-laws/check/DESIGN.md`
- RoomNet = `/Users/ren/theories/.claude/worktrees/ou5-check/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou5-conditional-laws/check/scratch/Becoming/RoomNet.lean`
- RoomRuns = `/Users/ren/theories/.claude/worktrees/ou5-check/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou5-conditional-laws/check/scratch/Becoming/RoomRuns.lean`
- Package modules are in `/Users/ren/theories/.claude/worktrees/ou5-check/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.

## HIGH

**1. DESIGN:40 and :150 (also :38–40 "Restated, it holds", DESIGN:70, RoomNet:49–54): "The thermostat holds … 3, which the window does not move."**

Problem:
- **(a) It is false for c = 2 inside the model.** With the window open the level alternates 3, 4 (RoomRuns:87 `Thermostat.alternates`; :117 `holds_one_way` gives the band [3, 4]). DESIGN:181 itself cites `Flow.not_at_of_beyond` for the thermostat at 3, and that law says it does not rest there.
- **(b) For c = 1, "does not move" depends on when the heater reads.** It reads the level left after the exchange, within the same step, so it answers the step's own draw. That is RegimeMargin's order: `step g H x = (x - H) + g (x - H)` (RegimeMargin.lean:247).
  - No `Regulation.ReadsLate ℓ` rule, for any ℓ ≥ 0 (Regulation.lean:686), reads that way. Those rules are what 02 §8's late-reading laws cover.
  - `late_spread` (Regulation.lean:781), with the shut rest's record (0, 0) and the window's (0, 1) from step T, puts the windowed level exactly ℓ+1 below the shut one at step T+ℓ+1, for every such rule.
  - If the heater reads before the exchange (`exchange σ x + heater c x`), c = 1 settles at 2 and c = 2 alternates 2 and 3, so the window does move the level.
- **(c) Read as "the set point is not moved", the claim is true by construction.** The set point (RoomNet:51) and the surroundings (RoomNet:44) are both constants written into the rule, and the window switches only the surroundings. The restated guess is an interpretation presented as a result, and it has no AI-reading label.

Fix:
- Say instead that with the window open the heated rooms stay at or above the set point (c = 1 at 3 by `Matched.window_held`; c = 2 within [3, 4]) because the heater answers the draw within the step. Under any ReadsLate rule the window lowers the level by ℓ+1 at least once (`late_spread`).
- Keep as the distinction only what holds under either reading order: with a heater, warmth never ends; without one, the level follows the surroundings down to 0.
- Label the restatement an AI reading. Optionally add the read-before-exchange variant in scratch.

**2. DESIGN:99: "Every cell is proved in RoomNet" is false.**

Problem: 16 cells of the table at :92–97 (20 cells per occurrence) have no Lean statement:
- row :93 (b2): 守 no, 全生成 no, 全守 no, 有终 ✓
- row :94 (c = 1, s3): 后守 ✓
- row :95 (k3): 生成 no, 后守 ✓, 退化 no, 全生成 no, 有终 no
- row :96 (thermostat, s3): 退化 no
- row :97 (o4, o3):
  - 生成 ✓ is not stated on net 2; only `generates_open` on openNet 2 (:352) and 全生成 (:339) are.
  - 守 no is stated for o4 only (`Thermostat.rows` :402).
  - 退化, 全守 and 有终 are not stated at either occurrence.

The renewal column is also off:
- "Every step after opening" (:96) misses that the opening step s3 → o4 is itself a carrying renewal (`begins_o4`).
- "Every step" (:97) is not stated; `renews` (:314) gives one renewing successor.

Fix: add one-line lemmas to `Unheated.rows` (:209), `Matched.rows` (:274) and `Thermostat.rows` (:402):
- **b2:**
  - ¬守 by «守退化不并» with `ends_b2`.
  - 有终 by `⟨b1, .inr (.one ⟨b2_b1, rfl⟩), b1_ends⟩`.
  - ¬全生成 and ¬全守 by «全生成有终不并» and «全守有终不并».
- **s3 and k3 (c = 1):** 后守 by «守则后守» (`keeps_at _`).
- **k3:**
  - ¬生成 as `Matched.not_generates` does it, with `no_renewal (.inr rfl)`.
  - ¬有终 by «全守有终不并», ¬全生成 by «全生成全守不并», ¬退化 by «守退化不并».
- **Thermostat, s3:** ¬退化 by «守退化不并» ⟨keeps, _⟩.
- **o4 and o3:**
  - ¬退化 by «尽则非不穷» (GrammarMap.lean:239) against `(generation _).1`.
  - ¬有终 and ¬全守 by the 全生成 exclusions.
  - 生成 on net 2 from the family {o4, o3}, as `generates_open` does on openNet 2. «全生成则生成» is at KeepingWidening.lean:231 and is not imported.
  - ¬守 at o3 by `not_keepsAfter_open (.inr rfl)` after «守则后守».

Or reword :99 to say which cells are proved and which follow by the named exclusions.

## MEDIUM

**3. The conditional law's Y, and the choices its "Y iff Z" rests on.** DESIGN:14, :16, :34, :132, :140, :151, :198; RoomNet:26, :63, :71–75, :425–427.

Problem:
- **(a) Y is glossed "warmth never ends along any branch".** «不穷» (Grammar.lean:237) says less: every occurrence a line of warmth reaches has a warm successor. A branch that leaves warmth is not a line, and «有常则往不穷» gives no more than that. The stronger reading happens to hold in the heated rooms (`heated_warm`, :129), but part A will take Y from these words.
- **(b) The iff and the unheated room's regions need a window that never closes** (the guard at RoomNet:63). If the window may close:
  - b1 gets the warm successor ⟨false, 2⟩, so «不穷» (net 0) alike s3 holds.
  - «有常» still fails: b1 steps to cold b0, and s3 has no cold successor. That is Y without Z.
  - s3 becomes 全生成, not 有终.
- **(c) They need "warm" to mean level ≥ 1.** If warm means at least the set point:
  - Z fails for c = 0, 1 and 2, and holds only from c = 3.
    - At c = 0, s3 steps to cold ⟨true, 2⟩, while ⟨true, 4⟩ steps only to warm.
    - At c = 1 and 2, ⟨false, 1⟩ steps to warm when shut, while ⟨true, 1⟩ steps only to cold.
  - Y holds for every c.
  - Stage 1 of warm-or-not then separates the rooms, as in the toy.
- **(d) Z is global and Y is local.** Z covers the whole carrier, unreached occurrences included; Y is a property of s3. (b), (c) and the joint-carrier example in finding 4 all use this asymmetry.

Fix:
- State (b) to (d) in §2 and §5 as the choices the iff depends on.
- Gloss Y as "no line of warmth from the set point ends".
- State "every branch stays warm" separately, from `heated_warm`.
- If a local Z is wanted, say it would be a new law.

**4. DESIGN:140 and :34: the counterexample to the converse is prose only.**

Problem: no Lean states ¬«有常» joint jointAlike or «不穷» joint jointAlike (c, s3). Both are true: (0, b1) steps to cold (0, b0), while warm (c, s3) has no cold successor. This is the "where Z fails" counterexample the plan asks for (丙一).

Fix: prove both lemmas. The first follows from «有亡之续则不有常» on ⟨⟨rfl, Unheated.b2_b1⟩, rfl⟩ with the end at (0, b1); the second from `heated_warm`. Or use 3(b)'s closable window as the witness. Then reword :34 to cite the theorem.

**5. "Finest class" and "nothing on the shut net tells them apart".** DESIGN:29, :117, :148, :193; RoomNet:21–22, :455–456.

Problem:
- **(a) jointLevel is not the finest class.** «静» (Grammar.lean:72, equality) separates (c, s3) from (c′, s3) at stage 0, because the tag is part of the occurrence.
- **(b) :29 holds only from the set point.** On jointShut, shut level 1 steps to 2, 3 and 4 for c = 0, 1, 2, and level 0 steps to 1, 2 and 3, so stage 1 of the level class separates all three rooms there. Only under warm-or-not does the shut net separate nothing.
- **(c) The tag is not explained.** c is a parameter of the rule carried in the occurrence and read by no class, so §4 compares rules side by side, not occurrences of one unfolding. The design does not say this.

Fix: write "from the set point, at the level class" in all four places and in the «» gloss, scope :29, and add one sentence on what the tag is.

**6. DESIGN:36–37 and :148: "fails as worded" on the shut net treats "cannot be tested here" as "false".**

Problem: at s3 nothing moves away from 3, so the shut net can neither confirm nor refute the guess there. The c = 2 heater's coupling does show on the shut net below the set point: level 1 steps to 4, a joint giving of 3 against a gap of 2 to m = 3, which is beyond `Flow.WithinGap`.

Fix: recast item (1) as "from the set point the shut net cannot test the guess". Keep item (2), that equilibrium's own exchange is a level-dependent coupling in 02 §8's sense, as the real objection to "needs none".

**7. Modelling choices are not stated where the laws depend on them.** DESIGN:7, :18, :67–71, :149, :181; RoomNet:43–51.

Problem:
- **(i) The surroundings are a supplied constant** that only the window switches, an unbounded reservoir. The World plan at :181 makes the outside a conserved condition, so its level would move; that is a different model.
- **(ii) The set point equals the shut surroundings' level.** «不开窗则同核» and "every room rests" (:18) need the set point at or below the shut surroundings. At set point 4 the shut thermostat cycles 4, 5.
- **(iii) The exchange is one unit per step whatever the gap.** This is what makes `next_open` a standing draw of one, and what makes the stage count 3.
- **(iv) The heater's supply never runs out**, so "warmth never ends" rests on a giving that is never drawn down.
- **(v) Heater, walls and window are terms of one rule, not occurrences**, so "held by a coupling" can only be compared across rules, through the tag.
- **(vi) :149 cites `Flow.settles`, which needs `L.Balances W` at every condition** (Regulation.lean:375). For one condition the right law is `Flow.settles_from` (:347).

Fix: add a "Modelling choices" paragraph to §2 naming each choice and the laws that depend on it, and cite `settles_from`.

**8. "What is new" misses existing results.** DESIGN:42–47, :53–61, :136, :156–182.

Problem:
- **(a) `RegimeMargin.Alternation` already shows this behaviour** (RegimeMargin.lean:1470–1510; 02-MAP.md:266, "Overcompensating giving can cycle for ever").
  - For levels from 3 up, the thermostat's open step is Alternation's step shifted by 2 (`heater 2 (z+2) = Alternation.giving z`).
  - `rests_within` (:1118) needs a giving that rises with the level, which this heater's does not.
  - So `Thermostat.alternates` and `holds_one_way` are instances of an existing witness.
- **(b) Map witnesses already inhabit the renewal regions.** `Map.Short` (GrammarMap.lean:403–442) gives 新而有终 and 新而尽, just as `Map.«生守相杂»` gives the mixed region.
- **(c) Two grammar laws shorten and join the work.**
  - «核之单调» (Grammar.lean:570) gives the toy's warm-or-not form from «不开窗则同核» in one line.
  - «类有常当且仅当含于核» (Grammar.lean:574) joins §5 to §4: within one room, warmth lies in its own core exactly where 1 ≤ c.
- **(d) Regulation already has a late thermostat.** `Regulation.relay` with `relay_runs` and `relay_threshold` (Regulation.lean:1175, :1985, :1997) is 02 §8's late thermostat as a World flow, with a threshold past which it oscillates.
  - §1 lists it at :59 but never relates it to the heater.
  - `course` and `courseFlow` (:853–859) are the route to the World instance and the late heater listed as not done at :181–182.
- **(e) Every new theorem is about this one family**, and no new law holds for every carrier. "What is new" should say so.

Fix: cite (a) to (d) where they bear, and add that line.

**9. Names.** DESIGN:10, :193–204; RoomNet:44, :258, :335, :536.

Problem:
- «二恒温以温不可分» calls every room with c ≥ 1 a 恒温 (thermostat), yet the design's thermostat is c = 2, and the c = 1 room is 全守, not 生成.
- Calling c = 1 "a control" (:10) misleads; the baseline is the unheated room.
- «给如所取则全守» and «恒温生守相杂» read as laws for every carrier but are stated for one value of c.
- The placement is mixed: the «» names inside `Rooms.Unheated`, `Matched` and `Thermostat` repeat the model in their full names, while the family laws sit at `Rooms`.
- `outside` names the surroundings' level, which is not the glossary's sense of outside (GLOSSARY.md:20).

Fix:
- Call c = 1 and c = 2 the matched heater and the overshooting heater.
- Use model-scoped «» names, e.g. «有给之室以温不可分» and «给过所取则生守相杂».
- Choose one placement convention.
- Rename `outside` to `surroundings`.

## LOW–MEDIUM

**10. The list of laws used is wrong.** DESIGN:47, :54, :133, :178.

Problem:
- «有终则粗不有常» and `RegimeMargin.ends_beyond_giving` appear in neither module (grep finds 0). The Lean uses «有亡之续则不有常» (RoomNet:419) and `stays_ended` (RoomRuns:66) instead.
- :178 omits laws that are used: «有亡之续则不有常», «有常之逐点», «闭之及», and the exclusion laws.
- The §5 row at :133 tests a law the Lean never uses and has no "where Z fails" entry.

Fix: correct the lists. Either add the instances (e.g. «有终则粗不有常» ⟨s3, stays_shut 0 3, rfl⟩ Unheated.ends) or name the laws actually used.

**11. Non-widening is claimed too widely, and two readings of 全生成 are joined.** DESIGN:58, :60, :111, :138, :175.

Problem:
- Non-widening is proved only for the window course from s3 at c = 0, 1, 2 (RoomRuns:97, :130, :138), not for "every course of every room".
- :111 joins two different things with no bridge:
  - §3's 全生成 on net 2 with (alike, sameLevel);
  - `generation_at_moments`' 全生成 on `Steps.next` with («一», level).
- For KeepingWidening (:60), "does not apply" is the accurate wording, not "none of its premises hold".

Fix: scope the claim to the window course, and keep the two readings apart or prove the bridge.

## LOW

**12. A generalization and a non sequitur.** DESIGN:31, :122, :106.

Problem:
- "The coarser the class, the deeper the stage" generalizes one threshold choice. With warm meaning ≥ 3, stage 1 already separates (3c). The only general fact is that a finer class separates no later.
- At :106, keeping along the shut branch rules out 退化 but not 生成; the thermostat's s3 is both (:108).

Fix: say "here", tie the stage count to the class threshold, and give the actual reason at :106.

**13. Prose that is unproved or too general.**
- :25: 新而尽 holds at b2 but not at b1, whose only successor is cold.
- :76: the claim is true, but the reason is that `joint` keeps the tag.
- :109: "b0 is 全守" is true but unproved.
- :110: "whole possible" needs a warm start; `heated_possible_held` has `warm x = true` (RoomRuns:203).
- :152: "Rest and exact regulation fall in one region" relies on unproved 全守 at s3 on the shut net.
- :154: at the level class, a gust of 2 separates the rooms (shut level 1 steps to 2, 3, 4).

**14. Docstrings that misdescribe their statements.**
- RoomNet:85 `stays_shut`: it holds at every level, not only at the set point.
- RoomNet:108 `begins_open`: the bold says "exactly where", but only one direction is proved.
- RoomNet:113 `not_begins_s3`: "begins nothing" overstates "is not a beginning at its level".
- RoomNet:376 `closed_open`: the docstring describes a set; the statement is that {o4, o3} is closed under net 2.
- RoomRuns:62 `window_cold`: "a draw beyond all giving" is `ends_beyond_giving`'s premise, but the proof applies `stays_ended` with `Short (heater 0) 1 4`.
- RoomNet:425: see 3(a).

**15. Replacing the toy (DESIGN:42, :53) would touch landed texts.** These cite «恒温与平衡»:
- `/Users/ren/theories/.claude/worktrees/ou5-check/theories/becoming/chapters/03-KNOWING.md:92`. This is the home section, and it says "the first stage" tells the rooms apart; on the rule-built nets it is the third stage of warm-or-not.
- The records `testing-within-the-net.md` and `.json`.
- `GrammarCases.lean:14`.
- `/Users/ren/theories/.claude/worktrees/ou5-check/theories/becoming/review/LOGIC.md` (L-12).
- `development/ou5-testing/study_ou5.txt:7–9`.

Fix: say the models stand beside the toy, or list what a replacement must change, record and home section together.

**16. DESIGN:182 is unclear.** `no_narrower_band` bounds the band a rule keeps against every rest within a step size d; it does not separate two rules. Restate it with ReadsLate and `late_spread`.

**17. DESIGN:142, the part A reading.** The grammar's «通» (GrammarReadings.lean:113: never ending in both directions) fails at the thermostat's s3. Going backward, s3 is preceded by ⟨false, 4⟩, which is preceded by ⟨false, 1⟩, and nothing leads to ⟨false, 1⟩ (no level l has `next 2 3 l = 1`). Also, the grammar's 穷 is a line's ending, not a level below the set point. Note both, or drop the 通 clause.

**18. The ten-minute part (DESIGN:5–47).**
- Region names are used without glosses.
- The readings at :36–40 have no AI-reading label.
- "Rest's region" for 全守 (:26) is not chapter 02's term, and 全守 allows an earlier renewal (02-MAP.md:43, `Map.Once`).
- Walls and window are both named as the agent of the exchange.
- The Y column is missing in row :137.
- `At` is a weak type name.

## Checked and sound
- **Build and branch:** the build log matches the sources, and both axiom reports are empty (91 declarations with 67 theorems; 23 with 20; unclean []). Branch `ou5-check` (commit `c896e1001`) adds only the four `check/` files and changes no package file. `.build` is git-ignored.
- **The bridge:** `next_open` (in Nat, `exchange 0 x = x − 1`), `window_line` and `windowAt_level` are correct.
- **§2 and the courses:** the fixed points in §2 and the courses at :19–21 are right. I checked by hand the claim at :82 that with set point 2 nothing is 新而尽.
- **Region theorems:** every region theorem that is stated holds, as do the rows theorems as far as they go.
- **Stage facts in §4:** all hold, including stage 2 holding and stage 3 failing.
- **The two family iffs** hold as stated in Lean.
- **RoomRuns:** `window_cold`, `window_held`, `alternates`, `holds_one_way`, the three `not_widening` lemmas, `generation_at_moments`, `line_iff_held`, `cold_not_held` and `heated_possible_held` all hold.
- **§6.2 arithmetic:** the shut unheated room meets Opposes and WithinGap at m = 3 at every level, and the c = 1 room's shut steps stay within the gap at every level.
- **The HeldPossible process bridge** is exact.
- **Method:**
  - The possible-net reading and its conflict relation are declared, and the window is part of the net, not an outside intervention.
  - The Hennessy–Milner direction is correctly left unused as a calibration.
  - Avoiding «闭» for "shut" is right.

---

**The re-check**, returned on the revision at `6c945b760`:

The revision holds up. Of the 18 findings, 14 are fully taken and 4 partly (9, 11, 15, 18). The changes introduced 7 new problems: two false claims in the text, and five small Lean-docstring and text slips. The ten-minute part reads correctly on its own apart from four gaps.

I stayed read-only. `build8.log` is the right log for these files: the `.build` copies of both modules are byte-identical to the current sources.

Paths below are relative to S = `/private/tmp/claude-501/-Users-ren-theories/b7c6b747-6b9c-4356-8b68-e395f26999fa/scratchpad/ou5m/`, so DESIGN means `S/DESIGN.md`, and RoomNet and RoomRuns are under `S/Becoming/`.

## (1) Your 18 findings against §9's "how taken"

1. Taken.
2. Taken. Every cell of the table at DESIGN:116–121 now has a Lean statement, and the renewal column is `renewing_steps`.
3. Taken.
4. Taken (`joint_converse`, RoomNet:794).
5. Taken. A new false claim on the same point appears elsewhere (new problem 1).
6. Taken.
7. Taken.
8. Taken.
9. **Partly.** The two «» renames are left to OU's owner (DESIGN:256–258) rather than applied. The deferral is stated, so this is fine if the owner keeps the names.
10. Taken.
11. **Partly.** §3 (:137) and §7 now scope non-widening correctly. But DESIGN:70, :72 and the §5 row at :174 still say it of every window course, and the overshooting thermostat's course is proved only at margin 3.
12. Taken.
13. Taken.
14. Taken.
15. **Partly.** The entry says "no landed text changes", but §8 note 1 (DESIGN:237) plans a clause in GrammarTesting's header at landing. The entry should say so.
16. Taken.
17. Taken.
18. **Partly.** "The row's Y is stated" is not true of the `Run.generation_of_held_changes` row (DESIGN:173): its "where Z fails" cell still gives no Y. There Y fails, since no moment is 全生成. The other gaps are under (3).

## (2) New problems, most severe first

1. **DESIGN:89, "the level class is the finest the rooms share", is false.** Equality on the occurrence alone (window and level, tag ignored) is finer and also ignores the tag. `«不开窗则同核»`'s witness works at it too. Fix: "the finer of the two classes used here".
2. **DESIGN:31 and :144 are scoped too widely.** §4 opens (:142) with "at every margin m unless a condition is stated". The two claims are "below it, the shut net does" (:31) and "shut at level 1, the three rooms step to 2, 3 and 4" (:144).
   - At margin 2, shut level 1 steps to 2 for every c; only level 0 separates the rooms (1, 2, 3).
   - At margin 1, no shut step separates the rooms anywhere.
   - So the hand check at :144 is true only from margin 3, and "below it" only from margin 2.
   - Fix: write "from a margin of two on", and give the 2, 3, 4 example "at a margin of three".
3. **Docstrings that claim more than their statements prove:**
   - RoomNet:563–564, `shut_rests`: "rest and the matched heater's regulation lie in one region" also needs `«给如所取则全守»`; the theorem covers the shut net only.
   - RoomRuns:158–160, `alternation_shifted`: "Overshooting.holds_one_way [is] that witness's" goes too far. Only its [3, 4] half follows from the shift; the Meets/Keeps half does not.
   - RoomNet:612–613, `alike_in_core_iff`: omits the positive set level the statement requires, and the claim is false at m = 0.
   - Wording slips:
     - RoomRuns:136 and DESIGN:213 say "Above two", but the statement holds from two on.
     - RoomNet:618, `cools_to`, says "above 1", but the statement covers 1 as well.
4. **DESIGN:106, at margin 1, "有终 is not inhabited there either".** The open occurrence at 1 is 有终, since its only successor is cold. The room does not reach it, but the carrier holds it. Fix: "at no occurrence reached from the set level", as the margin-two sentence already does.
5. **DESIGN:68** attributes `«及之单调»` to GrammarLaws; it is in Grammar (Grammar.lean:100).
6. **The build log.** DESIGN:3 and :194 link `scratch-build.log`, and the worktree's copy is still the old 91/67 log. Replace it with `build8.log` when the revision moves.
7. **RoomRuns:99–101 and :120–122:** docstring lines are broken mid-sentence.

## (3) The ten-minute part (DESIGN:5–57)

It is correct and readable alone, and nothing in it conflicts with chapter 02's region glosses. Chapter 02 also counts 有终 among the three strong forms. Four gaps remain:
- "Core class" and "stage" (:31–34) are used without a gloss, unlike the regions. One sentence would do, along the lines of: two occurrences are one core class when every step from either can be matched by a step from the other, indefinitely, with their classes never differing; stage n checks n such steps.
- :31's "below it, the shut net does" needs the margin scope from new problem 2.
- :26 never says the overshooting thermostat is 生成, so "the mixed region" goes unexplained. Write "生成 along the window's branch and 守 along the shut one".
- :38's "under 缘" is unglossed; "under the net's steps" would do.
