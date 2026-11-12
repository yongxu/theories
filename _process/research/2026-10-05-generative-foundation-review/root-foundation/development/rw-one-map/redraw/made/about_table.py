# AI-written, 12 November 2026. The note on how far the map goes was one paragraph of three hundred words, and said
# nothing of what a person has read. It is now one sentence on that, a table (what; written by; set against), and
# what is not on the map yet. Replaces _about in the worktree's module and patches the template and a test.
WT = '/Users/ren/tmp/rw/map2/wt/tools/research/'
M = WT + 'map_sheet.py'
s = open(M, encoding='utf-8').read()
a = s.index('def _about(m, lang):'); b = s.index('def hub(m, lang, head, site=', a)
NEW = r'''ABOUT = {
 'en': {
  'lead': 'Written and checked by AI readers. The person who directs the work has read the first path, in an earlier wording; no one outside the work has read it yet. What each part was written from, and what it was set against:',
  'head': ['What', 'Written by', 'Set against'],
  'rows': [
   ['The %(arrows)d arrows: the full sentence of each', 'an AI reader',
    'the law\'s Lean statement: %(two)d by a second AI reader, who corrected most; %(one)d by their one reader, each marked; %(nolean)d have no Lean statement (they are readings, or say one box is a case of another)'],
   ['The arrows\' short tags, the steps of the first two paths, some names of boxes and rows', 'the coordinating AI',
    'the sentences they stand on, by further AI readers; not the Lean again'],
   ['The other %(later)d paths', 'an AI reader each', 'the arrows\' sentences and, where a step turns on the law, the Lean, by a second AI reader'],
   ['The %(boxes)d boxes, with their sentences and examples', 'the coordinating AI, from places AI readers proposed out of the account\'s %(dynamics)d dynamics',
    '%(anchored)d are tied to a definition or a law in the Lean; the examples are illustrations, not tested cases'],
   ['The %(tests)d tests laid on the map', 'AI readers, from each test\'s own record or an earlier summary of it',
    'the record, by a second AI reader; the later ones were then shortened and set against the record again'],
   ['The sentence or two that opens each test; the names listed under each path; the cast of the first path', 'the coordinating AI',
    'the records, the boxes\' full names and the Lean, by a second AI reader'],
   ['The %(names)d names others gave, at %(named)d boxes', 'taken from the account\'s readings of other traditions and fields',
    'the reading each comes from, by a second AI reader, who corrected most'],
   ['The Chinese', 'AI readers, beside the English', 'read through as Chinese by two AI readers; their repairs set against the English, and the Lean where a condition was touched, by further readers'],
  ],
  'rest': 'A name others gave says a place is close to what its source describes, or is told apart from it; it is not the source\'s agreement. Not yet on the map: most of the %(exits)d ways out of a condition and the %(transitions)d passages between conditions that the account has recorded, %(left)d of its %(all_tests)d tests, and most of its readings of other traditions and fields.',
 },
 'zh': {
  'lead': '由 AI 读者写成、核对。主持这项工作的人读过第一条路（当时的措辞和现在略有不同）；这项工作之外，还没有谁读过。每一部分从哪里写出、对着什么核过：',
  'head': ['什么', '谁写的', '对着什么核过'],
  'rows': [
   ['%(arrows)d 条箭头各自的完整句子', '一位 AI 读者',
    '定律的 Lean 命题：%(two)d 条由第二位 AI 读者核过，大多改正了；%(one)d 条只有写它的那一位核过，各自标明；%(nolean)d 条没有 Lean 命题（它们是解读，或者说一个方框是另一个的特例）'],
   ['箭头上的短标签、头两条路的每一步、一些方框和行的名字', '负责协调的 AI', '它们依据的句子，由另外的 AI 读者核过；没有再对着 Lean 核'],
   ['另外 %(later)d 条路', '各由一位 AI 读者', '箭头的句子；哪一步取决于定律，就对着 Lean；由第二位 AI 读者核过'],
   ['%(boxes)d 个方框，连同它们的句子和例子', '负责协调的 AI，依据 AI 读者从这套理论的 %(dynamics)d 条动态里提出的位置',
    '%(anchored)d 个对上了 Lean 里的定义或定律；例子只是举例，不是检验过的情形'],
   ['放在图上的 %(tests)d 个检验', 'AI 读者，照检验自己的记录或早先的一份摘要', '记录，由第二位 AI 读者核过；后来放上的几个改短之后，又对着记录核了一遍'],
   ['每个检验开头的一两句；每条路下面列的说法；第一条路开头的“这条路上有什么”', '负责协调的 AI', '记录、方框上完整的说法和 Lean，由第二位 AI 读者核过'],
   ['%(named)d 个方框上别处的 %(names)d 个说法', '取自这套理论对别的传统和学科的解读', '各自出自的那条解读，由第二位 AI 读者核过，大多改正了'],
   ['中文', 'AI 读者，对着英文写', '由两位 AI 读者当作中文通读过；他们的修改，又由另外的读者对着英文核过，动到条件的地方还对着 Lean'],
  ],
  'rest': '别处的一个说法，说的是这个地方和出处讲的相近，或者有别；不是说出处赞同它。还没上图的：这套理论记下的 %(exits)d 条“从一种状况出去的路”和 %(transitions)d 处“两种状况之间的转变”里的大部分，%(all_tests)d 个检验里的 %(left)d 个，以及它对别的传统和学科的解读里的大部分。',
 },
}


def _about(m, lang):
    """How far the map goes: who has read it, what each part was written from and set against, what is not on it."""
    tot = m.get('totals') or totals()
    c = dict(m['counts'], **tot)
    c.update(left=c['all_tests'] - c['tests'], later=c['paths'] - 2)
    a = ABOUT[lang]
    return {'lead': a['lead'], 'head': a['head'], 'rows': [[cell % c for cell in row] for row in a['rows']], 'rest': a['rest'] % c}


def _about_md(m, lang):
    a = _about(m, lang)
    return [a['lead'], '', '| ' + ' | '.join(a['head']) + ' |', '|' + '---|' * len(a['head'])] + ['| ' + ' | '.join(row) + ' |' for row in a['rows']] + ['', a['rest']]


'''
s = s[:a] + NEW + s[b:]
x = "    out += ['## ' + s['far'], '', s['proved'], '', _about(m, lang), '']\n"
assert s.count(x) == 1
s = s.replace(x, "    out += ['## ' + s['far'], '', s['proved'], ''] + _about_md(m, lang) + ['']\n")
open(M, 'w', encoding='utf-8').write(s)


