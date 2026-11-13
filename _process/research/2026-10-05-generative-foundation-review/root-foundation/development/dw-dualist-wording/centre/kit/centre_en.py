#!/usr/bin/env python3
"""centre_en <tree>: DW step 1, English. Every edit is an exact phrase with its expected count."""
import sys
tree = sys.argv[1]
B = 'theories/becoming/'
E = {}
def ed(path, old, new, n=1): E.setdefault(path, []).append((old, new, n))
EX = '(a reward, a judge, a market, a vote, a training run)'
C1 = f'A selection {EX} is one dynamic among others, some of which sustain it.'
C2a = 'Two courses that differ in nothing that makes a difference to the selection are selected alike'
C2b = 'How much is left of what sustains the selection can be among what makes no difference to it; then the selection can use that up while nothing in it yet differs'
C3 = 'where each step sets the selection again only from the share it already favours, the selection goes on the same way until what sustains it gives out, unless its running down makes a difference to the selection early enough'
AIM = 'an alignment in which what sustains humans and AI keeps making a difference, early enough, to how they select together, and in which shaping how they select does not become what they select for'
AIM_OLD = 'an alignment that keeps humans and AI, selecting together, out of instrumental convergence and the meta-attractor: a joint selection that reads beyond its own share and does not come to select for control over its own selection'
NAMES = 'Instrumental convergence and the meta-attractor name what happens when this does not hold'
names = 'instrumental convergence and the meta-attractor name what happens when this does not hold'
T = f'the differences that make a difference to a selection {EX}, how what sustains it can run down while that makes no difference to it, and how it can go on the same way until that gives out, or turn early enough'
T0 = 'the differences that make a difference to a selection, how what sustains it can run down while that makes no difference to it, and how it can go on the same way until that gives out, or turn early enough'
O = 'where a selection that ranks more of what makes a difference to it higher is at its best, what makes no difference to it stands as low as any allowed outcome leaves it, given room'
ROOM = ' (wherever an allowed outcome leaves it higher than another does, some allowed outcome does better than that one on what makes a difference)'
RULE = 'the rule (how the selection selects at a step)'
LFORM = f'Its closed form, in which what is selected next and {RULE} as each step sets it again both follow from the share and the rule alone, how the rule is set again being formed from the share too, so that a loss makes a difference to neither,'
COND3 = 'selection does not lower the favoured share; a share not lower sets again a rule not lower; and a rule not lower than a favouring one still favours'
CORR = ', a correspondence and not a theorem'
M = 'Where what a selection raises comes to set the selection, the loop is what the work calls the'
L_LOCK = 'where selection does not lower the favoured share, a share not lower sets again a rule not lower, and a rule not lower than a favouring one still favours'
G1o = 'Control of the rule is not captured: where shaping the rule is selected by what comes back to the shapers, alone or through the groups they are in'
G1 = 'Where shaping the rule (how they select) rises by what comes back to those who shape it, alone or through the groups they are in'
G2o = 'the rule they shape still reads what lies beyond their share, so that a loss there can turn it'
G2 = 'something other than their share still makes a difference to the rule, so that a loss that makes no difference to their share can turn it'
G3o = 'A lock, once formed, is left in time, by a reading of what lies beyond the share before the loss passes its point of no return.'
G3 = 'And a lock, once formed, gives way early enough: something other than the share comes to make a difference to the rule before the loss passes its point of no return.'
G4o = 'The meta-attractor is the two failing together'
G4 = 'Where both fail, the meta-attractor has closed and holds'

# ---- AGENTS.md
ed('AGENTS.md',
   f'It is first a map for alignment: what a selection {EX} reaches, what it drains beyond what it reads, how it locks on what it already chose. From it we want to design {AIM_OLD}.',
   f'It is first a map for alignment. {C1} {C2a}. {C2b}. And {C3}. From this map we want to design {AIM}. {NAMES}.')
ed('AGENTS.md', 'the last [before the four questions](_process/history/2026-11-13-instructions/AGENTS-before-the-four-questions.md)',
   'the last [before the centre was said again](_process/history/2026-11-13-instructions/AGENTS-before-the-centre-said-again.md)')

