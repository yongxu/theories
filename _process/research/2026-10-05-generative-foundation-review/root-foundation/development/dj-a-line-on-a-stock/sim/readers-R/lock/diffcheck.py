import re, sys, difflib
T='/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/TurningInTime.lean'
S='/Users/ren/theories/tmp/r7/one-model/lean-scratch/Becoming/TurningInTime.lean'
t=open(T).read().split('\n'); s=open(S).read().split('\n')
def comment_mask(lines):
    mask=[]; depth=0
    for ln in lines:
        start=depth>0
        i=0; anycode=False
        while i<len(ln):
            if ln.startswith('/-',i): depth+=1; i+=2; continue
            if ln.startswith('-/',i) and depth>0: depth-=1; i+=2; continue
            if depth==0 and not ln[i].isspace(): anycode=True
            i+=1
        mask.append(not anycode and (start or depth>0 or ln.strip().startswith('/-') or ln.strip()==''))
    return mask
mt=comment_mask(t); ms=comment_mask(s)
sm=difflib.SequenceMatcher(None,t,s,autojunk=False)
removed=[];added=[]
for tag,i1,i2,j1,j2 in sm.get_opcodes():
    if tag=='equal': continue
    print(tag,'tracked',i1+1,i2,'scratch',j1+1,j2)
    for i in range(i1,i2):
        removed.append(i); 
        if not mt[i]: print('  REMOVED NON-COMMENT',i+1,t[i])
    if tag=='insert':
        # context
        print('   before:',repr(t[i1-1][:80]),'| after:',repr(t[i1][:80]) if i1<len(t) else None)
    if tag=='replace':
        nc=[j for j in range(j1,j2) if not ms[j]]
        if nc: print('  replace adds non-comment lines', [x+1 for x in nc][:5])
print('removed',len(removed),'all comment:',all(mt[i] for i in removed))
# code-only comparison: strip all comments from both, compare tracked code is subsequence of scratch code
def code(lines,mask): return [l for l,m in zip(lines,mask) if not m]
ct=code(t,mt); cs=code(s,ms)
sm2=difflib.SequenceMatcher(None,ct,cs,autojunk=False)
ops=[o for o in sm2.get_opcodes() if o[0]!='equal']
print('code ops:',[(o[0],o[2]-o[1],o[4]-o[3]) for o in ops])
