#!/usr/bin/env python3
"""PF2 texts: in 07 §4.6 the home section of the new record (a Theorem block after the first), the P4 bullet sharpened,
and the Open item replaced; the study section; the record's region. Agreed with the IV3 line's owner before it runs.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/round2/texts_pf2.py RECEIPT N"""
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT, N = sys.argv[1], int(sys.argv[2])
CH7 = ROOT / 'theories/becoming/chapters/07-SIGNIFICANCE.md'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
RID = 'what-leaves-a-class-follows-its-line'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


block = f"""<a id="r-{RID}"></a>
**Theorem** (root; any type, and witnesses). *What leaves a class follows its line.* Under a class constant up to the net's end, where a member conditions something not alike to it, every occurrence alike to the member that conditions anything conditions something alike to that effect and outside the class (`«出类随行»`), so every one on its line does (`«出类随线»`); where one such occurrence conditions nothing alike to that effect, the class is not constant up to the net's end (`«出类不随则不至终有常»`, witness `CleanStep`). This is nearly the definition of constancy up to the net's end, read at a member whose effects the class does not hold, and "alike to that effect" is only as fine as the class divides what lies outside it. A class can be constant up to the net's end without holding a member's effects: in a finite net without cycles, a class holding a member and part of what follows it can be constant up to the net's end though not constant, not holding the member's effects, while something outside it follows every step of its line that goes on (`FiniteWake.constant_to_end`, `FiniteWake.not_constant`, `FiniteWake.not_held`, `FiniteWake.wake_follows`) ([record](../results/records/{RID}.md)).

"""
edit(CH7, "**Argument** [AI reading; each step cites its Lean, and the joining of the steps is argued]. Premises:",
     block + "**Argument** [AI reading; each step cites its Lean, and the joining of the steps is argued]. Premises:")
edit(CH7, """so such a partial holding draws its line by the identity in question [AI reading].""",
     """so such a partial holding draws its line by the identity in question [AI reading]. Read as a self drawn by what one intends [AI reading; nothing in the Lean marks an intended effect], a class holding only part of one's effects can still pass P2 (`FiniteWake`), so P2 does not exclude it and P4 carries the crux; such a class, constant up to the net's end, has something outside it follow every alike step that goes on ([above](#r-{RID})). The doctrine of double effect, which lets what is intended, as against only foreseen, bear on what may be done, still weighs a foreseen side effect in its proportionality condition [AI reading].""".replace('{RID}', RID))
edit(CH7, """- **The narrowest holding of one's effects** ([§4.6](#future-path)): whether a class that holds a member's intended effects, and not its other effects, can be constant up to the net's end; if not, the agential self fails P2 as the organism does.""",
     """- **How finely a self's class divides what it leaves out** ([§4.6](#future-path)): constancy up to the net's end constrains every block of a class, the outside included, and asks that what is alike to each effect leaving a block follow every alike step that goes on (`«出类随行»`); so the division of what one leaves out fixes how much P2 asks of the agential self. Which class P2 should read, and whether it should constrain only the self's block, is open.""")

study = f"""
## {N}. Whether a self that owns only its intended effects is a regularity of its own (PF2)

07 §4.6 left open whether a class holding a member's intended effects, and not its other effects, can be constant up to the net's end; PF's first round guessed it could not. PF2 answers it and gives a second round of philosophical work ([study](development/pf-path-and-crux/PHILOSOPHY-ROUND-2.md)). Nothing in the Lean marks an intended effect: the laws concern any class that does not hold all of a member's effects, and the agent reading is the AI's. An independent review of the first build (a separate Claude Opus agent, read-only) found no error in the proofs and twelve problems in the claims, all taken, as listed there.

```text
Result(s): new record {RID}.
Delta: in Becoming.GrammarPath, for every relation and class: under a class constant up to the net's end, where a
       member conditions something not alike to it, every occurrence alike to the member that conditions anything
       conditions something alike to that effect and outside the class («出类随行»), every one on its line in
       particular («出类随线»); where one such occurrence conditions nothing alike to it, the class is not constant up
       to the net's end («出类不随则不至终有常», witness CleanStep); a finite acyclic class constant up to the net's
       end, not constant, not holding the member's effects (FiniteWake).
Supplied premises / correspondence: the witnesses' nets supplied, discrete steps and equality on the carriers; the
       reading of a class as drawn by intention.
Evidence: Becoming.GrammarPath; core receipt {RECEIPT}, every axiom report empty.
Boundary: the laws are nearly the definition read at a member whose effects the class does not hold, and "alike to
       that effect" is only as fine as the class; how finely P2's class should divide what a self leaves out; whether
       intention fixes scope (P4).
Output → input: 07 §4.6 (the home section; the P4 bullet: P2 does not exclude the agential self, so P4 carries the
       crux) and its Open item, as agreed with the IV3 line's owner (REVIEW-PF2.md: the witness sentence as "can be", "holding a
       member's effects" for "close", the intention reading labelled where FiniteWake is cited, the Open item on how finely
       a self's class divides what it leaves out); the record; the package README rows and root module doc.
```

**What it says.** Round 1 had the direction wrong. A self drawn by intention can be constant up to the net's end, and then it is never clean: something it leaves out follows every alike step that goes on. Ending excludes the organism, not the agential self, so the crux is P4, whether the class of one's line holds one's effects. The tradition built on intention, double effect, weighs the foreseen side effect in its proportionality condition.

**Constructivity.** No omniscience principle; the receipt's empty axiom report is the evidence.

**Self-review.** (1) Each sentence of 07 §4.6's new block and bullet was read against its declaration after the review. (2) Not done: the items in Boundary.
"""
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t
STUDY.write_text(t.rstrip('\n') + '\n' + study, encoding='utf-8')
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records']
reg['records'][RID] = {'region': 'significance', 'base': 'grammar',
                       'note': 'GrammarPath: under constancy up to the net\'s end, what leaves the class follows each alike step'}
reg['records'] = dict(sorted(reg['records'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 07 §4.6 block, P4 bullet and Open item; study section', N, '; region')
