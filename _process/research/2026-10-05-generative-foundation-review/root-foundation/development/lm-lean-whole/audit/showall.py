import re,sys
from pathlib import Path
B=Path('/Users/ren/tmp/lm/work/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming')
rows=[l.split('\t') for l in Path(sys.argv[1]).read_text().split('\n') if l]
lo,hi=int(sys.argv[2]),int(sys.argv[3])
rows.sort(key=lambda r:-int(r[1]))
for r in rows[lo:hi]:
    full,times,mod=r[0],r[1],r[2]
    p=B.parent/(mod.replace('.','/')+'.lean')
    if not p.exists(): print('NOFILE',full); continue
    lines=p.read_text().split('\n')
    short=full.split('.')[-1]
    pat=re.compile(r'^\s*(?:@\[[^\]]*\]\s*)?(?:private |protected |noncomputable )*(?:def|abbrev|structure|inductive|class)\s+(?:[\w.]*\.)?'+re.escape(short)+r'(\s|$|:)')
    for i,l in enumerate(lines):
        if pat.match(l):
            j=i
            if lines[i-1].rstrip().endswith('-/'):
                j=i-1
                while '/--' not in lines[j] and j>0: j-=1
            k=i+1
            while k<len(lines) and lines[k].strip() and k<i+9: k+=1
            print(f'### {full} ×{times} {mod.split(".")[-1]}:{i+1}')
            print('\n'.join(x[:125] for x in lines[j:k]))
            break
    else: print('NOTFOUND',full)
