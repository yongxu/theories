import sys
p=sys.argv[1]; s=open(p,encoding='utf-8').read()
def rep(a,b,n=1):
    global s
    assert s.count(a)==n,(s.count(a),a[:70]); s=s.replace(a,b)
rep("T8 names a pure closing argued good for life as what refutes T8 ([§8](#theses)): the witness would have that refuter's shape. What it would still want is the argument that the closing is good for life, what it closes counted; that each gets more by the game's payoffs is not yet that argument.",
    "Until 9 November 2026 T8 named a pure closing argued good for life as what refutes it, and the witness would have had that refuter's shape; it would still have wanted the argument that the closing is good for life, what it closes counted, and that each gets more by the game's payoffs is not that argument. T8 now names what could fail of its offer instead ([§8](#theses)); against C the witness keeps the bearing stated above.")
rep("the second-order direction 07 asks for", "the second-order direction 07 has asked about", 2)
rep("what the growth bears on, for the theory's direction, is what calling widening better (C) is read on, a first-order matter.",
    "what the growth bears on, for C, is what calling widening better is read on, a first-order matter.")
rep("Whether that presupposition is warranted is a further question, since a presupposition can be false.",
    "Whether that presupposition holds for actual selves is a further question (P3), since a presupposition can be false.")
rep("**Warrant, recognition, motivation.** Two questions are asked here: what acting presupposes, and whether that is warranted. Only the second is warrant.",
    "**Presupposition, recognition, motivation.** One question is asked here: what acting presupposes. Whether it holds for actual selves is P3, a correspondence; no warrant from outside is sought.")
rep("The direction proposed: align AI formation,", "The direction its makers offer AI, read under scope and order: align AI formation,")
rep("The direction asks AI to enable actual realization,", "Read so, it would have AI enable actual realization,")
rep("and to allow warranted transformation, transfer and ending;", "and to allow transformation, transfer and ending that those affected can read and answer;")
rep("comes only from a negative valuation or a misread or framed case:", "comes only from a valuation counting something negatively, a case misread or framed, or a loss the weighting does not list:")
open(p,'w',encoding='utf-8').write(s); print('ok')
