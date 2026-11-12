# AI-written, 12 November 2026. Two cut arrows between the same two boxes (one out, one back) wrote their labels on
# top of one another. They now share one label, with a two-way mark. Edits the worktree's module and template.
WT = '/Users/ren/tmp/rw/map2/wt/tools/research/'


def patch(path, pairs):
    s = open(path, encoding='utf-8').read()
    for a, b in pairs:
        assert s.count(a) == 1, (path, s.count(a), a[:90])
        s = s.replace(a, b)
    open(path, 'w', encoding='utf-8').write(s)


patch(WT + 'map_sheet.py', [
    ("    cut_labels = []\n", "    cuts = {}   # one label for the arrows cut between the same two boxes\n"),
    ("            cut_labels.append('<text class=\"farl\" x=\"%.1f\" y=\"%.1f\">%s %s</text>' % (tip[0] + 5, tip[1] + (19 if down else 9), '→' if leaves else '←', esc(other['zh'] if zh else other['en'])))\n",
     "            c = cuts.setdefault((p['from'] if leaves else p['to'], other['id']), {'x': tip[0] + 5, 'y': tip[1] + (19 if down else 9), 'out': False, 'in': False, 'name': other['zh'] if zh else other['en']})\n"
     "            c['x'] = max(c['x'], tip[0] + 5); c['out' if leaves else 'in'] = True\n"),
    ("    out += cut_labels\n",
     "    out += ['<text class=\"farl\" x=\"%.1f\" y=\"%.1f\">%s %s</text>' % (c['x'], c['y'], '⇄' if c['out'] and c['in'] else '→' if c['out'] else '←', esc(c['name'])) for c in cuts.values()]\n"),
])
patch(WT + 'map_sheet.html', [
    ("  $$('.edge', svg).forEach(n => { const id = n.dataset.id, p = P[id]; n.classList.toggle('cut', false); if (ps.has(id)) {",
     "  const cuts = {};\n  $$('.edge', svg).forEach(n => { const id = n.dataset.id, p = P[id]; n.classList.toggle('cut', false); if (ps.has(id)) {"),
    ("      marks.insertAdjacentHTML('beforeend', '<text class=\"tagt farl\" x=\"' + (tip[0] + 5) + '\" y=\"' + (tip[1] + (down ? 19 : 9)) + '\">' + (out ? '→ ' : '← ') + esc(nm(far)) + '</text>'); } } });\n}\n",
     "      const key = (out ? p.from : p.to) + '|' + far.id, c = cuts[key] || (cuts[key] = { x: tip[0] + 5, y: tip[1] + (down ? 19 : 9), out: false, inn: false, far: far });\n"
     "      c.x = Math.max(c.x, tip[0] + 5); if (out) c.out = true; else c.inn = true; } } });\n"
     "  Object.values(cuts).forEach(c => marks.insertAdjacentHTML('beforeend', '<text class=\"tagt farl\" x=\"' + c.x + '\" y=\"' + c.y + '\">' + (c.out && c.inn ? '⇄ ' : c.out ? '→ ' : '← ') + esc(nm(c.far)) + '</text>'));\n}\n"),
])
print('ok')
