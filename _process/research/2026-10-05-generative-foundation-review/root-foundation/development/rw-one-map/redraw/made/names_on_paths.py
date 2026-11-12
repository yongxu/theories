# AI-written, 12 November 2026. A path's head listed every name others gave any box on it (17 for the first path).
# Each path now carries a short list chosen from the names its boxes carry; the tool checks that each stands at a
# box on the path that has such a name. Edits the kit's paths.json, the worktree's module and its template. Run once.
import json, os
HERE = os.path.dirname(os.path.abspath(__file__))
WT = '/Users/ren/tmp/rw/map2/wt/tools/research/'
KNOWN = {
 'lock': [('b2.uncounted', "Goodhart's law", '古德哈特定律'),
          ('b1.held', 'the Matthew effect (cumulative advantage)', '马太效应（优势累积）'),
          ('bs.pays', 'regulatory capture', '规制俘获'),
          ('b3.inside', 'adaptive preferences (Sen)', '适应性偏好（森）'),
          ('b2.heard', "Collingridge's dilemma", '科林格里奇困境'),
          ('b3.gone', 'Guoyu: 國人莫敢言 (no one dared speak)', '《国语》：国人莫敢言')],
 'stock': [('b0.lost', 'the tragedy of the commons (Hardin)', '公地悲剧（哈丁）'),
           ('a1.over', 'overshoot (The Limits to Growth)', '过冲（《增长的极限》）'),
           ('a1.past', 'tipping points and alternative stable states', '临界点与多重稳态'),
           ('a1.within', 'a commons kept under rules its users revise (Ostrom)', '社群用自己能改的规则守住公共资源（奥斯特罗姆）'),
           ('a2.else', 'fixes that fail (Senge)', '饮鸩止渴（圣吉）')],
 'view': [('c1.road', 'confirmation bias', '确认偏误'),
          ('c1.same', 'Micaiah and the four hundred court prophets', '米该亚与四百宫廷先知')],
 'giving': [('d1.round', 'the gift (Mauss; Kimmerer)', '礼物（莫斯；基默尔）'),
            ('d1.wait', 'double contingency (Parsons; Luhmann)', '双重偶联性（帕森斯；卢曼）'),
            ('d1.gap', 'the wheel of food, rain and offering (Bhagavad Gītā 3)', '食、雨、祭相续之轮（《薄伽梵歌》第三章）'),
            ('d2.handed', 'an enduring object as a society in serial order (Whitehead)', '持存之物是有序相继的“社会”（怀特海）')],
 'returns': [('e2.swing', 'a balancing loop with delay oscillates (Forrester)', '有延迟的调节回路会来回摆荡（福瑞斯特）'),
             ('e2.good', 'Laozi 77: 損有餘而補不足', '《老子》七十七章：损有馀而补不足'),
             ('e2.round', 'Mencius: 一治一亂 (order and disorder in turn)', '《孟子》：一治一乱'),
             ('e2.norest', 'Epicurus: empty desires run without limit', '伊壁鸠鲁：空洞的欲望无穷')],
}
p = os.path.join(HERE, 'data', 'paths.json')
d = json.load(open(p, encoding='utf-8'))
for path in d['paths']:
    path['known'] = [{'at': a, 'en': e, 'zh': z} for a, e, z in KNOWN[path['id']]]
json.dump(d, open(p, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)


def sub(path, a, b):
    s = open(path, encoding='utf-8').read()
    assert s.count(a) == 1, (path, s.count(a), a[:70])
    open(path, 'w', encoding='utf-8').write(s.replace(a, b))


M = WT + 'map_sheet.py'
sub(M, "        n = 0\n        for S in path['sections']:\n            if S['tone'] not in TONES:",
       "        n, on = 0, set()\n        for S in path['sections']:\n            if S['tone'] not in TONES:")
sub(M, "                for ref in st.get('on', []):\n                    if ref.startswith('box:'):\n                        if ref[4:] not in boxes:",
       "                for ref in st.get('on', []):\n                    on.update([ref[4:]] if ref.startswith('box:') else [ref[5:]] if ref.startswith('stay:') else ref.split('>'))\n"
       "                    if ref.startswith('box:'):\n                        if ref[4:] not in boxes:")
sub(M, "    tids = set()\n    for t in laid['tests']:\n",
       "        for k in path.get('known', []):\n"
       "            if k['at'] not in on: E.append('path %s: a name it gives stands at %s, which is not on the path' % (path['id'], k['at']))\n"
       "            elif not boxes[k['at']].get('known_en'): E.append('path %s: a name it gives stands at %s, which carries no name others gave' % (path['id'], k['at']))\n"
       "            if not k.get('en', '').strip() or not k.get('zh', '').strip(): E.append('path %s: a name it gives is empty' % path['id'])\n"
       "    tids = set()\n    for t in laid['tests']:\n")
sub(M, "    names = []\n    for cid in path['cset']:\n        for k in m['geo']['boxes'][cid].get('known_' + lang) or m['geo']['boxes'][cid].get('known_en') or []:\n"
       "            k = k.replace('：', ':').split(':')[0].split('(')[0].split('（')[0].strip()\n            if k not in names: names.append(k)\n    return names\n",
       "    return [k[lang] for k in path.get('known', [])]\n")
T = WT + 'map_sheet.html'
sub(T, "const kn = []; path.cset.forEach(id => (zh() ? D.conds[id].known_zh : D.conds[id].known_en).forEach(k => { const s = k.split(/[:：(（]/)[0].trim(); if (!kn.includes(s)) kn.push(s); }));",
       "const kn = (path.known || []).map(k => zh() ? k.zh : k.en);")
print('ok')
