#!/usr/bin/env python3
"""The Chinese fronts and their one navigation line (RW, 8 November 2026).

Every Chinese front opens with the same line: its English edition, then the Chinese ways in in one order, the page
itself in bold and not linked; a way in whose page is English says so. The line is built here, so the hand-written
pages, the generated ones (the lineage, the Chinese landing page, the crosswalk's Chinese front, the Chinese of the
graph's spine sections) and the check agree.
Chapter 6, written in Chinese and with no English edition, carries the line too, without the English link.

The Chinese landing page, README.zh.md, is generated from _process/navigation/README-ZH.md, its links written from that file as README.md's first screen's
are: its reading times, its
counts of results and its navigation line are filled at render (`render`), by the rule README.md's first screen uses,
so no figure on it is copied by hand. Fields: {{nav}}; {{time:PATH}}, a page's reading time (a page the render writes
is timed as it is about to be written); {{time:chapters}}, the eight chapters' span in hours; {{time:screen}} and
{{time:page}}, the page's first screen (above its first `## `) and the whole page; {{stated:PATH}}, the reading time a
page states of itself in its opening lines; {{count:registered}} and {{count:STATUS}}; {{tests:ARG}}, README.md's
first screen's counts of the tests naming a thesis (tests_page.screen_count).

usage: python3 -B tools/research/zh_fronts.py   (prints each front whose line differs, exits 1 if any)
"""
from __future__ import annotations

from pathlib import Path
import posixpath
import re
import sys

ROOT = Path(__file__).resolve().parents[2]

# The ways in, in the line's order: (label, repository path).
WAYS = (('首页', 'README.zh.md'),
        ('一页', 'theories/becoming/ONE-PAGE.zh.md'),
        ('用途', 'theories/becoming/USES.zh.md'),
        ('实例', 'theories/becoming/USES-EXAMPLES.zh.md'),
        ('总览', 'theories/becoming/THE-THEORY-OF-BECOMING.zh.md'),
        ('八章（英文）', 'theories/becoming/chapters/README.md'),
        ('古文（第六章）', 'theories/becoming/chapters/06-CLASSICAL-TEXTS.md'),
        ('检验', 'TESTS.zh.md'),
        ('对照表', 'theories/becoming/results/atlas/CROSSWALK.zh.md'),
        ('怎样长成', 'theories/LINEAGE.zh.md'),
        ('术语表', 'GLOSSARY.zh.md'),
        ('审查包', 'theories/becoming/review/README.zh.md'))
# The fronts that carry the line, each with its English edition.
FRONTS = {'README.zh.md': 'README.md',
          'theories/becoming/ONE-PAGE.zh.md': 'theories/becoming/ONE-PAGE.md',
          'theories/becoming/USES.zh.md': 'theories/becoming/USES.md',
          'theories/becoming/USES-EXAMPLES.zh.md': 'theories/becoming/USES-EXAMPLES.md',
          'theories/becoming/THE-THEORY-OF-BECOMING.zh.md': 'theories/becoming/THE-THEORY-OF-BECOMING.md',
          'theories/LINEAGE.zh.md': 'theories/LINEAGE.md',
          'theories/becoming/results/THEORY-GRAPH.zh.md': 'theories/becoming/results/THEORY-GRAPH.md',
          'GLOSSARY.zh.md': 'GLOSSARY.md',
          'theories/becoming/review/README.zh.md': 'theories/becoming/review/README.md',
          'theories/becoming/results/atlas/CROSSWALK.zh.md': 'theories/becoming/results/atlas/CROSSWALK.md',
          'theories/becoming/chapters/06-CLASSICAL-TEXTS.md': None,
          'TESTS.zh.md': 'TESTS.md'}
# Generated, each by its generator, which takes the line from here.
GENERATED_FRONTS = ('theories/LINEAGE.zh.md', 'README.zh.md', 'theories/becoming/results/atlas/CROSSWALK.zh.md',
                    'theories/becoming/results/THEORY-GRAPH.zh.md', 'TESTS.zh.md')
