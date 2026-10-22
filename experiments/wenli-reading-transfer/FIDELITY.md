
# Excess referents: a fidelity measure that can run now

## 1. What it measures, and why
For each 條 of the 中华本 and its English counterpart in the canonical chapter, the measure counts the relata, agents and entities that the wording introduces but the Lean statement lacks. This is the operational form of the repository's rule that no name or variable may smuggle in an independent ontology.

Several claims made so far become testable through it:

- The 中华本's 序 says relational names make extra explanation unnecessary.
- The critic reading says classical Chinese has no obligatory subject while English does.
- The same reading says inherited senses ride along with characters.

Registered predictions:

- **F1.** The 經 introduce fewer agents (X_A) than the English clauses.
- **F2.** The 經 introduce no more excess referents (X) than the English clauses.
- **F3.** Omissions (O) are not what buys a lower X; the genre-matched comparison in §5 decides this.
- **F4.** The inherited-sense load (X_naive − X_table) is larger for the 經.

F1 and F2 are refuted if the 95% CI of the mean zh − en difference lies above 0. The H2 design also uses this measure as a materials gate.

## 2. Units and correspondence
**中华本 units.**

- Split the text at `### ` headings under 凡例, 篇一–篇十六 and 论纲. Stop at `#### 对照` and at the appendices.
- Each 條 has a 經, a 說 and a 證.
- Resolve the backticked names in the 證 with `work/resolve.py` (`resolve_decl`). Where that fails, accept a unique suffix match in the receipt's declarations. Log anything ambiguous or unresolved.
- Flag each 條 that contains a reading (讀（AI…）), a constructed example (有例), a double negation (不可非) or a thesis (论纲). Theses are scored separately against the chapter's Theses section and are not part of the primary comparison.

**The Lean statement L(d)** for each declaration d. Its referents are:

1. every binder of d's elaborated type, whether explicit, implicit or instance, including binders introduced by `variable`;
2. every variable bound inside the conclusion by ∀, ∃ or λ;
3. every term the statement forms by applying a constant to these, such as `w.web.level t x` or `π d`;
4. for each `Becoming.*` constant occurring in the type, one level of unfolding (U1): the binders and terms of its definition body.

Sensitivity runs use U0 (no unfolding) and U2 (two levels). For a `def` or `structure` cited in a 證, L is its binders plus its body or fields.

**Sorts.** Each referent gets one sort from a table reviewed once before scoring:

- relatum or role (types F and C, and elements of them);
- configuration (S);
- step (a `Nat` used as the index of a web field, a run or a history);
- amount (any other `Nat`);
- history or run;
- claim or predicate;
- map, lumping or feature;
- class of functions;
- law or process;
- world, web or flow;
- family or list;
- value;
- standpoint;
- significance.

Separately, each referent is classed as a hypothesis (a non-dependent `Prop` binder), a decidability instance, or a type parameter.

**English counterpart E1.** Taken from canonical chapter §0–§7, plus §8.6 and §9 for 凡例 items.

- Protect code spans, then split into sentences: at `.` or `;` followed by a capital, a code span or `(`.
- A clause is the text before a parenthetical that holds code spans; its citations are those spans.
- A bullet head of the form ``- `a` (with `b`)?: text`` is a clause citing a (and b).
- A sentence with code spans outside parentheses is a clause at sentence level.
- Resolve each cited short name *in the context of the 條*: among `resolve_decl` and suffix candidates, keep the one in the 條's 證 set.
- Where several clauses cite d, the primary clause is the one citing the fewest other declarations, ties broken by first occurrence; the others are logged.

**English counterpart E2 (fallback).** Where no clause cites d, use the `laws[].en` statement of a record cited in the 證 whose law names d or whose `references.declarations` contains d. E2 is tagged and analysed separately.

**Aligning 經 clauses to declarations.**

- Split the 經 at 。 and ；, keeping a definition head that ends in ： with its body.
- Propose an assignment of clauses to declarations by anchor overlap: the names in a clause whose anchors' constants meet the constants of L(d). Use 證 order as a prior.
- Two coders confirm the assignment, record agreement, and an adjudicator settles differences.
- A clause may state a set D of declarations. It is then judged against the union of L(d) over D. The same applies to an English clause that cites several declarations.

**Pairing.** The paired unit is (條, d) where d has both a 經 segment and an E1 segment. Per-條 scores are means over the 條's paired declarations.

## 3. Coding rules (codebook v1)
### Referents
A referent is any expression in the segment that denotes something within the unfolding as represented, of any sort: a relatum, role holder, collection, state, step, amount, history, law, map, claim, value or agent.

