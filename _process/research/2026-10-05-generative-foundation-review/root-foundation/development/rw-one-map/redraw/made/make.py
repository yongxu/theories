# AI-written, 12 November 2026. Builds what the kit shows from the kit's data with the worktree's tool:
# the page to operate (map.html, a fragment for publishing), its preview, and every view into out/.
import json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
WT = '/Users/ren/tmp/rw/map2/wt'
sys.path.insert(0, WT)
from tools.research import map_sheet as M

d = {name: json.load(open(os.path.join(HERE, 'data', name + '.json'), encoding='utf-8')) for name in ('sheet', 'passages', 'paths', 'laid')}
(_d, dyn, tests), errs = M.load()
errs = M.validate(d, dyn_ids=set(dyn), test_ids=tests, lean=M.lean_names())
for e in errs: print('ERROR', e)
m = M.build(d); m['dyn_names'] = dyn; m['totals'] = M.totals()
for e in M.built_errors(m): print('ERROR', e); errs.append(e)
frag = M.page(m)
open(os.path.join(HERE, 'map.html'), 'w', encoding='utf-8').write(frag)
open(os.path.join(HERE, 'preview.html'), 'w', encoding='utf-8').write(M.document(frag))
out = os.path.join(HERE, 'out'); os.makedirs(out, exist_ok=True)
views = M.views(m)
for name, text in views.items(): open(os.path.join(out, name.rsplit('/', 1)[1]), 'w', encoding='utf-8').write(text)
print(m['counts'])
print({k.rsplit('/', 1)[1]: len(v.split()) for k, v in views.items() if k.endswith('.md')})
print('page', len(frag), 'bytes;', len(errs), 'errors')
