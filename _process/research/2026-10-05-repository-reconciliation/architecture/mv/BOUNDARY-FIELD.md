# The boundary field: each central declaration's standing, declared on U4's record and checked against the Lean

**Status:** draft 3, implemented (§8 step 1), its code reviewed by four lenses and its fixes re-checked four times, every confirmed finding taken (§9; the third and fourth re-checks' as MV's follow-up after the field landed): the rules in [tools/research/boundary.py](../../../../../tools/research/boundary.py), applied by the check (registry.py) and the generator (master_laws.py); the Lean check in [tools/research/boundary_check.lean](../../../../../tools/research/boundary_check.lean); the tests in [tools/research/tests/test_boundary.py](../../../../../tools/research/tests/test_boundary.py). This is MV's part of U4's boundary record ([WHAT-REMAINS](../../../2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), "One root to its edge" and "OU's decisions on U4").
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
| `absent` | required when, and allowed only when, `not_entailed` is `null`: why |
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
- **Generated auxiliaries** are Lean's own constants. boundary.py's rule (`AUX`), which is normative, takes a name for one when its last component (the components split at the dots outside «») is one Lean gives an auxiliary of a declaration of the kind before it:
  - of a definition, an opaque, a theorem or an inductive type: the lifted proofs `_proof_N` and `proof_N`, with any further `_N` (Lean 4.29.1 names the proofs it lifts out of a theorem `_proof_N_M`, and puts the proof it lifts out of a structure's or a class's default, or a constructor's optional argument, under the inductive type: `Cfg._proof_1`);
  - of a definition, an opaque or a theorem: `match_N`, with any further `_N` (Lean names matchers `match_N_M`);
  - of a definition or an opaque: `_unsafe_rec` (a partial definition is an opaque);
  - of a definition: `eq_N`, `eq_def`, `splitter`, `_sunfold`, `_aux_N`, `_default`, and `_arg_pusher`, the theorem Lean makes for the equation lemmas of a definition by well-founded recursion of two arguments, or of mutual ones, under the `casesOn` or the matcher it pushes arguments into (`_private.M.0.PSigma.casesOn._arg_pusher`); and the names Lean realizes for a definition on use, in the module that uses them: its unfolding lemma `eq_unfold`, its functional induction and cases (`induct`, `induct_unfolding`, `mutual_induct`, `mutual_induct_unfolding`, `fun_cases`, `fun_cases_unfolding`) and a matcher's congruence equations (`congr_eq_N`);
  - of a constructor: `inj`, `injEq`, `sizeOf_spec`, `elim`, `_flat_ctor`, `noConfusion`;
  - of an inductive type: `noConfusion`, `noConfusionType`, `rec`, `recOn`, `casesOn`, `brecOn`, `below`, `binductionOn`, `ctorIdx`, `toCtorIdx`, `ofNat_ctorIdx`, `ctorElim`, `ctorElimType`, `_sizeOf_N`, `_sizeOf_inst` (4.29.1 makes no `binductionOn`, which the rule keeps); and a nested inductive type's `_sizeOf_N_eq`, `brecOn_N`, `below_N` and `rec_N` (`Nest._sizeOf_2_eq`, which the termination proof of a definition by well-founded recursion over the type reaches).

  The kinds are the dump's `k`, an opaque apart from a definition. An auxiliary's own constants are generated too: an auxiliary of an auxiliary (`match_1.eq_1`), the constructors of a generated `below` family (`«同族».below.refl`), and the `go` and `eq` of a generated `brecOn` or `brecOn_N` that is a definition (a Prop inductive's `brecOn` is a theorem, with neither). A private name the dump lacks is read by its user name, since Lean makes an equation lemma or a matcher of another module's declaration private to the module that needs it (`_private.Becoming.Restoration.0.Becoming.LateMet.web.match_1.eq_1`). A hygienic name, which a macro's declaration has, is read without its macro scopes, and the name before it with them (`aux._proof_1._@.M._hyg.3` under `aux._@.M._hyg.3`). Lean puts the equation lemmas of a definition a macro makes after the macro scopes (`halve.«_@».M._hyg.3.eq_def`); such a name has no macro scopes by Lean's test, so the dump writes it escaped, and the name before it, which has them, unescaped (`halve._@.M._hyg.3`), as which it is read.

  They are never laws, bridges or theorems a proof names: every walk goes through them, the Lean check's included (§3.2 test 9), except that test 9 collects another declaration's lifted proof that the recovery names itself. The Lean check holds its own copy of the rule, read on the environment's kinds; this one reads the dump's.
  - **Kinds the dump lacks** (the third re-check's RC3-RULES-1). The dump leaves out Init, but Lean realizes an equation lemma of an Init definition in the package module that unfolds it (`Nat.fold.eq_def`), and an `_arg_pusher` under Init's `PSigma.casesOn`. For these theorems, the ones `outside` lists, the generator sends the names to the Lean check, whose `kinds` give the kind of each name before them, and D1–D5 read those kinds. The measure's facts (grammar laws, forwarders, reaching) stay the dump's. Without the Lean check, such a theorem counts as one the proof names, so D2 fails closed, and the entry says that the check did not run. A hygienic name with its macro scopes last is not listed, since `String.toName` cannot read it. The stub test runs THEOREM-CONNECTIVITY-DUMP.lean on the stub modules and holds the two copies together on the dump's kinds, with D2 through `Nat.fold.eq_def`.
  - **After the macro scopes, nested types and functional induction** (the fourth re-check's R4-1 and R4-2). Until then boundary.py read the name before `halve.«_@».M._hyg.3.eq_1` with its escape, found no such constant and refused the lemma, which the Lean check's copy, reading the name's structure, took for generated; and neither copy had a nested type's auxiliaries or the names Lean realizes on use, so a recovery through `count.eq_1` of a definition over a nested type failed test 9, and a row through it or through `fun_induction` failed D2. Both failed closed. On the current dump none of these shapes occurs, so no figure, walk or reach changes.
  - **By kind** (the third re-check's RECHECK3-LEAN-1 to 4). Until then the rule took an opaque for a definition, so it walked through a theorem written by hand as `op.eq_1` under an opaque, to which Lean gives no equation lemma, and through `go` or `eq` under a Prop inductive's `brecOn`. It left out a lifted proof under an inductive type, `_arg_pusher`, and a hygienic name's lifted proof, so correct forms failed test 9 and D2. On the current dump none of these shapes occurs (it has no opaque, no hygienic name, no `_arg_pusher`, no Init auxiliary realized in a package module and no lifted proof under an inductive type), so no figure, walk or reach changes.
  - **By attachment, not by name** (the second re-check's WALK2-1). Until then the pattern matched the name alone, on any component after the first. So a theorem written by hand under a name Lean also uses, such as `next.inj` on a definition `next` or `comm.elim` on a theorem, was walked through, and where its proof used Init alone it hid a model fact from test 9 and from D2. On GW's run the rule takes every name the pattern took but two, `OneStep.Chain.below` and `RegimeMargin.below`, definitions written by hand, and no figure, walk or reach changes.
  - **What attachment does not tell apart:** a declaration written by hand under the exact name Lean gives an auxiliary of a declaration of that kind, where Lean made none, such as a theorem `f._proof_7` under a definition `f`. Lean accepts it, though it refuses the equation lemmas' names (`f.eq_1`, `f.eq_def`), which it reserves for a definition. Under an opaque it accepts them, and the rule refuses them there. Declaration ranges do not settle the rest: Lean gives some of its own auxiliaries a range (`casesOn`, `rec`, `elim`, `ctorElim`), and the dump records none. The review reads a model's source for such names.
  - **Defaults the rule leaves out** (RECHECK3-LEAN-5). Lean also gives `_default` to a Prop field's projection (a theorem) and to an overridden field (no declaration), and makes `_inherited_default` and `_autoParam`. No elaborated term names them, since the structure-instance elaborator inlines defaults, so the rule leaves them out, and a proof naming one would fail closed.
  - **`ofNat_ctorIdx`** is the theorem Lean generates for an enumeration's derived `DecidableEq`. The re-check of the code review's fixes found it missing. On GW's run there are 16, and adding them changes no figure, walk or reach.
  - **Inner components.** The probe matched the last component of the name alone, and so missed an auxiliary's own constants: on GW's run 97 names (69 constructors, 14 theorems and 14 definitions), and no figure, walk or reach changes.
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
- **The theorems a proof names** are found by walking its value through definitions, instances and generated auxiliaries, stopping at theorems, which are collected.
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
   - It, or a hypothesis it applies, names `«际»` or another «» term of the root. This excludes only forms free of relations.
   - It reaches no closed value.
   - Every binder that is not a proposition is implicit. Every propositional binder is an application of one listed hypothesis, and each hypothesis is used exactly once. So no hypothesis is written inline.
4. **The countermodel `F.needs_H`.**
   - Its type is defeq, at reducible transparency, to `¬` of F's telescope with H's binder removed.
   - Its proof reaches neither F nor the row.
5. **The fit `F.H_needed`.**
   - Its type is `¬ H w`, at a witness of admitted constants and definitions of F's module that name only admitted constants.
   - Its proof is `fun h => …` and applies F with `h` among F's arguments, so the kernel checks that the facts meet F's other hypotheses and that F's conclusion fails there.
   - Its facts are the package's proofs it uses besides F, found as in test 9, so from its proof alone and not from `¬ H w`. No fact reaches F or the row, and the countermodel uses exactly the same facts.
6. **F's proof** reaches only Init, the prelude, grammar modules and F's own module, and not the row. A lemma of the leaf whose content is on the root, such as `length_zero_of_none`, is allowed.
7. **The certificate.**
   - Its type is `@Row = @Recovery`, in either order.
   - The row is at distinct universe parameters of the certificate, so the recovery states the row at its full generality.
   - The kernel has checked it, so Lean has checked that the recovery states what the row states.
8. **The recovery,** under its leading binders, is F applied.
9. **The discharge condition** (U4 §1.2). The recovery meets F's hypotheses by definitions alone.
   - Its proof uses no proof but F, the entry's `bridges` and projections. A proof is a theorem, or a definition of the package whose type is a proposition.
   - The proofs it uses are those its proof and its own auxiliaries name at term positions, and the package's proofs inside every definition of the package they reach, all the way down. So a fact held in a definition, or carried by a model's data (`⟨f, f_rel⟩ : {f // …}`), counts.
   - A term position is outside a binder's type and a `∀`, which are types: no proof inside a definition named only there can flow into the proof.
   - An auxiliary Lean generated (§3.0, by attachment) is walked through, and collected only as the next bullet says. Lean makes one of a termination proof, a `decide`, a derived instance's proof, a structure's or a class's default, or an `rfl` in a model's data (`_proof_N`). A package proof inside it is still collected, so a fact Lean lifts out of a model's data into its `_proof_1` counts.
   - Another declaration's lifted proof that the recovery names itself is collected, being a fact the recovery uses: `three._proof_1 : 2 < 3`, or Init's `Fin.add._proof_3` (the second re-check's WALK2-2). Lean reuses a lifted proof across the declarations of a module that prove the same statement, so the fact collected can come from another declaration's source. An equation lemma it names, such as `half.eq_def`, `ack.eq_1` of a definition of two arguments, or `count.eq_1` of a definition over a nested type, is walked through, being the unfolding of a definition.
   - Constructors and `rfl` are not proofs, and `Init`'s proofs inside a definition are not counted.
   - Each bridge it uses is an equivalence.
   - The bridges are a closed set: each bridge's proof uses only admitted theorems, other bridges and projections, and each bridge is used.

**Two idioms, one set of facts.** `F.needs_H` is the countermodel proper: dropping H, F's conclusion fails. `F.H_needed` is its fit: H fails at the witness, by F. Both name the same facts, and the kernel checks the fit.

**What this does not show,** and the review reads:
- **That the hypotheses are the row's relational content.** A row may carry more than its form needs, and what it carries beyond F's hypotheses does not place it. The basis states what that is.
- **That each bridge adds no hypothesis the row lacks.**
- **That the countermodels show more than non-redundancy in the form.** The root countermodels over `Unit` show only that no hypothesis is redundant in F, which any non-redundant first-order hypothesis has (U4 §1.2). Lever 2's witnesses at the model stay beside them, as evidence that the model does not meet each hypothesis automatically.
- **An `Init` proof carried by a model's data.** A datum `⟨f, by omega⟩` whose proof the recovery projects meets a hypothesis by `Init`'s arithmetic, and test 9 does not count it. Lean makes that proof the same `_proof_N` it makes of a termination proof, and the check cannot tell the two apart by name or kind. The review reads the recovery for it.
- **A declaration written by hand under a name Lean gives its auxiliaries,** where Lean made none (§3.0). The walk goes through it, so its proof counts only for the package proofs it names.
- **Recoveries refused though made by definitions alone.** Every other proof counts, so a recovery fails where a definition it reaches holds a package proof that carries no fact into it: a package lemma in a termination proof (`decreasing_by exact Model.div2_lt n h`), a package instance of a class of propositions passed to a model definition, or a root proof inside a root definition (test 9, unlike the bridges' closed set, admits no root theorem). The check fails closed, and the review reads such a refusal. The controls cover a termination proof by `omega` only (the second re-check's WALK2-3).
- **That a certificate's definitional equality may include evaluation.** So `twice 3 = 6` certifies as `6 = 6` ([boundary/certificate-idiom.lean](boundary/certificate-idiom.lean), `certEval`), and the review reads that the recovery states the row in its own terms.

Where a hypothesis matches a premise of K3's register, the basis names it (U4 §1.2), and K3's witnesses may be cited beside the countermodel.

**On U4's forms** (u4-edge fe2a1942b; [boundary/check/controls-run.log](boundary/check/controls-run.log)):
- **Row 17, `GroupEnding.Flow.all_end`, passes every test.** Its recovery uses no theorem but `outside_leaves_no_offspring`, `And.left` and `And.right`. On 31 October the controls were rerun four times, with the same output each time: after test 9's walk was carried into the package's definitions (the code review's LEAN-1), after it read term positions only and walked through generated auxiliaries (its re-check), after generated auxiliaries were told by attachment (the second re-check), and after attachment read an opaque, a lifted proof under an inductive type, `_arg_pusher` and macro scopes (the third).
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

A reading is declared and reviewed. Beside it, the data shows:
- the rule's label;
- F5's verified items for the row;
- the grammar laws the row reaches;
- where balance enters.

The page shows the rule's label where it differs, with its reason (§5).

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
- **The imports.** It writes the check's imports: `Becoming`, the periphery joins, and the module of every name it sends (each entry's declaration and names).
- **The input.** It passes, for the entries that pass the field's rules (§2) and the generator's checks before Lean (a central declaration, in the run, a reading's fact), before D1 to D5 (the third re-check's order):
  - the standing-2 entries;
  - every derived entry's bridges, as `equivalences`;
  - the derived entries' laws, as `names`, for the name test;
  - with any derived entry, the theorems `outside` lists, as `generated`, whose `kinds` D1 to D5 read (§3.0).
- **The cost.** The run takes about 12 seconds.
- **When it cannot run.** If the checker cannot be set up (its Lean binary or module index missing), a module is missing from the cache, or Lean fails, the entries it would check are unverified. An entry under a stated hypothesis, and a derived entry passing D1 to D5, carry that reason. A derived entry failing D1 to D5 carries those failures, and, where D2 refuses a theorem `outside` lists, that the check, which gives the kind before it, did not run, with the reason. With no entry to send, Lean is not run.

**Failures.** As for F5, the generator never refuses to run.
- An entry that fails a check is written as unverified, with the checks it fails, and its row takes the rule's label. An entry whose declaration is not a central one, or names a constant not in the run, is unverified for that reason.
- An entry the registry would refuse is written the same way: the generator mirrors every rule of §2 except the review's text. An item of `standings` or `premises_of_the_ethics` that is not an object is unverified by its place in the record (`standing 2`, `premise 1`).
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
  - **A change around the field.** This is a change to what the rules read besides the field: the record's schema, status, review references or laws' declarations, or the field's own keys. Then "the field" comes first, followed by every declaration the field names in either version, since any of its verdicts may differ, and then `premises_of_the_ethics`, since Q1's verdicts may differ too.
  - **The rows outside the field.** The rule's lines for rows the field names in neither version stay, since they read only the statement and F5's items.

**Staleness.**
- `current` is false while `boundary_not_matched` is nonempty.
- A standing's page line shows only while its declaration is matched.
- A line whose label, or the rule's label beside a reading, the rule draws from F5's items shows only while each F5 law it cites is matched too.
- While the data has not read the field a record carries (it has no report, or a report of another record), that record's section says so and shows nothing else. It does the same, naming the cause, after a change around the field.
- A record whose field the data read, and which carries it no longer, has no section.
- The Lean check's source and the restored modules' keys are among the inputs MV hashes.

**U4's landing gate.** U4's landing requires the four lists empty, which U4's review keeps. Premise items "not shown" are not unverified.

## 4. The report

`master-laws.json` gains `boundary` once a record carries the field:
- `record`;
- `counts` for each label of §1, `derived_by_forwarder` with each forwarder's kind, and `groups` (on the edge, below the grammar, distances, unplaced), which sum to the distinct central declarations;
- `against_f5`: each label against F5's four classes, zeros included, so the report shows how the standings divide F5's 44 / 16 / 7 / 51;
- `premises_of_the_ethics`, each with its place in the record (`item`) and Q1's result;
- `lean_check`: the toolchain, the module keys' hash, the check's hash, and whether it ran (with the reason where it did not); with nothing to check, or a checker that cannot be set up, only that it did not run and why;
- `declared`: the field as the record carried it, which the check compares with the record's field now (§3.6);
- `context`: what the rules read of the record besides the field (its schema, status, review references and laws' declarations), compared in the same way;
- `field_failures`: the rules the field breaks as a whole, where it breaks any; every entry is then unverified;
- `unverified`: each entry that fails, with its place in the record (`item`), its declaration and standing, and its failures;
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
- **A reading.** "*Standing of `…`:* amounts, a reading: [basis] ([review])." Where the rule gives the same label: "; the rule gives the same". Where it gives another, its label and its reason, as below (§3.4): "; the rule gives connected (it reaches `«所闭之传递»` among its reasons; not declared a case of one)", or "; the rule gives unplaced (none of the rule's tests holds)". With a relational part: "; its relational part: `descent_forms_no_dependence`".
- **The rule.** "*Standing of `…`, by the rule:* connected (it reaches `«所闭之传递»` and `«缘在所闭»` among its reasons; not declared a case of one)". The other reasons read "`Flow.BalancesOn` in its statement", "balance written out in its statement", "F5's verified items at the process model", "F5's verified items on its own carrier only" and, for unplaced, "no standing declared, and none of the rule's tests holds".
- **An unverified entry.** "*Standing of `…`, by the rule:* connected (it reaches … among its reasons; not verified as a case of one; the declared standing, derived, is unverified: [failures])". For unplaced the reason reads "no standing verified, and none of the rule's tests holds".

**The boundary record's section,** "Standings on the edge", follows its laws. Its counts line gives each group with its labels; a line for each premise of the ethics gives its definition and Q1's result; then one line per central declaration under its group, a reading's line with the rule's label ("a reading; the rule gives the same", or "gives unplaced"). While the data read another version of the field, or none, the section says so and shows nothing else. After a change around the field (§3.6) it says that the record around the field changed. A premise's `absent` of another shape is left out of its line.

**Re-rendering.** When the boundary record changes, `registry.affected_ids` selects every record whose laws name a central declaration, since their standing lines change; so it does when the record the data read is deleted. When the data changes, it selects the boundary record with every record that has laws. When an F5 carrier changes, it selects the records whose laws name a row the rule places from that carrier's items.

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
   - **What lands:**
     - this specification;
     - the registry's check;
     - the generator's checks, rule and report;
     - the Lean check and its runner;
     - `counts_at_boundary_record`;
     - the page lines;
     - a RESULT-WORKFLOW paragraph;
     - the tests below;
     - `master-laws.json` regenerated (`python3 -B tools/research/master_laws.py`), since the generator and the code it hashes changed.
   - **Reviews:** the code gets an independent review and four re-checks. The review of 36d4b0fae, the re-checks of its fixes, and what each changed are in §9. The third's and the fourth's findings land after the field, as MV's follow-up.
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

**The tests** ([tools/research/tests/test_boundary.py](../../../../../tools/research/tests/test_boundary.py), 61). The registry and generator tests run against constants made for the case and a stubbed Lean-check output; the pages through the real render.
- **Registry.**
  - the field on a schema-1, superseded, withdrawn or second record;
  - unknown keys at every level, the `boundary` object included;
  - each standing's required and forbidden keys, and `relational_part` outside a balance reading;
  - a name that is not full, or equals the declaration;
  - empty lists;
  - duplicate declarations, roles, hypotheses, countermodels and fits;
  - `bridges` meeting `support`;
  - premises other than one `scope` and one `order`;
  - `absent` missing beside a `null`, or present beside a theorem;
  - a review that is not a review reference, or does not name each name (by full name, or without the root), for every kind of name;
  - names, a status or references of another shape, refused and never a crash;
  - an introduced name outside the record's law declarations, for every kind of introduced name;
  - one hypothesis definition shared by two entries;
  - the field through `registry.validate`: on a schema-1 record, on a schema-2 record with the review's text, and on two records.
- **Generator.**
  - **The checks:** a passing and a failing case for each of D1–D6 and Q1, including:
    - a row with `Flow`'s balance declared derived, which must come out unverified (`act_courses_unselected`'s shape);
    - a lemma that is a central declaration;
    - `law` with two laws;
  - **The terms:** a pure forwarder row, a projection, a forwarder of a forwarder and a theorem that is not one; the predicate of §3.0 on a helper, a witness theorem, a `Bool` fact, an auxiliary by attachment (an auxiliary's own constants, a private copy, a lifted proof under an inductive type, an opaque's, `_arg_pusher`, a hygienic name, one after the macro scopes, a nested type's and functional induction's included; not a name written by hand under one Lean uses, an opaque's equation lemma or a Prop `brecOn`'s `go`; and an Init owner's kind only as supplied, never over the dump's), the theorems `outside` lists, a grammar-module constant built on a model, a root-statement theorem proved off the root, and a «» law declared in a leaf; the grammar's balance form, a law and not an anchor;
  - **The walks:** through a definition holding a theorem and through auxiliaries, and not through a theorem written by hand under an auxiliary's name, which D2 refuses; reach through a root helper, stopping at a «» name; a law reached through a forwarder (D3), and a forwarder or a law listed as a lemma (D4);
  - **The rule:** every branch, written-out balance and unplaced included;
  - **Precedence:** an entry or a reading over the rule; a failing entry falling to the rule, not to a reading; a reading of a computed label without its fact;
  - **The Lean check:** a standing-2 entry whose check fails, gives no result or does not pass; output of another shape, a row not a string and kinds not an object included; an admission or an equivalence given as something other than true; the check not running, or its checker not set up; the module of every name sent; an entry breaking the field's rules kept out of the query, and one failing D2 sent, since the check runs before D1–D5; the names `outside` lists sent with a derived entry only; D2 through Init's equation lemma with the check's kinds, and failing closed without them, with a wrong kind or with malformed kinds, saying when the check did not run; a reason with no local path;
  - **Robustness:** a declaration that is not central or not in the run, an item that is not an object listed unverified by its place, and malformed entries never crashing;
  - **The report:** counts and groups summing to the distinct declarations; `against_f5` with every label; `derived_by_forwarder`; where balance enters; the generator's three tables (`law_entries`), the boundary record's laws apart with one carrier or two, and a law with both fields counted once; the data's `boundary` with one carrier, two or none (`boundary_data`); the boundary field's code and Lean check among the hashed inputs.
- **Pages.**
  - one line per central declaration under a law naming several, and under laws in several records;
  - each standing's sentence, the readings beside a rule that differs, the unverified entries, a forwarder row, two hypotheses with a bridge, an anchor and two represented models included;
  - the boundary record's section with its counts line, after the laws and before the conditions;
  - lines hidden when not matched, when an F5 law they cite is not matched (a reading beside the rule's F5 label included), or when the record around the field changed, with the rule's lines outside the field kept and the section naming the cause;
  - a premise's `absent` of another shape;
  - a carrier the data has not read, and the data's record no longer carrying the field;
  - real pages rendered byte-identical when no record carries the field;
  - `affected_ids` after a change to the boundary record, to the data, to an F5 carrier, and after the boundary record is deleted.
- **Status.** The four lists and `current`, true at a matched field and false at a changed one or the error, on a matching receipt; premise items "not shown" kept out of the unverified list; the error when two records carry the field.
- **The Lean check.** A test compiles stub modules (a prelude, a grammar, a model, a leaf, a grammar module built on the model, and a module of the third and fourth re-checks' cases) from strings in a temporary folder and runs the check once on:
  - a form passing every test;
  - recoveries on each of which the discharge condition fails: through a model fact, a fact held in a definition, one carried by a model's data, one given by a tactic inline in the data, one inside the proof Lean lifts out of data (`_proof_1`), one through a `have`, a theorem written by hand as `next.inj` on a definition, one written as `comm.elim` on a theorem and carried by data, `op.eq_1` on an opaque (named and carried by data), `Rp.brecOn.go` on a Prop inductive, `Cfg.elim` on a structure carried by data, and another declaration's lifted proof named itself;
  - recoveries through generated proofs, which must pass: an `rfl` in a model's data, a termination proof, a derived `DecidableEq`, a `decide`, an equation lemma named itself, a structure's, a class's and a constructor's default (each lifted under the inductive type), the equation lemmas of a definition by well-founded recursion of two arguments and of mutual ones (through `_arg_pusher`), a macro's declaration (a hygienic name), and the equation lemma of a definition over a nested type (through `_sizeOf_2_eq`);
  - a form with two hypotheses, one of which names a grammar definition holding a proof only in types, which must pass, with the same facts on both sides;
  - the check's copy of §3.0's rule, held to boundary.py's on the kinds THEOREM-CONNECTIVITY-DUMP.lean writes of the stubs (an opaque apart), with the check's kinds of names the dump lacks, on 142 names: 70 generated (`Nat.fold.eq_def`, `PSigma.casesOn._arg_pusher`, a matcher's `congr_eq_1`, a nested type's auxiliaries and the functional induction Lean realizes among them), and 72 not (written by hand under a name Lean uses, under a declaration of another kind or of none, each pattern under a kind it must not attach to, `_unsafe_rec`, `_arg_pusher`, `congr_eq_N` and the functional induction and cases included, a part no generated declaration has, and near misses of each pattern); and on the dump's theorems after the macro scopes, listed from the dump; the dump's hygienic lifted proofs and equation lemmas; the names `outside` lists; D2 through `Nat.fold.eq_def`, passing with the check's kinds and failing closed without; and D2 through a macro's equation lemma and through a nested type's `_sizeOf_2_eq`;
  - a hypothesis with an amount behind a prelude definition, and a certificate not in the environment;
  - the name test (by module and by content) and the equivalence test (an `Iff`, an `Eq` of propositions and of predicates, an `Eq` at a type of values).

  Sixteen mutations of the two copies (an attachment widened or narrowed for each finding of the third re-check, an opaque read as a definition, macro scopes or supplied kinds ignored) each fail it, and sixteen more for the fourth's (a nested type's names or functional induction's dropped or widened, `_unsafe_rec`, `_arg_pusher` and `rec_N` widened, the name before the macro scopes read escaped, `brecOn_N`'s parts dropped, the note that the check did not run dropped; [boundary/check/mutations_recheck3.py](boundary/check/mutations_recheck3.py) and [boundary/check/mutations_recheck4.py](boundary/check/mutations_recheck4.py), each with its output beside it, run on the tests as they stand). It takes about thirty seconds. It runs the installed toolchain directly, so nothing is downloaded, and is skipped when that toolchain is not installed. The run against U4's build stays as evidence ([boundary/check/run_controls.py](boundary/check/run_controls.py)).
- **End to end.** On GW's run (core 20261030T152859.871907Z), the report with a synthetic carrier of U4's eight derived rows, three readings, `act_courses_unselected` declared derived and the two premises, the real Lean check run, and rerun after the code review's fixes and after each re-check's, with every row the same ([boundary/e2e-report.json](boundary/e2e-report.json); the harness asserts these outcomes, the six counts included): the eight verify; `act_courses_unselected` fails D2, D3 and D5; the condition is not entailed and C not shown; the counts are 8 derived, 24 connected, 32 at balance in its statement, 16 at a represented model, 7 on their own carrier and 31 unplaced.

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

**The code review of 36d4b0fae: 46 findings, 29 confirmed and all taken; the verifiers judged 17 nits on correct code, of which 14 are taken as cheap defences or tests and three in part.** Four lenses read the implementation (spec conformance, robustness and regressions, the Lean integration, the tests), each followed by one adversarial verifier of its findings ([reports/boundary-code-review.json](reports/boundary-code-review.json), with the verdicts). A first pass of the Lean and tests lenses ran before a restart, and its verifiers did not; the two lenses ran again, and their second findings, which take in most of the first, are the ones verified. Three of the first pass's own are taken as well: the check's docstring now names its test (it cited a file that does not exist), `run_check` refuses a check that does not begin with `import Lean`, and the stub test runs the installed toolchain directly, so that elan downloads nothing.

| Findings | What 36d4b0fae had wrong | Where taken |
|---|---|---|
| LEAN-1 (major) | test 9 saw only the theorems the recovery and its own auxiliaries name, so a model fact held in a definition, or carried by a model's data, passed the discharge condition | boundary_check.lean: a proof is a theorem or a package definition of a proposition, and the walk enters the package's definitions (§3.2 tests 5 and 9); two stub controls; U4's 31 controls rerun with the same outcomes. The re-check found the walk collecting generated proofs and reading types, taken below |
| SPEC-1, ROBUSTNESS-1, TESTS-4 | the check crashed on an unhashable name when the review's text was read | `reviewed` filters full names first; tests through the check |
| SPEC-2, LEAN-2, ROBUSTNESS-4 | a missing Lean binary or checker stopped the generator | `lean_check`'s setup inside its guard, recorded as not run (§3.6) |
| SPEC-3, ROBUSTNESS-6 | a rule line said both that nothing was declared and that a declared standing was unverified | "no standing verified", "not verified as a case of one" (§5) |
| SPEC-4 | a reading did not show the rule's label where it differs | the reading's line and the section give it, with the rule's reason (§5) |
| SPEC-5, ROBUSTNESS-2 | an item that is not an object was dropped from the report | unverified by its place, `item` (§3.6, §4) |
| SPEC-6, SPEC-7, ROBUSTNESS-8 | a carrier without laws, or one the data had not read, kept a stale or no section; a deleted boundary record or a changed F5 carrier re-rendered nothing | `attach_standings` and `affected_ids` (§3.6, §5) |
| SPEC-8 | test 3 also reads a hypothesis's «» terms | the wording and the message say so (§3.2) |
| SPEC-9, SPEC-10, SPEC-11 | `lean_check` with nothing to check; `against_f5` dropped zeros; `absent` beside a theorem refused unstated | §4; every label kept; §2 |
| SPEC-12, TESTS-13 | "pages byte-identical" tested by proxy | real pages rendered with and without the attach |
| ROBUSTNESS-3 | a status or review path of another shape crashed the rules | refused, never a crash |
| ROBUSTNESS-5 | a change around the field (its record's schema, status, review references or laws, or the field's own keys) left the data current | `context` in the report; every declaration and "the field" not matched (§3.6, §4) |
| ROBUSTNESS-7 | the data hashes `master_laws.py`, which changed | the generator rerun at landing (§8 step 1), a landing step not yet done |
| TESTS-1, ROBUSTNESS-9 | `current` was false in every status test whatever the field did | a matching receipt; `current` true at a matched field |
| TESTS-2 | no test went through `registry.validate` | the schema-1, schema-2 and two-record cases through it |
| TESTS-3 | the generator's counting was tested only through `counted_in` | `law_entries`, with one carrier and two |
| TESTS-5, TESTS-8 | the «» anchor exclusion and D3 and D4 through a forwarder were vacuous | the grammar's balance form among the constants; a row through a forwarder |
| LEAN-3 to LEAN-7, TESTS-6, 7, 9 to 12, 14 to 18 (nits) | defences and tests the verifiers judged unneeded on correct code | output of another shape and an entry that did not pass; the module of every name sent; reasons without local paths and a fixed timeout message; the grammar module built on a model and the `Eq` branches in the stubs; the facts on both sides; forwarders of forwarders and a theorem that is not one; the walk through auxiliaries; no result, a failing entry kept out of the query and Q1 on a definition; every introduced name and every required key; the sentence variants; `affected_ids` before the data has read the field; the harness's asserts. In part: LEAN-6 (without its Lean-side report of an absent name), TESTS-16 (the absent certificate's message pinned, the model-fact case left as it is) and TESTS-17 (its case added beside the original, which the verifier upheld) |

**Inner auxiliary components** (U4's owner's note, 31 October): an auxiliary's own constants are generated too (§3.0). On GW's run they are 97 names the probe's pattern missed, and no figure, walk or reach changes.

**The re-check of the fixes (ffccb515d against 36d4b0fae): 16 findings, 12 confirmed and all taken; the verifiers judged 4 not real, and all four are taken as cheap defences or a stated limit.** Two lenses read the fixes, each followed by one adversarial verifier ([reports/boundary-fix-recheck.json](reports/boundary-fix-recheck.json)). One lens checked that every confirmed finding was taken, rerunning each original reproduction and 38 mutants. The other looked for what the fixes broke, Lean stubs included. U4's 31 controls were rerun after the fixes below, with byte-identical output. So was the end-to-end report, with every row the same; only the check's hash differs.

| Findings | What ffccb515d had wrong | Where taken |
|---|---|---|
| REGRESSIONS-1 (major), TAKEN-1 | LEAN-1's walk collected the proofs Lean generates inside a package definition (the `_proof_N` of a termination proof, a `decide`, a derived instance or an `rfl` in a model's data), so correct forms failed test 9; on GW's dump the statements of 13 of the 118 central rows reach such proofs, all through `Law.run._proof_1` (19 reach a package theorem, the other six only amount lemmas held in definitions, which test 9 counts; the second re-check's TAKEN2-6) | the walk goes through §3.0's auxiliaries by the check's own copy of the pattern, held to boundary.py's by a test, with `ofNat_ctorIdx` added (§3.0, §3.2 test 9); four stub controls that must pass and one through a tactic's proof that must fail (the tactic's proof stays inline in the data, the second re-check found: TAKEN2-3) |
| REGRESSIONS-2 | test 5's facts and test 9's uses came from types too, so a proof inside a definition named only in one side's type made the two idioms disagree, and failed a recovery | the walk reads term positions only (§3.2 tests 5 and 9); a stub form with two hypotheses, one naming a grammar definition that holds a proof |
| REGRESSIONS-4 | a change around the field hid every line, including the rule's for rows outside the field; the section's sentence blamed another version of the field and showed its cause last, past the five names it lists | the rule's lines outside the field stay; "the field" first; the section's own sentence (§3.6, §5) |
| TAKEN-4 | a reading's line gave the rule's F5 reason while the F5 law it cites was not matched | the gate reads the rule's label beside a reading too (§3.6) |
| TAKEN-3, TAKEN-5 | §3.4 said the page shows what only the data shows; §3.6 named draft 3's imports | §3.4, §3.6 |
| TAKEN-6, TAKEN-7, TAKEN-8 | the review's test skipped the law kind; the generator's branch for two carriers was untested; the harness did not assert the counts | the law in the review's loop; `boundary_data` and its test; the six counts asserted |
| TAKEN-9 | §9 miscounted the nits taken in part; the landing step ROBUSTNESS-7 needs was not among what lands | above; §8 step 1 |
| REGRESSIONS-5 | the output guard let a row of another shape crash the report | a row must be a string |
| TAKEN-2, TAKEN-10, REGRESSIONS-3, REGRESSIONS-6 (not real) | the section crashed when called directly on an `absent` of another shape, which validation refuses first; admissions read by truth; an `Init` proof a model's data carries uncounted; `rows` of another shape in `affected_ids` | `absent` read only as text; `is not True`; §3.2's "What this does not show"; `rows_of` |

**The second re-check (e5a8349db against ffccb515d): 11 findings, 7 confirmed and all taken; the verifiers judged 4 not real: TAKEN2-2 is taken with WALK2-1, WALK2-2 in part, WALK2-3 as a stated limit, and TAKEN2-1's fix is not taken, since it fails a correct form.** The same two lenses read the fixes, each followed by one adversarial verifier ([reports/boundary-fix-recheck2.json](reports/boundary-fix-recheck2.json)). U4's 31 controls were rerun after the fixes below, with byte-identical output. So was the end-to-end report, with every row the same; only the check's hash differs. Run on the previous check, three of the new stub controls pass (the cases WALK2-1 and WALK2-2 name), and the new check fails them.

| Findings | What e5a8349db had wrong | Where taken |
|---|---|---|
| WALK2-1 (major), TAKEN2-2 | a proof was taken for a generated auxiliary by its name alone, so a theorem written by hand under a name Lean also uses (`next.inj` on a definition, `comm.elim` on a theorem, any theorem in a namespace `Model.elim`) was walked through, and its Init-only proof hid a model fact from test 9, test 5 and the bridges' closed set; boundary.py's D2 had the same exposure | the rule by attachment, in boundary.py and the Lean check, on the dump's and the environment's kinds, with `_proof_N_M` (§3.0, §3.2 test 9), and its limit stated (§3.0); stub controls for `next.inj` named directly and `comm.elim` carried by data, which must fail; a D2 case; the dump's fixtures given real kinds; the pattern test on the stubs' own declarations |
| WALK2-2 (not real), TAKEN2-1 (not real) | a generated proof the recovery names itself was walked through, so another declaration's lifted proof (`Fin.add._proof_3`, `Nat.fold_succ._proof_1`) met a hypothesis by Init arithmetic | in part: a lifted proof the owner names itself is collected (§3.2 test 9), with a control naming `three._proof_1` that must fail; an equation lemma named itself is still walked through, with a control that must pass. TAKEN2-1's fix, walking an auxiliary in the owner's context, would fail that control |
| WALK2-3 (not real) | test 9 refuses some recoveries made by definitions alone: a package lemma in a termination proof, a package instance of a class of propositions, a root proof inside a root definition | stated in §3.2's "What this does not show": the check fails closed |
| TAKEN2-3 | no test checked that a package proof inside a generated auxiliary is still collected, or that a `have` is read; the tactic control went through no auxiliary | controls through the `_proof_1` Lean lifts out of data and through a `have`, which must fail; the tactic control's comment and §8 corrected |
| TAKEN2-4 | the `saying` test asserted D1 only | the whole list, D6 included |
| TAKEN2-5, WALK2-4 | §8 counted the pattern test's names as 43, not 48 | §8, for the rule's test as it now stands: 64 |
| TAKEN2-6 | §9 said 19 of the 118 central rows reach generated proofs | 13, all through `Law.run._proof_1` (the REGRESSIONS-1 row) |
| TAKEN2-7 | §3.6 left out that `premises_of_the_ethics` closes the list after a change around the field | §3.6 and `boundary_matching`'s docstring |

**The third re-check (328fa883a against 652ee90ac, after the field landed): 8 findings, all confirmed and all taken, as MV's follow-up.** Two lenses read the rule by attachment (the two copies held together; what the Lean check's copy lets through or refuses), each followed by one adversarial verifier, which confirmed all eight on Lean 4.29.1, one sub-claim of RC3-RULES-2 refuted ([reports/boundary-fix-recheck3.json](reports/boundary-fix-recheck3.json)). Their probe modules are carried, adapted, by the stub module of §8's Lean check. None of the shapes occurs on the current dump, so no figure, walk or reach changes. The cases of [boundary/check/controls-run.log](boundary/check/controls-run.log) on U4's build (31: its 21 controls, U4's two rows and U4's controls adapted among them, and 10 name-test queries) were rerun after the fixes below, with byte-identical output. So was the end-to-end report, with every row the same; only the check's hash differs.

| Findings | What 328fa883a had wrong | Where taken |
|---|---|---|
| RC3-RULES-1 (major) | the dump lacks Init, so boundary.py had no kind for the name before `Nat.fold.eq_def`, which Lean realizes in the package module that unfolds `Nat.fold`; D2 refused a correct derivation, while the Lean check, reading the environment, took it for generated | `outside` lists such theorems, the generator sends them to the Lean check before D1–D5, and D1–D5 read its `kinds` (`Terms.supplied`); the measure's facts stay the dump's; without the check D2 fails closed (§3.0); a fixture, a report test and D2 on the stubs' dump |
| RC3-RULES-2 | the pattern test fed boundary.py the Lean check's own kinds (Init's present, an opaque as a definition), so drift between the two copies, or within either, passed every test | the pattern test on THEOREM-CONNECTIVITY-DUMP.lean's constants of the stubs; each pattern under a kind it must not attach to, near misses of `noConfusion`, `_aux_N` and `_sizeOf_N`, an opaque, a partial definition and Init's equation lemma among the 100 names; sixteen mutations of the two copies, each caught (§8) |
| RC3-RULES-3 (nit) | §3.0 said every walk goes through generated auxiliaries, and §3.2 that test 9 never collects one, beside test 9's collecting another declaration's lifted proof; and that the copies are held together "on the same kinds" | §3.0 and §3.2 state the exception and which kinds each copy reads |
| RECHECK3-LEAN-1 (major) | Lean puts the proof it lifts out of a structure's or a class's default, or a constructor's optional argument, under the inductive type (`Cfg._proof_1`), which the rule left out, so a recovery through such a datum failed test 9; Lean's proof cache spreads it to other declarations of the module | `_proof_N` and `proof_N` attach to an inductive type too, in both copies (§3.0); controls through the three defaults, which must pass |
| RECHECK3-LEAN-2 (major) | the equation lemmas of a definition by well-founded recursion of two arguments or of mutual ones reach `_arg_pusher` theorems, which no table had, so a recovery naming `ack.eq_1` failed | `_arg_pusher` attaches to a definition (`PSigma.casesOn`'s kind supplied from the Lean check on the generator's side); controls through `ack.eq_1` and `evW.eq_1`, which must pass |
| RECHECK3-LEAN-3 (major) | a macro's declaration has a hygienic name, whose last component is a number, so its lifted proof was collected | both copies read a name without its macro scopes and the name before it with them (§3.0); a control through a macro's declaration, which must pass |
| RECHECK3-LEAN-4 (major) | an opaque was read as a definition, so a theorem written by hand as `op.eq_1` under an opaque, to which Lean gives no equation lemma, was walked through, and so were `go` and `eq` under a Prop inductive's `brecOn`, a theorem; the stub list certified names that do not exist (`Tone.brecOn`, `Tone.binductionOn`, `Reach.brecOn.go` and `.eq`) | an opaque is its own kind: the equation lemmas' names, `splitter`, `_sunfold`, `_default`, `_aux_N` and `_arg_pusher` attach to a definition only; `_unsafe_rec`, `match_N` and the lifted proofs to an opaque too; `go` and `eq` only under a `brecOn` that is a definition (§3.0); controls through `op.eq_1` (named and carried by data) and `Rp.brecOn.go`, which must fail; `Reach.brecOn.go` and `.eq` among the names not generated, and a recursive inductive type's `brecOn`, `brecOn.go`, `brecOn.eq` and `below` among those generated |
| RECHECK3-LEAN-5 (nit) | §3.0's table left out that Lean also gives `_default` to a Prop field's projection and to an overridden field, and makes `_inherited_default` and `_autoParam` | stated in §3.0, with why no outcome depends on it |

**The fourth re-check (26977f25a, MV's follow-up, against 1aa84fd59): 4 findings, all confirmed and all taken, in the same follow-up.** One lens read whether the third re-check's eight findings are taken and what the fixes break, holding the two copies together on 16,822 names of its probe modules, followed by one adversarial verifier, which reproduced each finding, R4-1 to R4-3 on Lean 4.29.1 and R4-4 on `report()` with a stubbed Lean check ([reports/boundary-fix-recheck4.json](reports/boundary-fix-recheck4.json)). It found the eight taken. R4-1 and R4-2 are not regressions (1aa84fd59 gives the same) and are latent; R4-3 is a gap in the negatives the follow-up's own §8 text claimed, and R4-4 is §3.6 text its reorder left behind. None occurs on the current dump: on core 20261030T232750.486801Z's dump and U4's build the old and new rules gave the same auxiliaries, walks, forwarders, laws and root constants, and `outside` stayed empty (that output was not kept; the runs on RF-M.3's and HE2's dumps are in [reports/boundary-rule-compare.json](reports/boundary-rule-compare.json), by [boundary/check/compare_rule.py](boundary/check/compare_rule.py)). The cases of [boundary/check/controls-run.log](boundary/check/controls-run.log) on U4's build (31: its 21 controls, U4's two rows and U4's controls adapted among them, and 10 name-test queries) were rerun after the fixes below, with byte-identical output. So was the end-to-end report, with every row the same; only the check's hash differs.

| Findings | What 26977f25a had wrong | Where taken |
|---|---|---|
| R4-1 (minor) | Lean puts the equation lemmas of a definition a macro makes after the macro scopes (`halve.«_@».M._hyg.3.eq_1`), and the dump writes such a name escaped, the name before it unescaped; boundary.py joined the escaped components, found no constant and refused the lemma in D2, while the Lean check's copy took it for generated; `outside` listed it | boundary.py reads the name before as the dump prints a name with macro scopes, unescaped (`printed`), in `Terms.aux` and `outside` (§3.0); a macro in the stub module defining by well-founded recursion, with D2 through its equation lemma; the pattern test reads hygienic names by component, and sends the dump's theorems after the macro scopes to the Lean check, which reads them listed |
| R4-2 (minor) | neither copy had a nested inductive type's auxiliaries (`_sizeOf_2_eq`, `below_1`, `brecOn_1` with its `go` and `eq`, `rec_1`), so a recovery through `count.eq_1` of a definition over a nested type failed test 9 and a row through it D2; nor the names Lean realizes for a definition on use (`induct`, `induct_unfolding`, `fun_cases`), so a row through `fun_induction` failed D2 | both copies attach `_sizeOf_N_eq`, `brecOn_N`, `below_N` and `rec_N` to an inductive type, `go` and `eq` under a `brecOn_N` that is a definition, and `eq_unfold`, `congr_eq_N`, `induct`, `induct_unfolding`, `mutual_induct`, `mutual_induct_unfolding`, `fun_cases` and `fun_cases_unfolding` to a definition, each as Lean 4.29.1 makes it (in the stub module, `congr_eq_N` on a probe not kept; §3.0); a nested type, its definition and a recovery through its equation lemma, which must pass, and a theorem realizing functional induction, in the stub module |
| R4-3 (nit) | §8 said the names not generated put each pattern under a kind it must not attach to, but `_unsafe_rec` had none and `_arg_pusher` none apart from its group, so widening either in both copies passed every test | `_unsafe_rec` under a theorem, an inductive type and a constructor, `_arg_pusher` under an opaque and a theorem, and each new pattern under a kind it must not attach to, among the names not generated; sixteen mutations of the new parts, each caught ([boundary/check/mutations_recheck4.py](boundary/check/mutations_recheck4.py), its output beside it; the third re-check's sixteen are [boundary/check/mutations_recheck3.py](boundary/check/mutations_recheck3.py)) |
| R4-4 (nit) | §3.6 still described the order before the third re-check (the input only for entries passing every other check, without `generated`; "with none to check, Lean is not run"), and a derived entry whose D2 turned on a kind the dump lacks carried D2's message alone when the check did not run, naming a theorem the field cannot declare | §3.6 states the input and the order as the code has them; such an entry also says that the check did not run, with its reason; a report test |