# Written by hand.
HAND_WRITTEN = tuple(p for p in FRONTS if p not in GENERATED_FRONTS)


def _link(label: str, target: str, page: str) -> str:
    return f'[{label}]({posixpath.relpath(target, posixpath.dirname(page) or ".")})'


def nav_line(page: str) -> str:
    """The line for a front: [English] · then each way in, the page itself bold and not linked."""
    if page not in FRONTS:
        raise KeyError(f'not a Chinese front: {page}')
    items = [_link('English', FRONTS[page], page)] if FRONTS[page] else []
    items += [f'**{label}**' if target == page else _link(label, target, page) for label, target in WAYS]
    return ' · '.join(items)


OPENING = 12  # the line stands among a front's opening lines, under its title


def current(page: str, root: Path = ROOT) -> str | None:
    """The page's navigation line as it stands: the first of its opening lines that opens with its English link, or
    None where it has none or the page is missing."""
    path = root / page
    if not path.is_file():
        return None
    lines = path.read_text(encoding='utf-8').split('\n')[:OPENING]
    first = '[English](' if FRONTS.get(page) else f'[{WAYS[0][0]}]('
    return next((line for line in lines if line.startswith(first)), None)


def problems(pages=HAND_WRITTEN, root: Path = ROOT) -> list[str]:
    """Each front whose line is missing or differs from `nav_line`."""
    return [f'{page}: its navigation line is not the Chinese fronts\' line' for page in pages if current(page, root) != nav_line(page)]


# --- the Chinese landing page, generated ----------------------------------------------------------------------------

TEMPLATE = '_process/navigation/README-ZH.md'
PAGE = 'README.zh.md'
GENERATED = ('<!-- Generated by tools/research/research.py render (tools/research/zh_fronts.py) from _process/navigation/README-ZH.md; '
             'edit that file, not this page. -->')
FIELD = re.compile(r'\{\{([a-z]+)(?::([^}]*))?\}\}')
CHAPTERS = tuple(f'theories/becoming/chapters/{n}' for n in ('01-ROOT.md', '02-MAP.md', '03-KNOWING.md', '04-LIFE.md', '05-COLLECTIVES.md',
                                                                 '06-CLASSICAL-TEXTS.md', '07-SIGNIFICANCE.md', '08-METHOD.md'))
STATED = re.compile(r'^\*[^*\n]*分钟[^*\n]*\*$', re.M)


def zh_time(text: str) -> str:
    """A reading time in Chinese, by README.md's rule: '11–14 分钟', or '1 分钟'."""
    from tools.research import navigation
    t = navigation.reading_time(text)
    return '1 分钟' if t == 'a minute' else t.replace(' minutes', ' 分钟')


def settle(timed) -> str:
    """A page's time of itself, by README.md's rule: `timed(t)` is the page's time with `t` written in; iterate until a
    value repeats and take the longer of the cycle."""
    from tools.research import navigation
    t, seen = timed(''), []
    while t not in seen:
        seen.append(t)
        t = timed(t)
    return max(seen[seen.index(t):], key=navigation.span)


def _hours(minutes: float) -> str:
    h = round(minutes / 30) / 2
    return f'{h:g}'


# --- the tests in Chinese, generated -------------------------------------------------------------------------------

TESTS_PAGE = 'TESTS.zh.md'
TESTS_DATA = 'theories/becoming/results/data/tests.json'
TESTS_LINES = 'theories/becoming/results/data/tests.zh.json'
METHOD_THESES = 'theories/becoming/chapters/08-METHOD.md#theses'
TESTS_GENERATED = ('<!-- Generated by tools/research/research.py render (tools/research/zh_fronts.py) from '
                   f'{TESTS_DATA} and {TESTS_LINES}; edit those, not this page. -->')
