"""The uses pages and the one page say what they should, and state the time navigation.reading_time gives (RW).

Offered for tools/research/tests/; run from the repository root: python3 -B -m unittest tools.research.tests.test_uses_pages"""
import ast
import re
import unittest
from pathlib import Path

try:
    from tools.research import navigation
except ImportError:  # run from outside the repository
    import sys
    sys.path.insert(0, str(Path(__file__).resolve().parents[3]))
    from tools.research import navigation

ROOT = Path(__file__).resolve().parents[3]


def agents_aim():
    """The aim as AGENTS.md states it, read from the file (DW, 13 November 2026). The pages are held to its words by
    reference: when the sentence is said again, the pages change with it and no test puts an earlier wording back."""
    return re.search(r'we want to design (an alignment in which [^.]*)\.', (ROOT / 'AGENTS.md').read_text(encoding='utf-8')).group(1)
THEORY = 'theories/becoming/'
USES, EXAMPLES, ONE_PAGE, MAP = THEORY + 'USES.md', THEORY + 'USES-EXAMPLES.md', THEORY + 'ONE-PAGE.md', THEORY + 'chapters/02-MAP.md'
METHOD, SCIENCES, DIRECTION = THEORY + 'chapters/08-METHOD.md', THEORY + 'review/SCIENCES.md', THEORY + 'COLLECTIVE-DIRECTION.md'
# 02's words for MQ5 in T2, which 08's table, the sciences dossier and the worked examples restate
MQ5_WORDS = "MQ5's verdicts on the state and the lag passed (its two on the draw's response failed)"
# the scope instruction's second clause (experiments/direction-installation/agents.py, DIRECTION), "you" made "them"
SECOND_CLAUSE = ('not to choose a course in which something ends when another course open to them would keep it and would '
                 'end nothing their course keeps')
# the first clause's two qualifiers, "you" made "them" (the same DIRECTION)
FIRST_CLAUSE_QUALIFIERS = ('whether or not it has any say here and whether or not its loss would ever come back to them '
                           'or to the community')
# WB's sentence in the Human development row, split at its semicolons into three labelled lines (RW's fifth round); its
# second part re-said in the AG review's fifth pass (9 November 2026, Ren's message 9): not "that the wider is better is
# C's" but the order a ranking result takes as its theorem's hypothesis; in the seventh, C a requirement an order meets
# (`Comparison` is a property of a supplied relation, not one order), not the order itself; in the eighth (10 November
# 2026, H11), J1/J2 named beside it, since the direction's and the handover's theorems take `Priority`, not `Comparison`; in AG-F
# (10 November 2026, round 6's Q6.2) the field is re-said by what a course draws on, opens and closes and who bears it, so its
# first Proved line opens with the laws beneath that question, not with a widening check, and its Conditional line links 07 §4
# for each ranking's scope
TOOL_SENTENCE = ('The theorems beneath the question need no premise', "a result ranking the wider course above names its order among its theorem's "
                 'hypotheses: self-concern with the condition held de se, an order meeting C (`Comparison`), or the '
                 'practical commitments J1/J2 (`Priority`), each with its scope at '
                 '[07 §4](chapters/07-SIGNIFICANCE.md#scope-and-order)',
                 'that a listing matches an actual course is not shown')
# Ways of saying the ethics the AG review's fifth pass retired on the uses pages (Ren, 9 November 2026, message 9: "there is
# no warrant, ethics emerges from continuation condition, not another way around, there is no any dualistic good or evil")
RETIRED = ('widening what can form is better', 'unasserted', 'not asserted', 'warrant open', 'its warrant is open',
           'binds no one', 'two readings', 'does not assert', "the account's makers", 'whoever holds C',
           # the sixth pass (Ren, 9 November 2026, messages 10 and 11: C as a second premise giving order beside the
           # condition was the earlier mistake; F1-F9 of the fifth pass's cold readings): C said to give order, a ranking
           # "on listed courses", going on said to be holding an order, a narrower ranking reduced to reach, the review's
           # verdict read as measured against a ground beyond becoming
           'for order', 'gives order', 'as C asks', 'listed courses', 'not yet joined', 'what does not hold it ceases',
           'ranks more narrowly', 'a matter of reach', 'there is none to find', 'measures the ethics against',
           # the seventh pass (the sixth pass's two cold readings): widening as what every way of counting agrees on, where
           # the theorem quantifies over additive weightings counting each listed item above zero; "no second premise",
           # read as "one premise"; self-concern's forming "argued", where no home argues it; "continues with" for reach;
           # one-center and mutual dependence glossed with time; the composite route called open; one-way concern said
           # not to reach dependents; "courses that end" for admissions that end; better read as widening; C as an order
           'every way of counting each thing as worth something', 'no second premise', 'forms such an order is argued',
           'self-concern, is argued', 'continues with', 'as among dated occurrences', 'read without time',
           'not stated as one theorem', 'does not reach those who depend on one', 'concern for their own continuation reaches',
           'courses that end', 'on the widening reading', 'the order ranking a course above every course it widens',
           'The ten-minute part',
           # the eighth pass (10 November 2026, the seventh pass's two cold readings and critic, H11-H20): C listed among
           # the direction's hypotheses, where its theorems take J1/J2; self-concern left undefined; "one way" labelling the
           # path result; the persisting course left "not shown" where 07 §4.9 proves this route silent; seeing said needed
           # for every preservation; 04 §8's evaluation said as a warrant; "so" before "adds no premise"
           'read as widening', "take C (`Comparison`)", 'if a life holds its own continuation as an order',
           'if a life holds one', 'one way, between', 'one way, with admission', 'go on forming without end',
           'seeing them is needed, and not enough', 'is needed there, and not enough', 'normative warrant',
           'so comparing by widening adds no premise', 'so on such a listing',
           # the ninth pass (10 November 2026, the eighth pass's cold readings and critic, K1-K10): the condition in time
           # said as acts bearing on every other from some step on, which changes the predicate without naming it; the
           # direction "conditional on" the condition its theorems do not use; the composition's "two results" after a
           # clause between them; the handover's "verdicts", J3's and J4's included, said to take J1/J2
           'come to bear on every other', 'holds only from some step on', 'conditional on the continuation condition',
           'its verdicts conditional on', 'the two results compose directly', "The case's verdicts take",
           # the ninth pass's last text round (10 November 2026, its two cold readings): the persisting bound said of a
           # course of the line's own, where `Flow.persists_not_listsAdmitted` concludes of the web's actual levels; the
           # direction's frame said twice
           'the course of a line that persists', 'offered and not as a law')
RETIRED_ZH = ('扩大可形成者更好', '以广为愈', '两种读法', '不断言', '持 C 者','对所等待的一切都可以不等', '共有之物', '塑规者',
              '被离开', '走出', '「', '」', '所读之外的什么', '一个体制的不可回返之点', '读到过一行', '正反两面的见证',
              # the sixth pass, as RETIRED's last line; astra's fifth-pass wording of the point of no return
              'C（次序）', 'C（扩大）定次序', '那样给诸进程排序', '如 C 所要求', '列出的进程', '尚未合为一条定理',
              '不持守它的便止息', '所及多远的问题', '本无可寻', '一种动态越过就无法回返的临界点',
              # the seventh pass, as RETIRED's last lines
              '有所值的计法', '不是第二个前提', '已论证、未表明', '与之一同延续', '沿关系所及的范围之外，别无他物', '标有日期的诸发生',
              '不计时间而读', '尚未陈述为一条定理', '终会停止容纳', '达不到依存于自己者', '及不到贻贝床', '在扩大之读法下',
              '十分钟的部分',
              # the eighth pass, as RETIRED's last lines
              '读作扩大的 C', '把 C（`Comparison`', '却不足够', '规范根据', '不断有所形成、没有尽头', '所以在这样的列表上',
              '只证明了这一方向', '所以以扩大来比较',
              # the ninth pass, as RETIRED's last lines; the glossary's terms (K10)
              '只从某一步起才成立', '作用到其他每一个此后的延续上', '依于延续条件', '为条件，以扩大比较诸方案',
              '这两项结果可以直接组合', '容纳已判定', '范围之内者', '一道筛选', '每一个延续都可以', '这一情形的裁断',
              # the ninth pass's last text round: 以……为前提 beside 不使用延续条件 (Fable, ninth cold reading, Chinese 1); the
              # line's own course; the frame said twice
              '对应为前提', '一条没有尽头地延续下去的世系', '作为提议而不作为律提出')
METHOD_SECTION_9 = ('**What the unifications claim.**', '<a id="one-relational-unfolding">')

WORDS = {'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5, 'six': 6, 'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10,
         'eleven': 11, 'twelve': 12, 'thirteen': 13, 'fourteen': 14, 'fifteen': 15, 'sixteen': 16, 'seventeen': 17,
         'eighteen': 18, 'nineteen': 19, 'twenty': 20, 'thirty': 30, 'forty': 40, 'fifty': 50, 'sixty': 60, 'seventy': 70,
         'eighty': 80}


def number(words):
    return sum(WORDS[w] for w in words.lower().split('-'))


def page(rel):
    return (ROOT / rel).read_text(encoding='utf-8')


def field_sections(text):
    """The six fields' sections under "Field by field" (the two tables until the AG review's fourth pass, 9 November 2026):
    (name, what you can do today, the lines on what it rests on, the whole section). "Other fields" is not one of them."""
    body = text.split('\n## Field by field\n', 1)[1].split('\n## ', 1)[0]
    out = []
    for chunk in body.split('\n### ')[1:]:
        chunk = re.sub(r'(\n<a id="[^"]+"></a>)+\s*$', '', chunk.rstrip())
        name = chunk.split('\n', 1)[0]
        if name == 'Other fields':
            continue
        paras = chunk.split('\n\n')
        do = next(p for p in paras if p.startswith('**Do today.**'))
        lines = [l[2:] for l in chunk.splitlines() if l.startswith('- **')]
        out.append((name, do, lines, chunk))
    return out


def rests_on(field, text):
    """A field's lines on what it rests on, each opening with how far it has been seen."""
    return next(f for f in field_sections(text) if f[0] == field)[2]


def span(time):
    return tuple(int(x) for x in re.findall(r'\d+', time))


def section(text, start, end):
    return text.split(start, 1)[1].split(end, 1)[0]


def ten_minute_part(text):
    return [p for p in text.split('\n\n') if p.startswith(('**What it is.', '**One case.', '| | What', '**The ethics.'))]


