#!/usr/bin/env python3
"""OU7's landing, part A: the corpus's conditional laws (Becoming.GrammarConditionals, a core leaf) with the two
general laws put below it in Grammar and GrammarReadings, the OU plan's line, 06's home section and record.

  python3 -B <dir>/integrate_ou7.py apply                  the Grammar, GrammarReadings and PLAN patches, then every
                                                           patch in patches/owner/ in name order (the grammar's
                                                           owner's held items); the leaf copied into the package; its
                                                           joins: the root module's import and note (after
                                                           GrammarLaws'), GrammarCandidates' note ("A leaf." becomes
                                                           "Imported by"), the checker's core list and scope sentence,
                                                           the README rows EN and ZH
  python3 -B <dir>/integrate_ou7.py audit                  the statements of Grammar and GrammarReadings against HEAD:
                                                           exactly the three new declarations added, none removed,
                                                           every other statement unchanged (comments blanked), the two
                                                           old laws proved as cases; the leaf's imports; the plan line
  python3 -B <dir>/integrate_ou7.py record RECEIPT STUDY   08 §3's receipt sentence, every count read from the receipt;
                                                           06's home section (home-06-section.txt, at the end of §四)
                                                           and its four lines (thesis, §三's 通, two open items);
                                                           regions.json's two entries; then the record
                                                           conditional-laws-of-the-corpus, bound to the receipt
  python3 -B <dir>/integrate_ou7.py register LOG           the apart register, from THEOREM-CONNECTIVITY.py --check's
                                                           log: the leaf's roots with their reasons (reasons() below);
                                                           register entries the leaf now uses dropped; others stop it
  python3 -B <dir>/integrate_ou7.py check                  after master_laws.py: the data is the landing run's, reads
                                                           the record's laws as they stand, and U4's boundary report
                                                           and the central figures are unchanged from the merged main
  python3 -B <dir>/integrate_ou7.py study N RECEIPT        the study's section N (the next free one), from the receipt

Run from the checkout root of the landing worktree, in the order land_ou7.sh gives. Each edit asserts that it applies
exactly once, or that it is already applied, so a stage can be rerun after main moves. Part B's pieces join when OU's
owner has decided them (README.md).
"""
import importlib.util
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('make_record_ou7', HERE / 'make_record_ou7.py')
mr = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mr)

PKG = ROOT / mr.PKG
LEAF = ROOT / mr.SOURCE
ROOTMOD = PKG / 'Becoming.lean'
CHECKER = PKG / 'check_becoming.py'
README_EN, README_ZH = PKG / 'README.md', PKG / 'README.zh.md'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
PLAN = ROOT / (RF + 'development/one-unfolding-root/PLAN.md')
HOME = ROOT / mr.CHAPTER
METHOD = ROOT / 'theories/becoming/chapters/08-METHOD.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
MASTER = 'theories/becoming/results/data/master-laws.json'
COVERAGE = ROOT / 'theories/becoming/results/completion/COVERAGE.json'
APART = ROOT / (RF + 'THEOREM-CONNECTIVITY-APART.json')
STUDY = ROOT / (RF + 'BECOMING-RENEWAL-READING.md')
PATCHES = [HERE / 'patches' / n for n in ('Grammar.patch', 'GrammarReadings.patch', 'PLAN.patch')]
OWNER = sorted((HERE / 'patches/owner').glob('*.patch')) if (HERE / 'patches/owner').is_dir() else []
DEVLINK = 'development/ou7-conditional-laws/'


def once(text, old, new, where):
    """Replace `old` by `new` exactly once, or confirm `new` is already in place (checked first, since `new` may
    contain `old`)."""
    if new in text:
        print(f'{where}: already in place')
        return text
    assert text.count(old) == 1, (where, 'expected once', text.count(old))
    print(f'{where}: applied')
    return text.replace(old, new)


# ---------------------------------------------------------------------------------------------------------- apply