# ---- the one page
P = B + 'ONE-PAGE.md'
ed(P, f'Its centre: a selection {EX} reaches only what couples into it; doing best on what it reads can drain what lies beyond, as far as any allowed outcome does; and a rule read from the share of its own winners can lock on them while a loss it does not read grows. Where winning comes to buy power over the rule that selects, the loop is what the work calls the [meta-attractor](../meta-attractor/README.md). Its closed form, the rule and how it is read both formed from the share it selects and nothing in it reading beyond that share, can lock ([02 §9](chapters/02-MAP.md#r-closed-capture)): where selection does not lower the favoured share and the rule and its reading follow it upward and keep favouring it, a course once locked stays locked whatever loss nothing in it reads, and if that loss grows by at least one unit each step, it passes every bound without breaking the lock. These are theorems on stated models, checked in Lean;',
   f'Its centre: {C1[0].lower() + C1[1:]} {C2a}. {C2b}; and {O}{ROOM}. And {C3} ([02 §11](chapters/02-MAP.md#turning-in-time)). {M} [meta-attractor](../meta-attractor/README.md). {LFORM} can lock ([02 §9](chapters/02-MAP.md#r-closed-capture)) under three conditions: {COND3}. Then a course once locked stays locked whatever the loss, and if the loss grows by at least one unit each step, it passes every bound and the lock holds. These are theorems on stated models, checked in Lean (that a selection is one dynamic among others, some of which sustain it, is given, not a theorem: 02 §11\'s model gives the going on a need, and §9\'s lock is built needing nothing; "the same way" says the lock is kept and neither the share nor the rule falls);')
ed(P, f'The map is drawn first for alignment. From it we want to design {AIM_OLD} (below).',
   f'The map is drawn first for alignment. From it we want to design {AIM} (below); {names}, a correspondence and not a theorem.')
ed(P, '**Alignment.** It is first what a selection can reach (', '**Alignment.** It is first a question: which differences make a difference to a selection (')
ed(P, f'From this map we want to design {AIM_OLD} ([the goal](../../GOALS.md#generative-alignment)).', f'From this map we want to design {AIM} ([the goal](../../GOALS.md#generative-alignment)).')

# ---- the overview
V = B + 'THE-THEORY-OF-BECOMING.md'
ed(V, 'It is drawn first for alignment: what a selection reaches, what doing best on what it reads can drain beyond that, and how a rule read from the share of its own winners can lock on them; where winning comes to buy power over the rule that selects, the loop is the [meta-attractor](../meta-attractor/README.md). Its closed form, the rule and how it is read both formed from the share it selects, can lock, on stated models (§2): where selection does not lower the favoured share and the rule and its reading follow it upward and keep favouring it, a course once locked stays locked whatever loss nothing in it reads, and if that loss grows by at least one unit each step, it passes every bound without breaking the lock. ' + f'From it we want to design {AIM_OLD} (§7).',
   f'It is drawn first for alignment. {C1} {C2a} (§3). {C2b}; and {O} (§5). And {C3} ([02 §11](chapters/02-MAP.md#turning-in-time)); where what a selection raises comes to set the selection, the loop is the [meta-attractor](../meta-attractor/README.md). {LFORM} can lock, on stated models (§2), under three conditions: {COND3}. Then a course once locked stays locked whatever the loss, and if the loss grows by at least one unit each step, it passes every bound and the lock holds. From it we want to design {AIM} (§7); {names}{CORR}.')
ed(V, 'its line runs through what a selection reaches (§3), what an optimum can drain beyond that (§5), how a rule read from the share it raises can lock, and the meta-attractor, the loop in which winning comes to buy power over the rule, whose closed form can lock (§2)',
   'its line runs through which differences make a difference to a selection (§3), how low an optimum leaves what makes none (§5), how a rule set again from the share it raises can lock, and the meta-attractor, the loop in which what a selection raises comes to set the selection, whose closed form can lock (§2)')
ed(V, 'reaches only what couples into its selector, so it can meet its own criterion while what it cannot read is lost, and a rule read from its own results can hold itself there; where winning comes to buy power over the rule that selects, the loop is the *meta-attractor*, whose closed form, the reading of the rule formed from those results too, can lock (§2).',
   'is one dynamic among others, some of which sustain it; only what couples into it makes a difference to it, so its criterion can be met while what makes no difference to it is lost, and where each step sets it again only from the share it already favours it can go on the same way until what sustains it gives out; where what a selection raises comes to set the selection, the loop is the *meta-attractor*, whose closed form can lock (§2).')
ed(V, 'the loop in which winning comes to buy power over the rule that selects ([the folder](../meta-attractor/README.md))', 'the loop in which what a selection raises comes to set the selection ([the folder](../meta-attractor/README.md))')
ed(V, '**Alignment.** Alignment is first a question with no premise: what a selection can reach.', '**Alignment.** Alignment is first a question with no premise: which differences make a difference to a selection.')
ed(V, f'From this map we want to design {AIM_OLD} (§2;', f'From this map we want to design {AIM} (§2;')

