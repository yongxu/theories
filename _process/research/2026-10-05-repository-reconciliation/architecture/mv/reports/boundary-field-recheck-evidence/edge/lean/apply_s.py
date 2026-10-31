"""Apply BOUNDARY-FIELD.md draft 2's S0, S2, S3 (names part) and S4 to the miniature's dump lines."""
import sys
D = {}
for line in open(sys.argv[1]):
    n, k, t, v = line.rstrip('\n').split('\t')
    p = lambda s: [x.strip() for x in s.strip('[]').split(',') if x.strip()]
    D[n] = {'k': k, 't': p(t), 'v': p(v)}
GRAMMAR = {'Becoming.«际»', 'Becoming.«而»', 'Becoming.«则»'}  # the root (grammar module stand-ins)
LEAF = 'Becoming.U4Boundary.'
def own(n): return D[n]['t'] if D[n]['k'] == 'thm' else D[n]['t'] + D[n]['v']
def aux(n): return n.rsplit('.', 1)[-1].startswith(('match_', '_proof', 'eq_'))
def direct(n):
    out, seen, st = set(), {n}, list(own(n))
    while st:
        b = st.pop()
        if b in seen or b not in D: continue
        seen.add(b)
        if aux(b) and b.startswith(n + '.'): st += own(b)
        else: out.add(b)
    return out
def closure(ns):
    seen, st = set(), list(ns)
    while st:
        b = st.pop()
        if b in D and b not in seen: seen.add(b); st += own(b)
    return seen
term = lambda b: '«' in b and b != 'Becoming.«际»'
def name_test(n, allowed=()): return sorted(b for b in direct(n) if b not in GRAMMAR and b not in allowed)
def walk(n):
    out, seen, st = set(), {n}, list(D[n]['v'])
    while st:
        b = st.pop()
        if b not in D or b in seen: continue
        seen.add(b)
        if D[b]['k'] == 'thm' and not aux(b): out.add(b)
        elif b in GRAMMAR: continue
        else: st += D[b]['t'] + D[b]['v']
    return out
def S2(h):
    return {'name_test_fails_on': name_test(h), 'names_grammar_term_directly': any(term(b) for b in direct(h))}
def S0(F, hyps):
    reach = closure(D[F]['t'])
    return {'name_test_fails_on': name_test(F, hyps), 'reaches_grammar_term': any(term(b) for b in reach)}
P = 'Becoming.U4Boundary.'
for h in ['GivenTo', 'Inherits', 'UndependedFrom', 'GivesFrom', 'ListedWithin', 'Outside', 'CancelsAlong', 'BoundedAlong', 'Redundant']:
    r = S2(P + h); print('S2', h, 'PASS' if not r['name_test_fails_on'] and r['names_grammar_term_directly'] else 'FAIL', r)
print('S0 row 5 form', S0(P + 'descent_forms_no_dependence', [P + 'GivenTo', P + 'Inherits', P + 'UndependedFrom']))
# S3 names part: K's statement names H and passes the name test with hyps and F's module defs allowed; K's proof names F
# and at least one other theorem, each of F's module, reaching neither F nor the row.
def S3(K, H, F):
    leafdefs = [n for n in D if n.startswith(LEAF) and D[n]['k'] == 'def']
    w = walk(K)
    others = w - {F}
    return {'statement_names_H': H in direct(K), 'name_test_fails_on': name_test(K, leafdefs),
            'proof_names_F': F in w, 'others': sorted(others),
            'others_ok': bool(others) and all(o.startswith(LEAF) and F not in closure([o]) and F not in walk(o) for o in others)}
print('S3 U4 needs_given', S3(P + 'descent_forms_no_dependence.needs_given', P + 'GivenTo', P + 'descent_forms_no_dependence'))
print('S3 gaming Redundant_needed', S3(P + 'Redundant_needed', P + 'Redundant', P + 'loose_form'))
