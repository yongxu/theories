# UE26 landing review (31 October 2026)

AI-written by an independent, adversarial reviewer. Nobody else has reviewed this text. What I read, against main at `adbf20392`:

- **Core leaf.** `kit/tree/Becoming/BlanketWeights.lean`, all 806 lines. I recompiled it against the kit's scratch build with the pinned `leanprover/lean4:v4.29.1` and re-ran `kit/tree/.build/BecomingBlanketWeightsAxiomAudit.lean`. All 90 declarations report "does not depend on any axioms".
- **What the core leaf imports.** `Becoming.Blanket`, `ConditionalWeights`, `Weighted`, `Prelude` (`Distinct`) and `GrammarLaws` (`«所闭»`), in the main package.
- **Periphery module.** `experiments/.../free-energy/LinearBlankets.lean`, all 869 lines, and its receipt `linear-blankets-checks/20261031T053546.425045Z/verification.json`. The receipt passed, and its source hash `6142f877…` equals the file's.
- **The landing packet.** `review-landing/texts.diff` (all 215 lines) and the three JSON files in `review-landing/records/`. I diffed the amended record against main.
- **Study and board.** `kit/study_ue26.txt` and the `LANDED` strings and the queue clause in `kit/board_ue26.py`.
- **Background.** `DESIGN.md`, `REVIEW-UE26-DESIGN.md`, `RECHECK-UE26.md` and `LITERATURE-CHECK.md`.
- **Sources.** The arXiv texts of Friston et al. 2023 (2201.06387v3, §4, eqs. 7–13, footnotes 10–13), Heins and Da Costa 2022 (2205.10190v2, eqs. 9–18) and Biehl, Pollock and Kanai 2021 (2001.06408v3, Observations 1–3, Appendix A). I extracted them into the session scratchpad; none is kept in the repository.
- **The brief's citation.** The brief gives Heins and Da Costa as arXiv 2207.07620. That number is Sakthivadivel 2022. The packet itself cites 2205.10190, which is correct.

My probes are in `review-landing/probes/`:

- `RatioReadsExternal.lean` compiles against the core scratch build, and every axiom report is empty.
- `em_circulation.py` and `em_scan.py` solve the Euler–Maruyama steady covariance in exact rationals.
- `coverage.py` checks that the records cover their modules.

Line numbers below are those of `texts.diff` unless a file is named.

## Findings

### A. Wrong claims

**1. "Detailed balance of the internal moves gives the statistical form": the summaries drop the conditions without which it is false.**

*Where.* Places that drop both the ratio condition and positivity:

- texts.diff 113: the page's In brief, "Where the theory forbids": "the blanket's statistical form holds under detailed balance of the internal moves, or footnote 13's condition in the linear case".
- 120: the claim table, "which detailed balance of the internal moves gives".
- 134: the page's §1, the same words.
- 141: the page's §2, "The statistical form holds under detailed balance of the internal moves".
- The amended record the-markov-blanket-as-a-coupling-structure, `related[1].detail` (en and zh): "which detailed balance of the internal moves gives".
- The new record the-blanket-at-a-steady-state, `laws[3]`: "…, which detailed balance gives".

Places that keep "one closure of moves present at every external state" but drop the ratio condition and positivity:

- `statement` (en and zh) of the-blanket-at-a-steady-state.
- `history[0]` (en and zh) of the same record.
- 197: the regions.json note.
- 8: FEP-INTEGRATION, "detailed balance of the internal moves within one closure of moves present at every external state gives it".

*What is wrong.* `crossForm_of_detailedBalance` (BlanketWeights.lean:200–206) has five hypotheses: `pos`, `balanced`, `moves`, `ratio` and `joined`. Without `ratio` the law fails. The module's own converse `ratio_of_crossForm` (BlanketWeights.lean:217–224) shows that `ratio` is forced whenever the weights are positive, in detailed balance and in cross form. Without moves present at every external state the law fails too, and the module's own witness `MovesReadExternal.not_crossForm` (BlanketWeights.lean:634–684) shows it: a positive weighting in detailed balance that is not in cross form. As written, these sentences are refuted by the module they summarize.

The page also breaks its own contract. Its header (line 3 on main) says it "says no more than" the home statement. Here 03 §1 (texts.diff 167) states the conditions correctly and the page does not.

*Evidence.* `review-landing/probes/RatioReadsExternal.lean` builds the case. It has one internal bit, one blanket state and two external states. The flip 0→1 has rate 1 where the external bit is off and 2 where it is on; 1→0 has rate 1. The weights are (1,1) and (1,2). The probe proves four things:

- `balanced`: detailed balance.
- `moves`: the flip is present at positive rate at every external state.
- `joined`: the closure joins the two internal states.
- `not_crossForm` and `not_independent`: the weighting is not independent given the blanket.

Every axiom report is empty. The record statement's wording, "within one closure of moves present at every external state", is met, and the claim still fails.

*Fix.* Use 03 §1's conditions everywhere. Exact replacements:

