#!/usr/bin/env python3
"""rows_en <tree>: glossary rows that state their basis, 08 section 1's four questions, 08 section 10's note on "reads"."""
import sys
tree = sys.argv[1]
NOTE = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/dw-dualist-wording/NOTE.md'
def after_row(path, start, rows):
    p = f'{tree}/{path}'; L = open(p, encoding='utf-8').read().split('\n')
    idx = [i for i, l in enumerate(L) if l.startswith(start)]; assert len(idx) == 1, (path, start, len(idx))
    L[idx[0] + 1:idx[0] + 1] = rows
    with open(p, 'w', encoding='utf-8') as f: f.write('\n'.join(L))
G = 'GLOSSARY.md'
after_row(G, '| boundary (边界', [
 '| <a id="beyond"></a>beyond, outside, within | the complement of a named set along a named relation (not in this family; not within this closure), or membership in it. It moves with the set, and nothing lies beyond the whole. Said bare ("the beyond", "what lies beyond") it reads as a place; new text names the set or says the relation: what makes no difference to a selection, what does not couple into it | [01 §9.9](theories/becoming/chapters/01-ROOT.md#boundaries), [the study](' + NOTE + ') |',
 '| <a id="own"></a>own, its own | three uses, kept apart: an index (which formation a level or a course is listed under); a return (a rule set again from the share that rose under it, a loop and not a self acting on itself); an extent (a centre\'s closure along a relation under a class, where which relation and which class is given and not derived) | [07 §1](theories/becoming/chapters/07-SIGNIFICANCE.md#evaluation), [the study](' + NOTE + ') |'])
after_row(G, '| lock |', [
 '| <a id="rule"></a>rule | how a selection selects at a step: in the lock\'s models one coordinate of the configuration, set again at some steps from the share. Share and rule are two ends of one loop at two paces; the rule is not a thing standing over what it selects | [02 §9](theories/becoming/chapters/02-MAP.md#capture), [02 §11](theories/becoming/chapters/02-MAP.md#turning-in-time) |',
 '| <a id="loss"></a>loss | in the lock\'s theorems a coordinate that rises each step and makes no difference to the share or the rule; whose loss it is, and by which comparison, is what significance leaves free. With a region named, it is what a formation outside the region can no longer go on through | [02 §9](theories/becoming/chapters/02-MAP.md#capture), [07 §2](theories/becoming/chapters/07-SIGNIFICANCE.md#r-loss-beyond-a-region) |'])
after_row(G, '| couples into |', [
 '| <a id="makes-a-difference"></a>makes a difference to; sustains | the centre\'s two relations, kept apart. A difference *makes a difference to* a selection where courses that differ in it can be selected differently: it couples into the selection. What *sustains* a selection is what its going on needs. Whether that need is met always makes a difference; how much is left above the need can make none, and the centre is that case | [03 §1](theories/becoming/chapters/03-KNOWING.md#selection), [02 §11](theories/becoming/chapters/02-MAP.md#turning-in-time) |',
 '| <a id="read"></a>read, reads, reading | one word for several relations, each of which has a word of its own in the Lean: what a step gives *depends only on* a named part (`DependsOnlyOn`, `GoAlike`); a verdict on a whole course is the same on courses *alike through* what couples in (`AlikeThroughUpTo`, `SelectsThrough`); one level *couples into* another\'s exchange (`CouplesAt`, `Sensitive`); the rule *after* a step, as a function of the share ("the rule read", "the reading": `after`); a schedule of the steps at which the rule is set again; a label a line carries, which picks its law and passes down the line; and the account\'s own interpreting ("read as", "[AI reading]"), the one sense in which someone reads. No formation faces what it is said to read. Text written since 13 November 2026 says the relation; the word stays in names and in passages not yet said again | [the study](' + NOTE + '), [08 §1](theories/becoming/chapters/08-METHOD.md#four-questions) |'])
after_row(G, '| hypotheses |', [
 '| <a id="supplied"></a>supplied, given | of a premise: taken by a theorem and not derived in its model (a class, a centre, an order, a significance, a listing). Whoever writes the model puts it in, and that writing is itself within the unfolding; "given from outside" says outside the model, never outside becoming | [08 §1](theories/becoming/chapters/08-METHOD.md#beginning-within-the-one-unfolding) |'])
p = f'{tree}/theories/becoming/chapters/08-METHOD.md'; s = open(p, encoding='utf-8').read()
a = '\n\n**An objection is answered on what it says.**'; assert s.count(a) == 1
q = ('\n\n<a id="four-questions"></a>\n**Four questions for a sentence or a picture.** Is the respect said, in which things are alike or differ? Is a pair said as one relation with two ends? Is separateness shown, not assumed? Is "better" said with what it is compared to? '
     'They test a sentence, not its words. A word that fails in one sentence states a relation with its basis in another, and a word struck out comes back as another with the same grammar: "registers" came back as "reads", "beyond" as "outside". '
     'So a sentence that fails is said again from what its theorem states, and no list of words is kept ([the study](../../../' + NOTE + '), AI-written, on [Ren\'s words of 13 November 2026](../../../sources/15-codex-theory-conversations/2026-11-13-what-a-law-is-and-the-words.md)).')
s = s.replace(a, q + a)
a = '"Couples into" replaced "registers", which presupposes a knower facing a world.'; assert s.count(a) == 1
s = s.replace(a, a + ' "Reads" presupposes the same, and in the Lean it stands for about fifteen relations, most with a word of their own; text written since 13 November 2026 says the relation, and the word stays in names and in passages not yet said again ([the glossary](../../../GLOSSARY.md#read), [the four questions](#four-questions)).')
with open(p, 'w', encoding='utf-8') as f: f.write(s)
print('rows and 08 edits written')
