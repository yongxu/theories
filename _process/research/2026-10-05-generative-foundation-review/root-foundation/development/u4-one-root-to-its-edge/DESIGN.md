# U4, lever 1: balance and the root (design, reviewed)

AI-written design for U4, "one root to its edge" ([proposal](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#one-root-to-its-edge-a-proposal-30-october-2026), [board row](../../../../../BECOMING-WORKBOARD.md)), lever 1: balance joined to the root.

- **Inputs.** It reads U1's reviewed verdict ([U1's design](../u1-balance-under-units/DESIGN.md), §0, §2 and §7). It applies the proposal's round-trip test, with the condition OU's owner set on that test.
- **Review.** It was reviewed once, independently ([REVIEW-U4-L1.md](REVIEW-U4-L1.md)): sound with fixes, two findings blocking. Every finding is taken (§7).
- **Lever 2.** [Lever 2's audit](LEVER-2-AUDIT.md), of the 18 evolution rows, sits beside this design.
- **No package Lean is claimed.**

**Scratch.** Four modules, 81 theorems in 97 declarations, every axiom report empty. They were built with `scratch_build.py` from this branch's package, whose files equal main's at `cd82afed6` ([log](scratch-build.log)):

| Module | Theorems / declarations | Content |
|---|---|---|
| [U4Scratch](scratch/Becoming/U4Scratch.lean) | 43 / 51 | the pairing laws, the place reading and the census (§2.1–§2.6) |
| [U4Repairing](scratch/Becoming/U4Repairing.lean) | 15 / 18 | re-pairing (§2.7) |
| [U4Bridge](scratch/Becoming/U4Bridge.lean) | 6 / 7 | the census on `«续» R E` (§2.8) |
| [U4Across](scratch/Becoming/U4Across.lean) | 17 / 21 | the census across a run, the review's witnesses, and `countIn` as `List.countP` (§2.9, §2.6, §5) |

The recount of §1 is [anchor_recount.py](anchor_recount.py), with its output in [anchor-recount.json](anchor-recount.json). Names are provisional.

## 0. The verdict (reviewed)

**The round trip fails its second test, so U1's verdict stands.**

The proposal set two tests. The lift counts only if:
1. the consumers' balance hypothesis gets a root reading with its witnesses; and
2. something read on unit lines is not read on counts.

"If either fails, U1's verdict stands and the failure is written here."

By the condition OU's owner set, a law of lines counts for the second test only where it holds for every pairing the counts admit. Nothing lever 1 found does. So:
- no row moves;
- the numbers stay the root's second sort;
- F13's reason ("balance needs amounts") stands.

**(i) is met as a representation, not a derivation.** Balance holds exactly where some one-to-one census model counts it. This holds at a step and a condition (`balances_at_iff_census`), and across a run (`balances_iff_census_run`). A census model has:
- units listed once;
- a continuation that fixes successors and predecessors;
- the levels as its lengths;
- what is given and taken as the units arising and ceasing, with as many more passing.

The model is built from the numbers, as in `Flow.balances_iff_units` and U1's `kunits_iff_balances`.

For a model in hand, one-to-one continuation together with the census equalities gives balance (`balances_at_of_census`). Those equalities are balance restated relative to the census. The reading would become a derivation only where the model is a World's own occurrences under `«续» R E`. That bridge is open (§4).

**(ii) fails.** What unit lines read and counts do not is whether a pairing under continuation exists.
- `split_and_merge` shows that pairing failing at balanced counts. The failure is found by a count on a region closed under the continuation.
- One-to-one continuation is sufficient for the pairing, not necessary (`pairs_without_one_to_one`).
- The counts fix neither the pairing nor one-to-one continuation (`same_counts_other_lines`).

U1 §7, in full: "If a line law over every selected matching (unique origin, Little's law) reads something the counts do not, the second sort's interface gains a law of lines." That condition is not met.

**The premise is U1's, not a second one.**
- In U1, every selected matching is a frame bijection (`FrameMatch`). Restricted to the units standing before and after a step, every U1 selection therefore continues one to one, and there the census reads only counts.
- `split_and_merge` lies outside U1's selections.
- One-to-one continuation is U1's atomism of amounts stated in the root's words. In U1's terms, amounts are counts of units, each continuing as one. In the root's terms, units begin (`«生»`), end (`«亡»`) and continue as one (`«定后»`, `«定前»`).
- Like U1's atomism, it rests on natural-number amounts.

**What lever 1 adds.** Each item holds for every pairing the counts admit (§2.7).

- **Laws of the pairing, on the grammar.**
  - A pairing keeps the count on every region it does not cross (`«对则闭域守数»`).
  - Under a class decided by a test, a pairing exists exactly where every class holds equally many (`«类之对当且仅当类类等数»`).
- **The census as a pairing.**
  - Where units listed once continue one to one, the units before with those arising pair with the units after with those ceasing (`census_pairs`). This puts a pairing behind the census equation, `Census.balanceFrom_eq_at`'s, on bare lists.
  - It holds on `«续» R E` (`census_on_continuation`).
  - On a closed step, its arising and ceasing are exactly the root's beginnings (`«生»`) and endings (`«亡»`) (`arising_iff_begins`, `ceasing_iff_ends`).
- **One continuation across a run.**
  - A balanced flow is counted by one run of unit lists under one continuation. The units after each step are the units before the next (`balances_iff_census_run`).
  - U1's ledger lists a global continuation graph as not established for its frames. This gives one, as a representation.
- **The place reading.**
  - Balance over a listed family at a step is one pairing under sameness (`balancesOn_iff_place`).
  - It is equivalent to `Flow.balancesOn_iff_units` (`place_iff_units`): a gain in form, not in content.
- **Witnesses** (§2.6).

**Modelling assumptions.** The laws above depend on these:
- amounts are natural numbers: levels, given and taken are list lengths, and `place` repeats a condition;
- steps are discrete;
- units and conditions are finite lists;
- continuation and equality are decided by Boolean tests;
- units are labelled by `Nat` in the representation laws;
- the pairing relation "a continuation, or the same unit" uses equality on the unit carrier, which the grammar names a commitment of the model.

## 1. Found at claim, corrected

At claim, this design said the 31 central declarations under "balance, represented" all read `Flow.Balances` or `Flow.BalancesOn`. The review found that wrong (F3). A recount by anchor over the [measure](../gw-generation-and-widening/measure-grammar-after.json) gives:

| Balance anchor reached | Distinct declarations |
|---|---|
| `Flow.Balances` or `Flow.BalancesOn` | 18 |
| `balance_over_stretch_on` only | 10 |
| `Flow.BalancesBetween` only | 2 |
| `Flow.BalancesBetween` and `balance_over_stretch_on` | 1 |

The measure has 39 rows in this category. They hold 31 distinct declarations, eight of which appear in two rows.

- **The ten that rest only on `balance_over_stretch_on`.** That anchor is a law of counting in the prelude: a count balanced at each step of a stretch is balanced over the stretch. These rows read no flow's balance. Each one supplies or proves its own per-step count.
- **The two census rows.** Two of the ten, `Listed.coming_of_ceasing` and `CensusWebs.keep_pace`, count the comings and ceasings of a listed family. `census_pairs` reaches them most directly: each member continues only itself, so the census applies with continuation as identity on the listed members.
- **Locality.** `Continuity`'s locality (`balancesOn_iff_conserved`) reaches none of the 31 directly, so that half of the claim-time finding stands. The 18 rows that read a flow's balance read `Flow F C`, where formations are apart from conditions.

## 2. What the scratch proves

### 2.1 A pairing keeps the count on every region it does not cross

- `«对则闭域守数»`: suppose `«对» R a b` holds, and `R` never crosses a region read as a test (related units lie both in it or both outside it). Then `a` and `b` hold equally many units in the region.
- `«对则闭域守数'»`: the same, with the region stated as `«闭» R` and `«闭» («逆» R)`. `closed_both` joins the two forms.
- `split_and_merge`'s own proof is such a count, on a region closed both ways under the continuation. So locality at the grain of the continuation's regions does read what counts do not. The World does not fix those regions.

### 2.2 The count law of a class

- `«类之对当且仅当类类等数»`: for a class `E` (`«类»`) decided by a test `e`, `«对» E a b` holds exactly where `countIn (e z) a = countIn (e z) b` for every `z`.
- **Under the one**, the law is equal length (`one_case`, a reproof of `«一之对»`).
- **Under sameness of conditions**, inside `balancesOn_iff_place`, it is equal multiplicity of each condition. Sameness and place are that one instance; there is no standalone corollary.
- `«续之对则类类等数»` is a corollary of `«对之单调»` and the class law. Continuation relative to a class lies within the class, so a pairing under `«续» R E` keeps the count in every class of `E`.
  - It adds to equal count only where `E` is finer than the one. `teleport` (`[0]` and `[1]`, paired under the one and not under sameness) witnesses that it adds something there.
  - It states part of what the grammar's header leaves open ("that a pairing under continuation adds anything to equal count, which is not stated"), not all of it.

### 2.3 Balance along a relation, as `«闭»` regions

- `closes_iff`: a family that `Continuity` calls closed is exactly a `«闭»` region under adjacency among the listed relata.
- `balancesOn_iff_closed`: `Continuity.balancesOn_iff_conserved`, with its families read as `«闭»` regions. This is a restatement, and it reaches none of the 31.
- The proposal's sub-claim (a) asked for `«所闭»`. That `«闭»` and `«所闭»` agree on a finite listed set is not proved here.

### 2.4 Balance over a listed family as one pairing under sameness

- `place q cs` lists each condition `c` of `cs`, `q c` times.
- `balancesOn_iff_place`: over a listed family `cs` at one step, with sameness decided by a test, `L.BalancesOn W cs t` holds exactly where `«对» «静» (place (W.level t) cs ++ place (L.given t) cs) (place (W.level (t+1)) cs ++ place (L.taken t) cs)`.
  - Its scope is `BalancesOn` over a listed family at one step. No corollary for `Flow.Balances` over an unlisted `C` is stated.
  - The levels are recovered from the lists (`countIn_place`, `total_pick`).
  - "Listed once" is used for convenience. With a condition repeated, the counts multiply and cancel.
- `place_iff_units` (U4Across): the place reading is equivalent to `Flow.balancesOn_iff_units`.
  - By the class law, it is per-place Hume's principle, the near-definitional case WHAT-REMAINS names.
  - It replaces one existential per condition with one pairing between fixed lists.

### 2.5 The census, as a pairing

- **`census_pairs`.** Units are listed once before and after a step, under a continuation decided by `k`.
  - `arising` lists the units after that continue none before. `ceasing` lists the units before that none after continues.
  - Suppose that among the listed units, none continues as two and no two continue as one. Then `before ++ arising` is paired with `after ++ ceasing` under "a continuation, or the same unit".
- **`census_pairs_of_fixed`.** The same, with global `«定后»` and `«定前»`; a corollary of the local form.
- **`census_balance`.** The count consequence: `after + ceasing = before + arising`. This is `Census.balanceFrom_eq_at`'s equation (in `Identity`, on formations active on a web), here on bare lists. No instance theorem joins the two.
- **`balances_at_of_census`.** A flow balances at a condition and step where:
  - the levels count the units;
  - what is given and taken counts the units arising and ceasing, plus the same number passing.

  At one step it is a corollary of `Flow.balances_of_matched`: add the passing units on both sides, paired by sameness. Its equalities for given and taken are balance restated relative to the census.

### 2.6 Witnesses

| Witness | Module | What it shows |
|---|---|---|
| `split_breaks` | U4Scratch | One unit continues as two. Nothing arises or ceases, and one before is not two after, so no pairing under any relation holds |
| `merge_breaks` | U4Scratch | The same for two units continuing as one |
| `split_and_merge` | U4Scratch | A split and a merge at one step. Nothing arises or ceases, and the count balances (paired under the one), yet no pairing under continuation or sameness holds. The region holding the unit that split and its two continuations is closed both ways; it holds one unit before and two after |
| `pairs_without_one_to_one` | U4Across | A split, then a merge into one of its continuations. Nothing arises or ceases, and the pairing under continuation holds, though the continuation fixes neither successors nor predecessors. One-to-one continuation is sufficient for the census pairing, not necessary |
| `repeated_unit` | U4Across | A unit listed twice before a step. No split or merge among the listed units and nothing arises or ceases, yet the census balance fails. Listing once is needed |
| `same_counts_other_lines` | U4Repairing | The same counts under two continuations: one admits the census pairing and one does not (§2.7) |
| `unlisted_predecessor` | U4Bridge | Closure of the listing is needed for arising to be beginning (§2.8) |
| `teleport` | U4Scratch | Equal count, with no pairing under sameness. It separates the one from sameness in the place reading. It witnesses no hypothesis of the census |

### 2.7 Re-pairing

Written for OU's condition.

- `same_counts_other_lines`: three units before and three after, with nothing arising or ceasing, under two continuations. `oneToOne` admits the census pairing; `splitAndMerge` (a split and a merge) admits none. Arising and ceasing are equal under both, and so are all counts.
- `census_model`: for any `d`, `out` and `into`, a unit model where `d` units stay, `out` cease and `into` arise, whose continuation fixes successors and predecessors (`«定后»`, `«定前»`).
- `census_counts`: where `m + T = n + G`, the four counts split into staying, ceasing, arising and passing: `d + out = n`, `d + into = m`, `into + passing = G`, `out + passing = T`.
- `balances_at_iff_census`: a condition's balance at a step holds exactly where some unit model counts it, the model having:
  - units listed once before and after;
  - a continuation that fixes successors and predecessors;
  - the levels as its lengths;
  - what is given and taken as its arising and ceasing, plus as many passing.

Each law, by OU's condition:

| Law | Holds for every pairing the counts admit? |
|---|---|
| `«对则闭域守数»`, `«对则闭域守数'»`, the class law, `«续之对则类类等数»` | Yes. They are laws of every pairing under the relation, and choose no lines |
| `closes_iff`, `balancesOn_iff_closed` | Yes. They restate a law on counts |
| `balancesOn_iff_place`, `place_iff_units` | Yes. The place lists are fixed by the counts, and any pairing under sameness between them is one the counts admit |
| `census_pairs`, `census_pairs_of_fixed`, `census_balance`, `balances_at_of_census`, `census_on_continuation` | Only as implications. Each holds of every model meeting its hypotheses, but whether a model meets them depends on its lines (`same_counts_other_lines`). The hypotheses are the premise, which is U1's (§0) |
| `balances_at_iff_census`, `balances_iff_census_run` | Yes. Both sides are about counts |

### 2.8 The census on continuation

The census of §2.5 is stated on a continuation `k` over listed units. U4Bridge states it on the grammar's `«续» R E`, decided by a test.

- `census_on_continuation`: where `«续» R E` fixes successors and predecessors (`«定后»`, `«定前»`), `before ++ arising` is paired with `after ++ ceasing` under "`«续» R E`, or the same unit".
- `arising_iff_begins`: where every predecessor of a unit after the step stands before it, the units the census lists as arising are exactly the units after that begin (`«生» R E`).
- `ceasing_iff_ends`: where every successor of a unit before the step stands after it, the units listed as ceasing are exactly the units before that end (`«亡» R E`).
- `unlisted_predecessor`: closure is needed. With `1` continuing `0` and only `1` listed, the census counts `1` as arising, and `1` does not begin.

So on a closed step, the census counts the root's beginnings and endings, not a list-relative stand-in.
- **Closure** is a hypothesis about the listing: the units listed at a step are all the predecessors and successors there are.
- **What is supplied:** the continuation is decided by a test and the listing is given. This joins the census to the grammar's words, not to a World's occurrences (§4).

### 2.9 Across a run

OU's owner asked whether the one-step models glue across steps before calling that point open. They do, with no relabelling, by giving each time one list.

- **`census_run`.** Take counts balanced at every step. Each time's units are an interval of labels starting from the oldest unit standing, and the oldest units cease first.
  - `splitOf` reads staying, ceasing, arising and passing off the counts.
  - `interval_census` counts the census of two intervals.
- **`balances_iff_census_run`.** A flow balances exactly where, for each condition:
  - there is one list of units at each time, under one continuation that fixes successors and predecessors;
  - the lists have the levels as their lengths;
  - at each step, what is given and taken is the units arising and ceasing, with as many more passing.

  The units after each step are the units before the next, so continuation composes along the run.
- **A representation.** The lists are built from the numbers, and the continuation is identity on labels.
- **What it adds.** It is the global continuation graph that U1's ledger lists as not established for `FrameMatch`, given here at the census grain. The grain is one condition at a time, so a unit moving between conditions ceases at one and arises at the other (§4).

## 3. The round trip, item by item

The proposal's test: "The lift counts only if two things hold … If either fails, U1's verdict stands and the failure is written here."

- **(i) Represented both ways, not derived.**
  - `balances_at_iff_census` at a step, `balances_iff_census_run` across a run, `balancesOn_iff_place` for a listed family at a step. Each is built from the numbers.
  - `balances_at_of_census` gives balance from a one-to-one model in hand, and its premises restate balance relative to the census.
- **(ii) Fails by OU's condition.**
  - Under a class, a pairing reads exactly the per-class counts (the class law). So at the place grain, locality reads nothing beyond counts.
  - At the grain of the continuation's regions, a count does read something. `split_and_merge` has balanced counts and no pairing under continuation, and a count on a region closed under the continuation finds this. What lines read beyond counts is whether a pairing under continuation exists, a Hall-type condition.
  - One-to-one continuation is sufficient for that pairing and not necessary (`pairs_without_one_to_one`). The counts fix neither (`same_counts_other_lines`). Neither is a law over every pairing the counts admit.
  - WRT's F1 (two idle Worlds standing at 1 and at 2, alike on every field): `place` and `countIn_place` carry the standings in the grammar's lists. This is a reading. No Lean ties `place` to `WorldRepresentation`.
- **The failure, written here.** No law of unit lines both holds over every pairing the counts admit and reads what the counts do not. U1's verdict stands.

## 4. What is not shown

- **A derivation.** It is not shown that a World's own occurrences, listed at each step under the World's `«续» R E`, with each listing closed, are a census model. U4Bridge states the census on a decided `«续» R E` with a supplied listing, and nothing joins it to a World. Where that held, balance would follow for that World rather than be represented.
- **The two readings, joined.**
  - Place units are copies of condition labels with no identity, so continuation is undefined on them.
  - The census is per condition, so a unit moving between conditions ceases at one and arises at the other. A teleport taken at `0` and given at `1` passes the census at each.
  - Neither reading sees transfers between conditions, and no theorem relates the two. One would go through a unit model with a place map `U → C`.
- **The 31 rows.** No row moves.
- **Formations.** The census counts what a flow gives and takes at a condition. It does not say which formation does so, and it uses no locality through formations.
- **A relation that is not a class.**
  - Beyond the forward law (§2.1), pairings under a relation that is not a class are not characterized. That needs Hall's condition, not counts.
  - `Continuity`'s transfers may pass through, which makes only the components count.
- **Known results.**
  - **Outside the package.**
    - The class law is equality of multisets, class by class.
    - The census is bookkeeping.
    - Gale (1957) and Hoffman (1960) give flow feasibility by components.
  - **`World.balanced_reidentify_iff`** (`Persistence`): "The namings under which a world balances are exactly its one-to-one continuations within conservation." This is the package's existing join of balance and one-to-one continuation, at the grain of relata, with continuation read off conservation. The census makes the same join at the grain of units, with continuation as a relation and balance from counting.
  - **The package's representations:** `Flow.balances_iff_units`, `Flow.balancesOn_iff_units`, and `Flow.balances_of_matched`, of which `balances_at_of_census` is a corollary at one step.
  - **`Census.balanceFrom_eq_at`**, whose equation `census_balance` repeats on lists.
  - **U1's `kunits_iff_balances`** (scratch). `balances_at_iff_census` reads it in census vocabulary, with four blocks (staying, ceasing, arising, passing), at one condition and step.

## 5. Placement (nothing claimed)

- **Beside `«对»` in `Becoming.GrammarLaws` (rule 9).** These are laws of the pairing:
  - `«对则闭域守数»`;
  - the class law, with its count. `countIn` is `List.countP`'s structural twin, proved equal with no axiom (`countIn_eq_countP`). It is kept because Init's lemmas on `List.countP` (`countP_cons`, `countP_append`, `countP_congr`) report `propext`. At the rebuild it enters beside `«对»` as `«计»`, or as whatever word the grammar's counting vocabulary takes, with that sentence in its docstring (OU's decision). The law's docstring also says that regions read as Boolean tests are a modelling choice, and that a Prop region enters by `decide` under `DecidablePred`;
  - the census pairing, with its bridge to `«生»` and `«亡»` (U4Bridge imports only the grammar laws and the census).

  They ride the planned near-full rebuild of grammar-wide laws, and stay in this kit until then (OU's decision on U4).
- **Above `Becoming.Flow`.** These are the representations: the place reading, and the census at a step and across a run.
  - They add no content to Flow's own representations, so they are placed only if a consumer needs their form.
  - `Flow` has no active owner, so by rule 3's fallback OU's owner decides.
- **Next candidate, its own item:** the two census rows (§1), where the census pairing could put a pairing behind their per-step count.
- **Not a candidate:** lever 2's row 5 (`no_new_dependence`). It needs no census. It holds under the inclusion that coming to stand is given to (`no_new_dependence_of_given`, in [lever 2's audit](LEVER-2-AUDIT.md)), and a route through the census's given count would be balance restated (F1).

