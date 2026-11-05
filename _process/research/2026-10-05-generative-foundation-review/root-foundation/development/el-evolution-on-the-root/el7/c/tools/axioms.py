import re, sys
src, out, mod = sys.argv[1], sys.argv[2], sys.argv[3]
ns = []
names = []
for line in open(src):
    m = re.match(r'^namespace (\S+)', line)
    if m: ns.append(m.group(1)); continue
    m = re.match(r'^end (\S+)', line)
    if m and ns and ns[-1] == m.group(1): ns.pop(); continue
    m = re.match(r'^(?:private )?(?:theorem|def|structure|abbrev|inductive) (\S+)', line)
    if m: names.append('.'.join(ns + [m.group(1)]))
with open(out, 'w') as f:
    f.write('import %s\n' % mod)
    for n in names: f.write('#print axioms %s\n' % n)
print(len(names))
