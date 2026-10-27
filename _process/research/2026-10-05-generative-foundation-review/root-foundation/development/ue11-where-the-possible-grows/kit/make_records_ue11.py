#!/usr/bin/env python3
"""UE11 records: write where-the-possible-grows (every declaration of Becoming.HeldPossible, in twenty-three law groups),
and relate what-a-course-keeps-reachable and rules-that-change-themselves-in-the-grammar to it, each with a related
entry and a history note; neither's statement, next step or declarations change. Asserts the receipt's hash and empty
axiom reports for the module, and the style caps (tools/research/style.py) on every field written. Mirrors UE10's
make_records_ue10.py; no landed module changes, so no record is re-pointed for Lean.
usage (from the checkout root, after texts_ue11.py): python3 -B make_records_ue11.py RECEIPT N
       python3 -B make_records_ue11.py --caps  (the caps and the declaration cover against the kit's scratch audit;
                                                writes nothing)"""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))
from tools.research import style  # noqa: E402

CAPS_ONLY = sys.argv[1] == '--caps'
RECEIPT_ID, N = ('20261027T000000.000000Z', 427) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KITD = RF + 'development/ue11-where-the-possible-grows/'
NOTE, REVIEW, RECHECK = KITD + 'NOTE.md', KITD + 'REVIEW-UE11.md', KITD + 'RECHECK-UE11.md'
CH7 = 'theories/becoming/chapters/07-SIGNIFICANCE.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in
        ('HeldPossible', 'ReachableRanges', 'Mechanism', 'Gated', 'Junctures', 'Onward', 'Amounts', 'Change',
         'Arising', 'Grammar', 'GrammarLaws', 'Frame')}
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'where-the-possible-grows'
RID10 = 'what-a-course-keeps-reachable'
RIDG = 'rules-that-change-themselves-in-the-grammar'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60])
    return pair


if CAPS_ONLY:
    audit = (HERE.parent / 'tree/.build/BecomingHeldPossibleAxiomAudit.lean').read_text(encoding='utf-8')
    names = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
else:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed'
    module = 'Becoming.HeldPossible'
    assert core['source_sha256'][module] == sha(LEAN['HeldPossible']), module
    mod = next(x for x in core['modules'] if x['module'] == module)
    assert not any(mod['axiom_dependencies'].values()), module
    names = {d['name'] for d in mod['declarations']}
assert len(names) == 110, len(names)


