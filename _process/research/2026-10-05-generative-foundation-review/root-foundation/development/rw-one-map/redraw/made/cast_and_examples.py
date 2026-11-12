# AI-written, 12 November 2026. The cold reader understood the three steps of the first path that carry an example
# and stopped at the ones that do not; and met "the same side", "the lead", "the rest", "what sets the rule", "the
# course" and "given from outside" in mid-sentence, never set out. This (1) gives a step the example its box already
# carries, wherever a box on the step has one that fits, and (2) sets out once, before step 1, who and what is in the
# path and what the page's own words mean. The cast is the coordinating AI's writing and goes to a second reader.
# Edits the kit's paths.json and the worktree's module, template and tests. Run once.
import json, os
HERE = os.path.dirname(os.path.abspath(__file__))
WT = '/Users/ren/tmp/rw/map2/wt/tools/research/'

EG = {1: 'b2.uncounted', 6: 'b3.inside', 8: 'b2.felt', 9: 'b2.counted', 12: 'b3.list', 14: 'b2.heard', 15: 'a1.past', 17: 'b1.outside', 18: 'b3.checkers'}
CAST = [
 ('the rule', '规则', 'what the picking goes by: a reward, a score, a price, a count of votes.', '取舍所凭的东西：奖励、分数、价格、票数。'),
 ('an update', '重定', 'the rule set again, here from what it has picked.', '把规则重新定一次；这里说的是照它选出来的结果来定。'),
 ('the favoured side, its share and its lead', '受偏向的一方，它的份额和领先', 'what the rule picks more of, how much of the whole it has, and how far ahead it is.', '规则多选的那一方；它占了多少；它领先多少。'),
 ('the rest', '其余的', 'what is picked among besides the favoured side.', '被取舍的各方里，受偏向的一方之外的。'),
 ('the loss', '损耗', 'something the rule does not count, being used up. What lives on that thing bears it.', '规则没算进去、却在被耗掉的东西。承受后果的，是靠这样东西延续的。'),
 ('what reads the loss, or counts it', '读得到损耗的，把损耗算进去的', 'anything whose judgment changes with the loss.', '判断会随损耗而变的一方。'),
 ('what sets the rule', '定规则的各方', 'those whose judgments the rule is set from.', '规则照哪几方的判断来定，就是哪几方。'),
 ('the shapers', '改规则的一方', 'what spends to change the rule in its own favour.', '花代价把规则往自己这边改的一方。'),
 ('of the course itself; given from outside', '过程自己的；过程之外给定的',
  'the first follows from the picking and updating as they run, with nothing added. The second is either a premise the laws assume or something that has to be supplied from outside the picking.',
  '前一种是说：照这样取舍、重定下去就会如此，不用另外加什么。后一种，要么是定律假定的前提，要么得从取舍之外另行提供。'),
 ('a built example', '造出来的例子', 'a small case made up and worked out exactly, in which the thing happens. It shows that it can happen, not that it must.', '专门搭出来、算得清的小例子，里面确实发生了这件事。它说明这件事会发生，不说明一定发生。'),
]
p = os.path.join(HERE, 'data', 'paths.json')
d = json.load(open(p, encoding='utf-8'))
lock = next(x for x in d['paths'] if x['id'] == 'lock')
n = 0
for sec in lock['sections']:
    for st in sec['steps']:
        n += 1
        if n in EG:
            assert not st.get('eg'), n
            st['eg'] = EG[n]
