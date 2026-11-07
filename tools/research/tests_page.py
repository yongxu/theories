"""The tests (TESTS.md): every test of the account's theses, by how it came out, the failures first.

The rows are curated data (theories/becoming/results/data/tests.json): each names its folder, the thesis it bears on,
when it was frozen and run, and quotes its outcome from its own folder. The class beside the quote is a reading of that
quote, labelled as such on the page. A quote that its file no longer holds, word for word, is an error at render, so the
page cannot drift from what the tests' folders say."""
import json
import re
import subprocess
from pathlib import Path

from tools.research import navigation, registry

ROOT = registry.ROOT
DATA = 'theories/becoming/results/data/tests.json'
PAGE = 'TESTS.md'
METHOD = 'theories/becoming/chapters/08-METHOD.md'
# Order on the page: the failures first, then what was neither, then what passed, then what never ran.
CLASSES = [
    ('failed', 'Failed', 'The frozen verdicts failed.'),
    ('mixed', 'Mixed', 'Some frozen verdicts passed and some failed, or the verdicts passed and the bridge to the thesis failed.'),
    ('refused', 'Refused before scoring', 'The run stopped at a check its design set before any verdict was scored.'),
    ('decided-nothing', 'Decided nothing', 'The run completed and its rules could not decide.'),
    ('partly-passed', 'Partly passed', 'Some of what the test asked held, and the rest did not or was not reached.'),
    ('not-rejected', 'Not rejected', 'The data did not reject the thesis at the frozen thresholds; that is not support.'),
    ('passed', 'Passed', 'Every frozen verdict passed.'),
    ('registered-rule', 'Decided by a registered rule', 'Decided by a rule registered before the analysis, with no direction predicted.'),
    ('no-verdict', 'Reported without a verdict', 'A stage reported without a verdict, as its design says; what was expected before the run is not a prediction of the account.'),
    ('not-run', 'Frozen, not run', 'Designed and frozen; no data scored yet.'),
    ('held', 'Held', 'Designed, not frozen.'),
    ('dropped', 'Dropped', 'Stopped before any run.'),
    ('no-prediction', 'No prediction of the account', 'Built, calculated or measured with no prediction of a thesis frozen before it; where a Frozen date is given, it is the day a protocol or plan was fixed.'),
]
CLASS_KEYS = [c[0] for c in CLASSES]
FIELDS = ('id', 'name', 'thesis', 'folder', 'frozen', 'run', 'outcome', 'quote', 'quote_path', 'gloss')
DATE = re.compile(r'^(\d{4}-\d{2}-\d{2})?$')
SCORED = {'failed', 'mixed', 'refused', 'decided-nothing', 'partly-passed', 'not-rejected', 'passed', 'registered-rule'}
PUSH_SCREEN = 'tools/research/push_screen.sh'


def private_pattern(root=ROOT):
    """The push screen's private paths, read from its p= line (the site builder reads the same line)."""
    screen = Path(root) / PUSH_SCREEN
    for line in (screen.read_text().splitlines() if screen.is_file() else []):
        if line.startswith('p=$(') and "grep -E '" in line:
            return re.compile(line.split("grep -E '", 1)[1].rsplit("')", 1)[0])
    return re.compile(r'^(sources/1[238]-|tmp/|work/|\.claude/)')


def tracked(paths, root=ROOT):
    """Those of paths the repository tracks, or None where root is not a repository (a test's throwaway folder)."""
    out = subprocess.run(['git', 'ls-files', '-z', '--'] + sorted(paths), cwd=root, capture_output=True)
    if out.returncode:
        return None
    return {p for p in out.stdout.decode().split('\0') if p}


def inputs():
    data = ROOT / DATA
    paths = {data, ROOT / METHOD, ROOT / PUSH_SCREEN}
    try:
        for row in json.loads(data.read_text()).get('tests', []):
            for key in ('folder', 'quote_path'):
                if isinstance(row.get(key), str):
                    paths.add(ROOT / row[key])
    except (OSError, ValueError):
        pass
    return paths