ENTRY = """* `Becoming.GrammarConditionals` (L1): the corpus's conditional laws (丙一) in the grammar, each
  family written as "Y 当且仅当 Z" or "Z 则 Y" with a net where Z fails and Y fails with it (06 §四, board
  item OU7). Where everything goes on under a coarse class and every step is parted by a fine one, every
  occurrence is generating (`«皆有后而步皆分则全生成»`; day and night, `«昼夜全生成»`); a line none of
  whose places comes back to itself is shorter than any list holding its places (`«线不返则短于所列»`), so
  in bounded room it is not endless (`«不返而有限则非不穷»`); what a class's core puts with an occurrence
  whose line never ends has a line that never ends (`«核同则同不穷»`), as an ending is kept along the core
  (`«亡于核下不变»`) and a beginning along the converse net's (`«生于逆核下不变»`); a dependence (`«依»`) is
  one-way, and where nothing is depended on nothing depends (`«所依无则依者无»`, `«依之传»`). Three
  definitional laws state families exactly (`«亡者异当且仅当有后»`, `«无异当且仅当不分续»`,
  `«皆不生当且仅当皆非无缘»`), and 27 witnesses (`…之例`) give the nets the other modules do not. Which unit
  states which law is an AI reconstruction (the OU7 study's `data/groups.tsv`). A leaf.
"""
SCOPE = ('    "GrammarConditionals: the corpus\'s conditional laws in the grammar, each family with a net where its "\n'
         '    "condition fails and its conclusion with it; where everything goes on under a coarse class and every "\n'
         '    "step is parted by a fine one, every occurrence is generating; a line none of whose places comes back "\n'
         '    "to itself is shorter than any list holding them, so in bounded room it is not endless; what a class\'s "\n'
         '    "core puts with an occurrence whose line never ends has a line that never ends; where nothing is "\n'
         '    "depended on nothing depends, and dependences compose. "\n')
ROW_EN = ('| L1 | [`Becoming.GrammarConditionals`](Becoming/GrammarConditionals.lean) | the corpus\'s conditional laws '
          '(丙一) in the grammar, each family with a net where its condition fails (no premise): 相推 gives 全生成 '
          '(`«皆有后而步皆分则全生成»`); a line that does not come back is shorter than any list holding it, so in '
          'bounded room not endless (`«线不返则短于所列»`, `«不返而有限则非不穷»`); what the core puts with an endless '
          'line is endless (`«核同则同不穷»`); where nothing is depended on nothing depends (`«所依无则依者无»`); '
          '27 witnesses |\n')
ROW_ZH = ('| L1 | [`Becoming.GrammarConditionals`](Becoming/GrammarConditionals.lean) | 语料之丙一之律写入文法，每族有其'
          '条件不成立之网（无前提）：相推而全生成（`«皆有后而步皆分则全生成»`）；不返之线短于任一列其处之表，故有界之室'
          '中非不穷（`«线不返则短于所列»`、`«不返而有限则非不穷»`）；核所合于不穷之线者亦不穷（`«核同则同不穷»`）；'
          '所依无则依者无（`«所依无则依者无»`）；见证 27 |\n')


def git(*args, check=True):
    return subprocess.run(['git', *args], cwd=ROOT, capture_output=True, text=True, check=check)


def apply_patches():
    for p in PATCHES + OWNER:
        if git('apply', '--check', str(p), check=False).returncode == 0:
            git('apply', str(p))
            print(f'{p.name}: applied')
        elif git('apply', '--reverse', '--check', str(p), check=False).returncode == 0:
            print(f'{p.name}: already in place')
        else:
            sys.exit(f'{p.name} neither applies nor is in place: main moved under it; rebase the patch and rerun')