# The classes that scored something, in TESTS.md's order: the failures first.
SCORED_ZH = (('failed', '未通过', '冻结的判定未通过。'),
             ('mixed', '有通过，有未通过', '冻结的判定有的通过、有的未通过，或者判定通过，而通向论题的那座桥不成立。'),
             ('refused', '评分之前被拒绝', '运行停在设计事先写定的一项检查上，没有任何判定被评分。'),
             ('decided-nothing', '什么也没有判定', '运行完成了，但它的规则无法作出判定。'),
             ('partly-passed', '部分通过', '所问之事有的成立，其余不成立或没有到达。'),
             ('not-rejected', '未被拒绝', '在冻结的阈值上，数据没有拒绝论题；这不等于得到支持。'),
             ('passed', '通过', '每一项冻结的判定都通过。'),
             ('registered-rule', '由登记的规则判定', '由分析之前登记的规则判定，没有预测方向。'))
OTHER_ZH = (('no-verdict', '只作报告、没有判定'), ('not-run', '已冻结、尚未运行'), ('held', '暂缓、未冻结'), ('dropped', '运行之前放弃'),
            ('no-prediction', '并非本论的预测'))


def _cell(text: str) -> str:
    return re.sub(r'(?<!\\)((?:\\\\)*)\|', r'\1\\|', ' '.join(text.split()))  # a pipe after an even run of backslashes is bare


def _lines_problems(held, ids) -> list[str]:
    """What is wrong with the Chinese lines: not an object, a line for no test, a field missing or empty."""
    if not isinstance(held, dict):
        return [f'zh fronts: {TESTS_LINES}: "lines" is not an object']
    found = [f'zh fronts: {TESTS_LINES} has a line for a test that does not exist: {k}' for k in held if k not in ids]
    for k, line in held.items():
        if not isinstance(line, dict) or not all(isinstance(line.get(f), str) and line[f].strip() for f in ('en', 'en_name', 'name', 'gloss')):
            found.append(f'zh fronts: {TESTS_LINES}: the line for {k} needs non-empty en, en_name, name and gloss')
    return found


