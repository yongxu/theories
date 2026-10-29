# U2: the remaining rows on the root (design)

AI-written design, 29 October 2026, on main at `5956c2cff`, branch `u2`. No Lean in the package.

U2 is an item of full unification (OU plan §十三 item 13, 全二, decision D25; [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), FU's U2 in [the proposal](../fu-full-unification/PROPOSAL.md)). OU's owner posted it on the board, proposed with its gate open (on main at `a15457b2e`). This session claims it as this design lands. OU's owner gave the item to WRT's and WRP's designer, this session. The shape is a design first, with scratch checks, then one independent review; no Lean is claimed before that.

**Status: reviewed once; every finding is taken ([REVIEW-U2](REVIEW-U2.md)). Placement decided by OU's owner on 29 October 2026, as §6 and §7 propose. The decisions are recorded on U2's row and in WHAT-REMAINS (on main at `a15457b2e`).**

**Scratch.**
- [check/tree/Becoming/U2Check.lean](check/tree/Becoming/U2Check.lean): 77 theorems in 120 declarations, every axiom report empty, built with `scratch_build.py` against main `5956c2cff` ([log](check/scratch-5.log)). Its namespace, `Becoming.ModelStatements`, is the one proposed for the leaf.
- [check/tree/Becoming/U2Deps.lean](check/tree/Becoming/U2Deps.lean): a dependency check, run with Lean directly because it imports `Lean` ([log](check/deps.log)). It is its own test, not OU3b's measure. For each reading it reports three things:
  - whether the proof reaches the row's declaration;
  - the grammar terms its statement names: «» names other than the relation type «际»;
  - every other constant the statement names, beyond U2's own relations, WRT2's and WRP2's model relations, and Lean's `Init`.

  That last list is what the reading keeps in other terms. It passes for all 20 readings, and §2's column records its report.
- [check/tree/Becoming/U2Preserving.lean](check/tree/Becoming/U2Preserving.lean): §6's two cases of `«保之像»`, 2 theorems, empty axiom reports ([log](check/preserving.log)).

## 0. What is asked, and the one criterion

**The rows.** OU3b's measure at WRP2's receipt rests 24 central rows on no master law, under three categories:
- 13 definitional or representational;
- 7 laws of their models;
- 4 single applications.

Their reasons are [EC6's audit §(c)](../ec6-no-master-law/AUDIT.md) and the `NO_LAW` table of [measure_grammar.py](../ou3b-master-laws-on-the-grammar/measure_grammar.py). EC6's audit has 14 definitional rows; its 14th, `partForms_iff`, left COVERAGE at EC6d, when the actor row came to cite `PartForms.goAlike` instead.

**A reading** is a theorem whose statement is the row's, stated at one of three places:
- a World's occurrence model (WRT2's);
- a process's model of its moves' relations (WRP2's);
- the row's own carrier, where the row lives on one.

Its proof goes through the row's theorem, whose proof is unchanged.

**The criterion, the same for all 24 rows.** A row is stated at the model where every term of its statement is one of these:
- a relation or region of the model: a grammar term, WRT2's or WRP2's selection, or a named relation of the model;
- a named comparison of the model's given amounts, possibly with a supplied amount added (a need against a level, two levels, two outcomes' levels at a condition);
- a supplied parameter;
- in a definitional reading, the row's own notion on the left of the equivalence.

A row resists where a term of its statement is an amount computed over a family by arithmetic: sums, products, moments, the bound of a propagation. A relation "read from" such an amount would only be the statement renamed. Under this criterion 20 rows are read, 3 resist (§4), and 1 is U3's (§5).

**How it counts (change 1).** Each reading counts as a representation, not a derivation. No row is derived from a grammar law here, and the measure's count of central declarations reaching the grammar (45 of 127 rows, 44 of 118 distinct) does not change. Telling representation from derivation in the measure is MV's line (F5); U2 supplies its values, the row-to-reading pairs of §2.

**Premises (F2).** The account's premises that the readings take are grammar statements at the model (§3), and so are the rows' other hypotheses, apart from what §3 lists as kept.

## 1. The models, and what each added relation reads

**The occurrence model.**
- For a web of one kind `V : Web X X`, the carrier is `Nat × X`.
- A web of two kinds `W : Web F C` is read through its one-kind reading `W.roles` (`Becoming.Roles`), on the carrier `Nat × (F ⊕ C)`.
- Every one-kind web is a World's web, through `World.of`, so these are statements at a World's occurrence model.
- A valuation's claims `(x, t)` are the occurrences `(t, x)` with their coordinates swapped. The readings that involve claims (rows 21–22) state their relations on the occurrences.

| Relation or region | What it reads | In WRT2's ten carried relations? |
|---|---|---|
| `requiring`, `drawing`, `needMet`; activity, presence, standing, `giving` | within a step | yes (`World.reidentify_carries`) |
| `participating` | within a step: requiring or drawing | a union of two of them; not shown to be carried |
| `bearing` | within a step: requiring with the need's sign | no. It is of the kind `Reidentify.withinStep_carried` covers, but that is not stated for it |
| partial identity at one occurrence `(· = (t, x))` (support) | names one occurrence | no |
| `sameName` | one name at any two steps | no: it reads the names |
| `Steps.along` | one name at consecutive steps (WRT2's names' step) | no |
| `metAfter`, `belowAfter`, `keptAcross` | a need at `t` against a level at `t + 1`: the condition's name at two steps | no; not shown to be carried |
| `undermined` | `Web.MetAbove`: requiring at every step since the dependence formed, a need met then, and the level at `t + 1` | no; not shown |
| `comesToStand`, `descentStep`, `descendsRel` | standing at two steps along the names; presence and giving within a step; any steps through `sameName` | no; not shown |
| `requiringOf c`, partial identity `(·.2 = c)` | the name `c` at every step | no |
| `needWithin δ c` | two needs for `c` compared with `δ` added; the name `c` at two steps | no; the addition is outside U1's interface |
| `atPair p q` | exactly one pair of occurrences | no |

**A process's model (WRP2's).**
- `moveRel` (`Becoming.GrammarRegularity`), with three readings WRP2 uses: `«定后»` for `Determined` (`determined_iff_fixed`, Laws), `«所闭» (Steps P)` for reach (`reach_iff_withinClosure`, Frame), and the steps on `Nat`, `Steps.next` (Arising).
- Runs are the model's lines (`run_iff_image`). Agreeing up to `h` reads the configurations within `«所闭» Steps.next` up to `h` and the moves before it, through `«及» Steps.next` (`agreeUpTo_iff`, `before_iff_lt`).
- Added relations:
  - `withholding f`, the supplied map read as a relation; withholding all parts is `«历»` of these (`withholdAll_iff_li`);
  - `requiresAt` and `needMetAt`, regions of configurations: requiring, and a need against a level at one configuration;
  - `breaking` and `keeping`, a need at `s` against levels at `s` and `t`.
