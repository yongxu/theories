# UE1: corrections to the note after landing

25 October 2026. AI-authored. The record [capture-by-counted-choices](../../../../../../theories/becoming/results/records/capture-by-counted-choices.md) was reviewed against [NOTE.md](NOTE.md) as it stood at the landing, and keeps citing those bytes. Corrections found afterwards are therefore stated here, not in the note. Each one names what it corrects and where the correction comes from. None changes the Lean, the record's statement or its home section.

## 1. What UE2 delivers (NOTE §3, first row, last cell)

**As written:** "the theory states belief (…) in counting form only once UE2 lands", for belief, surprisal and free energy.

**Corrected** (UE2's [review](../ue2-conditional-weights/REVIEW-UE2.md), finding 2): the principle states belief, surprisal and free energy. Once UE2 lands, the theory states two of them in counting form:

- belief, as the posterior share;
- pointwise surprisal, through the reciprocal share.

It states free energy and its bound only in the periphery, over the reals. Entropy and free energy are averages of logarithms, so neither has a counting form through reciprocal shares.

## 2. The chooser with set points (NOTE §5, reading 3)

**As written:** where the step can lose what it takes, "nothing protects what lies beyond", and a term counted after the set point "keeps the most beyond"; joint excess "holds for choosers held at set points".

**Corrected** (UE1b's [review](../ue1b-set-points/REVIEW-UE1b.md) and the landed kit, `Becoming.SetPointOptimum`, record [what-a-set-point-optimum-does-beyond](../../../../../../theories/becoming/results/records/what-a-set-point-optimum-does-beyond.md)):

- Where the family holds a condition, no asymmetric order nearing a set point is rising (`Optimum.Nearing.not_rising`), so the optimum law does not reach it as stated. Below its set point it rises, and its optima drain as a maximizer's do (`Optimum.least_below`, `Optimum.nearing_beyond`).
- Where the set point can be reached, every optimum stands at it, and nearing alone asks nothing more of what lies beyond (`Optimum.optima_iff`). In a balanced step in which the whole gains nothing, what lies beyond falls by the family's shortfall from its set point with the loss (`Flow.Balances.atSetPoint_draws`).
- Where the step can lose what it takes, the set point alone does not protect what lies beyond: the order by distance has the draining step among its optima, beside the keeping one (`Topped.nearing_either`). A term on what lies beyond, counted after the set point, does protect it there (`Topped.counted_after_keeps`).
- That term leaves what lies beyond, in total, at the most any eligible way of reaching the set point leaves (`Optimum.counted_after_most`). With several conditions beyond, it can empty one of them (`Spread.counted_after_empties`). Counting less, it drains (`Topped.counted_less_drains`). After an aspiration level it keeps too (`Drain.satisficingThen_keeps`). What protects is how the choice among equal optima is made, not the set point.
- A formation holding its family's stock, by any means, takes at least its loss from what feeds it (`Flow.held_draws`), and joint excess applies to any such holders (`Flow.held_excess_ends`). That the holders are set-point choosers re-optimizing at every step is a reading.

## 3. The third part (NOTE §7(b))

**As written:** the first candidate for a third part is a claim that belief sharing lets a collective respond to what no member couples to.

**Found** ([the search](THIRD-PART-SEARCH.md), 16 claims from 15 papers). No paper makes that claim. Every collective claim found stays within the union of the members' couplings. So UE1's own laws forbid nothing found, and UE1 stays a restatement with its third part open.

Seven claims are forbidden under a natural reading, by laws of the theory other than UE1's:

- **Symmetry.** Identical or mirror-symmetric agents are said to be guaranteed to differentiate, or to come to share a model or a language. A deterministic law that keeps the symmetry, from a symmetric start, forbids this (01's commuting law; 05 §9's shared codes). The strongest case is "Knowing one's place" (Friston, Levin, Sengupta and Pezzulo 2015): identical cells are said to be guaranteed to find unique places.
- **Joint excess and the outrun law.** Claims that risk minimization ensures an agent's needs are met, or that shared preferences make each agent's goal the group's (05).
- **Lumping, weakly.** A claim that information seeking gives self-correction (03).

Each forbids a verbal generalization, not a paper's simulation: the simulations break the symmetry with random starts and have no shared draw. Each forbidding law is a known result, symmetry breaking (Curie, Turing, Angluin) or the commons (Lloyd, Hardin). A containment widened to cite these laws could state a third part graded "forbidden under a natural reading", with its hypotheses and the known results named.
