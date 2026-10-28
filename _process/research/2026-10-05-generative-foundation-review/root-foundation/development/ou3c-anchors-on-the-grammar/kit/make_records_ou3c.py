#!/usr/bin/env python3
"""OU3c record: extend master-laws-on-the-grammar. The order group gains the two relation laws now in GrammarLaws; the
last group gains OU3c's derivations (structure and change one lumping, the step back of a returning configuration, the
lagged orders); proof references and bindings for LearningRuns, Junctures and ReachableRanges; the audit and review as
integration and review references; one does-not-show item; the validation scope's counts from the receipt; a history
note. The re-pointing that follows (repoint --drift-json with --receipt and --lean) rebinds the existing references.
usage (from the checkout root, after texts_ou3c.py): python3 -B make_records_ou3c.py RECEIPT N"""
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT_ID, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3c-anchors-on-the-grammar'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
P = ROOT / 'theories/becoming/results/records/master-laws-on-the-grammar.json'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
names = {m['module']: {d['name'] for d in m['declarations']} for m in core['modules']}
for m in ('Becoming.GrammarLaws', 'Becoming.LearningRuns', 'Becoming.Junctures', 'Becoming.ReachableRanges'):
    mod = next(x for x in core['modules'] if x['module'] == m)
    assert not any(mod['axiom_dependencies'].values()), m
    path = f'{PKG}/Becoming/{m.split(".")[1]}.lean'
    assert core['source_sha256'][m] == sha(path), m
GL = ['Becoming.strictJoin_trans', 'Becoming.strictJoin_irrefl']
NEW = {'LearningRuns': ['Becoming.Learning.fixed_image_iff_lumped', 'Becoming.Learning.goAlike_iff_lumped'],
       'Junctures': ['Becoming.Branching.step_back'],
       'ReachableRanges': ['Becoming.Reaching.WidensOrLater.irrefl', 'Becoming.Reaching.WidensOrLater.trans']}
assert set(GL) <= names['Becoming.GrammarLaws'], set(GL) - names['Becoming.GrammarLaws']
for m, ds in NEW.items():
    assert set(ds) <= names[f'Becoming.{m}'], (m, set(ds) - names[f'Becoming.{m}'])

r = json.loads(P.read_text(encoding='utf-8'))
order = r['laws'][14]
assert order['en'].startswith('Order. Widening of relations'), order['en'][:40]
order['en'] = order['en'].rstrip() + (' For any two relations, a transitive relation joined to the strict part of a '
                                      'transitive relation containing it is transitive, and irreflexive where the first is.')
order['zh'] = order['zh'].rstrip() + '任两关系：传递关系并入含之之传递关系之严格部分，仍传递；前者非自反处亦非自反。'
order['declarations'] = sorted(set(order['declarations']) | set(GL))
last = r['laws'][16]
assert last['en'].startswith("The models' laws of closure, return"), last['en'][:40]
last['en'] = last['en'].rstrip() + (' Among them: structure and change are one lumping, the image law on a determined '
                                    "law's one move; the step back of a returning configuration, the grammar's "
                                    'decomposition of reach, by which every loss passes a juncture; and the lagged orders '
                                    'of courses and of what can be reached, from the relation laws.')
last['zh'] = last['zh'].rstrip() + ('其中：结构与变化同为一种归并，即像之律施于定律之一步；返者之退一步，即文法对所及之分解，由之每一失皆经一岔口；'
                                    '进程与所可及者之滞后之序，出自关系之律。')
last['declarations'] = sorted(set(last['declarations']) | {d for ds in NEW.values() for d in ds})

refs = r['references']
gl_ref = next(x for x in refs if x['role'] == 'proof' and x['path'].endswith('/Becoming/GrammarLaws.lean'))
gl_ref['declarations'] = sorted(set(gl_ref['declarations']) | set(GL))
at = max(i for i, x in enumerate(refs) if x['role'] == 'proof') + 1
for m, ds in NEW.items():
    path = f'{PKG}/Becoming/{m}.lean'
    assert not any(x['path'] == path for x in refs), path
    refs.insert(at, {'path': path, 'role': 'proof', 'declarations': ds, 'sha256': sha(path)})
    at += 1
    r['proof_bindings'].append({'source': path, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{m}',
                                'success_pointer': '/status', 'success_value': 'passed'})
refs.append({'path': f'{DEV}/AUDIT.md', 'role': 'integration', 'sha256': sha(f'{DEV}/AUDIT.md')})
if (ROOT / f'{DEV}/REVIEW-OU3c.md').exists():
    refs.append({'path': f'{DEV}/REVIEW-OU3c.md', 'role': 'review', 'sha256': sha(f'{DEV}/REVIEW-OU3c.md')})
