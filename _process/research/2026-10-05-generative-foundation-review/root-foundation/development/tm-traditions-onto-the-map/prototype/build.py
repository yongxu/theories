#!/usr/bin/env python3
"""TM's prototype of the correction ledger and the signifier layer (AI-written, 10 November 2026).

usage (from anywhere): python3 -B build.py [--check]

Reads, never writes, the account's data:
  - the 中华脉络's entries (development/zhonghua/passages.json), whose `gap` field records a gap a
    classical passage named and how it was answered (06 §7.2);
  - the result records (theories/becoming/results/records/*.json), for each answer's status and title;
  - the crosswalk (theories/becoming/results/atlas/entries/correspondences.json and
    correspondence_groups.json), for the map's scoping of sources' universal forms;
  - the atlas's dynamics (entries/dynamics.json), for the six Chinese names it holds.
Writes, in this folder only: corrections.json, signifiers.json, LEDGER.md, SIGNIFIERS.md.
With --check it writes nothing and exits 1 if a written file would change.

Nothing here is a result: the ledger and the signifiers are a view of what the account already holds,
plus the entries TM's own readings add (marked so). Statuses are read from the records, never typed.
"""
from __future__ import annotations

import json
import re
import sys
from collections import Counter, OrderedDict
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[6]
DEV = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development'
RECORDS = ROOT / 'theories/becoming/results/records'
ATLAS = ROOT / 'theories/becoming/results/atlas'
UP = '../../../../../../../'  # from this folder to the repository root

def load(p):
    return json.loads(Path(p).read_text(encoding='utf-8'))

def record_index():
    out = {}
    for p in sorted(RECORDS.glob('*.json')):
        try:
            r = load(p)
        except Exception:
            continue
        decls = set()
        for ref in r.get('references', []):
            for d in ref.get('declarations', []) or []:
                decls.add(d)
        out[r['id']] = {'status': r.get('status'), 'kind': r.get('kind'),
                        'title': (r.get('title') or {}), 'declarations': decls}
    return out

GAP_HEAD = re.compile(r'^(已补|范围之注)[（(]([A-Z0-9]+)[，,]\s*([0-9]{4})年([0-9]+)月([0-9]+)日[）)]')

def gap_corrections(recs):
    clusters = load(DEV / 'zhonghua/passages.json')['clusters']
    out = []
    for cid, cl in clusters.items():
        for e in cl['entries']:
            g = e.get('gap')
            if not g:
                continue
            m = GAP_HEAD.match(g)
            assert m, (e['id'], g[:40])
            kind, item = m.group(1), m.group(2)
            date = '%s-%02d-%02d' % (m.group(3), int(m.group(4)), int(m.group(5)))
            named = [x for x in dict.fromkeys(re.findall(r'([a-z0-9]+(?:-[a-z0-9]+)+)', g)) if x in recs]
            decls = re.findall(r'(?:Becoming\.)?((?:[A-Z][A-Za-z0-9]*\.)+[a-z_][A-Za-z0-9_]*|«[^»]+»)', g)
            if kind == '已补' and not named:
                full = {('Becoming.' + d if not d.startswith('Becoming.') else d) for d in decls}
                named = sorted(r for r, v in recs.items() if v['declarations'] & full)
            existing = '现有之律' in g
            if kind == '已补':
                change, disposition = 'law', ('law-found' if existing else 'law-added')
                corrected = 'map'
            else:
                change, disposition, corrected = 'scope-note', 'outside-scope', 'none'
            statuses = sorted({recs[r]['status'] for r in named}) if named else []
            out.append(OrderedDict([
                ('id', 'cor-zh-' + e['id']),
                ('direction', 'tradition→map'),
                ('source', OrderedDict([('corpus', '中华脉络'), ('entry', e['id']), ('cluster', cid),
                                        ('tradition', e.get('tradition')), ('work', e.get('work')),
                                        ('locator', e.get('locator')), ('fragment', (e.get('fragments') or [''])[0]),
                                        ('text_read', 'read-in-repo')])),
                ('change', change),
                ('disposition', disposition),
                ('corrected', corrected),
                ('result', OrderedDict([('records', named), ('statuses', statuses)])),
                ('item', item),
                ('date', date),
                ('note', {'zh': g}),
                ('by', 'AI, in board item ' + item),
            ]))
    return out

