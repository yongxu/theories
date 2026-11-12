# AI-written, 12 November 2026. Joins the readers' placements of atlas items to the sheet's conditions.
import json, re, collections, glob, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from idmap import PILOT, FAMILY
ROOT='/Users/ren/theories/'
REC=ROOT+'_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rw-one-map/'
dyn={d['id']:d for d in json.load(open(ROOT+'theories/becoming/results/atlas/entries/dynamics.json'))}
def en(x):
    return x.get('en') if isinstance(x,dict) else (x or '')
def atlas_item(dynamic, item, base=1):
    d=dyn.get(dynamic)
    if not d: return None
    m=re.match(r'\s*(exit|transition|compose)s?\s+(\d+)', item or '')
    if not m: return None
    kind, i = m.group(1), int(m.group(2)) - base
    if i < 0: return None
    L=d.get({'exit':'exits','transition':'transitions','compose':'compose'}[kind], [])
    if i>=len(L): return None
    x=L[i]
    if kind=='exit':
        return {'kind':'exit','law':x.get('law'),'strength':x.get('strength'),'text':en(x.get('edge')),'to':en(x.get('to')) if isinstance(x.get('to'),dict) else x.get('to')}
    if kind=='transition':
        b=x.get('between',{})
        return {'kind':'transition','law':', '.join(x.get('declarations',[])),'strength':x.get('kind'),'text':en(x.get('condition')),'to':en(b.get('from'))+' -> '+en(b.get('to'))}
    return {'kind':'compose','law':', '.join(x.get('laws',[]) if isinstance(x.get('laws'),list) else []),'strength':'compose','text':en(x.get('says') or x.get('edge') or x.get('reading')),'to':json.dumps(x.get('to'),ensure_ascii=False)[:120]}
rows=[]
def place(m, pid):
    if pid is None: return None
    pid=pid.strip()
    return m.get(pid) or PILOT.get(pid) or ('?'+pid)
for f in sorted(glob.glob(REC+'families/*.json')):
    key=os.path.basename(f)[:-5]; d=json.load(open(f)); m=FAMILY[key]
    for x in d.get('rough') or []:
        base = 0 if key == 'B-process' else 1
        a=atlas_item(x.get('dynamic'), x.get('item'), base)
        it = x.get('item') or ''
        mm = re.match(r'\s*(exit|transition|compose)s?\s+(\d+)', it)
        canon = (mm.group(1) + ' ' + str(int(mm.group(2)) - base + 1)) if mm else it
        rows.append({'reader':key,'family':dyn.get(x.get('dynamic'),{}).get('family'),'dynamic':x.get('dynamic'),'item':canon,'kind':x.get('kind'),
                     'from':place(m,x.get('from')),'to':place(m,x.get('to')),'at':place(m,x.get('place')),'words':x.get('words'),'atlas':a})
# the pilot's settled decisions
for x in json.load(open(REC+'places/decisions.json')):
    rows.append({'reader':'pilot','family':'C','dynamic':x.get('dynamic'),'item':x.get('item'),'kind':x.get('decision'),
                 'from':place({},x.get('from')),'to':place({},x.get('to')),'at':place({},x.get('place')),'words':x.get('condition_en'),'words_zh':x.get('condition_zh'),
                 'atlas':{'kind':'pilot','law':x.get('law'),'strength':x.get('strength'),'text':x.get('condition_en'),'to':''},'both_ways':x.get('both_ways')})
json.dump(rows,open(os.path.join(os.path.dirname(os.path.abspath(__file__)),'items.json'),'w'),ensure_ascii=False,indent=1)
print('items',len(rows), collections.Counter(r['kind'] for r in rows))
unk=collections.Counter(v for r in rows for v in (r['from'],r['to'],r['at']) if v and v.startswith('?'))
print('unmapped place ids:',dict(unk))
print('pilot keys', sorted(json.load(open(REC+'places/decisions.json'))[0].keys()))