def D(*short):
    out = ['Becoming.' + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


groups = [
    ("A move adds nothing to the possible under its process. For any process Q, what is possible under Q from a "
     "configuration Q reaches is possible from the first; so where something possible under Q from t is not possible "
     "from s, Q does not reach t from s, and a step from s to t is not a move of Q.",
     "一步不给其过程下之可能增添任何东西。对任一过程 Q，自 Q 所达之构型在 Q 下可能者，自起点亦可能；故自 t 在 Q 下可能而自 s 不可能者若有，"
     "则 Q 不自 s 达 t，自 s 至 t 之步非 Q 之步。",
     D('Reaching.not_reach_of_grows', 'Reaching.not_step_of_grows')),
    ("Keeping widening needs departures without end. Along a course, where every step of a stretch is a move of Q, what "
     "is possible under Q at its end is possible at its start; so where the possible under Q keeps widening, read from "
     "the course's first step, from every step some bounded stretch is not made of moves of Q throughout, and where "
     "every step from some step on is one, it does not keep widening.",
     "持续扩大需无尽之偏离。沿一进程，一段中每步皆 Q 之步时，段末在 Q 下可能者段首亦可能；故 Q 下之可能自首步读而持续扩大时，"
     "自每一步起总有一有界之段不全由 Q 之步组成；自某步起每步皆为 Q 之步时，它不持续扩大。",
     D('Run.possible_of_stretch', 'Run.departs_of_keepsWidening', 'Run.not_keepsWidening_of_within')),
    ("A course that returns. Along a course that comes back to one configuration at arbitrarily late steps, nothing "
     "read off its configurations keeps widening: neither the possible under any process nor the possible with any part "
     "held.",
     "回返之进程。沿一于任意晚之步回到同一构型之进程，自其构型所读之任何东西皆不持续扩大：任一过程下之可能、持守任一部分时之可能皆然。",
     D('Run.not_keepsWidening_of_returns')),
    ("The possible with a part held. For a relation Same on configurations, read as a part held unchanged, the moves "
     "holding it are the moves of the process with Same between their two configurations, and the held possible is the "
     "possible under them; it is included in the whole possible, and holding a weaker relation reaches at least as much.",
     "持守一部分时之可能。构型上之关系 Same 读作不变地持守之部分；持守之之步即两构型间有 Same 之过程之步，持守时之可能即其下之可能；"
     "它含于全部可能之中，持守较弱之关系所达不少于此。",
     D('Reaching.heldMoves', 'Reaching.PossibleHeld', 'Reach.of_heldMoves', 'Reach.heldMoves_mono',
       'Reaching.PossibleHeld.possible')),
    ("Instances. Onward's steps within a family are the moves holding both ends in it, and Junctures' steps after which "
     "a configuration can still be had are the moves holding that, both by definition.",
     "实例。Onward 之族内之步即持守两端皆在族中之步，Junctures 之其后某构型仍可得之步即持守此者之步，皆依定义。",
     D('Onward.within_eq_heldMoves', 'Branching.keeping_eq_heldMoves')),
    ("On the root. With Same in the place of the grammar's class, any relation, a move holding it is a continuation "
     "«续» under it; what the moves holding it reach is the start or the start's line «相续» under it; and the held "
     "possible is what the start or that line admits.",
     "于根上。以 Same 居语法之类之位（任一关系皆可），持守之之步即其下之续；持守之之步所达者即起点或起点于其下之相续；"
     "持守时之可能即起点或该线所纳。",
     D('Reaching.steps_heldMoves_iff', 'Reaching.reach_heldMoves_iff', 'Reaching.possibleHeld_iff_line')),
    ("Held move by move, and as at the start. Where Same is a class, what the moves holding it reach is alike the start "
     "under it, and holding it move by move is holding it as it is at the start, both ways: what the moves holding Same "
     "reach from s is what the moves into configurations alike s reach.",
     "逐步持守与如起点般持守。Same 为类时，持守之之步所达者于其下与起点同类，逐步持守即如起点般持守，双向皆然："
     "自 s 持守 Same 之步所达者，即入与 s 同类之构型之步所达者。",
     D('Reach.same_of_heldMoves', 'Trace.heldMoves_sameAsStart', 'Trace.sameAsStart_heldMoves',
       'Reach.heldMoves_iff_sameAsStart')),
    ("Where it grows. Where something possible with the part held at the next step is not possible so at the present "
     "one, the step changes the part; where every step from T on holds the part, what is possible with it held at step "
     "T + d is possible so at T: from the step at which the part stays for good, nothing is added.",
     "于何处增长。下一步持守该部分时可能而当下不然者若有，则该步改变该部分；自 T 起每步皆持守该部分时，第 T + d 步持守时可能者，"
     "于 T 亦然：自该部分永住之步起，无所增。",
     D('Run.changes_of_heldGrows', 'Run.possibleHeld_of_stays')),
    ("Where it keeps widening. The held possible keeps widening only where the part changes without end: from every "
     "step some bounded stretch does not hold the part throughout, so not along a course whose steps hold it from some "
     "step on; and only where no list holds the whole possible from the course's start.",
     "于何处持续扩大。持守时之可能仅当该部分无尽地改变时持续扩大：自每一步起总有一有界之段不全持守之，故其步自某步起皆持守之之进程上不然；"
     "且仅当无列表自进程之始持全部可能时。",
     D('Run.changes_of_heldKeepsWidening', 'Run.not_heldKeepsWidening_of_stays', 'Run.not_heldKeepsWidening_of_listed')),
    ("Located where holding is decided. Where whether each step of the course holds the part is decided, a step "
     "changing it lies between N and N + d wherever something possible with it held at N + d is not possible so at N, "
     "and where the held possible keeps widening such a step recurs from every step on.",
     "持守可判定时可定位。进程每步是否持守该部分可判定时，第 N + d 步持守时可能而第 N 步不然者若有，则 N 与 N + d 之间有一步改变之；"
     "持守时之可能持续扩大时，此种步自每一步起皆复现。",
     D('Run.held_change_located', 'Run.held_change_recurs_of_keepsWidening')),
    ("Read on the course's moments. With the part between two moments in the place of the class, where the held "
     "possible keeps widening, from no moment is the course's line under the part unending «不穷»; and where holding is "
     "also decided, a line under the part begins «生» after every moment.",
     "读于进程之时刻。以两时刻间之该部分居类之位，持守时之可能持续扩大时，进程于该部分下之线自无一时刻起不穷；持守亦可判定时，"
     "该部分下之线于每一时刻之后皆有所生。",
     D('Run.not_unending_of_heldKeepsWidening', 'Run.begins_of_heldKeepsWidening')),
    ("A rule changing its own rule. On adaptive F G a step keeps the rule exactly where G leaves it as it is; so the "
     "possible with the rule held keeps widening only where G changes the rule without end, located from every step on "
     "where rules are decided; nothing is added to the whole possible (Run.possible_of_next at adaptive F G).",
     "改变自身规则之规则。于 adaptive F G 上，一步保持规则，恰当 G 使之不变时；故持守规则时之可能仅当 G 无尽地改变规则时持续扩大，"
     "规则可判定时自每一步起可定位；全部可能无所增（Run.possible_of_next 于 adaptive F G）。",
     D('adaptive_keeps_rule_iff', 'Run.adaptive_rule_changes_of_keepsWidening',
       'Run.adaptive_rule_change_recurs_of_keepsWidening')),
    ("Every possibility with some member of a sequence held. On the root, for every carrier and relation R: on a "
     "sequence of relations E n, each included in every later one, where every step of R is alike under some member, "
     "whatever R reaches lies on a line under some member; so where every move of a process holds some member, what it "
     "reaches it reaches with some member held, and so every possibility.",
     "持守某一序列成员时之每一可能。于根上，对每一载体与关系 R：于关系之列 E n（每项含于其后每项）上，R 之每步皆于某成员下同类时，"
     "R 所及者落于某成员下之线上；故过程之每步皆持守某成员时，其所达者于持守某成员时可达，每一可能亦然，反之亦然。",
     D('«及在渐粗列之相续»', 'Reaching.reach_held_of_sequence', 'Reaching.possible_iff_held_of_sequence')),
    ("A tower of rules with no top. A state and a sequence of rules: the move 0 changes the state as the rule at height "
     "0 allows, the move k + 1 the rule at height k as the rule at height k + 1 allows, all else kept, so each rule "
     "changes only as the one above it allows. The move a keeps the rules from height a up, a class coarser with the "
     "height, so each possibility is had with the rules from some height up held.",
     "无顶之规则塔。构型为一状态与一列规则；步 0 依高度 0 之规则改变状态，步 k + 1 依高度 k + 1 之规则改变高度 k 之规则，余皆保持："
     "每一规则仅依其上者所允而变。步 a 保持高度 a 以上之规则，此类随高度渐粗，故每一可能皆可于持守某高度以上诸规则时得之，反之亦然。",
     D('RuleTower.process', 'RuleTower.SameFrom', 'RuleTower.SameFrom.mono', 'RuleTower.sameFrom_class',
       'RuleTower.step_sameFrom', 'RuleTower.possible_iff_held')),
    ("The premise is needed. The same scheme changing every rule at once has a possibility needing the whole tower: with "
     "each rule growing by the one above it, 2 is possible from all rules at 1, but not with the rules from any height up "
     "held, each move changing every rule.",
     "前提不可少。同一方案而同时改变每一规则者，有需整座塔之可能：每一规则皆加其上者时，自诸规则皆为 1 处 2 可能，"
     "然持守任一高度以上之规则时不可能，因每步皆改变每一规则。",
     D('RuleTower.synchronous', 'Synchronous.process', 'Synchronous.adm', 'Synchronous.start',
       'Synchronous.possible_two', 'Synchronous.not_held', 'Synchronous.tower_law_fails')),
    ("Along a course of the tower. Where the possible with the rules from height n up held keeps widening, moves above "
     "n, the only moves that can change a rule from height n up, recur from every step on, located with no decision of "
     "the rules since each move names the one height it can change; the moves at most n reflect that possible, so "
     "every origin of it passes a move above n (Gated.origin).",
     "沿塔之进程。持守高度 n 以上之规则而可能持续扩大时，高于 n 之步（唯一能改高度 n 以上规则者）自每一步起复现，无需判定规则即可定位，"
     "因每步名其唯一能改之高度；至多 n 之步反映该可能，故其每一起源皆经一高于 n 之步（Gated.origin）。",
     D('Run.ruleTower_move_above_recurs_of_keepsWidening', 'RuleTower.reflected', 'RuleTower.held_origin')),
    ("Witness: a raised rule. A configuration is a rule n and a position x; a move raises the rule by one or moves the "
     "position to any x' at most n; (n, x) admits x. Along the course raising the rule at every step, the possible with "
     "the rule held at step k is what lies at most k, so it keeps widening, while every formation is possible from every "
     "configuration; the rule changes at every step.",
     "见证：逐步提升之规则。构型为规则 n 与位置 x；一步或将规则加一，或将位置移至任一至多 n 之 x'；(n, x) 纳 x。沿每步提升规则之进程，"
     "第 k 步持守规则时之可能即至多 k 者，故持续扩大，而自每一构型每一构成皆可能；规则每步皆改变。",
     D('RaisedRule.process', 'RaisedRule.adm', 'RaisedRule.Same', 'RaisedRule.course', 'RaisedRule.rule_changes',
       'RaisedRule.held_trace', 'RaisedRule.held_iff', 'RaisedRule.held_keeps_widening', 'RaisedRule.reach_raise',
       'RaisedRule.whole_every')),
    ("Witness: endless change does not suffice. A move sets the rule to any value or moves the position to any value at "
     "most the rule. Along the course alternating the rule between 0 and 1, the rule changes at every step and every "
     "formation is possible from every configuration, so no list holds the whole possible, yet the possible with the "
     "rule held does not keep widening.",
     "见证：无尽之改变不足。一步或将规则设为任一值，或将位置移至任一至多该规则之值。沿规则于 0 与 1 间交替之进程，规则每步皆改变，"
     "自每一构型每一构成皆可能，故无列表持全部可能，然持守规则时之可能不持续扩大。",
     D('Oscillating.process', 'Oscillating.adm', 'Oscillating.Same', 'Oscillating.flip', 'Oscillating.rule',
       'Oscillating.course', 'Oscillating.cond_not_ne', 'Oscillating.rule_changes', 'Oscillating.every',
       'Oscillating.held_zero', 'Oscillating.converse_fails')),
    ("Witness: a course that only returns. The alternating course returns every two steps, so its first configuration "
     "comes back at arbitrarily late steps; at every step the whole possible exceeds what is admitted, and the possible "
     "with the rule held widens across the first step; yet it does not keep widening.",
     "见证：只回返之进程。交替之进程每两步回返，故其首构型于任意晚之步复现；每一步全部可能皆超出所纳，持守规则时之可能于首步上扩大；"
     "然其不持续扩大。",
     D('Oscillating.returns', 'Oscillating.comes_back', 'Oscillating.exceeds_now', 'Oscillating.held_widens',
       'Oscillating.returning_has_both')),
    ("Witness: a tower copying down. The move k + 1 copies the rule at height k + 1 down to height k, the move 0 "
     "changing nothing; x is admitted where the rule at height x is above x + 1. Along the "
     "course copying down to height k at step k, the possible with the rules from height n up held is what lies below n "
     "or k: it keeps widening for every n, every formation stays possible, and each rule changes once.",
     "见证：向下复制之塔。步 k + 1 将高度 k + 1 之规则复制至高度 k，步 0 无所改；高度 x 之规则大于 x + 1 处纳 x。"
     "沿第 k 步复制至高度 k 之进程，持守高度 n 以上之规则时之可能即小于 n 或小于 k 者，故对每一 n 持续扩大，而每一构成始终可能；"
     "每一规则只改变一次。",
     D('CopyDown.process', 'CopyDown.adm', 'CopyDown.rule', 'CopyDown.rule_below', 'CopyDown.rule_above',
       'CopyDown.course', 'CopyDown.changes_iff', 'CopyDown.rule_next', 'CopyDown.copied', 'CopyDown.held_iff',
       'CopyDown.held_keeps_widening', 'CopyDown.whole_every')),
    ("Witnesses cease under what is held. Read on the course's moments under the rule held, no moment of the raised "
     "rule's course renews «复生», and under the rules from any height up held no moment of the copying course does; so "
     "every moment of both ceases «息» («自不复生则息»), while the held possible keeps widening.",
     "见证于所持守者下皆息。读于进程之时刻，持守规则时提升规则之进程无一时刻复生，持守任一高度以上之规则时复制之进程亦然；"
     "故二者每一时刻皆息（自不复生则息），而持守时之可能持续扩大。",
     D('RaisedRule.not_renews', 'RaisedRule.ceases', 'CopyDown.not_renews', 'CopyDown.ceases')),
    ("Witness: growth relative to what is held with renewal without end. On the raised rule's process, along the course "
     "raising the rule across every even step and keeping it across every odd one, the possible with the rule held "
     "keeps widening, every formation stays possible, and, read on the moments under the rule held, renewal without "
     "end «生生» holds at every even moment, so moment 0 does not cease «生生不息».",
     "见证：相对于所持守者之增长与生生并存。于提升规则之过程上，沿偶数步提升规则、奇数步保持之进程，持守规则时之可能持续扩大，"
     "自每一构型每一构成皆可能；读于持守规则时之时刻，每一偶数时刻皆生生，故时刻 0 不息（生生不息）。",
     D('RaisedEveryOther.odd', 'RaisedEveryOther.rule', 'RaisedEveryOther.step_cases', 'RaisedEveryOther.course',
       'RaisedEveryOther.rule_le', 'RaisedEveryOther.held_iff', 'RaisedEveryOther.held_keeps_widening',
       'RaisedEveryOther.whole_every', 'RaisedEveryOther.renews_without_end', 'RaisedEveryOther.both')),
    ("Witness: off a class the two readings of holding differ. For adjacent-or-equal, which is not transitive, the moves "
     "holding it reach 2 from 0, and 2 is not alike 0; for at-most, which is not symmetric, holding it as at the start "
     "reaches 3 from 0, and holding it move by move does not.",
     "见证：非类之关系上两种持守之读相异。相邻或相等非传递：持守之之步自 0 达 2，而 2 与 0 不同；至多非对称：如起点般持守自 0 达 3，"
     "逐步持守则否。",
     D('AdjacentHeld.process', 'AdjacentHeld.Same', 'AdjacentHeld.differs', 'OrderHeld.process',
       'OrderHeld.not_five_le_three', 'OrderHeld.held_ends', 'OrderHeld.differs')),
]
cited = [n for _, _, ds in groups for n in ds]
assert len(cited) == len(set(cited)), [n for n in cited if cited.count(n) > 1]
assert set(cited) == names, (sorted(names - set(cited)), sorted(set(cited) - names))
laws = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups]

