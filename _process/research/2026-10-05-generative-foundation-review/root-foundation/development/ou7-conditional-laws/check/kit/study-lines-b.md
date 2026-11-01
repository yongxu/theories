Part B's lines for OU7's study section in `BECOMING-RENEWAL-READING.md` (AI-written; the section's owner joins them to part A's and fills the receipt, the counts and N). The design is [check/DESIGN.md](../DESIGN.md), its review and re-check [check/review/FINDINGS.md](../review/FINDINGS.md).

```text
Result(s): rooms-tested-by-a-window (new, home 03 §3, after testing-within-the-net).
Delta:
  - One rule makes the nets of a family of rooms (Becoming.RoomNet): a level in whole units moves one unit a step
    toward surroundings at the set level m while the window is shut and at 0 once it opens; a heater reading the
    level after the exchange gives c wherever it is below m. The unheated room (c = 0) is thermal equilibrium, the
    matched thermostat (c = 1) gives what the window draws, the overshooting one (c = 2) more. The window's opening
    is in the net as an alternative; rooms are compared as rules on a carrier tagging each occurrence with its
    heater.
  - Testing: while no window opens every room at its set level is one core class at the level, at every margin
    («不开窗则同核»); with the window in the net the level's first stage tells the unheated room from every heated
    one at every positive margin («开窗则一层可分»), and under warm or not, at a margin of n + 1 draws, stage n
    holds and stage n + 1 tells them apart («开窗以温层如其余乃分»); two heated rooms stay one core class
    («有给之室以温不可分»). «恒温与平衡»'s stipulated branches are the rule's at a margin of one draw, and its
    verdict follows from the stage law there (toy_branches, toy_verdict): the toy stays and is derived.
  - Regions: at a margin of three the overshooting thermostat is 全生成 and keeps at its set level, a model case
    of Map.«生守相杂» («给过所取则生守相杂»); the unheated room keeps and reaches an end, and degenerates while
    renewing once open («平衡守而有终», «开窗则平衡新而尽»); at every positive margin the matched thermostat is
    全守 («给如所取则全守»), as every room is while no window opens (shut_rests). The single-line law tested both
    ways (Overshooting.single_line_tested).
  - A conditional law: at every positive margin warmth is constant under the net exactly where the heater gives
    («温有常当且仅当有给»); from a margin of two on, no line of warmth from the set level ends exactly there
    («温不穷当且仅当有给»); at a margin of one none ends (unended_at_one); across rooms the converse of «有常则往不穷»
    fails (joint_converse).
  - The bridge (Becoming.RoomRuns): with the window open the rule is RegimeMargin's step with the heater's giving,
    so stays_ended and holds apply as they stand (holds at a positive margin); at a margin of three the overshooting
    course is RegimeMargin.Alternation's run shifted by two; none of the three window courses keeps widening; the
    overshooting course's moments are 全生成, and no moment of the unheated course, or of the matched one at a
    positive margin, is; a coarse line is the possible with warmth held (HeldPossible).
Supplied premises / correspondence: the modelling choices are the record's hypotheses (whole-unit levels,
       surroundings switched by the window, a window that never closes, warm as a level of at least 1, the
       heater reading after the exchange, the nets read on the possible, rooms compared as rules); the
       variants of the window, the threshold and the reading order are checked by hand (DESIGN §2). The
       correspondence to thermostats, equilibrium, bisimulation and testing equivalence is the record's.
Evidence: core receipt (filled at landing); Becoming.RoomNet (94 theorems in 120 declarations) and
       Becoming.RoomRuns (24 in 27), every axiom report empty. One independent AI review (18 findings) and its
       re-check, every point taken; heated_unended, the two theorems on moments where the level stops
       changing, and the renames and module docs written after the re-check were not reviewed again.
Standing: model examples of 验 on the grammar; each law is a short proof on one constructed family, none
       claimed new as mathematics. What they add is one mechanism placing the stipulated witnesses
       (Map.«生守相杂», «恒温与平衡», RegimeMargin.Alternation) and the tests between them.
Boundary:
  - That the rooms are the World's flows: 02 §8's laws of regulation are read against their definitions only.
  - That regulation has a region of its own: matched regulation is 全守, as rest is.
  - The regions at margins other than three; gusts; a heater that reads late; the Hennessy–Milner direction.
Output → input: the record's next step, an instance on the World's flows, by which 02 §8's laws apply formally.
```
