#!/usr/bin/env python3
"""OU4: write the record generation-and-degeneration-at-two-grains bound to the core receipt.
usage (from the checkout root): python3 -B make_record3.py STUDY_SECTION RECEIPT"""
import datetime
import hashlib
import json
import sys
from pathlib import Path
ROOT = Path.cwd()
N, RECEIPT = sys.argv[1], sys.argv[2]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
SRC = f'{PKG}/Becoming/GrammarMap.lean'
REC = f'{PKG}/becoming-checks/{RECEIPT}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'generation-and-degeneration-at-two-grains'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
PLAN = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/PLAN.md'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


R = json.loads((ROOT / REC).read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.GrammarMap')
assert not any(mod['axiom_dependencies'].values())
assert R['source_sha256'].get('Becoming.GrammarMap') == sha(SRC)
names = {x['name'] for x in mod['declarations']}
by_bare = {n.replace('«', '').replace('»', ''): n for n in names}


def d(*xs):
    out = []
    for x in xs:
        f = 'Becoming.' + x
        hit = f if f in names else by_bare.get(f.replace('«', '').replace('»', ''))
        assert hit, f
        out.append(hit)
    return out


laws = [
    ("A carrying renewal, read at a fine class of parts and a coarse class of the pattern they make up, continues the "
     "pattern from one occurrence to the next while a part begins there; it is an alteration (火传).",
     "传：以部分之细类与其所成样式之粗类同读，样式自一事续至下一事，而一部分在下一事始；传即异（火传）。",
     d('«传»', '«传则异»', '«所及»', '«所及之传递»')),
    ("Generation (the pattern's line never ends and a carrying renewal lies ahead of every point), keeping (it never "
     "ends and from some point stops renewing) and degeneration (it ends) exclude each other; with excluded middle "
     "they cover every point. Generation holds along its line and degeneration reaches back along it.",
     "生成（样式之线不终，每一点之前方都有传）、守（不终，自某点起不再传）、退化（终）两两不并；有排中律时覆盖每一点。生成沿其线成立，退化沿其线向前传。",
     d('«生成»', '«守»', '«退化»', '«生成退化不并»', '«生成守不并»', '«守退化不并»', '«三域之周»', '«生成之所及亦生成»',
       '«退化之所前亦退化»')),
    ("Each region is inhabited: an endless chain generates under the one with identity as the parts' class, a still "
     "pattern keeps, a short life degenerates; and the short life renews and still ends, so renewal does not decide "
     "the region.",
     "每一域都有实例：无尽之链在“一”下以相等为部分之类而生成；静止之样式守；短命者退化；短命者复生而仍终，故复生不定其域。",
     d('«新而终»', 'Map.step', 'Map.step_irrefl', 'Map.Endless.generation', 'Map.still', 'Map.Still.keeping',
       'Map.short', 'Map.short_end', 'Map.Short.degeneration', 'Map.Short.renews_and_ends')),
    ("A coarse class constant under 缘 never degenerates from a continued point, so what degenerates has a coarse class "
     "that is not constant. Telling generation from degeneration on every line, in every model, is exactly excluded "
     "middle. A chain of classes reads generation at every order, and generation at an order keeps the next order's "
     "line from degenerating.",
     "对缘有常之粗类，自有前之点不退化；故退化者其粗类不有常。在一切模型的每条线上分辨生成与退化，恰是排中律。一串类在每一阶读生成，某阶之生成使上一阶之线不退化。",
     d('«有常则不退化»', '«退化则粗不有常»', '«生败之定当且仅当排中»', '«阶生成»', '«阶生成则上不退化»')),
]
cited = sorted({x for _, _, ds in laws for x in ds})
rec = {
    "schema_version": 2, "id": RID,
    "title": {"en": "Generation, keeping and degeneration at two grains", "zh": "两种粒度下的生成、守与退化"},
    "kind": "theorem", "status": "recorded-checked", "family": "F01", "reviewed_at_utc": NOW,
    "statement": {
        "en": "Read at a fine and a coarse class, generation, keeping and degeneration exclude each other and, where "
              "decided, cover every point; renewal does not decide the region, and telling generation from "
              "degeneration on every line is exactly excluded middle.",
        "zh": "以细类与粗类同读，生成、守、退化两两不并，可判定处覆盖每一点；复生不定其域；在每条线上分辨生成与退化恰是排中律。"},
    "laws": [{"en": a, "zh": b, "declarations": c} for a, b, c in laws],
    "hypotheses": [
        {"en": "None beyond the grammar: every carrier, every relation read as 缘, a fine and a coarse class; the "
               "covering law takes excluded middle as a hypothesis.",
         "zh": "除文法外无前提：每个载体、读作缘的每个关系、一个细类与一个粗类；覆盖之律以排中律为假设。"}],
    "does_not_show": [
        {"en": "That generation here is the 生生 of life in the whole: it is the continuation of a pattern through renewal "
               "of its parts, with no premise on what the pattern is or whether its going on is good.",
         "zh": "此处之生成即全体之生命的生生：它只是样式经其部分之更新而延续，对样式为何、其延续是否为善没有前提。", "kind": "correspondence"},
        {"en": "That the regions are decided: on a given line, whether the pattern goes on is in general not decided.",
         "zh": "诸域可判定：在一条给定的线上，样式是否继续，一般不可判定。", "kind": "non-implication",
         "witness": d('«生败之定当且仅当排中»')[0]},
        {"en": "That renewal is generation: a line can renew and still end.",
         "zh": "复生即生成：一条线可复生而仍终。", "kind": "non-implication",
         "witness": d('Map.Short.renews_and_ends')[0]}],
    "counterexamples": [{"path": SRC, "detail": {
        "en": "A short life of two occurrences renews (its second occurrence begins a new part) and ends "
              "(Map.Short.renews_and_ends).",
        "zh": "两事之短命：复生（其第二事始一新部分）而终（Map.Short.renews_and_ends）。"}}],
    "standard_boundaries": ["no-ethical-premise", "no-evaluation", "formal-not-empirical"],
    "validation_scope": {
        "en": f"Checked by the core checker with Lean 4.29.1 from the prelude: Becoming.GrammarMap, {mod['theorems']} "
              f"theorems in {len(mod['declarations'])} declarations, each with an empty axiom report. No independent "
              "review of this module.",
        "zh": f"由核心检查器以 Lean 4.29.1 从前奏检查：Becoming.GrammarMap，{len(mod['declarations'])} 个声明中 {mod['theorems']} "
              "条定理，公理报告皆空。本模块无独立审查。"},
    "next_delta": {
        "en": "State the old map's regimes (renewal, consumption, capture, the five questions of 势) as regions of this "
              "map on the old base's readings, and the meta-attractor's reading of selection at the coarse grain.",
        "zh": "把旧地图的诸态（更新、消耗、捕获、势之五问）在旧基底之读上陈述为本地图之域，并给出元吸引在粗粒度上对选择之读。"},
    "correspondence": {
        "en": "Generation as a pattern continuing through the renewal of its parts is close to autopoiesis (Maturana and "
              "Varela) and to the closure of constraints (Montévil and Mossio 2015), and the two grains to the levels "
              "of Rosas et al. (2024); the decidability calibration matches the old base's LastChange.lpo_iff_settles "
              "in form. Correspondences not proved."},
    "canonical_source": SRC, "aliases": cited,
    "dependencies": [{"id": "continuation-relative-to-a-class", "relation": "formal-reuse", "detail": {
        "en": "Continuation, lines, the positions, constancy and «有常则续不尽» are the grammar's.",
        "zh": "续、线、诸位、有常与 «有常则续不尽» 皆出自文法。"},
        "interface": {"output": {"en": "«续», «相续», «生», «亡», «不穷», «有常则续不尽».", "zh": "«续»、«相续»、«生»、«亡»、«不穷»、«有常则续不尽»。"},
                      "input": {"en": "A fine and a coarse class on one net.", "zh": "同一网上的一个细类与一个粗类。"},
                      "conditions": {"en": "None beyond the grammar.", "zh": "除文法外无。"},
                      "evidence": SRC}}],
    "related": [],
    "references": [
        {"path": SRC, "role": "proof", "sha256": sha(SRC), "declarations": sorted(names)},
        {"path": REC, "role": "receipt", "sha256": sha(REC)},
        {"path": PLAN, "role": "statement", "sha256": sha(PLAN)}],
    "proof_bindings": [{"source": SRC, "receipt": REC, "sha256_pointer": "/source_sha256/Becoming.GrammarMap",
                        "success_pointer": "/status", "success_value": "passed"}],
    "history": [{
        "en": f"23 October 2026, board item OU4 (study section {N}): the map of the one-unfolding plan, generation and "
              "degeneration with the region between them and its boundary, at two grains and at every order.",
        "zh": f"2026年10月23日，工作板条目 OU4（研究第 {N} 节）：一元计划之地图，生成与退化及其间之域与边界，以两种粒度及每一阶读之。"}],
}
for law in rec['laws']:
    assert len(law['en']) <= 420 and len(law['zh']) <= 190, law['en'][:50]
(RECORDS / f'{RID}.json').write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('wrote', RID, len(cited), 'of', len(names))
