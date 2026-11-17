import sys,os,re
SRC="/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming"
MAX=int(os.environ.get("MAXL","45"))
# usage: decl.py Module name1 name2 ... [-- Module2 name ...]
args=sys.argv[1:]
groups=[];cur=None
for a in args:
    if a=="--": cur=None; continue
    if cur is None: cur=[a]; groups.append(cur)
    else: cur.append(a)
for g in groups:
    mod=g[0]; path=os.path.join(SRC,mod+".lean")
    lines=open(path,encoding="utf-8").read().split("\n")
    for name in g[1:]:
        pat=re.compile(r"^\s*(?:@\[[^\]]*\]\s*)?(?:private |protected |noncomputable )*(theorem|lemma|def|structure|abbrev|inductive|instance|class)\s+(\S*\.)?"+re.escape(name)+r"(\s|$|:|\{|\(|\[)")
        hits=[i for i,l in enumerate(lines) if pat.search(l)]
        if not hits:
            print(f"!! {mod}: {name} NOT FOUND"); continue
        for i in hits[:2]:
            # namespace context
            ns=[]
            for k in range(i,-1,-1):
                m=re.match(r"^namespace\s+(\S+)",lines[k])
                if m: ns.append(m.group(1)); break
            # preceding doc comment
            j=i-1; doc=[]
            if j>=0 and lines[j].rstrip().endswith("-/"):
                while j>=0 and not lines[j].lstrip().startswith("/--"): j-=1
                doc=lines[j:i]
            out=[]
            for k in range(i,min(i+MAX,len(lines))):
                out.append(lines[k])
                if re.search(r":=\s*(by)?\s*$|:=\s|\bwhere\s*$",lines[k]) : break
            print(f"--- {mod}.lean:{i+1}  [ns {ns[0] if ns else '?'}]")
            if os.environ.get("DOC"): print("\n".join(doc))
            print("\n".join(out))
