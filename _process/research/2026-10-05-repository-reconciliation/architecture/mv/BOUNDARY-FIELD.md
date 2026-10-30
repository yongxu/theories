# The boundary field: each central declaration's standing, declared on U4's record and checked against the Lean

**Status:** draft 3, implemented (§8 step 1): the rules in [tools/research/boundary.py](../../../../../tools/research/boundary.py), applied by the check (registry.py) and the generator (master_laws.py); the Lean check in [tools/research/boundary_check.lean](../../../../../tools/research/boundary_check.lean); the tests in [tools/research/tests/test_boundary.py](../../../../../tools/research/tests/test_boundary.py). This is MV's part of U4's boundary record ([WHAT-REMAINS](../../../2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), "One root to its edge" and "OU's decisions on U4").
- **How the field lands.** U4's owner asked for it on 30 October 2026. U4's owner agreed that the record is built to it and that the field lands first, as F5's field ([F5-MODEL-STATEMENTS.md](F5-MODEL-STATEMENTS.md)) landed before U2's Lean.
- **The drafts and their reviews.**
  - Draft 1 (88b470a44): three independent reviewers read it, for the Lean, for the edge's meaning and for the tooling ([reports/boundary-field-review.json](reports/boundary-field-review.json), 49 findings).
  - Draft 2 (136500d72): the same three lenses and a completeness critic re-checked it, finding 49 more ([reports/boundary-field-recheck.json](reports/boundary-field-recheck.json)).
  - This draft takes every finding of both (§9).
- **What it follows.** U4's design at fe2a1942b (DESIGN-BOUNDARY.md, boundary_table.py and the boundary scratch on branch u4-edge), with which the points of §7 are settled.
- **The Lean check.** The tests of a form under a stated hypothesis run in Lean, in the core run's environment: [tools/research/boundary_check.lean](../../../../../tools/research/boundary_check.lean), generalized from U4's scratch check. It replaces the dump fields draft 2 proposed, so the dump is unchanged.
  - Run on U4's two forms, it passes row 17 and refuses row 5 on the discharge condition, as U4 records.
  - Its 21 controls and 10 name-test queries come out as expected ([boundary/check/](boundary/check/)).
- **What landing changes.** Nothing here is claimed for the Lean package. Landing the field changes no figure: the report exists only once a record carries the field.

## 0. What the field is for

U4's edge has three standings (WHAT-REMAINS, "What the edge is"):
1. **derived:** it follows from the grammar's laws, for every relation and class;
2. **on the root under a stated hypothesis:** the hypothesis is written in the grammar's terms, and a countermodel on the root shows it cannot be dropped;
3. **a premise:** stated on the root, with a proof that no statement about the dynamics entails it.

Any other standing is a distance from the edge. OU's owner decided that MV counts these standings once the boundary record lands, and until then the F5 figures stand. F5's own report (`central_reach`: 44 / 16 / 7 / 51) stays unchanged beside the new one.

**The principle is F5's.** What the Lean cannot show is declared and reviewed; the rest is computed.
- **The dump holds names, not terms.** The checker cache's constants dump records, for each constant, the run's constants its type and its value name, and nothing of Lean's `Init` (logic and the arithmetic of `Nat` and `List`). Names and dependencies are checked from it (§3.1, §3.5).
- **The Lean check holds terms.** What needs a term exactly runs in Lean, in the environment the cache restores: a countermodel's statement against the form's telescope, an amount in a hypothesis, a recovery's head, the certificate, and whether a bridge is an equivalence (§3.2, §3.1 D6).

**Three findings shape the design.** U4 reported them, and the probe in [boundary/](boundary/) confirms them (§6).
- **A name test on rows measures packaging, so it applies to declared items.** No central declaration's statement passes the name test. U4 counts 11 that do with their definitions unfolded, and 105 with structures unbundled (U4's figures, not the probe's). So every standing on the edge is carried by a declared item: a grammar law the row is a case of, or a root form the row is an instance of.
- **Reaching the grammar is connection, not derivation.** All 44 rows that reach the grammar reach a grammar law, by the measure's walk, mostly closure's elementary laws used as steps. The measure's "reaches the grammar" says a grammar law or term is among the reasons, never that the row is a case of a law.
- **Balance enters by the statement or by the proof.** The rule reads the statement only (U4's rules, DESIGN-BOUNDARY §2): `Flow`'s anchors in it, or balance written out. Where only the proof reaches balance, that is reported and places nothing.

**What the field takes from F5's plan** (F5-MODEL-STATEMENTS §4): telling derivation from connection, as "derived" against the rule's "connected". It does not take F5's premise value. That value is the grammar form of a premise in COVERAGE.json's register (K3), such as `Web.Dependent` with `dependent_iff`. A standing-2 hypothesis matching a K3 premise names it in its basis (U4 §1.2). Where the premise value lives otherwise is OU's owner's decision, by F5 §4's fallback.

## 1. The standings and the labels

Every distinct central declaration of `COVERAGE.json` gets exactly one label. There are 118 at core run 20261030T152859.871907Z.

| Group | Label | How a declaration gets it |
|---|---|---|
| on the edge | derived | declared, and checked (§3.1) |
| | under a stated hypothesis | declared, and checked in Lean (§3.2) |
| below the grammar | counting | a reading (§3.4) |
| distances | connected | the rule (§3.5), or a reading where the row reaches a grammar law |
| | witnessed at its model | a reading |
| | balance in its statement | the rule, or a reading where the rule's test holds |
| | amounts | a reading |
| | at a represented model | the rule, from F5's verified items |
| | own carrier | the rule, from F5's verified items |
| | at its model | a reading |
| | free significance | a reading |
| unplaced | unplaced | the rule's fallback |

- **Premise is not a label of a central declaration.** All 118 central declarations are theorems, and a theorem whose statement were a premise would prove it. The premises are definitions, and the record lists them apart (§2, §3.3). Standing 3 is empty today (§3.3).
- **Below the grammar** is its own group. Lever 2's review decided that laws of counting are counted apart, neither distances nor derived (REVIEW-U4-L2, S2; U4 §1.4).
- **Precedence.**
  - A checked entry on the edge, or a reading, comes before the rule.
  - An entry on the edge that fails places nothing. Its row takes the rule's label, never a reading's, and the entry is listed as unverified (§3.6).
  - A reading may give any label but the edge's and "unplaced". A reading of a label the rule computes needs the rule's fact (§3.4).
  - "Unplaced" exists so that no row takes a distance by default. The record is complete when no row is unplaced.
- **The labels are U4's** (DESIGN-BOUNDARY §0), with U4's senses:
  - **balance in its statement:** `Flow`'s balance in the statement's closure, or balance written out in its own type;
  - **amounts:** its statement compares amounts, or a hypothesis constrains them, and the grammar has terms for neither;
  - **at its model:** a law of its model with no statement on the root;
  - **free significance:** the general statement keeps `sig` free, as 07 §1 intends.

  "Balance in its statement" was the rule's "balance, represented" in draft 1. It is renamed because the measure's EC6 category of that name is a different set of 31 rows: 19 with `Flow`'s balance in their statements, 2 with it only in their proofs and 10 with the prelude's counting law alone.

## 2. The field

The field is called `boundary`. It sits on one record, U4's boundary record, of schema 2. The check refuses it on a second record and on a superseded or withdrawn one. It is an object with two keys, `standings` and `premises_of_the_ethics`, both required, and no other.

**`standings`:** a nonempty list. It has one entry per central declaration the record places on the edge or by a reading, and one per central declaration whose rule-given label the record confirms with a basis. A row the rule places and the record does not discuss is not written here. Every name is a full Lean name (`Becoming.Flow.no_new_dependence`).

| Key | Required for | Content |
|---|---|---|
| `declaration` | every entry | the central declaration; at most one entry per declaration |
| `standing` | every entry | one of the labels of §1 but "unplaced" |
| `basis` | every entry | `{en, zh}`, at least one nonempty: why, in the record's words |
| `review` | every entry | a review reference of the record (the check rules below) |
| `law` | derived | nonempty list: the grammar laws the row is a case of, more than one where the row joins several cases (both directions of an iff, say) |
| `bridges` | derived, optional | list: the equivalences translating the row's statement or the law's terms at the model |
| `support` | derived, optional | list: the closed set's other lemmas, which meet the law's hypotheses at the model or are steps inside a bridge's proof |
| `form` | under a stated hypothesis | the root form F |
| `hypotheses` | under a stated hypothesis | nonempty list of `{hypothesis, countermodel, fit}`: the definition, `F.needs_H` and `F.H_needed` (§3.2) |
| `recovery` | under a stated hypothesis | the theorem stating the row, proved through F |
| `certificate` | under a stated hypothesis | the theorem `@Row = @Recovery := rfl`, in either order |
| `bridges` | under a stated hypothesis, optional | list: equivalences the recovery uses besides F |
| `relational_part` | a reading at "balance in its statement", optional | a form of the record stating the row's relational part, which places nothing (row `Flow.no_new_dependence`'s `descent_forms_no_dependence`) |

