import sys, re, hashlib, json
from collections import Counter
def load(path):
    recs, cur = {}, None
    modre = re.compile(r'^(Becoming(\.[A-Za-z0-9_]+)*|GenerativeCore|InquirySufficiency|RelationalRenewal)$')
    for line in open(path, encoding='utf-8').read().split('\n'):
        parts = line.split('\t')
        if len(parts) >= 6 and modre.match(parts[1]) and parts[2] in ('axiom','def','theorem','opaque','quot','inductive','ctor','rec'):
            cur = parts[0]
            recs[cur] = [parts[1], parts[2], parts[3], parts[4], '\t'.join(parts[5:])]
        elif line and cur:
            recs[cur][4] += '\n' + line
    return recs
old, new = load(sys.argv[1]), load(sys.argv[2])
print('constants old', len(old), 'new', len(new))
gone = sorted(set(old) - set(new)); added = sorted(set(new) - set(old))
print('gone', gone); print('added', added)
moved, typechg, kindchg, lvlchg, valchg = [], [], [], [], []
for n in sorted(set(old) & set(new)):
    o, w = old[n], new[n]
    if o[0] != w[0]: moved.append((n, o[0], w[0]))
    if o[1] != w[1]: kindchg.append(n)
    if o[2] != w[2]: lvlchg.append(n)
    if o[4] != w[4]: typechg.append(n)
    if o[3] != w[3]: valchg.append((n, o[1], w[0]))
print('moved', moved)
print('kind changed', kindchg); print('universe params changed', lvlchg)
print('type changed', typechg)
print('value hash changed', len(valchg))
for v in valchg: print('   ', v)
mods_old = Counter(v[0] for v in old.values()); mods_new = Counter(v[0] for v in new.values())
print('modules old', len(mods_old), 'new', len(mods_new), 'modules only in old', sorted(set(mods_old)-set(mods_new)), 'only in new', sorted(set(mods_new)-set(mods_old)))
diffcount = {m: (mods_old.get(m,0), mods_new.get(m,0)) for m in set(mods_old)|set(mods_new) if mods_old.get(m,0)!=mods_new.get(m,0)}
print('per-module constant count changes', diffcount)