def join():
    kit = HERE / 'Becoming/GrammarConditionals.lean'
    if LEAF.exists():
        assert LEAF.read_bytes() == kit.read_bytes(), 'the package has a different GrammarConditionals.lean'
        print('leaf: already in place')
    else:
        shutil.copyfile(kit, LEAF)
        print('leaf: copied into the package')
    t = ROOTMOD.read_text(encoding='utf-8')
    t = once(t, 'import Becoming.GrammarLaws\n', 'import Becoming.GrammarLaws\nimport Becoming.GrammarConditionals\n',
             'root module, import')
    start = t.index('* `Becoming.GrammarLaws` (L0):')
    nxt = t.index('\n* `Becoming.', start) + 1
    if ENTRY not in t:
        assert '* `Becoming.GrammarConditionals`' not in t, 'a different note for the leaf is in place'
        t = t[:nxt] + ENTRY + t[nxt:]
        print('root module, note: applied after GrammarLaws\'')
    else:
        print('root module, note: already in place')
    cs = t.index('* `Becoming.GrammarCandidates` (L1):')
    ce = t.index('\n* `Becoming.', cs)
    note = t[cs:ce]
    if note.endswith(' A leaf.'):
        t = t[:cs] + note[:-len('A leaf.')] + 'Imported by `Becoming.GrammarConditionals`.' + t[ce:]
        print('root module, GrammarCandidates\' note: applied')
    else:
        assert note.rstrip().endswith('Imported by `Becoming.GrammarConditionals`.'), note[-120:]
        print('root module, GrammarCandidates\' note: already in place')
    ROOTMOD.write_text(t, encoding='utf-8')
    c = CHECKER.read_text(encoding='utf-8')
    c = once(c, '"Becoming.GrammarLaws", ', '"Becoming.GrammarLaws", "Becoming.GrammarConditionals", ',
             'checker, core list')
    anchor = '    "GrammarTesting: the core of a class lies in every stage of its approximation, so what a finite "\n'
    c = once(c, anchor, SCOPE + anchor, 'checker, scope sentence')
    CHECKER.write_text(c, encoding='utf-8')
    for path, row in [(README_EN, ROW_EN), (README_ZH, ROW_ZH)]:
        r = path.read_text(encoding='utf-8')
        if row in r:
            print(path.name, 'row: already in place')
            continue
        assert '[`Becoming.GrammarConditionals`]' not in r, (path.name, 'a different row for the leaf is in place')
        m = re.search(r'^\| L0 \| \[`Becoming\.GrammarLaws`\][^\n]*\n', r, re.M)
        assert m and len(re.findall(r'^\| L0 \| \[`Becoming\.GrammarLaws`\]', r, re.M)) == 1, path.name
        path.write_text(r[:m.end()] + row + r[m.end():], encoding='utf-8')
        print(path.name, 'row: applied after GrammarLaws\'')


def apply():
    apply_patches()
    join()


# ---------------------------------------------------------------------------------------------------------- audit

def statements(text):
    """Each declaration's statement (its header up to the first `:=`, or the whole command for one without),
    whitespace collapsed, from the code with comments blanked; and each declaration's whole text."""
    code = mr.code(text)
    heads = list(re.finditer(r'^(?:theorem|def|structure|inductive|abbrev|instance) (\S+)', code, re.M))
    out, whole = {}, {}
    for i, m in enumerate(heads):
        end = heads[i + 1].start() if i + 1 < len(heads) else len(code)
        body = code[m.start():end]
        body = re.split(r'^(?:end |section|namespace|/-!|variable)', body, maxsplit=1, flags=re.M)[0]
        out['Becoming.' + m.group(1)] = ' '.join(body.split(':=', 1)[0].split())
        whole['Becoming.' + m.group(1)] = ' '.join(body.split())
    return out, whole


EXPECTED = {'Becoming.Grammar': ({'Becoming.«位核含于逆核»', 'Becoming.«生于逆核下不变»'},
                                 {'Becoming.«生于位核下不变»': '«生于逆核下不变» hE («位核含于逆核» R E y y\' hk) hy'}),
            'Becoming.GrammarReadings': ({'Becoming.«两向有常有前则通»'},
                                         {'Becoming.«两向有常则通»': '«两向有常有前则通» hE hc hc\' hx.1'})}