No other key is allowed, and a key outside its standing is refused. A reading carries only the first four, and `relational_part` where it applies.

**`premises_of_the_ethics`:** exactly two items, one for each premise the ethics rests on: the continuation condition (role `scope`) and C (role `order`), as AGENTS.md asks wherever the ethics is summarized. The list is named for them because "premise" already names COVERAGE's category "premise of the account" and K3's register.

| Key | Content |
|---|---|
| `role` | `scope` or `order`, each once |
| `name` | `{en, zh}`, at least one nonempty |
| `premise` | the definition stating it |
| `not_entailed` | a theorem showing that no statement reading only the dynamics entails it, or `null` |
| `absent` | required when `not_entailed` is `null`: why |
| `basis`, `review` | as for a standing |

- **The condition:** `premise` is `Becoming.Unrestricted`, and `not_entailed` is `Becoming.ReadsOnlyDynamics.not_entails`.
- **C:** `premise` is `Becoming.Comparison` (Extension.lean: "C on a frame says every extension is better"), and `not_entailed` is `null`. No theorem shows that no statement reading only the dynamics entails `Comparison` with "better" free. `Comparison` leaves "better" free as `Unrestricted` leaves `sig` free, so the two items are alike in kind. They differ in that one has its not-entailed theorem and the other does not.

**The check's rules** (boundary.py's `field_findings`, which reads no Lean; registry.py applies them with the review's text, the generator without it):
- The keys are closed at every level, the `boundary` object included. Lists are nonempty where present, and `basis` and `name` take English or Chinese.
- Every name is a full name: it begins with a module root of the package (`Becoming.`, `Generative.`).
- Uniqueness:
  - no declaration appears twice, and no premise role twice;
  - an entry's hypotheses are distinct, and so are its countermodels and its fits;
  - `law`, `bridges` and `support` are pairwise disjoint, and each lists a name once.
- No name an entry gives equals its declaration.
- Every name an entry introduces is among the declarations of the record's own laws, so each has its proof binding and its place in the core. These are `form`, each `hypothesis`, `countermodel` and `fit`, `recovery`, `certificate`, the standing-2 `bridges` and `relational_part`. A derived entry's `law`, `bridges` and `support` belong to the grammar's modules and the models', and need not be.
- `review` is among the record's review references. Its file names in code spans the declaration and every name the entry gives, and for a premise, `premise` and `not_entailed`. A code span names X when it is X, or X without its first component (`Flow.no_new_dependence` for `Becoming.Flow.no_new_dependence`). F5's last-component match is not used, since 30 constants end in `course`.
- Whether the declaration is a central one is the generator's to check (§3.6), not the registry's, so a renamed COVERAGE row never makes the check fail for every lander.

One hypothesis definition may serve several entries; each entry gives its own countermodels and fits.

## 3. Checking (master_laws.py: the checker cache and the Lean check)

In the code, §3.0 to §3.5 and the report are boundary.py's, which master_laws.py calls.

### 3.0 Terms

These are computed from the dump. [boundary/probe.py](boundary/probe.py) is their reference implementation for the design, and the generator's code is among the inputs MV hashes.
- **Generated auxiliaries** are Lean's own constants, matched on the last name component by the probe's pattern (`AUX`), which is normative. It covers:
  - `match_N` with any further `_N` (Lean 4.29.1 names matchers `match_N_M`);
  - `_proof_N`, `proof_N`, `eq_N`, `eq_def`, `_aux_N`;
  - `sizeOf_spec`, `_sizeOf_N`, `_sizeOf_inst`;
  - `inj`, `injEq`, `brecOn`, `below`, `binductionOn`, `casesOn`, `recOn`, `rec`, `elim`, `noConfusion`, `noConfusionType`, `ctorIdx`, `toCtorIdx`, `ctorElim`, `ctorElimType`;
  - `splitter`, `_unsafe_rec`, `_sunfold`, `_flat_ctor`, `_default`.

  They are never laws, bridges or theorems a proof names: every walk goes through them.