def tm_corrections(recs):
    """CY's laws, asked by dialectics in TM's joint reading (from memory, then read against the texts in TM's pilot), and the laws and tests TM's readings of the traditions found."""
    rows = []
    for rid, asked, laws in [
        ('where-a-run-turns', '物极必反、反者道之动：极端何时转为其反面',
         'a turn shows the step breaking the order on the run; on a regime, overcompensation'),
        ('the-draws-before', '量变质变（与滞后）：同一之量，所达之质依于来路',
         'the draws before decide the level under one draw; separated bounds for collapse and for leaving the inflow'),
    ]:
        rows.append(OrderedDict([
            ('id', 'cor-tm-' + rid),
            ('direction', 'tradition→map'),
            ('source', OrderedDict([('corpus', 'materialist dialectics and its neighbours'),
                                    ('work', 'Engels, Anti-Dühring and Dialectics of Nature; 《矛盾论》; 《老子》四十章'),
                                    ('fragment', asked), ('text_read', 'external-read')])),
            ('change', 'law'),
            ('disposition', 'law-added'),
            ('corrected', 'map'),
            ('result', OrderedDict([('records', [rid]), ('statuses', [recs[rid]['status']] if rid in recs else [])])),
            ('item', 'CY'),
            ('date', '2026-11-10'),
            ('note', {'en': laws}),
            ('by', 'AI, in board items TM and CY'),
        ]))
    for corpus, e in pilot_entries():
        kind = e['map_effect']['kind']
        if kind not in ('law', 'test'):
            continue
        rids = [l['record'] for l in e['landings']] if kind == 'law' else []
        rows.append(OrderedDict([
            ('id', 'cor-tm-' + e['id']),
            ('direction', 'tradition→map'),
            ('source', OrderedDict([('corpus', corpus), ('work', e['source']['work']),
                                    ('fragment', e['name']['zh']), ('text_read', e['source']['text_read'])])),
            ('change', kind),
            ('disposition', 'law-found' if kind == 'law' else 'still-open'),
            ('corrected', e['map_effect']['corrected']),
            ('result', OrderedDict([('records', rids), ('statuses', [recs[r]['status'] for r in rids if r in recs])])),
            ('item', 'TM'),
            ('date', '2026-11-10'),
            ('note', {'en': e['residue']}),
            ('by', 'AI, in TM\'s reading of ' + corpus),
        ]))
    return rows

PILOTS = [('materialist dialectics', 'dialectics.json'), ('the Zhou books', 'zhou.json'), ('王陽明', 'wang.json')]

def pilot_entries():
    """The entries of TM's tradition readings, in the pilot folder, with the corpus each reads."""
    out = []
    for corpus, name in PILOTS:
        d = json.loads((HERE.parent / 'pilot' / name).read_text(encoding='utf-8'))
        out += [(corpus, e) for e in d['entries']]
    return out

def blanks():
    """The blanks TM's readings named: an entry whose effect on the map is a blank, read from the pilot's data."""
    return [OrderedDict([('id', 'cor-blank-' + e['id']), ('direction', 'tradition→map'),
                         ('source', OrderedDict([('corpus', corpus), ('work', e['source']['work']), ('fragment', e['name']['zh']),
                                                 ('text_read', e['source']['text_read'])])),
                         ('change', 'blank'), ('disposition', 'still-open'), ('corrected', 'none'),
                         ('result', OrderedDict([('records', []), ('statuses', [])])), ('item', 'TM'),
                         ('date', '2026-11-10'), ('note', {'en': e['residue']}), ('by', 'AI, in TM\'s reading of ' + corpus)])
            for corpus, e in pilot_entries() if e['map_effect']['kind'] == 'blank']

