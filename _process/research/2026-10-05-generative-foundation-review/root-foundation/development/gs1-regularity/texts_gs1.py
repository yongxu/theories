#!/usr/bin/env python3
"""GS1 texts: the home sections of the two new records (01-ROOT §4, 02-MAP beside closed capture), 01-ROOT's open item
on self-changing conditions restated, the study section, and the regions of the new records and module.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_gs1.py RECEIPT N"""
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


# --- 01-ROOT §4: the kept-and-changed laws, after the two-way core
root = CH / '01-ROOT.md'
edit(root, """so what shares a position under the two-way core shares beginning and ending (`«位同则四相同»`, which states these two marks and no others). A position is fixed by all its relations, before as well as after.
""", """so what shares a position under the two-way core shares beginning and ending (`«位同则四相同»`, which states these two marks and no others). A position is fixed by all its relations, before as well as after.

<a id="r-a-regularity-kept-and-changed"></a>
**Theorem** (root). *A kept regularity can always be kept, and a line ends only by a step that leaves it.* From a step continuing under the core of `E`, every occurrence its line under the core reaches has a successor under the core (`«守理则不穷»`), and a line along which the core is kept leaves its last occurrence continued under `E` (`«守理之线不亡»`). A step into an end under `E` leaves the core, for every relation `E` (`«亡前理变»`), and so does the last step of every line under `E` that ends (`«有亡之线末步离核»`); where `E` is a class, the two ends of such a line lie in different classes of the core (`«有亡之线两端理异»`). These are corollaries of the root theorem and of constancy never letting a continuation end; what they add is where the core is left, at the last step, found with no decision. So what goes on for a while and then ends is a class that does not hold by itself, whose line passes from one class of the core to another before it ends, while the core always admits continuation ([`Becoming.GrammarRegularity`][GrammarRegularity]; [record](../results/records/a-regularity-kept-and-changed.md)). In a branching net a successor under `E` can leave the core where another keeps it; along a determined law the next step keeps it. Where a longer line first leaves its start's class of the core is placed by `«两端分则中有标»` only where the core is decided at each step.

**Theorem** (root; a determined law). Along a determined law's step a line under any relation never ends exactly where every step of the orbit continues under it (`Law.unending_iff_steps`), and under a class such a line keeps every configuration of the orbit alike with its start (`Law.unending_alike`).
""")

# --- 01-ROOT Open: self-changing conditions restated
edit(root, """- **Self-changing conditions.** The grammar's relation is fixed, so a pattern reshaping its own position and limits, or a selection of selection (which [元吸引子](02-MAP.md#r-closed-capture) needs), cannot be stated in it; such change is stated only on processes and two-level courses (`adaptive_state_law_iff`, [`Becoming.ClosedCapture`][ClosedCapture]).
""", """- **Self-changing conditions.** A rule that changes by a fixed law is stated in the grammar by taking the rule into the occurrence, the carrier being a parameter: for a process changing its own rule the state's class is constant under every move exactly where the rule makes no difference to it, and in closed capture the locked line goes on while every step alters the loss ([02](02-MAP.md#r-rules-that-change-themselves-in-the-grammar), [`Becoming.GrammarRegularity`][GrammarRegularity]). The law of change stays fixed, and the levels come from the carrier's product, not from the grammar. Not yet stated: a change of the law of change with no fixed law above it, or a space of rules not given with the carrier; a pattern reshaping its own limits (限 is not defined, below); the lock and absorption laws of [`Becoming.ClosedCapture`][ClosedCapture] and readers formed from the selected, in the grammar's terms; and selection of selection (which [元吸引子](02-MAP.md#r-closed-capture) needs) as a law relating two grains.
""")
edit(root, """[ClosedCapture]: ../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ClosedCapture.lean
""", f"""[ClosedCapture]: ../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ClosedCapture.lean
[GrammarRegularity]: {LEAN}/GrammarRegularity.lean
""")

