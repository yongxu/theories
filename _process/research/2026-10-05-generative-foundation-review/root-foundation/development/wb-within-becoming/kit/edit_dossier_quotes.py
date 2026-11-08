import sys,os
root=sys.argv[1]
Q=[("Among them disagreement can fall only on mixed comparisons, and a ranking of a narrowing above its widening comes only from a negative valuation or a misread or framed case: a bound on where disagreement can fall, not a prediction.",
    "Among them disagreement can fall only on mixed comparisons, and a ranking of a narrowing above its widening comes only from a valuation counting something negatively, a case misread or framed, or a loss the weighting does not list: a bound on where disagreement can fall, not a prediction."),
   ("\"Neither is asserted. The condition alone ranks nothing\"",
    "\"Neither is asserted, and neither is the account's own: each is an order or scope some formations hold, and the results say what follows where it is held. The condition alone ranks nothing\""),
   ("\"A ranking of courses needs C or a premise in its place: C gives order, and an order rising with one's own continuation ranks one case with no C\"",
    "\"Whoever ranks courses holds some order; C is the one ranking a course above every course it widens, and an order rising with one's own continuation ranks one case with no C\""),
   ("It does not derive C. A ranking of courses still needs C or a premise in its place, and self-concern and the condition both remain hypotheses; the condition varies with the net, the class and the direction.",
    "It does not derive C. Whoever ranks courses still holds C or another order, and self-concern and the condition both remain hypotheses; the condition varies with the net, the class and the direction."),
   ("\"how far that reaches and which course is better are separate questions with separate premises.\"",
    "\"how far that reaches and how courses are ranked are separate questions, and the results here answer each under a reading it names.\""),
   ("\"this gives, without warranting, a reason of its own to retain what lies within its closure\"",
    "\"that reading is one condition of a response retaining what lies within its closure, a reason of its own; it does not produce the response\""),
   ("\"For life, the way is 生生, life in the whole and its continuing generation [AI reading, D1], compared by widening what can form\"",
    "\"For life, the makers offer a way of seeing, not a verdict: what each course draws on, from what renewal and at which grain, what ends, what goes on through that ending, and who bears it.\""),
   ("\"whose way it is, not whose losses count: every continuation's still does\"",
    "\"whose way it is, not whose losses count: under the continuation condition every continuation's still does\""),
   ("Beneath it is the theorem of P-07; the thesis is Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: \"that these are the valuers who count everything, and that their shared verdict binds those whose own line runs through life, is the thesis\"",
    "Beside it is the theorem of P-07; the thesis is Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: \"that a selection reading what a course draws on, and what ends with it, leaves a draw beyond a renewal its readers depend on more often than one that does not read it\""),
   ("\"argued. Open: P2 and P4, the crux of §4.6's path, with P3, a correspondence not shown for actual selves; the step of invariance, for what that path does not reach; and a reason for C.\"",
    "\"argued; its test beyond T4 named, not designed. Open: P2 and P4, the crux of §4.6's path, with P3, a correspondence not shown for actual selves; how readings that count beyond one's own line form.\""),
   ("\"That the ethics derives from the condition: the condition fixes scope and orders nothing; C gives order, and a ranking of courses needs C or a premise in its place.\"",
    "\"That the ethics derives from the condition: the condition fixes scope and orders nothing; C gives order, and whoever ranks courses holds C or another order, named where a result uses it.\""),
]
for f in ['theories/becoming/review/ALIGNMENT.md','theories/becoming/review/PHILOSOPHY.md']:
    p=os.path.join(root,f); s=open(p,encoding='utf-8').read(); n=0
    for a,b in Q:
        c=s.count(a)
        if c: s=s.replace(a,b); n+=c
    open(p,'w',encoding='utf-8').write(s); print(f,n)