def scope_view():
    corr = load(ATLAS / 'entries/correspondences.json')
    groups = {g['id']: g for g in load(ATLAS / 'entries/correspondence_groups.json')}
    by = Counter(); basis = Counter()
    for c in corr:
        if c.get('relation') == 'scope':
            by[c['group']] += 1
            basis[(c['group'], (c.get('source') or {}).get('basis'))] += 1
    rows = []
    for gid, n in by.most_common():
        g = groups.get(gid, {})
        rows.append(OrderedDict([('group', gid), ('title', (g.get('title') or {}).get('en', gid)),
                                 ('domain', g.get('domain')), ('scope_entries', n),
                                 ('read_in_repo', basis[(gid, 'read-in-repo')]),
                                 ('ai_knowledge', basis[(gid, 'ai-knowledge')])]))
    return rows

def signifiers():
    """The six Chinese names the atlas holds, reclassified, and the term 矛盾 as a worked example."""
    L = 'Becoming.'
    return [
        OrderedDict([('node', 'dynamic:degeneration-from-a-horizon'), ('kind', 'coined'), ('lang', 'lzh'), ('script', 'Hant'),
                     ('text', '退化'), ('anchor', L + '«退化»'), ('status', 'named'), ('basis', 'grammar name, defined in GrammarMap.lean'),
                     ('was', {'zh': '退化'})]),
        OrderedDict([('node', 'dynamic:closed-capture'), ('kind', 'coined'), ('lang', 'zh-Hans'), ('script', 'Hans'),
                     ('text', '元吸引子'), ('anchor', 'dynamic:closed-capture'), ('status', 'named'),
                     ('basis', 'a modern coinage for the glossary\'s meta-attractor'), ('was', {'zh': '元吸引子'})]),
        OrderedDict([('node', 'dynamic:closed-capture'), ('kind', 'coined'), ('lang', 'lzh'), ('status', '未立名'),
                     ('reason', 'no structural 文言 word yet: 闭 and 锁 carry the senses keep-the-possibility-space-open gives them (闭有二义)')]),
        OrderedDict([('node', 'dynamic:locked-seeking'), ('kind', 'tradition'), ('lang', 'lzh'), ('text', '无明'),
                     ('tradition', 'Buddhist'), ('relation', 'scope'),
                     ('residue', 'in Buddhist texts 无明 is the root of the twelve links and of suffering; the map reads only a seeker whose reading cannot reach beyond what it seeks'),
                     ('text_read', 'ai-knowledge'), ('was', {'zh': '无明'})]),
        OrderedDict([('node', 'dynamic:locked-seeking'), ('kind', 'tradition'), ('lang', 'lzh'), ('text', '无明'),
                     ('tradition', 'Buddhist (《大乘起信论》)'), ('relation', 'divergence'),
                     ('residue', '起信论 reads 念念相续 as 无明 and seeks to end the continuing of thought, the reverse of the map\'s neutral use of continuation (06 §十一)'),
                     ('text_read', 'read-in-repo')]),
        OrderedDict([('node', 'dynamic:locked-seeking'), ('kind', 'coined'), ('lang', 'lzh'), ('status', '未立名'),
                     ('reason', '无明 is a tradition\'s term with its own senses; a coined name would follow the 名表\'s rules')]),
        OrderedDict([('node', 'dynamic:obscuration-and-reopening'), ('kind', 'coined'), ('lang', 'lzh'), ('script', 'Hant'),
                     ('text', '偏蔽，復通'), ('anchor', 'dynamic:obscuration-and-reopening'), ('status', 'proposed'),
                     ('basis', '蔽 as in 《荀子·解蔽》 and «通» the grammar\'s name (往來不窮); the quotation not checked against the stored text'),
                     ('was', {'zh': '偏蔽，复通'})]),
        OrderedDict([('node', 'dynamic:waxing-and-waning-returns'), ('kind', 'coined'), ('lang', 'lzh'), ('script', 'Hant'),
                     ('text', '消息之律'), ('anchor', 'dynamic:waxing-and-waning-returns'), ('status', 'proposed'),
                     ('basis', '消息 as the 易 uses it for waxing and waning; the passage not checked against the stored text'),
                     ('was', {'zh': '消息之律'})]),
        OrderedDict([('node', 'dynamic:generation-and-degeneration-at-two-grains'), ('kind', 'coined'), ('lang', 'lzh'),
                     ('script', 'Hant'), ('text', '生成、守、退化'), ('anchor', [L + '«生成»', L + '«守»', L + '«退化»']),
                     ('status', 'named'), ('basis', 'three grammar names, defined in GrammarMap.lean; the dynamic bundles three regions'),
                     ('was', {'zh': '生成、守、退化'})]),
        OrderedDict([('node', ['law:' + L + '«能所相待»', 'law:' + L + '«有相则非亦有相»', 'record:relative-position-is-zero-sum',
                               'record:two-sided-regulation-and-late-reading']),
                     ('kind', 'tradition'), ('lang', 'zh-Hans'), ('text', '矛盾'), ('tradition', 'materialist dialectics'),
                     ('relation', ['scope', 'scope', 'scope', 'scope']),
                     ('residue', 'one word where the map has five nodes (the fifth, struggle as such, the grammar does not express); so 矛盾 gets no coined name'),
                     ('text_read', 'ai-knowledge')]),
    ]

