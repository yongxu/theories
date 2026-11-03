#!/usr/bin/env python3
"""U4e: the record and chapter edits, applied in the tree given as argv[1]. The records are read and written as JSON
(their files round-trip byte for byte); each edit asserts the text it replaces occurs once."""
import json
import sys
from pathlib import Path

ROOT = Path(sys.argv[1])
REC = ROOT / 'theories/becoming/results/records'
GL = 'Becoming.«有覆而亡屡则生不止»'


def sub(s, old, new):
    assert s.count(old) == 1, (old[:80], s.count(old))
    return s.replace(old, new)


def load(rid):
    p = REC / f'{rid}.json'
    t = p.read_text(encoding='utf-8')
    d = json.loads(t)
    assert t == json.dumps(d, ensure_ascii=False, indent=2) + '\n', rid
    return p, d


def save(p, d):
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


# census-balance-under-continuation
p, d = load('census-balance-under-continuation')
h = d['hypotheses'][1]
h['zh'] = sub(h['zh'], "活动可判定、“延续某个活跃形成”与“被某个活跃形成延续”可判定，是定理的假设，不是公理；",
              "判定是定理的假设，不是公理，每条律只取其所用：跨步的平衡以标记计数，取活动可判定、“延续某个活跃形成”与"
              "“被某个活跃形成延续”可判定；复现律各取其一，无分裂者取前者，无合并者取后者，不取活动之判定。")
h['en'] = sub(h['en'], "Decided activity and decided ‘continues some active formation’ and ‘is continued by some active "
              "formation’ are hypotheses of the theorems, not axioms; under a census",
              "The decisions are hypotheses of the theorems, not axioms, each law taking only those it uses: the balance "
              "across a step counts by marks and takes decided activity and decided ‘continues some active formation’ "
              "and ‘is continued by some active formation’; the recurrence laws take one each, the first without splits "
              "and the second without merges, and no decision of activity. Under a census")
law4 = d['laws'][3]
law4['zh'] = sub(law4['zh'], "（«所覆后亡屡则生未否»、«有界覆而生屡则亡不止»",
                 "（«所覆后亡屡则生未否»、«有覆而亡屡则生不止»、«有界覆而生屡则亡不止»")
law4['en'] = sub(law4['en'], "(«所覆后亡屡则生未否», «有界覆而生屡则亡不止»",
                 "(«所覆后亡屡则生未否», «有覆而亡屡则生不止», «有界覆而生屡则亡不止»")
decl = law4['declarations']
assert GL not in decl
decl.insert(decl.index('Becoming.«所覆后亡屡则生未否»') + 1, GL)
law12 = d['laws'][11]
assert law12['declarations'] == ['Becoming.Web.arisingFrom_of_ceasingFrom_covered',
                                 'Becoming.Web.ceasingFrom_of_arisingFrom_covered']
law12['zh'] = sub(law12['zh'], "延续之下的普查律（第 6、9 条）是其特例，普查在每步的列出覆盖该步。",
                  "延续之下的普查复现律（第 6、9 条）是其特例，各只取同一判定，不取活跃之判定，普查在每步的列出覆盖该步。")
law12['en'] = sub(law12['en'], "The census laws under a continuation (laws 6 and 9) are their cases, a census's listing "
                  "at each step covering it.",
                  "The census recurrence laws under a continuation (laws 6 and 9) are their cases, each taking the same "
                  "one decision and none of activity, a census's listing at each step covering it.")
nd = d['next_delta']
nd['zh'] = sub(nd['zh'], "从延续之下的普查律去掉其证明已不用的判定（活跃之判定，与另一方向延续之判定）；", "")
nd['en'] = sub(nd['en'], "dropping from the census laws under a continuation the decisions their proofs no longer use "
               "(of activity, and of the other direction's continuation); ", "")
refs = [r for r in d['references'] if r['path'].endswith('/Becoming/GrammarLaws.lean')]
assert len(refs) == 1 and GL not in refs[0]['declarations']
rd = refs[0]['declarations']
rd.insert(rd.index('Becoming.«所覆后亡屡则生未否»') + 1, GL)
d['history'].append({
    'en': "2 November 2026, U4e (study section U4E_SECTION): Web.arisingFrom_not_stopping_covered is re-proved as the "
          "root's «有覆而亡屡则生不止» at the formations' occurrences, statement unchanged, and law 4 names that root law "
          "among the covering laws' routes; the four census recurrence laws (laws 6 and 9) drop the decisions their "
          "proofs do not use, each keeping only whether a formation continues one active before (without splits) or is "
          "continued by one active after (without merges), and none of activity, so each statement is more general. The "
          "second hypotheses entry and law 12 say which decision each law takes, and the Next drops the item now done. "
          "The balance across a step (laws 3 and 9) keeps the three decisions its count uses.",
    'zh': "2026年11月2日，U4e（研究第 U4E_SECTION 节）：Web.arisingFrom_not_stopping_covered 改作根上之 «有覆而亡屡则生不止» "
          "取各形成之出现而证，陈述不变，第 4 条于覆盖之律之路径中列此根律；延续之下的四条普查复现律（第 6、9 条）去掉其证明不用的判定，"
          "各只留一形成是否延续前一活跃者（无分裂者）或是否为后一活跃者所延续（无合并者），不取活跃之判定，故各陈述更一般。"
          "第二条假设与第 12 条说明每条律取何判定，下一步去掉今已完成之项。跨步的平衡（第 3、9 条）仍取其计数所用的三种判定。"})
save(p, d)

# identity-across-steps: persisting_census's statement more general
p, d = load('identity-across-steps')
d['history'].append({
    'en': "2 November 2026, U4e (study section U4E_SECTION): Web.persisting_census drops the decisions its proof does not "
          "use, of holding activity and of the continuation itself, keeping whether a formation continues or is "
          "continued; the statement is more general and the law unchanged.",
    'zh': "2026年11月2日，U4e（研究第 U4E_SECTION 节）：Web.persisting_census 去掉其证明不用的判定，即保持之活跃之判定与延续本身之判定，"
          "留一形成是否延续与是否被延续之判定；陈述更一般，规律不变。"})
save(p, d)

# 01 §9.5: the home row of census-balance-under-continuation
c = ROOT / 'theories/becoming/chapters/01-ROOT.md'
c.write_text(sub(c.read_text(encoding='utf-8'),
    "| Under a census, read along a continuation, with activity decided and whether a formation continues, or is "
    "continued by, some active formation decided: without splits ceasing recurring needs arising recurring; without "
    "merges, at most `B` formations active from some step on, conversely; with neither the balance is exact "
    "(`Web.Census.balanceFrom_eq`), each hypothesis needed. From covering lists, with whether a formation continues (or "
    "is continued by) an active one decided and no decision of activity, the two directions hold exactly; a census is "
    "not needed (`Web.arisingFrom_of_ceasingFrom_covered`, `Web.ceasingFrom_of_arisingFrom_covered`). |",
    "| Under a census, read along a continuation: without splits ceasing recurring needs arising recurring, with whether "
    "a formation continues some active formation decided; without merges, at most `B` formations active from some "
    "step on, conversely, with whether it is continued by one decided; with neither, activity and both of these "
    "decided, the balance is exact (`Web.Census.balanceFrom_eq`), each condition needed. From covering lists, with "
    "the same decision each and none of activity, the two directions hold exactly; a census is not needed "
    "(`Web.arisingFrom_of_ceasingFrom_covered`, `Web.ceasingFrom_of_arisingFrom_covered`). |"), encoding='utf-8')
print('texts edited')
