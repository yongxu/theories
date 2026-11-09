import sys,os
root=sys.argv[1]
def edit(f,pairs):
    p=os.path.join(root,f); s=open(p,encoding='utf-8').read()
    for a,b in pairs:
        c=s.count(a); assert c==1,(f,c,a[:60]); s=s.replace(a,b)
    open(p,'w',encoding='utf-8').write(s)
edit('theories/becoming/chapters/01-ROOT.md',[("the order of mixed parts, and significance, which no represented dynamics entails ([07](07-SIGNIFICANCE.md),",
 "the order of mixed parts, and significance, which these dynamics, with significance left free, do not entail ([07](07-SIGNIFICANCE.md),")])
edit('theories/becoming/chapters/02-MAP.md',[("it is void from n = m·m/(p·q), and persisting longer needs a giving that reads the level.",
 "it is void from n = m·m/(p·q): beyond that horizon it gives no guarantee, and that persisting longer needs a giving that reads the level would need a further result.")])
edit('theories/becoming/chapters/03-KNOWING.md',[("a route forms when a coupling closes a chain, and a measurement begins when its loop closes.",
 "a route forms when a coupling closes a chain; in the measurement witness, recording closes the stock–record–draw loop.")])
edit('theories/becoming/chapters/04-LIFE.md',[("A flame is both. Read with one kind of relatum, the roles meet: a life feeds a life.",
 "A flame is both. Read with one kind of relatum, the roles meet: a formation can give to a relatum that also acts as a formation; calling either a life is the reading below.")])
edit('theories/becoming/chapters/05-COLLECTIVES.md',[
 ("under the condition the clearer's part loses the dweller from every standpoint, and where nothing has significance it loses nothing (`Clearing.loss_needs_significance`).",
  "under the condition the clearer's part loses the dweller from every standpoint, and where nothing has significance an empty predicate counts no loss, though the dweller still ends (`Clearing.loss_needs_significance`)."),
 ("(resisting a capture that hides a loss needs a member admitted by what the pool does not yet read).",
  "(a pool can gain the missing coupling through admission from beyond that answers the loss, or through recruitment its own course would undertake; how actual pools form is open)."),
])
edit('theories/becoming/COLLECTIVE-DIRECTION.md',[
 ("| getting whose losses count from any description of the dynamics, however complete |",
  "| getting whose losses count from a description of the dynamics that leaves the significance free, however complete |"),
 ("A loss beyond every selector's closure, a loss that returns to no one, counts only under it ([07 §6]",
  "A loss beyond every selector's closure, a loss that returns to no one, is counted under it, and particular scopes can count particular unreturned losses without meeting it ([07 §6]"),
 ("Practical choice among them needs J1–J4 (complete comparison with retained losses, priority of basic conditions, bounded responsibility, legitimate feasible choice), further premises.",
  "The practical comparison 07 proposes among them uses J1–J4 (complete comparison with retained losses, priority of basic conditions, bounded responsibility, legitimate feasible choice), further premises; constraints, undertakings and other held orders can also decide."),
 ("Openness is then a property of how rules keep changing, not of any rule chosen once.",
  "Strict continuing widening relative to a held rule is then a property of how rules keep changing, not of any rule chosen once; keeping what is possible open need not need endless change."),
 ("- **Positive-sum structure.** A difference parts make only together",
  "- **Joint effects.** A difference parts make only together"),
])
print('ok')
