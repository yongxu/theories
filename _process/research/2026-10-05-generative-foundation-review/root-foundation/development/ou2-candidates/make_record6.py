#!/usr/bin/env python3
"""OU2c: write the record candidate-theorems-of-the-corpus. usage (from the checkout root): python3 -B make_record6.py SECTION RECEIPT"""
import csv
import collections
import datetime
import hashlib
import json
import sys
from pathlib import Path
ROOT = Path.cwd()
N, RECEIPT = sys.argv[1], sys.argv[2]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
SRC = f'{PKG}/Becoming/GrammarCandidates.lean'
REC = f'{PKG}/becoming-checks/{RECEIPT}/verification.json'
OUT = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou2-candidates/outcomes.tsv'
RID = 'candidate-theorems-of-the-corpus'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()


def sha(p):
    return hashlib.sha256((ROOT / p).read_bytes()).hexdigest()


R = json.loads((ROOT / REC).read_text())
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.GrammarCandidates')
assert R['status'] == 'passed' and not any(mod['axiom_dependencies'].values())
assert R['source_sha256'].get('Becoming.GrammarCandidates') == sha(SRC)
names = {x['name'] for x in mod['declarations']}
bb = {n.replace('«', '').replace('»', ''): n for n in names}
with open(ROOT / OUT, encoding='utf-8') as f:
    rows = list(csv.DictReader(f, delimiter='\t'))
cnt = collections.Counter(r['outcome'] for r in rows)


def d(*xs):
    out = []
    for x in xs:
        f = 'Becoming.' + x
        h = f if f in names else bb.get(f.replace('«', '').replace('»', ''))
        assert h, f
        out.append(h)
    return out