- **Page, 113.** Replace "and the blanket's statistical form holds under detailed balance of the internal moves, or footnote 13's condition in the linear case, not with every circulation, while the theory's synchronous steps lose it with circulation even under the 2023 paper's term-by-term sparse coupling." with "and the blanket's statistical form holds where the internal moves are in detailed balance with a positive weighting, joined at each blanket state by moves present at every external state whose rate ratios read no external state, or, in the linear case, under the principle's sparse coupling with footnote 13's condition and diagonal positive noise; it need not hold with circulation, and in a witness the synchronous steps of a drift meeting footnote 13 and the 2023 paper's term-by-term sparse coupling lose it." This also fixes 2 and 7.
- **Page, 120 and 134.** Replace "which detailed balance of the internal moves gives" with "which detailed balance of the internal moves gives, with positive weights, moves present at every external state and rate ratios reading none".
- **Page, 141.** Replace "The statistical form holds under detailed balance of the internal moves, or footnote 13's condition in the linear case, and need not hold with circulation;" with "The statistical form holds under detailed balance of the internal moves, with positive weights, moves present at every external state and rate ratios reading none, or, in the linear case, under sparse coupling with footnote 13's condition and diagonal positive noise, and need not hold with circulation;".
- **Record statement, en.** "On weights of internal, blanket and external states, independence given the blanket is the cross form on listed states, on listings listing each state once; detailed balance of the internal moves with positive weights, within one closure of moves present at every external state whose rate ratios read no external state, gives it, sufficient, not necessary: circulation can lose it and need not."
- **Record statement, zh.** "于内部、毯与外部诸态之权，于每态列一次之列，予毯之独立即所列诸态之交叉形式；权皆正，内部诸移于每一外部态皆在之移之一闭包内细致平衡，每移之率比不读外部态，则予之，为充分而非必要：环流能失之，亦未必失之。"
- **regions.json note, FEP-INTEGRATION, `history[0]`, `laws[3]` and the amended record's `related[1]`.** Insert "with positive weights" and ", each such move's rate ratio reading no external state" (zh: "权皆正" and "，每移之率比不读外部态"). In `laws[3]`, end with "which detailed balance gives under law 1's conditions".

**2. A witness at one step size is stated as a law: "the synchronous scheme loses the four-part blanket with circulation".**

*Where.* Every summary of the synchronous result:

- On the page: 113 ("lose it with circulation even under…"), 120 ("the theory's synchronous steps lose it with circulation"), 141 ("lose the statistical form with circulation") and 158, the Standing ("with the synchronous scheme losing the four-part blanket under circulation").
- In 03 §1: 170 ("with circulation it loses the internal–external zero too") and 172, the Reading ("where with circulation the four-part blanket is lost").
- 184 (08 §8: "new are … the synchronous scheme losing the four-part blanket with circulation").
- 8 (FEP-INTEGRATION: "loses it with circulation") and 202 (the regions note).
- The linear record, `statement` (en and zh) and `history[0]`.
- The study: lines 47–49 ("with circulation it loses the internal–external zero"), 71 and 77.
- board_ue26.py, lines 49–51 (`LANDED`) and 113–115 (the queue clause).
- LinearBlankets.lean, header lines 82–84, and the bold first sentence of `em_couples`'s docstring (798).

*What is wrong.* The only Lean is `Autonomous.em_couples` (LinearBlankets.lean:802). It is one drift, at `h = 1/10`: entry −27800/984581. Nothing proves a loss for every circulating drift, and the general statement is false. The recheck's own fix said "With circulation it **can** lose it" (RECHECK-UE26.md:96). The texts dropped "can".

*Evidence.* `review-landing/probes/em_circulation.py` gives three results:

1. The value −27800/984581 at `h = 1/10` is confirmed; |A⁴⁰⁰| ≈ 7·10⁻³⁷, so the solution is the unique steady law.
2. Take the precision with agent and world uncoupled (Π_as = 0) and the same circulation as `Autonomous` (Q_es = 1, Q_ai = −1). It meets sparse coupling and footnote 13, and the synchronous steady precision keeps every agent–world zero (internal–external 0, active–external 0) at `h = 1/10` and at `h = 1/3`.
3. `em_scan.py` uses `Autonomous`'s own precision with Q_es = 1. As Q_ai runs from −1 to 0 at `h = 1/10`, the internal–external entry changes sign (−0.02824 at −1, −0.00627 at −1/2, +0.00467 at −1/4, +0.01521 at 0). So a circulating drift with Q_ai ≈ −0.36 keeps the zero at that step.

*Fix.* Say "can lose" and name the witness. Exact replacements:

- **03 §1, 170.** "with circulation it can lose the internal–external zero too: in a witness meeting footnote 13 and eq. 9, at h = 1/10, the entry is −27800/984581 while the coupling form holds on its runs (`LinearBlankets.Autonomous.em_couples`, `LinearBlankets.Autonomous.em_coupling_form`)".
- **172.** "where with circulation the four-part blanket can be lost even under footnote 13".
- **184.** "new are the joins to the blanketed law and a circulating witness in which the synchronous scheme loses the four-part blanket".
- **158.** "with a circulating witness in which the synchronous scheme loses the four-part blanket".
- **120, third cell.** "the theory's synchronous steps can lose it with circulation (a witness at h = 1/10)".
- **Linear record statement, en.** "…, while their steady law can lose the four-part zero with circulation (a witness at h = 1/10)".
- **Linear record statement, zh.** "…，而其稳态之律于有环流时可失四部分之零（h = 1/10 之见证）".
- **The other places.** Make the same edit in FEP-INTEGRATION, the regions note, the study, `LANDED` and the queue clause. For the docstring of `em_couples`, use "**With circulation the synchronous scheme can lose the blanket**".

**3. "Loses the active–external one" and "do not stay zero": a formula is stated as a loss, and one claim has no Lean.**

*Where.*

- 170, 03 §1: "which keeps the internal–external zero … and loses the active–external one (`LinearBlankets.em_active_external`)".
- Study, lines 46–47: "and loses the active–external one (em_active_external, …)".
- LinearBlankets.lean, header lines 80–82: "the active–external and sensory–internal entries do not stay zero (`em_active_external`, `Autonomous.em_loses_active_external`)".
- The docstring of `em_active_external` (691): "**The active–external entries do not stay zero**".

*What is wrong.* `em_active_external` (LinearBlankets.lean:694–698) proves that the entry equals −(h/2) Σ_{s sensory} Π_as d_s Π_sj. That sum vanishes whenever Π_as = 0 for every sensory s. Only the witness `Autonomous.em_loses_active_external` proves a nonzero entry. No theorem mentions the sensory–internal entry at all. The record's law 10 states the formula, which is correct, so the texts disagree with the record.

*Evidence.* em_circulation.py: with no circulation and Π_as = 0, the active–external and sensory–internal entries are both 0 at `h = 1/10`. With `Autonomous`'s precision the sensory–internal entry is −1/20, equal to −(h/2)Π_sa Π_ai, but no Lean states it.

