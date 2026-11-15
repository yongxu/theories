import re,sys
p='/Users/ren/theories/tmp/r7/one-model/lean-scratch/Becoming/LineOnAStock.lean'
src=open(p).read().split('\n')
# split into declarations
decl_re=re.compile(r'^(theorem|def|abbrev|instance|inductive)\s+([^\s:(\[{]+)')
decls=[]
for i,l in enumerate(src):
    m=decl_re.match(l)
    if m: decls.append((i,m.group(1),m.group(2)))
decls.append((len(src),'end','end'))
names=[d[2] for d in decls[:-1]]
ext=['WayOfUnits\\.[A-Za-z_.]+','RegimeMargin\\.[A-Za-z_]+','TurningInTime\\.[A-Za-z_.]+','GrammarLaws\\.[A-Za-z_]+','SelectionTerm\\.[A-Za-z_.]+','Law\\.[A-Za-z_]+','Naturals\\.[A-Za-z_]+','ListTests\\.[A-Za-z_]+','Flow\\.[A-Za-z_]+',
 r'\btotal_append\b',r'\btotal_le\b',r'\btotal_congr\b',r'\btotal_ones\b',r'\bfirst_of_decided\b',r'\ble_dest\b',r'\bsub_eq_zero_of_le\b',r'\blength_pos_of_mem\b',r'\bborn_eq\b',r'\.family\b',r'\.sum\b',r'\btotal\b',r'«不穷»',r'«一»',r'«际»',r'\bdecide\b']
for k in range(len(decls)-1):
    i,kind,name=decls[k]
    j=decls[k+1][0]
    body='\n'.join(src[i:j])
    # cut body at next docstring start
    cut=body.find('\n/--')
    if cut>0: body=body[:cut]
    # separate statement from proof roughly at ':=' or first '\n  |'
    found=set()
    for e in ext:
        for m in re.finditer(e,body):
            found.add(m.group(0))
    internal=set()
    for n in names:
        if n!=name and re.search(r'(?<![A-Za-z_.\'])'+re.escape(n)+r'(?![A-Za-z_\'])',body):
            internal.add(n)
    print(f"{i+1:5d} {kind:8s} {name:22s} EXT={sorted(found)} INT={sorted(internal)}")
