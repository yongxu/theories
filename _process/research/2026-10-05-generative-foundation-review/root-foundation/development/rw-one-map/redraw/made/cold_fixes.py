# AI-written, 12 November 2026. What the cold reader showed still held, changed in the tool:
# - red for "how it closes" and green for "the ways out" read as bad and good whatever the caption said: the groups
#   of a path now take hues that do not (blue, amber, purple, grey); green stays for the one thing declared a want;
# - a step that is given, built or a reading had the same solid number as a proved one: its number is now hollow;
# - "proved" was unqualified until the foot of the page: how to read it now says what proved means;
# - nothing said what an arrow between rows is;
# - the names others gave were a list without places: each is now a link to its box, and the page has a way in by name;
# - "where the reasoning met the world" did not say that most tests are built set-ups: it is counted and said;
# - the sentence on arrows along a row read as a finding: it is now the count itself, and says it is a count.
# Edits the kit's laid.json and the worktree's module, template and tests. Run once.
import json, os
HERE = os.path.dirname(os.path.abspath(__file__))
WT = '/Users/ren/tmp/rw/map2/wt/tools/research/'


def patch(path, pairs):
    s = open(path, encoding='utf-8').read()
    for a, b, *n in pairs:
        want = n[0] if n else 1
        assert s.count(a) == want, (path, s.count(a), a[:90])
        s = s.replace(a, b)
    open(path, 'w', encoding='utf-8').write(s)


