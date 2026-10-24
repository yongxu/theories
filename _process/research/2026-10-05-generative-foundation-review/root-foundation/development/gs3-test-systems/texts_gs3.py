#!/usr/bin/env python3
"""GS3 texts: the home section of the new record (01-ROOT, a new §8.7), the Open item on test systems restated, the
study section, and the regions of the new record and module.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_gs3.py RECEIPT N"""
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


root = CH / '01-ROOT.md'
edit(root, """<a id="laws-on-every-model"></a>
## 9. Laws on every model, each with its hypotheses
""", f"""<a id="test-systems"></a>
### 8.7 Test systems of the source texts

The two texts the root was built from proposed test systems a grammar of becoming must express ([the first text, §7](../../../sources/15-codex-theory-conversations/2026-10-23-continuity-as-root/minimum-grammar-of-becoming.md)). Small witnesses are given for two of them as stated, decay and a system with no clear boundary, and for two narrower stand-ins; in each, the behaviour in question is supplied in its net. The flame is §5's.

<a id="r-the-source-texts-test-systems"></a>
**Theorem** (root; witnesses). *Five small witnesses.*

- *Decay.* A nucleus intact or decayed, step by step. The decay is an alteration: the nucleus continues under the one while "intact or not" tells the two ends apart (`Decay.decay_alters`), in a net where no occurrence reaches itself (`Decay.possible_acyclic`); the steps only rise (`Decay.reach_rises`), so the absence of a cycle lies in the indexing, and that the nucleus has no inner interaction is an omission of the model. In the net of possibilities, where an intact nucleus may stay intact or decay at every step (`Decay.both_open`, the net's definition), "intact or not" is constant (`Decay.possible_constant`), and every two intact moments, at any two steps, are alike in its core (`Decay.time_not_in_core`): the step is not in the regularity of "intact or not", memorylessness without probabilities. A history within that net (`Decay.history_within`) that decays at its second step has the time left before the decay in that core: its two intact moments lie apart (`Decay.history_apart`), as the flame's time left does (§5). Which net a model declares decides this; which an actual decay is, the model does not say.
- *No clear boundary.* Three occurrences `a → b → c` and two identities, one holding `a` with `b`, the other `b` with `c`, each a class (`Overlap.continues_each`); `b` ends under the first and begins under the second (`Overlap.b_positions`). Their union is not a class: it relates `a` to `b` and `b` to `c` but not `a` to `c`, and its line from `a` reaches `c` with its ends apart (`Overlap.tolerance_line_apart`), where under a class a line's ends are alike (`«线内同类»`); the class the union generates holds all three and keeps neither identity. Overlapping identities are several classes, observer-dependence is the choice of class, and a vague boundary appears only as a relation that is not a class, whose line drifts out of it.
- *A line of descent generates at two grains.* On the endless line of descent of [07](07-SIGNIFICANCE.md#r-reach-past-ones-own-end), the line under the one never ends and ahead of every point a member begins (`LineOfDescent.Endless.generates`). This is not an organism that renews its parts and dies, which lies in `«新而有终»` ([02](02-MAP.md#r-generation-and-degeneration-at-two-grains)), and no self-maintenance or regulation is modelled.
- *Two family lines.* Two lines of descent with no condition between them, and the class of one family line, strictly between a member's class and the one (`TwoLines.between`). The family line is constant (`TwoLines.family_constant`), so its core goes on through each birth while the member's line ends (`TwoLines.core_through_birth`); and from one family's first birth, even under the one, no member of the other family is reached (`TwoLines.other_line_outside`). So reaching one's successors along 缘 is not reaching everything, and a class narrower than the one can have a core that carries a line past a member's end ([07](07-SIGNIFICANCE.md#r-reach-past-ones-own-end)). The families here share no condition; where they do, the class and its core are a further question.
- *A belief whose rate of spread grows with its number.* The number holding a belief goes up by the rate, and the rate by the number, by supplied laws, a process [changing its own rule](02-MAP.md#r-rules-that-change-themselves-in-the-grammar). On the step the rate changes with the number (`Belief.rate_changes_on_step`), and one holder at rates `0` and `1` lie apart in the core of "same number" (`Belief.rate_read_in_regularity`, an instance of `adaptive_core_apart`). The laws of spread and of the rate's change are fixed, and nothing here is specific to belief; [closed capture](02-MAP.md#r-closed-capture) is the nearer model of a selection changing its own rule.

What the witnesses do not show: that any actual nucleus, lineage or belief is so; probabilities of decay, which are the periphery's ([`Becoming.GrammarCases`]({LEAN}/GrammarCases.lean); [record](../results/records/the-source-texts-test-systems.md)).

**Reading** [AI reading, new]. An institution kept by its members' consent and one held by penalties, the source's pair of observationally equivalent mechanisms, are [the thermostat witness](03-KNOWING.md#r-testing-within-the-net) read socially: in one core class of "in being or not" while the penalties stand, told apart once their removal is in the net. That is the witness's net with its occurrences renamed, not a new law; the warning that interventions can fail to identify mechanisms is not touched.

<a id="laws-on-every-model"></a>
## 9. Laws on every model, each with its hypotheses
""")
edit(root, """- **Test systems.** Decay, a vortex, an organism, an institution, a belief system and a system with no clear boundary have no model; only toy witnesses exist.
""", """- **Test systems.** Small witnesses, the behaviour in question supplied in each net ([§8.7](#r-the-source-texts-test-systems)): decay, overlapping identities, a line of descent generating at two grains, two family lines whose class has a core going on through births, a belief whose rate grows with its number; an institution kept by consent or by penalty is the thermostat witness read socially. Open: a vortex; an institution's identity through replaced people, rules and purposes; self-maintenance and adaptive regulation, and an organism that ends; a belief system whose content or law of spread changes; a graded boundary; decay with its probabilities; models read off actual data.
""")

