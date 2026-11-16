# AI-written (Fable, refuter of the links), 16 November 2026. Read-only: import closure of Lean modules.
import re, os, sys
B = '/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/'
def imps(m):
    p = B + m + '.lean'
    if not os.path.exists(p): return []
    out = []
    for l in open(p):
        if l.startswith('import Becoming.'): out.append(l.split('Becoming.')[1].strip())
        elif l.strip() and not l.startswith('import') and not l.startswith('--') and not l.startswith('/-'): break
    return out
def closure(m):
    seen = set(); st = [m]
    while st:
        u = st.pop()
        for v in imps(u):
            if v not in seen: seen.add(v); st.append(v)
    return seen
for a, bs in [('TurningInTime', ['Seeking', 'Exhaustion', 'RuleShaping', 'RuleCapture', 'ClosedCapture', 'RegimeMargin', 'Lasting', 'Flow', 'Continuation', 'Founding', 'RuleRebuilding']),
              ('LineOnAStock', ['Seeking', 'Exhaustion', 'Founding', 'Continuation', 'SelectionTerm', 'SelectionLevels', 'Flow']),
              ('Founding', ['LineOnAStock', 'TurningInTime', 'Continuation', 'SelectionLevels', 'SelectionTerm']),
              ('Continuation', ['Flow', 'Arising', 'RegimeMargin']),
              ('RegimeMargin', ['Lasting', 'Recurrence', 'Viability', 'Flow']),
              ('RuleRebuilding', ['TurningInTime', 'RegimeMargin']),
              ('ClosedCapture', ['RuleCapture', 'TurningInTime']),
              ('RuleShaping', ['RuleCapture', 'TurningInTime']),
              ('Exhaustion', ['TurningInTime'])]:
    c = closure(a)
    print(a, '(closure %d):' % len(c), {b: (b in c) for b in bs})
