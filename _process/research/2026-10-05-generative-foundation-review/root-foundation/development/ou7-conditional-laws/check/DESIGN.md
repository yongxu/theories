# OU7 part B: two models for testing (验) on the net of the possible

Board item OU7 (claimed as OU5), part B: plan §八 step 5, "验之模型例（恒温器与热平衡，在可能之网中）" ([plan](../../one-unfolding-root/PLAN.md)). Design for OU's owner, who decides what goes into Lean. The scratch Lean is in [`scratch/`](scratch/), outside the package; it changes no package file. Both modules build with `scratch_build.py` with no warning, and every axiom report is empty, transitively through `RegimeMargin` and `HeldPossible`, so no piece needs the periphery ([log](scratch-build.log)). §7 lists what each module proves. OU's owner approved the «» names with three notes, each taken, and after the review renamed two of them (§8). One independent review read the design, and the same reader re-checked the revision; its 18 findings, the re-check's points and how each was taken are in §9, and both reports are kept verbatim in [review/FINDINGS.md](review/FINDINGS.md). AI-written.

## The ten-minute part

**One mechanism makes both nets.** A room has a level, in whole units of heat. Its surroundings are at its set level `m` while the window is shut and at 0 once it opens. Each step the level moves one unit toward the surroundings' level. A heater then reads the level left and gives `c` units where that is below `m`. So `m` is the room's margin, counted in the open window's draws of one. Three rooms are compared:
- thermal equilibrium, `c = 0`, the unheated room;
- the matched thermostat, `c = 1`, whose heater gives exactly what the open window draws;
- the overshooting thermostat, `c = 2`, whose heater gives more.

The regions are read at a margin of three, the matched thermostat's at every positive margin (§2 says why three). The testing laws and the conditional law hold at every margin, under the conditions they state. Every law here is about this one family of rules: none is a new law for every carrier.

An occurrence is a pair: whether the window is open, and the level. There are two relations:
- `shut`: only steps with the window shut;
- `net`: the window's opening is in the net. From a shut occurrence the room may stay shut or open the window; an open window stays open.

On `net` the successors of an occurrence are alternatives: the possible-net reading of plan §4.1. Staying shut and opening at one step conflict; that conflict relation is declared beside the net and not formalized. The classes are the level class (the same level) and warm or not. Warm means above the open surroundings, a level of at least 1. A heater is a term of its room's rule, not an occurrence, so rooms are compared side by side on a carrier that tags each occurrence with its `c`: rules compared, not occurrences of one unfolding.

**The courses.** At its set level with the window shut, every room rests: the exchange moves nothing, and the heater gives nothing. When the window opens, at a margin of three:
- the unheated room falls 3, 2, 1, 0 and stays cold;
- the matched thermostat stays at 3: the window draws a unit, and the heater gives it back;
- the overshooting thermostat goes 3, 4, 3, 4, …: from 3 the heater overshoots to 4; from 4 the exchange takes a unit, and the heater, reading 3, gives nothing.

**The regions,** in chapter 02's terms. A *carrying renewal* (传) is a step along which the pattern (here warmth) goes on and a line of the part (here the level) begins. *Generation* (生成): along some branch the pattern goes on, with a carrying renewal always ahead. *Keeping* (守): along some branch it goes on with no carrying renewal. *Degeneration* (退化): it ends on every branch. Of the strong forms, which read the whole line, *全生成* means no line of the pattern ends (不穷) and a carrying renewal can always be reached; *全守* means no line ends, and from some point no carrying renewal can be reached, earlier ones allowed; *有终* means some line reaches an end. *新而有终* and *新而尽* renew and still reach an end, or degenerate. Read on `net` at warm or not and the level class:
- **The overshooting thermostat** at its set level, window shut, is 生成 along the window's branch and 守 along the shut one, and as a strong form 全生成. So it lies in the mixed region 生守相杂, here made by a mechanism. It is a model case of `Map.«生守相杂»`, which shows the region on a stipulated fork, and a stronger one, since it is 全生成. After the window opens it is still 全生成: every step is a carrying renewal.
- **The unheated room** at its set level, window shut, keeps along the shut branch and reaches an end along the window's, where warmth ends. It is neither 生成 nor 退化, and it is 新而有终. Once its window opens, at the open occurrence at 2, it degenerates while renewing: 退化 and 新而尽.
- **The matched thermostat** is 全守 before and after the window opens, at every positive margin: from its set level on nothing renews at the level class. So is every room while no window opens.

**Testing.** Two occurrences are one core class (`«核»`) when each step from either is matched by a step from the other into a pair matched in turn, indefinitely, the two of every pair in one class. Stage `n` (`«层»`) asks this for `n` steps only, so a stage that tells two occurrences apart shows they are not one core class (`«可分则不在核»`).
- Without the window in the net, every room at its set level is one core class at the level class, at every margin. From the set level nothing on the shut net tells a heated room from an unheated one. From a margin of two on, the shut net does below `m - 1`, where the heater still gives after the exchange (§4.1).
- With the window in the net, at every positive margin, the first stage of the level class tells the unheated room from every heated room.
- Under warm or not, the first stage that tells them apart is the margin. At a margin of `n + 1` draws, stage `n` does not tell them apart and stage `n + 1` does: the open window takes the margin's draws to empty the unheated room's warmth, and the stage counts them. So here the coarser class needs the deeper stage, because warm means a level of at least 1; a threshold at the set level would separate them at stage 1 (§2, choice 7).
- Warm or not does not tell the two thermostats apart. Warmth tests whether warmth goes on, not how it is kept.

**The toy, derived.** `«恒温与平衡»` in `GrammarTesting` stipulates its rooms' branches: the balanced room "may cool", the held room "may be kept warm". At a margin of one draw these are the rule's own branches (`toy_branches`). The toy's verdict, that the first stage of warm or not tells its two rooms apart, follows from the stage law at that margin (`toy_verdict`). The toy stays as it is; the rule generalizes it.

**A conditional law, tested.** Z is "warmth is a constant class under the net's steps" (`«有常»`), and Y is "no line of warmth from the set level ends" (`«不穷»`). On this family:
- Z holds exactly where the heater gives (`1 ≤ c`), at every positive margin. There, by `«有常则往不穷»`, Y holds; more, every branch stays warm (`heated_warm`).
- Without a heater Z fails, and from a margin of two on Y fails too.
- At a margin of one, Y holds heater or not (`unended_at_one`): the window's single draw takes the unheated room straight out of warmth, so no warm occurrence is the last of warmth's line.

So from a margin of two on, Y holds exactly where Z does. Across rooms the converse fails: beside the unheated room, Z fails on the joint net while Y holds at a heated room's set level (`joint_converse`). The iff rests on choices of the model (§2): a window that never closes, warm meaning a level of at least 1, and Z being global while Y is local.

**The guess, tested** [AI reading]. The guess was: a thermostat's keeping is held by a coupling that reads the level, and equilibrium's needs none.
- From the set level the shut net cannot test it: every room rests there.
- "Needs none" fails against 02 §8's definition. The shut room's own exchange opposes the level's departure from its set level on both sides, within the gap, so equilibrium's keeping is held by a coupling that reads the level too.

