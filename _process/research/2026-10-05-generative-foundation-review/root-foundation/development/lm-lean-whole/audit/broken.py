#!/usr/bin/env python3
"""Backticked or «» names that resolved in the old package and no longer do, across live text."""
import re,sys,os
from pathlib import Path
W=Path('/Users/ren/tmp/lm/work')
L=W/'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
def names(p):
    s=set()
    for l in Path(p).read_text().split('\n'):
        if not l: continue
        n=l.split('\t')[0]
        s.add(n)
    return s
old=names('/Users/ren/tmp/lm/audit/out/names.tsv'); new=names('/Users/ren/tmp/lm/audit/new1/names.tsv')
def suffixes(S):
    out=set()
    for n in S:
        parts=n.split('.')
        for i in range(len(parts)):
            out.add('.'.join(parts[i:]))
    return out
so,sn=suffixes(old),suffixes(new)
gone=so-sn
print('suffixes gone',len(gone))
files=[]
for root in [L/'Becoming',W/'theories/becoming',W/'GLOSSARY.md',W/'GOALS.md',L/'README.md',L/'README.zh.md',L/'Becoming.lean',W/'_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou7-conditional-laws/data']:
    if root.is_file(): files.append(root); continue
    for dp,dn,fn in os.walk(root):
        dn[:]=[d for d in dn if d!='history']
        for f in fn:
            if f.endswith(('.lean','.md','.json','.tsv')) and f not in('lean-index.json','shared-laws.json','becoming-core.md'):
                files.append(Path(dp)/f)
pat=re.compile(r'`([^`\s]+)`|«([^»\s]+)»')
hits={}
for p in files:
    t=p.read_text(errors='ignore')
    gen=p.suffix=='.md' and (p.parent/(p.stem+'.json')).exists()
    if gen: continue
    for i,line in enumerate(t.split('\n')):
        for m in pat.finditer(line):
            tok=m.group(1) or m.group(0)
            tok=tok.strip('.,;:').replace('Becoming.','',1) if tok.startswith('Becoming.') else tok
            if tok in gone:
                hits.setdefault(tok,[]).append(f'{p.relative_to(W)}:{i+1}')
        if p.suffix=='.json':
            for m in re.finditer(r'"Becoming\.([^"\s]+)"',line):
                tok=m.group(1)
                if tok in gone: hits.setdefault(tok,[]).append(f'{p.relative_to(W)}:{i+1}')
for k in sorted(hits):
    v=sorted(set(hits[k]))
    print(k,len(v),' '.join(x.replace('experiments/integrated-correction/general-framework/generative-basis/lean/becoming/','').replace('theories/becoming/','') for x in v[:4]))
