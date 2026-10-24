"""OU4 + OU5 + OU2c: register the apart roots of GrammarMap, MapInstances, GrammarTesting and GrammarCandidates (leaves),
and remove the entries no longer apart roots. Reads the roots from the connectivity log given.
usage (from the checkout root): python3 -B register456.py CONNECTIVITY_LOG"""
import ast
import json
import re
import sys
from pathlib import Path
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
PKG = Path('experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming')
log = Path(sys.argv[1]).read_text()
m = re.search(r"apart roots without a reason in THEOREM-CONNECTIVITY-APART.json: (\[.*?\]); register entries no longer apart roots: (\[.*?\])", log)
roots, stale = ast.literal_eval(m.group(1)), ast.literal_eval(m.group(2))
t = F.read_text(encoding='utf-8')
for name in stale:
    pat = re.compile(r'  "' + re.escape(name) + r'": \{\n(?:   [^\n]*\n)*?  \},?\n')
    mm = pat.search(t)
    assert mm, name
    t = t[:mm.start()] + t[mm.end():]
t = t.replace('  },\n },\n "instances": {', '  }\n },\n "instances": {')
MODS = ['GrammarMap', 'MapInstances', 'GrammarTesting', 'GrammarCandidates']
src = {mo: (PKG / f'{mo}.lean').read_text(encoding='utf-8') for mo in MODS}


def module_of(name):
    short = name.split('.')[-1]
    hits = [mo for mo in MODS if re.search(r'(theorem|def|lemma)\s+(\S+\.)?' + re.escape(short) + r'(?=[\s:({])', src[mo])]
    assert len(hits) == 1, (name, hits)
    return 'Becoming.' + hits[0]


CAL = ['当且仅当排中', '当且仅当弱排中', '双非可还']
WIT = ['Map.Endless', 'Map.Short', 'Map.Still', 'Map.«生守相杂»', '«恒温与平衡»', '«尺与尺可相尽»', '«致诘不尽»',
       '«从缘生非文法之理»', '«有生不必有亡»', '«有自不必有他»', '«二际可偏举»']
REASON = {
    'Becoming.GrammarMap': 'a law of every relation read at a fine and a coarse class on any carrier; the base supplies no reading of the two grains yet',
    'Becoming.MapInstances': 'a law of the map on the old base\'s continuation relations that reads no web',
    'Becoming.GrammarTesting': 'a law of every relation and class on any carrier; the base supplies no reading of the stages yet',
    'Becoming.GrammarCandidates': 'a candidate theorem of the corpus (its unit in the OU2c outcomes) proved for every relation on any carrier; the base supplies no reading of its terms',
}
block = ''
for name in roots:
    mo = module_of(name)
    if any(c in name for c in CAL):
        cat, reason = 'calibration', 'the exact logical principle a stated law of the grammar needs (excluded middle, its weak form or double-negation stability); a lemma of the item that needs it'
    elif any(w in name for w in WIT):
        cat, reason = 'model-witness', 'a fact about one constructed model: a witness or counterexample of the grammar\'s laws'
    else:
        cat, reason = 'general-structure', REASON[mo]
    assert f'"{name}"' not in t, name
    block += ('  "' + name + '": {\n   "module": "' + mo + '",\n   "category": "' + cat + '",\n'
              '   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
anchor = '  }\n },\n "instances": {'
assert t.count(anchor) == 1
t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
json.loads(t)
F.write_text(t, encoding='utf-8')
print('register456: removed', len(stale), 'added', len(roots))
