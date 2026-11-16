# AI-written (Fable), 16 November 2026. A search over small worlds, not a proof.
# Wanted: finite kinds; a closed line S meeting line_ends' premises; selection within goes for the line at
# some step (discord < concord, amount = the mark of the line); the line is gone; the level is never 0;
# some need is met at every step of the horizon.
import itertools, sys
sys.path.insert(0, '.')
from apart_line_and_whole import step_level, run, taken, concord_discord
from collections import Counter

designs = {
  # name: kinds of the line as name -> (use, kids); every unit's line kids take more than it
  'cycle3': {'a': (1, ['b']), 'b': (2, ['c']), 'c': (3, ['a', 'a', 'a', 'a'])},
  'Def':    {'D': (2, ['D', 'e']), 'e': (1, ['f']), 'f': (2, ['D', 'e'])},
  'two':    {'p': (1, ['q']), 'q': (2, ['p', 'p', 'p'])},
  'double': {'D': (1, ['D', 'D'])},
}
STEPS = 40
hits = []
for name, line in designs.items():
    for H in range(8, 41):
        g = lambda z, H=H: min(z, max(H - z, 0))
        for need in range(2, H + 1):
            def kinds(u, line=line, need=need):
                if u == 'O': return (1, 1, ['O'])
                use, kids = line[u]
                return (need, use, kids)
            isS = lambda u: u != 'O'
            for first in line:
                for x0 in (H, H - 1, H // 2 + 1):
                    c = run(kinds, g, {first: 1, 'O': 1}, x0, STEPS)
                    levels = [lv for _, lv in c]
                    linec = [sum(n for u, n in w.items() if isS(u)) for w, _ in c]
                    if min(levels) < 1 or linec[-1] > 0: continue
                    if not all(any(kinds(u)[0] <= lv for u in w) for w, lv in c): continue
                    last = max(t for t in range(len(c)) if linec[t] > 0)
                    mark = lambda u: 1 if isS(u) else 0
                    sel = [t for t in range(last + 1) if (lambda cd: cd[1] < cd[0])(concord_discord(kinds, c[t][0], c[t][1], mark))]
                    if sel:
                        hits.append((name, H, need, first, x0, last, sel, levels[:last + 8], linec[:last + 2]))
print('worlds with the line selected within at some step, the line gone, the level never 0, some need met throughout:', len(hits))
for h in hits[:6]: print(h)
