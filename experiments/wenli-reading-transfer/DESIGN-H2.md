
# Testing H2 on the frozen core: a pre-registered design

**Status.** This is a design only. Nothing has been run and no file has been edited. It is AI-authored (Claude). The hypothesis comes from 文理生生's plan (01 §1.1 H2 and §八) and from the conversation of 22 October. Both are provenance; the reasons for each choice are given below. The work belongs to board item WL, under "the reading-transfer test designed". A run needs its own claim on the board and its records in the zhonghua study; no new dated workspace is needed.

## 1. The claim, stated so it can fail

The plan states H2 as: understanding these compositions improves structural reconstruction, explanation and transfer on unseen instances. As it bears on the theory, the claim under test is CL:

> **CL.** Take the frozen core R. Some readers learn R's laws through the controlled classical code K_zh: the 中华本's 經, its 凡例, 447 names and 11 function words. Others learn the same laws through a controlled English code K_en, at equal length and equal fidelity. The K_zh readers reconstruct the structure of unseen cases, and handle counterexamples, better than the K_en readers. The advantage arises through the mechanism the plan names: rereading internally generative text lets the reader reconstruct its rules.

CL splits into separately tested parts.

- **H2-T (transfer; primary).** K_zh beats K_en on transfer (P1) and on counterexample handling (P2), on mechanism-dense text, after the final pass.
- **H2-R (repetition; 读书百遍).** The K_zh − K_en difference grows over passes. The difference must lie in the slope, not only in the intercept.
- **H2-A (internal generation against authority).** The difference is larger on mechanism-dense text (A) than on conclusion-only text (B) of the same content and length.
- **H2-L (which grouping does the work).** The difference is concentrated where the code's grouping of names agrees with the structure's grouping, and it reverses where they disagree. L1 is morphological congruence: names that share characters. L2 is sense congruence: each name's inherited sense either is or is not the sense the name table adopts.
- **Rival explanations, each with a control arm.**
  - K_mz tests a first-language advantage.
  - K_en-comp tests compositional coding that any language can carry.
  - K_zh-perm tests whether brevity, register or familiarity with the characters alone does the work.

**What the theory predicts.** This is an AI reading: a correspondence to be tested, not an application of a theorem. The core proves what any learner working through a class can fix beyond its data:

- data fix an untried value exactly where it is lumped with an observed input (`determines_lumped_iff`);
- a fit is right beyond the data exactly where the class determines it (`Training.fit_right_iff`);
- a model of structure and a model of change are one lumping (`goAlike_iff_lumped`);
- learnability through a map is characterized (`learnable_iff`);
- within N states, 2N − 1 steps fix the course (`Identification.bounded_agree`, `leastBound_exact`).

Read these laws as an account of a reader. The code's composition and the reader's prior senses of the characters supply the class; the curriculum supplies the data. On that reading the theory predicts H2-L, not a blanket advantage for any one language. A code helps exactly where its grouping is the grouping the structure goes alike across, and misleads where it is not. Rereading identical text adds no data, so any gain across passes must come from the reader changing the class, that is, reconstructing the model. The design measures this through the model notes readers write after passes. If readers do not behave this way, the correspondence fails as a model of human reading; no Lean result changes.

**What the test cannot decide.**

- Whether the language *is* the theory. Content is invariant under a faithful renaming (`SharedCodes.renamed_tells_apart_iff`, `renamed_carries_iff`), so this is not an empirical question; that is why it is excluded here.
- Whether the theory holds of actual unfoldings.
- Whether classical Chinese is best among all languages. Only the arms that are run are compared.

## 2. Materials

### 2.1 Freeze
R consists of:

- the commit of main and the core receipt current at registration (today, receipt `20261022T040548.209667Z`, with its recorded source commit);
- `THE-THEORY-OF-BECOMING-ZHONGHUA.md`;
- `names-decisions.tsv` (447 rows) and `symbols-not-adopted.tsv`;
- `THE-THEORY-OF-BECOMING.md`.

The registration file records the SHA-256 of each. Committed scripts generate every arm text from these frozen sources. Reading materials change after registration only through the gate procedure (§2.5), and every revision is logged.