- **Reaching** is the closure through types and values, all the way down, definitions and theorems alike. Init is not in the dump, so the closure stops there.
- **A root constant** is a constant of `Becoming.Prelude` or of a `Becoming.Grammar*` module whose closure lies wholly in those modules. A theorem's proof is included, so this is a matter of content.
  - On the current run there are 2,258.
  - 66 constants of those modules are off the root because they are built on a model, such as `ClosedCapture.lockedAlike`.
  - Two of them have root statements and proofs through model theorems: `Law.continues_in_core_iff` and `TwoCourses.core_iff` (GrammarCourse).
- **A grammar law** follows OU's owner's decision (U4 §1.1: "the law sits in the package only … The «» name is the vocabulary, not the standing"), with the content tests U4's name test makes. It is a theorem that:
  - is of a `Becoming.Grammar*` module and is not an auxiliary;
  - is a root constant;
  - has a statement that reaches `«际»` or another «» term;
  - has a statement that reaches no closed value of the run (the dump's `cv`), so that it holds of every relation, not of one constructed net.

  The probe finds 406.
  - **With no «» name.** 15 of them, such as `«类».refl` and `Law.constant_iff_core`.
  - **Left out, though «»-named.** 34 of the 425 «»-named theorems:
    - 13 name a closed value, such as `«两火以薪定理»`;
    - 6 name no «» term: `«非真则假»`, `«非假则真»`, `«是不俱当»`, `«必或不当当且仅当弱排中»`, `«离觉则皆不觉»` and a fact of `Bool`, `«异三则同»`;
    - 15 are declared off the grammar modules: 13 in GW's leaf `MapRegions`, laws of the map that nothing below uses (OU's GW decision), with `«全生成则生成»` (KeepingWidening) and `«及在渐粗列之相续»` (HeldPossible).

    A leaf's «» laws are thus counted, or not, as a whole.
  - **`kept_onward` is not a grammar law.** U4 recorded OU's owner's wording that it "meets the test". By this predicate it does not, because its statement is about `Nat` and a predicate on it and reaches no «» term. It is a law of the steps of time (induction along the successor), proved through the grammar's closure: its proof applies «闭含所闭» and «线则所闭», and the walk below sees those. OU's owner accepted the predicate with this difference on 31 October, and corrects that wording in WHAT-REMAINS. No label changes.
- **A forwarder of a grammar law** is a theorem whose dump `f` names a grammar law or another forwarder, and whose proof names no other theorem of the run.
  - The probe finds 14. Thirteen are through closure's laws, such as `WithinClosure.not_rel` for `«所闭之界»`, and one is `Amounts.fallsStop_of_ends`, through `«尽则不或屡»`. Eight are direct.
  - Only a forwarder of kind `pure` whose binders Y uses is the exact case. One of kind `projection` (`Iff.mp`, `Iff.mpr`, `symm`) states one direction, and is reported as such.
  - The dump's `f` has false negatives. `WithinClosure.mono` applies `«所闭之单调»` to its arguments in order, past the law's «则» conclusion, and is not recognized. So `derived_by_forwarder` can undercount.
- **The theorems a proof names** are found by walking its value through definitions, instances and auxiliaries, stopping at theorems, which are collected.
- **The grammar laws a declaration reaches** are found by the measure's walk: from the declaration through every constant its type and proof use, stopping only at «» names, collecting the grammar laws among them and those forwarded to. A root helper without a «» name is entered. So `Web.Whole.family_excess_ends` reaches `«线则所闭»` and `«闭含所闭»` through `kept_onward`.
- **The balance anchors** are the measure's balance anchors that are not «» names: `Flow.Balances`, `Flow.BalancesOn`, `Flow.BalancesBetween` and the prelude's `balance_over_stretch_on`. The grammar's own balance forms (`«守数当且仅当可对»`, `«程守数当且仅当可对»`) are grammar laws.
- **What the dump does not show:** Init. A proof can do arithmetic of its own with `Nat` and `List` lemmas or `omega`, and the dump shows nothing of it. The pages say "theorems of the run named (Init not shown)" wherever they list them. The Lean check sees Init.

### 3.1 Derived

Let Y₁…Yₖ be the entry's `law`, Br its `bridges` and Su its `support`.
- **D1.** Each Yᵢ is a grammar law.
- **D2. The closed set.** Every theorem named by the row's proof, and by the proof of each lemma of Br and Su, is one of four kinds:
  - a grammar law or a forwarder of one;
  - a root theorem, whose proof the walk enters;
  - a lemma of Br or Su;
  - an auxiliary.

  No lemma of Br or Su is a central declaration. A derivation through another central row places the row by that row's standing, so the record reads it instead; none of the eight needs one.
- **D3.** Each Yᵢ is among the grammar laws D2's walk collects, directly or through a forwarder.
- **D4.** Every lemma of Br and Su is reached in D2's walk as a lemma: none is listed unused. A grammar law or a forwarder of one is collected as a law, so listed as a lemma it is not reached.
- **D5.** No balance anchor is in the row's closure, its statement and its proof all the way down, definitions included. That closure contains every lemma's. A derivation through balance or the prelude's counting law is a distance, and its row keeps the rule's label.
- **D6.** Each lemma of Br is an equivalence: under its binders, an `Iff`, or an `Eq` between propositions, predicates or relations. The Lean check computes this on terms (§3.2, `equivalences`).

**Reported on the page and in the data:**
- the other grammar laws used;
- the root theorems named;
- whether the row is a forwarder of a Yᵢ, and of which kind.

**What this does not show,** and the review reads:
- **That the row's proof applies the Yᵢ as the case, and not as steps among its model's facts.** The names show that a law is used, not how. The checks cannot tell the two apart: declared with their whole closed sets, 28 of the 32 connected rows pass D1–D5. The four that fail are `act_courses_unselected` and the three RegimeMargin rows, by D5. So "derived" rests on the review, and the checks bound it.
- **That each bridge translates without adding a hypothesis the row lacks.**
- **That each support lemma holds at every instance of the model's parameters and adds no hypothesis the row lacks** (U4 §1.1).
- **Arithmetic done in Init.**

So a derived entry reads, on the page, as §5 gives it.

### 3.2 Under a stated hypothesis

