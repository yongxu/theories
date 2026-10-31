#!/usr/bin/env python3
"""OU7's landing, parts A and B in one kit. Part A: the corpus's conditional laws (Becoming.GrammarConditionals, a core
leaf), 06's home section and record; the two general laws two of its families rest on, put in Grammar and
GrammarReadings by patch and stated where the laws they generalize are (01 §4 and law 5 of
continuation-relative-to-a-class; 06 §三 and law 4 of classical-definitions-in-the-grammar); the OU plan's line. Part B:
验's model examples (Becoming.RoomNet and Becoming.RoomRuns, two modules of the instance ring, their pieces in check/kit/
beside this folder), a clause in GrammarTesting's header and MapRegions' module doc, 03 §3's home section and record.
The grammar's owner's items, by patch in patches/owner/: GrammarLaws' header; «不出» stated in GrammarLaws with «所闭不出»,
«所闭之界» its case; Flow.Cut written as «不出»; a region not crossed read as one not gone out of either way and as one
closed both ways, so the two count laws read as one (01 §7 and master-laws-on-the-grammar's law 4).

  python3 -B <dir>/integrate_ou7.py anchors                every edit of apply and of the two home sections tried on
                                                           the texts as they stand, nothing written: each anchor is
                                                           found once or its edit is already in place (prepare)
  python3 -B <dir>/integrate_ou7.py apply                  the Grammar, GrammarReadings, MapRegions, PLAN and
                                                           GrammarTesting patches, then every patch in patches/owner/
                                                           in name order (the grammar's owner's items: GrammarLaws'
                                                           header, «不出» moved into GrammarLaws, Flow.Cut written as
                                                           «不出», a region not crossed read two ways); the three
                                                           leaves copied into the package; their joins: the root
                                                           module's imports and notes (part A's after GrammarLaws',
                                                           part B's after RegimeMargin's), the notes and rows saying
                                                           what imports a module the leaves import, the checker's lists
                                                           and scope sentences (GrammarReadings' naming the general
                                                           law), the README rows EN and ZH, the Lean catalogue's
                                                           description of the ring; what the notes, rows and scope
                                                           sentences say of the modules the owner's patches change;
                                                           then each stage's series, in name order
  python3 -B <dir>/integrate_ou7.py audit                  every Lean source the patches changed, against HEAD with
                                                           comments blanked: Grammar and GrammarReadings gain exactly
                                                           their three laws, none removed, every other statement kept,
                                                           the two old laws proved as cases; GrammarLaws gains «不出»
                                                           and «所闭不出» from GrammarCrossing unchanged, «所闭之界»
                                                           proved as the latter's case, and the two readings of a
                                                           region not crossed;
                                                           Flow.Cut's new body unfolds to its old one; no other
                                                           definition changes; every other changed source keeps its
                                                           code; the leaves' imports; the plan line
  python3 -B <dir>/integrate_ou7.py record RECEIPT STUDY   08 §3's receipt sentence, every count read from the receipt,
                                                           and its sentence naming the ring's members;
                                                           06's home section (home-06-section.txt, at the end of §四)
                                                           and its seven lines; 03 §3's (part B's home-03-section-3.txt,
                                                           after testing-within-the-net); regions.json's five entries;
                                                           the two general laws where the laws they generalize are
                                                           (01 §4, 06 §三, and the two records': law, declarations,
                                                           counts from the receipt, history note); the words the
                                                           joins make false in one record (MapRegions no longer a
                                                           leaf); the owner's two records (master-laws-on-the-grammar's
                                                           laws 1 and 4 and 01 §7, not-going-out-of-a-region's
                                                           references, each with a history note); then OU7's two
                                                           records, bound to the receipt
  python3 -B <dir>/integrate_ou7.py register LOG           the apart register, from THEOREM-CONNECTIVITY.py --check's
                                                           log: the leaves' roots with their reasons (part A's from
                                                           reasons() below, part B's from its apart-reasons.json, whose
                                                           roots must be exactly the log's), and the owner's two
                                                           readings of a region not crossed; register entries the
                                                           leaves and patches now use dropped (part B's six and
                                                           «所闭不出» among them); any other stops it
  python3 -B <dir>/integrate_ou7.py check                  after master_laws.py: the data is the landing run's, reads
                                                           both records' laws as they stand, and U4's boundary report
                                                           and the central figures are unchanged from the merged main
  python3 -B <dir>/integrate_ou7.py study N RECEIPT        the study's section N (the next free one), from the receipt,
                                                           a paragraph for each stage in place
  python3 -B <dir>/integrate_ou7.py stages                 the stages selected and the stages in place
  python3 -B <dir>/integrate_ou7.py reason N               the one re-point pass's reason: the kit's, then each stage's

Stages: extra patch sets riding in the same rebuild, each its owner's, in stages/NN-name/ (a series of *.patch made
against the tree after the kit's patches and joins, applied by `apply` after the joins; EXPECTED.json for the audit
and the register; repoint_reason.txt; study.md). A SKIP file or OU7_STAGES leaves a stage out, and a stage whose series
does not apply is dropped: OU7 lands without it (R10).

Run from the checkout root of the landing worktree, in the order land_ou7.sh gives. Each edit asserts that it applies
exactly once, or that it is already applied, so a stage can be rerun after main moves.
"""
import functools
import importlib.util
import json
import os
import re
import shutil
import subprocess
import sys
import textwrap
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PART_B = HERE.parent / 'check/kit'


def load(name):
    spec = importlib.util.spec_from_file_location(name, HERE / f'{name}.py')
    module = sys.modules[name] = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


mr = load('make_record_ou7')    # part A's record, the corpus's conditional laws
mb = load('make_record_ou7b')   # part B's record, rooms tested by a window

PKG = ROOT / mr.PKG
LEAF = ROOT / mr.SOURCE
ROOTMOD = PKG / 'Becoming.lean'
CHECKER = PKG / 'check_becoming.py'
README_EN, README_ZH = PKG / 'README.md', PKG / 'README.zh.md'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
PLAN = ROOT / (RF + 'development/one-unfolding-root/PLAN.md')
HOME = ROOT / mr.CHAPTER
HOME_B = ROOT / mb.CHAPTER
METHOD = ROOT / 'theories/becoming/chapters/08-METHOD.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
MASTER = 'theories/becoming/results/data/master-laws.json'
COVERAGE = ROOT / 'theories/becoming/results/completion/COVERAGE.json'
APART = ROOT / (RF + 'THEOREM-CONNECTIVITY-APART.json')
STUDY = ROOT / (RF + 'BECOMING-RENEWAL-READING.md')
PATCHES = [HERE / 'patches' / n for n in ('Grammar.patch', 'GrammarReadings.patch', 'MapRegions.patch', 'PLAN.patch')] + \
          [PART_B / 'GrammarTesting.patch']
OWNER = sorted((HERE / 'patches/owner').glob('*.patch')) if (HERE / 'patches/owner').is_dir() else []
DEVLINK = 'development/ou7-conditional-laws/'
WRITE = True    # False under `anchors`: every edit is tried and nothing is written


def once(text, old, new, where):
    """Replace `old` by `new` exactly once, or confirm `new` is already in place (checked first, since `new` may
    contain `old`)."""
    if new in text:
        print(f'{where}: already in place')
        return text
    assert text.count(old) == 1, (where, 'expected once', text.count(old))
    print(f'{where}: {"applied" if WRITE else "applies"}')
    return text.replace(old, new)


# ---------------------------------------------------------------------------------------------------------- apply

ENTRY = """* `Becoming.GrammarConditionals` (L1): the corpus's conditional laws (丙一) in the grammar, each
  family written as "Y 当且仅当 Z" or "Z 则 Y" with a net where Z fails and Y fails with it (06 §四, board
  item OU7). Where everything goes on under a coarse class and every step is parted by a fine one, every
  occurrence is generating (`«皆有后而步皆分则全生成»`; day and night, `«昼夜全生成»`); a line none of
  whose places comes back to itself is shorter than any list holding its places (`«线不返则短于所列»`), so
  in bounded room it is not endless (`«不返而有限则非不穷»`); what a class's core puts with an occurrence
  whose line never ends has a line that never ends (`«核同则同不穷»`), as an ending is kept along the core
  (`«亡于核下不变»`) and a beginning along the converse net's (`«生于逆核下不变»`); a dependence (`«依»`) is
  one-way, and where nothing is depended on nothing depends (`«所依无则依者无»`, `«依之传»`). Three
  definitional laws state families exactly (`«亡者异当且仅当有后»`, `«无异当且仅当不分续»`,
  `«皆不生当且仅当皆非无缘»`), and 27 witnesses (`…之例`) give the nets the other modules do not. Which unit
  states which law is an AI reconstruction (the OU7 study's `data/groups.tsv`). A leaf.
"""
SCOPE = ('    "GrammarConditionals: the corpus\'s conditional laws in the grammar, each family with a net where its "\n'
         '    "condition fails and its conclusion with it; where everything goes on under a coarse class and every "\n'
         '    "step is parted by a fine one, every occurrence is generating; a line none of whose places comes back "\n'
         '    "to itself is shorter than any list holding them, so in bounded room it is not endless; what a class\'s "\n'
         '    "core puts with an occurrence whose line never ends has a line that never ends; where nothing is "\n'
         '    "depended on nothing depends, and dependences compose. "\n')
SCOPE_BEFORE = '    "GrammarTesting: the core of a class lies in every stage of its approximation, so what a finite "\n'
ROW_EN = ('| L1 | [`Becoming.GrammarConditionals`](Becoming/GrammarConditionals.lean) | the corpus\'s conditional laws '
          '(丙一) in the grammar, each family with a net where its condition fails (no premise): 相推 gives 全生成 '
          '(`«皆有后而步皆分则全生成»`); a line that does not come back is shorter than any list holding it, so in '
          'bounded room not endless (`«线不返则短于所列»`, `«不返而有限则非不穷»`); what the core puts with an endless '
          'line is endless (`«核同则同不穷»`); where nothing is depended on nothing depends (`«所依无则依者无»`); '
          '27 witnesses |\n')
ROW_ZH = ('| L1 | [`Becoming.GrammarConditionals`](Becoming/GrammarConditionals.lean) | 语料之丙一之律写入文法，每族有其'
          '条件不成立之网（无前提）：相推而全生成（`«皆有后而步皆分则全生成»`）；不返之线短于任一列其处之表，故有界之室'
          '中非不穷（`«线不返则短于所列»`、`«不返而有限则非不穷»`）；核所合于不穷之线者亦不穷（`«核同则同不穷»`）；'
          '所依无则依者无（`«所依无则依者无»`）；见证 27 |\n')

# Part B's joins, beside RegimeMargin's (check/kit/README.md): its bullets and EN rows are part B's; its ZH rows and
# scope sentences are written here, from those and its record's Chinese. Its two modules join the instance ring: they
# read general laws of the core (testing's stages, the map's regions, constancy, the regime's runs) on one named
# carrier, the rooms, which is the ring's definition in the checker (R35b); nothing in the core imports them.
B_LIST = 'INSTANCES'
B_LISTS = {'CORE': ('"Becoming.RegimeMargin", ', '"Becoming.RegimeMargin", "Becoming.RoomNet", "Becoming.RoomRuns", '),
           'INSTANCES': ('"Becoming.PlaceTransitionNets"]',
                         '"Becoming.PlaceTransitionNets", "Becoming.RoomNet", "Becoming.RoomRuns"]')}
