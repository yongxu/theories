# UE1b landing: what it needs

25 October 2026. AI-authored, for the lander (the briefing session). It lists what landing UE1b, part 1, takes. The scripts in this folder do it (§7), modelled on UE1's landed kit. None has been run; each parses. Every anchor they edit occurs exactly once in main at `6170c9fa7` (UE4 and OC2 landed; rechecked 26 October), and none overlaps the edits that UE2's or UE5's scripts make. The scratch build ran over `d6addb3e4`; since then the package changed only in `GrammarPath` (OC2), outside the import closure of Optimum, SetPointOptimum and RegimeMargin. UE5's 08 bullet goes before the same **Assessment** line and keeps it once, so whichever lands second puts its bullet after the other's.

The kit is [NOTE.md](NOTE.md) with its tree ([SetPointOptimum](tree/Becoming/SetPointOptimum.lean), [Optimum](tree/Becoming/Optimum.lean)), revised after [REVIEW-UE1b.md](REVIEW-UE1b.md). Every finding was taken (NOTE §6). The re-check appended to the review found the kit ready to land once four garbled docstrings were fixed. They are fixed, with the re-check's other points (NOTE, header). The build and the statement comparison are in [scratch.log](scratch.log).

**Part 2 of the board item has landed already.** The board row names two parts: set-point orders, and pooled generative models (UE1's item e). Part 2 landed with UE1, as `ChoiceCountCapture.pooled_selectsThrough` and `ChoiceCountCapture.pooled_unchosen_beyond` (record `capture-by-counted-choices`, its second law). UE1b lands part 1, and with it the whole row moves to history.

## 0. Decisions

- **The rule 9 refactor of `Optimum` lands with UE1b.** Optimum's owner is inactive. So the lander decides to land it, as board rule 9 asks: the general law lands below its special cases, here in `Optimum` itself, and the rising laws become its corollaries.
  - The refactor changes three proofs and adds three theorems.
  - It changes no statement of `Optimum` or `RegimeMargin`, its only importer (scratch.log §3).
  - Record the decision in the commit message and on the board row.
- **The record id** is `what-a-set-point-optimum-does-beyond`. `texts_ue1b.py` and `make_records_ue1b.py` both use it; a different id means editing both.
- **For the lander to settle:** the study number `N` and the receipt; the T3 sentence (§3); the update to UE1's `NOTE-CORRECTIONS.md` (§4); the board's queue and state texts (§7).

## 1. Lean (package `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/`)

`integrate_ue1b.py` makes these changes.

1. **`Becoming/Optimum.lean`** is replaced with [tree/Becoming/Optimum.lean](tree/Becoming/Optimum.lean), after the script asserts that the landed file is the one this note records.
   - sha256 before `3da737a6…31621d3f`, after `6b8c4e20…f9eaeb6dc`.
   - The diff:
     - `Above.full_of_ranked` is inserted before `Above.full`, `Above.floor_or_full_of_ranked` before `Above.floor_or_full`, and `beyond_of_ranked` after `above_nothing`.
     - The three rising laws become two-line corollaries.
     - Five lines are added to the module docstring under *Every optimum beyond, exactly*.
2. **`Becoming/SetPointOptimum.lean`** is new, from [tree/Becoming/SetPointOptimum.lean](tree/Becoming/SetPointOptimum.lean), sha256 `22b6140d…4204253a`, the re-checked bytes. It imports `Becoming.Optimum` and `Becoming.Regulation` and is an L1 leaf.
3. **The root `Becoming.lean`** gets `import Becoming.SetPointOptimum` after `import Becoming.Optimum`, and the module's L1 bullet after Optimum's. Optimum's bullet gains one sentence naming the one law of the exchange.
4. **`check_becoming.py`** gets the module in `CORE` after `"Becoming.RegimeMargin"`, and its `SCOPE` sentence before SelectionPool's. Optimum's sentence gains a clause naming the general law.
5. **`README.md` and `README.zh.md`** each get an L1 row after Optimum's, and a clause in Optimum's row. The ZH wording is the lander's to settle.
6. **The checker run.** Expect a core receipt with:
   - `Becoming.Optimum`: 506 theorems in 637 declarations (+3, +3);
   - `Becoming.SetPointOptimum`: 82 in 124;
   - `RegimeMargin` unchanged at 246 in 336;
   - every axiom report empty.

The texts of the bullet, the `SCOPE` sentence and the rows are in the script. They say "strictly single-peaked", and "where the family holds a condition" wherever no nearing order is said to rise.

## 2. Records

1. **A new record**, `what-a-set-point-optimum-does-beyond` (`make_records_ue1b.py`).
   - *Laws:* 26, citing all 124 declarations of the module once each. They cover the class of nearing orders; why none rises; the optima at the set point; the term counted after the set point, in total only; the drain below the set point; the draw identity and its breaks; the exchange; holding and joint excess, with no order or choice in that law; and the witnesses.
   - *Does not show:* that an agent's preferences form a nearing order; any probability or precision; that a set point protects what lies beyond (witness `Topped.nearing_either`); the quantilizer bound; anything over a horizon or under noise; which optimum is taken; conflicting set points and optimizers read off an exchange; any evaluation.
   - *Correspondence*, cited from bibliographic knowledge with no source fetched: Friston and others 2016; Keramati and Gutkin 2014; Simon 1955; Taylor 2016; Zhuang and Hadfield-Menell 2020.
   - *Dependencies:* `what-an-optimum-does-beyond-what-couples-in`, `room-read-off-the-exchange`, `what-a-rise-draws-from-beyond`, `own-count-misses-joint-excess`, `two-sided-regulation-and-late-reading`. *Related:* `several-optimizers-drain-by-their-joint-capacity`, `capture-by-counted-choices`.
   - *Bindings:* `SetPointOptimum.lean` and `Optimum.lean`, at the new receipt.
   - Its texts keep the record lint's hard caps. One soft length warning remains, on the joint-excess law.
2. **`room-read-off-the-exchange`** (`update_room_record_ue1b.py`). Its fourth law (`laws[3]`) lists `Above.full`, `Above.floor_or_full`, `above_nothing` and `optimum_beyond`.
   - It gains `Optimum.Above.full_of_ranked`, `Above.floor_or_full_of_ranked` and `beyond_of_ranked`, which now carry it, and so does its `Optimum.lean` reference.
   - Its declaration list grows, so it takes a history line, the only one this landing writes in an existing record. The validation scope gains a sentence, and `reviewed_at_utc` is refreshed.
   - `Optimum.lean` is rebound to the new receipt. The law's statement is unchanged.
3. **The sixteen other records bound to `Optimum.lean`** are re-pointed as bookkeeping by `tools/research/repoint.py`. The exact command and `--reason` are in [repoint_ue1b.txt](repoint_ue1b.txt). They take no history lines, only one line of `_process/architecture/rebinds.jsonl`, since their statements, laws and declaration lists are unchanged. `re-optimizing-above-a-renewal-ends-it` and `several-optimizers-drain-by-their-joint-capacity` name `optimum_beyond` or `Above.full` in their dependency details; those texts stay true.

## 3. Chapters 05 and 08

`texts_ue1b.py` makes these edits.

- **05 §7, the home section.** It goes after the paragraph of the optimum law ([`r-what-an-optimum-does-beyond-what-couples-in`](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-what-an-optimum-does-beyond-what-couples-in)) and before `<a id="r-others-drawing-first-end-the-base"></a>`, under the anchor `r-what-a-set-point-optimum-does-beyond`. It holds a theorem paragraph, a paragraph on what protects at the set point, and a **Reading** [AI reading, D45].
- **05, Open:** an item after "- Whether the drain in actual trained systems lies where room lies (T3's clause on trained systems)."
- **08 §8, known results beyond the table:** a bullet at the end of the list, before the paragraph `**Assessment** (the market model of [05](05-COLLECTIVES.md), read against conventional control).` That puts it after UE4's bullet. It names satisficing and mild optimization as neighbours, and homeostatic reinforcement learning's drive as a nearing order.
- **08, the receipt and counts:** UE1's regex block.
- **Not scripted: a sentence for thesis T3** (recommended). T3 forbids "where room exists, a side-effect term ranked after the reward protecting a condition". The clause concerns rewards rising with what they read. A sentence under *Standing* or *Forbids* would keep it exact: "Counted after an order with a plateau, a set point or an aspiration level, such a term decides within the plateau", linking `#r-what-a-set-point-optimum-does-beyond`. The kit is no counterexample to T3, whose reward rises (REVIEW-UE1b, the section on satisficing).
- **Optional:** the chapter's thesis line and *What this chapter does not show* may add the choice among equal optima, conflicting set points, and reserves under noise.

## 4. UE1's note

- **Leave `ue1-fep-bridge/NOTE.md` as it is.** Its record cites those bytes.
- **Update §2 of [NOTE-CORRECTIONS.md](../ue1-fep-bridge/NOTE-CORRECTIONS.md)** to the landed names, since it predates the renames. Not scripted; for example:

  > **Corrected** (UE1b's review and the landed kit, `Becoming.SetPointOptimum`, record `what-a-set-point-optimum-does-beyond`).
  >
  > - Where the family holds a condition, no asymmetric order nearing a set point is rising (`Optimum.Nearing.not_rising`), so the optimum law does not reach it as stated. Below its set point it rises, and its optima drain as a maximizer's do (`Optimum.least_below`, `Optimum.nearing_beyond`).
  > - Where the set point can be reached, every optimum stands at it, and nearing alone asks nothing more of what lies beyond (`Optimum.optima_iff`). In a balanced step in which the whole gains nothing, the beyond falls by the family's shortfall from its set point with the loss (`Flow.Balances.atSetPoint_draws`).
  > - Where the step can lose what it takes, the set point alone does not protect what lies beyond: the order by distance has the draining step among its optima, beside the keeping one (`Topped.nearing_either`). A term on what lies beyond, counted after the set point, does protect it there (`Topped.counted_after_keeps`).
  > - That term leaves what lies beyond, in total, at the most any eligible way of reaching the set point leaves (`Optimum.counted_after_most`). With several conditions beyond, it can empty one of them (`Spread.counted_after_empties`). Counting less, it drains (`Topped.counted_less_drains`). After an aspiration level it keeps too (`Drain.satisficingThen_keeps`). What protects is how the choice among equal optima is made, not the set point.
  > - A formation holding its family's stock, by any means, takes at least its loss from what feeds it (`Flow.held_draws`), and joint excess applies to any such holders (`Flow.held_excess_ends`). That the holders are set-point choosers re-optimizing at every step is a reading.

- The UE1 record `capture-by-counted-choices` is unaffected.

## 5. Study, registries and generated pages

- **Study.** `texts_ue1b.py` appends [study_ue1b.txt](study_ue1b.txt) to `BECOMING-RENEWAL-READING.md` as section `N`, the next free number after UE4's and UE2's. Its title is "Set-point orders and the optimum: what an order with a point of enough does beyond what couples in (UE1b)". It holds the part 2 statement, the delta, the premises, the refactor and the 16 bookkeeping re-points, the review and the re-check.
- **`regions.json`** (`texts_ue1b.py`). The record and the module go in region `collective`, base `old-base`, as `Optimum` does, since the laws of the draw are stated on World, Flow and Web. `Becoming.Optimum`'s note changes from 503 theorems to 506.
- **Connectivity.** Run it, then `register_ue1b.py` registers the module's apart roots with a category and a reason, and the connectivity run writes `THEOREM-CONNECTIVITY`. The likely roots are the laws of the class on any outcomes and the witnesses `Spread` and `Skew`, which reach no base type. The script places a root in the module only where the receipt lists it there.
- **Board** (`board_ue1b.py`). The UE1b row goes to history, with the refactor decision.
- **Then** `make research-render`, `research-check`, `research-links` and `research-test`, in a clean worktree, as UE1's landing did.

## 6. Optional, not blocking

- **`Weightings.total_le_at_on`.** Move it down to `Dissipation`, beside `total_le_at`, and derive `Optimum.total_le_of_only` from it or drop it (review finding 17). Weightings' owner decides.
- **The prelude.** Move `Optimum.sub_le_sub_iff` and `Optimum.sub_lt_sub_iff` to `Naturals`, as R31's practice puts lemmas on Lean's numbers there (finding 17).
- **One evaluation of `transfer` on the family**, in `Optimum`, for `transfer_exceeds`, `transfer_above` and `transfer_nearer` (finding 17).
- **`MutualBest.full` and `mutual_beyond`.** Generalize them by the ranked unit, as the refactor did the one-part laws, so that several nearing optimizers below their set points are read off an exchange (finding 19). Optimum's owner decides; with the owner inactive, the lander may take it with this refactor or after.

## 7. Scripts and run order

Run from the checkout root of a clean landing worktree, after UE4's and UE2's landings, against the then-current main. Every edit asserts that it applies exactly once. `RECEIPT` is the new core receipt id and `N` the study number.

1. `python3 -B <kit>/integrate_ue1b.py`: the Lean files, root, checker and README (§1). It refuses to run if `Becoming/Optimum.lean` has changed since this note.
2. The checker (`check_becoming.py`), for a fresh core receipt `RECEIPT`.
3. `python3 -B <kit>/texts_ue1b.py RECEIPT N`: chapters 05 and 08, the study section, regions (§3, §5).
4. `python3 -B <kit>/make_records_ue1b.py RECEIPT N`: the new record. It asserts the receipt's hashes for both modules, 124 declarations and 82 theorems, empty axiom reports, the home anchor, and free aliases.
5. `python3 -B <kit>/update_room_record_ue1b.py RECEIPT N`: `room-read-off-the-exchange` (§2.2).
6. The re-point of the sixteen ([repoint_ue1b.txt](repoint_ue1b.txt)): the check, then the dry run, then `--apply`.
7. The connectivity run with its error stream kept, `python3 -B <root-foundation>/THEOREM-CONNECTIVITY.py --check > conn.log 2>&1` (it exits with the list of unregistered apart roots), then `python3 -B <kit>/register_ue1b.py conn.log RECEIPT`, then `THEOREM-CONNECTIVITY.py --write --check`.
8. `make research-render`, `research-check`, `research-links`, `research-test`.
9. `python3 -B <kit>/board_ue1b.py land UE1b RECEIPT N QUEUE STATE`. This is a copy of UE1's script with one change: the date is read from the receipt id rather than written in. A draft:
   - QUEUE: "UE1b landed (set-point orders: an order nearing a set point is not rising, its optima stand at the set point where it is reached and drain below it, the draw at it is the shortfall with the loss, and holders end what they jointly overdraw; `Becoming.SetPointOptimum` 82 theorems in 124 declarations, the rule 9 refactor of `Optimum` landed with it, core receipt `RECEIPT`, study §N, record what-a-set-point-optimum-does-beyond; part 2 had landed with UE1)";
   - STATE: "landed `<commit>`: SetPointOptimum 82 theorems in 124 declarations, every axiom report empty; corrects UE1's reading 3; reviewed and re-checked; the rule 9 refactor of Optimum landed on the lander's decision, Optimum's owner inactive; part 2 had landed with UE1 (`pooled_selectsThrough`, `pooled_unchosen_beyond`)".
