"""OU7's front refresh: OU's owner's texts (TEXTS.md, kept as sent) on the four front files, after the text review's
merge (at prepare) and the record stage, before the re-point and render. Run from the landing worktree's root:

  python3 -B <kit>/front-refresh/front_refresh.py            apply
  python3 -B <kit>/front-refresh/front_refresh.py --check    try every edit and the recount, write nothing

1. The one page, both editions: the first open item's step-5 comment gives way to TEXTS.md's sentence, the bullet's
   first sentence kept as it stands.
2. The overview, both editions: the "Conditional laws" bullet, with its step-5 comment, is replaced whole.
3. The overview, both editions: line 115's two sentences on the root fold into one clause.
4. READING-BUDGETS' one-page and overview rows are written from one recount by AJ4's measure, taken after 1-3, and the
   recount is added to the front pages' measure runs, which the rows cite.

Before anything is written, item 2's figures (219, 22, six) must be those of the record conditional-laws-of-the-corpus
as the record stage wrote it, and the two anchors item 2 links must stand once in their chapters; under --check before
the record stage, both are left to the run after it. Every sentence an edit replaces must stand once, or its new text
must already be in place, and no step-5 comment may be left; otherwise nothing is written. Run again, it finds every
edit in place and writes nothing."""
import importlib.util
import re
import subprocess
import sys
import json
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TEXTS = (HERE / 'TEXTS.md').read_text(encoding='utf-8')
BECOMING = ROOT / 'theories/becoming'
ONE, ONE_ZH = BECOMING / 'ONE-PAGE.md', BECOMING / 'ONE-PAGE.zh.md'
OVER, OVER_ZH = BECOMING / 'THE-THEORY-OF-BECOMING.md', BECOMING / 'THE-THEORY-OF-BECOMING.zh.md'
DEV = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development'
BUDGETS = DEV / 'aj4-alignment-readers/READING-BUDGETS.md'
RUNS = DEV / 'front-pages-for-a-person/MEASURE-RUNS.txt'
RUNS_LINK = '[the front pages\' measure runs](../front-pages-for-a-person/MEASURE-RUNS.txt)'
RECORD = BECOMING / 'results/records/conditional-laws-of-the-corpus.json'
ANCHORS = {'chapters/06-CLASSICAL-TEXTS.md': 'r-conditional-laws-of-the-corpus',
           'chapters/03-KNOWING.md': 'r-rooms-tested-by-a-window'}
STEP5 = {'en': re.compile(r" ?<!-- Refresh at OU's pass after §八 step 5:.*?-->"),
         'zh': re.compile(r'<!-- 于 OU 之通篇修订时.*?-->')}
NUMBERS = {'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5, 'six': 6, 'seven': 7, 'eight': 8, 'nine': 9,
           '一': 1, '二': 2, '三': 3, '四': 4, '五': 5, '六': 6, '七': 7, '八': 8, '九': 9}
RUNS_HEAD = '## OU7\'s landing'


def section(n):
    return re.search(rf'^## {n}\. .*?(?=^## |\Z)', TEXTS, re.M | re.S).group(0)


def quoted(n):
    """The blockquoted texts of TEXTS.md's section n, in order: the English, then the Chinese."""
    return [line[2:] for line in section(n).split('\n') if line.startswith('> ')]


S1, S1_ZH = quoted(1)
# Item 4's excess reasons, as TEXTS.md words them: the one page's whole, the overview's addition.
REASON_ONE = re.search(r'^- \*\*One page:\*\* the excess reason reads: "…(.+?)…"\.$', section(4), re.M)
REASON_OVER = re.search(r'^- \*\*Overview:\*\* the excess reason adds: "…(.+?)"\.', section(4), re.M)
B2, B2_ZH = quoted(2)
F3 = dict((ed, (old, new)) for ed, old, new in
          re.findall(r'^\*\*\.(md|zh\.md)\*\*: "…(.+?)" becomes "…(.+?)"$', section(3), re.M))