lock['cast'] = [{'en': a, 'zh': b, 'says_en': c, 'says_zh': e} for a, b, c, e in CAST]
json.dump(d, open(p, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)


def patch(path, pairs):
    s = open(path, encoding='utf-8').read()
    for a, b in pairs:
        assert s.count(a) == 1, (path, s.count(a), a[:90])
        s = s.replace(a, b)
    open(path, 'w', encoding='utf-8').write(s)


patch(WT + 'map_sheet.py', [
    ("        for k in path.get('known', []):\n",
     "        for c in path.get('cast', []):\n"
     "            if not all(c.get(f, '').strip() for f in ('en', 'zh', 'says_en', 'says_zh')): E.append('path %s: an entry of its cast is not filled' % path['id'])\n"
     "        for k in path.get('known', []):\n"),
    ("        for f in ('shows_en', 'shows_zh', 'known'): path.setdefault(f, [])\n", "        for f in ('shows_en', 'shows_zh', 'known', 'cast'): path.setdefault(f, [])\n"),
    ("def _along(m, lang):\n",
     "def _cast(path, lang):\n"
     "    \"\"\"Who and what is in a path, and the page's own words, set out once before its first step.\"\"\"\n"
     "    if not path.get('cast'): return []\n"
     "    return ['**%s**' % S[lang]['cast'], ''] + ['- **%s**%s%s' % (_nm(c, lang), _col(lang), _L(c, 'says', lang)) for c in path['cast']] + ['']\n"
     "\n\n"
     "def _along(m, lang):\n"),
    ("    out += [s['unmarked'].format(paths=f['paths'], id=first['id']), ''] + _told(m, first, lang)\n",
     "    out += _cast(first, lang) + [s['unmarked'].format(paths=f['paths'], id=first['id']), ''] + _told(m, first, lang)\n"),
    ("        out += _told(m, path, lang, deep=True, places=f['places'])\n", "        out += _cast(path, lang) + _told(m, path, lang, deep=True, places=f['places'])\n"),
    ("  'first': 'The first path', 'known': 'Close to what others call',", "  'cast': 'Who and what is in it, and the words used', 'first': 'The first path', 'known': 'Close to what others call',"),
    ("  'first': '第一条路', 'known': '相近的说法',", "  'cast': '这条路上有什么，用的是哪些词', 'first': '第一条路', 'known': '相近的说法',"),
])
patch(WT + 'map_sheet.html', [
    ("  h += '<p class=\"eg\">' + esc(t('unmarked')) + '</p>';\n",
     "  if ((path.cast || []).length) h += '<details class=\"cast\"><summary>' + esc(t('cast')) + '</summary><dl>' + path.cast.map(c => '<div><dt>' + esc(zh() ? c.zh : c.en) + '</dt><dd>' + esc(zh() ? c.says_zh : c.says_en) + '</dd></div>').join('') + '</dl></details>';\n"
     "  h += '<p class=\"eg\">' + esc(t('unmarked')) + '</p>';\n"),
    (".known .lk {", ".cast { margin: 8px 0 10px; font-size: 13.5px; } .cast summary { cursor: pointer; color: var(--muted); } .cast dl { margin: 6px 0 0; } .cast dl > div { margin: 5px 0; } .cast dt { font-weight: 600; display: inline; } .cast dt::after { content: ': '; } .cast dd { display: inline; margin: 0; color: var(--muted); }\n.known .lk {"),
    ("known: 'Close to what others call', unlike:", "cast: 'Who and what is in it, and the words used', known: 'Close to what others call', unlike:"),
    ("known: '相近的说法', unlike:", "cast: '这条路上有什么，用的是哪些词', known: '相近的说法', unlike:"),
])
patch(WT + 'tests/test_map_sheet.py', [
    ("    def test_a_laid_test_says_where_it_was_run(self):\n",
     "    def test_a_path_s_cast_is_filled_in_both_languages(self):\n"
     "        d = data()\n"
     "        d['paths']['paths'][0]['cast'] = [{'en': 'the well', 'zh': '井', 'says_en': 'what is drawn from.', 'says_zh': ''}]\n"
     "        self.assertIn('path down: an entry of its cast is not filled', errors(d))\n"
     "        d['paths']['paths'][0]['cast'][0]['says_zh'] = '被取用的。'\n"
     "        self.assertNotIn('cast', errors(d))\n"
     "        m = map_sheet.build(d)\n"
     "        self.assertEqual(map_sheet._cast(m['paths'][0], 'zh')[2], '- **井**：被取用的。')\n\n"
     "    def test_a_laid_test_says_where_it_was_run(self):\n"),
])
print('ok')
