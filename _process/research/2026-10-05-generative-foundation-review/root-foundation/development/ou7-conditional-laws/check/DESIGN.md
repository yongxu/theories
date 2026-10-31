# OU5 part B: two models for testing (验) on the net of the possible

Board item OU5, part B: plan §八 step 5, "验之模型例（恒温器与热平衡，在可能之网中）" ([plan](../../one-unfolding-root/PLAN.md)). Design for OU's owner, who decides what goes into Lean. The scratch Lean is in [`scratch/`](scratch/), outside the package; it changes no package file. Both modules build with `scratch_build.py`, with no warning and every axiom report empty ([log](scratch-build.log)). §7 lists what each module proves. AI-written. The independent review is in §9.

## The ten-minute part

**One mechanism makes both nets.** A room has a level, in whole units of heat. Its surroundings are at 3 while the window is shut and at 0 once it opens. Each step the room exchanges one unit toward its surroundings. A heater then reads what is left and gives `c` units where that is below 3, the heater's set point. Three rooms are compared:
- thermal equilibrium, `c = 0` (no heater);
- the thermostat, `c = 2`;
- a control, `c = 1`, whose heater gives exactly what the open window draws.

An occurrence is a pair: whether the window is open, and the level. There are two relations:
- `shut`: only steps with the window shut;
- `net`: the window's opening is in the net. From a shut occurrence the room may stay shut or open the window; an open window stays open.

On `net` the successors of an occurrence are alternatives. This is the possible-net reading of plan §4.1. Staying shut and opening at one step conflict; that conflict relation is declared beside the net and not formalized. The classes are the same level (fine) and warm or not (coarse). Warm means above the open surroundings: level at least 1.

**The courses.** At the set point with the window shut, every room rests: the walls exchange nothing and the heater gives nothing. When the window opens:
- the unheated room falls 3, 2, 1, 0 and stays cold;
- the `c = 1` room stays at 3: the window draws a unit, and the heater gives it back;
- the `c = 2` room goes 3, 4, 3, 4, …: from 3 the heater overshoots to 4; from 4 the walls take a unit, and the heater, reading 3, gives nothing.

**Regions.** These are read on `net`, at the coarse class warm or not and the fine class the same level:
- **The thermostat** at the set point, window shut: 全生成, and 守 along the shut branch. This is the mixed region 生守相杂, here from a mechanism; `Map.«生守相杂»` shows it on an abstract fork. After the window opens it is 全生成: the level changes at every step, and each step is a carrying renewal.
- **The unheated room** at the set point, window shut: 守 along the shut branch, and 有终 because the window branch's warmth ends. It is neither 生成 nor 退化, and it is 新而有终. After the window opens it is 退化 and 新而尽.
- **The `c = 1` room** is 全守 before and after the window opens. Nothing renews at the grain of the level, so it lies in rest's region.

**Testing.**
- Without the window in the net, every room at the set point is in one core class, even at the finest class. Nothing on the shut net tells a heated room from an unheated one.
- With the window in the net, the first stage of the level class tells the unheated room from every heated room.
- Under warm or not, the second stage does not tell them apart, and the third does: the open window takes three steps to empty the unheated room's warmth. The coarser the class, the deeper the stage a test needs.
- The two heated rooms are in one core class under warm or not. Warmth tests only whether warmth goes on along every branch, not how it is kept.

**A conditional law, tested.** Warmth is a constant class under the net exactly where the heater gives (`1 ≤ c`). There, by `«有常则往不穷»`, warmth never ends along any branch from the set point; without a heater it ends. On this family, then, "warmth never ends" (Y) holds exactly where "warmth is a constant class under 缘" (Z) holds, and Z is written in the grammar. Across all models only "Z then Y" holds (§5).

**The guess, tested.** The guess was: a thermostat's keeping is held by a coupling that reads the level, and equilibrium's needs none. It fails as worded in two ways:
- On the shut net both rooms rest. No coupling is at work, and they are one core class.
- It fails against 02 §8's definition. The shut room's own exchange with its walls opposes the level's departure from 3 on both sides, within the gap, so it is regulated toward its surroundings' level.

Restated, it holds on the net of the possible. Both keepings depend on the level; they differ in where the held level comes from. The thermostat holds the level its own rule sets: 3, which the window does not move. The unheated room holds its surroundings' level, 3 and then 0. The window's branch tests whether the held level moves with the surroundings. The map has no region for "held by regulation": the `c = 1` room's regulated keeping is 全守, rest's region, and the thermostat's is 全生成.

