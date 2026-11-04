#!/usr/bin/env python3
"""UE32's run, its result in the shared texts, by script on the landing tree after the branch is merged: T2's home and
08's row, the sciences dossier's S-15 and its whole's time with the review covers' (EN, ZH), the overview's T2 row (EN, ZH),
the experiments index, the sources table, READING-BUDGETS and a study section.

Every statement of the verdict carries the persistence caveat beside it; the homes and S-15 also carry the embedding's
loss growing with the history it chose, and the reach (the three numbers' sufficiency against the series' longer
history at these lengths, not the lag's place or T2's law). The study section's number is the next free one on the
tree it runs on, and 02's links to it follow it. Each old text must occur exactly once; nothing already applied is
applied again. RB_FIGURES are the measured figures with these edits, set before the landing.
usage (from the checkout root): python3 -B edit_ue32r.py [--no-budgets]"""
import re
import subprocess
import sys
from pathlib import Path

STUDY = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md')
M02 = Path('theories/becoming/chapters/02-MAP.md')
M08 = Path('theories/becoming/chapters/08-METHOD.md')
SCI = Path('theories/becoming/review/SCIENCES.md')
EN = Path('theories/becoming/THE-THEORY-OF-BECOMING.md')
ZH = Path('theories/becoming/THE-THEORY-OF-BECOMING.zh.md')
EXPIDX = Path('experiments/README.md')
SRC = Path('sources/README.md')
SRCDIR = 'sources/15-codex-theory-conversations'
MQREADME = Path('experiments/margin-measured/README.md')
REV_EN = Path('theories/becoming/review/README.md')
REV_ZH = Path('theories/becoming/review/README.zh.md')
RB = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/'
          'READING-BUDGETS.md')
HERE = Path(__file__).resolve().parent

TITLE = "T2's three numbers against the field's fitted delay embedding, out of sample (UE32's run)"


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
RESULT_SCI = '../../../experiments/state-against-embedding/README.md#the-result'

EVID_02 = ("on MQ5's stocks one year ahead, against the field's fitted delay embedding of the same two series, the three "
           "numbers forecast the next giving better by UE32's frozen criterion "
           f"(§{N}: median log ratio of the embedding's error to theirs 0.16, the three numbers better in 42 of 65 "
           "stocks, p = 0.025, where UE32 expected \"not separated\"), though each forecast worse than persistence in 53 "
           "of the 65 (both in 46), and the embedding lost more the longer the history it chose: that bears on the "
           "three numbers' sufficiency against the series' longer history at these lengths, not on the lag's place or "
           "T2's law")
EVID_08 = ("UE32 found T2's numbers better than the field's fitted embedding by its frozen criterion, both behind "
           "persistence in most stocks, the embedding losing more with longer history: sufficiency against it at these "
           "lengths, not the lag's place or T2's law (better in 42 of 65 stocks, p = 0.025; expected: not separated)")
QUOTE_08 = EVID_08[len('UE32 '):EVID_08.index(' (better in 42')]
assert EVID_08.startswith('UE32 found ')

L316 = '#316-fates-on-either-side-of-the-curve-in-the-plane-in-the-field-mq7)'

# The figures measured on the landing tree with these edits (rehearsal); the landing script asserts the measure.
RB_FIGURES = {
    'whole_stated': '140 to 195',
    'slowest': '190.3',
    'overview': '7,270 words and 19 characters (56.0 to 72.8 minutes)',
    'overview_zh': 'Chinese 216 words and 12,622 characters (50.2 to 65.3 minutes)',
    'overview_over': '1279',
    'over_hour': 'thirteen',
    'ov_words': '47',
    'ov_zh': '116',
    'front': '1,365 words, 10.5 to 13.7',
    'front_over': '265',
    'hour': '6,500 words, 50.0 to 65.0 minutes',
    'hour_over': '500',
    'whole': '146 to 190',
}