IMPORTS_B = ('import Becoming.RegimeMargin\n', 'import Becoming.RegimeMargin\nimport Becoming.RoomNet\nimport Becoming.RoomRuns\n')
BULLETS_B = (PART_B / 'becoming-lean-bullets.txt').read_text(encoding='utf-8')
ROWS_B_EN = (PART_B / 'package-readme-rows.txt').read_text(encoding='utf-8')
ROWS_B_ZH = (
    '| L1 | [`Becoming.RoomNet`](Becoming/RoomNet.lean) | 以窗验室，验之模型之例（无伦理谓词；水平以整单位计，开窗作为'
    '可选之枝入网）：一则生成无给之室与二恒温器之网，诸室作为规则并列相较；不开窗时，诸室于其设定水平同属一核类'
    '（`Rooms.«不开窗则同核»`）；窗入网而余量为正时，水平之第一层分无给之室与每一有给之室（`Rooms.«开窗则一层可分»`），以温与否，'
    '至层数等于余量之层始分之（`Rooms.«开窗以温层如其余乃分»`），二有给之室仍同属一类（`Rooms.«有给之室以温不可分»`）；'
    '余量为三时，给过所取之恒温器为相杂之域之模型之例（`Rooms.«给过所取则生守相杂»`），无给之室守而有终'
    '（`Rooms.«平衡守而有终»`），开窗之后新而尽（`Rooms.«开窗则平衡新而尽»`）；于每一正余量，给如所取之恒温器全守'
    '（`Rooms.«给如所取则全守»`）；于每一正余量，温有常恰在有给之处（`Rooms.«温有常当且仅当有给»`），余量二以上，温之线'
    '不穷亦恰在彼处（`Rooms.«温不穷当且仅当有给»`），须此余量（`Rooms.unended_at_one`），跨诸室 `«有常则往不穷»` 之逆不成立'
    '（`Rooms.joint_converse`）；'
    '`«恒温与平衡»` 之枝与判语于余量一推出（`Rooms.toy_branches`、`Rooms.toy_verdict`）；交换之前读水平，余量为三时窗移'
    '二恒温器之水平（`Rooms.before_window_moves`）。`Becoming.RoomRuns` 导入之（工作板条目 OU7） |\n'
    '| L1 | [`Becoming.RoomRuns`](Becoming/RoomRuns.lean) | 诸室开窗之进程作为运行（无伦理谓词）：开窗时，此则即 '
    '`RegimeMargin.step`，热源之所给为其所给（`Rooms.next_open`、`Rooms.window_line`），故无给之室自其余量之步起皆冷'
    '（`Rooms.Unheated.window_cold`，由 `RegimeMargin.stays_ended`），于正余量给如所取之恒温器守其设定水平'
    '（`Rooms.Matched.window_held`，由 `RegimeMargin.holds`），余量为三时给过所取者之进程于 `3, 4` 间交替，即 '
    '`RegimeMargin.Alternation` 之进程移二（`Rooms.Overshooting.alternation_shifted`），虽 `holds` 之条件于它不成立'
    '（`Rooms.Overshooting.holds_one_way`）；此诸进程无一持续扩大（`Rooms.Unheated.not_widening`、'
    '`Rooms.Matched.not_widening`、`Rooms.Overshooting.not_widening`）；就其时刻读之，给过所取者之进程全生成，无给之室之进程无一时刻如是，'
    '于正余量给如所取者之进程亦然（`Rooms.Overshooting.generation_at_moments`、`Rooms.Matched.no_generation_at_moments`、'
    '`Rooms.Unheated.no_generation_at_moments`）；粗线即持温之可能（`Rooms.line_iff_held`、'
    '`Rooms.heated_possible_held`、`Rooms.Unheated.cold_not_held`）。叶（工作板条目 OU7） |\n')
SCOPE_B = (
    '    "RoomNet: one rule makes the nets of an unheated room and two thermostats: a level in whole units moves "\n'
    '    "one unit a step toward its surroundings, at the set level m while the window is shut and at 0 once it "\n'
    '    "opens, and a heater reading the level after that exchange gives c wherever it is below m; the window\'s "\n'
    '    "opening is in the net as an alternative, and the rooms are compared as rules side by side. While no "\n'
    '    "window opens every room at its set level is one core class at the level, at every margin; with the "\n'
    '    "window in the net, at every positive margin, the level\'s first stage tells the unheated room from every "\n'
    '    "heated one; under warm or not, at a margin of n + 1 draws, stage n holds and stage n + 1 tells them "\n'
    '    "apart, and two heated rooms stay one core class; the branches the toy of testing stipulates are the "\n'
    '    "rule\'s at a margin of one, and its verdict follows. At a margin of three the overshooting thermostat is "\n'
    '    "a model case of the mixed region, and the unheated room keeps and reaches an end and, once open, "\n'
    '    "degenerates while renewing; at every positive margin the matched thermostat is 全守, as every room is "\n'
    '    "while no window opens, and warmth is constant exactly where the heater gives and, from a margin of two, "\n'
    '    "unended exactly there; across rooms the converse of «有常则往不穷» fails. "\n'
    '    "RoomRuns: with the window open the rooms\' rule is RegimeMargin\'s step with the heater\'s giving, so "\n'
    '    "the unheated room is cold from its margin\'s step on, at a positive margin the matched thermostat holds "\n'
    '    "its set level, and at a margin of three the overshooting course is Alternation\'s run shifted by two "\n'
    '    "though holds\'s condition fails for it; none of these three courses keeps widening; read on its moments "\n'
    '    "the overshooting course is 全生成 and no moment of the unheated course, or of the matched one at a positive "\n'
    '    "margin, is; a coarse line is the possible with warmth held. "\n')
SCOPE_B_BEFORE = '    "Regulation: with balance, the joint exchange is within the gap to m on both sides exactly "\n'
# GrammarReadings' scope sentence states the general law of passing through, as its note in the root module does.
SCOPE_READINGS = ('    "line with a past never ends going, what abides passes through (通), going and coming, where a class is "\n'
                  '    "constant both ways, and constancy one way is not enough; continuation is neither identity nor mere "\n'
                  '    "difference; the conditioning occurrence "\n',
                  '    "line with a past never ends going and, where a class is constant both ways, passes through (通), "\n'
                  '    "going and coming, what abides being a case, and constancy one way is not enough; continuation is "\n'
                  '    "neither identity nor mere difference; the conditioning occurrence "\n')
# The ring's own descriptions name its carriers: the checker's comment on INSTANCES and the README's summary row.
RING_COMMENT = ('# on one named carrier (the Changes, place/transition nets); applications are leaves nothing in the\n'
                '# core imports. Both are held to the core\'s conditions (prelude only, empty axiom reports) and sit\n'
                '# outside it by direction: no core module but the root `Becoming` imports a ring module, and no\n'
                '# instance imports an application (`ring_direction`).\n',
                '# on one named carrier (the Changes, place/transition nets, rooms tested by a window); applications\n'
                '# are leaves nothing in the core imports. Both are held to the core\'s conditions (prelude only, empty\n'
                '# axiom reports) and sit outside it by direction: no core module but the root `Becoming` imports a\n'
                '# ring module, and no instance imports an application (`ring_direction`).\n')
# The Lean catalogue's description of the ring, rendered into the index pages (LEAN-INDEX and becoming-ring).
CATALOGUE = ROOT / 'tools/research/lean_catalogue.py'
RING_CATALOGUE = ('instances read general laws on one carrier (the Changes, place/transition nets), applications are leaves',
                  'instances read general laws on one carrier (the Changes, place/transition nets, rooms tested by a window), '
                  'applications are leaves')
RING_ROWS = {'README.md': ('the Changes (`Becoming.Hexagrams`, `HexagramPlaces`, `HexagramCommuting`, `HexagramLaws`, '
                           '`HexagramSites`, `HexagramSequences`) and `Becoming.PlaceTransitionNets`. Applications',
                           'the Changes (`Becoming.Hexagrams`, `HexagramPlaces`, `HexagramCommuting`, `HexagramLaws`, '
                           '`HexagramSites`, `HexagramSequences`), `Becoming.PlaceTransitionNets` and the rooms tested by '
                           'a window (`Becoming.RoomNet`, `RoomRuns`). Applications'),
             'README.zh.md': ('`HexagramSites`、`HexagramSequences`）与 `Becoming.PlaceTransitionNets`。应用',
                              '`HexagramSites`、`HexagramSequences`）、`Becoming.PlaceTransitionNets` 与以窗所验之室'
                              '（`Becoming.RoomNet`、`RoomRuns`）。应用')}

# What imports a module, where its note in the root module or its README row says so: the modules the leaves import
# (GrammarConditionals imports GrammarCandidates and GrammarLaws; RoomNet GrammarTesting, GrammarLaws, GrammarReadings
# and MapRegions; RoomRuns RoomNet, RegimeMargin and HeldPossible; the audit checks these imports).
NOTES = [('GrammarCandidates', ' A leaf.', ' Imported by `Becoming.GrammarConditionals`.'),
         ('GrammarReadings', 'Imported by\n  `Becoming.GrammarCandidates`.',
          'Imported by\n  `Becoming.GrammarCandidates` and `Becoming.RoomNet`.'),
         ('GrammarTesting', 'Imported by `Becoming.GrammarCases`.',
          'Imported by\n  `Becoming.GrammarCases` and `Becoming.RoomNet`.'),
         ('MapRegions', 'kept in a leaf, since\n  most of the package depends on it. A carrying renewal begins no line of '
                        'the pattern (`«传则粗不生»`), and a beginning of a\n  part is, as far as can be refuted, a '
                        'beginning of the pattern or the end of a carrying renewal\n',
          'kept in a module\n  of their own, since most of the package depends on it. A carrying renewal begins no line '
          'of the\n  pattern (`«传则粗不生»`), and a beginning of a part is, as far as can be refuted, a beginning of\n'
          '  the pattern or the end of a carrying renewal\n'),
         ('MapRegions', 'A leaf (board item GW).', 'Imported by `Becoming.RoomNet` (board items GW, OU7).'),
         # GrammarReadings now states the general law of passing through, the old one its case.
         ('GrammarReadings', 'what abides passes through\n  where a class is constant both ways (`«两向有常则通»`), and '
                             'constancy one way is not enough\n  (`«有常而不通»`); in a net',
          'what has a predecessor passes\n  through where a class is constant both ways (`«两向有常有前则通»`, what '
          'abides being its\n  case), and constancy one way is not enough (`«有常而不通»`); in a net'),
         ('HeldPossible', 'Imported\n  by `Becoming.Tasks`, `Becoming.CausalGrowth` and `Becoming.WideningOnTheMap` '
                          '(board items UE11,\n  GW).',
          'Imported\n  by `Becoming.Tasks`, `Becoming.CausalGrowth`, `Becoming.WideningOnTheMap` and `Becoming.RoomRuns`'
          '\n  (board items UE11, GW, OU7).')]
ROW_NOTES = [('README.md', 'MapRegions', 'A leaf (board item GW) |', 'Imported by `Becoming.RoomNet` (board items GW, OU7) |'),
             ('README.zh.md', 'MapRegions', '叶（工作板条目 GW） |', '`Becoming.RoomNet` 导入之（工作板条目 GW、OU7） |')]
IMPORTS = {mr.SOURCE: ['Becoming.GrammarCandidates', 'Becoming.GrammarLaws'],
           mb.MODULES['Becoming.RoomNet']: ['Becoming.GrammarTesting', 'Becoming.GrammarLaws', 'Becoming.GrammarReadings',
                                            'Becoming.MapRegions'],
           mb.MODULES['Becoming.RoomRuns']: ['Becoming.RoomNet', 'Becoming.RegimeMargin', 'Becoming.HeldPossible']}

# The grammar's owner's three items, held until BD2 landed (patches/owner/02-04): «不出» and «所闭不出» stated in
# GrammarLaws beside «闭», «所闭之界» «所闭不出»'s case at two occurrences; Flow.Cut written as «不出» at a valuation's
# relation
# (Standpoints), the old body once unfolded; a region not crossed read two ways, so that the two count laws read as one
# law on regions not gone out of either way. What the root module's notes, the README rows and the checker's scope
# sentences say of the modules they change.
OWNER_NOTES = [
    ('GrammarLaws', '  (board items OU3f, HE). Under the converse the closure is the closure read backward\n',
     '  (board items OU3f, HE). An occurrence\'s closure is not gone out of (`«不出»`, `«所闭不出»`, with\n'
     '  `«所闭之界»` its case; board items BD2, OU7). Under the converse the closure is the closure read backward\n'),
    ('GrammarLaws', '  (`«计»`, the region read as a test), a pairing keeps the count on every region the relation does\n'
                    '  not cross (`«对则不越域守数»`), and under a class decided by a test it is exactly equal count in\n',
     '  (`«计»`, the region read as a test), a pairing keeps the count on every region not gone out of\n'
     '  either way, which is exactly one the relation does not cross and one closed both ways\n'
     '  (`«对则不越域守数»`, `GrammarLaws.uncrossed_iff_notGoingOut`, `GrammarLaws.uncrossed_iff_closed`;\n'
     '  board items BD2, OU7), and under a class decided by a test it is exactly equal count in\n'),
    ('GrammarCrossing', '* `Becoming.GrammarCrossing` (L1): not going out of a region (`«不出»`), for every carrier, relation\n'
                        '  and region (board item BD2). A closed region is not gone out of (`«闭则不出»`), an occurrence\'s '
                        'closure\n  among them (`«所闭不出»`, the closure law `«所闭之界»` read through `«不出»`); not going '
                        'out of a\n',
     '* `Becoming.GrammarCrossing` (L1): not going out of a region (the grammar\'s `«不出»`, in\n'
     '  `Becoming.GrammarLaws`), for every carrier, relation and region (board item BD2). A closed region is\n'
     '  not gone out of (`«闭则不出»`), an occurrence\'s closure among them (`«所闭不出»`, a law of closure in\n'
     '  `Becoming.GrammarLaws`); not going out of a\n'),
    ('ConveyanceBoundaries', 'the cut keeps its definition in `Becoming.Standpoints`.',
     'the cut is defined in `Becoming.Standpoints` as `«不出»` at the valuation\'s relation.')]
