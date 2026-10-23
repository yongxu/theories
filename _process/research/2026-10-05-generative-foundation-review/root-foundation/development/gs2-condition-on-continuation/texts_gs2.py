#!/usr/bin/env python3
"""GS2 texts: the home sections of the two new records (07 §4.5, a new subsection with both), the
Open items of 07 and 01-ROOT that GS2 meets, the study section, and the regions of the new records and module.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_gs2.py RECEIPT N"""
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT, N = sys.argv[1], int(sys.argv[2])
CH = ROOT / 'theories/becoming/chapters'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
LEAN = '../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


sig = CH / '07-SIGNIFICANCE.md'

# --- 07 §4.5: the condition on the root, a new subsection at the end of §4
edit(sig, """<a id="practical-judgment"></a>
## 5. Practical judgment
""", f"""<a id="condition-on-the-root"></a>
### 4.5 The condition on the root

The root reads every subject as [continuation relative to a class](01-ROOT.md#r-continuation-relative-to-a-class): an occurrence continues another where it is conditioned by it and alike to it under a class, and a line's regularity is its class's [core](01-ROOT.md#constancy-and-core).

<a id="r-the-continuation-condition-on-the-root"></a>
**Theorem** (root; any type) **and Conditional** (the root's condition at the one, the own-closure reading). Given a net `R`, a class `E` and each standpoint's center, the condition *along the net* is that every occurrence is reached on every center's line under `E` (`«续无外»`), and *in families* that every occurrence lies in every center's family under `E` (`«族无外»`). The first gives the second (`«续无外则族无外»`), and either at a class gives it at every coarser class (`«续无外之粗化»`, `«族无外之粗化»`). Lying within a closure along a relation is being reached on a line under the one of that relation (`withinClosure_iff_reached`). So the condition held de se along a relation, `Unrestricted (selfAscribed (ownClosure rel) center)` ([§4.2](#r-what-the-step-across-standpoints-reaches)), is exactly the root's condition at the one of that relation taken as the net (`ownClosure_unrestricted_iff_noOutside`). Each theorem of this chapter taking the condition as a hypothesis instantiates at that significance; one instance is proved: on every reading where a claim's significance from a standpoint is that its formation lies within that standpoint's center's closure, living significance follows, with S0 at every standpoint, both neutralities and, wherever something lives and there is a standpoint, a seed (`premises_of_noOutside`) ([`Becoming.GrammarScope`]({LEAN}/GrammarScope.lean); [record](../results/records/the-continuation-condition-on-the-root.md)). Read so, the condition has no significance parameter: it is true or false once the net, the class and the centers are given. Along a net with no cycle it holds only with one center, which nothing conditions (`«续无外则同一中心»`, `«续无外则中心无缘»`); in families at the one it asks only that the net be joined. The relations a self is drawn along in §4.1–4.3 (feeding, influence) run from what is fed or affected to what feeds or affects it, the converse of 缘, so read along them "ahead" runs to conditions, not into the future. The free significance of §1 is not lifted onto the root.

<a id="r-reach-past-ones-own-end"></a>
**Theorem** (root; witnesses). On a line under a class `L` from a center, what continues under `L` an occurrence at which the line under a relation `O` ends is reached on the line under `L`, and lies on no line under `O` from that occurrence (`«过亡而续»`); the case read is a class `O` finer than `L`, such as an organism's. The core of a class, fixed by the net once the class is given, continues something exactly where some line under it goes on without end (`«核有续当且仅当有不穷»`, by GS1's [`«守理则不穷»`](01-ROOT.md#r-a-regularity-kept-and-changed)), so where no line under the core goes on without end, the core continues nothing (`«无不穷则核无续»`). Two lines of descent, each with the one as its class of descent, show both. In endless descent, each member young, then old, then the parent of the next, every occurrence conditions a successor, so the one is constant, its core is the whole and continues through each birth while the member's line ends at old age (`LineOfDescent.Endless.core_through_birth`); with the first birth as the only center the condition holds under the one, and under the member's class it fails (`LineOfDescent.Endless.descent_no_outside`, `LineOfDescent.Endless.member_outside`). In descent that ends, two members with the second childless, no line under any relation goes on without end, so no class's core continues anything, while the one reaches the second member past the first's end (`LineOfDescent.Last.core_no_continuation`, `LineOfDescent.Last.descent_past_end`). Neither model has a class narrower than the one and wider than the member's ([record](../results/records/reach-past-ones-own-end.md)).

**Reading** [AI reading, new]. Held de se of a line under a coarser class than one's organism, the presupposition of one's own continuation reaches successors past one's own end with no step of invariance; so the case against the step, held de se, becomes in part a question of classes: under an organism's class nothing of the self follows its end, under a coarser one the line can go on through new members. Where no line under a class's core goes on without end, a step past one's end continues under the class and not under its core; whether such a class is thereby chosen is not shown, and the one is not chosen. What the represented dynamics leave open, held de se, is which class a center's own line runs under, which occurrences are centers, and, for what lies on no center's line, the step or a reading of one's own as one's family under the class (`«族无外»`); which holds is not shown.

<a id="practical-judgment"></a>
## 5. Practical judgment
""")

