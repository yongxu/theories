#!/usr/bin/env python3
"""LW's follow-up: the record universal-practical-warrant restated as the question it now is, with its home item in 07
and the passages that still called it a target. The goal zero-axiom-session, restated and approved on 30 October as
practical judgment for life, lists the record "as the question": whether a warrant binding every possible mind exists
stays open, and the ethics, life's stance (07 T8), does not wait on it. A changed statement goes to the record and its
home section together (RESULT-WORKFLOW). Kind and status stay (a target, open): the registry has no kind "question",
and an open target is its kind for an open item; the history note says so.
Taken from the review in rv21-one-sense/review/ (three lenses): the statement keeps no claim beyond 07 §1's
non-entailment, which moves, exact, to does_not_show and to a related entry for what-the-dynamics-leave-open; the
target wording goes from the record's fields, 07's item, 08's warrant line, four related details in chapter 7's
records and the sentence navigation.py writes into RESULTS.md. The second round (rv21-one-sense NOTE §5): "satisfiable"
in the non-entailment, as 07 and T8 have it; the shared boundary zero-axiom-target-open names both the theory's
zero-axiom foundation (a target) and this question, and this record drops it; validation_scope says what the progress
lines are. The third round: the non-entailment's own record, what-the-dynamics-leave-open, says "satisfiable" in
its statement, as its home section does (snapshot and history note).
  python3 -B upw_question.py --check    (from the checkout root) everything is as read; writes nothing
  python3 -B upw_question.py --apply    snapshots the record's bytes (research.py snapshot), then writes"""
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
RID = 'universal-practical-warrant'
RECS = ROOT / 'theories/becoming/results/records'
REC = RECS / f'{RID}.json'
CH7 = ROOT / 'theories/becoming/chapters/07-SIGNIFICANCE.md'
CH8 = ROOT / 'theories/becoming/chapters/08-METHOD.md'
NAV = ROOT / 'tools/research/navigation.py'
BOUNDARIES = ROOT / 'theories/becoming/results/data/standard-boundaries.json'

OLD_TITLE = {"zh": "普遍实践根据的更强目标", "en": "Stronger universal practical warrant target"}
OLD_STATEMENT_EN = "Target: universal practical warrant with zero substantive axioms, developed as one account of ends, "
OLD_HYPOTHESIS_EN = "An independently authorized stronger target; supplied local norms or behavioral convergence do not substitute for it."
OLD_DNS8_EN = "The revised question is itself an inquiry: it substitutes for no normative argument and cannot prove warrant by defining it in."

NEW = {
    'title': {"en": "Whether a universal practical warrant exists", "zh": "是否存在普遍的实践根据"},
    'statement': {
        "en": "Question: whether practical reasons have a warrant binding every possible mind, with zero substantive "
              "premises. It stays open, and the ethics, life's stance, does not wait on it.",
        "zh": "问题：实践理由是否有一个零实质前提、对一切可能的心智都有约束力的根据。它保持开放，伦理作为生命的立场不待其解决。"},
    'next_delta': {
        "en": "An argument either way: a warrant binding every possible mind that, where it grounds the condition, says "
              "where it comes from beyond logic alone and the represented dynamics alone; or a showing that none exists "
              "for a stated class of minds. The practical judgment the ethics for life needs is the work of the goal of "
              "practical judgment for life, and does not wait on this question.",
        "zh": "任一方向的论证：一个对一切可能心智都有约束力的根据，若为延续条件奠基，须说明它在单凭逻辑与单凭所表示的动力学之外从何而来；"
              "或表明对某一注明的心智类不存在这样的根据。生命之伦理所需的实践判断是“生命的实践判断”这一目标的工作，不待此问。"},
}
NEW_HYPOTHESIS = {
    "en": "Left open by the goal \"Practical judgment for life, on the fewest premises\"; supplied local norms, "
          "behavioural convergence or fuller description do not answer it.",
    "zh": "“生命的实践判断，立于最少的前提”这一目标把它留作开放的问题；给定的局部规范、行为收敛或更完整的描述都不回答它。"}