*Fix.*

- **03 §1, 170.** "… which keeps the internal–external zero in the four parts with diagonal noise and moves the active–external one by −(h/2) times a sum through the sensory coordinates, which a witness shows nonzero (`LinearBlankets.em_steady`, `LinearBlankets.em_keeps_four_part`, `LinearBlankets.em_active_external`, `LinearBlankets.Autonomous.em_loses_active_external`)".
- **Study, lines 46–47.** Make the same change.
- **LinearBlankets.lean header.** Use "the active–external entries need not stay zero"; drop "and sensory–internal", or add its theorem.
- **Docstring.** "**The active–external entries need not stay zero**".

**4. The board's `LANDED` text puts the no-circulation formula on the circulating case.**

*Where.* board_ue26.py:49–51: "the synchronous steady precision Π − (h/2)ΠDΠ keeping the four-part zero without circulation and losing it with circulation".

*What is wrong.* `em_steady` (LinearBlankets.lean:619–626) holds only for `B = DΠ`, that is Q = 0. With circulation the steady precision is not Π − (h/2)ΠDΠ.

*Evidence.* em_circulation.py: for `Autonomous` at `h = 1/10`, (Π − (h/2)Π²)₃₀ = 0, while the steady precision's entry is −27800/984581.

*Fix.* "the synchronous steady precision, Π − (h/2)ΠDΠ without circulation, keeping the four-part zero there, and in a circulating witness at h = 1/10 losing it, even under footnote 13 and eq. 9".

**5. The page says Langevin flows and Gaussian steady-state densities are now stated. The module states neither.**

*Where.*

- 114: "Langevin flows, the Helmholtz decomposition and nonequilibrium steady states beyond the linear Gaussian case … none is stated".
- 127: "Densities, Langevin flows, the Helmholtz decomposition and steady states beyond the linear case".
- 148: "nonequilibrium steady-state densities beyond the Gaussian".
- 8 (FEP-INTEGRATION) and study line 75: "moves three of the page's §5 rows to stated in the linear case".

*What is wrong.* The LinearBlankets header (lines 15–16) says: "The pinned Mathlib has no stochastic integral, so Langevin flows and densities stay outside the module". The linear record says the same in `does_not_show[0]`, and DESIGN §4 says "Langevin flows and densities stay here". What is stated is the algebra of the steady covariance and the precision, under stated correspondences. The scope phrase "beyond the linear (Gaussian) case" makes the linear Langevin flow and the Gaussian density look stated.

*Fix.*

- **114.** "Langevin flows and densities; the Helmholtz decomposition and nonequilibrium steady states beyond the algebra of the linear case, stated under stated correspondences".
- **127.** "Densities, Langevin flows, the Helmholtz decomposition and steady states beyond the linear case's algebra, the precision of beliefs, learning".
- **148.** "nonequilibrium steady-state densities (the linear case states only the steady covariance's algebra)".
- **FEP-INTEGRATION and the study.** "narrows three items of §5's first entry to what lies beyond the linear case, stated algebraically".

### B. Missing hypotheses

**6. "No assignment to the four parts makes [the chain] sparsely coupled" is false without its hypothesis on the ends.**

*Where.*

- LinearBlankets.lean, header lines 84–86.
- The linear record, `laws[13]` (en: "which no assignment to the four parts makes sparsely coupled"; zh: "无一对四部分之指派使之稀疏耦合").
- Study line 50.
- The periphery receipt's scope sentence, from check_linear_blankets.py.
- Study line 73: "the three-part witness is no blanketed law".

*What is wrong.* `ThreePart.no_four_part` (LinearBlankets.lean:851–852) assumes `part 0 = .internal` and `part 2 = .external`. Without that, the statement fails. Take every coordinate internal: `SparseCoupling` holds vacuously, because both clauses need an external or a sensory coordinate.

"No blanketed law" is not proved either. `split_euler` goes only from sparse coupling to a blanketed Euler step.

*Fix.* Write "which no assignment to the four parts with its ends internal and external makes sparsely coupled" (zh: "无一对四部分、两端为内部与外部之指派使之稀疏耦合"). In study line 73, replace "is no blanketed law" with "is not sparsely coupled with its ends internal and external".

**7. Footnote 13's condition alone is cited for the linear zero.**

*Where.*

- 134, the page's §1: "footnote 13's condition gives the zero precision entry between internal and external coordinates".
- 113 and 141: "or footnote 13's condition in the linear case".

*What is wrong.* `precision_zero_of_footnote13` (LinearBlankets.lean:610–617) also needs diagonal positive noise, Q antisymmetric, the Helmholtz form and `SparseCoupling`. Footnote 13 (2023 paper, p. 11) is only the absence of solenoidal coupling between autonomous and non-autonomous states, attached to the sparse coupling of its eq. 13.

*Fix.* At 134, write "with diagonal positive noise and the principle's sparse coupling, footnote 13's condition gives the zero precision entry …". For 113 and 141, the replacements are in finding 1.

**8. "Independence given the blanket is the cross form on listed states" drops "on listings listing each state once".**

*Where.*

- 38–39 (the Becoming.lean bullet).
- 62 (README) and 72 (README.zh, "即所列诸态上之交叉形式").
- 89–91 (check_becoming.py SCOPE: "is on listed states the joint weight factoring … and the cross form there").
- 120 and 134 (the page).
- 8 (FEP-INTEGRATION) and 197 (the regions note).
- `statement` of the-blanket-at-a-steady-state.
- board_ue26.py:40.

*What is wrong.* `factorsGiven_of_independentGiven` and `crossFormOn_of_independentGiven` (BlanketWeights.lean:416, 459) assume `Distinct li` and `Distinct le`. 03 §1 (167) states this hypothesis correctly.

The equivalence is in fact true for repeated listings, since multiplicities cancel in the cross form, but the Lean does not prove it.