# ---- the uses pages and the first screen
LEAD_OLD = f'what a selection {EX} reaches, what it drains beyond what it reads, how it comes to lock on what it already chose, and how winning comes to buy power over the rule that selects: the loop the work calls the '
LEAD_NEW = f'{T}. Where what a selection raises comes to set the selection, the loop is what the work calls the '
LS_OLD = 'Its closed form, where the rule and how it is read are both formed from the share it selects, can lock: on stated models, where selection does not lower the favoured share and the rule and its reading follow it upward and keep favouring it, a locked start stays locked however large an unread loss grows'
LS_NEW = f'Its closed form, where what is selected next and {RULE} as each step sets it again follow from the share and the rule alone, how the rule is set again being formed from the share too, can lock: on stated models, {L_LOCK}, a locked start stays locked however large a loss grows that makes no difference to either'
U = B + 'USES.md'
ed(U, 'It is first a map for alignment: ' + LEAD_OLD + '[meta-attractor](../meta-attractor/README.md).', 'It is first a map for alignment: ' + LEAD_NEW + '[meta-attractor](../meta-attractor/README.md).')
ed(U, LS_OLD, LS_NEW)
ed(U, f'From this map we want to design {AIM_OLD} ([the goal](../../GOALS.md#generative-alignment)).', f'From this map we want to design {AIM} ([the goal](../../GOALS.md#generative-alignment)); {names}{CORR}.')
F = '_process/navigation/README-FIRST-SCREEN.md'
ed(F, 'First, a map for alignment: ' + LEAD_OLD + '[meta-attractor](../../theories/meta-attractor/README.md).', 'First, a map for alignment: ' + LEAD_NEW + '[meta-attractor](../../GLOSSARY.md#meta-attractor).')
ed(F, LS_OLD, LS_NEW)
ed(F, f'From this map we [want to design](../../GOALS.md#generative-alignment) {AIM_OLD}.', f'From this map we [want to design](../../GOALS.md#generative-alignment) {AIM}; {names}{CORR}.')
X = B + 'USES-EXAMPLES.md'
ed(X, f'From this map we want to design {AIM_OLD}.', f'From this map we want to design {AIM}.')
ed(X, 'The [meta-attractor](../meta-attractor/README.md), the loop in which winning comes to buy power over the rule that selects, is the two failing together (', 'Where both fail, the [meta-attractor](../meta-attractor/README.md), the loop in which what a selection raises comes to set the selection, has closed and holds (')
ed(X, 'capture of the rule is selected, and the rule it shapes locks.', 'shaping the rule is selected, and the rule it shapes locks.')
D = B + 'COLLECTIVE-DIRECTION.md'
ed(D, f'From the map we want to design {AIM_OLD} ([the goal](../../GOALS.md#generative-alignment)).', f'From the map we want to design {AIM} ([the goal](../../GOALS.md#generative-alignment)).')
ed('MAP.md', f'from it we [want to design](GOALS.md#generative-alignment) {AIM_OLD}.', f'from it we [want to design](GOALS.md#generative-alignment) {AIM}; {names}{CORR}.')
J = '_process/goals/generative-alignment.json'
ed(J, f'From this map we want to design {AIM_OLD}.', f'From this map we want to design {AIM}.')
for p in (P, V, X, D, J):
    ed(p, G1o, G1); ed(p, G2o, G2); ed(p, G3o, G3)
for p in (P, V, D, J):
    ed(p, G4o, G4)

# ---- one-line descriptions
ed('GLOSSARY.md', 'first a map for alignment, what a selection reaches, what it can drain beyond what it reads and how its rule can lock;', f'first a map for alignment, {T0};')
ed('GLOSSARY.md', '| meta-attractor (元吸引子) | the loop in which winning comes to buy power over the rule that selects ([the folder](theories/meta-attractor/README.md)). Its closed form is 02 §9\'s definition, a loop of selection whose rule and whose reading of the rule are both formed from the share it selects, nothing in it reading what lies beyond the share; on stated models it is proved to lock, a loss it does not read leaving it locked however large the loss grows',
   '| <a id="meta-attractor"></a>meta-attractor (元吸引子) | the loop in which what a selection raises comes to set the selection; in the work\'s earlier words, "the loop in which winning comes to buy power over the rule that selects" ([the folder](theories/meta-attractor/README.md)). Its closed form is 02 §9\'s definition, a loop of selection whose rule, and how the rule is set again, are both formed from the share it selects, nothing else making a difference to either; where what is selected next and the rule as each step sets it again follow from the share and the rule alone, it is proved on stated models to lock, a loss that makes a difference to neither leaving it locked however large the loss grows')
