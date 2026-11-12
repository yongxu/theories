# AI-written, 12 November 2026. The code reviewer's findings on the map's tool, each fixed where it was found:
# a step that stands on "staying at a box" showed the word "undefined" under "In full"; moving over a step deleted
# the label of a cut arrow; the number of a step whose arrow leaves the picture was drawn outside it; the validator
# crashed on a name at an unknown box, let through a test with no pins, a path with no bands, an id that breaks
# markup, a word that fits only a person in an arrow's further ways, and text with markup characters; the count of
# arrows read twice counted one with no law; the data's "<" could close the page's script; the first path's id was
# fixed in the template; counts of the atlas were typed in, not counted. Edits the worktree's module, template and
# tests. Run once.
WT = '/Users/ren/tmp/rw/map2/wt/tools/research/'


def patch(path, pairs):
    s = open(path, encoding='utf-8').read()
    for a, b in pairs:
        assert s.count(a) == 1, (path, s.count(a), a[:90])
        s = s.replace(a, b)
    open(path, 'w', encoding='utf-8').write(s)


patch(WT + 'map_sheet.py', [
    # ---- validate
    ("    boxes, cells = {}, {}\n    for b in sheet['boxes']:\n",
     "    for kind, things in (('band', sheet['bands']), ('row', sheet['rows']), ('box', sheet['boxes']), ('path', paths['paths']), ('test', laid['tests'])):\n"
     "        for x in things:\n"
     "            if not ID.match(str(x.get('id', ''))): E.append('%s %r: an id is letters, digits, dots, dashes and underscores' % (kind, x.get('id')))\n"
     "    E += ['%s: %r holds markup characters (\"<\" or \"](\")' % (name, v[:40]) for name in ('sheet', 'passages', 'paths', 'laid') for v in _strings(d[name]) if '<' in v or '](' in v]\n"
     "    boxes, cells = {}, {}\n    for b in sheet['boxes']:\n"),
    ("            if w.get('laws') and not w.get('readers'): E.append('passage %s: names a law and no reader has set its sentence against the Lean' % k)\n",
     "            if w.get('laws') and not w.get('readers'): E.append('passage %s: names a law and no reader has set its sentence against the Lean' % k)\n"
     "            elif w.get('laws') and w['readers'] not in (1, 2): E.append('passage %s: readers is 1 or 2' % k)\n"
     "            if w is not p and (PERSON_EN.search(w.get('en', '')) or PERSON_ZH.search(PERSON_ZH_OK.sub('', w.get('zh', '')))): E.append('passage %s: a further way uses a word that fits only a person' % k)\n"),
    ("        for b in path['bands']:\n            if b not in bands:",
     "        if not path.get('bands'): E.append('path %s: no bands' % path['id'])\n"
     "        for b in path.get('bands', []):\n            if b not in bands:"),
    ("            elif not boxes[k['at']].get('known_en'): E.append(", "            elif not boxes.get(k['at'], {}).get('known_en'): E.append("),
    ("        for f in ('en', 'zh', 'line_en', 'line_zh', 'what_en',",
     "        if not t.get('pins') or not t.get('test'): E.append('test %s: no pins, or no test named' % t['id']); continue\n"
     "        for f in ('en', 'zh', 'line_en', 'line_zh', 'what_en',"),
    # ---- the crop, shared by the picture, the badges and the check of what was built
    ("    H = geo['H'] if not crop else max(geo['band_box'][b][1] for b in crop) + 13\n"
     "    Y0 = 0 if not crop else max(0, min(geo['band_box'][b][0] for b in crop) - 4)\n",
     "    Y0, H = _crop(geo, crop)\n"),
    ("    inside = lambda cid: Y0 <= geo['boxes'][cid]['y'] <= H - 13\n", "    inside = _inside(geo, crop)\n"),
    ("def chart(geo: dict, lang: str = 'en', static: bool = False, focus: dict | None = None, crop: list | None = None) -> str:\n",
     "def _crop(geo: dict, bands) -> tuple:\n"
     "    \"\"\"Top and bottom of the picture that shows only these bands (the whole sheet where none are named).\"\"\"\n"
     "    if not bands: return 0, geo['H']\n"
     "    return max(0, min(geo['band_box'][b][0] for b in bands) - 4), max(geo['band_box'][b][1] for b in bands) + 13\n"
     "\n\n"
     "def _inside(geo: dict, bands):\n"
     "    if not bands: return lambda cid: True\n"
     "    y0, y1 = _crop(geo, bands)\n"
     "    return lambda cid: y0 <= geo['boxes'][cid]['y'] <= y1 - 13\n"
     "\n\n"
     "def chart(geo: dict, lang: str = 'en', static: bool = False, focus: dict | None = None, crop: list | None = None) -> str:\n"),
    ("                if 'p' in r: at = next(p for p in P if p['id'] == r['p'])['mid']\n",
     "                if 'p' in r:\n"
     "                    p = next(p for p in P if p['id'] == r['p']); at = p['mid']\n"
     "                    if p['far'] and not (inside(p['from']) and inside(p['to'])):     # the arrow is a stub here: number it at the stub\n"
     "                        tip = p['tips'][0 if inside(p['from']) else 1]; at = (tip[0] - 12, tip[1])\n"),
    ("        path = json.loads(json.dumps(path)); n = 0\n",
     "        path = json.loads(json.dumps(path)); n = 0\n"
     "        for f in ('shows_en', 'shows_zh', 'known'): path.setdefault(f, [])\n"
     "        inside = _inside(geo, path.get('bands'))\n"),
    ("'two': sum(1 for p in P if p.get('readers') == 2),", "'two': sum(1 for p in P if p.get('readers') == 2 and p['laws']),"),
    # ---- the page's data
    (".replace('</', '<\\\\/'))", ".replace('<', '\\\\u003c'))"),
    ("        'conds': {b['id']: {k: b.get(k) for k in (", "        'conds': {b['id']: {k: b.get(k, [] if k in LISTS else None) for k in ("),
    ("S = {'en': {'hub': 'THE-MAP.md', 'places': 'PLACES.md', 'paths': 'PATHS.md'},\n         'zh': {'hub': 'THE-MAP.zh.md', 'places': 'PLACES.zh.md', 'paths': 'PATHS.zh.md'}}\n", ""),
    # ---- counts of the atlas, counted
    ("out of the account\\'s 183 dynamics;", "out of the account\\'s %(dynamics)d dynamics;"),
    ("most of the 321 ways out of a condition and the 103 passages between conditions that the account has recorded, %(left)d of its 66 tests,",
     "most of the %(exits)d ways out of a condition and the %(transitions)d passages between conditions that the account has recorded, %(left)d of its %(all_tests)d tests,"),
    ("从这套理论的 183 条动态里提出的位置写成的", "从这套理论的 %(dynamics)d 条动态里提出的位置写成的"),
    ("这套理论记下的 321 条“从一种状况出去的路”和 103 处“两种状况之间的转变”里的大部分，66 个检验里的 %(left)d 个，",
     "这套理论记下的 %(exits)d 条“从一种状况出去的路”和 %(transitions)d 处“两种状况之间的转变”里的大部分，%(all_tests)d 个检验里的 %(left)d 个，"),
    ("def _about(m, lang):\n    c = m['counts']\n", "def _about(m, lang):\n    tot = m.get('totals') or totals()\n    c = dict(m['counts'], **tot)\n"),
    ("    m = build(d); m['dyn_names'] = dyn\n    out = views(m)\n",
     "    m = build(d); m['dyn_names'] = dyn; m['totals'] = totals()\n"
     "    errors = [MAP + ': ' + e for e in built_errors(m)]\n"
     "    if errors:\n        return {}, errors\n"
     "    out = views(m)\n"),
    ("def document(fragment: str) -> str:\n",
     "def totals(root: Path = ROOT) -> dict:\n"
     "    \"\"\"What the account holds in all, counted from the atlas's dynamics and the tests table.\"\"\"\n"
     "    dyn = json.loads((root / DYNAMICS).read_text(encoding='utf-8'))\n"
     "    return {'dynamics': len(dyn), 'exits': sum(len(x.get('exits') or []) for x in dyn), 'transitions': sum(len(x.get('transitions') or []) for x in dyn),\n"
     "            'all_tests': len(json.loads((root / TESTS).read_text(encoding='utf-8'))['tests'])}\n"
     "\n\n"
     "def built_errors(m: dict) -> list:\n"
     "    \"\"\"What only the laid-out sheet can show: a path's picture shows its bands, so each box a step stands on lies in\n"
     "    them, and an arrow that leaves them is one drawn as a stub, which the picture cuts and labels.\"\"\"\n"
     "    E, geo = [], m['geo']\n"
     "    byid = {p['id']: p for p in geo['P']}\n"
     "    for path in m['paths']:\n"
     "        inside = _inside(geo, path.get('bands'))\n"
     "        for sec in path['sections']:\n"
     "            for st in sec['steps']:\n"
     "                for r in st['refs']:\n"
     "                    if 'p' not in r:\n"
     "                        if not inside(r.get('c') or r['stay']): E.append('path %s step %d: %s lies outside the path\\'s bands' % (path['id'], st['n'], r.get('c') or r['stay']))\n"
     "                        continue\n"
     "                    p = byid[r['p']]\n"
     "                    if not (inside(p['from']) or inside(p['to'])): E.append('path %s step %d: the arrow %s lies outside the path\\'s bands' % (path['id'], st['n'], p['key']))\n"
     "                    elif not (inside(p['from']) and inside(p['to'])) and not p['far']:\n"
     "                        E.append('path %s step %d: the arrow %s leaves the path\\'s bands and is drawn in full, so the picture would cut it without a label; name the other band too' % (path['id'], st['n'], p['key']))\n"
     "    return E\n"
     "\n\n"
     "def document(fragment: str) -> str:\n"),
    ("PERSON_ZH_OK = re.compile(r'人为|人和 AI')\n",
     "PERSON_ZH_OK = re.compile(r'人为|人和 AI')\n"
     "ID = re.compile(r'^[A-Za-z0-9][A-Za-z0-9._-]*$')\n"
     "LISTS = ('known_en', 'known_zh', 'unlike_en', 'unlike_zh', 'anchors', 'dynamics')\n"
     "\n\n"
     "def _strings(node):\n"
     "    \"\"\"Every string in a JSON value.\"\"\"\n"
     "    if isinstance(node, str): yield node\n"
     "    elif isinstance(node, dict):\n"
     "        for v in node.values(): yield from _strings(v)\n"
     "    elif isinstance(node, list):\n"
     "        for v in node: yield from _strings(v)\n"),
])