def tests_page(root: Path = ROOT, checked: bool = True) -> tuple[dict, list[str]]:
    """({TESTS.zh.md: page}, errors): the tests that scored something, failures first, a line of Chinese each. A row with
    no Chinese line, or whose English name or line has changed since it was translated, shows the English, marked, so
    the page cannot say what the row no longer says. `checked` is false where TESTS.md's own render refused the data;
    then there is no page, and that render has said why. Malformed Chinese lines, a line naming no test, and an outcome
    neither list here knows are errors."""
    import json
    from tools.research import tests_page as english_tests
    data, lines = root / TESTS_DATA, root / TESTS_LINES
    if not data.is_file() or not checked:
        return {}, []
    rows = json.loads(data.read_text(encoding='utf-8'))['tests']
    try:
        held = json.loads(lines.read_text(encoding='utf-8')).get('lines', {}) if lines.is_file() else {}
    except (ValueError, AttributeError) as e:
        return {}, [f'zh fronts: {TESTS_LINES} is not a JSON object with "lines": {e}']
    errors = _lines_problems(held, {r['id'] for r in rows})
    known = {k for k, _, _ in SCORED_ZH} | {k for k, _ in OTHER_ZH}
    errors += [f'zh fronts: no Chinese class for the outcome {k!r} (tests_page.py has it)' for k in english_tests.CLASS_KEYS if k not in known]
    if {k for k, _, _ in SCORED_ZH} != set(english_tests.SCORED):
        errors.append('zh fronts: the Chinese page\'s scored classes are not tests_page.py\'s SCORED')
    if errors:
        return {}, errors
    by = {}
    for r in rows:
        by.setdefault(r['outcome'], []).append(r)
    counts = '，'.join(f'「{label}」{len(by[k])}' for k, label, _ in SCORED_ZH if by.get(k))
    others = '，'.join(f'「{label}」{len(by[k])}' for k, label in OTHER_ZH if by.get(k))
    scored = sum(len(by.get(k, [])) for k, _, _ in SCORED_ZH)
    body = []
    for key, label, gloss in SCORED_ZH:
        if not by.get(key):
            continue
        body += [f'## {label}', '', gloss, '', '| 检验 | 论题 | 冻结 | 运行 | 一句话［AI 读法］ |', '|---|---|---|---|---|']
        for r in sorted(by[key], key=lambda r: (r['run'] or r['frozen'] or '9999', r['id'])):
            line = held.get(r['id'])
            if line and line['en'] == r['gloss'] and line['en_name'] == r['name']:
                name, said = line['name'], line['gloss']
            else:
                name, said = r['name'] + '（英文）', r['gloss'] + '（英文）'
            theses = '、'.join(t.strip() for t in r['thesis'].split(',') if t.strip())
            body.append(f"| [**{_cell(r['id'])}**]({r['folder']}) {_cell(name)} | {_cell(theses or '—')} | {r['frozen'] or '—'} | {r['run'] or '—'} | {_cell(said)} |")
        body.append('')
    lead = [f'本论的经验论题接受评分之前就已冻结的检验。这里按结局列出已经评分的 {scored} 项，未通过的在前（全部 {len(rows)} 项中：{counts}；'
            f'此外{others}，见[英文的全表](TESTS.md)）。', '',
            f'每行链接该项检验的文件夹（英文）；那句话由 AI 读取其记录写成，是一种读法。冻结，指预测或规则定下的那一天。各项检验的结局按所在文件夹的判定归类，'
            f'引文与来源在英文的全表里。论题各说什么、禁止什么，见[方法一章的论题]({METHOD_THESES})（英文）。',
            '']
    head = lambda t: [TESTS_GENERATED, '', '# 检验', '', nav_line(TESTS_PAGE), '', f'*约 {t}读完。*', '',
                      '*AI 依英文版写成，未经人工审读；义以英文版为准，英文版又以各项检验的文件夹为准。*', '']
    final = lambda t: '\n'.join(head(t) + lead + body).rstrip('\n') + '\n'
    page = final(settle(lambda t: zh_time(final(t))))
    return {TESTS_PAGE: page}, errors


def inputs(root: Path = ROOT) -> list[Path]:
    """The files the landing page and the tests page read, for the render's input snapshot."""
    template = root / TEMPLATE
    if not template.is_file():
        return []
    named = {arg for kind, arg in FIELD.findall(template.read_text(encoding='utf-8')) if kind in ('time', 'stated') and arg.endswith('.md')}

    def hand_written(p):  # a page the render writes is no input of it: it is timed as the render writes it
        return p.is_file() and '<!-- Generated by ' not in p.read_text(encoding='utf-8')[:400]
    extra = {root / p for p in (TESTS_DATA, TESTS_LINES) if (root / p).is_file()}
    return sorted({template} | extra | {root / p for p in named | set(CHAPTERS) if hand_written(root / p)})


