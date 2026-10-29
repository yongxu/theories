# U2: the remaining rows on the root (design)

AI-written design, 29 October 2026, on main at `5956c2cff`, branch `u2`. No Lean in the package.

U2 is an item of full unification (OU plan §十三 item 13, 全二, decision D25; [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), FU's U2 in [the proposal](../fu-full-unification/PROPOSAL.md)). OU's owner posted it with its gate open once WRP2 landed and gave it to WRP's designer, this session. The order is a design first, with scratch checks, then one independent review. No Lean is claimed before that review.

**Scratch.**
- [check/tree/Becoming/U2Check.lean](check/tree/Becoming/U2Check.lean): 48 theorems in 68 declarations, every axiom report empty. Built with `scratch_build.py` against main `5956c2cff` ([log](check/scratch-4.log)).
- [check/tree/Becoming/U2Deps.lean](check/tree/Becoming/U2Deps.lean): a dependency check, run with Lean directly because it imports `Lean` ([log](check/deps.log)). For each reading it confirms two things. The reading's proof reaches its row's declaration. And its statement names grammar constants: `«»` names, or declarations of a `Becoming.Grammar*` module, as OU3b's measure recognises them.

**Review.** Pending: one independent review.

## 0. What is asked, and what counts

**The rows.** OU3b's measure at WRP2's receipt rests 24 central rows on no master law under three categories:
- 13 definitional or representational;
- 7 laws of their models;
- 4 single applications.

Their reasons are [EC6's audit §(c)](../ec6-no-master-law/AUDIT.md) and the measure's `NO_LAW` table ([measure_grammar.py](../ou3b-master-laws-on-the-grammar/measure_grammar.py)). EC6's audit lists 14 definitional rows. The 14th, `partForms_iff`, stopped being central at EC6d, which put `PartForms.goAlike` in its place in COVERAGE's actor row.

**What a reading is.** A theorem whose statement is the row's, in the grammar's terms, at one of three places:
- the World's occurrence model (WRT2);
- a process's model of its moves' relations (WRP2);
- the row's own carrier, where the row lives on one.

Its proof goes through the row: it uses the row's theorem, and the row's proof is unchanged. U2Deps checks this for all 19 readings.

**How it counts (change 1).** A reading counts as a representation, not a derivation. No row is derived from a grammar law here, and the count of rows reaching the grammar (全二, 44 of 118 distinct) does not change. The measure separating representation from derivation is MV's line (F5). U2 supplies its values: the table of §2, each row with its reading.

**Premises (F2).** Every premise a reading takes is itself a grammar statement at that model: support, relational neutrality, a selection through the data, determinism, reading through a coupling, and the closure of a finite reading (§3).

**Rows that resist.** For these the result is a written reason, not a forced reading (§4). No row moves only to change a count.

## 1. The models, and what U2 adds to them

### 1.1 The occurrence model of a web (WRT2's)

**Carrier and kinds.**
- The carrier is `Nat × X`, for a web of one kind `V : Web X X`.
- A web of two kinds `W : Web F C` is read through its one-kind reading `W.roles` (`Becoming.Roles`), on the carrier `Nat × (F ⊕ C)`.
- A World's web is of one kind, so every reading in this section is a statement at a World's occurrence model.

**WRT2's own selection, named.** These are its within-step relations and regions, read formation first, as `World.withinStep` reads them:
- `requiring`: `World.withinStep V.requires`.
- `drawing`.
- `needMet`: a need within the condition's level at the step.
- `activeAt`: activity, held as a region or as its partial identity.
- `participating`: requiring or drawing, the union of two of WRT2's relations.

**Added: relations read from amounts across one step.** Each reads one name at two steps, so re-identification does not carry them, as WRT2 found for recurrence:
- `metAfter`: an occurrence's need within the condition's level at the next step.
- `keptAcross`: a dependence kept across the step.
- `lostAcross`: a dependence lost across the step. It reads `Web.MetAbove`'s history along the names.

`keptAcross` and `lostAcross` are read as 缘, from the condition to the formation, as WRT2 reads requiring under `«逆»`.

**Added: one descent and one need comparison.**
- `descentAt t x g`: one descent, as a pair of occurrences, `x` at `t + 1` and `g` at `t`.
- `requiringOf c`: the occurrences requiring `c`, a region.
- `needWithin δ c`: two needs compared with `δ` added. This is an addition on amounts, which U1's limited interface does not hold.

**So** support and dependence are grammar statements in WRT2's name-free selection alone. Keeping, renewal, undermining and transmission read the names and amounts across a step, through the relations just listed.

### 1.2 A process's model (WRP2's)

`moveRel P a` comes from `Becoming.GrammarRegularity`, used as WRP2 uses it. Three of WRP2's readings are used:
- `«定后»` for `Determined`, by `determined_iff_fixed`;
- `«所闭» (Steps P)` for reach, by `reach_iff_withinClosure`;
- `Steps.next` on `Nat`, for the step index.

Added: `breaking K g c` and `keeping K g c`, relations on configurations read from a dependence's amounts at two configurations (`Dependence.Breaks`, `Keeps`).

### 1.3 The rows' own carriers

| Carrier | Relations and regions |
|---|---|
| a valuation's claims | regions held as partial identities (`Web.partialIdentity`), as WRT2 holds activity |
| (step, formation) pairs | `Web.admitted`, met with a significance region (`significantAt`) |
| runs | `Run.AgreeUpTo h` |
| level histories | `couplingAlike` and `exchangingAlike` (the meet over conditions of `sameValue` classes) |
| a code's formations | `copies m e`, read from who hears whom at which sense |
| points and stretches | `member` and `onPoints`, on one carrier `X ⊕ α` |
| functions | `AgreeOn D` |

## 2. The rows

Each row of the table is the row's statement at the place given. "Terms" are the grammar constants U2Deps finds in the reading's statement. The *Model* column uses three labels:
- **occ.**, the occurrence model;
- **proc.**, a process's model;
- **own**, the row's own carrier.

### 2.1 Definitional or representational (13)

| # | Row (region) | Record | Reading in scratch | Model | Terms | What the reading states |
|---|---|---|---|---|---|---|
| 1 | `Web.roles_supported` (actor) | life-as-condition-of-life | `roles_supported_reading`, via `supported_iff` | occ., WRT2's selection | `«则»`, `«而»` | Support at `(t, x)`: what the occurrence requires lies within the needs met. |
| 2 | `Web.roles_dependent` (patient) | life-as-condition-of-life | `roles_dependent_reading`, via `dependent_iff` | occ., WRT2's selection | `«则»`, `«而»` | Dependence: requiring from the active occurrences lies within the needs met. |
| 3 | `Web.roles_alive` (life) | life-as-condition-of-life | `roles_alive_reading`, via `living_iff`, `underminingAt_iff` | occ., across a step | `«能»`, `«而»`, `«合»`, `«逆»` | Living: active, and with no drawing on a condition from which a dependence is lost across the step: `¬ «能» («而» drawing («合» («逆» requiring) lostAcross))`. |
| 4 | `Web.renewingAt_iff_over_all` (evaluation) | represented-boundary-against-dependence | `renewingAt_reading`, via `renewingOver_iff`, `roles_renewingOver` | occ., across a step | `«则»`, `«而»`, `«逆»` | Renewal: active, and requiring, from the conditions it takes part in (the region of all), lies within the kept relation. |
| 5 | `Web.transmits_at_iff` (evolution) | transmission-is-inheritance-and-need | `transmits_at_reading`, via `transmits_at_one_kind`, `inheritsAt_iff`, `needsWithinAt_iff` | occ., across a step | `«则»`, `«而»`, `«逆»`, `«合»` | Two inclusions. (1) What the descendant requires of `c`, carried back one step along the names (`«逆» Steps.along`), the giver requires. (2) The descent, where both require `c`, lies within the need-within relation, which is read from amounts with an addition. |
| 6 | `Limit.identifies_iff_tracks` (learning) | learning-through-a-map-is-tracking-in-the-limit | `identifies_iff_reading`, via `tracks_iff`, `withinSteps_iff_le` | the step index | `«所闭»` | On each run, from some horizon, the closure of the steps on `Nat` lies within agreement with the constant target. That `n ≤ k` is `«所闭» Steps.next n k` is proved from the grammar's closure laws. |
| 7 | `Ideals.verifiableBy_iff_interior` (knowing) | what-a-finite-stretch-verifies | `verifiableBy_reading`, via `interiorBy_iff` | own (`X ⊕ α`) | `«能»`, `«合»`, `«承»` | Every point the reading holds bears membership to a stretch whose every bearer the reading holds (`«承»`, what every condition held). |
| 8 | `unrestricted_iff_livingSignificance` (significance) | continuation-condition-yields-living-significance | **U3's** (§5) | | | |
| 9 | `Valuation.significant_iff_held` (evaluation) | living-significance-on-held-lives | `significant_iff_held_reading`, via four region readings | own (claims) | `«则»`, `«合»` | Where living lies within the own regions together, two things are the same. Living lies within every position's significance. And at each position its own living lies within its significance (S0), while living and significant from one position lies within every other's (N_std). |
| 10 | `Web.significance_undetermined` (evaluation) | continuation-condition-yields-living-significance | `significance_undetermined_reading`, via `retains_iff`, `adds_iff` | own ((step, formation), claims) | `«则»`, `«合»`, `«逾»` | With the empty region of significance, what one path admits with it lies within what every other admits, and exceeds nothing. With the full region, living lies within significance; with the empty one it does not, where an event lives. A free region shown free. |
| 11 | `Dependence.Overdetermined.only_together` (responsibility) | joint-difference-making | `only_together_reading`, via `overdetermined_iff` | proc. | `«能»`, `«合»`, `moveRel` | An overdetermined loss: the move's relation meets the breaking from the configuration and from each withholding. So the parts make the difference only together. |
| 12 | `ExchangeLaw.response_not_fixed_by_coupling` (alignment) | what-a-pools-acts-respond-to | `response_not_fixed_reading`, via `through_iff_inclusion` | own (histories) | `«则»`, `sameValue`, `«谓»`, `«一»` | Reading through the coupling is an inclusion: alike through every formation's coupling lies within exchanging alike. Some such law does not relate the two histories by what is taken. Another has the full relation at every step. |
| 13 | `Viability.kernel_and_iff` (maintenance) | conditions-kept-together | `kernel_and_reading`, via `kernel_iff` | proc. | `«所闭»` | A kernel: the closure of the steps from a configuration lies within the guard. It lies within a meet exactly where it lies within each. |

### 2.2 Laws of their models (7) and single applications (4)

| # | Row (region) | Record | Reading in scratch | Model | Terms | What the reading states |
|---|---|---|---|---|---|---|
| 14 | `Dependence.differenceOnlyTogether_iff` (actor) | joint-difference-making | `differenceOnlyTogether_reading` | proc. | `«定后»`, `moveRel`, `«能»`, `«合»` | With each move's relation fixing its successor, the parts make the difference only together exactly where they do together, and each one's withholding leaves the move's relation meeting the breaking. |
| 15 | `Run.not_fixes_of_untaken` (knowing) | experiment-needs-return | `not_fixes_reading`, via `fixes_iff` | proc., relations indexed by moves | `«定后»`, `moveRel`, `«际»` | A record fixes an outcome exactly where every family of relations indexed by moves relates `s` by `a` only to `u`, each relation fixing its successor and the family holding the run's steps (WRP2's pattern, `forall_moveRel_iff`). For an untaken move no outcome is so fixed. |
| 16 | `SharedCodes.run_agrees_every_start_iff` (collective) | a-code-formed-between-formations | `run_agrees_every_start_reading`, via `origin_iff_li` | own (formations) | `«而»`, `«逆»`, `«历»` | Agreement from every start: every two formations are reached from one formation through the hearings' copying relations in turn. A formation's origin is what passes into it along the word (`origin_iff_li`). |
| 17 | `responses_le_missBound` (patient) | what-a-cut-loses | resists (§4) | | | |
| 18 | `Drift.falls_back` (evolution) | drift-offspring-sampled | resists (§4) | | | |
| 19 | `RelativePosition.rise_needs_fall` (collective) | relative-position-is-zero-sum | resists (§4) | | | |
| 20 | `Web.optimum_broken_iff` (alignment) | what-an-optimum-does-beyond-what-couples-in | resists (§4) | | | |
| 21 | `Web.living_on_reaches` (life) | living-on-and-descent | `living_on_reaches_reading`, via `neutral_transmits_iff` | own (claims) | `«闭»`, `«合»` | N_rel is significance from each position closed under the formed relation into living content. The row is one step of that closure, along living on. |
| 22 | `Flow.descent_reaches` (life) | living-on-and-descent | `descent_reaches_reading` | own (claims) | `«闭»`, `«合»` | The same, along descent. |
| 23 | `Learning.Training.unselected_beyond_data` (learning) | generalization-through-lumping | `unselected_beyond_data_reading`, via `through_iff` | own (functions) | `«闭»`, `«逆»` | A selection through the data is closed both ways along agreement on it. The row's proof uses the closure back along agreement once. |
| 24 | `Renewable.no_exact_finite_reading` (capacity) | becoming-finite-horizon | `no_exact_finite_reading_reading`, `no_exact_finite_reading_iff` | own (runs) | `«闭»` | No region of runs closed under agreeing up to `h` is the region of renewing runs. Equivalently, that region is not closed under agreeing up to `h`. |

**Notes on single rows.**
- **Rows 1–5: the same occurrence model for one kind and two.** Each is stated first for a web of one kind, then for a two-kind web through `W.roles`. The rows' own bridges, `roles_supported`, `roles_dependent` and `roles_alive`, are used as they stand. `Becoming.Roles` has no bridge for renewal over a region, so U2 adds `roles_renewingOver` in its own module, beside the region `onConditions` it needs, and leaves Roles unchanged.
- **Row 5's two inclusions are of different kinds.** Inheritance is a statement in WRT2's requiring and the names' step. The need within `δ` reads two needs against each other with an addition, which neither WRT2's selection nor U1's interface states.
- **Row 6's horizon.** The statement keeps Tracks' horizon `n`. Only "from `n` on" is read in the grammar.
- **Row 13's reach.** `Kernel` reads reach as `«所闭» (Steps P)`, through WRP2's `reach_iff_withinClosure`.
- **Row 16's copying relation.** `copies m e j i` says that `i` holds, after the hearing, `j`'s form before it. This is the converse of `SharedCodes.back` read as a relation. The proof that `origin` is `«历»` is by induction on the word.

## 3. Premises as grammar statements at the model (F2)

| Premise | Grammar statement | Where |
|---|---|---|
| support at an occurrence | `«则» («而» (partial identity at x) requiring) needMet` | `supported_iff`; occurrence model, WRT2's selection |
| dependence (support of the active) | `«则» («而» (partial identity of activity) requiring) needMet` | `dependent_iff` |
| relational neutrality (N_rel) | `∀ p, «闭» («合» related (into living)) (sig p)` | `neutral_transmits_iff`; claims |
| standpoint neutrality (N_std), S0, held lives | inclusions of partial identities | `shares_iff_reading`, `selfSignificance_iff_reading`, `held_iff_reading` |
| a selection through the data | `«闭» E select ∧ «闭» («逆» E) select` | `through_iff` |
| a determined process | `∀ a, «定后» (moveRel P a)` | WRP2's `determined_iff_fixed` |
| a law reading through a coupling | `«则» (couplingAlike W obs h t) (exchangingAlike law t h)` | `through_iff_inclusion` |
| a reading decided by the first `h` steps | `«闭» (agreeing up to h) reading` | `no_exact_finite_reading_reading` |
| transmission at a descent | the two inclusions of row 5 | `inheritsAt_iff`, `needsWithinAt_iff` |

**The rows that take support as a premise.** Nine rows are "premise of the account" (support, dissipation). They are not U2's: U1 §4 leaves them unchanged, and their content is Price's identity and counting on amounts. Support's grammar statement above is the statement they would cite. That citation makes them statements at the model with a grammar premise. It does not derive them.

## 4. The rows that resist, with reasons

Each keeps its category, and its reason now cites U1's verdict. Amounts are the root's second sort, with a limited interface: frame bijections, a fixed predecessor at a frame, the crossing laws, the residual-count laws and their dissipation case, lossless storage excluded, and the stretch law under a supplied pairing. That interface states no addition, product or order of amounts, and no comparison of a need with a level.

- **`responses_le_missBound`** (law of its model). It bounds what a cut at order `j` loses by `Loops.missBound M D j t`, for every schedule of couplings, using `carried_le_carriedWithin_add`. The content is that numerical bound, in sums of carried amounts. The couplings' schedule is relational, but it carries none of the bound. A reading would restate the inequality with the amounts unread.
- **`Drift.falls_back`** (law of its model). A second-moment bound on samplings weighted by binomial weights. This is counting with products and binomial coefficients, outside the interface. It has no premise of the unfolding to read.
- **`RelativePosition.rise_needs_fall`** (law of its model). A counting identity. Over the family, each part's rise count (`n·b p + Σa`) and fall count (`n·a p + Σb`) total alike, by commutativity and distribution (`change_balances`), so a rise needs a fall.
  - In the grammar, the totals' equality could only be a perfect pairing (`«对»`, with `«对则守数»`) of rise units against fall units.
  - That needs amounts as unit lists for every profile, and products as repeated lists. U1's unit selection holds only at a World's condition frames and has no product.
  - The reading would need a pairing the interface does not have. By U1's test such a law is "a discipline, to be named as a premise", not a reading.
- **`Web.optimum_broken_iff`** (law of its model). An optimum of an order rising with the family, with room beyond, breaks exactly what some eligible outcome breaks. Its content is `least_of_room`, the drive to the least level beyond. That is an order law of amounts: `Exceeds` is a componentwise `≤` with a strict `<` on the family.
  - The relational part reads in §1.1's relations: `Broken` is a need met and left below after the step. Restating it alone would be a definitional mention, because the law is the order.
  - **What would change it.** U1 §4 says the comparison `need ≤ level` "could read as units paired into the standing units: representation, not done". If that law joins the interface, `Exceeds` reads as units of one outcome paired into another's. This row could then be stated at the unit model.

## 5. The row U3 holds

`unrestricted_iff_livingSignificance` is one of U3's five significance rows. U3's design (in `development/u3-significance-on-the-root/`, not yet on main) gives it a root form: `noOutside_iff_paths_livingSignificance`, the condition in its structural reading on a web's level paths. U2 restates nothing of it and counts it with U3.

Two of U2's readings sit next to U3's rows, and U3 may use them in place of the native forms its scratch keeps:
- `retains_iff`: Retaining is an inclusion (`«则»`) at what the paths admit, met with a significance region;
- `adds_iff`: Adding is exceeding (`«逾»`) there.

Whichever item lands first holds them, with nothing duplicated.

## 6. «保之像» beside «像»: a small Lean item after U2

**The item.** `«保之像»` moves from `Becoming.GrammarTransport` to `Becoming.GrammarLaws`, beside `«像»`, with its statement and name unchanged and no copy left behind. Mechanism's `factors_image` and `Image.least` then become its cases:
- the image lies within its own process's moves;
- a process the step factors through holds the image.

Their statements and names are unchanged. Mechanism imports no GrammarTransport, which is why the move comes first.

**Why after U2 and not folded in.**
- No U2 reading uses `«像»` or `«保之像»`.
- U2 adds one leaf and changes no module.
- The move changes GrammarLaws, which nearly every module imports, so the checker rebuilds the package. It also needs three owners: GrammarLaws' owner, who decided the move; GrammarTransport's owner, WRT's designer; and Mechanism's owner, which no note names, so rule 3's fallback applies.

Folding it in would tie a leaf's landing to a full rebuild and to two more owners' decisions.

**When.** As its own item, at a quiet point in the queue, rehearsed outside the repository as WRP2 was. Its design is the paragraph above, plus a check that `factorsThrough_iff_image` (`Becoming.ProcessRepresentation`) is unchanged.

## 7. Placement, and the Lean item proposed (none claimed)

**One core leaf module.** Its working name is `Becoming.ModelStatements`. The name is deliberately not `Becoming.Grammar*`: OU3b's measure counts every declaration of a `Grammar*` module as a grammar constant, and U2's are not grammar laws. It holds `U2Check`'s declarations, minus the scratch header. It imports only Becoming modules, so the pure core's rules apply. Adding it changes no other module's source, so the checker builds only it.

**No module changes.** Every reading, including the one new bridge (`roles_renewingOver`), is in the leaf. The rows' modules and their owners are untouched, so no owner's decision is needed for any module.

**One record.** Its working id is `definitions-and-model-laws-at-the-models`. Its laws come by model:
- the occurrence model: support, dependence, keeping, renewal, undermining, transmission;
- a process's model: kernel, overdetermination, joint difference, fixing;
- the rows' own carriers: significance regions, N_rel, selection, the finite reading, coupling, copying, verification.

It states what U2 does not show (§8).

**Its home.** Proposed: a new 01 §8.8 after §8.7, "The rows at the models". OU's owner decides.

**The rows' records.** Unchanged. A `related` link from each to the new record is optional, by OU's owner's decision under rule 3's fallback.

**The measure.** U2 supplies the reading of each row in §2, the reasons of §4 updated to cite U1's verdict, and U3's row. MV's F5 separates representation from derivation and reads them. The `NO_LAW` table is OU's owner's.

**At landing.** Rerun MV's generator. Render and check in a clean worktree. Rehearse outside the repository first. The checker run is one leaf.

## 8. What this establishes, and what it does not

**Established, in scratch, at the scopes above.**
- 19 of the 24 rows have statements whose terms are the grammar's, at a World's occurrence model, a process's model or the row's own carrier.
- Each statement is proved through its row.
- Each premise the readings take is a grammar statement at the model.
- Support and dependence use WRT2's name-free selection alone.

**Not established.**
- **No derivation.** No row is derived from a grammar law. The definitional rows' readings are their definitions written in the grammar's terms. The model laws keep the row's proof.
- **Names and amounts.** The across-step relations read the names and amounts, so re-identification does not carry them. The need-within relation adds amounts, outside U1's interface. The occurrence model's selection is extended by named relations read from amounts; it does not hold amounts as the grammar's own.
- **Four rows resist** (§4). One row is U3's.
- **The 9 premise rows** keep U1's verdict.
- **A partial identity at one occurrence** names that occurrence. Support is a statement about one occurrence, not a name-free class.

**What would change this.**
- U1's interface gaining the comparison of a need with a level, as units paired into standing units. Then the comparisons in §1.1 (need met, met after the step, below after it) read in units, and `optimum_broken_iff` with them.
- A law of unit lists for products, which would bear on `rise_needs_fall`.

## 9. Owners

- **The design, the scratch and, once claimed, the leaf and its record:** this session, WRP's designer.
- **The rows' modules:** unchanged, so none is engaged.
- **GrammarLaws, GrammarTransport and Mechanism:** only for §6's item, as named there.
- **WHAT-REMAINS and the measure's `NO_LAW` table:** OU's owner.
- **F5's report:** MV.