# --- 02-MAP: rules that change themselves, beside closed capture
mp = CH / '02-MAP.md'
edit(mp, """Where the reading too is formed monotonically from the share, a change of the reading of any size is absorbed at the next reading step ([record](../results/records/closed-capture.md)).
""", """Where the reading too is formed monotonically from the share, a change of the reading of any size is absorbed at the next reading step ([record](../results/records/closed-capture.md)).

<a id="r-rules-that-change-themselves-in-the-grammar"></a>
**Theorem** (root; on processes and the two-level step). *Rules that change themselves, read in the grammar.* A move of a process is a relation, `s` conditioning `t` by the move (`moveRel`): where every move is possible, a process going alike by a map has the map's class constant under every move (`constant_of_goAlike`), and where the process is determined the converse holds (`goAlike_of_constant`). For a state going on under a rule that itself goes on, the state's class is constant under every move, and is its own core under every move, exactly where the rule makes no difference to the state (`adaptive_constant_iff`, `adaptive_core_iff`); where two rules take one state by one move to different states, the core of the state's class under that move tells the two configurations apart (`adaptive_core_apart`): the rule is read in the state's regularity. In closed capture the class of share, rule and step count is constant under the two-level step along every schedule exactly where nothing beyond the share is read (`ClosedCapture.constant_iff_unread`). Under the premises of `lock_outlives_loss`, from a locked start the line under the class of being locked or not never ends and each of its steps alters the loss (`ClosedCapture.lock_line`): the course stays locked while the coordinate it does not read changes at every step. Along a two-level step whose reading favours at no loss past a bound, with a reading step past the bound, the line under favouring or not from a favouring start is not unending (`ClosedCapture.loss_ends_line`), one sufficient way out, as in T7. In the witness, read from the share alone the line under being locked never ends, and read from the loss the line under favouring ends at the first step (`ClosedCapture.Beyond.closed_line`, `ClosedCapture.Beyond.open_line_ends`). This is capture through the rule; the reading formed from the share (`both_reads`) and the lock's own laws are used or left as they are, not restated in the grammar ([record](../results/records/rules-that-change-themselves-in-the-grammar.md)).
""")