**What is new.** The rule-generated nets replace `«恒温与平衡»`'s stipulated branches. New results on them:
- the regions and the stage counts;
- the constancy law on the family;
- the bridge: the open window's course is `RegimeMargin`'s run, with a draw of one and the heater as the giving.

Through the bridge, `RegimeMargin.ends_beyond_giving` and `holds` apply as they stand, and so do `HeldPossible`'s `Run.not_keepsWidening_of_returns` and `Run.generation_of_held_changes`. Every other law used exists already. Not done: an instance on the World's flows, which 02 §8's laws need before they apply formally; gusts; a heater that reads late.

## 1. What exists, and what the models use

| module | what it states | used here |
|---|---|---|
| `GrammarTesting` | stages `«层»`; `«核在每层之内»`; `«可分则不在核»`; the toy `«恒温与平衡»`, with stipulated branches (the balanced room "may cool", the held room "may be kept warm"), told apart at stage 1 of warm or not | stages and the one theorem direction; the toy is what the models replace |
| `GrammarMap` | `«传»`, `«生成»`, `«守»`, `«退化»`, `«全生成»`, `«全守»`, `«有终»`, `«新而有终»`, `«新而尽»`; `«有常则无终»`, `«有终则粗不有常»`; `Map.«生守相杂»` on the abstract fork | the regions; the ending law |
| `MapRegions` | `«后守»`, `«守则后守»`, `«单行则生成后守不并»`, `«三域之周»`, `Map.generates_iff_changes`, `Map.keepsAfter_iff_settles` | keeping from some point on; the single-line law tested (§5) |
| `GrammarReadings` | `«有常则往不穷»` (constant and continued: the line never ends) | the conditional law's Y |
| `RegimeMargin` | a draw `H` then giving `g` of what is left (`step g H x = (x - H) + g (x - H)`); `ends_beyond_giving`, `holds`, `ends_iff_below` | the open window's course is `step (heater c) 1` |
| `HeldPossible` | the possible with a part held; on the root it is the start's line under the part (`Reaching.reach_heldMoves_iff`, `Reaching.possibleHeld_iff_line`); `Run.not_keepsWidening_of_returns`, `Run.generation_of_held_changes` | a coarse line is the possible with warmth held; no room keeps widening; the thermostat's moments are 全生成 |
| `Regulation` (02 §8) | `Flow.Opposes`, `Flow.WithinGap`, settling; overshooting; the relay; the band a late reading needs | read only (§6): the rooms are not built as World flows |
| `KeepingWidening` | what a World course whose range keeps widening needs | none of its premises hold: no room's range keeps widening (§3) |
| `RevisionRoutes` | when no route of keeping a formation's law stands above letting a revision go through | does not apply: no room has an act that keeps its rule against a revision; a changed set point is another relation, not a branch of this net |

## 2. The models

The Lean names are provisional; the «» names wait on OU's owner (§8). Everything is in the grammar except the bridge module (§7).

- **Occurrence.** `Rooms.At`: `opened : Bool`, `level : Nat`.
- **Surroundings.** `outside opened` is `0` if open and `3` if shut.
- **Exchange.** `exchange σ x` moves one unit toward `σ`: `x + 1` below it, `x - 1` above it, `x` at it.
- **Heater.** `heater c z` is `c` where `z < 3` and `0` otherwise. It reads the level `z` left after the exchange.
- **Rule.** `next c σ x` is `exchange σ x + heater c (exchange σ x)`.
- **Nets.**
  - `shut c x y`: both shut, and `y.level = next c 3 x.level`.
  - `net c x y`: `x` shut or `y` open, and `y.level = next c (outside y.opened) x.level`. The step uses the window as it is after the step's choice.
- **Classes.** `sameLevel x y` is `x.level = y.level`. `alike x y` is `warm x = warm y`, with `warm x` meaning `1 ≤ x.level`. `alike` is an equivalence: its two classes are warm and cold.
- **Joint nets.** To compare rooms, the carrier `Nat × At` tags each occurrence with its room's `c`. `joint` steps by `net x.1` and keeps the tag; `jointShut` does the same by `shut`. The classes `jointLevel` and `jointAlike` read the second component. The core of one pair is unaffected by the other rooms in the carrier, because the core matches steps forward from the pair.