title = capped('title', {'en': 'Where the possible grows', 'zh': '可能者于何处增长'})
statement = capped('statement', {
    'en': "The possible relative to what is held grows only across steps changing what is held, and keeps widening "
          "only where what is held changes without end. Along a course of a stated process nothing is added to the "
          "whole possible, a rule changing its own rule and a tower of rules with no top included.",
    'zh': '相对于所持守者之可能，仅于改变所持守者之步上增长，仅当所持守者无尽地改变时持续扩大。沿一陈述之过程之进程，全部可能无所增，'
          '改变自身规则之规则与无顶之规则塔亦然。'})
hypotheses = [capped('hypotheses', x, item=True) for x in (
    {'en': "No axiom. Each law holds on every process with what each configuration admits given, or on a witness; the "
           "located forms take holding decided along the course, or rules decided; the sequence law takes each member "
           "included in every later one and every move holding some member.",
     'zh': '不加公理。每一律于每一过程（各构型所纳给定）或于一见证上成立；可定位之形需沿进程持守可判定，或规则可判定；序列之律需每一成员含于其后每一成员，'
           '且每步皆持守某一成员。'},
    {'en': "Modelling choices: discrete steps; the held part a relation on configurations read move by move, the same "
           "as holding it as at the start for a class, not in general; formations compared by name over one fixed type; "
           "keeping "
           "widening read from the course's first step; the tower's rules a sequence indexed by the natural numbers, "
           "each move keeping the rules from some height up, its scheme fixed.",
     'zh': '建模之选：离散之步；所持守之部分为构型上之关系，逐步读之，对类而言与如起点般持守相同，一般则否；构成在一固定类型上按名比较；持续扩大自进程首步读；'
           '塔之规则为以自然数为索引之列，每步保持某高度以上之规则，其方案固定。'})]