NEW_DNS8 = {
    "en": "With significance a free predicate, where there is a standpoint and a formation, neither logic alone nor a "
          "satisfiable statement reading only the represented dynamics entails the condition; this does not show that no "
          "such warrant exists.",
    "zh": "意义为自由谓词、有立场与形成之处，单凭逻辑或只读所表示之动力学的可满足陈述都不蕴含延续条件；这不表明不存在这样的根据。",
    "kind": "non-implication"}
RELATED = {"id": "what-the-dynamics-leave-open", "detail": {
    "en": "Where there is a standpoint and a formation, no satisfiable statement reading only the represented dynamics "
          "entails the condition, and bounded_rival (in continuation-condition-yields-living-significance) denies it "
          "consistently; so a warrant grounding the condition comes from neither logic alone nor those dynamics alone, "
          "and these do not show that none exists.",
    "zh": "在有立场与形成之处，只读所表示动力学的可满足陈述都不蕴含延续条件，bounded_rival（见 continuation-condition-yields-"
          "living-significance）一致地否认它；所以为条件奠基的根据既不单出于逻辑，也不单出于这些动力学，而这些并不表明它不存在。"}}
# related details in this record that called it a target: (id, old en, new en, old zh, new zh)
# The non-entailment's own record states it without "satisfiable", which its home section (07, "What the dynamics leave
# open") and ReadsOnlyDynamics.not_entails have: an unsatisfiable statement entails the condition vacuously.
DYN = 'what-the-dynamics-leave-open'
OLD_DYN = {"en": "No statement that reads only the dynamics excludes a rival or, given a standpoint and a formation, entails "
                 "the continuation condition. A rival is exactly a point lacking significance; a premise excludes every "
                 "rival exactly where no point lacks significance, the condition where each point is decided.",
           "zh": "只读动力之陈述不排除任何对手，有立场与形成处亦不推出延续之条件。对手恰是某处缺意义；一前提排除一切对手恰当其推出无处缺意义，"
                 "每处意义已定处即为条件。"}
NEW_DYN = {"en": "No satisfiable statement reading only the dynamics excludes a rival or, with a standpoint and a formation, "
                 "entails the continuation condition. A rival is exactly a point lacking significance; a premise excludes "
                 "every rival exactly where no point lacks it, the condition where each point is decided.",
           "zh": "可满足而只读动力之陈述不排除任何对手，有立场与形成处亦不推出延续之条件。对手恰是某处缺意义；一前提排除一切对手恰当其推出"
                 "无处缺意义，每处意义已定处即为条件。"}
DYN_HISTORY = {
    "en": "30 October 2026: the statement made exact, with no change to what is proved: a satisfiable statement, as the "
          "home section and ReadsOnlyDynamics.not_entails have it, since an unsatisfiable one entails the condition "
          "vacuously; the earlier bytes are in text_versions.",
    "zh": "2026年10月30日：陈述改为确切，所证无改变：为可满足之陈述，如本节与 ReadsOnlyDynamics.not_entails 所述，因不可满足者空洞地"
          "推出条件；先前字节见 text_versions。"}
OLD_SCOPE = {
    "en": ("full or targeted rereadings of existing studies (elective concern, relation and reason, the noninstrumental "
           "root, relational goodness, whole-process realization, the constitutive audit, ethical learning)"),
    "zh": "完整或定向重读既有研究（选择关切、关系与理由、非工具性根基、关系善、整体实现、构成审计、伦理学习）"}
NEW_SCOPE = {
    "en": "full or targeted rereadings of seven existing studies, from elective concern to ethical learning,",
    "zh": "完整或定向重读七项既有研究（自选择关切至伦理学习）"}
SCOPE_ADD = {
    "en": " The progress lines are the earlier target's work, now the goal's; none bears on whether such a warrant "
          "exists.",
    "zh": "进展诸行是先前目标在实践判断上的工作，今属该目标；无一关涉这样的根据是否存在。"}
