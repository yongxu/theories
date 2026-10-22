"""Seventh pass (22 October, board item WL): the name 文 and 文同 (judge, agents/wl/wen-judge.json), the five rows the
judge changes (往, 歷, 理, 終而復始, 不測), and the checked revisions from 文理生生's textual evidence
(agents/wl/revisions-check.json: 動, 察 and 衡 revised, 26 kept with the text's own sense and the distance written
into the note). Writes work/seventh-pass.json (the parsed changes) for apply_flags.py; python3 -I work/seventh_pass.py"""
import json, os, re
H = os.path.dirname(os.path.abspath(__file__)); KIT = os.path.dirname(H)


def quoted(s, i):
    """The balanced 「…」 starting at or after i: returns (inner text, end index)."""
    a = s.index('「', i)
    d, j = 0, a
    while True:
        c = s[j]
        if c == '「':
            d += 1
        elif c == '」':
            d -= 1
            if d == 0:
                return s[a + 1:j], j + 1
        j += 1


ROW = re.compile(r'(\S+?) row')
ops = []
judge = json.load(open(KIT + '/agents/wl/wen-judge.json', encoding='utf-8'))
for r in judge['rows']:
    ops.append({'row': r['name'], 'op': 'set', 'fields': {'篇': r['cluster'], '所名': r['what'], '锚': r['anchor'],
                                                          '引': r['quote'], '式': r['form'], '注': r['note']},
                'why': 'WL judge (D63): 文 names the course'})
rev = json.load(open(KIT + '/agents/wl/revisions-check.json', encoding='utf-8'))
NOTAD = {'易', '德', '礼', '信', '虚', '反', '人'}
for x in rev['decisions']:
    c, ch = x['change'], x['character']
    why = 'WL revisions (%s, %s): %s' % (ch, x['decision'], x['why'][:120])
    if ch in NOTAD:
        for m in re.finditer(r'Append to 理由: ', c):
            ops.append({'row': ch, 'op': 'notad-append', 'text': quoted(c, m.end())[0], 'why': why})
        continue
    # each change sentence names its row ('X row: ...') or, for 往, 'Append to 往 注'
    segs = [(m.group(1), m.start()) for m in ROW.finditer(c)]
    if ch == '往':
        segs = [('往', 0)]
    for k, (row, start) in enumerate(segs):
        end = segs[k + 1][1] if k + 1 < len(segs) else len(c)
        part = c[start:end]
        for kind, pat in [('note-set', r'注→'), ('note-set', r'注 「已采」→'), ('note-set', r'注 —→'), ('note-append', r'Append to (?:往 )?注: '),
                          ('note-prepend', r'Prepend to 注: '), ('what-set', r'所名→'), ('quote-set', r'引 (?:—)?→'),
                          ('quote-set', r'引→'), ('quote-set', r'引 may take the frozen comma, ')]:
            for m in re.finditer(pat, part):
                ops.append({'row': row, 'op': kind, 'text': quoted(part, m.end())[0], 'why': why})
        for m in re.finditer(r'锚 (\S+?)→(「?)', part):
            if m.group(2):
                ops.append({'row': row, 'op': 'anchor-set', 'text': quoted(part, m.end() - 1)[0], 'why': why})
            else:
                ops.append({'row': row, 'op': 'anchor-set', 'text': re.match(r'[\w.]+', part[m.end():]).group(0).rstrip('.'), 'why': why})
