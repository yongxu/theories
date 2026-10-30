# Second review: U4, the boundary record (DESIGN-BOUNDARY.md and the strict forms)

*Independent AI review. Read-only on `wt-u4` (branch `u4-edge`, `3fd7dad75`). D/ = `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u4-one-root-to-its-edge/`; L/ = `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.*

## Verdict: sound with fixes (3 blocking)

The eight derived rows, the counts and the table hold, and the scratch Lean is correct as Lean. Two things are not sound:
- the new rule "a row may carry more than its form needs" (D/DESIGN-BOUNDARY.md:87), as used for row 5;
- the claim that §1.5's tests can be run from constant names.

## What I checked, and how

- **Ran** `boundary_table.py . --dump constants-main.pickle --json <scratchpad>`. The output is identical to the committed `boundary-table.json` (sorted keys).
  - Counts: 8 derived; 6 counting; 24 / 2 / 31 / 18 / 16 / 7 / 3 / 3 at distances; 0 unplaced. F5's 44/16/7/51 are read back and match.
  - 42 readings, 40 of them differing from the rule: 32 unplaced → placed, 8 connected → derived.
  - From the dump, I recomputed finding 1: 0 rows pass directly, and 11 pass with definitions unfolded, the same list as §0:43.
- **Ran, writing nothing:**
  - the periphery check (`lean ../Becoming/U4BoundaryCheck.lean` in `boundary-scratch/.build`, `LEAN_PATH` as its header says). Its output is identical to `check-run.log`.
  - `#print axioms` on all 14 theorems, through `lean --stdin`: every report is empty. `Nat.succ_ne_zero` depends on `propext`.
  - two probes through `lean --stdin`: the check with one fake entry added (finding 2), and the theorems each bridge's proof uses (finding 1).
- **Read:** the design, the first review, the table script, the reading's correction note, both scratch files, the rows and definitions the brief lists, and lever 2's row-5 form and witnesses.
- **Not checked:** the "105 unbundled" figure; the eight derived rows' bridges (the first review checked them).

## Q1. The first review's findings

- **B1: taken** (§1.2:78, :83, :99), but §1.2:87 reopens it in another form (finding 1).
- **B2:**
  - (1) The new test is specified (§1.5), but it cannot be run from names as written (finding 3).
  - (2) Derived and standing 2 are now separated by where the law is declared and by the kind of bridge. Y sits in a `Grammar*` module, by OU's decision (§1.1:66), and its bridges are equivalences. F sits in U4's leaf, and its hypotheses are met by lemmas. That separation is mechanical and adequate.
  - (3) The certificate is checked by Lean. The countermodels' shape is not, so the heading "Shapes, checked by Lean" (§1.5:148) overstates (finding 2).
  - (4) F5's §4 is reconciled (§1.2:103–111).
- **B3: taken.** See §1.1:67, §3's table and the correction note in CONNECTED-ROWS-READING.md.
- **B4: taken.** See §1.4:127–132. The table flags 12 rows definitional, and §0:32–35 prints the record's figures against F5's.
- **M1–M8 and M10: taken as §7 says.** I verified two in the table:
  - M5: `Web.Whole.family_excess_ends` reaches only `kept_onward` and stands at balance;
  - M6: `act_courses_unselected` is connected, reaching `«所闭之传递»` and `«缘在所闭»`.
- **M9: partly taken.** The fix created a new contradiction (finding 5).

## Blocking

### 1. The "carry more" rule lets amount reasoning into the bridge. Row 5 reaches standing 2 only through it, and as written the rule promotes other balance rows too (Q2, Q3)

**What the bridges use.**
- `no_new_dependence_at_model` meets `GivenTo` by `Flow.descends_of_comes balances comes` (U4Boundary.lean:98).
  - The probe shows its proof uses exactly three theorems: F, `And.left` and `Flow.descends_of_comes`.
  - `descends_of_comes` (Transmission.lean:501–507) is amount reasoning. Balance at `x`, with a rise from zero, gives a positive giving, through `total_pos` and `BalancesOn.rise_given`.
  - That step is row 5's only content beyond logic. The form itself (U4Boundary.lean:58–62) uses no theorem at all.
- `all_end_at_model` (:169–175), by contrast, uses only F, `And.left` and `And.right`. Row 17's hypotheses meet its form's by unfolding.

**The rule is unbounded.** §1.2:87 allows "lemmas the record names", with no limit on what those lemmas do. Two consequences follow.
- **Degenerate forms pass.** Take a form whose one hypothesis is its conclusion (`def Holds (a : Prop) := a`).
  - It passes the name test and the amounts test.
  - It has a countermodel, `¬ ∀ a : Prop, a`.
  - Its bridge meets the hypothesis with the row's own proof.
  - Nothing in §1.5 forbids it.