OWNER_ROW_NOTES = [
    ('README.md', 'GrammarLaws', 'from where it holds on (`kept_onward`), the closure under the converse',
     'from where it holds on (`kept_onward`), an occurrence\'s closure not gone out of (`«不出»`, `«所闭不出»`), the '
     'closure under the converse'),
    ('README.md', 'GrammarLaws', 'a pairing keeps the count on every region the relation does not cross (`«对则不越域守数»`) '
                                 'and,',
     'a pairing keeps the count on every region not gone out of either way, which is one the relation does not cross '
     'and one closed both ways (`«对则不越域守数»`, `GrammarLaws.uncrossed_iff_notGoingOut`, '
     '`GrammarLaws.uncrossed_iff_closed`) and,'),
    ('README.md', 'GrammarCrossing', '| not going out of a region, for every carrier,',
     '| not going out of a region (the grammar\'s `«不出»`, in `Becoming.GrammarLaws`), for every carrier,'),
    ('README.md', 'GrammarCrossing', 'a closure among them (`«所闭不出»`, the closure law read through `«不出»`);',
     'a closure among them (`«所闭不出»`, a law of closure in `Becoming.GrammarLaws`);'),
    ('README.zh.md', 'GrammarLaws', '（`kept_onward`），逆关系下之闭包为闭包之逆读',
     '（`kept_onward`），一发生之闭包不出（`«不出»`、`«所闭不出»`），逆关系下之闭包为闭包之逆读'),
    ('README.zh.md', 'GrammarLaws', '配对守其关系所不越之每一域之数（`«对则不越域守数»`），',
     '配对守两向皆不出之每一域之数，此域即关系所不越者，亦即两向皆闭者（`«对则不越域守数»`、'
     '`GrammarLaws.uncrossed_iff_notGoingOut`、`GrammarLaws.uncrossed_iff_closed`），'),
    ('README.zh.md', 'GrammarCrossing', '| 不出一域，于每一载体、',
     '| 不出一域（文法之 `«不出»`，在 `Becoming.GrammarLaws`），于每一载体、'),
    ('README.zh.md', 'GrammarCrossing', '所闭亦然（`«所闭不出»`，即闭包之律经不出读之）；',
     '所闭亦然（`«所闭不出»`，`Becoming.GrammarLaws` 中闭包之一律）；')]
OWNER_SCOPES = [
    ('    "on, the closure under the converse is the closure read backward, a closure through borrowed steps lies "\n',
     '    "on, an occurrence\'s closure is not gone out of, the closure under the converse is the closure read "\n'
     '    "backward, a closure through borrowed steps lies "\n'),
    ('    "region, a pairing keeps the count on every region the relation does not cross and under a class decided by "\n',
     '    "region, a pairing keeps the count on every region not gone out of either way, which is one the relation "\n'
     '    "does not cross and one closed both ways, and under a class decided by "\n'),
    ('    "of, an occurrence\'s closure among them; the two coincide where membership is stable, and that they coincide "\n',
     '    "of; the two coincide where membership is stable, and that they coincide "\n')]


def git(*args, check=True):
    return subprocess.run(['git', *args], cwd=ROOT, capture_output=True, text=True, check=check)


def apply_patches():
    for p in PATCHES + OWNER:
        if git('apply', '--check', str(p), check=False).returncode == 0:
            git('apply', str(p))
            print(f'{p.name}: applied')
        elif git('apply', '--reverse', '--check', str(p), check=False).returncode == 0:
            print(f'{p.name}: already in place')
        else:
            sys.exit(f'{p.name} neither applies nor is in place: main moved under it; rebase the patch and rerun')


# --------------------------------------------------------------------------------------------------------- stages

# Extra patch sets that ride in the same rebuild, each its owner's (U4c's census laws, ND's renames): a directory
# stages/NN-name/ holding a series of *.patch files, made against the tree after the kit's patches and joins and the
# stages before it, applied in name order. A stage may also hold EXPECTED.json (merged into the audit's and the
# register's, below), repoint_reason.txt (joined to the kit's, for the one re-point pass) and study.md (its paragraph
# in the study section). A SKIP file in it skips it, and OU7_STAGES, when set, names the stages taken ('none' takes
# none). A stage whose series does not apply is dropped, and OU7 lands without it (R10). Every later step reads only
# the stages in place.
STAGES = HERE / 'stages'
STAGE_KEYS = {'added', 'cases', 'moved', 'redefined', 'restated', 'renamed', 'roots', 'now_used'}


def selected_stages():
    found = sorted(d for d in STAGES.iterdir() if d.is_dir()) if STAGES.is_dir() else []
    wanted = os.environ.get('OU7_STAGES')
    if wanted is not None:
        names = set(wanted.replace(',', ' ').split()) - {'none'}
        unknown = names - {d.name for d in found}
        if unknown:
            sys.exit(f'OU7_STAGES names no stage: {sorted(unknown)}')
        found = [d for d in found if d.name in names]
    return [d for d in found if not (d / 'SKIP').exists()]


def series(stage):
    return [str(x) for x in sorted(stage.glob('*.patch'))]


def applied_stages():
    """The selected stages whose series are in place, found from the last back: a stage is in place when its series
    reverses on the tree as it stands, once every later stage in place has been reversed first."""
    later, out = [], []
    for stage in reversed(selected_stages()):
        trial = later + series(stage)[::-1]
        if series(stage) and git('apply', '--reverse', '--check', *trial, check=False).returncode == 0:
            later, out = trial, [stage] + out
    return out


def apply_stages():
    stages, applied = selected_stages(), applied_stages()
    last = max((stages.index(s) for s in applied), default=-1)
    for i, stage in enumerate(stages):
        patches = series(stage)
        if stage in applied:
            print(f'stage {stage.name}: already in place')
        elif not patches:
            print(f'stage {stage.name}: no patch')
        elif i < last:
            print(f'stage {stage.name}: DROPPED, not in place while a later stage is; OU7 lands without it (R10)')
        elif git('apply', '--check', *patches, check=False).returncode == 0:
            git('apply', *patches)
            print(f'stage {stage.name} ({len(patches)} patches): applied')
        else:
            print(f'stage {stage.name}: DROPPED, its series does not apply to the tree after the kit and the stages '
                  'before it; OU7 lands without it (R10)')


def stage_data():
    """Each applied stage with its EXPECTED.json (or nothing), its keys checked, in order."""
    out = []
    for stage in applied_stages():
        path = stage / 'EXPECTED.json'
        data = json.loads(path.read_text(encoding='utf-8')) if path.exists() else {}
        assert set(data) <= STAGE_KEYS, (stage.name, 'EXPECTED.json: unknown keys', sorted(set(data) - STAGE_KEYS))
        out.append((stage, data))
    return out


def show_stages():
    print('stages selected:', ' '.join(s.name for s in selected_stages()) or 'none')
    print('stages in place:', ' '.join(s.name for s in applied_stages()) or 'none')


def reason(n):
    """The one re-point pass's reason: the kit's, then each applied stage's repoint_reason.txt, {N} the study
    section."""
    texts = [(HERE / 'repoint_reason.txt').read_text(encoding='utf-8').strip()]
    texts += [(s / 'repoint_reason.txt').read_text(encoding='utf-8').strip() for s in applied_stages()
              if (s / 'repoint_reason.txt').exists()]
    return ' '.join(texts).replace('{N}', str(n))


def leaves():
    """The three leaves: each kit copy (part B's in its scratch tree) and its place in the package."""
    return [(HERE / 'Becoming/GrammarConditionals.lean', LEAF)] + \
           [(kit, ROOT / mb.MODULES[m]) for m, kit in mb.KIT_LEAVES.items()]


def span(t, module):
    """Where `module`'s note in the root module's doc starts and ends."""
    head = f'* `Becoming.{module}` ('
    assert t.count(head) == 1, ('the root module has not one note for', module)
    s = t.index(head)
    return s, t.index('\n* `Becoming.', s)


def note_once(t, module, old, new):
    s, e = span(t, module)
    return t[:s] + once(t[s:e], old, new, f'root module, {module}\'s note') + t[e:]


def after_note(t, module, block, name, where):
    """`block`, the notes of new modules, after `module`'s note, or confirm it is in place."""
    if block in t:
        print(f'{where}: already in place')
        return t
    assert f'* `Becoming.{name}`' not in t, f'a different note for {name} is in place'
    nxt = span(t, module)[1] + 1
    print(f'{where}: {"applied" if WRITE else "applies"}')
    return t[:nxt] + block + t[nxt:]


def row(r, module):
    found = list(re.finditer(r'^\| L\d \| \[`Becoming\.' + re.escape(module) + r'`\][^\n]*\n', r, re.M))
    assert len(found) == 1, ('README rows for', module, len(found))
    return found[0].span()


def after_row(r, module, rows, name, where):
    if rows in r:
        print(f'{where}: already in place')
        return r
    assert f'[`Becoming.{name}`]' not in r, (where, f'a different row for {name} is in place')
    end = row(r, module)[1]
    print(f'{where}: {"applied" if WRITE else "applies"}')
    return r[:end] + rows + r[end:]


def row_once(r, module, old, new, where):
    s, e = row(r, module)
    return r[:s] + once(r[s:e], old, new, where) + r[e:]


def join():
    for kit, leaf in leaves():
        if leaf.exists():
            assert leaf.read_bytes() == kit.read_bytes(), ('the package has a different', leaf.name)
            print(f'{leaf.name}: already in place')
        else:
            if WRITE:
                shutil.copyfile(kit, leaf)
            print(f'{leaf.name}: {"copied into the package" if WRITE else "to be copied into the package"}')
    t = ROOTMOD.read_text(encoding='utf-8')
    t = once(t, 'import Becoming.GrammarLaws\n', 'import Becoming.GrammarLaws\nimport Becoming.GrammarConditionals\n',
             'root module, import (A)')
    t = once(t, *IMPORTS_B, 'root module, imports (B)')
    t = after_note(t, 'GrammarLaws', ENTRY, 'GrammarConditionals', 'root module, note (A)')
    t = after_note(t, 'RegimeMargin', BULLETS_B, 'RoomNet', 'root module, notes (B)')
    for module, old, new in NOTES + OWNER_NOTES:
        t = note_once(t, module, old, new)
    c = CHECKER.read_text(encoding='utf-8')
    c = once(c, '"Becoming.GrammarLaws", ', '"Becoming.GrammarLaws", "Becoming.GrammarConditionals", ',
             'checker, core list (A)')
    c = once(c, *B_LISTS[B_LIST], f'checker, {B_LIST} list (B)')
    if B_LIST == 'INSTANCES':
        c = once(c, *RING_COMMENT, 'checker, the ring\'s comment (B)')
    assert c.count('"Becoming.RoomNet"') == c.count('"Becoming.RoomRuns"') == 1, 'part B\'s leaves in more than one list'
    c = once(c, SCOPE_BEFORE, SCOPE + SCOPE_BEFORE, 'checker, scope sentence (A)')
    c = once(c, SCOPE_B_BEFORE, SCOPE_B + SCOPE_B_BEFORE, 'checker, scope sentences (B)')
    c = once(c, *SCOPE_READINGS, 'checker, GrammarReadings\' scope sentence (the general law)')
    for old, new in OWNER_SCOPES:
        c = once(c, old, new, 'checker, a scope sentence of a module the owner\'s patches change')
    readmes = {}
    for path, row_a, rows_b in [(README_EN, ROW_EN, ROWS_B_EN), (README_ZH, ROW_ZH, ROWS_B_ZH)]:
        r = path.read_text(encoding='utf-8')
        r = after_row(r, 'GrammarLaws', row_a, 'GrammarConditionals', f'{path.name}, row (A)')
        r = after_row(r, 'RegimeMargin', rows_b, 'RoomNet', f'{path.name}, rows (B)')
        for name, module, old, new in ROW_NOTES + OWNER_ROW_NOTES:
            if name == path.name:
                r = row_once(r, module, old, new, f'{path.name}, {module}\'s row')
        if B_LIST == 'INSTANCES':
            r = once(r, *RING_ROWS[path.name], f'{path.name}, the ring\'s row (B)')
        readmes[path] = r
    k = CATALOGUE.read_text(encoding='utf-8')
    if B_LIST == 'INSTANCES':
        k = once(k, *RING_CATALOGUE, 'Lean catalogue, the ring\'s description (B)')
    if WRITE:
        ROOTMOD.write_text(t, encoding='utf-8')
        CHECKER.write_text(c, encoding='utf-8')
        for path, r in readmes.items():
            path.write_text(r, encoding='utf-8')
        CATALOGUE.write_text(k, encoding='utf-8')


def apply():
    apply_patches()
    join()
    apply_stages()


def anchors():
    """Every edit of apply and of the two home sections, tried on the texts as they stand, nothing written."""
    global WRITE
    WRITE = False
    join()
    home()
    home_root()
    home_b()
    ring_sentence()
    owner_texts(*(json.loads((ROOT / f'theories/becoming/results/records/{rid}.json').read_text(encoding='utf-8'))
                  for rid in (MASTER_REC, CROSSING_REC)))
    print('the owner\'s record words: found once or already in place in', MASTER_REC, 'and', CROSSING_REC)
    assert len(SENTENCE.findall(METHOD.read_text(encoding='utf-8'))) == 1, '08 §3: the receipt sentence is not there once'
    print('08 §3: the receipt sentence found once')
    print('anchors: every edit applies exactly once or is already in place; nothing written')


# ---------------------------------------------------------------------------------------------------------- audit

def statements(text):
    """Each declaration's statement (its header up to the first `:=`, or the whole command for one without),
    whitespace collapsed, from the code with comments blanked; and each declaration's whole text."""
    code = mr.code(text)
    heads = list(re.finditer(r'^(?:theorem|def|structure|inductive|abbrev|instance) (\S+)', code, re.M))
    out, whole = {}, {}
    for i, m in enumerate(heads):
        end = heads[i + 1].start() if i + 1 < len(heads) else len(code)
        body = code[m.start():end]
        body = re.split(r'^(?:end |section|namespace|/-!|variable)', body, maxsplit=1, flags=re.M)[0]
        out['Becoming.' + m.group(1)] = ' '.join(body.split(':=', 1)[0].split())
        whole['Becoming.' + m.group(1)] = ' '.join(body.split())
    return out, whole


