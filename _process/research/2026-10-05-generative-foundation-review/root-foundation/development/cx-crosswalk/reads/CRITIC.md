<!-- AI-written, 7 November 2026, completeness critic of the crosswalk. It adds no result. Every verdict here is an AI reading. -->

# The crosswalk as a whole: what is wrong or missing

**Verdict.** The readings are good and mostly honest; the labels on top of them say more than the readings do. Target quotations, absence evidence and what the summaries say is named or not named all held. What does not hold is `carried-in-part` and `agreement` as counted: a reader taking the totals (670 carried in part, 423 agreement) would believe the account states more, and has laws for more, than the entries themselves say. The same claim also gets different verdicts in different items. Nothing is missing at the level of items, with one capped row.

## What I read

- `BRIEF.md`; `aa-attractor-atlas/PLAN.md` §3.2, §3.3, §6.3 to §6.5; `digest.py` whole and `--counts`; every item's `group` block.
- 59 entries in full against both sides (table below), and further entries against their targets only (marked where used).
- Home sections, read for the five most cited targets and the next: 07 §6 (`#alignment-without-premise`, 86 citations), 08 `#one-relational-unfolding` (63), 02 `#r-closed-capture` (59) with `#r-capture-through-the-rule` (45), 07 §8 and `#does-not-show` (58, 38), 02 `#t7` (54), 05 §10 `#markets` (54). Also T1, T2 and T6's statements, and the JSON (`hypotheses`, `does_not_show`, `correspondence`) of `closed-capture`, `capture-through-the-rule`, `a-code-formed-between-formations` (45), `relative-position-is-zero-sum`, `becoming-return-grades`, `represented-boundary-against-dependence`.
- Read-only scripts over `reads/*.3-check.json`: target resolution, carried by relation, 1,539 quoted fragments in `says` searched in their homes, name greps over the live account. Nothing else was run: no checker, gate, build or test.
- Sources: for `read-in-repo` entries I opened only the lines the sampled entries cite. For `ai-knowledge` entries I compared against my own memory, which is itself unchecked.

## What held

| Check | Result |
|---|---|
| Items | 28 present with all three stages: all 16 folders under `theories/` other than `becoming`, and all 12 domains of PLAN §6.3 |
| Entry ids | 1,180, all unique |
| Targets | every anchor resolves; 17 record citations missing from the index are a stale index, not a bad target (L1) |
| Quotation of targets | of 1,539 fragments, 1,516 are in the cited home, 14 elsewhere in the live account, 9 not found by the script; of those I grepped, the misses are translations from Chinese pages or quotes from a neighbour the entry names (L2) |
| Summaries on presence and absence | hold where I grepped: Bergson, Marx, Simondon, Michels, Soros, Tainter, Ibn Khaldun, Plato, Stoics, Polybius, Aquinas, Senge, Beer, Holling, Luhmann and Bostrom have no line in chapters, fronts or review; Aristotle one record; 'ubuntu' only the record hit the summary describes; the five design folders named in 05 alone among chapters and fronts; the dossier's stale Tiantai line |
| Summaries' counts | the per-relation counts in the domain summaries match the files where they state them |
| Divergence kept | 277 divergence and 25 contrary against 423 agreement; Buddhist has no agreement at all. Divergence is not crowded out in most items |
| Absences | all seven `not-carried` entries I tested held, and my own greps found nothing they missed (`burden`, `segregat`, `percolat`, `underinvest`, `adaptive cycle`, `addict`, `Gödel`) |
| Ethics | no entry says the ethics derives from the condition or that a law says a loss is a harm; the phrases recur only as denials. 91 of 105 entries citing T8, `#scope-and-order`, `#condition` or the widening law name both premises (M5) |
| Stored sources | the verbatim passages I opened are there: 不住相似生 (青目 on 中论 13), 相續滅，是名苦邊 (雜阿含), 積累莫返 (黄宗羲), and the English quotes from the folders |

The most cited targets are quoted faithfully with their qualifiers. The stretching is not in `says`: it is in what an entry labels as following from a correctly quoted target.

## Entries checked against both sides

The sample was aimed at agreements and at phrases that looked like trouble, so **this is not an error rate**. "Held" means carried, relation and targets stand as labelled. "Partly" means the reading stands and a label or a target needs fixing.