- **Like rows are placed unlike.** `Flow.Balances.renewedBy` (Flow.lean:513–516) is one of the 31 "balance, represented" rows, and it has row 5's structure exactly.
  - Its balance is used only through `total_pos` and `rise_given`, to find a giver for every rise, with `Acting` as a gate.
  - Under §1.2:87 it gets a two-hypothesis form ("every rise is given to"; "giving comes from the active"), with countermodels, and moves to standing 2.
  - The design keeps it at a distance and gives no reason.
  - The measure itself puts row 5 in the same category: its table row has `category: "balance, represented"`, and LEVER-2-AUDIT.md:64 agrees.
  - Lever 2 and its review accepted row 5 under the weakened hypothesis (REVIEW-U4-L2.md:47). Under the strict reading, though, standing 2 becomes a mechanical test, and that test must treat like rows alike.

**The candidate condition, weighed.**
- "Each form hypothesis is weaker than a hypothesis the row states" is a semantic condition, and names cannot check it. If "weaker" means "implied through a named lemma", then balance → "given to" qualifies. Neither row 5 nor `renewedBy` is stopped, only the degenerate form.
- "Not the form's only motivating instance" cannot be checked, and it is beside the point: it would exclude row 17, which is clean.

**Fix (recommended).** Add a discharge condition:

> The bridge meets each of F's hypotheses from the row's own hypotheses by definitions alone. Apart from F and the named bridge equivalences of §1.1, its proof uses no theorem except Init's projections and constructors (`And`, `Exists`, `Eq`).

- Amounts may still define the model's relations. Row 17's giving is `present ∧ 0 < give` (Flow.lean:280–281), and that is allowed.
- What is excluded is amount reasoning used to meet a hypothesis.
- The Lean check can test this; the probe above is that test.
- Under this condition:
  - row 17 reaches standing 2;
  - row 5 stays at "balance, represented", with its strict form and `no_new_dependence_of_given` recorded as its relational part ("balance is used only to find a giver").
- Rewrite §1.2:87–88, and the HAND entry for row 5, to match.

**Alternative.** If OU's owner wants the weaker sense, name it as a standing of its own ("under a stated hypothesis, met through ⟨lemma⟩"). Then apply it to every row by a scan, `renewedBy` included, and revise the 31 accordingly.

### 2. The names-only shape test can be fooled, and nothing checks that a form's hypotheses are the named ones (Q4)

**The probe.** I ran the check through `lean --stdin`, unchanged except for one added entry in `forms`. It reported every test passed for both of these:
- **A vacuous countermodel:** `¬ ∀ {X} {comes before after} {descends}, Inherits … → UndependedFrom … → False`.
  - It names exactly what `needs_given` names (check-run.log:5).
  - It is trivially true and says nothing about `GivenTo`.
- **A form with an inline amount hypothesis**, `(bound : ∀ x, comes x → q x ≤ 0)`, beside the three named ones. Three parts of the check let it through:
  - the name test admits `Nat` and `LE.le` as "outside Becoming" (U4BoundaryCheck.lean:60–63);
  - the amounts test reads only the listed definitions (:102–105);
  - the countermodel test never compares a countermodel with F's type (:106–114).

The four negative controls (§4:247) test neither case, and they are not committed: no file or log in D/ holds them.

**Fix.** In the Lean check, work on F's telescope (`forallTelescope`):
1. Require every Prop-valued binder to be an application of one listed hypothesis definition, each used once.
2. For each hypothesis i, build `¬ ∀ (F's binders without i), F's conclusion` with F's binder infos.
3. Require that to equal the countermodel's type, up to binder names.
4. Commit the controls, these two included, with their expected failures.

Then §1.5:148–152 can truly say "checked by Lean".

### 3. §1.5 cannot run on the constants dump as specified (Q1, B2)

§5:272 says "MV verifies these from the checker cache". As specified, three of the tests cannot be run from it.
- **The dump drops Init's constants.** In `constants-main.pickle`, the `t` list of `Becoming.Flow.no_new_dependence` has no `Nat`, `HAdd.hAdd` or `Eq`, and `Becoming.total`'s `t` is empty. `Nat` and `LE.le` are not keys. So:
  - the amounts test (§1.5:145) cannot run on the dump;
  - "names only Init" cannot be told apart from "names nothing".
- **"A constant outside `Becoming`, that is, of `Init`" (:141) is false in this package.**
  - The dump holds the foundation's 295 constants, in modules `GenerativeCore` (the `Generative.*` names), `RelationalRenewal` and `InquirySufficiency`.
  - The check admits them by module prefix (U4BoundaryCheck.lean:63), and `GenerativeCore.olean` is in its `.build`.
  - `Generative.Process` is a model.
- **"A «» name" (:139) admits theorems declared off the grammar,** such as `«全生成则生成»` (KeepingWidening.lean:231) and `«及在渐粗列之相续»` (HeldPossible.lean:504). The check admits any name containing «(:62). This contradicts §1.1:66: "The «» name is the vocabulary, not the standing". §3:222 has the same issue.

