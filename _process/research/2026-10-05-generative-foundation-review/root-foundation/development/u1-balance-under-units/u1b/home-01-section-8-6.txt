<a id="r-amounts-by-unit-matchings"></a>
**Theorem** (Flow and Web; the grammar's pairing). *Amounts, the root's second sort: balance represented by selected unit matchings, not derived.*

The census form of balance is the grammar's: a flow balances exactly where each step's lists of units pair one to one under the one (`Flow.balances_iff_units`, from `«守数当且仅当可对»`), and over a stretch the pairings at each step give one under the relation's closure (`«对之程»`, `«程守数当且仅当可对»`). What the census does not give is the matching as data, and the laws at a formation's exchange.

**Frame matchings, both ways.** A selected matching of a frame (`UnitMatchings.FrameMatch`), a bijection of its in-positions with its out-positions given as data, forces equal counts by pigeonhole with no decidability (`UnitMatchings.FrameMatch.le`, `UnitMatchings.FrameMatch.eq`, through `GrammarLaws.revisits_within`); each out-position has an in-position sent to it, and only one (`UnitMatchings.FrameMatch.predecessor_unique`). A flow over a web has such a matching at every step and condition exactly where it balances, the converse pairing by position with no choice (`UnitMatchings.FrameMatchings`, `UnitMatchings.frameMatchings_iff_balances`). By it a standing unit goes on standing or is taken, which of the two being the matching's (`UnitMatchings.FrameMatchings.next`).

**Crossing.** In a one-to-one pairing whose first block on one side is longer than the first block on the other, some member of the other side's rest is related to a member of that block (`UnitMatchings.crossing_edge`). In a balanced flow, where a family listed without repetition rises past the inflow of a family containing it, one formation taking part is such that every pairing of its exchange relates a unit it gives the risen family to another input (`UnitMatchings.rise_crossing_weak`); with beyond's inputs source-minimal, to one taken from the rest of the containing family (`UnitMatchings.rise_crossing_strong`). One formation, then every pairing; which unit crosses may depend on the pairing.

**Residual counts.** At a formation, with beyond's units numbering the source-minimal count, every pairing of what it takes from a family and beyond's units with what it gives the family and the units ending there has exactly as many endings as it takes beyond what it gives (`UnitMatchings.endings_count`); with leaving outputs kept, leaving and endings together number that (`UnitMatchings.leaving_and_endings_count`).

**Dissipation and storage.** On a family a present formation dissipates on, the source-minimal count is zero (`UnitMatchings.source_minimal_zero_of_dissipates`), and where it takes, the residual count is positive (`UnitMatchings.residual_pos_of_dissipates`); a present formation taking from a family exactly what it gives it, and something, does not dissipate on it (`UnitMatchings.lossless_not_dissipative`).

Natural-number amounts in one unit commensurable across conditions; discrete steps; positions as numbers below a count; a family as a list of conditions, a repeated condition repeating its labels; formations counted with their multiplicity among those present. The beyond, leaving and ending lists are any lists of exchange occurrences; a pairing under a relation uses its steps one to one and does not make the relation functional.

([record](../results/records/amounts-by-unit-matchings.md))

**What is not shown:**
- that balance is derived from the unfolding: every number-stated consumer of the matchings would be a round trip, and none is rerouted through them;
- that residual units are actual boundary traffic: once a formation's actual exchange outside the family is kept, their identification with actual losses fails;
- that the frame matchings and the exchange pairings are one structure: no labelled exchange pairing is shown to exist for a World's formations or attached to the frames, and a frame matching is not bridged to the grammar's pairing on labelled lists;
- line laws across steps (unique origin over many steps, the stretch law for selected matchings, residence): which unit goes where is the matching's, and lines are not World data;
- that unit continuation projects onto the World's conservation, or that renaming, re-pairing and forgetting exhaust the matchings over one World: these are the conclusions of [U1's design](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u1-balance-under-units/DESIGN.md), not theorems here.