def audit():
    problems = []
    for module, (added, cases) in EXPECTED.items():
        path = mr.BELOW[module]
        before, _ = statements(git('show', 'HEAD:' + path).stdout)
        after, whole = statements((ROOT / path).read_text(encoding='utf-8'))
        if set(after) - set(before) != added:
            problems.append((module, 'added', sorted(set(after) - set(before))))
        if set(before) - set(after):
            problems.append((module, 'removed', sorted(set(before) - set(after))))
        changed = [n for n in before if n in after and before[n] != after[n]]
        if changed:
            problems.append((module, 'statements changed', changed))
        for name, proof in cases.items():
            if ' '.join(proof.split()) not in whole.get(name, ''):
                problems.append((module, 'not proved as a case', name))
        print(module, len(before), '->', len(after), 'declarations; added', sorted(set(after) - set(before)))
    imports = re.findall(r'^import (\S+)', LEAF.read_text(encoding='utf-8'), re.M)
    if imports != ['Becoming.GrammarCandidates', 'Becoming.GrammarLaws']:
        problems.append(('the leaf imports', imports))
    plan = PLAN.read_text(encoding='utf-8')
    if '生只在双向之核下不变' in plan or '生在逆缘之核下不变（`«生于逆核下不变»`）' not in plan:
        problems.append(('the OU plan line',))
    for p in problems:
        print('PROBLEM', p)
    assert not problems
    print('audit: the patches add only their three laws, keep every other statement, and the two old laws are their '
          'cases; the leaf imports GrammarCandidates and GrammarLaws; the plan line is replaced')


# ---------------------------------------------------------------------------------------------------------- record

# 08 §3's sentence naming the core receipt and its counts (U1b's integrate_u1b.py, the same pattern).
SENTENCE = re.compile(
    r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
    r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
    r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
    r"modules were kept out of the run\.")


def receipt_sentence(receipt):
    r = json.loads((ROOT / receipt).read_text(encoding='utf-8'))
    assert r['status'] == 'passed'
    mr.receipt_modules(receipt)
    stamp = Path(receipt).parent.name
    layers = {}
    for m in r['modules']:
        count = layers.setdefault(m['layer'], [0, 0])
        count[0] += 1
        count[1] += m['theorems']
    assert set(layers) <= {'foundation', 'core', 'instance', 'application'}, set(layers)
    modules = sum(v[0] for v in layers.values())
    theorems = sum(v[1] for v in layers.values())
    assert modules == len(r['core_closure']), (modules, len(r['core_closure']))
    ring = layers.get('instance', [0, 0])[0] + layers.get('application', [0, 0])[0]
    declarations = sum(len(m['declarations']) for m in r['modules'])
    injeq = sum(1 for name, axioms in r['generated_axiom_dependencies'].items()
                if name.endswith('.injEq') and axioms == ['propext'])
    assert injeq == len(r['generated_axiom_dependencies']), 'a generated dependency other than injEq on propext'
    link = '../../../' + receipt
    counts = (f"At core receipt [`{stamp}`]({link}) (Lean 4.29.1), the closure held {modules} modules "
              f"({layers['foundation'][0]} foundation, {layers['core'][0]} core, {ring} in the instance and application "
              f"ring) and {theorems:,} theorems; the {layers['core'][0]} core modules held {layers['core'][1]:,} of them; "
              f"{declarations:,} declarations were audited; {injeq} generated `injEq` lemmas depend on `propext`; "
              f"{len(r['superseded_modules'])} superseded modules were kept out of the run.")
    text = METHOD.read_text(encoding='utf-8')
    text, k = SENTENCE.subn(lambda m: counts, text)
    assert k == 1, k
    METHOD.write_text(text, encoding='utf-8')
    print('08 §3:', counts[:160], '…')


