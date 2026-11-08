import sys,os
root=sys.argv[1]
def edit(f,pairs):
    p=os.path.join(root,f); s=open(p,encoding='utf-8').read()
    for a,b in pairs:
        c=s.count(a); assert c==1,(f,c,a[:60]); s=s.replace(a,b)
    open(p,'w',encoding='utf-8').write(s)
edit('theories/becoming/ONE-PAGE.md',[("Eating and ending belong to life's going on; what the laws mark is a draw beyond what the renewal it depends on gives.",
 "Eating and ending belong to life's going on; what the laws mark is what a course closes: a draw beyond what the renewal it depends on gives ends it, and even one within renewal can close what has not yet formed ([07 §2](chapters/07-SIGNIFICANCE.md#r-the-run-classes-and-widening)).")])
edit('theories/becoming/ONE-PAGE.zh.md',[("吃与结束属于生命之延续；诸律所标出的，是越出其所依之更新所给的取用。",
 "吃与结束属于生命之延续；诸律所标出的，是一个进程闭了什么：越出其所依之更新所给的取用终结它，即使在更新之内的取用，也可能闭掉尚未形成者（[07 §2](chapters/07-SIGNIFICANCE.md#r-the-run-classes-and-widening)）。")])
edit('theories/becoming/OPENING.md',[("Eating and ending belong to life's going on; what the law marks is a draw beyond what the renewal it depends on gives.",
 "Eating and ending belong to life's going on; what the law marks is what a course closes: a draw beyond what the renewal it depends on gives ends it, and even one within renewal can close what has not yet formed.")])
edit('theories/becoming/chapters/07-SIGNIFICANCE.md',[("Eating and ending belong to life's going on; what the laws mark is a draw beyond what the renewal it depends on gives ([05](05-COLLECTIVES.md#r-own-count-misses-joint-excess)), its own or others', and where each course ends something the situation decides.",
 "Eating and ending belong to life's going on; what the laws mark is what a course closes: a draw beyond what the renewal it depends on gives, its own or others', ends it ([05](05-COLLECTIVES.md#r-own-count-misses-joint-excess)), and even a draw within renewal at a step can close what has not yet formed ([§2](#r-the-run-classes-and-widening), `Preemption`); where each course ends something the situation decides.")])
edit('theories/becoming/chapters/06-CLASSICAL-TEXTS.md',[("在延续之条件下，每一种结束在其所结束者之粒度上都是收窄，都有所失；在其所依之更新之粒度上，汲取若不出更新所给，则无所闭：吃与结束属于生命之延续（[第七章 §8](07-SIGNIFICANCE.md#theses)）。",
 "在延续之条件下，每一种结束都有所失；含此结束的历程或收窄，或得失相杂，须明其类与粒度。吃与结束属于生命之延续；诸律所标出的，是一个历程闭了什么，而即使在更新之内的取用，也可能闭掉尚未形成者（[第七章 §2](07-SIGNIFICANCE.md#r-the-run-classes-and-widening)，[§8](07-SIGNIFICANCE.md#theses)）。")])
print('ok')