section = f"""
## {N}. Test systems of the source texts as small witnesses (GS3)

The review of the root against its two source texts ([note](development/one-unfolding-root/reviews/2026-10-23-sources-against-v10.md), §4 and §6) found the texts' test systems without models. This item gives small witnesses for two of them as stated, decay and a system with no clear boundary, and for two narrower stand-ins, a line of descent and a belief whose rate grows with its number; an institution kept by consent or by penalty is read, not restated. An independent review of the first draft (a separate Claude Opus agent) found the Lean sound and the texts and two model names overstated; what it changed is at the end.

```text
Result(s): new record the-source-texts-test-systems.
Delta: (1) decay: the decay an alteration in a net with no cycle (the steps rise); in the net of possibilities,
       both stay and decay open at every intact moment, "intact or not" constant and every two intact moments alike
       in its core; a history within that net, decaying at its second step, with its two intact moments apart.
       (2) no clear boundary: two overlapping identities, each a class; an occurrence ending under one and
       beginning under the other; their union not a class, its line from the first occurrence reaching the third
       with its ends apart.
       (3) a line of descent generating at two grains (on GS2's endless line of descent).
       (3a) two family lines: the class of one family line strictly between a member's and the one, constant, its
       core going on through each birth while the member's line ends; from one family's first birth no member of
       the other family reached, even under the one.
       (4) a belief whose rate of spread grows with its number: on the step the rate changes with the number, and
       one holder at two rates lie apart in the core of same number.
Supplied premises / correspondence: each net is supplied with the behaviour in question; discrete steps, equality
       on the carriers, natural-number counts and linear laws for the belief.
Evidence: Becoming.GrammarCases; core receipt {RECEIPT}, every axiom report empty.
Boundary: a vortex; an institution's identity through replaced people, rules and purposes; self-maintenance and
       adaptive regulation, and an organism that ends; a belief system whose content or law of spread changes; a
       graded boundary; decay with its probabilities; models read off actual data.
Output → input: 01-ROOT §8.7 (new) and its Open item on test systems; regions; the package README row (EN, ZH);
       the root module's doc.
```

**What was built.** `Becoming.GrammarCases`, a leaf of witnesses: `Decay` (`Occ`, `possible`, `intactAlike`, `intactAlike_class`, `reach_rises`, `possible_acyclic`, `both_open`, `decay_alters`, `possible_constant`, `time_not_in_core`, `history`, `history_within`, `history_apart`); `Overlap` (`Occ`, `step`, `first`, `second`, `continues_each`, `b_positions`, `either`, `tolerance_line_apart`); `LineOfDescent.Endless.generates`; `TwoLines` (`Occ`, `step`, `member`, `family`, `family_class`, `between`, `total`, `family_constant`, `core_through_birth`, `line_in_family`, `other_line_outside`); `Belief` (`spread`, `grow`, `rate_changes_on_step`, `rate_read_in_regularity`).

**What the witnesses answer of the texts' questions.** "Must every transformation involve feedback or reciprocal interaction?" The grammar does not require it: the decay is an alteration in a net where no occurrence reaches itself; but every net indexed by rising steps has no cycle, a feedback system run over time included, so the absence of a cycle lies in the indexing, and the nucleus's lack of inner interaction is an omission of the model. "Can persistence be explained without fixed components?" The line of descent continues under the one while each member's line begins and ends: the one is constant, and since each member's line ends at old age, "same member" is not («有亡之续则不有常»); the flame answers otherwise (§5 of 01): its moments continue under "flame or not", that class is not constant, and its course is fixed by fire with fuel. "Can the grammar handle overlapping and observer-dependent identities?" As several classes, with positions relative to each and observer-dependence as the choice of class; a sameness that does not compose is not a class, and the grammar says what fails then. "Can patterns transform the conditions governing their own propagation?" In one narrow sense: a rate that grows with the number it spreads, both laws supplied and fixed. The source's organism question (deriving self-maintenance and adaptive regulation) and its institution question (identity through replaced parts) are not answered; the consent-or-penalty pair is the thermostat witness renamed. The two family lines answer a question GS2's witnesses left (PW's, after §4.5 of 07 landed): a class strictly between a member's and the one can have a core that goes on through births, and reaching one's successors along 缘 is then not reaching everything. The decay witness adds one point: which net a model declares, of possibilities or one history within it, decides whether the time is in the regularity.

**Constructivity.** No omniscience principle. A first build had `propext` in definitions written with overlapping patterns (`| _, _ => False`); every case is now written out, as `Becoming.GrammarTesting` writes its room.

**The review, and what was taken.** Errors fixed: "whether a condition fixes the timing depends on how the net is read" (two nets were written, not one net read two ways; now said of which net a model declares); the history, which let a decayed nucleus become intact (now a branch within the net of possibilities, `Decay.history_within`); the flame said to have a constant class (it has none); the organism reading, which contradicted GS2's reading of the same net (dropped; what remains is that the line of descent generates); the Open bullet, which closed questions the witnesses do not answer (now listing them); the institution, the thermostat witness renamed (now a reading, not a law). Imprecisions narrowed: "no condition fixes the timing" (the step is not in the regularity of one class; that no occurrence forces the decay is the net's definition); the absence of a cycle (from the indexing); the belief (the rate changes on the step; one holder at two rates; the laws fixed); "small witnesses" for what are witnesses, not models of the systems.

**Self-review.** (1) Each sentence of §8.7 was read against its declaration after the review. (2) Not done: the items in Boundary.
"""
text = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in text
STUDY.write_text(text.rstrip('\n') + '\n' + section, encoding='utf-8')

reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert 'the-source-texts-test-systems' not in reg['records']
reg['records']['the-source-texts-test-systems'] = {'region': 'root', 'base': 'grammar',
                                                  'note': 'GrammarCases: decay, overlap, line of descent, belief as small witnesses'}
assert 'Becoming.GrammarCases' not in reg['modules']
reg['modules']['Becoming.GrammarCases'] = {'region': 'root', 'base': 'grammar',
                                           'note': 'test systems of the source texts as small witnesses (GS3)'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 01-ROOT §8.7 and Open; study section', N, '; regions')