**The carrier holds every pair, reached or not.** The rule gives every pair its successors, and that is how unreached occurrences matter:
- **`«生»`.** A predecessor in an occurrence's own level class is a fixed point of the rule at that level. Open, the fixed points are level 0 for `c = 0`, levels 1 to 3 for `c = 1`, and none for `c = 2`; shut, level 3 is one for every `c`.
- **`«有常»`.** Constancy is global, so §5 states it for the whole carrier.

**Why these numbers.** A set point of 3, open surroundings of 0 and a draw of one a step are the least numbers at which every region in §3 is inhabited. With a set point of 2, the unheated room's window line has a single warm occurrence, and nothing is 新而尽. Warm means above the open surroundings, so warmth is exactly `RegimeMargin`'s condition, a positive level.

**The models' two readings, stated as plan §4.1 asks.** `shut` and `net` use the possible-net reading: successors are alternatives. The window is in the net and is not an intervention from outside it. Testing is said within the net (plan §4.4), and the stages are the relations of the observations.

## 3. Regions, and why

Read on `net c`, `L = alike`, `E = sameLevel`, at the occurrences each room reaches from the set point with the window shut (`s3`). "✓ (shut branch)" names the branch that witnesses it.

| occurrence | 生成 | 守 | 后守 | 退化 | 全生成 | 全守 | 有终 | renewal |
|---|---|---|---|---|---|---|---|---|
| unheated, `s3` | no | ✓ (shut branch) | ✓ | no | no | no | ✓ (window branch) | 新而有终 |
| unheated, open at 2 | no | no | no | ✓ | no | no | ✓ | 新而尽 |
| `c = 1`, `s3` | no | ✓ | ✓ | no | no | ✓ | no | none |
| `c = 1`, open at 3 | no | ✓ | ✓ | no | no | ✓ | no | none |
| thermostat (`c = 2`), `s3` | ✓ (window branch) | ✓ (shut branch) | ✓ | no | ✓ | no | no | every step after opening |
| thermostat, open at 4 or 3 | ✓ | no | no | no | ✓ | no | no | every step |

Every cell is proved in `RoomNet`:
- the headline theorems of §8;
- `Unheated.rows`, `Matched.rows` and `Thermostat.rows`, which derive the remaining cells by the landed exclusions (`«全生成有终不并»`, `«全守有终不并»`, `«全生成全守不并»`, `«生成退化不并»`, `«后守退化不并»`, `«守退化不并»`);
- `Thermostat.not_keepsAfter_open`.

Why:
- **Carrying renewal.** A step is a carrying renewal (`«传»`) exactly where both ends are warm and the end's level is not a fixed point of the rule. The thermostat's open steps 3 → 4 → 3 change the level and are never fixed points, so every step is one. The `c = 1` room's open step 3 → 3 is a fixed point, so no step it reaches renews.
- **The unheated room's window branch.** Its steps 3 → 2 → 1 renew, but 1 → 0 leaves warmth. The line ends at the open occurrence at 1 (`«亡»`), so `s3` reaches an end (有终). It still keeps along the shut branch (守), so it is neither 生成, which needs an unending branch with renewal ahead, nor 退化, which needs an end on every branch.
- **After the window opens** the unheated room has one branch, and that branch ends: 退化. It renews at 2 → 1 before it ends: 新而尽.
- **生守相杂.** At the thermostat's `s3` the net branches. The window branch generates and the shut branch keeps, so `s3` is 生成 and 守 at once. As a strong form it is 全生成: warmth never ends along any branch, and a renewal lies ahead of every point reached (the opening is ahead of `s3` itself). 全生成 and 守 do not exclude each other; 全生成 and 全守 do (`«全生成全守不并»`).
- **A cold occurrence** reads the other class of `alike`. The unheated room's open occurrence at 0 keeps its coldness (全守). The table reads the warm pattern.
- **On HeldPossible.** By `Reaching.reach_heldMoves_iff`, what a coarse line reaches from `x` is what is possible from `x` with warmth held. The regions are read on each room's possible with warmth held. A heated room's possible with warmth held is its whole possible. The unheated room's lacks the cold occurrence past the window's cooling.
- **On keeping widening.** No room keeps widening along any course: each course returns to one configuration at arbitrarily late steps, so `Run.not_keepsWidening_of_returns` applies. The unheated room settles at 0, the `c = 1` room stays at 3, and the thermostat cycles. The thermostat's 全生成 is generation without widening, as with `Oscillating` in `HeldPossible`.

