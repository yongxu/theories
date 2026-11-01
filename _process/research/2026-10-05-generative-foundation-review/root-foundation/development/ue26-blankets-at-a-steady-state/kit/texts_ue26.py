#!/usr/bin/env python3
"""UE26 texts: the home sections of the-blanket-at-a-steady-state and the-blanket-in-a-linear-steady-state in 03 §1,
after the blanket's reading, with a reading of their own; 08 §8's blanket bullet; the principle's page (In brief, the
claim table, §1's and §2's blanket bullets, §5 and Standing); the UE plan's owners and FEP-INTEGRATION's item 11. Every
backticked BlanketWeights name is checked against the kit's scratch-build axiom audit and every LinearBlankets name
against the periphery's declarations (periphery/declarations.txt, which make_records_ue26.py checks against the
landing receipt). Mirrors UE25's texts_ue25.py; every edit is asserted to apply exactly once. The wording follows the
landing review (REVIEW-UE26-LANDING): each summary keeps the sufficient condition's hypotheses, and the synchronous
loss with circulation is a witness, a loss of the discrete step.
usage (from the checkout root of the landing worktree, after integrate_ue26.py): python3 -B <kit>/texts_ue26.py N
(N the study section the landing appends)"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
AUDIT = HERE / 'tree/.build/BecomingBlanketWeightsAxiomAudit.lean'
CORE_NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))
LINEAR_NAMES = {n.replace('Becoming.', '', 1) for n in
                (HERE / 'periphery/declarations.txt').read_text(encoding='utf-8').split()}
CH = ROOT / 'theories/becoming/chapters'
PAGE = ROOT / 'theories/becoming/FREE-ENERGY-PRINCIPLE.md'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
CORE_ID, LINEAR_ID = 'the-blanket-at-a-steady-state', 'the-blanket-in-a-linear-steady-state'
N = int(sys.argv[1])


def cited(text):
    """Every backticked BlanketWeights or LinearBlankets name the text cites is a declaration of its module."""
    core = set(re.findall(r'`(BlanketWeights\.[A-Za-z_.\']+)`', text))
    linear = set(re.findall(r'`(LinearBlankets\.[A-Za-z0-9_.\']+)`', text))
    missing = sorted(n for n in core if n not in CORE_NAMES) + sorted(n for n in linear if n not in LINEAR_NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# the sufficient condition and the synchronous loss, as every summary below states them
SUFFICIENT = ("with positive weights, moves present at every external state and rate ratios reading none")
LINEAR_ZERO = ("under the principle's sparse coupling with footnote 13's condition and diagonal positive noise")

# 03 §1: the two home sections and their reading, after the blanket's reading
C03 = CH / '03-KNOWING.md'
DESIGN = ('../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
          'ue26-blankets-at-a-steady-state/DESIGN.md')
ANCHOR = '<a id="observation"></a>'
SECTION = (
    f'<a id="r-{CORE_ID}"></a>\n'
    "**Theorem** (any type; natural weights on listed states; for the sufficient condition, discrete states and a "
    "chain in which one part moves at a time, read through its rates). *The blanket at a steady state.* The "
    "free-energy principle's blanket is statistical: at a steady state, internal and external states are independent "
    "given the present blanket state (Friston 2019; Friston, Da Costa, Sajid, Heins, Ueltzhöffer, Pavliotis and Parr "
    "2023, §4). On a weighting of internal, blanket and external states, that independence on the theory's "
    "conditioning, an internal event's share under the weighting restricted to a record of the external part being "
    "its share at each blanket state (`BlanketWeights.IndependentGiven`), is the cross form on the listed states, "
    "two internal states' weights with two external states cross-multiplying equally, on listings listing each state "
    "once (`BlanketWeights.independentGiven_of_crossFormOn`, `BlanketWeights.crossFormOn_of_independentGiven`); the "
    "product law of [conditioning by restriction](#r-conditioning-by-restriction) is its case at one blanket state "
    "(`BlanketWeights.restrict_independent_case`). Where the internal moves are in detailed balance with a positive "
    "weighting, the internal states at each blanket state lie within one closure (the grammar's «所闭») of moves "
    "present at every external state, and each such move's rate ratio reads no external state, the weighting is in "
    "cross form, so independent given the blanket, no steady state assumed "
    "(`BlanketWeights.crossForm_of_detailedBalance`, `BlanketWeights.independentGiven_of_detailedBalance`); that the "
    "same moves are present at every external state cannot be dropped (`BlanketWeights.MovesReadExternal.not_crossForm`). "
    "The condition is sufficient, not necessary. In a lag relay the internal bit follows the blanket bit, which "
    "follows the external bit, the internal bit's rates reading no external state, and its steady weights are not "
    "independent given the blanket (`BlanketWeights.LagRelay.not_independentGiven`); a chain whose internal part turns "
    "one way only, circulating, keeps them independent (`BlanketWeights.Turning.independentGiven`). In a synchronous "
    "kernel, all parts moving at once, each factor reading, by the kernel's construction, only what the blanketed law "
    "lets it read, the internal bit copying a sensory copy of the external bit, the steady weights are independent "
    "when the sensory copy is exact and not with a miss in four (`BlanketWeights.SynchronousCopy.exact_independentGiven`, "
    "`BlanketWeights.SynchronousCopy.noisy_not_independentGiven`); a determined blanketed run's occupation weighting "
    "need not be in cross form (`BlanketWeights.Cycle.not_crossForm`): the coupling form holds on every run, the "
    "statistical form not. Known and near-definitional: Kelly's proof that the equilibrium of a reversible spatial "
    "process is a Markov field (Kelly 1979, Theorem 9.3), taken at the internal site with rate ratios; sparse coupling "
    "without the statistical blanket (Biehl, Pollock and Kanai 2021, Observation 1; Aguilera, Millidge, Tschantz and "
    "Buckley 2022), of which the relay is a witness. New: the statement in the pure core, on the theory's conditioning "
    f"([record](../results/records/{CORE_ID}.md)).\n\n"
    f'<a id="r-{LINEAR_ID}"></a>\n'
    "**Theorem** (periphery, on Mathlib's reals, Lean's three standard axioms; finitely many coordinates, stated "
    "algebraically, the correspondences with stationarity and Gaussian conditional independence stated, not proved; "
    "discrete steps for the Euler laws). *The blanket in a linear steady state.* For the drift −Bx with noise D, "
    "steady covariance S (symmetric and invertible) and precision Π, the Lyapunov equation is the Helmholtz form "
    "B = (D − Q)Π with Q antisymmetric, its parts unique (`LinearBlankets.helmholtz_of_lyapunov`, "
    "`LinearBlankets.helmholtz_unique`). With diagonal positive noise, Q vanishing between a set of coordinates and "
    "the rest, and no coordinate of the set reading a coordinate j, every precision entry between the set and j is "
    "zero (`LinearBlankets.precision_zero_of_autonomous`): in the four parts, with the internal and active coordinates "
    "autonomous (the 2023 paper's footnote 13: no solenoidal flow between them and the rest), the principle's sparse "
    "coupling gives zero precision entries between internal and external coordinates while the internal and active "
    "coordinates circulate between themselves (`LinearBlankets.precision_zero_of_footnote13`, "
    "`LinearBlankets.Autonomous.precision_zero`). Under the paper's term-by-term sparse coupling (its eq. 9, with "
    "constant solenoidal part, noise and Hessian, the noise and the Hessian with positive diagonals) the zero precision "
    "entry is one of the definition's terms, and an influence the other way runs only through solenoidal flow to "
    "third states (`LinearBlankets.unread_zero`, `LinearBlankets.reverse_through_third`); read as a zero drift entry, "
    "sparse coupling can come, by cancellation, with a nonzero entry (`LinearBlankets.LagRelay.precision_nonzero`, "
    "`LinearBlankets.LagRelay.not_termwise`). The Euler step of a sparsely coupled drift is a blanketed law, and with "
    "additive noise as each coordinate's own input the agent's course is fixed by its start, its own noise and its "
    "sensory course, pathwise, circulating or not (`LinearBlankets.split_euler`, "
    "`LinearBlankets.em_agent_through_sensory`). Without circulation the synchronous recursion's steady precision is "
    "Π − (h/2)ΠDΠ, which keeps the internal–external zero in the four parts with diagonal positive noise and moves an "
    "active–external entry by −h/2 times a sum through the sensory coordinates, nonzero in a witness "
    "(`LinearBlankets.em_steady`, `LinearBlankets.em_keeps_four_part`, `LinearBlankets.em_active_external`, "
    "`LinearBlankets.Autonomous.em_loses_active_external`). With circulation it can lose the internal–external zero "
    "too: in a witness whose drift meets footnote 13 and eq. 9, the entry at h = 1/10 is −27800/984581, while the "
    "coupling form holds on its runs and the drift's continuous-time zero stands, a loss of the discrete step "
    "(`LinearBlankets.Autonomous.em_loses_internal_external`, `LinearBlankets.Autonomous.em_coupling_form`). Known: "
    "the Ornstein–Uhlenbeck identities, footnote 13's condition with its normal form (Heins and Da Costa 2022, eq. 14, "
    "with the condition under it, eq. 15), and the order-h bias of the Euler–Maruyama steady law. New: the proof of "
    "footnote 13's law for any set of coordinates, the joins to the blanketed law, and the circulating witness "
    f"([record](../results/records/{LINEAR_ID}.md)).\n\n"
    "**Reading** [AI reading, D45]. What the theory states of agents through the blanket, a determined policy a "
    "selection through the sensory course, a reading through the blanket lumping, the break unseen, needs only the "
    "coupling form, so it holds whether or not the steady weights are independent given the blanket. The principle's "
    "reading of internal states as beliefs about external ones needs the statistical form, which holds under "
    "conditions each of which is known; under its own term-by-term definition, in the linear case, the zero is one of "
    "the definition's terms, and the losses are where sparse coupling is read as a zero drift entry, and in the "
    "theory's synchronous steps, where with circulation the four-part blanket can be lost even under footnote 13 "
    f"([design]({DESIGN})).\n\n")
edit(C03, ANCHOR, SECTION + ANCHOR)

# 08 §8: after the blanket bullet's last sentence
C08 = CH / '08-METHOD.md'
edit(C08, "Each law is near-definitional, a composition or a witness; no sentence of the principle's literature is "
          "forbidden.",
     "Each law is near-definitional, a composition or a witness; no sentence of the principle's literature is "
     f"forbidden. The blanket at a steady state ([03 §1](03-KNOWING.md#r-{CORE_ID})) restates Kelly's proof (1979, "
     "Theorem 9.3) at the internal site, with rate ratios, on the theory's conditioning; sparse coupling without the "
     "statistical blanket is known (Biehl, Pollock and Kanai 2021, Observation 1), and the relay is a witness of it. "
     f"Its linear case ([03 §1](03-KNOWING.md#r-{LINEAR_ID})) states the Ornstein–Uhlenbeck identities, the 2023 "
     "paper's footnote 13 as a law, near-definitional corollaries of its eqs. 9–10, and the Euler–Maruyama scheme's "
     "known order-h bias. New are the statement in the pure core on the theory's conditioning, the proof of footnote "
     "13's law for any set of coordinates, the joins to the blanketed law, deterministic and with noise, and a "
     "circulating witness in which the synchronous scheme loses the four-part blanket. No sentence of the literature "
     "is forbidden.")

# the principle's page
CORE = f'(chapters/03-KNOWING.md#r-{CORE_ID})'
LINEAR = f'(chapters/03-KNOWING.md#r-{LINEAR_ID})'
edit(PAGE, "the Markov blanket is stated as a coupling structure on a determined law;",
     "the Markov blanket is stated as a coupling structure on a determined law, and its statistical form, "
     "conditional independence given the blanket at a steady state, under sufficient conditions in counts and, in the "
     "linear case, over the reals;")
edit(PAGE, "Three further laws forbid no sentence of the literature but state what it leaves open:",
     "Four further laws forbid no sentence of the literature but state what it leaves open:")
edit(PAGE, "expected free energy reads beliefs only through the lumping its likelihood makes, and so does every course "
           "of seeking by it, and an agent reading its supply only by threshold cannot see its break coming, whatever "
           "its model and policy.",
     "expected free energy reads beliefs only through the lumping its likelihood makes, and so does every course of "
     "seeking by it; an agent reading its supply only by threshold cannot see its break coming, whatever its model and "
     "policy; and the blanket's statistical form holds where the internal moves are in detailed balance with a "
     "positive weighting, joined at each blanket state by moves present at every external state whose rate ratios "
     f"read no external state, or, in the linear case, {LINEAR_ZERO}; it need not hold with circulation, and in a "
     "witness the synchronous steps of a drift meeting footnote 13 and the 2023 paper's term-by-term sparse coupling "
     "lose it, a loss of the discrete step, the drift's continuous-time zero standing.")
edit(PAGE, "Langevin flows and the Helmholtz decomposition, nonequilibrium steady states, generalized coordinates, "
           "precision,",
     "Langevin flows, the Helmholtz decomposition and nonequilibrium steady states beyond the linear case's algebra, "
     "generalized coordinates, the precision of beliefs,")
edit(PAGE, "| The Markov blanket | a blanketed law: the agent's course fixed by its start and its sensory course "
           "([03 §1](chapters/03-KNOWING.md#r-the-markov-blanket-as-a-coupling-structure)) | stated, pure core, the "
           "deterministic case |\n",
     "| The Markov blanket | a blanketed law: the agent's course fixed by its start and its sensory course "
     "([03 §1](chapters/03-KNOWING.md#r-the-markov-blanket-as-a-coupling-structure)) | stated, pure core, the "
     "deterministic case |\n"
     "| The blanket's statistical form: internal and external states independent given the blanket at a steady state "
     "(Friston 2019; Friston, Da Costa, Sajid, Heins, Ueltzhöffer, Pavliotis and Parr 2023, §4) | the cross form on "
     f"states each listed once, which detailed balance of the internal moves gives, {SUFFICIENT} ([03 §1]{CORE}); in "
     "the linear case the Helmholtz form, footnote 13 as a law, the term-by-term corollaries and the synchronous "
     f"scheme ([03 §1]{LINEAR}) | stated, pure core and periphery, sufficient conditions with witnesses on either "
     "side; under the paper's term-by-term definition the linear zero is definitional; the theory's synchronous steps "
     "can lose it with circulation (a witness at h = 1/10) |\n")
edit(PAGE, "| Densities, Langevin flows, the Helmholtz decomposition, steady states, precision, learning | none |",
     "| Densities, Langevin flows, the Helmholtz decomposition and steady states beyond the linear case's algebra, the "
     "precision of beliefs, learning | none |")
edit(PAGE, "each side's fixed by its start and the blanket's ([03 §1](chapters/03-KNOWING.md#r-the-markov-blanket-as-a-"
           "coupling-structure); `Blanket.Blanketed.agent_through_sensory`, `Blanket.Blanketed.internal_through_blanket`).",
     "each side's fixed by its start and the blanket's ([03 §1](chapters/03-KNOWING.md#r-the-markov-blanket-as-a-"
     "coupling-structure); `Blanket.Blanketed.agent_through_sensory`, `Blanket.Blanketed.internal_through_blanket`). "
     "Its statistical form, conditional independence given the blanket at a steady state, is the cross form on states "
     f"each listed once, which detailed balance of the internal moves gives, {SUFFICIENT} ([03 §1]{CORE}; "
     "`BlanketWeights.crossForm_of_detailedBalance`); in the linear case (*periphery*) the Lyapunov equation is the "
     "Helmholtz form, and with diagonal positive noise and the principle's sparse coupling, footnote 13's condition "
     f"gives zero precision entries between internal and external coordinates ([03 §1]{LINEAR}; "
     "`LinearBlankets.precision_zero_of_footnote13`).")
edit(PAGE, "for the threshold witness the blanket is the World's coupling ([03 §1](chapters/03-KNOWING.md#r-the-markov-"
           "blanket-as-a-coupling-structure)). **Reading** [AI reading, D45]: the partition names the couplings.",
     "for the threshold witness the blanket is the World's coupling ([03 §1](chapters/03-KNOWING.md#r-the-markov-"
     "blanket-as-a-coupling-structure)). The statistical form holds under detailed balance of the internal moves, "
     f"{SUFFICIENT}, or, in the linear case, {LINEAR_ZERO}, and need not hold with circulation; the theory's "
     "synchronous steps keep the coupling form on every run and can lose the statistical form with circulation, a "
     f"loss of the discrete step ([03 §1]{CORE}, [03 §1]{LINEAR}; "
     "`LinearBlankets.Autonomous.em_loses_internal_external`). **Reading** [AI reading, D45]: the partition names the "
     "couplings; the theory's agent laws need only the coupling form, the principle's inference reading the "
     "statistical form.")
edit(PAGE, "Langevin flows and the Helmholtz decomposition of a steady-state flow; nonequilibrium steady-state "
           "densities, and whether statistical and dynamical blankets coincide.",
     "Langevin flows; the Helmholtz decomposition of a steady-state flow beyond the linear case, where it is stated "
     f"algebraically under stated correspondences ([03 §1]{LINEAR}); nonequilibrium steady-state densities, the linear "
     "case stating only the steady covariance's algebra; the relation of statistical and dynamical blankets beyond the "
     f"sufficient conditions and witnesses of [03 §1]{CORE}.")
edit(PAGE, "a World formation in general as the agent of a blanketed law;",
     "a World formation in general as the agent of a blanketed law; a discrete law for footnote 13's set of internal "
     "and active states;")
edit(PAGE, "and the code law for beliefs held as counts, joined to the free-energy bound in counts.",
     "the code law for beliefs held as counts, joined to the free-energy bound in counts; and the blanket's "
     "statistical form on the theory's conditioning in the pure core, footnote 13's law for any set of coordinates, "
     "the joins to the blanketed law, and a circulating witness in which the synchronous scheme loses the four-part "
     "blanket.")

# the UE plan and the plan for the principle
UE = ROOT / RF / 'development/ue-unified-explanation'
REC = '../../../../../../theories/becoming/results/records/'
edit(UE / 'PLAN.md', "UE21, UE22, UE23, UE24 and UE25, and holds UE8.",
     "UE21, UE22, UE23, UE24, UE25 and UE26, and holds UE8.")
FI = UE / 'FEP-INTEGRATION.md'
lines = FI.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('10. **UE25. A code held as counts**')]
assert len(at) == 1 and not any(line.startswith('11. **UE26.') for line in lines), at
lines[at[0] + 1:at[0] + 1] = [cited(
    "11. **UE26. Blankets at a steady state** (landed as the core leaf `Becoming.BlanketWeights` and the periphery "
    f"module `LinearBlankets`, with [the record in counts]({REC}{CORE_ID}.md) and [the record of the linear case]"
    f"({REC}{LINEAR_ID}.md), study section {N}). The principle's statistical blanket on the theory's conditioning: "
    "conditional independence given the blanket is the cross form on listed states, the converse on listings listing "
    "each state once; detailed balance of the internal moves with positive weights, within one closure of moves "
    "present at every external state whose rate ratios read no external state, gives it, Kelly's proof at the "
    "internal site, sufficient, not necessary, with witnesses on either side; in the linear case, the Lyapunov "
    "equation as the Helmholtz form, footnote 13 as a law for any set of coordinates, the term-by-term corollaries, "
    "and the join to the blanketed law with noise; the synchronous scheme keeps the four-part zero without "
    "circulation, and in a circulating witness at h = 1/10 meeting footnote 13 and eq. 9 it loses it, a loss of the "
    "discrete step. It narrows three items of §5's first entry to what lies beyond the linear case, stated "
    "algebraically, and forbids no sentence of the literature.")]
FI.write_text('\n'.join(lines), encoding='utf-8')
print('texts: 03 §1 (two home sections and a reading), 08 §8, the page, UE plan, FEP-INTEGRATION item 11')
