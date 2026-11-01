#!/usr/bin/env python3
"""BD4's texts on its branch (apply_bd3.py's pattern): the leaf's bullet in the root module, the checker's scope, both
README rows, regions.json's note, the eighth law, its items and its hypothesis on
balance-from-conservation-along-a-relation, and 01 §8.4's sentence. The leaf itself is edited on the branch. The receipt
is left `PENDING` (three places: the scope in both languages and the leaf's proof binding), for reland_bd4.py; the
leaf's reference carries the leaf's digest now and every declaration of the leaf, read from its source, and sha_bd4.py
refreshes the digest after any later edit of the leaf. Run from the worktree root on a tree with no other change to
these files; on any failed assertion every touched file is restored.
usage: python3 -B apply_bd4.py REVIEWED_AT_UTC DECLARATIONS THEOREMS (the scratch build's counts for the leaf, which
reland_bd4.py replaces with the receipt's)"""
import hashlib
import json
import re
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
# the eighth law's declarations: the closure decided and least, balance on each closure, the unit grain and the join
DECLS = [C + n for n in (
    'closureListed', 'closureListed_iff', 'closureListed_closed', 'closureListed_closes', 'closureListed_self',
    'closureListed_inside', 'conservedOn_iff_closures', 'balancing_iff_closures', 'balancesOn_iff_closures',
    'pairing_iff_closure_counts', 'pairing_iff_closures', 'unitsOn', 'count_unitsOn', 'conservedOn_iff_units_paired',
    'balancing_iff_units_paired', 'balancesOn_iff_units_paired')]
# the witness of the second new item on what is not shown, the inversion it uses, and the unlisted closure
WITNESS = [C + n for n in (
    'paired_single', 'PathOfThree.rel', 'PathOfThree.paired_within', 'PathOfThree.not_paired_along_step',
    'PathOfThree.counts_kept_not_along_step')]
ALIASES = DECLS + WITNESS + [C + 'closureListed_unlisted']
touched = []
for path in (f'{PKG}/Becoming.lean', f'{PKG}/check_becoming.py', f'{PKG}/README.md', f'{PKG}/README.zh.md',
             'theories/becoming/results/data/regions.json', REC, 'theories/becoming/chapters/01-ROOT.md'):
    assert subprocess.run(['git', 'diff', '--quiet', '--', path], cwd=ROOT).returncode == 0, ('changed already', path)


def leaf_declarations():
    """Every declaration of the leaf, by full name, in source order."""
    names, spaces = [], []
    for line in (ROOT / LEAF).read_text(encoding='utf-8').split('\n'):
        m = re.match(r'namespace (\S+)$', line)
        if m:
            spaces.append(m.group(1))
            continue
        m = re.match(r'end (\S+)$', line)
        if m and spaces and spaces[-1] == m.group(1):
            spaces.pop()
            continue
        m = re.match(r'(?:theorem|def|abbrev|structure|inductive) (\S+)', line)
        if m:
            names.append('.'.join(spaces + [m.group(1)]))
    return names


def rep(path, old, new, n=1):
    p = ROOT / path
    s = p.read_text(encoding='utf-8')
    c = s.count(old)
    assert c == n, (path, c, old[:100])
    if path not in touched:
        touched.append(path)
    p.write_text(s.replace(old, new), encoding='utf-8')


