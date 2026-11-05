"""Print the import closure (topological order) of the named modules, read from git main."""
import re, subprocess, sys
R = '/Users/ren/theories'
LEAN = 'experiments/integrated-correction/general-framework/generative-basis/lean'
FOUND = {'GenerativeCore': LEAN + '/GenerativeCore.lean',
         'RelationalRenewal': LEAN + '/deeper/RelationalRenewal.lean',
         'InquirySufficiency': LEAN + '/inquiry-root/sufficiency/InquirySufficiency.lean'}
def path(name):
    if name in FOUND: return FOUND[name]
    return LEAN + '/becoming/' + name.replace('.', '/') + '.lean'
def show(p):
    return subprocess.run(['git', '-C', R, 'show', 'main:' + p], capture_output=True, text=True, check=True).stdout
def code_only(s):
    s = re.sub(r'/-.*?-/', '', s, flags=re.S)
    return re.sub(r'--.*', '', s)
cache = {}
def imports(name):
    if name not in cache:
        cache[name] = [m for m in re.findall(r'^import\s+(\S+)', code_only(show(path(name))), re.M) if m != 'Std']
    return cache[name]
order, seen = [], set()
def visit(n):
    if n in seen: return
    seen.add(n)
    for i in imports(n): visit(i)
    order.append(n)
for t in sys.argv[1:]: visit(t)
for n in order: print(n, path(n))