- **Chinese:**
  - names from the name table, and the 37 words of `symbols-not-adopted.tsv`;
  - 者 and 所 nominalizations;
  - nouns, deictics (此, 彼, 其, 之, resolved to their antecedents), variables and numerals.
- **English:**
  - noun phrases, pronouns (resolved), variables and numerals.
- **Not counted:**
  - zero anaphora and dummy subjects (it, there);
  - quantifier words (凡, 皆, 莫, every, any);
  - connectives (恰当, 则, exactly where, if).

Count distinct referents per segment: two mentions of one referent count once.

### Matching (a referent has a counterpart if any rule applies)
- **M1 direct.** It denotes a binder, a bound variable or a constructed term of L(D). Use the name table's 所名 and 锚 columns for Chinese, and the glossary anchors for English.
- **M2 role.** A role nominalization (待者/所待, formation/condition, 读者/所读, taker/giver) of a relatum present in L(D) matches that relatum. If the relation defining the role is absent from L(D), code a predicate excess (P), not a referent excess.
- **M3 collective.** 兼, 诸物, the whole, the family or the world matches a binder of collection, type or world sort. Without one, it is excess R, tagged *ground*.
- **M4 quantity and step.** These match `Nat` terms of the right sort.
- **M5 unfolding.** A referent matches if it lies in the U1 body of a constant occurring in d's type.
- **M6 constructed examples.** In an 有例 or "for example" statement, a referent matches the witness constants of the construction (U1).
- **Sort preservation.** The counterpart must have the same sort, or an allowed coarsening from the registered table (for example, "relatum" matches formation or condition, and "observation" matches a coupling relation). A match across sorts, such as a "rival claim" mapped onto a history, counts as excess, and the Lean referent counts as omitted.

### Classes of excess
- **A (agent):** a referent presented as acting, perceiving, knowing, choosing, intending or owning, or any personal referent (人, 我, 吾, 君子, 知者, we, one, the observer, the learner). An exception: 我, 己 and 方 match the standpoint binder where one exists.
- **R (relatum):** a participant in the unfolding that L(D) lacks: an environment, another party, a third, a container, the rest.
- **E (entity):** a reified abstraction: knowledge, truth, nature, order, a law where L(D) has none, a "rival claim", 道 or 理 taken as a substance.

Tags on excess referents follow the four non-relational layers (CIV §四·三): *ground*, *nature*, *centre/will* and *rank*. Further tags mark referents in negated scope (*neg*), inside a reading (*reading*), and on the inherited-sense hazard list (*hazard*).

### Excluded from counting
- **META:** references to the text, the theory, Lean, a section or 條 number, 本书, 本篇, this law, the representation.
- Quotations (「…」 with 〔…〕).
- Lean names inside the wording.

### Secondary codes
- **O (omission):** binders and hypotheses of L(D), including decidability instances (定然否) and type parameters, that the wording does not render. A structure binder counts as rendered if any of its fields is mentioned. A target left implicit in a predicate ("couples in", with no stated target) counts as not rendered. O-rate = O / (binders + hypotheses).
- **S (connective mismatches):**
  - ↔ rendered in one direction only, or as plain "is";
  - ∀ rendered as a generic or habitual statement;
  - ¬¬ rendered as a plain assertion (not 不可非 / "cannot be refuted");
  - ∃ rendered as ∀;
  - a negation whose scope has moved;
  - a hypothesis rendered as a conclusion.
- **P (predicate excess):** an agentive or intentional predicate attached to a matched referent (seeks, tests, wants, 求, 欲) with no counterpart relation. P is reported apart from X.

### Two passes
- **X_table (primary).** Coders have the code's key: the name table's adopted senses for Chinese, the glossary for English.
- **X_naive (secondary).** Coders read without the key, as an untrained reader would, and code what the plain classical or plain English sense introduces. X_naive − X_table is the inherited-sense load.

### Worked examples
These are AI calibration codings for the codebook, not results.

1. **九·十二 against `Web.Excludes.not_of_alike`.**
   - The Lean statement has: F and C, W, `obs`, g, l, l′, a claim, t, the hypotheses `meets` and `alike`, and U1 of `Excludes` and of `AlikeThroughUpTo`.
   - The 經 clause 「如此辞之一历缘其感至此步与所然无异，则此辞于此不见去」: 辞 = claim; 一历 = l′; 其感 = `obs` at g; 此步 = t; 所然 = l. X = 0.
   - The English clause "a claim and its rival must differ where something couples in": "its rival" is a claim, and L has no second claim, so it is excess E (sort mismatch). "Something" matches a coupled condition by U1. X = 1. O includes the formation (only implicit) and the step.
