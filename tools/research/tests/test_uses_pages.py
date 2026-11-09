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
# C's" but the order a ranking result takes as its theorem's hypothesis
TOOL_SENTENCE = ('The tool needs no premise', "a result ranking the wider course above names its order among its theorem's "
                 'hypotheses: self-concern with the condition held de se, or C (`Comparison`)',
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
           'ranks more narrowly', 'a matter of reach', 'there is none to find', 'measures the ethics against')
RETIRED_ZH = ('扩大可形成者更好', '以广为愈', '两种读法', '不断言', '持 C 者','对所等待的一切都可以不等', '共有之物', '塑规者',
              '被离开', '走出', '「', '」', '所读之外的什么', '一个体制的不可回返之点', '读到过一行', '正反两面的见证',
              # the sixth pass, as RETIRED's last line; astra's fifth-pass wording of the point of no return
              'C（次序）', 'C（扩大）定次序', '那样给诸进程排序', '如 C 所要求', '列出的进程', '尚未合为一条定理',
              '不持守它的便止息', '所及多远的问题', '本无可寻', '一种动态越过就无法回返的临界点')
METHOD_SECTION_9 = ('**What the unifications claim.**', '<a id="one-relational-unfolding">')

WORDS = {'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5, 'six': 6, 'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10,
         'eleven': 11, 'twelve': 12, 'thirteen': 13, 'fourteen': 14, 'fifteen': 15, 'sixteen': 16, 'seventeen': 17,
         'eighteen': 18, 'nineteen': 19, 'twenty': 20, 'thirty': 30, 'forty': 40, 'fifty': 50, 'sixty': 60, 'seventy': 70}


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
        self.assertIn("so that a loss beyond the shapers' share can turn the rule", do)
        self.assertNotIn('control over itself', do)
        # the third question as 02's shaping law asks it (AG review, fifth pass; astra's fourth-pass Chinese point 1)
        self.assertIn("who receives what shaping brings back and whether it covers the shapers' cost", do)
        self.assertNotIn('whether control comes back', do)
        self.assertIn('an AI-authored plan', next(l for l in lines if l.startswith('**Reading.** The three questions')))
        self.assertIn('conditional on the continuation condition', next(l for l in lines if l.startswith('**Conditional.**')))

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
        for phrase in ('how winning comes to buy power over the rule that selects: the loop the work calls the '
                       '[meta-attractor](../meta-attractor/README.md). Its closed form, where the rule and how it is read are '
                       'both formed from the share it selects, can lock: on stated models, where selection does not lower the '
                       'favoured share and the rule and its reading follow it upward and keep favouring it, a locked start '
                       'stays locked however large an unread loss grows ([02 §9](chapters/02-MAP.md#r-closed-capture))',
                       'falls into neither instrumental convergence nor the meta-attractor: where shaping its rule is selected, '
                       "the rule still reads what lies beyond the shapers' share, so that a loss there can turn it "
                       '([the goal](../../GOALS.md#generative-alignment))'):
            self.assertIn(phrase, first)
        self.assertNotIn('control over its own selection', text)
        brief = next(p for p in text.split('\n\n') if p.startswith('**In brief.**'))
        # the ethics as 07 says it since the fifth pass, and as the first screen's anchor says it since the sixth (F1-F9):
        # no should and no good and evil over becoming; the ethics emerging from continuation; a life going on through what
        # sustains it, and forming an order over courses (self-concern) argued, not shown; relations closing read without
        # time; the ranking proved on a finite listing and, one way, between courses that end; widening as what every
        # positive weighting agrees on, no second premise; seeing needed, and not enough, where relations run one way
        for phrase in ('There is no should beyond becoming ([the opening](OPENING.md)), and no good and evil set over it',
                       'form within it, in people and AI ([07 §1](chapters/07-SIGNIFICANCE.md#evaluation))',
                       'The ethics emerges from continuation. A life goes on through what sustains it',
                       'holds its own continuation as an order over courses, *self-concern*',
                       'relations close, read without time',
                       'one course keeping all another keeps and letting more form, more future',
                       'proved on models, on a finite listing and, one way, between two courses whose admissions fit in a '
                       'finite list, courses that end',
                       'that a life forms such an order is argued, not shown',
                       'Widening is what every way of counting each thing as worth something agrees on, and no second premise',
                       'seeing them is needed, and not enough, and counting their loss is the one step we offer',
                       'the laws show it mixed and weigh it for no one'):
            self.assertIn(phrase, brief)
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
        self.assertIn('In [04 §8]', by_label['Proved'])
        self.assertIn('they are mixed, some positive weighting ranking them each way, and the laws weigh them for no one',
                      by_label['Proved'])
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
        self.assertIn('"a clarified ethics, not a grounded one", which made clear the scope and order the ranking results '
                      'assume, how those form within becoming not yet established', intro)
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
                       "Which laws those are is this page's reading",
                       'to Hume; to Fine and Wilf (1965); to Moore (1956); and to Gold (1967).',
                       'BECOMING-TWENTY-FIRST-REVIEW.md#5-how-the-traditions-and-the-sciences-map-onto-it'):
            self.assertIn(phrase, line)


