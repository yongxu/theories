"""ND's final stage, after the record id rename: the names that still state rank, in a tree (argv[1]).

python3 -B nd_final.py TREE --day '1 November 2026' --day-zh '2026年11月1日' --n 495

The view's generator, its data and its test move to the shared names (tools/research/shared_laws.py,
data/shared-laws.json, tests/test_shared_laws.py), with git mv. In the research tools, the measure's two scripts and
the connectivity script, every identifier, key and category value naming a master law names a shared law
(`master_laws` → `shared_laws`, `'master law'` → `'shared law'`, `'no master law'` → `'no shared law'`), and so does
their prose. Paths of study folders (ou3b-master-laws-on-the-grammar, ec6-no-master-law) and the old anchor
`master-laws` are left as they are. A few live texts follow: 08's and one record's mention of the generator, the
workflow's section on the view, the glossary's note on the former name, the Lean README's two rows, two notes in
regions.json, one item in arguments-a-l.json, the coverage file's key, and the register's reasons, where
`Concave.roots` still names `harms_superadditive` (renamed `rises_superadditive` by stage 20-nd). check_becoming.py's
scope strings are left for the next core landing: the scope is written into each core receipt, so edited without a
core run it would stand apart from the latest receipt's. The generated files (data/shared-laws.json, THEOREM-CONNECTIVITY.json, the pages) are regenerated
afterwards, never edited here."""
import argparse, json, re, subprocess
from pathlib import Path

ap = argparse.ArgumentParser()
ap.add_argument('tree')
ap.add_argument('--day', required=True)
ap.add_argument('--day-zh', required=True)
ap.add_argument('--n', required=True)
args = ap.parse_args()
T = Path(args.tree)
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
LEAN = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'

MOVES = [('tools/research/master_laws.py', 'tools/research/shared_laws.py'),
         ('tools/research/tests/test_master_laws.py', 'tools/research/tests/test_shared_laws.py'),
         ('theories/becoming/results/data/master-laws.json', 'theories/becoming/results/data/shared-laws.json')]

CODE = sorted({p.relative_to(T).as_posix() for p in (T / 'tools/research').glob('*.py')}
              | {p.relative_to(T).as_posix() for p in (T / 'tools/research/tests').glob('*.py')}
              | {'tools/research/boundary_check.lean', RF + 'THEOREM-CONNECTIVITY.py',
                 RF + 'development/ou3b-master-laws-on-the-grammar/measure_grammar.py',
                 RF + 'development/ec-elegant-completion/measure.py'})

# Identifiers, keys, file names and category values, then prose. A study folder's path or the old anchor contains
# "master-law" with a hyphen before it or "-laws" without ".json", which none of these patterns matches.
CODE_MAP = [(r'master_law', 'shared_law'), (r'MASTER_LAW', 'SHARED_LAW'), (r'MasterLaw', 'SharedLaw'),
            (r'\bmaster_rows\b', 'shared_rows'), (r'(?<![\w-])master-laws\.json', 'shared-laws.json'),
            (r"'master-laws-'", "'shared-laws-'"), (r'(?<![\w-])master law', 'shared law'),
            (r'(?<![\w-])Master law', 'Shared law')]
GUARD = re.compile(r'formerly|主律|replaced')   # a line telling the former name keeps it


def sub_lines(text, pairs):
    out = []
    for line in text.splitlines(keepends=True):
        if not GUARD.search(line):
            for a, b in pairs:
                line = re.sub(a, b, line)
        out.append(line)
    return ''.join(out)


def exact(rel, pairs):
    """Each (old, new) replaced exactly once in the file."""
    p = T / rel
    text = p.read_text(encoding='utf-8')
    for a, b in pairs:
        assert text.count(a) == 1, (rel, a, text.count(a))
        text = text.replace(a, b)
    if rel.endswith('.json'):
        json.loads(text)
    p.write_text(text, encoding='utf-8')


