# AI-written, 12 November 2026. The page listed each test by its boxes and a few words at each ("m = 0, 30 of 30"),
# which a person cannot read. Each laid test now carries one or two sentences (line_en, line_zh) saying what was
# seen and what gave way; the page lists the tests by them, and a test's own card opens with them.
# Edits the worktree's module, template and tests. Run once.
WT = '/Users/ren/tmp/rw/map2/wt/tools/research/'


def patch(path, pairs):
    s = open(path, encoding='utf-8').read()
    for a, b in pairs:
        assert s.count(a) == 1, (path, s.count(a), a[:80])
        s = s.replace(a, b)
    open(path, 'w', encoding='utf-8').write(s)


patch(WT + 'map_sheet.py', [
    ("Here each is given by the boxes it was laid on and, in a few words, what was seen there; its page has the rest.',",
     "Here each is given in a sentence or two; its page has the rest.',\n"
     "  'met_lead2': 'Each test is laid on the map with what in it was taken as which box, what the reasoning said, what was seen and what gave way.',"),
    ("这里只列出它放在哪些方框上、在那里看到了什么（几个字）；其余的在它自己的那一页。',",
     "这里每个只说一两句；其余的在它自己的那一页。',\n"
     "  'met_lead2': '每个检验放到图上的时候都写明：把其中的什么当作哪个方框，推理怎么说，实际看到什么，是哪里没对上。',"),
    ("    mark = {'yes': '', 'mixed': s['mixed'], 'no': s['unseen']}\n"
     "    for t in m['tests']:\n"
     "        pins = '; '.join('[%s](%s#%s): %s%s' % (_nm(boxes[pin['at']], lang), f['places'], _anchor(pin['at']), _L(pin, 'short', lang), mark[pin['agree']]) for pin in t['pins'])\n"
     "        out.append('- **[%s](%s#test-%s)** (%s). %s.' % (_nm(t, lang), f['paths'], t['id'], t['test'], pins))\n",
     "    for t in m['tests']:\n"
     "        out.append('- **[%s](%s#test-%s)** (%s). %s' % (_nm(t, lang), f['paths'], t['id'], t['test'], _L(t, 'line', lang)))\n"),
    ("    out += ['## ' + s['tests_title'], '', S[lang]['met_lead'], '']\n", "    out += ['## ' + s['tests_title'], '', s['met_lead2'], '']\n"),
    ("        out += ['<a id=\"test-%s\"></a>' % t['id'], '### %s (%s)' % (_nm(t, lang), t['test']), '',\n",
     "        out += ['<a id=\"test-%s\"></a>' % t['id'], '### %s (%s)' % (_nm(t, lang), t['test']), '', _L(t, 'line', lang), '',\n"),
    ("        for rec in t.get('records') or [t['test']]:\n",
     "        for f in ('en', 'zh', 'line_en', 'line_zh', 'what_en', 'what_zh', 'said_en', 'said_zh', 'seen_en', 'seen_zh', 'broke_en', 'broke_zh'):\n"
     "            if not t.get(f, '').strip(): E.append('test %s: no %s' % (t['id'], f))\n"
     "        for rec in t.get('records') or [t['test']]:\n"),
])
patch(WT + 'map_sheet.html', [
    ("esc(zh() ? k.en : k.zh) + ' · ' + esc(k.test) + '</p><dl class=\"dl\">';",
     "esc(zh() ? k.en : k.zh) + ' · ' + esc(k.test) + '</p><p>' + esc(L(k, 'line')) + '</p><dl class=\"dl\">';"),
])
patch(WT + 'tests/test_map_sheet.py', [
    ("'laid': {'tests': [{'id': 'well', 'test': 'T1', 'en': 'A well', 'zh': '一口井', ",
     "'laid': {'tests': [{'id': 'well', 'test': 'T1', 'en': 'A well', 'zh': '一口井', 'line_en': 'It ran down, as said.', 'line_zh': '它往下走了，和推理说的一样。', "),
    ("    def test_a_laid_test_is_in_the_tests_table_and_pins_boxes_the_sheet_has(self):\n",
     "    def test_a_laid_test_says_in_a_sentence_what_was_seen(self):\n"
     "        self.assertIn('test well: no line_en', errors(data(laid__tests__0__line_en=' ')))\n\n"
     "    def test_a_laid_test_is_in_the_tests_table_and_pins_boxes_the_sheet_has(self):\n"),
])
print('ok')
