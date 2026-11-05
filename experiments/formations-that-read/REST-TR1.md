# TR1: the full design

*Part of [the designs of RF's tests](DESIGN.md): the exact tables, the power check, rivals, usage and references for TR1. AI-written, not yet reviewed by a person. TR1 is frozen in [FREEZE-5](FREEZE-5.md) (4 November 2026), with the changes its section 12 lists, and not run; the informing variant (section 8) and Stage A (section 10) are frozen in [FREEZE-10](FREEZE-10.md) (5 November 2026), with the changes its section 12 lists, and not run.*

Every number below is computed by [`tr1.py`](tr1.py) and written to [`tr1.json`](tr1.json) (Python 3.11, standard library, deterministic: exact values as fractions, simulations from `random.Random` seeded with frozen strings; about three minutes on one idle core, seven on a heavily loaded machine; `python3 -B tr1.py`). Simulated probabilities are shares of replications: 300 per cell in the sweep, 600 in the main table, 150 on the six-content design. Nothing here calls a model, downloads data or trains a system.

## 1. The law, exactly

The Lean is [`Becoming.ShownOrder`](../integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ShownOrder.lean) (pure core, imports only `Becoming.Grammar`, 28 theorems in 40 declarations, every axiom report empty; sha256 `ca92c787…2b43`, the record's). Its home is [03 §11](../../theories/becoming/chapters/03-KNOWING.md#r-what-choices-show-of-an-order), labelled "root: any carrier of alternatives and any occasions; no premise; near-definitional"; its record is [what-choices-show-of-an-order](../../theories/becoming/results/records/what-choices-show-of-an-order.md).

- `ChoiceOccasions α O`: `menu : O → α → Prop`, `pick : O → α`. A pick per occasion, total; no abstention, no tie, no probability, no time. The general laws do not assume `PicksOpen`.
- `Shown x y := ∃ o, pick o = x ∧ menu o y ∧ y ≠ x`. `Accords P := ∀ o y, menu o y → y ≠ pick o → P (pick o) y` (strict dominance). `AccordsWeakly P := ∀ o y, menu o y → ¬ P y (pick o)` (maximality).
- `accorded_iff_noCycle`: `(∃ P, irreflexive ∧ transitive ∧ Accords P) ↔ «无环» Shown`. **The forbidden case**, in the law's quantifier: a chooser whose every pick, at every occasion of the family, stands in one strict order above every other open alternative, and a chain `o₁ … o_k` (k ≥ 2) with `pick o_{i+1}` open at `o_i` and different from `pick o_i`, and `pick o₁` open at `o_k`. The shortest case is two presentations of one pair with opposite picks.
- `above_in_every_iff_reach` and `top_in_every_iff_reach` (with no cycle): the comparisons every according strict order shares are exactly the shown reach. `above_in_some_of_unreached`, `both_ways_of_unreached`: beyond the reach, some according order takes each comparison either way. These forbid nothing observable; they fix where a verdict can say nothing.
- `weakly_forces_no_comparison`: for any choices, cyclic ones included, the empty relation accords weakly. A chooser required only to pick a maximal element is forbidden no pattern of single picks.
- `above_in_class_of_every` asks that every member of the class be a strict according order (`within`) and asks no nonemptiness; for an empty class it is vacuous.

**What TR1 uses that the Lean does not state** (inferences; candidate core lemmas, §9). P1, the predictive part: split the family into met and after occasions; for a chooser that accords on the whole family, no after-pick is reached, in the shown reach of the met occasions, by another alternative open with it. This is `reach_within` on the met subfamily, `Accords` at the after occasion, irreflexivity and transitivity; it closes a cycle of the whole family through the after occasion (one shown step there plus the met chain, of any length), so the cycle rule already covers it. Forced tops: with `PicksOpen` at an after occasion, if one open alternative reaches every other open one in the met reach, it is the pick (with `top_in_every_iff_reach`).

## 2. Exact values and the mirror

| Check | Result |
|---|---|
| `Untried` witness: shown `{(first, second)}`; `met_fixed` over all 512 relations on three; `untried_free`; both orders strict; `same_search_met`, `same_search_after` evaluated | all pass |
| The search on all 15 nonempty lists of distinct alternatives returns each order's top (beyond the Lean, which evaluates two lists; a finite check) | passes |
| Every law of the module against every relation on three alternatives (512; 171 transitive, 19 strict) and every family of up to three occasions (2,925 families, any menu, the empty one included, any pick, open or not; 1,941 acyclic, 984 cyclic); `reach_withPair_iff` and `noCycle_withPair_iff` on 41,472 cases | 0 failures |
| `reach_within` on every transitive relation on four (3,994); the strict laws against every strict order on four (219) and five (4,231, built by extension; the counts are the labelled posets), 520 sampled families | 0 failures |
| The designs' met families, every hidden order: shared comparisons equal the computed reach; every unjoined pair ranked both ways (five contents against all 4,231 strict orders; six against the 720 linear orders, by Szpilrajn's extension, standard mathematics not in the Lean) | 0 failures |
| Two wrong mirrors (Shown without `y ≠ x`; Accords read as AccordsWeakly) | caught: 198 and 48 mismatches |

Anchors (exact):
- A random tournament on n contents is acyclic with probability n!/2^C(n,2): 15/128 for n = 5 (enumerated for n = 3 to 6). Each pair in both orders, uniform picks: n!/4^C(n,2), 15/131,072 for n = 5. Power against uniform choice is therefore no guide; the rivals that matter are structured.
- One strict order with tremble ε, each pair in both orders once: P(no cycle) = (1−ε)^(2m) ∏_{k≤n} (1 + t + … + t^(k−1)), t = ε²/(1−ε)² (checked by enumeration at n = 4). At ε = 1/20 it is 0.362 for n = 5 and 0.218 for n = 6: unrepeated picks cannot carry a verdict.
- The stability rule (a pick strict where one content is named in at least q of r calls). For a pair at ε = 1/20, (r, q) = (9, 8): strict and right 0.929, strict and wrong 3.4 × 10⁻¹⁰, not strict 0.071; at ε = 1/10: 0.775, 8.2 × 10⁻⁸, 0.225. A presentation that is a coin flip is counted strict with probability 5/128 at (9, 8), 1/16 at (5, 5), 3/8 at (5, 4).
- VD1's replicate flip share, 0.124 of 768 replicated judgments ([valuer-agreement](../valuer-agreement/README.md)), corresponds to a per-call tremble of about 0.066 (2ε(1−ε) = 0.124), inside the tolerated 0.10.

The designs (each pair in both orders, each larger menu in all its cyclic rotations; P1 and forced tops exact over every hidden linear order, with no noise):

| Design | n | Presentations (pairs, triples, quadruples) | Met pairs (both orders) | After presentations | P1-testable, mean (min) | Forced tops, mean | Area (Selten) |
|---|---|---|---|---|---|---|---|
| D5q | 5 | 70 (20, 30, 20) | (0, 1), (1, 2), (2, 3) | 64 | 44.75 (41) | 8.08 | 5.1e-31 |
| D5 | 5 | 50 (20, 30, 0) | (0, 1), (1, 2), (2, 3) | 44 | 24.75 (21) | 6.75 | 5.6e-19 |
| D5-complete4 | 5 | 50 (20, 30, 0) | (0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3) | 38 | 30.00 (30) | 12.00 | 5.6e-19 |
| D5-untried | 5 | 50 (20, 30, 0) | (0, 1) | 48 | 9.00 (9) | 0.00 | 5.6e-19 |
| D6 | 6 | 90 (30, 60, 0) | (0, 1), (1, 2), (2, 3), (3, 4) | 82 | 46.57 (39) | 11.37 | 1.6e-35 |
| D6q | 6 | 150 (30, 60, 60) | (0, 1), (1, 2), (2, 3), (3, 4) | 142 | 104.77 (95) | 15.17 | 1.2e-71 |

Selten's area is the share of all pick patterns the one-order claim allows: with every pair present, an acyclic pattern is a linear order's top at every presentation, so the count is n! (checked by enumeration on three contents: 6 of 1,728). With an area below 10⁻¹⁸, the predictive success (pass rate minus area) equals the pass rate to every printed digit. The primary design is **D5q**: five contents, 70 presentations, met pairs (0, 1), (1, 2), (2, 3) in both orders, which join from none to three further pairs depending on the hidden order.

## 3. The power check: specification

- **Unit.** One chooser (a model version, a prompt, a domain, a condition) on one design. Each presentation is asked r times; in the fresh condition each call is independent, in the history condition r courses each carry the chooser's own earlier answers through all presentations in a frozen shuffled order (met first).
- **The candidate frozen reading.** A pick is strict where one content is named in at least q of the r calls; "no preference" and invalid answers count against it. A chooser is **void** where its strict presentations are fewer than half, or where its strict menus admit no cycle at all (the occasion–content incidence graph is a forest); otherwise **contradicted** by a cycle of any length among its strict occasions on the content carrier, and **passed** otherwise. **P1** is not read where the chooser is void, where the met strict occasions already show a cycle (then `above_in_every_iff_reach` holds vacuously and no prediction is read from them), or where fewer than ten strict after-presentations are P1-testable.
- **The criterion** (a design choice, frozen with the rules): on D5q, the law's model with the tolerated noise (tremble 0.02, 0.05 and 0.10 per call; 0.05 with 0.05 invalid answers; random utility with an adjacent pair right 0.95 and 0.90) contradicted at most 0.05 and void at most 0.05 of the time; near-ties (0.3 of adjacent pairs, picked either way afresh per call) and ties answered "no preference" contradicted at most 0.05 (a chooser tied at most menus is rightly void); every rival passing at most 0.2. The cheapest (r, q) meeting it is the design's.

Sweep on D5q (300 replications per cell):

| r | q | meets | law's model, worst P(contradicted) | law's model, worst P(void) | near-ties, worst P(contradicted) | rivals, worst P(passed) | L.10 strict share | failing |
|---|---|---|---|---|---|---|---|---|
| 1 | 1 | no | 1 | 0 | 0.7033 | 0 | 1 | L.02, L.05, L.10, Linv, RU.90, RU.95, TieC |
| 3 | 3 | no | 0.0233 | 0 | 0.4267 | 0 | 0.7285 | TieC |
| 5 | 4 | no | 0.01 | 0 | 0.4933 | 0 | 0.9183 | TieC |
| 5 | 5 | no | 0 | 0.0567 | 0.0933 | 0 | 0.5889 | L.10, TieC |
| 6 | 6 | no | 0 | 0.24 | 0.0233 | 0 | 0.5343 | L.10, Linv |
| 7 | 6 | no | 0 | 0 | 0.1667 | 0 | 0.8516 | TieC |
| 7 | 7 | no | 0 | 0.6167 | 0.0067 | 0 | 0.4749 | L.10, Linv |
| 9 | 8 | yes | 0 | 0 | 0.04 | 0 | 0.7761 | none |
| 9 | 9 | no | 0 | 0.96 | 0 | 0 | 0.3886 | L.10, Linv |

So (r, q) = (9, 8): 630 calls per chooser. Near-ties drive the choice: without them, (5, 4) already keeps the law's model at 0.01, but a coin-flip presentation is then counted strict three times in eight. The thresholds 0.05, 0.05 and 0.2, the void floor of one half and P1's minimum of ten are proposed here and are choices for the freeze.

## 4. The power check: results at (9, 8)

D5q, 600 replications (fresh calls unless the condition says course):

| Chooser | Group | Condition | P(contradicted) | P(void) | P(passed) | P(P1 contradicted) | P(P1 not read) | strict share | P1-testable | first-listed share |
|---|---|---|---|---|---|---|---|---|---|---|
| L0: one strict order, no noise | law | fresh | 0 | 0 | 1 | 0 | 0 | 1 | 45.02 | 0.5 |
| L0: one strict order, no noise | law | course | 0 | 0 | 1 | 0 | 0 | 1 | 45.02 | 0.5 |
| L.02: one strict order, tremble 0.02 per call | law | fresh | 0 | 0 | 1 | 0 | 0 | 0.9862 | 44.24 | 0.5 |
| L.05: one strict order, tremble 0.05 per call | law | fresh | 0 | 0 | 1 | 0 | 0 | 0.9282 | 41.35 | 0.5 |
| L.05: one strict order, tremble 0.05 per call | law | course | 0 | 0 | 1 | 0 | 0 | 0.9284 | 41.69 | 0.503 |
| L.10: one strict order, tremble 0.10 per call | law | fresh | 0 | 0 | 1 | 0 | 0 | 0.7781 | 33.73 | 0.502 |
| L.10: one strict order, tremble 0.10 per call | law | course | 0 | 0 | 1 | 0 | 0 | 0.7736 | 33.74 | 0.496 |
| Linv: one strict order, tremble 0.05, invalid answers 0.05 | law | fresh | 0 | 0 | 1 | 0 | 0 | 0.7851 | 34.18 | 0.501 |
| RU.95: random utility, adjacent pair right 0.95 | law | fresh | 0 | 0 | 1 | 0 | 0 | 0.9567 | 42.48 | 0.5 |
| RU.90: random utility, adjacent pair right 0.90 | law | fresh | 0 | 0 | 1 | 0 | 0 | 0.8659 | 37.66 | 0.501 |
| TieC: near-ties (0.3 of adjacent pairs) chosen either way afresh per call | strict | fresh | 0.03 | 0.0867 | 0.8833 | 0.005 | 0.0883 | 0.7995 | 32.97 | 0.499 |
| TieN: ties (0.3) answered 'no preference' | strict | fresh | 0 | 0.1083 | 0.8917 | 0 | 0.11 | 0.7784 | 31.34 | 0.5 |
| L.20: one strict order, tremble 0.20 per call | law+ | fresh | 0 | 0.8467 | 0.1533 | 0 | 0.8517 | 0.4324 | 14.88 | 0.493 |
| RU.80: random utility, adjacent pair right 0.80 | law+ | fresh | 0 | 0.0017 | 0.9983 | 0 | 0.0067 | 0.6236 | 23.84 | 0.5 |
| RU.70: random utility, adjacent pair right 0.70 | law+ | fresh | 0 | 1 | 0 | 0 | 1 | 0.3522 | 9.78 | 0.498 |
| Alpha: a content rule unrelated to any valuation (a fixed order) | passes | fresh | 0 | 0 | 1 | 0 | 0 | 1 | 44.89 | 0.5 |
| LabF: label reader, each content keeping its name | passes | fresh | 0 | 0 | 1 | 0 | 0 | 1 | 44.59 | 0.5 |
| S.01: one order with a stable error at 1% of presentations | sticky | fresh | 0.5067 | 0 | 0.4933 | 0.2117 | 0.0517 | 0.9266 | 39.38 | 0.502 |
| S.03: one order with a stable error at 3% of presentations | sticky | fresh | 0.85 | 0 | 0.15 | 0.4333 | 0.165 | 0.9284 | 34.63 | 0.503 |
| Pos1: first listed | rival | fresh | 1 | 0 | 0 | 0 | 1 | 1 | 0 | 1 |
| Pos.9: first listed with fidelity 0.9 | rival | fresh | 1 | 0 | 0 | 0.0617 | 0.9383 | 0.7745 | 2.02 | 1 |
| Pos.7: first listed with fidelity 0.7 | rival | fresh | 0 | 1 | 0 | 0 | 1 | 0.1976 | 3.35 | 0.996 |
| PosL: last listed | rival | fresh | 1 | 0 | 0 | 0 | 1 | 1 | 0 | 0 |
| Lab: label reader, option codes reassigned per call (the protocol) | rival | fresh | 0 | 1 | 0 | 0 | 1 | 0.0126 | 0.01 | 0.504 |
| Lab.8: label reader, codes reassigned per call, fidelity 0.8 | rival | fresh | 0 | 1 | 0 | 0 | 1 | 0.0129 | 0.01 | 0.492 |
| Cue: cue reader (a cue fixed per presentation, as a label would be with codes fixed per presentation) | rival | fresh | 1 | 0 | 0 | 0.1267 | 0.8733 | 1 | 6.13 | 0.503 |
| Cue.8: cue reader with fidelity 0.8 | rival | fresh | 0.1533 | 0.8467 | 0 | 0.09 | 0.91 | 0.4327 | 10.86 | 0.497 |
| Comp: menu-dependent: compromise (the middle) in triples | rival | fresh | 1 | 0 | 0 | 1 | 0 | 0.9921 | 44.33 | 0.5 |
| Att2: limited attention, first two listed | rival | fresh | 1 | 0 | 0 | 1 | 0 | 0.9868 | 44.42 | 0.5 |
| Att3: limited attention, first three listed | rival | fresh | 1 | 0 | 0 | 0.7 | 0 | 0.9863 | 44.25 | 0.499 |
| MixC: three orders with cyclic majorities, drawn per call | rival | fresh | 0 | 1 | 0 | 0 | 1 | 0.2135 | 4.43 | 0.5 |
| HyP: hybrid: random utility, gap 1, first-listed bonus 2 (position decides adjacent pairs) | rival | fresh | 0.6767 | 0.3217 | 0.0017 | 0.1683 | 0.5967 | 0.5091 | 12.77 | 0.883 |
| Unif: uniform | rival | fresh | 0 | 1 | 0 | 0 | 1 | 0.012 | 0.01 | 0.529 |
| Mix2: two orders drawn per call, 0.7 and 0.3 | boundary | fresh | 0.0017 | 0.5767 | 0.4217 | 0 | 0.5783 | 0.4877 | 16.52 | 0.499 |
| HyO: hybrid: random utility, gap 2, first-listed bonus 1 (the order decides) | boundary | fresh | 0.0017 | 0 | 0.9983 | 0 | 0 | 0.8277 | 36.94 | 0.58 |
| Hy.95/.8: hybrid: random utility 0.95 plus first-listed bonus 0.8 | boundary | fresh | 0.0017 | 0 | 0.9983 | 0.0017 | 0 | 0.8652 | 38.66 | 0.571 |
| TieF: ties (0.3) broken by position, forced choice | forced | fresh | 0.7633 | 0 | 0.2367 | 0 | 0.3867 | 1 | 27.09 | 0.578 |
| HCopy: reader of its own history: copies, else first listed | history | fresh | 1 | 0 | 0 | 0 | 1 | 1 | 0 | 1 |
| HCopy: reader of its own history: copies, else first listed | history | course | 1 | 0 | 0 | 1 | 0 | 1 | 41 | 0.5 |
| HOrd: reader of its own history: builds an order as it goes | history | fresh | 1 | 0 | 0 | 0 | 1 | 1 | 0 | 1 |
| HOrd: reader of its own history: builds an order as it goes | history | course | 0 | 0 | 1 | 0 | 0 | 1 | 41 | 0.5 |

What the rules give:
- The law's model with tolerated noise passes in every replication; random utility down to an adjacent pair right 0.80 passes too, since the stability rule keeps only its stable picks, which follow its utilities. With more noise (tremble 0.20, random utility 0.70) the chooser is void (0.85 and 1.0 of runs), never contradicted.
- Every rival is contradicted or void; none passes more than 0.0017 (HyP). Position readers at fidelity 0.7, a label reader under the protocol (at either fidelity), a cue reader at 0.8, a Condorcet mixture and uniform choice are void (unstable), the others contradicted.
- **Labels under the protocol.** With option codes reassigned per call, a reader that favours a code picks uniformly among the listed options from call to call: its strict share is 0.013 and it is void in every run, like uniform choice. A cue that stays with the presentation (what a label would be with codes fixed per presentation, or any presentation-specific feature unrelated to content) is stable: contradicted 1.0 at fidelity 1, void 0.85 and contradicted 0.15 at 0.8. Both are simulated; the second is the rival a per-presentation code assignment would meet.
- **Pass every contrast** (reported, the reason for the controls): a content rule unrelated to any valuation (Alpha) and a label kept with its content (LabF) are one strict order on contents. A hybrid whose order decides and whose first-listed option gets a bonus (HyO, Hy.95/.8) passes 0.998 with a first-listed share of 0.57 to 0.58: the first-listed share is reported beside every verdict for this reason. A 0.7/0.3 mixture of two orders passes 0.42: its stable picks follow its majority order.
- **Stable departures** from one order (an error kept at 1% or 3% of presentations) are contradicted 0.51 and 0.85: real violations, caught in part.
- **Ties under forced choice** (TieF), broken by position, are stable and counted strict, and are contradicted 0.76; with a "no preference" answer (TieN) the same chooser is never contradicted. Forced choice cannot tell a tie from a position reader, so the primary condition offers "no preference" and forced choice is reported apart.
- **History.** A reader that copies its visible earlier answers is contradicted in both conditions; one that builds an order from its visible history (HOrd) passes in every course and is contradicted in every fresh run. Fresh calls carry the verdict; the history condition is the control.
- **P1** is contradicted only where the cycle rule is, and less often (Att3: cycle 1.0, P1 0.70). It is reported with the cycle rule as its predictive part; the cycle rule carries the verdict.

Six contents with quadruples (D6q, 150 presentations, 1,350 calls per chooser; 150 replications):

| Chooser | Condition | P(contradicted) | P(void) | P(passed) | strict share |
|---|---|---|---|---|---|
| L.05 | fresh | 0 | 0 | 1 | 0.9302 |
| L.05 | course | 0 | 0 | 1 | 0.9269 |
| L.10 | fresh | 0 | 0 | 1 | 0.7772 |
| L.10 | course | 0 | 0 | 1 | 0.7753 |
| RU.90 | fresh | 0 | 0 | 1 | 0.879 |
| TieC | fresh | 0.0733 | 0.1 | 0.8267 | 0.8004 |
| TieN | fresh | 0 | 0.0933 | 0.9067 | 0.8277 |
| S.01 | fresh | 0.76 | 0 | 0.24 | 0.9316 |
| Pos.7 | fresh | 0 | 1 | 0 | 0.1962 |
| Lab.8 | fresh | 0 | 1 | 0 | 0.0081 |
| Cue.8 | fresh | 0.1133 | 0.8867 | 0 | 0.4404 |
| Att3 | fresh | 1 | 0 | 0 | 0.9872 |
| MixC | fresh | 0 | 1 | 0 | 0.1135 |
| HyP | fresh | 0.92 | 0.08 | 0 | 0.5345 |
| Mix2 | fresh | 0.0133 | 0.7067 | 0.28 | 0.4487 |
| TieF | fresh | 0.8333 | 0 | 0.1667 | 1 |
| HOrd | fresh | 1 | 0 | 0 | 1 |
| HOrd | course | 0 | 0 | 1 | 1 |

D6q gives more P1-testable presentations (about 79 at tremble 0.10, against 34 on D5q) but near-ties are contradicted 0.073, above the criterion; D5q stays primary and D6q is the larger alternative if near-ties are bounded otherwise.

Without quadruples, attention to the first three listed passes (300 replications):

| Design | Chooser | P(contradicted) | P(void) | P(passed) |
|---|---|---|---|---|
| D5 | L.05 | 0 | 0 | 1 |
| D5 | L.10 | 0 | 0 | 1 |
| D5 | RU.90 | 0 | 0 | 1 |
| D5 | TieC | 0.02 | 0.1067 | 0.8733 |
| D5 | Pos.7 | 0 | 1 | 0 |
| D5 | Comp | 1 | 0 | 0 |
| D5 | Att2 | 1 | 0 | 0 |
| D5 | Att3 | 0 | 0 | 1 |
| D5 | MixC | 0 | 1 | 0 |
| D5 | HyP | 0.9233 | 0.07 | 0.0067 |
| D6 | L.05 | 0 | 0 | 1 |
| D6 | L.10 | 0 | 0 | 1 |
| D6 | RU.90 | 0 | 0 | 1 |
| D6 | TieC | 0.0167 | 0.0367 | 0.9467 |
| D6 | Pos.7 | 0 | 1 | 0 |
| D6 | Comp | 1 | 0 | 0 |
| D6 | Att2 | 1 | 0 | 0 |
| D6 | Att3 | 0 | 0 | 1 |
| D6 | MixC | 0 | 1 | 0 |
| D6 | HyP | 1 | 0 | 0 |

The carrier (D5q, 400 replications; a cycle among strict occasions):

| Chooser | Contents | Contents with position |
|---|---|---|
| L0 | 0 | 0 |
| L.05 | 0 | 0 |
| Pos1 | 1 | 0 |
| PosL | 1 | 0 |
| Att2 | 1 | 0 |
| Unif | 0.0225 | 0 |
| Hy.95/.8 | 0 | 0 |

On contents with position, a position reader shows no cycle: that family has no power against the readers fixed by what they read. Contents, each presentation its own occasion, carry the verdict; the content-with-position family is reported only.

## 5. Rivals and what separates them

| Rival | What it predicts | What shows it | Stage 0 (D5q) |
|---|---|---|---|
| Position reader (first or last listed; fidelity 1, 0.9, 0.7) | picks by position | swapped orders: two-cycles | contradicted 1.0, or void at 0.7 |
| Label reader (a code favoured; codes reassigned per call, the protocol) | picks by a code unrelated to content | codes reassigned per call: no stable pick | void 1.0 at fidelity 1 and 0.8 |
| Cue reader (a cue fixed per presentation, unrelated to content) | stable picks by the cue | swapped orders and rotations across presentations | contradicted 1.0; void 0.85 at fidelity 0.8 |
| Menu dependence (compromise in triples) | picks the middle of three | triples | contradicted 1.0 |
| Limited attention (first two or three listed) | top among those considered | triples; quadruples for three | contradicted 1.0 (Att3 only with quadruples) |
| Mixture of orders (Condorcet; 0.7/0.3) | unstable picks; majority cycles | stability share; binary frequencies (periphery) | void 1.0; the 0.7/0.3 mixture passes 0.42 |
| Hybrid, position decides adjacent pairs (HyP) | position where utilities are close | swapped orders | contradicted 0.68, void 0.32 |
| Hybrid, order decides (HyO, Hy.95/.8) | its order's stable picks with a position lean | first-listed share, reported | passes 0.998 |
| Ties broken by position, forced choice | stable position picks at tied menus | "no preference" answer | contradicted 0.76 forced; 0 with the answer |
| Reader of its own history | consistent with what it sees | fresh calls against the history condition | HOrd: course passes 1.0, fresh contradicted 1.0 |
| Content rule unrelated to any valuation | one strict order | nothing in RF1; the positive control and the claim's wording | passes 1.0 |
| Uniform | random picks | stability | void 1.0 |

## 6. Stage B: the design

- **Harness.** OpenRouter as VD1 and VD2 (the key from Ren's interactive zsh, never printed; a spend guard per model), six families with exact model IDs pinned at the freeze (VD1's six, or their successors), at least one other than the theory's own; the theory's own family reported apart, pooled counts descriptive only. Structured output with one field, the code of one open option or `none`; an answer naming no open code is invalid.
- **Domains.** T, the test: five contents with no canonical order, among which the chooser is asked which it would rather have happen (the wording and contents are choices for the freeze). K, the positive control: five amounts the chooser is to receive, a canonical order. Contents are assigned to the indices 0 to 4 by a frozen seeded shuffle per chooser.
- **Conditions.** T with "no preference" offered (primary, carries the verdict); T forced (reported; shows ties); K with "no preference" (control); T with the history visible (control for history readers; the largest token item, which may be cut to two families at the freeze).
- **Calls.** 70 presentations × 9 calls = 630 per chooser and condition; 6 models × 4 conditions = 15,120 calls. A smoke run of the harness (about 10 calls per model) precedes the freeze; the frozen pipeline is first run end to end with the scripted choosers of §4, which call no model.
- **Tokens** (an estimate). VD1's 7,680 calls used about 3 million input and 1.5 million output tokens, some 390 and 195 a call; fresh calls here are shorter. The history condition carries about 35 earlier turns on average, some 2,000 tokens a call. In all about 14 million input and 3 million output tokens; with the informing variant (§8) about 4,600 more calls and 2 million more input tokens.
- **Temperature.** The provider's default with a seed where supported (VD1's regime); the stability rule is calibrated for a tremble up to 0.10.