changed = []
for old, new in MOVES:
    subprocess.run(['git', '-C', str(T), 'mv', old, new], check=True)
for rel in CODE:
    rel = dict(MOVES).get(rel, rel)
    p = T / rel
    text = p.read_text(encoding='utf-8')
    new = sub_lines(text, CODE_MAP)
    if new != text:
        p.write_text(new, encoding='utf-8')
        changed.append(rel)

# 08 §10's sentence on where the old name stays: rename-id has rewritten the id in it, which made it name the new id
# as the old name's place; after this stage the old name stays where it is matched, not read.
exact('theories/becoming/chapters/08-METHOD.md', [
    ('`master_laws.py` checks', '`shared_laws.py` checks'),
    ('and the old name stays only in keys (the record id `shared-laws-on-the-grammar`, anchors, data fields, tools), '
     'which are matched, not read.',
     "and the old name stays only where it is matched, not read: the record's former id "
     '(`master-laws-on-the-grammar`), anchors kept beside the new ones, and the paths of the studies of its time.')])
exact('GLOSSARY.md', [('formerly "master law" (主律), a name kept only in keys',
                       'formerly "master law" (主律), a name kept only where it is matched, not read (a former id, old '
                       'anchors) and in history')])
exact(LEAN + 'README.md', [('the five master laws on the grammar, for every carrier',
                            'the five shared laws on the grammar, for every carrier'),
                           ('twenty central declarations on no master law,', "twenty central declarations on no shared law's anchor,")])
exact('theories/becoming/results/data/regions.json',
      [("GrammarLaws OU3b: the five master laws on the grammar", "GrammarLaws OU3b: the five shared laws on the grammar"),
       ('"the master laws on the grammar (OU3b)', '"the shared laws on the grammar (OU3b)')])
exact('theories/becoming/results/data/arguments-a-l.json', [('expressible is not derived; master laws;',
                                                             'expressible is not derived; shared laws;')])
exact('theories/becoming/results/completion/COVERAGE.json', [('"master_laws":', '"shared_laws":')])
exact(RF + 'THEOREM-CONNECTIVITY-APART.json',
      [('a fact about one constructed model showing harms_superadditive strict',
        'a fact about one constructed model showing rises_superadditive strict'),
       ('a law of every relation on any carrier (a master law on the grammar, OU3b)',
        'a law of every relation on any carrier (a shared law on the grammar, OU3b)')])
p = T / (RF + 'THEOREM-CONNECTIVITY-APART.json')
text = p.read_text(encoding='utf-8')
w = 'a witness that a hypothesis of a master law on the grammar cannot be omitted'
assert text.count(w) == 3, text.count(w)
text = text.replace(w, w.replace('master law', 'shared law'))
# the register's reasons cite the record by its id, which rename-id leaves to the register's owner
text, k = re.subn(r'(?<![\w-])master-laws-on-the-grammar(?![\w-])', 'shared-laws-on-the-grammar', text)
assert k >= 1, k
json.loads(text)
p.write_text(text, encoding='utf-8')
# Every kit script on main that calls the generator, its test or its data by path follows the move (paths only:
# a kit's prose is of its time), so EL6's, OG's, U4d's and SJ's kits, which reuse these steps, run on the new names;
# U4's make_record_u4.py writes one-root-to-its-edge's text and 08 §7's sentence, which name the generator. No shim
# is left under the old names. Data files, drift lists and review results keep the paths of their time.
KIT_MAP = [(r'(?<![\w-])master_laws\.py', 'shared_laws.py'), (r'(?<![\w-])test_master_laws', 'test_shared_laws'),
           (r'(?<![\w-])master-laws\.json', 'shared-laws.json')]
KIT_ROOTS = ['_process/research/2026-10-05-generative-foundation-review/root-foundation/development',
             '_process/research/2026-10-05-repository-reconciliation/architecture']