# integrator's corrections: the checker reads no elision inside one quotation, so the two elided quotations are split;
# the readers numbered 篇一 before 文与文同 was inserted as 一·二十一 (renumber_pian1); the appended 往 gloss follows the
# set note and names the 文's prefix; two older notes (今, 錄) still gave 往 as 「历程之前段」
import sys; sys.path.insert(0, H); from renumber_pian1 import renumber
SPLIT = [('「凡物之有形者易裁也……有形則有短長」〔CV1-S-JL〕', '「凡物之有形者易裁也」〔CV1-S-JL〕、「有形則有短長」〔CV1-S-JL〕'),
         ('「剛柔交錯，天文也……觀乎天文，以察時變」〔YD-JP22〕', '「剛柔交錯，天文也」〔YD-JP22〕、「觀乎天文，以察時變」〔YD-JP22〕'),
         ('；字之常义是去、离开', '字之常义是去、离开'), ('以之名历程之前段', '以之名文之前段'),
         # the final review (agents/wl/final-review.json): D63 is the decision; 「极其数」 is the yarrow count, as
         # 一·二十一 and xici-can-wu-cuo-zong read it; 察's name is now 敏感; a code maps 义项 to 名; 理 is read off
         # the 文 only as the coarsest value-keeping 理; 九·三十三's adopted wording
         ('（讀，AI；须一决定记录）', '（讀，AI，D63）'),
         ('「极其数，遂定天下之象」读作给界则有穷之往定文之状（定域：界须所给）；揲蓍之「参伍」「错综」，与同章「遂知来物」（九·三十，相分），皆不带。',
          '「参伍」「错综」与「极其数，遂定天下之象」讲揲蓍之数，数不读作状之种数之界（全段之条定域，xici-can-wu-cuo-zong；给界则有穷之往定文之状是九·三十三之律，不由此句），与同章「遂知来物」（九·三十，相分），皆不带。'),
         ('察（敏感性）', '察（敏感）'), ('一书是名经码之文；', '一书是以名为值之文，其名经码配义项；'),
         ('类、理自文读出而非文（见理）', '类、理不是文；理自文读出只在一义：法经一象示之，守象之值之最粗之理所并恰为文同之状（见理）'),
         ('读作定域：理是自文读出之类，不是文。', '读作定域：理不是文，自文读出只在一义。'),
         ('恰当其文经类于族之员数减一步之前皆同', '恰当其文于族之员数减一步之前皆同'),
         # the second review (agents/wl/second-review.json): 九·二十二's courses of a relation's values are 文; a run's
         # 往 through a class is the prefix of the 文 of its moves read through the class
         ('九·十、九·十九、九·二十二、十一·十', '九·十、九·十九、十一·十'),
         ('（凡十七处）改「文」；', '（凡十七处）改「文」；九·二十二经中关系逐日之值之「历程」（二处）改「文」；'),
         ('经 π 读之者（Run.FixesThrough）是其经类之文之前段', '经 π 读之者（Run.FixesThrough）是其诸移经类（状经类，动如故）逐步所成之文之前段')]
def corrected(t):
    for a, b in SPLIT:
        t = t.replace(a, b)
    return renumber(t)[0]


for o in ops:
    if 'text' in o:
        o['text'] = corrected(o['text'])
    if 'fields' in o:
        o['fields'] = {k: corrected(v) for k, v in o['fields'].items()}
ops += [{'row': '今', 'op': 'note-replace', 'old': '（名表往：历程之前段）', 'new': '（名表往：文之前段）',
         'why': 'WL: 往 is the prefix of a 文'},
        {'row': '錄', 'op': 'note-replace', 'old': '建议：名表往之释「记录、历程之前段」去「记录」二字，免与此名相混。',
         'new': '名表往之释原为「记录、历程之前段」，今去「记录」二字，免与此名相混，并改名文之前段（WL）。',
         'why': 'WL: the suggestion was taken and 往 now names the prefix of a 文'},
        {'row': '錄', 'op': 'note-replace', 'old': '往（Learning.prefixOf，一程之前段）是全段', 'new': '往（Learning.prefixOf，文之前段）是全段',
         'why': 'WL: 往 is the prefix of a 文'},
        {'row': '得', 'op': 'note-replace', 'old': '不测之程上无一步起每步皆得', 'new': '不测之文上无一步起每步皆得',
         'why': 'WL: 不测 is the diagonal 文 (九·三十), not a 程'}]
json.dump(ops, open(H + '/seventh-pass.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
import collections
print(len(ops), collections.Counter(o['op'] for o in ops))
print(sorted({o['row'] for o in ops}))
