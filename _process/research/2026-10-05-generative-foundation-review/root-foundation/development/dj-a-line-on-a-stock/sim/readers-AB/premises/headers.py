# AI-written (Fable, reader "premises"), 16 November 2026. Compares declaration headers (up to the
# first top-level ":=" or first "\n  |" match arm) of the tracked WayOfUnits.lean and the scratch copy.
import re, sys
def strip(s):
    out=[];i=0;d=0
    while i<len(s):
        if s.startswith('/-',i): d+=1;i+=2;continue
        if s.startswith('-/',i) and d>0: d-=1;i+=2;continue
        if d==0: out.append(s[i])
        i+=1
    return ''.join(out)
def heads(p):
    code=strip(open(p).read())
    parts=re.split(r'\n(?=(?:private\s+)?(?:theorem|def|abbrev|instance|inductive|structure)\s)',code)
    H={}
    for part in parts:
        m=re.match(r'(?:private\s+)?(theorem|def|abbrev|instance|inductive|structure)\s+(\S+)',part)
        if not m: continue
        body=part
        cut=len(body)
        for pat in (r':=', r'\n\s*\|', r'\bwhere\b'):
            mm=re.search(pat,body)
            if mm: cut=min(cut,mm.start())
        H.setdefault(m.group(2),[]).append(' '.join(body[:cut].split()))
    return H
a=heads(sys.argv[1]); b=heads(sys.argv[2])
print('tracked decls',sum(map(len,a.values())),'scratch decls',sum(map(len,b.values())))
print('missing in scratch:',[k for k in a if k not in b])
print('changed:',[k for k in a if k in b and a[k]!=b[k]])
print('added:',[k for k in b if k not in a])
