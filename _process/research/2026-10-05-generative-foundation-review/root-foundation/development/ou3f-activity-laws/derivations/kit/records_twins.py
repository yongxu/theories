#!/usr/bin/env python3
"""OU3f, the twins: bring the record a-pattern-lasts-through-passing to the retired names. Its law on the grammar (law 4)
says the second law's two statements and the third law's ending are proved from grammar laws, naming the kept theorems;
the two retired names leave its aliases and the module's reference; a history note. Re-pointing follows (repoint
--drift-json with --receipt and --lean).
usage (from the checkout root, after the checker): python3 -B <kit>/records_twins.py RECEIPT N"""
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT_ID, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
P = ROOT / 'theories/becoming/results/records/a-pattern-lasts-through-passing.json'
core = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT_ID / 'verification.json').read_text())
assert core['status'] == 'passed'
names = {d['name'] for m in core['modules'] if m['module'] == 'Becoming.PatternPassing' for d in m['declarations']}
W = 'Becoming.Web.ByPassing.'
RETIRED = {W + 'passes_within_by_line': W + 'passes_within', W + 'begins_passed_by_grammar': W + 'begins_passed'}
assert not set(RETIRED) & names and {W + 'passes_within', W + 'begins_passed', W + 'ends_within'} <= names

r = json.loads(P.read_text(encoding='utf-8'))
law = r['laws'][4]
EN = 'and both statements of the second law follow from grammar laws;'
ZH = '第二条律的两个陈述都由文法规律导出；'
assert law['en'].count(EN) == 1 and law['zh'].count(ZH) == 1, 'law 4 has changed; re-read it'
law['en'] = law['en'].replace(EN, 'and both statements of the second law and the ending of the third are proved from grammar laws;')
law['zh'] = law['zh'].replace(ZH, '第二条律的两个陈述及第三条律中的终止都由文法规律证出；')
decls = []
for d in law['declarations']:
    d = RETIRED.get(d, d)
    if d not in decls:
        decls.append(d)
at = decls.index(W + 'begins_passed') + 1
decls.insert(at, W + 'ends_within')
law['declarations'] = decls
assert all(a in r['aliases'] for a in RETIRED)
r['aliases'] = [a for a in r['aliases'] if a not in RETIRED]
ref = next(x for x in r['references'] if x['role'] == 'proof' and x['path'].endswith('/Becoming/PatternPassing.lean'))
assert all(a in ref['declarations'] for a in RETIRED)
ref['declarations'] = [d for d in ref['declarations'] if d not in RETIRED]
r['history'].append({
    'en': f"29 October 2026, board item OU3f (study section {N}): the second law's two statements and the third law's "
          f"ending are proved from grammar laws under their own names (board rule 9). ByPassing.passes_within and "
          f"begins_passed take the derivations of their twins, which are retired (passes_within_by_line, "
          f"begins_passed_by_grammar), and ByPassing.ends_within is proved as passes_within is, through the pattern's "
          f"line and «两端分则中有标»; the law on the grammar, its declarations, the aliases and the module's reference "
          f"brought to the kept names.",
    'zh': f"2026年10月29日，工作板条目 OU3f（研究第 {N} 节）：第二条律的两个陈述及第三条律中的终止，以其本名由文法规律证出（板规九）。"
          f"ByPassing.passes_within 与 begins_passed 取其孪生之推导，孪生（passes_within_by_line、begins_passed_by_grammar）退役；"
          f"ByPassing.ends_within 如 passes_within 之证，经样式之相续与「两端分则中有标」；文法上之律、其声明、别名与该模块之引用皆改为所存之名。"})
P.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record a-pattern-lasts-through-passing brought to the kept names')
