"""Print the import closure (topological order) of the named modules, read from git main.
Each line: module name, repository path."""
import re, subprocess, sys
R = '/Users/ren/theories'
LEAN = 'experiments/integrated-correction/general-framework/generative-basis/lean'
def path(name):
    tree = subprocess.run(['git', '-C', R, 'ls-tree', '-r', '--name-only', 'main', LEAN],
                          capture_output=True, text=True, check=True).stdout.split('\n')
    want = name.replace('.', '/') + '.lean'
    hits = [p for p in tree if p.endswith('/' + want) and ('/becoming/' + want == p[len(LEAN):] or name.split('.')[0] != 'Becoming')]
    if name.startswith('Becoming.'):
        return LEAN + '/becoming/' + want
    hits = [p for p in tree if p.endswith('/' + want)]
    assert len(hits) == 1, (name, hits)
    return hits[0]
def show(p):
    return subprocess.run(['git', '-C', R, 'show', 'main:' + p], capture_output=True, text=True, check=True).stdout
def code_only(s):
    s = re.sub(r'/-.*?-/', '', s, flags=re.S)
    return re.sub(r'--.*', '', s)
cache = {}
def imports(name):
    if name not in cache:
        cache[name] = [m for m in re.findall(r'^import\s+(\S+)', code_only(show(path(name))), re.M)
                       if m.split('.')[0] not in ('Std', 'Init', 'Lean')]
    return cache[name]
order, seen = [], set()
def visit(n):
    if n in seen: return
    seen.add(n)
    for i in imports(n): visit(i)
    order.append(n)
for t in sys.argv[1:]: visit(t)
for n in order: print(n, path(n))