class Exits(unittest.TestCase):
    def setUp(self):
        # before what each field already has since the AG review's fifth pass (astra's fourth-pass point 6)
        self.text = section(page(USES), '## Exits and design laws\n', '<a id="what-each-field-already-has">')
        self.assertLess(page(USES).index('## Exits and design laws'), page(USES).index(FIELDS_BLOCK))

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
        self.assertIn('it does not say the law is false. Where a row says so, an answer may instead count against a '
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

    def test_marks_a_shorter_route_named_by_what_it_is(self):
        # A stated time is a guide, not a bound (Ren, 9 November 2026, sources/15-codex-theory-conversations/
        # 2026-11-09-agents-the-map.md, message 8): the part keeps its complete text and its time is stated as counted. It
        # was "the ten-minute part" while ten minutes lay within that count. In the AG review's sixth pass the ethics said
        # at its reach (the order a life holds named as such, the reading of significance, the finite listing, how far
        # each part is seen) took it to twelve to fifteen minutes in English and fourteen to eighteen in Chinese, so both
        # languages name it by what it is, a shorter route; a name saying ten minutes stays out while ten lies outside the
        # count.
        for rel, (label, ten, leads) in self.ROUTE.items():
            text = page(rel)
            head = text.split(leads[0])[0]
            chosen = [p for p in text.split('\n\n') if p.startswith(leads)]
            self.assertEqual(len(chosen), 4, rel)
            self.assertIn(label, head, rel)
            if span(navigation.reading_time('\n\n'.join(chosen)))[0] > 10:
                self.assertNotIn(ten, head, rel)

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
        chosen = '\n\n'.join(p for p in text.split('\n\n') if p.startswith(leads))
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

    def test_uses_names_a_ten_minute_part(self):
        line, text = self.time_line(), page(USES)
        self.assertIn("The ten-minute part: the first paragraph, **In brief**, the line on the labels and your field's section", line)
        parts = uses_ten_minute_parts(text)
        self.assertEqual(len(parts), 6)
        longest = max(parts, key=lambda p: navigation.prose_counts(p)[0])
        stated = self.stated(line, r'\(([A-Za-z-]+) to ([A-Za-z-]+) minutes for the longest\)')
        self.assertEqual(stated, span(navigation.reading_time(longest)))
        # a guide, not a bound (Ren, 9 November 2026): the name stays true while ten minutes lies within the count; the one
        # page's part, past it since the AG review's sixth pass, is named "A shorter route" (OnePage)
        self.assertLessEqual(stated[0], 10)

    def test_uses_names_an_hours_path(self):
        line, uses = self.time_line(), page(USES)
        self.assertIn('For about an hour: this page, then [the audit of a language-model judge](USES-EXAMPLES.md#auditing-a-language-model-judge) '
                      'and [its sheet](USES-EXAMPLES.md#the-judge-audit-as-a-sheet), or one worked example of your own field', line)
        path = span(navigation.reading_time(uses + '\n\n' + judge_audit(page(EXAMPLES))))
        self.assertEqual(self.stated(line, r'\(([A-Za-z-]+) to ([A-Za-z-]+) minutes at the most\)'), path)
        # A stated time is a guide, not a bound: "一小时也不是最重要的，如果做不到，追求完整表达即可" (Ren, 9 November 2026,
        # sources/15-codex-theory-conversations/2026-11-09-agents-the-map.md, message 8). The path keeps its complete text, at
        # 47–61 minutes since the fourth pass (49–64 before it), and is said as about an hour; this guards only that "about"
        # stays true.
        self.assertLessEqual(path[-1], 65)
        for example in re.split(r'\n(?=### )', page(EXAMPLES))[1:]:  # any one example with the page stays within it
            example = re.split(r'\n(?=## )', example)[0]
            self.assertLessEqual(span(navigation.reading_time(uses + '\n\n' + example))[-1], path[-1], example[:50])

    def test_stated_ten_minute_part_is_computed(self):
        text = page(ONE_PAGE)
        stated = self.stated(text, r'\*\*The ethics\*\* \(([A-Za-z-]+) to ([A-Za-z-]+) minutes\)')
        self.assertEqual(stated, span(navigation.reading_time('\n\n'.join(ten_minute_part(text)))))


if __name__ == '__main__':
    unittest.main()