*Fix.* Add "(the converse on listings listing each state once)" (zh: "（逆向于每态列一次之列）").

**9. Positivity is dropped from the sufficient condition.**

*Where.*

- 62 (README) and 72 (README.zh).
- board_ue26.py:41–42.
- The English of `laws[1]`'s last clause: "Conversely, in cross form the ratios read none". The zh of the same law has "细致平衡之正权".

*What is wrong.* `pos : ∀ i b e, 0 < w i b e` is a hypothesis of `crossForm_of_detailedBalance` and `ratio_of_crossForm`.

The forward law also holds without it, because detailed balance with moves at positive rate, joined, forces each (b, e) slice to be all-zero or all-positive. But that version is not what the Lean proves.

*Fix.* Insert "with a positive weighting" (zh: "权皆正"). In `laws[1]`, write "Conversely, positive weights in detailed balance and in cross form have ratios reading none".

**10. Smaller omissions in 03 §1's linear theorem (170).**

- "the Lyapunov equation is the Helmholtz form …": `helmholtz_of_lyapunov` needs S symmetric and invertible. The record's law 0 says so; 03 does not.
- "the zero precision entry is one of the definition's terms" (`unread_zero`) needs positive noise and a positive Hessian diagonal. The 2023 paper's eq. 10 states both.

*Fix.* Add "(S symmetric and invertible)" and "(with positive noise and Hessian diagonals)". In the linear record's `laws[3]`, add "with positive noise and Hessian diagonals".

**11. Two clauses of 03 §1's core theorem (167) say more than is proved.**

- "In a lag relay … its rates reading no external state". The relay's blanket rates do read the external bit (`LagRelay.fullRate`, line 512); only the internal rates do not.
- "In the theory's synchronous law, …, each reading what the blanketed law lets it read". No theorem joins `SynchronousCopy.kernel` to `Blanket.Blanketed`; the module (lines 69–71) and the record (`laws[9]`, `does_not_show[3]`) say "by construction". The kernel is also stochastic, while `Blanketed` is a determined law.

*Fix.* Write "the internal bit's rates reading no external state". Write "In a synchronous kernel, all parts moving at once, each factor reading, by the kernel's construction, only what the blanketed law lets it read, …".

### C. Misattributions

**12. Heins and Da Costa's eq. 15 is called "the normal form".**

*Where.*

- LinearBlankets.lean:37: "the normal form in Heins and Da Costa 2022, eq. 15".
- 170: "footnote 13's condition with its normal form (Heins and Da Costa 2022, eq. 15)".
- The linear record, `correspondence` (en and zh): "eq. 15 (the normal form)".
- Study line 71.

*Evidence.* In arXiv:2205.10190v2 the normal form, with no solenoidal coupling between autonomous and non-autonomous states, is eq. (14). Eq. (15) is the condition under it: "Assuming (14): H_ημ = 0 ⟺ Q_ηs H_sμ = 0 ⟺ H_ηa Q_aμ = 0".

*Fix.* Write "its normal form (Heins and Da Costa 2022, eq. 14, with the condition under it, eq. 15)" (zh: "方程 14 之标准形与其下之条件方程 15").

**13. "The relay's loss" is attributed to sources whose examples are not relays.**

*Where.* 167 and 184; the counts record, `correspondence`; the linear record, `correspondence`; study line 71.

*Evidence.* Biehl, Pollock and Kanai 2021 show sparse coupling without conditional independence (Observation 1). Their counterexample (Appendix A, eq. 52) is a four-coordinate system with couplings in both directions, not a lag relay. The phenomenon is theirs and Aguilera et al.'s; the relay is UE26's witness of it.

*Fix.* Write "sparse coupling without the statistical blanket is known (Biehl, Pollock and Kanai 2021, Observation 1; Aguilera, Millidge, Tschantz and Buckley 2022); the relay is a witness of it".

### D. Wording, consistency and style

**14. "The precision couples i and j" uses "couple" for a statistical dependence.**

*Where.*

- 170: "the precision couples none of the set to j".
- The linear record, `laws[1]`, `laws[2]` and `laws[12]` (zh "精度耦合").
- Study (4) and (5).
- Docstrings in LinearBlankets.

*What is wrong.* The glossary gives coupling one sense: "how strongly one level responds to another" (02). It also gives "couples into", a dynamical reach. UE26's whole point is to tell the coupling form, dynamical, apart from the statistical form. Calling a nonzero precision entry a "coupling" blurs exactly that distinction.

*Fix.* Write "the precision entry between them is nonzero" or "the precision ties them" (zh: "精度之项不为零"). For example: "the precision ties none of the set to j".

**15. The loss is of order h, and the page does not say so.**

*Where.* 113, 141 and 158.

*What is wrong.* Read alone, "the theory's synchronous steps lose it … even under the 2023 paper's term-by-term sparse coupling" sounds like a claim against the principle's continuous-time blanket. The linear record (`does_not_show[3]`) and the module (header lines 86–90) both say the loss belongs to the discrete step.

*Evidence.* em_circulation.py: the internal–external entry is −0.0282 at h = 1/10, −0.00214 at h = 1/100 and −0.000209 at h = 1/1000.

*Fix.* After the synchronous clause on the page, add "(a loss of the discrete step; the continuous-time zero stands)".

**16. The study's "Decisions at landing" names a different added law from the one on the page.**

*Where.* Study line 75 says the page "adds a further law that forbids no sentence of the literature: under the paper's own term-by-term definition, in the linear case, the zero precision entry is one of the definition's terms". The page (113) adds the sufficiency-and-synchronous sentence instead.

*Fix.* Make the two agree; finding 1's replacement for 113 is one option.

**17. The lists of "what is new" disagree.**

*Where.*

- 03 §1's core theorem (167) names nothing new.
- 03 §1's linear theorem (170) names the proof for any set of coordinates.
- 08 §8 (184) names the joins and the synchronous loss.
- The page's Standing (158) names the statement on the theory's conditioning, the join and the loss.
- The study (line 71) names four items.