def patch(path, pairs):
    t = open(path, encoding='utf-8').read()
    for x, y in pairs:
        assert t.count(x) == 1, (path, t.count(x), x[:90])
        t = t.replace(x, y)
    open(path, 'w', encoding='utf-8').write(t)


patch(WT + 'map_sheet.html', [
    (".about { margin-top: 22px; max-width: 96ch; color: var(--muted); font-size: 13.5px; } .about p { margin: 6px 0; } .about b { color: var(--ink); font-weight: 600; }",
     ".about { margin-top: 22px; max-width: 96ch; color: var(--muted); font-size: 13.5px; } .about p { margin: 6px 0; } .about b { color: var(--ink); font-weight: 600; }\n"
     ".about .farwrap { overflow-x: auto; } .about table { border-collapse: collapse; margin: 8px 0; min-width: 520px; } .about th { text-align: left; font-weight: 600; color: var(--ink); }\n"
     ".about th, .about td { vertical-align: top; padding: 6px 14px 6px 0; border-top: 1px solid var(--line); } .about td:first-child { color: var(--ink); width: 30%; } .about td:nth-child(2) { width: 24%; }"),
    ("esc(en ? 'AI-written, 12 November 2026. ' : '由 AI 写成，2026 年 11 月 12 日。') + esc(D.about[state.lang]) + '</p><p>' +",
     "esc(en ? '12 November 2026. ' : '2026 年 11 月 12 日。') + esc(D.about[state.lang].lead) + '</p><div class=\"farwrap\"><table><thead><tr>' +\n"
     "    D.about[state.lang].head.map(x => '<th>' + esc(x) + '</th>').join('') + '</tr></thead><tbody>' + D.about[state.lang].rows.map(r => '<tr>' + r.map(x => '<td>' + esc(x) + '</td>').join('') + '</tr>').join('') +\n"
     "    '</tbody></table></div><p>' + esc(D.about[state.lang].rest) + '</p><p>' +"),
])
patch(WT + 'tests/test_map_sheet.py', [
    ("        self.assertIn('Each of the %d arrows has a full sentence. For %d of them a second AI reader' % (c['arrows'], c['two']), page)\n"
     "        self.assertIn('%d of the %d boxes are tied so far' % (c['anchored'], c['boxes']), page)\n",
     "        self.assertIn('| The %d arrows: the full sentence of each |' % c['arrows'], page)\n"
     "        self.assertIn('%d by a second AI reader, who corrected most; %d by their one reader' % (c['two'], c['one']), page)\n"
     "        self.assertIn('| The %d boxes, with their sentences and examples |' % c['boxes'], page)\n"
     "        self.assertIn('%d are tied to a definition or a law in the Lean' % c['anchored'], page)\n"),
])
print('ok')