2. **七·三 against `determines_lumped_iff`.**
   - The 經 renders 一族 (List), 定然否 (`DecidableEq K`), 相异之二 (`two`) and 恰当 (↔). X = 0, O = 0.
   - The English clause "Finite data fix an untried value exactly where it is lumped with an observed input" gives X = 0. O = 3: the class of functions lumped by π, the two values, and decidability. Its connective is right.
3. **X_naive on 運 (一·一).** The name table strips 「同段所设之推动者」. In the table pass X = 0. In the naive pass, a reader of 「天其運乎」 may posit a mover: excess A, tagged *centre/will*.

## 4. Procedure
- **F0 (mechanical, now).**
  - Extract the 條 and their 證.
  - Extract the English clauses.
  - Dump the Lean statements (§6).
  - Assign sorts.
  - Propose the alignment.
  - Generate candidate referents.
  - Compute X_anchor, a screening statistic: names in the segment whose anchor constants miss L(D).
- **F1 (calibration).** Forty pairs, stratified by 篇, are set aside to train the codebook and excluded from scoring.
- **F2 (coding, now).**
  - Two LLM coders from different families code every segment, with Chinese and English segments in separate shuffled batches. A coder never sees the other language's segment for the same declaration.
  - Since Claude wrote both texts, at least one coder must come from another family, and between-family agreement is reported.
- **F3 (human audit).** A bilingual coder who reads Lean codes a stratified 20% sample and every disagreement. An adjudicator settles the rest.
- **Reliability.** Krippendorff's α is computed on per-segment X (interval) and on referent classes (nominal), after span matching with at least 50% overlap. Below α 0.8 on counts, revise the codebook on the calibration set and recode, logging each revision.

## 5. Scores and analysis
**Per unit.**

- Per segment: X, X_A, X_R, X_E, O, O-rate, S, P and X_naive.
- Per (條, d) pair; per 條 (means); per 篇.

**Comparisons.**

- **Primary:** paired zh − en on per-條 mean X.
  - A cluster bootstrap over 條 (10,000 resamples) gives the CI.
  - A Wilcoxon signed-rank test is run on the 條 means.
  - A Poisson mixed model `X ~ language + (1|條) + (1|d)` is fitted.
  - McNemar's test is run on X ≥ 1.
  - All of the above is repeated by class (A, R, E) and by 篇.
- **Genre-matched 2×2** (register × language): 經 against EN-rec (`laws[].en`), ZH-rec (`laws[].zh`) against EN-rec, 經 against ZH-rec, and 說 prose (quotations and readings removed) against the E1 clauses. This separates a language effect from a register effect: the 經 are full statements, while the chapter's clauses summarize.

**Sensitivity analyses.**

- unfolding depth U0, U1 and U2;
- excluding negated referents;
- excluding readings;
- E1 only against E1 + E2;
- LLM-only coding against human-audited coding;
- the correlation of X_anchor with coded X.

## 6. Script outline
The scripts would live in the zhonghua study's `development/zhonghua/fidelity/` when the measure is run. Nothing is written now.

```
inputs (frozen, hashed): ZH chapter, EN chapter, work/names-decisions.tsv, work/symbols-not-adopted.tsv,
  theories/becoming/results/records/*.json, wenli 08 dictionary JSON, newest becoming-checks/*/verification.json

extract_zh.py   -> tiao.jsonl {id, pian, jing, jing_clauses[], shuo, decls[], unresolved[], records[], flags}
extract_en.py   -> en_clauses.jsonl {id, section, text, cites[]}; index d -> clause ids; primary choice;
                   E2 fallback from records laws[].en / laws[].zh
lean_dump.py    -> writes TREE/FidelityDump.lean (driver below) with the needed declaration names,
                   runs `python3 -B scratch_build.py TREE FidelityDump` (checker's Lean 4.29.1, shared
                   step cache ~/.cache/becoming-lean, nothing written to the repository),
                   parses `FIDELITY {json}` lines from the driver log in TREE/.build;
                   fallback: a `#check @d` driver with pp.fullNames, parsed for ∀/∃ binder groups
sorts.py        -> sort per Lean referent from a registered type-head table (reviewed once)
align.py        -> per 經 clause, candidate decls by anchor overlap + 證 order; output for coder confirmation
candidates.py   -> zh: longest-match over 449 names + 37 not adopted, 者/所 nominalizations, variables,
                   numerals, agent lexicon, characters whose wenli 08 senses require an Agent parameter,
                   hazard flag from the name table's 注 (本体|实体|推动者|主宰|意志|中心|先在|本原|天意|神|人格);
                   en: glossary §10(a)(b) terms with anchors, NP chunks, pronouns, variables, agent lexicon;
                   X_anchor per segment
