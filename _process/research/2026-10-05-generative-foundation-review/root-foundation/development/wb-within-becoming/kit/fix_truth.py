import sys,os
root=sys.argv[1]
def edit(f,pairs):
    p=os.path.join(root,f); s=open(p,encoding='utf-8').read()
    for a,b in pairs:
        c=s.count(a); assert c==1,(f,c,a[:60]); s=s.replace(a,b)
    open(p,'w',encoding='utf-8').write(s)
edit('theories/becoming/OPENING.md',[
 ("and where one fails, the law says exactly which conclusion goes with it.[^law]",
  "and where one fails, the law no longer guarantees the conclusions that used it, and a constructed world shows each can then fail.[^law]"),
 ("So whatever has lasted has never, with all who draw with it, taken more than there was to spare: lasting proves the joint draw, and one's own restraint proves nothing.",
  "So, in the model, whatever has lasted through such renewals has never, with all who draw with it, run past what there was to spare long enough to end it: lasting bounds the joint draw, and one's own restraint proves nothing."),
 ("The law shows what anything that wants to go on must count: everything that bears on what it depends on,",
  "The law shows what anything that wants to go on depends on, and so must count if it is to see its own course: everything that bears on what it depends on,"),
 ("which anyone who counts everything at stake as worth something already holds,",
  "which, on a finite listing, anyone whose weighting counts each thing at stake as worth something already ranks as it does,"),
 ("This holds of any understanding, this one included: no map couples into everything, and what lies beyond it is reached only through others who couple into it.",
  "This holds of any understanding, this one included: no map here is shown to couple into everything, and what lies beyond a map is reached only through what couples into it, others among them."),
 ("and nothing that keeps taking stays closed, so no self owns what it goes on through.[^no-law]",
  "and nothing that keeps taking stays closed, so no self is closed off from what it goes on through.[^no-law]"),
])
edit('theories/becoming/chapters/07-SIGNIFICANCE.md',[
 ("| a course closing something the other admits neither widens nor keeps it, so C never ranks it above | `Web.not_widens_of_closes` |",
  "| a course closing something the other admits neither widens nor keeps it, so C does not ask that it be ranked above | `Web.not_widens_of_closes` |"),
 ("Capability is a reason to pool, not to govern: read as reach (above),", "Capability, on this reading, is a reason its makers offer to pool rather than to govern, under the requirements above: read as reach (above),"),
 ("The step gives a positive grade, not status: numbers count only if status is invariant and equal, which is not asserted.",
  "The step gives a positive grade, not status: under invariant and equal status these rankings reduce to counting, which is not asserted; unequal grades can still let numbers matter."),
])
edit('theories/becoming/chapters/08-METHOD.md',[
 ("The review found prose saying more than four of these theorems prove, and the chapters and the opening keep their prose within the theorems, the opening's notes giving each sentence's standing:",
  "The review found prose saying more than four of these theorems prove, and the passages it named were brought within the theorems, the opening's notes giving each sentence's standing; that is not a certificate for all the prose, and later reviews have found more (WB, 9 November 2026):"),
])
edit('theories/becoming/chapters/06-CLASSICAL-TEXTS.md',[
 ("“天地之大德曰生”是一种已成之序的表述，与 C 同形，不是定理，本论读其结构，不以之为据",
  "“天地之大德曰生”可与重生之评价相参，不因此等同于 C，也不是定理；本论读其结构，不以之为据"),
 ("知来只在历程有界、读法为律所同行之处成立", "该识别定理在历程有界、读法为律所同行之处成立；它并未穷尽知来的方式"),
])
print('ok')