patch(WT + 'map_sheet.html', [
    ("  if (r.stay) return '<div class=\"ref\"><div class=\"tag\" data-cond=\"' + r.stay + '\">' + esc(t('stay_t')) + '</div><p>' + esc(zh() ? r.zh : r.en) + '</p></div>';",
     "  if (r.stay) return '<div class=\"ref\"><div class=\"tag\" data-cond=\"' + r.stay + '\">' + esc(t('stay_t')) + '</div><p>' + esc(D.stays.filter(s => s.from === r.stay).map(s => zh() ? (s.zh || s.en) : s.en).join(' ')) + '</p></div>';"),
    ("  $$('.tagt', marks).forEach(x => x.remove());\n  path.sections.forEach(S => S.steps.forEach(st => { if (String(st.n) !== String(step)) return;",
     "  $$('.tagt:not(.farl):not(.pinl)', marks).forEach(x => x.remove());\n  path.sections.forEach(S => S.steps.forEach(st => { if (String(st.n) !== String(step)) return;"),
    ("const state = { mode: 'path', path: 'lock', sel: null,", "const state = { mode: 'path', path: D.paths[0].id, sel: null,"),
    ("let last = { mode: 'path', path: 'lock', kase: null };", "let last = { mode: 'path', path: D.paths[0].id, kase: null };"),
    ("svg.classList.toggle('want', state.mode === 'path' && state.path === 'lock');", "svg.classList.toggle('want', state.mode === 'all' || (state.mode === 'path' && !!L(pth, 'want')));"),
    ("function setClasses() {\n",
     "function cropOf(pth) {\n"
     "  const on = !!(pth && pth.bands && pth.bands.length);\n"
     "  return { on: on, top: on ? Math.max(0, Math.min(...pth.bands.map(b => D.bandStart[b])) - 4) : 0, end: on ? Math.max(...pth.bands.map(b => D.bandEnd[b])) + 13 : D.geo.H };\n"
     "}\n"
     "function setClasses() {\n"),
    ("    path.cset.forEach(c => cs.add(c)); path.pset.forEach(p => ps.add(p)); tones = path.tones; hl = 'var(--t-close)';\n",
     "    path.cset.forEach(c => cs.add(c)); path.pset.forEach(p => ps.add(p)); tones = path.tones; hl = 'var(--t-close)';\n"
     "    const cr0 = cropOf(path), out0 = id => cr0.on && (D.conds[id].y > cr0.end - 13 || D.conds[id].y < cr0.top);\n"),
    ("      if (r.p) { [x, y] = P[r.p].mid; } else {",
     "      if (r.p) { const pp = P[r.p]; [x, y] = pp.mid; if (pp.far && (out0(pp.from) || out0(pp.to))) { const tp = out0(pp.to) ? pp.tips[0] : pp.tips[1]; x = tp[0] - 12; y = tp[1]; } } else {"),
    ("  const yEnd = pth && pth.bands ? Math.max(...pth.bands.map(b => D.bandEnd[b])) + 13 : D.geo.H;\n"
     "  const yTop = pth && pth.bands ? Math.max(0, Math.min(...pth.bands.map(b => D.bandStart[b])) - 4) : 0;\n",
     "  const cr = cropOf(pth), yEnd = cr.end, yTop = cr.top;\n"),
    ("  const hidden = id => D.conds[id].y > yEnd - 13 || D.conds[id].y < yTop;\n  const cn = $('#cropnote'); cn.hidden = !(pth && pth.bands);",
     "  const hidden = id => cr.on && (D.conds[id].y > yEnd - 13 || D.conds[id].y < yTop);\n  const cn = $('#cropnote'); cn.hidden = !cr.on;"),
    ("function pinMark(c, pin, k) {", "function pinMark(c, pin) {"),
])