*Fix.* Use the study's list, with finding 2's wording, in 08 §8 and the Standing, and add one line to 03 §1's core theorem: "new: the statement in the pure core, below `restrict_independent`, and the witnesses on either side".

**18. DESIGN's mechanism for the loss is refuted, and 03 §1's Reading links that design for its readings.**

*Where.* DESIGN.md §3 item 12, repeated at RECHECK-UE26.md:85: "Reading sensory states with the internal–external zero kept passes through circulation …, and exactly there the synchronous scheme loses it."

*Evidence.* em_circulation.py, "world-only circulation": with Q_es = 1 and Q_ai = 0, the internal coordinate reads no sensory coordinate (B₃₁ = Π₃₁ = 0). The drift still meets sparse coupling, footnote 13 and eq. 9. Yet the synchronous steady precision's internal–external entry is +0.0152 at h = 1/10.

*Fix.* Delete "and exactly there …" from DESIGN §3, or replace it with "the loss also occurs with circulation only between the external and sensory coordinates".

**19. Minor items.**

- The zh "率比为一" in the counts record's `laws[8]` and `counterexamples[1]` reads as "the ratio equals one". Use "率比相同".
- The page lists "precision" among what is not stated (114 and 127), while 03 §1 now states laws on the precision Π. Write "the precision of beliefs and its dynamics", as §5 has it.
- The linear record's `standard_boundaries` lacks "discrete-steps", though laws 8–13 (Euler and Euler–Maruyama) depend on discrete steps. The counts record has it.
- "Autonomous" is the 2023 paper's name for the active and internal states taken together. The module uses it for a property: no solenoidal coupling to the rest (`precision_zero_of_autonomous`, the namespace `Autonomous`). That is a second sense of the word. Consider "unmixed" or "solenoidally apart" for the condition, or say once that the module uses the word for footnote 13's condition.
- The packet was built with two different section numbers: FEP-INTEGRATION has 474, the records have 480 (the `--caps` run). Both come from one N at landing (`texts_ue26.py`, `reland_ue26.py`), so this is not an error. Check them once after the landing.

## Checked and sound

- **Core axioms.** All 90 declarations of `BlanketWeights` have empty axiom reports (re-run). The file recompiles against the scratch build. It imports only `Becoming.Blanket` and `Becoming.Flow`. No `propext`, `Quot.sound` or `Classical.choice` comes in through `decide`, `rw`, `cases h :` or `nomatch`.
- **Core definitions.** `CrossForm`, `DetailedBalance`, `FactorsGiven`, `CrossFormOn` and `IndependentGiven` mean what their names say. `IndependentGiven` is conditional independence, with `Share.Same` as cross-multiplication and the zero-weight cases trivial. `restrict_independent_case` really derives `ConditionalWeights.restrict_independent`'s statement.
- **Core witnesses.** I checked each by hand and found them correct:
  - `LagRelay`: the weights 31…31, the 46/72 and 15·72 ≠ 46·24 arithmetic.
  - `Turning`.
  - `ReadsDirectly`.
  - `MovesReadExternal`: weights (1,1,1) and (1,2,2); its `ratio` and `joined` hold.
  - `SynchronousCopy`: kernel total 64; the weights equal the lagged Markov chain's law; the docstring's 9, 6, 3 and 16.
  - `Cycle`: the counter 2→3→0→1, the run, the period 4, and the failing cross product.
  - `Uncovered`.