## 4. Testing: the core and its stages

On the joint nets, with the rooms tagged by `c`:

1. **No window: one class even at the finest grain.** For all `c` and `c'`, `«核» jointShut jointLevel (c, s3) (c', s3)`. The witness pairs any two shut occurrences at 3. It is symmetric and within the class, and constant because each such occurrence steps to itself.
2. **Window, same level: the first stage.** For `1 ≤ c`, `¬ «层» joint jointLevel 1 (0, s3) (c, s3)`. The unheated room's opening reaches level 2. The heated room's successors are at 3 (shut) and at `2 + c` (open), and neither is 2. By `«可分则不在核»` the two are not in one core class. The two heated rooms are also told apart at stage 1: the thermostat's opening reaches 4, and the `c = 1` room's successors are both at 3.
3. **Window, warm or not: exactly the third stage.** For `1 ≤ c`, `«层» joint jointAlike 2 (0, s3) (c, s3)` and `¬ «层» joint jointAlike 3 (0, s3) (c, s3)`. Every successor of a heated room is warm, and every occurrence has a successor. The unheated room's window line is warm at depths 1 and 2 (levels 2 and 1) and cold at depth 3. In `RegimeMargin`'s terms the draw empties what stands above the surroundings in as many steps as it stood: `RegimeMargin.stays_ended` from 3 (`Unheated.window_cold`).
4. **The two heated rooms are one class under warmth.** For `1 ≤ c` and `1 ≤ c'`, `«核» joint jointAlike (c, s3) (c', s3)`. The witness pairs warm occurrences of heated rooms; it is constant because every successor in a heated room is warm.

The toy `«恒温与平衡»` separates its rooms at the first stage of warm or not, because its balanced room "may cool" in one step. Derived from the rule, the coarse test needs the stage at which the difference shows at its grain. That stage is the margin above the surroundings, measured in the window's draws.

Only one direction of testing is a theorem, `«可分则不在核»`. The other, that what is not in the core is separable, is the Hennessy–Milner calibration (plan §4.4). These nets are image-finite, with at most two successors, so its condition is met. The separations above are proved directly, and the calibration is not used.

## 5. Conditional laws tested on the models

Each row is a landed law, the place on the models where its condition Z holds, and a place where Z fails.

| law (Z then Y) | where Z holds, and Y there | where Z fails, and Y there |
|---|---|---|
| `«有常则往不穷»`: `«有常» R L`, with `«有前» R L x`, gives `«不穷» R L x` | in every heated room, warmth is constant under `net c`: every successor of every occurrence is warm. Warmth never ends along any branch from `s3` | in the unheated room: open occurrences at 2 and at 1 are both warm, but step to warm and to cold. Y fails too: the line from `s3` reaches the open occurrence at 1, which ends |
| `«有终则粗不有常»`: `«有前»` and `«有终»` give `¬ «有常» R L` | the unheated room's `s3`: warmth is not constant under its net | — |
| `«单行则生成后守不并»`: each occurrence conditions at most one other | after the window opens (the open-window relation is single): the thermostat's open occurrences are 生成 and so not 后守 | at the thermostat's `s3` the net branches, and 生成 and 后守 hold together. This is the mechanism counterpart of `Map.«生守相杂»`, and it shows Z is needed |
| `RegimeMargin.stays_ended`: giving short of the draw below the point of no return, and nothing from nothing | the unheated room's window course: cold from the third step on | the heated rooms: the heater gives `c ≥ 1` below 3, and the course never ends |
| `RegimeMargin.holds`: giving meets the draw on the band (`Meets`) and keeps within its top (`Keeps`) | the `c = 1` room, band `[1, 3]`: from 3 the level stays at 3 | the thermostat: no band holding 3 has both, yet its course stays within `[3, 4]`. `Meets` needs the band's top at most 3, because the heater gives nothing at 3; `Keeps` then fails at that top, because from 3 the level goes to 4. The law is one-way: Y without Z (`Thermostat.holds_one_way`) |
| `Run.generation_of_held_changes`: the held part changes at every step | the thermostat's window course, part the level: every moment is 全生成 | the `c = 1` room: the level never changes; the unheated room: it settles at 0 |
| `Run.not_keepsWidening_of_returns`: the course returns to one configuration at arbitrarily late steps | every course of every room: none keeps widening | — |

