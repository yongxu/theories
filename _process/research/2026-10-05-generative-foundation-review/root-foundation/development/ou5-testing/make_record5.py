#!/usr/bin/env python3
"""OU5: write the record testing-within-the-net. usage (from the checkout root): python3 -B make_record5.py SECTION RECEIPT"""
import datetime
import hashlib
import json
import sys
from pathlib import Path
ROOT = Path.cwd()
N, RECEIPT = sys.argv[1], sys.argv[2]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
SRC = f'{PKG}/Becoming/GrammarTesting.lean'
REC = f'{PKG}/becoming-checks/{RECEIPT}/verification.json'
RID = 'testing-within-the-net'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()


def sha(p):
    return hashlib.sha256((ROOT / p).read_bytes()).hexdigest()


R = json.loads((ROOT / REC).read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.GrammarTesting')
assert not any(mod['axiom_dependencies'].values()) and R['source_sha256'].get('Becoming.GrammarTesting') == sha(SRC)
names = {x['name'] for x in mod['declarations']}
bb = {n.replace('«', '').replace('»', ''): n for n in names}


def d(*xs):
    out = []
    for x in xs:
        f = 'Becoming.' + x
        h = f if f in names else bb.get(f.replace('«', '').replace('»', ''))
        assert h, f
        out.append(h)
    return out


laws = [
    ("The core of a class is approximated by stages: stage zero is the class, and at the next stage each step from "
     "either end is matched by a step from the other at the stage before. The core lies in every stage, so what a "
     "finite stage tells apart is not in the core.",
     "类之核以层逼近：第零层即类；下一层要求自任一端之每一步，都有自另一端之一步在前一层与之相配。核在每一层之内，故有穷之层所分者不在核中。",
     d('«层»', '«核在每层之内»', '«可分则不在核»')),
    ("A room in balance and a room held by a thermostat share a core class of 'warm or not' while no window opens; "
     "with the window's opening in the net, the balanced room's cooling has no warm match from the held room, and "
     "the first stage tells them apart.",
     "平衡之室与恒温之室，在不开窗时同属“暖与否”之一核类；开窗入网后，平衡之室之变冷在恒温之室无暖者相配，第一层即分之。",
     d('Room', 'Room.closed', 'Room.opened', 'Room.warm', 'Room.alike', 'Room.same', 'Room.same_alike',
       'Room.same_symm', 'Room.same_constant', '«恒温与平衡»')),
]
cited = sorted({x for _, _, ds in laws for x in ds})
rec = {
    "schema_version": 2, "id": RID,
    "title": {"en": "Testing within the net", "zh": "网内之验"},
    "kind": "theorem", "status": "recorded-checked", "family": "F01", "reviewed_at_utc": NOW,
    "statement": {
        "en": "What a finite stage of approximation tells apart is not in the core of a class, and a wider net tells "
              "apart what a narrower one does not, with no intervener outside the net.",
        "zh": "有穷之逼近层所分者不在类之核中；较宽之网分较窄之网所不分者，而网外无干预者。"},
    "laws": [{"en": a, "zh": b, "declarations": c} for a, b, c in laws],
    "hypotheses": [{"en": "None beyond the grammar.", "zh": "除文法外无前提。"}],
    "does_not_show": [
        {"en": "That what no finite stage tells apart is in the core: that is the Hennessy-Milner direction, which needs "
               "finitely many successors and implies LLPO in its limit form.",
         "zh": "无有穷之层所分者在核中：那是 Hennessy-Milner 之向，要求有穷多后继，其极限形式蕴涵 LLPO。", "kind": "converse"},
        {"en": "That the open window happens: the wider net is a net of possibilities, and the comparison is "
               "counterfactual.",
         "zh": "开窗确有其事：较宽之网是可能之网，此比较是反事实的。", "kind": "scope"}],
    "counterexamples": [{"path": SRC, "detail": {
        "en": "The balanced and the held room: one core class under the closed net, told apart under the opened net "
              "(«恒温与平衡»).",
        "zh": "平衡与恒温之室：闭网下同属一核类，开网下分（«恒温与平衡»）。"}}],
    "standard_boundaries": ["no-ethical-premise", "formal-not-empirical"],
    "validation_scope": {
        "en": f"Checked by the core checker with Lean 4.29.1 from the prelude: Becoming.GrammarTesting, {mod['theorems']} "
              f"theorems in {len(mod['declarations'])} declarations, each with an empty axiom report. No independent review.",
        "zh": f"由核心检查器以 Lean 4.29.1 从前奏检查：Becoming.GrammarTesting，{len(mod['declarations'])} 个声明中 {mod['theorems']} "
              "条定理，公理报告皆空。无独立审查。"},
    "next_delta": {
        "en": "State the converse for nets with finitely many successors as a calibration in the core, and testing "
              "equivalence relative to a stated family of observation relations within the net.",
        "zh": "在核心中为有穷多后继之网陈述其逆为标定；并陈述相对于网内一组观察关系之检验等价。"},
    "correspondence": {
        "en": "Stages of bisimulation and the Hennessy-Milner theorem (Hennessy and Milner 1985); intervention in "
              "structural causal models (Pearl 2000) read here as comparison within a wider net."},
    "canonical_source": SRC, "aliases": cited,
    "dependencies": [{"id": "continuation-relative-to-a-class", "relation": "formal-reuse", "detail": {
        "en": "The core, its root theorem and the pointwise form of constancy are the grammar's.",
        "zh": "核、根定理与有常之逐点形式皆出自文法。"},
        "interface": {"output": {"en": "«核», «根», «有常之逐点».", "zh": "«核»、«根»、«有常之逐点»。"},
                      "input": {"en": "Two nets on one carrier, one wider.", "zh": "同一载体上的两网，其一较宽。"},
                      "conditions": {"en": "None beyond the grammar.", "zh": "除文法外无。"}, "evidence": SRC}}],
    "related": [],
    "references": [{"path": SRC, "role": "proof", "sha256": sha(SRC), "declarations": sorted(names)},
                   {"path": REC, "role": "receipt", "sha256": sha(REC)}],
    "proof_bindings": [{"source": SRC, "receipt": REC, "sha256_pointer": "/source_sha256/Becoming.GrammarTesting",
                        "success_pointer": "/status", "success_value": "passed"}],
    "history": [{
        "en": f"23 October 2026, board item OU5 (study section {N}): 验 of the one-unfolding plan, the root theorem's one "
              "direction and the thermostat case read within the net.",
        "zh": f"2026年10月23日，工作板条目 OU5（研究第 {N} 节）：一元计划之验，根定理之一向与恒温之例在网内读之。"}],
}
(ROOT / 'theories/becoming/results/records' / f'{RID}.json').write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('wrote', RID, len(cited), 'of', len(names))