EDITS = {
    M02: [
        ("(§316: 0.39 from 5 stocks, of the predicted sign, lower bound 0.00). The proved laws reach",
         f"(§316: 0.39 from 5 stocks, of the predicted sign, lower bound 0.00); {EVID_02}. The proved laws reach"),
        ("*Standing*: conjectured, on the three frozen fish-stock tests above;",
         "*Standing*: conjectured, on the four frozen fish-stock tests above;"),
        (f"{L316}). In one domain", f"{L316}, [§{N}]({STUDY_LINK})). In one domain"),
    ],
    M08: [
        ("| conjectured, on three frozen fish-stock tests; untested outside fisheries; in the flour beetle",
         "| conjectured, on four frozen fish-stock tests; untested outside fisheries; in the flour beetle"),
        ("MQ7 missed its frozen bound (0.39, lower bound 0.00); in MQ6's yeast",
         f"MQ7 missed its frozen bound (0.39, lower bound 0.00); {EVID_08}; in MQ6's yeast"),
    ],
    SCI: [
        ('Quote [theories/becoming/chapters/08-METHOD.md]: "conjectured, on three frozen fish-stock tests; untested '
         'outside fisheries"',
         'Quote [theories/becoming/chapters/08-METHOD.md]: "conjectured, on four frozen fish-stock tests; untested '
         'outside fisheries"'),
        ("and C2 was not testable. In yeast both chapters",
         f'and C2 was not testable. [UE32]({RESULT_SCI}) Quote [theories/becoming/chapters/08-METHOD.md]: '
         f'"{QUOTE_08}". In yeast both chapters'),
        ("| of three on fish stocks, one passed its state verdict; a frozen test (UE31)",
         "| of four on fish stocks, one passed its state verdict; UE32: T2's numbers beat the field's fitted embedding, "
         "both behind persistence in most stocks; a frozen test (UE31)"),
    ],
    MQREADME: [
        ("This is thesis T2, conjectured (of three frozen fish-stock tests, MQ5's passed) and untested outside fisheries.",
         "This is thesis T2, conjectured (of four frozen fish-stock tests, MQ5's passed, and in UE32 the three numbers "
         "forecast better than the field's fitted embedding, both behind persistence in most stocks) and untested "
         "outside fisheries."),
    ],
    EN: [
        ("| conjectured; of three frozen fish-stock tests one passed; untested outside fisheries |",
         "| conjectured; of four frozen fish-stock tests one passed, one failed its state verdict and one missed its "
         "bound; in the fourth the three numbers forecast better than the field's fitted embedding by its frozen "
         "criterion, a sign of their sufficiency against longer history, not of the lag's place, though both trailed "
         "persistence in most stocks; untested outside fisheries |"),
    ],
    ZH: [
        ("| 猜想；三项冻结的鱼类种群检验中一项通过；在渔业之外未经检验 |",
         "| 猜想；四项冻结的鱼类种群检验中，一项通过，一项未通过其状态裁决，一项未达其冻结界限；第四项中，按其冻结的判据，"
         "水平、近来的给予与滞后这三个量对下一次给予的预报胜过该领域拟合的延迟嵌入，这是它们相对于更长历史之充分性的一个迹象，"
         "而非滞后位置的迹象，但在多数种群中二者都不如直接沿用上一次的给予；在渔业之外未经检验 |"),
    ],
    EXPIDX: [
        (", and a test designed and frozen 3 Nov 2026 before any series was read by it, its download and run Ren's |",
         ", and a test designed and frozen 3 Nov 2026 before any series was read by it, run 4 Nov 2026 on Ren's yes: "
         "T2 better than the field's fitted embedding by its frozen criterion (median log ratio of the embedding's error "
         "to the three numbers' 0.16, the three numbers better in 42 of 65 stocks, p = 0.025; expected: not separated), "
         "both behind persistence in most stocks "
         "([result](state-against-embedding/README.md#the-result)) |"),
    ],
}