def main():
    every = leaf_declarations()
    assert len(every) == N_DECL and len(set(every)) == N_DECL, (len(every), N_DECL)
    assert set(DECLS + WITNESS + [C + 'closureListed_unlisted']) <= set(every), set(ALIASES) - set(every)
    # the root module's bullet
    rep(f'{PKG}/Becoming.lean',
        "  (`Continuity.balancesOn_iff_notGoingOut`). A leaf; balance from conservation on each closure under\n"
        "  the adjacency (the `«所闭»` form) is not shown.\n",
        "  (`Continuity.balancesOn_iff_notGoingOut`). Each closure under that adjacency, the grammar's\n"
        "  `«所闭»`, is decided as a test among the listed relata by a counting bound\n"
        "  (`Continuity.closureListed`, `Continuity.closureListed_iff`), and the transfers exist exactly\n"
        "  where the total is conserved on the closure of each listed relatum\n"
        "  (`Continuity.balancing_iff_closures`, on a web `Continuity.balancesOn_iff_closures`; board item\n"
        "  BD4), the uncapacitated, undirected case of the feasibility conditions for flows. At the unit\n"
        "  grain, a pairing under the closure of a symmetric relation whose closure a test decides is the\n"
        "  count kept on each closure (`Continuity.pairing_iff_closure_counts`), a case of\n"
        "  `«类之对当且仅当类类等数»`; along the listed adjacency, on the closure of each relatum, listed or\n"
        "  not (`Continuity.pairing_iff_closures`). So, the levels read as units on their relata, each\n"
        "  listed relatum repeated as often as its level (`Continuity.unitsOn`), the transfers exist exactly\n"
        "  where the units before pair one to one with the units after under the closure\n"
        "  (`Continuity.balancing_iff_units_paired`), though not always along one step of the adjacency\n"
        "  (`Continuity.PathOfThree.counts_kept_not_along_step`). A leaf.\n")
    # the checker's scope
    rep(f'{PKG}/check_becoming.py',
        "    \"conserved on every region not gone out of along that adjacency, and on a web at every step likewise. \"\n",
        "    \"conserved on every region not gone out of along that adjacency, and on a web at every step likewise; \"\n"
        "    \"each closure under that adjacency, the grammar's «所闭», is decided as a test by a counting bound, and \"\n"
        "    \"the transfers exist exactly where the total is conserved on the closure of each listed relatum, and \"\n"
        "    \"exactly where the levels, read as units on their relata, pair one to one, before with after, under \"\n"
        "    \"the closure; at the unit grain a pairing under the closure of a symmetric relation whose closure a \"\n"
        "    \"test decides is the count kept on each closure, a case of the count law of a class. \"\n")
    # both README rows
    rep(f'{PKG}/README.md',
        "and on a web at every step likewise (`Continuity.balancesOn_iff_notGoingOut`); a leaf |",
        "and on a web at every step likewise (`Continuity.balancesOn_iff_notGoingOut`); each closure under that "
        "adjacency, the grammar's `«所闭»`, decided as a test (`Continuity.closureListed_iff`), and the transfers "
        "existing exactly where the total is conserved on the closure of each listed relatum "
        "(`Continuity.balancing_iff_closures`, on a web `Continuity.balancesOn_iff_closures`) and exactly where the "
        "levels, read as units on their relata (`Continuity.unitsOn`), pair one to one, before with after, under "
        "the closure (`Continuity.balancing_iff_units_paired`); at the unit grain, a pairing under the closure is the count kept "
        "on the closure of each relatum, listed or not, a case of `«类之对当且仅当类类等数»` "
        "(`Continuity.pairing_iff_closures`); a leaf |")
    rep(f'{PKG}/README.zh.md',
        "依存网上每步亦然（`Continuity.balancesOn_iff_notGoingOut`）；为叶模块 |",
        "依存网上每步亦然（`Continuity.balancesOn_iff_notGoingOut`）；此相邻下每个闭包（文法之 `«所闭»`）可判定为一"
        "检验（`Continuity.closureListed_iff`），而转移恰在总量于每个所列关系项之闭包上守恒处存在"
        "（`Continuity.balancing_iff_closures`，依存网上为 `Continuity.balancesOn_iff_closures`），亦恰在各水平读作其关系项"
        "上之单位（`Continuity.unitsOn`）、前后于闭包下一一成对处存在（`Continuity.balancing_iff_units_paired`）；在单位之粒度上，闭包下之配对即每个关系项"
        "（无论列出与否）之闭包上计数相守，为 `«类之对当且仅当类类等数»` 之一例（`Continuity.pairing_iff_closures`）；"
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
                     'decided as a test, iff the levels, read as units on their relata, pair under the closure (BD4)')
    touched.append(rpath)
    p.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    # the record
    p = ROOT / REC
    old_text = p.read_text(encoding='utf-8')
    assert json.dumps(json.loads(old_text), ensure_ascii=False, indent=2) + '\n' == old_text, 'record does not round-trip'
    r = json.loads(old_text)
    assert len(r['laws']) == 7, len(r['laws'])
    law = {'en': ("With equality decided, each relatum's closure under the listed adjacency, «所闭», is decided by a "
                  "test and is the least family the relation closes holding it. So, relata listed without repetition, "
                  "transfers along the relation balancing a step exist exactly where the total is conserved on each "
                  "listed relatum's closure, equivalently where the levels read as units on their relata pair one to "
                  "one, before with after, under the closure; on a web, at every step likewise."),
           'zh': ("关系项之相等可判定时，所列相邻下每个关系项之闭包（«所闭»）可判定为一检验，且为关系所封闭、含此项之最小家族。"
                  "故关系项不重复列出时，沿关系使一步平衡的转移，恰在总量于每个所列关系项之闭包上守恒时存在，亦即恰在各水平读作"
                  "其关系项上之单位、前后于闭包下一一成对时存在；网在每一步亦然。"),
           'declarations': DECLS}
    # the cap on a law warns (tools/research/style.py); the record's laws run to 475 characters
    print('law 8:', len(law['en']), 'en,', len(law['zh']), 'zh (soft caps 420/190)')
    assert len(law['en']) <= 475 and len(law['zh']) <= 190, (len(law['en']), len(law['zh']))
    r['laws'].append(law)
    hyp = r['hypotheses'][0]
    old_h = ('Finitely many relata listed without repetition; equality of relata decided and the relation a Bool test, '
             'so the transfers are computed; levels are whole numbers.')
    assert hyp['en'] == old_h, hyp['en']
    assert hyp['zh'] == '有限多个不重复列出的关系项；关系项的相等可判定，关系是布尔检验，故转移可计算；水平是整数。', hyp['zh']
    hyp['en'] = ('Finitely many relata listed without repetition; equality of relata decided, a modelling hypothesis, '
                 'and the relation a Bool test, so the transfers and the closures are computable; levels are whole numbers.')
    hyp['zh'] = '有限多个不重复列出的关系项；关系项的相等可判定（建模假设），关系是布尔检验，故转移与闭包可计算；水平是整数。'
    dns = r['does_not_show']
    assert len(dns) == 6 and dns[5]['en'].startswith('That conservation on each closure'), dns[5]
    dns.pop()
    dns.append({
        'en': ("Transfers within capacities: conservation on each closure is the uncapacitated, undirected case of the "
               "feasibility conditions of Gale (1957) and Hoffman (1960); their capacitated case is not stated."),
        'zh': "容量之内的转移：每个闭包上的守恒是 Gale（1957）与 Hoffman（1960）可行性条件的无容量、无向情形；有容量情形未陈述。",
        'kind': 'scope'})
    dns.append({
        'en': ("That counts kept on each closure give a pairing along one step of the adjacency: on the path "
               "0 — 1 — 2, [0] and [2] keep every closure's count and no step joins 0 to 2, as an amount may pass "
               "through a relatum within the step."),
        'zh': ("每个闭包计数相守即给出沿相邻一步之配对：在路径 0 — 1 — 2 上，[0] 与 [2] 在每个闭包上计数相守，而无一步连接 "
               "0 与 2，正如一量可在一步内经过一个关系项。"),
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
                f'{N_DECL} declarations ({N_THM} theorems), each with an empty axiom report, decided equality taken '
                'as an argument: an instance supplied at use carries its own report. No independent review of '
                'Becoming.Continuity; Becoming.BalanceRegions and its two laws read by independent AI readers, every '
                'finding taken.')
    old_zh = vs['zh']
    assert '20261031T225858.600119Z' in old_zh, old_zh
    vs['zh'] = ('由核心检查器以 Lean 4.29.1 从前奏检查：Becoming.Continuity，64 个声明中 43 条定理；Becoming.BalanceRegions'
                f'（第七、八律），回执 PENDING，{N_DECL} 个声明中 {N_THM} 条定理；公理报告均为空，可判定相等作为参数取入，'
                '使用时所给实例自带其报告。Becoming.Continuity 没有独立审查；Becoming.BalanceRegions 及其两律经独立 AI '
                '读者审读，所提各点皆已采纳。')
    assert len(vs['en']) - 7 + 24 <= 600 and len(vs['zh']) - 7 + 24 <= 260, (len(vs['en']), len(vs['zh']))
    bound = [b for b in r['proof_bindings'] if b['source'] == LEAF]
    assert len(bound) == 1 and '20261031T225858.600119Z' in bound[0]['receipt'], bound
    bound[0]['receipt'] = f'{PKG}/becoming-checks/PENDING/verification.json'
    named = [x for x in r['references'] if x['path'] == LEAF]
    assert len(named) == 1, named
    assert named[0]['declarations'] == every[:len(named[0]['declarations'])], named[0]['declarations']
    named[0]['sha256'] = hashlib.sha256((ROOT / LEAF).read_bytes()).hexdigest()
    named[0]['declarations'] = every
    assert not set(ALIASES) & set(r['aliases']), set(ALIASES) & set(r['aliases'])
    r['aliases'] = r['aliases'] + ALIASES
    corr = r['correspondence']['en']
    old_c = ("Network flows: a flow on a finite graph with prescribed divergence exists exactly where the divergence "
             "sums to zero on each connected component; balancing_iff is that fact stated with the spine's families "
             "and computed.")
    assert corr.count(old_c) == 1, corr
    r['correspondence']['en'] = corr.replace(old_c, (
        "Network flows: a flow on a finite graph with prescribed divergence exists exactly where the divergence "
        "sums to zero on each connected component, the uncapacitated, undirected case of the feasibility conditions "
        "of Gale (1957) for supplies and demands and, through the usual reduction to a circulation, of Hoffman "
        "(1960); balancing_iff is that fact stated with the spine's families and computed, balancing_iff_closures "
        "states it on each component, the grammar's «所闭» along the listed adjacency, and "
        "balancing_iff_units_paired is the closure-local reading of Flow.balances_iff_units, the closure taking "
        "the place of the transfers; it reads only the counts on each closure, so it derives no balance from the "
        "unfolding."))
    assert len(r['correspondence']['en']) <= 1200, len(r['correspondence']['en'])
    assert not any(x['id'] == 'amounts-by-unit-matchings' for x in r['related']), r['related']
    r['related'].append({'id': 'amounts-by-unit-matchings', 'detail': {
        'en': ("There balance is represented by selected matchings of units, given as data, not derived from the "
               "unfolding, and Flow.balances_iff_units pairs a flow's units at one condition under the one, with what "
               "is given and taken among them. Here the levels read as units on their relata pair under each closure "
               "exactly where its count is kept; reading only those counts, this pairing derives no balance from the "
               "unfolding either."),
        'zh': ("那里平衡由所选之单位配对表示，作为数据给出，非自展开推出；Flow.balances_iff_units 于一条件下在一之下配对流之"
               "单位，所给与所取在其中。这里各水平读作其关系项上之单位，恰在每个闭包之计数相守处于其下成对；只读这些计数，"
               "此配对亦不自展开推出平衡。")}})
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
               "(Becoming.BalanceRegions): each closure under the listed adjacency is decided as a test and is the "
               "least family the relation closes holding it, so transfers balancing a step exist exactly where the "
               "total is conserved on each listed relatum's closure, equivalently where the levels read as units on "
               "their relata pair one to one, before with after, under the closure. The sixth item on what is not shown, the «所闭» form, is "
               "replaced by two: capacities, and pairing along one step, with a witness on the path 0 — 1 — 2. Gale "
               "and Hoffman, and the join as the closure-local reading of Flow.balances_iff_units, named in the "
               "correspondence, with a link to amounts-by-unit-matchings; the first hypothesis names decided "
               "equality a modelling hypothesis, and the transfers and the closures computable. No earlier "
               "statement, law or declaration changed."),
        'zh': ("2026年11月1日，工作板条目 BD4：第八律于文法之 «所闭» 上读本记录（Becoming.BalanceRegions）：所列相邻下每个"
               "闭包可判定为一检验，且为关系所封闭、含此项之最小家族，故使一步平衡之转移恰在总量于每个所列关系项之闭包上守恒"
               "时存在，亦即恰在各水平读作其关系项上之单位、前后于闭包下一一成对时存在。所不示者第六项（«所闭» 形式）代之以二项：容量，"
               "与沿一步之配对（以路径 0 — 1 — 2 为证）。对应中写出 Gale 与 Hoffman，并称此合为 Flow.balances_iff_units 之闭包局部读法，"
               "链至 amounts-by-unit-matchings；第一条假设注明可判定相等为建模假设、转移与闭包可计算。"
               "先前之陈述、规律与声明皆未变。")})
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
        "closure of each listed relatum (`Continuity.balancing_iff_closures`), the uncapacitated, undirected case of "
        "the feasibility conditions for flows of Gale and Hoffman. Read at the grain of units, each listed relatum "
        "repeated as often as its level, they exist exactly where the units before pair one to one with the units "
        "after within the closures (`Continuity.balancing_iff_units_paired`), by the count law of a class, though "
        "not always along one step (`Continuity.PathOfThree.counts_kept_not_along_step`). A swap")
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