def squash(text):
    return re.sub(r'\s+', ' ', text).strip()


def validate(data, root=ROOT):
    errors = []
    rows = data.get('tests') if isinstance(data, dict) else None
    if not isinstance(rows, list) or not rows:
        return [DATA + ': no tests list']
    if not re.fullmatch(r'\d{4}-\d{2}-\d{2}', str(data.get('as_of', ''))):
        errors.append(DATA + ': as_of is not a date')
    method = (Path(root) / METHOD).read_text() if (Path(root) / METHOD).is_file() else ''
    for q in data.get('method_quotes', []):
        if not isinstance(q, dict) or not isinstance(q.get('text'), str) or squash(q['text']) not in squash(method):
            errors.append(f'{DATA}: method §9 no longer says, word for word: {str(q)[:80]}…')
    private = private_pattern(root)
    named = {r[k] for r in rows if isinstance(r, dict) for k in ('folder', 'quote_path') if isinstance(r.get(k), str)}
    known = tracked(named, root)
    seen = set()
    for k, row in enumerate(rows):
        if not isinstance(row, dict):
            errors.append(f'{DATA} test {k}: not an object')
            continue
        where = f"{DATA} test {row.get('id', k)}"
        missing = [f for f in FIELDS if not isinstance(row.get(f), str)]
        if missing:
            errors.append(f'{where}: missing {", ".join(missing)}')
            continue
        if row['id'] in seen:
            errors.append(f'{where}: a second row with this id')
        seen.add(row['id'])
        if row['outcome'] not in CLASS_KEYS:
            errors.append(f"{where}: unknown outcome {row['outcome']!r}")
        for key in ('frozen', 'run'):
            if not DATE.match(row[key]):
                errors.append(f'{where}: {key} is not a date: {row[key]!r}')
        if row['thesis'] and not re.fullmatch(r'T[1-8](, ?T[1-8])*', row['thesis']):
            errors.append(f"{where}: thesis is not T1 to T8: {row['thesis']!r}")
        o, fz, rn = row['outcome'], row['frozen'], row['run']
        if (o in SCORED and not (fz and rn)) or (o == 'no-verdict' and not rn) or (o == 'not-run' and (not fz or rn)) \
                or (o == 'held' and (fz or rn)) or (o == 'dropped' and rn) or (fz and rn and fz > rn):
            errors.append(f"{where}: its dates (frozen {fz or '—'}, run {rn or '—'}) do not fit the class {o}")
        for key in ('folder', 'quote_path'):
            path = row[key]
            if path.startswith('/') or '..' in path.split('/') or private.search(path):
                errors.append(f'{where}: {key} is not a public path of the repository: {path}')
            elif known is not None and path not in known:
                errors.append(f'{where}: {key} is not tracked: {path}')
        if not (root / row['folder']).is_file():
            errors.append(f"{where}: its folder's page is missing: {row['folder']}")
        quoted = root / row['quote_path']
        if not quoted.is_file():
            errors.append(f"{where}: the quoted file is missing: {row['quote_path']}")
        elif squash(row['quote']) not in squash(quoted.read_text()):
            errors.append(f"{where}: {row['quote_path']} no longer says, word for word: {row['quote'][:80]}…")
    return errors


def cell(text):
    return text.replace('|', '\\|').replace('\n', ' ')


def theses(field):
    return ', '.join(f'[{t.strip()}]({METHOD}#theses)' for t in field.split(',') if t.strip()) or '—'


MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November',
          'December']


def day(iso):
    y, m, d = iso.split('-')
    return f'{int(d)} {MONTHS[int(m) - 1]} {y}'