def budget_edits():
    f = RB_FIGURES
    assert not any(v.isupper() for v in f.values()), 'RB_FIGURES not set'
    return {
        SCI: [("The whole takes 140 to 190 minutes", f"The whole takes {f['whole_stated']} minutes")],
        REV_EN: [("| reading 140 to 190 minutes;", f"| reading {f['whole_stated']} minutes;")],
        REV_ZH: [("| 读约一百四十到一百九十分钟；", "| 读约一百四十到一百九十五分钟；")],
        RB: [
            ("7,223 words and 19 characters (55.6 to 72.3 minutes)", f['overview']),
            ("Chinese 216 words and 12,506 characters (49.8 to 64.7 minutes)", f['overview_zh']),
            ("Done: 1232 budget-words over; the upper bound is over the hour by about twelve minutes,",
             f"Done: {f['overview_over']} budget-words over; the upper bound is over the hour by about {f['over_hour']} minutes,"),
            ("what the two simulations' passes test ([T1's standing](../review-packet/T1-STANDING.md)). Recorded in",
             "what the two simulations' passes test ([T1's standing](../review-packet/T1-STANDING.md)). UE32's run added "
             f"{f['ov_words']} words to T2's row in §9 (Chinese {f['ov_zh']} characters): its fourth frozen fish-stock "
             "test, the three numbers better than the field's fitted embedding, with both behind persistence beside it. "
             "Recorded in"),
            ("sciences (1,351 words, 10.4 to 13.5, since T2S of 4 November, 251 over,",
             f"sciences ({f['front']}, since UE32's run of 4 November, {f['front_over']} over,"),
            ("since TS4 the bound on the point's exactness and since T2S T2's second forbidden item with its condition, kept",
             "since TS4 the bound on the point's exactness, since T2S T2's second forbidden item with its condition and "
             "since UE32's run T2's fourth frozen fish-stock test with persistence beside it, kept"),
            ("6,446 words, 49.6 to 64.5 minutes, since T2S of 4 November, which restated T2's second forbidden item "
             "and its lag's place in the front's row and S-15,",
             f"{f['hour']}, since UE32's run of 4 November, which added its verdict to the front's T2 row and to S-15 "
             "beside the frozen counts, after T2S restated T2's second forbidden item and its lag's place in the front's "
             "row and S-15,"),
            ("Sciences' hour runs 446 words past it", f"Sciences' hour runs {f['hour_over']} words past it"),
            ("T2's restatement in the front's row and S-15,", "T2's restatement in the front's row and S-15, UE32's "
             "verdict in both,"),
            ("140 to 190 for sciences since TS2 of 3 November, its readings 143.0",
             f"{f['whole_stated']} for sciences since UE32's run of 4 November, whose slowest reading, {f['slowest']} "
             "minutes, the earlier 140 to 190 no longer covered once the front and S-15 took UE32's verdict; 140 to 190 "
             "since TS2 of 3 November, its readings 143.0"),
            ("sciences 146 to 190 since FV of 4 November.", f"sciences {f['whole']} since UE32's run of 4 November, "
             f"its time stated as {f['whole_stated']} minutes since then."),
        ],
    }


def sources_table():
    files = subprocess.run(['git', 'ls-files', SRCDIR], capture_output=True, text=True, check=True).stdout.split()
    s = SRC.read_text(encoding='utf-8')
    pat = re.compile(r'\| 15a \| `15-codex-theory-conversations/` \| — \| (\d+) \| 2026-09-05 to (2026-\d\d-\d\d) \|')
    m = pat.findall(s)
    assert len(m) == 1, m
    assert f'{SRCDIR}/2026-11-04-ue32-download-and-run.md' in files, 'the source file is not tracked'
    new = f'| 15a | `15-codex-theory-conversations/` | — | {len(files)} | 2026-09-05 to 2026-11-04 |'
    SRC.write_text(pat.sub(new, s, count=1), encoding='utf-8')
    print('edit:', SRC, m[0], '->', len(files))


def apply(edits):
    for path, pairs in edits.items():
        s = path.read_text(encoding='utf-8')
        for old, new in pairs:
            assert s.count(old) == 1, (str(path), s.count(old), old[:100])
            assert new not in s, (str(path), 'already applied', new[:100])
            s = s.replace(old, new, 1)
        path.write_text(s, encoding='utf-8')
        print('edit:', path)


def main(budgets):
    apply(EDITS)
    if budgets:
        apply(budget_edits())
    sources_table()
    section = (HERE / 'study.txt').read_text(encoding='utf-8')
    line = (HERE / 'review_line.txt').read_text(encoding='utf-8').rstrip('\n')
    assert line.strip() and 'REVIEW_LINE' not in line
    section = section.replace('{N}', str(N)).replace('{TITLE}', TITLE).replace('REVIEW_LINE', line)
    assert '{' not in section.replace('{"', ''), 'placeholder left in the study section'
    s = STUDY.read_text(encoding='utf-8')
    assert TITLE not in s, 'already applied'
    STUDY.write_text(s.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')
    print('edit:', STUDY, f'§{N}', ANCHOR)


if __name__ == '__main__':
    if sys.argv[1:] not in ([], ['--no-budgets']):
        sys.exit(__doc__)
    main(sys.argv[1:] == [])