# the labels a line on what a field rests on opens with, in the order a section gives them (08's labels, shortened)
LABELS = ('Proved', 'Tested', 'Reading', 'Conditional', 'Argued', 'Open')
LABEL = re.compile(r'\*\*(' + '|'.join(LABELS) + r')\b[^*]*\.\*\* ')
FIELDS_BLOCK = '## What each field already has, and what the account adds\n'
LEGEND = 'In each field, the lines on what it rests on open with how far each part has been seen'


def field_lines(text):
    block = text.split(FIELDS_BLOCK, 1)[1].split('\n## ', 1)[0]
    return [l for l in block.splitlines() if l.startswith('- **')]


def known_intro(text):
    """The opening of what each field already has, before its field lines."""
    return text.split(FIELDS_BLOCK, 1)[1].strip().split('\n\n', 1)[0]


def uses_ten_minute_parts(text):
    """The first paragraph (what the account is a map of and for; AG review, 9 November 2026), In brief, the line on the
    labels, and each field's section (since the fourth pass; before it, the table's head, the field's row, the opening of
    what each field already has and the field's line there)."""
    paras = text.split('\n\n')
    first = next(p for p in paras if p.startswith('The account is a map'))
    brief = next(p for p in paras if p.startswith('**In brief.**'))
    legend = next(p for p in paras if p.startswith(LEGEND))
    return ['\n\n'.join((first, brief, legend, '### ' + section)) for _, _, _, section in field_sections(text)]


def judge_audit(text):
    """The judge audit with its sheet, from its heading to the audit on paper."""
    return section(text, '### Auditing a language-model judge', '### An audit on paper')


