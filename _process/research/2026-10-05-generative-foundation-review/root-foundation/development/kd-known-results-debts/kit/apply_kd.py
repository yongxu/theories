# KD: a fourth column in 08 §8's table, what the closest prior results state that the account does not yet.
import os, sys
W = sys.argv[1]
F = os.path.join(W, 'theories/becoming/chapters/08-METHOD.md')
s = open(F, encoding='utf-8').read()
R = '../results/records/'
CELLS = [
    ('[Coming and ceasing keep pace]',
     f"rates: vital rates, Lotka's renewal equation and convergence to a stable age structure (Lopez 1961), and Little's law, of which a finite form is only proposed; the Foata normal form and infinite traces ([not built]({R}order-of-exchanges-is-the-invariant.md)); Zielonka's realization of a global law by local automata (1987)"),
    ('[Recurrence]',
     f"recurrence of almost every point on a space of finite measure, and Kac's mean return time (the laws here need a list of the configurations); Landauer's bound in energy, kT ln 2 ([not derived]({R}merge-of-a-part-kept-by-the-rest.md): the count only); Bennett's uncomputation, which returns the history to blank (only the history kept)"),
    ('[Premises carve parts]',
     "separations by realizability and Kripke models: WLPO does not give LPO ([§5](#calibrations) cites it, not checked), LLPO does not give WLPO, Markov's principle is independent of LLPO (here implications and equivalences only); complete independence of the premises (Moore 1910): here each left out alone, and a few pairs"),
    ('[Rest needs a least loss]',
     f"the converse, a ranking for every terminating relation, classical with choice ([open]({R}rest-exactly-where-falls-stop.md)), and the converse Lyapunov theorems; stability in continuous time, rates of convergence and LaSalle's largest invariant set; chip-firing's independence of the order of firing and its thresholds in chips (Björner, Lovász and Shor 1991)"),
    ('[How two courses differ in what can form]',
     "Pattanaik and Xu's axioms, which force the ranking by number (here counting is one weighting of a class, and mixed pairs are left open); rankings of sets by diversity, where a near-duplicate adds less than a distinct option (Weitzman 1992; Nehring and Puppe 2002)"),
    ('[Closures]',
     f"Blackwell's equivalence over noisy experiments and priors, worth in every decision exactly where the other is a garbling, and sufficiency (here deterministic, with a converse in expressibility); Pearl's do-calculus and identification by the back-door and front-door criteria ([not stated]({R}causal-models-as-processes.md)); Zhuang and Hadfield-Menell's continuous setting, and the gain a re-read proxy brings ([record]({R}what-an-optimum-does-beyond-what-couples-in.md))"),
    ('[Joint excess]',
     "the interior equilibrium of a common pool where each bears a share, nearer open access as drawers multiply (Gordon 1954; Dasgupta and Heal 1979; here only the corner, [drawing at once](05-COLLECTIVES.md#r-drawers-in-turn)); restraint kept by an equilibrium of the game repeated without end (the folk theorem; here every horizon is finite); Frank's race between positional and other goods (1985), over-allocation being that field's frame"),
    ('[Learning and identification]',
     f"Gold's theorem that no class holding every finite language and one infinite language is identifiable from text, and Angluin's tell-tales (1980); Kelly's converse, a method for every countable union of closed readings (credited in the [record]({R}what-a-method-comes-to-say-in-the-limit.md), not shown); Moore's limit on finding the initial state from one copy (here only what an untaken act would do)"),
    ('[Significance not in the dynamics]',
     "Hume's law for relevant consequence, with mixed premises and bridge principles (Schurz 1997), and Prior's counterexamples to the plain form; Parfit's mere addition, the Repugnant Conclusion and the non-identity problem (C ranks a costless addition better; [the philosophy dossier](../review/PHILOSOPHY.md) keeps what it owes open)"),
    ('[Loops]',
     "Perron–Frobenius: an irreducible web grows at its Perron root, in a positive eigenvector's proportions (here bounds, `(1 + M) ^ a` above and doubling below); the sign of a loop from its links' signs (Maruyama 1963) and Thomas's rules for which circuits multistability and oscillation need"),
    ('[Fed from beyond]',
     f"least entropy production near equilibrium and dissipative structures formed by bifurcation (Prigogine); liveness of free-choice nets by siphons and traps (Commoner; Hack 1972), structural boundedness, and decided coverability and reachability (Karp and Miller 1969; Mayr 1981; here siphons of one place, [the record]({R}place-transition-nets-on-the-spine.md)); the entropy balance itself is stated in counts (`Flow.Balances.stock_gained`)"),
    ('[Evolution on descent]',
     "Fisher's theorem under inexact transmission, with the environment term (Price 1972), and a solution of the normal equations ([here given](04-LIFE.md#r-the-breeding-value)); Hamilton's rule with synergy (Queller 1985) and with assortment changing over generations, its general additive form being stated; group reproduction with migration (Traulsen and Nowak 2006)"),
    ('[Drift]',
     "Kimura's fixation with selection in sampled generations, and the neutral rate of substitution (mutation with drift is not stated here); drift's time scales, variation lost by `1 − 1/N` a generation and fixation in a time of order `N` (here a crude bound); Eigen's threshold by sequence length and the quasispecies of many classes"),
]
old_head = '| Central result | Closest prior result | Verdict |\n|---|---|---|\n'
assert s.count(old_head) == 1
s = s.replace(old_head, '| Central result | Closest prior result | Verdict | What it states that the account does not yet |\n|---|---|---|---|\n')
i = s.index('| Central result | Closest prior result |'); j = s.index('\n\n', i)
rows = s[i:j].split('\n')
assert len(rows) == 2 + len(CELLS), len(rows)
for k, (start, cell) in enumerate(CELLS):
    r = rows[2 + k]
    assert r.startswith('| ' + start), (k, r[:60])
    assert r.endswith(' |') and '|' not in cell
    rows[2 + k] = r + ' ' + cell + ' |'
s = s[:i] + '\n'.join(rows) + s[j:]
old_v = 'The last two rows, the evolution line of [04](04-LIFE.md), which that review did not rank, carry the verdicts of the audit of the third parts ([below](#third-parts)).'
assert s.count(old_v) == 1
new_v = old_v + (" The last column lists, for each row, what the closest prior frameworks state that the account does not yet, as of 3 November 2026: stronger theorems, quantities, continuous and stochastic forms, wider scope. Four AI readers drafted it from the literature they knew, unless a linked record names the gap, and four others searched the repository to refute each item; two items were found already stated, Sen's graded comparisons ([07](07-SIGNIFICANCE.md#r-weights-within-a-ratio-agree-past-it)) and the entropy balance in counts, and dropped, and Fisher's theorem and Hamilton's rule were narrowed to what their general forms here leave out ([study](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/kd-known-results-debts/DEBTS.md)). Each is a limit that holds so far and lapses when the account states the result; as with the free-energy principle ([the page](../FREE-ENERGY-PRINCIPLE.md)), it is work the row leaves.")
s = s.replace(old_v, new_v)
open(F + '.tmp', 'w', encoding='utf-8').write(s); os.replace(F + '.tmp', F)
print('ok')