EXPECTED = {'Becoming.Grammar': ({'Becoming.«位核含于逆核»', 'Becoming.«生于逆核下不变»'},
                                 {'Becoming.«生于位核下不变»': '«生于逆核下不变» hE («位核含于逆核» R E y y\' hk) hy'}),
            'Becoming.GrammarReadings': ({'Becoming.«两向有常有前则通»'},
                                         {'Becoming.«两向有常则通»': '«两向有常有前则通» hE hc hc\' hx.1'}),
            # The owner's patches: GrammarLaws gains «不出» and «所闭不出» (MOVED) and the two readings of a region not
            # crossed, and proves «所闭之界» as «所闭不出»'s case; GrammarCrossing loses the two; Standpoints writes
            # Flow.Cut anew (REDEFINED).
            'Becoming.GrammarLaws': ({'Becoming.«不出»', 'Becoming.«所闭不出»',
                                      'Becoming.GrammarLaws.uncrossed_iff_notGoingOut',
                                      'Becoming.GrammarLaws.uncrossed_iff_closed'},
                                     {'Becoming.«所闭之界»': '«所闭不出» R x y z within beyond'}),
            'Becoming.GrammarCrossing': (set(), {}),
            'Becoming.Standpoints': (set(), {})}
# Declarations an owner's patch moves, each keeping its statement (a definition its body too): name: (from, to).
MOVED = {'Becoming.«不出»': ('Becoming.GrammarCrossing', 'Becoming.GrammarLaws'),
         'Becoming.«所闭不出»': ('Becoming.GrammarCrossing', 'Becoming.GrammarLaws')}
# A definition an owner's patch writes anew: its old body, its new one, and the definition the new one unfolds with
# the names it reads at: Flow.Cut as «不出» at the valuation's relation, which unfolds to the old body word for word.
REDEFINED = {'Becoming.Cut': ("∀ e e', region e → ¬ region e' → ¬ V.related e e'", '«不出» V.related region',
                              'Becoming.«不出»', {'R': 'V.related', 'P': 'region', 'x': 'e', 'y': "e'"})}


def source_of(module):
    return mr.PKG + 'Becoming/' + module[len('Becoming.'):].replace('.', '/') + '.lean'


def expectations():
    """The audit's expectations: the kit's EXPECTED, MOVED and REDEFINED, with each applied stage's EXPECTED.json
    merged in. A stage's keys, every name as the audit keys it ('Becoming.' and the name as written in its source):
    added {module: [names]}, naming every module whose code the stage changes, with the names it adds (possibly none);
    cases {module: {name: the proof that makes it a case}}; moved {name: [from module, to module]}; redefined {name:
    [old body, new body, the definition it unfolds with, {bound name: argument}]}; restated {name: why its statement
    changes}; renamed {old: new}, the statement kept but for the name."""
    expected = {m: (set(added), dict(cases)) for m, (added, cases) in EXPECTED.items()}
    moved, redefined, restated, renamed = dict(MOVED), dict(REDEFINED), {}, {}
    for stage, data in stage_data():
        for module, names in data.get('added', {}).items():
            expected.setdefault(module, (set(), {}))[0].update(names)
        for module, cases in data.get('cases', {}).items():
            expected.setdefault(module, (set(), {}))[1].update(cases)
        for name, (source, target) in data.get('moved', {}).items():
            moved[name] = (source, target)
            expected.setdefault(source, (set(), {}))
            expected.setdefault(target, (set(), {}))[0].add(name)
        redefined.update({n: tuple(entry) for n, entry in data.get('redefined', {}).items()})
        restated.update(data.get('restated', {}))
        renamed.update(data.get('renamed', {}))
    return expected, moved, redefined, restated, renamed


def unfold(body, names):
    """A definition's body read at given arguments: each of its bound names replaced."""
    return re.sub(r"(?<![\w'.])(" + '|'.join(map(re.escape, names)) + r")(?![\w'.])", lambda m: names[m.group(1)], body)


def audit():
    """The Lean sources the patches changed, against HEAD. Those whose code a patch changes are held to the
    expectations (the kit's Grammar and GrammarReadings, the owner's GrammarLaws, GrammarCrossing and Standpoints, and
    each applied stage's): their declarations added and removed, the moved ones with nothing changed, the renamed ones
    changed only in name, every other statement kept but those a stage restates, no definition's body changed but a
    redefined one, which must unfold to its old body. Every other changed source (GrammarTesting's header clause,
    MapRegions' doc, the owner's GrammarLaws header and ConveyanceBoundaries' doc) keeps its code, comments blanked."""
    problems = []
    expected_all, moved, redefined, restated, renamed = expectations()
    changed = [p for p in git('diff', '--name-only', 'HEAD', '--', mr.PKG + 'Becoming/').stdout.split()
               if p.endswith('.lean')]
    expected = {source_of(m): m for m in expected_all}
    seen = {}       # module: its statements and whole declarations, before and after
    for path in sorted(set(changed) | set(expected)):
        if path not in changed:
            problems.append((path, 'unchanged: its patch is not applied'))
            continue
        before_text = git('show', 'HEAD:' + path).stdout
        after_text = (ROOT / path).read_text(encoding='utf-8')
        if path not in expected:
            if mr.code(before_text) != mr.code(after_text):
                problems.append((path, 'its code changed and EXPECTED does not cover it'))
            print(path.rsplit('/', 1)[-1], 'changed in its comments only' if mr.code(before_text) == mr.code(after_text)
                  else 'CHANGED IN ITS CODE')
            continue
        module = expected[path]
        added, cases = expected_all[module]
        before, whole_before = statements(before_text)
        after, whole = statements(after_text)
        seen[module] = (before, after, whole_before, whole)
        renames = {old: new for old, new in renamed.items() if old in before}
        if set(after) - set(before) != added | set(renames.values()):
            problems.append((module, 'added', sorted(set(after) - set(before))))
        if set(before) - set(after) != {n for n, (source, _) in moved.items() if source == module} | set(renames):
            problems.append((module, 'removed', sorted(set(before) - set(after))))
        for old, new in renames.items():
            if after.get(new) != before[old].replace(old[len('Becoming.'):], new[len('Becoming.'):], 1):
                problems.append((module, 'renamed, not in name only', old, new))
        kept = [n for n in before if n in after]
        heads = [n for n in kept if before[n] != after[n]]
        if [n for n in heads if n not in restated]:
            problems.append((module, 'statements changed', [n for n in heads if n not in restated]))
        for n in heads:
            if n in restated:
                print(module, 'restated, as its stage says:', n, '-', restated[n])
        rewritten = [n for n in kept if not whole_before[n].startswith('theorem ') and whole_before[n] != whole[n]
                     and n not in redefined and n not in restated]
        if rewritten:
            problems.append((module, 'definitions changed', rewritten))
        for name, proof in cases.items():
            if ' '.join(proof.split()) not in whole.get(name, ''):
                problems.append((module, 'not proved as a case', name))
        print(module, len(before), '->', len(after), 'declarations; added', sorted(set(after) - set(before)),
              'removed', sorted(set(before) - set(after)))
    for name, (source, target) in moved.items():
        if source not in seen or target not in seen:
            problems.append(('moved, but a module is unchanged', name, source, target))
            continue
        old, new = seen[source][2].get(name, ''), seen[target][3].get(name, '')
        if seen[source][0].get(name) != seen[target][1].get(name) or (not old.startswith('theorem ') and old != new):
            problems.append(('moved, not unchanged', name))
    for name, (old, new, by, names) in redefined.items():
        bodies = [(s[2][name].split(':=', 1)[1].strip(), s[3][name].split(':=', 1)[1].strip())
                  for s in seen.values() if name in s[2] and name in s[3]]
        unfolded = [unfold(s[3][by].split(':=', 1)[1].strip(), names) for s in seen.values() if by in s[3]]
        if bodies != [(old, new)] or unfolded != [old]:
            problems.append(('redefined, not as its old body unfolded', name, bodies, unfolded))
    for path, wanted in IMPORTS.items():
        imports = re.findall(r'^import (\S+)', (ROOT / path).read_text(encoding='utf-8'), re.M)
        if imports != wanted:
            problems.append(('the imports of', path, imports))
    plan = PLAN.read_text(encoding='utf-8')
    if '生只在双向之核下不变' in plan or '生在逆缘之核下不变（`«生于逆核下不变»`）' not in plan:
        problems.append(('the OU plan line',))
    for p in problems:
        print('PROBLEM', p)
    assert not problems
    print('audit: the kit\'s patches add only their three laws, the two old laws their cases; the owner\'s move «不出» '
          'and «所闭不出» into GrammarLaws unchanged, prove «所闭之界» as the latter\'s case, add the two readings of a '
          'region not crossed, and write Flow.Cut as what unfolds to its old body; every other statement is kept and '
          'every other changed source keeps its code; the leaves import what their notes say; the plan line is '
          'replaced; stages in place:', ' '.join(s.name for s in applied_stages()) or 'none')


# ---------------------------------------------------------------------------------------------------------- record

# 08 §3's sentence naming the core receipt and its counts (U1b's integrate_u1b.py, the same pattern).
SENTENCE = re.compile(
    r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
    r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
    r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
    r"modules were kept out of the run\.")


def receipt_sentence(receipt):
    r = json.loads((ROOT / receipt).read_text(encoding='utf-8'))
    assert r['status'] == 'passed'
    mr.receipt_modules(receipt)
    mb.receipt_modules(receipt)
    stamp = Path(receipt).parent.name
    layers = {}
    for m in r['modules']:
        count = layers.setdefault(m['layer'], [0, 0])
        count[0] += 1
        count[1] += m['theorems']
    assert set(layers) <= {'foundation', 'core', 'instance', 'application'}, set(layers)
    modules = sum(v[0] for v in layers.values())
    theorems = sum(v[1] for v in layers.values())
    assert modules == len(r['core_closure']), (modules, len(r['core_closure']))
    ring = layers.get('instance', [0, 0])[0] + layers.get('application', [0, 0])[0]
    declarations = sum(len(m['declarations']) for m in r['modules'])
    injeq = sum(1 for name, axioms in r['generated_axiom_dependencies'].items()
                if name.endswith('.injEq') and axioms == ['propext'])
    assert injeq == len(r['generated_axiom_dependencies']), 'a generated dependency other than injEq on propext'
    link = '../../../' + receipt
    counts = (f"At core receipt [`{stamp}`]({link}) (Lean 4.29.1), the closure held {modules} modules "
              f"({layers['foundation'][0]} foundation, {layers['core'][0]} core, {ring} in the instance and application "
              f"ring) and {theorems:,} theorems; the {layers['core'][0]} core modules held {layers['core'][1]:,} of them; "
              f"{declarations:,} declarations were audited; {injeq} generated `injEq` lemmas depend on `propext`; "
              f"{len(r['superseded_modules'])} superseded modules were kept out of the run.")
    text = METHOD.read_text(encoding='utf-8')
    text, k = SENTENCE.subn(lambda m: counts, text)
    assert k == 1, k
    METHOD.write_text(text, encoding='utf-8')
    print('08 §3:', counts[:160], '…')


# 08 §3 names the ring's members. The rooms join the instances where part B is in the ring (B_LIST, as for the ring's
# other texts), and the applications are counted from the checker's list either way: main says six, though
# APPLICATIONS has held seven since RF6.1 added OpenedCorrection (30 October).
RING_SENTENCE = re.compile(r'The instance and application ring \(the Changes and place/transition nets; \w+ leaf applications\)')
NUMBERS = ('no', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'eleven', 'twelve')


def ring_sentence():
    """08 §3's sentence naming the ring's members: the rooms among the instances, the applications counted."""
    listed = re.search(r'^APPLICATIONS = \[(.*)\]$', CHECKER.read_text(encoding='utf-8'), re.M).group(1)
    n = len(re.findall(r'"Becoming\.[^"]+"', listed))
    members = ('the Changes, place/transition nets and rooms tested by a window' if B_LIST == 'INSTANCES'
               else 'the Changes and place/transition nets')
    new = f'The instance and application ring ({members}; {NUMBERS[n]} leaf applications)'
    text = METHOD.read_text(encoding='utf-8')
    if new in text:
        print('08 §3: the sentence naming the ring is already in place')
        return
    assert len(RING_SENTENCE.findall(text)) == 1, '08 §3: the sentence naming the ring is not there once'
    text = RING_SENTENCE.sub(lambda m: new, text)
    if WRITE:
        METHOD.write_text(text, encoding='utf-8')
    print(f'08 §3: the ring named, {new[new.index(";") + 2:-1]}{"" if WRITE else " (applies)"}')