does_not_show = [capped('does_not_show', x, item=True) for x in (
    {'en': "That growth relative to what is held is growth of the whole possible: along a course of a stated process "
           "the whole possible never grows.",
     'zh': '相对于所持守者之增长即全部可能之增长：沿一陈述之过程之进程，全部可能从不增长。', 'kind': 'non-implication'},
    {'en': "A sufficient condition for keeping widening relative to what is held, beyond the witnesses: endless change "
           "with an unlisted whole possible does not suffice.",
     'zh': '相对于所持守者持续扩大之充分条件（见证之外）：无尽之改变加无列表之全部可能并不足够。', 'kind': 'non-implication'},
    {'en': "Where a change of a general part is located without deciding each step's holding: the law then gives a "
           "bounded stretch not holding it throughout, not a step.",
     'zh': '不判定每步之持守时一般部分之改变位于何处：此时律只给出一不全持守之有界之段，非一步。', 'kind': 'scope'},
    {'en': "That a move above n changes a rule: the tower's law locates moves that can change a rule from height n up, "
           "not a change.",
     'zh': '高于 n 之步改变一规则：塔之律所定位者为能改变高度 n 以上规则之步，非改变本身。', 'kind': 'scope'},
    {'en': "A change of the law of change with no fixed scheme, or a space of rules not given with the carrier: the "
           "tower's scheme is fixed, as the law of any stated process is.",
     'zh': '无固定方案之变化律之变化，或不随载体给出之规则空间：塔之方案固定，如任一陈述之过程之律。', 'kind': 'scope'},
    {'en': "Whether the actual unfolding is a course of a process statable in advance; the possible that cannot be "
           "prestated is outside.",
     'zh': '实际之展开是否为一可预先陈述之过程之进程；不可预先陈述之可能在外。', 'kind': 'scope'},
    {'en': "That growth relative to what is held is better or is the direction of 生生: ranking needs C, and the "
           "reading of 生生不息 here is an AI reading.",
     'zh': '相对于所持守者之增长更好或即生生之方向：排序需要 C，此处对生生不息之读为 AI 之读。', 'kind': 'non-implication'},
    {'en': "A result no neighbouring field states: the held law restates open-ended novelty's innovation, and the "
           "tower law the finite degree of introspection of reflective towers.",
     'zh': '近邻领域无人陈述之结果：持守之律重述开放式新颖之创新，塔之律重述反射塔之有限内省度。', 'kind': 'correspondence'})]