- The hearing process: what a word of hearings reaches is `«历»` of the moves (`reached_iff`). The copying relation `copies m e` is read from who hears whom at which sense.

**The rows' own carriers.**
- Claims: regions held as partial identities.
- (step, formation) pairs: `Web.admitted` (OU3b's reading, needs against levels) met with `significantAt`.
- Level histories: `couplingAlike` (`Web.Admits`, needs against levels, and levels equal at coupled conditions) and `exchangingAlike` (the meet over conditions of the `sameValue` classes of a supplied law's outputs).
- Points and stretches: `member` and `onPoints`, on `X ⊕ α`.
- Functions: `agreeingOn D`, the meet over the data of the `sameValue` classes of values.
- Outcomes `C → Nat`: `exceedsOn` and `lowerBeyond`, comparisons of given levels.

**U1's limited interface.** It states equal counts from a matching and its residual-count laws, with their sums of counts. It states no product, no componentwise order of outcomes, and no comparison of a need with a level. So every comparison of a need with a level above (`needMet`, `Web.admitted`, `keeping`, `couplingAlike`) is a relation of the model read from amounts, not a law of the second sort, as is the order of outcomes (`exceedsOn`).

## 2. The rows

The *Model* column uses three labels: **occ.**, the occurrence model; **proc.**, a process's model; **own**, the row's own carrier. *Kept in other terms* is U2Deps' report, beyond the model's structures and data.

### 2.1 Definitional or representational (13)

| # | Row (region) | Record | Reading (scratch) | Model | Kept in other terms | What the reading states |
|---|---|---|---|---|---|---|
| 1 | `Web.roles_supported` (actor) | life-as-condition-of-life | `roles_supported_reading` (`supported_iff`) | occ. | `Web.Supported`, on the left | Support at `(t, x)`: what the occurrence requires lies within the needs met. The partial identity of one occurrence is added to WRT2's relations |
| 2 | `Web.roles_dependent` (patient) | life-as-condition-of-life | `roles_dependent_reading` (`dependent_iff`) | occ. | `Web.Dependent`, on the left | Requiring from the active occurrences lies within the needs met: WRT2's relations alone |
| 3 | `Web.roles_alive` (life) | life-as-condition-of-life | `roles_alive_reading` (`living_iff`, `underminingAt_iff`) | occ., across a step | the living event, on the left | Active, and `¬ «能» («而» drawing («合» («逆» requiring) undermined))`: no drawing on a condition from which a dependence is undermined |
| 4 | `Web.renewingAt_iff_over_all` (evaluation) | represented-boundary-against-dependence | `renewingAt_iff_over_all_reading` (`renewingAt_reading`, `renewingOver_reading`, `roles_renewingAt`, `roles_renewingOver`) | occ., across a step | none | Both sides at the model. Renewal at a step: active, and requiring, from the conditions taken part in, lies within the kept relation. Renewal over a region: the same, the source met with the region. The row is their equivalence for the region of every condition |
| 5 | `Web.transmits_at_iff` (evolution) | transmission-is-inheritance-and-need | `transmits_at_reading` (`transmits_at_one_kind`, `inheritsAt_iff`, `needsWithinAt_iff`) | occ., across a step | transmission in the web's data, on the left | Two inclusions. (1) What the descendant at `t + 1` requires of `c`, read from the giver and carried back one step along the names, the giver at `t` requires. (2) The pair, where both require `c`, lies within `needWithin δ c` |
| 6 | `Limit.identifies_iff_tracks` (learning) | learning-through-a-map-is-tracking-in-the-limit | `identifies_iff_reading` (`tracks_iff`, `withinSteps_iff_le`) | the step index | `Limit.Identifies`, on the left | On each run, from some horizon `n`, the closure of the steps from `n` lies within agreement with the constant target |
| 7 | `Ideals.verifiableBy_iff_interior` (knowing) | what-a-finite-stretch-verifies | `verifiableBy_reading` (`interiorBy_iff`) | own (`X ⊕ α`) | `VerifiableBy`, on the left | Every point the reading holds bears membership to a stretch every bearer of which the reading holds (`«承»`) |
| 8 | `unrestricted_iff_livingSignificance` (significance) | continuation-condition-yields-living-significance | U3's (§5) | | | |
| 9 | `Valuation.significant_iff_held` (evaluation) | living-significance-on-held-lives | `significant_iff_held_reading` | own (claims) | none | Where living lies within the own regions together: living lies within every position's significance exactly where each position's own living lies within its significance (S0), and living and significant from one lies within every other's (N_std) |
| 10 | `Web.significance_undetermined` (evaluation) | continuation-condition-yields-living-significance | `significance_undetermined_reading` (`retains_iff`, `adds_iff`, `livingClaim`) | own, and occ. | none | For a claim living at the occurrence model, three statements. With the empty region of significance, what one path admits with it lies within what every other admits, and exceeds nothing. With the full region, the living claims lie within significance. With the empty one, they do not |
| 11 | `Dependence.Overdetermined.only_together` (responsibility) | joint-difference-making | `only_together_reading` (`overdetermined_iff`, `makesDifferenceTogether_iff`, `withholdAll_iff_li`) | proc. | none | Where the move's relation meets the breaking from `s` and from what each withholding leaves, the but-for statement for the parts together (`differenceAt`, from `«历»` of the withholdings) holds for no single part |
| 12 | `ExchangeLaw.response_not_fixed_by_coupling` (alignment) | what-a-pools-acts-respond-to | `response_not_fixed_reading` (`through_iff_inclusion`) | own (histories) | none (decidability data kept, §3) | Where each coupling class of `l` is decided and `g` couples `l` and `l'` apart up to `t`, two laws exist. Each has its exchanging alike containing every formation's coupling class. For the first, what `g` takes from `c` across the step from `t` is not alike under `l` and `l'`. For the second, exchanging alike is the full relation at every step |
| 13 | `Viability.kernel_and_iff` (maintenance) | conditions-kept-together | `kernel_and_reading` (`kernel_iff`) | proc. | none | The closure of the steps from `s` lies within a meet exactly where it lies within each: a law of logic, for any relation |

### 2.2 Laws of their models (7) and single applications (4)

| # | Row (region) | Record | Reading (scratch) | Model | Kept in other terms | What the reading states |
|---|---|---|---|---|---|---|
| 14 | `Dependence.differenceOnlyTogether_iff` (actor) | joint-difference-making | `differenceOnlyTogether_reading` | proc. | none | Two premises hold: each move's relation fixes its successor, and from what each withholding leaves the move is available and the dependence is required and met there (`requiresAt`, `needMetAt`). Then the parts make the difference only together exactly where they do together and, from what each withholding leaves, the move's relation meets the breaking |
| 15 | `Run.not_fixes_of_untaken` (knowing) | experiment-needs-return | `not_fixes_reading` (`fixes_iff`, `takes_iff`, `before_iff_lt`) | proc., runs as lines | `x ≠ y`, logic | Two premises hold: each move's relation fixes its successor, and two configurations differ. Then, where the run's line does not pass `(s, b)` at any step before `t` (`«及» Steps.next`), no record relates `s` by `b` to one outcome |
| 16 | `SharedCodes.run_agrees_every_start_iff` (collective) | a-code-formed-between-formations | `run_agrees_every_start_reading` (`runs_agree_iff_reached`, `reached_iff`, `origin_iff_li`) | proc., and own (formations) | `a ≠ b`, logic | Where two forms differ, two statements are equivalent. (1) Every code the first `k` hearings reach (`«历»` of the moves) from any start has all formations alike at `m`. (2) Every two formations are reached from one formation through the hearings' copying relations in turn: `«则» «一» («而» («逆» («历» copies)) («历» copies))` |
| 17 | `responses_le_missBound` (patient) | what-a-cut-loses | resists (§4) | | | |
| 18 | `Drift.falls_back` (evolution) | drift-offspring-sampled | resists (§4) | | | |
| 19 | `RelativePosition.rise_needs_fall` (collective) | relative-position-is-zero-sum | resists (§4) | | | |
| 20 | `Web.optimum_broken_iff` (alignment) | what-an-optimum-does-beyond-what-couples-in | `optimum_broken_reading` (`rising_iff`, `room_iff`, `frontier_iff`, `metOn_iff`, `broken_iff`) | own (outcomes), and occ. | none | Four premises hold:<br>• the order contains exceeding on the family (`«则» exceedsOn better`);<br>• room beyond: where an eligible outcome stands lower than another beyond, something eligible exceeds the first;<br>• the levels after the step are eligible and nothing eligible beats them;<br>• each condition beyond is required and met by the formation named on it.<br>Then a dependence beyond is broken across the step (required, met, and below after it) exactly where some eligible outcome stands below its need there |
| 21 | `Web.living_on_reaches` (life) | living-on-and-descent | `living_on_reaches_reading` (`sustenance_neutral_iff`, `livesOn_iff`, `interacts_iff`) | occ. | none | N_rel for the sustenance valuation is `«闭» («合» sustenanceRel livingOcc)` of significance on the occurrences. The row is one step of it, along `livesOn` |
| 22 | `Flow.descent_reaches` (life) | living-on-and-descent | `descent_reaches_reading` (`descent_neutral_iff`, `descends_iff`) | occ. | none | The same along descent: present, giving, coming to stand |
| 23 | `Learning.Training.unselected_beyond_data` (learning) | generalization-through-lumping | `unselected_beyond_data_reading` (`through_of_closed`, `free_iff`, `agreeingOn`) | own (functions) | none | With the selection closed along agreeing on the data (one closure, agreement being symmetric) and the class free at `x` (an inclusion), a selected member is related to each member through a selected member of the class agreeing with it on the data, alike at `x` with the second |
| 24 | `Renewable.no_exact_finite_reading` (capacity) | becoming-finite-horizon | `finite_reading_not_exact`, `finite_reading_iff` (`agreeUpTo_iff`, `renewing_iff_along`, `renewingIn_iff`) | proc., runs as lines, and occ. | none | No region of runs closed under agreeing up to `h` is the region of runs along which the focal formation renews, read at the occurrence model of the run's web. Equivalently, that region is not so closed |

## 3. Premises, and what is kept

**The account's premises the readings take, as grammar statements at the model.**

| Premise | Grammar statement | Where |
|---|---|---|
| support at an occurrence | `«则» («而» (partial identity at x) requiring) needMet` | `supported_iff` |
| dependence | `«则» («而» (partial identity of activity) requiring) needMet` | `dependent_iff` |
| relational neutrality (N_rel) | `∀ p, «闭» («合» related (into living)) (sig p)`, from `Valuation.transmits_iff_closed`; at the occurrence model for sustenance and descent | `neutral_transmits_iff`, `sustenance_neutral_iff`, `descent_neutral_iff` |
| standpoint neutrality (N_std), S0, held lives | inclusions of partial identities | `shares_iff_reading`, `selfSignificance_iff_reading`, `held_iff_reading` |
| transmission at a descent | the two inclusions of row 5 | `inheritsAt_iff`, `needsWithinAt_iff` |
| a determined process | `∀ a, «定后» (moveRel P a)` | `determined_iff_fixed` |
| a selection through the data | `«闭» (agreeingOn D) select` | `through_of_closed` |
| a law reading through a coupling | `«则» (couplingAlike W obs h t) (exchangingAlike law t h)` | `through_iff_inclusion` |
| a reading decided by the first `h` steps | `«闭» (agreeing up to h) reading` | `finite_reading_not_exact` |

**What the readings keep.**
- **Decidability data** (row 12): `∀ h t m, Decidable (couplingAlike W obs h t l m)`, which the row needs to build the law marking each class.
- **Logic** (rows 15 and 16): `x ≠ y` and `a ≠ b`.
- **Supplied parameters**, which are free at the model: `withhold`, `obs`, `eligible`, `better`, `dep`, `own`, `sig`, the class `C`, the data `D`, `select`, and the supplied law of exchange.

**The nine rows "premise of the account."** They are not U2's, and U1 §4 leaves them unchanged. Their content, by `NO_LAW`'s reasons:
- support with Price's identity or its counting form: `support_not_lower`, `support_moved_rises`, `selection_within`;
- support itself: `selected_le`, and `carried_iff_rising` as `NeedsSupportAt`;
- support with inheritance within a bound: `transmitted_supported`;
- only the active giving: the two GroupEnding rows;
- dissipation: `number_within_take`.

Support's grammar statement above is the one the six support rows would cite. Stating that premise in grammar terms does not state those rows at the model.

## 4. The rows that resist

Each keeps its category, and its reason now cites U1's verdict.

- **`responses_le_missBound`.** It bounds what a cut at order `j` loses by `Loops.missBound M D j t`, for every schedule of couplings. Its statement is an inequality between two amounts, each computed over the run:
  - the responses of the carried amounts, computed by the propagation;
  - the bound, computed from `M`, `D`, `j` and `t`.

  The couplings' schedule is relational, but it is not a term of the statement.
- **`Drift.falls_back`.** A second-moment bound on samplings, weighted by their binomial weights. Its terms are moments computed with products and binomial coefficients.
- **`RelativePosition.rise_needs_fall`.** Its terms are each part's rise and fall counts, `ps.length * b p + total ps a` and `ps.length * a p + total ps b`, computed over the family by sums weighted by the family's length. Its proof is the sum identity `change_balances` with the order lemmas `total_lt_of_mem` and `below_somewhere_or_not`. None of these is in U1's limited interface.

**What would change these.** Arithmetic on the second sort beyond U1's interface: sums weighted by a length, products and moments. Nothing in sight supplies it.

## 5. The row U3 holds

`unrestricted_iff_livingSignificance` is one of U3's five significance rows. U3's design, in `development/u3-significance-on-the-root/` and not yet on main, gives it a root form: `noOutside_iff_paths_livingSignificance`, the condition in its structural reading on a web's level paths. U2 restates nothing of it.

Two of U2's readings border U3's rows. `retains_iff` states retaining as an inclusion (`«则»`) at what the paths admit, met with a significance region; `adds_iff` states adding as exceeding (`«逾»`) there. U3's scratch keeps the native forms, and could use these. Whichever item lands first holds them, with nothing duplicated.

## 6. «保之像» beside «像»: an edit for HE's list

**The edit.** `«保之像»` moves from `Becoming.GrammarTransport` to `Becoming.GrammarLaws`, beside `«像»`, with its statement and name unchanged and no copy left behind. Mechanism's `factors_image` and `Image.least` are then proved as its cases, statements and names unchanged:
- the image lies within its own process's moves;
- a process the step factors through holds the image.

The scratch proves both from `«保之像»` where it now is ([U2Preserving](check/tree/Becoming/U2Preserving.lean)). Mechanism imports GrammarLaws and not GrammarTransport, which is why the lemma must move first. `factorsThrough_iff_image` (`Becoming.ProcessRepresentation`) is unchanged.

**Why HE and not U2.**
- No U2 reading uses `«像»` or `«保之像»`.
- The move changes GrammarLaws, which nearly every module imports, so it means a near-full rebuild. HE (main `981a93316`) is the one landing that rebuilds the package once, on purpose, for every edit held for a rebuild, and its row asks that such edits be added to its list.
- So this edit belongs on HE's list, as a sixth edit, not a second rebuild.

**Owners.**
- **GrammarLaws:** the move is in OU's plan (WHAT-REMAINS, "After WRP2", the second of the next items). It comes from GrammarLaws' owner's decision during WRP2, which reached this session by message and is recorded nowhere else. REVIEW-WRP2 had left it "proposed to the owner". The plan's text names only Mechanism's owner or rule 3's fallback as still needed.
- **The move's size:** GrammarLaws has 322 dependents of the package's 342 modules.
- **GrammarTransport:** its owner is WRT's designer, this session, which agrees to the removal.
- **Mechanism:** no owner is named. OU's owner approved the change to its proofs under rule 3's fallback.

**Decided.** OU's owner sent the edit to HE's owner (fork 1), and HE's row lists it as its sixth held edit (main `d9a6615e6`). If HE rebuilds before the edit is added, it becomes its own small item at a quiet point, rehearsed outside the repository.

## 7. Placement (decided) and the Lean item (not yet claimed)

**One core leaf.**
- Its module and namespace are `Becoming.ModelStatements`. Its relation names (`drawing`, `copies`, `member`, `keeping`, `supported_iff`, `kept_iff`) exist elsewhere only in other namespaces.
- It holds the scratch's declarations and imports only Becoming modules, so the pure core's rules apply.
- It is not named `Becoming.Grammar*`, since it is not the grammar layer and states no grammar law.
- It is a leaf because it states rows at their models, which is rule 9's "a model". OU's owner gives this reason on U2's row.
- No row module changes. `roles_renewingAt` and `roles_renewingOver` stay in the leaf, as OU's owner decided, since only its readings use them. Their natural home would be `Becoming.Regions`, which has 169 dependents, so they do not go on HE's list.

**Records, by RESULT-WORKFLOW.** A wrapper goes to the same record, so there is no new record.
- Each reading goes to its row's own record as a law "at the model", with the reading and its lemmas bound to the record's receipt. The row's statement and proof stay unchanged.
- These are other owners' records. OU's owner decided by rule 3's fallback; a record's owner who objects says so on U2's row before the landing.
- The pairs (row, reading) are data for MV's F5, in a field MV chooses. MV's owner is asked for that field when the Lean is claimed.

**Landing touch points, as WRP2's landing (`f28abafc6`) had them.**
- The root `Becoming.lean`: an import and a bullet.
- `check_becoming.py`: `CORE` and `SCOPE`.
- `README.md` and `README.zh.md`.
- `regions.json`.
- The rows' records and their proof bindings.
- MV's generator, rerun.
- A rehearsal outside the repository, then render and check in a clean worktree.

The checker compiles the leaf and the root.

**The measure.** U2 supplies the 20 pairs of §2, §4's reasons citing U1's verdict, and U3's row. MV's F5 reads them. The `NO_LAW` table is OU's owner's.

## 8. What this establishes, and what it does not

**Established, in scratch, at the scopes above.**
- 20 of the 24 rows are stated at a World's occurrence model, a process's model or the row's own carrier, every term of each statement under §0's criterion.
- Each reading is proved through its row.
- The account's premises they take are grammar statements at the model.
- Support and dependence are read in WRT2's relations, support with the partial identity of one occurrence added.

**Not established.**
- **No derivation.** No row is derived from a grammar law. A definitional row's reading is its definition written at the model, and a model law keeps the row's proof.
- **The names and the amounts.** The relations across a step read names, and are not shown to be carried by re-identification. Comparisons of needs with levels, and the order of outcomes, are relations of the model read from amounts, outside U1's interface. The need-within relation adds a supplied amount.
- **Three rows resist** (§4), and one is U3's.
- **The nine premise rows** keep U1's verdict.

**What would change this.**
- U1's interface gaining the comparison of a need with a level, as units paired into the standing units. The comparisons of §1 would then read in units.
- Arithmetic on the second sort, which would bear on §4's rows.

## 9. Owners

- **The design, the scratch and, once claimed, the leaf:** this session, WRT's and WRP's designer.
- **The rows' modules:** unchanged, so none is engaged.
- **The rows' records:** their owners. OU's owner decided by rule 3's fallback; an owner who objects says so on U2's row before the landing.
- **GrammarLaws, GrammarTransport and Mechanism:** only for §6's edit, as named there. Mechanism's change is approved by OU's owner under the fallback. HE's owner holds HE's list.
- **WHAT-REMAINS and the measure's `NO_LAW` table:** OU's owner.
- **F5's report:** MV.