kits = []
for root in KIT_ROOTS:
    for p in sorted((T / root).rglob('*')):
        rel = p.relative_to(T).as_posix()
        if p.suffix not in ('.sh', '.py', '.js') or '/history/' in rel or 'nd-nondual-names/' in rel or not p.is_file():
            continue
        text = p.read_text(encoding='utf-8')
        new = text
        for a, b in KIT_MAP:
            new = re.sub(a, b, new)
        if new != text:
            p.write_text(new, encoding='utf-8')
            kits.append(rel)
changed.append(f'{len(kits)} kit scripts (paths only)')
print('\n'.join('  kit: ' + k for k in kits))

# AJ4's failure-mode map links the view's data, which moved; its prose on master laws is its owner's
exact(RF + 'development/aj4-alignment-readers/FAILURE-MODE-MAP.md',
      [('the master-laws view ([`master-laws.json`](../../../../../../theories/becoming/results/data/master-laws.json), '
        'generated by `tools/research/master_laws.py`)',
        'the shared-laws view ([`shared-laws.json`](../../../../../../theories/becoming/results/data/shared-laws.json), '
        'generated by `tools/research/shared_laws.py`)')])
changed += ['FAILURE-MODE-MAP.md (the link)', '08-METHOD.md', 'GLOSSARY.md', 'Lean README.md', 'regions.json', 'arguments-a-l.json', 'COVERAGE.json',
            'THEOREM-CONNECTIVITY-APART.json']

# The workflow's section on the view: its prose, the generator's and the data's names, the keys.
p = T / '_process/RESULT-WORKFLOW.md'
text = p.read_text(encoding='utf-8')
new = sub_lines(text, CODE_MAP)
assert new != text
p.write_text(new, encoding='utf-8')
changed.append('RESULT-WORKFLOW.md')


def history_note(rid, en, zh):
    """Append one history note to a record, keeping the rest of its bytes."""
    p = T / f'theories/becoming/results/records/{rid}.json'
    text = p.read_text(encoding='utf-8')
    d = json.loads(text)
    start = text.index('\n  "history": [')
    end = text.index('\n  ]', start)
    entry = json.dumps({'en': en, 'zh': zh}, ensure_ascii=False, indent=2)
    entry = '\n'.join('    ' + line for line in entry.split('\n'))
    new = text[:end] + ',\n' + entry + text[end:]
    e = json.loads(new)
    assert e['history'][:-1] == d['history'], rid
    p.write_text(new, encoding='utf-8')


exact('theories/becoming/results/records/one-root-to-its-edge.json',
      [('hypotheses. master_laws.py checks the standings', 'hypotheses. shared_laws.py checks the standings'),
       ('与其自身之假设。master_laws.py 于核心运行上验诸所立', '与其自身之假设。shared_laws.py 于核心运行上验诸所立')])
history_note('one-root-to-its-edge',
             f'{args.day}, board item ND (study section {args.n}): the generator that checks the standings is named '
             'shared_laws.py (was master_laws.py), and its data shared-laws.json; the check and the claim are unchanged.',
             f'{args.day_zh}，工作板条目 ND（研究第 {args.n} 节）：验诸所立之生成程序名 shared_laws.py（原 master_laws.py），'
             '其数据名 shared-laws.json；所验与论断不变。')
history_note('shared-laws-on-the-grammar',
             f'{args.day}, board item ND (study section {args.n}): the id is shared-laws-on-the-grammar (was '
             'master-laws-on-the-grammar, kept in former_ids), following the title of ND part 1; the claim is unchanged.',
             f'{args.day_zh}，工作板条目 ND（研究第 {args.n} 节）：标识为 shared-laws-on-the-grammar（原 '
             'master-laws-on-the-grammar，存于 former_ids），从 ND 第一部分之题；论断不变。')
changed += ['one-root-to-its-edge (validation scope, note)', 'shared-laws-on-the-grammar (note)']
print('\n'.join(changed))