**Fix.**
- State the test by module. Admit:
  - the `Grammar*` modules, with their generated auxiliaries;
  - `Becoming.Prelude`;
  - Init's constants, that is, those absent from the package;
  - the form's own hypothesis definitions.
- Exclude the foundation's modules explicitly.
- Then either have the dump keep Init's names, or say that the amounts and shape tests run in the Lean check and MV records its result.

## Minor

**4. Row 5's prose does not match its Lean (Q2).**
- §4:232 says coming to stand is the region in the form's conclusion. In the bridge, the region is `fun y => y = x` (U4Boundary.lean:95).
- The row's `comes` is consumed with balance to meet `GivenTo` (:98). At the model, `GivenTo` is the unconditional `∃ g, DescendsAt t x g`. It is not lever 2's inclusion `ComesToStand → ∃ g, …` (U4LeverTwo.lean:592), which §1.2:88 describes.
- **Fix,** if row 5 keeps the form as its relational part: instantiate `comes := fun y => y = x ∧ W.ComesToStand t y`. Then:
  - `GivenTo` is lever 2's inclusion, met from balance alone;
  - the region is coming to stand, as §4 says;
  - `Standing`'s counterpart is the region, and no countermodel is needed for it.
- Restricting to the relatum is legitimate: it is the form at a singleton region, which the row forces, since balance and inheritance hold at `x` only. It is not vacuous. The record should say that the row is the form at one relatum.

**5. Row 5's placement contradicts §0 and §2.**
- §0:52 lists row 5 among the rows that take balance "only in their proofs", and :54 says its statement carries balance.
- §2's rule 1 (:164) places by balance "in its statement", which by :54 gives "balance, represented".
- The table's `rule_would_give` shows "unplaced" only because the anchor test misses the equation written out.
- **Fix:** let rule 1 read balance written out (the scan at :54 already finds it).

**6. What the forms establish (Q5).**
- `descent_forms_no_dependence` uses no theorem. `outside_leaves_no_offspring` uses one Prelude list lemma and its own length lemma.
- Neither reaches any grammar law. Row 5's form uses one grammar term, `«际»`, which is an `abbrev` for `α → α → Prop` (Grammar.lean:47).
- The root countermodels over `Unit` show only that no hypothesis is redundant in the schema, and any non-redundant first-order hypothesis has such a countermodel.
- So standing 2 here means: the row's conclusion follows by logic alone from its hypotheses read as relations, and none of them is redundant. It does not mean:
  - that the row uses the grammar's laws. Connected rows do; these forms do not.
  - that the hypotheses are warranted. They are premises of the account (K3).
- The record should say this in those terms. It should also keep lever 2's model witnesses beside each root countermodel: they show that the model does not meet each hypothesis automatically. And "on the edge" (§0:15) should not read as nearer the grammar than "connected".

**7. Smaller points.**
- The leaf re-proves `succ_ne_zero` (U4Boundary.lean:121–122). The Prelude already has `Becoming.succ_ne_zero` (Prelude.lean:174–175), proved for the same reason. Use it, and correct §4:228.
- §4:262 says the leaf imports GrammarLaws. The scratch imports Grammar, Transmission and GroupEnding (U4Boundary.lean:1–3), and needs nothing from GrammarLaws.
- §1.5:153 says "Every declared item is in the core leaf". Y and the derived rows' bridges live in Grammar and model modules; write "in the core".
- The check does not test the certificates, though §1.5:152 says MV checks that they exist. With `type_of%`, the certificate is redundant but harmless.
- Require F's proof to use only the grammar, the Prelude, Init and the leaf's own lemmas. The check tests only that it does not reach the row (:115).

## Q4 and Q6, directly

**Q4.** Each of the six countermodels is exactly ¬ of F with one hypothesis dropped.
- The binder order matches F's: `{X : Type}` (the section variable) first; then the implicit relations, regions and lists in F's order; then the remaining hypotheses in F's order; then F's conclusion.
- Implicitness matches, and `X : Type` in both.
- Each instantiation is correct: I checked them by hand, and Lean accepts them.
- The names-based check is not sound beyond its controls (finding 2).

**Q6.** If landed as written, the scratch module meets the pure-core rule.
- **Imports:** `Becoming.Grammar`, `Becoming.Transmission` and `Becoming.GroupEnding`, all core modules (Becoming.lean:43, :68). Its import closure is therefore the foundation and the core: Init only, besides the package.
- **Axiom reports:** all 20 declarations are empty, per scratch-build.log and my own `#print axioms` on the 14 theorems.
- **The check module stays out of the core.** It imports `Lean` (U4BoundaryCheck.lean:1) and sits in `boundary-scratch/Becoming/` as `Becoming.U4BoundaryCheck`, but the design does not say where it goes at landing. State that it lands outside L/, with MV's tools or this study, and never under `Becoming/`.