laws = [
    ("Correlatives that are the two ends of one relation, a condition and its result, the goer and the going, are had "
     "together: each exactly where the other is; two independent relations have no such law.",
     "一关系之两端相待（缘与果、去者与去）：各恰在另一有处有；两个独立之关系无此律。",
     d('«能»', '«能所相待»', '«三法相因待»', '«因果互即»', '«二际可偏举»')),
    ("A mark gives its complement a mark; that the complement gives the mark back, for every carrier, is exactly "
     "double-negation stability, and holds for a decided two-valued reading.",
     "有相则非亦有相；自非还于其相，对一切载体成立，恰是双重否定之稳定；对可判定之二值读法成立。",
     d('«有相则非亦有相»', '«相待之还当且仅当双非可还»', '«二值之相待»')),
    ("An occurrence begins under some class and not under another exactly where it is not-not conditioned and is not "
     "its own condition; its own condition abides under every class; everything ends under identity exactly where "
     "nothing is its own condition.",
     "一事在某类下生而在另一类下不生，恰在其非不受缘且不自缘时；自缘者在每一类下皆住；在相等之类下一切皆灭，恰在无物自缘时。",
     d('«定性之判»', '«自缘则常»', '«念念灭当且仅当无自缘»')),
    ("Every condition strictly precedes its result exactly where the net has no cycle, and a cycle of 缘 is one "
     "co-present cluster.",
     "每一缘严格先于其果，恰在网无环时；缘之环为一同时之聚。",
     d('«缘先果后当且仅当无环»', '«俱有»')),
    ("The core is never separated at a finite stage; the converse fails in an infinitely branching net, and holds where "
     "the relation of no separating stage is itself constant.",
     "核在有穷之层永不被分；其逆在无穷分支之网中不成立，而在“无分之层”之关系本身有常时成立。",
     d('«核则不可致诘»', '«致诘不尽»', '«不可致诘而有常则混而为一»')),
]
cited = sorted({x for _, _, ds in laws for x in ds})
rec = {
    "schema_version": 2, "id": RID,
    "title": {"en": "The corpus's candidate theorems of the grammar, tested", "zh": "语料中文法之候选定理之检验"},
    "kind": "theorem", "status": "recorded-checked", "family": "F01", "reviewed_at_utc": NOW,
    "statement": {
        "en": f"Of the first batch's {len(rows)} candidate theorems of the grammar, {cnt['proved']} hold for every carrier "
              f"and relation, {cnt['conditional']} hold only under a premise, {cnt['refuted']} fail; the premises most "
              "often needed are double-negation stability and that nothing is its own condition.",
        "zh": f"第一批 {len(rows)} 个文法之候选定理中，{cnt['proved']} 个对每个载体与关系成立，{cnt['conditional']} 个只在前提下成立，"
              f"{cnt['refuted']} 个不成立；最常需要的前提是双重否定之稳定与无物自缘。"},
    "laws": [{"en": a, "zh": b, "declarations": c} for a, b, c in laws],
    "hypotheses": [{"en": "Each reading of a sentence is an AI reconstruction; the outcome table records what the "
                          "reading loses.", "zh": "每一句之读法是 AI 重构；结果表记录读法所失。"}],
    "does_not_show": [
        {"en": "That the corpus states the grammar: 有無相生 and 四相俱時, the plan's own examples, need a premise, and "
               "several 中论 lines need that nothing is its own condition, which the grammar does not assume.",
         "zh": "语料陈述本文法：计划自己的例子有無相生与四相俱時都需前提，《中论》数句需“无物自缘”，而文法不设之。", "kind": "non-implication"},
        {"en": "That every condition precedes its result: a net may have cycles of 缘.",
         "zh": "每一缘都先于其果：网可有缘之环。", "kind": "scope"}],
    "counterexamples": [{"path": SRC, "detail": {
        "en": "An infinitely branching net where no finite stage separates two occurrences outside one core class "
              "(«致诘不尽»).",
        "zh": "无穷分支之网：有穷之层不分两事，而二者不在一核类（«致诘不尽»）。"}}],
    "standard_boundaries": ["no-ethical-premise", "formal-not-empirical"],
    "validation_scope": {
        "en": f"Checked by the core checker with Lean 4.29.1 from the prelude: Becoming.GrammarCandidates, {mod['theorems']} "
              f"theorems in {len(mod['declarations'])} declarations, each with an empty axiom report. Written by an Opus "
              "coder from the first-batch classification; no human audit of the readings.",
        "zh": f"由核心检查器以 Lean 4.29.1 从前奏检查：Becoming.GrammarCandidates，{len(mod['declarations'])} 个声明中 "
              f"{mod['theorems']} 条定理，公理报告皆空。由一位 Opus 编者据第一批分类写成；读法无人审。"},
    "next_delta": {
        "en": "Test the second round's candidates (中论 chapters 10, 17, 19, 24, 成唯识论, 五教章), and decide with the "
              "classical review whether 不自生 is a premise of the texts or a reading of them.",
        "zh": "检验第二轮之候选（中论第十、十七、十九、二十四品，成唯识论，五教章），并与古文审查一同判断“不自生”是文本之前提还是对文本之读。"},
    "correspondence": {"en": f"Outcomes per unit in {OUT}: " + ', '.join(f'{k} {v}' for k, v in sorted(cnt.items())) + "."},
    "canonical_source": SRC, "aliases": cited,
    "dependencies": [{"id": "classical-definitions-in-the-grammar", "relation": "formal-reuse", "detail": {
        "en": "The corpus's definitions in the grammar are the vocabulary the candidates are read in.",
        "zh": "语料之定义写入文法，是读候选之词汇。"},
        "interface": {"output": {"en": "«化», «同于», «复», «通».", "zh": "«化»、«同于»、«复»、«通»。"},
                      "input": {"en": "Candidate sentences of class 乙.", "zh": "乙类之候选句。"},
                      "conditions": {"en": "None beyond the grammar.", "zh": "除文法外无。"}, "evidence": SRC}}],
    "related": [],
    "references": [{"path": SRC, "role": "proof", "sha256": sha(SRC), "declarations": sorted(names)},
                   {"path": REC, "role": "receipt", "sha256": sha(REC)},
                   {"path": OUT, "role": "statement", "sha256": sha(OUT)}],
    "proof_bindings": [{"source": SRC, "receipt": REC, "sha256_pointer": "/source_sha256/Becoming.GrammarCandidates",
                        "success_pointer": "/status", "success_value": "passed"}],
    "history": [{
        "en": f"23 October 2026, board item OU2c (study section {N}): the first batch's class-乙 units tested in Lean.",
        "zh": f"2026年10月23日，工作板条目 OU2c（研究第 {N} 节）：第一批乙类单元在 Lean 中检验。"}],
}
for law in rec['laws']:
    assert len(law['en']) <= 420 and len(law['zh']) <= 190
(ROOT / 'theories/becoming/results/records' / f'{RID}.json').write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('wrote', RID, len(cited), 'of', len(names), dict(cnt))
