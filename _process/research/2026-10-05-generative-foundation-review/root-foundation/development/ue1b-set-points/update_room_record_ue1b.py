#!/usr/bin/env python3
"""UE1b: update the record room-read-off-the-exchange for the rule 9 refactor of Becoming.Optimum.

Its fourth law's declaration list grows, so this takes a history note, written here, and is not a bookkeeping re-point
(the other sixteen records bound to Optimum.lean are re-pointed by repoint.py, as repoint_ue1b.txt gives, with no
history note). The script adds Optimum.Above.full_of_ranked, Optimum.Above.floor_or_full_of_ranked and
Optimum.beyond_of_ranked to the fourth law, each before the rising law it now carries (the third after above_nothing),
and to the Optimum.lean reference in sorted place; sets that reference to the landed bytes; re-binds Optimum.lean to the
new core receipt, after checking that the receipt binds those bytes and passed, with the receipt as a reference; adds a
sentence to the validation scope; refreshes reviewed_at_utc; and adds the history note, dated from the receipt. The
fourth law's statement and the record's other laws are unchanged. Every edit asserts that it applies exactly once.

usage (from the checkout root of the landing worktree, after the checker and make_records_ue1b.py):
  python3 -B <kit>/update_room_record_ue1b.py RECEIPT N"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
OPT = f'{PKG}/Becoming/Optimum.lean'
RECORD = ROOT / 'theories/becoming/results/records/room-read-off-the-exchange.json'
LANDED_OPTIMUM = '3da737a69545d00146977487c4e287526233d6db927f5606fe0ae94031621d3f'
KIT_OPTIMUM = '6b8c4e2024cf6f5d8b1ffc1dd5cf8849f032e2bc118c23ed76c4f20f9eaeb6dc'
OLD_RECEIPT = f'{PKG}/becoming-checks/20261023T055339.893510Z/verification.json'
O = 'Becoming.Optimum.'
OLD_LAW4 = [O + 'Above.full', O + 'Above.floor_or_full', O + 'above_nothing', O + 'optimum_beyond']
NEW_LAW4 = [O + 'Above.full_of_ranked', O + 'Above.full', O + 'Above.floor_or_full_of_ranked', O + 'Above.floor_or_full',
            O + 'above_nothing', O + 'beyond_of_ranked', O + 'optimum_beyond']
GENERAL = [O + 'Above.full_of_ranked', O + 'Above.floor_or_full_of_ranked', O + 'beyond_of_ranked']
LAW4_EN = ('Above its floor, at every step to an optimum of every order rising with the family, each member takes its whole '
           'capacity at a condition beyond and gives nothing there, so the optimum stands at its floor or at what the rest '
           'leaves less the capacity; with no floor, every optimum stands at each condition beyond at the level before with '
           'what the rest gives, less what it takes, less the part\'s capacity, or at nothing.')
OLD_SCOPE_EN = ('Machine-checked by the consolidated Lean 4.29.1 checker (receipt 20261020T222228.243650Z): the 53 '
                'declarations Becoming.Optimum gained have empty axiom reports; the checker verifies core purity. Built and '
                'reviewed in one session, with no separate reviewer; author review in study section 288; not independently '
                'reviewed by a person.')
OLD_SCOPE_ZH = ('Lean 4.29.1 合并检查器实查（回执 20261020T222228.243650Z）：Becoming.Optimum 新增的 53 项声明公理报告为空；'
                '检查器并核对核心纯净。在一个会话中构建并审查，没有另设审查者；作者审查见研究第 288 节；未经人的独立审查。')


def update(r, receipt_id, n, opt_sha, receipt_sha, opt_names, now):
    """Edit the record `r` in place: `opt_names` are the receipt's declaration names of Becoming.Optimum, `opt_sha`
    the landed Optimum.lean's sha256, `receipt_sha` the receipt file's."""
    receipt = f'{PKG}/becoming-checks/{receipt_id}/verification.json'
    day = datetime.datetime.strptime(receipt_id[:8], '%Y%m%d')
    date_en, date_zh = f'{day.day} {day.strftime("%B")} {day.year}', f'{day.year}年{day.month}月{day.day}日'
    assert r['id'] == 'room-read-off-the-exchange'
    assert set(GENERAL) <= opt_names, sorted(set(GENERAL) - opt_names)
    # the fourth law: the three general laws, its statement unchanged
    at = [i for i, law in enumerate(r['laws']) if law['declarations'] == OLD_LAW4]
    assert at == [3], at
    assert r['laws'][3]['en'] == LAW4_EN
    r['laws'][3]['declarations'] = NEW_LAW4
    # the Optimum.lean reference: the three names in sorted place, the landed bytes
    refs = [x for x in r['references'] if x['path'] == OPT]
    assert len(refs) == 1
    ref = refs[0]
    assert ref['sha256'] == LANDED_OPTIMUM, ref['sha256']
    assert ref['declarations'] == sorted(ref['declarations']) and not set(GENERAL) & set(ref['declarations'])
    ref['declarations'] = sorted(ref['declarations'] + GENERAL)
    assert opt_sha == KIT_OPTIMUM, opt_sha
    ref['sha256'] = opt_sha
    # Optimum.lean's binding, to the new receipt, with the receipt as a reference
    bindings = [b for b in r['proof_bindings'] if b['source'] == OPT]
    assert len(bindings) == 1 and bindings[0]['receipt'] == OLD_RECEIPT, bindings
    assert bindings[0]['sha256_pointer'] == '/source_sha256/Becoming.Optimum'
    bindings[0]['receipt'] = receipt
    assert not any(x['path'] == receipt for x in r['references'])
    r['references'].append({'path': receipt, 'role': 'receipt', 'sha256': receipt_sha, 'declarations': []})
    # the validation scope: one sentence for the three general laws
    assert r['validation_scope']['en'] == OLD_SCOPE_EN and r['validation_scope']['zh'] == OLD_SCOPE_ZH
    r['validation_scope'] = {
        'en': OLD_SCOPE_EN + f' The three general laws of the exchange that the fourth law lists since UE1b were checked '
                             f'at core receipt {receipt_id}, with empty axiom reports, and reviewed independently with '
                             f'UE1b (AI, read-only, its findings taken).',
        'zh': OLD_SCOPE_ZH + f'第四条定律自 UE1b 起所列的交换之三条一般定律于核心回执 {receipt_id} 实查，公理报告为空，并随 UE1b '
                             f'经独立审查（AI，只读，所见皆采）。'}
    r['reviewed_at_utc'] = now
    r['history'].append({
        'en': f'{date_en}, UE1b (board rule 9): Optimum.Above.full, Optimum.Above.floor_or_full and Optimum.optimum_beyond '
              f'are now corollaries of Optimum.Above.full_of_ranked, Optimum.Above.floor_or_full_of_ranked and '
              f'Optimum.beyond_of_ranked, which take as hypothesis that the order ranks above the optimum the outcome '
              f'with one unit moved from the condition beyond into the family, in place of the rising order; the three '
              f'are added to the fourth law and its references; statements and this record\'s laws unchanged. '
              f'Optimum.lean rebound to core receipt {receipt_id} after reading the change (record '
              f'what-a-set-point-optimum-does-beyond, study section {n}).',
        'zh': f'{date_zh}，UE1b（看板规则 9）：Optimum.Above.full、Optimum.Above.floor_or_full 与 Optimum.optimum_beyond 现为 '
              f'Optimum.Above.full_of_ranked、Optimum.Above.floor_or_full_of_ranked 与 Optimum.beyond_of_ranked 的推论；后三者'
              f'以其序把自之外该条件移入族一单位的结果排在最优之上为假设，代替升高的序；三者加入第四条定律及其引用；陈述与本记录的'
              f'定律不变。读过改动后 Optimum.lean 改绑核心回执 {receipt_id}（记录 what-a-set-point-optimum-does-beyond，研究第 '
              f'{n} 节）。'})
    return r


def main():
    receipt_id, n = sys.argv[1], int(sys.argv[2])
    receipt = f'{PKG}/becoming-checks/{receipt_id}/verification.json'

    def sha(path):
        return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()

    core = json.loads((ROOT / receipt).read_text())
    assert core['status'] == 'passed'
    assert core['source_sha256']['Becoming.Optimum'] == sha(OPT) == KIT_OPTIMUM
    mod = next(m for m in core['modules'] if m['module'] == 'Becoming.Optimum')
    assert not any(mod['axiom_dependencies'].values())
    opt_names = {d['name'] for d in mod['declarations']}
    assert (ROOT / 'theories/becoming/results/records/what-a-set-point-optimum-does-beyond.json').exists(), \
        'run make_records_ue1b.py first'
    now = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
    r = json.loads(RECORD.read_text(encoding='utf-8'))
    update(r, receipt_id, n, sha(OPT), sha(receipt), opt_names, now)
    RECORD.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('room-read-off-the-exchange: fourth law', len(NEW_LAW4), 'declarations; rebound to', receipt_id)


if __name__ == '__main__':
    main()