def ledger_md(corr, scope, recs):
    gaps = [c for c in corr if c['id'].startswith('cor-zh-')]
    added = [c for c in gaps if c['disposition'] == 'law-added']
    found = [c for c in gaps if c['disposition'] == 'law-found']
    notes = [c for c in gaps if c['disposition'] == 'outside-scope']
    tm = [c for c in corr if c['id'].startswith('cor-tm-')]
    bl = [c for c in corr if c['change'] == 'blank']
    L = []
    L.append('*Generated by `build.py` in this folder (AI-written prototype, TM, 10 November 2026); do not edit by hand. A view of what the account holds, not a result.*')
    L.append('')
    L.append('# The correction ledger, a prototype')
    L.append('')
    L.append('Where traditions moved the map, and where the map scoped a tradition\'s universal form. The first column comes from the 中华脉络\'s gap notes (06 §7.2) and from CY\'s laws; the second from the crosswalk\'s scope entries; the third from blanks TM\'s joint reading named. Statuses are read from the records.')
    L.append('')
    L.append('## 1. 所问 → 所得: traditions moved the map')
    L.append('')
    L.append('%d gap notes in the 中华脉络: %d answered by a law added to the map, %d by laws the map already had, %d scope notes that sought no law. Two more laws were asked by materialist dialectics in TM\'s reading, first from memory, then read against the texts; TM\'s readings of the traditions add the laws they found already on the map and the tests they named.' % (len(gaps), len(added), len(found), len(notes)))
    L.append('')
    trad = Counter((c['source'].get('tradition') or '—') for c in added + found)
    L.append('By tradition (laws added or found): ' + '; '.join('%s %d' % (t, n) for t, n in trad.most_common()) + '.')
    L.append('')
    L.append('| Source | Passage | Answer | Disposition | Record status |')
    L.append('|---|---|---|---|---|')
    for c in sorted(added + found, key=lambda c: (c['source'].get('tradition') or '', c['source'].get('work') or '')):
        s = c['source']; frag = (s.get('fragment') or '').replace('|', '｜')
        if len(frag) > 40:
            frag = frag[:40] + '…'
        links = '、'.join('[%s](%stheories/becoming/results/records/%s.md)' % ((recs[r]['title'].get('zh') or recs[r]['title'].get('en') or r), UP, r) for r in c['result']['records'])
        who = ' '.join(x for x in (s.get('tradition'), s.get('work')) if x) or ('entry ' + s.get('entry', ''))
        L.append('| %s | 「%s」 | %s | %s | %s |' % (who, frag, links or '—', c['disposition'], ', '.join(c['result']['statuses']) or '—'))
    for c in tm:
        links = '、'.join('[%s](%stheories/becoming/results/records/%s.md)' % ((recs.get(r, {}).get('title') or {}).get('en', r), UP, r) for r in c['result']['records'])
        L.append('| %s | %s | %s | %s | %s |' % (c['source']['corpus'], c['source']['fragment'], links or ('a test named, no design' if c['change'] == 'test' else '—'), c['disposition'], ', '.join(c['result']['statuses']) or '—'))
    L.append('')
    L.append('Scope notes, no law sought (%d): ' % len(notes) + '、'.join('%s「%s」' % (c['source'].get('work') or '', (c['source'].get('fragment') or '')[:14]) for c in notes) + '.')
    L.append('')
    L.append('## 2. 所陈全称 → 所定之域: the map scoped a universal form')
    L.append('')
    L.append('The crosswalk\'s entries whose relation is scope: the source states a claim universally and the account gives where it holds. Each is an AI reading; a scope corrects the unrestricted reading of the source, and the source itself only where it admits the domain (TM\'s joint reading §三).')
    L.append('')
    L.append('| Group | Scope entries | Read in the repository | From AI knowledge |')
    L.append('|---|---|---|---|')
    for r in scope:
        page = r['group'][len('cxg-'):] if r['group'].startswith('cxg-') else r['group']
        L.append('| [%s](%stheories/becoming/results/atlas/crosswalk/%s.md) | %d | %d | %d |' % (r['title'], UP, page, r['scope_entries'], r['read_in_repo'], r['ai_knowledge']))
    L.append('')
    L.append('## 3. 留白: blanks a tradition named that no law answers')
    L.append('')
    for c in bl:
        L.append('- %s (%s, %s): %s' % (c['source']['fragment'], c['source']['corpus'], c['source']['work'], c['note']['en']))
    L.append('')
    return '\n'.join(L)

