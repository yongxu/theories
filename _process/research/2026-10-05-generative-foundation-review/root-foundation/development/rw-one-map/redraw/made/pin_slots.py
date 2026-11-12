# AI-written, 12 November 2026. On a test's view, two marks at one box were drawn on top of one another (a pin, and
# the mark of another pin "found here instead"), and the cross for "this gave way" lay over the box's name. Every
# mark at a box now takes its own place along the box's top edge. Edits the worktree's module and template. Run once.
WT = '/Users/ren/tmp/rw/map2/wt/tools/research/'


def patch(path, pairs):
    s = open(path, encoding='utf-8').read()
    for a, b in pairs:
        assert s.count(a) == 1, (path, s.count(a), a[:80])
        s = s.replace(a, b)
    open(path, 'w', encoding='utf-8').write(s)


patch(WT + 'map_sheet.py', [
    ("        for i, pin in enumerate(t['pins']):\n"
     "            pin['n'] = i + 1; pin['k'] = sum(1 for x in t['pins'][:i] if x['at'] == pin['at'])\n",
     "        slots = collections.Counter()   # each mark at a box takes the next place along its top edge\n"
     "        def slot(box):\n"
     "            slots[box] += 1\n"
     "            return slots[box] - 1\n"
     "        gave_pins = {g['pin'] for g in t.get('gave', []) if 'pin' in g}\n"
     "        for i, pin in enumerate(t['pins']):\n"
     "            pin['n'] = i + 1; pin['k'] = sum(1 for x in t['pins'][:i] if x['at'] == pin['at'])\n"
     "            pin['s'] = slot(pin['at'])\n"
     "            if i + 1 in gave_pins: pin['gs'] = slot(pin['at'])\n"
     "            if pin.get('found_at'): pin['fs'] = slot(pin['found_at'])\n"
     "        if t.get('view'): t['view']['s'] = slot(t['view']['at'])\n"),
])
patch(WT + 'map_sheet.html', [
    ("const x = c.x + D.geo.BW / 2 - 3 - (pin.k || 0) * 19, y = c.y - D.geo.BH / 2 + 3;\n  const sh = pin.how",
     "const x = c.x + D.geo.BW / 2 - 3 - (pin.s || 0) * 19, y = c.y - D.geo.BH / 2 + 3;\n  const sh = pin.how"),
    ("pinMark(b, Object.assign({}, pin, { how: 'found', agree: 'yes', k: 0 }))", "pinMark(b, Object.assign({}, pin, { how: 'found', agree: 'yes', s: pin.fs || 0 }))"),
    ("cross(c.x + D.geo.BW / 2 - 3 - (pin.k || 0) * 19, c.y - D.geo.BH / 2 + 22)", "cross(c.x + D.geo.BW / 2 - 3 - (pin.gs || 0) * 19, c.y - D.geo.BH / 2 + 3)"),
    ("cs.add(k.view.at); const x = c.x + D.geo.BW / 2 - 3, y = c.y - D.geo.BH / 2 + 3;", "cs.add(k.view.at); const x = c.x + D.geo.BW / 2 - 3 - (k.view.s || 0) * 19, y = c.y - D.geo.BH / 2 + 3;"),
])
print('ok')