s = open(WT + 'map_sheet.html', encoding='utf-8').read()
a = s.index('function fullOf(p, cls) {'); b = s.index('function refFull(r) {')
assert 'fullOf(' not in s[:a] + s[b:], 'fullOf is still called'
open(WT + 'map_sheet.html', 'w', encoding='utf-8').write(s[:a] + s[b:])

patch(WT + 'tests/test_map_sheet.py', [
    (".group(1).replace('<\\\\/', '</'))", ".group(1))"),
    ("        cls.m = map_sheet.build(cls.d); cls.m['dyn_names'] = cls.dyn\n", "        cls.m = map_sheet.build(cls.d); cls.m['dyn_names'] = cls.dyn; cls.m['totals'] = map_sheet.totals()\n"),
    ("        self.assertIn('%d of its 66 tests' % (66 - c['tests']), page)\n        self.assertEqual(len(self.tests), 66)\n",
     "        tot = map_sheet.totals()\n"
     "        self.assertEqual(tot['all_tests'], len(self.tests))\n"
     "        self.assertEqual(tot['dynamics'], len(self.dyn))\n"
     "        self.assertIn('%d of its %d tests' % (tot['all_tests'] - c['tests'], tot['all_tests']), page)\n"
     "        self.assertIn('most of the %d ways out of a condition and the %d passages between conditions' % (tot['exits'], tot['transitions']), page)\n"
     "\n"
     "    def test_what_the_whole_map_says_of_its_arrows_along_a_row_is_what_the_counts_give(self):\n"
     "        # the page: most that run right are laws of the course itself; most that run back need something given, or are built\n"
     "        along = self.m['counts']['along']\n"
     "        right = {k[6:]: v for k, v in along.items() if k.startswith('right/')}\n"
     "        left = {k[5:]: v for k, v in along.items() if k.startswith('left/')}\n"
     "        self.assertGreater(right.get('law', 0), sum(right.values()) / 2)\n"
     "        self.assertGreater(left.get('needs', 0) + left.get('built', 0), sum(left.values()) / 2)\n"
     "\n"
     "    def test_every_step_of_every_path_lies_in_the_picture_of_its_path(self):\n"
     "        self.assertEqual(map_sheet.built_errors(self.m), [])\n"),
    ("    def test_a_laid_test_says_in_a_sentence_what_was_seen(self):\n",
     "    def test_an_id_and_a_text_cannot_break_the_page(self):\n"
     "        self.assertIn(\"box 'a b': an id is letters, digits, dots, dashes and underscores\", errors(data(sheet__boxes__0=box('a b', 'r1', 1))))\n"
     "        self.assertIn('holds markup characters', errors(data(sheet__lead_en='A <b>map</b>.')))\n"
     "        self.assertIn('holds markup characters', errors(data(laid__tests__0__what_en='See [this](that).')))\n"
     "\n"
     "    def test_a_path_names_its_bands_and_a_test_has_pins(self):\n"
     "        self.assertIn('path down: no bands', errors(data(paths__paths__0__bands=[])))\n"
     "        self.assertIn('test well: no pins, or no test named', errors(data(laid__tests__0__pins=[])))\n"
     "\n"
     "    def test_a_further_way_of_an_arrow_is_held_to_the_same_words(self):\n"
     "        more = arrow('a', 'b', more=[dict(arrow('a', 'b'), en='Where someone takes it, it runs down.')])\n"
     "        self.assertIn('passage a>b: a further way uses a word that fits only a person', errors(data(passages__passages__0=more)))\n"
     "\n"
     "    def test_a_name_at_a_box_the_sheet_lacks_is_an_error_not_a_crash(self):\n"
     "        d = data()\n"
     "        d['paths']['paths'][0]['sections'][0]['steps'][0]['on'] = ['box:zz']\n"
     "        d['paths']['paths'][0]['known'] = [{'at': 'zz', 'en': 'the well', 'zh': '井'}]\n"
     "        self.assertIn('unknown box box:zz', errors(d))\n"
     "\n"
     "    def test_a_laid_test_says_in_a_sentence_what_was_seen(self):\n"),
    ("    def test_a_laid_test_shows_the_bands_it_touches(self):\n",
     "    def test_a_step_whose_arrow_leaves_the_picture_is_numbered_at_its_stub_and_one_drawn_in_full_is_an_error(self):\n"
     "        d = data()\n"
     "        d['paths']['paths'][0]['sections'][0]['steps'].append({'say_en': 'It leaves.', 'say_zh': '它离开。', 'on': ['c>g']})\n"
     "        m = map_sheet.build(d)\n"
     "        self.assertEqual(map_sheet.built_errors(m), [])\n"
     "        far = next(p for p in m['geo']['P'] if p['key'] == 'c>g')\n"
     "        at = next(a for n, _tone, a in m['paths'][0]['badges'] if n == 3)\n"
     "        self.assertEqual(at, (far['tips'][0][0] - 12, far['tips'][0][1]))\n"
     "        d['paths']['paths'][0]['sections'][0]['steps'][-1]['on'] = ['box:g']\n"
     "        self.assertIn(\"path down step 3: g lies outside the path's bands\", ' | '.join(map_sheet.built_errors(map_sheet.build(d))))\n"
     "\n"
     "    def test_a_laid_test_shows_the_bands_it_touches(self):\n"),
])
s = open(WT + 'map_sheet.py', encoding='utf-8').read()
old = "dict(c, left=66 - c['tests'], later=c['paths'] - 2)"
assert s.count(old) == 2
open(WT + 'map_sheet.py', 'w', encoding='utf-8').write(s.replace(old, "dict(c, left=c['all_tests'] - c['tests'], later=c['paths'] - 2)"))
print('ok')