def by_thesis(rows):
    """A table of the theses against the classes: how many tests of each came out each way (a test bearing on two
    theses counts under both; tests bearing on none are a row of their own)."""
    shown = [k for k in CLASS_KEYS if any(r['outcome'] == k for r in rows)]
    labels = dict((k, label) for k, label, _ in CLASSES)
    out = ['| Thesis | ' + ' | '.join(labels[k] for k in shown) + ' |', '|---|' + '---|' * len(shown)]
    keys = [f'T{n}' for n in range(1, 9)] + ['']
    for t in keys:
        mine = [r for r in rows if (t in [x.strip() for x in r['thesis'].split(',')] if t else not r['thesis'].strip())]
        if not mine:
            continue
        name = f'[{t}]({METHOD}#theses)' if t else 'none named'
        cells = [sum(r['outcome'] == k for r in mine) for k in shown]
        out.append(f'| {name} | ' + ' | '.join(str(n) if n else '·' for n in cells) + ' |')
    return out


def render_page(data):
    rows = data['tests']
    by = {k: [r for r in rows if r['outcome'] == k] for k in CLASS_KEYS}
    counts = '; '.join(f'{len(by[k])} {label.lower()}' for k, label, _ in CLASSES if by[k])
    nav = ' · '.join(navigation.link(p, PAGE, label) for p, label in navigation.NAV)
    lead = [
        f'Every test in [experiments](experiments/README.md) by how it came out, the failures first: {len(rows)} in all '
        f'({counts}), as of {day(data["as_of"])}. Each row links its folder and quotes the outcome from its pages (one, '
        'where they have no sentence to quote, from method §9), the source linked; its class is read from the folder\'s '
        'verdicts, and its plain gloss is a restatement [AI reading]. The rows were drafted from the folders by an AI reader '
        'and checked against them by a second; no person has checked them. A row\'s thesis is the one method §9 or the '
        'test\'s folder names; Frozen is the day its prediction, rule or plan was fixed, and Run the day the run finished. '
        'Experiments retired to [experiments/history](experiments/history/INDEX.md) are not listed. T8 is argued, and no '
        'test bears on it.',
        '',
        f'How to read a verdict, in [method §9](theories/becoming/chapters/08-METHOD.md#theses)\'s words: '
        + ' '.join(f'"{q["text"]}{"…" if q.get("continues") else ""}"' for q in data.get('method_quotes', [])),
        '',
        '## By thesis',
        '',
        'How many tests of each thesis came out each way (a test bearing on two theses counts under both; "·" is none). '
        'What each thesis says and forbids is in [method §9](theories/becoming/chapters/08-METHOD.md#theses).',
        '',
    ] + by_thesis(rows) + ['']
    body = []
    for key, label, gloss in CLASSES:
        group = by[key]
        if not group:
            continue
        body += [f'## {label}', '', f'*{gloss}*', '', '| Test | Thesis | Frozen | Run | Plainly [AI reading] | In its folder\'s words |',
                 '|---|---|---|---|---|---|']
        for r in sorted(group, key=lambda r: (r['run'] or r['frozen'] or '9999', r['id'])):
            body.append(f"| [**{cell(r['id'])}**]({r['folder']}) {cell(r['name'])} | {theses(r['thesis'])} | {r['frozen'] or '—'} "
                        f"| {r['run'] or '—'} | {cell(r['gloss'])} | \"{cell(squash(r['quote']))}\" ([source]({r['quote_path']})) |")
        body.append('')
    head_time, full_time = navigation.reading_time('\n'.join(lead)), navigation.reading_time('\n'.join(lead + body))
    head = ['# Tests', '', f'<!-- Generated by tools/research/research.py render from {DATA} (tools/research/tests_page.py). '
            'Edit the data, not this view. -->', '', nav, '',
            f'*The lead and the summary by thesis: {head_time} to read; every row: {full_time}.*', '']
    return registry.finish(head + lead + body)


def render():
    """{TESTS.md: page} and the errors that stop a render."""
    p = ROOT / DATA
    if not p.is_file():
        return {}, []
    try:
        data = json.loads(p.read_text())
    except ValueError as e:
        return {}, [f'{DATA}: not JSON: {e}']
    errors = validate(data)
    if errors:
        return {}, errors
    return {PAGE: render_page(data)}, []
