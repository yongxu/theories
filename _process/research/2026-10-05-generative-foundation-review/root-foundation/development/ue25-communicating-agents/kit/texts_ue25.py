#!/usr/bin/env python3
"""UE25 texts: 05's thesis and the home section of a-code-held-as-counts in 05 §9, after imposing a code; 08 §8's
bullet on identical cells; the principle's page (In brief, the communicating-agents row, §3's opening, a fifth entry,
the paragraph on UE1's search, the reading, §5 and Standing); the UE plan's owners, FEP-INTEGRATION's item 10 and its
done-when paragraph; and a correction section appended to UE1's search, whose cited sections stay as written. Every
backticked CountedCodes name the texts cite is checked against the kit's scratch-build axiom audit (the receipt's
declarations are checked against the same names by make_records_ue25.py). Mirrors UE24's texts_ue24.py; every edit is
asserted to apply exactly once.
usage (from the checkout root of the landing worktree, after integrate_ue25.py): python3 -B <kit>/texts_ue25.py N
(N the study section the landing appends)"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
AUDIT = HERE / 'tree/.build/BecomingCountedCodesAxiomAudit.lean'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))
CH = ROOT / 'theories/becoming/chapters'
PAGE = ROOT / 'theories/becoming/FREE-ENERGY-PRINCIPLE.md'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
RID = 'a-code-held-as-counts'
N = int(sys.argv[1])


def cited(text):
    """Every backticked CountedCodes name the text cites is a declaration of the module."""
    found = set(re.findall(r'`(CountedCodes\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in found if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# 05: the thesis and §9
C05 = CH / '05-COLLECTIVES.md'
edit(C05, "from a symmetric start only a broken symmetry brings agreement on a code, or parts identical cells",
     "from a symmetric start only a broken symmetry brings agreement on a code, a code held as counts and learned "
     "from what is heard among them, or parts identical cells")
ANCHOR = '<a id="r-a-swap-symmetric-assignment-singles-out-none"></a>'
SECTION = (
    f'<a id="r-{RID}"></a>\n'
    "**Theorem** (any type of agents, meanings and words; counts in any strict order, natural counts for learning and "
    "free energy; discrete steps of a determined law, the hearer given the meaning). The code law for beliefs held as "
    "counts, as the principle's agents hold a likelihood of words given meanings, learned as Dirichlet counts. A "
    "belief state gives each agent, for each meaning, a count of each word; a word is *uniquely greatest* where it "
    "alone has the greatest count, the word a posterior mean names with no tie. Two words are never both uniquely "
    "greatest, and counts a renaming moving every word leaves unchanged have none "
    "(`CountedCodes.unique_greatest_not_two`, `CountedCodes.fixed_no_unique_greatest`). Under a law keeping the "
    "exchange of agents together with a renaming of the words, from a start related to itself, where the renaming at "
    "a meaning is onto, an agent's uniquely greatest word there, renamed, is that of the agent the exchange gives it, "
    "at every step; so where the renaming also moves every word, or moves every word with the exchange an "
    "involution, two exchanged agents never hold one word as each one's uniquely greatest, and where they hold the "
    "same counts there those counts have none (`CountedCodes.unique_greatest_exchanged_run`, "
    "`CountedCodes.never_shared`, `CountedCodes.never_shared_of_involution`, "
    "`CountedCodes.shared_no_unique_greatest`). Learning from what is heard keeps the relation where the speaker map "
    "commutes with the exchange and the rule reads count by count and commutes with renaming "
    "(`CountedCodes.hear_keeps`); adding the counts heard, the form of the principle's update, is such a rule where "
    "what is heard is (`CountedCodes.addHeard_keeps`); a weight on what is heard read off the hearer's whole model, "
    "not a rule of that form, keeps the relation where the weight is unchanged by the renaming "
    "(`CountedCodes.gatedHear_keeps`). Adding the speaker's own counts, with an involution as speaker map, gives the "
    "two one model after one step; with the exchange, an involution, as speaker map, from a start related to itself, "
    "that model has no uniquely greatest word at a meaning whose every word the renaming moves "
    "(`CountedCodes.addSpeaker_shares`, `CountedCodes.addSpeaker_tied`). In natural counts, over a listing a renaming "
    "permutes, a count belief reaches the free-energy bound for some weights exactly where its renaming reaches it for "
    "the renamed weights, and under weights a renaming moving every word fixes, with a positive total, a belief at "
    "the bound over a listing of every word has no uniquely greatest word (`CountedCodes.bound_invariant`, "
    "`CountedCodes.minimizer_no_unique_greatest`). In witnesses on two agents and two words, a speaker saying the "
    "first word of greatest count, a preferred word, and an asymmetric start each bring a shared uniquely greatest "
    "word (`CountedCodes.Witness.sayFirst_shared`, `CountedCodes.Witness.asymmetric_shared`). Known: Curie's "
    "principle (1894), and conventions as equilibria that symmetry does not select (Lewis 1969; Skyrms 2010); under "
    "sampled signals reinforcement reaches a signalling system (Argiento, Pemantle, Skyrms and Volkov 2009), where "
    f"this law does not apply ([record](../results/records/{RID}.md)).\n\n"
    "**Reading** [AI reading, D45]. That language is an emergent property of free-energy minimization (Friston, Parr "
    "and others 2024), read as a guarantee, fails for every deterministic scheme keeping the symmetry from a "
    "symmetric start: free-energy minimization breaks no symmetry, and something else must, a preferred word, an "
    "order or centre telling the agents apart, an asymmetric start or chance. The paper's federated inference, the "
    "hearer given the meaning, adds the speaker's normalized predictive at the meaning, a rule of the kind "
    "`CountedCodes.hear_keeps` covers; its weighting by the probability of the policy to update reads the hearer's "
    "whole model, of the kind `CountedCodes.gatedHear_keeps` covers in natural weights, and its forgetting acts alike "
    "on every word. So its law is read as keeping the relation `CountedCodes.never_shared` needs, for a renaming the "
    "same for every meaning, since expected free energy reads the marginal over words; that is a reading, not a "
    "theorem. Its simulation starts from random parameters and stands.\n\n")
edit(C05, ANCHOR, SECTION + ANCHOR)

# 08 §8: after UE24's sentence in the identical-cells bullet
C08 = CH / '08-METHOD.md'
edit(C08, "under noise of one law at every cell an exchangeable law stays exchangeable, which forbids nothing of the 2015 "
          "paper, whose scheme has that form.",
     "under noise of one law at every cell an exchangeable law stays exchangeable, which forbids nothing of the 2015 "
     f"paper, whose scheme has that form. A code held as counts ([05 §9](05-COLLECTIVES.md#r-{RID})) states the code "
     "law, Curie's principle with conventions that symmetry does not select (Lewis 1969), for beliefs held as "
     "Dirichlet counts and learned from what is heard, joined to the free-energy bound in counts: it forbids that "
     "language emerges from free-energy minimization (Friston, Parr and others 2024), read as a guarantee, for a "
     "deterministic scheme keeping the symmetry (a rule commuting with the renaming) from a symmetric start, not the "
     "paper's simulation, which starts from random parameters; under sampled signals reinforcement reaches a "
     "signalling system (Argiento, Pemantle, Skyrms and Volkov 2009). Near-definitional, an instance of the core's "
     "kept relation, with witnesses.")

# the principle's page
LINK = f'(chapters/05-COLLECTIVES.md#r-{RID})'
edit(PAGE, "- **Where the theory forbids.** Four statements of the principle's literature,",
     "- **Where the theory forbids.** Five statements of the principle's literature,")
edit(PAGE, "risk minimization does not keep a need the rest outruns; and seeking information corrects only within what "
           "some experiment it can choose separates. Three further laws",
     "risk minimization does not keep a need the rest outruns; seeking information corrects only within what some "
     "experiment it can choose separates; and agents learning a code from what they hear, under a deterministic law "
     "keeping the exchange of agents with a renaming of the words, never come to share, from a start that exchange "
     "and renaming leave unchanged, a uniquely greatest word at a meaning whose every word the renaming moves, free-energy minimization "
     "breaking no symmetry. Three further laws")
edit(PAGE, "learning and structure learning: none is stated in the theory (§5).",
     "learning beyond rules on counts that keep a symmetry, and structure learning: none is stated in the theory "
     "(§5).")
edit(PAGE, "| the laws of a code formed between formations ([05 §9](chapters/05-COLLECTIVES.md#r-a-code-formed-between-"
           "formations)) | graded (b) by UE1's search: forbidden from a start symmetric under exchanging the agents with a "
           "renaming of forms, under a law keeping both; the papers' simulations lie outside; not stated in the "
           "principle's terms here (§3) |",
     "| the laws of a code formed between formations ([05 §9](chapters/05-COLLECTIVES.md#r-a-code-formed-between-"
     f"formations)); for beliefs held as counts and learned from what is heard ([05 §9]{LINK}) | forbidden as a "
     "guarantee for a deterministic scheme of the principle's update keeping the symmetry (a rule commuting with the "
     "renaming), from a start symmetric under exchanging the agents with a renaming of words, read universally (the "
     "2024 papers); the duet, in continuous states, stays under the code law and is not counted; the "
     "federated-inference simulation, from random parameters, stands; pure core |")
edit(PAGE, "and the studies Da Costa and others cite, which have no shared draw, are not refuted;",
     "the studies Da Costa and others cite, which have no shared draw, and the federated-inference simulation, which "
     "starts from random parameters, are not refuted;")
edit(PAGE, "if seeking separated a pair every experiment ties, a likelihood would differ somewhere. Each restates",
     "if seeking separated a pair every experiment ties, a likelihood would differ somewhere; if agents of the 2024 "
     "scheme came to one word from a symmetric start with no noise, their update would treat words or agents unalike. "
     "Each restates")
ENTRY4_END = ("Known: identification (Rothenberg 1971) in its Bayesian form (Poirier 1998).\n")
edit(PAGE, ENTRY4_END,
     ENTRY4_END +
     "5. **Agents learning a code from what they hear by a rule keeping the symmetry never come to share a uniquely "
     f"greatest word from a symmetric start** ([05 §9]{LINK}; *any type*, natural counts for learning and free energy). "
     "Agents hold a likelihood of words given meanings as counts; under a determined law keeping the exchange of "
     "agents together with a renaming of the words, from a start related to itself, two exchanged agents never hold "
     "one word as each one's uniquely greatest at a meaning where the renaming moves every word and is onto, or the "
     "exchange is an involution (`CountedCodes.never_shared`, `CountedCodes.never_shared_of_involution`). Learning "
     "from what is heard keeps the relation where the speaker map commutes with the exchange and the rule reads count "
     "by count and commutes with renaming, adding the counts heard among such rules (`CountedCodes.hear_keeps`, "
     "`CountedCodes.addHeard_keeps`), and so does a weight on what is heard read off the whole model where the weight "
     "is unchanged by the renaming (`CountedCodes.gatedHear_keeps`). Free-energy minimization breaks no symmetry: "
     "the bound in counts is unchanged by a renaming permuting the words, and under weights a renaming moving every "
     "word fixes, with a positive total, a belief at the bound over a listing of every word names no word "
     "(`CountedCodes.bound_invariant`, `CountedCodes.minimizer_no_unique_greatest`). Against language as an emergent "
     "property of free-energy minimization (Friston, Parr and others 2024, abstract), read universally, with the "
     "statement that any dyad or ensemble will come to share a generative model (Friston, Ramstead and others 2024, "
     "§4.1) as its general form on its natural reading, a common code; with that paper's hedge, some factors of a "
     "model, the shared model with no uniquely greatest word is such a factor, and that paper describes no system of "
     "its own. Federated inference's law, the hearer given the meaning, is read as keeping the relation for a "
     "renaming the same for every meaning [AI reading, D45]; its simulation starts each parameter at one plus a random "
     "variate and stands. Known: Curie's principle (1894) and conventions that symmetry does not select (Lewis 1969); "
     "under sampled signals reinforcement reaches a signalling system (Argiento, Pemantle, Skyrms and Volkov 2009), "
     "where this law does not apply.\n")
edit(PAGE, "UE1's [search](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/"
           "ue1-fep-bridge/THIRD-PART-SEARCH.md) grades three more statements as forbidden on their natural reading, "
           "that communicating agents come to share one model or language (Friston and Frith 2015; Friston, Ramstead "
           "and others 2024, §4.1; Friston, Parr and others 2024), under the laws of a code formed between formations "
           "([05 §9](chapters/05-COLLECTIVES.md#r-a-code-formed-between-formations)): from a start symmetric under "
           "exchanging the agents with a renaming of forms, a law keeping both never brings them to agree where the "
           "renaming moves every form, while a preferred form or an order of hearing breaks the symmetry. The duet "
           "gives both agents one model, the federated-inference simulation starts from random parameters, and the "
           "ecosystems paper describes no system of its own, so none is refuted. None is stated in the principle's "
           "terms here, so they are not counted among the four.",
     "UE1's [search](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/"
     "ue1-fep-bridge/THIRD-PART-SEARCH.md) grades three statements that communicating agents come to share one model "
     "or language as forbidden on their natural reading, under the laws of a code formed between formations "
     "([05 §9](chapters/05-COLLECTIVES.md#r-a-code-formed-between-formations)). Two of them make the fifth entry "
     "above. The third, the duet (Friston and Frith 2015), is not stated in these terms: its birds have continuous "
     "states, no word counts and no simulated learning, and start with the same expectations. It stays under the code "
     "law, whose forms may be of any type, and is not counted.")
edit(PAGE, "**Reading** [AI reading, D45]. Each of the four holds whatever model,",
     "**Reading** [AI reading, D45]. Each of the five holds whatever model,")
edit(PAGE, "- Learning of the likelihood, novelty, structure learning and model comparison;",
     "- Learning of the likelihood beyond rules on counts that keep a symmetry, the hearer given the meaning "
     f"([05 §9]{LINK}); novelty, structure learning and model comparison;")
edit(PAGE, "which place four statements of the principle's literature, read as guarantees, where they fail; new also are "
           "the seeking form of identification, joined to seeking by expected free energy, and expected free energy "
           "read through the lumping at every step of a course, and the law on identical cells under noise, joined to "
           "the core's descent.",
     "which place five statements of the principle's literature, read as guarantees, where they fail; new also are "
     "the seeking form of identification, joined to seeking by expected free energy; expected free energy read "
     "through the lumping at every step of a course; the law on identical cells under noise, joined to the core's "
     "descent; and the code law for beliefs held as counts, joined to the free-energy bound in counts.")

# the UE plan and the plan for the principle
UE = ROOT / RF / 'development/ue-unified-explanation'
REC = '../../../../../../theories/becoming/results/records/'
edit(UE / 'PLAN.md', "UE16, UE17, UE18, UE19, UE20, UE21, UE22, UE23 and UE24, and holds UE8.",
     "UE16, UE17, UE18, UE19, UE20, UE21, UE22, UE23, UE24 and UE25, and holds UE8.")
FI = UE / 'FEP-INTEGRATION.md'
lines = FI.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('9. **UE24. Identical cells under noise**')]
assert len(at) == 1 and not any(line.startswith('10. **UE25.') for line in lines), at
lines[at[0] + 1:at[0] + 1] = [cited(
    f"10. **UE25. A code held as counts** (landed as the core leaf `Becoming.CountedCodes`, with [its record]"
    f"({REC}{RID}.md), study section {N}). The code law of 05 §9 for beliefs held as counts of each word for "
    "each meaning, the principle's likelihood learned as Dirichlet counts: under a determined law keeping the "
    "exchange of agents together with a renaming of the words, from a start related to itself, two exchanged agents "
    "never hold one word as each one's uniquely greatest where the renaming moves every word and is onto, or the "
    "exchange is an involution; learning from what is heard, the hearer given the meaning, keeps the relation where "
    "the speaker map commutes with the exchange and the rule reads count by count and commutes with renaming, adding "
    "the counts heard among such rules, and so does a weight on what is heard read off the whole model where the "
    "renaming leaves the weight unchanged; the free-energy bound in counts is unchanged by a renaming permuting the "
    "words, and under weights a renaming moving every word fixes, with a positive total, a belief at the bound over a "
    "listing of every word names no word. It lets the page count a fifth statement, language as an emergent property "
    "of free-energy minimization read universally (candidates 5 and 6 of UE1's search); the duet (candidate 4) stays "
    "under the code law. Witnesses: a preferred word and an asymmetric start each bring a shared word; under sampled "
    "signals the law does not apply.")]
FI.write_text('\n'.join(lines), encoding='utf-8')
edit(FI, "places each claim, with the four third parts and what the principle states that the theory cannot yet.",
     "places each claim, with the four third parts and what the principle states that the theory cannot yet. "
     "UE25 added a fifth.")

# UE1's search: a correction section appended (its candidates, which records cite, stay as written)
SEARCH = ROOT / RF / 'development/ue1-fep-bridge/THIRD-PART-SEARCH.md'
t = SEARCH.read_text(encoding='utf-8')
assert '## Correction after UE25' not in t
t = t.rstrip('\n') + '\n\n' + cited(
    "## Correction after UE25 (31 October 2026)\n\n"
    "AI-written. UE25 states the forbidding law of candidates 4–6 for beliefs held as counts, in the pure core "
    f"([a code held as counts](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-{RID}), "
    "`Becoming.CountedCodes`), after an independent review and its recheck ([REVIEW-UE25](../ue25-communicating-agents/"
    "REVIEW-UE25.md), [RECHECK-UE25](../ue25-communicating-agents/RECHECK-UE25.md)). Three points above change; the "
    "candidates stand as written on 25 October.\n\n"
    "- **Candidate 6, the scheme.** \"Agents exchange sufficient statistics rather than samples (§3.1 ¶7)\" is "
    "imprecise. In federated inference agents share posterior predictive beliefs over latent states (§3.1, "
    "Eqs. 6–8), and each learns its likelihood's Dirichlet counts privately, adding the outer product of the outcome "
    "and its posterior over states (Eq. 9), weighted by the probability of the policy to update (Eqs. 10–11), with "
    "forgetting (Eq. 12). [AI reading, D45] With the hearer given the meaning, the learning step adds the speaker's "
    "normalized predictive at the meaning, a rule of the kind `CountedCodes.hear_keeps` covers; the weighting reads "
    "the whole model, of the kind `CountedCodes.gatedHear_keeps` covers in natural weights; so the law is read as "
    "keeping the relation `CountedCodes.never_shared` needs, for a renaming the same for every meaning. That is a "
    "reading, not a theorem.\n"
    "- **Candidate 6, the premise.** \"Free-energy minimization is unchanged by permuting word labels\" is now proved "
    "in counting form: over a listing a renaming permutes, a count belief reaches the free-energy bound exactly where "
    "its renaming does for the renamed weights (`CountedCodes.bound_invariant`), and under weights a renaming moving "
    "every word fixes, with a positive total, a belief at the bound over a listing of every word has no uniquely "
    "greatest word (`CountedCodes.minimizer_no_unique_greatest`). The learning argument does not rest on it: it rests "
    "on the update keeping the symmetry (`CountedCodes.hear_keeps`, `CountedCodes.never_shared`).\n"
    "- **Candidates 4 and 6, the scope.** The duet's birds have continuous states, no word counts and no simulated "
    "learning; the law for counts does not state them, and the principle's page does not count candidate 4. A rule "
    "of learning from what is heard that does not commute with the renaming, such as saying the first word of "
    "greatest count, can bring a shared word from a symmetric start (`CountedCodes.Witness.sayFirst_shared`), so "
    "grade (b) is for a deterministic scheme keeping the symmetry. Under sampled signals the law does not apply: "
    "reinforcement reaches a signalling system (Argiento, Pemantle, Skyrms and Volkov 2009).\n")
SEARCH.write_text(t, encoding='utf-8')
print('texts: 05 thesis and §9, 08 §8, the page, UE plan, FEP-INTEGRATION item 10, UE1 search correction')
