# A deeper review of the unification and the premises

AI-written review, 31 October 2026. Claimed on the board as DU. The request, made in conversation and not yet recorded under `sources/`, asked for five things to be resolved and unified:
- evolution's 18 central rows;
- significance's 5 rows;
- amounts and balance;
- the World's amounts;
- the two premises of the ethics.

It added that "unproven premises should not exist", and asked how the unification can be achieved and what should be rewritten or thrown away.

**Method.** There were five independent reviews: evolution, the continuation condition, C, amounts and the World, and the architecture as a whole. Each review was then given to a skeptic, who re-read the repository to refute it. Scratch Lean was Init-only and lives outside the package. The reviews, the attacks and the workflow script are in [raw/](raw/), and the scratch files are in [scratch/](scratch/). Main moved during the review, from `70fcebea2` to `d8e629828`, and U4 landed in between. The skeptics read the newer head.

**What survived.** The skeptics refuted most of the reviewers' constructive proposals, for three reasons:
- they duplicated landed or claimed work (RootForms, U4's kit, U1's scratch, EL's kit);
- they were near-definitional (Hume's principle, an `Iff.rfl`, C true by unfolding);
- they reversed an owner's argued decision without answering its reasons.

What survived is a diagnosis, a short list of exact fixes, and one direction worth research. This note keeps only what survived. The rest is in `raw/`, with the attacks.

## 1. The finding that governs the rest

The grammar's laws hold for every carrier, relation and class, so a law provable from the root alone forbids nothing. (The scratch `valid_forbids_nothing` shows this; it is a method lemma, not a result.) Every law with content can fail in some structure, so it can only be a theorem under hypotheses. This holds for balance, dissipation, support, selection under a gate, joint excess and the laws of evolution.

Those hypotheses are contingent, and the package already proves them independent: `World.independent` and `none_follows` give, for each of the World's eight premises, a world meeting the other seven and not it ([Premises.lean:765](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Premises.lean)). The ethics' two premises are free parameters (`sig`, `Better`), so they are independent of any root by construction.

So "derive every central row from the root with no premise" cannot be met by any theory that forbids anything. This is provable, not a lag. Every lever tried for it so far produced representations or logical forms, never derivations: U1, U2, U3, and U4's levers 1 and 2. The reason is structural, not a lack of effort. The repository half-says this already ([01 §0](../../../../../../theories/becoming/chapters/01-ROOT.md): "its general theorems hold of every carrier"; [08 §7](../../../../../../theories/becoming/chapters/08-METHOD.md#master-laws-and-connectivity): the reach count "is no criterion of completion"; "Ten are derived"). The front pages and the board still treat the low reach figures as gaps to be closed by more lifting.

## 2. What "no unproven premises" can honestly mean

A statement the work uses can have one of three standings:
1. **Proved.**
2. **A named hypothesis of proved conditionals,** proved independent with witnesses both ways and characterized exactly. This is not an unproven premise: the theory claims only the conditional, and proves that the hypothesis can neither be derived nor refuted from the rest.
3. **Asserted.** The theory asserts nothing of this kind ([08 §2](../../../../../../theories/becoming/chapters/08-METHOD.md), [07 §4](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order)).

Read this way, the demand can be met, and it is nearly met already. Four real gaps remain:

| Gap | What is missing | Cost |
|---|---|---|
| The root form of the condition, `«续无外»` | No stated met-and-failed pair at one class. 08 §7 says the root form "has none" (of a not-entailed theorem). Models both ways already exist: `descent_no_outside`, and `TwoLines.other_line_outside`, from which failing follows in one line (corrected by the leaf's review). | Two witnesses: it holds on a one-point net and fails on two unjoined points. Checked in scratch with an empty axiom report ([scratch/architecture-skeptic/Sk.lean](scratch/architecture-skeptic/Sk.lean)). Along an acyclic net it is already refuted for any center that something conditions (`«续无外则中心无缘»`). |
| C | No stated non-entailment from the dynamics, though the free condition has one (`ReadsOnlyDynamics.not_entails`, Significance.lean:276-300). | The same pattern with `Better := False` as the rival. It is immediate because `Better` is free, and it should be labelled so. |
| The other order premises | L (`LiftBetter`) and J1–J4 (`Lexical.BasicPriority` and the others) are on the premise card (08:233-237). L has no meets or fails witness at all (COVERAGE.json:766-770). | One witness each way for L, and a check of J1–J4. The demand applies to these as much as to C. |
| §4.6's "P2 and P4" | Two premises are named where one suffices: 07 §4.6 itself shows the path needs one thing, that the class of one's line holds the effects of oneself and of each stage of that line (`«后皆续当且仅当自与线皆闭»`). | Text only: name the one crux on the front pages and in the instructions' ethics paragraph. |

**What cannot be met.** No honest route makes "one ought to count everything" or "widening is better" a theorem of the root. There are only two ways to make either one a theorem:
- define "better" or "significance" so the premise holds by construction (with `Better :=` widening, C is `paths_comparison_widens`, an unfolding), which the rules forbid as hiding weight in a definition;
- assert it as an axiom, which gives up the zero-axiom aim.

Read literally for the ethics, the demand cannot be met, and the text should say so plainly rather than call the premises "discharged". The structural readings move the weight without removing it, as the skeptics showed in each case:
- the class of being joined makes P4 true by construction, and it is not canonical, since finer classes reach the same;
- the family reading of the condition is just joinedness of the net;
- the first-person locality law keeps a coverage hypothesis, which is the scope question again; the fished stock's seabirds lie downstream of the boats' own choice.

**One direction worth research.** In a mutually fed flow, C's premise reduces to self-concern's monotonicity, which is weaker than monotonicity at every standpoint:
- `Weighting.IncreasingInOwn`;
- `increasingInOwn_iff_increasing` (Weightings.lean:6100);
- `ended_below`, `Flow.coupled_ending_ranked_below` ("with no C", 07:326-328).

There, ordering needs no premise about everything. It needs only what a living center already acts on, its own continuation, and the region where one's own continuation covers everything is a fact about the net. An item that maps that region exactly would show where the ethics needs no premise beyond self-concern, and where it does. This is the strongest honest replacement for C that exists. It is the closest the work comes to "no unproven premise": outside that region the premise remains, with its boundary proved.

## 3. Gap by gap

### Evolution (18 rows)

**Verdict.** No row is derivable from the root without hypotheses, and provably so. The rows' content lies in the gate, dependence, transmission, balance and dissipation, each proved independent.

The quoted summary "none of its 18 rows reaches the root" is stale. The landed boundary record (`one-root-to-its-edge`) places every row:
- 1 under a stated hypothesis;
- 3 counting;
- 1 at a represented model;
- 6 with balance in its statement;
- 7 at amounts.

[04 §Bases](../../../../../../theories/becoming/chapters/04-LIFE.md) (line 7, "None is yet lifted") and its Open list (line 299) contradict that record.

**What survives:**
- Fix 04's text to cite the boundary record's standings, with the reason no row is derivable.
- One open decision for U4's owner. U4 labels a comparison over any map to Nat "counting" (DESIGN-BOUNDARY §1.4), yet places rows 7, 8, 13 and 14, which compare an arbitrary trait map, "at amounts". Both labels cannot stand.
- Merge `Flow.selection_within` into `selected_le` as a coverage cleanup (it is `price ∘ selected_le`), reporting both counts.
- The honest route for the conditional rows is OU7's form (formerly OU5), "Y iff Z, with a counterexample where Z fails", which is already claimed. Each hypothesis becomes an exact condition proved necessary.
- The link between selection and fate belongs to EL's owner. The review's version ("shares do not decide the region") is false: EL's kit proves that terms positive at unboundedly many steps force every generation to be nonempty, with no exact transmission needed.

**Do not:**
- anchor the gate as a sixth master law;
- redefine activity or support so the premises become definitional;
- drop Price, the levels partition or the drift bound from the central rows: they are evidence that classical laws were recovered, already placed as "counting";
- reprove EL's map-level ending (`degeneration_of_dissipation` on `el-kit`).

### The continuation condition (scope)

**Verdict.** Its forms have three different standings:
- **The free form** (`Unrestricted sig`) is the constant-true significance. It is proved independent of every statement that reads only the dynamics (SD1, `bounded_rival`). This is standing 2 already; the front pages only need to say so.
- **The root form** (`«续无外»`) is a descriptive statement about a net, its class and its centers:
  - refuted along forward conditioning for any conditioned center;
  - joinedness in families at the one;
  - a correspondence along feeding.

  Its contingency theorem is the missing piece (§2).
- **The de se path** needs one crux, the class question, with the organism and intention classes as coherent rival readings, each with its witness. The skeptic rejected the claim that the class of being joined is canonical: finer classes reach the same (07:350, `ThirdAffects.finer_class_reaches`).

**What survives:**
- the contingency witnesses;
- the status table with exact types, written into the record `the-continuation-condition-on-the-root` as uncounted lemmas;
- naming one crux.

**Do not:**
- retire `Unrestricted` (that removes the ethics, not the premise);
- move 07 §4.2's argument across drawings to history (it is the live argument behind the open de se question);
- rewrite U3's rows (they are correctly scoped representations: the hypothesis can hold along cyclic relations such as `Clearing.system_whole`).

### C (order)

**Verdict.** C is not an unproven claim about the unfolding. It is an unfilled meaning, because `Better` is a free parameter (Extension.lean:57) and the root has no "better". Every definition of "better" from the root alone either makes C true by unfolding or relocates it as monotonicity at each standpoint, which 07:312 already says. Mixed cases stay unranked, and any ranking of them is proved independent of counting everything (`mixed_either_way`).

**What survives:**
- Drop `Web.paths_comparison_widens` from the significance row's central declarations (COVERAGE.json:556-562), since it is an unfolding. Keep it as C's consistency witness, labelled trivial.
- Exclude the laws 3 and 10 of `comparison-by-widening` from any reach tally.
- Narrow the docstrings: the amount-free class theorem over all increasing orders is near-definitional; its content is the lower bound over positive weightings and the split of mixed cases.
- One premise-free law of `«广»`, small but real: on a finite listing (with `DecidableEq`, a stated modelling assumption), widening is generated by one-item widenings.
- The non-entailment and L's witnesses (§2).
- The self-concern direction (§2).

**Do not:**
- remove the name C;
- define "better" as unanimity (that is widening again);
- merge C into a valenced condition (stronger, with no less open a warrant, and in tension with relational significance by the `Interacting` witness).

### Amounts and the World

**Verdict.** Balance cannot be derived from the grammar; the root has models where it fails (Tandem's splits and merges, `idleTwice`). Balance is also not a premise of the account. It is a row hypothesis with three supports:
- proved independent (`World.contingent`, `World.independent`, `idleTwice_unbalanced`);
- enclosed hypothesis-free forms with the rest counted as an added relatum (`World.withRest_*`, `ReadOffExchange.*`);
- a physical derivation in the periphery (`balance_and_least_loss`).

Making amounts "counts of listed occurrences" re-expresses balance as a bijection of supplied units, the easy direction of Hume's principle. U4's lever 1 (`balances_at_iff_census`) and U1 already built that, and it adds no law.

**What survives:**
- A wording fix. One-to-one continuation is balance at the unit grain, not atomism (integrality). The sentence in U4 DESIGN.md:56-57 and WHAT-REMAINS.md:313 conflates the two; add a new dated section rather than editing the cited one.
- An optional audit of which balance consumers use only one half ("no production" against "no destruction"), recorded as a strengthening, not as reach.
- U1b is the law set of the balance hypothesis. Holding it back would contradict every honest reframing; keep it with its owner.

**What would be needed for more.** A root in which unit occurrences and their residence are fixed by relations independent of the counts, with a law proved about World data that the counts do not give. No candidate exists in the repository or in the reviews. It stays open, stated as such.

### Architecture

**Verdict.** The reviewer's diagnosis holds: the reach count tracks where content lives, not a defect. Its proposals were mostly already the repository's stated position, or invented a parallel hub. The World, with its eight-premise catalogue and `counting_under`, already is the hub that the processes, the web and the flow reach by construction.

**What survives:**
- **Lead every headline with what is derived** ("Ten are derived", 08:438). Then give the hypothesis set of each central law. Give the reach count third, as the dependence measure it is.
- **Build one generated law × premise matrix on the existing catalogue,** with the needed-witness method RootForms already uses. Use one non-triviality test: the proof uses a grammar law with inductive content (closure induction, `«对»`, `«核»`, return).
- **Write a current one-page head for WHAT-REMAINS.** Keep the dated sections; records cite them.
- **Correct the count.** `master-laws.json` gives 44 declarations reaching the grammar, while ONE-PAGE and 08 §7 say 45.

**Do not:**
- fold records (distinct claims stay separate);
- move live measure scripts (`master_laws.py` hashes them as inputs);
- move U1's scratch (the evidence ledger of a live verdict).

## 4. What to throw away, and what to keep

Very little should be deleted. Each discard the reviewers proposed would have lost a result, a counterexample, a failed candidate or a cited section, and the skeptics caught every one. What should stop is a kind of work:
- **Stop opening items whose aim is to raise the reach count.** A row reaches the root with content only through a conditional on a grammar-stated hypothesis, with that hypothesis's witnesses. A row that already has that standing gains nothing from rerouting.
- **Stop calling the ethics' premises "unproven" on the front pages.** Say what each one is:
  - the free condition is proved independent;
  - the root condition is contingent on the net, once its witnesses land;
  - C constrains a free order, independent by construction;
  - the class question is the one open crux, a philosophical question with coherent rivals.

## 5. Proposed order of work

1. **Text corrections, no Lean.**
   - 04's Bases and Open.
   - The headline order in 08 §7 and ONE-PAGE: derived, then hypothesis sets, then reach.
   - 44 against 45.
   - One crux in place of "P2 and P4".
   - The atomism sentence.
   - `paths_comparison_widens` out of the significance row.
   - The instructions' ethics paragraph changes only with approval.
2. **One small Lean item.** It covers:
   - the contingency of `«续无外»` and `«族无外»`;
   - C's non-entailment, labelled immediate;
   - witnesses for L, and a check of J1–J4;
   - the law of `«广»` on a finite listing.
3. **The law × premise matrix,** generated from the catalogue that exists.
4. **Hand-offs on the board:**
   - EL's owner: the boundary between selection and fate;
   - OU7: "Y iff Z with a counterexample" for evolution's conditional rows;
   - U4's owner: counting or amounts for rows 7, 8, 13 and 14;
   - U1b's owner: the balance hypothesis's law set.
5. **Research:** the region of the net where one's own continuation covers everything, where C reduces to self-concern (§2).
6. **Open:** a root that fixes units independently of the counts (§3, amounts). There is no candidate yet.

## Checks made for this note

Read in the package:
- `Premises.lean:765-776` (`independent`, `none_follows`);
- `Significance.lean:195` (`bounded_rival`);
- `GrammarScope.lean:40-41, 215` (the boundaries of `«续无外»`);
- `master-laws.json` (central reach 44 / 16 / 7 / 51).

Scratch files compiled with Lean, Init only:
- [Sk.lean](scratch/architecture-skeptic/Sk.lean): `noOutside_holds`, `noOutside_fails`, `unanimity_is_ext`, all with empty axiom reports;
- [EvoSketch.lean](scratch/evolution/EvoSketch.lean): three lemmas with empty reports, of which `shares_do_not_decide` is vacuous as stated, as its skeptic showed;
- [NotTrans.lean](scratch/order-C-skeptic/NotTrans.lean): an increasing order that is not transitive (uses classical axioms; scratch only).

The other citations in this note are the skeptics'. They checked the reviewers' line numbers and corrected the wrong ones; this note was not re-verified line by line beyond the checks above.

## The leaf in scratch (31 October 2026)

[`Becoming.PremiseWitnesses`](tree/Becoming/PremiseWitnesses.lean), revised after one independent review ([findings and dispositions](REVIEW-LEAF.md)). It is built with `scratch_build.py` ([log](scratch-build.log)): 9 theorems in 11 declarations, every axiom report empty. It imports `Becoming.GrammarCases` and `Becoming.Lifting`, and nothing imports it.
- **The condition on the root varies with the net.** At the one, the endless line of descent meets `«续无外»` and two unjoined family lines fail it (`«续无外随网»`). In families, the same line meets `«族无外»` and a third thing apart fails it (`«族无外随网»`). Both pairs are built from models the package already has.
- **No statement reading no order, and holding at a datum with an extension, entails C** (`ReadsNoOrder.not_entails`). This is immediate, and labelled so.
- **L is met and failed on `LiftModel`'s frame** (`LiftModel.met_and_failed`).
- **Widening on a listing is generated by widening by one item** (`Weighting.widensOn_iff_reach`). So being increasing in admission is asked item by item of a transitive order (`Weighting.increasing_iff_by_one`). These two move into `Becoming.Weightings` at that module's next change.

J1–J4: J1 and J2 (`Lexical.BasicPriority`) admit a meaningful failing witness, a positive weighting that trades a basic loss for gains. J3 and J4 (`Requirement.Frontier`, `Required`) are definitions; the premise is the rule of choosing on them, whose witness is a rival rule. `Required.defeated` and `Required.impossible` already show the definitions are not constant. The premise card should say this rather than ask J3 and J4 for met-and-failed pairs (a proposal for the card's owner).

Order, per the coordinator (31 October 2026): the leaf goes in the core round by readiness, after UE26 and BD2, beside EL and UE27, and before OU7. The rehearsal on main starts on the coordinator's word. Each text change needs the word of its file's owner before the slot.

Text routing, per the coordinator (31 October 2026):
- **OU's owner** (the integrator of the unification line) is asked for 08 §7's two figures (a live inconsistency, fixed with DU), COVERAGE's significance row and premise witnesses, the new WHAT-REMAINS section, and 04's standings.
- **The one crux for §4.6** is kept apart from DU's other texts. Replacing "P2 and P4" with one crux changes the ethics' summary: it is a change of standing, not a wording fix. It must first be argued in a record and a review, then carried to every text naming P2 and P4. For the instructions file it goes to Ren only as a proposal. The leaf and the other fixes do not wait on it.

OU's owner's word (31 October 2026, read on main `3942f6177`):
- **(a) 08 §7.** Agreed. The two figures may count different things: 45 of the 127 rows, where a declaration standing in two rows counts twice, against 44 of the 118 distinct declarations (`master-laws.json` central reach 44 / 16 / 7 / 51). Check 45 against `measure_grammar.py`'s per-row count. If it is that count, label both figures; if not, correct it to the data. Either way, read the figure from the generated data rather than copying it. The lead may be reordered (what is derived, the boundary record's 10 / 1 / 6 / 101, then each law's hypotheses, then reach as the dependence measure) so long as nothing in the paragraph is lost. The draft goes in this kit, and OU's owner reads the diff before the slot.
- **(b) COVERAGE.** Agreed. Dropping `Web.paths_comparison_widens` from the significance row changes F5's figure, so the landing reruns `master_laws.py`, gives the reason in COVERAGE and reports the new figures; OU's owner puts them in WHAT-REMAINS and 08 §7 in the same landing. Agreed too: `LiftWitness.contingent` for L, and `Comparison.contingent` and `ReadsNoOrder.not_entails` beside C's witnesses.
- **(c) WHAT-REMAINS.** Agreed, consistent with U1b's landed record `amounts-by-unit-matchings`. U4's DESIGN.md:56–57 and WHAT-REMAINS:313 stay as they are. A new section, "The unit grain is balance, not atomism (DU, date)", is drafted in this kit; OU's owner applies it at the landing.
- **(d) 04.** Agreed, with the standings read from the boundary record (1 / 3 / 1 / 6 / 7) and checked at landing. One correction to the reason: `World.independent` proves the World's eight premises independent of one another, and says nothing about 04's laws as such. The text must say that 04's laws rest on World premises (named per row where the record names them), that those premises are independent (`World.independent`, `World.none_follows`), and so that no 04 law follows from the root's laws without them. "Contingent at the grammar" is said only where a leaf or record gives a model of the grammar in which the law fails. Only §Bases and Open change, never a statement.
- **§4.6.** No item holds it now (PF and PF2 landed; OC1 took up the open item). The crux proposal keeps its own board row, record and review. Any change must keep the statement that the condition fixes scope and C fixes order.
