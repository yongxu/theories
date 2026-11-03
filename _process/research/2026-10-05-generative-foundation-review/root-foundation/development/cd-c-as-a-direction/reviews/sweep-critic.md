<!-- AI-written report, sweep-critic, an independent reader of board item CD, 3 November 2026; kept as returned. -->

**Completeness critique of the CD sweep (read only, worktree at 01c0328b2; `sweep.py` reproduces the 695 hits exactly)**

**1. Rule-sorted hits (all 324 read)**

Almost all are correctly kept. Two need action:
- **ONE-ARGUMENT.md:90**, "the policy reads the bay's level and fishes best where it has been". It was filed as `field` only because "policy" is nearby, and its basis is missing. Restate it with the basis (highest catch? most effort?).
- **07:749, THE-THEORY-OF-BECOMING.md:173 and its .zh:173 ("排序")**, T8's "ranked by what every valuer counting everything shares (order: C)". The basis is given, but it states C's role with "ranked". Rows 28–31 make "order" the one word for every order, so this should become "ordered by".

Misfiled but correctly kept:
- 07:94, 07:102 and 07:107 were filed `textual` (a nearby "[below]" matched) but are named orders.
- ONE-PAGE.zh.md:9 "社群的最优进程" was filed `field` because "训练" is in the window. Changes row 4 already covers it through the English line.

**2. Words the regex missed**

Nothing new states a comparison with no basis. Checked and kept:
- "graver", "greater rescue", "worsening" and "prefer" in 07:595–599 are disclosed commitments.
- "who wins more" (COLLECTIVE:119) is a field's frame.
- "beaten on the family", "outweighs", "favours", "top", "for good" and "at most" all carry their basis.
- 胜过 has its basis stated; 最大 (zh:67) is a set's largest member.
- 高下, 优劣, 好于, 更佳 and 更有价值 do not occur.

Two borderline items:
- 07:567 "alteration lacks advantage … a better alternative" has its basis only in the J1–J4 header. Consider naming it there.
- The regex lacks 排定. That missed ONE-PAGE.zh.md:26 "排定一个已陈述的情形" (see 3d).

**3. changes.tsv**

a. **The rubric and the proposals disagree.** DESIGN §4 keeps C's verdict on two named courses ("C ranks it higher", "leaves that pair unranked"), but rows 10–11 and 18–21 restate exactly those. Either amend §4 so the change applies to the fronts only, or drop the rows. If they stay, ONE-ARGUMENT:110 ("C ranks restraint higher") and COLLECTIVE:78 and :117 ("unranked") need the same change.

b. **"takes" as C's verb** (rows 18–21, 24–25, 27) causes three problems:
- It departs from DESIGN §2's second sentence ("is the better").
- It invites the choice-rule reading DESIGN warns against, and sits next to "choices take more" (row 30).
- It collides with the glossary's "take" = draw (GLOSSARY:35) inside a fishing example. "C takes it over fifty" also reads as the phrasal verb "take over". In Chinese, 取 likewise collides with 取用, and row 21 puts 应取 and 取它 side by side.

Suggested wording: "C puts it before fifty" or "C counts it the better", and in Chinese "C 把它置于五十吨之前".

c. **Row 36** (ONE-ARGUMENT:98 "the one to take") drops "better", against DESIGN §5's rule that "calling widening better" stays. It is a case of two named courses. Row 34 leaves COLLECTIVE:30 and COLLECTIVE:77 with two different forms on one page.

d. **The same-word rows (28, 31, 37) are applied piecemeal.**
- "ranks nothing" or "rank anything" also appears at 07:229 (the same table as row 27), 07:499, 07:510, 08:87, README-FIRST-SCREEN:6, ONE-PAGE:24, THE-THEORY-OF-BECOMING:137, ONE-ARGUMENT:94 and :102, and COLLECTIVE:101.
- "Self-concern ranks one case" also appears at ONE-PAGE:26 (and .zh "排定"), THE-THEORY-OF-BECOMING:142 (and .zh "对一种情形排序") and 07:509.
- Change all of them or none. 07:770 and COLLECTIVE:77 already say "orders nothing".

e. **Missing C statements and role clauses.**
- 08:234, "an extension with no loss that realizes more is better … the only premise that ranks courses", has no row.
- 07:510, 07:770 and 08:87 lack the role clause "read from the difference".
- Row 15 (AGENTS.md) drops "alone".
- "two options" (rows 12, 14, 15, 41) and "two courses" (rows 26, 29) are mixed. Pick "courses".

f. **The proposed "direction" row (row 13)** has two problems:
- "never … to a best" overstates. On a finite listing, a course widening every other can exist; point 6 concerns endless chains only.
- Its one sense ("the way C compares") clashes with 07 §7 "The conditional direction", which needs C, J1–J4 and E, and with "the second-order direction of 生生" (07:94, 104, 109, 787), which is explicitly beyond C. ONE-ARGUMENT:14 "the direction takes more" also reads differently. The row must cover these uses, or they need renaming.

g. **The fisher basis (rows 1–4).** In `exact.py`, COMM maximizes "total catch this season plus a terminal value for the stock left (the seasons after it)". Plain "total catch" reads as the season's catch only. Add "this season and after it", and in Chinese 本季及其后. The rendering "使社群总渔获最大的进程" is natural.

h. **The other Chinese renderings.**
- "扩大可形成者是应取的方向" is natural and faithful.
- "进程之间的次序需要它" is natural. However, "C 给出次序；进程之间的次序需要它" is near-circular, and so is the English. "every order of courses" or "任何进程之间的次序" would be clearer.
- Row 11's "C 不作声" diverges from its English, "does not decide between them". Match the overview: either "C silent" with 不作声, or "不判定二者" to match row 25.

i. **DESIGN housekeeping.**
- DESIGN §5 says "§4.4's table", but the table is in §4 (07:229–230).
- DESIGN §5 lists 01, but changes.tsv has no 01 row. 01:7 already uses the kept "calling widening better" form.
- Row 13's "why" text is garbled.

Files: `/Users/ren/theories/.claude/worktrees/reader-measure/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/cd-c-as-a-direction/{DESIGN.md,changes.tsv,hits.tsv,sweep.py}`, and `/Users/ren/theories/.claude/worktrees/reader-measure/experiments/direction-installation/exact.py`.