# AI-written, 16 November 2026. Read only: which WayOfUnits declarations are named in the tracked records the brief lists.
import re,glob,sys
R='/Users/ren/theories/'
files=[R+'theories/becoming/results/data/shared-laws.json']+glob.glob(R+'theories/becoming/results/records/*.json')+glob.glob(R+'theories/becoming/results/atlas/entries/*.json')+[R+'_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aa-attractor-atlas/six/mapping.json']+[p for p in glob.glob(R+'theories/becoming/chapters/**/*',recursive=True) if not p.endswith('/') and '.' in p.split('/')[-1]]
text={}
for f in files:
    try: text[f]=open(f,encoding='utf-8',errors='replace').read()
    except IsADirectoryError: pass
src=open(sys.argv[1]).read()
names=re.findall(r'^(?:private\s+)?(?:theorem|def|abbrev|instance)\s+(\S+)',src,re.M)
for n in names:
    hits=[f.replace(R,'') for f,t in text.items() if ('WayOfUnits.'+n) in t or ('`'+n+'`') in t]
    q=[f.replace(R,'') for f,t in text.items() if ('WayOfUnits.'+n) in t]
    print(n, 'QUALIFIED:'+str(len(q)), 'ANY:'+str(len(hits)), (q[:3] if q else hits[:3]))