This is the strict reading U4's design adopts (DESIGN-BOUNDARY §1.2). F is stated over variable relations, regions and amount functions, and the row is F at its model. The tests run in Lean, in the core run's environment restored from the cache, by [tools/research/boundary_check.lean](../../../../../tools/research/boundary_check.lean). Its module docstring states each exactly. In outline:
1. **The names.** Every declaration named is in the environment and of the right kind. Hypotheses, countermodels and fits are each distinct, and the row, F and the recovery are three.
2. **The hypotheses.**
   - Each is a definition of F's module. Its type and body name only constants the name test admits.
   - Nothing it reaches is an amount: `Nat`, `LE.le`, `LT.lt`, `HAdd.hAdd`, `HSub.hSub`, `HMul.hMul`, seen through the package's definitions, so an amount behind a prelude definition counts.

   The name test admits:
   - a constant of Init (module `Init` or `Init.*`, not `Lean.*` or `Std.*`);
   - one of the prelude;
   - a root constant of a grammar module, by content.

   A «» name declared elsewhere is refused.
3. **F's statement.**
   - It names only admitted constants and its hypotheses.
   - It names `«际»` or another «» term of the root. This excludes only forms free of relations.
   - It reaches no closed value.
   - Every binder that is not a proposition is implicit. Every propositional binder is an application of one listed hypothesis, and each hypothesis is used exactly once. So no hypothesis is written inline.
4. **The countermodel `F.needs_H`.**
   - Its type is defeq, at reducible transparency, to `¬` of F's telescope with H's binder removed.
   - Its proof reaches neither F nor the row.
5. **The fit `F.H_needed`.**
   - Its type is `¬ H w`, at a witness of admitted constants and definitions of F's module that name only admitted constants.
   - Its proof is `fun h => …` and applies F with `h` among F's arguments, so the kernel checks that the facts meet F's other hypotheses and that F's conclusion fails there.
   - Its facts are the package's theorems it names besides F. No fact reaches F or the row, and the countermodel names exactly the same facts.
6. **F's proof** reaches only Init, the prelude, grammar modules and F's own module, and not the row. A lemma of the leaf whose content is on the root, such as `length_zero_of_none`, is allowed.
7. **The certificate.**
   - Its type is `@Row = @Recovery`, in either order.
   - The row is at distinct universe parameters of the certificate, so the recovery states the row at its full generality.
   - The kernel has checked it, so Lean has checked that the recovery states what the row states.
8. **The recovery,** under its leading binders, is F applied.
9. **The discharge condition** (U4 §1.2). The recovery meets F's hypotheses by definitions alone.
   - Its proof uses no theorem but F, the entry's `bridges` and projections. Constructors and `rfl` are not theorems.
   - Each bridge it uses is an equivalence.
   - The bridges are a closed set: each bridge's proof uses only admitted theorems, other bridges and projections, and each bridge is used.

**Two idioms, one set of facts.** `F.needs_H` is the countermodel proper: dropping H, F's conclusion fails. `F.H_needed` is its fit: H fails at the witness, by F. Both name the same facts, and the kernel checks the fit.

**What this does not show,** and the review reads:
- **That the hypotheses are the row's relational content.** A row may carry more than its form needs, and what it carries beyond F's hypotheses does not place it. The basis states what that is.
- **That each bridge adds no hypothesis the row lacks.**
- **That the countermodels show more than non-redundancy in the form.** The root countermodels over `Unit` show only that no hypothesis is redundant in F, which any non-redundant first-order hypothesis has (U4 §1.2). Lever 2's witnesses at the model stay beside them, as evidence that the model does not meet each hypothesis automatically.
- **That a certificate's definitional equality may include evaluation.** So `twice 3 = 6` certifies as `6 = 6` ([boundary/certificate-idiom.lean](boundary/certificate-idiom.lean), `certEval`), and the review reads that the recovery states the row in its own terms.

Where a hypothesis matches a premise of K3's register, the basis names it (U4 §1.2), and K3's witnesses may be cited beside the countermodel.

**On U4's forms** (u4-edge fe2a1942b; [boundary/check/controls-run.log](boundary/check/controls-run.log)):
- **Row 17, `GroupEnding.Flow.all_end`, passes every test.** Its recovery uses no theorem but `outside_leaves_no_offspring`, `And.left` and `And.right`.
- **Row 5, `Flow.no_new_dependence`, fails only the discharge condition.** Its recovery uses `Flow.descends_of_comes`, which is amount reasoning. So the row keeps "balance in its statement", with `descent_forms_no_dependence` as its relational part.
- **The controls.** They are U4's nine, adapted, and twelve more:
  - a fit that names F aside without applying it;
  - a degenerate form naming no «» term;
  - the row declared a bridge, and a bridge not used;
  - a repeated hypothesis;
  - certificates in either order, of another shape and at a specialized universe;
  - a recovery applying F under a `have`;
  - a recovery through a declared closed bridge, and the same recovery with the bridge undeclared;
  - a name not in the environment.

### 3.3 The premises of the ethics

- **Q1.** For an item with both names: `premise` is a definition, and `not_entailed` a theorem whose type names it. The review checks that it states non-entailment by every statement reading only the dynamics, as `ReadsOnlyDynamics.not_entails` does.

Each premise is reported as not entailed (checked, or unverified) or "not shown", with its `absent`. An item whose names fail Q1 is unverified. "Not shown" is not unverified.

**Standing 3 is empty today.** WHAT-REMAINS defines a premise as "stated on the root, with a proof that no statement about the dynamics entails it". Neither premise of the ethics meets both conditions:
- **The condition** has its not-entailed theorem. But 07 §4.5 keeps its free significance off the root, and its root form at the own-closure reading, `«续无外»`, has no not-entailed theorem.
- **C** has its statement, `Comparison`, and no not-entailed theorem.

The name test cannot settle "stated on the root" for either. `Unrestricted` names `Neutral`, which is `∀ i, rule i` declared in Metaethics, and `Comparison` names `Frame` and `Extension`. Whether `sig` or "better" is free is content the names do not show. So the report states only what Q1 checks, and the record's basis states each premise's relation to the root as a reading.

This corrects WHAT-REMAINS in two sentences:
- "The continuation condition and C stand here already (`ReadsOnlyDynamics.not_entails`)" under standing 3;
- "The continuation condition and C are premises, proved not entailed by the dynamics" under "Where the edge stays".

It also corrects U4 §1.3, "The continuation condition stands here". OU's owner and U4's owner are asked to correct them (§8).

A row whose kept hypotheses are the premises is not under a stated hypothesis. `not_entails` is not a countermodel: it shows that no law of the dynamics gives the premise, not that the row needs it. A form keeping `Unrestricted sig` fails test 2, since `Unrestricted` is not admitted. The three significance rows, `unrestricted_iff_livingSignificance`, `Web.widens_iff_retains_adds` and `Web.paths_one_object`, stay at free significance until 07 §1's open root reading exists, as U4 reads them.

