#!/usr/bin/env python3
"""OU3e record: extend master-laws-on-the-grammar. The last group gains the models' step-indexed laws and their bridges
(Withholding's closed forms and WithinMoves.after_course, with the chain and trace bridges); proof references and
bindings for Withholding and Labelled; the design and the review; the receipt; the does-not-show item on the
step-indexed bridges goes, since the record now shows them; the validation scope; a history note. The re-pointing that
follows (repoint --drift-json with --receipt and --lean) rebinds the existing references.
usage (from the checkout root, after texts_ou3e.py): python3 -B make_records_ou3e.py RECEIPT N"""
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT_ID, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3e-step-indexed-bridges'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
P = ROOT / 'theories/becoming/results/records/master-laws-on-the-grammar.json'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
gl = next(x for x in core['modules'] if x['module'] == 'Becoming.GrammarLaws')
NEW = {'Withholding': ['Becoming.Withholding.answers_closed', 'Becoming.Withholding.chain_iff_steps',
                       'Becoming.Withholding.waitsAll_closed', 'Becoming.Withholding.within_iff_withinSteps'],
       'Labelled': ['Becoming.WithinMoves.after_course', 'Becoming.trace_iff_steps', 'Becoming.trace_steps',
                    'Becoming.withinMoves_iff_withinSteps']}
for m, ds in NEW.items():
    mod = next(x for x in core['modules'] if x['module'] == f'Becoming.{m}')
    assert not any(mod['axiom_dependencies'].values()), m
    assert core['source_sha256'][f'Becoming.{m}'] == sha(f'{PKG}/Becoming/{m}.lean'), m
    assert set(ds) <= {d['name'] for d in mod['declarations']}, (m, set(ds) - {d['name'] for d in mod['declarations']})

r = json.loads(P.read_text(encoding='utf-8'))
last = r['laws'][17]
assert last['en'].startswith("The models' laws of closure, return"), last['en'][:40]
last['en'] = last['en'].rstrip() + (' And the models\' step-indexed laws: giving that waits on giving, with memory and '
                                    'without, from the laws of taking on, a chain of waits read as the grammar\'s steps; '
                                    'and a course carrying every bound on realizing a bundle together, from the '
                                    'composition of within, a trace read as the grammar\'s steps.')
last['zh'] = last['zh'].rstrip() + ('又诸模型计步之律：待施之施，有记忆与无记忆，出自承之律，待之链读为文法之步；'
                                    '进程携同时实现一束之每一界，出自以内之接，迹读为文法之步。')
last['declarations'] = sorted(set(last['declarations']) | {d for ds in NEW.values() for d in ds})

refs = r['references']
at = max(i for i, x in enumerate(refs) if x['role'] == 'proof') + 1
for m, ds in NEW.items():
    path = f'{PKG}/Becoming/{m}.lean'
    assert not any(x['path'] == path for x in refs), path
    refs.insert(at, {'path': path, 'role': 'proof', 'declarations': ds, 'sha256': sha(path)})
    at += 1
    r['proof_bindings'].append({'source': path, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{m}',
                                'success_pointer': '/status', 'success_value': 'passed'})
refs.append({'path': f'{DEV}/DESIGN.md', 'role': 'integration', 'sha256': sha(f'{DEV}/DESIGN.md')})
refs.append({'path': f'{DEV}/REVIEW-OU3e.md', 'role': 'review', 'sha256': sha(f'{DEV}/REVIEW-OU3e.md')})
refs.append({'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)})

gone = [d for d in r['does_not_show'] if d['en'].startswith("That the models' step-indexed laws are proved from the laws of steps counted")]
assert len(gone) == 1, len(gone)
r['does_not_show'].remove(gone[0])

vs = r['validation_scope']
a = "and OU3c's derivations in four more, every axiom report empty, all cited;"
assert vs['en'].count(a) == 1, vs['en'][:300]
vs['en'] = vs['en'].replace(a, "and the derivations of OU3c in four more and of OU3e in two, every axiom report empty, all cited;")
b = "and one of OU3d with a second pass; not reviewed by a person."
assert vs['en'].count(b) == 1
vs['en'] = vs['en'].replace(b, "one of OU3d with a second pass, and one of OU3e; not reviewed by a person.")
z1 = "及另四模块中 OU3c 之推导"
assert vs['zh'].count(z1) == 1, vs['zh'][:200]
vs['zh'] = vs['zh'].replace(z1, "及另四模块中 OU3c 之推导、另二模块中 OU3e 之推导")
z2 = "OU3d 一次并复审一遍；未经人审。"
assert vs['zh'].count(z2) == 1
vs['zh'] = vs['zh'].replace(z2, "OU3d 一次并复审一遍，OU3e 一次；未经人审。")
assert len(vs['en']) <= 600, len(vs['en'])
r['history'].append({
    'en': f"28 October 2026 (OU3e, study section {N}): the models' step-indexed laws proved from the laws of steps "
          f"counted: Withholding's two closed forms from the laws of taking on, a chain of waits read as the grammar's "
          f"steps, and WithinMoves.after_course from the composition of within, a trace read as them; the does-not-show "
          f"item on their bridges removed.",
    'zh': f"2026年10月28日（OU3e，研究第 {N} 节）：诸模型计步之律由计步之律证出：Withholding 之二闭式出自承之律，待之链读为文法之步；"
          f"WithinMoves.after_course 出自以内之接，迹读为文法之步；其桥接之「未示」一条删去。"})
P.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record extended:', len(last['declarations']), 'in the last group; validation scope', len(vs['en']), 'chars')