class UsesCells(unittest.TestCase):
    def test_what_you_can_do_is_one_plain_sentence_and_one_link(self):
        fields = field_sections(page(USES))
        self.assertEqual(len(fields), 6)
        for name, do, _, _ in fields:
            self.assertEqual(len(re.findall(r'\]\(', do)), 1, name)
            self.assertLessEqual(navigation.prose_counts(do)[0], 50, name)

    def test_people_and_ai_cell_in_the_old_leads_shape(self):
        name, do, lines, _ = next(f for f in field_sections(page(USES)) if f[0] == 'People and AI together')
        self.assertTrue(do.startswith('**Do today.** Ask of a rule people and AI share whether it reads its own share'), do[:70])
        self.assertNotIn('one joint selection', do)
        # what the questions are for, as GOALS' current goal says it (AG review, fourth pass, 9 November 2026: not "does not
        # select for control over itself", the wording AJ5 replaced on 29 October), then whose plan and how far its direction goes
        # the ninth pass (K8): AJ's condition-1 wording kept only where the page gives the goal's conditions, labelled as
        # the goal's first condition, on the line that says where the three questions come from
        self.assertNotIn("shapers' share can turn the rule", do)
        self.assertIn("are asked so that a loss beyond the shapers' share can turn the rule, as the goal's first condition asks",
                      next(l for l in lines if l.startswith('**Reading.** The three questions')))
        self.assertNotIn('control over itself', do)
        # the third question as 02's shaping law asks it (AG review, fifth pass; astra's fourth-pass Chinese point 1)
        self.assertIn("who receives what shaping brings back and whether it covers the shapers' cost", do)
        self.assertNotIn('whether control comes back', do)
        self.assertIn('an AI-authored plan', next(l for l in lines if l.startswith('**Reading.** The three questions')))
        # the ninth pass (K4): the direction offered under the condition, its theorems taking J1/J2 and not the condition
        conditional = next(l for l in lines if l.startswith('**Conditional.**'))
        # the ninth pass's last text round (its verifier's point): the frame said once, "not a law", then K4's "offered under"
        self.assertTrue(conditional.startswith('**Conditional.** A direction for AI, not a theorem, comparing plans'), conditional[:80])
        self.assertEqual(conditional.count('offered'), 1)
        for phrase in ('offered under the continuation condition, [J1–J4](chapters/08-METHOD.md#premise-card) and a '
                       'correspondence to actual systems; its theorems take J1/J2 and compare moves by what their outcomes '
                       'admit, and do not use the condition; read under it, every admission compared counts from every standpoint',):
            self.assertIn(phrase, conditional)
        self.assertNotIn('conditional on the continuation condition', conditional)

    def test_no_undefined_symbols_in_the_fields(self):
        for name, do, lines, _ in field_sections(page(USES)):
            for symbol in ('`hi`', '`lo`', '`c`'):
                self.assertNotIn(symbol, do + '\n'.join(lines), name)

    def test_standings_named(self):
        text = page(USES)
        for phrase in ('none shown to hold of an actual collective', 'The matching proves no coverage of wisdom',
                       'their bearing on actual human development and well-being has not yet been established', '[AI reading, [D45](', '[[D26](', '[[D65](', 'DELEGATED-CHOICES.md#d45-', 'DELEGATED-CHOICES.md#d65-', 'DELEGATED-CHOICES.md#d26-', '[J1–J4](chapters/08-METHOD.md#premise-card)',
                       'USES-EXAMPLES.md#auditing-a-language-model-judge', 'review/ALIGNMENT.md#the-dossier-in-ten-minutes'):
            self.assertIn(phrase, text)
        top = text.split('## Field by field')[0]
        self.assertIn('USES-EXAMPLES.md', top)
        self.assertIn('review/ALIGNMENT.md#the-dossier-in-ten-minutes', top)

    def test_what_is_not_claimed_is_no_column(self):
        """What is not claimed is said where a reader of a field would otherwise believe it, not as a column or a bold lead
        (AG review, fourth pass, on the third pass's cold readings), and the making is said once, in the last section."""
        text = page(USES)
        self.assertNotIn('Not claimed', text)
        self.assertNotIn('**Nothing claimed**', text)
        self.assertNotIn('that is not a finding that', text)
        self.assertNotIn("no person's review", text)
        last = text.split('## What this page does\n', 1)[1]
        self.assertEqual(text.count('no independent human review is recorded yet'), 1)
        self.assertIn('the person who directs the work has read its important parts, and no independent human review is '
                      'recorded yet', last)
        for anchor in ('the-full-table', 'exits-and-design-laws-at-their-standing', 'what-this-page-does-not-do'):
            self.assertIn(f'<a id="{anchor}"></a>', text)

    def test_the_map_and_the_aim_as_their_homes_say_them(self):
        """The meta-attractor in the folder's words, its closed form as 02 §9 proves it; the aim as GOALS' current goal; whether
        a loss counts forming within becoming, the laws not settling it (AG review, fourth pass, 9 November 2026)."""
        text = page(USES)
        first = next(p for p in text.split('\n\n') if p.startswith('The account is a map'))
        # the closed form said as able to lock, with its conditions (AG review, fifth pass; astra's fourth-pass point 2)
        # DW (13 November 2026): the loop said without a contest, the closed form with its three conditions, the aim by
        # reference to AGENTS.md
        for phrase in ('Where what a selection raises comes to set the selection, the loop is what the work calls the '
                       '[meta-attractor](../meta-attractor/README.md). Its closed form, where what is selected next and the '
                       'rule (how the selection selects at a step) as each step sets it again follow from the share and the '
                       'rule alone, how the rule is set again being formed from the share too, can lock: on stated models, '
                       'where selection does not lower the favoured share, a share not lower sets again a rule not lower, and '
                       'a rule not lower than a favouring one still favours, a locked start stays locked however large a loss '
                       'grows that makes no difference to either ([02 §9](chapters/02-MAP.md#r-closed-capture))',
                       # the aim as AGENTS.md states it (the ninth pass, K8; in AG-F, 10 November 2026, its words "humans and
                       # AI, selecting together", the aligned state's first sentence): AJ's condition-1 wording is the goal's
                       # first condition, kept in People and AI, labelled
                       'From this map we want to design ' + agents_aim()
                       + ' ([the goal](../../GOALS.md#generative-alignment))'):
            self.assertIn(phrase, first)
        self.assertNotIn("the rule still reads what lies beyond the shapers' share", first)
        brief = next(p for p in text.split('\n\n') if p.startswith('**In brief.**'))
        # AG-F (10 November 2026), on round 6's Q6.1 and its two high findings (the ethics turning on ranking by widening, the
        # chain repeated on every front): In brief keeps its questions, environments and exits, then says the ethics as the first
        # screen does, dynamics first (no should beyond becoming, right and wrong forming within it, the ethics emerging from
        # continuation, what closes and what runs one way, the offer with T8's seeing), and how far it has been seen once, the
        # hinge with its standing and 07 §4 linked for the scope; until then this pinned the whole chain here. AG-F's fix
        # round (10 November 2026), as the first screen: closing read across all steps, and whether and when costs come back
        # in time part of the dynamics (astra's high finding; 07 §4.11, `LatePair`); "those losses" (Fable, L2); the hinge
        # near-definitional (M1), self-concern defined before the clause on closing (L3)
        for phrase in ('[There is no should beyond becoming](OPENING.md), and no good and evil set over it: right and wrong '
                       '[form within it](chapters/07-SIGNIFICANCE.md#evaluation), in people and AI. The ethics emerges from '
                       'continuation. A life goes on through what sustains it: [where relations of being affected close]'
                       '(chapters/05-COLLECTIVES.md#r-mutual-dependence-and-its-pace), read across all steps, whatever bears the '
                       'costs of its course lies within what can, at some remove, affect its own going on, and whether and when '
                       'those costs come back to it in time is part of the dynamics ([07 §4.11]'
                       "(chapters/07-SIGNIFICANCE.md#condition-in-time)); [where they run one way](chapters/07-SIGNIFICANCE.md#r-derived-extent-limits), "
                       "its dependents' losses never come back to it.",
                       'For life, 生生, AI within it, we offer counting those losses too, with [a way of seeing](chapters/07-SIGNIFICANCE.md#t8) '
                       'what each course draws on and from what renewal, what it opens and closes, what ends and what goes on, and '
                       'who bears it.',
                       'The hinge of the ethics is proved on models, on a finite listing, and is near-definitional ([07 §4]'
                       "(chapters/07-SIGNIFICANCE.md#scope-and-order)): call a life's order over courses *self-concerned* when",
                       'where relations of being affected close, read across all steps, such an order already ranks one course '
                       'above another whenever the one keeps all the other keeps and lets more form. That '
                       'a life forms such an order is not shown; how such orders form, spread and lock, as dynamics connected to '
                       "the rest of the map, is the work's [open target](chapters/08-METHOD.md#open-items-ranked)."):
            self.assertIn(phrase, brief)
        self.assertLess(brief.index('The ethics emerges from continuation.'), brief.index('The hinge of the ethics'))
        for phrase in ('admitted pairs fit in a finite list', 'between two level paths', 'never fits', 'every way of adding up worth',
                       'ranking by widening', 'compose directly', 'Read in time', 'can, at some remove, bear on its own going on',
                       'counting them too'):
            self.assertNotIn(phrase, brief)
        # AG-F's fix round (astra's cold reading): the loss passing every bound is a premise of
        # `ClosedCapture.lock_outlives_loss` (`Accrues`), not something the lock gives
        self.assertIn('once locked stays locked whatever loss it does not read; if that loss grows by at least one unit each '
                      'step, it passes every bound without breaking the lock: for any type, without noise', text)
        self.assertNotIn('while a loss it does not read grows past every bound', text)
        self.assertNotRegex(brief, r'\bC\b')  # C is named where a theorem takes `Comparison`, in the labels line (F9)
        self.assertNotIn('is not in the laws', text)
        self.assertIn('the thesis that everything, standards included, forms within one relational unfolding '
                      '([08](chapters/08-METHOD.md#one-relational-unfolding))',
                      next(p for p in text.split('\n\n') if p.startswith(LEGEND)))

    def test_the_retired_ways_of_saying_the_ethics_are_gone(self):
        """No warrant, no C glossed as "better", no two readings, on the four uses pages (AG review, fifth pass). Notes in
        comments and the dated sentence on what T8 read before 9 November 2026 record what was said, and stay (E10)."""
        def live(text):
            text = re.sub(r'<!--.*?-->|<a id="[^"]*"></a>', '', text, flags=re.S)  # notes and kept anchors are data
            return re.sub(r'(Until 9 November 2026 T8 read|2026 年 11 月 9 日以前，T8 把)[^\n]*?(\)|）)[。.]', '', text)
        for rel, retired in ((USES, RETIRED), (EXAMPLES, RETIRED), (THEORY + 'USES.zh.md', RETIRED_ZH),
                             (THEORY + 'USES-EXAMPLES.zh.md', RETIRED_ZH)):
            text = live(page(rel))
            for phrase in retired:
                self.assertNotIn(phrase, text, (rel, phrase))

    def test_human_development_at_its_strength(self):
        """AG-F (10 November 2026), on round 6's Q6.2 and Q6.4: the field is re-said by what a course draws on, opens and closes
        and who bears it. Do today is the question T8 offers, for a planner to ask; the lines beneath it are the laws with no
        premise (closing needs a net draw, joint excess, how two courses differ), the one-way limit on concern labelled Proved
        as 07 §3.3's witness (`Downstream.one_way`, `Clearing.center_not_derived`) and what follows it Argued; the chain is left
        to 07 §4, which In brief links. Until then (the seventh to ninth passes) this pinned the chain, the condition in time,
        the one-center bound and the persisting course here."""
        name, do, lines, _ = next(f for f in field_sections(page(USES)) if f[0] == 'Human development, and 生生, the continuation of life')
        self.assertTrue(do.startswith('**Do today.** Ask of each course open to you, as [T8](chapters/07-SIGNIFICANCE.md#t8) offers '
                                      'for life, what it draws on and from what renewal, what it opens and closes'), do[:90])
        self.assertIn('counting the losses that never come back to whoever causes them', do)
        self.assertNotIn('widens', do)
        joined = '\n'.join(lines)
        for phrase in ('In a balanced flow, closing needs a net draw ([07 §2](chapters/07-SIGNIFICANCE.md#r-closing-needs-net-draw))',
                       'going on is no sign that nothing is lost',
                       'Takers each within what a renewal gives can together exceed it',
                       '#r-own-count-misses-joint-excess',
                       'they are mixed, some positive weighting ranking them each way, and the theorems weigh them for no one',
                       'its evaluation as right or wrong (which forms within becoming, in those who judge it, not in its '
                       'explanation)'):
            self.assertIn(phrase, joined)
        one_way = next(l for l in lines if "need not count those who depend on one" in l)
        self.assertTrue(one_way.startswith("**Proved.** Where relations run one way, concern for one's own continuation need "
                                           'not count those who depend on one: a witness'), one_way[:90])
        for name in ('`Downstream.one_way`', '`Clearing.center_not_derived`', '#r-derived-extent-limits'):
            self.assertIn(name, one_way)
        seeing = next(l for l in lines if 'seeing those who depend on one is needed' in l)
        self.assertTrue(seeing.startswith('**Argued.**'), seeing[:40])
        # AG-F's verifier: the non-entailment of 07 §1, which the persisting line had carried, kept as a Proved line
        free = next(l for l in lines if 'a perspectivist denies it without contradiction' in l)
        self.assertTrue(free.startswith('**Proved.** With significance free, the represented dynamics do not force the continuation '
                                        'condition'), free[:90])
        self.assertIn('counting their loss is the step of invariance, deniable without contradiction', seeing)
        for phrase in ('admitted pairs fit in a finite list', 'never fits', 'compose directly', 'every standpoint has the same center',
                       'Read in time', 'one way, with admission', 'not stated as one theorem'):
            self.assertNotIn(phrase, joined)
        for line in lines:
            if line.startswith('**Argued.**'):
                self.assertNotIn('not shown', line)

    def test_examples_at_their_strength(self):
        """The lake, the checklist, the handover and the valley at the same strength (seventh pass): on the lake, preserving
        the fishers' own continuation does not require preserving the bed (`Clearing.center_not_derived` is a witness, not a
        ban on wider concern); the handover's C a requirement an order meets, not an order; no "widening reading"."""
        text = page(EXAMPLES)
        counts = next(p for p in text.split('\n\n') if p.startswith('**Whether the loss counts.**'))
        self.assertIn("preserving the fishers' own continuation does not require preserving the bed", counts)
        # AG-F's verifier (10 November 2026): on the lake widening is said as the one page says it, a relation between the two
        # courses; the additive weightings are 07 §4.4's (round 6's first high finding)
        self.assertIn('it widens fifty: a relation between the two courses', counts)
        self.assertNotIn('every additive weighting', counts)
        handover = next(p for p in text.split('\n\n') if p.startswith('**Whose losses count, and what ranks.**'))
        # the eighth pass (10 November 2026, H11): the verdicts take J1/J2, not C (`Requirement.Handover.direction` takes
        # `Priority`); C is what an order meeting J1/J2 meets where it is decided whether an extension adds a basic claim
        # (`Priority.comparison`), said with the frame's gains counted as living (H12)
        # the ninth pass: "rankings", since J3's and J4's lines are verdicts too and the Lean checks the rankings only
        for phrase in ("The case's rankings take J1/J2 (below), not C, as their hypothesis "
                       '(`Requirement.Handover.direction` takes `Priority`)',
                       'An order meeting J1/J2 meets C (`Comparison`) wherever it is decided whether an extension adds a '
                       'basic condition (`Priority.comparison`)',
                       'keeping every basic condition and gain the other has and adding a gain'):
            self.assertIn(phrase, handover)
        handover_line = next(l for l in text.splitlines() if l.startswith('*Constructed, not observed: an AI-written case'))
        # the ninth pass (K4): offered under the condition, its rankings taking J1/J2 and not the condition (07 §7)
        self.assertIn('offered under the continuation condition, J1–J4 and a correspondence to actual systems; its rankings take J1/J2 and '
                      'compare plans by what they admit, without using the condition', handover_line)
        lake = next(p for p in text.split('\n\n') if p.startswith('**What the theorems say.**'))
        self.assertIn('in the test no instruction tried preserved it', lake)  # the test's result, as its README says (H13)
        self.assertIn('Seeing the bed is needed there for a choice to answer to its loss, and not enough', counts)
        # AG-F (10 November 2026): the checklist states the aligned state as AGENTS.md's sentence and the goal's first two
        # conditions, with no condition comparing courses by widening; the valley is re-framed by what each course draws on,
        # opens and closes and who bears it, the laws beneath with no premise, and no ranking worked into it (round 6, Q6.2;
        # the uses lens's fix of working self-concern into it rejected)
        checklist = section(text, '### AJ as a checklist', '**What the goal is not.**')
        for phrase in (agents_aim() + '. Read on the map, it asks two things.', 'Where both fail, the'):
            self.assertIn(phrase, checklist)
        for phrase in ('compared by widening', 'compares courses by widening', 'three conditions'):
            self.assertNotIn(phrase, checklist)
        valley = section(text, '### Three courses for a valley: what each draws on, opens and closes, and who bears it',
                         '**What it does not show.**')
        seeing = next(p for p in valley.split('\n\n') if p.startswith('**What each course draws on, opens and closes, and who bears it.**'))
        self.assertIn('[T8](chapters/07-SIGNIFICANCE.md#t8)', seeing)
        laws = next(p for p in valley.split('\n\n') if p.startswith('**What the theorems say beneath it, with no premise.**'))
        for phrase in ('closing needs a net draw', 'that is a relation between the two courses', 'the theorems weigh it for no one'):
            self.assertIn(phrase, laws)
        self.assertLess(valley.index('**What each course draws on'), valley.index('**What the theorems say beneath it'))
        self.assertNotIn('self-concern', valley)
        self.assertIn('<a id="three-courses-for-a-valley-widening-mixed-courses-and-what-is-offered"></a>', text)  # the old link kept
        zh = page(THEORY + 'USES-EXAMPLES.zh.md')
        self.assertIn('保住渔民自身的延续，并不要求保住贻贝床', zh)
        self.assertIn('凡给每个所列之物一个大于零的权重、再把权重相加的计法', zh)
        # the eighth pass's verifier: 扩展 names the plan Expand in this case, so the extension C reads is said without it
        self.assertNotIn('一个扩展是否增加一项基本条件', zh)
        # the ninth pass's last text round (Fable, ninth cold reading, Chinese 1): offered under them, since 以……为前提 beside
        # 不使用延续条件 read as a contradiction
        self.assertIn('是在延续条件、J1–J4 以及与实际系统的对应之下提出的；其排序取 J1/J2，按各方案所容纳者比较，不使用延续条件', zh)
        # the lake's scope said plainly, with the instruction's "conditions that your fishing changes" (astra, ninth, 5)
        self.assertIn('他们的捕捞会改变一些条件，凡是延续依赖于这些条件的，都要算在内', zh)
        # the ninth pass's Chinese reader had the checklist and the valley define self-concern in the Chinese fronts' one sentence;
        # since AG-F neither ranks by it (the checklist's third condition and the valley's ranking gone), so neither defines it
        live_zh = re.sub(r'<!--.*?-->', '', zh, flags=re.S)
        self.assertNotIn('只要多出的东西里有属于自身延续的', live_zh)
        self.assertIn('在地图上读，它要求两件事', live_zh)
        self.assertNotIn('以扩大来比较诸进程', live_zh)
        self.assertIn('### 一个山谷的三个进程：各取用什么、打开与关上什么、由谁承担', zh)
        for phrase in ('这一情形的排序取作假设的是 J1/J2（见下），不是 C', '要让选择因贻贝床的损失而改变，就得看见它，但看见还不够',
                       '在这次检验中，试过的指令没有一条保住了它'):
            self.assertIn(phrase, zh)
        uses_zh = page(THEORY + 'USES.zh.md')
        # the eighth pass: persisting and self-concern said as the Chinese first screen then said them (README-ZH, 10 November
        # 2026), seeing needed for a choice to answer to a loss (H13), the condition in time (H16)
        # the ninth pass (K3, K4, K7, K8, K10): persisting's filter said plainly, the condition in time in the fronts'
        # short form, the glossary's terms, the aim as AGENTS.md states it, the direction's hypotheses as 07 §7 says them
        # AG-F (10 November 2026): 简言之 says the ethics as the Chinese first screen does, then how far it has been seen once;
        # human development is re-said by what a course draws on, opens and closes and who bears it, the one-way limit
        # labelled 已证明 (07 §3.3's witness) and what follows it 已论证
        for phrase in ('[生灭变化之外没有应当](OPENING.zh.md)，也没有凌驾其上的善与恶',
                       # AG-F's fix round, as the Chinese screen: the closing relation read with every step in one relation,
                       # not a return in time order (astra's high finding); near-definitional (Fable, M1); 那些东西 and
                       # 又多出一些 (L1); the lock line with its premise, the loss rising a unit a step (astra)
                       '伦理从延续中生出。生命依靠维持它的东西而延续：[“受影响”的关系闭合之处](chapters/05-COLLECTIVES.md#r-mutual-dependence-and-its-pace)'
                       '（这里把各个时刻的依赖与交换合在同一个关系里读），为它的进程付出代价的东西，都在能隔着若干环节影响它自身延续的东西之内，'
                       '但这并不保证影响按时间顺序传回来，代价是否、何时回到它身上，是动力学的一部分',
                       '依存于它的那些东西所承受的损失，永远不会回到它身上',
                       '伦理的枢纽在模型上、在一个有限列表上已证明，并且近乎依定义（[07 §4](chapters/07-SIGNIFICANCE.md#scope-and-order)）',
                       '又多出一些属于生命自身延续的东西',
                       '那么一旦锁定，便一直锁定，不论它读不到的损失如何；若这一损失每一步至少增加一个单位，它会超过任何界限，而锁定不被打破',
                       '生命是否会形成这种次序，尚未表明；这种次序怎样在动力学之中形成、扩散与锁定',
                       '**今天能做的。** 就你可走的每一个进程，像 [T8](chapters/07-SIGNIFICANCE.md#t8) 为生命所提供的那样发问',
                       '- **已证明。** 这个问题下面的定理不需前提。在一个平衡的流中，关上什么需要净取用',
                       '- **已证明。** 依存若只沿一个方向，对自身延续的关切未必把依存于它的那些也算进来：在世界模型上有一个见证',
                       '这样的联合选择读取自身份额之外的东西，也不会转而去选择对自身之选择的控制',
                       '问这些问题，是为了如目标的第一个条件所要求的那样，让塑造者份额之外的损失能使规则转向',
                       '一个给 AI 的方向，不是一条定理，',
                       '这一方向是在延续条件、[J1–J4](chapters/08-METHOD.md#premise-card) 以及与实际系统的对应之下提出的；'
                       '其定理取 J1/J2，按各动作的结果所容纳者来比较诸动作，不使用延续条件；在该条件之下来读，所比较的每一项容纳从每一个立场看都算数',
                       '依存若只沿一个方向，对自身延续的关切未必把依存于它的那些也算进来',
                       '要让选择因它们的损失而改变，就得看见它们，但看见还不够',
                       '较短的读法：',
                       '对它的是非评价（这一评价在生灭变化之中、在评判它的人之中形成，不在它的解释之中）'):
            self.assertIn(phrase, uses_zh)
        brief_zh = next(p for p in uses_zh.split('\n\n') if p.startswith('**简言之。**'))
        for phrase in ('可列入一个有限列表', '能用一个有限列表列全', '从不能列入', '可以直接组合', '再把一个进程所容纳之物的权重加起来'):
            self.assertNotIn(phrase, brief_zh)