validation_scope = capped('validation_scope', {
    'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.HeldPossible, '
          f'{len(names)} declarations, every one with an empty axiom report, all cited here; the two instance theorems, '
          f'the laws of reach and traces under the held moves, adaptive_keeps_rule_iff and the root law sit in the leaf '
          f'until the owners of the definitions they concern move them. Built in one session; an independent read-only review by a separate AI agent '
          f'(REVIEW-UE11) and a re-check (RECHECK-UE11), in study section {N}; not reviewed by a person.',
    'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.HeldPossible 之 {len(names)} 项声明，公理报告皆空，本记录全引；'
          f'两实例定理、持守之步下之达与迹之律、adaptive_keeps_rule_iff 与根之律暂居此叶，待其所涉定义之主移之。于一会话中构建；另一 AI 代理作独立只读审查'
          f'（REVIEW-UE11）并复查（RECHECK-UE11），见研究第 {N} 节；未经人审。'})
next_delta = capped('next_delta', {
    'en': "A change of the law of change with no fixed scheme, or a space of rules not given with the carrier; a "
          "sufficient condition for keeping widening relative to what is held; review by a person.",
    'zh': '无固定方案之变化律之变化，或不随载体给出之规则空间；相对于所持守者持续扩大之充分条件；人之审查。'})
