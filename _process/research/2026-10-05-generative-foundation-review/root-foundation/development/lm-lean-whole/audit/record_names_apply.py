#!/usr/bin/env python3
"""Records: old names to the one statement; each name's reference moved to the file that now holds it; one history note."""
import json,re,sys,hashlib
from pathlib import Path
sys.path.insert(0,'/Users/ren/tmp/lm/rec')
from mapping import MAP,DROP
W=Path('/Users/ren/tmp/lm/work'); R=W/'theories/becoming/results/records'
LP='experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
MAP.update({'DrawnShaping.CriticalMass.one_pos':'Nat.one_pos','RuleShaping.Assorting.one_pos':'Nat.one_pos','RuleShaping.SharedFlips.one_pos':'Nat.one_pos','RuleShaping.Split.one_pos':'Nat.one_pos','mem_mapped':'ListTests.mem_map_of'})
def lean_own(n): return n.startswith(('Nat.','Bool.','List.'))
mods={}
for l in Path('/Users/ren/tmp/lm/audit/new1/names.tsv').read_text().split('\n'):
    if l:
        a=l.split('\t'); mods[a[0]]=a[2]
old={l.split('\t')[0] for l in Path('/Users/ren/tmp/lm/audit/out/names.tsv').read_text().split('\n') if l}
newset=set(mods)
gone={n.replace('Becoming.','',1) for n in old-newset}
PAT=re.compile(r'Becoming\.[^\s"`,;:)\]（）、，。；]+')
BT=re.compile(r'`([^`\s]+)`')
def mapname(n):
    """n without the Becoming prefix -> new or None to drop, or n unchanged"""
    if n in DROP: return None
    if n in gone or n in MAP:
        if n not in gone: return n
        v=MAP.get(n)
        if v is None: return n
        if lean_own(v): return None
        return v
    return n
HIST={'en':'6 November 2026, board item LM: the helper lemmas this record lists are stated once now, in Prelude, Flow, Change or Laws, or are Lean\'s own and dropped from the lists; the names changed and no law did.',
      'zh':'2026年11月6日，工作板条目 LM：此记录所列辅助引理现只陈述一次，在 Prelude、Flow、Change 或 Laws，或即 Lean 自有者而从列表除去；改其名，诸律不变。'}
def fix_list(lst):
    out=[]; changed=False
    for x in lst:
        if isinstance(x,str) and x.startswith('Becoming.'):
            n=x.replace('Becoming.','',1)
            m=mapname(n)
            if m!=n: changed=True
            if m is None: continue
            y='Becoming.'+m
            if y not in out: out.append(y)
            elif m==n: changed=True
        else: out.append(x)
    return out,changed
def fix_prose(s):
    def f(m):
        n=m.group(1)
        if n in gone or n in DROP:
            v=mapname(n)
            if v is None: return m.group(0)
            return '`'+v+'`'
        return m.group(0)
    return BT.sub(f,s)
def walk(o,key=None):
    ch=False
    if isinstance(o,dict):
        for k in list(o):
            if k=='history': continue
            v=o[k]
            if isinstance(v,list) and v and all(isinstance(x,str) for x in v) and k in('declarations','aliases'):
                nv,c=fix_list(v)
                if c: o[k]=nv; ch=True
            elif isinstance(v,str):
                if k=='witness' and v.startswith('Becoming.'):
                    n=v.replace('Becoming.','',1); m=mapname(n)
                    if m and m!=n: o[k]='Becoming.'+m; ch=True
                else:
                    ns=fix_prose(v)
                    if ns!=v: o[k]=ns; ch=True
            else:
                if walk(v): ch=True
    elif isinstance(o,list):
        for v in o:
            if walk(v): ch=True
    return ch
def rehome(d):
    """each reference's Lean declarations under the file that now holds them"""
    refs=d.get('references') or []
    leanrefs=[r for r in refs if isinstance(r,dict) and str(r.get('path','')).endswith('.lean') and r.get('declarations') is not None]
    ch=False
    for r in leanrefs:
        keep=[]
        for n in r['declarations']:
            m=mods.get(n)
            if m is None or not m.startswith('Becoming.'): keep.append(n); continue
            path=f"{LP}/{m.replace('.','/')}.lean"
            if path==r['path']: keep.append(n); continue
            target=next((x for x in leanrefs if x['path']==path),None)
            if target is None:
                target={'path':path,'role':r.get('role','proof'),'sha256':hashlib.sha256((W/path).read_bytes()).hexdigest(),'declarations':[]}
                refs.append(target); leanrefs.append(target)
            if n not in target['declarations']: target['declarations'].append(n)
            ch=True
        r['declarations']=keep
    d['references']=[r for r in refs if not (isinstance(r,dict) and str(r.get('path','')).endswith('.lean') and r.get('declarations')==[] and r.get('role')=='proof')]
    return ch
touched=[]
for p in sorted(R.glob('*.json')):
    d=json.loads(p.read_text())
    ch=walk(d)
    if ch:
        rehome(d)
        d.setdefault('history',[]).append(dict(HIST))
        p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n')
        touched.append(p.stem)
print(len(touched)); print(' '.join(touched)[:1500])