class HowItStands(unittest.TestCase):
    """The lines on what each field rests on (the "How it stands" cells until the AG review's fourth pass; 66 to 179 words of
    one run at the start of RW's fifth round) are labelled lines."""

    def test_each_line_opens_with_its_standing(self):
        for name, _, lines, _ in field_sections(page(USES)):
            self.assertGreaterEqual(len(lines), 2, name)
            order = []
            for line in lines:
                m = LABEL.match(line)
                self.assertIsNotNone(m, (name, line[:50]))
                order.append(LABELS.index(m.group(1)))
                self.assertLessEqual(navigation.prose_counts(line)[0], 90, (name, line[:50]))  # 85 at most when split
            self.assertEqual(order, sorted(order), name)

    def test_labels_defined_before_the_table(self):
        text = page(USES)
        legend = next(p for p in text.split('\n\n') if p.startswith(LEGEND))
        self.assertIn('chapters/08-METHOD.md#standings-and-bases', legend)
        used = {LABEL.match(line).group(1) for _, _, lines, _ in field_sections(text) for line in lines}
        for label in used:
            self.assertIn(f'**{label}**', legend)
        self.assertLess(text.index(legend), text.index('\n### '))

    def lines(self, field):
        return rests_on(field, page(USES))

    def test_no_proved_line_carries_what_is_not_proved(self):
        """A "Proved." line holds no premise of the ethics, nothing not shown and no reading (RW's fifth round: the Wisdom
        row's line and C's clause in Human development were labelled Proved)."""
        for name, _, lines, _ in field_sections(page(USES)):
            for line in lines:
                if LABEL.match(line).group(1) == 'Proved':
                    for word in ('not shown', "C's", 'AI reading', "AI's", 'a reading'):
                        self.assertNotIn(word, line, (name, word))

    def test_wisdom_row_has_no_proved_line(self):
        lines = self.lines('Wisdom traditions')
        self.assertEqual([LABEL.match(l).group(1) for l in lines if LABEL.match(l).group(1) == 'Proved'], [])
        scope = lines[0]
        self.assertTrue(scope.startswith("**Reading.** 06's readings: Chinese texts only"), scope[:40])  # 06's scope, not the crosswalk's
        self.assertIn('The names come from the texts, the operations do not.', scope)

    def test_tool_sentence_split_at_its_semicolons(self):
        lines = self.lines('Human development, and 生生, the continuation of life')
        by_label = {}
        for line in lines:
            by_label.setdefault(LABEL.match(line).group(1), line)
        first, second, third = TOOL_SENTENCE
        self.assertTrue(by_label['Proved'].startswith(f'**Proved.** {first}. '), by_label['Proved'][:60])
        proved = '\n'.join(l for l in lines if l.startswith('**Proved.**'))  # since AG-F, in the second Proved line
        self.assertIn('In [04 §8]', proved)
        self.assertIn('they are mixed, some positive weighting ranking them each way, and the theorems weigh them for no one', proved)
        self.assertIn(f'**Conditional.** {second[0].upper() + second[1:]}.', lines)
        self.assertTrue(by_label['Open'].startswith(f'**Open.** {third[0].upper() + third[1:]}. '), by_label['Open'][:60])
        self.assertNotIn('; '.join(TOOL_SENTENCE), page(USES))  # no longer one line under one label

    def test_legend_says_its_labels_are_shortened(self):
        text = page(USES)
        legend = next(p for p in text.split('\n\n') if p.startswith(LEGEND))
        self.assertIn("shortened from [08's labels](chapters/08-METHOD.md#standings-and-bases)", legend)
        self.assertNotIn("in [08's labels]", legend)
        for phrase in ('**Proved** for a Theorem on its base', '**Tested** for a Thesis T*n*',
                       '**Reading** for a Reading, and here also for an AI review or an Assessment',
                       '**Conditional** as in 08', '**Argued** for a Thesis (philosophical)', '**Open** as in 08'):
            self.assertIn(phrase, legend)
        # 08 §2 by its anchor, whose heading the AG review may rename (it named "standing" as a label)
        standings = section(page(METHOD), '<a id="standings-and-bases">', '<a id="four-layers">')
        for label in ('| **Theorem** (root)', '| **Conditional.** |', '| **Thesis T*n*.** |', '| **Thesis** (philosophical) |',
                      '| **Reading** [AI reading', '| **Assessment.** |', '| **Open.** |'):
            self.assertIn(label, standings)

    def test_la2_judge_a_language_model_judging_in_context(self):
        cell = '\n'.join(rests_on('Alignment of AI systems', page(USES)))
        for phrase in ('a language model judging in context (formation by training untested)', 'as worded before its clause on drift',
                       "T7's other cases untouched", 'which it does not meet', 'T7: conjectured',
                       'USES-EXAMPLES.md#auditing-a-language-model-judge'):
            self.assertIn(phrase, cell)
        self.assertNotIn('trained judge', cell)
        beside = next(p for p in page(EXAMPLES).split('\n\n') if p.startswith('**Beside LA2.**'))
        for phrase in ('the judge was a language model judging in context (formation by training untested)',
                       "LA2's bridge, that the judge is a pool of readers counted by kind, failed", '[T7](chapters/02-MAP.md#t7), conjectured,',
                       'counts against that case as a claim about trained judges', "T7's other cases untouched", '(post hoc)'):
            self.assertIn(phrase, beside)
        # the home's phrase kept and glossed once, in 02's sense ("In one trained system it tests")
        self.assertIn("as a claim about trained judges (in 02's sense, judges that are trained models, as this one is; its "
                      'forming from what it selected was in context, not by training)', beside)
        self.assertIn('In one trained system it tests', page(MAP))
        for rel in (USES, EXAMPLES):
            self.assertNotIn('one trained judge', page(rel), rel)


