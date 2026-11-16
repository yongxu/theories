import re,os,sys,json
L='experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming'
pat=re.compile(r'^(?:private |protected )?(theorem|lemma)\s+([^\s:({\[]+)')
key=re.compile(r'(ends?_iff|unending|noReturn|no_return|deadline|threshold|margin|in_time|turns|iff_below|iff_above|iff_before|iff_within|iff_holds|tipp|break|lasts_iff|persist.*iff|collapse|recover|iff_first|below_iff|iff_met|iff_exceed|excess|stays_below|iff_short|iff_lt|iff_le|overdraw.*iff|iff_overdraw|extinct|iff_reach)',re.I)
out=[]
for fn in sorted(os.listdir(L)):
    if not fn.endswith('.lean'): continue
    lines=open(os.path.join(L,fn)).read().split('\n')
    ns=[]
    for i,l in enumerate(lines):
        m=pat.match(l)
        if m and key.search(m.group(2)):
            # collect statement to ':='
            st=[]
            for j in range(i,min(i+25,len(lines))):
                st.append(lines[j].strip())
                if ':=' in lines[j]: break
            s=' '.join(st)
            out.append((fn[:-5],i+1,m.group(2),s))
mods={}
for m,i,n,s in out: mods.setdefault(m,[]).append((i,n,s))
print(len(out),'theorems in',len(mods),'modules')
json.dump(out,open('tmp/r7/one-model/check/round10/phase-transitions/scan.json','w'))
for m in sorted(mods,key=lambda k:-len(mods[k])):
    iff=[x for x in mods[m] if '↔' in x[2]]
    print(m,len(mods[m]),'iff:',len(iff))
