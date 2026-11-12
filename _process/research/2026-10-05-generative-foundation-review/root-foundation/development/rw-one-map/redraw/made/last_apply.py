# AI-written, 12 November 2026. What the last readers asked for that is not a replacement of text, and the
# coordinator's last few lines, each following a reader's finding:
# - five examples taken off steps of the first path where a reader would take the example for what the step says;
# - "locked; the lock" added to the cast; the entry on "of the course itself; given from outside" says that which
#   premises are marked as given is the map's own marking, not two kinds of proof (the reader's finding);
# - the opening paragraph says only that the rule turns, and leaves "for good", with its conditions, to step 9;
# - two arrows whose return comes in from outside are drawn as needing something given, not as laws of the course;
# - the source of the name at "The rest count too" is recorded; seven arrows now read by a second reader say so.
# Edits the kit's data and the worktree's module and template. Run once.
import json, os
HERE = os.path.dirname(os.path.abspath(__file__))
WT = '/Users/ren/tmp/rw/map2/wt/tools/research/'
data = {n: json.load(open(os.path.join(HERE, 'data', n + '.json'), encoding='utf-8')) for n in ('sheet', 'passages', 'paths', 'laid')}
lock = next(p for p in data['paths']['paths'] if p['id'] == 'lock')
steps = [st for sec in lock['sections'] for st in sec['steps']]
for n, box in ((4, 'b3.gone'), (9, 'b2.counted'), (15, 'a1.past'), (17, 'b1.outside'), (18, 'b3.checkers')):
    assert steps[n - 1].get('eg') == box, (n, steps[n - 1].get('eg'))
    del steps[n - 1]['eg']
cast = lock['cast']
assert cast[1]['en'] == 'an update' and cast[8]['en'].startswith('of the course itself')
cast[8]['says_en'] += ' Which premises are marked as given from outside is the map\'s own marking, not a difference between two kinds of proof.'
cast[8]['says_zh'] += '哪些前提标作“过程之外给定的”，是这张图自己的标法，不是证明分成了两类。'
cast.insert(2, {'en': 'locked; the lock', 'zh': '定住；定局',
                'says_en': 'the rule favours one side and the next update would favour it no less; from there neither the favour nor that side\'s share falls.',
                'says_zh': '规则偏向一方，而且下一次重定也不会偏得更少；从这里起，偏向和这一方的份额都不再降。'})
s = data['sheet']
a = 'One way out is a law of the course itself, under its condition: where the loss gets back to the rule in time, the rest count it, and the judgments together go against what the rule favoured at two updates running, the rule turns for good.'
assert s['lead_en'].count(a) == 1
s['lead_en'] = s['lead_en'].replace(a, 'One way out is a law of the course itself: where the loss gets back to the rule in time, the rest count it, and the judgments together go against what the rule favoured at two updates running, the rule turns.')
a = '不靠外面、过程自己就有的出路，证明了的只有一条，也有它的条件：要是损耗及时传回规则那里，其余的把它算进去，合起来的判断接连两次重定都不利于规则原先偏向的一方，规则就转向，从此不再转回。'
assert s['lead_zh'].count(a) == 1
s['lead_zh'] = s['lead_zh'].replace(a, '有一条出路是过程自己的定律：要是损耗及时传回规则那里，其余的把它算进去，合起来的判断接连两次重定都不利于规则原先偏向的一方，规则就转向。')
P = {p['from'] + '>' + p['to']: p for p in data['passages']['passages']}
for k in ('d3.merged>d3.several', 'd3.one>d3.several'):
    assert P[k]['kind'] == 'law', (k, P[k]['kind'])
    P[k]['kind'] = 'needs'
both = lambda a, b: P.get(a + '>' + b) or P[b + '>' + a]
for a, b in (('e2.good', 'e2.swing'), ('b2.uncounted', 'a2.supplied'), ('d1.gap', 'd1.round'), ('e2.rest', 'a1.up'), ('d2.handed', 'a2.ended'), ('d3.merged', 'd3.several'), ('d3.one', 'd3.several')):
    both(a, b)['readers'] = 2
box = next(b for b in s['boxes'] if b['id'] == 'b3.rest')
box['known_src'] = ['cx-cc-huang-xuexiao']
for f in ('unlike_en', 'unlike_zh'): box.setdefault(f, [])
shows = lock['shows_zh']
n = sum(x.count('画出的定律') for x in shows)
lock['shows_zh'] = [x.replace('画出的定律', '图上的定律') for x in shows]
for name, d in data.items(): json.dump(d, open(os.path.join(HERE, 'data', name + '.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)


def patch(path, pairs):
    t = open(path, encoding='utf-8').read()
    for x, y in pairs:
        assert t.count(x) == 1, (path, t.count(x), x[:90])
        t = t.replace(x, y)
    open(path, 'w', encoding='utf-8').write(t)


patch(WT + 'map_sheet.py', [
    ("; the cast, against the first path, by a further AI reader'],", "; the cast, against the Lean and the first path\\'s boxes, by a further AI reader, who corrected most of it'],"),
    ("；“这条路上有什么”另由一位 AI 读者对着第一条路核过'],", "；“这条路上有什么”另由一位 AI 读者对着 Lean 和第一条路上的方框核过，大多改正了'],"),
])
patch(WT + 'map_sheet.html', [
    ("esc(D.proved[state.lang]) + ' ' + (en ? 'A small ring on a box:", "esc(D.proved[state.lang].replace(/\\*/g, '')) + ' ' + (en ? 'A small ring on a box:"),
])
print('ok;', n, 'of 画出的定律 in the lock path\'s shows replaced; examples now on', sum(1 for st in steps if st.get('eg')), 'of', len(steps), 'steps')
