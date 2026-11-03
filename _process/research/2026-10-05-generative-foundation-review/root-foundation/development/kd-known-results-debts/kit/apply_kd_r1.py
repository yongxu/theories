# KD: the column read by three independent readers; their fourteen findings taken.
import os, sys
W = sys.argv[1]
F = os.path.join(W, 'theories/becoming/chapters/08-METHOD.md')
s = open(F, encoding='utf-8').read()
R = '../results/records/'
E = [
 ("convergence to a stable age structure (Lopez 1961)", "convergence to a stable age structure (Sharpe and Lotka 1911; Lotka 1939; Lopez 1961)"),
 ("Zielonka's realization of a global law by local automata (1987)", "Zielonka's theorem (1987), every regular trace-closed language accepted by a finite asynchronous automaton, a global finite-state specification realized by local components"),
 ("recurrence of almost every point on a space of finite measure, and Kac's mean return time", "recurrence, under a map preserving a finite measure, of almost every point of a set of positive measure, and Kac's mean return time (1947)"),
 ("here each left out alone, and a few pairs", "here each left out alone (`World.independent`), and no pair is shown to fail together"),
 ("stability in continuous time, rates of convergence and LaSalle's largest invariant set", "stability in continuous time, exponential or asymptotic rates and LaSalle's largest invariant set (here discrete rest, bounding how many falls and not when rest comes, with the discrete invariance principle)"),
 ("(here counting is one weighting of a class, and mixed pairs are left open)", "(here counting is the case 1 / 1 of weights within a ratio and ranks mixed pairs by number, but no axioms are shown to force it)"),
 ("restraint kept by an equilibrium of the game repeated without end (the folk theorem; here every horizon is finite)", "restraint kept by punishing strategies in an equilibrium of the commons played without end (folk theorems: Fudenberg and Maskin 1986 for repeated games, Dutta 1995 for dynamic ones; here every horizon is finite)"),
 ("Perron–Frobenius: an irreducible web grows at its Perron root, in a positive eigenvector's proportions (here bounds, `(1 + M) ^ a` above and doubling below)",
  f"Perron–Frobenius: an irreducible web has a positive eigenvector at its Perron root and grows at that rate, and a primitive one settles into its proportions (here, in the core, `(1 + M) ^ a` above and, around a loop, one plus the product of its strengths a turn below; the periphery's rate decides vanishing and runaway ([record]({R}what-discrete-steps-and-whole-amounts-represent.md)) and is not shown to be the Perron root)"),
 (f"liveness of free-choice nets by siphons and traps (Commoner; Hack 1972), structural boundedness, and decided coverability and reachability (Karp and Miller 1969; Mayr 1981; here siphons of one place, [the record]({R}place-transition-nets-on-the-spine.md)); the entropy balance itself is stated in counts (`Flow.Balances.stock_gained`)",
  f"liveness of free-choice nets by siphons and traps (Commoner; Hack 1972; here siphons of one place, [the record]({R}place-transition-nets-on-the-spine.md)), structural boundedness, and decided coverability and reachability (Karp and Miller 1969; Mayr 1981)"),
 ("its general additive form being stated;", f"its general additive form being stated (`SelectionLevels.rises_iff_reading`, [record]({R}selection-with-returns-to-groupmates.md));"),
 ("Eigen's threshold by sequence length and the quasispecies of many classes |", f"Eigen's threshold by sequence length and the quasispecies of many classes; the long-run state under rare mutation (Fudenberg and Imhof 2006), the risk-dominant state selected as noise vanishes (Kandori, Mailath and Rob 1993; Young 1993; [not stated]({R}drawn-shaping-drawn-one-at-a-time.md)) and the one-third rule under weak selection (Nowak and others 2004) |"),
 ("and four others searched the repository to refute each item; two items were found already stated, Sen's graded comparisons ([07](07-SIGNIFICANCE.md#r-weights-within-a-ratio-agree-past-it)) and the entropy balance in counts, and dropped, and Fisher's theorem",
  "and four others searched the repository to refute each item. Three items were dropped as already stated, Sen's graded comparisons ([07](07-SIGNIFICANCE.md#r-weights-within-a-ratio-agree-past-it)), the entropy balance in counts ([05](05-COLLECTIVES.md#r-a-rise-past-the-inflow-is-drawn-from-beyond)) and Haldane's load (one line on `Mutation.kept_share`); Fisher's theorem"),
 ("leave out ([study]", "leave out; three further readers checked the column as written, and their fourteen findings were taken ([study]"),
]
for a, b in E:
    assert s.count(a) == 1, (s.count(a), a[:70])
    s = s.replace(a, b)
open(F + '.tmp', 'w', encoding='utf-8').write(s); os.replace(F + '.tmp', F)
print('applied', len(E))
