#!/usr/bin/env python3
"""OU2 + OU3a: update the record continuation-relative-to-a-class (the grammar's new laws, the old continuation
family as its instances, the new receipt) and write classical-definitions-in-the-grammar.
usage (from the checkout root): python3 -B make_records2.py STUDY_SECTION RECEIPT"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
N, RECEIPT = sys.argv[1], sys.argv[2]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
REC = f'{PKG}/becoming-checks/{RECEIPT}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
PLAN = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/PLAN.md'
CLASSIFY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/classify/REPORT.md'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(m):
    return f'{PKG}/Becoming/{m}.lean'


R = json.loads((ROOT / REC).read_text())
assert R['status'] == 'passed'
mods = {m['module']: m for m in R['modules']}
for m in ['Grammar', 'GrammarReadings', 'Arising', 'Change', 'Identity', 'ContinuedClasses', 'PatternPassing',
          'Persistence', 'Space']:
    mm = mods['Becoming.' + m]
    assert not any(mm['axiom_dependencies'].values()), m
    assert R['source_sha256'].get('Becoming.' + m) == sha(src(m)), ('receipt does not bind', m)
names = {m: {d['name'] for d in mods['Becoming.' + m]['declarations']} for m in
         ['Grammar', 'GrammarReadings', 'Arising', 'Change', 'Identity', 'ContinuedClasses', 'PatternPassing',
          'Persistence', 'Space']}


def bare(n):
    return n.replace('«', '').replace('»', '')


def d(module, *xs):
    pool = names[module]
    by_bare = {bare(n): n for n in pool}
    out = []
    for x in xs:
        full = 'Becoming.' + x
        hit = full if full in pool else by_bare.get(bare(full))
        assert hit, ('not in the receipt', module, full)
        out.append(hit)
    return out


# --- continuation-relative-to-a-class -------------------------------------------------------------------------
p = RECORDS / 'continuation-relative-to-a-class.json'
rec = json.loads(p.read_text())
new_laws = [
    ("Lines: a line under a class stays within it; a beginning under a finer class continued under a coarser one is "
     "an alteration; what begins under a coarser class begins under the finer; and where every step keeps a class or "
     "carries a mark, a line whose ends the class tells apart has a marked step.",
     "线：类下之线不出其类；在细类下生而在粗类下续者为异；在粗类下生者在细类下亦生；凡每一步或保一类或带一标者，其两端为此类所分之线，必有带标之一步。",
     d('Grammar', '«线内同类»', '«生于细而续于粗则异»', '«生于粗则生于细»', '«两端分则中有标»')),
    ("Holding, mutual need and leaning-on through constancy apply only to lines that do not end; through the core they "
     "apply to every line: a class suffices for another's regularity where what is alike under both is alike under "
     "the other's core. The forms through constancy imply those through the core; a class is constant exactly where "
     "it lies in its own core, and the core is monotone in the class. A flame's regularity lies in fire and fuel.",
     "以有常定义的自持、相须、因于只适用于不终了之线；以核定义的适用于每条线：两类俱同者在其一之核下同，则此类足以定其一之理。以有常者蕴涵以核者；"
     "一个类恰在含于其核时有常；核随类单调。火之理在火与薪。",
     d('Grammar', '«自持»', '«相须»', '«因于»', '«有常之同谓»', '«相须之对称»', '«无自相须»', '«核之单调»',
       '«类有常当且仅当含于核»', '«足以定理»', '«因于核»', '«相须核»', '«合有常则足以定理»', '«因于则因于核»',
       '«相须则相须核»', 'Flame.fuel', 'Flame.sameFuel', 'Flame.joint_eq', '«火因于薪»')),
    ("Ceasing: nothing on the line from an occurrence renews. Renewal without end does not cease (生生不息), and "
     "under the one everything ceases.",
     "息：自一事起之线上无物复生。生生不息；在“一”之下皆息。",
     d('Grammar', '«息»', '«生生不息»', '«一之下皆息»')),
    ("The old base's continuation family is an instance of the grammar, occurrences being pairs of a step and a "
     "relatum and 缘 the module's own relation between them: arising and ceasing are beginning and ending under "
     "'alike in activity' along the same relatum, and relative to a continuation they are its beginning and ending; "
     "ceasing to be is an ending, coming to be a beginning; a split is fission and a merge the candles' merge; "
     "lineages, continuing, links and holding are lines; passing a pattern on while the carrier ceases is an "
     "alteration (火传), and falling dormant is an alteration under holding; the finite-world law of arising and "
     "ceasing is exactly the decidability of the positions.",
     "旧基底的续之族是本文法的实例：事为步与关系项之对，缘是模块自身在其间的关系。生起与终止是在同一关系项上“活动相同”之类下的生与亡，相对于一个延续则是其生与亡；"
     "成为是生，不再是是亡；分裂是分叉，合并是蜡烛之合；世系、延续、联系与持有都是线；薪尽而传样式是异（火传），休眠在持有之下是异；有穷世界的生灭之律恰是诸位之可判定。",
     d('Arising', 'Web.arises_iff_sheng', 'Web.unceasing_iff_late_beginnings', 'Web.renews_iff', 'Steps.next',
       'Steps.along', 'Web.activityClass') +
     d('Change', 'ceasesToBe_iff_wang', 'comesToBe_iff_sheng', 'Web.ceases_iff_wang', 'positions_iff_em',
       'persists_of_positions', 'core_iff_same_course', 'Web.flash_positions') +
     d('Identity', 'Web.continuationStep', 'Web.arisesFrom_iff_sheng', 'Web.ceasesFrom_iff_wang', 'Web.split_fission',
       'Web.merge_candles', 'Web.lineage_iff_line', 'Web.positions_not_self_standing', 'Web.reach_strict_order') +
     d('ContinuedClasses', 'Web.continuing_iff_line', 'Web.linked_iff_line', 'Web.held_iff_line',
       'Web.RenewingAlong.branches', 'Web.ConsumingAlong.merged_candles', 'Web.line_reidentify') +
     d('PatternPassing', 'Web.carrierClass', 'Web.byPassing_iff_hasPred', 'Web.passing_fire',
       'PatternRelay.fire_shape') +
     d('Persistence', 'Web.stateClass', 'Web.fallsDormant_alters', 'Web.ceases_of_persisting_ceases',
       'Hibernation.positions', 'Seed.held_classes') +
     d('Space', 'World.law_iff_positions', 'World.law_iff_grammar_positions')),
]
rec['laws'] += [{"en": a, "zh": b, "declarations": c} for a, b, c in new_laws]
rec['statement'] = {
    "en": "For every carrier and relation, continuation is 缘 met with a class; its positions depend on the class, a "
          "class constant under 缘 never lets a continuation end, a line's own regularity is the class's core, and "
          "the old base's arising, ceasing, lineage and passing are its instances.",
    "zh": "对每个载体与关系，续是缘与类之合；其诸位依于类，对缘有常之类其续永不终了，一条线之理是其类之核；旧基底之生起、终止、世系与传是其实例。"}
rec['does_not_show'] = [x for x in rec['does_not_show'] if 'continuation family' not in x['en']]
rec['does_not_show'].append({
    "en": "That the old base's counting, amounts, recurrence and renaming laws are instances: the grammar states no "
          "counting and no map of carriers, so only their premises are connected.",
    "zh": "旧基底的计数、量、复现与改名之律是实例：文法不陈述计数，也无载者之映射，故只连其前提。", "kind": "scope"})
for m in ['Grammar', 'Arising', 'Change', 'Identity', 'ContinuedClasses', 'PatternPassing', 'Persistence', 'Space']:
    path = src(m)
    cited_here = sorted({x for law in rec['laws'] for x in law['declarations'] if x in names[m]})
    refs = [r for r in rec['references'] if r['path'] == path]
    if m == 'Grammar':
        refs[0]['sha256'] = sha(path)
        refs[0]['declarations'] = sorted(names['Grammar'])
    elif refs:
        refs[0]['sha256'] = sha(path)
        refs[0]['declarations'] = cited_here
    else:
        rec['references'].append({"path": path, "role": "proof", "sha256": sha(path), "declarations": cited_here})
rec['references'] = [r for r in rec['references'] if r['role'] != 'receipt']
rec['references'].append({"path": REC, "role": "receipt", "sha256": sha(REC)})
for r in rec['references']:
    if r['path'] == PLAN:
        r['sha256'] = sha(PLAN)
rec['proof_bindings'] = [{"source": src(m), "receipt": REC, "sha256_pointer": f"/source_sha256/Becoming.{m}",
                          "success_pointer": "/status", "success_value": "passed"}
                         for m in ['Grammar', 'Arising', 'Change', 'Identity', 'ContinuedClasses', 'PatternPassing',
                                   'Persistence', 'Space']]
rec['aliases'] = sorted({x for law in rec['laws'] for x in law['declarations']})
g = mods['Becoming.Grammar']
rec['validation_scope'] = {
    "en": f"Checked by the core checker with Lean 4.29.1 from the prelude: Becoming.Grammar, {g['theorems']} theorems in "
          f"{len(g['declarations'])} declarations, and the instance sections of Arising, Change, Identity, "
          "ContinuedClasses, PatternPassing, Persistence and Space, each declaration with an empty axiom report. The "
          "plan it realizes was reviewed in its ninth version by GPT astra and two Opus reviewers; the instance "
          "sections were written by three Opus coders and merged with names reconciled. No human review.",
    "zh": f"由核心检查器以 Lean 4.29.1 从前奏检查：Becoming.Grammar，{len(g['declarations'])} 个声明中 {g['theorems']} 条定理，"
          "及 Arising、Change、Identity、ContinuedClasses、PatternPassing、Persistence、Space 的实例之节，公理报告皆空。计划第九版经 GPT astra 与两位 "
          "Opus 审查者审查；实例之节由三位 Opus 编者写成，合并时统一了名。无人审查。"}
rec['next_delta'] = {
    "en": "Lift the master laws onto the grammar with their owner, and the theorems that read activity only; state the "
          "counting of lines; and give generation and degeneration the content that continuation and renewal alone "
          "do not carry.",
    "zh": "与其主一同把主律提升到文法上，并提升只读活动之定理；陈述线之计数；给生成与退化以续与复生单独不带之内容。"}
rec['history'].append({
    "en": f"23 October 2026, board items OU2 and OU3a (study section {N}): the grammar gains holding, mutual need and "
          "leaning-on through the core for lines that end, ceasing and 生生不息, and four laws of lines moved down from "
          "PatternPassing and Persistence; the old continuation family is stated as its instances. The claim is "
          "widened to name the instances; the earlier laws are unchanged.",
    "zh": f"2026年10月23日，工作板条目 OU2 与 OU3a（研究第 {N} 节）：文法增以核定义的自持、相须、因于（适用于终了之线）、息与生生不息，"
          "并自 PatternPassing 与 Persistence 移下四条线之律；旧续之族陈述为其实例。论断扩及实例，先前之律不变。"})
rec['reviewed_at_utc'] = NOW
p.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('updated continuation-relative-to-a-class', len(rec['aliases']))

# --- classical-definitions-in-the-grammar ---------------------------------------------------------------------
RID = 'classical-definitions-in-the-grammar'
S = src('GrammarReadings')
laws = [
    ("化, read from the 墨经 (「化，徵易也」) and the 荀子 (「状变而实无别而为异者，谓之化」), is one form: continuing under "
     "the class of the thing while the class of its marks tells the two apart, which is the grammar's alteration.",
     "墨经（「化，徵易也」）与荀子（「状变而实无别而为异者，谓之化」）之化同为一形：在其物之类下续，而其征之类分之，即文法之异。",
     d('GrammarReadings', '«化»', '«化之二说同形»')),
    ("成坏, read from the 金师子章 (「諸根合會是成相，諸緣各住自位是壞相」), is at once alike under a coarse class and apart "
     "under a fine one; 化 is 成坏 along 缘.",
     "金师子章之成坏（「諸根合會是成相，諸緣各住自位是壞相」）是一时之中在粗类下同、在细类下异；化是沿缘之成坏。",
     d('GrammarReadings', '«成坏»', '«化为有缘之成坏»')),
    ("同, read from the 墨经 (「同，異而俱於之一也」), is sameness in belonging to one; it is a class exactly where each "
     "belongs to one and one only, and otherwise need not be transitive.",
     "墨经之同（「同，異而俱於之一也」）是同属于一；恰在各属唯一时为类，否则不必传递。",
     d('GrammarReadings', '«同于»', '«同于为类»', '«同于不必传递»')),
    ("复, read from the 老子 (「復命曰常」), is a line returning to where it was; what returns abides. 通, read from the "
     "系辞 (「往來不窮謂之通」), is a line that never ends; under a constant class a line with a past passes through.",
     "老子之复（「復命曰常」）是线之返其所始；复者住。系辞之通（「往來不窮謂之通」）是不终之线；在有常之类下，有前之线即通。",
     d('GrammarReadings', '«复»', '«相续之末有前»', '«复者住»', '«通»', '«有常则通»')),
    ("Neither one nor other: in a net without self-conditioning there is no continuation under identity, and every "
     "缘 is a continuation under some class while identity tells its ends apart. The 中论's 「滅更不生故，因即為斷滅」 holds "
     "under identity while the same 缘 is a continuation under a coarser class.",
     "非一非异：无自缘之网中，相等之类下无续，而每一缘在某类下为续、其两端为相等所分。中论「滅更不生故，因即為斷滅」在相等之类下成立，而同一缘在较粗之类下为续。",
     d('GrammarReadings', '«非一非异»', '«因灭而续»')),
]
cited = sorted({x for _, _, ds in laws for x in ds})
new = {
    "schema_version": 2, "id": RID,
    "title": {"en": "Classical definitions in the grammar", "zh": "古文之定义写入文法"},
    "kind": "theorem", "status": "recorded-checked", "family": "F01", "reviewed_at_utc": NOW,
    "statement": {
        "en": "Definitions of the frozen corpus written in the grammar hold for every carrier and relation: the 墨经's and "
              "荀子's 化 are one form and are 成坏 along 缘, 同 is a class only where belonging is single, and continuation "
              "is neither identity nor mere difference.",
        "zh": "冻结语料中的定义写入文法后，对每个载体与关系成立：墨经与荀子之化同形，是沿缘之成坏；同只在所属唯一时为类；续非一非异。"},
    "laws": [{"en": a, "zh": b, "declarations": c} for a, b, c in laws],
    "hypotheses": [
        {"en": "Each reading of a sentence as a definition is an AI reconstruction following the commentary named in the "
               "classification; the sense lost in it is recorded in the plan.",
         "zh": "把一句读作定义，是依分类中所注之注疏的 AI 重构；其中失去之义记于计划。"},
        {"en": "Equality on the carrier is a model commitment where identity is the class.",
         "zh": "以相等为类之处，载体之相等是模型的承诺。"}],
    "does_not_show": [
        {"en": "That these readings are the texts' own sense: the 墨经's 化 is also one of six kinds of action, and the "
               "金师子章's 成坏 is read synchronically against the 中论's 「成壞相違，云何一時有」.",
         "zh": "这些读法即文本自身之义：墨经之化又是六种为之一；金师子章之成坏以共时读之，与中论「成壞相違，云何一時有」相对。",
         "kind": "correspondence"},
        {"en": "That the 中论's dilemma is answered: whether a condition must still be present when what it conditions "
               "arises is not expressible without a relation of co-presence, which the grammar lacks.",
         "zh": "中论之两难已答：缘在其所缘生时是否须仍在，没有同在之关系便不能表达，而文法没有。", "kind": "scope"},
        {"en": "That every kind of 同 in the 墨经 is a class: 類同 is not transitive by itself.",
         "zh": "墨经之每种同都是类：类同本身不传递。", "kind": "non-implication",
         "witness": d('GrammarReadings', '«同于不必传递»')[0]}],
    "counterexamples": [{"path": S, "detail": {
        "en": "Belonging to two: 0 and 1 share 10, 1 and 2 share 20, 0 and 2 share nothing («同于不必传递»).",
        "zh": "属于二者：0 与 1 同属 10，1 与 2 同属 20，0 与 2 无所同属（«同于不必传递»）。"}}],
    "standard_boundaries": ["no-ethical-premise", "formal-not-empirical"],
    "validation_scope": {
        "en": f"Checked by the core checker with Lean 4.29.1 from the prelude: Becoming.GrammarReadings, "
              f"{mods['Becoming.GrammarReadings']['theorems']} theorems in "
              f"{len(mods['Becoming.GrammarReadings']['declarations'])} declarations, each with an empty axiom report. "
              "The sentences come from the frozen first-batch corpus as classified by four Opus coders; no human audit.",
        "zh": f"由核心检查器以 Lean 4.29.1 从前奏检查：Becoming.GrammarReadings，{len(mods['Becoming.GrammarReadings']['declarations'])} "
              f"个声明中 {mods['Becoming.GrammarReadings']['theorems']} 条定理，公理报告皆空。句子来自冻结之第一批语料，经四位 Opus 编者分类；无人审。"},
    "next_delta": {
        "en": "Write the rest of the corpus's 517 definitional units in the grammar where they read relationally, and "
              "prove the 59 grammar-theorem candidates or show where they fail.",
        "zh": "把语料 517 个定义单元中能以关系读之者写入文法，并证明 59 个文法定理之候选，或示其不成之处。"},
    "correspondence": {
        "en": "Units: 墨经 MJ-J-045, MJ-J-039; 荀子 XZ-ZM-063, XZ-ZM-064; 金师子章 JSZ-P-08-003; 老子 LZ-16-005; 系辞 "
              "「往來不窮謂之通」; 中论 ZL-21-122, ZL-01 (青目 「若一則無緣，若異則無相續」). The 墨经's four kinds of 同 "
              "(MJ-S-089) and the 中论's refutations are registered with the classification."},
    "canonical_source": S,
    "aliases": cited,
    "dependencies": [{"id": "continuation-relative-to-a-class", "relation": "formal-reuse", "detail": {
        "en": "Continuation, alteration, lines, constancy and the identity class are the grammar's.",
        "zh": "续、异、线、有常与相等之类皆出自文法。"},
        "interface": {"output": {"en": "«续», «异», «相续», «有常», «有常则续不尽», «任一缘可为续».",
                                 "zh": "«续»、«异»、«相续»、«有常»、«有常则续不尽»、«任一缘可为续»。"},
                      "input": {"en": "Definitions read from the corpus.", "zh": "读自语料之定义。"},
                      "conditions": {"en": "A net without self-conditioning where identity is the class.",
                                     "zh": "以相等为类处，网中无自缘。"},
                      "evidence": S}}],
    "related": [],
    "references": [
        {"path": S, "role": "proof", "sha256": sha(S), "declarations": sorted(names['GrammarReadings'])},
        {"path": REC, "role": "receipt", "sha256": sha(REC)},
        {"path": CLASSIFY, "role": "statement", "sha256": sha(CLASSIFY)}],
    "proof_bindings": [{"source": S, "receipt": REC, "sha256_pointer": "/source_sha256/Becoming.GrammarReadings",
                        "success_pointer": "/status", "success_value": "passed"}],
    "history": [{
        "en": f"23 October 2026, board item OU2 (study section {N}): the first definitions of the frozen corpus written "
              "in the grammar, after the classification of the first batch.",
        "zh": f"2026年10月23日，工作板条目 OU2（研究第 {N} 节）：第一批语料归类之后，首批定义写入文法。"}],
}
(RECORDS / f'{RID}.json').write_text(json.dumps(new, ensure_ascii=False, indent=2) + '\n')
print('wrote', RID, len(cited))