SECTION = (HERE / 'home-06-section.txt').read_text(encoding='utf-8')
OLD_SENTENCE = '八部文本之 162 条丙一之律尚未逐条写成“Y 当且仅当 Z”；后加三部文本的 181 条乙类候选尚未检验（[未决](#open)）。\n'
NEW_SENTENCE = '后加三部文本的 181 条乙类候选尚未检验（[未决](#open)）。\n'
LINK = '[§四](#r-conditional-laws-of-the-corpus)'
LINES = [
    ('thesis, §四',
     '另三条归错或表达不了（§四）；',
     '另三条归错或表达不了；219 条丙一之律逐族写成，各有其条件不成立之网，6 条依其读法不成立（§四）；'),
    ('thesis, open',
     '162 条丙一之律与另 181 条候选',
     '另 181 条乙类候选与“穷 → 变 → 通”所言何变'),
    ('§三, 通 and 息',
     '仍未证者：“穷 → 变 → 通”之序在何处成立（[未决](#open)）。',
     f'“穷 → 变 → 通”之读见 {LINK}：读變为一次之异，三者是合取，无序可求；读變为「一闔一闢」，通之一步依定义；'
     '文本所言是哪一种變，仍未决（[未决](#open)）。'),
    ('open, 丙一',
     '- **丙一与新候选。** 八部文本之 162 条丙一之律尚未逐条写成“Y 当且仅当 Z”；后加三部文本的 181 条乙类候选尚未检验。',
     f'- **新候选与丙一之读。** 后加三部文本的 181 条乙类候选尚未检验。丙一 219 条之读（{LINK}）无人审过，其中三处仍是疑问 '
     '[AI reading]：「衡不正」是反转其衡，还是只不保其序（G22；若只不保其序，「重縣於仰」不随之）；《起信论》之相應是否读作'
     '同在核之一类（G15，JS-326；须遍检其书相應之用，JS-318 在内）；無明是否在其煩惱染法之中（G15，JS-318；若在，JS-318 '
     '否定 JS-326 之读所用之前提）。'),
    ('open, 穷 → 变 → 通',
     '- **穷 → 变 → 通。** `«通»` 已依往来定义，`«息»` 已正面定义；“穷 → 变 → 通”之序在其下何处成立，尚未证明'
     '（[§三](#tong-and-xi)）。',
     '- **穷 → 变 → 通。** 文本所言是哪一种變 [AI reading]：读作一次之异，三者是合取，无序可求；读作「一闔一闢」，通之一步'
     f'依定义（{LINK}，[§三](#tong-and-xi)）。'),
    # The home of classical-definitions-in-the-grammar's law 4, generalized (GENERAL below): its table row and reading.
    ('§三, 通 in the table',
     '类（等价之类）于缘与其逆两向皆有常时，住者通（`«两向有常则通»`）',
     '类（等价之类）于缘与其逆两向皆有常时，有前者通（`«两向有常有前则通»`），住者是其一例（`«两向有常则通»`）'),
    ('§三, 通 in the reading',
     '类于两向皆有常时，住者通（`«两向有常则通»`）',
     '类于两向皆有常时，有前者通（`«两向有常有前则通»`；住者是其一例，`«两向有常则通»`）'),
]

# The two general laws are stated where the laws they generalize are, as a change to a result's statement goes to its
# record and its home section: 01 §4 with law 5 of continuation-relative-to-a-class, and 06 §三 (LINES above) with law 4
# of classical-definitions-in-the-grammar. OU7's record names them in its prose and depends on both records. 01 §7 is
# the home of master-laws-on-the-grammar, whose law 4 the owner's item 3 reads as one law (OWNER_RECORDS below).
ROOT_CHAPTER = ROOT / 'theories/becoming/chapters/01-ROOT.md'
ROOT_LINES = [(
    '§4, beginning kept along the converse net\'s core',
    'The two-way core is the greatest symmetric relation inside `E` constant both ways (`«位根»`) and lies inside the '
    'core (`«位核含于核»`). For a class, ending is not told apart by the core (`«亡于核下不变»`) and beginning not by the '
    'two-way core (`«生于位核下不变»`), so what shares a position under the two-way core shares beginning and ending '
    '(`«位同则生亡同»`), and abiding too (`«位同则住同»`).',
    'The two-way core is the greatest symmetric relation inside `E` constant both ways (`«位根»`); it lies inside the '
    'core (`«位核含于核»`) and inside the core of the converse net (`«位核含于逆核»`). For a class, ending is not told '
    'apart by the core (`«亡于核下不变»`) and, the mirror, beginning not by the core of the converse net '
    '(`«生于逆核下不变»`), so neither by the two-way core (`«生于位核下不变»`): what shares a position under the two-way '
    'core shares beginning and ending (`«位同则生亡同»`), and abiding too (`«位同则住同»`). The forward core can tell '
    'beginnings apart, and the core of the converse net relates pairs that neither the core nor the two-way core '
    'relates ([06](06-CLASSICAL-TEXTS.md#r-conditional-laws-of-the-corpus)).'), (
    '§7, balance on every region not gone out of either way',
    'a pairing keeps the count on every region the relation does not cross (`«对则不越域守数»`), so on every region '
    'closed under it and its converse (`«对则双闭域守数»`), closed one way not being enough (`«对而单闭域不守数之例»`);',
    'a pairing keeps the count on every region not gone out of either way, which is exactly a region the relation '
    'does not cross (`GrammarLaws.uncrossed_iff_notGoingOut`) and a region closed under it and its converse '
    '(`GrammarLaws.uncrossed_iff_closed`): one law, read either way (`«对则不越域守数»`, `«对则双闭域守数»`), closed '
    'one way not being enough (`«对而单闭域不守数之例»`);')]
GENERAL = [
    {'rid': 'continuation-relative-to-a-class', 'module': 'Becoming.Grammar', 'law': 5,
     'en': ('Read both ways, constant under 缘 and under its converse, the core carries beginning, abiding and ending: '
            'for a class, what the two-way core relates shares beginning, abiding and ending',
            'For a class, ending is kept along the core and, its mirror, beginning along the core of the converse net; '
            'the two-way core, constant both ways, lies inside both, so what it relates shares beginning, abiding and '
            'ending'),
     'zh': ('双向读之（对缘及其逆皆有常），对一个类，双向之核所关联者生同、住同、亡同',
            '对一个类，亡沿核不变，与之相映，生沿逆缘之核不变；双向之核（两向皆有常）在二者之内，故其所关联者'
            '生同、住同、亡同'),
     'after': [('Becoming.«位核含于核»', 'Becoming.«位核含于逆核»'), ('Becoming.«亡于核下不变»', 'Becoming.«生于逆核下不变»')],
     'family': ('of 前際 and 後際', '前际后际'),
     'what': ('beginning is kept along the core of the converse net («生于逆核下不变»), which holds the two-way core '
              '(«位核含于逆核»), the mirror of ending kept along the core; «生于位核下不变» is proved as its case, its '
              'statement unchanged',
              '生沿逆缘之核不变（«生于逆核下不变»），此核含双向之核（«位核含于逆核»），与亡沿核不变相映；«生于位核下不变» '
              '证为其一例，陈述不变')},
    {'rid': 'classical-definitions-in-the-grammar', 'module': 'Becoming.GrammarReadings', 'law': 4,
     'en': ('an occurrence that abides passes through where the class is constant both ways;',
            'where the class is constant both ways, an occurrence with a predecessor passes through, what abides being '
            'a case;'),
     'zh': ('类于缘与其逆两向皆有常时，住者通；', '类于缘与其逆两向皆有常时，有前者通，住者是其一例；'),
     'after': [('Becoming.«有常则往不穷»', 'Becoming.«两向有常有前则通»')],
     'family': ('of 通', '通'),
     'what': ('where a class is constant both ways, what has a predecessor passes through («两向有常有前则通»); '
              '«两向有常则通», for what abides, is proved as its case, its statement unchanged',
              '类两向有常时，有前者通（«两向有常有前则通»）；«两向有常则通»（住者）证为其一例，陈述不变')},
]


def home():
    text = HOME.read_text(encoding='utf-8')
    if mr.ANCHOR in text:
        assert SECTION in text, 'a different home section is in place: remove it and rerun'
        print('06 §四: the home section is already in place')
    else:
        assert text.count(OLD_SENTENCE) == 1, '06 §四 no longer ends with the sentence on the 丙一 laws: place by hand'
        start, end = text.index('<a id="grammar-theorems"></a>'), text.index('<a id="the-changes"></a>')
        assert start < text.index(OLD_SENTENCE) < end, 'the sentence is no longer in §四'
        text = text.replace(OLD_SENTENCE, SECTION + '\n' + NEW_SENTENCE)
        print(f'06 §四: the home section in place of the sentence on the 丙一 laws{"" if WRITE else " (applies)"}')
    for where, old, new in LINES:
        text = once(text, old, new, '06, ' + where)
    if WRITE:
        HOME.write_text(text, encoding='utf-8')


def home_root():
    """01 §4, the home of law 5 of continuation-relative-to-a-class, generalized; 01 §7, the home of
    master-laws-on-the-grammar, whose law 4 reads its two count laws as one."""
    text = ROOT_CHAPTER.read_text(encoding='utf-8')
    for where, old, new in ROOT_LINES:
        text = once(text, old, new, '01, ' + where)
    if WRITE:
        ROOT_CHAPTER.write_text(text, encoding='utf-8')


def insert_after(names, pairs, where):
    """`names` with each new name after its anchor, or as it is where every new name is already there."""
    out = list(names)
    for anchor, name in pairs:
        if name in out:
            continue
        assert out.count(anchor) == 1, (where, 'anchor not there once', anchor)
        out.insert(out.index(anchor) + 1, name)
    return out


def general_records(receipt, study):
    """The two records whose laws the patches generalize: the law's statement, its declarations and the source's
    reference, the validation scope's counts (read from the receipt, each the old count plus the declarations added),
    reviewed_at_utc and a history note. Each step is skipped where it is already in place."""
    from datetime import datetime, timezone
    data = json.loads((ROOT / receipt).read_text(encoding='utf-8'))
    mods = {m['module']: m for m in data['modules']}
    stamp = Path(receipt).parent.name
    day = datetime.now(timezone.utc).replace(microsecond=0)
    for g in GENERAL:
        path = ROOT / f"theories/becoming/results/records/{g['rid']}.json"
        r = json.loads(path.read_text(encoding='utf-8'))
        law = r['laws'][g['law'] - 1]
        for lang in ('en', 'zh'):
            old, new = g[lang]
            if new not in law[lang]:
                assert law[lang].count(old) == 1, (g['rid'], lang, 'the law moved')
                law[lang] = law[lang].replace(old, new)
        added = [name for _, name in g['after']]
        law['declarations'] = insert_after(law['declarations'], g['after'], g['rid'] + ' law')
        source = mr.BELOW[g['module']]
        ref = next(x for x in r['references'] if x['path'] == source)
        ref['declarations'] = insert_after(ref['declarations'], g['after'], g['rid'] + ' reference')
        m = mods[g['module']]
        theorems, declarations = m['theorems'], len(m['declarations'])
        assert set(added) <= {d['name'] for d in m['declarations']}, (g['module'], 'the receipt lacks', added)
        short = g['module']
        for lang, pattern, form in [('en', re.escape(short) + r', (\d+) theorems in (\d+) declarations',
                                     f'{short}, {theorems} theorems in {declarations} declarations'),
                                    ('zh', re.escape(short) + r'，(\d+) 个声明中 (\d+) 条定理',
                                     f'{short}，{declarations} 个声明中 {theorems} 条定理')]:
            found = re.findall(pattern, r['validation_scope'][lang])
            assert len(found) == 1, (g['rid'], lang, 'the counts are not there once')
            a, b = map(int, found[0])
            t_old, d_old = (a, b) if lang == 'en' else (b, a)
            if (t_old, d_old) != (theorems, declarations):
                assert (t_old + len(added), d_old + len(added)) == (theorems, declarations), \
                    (g['rid'], lang, 'the old counts plus the added declarations are not the receipt\'s',
                     (t_old, d_old), (theorems, declarations))
                r['validation_scope'][lang] = re.sub(pattern, form, r['validation_scope'][lang])
        if not any('board item OU7' in h.get('en', '') for h in r['history']):
            k = len(added)
            r['history'].append({
                'en': f"{day.day} {day:%B %Y}, board item OU7 (study section {study}): law {g['law']} generalized, as the "
                      f"corpus's family {g['family'][0]} needed (conditional-laws-of-the-corpus): {g['what'][0]}. The "
                      f"law and the {source.rsplit('/', 1)[-1]} reference gain {k} declaration{'s' if k > 1 else ''}; the "
                      f"validation scope's counts are receipt {stamp}'s. Nothing else the record states changed.",
                'zh': f"{day.year}年{day.month}月{day.day}日，工作板条目 OU7（研究第 {study} 节）：律 {g['law']} 推广，为语料之"
                      f"{g['family'][1]}之族所需（conditional-laws-of-the-corpus）：{g['what'][1]}。律与 "
                      f"{source.rsplit('/', 1)[-1]} 之引用增 {k} 声明；验证范围之数目为收据 {stamp} 者。记录所述余无改变。"})
            r['reviewed_at_utc'] = day.isoformat()
        path.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
        print(f"{g['rid']}: law {g['law']} generalized, {', '.join(added)} declared; counts {theorems} theorems in "
              f"{declarations} declarations; history note in place")


