#!/usr/bin/env python3
"""DF2: the two errors research check found after the chapter phase. Run once from the checkout root.

- what-a-summary-keeps: D15 re-roled HistoryRealization as provenance (the core receipt lists it as superseded,
  stated by Becoming.HistoryLanguages, the precedent of R35 on derived-history-law-exactness); its proof binding goes
  with it, and the validation scope and the axiom hypothesis no longer name it as checked (the scope's
  clause first applied longer and shortened to the Chinese cap after the next check).
- finite-agreement-does-not-identify-priority: the Chinese validation scope within its 260-character cap."""
import json
from pathlib import Path

REC = Path.cwd() / 'theories/becoming/results/records'


def edit(rid, fn):
    p = REC / f'{rid}.json'
    d = json.loads(p.read_text(encoding='utf-8'))
    fn(d)
    p.write_text(json.dumps(d, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')


def sub(o, k, old, new):
    assert o[k].count(old) == 1, (k, old)
    o[k] = o[k].replace(old, new)


def summary(d):
    b = [x for x in d['proof_bindings'] if x['source'].endswith('deeper/HistoryRealization.lean')]
    assert len(b) == 1
    d['proof_bindings'].remove(b[0])
    v = d['validation_scope']
    sub(v, 'en', 'empty axiom reports; HistoryRealization by the package checker of 6 October (empty);',
        'empty axiom reports (the latter supersedes HistoryRealization, cited as provenance);')
    sub(v, 'zh', '公理报告皆空；HistoryRealization 经 10 月 6 日之包检查器（皆空）；', '公理报告皆空，后者所取代之 HistoryRealization 作来源；')
    h = d['hypotheses'][2]
    sub(h, 'en', 'have empty axiom reports, as do HistoryRealization\'s;', 'have empty axiom reports;')
    sub(h, 'zh', '公理报告皆空，HistoryRealization 的亦然；', '公理报告皆空；')


edit('what-a-summary-keeps', summary)


def agreement(d):
    sub(d['validation_scope'], 'zh', '于一会话中构建；本记录对照当前 Lean 读过；未经人审。', '一会话中构建；对照当前 Lean 读过；未经人审。')
    assert len(d['validation_scope']['zh']) <= 260, len(d['validation_scope']['zh'])


edit('finite-agreement-does-not-identify-priority', agreement)
print('df2_fix_check: applied')
