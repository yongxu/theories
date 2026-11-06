#!/usr/bin/env python3
"""Keep one statement of each lemma proved more than once. Deletes the copies and rewrites what reads them.
Code tokens are rewritten only in modules the compiled package says read the copy; comments only inside backticks."""
import json, re, sys, collections
from pathlib import Path
sys.path.insert(0,'/Users/ren/tmp/lm/dedupe')
import block
L = Path('/Users/ren/tmp/lm/work/experiments/integrated-correction/general-framework/generative-basis/lean/becoming')
B = L/'Becoming'
d = json.load(open('/Users/ren/tmp/lm/dedupe/groups.json'))
home = {r['name'].replace('Becoming.','',1):r['module'] for g in d['groups'] for r in g}
PLAN = dict(block.PLAN)
# the group of `one_pos`s, whose list is long
for g in d['groups']:
    for r in g:
        n=r['name'].replace('Becoming.','',1)
        if n.endswith('.one_pos'): PLAN[n]='Nat.one_pos'
# homes the audit's groups do not list
for n,m in {'skipAt':'Becoming.Recurrence','skipAt_ne':'Becoming.Recurrence','skipAt_le':'Becoming.Recurrence','skipAt_lt':'Becoming.Recurrence',
            'GrammarLaws.skipAt':'Becoming.GrammarLaws','GrammarLaws.skipAt_ne':'Becoming.GrammarLaws','GrammarLaws.skipAt_le':'Becoming.GrammarLaws','GrammarLaws.skipAt_lt':'Becoming.GrammarLaws'}.items():
    home[n]=m
uses = collections.defaultdict(set)
for l in open('/Users/ren/tmp/lm/dedupe/out/uses.tsv'):
    r,m,_=l.rstrip('\n').split('\t'); uses[r.replace('Becoming.','',1)].add(m)
CMD = re.compile(r"^(?:@\[[^\]]*\]\s*)?(?:(?:private|protected|noncomputable|partial|unsafe)\s+)*(?:theorem|lemma|def|abbrev)\s+(\S+)")
def locate(lines):
    """Each declaration's full name and its extent, docstring included."""
    stack=[]; out={}; i=0; depth=0; doc=None
    while i<len(lines):
        l=lines[i]
        if depth==0 and l.startswith('/--'):
            doc=i
            if '-/' not in l[3:] :
                depth=1
            i+=1; continue
        if depth==0 and l.startswith('/-'):
            if '-/' not in l[2:]: depth=-1
            i+=1; doc=None; continue
        if depth!=0:
            if '-/' in l: depth=0
            i+=1; continue
        m=re.match(r'namespace (\S+)',l)
        if m: stack.append(('n',m[1])); doc=None; i+=1; continue
        m=re.match(r'section\b(.*)',l)
        if m: stack.append(('s',m[1].strip())); doc=None; i+=1; continue
        if re.match(r'end\b',l):
            if stack: stack.pop()
            doc=None; i+=1; continue
        m=CMD.match(l)
        if m:
            name=m[1]
            full='.'.join([x[1] for x in stack if x[0]=='n']+[name]).replace('_root_.','')
            start=doc if doc is not None else i
            j=i+1
            while j<len(lines) and not (lines[j] and not lines[j][0].isspace()): j+=1
            out[full]=(start,j)
            doc=None; i=j; continue
        if l.strip(): doc=None if not l.startswith('@[') else doc
        i+=1
    return out
def segments(text):
    """(kind, start, end) over the file: code and comment regions."""
    i=0;n=len(text);out=[];start=0
    while i<n:
        if text.startswith('/-',i):
            if i>start: out.append(('code',start,i))
            depth=1;j=i+2
            while j<n and depth:
                if text.startswith('/-',j): depth+=1;j+=2
                elif text.startswith('-/',j): depth-=1;j+=2
                else: j+=1
            out.append(('comment',i,j)); i=j; start=i; continue
        if text.startswith('--',i):
            if i>start: out.append(('code',start,i))
            j=text.find('\n',i); j=n if j<0 else j
            out.append(('comment',i,j)); i=j; start=i; continue
        if text[i]=='"':
            j=i+1
            while j<n and text[j]!='"':
                j+= 2 if text[j]=='\\' else 1
            i=j+1; continue
        i+=1
    if start<n: out.append(('code',start,n))
    return out
def lean(n):
    return '.'.join('«%s»'%p if re.search(r'[一-鿿]',p) else p for p in n.split('.'))
def variants(copy, full_only=False):
    parts=lean(copy).split('.')
    if full_only: return ['Becoming.'+'.'.join(parts), '.'.join(parts)] if len(parts)>1 else ['Becoming.'+parts[0]]
    return ['Becoming.'+'.'.join(parts)]+['.'.join(parts[i:]) for i in range(len(parts))]
TOK=lambda v: re.compile(r"(?<![\w.'«!?₀-₉])"+re.escape(v)+r"(?![\w'!?₀-₉»])")
def rewrite_code(text, pairs):
    out=[]
    for kind,a,b in segments(text):
        seg=text[a:b]
        if kind=='code':
            for pat,new in pairs: seg=pat.sub(new,seg)
        else:
            for v,new in pairs_bt(pairs): seg=seg.replace('`'+v+'`','`'+new+'`')
        out.append(seg)
    return ''.join(out)
