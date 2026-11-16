# AI-written (Fable), 16 November 2026. A search over small worlds, not a proof.
# As search_selected_and_whole_stays.py, and also: the level rises at a step after the last step at which a
# unit of the line is in the way (so no T <= last has the level never rising from T on), and what the way
# takes is within the level at every step (the record take := use balances throughout).
import io, contextlib, sys
sys.path.insert(0, '.')
with contextlib.redirect_stdout(io.StringIO()):
    from apart_line_and_whole import step_level, run, taken, concord_discord
designs = {
  'cycle3': {'a': (1, ['b']), 'b': (2, ['c']), 'c': (3, ['a', 'a', 'a', 'a'])},
  'Def':    {'D': (2, ['D', 'e']), 'e': (1, ['f']), 'f': (2, ['D', 'e'])},
  'two':    {'p': (1, ['q']), 'q': (2, ['p', 'p', 'p'])},
  'double': {'D': (1, ['D', 'D'])},
}
STEPS = 40
hits = []; tried = 0
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
                    tried += 1
                    c = run(kinds, g, {first: 1, 'O': 1}, x0, STEPS)
                    levels = [lv for _, lv in c]
                    linec = [sum(n for u, n in w.items() if isS(u)) for w, _ in c]
                    takes = [taken(kinds, w) for w, _ in c]
                    if min(levels) < 1 or linec[-1] > 0: continue
                    if any(takes[t] > levels[t] for t in range(STEPS)): continue
                    if not all(any(kinds(u)[0] <= lv for u in w) for w, lv in c): continue
                    last = max(t for t in range(len(c)) if linec[t] > 0)
                    if any(all(levels[t + 1] <= levels[t] for t in range(T, STEPS)) for T in range(last + 1)): continue
                    mark = lambda u: 1 if isS(u) else 0
                    sel = [t for t in range(last + 1) if (lambda cd: cd[1] < cd[0])(concord_discord(kinds, c[t][0], c[t][1], mark))]
                    if sel:
                        hits.append((name, 'H', H, 'need', need, 'first', first, 'x0', x0, 'last', last, 'selected at', sel, levels[:last + 9], linec[:last + 2], takes[:last + 3]))
print('tried', tried, '; hits', len(hits))
for h in hits[:8]: print(h)
