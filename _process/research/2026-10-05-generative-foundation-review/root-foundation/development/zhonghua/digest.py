import json,sys,os,re,glob
root=sys.argv[1]; out=sys.argv[2]
L=os.path.join(root,'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean')
t=open(L,encoding='utf-8').read()
doc=t[t.index('/-!'):]
doc=doc[:doc.index('-/')]
# bullets start with "* `Becoming."
items=re.split(r'\n\* ',doc)
lines=['# Spine modules (docstring of Becoming.lean on main)\n']
for it in items[1:]:
    s=' '.join(x.strip() for x in it.split('\n'))
    lines.append('- '+s)
open(os.path.join(out,'spine-modules.md'),'w').write('\n'.join(lines)+'\n')
recs=[]
for p in sorted(glob.glob(os.path.join(root,'theories/becoming/results/records/*.json'))):
    d=json.load(open(p,encoding='utf-8'))
    ti=d.get('title',{}); st=d.get('statement',{})
    decls=[]
    for l in d.get('laws',[]) or []:
        for x in l.get('declarations',[]) or []:
            if x not in decls: decls.append(x)
    if not decls:
        decls=[a for a in d.get('aliases',[]) or [] if isinstance(a,str) and a.startswith('Becoming.')]
    recs.append('- `%s` [%s] %s / %s: %s / %s — decls: %s'%(d['id'],d.get('kind'),ti.get('en',''),ti.get('zh',''),st.get('en',''),st.get('zh',''),', '.join(decls[:12])))
open(os.path.join(out,'spine-records.md'),'w').write('# Result records (theories/becoming/results/records/<id>.json)\n\n'+'\n'.join(recs)+'\n')
print(len(items)-1,'modules',len(recs),'records')
