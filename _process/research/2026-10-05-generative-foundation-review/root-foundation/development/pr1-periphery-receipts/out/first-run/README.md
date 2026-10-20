# First run's failures (PR1)

The checkers' first run on the current core (20 October 2026, `out-run1.txt`) failed for seven modules; these
are the logs of the failing Lean step (or, for TransmissionCorrespondence, the checker's closure error),
copied from the run folders, which were not kept. `entropy-production--EntropyProduction-second.log` is the
second run of EntropyProduction (after `Passing.lossless` was repointed): the `simp` of `Fluctuation.balances`
left `Witnesses.profile [0] 1 1` unevaluated, since `Flow.sign` is now defined through it.