### 2.2 Curriculum and held-out laws
There are two content blocks with few links between them, so that text type can vary within each reader.

- **Block D (dependence and exchange):** 一·一–一·十三, 二·一–二·七 and 四·一–四·五. That is 25 條 and 2,406 Han characters of 經.
- **Block K (knowing):** 七·一–七·三, 九·一–九·六, 九·十二–九·十七 and 九·二十九–九·三十六. That is 23 條 and 2,476 characters.

In each block, five 條 are held out by seeded lot. Candidates are only 條 whose 證 includes a theorem and which define no name a later taught 條 uses. Held-out 條 appear only at test. The lists are fixed by number at registration.

### 2.3 Arms (codes)
Every arm renders the same taught declarations and comes with a conventions page of matched length. No arm shows Lean names, 說, quotations or 證.

- **K_zh.** The 經 verbatim, plus the 凡例 entries for the function words and status marks they use (若, 则, 故, 必, 或, 皆, 莫, 恰当, 不可非, 有例, 定然否).
- **K_en.** For each taught declaration, start from the canonical chapter's clause that cites it. Complete the hypotheses that the Lean statement carries. Use only glossary terms from §10(a)–(b), each with its one sense. Compress to the length budget. Two bilingual translators with formal training write it from the Lean statements and the glossary, *not* from the 經, so it does not copy the classical surface. It must pass the gates.
- **K_mz (stage 2).** Controlled modern Chinese, built by the same procedure from the records' `laws[].zh` statements.
- **K_en-comp (stage 2).** K_en with the 中华本's composition carried into English morphology by a table generated from the name table. Each single-character name gets one English root taken from its 所名. Then 者 becomes "-er", 所X becomes "X-ee", X网 becomes "X-web", and so on. Its grouping of names is then K_zh's grouping.
- **K_zh-perm (stage 2).** K_zh under an injective renaming of the names; function words and 凡例 stay unchanged.
  - Each name is replaced by a string of equal length drawn from the code's own character inventory.
  - The draw is constrained so that names sharing a character in K_zh share none after renaming.
  - No image may be a common classical word.
  - Content is unchanged (renaming invariance). The code's grouping and the names' inherited senses are destroyed.

### 2.4 Text types (the plan's A/B/C, crossed with code, so no type is assigned to a culture)
- **A (mechanism-dense).** The taught 條 in order, each with its conditions, its definitions and the laws it rests on.
- **B (conclusion-only).** The same laws' conclusions in the same code, with hypotheses, the definiens of each definition and the cross-links all removed. Conclusions are restated in varied wording to reach equal length. This is the plan's "authority" register. Its universals are mostly false as stated; that is intended, and the trap items measure the consequence.
- **C (reference reading).** A formal text of matched length and difficulty from an unrelated domain (the rules of a finite board game or a railway interlocking), rendered in each arm's register. A separate baseline group reads it. It estimates what reading any formal text in that register contributes to the same name-free tests.
- **Mechanism density** is rated by three blind raters per text: stated conditions, definitions used later, and derivation links, per 100 morphemes. A must exceed B in both codes, and the A/B ratio must agree across codes within 10%.

### 2.5 Gates (passed before any reader sees the texts)
1. **Length.** Count morphemes: Han characters for Chinese; for English, words plus affixes by a registered rule list; a variable or numeral counts as one. Arms must agree within ±5% per block and within ±20% per 條. Characters, words and tokens under three tokenizers are reported as well.
2. **Fidelity by back-translation.** Two formalizers per arm, blind to the hypotheses, receive only the arm's text and conventions page. They write each law as a structured statement (hypotheses, quantifiers, direction, conclusion). A third person scores these against the Lean statement. Each arm must reach at least 90%, and the arms must agree within 5 points.
3. **Excess referents and omissions.** Apply the companion fidelity measure to every arm text. Arms may differ by at most 0.1 excess referents per statement and 5 points in omission rate.
4. **Mechanism density**, as in §2.4.

Equal length and equal fidelity may not both be achievable. If not, that fact is recorded as a result (the K_zh code compresses better at equal fidelity). The primary comparison then runs at equal fidelity with reading time matched, and the equal-length version runs as secondary.

