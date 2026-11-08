import sys
p=sys.argv[1]; s=open(p,encoding='utf-8').read()
def rep(a,b):
    global s
    assert s.count(a)==1,(s.count(a),a[:70]); s=s.replace(a,b)
rep("""    'premises': (CH07, 'The ethics rests on its two premises with two roles, the continuation condition for scope and C for order.'),
    'unasserted': (CH07, 'Neither is asserted.'),""",
"""    'premises': (CH07, 'The ranking results rest on their two readings, the continuation condition for scope and C for order, each named where used.'),
    'unasserted': (CH07, 'Neither is asserted, and neither is the account\\'s own: each is an order or scope some formations hold, and the results say what follows where it is held.'),""")
rep("""    'c-question': (CH08, 'Is widening better (C, which orders), and does significance stop at no boundary (the step of invariance, which fixes scope)?'),
    'c-definition': (CH08, 'C\\'s no-loss extension is widening by definition, so the definition carries no warrant'),
    'c-open': (CH08, 'a reason for C, and whether a stronger practical warrant exists, with no warrant binding every possible mind claimed (T8)'),""",
"""    'c-question': (CH08, 'Which formations hold C, which count past their own line (the step of invariance, which fixes scope), and how such orders form, spread, lock and fare; no warrant from outside is sought.'),
    'c-definition': (CH08, 'C\\'s no-loss extension is widening by definition, so the definition carries no "better"'),
    'c-open': (CH08, 'how C-like orders form; whether a universal practical warrant exists is kept as a question the account does not pursue (T8)'),""")
rep("return ['## The crux and the warrant of C', '',", "return ['## The crux, and how scope and order form', '',")
rep("f'- **The warrant of C.** \"{q(\"c-question\")}\" ('", "f'- **How C and the scope form.** \"{q(\"c-question\")}\" ('")
rep("link(CH08 + '#philosophical-warrant', path, 'method, philosophical warrant')", "link(CH08 + '#philosophical-warrant', path, 'method, philosophical questions')")
# Start here's closing line
rep("return lines + ['', 'The ethics rests on two premises it does not assert: ' + link(CHAPTERS + '/07-SIGNIFICANCE.md#scope-and-order', path, 'the continuation condition fixes scope, and C gives order') + '.', '']",
    "return lines + ['', 'No law here evaluates; where a result ranks courses, it names the two readings it ranks under, neither asserted: ' + link(CHAPTERS + '/07-SIGNIFICANCE.md#scope-and-order', path, 'the continuation condition fixes scope, and C gives order') + '.', '']")
# README's conditional block
rep("'The ethics rests on two premises with two roles: the condition fixes scope, whose losses count, and C, calling widening better, gives order, and a ranking of courses needs C or a premise in its place; '",
    "'The ranking results rest on two readings, neither asserted: the condition fixes scope, whose losses count, and C, calling widening better, gives order; whoever ranks courses holds C or another order; '")
rep("'Open: the warrant of the condition, of C, and of the step of invariance from what one\\'s own continuation needs to the continuation of anything.'",
    "'Open: how the condition, C and the step of invariance, from what one\\'s own continuation needs to the continuation of anything, come to be held; no warrant from outside is sought.'")
open(p,'w',encoding='utf-8').write(s); print('ok')