# --- the study section
section = f"""
## {N}. A regularity kept and left along its own line, and rules that change themselves (GS1)

The review of the root against its two source texts ([note](development/one-unfolding-root/reviews/2026-10-23-sources-against-v10.md), §4 and §6) found three things this item takes up: the root chapter called self-changing conditions unstatable in the grammar; the texts' "a regularity can be temporarily self-maintaining without being eternal" was read only through «有常则续不尽»; and the meta-attractor was stated only on processes. Ren chose on 24 October to carry the gaps the review found, in turn (board items GS1–GS3). That choice is the provenance; the argument is below. An independent review of this landing's first draft (a separate Claude Opus agent, reading the Lean and every text) found the Lean sound and the texts overstated; its findings were taken before landing and are listed at the end.

```text
Result(s): new records a-regularity-kept-and-changed and rules-that-change-themselves-in-the-grammar; closed-capture
       and projection-carrying-a-law gain related entries.
Delta: (1) laws of the grammar, corollaries of «根», «有常则续不尽» and «亡于核下不变»: from a step under the core
       every occurrence its line under the core reaches is continued under the core («守理则不穷»); a line along
       which the core is kept leaves its last occurrence continued under the class («守理之线不亡»); for every
       relation E, a step into an end leaves the core («亡前理变»), and so does the last step of every line that
       ends, found by recursion with no decision («相续之末步», «有亡之线末步离核»); where E is a class, the two
       ends of such a line lie apart in the core («有亡之线两端理异»).
       (2) along a determined law's step a line under any relation never ends exactly where every step of the
       orbit continues under it (Law.unending_iff_steps), and under a class it keeps the orbit alike with its
       start (Law.unending_alike).
       (3) moves as relations (moveRel): with every move possible, going alike by a map gives the map's class
       constant under every move (constant_of_goAlike); determined, the converse (goAlike_of_constant).
       (4) a rule that changes itself: the state's class constant under every move, and its own core, exactly
       where the rule makes no difference to the state (adaptive_constant_iff, adaptive_core_iff); where two rules
       take one state by one move apart, the core tells the two configurations apart (adaptive_core_apart).
       (5) closed capture: the class of share, rule and step count constant along every schedule exactly where
       nothing beyond the share is read (ClosedCapture.constant_iff_unread); from a locked start the line under
       being locked never ends, each step an alteration under the loss (ClosedCapture.lock_line); along a step
       whose reading turns against favouring past a loss bound, the line under favouring is not unending
       (ClosedCapture.loss_ends_line); the witness both ways, the open line ending at its first step
       (Beyond.closed_line, Beyond.open_line_ends).
Supplied premises / correspondence: (1) E a class only for «有亡之线两端理异»; (3) totality for one direction,
       determinacy for the other; (4) the adaptive process of Becoming.Mechanism; (5) the premises of
       lock_outlives_loss and of turned_by_loss, natural-number losses and discrete steps, as ClosedCapture states.
Evidence: Becoming.GrammarRegularity; core receipt {RECEIPT}, every axiom report empty.
Boundary: lock_outlives_loss and turned_by_loss are used as lemmas; the absorption and readers' laws of RuleCapture
       and ClosedCapture are not used and not restated in the grammar's terms; selection of selection as a law
       relating two grains is not stated; which class carries an actual pattern's regularity stays a reading.
Output → input: 01-ROOT §4 (the kept-and-left laws, the orbit laws) and its Open item on self-changing
       conditions; 02-MAP beside closed capture; regions; the package README row (EN, ZH); the root module's doc.
```

**What was built.** `Becoming.GrammarRegularity`, a leaf: `«守理则不穷»`, `«相续之始有后»`, `«相续之末步»`, `«守理之线不亡»`, `«亡前理变»`, `«有亡之线末步离核»`, `«有亡之线两端理异»`; `Law.unending_iff_steps`, `Law.unending_alike`; `moveRel`, `constant_of_goAlike`, `goAlike_of_constant`, `goAlike_iff_constant`; `adaptive_constant_iff`, `adaptive_core_iff`, `adaptive_core_apart`; in `ClosedCapture`: `constant_iff_unread`, `favouredAlike`, `favouredAlike_class`, `lockedAlike`, `lockedAlike_class`, `loss`, `turn_fast`, `orbit_paced`, `loss_alters`, `lock_line`, `loss_ends_line`, `Beyond.closed_line`, `Beyond.open_line_ends`. No definition of an earlier module changes. The general laws hold for every carrier and relation and could move into `Becoming.Grammar` if its owner agrees; the module is a leaf because it also reads two-level steps, which `Becoming.Grammar` does not import.

**What it says of the source texts.** The texts hold that a regularity can be temporarily self-maintaining without being eternal. In the grammar the regularity of a line is its class's core, and the core always admits continuation: from a step under it, everything its line under it reaches has a successor under it. What goes on for a while and then ends is a class that does not hold by itself (in the grammar's own sense of holding by itself, `«自持»`, nothing does so for a while), and its line passes from one class of the core to another, at the latest at its last step. Under the possibilities reading of a net this says that a core-alike alternative always exists, not that the course taken keeps it. The root chapter's statement that a rule changing itself cannot be stated in the grammar is narrowed: a rule changing by a fixed law, over a carrier holding every rule, is stated by taking the rule into the occurrence, and the two-level laws are the grammar's read there; a change of the law of change with no fixed law above it, a space of rules not given with the carrier, and 限 stay open, and the chapter says so.

**Constructivity.** No omniscience principle is used. «亡前理变» and «有亡之线两端理异» are negations (the core does not relate the two ends); the last step of a line is extracted by recursion on the line («相续之末步»), so «有亡之线末步离核» needs no decision. Where a longer line first leaves its start's class of the core needs the core decided at each step («两端分则中有标»).

**The review, and what was taken.** Errors fixed in the texts: "never left" read as every successor (the law gives a successor; in a branching net another may leave the core); "its core changes" (the core is one relation; the line passes between its classes); "every ending is preceded by a change" (only an end reached by a step); "which step leaves the core needs decision" (the last step needs none, now a theorem); the class of `loopPart` named without its step count; "along every schedule" dropped from an iff; the hypotheses of `loss_ends_line` dropped and its line confused with the lock line; the Open item's "limits" dropped without being covered. Lean changed: `«亡前理变»` stated for every relation (the class hypothesis was superfluous); `«相续之末步»`, `«有亡之线末步离核»` and `adaptive_core_apart` added; the lock line stated under being locked, not only favouring; the witness's open line shown to end at its first step. Readings narrowed: the texts' claim read as true of a class that does not hold by itself, under the one-history reading; the withdrawal of "cannot be stated" narrowed to a rule changing by a fixed law; "the loop continues as itself" replaced by "the course stays locked"; the way out called one sufficient way, as T7 does; the closed loop called capture through the rule, the reading formed from the share not stated here. The record of the general laws says they are corollaries.

**Self-review.** (1) Each sentence of the chapter paragraphs was read against its declaration after the review. (2) `favouredAlike` serves `loss_ends_line` because its reading is any `h` turning against favouring; `lockedAlike` serves the lock line. (3) Not done: the items in Boundary.
"""
text = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in text
STUDY.write_text(text.rstrip('\n') + '\n' + section, encoding='utf-8')

# --- regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
for rid, region, note in (
        ('a-regularity-kept-and-changed', 'root', 'GrammarRegularity: core always admits continuation; last step into an end leaves it'),
        ('rules-that-change-themselves-in-the-grammar', 'map',
         'GrammarRegularity: adaptive rule and closed capture as models of the grammar')):
    assert rid not in reg['records']
    reg['records'][rid] = {'region': region, 'base': 'grammar', 'note': note}
assert 'Becoming.GrammarRegularity' not in reg['modules']
reg['modules']['Becoming.GrammarRegularity'] = {'region': 'root', 'base': 'grammar',
                                                'note': 'kept and left regularity; two-level steps as models (GS1)'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 01-ROOT §4 and Open, 02-MAP, study section', N, ', regions')