What does tell the rooms apart is whether warmth goes on when the window opens. With a heater it does; without one, the level follows the surroundings down to 0. That holds whether the heater reads the level after the exchange or before it, from a margin of two on (`next_pos`, `before_pos`). Whether the window moves the held level depends on that order: read after the exchange, as here, the heater answers the draw within the step, and the matched thermostat holds its set level; read before it, the window moves both thermostats' levels (`before_window_moves`). The map has no region for "held by regulation": the matched thermostat's regulated keeping is 全守, as rest is, and the overshooting thermostat's is 全生成.

**What is new.** A rule that generates the nets, generalizing `«恒温与平衡»`'s stipulated branches and deriving its verdict. On it:
- the regions;
- the stage law at every margin;
- the constancy law with the margin it needs, and its converse failing across rooms;
- the bridge: the open window's course is `RegimeMargin`'s run, a draw of one and the heater as the giving.

The regions are inhabited already by stipulated witnesses (`Map.«生守相杂»`, `Map.Short`), and the overshooting course is `RegimeMargin.Alternation`'s run shifted by two (`Overshooting.alternation_shifted`). What the models add is one mechanism that places all of them, and the tests between them. Through the bridge, `RegimeMargin.stays_ended` and `holds` apply as they stand, and so do `HeldPossible`'s `Run.not_keepsWidening_of_returns`, `Run.generation_of_held_changes` and `Steps.generation_iff_begins`. Every other law used exists already. Not done: an instance on the World's flows, which 02 §8's laws need before they apply formally; gusts; a heater that reads late.

## 1. What exists, and what the models use

| module | what it states | used here |
|---|---|---|
| `Grammar` | `«核»`, `«有常»`, `«有常之逐点»`, `«有亡之续则不有常»`, `«核之单调»`, `«类有常当且仅当含于核»`, `«及之单调»`, `«线内同类»` | constancy; the core's monotonicity (§4); warmth in its own core (§5); a coarse line read on the process (`line_iff_held`, `Unheated.cold_not_held`) |
| `GrammarTesting` | stages `«层»`; `«核在每层之内»`; `«可分则不在核»`; the toy `«恒温与平衡»`, with stipulated branches (the balanced room "may cool", the held room "may be kept warm"), told apart at stage 1 of warm or not | stages and the one theorem direction; the toy, which the models derive at a margin of one draw (§4) |
| `GrammarMap` | `«传»`, `«生成»`, `«守»`, `«退化»`, `«全生成»`, `«全守»`, `«有终»`, `«新而有终»`, `«新而尽»`, `«所及之传递»`; `«有常则无终»`, `«有终则粗不有常»`; the exclusions; the witnesses `Map.«生守相杂»` (a stipulated fork) and `Map.Short` (新而有终, 新而尽) | the regions and their exclusions; the ending law |
| `MapRegions` | `«后守»`, `«守则后守»`, `«单行则生成后守不并»`, `«后守退化不并»`, `«三域之周»`, `Map.generates_iff_changes`, `Map.keepsAfter_iff_settles` | keeping from some point on; the single-line law tested (§5) |
| `GrammarReadings` | `«有常则往不穷»` (constant and continued: no line from the point ends); `«通»` | the conditional law's Y |
| `GrammarLaws` | `«闭»`, `«闭之及»` | the reach invariants |
| `RegimeMargin` | a draw `H` then giving `g` of what is left (`step g H x = (x - H) + g (x - H)`); `Short`, `Meets`, `Keeps`; `stays_ended`, `holds`, `ends_beyond_giving`, `ends_iff_below`; `Alternation`, a giving that cycles for ever | the open window's course is `step (heater m c) 1`; `stays_ended`, `holds`, and `Alternation` shifted by two |
| `HeldPossible` | the possible with a part held; on the root it is the start's line under the part (`Reaching.reach_heldMoves_iff`, `Reaching.possibleHeld_iff_line`); `Run.not_keepsWidening_of_returns`, `Run.generation_of_held_changes`, `Steps.generation_iff_begins` | a coarse line is the possible with warmth held; the window courses do not keep widening, at the margins proved (§3); the overshooting course's moments are 全生成, and no moment of the other two courses is |
| `Regulation` (02 §8) | `Flow.Opposes`, `Flow.WithinGap`, `Flow.settles_from` (one condition), `Flow.not_at_of_beyond`; overshooting; rules reading late (`ReadsLate`, `late_spread`); the relay, 02 §8's late thermostat as a World flow (`relay`, `relay_runs`, `relay_threshold`); `course`, `courseFlow` | read only (§6): the rooms are not built as World flows |
| `KeepingWidening` | what a World course whose range keeps widening needs | does not apply: the rooms are not World courses, and the window courses proved here do not keep widening (§3) |
| `RevisionRoutes` | when no route of keeping a formation's law stands above letting a revision go through | does not apply: no room has an act that keeps its rule against a revision; a changed set level is another relation, not a branch of this net |

## 2. The models

The «» names are approved (§8); the English names are provisional. Everything is in the grammar except the bridge module (§7).

- **Occurrence.** `Rooms.Occurrence`: `opened : Bool`, `level : Nat`.
- **Surroundings.** `surroundings m opened` is `0` if open and `m` if shut.
- **Exchange.** `exchange σ x` moves the level one unit toward `σ`: `x + 1` below it, `x - 1` above it, `x` at it.
- **Heater.** `heater m c z` is `c` where `z < m` and `0` otherwise. It reads the level `z` left after the exchange.
- **Rule.** `next m c σ x` is `exchange σ x + heater m c (exchange σ x)`.
- **Nets.**
  - `shut m c x y`: both shut, and `y.level = next m c m x.level`.
  - `net m c x y`: `x` shut or `y` open, and `y.level = next m c (surroundings m y.opened) x.level`. The step uses the window as it is after the step's choice.
- **Start.** `start m` is the room at its set level with the window shut.
- **Classes.** `sameLevel x y` is `x.level = y.level`. `alike x y` is `warm x = warm y`, with `warm x` meaning `1 ≤ x.level`. `alike` is an equivalence: its two classes are warm and cold.
- **Joint nets.** To compare rooms, the carrier `Nat × Occurrence` tags each occurrence with its room's `c`. `joint m` steps by `net m x.1` and keeps the tag; `jointShut m` does the same by `shut m`. The classes `jointLevel` and `jointAlike` read the second component only. Because `joint` keeps the tag, no step leaves a room, and the core of one pair is unaffected by the other rooms in the carrier. The tag is a parameter of the rule carried in the occurrence and read by no class, so §4 compares rules side by side, not occurrences of one unfolding. Equality on the tagged carrier (`«静»`) separates every two rooms at stage 0. Of the two classes used here the level class is the finer; equality on the occurrence with the tag ignored would be finer still.

**The carrier holds every pair, reached or not.** The rule gives every pair its successors, and that is how unreached occurrences matter:
- **`«生»`.** A predecessor in an occurrence's own level class is a fixed point of the rule at that level. Open, the fixed points are level 0 for `c = 0`, levels 1 to `m` for `c = 1`, and none for `c = 2`; shut, level `m` is one for every `c`.
- **`«有常»`.** Constancy is global, so §5 states it for the whole carrier.