ed('_process/navigation/REPOSITORY.md', f'first a map for alignment, of what a selection {EX} reaches, what it can drain beyond what it reads and how its rule can lock on what it already chose;', f'first a map for alignment: {T};')
ed('_process/research-config.json', 'For alignment: what a selection reaches, what it drains beyond what it reads, how it comes to lock on what it already chose, and how winning comes to buy power over the rule that selects.', f'For alignment: {T0}.')
ed('experiments/README.md', 'under a selection, what a reward or a judge reaches, what it drains beyond what it reads, whether it locks on what it already chose and whether it comes to shape its own evaluator, the meta-attractor\'s loop',
   'under a selection: which differences make a difference to a reward or a judge, whether what makes no difference to it is run down, whether, set again only from the share it already favours, it goes on the same way, and whether shaping the evaluator comes to be selected, the meta-attractor\'s loop')
N = 'tools/research/navigation.py'
ed(N, "'The work draws one map: for alignment, what a selection reaches, drains beyond what it reads and locks on, toward the '\n                        'alignment we want, one that keeps humans and AI, selecting together, out of instrumental convergence '\n                        'and the meta-attractor: a joint selection that reads beyond its own share and does not come to select for control '\n                        'over its own selection; and of wisdom,",
   "'The work draws one map: for alignment, the differences that make a difference to a selection, how what sustains it can run '\n                        'down while that makes no difference to it, and how it can go on the same way until that gives out, or turn early enough; from '\n                        'it we want to design an alignment in which what sustains humans and AI keeps making a difference, early enough, to how they '\n                        'select together, and in which shaping how they select does not become what they select for; and of wisdom,")
ed('tools/research/reading_catalogue.py', '| What does a selection reach, drain beyond what it reads and lock on, and what does that give alignment? |', '| Which differences make a difference to a selection, what can run down while that makes no difference to it, when does it lock, and what does that give alignment? |')

# ---- second readers' findings (13 November 2026)
ed('GLOSSARY.md', 'a configuration of a rule read from the share it raises in which the rule keeps favouring what it selected, share and rule never below the start, while a loss it does not read can pass every bound;', 'a configuration of a rule set again from the share it raises in which the rule keeps favouring what it selected, share and rule never below the start, while a loss that makes no difference to either can pass every bound;')
ed(V, 'Whether a loss beyond a selection counts forms within becoming too,', 'Whether a loss that makes no difference to a selection counts forms within becoming too,')
ed(V, 'A selection whose rule is read from the share it raises can hold itself. Proved for any type:', 'A selection whose rule is read from the share it raises can hold itself (this section keeps the chapter\'s words: the rule read at a step is the rule as that step sets it again, and an unread loss is one that makes no difference to what is selected next or to that rule). Proved for any type:')
ed(X, 'Its closed form, a loop whose rule and whose reading of the rule are both formed from the share it selects, can lock: on stated models, where selection does not lower the favoured share and the rule and its reading follow it upward and keep favouring it, a locked start stays locked however large an unread loss grows', LS_NEW)
for p_ in (P, V):
    ed(p_, 'not a case of the first of the two (', 'not a case of the first of the two asks failing (')
ed(X, 'it is not a case of the first of the two, and', 'it is not a case of the first of the two asks failing, and')
DWNOTE = ' On 13 November 2026 (board item DW, on Ren\'s words of 11 to 13 November) the sentences on the centre and the aim were said again from the theorems\' own statements, in blocks kept in the study folder dw-dualist-wording: what makes a difference to a selection and what sustains it are two relations with two phrases; the aim follows AGENTS.md\'s second paragraph; no sentence here follows the earlier clause ("a joint selection that reads beyond its own share …") any longer, and a later pass does not put it back. -->'
ed(U, 'the lock itself holding whatever the unread loss. -->', 'the lock itself holding whatever the unread loss.' + DWNOTE)
ed(F, 'and spine.svg keeps an older name). AI-written. -->', 'and spine.svg keeps an older name). AI-written.' + DWNOTE)
bad = 0
for path, lst in E.items():
    p = f'{tree}/{path}'; s = open(p, encoding='utf-8').read()
    for old, new, n in lst:
        k = s.count(old)
        if k != n: print('MISMATCH', path, k, 'expected', n, '|', old[:90]); bad += 1; continue
        s = s.replace(old, new)
    with open(p, 'w', encoding='utf-8') as f: f.write(s)
print('files', len(E), 'edits', sum(len(v) for v in E.values()), 'mismatches', bad)
sys.exit(1 if bad else 0)
