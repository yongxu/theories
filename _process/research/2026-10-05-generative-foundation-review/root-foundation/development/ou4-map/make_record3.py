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
imod = next(m for m in R['modules'] if m['module'] == 'Becoming.MapInstances')
assert not any(imod['axiom_dependencies'].values())
ISRC = f'{PKG}/Becoming/MapInstances.lean'
assert R['source_sha256'].get('Becoming.MapInstances') == sha(ISRC)
inames = {x['name'] for x in imod['declarations']}
by_bare = {n.replace('«', '').replace('»', ''): n for n in names}


def d(*xs):
    out = []
    for x in xs:
        f = 'Becoming.' + x
        hit = f if f in names else by_bare.get(f.replace('«', '').replace('»', ''))
        assert hit, f
        out.append(hit)
    return out


def di(*xs):
    out = ['Becoming.' + x for x in xs]
    miss = [x for x in out if x not in inames]
    assert not miss, miss
    return out


laws = [
    ("A carrying renewal, read at a fine class of parts and a coarse class of the pattern they make up, continues the "
     "pattern from one occurrence to the next while a part begins there; it is an alteration (火传).",
     "传：以部分之细类与其所成样式之粗类同读，样式自一事续至下一事，而一部分在下一事始；传即异（火传）。",
     d('«传»', '«传则异»', '«所及»', '«所及之传递»', '«相续之续»')),
    ("On branches: the pattern goes on along some branch or ends on every branch, which exclude each other; going on "
     "along every branch is going on along some. Generation (some branch renews without end), keeping (some branch "
     "goes on without renewal) and degeneration (every branch ends) are read so; degeneration excludes both.",
     "按分支：样式或沿某支而延，或诸支皆尽，二者互斥；诸支皆不穷即某支之延。生成（某支更新不已）、守（某支延而无传）、退化（诸支皆尽）如此读之；退化与二者皆斥。",
     d('«延»', '«尽»', '«延尽不并»', '«不穷则延»', '«尽则非不穷»', '«生成»', '«守»', '«退化»', '«新而尽»', '«生成则延»',
       '«守则延»', '«生成退化不并»', '«守退化不并»')),
    ("Generation and keeping can hold at one point, along different branches: a root whose chain renews at every step "
     "and whose other branch stays still is in both, the mixed region. On a single line, where each occurrence "
     "conditions at most one other, they exclude each other.",
     "生成与守可在一点上沿不同分支同时成立：一根之链每步更新而其另一支静止，即二者皆是，相杂之域。在单行之网中（每事至多为一事之缘），二者互斥。",
     d('Map.Branch', 'Map.fork', 'Map.fork_chain_begins', 'Map.«生守相杂»', '«单行则族含所及»', '«单行则生守不并»')),
    ("The every-branch forms: generation along every branch, keeping along every branch and an end on some branch "
     "exclude each other and, with excluded middle, cover every point; generation holds along its line and an end "
     "reaches back along it; telling them apart on every line is exactly excluded middle.",
     "诸支之形：诸支之生成、诸支之守与某支之终两两互斥，有排中律时覆盖每一点；生成沿其线成立，终沿其线向前传；在每条线上分辨它们恰是排中律。",
     d('«全生成»', '«全守»', '«有终»', '«新而有终»', '«全生成有终不并»', '«全生成全守不并»', '«全守有终不并»',
       '«全三域之周»', '«全生成之所及亦全生成»', '«有终之所前亦有终»', '«全生有终之定当且仅当排中»')),
    ("Each region is inhabited (an endless chain generates, a still pattern keeps, a short life ends on every branch), "
     "and the short life renews and still ends, so renewal does not decide the region. Telling going on from ending "
     "at every point, in every model, is exactly excluded middle.",
     "每一域都有实例（无尽之链生成，静止之样式守，短命者诸支皆尽）；短命者复生而仍尽，故复生不定其域。在一切模型的每一点分辨延与尽，恰是排中律。",
     d('Map.step', 'Map.step_irrefl', 'Map.Endless.generation', 'Map.Endless.generates', 'Map.still',
       'Map.Still.keeping', 'Map.Still.keeps', 'Map.short', 'Map.short_end', 'Map.Short.degeneration', 'Map.Short.ends',
       'Map.Short.renews_and_ends', 'Map.Short.renews_and_ends_everywhere', '«延尽之定当且仅当排中»')),
    ("A coarse class constant under 缘 has no end from a continued point, so what ends after a continued step has a "
     "coarse class that is not constant. A chain of classes reads generation at every order, and generation at an "
     "order keeps the next order's pattern from ending on every branch.",
     "对缘有常之粗类，自有前之点无终；故有前而终者，其粗类不有常。一串类在每一阶读生成，某阶之生成使上一阶之样式不诸支皆尽。",
     d('«有常则无终»', '«有终则粗不有常»', '«阶全生成»', '«阶全生成则上无终»', '«阶生成»', '«阶生成则上不退化»')),
    ("On the old base (occurrences: a step and a formation): carrying renewal steps into a formation that did not "
     "carry on as itself; under passing, generation makes carriers arise arbitrarily late; by names nothing "
     "generates; consumption held, a family drawn beyond renewal and stopped passing refute going on every branch; "
     "the relay renews and ends.",
     "在旧基底的延续关系上（事为步与形成之对）：传是步入一个其形成未以自身延续之事；在传递之下，生成使载者迟迟生起；只按名读则无生成；所耗仍持、家族超出更新、传之止皆否诸支之不穷；中继复生而终。",
     di('Web.carries_iff', 'Web.passing_carries_iff', 'Web.generation_renews_late', 'Web.generation_arises_late',
        'Web.keeping_of_carried_on', 'Web.itself_not_generation', 'Web.always_keeps', 'Web.degenerates_of_gone',
        'Web.consumed_held_not_endless', 'Web.family_excess_not_endless', 'Web.stopped_not_endless',
        'Map.shifted_generates', 'Map.relay_renews_and_ends', 'Map.renewal_undecided')),
]
cited = sorted({x for _, _, ds in laws for x in ds})
rec = {
    "schema_version": 2, "id": RID,
    "title": {"en": "Generation, keeping and degeneration at two grains", "zh": "两种粒度下的生成、守与退化"},
    "kind": "theorem", "status": "recorded-checked", "family": "F01", "reviewed_at_utc": NOW,
    "statement": {
        "en": "Read at a fine and a coarse class and on branches, the pattern goes on along some branch or ends on "
              "every branch; generation and keeping exclude degeneration and can share a point; renewal does not "
              "decide the region, and telling going on from ending is exactly excluded middle.",
        "zh": "以细类与粗类、按分支同读：样式或沿某支而延，或诸支皆尽；生成与守皆斥退化，而可共于一点；复生不定其域；分辨延与尽恰是排中律。"},
    "laws": [{"en": a, "zh": b, "declarations": c} for a, b, c in laws],
    "hypotheses": [
        {"en": "None beyond the grammar: every carrier, every relation read as 缘, a fine and a coarse class; the "
               "covering law takes excluded middle as a hypothesis.",
         "zh": "除文法外无前提：每个载体、读作缘的每个关系、一个细类与一个粗类；覆盖之律以排中律为假设。"}],
    "does_not_show": [
        {"en": "That generation here is the 生生 of life in the whole: it is the continuation of a pattern through renewal "
               "of its parts, with no premise on what the pattern is or whether its going on is good.",
         "zh": "此处之生成即全体之生命的生生：它只是样式经其部分之更新而延续，对样式为何、其延续是否为善没有前提。", "kind": "correspondence"},
        {"en": "That the regions are decided: at a given point, whether the pattern goes on is in general not decided.",
         "zh": "诸域可判定：在一个给定之点，样式是否继续，一般不可判定。", "kind": "non-implication",
         "witness": d('«延尽之定当且仅当排中»')[0]},
        {"en": "That generation and keeping exclude each other where lines branch: a point can lie in both.",
         "zh": "分支之处生成与守互斥：一点可兼二者。", "kind": "non-implication", "witness": d('Map.«生守相杂»')[0]},
        {"en": "That renewal is generation: a line can renew and still end.",
         "zh": "复生即生成：一条线可复生而仍终。", "kind": "non-implication",
         "witness": d('Map.Short.renews_and_ends')[0]}],
    "counterexamples": [{"path": SRC, "detail": {
        "en": "A short life of two occurrences renews (its second occurrence begins a new part) and ends on every "
              "branch (Map.Short.renews_and_ends_everywhere).",
        "zh": "两事之短命：复生（其第二事始一新部分）而诸支皆尽（Map.Short.renews_and_ends_everywhere）。"}}],
    "standard_boundaries": ["no-ethical-premise", "no-evaluation", "formal-not-empirical"],
    "validation_scope": {
        "en": f"Checked by the core checker with Lean 4.29.1 from the prelude: Becoming.GrammarMap, {mod['theorems']} "
              f"theorems in {len(mod['declarations'])} declarations, and Becoming.MapInstances, {imod['theorems']} theorems, each "
              "with an empty axiom report. The instances were written by an Opus coder; no independent review.",
        "zh": f"由核心检查器以 Lean 4.29.1 从前奏检查：Becoming.GrammarMap，{len(mod['declarations'])} 个声明中 {mod['theorems']} "
              "条定理，及 Becoming.MapInstances，公理报告皆空。实例由一位 Opus 编者写成；无独立审查。"},
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
        {"path": ISRC, "role": "proof", "sha256": sha(ISRC), "declarations": sorted(inames)},
        {"path": REC, "role": "receipt", "sha256": sha(REC)},
        {"path": PLAN, "role": "statement", "sha256": sha(PLAN)}],
    "proof_bindings": [{"source": SRC, "receipt": REC, "sha256_pointer": "/source_sha256/Becoming.GrammarMap",
                        "success_pointer": "/status", "success_value": "passed"},
                       {"source": ISRC, "receipt": REC, "sha256_pointer": "/source_sha256/Becoming.MapInstances",
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
