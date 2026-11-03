#!/usr/bin/env python3
"""T2S's edits, by script on the landing tree (every file is shared): T2's statement from UE32's proposals 1, 2 and 4.

The study section's number is the next free one on the tree it runs on, and the chapters' links to it follow it.
Each old text must occur exactly once; nothing already applied is applied again.
usage (from the checkout root): python3 -B edit_t2s.py"""
import re
import sys
from pathlib import Path

STUDY = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md')
M02 = Path('theories/becoming/chapters/02-MAP.md')
M08 = Path('theories/becoming/chapters/08-METHOD.md')
SCI = Path('theories/becoming/review/SCIENCES.md')
EN = Path('theories/becoming/THE-THEORY-OF-BECOMING.md')
ZH = Path('theories/becoming/THE-THEORY-OF-BECOMING.zh.md')
EXP = Path('experiments/state-against-embedding')
RB = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/'
          'READING-BUDGETS.md')

TITLE = "T2's statement: the level alone at the regime's-step end, the horizon's grain and the lag's place (T2S)"


def slug(heading):
    s = heading.strip().lower()
    s = re.sub(r"[^\w\- ]", '', s)
    return s.replace(' ', '-')


def next_section():
    nums = [int(m) for m in re.findall(r'^## (\d+)\. ', STUDY.read_text(encoding='utf-8'), flags=re.M)]
    return max(nums) + 1


N = next_section()
ANCHOR = slug(f'{N}. {TITLE}')
STUDY_LINK = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{ANCHOR}'
PROPOSALS_02 = '../../../experiments/state-against-embedding/T2-PROPOSALS.md'

ITEM2_OLD = 'the level alone forecasting as well at five years'
ITEM2 = ("the level alone forecasting as well as the three numbers at five steps of the grain at which they are read, "
         "fixed before the data (five years in the fisheries), in a series not shown to sit at the regime's-step end "
         "(where, by a test fixed before the data, the upper confidence bound on what the recent giving and the lag "
         "together remove, beyond chance, of the residual variance the level leaves in the next giving is below a "
         "tenth)")
ITEM2_SHORT = ("the level alone forecasting as well as the three numbers at five steps of the grain they are read at, "
               "fixed before the data, in a series not shown by a bound to sit at the regime's-step end")
FORBIDS_OLD = ("a fourth variable removing a tenth of the residual variance in the median series; "
               f"{ITEM2_OLD}; the lag's coefficients changing sign between series")
FORBIDS = ("a fourth variable removing a tenth of the residual variance in the median series; "
           f"{ITEM2}; the lag's coefficients changing sign between series")
CLAIM_OLD = 'The state of a renewable condition under a draw is its level, its recent giving and one lag'
CLAIM = CLAIM_OLD + ', its place named before the data'

WHY_02 = ("At the regime's-step end the next giving is a function of the level alone, with the draw, so there T2's own "
          "law has the level alone forecast as well; the end is shown by a bound, not by a failure to detect the "
          "recent giving: an item lifted by that failure would lapse where the data are poorest. Where the item is "
          "read across series, a series so shown leaves the pool. The condition's renewal is one source for the lag's "
          "place; the tests so far named it before the data: one year back in the fish stocks tested, from MQ4's post "
          "hoc reading of other stocks and a generic reading of age structure, not from each stock's renewal, and two "
          "censuses back in the flour beetle, from its life cycle.")

RESTATED_02 = (f"Restated on 4 November 2026 from UE32's proposals 1, 2 and 4 ([T2-PROPOSALS]({PROPOSALS_02}), "
               f"[study §{N}]({STUDY_LINK})), with one reader's findings: the second forbidden item names what the "
               "level alone is set against, the three numbers, is read at the grain fixed before the data and is "
               "lifted only in a series shown to sit at the regime's-step end, which forbids less; the lag's place is "
               "named before the data, which forbids more, a lag placed after the data being no longer T2's. No "
               "completed verdict changes. Only MQ5's report (median error at five years, the level alone 0.392 against "
               "the three numbers' 0.194; reported, not a verdict) set the level alone against the three numbers on a "
               "condition under a draw, and no test of the bound has been run on it; the three numbers were read with "
               "MQ4's frozen rate φ = 0.96, chosen on other stocks, near the other end (the frozen rest at 1). UE31's V4 "
               "did so only on control cultures with no set loss, outside T2's claim, reported only. MQ3's F2, MQ4's F5 "
               "and MQ6's T1a set the level alone against other forecasts, so they read other claims; UE31's and "
               "UE31b's V4 keep their frozen rules. The third proposal, narrowing \"as far as anything measured does\" "
               "to \"as far as the level's own history does\", waits on a frozen run that fails it.")