OWN_RELATED = [
    ('practical-judgment-under-living-significance',
     "The conditional alignment route is an established result with a different completion standard.",
     "The conditional alignment route is an established result; this question does not reopen it.",
     "条件对齐路线是已有成果；两者的完成标准不同。", "条件对齐路线是已有成果；本问题不重开它。"),
    ('open-form-realization-under-revision',
     "P89 bounded realization and formal connection are complete, not reopened as a missing mechanism for this target.",
     "Bounded realization and formal connection are complete, not reopened as a missing mechanism for this question.",
     "P89的有限实现与正式连接已结项，不恢复为本目标的待做机制。", "有限实现与正式连接已结项，不恢复为本问题的待做机制。"),
]
HISTORY = {
    "en": "30 October 2026: restated as the question it now is, whether a warrant binding every possible mind exists. The "
          "goal zero-axiom-session, restated and approved on 30 October as practical judgment for life, lists the record "
          "as the question, and the ethics, life's stance (chapter 7, T8), does not wait on it. Title, statement, "
          "hypothesis and next step rewritten with 07's open item; 07's non-entailment linked and stated exactly in "
          "does_not_show, in place of the item on the earlier fulfillment question; two related details say question; "
          "the shared boundary zero-axiom-target-open, whose question this record now is, dropped. "
          "The kind stays target, the registry's kind for an open item. validation_scope, its list of studies "
          "shortened, now says that the progress lines are the earlier target's work on practical judgment, now the "
          "goal's, and that none bears on whether such a warrant exists. The earlier bytes are in text_versions; no new "
          "proof.",
    "zh": "2026年10月30日：重述为它现在所是的问题，即是否存在对一切可能心智都有约束力的根据。目标 zero-axiom-session 于 10 月 30 日"
          "重述并获批为生命的实践判断，把本记录列为该问题；伦理是生命的立场（第七章 T8），不待其解决。标题、陈述、假设与下一步随"
          "第七章的未决条目一并改写；第七章之不蕴含得到链接，并在 does_not_show 中确切陈述，替换关于先前完成问句之条目；两条相关说明"
          "改称问题；共享边界 zero-axiom-target-open（其问题即本记录）移去。类别仍为 target，即登记处对未决条目之类别。validation_scope "
          "缩短所列研究，并说明进展诸行是先前目标在实践判断上的工作，今属该目标，无一关涉这样的根据是否存在。先前字节见 text_versions；"
          "无新证明。"}

OLD_07 = ("<a id=\"r-universal-practical-warrant\"></a>**A universal practical warrant**: grounding practical reasons with "
          "zero substantive premises, as one account of ends, selection, knowing and revision within becoming; supplied "
          "local norms, behavioural convergence or fuller description do not substitute for it. The ethics does not wait "
          "on it ([T8](#theses)).")
NEW_07 = ("<a id=\"r-universal-practical-warrant\"></a>**Whether a universal practical warrant exists**: whether practical "
          "reasons have a warrant binding every possible mind, with zero substantive premises. It stays open: supplied "
          "local norms, behavioural convergence or fuller description do not answer it, and the ethics, life's stance, "
          "does not wait on it ([T8](#theses)).")
OLD_07B = ("comes neither from the laws of the dynamics alone nor from logic alone; neither shows that none exists. "
           "([record](../results/records/universal-practical-warrant.md))")
NEW_07B = ("comes neither from the laws of the dynamics alone nor from logic alone; these do not show that none exists. "
           "([record](../results/records/universal-practical-warrant.md))")
OLD_08 = ("- **A stronger universal practical warrant**: grounding reasons without an externally supplied end; the ethics "
          "does not wait on it ([07](07-SIGNIFICANCE.md#r-universal-practical-warrant), T8).")
NEW_08 = ("- **Whether a universal practical warrant exists**: whether practical reasons have a warrant binding every "
          "possible mind, with zero substantive premises; it stays open, and the ethics, life's stance, does not wait on "
          "it ([07](07-SIGNIFICANCE.md#r-universal-practical-warrant), T8).")
OLD_NAV = "The independent targets `universal-practical-warrant` and `wisdom-root` remain open."
NEW_NAV = "The question `universal-practical-warrant` and the independent target `wisdom-root` remain open."
BOUNDARY_KEY = 'zero-axiom-target-open'
OLD_BOUNDARY = {"en": "Premise-free (zero-substantive-axiom) grounding is a separate open target; completed results on the "
                      "conditional alignment route keep their scope.",
                "zh": "无实质公理奠基是另一开放目标；条件对齐路线上已完成的成果保持原范围。"}