# A record whose words the joins make false: once RoomNet imports MapRegions, MapRegions is no longer a leaf.
RECORD_WORDS = {'generation-and-degeneration-at-two-grains': (
    [('validation_scope', 'en', 'a core leaf importing GrammarMap only', 'a core module importing GrammarMap only'),
     ('validation_scope', 'zh', 'MapRegions（GW1、GW2，核心叶）', 'MapRegions（GW1、GW2，核心模块）')],
    ('Becoming.RoomNet imports Becoming.MapRegions, so the validation scope calls MapRegions a core module, not a '
     'leaf, as its module doc now does',
     'Becoming.RoomNet 导入 Becoming.MapRegions，故验证范围称 MapRegions 为核心模块而非叶，与其模块说明今之所言同'))}


def record_words(study):
    """The words of RECORD_WORDS, each with a history note; each step skipped where it is already in place."""
    from datetime import datetime, timezone
    day = datetime.now(timezone.utc).replace(microsecond=0)
    for rid, (edits, (why_en, why_zh)) in RECORD_WORDS.items():
        path = ROOT / f'theories/becoming/results/records/{rid}.json'
        r = json.loads(path.read_text(encoding='utf-8'))
        for field, lang, old, new in edits:
            if new not in r[field][lang]:
                assert r[field][lang].count(old) == 1, (rid, field, lang, 'the words moved')
                r[field][lang] = r[field][lang].replace(old, new)
        if not any('board item OU7' in h.get('en', '') for h in r['history']):
            r['history'].append({
                'en': f"{day.day} {day:%B %Y}, board item OU7 (study section {study}): {why_en}. Nothing else the "
                      "record states changed.",
                'zh': f"{day.year}年{day.month}月{day.day}日，工作板条目 OU7（研究第 {study} 节）：{why_zh}。记录所述余无改变。"})
            r['reviewed_at_utc'] = day.isoformat()
        path.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
        print(f'{rid}: {len(edits)} words corrected; history note in place')


# The two records the owner's patches change. master-laws-on-the-grammar: law 1 and the GrammarLaws reference gain
# «不出» and «所闭不出»; law 4 reads its two count laws as one law on regions not gone out of either way (its home, 01 §7,
# in ROOT_LINES) and, with the reference, gains the two readings of a region not crossed. not-going-out-of-a-region:
# «不出» and «所闭不出» are GrammarLaws' now, so a GrammarLaws reference and proof binding hold them and its reuse of the
# closure law says so. Each validation scope names the landing receipt and its counts.
MASTER_REC, CROSSING_REC = 'master-laws-on-the-grammar', 'not-going-out-of-a-region'
NOT_CROSSED = ['Becoming.GrammarLaws.uncrossed_iff_notGoingOut', 'Becoming.GrammarLaws.uncrossed_iff_closed']
LAW4 = {'en': ('a pairing keeps the count on every region the relation does not cross, so on every region closed under '
               'it and its converse, closed one way not being enough',
               'a pairing keeps the count on every region not gone out of either way, which is exactly a region the '
               'relation does not cross and one closed under it and its converse, closed one way not being enough'),
        'zh': ('配对守其关系所不越之每一域之数，故守对关系及其逆皆封闭之每一域之数，单向封闭不足',
               '配对守两向皆不出之每一域之数，此域恰是关系所不越者，亦恰是对关系及其逆皆封闭者，单向封闭不足')}
REUSE = {'en': ('«闭», «所闭», «闭之及» and «所闭之界» from the closure law, «所闭不出» being «所闭之界» read through «不出».',
                '«闭», «所闭», «闭之及» and «所闭之界» from the closure law, which GrammarLaws states through «不出» as '
                '«所闭不出», «所闭之界» its case at two occurrences.'),
         'zh': ('«闭»、«所闭»、«闭之及» 与 «所闭之界» 出自闭包之律；«所闭不出» 即经 «不出» 所读之 «所闭之界»。',
                '«闭»、«所闭»、«闭之及» 与 «所闭之界» 出自闭包之律；GrammarLaws 经 «不出» 陈此律为 «所闭不出»，'
                '«所闭之界» 为其于二发生处之例。')}
COUNTS = {MASTER_REC: ('Becoming.GrammarLaws', r'Becoming\.GrammarLaws, (\d+) theorems in (\d+) declarations',
                       r'GrammarLaws (\d+) 项声明中 (\d+) 条定理',
                       'Becoming.GrammarLaws, {t} theorems in {d} declarations', 'GrammarLaws {d} 项声明中 {t} 条定理'),
          CROSSING_REC: ('Becoming.GrammarCrossing',
                         r'Becoming\.GrammarCrossing, (\d+) declarations \((\d+) theorems\)'
                         r'(?:, with «不出» and «所闭不出» in Becoming\.GrammarLaws)?',
                         r'Becoming\.GrammarCrossing (\d+) 项声明（(\d+) 条定理）(?:及 Becoming\.GrammarLaws 之 «不出»、«所闭不出»)?',
                         'Becoming.GrammarCrossing, {d} declarations ({t} theorems), with «不出» and «所闭不出» in '
                         'Becoming.GrammarLaws',
                         'Becoming.GrammarCrossing {d} 项声明（{t} 条定理）及 Becoming.GrammarLaws 之 «不出»、«所闭不出»')}


def owner_texts(master, crossing):
    """The words and declaration lists the owner's patches change in the two records, each step skipped where it is
    already in place (anchors() tries them on the records as they stand)."""
    law1, law4 = master['laws'][0], master['laws'][3]
    for lang, (old, new) in LAW4.items():
        if new not in law4[lang]:
            assert law4[lang].count(old) == 1, (MASTER_REC, 'law 4', lang, 'the words moved')
            law4[lang] = law4[lang].replace(old, new)
    moved = sorted(MOVED)
    law1['declarations'] = insert_after(law1['declarations'], [('Becoming.«闭»', 'Becoming.«不出»'),
                                                                ('Becoming.«所闭之对称»', 'Becoming.«所闭不出»')],
                                        MASTER_REC + ' law 1')
    law4['declarations'] = insert_after(law4['declarations'], [('Becoming.«对则双闭域守数»', NOT_CROSSED[0]),
                                                                (NOT_CROSSED[0], NOT_CROSSED[1])], MASTER_REC + ' law 4')
    ref = next(x for x in master['references'] if x['path'] == source_of('Becoming.GrammarLaws'))
    ref['declarations'] = insert_after(ref['declarations'], [('Becoming.«闭»', 'Becoming.«不出»'),
                                                              ('Becoming.«所闭之对称»', 'Becoming.«所闭不出»'),
                                                              ('Becoming.GrammarLaws.uncrossed_of_closed', NOT_CROSSED[0]),
                                                              (NOT_CROSSED[0], NOT_CROSSED[1])],
                                       MASTER_REC + ' GrammarLaws reference')
    reuse = next(d for d in crossing['dependencies'] if d['id'] == MASTER_REC)['detail']
    for lang, (old, new) in REUSE.items():
        if reuse[lang] != new:
            assert reuse[lang] == old, (CROSSING_REC, 'its reuse of the closure law', lang, 'the words moved')
            reuse[lang] = new
    assert set(moved) <= set(law1['declarations']) and set(moved) <= {d for law in crossing['laws']
                                                                      for d in law['declarations']}


def owner_records(receipt, study):
    """The two records the owner's patches change: owner_texts, then not-going-out-of-a-region's references and proof
    binding, each validation scope's receipt and counts (each the old count with what the patches add or move, checked
    against the receipt), reviewed_at_utc and a history note. Each step is skipped where it is already in place."""
    from datetime import datetime, timezone
    data = json.loads((ROOT / receipt).read_text(encoding='utf-8'))
    mods = {m['module']: m for m in data['modules']}
    stamp = Path(receipt).parent.name
    day = datetime.now(timezone.utc).replace(microsecond=0)
    laws_source, crossing_source = source_of('Becoming.GrammarLaws'), source_of('Becoming.GrammarCrossing')
    held = {d['name'] for d in mods['Becoming.GrammarLaws']['declarations']}
    named = set(MOVED) | set(NOT_CROSSED)
    assert named <= held, ('the receipt\'s GrammarLaws lacks', named - held)

    def counted(text):
        whole = statements(text)[1]
        return sum(w.startswith('theorem ') for w in whole.values()), len(whole)
    # What each module's count changes by, read from its source against HEAD: GrammarLaws gains the moved and the new,
    # GrammarCrossing loses the moved, and either changes by what an applied stage adds, moves or renames there.
    delta = {}
    for rid in (MASTER_REC, CROSSING_REC):
        path = source_of(COUNTS[rid][0])
        (t1, d1), (t0, d0) = counted((ROOT / path).read_text(encoding='utf-8')), counted(git('show', 'HEAD:' + path).stdout)
        delta[rid] = (t1 - t0, d1 - d0)
    paths = {rid: ROOT / f'theories/becoming/results/records/{rid}.json' for rid in (MASTER_REC, CROSSING_REC)}
    recs = {rid: json.loads(path.read_text(encoding='utf-8')) for rid, path in paths.items()}
    owner_texts(recs[MASTER_REC], recs[CROSSING_REC])
    crossing = recs[CROSSING_REC]
    ref = next(x for x in crossing['references'] if x['path'] == crossing_source)
    ref['declarations'] = [d for d in ref['declarations'] if d not in MOVED]
    if not any(x['path'] == laws_source for x in crossing['references']):
        crossing['references'].insert(crossing['references'].index(ref) + 1, {
            'path': laws_source, 'role': 'proof', 'sha256': mr.digest(laws_source), 'declarations': sorted(MOVED)})
    if not any(b['source'] == laws_source for b in crossing['proof_bindings']):
        crossing['proof_bindings'].append({'source': laws_source, 'receipt': receipt,
                                           'sha256_pointer': '/source_sha256/Becoming.GrammarLaws',
                                           'success_pointer': '/status', 'success_value': 'passed'})
    notes = {MASTER_REC: (
        "the grammar's owner's items held from BD2 (patches/owner/02-04). «不出» and «所闭不出» are stated in "
        "GrammarLaws beside «闭», moved from GrammarCrossing with their statements unchanged, and «所闭之界» is proved "
        "as «所闭不出» at two occurrences, its statement unchanged: law 1 and the GrammarLaws reference gain the two. "
        "A region not crossed is exactly one not gone out of either way and one closed both ways "
        "(GrammarLaws.uncrossed_iff_notGoingOut, GrammarLaws.uncrossed_iff_closed, BD2's text), so law 4 reads its "
        "two count laws as one law on regions not gone out of either way, and its home in 01 §7 says the same: law 4 "
        f"and the reference gain the two. The validation scope's receipt and counts are receipt {stamp}'s.",
        "文法之主人于 BD2 所留之项（patches/owner/02-04）。«不出» 与 «所闭不出» 陈于 GrammarLaws，在 «闭» 旁，自 "
        "GrammarCrossing 移来，陈述不变；«所闭之界» 证为 «所闭不出» 于二发生处之例，陈述不变：律 1 与 GrammarLaws 之引用"
        "增此二者。关系所不越之域恰是两向皆不出者，亦恰是两向皆闭者（GrammarLaws.uncrossed_iff_notGoingOut、"
        "GrammarLaws.uncrossed_iff_closed，BD2 之文），故律 4 读其二守数之律为两向皆不出之域上之一律，其归处 01 §7 亦如是"
        f"言：律 4 与其引用增此二者。验证范围之回执与数目为收据 {stamp} 者。"),
        CROSSING_REC: (
        "«不出» and «所闭不出» are now stated in GrammarLaws beside «闭» (the grammar's owner's item held from BD2, "
        "patches/owner/02), their statements unchanged: they move from the GrammarCrossing reference to a GrammarLaws "
        "reference and proof binding, the reuse of the closure law says that GrammarLaws states it through «不出», and "
        f"the validation scope's receipt and GrammarCrossing's counts are receipt {stamp}'s.",
        "«不出» 与 «所闭不出» 今陈于 GrammarLaws，在 «闭» 旁（文法之主人于 BD2 所留之项，patches/owner/02），陈述不变："
        "二者自 GrammarCrossing 之引用移至 GrammarLaws 之引用与证明绑定，闭包之律之复用言 GrammarLaws 经 «不出» 陈之，"
        f"验证范围之回执与 GrammarCrossing 之数目为收据 {stamp} 者。")}
    for rid, r in recs.items():
        module, en, zh, form_en, form_zh = COUNTS[rid]
        theorems, declarations = mods[module]['theorems'], len(mods[module]['declarations'])
        scope = r['validation_scope']
        for lang, pattern, form in (('en', en, form_en), ('zh', zh, form_zh)):
            found = re.findall(pattern, scope[lang])
            assert len(found) == 1, (rid, lang, 'the counts are not there once')
            a, b = map(int, found[0])
            # Only master-laws-on-the-grammar's English names the theorems first.
            t_old, d_old = (a, b) if lang == 'en' and rid == MASTER_REC else (b, a)
            if form.format(t=theorems, d=declarations) not in scope[lang]:
                assert (t_old + delta[rid][0], d_old + delta[rid][1]) == (theorems, declarations), \
                    (rid, lang, 'the old counts with what the patches add or move are not the receipt\'s',
                     (t_old, d_old), (theorems, declarations))
                scope[lang] = re.sub(pattern, form.format(t=theorems, d=declarations), scope[lang])
        for lang, pattern, form in (('en', r'\(receipt \d{8}T\d{6}\.\d{6}Z\)', f'(receipt {stamp})'),
                                    ('zh', r'（回执 \d{8}T\d{6}\.\d{6}Z）', f'（回执 {stamp}）')):
            assert len(re.findall(pattern, scope[lang])) == 1, (rid, lang, 'the receipt is not named once')
            scope[lang] = re.sub(pattern, form, scope[lang])
        if not any('board item OU7' in h.get('en', '') for h in r['history']):
            r['history'].append({
                'en': f"{day.day} {day:%B %Y}, board item OU7 (study section {study}): {notes[rid][0]} Nothing else "
                      "the record states changed.",
                'zh': f"{day.year}年{day.month}月{day.day}日，工作板条目 OU7（研究第 {study} 节）：{notes[rid][1]}记录所述余无改变。"})
            r['reviewed_at_utc'] = day.isoformat()
        paths[rid].write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
        print(f'{rid}: the owner\'s items in place; {module} {theorems} theorems in {declarations} declarations at '
              f'receipt {stamp}; history note in place')