def render(records: list, outputs: dict, root: Path = ROOT) -> tuple[dict, list[str]]:
    """(pages, errors): README.zh.md from its template, every field filled; a page the render writes is read as it is
    about to be written. No page where a field is unknown, malformed or names a missing page."""
    from tools.research import navigation
    template = root / TEMPLATE
    if not template.is_file():
        return {}, [f'{TEMPLATE} is missing']
    errors, stated = [], {}
    from tools.research import tests_page as english_tests
    checked = english_tests.PAGE in outputs or not (root / TESTS_DATA).is_file()
    if not checked:  # TESTS.md's own render refused the data and has said why; the landing page, which times both, waits
        return {}, []
    tests, tests_errors = tests_page(root, checked=checked)
    if tests_errors:  # the landing page times the tests page: without it, say why, not that a time is missing
        return {}, tests_errors
    outputs = {**outputs, **tests}  # the landing page times the tests page as it is about to be written

    def text_of(path):
        if path in outputs:
            return outputs[path]
        p = (root / path).resolve()
        if Path(root).resolve() not in p.parents or not p.is_file():
            errors.append(f'{TEMPLATE} names a missing page: {path}')
            return ''
        text = p.read_text(encoding='utf-8')
        if '<!-- Generated by ' in text[:400]:  # its copy on disk is the last render's, as README.md's rule says
            errors.append(f'{TEMPLATE} times a page the render writes after this one: {path}')
            return ''
        return text

    def fill(m):
        kind, arg = m.group(1), m.group(2) or ''
        if kind == 'nav':
            return m.group(0)  # filled after the links are adapted: it is written from the page
        if kind == 'count':
            if arg == 'registered':
                return str(len(records))
            if arg not in navigation.STATUS_TEXT:
                errors.append(f'{TEMPLATE} names an unknown status: {arg}')
                return m.group(0)
            return str(sum(r['status'] == arg for r in records))
        if kind == 'tests':  # README.md's first screen's counts, by the same function
            from tools.research import tests_page as english_tests
            try:
                return str(english_tests.screen_count(arg, root))
            except english_tests.UnknownCount as e:
                errors.append(f'{TEMPLATE} {e}')
                return m.group(0)
            except english_tests.Unreadable as e:
                errors.append(f'{TEMPLATE} counts the tests: {e}')
                return m.group(0)
        if kind == 'time' and arg in ('screen', 'page'):
            return m.group(0)
        if kind == 'time' and arg == 'opening':  # the opening's body, without its notes, as README.md's first screen times it
            try:
                body_of_opening = navigation.readme_opening(root=root).partition('\n### Notes\n')[0]
            except (ValueError, OSError) as e:
                errors.append(f'{TEMPLATE} times the opening: {e}')
                return m.group(0)
            if not body_of_opening.strip():
                errors.append(f'{TEMPLATE} times the opening, which has no body')
                return m.group(0)
            return zh_time(body_of_opening)
        if kind == 'time' and arg == 'chapters':
            spans = [navigation.span(navigation.reading_time(text_of(c))) for c in CHAPTERS]
            return f'{_hours(min(lo for _, lo in spans))}–{_hours(max(hi for hi, _ in spans))} 小时'
        if kind == 'time':
            return zh_time(text_of(arg))
        if kind == 'stated':
            found = STATED.search('\n'.join(text_of(arg).split('\n')[:OPENING]))
            if not found:
                errors.append(f'{arg} states no reading time in its opening lines')
                return m.group(0)
            stated[m.group(0)] = found.group(0).strip('*').rstrip('。').replace('|', '\\|')
            return m.group(0)  # filled after the links are adapted
        errors.append(f'{TEMPLATE} has an unknown field: {m.group(0)}')
        return m.group(0)

    body = re.sub(r'\A\s*<!--.*?-->\s*', '', template.read_text(encoding='utf-8'), count=1, flags=re.S)  # the template's own note
    body = navigation.adapt_links(FIELD.sub(fill, body), TEMPLATE, PAGE)  # its links are written from the template, as README.md's
    body = body.replace('{{nav}}', nav_line(PAGE))
    for field, value in stated.items():
        body = body.replace(field, value)
    body = GENERATED + '\n\n' + body.lstrip('\n')
    # The page's own times, each by README.md's rule; the screen's first, then the page's with it in place.
    screen_time = settle(lambda t: zh_time(body.replace('{{time:screen}}', t).replace('{{time:page}}', '').split('\n## ', 1)[0]))
    body = body.replace('{{time:screen}}', screen_time)
    body = body.replace('{{time:page}}', settle(lambda t: zh_time(body.replace('{{time:page}}', t))))
    if errors:
        return {}, ['zh fronts: ' + e for e in errors]
    if '{{' in body:
        return {}, [f'zh fronts: {TEMPLATE} has a malformed field: ' + body.split('{{', 1)[1][:40]]
    return {PAGE: body, **tests}, tests_errors


if __name__ == '__main__':
    found = problems()
    print('\n'.join(found) or 'every Chinese front carries the line')
    sys.exit(1 if found else 0)
