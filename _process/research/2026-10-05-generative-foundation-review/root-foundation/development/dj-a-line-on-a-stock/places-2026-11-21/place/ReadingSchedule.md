# ReadingSchedule

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadingSchedule.lean`
- *result records that name this place's file as a source* (computed; not a link): `one-reader-several-conditions`

## 21 November, how a registering comes to be: reader readings-and-the-lock

*As "ReadingSchedule.lean". A reader's return, unchecked; what the note mended is in the note: [note](../../read-registering-2026-11-21/NOTE.md), [report](../../read-registering-2026-11-21/read-readings-and-the-lock.md.txt).*

- **what registers what**: One reader reads one condition a step by a supplied schedule s (Within 88, Unread 92).
- **what changes it**: The schedule is handed in and fixed.
- **laws where something comes to be registered**: None found in what was read.
- **cost and keeping**: density (265): distinct names and windows a c with q c * a c ≤ P give total q ≤ P (reciprocals sum ≤ 1). no_two_three (278), spare_not_enough (898). half_suffices (616), keeps_of_half (912).
- **a registering lost**: Balances.loses_of_unread (690), in a balanced flow: a stretch of k steps left unread lets a part drawing at least d a step take (k+1+ℓ)d. A significant formation admitted without the part, requiring c, with l t c \< need + (k+1+ℓ)d, is lost (W.Adds). Premises as listed in the report.
- **tied to what it rests on**: keeps_iff_within (879), premises (a+ℓ)d ≤ m \< (a+1+ℓ)d: a schedule keeps c within margin m against every balanced flow's draws exactly where it reads c within every a steps. General; the schedule does not change.

## 22 November, every module by fifteen questions

*pass a: reader whole-a-15, as "ReadingSchedule.lean: keeps_iff_within, Balances.loses_of_unread, spare_not_enough, keeps_of_half" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-15.md.txt)); pass b: reader whole-b-56, as "ReadingSchedule.lean: keeps_iff_within, within_of_keeps, Flow.Balances.retains_of_read, Flow.Balances.loses_of_unread, density, pool_density, no_two_three, spare_not_enough, half_suffices, keeps_of_half, Keeps, Within" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-56.md.txt)); the third pass, where the two differed: reader whole-c-settle-21, as "ReadingSchedule.lean: settled fields share, cost" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-21.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `keeps_iff_within` (l. 879) gives the exact reading window for a universal retention guarantee at a specified margin, lag and draw bound. `spare_not_enough` (l. 898) and `keeps_of_half` (l. 912) respectively give incompatible windows with spare capacity and a sufficient dyadic weight bound for one schedule to keep all listed conditions.
  - *pass b:* The module states, generally over schedules and balanced flows, that a schedule reading one condition a step keeps a condition c within margin m against draws of at most d a step, withdrawn ℓ steps after a reading, exactly where it reads c within every a steps, given (a+ℓ)d ≤ m \< (a+1+ℓ)d (keeps_iff_within). One direction is the margin law Balances.retains_of_read; the other uses the built Drawer witness. It also states pinwheel-scheduling capacity laws: a counting bound that is necessary (density, pool_density, keeps_density) but not sufficient (no_two_three, spare_not_enough), and a constructive sufficiency at half density via dyadic codes (kraft_reads, half_suffices, keeps_of_half).
- **moves**
  - *pass a:* S: `keeps_of_half` (l. 912) constructs a schedule choosing at most one condition per step given positive windows, margins covering (a+ℓ)d, and weights q satisfying 2^(D+1) ≤ qa with total ≤ 2^D.
  - *pass b:* S: the schedule s : Nat → X is a choice of which condition to read at each step. `spare_not_enough` (l. 898) and `no_two_three` (l. 278): no schedule keeps, or reads, three distinct conditions with windows 2, 3 and M. `density` (l. 265): every schedule reading each condition within a c has counts with q c * a c ≤ P totalling at most P. `keeps_of_half` (l. 912) and `half_suffices` (l. 616): where the windows' weights total at most half, some schedule keeps every condition. There is no Process S A.
- **a reading**
  - *pass a:* S: `Flow.taken_of_read` (l. 645) bounds cumulative take by (a+ℓ)d given reading within a, draw ≤ d, no draw before T, and withdrawal after the lag following a reading at or after T.
  - *pass b:* S: `Within` (l. 88) and `Keeps` (l. 732). `keeps_iff_within` (l. 879): what the schedule reads decides whether every balanced flow's withdrawn drawer leaves retained what has significance without it. `Flow.Balances.retains_of_read` (l. 662): reading each condition the part draws on within a c, with levels without the part exceeding each need by (a c + ℓ) d c, gives Retains. `within_iff` (l. 122): with equality decided, reading within a is leaving no stretch of a steps unread.
- **a share**
  - *settled by the third pass:* S for the count, N for a rule set again from it: `density` (l. 265): for a schedule `s : Nat -> X` reading each condition of a list, distinct by name, `Within` its window `a c`, counts `q c` with `q c * a c <= P` total at most P; `pool_density` (l. 240): the same for a pool with `(r t).length <= k`, total at most `P * k`; `keeps_density` (l. 887). These count the readings of each condition among one reader's steps. `two_three_room` (l. 302) is arithmetic: `3 * M + 2 * M + 6 < 6 * M` for `7 <= M`. No rule or favouring is set again from any of these counts. [which pass was right: both in part; opened: Within (l. 88), PoolWithin (l. 184), times (l. 194), PoolWithin.count (l. 226), pool_density (l. 240), density (l. 265), no_two_three (l. 278), two_three_room (l. 302), keeps_density (l. 887), spare_not_enough (l. 898)]
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* S: `density` (l. 265), `pool_density` (l. 240) and `keeps_density` (l. 887) count readings: q c with q c * a c ≤ P total at most P (or P k for a pool), the rates summing to at most 1. `two_three_room` (l. 302): an idle share 1/6 − 1/M. N: no rule or favouring is set again from a share.
- **a level that runs down**
  - *pass a:* S: `Flow.Balances.loses_of_unread` (l. 690) uses balanced levels, a non-giving drawer and a lower draw bound until withdrawal. A significant formation admitted without the drawer loses admission when its required condition’s margin is smaller than the accumulated draw. No return flow depends on the remaining amount here.
  - *pass b:* S: `Flow.Balances.loses_of_unread` (l. 690): in a balanced flow, a part giving nothing to c and taking at least d a step until ℓ steps after the next reading, with c unread for k steps, draws (k+1+ℓ)d. A formation requiring c whose level without the part is short of need plus that draw is lost (W.Adds). `retains_of_read` (l. 662) is the retaining side. B: `Drawer.web` (l. 790): the level starts at n d + m and falls by what the drawer takes.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: levels, needs and the drawer's taking are supplied (Flow, Web and the premises draw, start, withdrawn). In loses_of_unread the part gives nothing (premise gives). The reader is a schedule handed in, not a going-on of the model that can be lost.
- **a cost to the one that keeps or gives**
  - *settled by the third pass:* S, in a weaker form: `keeps_density` (l. 887): a schedule that `Keeps` each condition of a list, distinct by name, within margins `m c < (a c + 1 + l) * d c`, has counts `q c` with `q c * a c <= P` totalling at most P; with `within_of_keeps` (l. 848) and `keeps_iff_within` (l. 879): under `(a + l) * d <= m < (a + 1 + l) * d` keeping c is exactly reading it within every a steps. So keeping takes readings from a schedule that reads one name a step (`s : Nat -> X`), and `spare_not_enough` (l. 898) and `no_two_three` (l. 278) show the limit. This is a bound on the reader's steps, not a debit on its standing or anything it forgoes besides other readings. `pool_density` (l. 240), which pass a cites, is about reading within windows and does not mention keeping. [which pass was right: both in part; opened: pool_density (l. 240), density (l. 265), no_two_three (l. 278), taken_of_read (l. 645), Balances.retains_of_read (l. 662), Balances.loses_of_unread (l. 690), Keeps (l. 732), keeps_of_within (l. 744), Drawer.flow (l. 784), Drawer.web (l. 790), within_of_keeps (l. 848), keeps_iff_within (l. 879), keeps_density (l. 887), spare_not_enough (l. 898), keeps_of_half (l. 912)]
  - *pass a:* S: `pool_density` (l. 240) counts reading slots spent. For distinct names read within their windows and counts satisfying q(c)a(c) ≤ P, total counts cannot exceed Pk when at most k names can be read per step.
  - *pass b:* N: reading costs the reader only a step of its schedule. No law makes keeping cost the one that keeps.
- **multiplying**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: there are no units that leave units. Code and pair build trees of readings, not populations.
- **a point of no return**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: `Flow.Balances.loses_of_unread` (l. 690) concludes that a formation is lost at one step t (W.Adds). The module states no irreversibility and no point after which no schedule keeps it.
- **both outcomes**
  - *pass a:* S: `keeps_iff_within` (l. 879), with decidable equalities and (a+ℓ)d ≤ m \< (a+1+ℓ)d, equates keeping in every admissible balanced flow with reading the condition in every a-step window. Failure negates the universal guarantee.
  - *pass b:* S: `keeps_iff_within` (l. 879), general: a schedule keeps c (retained in every balanced flow) exactly when it reads c within every a steps, given (a+ℓ)d ≤ m \< (a+1+ℓ)d. Otherwise, by `within_of_keeps` (l. 848) with the Drawer witness, a formation needing c is lost. This is keeping and losing, not going on and ending.
- **a comparison between two**
  - *pass a:* S: `Flow.Balances.retains_of_read` (l. 662) carries admission of significant formations from withheld levels to actual levels under balance, reading windows, bounded draws, withdrawal and adequate margins at required conditions.
  - *pass b:* S: `Within.mono` (l. 96): reading within a window carries to every longer one (closed upward). `weave_left` (l. 346) and `weave_right` (l. 356): what a schedule reads within a, the interleaving reads within 2a. `Within.pool` (l. 188): one reader is a pool of one. `Code.At.reads` (l. 389), `pair_lift` (l. 408) and `kraft_reads` (l. 544): depth-k items are read within 2^k.
- **a rank (an ending within a bound)**
  - *pass a:* S: `Within.unread_lt` (l. 102) bounds any unread stretch strictly below the window. `Flow.Balances.loses_of_unread` (l. 690) uses a k-step unread stretch to force at least (k+1+ℓ)d drawn by T+k+1+ℓ under its draw hypotheses.
  - *pass b:* S: deadlines. `Within` (l. 88) asks a reading in every stretch of a steps. `Flow.taken_of_read` (l. 645): a part withdrawn ℓ steps after a reading takes in all at most (a+ℓ)d. `Within.unread_lt` (l. 102): a stretch left unread is shorter than every window read within. There is no variant that falls toward an end.
- **a closed region**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no region closed under steps, invariant, kernel or fixed point is stated.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no statement or built case in which the going on continues while what is present changes, and no widening.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, moves, reading, level, cost, both_outcomes, comparison, rank. The remaining findings are N. No question was unreached.
  - *pass b:* All fourteen were answered from statements. The whole module was read: the opening account and every statement and docstring to l. 921.