### 3.4 Readings

A reading is declared and reviewed. Beside it, the page and the data show:
- the rule's label, where it differs;
- F5's verified items for the row;
- the grammar laws the row reaches;
- where balance enters.

**A reading of a label the rule computes needs the rule's fact.** Without it, the reading is listed as unverified and its row takes the rule's label:

| Label | The fact it needs |
|---|---|
| connected | the row reaches a grammar law |
| balance in its statement | the rule's first test holds |
| at a represented model, own carrier | F5's verified items of that class |

Readings of the other labels are not falsified by MV. "Counting" is one of them: a mechanical test for it would be a name test on rows, which U4's finding 1 shows measures packaging.

A reading equal to the rule's label confirms it, with its basis. U4 has three:
- `Flow.mutuallyDependent_iff_reach`, connected;
- `Flow.withinCoupling_reads_iff`, connected;
- `Flow.no_new_dependence`, balance in its statement, with its relational part.

### 3.5 The rule

This is U4's rule (DESIGN-BOUNDARY §2; boundary_table.py, `standing`). It reads only the statement or facts recorded apart, and its fallback is "unplaced":
1. **Balance in its statement.** The row has `Flow`'s balance in its statement's closure (`Flow.Balances`, `BalancesOn`, `BalancesBetween`), or writes balance out, its own type naming `Dependence.level`, `Flow.taken` and `Flow.given`.
2. **Connected.** The measure has the row reaching the grammar. The grammar laws it reaches are listed.
3. **At a represented model, or own carrier.** A row with an F5 item at `occurrence` or `process` is at a represented model. One whose only items are `own` is own carrier.
4. **Unplaced.** Any other row.

Where only the proof reaches `Flow`'s balance or the prelude's counting law, the row's data says so, and that places nothing.

**On the current run** the rule gives:

| Label | Rows |
|---|---:|
| balance in its statement | 32 (31 by an anchor; `Flow.no_new_dependence` written out) |
| connected | 32 |
| at a represented model | 16 |
| own carrier | 7 |
| unplaced | 31 |

U4's readings place the 31, and move 8 connected rows to derived (U4's table, `rule_would_give`, agrees on every row).

### 3.6 The run, failures and staleness

**The Lean check's run.** When a record carries the field, `master_laws.py` runs the check:
- **Restoring the modules.** It restores the core run's modules from the checker's cache, as THEOREM-CONNECTIVITY.py's dump does, with the same keys and no recompile.
- **The imports.** It writes the check's imports: `Becoming`, the periphery joins, and the module of each standing-2 form.
- **The input.** It passes, for the entries that pass every other check:
  - the standing-2 entries;
  - every derived entry's bridges, as `equivalences`;
  - the derived entries' laws, as `names`, for the name test.
- **The cost.** The run takes about 12 seconds.
- **When it cannot run.** If a module is missing from the cache, or Lean fails, the entries it would check (every derived entry and every entry under a stated hypothesis) are unverified with that reason. With none to check, Lean is not run.

**Failures.** As for F5, the generator never refuses to run.
- An entry that fails a check is written as unverified, with the checks it fails, and its row takes the rule's label. An entry whose declaration is not a central one, or names a constant not in the run, is unverified for that reason.
- An entry the registry would refuse is written the same way: the generator mirrors every rule of §2 except the review's text.
- **With no record carrying the field,** the data has no `boundary` key and no page has a standing line.
- **With two or more records carrying it,** the data holds `boundary: {error, records}`:
  - nothing renders;
  - `counts_at_boundary_record` takes the laws of every carrying record;
  - `current` is false;
  - the four lists below are empty, and the status shows the error instead.

**Status.** The check's `master_laws` status lists:
- `boundary_unverified` and `boundary_premises_unverified`;
- `boundary_unplaced`;
- `boundary_not_matched`: each central declaration whose entry on the record, or its absence, differs from the data's, and a premises list that differs.

**Staleness.**
- `current` is false while `boundary_not_matched` is nonempty.
- A standing's page line shows only while its declaration is matched. A line the rule places from F5's items shows only while each F5 law it cites is matched too.
- The Lean check's source and the restored modules' keys are among the inputs MV hashes.

**U4's landing gate.** U4's landing requires the four lists empty, which U4's review keeps. Premise items "not shown" are not unverified.

## 4. The report

`master-laws.json` gains `boundary` once a record carries the field:
- `record`;
- `counts` for each label of §1, `derived_by_forwarder` with each forwarder's kind, and `groups` (on the edge, below the grammar, distances, unplaced), which sum to the distinct central declarations;
- `against_f5`: each label against F5's four classes, so the report shows how the standings divide F5's 44 / 16 / 7 / 51;
- `premises_of_the_ethics`, each with Q1's result;
- `lean_check`: the toolchain, the module keys' hash, the check's hash, and whether it ran (with the reason where it did not);
- `declared`: the field as the record carried it, which the check compares with the record's field now (§3.6);
- `field_failures`: the rules the field breaks as a whole, where it breaks any; every entry is then unverified;
- `unverified`;
- `rows`: for each central declaration:
  - its label, and how it came (checked entry, reading or rule);
  - the rule's label;
  - the basis;
  - F5's items;
  - the grammar laws it reaches;
  - where balance enters (an anchor in its statement, written out, or only in its proof);
  - the entry's names, with what §3.1 and §3.2 report and any failures.

**The record's own laws are counted apart.** The forms, hypotheses, countermodels, fits, recoveries and certificates are declarations of the boundary record's laws, and they reach the grammar and the rows.
- **Where they go.** Every law of the record carrying `boundary` goes into `counts_at_boundary_record`, not `counts`, as F5's carrying laws go into `counts_at_model`. It holds the master-law dependence of the record's laws. The standings' own counts are `boundary.counts`.
- **A law that also carries `statements_at_model`** goes into `counts_at_boundary_record` only.
- **The effect.** U4's landing then changes no existing count, which a test asserts. F5's `central_reach` is unchanged.

## 5. The pages

**The boundary record's page** gets a generated section listing the central declarations by group and label, headed by a counts line. Each line gives:
- the declaration;
- how it was placed;
- for the edge, the laws, bridges and support, or the form, hypotheses with countermodels and fits, recovery and certificate.