# The key stands, in the theory records, for the zero-substantive-axiom foundation of the theory, still a target; in
# the practical records for the warrant, now the question. The new text names both. The record restated here drops the
# key, since its own question is the second.
NEW_BOUNDARY = {"en": "The zero-substantive-axiom foundation of the theory is a separate open target, and whether a "
                      "warrant binding every possible mind exists a separate open question; completed results on the "
                      "conditional alignment route keep their scope.",
                "zh": "本理论的零实质公理基础是另一开放目标，是否存在对一切可能心智都有约束力的根据是另一开放问题；"
                      "条件对齐路线上已完成的成果保持原范围。"}
# related details in other chapter-7 records that called this record a target: (record, old en, new en, old zh, new zh)
OTHER_RELATED = [
    ('practical-judgment-under-living-significance',
     "The independent axiom-free target remains open and is not an unmet completion gate for this result.",
     "The question of a warrant binding every possible mind stays open and is not an unmet completion gate for this result.",
     "无公理目标独立保留，不是本成果的未完成条件。", "是否存在对一切可能心智都有约束力的根据，此问题保持开放，不是本成果的未完成条件。"),
    ('metaethical-core-characterization', "Advances without completing it:", "Bears on it without answering it:",
     "推进而未完成：", "关涉而未回答："),
    ('own-good-to-reachable-living-significance', "Advances without completing it:", "Bears on it without answering it:",
     "推进但未完成：", "关涉但未回答："),
    ('positioned-positive-reason',
     "the stronger universal practical warrant without added normative premises remains open.",
     "whether a universal practical warrant binding every possible mind exists, with zero substantive premises, stays "
     "an open question.",
     "更强的无附加规范前提的普遍实践根据仍为开放目标。", "是否存在零实质前提、对一切可能心智都有约束力的普遍实践根据，仍是开放问题。"),
]
OTHER_HISTORY = {
    "en": "30 October 2026: the related detail on universal-practical-warrant reworded for its restatement as a question; "
          "nothing else changed.",
    "zh": "2026年10月30日：关于 universal-practical-warrant 的相关说明因其重述为问题而改写；其余无改变。"}


def load(path):
    raw = path.read_text(encoding='utf-8')
    return raw, json.loads(raw)


def dump(path, raw, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + ('\n' if raw.endswith('\n') else ''), encoding='utf-8')


def related_of(record, rid):
    hits = [r for r in record['related'] if r['id'] == rid]
    assert len(hits) == 1, (record['id'], rid, len(hits))
    return hits[0]['detail']


def check():
    _, record = load(REC)
    done = record['title'] == NEW['title']
    if not done:
        assert record['title'] == OLD_TITLE, record['title']
        assert record['statement']['en'].startswith(OLD_STATEMENT_EN), record['statement']['en'][:120]
        assert [h['en'] for h in record['hypotheses']] == [OLD_HYPOTHESIS_EN], record['hypotheses']
        assert record['does_not_show'][7]['en'] == OLD_DNS8_EN and len(record['does_not_show']) == 8
        for rid, oe, ne, oz, nz in OWN_RELATED:
            d = related_of(record, rid)
            assert (d['en'], d['zh']) == (oe, oz), rid
        assert RELATED['id'] not in [r['id'] for r in record['related']]
        for lang in ('en', 'zh'):
            assert record['validation_scope'][lang].count(OLD_SCOPE[lang]) == 1, lang
        assert BOUNDARY_KEY in record['standard_boundaries']
    _, dyn = load(RECS / f'{DYN}.json')
    assert dyn['statement'] in (OLD_DYN, NEW_DYN) or {k: dyn['statement'][k] for k in ('en', 'zh')} in (OLD_DYN, NEW_DYN), \
        dyn['statement']
    for path, pairs in ((CH7, [(OLD_07, NEW_07), (OLD_07B, NEW_07B)]), (CH8, [(OLD_08, NEW_08)]), (NAV, [(OLD_NAV, NEW_NAV)])):
        text = path.read_text(encoding='utf-8')
        for old, new in pairs:
            assert text.count(old) == 1 or (done and new in text), (path.name, old[:60])
    _, bounds = load(BOUNDARIES)
    b = bounds['boundaries'][BOUNDARY_KEY]
    assert {k: b[k] for k in ('en', 'zh')} in (OLD_BOUNDARY, NEW_BOUNDARY), b
    for rid, oe, ne, oz, nz in OTHER_RELATED:
        _, other = load(RECS / f'{rid}.json')
        d = related_of(other, RID)
        assert (d['en'].count(oe) == 1 and d['zh'].count(oz) == 1) or (done and ne in d['en']), rid
    return done


