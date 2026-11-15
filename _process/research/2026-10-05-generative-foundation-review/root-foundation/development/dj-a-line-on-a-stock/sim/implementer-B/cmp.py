import re,sys
def decls(p):
    s=open(p).read(); out={}
    for m in re.finditer(r'^(theorem|def|abbrev|instance|inductive) (\S+)(.*?)(:=|\n  \||\nwhere| where)', s, re.S|re.M):
        out[m.group(2)]=' '.join((m.group(3)).split())
    return out
a=decls(sys.argv[1]); b=decls(sys.argv[2])
print('missing', [k for k in a if k not in b]); print('changed', [k for k in a if k in b and a[k]!=b[k]]); print('new', [k for k in b if k not in a])
