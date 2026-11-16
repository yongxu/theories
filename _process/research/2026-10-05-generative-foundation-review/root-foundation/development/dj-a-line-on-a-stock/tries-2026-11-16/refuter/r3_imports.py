# AI-written (Fable, refuter seat, round 11), 16 November 2026. Reads import lines only.
import os, re, sys
root = '/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean'
def path(mod):
    if mod.startswith('Becoming.'): return os.path.join(root, 'becoming', mod.replace('.', '/') + '.lean')
    for d in ('deeper', 'becoming'):
        p = os.path.join(root, d, mod.replace('.', '/') + '.lean')
        if os.path.exists(p): return p
    return None
def imports(mod):
    p = path(mod)
    if not p or not os.path.exists(p): return []
    out = []
    with open(p) as f:
        for line in f:
            m = re.match(r'^import\s+(\S+)', line)
            if m: out.append(m.group(1))
            elif line.strip() and not line.startswith('import') and not line.startswith('--') and out: break
    return out
def closure(mod):
    seen = set(); stack = [mod]
    while stack:
        m = stack.pop()
        for i in imports(m):
            if i not in seen: seen.add(i); stack.append(i)
    return seen
for a, b in [('Becoming.RegimeMargin', 'RelationalRenewal'), ('Becoming.RegimeMargin', 'Becoming.Dependence'),
             ('Becoming.RenewalFlow', 'RelationalRenewal'), ('Becoming.RenewalFlow', 'Becoming.RegimeMargin'),
             ('Becoming.Lasting', 'RelationalRenewal'), ('Becoming.TurningInTime', 'Becoming.Lasting'),
             ('Becoming.RegimeMargin', 'Becoming.Lasting'), ('Becoming.LineOnAStock', 'Becoming.RegimeMargin'),
             ('Becoming.RegimeMargin', 'Becoming.RenewalFlow'), ('Becoming.RegimeMargin', 'Becoming.Continuation')]:
    print(f"{a} imports (transitively) {b}: {b in closure(a)}")