**The constancy law on the family.** For every `c`, warmth is constant under `net c` exactly where `1 ≤ c` (`«温有常当且仅当有给»`, proposed). With `«有常则往不穷»` this gives: warmth never ends along any branch from `s3` exactly where `1 ≤ c` (`«温不穷当且仅当有给»`, proposed). On this family the converse of `«有常则往不穷»` holds as well. Across models it does not: the joint carrier puts the unheated room beside the heated ones, so warmth is not constant under `joint`, and still never ends from a heated room's `s3`.

**For part A (an AI reading, not a result).** The thermostat may read as the case where Z holds for 穷则变（变则通，通则久）: where the level falls below the set point, the heater's giving changes, and warmth goes on. The unheated room under the window may read as its counterexample, 穷而息. Here Z would be "something in the net answers the exhaustion", and on these models it is the constancy above. Whether that is the corpus's Z is part A's question.

## 6. The guess

**The guess** (OU's owner): a thermostat's keeping is held by a coupling that reads the level, and equilibrium's needs none.

1. **On the shut net it fails as worded.** At the set point the heater gives nothing and the walls exchange nothing; both rooms rest. They are one core class at the finest class (§4.1). Nothing on the shut net shows the thermostat's keeping held by its coupling.
2. **Against 02 §8 it fails too.** The shut room's exchange with its walls is one unit toward 3 on each side. So it takes more than it gives above 3, gives more than it takes below, and departs from evenness by at most the gap. That is `Flow.Opposes` within `Flow.WithinGap`, and by `Flow.settles` the level is regulated toward its surroundings' level. In 02's sense, equilibrium's keeping is held by a coupling that depends on the level. The rooms are not built as World flows, so this item is a reading of the definitions, not an instance theorem.
3. **What tells the rooms apart is where the held level comes from.** The thermostat's held level is its rule's own, the set point 3, which the window does not move. Equilibrium's is the surroundings' level, which the window moves to 0. "Reads the level" is common to both: the heater reads it against 3, and the walls exchange by its difference from the surroundings. The thermostat has, and equilibrium lacks, a coupling whose held level does not move with the surroundings. The window's branch tests exactly that, so the test needs the net of the possible: on the actual course, with no window, the rooms are one class.
4. **Restated as a conditional law** (§5): warmth never ends along any branch from the set point exactly where the heater gives. The counterexample is the unheated room.
5. **The map does not read regulation as a region.** Below the set point, the `c = 1` room's heater returns exactly what the window draws. The level never changes, and the room is 全守, the region of rest. Rest and exact regulation fall in one region, and only the net of the possible tells them apart: compare the unheated room's window branch. The thermostat's heater overshoots, the level changes at every step, and it is 全生成. Which region a regulated keeping lies in depends on the heater's step against the draw, read at the grain of the level.

**Why the window, not a gust.** A gust lowers the level once while the surroundings stay at 3. Both rooms restore, and if the gust is small, both stay warm. Under warm or not a gust can leave them one class. A gust tests restoring; the window tests where the held level comes from.

## 7. What is new, what is used, what is not done

**New: the scratch Lean.** Both modules build with no warning and every axiom report empty ([log](scratch-build.log)).

`scratch/Becoming/RoomNet.lean`: 91 declarations, 67 of them theorems. It imports only `GrammarTesting`, `GrammarLaws`, `GrammarReadings` and `MapRegions`.
1. **The nets and classes.** `At`, `exchange`, `heater`, `next`, `shut`, `net`, `openNet`, `sameLevel`, `warm`, `alike`, and the joint carrier `Tagged` with `joint`, `jointShut`, `jointLevel`, `jointAlike`.
2. **The regions in §3**, for `c = 0`, `1` and `2`: `«平衡守而有终»`, `«开窗则平衡新而尽»` and `Unheated.rows`; `«给如所取则全守»` and `Matched.rows`; `«恒温生守相杂»`, `Thermostat.generation_strong`, `Thermostat.rows`, `Thermostat.not_keepsAfter_open` and `Thermostat.single_line_tested`.
3. **The core and stage facts in §4.**
   - For every `c` and `c'`: `«不开窗则同核»`.
   - For every heated `c` (`1 ≤ c`): `«开窗则一层可分»`, `«开窗以温三层乃分»` and `«二恒温以温不可分»`.
   - At `c = 1, 2`: `heaters_told_apart`.
4. **The constancy law and its corollary** (§5), for every `c`: `«温有常当且仅当有给»` and `«温不穷当且仅当有给»`.

`scratch/Becoming/RoomRuns.lean`, the bridge: 23 declarations, 20 of them theorems. It imports `RoomNet`, `RegimeMargin` and `HeldPossible`.
- **The open window is the regime's step.** The rule with the window open is `RegimeMargin.step (heater c) 1` (`next_open`), and the window's branch is a line of the net (`window_line`).
- **The regime's laws on that branch.**
  - The unheated room is cold from the third step on (`Unheated.window_cold`, by `RegimeMargin.stays_ended`).
  - The `c = 1` room stays at 3 (`Matched.window_held`, by `RegimeMargin.holds`).
  - The thermostat alternates 3 and 4 (`Thermostat.alternates`). `holds` is one-way on it (`Thermostat.holds_one_way`).
- **Widening and generation.** No room's window course keeps widening (`*.not_widening`, by `Run.not_keepsWidening_of_returns`). Every moment of the thermostat's is 全生成 at the level (`Thermostat.generation_at_moments`, by `Run.generation_of_held_changes`).
- **The possible with warmth held.** Each room is read as a process whose act opens the window (`process`, `steps_of_net`, `net_of_steps`). A coarse line is then the possible with warmth held (`line_iff_held`). A heated room's possible from a warm occurrence is all possible with warmth held (`heated_possible_held`). The unheated room's cold occurrence is possible, but not with warmth held (`Unheated.cold_not_held`).

**Used as they stand:** `«层»`, `«可分则不在核»`, `«核»`, `«有常则往不穷»`, `«有终则粗不有常»`, `«单行则生成后守不并»`, `«守则后守»`, `«全生成全守不并»`, the region definitions, `RegimeMargin`'s and `HeldPossible`'s laws.

**Not done** (each is a candidate for OU's owner to decide on):
- **A World instance.** The room as a `Flow` would have conditions (the room's heat, the outside, the heater's supply) and formations (walls, heater), with balance by conservation. 02 §8's laws would then apply formally: `Flow.settles` for the shut room, and `Flow.not_at_of_beyond` for the thermostat at 3, where the joint exchange gives `c - 1` across a gap of 0.
- **A heater that reads late.** By `Regulation.no_narrower_band`, a rule reading `ℓ` steps late keeps no band narrower than `2 (ℓ + 1) d`. That would separate the thermostat from equilibrium, which reads its present difference.
- **Gusts.**
- **The general-`c` region table.** The regions for `c ≥ 2` need the reach invariant: open levels stay within `[3, 2 + c]`.
- **The Hennessy–Milner direction**, which remains a calibration.

## 8. Names proposed

Following the core's model names (`«恒温与平衡»`, `«薪尽火传»`, `«蜡烛之合»`). «闭» is avoided for "shut", since the core uses it for closure.

| proposed | statement |
|---|---|
| `«不开窗则同核»` | while no window opens, every room at its set point is one core class at the finest class, whatever its heater (§4.1) |
| `«开窗则一层可分»` | with the window in the net, the first stage of the level class tells the unheated room from every heated one (§4.2) |
| `«开窗以温三层乃分»` | under warm or not, the third stage tells them apart and the second does not (§4.3) |
| `«二恒温以温不可分»` | two heated rooms are one core class under warm or not (§4.4) |
| `«温有常当且仅当有给»` | warmth is a constant class under the net exactly where the heater gives (§5) |
| `«温不穷当且仅当有给»` | warmth never ends along any branch from the set point exactly where the heater gives (§5) |
| `«恒温生守相杂»` | the thermostat at its set point, shut: 全生成 and 守 (§3) |
| `«给如所取则全守»` | the `c = 1` room: 全守 before and after the window opens (§3) |
| `«平衡守而有终»` | the unheated room at its set point, shut: 守, 有终 and 新而有终, neither 生成 nor 退化 (§3) |
| `«开窗则平衡新而尽»` | after the window opens, the unheated room degenerates while renewing (§3) |

Everything else takes English names in the namespace `Rooms`, as the map's witnesses do (`Map.Once.keeping`).

## 9. Review

*(The independent review's findings, and how each was taken, follow once the review has run.)*