STUDY_SECTION = f"""

## {N}. {TITLE}

Board item T2S, the coordinator's item of 4 November 2026, from three of UE32's four proposals for T2's statement ([T2-PROPOSALS](../../../../experiments/state-against-embedding/T2-PROPOSALS.md)), with one reader's findings ([REVIEW](development/ue-unified-explanation/t2-statement/REVIEW.md)). T2 is unmigrated, as every thesis is: its home is [02 §5](../../../../theories/becoming/chapters/02-MAP.md#t2) with its row in 08's thesis table, and no record states it. This section is its correction under RESULT-WORKFLOW, every completed verdict kept.

```text
Result(s): none reused and none new; thesis T2 (home 02 §5, 08's thesis table), unmigrated.
Correction:
  - The second forbidden item, "the level alone forecasting as well at five years", is met by T2's own law at the
    regime's-step end T2's sentence names: in MQ5's three-number form, gamma_t = phi gamma_(t-1) + (1 - phi) g(E_t)
    + lambda (E_(t-1) - E_t), at phi = 0 and lambda = 0 the next giving is g(E_t), a function of the level alone
    with the draw, so a series sitting there would have counted against T2 although T2's law held of it (the
    sciences dossier's S-15, question 4). It now reads: "the level alone forecasting as well as the three numbers
    at five steps of the grain at which they are read, fixed before the data (five years in the fisheries), in a
    series not shown to sit at the regime's-step end (where, by a test fixed before the data, the upper confidence
    bound on what the recent giving and the lag together remove, beyond chance, of the residual variance the level
    leaves in the next giving is below a tenth)". The end is shown by a bound, not by a failure to detect: in MQ5's frozen dry
    runs its S1 found the recent giving in only 67 of 145 stocks generated by T2's own law, so an item lapsing
    where the recent giving goes undetected would lapse most where the data are poorest. The bound borrows the
    first item's tenth and its count beyond chance, so no value is chosen for the purpose. Read across series, a series so shown leaves the
    pool. The item forbids less, and only in series so shown.
  - "As well as the three numbers" is the reader's finding, not a proposal: the old item named nothing the level
    alone is set against, and the list of tests that read it, taken from "at five years", mixed tests that set the
    level alone against the three numbers with tests that set it against other forecasts.
  - The horizon was in years, the fisheries' step, though T2 claims every renewable condition under a draw; every
    test read it at a grain fixed before its data (UE31 §4 the census). The item now says so; nothing tested changes.
  - "One lag" now reads "one lag, its place named before the data". It forbids more: a lag placed after the data is
    not T2's. MQ5's one-year lag was named before its data, from MQ4's post hoc reading of other stocks (G3's excess
    mostly the lagged escapement) and a generic reading of age structure. Not "at the delay of renewal", UE31's
    wording: MQ5's level is the spawning biomass, whose delay of renewal is the age at maturity, in most of its
    species longer than one year (general knowledge of the species, not a measurement of MQ5's stocks), so that
    wording would have needed MQ5's pass restated.
Kept: every completed verdict. Only MQ5's report (§280; not a verdict) set the level alone against the three
       numbers on a condition under a draw: at five years, median error 0.392 against 0.194 and direction 0.467
       against 0.618. No test of the bound has been run on it, so the item applies to MQ5's stocks as before. UE31's
       V4 did so on its 13 control cultures (T2's law better in 9, worse in 4, p = 0.27, reported only); with no set
       loss they lie outside T2's claim and show only that V4 runs. MQ3's F2 (§272: against the frozen rest and
       persistence), MQ4's F5 (§277: against the level with the recent giving) and MQ6's T1a (§314: the regime
       margin against the frozen rest, persistence and trend at three and five days in yeast) set the level alone
       against other forecasts and read other claims; their verdicts stand as they were. T2-PROPOSALS' proposal 1
       and UE32's design (§12, frozen) counted MQ4 among the tests that read the item; under its present words it
       reads another claim. UE31's V4, run, and UE31b's,
       frozen, keep their rules: V4 fails T2 only where the level alone forecasts better on both of its
       criteria, and the showing it would now need first is a change to a frozen rule, which holds for designs frozen
       after it. At the regime's-step end the level alone, with fewer parameters fitted, can forecast better out of
       sample, so under those frozen rules V4 can still fail T2 there; such a failure counts as their rules say, with
       the bound the item now asks for read beside it, reported.
Not taken: proposal 3, narrowing "as far as anything measured does" to "as far as the level's own history does",
       waits on a frozen run that fails it; UE31b's design expects its run to.
Deferred: RESULT-WORKFLOW's step 2 migrates an unmigrated claim when a study substantively changes it, and this
       study does: the item forbids less and the lag's place more. Migration is deferred, not met. Migrated alone, T2
       would be the one thesis in the register, apart from T1 and T3 to T8, and none of the register's kinds
       (theorem, argument, assessment, target) fits a conjecture with frozen verdicts cleanly, though the empirical
       assessments come nearest. T1S also left T1 unmigrated, without stating a ground. The theses' migration
       together is
       proposed to the coordinator on the board, not done here.
Text: 02 §5 (T2's state sentence, its Forbids, sentences on the end, the pool and the lag's place, a dated note
       closing its Standing), 08's thesis row (claim, Standing, Forbids), the sciences dossier's summary row and S-15
       (Meaning, Standing and use, the dossier's bullet on the constant dilution, question 4 asked of the answer),
       the overview's thesis row (EN, ZH: the lag's place named, and the second item, now conditional, replaced among
       the main cases by the third), READING-BUDGETS' sciences figures, UE32's README and T2-PROPOSALS (the
       proposals' standing). The three records bound to the overview, whose theses section changed only in T2's row,
       re-pointed after reading; nothing they say changed. No other record drifts.
Review: REVIEW_LINE
```
"""