**Modelling choices,** and the laws that depend on them:
1. **The surroundings are a supplied constant**, switched only by the window: an unbounded reservoir. A World instance with the surroundings' heat as a conserved condition would be another model, in which the surroundings' level moves.
2. **The set level equals the shut surroundings' level**, one parameter `m`. `«不开窗则同核»`, `shut_rests` and "every room rests" depend on it: with surroundings at 3 and a set level of 4, the shut overshooting thermostat cycles 4, 5 (checked by hand).
3. **The exchange is one unit a step, whatever the gap.** It makes the open course `RegimeMargin`'s step with a draw of one (`next_open`), and the stage of separation the margin counted in draws.
4. **The heater's supply is unlimited**, so "no line of warmth ends" rests on a giving that is never drawn down.
5. **Heater, walls and window are terms of one rule, not occurrences.** "Held by a coupling" can only be compared across rules, through the tag; nothing in one net is the coupling.
6. **The window never closes once open** (the guard in `net`). If it may close, the unheated room's open occurrence at 1 gets a warm successor, the room shut again at 2, so no line of warmth from its set level ends while warmth is still not constant: Y without Z. Its set level is then 全生成, not 有终 (checked by hand, not in Lean).
7. **Warm means a level of at least 1**, above the open surroundings, so warmth is exactly `RegimeMargin`'s condition, a positive level. If warm meant at least the set level, at a margin of three Z would fail for `c = 0`, 1 and 2 and hold only from `c = 3`, Y would hold for every `c`, and the first stage of warm or not would separate the rooms, as in the toy (checked by hand).
8. **The heater reads the level after the exchange**, so it answers the window's draw within the step. Read before the exchange (`nextBefore`), the window moves the thermostats' levels (`before_window_moves`), and at a margin of one it takes even a heated room out of warmth (`before_at_one`); from a margin of two on, every step of a heated room lands warm under either order (`next_pos`, `before_pos`). Without a heater the two orders are one rule (`before_unheated`).
9. **Z is global and Y is local.** `«有常»` covers the whole carrier, unreached occurrences included; `«不穷»` is a property of the start. Choices 6 and 7 and the joint carrier (`joint_converse`) all turn on this asymmetry. A Z local to what the start reaches would be a new law, not one the grammar has.

**Why a margin of three for the regions.** With open surroundings at 0 and a draw of one a step, three is the least margin at which every region in §3 is inhabited. At a margin of two the unheated room's window line has a single warm open occurrence, and no occurrence it reaches from its set level is 新而尽 (by inspection, not proved; an open occurrence at 2, which the carrier holds but the room does not reach, is). At a margin of one no line of warmth from the unheated room's set level ends (`unended_at_one`), so no occurrence it reaches from there is 有终 (the open occurrence at 1, which the carrier holds but the room does not reach, is). The matched thermostat's regions need no margin of three, and are proved at every positive margin.

**The models' two readings, stated as plan §4.1 asks.** `shut` and `net` use the possible-net reading: successors are alternatives. The window is in the net and is not an intervention from outside it. Testing is said within the net (plan §4.4), and the stages are the relations of the observations.

## 3. Regions, and why

Read on `net m c`, `L = alike`, `E = sameLevel`, at the occurrences each room reaches from its set level with the window shut: at a margin of three for the unheated room and the overshooting thermostat, at every positive margin for the matched thermostat. "✓ (shut branch)" names the branch that witnesses it.

| occurrence | 生成 | 守 | 后守 | 退化 | 全生成 | 全守 | 有终 | renewal |
|---|---|---|---|---|---|---|---|---|
| unheated, `start 3` | no | ✓ (shut branch) | ✓ | no | no | no | ✓ (window branch) | 新而有终 |
| unheated, open at 2 | no | no | no | ✓ | no | no | ✓ | 新而尽 |
| matched, `start m` | no | ✓ | ✓ | no | no | ✓ | no | none |
| matched, open at `m` | no | ✓ | ✓ | no | no | ✓ | no | none |
| overshooting (`c = 2`), `start 3` | ✓ (window branch) | ✓ (shut branch) | ✓ | no | ✓ | no | no | the opening and every open step; not the shut step |
| overshooting, open at 4 or 3 | ✓ | no | no | no | ✓ | no | no | every step |

Every cell is proved in `RoomNet`:
- the headline theorems of §8, with `Overshooting.generation_strong`;
- `Unheated.rows`, `Matched.rows` and `Overshooting.rows`, one theorem per room, which state every remaining cell and derive most of them by `«守则后守»` and the landed exclusions (`«全生成有终不并»`, `«全守有终不并»`, `«全生成全守不并»`, `«生成退化不并»`, `«后守退化不并»`, `«守退化不并»`);
- `Overshooting.not_keepsAfter_open`;
- the renewal column: the headline theorems for the unheated room; `Matched.no_renewal`, no carrying renewal at any occurrence reached; `Overshooting.renewing_steps`: the opening is a carrying renewal, and so is every step from an open occurrence reached, while the shut step is not.

Two more rows, at every margin: while no window opens every room at its set level is 全守 (`shut_rests`), and the unheated room's cold open occurrence keeps its coldness, 全守 at the other class of warm or not (`cold_rests`).