SECTION = (HERE / 'home-06-section.txt').read_text(encoding='utf-8')
OLD_SENTENCE = '八部文本之 162 条丙一之律尚未逐条写成“Y 当且仅当 Z”；后加三部文本的 181 条乙类候选尚未检验（[未决](#open)）。\n'
NEW_SENTENCE = '后加三部文本的 181 条乙类候选尚未检验（[未决](#open)）。\n'
LINK = '[§四](#r-conditional-laws-of-the-corpus)'
LINES = [
    ('thesis, §四',
     '另三条归错或表达不了（§四）；',
     '另三条归错或表达不了；219 条丙一之律逐族写成，各有其条件不成立之网，6 条依其读法不成立（§四）；'),
    ('thesis, open',
     '162 条丙一之律与另 181 条候选',
     '另 181 条乙类候选与“穷 → 变 → 通”所言何变'),
    ('§三, 通 and 息',
     '仍未证者：“穷 → 变 → 通”之序在何处成立（[未决](#open)）。',
     f'“穷 → 变 → 通”之读见 {LINK}：读變为一次之异，三者是合取，无序可求；读變为「一闔一闢」，通之一步依定义；'
     '文本所言是哪一种變，仍未决（[未决](#open)）。'),
    ('open, 丙一',
     '- **丙一与新候选。** 八部文本之 162 条丙一之律尚未逐条写成“Y 当且仅当 Z”；后加三部文本的 181 条乙类候选尚未检验。',
     f'- **新候选与丙一之读。** 后加三部文本的 181 条乙类候选尚未检验。丙一 219 条之读（{LINK}）无人审过，其中三处仍是疑问 '
     '[AI reading]：「衡不正」是反转其衡，还是只不保其序（G22；若只不保其序，「重縣於仰」不随之）；《起信论》之相應是否读作'
     '同在核之一类（G15，JS-326；须遍检其书相應之用，JS-318 在内）；無明是否在其煩惱染法之中（G15，JS-318；若在，JS-318 '
     '否定 JS-326 之读所用之前提）。'),
    ('open, 穷 → 变 → 通',
     '- **穷 → 变 → 通。** `«通»` 已依往来定义，`«息»` 已正面定义；“穷 → 变 → 通”之序在其下何处成立，尚未证明'
     '（[§三](#tong-and-xi)）。',
     '- **穷 → 变 → 通。** 文本所言是哪一种變 [AI reading]：读作一次之异，三者是合取，无序可求；读作「一闔一闢」，通之一步'
     f'依定义（{LINK}，[§三](#tong-and-xi)）。'),
]


def home():
    text = HOME.read_text(encoding='utf-8')
    if mr.ANCHOR in text:
        assert SECTION in text, 'a different home section is in place: remove it and rerun'
        print('06 §四: the home section is already in place')
    else:
        assert text.count(OLD_SENTENCE) == 1, '06 §四 no longer ends with the sentence on the 丙一 laws: place by hand'
        start, end = text.index('<a id="grammar-theorems"></a>'), text.index('<a id="the-changes"></a>')
        assert start < text.index(OLD_SENTENCE) < end, 'the sentence is no longer in §四'
        text = text.replace(OLD_SENTENCE, SECTION + '\n' + NEW_SENTENCE)
        print('06 §四: the home section in place of the sentence on the 丙一 laws')
    for where, old, new in LINES:
        text = once(text, old, new, '06, ' + where)
    HOME.write_text(text, encoding='utf-8')