| Verdict | n | Entries (`cx-`) |
|---|---|---|
| Held | 32 | dpc-fold; ecoevo-stage-structure-and-t2; econ-hardin-commons; econ-goodhart-regularity; pal-goodhart-taxonomy; econ-ostrom-commons; syscyb-ostrom-design-principles; syscyb-ostrom-against-hardin; greek-polybius-anacyclosis; greek-thrasymachus-stronger; greek-heraclitus-river; modphil-spinoza-necessity; modphil-marx-metabolic-rift; modphil-marx-boundless-drive; modphil-jonas-heuristics-of-fear; oi-moksha; oi-jain-sat; syscyb-foerster-imperative; syscyb-trap-shifting-the-burden; jianwen-alignment-from-algebra; memories-one-owned-premise; ma-partial-reform; ma-vs-goodhart-and-lock-in; econ-michels-oligarchy; econ-ibn-khaldun-cycle; econ-schelling-segregation; buddhist-mmk13-arising-alike; indaf-gift-circulates; cc-gu-wangtianxia; abr-khaldun-asabiyya; abr-hisba-office; pal-godel-incompleteness |
| Partly | 12 | cc-huang-jilei-mofan; econ-acemoglu-persistence; zhishan-selection-follows-feedback; ctxrt-legibility-test; memories-values-as-neutral-design; rsd-he-not-tong; greek-roman-usufruct; abr-prophets-against-rulers; pal-attachment; ecoevo-evolutionary-traps; dpc-noise-tipping; dpc-hopf-cycles |
| Failed | 15 | wamo-no-stable-victory; sty-non-inference-algebra; sty-touch-whitehead; abr-jubilee-return-of-land; abr-subsistent-relation; asc-survival-belief; dpc-hysteresis; dpc-rate-tipping; indaf-constituted-person; modphil-marx-capital-self-valorizing; modphil-marx-coercive-competition; modphil-marx-reproduces-the-relation; modphil-marx-surplus-not-from-circulation; oi-gita-descent; greek-thucydides-stasis |

By relation among the 59: every contrary reading, divergence and `not-carried` I sampled held, and all the scope entries but one (`cx-wamo-no-stable-victory`). Every failure but that one is an `agreement`. Correct that label first.

---

## High

### H1. `carried-in-part` does not separate "the account states part of it" from "a law of this form exists and this reader joined it"

The brief has `fresh-reading` only "for domains". So the 16 folder items have 0 fresh readings, and a reader there who found a law of like form could only write `carried-in-part` or `not-carried`. Domains use both for the same case: "Reading it so is mine" goes to `fresh-reading` in the Greek and Marx entries and to `carried-in-part` in `cx-dpc-hopf-cycles` ("The relation to delay is my reading") and `cx-dpc-noise-tipping` ("by my reading").

