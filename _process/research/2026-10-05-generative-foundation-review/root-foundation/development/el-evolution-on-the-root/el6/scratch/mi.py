import re
root='experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/'
p=root+'MapInstances.lean'
s=open(p).read()
ld=open(root+'LineDegeneration.lean').read()
def rep(a,b,n=1):
    global s
    assert s.count(a)==n,(s.count(a),a[:90])
    s=s.replace(a,b)
def cut(src,start,end):
    i=src.index(start); j=src.index(end,i)
    return src[i:j]

# --- the section of laws: from '/-! ## Not going on' to 'end Web'
i=s.index('/-! ## Not going on, and reaching an end -/')
j=s.index('end Web\n\n/-! ## Witnesses on the base -/')
old=s[i:j]

# landed docstrings+statements, kept, with new proofs
def landed(name):
    k=old.index('theorem '+name+' ')
    # docstring start: last '/--' before k
    d=old.rindex('/--',0,k)
    e=old.index(':=\n',k)
    return old[d:e+3]
nend=landed('not_endless_of_gone')
dend=landed('degenerates_of_gone')
cnot=landed('consumed_held_not_endless')
fnot=landed('family_excess_not_endless')
snot=landed('stopped_not_endless')

dend=dend.replace("""/-- **Where going on is decided, such a line reaches an end** (有终); that it degenerates (尽) is not
shown. -/
theorem degenerates_of_gone ""","""/-- **Where going on is decided, such a line reaches an end** (有终): its degeneration
(`Web.activity_every_branch_ends_of_gone`) with the decision. -/
theorem end_of_gone """)
assert 'theorem end_of_gone ' in dend

# pieces from LineDegeneration (verbatim)
steps=cut(ld,'/-! ## Ending on every branch, by the steps left -/','/-! ## The three regimes: one gone step each -/')
law=steps.replace("""/-- **At the kind grain**: for every kind relation `Q` and every continuation, the lineage
continuation `Web.withinKind W Q passes` included. -/
theorem kind_every_branch_ends_of_gone {Q : F → F → Prop} {x : Nat × F} {N : Nat}
    (start : W.active x.1 x.2) (le : x.1 ≤ N)
    (gone : ∀ y, «所及» (continuationStep R) (W.kindClass Q) x y → y.1 = N →
      ¬ W.active y.1 y.2) :
    «退化» (continuationStep R) (W.kindClass Q) x :=
  every_branch_ends_of_gone kindClass_within start le gone

""","")
assert 'kind_every' not in law
law=law.replace('/-! ## The constructive degeneration law -/','/-! ## Degeneration: the constructive law -/')
gone=cut(ld,'/-! ## The three regimes: one gone step each -/','/-! ## The three regimes degenerate -/')
degs=cut(ld,'/-! ## The three regimes degenerate -/','/-! ## The landed laws, restated')
def piece(src,name):
    k=src.index('theorem '+name+' '); d=src.rindex('/--',0,k)
    nxt=src.find('\n/--',k); 
    if nxt==-1: nxt=len(src)
    return src[d:nxt+1]
cg,fg,sg=piece(gone,'consumed_held_gone'),piece(gone,'family_excess_gone'),piece(gone,'stopped_gone')
cd,fd,sd=piece(degs,'consumed_held_degenerates'),piece(degs,'family_excess_degenerates'),piece(degs,'stopped_degenerates')

new=('/-! ## Ending on every branch, by the steps left -/'+steps.split('/-! ## Ending on every branch, by the steps left -/')[1]).replace(steps,'') if False else ''
new=law.rstrip('\n')+'\n\n'
new+='/-! ## Not going on, and reaching an end: degeneration read coarser -/\n\n'
new+=nend+"  «尽则非不穷» (activity_every_branch_ends_of_gone start le gone)\n\n"
new+=dend+"  «尽而续可定则有终» (activity_every_branch_ends_of_gone start le gone) decided\n\n"
new+='/-! ## The three regimes degenerate, through one gone step each -/\n\n'
new+=cg.rstrip('\n')+'\n\n'+cd.rstrip('\n')+'\n\n'
new+=cnot+"  «尽则非不穷» (consumed_held_degenerates dependent below after start le held)\n\n"
new+=fg.rstrip('\n')+'\n\n'+fd.rstrip('\n')+'\n\n'
new+=fnot+"  «尽则非不穷» (family_excess_degenerates balances acting dependent gated excess stock start le held)\n\n"
new+=sg.rstrip('\n')+'\n\n'+sd.rstrip('\n')+'\n\n'
new+=snot+"  «尽则非不穷» (stopped_degenerates byPassing brief stopped start le)\n\n"
s=s[:i]+new+s[j:]

# --- witnesses: append LineDegeneration's regime witnesses, Undecided (without kind) and the calibration before the final 'end Map'
w=cut(ld,'/-! ## Witnesses of the regimes -/\n\nnamespace Map\n\n','end Map\n\nend Becoming')
w=w.replace('/-! ## Witnesses of the regimes -/\n\nnamespace Map\n\n','')
kind=piece(w,'kind_degenerates')
assert 'theorem kind_degenerates' in kind
w=w.replace(kind,'')
w=w.replace('    end_of_ends_decided (Web.activity_every_branch_ends_of_gone start le gone) fun _ _ => em _⟩',
            '    «尽而续可定则有终» (Web.activity_every_branch_ends_of_gone start le gone) fun _ _ => em _⟩')
w=w.replace("strong as excluded middle. -/","strong as excluded middle (`Web.end_of_gone`). -/")
w=w.replace("middle**, at every web and continuation: the decision premise of `Web.degenerates_of_gone` is as\nstrong as excluded middle (`Web.end_of_gone`). -/",
            "middle**, at every web and continuation: the decision premise of `Web.end_of_gone` is as strong as\nexcluded middle. -/")
assert 'degenerates_of_gone' not in w, [l for l in w.split('\n') if 'degenerates_of_gone' in l]
tail='end Map\n\nend Becoming\n'
assert s.endswith(tail)
s=s[:-len(tail)]+'/-! ## Witnesses of the regimes, and of the decision -/\n\n'+w.rstrip('\n')+'\n\n'+tail
open(p,'w').write(s)
print(len(s.split('\n')))
open('/private/tmp/claude-501/-Users-ren-theories/6e883b66-baef-49e6-bd45-0e63629106ab/scratchpad/el6/kind_witness.lean','w').write(kind)