assert set(F3) == {'md', 'zh.md'} and B2.startswith('- **Conditional laws.**') and B2_ZH.startswith('- **有条件之律。**') \
    and REASON_ONE and REASON_OVER, 'TEXTS.md is not in the form this step reads'


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def figures():
    """Item 2's figures in each edition against the record as the record stage wrote it, and the two anchors."""
    r = json.loads(RECORD.read_text(encoding='utf-8'))
    en = re.search(r"Of the corpus's (\d+) conditional units, \d+ fall into (\d+) families of laws.*? (\d+) laws false "
                   r"as read", r['statement']['en'])
    zh = re.search(r'归为丙一之 (\d+) 条中，\d+ 条入 (\d+) 族.*?(?<!\d)(\d+) 条依读法不成立', r['statement']['zh'])
    assert en and zh, 'the record states its figures otherwise than this step reads'
    record = tuple(map(int, en.groups()))
    assert record == tuple(map(int, zh.groups())), ('the record\'s editions differ', en.groups(), zh.groups())
    a = re.search(r"corpus's (\d+) conditional statements on the grammar: (\d+) families of laws.*?; (\w+) statements "
                  r"are false as read", B2)
    b = re.search(r'古典语料中的 (\d+) 条有条件陈述写到文法上：(\d+) 族律.*?；(\S)条依所读为假', B2_ZH)
    assert a and b, 'item 2 states its figures otherwise than this step reads'
    for edition, (units, families, false) in (('en', a.groups()), ('zh', b.groups())):
        assert (int(units), int(families), NUMBERS[false]) == record, (edition, 'item 2 says', units, families, false,
                                                                     'the record', record)
    for chapter, anchor in ANCHORS.items():
        t = (BECOMING / chapter).read_text(encoding='utf-8')
        assert t.count(f'<a id="{anchor}"></a>') == 1, (chapter, anchor, 'not standing once')
        assert f'({chapter}#{anchor})' in B2 and f'({chapter}#{anchor})' in B2_ZH, (anchor, 'not linked by item 2')
    print(f'item 2\'s figures are the record\'s ({record[0]} units, {record[1]} families, {record[2]} false as read), '
          'and both anchors stand once')


def edit(text, old, new, where, done):
    if new in text:
        done.append(f'{where}: already in place')
        return text
    assert text.count(old) == 1, (where, 'the sentence it replaces stands', text.count(old), 'times')
    done.append(f'{where}: applies')
    return text.replace(old, new)


def step5(text, edition, where):
    found = STEP5[edition].findall(text)
    assert len(found) == 1, (where, 'step-5 comments found', len(found))
    return found[0]


def refreshed():
    """The four files' texts after items 1-3, and what each edit found."""
    texts = {p: p.read_text(encoding='utf-8') for p in (ONE, ONE_ZH, OVER, OVER_ZH)}
    done = []
    # 1. The one page's first open item: its comment gives way to the sentence.
    for path, edition, new in ((ONE, 'en', ' ' + S1), (ONE_ZH, 'zh', S1_ZH)):
        t = texts[path]
        if new in t:
            done.append(f'{path.name}, item 1: already in place')
        else:
            texts[path] = edit(t, step5(t, edition, path.name), new, f'{path.name}, item 1', done)
    # 2. The overview's bullet, replaced whole.
    for path, new, edition, head in ((OVER, B2, 'en', '- **Conditional laws.**'), (OVER_ZH, B2_ZH, 'zh', '- **有条件之律。**')):
        t = texts[path]
        if new in t.split('\n'):
            done.append(f'{path.name}, item 2: already in place')
            continue
        lines = [line for line in t.split('\n') if line.startswith(head)]
        assert len(lines) == 1 and STEP5[edition].search(lines[0]), (path.name, 'the bullet with its step-5 comment',
                                                                     len(lines))
        texts[path] = edit(t, lines[0], new, f'{path.name}, item 2', done)
    # 3. Line 115's two sentences, one clause.
    for path, edition in ((OVER, 'md'), (OVER_ZH, 'zh.md')):
        texts[path] = edit(texts[path], *F3[edition], f'{path.name}, item 3', done)
    for path, t in texts.items():
        assert not STEP5['en'].search(t) and not STEP5['zh'].search(t), (path.name, 'a step-5 comment is left')
    return texts, done


def recount(texts):
    """One recount of the four texts by AJ4's measure: {layer: (words, characters, low, high, time stated)}."""
    m = load('measure_layers', DEV / 'aj4-alignment-readers/kit/measure_layers.py')
    out = {}
    for name, path, start, end, budget in m.LAYERS:
        if ROOT / path in texts:
            body = m.part(texts[ROOT / path], start, end)
            en, zh = m.count(body)
            low, high = m.minutes(en, zh).split('–')
            out[name] = (en, zh, low, high, m.states_time(body), budget, path)
    assert set(out) == {'one page', 'one page, Chinese', 'overview', 'overview, Chinese'}, sorted(out)
    return out


def over(layer):
    en, zh, *_, budget, _ = layer
    return round(en + zh / 2) - budget     # budget-words as the measure runs print them


