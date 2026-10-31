#!/usr/bin/env python3
"""RF round 2, third part, RF-M.3's landing (register_rfm2.py's pattern): register the apart roots the connectivity check
lists without a reason that are RF's, each with a category and a reason; stop on any other root, which belongs to its
owner.

* ListingValuation's laws hold of any finite listing of candidates with natural-number weights and values read through a
  map, and of one blanketed law carrying a reading formation's listing and valuation as state: the base supplies no
  reading of their vocabulary yet (general structure). They wait for the reading formation's learning beyond filtering
  by what it is shown and a holding formation planning among informing, revaluing and holding, on the base (RF).
* The witnesses (ListingValuation.TwoWorlds, .Informing, .WeightsApart, .OneListing, .Revaluing, and the four witnesses
  of Part 1 at the module's top level) are facts about one constructed model each (model witness).

A register entry no longer an apart root because ListingValuation now uses it is RF's to remove; any other stale entry
stops the script, for its owner. Textual edits, the rest of the file byte for byte (register_wrt2.py's pattern).
usage (from the checkout root): python3 -B register_rfm3.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
stale = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
stale = [] if not stale else [s.strip().strip("'\"") for s in stale.group(1).strip('[]').split(',') if s.strip()]
# A stale entry is RF's to remove where ListingValuation uses it: its modules are the ones ListingValuation imports,
# through HeldForReading, and its name, as written there (HeldForReading's names unqualified, ListingValuation opening
# HeldForReading), is a word of ListingValuation's source.
SOURCE = (HERE / 'tree/Becoming/ListingValuation.lean').read_text(encoding='utf-8')
IMPORTED = ('Becoming.HeldForReading.', 'Becoming.ReadingLoop.', 'Becoming.Blanket.', 'Becoming.Learning.',
            'Becoming.ListTests.')


def used_here(name):
    if not name.startswith(IMPORTED):
        return False
    short = name[len('Becoming.'):]
    written = short[len('HeldForReading.'):] if short.startswith('HeldForReading.') else short
    return re.search(r'(?<![A-Za-z0-9_.])' + re.escape(written) + r'(?![A-Za-z0-9_\'])', SOURCE) is not None


assert all(used_here(name) for name in stale), ("stale entries ListingValuation does not use are their owners'",
                                                [n for n in stale if not used_here(n)])
NAMES = {}
for mod in ('ListingValuation',):
    audit = (HERE / f'tree/.build/Becoming{mod}AxiomAudit.lean').read_text(encoding='utf-8')
    for name in re.findall(r'^#print axioms (\S+)$', audit, re.M):
        NAMES[name] = f'Becoming.{mod}'
WAIT = {
    'Becoming.ListingValuation': ('a law of any finite listing of candidates with natural-number weights and values read '
                                  'through a map (a reading formation\'s answer by its own valuation, a rule\'s least '
                                  'shortfall and residual by a reference, informing and revaluing), or of one blanketed '
                                  'law carrying the reading formation\'s listing and valuation as state; it waits for the '
                                  'reading formation\'s learning beyond filtering by what it is shown and a holding formation planning '
                                  'among informing, revaluing and holding over several steps, on the base (RF)'),
}
WITNESS = {  # the first key a name contains gives its reason
    '.TwoWorlds.': ('two candidate worlds a demonstration tells apart, three valuation states and a holding formation '
                    'that demonstrates or presents an input on a fixed schedule, on the joint law (RF)'),
    '.Informing.': ('two candidates of weight one, the reference gaining nothing and saving 10 at the first and gaining 1 '
                    'at the second, read by a valuation going on 2 at the first and switching off 5 at the second (RF)'),
    '.WeightsApart.': ('the candidates 0, 1 and 2, weighted 2, 1 and 1 by the holding formation and 1, 2 and 2 by the '
                       'reading formation, with one valuation (RF)'),
    '.OneListing.': ('a holding formation listing one candidate and a reading formation listing two, with a valuation '
                     'apart from the reference (RF)'),
    '.Revaluing.': ('two candidates of weight one, going on gaining 1 at the first and switching off saving 1 at the '
                    'second, and four one-decision alternatives (RF)'),
    'ListingValuation.scales_by_candidate': ('two candidates of weight one in one cell, valued on scales differing by '
                                             'candidate (RF)'),
    'ListingValuation.unweighted_told': ('one candidate the holding formation weighs one and the reading formation '
                                         'nothing, told the candidate (RF)'),
    'ListingValuation.release_keeps': ('one candidate whose answer releases where the reference stops, splits keeping '
                                       'the worth (RF)'),
    'ListingValuation.no_order_across': ('one candidate of weight one, its valuation revised from going on 10 and '
                                         'switching off 9 to 1 and 2 (RF)'),
}
reasons = {}
for name in unclassified:
    mod = NAMES.get(name)
    if mod is None:
        continue
    witness = next((w for part, w in WITNESS.items() if part in name), None)
    if witness is not None:
        reasons[name] = (mod, 'model-witness', f"{name.replace('Becoming.', '')}: a fact about one constructed model, "
                                               f'{witness}')
    else:
        reasons[name] = (mod, 'general-structure', f"{name.replace('Becoming.', '')}: {WAIT[mod]}")
others = [n for n in unclassified if n not in reasons]
assert not others, ("apart roots not registered here: read them; another session's belong to their owners", others)
t = F.read_text(encoding='utf-8')
block = ''
for name in unclassified:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    mod, cat, reason = reasons[name]
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "' + mod + '",\n   "category": "' + cat
              + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
for name in stale:
    d = json.loads(t)
    assert name in d['roots'], name
    entry = '  ' + json.dumps(name, ensure_ascii=False) + ': ' + json.dumps(d['roots'][name], ensure_ascii=False, indent=1).replace('\n', '\n  ')
    assert t.count(entry) == 1, ('entry text', name)
    after = t.index(entry) + len(entry)
    if t.startswith(',\n', after):
        t = t[:t.index(entry)] + t[after + 2:]
    else:
        before = t.rindex(',\n', 0, t.index(entry))
        t = t[:before] + t[after:]
    d2 = json.loads(t)
    assert name not in d2['roots'] and len(d2['roots']) == len(d['roots']) - 1
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
json.loads(t)
F.write_text(t, encoding='utf-8')
counts = {}
for name in unclassified:
    counts[reasons[name][1]] = counts.get(reasons[name][1], 0) + 1
print('register: added', len(unclassified), counts, '; removed, now used by ListingValuation:', stale)
