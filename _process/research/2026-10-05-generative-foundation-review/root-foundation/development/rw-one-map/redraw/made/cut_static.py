# AI-written, 12 November 2026. A path's picture shows only the bands the path names. A lit arrow whose other end
# lies outside them was drawn as a line running off the edge; it is now a short stub with the far box's name, as on
# the page to operate. Edits the worktree's module. Run once.
M = '/Users/ren/tmp/rw/map2/wt/tools/research/map_sheet.py'
s = open(M, encoding='utf-8').read()


def sub(a, b):
    global s
    assert s.count(a) == 1, (s.count(a), a[:70])
    s = s.replace(a, b)


sub(".far .full{display:none}.far .stub{opacity:.7}.far.on .full{display:inline}.far.on .stub{display:none}.hit{display:none}",
    ".far .full{display:none}.far .stub{opacity:.7}.far.on .full{display:inline}.far.on .stub{display:none}.hit{display:none}\n"
    ".far.on.cut .full{display:none}.far.on.cut .stub{display:inline;opacity:1}.farl{font-size:10.5px;fill:#3b4654}")
sub("    out.append('<g class=\"edges\">')\n    for p in geo['P']:\n        cls = 'edge k-%s%s%s%s%s' % (p['kind'], ' far' if p['far'] else '', ' cross' if p['cross'] else '', ' on' if p['id'] in fp else '', ' tone-' + tones[p['id']] if p['id'] in tones else '')\n",
    "    out.append('<g class=\"edges\">')\n"
    "    inside = lambda cid: Y0 <= geo['boxes'][cid]['y'] <= H\n"
    "    cut_labels = []\n"
    "    for p in geo['P']:\n"
    "        cls = 'edge k-%s%s%s%s%s' % (p['kind'], ' far' if p['far'] else '', ' cross' if p['cross'] else '', ' on' if p['id'] in fp else '', ' tone-' + tones[p['id']] if p['id'] in tones else '')\n"
    "        if crop and p['far'] and p['id'] in fp and not (inside(p['from']) and inside(p['to'])):\n"
    "            leaves = not inside(p['to']); tip = p['tips'][0 if leaves else 1]; other = geo['boxes'][p['to'] if leaves else p['from']]\n"
    "            cls += ' cut'\n"
    "            cut_labels.append('<text class=\"farl\" x=\"%.1f\" y=\"%.1f\">%s %s</text>' % (tip[0] + 5, tip[1] + 9, '→' if leaves else '←', esc(other['zh'] if zh else other['en'])))\n")
sub("    out.append('</g><g id=\"marks\">' if not static else '</g><g>')\n    if focus:\n",
    "    out.append('</g><g id=\"marks\">' if not static else '</g><g>')\n    out += cut_labels\n    if focus:\n")
open(M, 'w', encoding='utf-8').write(s)
print('ok')
