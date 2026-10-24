#!/usr/bin/env python3
"""GS4 texts: the home section of the new record (07 §4.5, an added paragraph after the reach past one's own end), the
study section, and the record's region.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_gs4.py RECEIPT N"""
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT, N = sys.argv[1], int(sys.argv[2])
CH = ROOT / 'theories/becoming/chapters'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


sig = CH / '07-SIGNIFICANCE.md'
edit(sig, """<a id="practical-judgment"></a>
## 5. Practical judgment
""", """<a id="r-reach-through-a-shared-condition"></a>
**Theorem** (root; witnesses). *Two lines that share a condition.* Two family lines and a condition that feeds the next generation of both. Where the members affect the condition, each a condition of its next state (drawing on it is one way; no amounts are modelled), the line under the one from the first family's first member reaches the second family's member two generations on, through the condition (`SharedCondition.affecting_reaches_other`). Under the class "a member or not", which holds both families' members alike and the condition apart, the line reaches no member of the second family (`SharedCondition.affecting_member_outside`): holding both lines together is not enough, the class must hold the condition with them. Where the members only feed from a condition they do not affect, a common cause, the line from the first family's first member, under any relation, reaches no member of the second (`SharedCondition.fed_outside`). No class narrower than the one is shown to reach the other family, and no core is computed; [two family lines that share nothing](01-ROOT.md#r-the-source-texts-test-systems) reach nothing of each other ([record](../results/records/reach-through-a-shared-condition.md)).

**Reading** [AI reading, new]. Held de se along the line under the one, the only class shown to reach, the presupposition of one's continuation reaches the members a condition one affects later feeds, with no step of invariance; which class a center's line runs under is open, and the one is not chosen. Read as a commons, whatever acts on it has, under the one, those it later feeds on its line; whether an actual commons is so is empirical.

<a id="practical-judgment"></a>
## 5. Practical judgment
""")

section = f"""
## {N}. One line reaching another through a shared condition (GS4)

After GS3's two family lines landed, PW ([note](development/pw-step-forward/NOTE.md), §7 item 4) asked whether a class across two lines that share a condition carries each past a member's end so that one line's future reaches the other's, or whether sharing yields no such reach and the future of other lines is what the step still has to do. This item answers the first side at the one only (no class narrower than the one, no member's end and no core is modelled), and the second for a condition the members do not affect. An independent review of the first draft (a separate Claude Opus agent) found the Lean sound and the texts claiming a core, later members and "drawing" that nothing proved; what it changed is at the end.

```text
Result(s): new record reach-through-a-shared-condition.
Delta: (1) two family lines and a condition feeding both; where the members affect it (each a condition of its next
       state), the line under the one from the first family's first member reaches the second family's member two
       generations on, through the condition.
       (2) under "a member or not", which holds both families' members alike and the condition apart, the line
       reaches no member of the second family.
       (3) where the members only feed from a condition they do not affect, under any relation the line reaches no
       member of the second family.
Supplied premises / correspondence: each net supplied; discrete steps and equality on the carrier; affecting read
       as a member being a condition of the shared condition's next state, with no amounts.
Evidence: Becoming.GrammarCases; core receipt {RECEIPT}, every axiom report empty.
Boundary: a class strictly between a member's and the one whose line reaches the other family through the condition,
       with its core; the general form of (2) for any class holding the condition apart from the members; amounts
       and depletion; whether self-concern is held along such a class (the de se question of 07 §4.5).
Output → input: 07 §4.5 (an added paragraph and a labelled reading, after the existing reading); the record; the
       package README rows and root module doc; the-source-texts-test-systems re-pointed to the module's new bytes,
       its declarations unchanged; 01-ROOT §8.7's "a further question" is the question this item answers at the one.
```

**What was built.** In `Becoming.GrammarCases`, namespace `SharedCondition`: `Occ`, `affecting`, `fed`, `living`, `affecting_reaches_other`, `affecting_member_step`, `affecting_member_stays`, `affecting_member_outside`, `fed_step`, `fed_stays`, `fed_outside`. No earlier statement of the module changes.

**What it says.** In the witness, under the one, the first family's first member reaches the second family's member two generations on, through a condition the first family's members affect and that feeds the second; under any relation, a source that no member affects joins none. Under "a member or not", a class across both lines that holds the condition apart, the line stays in the first family: holding both lines together is not enough; the class must hold the condition with them. [AI reading] This is the coupling of 07 §4.3 read forward along 缘: the witness adds the time index, not a new route.

**Constructivity.** No omniscience principle; the receipt's empty axiom report is the evidence.

**The review, and what was taken.** Errors fixed: "later members" (one pair is proved); a core said to carry the line (no core is computed; `drawn_constant` and `drawn_total`, which said only that every occurrence has a successor, were removed); "witnesses for both sides" (the first side only at the one); a Chinese gloss saying the member class does not contain the condition (it holds it apart); the reading's "successors that draw on it" (reached because fed). Renamed: `drawn` to `affecting`, since the model shows affecting a condition, not drawing amounts from it. Narrowed: "joined" (one direction), "a class that leaves the condition out" (one class), the commons reading (labelled, and as acting on, not drawing), and the correspondence with the route through dependence (labelled). The new paragraph and its reading sit after §4.5's existing reading.

**Self-review.** (1) Each sentence was read against its declaration after the review. (2) Not done: the items in Boundary.
"""
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t
STUDY.write_text(t.rstrip('\n') + '\n' + section, encoding='utf-8')

reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert 'reach-through-a-shared-condition' not in reg['records']
reg['records']['reach-through-a-shared-condition'] = {
    'region': 'significance', 'base': 'grammar', 'note': 'GrammarCases: one line reaching another through a condition it affects'}
reg['records'] = dict(sorted(reg['records'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 07 §4.5 paragraph; study section', N, '; region')