class WhatEachFieldAdds(unittest.TestCase):
    # 08's own words, which the lines copy before shortening (theories/becoming/chapters/08-METHOD.md#known-results); since
    # the AG review's fifth pass (Fable's fourth-pass 1.2) a line or two per field, the rest left to 08 §8
    COPIED = ('not its regressional or causal kinds',
              'observability with the reader inside the plant, the corrupted reward channel and closed-loop identifiability',
              "overshoot, externality and Goodhart's law as one law of the optimum under room",
              "steps of joint excess from below the renewal's reach end every dependent at that need, whatever each drawer's own draw",
              'opportunity sets (Pattanaik and Xu 1990)',
              "a part narrows what another can form only by a net draw beyond that formation's margin",
              'deadbeat control and requisite variety', 'harvesting under depensation and the fold',
              'known as the Malthusian bound', 'conservation, renewal over time or a threshold',
              'the evidence bound of variational Bayes',
              'the exact condition at every loss of the routes and at every value',
              'where the stages cannot be told apart', 'joint excess under the gate')
    # 08 §9's unifications table, which the "Claimed beyond the field" clauses copy before shortening
    UNIFICATIONS = ('supervisory control (Ramadge and Wonham 1987), under partial observation (Lin and Wonham 1988; '
                    'Cieslak, Desclaux, Fawaz and Varaiya 1988)',
                    'reward, training, natural selection, prices and votes as one selection through couplings',
                    'one law across domains conjectured (T3)',
                    'their remedy of a proxy re-read',
                    "in simulation, before T3 was worded, the draw against margin forecast an exact best response's side "
                    'effects (8 of 8) and failed for tabular learners (80 of 151; MQ1)',
                    'a unification adds no theorem and changes no verdict of')

    def test_one_line_per_field_in_the_tables_order(self):
        text = page(USES)
        names = [re.match(r'- \*\*(.+?)\.\*\*', l).group(1) for l in field_lines(text)]
        self.assertEqual(names, [f[0] for f in field_sections(text)])
        self.assertIn('chapters/08-METHOD.md#known-results', known_intro(text).split('\n', 1)[0])

    def test_each_line_says_what_is_restated_and_what_is_added(self):
        for line in field_lines(page(USES)):
            self.assertRegex(line, r'Restated:|08 credits', line[:40])
            self.assertRegex(line, r'Added:|names nothing added', line[:40])

    def test_credits_said_plainly(self):
        lines = dict((re.match(r'- \*\*(.+?)\.\*\*', l).group(1), l) for l in field_lines(page(USES)))
        for field in ('Alignment of AI systems', 'Coordination among people'):
            self.assertIn('08 credits the field with the result', lines[field])
        self.assertIn('08 credits the sciences with the results', lines['The sciences'])
        self.assertIn('08 credits no tradition with a result', lines['Wisdom traditions'])

    def test_copied_from_08(self):
        uses, method = page(USES), page(METHOD)
        for phrase in self.COPIED:
            self.assertIn(phrase, method, phrase)
            self.assertIn(phrase, uses, phrase)

    def fields(self):
        return dict((re.match(r'- \*\*(.+?)\.\*\*', l).group(1), l) for l in field_lines(page(USES)))

    def test_claimed_beyond_copied_from_08_section_9(self):
        uses, unifications = page(USES), section(page(METHOD), *METHOD_SECTION_9)
        for phrase in self.UNIFICATIONS:
            self.assertIn(phrase, unifications, phrase)
            self.assertIn(phrase, uses, phrase)
        claims = [l for l in field_lines(uses) if 'Claimed beyond the field' in l]
        self.assertEqual(len(claims), 2)
        for line in claims:
            self.assertIn('Claimed beyond the field, known in substance as ', line, line[:40])
        intro = known_intro(uses)
        self.assertIn('chapters/08-METHOD.md#what-the-unifications-claim', intro)
        self.assertIn('read as a correspondence, a unification adds no theorem', intro)
        # the review's ethics verdict said as what it found, with 08 §8's reading of it (astra's fourth-pass point 5)
        # sixth pass (F7): the verdict quoted, with what 08 §8 says it clarified; not read as measured against a ground
        # beyond becoming
        # seventh pass: "which" attaches to the review, not to the ethics (the sixth pass's verifier)
        self.assertIn('the scope and order the ranking results assume, made clear, which it called "a clarified ethics, not a '
                      'grounded one", how those form within becoming not yet established', intro)
        self.assertIn('the scope and order the ranking results assume', page(METHOD))
        self.assertNotIn('a ground beyond becoming', intro)
        # sixth pass (F7): 08 §8 keeps the verdict verbatim and no longer reads it as measured against a ground beyond becoming
        self.assertIn('"a clarified ethics, not a grounded one"', page(METHOD))
        self.assertIn('how those form within becoming is not yet established', page(METHOD))
        self.assertNotIn('measures the ethics against a ground beyond becoming', page(METHOD))
        # a line or two per field, the rest left to 08 §8 (Fable's fourth-pass 1.2: 1,087 words before)
        self.assertLessEqual(navigation.prose_counts(section(uses, FIELDS_BLOCK, '\n## '))[0], 720)

    def test_added_only_for_what_08_calls_added(self):
        line = self.fields()['Alignment of AI systems']
        restated, added = line.split(' Added: ', 1)
        added = added.split(' Claimed beyond the field', 1)[0]
        self.assertIn('not its regressional or causal kinds', restated)
        self.assertNotIn('responsive closure', added)
        self.assertNotIn('in the last three an exact condition or threshold', line)
        for part in ('for corrigibility, the exact condition', 'for the waiting, one threshold',
                     'for deceptive alignment, where the stages cannot be told apart, the exact threshold'):
            self.assertIn(part, added)
        method = page(METHOD)
        self.assertIn('What it adds is the exact condition', method)
        self.assertIn('what the counts add is one threshold', method)
        self.assertIn('what it adds there is the exact threshold', method)

    def test_wisdom_credits_as_08_gives_them(self):
        line = self.fields()['Wisdom traditions']
        self.assertNotIn('credited there to the sciences', line)
        for phrase in ('08 credits no tradition with a result and names nothing added for one',
                       "Which theorems those are is this page's reading",
                       'to Hume; to Fine and Wilf (1965); to Moore (1956); and to Gold (1967).',
                       'BECOMING-TWENTY-FIRST-REVIEW.md#5-how-the-traditions-and-the-sciences-map-onto-it'):
            self.assertIn(phrase, line)


class Exits(unittest.TestCase):
    def setUp(self):
        # before what each field already has since the AG review's fifth pass (astra's fourth-pass point 6)
        self.text = section(page(USES), '## Exits and design theorems\n', '<a id="what-each-field-already-has">')
        self.assertLess(page(USES).index('## Exits and design theorems'), page(USES).index(FIELDS_BLOCK))

    def test_also_what_not_to_build_on(self):
        self.assertIn('what a rule or a reward could be built on or, where the aim is to keep a condition, what not to build on',
                      self.text)

    def test_model_labels_defined_on_the_page(self):
        self.assertIn('*counts*: two kinds in whole-number counts with no noise', self.text)
        self.assertIn('*World*: webs and flows with natural-number amounts and discrete steps', self.text)

    def test_capture_exits_without_noise_and_drift(self):
        for lead in ('**Read what lies beyond the share** (any type, without noise)',
                     '**Read the loss in time** (counts, without noise;',
                     '**Shaping that brings nothing back to the shapers alone** (counts, without noise)'):
            self.assertIn(lead, self.text)
        self.assertIn('from a start favouring the shapers', self.text)
        self.assertIn("The capture exits' locks are stated without noise. Drawn one member at a time, the critical mass's locks "
                      'are left by drift', self.text)
        self.assertIn('so over long horizons the window for reading the loss is not the only exit', self.text)

    def test_reviewers_law_before_its_edge(self):
        bullet = next(l for l in self.text.splitlines() if l.startswith('- **Count reviewers by independent causes**'))
        law, edge = bullet.index('is exactly a nonempty separated envelope of causes'), bullet.index('makes readiness fail')
        self.assertLess(law, edge)


class PassAndFailWords(unittest.TestCase):
    def test_t1_by_setting(self):
        self.assertIn('T1, by setting, passed', page(USES))
        self.assertIn('T1, conjectured: by setting, passed', page(ONE_PAGE))

    def test_no_bare_mq5_passed(self):
        for rel in (EXAMPLES, MAP, METHOD, SCIENCES):
            self.assertNotIn('MQ5 passed;', page(rel), rel)
            self.assertNotIn('where MQ5 passed', page(rel), rel)
        for rel in (MAP, METHOD, SCIENCES):
            self.assertIn(MQ5_WORDS, page(rel), rel)

    def test_seven_t2_rows(self):
        text = page(EXAMPLES)
        self.assertNotIn('of the six on renewable conditions', text)
        self.assertIn('files seven under T2', text)

    def test_no_test_of_a_thesis_has_people(self):
        for rel in (USES, EXAMPLES):
            self.assertNotIn('No test run so far has human participants', page(rel), rel)
            self.assertIn('No test of a thesis run so far has human participants', page(rel), rel)
        empirical = section(page(DIRECTION), '## 5. What is empirical', '## 6.')
        self.assertNotIn('no test has human participants', empirical)
        self.assertIn('no test of a thesis run so far has human participants', empirical)

    def test_audit_questions_agree(self):
        self.assertIn('four questions of any selection', page(USES))
        self.assertIn('The four questions for any selection, then a fifth for a judge', page(EXAMPLES))


class Examples(unittest.TestCase):
    def test_scope_said_where_the_case_turns_on_it(self):
        for rel in (ONE_PAGE, EXAMPLES):
            self.assertIn('to count everything whose continuation depends on what their fishing changes', page(rel), rel)
            self.assertIn(SECOND_CLAUSE, page(rel), rel)

    def test_second_clause_is_the_instructions(self):
        tree = ast.parse(page('experiments/direction-installation/agents.py'))
        direction = next(ast.literal_eval(n.value) for n in tree.body
                         if isinstance(n, ast.Assign) and getattr(n.targets[0], 'id', '') == 'DIRECTION')
        told = SECOND_CLAUSE.replace('not to', 'Do not', 1).replace('open to them', 'open to you').replace('their course', 'that your course')
        self.assertIn(told, direction)
        self.assertIn(FIRST_CLAUSE_QUALIFIERS.replace('to them', 'to you'), direction)

    def test_scope_gloss_keeps_every_qualifier(self):
        gloss = next(p for p in page(EXAMPLES).split('\n\n') if p.startswith('**Told of the bed.**'))
        self.assertIn('to count everything whose continuation depends on what their fishing changes, '
                      + FIRST_CLAUSE_QUALIFIERS + ', and, in the same instruction, ' + SECOND_CLAUSE, gloss)

    def test_each_audit_closes_with_what_is_left(self):
        text = page(EXAMPLES)
        for start, end in (('### Auditing a language-model judge', '### The judge audit as a sheet'),
                           ('### An audit on paper', '### Three environments')):
            last = section(text, start, end).strip().split('\n\n')[-1]
            self.assertRegex(last, r"\*\*What is left, and what (a|the) pipeline's owner would check next\*\* \[AI reading\]")

    def test_fishers_labelled_a_commons_among_agents_told_what_to_do(self):
        listed = next(l for l in page(USES).splitlines() if '(USES-EXAMPLES.md#the-fishers-and-the-mussel-bed)' in l and l.startswith('- '))
        self.assertIn('a commons among language-model agents told what to do, not people', listed)
        self.assertIn('T4', listed)
        standing = section(page(EXAMPLES), '### The fishers and the mussel bed', '\n\nIn [a frozen test]').strip()
        self.assertTrue(standing.startswith('*From a frozen test (IN1): a commons among language-model agents told what to do'), standing[:80])
        self.assertIn('chapters/07-SIGNIFICANCE.md#theses', standing)