correspondence = capped('correspondence', {
    'en': "The held law restates open-ended novelty's innovation, novelty that changes the model and with it the "
          "possibilities of variation (Banzhaf and others 2016), which holds there by definition, as a law on any "
          "process. Continuing inheritable change at the highest levels, which McMullin proposed at the York "
          "workshop (Taylor and others 2016), is the informal neighbour of a top fixed for good stopping the growth relative to it; "
          "innovation against fixed-rule systems, found with state-dependent rules (Adams, Zenil, Davies and Walker "
          "2017), is a neighbour of the rule changing its own rule, not the same statement. The tower law's finite "
          "support is, in substance, the finite degree of introspection that lets an infinite tower of reflective "
          "processors be implemented (des Rivières and Smith 1984; Wand and Friedman 1988), restated with its premise "
          "shown needed; Bateson's levels of learning (1972) are the tower's scheme with no law of possibility. The "
          "possible that cannot be prestated (Kauffman 2000; Longo, Montévil and Kauffman 2012) is outside, and "
          "open-endedness relative to an observer (Hughes and others 2024) is an analogue on the side of novelty. "
          "Graded in UE11's NOTE.",
    'zh': '持守之律把开放式新颖之创新（改变模型从而改变变异之可能者之新颖，Banzhaf 等 2016；彼处依定义成立）重述为任一过程上之律。McMullin 于 York 研讨会所提'
          '最高层级之持续可遗传改变（Taylor 等 2016）是顶部永固则相对于之增长止之非形式近邻；以依赖状态之规则所得之、相对于固定规则系统之创新（Adams、Zenil、Davies 与 '
          'Walker 2017）是改变自身规则之规则之近邻，非同一陈述。塔之律之有限支撑，实质上即使无穷反射处理器之塔可实现之有限内省度（des Rivières 与 Smith 1984；'
          'Wand 与 Friedman 1988），此处重述并示其前提不可少；Bateson 之学习层级（1972）即无可能之律之塔之方案。不可预先陈述之可能（Kauffman 2000；Longo、'
          'Montévil 与 Kauffman 2012）在外，相对于观察者之开放性（Hughes 等 2024）为新颖一侧之类比。分级见 UE11 之 NOTE。'})
counterexamples_text = [
    {'en': 'The rule changes at every step and every formation is possible everywhere, yet the possible with the rule '
           'held does not keep widening (Oscillating.converse_fails).',
     'zh': '规则每步皆改变，处处每一构成皆可能，然持守规则时之可能不持续扩大（Oscillating.converse_fails）。'},
    {'en': 'With every rule changed at once, 2 is possible from all rules at 1 but not with the rules from any height '
           'up held (Synchronous.tower_law_fails).',
     'zh': '每一规则同时改变时，自诸规则皆为 1 处 2 可能，然持守任一高度以上之规则时不可能（Synchronous.tower_law_fails）。'},
    {'en': 'Each rule changes once, yet the possible with the rules from every height up held keeps widening '
           '(CopyDown.changes_iff, CopyDown.held_keeps_widening).',
     'zh': '每一规则只改变一次，然持守每一高度以上之规则时之可能持续扩大（CopyDown.changes_iff、CopyDown.held_keeps_widening）。'},
    {'en': 'The possible with the rule held keeps widening while every formation is possible from every configuration '
           'of the course (RaisedRule.held_keeps_widening, RaisedRule.whole_every).',
     'zh': '持守规则时之可能持续扩大，而自进程之每一构型每一构成皆可能（RaisedRule.held_keeps_widening、RaisedRule.whole_every）。'},
    {'en': 'A course returning every two steps has the whole possible exceeding what is admitted at every step and the '
           'held possible widening across a step, yet it does not keep widening (Oscillating.returning_has_both).',
     'zh': '每两步回返之进程，每一步全部可能皆超出所纳，持守时之可能于一步上扩大，然不持续扩大（Oscillating.returning_has_both）。'},
    {'en': 'The held possible keeps widening while every moment ceases under what is held (RaisedRule.ceases, '
           'CopyDown.ceases).',
     'zh': '持守时之可能持续扩大，而于所持守者下每一时刻皆息（RaisedRule.ceases、CopyDown.ceases）。'},
    {'en': 'For a relation that is not transitive, the moves holding it reach what is not alike the start; for one that '
           'is not symmetric, holding it as at the start reaches what holding it move by move does not '
           '(AdjacentHeld.differs, OrderHeld.differs).',
     'zh': '非传递之关系，持守之之步所达者可与起点不同；非对称之关系，如起点般持守所达者，逐步持守未必达（AdjacentHeld.differs、'
           'OrderHeld.differs）。'}]