# ---- data: where each test was run
p = os.path.join(HERE, 'data', 'laid.json')
laid = json.load(open(p, encoding='utf-8'))
FIELD = {'stocks'}
for t in laid['tests']: t['setting'] = 'field' if t['id'] in FIELD else 'built'
json.dump(laid, open(p, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)

patch(WT + 'map_sheet.py', [
    # hues
    (".tone-close{--hl:#b0452c}.tone-turn{--hl:#1a7a5e}.tone-late{--hl:#5b4b8a}.tone-open{--hl:#5a6573}\n"
     ".badge circle{fill:var(--hl)}.badge text{fill:#fff;font-size:9.5px;font-weight:600;text-anchor:middle}",
     ".tone-close{--hl:#2a5d9f}.tone-turn{--hl:#a36a12}.tone-late{--hl:#7a4b8f}.tone-open{--hl:#5a6573}\n"
     ".badge circle{fill:var(--hl)}.badge text{fill:#fff;font-size:9.5px;font-weight:600;text-anchor:middle}"
     ".badge.soft circle{fill:#fff;stroke:var(--hl);stroke-width:1.6}.badge.soft text{fill:var(--hl)}"),
    # hollow numbers
    ("                badges.append((n, S['tone'], at))\n",
     "                st['soft'] = 'p' in r and p['kind'] in ('needs', 'built', 'reading')   # not proved of the course itself: a hollow number\n"
     "                badges.append((n, S['tone'], at, st['soft']))\n"),
    ("        for n, tone, at in focus['badges']:\n"
     "            out.append('<g class=\"badge tone-%s\"><circle cx=\"%.1f\" cy=\"%.1f\" r=\"8.5\"></circle><text x=\"%.1f\" y=\"%.1f\">%d</text></g>' % (tone, at[0], at[1], at[0], at[1] + 3.3, n))\n",
     "        for n, tone, at, soft in focus['badges']:\n"
     "            out.append('<g class=\"badge%s tone-%s\"><circle cx=\"%.1f\" cy=\"%.1f\" r=\"8.5\"></circle><text x=\"%.1f\" y=\"%.1f\">%d</text></g>' % (' soft' if soft else '', tone, at[0], at[1], at[0], at[1] + 3.3, n))\n"),
    # how to read it
    ("Each arrow is a way from one box to another; its line says how that is known: solid where it is proved, dashed where it is proved only with something given from outside, dotted where it is not shown in general (a built example, or a reading). A bar across a line marks a proved boundary between two boxes; a double line, one box being a case of another. A small ring on a box: something is known about staying there. A violet dot: a test is laid on it. A box outlined in green dashes is one the work wants to reach.',",
     "A thing stands in one box of every row that applies to it. Each arrow is a way from one box to another: along a row, a change of that row\\'s answer; between rows, from one row\\'s answer to another\\'s. Its line says how that is known: solid where it is proved, dashed where it is proved only with something given from outside, dotted where it is not shown in general (a built example, or a reading). *Proved* means a theorem on a stated model, checked by machine; whether a real case fits the model is what the tests show. A bar across a line marks a proved boundary between two boxes; a double line, one box being a case of another. On a path, a hollow number marks a step that is not proved of the course itself. A small ring on a box: something is known about staying there. A violet dot: a test is laid on it. A box outlined in green dashes is one the work wants to reach.',"),
    ("每条箭头是从一个方框到另一个的路，线型标明凭什么这么说：实线是已证明的；虚线是已证明、但要有外面给定的东西；点线是没有一般证明的（造出来的例子，或者一种解读）。线上一道短杠是两个方框之间已证明的界线；双线表示一个是另一个的特例。方框角上的小圆圈：关于“留在那里”已经知道一些。紫色的小点：有检验放在这里。绿色虚线框出的方框，是这项工作想到达的。',",
     "一样东西，在每一个用得上的行里各占一个方框。每条箭头是从一个方框到另一个的路：沿着一行的，是这一行的回答变了；跨行的，是从一行的回答通到另一行的回答。线型标明凭什么这么说：实线是已证明的；虚线是已证明、但要有外面给定的东西；点线是没有一般证明的（造出来的例子，或者一种解读）。“已证明”是指在写明的模型上成立、由机器检查过的定理；真实的情形合不合这个模型，要看放在图上的检验。线上一道短杠是两个方框之间已证明的界线；双线表示一个是另一个的特例。路上空心的编号，标的是没有就过程本身证明的那几步。方框角上的小圆圈：关于“留在那里”已经知道一些。紫色的小点：有检验放在这里。绿色虚线框出的方框，是这项工作想要到达的。',"),
    # the count along a row, as a count
    (" Among the arrows drawn so far that run along a row (the last band apart), most that run right are proved of the course itself; most that run back need something given from outside the course, or are shown only in a built example.',",
     "',\n  'along': 'Counted over the arrows drawn so far that run along a row (the last band apart): %(rl)d of the %(r)d that run right are proved of the course itself; of the %(l)d that run back, %(ll)d are, %(ln)d need something given from outside and %(lb)d are shown only in a built example. This is a count on an order we chose, not a finding.',"),
    ("在目前画出的、沿着一行走的箭头里（最下面一栏不算），往右的多数是过程自己就会走的；往回的多数要靠过程之外给定的东西，或者只在造出来的例子里见过。',",
     "',\n  'along': '数一数目前画出的、沿着一行走的箭头（最下面一栏不算）：往右的 %(r)d 条里，%(rl)d 条是就过程本身证明的；往回的 %(l)d 条里，这样的有 %(ll)d 条，%(ln)d 条要有过程之外给定的东西，%(lb)d 条只在造出来的例子里见过。这是在我们自己排的次序上数出来的，不是一个发现。',"),
    ("s['whole_lead'], '', '### ' + s['index'], '']", "s['whole_lead'] + ('' if lang == 'zh' else ' ') + _along(m, lang), '', '### ' + s['index'], '']"),
    # the tests, by where they were run
    ("    out += ['## ' + s['met'], '', s['met_lead'], '']\n", "    out += ['## ' + s['met'], '', s['met_lead'] + ('' if lang == 'zh' else ' ') + _settings(m, lang), '']\n"),
    ("    out += ['## ' + s['tests_title'], '', s['met_lead2'], '']\n", "    out += ['## ' + s['tests_title'], '', s['met_lead2'] + ('' if lang == 'zh' else ' ') + _settings(m, lang), '']\n"),
    ("        for f in ('en', 'zh', 'line_en', 'line_zh', 'what_en',",
     "        if t.get('setting') not in ('built', 'field'): E.append('test %s: its setting is built or field' % t['id'])\n"
     "        for f in ('en', 'zh', 'line_en', 'line_zh', 'what_en',"),
    # names: links to their boxes, and a way in by name
    ("def _known(m, path, lang):\n    return [k[lang] for k in path.get('known', [])]\n",
     "def _known(m, path, lang, places=None):\n"
     "    \"\"\"The names a path gives, each a link to the box it stands at where the page of boxes is named.\"\"\"\n"
     "    if places is None: return [k[lang] for k in path.get('known', [])]\n"
     "    return ['[%s](%s#%s)' % (k[lang], places, _anchor(k['at'])) for k in path.get('known', [])]\n"
     "\n\n"
     "def _along(m, lang):\n"
     "    a = m['counts']['along']\n"
     "    right = {k[6:]: v for k, v in a.items() if k.startswith('right/')}; left = {k[5:]: v for k, v in a.items() if k.startswith('left/')}\n"
     "    return S[lang]['along'] % {'r': sum(right.values()), 'rl': right.get('law', 0), 'l': sum(left.values()), 'll': left.get('law', 0), 'ln': left.get('needs', 0), 'lb': left.get('built', 0)}\n"
     "\n\n"
     "def _settings(m, lang):\n"
     "    n = len(m['tests']); field = sum(1 for t in m['tests'] if t.get('setting') == 'field')\n"
     "    return S[lang]['settings'] % {'n': n, 'built': n - field, 'field': field}\n"),
    ("    kn = _known(m, first, lang)\n    if kn: out += [_listed(s['known'], kn, lang), '']\n",
     "    kn = _known(m, first, lang, f['places'])\n    if kn: out += [_listed(s['known'], kn, lang), '']\n"),
    ("        kn = _known(m, path, lang)\n        if kn: out += [_listed(s['known'], kn, lang), '']\n",
     "        kn = _known(m, path, lang, f['places'])\n        if kn: out += [_listed(s['known'], kn, lang), '']\n"),
    ("    out += ['## ' + s['met'], '',",
     "    names = [(k, p) for p in m['paths'] for k in p.get('known', [])]\n"
     "    if names:\n"
     "        out += ['## ' + s['by_name'], '', s['by_name_lead'], '']\n"
     "        out += ['- %s%s[%s](%s#%s)%s' % (k[lang], ' → ', _nm(boxes[k['at']], lang), f['places'], _anchor(k['at']), _br('[%s](%s#path-%s)' % (_nm(p, lang), f['paths'], p['id']), lang)) for k, p in names] + ['']\n"
     "    out += ['## ' + s['met'], '',"),
    ("  'first': 'The first path', 'known': 'Close to what others call',",
     "  'by_name': 'Start from a name you know', 'by_name_lead': 'Each name is close to what one box says, not the same as it, and is not its source\\'s agreement. The box says how it is close; the path it lies on is in brackets.',\n"
     "  'settings': '%(built)d of the %(n)d were run in built set-ups, with language models or small learning programs; %(field)d on data from the field.',\n"
     "  'first': 'The first path', 'known': 'Close to what others call',"),
    ("  'first': '第一条路', 'known': '相近的说法',",
     "  'by_name': '从你熟悉的说法进来', 'by_name_lead': '每个说法只是和一个方框讲的相近，并不等同，也不是说出处赞同它。怎么个相近，方框那里写着；括号里是它所在的那条路。',\n"
     "  'settings': '%(n)d 个里有 %(built)d 个是在搭出来的情境里跑的，用的是语言模型或小型学习程序；%(field)d 个用的是实地数据。',\n"
     "  'first': '第一条路', 'known': '相近的说法',"),
    ("        'about': {'en': _about(m, 'en'), 'zh': _about(m, 'zh')},", "        'about': {'en': _about(m, 'en'), 'zh': _about(m, 'zh')}, 'along': {'en': _along(m, 'en'), 'zh': _along(m, 'zh')},"),
])

patch(WT + 'map_sheet.html', [
    ("--t-close: #b0452c; --t-turn: #1a7a5e; --t-late: #5b4b8a;", "--t-close: #2a5d9f; --t-turn: #a36a12; --t-late: #7a4b8f;"),
    ("--t-close: #e48b70; --t-turn: #63c7a6; --t-late: #b3a3e6;", "--t-close: #8ab6ee; --t-turn: #e0b566; --t-late: #cfa3e0;", 2),
    (".badge circle { fill: var(--hl); } .badge text { fill: #fff; font-size: 9.5px; font-weight: 600; text-anchor: middle; }",
     ".badge circle { fill: var(--hl); } .badge text { fill: #fff; font-size: 9.5px; font-weight: 600; text-anchor: middle; }\n"
     ".badge.soft circle { fill: var(--card); stroke: var(--hl); stroke-width: 1.6; } .badge.soft text { fill: var(--hl); }\n"
     ".num.soft { background: var(--card); color: var(--hl); box-shadow: inset 0 0 0 1.6px var(--hl); }\n"
     ".known .lk { cursor: pointer; text-decoration: underline; text-decoration-style: dotted; text-underline-offset: 3px; }"),
    ("marks.insertAdjacentHTML('beforeend', '<g class=\"badge\" style=\"--hl:' + TONE[st.tone] + '\">", "marks.insertAdjacentHTML('beforeend', '<g class=\"badge' + (st.soft ? ' soft' : '') + '\" style=\"--hl:' + TONE[st.tone] + '\">"),
    ("'\"><span class=\"num\">' + st.n + '</span><div><p class=\"say\">'", "'\"><span class=\"num' + (st.soft ? ' soft' : '') + '\">' + st.n + '</span><div><p class=\"say\">'"),
    ("  const kn = (path.known || []).map(k => zh() ? k.zh : k.en);\n  if (kn.length) h += '<p class=\"known\">' + esc(listed(t('known'), kn)) + '</p>';",
     "  const kn = (path.known || []).map(k => '<span class=\"lk\" data-cond=\"' + k.at + '\">' + esc(zh() ? k.zh : k.en) + '</span>');\n"
     "  if (kn.length) h += '<p class=\"known\">' + esc(t('known')) + (zh() ? '：' : ': ') + kn.join(zh() ? '；' : '; ') + '</p>';"),
    ("  h += '<p class=\"note\">' + (en\n"
     "    ? 'Among the arrows drawn so far that run along a row (the last band apart), most that run right are laws of the course itself; most that run back need something given from outside the course, or are shown only in a built example.'\n"
     "    : '在目前画出的、沿着一行走的箭头里（最下面一栏不算），往右的多数是过程自己就会走的；往回的多数要靠过程之外给定的东西，或者只在造出来的例子里见过。') + '</p>';",
     "  h += '<p class=\"note\">' + esc(D.along[state.lang]) + '</p>';"),
    ("its line says how that is known: solid where it is proved, dashed where it is proved only with something given from outside, dotted where it is not shown in general. Choose any box or arrow.'",
     "its line says how that is known: solid where it is proved of a stated model, dashed where it is proved only with something given from outside, dotted where it is not shown in general. On a path, a hollow number marks a step that is not proved of the course itself. Choose any box or arrow.'"),
    ("线型标明凭什么这么说：实线是已证明的；虚线是已证明、但要有外面给定的东西；点线是没有一般证明的。方框和箭头都可以点。'",
     "线型标明凭什么这么说：实线是在写明的模型上已证明的；虚线是已证明、但要有外面给定的东西；点线是没有一般证明的。路上空心的编号，标的是没有就过程本身证明的那几步。方框和箭头都可以点。'"),
])

patch(WT + 'tests/test_map_sheet.py', [
    ("[n for n, _tone, _at in path['badges']]", "[n for n, _tone, _at, _soft in path['badges']]"),
    ("next(a for n, _tone, a in m['paths'][0]['badges'] if n == 3)", "next(a for n, _tone, a, _soft in m['paths'][0]['badges'] if n == 3)"),
    ("'laid': {'tests': [{'id': 'well', 'test': 'T1',", "'laid': {'tests': [{'id': 'well', 'test': 'T1', 'setting': 'built',"),
    ("    def test_a_laid_test_says_in_a_sentence_what_was_seen(self):\n",
     "    def test_a_laid_test_says_where_it_was_run(self):\n"
     "        self.assertIn('test well: its setting is built or field', errors(data(laid__tests__0__setting='lab')))\n\n"
     "    def test_a_laid_test_says_in_a_sentence_what_was_seen(self):\n"),
    ("    def test_a_laid_test_shows_the_bands_it_touches(self):\n",
     "    def test_a_step_that_is_not_proved_of_the_course_itself_has_a_hollow_number(self):\n"
     "        d = data()\n"
     "        d['paths']['paths'][0]['sections'][0]['steps'].append({'say_en': 'It is given.', 'say_zh': '这是给定的。', 'on': ['a>c']})   # a>c is drawn as needs\n"
     "        m = map_sheet.build(d)\n"
     "        self.assertEqual([soft for _n, _tone, _at, soft in m['paths'][0]['badges']], [False, False, True, False])\n"
     "        self.assertEqual(map_sheet.path_picture(m, m['paths'][0], 'en').count('class=\"badge soft '), 1)\n\n"
     "    def test_a_laid_test_shows_the_bands_it_touches(self):\n"),
])
print('ok')