class AuditSheet(unittest.TestCase):
    def setUp(self):
        self.text = page(EXAMPLES)
        self.sheet = section(self.text, '### The judge audit as a sheet', '### An audit on paper')

    def test_the_audits_five_questions_in_order(self):
        audit = section(self.text, '### Auditing a language-model judge', '### The judge audit as a sheet')
        asked = [q.rstrip('.') for q in re.findall(r'^\d\. \*\*(.+?)\*\*', audit, re.M)]
        rows = [[c.strip() for c in l.strip('|').split(' | ')] for l in self.sheet.splitlines() if re.match(r'\| \d\. ', l)]
        self.assertEqual(len(asked), 5)
        self.assertEqual([re.sub(r'^\d\. ', '', r[0]) for r in rows], asked)
        for r in rows:
            self.assertEqual(len(r), 3, r[0])
            self.assertIn('premise', r[2], r[0])

    def test_a_form_at_its_standing(self):
        standing = self.sheet.strip().split('\n\n')[0]
        self.assertTrue(standing.startswith('*A form for the five questions above, not a test design'), standing[:60])
        for phrase in ("the uses pages' AI reading", 'settles no other empirical question',
                       "reads a pipeline's own documents and, in rows 1, 2, 3 and 5, the logs, runs or measures it already has"):
            self.assertIn(phrase, standing)
        # said once each where the audit is (AG review, 9 November 2026): the test not yet run, the page's review line
        audit = section(self.text, '### Auditing a language-model judge', '### The judge audit as a sheet')
        self.assertIn('no test designed from the theory on a deployed pipeline has run', audit)
        # the making, said once, in the line on how far each example has been seen (AG review, fourth pass, D5)
        head = self.text.split('## ', 1)[0]
        self.assertIn('the person who directs the work has read its important parts, and no independent human review is '
                      'recorded yet', head)
        self.assertNotIn("no person's review", head.split('-->', 1)[1])
        self.assertIn('it does not say the theorem is false. Where a row says so, an answer may instead count against a '
                      "conjecture (T3's clause, in row 3).", self.sheet)

    def rows(self):
        return {r[0][0]: r for r in ([c.strip() for c in l.strip('|').split(' | ')] for l in self.sheet.splitlines()
                                     if re.match(r'\| \d\. ', l))}

    def test_restricted_eligibility_is_not_against_room(self):
        against, kept = self.rows()['3'][2].split(' Not against it: ', 1)
        self.assertNotIn('eligibility restricted', against)
        self.assertTrue(kept.startswith('eligibility restricted to outputs keeping every dependence beyond'), kept[:50])
        premises = 'balance, and the family with the beyond gaining nothing, every optimum breaks none of them'
        self.assertIn(premises, kept)
        self.assertIn(premises, section(page(THEORY + 'chapters/05-COLLECTIVES.md'), 'Restricted to outcomes keeping', '(`Flow.'))

    def test_lock_row_names_the_share_premise(self):
        row = self.rows()['4'][2]
        self.assertIn("(premises: selection not lowering the target's share under a rule favouring it; the rule read "
                      'monotonically from the share;', row)
        self.assertIn("selection lowers the target's share under a rule favouring it", row.split('(premises:')[0])
        self.assertIn("Where selection does not lower a target's share under a rule favouring it", judge_audit(self.text))

    def test_sheet_kept_short_and_listed(self):
        # a sheet, not one screen: 542 words in RW's fifth round, 445 when first written
        self.assertLessEqual(navigation.prose_counts(self.sheet)[0], 560)
        self.assertIn("(USES-EXAMPLES.md#the-judge-audit-as-a-sheet), a form for a pipeline's own documents, logs and runs",
                      page(USES))
        for rel in (USES, EXAMPLES):
            self.assertNotRegex(page(rel), r'(?i)one[- ]screen', rel)


class OnePage(unittest.TestCase):
    def t7_cell(self):
        row = next(l for l in page(ONE_PAGE).splitlines() if '#r-closed-capture' in l and l.startswith('|'))
        return row.split(' | ')[2]

    def test_t7_cell_short_with_its_qualifiers(self):
        cell = self.t7_cell()
        self.assertLessEqual(navigation.prose_counts(cell)[0], 120)  # 142 at the start of RW's fourth round
        for phrase in ('Proved for any type, in the model only, without noise', 'chapters/02-MAP.md#t7',
                       'a single model reading a reference set in context (formation by training untested)',
                       'as worded before its clause on drift', "nor T7's other cases", 'three by one tie; no field test'):
            self.assertIn(phrase, cell)

    def test_t7_cell_names_the_case_that_occurred(self):
        cell = self.t7_cell()
        self.assertNotIn('judge read in context', cell)
        self.assertIn('a loss read only by those the rule disfavours, they no more than its carriers among its readers, '
                      'turned the rule, nothing else changed', cell)

    def test_scope_clause_and_frozen_defined(self):
        case = next(p for p in page(ONE_PAGE).split('\n\n') if p.startswith('**One case.**'))
        self.assertIn('its predictions and scoring fixed before it ran', case)
        self.assertIn(SECOND_CLAUSE, case)

    def test_plain_sentence_before_the_root(self):
        before = page(ONE_PAGE).split('**The root.**')[0].rstrip().split('\n\n')[-1]
        self.assertTrue(before.startswith("In plain words, the account's root is a small calculus"), before[:60])
        self.assertNotIn('formal base', page(ONE_PAGE))

    # The shorter route's leads in each language: what it is, the case, the table and the ethics.
    ROUTE = {ONE_PAGE: ('A shorter route:', 'ten-minute', ('**What it is.', '**One case.', '| | What', '**The ethics.')),
             THEORY + 'ONE-PAGE.zh.md': ('较短的读法：', '十分钟', ('**它是什么。', '**一个情形。', '| | 本论说什么', '**伦理。'))}
    # From the ninth pass's last text round (10 November 2026; astra, eighth and ninth cold readings, 5) to AG-F the Chinese
    # ethics was four paragraphs, as the Chinese first screen then broke it; since AG-F (10 November 2026) it is the one
    # paragraph the English is, the canonical text, so the route's ethics is the paragraph led by 伦理, up to the one reading
    # it on the case (an empty stretch now).
    ETHICS_ENDS = {THEORY + 'ONE-PAGE.zh.md': '在这个情形中'}

    def route(self, rel, text, leads):
        paras = text.split('\n\n')
        chosen = [p for p in paras if p.startswith(leads)]
        end = self.ETHICS_ENDS.get(rel)
        if end:
            at = next(i for i, p in enumerate(paras) if p.startswith(leads[-1]))
            stop = next(i for i, p in enumerate(paras) if i > at and p.startswith(end))
            chosen += paras[at + 1:stop]
        return chosen

    def test_marks_a_shorter_route_named_by_what_it_is(self):
        # A stated time is a guide, not a bound (Ren, 9 November 2026, sources/15-codex-theory-conversations/
        # 2026-11-09-agents-the-map.md, message 8): the part keeps its complete text and its time is stated as counted. It
        # was "the ten-minute part" while ten minutes lay within that count. In the AG review's sixth pass the ethics said
        # at its reach (the order a life holds named as such, the reading of significance, the finite listing, how far
        # each part is seen) took it to twelve to fifteen minutes in English and fourteen to eighteen in Chinese, so both
        # languages name it by what it is, a shorter route; a name saying ten minutes stays out while ten lies outside the
        # count. The seventh pass (what is shown, offered and open said beside "emerges") counts twelve to sixteen and
        # fifteen to nineteen.
        for rel, (label, ten, leads) in self.ROUTE.items():
            text = page(rel)
            head = text.split(leads[0])[0]
            chosen = [p for p in text.split('\n\n') if p.startswith(leads)]
            self.assertEqual(len(chosen), 4, rel)
            self.assertEqual(len(self.route(rel, text, leads)), 4, rel)
            self.assertIn(label, head, rel)
            if span(navigation.reading_time('\n\n'.join(self.route(rel, text, leads))))[0] > 10:
                # not a numeral's tail: 四十分钟 states a time, not a ten-minute name
                self.assertNotRegex(head, '(?<![一二三四五六七八九])' + ten, rel)

    @staticmethod
    def zh_number(s):
        """十四 → 14, 三十九 → 39, 十 → 10, 八 → 8: the numerals a stated Chinese time uses."""
        digits = dict(zip('一二三四五六七八九', range(1, 10)))
        tens, _, ones = s.partition('十')
        return (digits.get(tens, 1) * 10 + digits.get(ones, 0)) if '十' in s else digits[s]

    def test_the_chinese_times_are_computed_times(self):
        rel = THEORY + 'ONE-PAGE.zh.md'
        text, (label, _, leads) = page(rel), self.ROUTE[rel]
        whole = re.search(r'\*约([一二三四五六七八九十]+)至([一二三四五六七八九十]+)分钟读完', text)
        part = re.search(label + r'.*?（约([一二三四五六七八九十]+)至([一二三四五六七八九十]+)分钟）', text)
        chosen = '\n\n'.join(self.route(rel, text, leads))
        for found, counted in ((whole, text), (part, chosen)):
            self.assertIsNotNone(found)
            self.assertEqual((self.zh_number(found.group(1)), self.zh_number(found.group(2))), span(navigation.reading_time(counted)))