Why:
- **Carrying renewal.** A step is a carrying renewal (`«传»`) where it stays within one class of warm or not and its end's level is not a fixed point of the rule that steps into it (`begins_open`); a step into a fixed point never is one. The overshooting thermostat's open steps 3 → 4 → 3 change the level, and neither level is a fixed point, so every one is a renewal. The matched thermostat's open step `m → m` is a fixed point, so no step it reaches renews.
- **The unheated room's window branch.** Its steps 3 → 2 → 1 renew, but 1 → 0 leaves warmth. The line ends at the open occurrence at 1 (`«亡»`), so `start 3` reaches an end (有终). It is not 退化, because it keeps along the shut branch (`«守退化不并»`). It is not 生成: a generating family holding `start 3` needs a carrying renewal ahead between members whose lines go on, and the only renewals ahead lie on the window's branch, whose warmth ends (`Unheated.not_generates`).
- **Once the window opens** the unheated room has one branch, and that branch ends: 退化 at its open occurrence at 2. It renews at 2 → 1 before it ends: 新而尽. The open occurrence at 1 is 退化 but not 新而尽, since its only successor is cold.
- **生守相杂.** At the overshooting thermostat's `start 3` the net branches. The window branch generates and the shut branch keeps, so `start 3` is 生成 and 守 at once: `Map.«生守相杂»`'s fork, with the window's branch as the chain and the shut branch as the still occurrence. As a strong form it is 全生成: no line of warmth ends, and a renewal lies ahead of every point reached (the opening is ahead of `start 3` itself). 全生成 and 守 do not exclude each other; 全生成 and 全守 do (`«全生成全守不并»`).
- **On HeldPossible.** By `Reaching.reach_heldMoves_iff`, what a coarse line reaches from `x` is what is possible from `x` with warmth held. The regions are read on each room's possible with warmth held. From a warm occurrence, a heated room's possible with warmth held is its whole possible (`heated_possible_held`). The unheated room's lacks the cold occurrence past the window's cooling (`Unheated.cold_not_held`).
- **On keeping widening.** No room's window course from its set level keeps widening: each returns to one configuration at arbitrarily late steps, so `Run.not_keepsWidening_of_returns` applies. The unheated room settles at 0, the matched thermostat stays at its set level, and the overshooting one cycles. This is proved for the window courses: at every margin for the unheated room and the matched thermostat, at a margin of three for the overshooting one. Other courses are not claimed.
- **Two readings of 全生成.** The table's 全生成 is on `net 3 2`, read at warm or not and the level. `Overshooting.generation_at_moments` reads 全生成 on the window course's moments (`Steps.next`, the one, and the run's level), as `HeldPossible`'s `Oscillating` does: generation without widening. Both hold for the overshooting thermostat, each proved on its own; no bridge between them is proved.

## 4. Testing: the core and its stages

On the joint nets, with the rooms tagged by `c`, at every margin `m` unless a condition is stated:

1. **No window: one class at the level class.** For all `m`, `c` and `c'`, `«核» (jointShut m) jointLevel (c, start m) (c', start m)`. The witness pairs any two shut occurrences at the set level. It is symmetric and within the class, and constant because each such occurrence steps to itself. By `«核之单调»` the same holds under warm or not (`shut_one_class_alike`). From the set level, then, the shut net tells no room from another. Below it, from a margin of two on, it does at every level under `m - 1`, where the heater still gives after the exchange: at a margin of three, shut at level 1, the three rooms step to 2, 3 and 4, so the first stage of the level class separates them there. At level `m - 1` the exchange alone reaches the set level and every room steps to `m`, so at a margin of one no shut step separates the rooms (all checked by hand).
2. **Window, level class: the first stage.** For `1 ≤ m` and `1 ≤ c`, `¬ «层» (joint m) jointLevel 1 (0, start m) (c, start m)`. The unheated room's opening reaches level `m - 1`. The heated room's successors are at `m` (shut) and at `m - 1 + c` (open), and neither is `m - 1`. By `«可分则不在核»` the two are not in one core class. At a margin of three the two thermostats are also told apart at stage 1 (`heaters_told_apart`): the overshooting thermostat's opening reaches 4, and the matched thermostat's successors are both at 3.
3. **Window, warm or not: the stage of the margin.** For `1 ≤ c` and a margin of `n + 1`, `«层» (joint (n + 1)) jointAlike n (0, start (n + 1)) (c, start (n + 1))` and `¬ «层» (joint (n + 1)) jointAlike (n + 1) (0, start (n + 1)) (c, start (n + 1))` (`«开窗以温层如其余乃分»`). Two inductions on the stage prove it:
   - an unheated occurrence above level `k` and a warm occurrence of a heated room are alike at stage `k` (`lasts`): an unheated step loses at most one unit (`unheated_step`), every successor of a heated room is warm, and every occurrence has a successor;
   - an unheated room open at level `j` is told from every warm occurrence of a heated room at stage `j` (`empties`): its window line empties it in `j` draws.

   In `RegimeMargin`'s terms the draw empties what stands above the surroundings in as many steps as it stood: the window's run is cold from the step of the margin on (`Unheated.window_cold`, by `RegimeMargin.stays_ended`). The stage count belongs to the class's threshold (choice 7 in §2): in general a finer class separates no later, and nothing more.
4. **Two rooms with a heater are one class under warm or not.** For `1 ≤ m`, `1 ≤ c` and `1 ≤ c'`, `«核» (joint m) jointAlike (c, start m) (c', start m)`. The witness pairs warm occurrences of heated rooms; it is constant because every successor in a heated room is warm.

**The toy, derived.** `«恒温与平衡»` separates its rooms at the first stage of warm or not, because its balanced room "may cool" in one step. That is the rule at a margin of one draw. Read the toy's rooms as the rule's occurrences (`toy`): the balanced room is the unheated room at its set level, the held room is the matched thermostat there, the cold room is the unheated room once its window has opened, and the kept room is the matched thermostat once its window has opened. Then (`toy_branches`):
- each branch the toy stipulates, with the window or shut, is a step of the rule;
- from the balanced and the held room each step of the rule is one the toy stipulates;
- the toy's warmth is the rule's.

The toy stops at the cold and the kept room, where the rule goes on, and a first stage does not read past them. So the toy's first stage reads as the rule's, and its verdict follows from the stage law at `n = 0`: its rooms are told apart at stage 1, and so are not in one core class (`toy_verdict`, the second half of `«恒温与平衡»`). The first half, one core class while no window opens, is the rule's at warm or not on the joint carrier at the toy rooms' images (`shut_one_class_alike 1 0 1`); carrying it back to the toy's own relation is not done, and the toy keeps its own proof. Derived from the rule, the coarse test needs the stage at which the difference shows at its grain, and that stage is the margin in the window's draws.

Only one direction of testing is a theorem, `«可分则不在核»`. The other, that what is not in the core is separable, is the Hennessy–Milner calibration (plan §4.4). These nets are image-finite, with at most two successors, so its condition is met. The separations above are proved directly, and the calibration is not used.

## 5. Conditional laws tested on the models

Each row is a landed law, the place on the models where its condition Z holds, and a place where Z fails.

| law (Z then Y) | where Z holds, and Y there | where Z fails, and Y there |
|---|---|---|
| `«有常则往不穷»`: `«有常» R L`, with `«有前» R L x`, gives `«不穷» R L x`, no line of `L` from `x` ends | in every heated room at a positive margin, warmth is constant under `net m c`: every successor of every occurrence is warm (`heated_warm`). No line of warmth from `start m` ends (`heated_unended`) | in the unheated room: the open occurrences at 2 and at 1 are both warm, but one steps to warm and the other only to cold. From a margin of two on Y fails too: the line from `start m` reaches the open occurrence at 1, which ends. At a margin of one Y holds without Z (`unended_at_one`), and so it does across rooms (`joint_converse`) |
| `«有终则粗不有常»`: `«有前»` and `«有终»` give `¬ «有常» R L` | the unheated room's `start 3`: warmth is not constant under its net (`Unheated.rows`) | the heated rooms' `start m`: no line of warmth reaches an end (`heated_unended`), and Y fails too, since warmth is constant (`«温有常当且仅当有给»`) |
| `«单行则生成后守不并»`: each occurrence conditions at most one other | after the window opens (the open-window relation is single): the overshooting thermostat's open occurrences are 生成 and so not 后守 | at the overshooting thermostat's `start 3` the net branches, and 生成 and 后守 hold together. This is the mechanism counterpart of `Map.«生守相杂»`, and it shows Z is needed |
| `RegimeMargin.stays_ended`: giving short of the draw below the start (`Short`), and nothing from nothing | the unheated room's window course, at every margin: cold from the step of the margin on | the heated rooms: below the set level the heater gives `c ≥ 1`, not short of the draw, and the course never ends |
| `RegimeMargin.holds`: giving meets the draw on the band (`Meets`) and keeps within its top (`Keeps`) | the matched thermostat at every positive margin `m`, band `[1, m]`: from `m` the level stays at `m` | the overshooting thermostat at a margin of three: no band holding 3 has both, yet its course stays within `[3, 4]`. `Meets` needs the band's top at most 3, because the heater gives nothing at 3; `Keeps` then fails at that top, because from 3 the level goes to 4. The law is one-way: Y without Z (`Overshooting.holds_one_way`). The course is `RegimeMargin.Alternation`'s run shifted by two (`Overshooting.alternation_shifted`) |
| `Run.generation_of_held_changes`: the held part changes at every step | the overshooting thermostat's window course, part the level: every moment is 全生成, read on the run's moments | the matched thermostat: the level never changes; the unheated room: it settles at 0. Y fails in both: no moment is 全生成 (`Matched.no_generation_at_moments` at every positive margin, `Unheated.no_generation_at_moments` at every margin) |
| `Run.not_keepsWidening_of_returns`: the course returns to one configuration at arbitrarily late steps | the window courses from the set level, the unheated room's at every margin, the matched thermostat's at every positive margin and the overshooting thermostat's at a margin of three: none keeps widening | — |

**The constancy law on the family.** For every positive margin `m` and every `c`, warmth is constant under `net m c` exactly where `1 ≤ c` (`«温有常当且仅当有给»`). By `«类有常当且仅当含于核»` this is a law of the core too: within one room, warmth lies in its own core exactly where the heater gives (`alike_in_core_iff`). With `«有常则往不穷»` it gives, from a margin of two on, that no line of warmth from `start m` ends exactly where `1 ≤ c` (`«温不穷当且仅当有给»`). The margin of two is needed: at a margin of one no line of warmth ends, heater or not (`unended_at_one`). On this family the converse of `«有常则往不穷»` therefore holds from a margin of two on, and fails at a margin of one. Across rooms it fails at every positive margin: the joint carrier puts the unheated room beside the heated ones, so warmth is not constant under `joint m`, and still no line of warmth from a heated room's `start m` ends (`joint_converse`). The iff rests on choices 6, 7 and 9 of §2.

**For part A** [AI reading, not a result]. The heated room may read as a case where 穷则变 holds: the heater's giving changes where the window draws, and warmth goes on. In the grammar, though, 穷 is a line's ending, not a level below the set point, and a heated room's line of warmth never ends; the unheated room under the window, whose line does end, may read as 穷而息. On these models the condition is the constancy above. Whether that is the corpus's Z is part A's question.

## 6. The guess

**The guess** (OU's owner): a thermostat's keeping is held by a coupling that reads the level, and equilibrium's needs none. Items 3 and 5 are AI readings.

1. **From the set level the shut net cannot test it.** At the set level the heater gives nothing and the exchange moves nothing: every room rests (`shut_rests`), and all are one core class at the level class (§4.1). There the shut net can neither confirm nor refute the guess. Below the set level it shows the heater's coupling: at a margin of three, shut at level 1, the overshooting thermostat steps to 4, a joint giving of 3 against a gap of 2 to its set level, beyond `Flow.WithinGap` (checked by hand, and a reading of 02 §8's definitions, since the rooms are not World flows).
2. **"Needs none" fails against 02 §8.** The shut room's exchange is one unit toward the set level on each side. So it takes more than it gives above the set level, gives more than it takes below, and departs from evenness by at most the gap. That is `Flow.Opposes` within `Flow.WithinGap`, and by `Flow.settles_from` the level settles toward its surroundings' level. In 02's sense, equilibrium's keeping is held by a coupling that reads the level. The rooms are not built as World flows, so this item is a reading of the definitions, not an instance theorem. It is the guess's real counterexample.
3. **What tells the rooms apart** [AI reading]. Both keepings depend on the level. What holds whichever way the heater reads, from a margin of two on: every step of a heated room lands warm (`next_pos`, `before_pos`), so no line of warmth from its set level ends; without a heater the two orders are one rule (`before_unheated`), and the open window takes the level down to the surroundings' 0 (`Unheated.window_cold`). What depends on the order is whether the window moves the held level. Read after the exchange, as here, the heater answers the window's draw within the step: the matched thermostat holds its set level (`Matched.window_held`), and the overshooting one stays within `[3, 4]` (`Overshooting.holds_one_way`). Read before the exchange, the window moves both (`before_window_moves`). 02 §8's rules reading `ℓ` steps late (`Regulation.ReadsLate`) answer no draw within its step: for each of them, with the shut rest exchanging nothing and the window's rest taking one unit a step from `T`, `late_spread` puts the windowed level exactly `ℓ + 1` below the shut one at step `T + ℓ + 1`. So the distinction that survives the reading order is warmth going on when the window opens, not a held level the window cannot move. The window tests exactly that, so the test needs the net of the possible: on the actual course, with no window, the rooms are one class.
4. **Restated as a conditional law** (§5): from a margin of two on, no line of warmth from the set level ends exactly where the heater gives. The counterexample is the unheated room.
5. **The map does not read regulation as a region** [AI reading]. Below the set level, the matched thermostat's heater returns exactly what the window draws. The level never changes, and the room is 全守 at every positive margin (`«给如所取则全守»`), as every room is on the shut net (`shut_rests`). Rest and exact regulation lie in one region, and only the net of the possible tells them apart: compare the unheated room's window branch, which reaches an end. The overshooting heater overshoots, the level changes at every step, and the room is 全生成. Which region a regulated keeping lies in depends on the heater's step against the draw, read at the level class.

**Why the window, not a gust.** A gust lowers the level once while the surroundings stay at the set level. At the level class, at a margin of three, even a gust of 2 separates the rooms: shut at level 1 they step to 2, 3 and 4. Under warm or not, a gust that leaves both rooms warm can leave them one class (by inspection). A gust tests how the level is restored; the window tests whether warmth goes on when the surroundings fall.

## 7. What is new, what is used, what is not done

**New: the scratch Lean.** Both modules build with no warning, and every axiom report is empty, transitively through every module they import ([log](scratch-build.log)).

`scratch/Becoming/RoomNet.lean`: 120 declarations, 94 of them theorems. It imports only `GrammarTesting`, `GrammarLaws`, `GrammarReadings` and `MapRegions`.
1. **The nets and classes**, at every set level `m`: `Occurrence`, `surroundings`, `exchange`, `heater`, `next`, `shut`, `net`, `openNet`, `sameLevel`, `warm`, `alike`, `start`, and the joint carrier `Tagged` with `joint`, `jointShut`, `jointLevel`, `jointAlike`. The steps used throughout: `rest_step`, `shut_rest_step`, `opens`, `net_open`, `net_shut`, `shut_start`, `cools`, `cold_step`, with `next_rest`, `next_zero`, `warms_open`, `exchange_ge`, `next_pos`, `heated_warm`, `warm_of_pos` and `warm_of_level`.
2. **The regions in §3.** At a margin of three: `«平衡守而有终»`, `«开窗则平衡新而尽»` and `Unheated.rows`; `«给过所取则生守相杂»`, `Overshooting.generation_strong`, `Overshooting.rows`, `Overshooting.renewing_steps`, `Overshooting.not_keepsAfter_open` and `Overshooting.single_line_tested`. At every positive margin: `«给如所取则全守»` and `Matched.rows`. At every margin: `shut_rests` and `cold_rests`.
3. **The core and stage facts in §4.**
   - For every `m`, `c` and `c'`: `«不开窗则同核»` and `shut_one_class_alike`.
   - For `1 ≤ m` and every heated `c` (`1 ≤ c`): `«开窗则一层可分»` and `«有给之室以温不可分»`.
   - For every margin `n + 1` and `1 ≤ c`: `«开窗以温层如其余乃分»`, by `lasts` and `empties`, with `unheated_step`.
   - At a margin of three, `c = 1, 2`: `heaters_told_apart`.
4. **The constancy law, its corollary and its converse** (§5): `«温有常当且仅当有给»`, `alike_in_core_iff` and `heated_unended` for `1 ≤ m`; `«温不穷当且仅当有给»` for `2 ≤ m`, with `cold_after` and `cools_to`; `unended_at_one`; `joint_converse` for `1 ≤ m` and `1 ≤ c`.
5. **The reading order** (§2 choice 8, §6.3): `nextBefore`, `before_window_moves`, `before_pos`, `before_at_one`, `before_unheated`.
6. **The toy derived** (§4): `toy`, `toy_branches`, `toy_verdict`.

`scratch/Becoming/RoomRuns.lean`, the bridge: 27 declarations, 24 of them theorems. It imports `RoomNet`, `RegimeMargin` and `HeldPossible`.
- **The open window is the regime's step**, at every set level. The rule with the window open is `RegimeMargin.step (heater m c) 1` (`next_open`), and the window's branch is a line of the net (`window_line`).
- **The regime's laws on that branch.**
  - The unheated room is cold from the step of its margin on, at every margin (`Unheated.window_cold`, by `RegimeMargin.stays_ended`).
  - The matched thermostat stays at its set level, at every positive margin (`Matched.window_held`, by `RegimeMargin.holds`).
  - At a margin of three the overshooting thermostat alternates 3 and 4 (`Overshooting.alternates`), and `holds` is one-way on it (`Overshooting.holds_one_way`). From two on, its heater is `RegimeMargin.Alternation`'s giving shifted by two (`Overshooting.heater_shifted`), and its course is that witness's run shifted by two (`Overshooting.in_phase`, `Overshooting.alternation_shifted`).
- **Widening and generation.** The window courses do not keep widening: the unheated room's at every margin (`Unheated.not_widening`), the matched thermostat's at every positive margin (`Matched.not_widening`) and the overshooting thermostat's at three (`Overshooting.not_widening`), each by `Run.not_keepsWidening_of_returns`. Every moment of the overshooting thermostat's is 全生成 at the level, read on the run's moments (`Overshooting.generation_at_moments`, by `Run.generation_of_held_changes`); no moment of the matched thermostat's or the unheated room's is (`Matched.no_generation_at_moments`, `Unheated.no_generation_at_moments`, by `Steps.generation_iff_begins`).
- **The possible with warmth held.** Each room is read as a process whose act opens the window (`process`, `steps_of_net`, `net_of_steps`). A coarse line is then the possible with warmth held (`line_iff_held`). From a warm occurrence, a heated room's possible is all possible with warmth held, at every positive margin (`heated_possible_held`, with `heated_held`). At a margin of three the unheated room's cold occurrence is possible, but not with warmth held (`Unheated.cold_not_held`).

**Used as they stand.**
- The grammar's laws: `«可分则不在核»`, `«核之单调»`, `«类有常当且仅当含于核»`, `«有常之逐点»`, `«有亡之续则不有常»`, `«有常则往不穷»`, `«有终则粗不有常»`, `«单行则生成后守不并»`, `«守则后守»`, `«所及之传递»`, `«闭之及»`, `«及之单调»`, `«线内同类»`, and the exclusions `«全生成全守不并»`, `«全生成有终不并»`, `«全守有终不并»`, `«生成退化不并»`, `«守退化不并»`, `«后守退化不并»`.
- Its definitions: `«层»`, `«核»`, `«有常»`, `«不穷»`, `«传»`, `«生成»`, `«守»`, `«后守»`, `«退化»`, `«全生成»`, `«全守»`, `«有终»`, `«新而有终»`, `«新而尽»`, `«闭»`.
- `RegimeMargin`: `step`, `Short`, `Meets`, `Keeps`, `stays_ended`, `holds`, `Alternation.giving`.
- `HeldPossible`: `Reaching.heldMoves`, `Reaching.Possible`, `Reaching.PossibleHeld`, `Reaching.reach_heldMoves_iff`, `Reaching.possibleHeld_iff_line`, `Reaching.KeepsWidening`, `Run.not_keepsWidening_of_returns`, `Run.generation_of_held_changes`, `Steps.generation_iff_begins`; with `Arising`'s `Steps.hasPred_iff`.

**Not done.** OU's owner decided that each goes, as it stands, into the record's next step and the home section's open lines:
- **A World instance.** The room as a `Flow` would have conditions (the room's heat, the surroundings' heat, the heater's supply) and formations (walls, heater), with balance by conservation. 02 §8's laws would then apply formally: `Flow.settles_from` for the shut room, and `Flow.not_at_of_beyond` for the overshooting thermostat with the window open, where at its set level the joint exchange gives 1 across a gap of 0, so it does not rest there. `Regulation.course` and `courseFlow` are the route.
- **A heater that reads late.** 02 §8's late thermostat as a World flow is `Regulation.relay` (`relay_runs`, `relay_threshold`, a threshold past which it oscillates). On the rooms, a heater reading `ℓ` steps late would let the window lower the level by `ℓ + 1` before it answers (`late_spread`, §6.3).
- **Gusts.**
- **The regions at other margins** for the unheated room and the overshooting thermostat, proved here at a margin of three only. They need reach invariants: open levels stay within `[1, m - 1]` while warm for `c = 0`, and within `[m, m - 1 + c]` for `c ≥ 2`. `cools_to` is the first of them. The matched thermostat's are at every positive margin.
- **The cold occurrence at other margins.** `Unheated.cold_not_held` is proved at a margin of three.
- **The toy's first half carried back** to the toy's own relation (§4).
- **The variants of choices 2, 6 and 7 in §2**, and the separations below the set level (§4.1, §6), checked by hand only.
- **«通» at the overshooting thermostat's set level** (§9, finding 17), checked by hand only.
- **The Hennessy–Milner direction**, which remains a calibration.

## 8. Names

OU's owner approved the ten names proposed, with three notes, each taken, and after the review renamed two of them (below):
1. **The toy stays.** `«恒温与平衡»` stays in `GrammarTesting` with its scope, and `GrammarCases` cites it. The rule's nets derive it rather than replace it: `toy_branches` is the instance theorem (the toy's branches are the rule's at a margin of one draw), and `toy_verdict` derives its verdict at stage 1 (§4). `GrammarTesting`'s header bullet gains a clause pointing to the derived model at landing; that edit is OU's owner's.
2. **`«给过所取则生守相杂»`** (proposed as `«恒温生守相杂»`) is a model case of `Map.«生守相杂»` (生成 and 守 at the fork's root), and a stronger one, since 全生成. Its docstring says so.
3. **The stage law holds at every margin**, so `«开窗以温三层乃分»` becomes `«开窗以温层如其余乃分»`: the stage is the margin, in the window's draws of one.

Following the core's model names (`«恒温与平衡»`, `«薪尽火传»`, `«蜡烛之合»`). «闭» is avoided for "shut", since the core uses it for closure. All ten «» names sit in the namespace `Rooms`, each naming its model or its condition (平衡, 给如所取, 给过所取, 有给, 开窗); the rows and helpers sit in `Rooms.Unheated`, `Rooms.Matched` and `Rooms.Overshooting`.

| name | statement |
|---|---|
| `«不开窗则同核»` | while no window opens, every room at its set level is one core class at the level class, whatever its heater, at every margin (§4.1) |
| `«开窗则一层可分»` | with the window in the net, the first stage of the level class tells the unheated room from every heated one, at every positive margin (§4.2) |
| `«开窗以温层如其余乃分»` | under warm or not, at a margin of `n + 1` draws, stage `n + 1` tells them apart and stage `n` does not (§4.3) |
| `«有给之室以温不可分»` | two rooms with a heater are one core class under warm or not, at every positive margin (§4.4) |
| `«温有常当且仅当有给»` | warmth is a constant class under the net exactly where the heater gives, at every positive margin (§5) |
| `«温不穷当且仅当有给»` | from a margin of two on, no line of warmth from the set level ends exactly where the heater gives (§5) |
| `«给过所取则生守相杂»` | where the heater gives more than the window takes, the room at its set level, shut, is 生成 and 守: the overshooting thermostat at a margin of three, a model case of `Map.«生守相杂»`; 全生成 is `Overshooting.generation_strong` (§3) |
| `«给如所取则全守»` | the matched thermostat: 全守 before and after the window opens, at every positive margin (§3) |
| `«平衡守而有终»` | the unheated room at its set level, shut: 守, 有终 and 新而有终, neither 生成 nor 退化 (§3) |
| `«开窗则平衡新而尽»` | after the window opens, the unheated room degenerates while renewing (§3) |

Everything else takes English names in the namespace `Rooms`, as the map's witnesses do (`Map.Once.keeping`). The review's English renames are taken: `At` became `Occurrence` (the package's other `Occurrence` types sit in `Joining` and `SecuredContent`), `outside` became `surroundings` (the glossary's "outside" is another sense), the namespace `Thermostat` became `Overshooting`, and the matched thermostat's open occurrence is `Matched.kept m`. `lasts`, `empties`, `cools_to`, `unheated_step` and the step lemmas are helpers.

**Decided by OU's owner after the review** (finding 9):
- `«恒温生守相杂»` became `«给过所取则生守相杂»`. 恒温 names both heated rooms, but only the overshooting one is 生守相杂, while the matched one is 全守. The new name is exact and pairs with `«给如所取则全守»`.
- `«二恒温以温不可分»` became `«有给之室以温不可分»`. 有给 is already this item's word for `1 ≤ c` (`«温有常当且仅当有给»`), so the name says exactly which rooms the law is about.
- The English names that state results stay English in `Rooms`, as helpers and bridges do: `toy_branches`, `toy_verdict`, `unended_at_one`, `joint_converse`, `alike_in_core_iff`, `shut_rests`, `cold_rests`, `heated_unended`, `before_window_moves`, `before_pos`, `Matched.no_generation_at_moments` and `Unheated.no_generation_at_moments`. A row of the home section that needs one cites it by that name.
- `RoomNet` and `RoomRuns` stay two modules. The first reads the grammar only, and the second is the bridge to `RegimeMargin` and `HeldPossible`; their imports state their different bases, which one module would hide.

## 9. Review

One independent AI review read the design, both scratch modules and the package modules they cite, read-only. It ran on the margin-three version of commit `c896e1001`; the margin-general version and the approved names came after it, and each finding was taken against the current text. It found 2 high, 7 medium, 2 low–medium and 7 low findings, and checked as sound: the build and its axiom reports; the bridge (`next_open`, `window_line`, `windowAt_level`); the fixed points and courses of §2; every region theorem stated; the stage facts of §4; the two family iffs; every `RoomRuns` lemma; the arithmetic of §6.2; the `HeldPossible` process bridge; and the method (the possible-net reading and its conflict relation declared, the window inside the net, the Hennessy–Milner direction left as a calibration, «闭» avoided for "shut").

| # | finding | how taken |
|---|---|---|
| 1 (high) | "The thermostat holds 3, which the window does not move" is false for `c = 2`, which alternates 3, 4; for `c = 1` it holds only because the heater reads after the exchange, and no `ReadsLate` rule reads that way (`late_spread` gives a dip of `ℓ + 1`); read as "the set point is not moved" it is true by construction, an interpretation without an AI label | the claim is gone. §6.3, labelled an AI reading, keeps as the distinction only what holds whichever way the heater reads, proved for both orders (`next_pos`, `before_pos`, `before_unheated`); what depends on the order is proved (`before_window_moves`, `before_at_one`) and stated with `late_spread`; the reading order is choice 8 in §2 |
| 2 (high) | "Every cell is proved" was false: 16 cells had no Lean statement, and the renewal column missed the opening and claimed "every step" from one renewing successor | every cell now has a statement (`Unheated.rows`, `Matched.rows`, `Overshooting.rows`, at every positive margin for the matched thermostat); the renewal column is `Overshooting.renewing_steps`: the opening and every open step renew, the shut step does not |
| 3 (medium) | Y was glossed "warmth never ends along any branch", more than `«不穷»` says; the iff needs a window that never closes and warm meaning a level of at least 1; Z is global and Y local | Y is glossed "no line of warmth from the set level ends" throughout, Lean docstrings included, and "every branch stays warm" is stated apart, from `heated_warm`; choices 6, 7 and 9 in §2 state the window, the threshold and the asymmetry, with the review's hand checks; a local Z would be a new law |
| 4 (medium) | the converse's counterexample across rooms was prose only | proved: `joint_converse` (warmth not constant under `joint m`, and no line of warmth from a heated room's set level ends, for `1 ≤ m`, `1 ≤ c`) |
| 5 (medium) | `jointLevel` is not the finest class, since equality separates by tag; "nothing on the shut net tells them apart" holds only from the set level; the tag is not explained | "the level class" throughout, the «» gloss included; "from the set level", with the shut steps from level 1 to 2, 3 and 4 below it (§4.1); §2 says what the tag is |
| 6 (medium) | "fails as worded" on the shut net treats "cannot be tested here" as "false"; the overshooting heater's coupling shows on the shut net below the set level | §6.1 now says that from the set level the shut net cannot test the guess, with the coupling below it; §6.2, equilibrium's own level-reading exchange, is named the real objection |
| 7 (medium) | modelling choices the laws depend on were not stated; `Flow.settles` needs balance everywhere | §2's "Modelling choices" names nine, each with the laws that rest on it; §6.2 cites `Flow.settles_from` |
| 8 (medium) | "what is new" missed `RegimeMargin.Alternation`, `Map.Short`, `«核之单调»`, `«类有常当且仅当含于核»` and the relay; every new theorem is about one family | the overshooting course is proved to be `Alternation`'s run shifted by two (`Overshooting.heater_shifted`, `in_phase`, `alternation_shifted`); `shut_one_class_alike` (by `«核之单调»`) and `alike_in_core_iff` (by `«类有常当且仅当含于核»`) are proved; "what is new" cites the existing witnesses and says every law is about this family; §1 and §7 cite the relay, `course` and `courseFlow` |
| 9 (medium) | `«二恒温以温不可分»` calls `c = 1` a thermostat while the design's thermostat was `c = 2`; `c = 1` was called a control; `«给如所取则全守»` and `«恒温生守相杂»` read as laws; placement mixed; `outside` | the heated rooms are the matched and the overshooting thermostat throughout; OU's owner then took both proposed «» renames, `«给过所取则生守相杂»` and `«有给之室以温不可分»` (§8); all ten «» names now sit at `Rooms`; `outside` became `surroundings` and `At` became `Occurrence`; `«给如所取则全守»` is now proved at every positive margin |
| 10 (low–medium) | the lists of laws used were wrong; the `«有终则粗不有常»` row had no "Z fails" entry | `«有终则粗不有常»` is now used (`Unheated.rows`), and `ends_beyond_giving` is listed as existing, not used; §7's list is taken from the modules' code; the row's "Z fails" entry is the heated rooms |
| 11 (low–medium) | non-widening was claimed for every course; two readings of 全生成 were joined; `KeepingWidening` "none of its premises hold" | non-widening is claimed for the window courses only, each at the margins proved (§1, §3, §5, §7); §3 keeps the net's 全生成 and the run's apart, with no bridge claimed; §1 says "does not apply" |
| 12 (low) | "the coarser the class, the deeper the stage" generalizes one threshold; a non sequitur on why the unheated room is not 生成 | "here", tied to the threshold, with the general fact that a finer class separates no later; the reason given is `Unheated.not_generates`'s |
| 13 (low) | 新而尽 holds at the open occurrence at 2, not 1; the joint core's reason is that `joint` keeps the tag; "the cold occurrence is 全守" unproved; "whole possible" needs a warm start; "rest and exact regulation fall in one region" needed 全守 on the shut net; a gust of 2 separates at the level class | each stated as said; `cold_rests` and `shut_rests` proved; "from a warm occurrence"; the gust paragraph gives the level-class case |
| 14 (low) | docstrings: `begins_open`'s "exactly where", `not_begins_s3`'s "begins nothing", `closed_open`, `window_cold`'s premise, the Y gloss | each rewritten to say what is proved (`not_begins_s3` is now `not_begins_start`; the old `stays_shut` was replaced by `rest_step`, stated at the set level) |
| 15 (low) | replacing the toy would touch landed texts (chapter 03's home section, its record, `GrammarCases`, LOGIC L-12, the OU5 testing study) | the toy stays and is derived, not replaced; no landed text changes except one clause, which OU's owner adds to `GrammarTesting`'s header at landing, pointing to the derived model (§8, note 1); chapter 03's "first stage" is the toy's, at a margin of one |
| 16 (low) | the late-heater item misused `no_narrower_band` | restated with `ReadsLate` and `late_spread` (§6.3, §7) |
| 17 (low) | the part A reading: the grammar's «通» fails at the overshooting thermostat's set level (going back, `start 3` ← shut at 4 ← shut at 1, which nothing precedes), and 穷 is a line's ending, not a level below the set point | the «通» clause is dropped; §5 says what 穷 is in the grammar; the review's hand check of «通» is listed as not done in Lean (§7) |
| 18 (low) | the ten-minute part: region names unglossed; readings unlabelled; "rest's region" not chapter 02's term (全守 allows an earlier renewal); walls and window both named as the exchange's agent; a missing Y entry; `At` a weak name | glosses in chapter 02's terms, the core class and the stages among them; AI-reading labels on the guess's readings; "rest's region" is gone; the exchange moves the level toward the surroundings, and the window switches them; every row of §5 states its Y where Z fails, the `Run.generation_of_held_changes` row by `Matched.no_generation_at_moments` and `Unheated.no_generation_at_moments`; `At` is `Occurrence` |

**The re-check.** The same reader then re-checked the revision, read-only: the version committed at `6c945b760`, before `heated_unended` was added and before the points below were taken. Of the 18 findings it found 14 fully taken and 4 partly (9, 11, 15 and 18). It found seven new problems, all in text or docstrings and none in a Lean statement, and four gaps in the ten-minute part, which it otherwise found correct and in agreement with chapter 02's region glosses. Each point was then taken, as the table below says; the table above gives each finding's handling as it now stands. `heated_unended` and these last changes were not reviewed again; the build checks the three theorems among them.

| re-check point | how taken |
|---|---|
| 9, 11, 15 and 18 partly taken: the two «» renames left to OU's owner, which is fine if stated; non-widening still said of every window course in §1's two rows and §5's last; "no landed text changes" while §8 plans a clause in `GrammarTesting`'s header; the `Run.generation_of_held_changes` row gave no Y where Z fails | 9: OU's owner then took both renames (§8); 11: each place names the margins proved; 15: row 15 names the clause; 18: Y fails there, proved (`Matched.no_generation_at_moments`, `Unheated.no_generation_at_moments`, by `Steps.generation_iff_begins`) |
| new 1: "the level class is the finest the rooms share" is false, since equality on the occurrence with the tag ignored is finer | "of the two classes used here, the finer" (§2) |
| new 2: the shut net's separation below the set level was said at every margin; it holds below `m - 1`, so from a margin of two on, and the steps to 2, 3 and 4 are at a margin of three | scoped so in the ten-minute part and §4.1, with the margin given in §6.1 and the gust paragraph |
| new 3: docstrings claiming more than their statements: `shut_rests` (the one region also needs `«给如所取则全守»`), `alternation_shifted` (only the band of `holds_one_way` follows from the shift), `alike_in_core_iff` (it needs a positive set level); "above two" and "above 1" where the statements hold from two and at 1 | each docstring says what its statement proves, and §7 says "from two on"; `RoomNet`'s module doc and the ten-minute part now scope the window's tests to a positive margin, which `«开窗则一层可分»` needs |
| new 4: at a margin of one, "有终 is not inhabited" is false of the carrier, whose open occurrence at 1 is 有终 | "no occurrence it reaches from there" (§2) |
| new 5: `«及之单调»` is in `Grammar`, not `GrammarLaws` | moved to §1's `Grammar` row, with `«线内同类»` |
| new 6: the folder's build log was the old one | rebuilt in this folder ([log](scratch-build.log)) |
| new 7: two docstrings in `RoomRuns` broken mid-sentence | rejoined |
| the ten-minute part: "core class" and "stage" unglossed; "below it" unscoped; the overshooting thermostat never said to be 生成, so the mixed region unexplained; "under 缘" unglossed | glossed in the testing paragraph; scoped as in new 2; "生成 along the window's branch and 守 along the shut one"; "under the net's steps" |
