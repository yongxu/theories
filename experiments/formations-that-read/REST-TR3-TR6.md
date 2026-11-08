# TR3 and TR6: the full design

*Part of [the designs of RF's tests](DESIGN.md): the exact tables, the power check, rivals, usage and references for TR3 and TR6. AI-written; no person's review of it is recorded. TR3 is frozen in [FREEZE-3](FREEZE-3.md) (4 November 2026), with the changes its section 12 lists, and not run; TR6 in [FREEZE-6](FREEZE-6.md) (the same day), with the changes its section 12 lists, and not run.*

Every number here is printed by [`tr3.py`](tr3.py) into [`tr3.json`](tr3.json) (Python 3.11, standard library, `fractions.Fraction` for exact values, seeds 20261031 and its successors; a few minutes on one core, about a minute of processor time). The script mirrors [`Becoming.Cascade`](../integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Cascade.lean) (sha256 `e6add4291cb2…`, the hash the record binds; core receipt 20261029T134236.345943Z, every declaration with an empty axiom report). The empty report concerns logic only. The modelling choices are in the law's own statement: deterministic laws, members indexed by the natural numbers, one act each, worlds fixing every coupling, no probability.

## The mirror, checked against the Lean

| Check | Cases | Violations |
|---|---|---|
| `Copying.readsOnlyActs` (from member 1, not from 0) and `reaches_first_only`, five members, two and three coupling values | 2,560 and 98,415 pairs | 0; every pair apart in member 0's coupling gives different acts (512 of 512, 39,366 of 39,366) |
| `acts_alike_of_cascade` on every Boolean pool of three members (16,384 laws, every k) | 163,840 | 0 |
| `separates_at` on the same pools | 2,424,832 | 0 |
| The same on every pool of two members with three coupling values (512 laws) | 6,120 and 69,120 | 0 |
| The same on 1,500 random Boolean pools of five members | 392,320 | 0 |
| Non-vacuity: pairs alike before k with different acts where the premise fails (pools of three) | 901,120 | (expected) |

Laws meeting `ReadsOnlyActsFrom k` among the 16,384 pools of three: 128 (k = 0), 256 (k = 1), 1,024 (k = 2), all (k = 3, vacuous). A table law is extended to lists of other lengths by truncating or padding; for such laws the premise over every list of length 0 to N + 1 equals the premise over each member's own length (1,600 random checks agree), which is what the enumeration rests on.

**The reached-history form** (an inference from the proof term when this was written; proved since in the core, `Turns.acts_alike_along`, board item TRL). `law_alike_of_cascade` uses the premise only at `T.acts w n`, with the two worlds' couplings. So if, for every n ≥ k, member n gives one act for `coupling n w` and `coupling n w'` at the list `acts w n`, worlds alike before k give the same acts. Checked: 1,064,960 pairs on the pools of three and 1,790,856 on the pools of five, no violation; in 901,120 and 1,398,536 of them the reached premise holds where the Lean's premise fails. This is the form a natural cascade can meet.

## Where the textbook member meets the premise

The urn game: state A or B, prior P(A), draws independent given the state, P(draw = state) = p. A member's coupling is its draw, its act a guess. D(h) = P(A | draw a, h) − P(A | draw b, h); at temperature 0 it is −1, 0 or 1. BHW members compute the public belief assuming every earlier member is of their own type; an off-path guess (probability 0 in both states) is read, by a stated convention, as revealing the draw it names, and BHW predictions are taken only on its own path (marked * below).

At p = 2/3, prior 1:1, ties to the own draw, ten members: at every position 0 to 9 some reachable history has the member reading its draw (the counts below), so BHW meets the Lean's premise from no k ≤ 9, and the alternating histories (B,A,B,A,…) give the same at any length.

| Position | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
|---|---|---|---|---|---|---|---|---|---|---|
| Reachable histories | 1 | 2 | 4 | 6 | 10 | 14 | 22 | 30 | 46 | 62 |
| Of which the member reads its draw | 1 | 2 | 2 | 4 | 4 | 8 | 8 | 16 | 16 | 32 |

The stopping-time form (a further candidate lemma: k replaced by τ(w), the first position whose member gives one guess for both draws at the history w reaches) needs persistence as a premise: every member from τ(w) on ignores its draw at the history w reaches. Without it the form fails: member 0 reading its draw, member 1 always guessing B and member 2 reading its draw give τ = 1 everywhere, and 16 ordered pairs of worlds alike before 1 give different acts. BHW meets persistence (its cascades are absorbing: no member from τ(w) on reads its draw at w's history, on any of the 1,024 draw assignments of ten members), and there the 149,824 pairs alike in the draws before τ(w) give the same guesses and the same τ. The fixed-k reached form holds at every k = 0 to 10 (for example 84,288 of 131,072 pairs alike before k = 3 meet it, all with the same acts).

BHW's timing at prior 1:1, true urn A, ten members, by precision and tie rule (member indices from 0, so "member 2" is the third):

| Precision | Ties | P(starts at member 2) | P(by member 4) | P(by member 6) | P(wrong within 10) | P(none within 10) |
|---|---|---|---|---|---|---|
| 5/9 | own draw | 41/81 (0.5062) | 4961/6561 (0.7561) | 467441/531441 (0.8796) | 0.3670 | 0.0595 |
| 5/9 | coin | 61/81 (0.7531) | 6161/6561 (0.9390) | 523441/531441 (0.9849) | 0.4246 | 0.0037 |
| 3/5 | own draw | 13/25 (0.52) | 481/625 (0.7696) | 13897/15625 (0.8894) | 113812/390625 (0.2914) | 20736/390625 (0.0531) |
| 3/5 | coin | 19/25 (0.76) | 589/625 (0.9424) | 15409/15625 (0.9862) | 143437/390625 (0.3672) | 1296/390625 (0.0033) |
| 2/3 | own draw | 5/9 (0.5556) | 65/81 (0.8025) | 665/729 (0.9122) | 1261/6561 (0.1922) | 256/6561 (0.0390) |
| 2/3 | coin | 7/9 (0.7778) | 77/81 (0.9506) | 721/729 (0.9890) | 1870/6561 (0.2850) | 16/6561 (0.0024) |
| 3/4 | own draw | 5/8 (0.625) | 55/64 (0.8594) | 485/512 (0.9473) | 803/8192 (0.0980) | 81/4096 (0.0198) |
| 3/4 | coin | 13/16 (0.8125) | 247/256 (0.9648) | 4069/4096 (0.9934) | 25175/131072 (0.1921) | 81/65536 (0.0012) |

These are BHW's predictions, to be frozen for its timing bridge, not RF4's.

**The precision.** BHW (ties to the own draw) stops reading at two net informative guesses at every precision. An overweighter abandoning its draw only at odds above t:1 stops at: p = 5/9: 3, 5, 6, 6 net guesses (t = 3/2, 2, 5/2, 3); p = 3/5: 3, 3, 4, 4; p = 2/3: 2, 3, 3, 3; p = 3/4: 2, 2, 2, 3. At 3/5 every overweighting rival parts from BHW at two net guesses and cascades still start early (0.52 at the third member); at 2/3 the 3:2 rival does not part. The design fixes p = 3/5, and the second prior at one draw's worth for A (odds 3:2).

D per cell at p = 3/5 (the planned cells; the paths continue to seven earlier guesses with the same values):

| Prior 1:1 | () | (A) | (B) | (A,B) | (B,A) | (A,A) | (B,B) | (A,A,A) | (B,B,B) |
|---|---|---|---|---|---|---|---|---|---|
| BHW, ties to the own draw | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
| BHW, ties by a coin | 1 | 1/2 | 1/2 | 1 | 1 | 0 | 0 | 0 | 0 |
| Overweighting 2:1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 |
| Naive counting | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
| Copier (`Copying.turns`) | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| Majority copier | 1 | 0 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
| Constant A | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| Logit response, precision 10 | 0.76 | 0.59 | 0.59 | 0.76 | 0.76 | 0.39 | 0.39 | 0.28 | 0.28 |
| Hybrid: own draw w.p. 1/4, else counting | 1 | 1 | 1 | 1 | 1 | 1/4 | 1/4 | 1/4 | 1/4 |

| Prior one draw for A | () | (B) | (B,A) | (B,B) | (A) | (A,A) | (B,B,B) | (B,B,B,B) |
|---|---|---|---|---|---|---|---|---|
| BHW, ties to the own draw | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
| BHW, ties by a coin | 1/2 | 1 | 1/2 | 1/2 | 0 | 0 | 0 | 0 |
| Overweighting 2:1 | 1 | 1 | 1 | 1 | 1 | 0 | 1 | 0 |
| Naive counting | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
| Copier | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| Majority copier | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| Constant A | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |

Exploration cells, reported with no prediction (off BHW's path): (A,A,B), (B,B,A), (A,A,A,B) at 1:1; (A,B), (A,A,B) at the other prior. Naive counting ignores its draw at (A,A,A,B), and at (A,A,B) at the other prior, where BHW's convention reads it, so these are where the two could part, but BHW fixes no belief there. [Note, 4 November 2026, at TR3's freeze: the cell at the other prior added; it said only (A,A,A,B).]

## The stochastic analogue a sampled arm would need

Not proved (the core has no probability; a candidate periphery lemma). Two forms were checked exactly at p = 3/5, prefix (A,A), eight members, all 64 later-draw assignments (2,016 pairs). **The sum form:** if every member from k on has |P(A | a, h) − P(A | b, h)| ≤ ε_n at every history reachable at its position, the law of the act list moves by at most Σ ε_n in total variation between any two assignments. Total variation is at most 1, so this check can fail only where Σ ε_n < 1: here only in the two BHW rows without flips and the leaky counter-row outside `Turns` (Σ ε_n = 0 in each). Every other row meets it trivially, since one history reachable by a flip or a reading call is enough to make ε_n about 1. **The weighted form** (the hybrid argument): for assignments a and b, the total variation is at most the sum, over the positions j where they differ, of E|D(k + j, h)| with h drawn from the law of the history at k + j under one assignment's draws before j (the smaller of the two orders is taken). It can lie below 1. For every member in `Turns`, whose act depends only on the history and its own draw, it holds by the hybrid argument and data processing (the history at k + j depends only on draws before j), so a violation could come only from a fault in the simulator: its check verifies the simulator, not the members.

| Member type | Largest total variation, act list | Majority only | Σ ε_n (sum form) | Weighted bound at that pair | Pairs with a weighted bound below 1 | Violations of the weighted form |
|---|---|---|---|---|---|---|
| BHW, either tie rule | 0 | 0 | 0 | 0 | 2,016 | 0 |
| BHW with flips w.p. 1/1000 | 0.00498 | 0.00299 | 4.99 | 0.00499 | 2,016 | 0 |
| BHW with flips w.p. 1/100 | 0.0483 | 0.0292 | 4.9 | 0.0493 | 2,016 | 0 |
| Hybrid, own draw w.p. 1/20 | 0.2649 | 0.0526 | 5.05 | 0.2975 | 2,016 | 0 |
| Hybrid, own draw w.p. 1/5 | 0.7379 | 0.2422 | 5.2 | 1.16 | 1,760 | 0 |
| Hybrid, own draw w.p. 1/2 | 0.9844 | 0.6875 | 5.5 | 2.75 | 192 | 0 |
| Counting with flips w.p. 1/100 | 0.0100 | 0.0100 | 4.9 | 0.0102 | 2,016 | 0 |
| Counting with flips w.p. 1/20 | 0.0499 | 0.0499 | 4.5 | 0.0552 | 2,016 | 0 |
| Logit response, precision 2, 5, 10 | 0.377, 0.724, 0.764 | 0.340, 0.585, 0.576 | 1.18, 2.70, 4.09 | 1.16, 1.99, 1.42 | 1,984, 724, 1,126 | 0 |
| Reads the next member's draw w.p. 1/2 (outside `Turns`) | 0.9688 | — | 0 | — | — | the sum form fails: own dependence 0, yet the list moves |

The weighted form is attained at the pairs differing in one draw (the smallest gap between bound and total variation, among pairs with a bound below 1, is 0 in every row), where equality holds by construction; at the pairs of largest total variation it is loose where members read (2.75 against 0.984 for the hybrid at 1/2, 1.16 against 0.738 at 1/5, 1.99 against 0.724 for the logit at precision 5). For a member that is deaf at the histories it actually reaches and reads only where a rare flip has led, the weighted bound is of the order of that flip rate, while the sum form is near the number of members. A sampled verdict would rest on the weighted form, with a tolerance frozen; until such a lemma is proved, the sampled arm is reported only.

## The power check

**The cell rule.** A cell is a prior and a history, asked R times with each draw. C0: all 2R calls one act, *ignores*; each draw's R calls unanimous and apart, *reads*; otherwise *flagged*. C1: the same with one call of each draw's five allowed off its class. At R = 5 under C0, a cell where the member ignores is classed so with probability 0.99 at η = 1/1000 flips per call (flagged 0.01, misread below 10⁻⁶), 0.90 at 1/100 and 0.60 at 1/20. A five-cell path meets the premise with probability 0.95 at 1/1000, 0.78 at 1/200 and 0.61 at 1/100. After n identical calls with no flip, the one-sided 95% bound on η is 0.015 at n = 200, 0.0099 at 300, 0.003 at 1,000 and 0.001 at 3,000. The planned pilot of 300 calls is a screen: it excludes η above about 1/100, where C1's placement and the conditional verdict fail, and does not measure the 1/1000 boundary; that regime is carried by each cell's unanimity and the flagged share, as the verdict rules already do.

**BHW's timing rule, both priors together (33 cells).** Placed where every cell's class is BHW's prediction; contradicted where a resolved cell differs; unresolved otherwise.

| Member type | C0 (R 3) placed | C0 contradicted | C1 (R 5) placed | C1 contradicted |
|---|---|---|---|---|
| BHW, ties to the own draw | 1 | 0 | 1 | 0 |
| The same, flips 1/1000 | 0.8203 | 0 | 0.9994 | 0 |
| The same, flips 3/1000 | 0.5516 | 0 | 0.9941 | 0 |
| The same, flips 1/100 | 0.1367 | 0 | 0.9373 | 0 |
| The same, flips 3/100 | 0.0024 | 0.0012 | 0.5704 | 0.0002 |
| Overweighting 2:1, any flips up to 3/100 | 0 | ≥ 0.999 | 0 | 1 |
| Hybrid 1/5 | 0 | 0.063 | 0.0007 | 0.083 |
| Hybrid 1/10 | 0.0005 | 0.0125 | 0.1301 | 0.009 |

Under C0 at R = 5: naive counting is placed with probability 1 (it agrees with BHW on every cell); BHW with coin ties, contradicted 0.15 and otherwise unresolved; ties to the public, every overweighter (3:2, 2:1, 3:1), every copier, constant, position-fixed, own-draw-always and contrarian member, contradicted 1; logit responders (precision 2, 5, 10), contradicted 0.05 to 0.11 and otherwise unresolved; hybrids, unresolved 0.88 to 1. **What the rules give.** C1 keeps BHW placeable under residual nondeterminism up to 1/100 at the price of placing a member that reads its draw one time in ten (in the cascade cells) in 13% of runs. The design uses C1 for the timing bridge and reports each cell's off-class count; RF4's conditional verdict keeps unanimity (C0 at R = 5), since its premise is exact.

**RF4's conditional verdict, prefix (A,A), eight members, R = 5, eight fresh sequences, 4,000 replications per agent.**

| Member type | Premise not met | Flagged cell | Passed | Breach reproduced | Unresolved difference |
|---|---|---|---|---|---|
| BHW, ties to the own draw | 0 | 0 | 1 | 0 | 0 |
| BHW, flips 1/1000 | 0 | 0.057 | 0.897 | 0 | 0.046 |
| BHW, flips 1/200 | 0 | 0.254 | 0.578 | 0 | 0.168 |
| BHW, flips 1/100 | 0 | 0.467 | 0.337 | 0 | 0.196 |
| BHW, flips 1/20 | 0 | 0.951 | 0.005 | 0 | 0.044 |
| Hybrid, own draw w.p. 1/20 | 0 | 0.798 | 0.059 | 0 | 0.143 |
| Hybrid, own draw w.p. 1/10 | 0 | 0.958 | 0.003 | 0 | 0.039 |
| Hybrid, own draw w.p. 1/4 | 0.001 | 0.999 | 0 | 0 | 0.0003 |
| Majority copier; constant A | 0 | 0 | 1 | 0 | 0 |
| Reads the next member's draw, always | 0 | 0 | 0 | 1 | 0 |
| Reads it w.p. 1/2 | 0 | 0 | 0 | 0.155 | 0.845 |
| Own draw always | 1 | 0 | 0 | 0 | 0 |

A breach is counted only where the re-asks in the fresh context are unanimous for the new act and those in the premise context unanimous for the path's act; for a member inside `Turns` that is nondeterministic, this needs ten calls to fall into two unanimous blocks, and it did not occur in any replication above. A planted leak through the prompt is caught by the input diff with certainty; the re-ask is the backstop for a channel the log does not show, and it catches a weak one (1/2) in only 0.155 of runs. [Note, 4 November 2026, at TR3's freeze: in the frozen run the two contexts are one request, so a breach outside the leak control is read as a fault of the harness or chance, not as a channel the log does not show; the leak control, a channel the prompt carries, is the re-ask's positive control for a member whose guess the shown light changes ([FREEZE-3 §5](FREEZE-3.md#5-rf4s-conditional-verdict-the-walk-and-the-leak-control)).] **What the rules give.** The conditional verdict is reachable only where residual nondeterminism is near 1/1000 or less; above that the units are voided, not refuted. Fixed readers pass it (they meet the premise), which is why the empty-history cells and BHW's rule are read beside it: a member deaf at the empty history meets RF4's premise trivially and is no cascade.

**The sampled arm (reported only).** Normal-approximation sizes per draw and cell: detecting D = 0.1 between 0.9 and 0.8, 197 calls (two-sided 0.05, power 0.8); equivalence |D| < 0.1 at base 0.9, 155 (two one-sided tests at 0.05, power 0.8, checked by simulation: 0.80), at base 0.5, 429; |D| < 0.05, 617 and 1,713. The planned 50 calls per draw give a 95% half-width of 0.12 to 0.20 on D, enough to describe, not to rule.

## Rivals and what separates them

| Rival | What it predicts | Where it shows | Simulated as |
|---|---|---|---|
| BHW with coin or public ties | D = 1/2 or 0 at one-ahead cells | (A), (B) at 1:1; (), (B,A), (B,B) at 3:2 | `FilterType` with `decide_coin`, `decide_public` |
| Overweighting 3:2, 2:1, 3:1 (Weizsäcker 2010) | reads at two net guesses | (A,A), (B,B) at 1:1; (A), (B,B,B) at 3:2 | `decide_overweight(t)` |
| Naive counting (Eyster and Rabin 2010) | agrees with BHW on every planned cell | only off path, e.g. (A,A,A,B); no BHW prediction there | `Naive` |
| Readers fixed by what they read: first, last, majority, constant, position, contrarian | D = 0 at the empty or balanced cells | (), (A), (B), (A,B), (B,A) | `Rule` |
| Logit quantal response (McKelvey and Palfrey 1995; Goeree and others 2007) | intermediate D everywhere | flagged cells | `decide_logit(λ)` |
| Hybrids of reading and counting | D = q in the cascade cells | flagged cells; C1 misplaces q = 1/10 in 13% | `Mix` |
| A member reading the next member's draw (outside `Turns`) | own D = 0, act list moves | input diff; re-ask | `Leaky` |
| Residual nondeterminism | flips at rate η | flagged cells; unreproduced differences | `Noisy` |

Controls beyond the cells: no draw shown (history only, R = 5 per cell), to see what the member does unread; a comprehension probe per cell and draw (restate the draw and the counts), scored apart from the act, so a member that fails to parse is not counted as one that ignores; a planted leak and a scripted client in the dry run, to show the input diff and the re-ask can fail; presentation of the list frozen (format effects reported by Cho and others 2025, to be checked), varied only as a stated factor in a later round.

## Usage (Stage B, per model, at temperature 0)

| Part | Calls |
|---|---|
| Premise cells (33 cells × 2 draws × 5) | 330 |
| Fresh sequences (8 per prefix, single calls, at most) | 272 |
| Leak control (one prefix) | 108 |
| Comprehension probes (33 × 2) | 66 |
| No-draw control (33 × 5) | 165 |
| Sampled arm (6 cells × 2 draws × 50), reported only | 600 |
| Determinism pilot (a screen) | 300 |
| Total, before re-asks (5 per difference, 1 per invalid answer) | 1,841 |

At about 320 input and 8 output tokens a call, about 0.60M tokens per model; three families 5,523 calls and 1.8M tokens, six families 11,046 calls and 3.6M tokens. A reasoning model adds its reasoning, measured at the smoke run. Harness: OpenRouter as VD1 and VD2 (exact model IDs, key from Ren's interactive zsh, never printed; a spend guard), with structured output; or the Claude CLI as LA1 to LA3 with VD1's isolation flags, after a smoke run on the installed version (the LA pins name 2.1.220). At least one family other than the theory's own, reported apart; pooled counts descriptive only. No download.

## Choices left for the freeze

The reached-history lemma proved in the core first, or the design's reliance on it stated as an inference; the model families and versions; the cover story (unusual precision, urns not named as such) against recognition of the urn game; the determinism pilot's size (300 as a screen excluding η above about 1/100; about 3,000 flip-free calls would bound η below 1/1000); whether TR3's judges variant (each judge with its own evidence, in turn) is added as a second arm with the same harness; whether the public laboratory data (Anderson and Holt 1997; Weizsäcker 2010's pooled sets) are reanalysed, their availability still to be checked. The freeze made these choices ([FREEZE-3 §12](FREEZE-3.md#12-what-changed-from-the-design-and-what-was-chosen)): the lemma proved first, freeze 1's pins, a machine with lights, the pilot of 300 reported, and neither the judges variant nor the reanalysis run.

# TR6 (RF6.3): exact values, power check, rivals and usage

Every number is printed by [`tr6.py`](tr6.py) into [`tr6.json`](tr6.json) (under half a minute). It mirrors [`Becoming.ReflexivePrediction`](../integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReflexivePrediction.lean) (sha256 `4eb919e7…`, the hash the record binds; core receipt 20261029T191748.070149Z, all 26 declarations depending on no axioms). Modelling choices: the response a function of the published value alone, read before the outcome; one value, no probability; the chain the natural numbers 0..n.

## The mirror and every map of small chains

The witnesses check: `threshold` keeps 0..2 and its order, 0 and 2 are right, the orbit from 0 is 0 at every step and from 1 is 2 from step 1 (checked to step 50); `negate` moves both values and alternates; `reflect` reverses the order and fixes 1, and its orbit from 0 is 0, 2, 0, 2, … and is never right (computed, not a Lean statement). `rests_iff_right`, `right_rests` and `reached_rests` hold on 2,000 random maps of 0..9 (30,000 checks). On Bool, every admitted class containing negation (8 of 15) has no predictor right on every admitted response, and `predictor_iff` holds on all 15.

| n | Self-maps of 0..n | Order-keeping | Violations under the hypotheses | Non-keeping maps where `bottom_rests` fails | where `below_right` fails |
|---|---|---|---|---|---|
| 1 | 4 | 3 | 0 | 1 | 0 |
| 2 | 27 | 10 | 0 | 11 | 3 |
| 3 | 256 | 35 | 0 | 128 | 48 |
| 4 | 3,125 | 126 | 0 | 1,755 | 755 |

| n | Order-keeping self-maps | Violations | Steps to rest from 0: 0, 1, 2, … | Most |
|---|---|---|---|---|
| 4 | 126 | 0 | 70, 29, 19, 7, 1 | 4 |
| 5 | 462 | 0 | 252, 99, 67, 34, 9, 1 | 5 |
| 6 | 1,716 | 0 | 924, 351, 233, 143, 53, 11, 1 | 6 |

The bound n is attained, by min(v + 1, n) alone among the order-keeping maps; that it is attained is a computation, not a Lean statement. **Without `within`** (order-keeping tables over 0..n with values up to n + 2, some above n): `below_right` never fails (it needs `keeps` only). How often `bottom_rests` fails depends on r beyond n, which a table over 0..n does not fix and an orbit leaving the chain reads: with r v = v + 1 there (and equally with r v = n or r v = 0), in 5 of 7, 14 of 25, 42 of 91 and 132 of 336 tables for n = 1 to 4; with r fixing every value beyond n, in 2 at each n. Under every extension checked some table breaks it, for example r v = v + 1 everywhere. **No right value:** n^(n+1) of the (n+1)^(n+1) self-maps, by enumeration to n = 5 and the formula at 6: 279,936 of 823,543 (0.34). **Order-reversing maps** of 0..6: 1,709 non-constant, 917 with a right value, of which 422 reach it from 0 and 495 never do. **The orbit from any start** under an order-keeping self-map (not in the Lean, a candidate core lemma): if s ≤ r s, it never falls and is at step n − s the least right value at or above s; if r s ≤ s, it never rises and is at step s the greatest at or below s. Checked on every order-keeping self-map and start for n ≤ 6 (12,012 cases), no violation.

## Simulated publics of ten

| Public | r(0), …, r(10) | Shape | Right values | Orbit from 0 | Rests at step |
|---|---|---|---|---|---|
| Bandwagon, full climb (thresholds 0,1,2,3,3,5,6,6,8,9) | 1 2 3 5 5 6 8 8 9 10 10 | keeps | 10 | 0 1 2 3 5 6 8 9 10 | 8 |
| Bandwagon, stalled (0,1,2,4,4,5,7,8,9,10) | 1 2 3 3 5 6 6 7 8 9 10 | keeps | 3, 6, 7, 8, 9, 10 | 0 1 2 3 3 … | 3 |
| Granovetter's thresholds 0..9 | 1 2 3 4 5 6 7 8 9 10 10 | keeps | 10 | 0 1 … 10 | 10 |
| The same with threshold 1 moved to 2 | 1 1 3 4 5 6 7 8 9 10 10 | keeps | 1, 10 | 0 1 1 … | 1 |
| Bandwagon, identical (threshold 5) | 0 0 0 0 0 10 10 10 10 10 10 | keeps | 0, 10 | 0 0 … | 0 |
| Congestion, spread (capacities 1..10) | 10 9 8 7 6 5 4 3 2 1 0 | reverses | 5 | 0 10 0 10 … | never |
| Congestion, identical (capacity 6) | 10 10 10 10 10 10 0 0 0 0 0 | reverses, moves every value | none | 0 10 0 10 … | never |
| Identity (each forecast met) | 0 1 … 10 | identity | all | 0 0 … | 0 |
| Constant 4 (deaf) | 4 4 … 4 | constant | 4 | 0 4 4 … | 1 |

The spread congestion public has a right value, 5, that republishing from 0 never reaches, as the reflection does; Granovetter's example shows how one moved threshold stops the climb at the least right value, 1.

## The power check

**Specified.** Per framing: offline, every agent at every forecast 0..10, R = 5 calls; an agent's decision at a forecast is the one at least four of five calls give, else flagged; the table is the count. Arm A (memoryless) and arm B (each agent keeps its course): republish from 0 for 11 rounds, five presentation variants each (55 rounds and 550 decisions per arm). V1: no flagged decision; the table neither constant nor the identity; its shape (keeps, reverses, moves every value, neither). V2, at the Lean's level (its r is the count, not the agents): a round mismatches where its count differs from the offline table's count at the published forecast; V2 is contradicted where arm B's mismatching rounds exceed arm A's by a one-sided Fisher exact test at 0.05. Individual mismatches (a decision differing from the agent's offline one) are a diagnostic of a stronger premise, each agent a function of the forecast alone, and carry no verdict: agents can depart from their own decisions while every count stays the table's. The Lean's forbidden cases are counted per seed in each arm (a fall, a pass above the least right value, no rest by round 10, a right round followed by another value; under a table moving every value, a right round). 300 replications per row; agents flip each decision with chance η.

Exact offline pieces at R = 5: a decision is flagged with probability 10⁻⁵ at η = 1/1000, 0.001 at 1/100 and 0.023 at 1/20, so the 110-decision table has no flag with probability 0.999, 0.898 and 0.081; a modal decision is wrong with probability below 10⁻⁷ at 1/100. V2 needs at least 5 mismatching rounds of 55 in arm B when arm A has none, 7 when it has one, 8 for two, 13 for five.

| Public and memory (η = 1/1000 unless stated) | V2 contradicted | Mismatching rounds A / B | Individual diagnostic contradicted | Moving rounds in B | Some seed in A shows a fall |
|---|---|---|---|---|---|
| Bandwagon stalled, memoryless, η 0, 1/1000, 1/100 | 0, 0, 0.017 | 0 / 0, 0.54 / 0.51, 5.3 / 5.2 | 0, 0, 0.017 | 3.0 to 4.5 | 0, 0.13, 0.74 |
| Bandwagon stalled, inertia 0.1, 0.3 | 0.04, 0.44 | 0.55 / 1.7, 0.52 / 5.2 | 0.04, 0.45 | 3.2 | 0.12, 0.10 |
| Bandwagon stalled, momentum 0.3, 1 | 0.32, 1 | 0.62 / 4.5, 0.46 / 24.9 | 0.38, 1 | 4.5, 8.9 | 0.14, 0.08 |
| Bandwagon stalled, trend reader 0.5 | 1 | 0.54 / 16.8 | 1 | 5.4 | 0.12 |
| Bandwagon stalled, agents exchange rules | 0 | 0.55 / 0.50 | 0.997 | 3.2 | 0.10 |
| Full climb, memoryless, η 0, 1/1000, 1/100 | 0, 0, 0.02 | 0 / 0, 0.52 / 0.48, 5.4 / 5.1 | 0, 0, 0.013 | 8.0 to 8.3 | 0, 0.16, 0.76 |
| Full climb, inertia 0.1, 0.3 | 0.48, 0.99 | 0.51 / 5.3, 0.57 / 16.7 | 0.50, 0.99 | 8.4, 8.1 | 0.13, 0.14 |
| Full climb, momentum 0.3, 1 | 0.84, 1 | 0.54 / 7.8, 0.63 / 15.3 | 0.89, 1 | 7.4, 5.1 | 0.18, 0.15 |
| Full climb, trend reader 0.5 | 0.98 | 0.53 / 10.6 | 1 | 5.1 | 0.15 |
| Full climb, agents exchange rules | 0 | 0.58 / 0.51 | 1 | 8.0 | 0.16 |
| Congestion spread, memoryless, η 0, 1/1000, 1/100 | 0, 0, 0.03 | 0 / 0, 0.55 / 0.54, 5.3 / 5.2 | 0, 0, 0.033 | 11 | not counted (reverses) |
| Congestion spread, inertia 0.1, 0.3 | 1, 0.997 | 0.62 / 18.2, 0.49 / 20.0 | 1, 0.997 | 9.4, 6.2 | — |
| Congestion spread, regret after a crowded round 0.3, 1 | 0.003, 0 | 0.57 / 0.51, 0.51 / 0.58 | 0.003, 0 | 11 | — |
| Congestion spread, trend reader 0.5 | 1 | 0.55 / 43.7 | 1 | 10.2 | — |
| Congestion spread, agents exchange rules | 0 | 0.52 / 0.59 | 0.34 | 11 | — |
| Congestion identical, inertia 0.1, 0.3; trend reader 0.5 | 1, 1, 0.997 | up to 46.8 in B | 1, 1, 0.997 | 10.4 to 11 | — |
| Congestion identical, agents exchange rules (identical agents: nothing changes) | 0 | 0.61 / 0.57 | 0 | 11 | — |
| Constant 4 (deaf) | V1: constant in all runs | 0.58 / 0.44 | 0.003 | 1.2 | 0.42 |
| Identity | V1: identity in all runs | 0.52 / 0.60 | 0.003 | 0.1 | 0 |
| Hybrid: even agents stalled bandwagon, odd agents deaf | 0 (V1: keeps) | 0.59 / 0.57 | 0 | 3.1 | 0.35 |

In every row, no forbidden case occurred in a seed with no count mismatch. **What the rules give.** (1) The Lean's forbidden cases cannot carry a verdict at temperature 0 as served: on the memoryless bandwagon publics, one flip in a thousand decisions makes some seed in arm A show a fall in 13 to 16 percent of runs, a pass in up to 27 percent and a right round not repeated in up to 32 percent. They are reported, and one in a seed with no count mismatch is a harness fault. (2) V2's false rate stays at or below 0.03 up to η = 1/100. (3) V2 resolves memory only where it changes counts on the orbit: inertia is invisible where the orbit rests (0.04 at strength 0.1 on the stalled public, 0.48 on the climb, 1 under congestion's alternation), and regret after a crowded round changes nothing on the 0, 10 alternation and is detected no more often than noise (at most 0.003). That is a limit of the measure, and it is the law's own scope: along the orbit such a public is indistinguishable from a response of the forecast alone. (4) V1 cannot tell an identity public or a deaf one from a reading one by shape alone; both are flagged by their own classes and by the controls. (5) The cancellation control: agents exchanging decision rules cyclically each round leave every count the table's, so the public is a response of the forecast alone in the Lean's sense; V2 is never contradicted, while the individual diagnostic is resolved against them in 0.997 and 1 of runs on the bandwagon publics and 0.34 on spread congestion. A verdict on individual mismatches would reject a public the law describes.

## Rivals and what separates them

| Rival | What it does | Where it shows |
|---|---|---|
| Deaf public (constant) | ignores the forecast | V1: constant table; the no-forecast round gives the same count |
| Identity public (forecast read as an instruction to match) | every forecast right | V1: identity table; the payoffs-not-told control |
| Inertia, momentum, trend reading (learning-to-forecast subjects; Hommes and others 2005, Heemeijer and others 2009) | reads its own course | V2 in arm B, where the orbit moves |
| Hybrid of readers and deaf agents | a response of the forecast alone, flatter | V1 keeps; no verdict against it (it meets the premise) |
| Residual nondeterminism | flips at rate η | arm A's mismatching rounds; V2's baseline |
| Agents exchanging rules (the cancellation control) | each agent departs from its own decisions; every count is the table's | the individual diagnostic only; V2 not contradicted (it is a response of the forecast alone) |
| Thresholds written into personas | an implementation of the order | the design states costs, not thresholds, and reports the best-reply table apart (V1's shape is then a comprehension check) |

Controls: a round with no forecast (what the public does unread); payoffs not told (does the forecast alone set the count); a start at a value found right offline (`right_rests`: the same count every round in arm A); comprehension probes (restate the forecast and the payoff rule); the determinism pilot. Where the offline orbit from 0 moves in fewer than four rounds, a second start for arm B, fixed from the offline table before arm B runs, is a choice for the freeze; the Lean gives verdicts from 0 and from right values only, so its forbidden cases from that start would be reported against the candidate lemma above, not judged.

## Usage (Stage B, per model, at temperature 0)

| Part | Calls |
|---|---|
| Offline table (2 framings × 10 agents × 11 forecasts × 5) | 1,100 |
| Arm A (2 × 5 variants × 11 rounds × 10) | 1,100 |
| Arm B (the same, with memory) | 1,100 |
| No-forecast round (2 × 10 × 5) | 100 |
| Payoffs not told (10 × 11) | 110 |
| Start at a right value (2 × 3 rounds × 10 × 2 arms) | 120 |
| Comprehension probes (2 × 11 × 2) | 44 |
| Determinism pilot (a screen, as TR3's) | 300 |
| Total, before re-asks | 3,974 |

About 280 input and 8 output tokens a stateless call, and about 60 more per round of course in arm B: about 1.47M tokens per model; three families 11,922 calls and 4.4M tokens. Same harness and pins as TR3. No download.

## Choices left for the freeze

The personas' costs (heterogeneity measured before any claim of a richer chain than a threshold); the families; the cover story (El Farol and bandwagon framings are well known to the models, so neither is named); the second start; whether a sampled arm is added (reported only: a random response is outside the law). The freeze made these choices ([FREEZE-6 §12](FREEZE-6.md#12-what-changed-from-the-design-and-what-was-chosen)): one set of ten costs for both framings, a work day and a lake told in points, freeze 1's pins with freeze 3's request and endpoints, a second start for both arms from the start whose orbit moves most, and no sampled arm.

# Candidate core lemmas (no new Lean is written here)

1. **Cascade at the histories reached** (TR3): `acts_alike_of_cascade` with the premise required only at `T.acts w n` for the two worlds compared. The current proof term suggests it is short. Without it, a natural cascade is an instance only through a constructed law agreeing with the member on the reached histories. Proved since: `Turns.acts_alike_along` (`Becoming.ReachedCascade`, board item TRL).
2. **Cascade from a stopping time** (TR3): k replaced by τ(w), the first position whose member ignores its draw at the history w reaches, with persistence as a premise (every member from τ(w) on ignores its draw at the history w reaches). Without persistence it is false (the counterexample above); with it, it follows from lemma 1, since worlds alike before τ(w) reach the same histories up to τ(w) and so have the same τ.
3. **A total-variation form** (TR3, periphery): the weighted form above (each position's dependence averaged over the histories reached) bounds the act list's movement; needed before any sampled verdict. The sum form Σ ε_n is weaker and, at these sizes, vacuous wherever it is not 0.
4. **The orbit from any start** (TR6): the statement under B6 above; needed before any verdict from a start other than 0 or a right value.

# The plan's corrections in full

1. **§10, TR3.** "Predict when naturally operating sequential choosers stop using their private signals" asks RF4 for a timing it does not make: that a member stops reading its coupling is the premise `ReadsOnlyActsFrom k` (record, does_not_show). The timing comes from a named model (BHW, here) and is judged apart; its failure refutes that model for those choosers, under the probabilistic form's debt, and is not, for RF4, "a test whose forbidden case occurs" (§11).
2. **§10, TR3, last sentence.** "Test the claimed return of reach separately" names a claim the Lean does not make: `Cascade.lean` says "nothing here acquires or restores a distinction", and the record lists as not shown that a pool's later selection keeps a coupling one member's act carries. The sentence predates the Lean review's finding 13. Dropped; cascade breaking after a revealed draw may be explored with no verdict.
3. **§10, TR3, scope.** The premise covers every member from k on, k included, every list of earlier acts, reached or not, with k fixed. BHW meets it for no k (computed). The design rests on the reached-history form (an inference; lemma 1, proved since) and fixes k by a scripted prefix.
4. **§10, TR3, the intervention.** On the draws of members from k on, with the acts before k scripted. With stateless members the conclusion then follows from the measured premise, so it checks the representation; this is said in the design, not hidden.
5. **§3, the pool row.** "only what couples into those read first where members read one another's acts (RF4)" drops the premise; members who read one another's acts and their own couplings carry those couplings (`separates_at`). Corrected: "where, from some member k on, k included, every member acts alike whatever its own coupling on every list of earlier acts, only what couples into the members before k (RF4)".
6. **§10 has no entry for RF6.3**, though the record's next delta names a test; TR6 is added to [plan §10](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md#10-tests-to-freeze-before-any-run).
7. **§4.6, RF6.3's summary** drops `within`, a hypothesis of `on_chain`, `rises`, `again_or_risen` and `bottom_rests`; without it `bottom_rests` fails (at n = 4, with values up to 6, in 132 of 336 order-keeping tables leaving the chain when r v = v + 1 beyond n, in 2 when r fixes every value beyond n). With counts of N agents it holds by construction, so no test checks it.
8. **§4.6, "a response reversing the order can leave one"** (`Reflecting.middle_right`) says nothing of reaching it: from 0 the reflection gives 0, 2, 0, 2, … and 495 of 917 such maps of 0..6 never reach their right value. No design predicts reaching under an order-reversing response.
9. **§4.4's sentence on a negated prediction** matches `no_predictor_right` read over a class of responses; its one observable instance is a single response moving every value, the identical congestion public.
10. **§12, step 3** says "The tests' designs, frozen"; the board claim says nothing frozen or run. These designs are not frozen; the freeze is a later commit after the power check, and only the runs wait for Ren's yes.

# Where the designs meet the six lessons ([experiments/README.md](../README.md#freezing-a-test-on-a-trained-system))

- **Resolved differences only.** TR3: C1 keeps BHW placeable to η = 1/100, the conditional verdict is voided above about 1/1000; TR6: verdicts rest on V2, not on the Lean's forbidden cases, which noise produces.
- **The law's own quantifier.** TR3 reads every cell from k to the last member and the whole act vector, not the end or one aggregate; TR6 counts every round.
- **The system the test may meet.** Fixed readers, all-or-nothing and threshold agents, hybrids, logit responders, leaks and flips are simulated (TR3: 22 member types, with leaks and flips added; TR6: 10 publics, and 5 memory rules at several strengths, the rule exchange among them).
- **Exploration apart from selection.** Off-path cells (TR3) and second starts (TR6) are reported with no verdict.
- **Guarded support rules.** BHW's rule reads all 33 cells, including the empty and balanced ones where fixed readers fail; TR6's V1 reads constancy and identity before shape.
- **A control where a rival passes everything.** Naive counting passes BHW's rule, so the bridge is to the class {BHW, naive counting}; fixed readers pass RF4's conditional verdict, so the empty-history cells are read beside it; the hybrid public passes V1 and V2, and meets the premise; agents exchanging rules pass V2 and are a response of the forecast alone in the Lean's sense, so only the individual diagnostic shows them, with no verdict.

# References

- Anderson, L. R. and Holt, C. A. (1997). Information cascades in the laboratory. *American Economic Review* 87(5). Laboratory urn game; cascades formed in most imbalanced histories. Shares to be read from the paper before citing figures.
- Arthur, W. B. (1994). Inductive reasoning and bounded rationality. *American Economic Review* 84(2). El Farol: a shared forecast defeats itself in a congestion game.
- Banerjee, A. V. (1992). A simple model of herd behavior. *Quarterly Journal of Economics* 107(3).
- Bikhchandani, S., Hirshleifer, D. and Welch, I. (1992). A theory of fads, fashion, custom, and cultural change as informational cascades. *Journal of Political Economy* 100(5). Once public evidence outweighs any private signal, acts stop depending on it.
- Çelen, B. and Kariv, S. (2004). Distinguishing informational cascades from herd behavior in the laboratory. *American Economic Review* 94(3). Agreement of acts is not ignoring one's signal; measure the latter.
- Eyster, E. and Rabin, M. (2010). Naïve herding in rich-information settings. *American Economic Journal: Microeconomics* 2(4).
- Goeree, J. K., Palfrey, T. R., Rogers, B. W. and McKelvey, R. D. (2007). Self-correcting information cascades. *Review of Economic Studies* 74(3). Long sequences: cascades break and re-form; logit QRE fits.
- Granovetter, M. (1978). Threshold models of collective behavior. *American Journal of Sociology* 83(6). [AI reading] The closest social-science form of `bottom_rests`.
- Grunberg, E. and Modigliani, F. (1954). The predictability of social events. *Journal of Political Economy* 62(6). Existence of a correct public prediction, not its reaching.
- Heemeijer, P., Hommes, C., Sonnemans, J. and Tuinstra, J. (2009). Price stability and volatility in markets with positive and negative expectations feedback. *Journal of Economic Dynamics and Control* 33(5).
- Hommes, C., Sonnemans, J., Tuinstra, J. and van de Velden, H. (2005). Coordination of expectations in asset pricing experiments. *Review of Financial Studies* 18(3). Forecasters coordinate on trend-following, so they do not republish the last outcome.
- McKelvey, R. D. and Palfrey, T. R. (1995). Quantal response equilibria for normal form games. *Games and Economic Behavior* 10(1).
- Merton, R. K. (1948). The self-fulfilling prophecy. *Antioch Review* 8(2).
- Perdomo, J., Zrnic, T., Mendler-Dünner, C. and Hardt, M. (2020). Performative prediction. *ICML*. Related to `Right` only where retraining returns the outcome exactly.
- Simon, H. A. (1954). Bandwagon and underdog effects and the possibility of election predictions. *Public Opinion Quarterly* 18(3).
- Smith, L. and Sørensen, P. (2000). Pathological outcomes of observational learning. *Econometrica* 68(2). With unbounded private beliefs no cascade forms; RF4's premise needs bounded ones, as urn draws are.
- Tarski, A. (1955). A lattice-theoretical fixpoint theorem and its applications. *Pacific Journal of Mathematics* 5(2).
- Weizsäcker, G. (2010). Do we follow others when we should? A simple test of rational expectations. *American Economic Review* 100(5). Subjects abandon their own signal only at odds well above 1:1 (about 2:1, as the reader's report gives it; to be checked against the paper).
- To be checked before citing: Cho, Guntuku and Ungar (2025), herding in multi-agent language-model systems and the format of peer information (arXiv 2505.21588); Weng, Chen and Wang (2025), BenchForm, conformity of language models (ICLR); Jain and Krishnamurthy (2024), language-model agents as Bayesian social learners (arXiv 2411.01271); Arghal and others (2025), cascades as absorbing states with language-model simulations (arXiv 2504.02648); Oesterheld, Treutlein, Cooper and Hudson (2023), performative predictions and proper scoring rules (UAI).

Repository precedents: [LA2](../self-rewarding-lock/README.md) (a judge reading a pool of earlier selections; one note in nine turned it, the opposite of RF4's premise; whole calls answered one way, so members at temperature 0 sit near the Lean's deterministic form); [VD1 and VD2](../valuer-agreement/README.md) (several families through OpenRouter, the theory's own family reported apart); [IN1](../direction-installation/README.md) (a multi-agent API run and its usage).
