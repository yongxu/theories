#!/usr/bin/env python3
"""Write evidence/REVIEW-RFM3.md: the cross-model review of RF-M.3's design, verbatim, and what each finding became.

Input (saved where the review ran): the cross-model reader's review (markdown). The design it read is the first draft of
plan §4.8, at the root of a rehearsal of main with RF-M.2 integrated (RFM3-DESIGN.md); the plan's §4.8 is the design as
revised on it. Usage, from the repository root:

    python3 -B <this file> <review .md>
"""
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
STUDY = HERE.parents[1]
OUT = STUDY / 'evidence' / 'REVIEW-RFM3.md'
sys.path.insert(0, str(HERE.parent / 'round2b'))
from relink_rfm2 import relink  # noqa: E402

ROOTS = ('/private/tmp/claude-501/-Users-ren-theories/50635de9-b91e-4f4c-a63c-8413ce8c4652/scratchpad/wt-rfm2-rehearse/',)
review = Path(sys.argv[1]).read_text(encoding='utf-8')
review = review[:review.index('── cx ·')].rstrip() if '── cx ·' in review else review.rstrip()
for root in ROOTS:
    review = review.replace(root, '')

INTRO = """# The review of the design of RF's round 2, third part

RF round 2, third part, RF-M.3: the valuation as state (plan §4.8). Before any Lean was written, the first draft of the design was read by the cross-model reader (GPT astra, high effort, read-only, a fresh session `01a18d08-1fbf-7b82-9522-08ae41b858b8`, 30 October 2026), in a rehearsal of main with RF-M.2 integrated and the draft at its root as `RFM3-DESIGN.md` (kept as [RFM3-DESIGN-FIRST-DRAFT](RFM3-DESIGN-FIRST-DRAFT.md)), with the prompt in [the brief](BRIEF.md#round-2-third-part). Its review follows verbatim, its paths made relative to the checkout and its links to this folder, since this folder is link-checked as live: a line number kept in a link's text and dropped from its target, and a link that does not resolve here (the draft itself among them) shown as its text with its target as code. The draft's item numbers are not the plan's: the plan's §4.8 is the design as revised on this review, and the table below says where each finding went."""

