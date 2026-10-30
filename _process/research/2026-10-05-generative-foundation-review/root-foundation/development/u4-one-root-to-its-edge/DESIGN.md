# U4, lever 1: balance on the root (design, before review)

AI-written design for U4, "one root to its edge" ([proposal](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#one-root-to-its-edge-a-proposal-30-october-2026), [board row](../../../../../BECOMING-WORKBOARD.md)), lever 1: balance joined to the root. It reads U1's reviewed verdict ([U1](../u1-balance-under-units/DESIGN.md) §0, §5, §7) and applies U1's own round-trip test. No package Lean is claimed. The scratch is two modules, every axiom report empty, built with `scratch_build.py` against main at `3a728388e` ([log](scratch-build.log)): [U4Scratch](scratch/Becoming/U4Scratch.lean), 43 theorems in 51 declarations, and [U4Repairing](scratch/Becoming/U4Repairing.lean), 15 theorems in 18 declarations, written for the condition OU's owner set on the round trip (§2.7). Names are provisional.

## 0. The verdict, proposed

**Balance is the count of a census of units continuing one to one.** Each condition's balance, the hypothesis `Flow.Balances` that the 31 rows on "balance, represented" rest on, is read on the root two ways:

- **as a pairing:** exactly one pairing, under sameness, of the units standing at their conditions before a step together with those given, with the units standing after together with those taken (`balancesOn_iff_place`, both ways);
- **as a derivation:** it holds wherever the levels count units whose continuation fixes successors and predecessors (`«定后»`, `«定前»`), and what is given and taken counts the units arising (`«生»`) and ceasing (`«亡»`) at the condition, with as many passing through within the step on both sides (`census_pairs_of_fixed`, `balances_at_of_census`).

Each hypothesis is shown to be needed. A split and a merge each break the census (`split_breaks`, `merge_breaks`). A teleport keeps the total but not each place's count (`teleport`).

**The second half of the round trip.** One-to-one continuation is something unit lines read and counts do not. A split and a merge at the same step leave the count balanced, yet no pairing under continuation or sameness holds (`compensation`). Balance follows from one-to-one continuation, and the converse fails.

**A limit of the same kind.** Under a class, a pairing reads nothing beyond counts. Two lists are paired under a class decided by a test exactly where every class holds equally many units of each (`«类之对当且仅当类类等数»`). So a line law can read more than counts only through a relation that is not a class, such as continuation.

**Which of these hold whatever lines are chosen.** Counts admit many unit models, so a law about lines counts only where it holds for every pairing the counts admit; a law that needs one pairing chosen is a discipline and is named as a premise (the condition OU's owner set, §2.7).

- **Invariant:** balance as the existence of a one-to-one model. A flow balances at a condition across a step exactly where some unit model continuing one to one counts to it (`balances_at_iff_census`). Both sides are statements about counts.
- **A premise:** that the unit model in hand continues one to one. The same counts, with nothing arising or ceasing, admit a model that continues one to one and one that splits a unit and merges two (`same_counts_other_lines`). Under this premise balance is derived (`balances_at_of_census`); without it, it is not.

U1's verdict stands, and is sharpened. Its §7 named the condition for widening the interface: "a line law … reads something the counts do not". One-to-one continuation is the only thing found that lines read and counts do not, and it changes with the pairing, so it enters as a premise, not as a law. Lines are still not World data (U1 §5). What the lift adds is a root reading of each condition's balance at a step: not a supplied equation, but the count of a census of the root's `«生»` and `«亡»` under `«定后»` and `«定前»`. F13's reason, "balance needs amounts", becomes "balance is what a one-to-one census counts". The numbers are still a second sort.

## 1. Found at claim

The 31 central declarations under "balance, represented" ([measure](../gw-generation-and-widening/measure-grammar-after.json)) all read `Flow.Balances` or `Flow.BalancesOn`. There, formations take from and give to conditions, and each condition's level changes by what is given less what is taken. They do not read transfers between conditions along a relation. So `Continuity`'s locality (`balancesOn_iff_conserved`) reaches none of them directly. The proposal's sub-claim (a) is kept as a restatement (§2.3), and the work for the 31 goes through the place reading and the census (§2.4, §2.5).

## 2. What the scratch proves

### 2.1 A pairing keeps the count on every region it does not cross

- `«对则闭域守数»`: if `«对» R a b` holds, and a region read as a test is never crossed by `R` (related units lie both in it or both outside it), then `a` and `b` hold equally many units in the region.
- `«对则闭域守数'»`: the same, with the region stated as `«闭» R` and `«闭» («逆» R)`; `closed_both` joins the two forms.

### 2.2 The count law of a class

- `«类之对当且仅当类类等数»`: for a class `E` (`«类»`) decided by a test `e`, `«对» E a b` holds exactly where `countIn (e z) a = countIn (e z) b` for every `z`.
- Its cases:
  - the one (`«一»`), where the law is equal length (`one_case`, a reproof of `«一之对»`);
  - sameness (`«静»`), where it is equal multiplicity of each element;
  - the class of being at one place (§2.4).
- `«续之对则类类等数»`: continuation relative to a class lies within the class, so a pairing under `«续» R E` keeps the count in every class of `E`. This states part of what the grammar's header leaves open ("that a pairing under continuation adds anything to equal count, which is not stated"). It is not shown to be all it adds.
- `teleport`: `[0]` and `[1]` are paired under the one and not under sameness.

### 2.3 Balance along a relation, on the grammar (the proposal's (a))

- `closes_iff`: a family `Continuity` calls closed is exactly a region `«闭»` under adjacency among the listed relata.
- `balancesOn_iff_closed`: `Continuity.balancesOn_iff_conserved` with its families read as `«闭»` regions. This is a restatement. It reaches none of the 31 rows.

### 2.4 Each condition's balance as one pairing under sameness

- `place q cs` lists each condition `c` of `cs`, `q c` times.
- `balancesOn_iff_place`: over conditions listed once, with sameness decided by a test, `L.BalancesOn W cs t` holds exactly where `«对» «静» (place (W.level t) cs ++ place (L.given t) cs) (place (W.level (t+1)) cs ++ place (L.taken t) cs)`.
- The levels are recovered from the lists (`countIn_place` with `total_pick`), so the reading goes both ways at a step. U1's per-condition frames (`Flow.balancesOn_iff_units`) become one pairing under one class.

### 2.5 The census, as a pairing

- In `census_pairs`, units are listed once before and after a step under a continuation decided by `k`.
  - `arising` lists the units after that continue none before; `ceasing` lists the units before that none after continues.
  - Where no unit continues as two and no two continue as one, `before ++ arising` is paired with `after ++ ceasing` under "a continuation, or the same unit".
- `census_pairs_of_fixed` is the same with the two hypotheses stated as `«定后»` and `«定前»` of the continuation.
- `census_balance` is the count consequence, through `«对则守数»`: `after + ceasing = before + arising`. This is `Census.balanceFrom_eq_at`'s equation, now with a pairing behind it.
- `balances_at_of_census` gives a flow's balance at a condition. It holds where the levels count the units, and given and taken count the arising and ceasing units plus the same number passing through within the step.

### 2.6 Witnesses

| Witness | What it shows |
|---|---|
| `split_breaks` | One unit continuing as two: nothing arises or ceases, one before is not two after; no pairing under any relation |
| `merge_breaks` | The same for two continuing as one |
| `compensation` | A split and a merge at the same step: nothing arises or ceases, the count balances (paired under the one), and no pairing under continuation or sameness holds. The region of the unit that split and its two continuations, closed both ways, holds one unit before and two after |
| `teleport` | Equal count, no pairing under sameness |

### 2.7 Re-pairing

Written for OU's condition, in a separate module so the reviewed one is unchanged.

- `same_counts_other_lines`: three units before and three after, with nothing arising or ceasing, under two continuations. `oneToOne` admits the census pairing; `compensating` (a split and a merge) admits none. Arising and ceasing are equal in both, and so are all counts.
- `census_model`: for any `d`, `out` and `into`, a unit model where `d` units stay, `out` cease and `into` arise, with `«定后»` and `«定前»` of its continuation.
- `census_counts`: where `m + T = n + G`, the four counts split as staying, ceasing, arising and passing (`d + out = n`, `d + into = m`, `into + passing = G`, `out + passing = T`).
- `balances_at_iff_census`: a condition's balance at a step holds exactly where some unit model, listed once before and after, with a continuation fixing successors and predecessors, has the levels as its lengths and what is given and taken as its arising and ceasing plus as many passing.

Each law of §2, by OU's condition:

| Law | Holds for every pairing the counts admit? |
|---|---|
| `«对则闭域守数»`, `«对则闭域守数'»`, the class law, `«续之对则类类等数»` | Yes. They are laws of every pairing under the relation, and choose no lines |
| `closes_iff`, `balancesOn_iff_closed` | Yes. They restate a law on counts |
| `balancesOn_iff_place` | Yes. The place lists are fixed by the counts, and any pairing under sameness between them is one the counts admit |
| `census_pairs`, `census_pairs_of_fixed`, `census_balance`, `balances_at_of_census` | Only as implications. Each holds of every model meeting its hypotheses, and whether a model meets them depends on its lines (`same_counts_other_lines`). The hypotheses are the premise |
| `balances_at_iff_census` | Yes. Both sides are about counts |

## 3. The round trip, item by item

U4 set the test: the lift counts only if (i) the consumers' balance hypothesis gets a root reading with its witnesses, and (ii) something read on unit lines is not read on counts.

- **(i) Met at a step and a condition.**
  - `balancesOn_iff_place` reads the hypothesis as a grammar pairing, both ways.
  - `balances_at_of_census` derives it from one-to-one continuation.
  - Its witnesses are split, merge and teleport.
- **(ii) Not met as a law; met as a premise.**
  - Locality per closed region is read on counts at the place grain. The class law shows that a pairing under any class reads exactly per-class counts, so locality is not the extra.
  - The extra is one-to-one continuation: `compensation` shows counts do not read it, and the census shows it gives balance.
  - By OU's condition it is not a law: it holds of one pairing the counts admit and fails of another (`same_counts_other_lines`). It is the premise under which balance is derived. What holds of every pairing, `balances_at_iff_census`, is read on counts.
  - F1 (two idle Worlds standing at 1 and at 2 alike on every field) is the relational representation forgetting the located units. `place` and `countIn_place` carry the standings in the grammar's lists.

## 4. What is not shown

- **A unit model across steps.**
  - At one step and one condition the existence is shown (`census_model`, `balances_at_iff_census`).
  - It is not shown that every balanced World is the count of one unit model whose continuation fixes successors and predecessors at every step. That needs the units after one step to be the units before the next; the one-step models are built on fresh labels, so a relabelling lemma would join them. U1's `KUnits.canonical` gives a frame-wise existence.
  - A package leaf would state the existence across steps, with units passing through counted rather than lined.
- **The 31 rows' standing.**
  - No row moves. To move one, the row would be stated at the unit model by transport (as U2 stated its rows), with the census hypothesis named and a countermodel per row where one is needed.
  - The MV view would need the standing "on the root under a stated hypothesis" (F5).
- **The census is not yet a statement about `«续» R E` itself.**
  - The pairing relation is "continuation, or the same unit", and the hypotheses are stated on a decided continuation `k` over listed units.
  - Joining `k` to `«续» R E` (with `arising` as `«生»` and `ceasing` as `«亡»` read on the listed units) is a bridge left for the leaf.
- **Formations.** The unit reading counts what a flow gives and takes at a condition. It does not say which formation does so, and it does not use locality through formations.
- **A relation that is not a class.**
  - Beyond the forward law (§2.1), pairings under a relation that is not a class are not characterized. That needs Hall's condition, not counts.
  - `Continuity`'s transfers may pass through, which makes only the components count.
- **Known results.**
  - The class law is equality of multisets class by class.
  - The census is bookkeeping, and Gale (1957) and Hoffman (1960) give flow feasibility by components.
  - The content is the placement: balance as the census of the root's arising and ceasing under fixed successors and predecessors.

## 5. Placement, if the review keeps it (nothing claimed)

- **The general laws belong beside `«对»` in `Becoming.GrammarLaws` (rule 9):**
  - `«对则闭域守数»`;
  - the class law;
  - `«续之对则类类等数»`;
  - the census pairing, stated on `«续» R E` with `«生»` and `«亡»`.

  GrammarLaws has about 322 dependents, so they ride the next planned near-full rebuild, as HE's edits did, or wait in a leaf above GrammarLaws until then.
- **The place reading, `balances_at_of_census` and `balances_at_iff_census`** import `Flow`, so they go in a leaf above `Becoming.Flow`. `Flow` has no active owner, so by rule 3's fallback OU's owner decides its place.
- **Order.** First the review of this design. Then the bridge to `«续» R E` and the existence across steps, in scratch. Then the leaf, with the transport of one row as a trial, before any other row.

## 6. What would change this

- If a law about unit lines is found that holds for every pairing the counts admit and is not read on counts, (ii) is met as a law, and U1's §7 condition for widening the interface holds.

- If the existence across steps fails for balanced Worlds with units passing through, write that failure here. The census reading then holds only for flows whose given and taken are arrivals and departures of a stock.
- If the transport of a row needs more than the census hypothesis (for example, the row reads which formation draws), that row keeps "balance, represented", with its reason.