def apply():
    if check():
        print('already applied')
        return
    now = datetime.now(timezone.utc).replace(microsecond=0).isoformat()
    out = subprocess.run([sys.executable, '-B', 'tools/research/research.py', 'snapshot', RID], cwd=ROOT,
                         capture_output=True, text=True, check=True).stdout
    entry = json.loads(out[out.index('{'):out.rindex('}') + 1])['text_versions_entry']
    entry['note'] = {"en": "Exact record bytes before it was restated as the question (30 October 2026).",
                     "zh": "重述为问题之前的记录原始字节（2026年10月30日）。"}
    raw, record = load(REC)
    record.update(NEW)
    record['hypotheses'] = [NEW_HYPOTHESIS]
    record['does_not_show'][7] = NEW_DNS8
    for rid, oe, ne, oz, nz in OWN_RELATED:
        d = related_of(record, rid)
        d['en'], d['zh'] = ne, nz
    record['related'].append(RELATED)
    for lang in ('en', 'zh'):
        record['validation_scope'][lang] = record['validation_scope'][lang].replace(OLD_SCOPE[lang], NEW_SCOPE[lang], 1) \
            + SCOPE_ADD[lang]
    record['standard_boundaries'].remove(BOUNDARY_KEY)
    record['history'].append(HISTORY)
    record['text_versions'].append(entry)
    record['reviewed_at_utc'] = now
    dump(REC, raw, record)
    for path, pairs in ((CH7, [(OLD_07, NEW_07), (OLD_07B, NEW_07B)]), (CH8, [(OLD_08, NEW_08)]), (NAV, [(OLD_NAV, NEW_NAV)])):
        text = path.read_text(encoding='utf-8')
        for old, new in pairs:
            text = text.replace(old, new, 1)
        path.write_text(text, encoding='utf-8')
    text = BOUNDARIES.read_text(encoding='utf-8')  # edited as text: the file's layout is not json.dumps's
    for lang in ('en', 'zh'):
        assert text.count(json.dumps(OLD_BOUNDARY[lang], ensure_ascii=False)) == 1, lang
        text = text.replace(json.dumps(OLD_BOUNDARY[lang], ensure_ascii=False),
                            json.dumps(NEW_BOUNDARY[lang], ensure_ascii=False), 1)
    BOUNDARIES.write_text(text, encoding='utf-8')
    assert json.loads(text)['boundaries'][BOUNDARY_KEY]['en'] == NEW_BOUNDARY['en']
    out = subprocess.run([sys.executable, '-B', 'tools/research/research.py', 'snapshot', DYN], cwd=ROOT,
                         capture_output=True, text=True, check=True).stdout
    dyn_entry = json.loads(out[out.index('{'):out.rindex('}') + 1])['text_versions_entry']
    dyn_entry['note'] = {"en": "Exact record bytes before its statement was made exact (30 October 2026).",
                         "zh": "陈述改为确切之前的记录原始字节（2026年10月30日）。"}
    raw, dyn = load(RECS / f'{DYN}.json')
    for lang in ('en', 'zh'):
        assert dyn['statement'][lang] == OLD_DYN[lang], lang
        dyn['statement'][lang] = NEW_DYN[lang]
    dyn['history'].append(DYN_HISTORY)
    dyn.setdefault('text_versions', []).append(dyn_entry)
    dyn['reviewed_at_utc'] = now
    dump(RECS / f'{DYN}.json', raw, dyn)
    for rid, oe, ne, oz, nz in OTHER_RELATED:
        path = RECS / f'{rid}.json'
        raw, other = load(path)
        d = related_of(other, RID)
        d['en'], d['zh'] = d['en'].replace(oe, ne, 1), d['zh'].replace(oz, nz, 1)
        other['history'].append(OTHER_HISTORY)
        other['reviewed_at_utc'] = now
        dump(path, raw, other)
    print('restated', RID, 'with its home item in 07, 08\'s line, the shared boundary, navigation.py and',
          len(OTHER_RELATED), 'related details; snapshot', entry['path'])


if __name__ == '__main__':
    {'--check': lambda: print('already applied' if check() else 'checked: everything is as read'),
     '--apply': apply}[sys.argv[1]]()
