# UE7 review: what keeps widening, and what it needs (26 October 2026)

This is an AI-authored independent review of board item UE7 as committed at `71ec77fa0`. It covers four files:

- [DESIGN.md](DESIGN.md), sha256 `e97f11aa…1b00dff4`;
- [NOTE.md](NOTE.md), sha256 `9f40ee33…893e887a`;
- [tree/Becoming/SustainedWidening.lean](history/SustainedWidening.lean), sha256 `0b03db44…f52b451f`;
- [scratch.log](scratch.log).

They were read with [AGENTS](../../../../../../AGENTS.md); rules 8 and 9 of the [work board](../../../../../BECOMING-WORKBOARD.md); [RESULT-WORKFLOW](../../../../../RESULT-WORKFLOW.md); §1 of the [UE plan](../ue-unified-explanation/PLAN.md#1-the-objective) and the [UE0 audit](../ue0-third-parts/AUDIT.md); 02 §1 and [02's Open list](../../../../../../theories/becoming/chapters/02-MAP.md#open); [07 §2](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-eventual-widening) and [07's Open list](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#open); the [glossary](../../../../../../GLOSSARY.md); the [eventual-widening record](../../../../../../theories/becoming/results/records/eventual-widening.md) (UE4); and the package modules `EventualWidening`, `EventualWideningInstances`, `ContinuedClasses` (`Linked`), `Flow`, `Gain`, `Novelty`, `Population`, `Admission`, `Dissipation`, `Recurrence`, `Thresholds`, `Prelude`, `PatternPassing`, `Grammar`, `GrammarMap` and `MapInstances`.

**How it was checked.**

- **Rebuild.** `python3 -B scratch_build.py <kit>/tree` keys its steps by source bytes, so it reuses the module's step from the cache instead of recompiling it. A byte-identical copy (same sha256) was therefore also compiled fresh with Lean 4.29.1 in the session scratchpad (`ue7tree/`, volatile), with no warning or error. An environment audit (`collectAxioms` over every constant the module adds, auxiliary ones included) found 264 constants, 118 of them theorems, none depending on any axiom. The source has 118 theorems and 26 definitions, 144 declarations, as the NOTE says.
- **Probes.** Two scratch modules import the kit; both are given in full in the appendices ([A](#appendix-a-the-exclusion-law-and-the-restated-witnesses), sha256 `efedbd76…04f25eba`; [B](#appendix-b-the-late-single-giver), sha256 `9db4b442…4c8da291`). `#print axioms` reports every theorem in them free of axioms; this was rerun for this review.
- **Sources.** The following were checked on web pages, and nothing was installed: Jones (1995); the TAP paper (arXiv 2204.14115v4); assembly theory (Sharma and others 2023, read on PubMed Central); the standard form of the Jones model; Pirt (1965)'s bibliographic record; work on RAF dynamics. One fetch (lecture slides on web2.econ.ku.dk) saved a PDF automatically outside the repository, at `/Users/ren/.claude/projects/-Users-ren-theories/7e73c253-c642-4ddd-ad8f-cc6d011978ec/tool-results/webfetch-1792950046644-l8f9wh.pdf`. It was not opened, and nothing here depends on it.
- No repository file other than this review was created or changed. Nothing was committed.

## Verdict

The Lean is sound and the core stays pure:
- every statement the NOTE quotes is the module's;
- a witness meets each set of hypotheses together, and a witness shows each dropped premise needed;
- nothing gets past the axiom report.

The four laws are what the NOTE grades them, restatements or near-definitional, and "none is a result no neighbouring field states" is right. Three claims go further than the Lean:

- **The map law and 02's open item (O1).** The law is said to answer 02's open item. It answers a narrower question, about the strong forms and the nothing-lost half of keeping widening. On each reading the kit uses, 全生成 and keeping widening cannot hold together; a probe proves this along passing of support under the World premises.
- **The provisional definition (O3).** It is said to be too strict, but the two forms are independent. A probe gives a late single giver that the old form counts and the new form does not, and that giver is the stronger reason for the replacement.
- **Third parts (O2).** Third parts are named against TAP, assembly theory and Jones 1995 although no containment is built. Variants or neighbours of those frameworks already forbid the course.

Further:
- one prose claim is false: the lagged relay's first two gains (E1);
- one landing proposal does not build as stated (E2);
- two "rule 9" derivations sit beside the landed laws until the proposed moves are made (O4).

The replacement does not endanger `Saturated.reverses`, which is restated in five lines ([appendix A](#appendix-a-the-exclusion-law-and-the-restated-witnesses)).

**Land after named fixes:** E1, E2, O1–O4 and I1–I4 are required; the rest are recommended.

**Counts:** 2 errors, 4 overclaims, 8 imprecisions, 10 suggestions.

## Findings

Each finding gives its location, what is wrong, and a fix. The wording of a fix may be taken as written or in words that say the same. Line numbers are those of the committed files.

### Errors

**E1. Formation 0, which never gained support, gives the lagged relay's first two gains.**
- *Location.*
  - NOTE §2.3, Witnesses, fourth bullet (line 119).
  - DESIGN §4, "Relations proved" (line 105).
  - The docstrings of `OpeningChain.laggedRelay` (kit lines 1264–1265) and `OpeningChain.laggedRelay_within` (lines 1281–1282).
- *What is wrong.* The text says that formation `t` gives at step `t + 1`, "so every gain is given by the formation that gained support two steps before". But `lagging 0 = [0]` and `lagging 1 = [0]`. Formation 0 is supported from step 0 and never gains support, and it gives the gains at steps 0 and 1 (formations 1 and 2). The claim holds only from step 2 on. `laggedRelay_within` is still true, because within two constrains only gains across steps `S + 2 ≥ 2` (I3).
- *Fix.* Write: "From step 2 on, each gain is given by the formation that gained support two steps before. The gains at steps 0 and 1 are given by formation 0, which never gained support, and within two leaves gains before step 2 unconstrained." In the `laggedRelay` docstring, write "for `t ≥ 1`, two steps after it gained support".

**E2. The decided form cannot land in Admission as proposed.**
- *Location.* NOTE §7, Rule 9 moves, second bullet (line 214): "with its global and decided forms, would land in Admission".
- *What is wrong.* `gain_given_by_recent_gainer_decided` uses `upto_or_fails` (Novelty.lean:62). Novelty is not in Admission's import closure; Population is. Admission would not build as proposed.
- *Fix.* Land the local and global forms in Admission. Then do one of two things:
  - move `upto_or_fails` down to `Recurrence`, beside `le_succ_cases`, the only package lemma it uses (Recurrence lies below both Admission and Novelty);
  - or land the decided form above Novelty and say so.

### Overclaims

**O1. The map law does not answer 02's open item. It answers a narrower question, and on each reading it uses, 全生成 and keeping widening cannot hold together.**

*Location.*
- NOTE §4 item 4 (lines 182–185), §5's closing paragraph ("a precise answer to 02's open item", line 199), and §8's last bullet (line 230, "independent both ways").
- DESIGN: the verdict paragraph ("a law for 02's open item, relating the map's generation to widening", line 5), law table row 4 (line 12), and the map law's grade (line 130).
- The board row and the commit message of `71ec77fa0`.

*What 02 asks.* "Whether a capture loop (§9) is 生成 at some pair of classes, and a law relating the map's 生成 to widening what can form" ([02 Open](../../../../../../theories/becoming/chapters/02-MAP.md#open)).
- 生成 is the some-branch region (02 §1, Definition). On the World only the strong forms are instanced; 02 §1 says "the some-branch regions are not read on the World", and reading them there is itself 02's first Open item.
- "Widening what can form" is 07 §2's widening, a comparison of two level paths. The glossary gives it as "at every step admitting every formation the other admits, and at some step one more".
- The board row had already reframed the item as "relating 生成 to gains of support"; DESIGN line 113 quotes 02 correctly and then reaches it "through gains of support".

*What the law relates.* It relates the strong forms 全生成 and 全守 to nothing lost (`IncludesAcrossFrom`), the first half of keeping widening, a property of one course.
- It does not reach 生成: the package has no lemma 全生成 → 生成, and the kit states none.
- It does not reach the widening order: no map-law statement mentions `Web.Widens`, `KeepsOpening` or `ExceedsAcross`, and `KeepsWidening.kept_by_name` uses only `keeps.1`.

*On each reading the kit uses, the two cannot hold together.*
- **By name.** Nothing is ever 全生成 (`Web.itself_not_generation`, landed).
- **Along "carry on, or open".** Assume the four World premises of law 3's global form: balance, only active formations giving, activity needing support, requirements never loosening. Then nothing keeps opening, from any step.
  - Whatever is supported at `S + k` descends, up to double negation, along passings of support from something supported at `S` ([appendix A](#appendix-a-the-exclusion-law-and-the-restated-witnesses): `Flow.descends_along_openings`, `Flow.not_keepsOpening_along_openings`, axiom-free). It is close in spirit to the landed `Web.ByPassing.trace`; here the World premises supply the passing, up to double negation, through `gain_carried`.
  - `ClosedCycle.not_opening_along` is an instance of it (`ClosedCycle.not_opening_along'`).
  - By `Linked.mono`, the same holds along every continuation that contains "carry on, or open".

So "generation and widening are independent both ways (the cycle; the rising course)" holds only by comparing two readings: the cycle is 全生成 along passing, and the rising course keeps widening by name. On either reading alone they cannot hold together; on the second this rests on the World premises.

**[AI reading]** Under the World premises nothing is new along lineage: this is the theory's form of "every cell from a cell". A course keeps widening by name only because names leave lineage out. That is a lead for what the second-order direction should count as novel.

*What it answers.*
- (a) Along a continuation from `T`, nothing lost is exactly this: from every occurrence admitted from `T` on, the admitted pattern's line never ends (不穷). This is `includesAcrossFrom_iff_endless`, an exact equivalence.
- (b) By name, nothing lost gives 全守.
- (c) Along "carry on, or open", a carrying renewal from a supported occurrence is exactly a passing of support, and every gain is one, up to double negation (`opening_carries_iff`, `gain_carried`).
- (d) Brief supports make every supported endless line 全生成, without the World premises (`generates_of_brief`).

*What it leaves.*
- 生成 itself, on the World.
- Any law involving the opening half of keeping widening, or the widening order.
- The capture loop.
- A reading on which 全生成 and keeping widening hold together. Under the World premises such a reading would have to leave out some step of "carry on, or open", as the merge continuation of `MergedWitness` leaves out carrying on as itself; none is constructed.

*Fix.*
- Write "answers part of 02's open item", followed by (a)–(d).
- Keep 02's item open and narrow it, for example: "a law relating 生成 (some branch, read on the World) to widening what can form. On the two readings so far, names and passing of support under the World premises, 全生成 and keeping widening cannot hold together."
- Replace "independent both ways" accordingly.
- Add the exclusion law to the kit (S8), or cite it as the reason.

**O2. Third parts are named against TAP, assembly theory and Jones 1995, though no containment is built and the frameworks' own families forbid the course.**

*Location.*
- NOTE §3: the TAP, assembly theory and Jones 1995 rows (lines 169, 170 and 172); §5, third bullet.
- DESIGN: the verdict paragraph, law table row 2, §2 (the adjacent possible, line 52), §3 (Jones, line 78), §6's table (line 143) and §7 (line 151).
- The commit message.

*What is wrong.* Under the UE plan §1, a third part is one of three parts of a containment:
1. the framework's premises on the premise card;
2. an instance or equivalence theorem in Lean;
3. something the theory forbids that the framework leaves open.

None of the three frameworks has a card entry or a Lean instance here; each correspondence is a prose mapping. UE0 did count premise-carried third parts for rows whose laws the theory already holds, so the usage has a precedent. But UE0 also graded "the sources' own exclusion, under a stronger premise" as **no** (its row 11), and the same applies here:
- **TAP.** The TAP paper itself discusses a logistic variant that limits innovation (its §5.3). "No resource term" is true of its Eq. 1 only.
- **Jones 1995.** The model with depreciation forbids the course; DESIGN §3 says so (line 75). So does break-even investment (Solow 1956).
- **Assembly theory.** The paper has no balance term, but it notes mass constraints on what is produced, qualitatively.

*Fix.* Grade the three rows "restatement: the framework as stated omits conservation or upkeep, which its own variants or neighbours supply". Keep "third part" only alongside a Lean instance and a premise card, or mark it "in UE0's weak sense, not a containment".

**O3. The replacement is argued as relaxing a form that is too strict, but the two forms are independent.**

*Location.*
- NOTE §2.3, Witnesses ("The fixed origin is too strict", line 119); §5 ("showing that the provisional form is too strict", line 196); §7, Definition replacement (lines 218–223).
- DESIGN lines 105 and 163.
- The commit message ("shows UE4's provisional OpenedByOpened too strict").

*What is wrong.* `openedByOpenedWithin_of_opened` needs the old form at every origin. The landed uses read it at one origin (`relay_opened`, `ClosedCycle.opened` and `Saturated.reverses` at origin 0) or at none ("from no step"). At a single origin the old form does not give the new one:
- **The late giver** ([appendix B](#appendix-b-the-late-single-giver), `OpeningChain.forms_independent`). On `OpeningChain.web`, take formation 0 at step 0 and formation 1 at every later step, each giving the opening unit. This flow balances, and only active formations give. It is opened by the opened at origin 0, since formation 1 gained support across step 0, and within no bound.
- **The lagged relay** goes the other way: within two, and at no origin. So neither form implies the other.

**[AI reading]** The late giver is the stronger case for the replacement. The old form counts one lasting carrier as opened by the opened whenever that carrier began after the origin. This defeats the purpose 07 §2 gives the property (the relay opened by the opened, the single giver not). The new form excludes it at every bound.

*Fix.*
- Add the late giver ([appendix B](#appendix-b-the-late-single-giver)) beside `within_not_fixed_origin`.
- Describe the replacement as a change of class: it drops a giver that gained support once after the origin and carries every later gain, and it admits givers that gained support within `K` steps, whatever the origin.
- Drop "too strict", or write "the two forms are independent".

**O4. Two derivations labelled rule 9 sit beside the landed laws as placed.**
- *Location.*
  - Kit `Web.exceeds_of_firsts_of_distinct_configs` (line 196) has the statement of `Web.exceeds_of_firsts` (Gain.lean:138).
  - Kit `Flow.support_passes_on_of_recent` (line 437) has the statement of `Flow.support_passes_on` (Admission.lean:227).
  - NOTE §2.1, Steps, and §2.3, Variants, label both "(rule 9)".
- *What is wrong.* In a leaf module these are second proofs of landed statements, which rule 9 forbids. They become rule 9 only when the general laws move below and the landed laws are re-proved from them in place.
- *Fix.* At landing, carry out NOTE §7's moves, with E2's correction:
  - put `exceeds_of_distinct_configs` in Novelty, and re-prove `exceeds_of_firsts` from it (and `exceeds_of_new`, or record that it stays beside);
  - put the local and global uniform law in Admission, and re-prove `support_passes_on` from it;
  - delete the kit's two derivations.

  Until then, call them "derivations showing that the moves work".

### Imprecisions

**I1. "Nothing is ever opened along its continuation."**
- *Location.* NOTE §2.4, Witnesses, first bullet (line 156); the docstrings of `ClosedCycle.not_opening_along` (kit line 1122, "Along 'carry on, or open' nothing is opened") and `ClosedCycle.generation_without_widening` (lines 1133–1135).
- *What is wrong.* The theorems state that the cycle keeps opening from no step, and every step of that continuation is a `Flow.Opens`.
  - Read in the core's sense, the sentence says more than the statement: the proof shows no `ExceedsAcross S U` for any `S ≤ U`, but the theorem does not state that.
  - Read in the sense of `Opens`, it is false.
- *Fix.* Write "keeps opening from no step", or state and prove the stronger form; see also I2.

**I2. Rule 8: `Flow.Opens` names a passing of support with the core's word for novelty.**
- *Location.* Kit line 627.
- *What is wrong.* In the core, "opened" means admitted and continuing nothing admitted (`KeepsOpening`, `ExceedsAcross`; 07 §2, "something keeps being opened"). `Flow.Opens L W t g f` says that `g`, supported, passes support to `f`. The cycle shows that the two senses come apart.
- *Fix.* Rename to `Flow.PassesSupport`, read as "carry on, or pass support" in prose. Rename `opening_carries_iff` and `opens_or_carried_on` to `passesSupport_carries_iff` and `passes_or_carried_on`. This joins the landed passing vocabulary: `passingContinuation`, `ByPassing`, `support_passes_on`.

**I3. The new definition's exemption and its empty case are not stated.**
- *Location.* The docstring of `Flow.OpenedByOpenedWithin` (kit lines 461–466); NOTE §2.3, "Definition and its laws".
- *What is wrong.*
  - `OpenedByOpenedWithin L W K` constrains only gains across steps from `K` on, so gains before step `K` are exempt.
  - With `K = 0` it holds of no flow ([appendix A](#appendix-a-the-exclusion-law-and-the-restated-witnesses), `Flow.not_within_zero`).
  - Every form must exempt founders: formation 0 of the relay and of the lagged relay never gained support. The old form exempts gains up to its origin; the new one exempts gains before step `K`, so the bound does two jobs.
- *Fix.* State both in the docstring and in the record: "gains before step `K` are not constrained; within 0 holds of no flow". See also S6.

**I4. Renewers and takers count entries of the present list, with repetition.**
- *Location.* NOTE §2.2; §3, the Jones row ("researchers ↔ renewers"); law 2's prose, "renewers multiply".
- *What is wrong.* `Flow.count` totals `sign` over `present t`, so one formation listed `m` times counts `m` times, and `Capacity` bounds each entry. Law 2 says that the entries giving to the family are bounded from no step on. It says the same of formations only where `present t` has no repetition.
- *Fix.* Say so in the NOTE and in the record, or add `Distinct (L.present t)` as a hypothesis for the formations reading.

**I5. RAF dynamics exist.**
- *Location.* DESIGN §2, Autocatalytic sets (line 54: "RAF theory states existence, not growth laws (the searches found none on growth)"), and §6's table (line 142); the NOTE §3 row ("the law asks it for growth, not only persistence").
- *What is wrong.* The dynamics of RAF sets and of autocatalytic cores, including their growth and division in compartments, are studied. Examples are W. Hordijk and M. Steel, "Autocatalytic sets extended: dynamics, inhibition, and a generalization", *Journal of Systems Chemistry* 3 (2012) 5; and V. Vasas and others, "Evolution before genes", *Biology Direct* 7 (2012) 1. The restatement grade stands, more firmly.
- *Fix.* Drop "found none on growth" and the contrast between growth and persistence, and cite both papers.

**I6. The Jones row maps renewers to researchers.**
- *Location.* NOTE §3, the Jones row; DESIGN §3 (lines 75–78).
- *What is wrong.* Law 2's renewers give what kept formations take. They are the counterpart of the input that offsets depreciation, not of research producing ideas.
  - The closest economic neighbour is break-even investment (R. M. Solow 1956, *Quarterly Journal of Economics* 70): keeping capital per worker takes investment in proportion to it.
  - In microbiology the neighbour is Pirt's maintenance coefficient, which the NOTE already cites.
- *Fix.* Map "upkeep ↔ depreciation or maintenance; renewers ↔ the input that offsets it", and add Solow 1956. Keep Jones 1995 as the model that leaves the course open without depreciation.

**I7. "Widening by name and generation are disjoint."**
- *Location.* The docstring of `KeepsWidening.kept_by_name` (kit lines 609–611) and the module docstring (line 58).
- *What is wrong.* By name, nothing at all is 全生成 (`itself_not_generation`), so the disjointness says nothing about widening. The corollary adds 全守 and uses only nothing lost.
- *Fix.* Write "by name, nothing lost gives 全守, and nothing is 全生成 by name". Consider keeping only `kept_of_includes_by_name`.

**I8. The map law reads the class as support, not activity.**
- *Location.* NOTE §2.4; DESIGN §5.
- *What is wrong.* Law 4 is stated on `W.admitting l`, whose activity is admission by `l`; on the actual levels that is support. The World theorems of 02 §1 read the web's own activity, and under `Dependent` activity implies support, not the converse.
- *Fix.* Say in the record that the generation in law 4 is that of the admitted (supported) pattern.

### Suggestions

**S1. One first step, below (rule 9).** `Flow.gain_carried` (kit line 648) and `Flow.gain_given_by_recent_gainer_at` (line 374) each repeat the body of the landed `Flow.gains_from_supported_at` (Admission.lean:184), with `W.Rises t c` added. Instead:
- state once, in Admission, that a gain of support is, up to double negation, given on a rising required condition by a supported formation taking part;
- derive `gains_from_supported_at` from it, statement unchanged;
- derive both kit laws from it.

**S2. One unboundedness law.** Three laws conclude from arbitrarily long lists of late steps with pairwise distinct configurations: `passes_every_bound` (kit), `unbounded_of_new` (Novelty.lean:125) and `rises_late_of_firsts` (Gain.lean:150). One law beside `exceeds_of_distinct_configs` would serve all three: such lists from every step exceed every bound at arbitrarily late steps.

**S3. Restatements.** `le_of_double_negation` (kit line 120) restates `Thresholds.le_of_not_not` (Thresholds.lean:389), which lies outside the kit's imports. NOTE §7 lists the three `upto_*` restatements but not this one. Keep one statement of each, in Prelude.

**S4. Counting.** `length_le_count` generalizes `length_le_of_sub` (Population.lean:152), taking `q := fun _ => 1`. Land it so that one is a corollary of the other, or both of `length_le_of_matched`, not as an independent proof beside it.

**S5. The leaf.** Rule 9 asks a new module's row to say why it is a leaf. DESIGN §8 gives the reason: it joins EventualWidening with Gain, Flow and MapInstances. The board row and the package README row should say so at landing.

**S6. A two-parameter form.** Define `OpenedByOpenedWithinFrom L W T K`: gains across steps from `T + K` on are given by gainers within the `K` steps before.
- It separates "from when" from "how recent".
- It parallels `KeepsWidening _ _ T`.
- It makes the founders' exemption explicit.
- With `T = 0` it is the kit's form.

**S7. Records and homes.** All four laws are joins, graded restatement or near-definitional.
- One record for the item, homed in 07 §2 after r-eventual-widening, can hold laws 1, 2 and 4 with their witnesses.
- Law 3's general form should extend the support-passed-on record (02) rather than start a new one, since the landed law becomes its corollary.
- The replacement revises law 7 of the eventual-widening record. Keep the provisional form there as a superseded candidate, with the lagged relay and the late giver as the reasons; RESULT-WORKFLOW keeps failed candidates.

**S8. Add the exclusion law.** [Appendix A](#appendix-a-the-exclusion-law-and-the-restated-witnesses)'s `Flow.not_keepsOpening_along_openings` belongs in the kit, or its stronger form, no `ExceedsAcross S U` for `S ≤ U`.
- It is a law relating the map's reading to widening that the theory can state today.
- It answers part of NOTE §6's "keeping widening along a continuation other than names": along passing of support, under the World premises, never.
- Its standing is near-definitional (biogenesis).
- No append lemma for `Web.Linked` is landed, so `Linked.snoc'` would land as `Web.Linked.snoc` in ContinuedClasses.

**S9. From 全生成 to 生成.** If the record is to say anything of 生成, prove on the grammar that 全生成 gives 生成; the points a line reaches look like a branch. This was not checked here.

**S10. The module's name.** The property is `KeepsWidening` and the item is "what keeps widening"; "sustained" is not glossary vocabulary. `Becoming.KeepingWidening` would name the module in the adopted words, as rule 8 asks at claim time.

## The seven checks

1. **Build.** Confirmed: 118 theorems in 144 declarations, every axiom report empty. The scratch build reuses its cache, so a fresh compile and an audit of all 264 constants were added; no constant depends on an axiom.
2. **Lean against the NOTE.**
   - Every quoted statement matches the module word for word, implicit arguments aside.
   - A witness meets each set of hypotheses together (Ladder for laws 1 and 2, ClosedCycle for laws 3 and 4, OwnCondition for `kept_by_name`), so none is vacuous; within 0 holds of no flow, as I3 says.
   - Conclusions are as strong as stated. `renewers_unbounded` gives "no bound from `T₀`", hence "from no step on", because balance from `T₀` holds from every later step. `whole_not_keepsWidening` is exact. `includesAcrossFrom_iff_endless` is an equivalence.
   - No premise hides in a definition: upkeep is the hypothesis `TakesWhileSupported`, and the World premises are hypotheses.
   - The claims of constructive need hold: lists of steps without choice, `search` with `Nat.decLe`; `length_le_count` with no decision; the decided form with finitely many decisions.
   - Each witness shows what its docstring says, except E1 and I1.
   - Law 1's dependence on whole-number amounts is stated (NOTE §2.1); law 2's dependence on a list with repetition is not (I4).
3. **02's open item.** Not answered; a narrower question is answered (O1).
4. **The replacement.** It is supported on intent, and more strongly by the late giver than by the lagged relay; the forms are independent (O3, I3). The changes are listed below. `Saturated.reverses` is not at risk.
5. **Grades and neighbours.** No grade is too harsh. The TAP, assembly theory and Jones rows are too generous (O2), and the RAF and Jones mappings need correcting (I5, I6). "None is a result no neighbouring field states" is right. Pirt (1965) is *Proceedings of the Royal Society of London B* 163 (991): 224–231. The Jones model's form and the TAP equation are as DESIGN states them.
6. **Rules 8 and 9.**
   - Names: I2 and S10.
   - Moves: O4 and E2.
   - Laws stated beside landed ones that should go below: S1–S4.
   - The leaf's reason: S5.
7. **Pure core.** Satisfied.
   - Imports are three package modules; the closure has 77 modules, all in the checker's CORE and FOUNDATION lists, and nothing outside the package besides `Init`.
   - The source has no `sorry`, `native_decide`, `set_option`, `opaque`, `unsafe`, `partial`, `extern`, `implemented_by`, `macro`, `elab`, `axiom` or `instance`, and no tactic block: every proof is a term.
   - Decisions come only from `Nat.decLe`, `Nat.decLt` and supplied `Decidable` hypotheses.
   - What no report catches lies in the modelling: discrete steps, natural-number amounts, Prop-valued support, and a present list with repetition.
   - `check_becoming.py` (its environment audit, controls and prelude-only compile) waits for landing.

### What the replacement changes

**UE4's record** ([eventual-widening](../../../../../../theories/becoming/results/records/eventual-widening.md)):
- **Law 7.** The definition becomes `OpenedByOpenedWithin`, with its laws: brief supports give it; it is monotone; it gives the lagged form; the old form at every origin gives bound one. State the exemption and `K ≥ 1`, and remove "provisionally" and the closing "Provisional: …" sentence. `not_of_unsupported` is restated with the same proof ([appendix A](#appendix-a-the-exclusion-law-and-the-restated-witnesses), `OpenedByOpenedWithin.not_of_unsupported'`).
- **Law 8.** "On that web no flow is opened by the opened" (`OwnCondition.not_opened`) carries over through the restated `not_of_unsupported`.
- **Law 11.** `relay_opened`, `oneGiver_not_opened` and `carried` become `relay_within`, `oneGiver_not_within` and `carriers_within`, all in the kit. The sentence stays true.
- **Law 12.** `still_not_opened` and `reverses` become `still_not_within` and `reverses_within` ([appendix A](#appendix-a-the-exclusion-law-and-the-restated-witnesses)). The sentence stays true, with "within one".
- **Law 13.** `ClosedCycle.opened` and `cycle` become `opened_within` and a restated `cycle`.
- **Does not show.** The second bullet ("A law relating 生成 to widening (02 stays open), or any gain, renewal or giver law") changes with UE7: those laws are proved as restatements, and 02 is narrowed (O1). The provisional clause of the third bullet goes.
- **Next.** The gain bridge and the givers law were called "each a candidate no neighbouring field states". Record them as candidates that turned out to be restatements.
- **Sources, evidence and history.** Regenerate with the declaration lists.

**07 §2** (r-eventual-widening, chapter line 79):
- Change "(every later gain given by a formation that gained support before)" to "(every gain from step `K` on given by a formation that gained support within the `K` steps before)".
- Change "(`OpeningChain.carried`; the property `Flow.OpenedByOpened` is provisional)" to the new names, without "provisional".
- `ClosedCycle.cycle` and `Saturated.reverses` follow their restatements.

**07 Open**, "The second-order direction of 生生" (line 628): the first laws it asks for, gain from beyond and givers multiplying, are now proved, as restatements. Narrow the item to the comparison itself.

**Elsewhere:**
- `EventualWideningInstances.lean`, a landed core module whose owner decides the definition change (AGENTS, Coordination);
- the root module's description (`Becoming.lean`, near line 1220);
- the package README's L1 row;
- the generated indexes.

**`Saturated.reverses`** is not at risk. `reverses_within` is proved from `relay_within`, `still_not_within` (no gain recurs on the saturated web) and the landed `level_rising`, `level_full` and `full_widens_rising`.

## What the record should and should not claim

**It may claim:**
1. **Law 1, a restatement (open systems; finite recurrence).** Take a course keeping widening by name on the actual levels, in which every formation supported from `T` on requires, at every step and at one need, only conditions of a finite list. Then:
   - its stock on that list passes every bound, and rises, at arbitrarily late steps;
   - under the first law, with the list without repetition, at arbitrarily late steps the list is given net by the rest or is not closed;
   - with balance on the list from a step as well, it is not closed at arbitrarily late steps.

   Moreover, a finite, closed world, balanced on all its conditions under the first law, has no course keeping widening by name with its requirements so fixed. All this uses whole-number amounts.
2. **Law 2, a restatement (maintenance scaling: depreciation, Pirt, break-even investment).** Under upkeep, a course keeping widening by name has more takers without end. With balance on the family from a step, its replenishment is bounded from no step on. With bounded giving per entry, its renewers are too: entries of the present list, which are formations where the list has no repetition.
3. **Law 3, near-definitional.** The local, global and decided forms. The two double negations locate which condition rose and at which step of the window the giver gained support. Decided support and a listed family remove them, and no omniscience principle enters.
4. **Law 4, near-definitional.** Items (a)–(d) of O1; it answers part of 02's open item.
5. **The witnesses,** each premise shown needed as listed, with E1 corrected.
6. **If adopted, the recency form of opened by the opened:** its laws, its exemption before step `K`, the independence of the two forms (the lagged relay and the late giver), and the restated UE4 witnesses.
7. **Constructivity.** No choice anywhere; the count lemma needs no decision; every axiom report is empty.
8. **Standing.** None of the four is a result no neighbouring field states, none compares two courses, and the second-order direction of 生生 stays uncaptured.

**It should not claim:**
- that 02's open item is answered, or that there is a law relating 生成 to widening what can form;
- that generation and widening are "independent both ways", unless it adds that on each reading used they cannot hold together;
- third parts against TAP, assembly theory or Jones 1995;
- that the provisional form was merely too strict;
- that every gain of the lagged relay is given by a formation that gained support two steps before;
- that RAF theory has no growth laws;
- that renewers count formations, without the caveat on repetition;
- that the cycle opens nothing in the core's sense, beyond "keeps opening from no step", unless the stronger statement is proved;
- that the kit's two derivations satisfy rule 9 as placed;
- UE4's "a candidate no neighbouring field states" for the gain bridge or the givers law.

## Appendix A: the exclusion law and the restated witnesses

This is scratch, not for landing as is. Names follow the kit's (`Opens`) and would follow a rename under I2. `Linked.snoc'` is primed only because it is scratch. Compiled with Lean 4.29.1 against the kit; `#print axioms` gives "does not depend on any axioms" for `not_keepsOpening_along_openings`, `not_keepsWidening_along_openings`, `not_within_zero`, `Saturated.reverses_within`, `ClosedCycle.not_opening_along'` and `OpenedByOpenedWithin.not_of_unsupported'`.

```lean
import Becoming.SustainedWidening

/-! Reviewer's scratch checks for UE7 (not part of the kit; not for landing). -/

namespace Becoming

variable {F C : Type}

namespace Web

/-- Appending one step to a link chain. -/
theorem Linked.snoc' {R : Nat → F → F → Prop} : ∀ {s : Nat} {f : F} {t : Nat} {g h : F},
    Linked R s f t g → R t g h → Linked R s f (t + 1) h
  | _, _, _, _, _, .here t _, r => .next r (.here (t + 1) _)
  | _, _, _, _, _, .next r' rest, r => .next r' (Linked.snoc' rest r)

end Web

namespace Flow

variable {L : Flow F C} {W : Web F C}

/-- Under the World premises, along "carry on, or open", whatever is supported at `S + k` is,
up to double negation, linked to something supported at `S`. -/
theorem descends_along_openings (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) (S : Nat) :
    ∀ k g, W.Supported (S + k) g →
      ¬ ¬ ∃ f, Web.Linked (Web.passingContinuation (L.Opens W)) S f (S + k) g ∧ W.Supported S f
  | 0, g, supported => fun none => none ⟨g, .here S g, supported⟩
  | k + 1, g, supported => fun none =>
    (fun em : ¬ ¬ (W.Supported (S + k) g ∨ ¬ W.Supported (S + k) g) => em fun decided =>
      match decided with
      | .inl before =>
        descends_along_openings balances acting dependent unloosened S k g before
          fun ⟨f, linked, sf⟩ => none ⟨f, Web.Linked.snoc' linked (.inl rfl), sf⟩
      | .inr notBefore =>
        gain_carried (fun c _ => balances.on [c] (S + k))
          (fun c _ => acting.giversSupported dependent (S + k) c)
          (unloosened (S + k) g) ⟨notBefore, supported⟩
          fun ⟨h, sh, carries⟩ =>
            descends_along_openings balances acting dependent unloosened S k h sh
              fun ⟨f, linked, sf⟩ =>
                none ⟨f, Web.Linked.snoc' linked (.inr ((opening_carries_iff sh).mp carries)), sf⟩)
      (fun k => k (.inr fun h => k (.inl h)))

/-- **Under the World premises nothing keeps opening along "carry on, or open".** The continuation
along which `generates_of_brief` reads 全生成 admits no keeping widening: balance, only active
formations giving, activity needing support and unloosened requirements already refute it. -/
theorem not_keepsOpening_along_openings (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) (T : Nat) :
    ¬ W.KeepsOpening (Web.passingContinuation (L.Opens W)) W.level T :=
  fun opens => match opens T (Nat.le_refl T) with
    | ⟨_, le, ⟨g, admitted, apart⟩⟩ => match le_dest le with
      | ⟨k, at_⟩ =>
        descends_along_openings balances acting dependent unloosened T k g
          (Eq.subst (motive := fun x => W.Supported x g) at_ admitted)
          fun ⟨f, linked, sf⟩ =>
            apart f (Eq.subst (motive := fun x => Web.Linked (Web.passingContinuation (L.Opens W)) T f x g)
              at_.symm linked) sf

/-- So, under the World premises, nothing keeps widening along it either. -/
theorem not_keepsWidening_along_openings (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (unloosened : ∀ t f, W.Unloosened t f) (T : Nat) :
    ¬ W.KeepsWidening (Web.passingContinuation (L.Opens W)) W.level T :=
  fun keeps => not_keepsOpening_along_openings balances acting dependent unloosened T keeps.2

/-- Within zero is empty: with gains recurring, the window `[S, S)` holds no gainer. -/
theorem not_within_zero : ¬ L.OpenedByOpenedWithin W 0 :=
  fun ⟨recur, within⟩ => match recur 0 with
    | ⟨t, f, _, gains⟩ => within t f gains
        fun ⟨_, _, _, _, _, _, _, _, from_, below, _⟩ =>
          Nat.lt_irrefl _ (Nat.lt_of_le_of_lt from_ below)

/-- `not_of_unsupported`, restated for the proposed definition. -/
theorem OpenedByOpenedWithin.not_of_unsupported' {T : Nat}
    (none_ : ∀ t f, T ≤ t → ¬ W.Supported t f) (K : Nat) : ¬ L.OpenedByOpenedWithin W K :=
  fun ⟨recur, _⟩ => match recur T with
    | ⟨t, f, from_, gains⟩ => none_ (t + 1) f (Nat.le_succ_of_le from_) gains.2

end Flow

namespace Saturated

/-- `still` is opened by the opened within no bound: no gain recurs. -/
theorem still_not_within (K : Nat) : ¬ Flow.OpenedByOpenedWithin still web K :=
  fun ⟨recur, _⟩ => match recur 0 with
    | ⟨_, _, _, gains⟩ => gains.1 (fun _ _ => Nat.le_refl 1)

/-- `Saturated.reverses`, restated for the proposed definition. -/
theorem reverses_within :
    Flow.OpenedByOpenedWithin OpeningChain.relay OpeningChain.web 1 ∧
      OpeningChain.web.level = OwnCondition.rising ∧
      (∀ K, ¬ Flow.OpenedByOpenedWithin still web K) ∧ web.level = OwnCondition.full ∧
      OwnCondition.web.Widens OwnCondition.full OwnCondition.rising :=
  ⟨OpeningChain.relay_within, OpeningChain.level_rising, still_not_within, level_full,
   OwnCondition.full_widens_rising⟩

end Saturated

namespace ClosedCycle

/-- The cycle's `not_opening_along` is the general law's instance. -/
theorem not_opening_along' (T : Nat) :
    ¬ web.KeepsOpening (Web.passingContinuation (flow.Opens web)) web.level T :=
  Flow.not_keepsOpening_along_openings balances acting dependent unloosened T

end ClosedCycle

end Becoming
```

## Appendix B: the late single giver

This is scratch, not for landing as is. It was compiled with Lean 4.29.1 against the kit; `#print axioms Becoming.OpeningChain.forms_independent` gives "does not depend on any axioms".

```lean
import Becoming.SustainedWidening

/-! Reviewer's scratch check: a late single giver is opened by the opened in UE4's form and within
no bound in the proposed form (not for landing). -/

namespace Becoming

namespace OpeningChain

open OwnCondition

/-- Formation `0` at step `0`, formation `1` at every later step. -/
def lateGiving : Nat → List Nat
  | 0 => [0]
  | _ + 1 => [1]

theorem lateGiving_succ (n : Nat) : lateGiving (n + 1) = [1] := rfl

/-- **A late single giver**: formation `1`, which gained support across the step from `0`, gives
every later unit. -/
def lateGiver : Flow Nat Nat := ⟨lateGiving, fun _ _ _ => 0, fun t _ c => opening t c⟩

theorem lateGiver_balances : lateGiver.Balances web := fun t c => match t with
  | 0 => show rung c 1 + (0 + 0) = rung c 0 + (opening 0 c + 0) from balanced_step 0 c
  | t + 1 => show rung c (t + 1 + 1) + (0 + 0) = rung c (t + 1) + (opening (t + 1) c + 0) from
      balanced_step (t + 1) c

theorem lateGiver_acting : lateGiver.Acting web := fun t _ _ mem _ => match t, mem with
  | 0, mem => match mem_cons_cases mem with
    | .inl same => Nat.le_of_eq same
    | .inr inner => nomatch inner
  | t + 1, mem => match mem_cons_cases mem with
    | .inl same => Eq.subst (motive := fun x => x ≤ t + 1) same.symm
        (Nat.succ_le_succ (Nat.zero_le t))
    | .inr inner => nomatch inner

/-- In UE4's form, from origin `0`, the late single giver is opened by the opened. -/
theorem lateGiver_opened : Flow.OpenedByOpened lateGiver web 0 :=
  ⟨gains_recur, fun t f after gains => match t, after, gains_iff.mp gains with
    | s + 1, _, same => ⟨f, 1, 0, rfl,
        Eq.subst (motive := fun x => web.Rises (s + 1) x) same.symm (rises_next (s + 1)),
        .head [],
        Eq.subst (motive := fun x => 0 < opening (s + 1) x) same.symm (opening_pos (s + 1)),
        supported_iff.mpr (Nat.succ_le_succ (Nat.zero_le s)), Nat.le_refl 0, Nat.zero_lt_succ s,
        gains_iff.mpr rfl⟩⟩

/-- In the proposed form it is opened by the opened within no bound. -/
theorem lateGiver_not_within (K : Nat) : ¬ Flow.OpenedByOpenedWithin lateGiver web K :=
  fun ⟨_, within⟩ => within 1 (1 + K + 1) (gains_iff.mpr rfl)
    fun ⟨_, g, u, _, _, mem, _, _, from_, _, gained⟩ =>
      have listed : lateGiving (1 + K) = [1] :=
        (congrArg lateGiving (Nat.add_comm 1 K)).trans (lateGiving_succ K)
      match mem_cons_cases (Eq.subst (motive := fun l => g ∈ l) listed mem) with
      | .inl same =>
        Nat.not_succ_le_self u (Eq.subst (motive := fun x => x ≤ u)
          (same.symm.trans (gains_iff.mp gained)) from_)
      | .inr inner => nomatch inner

/-- **The two forms are independent**: on one web, the late single giver meets UE4's form at
origin `0` and the proposed form at no bound; the lagged relay meets the proposed form within two and
UE4's form at no origin. -/
theorem forms_independent :
    lateGiver.Balances web ∧ lateGiver.Acting web ∧ Flow.OpenedByOpened lateGiver web 0 ∧
      (∀ K, ¬ Flow.OpenedByOpenedWithin lateGiver web K) ∧
      Flow.OpenedByOpenedWithin laggedRelay web 2 ∧ ∀ T, ¬ Flow.OpenedByOpened laggedRelay web T :=
  ⟨lateGiver_balances, lateGiver_acting, lateGiver_opened, lateGiver_not_within,
   laggedRelay_within, laggedRelay_not_opened⟩

end OpeningChain

end Becoming
```