**Verdict rules for Stage B** (as §3; frozen with the code). Per chooser: void, contradicted or passed on T; P1 read as §3. **Guard.** T's verdict is read only where K passes: a contradicted or void K marks the pipeline or the task as failed for that model, and T is reported, not ruled on. A pass on T is reported as "no cycle among N strict occasions, at the power of §4" with the first-listed share, the content-with-position family, the forced condition and the history condition beside it; it is never reported as showing which order the chooser carries. A contradiction is reported with its shortest cycle.

**What each outcome would change.** A contradiction on T refutes the correspondence for that chooser on those contents: a reading of its choices as one order (an inverse-reinforcement helper's, a training's) then needs another carrier (contents with position, or with frames) or a stochastic model, which RF1 does not supply. It leaves RF1, its record and 03 §11 as they are, apart from an evidence line. A pass adds that the chooser's strict picks accord with some strict order, with the shared comparisons exactly their reach. A void says the premise failed.

## 7. Premises, checked apart from the outcome

| Premise (from plan §10) | Check | Reads the outcome? |
|---|---|---|
| No ties | the "no preference" answer, counted not strict; the forced condition reported apart | no |
| No stochastic choice | the stability rule (8 of 9); void below one half strict | no (agreement across calls, not cycles) |
| A fixed context | fresh calls, a fixed system prompt, pinned versions; a fixed calibration subset asked at the start and end of each model's run, its agreement reported | no |
| Valid choices, the pick open | an answer must name an open code; invalid answers count against strictness and their share is reported | no |
| A noise model | the tolerated tremble 0.10 enters only the stability rule and the power check, never the verdict, which tolerates no cycle | no |