# (finding, status, how); item numbers are those of plan §4.8.
TAKEN = (
    ('1', 'taken', "The Standing: the split with its exact criteria and the threshold, joined to executable courses of "
                   "informing and revaluing in one law with the valuation in state, is the contribution; optimality, "
                   "refinement monotonicity, sensory dependence and the projection identities are named as supporting "
                   "compositions or instances, with `Untested.model_or_order` and `informed_turns` credited and the "
                   "capture laws named as distinct."),
    ('2', 'taken', "Item 2: the residual is the weighted loss of deciding a cell against its strict weighted preference, "
                   "not a disagreement with `leastThrough` (which stops at ties where the answer releases); decidable "
                   "equality on cells named; the zero and positive characterizations kept; a cell without a listed "
                   "candidate of positive weight adds nothing."),
    ('3', 'taken', "Item 3: the exact cell criterion for the answer, for any model of the reading formation; one positive "
                   "scale, `q * g c + p * loss c = q * l c + p * gain c`, and net agreement as sufficient conditions, "
                   "needed only at listed candidates of positive weight; scales differing by candidate said not to "
                   "suffice."),
    ('4', 'taken', "Item 5 assumes the finer answer has no residual (by 3), the refinement stated on the holding "
                   "formation's listed candidates without surjectivity; the counterexample is item 10's witness."),
    ('5', 'taken', "Item 4: the corollary with its support condition, exact (every candidate the holding formation weighs, "
                   "where the loss exceeds the gain, has positive total weight in the reading formation's listing), with "
                   "the review's counterexample as its witness."),
    ('6', 'taken', "Item 9 sets the second candidate's value of switching off to nothing explicitly; the draft's item 8 is "
                   "item 14, whose first candidate is the review's specification and whose second makes holding needed."),
    ('7', 'taken', "Item 11: strictly lower exactly where some listed cell is decided against the current valuation's "
                   "strict weighted preference; one listing, weights and map for both answers; gross worth, before costs "
                   "of waiting or intervening."),
    ('8', 'taken', "\"Opposite verdicts\" dropped. Item 12: the revised answer has no residual under the revised valuation; "
                   "no order of attained worth across valuations and no endorsement of revaluing follows, with the "
                   "review's numbers as a witness both ways."),
    ('9', 'taken', "Item 15: strictly lower exactly where the amount forgone is positive, stated by cross-addition."),
    ('10', 'taken', "Item 16: the four maps, the answer of the updated state, the holding formation's law reading only "
                    "its own state and the answer, the timing to `t + 3`, decidable equality on what is shown, each act "
                    "one step's input."),
    ('11', 'taken', "Item 8: revaluing changes only the residual, refining changes both, the residual either way; item 17: "
                    "the updates commute and the courses need not; \"act apart\" dropped."),
    ('12', 'taken', "Item 18: pointwise over the candidate worlds, the weights and valuation preserved, the time the "
                    "demonstration is taken in named, the holding formation's model as the reading formation's before "
                    "it; the reading as conditional probability needs positive mass in the cell."),
    ('13', 'taken', "Item 19: one start and inputs alike at the two worlds (no demonstration telling them apart, one "
                    "payload in every exposure); the conclusion is no strict gross advantage over the better move, not a "
                    "worth of nothing."),
    ('14', 'taken', "Item 20: the review's tables and weights, the update adopting a presented valuation state, and the "
                    "separation of the two terms said to hold in these witnesses only."),
    ('15', 'taken', "Item 21: the route property defined apart from the endpoint, the endpoint the reading formation's "
                    "internal state, the exposure producing the identical valuation state, and the boundary (the start "
                    "or the inputs added to the record) named."),
    ('16', 'taken', "Item 21: a finite record of answers and courses agreeing pointwise, the valuation states a finite "
                    "type; no extensionality or classical decidability."),
    ('17', 'taken', "Item 6: the proposed criterion over every refinement, to be built and checked in the Lean; its sets "
                    "need not be nonempty (empty ones meet it trivially)."),
    ('18', 'taken', "Item 7 (the exact threshold of withholding against informing) and item 14 (a witness of four "
                    "courses); item 13 adds when some revaluation gains. The minimization is not represented as a "
                    "choice."),
    ('19', 'taken', "Item 5 names the deterministic-refinement, fixed-decision direction of Blackwell (1953); the "
                    "Readings take the review's sentence on Bayesian persuasion: weakly optimal full disclosure under a "
                    "common prior and identical objectives; the sender's commitment and equilibrium not represented."),
    ('20', 'taken', "The Readings take the review's sentence on Crawford and Sobel (1982)."),
    ('21', 'taken', "The Readings relate item 11 to Everitt and others (2021) only as an analogy of evaluation, with the "
                    "reason it holds. The draft's projection lemmas (its item 15), which the verdict would build as "
                    "modest, are dropped: definitional, and, as this finding says, their world-only act is absent from "
                    "the carrier."),
    ('22', 'taken', "The Readings: no path-specific objective is constructed; the fixed evaluation corresponds to one "
                    "only where the paths through the valuation are cut, and the evaluation after revaluing uses the "
                    "actual changed valuation."),
    ('23', 'taken', "The Readings take the review's sentence on Carroll and others (2022): the answers and the endpoint "
                    "do not determine this specified route property."),
    ('24', 'taken', "Item 19 and the Readings: no strict gross advantage over the better move; the preference-relevant "
                    "parameter among the candidate worlds; a start carrying information excluded."),
    ('25', 'taken', "The opening takes the review's framing; \"reference valuation\" replaces \"measure\" and "
                    "\"residual\" the disagreement, defined narrowly; \"the candidate parameter `W` unchanged\". The module "
                    "is `ListingValuation`, as the review suggested, and the draft's \"shaping\" is \"revaluing\", since "
                    "`RuleShaping` and `DrawnShaping` use shaping for a rule selected by what comes back."),
)

assert [int(n) for n, _, _ in TAKEN] == list(range(1, 26))
rows = ['| Finding | Status | Where it went (plan §4.8) |', '|---|---|---|']
rows += [f"| {n} | {status} | {how.replace('|', chr(92) + '|')} |" for n, status, how in TAKEN]
text = '\n\n'.join([INTRO, '## The review', relink(review), '## What was taken', '\n'.join(rows)]) + '\n'
assert '](/' not in text and not any(root in text for root in ROOTS)
OUT.write_text(text, encoding='utf-8')
print(OUT.relative_to(STUDY.parent), len(text), 'characters,', len(TAKEN), 'findings')
