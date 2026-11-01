#!/usr/bin/env python3
"""BD4's texts on its branch (apply_bd3.py's pattern): the leaf's bullet in the root module, the checker's scope, both
README rows, regions.json's note, the eighth law and its items on balance-from-conservation-along-a-relation, and
01 §8.4's sentence. The leaf itself is edited on the branch. The receipt is left `PENDING` (three places: the scope in
both languages and the leaf's proof binding), for reland_bd4.py; the leaf's reference carries the leaf's digest now,
and sha_bd4.py refreshes it after any later edit of the leaf. Run from the worktree root on a tree with no other
change to these files; on any failed assertion every touched file is restored.
usage: python3 -B apply_bd4.py REVIEWED_AT_UTC DECLARATIONS THEOREMS (the scratch build's counts for the leaf, which
reland_bd4.py replaces with the receipt's)"""
import hashlib
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
LEAF = f'{PKG}/Becoming/BalanceRegions.lean'
REC = 'theories/becoming/results/records/balance-from-conservation-along-a-relation.json'
REVIEWED = sys.argv[1]
N_DECL, N_THM = int(sys.argv[2]), int(sys.argv[3])
assert REVIEWED.endswith('+00:00'), REVIEWED
C = 'Becoming.Continuity.'
DECLS = [C + n for n in (
    'closureListed', 'closureListed_iff', 'closureListed_closed', 'closureListed_closes',
    'conservedOn_iff_closures', 'balancing_iff_closures', 'balancesOn_iff_closures',
    'pairing_iff_closure_counts', 'pairing_iff_closures')]
# the witness of the second new item on what is not shown, and the inversion it uses
WITNESS = [C + n for n in (
    'paired_single', 'PathOfThree.rel', 'PathOfThree.paired_within', 'PathOfThree.not_paired_along_step',
    'PathOfThree.counts_kept_not_along_step')]
touched = []
for path in (f'{PKG}/Becoming.lean', f'{PKG}/check_becoming.py', f'{PKG}/README.md', f'{PKG}/README.zh.md',
             'theories/becoming/results/data/regions.json', REC, 'theories/becoming/chapters/01-ROOT.md'):
    assert subprocess.run(['git', 'diff', '--quiet', '--', path], cwd=ROOT).returncode == 0, ('changed already', path)


def rep(path, old, new, n=1):
    p = ROOT / path
    s = p.read_text(encoding='utf-8')
    c = s.count(old)
    assert c == n, (path, c, old[:100])
    if path not in touched:
        touched.append(path)
    p.write_text(s.replace(old, new), encoding='utf-8')