### 2.6 Tests
Items are language-neutral wherever the claim allows.

- Unseen systems are shown as diagrams and tables of levels, needs and exchanges over steps, with abstract labels.
- Instructions are identical for all arms: short, in modern Chinese and English side by side.
- Answers are given by selecting, drawing edges or entering numbers.
- Every answer key is computed from the system's specification and checked in Lean by a periphery driver running `decide` on the finite instance, with a receipt.

Item families:

- **O1 structure reconstruction.** From a trace, draw the dependence web: who requires whom, and at what need. Scored by edge-level F1.
- **O2 conditional prediction under perturbation.** After a stated change (a take raised, a source removed, an observation coupled in), predict:
  - which relata keep support;
  - which claims are excluded at which step;
  - whether a feature is learnable through a given map;
  - whether a prefix fixes the course.

  The reader also chooses the condition among distractors.
- **O3 traps** (registered misreadings):
  - co-variation read as dependence;
  - persistence through exchange read as stasis;
  - 穷则变 read as unconditional;
  - mutual generation read as symmetric causation;
  - 不息 read as 生生;
  - data assumed to fix an untried value without a lumping;
  - a finite prefix assumed to exclude a claim about the tail without a model;
  - continuation read as a ranking.
- **O4 revision.** Shown a counterexample trace, the reader revises the earlier answer.
- **O5 calibration.** A confidence rating (0–100) on every item, plus overgeneralization items where a taught law's condition fails.
- **O6 held-out laws (code items).** For a held-out 條, given small examples, choose its statement in the arm's code among distractors that differ in hypothesis, direction or scope.
- **O7 unseen names (code items).** Names formed by the arm's own composition rules but never taught; the reader identifies what each denotes in a diagram.

Unseen cases come from three sources:

1. finite worlds generated after the freeze by a seeded generator;
2. 文理生生's micro-models and engine models (`research/constructions/`, `research/engine/`), restricted to what the core's representation covers; a separate project wrote these, for neither code;
3. the plan's flame and forest cases, under the same restriction.

There are four parallel forms per time point, balanced on family, block and congruence, and rotated by Latin square.

**Congruence coding** is mechanical and fixed before data collection.

- Each item maps to the laws it needs, and those laws to their names in K_zh.
- **L1** is the adjusted Rand index between two partitions of those names: by shared characters, and by shared defining Lean constants (from the Lean dump in the fidelity tooling).
- **L2** is computed from the name table's 式 column, which marks each name 古, 复 or 新 (old, revived, new):
  - a 古/复 name whose dominant inherited sense the 不带 note strips is *incongruent*;
  - a 古/复 name whose kept sense is its dominant one is *congruent*;
  - a 新 name is *neutral*.

## 3. Readers

### 3.1 Humans (primary: they decide H2)
**Why humans.** H2 is a claim about human understanding, and 读书百遍 is a human practice. Results from language models cannot stand in for either.

**Population.** Adult Mandarin–English bilinguals who meet all of:

- a classical Chinese pre-test score of at least 60% (20 items on 文言 passages unrelated to the theory);
- English at C1 or above (pre-test);
- a basic discrete mathematics pre-test (sets, functions, graphs, quantifiers), reported and used as a covariate.

Assigning codes at random within one population removes the confound that separate Chinese and English reader groups would add. It leaves K_zh a first-language advantage, which K_mz controls.

**Exclusions.**

- Anyone who has read the theory, either edition, 文理生生 or the repository, checked by self-report and by a recognition test with foil sentences.
- Anyone who has taken part in the project.

**Assignment.** Randomization is stratified by the three pre-test scores.

**Sample size.** Provisional; it is fixed by simulation from the pilot before confirmatory data are collected.

- Stage 1: K_zh and K_en, 80 readers each, with text type A/B varied within reader; C baseline, 40 per code.
- Stage 2: K_mz, K_en-comp and K_zh-perm, 80 each, A only.

The figure of 80 rests on these assumptions:

- a standard deviation of about 0.21 between reader means of proportion correct;
- a smallest effect of interest of 8 points (d ≈ 0.38), which would need about 110 readers per arm unadjusted;
- about 30% of variance explained by the pre-tests.

**Pilot.** Twelve readers per stage-1 arm, to estimate variance components and timing. Pilot readers are not reused.

### 3.2 Language models (secondary: a separate confirmatory family, H2-M)
**Why models as well.** They give statistical power, exact control of exposure and length, and a literal dose of repetition. The theory is also read and maintained by AI sessions, so whether the code helps machine readers matters on its own. Their results neither support nor refute the human claim.

**In-context readers.**

- Families: at least three families other than the ones that wrote the texts. Claude wrote the 中华本 and much of the canonical chapter; GPT/Codex wrote 文理生生. The authoring families run as a flagged extra arm.
- Contamination controls:
  - training cutoffs before the codes became public;
  - a canary string in every material;
  - a membership check: the model completes the second half of 20 經 and 20 English clauses, and a model that completes them above chance is excluded.
- Procedure: the model reads the curriculum and writes model notes of bounded length, for k ∈ {1, 3, 10} passes, with the notes carried forward. Each test item runs in a fresh context holding the curriculum and the notes.
- Replication: 30 seeds per cell.

**Trained readers.**

- Two open-weight model families that differ in their balance of Chinese and English pretraining, plus the untrained base model.
- Each is fine-tuned (LoRA) on the curriculum text only, for E ∈ {1, 10, 100} epochs, with 5 seeds per cell.
- Each epoch contains an equal number of morphemes across arms. Token counts are reported, and a token-equalized run serves as sensitivity check.
- Testing uses fixed few-shot prompts in the neutral item format.

## 4. Procedure (humans)
- **Day 0.** Consent, pre-tests, recognition test, randomization.
- **Day 1 (proctored).**
  - Read the conventions page.
  - Pass 1 of both blocks: one block in A and the other in B, counterbalanced; the time cap per block is the pilot median × 1.3.
  - Write model notes in a diagram editor with abstract nodes.
  - Take form 1.
- **Days 2–9.**
  - Passes 2–9 on a locked platform: time is logged; copying, search and dictionaries are disabled; attention checks are embedded.
  - Model notes after pass 3.
  - Form 2 after pass 3, under remote proctoring.
- **Day 10 (proctored).** Pass 10, model notes, form 3.
- **Day 17.** Form 4, a retention test with no reading.

Baseline C readers follow the same schedule with text C. Pay is equal across arms. Readers are told only that the study compares ways of writing the same mathematics. Ten passes stand for 百遍 among humans; the trained-model arm goes to 100 epochs.

## 5. Outcomes
**Primary**, measured at form 3; both are required:

- **P1 transfer:** the mean of O1 F1 and O2 accuracy, on name-free items.
- **P2 counterexample handling:** O3 correct rejection with the correct condition, together with O4 revision success.

**Secondary:**

- the slope over forms 1–3 (for H2-R);
- form-4 retention;
- O5 calibration (Brier score and overgeneralization rate);
- O6 and O7;
- structural accuracy of the model notes (edge F1 against the Lean dependency graph of the taught block);
- reading time.

## 6. Analysis
- **Model.** Mixed-effects models on item responses: logistic for accuracy, linear for F1.
  - Fixed effects: code, text type, log pass, their interactions, and the three pre-tests.
  - Random effects: intercepts for reader and item, a slope for pass by reader, and a slope for code by item.
- **H2-T.**
  - The contrast is K_zh − K_en, text A, form 3, on P1 and on P2, each tested one-sided at α = 0.025.
  - CL requires both (an intersection–union test, so no further correction).
  - The smallest effect of interest is Δ = 8 points. A relative version is also registered: half the A-over-C gain in the K_en arm.
  - Equivalence is tested by two one-sided tests at ±Δ, which gives a refutation verdict.
