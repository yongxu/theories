# AI-written (reader "smaller"), 16 November 2026. Read only: context of a bare name in the files that mention WayOfUnits.
import re, sys
R='/Users/ren/theories/'
files=['theories/becoming/results/data/shared-laws.json','theories/becoming/results/records/turning-in-time.json','theories/becoming/results/records/a-way-of-units.json','theories/becoming/results/records/a-way-of-units.md','theories/becoming/results/records/turning-in-time.md','theories/becoming/results/atlas/entries/dynamics.json','theories/becoming/results/atlas/entries/premises.json','_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aa-attractor-atlas/six/mapping.json','theories/becoming/chapters/02-MAP.md']
name=sys.argv[1]; w=int(sys.argv[2]) if len(sys.argv)>2 else 120
for f in files:
    t=open(R+f,encoding='utf-8').read()
    for m in re.finditer(r'(?<![\w.])'+re.escape(name)+r"(?![\w'])",t):
        s=t[max(0,m.start()-w):m.end()+w].replace('\n',' ')
        print(f.split('/')[-1], '@', t.count('\n',0,m.start())+1, ':', s)
        print()
