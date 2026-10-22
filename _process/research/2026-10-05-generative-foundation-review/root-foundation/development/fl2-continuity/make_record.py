#!/usr/bin/env python3
"""FL2: write the record balance-from-conservation-along-a-relation bound to the core receipt, and relate FL1's record
balance-from-the-first-law to it with one history note.
usage (from the checkout root): python3 -B make_record.py STUDY_SECTION RECEIPT"""
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
N, RECEIPT = sys.argv[1], sys.argv[2]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
SRC = f'{PKG}/Becoming/Continuity.lean'
REC = f'{PKG}/becoming-checks/{RECEIPT}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'balance-from-conservation-along-a-relation'
C = 'Becoming.Continuity.'
NOW = '2026-10-22T18:00:00+00:00'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


R = json.loads((ROOT / REC).read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Continuity')
assert not any(mod['axiom_dependencies'].values())
names = {d['name'] for d in mod['declarations']}


def d(*xs):
    out = [C + x for x in xs]
    missing = [x for x in out if x not in names]
    assert not missing, missing
    return out


laws = [
    ("A family is a test on the relata and the part of a quantity on it its value there; two relata are adjacent where "
     "the relation holds one way or the other, and a family is closed where no two adjacent listed relata lie one in it "
     "and one outside. Transfers balance a step along the relation where something moves only between adjacent listed "
     "relata and each listed relatum's level after, with what it sends, is its level before, with what it receives.",
     "家族是关系项上的一个检验，量在其上的部分是它在那里的值；关系一方或另一方成立时两个关系项相邻；没有两个相邻的列出关系项一在其内一在其外时，"
     "家族封闭。只在相邻的列出关系项之间移动、且每个列出关系项步后的水平加其所送等于步前的水平加其所收时，转移沿关系使一步平衡。",
     d('adj', 'adj_symm', 'within', 'within_add', 'Closes', 'ConservedOn', 'Balancing')),
    ("Transfers along the relation that balance a step conserve the total on every family the relation closes: what "
     "moves inside the family is counted once sent and once received.",
     "沿关系使一步平衡的转移，在关系封闭的每个家族上守恒总量：家族内移动的，送出计一次，收到计一次。",
     d('inside', 'within_sent', 'within_received', 'conserved_of_balancing')),
    ("Over relata listed without repetition, with equality decided and the relation a computable test, wherever the "
     "total is conserved on every closed family the routed transfers balance the step along the relation: one relatum "
     "at a time, its change is exchanged with the first relatum adjacent to it, and the rest are routed with its "
     "neighbours taken as adjacent, their moves passing through it. So such transfers exist exactly where the total is "
     "conserved on every closed family.",
     "在不重复列出的关系项上，相等可判定、关系是可计算的检验时，凡总量在每个封闭家族上守恒，经路由的转移就沿关系使一步平衡："
     "每次取一个关系项，其变化与第一个与之相邻者交换，其余者以其邻居为相邻而路由，其移动经过它。故这样的转移恰在总量于每个封闭家族上守恒时存在。",
     d('joined', 'direct', 'via', 'edge', 'expand', 'route', 'route_cons', 'conservedOn_rest', 'kept_alone',
       'route_balancing', 'balancing_iff')),
    ("A law whose next level at a listed relatum is the same from two configurations agreeing there and at every listed "
     "relatum adjacent to it, and which conserves the total from every configuration, conserves it on every family the "
     "relation closes.",
     "下一步水平在一个列出关系项上，对在它和每个与之相邻的列出关系项上一致的两个配置相同，且从每个配置守恒总量的规律，在关系封闭的每个家族上守恒总量。",
     d('ReadsAdjacent', 'Conserves', 'conservedOn_of_law')),
    ("Read as a flow in which each relatum takes from a condition what moves from it to the relatum and gives what moves "
     "back, transfers along the relation balancing a web's levels on the listed relata at every step exist exactly where "
     "the levels are conserved on every closed family at every step; with every relatum listed the routed flow balances "
     "the web, and every run of a law reading only adjacent relata and conserving the total balances.",
     "读作一个流（每个关系项从一个条件取走从它移到该关系项的，并给回反向移动的），沿关系、在每一步使网在列出关系项上的水平平衡的转移，"
     "恰在水平于每一步在每个封闭家族上守恒时存在；列出全部关系项时，经路由的流使网平衡；只读相邻关系项、守恒总量的规律，其每次运行都平衡。",
     d('flow', 'routed', 'balancesOn_iff_conserved', 'balances_of_conserved', 'balancesOn_of_law')),
    ("Teleport: swapping the levels of two relata conserves the total from every configuration and reads both. Along the "
     "empty relation each relatum alone is a closed family and the swap moves one unit out of it, so no transfers along "
     "it balance the swap; along the full relation the routed transfers balance it.",
     "Teleport：交换两个关系项的水平，从每个配置守恒总量，并读两者。沿空关系，每个关系项自身是封闭家族，交换把一个单位移出，故没有沿它的转移"
     "使交换平衡；沿完全关系，经路由的转移使它平衡。",
     d('Teleport.all', 'Teleport.distinct', 'Teleport.swap', 'Teleport.apart', 'Teleport.together',
       'Teleport.conserves', 'Teleport.reads', 'Teleport.unit', 'Teleport.no_transfers_apart',
       'Teleport.balanced_together')),
]
cited = sorted({x for _, _, ds in laws for x in ds})
alldecl = sorted(names)
rec = {
    "schema_version": 2,
    "id": RID,
    "title": {"en": "Balance from conservation along a relation", "zh": "沿关系的守恒给出的平衡"},
    "kind": "theorem", "status": "recorded-checked", "family": "F01", "reviewed_at_utc": NOW,
    "statement": {
        "en": "Over finitely many relata, transfers between related relata that balance a step exist exactly where the "
              "total is conserved on every family the relation closes, and a law reading only related relata that "
              "conserves its total gives that conservation.",
        "zh": "在有限多个关系项上，只在相关关系项之间移动、使一步平衡的转移，恰在总量于关系封闭的每个家族上守恒时存在；只读相关关系项、守恒总量的规律给出这一守恒。"},
    "laws": [{"en": a, "zh": b, "declarations": c} for a, b, c in laws],
    "hypotheses": [
        {"en": "Finitely many relata listed without repetition; equality of relata decided and the relation a Bool test, "
               "so the transfers are computed; levels are whole numbers.",
         "zh": "有限多个不重复列出的关系项；关系项的相等可判定，关系是布尔检验，故转移可计算；水平是整数。"},
        {"en": "For the law: its next level at a listed relatum reads only that relatum and the listed relata adjacent "
               "to it, and it conserves the total from every configuration, the configuration with nothing anywhere "
               "included.",
         "zh": "对规律：它在一个列出关系项上的下一步水平只读该关系项及与之相邻的列出关系项，且从每个配置守恒总量，包括处处为零的配置。"}],
    "does_not_show": [
        {"en": "That the flux is local: the routed transfers depend on the whole configuration, as the lattice results "
               "of Hattori and Takesue and of Pivato do not.",
         "zh": "通量是局部的：经路由的转移依赖整个配置，而 Hattori 与 Takesue、Pivato 在格点上的结果则不然。", "kind": "scope"},
        {"en": "That a transfer stays within what stands on its source: an amount may pass through a relatum within the "
               "step.",
         "zh": "转移不超过其来源上所立者：一个量可在一步内经过一个关系项。", "kind": "scope"},
        {"en": "That conservation of the whole total gives balance along a relation: it does not where the relation "
               "does not join where the amount moves.",
         "zh": "整体总量的守恒给出沿关系的平衡：关系不连接量移动之处时就不给出。", "kind": "non-implication",
         "witness": C + "Teleport.no_transfers_apart"},
        {"en": "That balance holds of every dynamics: conservation on closed families is the content and fails where a "
               "law creates or destroys the quantity.",
         "zh": "平衡对每个动力学都成立：封闭家族上的守恒是内容，规律产生或毁灭该量处它就不成立。", "kind": "non-implication"},
        {"en": "Infinitely many relata, or a relation that is not decided.",
         "zh": "无限多个关系项，或不可判定的关系。", "kind": "scope"}],
    "counterexamples": [
        {"path": SRC, "detail": {
            "en": "Teleport: the swap conserves the total of two relata and no transfers along the empty relation "
                  "balance it (Continuity.Teleport.no_transfers_apart).",
            "zh": "Teleport：交换守恒两个关系项的总量，而沿空关系没有转移使它平衡（Continuity.Teleport.no_transfers_apart）。"}}],
    "standard_boundaries": ["discrete-steps", "no-evaluation", "no-ethical-premise"],
    "validation_scope": {
        "en": f"Checked by the core checker with Lean 4.29.1 from the prelude: Becoming.Continuity, {mod['theorems']} "
              f"theorems in {len(mod['declarations'])} declarations, each with an empty axiom report. No independent "
              "review.",
        "zh": f"由核心检查器以 Lean 4.29.1 从前奏检查：Becoming.Continuity，{len(mod['declarations'])} 个声明中 "
              f"{mod['theorems']} 条定理，公理报告均为空。没有独立审查。"},
    "next_delta": {
        "en": "A flux chosen local, depending only on the levels near each related pair, for laws that read within a "
              "bounded neighbourhood, as for cellular automata on lattices; and transfers within what stands on their "
              "source where the law moves units, as particle displacements do.",
        "zh": "对只在有界邻域内读取的规律，选取局部的通量（只依赖每对相关关系项附近的水平），如格点上的元胞自动机；以及在规律移动单位处，"
              "不超过来源所立者的转移，如粒子位移表示。"},
    "correspondence": {
        "en": "Network flows: a flow on a finite graph with prescribed divergence exists exactly where the divergence "
              "sums to zero on each connected component; balancing_iff is that fact stated with the spine's families "
              "and computed. Cellular automata: a conserved additive quantity of a local rule on a lattice has a flux "
              "depending on a finite window (Hattori and Takesue 1991; Pivato 2002, Proposition 12), and number-"
              "conserving rules have particle-displacement representations in one dimension (Fukś 2000; Moreira, "
              "Boccara and Goles 2004) and two (Kari and Taati 2008). Physics: the continuity equation of a locally "
              "conserved quantity, of which FL1's first law with locality is the energy case."},
    "canonical_source": SRC,
    "aliases": cited,
    "dependencies": [
        {"id": "balance-from-the-first-law", "relation": "interpretive", "detail": {
            "en": "FL1 reads balance as the first law with locality, stating locality as one transfer per exchange and "
                  "store; here the transfers are derived from conservation on every closed family, and locality is "
                  "a property of the law.",
            "zh": "FL1 把平衡读作带局部性的第一定律，把局部性陈述为每对交换与储存一个转移；这里转移由每个封闭家族上的守恒推出，局部性是规律的性质。"}}],
    "related": [
        {"id": "premises-read-off-the-exchange", "detail": {
            "en": "There balance holds by reading a world off an exchange, with the rest counted; here balance along a "
                  "given relation is equivalent to conservation on the families it closes.",
            "zh": "那里平衡因把世界读自交换（计入其余）而成立；这里沿给定关系的平衡等价于它所封闭的家族上的守恒。"}}],
    "references": [
        {"path": SRC, "role": "proof", "sha256": sha(SRC), "declarations": alldecl},
        {"path": REC, "role": "receipt", "sha256": sha(REC)},
        {"path": f'{PKG}/Becoming/Flow.lean', "role": "statement", "sha256": sha(f'{PKG}/Becoming/Flow.lean'),
         "declarations": ["Becoming.Flow.Balances", "Becoming.Flow.BalancesOn", "Becoming.Flow.taken",
                          "Becoming.Flow.given"]}],
    "proof_bindings": [{"source": SRC, "receipt": REC, "sha256_pointer": "/source_sha256/Becoming.Continuity",
                        "success_pointer": "/status", "success_value": "passed"}],
    "history": [{
        "en": f"22 October 2026, board item FL2 (study section {N}): added after FL1, for the question whether balance "
              "can be more than a premise about transfers; the literature on conserved quantities of cellular "
              "automata checked first.",
        "zh": f"2026年10月22日，工作板条目 FL2（研究第 {N} 节）：继 FL1 之后，为“平衡能否不止是关于转移的前提”之问而加；先查了元胞自动机守恒量的文献。"}],
}
assert R['source_sha256'].get('Becoming.Continuity') == sha(SRC), 'receipt does not bind the current source'
(RECORDS / f'{RID}.json').write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('wrote', RID, len(cited), 'cited of', len(alldecl))

p = RECORDS / 'balance-from-the-first-law.json'
fl1 = json.loads(p.read_text())
if not any(r['id'] == RID for r in fl1['related']):
    fl1['related'].append({"id": RID, "detail": {
        "en": "Locality, stated here as one transfer per exchange and store, is derived there: transfers along a "
              "relation balancing a step exist exactly where the total is conserved on every family it closes.",
        "zh": "这里陈述为每对交换与储存一个转移的局部性，在那里被推出：沿关系使一步平衡的转移，恰在总量于其封闭的每个家族上守恒时存在。"}})
    fl1['history'].append({
        "en": f"22 October 2026, FL2 (study section {N}): related to balance-from-conservation-along-a-relation, which "
              "derives the transfers this record assumes. The claim is unchanged.",
        "zh": f"2026年10月22日，FL2（研究第 {N} 节）：关联 balance-from-conservation-along-a-relation，它推出本记录所假设的转移。论断不变。"})
    fl1['reviewed_at_utc'] = NOW
    p.write_text(json.dumps(fl1, ensure_ascii=False, indent=2) + '\n')
    print('related FL1')
