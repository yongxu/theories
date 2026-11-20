# The table of what the repository already has toward the two ways: how it was made and what it shows

*AI-written (Claude Fable, board row DJ), 20 November 2026, at Ren's "Yes, the table". No Lean was written or changed and nothing was built. The table proves nothing: every cell is an AI reader's reading of a statement, and no proof was checked; no person has read it. Two AI readers who took no part then checked this note against the data file, the Lean of the place with all eight and the direction page: the counts are as the data file has them; eleven places here and in the page's paragraph said something false or more than the table shows, and twenty were lesser; they are mended in those readers' words and not read again. Unit, level, share, rule, giving are working names.*

## Why

The direction asks for two ways of going on placed with respect to each other: a way of selecting that uses up what it or others rest on and can no longer be turned, and a way that keeps remaking what it rests on. The direction page's section "We are far from it" says how far the repository is from that. On 20 November readers found that the section says less than the repository has, and that three proposals made from it in a day and a half had each missed something already there. So the places were set out as data.

## How

- **Fixed first** ([COLUMNS-AND-ROWS.md](COLUMNS-AND-ROWS.md)): eight columns, each with what counts as yes, in part and no; and eleven groups of places.
- **Two readers a group, who did not see each other**, filled every cell from the Lean's statements (for a program, from its code and stored output), with the declarations and their lines. Where they gave different values a third settled the cell from the statement.
- **A second round** filled ten more places in two groups: nine that readers of the first round had named as likely to have four or more of the eight (seven of them by two or more readers; `DrawHistory`, and `HorizonWebs` with `Substitution`, by one each), and the market model's program.
- **The result** is [two-ways-table.json](two-ways-table.json), with both readers' value, declarations and note for every cell and the settling where there was one; [TABLE.md](TABLE.md) is a view of it made by `build_table.py`.

89 places, 712 cells: 643 on which the two readers agreed, 69 settled by a third. By the first reader's field, 55 places are in the package's core, 30 are Lean outside the package, 3 are programs and 1 is Lean built once and not landed; the two readers differ on one place's standing (`deeper/RelationalRenewal`, whose path is outside the package). The 55 are places that were named, not a sweep of the package's 406 files.

## What it shows

**1. One place has all eight by the columns' letter, and the direction page did not name it.** `experiments/market-generativity/meta-attractor/PopulationCorrection.lean`, first committed 8 October 2026, outside the package; its theory page is `theories/meta-attractor/COLLECTIVE-DESTRUCTIVE-ATTRACTORS.md`. The writer read these statements himself, beside the two readers:

- A fixed number `N` of slots hold renewing or racing contracts; the state is how many renew, a reserve and a capacity (`State`, `next`).
- Correction acts at a step exactly where the reserve covers a fee (`funded`). Each renewing contract pays one into the reserve; while correction acts the others are charged three each (`inflow`).
- While correction does not act, a renewing contract earns strictly less at that step than a racing one against the same others, and while it acts, strictly more (`strict_revision_advantage`). The number renewing is moved by a supplied law (`allocated`: up by the schedule's `k` to at most `N` where funded, down by it where not), and every slot that law changes takes the action that pays more at that step (`revised_slot_is_optimal`).
- For every `N`, fee at most `N`, start with at most `N` renewing, and schedule revising at least one slot a step: correction is funded at some step exactly where the start's reserve with what the renewing contracts can still pay reaches the fee (`exact_schedule_activation_boundary`). Short of that the course comes to none renewing, the reserve below the fee and capacity nothing, and stays there (`schedule_shortfall_is_destructive`, `destructive_region_absorbing`); a narrower region, the shortfall at one slot a step, is never left under any such schedule (`Doomed`, `doom_history`).
- Supplied, not derived: the two actions, the payoffs (through `CollectiveDestruction.utility 2 1 …`), the charges of one and three, the law that moves the number renewing and its schedule, the reserve's cap at the fee, and the law by which capacity moves. The file claims nothing about what is best over a repeated game. Slots revise; nothing leaves offspring. Its receipt of 8 October allows the three standard axioms.
- Nothing in it reads capacity: what correction needs is the reserve, which, once it covers a fee no greater than the number of slots, does not fall; and no slot needs a level.
- So: all eight by the columns' letter, the first by a settling (one reader gave in part); the level and the giving are on the reserve, while the amount that runs down is capacity, which nothing reads; the rule is set again through the reserve that the counts feed. No one has set this place against what the direction page means.

**2. What comes next, by how many of the eight are whole.** The market model's program, not Lean (seven); then three places with six: `ResponseCapacity` in the same study, and `MarketInstances` and `MarketGenerativity` in the market model that chapter 5 §10 tells. All are outside the package.

**3. In the package's core the two halves are apart.** Of its 55 places:

| column | places where it is whole |
|---|---|
| a. multiplies | 14 |
| b. a level that can run down | 44 |
| c. gives at a cost | 1 |
| d. the source is said | 14 |
| e. what comes back | 22 |
| f. a rule set again from a share | 11 |
| g. both outcomes, with the boundary exact | 25 |
| h. no return, or a turn | 35 |

- Giving at a cost, by what rests on a level, to that same level is whole in one place, `ContinuingRevision` (a renewal act that uses one unit of the fuel and brings a supplied yield into it), where nothing multiplies. In two more, `PairSelection` and `PairFlow`, a gift at a stated cost goes to a level the giver does not rest on.
- No place has a level that can run down, what comes back, and a rule set again from a share, all three whole.
- Four places have what multiplies, what comes back and a rule set again from a share, with both outcomes exact or a point of no return: `RuleShaping`, `DrawnShaping`, `ReadInTime`, `PoolFromCourse` (chapter 2 §9 and §10). None has a level whole.
- Seven places have what multiplies on a level that can run down: `LineOnAStock`, `Reproduction`, `Copying`, `PairFlow`, `RuleRebuilding`, `ReadingsSpread`, `ReadingsPersist`. In three of them what comes back is whole (`PairFlow`, `ReadingsSpread`, `ReadingsPersist`); in none of those three is a rule set again from a share.
- Three places have a level and a rule set again from a share: the two rows of `TurningInTime` and `RuleRebuilding`. In none is what comes back whole.
- One place has what multiplies, a level that can run down and a rule set again from a count, all whole, the first by the third reader's settling: `RuleRebuilding` (chapter 5 §12). By the letters that is the three the direction page's "What is not there" speaks of; the page now names it and says why it is not taken for them (a cohort enters at a quota and not as any holder's offspring; what is set from the count is who enters).

**4. So what was not found, among the places the table has, is the pieces in one statement inside the package:** what multiplies on a level that can run down (which the line on a stock and six others have) together with what comes back and a rule set again from the share (which the four places on shaping have, with no level). The table looked for no join. A search by name found no Lean file but `PopulationRealization`, beside it, that names `PopulationCorrection`; two other files of that study, both rows of the table, do state laws of it as instances of the package's (`SharedStockInstances`, `VersionedTaskInstances`).

## What it does not show

- That any statement holds: no proof was checked. Nothing was built, and each cell is taken from a statement even where a reader also read the proof.
- That the columns are sound: they were fixed by the same writer whose reading of that morning readers had found short, and 69 cells rest on one reader's settling between two others.
- That the eight are the right properties, or that two places with the same letters say the same thing. "Multiplies" is whole for anything whose number grows by a law of the step (a share, a count of slots, a line gaining a fixed amount a step) as much as for units that leave offspring; the readers' notes say which. "Core" is the readers' field; nothing was built to check it.
- That the place with all eight is what the direction means. It was set against the eight columns, not against the direction page.
- Anything about the places not listed. Nine more were named by readers and not filled: `LineageRegions` (in the package; by its one reader likely five or six of the eight), `Weightings`' need on a web with capacities, `Arising`, `RelativePosition`, `regime/RegimeReals`, `deeper/RenewalComparison`, `deeper/RenewalRecovery`, `shared-renewal-capability/…/SelectorRevision`, and `universal-ethics/generative-capacity/GoalFormationRevision`. The package has 406 files; the rows cover the places that were named, not a sweep of all of it.

## What it cost

About 10 million tokens of AI readers' work: 8.2 million for the first round, 1.9 million for the second with one failed start. The writer had told Ren about 2 million.

## Beside it

The reading that led to the table is in [`../read-first-2026-11-20/`](../read-first-2026-11-20/DRAFT-READING.md): a first reading in seven claims, and five readers' reports on it as text. One of those reports (the sweep, its section 5) lists eight sentences of the direction page that say less than the repository has, with words for each; the direction page now points here in their place. The two checking readers' reports are beside this note as text (`check-table-data.md.txt`, `check-table-page.md.txt`). The run's journals, from which `build_table.py` made the data file, are not filed; the data file holds every cell they held.
