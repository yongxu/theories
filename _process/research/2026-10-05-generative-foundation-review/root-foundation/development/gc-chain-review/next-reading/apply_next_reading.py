#!/usr/bin/env python3
"""GC4: the next reading of the chain. C's role as 07 §4 states it; "registration" read source by source; G0 read use by use,
changed only where a sentence presented the premise as acting now with no route named; the link labels' tense.

Each edit replaces text that occurs exactly once in its field and asserts so. Sources are not touched. Run once from the
checkout root, or pass the data file's path.
usage: python3 -B <kit>/apply_next_reading.py [DATA]"""
import json
import re
import sys
from pathlib import Path

DATA = Path(sys.argv[1] if len(sys.argv) > 1 else 'theories/becoming/results/data/generativity-chain.json')

# C's role, as 07 §4 states it after PF3: "C gives order, in general alone", self-concern ranking one case with no C.
# The list's items also hold commas, so semicolons part them.
C_EN_OLD = ('no reading of living includes further generation, 生生, the object of the direction, is compared by widening, '
            'and ranking rests on C, widening what can form is better, also not asserted (07 §4)')
C_EN_NEW = ('no reading of living includes further generation; 生生, the object of the direction, is compared by widening; '
            'and C, widening what can form is better, gives order, in general alone, also not asserted (07 §4)')
C_ZH_OLD = '活的任一读法都不含继续生发，生生作为方向之所向，以扩大相比较，排序依于 C，即扩大可形成者更好，亦不断言（07 §4）'
C_ZH_NEW = '活的任一读法都不含继续生发；生生作为方向之所向，以扩大相比较；C，即扩大可形成者更好，给出次序，一般而言只有它，亦不断言（07 §4）'
C_FIELDS = [('C03', 'scope'), ('C17', 'claim'), ('C24', 'scope'), ('M15', 'scope'), ('M20', 'scope')]
# The key says once what "in general" excepts, as the glossary's row does.
KEY = [
    ('scope_en',
     'no reading of living includes further generation, 生生, the object of the direction, is compared by widening, '
     'and ranking rests on C, neither premise asserted',
     'no reading of living includes further generation; 生生, the object of the direction, is compared by widening; '
     'and C, widening what can form is better, gives order, in general alone (self-concern ranks one case with no C), '
     'neither the continuation condition nor C asserted'),
    ('scope_zh',
     '活的任一读法都不含继续生发，生生作为方向之所向，以扩大相比较，排序依于 C，两条前提都不断言',
     '活的任一读法都不含继续生发；生生作为方向之所向，以扩大相比较；C，即扩大可形成者更好，给出次序，一般而言只有它'
     '（自我关切无需 C 即可给一种情形排序），延续条件与 C 都不断言'),
]