A phrase search of `reading` for self-declared joins (is mine, my reading, this read's, no live text, composition) finds 56 `carried-in-part` entries, 45 of them in folders. This is a list to re-read, not 56 errors. Some are a single link in an otherwise carried claim.

`carried` is nearly empty (3) and `carried-in-part` is 57% of all entries, so the value carries little information: in the sample it runs from "the law is the claim in whole numbers" (`cx-dpc-fold`) to "the source's main claim is not stated" (`cx-rsd-he-not-tong`, whose 同则不继 "no law says").

**Fix.**
1. Extend `fresh-reading` to folder items in BRIEF: the account does not state the connection; it is proposed here.
2. Re-read the 56 and move those whose join is the whole connection. Start with: `cx-asc-survival-belief`, `cx-asc-recursive-capture-threshold`, `cx-asc-self-interest-selfishness`, `cx-asc-corpus-channel-training-ground`, `cx-kpso-paradigm-coherence`, `cx-hsm-wheel-reinvention`, `cx-hsm-borrowable-method`, `cx-hsm-new-problems`, `cx-hsm-conversion-to-tool`, `cx-zhishan-controllability-inversion`, `cx-zhishan-independence-is-material`, `cx-zhishan-perverse-principle`, `cx-zhishan-semantic-closure`, `cx-sty-prohibition-unexpressed`, `cx-jianwen-particles-as-first-order-logic`, `cx-archearth-datong-as-a-condition`, `cx-dpc-continuum`, and the 16 `cx-drives-*` listed by the same search.
3. Report the corrected counts in each summary.

### H2. `agreement` goes well beyond its definition

BRIEF, from 06: agreement is "the form of a **checked law**". Then:

- 55 of 423 agreements have no record among their targets: only a thesis, a method section, a Reading or a front (`memories-and-working-style` 12, `meta-attractor` 7, `zhishan` 7, `jian` 6, `kpso` 5, `modern-philosophy` 5). Examples: `cx-zhishan-world-happening-as-us`, `cx-ma-intelligence-not-direction`, `cx-ma-organization-first`, `cx-abr-subsistent-relation`, `cx-rsd-ontology-entails-nothing`, `cx-modphil-marx-fetishism`. By 08 the thesis "has no strength: it excludes no observation", so agreement with it alone shows very little.
- Further agreements cite a law while their reading says the source's point is not that law. The group summary for `modern-philosophy` concedes this in advance: "25 agreement (of form, often through a reading or a premise, not a law)". A concession in a summary does not repair 25 entries that a count will pick up as agreement.
- The Marx cluster shows it best, as 7 agreements of 9. Coercive competition: "the law covers any selection, so it reads nothing peculiar to capital, while Marx's whole point is the specific form". Reproduction: "A class relation is not a share, and reading the wage relation as such a rule is mine". Self-valorizing: "the wide sense the glossary sets aside", which PLAN §3.3 keeps `open` with no law. Surplus: "only if value is read as an amount".

**Fix.**
1. Add a required field on agreement, `agreement_of: law | thesis-or-method | reading`, filled from the targets, and report the three separately in every summary. Method agreements are real (the 12 in `memories` are the account's method restating the folder's), but they are not 06's 相合.
2. Relabel as below (H4).

### H3. The same claim gets different verdicts in different items

| Claim | Now | Fix |
|---|---|---|
| Believed survival pressure | `cx-asc-survival-belief` carried-in-part/agreement; `cx-drives-survival-meta-attractor`, `cx-ma-survival-belief` not-carried | asc to `not-carried` (its reading: "No live text draws this link"); move the set-point forms to `reading` |
| Commons or collar (one sentence) | `cx-kpso-abundance-commons-or-collar` not-carried; `cx-fork-commons-or-collar` changed/divergence | fork to `not-carried`: the account has no such layer or either/or. Keep "ownership is no variable" in `reading` |
| Do not use AI to compete | `cx-asc-pragmatic-minimum`, `cx-kpso-stop-using-ai-to-compete`, `cx-fork-one-rule` not-carried; `cx-wamo-ai-out-of-the-game` history-only; `cx-rsd-ai-not-for-struggle` carried-in-part/divergence; `cx-zhishan-do-not-fight-for-us` changed/divergence | one verdict for all six. I would use `changed`/`divergence` with `alignment-direction-under-widening` and CD §8, as zhishan has it, since the account takes up the topic and gives only a conditional direction. Nothing is carried in rsd's case either way |
| The guardian test | `cx-ma-guardian-test` scope; `cx-zhishan-guardian-test` agreement, whose reading says "not every remedy" | zhishan to `scope` |
| A counter-rule becoming the capture it opposed (one D68 reading) | `cx-ma-anti-attractor`, `cx-drives-confucian-engineering` scope; `cx-kpso-governance-paradox`, `cx-drives-virtue-does-not-self-install`, `cx-rsd-kernel-degenerations` agreement | kpso and drives-virtue to `scope` (both state it universally and the reading conditions it). rsd-kernel to `not-carried`: "It names no degenerations of a kernel" |
| Reform absorbed (one law) | `cx-ma-partial-reform` scope; `cx-econ-acemoglu-persistence` agreement, whose reading says "The mechanism parts" | acemoglu to `scope`; keep substitution of power in `source_adds` |
| Practical and epistemic closure | `cx-ma-epistemic-closure` scope; `cx-asc-closure-of-correction` agreement ("readings with no law of their own") | asc to `scope` |
| Open ontology (one claim of Ren's, same targets) | `cx-ctxrt-open-ontology-worlds` scope; `cx-sty-open-ontology-define-kinds` agreement ("No law says worlds need this") | sty to `scope` |
| Obedient assistant in a race (one D68 reading) | `cx-kpso-game-between-principals` agreement; `cx-zhishan-two-body-problem` scope, correcting no universal | zhishan to `agreement`; add `several-optimizers-drain-by-their-joint-capacity` to kpso, which cites the reading and not the law |
| AI raises the gain | `cx-wamo-amplifier` scope; `cx-kpso-ai-raises-the-gain` agreement ("Only rule-shaping is covered", against the source's "every existing strategy") | kpso to `scope` |

The likely cause is that each item's three readers saw few of the sibling items, and no pass compared items. **Fix.** After these, run one pass grouped by shared target, for `closed-capture`, `capture-through-the-rule`, `selection-through-couplings`, `a-code-formed-between-formations` and 07 §6's readings, and compare relation on like claims. Cross-item rule for the pass: where the source states it universally and the target conditions it, the relation is scope.

### H4. Entries a sceptical reader would call a word match

| Entry | What matches | Fix |
|---|---|---|
| `cx-wamo-no-stable-victory` scope | The source's reason is that "the game itself forces the delegation of the decisive move" (README line 49). `relative-position-is-zero-sum` is a different mechanism, joint excess and dependence on a drawn condition. "Holds only where the winner depends on what is drawn" scopes a claim the source does not make. The D45 target adds nothing | `not-carried`, or `changed` with the witness kept as a remark; drop D45 |
| `cx-sty-non-inference-algebra` agreement | Three of five targets hit on the words: "Admissibility is not permission", "nor any authority", "confers no authority". The source's object is seven separately owned graphs | `carried-in-part`/`divergence` on status, keep `#beginning-within-the-one-unfolding` and `premises-met-and-failed` as the general form, drop the rest |
| `cx-sty-touch-whitehead` agreement | "every exchange touches a relatum" and a World premise (balance) against "every event is a 'touching'". The source's claim is metaphysical, one bearer's contact as the single write verb; balance is an accounting premise of a model | `not-carried`; the reading stays as a neighbour note |
| `cx-abr-jubilee-return-of-land` agreement | Land "returning" to a family against `becoming-return-grades`, which grades when a dependence is met again. The item's own `not_mapped` rejects teshuvah as this same word match, and its coverage says no law of an imposed calendar reset exists | relation `divergence` on ground, or `not-carried` with the capture remark in `reading`; drop `becoming-return-grades` |
| `cx-abr-subsistent-relation` agreement | "Relation" in the Trinity, said of God alone, "the reverse of 'whatever is, is how it relates'" by its own `source_adds` | `divergence` |
| `cx-indaf-constituted-person` agreement | Reading: "Same words, not the same reference"; "Dependence is not constitution"; 05 allows no unit with an interest of its own. Most serious of the set, given BRIEF's rule 5 | `divergence`; correct the summary's "two agreements in form only" |
| `cx-oi-gita-descent` agreement | "with every coupling and strength supplied": any listed sequence has this form, and no law gives any link | `fresh-reading` with relation `divergence` on the causal order, or drop the relation claim. A form admitting every chain explains nothing, by 08 |
| `cx-greek-thucydides-stasis` agreement | Its reading says he has "no share or lock" and that the code law "reads forms, not valuations" | `divergence`, or `scope` if its human-nature claim is taken as universal |
| `cx-archearth-security-and-cooperation` agreement (read against targets only) | "read security as slack" is the only form; the reading then reports 05 saying the law changes, not the state alone | `changed`/`divergence` |
| `cx-modphil-marx-capital-self-valorizing`, `-coercive-competition`, `-reproduces-the-relation`, `-surplus-not-from-circulation` agreement | H2 | `divergence` each. `-fetishism` to `agreement_of: thesis-or-method`. Keep `-boundless-drive`, `-metabolic-rift`. Update the summary's counts |
| `cx-zhishan-selection-follows-feedback` | Its reading calls the second half "a word match if read through D45", and D45 is still a target | drop that target |
| `cx-sspiral-adopt-or-die` agreement (read against targets only) | The reading conditions the source's "all agents become": "a rest under copying, one reachable state" | `scope` |
| `cx-ctxrt-legibility-test` | The 07 §6 sentence is decoration on a near-definitional law | drop the §6 target |
| `cx-rsd-he-not-tong` agreement | Three unrelated laws stitched together; the central 同则不继 has no law | keep `carried-in-part`; relation `scope`, and lead `source_adds` with the omission |
| `cx-greek-roman-usufruct`, `cx-pal-attachment`, `cx-ecoevo-evolutionary-traps` | Each reading says the law's subject differs (a holder against a run; no caregiver; "both this reading's") | keep, and mark `agreement_of: reading` |

### H5. A domain summary contradicts its own entries

`dynamics-physics-complexity`'s summary says the account has "no law of a path through a band, critical rate of a regime", and its coverage lists hysteresis and rate-induced tipping as absent. `systems-cybernetics` lists "any law of hysteresis" as absent too. Yet:

- `cx-dpc-hysteresis` is `carried-in-part`/`agreement`, with "no live law draws it" and "Both compositions are mine".
- `cx-dpc-rate-tipping` is `carried-in-part`/`agreement`, with "Only a reading names this route; no law states it" and "my composition".

These two count in the summary's "20 agreement". They matter beyond this item: PLAN holds a hysteresis test and CY(b) and CY(c) on whether such a law exists.

**Fix.** Both to `not-carried`, keeping the compositions in `reading`, marked as proposals. Record the hysteresis composition (stag hunt, width hi − lo; triad tolerance) for the atlas as a candidate to prove, not a result. Thin `cx-dpc-hysteresis`'s eight targets to the two the composition uses (`shaping-read-by-readers-drawn-from-the-selected`, `thresholds-of-waiting`) and drop T1's ("neither frozen lake test says anything of T1"). Re-check `cx-dpc-hopf-cycles`, `cx-dpc-noise-tipping`, `cx-dpc-transcritical`, `cx-dpc-chaos` and `cx-dpc-dependence-cascades`, whose readings also say "my reading". Then restate the summary's counts.

---

## Medium

**M1. One anchor stands for many claims.** `07 #alignment-without-premise`, the most cited target, is a section holding at least eight separate statements: the thesis-conditional opening, one theorem table, and readings D25, D26, D45, D65 and D68. Most are AI readings; the crosswalk shows one target and hides which. One sentence, "Alignment is first what each one's selections reach…", itself under "On the thesis of one relational unfolding", serves both as agreement (`cx-ctxrt-legibility-test`, `cx-memories-values-as-neutral-design`, `cx-zhishan-selection-before-games`) and as divergence (`cx-ctxrt-prompt-narrows-path`, `cx-ctxrt-no-silent-mind-edits`, `cx-memories-operationability-reflex`, `cx-sty-community-sovereignty`, `cx-jianwen-anti-zhuxin`), as a general stance and not a mechanism. **Fix.** Add a `reading` key in the target (D25, D45, D65, D68, or a theorem's own `r-` anchor such as `#r-the-gap-for-ones-own-act`). Drop that sentence where it is not the entry's mechanism.

**M2. Agreement on a reading descended from the source.** BRIEF: "The law does not depend on the source." 07's D68 reads the imperial examination "as read in the meta-attractor line"; 02's D26 and D67 read "the corpus's" meta-attractor and "selecting the selectors". A folder cannot gain agreement from a reading made of the folder or its siblings. Laws in Lean can, since they stand apart from it; the readings cannot. Affected: `cx-ma-loses-force`, `cx-ma-organization-first`, `cx-ma-intelligence-not-direction`, `cx-rsd-kernel-degenerations`, `cx-drives-virtue-does-not-self-install`, `cx-kpso-governance-paradox`, `cx-zhishan-guardian-test`, `cx-zhishan-controllability-inversion`. `cx-ma-intelligence-not-direction` has this reading as its only target, and its own reading says "on coupling, not on the environment's reward". **Fix.** Report these as carried by descent in `reading`, not as independent agreement; relabel as in H3, and give `cx-ma-intelligence-not-direction` a law target or `scope`.

**M3. Targets padded with what is not stated.** 119 entries have six or more targets. 169 of 3,876 target citations have a `says` that states a limit by the phrase search (not stated, neighbour, says nothing, the link is mine). The honesty is good, but those belong in `source_adds`: the citation counts and any "which laws carry what" view built on them will overstate. Examples: T1 in `cx-dpc-hysteresis`; `experiment-needs-return` in `cx-econ-goodhart-regularity` ("a neighbour only"); `a-pair-tolerates-only-within-a-window` in `cx-econ-ostrom-commons`. **Fix.** Add `role: law | neighbour | limit` on targets, and count only `law`.

**M4. One row was capped, and its summary does not say so.** `psychology-alignment-logic` holds three fields in 15 entries. Its `not_mapped` says multipolar traps and Moloch (a PLAN §6.3 seed), and Hendrycks and Christiano, were left out by "cap of 15". The theme runs through the folders, so the row should have it: `cx-asc-*`, `cx-wamo-*` and `cx-ma-vs-moloch` read Moloch from the folders' side, and the domain row has no entry for the field's own statement. **Fix.** Add `cx-pal-multipolar-traps` and say in the summary that the row was capped. BRIEF's range is "usually", not a limit, and no other item shows a cap.

**M5. Ethics targets without both premises, by string test.** 14 of 105 entries citing T8, `#scope-and-order`, `#condition` or the widening law do not name both the condition and C anywhere in the entry: `cx-asc-impossibility-claim`, `cx-asc-context-dependent-alignment`, `cx-ctxrt-operator-not-empty`, `cx-ctxrt-projection-not-neutral`, `cx-drives-minds-first`, `cx-drives-repertoire-curriculum`, `cx-ecs-synthetic-members`, `cx-greek-socrates-no-one-errs`, `cx-greek-aristotle-virtue-character`, `cx-hsm-value-or-tool-alone`, `cx-kpso-many-measures-of-worth`, `cx-kpso-determined-adversary`, `cx-kpso-published-falsifiers`, `cx-zhishan-failure-conditions-reflexivity`. I ran the string test and did not read each. Some may cite those anchors for a non-ethical line. **Fix.** Name both, or point to the narrower anchor actually meant.

---

## Low

- **L1. `record-index.tsv` is stale.** `what-would-give-c` landed after the index was made, so 17 citations do not resolve in it. The record and its page exist. Regenerate with `make_record_index.py` before any import.
- **L2. Translations in quotation marks.** English in quotes for Chinese pages reads as verbatim: `cx-rsd-kernel-degenerations` ('did not speak of the true 道'), `cx-buddhist-mmk-samsara-nirvana-no-difference` ('the proof is almost by definition'; the home has 几乎依定义), `cx-drives-truth-intersubjective`, `cx-drives-confucian-engineering`. Quote the Chinese, or drop the marks.
- **L3. `history-only` is used two ways.** 20 have no relation and 3 have one (`cx-buddhist-mmk26-chain-and-stopping`, `cx-greek-socrates-knowing-scope`, `cx-greek-epicurus-death`); 5 carry live targets (those three, `cx-oi-meta-attractor-reading`, `cx-zhishan-planetary-technology`). Allow a relation here in BRIEF if a structural reading is also proposed, say that it is one, and mark the targets as neighbours (M3).
- **L4. Claims counted twice across items.** Sen's intersection, capability and Paretian liberal stand in both `economics-politics-sociology` and `modern-philosophy`; Goodhart in `economics` and `psychology-alignment-logic`, consistently; Ibn Khaldun in `abrahamic-islamic` and `economics`, with cross-references that hold. Harmless per item, but any crosswalk-wide total should count them once. Add a `same_as` link.
- **L5. One entry lacks the standing.** Of 19 agreements citing `selection-through-couplings`, 18 carry its near-definitional standing or its premise; `cx-ecoevo-evolutionary-traps` does not.
- **L6. Process traces, and unread stretches.** `group.read` holds "This attempt:" and "an earlier attempt" (`keep-the-possibility-space-open`, `drives-narrative-attractors-and-mind`); clean them before import. Disclosed and harmless by their headings: `meta-attractor` README lines 734 to 1019 ("What was lost", "In Ren's own words"), `zhishan` lines 1088 on (sources), `keep-the-possibility-space-open` lines 870 on, and the three `.zh.md` editions in `meta-attractor`.

## Agreement crowding, looked at

Agreement's share of entries with a relation runs from 0% (Buddhist) to 82%. The four highest are `architecture-for-a-living-earth` 82% (no scope at all), `evolving-community-swarms` 80%, `ecology-evolution` 77% and `dynamics-physics-complexity` 74%; the next is 50%. I do not call all of this crowding. The two folders hedge their claims, which gives scope nothing universal to correct, and the two sciences are what 08 itself calls restated. Dynamics has the label error of H5, and `cx-archearth-security-and-cooperation` is one case found. These four are where a second look at H2 should go first, and I did not sample them enough to say more.

## Order of fixes

1. BRIEF: extend `fresh-reading` to folders; add `agreement_of` and target `role`; settle `history-only`.
2. The named entries of H3, H4 and H5, one pass, by a reader other than the checker.
3. The grouped-by-target pass of H3, and the re-read of H1's 56.
4. Regenerate the summaries' counts from the files instead of writing them by hand, so that a summary cannot disagree with its entries. Then M1, M2, M4 and M5.