- **The seven secondary hypotheses** (H2-R, H2-A, H2-L1, H2-L2 and the three stage-2 controls) are tested one-sided with Holm correction at 0.05. Each is interpreted whatever H2-T gives.
- **Mediation (secondary).** The change in model-note accuracy across passes is tested as mediator of the pass effect on P1, by arm.
- **Missing data.** The primary analysis is intention to treat: every randomized reader who completed form 1, with multiple imputation. Per-protocol is a sensitivity analysis.
- **Exclusions**, fixed in advance:
  - failing the recognition test;
  - passing fewer than 2 of 3 attention checks;
  - pass times below 30% of the pilot median.
- **Sensitivity analyses:**
  - equal-fidelity against equal-length texts;
  - without the 文理生生 unseen cases;
  - by tertile of the classical Chinese pre-test. If the advantage appears only in the top tertile, it is familiarity, as the plan warns.
- **Language models.** The same contrasts are run per family, then pooled by random-effects synthesis across families. For trained readers, the dose–response over epochs is estimated with seeds as replicates.
- **Grading.** Drawings for O1 and O4 are scored automatically against the keys. Any free-form answer is scored by two graders blind to arm.
- **Discipline.** One registered analysis script, run once on locked data. No optional stopping.

## 7. What refutes the claim
Results refer to human readers, form 3 and text A unless stated otherwise.

| Result | Verdict |
|---|---|
| K_zh − K_en is equivalent to zero within ±Δ, or below −Δ, on P1 or on P2 | **H2-T refuted** for this core, code and population |
| The difference is neither significant nor equivalent | Not supported; inconclusive |
| K_zh > K_en, but the difference does not grow across passes | The advantage is familiarity or fluency; the 读书百遍 mechanism is refuted |
| The advantage is as large on B as on A | It does not come from internal generation |
| The advantage appears only in the top classical Chinese tertile, or is as large after reading C | Familiarity or general training |
| K_mz is non-inferior to K_zh (≥ K_zh − Δ) | A first-language advantage; the claim narrows to "Chinese", not "the classical code" |
| K_en-comp ≥ K_zh − Δ | The advantage is compositional coding that any language can carry; "best language" is refuted, "compositional code" stands |
| K_zh-perm ≥ K_zh − Δ | The names' composition and senses do no work; at most brevity or register remains |
| An accuracy gain comes with worse calibration or more overgeneralization | Counts against the claim (the plan's outcome 5) |
| The advantage is not larger on congruent items (L1 or L2), or is larger on incongruent ones | The account of reading as learning through a lumping fails as a model of these readers |
| A gate fails | No verdict until the materials are repaired |

CL is supported only if H2-T holds on both P1 and P2, H2-R and H2-A both hold, and K_zh beats all three controls.

## 8. What each verdict changes
No theorem changes under any verdict. What changes is readings and chapter prose:

- The ZH 序 section "为什么用古典之名" and the arguments of CIV §五 keep or lose any claim of superiority.
- The AI reading that the line of 文 is the best expression of the core's language narrows to whatever survived the test. That may be a compact index, a compositional code, a first-language effect, or nothing.
- The correspondence that reads §3.3 as a model of human reading gains or loses empirical support. This is recorded under §8.7 (empirical correspondence).

A refutation leaves the 中华本 standing as a reading edition, with its names and checks intact.

## 9. Threats and their handling
- **Shared authorship.** Both codes and this design are AI-written in one repository. Handling: translators, formalizers, item writers and graders are external; the gates; the flagged arm for the authoring families.
- **Coined names against everyday words.** K_zh has 131 新 names while K_en uses ordinary English words. Handling: the L2 moderator and the K_zh-perm arm.
- **Test language.** Handling: name-free primary items and side-by-side bilingual instructions.
- **Reading time.** Handling: time is logged and capped, and an equal-time analysis is run.
- **Practice effects.** Handling: parallel forms, Latin-square rotation and a retention form.
- **Item bias.** Items are written from the neutral specification by people who have not read the 中华本, and every key is checked in Lean.
- **Ethics.** All readers give consent. Because B contains false universals, every reader is debriefed with the correct statements.

## 10. Registration
The following are committed to the zhonghua study before any data are collected:

- the registration text, the material generators and the materials;
- the Lean key checks with their receipt;
- the analysis script;
- a SHA-256 manifest;
- a deviations log.

A board claim is needed before any run.