SECTION_B = (PART_B / 'home-03-section-3.txt').read_text(encoding='utf-8')
BEFORE_B = '<a id="r-testing-within-couplings"></a>\n'
# testing-within-the-net's toy stipulates its branches; RoomNet derives them at a margin of one (Rooms.toy_branches).
TOY_B = ('Lean: `«恒温与平衡»`, on a net of possibilities; [record](../results/records/testing-within-the-net.md).',
         'Lean: `«恒温与平衡»`, on a net of possibilities whose branches are stipulated; at a margin of one draw they are '
         'the steps of one rule of rooms ([below](#r-rooms-tested-by-a-window)); '
         '[record](../results/records/testing-within-the-net.md).')


def home_b():
    """Part B's home section in 03 §3, after testing-within-the-net's open note on the converse and before
    testing-within-couplings; and the toy's line in testing-within-the-net's home section pointing to it."""
    text = HOME_B.read_text(encoding='utf-8')
    if mb.ANCHOR in text:
        assert SECTION_B in text, 'a different home section for part B is in 03: remove it and rerun'
        print('03 §3: the home section is already in place')
    else:
        assert text.count(BEFORE_B) == 1, '03 §3: the anchor of testing-within-couplings is not there once'
        i = text.index(BEFORE_B)
        last = text[:i].rstrip('\n')
        last = last[last.rindex('\n\n') + 2:]
        assert last.startswith('**Open.** That this converse'), ('03 §3: the paragraph before testing-within-couplings '
                                                                 'is no longer the converse\'s open note', last[:80])
        text = text[:i] + SECTION_B.rstrip('\n') + '\n\n' + text[i:]
        print(f'03 §3: the home section after testing-within-the-net\'s open note{"" if WRITE else " (applies)"}')
    text = once(text, TOY_B[0], TOY_B[1], '03 §3, the toy\'s pointer to its branches derived')
    if WRITE:
        HOME_B.write_text(text, encoding='utf-8')