# --- 07 Open: the de se question and the condition on the root, merged
edit(sig, """- **The de se question** ([§4.2](#step)).
""", """- **The de se question** ([§4.2](#step)), asked on the root of classes: which class a center's own line runs under, and whether a core that goes on without end carries it past a member's end ([§4.5](#r-reach-past-ones-own-end)).
""")
edit(sig, """- **The condition on the root's grammar**: the continuation condition is stated on the significance formalism (standpoints, steps, formations), not on the [root's](01-ROOT.md) continuation (续); until `Unrestricted` is lifted onto the grammar, the root and the ethics are not one account.
""", """- **The condition on the root's grammar, beyond one instance**: held de se along a relation the condition is the [root's](#r-the-continuation-condition-on-the-root) at the one of that relation; the free significance of §1 is not lifted, and the chapter's other laws are instances not yet stated on the root.
""")

# --- 01-ROOT Open: the root and the ethics
root = CH / '01-ROOT.md'
edit(root, """- **The root and the ethics.** The continuation condition is stated on the significance formalism, not on 续, so the root and the ethics are not yet one account.
""", """- **The root and the ethics.** Held de se along a relation, the continuation condition is the root's at the one of that relation ([07](07-SIGNIFICANCE.md#r-the-continuation-condition-on-the-root)); along a net with no cycle it holds only with one center. The free significance of 07 §1 is not lifted, and the ethics' other laws are instances not yet stated on the root; which class a center's own line runs under ([07](07-SIGNIFICANCE.md#r-reach-past-ones-own-end)), and the warrant of the condition and of C, are open.
""")