# (entry, field, old, new)
TEXT = [
    # A count is not a ranking. 07 §3.2 and positive-ground-open-futures give a contributory reason under living significance,
    # with correspondence and a supplied articulation, and use no C; a ranking of courses needs C or a premise in its place (07 §4).
    ('M21', 'claim_en', 'can count positively, a count that rests on C (07 §4), without',
     'can count positively, as a reason under living significance with a supplied articulation and correspondence (07 §3.2) '
     'and in a ranking of courses under C or a premise in its place (07 §4), without'),
    ('M21', 'claim_zh', '新的生也可计为正面，此计依于 C（07 §4），且不自动',
     '新的生也可计为正面：作为理由，须有存活之意义、所给的表述与对应（07 §3.2）；在进程的排序中，须有 C 或代替它的前提（07 §4）；且不自动'),
    # "Registration", each by its source's sense. The first three are the plain word: VERSIONED-CORRECTION-INTEGRATION
    # registers a request's pin, in "capture with pin registration"; none of coupling, lumping or contacts.
    ('C33', 'scope_en', 'Atomic acquisition with registration,', 'Atomic acquisition with pin registration,'),
    ('C33', 'scope_zh', '保留原子取得与登记、', '保留原子取得与 pin 登记、'),
    ('F29', 'scope_en', 'Atomic acquisition with registration,', 'Atomic acquisition with pin registration,'),
    ('F29', 'scope_zh', '保留原子取得与登记、', '保留原子取得与 pin 登记、'),
    ('M23', 'scope_en', 'Atomic acquisition with registration,', 'Atomic acquisition with pin registration,'),
    ('M23', 'scope_zh', '保留原子取得与登记、', '保留原子取得与 pin 登记、'),
    # SCIENTIFIC-INQUIRY-CONDITIONS §11's row links the record now named testing-within-couplings, whose zh title is 耦合之内的检验.
    ('M21', 'claim_en', 'the necessity correspondence for registration, generalization,',
     'the necessity correspondence for testing within the couplings, generalization,'),
    ('M21', 'claim_zh', '现已给出识、推广、', '现已给出耦合之内的检验、推广、'),
    # P92's bound: §12.2's first two premises, finite-fallible-inquiry-necessity's laws 8 and 10. The levels are restricted to
    # what couples in beyond the reach; P104's, later in the entry, are not.
    ('M21', 'claim_en', 'under balance, matching initial registrations and complete readouts',
     'under balance, the same formations present, alike initial levels on what couples in beyond responsive reach, and complete readouts'),
    ('M21', 'claim_zh', '在平衡、相同初始所识和完整读数条件下', '在平衡、在场形成相同、回应可达之外耦合入者初始水平相同和完整读数条件下'),
    # timely-response-necessity's law 1 (a coupling on a route is at some s ≤ t) and the study's §16 counterreview (a requirement
    # appearing only in a future step creates no earlier edge).
    ('M21', 'claim_en', 'future support cannot count as earlier registration',
     'future support cannot count as an earlier coupling'),
    ('M21', 'claim_zh', '未来支持不能倒算成此前登记', '未来支持不能倒算成此前的耦合'),
    # G0, where a sentence presented the premise as acting now. M20 has the note and still said "retains", against it; P95's
    # home in its Chinese edition (PRACTICAL-JUDGMENT.zh.md §2.1) says two things, that the G0/J conditional interface is kept
    # and that G0 is folded; the English edition has the same under 08 §10's later labels.
    ('M20', 'scope_en', 'G0 retains its folded significance interface, with J2 strength',
     'it keeps the G0/J conditional interface of that time, G0 then folded into significance, with J2 strength'),
    ('M20', 'scope_zh', 'G0 沿用折入意义后的条件接口，J2 强度', '沿用当时的 G0/J 条件接口，G0 当时已折入意义，J2 强度'),
    # The other three have no note in their entries; the form is M20's "under the G0 route then taken".
    ('F14', 'scope_en', 'Explicit G0 supersedes the earlier premise-free impasse audit;',
     'Under the G0 route then taken, explicit G0 superseded the earlier premise-free impasse audit;'),
    ('F14', 'scope_zh', '旧无前提受阻审计已由明确 G0 方向取代，未执行', '在当时所取的 G0 路线下，明确的 G0 取代了旧无前提受阻审计；未执行'),
    ('M25', 'claim_en', 'Explicit G0/J grounds appraise', 'Under the G0/J route then taken, explicit G0/J grounds appraise'),
    ('M25', 'claim_zh', '明确G0/J规范基础评价', '在当时所取的 G0/J 路线下，明确的 G0/J 规范基础评价'),
    ('C23', 'claim_en', 'G0, disclosed J1–J4, finite knowledge', 'Under the G0 route then taken, G0, disclosed J1–J4, finite knowledge'),
    ('C23', 'claim_zh', 'G0、公开 J1–J4、有限认识', '在当时所取的 G0 路线下，G0、公开 J1–J4、有限认识'),
]