def regions():
    data = json.loads(REGIONS.read_text(encoding='utf-8'))
    # Region: the chapter of the home section (06, the classical texts). Base: the grammar, as for the corpus's
    # candidate theorems and definitions.
    data['records'][mr.RID] = {
        'region': 'classical', 'base': 'grammar',
        'note': 'GrammarConditionals OU7: 219 丙一 units, 128 in 22 families, each law with a net where its condition '
                'fails; 6 false as read, 19 premises; new laws G02, G03, G15 and 依'}
    data['modules'][mr.MODULE] = {
        'region': 'classical', 'base': 'grammar',
        'note': 'the corpus\'s conditional laws (丙一): 相推 gives 全生成, bounded room on a line, the core keeps never '
                'ending, dependence; 27 witnesses (OU7)'}
    for key in ('records', 'modules'):
        data[key] = dict(sorted(data[key].items()))
    REGIONS.write_text(json.dumps(data, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    print('regions: the record and the module, region classical, base grammar')


def record(receipt, study):
    receipt_sentence(receipt)
    home()
    regions()
    r = mr.record(receipt, study)
    (ROOT / mr.REC).write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('record', mr.REC, 'bound to', receipt)


# ---------------------------------------------------------------------------------------------------------- register

def reasons():
    """The category and reason of each theorem of the leaf, should the connectivity tool list it as an apart root
    (used by no other apart theorem): the witnesses and the day-and-night instance are facts about one constructed
    model; counting_reach_lt and the line-matching law support others; every other law is a law of every relation on
    any carrier, its unit's reading in the OU7 study. The patches' three laws are listed too, in case one stands
    apart: on the expected reading each is used by the old law that is its case."""
    out = {}
    for name in mr.LEAF:
        short = name[len('Becoming.'):]
        if short == '«依»':
            continue
        if short.endswith('之例»') or short == '«昼夜全生成»':
            out[name] = ('model-witness', f'{short}: a fact about one constructed model, a net where a conditional law '
                                          'of the corpus has its condition fail (06 §四, the record '
                                          'conditional-laws-of-the-corpus)')
        elif short in ('counting_reach_lt', '«类内有常则线相随»'):
            out[name] = ('support', f'{short}: a lemma of a law of the same leaf (G03\'s witnesses, G15\'s '
                                    '«核同则同不穷»)')
        else:
            out[name] = ('general-structure', f'{short}: a conditional law of the corpus (its family in the OU7 '
                                              'study\'s groups.tsv) proved for every relation on any carrier; the base '
                                              'supplies no reading of its terms')
    for name in sorted(mr.PATCHED):
        out[name] = ('general-structure', f'{name[len("Becoming."):]}: a law of every relation on any carrier, the '
                                          'general form of an older law of the grammar that is now its case (OU7)')
    return out


def used_by_ou7(names):
    """Of `names`, those the leaf's code or the patches' added code names: once these use a register root it is no
    longer an apart root. Read from the code, not the register, so a rerun after the entries went still knows them."""
    added = '\n'.join(l[1:] for p in PATCHES[:2] for l in p.read_text(encoding='utf-8').splitlines()
                      if l.startswith('+') and not l.startswith('+++'))
    code = mr.code(LEAF.read_text(encoding='utf-8')) + '\n' + mr.code(added)
    return {n for n in names if n.startswith('Becoming.') and n not in mr.LEAF
            and re.search(re.escape(n[len('Becoming.'):]) + r'(?![^\s()\]⟩,])', code)}


def leaf_uses():
    """The register roots OU7's code names (the entries the register step expects to drop)."""
    return used_by_ou7(json.loads(APART.read_text(encoding='utf-8'))['roots'])


def register(log_path):
    t = APART.read_text(encoding='utf-8')
    log = Path(log_path).read_text(encoding='utf-8')
    m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
    listed = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
    known = reasons()
    block, others, unknown = '', [], []
    for name in listed:
        if name not in mr.LEAF and name not in mr.PATCHED:
            others.append(name)
            continue
        if name not in known:
            unknown.append(name)
            continue
        if json.dumps(name, ensure_ascii=False) in t:
            continue
        cat, why = known[name]
        module = mr.MODULE if name in mr.LEAF else next(k for k in mr.BELOW if name in mr.BELOW_NAMES[k])
        block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "' + module + '",\n'
                  '   "category": "' + cat + '",\n   "reason": ' + json.dumps(why, ensure_ascii=False) + '\n  },\n')
    assert not unknown, ('roots with no reason: add each to reasons(), read from its statement', unknown)
    if block:
        anchor = '  }\n },\n "instances": {'
        assert t.count(anchor) == 1
        t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
        json.loads(t)
        APART.write_text(t, encoding='utf-8')
    # A register root the leaf or the patches now use is no longer an apart root: its entry goes. Only the roots
    # their code names may go this way; any other stops for its owner's reading.
    m = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
    gone = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
    used = used_by_ou7(gone)
    unexpected = [g for g in gone if g not in used]
    assert not unexpected, ('register entries no longer apart roots that OU7 does not use', unexpected)
    t = APART.read_text(encoding='utf-8')
    d = json.loads(t)
    dropped = [g for g in gone if g in d['roots']]
    for g in dropped:
        start = t.index('  ' + json.dumps(g, ensure_ascii=False) + ': {\n')
        end = t.index('\n  },\n', start) + len('\n  },\n')
        t = t[:start] + t[end:]
    if dropped:
        after = json.loads(t)
        assert all(g not in after['roots'] for g in dropped) and len(after['roots']) == len(d['roots']) - len(dropped)
        APART.write_text(t, encoding='utf-8')
    print('dropped', len(dropped), 'register entries the leaf now uses:', ', '.join(dropped) or 'none')
    print('registered', block.count('"module"'), 'roots of the leaf and the patches')
    if others:
        print("roots not OU7's, for their owners:", ', '.join(others))


# ---------------------------------------------------------------------------------------------------------- check

def head_master():
    """master-laws.json as the merged main has it (the landing worktree's HEAD, before the landing commit)."""
    return json.loads(git('show', 'HEAD:' + MASTER).stdout)


def check():
    data = json.loads((ROOT / MASTER).read_text(encoding='utf-8'))
    before = head_master()
    problems = []
    verification = json.loads((PKG / 'becoming-verification.json').read_text(encoding='utf-8'))
    if data.get('from_dump') or data.get('core_receipt') != verification.get('utc'):
        problems.append(('the data is not the landing run\'s', data.get('core_receipt'), verification.get('utc')))
    rec = json.loads((ROOT / mr.REC).read_text(encoding='utf-8'))
    laws = data.get('records', {}).get(mr.RID)
    if not laws:
        problems.append(('the data has no entry for the record', mr.RID))
    else:
        mine = [law['declarations'] for law in rec['laws']]
        theirs = [law.get('declarations') for law in laws]
        if mine != theirs:
            problems.append(('the data does not match the record\'s laws', len(mine), len(theirs)))
        for i, law in enumerate(laws, 1):
            print(f"law {i}: master laws {law.get('master_laws')}, grammar {law.get('grammar')}, "
                  f"dependence {law.get('dependence')}")
    # No central declaration is the leaf's or one the patches add, so U4's boundary record needs no new entry.
    central = {d for row in json.loads(COVERAGE.read_text(encoding='utf-8'))['rows'] for d in row.get('declarations', [])}
    if central & (set(mr.LEAF) | mr.PATCHED):
        problems.append(('a declaration of OU7 is central: U4\'s boundary record must place it',
                         central & (set(mr.LEAF) | mr.PATCHED)))
    b = data.get('boundary') or {}
    if b.get('record') != 'one-root-to-its-edge' or b.get('field_failures') or b.get('unverified'):
        problems.append(('the boundary report', b.get('record'), b.get('field_failures'), b.get('unverified')))
    unplaced = [d for d, row in (b.get('rows') or {}).items() if row.get('label') == 'unplaced']
    if unplaced:
        problems.append(('unplaced', unplaced))
    if not b.get('lean_check', {}).get('ran'):
        problems.append(('the Lean check did not run', b.get('lean_check')))
    for key, now, then in [('boundary counts', b.get('counts'), (before.get('boundary') or {}).get('counts')),
                           ('central reach', (data.get('central_reach') or {}).get('counts'),
                            (before.get('central_reach') or {}).get('counts')),
                           ('counts at a model', data.get('counts_at_model'), before.get('counts_at_model')),
                           ('counts at the boundary record', data.get('counts_at_boundary_record'),
                            before.get('counts_at_boundary_record'))]:
        if now != then:
            problems.append((key + ' changed', then, now))
    grown = {k: (before['counts'].get(k), v) for k, v in data['counts'].items() if before['counts'].get(k) != v}
    print('record-law counts, main -> landing (only the new record\'s laws should add):', grown)
    if data['counts']['laws'] != before['counts']['laws'] + len(rec['laws']):
        problems.append(('law count', before['counts']['laws'], data['counts']['laws']))
    for p in problems:
        print('PROBLEM', p)
    assert not problems
    print('master laws read the record; the boundary report and the central figures are as on main:',
          b.get('counts'), (data.get('central_reach') or {}).get('counts'))


# ---------------------------------------------------------------------------------------------------------- study

def study(n, receipt):
    """The study's section N (the next free one), from the landing's receipt. Part B's text, once OU's owner has
    decided its pieces, is kit/study-part-b.txt and follows part A's block."""
    text = STUDY.read_text(encoding='utf-8')
    title = '## {}. The corpus\'s conditional laws, family by family (OU7)'
    if title.format(n) in text:
        print('study §', n, 'already in place')
        return
    free = max(int(x) for x in re.findall(r'^## (\d+)\. ', text, re.M)) + 1
    assert int(n) == free, ('the next free section is', free)
    m = mr.receipt_modules(receipt)
    leaf = m[mr.MODULE]
    stamp = Path(receipt).parent.name
    below = ', '.join(f"{k.split('.')[-1]} {len(m[k]['declarations'])} declarations" for k in mr.BELOW)
    part_b = HERE / 'study-part-b.txt'
    section = f"""{title.format(n)}

Board item OU7 (claimed as OU5), the OU plan's §八 step 5 and the release gate's item 4: each conditional law of the corpus (丙一) written in the grammar as "Y 当且仅当 Z" or "Z 则 Y", with a net where Z fails and Y fails with it ([the design]({DEVLINK}DESIGN.md)). Part A reads the 219 units; one independent AI review of its design found 24 problems, every one taken ([the review]({DEVLINK}review/FINDINGS.md)); OU's owner decided what lands and confirmed every name.

```text
Result(s): conditional-laws-of-the-corpus (new, home 06 §四 at its end). Reused: candidate-theorems-of-the-corpus,
       classical-definitions-in-the-grammar, continuation-relative-to-a-class, master-laws-on-the-grammar,
       generation-and-degeneration-at-two-grains, testing-within-the-net.
Delta:
  - The 219 units classed 丙一 (162 of the first batch, 25 of 中论 chapters 10, 17, 19 and 24, 32 of 成唯识论):
    128 in 22 families (103 state a law that holds, 6 one false as read with its countermodel, 19 a premise);
    33 back to 丁, 53 not expressible with their reasons, 5 definitions. Each reading AI-labelled in groups.tsv.
  - New laws: 相推 gives 全生成 (G02, sufficient); bounded room on the line itself (G03: a line that does not come
    back is shorter than any list holding it, so not endless); the core keeps never ending (G15, «核同则同不穷»);
    dependence, one-way, with its two definitional laws (G09).
  - Below the leaf, by patch: «生于逆核下不变» and «位核含于逆核» in Grammar, «生于位核下不变» its case;
    «两向有常有前则通» in GrammarReadings, «两向有常则通» its case; every old statement kept. 前際 and 後際 mirror
    each other under the converse; constancy is sufficient for 通, not necessary.
  - 穷 → 变 → 通 is a conjunction where 變 is one alteration, not an order; G01's conjunction is text in 06, and
    06's open item is restated as which 變 the text means.
  - 27 witnesses, so that every family's net where Z fails is in the core; the 17 compositions the home section
    states as text stay in scratch.
Supplied premises / correspondence: the readings (AI reconstructions); G03's and G04's bound; G08 and G20 premises
       of the model; G13's not its own condition; G21's converse under its premise. Modelling choices: one carrier,
       缘 a necessary relation with no predicate of presence, discrete steps.
Evidence: core receipt `{stamp}`; Becoming.GrammarConditionals ({leaf['theorems']} theorems in
       {len(leaf['declarations'])} declarations), a core leaf importing GrammarCandidates and GrammarLaws, nothing
       importing it; {below}; every axiom report empty. The patches' audit: only their three laws added, every other
       statement unchanged.
Standing: three families new (G02, G03, G15), dependence definitional; the rest are existing laws given exact form
       and nets. None of it says what a text means.
Boundary:
  - That the texts state these laws; no person has reviewed the readings.
  - An order 穷 → 变 → 通; production and sufficiency (not expressible); constancy as necessary.
  - The three open readings (G22's 衡不正, JS-326's 相應, JS-318's 無明), each with its AI label in 06's open items.
  - The 181 乙 candidates of the three added texts.
Output -> input: 06 §四's home section, its thesis, §三's 通 and two open items; the OU plan's line on beginning;
       the record's next step (review by a person; the open readings).
```
"""
    if part_b.is_file():
        section += '\n' + part_b.read_text(encoding='utf-8').rstrip('\n') + '\n'
    STUDY.write_text(text.rstrip('\n') + '\n\n' + section, encoding='utf-8')
    print('study §', n, 'written')


if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    if sys.argv[1] == 'apply':
        apply()
    elif sys.argv[1] == 'audit':
        audit()
    elif sys.argv[1] == 'record':
        record(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == 'register':
        register(sys.argv[2])
    elif sys.argv[1] == 'check':
        check()
    elif sys.argv[1] == 'study':
        study(sys.argv[2], sys.argv[3])
    else:
        sys.exit(__doc__)