def regions():
    data = json.loads(REGIONS.read_text(encoding='utf-8'))
    # Part A. Region: the chapter of the home section (06, the classical texts). Base: the grammar, as for the corpus's
    # candidate theorems and definitions.
    data['records'][mr.RID] = {
        'region': 'classical', 'base': 'grammar',
        'note': 'GrammarConditionals OU7: 219 丙一 units, 128 in 22 families, each law with a net where its condition '
                'fails; 6 false as read, 19 premises; new laws G02, G03, G15 and 依'}
    data['modules'][mr.MODULE] = {
        'region': 'classical', 'base': 'grammar',
        'note': 'the corpus\'s conditional laws (丙一): 相推 gives 全生成, bounded room on a line, the core keeps never '
                'ending, dependence; 27 witnesses (OU7)'}
    # Part B's three entries, as its kit gives them: region knowing (03), RoomNet on the grammar, RoomRuns on the frame.
    data['records'][mb.RID] = {
        'region': 'knowing', 'base': 'grammar',
        'note': 'RoomNet, RoomRuns OU7: rooms tested by a window, regulation and equilibrium on the net of the possible'}
    data['modules']['Becoming.RoomNet'] = {
        'region': 'knowing', 'base': 'grammar',
        'note': 'rooms on the net of the possible: one rule, testing, regions, a conditional law, the toy derived'}
    data['modules']['Becoming.RoomRuns'] = {
        'region': 'knowing', 'base': 'frame',
        'note': 'the rooms\' window courses as RegimeMargin runs; the possible with warmth held'}
    for key in ('records', 'modules'):
        data[key] = dict(sorted(data[key].items()))
    REGIONS.write_text(json.dumps(data, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    print('regions: two records and three modules')


def record(receipt, study):
    receipt_sentence(receipt)
    ring_sentence()
    home()
    home_root()
    home_b()
    regions()
    general_records(receipt, study)
    record_words(study)
    owner_records(receipt, study)
    for maker in (mr, mb):
        r = maker.record(receipt, study)
        (ROOT / maker.REC).write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
        print('record', maker.REC, 'bound to', receipt)


# ---------------------------------------------------------------------------------------------------------- register

APART_B = json.loads((PART_B / 'apart-reasons.json').read_text(encoding='utf-8'))
# The owner's patches in the register: the two readings of a region not crossed, should the connectivity tool list them
# as apart roots, and «所闭不出», an apart root on main that «所闭之界» now uses.
OWNER_ROOTS = {
    'Becoming.GrammarLaws.uncrossed_iff_notGoingOut': (
        'general-structure', 'GrammarLaws.uncrossed_iff_notGoingOut: a region a relation does not cross is one not gone '
                             'out of either way, for every relation on any carrier and every region read as a test; '
                             'master-laws-on-the-grammar\'s law 4 reads its two count laws on it as one law'),
    'Becoming.GrammarLaws.uncrossed_iff_closed': (
        'general-structure', 'GrammarLaws.uncrossed_iff_closed: a region a relation does not cross is one closed under '
                             'it and under its converse, for every relation on any carrier, the converse of '
                             'GrammarLaws.uncrossed_of_closed; master-laws-on-the-grammar, law 4')}
OWNER_NOW_USED = ['Becoming.«所闭不出»']


@functools.lru_cache(maxsize=None)
def stage_roots():
    """The applied stages' register entries, from their EXPECTED.json: roots {name: [module, category, reason]}, and
    now_used, the register roots their code now uses."""
    roots, used = {}, set()
    for stage, data in stage_data():
        roots.update({n: tuple(entry) for n, entry in data.get('roots', {}).items()})
        used.update(data.get('now_used', []))
    return roots, frozenset(used)


def ours(name):
    return name in mr.LEAF or name in mr.PATCHED or name in mb.NAMES or name in OWNER_ROOTS or name in stage_roots()[0]


def module_of(name):
    if name in OWNER_ROOTS:
        return 'Becoming.GrammarLaws'
    if name in stage_roots()[0]:
        return stage_roots()[0][name][0]
    if name in mr.LEAF:
        return mr.MODULE
    for m in mb.MODULES:
        if name in mb.LEAVES[m]:
            return m
    return next(k for k in mr.BELOW if name in mr.BELOW_NAMES[k])


def reasons():
    """The category and reason of each theorem of the leaves, should the connectivity tool list it as an apart root
    (used by no other apart theorem). Part A: the witnesses and the day-and-night instance are facts about one
    constructed model; counting_reach_lt and the line-matching law support others; every other law is a law of every
    relation on any carrier, its unit's reading in the OU7 study. The patches' three laws are listed too, in case one
    stands apart: on the expected reading each is used by the old law that is its case. Part B: its apart-reasons.json,
    each root a fact about the rooms' rule, one constructed family of models. The owner's: OWNER_ROOTS."""
    out = {}
    for name in mr.LEAF:
        short = name[len('Becoming.'):]
        if short == '«依»':
            continue
        if short.endswith('之例»') or short == '«昼夜全生成»':
            out[name] = ('model-witness', f'{short}: a fact about one constructed model, a net where a conditional law '
                                          'of the corpus has its condition fail (06 §四, the record '
                                          'conditional-laws-of-the-corpus)')
        elif short in ('counting_reach_lt', '«类内有常则线相随»'):
            out[name] = ('support', f'{short}: a lemma of a law of the same leaf (G03\'s witnesses, G15\'s '
                                    '«核同则同不穷»)')
        else:
            out[name] = ('general-structure', f'{short}: a conditional law of the corpus (its family in the OU7 '
                                              'study\'s groups.tsv) proved for every relation on any carrier; the base '
                                              'supplies no reading of its terms')
    for name in sorted(mr.PATCHED):
        out[name] = ('general-structure', f'{name[len("Becoming."):]}: a law of every relation on any carrier, the '
                                          'general form of an older law of the grammar that is now its case (OU7)')
    for name, (category, why) in APART_B['roots'].items():
        out[name] = (category, why)
    out.update(OWNER_ROOTS)
    out.update({n: (category, why) for n, (_, category, why) in stage_roots()[0].items()})
    return out


def used_by_ou7(names):
    """Of `names`, those the leaves' code or the Grammar and GrammarReadings patches' added code names: once these use
    a register root it is no longer an apart root. Read from the code, not the register, so a rerun after the entries
    went still knows them."""
    added = '\n'.join(l[1:] for p in PATCHES[:2] for l in p.read_text(encoding='utf-8').splitlines()
                      if l.startswith('+') and not l.startswith('+++'))
    code = '\n'.join(mr.code(kit.read_text(encoding='utf-8')) for kit, _ in leaves()) + '\n' + mr.code(added)
    return {n for n in names if n.startswith('Becoming.') and not ours(n)
            and re.search(re.escape(n[len('Becoming.'):]) + r'(?![^\s()\]⟩,])', code)}


def leaf_uses():
    """The register roots OU7's code names and the owner's patches now use (the entries the register step expects to
    drop)."""
    roots = json.loads(APART.read_text(encoding='utf-8'))['roots']
    return used_by_ou7(roots) | {n for n in set(OWNER_NOW_USED) | stage_roots()[1] if n in roots}


def listed_in(log, label):
    m = re.search(label + r"[^:]*: (\[[^\]]*\])", log)
    return [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]


def cut(t, name):
    """The register's text without `name`'s entry (an entry holds no nested object, so its first closing brace at
    two spaces is its own)."""
    key = '  ' + json.dumps(name, ensure_ascii=False) + ': {\n'
    assert t.count(key) == 1, name
    start = t.index(key)
    close = t.index('\n  }', start)
    if t.startswith('\n  },\n', close):
        return t[:start] + t[close + len('\n  },\n'):]
    assert t.startswith('\n  }\n', close), name
    return t[:t.rindex(',\n', 0, start)] + '\n' + t[close + len('\n  }\n'):]


def register(log_path):
    """Every check first, then one write: a refused log leaves the register as it was."""
    t = APART.read_text(encoding='utf-8')
    d = json.loads(t)
    log = Path(log_path).read_text(encoding='utf-8')
    listed = listed_in(log, 'apart roots without a reason in')
    known = reasons()
    new, others, unknown = [], [], []
    for name in listed:
        if not ours(name):
            others.append(name)
        elif name not in known:
            unknown.append(name)
        elif name not in d['roots']:
            new.append(name)
    assert not unknown, ('roots with no reason: add each to reasons() or part B\'s apart-reasons.json, read from its '
                         'statement', unknown)
    # Part B's roots were predicted from its sources: the log's must be exactly these, or the stage stops for reading.
    found = {n for n in listed if n in mb.NAMES} | {n for n, e in d['roots'].items() if e.get('module') in mb.MODULES}
    assert found == set(APART_B['roots']), ('part B\'s roots differ from its apart-reasons.json',
                                            'not predicted', sorted(found - set(APART_B['roots'])),
                                            'predicted, not roots', sorted(set(APART_B['roots']) - found))
    # A register root the leaves or the patches now use is no longer an apart root: its entry goes. Only the roots
    # their code names, and OWNER_NOW_USED, may go this way; any other stops for its owner's reading. Part B's six must
    # be among them.
    gone = listed_in(log, 'register entries no longer apart roots')
    unexpected = [g for g in gone if g not in used_by_ou7(gone) and g not in OWNER_NOW_USED and g not in stage_roots()[1]]
    assert not unexpected, ('register entries no longer apart roots that OU7 does not use', unexpected)
    dropped = [g for g in gone if g in d['roots']]
    kept = [n for n in APART_B['now_used'] if n in d['roots'] and n not in dropped]
    assert not kept, ('part B\'s now-used roots the log does not list as no longer apart roots', kept)
    if new:
        anchor = '  }\n },\n "instances": {'
        assert t.count(anchor) == 1
        block = ',\n'.join('  ' + json.dumps(n, ensure_ascii=False) + ': {\n   "module": "' + module_of(n) + '",\n'
                           '   "category": "' + known[n][0] + '",\n   "reason": '
                           + json.dumps(known[n][1], ensure_ascii=False) + '\n  }' for n in new)
        t = t.replace(anchor, '  },\n' + block + '\n },\n "instances": {')
    for g in dropped:
        t = cut(t, g)
    assert set(json.loads(t)['roots']) == (set(d['roots']) | set(new)) - set(dropped)
    if new or dropped:
        APART.write_text(t, encoding='utf-8')
    print('dropped', len(dropped), 'register entries the leaves and the patches now use:', ', '.join(dropped) or 'none')
    print('registered', len(new), 'roots of the leaves and the patches; part B\'s', len(APART_B['roots']),
          'as predicted')
    if others:
        print("roots not OU7's, for their owners:", ', '.join(others))


# ---------------------------------------------------------------------------------------------------------- check

def head_master():
    """master-laws.json as the merged main has it (the landing worktree's HEAD, before the landing commit)."""
    return json.loads(git('show', 'HEAD:' + MASTER).stdout)


def check():
    data = json.loads((ROOT / MASTER).read_text(encoding='utf-8'))
    before = head_master()
    problems = []
    verification = json.loads((PKG / 'becoming-verification.json').read_text(encoding='utf-8'))
    if data.get('from_dump') or data.get('core_receipt') != verification.get('utc'):
        problems.append(('the data is not the landing run\'s', data.get('core_receipt'), verification.get('utc')))
    records = {maker.RID: json.loads((ROOT / maker.REC).read_text(encoding='utf-8')) for maker in (mr, mb)}
    for rid, rec in records.items():
        laws = data.get('records', {}).get(rid)
        if not laws:
            problems.append(('the data has no entry for the record', rid))
            continue
        mine = [law['declarations'] for law in rec['laws']]
        theirs = [law.get('declarations') for law in laws]
        if mine != theirs:
            problems.append(('the data does not match the record\'s laws', rid, len(mine), len(theirs)))
        for i, law in enumerate(laws, 1):
            print(f"{rid} law {i}: master laws {law.get('master_laws')}, grammar {law.get('grammar')}, "
                  f"dependence {law.get('dependence')}")
    # No central declaration is a leaf's or one the patches add, so U4's boundary record needs no new entry.
    central = {d for row in json.loads(COVERAGE.read_text(encoding='utf-8'))['rows'] for d in row.get('declarations', [])}
    new = set(mr.LEAF) | mr.PATCHED | mb.NAMES
    if central & new:
        problems.append(('a declaration of OU7 is central: U4\'s boundary record must place it', central & new))
    b = data.get('boundary') or {}
    if b.get('record') != 'one-root-to-its-edge' or b.get('field_failures') or b.get('unverified'):
        problems.append(('the boundary report', b.get('record'), b.get('field_failures'), b.get('unverified')))
    unplaced = [d for d, row in (b.get('rows') or {}).items() if row.get('label') == 'unplaced']
    if unplaced:
        problems.append(('unplaced', unplaced))
    if not b.get('lean_check', {}).get('ran'):
        problems.append(('the Lean check did not run', b.get('lean_check')))
    for key, now, then in [('boundary counts', b.get('counts'), (before.get('boundary') or {}).get('counts')),
                           ('central reach', (data.get('central_reach') or {}).get('counts'),
                            (before.get('central_reach') or {}).get('counts')),
                           ('counts at a model', data.get('counts_at_model'), before.get('counts_at_model')),
                           ('counts at the boundary record', data.get('counts_at_boundary_record'),
                            before.get('counts_at_boundary_record'))]:
        if now != then:
            problems.append((key + ' changed', then, now))
    grown = {k: (before['counts'].get(k), v) for k, v in data['counts'].items() if before['counts'].get(k) != v}
    print('record-law counts, main -> landing (only the new records\' laws should add):', grown)
    if data['counts']['laws'] != before['counts']['laws'] + sum(len(rec['laws']) for rec in records.values()):
        problems.append(('law count', before['counts']['laws'], data['counts']['laws']))
    for p in problems:
        print('PROBLEM', p)
    assert not problems
    print('shared laws read both records; the boundary report and the central figures are as on main:',
          b.get('counts'), (data.get('central_reach') or {}).get('counts'))


# ---------------------------------------------------------------------------------------------------------- study

def part_b_block(stamp, mods):
    """Part B's lines (check/kit/study-lines-b.md's text block), with the receipt and its counts filled and the
    results it reuses named."""
    md = (PART_B / 'study-lines-b.md').read_text(encoding='utf-8')
    block = md[md.index('```text\n'):md.rindex('```') + 3]
    net, runs = mods['Becoming.RoomNet'], mods['Becoming.RoomRuns']
    old = ('Evidence: core receipt (filled at landing); Becoming.RoomNet (94 theorems in 120 declarations) and\n'
           '       Becoming.RoomRuns (24 in 27)')
    new = (f'Evidence: core receipt `{stamp}`; Becoming.RoomNet ({net["theorems"]} theorems in '
           f'{len(net["declarations"])} declarations) and\n       Becoming.RoomRuns ({runs["theorems"]} in '
           f'{len(runs["declarations"])})')
    assert block.count(old) == 1, 'part B\'s evidence line moved'
    block = block.replace(old, new)
    first = 'Result(s): rooms-tested-by-a-window (new, home 03 §3, after testing-within-the-net).'
    assert block.count(first + '\n') == 1, 'part B\'s first line moved'
    reused = '\n'.join(textwrap.wrap(first + ' Reused: ' + ', '.join(d['id'] for d in mb.TEXT['dependencies']) + '.',
                                     width=118, subsequent_indent=' ' * 7, break_on_hyphens=False))
    return block.replace(first, reused)


def study(n, receipt):
    """The study's section N (the next free one), from the landing's receipt: part A's block, then part B's."""
    text = STUDY.read_text(encoding='utf-8')
    title = '## {}. The corpus\'s conditional laws, family by family, and rooms tested by a window (OU7)'
    if title.format(n) in text:
        print('study §', n, 'already in place')
        return
    free = max(int(x) for x in re.findall(r'^## (\d+)\. ', text, re.M)) + 1
    assert int(n) == free, ('the next free section is', free)
    m = mr.receipt_modules(receipt)
    leaf = m[mr.MODULE]
    stamp = Path(receipt).parent.name
    below = ', '.join(f"{k.split('.')[-1]} {len(m[k]['declarations'])} declarations" for k in mr.BELOW)
    data = {x['module']: x for x in json.loads((ROOT / receipt).read_text(encoding='utf-8'))['modules']}
    owner = ', '.join(f"{k} {data['Becoming.' + k]['theorems']} theorems in {len(data['Becoming.' + k]['declarations'])} "
                      "declarations" for k in ('GrammarLaws', 'GrammarCrossing'))
    evidence = '\n'.join(textwrap.wrap(
        f"Evidence: core receipt `{stamp}`; Becoming.GrammarConditionals ({leaf['theorems']} theorems in "
        f"{len(leaf['declarations'])} declarations), a core leaf importing GrammarCandidates and GrammarLaws, nothing "
        f"importing it; {below}; {owner}; every axiom report empty. The patches' audit: the kit's add only their "
        "three laws, every other statement unchanged; the owner's move two declarations unchanged, add two and write "
        "Flow.Cut as what unfolds to its old body.", width=118, subsequent_indent=' ' * 7, break_on_hyphens=False))
    section = f"""{title.format(n)}

Board item OU7 (claimed as OU5), the OU plan's §八 step 5 and the release gate's item 4, in two parts. Part A writes each conditional law of the corpus (丙一) in the grammar as "Y 当且仅当 Z" or "Z 则 Y", with a net where Z fails and Y fails with it ([the design]({DEVLINK}DESIGN.md)); it reads the 219 units, and one independent AI review of its design found 24 problems, every one taken ([the review]({DEVLINK}review/FINDINGS.md)). Part B gives 验's model examples: one rule of rooms, an unheated room and two thermostats, tested by a window on the net of the possible ([the design]({DEVLINK}check/DESIGN.md)); one independent AI review found 18 problems, and its re-check took every point ([the review and re-check]({DEVLINK}check/review/FINDINGS.md)). OU's owner decided what lands and confirmed every name; the kit's last revision settled where the two general laws are stated (GrammarReadings' note and scope sentence with them), part B's place in the instance ring, MapRegions' wording (its doc, its notes and one record's validation scope) and the toy's pointer to its derivation. Every text that lists the ring's members names the rooms; 08 §3's count of leaf applications, six there though the checker has listed seven since RF6.1 added OpenedCorrection (30 October), is now counted from the checker's list. The grammar's owner's three items held from BD2 land with it ([the patches]({DEVLINK}kit/patches/README.md)): «不出» and «所闭不出» stated in GrammarLaws beside «闭», «所闭之界» their case; `Flow.Cut` written as «不出» at a valuation's relation, the old definition by `Iff.rfl`; and a region not crossed read two ways (BD2's two equivalences), so that master-laws-on-the-grammar's two count laws read as one law on regions not gone out of either way.

```text
Result(s): conditional-laws-of-the-corpus (new, home 06 §四 at its end); continuation-relative-to-a-class (law 5,
       home 01 §4) and classical-definitions-in-the-grammar (law 4, home 06 §三), each generalized;
       master-laws-on-the-grammar (law 4 read as one law, home 01 §7; laws 1 and 4 gain the owner's declarations)
       and not-going-out-of-a-region («不出» and «所闭不出» now GrammarLaws'). Reused:
       candidate-theorems-of-the-corpus, master-laws-on-the-grammar, generation-and-degeneration-at-two-grains,
       testing-within-the-net.
Delta:
  - The 219 units classed 丙一 (162 of the first batch, 25 of 中论 chapters 10, 17, 19 and 24, 32 of 成唯识论):
    128 in 22 families (103 state a law that holds, 6 one false as read with its countermodel, 19 a premise);
    33 back to 丁, 53 not expressible with their reasons, 5 definitions. Each reading AI-labelled in groups.tsv.
  - New laws: 相推 gives 全生成 (G02, sufficient); bounded room on the line itself (G03: a line that does not come
    back is shorter than any list holding it, so not endless); the core keeps never ending (G15, «核同则同不穷»);
    dependence, one-way, with its two definitional laws (G09).
  - Two general laws, by patch, each stated where the law it generalizes is: beginning kept along the core of the
    converse net («生于逆核下不变», with «位核含于逆核»; «生于位核下不变» its case), in Grammar, law 5 of
    continuation-relative-to-a-class and 01 §4; what has a predecessor passes through under two-way constancy
    («两向有常有前则通»; «两向有常则通» its case), in GrammarReadings, law 4 of the classical definitions and 06 §三.
    Every old statement kept. 前際 and 後際 mirror each other under the converse; constancy is sufficient for 通,
    not necessary.
  - The grammar's owner's items held from BD2 (patches/owner/02-04): «不出» and «所闭不出» stated in GrammarLaws
    beside «闭», moved from GrammarCrossing unchanged, «所闭之界» «所闭不出»'s case at two occurrences; Flow.Cut written as
    «不出» at a valuation's relation, which unfolds to its old body; a region not crossed is exactly one not gone
    out of either way and one closed both ways (BD2's two equivalences), so master-laws-on-the-grammar's law 4
    reads its two count laws as one law.
  - 穷 → 变 → 通 is a conjunction where 變 is one alteration, not an order; G01's conjunction is text in 06, and
    06's open item is restated as which 變 the text means.
  - 27 witnesses, so that every family's net where Z fails is in the core; the 17 compositions the home section
    states as text stay in scratch.
Supplied premises / correspondence: the readings (AI reconstructions); G03's and G04's bound; G08 and G20 premises
       of the model; G13's not its own condition; G21's converse under its premise. Modelling choices: one carrier,
       缘 a necessary relation with no predicate of presence, discrete steps.
{evidence}
Standing: three families new (G02, G03, G15), dependence definitional; the rest are existing laws given exact form
       and nets. None of it says what a text means.
Boundary:
  - That the texts state these laws; no person has reviewed the readings.
  - An order 穷 → 变 → 通; production and sufficiency (not expressible); constancy as necessary.
  - The three open readings (G22's 衡不正, JS-326's 相應, JS-318's 無明), each with its AI label in 06's open items.
  - The 181 乙 candidates of the three added texts.
Output → input: 06 §四's home section, its thesis, §三's 通 (its table row and reading) and two open items; 01 §4's
       paragraph on the two-way core; 01 §7's sentence on balance on a region; the OU plan's line on beginning; the
       record's next step (review by a person; the open readings).
```

{part_b_block(stamp, mb.receipt_modules(receipt))}
"""
    for stage in applied_stages():
        said = (stage / 'study.md').read_text(encoding='utf-8').strip() if (stage / 'study.md').exists() else ''
        section += f"\n**Stage {stage.name}**, in the same core run. {said or 'Its records say what it holds.'}\n"
    STUDY.write_text(text.rstrip('\n') + '\n\n' + section, encoding='utf-8')
    print('study §', n, 'written')


if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    if sys.argv[1] == 'anchors':
        anchors()
    elif sys.argv[1] == 'apply':
        apply()
    elif sys.argv[1] == 'audit':
        audit()
    elif sys.argv[1] == 'record':
        record(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == 'register':
        register(sys.argv[2])
    elif sys.argv[1] == 'check':
        check()
    elif sys.argv[1] == 'study':
        study(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == 'stages':
        show_stages()
    elif sys.argv[1] == 'reason':
        print(reason(sys.argv[2]))
    else:
        sys.exit(__doc__)
