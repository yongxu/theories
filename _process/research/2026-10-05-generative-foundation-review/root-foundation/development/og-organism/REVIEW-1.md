# OG design: first independent reading (1 November 2026)

An AI reader (one agent, read-only, given the first draft at 02877ea2c and the sources) gave the ten findings below. Its words are summarized; every finding is taken in the second draft. [AI review, unverified except where taken.]

| # | severity | finding | taken as |
|---|---|---|---|
| 1 | high | T4's iff holds by definition: in a state net the coarse cycle is the rule's rebuild clause, and the heated room already has level → reader (01-ROOT line 35), so the thermostat meets Z too; state nets have self-loops at rest | Z is the rebuild's source (a rule fact), Y is the course (L1's horizon in the stock, L2's absorption), over a family with (c), (c′), (c″), (d) |
| 2 | high | the flame meets the guess's Z (`«火薪相须»`, the leaning goes both ways) | the guess is a reader with its own span rebuilt from the level; a cycle is not the criterion |
| 3 | high | T3 separates (c) from (d) only for long cuts and short spans; the reading order matters; the flame is absorbing too; the return was not in the net | cut length against a horizon h; the return a branch of the net; the step order stated; (c′) added; absorption with L1, not alone, separates (d) from (a) |
| 4 | high | the rooms' `exchange` moves toward the surroundings; the draft's rule is different, so the stage law is not reused | the rooms are an analogue only; the window is re-proved, its dependence on parameters stated |
| 5 | high | EL2's draw regime needs doubling draws; EL3 and conveyance live on Web/Flow; conveyance concludes only "from no step on uncrossed"; BD4 is unlanded and needs conserved listed amounts | moved to §5, part 2 after the World embedding; the supply and sink given amounts; the gated run-down named as the closer law |
| 6 | medium | `«亡于细者不必亡于粗»` is an existence witness; a bare count cannot track spans | reported as a further witness; the reader is a list of unit ages |
| 7 | medium | `«俱有»` on `«粗»` is mutual reach, not simultaneity | "one cluster with no precedence defined"; "simultaneous" and "before" dropped |
| 8 | medium | the correspondences are overstated | "a minimal case of self-maintenance below each", with each one's missing part named |
| 9 | medium | 04 §8's `LivingOrganizationCorrespondence`, 02's feeding closure and 03's acts-return are missed | placed in §0 |
| 10 | low | the "new" column is too generous | only L1 and L2 (and the family law they give) are counted as new |

## Re-check of the second draft

The same reader re-checked the second draft, and simulated the rule as written by hand-sized runs ([sim/sim.py](sim/sim.py), [sim/alt.py](sim/alt.py)). Findings 2 and 4–10 were resolved; 3 was resolved in structure, its horizon wrong. Every new point is taken in the third draft:

| # | severity | finding | taken as |
|---|---|---|---|
| R1 | high | L1's "strictly increasing in L₀" is false: h never decreases but rises in jumps, h(0) = h(1) | h nondecreasing and unbounded; for n = 1, h(L₀ + s + 1) = h(L₀) + s, checked by OU's owner on s = 2..5, L₀ < 30, to be proved; (c′)'s horizon s, whatever L₀ is, named as the separating content |
| R2 | high | h depends on n and on the starting ages | every start fixed: n units of age 0; h(L₀, s, n) |
| R3 | medium | the rebuild replaces the last unit in the same step | the line ends at the first state with an empty list; L2 a one-step invariant |
| R4 | high | (d) never holds its set level with the supply on, which breaks "level held", L3 and the window claim; moving the read after the rebuild kills every member | the class is "reader present"; L0 (kept while supplied, even under an extra draw each step, checked by OU's owner in runs) added; the window claim dropped |
| R5 | medium | L2 does no separating work in the family law | the family law on L1; L2 a fact of (d), its contrast with (c′); (c″) and (a) absorbing too |
| R6 | medium | the read step is ambiguous; the draw at L = 0, cut timing and (b)'s intake unstated | units read in turn; nothing drawn at 0; a cut or return before step 2; (b) takes in only where L < m |
| R7 | low | Z is a parameter of the rule, so "exactly where" holds over the listed members | said so |
