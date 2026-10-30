"""Draft 2's S0-S5 (BOUNDARY-FIELD.md §3.2), read literally, applied to a module dumped by dump_*.lean merged into
the run's pickle. Usage: s_checks.py DUMP.jsonl MODULE (entries hard-coded below)."""
import json, sys
import lib
from lib import *
dump, MOD = sys.argv[1], sys.argv[2]
new = {}
for l in open(dump):
    d = json.loads(l)
    if d['m'] == MOD:
        new[d['n']] = d
for n, d in new.items():
    C[n] = d
# recompute root over merged C (module MOD is not a Grammar/Prelude module, so its constants are off the root)
nonroot = {n for n in C if not lib.located(n)}
lib.root.clear(); lib.root.update(n for n in C if n not in nonroot and n in lib.root or (n not in nonroot and n not in new))
root = lib.root
def theorems_named(n): return lib.walk(n)
def term(n): return '«' in n and n != TERM
def reaches_term(names):
    return any(term(b) for b in closure(names))
def S(entry):
    F, H, K, R, row, cert = entry['form'], entry['hyps'], entry['cms'], entry.get('recovery'), entry['row'], entry.get('cert')
    out = {}
    nt = name_test(F, allowed=set(H))
    out['S0 name test'] = nt or 'pass'
    out['S0 reaches grammar term'] = reaches_term(direct(F) - set(H)) or any(reaches_term(own(h)) for h in H)
    out['S1'] = all(h in C[F]['t'] for h in H)
    for h in H:
        out[f'S2 {h.split(".")[-1]} name test'] = name_test(h) or 'pass'
        out[f'S2 {h.split(".")[-1]} names a term directly'] = any(term(b) for b in direct(h))
    Fmod = C[F]['m']
    defs_of_F_module = {n for n in C if C[n]['m'] == Fmod and C[n]['k'] != 'thm'}
    for h, k in zip(H, K):
        tn = name_test(k, allowed=set(H) | defs_of_F_module)
        others = theorems_named(k) - {F}
        out[f'S3 {k.split(".")[-1]}'] = {
            'statement names H': h in direct(k), 'statement name test': tn or 'pass',
            'proof names F': F in theorems_named(k), 'others': sorted(others),
            'others ok': bool(others) and all(C[o]['m'] == Fmod and F not in closure([o]) for o in others)}
    w = theorems_named(F)
    out['S4 theorems F names'] = {b: ('root' if b in root else 'law' if b in laws else 'fwd' if b in forwarders else 'OFF ROOT') for b in w}
    if R:
        out['S5 R reaches F'] = F in closure([R]) or F in theorems_named(R)
        out['S5 R reaches row'] = row in theorems_named(R)
        out['S5 cert eq'] = (C[cert].get('eq'), C[cert].get('eqg'))
    return out
U = 'Becoming.U4Boundary.'
entries = [
 dict(form=U+'descent_forms_no_dependence', hyps=[U+'GivenTo', U+'Inherits', U+'UndependedFrom'],
      cms=[U+'descent_forms_no_dependence.needs_given', U+'descent_forms_no_dependence.needs_inherits', U+'descent_forms_no_dependence.needs_undepended'],
      recovery=U+'no_new_dependence_at_model', row='Becoming.Flow.no_new_dependence', cert=U+'no_new_dependence_certified'),
 dict(form=U+'outside_leaves_no_offspring', hyps=[U+'GivesFrom', U+'ListedWithin', U+'Outside'],
      cms=[U+'outside_leaves_no_offspring.needs_gate', U+'outside_leaves_no_offspring.needs_descent', U+'outside_leaves_no_offspring.needs_outside'],
      recovery=U+'all_end_at_model', row='Becoming.GroupEnding.Flow.all_end', cert=U+'all_end_certified'),
] if MOD in ('Becoming.U4Boundary', 'U4C.Boundary') else json.load(open(sys.argv[3]))
for e in entries:
    print('==', e['form'])
    for k, v in S(e).items():
        print(' ', k, ':', v)