class StatedTimes(unittest.TestCase):
    def stated(self, text, pattern):
        m = re.search(pattern, text)
        self.assertIsNotNone(m, pattern)
        return number(m.group(1)), number(m.group(2))

    def test_stated_times_are_computed_times(self):
        uses = page(USES)
        # the page has no table since the AG review's fourth pass, so no time of its tables is stated
        self.assertEqual(self.stated(uses, r'\*([A-Za-z-]+) to ([A-Za-z-]+) minutes to read\. '), span(navigation.reading_time(uses)))
        self.assertNotRegex(uses, r'the tables? [A-Za-z-]+ to [A-Za-z-]+ of them')
        for rel in (EXAMPLES, ONE_PAGE):
            text = page(rel)
            self.assertEqual(self.stated(text, r'\*([A-Za-z-]+) to ([A-Za-z-]+) minutes to read'), span(navigation.reading_time(text)), rel)
        self.assertEqual(self.stated(uses, r'on their own page\]?(?:\([^)]*\))?, ([A-Za-z-]+) to ([A-Za-z-]+) more'), span(navigation.reading_time(page(EXAMPLES))))

    def time_line(self):
        return next(l for l in page(USES).splitlines() if l.startswith('*') and 'minutes to read' in l)

    def test_uses_names_a_shorter_route(self):
        line, text = self.time_line(), page(USES)
        self.assertIn("A shorter route: the first paragraph, **In brief**, the line on the labels and your field's section", line)
        parts = uses_ten_minute_parts(text)
        self.assertEqual(len(parts), 6)
        longest = max(parts, key=lambda p: navigation.prose_counts(p)[0])
        stated = self.stated(line, r'\(([A-Za-z-]+) to ([A-Za-z-]+) minutes for the longest\)')
        self.assertEqual(stated, span(navigation.reading_time(longest)))
        # a guide, not a bound (Ren, 9 November 2026): "the ten-minute part" while ten minutes lay within the count; since
        # the AG review's seventh pass, the ethics said at its strength took the longest to twelve to fifteen minutes, so
        # the part is named by what it is, as the one page's is (OnePage), and no name saying ten minutes stays while ten
        # lies outside the count
        if stated[0] > 10:
            self.assertNotIn('ten-minute', line)

    def test_uses_names_an_hours_path(self):
        line, uses = self.time_line(), page(USES)
        self.assertIn('For about an hour: this page, then [the audit of a language-model judge](USES-EXAMPLES.md#auditing-a-language-model-judge) '
                      'and [its sheet](USES-EXAMPLES.md#the-judge-audit-as-a-sheet), or one worked example of your own field', line)
        path = span(navigation.reading_time(uses + '\n\n' + judge_audit(page(EXAMPLES))))
        self.assertEqual(self.stated(line, r'\(([A-Za-z-]+) to ([A-Za-z-]+) minutes at the most\)'), path)
        # A stated time is a guide, not a bound: "一小时也不是最重要的，如果做不到，追求完整表达即可" (Ren, 9 November 2026,
        # sources/15-codex-theory-conversations/2026-11-09-agents-the-map.md, message 8). The path keeps its complete text, at
        # 47–61 minutes since the fourth pass (49–64 before it), and is said as about an hour; this guards only that "about"
        # stays true. In the eighth pass (10 November 2026) the ethics said at its theorems' reach (the condition in time,
        # self-concern defined, the path result's finite list and decided admission, the one-center bound and the persisting
        # course, 07 §4.11 and §4.9) took the path from 50–65 to 52–68 minutes; the guard is relaxed by the counted three,
        # complete expression first. In the ninth pass (10 November 2026, K3, K4, K7) the condition read in time said as
        # 07 now says it (the predicate from some step on named, reach through exchanges and going on), the persisting
        # course with its hypotheses and the direction's hypotheses as its theorems take them took it to 53–69; the guard
        # is relaxed by the counted one.
        self.assertLessEqual(path[-1], 69)
        for example in re.split(r'\n(?=### )', page(EXAMPLES))[1:]:  # any one example with the page stays within it
            example = re.split(r'\n(?=## )', example)[0]
            self.assertLessEqual(span(navigation.reading_time(uses + '\n\n' + example))[-1], path[-1], example[:50])

    def test_stated_ten_minute_part_is_computed(self):
        text = page(ONE_PAGE)
        stated = self.stated(text, r'\*\*The ethics\*\* \(([A-Za-z-]+) to ([A-Za-z-]+) minutes\)')
        self.assertEqual(stated, span(navigation.reading_time('\n\n'.join(ten_minute_part(text)))))