def rows(c, texts):
    """READING-BUDGETS' two rows from the recount, with the lines the excess reasons cite checked."""
    one, overview = texts[ONE].split('\n'), texts[OVER].split('\n')
    assert 'continuation condition' in one[22] and '`«续无外»`' in one[34], 'the one page\'s lines 23 and 35 moved'
    assert '`«续无外»`' in overview[114] and '`«续无外»`' in overview[163], 'the overview\'s lines 115 and 164 moved'

    def counts(en_layer, zh_layer):
        en, zh, low, high, stated, *_ = c[en_layer]
        zen, zzh, zlow, zhigh, *_ = c[zh_layer]
        chinese = 'within' if over(c[zh_layer]) <= 0 else f'{over(c[zh_layer])} over'
        return (f'{en:,} words and {zh:,} characters ({low} to {high} minutes), '
                f'{"stating its time" if stated else "not stating its time"}; Chinese {zzh:,} characters ({zlow} to '
                f'{zhigh}), {chinese}')
    n = over(c['one page'])
    done_one = (f'Done: {n} over, {REASON_ONE.group(1)}, recorded in {RUNS_LINK}' if n > 0
                else f'Done: within, recorded in {RUNS_LINK}')
    n, high = over(c['overview']), float(c['overview'][3])
    upper = (f'the upper bound, {high:.1f} minutes, is over the hour by {high - 60:.1f}, for the same reasons'
             if high > 60 else f'the upper bound, {high:.1f} minutes, is within the hour')
    done_over = (f'Done: {n} over, which OU\'s owner judged within amendment 1\'s intent (T3\'s row with a failure as it '
                 f'fell, a deciding hypothesis, and the shaping loop whose record cites the overview), {REASON_OVER.group(1)}; '
                 f'{upper}; recorded in {RUNS_LINK}' if n > 0 else f'Done: within; {upper}; recorded in {RUNS_LINK}')
    return {'| One page (and Chinese) |': f'| One page (and Chinese) | {counts("one page", "one page, Chinese")} | '
                                         f'Ten minutes | {done_one} | OU\'s owner |',
            '| Overview (and Chinese) |': f'| Overview (and Chinese) | {counts("overview", "overview, Chinese")} | '
                                         f'An hour | {done_over} | OU\'s owner |'}


def runs_block(c):
    main = subprocess.run(['git', 'rev-parse', '--short', 'refs/heads/main'], capture_output=True, text=True,
                          check=True).stdout.strip()
    lines = []
    for name in ('one page', 'one page, Chinese', 'overview', 'overview, Chinese'):
        en, zh, low, high, stated, budget, path = c[name]
        lines.append(f'{en:6d} words {zh:6d} chars  {en + zh / 2:8.0f} budget-words  {low}–{high} min  {path}')
    zh_over = [e for n, e in (('one page, Chinese', 'the one page\'s Chinese edition'),
                              ('overview, Chinese', 'the overview\'s Chinese edition')) if over(c[n]) > 0]
    return (f'\n{RUNS_HEAD} (on main {main}: the text review\'s front-page fixes merged, then OU\'s owner\'s refresh, '
            'step 5\'s conditional laws in the one page\'s first open item and in the overview\'s bullet, and the '
            'overview\'s sentences on the root folded into one clause)\n' + '\n'.join(lines) + '\n\n'
            f'Over budget: the one page by {over(c["one page"])} budget-words and the overview by '
            f'{over(c["overview"])}, for the reasons READING-BUDGETS gives (amendment 1). '
            + ('Both Chinese editions are within budget.' if not zh_over else
               'T' + ' and '.join(zh_over)[1:] + (' are' if len(zh_over) > 1 else ' is') + ' over budget.') + '\n')


def main(check):
    if RECORD.exists():
        figures()
    else:
        assert check, 'the record conditional-laws-of-the-corpus is not written: run after the record stage'
        print('the record is not yet written: item 2\'s figures and anchors are checked after the record stage')
    texts, done = refreshed()
    c = recount(texts)
    budgets = BUDGETS.read_text(encoding='utf-8')
    for head, row in rows(c, texts).items():
        found = [line for line in budgets.split('\n') if line.startswith(head)]
        assert len(found) == 1, (BUDGETS.name, head, len(found))
        budgets = edit(budgets, found[0], row, f'{BUDGETS.name}, {head.strip("| ")}', done)
    runs, block = RUNS.read_text(encoding='utf-8'), runs_block(c)
    if RUNS_HEAD in runs:
        assert block.strip() in runs, f'{RUNS.name}: an earlier recount stands, unlike this one'
        done.append(f'{RUNS.name}: the recount already in place')
    else:
        runs = runs.rstrip('\n') + '\n' + block
        done.append(f'{RUNS.name}: the recount {"would be" if check else "is"} added')
    print('\n'.join(done))
    print(block.strip())
    if not check:
        for path, t in texts.items():
            path.write_text(t, encoding='utf-8')
        BUDGETS.write_text(budgets, encoding='utf-8')
        RUNS.write_text(runs, encoding='utf-8')
    print('front refresh:', 'checked, nothing written' if check else 'written')


if __name__ == '__main__':
    main('--check' in sys.argv[1:])