packets.py      -> coder packets JSONL {seg_id, lang, text, D, L(D) table with sorts, candidates, codebook}
                   (zh and en in separate shuffled batches; table and naive passes)
score.py        -> X, X_A/R/E, O, S, P, X_naive per segment/pair/條/篇; α; bootstrap; Wilcoxon;
                   Poisson GLMM; McNemar; sensitivity; writes results JSON and a table
```

The Lean driver is a sketch, to be checked when it is built. It goes in the periphery, since `import Lean` is not allowed in the core.

```lean
import Lean
import Becoming
open Lean Meta Elab Command
set_option pp.fullNames true

partial def nested (e : Expr) (acc : Array Json) : MetaM (Array Json) := do
  match e with
  | .forallE n t b bi => withLocalDecl n bi t fun x => do
      nested (b.instantiate1 x) (acc.push (Json.mkObj [("q", "∀"), ("name", toJson n.toString),
        ("type", toJson (toString (← ppExpr t)))]))
  | _ =>
    if e.isAppOfArity ``Exists 2 then
      match e.appArg! with
      | .lam n t b bi => withLocalDecl n bi t fun x => do
          nested (b.instantiate1 x) (acc.push (Json.mkObj [("q", "∃"), ("name", toJson n.toString),
            ("type", toJson (toString (← ppExpr t)))]))
      | _ => pure acc
    else if e.isAppOfArity ``Iff 2 || e.isAppOfArity ``And 2 || e.isAppOfArity ``Or 2 then do
      nested (e.getArg! 1) (← nested (e.getArg! 0) acc)
    else if e.isAppOfArity ``Not 1 then nested e.appArg! acc
    else pure acc

def binders (xs : Array Expr) : MetaM (Array Json) := xs.mapM fun x => do
  let d ← x.fvarId!.getDecl
  return Json.mkObj [("name", toJson d.userName.toString), ("type", toJson (toString (← ppExpr d.type))),
    ("info", toJson (toString (repr d.binderInfo))), ("prop", toJson (← isProp d.type))]

def dumpOne (n : Name) : MetaM Json := do
  let ci ← getConstInfo n
  forallTelescope ci.type fun xs body => do
    let cs := ci.type.getUsedConstants.filter (`Becoming).isPrefixOf
    let unfold ← cs.filterMapM fun c => do
      match (← getConstInfo c) with
      | .defnInfo v => lambdaTelescope v.value fun ys b => do
          return some (Json.mkObj [("const", toJson c.toString), ("binders", toJson (← binders ys)),
            ("body", toJson (toString (← ppExpr b)))])
      | _ => return none
    return Json.mkObj [("decl", toJson n.toString), ("binders", toJson (← binders xs)),
      ("conclusion", toJson (toString (← ppExpr body))), ("nested", toJson (← nested body #[])),
      ("consts", toJson (cs.map toString)), ("unfold1", toJson unfold)]

elab "#fidelity_dump " ids:ident* : command => do
  for id in ids do
    let j ← liftTermElabM (dumpOne id.getId)
    logInfo m!"FIDELITY {j.compress}"
```

For a `def` in a 證, also dump `lambdaTelescope v.value`. Universe and sort binders are dropped at scoring.

## 7. Pilot facts (read-only pilot in the scratchpad)
- **Units.** 393 條 have both 經 and 證; 410 `###` headings in all.
- **證 names.** The 證 hold 2,293 backticked names. Of these, 2,280 resolve exactly, 4 are ambiguous and 9 are unresolved. Six 條 have no resolvable declaration.
- **English pairing.** A crude E1 extractor over §0–§7, using resolution in the context of each 條, pairs 308 條 and 962 (條, declaration) pairs. The other 85 need the E2 fallback or are reported as unmatched.
- **Name table.** 198 names are 古, 118 复 and 131 新. 118 notes contain 不带, and more strip senses in other words. 58 notes strip a ground, agent or centre sense; these form the hazard list.
- **Agent-lexicon hits.** In the 經 they are few: 求 38 and 我 21. All 21 instances of 我 are in 篇十五 and name the standpoint, which matches the standpoint binder. This is why lexicon hits are only candidates.

## 8. Limits
- The measure scores referents, not truth. A wording that omits everything scores X = 0, which is why O and S are reported beside it.
- Anchors in the name table and the glossary are single representative names, so X_anchor is only a screen.
- The chapter's clauses and the 經 differ in genre; the 2×2 comparison separates genre from language.
- AI coders share the texts' conventions, which is why a human audit decides.