**Every record page whose law names a central declaration** gets one line under that law for each such declaration, once though the law names it twice, as F5's statements at a model get theirs. The master-law note above it is unchanged: it gives the measure's dependence, and the standing line gives the edge. One sentence per standing, naming the declaration, with full names throughout:
- **Derived.** "*Standing of `Learning.goAlike_iff_lumped`:* derived, a case of `«像定后当且仅当同行»` through `Learning.lumped_iff_fixed_image` and `goAlikeUnder_iff_alike`, using also `«同行之逐点»` (declared in [record]; the closed set checked against the Lean, the bridges checked as equivalences; the case read in [review])." Where the walk entered root theorems: "Root theorems its proofs name: … (Init not shown)." With support: ", with the support …" after the bridges.
- **Under a stated hypothesis.** "*Standing of `GroupEnding.Flow.all_end`:* under a stated hypothesis, the root form `F` at its model, with hypotheses `H₁`, `H₂` and `H₃`, each with its countermodel and fit (declared in [record]; checked in Lean: the form, its countermodels, the certificate and the discharge condition; the hypotheses read as the row's relational content in [review])."
- **A reading.** "*Standing of `…`:* amounts, a reading: [basis] ([review])." Where the rule gives the same label: "; the rule gives the same". With a relational part: "; its relational part: `descent_forms_no_dependence`".
- **The rule.** "*Standing of `…`, by the rule:* connected (it reaches `«所闭之传递»` and `«缘在所闭»` among its reasons; not declared a case of one)". The other reasons read "`Flow.BalancesOn` in its statement", "balance written out in its statement", "F5's verified items at the process model", "F5's verified items on its own carrier only" and, for unplaced, "no standing declared, and none of the rule's tests holds".
- **An unverified entry.** "*Standing of `…`, by the rule:* connected (…; the declared standing, derived, is unverified: [failures])".

**The boundary record's section,** "Standings on the edge", follows its laws. Its counts line gives each group with its labels; a line for each premise of the ethics gives its definition and Q1's result; then one line per central declaration under its group. While the data read another version of the field, the section says so and shows nothing else.

**Re-rendering.** When the boundary record changes, `registry.affected_ids` selects every record whose laws name a central declaration, since their standing lines change.

## 6. What the probe found

