import json,sys,os,collections
sys.argv=[sys.argv[0]]+sys.argv[1:]
root,ro,out=sys.argv[1],sys.argv[2],sys.argv[3]
m=json.load(open(os.path.join(root,'data/model.json'),encoding='utf-8'))
P=json.load(open(ro,encoding='utf-8'))['passages']
romap=collections.defaultdict(list)
for p in P:
    for a in p.get('atlas_ids',[]) or []:
        romap[a['id']].append(p['id'])
labels={n['id']:n.get('label',n['id']) for n in m['nodes']}
def realm(r): return (r.get('taxonomy') or {}).get('realm')
def q1(r):
    ev=r.get('evidence') or []
    if not ev: return ''
    e=ev[0]; return '「%s」(%s %s)'%(e.get('quote','')[:90],e.get('source_id'),e.get('locator','')[:30])
def line(r):
    fr='+'.join(labels.get(x,x) for x in r.get('from',[])); to='+'.join(labels.get(x,x) for x in r.get('to',[]))
    ro_=(' | RO已映射:'+','.join(romap[r['id']])) if r['id'] in romap else ''
    return '%s | %s | %s/%s | %s | [%s]%s→%s (%s,%s,%s) | %s | %s%s'%(r['id'],realm(r),r.get('partition'),r.get('layer','')[:20],r.get('title',''),r.get('verb',''),fr,to,r.get('type'),r.get('premise_mode'),r.get('level'),r.get('claim','')[:120],q1(r),ro_)
order=['共享经典','道','儒','庄','墨','名辩','兵','法','佛','三教互动','思想史与交涉']
rels=sorted(m['relations'],key=lambda r:(order.index(realm(r)) if realm(r) in order else 99, r.get('partition') or '', r['id']))
os.makedirs(out,exist_ok=True)
N=240; chunks=[]; cur=[]; curk=None
for r in rels:
    k=realm(r)
    if cur and (len(cur)>=N or (k!=curk and len(cur)>=120)):
        chunks.append(cur); cur=[]
    cur.append(r); curk=k
if cur: chunks.append(cur)
idx=[]
for i,c in enumerate(chunks,1):
    fn=os.path.join(out,'chunk-%02d.txt'%i)
    open(fn,'w',encoding='utf-8').write('\n'.join(line(r) for r in c)+'\n')
    rs=collections.Counter(realm(r) for r in c)
    idx.append({'chunk':i,'file':fn,'n':len(c),'realms':dict(rs),'first':c[0]['id'],'last':c[-1]['id'],'ro_mapped':sum(1 for r in c if r['id'] in romap)})
json.dump(idx,open(os.path.join(out,'index.json'),'w'),ensure_ascii=False,indent=1)
for x in idx: print(x['chunk'],x['n'],x['realms'],x['ro_mapped'], os.path.getsize(x['file'])//1024,'KB')