history_entry = {
    'en': f'{DATE_EN}: added (UE11), where the possible grows: a move adds nothing to the possible under its process; '
          f'the possible relative to what is held grows only across a step changing what is held and keeps widening only '
          f'where it changes without end, which does not suffice and which a course that only returns never has; a rule '
          f'changing its own rule and a tower of rules with no top add nothing to the whole possible, every possibility '
          f'of the tower had below some height, on the root as reach over a sequence growing coarser; growth relative to '
          f'what is held and renewal without end are different relations; near-definitional; after a review and a '
          f're-check; study section {N}.',
    'zh': f'{DATE_ZH}：新增（UE11），可能者于何处增长：一步不给其过程下之可能增添任何东西；相对于所持守者之可能仅于改变所持守者之步上增长，'
          f'仅当该部分无尽地改变时持续扩大，而此不足，只回返之进程亦从无之；改变自身规则之规则与无顶之规则塔皆不给全部可能增添任何东西，'
          f'塔之每一可能皆于某高度之下得之，于根上即渐粗之列上之及；相对于所持守者之增长与生生为不同之关系；近乎定义；经审查与复查；研究第 {N} 节。'}

if CAPS_ONLY:
    print('caps: ok;', len(names), 'declarations in', len(groups), 'laws; statement', len(statement['en']),
          len(statement['zh']), '; validation', len(validation_scope['en']), len(validation_scope['zh']),
          '; next', len(next_delta['en']), len(next_delta['zh']), '; correspondence', len(correspondence['en']),
          len(correspondence['zh']), '; laws max', max(len(x['en']) for x in laws), max(len(x['zh']) for x in laws))
    raise SystemExit(0)

