#!/usr/bin/env python3
"""AP2: extend the records reading-anothers-couplings-is-pooling (reading another's law) and
widening-as-what-every-weighting-ranks (lexical priority within the class), and bind their proofs to the landing
receipt: python3 -B make_record.py CORE_RECEIPT STUDY_SECTION   (from the checkout root, after apply_text.py)

Every declaration cited is resolved against the receipt's audited declarations, and the receipt must bind each cited
module's current bytes."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f"## {N}. Reading another's law, and lexical priority within the class (AP2)"
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


def decls(mod):
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src(mod)), ('receipt does not bind', mod)
    assert not any(m['axiom_dependencies'].values())
    return [d['name'] for d in m['declarations']]


def resolve(mod, names):
    full = decls(mod)
    out = []
    for n in names:
        hits = [f for f in full if f == 'Becoming.' + n]
        assert len(hits) == 1, (mod, n, hits)
        out.append(hits[0])
    return out


def rebind(d, extended):
    """Set the extended module's declarations and every proof reference's hash, and point the receipt and every
    proof binding at the landing receipt."""
    for mod, names in extended.items():
        ref = next(r for r in d['references'] if r['path'] == src(mod))
        ref['declarations'] = sorted(set(ref['declarations']) | set(names))
    for r in d['references']:
        if r['role'] == 'proof':
            mod = r['path'].rsplit('/', 1)[-1][:-5]
            assert core['source_sha256'][f'Becoming.{mod}'] == sha(r['path']), mod
            r['sha256'] = sha(r['path'])
    receipts = [r for r in d['references'] if r['role'] == 'receipt']
    assert len(receipts) == 1, receipts
    receipts[0]['path'], receipts[0]['sha256'] = RECEIPT, sha(RECEIPT)
    for b in d['proof_bindings']:
        b['receipt'] = RECEIPT


# Reading another's law.
RID = 'reading-anothers-couplings-is-pooling'
p = RECORDS / f'{RID}.json'
d = json.loads(p.read_text())
LAW = resolve('SelectionPool', ['Web.anticipates_iff', 'Web.anticipation_misses', 'Web.SelectsThrough.read',
                                'ExchangeLaw.Through.anticipated'])
at = next(i for i, l in enumerate(d['laws']) if l['en'].startswith('Beyond that union'))
d['laws'].insert(at + 1, {
    'en': 'Knowing another\'s law is no coupling: every selection through another\'s couplings is one through a '
          'formation\'s own exactly when whatever it couples alike the other does, and otherwise some is not; then, under '
          'a law reading through the other\'s coupling, the other\'s acts are fixed by what the formation couples into. '
          'Reading the other\'s couplings is that fine.',
    'zh': '知道他者的律不是耦合：经他者耦合的每个选择都经一形成自身的耦合，恰当凡它耦合相同者他者都耦合相同，否则有一个不是；此时在经他者耦合读取的律下，他者的动作由该形成所耦合入者决定。读取他者的耦合即这样细。',
    'declarations': LAW})
dn = d['does_not_show'][0]
assert dn['en'].startswith('Reading another\'s law, how it would exchange under histories not taken, is not stated'), dn
dn['en'] = ('What another\'s law does under histories not taken: no run fixes it, so what a reader takes it to be there '
            'is a model.')
dn['zh'] = '他者的律在未取的历史下做什么：没有哪一次运行确定它，故读取者在那里对它的理解是一个模型。'
nd = d['next_delta']
assert nd['en'].startswith('Reading another\'s law (how it would exchange under histories not taken); '), nd
nd['en'] = nd['en'].replace('Reading another\'s law (how it would exchange under histories not taken); ',
                            'The converse for acts under laws of natural-number exchanges, where the reader is coarser '
                            '(it needs the class decided); ')
nd['zh'] = nd['zh'].replace('读取他者的律（它在未取的历史下会如何交换）；', '读取者较粗时、自然数交换之律下动作的逆命题（需该类可判定）；')
rebind(d, {'SelectionPool': LAW})
d['history'].append({
    'en': f'21 October 2026, AP2: reading another\'s law, anticipation exactly where the reader couples as finely, never '
          f'reach (study section {N}); a law, the first does-not-show item and the next delta revised to match; the '
          'earlier laws and the statement are unchanged.',
    'zh': f'2026年10月21日，AP2：读取他者的律，只在读取者耦合得同样细之处预见，从不加上所及（研究第 {N} 节）；新增一条定律，第一个“未表明”项与下一步随之修订；先前诸律与陈述不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('extended', RID)

# Lexical priority within the class.
WID = 'widening-as-what-every-weighting-ranks'
p = RECORDS / f'{WID}.json'
d = json.loads(p.read_text())
LEX = resolve('Weightings', ['Weighting.restrict', 'Weighting.lexical', 'Weighting.increasing_lexical'])
HELP = resolve('Weightings', ['Weighting.and_parts', 'Weighting.and_of_parts', 'Weighting.includes_restrict',
                              'Weighting.gain_at'])
at = next(i for i, l in enumerate(d['laws']) if l['en'].startswith('Additivity is not needed'))
d['laws'].insert(at + 1, {
    'en': 'Lexical priority, the basic items first (a course above another where it widens it on the basic items, or '
          'admits exactly its basic items and widens it on the others), ranks every widening higher, so it lies within '
          'the classes whose shared order is widening and decides only mixed comparisons.',
    'zh': '词典式优先，基本项在先（一条进程在基本项上扩大另一条，或恰好接纳其基本项而在其余项上扩大它，则排在其上），把每个扩大都排得更高，故在共有次序为扩大的诸类之内，只决定混合的比较。',
    'declarations': LEX})
rebind(d, {'Weightings': LEX + HELP})
d['history'].append({
    'en': f'21 October 2026, AP2: lexical priority within the classes whose shared order is widening (study section '
          f'{N}); one law added; the statement and the earlier laws are unchanged.',
    'zh': f'2026年10月21日，AP2：词典式优先在共有次序为扩大的诸类之内（研究第 {N} 节）；新增一条定律；陈述与先前诸律不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('extended', WID)