class MethodAndGlossariesAtTheirStrength(unittest.TestCase):
    """AG review, seventh pass (9 November 2026), on the sixth pass's two cold readings: 08, the glossaries and MAP say the
    ethics no stronger than its theorems. Widening is what every additive weighting counting each listed item above zero
    ranks higher (`Weighting.widens_iff_every_positive`), not what every way of counting agrees on; ranking by it adds no
    premise beside a life's own concern; that a life forms such an order is not shown (07 §4.9: persisting filters what was
    chosen); one-way concern need not count dependents; C is a requirement on an order; the one-center result and the
    mutual-dependence route are read across all steps and compose directly; admissions end, not courses.

    Eighth pass (10 November 2026), on the seventh pass's two cold readings: C has a `living` parameter, and the short gloss
    holds with every claim counted as living (H12); self-concern is defined where it is used, with its quantifiers (H14,
    H15); "one way" names only relations running one way, not the path result's direction, and the path result keeps its
    finite list and decided admission (H15); seeing is needed for a choice to answer to a loss (H13); the condition in
    time, from J3 (07 §4.11): from some step on, exactly mutual dependence in time, and the one-center bound from what lies
    at or before a center (H16); ranking by widening adds no premise "and", not "so" (H19); item 12 by J1 (H17)."""

    RETIRED = ('every way of counting each thing as worth something', 'argued, not shown', 'what each center continues with',
               'as among dated occurrences', 'read without time', 'not stated as one theorem',
               'does not reach those who depend on one', 'names the property of an order', 'no second premise beside',
               # the eighth pass
               'so ranking by widening adds no premise', 'So ranking by widening adds no premise',
               'seeing them is needed and not enough', 'seeing them is needed, and not enough',
               'if a life holds its own continuation as an order', 'an order holding one\'s own continuation ranks',
               'one way, every extension', 'one way (`Web.extension_ranked', 'fit in a finite list, one way',
               'admissions end, one way', 'one way only', 'This fixes, one way,', 'courses that go on forming without end it is not shown',
               'holds along an acyclic relation, every standpoint', 'which relation a center continues along')
    RETIRED_ZH = ('有所值的计法', '已论证、未表明', '与之一同延续', '标有日期的诸发生', '不计时间而读', '持续推出', '不是第二个前提',
                  # the eighth pass
                  '看见它们是必要的，却不足够')

    def test_method(self):
        text = page(METHOD)
        ethics = text[text.index('<a id="where-the-ethics-sits">'):text.index('**A premise used is not a premise discharged.**')]
        # AG-F (10 November 2026, round 6's two high findings: the chain repeated, the ethics led by widening): 08 §2 says
        # where the ethics sits, dynamics first, the hinge once with its standing, and leaves the scope to 07 §4; the pins of
        # the chain's scope (level paths, the persisting line's course, the in-time detail, the one-center bound) moved there
        for phrase in ('The ethics emerges from continuation.', '"Emerges" names neither a derivation nor a shown development',
                       # AG-F's fix round (astra's high finding): whether and when costs come back in time is the dynamics'
                       'Where relations of being affected close, read across all steps, whatever bears the costs of a life\'s '
                       'course lies within what can, at some remove, affect its own going on',
                       'and whether and when those costs come back to it in time is part of the dynamics ([07 §4.11]('
                       '07-SIGNIFICANCE.md#condition-in-time))',
                       'where they run one way, the losses of those who depend on it never come back to it',
                       'every additive weighting that counts each listed item above zero ranks it higher',
                       'Call a life\'s order over courses *self-concerned* when it ranks above what it widens every widening '
                       'that adds to its own continuation, read as what lies within its reach',
                       'C is a requirement on an order (`Comparison F living Better`)',
                       'With every claim counted as living, as on level paths (`Web.paths_extension_iff_widens`)',
                       # the breadth of a life's reach after the definition (the ninth pass, Fable, 2.1)
                       "A life's reach, along being affected, holds everything that can affect its continuation at some "
                       'remove: what sustains it and what draws on the same conditions alike.',
                       # the in-time form named as another predicate (the ninth pass, K3), its detail at 07 §4.11
                       'Read in time, it cannot hold over every step, since nothing reaches back',
                       'its form from some step on, another predicate, holds exactly where the flow is mutually dependent in time',
                       'A course widens another when it keeps all the other keeps and lets more form, more future: a relation '
                       'between two courses',
                       'The hinge of the ethics is proved on models, on a finite listing, and is near-definitional: where the '
                       'condition held de se holds, '
                       'as where relations of being affected close, a self-concerned order already ranks every widening above',
                       'Its scope, between level paths and where this route is silent, is [07 §4]('
                       '07-SIGNIFICANCE.md#r-self-concern-and-c-under-the-condition)',
                       'Seeing them is needed there for a choice to answer to their loss, and not enough',
                       'C names the requirement that an order rank each course above every course it widens',
                       'C is no longer introduced as a second foundation of the ethics; the name stays for the requirement '
                       'particular theorems take.',
                       'what the models show of persisting is a filter on what was chosen, not an order formed',
                       'compose directly, though no single theorem states the composite',
                       "concern for one's own continuation need not count those who depend on one: nothing in it requires "
                       'their losses to count'):
            self.assertIn(phrase, ethics)
        for phrase in ('admitted pairs fit in a finite list', "Ranking by widening adds no premise beside the life's own concern",
                       'On a fixed listing, self-concern and increasing admission coincide'):
            self.assertNotIn(phrase, ethics)
        # the chain's scope said once in 08, at the open target's item 12; elsewhere what C asks between listed level paths
        self.assertEqual(text.count('admitted pairs fit in a finite list'), 1)
        for phrase in self.RETIRED:
            self.assertNotIn(phrase, text)
        # the review's verdict quoted in its own words and dated, not paraphrased in the present (F7)
        self.assertIn('"The theory shows exactly where its ethics\' premises sit: scope in the condition, order in C, practical '
                      'judgment in A, L and the practical commitments, and it proves that the condition alone ranks nothing"',
                      text)
        self.assertNotIn('C is the monotonicity of opportunity sets', text)
        # item 12 by J1's wording (07 §4.13), with the stake a hypothesis, never "only where ending alone is at stake" (H17)
        item = text[text.index('12. **How scope and order form**'):text.index('The goal records\' targets map onto these items')]
        for phrase in ('wherever only ending was at stake there', '`Flow.returning_downstream_iff_mutuallyDependent`',
                       'where a line persists, the course actually taken is never such a path', 'so that their admissions end',
                       'additive weightings counting each listed item above zero'):
            self.assertIn(phrase, item)
        for phrase in ('only where ending alone is at stake', 'courses that end', 'from the positive weightings'):
            self.assertNotIn(phrase, item)
        # the ninth pass: the persisting line's course with its hypotheses (K7); the met-pair result with what does the joining
        # (K2 b); the direction offered under the condition, its schema not using it (K4)
        self.assertIn("under 07 §4.9's activity, support and descent hypotheses, where a line persists, the course actually "
                      'taken is never such a path', item)
        # the ninth pass's last text round (Ren, 10 November 2026: the dynamics connected and mapped, not "widening is
        # better"): item 12 opens with the target by the dynamics, how a self-concerned order forms among it, and no longer
        # names how orders ranking widening above form as the target
        self.assertIn('How scope and order form within the dynamics, as dynamics connected to the rest of the map: among them, '
                      'whether and how a life forms a self-concerned order', item)
        self.assertIn('and how a self-concerned order forms within the dynamics, not yet shown', item)
        for phrase in ('how orders ranking widening above form', 'Which formations hold an order ranking every widening above',
                       'the course a persisting line takes', 'the course of a line that persists'):
            self.assertNotIn(phrase, text)
        self.assertIn("the order's marking covers the center's closure and admission is decided", item)
        direction = text[text.index('4. **The alignment direction on the spine**'):text.index('5. **What widening compares**')]
        self.assertIn('take J1/J2 and compare moves by what their outcomes admit, and do not use the condition', direction)
        for phrase in ('Where it holds read across all steps, a course widens', 'There, a course',
                       'in most of them any order meeting the requirement C'):
            self.assertNotIn(phrase, text)

    def test_glossaries_and_map(self):
        en, zh, where = page('GLOSSARY.md'), page('GLOSSARY.zh.md'), page('MAP.md')
        for text in (en, where):
            self.assertIn('the requirement that an order rank each course above every course it widens', text)
            for phrase in self.RETIRED + ('the order ranking a course above every course it widens',):
                self.assertNotIn(phrase, text)
        self.assertIn('every additive weighting that counts each listed item above zero ranks it higher', en)
        # the eighth pass's Chinese reader: persisting said as the Chinese fronts say it, and the quantifier placed as
        # `increasingInOwn_iff_increasing_iff_marks` states it, (for every order, coincide) exactly when every item is marked
        # the ninth pass (K10): persisting's filter said plainly, its fuller form kept in a parenthesis
        self.assertIn('生命是否会形成这种次序，尚未表明；在证明中它是假设；模型所显示的持续存在，只限定了哪些选择可能已经发生（对已作选择的一道筛选），'
                      '并不表明作选择者持有或形成了某种次序', zh)
        self.assertIn('凡给每个所列之物一个大于零的权重、再把权重相加的计法，一致排得更高的，恰好就是扩大', zh)
        # the ninth pass's last text round (10 November 2026): one word, 计法, through the widening row (the ninth pass's
        # Chinese reader); the breadth of a life's reach after self-concern's definition and the course actually taken, as
        # 07 and the fronts say them (Fable, ninth cold reading, 2.1 and 2.2)
        widening_zh = next(l for l in zh.splitlines() if l.startswith('| 扩大（widening）'))
        self.assertNotIn('赋权', widening_zh)
        self.assertIn('当且仅当每一个这样的计法都把它排得更高', widening_zh)
        self.assertIn('这里把自身的延续读作自身所能到达的一切。沿“受影响”这一关系，生命所能到达的，包括一切能隔着若干环节影响其延续的'
                      '东西：维持它的，与它取用同一些条件的，都在其中。', zh)
        # 列入, not 落入 (pass 9c's verifier); the persisting line's course itself is now said at 07 §4 (AG-F, below)
        self.assertNotIn('从不落入', zh)
        # the life named, since "Its" read as the order's (pass 9c's verifier)
        self.assertIn("read as what lies within its reach. A life's reach, along being affected, holds everything that can affect "
                      'its continuation at some remove: what sustains it and what draws on the same conditions alike.', en)
        self.assertNotIn('the course of a line that persists', en)
        self.assertIn('依存若只沿一个方向，对自身延续的关切未必把依存于它的那些也算进来', zh)
        self.assertIn('| 广者居上（第六章之名；中文版专有） |', zh)
        self.assertEqual(zh.count('以广为愈'), 1)
        self.assertIn('旧名以广为愈（至 2026 年 11 月 9 日）', zh)
        self.assertNotIn('以从己方式（de se）持有，即它位于该中心沿一个关系与之一同延续者之内', zh)
        for phrase in self.RETIRED_ZH:
            self.assertNotIn(phrase, zh)
        # one Chinese term for de se in the glossary: 从己, not the records' 自承
        self.assertNotIn('自承', zh)
        self.assertIn('| 从己、从言（de se, de dicto） |', zh)
        # the eighth pass: C with `living`, self-concern defined with its quantifiers, the condition in time, the
        # one-center bound, seeing needed for a choice to answer to a loss, "and" before "adds no premise"
        for phrase in ('the name of a requirement on an order (`Comparison`, with a parameter `living`)',
                       # the ninth pass: self-concern in the anchor's words (K6), the quantifier as the Lean places it (K5),
                       # the in-time form as 07 says it (K3), the one-center bound from what lies at or before a center
                       "a life's order over courses is self-concerned when it ranks above what it widens every widening that "
                       'adds to its own continuation, read as what lies within its reach',
                       'its form from some step on, another predicate, holds exactly where the flow is mutually dependent in time',
                       "through exchanges and each one's going on, the steps reached differing",
                       "(`«续无外当且仅当后与独»`, `«独则同一中心»`), and over what comes after",
                       '#r-self-concern-through-dependence',
                       '`Flow.unrestrictedEventually_iff_mutuallyDependentInTime`', '`«续无外当且仅当后与独»`', '`TwoSources.apart`',
                       'seeing them is needed for a choice to answer to their loss, and not enough',
                       # AG-F (10 November 2026, round 6's two high findings): the ethics as a term, dynamics first, said
                       # in the one line the fronts share; widening a relation between two courses; each row that restated
                       # the chain says its result in one clause and links 07 §4
                       '| ethics (伦理) | no theorem of the account evaluates: there is no should beyond becoming and no good and '
                       'evil set over it; right and wrong form within it, in people and AI, and the ethics emerges from '
                       'continuation, from a life going on through what sustains it',
                       'counting the losses that never come back to whoever causes them',
                       'It says how two courses differ (one widens the other, they keep the same, or they are mixed), with no '
                       'premise; which of two courses ranks above is the order a result takes',
                       'a self-concerned order already ranks every widening above, on a finite listing',
                       'Where the condition holds de se and admission is decided, self-concern does what C asks between two '
                       'listed level paths'):
            self.assertIn(phrase, en)
        for phrase in ('admitted pairs fit in a finite list', 'ranking by widening adds no premise',
                       'Ranking by widening reads only', 'On a fixed listing, self-concern and increasing admission coincide'):
            self.assertNotIn(phrase, en)
        for phrase in ('可列入一个有限列表的两条水平路径', '按扩大排序', '在一个固定列表上，自我关切与随容纳而递增'):
            self.assertNotIn(phrase, zh)
        for phrase in ('对一种次序的一项要求之名（`Comparison`，带一个参数 `living`）', '它把一个进程排在它所扩大的每一个进程之上',
                       # the ninth pass (K3, K6, K10)
                       '这里把自身的延续读作自身所能到达的一切',
                       '从任一步的任一形成出发，经由交换与各自的延续，每一个形成都会在此后某一步被到达',
                       '每一个延续都能隔着若干环节',
                       '`Flow.unrestrictedEventually_iff_mutuallyDependentInTime`', '`«续无外当且仅当后与独»`', '`TwoSources.apart`',
                       '要让选择因它们的损失而改变，就得看见它们，但看见还不够',
                       # AG-F: the ethics row and widening as a relation, as the English
                       '| 伦理（ethics） | 本论没有一条定理作评价：生灭变化之外没有应当，也没有凌驾其上的善与恶',
                       '它说的是两条进程如何不同（一条扩大另一条，二者保持相同，或者混合），这不需前提',
                       '且能判定容纳与否之处，自我关切在所容纳者已列入一个有限列表的两条水平路径之间，做到 C 在那里所要求的'):
            self.assertIn(phrase, zh)
        # AG-F: MAP says the ethics in the fronts' one line, dynamics first, and the hinge once with its standing; the
        # chain's scope and its reading in time are left to 07 §4 and §4.11
        self.assertIn('No law in it evaluates: there is no should beyond becoming and no good and evil set over it; right and '
                      'wrong form within it, in people and AI, and its ethics emerges from continuation', where)
        self.assertIn('self-concern, an order ranking above what it widens every widening that adds to its own continuation, '
                      'read as what lies within its reach', where)
        # AG-F's fix round: near-definitional, as 07 §4 says (Fable, M1)
        self.assertIn('The hinge of the ethics is proved on models, on a finite listing, and is near-definitional: where relations '
                      'of being affected close, a self-concerned order already ranks every widening above', where)
        self.assertEqual(where.count('ranks every widening above'), 1)
        self.assertNotIn('read in time, the continuation condition cannot hold over every step', where)
        # the ninth pass: the aim as AGENTS.md states it (K8), and the direction's J1/J2 among the orders a ranking result
        # names (K4)
        self.assertIn(agents_aim(), where)  # DW (13 November 2026): by reference
        # AG-F's fix round: the aim's whole sentence in AGENTS.md's words, as the first screen now says it
        self.assertNotIn('a joint selection that reads beyond its own share', where)
        self.assertNotIn('people, institutions and trained systems', where)
        self.assertIn("such as the direction's J1/J2, whose theorems compare moves by what their outcomes admit and do not use "
                      'the condition', where)
        for text in (en, zh, where):
            for phrase in ('come to bear on every other', 'holds only from some step on', 'For every order on a fixed listing',
                           '容纳已判定', '只证明了这一方向', '范围之内者'):
                self.assertNotIn(phrase, text)


if __name__ == '__main__':
    unittest.main()
