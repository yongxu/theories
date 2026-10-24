#!/usr/bin/env python3
"""GS5 texts: the home section of the new record (07 §4.5, an added paragraph and a labelled reading at the end of the
subsection), the study section, and the record's region.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_gs5.py RECEIPT N"""
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


edit(CH / '07-SIGNIFICANCE.md', """<a id="practical-judgment"></a>
## 5. Practical judgment
""", """<a id="r-the-class-of-being-joined"></a>
**Theorem** (root; any type, and witnesses). *The class of being joined.* The class of being joined by 缘 read either way, the family under the one (`«同族» R «一»`), is defined from the net alone. Under it continuation is 缘 itself (`«族之续即缘»`), so its lines reach exactly what the one's reach (`«族之所及即一之所及»`), and it is the finest class under which every condition is a continuation: a class has 缘 as its continuation exactly where it contains this one (`«续即缘当且仅当含族»`). Where every occurrence conditions something it is constant (`«遍有后则族有常»`), so its core holds both ends of every condition, every step of 缘 being a step under the core (`«遍有后则缘在族核»`), and a line under the core reaches what the one's reaches (`«遍有后则核之所及即一之所及»`). Three witnesses add a third thing to the shared-condition witness above. Joined to nothing, conditioning nothing and conditioned by nothing but its own earlier stage, it lies outside the class of being joined, which is then narrower than the one and still reaches the second family (`ThirdThing.fixed_class`, `ThirdThing.fixed_class_reaches`). Affecting the shared condition, it makes the class of being joined the one, while the constant class "the third thing or not" leaves it out and still reaches the second family (`ThirdAffects.finer_class_reaches`). Fed by the shared condition, it is taken in by every constant class holding a stage of the condition with a member (`ThirdFed.constant_takes_third`). In the shared-condition witness above, whose net is joined, the class of being joined is the one ([record](../results/records/the-class-of-being-joined.md)).

**Reading** [AI reading, new]. In the results above stated through continuation under the one (what a line reaches, where it ends, the condition along the net), the one can be replaced by the class of being joined with nothing changed: continuation under the two is the same relation. Held de se along a line under it, the presupposition of one's continuation reaches exactly what a line under the one reaches: what one conditions and what that conditions in turn, the conditions one affects and those they later feed among it; not what only conditions one, and nothing no chain joins; with no step of invariance. Keeping every condition fixes nothing beyond the net: the finest class under which every condition is a continuation is the class of being joined, and every class containing it reaches the same; but a finer constant class can reach the same too, as where a third thing affects the shared condition, and constancy, unlike being joined, reads which way a thing is joined. Whether one's own line runs under such a class or a finer one, an organism's, is the de se question. Where the net is joined the class of being joined is the one; that the actual unfolding is joined in this sense is a correspondence, not shown, and on it the class gives nothing narrower than the one.

<a id="practical-judgment"></a>
## 5. Practical judgment
""")