section = f"""
## {N}. The continuation condition on the root, and the reach past one's own end (GS2)

The review of the root against its two source texts ([note](development/one-unfolding-root/reviews/2026-10-23-sources-against-v10.md), §4) found the continuation condition stated on the significance formalism, not on 续, so that the root and the ethics were not one account. Two handovers shaped the design. SW ([note](development/sw-significance-without-a-value-layer/NOTE.md), proposal 3), after [Ren's remark](../../../../sources/15-codex-theory-conversations/2026-10-24-significance-a-dualist-word.md) that significance was a dualist word, proposed stating the condition as inclusion in what a line under a class continues with, with no separate significance formalism. PW ([note](development/pw-step-forward/NOTE.md), §7 item 3) proposed the reach past one's own end with two witnesses of descent. Both are taken. An independent review of the first texts (a separate Claude Opus agent reading the Lean and every text) found the Lean sound and the texts overstated; what it changed is at the end.

```text
Result(s): new records the-continuation-condition-on-the-root and reach-past-ones-own-end;
       what-the-step-across-standpoints-reaches gains a related entry.
Delta: (1) the condition on the root: given a net R, a class E and the standpoints' centers, every occurrence on
       every center's line under E («续无外») or in every center's family («族无外»); the first gives the second;
       either at a class gives it at every coarser class.
       (2) held de se: lying within a closure along a relation is being reached on a line under the one of it
       (withinClosure_iff_reached), so Unrestricted (selfAscribed (ownClosure rel) center) is exactly
       «续无外» rel «一» center (ownClosure_unrestricted_iff_noOutside); one instance of the chapter's theorems,
       living significance on the own-closure reading of claims (premises_of_noOutside).
       (3) along a net with no cycle the condition holds only with one center («续无外则同一中心»), which nothing
       conditions («续无外则中心无缘»).
       (4) past one's own end («过亡而续»); the core continues something exactly where some line under it goes on
       without end («核有续当且仅当有不穷»), so with no such line it continues nothing («无不穷则核无续»).
       (5) two lines of descent with the one as the class of descent: endless (the core continuing through each
       birth, the member's line ending; the condition holding under the one with the first birth as the only
       center, failing under the member's class) and ending (no class's core continuing anything, the one reaching
       the second member past the first's end).
Supplied premises / correspondence: SW §3's reading (what counts for a center is what lies within its continuing
       along a relation), with the relation taken as the net; for living significance, the reading of claims
       through the own closure; the models commit to discrete steps and equality on their carriers.
Evidence: Becoming.GrammarScope; core receipt {RECEIPT}, every axiom report empty.
Boundary: the free significance of chapter 7 §1 is not lifted, and the chapter's other laws are instances not yet
       stated on the root; which class a center's own line runs under, and which occurrences are centers, are
       not settled; neither model has a class between the member's and the one; that any actual lineage is
       endless is not shown; C is untouched.
Output → input: 07 §4.5 (new) and its Open items; 01-ROOT's Open item; regions; the package README row (EN, ZH);
       the root module's doc. The thesis line of 07 and the front pages are their owners' (SW's owner and NR's
       owner, told).
```

**What was built.** `Becoming.GrammarScope`, a leaf: `«续无外»`, `«族无外»`, `«相续则同族»`, `«所及则同族»`, `«续无外则族无外»`, `«同族之粗化»`, `«续无外之粗化»`, `«族无外之粗化»`, `«过亡而续»`, `«核有续当且仅当有不穷»`, `«无不穷则核无续»`, `«续无外则同一中心»`, `«续无外则中心无缘»`; `withinClosure_of_line`, `withinClosure_iff_reached`, `ownClosure_unrestricted_iff_noOutside`, `premises_of_noOutside`; `LineOfDescent.Endless` (`Occ`, `step`, `member`, `member_class`, `total`, `member_ends`, `descent_constant`, `core_through_birth`, `descent_unending`, `descent_reaches_both`, `descent_reaches`, `descent_no_outside`, `member_line`, `member_outside`) and `LineOfDescent.Last` (`Occ`, `step`, `last_ends`, `never_unending`, `core_no_continuation`, `descent_past_end`). No definition of an earlier module changes.

**Why no value parameter.** A first draft put a significance on the root, `Pos → «际» α → α → Prop`, with the condition over every class and a non-entailment copied from the free one. SW's argument holds against it: such a parameter is fixed by nothing else in the representation, by construction. Read de se, what counts for a center is what lies within its continuing; on the root that is what its line reaches. The draft was built in scratch and never landed.

**What the root adds.** Two findings that the free formalism hid. First, along a net with no cycle the condition can hold only with one center that nothing conditions: two centers each reached from the other would lie on a cycle. So for many standpoints, read along 缘, the condition fails, and what remains is the family reading, which asks only that the net be joined. Second, the relations chapter 7 draws a self along (feeding, influence) run toward conditions, the converse of 缘; read along them the own closure reaches what one depends on, not what follows one (as PW §2–3 argues of need). The future of one's own line is reached along 缘, past one's end, under a coarser class (`«过亡而续»`), and the core carries that line only where its line goes on without end (`«核有续当且仅当有不穷»`). Whether a living line's core is wider than its organism is made exact here, not answered: both sides are witnessed, each with the one as its class of descent.

**Constructivity.** No omniscience principle is used. `LineOfDescent.Last.never_unending` follows each occurrence's only successors to the last. A first build used `Nat.succ_ne_zero`, whose proof reports `propext`; it was replaced by `Nat.noConfusion`.

**The review, and what was taken.** Errors fixed: living significance stated without its reading of claims (now stated, and called one instance); a claim that the condition has no slot the net does not read (the class and the centers are supplied); two wrong docstrings in the witnesses and one on the wrong declaration; a record law that made the member's line go on for good; the condition asserted in the root module's bullet. Lean changed: `«诸线皆尽则核无续»`, whose hypothesis was equivalent to its conclusion and whose name used 尽 in a sense the grammar defines otherwise, became the exact `«核有续当且仅当有不穷»` with the corollary `«无不穷则核无续»`; `«续无外则同一中心»` and `«续无外则中心无缘»` added. Readings labelled and narrowed: that the dynamics fix a class only through its core, that what lies on no line of one's own is reached only by the step, that a feeding closure reaches ahead, and that PW §5 is answered. The text moved from §3 to a new §4.5, after the de se readings it uses.

**Self-review.** (1) Each sentence of §4.5 was read against its declaration after the review. (2) The Open bullet on the de se question now carries the question of classes; the bullet on the condition on the root says what remains beyond the one instance. (3) Not done: the items in Boundary.
"""
text = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in text
STUDY.write_text(text.rstrip('\n') + '\n' + section, encoding='utf-8')

reg = json.loads(REGIONS.read_text(encoding='utf-8'))
for rid, note in (
        ('the-continuation-condition-on-the-root', 'GrammarScope: nothing outside a center\'s continuing; the World\'s condition at the one'),
        ('reach-past-ones-own-end', 'GrammarScope: reach past a finer line\'s end; core of descent, endless and ending')):
    assert rid not in reg['records']
    reg['records'][rid] = {'region': 'significance', 'base': 'grammar', 'note': note}
assert 'Becoming.GrammarScope' not in reg['modules']
reg['modules']['Becoming.GrammarScope'] = {'region': 'significance', 'base': 'grammar',
                                           'note': 'the continuation condition on the root, structurally (GS2)'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 07 §4.5, Open; 01-ROOT Open; study section', N, '; regions')
