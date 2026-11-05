# Review of T1R's freeze: an independent reader, round by round

5 November 2026. AI-written (a Claude Code session). The rule is T1N's:
- A reader other than the author reads the files before the freeze lands: a fresh Claude Opus subagent, of the theory's own family, reads them whole in the first round.
- From the second round on, the same reader, continued, reads the diff of the last round's fixes and the sections it touches, and checks this record rather than trusting it.
- The rounds stop at the first with no finding of high or medium severity, at most five.
- The reader works read-only. It downloads nothing, opens no page showing a value of the walleye records, and calls no model.
- Each round reads a commit on the branch.

**What counts as high**, the coordinator's rule for T1N carried here:
- a false sentence in a verdict;
- an outcome that worlds where it is false can produce without a clause;
- a rule that breaks on real records.

## Round 1: a full read of the design (87381662e)

7 high, 1 medium and 7 low. Three highs were worlds where V1 says something false with no clause covering it, two were rules that break on real records, and two were false sentences about what an outcome means. The reader built its worlds on the dry run's own generator. It checked every number in §8 against the record, the exact tests, the disjointness from T1N's fit, the import by hash and the freeze's chain, and found them right. The first round was cut off by the API's weekly limit and resumed by message, the same reader continuing.

| id | sev | finding | how it was taken |
|---|---|---|---|
| R-01 | high | The rise was tested against the need's fit at each lake's low level, not the lake's own renewal there. With the lakes whose renewal is lost left unstocked, the lakes read renew at any level, and V1 rose in 31 of 40 archives of 900 lakes though no lake's renewal follows the level. | The rise is now read within the lake. Each lake is also read in its last year below the need with no stocking that year, and V1 rises where more lakes renewed above the need and not below than the reverse, by an exact sign test (§7). The fit's chance at the low level is reported only. The reader's world is in the dry run's renewal-lost family: no rise in 80 archives, not decided in 36 and 38 of 40 and *did not rise* in 4 and 2. The world there also begins the other lakes' programmes ten times as soon, so that it reads many lakes, a median of 87 at 0.1. |
| R-02 | high | A year read right after a stocking let yearlings read as age 0 make renewal. With a tenth of last year's surviving stocked fish read so, renewal lost in 94% of the lakes read gave *rose* in 33 of 40, with no clause naming it. | The year read has no stocking recorded that year or the year before (§5). The reader's world is in the dry run's renewal-lost family: *did not rise* in 40 and 39 of 40, and no rise. |
| R-03 | high | Stocked cohorts counted among the adults before they spawn gave *did not rise* in T1's own world (6, 17 and 24 of 40 for one, two and three years; 39 of 40 in *needs vary*), and neither clause's stated reason covered it. | The negative outcome carries a third clause always, the adults restored counting stocked fish not yet spawning (§7), named in §13. The world is in the dry run, reported with the rivals of the negative outcome: *did not rise* in 40 and 29 of 40, each with the new clause. |
| R-04 | high | Dates in a form the reader could not read gave an empty map, not none, so every lake counted as dated and the rise dropped *unrecorded stocking*: in *no dates* with unreadable dates, 0 of 15 and 0 of 16 carried it. | "Dated" is decided lake by lake: a lake with a walleye stocking whose date gives no readable year, or in a file with no date column while the other has one, is undated, and a lake that rose undated carries *unrecorded stocking* (§3, §7). The date reader also takes ranges within a year, eight digits, a spreadsheet's day count and two-digit years. Scripted checks hold both. |
| R-05 | high | A low survey with a positive estimate and an upper bound of 0 passed, and `chance` took the log of 0: the run stopped with no result where T1N's rules read the same lakes. | The low survey and the year below need an upper bound above no adults, and `chance` gives none at no adults (§5). A scripted check holds it. |
| R-06 | high | What *did not rise* means was false in the dry run's own mixed world: "restoring the level did not raise these lakes' renewal" and "a positive T1N verdict would then rest on renewal lost, not on the need". | *Did not rise* now reads renewal short of the level's "in some of these lakes at least", in its line, §1 and §11. §11 says a positive T1N verdict may rest in part on such lakes, how far not read. |
| R-07 | high | The not-decided line said "not fewer than the need's fit expects (8.9 expected)" when 6 renewed. | The line says "not shown fewer than" and "not shown more often above"; a scripted check reads both. |
| R-08 | medium | A lake back above the need at a survey before any stocking was read as stocked back above it. | Such a lake is out, by its reason, "back above the need before it was stocked" (§5); a scripted check holds it. |
| R-09 | low | "T1R reads no lake-year that T1N's fit reads" was too broad: the low surveys and the own-level years are often fit years. | Narrowed to the years read above the need, in §1, §4, the README and `t1r.py`'s docstring. The years below the need may be fit years too, and §4 says so. |
| R-10 | low | With T1R's downloads.json present but not recording R8, an R8 file in the folder was accepted. | `run.py` refuses R8 in the folder unless downloads.json records it, in every case; the dry run checks both cases. |
| R-11 | low | R8 given as percentages was read at the wrong scale, and a lake-year given twice kept its last row, uncounted. | A share above 1 means the second route is not read, since the file may give percentages. A lake-year given twice with different shares is dropped and counted. Both are checked. |
| R-12 | low | *Unrecorded stocking* treats R5b, where read, as complete. | Named in §13: a stocking outside both records makes that lake's renewal its stocking's, holding so far. |
| R-13 | low | A lake-year with two fall surveys is read at its larger catch, and stocked lakes may be surveyed twice more often. | The run reports the years read and below with more than one fall survey, found by R2's lake and year columns alone (`additions.repeated_fall`), and §13 names it. |
| R-14 | low | §10's layout step named `additions.facts`, which only the run called. | `python3 -B additions.py facts FOLDER` prints the facts with no value read. |
| R-15 | low | Six small inaccuracies, listed below. | Each corrected, as listed below. |

R-15's six inaccuracies and their corrections:
- §3 said T1R "is not decided" where T1N's reader refuses. It now says the run writes no result.
- §8's account of T1N's speed of 0.3 now gives T1N's record: no need fitted in 33 of 40 archives of *need*.
- The fewer-than-10 line now opens "of n lakes…" like the others.
- A stocking in the low survey's own year now counts as after it, since it comes after the spring's count.
- The own level's median is stated as the upper of the middle two where they are even.
- §14 says T1N's check stops with an error on a layout.json with no `labels` key, which an addendum keeps.

**The rework, by the author.**
- **Every world at 900 lakes.** At 300, the rise within the lake read too few lakes: *need* at 0.1 rose in 18 of 40 in the author's runs. So every world is now run at 900 lakes, about the field's size, and the record's separate 900-lake cells are gone.
- **A new confounded world**, *stocked after a failed survey*. Managers begin only after a fall survey below the floor, so a run of poor years brings the stocking and then passes. A rise there would carry what held renewal down ending, and none came: *did not rise* in 40 of 40 at both speeds, with 95% of the lakes read at 0.1 having lost their renewal.
- **The year below.** The author tried keeping it two years from a stocking, as the year read is, and set that aside: *need* at 0.03 then rose in 26 of 40 against 36 (§2).