## 6. What would change this

- **A law of unit lines** that holds over every pairing the counts admit and reads what they do not. Then (ii) is met, and U1 §7's condition holds.
- **A World's own occurrences as a census model**, under its `«续» R E` with closed listings. Then balance is derived for those Worlds, not represented.
- **A transport that needs more than the census hypothesis.** If a row's transport needs more (for example, the row reads which formation draws), that row keeps "balance, represented", with its reason.

## 7. The review's findings and where each is taken

| Finding | Taken in |
|---|---|
| F1 (blocking): "derived", "not a supplied equation", "the census of the root's `«生»` and `«亡»`" overclaim | §0, §2.5 and §3 now say "represented, not derived" and drop "not a supplied equation". F13's reason stands. `«生»` and `«亡»` are joined only on a closed step with a decided `«续» R E` (§2.8), and to a World not at all (§4) |
| F2 (blocking): the verdict ignores its own test; U1 §7 quoted with its quantifier cut | §0 leads with the failure of (ii) and quotes U1 §7 in full. U1's frame bijections make the premise U1's own (§0). `balances_at_iff_census` is named as `kunits_iff_balances` read in census vocabulary (§4) |
| F3: not all 31 rows read `Balances`/`BalancesOn` | §1, recounted by anchor; the two census rows named as candidates (§5). The board line is corrected at landing |
| F4: locality detects the split and merge; one-to-one is not necessary | §2.1, §3 (ii); `pairs_without_one_to_one` built (U4Across) |
| F5: "each hypothesis shown needed" overclaims | `repeated_unit` built; `teleport`'s role stated; "listed once" in the place reading marked as convenience (§2.4, §2.6) |
| F6: the place reading's scope; equivalent to `balancesOn_iff_units`; readings not joined | §2.4, with `place_iff_units` built; §4 |
| F7: known package results uncited | §2.5, §4 |
| F8: modelling assumptions | §0 |
| F9: the class law's cases | §2.2 |
| F10: `«闭»`, not `«所闭»` | §2.3 |
| F11: global form a corollary of the local | §2.5 |
| F12: F1 a reading | §3 |
| F13: `«续之对则类类等数»` a corollary; `teleport` witnesses what it adds | §2.2 |
| F14: names | `compensation` renamed `split_and_merge`, `compensating` renamed `splitAndMerge`; `countIn` decided by OU: kept as `List.countP`'s twin, `«计»` at the rebuild (§5); "the census pairing stated on `«续» R E`" now names its scope (§2.8, §5) |
| F15: build provenance | Header: built from this branch's package, equal to main's at `cd82afed6`; `U4Bridge` builds (6 theorems in 7 declarations), and every module is built by name |