def main():
    # the root module's bullet
    rep(f'{PKG}/Becoming.lean',
        "  (`Continuity.balancesOn_iff_notGoingOut`). A leaf; balance from conservation on each closure under\n"
        "  the adjacency (the `«所闭»` form) is not shown.\n",
        "  (`Continuity.balancesOn_iff_notGoingOut`). Each closure under that adjacency, the grammar's\n"
        "  `«所闭»`, is decided as a test among the listed relata by a counting bound\n"
        "  (`Continuity.closureListed`, `Continuity.closureListed_iff`), and the transfers exist exactly\n"
        "  where the total is conserved on the closure of each listed relatum\n"
        "  (`Continuity.balancing_iff_closures`, on a web `Continuity.balancesOn_iff_closures`; board item\n"
        "  BD4), the uncapacitated case of the feasibility conditions for flows. At the unit grain, a\n"
        "  pairing under the closure of a symmetric relation whose closure a test decides is the count kept\n"
        "  on each closure (`Continuity.pairing_iff_closure_counts`, `Continuity.pairing_iff_closures`), a\n"
        "  case of `«类之对当且仅当类类等数»`, though not always along one step of the adjacency\n"
        "  (`Continuity.PathOfThree.counts_kept_not_along_step`). A leaf.\n")
    # the checker's scope
    rep(f'{PKG}/check_becoming.py',
        "    \"conserved on every region not gone out of along that adjacency, and on a web at every step likewise. \"\n",
        "    \"conserved on every region not gone out of along that adjacency, and on a web at every step likewise; \"\n"
        "    \"each closure under that adjacency, the grammar's «所闭», is decided as a test by a counting bound, and \"\n"
        "    \"the transfers exist exactly where the total is conserved on the closure of each listed relatum; at the \"\n"
        "    \"unit grain a pairing under the closure of a symmetric relation, decided by a test, is the count kept on \"\n"
        "    \"each closure, a case of the count law of a class. \"\n")
    # both README rows
    rep(f'{PKG}/README.md',
        "and on a web at every step likewise (`Continuity.balancesOn_iff_notGoingOut`); a leaf |",
        "and on a web at every step likewise (`Continuity.balancesOn_iff_notGoingOut`); each closure under that "
        "adjacency, the grammar's `«所闭»`, decided as a test (`Continuity.closureListed_iff`), and the transfers "
        "existing exactly where the total is conserved on the closure of each listed relatum "
        "(`Continuity.balancing_iff_closures`, on a web `Continuity.balancesOn_iff_closures`); at the unit grain, a "
        "pairing under the closure is the count kept on each closure, a case of `«类之对当且仅当类类等数»` "
        "(`Continuity.pairing_iff_closures`); a leaf |")
    rep(f'{PKG}/README.zh.md',
        "依存网上每步亦然（`Continuity.balancesOn_iff_notGoingOut`）；为叶模块 |",
        "依存网上每步亦然（`Continuity.balancesOn_iff_notGoingOut`）；此相邻下每个闭包（文法之 `«所闭»`）可判定为一"
        "检验（`Continuity.closureListed_iff`），而转移恰在总量于每个所列关系项之闭包上守恒处存在"
        "（`Continuity.balancing_iff_closures`，依存网上为 `Continuity.balancesOn_iff_closures`）；在单位之粒度上，"
        "闭包下之配对即每个闭包上计数相守，为 `«类之对当且仅当类类等数»` 之一例（`Continuity.pairing_iff_closures`）；"
        "为叶模块 |")
    # regions.json: the module's note, the file's own formatting (indent 1)
    rpath = 'theories/becoming/results/data/regions.json'
    p = ROOT / rpath
    old_text = p.read_text(encoding='utf-8')
    d = json.loads(old_text)
    assert json.dumps(d, ensure_ascii=False, indent=1) + '\n' == old_text, 'regions.json does not round-trip'
    entry = d['modules']['Becoming.BalanceRegions']
    assert entry['note'].endswith('(BD3)'), entry
    entry['note'] = ('a family a relation closes iff a region not gone out of (不出) along the listed adjacency; '
                     'balancing transfers iff conservation on every such region (BD3), iff on each closure (所闭), '
                     'decided as a test (BD4)')
    touched.append(rpath)
    p.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    # the record
    p = ROOT / REC
    old_text = p.read_text(encoding='utf-8')
    assert json.dumps(json.loads(old_text), ensure_ascii=False, indent=2) + '\n' == old_text, 'record does not round-trip'
    r = json.loads(old_text)
    assert len(r['laws']) == 7, len(r['laws'])
    law = {'en': ("With equality decided, each relatum's closure under the listed adjacency, «所闭», is decided by a "
                  "test. So, relata listed without repetition, transfers along the relation balancing a step exist "
                  "exactly where the total is conserved on each listed relatum's closure; on a web, at every step "
                  "likewise. Two lists pair one to one under the closure exactly where each closure holds equally many "
                  "of both, a case of «类之对当且仅当类类等数»."),
           'zh': ("关系项之相等可判定时，所列相邻下每个关系项之闭包（«所闭»）可判定为一检验。故关系项不重复列出时，沿关系"
                  "使一步平衡的转移，恰在总量于每个所列关系项之闭包上守恒时存在；网在每一步亦然。两列在闭包下一一成对，恰在每个"
                  "闭包所含两列之项同样多时，为 «类之对当且仅当类类等数» 之一例。"),
           'declarations': DECLS}
    print('law 8:', len(law['en']), 'en,', len(law['zh']), 'zh (soft caps 420/190)')
    assert len(law['en']) <= 420 and len(law['zh']) <= 190, (len(law['en']), len(law['zh']))
    r['laws'].append(law)
    dns = r['does_not_show']
    assert len(dns) == 6 and dns[5]['en'].startswith('That conservation on each closure'), dns[5]
    dns.pop()
    dns.append({
        'en': ("Transfers within capacities: conservation on each closure is the uncapacitated case of the "
               "feasibility conditions of Gale (1957) and Hoffman (1960); their capacitated case is not stated."),
        'zh': "容量之内的转移：每个闭包上的守恒是 Gale（1957）与 Hoffman（1960）可行性条件的无容量情形；有容量情形未陈述。",
        'kind': 'scope'})
    dns.append({
        'en': ("That counts kept on each closure give a pairing along one step of the adjacency: on the path "
               "0 — 1 — 2, [0] and [2] keep every closure's count, and no step joins 0 to 2."),
        'zh': "每个闭包计数相守即给出沿相邻一步之配对：在路径 0 — 1 — 2 上，[0] 与 [2] 在每个闭包上计数相守，而无一步连接 0 与 2。",
        'kind': 'non-implication',
        'witness': C + 'PathOfThree.counts_kept_not_along_step'})
    for x in dns[-2:]:
        assert len(x['en']) <= 240 and len(x['zh']) <= 110, (len(x['en']), len(x['zh']))
    vs = r['validation_scope']
    old_en = ('Checked by the core checker with Lean 4.29.1 from the prelude: Becoming.Continuity, 43 theorems in 64 '
              'declarations, and Becoming.BalanceRegions (the seventh law) at receipt 20261031T225858.600119Z, '
              '7 declarations (6 theorems), each with an empty axiom report. No independent review of '
              'Becoming.Continuity; Becoming.BalanceRegions and the seventh law read by an independent AI reader, '
              'every finding taken.')
    assert vs['en'] == old_en, vs['en']
    vs['en'] = ('Checked by the core checker with Lean 4.29.1 from the prelude: Becoming.Continuity, 43 theorems in 64 '
                'declarations, and Becoming.BalanceRegions (the seventh and eighth laws) at receipt PENDING, '
                f'{N_DECL} declarations ({N_THM} theorems), each with an empty axiom report; equality of relata '
                'decided, a modelling hypothesis taken as an argument, which adds no axiom to the reports. No '
                'independent review of '
                'Becoming.Continuity; Becoming.BalanceRegions and its two laws read by independent AI readers, every '
                'finding taken.')
    old_zh = vs['zh']
    assert '20261031T225858.600119Z' in old_zh, old_zh
    vs['zh'] = ('由核心检查器以 Lean 4.29.1 从前奏检查：Becoming.Continuity，64 个声明中 43 条定理；Becoming.BalanceRegions'
                f'（第七、八律），回执 PENDING，{N_DECL} 个声明中 {N_THM} 条定理；公理报告均为空；关系项之相等可判定，'
                '为建模假设，作为参数取入，不增报告之公理。Becoming.Continuity 没有独立审查；Becoming.BalanceRegions 及其两律经独立 AI '
                '读者审读，所提各点皆已采纳。')
    assert len(vs['en']) - 7 + 23 <= 600 and len(vs['zh']) - 7 + 23 <= 260, (len(vs['en']), len(vs['zh']))
    bound = [b for b in r['proof_bindings'] if b['source'] == LEAF]
    assert len(bound) == 1 and '20261031T225858.600119Z' in bound[0]['receipt'], bound
    bound[0]['receipt'] = f'{PKG}/becoming-checks/PENDING/verification.json'
    named = [x for x in r['references'] if x['path'] == LEAF]
    assert len(named) == 1, named
    named[0]['sha256'] = hashlib.sha256((ROOT / LEAF).read_bytes()).hexdigest()
    named[0]['declarations'] = named[0]['declarations'] + DECLS + WITNESS
    r['aliases'] = r['aliases'] + DECLS + WITNESS
    corr = r['correspondence']['en']
    old_c = ("Network flows: a flow on a finite graph with prescribed divergence exists exactly where the divergence "
             "sums to zero on each connected component; balancing_iff is that fact stated with the spine's families "
             "and computed.")
    assert corr.count(old_c) == 1, corr
    r['correspondence']['en'] = corr.replace(old_c, (
        "Network flows: a flow on a finite graph with prescribed divergence exists exactly where the divergence "
        "sums to zero on each connected component, the uncapacitated case of the feasibility conditions of Gale "
        "(1957) and Hoffman (1960); balancing_iff is that fact stated with the spine's families and computed, and "
        "balancing_iff_closures states it on each component, the grammar's «所闭» along the listed adjacency."))
    dep = [x for x in r['dependencies'] if x['id'] == 'master-laws-on-the-grammar']
    assert len(dep) == 1, dep
    dep[0]['detail'] = {
        'en': ("GrammarLaws.uncrossed_of_closed: a region closed under a relation and under its converse is one the "
               "relation crosses neither way; closes_iff_closed reads Continuity's closed family through it, the "
               "adjacency being symmetric. The eighth law reuses the closure's laws («所闭之自反», «所闭之传递», "
               "«所闭之对称», «缘在所闭», «闭含所闭»), the count «计» and the count law of a class "
               "«类之对当且仅当类类等数»."),
        'zh': ("复用 GrammarLaws.uncrossed_of_closed：在关系及其逆下皆闭之域，关系两向皆不越；closes_iff_closed 借之读 "
               "Continuity 之封闭家族，相邻对称。第八律复用闭包之律（«所闭之自反»、«所闭之传递»、«所闭之对称»、«缘在所闭»、"
               "«闭含所闭»）、计数 «计» 与类之计数律 «类之对当且仅当类类等数»。")}
    r['history'].append({
        'en': ("1 November 2026, board item BD4: an eighth law reads the record on the grammar's «所闭» "
               "(Becoming.BalanceRegions): each closure under the listed adjacency is decided as a test, so transfers "
               "balancing a step exist exactly where the total is conserved on each listed relatum's closure, and "
               "units are paired under the closure exactly where each closure keeps its count. The sixth item on "
               "what is not shown, the «所闭» form, is replaced by two: capacities, and pairing along one step, with a "
               "witness on the path 0 — 1 — 2. "
               "Gale and Hoffman named in the correspondence. No earlier statement, law or declaration changed."),
        'zh': ("2026年11月1日，工作板条目 BD4：第八律于文法之 «所闭» 上读本记录（Becoming.BalanceRegions）：所列相邻下每个"
               "闭包可判定为一检验，故使一步平衡之转移恰在总量于每个所列关系项之闭包上守恒时存在，而单位在闭包下成对恰在"
               "每个闭包计数相守时。所不示者第六项（«所闭» 形式）代之以二项：容量，与沿一步之配对（以路径 0 — 1 — 2 为证）。对应中写出 Gale 与 "
               "Hoffman。先前之陈述、规律与声明皆未变。")})
    r['reviewed_at_utc'] = REVIEWED
    touched.append(REC)
    p.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    # 01 §8.4: the home sentence, and the paragraph's list of what is not shown
    rep('theories/becoming/chapters/01-ROOT.md',
        "so such transfers exist exactly where the total is conserved on every such region "
        "(`Continuity.balancing_iff_notGoingOut`). A swap",
        "so such transfers exist exactly where the total is conserved on every such region "
        "(`Continuity.balancing_iff_notGoingOut`). Each relatum's closure, the grammar's `«所闭»` along that "
        "adjacency, is decided as a test (`Continuity.closureListed_iff`) and is the least such region holding it "
        "(`Continuity.closureListed_inside`), so such transfers exist exactly where the total is conserved on the "
        "closure of each listed relatum (`Continuity.balancing_iff_closures`), the uncapacitated case of the "
        "feasibility conditions for flows of Gale and Hoffman. At the grain of units, two lists of relata are paired "
        "one to one within the closures exactly where every closure holds equally many entries of both "
        "(`Continuity.pairing_iff_closures`), though not always along one step "
        "(`Continuity.PathOfThree.counts_kept_not_along_step`). A swap")
    rep('theories/becoming/chapters/01-ROOT.md',
        "Not shown: local fluxes in the lattice sense, or infinitely many relata ([record]",
        "Not shown: local fluxes in the lattice sense, transfers within capacities, or infinitely many relata "
        "([record]")


try:
    main()
except BaseException:
    for path in touched:
        subprocess.run(['git', 'checkout', '--', path], cwd=ROOT, check=True)
    print('restored', len(touched), 'files', file=sys.stderr)
    raise
print('\n'.join(touched))
