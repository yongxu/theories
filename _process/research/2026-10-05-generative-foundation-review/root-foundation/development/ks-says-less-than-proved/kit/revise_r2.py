# Revise apply_ks.py with the reader's second pass (two qualifiers).
p='/Users/ren/tmp/prefreeze-fix/kskit/apply_ks.py'; s=open(p,encoding='utf-8').read()
def rep(a,b):
    global s
    assert s.count(a)==1,(s.count(a),a[:70]); s=s.replace(a,b)
rep("one amount the case of a single pair (`Breeding.one_amount`). [Record]", "one amount the case of a single pair (`Breeding.one_amount`, a rising line). [Record]")
rep("made countable (every reading of runs is a union of closed ones, recurrence among them)", "made countable (classically, every reading of runs is a union of closed ones, recurrence among them)")
rep("改为可数并（运行的每个读法都是闭读法之并，复现在内）", "改为可数并（经典上，运行的每个读法都是闭读法之并，复现在内）")
open(p,'w',encoding='utf-8').write(s); print('revised')