record = {
    'schema_version': 2,
    'id': RID,
    'title': title,
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F07',
    'reviewed_at_utc': NOW,
    'statement': statement,
    'laws': laws,
    'hypotheses': hypotheses,
    'does_not_show': does_not_show,
    'counterexamples': [{'path': LEAN['HeldPossible'], 'detail': x} for x in counterexamples_text],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': validation_scope,
    'next_delta': next_delta,
    'correspondence': correspondence,
    'canonical_source': LEAN['HeldPossible'],
    'aliases': ['Where the possible grows', '可能者于何处增长', 'the held possible', 'the possible relative to what is held',
                'a tower of rules with no top', 'Becoming.Reaching.PossibleHeld', 'Becoming.RuleTower.possible_iff_held'],
    'dependencies': [
        {'id': RID10, 'relation': 'formal-reuse',
         'detail': {'en': 'Reaching.Possible, Reaching.Possible.of_reach, Reaching.KeepsWidening, '
                          'Reaching.KeepsWidening.not_listed, Run.possible_of_next and Run.possible_from_start: the '
                          'possible, nothing added to it along a course, and keeping widening as a chain.',
                    'zh': 'Reaching.Possible、Reaching.Possible.of_reach、Reaching.KeepsWidening、Reaching.KeepsWidening.not_listed、'
                          'Run.possible_of_next 与 Run.possible_from_start：可能者、沿进程其无所增、以链读之持续扩大。'}},
        {'id': 'projection-carrying-a-law', 'relation': 'formal-reuse',
         'detail': {'en': 'adaptive, a state going on under a rule that itself goes on.',
                    'zh': 'adaptive，一状态于自身亦延续之规则下延续。'}},
        {'id': 'every-origin-passes-the-gate', 'relation': 'formal-reuse',
         'detail': {'en': 'Gated.ReflectedBy and Gated.origin: the held possible of the tower reflected by the moves at '
                          'most a height, and every origin of it passing a move above.',
                    'zh': 'Gated.ReflectedBy 与 Gated.origin：塔之持守时之可能为至多某高度之步所反映，其每一起源皆经一更高之步。'}},
        {'id': 'where-a-run-goes-on', 'relation': 'formal-reuse',
         'detail': {'en': 'Onward.within, an instance of the moves holding a part.',
                    'zh': 'Onward.within，持守一部分之步之实例。'}},
        {'id': 'every-loss-passes-a-juncture', 'relation': 'formal-reuse',
         'detail': {'en': 'Branching.keeping, an instance of the moves holding a part.',
                    'zh': 'Branching.keeping，持守一部分之步之实例。'}},
        {'id': 'continuation-relative-to-a-class', 'relation': 'formal-reuse',
         'detail': {'en': '«续», «相续», «及», «类», «粗化», «及之单调», «线内同类», «不穷», «生», «复生», «息», «生生», '
                          '«自不复生则息», «生生不息» and Steps.next: the held moves as continuations, what they reach as a '
                          'line, and the course read on its moments, where they renew, cease or renew without end.',
                    'zh': '«续»、«相续»、«及»、«类»、«粗化»、«及之单调»、«线内同类»、«不穷»、«生»、«复生»、«息»、«生生»、«自不复生则息»、'
                          '«生生不息» 与 Steps.next：持守之步即续，其所达即线，进程读于其时刻，于彼复生、息或生生。'}},
        {'id': 'master-laws-on-the-grammar', 'relation': 'formal-reuse',
         'detail': {'en': '«所闭当且仅当同一或及»: reach is the start or a reach of the steps.',
                    'zh': '«所闭当且仅当同一或及»：所达即起点或诸步之及。'}},
        {'id': 'levels-of-closure', 'relation': 'formal-reuse',
         'detail': {'en': 'reach_iff_withinClosure: reach under a process read as the closure of its steps.',
                    'zh': 'reach_iff_withinClosure：过程下之达读作其步之闭包。'}},
        {'id': 'rest-by-balance', 'relation': 'formal-reuse',
         'detail': {'en': 'Amounts.unmarked_or_marked: the bounded search behind the located forms.',
                    'zh': 'Amounts.unmarked_or_marked：可定位之形背后之有界搜索。'}}],
    'related': [
        {'id': RID10,
         'detail': {'en': 'Its third law, nothing added to the whole possible along a course of one process, read on '
                          'a part held, a rule changing its own rule and a tower of rules with no top.',
                    'zh': '其第三律（沿一过程之进程全部可能无所增），读于持守之部分、改变自身规则之规则与无顶之规则塔。'}},
        {'id': RIDG,
         'detail': {'en': 'Rules that change themselves read in the grammar\'s regularity; here read on what each '
                          'configuration admits: the possible with the rule held grows only where the rule changes.',
                    'zh': '于语法之常性中读自身改变之规则；此处读于各构型所纳：持守规则时之可能仅于规则改变处增长。'}}],
    'references': [{'path': LEAN['HeldPossible'], 'role': 'proof', 'declarations': sorted(names),
                    'sha256': sha(LEAN['HeldPossible'])}]
                  + [{'path': LEAN[m], 'role': 'proof', 'sha256': sha(LEAN[m])}
                     for m in ('ReachableRanges', 'Mechanism', 'Gated', 'Junctures', 'Onward', 'Amounts', 'Change',
                               'Arising', 'Grammar', 'GrammarLaws', 'Frame')]
                  + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                     {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                     {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
                     {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                     {'path': RECHECK, 'role': 'integration', 'sha256': sha(RECHECK)},
                     {'path': CH7, 'role': 'statement', 'sha256': sha(CH7)}],
    'proof_bindings': [{'source': LEAN['HeldPossible'], 'receipt': RECEIPT,
                        'sha256_pointer': '/source_sha256/Becoming.HeldPossible',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [history_entry],
}
deps = [x['id'] for x in record['dependencies']] + [x['id'] for x in record['related']]
for rid in deps:
    assert (RECORDS / f'{rid}.json').exists(), rid
path = RECORDS / f'{RID}.json'
assert not path.exists()
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(names), 'declarations in', len(groups), 'laws')


def load(rid):
    return json.loads((RECORDS / f'{rid}.json').read_text(encoding='utf-8'))


def save(rid, d):
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def history(d, en, zh):
    d['history'].append({'en': f'{DATE_EN}, board item UE11 (study section {N}): {en}',
                         'zh': f'{DATE_ZH}，工作板条目 UE11（研究第 {N} 节）：{zh}'})


# what a course keeps reachable, and rules that change themselves: related to the new record
RELATED = {
    RID10: {'en': 'Where the possible grows: its third law read on a part held, a rule changing its own rule and a tower '
                  'of rules with no top; the possible relative to what is held grows only where what is held changes.',
            'zh': '可能者于何处增长：其第三律读于持守之部分、改变自身规则之规则与无顶之规则塔；相对于所持守者之可能仅于所持守者改变处增长。'},
    RIDG: {'en': 'Where the possible grows: read on what each configuration admits, the possible with the rule held grows '
                 'only where the rule changes, and a tower of rules with no top is one process with a fixed scheme.',
           'zh': '可能者于何处增长：读于各构型所纳，持守规则时之可能仅于规则改变处增长，无顶之规则塔为方案固定之一过程。'}}
for rid, detail in RELATED.items():
    d = load(rid)
    assert RID not in [x['id'] for x in d['related']]
    d['related'].append({'id': RID, 'detail': detail})
    history(d, f'related to {RID}; no statement, next step or declaration changed.',
            f'与 {RID} 相关联；无一陈述、下一步或声明改变。')
    save(rid, d)
print('records related here:', RID10, RIDG)