# (entry, old_en, new_en, old_zh, new_zh)
LABELS = [
    # The two records' titles since GC2's renames, and Becoming.Revision's account; the paths keep their words.
    ('C14', 'Formed registration and fidelity', 'Formed contacts and fidelity', '配准形成与保真', '形成的接触与保真'),
    ('C14', 'Registration-copying checks', 'Contacts-and-copying checks', '配准复制实查', '接触与复制实查'),
    ('M24', 'Registration revision on the unified spine', 'Revision of the lumping on the unified spine',
     '统一主干中的登记修订', '统一主干中的归并修订'),
    # Receipts of 8 October, no longer current.
    # C01's and M15's labels: the zh said complete build, M15's en affected build; each receipt lists 32 modules and says neither.
    ('C01', 'Current formation-repair build', 'Formation-repair build of 8 October', '当前形成修复完整构建', '10 月 8 日的形成修复构建'),
    # This receipt ran at 18:54Z, already 9 October in Asia/Bangkok, where the study reporting it is dated; its path says 20261008.
    ('C09', 'Current source-bound check', 'Source-bound check of 8 October (UTC)', '本次源码绑定实查', '10 月 8 日（UTC）的源码绑定实查'),
    ('M15', 'Current affected-build receipt', 'Build receipt of 8 October', '当前完整构建回执', '10 月 8 日的构建回执'),
    ('F01', 'Current check receipt', 'Check receipt of 8 October', '本轮检查回执', '10 月 8 日的检查回执'),
    ('F01', 'Frozen pilot receipt', 'Frozen pilot receipt', '本轮冻结回执', '冻结试点回执'),
    # Sources and sections labelled from the session that made them.
    ('C01', 'Request and provenance', 'Request and provenance', '本次原话', '请求与来源'),
    ('C01', 'Renewed stronger request', 'Renewed stronger request', '本次更强要求', '再次提出的更强要求'),
    ('C20', 'Method correction in this inquiry', 'Method correction of 13 October', '本会话方法纠正', '10 月 13 日的方法纠正'),
    ('C26', 'Current focus directive', 'Source: the words on the focus, 13 October', '本次聚焦原话', '来源：10 月 13 日关于聚焦的原话'),
    ('M24', 'Session directive', "Source: the session's words, 8 October", '本会话原话', '来源：10 月 8 日会话的原话'),
    ('M15', 'Root proof target and current connections', 'Root proof target and its connections', '慧根证明目标与当前连接', '慧根证明目标及其连接'),
    # The source says "working definition", dated 8 October.
    ('M24', 'Current definition', 'Working definition of 8 October', '当前定义', '10 月 8 日的工作定义'),
    # GC2 kept this one as naming its round's frontier; it now says what the counterexample is against, in the source's words:
    # "a specified current corrigibility claim", in its zh "已发表的有限权重可纠正性保证".
    ('M23', 'Executable repair and current-theorem counterexample',
     'Executable repair and a counterexample to a published finite-weight corrigibility guarantee',
     '可执行修复与前沿反例', '可执行修复与针对已发表有限权重可纠正性保证的反例'),
    # The zh said present realization and the en did not. M15's connection says the proofs supply it, and M15's other label renders
    # it 当下实现; the file proves realized living content and the ranking laws.
    ('M15', 'Original realization and ranking-boundary proofs', 'Original proofs supplying present realization, and the ranking boundary',
     '当前实现及排序边界的原证明', '供应当下实现的原证明及排序边界'),
    # Retired protocols: the en was already this, and 范围 said scope.
    ('M20', 'Study protocol', 'Study protocol', '本轮范围', '研究方案'),
    ('M20', 'Adequacy protocol', 'Adequacy protocol', '份额接续范围', '份额接续方案'),
    ('M20', 'Formal continuation protocol', 'Formal continuation protocol', '形式接续范围', '形式接续方案'),
]


def once(text, old, new, where):
    assert text.count(old) == 1, (where, text.count(old), old[:80])
    return text.replace(old, new)


def main():
    data = json.loads(DATA.read_text())
    entries = {e['id']: e for s in data['sections'] for e in s['entries']}
    for field, old, new in KEY:
        data[field] = once(data[field], old, new, ('key', field))
    for entry, field in C_FIELDS:
        entries[entry][field + '_en'] = once(entries[entry][field + '_en'], C_EN_OLD, C_EN_NEW, (entry, 'C en'))
        entries[entry][field + '_zh'] = once(entries[entry][field + '_zh'], C_ZH_OLD, C_ZH_NEW, (entry, 'C zh'))
    for entry, field, old, new in TEXT:
        entries[entry][field] = once(entries[entry][field], old, new, (entry, field))
    for entry, old_en, new_en, old_zh, new_zh in LABELS:
        links = [l for l in entries[entry]['links'] if l['label_en'] == old_en]
        assert len(links) == 1 and links[0]['label_zh'] == old_zh, (entry, old_en, [l['label_zh'] for l in links])
        links[0]['label_en'], links[0]['label_zh'] = new_en, new_zh
    text = json.dumps(data, ensure_ascii=False)
    for gone in ('ranking rests on C', 'a count that rests on C', '排序依于'):
        assert gone not in text, gone
    # What remains of the word: the pin in prose, and two link paths kept as they are.
    left = sorted(set(m.group(0) for m in re.finditer(r'.{12}[Rr]egistration.{6}', text)))
    print('registration left:', left)
    DATA.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n')
    print('applied', len(KEY) + 2 * len(C_FIELDS), 'edits of C,', len(TEXT), 'text edits and', len(LABELS), 'label pairs')


if __name__ == '__main__':
    main()