EDITS = {
    M02: [
        ("*The state of a renewable condition under a draw* is its level, its recent giving and one lag; with the draw",
         "*The state of a renewable condition under a draw* is its level, its recent giving and one lag, its place "
         "named before the data; with the draw"),
        (f"*Forbids*: {FORBIDS_OLD}. *Evidence*:", f"*Forbids*: {FORBIDS}. {WHY_02} *Evidence*:"),
        ("at the census grain, as the test expects of cultures under one; that shows the rules run on the archive, not "
         "how cultures under a loss would read.",
         "at the census grain, as the test expects of cultures under one; that shows the rules run on the archive, not "
         f"how cultures under a loss would read. {RESTATED_02}"),
    ],
    M08: [
        (f"| T2. {CLAIM_OLD} | [02](02-MAP.md#t2) |", f"| T2. {CLAIM} | [02](02-MAP.md#t2) |"),
        ("being too short for its rules) | " + FORBIDS_OLD + " |",
         "being too short for its rules); restated on 4 November 2026 from UE32's proposals 1, 2 and 4, no completed "
         "verdict changed ([02](02-MAP.md#t2)) | " + FORBIDS + " |"),
    ],
    SCI: [
        ("| [T2](#s-15): the state of a renewable condition under a draw is its level, its recent giving and one lag | "
         "conjectured; untested outside fisheries | " + FORBIDS_OLD + " |",
         "| [T2](#s-15): the state of a renewable condition under a draw is its level, its recent giving and one lag, "
         "its place named before the data | conjectured; untested outside fisheries | a fourth variable removing a "
         f"tenth of the residual variance in the median series; {ITEM2_SHORT}; the lag's coefficients changing sign "
         "between series |"),
        (f'Quote [theories/becoming/chapters/08-METHOD.md]: "T2. {CLAIM_OLD}". It forbids Quote '
         f'[theories/becoming/chapters/08-METHOD.md]: "{FORBIDS_OLD}".',
         f'Quote [theories/becoming/chapters/08-METHOD.md]: "T2. {CLAIM}". It forbids Quote '
         f'[theories/becoming/chapters/08-METHOD.md]: "{FORBIDS}".'),
        ('Quote [_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue0-third-parts/'
         'AUDIT.md]: "no Lean statement excludes what T2 forbids, so it is a conjecture, not a third part".',
         'Quote [_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue0-third-parts/'
         'AUDIT.md]: "no Lean statement excludes what T2 forbids, so it is a conjecture, not a third part". Restated on 4 '
         'November 2026: Quote [theories/becoming/chapters/02-MAP.md]: "No completed verdict changes".'),
        ("Since the level alone was the state there, the second forbidden item, the level alone forecasting as well at "
         "five years (read at the culture's own grain), could be met in such a culture; neither chapter says whether "
         "that item stands at the law's regime's-step end (question 4).",
         "Since the level alone was the state there, the second forbidden item, the level alone forecasting as well as "
         "the three numbers at five steps of the culture's grain, could be met in such a culture. The chapters now lift that item where a "
         "test fixed before the data shows, by a bound, a series at the regime's-step end; no such bound was computed "
         "at MQ6's constant dilution (question 4)."),
        ("Should the second forbidden item, the level alone forecasting as well at five years, exclude the "
         "regime's-step end, and what would mark a series as near it?",
         "The second forbidden item now excludes a series shown to sit there, by a test fixed before the data "
         "(Meaning). Is that the right mark, given that a series too short or noisy for the bound stays within the "
         "item, so that T2 is most exposed where the data are poorest?"),
        ("The verdicts against prior work quoted here come from AI reviews",
         "On 4 November 2026 (T2S) the front's T2 row and S-15 took T2's statement as its home restated it from UE32's "
         "proposals: the second forbidden item set against the three numbers, read at the grain fixed before the data "
         "and lifted only in a series a test shows, by a bound, to sit at the regime's-step end, the lag's place named "
         "before the data, and question 4 asked of that answer. An independent AI reader, read-only, read the change "
         "against the proposals and the study, and then the fixes; its findings were checked against the sources and "
         "taken or argued ([the reading](../../../_process/research/2026-10-05-generative-foundation-review/"
         "root-foundation/development/ue-unified-explanation/t2-statement/REVIEW.md)). The verdicts against prior work "
         "quoted here come from AI reviews"),
    ],
    EN: [
        ("| T2 | A renewable condition's state under a draw is its level, recent giving and one lag |",
         "| T2 | A renewable condition's state under a draw is its level, recent giving and one lag, its place named "
         "before the data |"),
        ("| a fourth variable removing a tenth of the residual variance in the median series; the level alone "
         "forecasting as well at five years | [02](chapters/02-MAP.md#t2) |",
         "| a fourth variable removing a tenth of the residual variance in the median series; the lag's coefficients "
         "changing sign between series | [02](chapters/02-MAP.md#t2) |"),
    ],
    ZH: [
        ("| T2 | 一个可更新的缘在取用之下的状态，就是它的水平、近来的给予与一个滞后 |",
         "| T2 | 一个可更新的缘在取用之下的状态，就是它的水平、近来的给予与一个滞后，其位置在读数据之前定下 |"),
        ("| 第四个变量在中位序列中去掉十分之一的残差方差；单凭水平在五年尺度上预测得一样好 | [02](chapters/02-MAP.md#t2) |",
         "| 第四个变量在中位序列中去掉十分之一的残差方差；滞后的系数在序列之间变号 | [02](chapters/02-MAP.md#t2) |"),
    ],
    EXP / 'T2-PROPOSALS.md': [
        ("They come from UE31 and UE31b, which read T2 in the flour beetle, and from the sciences dossier's question 4.",
         "They come from UE31 and UE31b, which read T2 in the flour beetle, and from the sciences dossier's question 4. "
         f"**Taken on 4 November 2026:** proposals 1, 2 and 4 are in 02 §5, 08's row and S-15 "
         f"([study §{N}](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/"
         f"BECOMING-RENEWAL-READING.md#{ANCHOR})); proposal 3 waits on a frozen run that fails the clause. The study also "
         "names what the level alone is set against, the three numbers, so of the readings listed under proposal 1 only "
         "MQ5's report read the item; MQ3's F2 and MQ4's F5 read other claims."),
    ],
    RB: [
        ("| Overview (and Chinese) | 7,219 words and 19 characters (55.6 to 72.3 minutes), stating about an hour; "
         "Chinese 216 words and 12,499 characters (49.7 to 64.7 minutes) | An hour | Done: 1228 budget-words over;",
         "| Overview (and Chinese) | 7,223 words and 19 characters (55.6 to 72.3 minutes), stating about an hour; "
         "Chinese 216 words and 12,506 characters (49.8 to 64.7 minutes) | An hour | Done: 1232 budget-words over;"),
        ("sciences (1,316 words, 10.1 to 13.2, since SF of 4 November, 216 over, its section stating ten to fourteen "
         "minutes since SF:",
         "sciences (1,351 words, 10.4 to 13.5, since T2S of 4 November, 251 over, its section stating ten to fourteen "
         "minutes since SF:"),
        ("with the time ecology's path takes and since TS4 the bound on the point's exactness, kept with the excess "
         "recorded",
         "with the time ecology's path takes, since TS4 the bound on the point's exactness and since T2S T2's second "
         "forbidden item with its condition, kept with the excess recorded"),
        ("6,279 words, 48.3 to 62.8 minutes, since SF,",
         "6,446 words, 49.6 to 64.5 minutes, since T2S of 4 November, which restated T2's second forbidden item and its "
         "lag's place in the front's row and S-15,"),
        ("Sciences' hour runs 279 words past it at the slower rate, by T1's standing and tests from its home, in the "
         "front and S-14, the bound on the point's exactness in the front, and the front's sentence",
         "Sciences' hour runs 446 words past it at the slower rate, by T1's standing and tests from its home, in the "
         "front and S-14, the bound on the point's exactness in the front, T2's restatement in the front's row and "
         "S-15, and the front's sentence"),
        ("sciences 144 to 187 since SF of 4 November.", "sciences 146 to 189 since T2S of 4 November."),
    ],
    EXP / 'README.md': [
        ("- [T2-PROPOSALS.md](T2-PROPOSALS.md): four proposals for T2's owner, documents only. About fifteen minutes.",
         "- [T2-PROPOSALS.md](T2-PROPOSALS.md): four proposals for T2's owner, documents only. About fifteen minutes. "
         f"Proposals 1, 2 and 4 were taken into T2's statement on 4 November 2026 ([study §{N}](../../_process/research/"
         f"2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{ANCHOR})); proposal 3 "
         "waits on a frozen run that fails it."),
    ],
}


def main():
    review = Path(__file__).with_name('review_line.txt')
    line = review.read_text(encoding='utf-8').strip() if review.exists() else 'pending.'
    for path, pairs in EDITS.items():
        s = path.read_text(encoding='utf-8')
        for old, new in pairs:
            assert s.count(old) == 1, (str(path), s.count(old), old[:100])
            assert new not in s, (str(path), 'already applied', new[:100])
            s = s.replace(old, new, 1)
        path.write_text(s, encoding='utf-8')
        print('edit:', path)
    s = STUDY.read_text(encoding='utf-8')
    assert TITLE not in s, 'study section already written'
    STUDY.write_text(s.rstrip('\n') + '\n' + STUDY_SECTION.replace('REVIEW_LINE', line), encoding='utf-8')
    print('edit:', STUDY, f'§{N}', ANCHOR)


if __name__ == '__main__':
    if len(sys.argv) != 1:
        sys.exit(__doc__)
    main()
