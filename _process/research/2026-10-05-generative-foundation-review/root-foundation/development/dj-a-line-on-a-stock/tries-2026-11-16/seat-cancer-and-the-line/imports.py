# AI-written (Fable), 16 November 2026. Reads the import lines only; a search, not a proof.
import os, re, sys
B = '/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming'
def imports(m):
    p = os.path.join(B, m + '.lean')
    if not os.path.exists(p): return []
    out = []
    for line in open(p):
        mm = re.match(r'import Becoming\.(\S+)', line)
        if mm: out.append(mm.group(1))
        elif line.strip() and not line.startswith('import'): break
    return out
def closure(m):
    seen = set(); stack = [m]
    while stack:
        x = stack.pop()
        for y in imports(x):
            if y not in seen:
                seen.add(y); stack.append(y)
    return seen
for a, bs in [('TurningInTime', ['Seeking','Exhaustion','Continuation','Flow','SelectionTerm','SelectionLevels','RegimeMargin','RuleCapture','World']),
              ('LineOnAStock', ['Seeking','Exhaustion','Continuation','Flow','SelectionLevels','GroupEnding','Founding','World','Evolution']),
              ('Founding', ['RegimeMargin','TurningInTime','LineOnAStock','Seeking','Exhaustion']),
              ('Exhaustion', ['RegimeMargin','TurningInTime','Recurrence']),
              ('RegimeMargin', ['Seeking','Exhaustion','Flow','World','Continuation'])]:
    c = closure(a)
    print(a, {b: (b in c) for b in bs})