def pairs_bt(pairs):
    return [(p.pattern_v,n.replace(' _','')) for p,n in ((q[0],q[1]) for q in pairs)] if False else BT[id(pairs)]
BT={}
files={p:p.read_text(encoding='utf-8') for p in B.glob('*.lean')}
modof=lambda m:B/(m.replace('Becoming.','',1)+'.lean')
# 1. delete
missing=[]
bypath=collections.defaultdict(list)
for copy in PLAN:
    if copy in home: bypath[modof(home[copy])].append(copy)
    else: missing.append(copy)
for p,copies in bypath.items():
    if not p.exists(): missing+=copies; continue
    lines=files[p].split('\n')
    where=locate(lines)
    spans=[]
    for c in copies:
        full='Becoming.'+lean(c)
        if full in where: spans.append((where[full],c))
        else: missing.append(c+' @'+p.name)
    for (a,b),c in sorted(spans,key=lambda s:-s[0][0]):
        k=b
        while k<len(lines) and not lines[k].strip(): k+=1
        del lines[a:k]
    files[p]='\n'.join(lines)
print('not found:',missing)
# 2. rewrite in readers (their own home included)
readers=collections.defaultdict(set)
for copy in PLAN:
    if copy in home: readers[modof(home[copy])].add(copy)
    for m in uses.get(copy,()):
        if m.startswith('Becoming.') and m!='Becoming': readers[modof(m)].add(copy)
for p,copies in readers.items():
    if p not in files: continue
    text=files[p]
    pairs=[];bt=[]
    for c in sorted(copies,key=lambda c:-len(c)):
        new=lean(PLAN[c]) if not PLAN[c].endswith(' _') else lean(PLAN[c][:-2])+' _'
        parts=c.split('.')
        prefixes=parts[:-1]
        opened=modof(home.get(c,'x'))==p or any(re.search(r'^\s*(?:namespace|open)\s+(?:\S+\s+)*?(?:\S*\.)?'+re.escape(x)+r'(?:\.\S*)?\b',text,re.M) for x in prefixes)
        if c.startswith('Naturals.') and c.endswith(('add_right_cancel','le_of_add_le_add_right')): vs=['Becoming.'+lean(c),lean(c)] if not p.name=='Prelude.lean' else ['Becoming.'+lean(c),lean(c)]
        else: vs=variants(c) if (opened or len(parts)==1) else variants(c,True)
        for v in vs:
            if v==new: continue
            pairs.append((TOK(v),new.replace('\\','\\\\')))
            bt.append((v,new.replace(' _','')))
    BT[id(pairs)]=bt
    files[p]=rewrite_code(text,pairs)
# 3. backticked mentions anywhere, by qualified name
qual=[(v,PLAN[c].replace(' _','')) for c in PLAN for v in variants(c,True) if ('.' in v)]
qual=[(v,lean(n)) for v,n in qual if v!=lean(n)]
for p in list(files):
    t=files[p]
    for v,n in qual:
        if '`'+v+'`' in t: t=t.replace('`'+v+'`','`'+n+'`')
    files[p]=t
# 4. the blocks
pr=B/'Prelude.lean'
gl=(B/'GrammarLaws.lean').read_text(encoding='utf-8').split('\n')
loc=locate(gl)
take=[]
for n in ['GrammarLaws.skipAt','GrammarLaws.skipAt_ne','GrammarLaws.skipAt_le','GrammarLaws.skipAt_lt','GrammarLaws.split_at_head','GrammarLaws.revisits_within']:
    a,b=loc['Becoming.'+n]
    take.append('\n'.join(gl[a:b]).rstrip())
skip='\n\n'.join(take).replace('{g : Nat → α} {a : α} {l : List α}','{α : Type u} {g : Nat → α} {a : α} {l : List α}').replace('theorem revisits_within : ∀ (l : List α)','theorem revisits_within {α : Type u} : ∀ (l : List α)').replace('mem_cons_split','mem_cons_cases')
blockp=block.PRELUDE.replace('@@SKIP@@',skip)
anchor='/-! ## Stretches of steps -/'
assert files[pr].count(anchor)==1
files[pr]=files[pr].replace(anchor,blockp+'\n'+anchor)
fl=B/'Flow.lean'
a='def sign : Nat → Nat := Witnesses.profile [0] 1\n'
assert files[fl].count(a)==1
files[fl]=files[fl].replace(a,a+block.FLOW_SIGN)
a='''  | a :: as, le => Nat.add_le_add (le a (.head as)) (total_le as fun b mem => le b (.tail a mem))
'''
assert files[fl].count(a)==1
files[fl]=files[fl].replace(a,a+block.FLOW_TOTAL)
ch=B/'Change.lean'
a='''      ((congrArg Nat.succ (excess_balance a b)).trans (Nat.succ_add b _).symm)
'''
assert files[ch].count(a)==1
files[ch]=files[ch].replace(a,a+block.CHANGE)
la=B/'Laws.lean'
m=re.search(r'def Determined \(P : Process S A\) : Prop :=\n(?:  .*\n)+',files[la])
files[la]=files[la][:m.end()]+block.LAWS+files[la][m.end():]
for p,t in files.items():
    if p.read_text(encoding='utf-8')!=t:
        p.write_text(t,encoding='utf-8')
print('written')