refs.append({'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)})

r['does_not_show'] += [
    {'en': 'That the anchors Branching.Returns, Branching.Lossless, GoAlikeUnder, Web.Widens and Weighting.WidensOn are '
           'their grammar terms by definition: each is equivalent to its grammar term by a representation theorem, not '
           'equal to it by rfl, and none is redefined (OU3c\'s audit).',
     'zh': '锚 Branching.Returns、Branching.Lossless、GoAlikeUnder、Web.Widens 与 Weighting.WidensOn 以定义即其文法之项：'
           '各以表示定理与其文法之项等价，而非依 rfl 相等，亦无一被重定义（OU3c 之审查）。', 'kind': 'non-implication'},
    {'en': 'That the learnability laws (Learnable.learnable_iff, LearnableRuns.learnable_iff_tracks) are cases of the '
           'return law: they rest on pigeonhole through Learning.lasso_of_held, whose bound (i + q + 1 at most the '
           'list\'s length) the grammar\'s «定后于线有限则末返» does not carry; a grammar law with the bound would '
           'restate pigeonhole, a lemma on lists.',
     'zh': '可学之律（Learnable.learnable_iff、LearnableRuns.learnable_iff_tracks）为返之律之例：其经 Learning.lasso_of_held '
           '依于鸽笼，其界（i + q + 1 不过列表之长）文法之 «定后于线有限则末返» 不载；载此界之文法律不过重述鸽笼，乃列表之引理。',
     'kind': 'non-implication'},
    {'en': 'That C\'s extension on the paths of a web is a case of the grammar\'s widening (Web.paths_extension_iff_widens, '
           'Direction.extension_iff_widens, Web.paths_comparison_widens, and Web.paths_one_object, which also takes the '
           'next item): its content is a reindexing of claims, (formation, step), to admissions, (step, formation), with '
           'every claim counted; widening enters by its definition, and reaching the grammar would need a transport of '
           '«广» along the swap of a pair, adding machinery and no content.',
     'zh': '网之诸路上 C 之扩展为文法之扩大之例（Web.paths_extension_iff_widens、Direction.extension_iff_widens、'
           'Web.paths_comparison_widens，及兼取下一条之 Web.paths_one_object）：其内容为把主张（构成、步）重排为所纳（步、构成），'
           '每一主张皆计；扩大只以其定义入，及于文法须沿对之交换移运 «广»，徒增工具而无内容。', 'kind': 'non-implication'},
    {'en': 'That the reduction of what has significance to what can form under the continuation condition is a law of '
           'the grammar (Web.widens_iff_retains_adds): the free significance is not lifted to the root.',
     'zh': '在延续条件下，把有意义者归约为可成形者，为文法之律（Web.widens_iff_retains_adds）：自由之意义未升至根。',
     'kind': 'non-implication'},
    {'en': 'That widening being what every positive weighting ranks higher is a law of the grammar '
           '(Weighting.widens_iff_every_positive): the grammar has no weights.',
     'zh': '扩大即每一正权重皆排之更高者，为文法之律（Weighting.widens_iff_every_positive）：文法无权重。',
     'kind': 'non-implication'}]

gl = next(x for x in core['modules'] if x['module'] == 'Becoming.GrammarLaws')
vs = r['validation_scope']
vs['en'] = (f"Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.GrammarLaws, "
            f"{gl['theorems']} theorems in {len(gl['declarations'])} declarations, the 40 representation and bridge "
            f"declarations in fourteen model modules, and OU3c's derivations in three more, every one with an empty axiom "
            f"report, all cited; every theorem of the changed modules keeps its printed statement, but for the two relation "
            f"laws moved into the grammar and generalised to any universe. Three independent read-only AI reviews of OU3b, "
            f"every finding taken, in study section 417, and one of OU3c in study section {N}; not reviewed by a person.")
vs['zh'] = (f"Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.GrammarLaws，{len(gl['declarations'])} 项声明中 "
            f"{gl['theorems']} 条定理，十四个模型模块中 40 项表示与桥接声明，及另三模块中 OU3c 之推导，公理报告皆空，本记录全引；"
            f"诸改动模块之每条定理其所印陈述不变，唯移入文法之二关系律推广至任一宇宙。OU3b 经三次独立只读 AI 审查，所见皆采，"
            f"见研究第 417 节；OU3c 经一次，见研究第 {N} 节；未经人审。")
r['history'].append({
    'en': f"28 October 2026 (OU3c, study section {N}): the two relation laws moved into the grammar and the lagged orders "
          f"proved from them; structure and change as one lumping proved from the image law, and the step back of a "
          f"returning configuration from the decomposition of reach. No anchor is its grammar term by rfl, so each keeps "
          f"its definition; the reasons for the other consumers are in OU3c's audit.",
    'zh': f"2026年10月28日（OU3c，研究第 {N} 节）：二关系律移入文法，滞后之序由之证出；结构与变化同为一种归并由像之律证出，"
          f"返者之退一步由所及之分解证出。无一锚依 rfl 即其文法之项，故各保其定义；其余依之者之理由见 OU3c 之审查。"})
P.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record extended:', len(order['declarations']), 'order;', len(last['declarations']), 'in the last group')