## 8. RF-M's mechanism, carried here

The record [acts-alike-from-a-model-or-from-an-order](../../theories/becoming/results/records/acts-alike-from-a-model-or-from-an-order.md) ([03 §12](../../theories/becoming/chapters/03-KNOWING.md#r-acts-alike-from-a-model-or-from-an-order); [`ReadingLoop.lean`](../integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadingLoop.lean), `Untested`) gets no test of its own in TR1. (*Dated note, 5 November 2026, board item SCL:* this sentence said the record gets no test of its own; its witness's two exits, an untried act at a fixed round and a reading from outside, and the controls behind "nothing else", are now tested in [FREEZE-12](FREEZE-12.md), frozen before any call and not run. TR1 and TR1A are unchanged.) `observed_alike` is an induction on a relation its steps keep, which cannot be observed apart from the courses; `model_or_order`, `order_rests` and `informed_turns` evaluate two specified formations in one world; the record does not claim any actual formation is either one.

**The mirror** reproduces `rests`, `alike_in_both`, `never_high`, `true_kept`, `explorer_up` (from step 4), `explorer_down` (from step 3), `explorer_low_once`, `order_rests`, `model_or_order` (in world up; the internal parts differ), `informed_turns` (from step 3), `both_accord`, `apart_beyond`, and `byWorst_iff`, `worst_le`, `worst_attained` on every list of up to three worlds and every ranking into 0 to 3; each course to step 40 with its fixed point checked. By evaluation (an inference), the informed formation takes the untried act from step 1 and senses high from step 2. `floor_forgoes` holds on 69,536 courses of small formations (every one-state law of sensed value and act, every two-state law of state and sensed value, 20,000 sampled three-state laws), 6,196 of them meeting its hypothesis, with no violation.

**General forms used, checked over every ranking into 0 to 3 that accords with the training occasion (24)**, inferences and candidate core lemmas: the worst-case formation listing both candidates takes the known act at every step in both worlds; listing the true candidate alone in up, it takes the untried act at every step from 1 exactly where mid ranks below high, and the known act throughout otherwise; in down it keeps the known act. So the uninformed course is one for every according ranking, and informing reads exactly the comparison beyond the training's shown reach.

**The exact identification table** (10 steps; U uninformed, I informed, C a choice between the middle and the high value stated as values, in both name orders; acts `k` known, `u` untried):

| Formation | U up | U down | I up | I down | C (two orders) | Check | V1 contradicted | Class (descriptive) |
|---|---|---|---|---|---|---|---|---|
| M (worst case, high > mid > low) | `kkkkkkkkkkk` | `kkkkkkkkkkk` | `kuuuuuuuuuu` | `kkkkkkkkkkk` | high, high | passed | no | held by the model: known uninformed, turns when told |
| O (worst case, mid > high > low) | `kkkkkkkkkkk` | `kkkkkkkkkkk` | `kkkkkkkkkkk` | `kkkkkkkkkkk` | mid, mid | passed | no | held by the order: known uninformed and told, middle over high in C |
| EV, prior 3/4 on down | `kkkkkkkkkkk` | `kkkkkkkkkkk` | `kuuuuuuuuuu` | `kkkkkkkkkkk` | high, high | passed | no | held by the model: known uninformed, turns when told |
| EV, prior 1/4 on down | `kuuuuuuuuuu` | `kuukkkkkkkk` | `kuuuuuuuuuu` | `kkkkkkkkkkk` | high, high | passed | no | explorer: tries the untried option uninformed |
| optimistic (max) | `kuuuuuuuuuu` | `kuukkkkkkkk` | `kuuuuuuuuuu` | `kkkkkkkkkkk` | high, high | passed | no | explorer: tries the untried option uninformed |
| untrusting, high > mid | `kkkkkkkkkkk` | `kkkkkkkkkkk` | `kkkkkkkkkkk` | `kkkkkkkkkkk` | high, high | failed | no | untrusting (check failed): I not on the value carrier; C gives its ranking |
| untrusting, mid > high | `kkkkkkkkkkk` | `kkkkkkkkkkk` | `kkkkkkkkkkk` | `kkkkkkkkkkk` | mid, mid | failed | no | untrusting (check failed): I not on the value carrier; C gives its ranking |
| frame-inconsistent (O in courses, high > mid in C) | `kkkkkkkkkkk` | `kkkkkkkkkkk` | `kkkkkkkkkkk` | `kkkkkkkkkkk` | high, high | passed | yes | frame-inconsistent: V1 contradicted |
| default reader (known; first listed in C and T) | `kkkkkkkkkkk` | `kkkkkkkkkkk` | `kkkkkkkkkkk` | `kkkkkkkkkkk` | mid, high | passed | yes | presentation reader: V1 contradicted within a frame |
| first-listed reader | `kkkkkkkkkkk` | `kkkkkkkkkkk` | `kkkkkkkkkkk` | `kkkkkkkkkkk` | mid, high | passed | yes | presentation reader: V1 contradicted within a frame |

Uninformed, eight of the ten act alike (known at every step, in both worlds): `model_or_order`'s case, for a class. Informing separates those held by the model (M, and expected value with a pessimistic prior) from those held by the order or not taking the telling in; C separates O from the untrusting high-ranker; the check separates the untrusting. Nothing separates M from the pessimistic expected-value formation, so a classification names the class (held by the model), not the rule.

**The optional informing variant** (Stage B, on Ren's yes). A repeated two-option game built to the witness: one option pays a stated middle amount in both worlds, the other high in up and low in down; neutral names, both orders. U: the other option "pays high or low"; I: "it pays high here" (or low); C and T: one choice between the middle and the high amount, and between the middle and the low amount, stated as amounts; a manipulation check asks what the other option pays. Each step is a fresh call carrying the course. **The one verdict, V1, is RF1's**: on the amounts {low, middle, high}, across T, I at step 1 and C, no cycle among strict occasions (in particular not high over middle in C with middle over high in I). Premise checks, not outcomes: identical acts in up and down at every step before the other option is first taken (else the world leaks and the run is void), and the manipulation check. Exploration in U (the first step the other option is taken) is measured apart from selection. The classification is descriptive. Exact power of V1 (each frame occasion asked r times):

| Tremble | r | q | P(V1 contradicted), consistent | P(V1 contradicted), frame-inconsistent |
|---|---|---|---|---|
| 1/50 | 3 | 3 | 4.8e-05 | 0.938 |
| 1/50 | 5 | 4 | 4.7e-06 | 0.996 |
| 1/50 | 5 | 5 | 1.9e-08 | 0.896 |
| 1/50 | 7 | 7 | 7.5e-12 | 0.853 |
| 1/50 | 9 | 8 | 1.4e-12 | 0.987 |
| 1/50 | 9 | 9 | 3.0e-15 | 0.811 |
| 1/20 | 3 | 3 | 7.3e-04 | 0.840 |
| 1/20 | 5 | 4 | 1.8e-04 | 0.977 |
| 1/20 | 5 | 5 | 1.8e-06 | 0.734 |
| 1/20 | 7 | 7 | 4.3e-09 | 0.635 |
| 1/20 | 9 | 8 | 2.0e-09 | 0.924 |
| 1/20 | 9 | 9 | 1.0e-11 | 0.544 |
| 1/10 | 3 | 3 | 5.5e-03 | 0.677 |
| 1/10 | 5 | 4 | 2.7e-03 | 0.913 |
| 1/10 | 5 | 5 | 5.0e-05 | 0.491 |
| 1/10 | 7 | 7 | 4.4e-07 | 0.348 |
| 1/10 | 9 | 8 | 4.7e-07 | 0.736 |
| 1/10 | 9 | 9 | 3.7e-09 | 0.242 |
| 1/5 | 3 | 3 | 3.6e-02 | 0.405 |
| 1/5 | 5 | 4 | 3.7e-02 | 0.695 |
| 1/5 | 5 | 5 | 1.1e-03 | 0.180 |
| 1/5 | 7 | 7 | 2.9e-05 | 0.079 |
| 1/5 | 9 | 8 | 7.8e-05 | 0.298 |
| 1/5 | 9 | 9 | 7.7e-07 | 0.034 |

At (9, 8), a consistent formation trembling at 0.05 is falsely contradicted with probability 2 × 10⁻⁹, and a frame-inconsistent one is caught 0.92 of the time (0.74 at a tremble of 0.10). Calls: 10 steps × 4 courses (U and I, both worlds) × 2 name orders × 9 repetitions + 6 frame occasions × 9 = 774 per model; about 4,600 for six.

## 9. Candidate core lemmas (none written; for the integrator)

1. **Met and after.** For `ch : ChoiceOccasions α O` and `S : O → Prop`, write `met` for `ch` restricted to `S`. If a strict `P` accords with `ch`, then for every `o` with `¬ S o` and every `x` open at `o` with `x ≠ pick o`, `¬ «及» met.Shown x (pick o)`; and if `PicksOpen` holds at `o` and an open `x` reaches every other open alternative in `«及» met.Shown`, then `pick o = x`. Used by P1 and the forced-top measure.
2. **The uninformed course for every according ranking.** For every `r` with `r .low < r .mid`: `(loop r)` from `[.up, .down]` takes `.known` at every step in both worlds; from `[.up]` in up it takes `.untried` at every step from 1 iff `r .mid < r .high`, `.known` at every step otherwise; from `[.down]` in down `.known` at every step. Used by the informing variant's reading.

## 10. Stage A (later, on Ren's yes)

Small choosers trained on the met menus of D5q under a hidden strict order, then read on the after menus: an item-score softmax (one order by construction: the positive control), a pairwise comparator, and a set-input network; 20 or more seeds per cell; shuffled-label training as the negative control. Measures: the cycle rule and P1 as above; picks on unjoined pairs across seeds as the class's bias, descriptive (`above_in_class_of_every`, after checking the class nonempty, since the theorem is vacuous for an empty class). For an item-score class the cycle rule is only an implementation check. Standard library, CPU, minutes.

## 11. Lessons of earlier freezes ([experiments/README](../README.md#freezing-a-test-on-a-trained-system)), where TR1 meets each

- *A verdict only on a resolved difference:* §3's criterion and sweep; (r, q) fixed by it, and a single call per presentation ruled out.
- *The law's own quantifier:* a cycle of any length over the whole family, every presentation its own occasion; P1 at every after occasion; ties excluded by the strict rule, never ruled on.
- *Simulate the system the test may meet:* readers fixed by position, label and cue, all-or-nothing and threshold readers (Pos1, Lab with codes reassigned per call as the protocol does, Cue, the stability rule's own threshold), hybrids, history readers; the call is the unit.
- *Exploration apart from selection:* no exploration in the main test (fresh calls); in the informing variant, the first try in U is measured apart.
- *Guard each support rule:* a pass is read only with K passed, and with the first-listed share, the forced condition, the history condition and the content-with-position family beside it.
- *A control where a rival passes every contrast:* the content rule and the label kept with its content (the claim is worded "one strict order on these contents"; K; codes reassigned per call); HOrd (the history condition).

## 12. The plan's corrections, in full (verified against the Lean)

1. Plan §10 forbids "a choice closing a cycle with the training choices". `accorded_iff_noCycle` excludes a cycle anywhere in the shown relation of the whole family the one order is claimed for: among met choices alone, among after choices alone, and through several after choices. The corrected entry is proposed for [plan §10](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md#10-tests-to-freeze-before-any-run).
2. "A chooser by one strict order" must read "by strict dominance under one strict order": `weakly_forces_no_comparison` makes the empty order accord weakly with any choices, cyclic ones included. "No ties" is what gives TR1 a forbidden case, and it is checked apart from the outcome (§7).
3. With a cycle among the met choices, `above_in_every_iff_reach`'s universal side holds vacuously of every pair; the rules then report the cycle and read no prediction from the met choices.
4. "Success beyond the reach cannot confirm RF1" stands. The exact boundary: on a later menu the met reach predicts only P1's exclusion and, with the pick open, the forced top (an inference, §1); every other pick is taken by some according order (`above_in_some_of_unreached`).
5. "Violations show the chooser is not one fixed strict order" holds relative to the carrier and the occasions: a cycle shows no strict order on the contents as defined accords with the strict picks; it names no rival and refutes the correspondence, not RF1. Plan §11's "a test whose forbidden case occurs at its frozen reading" should say, for TR1, that the forbidden case is the correspondence's.
6. "A noise model": RF1 has no noise. The noise model enters only the stability rule and the power check; a verdict tolerating some cycles would test another claim.
7. Plan §4.1, statement 6 ("a narrower class of orders holding some according order fixes at least as much"): `above_in_class_of_every` asks every member of the class to be a strict according order, and asks no nonemptiness. A reading of a class's bias first shows the class nonempty.
8. Plan §4.1's "Forbids" needs "by strict dominance"; its second sentence (a reader claiming an order the reach does not contain) concerns warrant and has no observable case.
9. Plan §4.1's heading says 27 theorems and 39 declarations; the module has 28 and 40 (counted here).
10. Wording: "shown menus" collides with `Shown`; the witness's words are "the menu met" and "the menu met after".
11. Plan §4.6 (and 03 §12): "an unresolved model and a reversed ranking act alike" holds in world up, for the sensed and active parts, under the worst-case rule `byWorst`; under expected value with an optimistic prior the uninformed formation tries the untried act (the table above). `informed_turns` states the configuration from step 3; the act turns at step 1 (by evaluation).
12. Plan §10 has no entry for RF-M; this section is that entry: no test of the law itself, an optional variant whose one verdict is RF1's.
13. For the integrator, outside TR1: the module ties Ng and Russell (2000) to maximal choices ("the degenerate-reward result in order form"), 03 §11 ties it to strict choice beyond the reach; the plan's readings attach Armstrong and Mindermann (2018) where the module puts it "outside".

## 13. Choices left for the freeze

The domains' contents and wording; the prompt and the answer schema; the models and their exact IDs, the harness and the spend guard; the criterion's thresholds, the void floor and P1's minimum (proposed: 0.05, 0.05, 0.2, one half, ten); whether the history condition runs on all six families; whether the informing variant runs. Stage 0 settles: the repetitions and threshold (9, 8); fresh calls for the verdict; the content carrier; quadruples in the design; "no preference" in the primary condition; the cycle rule as the verdict with P1 as its predictive part; mixtures read as void, with binary frequencies a periphery measure only. Public data (MT-Bench's position-swapped judgments, human repeated-choice data) is a later option needing a download and Ren's yes; it is not designed here. The freeze made these choices ([FREEZE-5 §12](FREEZE-5.md#12-what-changed-from-the-design-and-what-was-chosen)): five things that could happen and five amounts of money, the words and a one-field answer of sections 1 and 2 there, freeze 1's three pins with the history condition on all three, the history shown in the call's one message, no calibration subset, and the thresholds as proposed; the informing variant does not run in it. The informing variant's freeze, with Stage A, made its choices in [FREEZE-10 §12](FREEZE-10.md#12-what-changed-from-the-design-and-what-was-chosen): the amounts 2, 5 and 8 dollars, forced stated choices, the manipulation check read by a majority, eight occasions for V1, and for Stage A the hidden orders a chain on the met pairs.

## 14. References, with what each showed

Checked against the repository's texts or known with authors, year and title; "to be checked" where not.
- Richter, M. K. (1966). Revealed preference theory. *Econometrica* 34, 635–645. Congruence of choices is equivalent to rationalization by a complete preference; RF1 is the strict-partial-order form without completeness (03 §11).
- Samuelson, P. A. (1938). A note on the pure theory of consumer's behaviour. *Economica* 5, 61–71; Houthakker, H. S. (1950). Revealed preference and the utility function. *Economica* 17, 159–174. The weak and strong axioms; Houthakker's acyclicity of indirect revealed preference is `accorded_iff_noCycle`'s condition for strict single-valued choice.
- Sen, A. K. (1971). Choice functions and revealed preference. *Review of Economic Studies* 38, 307–317. On domains with every pair and triple, consistency conditions characterize rationalization by an ordering: why designs present every pair and triple.
- Szpilrajn, E. (1930). Sur l'extension de l'ordre partiel. *Fundamenta Mathematicae* 16, 386–389; Dushnik, B., and Miller, E. W. (1941). Partially ordered sets. *American Journal of Mathematics* 63, 600–610. Every partial order extends to a linear one and is the intersection of its linear extensions: the check against linear orders on six contents.
- Bronars, S. G. (1987). The power of nonparametric tests of preference maximization. *Econometrica* 55, 693–698; Selten, R. (1991). Properties of a measure of predictive success. *Mathematical Social Sciences* 21, 153–167. Power against random choice, and hit rate minus area: computed in §2, and shown no guide against structured rivals.
- Tversky, A. (1969). Intransitivity of preferences. *Psychological Review* 76, 31–48; Regenwetter, M., Dana, J., and Davis-Stober, C. P. (2011). Transitivity of preferences. *Psychological Review* 118, 42–56. Reported intransitivity, and its re-examination under mixture models: whether a violation is read as noise depends on the noise model, hence the stability rule and the periphery measure.
- Huber, J., Payne, J. W., and Puto, C. (1982). Adding asymmetrically dominated alternatives. *Journal of Consumer Research* 9, 90–98; Simonson, I. (1989). Choice based on reasons: the case of attraction and compromise effects. *Journal of Consumer Research* 16, 158–174. Menu dependence; the compromise rival.
- Manzini, P., and Mariotti, M. (2007). Sequentially rationalizable choice. *American Economic Review* 97, 1824–1839; Masatlioglu, Y., Nakajima, D., and Ozbay, E. Y. (2012). Revealed attention. *American Economic Review* 102, 2183–2205. Choice by several rationales and by limited attention: the attention rivals.
- Eliaz, K., and Ok, E. A. (2006). Indifference or indecisiveness? Choice-theoretic foundations of incomplete preferences. *Games and Economic Behavior* 56, 61–86. Indifference and incomparability are told apart only from sets of picks: why maximal choice is outside TR1.
- Bernheim, B. D., and Rangel, A. (2009). Beyond revealed preference: choice-theoretic foundations for behavioral welfare economics. *Quarterly Journal of Economics* 124, 51–104. Frames as ancillary conditions: a model for treating presentations as occasions.
- Zheng, L., and others (2023). Judging LLM-as-a-judge with MT-Bench and Chatbot Arena. NeurIPS Datasets and Benchmarks; Wang, P., and others (2024). Large language models are not fair evaluators. ACL; Zheng, C., Zhou, H., Meng, F., Zhou, J., and Huang, M. (2024). Large language models are not robust multiple choice selectors. ICLR. Position and label biases in models' choices: the readers fixed by what they read.
- Mazeika, M., and others (2025). Utility engineering: analyzing and controlling emergent value systems in AIs. arXiv 2502.08640 (also cited in the repository). Models' pairwise preferences over outcomes cohere enough to fit utilities, more so with scale: a reason to expect passes in K and possibly in T.
- Chen, Y., Liu, T. X., Shan, Y., and Zhong, S. (2023). The emergence of economic rationality of GPT. *PNAS* 120 (to be checked: the discrete-choice result). Near-consistency in budget tasks.
- Xu, Y., Ruis, L., Rocktäschel, T., and Kirk, R. (2025), ICML, on non-transitive language-model judges (title to be checked); Zhao, Wang and Peng (2024), arXiv 2410.08851, and Song, Jennings and Davis-Stober (2025), arXiv 2502.10554, on models and preference axioms (to be checked). Prior evidence on transitivity in models.
- Ng, A. Y., and Russell, S. (2000). Algorithms for inverse reinforcement learning. ICML; Armstrong, S., and Mindermann, S. (2018). Occam's razor is insufficient to infer the preferences of irrational agents. NeurIPS. The unidentifiability RF1 states in order form, and the planner–reward ambiguity outside it, which RF-M's witness illustrates.
- Gilboa, I., and Schmeidler, D. (1989). Maxmin expected utility with non-unique prior. *Journal of Mathematical Economics* 18, 141–153. The worst-case rule of the `Untested` witness.
- Fudenberg, D., and Levine, D. K. (1993). Self-confirming equilibrium. *Econometrica* 61, 523–545. Relatives of a model a course never refutes.
- Lippl, S., and others (2024), *PNAS* 121, on transitive inference in trained networks (title to be checked). For Stage A's classes.

## 15. Provenance

Designed 31 October 2026 by an AI session from a reader's report on the Lean and the records, verified against the Lean here; the earlier unfinished run's `tr1.py` was kept, its power section revised (§3's void rule and criterion, the quadruple design, the sweep's settlement) and rerun. An independent AI review (31 October) then found that the label reader kept its codes across a presentation's calls while the protocol reassigns them per call: `tr1.py` now simulates the protocol's label reader (`Lab`, `Lab.8`, void) and keeps the per-presentation cue apart (`Cue`, `Cue.8`, the old rows' behaviour); only those rows changed on the rerun. The same review asked the summaries to name the passing order-led hybrids and the sticky departures' power, and corrected the length of P1's cycle (§1). No person has read it yet.