The probe is [boundary/probe.py](boundary/probe.py), rewritten to this draft's terms, with output [boundary/probe.json](boundary/probe.json).
- **Its run.** It ran on the constants of core run 20261030T152859.871907Z (GW's; main `e332ae87a`), from `measure_grammar.py --save`.
- **Its other inputs.** It took that run's master-laws.json for F5's items, and the Lean check's answers on the closed sets ([boundary/check-equivalences.json](boundary/check-equivalences.json)).

**Figures.**
- **The name test:** no central declaration passes it.
- **Grammar laws:** 406; 14 forwarders, none a central declaration; 2,258 root constants (§3.0).
- **Reach:** all 44 rows reaching the grammar reach a grammar law.
- **Balance:**
  - 31 rows have an anchor in their statements;
  - `Flow.no_new_dependence` writes balance out;
  - so 32 rows are at balance in their statements, 12 of them reaching the grammar.
- **D1–D5 against steps:** declared with its whole closed set as support, a connected row passes D1–D5 in 28 of 32 cases (§3.1).

**U4's eight derived rows.** For each:
- every Y is a grammar law and the closed set reaches it;
- no balance anchor is in the row's closure;
- no lemma is a central declaration;
- the row is not a forwarder.

The closed set splits by the Lean check into bridges (equivalences) and support.

| Row | Law | Bridges | Support |
|---|---|---|---|
| `Flow.beyond_gives_nothing` | `«所闭之界»` | none (`FedFrom` and `FedBy` unfold) | `eq_zero_of_not_pos` |
| `Flow.withinSystem_of_withinInfluence` | `«所闭之单调»` | none | `Flow.shares_of_affectedBy`, `WithinClosure.mono` (the law at Frame's closure, applied past its «则» conclusion) |
| `Law.drawn_iff_not_returns` | `«定后有后则入当且仅当不返»` | `Law.drawn_iff_drawnIn`, `Law.absorbing_iff_closed`, `Law.reaches_iff_orbit`, `Law.returns_iff_reaches`, `Law.returns_iff`, `Branching.law_reach_iff`, `Branching.law_trace_iff` | `Law.reaches_of_orbit`, `Law.orbit_add`, `Law.orbit_shift`, `Law.next_fixed`, `Law.next_total`, `Branching.law_trace_of`, `Branching.units_length` |
| `Law.lossless_iff_returns` | `«有限遍后定后则定前当且仅当皆返»` | `Law.lossless_iff_fixedBefore`, `Law.lossless_iff`, `Law.reaches_iff_orbit`, `Law.returns_iff_reaches`, `Law.returns_iff`, `Branching.law_reach_iff`, `Branching.law_trace_iff` | the same seven |
| `Learning.goAlike_iff_lumped` | `«像定后当且仅当同行»` (it also uses `«同行之逐点»`) | `goAlikeUnder_iff_alike`, `Learning.lumped_iff_fixed_image` | none |
| `Tolerance.answers_restores_iff` | `«承之迭»` (it also uses `«迭之末步»`) | `Withholding.chain_iff_steps`, `Withholding.answers_closed`, `Tolerance.worst_start` | `Tolerance.KeepsInclusion.course`, `Tolerance.KeepsInclusionInto.course`, `Tolerance.answers_keeps`, `Withholding.Chain.last`, `Withholding.Chain.last_of_eq`, `Withholding.Chain.zero_eq` |
| `Withholding.withholding_spreads` | `«存承之迭»` (it also uses `«迭之末步»`) | `Withholding.within_iff_withinSteps`, `Withholding.chain_iff_steps`, `Withholding.waitsAll_closed` | `Withholding.Chain.last`, `Withholding.Chain.last_of_eq`, `Withholding.Chain.zero_eq` |
| `WithinMoves.after_course` | `«迭内之接»` | `trace_iff_steps`, `withinMoves_iff_withinSteps` | `trace_steps` |

**How the table meets U4's.**
- U4's principal bridges are among these bridges, except three, which are implications and so go to support: `eq_zero_of_not_pos` (U4: "one prelude step"), `shares_of_affectedBy` (U4: "an unfolding") and `trace_steps`.
- The review reads each support lemma as U4 §1.1 asks.
- A row whose support includes a model fact that adds a hypothesis the row lacks stays connected.

## 7. Settled with U4's owner and OU's owner

**With U4's owner** (u4-edge a93071609 to fe2a1942b):
- **Derived.** The closed set, now split into `bridges` (equivalences, checked in Lean) and `support` (the review's), with `law` a list. "Derived" and "under a stated hypothesis" are never readings.
- **Standing 2.** The strict reading, with both countermodel idioms on the same facts, keyed `{hypothesis, countermodel, fit}`, and U4's discharge condition. The tests are U4's, run by MV's generalization of U4's check, with four additions:
  - the certificate's row side at full universe generality, in either order;
  - F naming «际» or another «» term, and no closed value;
  - the recovery's head being F, and the fit applying F with its hypothesis;
  - distinct countermodels and fits, and optional bridge equivalences closed under the name test.

  The amounts test now reads a hypothesis's closure through the package's definitions, so an amount behind a prelude definition is caught. U4's §1.5 will say MV runs the check (boundary_check.lean).
- **Rows 5 and 17.** Row 17 (`GroupEnding.Flow.all_end`) reaches standing 2 when the leaf lands. Row 5 (`Flow.no_new_dependence`) is a reading at "balance in its statement", equal to the rule's label, with its relational part. Rows 13 and 14 (`SelectionLevels.rises_exact_iff_levels`, `GroupEnding.Flow.rises_iff_inactive`) stay at amounts: their cancellation constrains amounts.
- **The dump.** Unchanged: the fields `eq` and `x` are not proposed, so the coordinator's yes is not needed. [boundary/certificate-idiom.lean](boundary/certificate-idiom.lean) and its companion stay as the record of what a certificate checks; their `eqField` is superseded by the check's test 7.
- **The counts.** The standings are counted in `boundary.counts`; the record's own laws' dependence in `counts_at_boundary_record`.
- **Premises.** No central declaration is a premise. The record lists the two premises of the ethics apart: the condition with its not-entailed theorem, and C, `Comparison`, with none. Standing 3 is empty today (§3.3).

**With OU's owner** (31 October):
- **The grammar-law predicate** (§3.0) is accepted: OU's location rule with the content tests, `kept_onward` not a grammar law, and the leaf `MapRegions`' «» laws left out as a whole.
- **WHAT-REMAINS' two sentences on standing 3** are wrong, and OU's owner corrects them in its proposal section, marked as a correction, with its bullet on `kept_onward`. U4 §1.3's sentence is U4's owner's to correct.

## 8. Order of work

1. **MV lands the field first,** with one claim on RA's row of the board.
   - **What lands:** this specification; the registry's check; the generator's checks, rule and report; the Lean check and its runner; `counts_at_boundary_record`; the page lines; a RESULT-WORKFLOW paragraph; and the tests below.
   - **Reviews:** the code gets an independent review and a re-check.
   - **Figures:** no record carries the field, so no figure changes, which a test asserts.
2. **U4 builds the leaf and the record.**
   - **The leaf** is a core leaf, as `SignificanceStatements` is. It holds:
     - row 17's form with its hypotheses, countermodels, fits, facts and witnesses, its recovery and its certificate;
     - row 5's relational part;
     - any juncture law the leaf's design admits.
   - **The record** carries the field, with the eight derived rows' laws, bridges and support as §6 lists them, and the three readings equal to the rule.
   - **The landing** reruns `master_laws.py` and requires none unverified, unplaced or not matched. It lands after GW's landing, by OU's order.
3. **OU's owner** brings WHAT-REMAINS and 08 §7's account of the edge to MV's report. The corrections of §3.3 land after RR's landed clause.

**RESULT-WORKFLOW** gains a paragraph. `law`, `bridges`, `support` and a standing-2 entry's names declare a correspondence: the row is a case of these laws through these lemmas, or an instance of this form. F5's `of` does the same. They record nothing about which master laws a row rests on, which stays computed.

**The tests** ([tools/research/tests/test_boundary.py](../../../../../tools/research/tests/test_boundary.py), 45). The registry and generator tests run against constants made for the case and a stubbed Lean-check output; the pages through the real render.
- **Registry.**
  - the field on a schema-1, superseded, withdrawn or second record;
  - unknown keys at every level, the `boundary` object included;
  - each standing's required and forbidden keys, and `relational_part` outside a balance reading;
  - a name that is not full, or equals the declaration;
  - empty lists;
  - duplicate declarations, roles, hypotheses, countermodels and fits;
  - `bridges` meeting `support`;
  - premises other than one `scope` and one `order`;
  - `absent` missing beside a `null`;
  - a review that is not a review reference, or does not name each name (by full name, or without the root);
  - an introduced name outside the record's law declarations;
  - one hypothesis definition shared by two entries.
- **Generator.**
  - **The checks:** a passing and a failing case for each of D1–D6 and Q1, including:
    - a row with `Flow`'s balance declared derived, which must come out unverified (`act_courses_unselected`'s shape);
    - a lemma that is a central declaration;
    - `law` with two laws;
  - **The terms:** a pure forwarder row and a projection; the predicate of §3.0 on a helper, a witness theorem, a `Bool` fact, an auxiliary, a grammar-module constant built on a model, a root-statement theorem proved off the root, and a «» law declared in a leaf;
  - **The walks:** through a definition holding a theorem; reach through a root helper;
  - **The rule:** every branch, written-out balance and unplaced included;
  - **Precedence:** an entry or a reading over the rule; a failing entry falling to the rule, not to a reading; a reading of a computed label without its fact;
  - **The Lean check:** a standing-2 entry whose check fails, and the check not running;
  - **Robustness:** a declaration that is not central or not in the run, and malformed entries never crashing;
  - **The report:** counts and groups summing to the distinct declarations; `against_f5`; `derived_by_forwarder`; where balance enters; `counts` unchanged by the boundary record's laws, and a law with both fields counted once.
- **Pages.**
  - one line per central declaration under a law naming several, and under laws in several records;
  - each standing's sentence;
  - the boundary record's section with its counts line;
  - lines hidden when not matched, or when an F5 law they cite is not matched;
  - pages byte-identical when no record carries the field;
  - `affected_ids` after a change to the boundary record.
- **Status.** The four lists and `current`; premise items "not shown" kept out of the unverified list; the error when two records carry the field.
- **The Lean check.** A test compiles stub modules (a prelude, a grammar, a model and a leaf) from strings in a temporary folder and runs the check once on a form passing every test, a recovery through a model fact (the discharge condition fails), a hypothesis with an amount behind a prelude definition, a certificate not in the environment, the name test and the equivalence test; about ten seconds. It is skipped when the toolchain is absent. The run against U4's build stays as evidence ([boundary/check/run_controls.py](boundary/check/run_controls.py)).
- **End to end.** On GW's run (core 20261030T152859.871907Z), the report with a synthetic carrier of U4's eight derived rows, three readings, `act_courses_unselected` declared derived and the two premises, the real Lean check run (16.5 seconds): the eight verify; `act_courses_unselected` fails D2, D3 and D5; the condition is not entailed and C not shown; the counts are 8 derived, 24 connected, 32 at balance in its statement, 16 at a represented model, 7 on their own carrier and 31 unplaced.

## 9. Findings taken

**Draft 1's review: 49 findings, all taken in draft 2.** It had three lenses: Lean (BF-L1 to BF-L14), the edge's meaning (E1 to E16) and the tooling (BF-S1 to BF-S6, BF-M1 to BF-M8 and BF-T1 to BF-T5). Draft 2's table of them is in its commit (136500d72). The re-check found eleven of them only partly taken: BF-L2, L3, L4, L9 and L14, E1, E8 and E10, and BF-T1, T3 and T5. Each is completed by the findings below, as the table's last row says.

**Draft 2's re-check: 49 findings, all taken here.** It had the same three lenses (R2-LEAN-1 to 9, R2-EDGE-1 to 15, R2-TOOLING-1 to 15) and a completeness critic (R2-CRITIC-1 to 10).

| Findings | What draft 2 had wrong | Where taken |
|---|---|---|
| R2-LEAN-1, R2-EDGE-1, R2-TOOLING-1, R2-TOOLING-4, R2-CRITIC-4 | it followed U4 at 2cc1bac0b; S0 and S2 refused U4's forms over «际»; its keys and countermodel idiom were not U4's | status line; §2 `{hypothesis, countermodel, fit}`; §3.2 tests 2–5 in Lean; §7 |
| R2-LEAN-3, R2-EDGE-2, R2-TOOLING-2 | amounts invisible; an inline hypothesis unseen | §3.2 tests 2 and 3, in Lean with Init visible, through the hypothesis's closure |
| R2-LEAN-2, R2-EDGE-5, R2-TOOLING-3 | D5 blind to `Flow`'s anchors, which are definitions | §3.1 D5 on the row's whole closure; `act_courses_unselected` and the RegimeMargin rows fail it (§6) |
| R2-LEAN-4, R2-EDGE-3, R2-TOOLING-6 | S3 checked a countermodel by names, against U4's idiom; one countermodel could serve two hypotheses | §3.2 tests 4 and 5: `needs_H` defeq to the telescope with H dropped, the fit applying F to its hypothesis, witnesses name-tested; distinct countermodels and fits (§2) |
| R2-LEAN-5, R2-EDGE-4, R2-TOOLING-8 | root constants by location; "reaches" undefined | §3.0: reaching as the closure; root constants by content (two GrammarCourse theorems leave); §3.2 test 6 admits leaf lemmas on the root |
| R2-LEAN-7, R2-EDGE-7, R2-CRITIC-1 | a recovery could name F idly, or meet hypotheses by amount reasoning | §3.2 tests 8 and 9 (the head; the discharge condition); row 5 fails it; the review's list |
| R2-LEAN-6, R2-EDGE-13 | `mono` called reordered; forwarders called exact | §3.0 forwarders; §6's table |
| R2-LEAN-8, R2-TOOLING-7 | Q2 judged the premise by its packaging | §3.3: Q2 dropped, the relation to the root a reading |
| R2-LEAN-9 | the certificate's order | §3.2 test 7: either order |
| R2-EDGE-6 | bridges were the whole closed set, mostly not equivalences; the checks pass steps rows | §2 `bridges` and `support`; §3.1 D6 and what it does not show (28 of 32) |
| R2-EDGE-8, R2-CRITIC-7 | the predicate departed from OU's decision; figures before GW | §3.0: OU's location rule with content tests, 406 on GW's run, the leaf counted as a whole; `kept_onward` not a law, accepted by OU's owner (§7) |
| R2-EDGE-9 | C said to have no statement | §2: `premise` `Comparison`, `not_entailed` null |
| R2-EDGE-10 | the correction covered C only | §3.3: standing 3 empty; both WHAT-REMAINS sentences and U4 §1.3 |
| R2-EDGE-11 | readings of computed labels unchecked | §1 table; §3.4 |
| R2-EDGE-12 | three glosses | §1, U4's senses; the witnesses' sentence dropped |
| R2-EDGE-14 | a form about a constructed net passed | §3.2 test 3: no closed value |
| R2-EDGE-15, R2-TOOLING-10, R2-CRITIC-10 | small inaccuracies | 11 and 105 as U4's (§0); `«迭之末步»` for both rows (§6); two connected readings (§3.4); one group name; the sentences repaired; `«同行之逐点»` in §5's example |
| R2-TOOLING-5 | the no-record case contradicted itself | §3.6 |
| R2-TOOLING-9 | "all through closure's laws" | §3.0: 13 and `fallsStop_of_ends` |
| R2-TOOLING-11 | auxiliaries as a list | §3.0: the probe's pattern, normative, with `ctorElim`, `ctorElimType` and `splitter` |
| R2-TOOLING-12, BF-T3 | short names; last-component review match | §2: full names; the review's match |
| R2-TOOLING-13 | precedence between an entry and a reading | §1 precedence |
| R2-TOOLING-14 | the row's own proof applying F changed counts | dropped: `recovery` and `certificate` required (§2) |
| R2-TOOLING-15 | `eqg`'s shape, counts overlap, page sentences, `affected_ids` | no dump field (§7); §4; §5 |
| R2-CRITIC-2 | rule 1 missed balance written out | §3.5 rule 1; 32/32/16/7/31 |
| R2-CRITIC-3 | the reach walk stopped at root helpers | §3.0: the measure's walk; 44 of 44 |
| R2-CRITIC-5 | no place for a reading equal to the rule, or a relational part | §2; §3.4 |
| R2-CRITIC-6 | rows cited by number from two tables | names throughout |
| R2-CRITIC-8 | one law per entry | §2 `law` a list; D1, D3 |
| R2-CRITIC-9 | untested behaviours | §8's tests |
| draft 1's partly-taken BF-L2, L3, L4, L9, L14, E1, E8, E10, BF-T1, T5 | carried into the findings above | BF-L2 and E1 by R2-EDGE-6/7 and tests 4–5; BF-L3 by test 3; BF-L4 and E8 by tests 2–3; BF-L9 by D5 (the prelude's `le_over_stretch` and `ge_over_stretch` are root theorems listed on a derived row's line); BF-L14 by R2-LEAN-6; E10 by §3.4's reason; BF-T1 by the closed `boundary` object and D2's central-lemma rule; BF-T5 by the probe's rewrite |