- **No vacuous hypotheses.** The sufficient law's hypotheses hold together (`ReadsDirectly` meets all of them).
- **Periphery receipt.** It passed. Its source hash matches. Of the 92 declarations, 90 depend on the three standard axioms, one on `propext` and one on none.
- **Periphery mathematics.** Sound:
  - The Helmholtz–Lyapunov identities.
  - `row_zero_iff`, `drift_zero_iff` and `zero_iff_solenoidal`. The last matches Heins and Da Costa's eq. 13 in the scalar case with diagonal Γ.
  - `precision_zero_of_autonomous`, by the quadratic form of D − Q on the set.
  - `TermwiseUnread`, which matches eq. 9's first two rows for diagonal Γ, and `unread_zero`, which matches eq. 10.
  - Footnote 10, "precludes edge cases, in which some non-zero terms cancel", matches the "cancellation" labels. `LagRelay.not_termwise` and `Circulating.not_termwise` check by hand.
  - `Autonomous.termwise` holds for the four required pairs. `Autonomous` meets footnote 13 and `SparseCoupling`.
  - `em_steady`'s precision Π − (h/2)ΠDΠ for B = DΠ, which agrees with the scalar OU result. `em_keeps_four_part`'s term-by-term argument.
  - −27800/984581 (my exact solve gives the same value, and the step's spectral radius is below 1). ThreePart's range 0 < h < 2/(2+√2).
- **Literature.** Correct attributions:
  - The 2023 paper's §4 is "Particles, partitions and things". Its eq. 9 is term-by-term sparse coupling, and footnote 13 is as cited.
  - Kelly's Theorem 9.3 and conditions (ii) and (iii), and Exercise 9.2.2, as given in the literature check.
  - Heins and Da Costa's eqs. 13 and 17–18.
  - Biehl et al.'s Observation 3 as a special case without a third block.
  - Da Costa et al. 2021, Remark 3.1, for `Unsparse`, per the first review's quotation.
- **Record coverage.** Each record's laws cite each declaration of its module exactly once (90 of 90; 92 of 92; no duplicates). Each "and N more" count matches, and each `references` list equals the cited set.
- **Amended record.** The amended record changes only `related` and `history`.
- **Anchors and labels.** The anchors the texts cite exist on main (`r-conditioning-by-restriction`, `r-the-markov-blanket-as-a-coupling-structure`, `observation`, `known-results`). The readings carry "[AI reading, D45]", or "AI reading:" in the records' convention. The core theorem in 03 §1 (167) states the sufficient condition, the distinct-listing converse and the `MovesReadExternal` boundary correctly, and the linear record's laws 10 and 12 are precise.

## Recheck of the fixes (f3863ef99, 09a225854)

AI-written by the same reviewer on 31 October 2026, against `09a225854` on `ue26-kit` in the same worktree.

**What I read.**

- **The kit diff.** Every changed kit file in `git diff 32a60f0d3 09a225854`. `texts_ue26.py` I read in full; the others are `integrate_ue26.py`, `board_ue26.py`, `land_ue26.sh`, `study_ue26.txt`, `make_records_ue26.py` and `DESIGN.md`.
- **The Lean itself, not only its docstrings.** The renamed declarations, with their statements:
  - `LagRelay.precision_nonzero` (LinearBlankets.lean:364);
  - `Autonomous.em_loses_internal_external` (:812), which is `emM 3 0 = −27800/984581 ∧ P 3 0 = 0`, with `emS_steady` and `emS_inverse`;
  - `ThreePart.em_loses_zero` (:875).

  Also `ThreePart.no_four_part` (:862, with `h0 : part 0 = .internal` and `h2 : part 2 = .external`), `em_active_external` (a formula), `drift_zero_iff`, `precision_zero_of_footnote13`, `Autonomous.autonomous`, and the core's `ratio_of_crossForm` and `independentGiven_of_detailedBalance`.
- **The periphery receipt.** `20261031T071322.409555Z` passed, and its source hash equals the file's. The kit's `periphery/` copies of the module and its checker are byte-identical to those in `free-energy/`.
- **The core leaf.** It is rebuilt in the kit's scratch build: 90 declarations, every axiom report empty. f3863ef99 changed only its Standing paragraph. My probe `RatioReadsExternal.lean` still compiles against it, its axiom reports empty.
- **The records.** The three records in the preview `scratchpad/ue26/records-after-review/`, in en and zh. The amended record, diffed against main, changes only `related` and `history`.
- **A search for old names and wording.** It covered the UE26 folder, the periphery module and its checker, and the preview, leaving out the frozen REVIEW and RECHECK files and `review-landing/`.

### Per finding

1. **Resolved.** Every summary now keeps positivity, moves present at every external state, and the ratio condition. The page:
   - In brief: "holds where the internal moves are in detailed balance with a positive weighting, joined at each blanket state by moves present at every external state whose rate ratios read no external state".
   - The claim table, §1 and §2: `SUFFICIENT`, "with positive weights, moves present at every external state and rate ratios reading none".

   The records:
   - The counts statement: "positive weights with the internal moves in detailed balance, joined by moves present at every external state whose rate ratios read none, give it".
   - `laws[1]`.
   - `laws[3]`: "under the second law's conditions". Laws render numbered from 1, so this is the right law.
   - `history[0]`, and the amended record's `related[1]`.

   Elsewhere: the regions note; FEP-INTEGRATION item 11; the README rows (zh "权皆正", "每移之率比不读外部态"); the root bullet; the check_becoming scope; the board's `LANDED`; the commit message.
2. **Resolved.** Each text now says "can lose" or "in a witness":
   - 03 §1: "With circulation it can lose the internal–external zero too: in a witness whose drift meets footnote 13 and eq. 9, the entry at h = 1/10 is −27800/984581".
   - Its Reading: "can be lost even under footnote 13".
   - The claim table: "can lose it with circulation (a witness at h = 1/10)".
   - The linear statement: "can lose the four-part zero with circulation (a witness at h = 1/10)".
   - The board: "in a circulating witness at h = 1/10 losing it".
   - The header: "the internal–external zero can be lost: in a witness".
   - The docstring: "**With circulation the synchronous scheme can lose the blanket**".

   The same change is made in 08 §8, the Standing, FEP-INTEGRATION, regions, the study, the queue clause and the commit message. That is exactly what the Lean proves.
3. **Resolved.** The texts now give a formula and a witness:
   - 03 §1: "moves an active–external entry by −h/2 times a sum through the sensory coordinates, nonzero in a witness". The study's (9) says the same.
   - The header: "an active–external entry is `−h/2` times a sum through the sensory coordinates (`em_active_external`), nonzero in a witness".
   - The docstring: "**need not stay zero** … which vanishes where `Π a s = 0` at every sensory `s` and not in general".

   The sensory–internal clause is gone from the header and from DESIGN. This matches `em_active_external` (an equation) and `Autonomous.em_loses_active_external` (−h/2 at every h).
4. **Resolved.** The board's `LANDED` now reads: "the synchronous steady precision, Π − (h/2)ΠDΠ without circulation, keeping the four-part zero there, and in a circulating witness at h = 1/10 losing it, even under footnote 13 and eq. 9, a loss of the discrete step".
5. **Resolved.**
   - In brief: "Langevin flows, the Helmholtz decomposition and nonequilibrium steady states beyond the linear case's algebra, generalized coordinates, the precision of beliefs".
   - The table row uses the wording I proposed.
   - §5: "nonequilibrium steady-state densities, the linear case stating only the steady covariance's algebra".
   - FEP-INTEGRATION and the study: "narrows three items of §5's first entry to what lies beyond the linear case, stated algebraically".

   The In brief's scope phrase also covers Langevin flows. That is still true: a linear Langevin flow, as a stochastic process, lies beyond that algebra.
6. **Resolved.** The header and the checker scope now say "sparsely coupled under no assignment to the four parts with its ends internal and external". The same hypothesis is in:
   - `laws[13]`, en and zh ("两端为内部与外部之指派");
   - `counterexamples[2]`;
   - the study's (9), and its review paragraph ("not sparsely coupled with its ends internal and external");
   - DESIGN §3.

   This matches `no_four_part`'s `h0` and `h2`.
7. **Resolved on the page.** §1: "with diagonal positive noise and the principle's sparse coupling, footnote 13's condition gives zero precision entries". In brief and §2 use `LINEAR_ZERO`. One place is left, in the linear statement (N5).
8. **Resolved** in:
   - the root bullet and the README rows, en and zh ("逆向于每态列一次之列");
   - the check_becoming scope ("gives both back on listings listing each state once");
   - the page ("on states each listed once");
   - FEP-INTEGRATION and regions;
   - the counts statement and `laws[3]`;
   - the board.

   Two places are left: the counts history and the commit message (N4).
9. **Resolved.** The README rows now say "with a positive weighting" / "权皆正", and the board "with positive weights". The converse in `laws[1]` now names positive weights; that clause's other wording is N3.
10. **Resolved.** 03 §1 now has "steady covariance S (symmetric and invertible)" and "the noise and the Hessian with positive diagonals". `laws[3]` has "the noise and Hessian diagonals positive", and the header, the checker scope and the study say the same.
11. **Resolved.** 03 §1 now says "the internal bit's rates reading no external state" and "In a synchronous kernel, all parts moving at once, each factor reading, by the kernel's construction, only what the blanketed law lets it read". The root bullet, the README rows, the study, and the counts record's `counterexamples[2]` and history (09a225854) follow it. A few places still say "the theory's synchronous blanket" (N2).
12. **Resolved.** The header and 03 §1 say "its normal form is Heins and Da Costa 2022, eq. 14, with the condition under it, eq. 15". The linear correspondence says "eq. 14 (the normal form) with the condition under it, eq. 15" (zh "方程 14 之标准形及其下之条件方程 15"). The study and DESIGN agree.
13. **Resolved.** "Sparse coupling without the statistical blanket is known (Biehl, Pollock and Kanai 2021, Observation 1 …), and the relay is a witness of it" now stands in:
   - 03 §1 and 08 §8;
   - both correspondences, en and zh;
   - the core header's Standing;
   - the study;
   - DESIGN's literature list ("their example, Appendix A, is not a relay").
14. **Resolved, in the Lean.**
    - The three renames are in the module (LinearBlankets.lean:364, 812, 875), in `declarations.txt`, and in every record and text.
    - The docstrings now say the precision entry "is nonzero".
    - `laws[1]`, `laws[2]` and `laws[12]` say the same in en and zh ("精度之项不为零"), and 03 §1 says "every precision entry between the set and j is zero"; the study's (4) and (5) agree.

    No old name survives outside the frozen files. The only "precision couples" left is in two earlier rounds' probe copies (`probes/LinearBlanketsProbe.lean`:48, 60 and `review-probes/LinearBlanketsAxioms.lean`:48, 60). They are evidence of those rounds, and I would leave them.
15. **Resolved.** The page's In brief says "a loss of the discrete step, the drift's continuous-time zero standing", and §2 "a loss of the discrete step". 03 §1 says "the drift's continuous-time zero stands, a loss of the discrete step". The header, the study and FEP-INTEGRATION say the same.
16. **Resolved.** The study's "Decisions at landing" now names the page's fourth further law, in the In brief's terms.
17. **Resolved.** There is now one list of what is new:
    - the statement in the pure core, on the theory's conditioning;
    - footnote 13's law for any set of coordinates;
    - the joins to the blanketed law;
    - the circulating witness.

    03 §1 splits the list between its two theorems: "New: the statement in the pure core, on the theory's conditioning", then "New: the proof of footnote 13's law for any set of coordinates, the joins to the blanketed law, and the circulating witness". 08 §8, the Standing and the study give all four.
18. **Resolved.** DESIGN §3 item 12 now says: "It is one witness, a loss of the discrete step … An earlier draft placed the loss exactly where the internal coordinate reads the sensory one through circulation; that probe refutes it."
19. **Mostly resolved.**
    - "率比相同" is in `laws[8]` and `counterexamples[1]`.
    - "The precision of beliefs" is in the In brief and the table.
    - `discrete-steps` is in the linear record's `standard_boundaries`.
    - Both section numbers in the preview are 480.

    "Autonomous" is now explained once in the header, but the explanation contradicts the Lean (N1).

### New issues introduced by the fixes

**N1. "Autonomous" now has two senses, and under the header's sense law 3 of the linear record loses a hypothesis.** This is the only one that matters.

*Where the new definition is.*

- LinearBlankets.lean:35–38, the header: "a set is autonomous with respect to `j` here when none of its coordinates reads `j`, and footnote 13 adds that no solenoidal flow joins the set to the rest".
- DESIGN.md:170: "'Autonomous' keeps the 2023 paper's sense, said once in the header: a set none of whose coordinates reads `j`, footnote 13 adding no solenoidal flow to the rest".

*What the Lean says.* The module's own `Autonomous.autonomous` (LinearBlankets.lean:750–752) states only that `Q i k = 0` between the internal-and-active coordinates and the rest, which is footnote 13's condition. It is passed as `noQ` to `precision_zero_of_footnote13`. That theorem's "reads no external coordinate" comes from `sparse`, not from autonomy. The same sense, footnote 13's condition, is used in four places:

- the docstring of `precision_zero_of_footnote13` (615–617): "with the internal and active coordinates autonomous, no solenoidal coupling between them and the sensory and external coordinates (the 2023 paper's footnote 13)";
- 03 §1 (texts_ue26.py:93–94): "autonomous (the 2023 paper's footnote 13: no solenoidal flow between them and the rest)";
- the checker scope (check_linear_blankets.py:57);
- the linear record's `laws[2]` (make_records_ue26.py:229): "in the four parts, the internal and active coordinates autonomous, sparse coupling gives them zero precision entries".

*Why it matters.* Read with the header's definition, the four-part clause of `laws[2]` loses its `noQ` hypothesis, and "sparse coupling" becomes redundant.

*Fix.* One sentence, in the header, with no change to any Lean statement or name: "In the 2023 paper the autonomous states are the internal and active ones, those no external state influences; this module uses the word for footnote 13's condition on a set of coordinates, that no solenoidal flow joins it to the rest (`noQ`; `Autonomous.autonomous`), and states separately that no coordinate of the set reads `j` (`absent`)." DESIGN.md:170 should say the same. The header is part of the checked source, so the periphery checker reruns once.

**N2. "The theory's synchronous blanket" is left in a few places.** Low.

*Where.*

- The counts record's `laws[9]`: en "Witness, the theory's synchronous blanket", zh "见证（理论之同步之毯）" (make_records_ue26.py:187, 192).
- BlanketWeights.lean:68: "**The theory's synchronous blanket: …**".
- DESIGN.md:36 and 140.
- study_ue26.txt:3: "the theory's synchronous blanket against it".

*Why it matters.* 09a225854 itself changed the counterexample and the history to "a synchronous copy". 03 §1, the root bullet, the README rows and the board say "a synchronous kernel" or "a synchronous copy". `SynchronousCopy.kernel` is a stochastic kernel, the theory's `Blanket.Blanketed` is a determined law, and no theorem joins them (`does_not_show[3]`). Each place keeps "by construction" nearby, so nothing is false, but the name says more than the Lean does.

*Fix.* Use "a synchronous blanket" (zh "同步之毯") in `laws[9]`; that is shorter, so it stays within the cap. At BlanketWeights.lean:68 use "A synchronous blanket". That is a docstring change, and the leaf is rebuilt at landing anyway. Use "a synchronous blanket" in DESIGN and the study.

**N3. "Unread" in the counts record's `laws[1]` says the reverse of what is meant.** Low.

*Where.* make_records_ue26.py:121–122, en only (the zh is right): "unread rates qualify. Conversely, a positive weighting in detailed balance and cross form has unread ratios". This came from trimming the law to its 420-character cap.

*Why it matters.* "Unread" says the rates or ratios are read by nothing. What is meant is that they read no external state: the external state is the thing unread.

*Fix.* This replacement is 417 characters: "With positive weights, internal states at each blanket state within one closure of moves at positive rate at every external state, each move's rate ratio reading no external state, internal detailed balance gives the cross form, no steady state assumed; rates reading none qualify. Conversely, positive weights in detailed balance and cross form have ratios reading none (crossForm_of_detailedBalance and three more)."

**N4. Two places still say the cross form without the distinct-listing converse (finding 8).** Low.

*Where.*

- The counts record's `history[0]` (make_records_ue26.py:470, zh 475): "independence given the blanket as the cross form on listed states" / "予毯之独立即所列诸态之交叉形式".
- The commit message (land_ue26.sh:47): "conditional independence given the blanket on the theory's conditioning is the cross form on listed states".

*Fix.* Add "on listings listing each state once" (zh "于每态列一次之列"). History has no cap.

**N5. The linear statement cites footnote 13's condition alone (finding 7).** Low.

*Where.* make_records_ue26.py:486, zh 488: "footnote 13's condition gives the zero precision block".

*Why it matters.* The law also needs diagonal positive noise and sparse coupling. `hypotheses[2]` gives them, but the statement reads as if the condition sufficed.

*Fix.* The statement is 293 characters of 300. "footnote 13's law gives the zero precision block" (zh "脚注 13 之律予零精度之块") names the law with its hypotheses and fits.

**N6. DESIGN's summary of the sufficient conditions drops their hypotheses.** Low. Both records' correspondences send readers to DESIGN.md for their readings.

*Where.* DESIGN.md:138: "The statistical form holds under stated sufficient conditions: detailed balance of the internal moves, no circulation through the internal coordinates, or footnote 13."

*Why it matters.* This drops finding 1's conditions. Also, "no circulation through the internal coordinates" alone is not sufficient in the Lean: `precision_zero_of_autonomous` also needs diagonal positive noise and no coordinate of the set reading `j`.

*Fix.* "The statistical form holds under the sufficient conditions of law 3 (positive weights, moves present at every external state, rate ratios reading none) and law 7 (diagonal positive noise, footnote 13's condition, no coordinate of the set reading `j`)."

**Checked and sound in the fixes.**

- **Names.** The renamed declarations state exactly what their names say. `em_loses_internal_external` uses coordinates 3 (internal) and 0 (external) of `Autonomous.part`. `em_loses_zero` gives −h/2 against Π's zero. `precision_nonzero` gives `P 0 2 ≠ 0`.
- **Caps.** Every record law is within its cap; the largest is `laws[1]` at 420 of 420. Apart from N3's wording and N5, no hypothesis was lost in the trimming.
- **Dates.** If the landing slips past 31 October, the board's `UE_NEW` and the landed cell take today's date, and so do the records' dates (`TODAY`). `LANDED` contains no " | ".
- **The new design table.** DESIGN §7's table for this review places each finding where it was in fact taken. The one exception is item 19's "autonomous" (N1).

### Verdict

The fixes take all nineteen findings, and they are correct where it matters most. The sufficient condition now keeps positivity, moves present at every external state and the ratio condition in every summary. The synchronous loss with circulation is everywhere one witness at h = 1/10, a loss of the discrete step. The active–external entry is a formula, the three-part chain carries its hypothesis on its ends, and Heins and Da Costa's eq. 14 and Biehl et al.'s Observation 1 are cited correctly. The three renames are real in the Lean, and the statements under them say exactly what the new names say.

The core leaf is unchanged apart from a docstring, and its 90 axiom reports are empty. The periphery receipt passed on the new bytes. No old name survives in live text.

The fixes introduced one real inconsistency (N1). The header's new sentence defines "autonomous" as "none of its coordinates reads `j`", while the Lean's `Autonomous.autonomous`, the `precision_zero_of_footnote13` docstring, 03 §1, the checker scope and the linear record's `laws[2]` use the word for footnote 13's no-solenoidal-flow condition; read with the header's sense, `laws[2]` loses that hypothesis. One sentence in the header and one in DESIGN fix it, followed by one periphery checker run. The other five (N2–N6) are low-severity residues of findings 7, 8, 1 and 11, plus one trimmed wording ("unread"), each with an exact replacement above. With N1 fixed, I see nothing that should hold the landing.