section = f"""
## {N}. The class of being joined (GS5)

PW ([note](development/pw-step-forward/NOTE.md), §7 item 5) asked, after GS4, whether a class narrower than the one holds the living together with the conditions they affect and are fed by, constant, with a core that carries each line on, and proposed testing it with a third thing that neither family affects nor is fed by. The answer has a general part and a part that turns on how the third thing is joined. An independent review of the first draft (a separate Claude Opus agent) found the Lean sound, the name "the class the net fixes" and the reading overclaiming, and the witness only the degenerate case; it changed the item, as listed at the end.

```text
Result(s): new record the-class-of-being-joined; the-continuation-condition-on-the-root, reach-past-ones-own-end,
       the-source-texts-test-systems and reach-through-a-shared-condition re-pointed to their modules' new bytes,
       their declarations unchanged.
Delta: (1) in Becoming.GrammarScope, for every carrier and relation: every condition joins its ends in one family
       under the one («缘在族中»); under that family class, the class of being joined, continuation is 缘
       («族之续即缘»), and its lines reach what the one's reach («族之所及即一之所及»); a class has 缘 as its
       continuation exactly where it contains the class of being joined («续即缘当且仅当含族»); where every
       occurrence conditions something, it is constant («遍有后则族有常»), its core holds both ends of every
       condition («遍有后则缘在族核») and a line under the core reaches what the one's reaches
       («遍有后则核之所及即一之所及»).
       (2) in Becoming.GrammarCases, three witnesses on GS4's two families and their shared condition with a third
       thing: joined to nothing, outside the class of being joined, which is narrower than the one and reaches the
       second family (ThirdThing); affecting the shared condition, the class of being joined is the one while the
       constant class "the third thing or not" leaves it out and reaches the second family (ThirdAffects); fed by
       the shared condition, taken in by every constant class holding a stage of the condition with a member
       (ThirdFed).
Supplied premises / correspondence: (1) for constancy and the core, every occurrence conditions something; for the
       witnesses, the nets supplied, discrete steps and equality on the carriers.
Evidence: Becoming.GrammarScope and Becoming.GrammarCases; core receipt {RECEIPT}, every axiom report empty.
Boundary: whether a center's own line runs under the class of being joined, a finer constant class, or a finer one
       still (the de se question); constancy where some occurrence conditions nothing; that the actual unfolding is
       joined.
Output → input: 07 §4.5 (an added paragraph and a labelled reading at its end); the record; the package README rows
       and root module doc; four records re-pointed.
```

**What was built.** In `Becoming.GrammarScope`: `«缘在族中»`, `«族之续即缘»`, `«族之所及即一之所及»`, `«续即缘当且仅当含族»`, `«遍有后则族有常»`, `«遍有后则缘在族核»`, `«遍有后则核之所及即一之所及»`. In `Becoming.GrammarCases`: `ThirdThing` (`Occ`, `step`, `third`, `total`, `step_keeps_third`, `family_keeps_third`, `fixed_class`, `fixed_class_reaches`), `ThirdAffects` (`Occ`, `step`, `third`, `third_class`, `rest_to_rest`, `succ_of_kind`, `third_constant`, `condition_joined`, `joined_to_start`, `finer_class_reaches`) and `ThirdFed` (`Occ`, `step`, `constant_takes_third`). No earlier statement changes.

**What it says of PW's question.** The class of being joined holds the living with the conditions they affect and are fed by, and with everything joined to these by any chain of 缘; it is narrower than the one only where the net has parts no chain joins, and it does not separate life with its conditions from anything else joined to them. So PW's question turns on which way the third thing is joined, and the three witnesses give the cases. Joined to nothing, it is left out by the class of being joined. Affecting the shared condition, it is left out by a finer constant class, "the third thing or not", which still reaches the other family: so the class that reaches is not unique, and a constant class narrower than the class of being joined can single out the living with their conditions. Fed by the shared condition, it is taken in by every constant class holding a member with the condition. Constancy reads the direction of joining; being joined does not. The one in GS2 and GS4 is not arbitrary in what it reaches: it reaches what every class keeping every condition reaches, and in their nets, which are joined, it is the finest such class.

**Constructivity.** No omniscience principle; the receipt's empty axiom report is the evidence.

**The review, and what was taken.** Renamed: "the class the net fixes" to "the class of being joined", since the net also fixes the one, identity and every core, and what singles this class out is `«续即缘当且仅当含族»`. Errors fixed: the reading's "reaches what conditioning joins one to" (a line runs forward; it reaches what a line under the one reaches); "the class that reaches is not a choice" (a finer constant class reaches the same where the third thing affects the condition, now proved); the correspondence "holds the living with the conditions" (it holds whatever any chain joins). Lean added: `«遍有后则核之所及即一之所及»` for "a line under the core reaches what the one's reaches", and the witnesses `ThirdAffects` and `ThirdFed`, which the review found by hand. Narrowed: "a third thing that shares no condition" (joined to nothing); what `fixed_class` proves (three pairs and a narrower class); the replaceability of the one (for results through continuation, not about its own constancy); "where the net is joined, as one unfolding is" (a correspondence, not shown).

**Self-review.** (1) Each sentence of the paragraph was read against its declaration after the review. (2) Not done: the items in Boundary.
"""
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t
STUDY.write_text(t.rstrip('\n') + '\n' + section, encoding='utf-8')

reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert 'the-class-of-being-joined' not in reg['records']
reg['records']['the-class-of-being-joined'] = {'region': 'significance', 'base': 'grammar',
                                               'note': 'GrammarScope: the class of being joined, finest with 缘 as continuation'}
reg['records'] = dict(sorted(reg['records'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 07 §4.5 paragraph and reading; study section', N, '; region')