def signifiers_md(sigs):
    L = ['*Generated by `build.py` in this folder (AI-written prototype, TM, 10 November 2026); do not edit by hand.*', '',
         '# Signifiers, a prototype', '',
         'Three kinds kept apart (TM\'s joint reading §四): names the map coins (`coined`, 文言 first), a tradition\'s terms pointing at a node (`tradition`, with their relation and residue), and statements (at the record; none here yet). The six Chinese names the atlas holds today under one key `zh` are reclassified below; `zh` is retired in favour of `lzh` and `zh-Hans`.', '',
         '| Node | Kind | Language | Text | Status or relation | Basis or residue |', '|---|---|---|---|---|---|']
    for s in sigs:
        node = s['node'] if isinstance(s['node'], str) else '; '.join(s['node'])
        stat = s.get('status') or (s['relation'] if isinstance(s.get('relation'), str) else ', '.join(s.get('relation') or []))
        basis = s.get('basis') or s.get('residue') or s.get('reason') or ''
        L.append('| %s | %s | %s | %s | %s | %s |' % (node, s['kind'], s['lang'], s.get('text', '—'), stat, basis.replace('|', '｜')))
    L.append('')
    return '\n'.join(L)

def main():
    check = '--check' in sys.argv
    recs = record_index()
    corr = gap_corrections(recs) + tm_corrections(recs) + blanks()
    scope = scope_view()
    sigs = signifiers()
    outs = {
        'corrections.json': json.dumps({'about': 'TM prototype (AI-written): the correction ledger, built by build.py; statuses read from the records.',
                                        'entries': corr, 'scope_view': scope}, ensure_ascii=False, indent=1) + '\n',
        'signifiers.json': json.dumps({'about': 'TM prototype (AI-written): signifiers in three kinds; the six zh names reclassified.',
                                       'entries': sigs}, ensure_ascii=False, indent=1) + '\n',
        'LEDGER.md': ledger_md(corr, scope, recs),
        'SIGNIFIERS.md': signifiers_md(sigs),
    }
    changed = []
    for name, text in outs.items():
        p = HERE / name
        if not p.exists() or p.read_text(encoding='utf-8') != text:
            changed.append(name)
            if not check:
                p.write_text(text, encoding='utf-8')
    gaps = [c for c in corr if c['id'].startswith('cor-zh-')]
    print(json.dumps({'gap_entries': len(gaps),
                      'law_added': sum(c['disposition'] == 'law-added' for c in gaps),
                      'law_found': sum(c['disposition'] == 'law-found' for c in gaps),
                      'scope_notes': sum(c['disposition'] == 'outside-scope' for c in gaps),
                      'without_record': [c['id'] for c in gaps if c['change'] == 'law' and not c['result']['records']],
                      'tm_rows': sum(c['id'].startswith('cor-tm-') for c in corr), 'blanks': sum(c['change'] == 'blank' for c in corr), 'scope_groups': len(scope),
                      'scope_entries': sum(r['scope_entries'] for r in scope), 'signifiers': len(sigs),
                      'changed': changed}, ensure_ascii=False, indent=1))
    return 1 if (check and changed) else 0

if __name__ == '__main__':
    sys.exit(main())
