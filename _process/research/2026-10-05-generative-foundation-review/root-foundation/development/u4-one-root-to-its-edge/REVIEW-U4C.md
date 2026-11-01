# Review of U4c, the census on the root (CENSUS-ON-THE-ROOT.md)

1 November 2026. AI-written independent review of [CENSUS-ON-THE-ROOT.md](CENSUS-ON-THE-ROOT.md) at worktree commit `4d919a99b`. Its brief was to try to refute the design. Reading time: about fifteen minutes.

## What was read and run

**Read.**
- The design.
- Grammar.lean: `«续»` :120, `«生»` :132 and `«亡»` :135.
- GrammarLaws.lean:
  - `«计»` :881, `«定后»` :1040, `«定后之逐点»` :1045, `«定前之逐点»` :1048 and `«屡»` :1569;
  - the census section, :1640–1805.
- Population.lean:
  - `length_le_of_matched` :129, `mem_remove` :119 and `not_not_all` :255;
  - `gaining_of_losing` :387 and `gaining_of_losing_from` :425;
  - `Listed` :446, `across_at` :491, `over_stretch_on` :507, `coming_iff_excess` :599, `coming_of_ceasing` :609, `ceasing_of_returning` :623, `ceasing_of_coming` :642 and `DependenceCensus.forming_of_dissolving` :1108.
- Change.lean and Flow.lean: the counting lemmas that `gaining_of_losing` uses.
- Identity.lean:
  - `ArisesFrom` :572, `NoSplit` :581, `arisesFrom_of_more` :603, `CeasesFrom` :763;
  - the section instances :785–789, `Census.balanceFrom_at` :800 and `Census.arisingFrom_of_ceasingFrom_from` :912;
  - `continuationStep` :999, `activityOnward` :1005, `occurrence_eq` :1011 and `Lineage.unique` :1064.
- Arising.lean: `Steps.along` :662, `along_hasSucc_iff` and `along_hasPred_iff` :668–676, `along_sheng_zero` :679, `Web.activityClass` :690 and `Web.arises_iff_sheng` :713.
- Decidedness.lean: `Counts` :219, `counts_iff_decided` :224, `CountsAcross` :291, `Counts.over_stretch_decided` :387 (through `balance_over_stretch_on` at :410) and `CountsAcross.keep_pace` :438.
- Listing.lean: `CensusWebs.keep_pace` :1057 and `Web.arising_of_ceasing_listing` :513.
- Locality.lean: `coming_of_ceasing_covered` :578, `Listed.covered` :587 and `Covers.ceasing_steps_within` :618.
- Openness.lean: `Web.StandingCensus.coming_of_ceasing` :150 and `World.arising_of_ceasing` :359.
- GrammarCandidates.lean:94: `«生亡对偶»`.
- DESIGN-BOUNDARY §0–§1.5, §2's rules and §4.
- BOUNDARY-FIELD §3.0–§3.1, for D1–D6 and the grammar-law predicate.
- The record one-root-to-its-edge (its standings and `next_delta`).
- The records ceasing-needs-arising and census-balance-under-continuation.
- WHAT-REMAINS :325–345.
- 08 §7.
- The board's Queue line, for the order.

**Run.** A throwaway Lean file outside the package:
- **File:** `/private/tmp/claude-501/-Users-ren-theories/a1748b36-1177-4857-afe2-0d9f0c541556/scratchpad/u4c-review/src/U4cReview.lean`, 422 lines.
- **Build:** against Grammar, GrammarMap, Prelude and GrammarLaws, compiled from this worktree into a scratch build directory with Lean 4.29.1. The package checker was not run.
- **What it checks.** Each declaration below has an empty axiom report:
  - `step_form`: the step form under H1, which it needs only for the list after, and H2, H3 and H4;
  - `step_needs_once`: without H1 the step form fails;
  - `mirror_step_form`: the mirror at one step, as the step form at the converse;
  - `run_form`: from `T` on;
  - `coming_of_ceasing'`: `Listed.coming_of_ceasing`'s statement, re-proved through `run_form` at the occurrence relation, with `[∀ a t, Decidable (p a t)]` only and no `DecidableEq α`.
- **How the file was built.** It takes only GrammarLaws' imports: the list and counting helpers are local copies, which is evidence for question 2.
- **A propext that was removed.** A first version of the beginnings' test used `y.1 - 1` and reported `propext`, through `Nat.add_sub_cancel`. Defining the test by matching on `(t + 1, a)` removed it. That is worth knowing at the landing.
- **Not checked in Lean:**
  - the Identity case, read against the definitions only;
  - the `keep_pace` route of finding 1;
  - the claim of finding 9 that H1 is not needed for the run form's truth.

## What holds

- **The step form is true under exactly H1–H4, and constructive.**
  - The injection argument is right:
    - a unit listed after whose test says it does not begin has, under double negation, a predecessor;
    - H2 lists that predecessor before;
    - H4 makes the predecessor's ending test false, since it has a successor;
    - H3 makes the map one to one.
  - The inequality is a decided `Nat` comparison. So `Nat.decLe` together with the finite double-negation lemma gives the witnesses with no classical step. This is the pattern `Covers.ceasing_steps_within` already uses (Locality.lean:618).
  - No decision of identity enters. Splitting the target list at a member needs only membership.
  - Nothing is needed about the units before: successors that are unlisted, or listed elsewhere, only enlarge the right side.
  - H1 is used only for the list after. Without it the step form fails (`step_needs_once`: `[0]` before and `[1, 1]` after, under `0 → 1`).
- **The run form follows from the step form by counting.** It uses `gaining_of_losing_from`'s argument through the prelude's `le_over_stretch` (Prelude.lean:813), not through `balance_over_stretch_on`. With its helpers it can be proved over GrammarLaws' imports, but the helpers must move down or be copied (finding 2).
- **`Listed.coming_of_ceasing` is a case, with no `DecidableEq` on the carrier.** It was checked as `coming_of_ceasing'`:
  - H1 comes from `Distinct` mapped by `fun a => (t, a)`;
  - H2 from `Nat.succ.inj` and `Listed`;
  - H3 because the occurrence relation is functional;
  - H4 from tests built with `decide (p a t)` and `decide (p a (t + 1))` alone.
  - The bridges are equivalences under the hypothesis that the occurrence is listed:
    - `«生» … (t + 1, a) ↔ ¬ p a t` where `p a (t + 1)` holds;
    - `«亡» … (t, a) ↔ ¬ p a (t + 1)` where `p a t` holds.
  - The design's reason that HE2's census cannot take `Listed`, because `k` would decide identity on occurrences, is right.
- **`Census.arisingFrom_of_ceasingFrom_from` is a case.** This was read against the definitions, not built.
  - **The relation.** At `«续» (continuationStep R) (W.activityOnward T)`, a step needs `T ≤ x.1` and `x` active, and the class makes the successor active.
  - **H3.** It follows from `NoSplit` from `T` on through `occurrence_eq`, exactly as `Lineage.unique` does (Identity.lean:1064).
  - **H2.** For `t ≥ T` it follows from the listing at `t`.
  - **H4.** For units listed after a step from `t ≥ T`, the tests come from the decidability of `Continues` and of `Continued`. Both are section instances the theorem already carries (Identity.lean:785–786).
- **On the key standing question (5), derived is the right standing.** Two conditions apply, findings 2 and 4.
  - **The precedent.** `Law.drawn_iff_not_returns` is a derived row whose law, `«定后有后则入当且仅当不返»`, has the hypotheses `«定后»` and "has a successor". They are met at the model by the support lemmas `Law.next_fixed` and `Law.next_total`.
  - **The test.** DESIGN-BOUNDARY §1.1 asks of support only that it hold at every instance of the model's parameters and add no hypothesis the row lacks.
  - **Here.** H1–H3 are met by support from the row's own `Listed`, and H4 from its own instance.
  - **Why not standing 2.** Standing 2 is for a form that is not a grammar law, whose extra hypotheses stay in the row (DESIGN-BOUNDARY §1.2, "What separates standing 2 from derived"). The proposed law would be a theorem of GrammarLaws.
  - **How the move happens.** The row is moved by DESIGN-BOUNDARY §2's rule 2 together with the reading, as the eight cases were. The proof gives it reach. Its statement stays a counting statement on U4b's line.
- **The figures.** 11 derived, 6 counting and 18 at amounts are right against the record as it stands: 10 derived, 7 counting and 18 at amounts.
- **The order.** "OU7's rebuild last" matches the board's Queue line.

## Findings

### 1. Blocking (for the record's basis text): the reason given for `CensusWebs.keep_pace` is not the obstacle

- **Where.** Design §0 ("its counts are relations … and the root's count `«计»` takes one") and §4 ("A count that exists without a test is not a case of a law stated with one"). §4 also proposes this wording for the record's basis.
- **Why it fails.**
  - **The design's own move answers it.** The design itself obtains witnesses under double negation because the goal is a decided `Nat` inequality. `keep_pace`'s conclusion is such an inequality, `A ≤ fs.length + D ∧ D ≤ fs.length + A`. Its own proof already obtains decidedness of each member under double negation (`not_not_decided` and `not_not_all`, Decidedness.lean:438–456).
  - **So the tests can be had.** The same move gives Boolean tests on the finitely many members and steps of the stretch, with no `DecidableEq`: a list of `Bool` per step, indexed by position. So "a count without a test" is no obstacle to being a case of a law stated with tests.
- **What does block it, against this design.**
  - **(a) It is a two-sided bound.** The step form gives one side: no splits give `D ≤ fs.length + A`. The other side, `A ≤ fs.length + D`, needs the mirror at the step level (no merges, successors listed). The design proposes the mirror only as a run form, and only optionally.
  - **(b) It is a stretch law.** The design states no stretch form, the step form summed by `le_over_stretch` and `ge_over_stretch`.
  - **(c) Its family is fixed and may repeat.** `fs` carries no `Distinct`. Every member is counted whether or not it holds, so its units would be positions of `fs` at each step, a reading the design does not give.
  - **(d) D5.** Its proof today reaches `balance_over_stretch_on` through `Counts.over_stretch_decided` (Decidedness.lean:410), so D5 would fail until it is re-proved.
- **Fix.** Write the basis as what is missing: "not a case of this item's law. It is a two-sided bound over a stretch on a fixed family that may repeat. It would need the step law and its mirror summed over a stretch, read on positions. Its counts as relations are not the obstacle, since its conclusion is decided." Answer §7 question 2 in the same terms. If the mirror's step form is taken (finding 5), a stretch form on positions is a small further step, and the row could then be weighed again.

### 2. Should fix: the law is a grammar law only if its whole proof is on the root; name the moves and D5

- **Where.** Design §2 (the count lemma "in GrammarLaws") and §5 (the counting step "as the prelude's or the census section's lemma").
- **Why it matters.**
  - **D1.** MV's grammar-law predicate needs a root constant, whose closure, proof included, lies in `Grammar*` and the prelude (BOUNDARY-FIELD §3.0).
  - **The run form's chain lies above.** It is not `gaining_of_losing_from` alone:
    - `gaining_of_losing`, `recurs_shift` and `recurs_unshift` (Population);
    - `recurring_accumulates` :246, `pos_of_exceeds` :267, `steps_mem` :212, `steps_last` :217 and `steps_mono` :225 (Change);
    - `total_pos` :183 (Flow).
  - **The step form's list lemma already exists.** It is `length_le_of_matched` (Population.lean:129, stated at `{α β : Type}` by Population.lean:97). It needs `mem_remove` :119 and `not_not_all` :255. Writing a new one in GrammarLaws would set a second copy beside it.
  - **D5.** `Listed.coming_of_ceasing` today reaches the balance anchor `balance_over_stretch_on`, through `coming_iff_excess` (:599) and `over_stretch_on` (:507). DESIGN-BOUNDARY §0, finding 3, counts it among the thirteen rows that reach only that anchor. D5 fails unless the re-proof drops that route.
- **Fix.**
  - **In §5,** list the lemmas that move to the prelude, with their names unchanged, as EC2 moved `balance_over_stretch_on`, rather than copying them. Generalize `length_le_of_matched` to universes, since the census section is at `Type u`, or state it on `«计»` (the scratch's `count_le_of_matched`) and derive the length form from that.
  - **State D5:**
    - the run form is proved through `le_over_stretch`, never `balance_over_stretch_on`;
    - `Listed.coming_of_ceasing` is re-proved through the run form only, not through `coming_iff_excess`.
  - **Say what moving changes for MV.** Moving these lemmas raises MV's root-constant count (2,258) and widens the set D2 admits for every row. The landing reruns `master_laws.py` and checks that no other row's standing changes by it.

### 3. Should fix: the occurrence relation already exists below both modules

- **Where.** Design §3, "Placement: the relation belongs where `Listed` lives … or below both".
- **What is there.**
  - `Steps.along` (Arising.lean:662) is exactly "each member continuing only itself" on `Nat × F`. Arising lies below both Population and Identity: Population imports it transitively.
  - Its bridges are there too: `along_hasPred_iff`, `along_hasSucc_iff` and `Web.arises_iff_sheng` (:713).
  - `continuationStep (fun _ g f => g = f)` is the same relation, with the equation the other way round.
- **Why the design's class matters.** The design's `E`, "both holding", is not a class. Arising's reading uses a class: `Web.activityClass` (:690), "alike in activity". The two give the same `«生»` and `«亡»` on listed occurrences.
- **Fix.**
  - Use `Steps.along` with a determination's two-valued class on occurrences, `fun x y => p x.2 x.1 ↔ p y.2 y.1`. `Web.activityClass` is then its case at activity, so `Listed`'s case and Arising's reading are one reading.
  - Say that `continuationStep` at the identity is the same relation.
  - Nothing new needs placing.

### 4. Should fix: DESIGN-BOUNDARY §4 and the record's next step now say otherwise; say what differs

- **Where.**
  - DESIGN-BOUNDARY:326: "The two census rows are laws of counting, so lever 1's candidate through `«计»` adds nothing to their standing."
  - The record's `next_delta`: "A root form for the census rows".
  - The design §0: "That holds, and this design does not revisit it".
- **Why it matters.**
  - **The new law's conclusion is itself a `«计»` inequality.** Read as written, §4's reason ("laws of counting, so … adds nothing") would bar this move too.
  - **"Root form" is U4's term for a standing-2 form** (RootForms). The design proposes a grammar law, which gives derived.
  - Two live texts would disagree.
- **Fix.**
  - **In the design, state the difference.** Lever 1's census candidate, now HE2's `«定后定前则前并生对后并亡»`, needs `k` deciding every pair, so decided identity, which `Listed` lacks. This law needs only tests on listed units (H4), and the row applies it through bridges. Its subject is `«生»` and `«亡»` of `«续»`, so it passes MV's predicate.
  - **At landing,** add a dated note to DESIGN-BOUNDARY, as §8 did for U4b.
  - **In the record,** reword the next step as "a grammar law the census rows are cases of".
  - **Answer §7 question 1** that way: a grammar law is stronger than a standing-2 form and is admitted by the precedent above.

### 5. Should fix: take the mirror's step form, by converse, in this landing; it joins the law to HE2's census and is needed for `ceasing_of_returning`

- **Where.** Design §2 ("The mirror … a second law, proposed … only if its cases are worth the lines") and §5.
- **What is found.**
  - **The mirror is the step form read backward.** `«生» R E y ↔ «亡» («逆» R) («逆» E) y` (`«生亡对偶»`, GrammarCandidates.lean:94). `«定前»` is `«定后»` of the converse, and "successors listed after" is H2 of the converse.
  - **It costs a few lines.** The scratch's `mirror_step_form` is ten lines, with an empty axiom report: `before.length + «计» b after ≤ after.length + «计» e before`, under `«定前»` and `«后者在后则所列亡者亡»`'s hypothesis `successorsAfter`.
  - **The two halves give HE2's count.** With HE2's hypotheses, the tests come from `k`: `b y := !(before.any (k · y))`. The two halves then give exactly the count of HE2's pairing.
  - **Rule 9.** So the new law generalizes the census of a step's count, below it, rather than standing beside it. That is rule 9's "generalized below, not set beside".
  - **The returning form.** The design says the mirror reaches `Listed.ceasing_of_returning`. That row takes a bound returned to at arbitrarily late steps (Population.lean:623), not "at most `B` from some step on". A run form with a bound from some step on reaches only `ceasing_of_coming` (:642) and `ceasingFrom_of_arisingFrom_from`.
- **Fix.**
  - State the mirror's step form as a corollary at the converse, and its run form in the returning form, from which the bounded form follows.
  - Add one sentence, or a corollary, joining the two halves to `«定后定前则前并生对后并亡»`'s count.
  - Answer §7 question 3: yes.

### 6. Should fix: the records' new sentences overclaim; one census law stays a parallel proof

- **Where.** Design §5: ceasing-needs-arising and census-balance-under-continuation "each gain one sentence: their laws are cases of the root's census of a run".
- **What is found.**
  - **ceasing-needs-arising lists laws that go through the covering law,** `coming_of_ceasing_covered` (Locality.lean:578), not through `Listed`. These are `World.arising_of_ceasing` (Openness.lean:359), in the same law entry as `Listed.coming_of_ceasing`, and `Web.StandingCensus.coming_of_ceasing` (Openness.lean:150).
  - **census-balance-under-continuation's no-merge halves** are cases only if the mirror is taken.
  - **The covering law is more general.** In the identity reading it is more general than `Listed.coming_of_ceasing`, which is already its corollary through `Listed.covered` (:587). After U4c, the census in the identity reading would have two proofs: the root's, and the covering law's, which is not a case.
- **Fix.**
  - Scope the sentences:
    - in ceasing-needs-arising, to `Listed.coming_of_ceasing` and what goes through it (`Web.arising_of_ceasing_listing` and `DependenceCensus.forming_of_dissolving`);
    - in census-balance-under-continuation, to the no-split halves, or both halves with the mirror.
  - Under "Not cases", add `World.arising_of_ceasing`. Name the covering law's root form (lines traced back to a covering list, no splits) as the next step, so that its standing as a parallel proof is written down.

### 7. Should fix: state the run form's indexing; step 0 and steps before `T`

- **Where.** Design §2, "beginnings among them at arbitrarily late steps", and §3's bridges.
- **Why it matters.**
  - **The indexing.** If the conclusion is beginnings among `u t`, then every occurrence listed at step 0 begins with no condition (`Steps.along_sheng_zero`, Arising.lean:679) and is no coming to be (Arising.lean:615–617).
  - **The Identity bridges.** Under `activityOnward T`, every active occurrence before `T` both begins and ends. So "`ArisesFrom` and `CeasesFrom` are the beginnings and endings of active occurrences" holds only from `T` on.
- **Fix.**
  - State the conclusion as beginnings among the units listed after a step from `t ≥ N`, that is `∃ t, N ≤ t ∧ ∃ y, y ∈ u (t + 1) ∧ «生» R E y`, as the scratch's `run_form` does.
  - State the bridges for `(t + 1, a)` and `(t, a)` listed. For Identity, add "from `T` on".

### 8. Minor: the cases the design misses

The step form has direct cases that the design does not name:
- the no-split half of `Census.balanceFrom_at` (Identity.lean:800);
- the `≤` half of `Listed.across_at` (Population.lean:491);
- `Web.arisesFrom_of_more` (Identity.lean:603): more after than before means some unit begins, since the step form gives `after.length ≤ before.length + «计» b after`.

The Identity re-proof has two routes: through the run form, or through `balanceFrom_at` re-proved by the step form. Choose one and say so, so that two routes are not landed.

### 9. Minor: H1 and H3, exactly

- **H1.**
  - The step form needs `Distinct` only of the list after.
  - For the run form, H1 is not needed for the truth. Counting distinct elements, non-beginners at `t + 1` inject into non-endings at `t` by H2 and H3, so endings after the last beginning are at most the distinct units listed then.
  - A constructive proof without H1 would need a deduplication under double negation. That is possible, since a bounded search with the tests is decided, but it is not worth it while every case has H1.
  - Answer §7 question 4 this way, as argued, not checked in Lean.
- **H3.** The global `«定后»` is more than the step uses. The step uses no splits among listed units, as `census_pairs` takes it. Both cases meet the global form, so keep it, but say that it is stronger than what the step uses.

### 10. Minor: one inexact sentence

- **Where.** §1: "No law of the grammar joins the steps of a run."
- **Why it is inexact.** `«对之程»` and `«程守数当且仅当可对»` (GrammarLaws, the Balance section) join per-step pairings over a stretch.
- **Fix.** "No grammar law joins a run's beginnings and endings across its steps."

### 11. Minor: names

- **The step form's name.** `«定后前者在前则后并亡不过前并生»` fits HE2's census names, and `«前者在前»` matches `predecessorsBefore`.
- **The run form's name.** `«…亡不绝者生不绝»` brings in 不绝. The grammar's word for "at arbitrarily late steps" is 屡 (`«屡»`, `«或屡»`, GrammarLaws.lean:1569). Propose `«定后前者在前则亡屡者生屡»` to GrammarLaws' owner, or say why 不绝.

### 12. Minor: the instance arguments of the Identity re-proof

- **Where.** `Census.arisingFrom_of_ceasingFrom_from` takes the section instances `[∀ t f, Decidable (W.active t f)]` and `[∀ t g f, Decidable (R t g f)]` (Identity.lean:785–789).
- **What happens.** Through the run form they become unused.
  - Keeping "its statement unchanged" keeps them, and the unused-section-variable linter warns.
  - Dropping them changes the statement that the record cites.
- **Fix.** Decide which, and say so in §5.

### 13. Minor: what MV's field needs, and what 08 says

- **The entry.** §5 says only "through MV's probe". List the entry for `Listed.coming_of_ceasing`:
  - `law`: the run form;
  - `bridges`: the beginning and ending equivalences on listed occurrences;
  - `support`: H1–H3 met from `Listed`, and H4's tests.
- **The prose.** 08 §7's prose ("Seven are counting, below the grammar") changes with the figures. Say the row's statement still reads as counting on U4b's line, and that it is placed by its proof's reach and the reading, as the eight cases were.

## Verdict

The mathematics holds. The step form, the run form and the `Listed` case were checked in Lean with empty axiom reports and no decision of identity. The Identity case holds against the definitions. Derived is the right standing for `Listed.coming_of_ceasing`, on the precedent of `Law.drawn_iff_not_returns`, once the law is wholly on the root and the re-proof avoids the balance anchor (finding 2).

The design is not ready as written:
- **Before any record text:** fix finding 1, the stated reason for `CensusWebs.keep_pace`, which the design's own double-negation move refutes.
- **Before package Lean:** take findings 2–7:
  - name the lemmas that move and D5;
  - reuse `Steps.along`;
  - reconcile DESIGN-BOUNDARY §4 and the record's next step;
  - take the mirror by converse in its returning form;
  - scope the records' sentences;
  - fix the run form's indexing.
- **Findings 8–13** are small.

With the mirror taken by converse and joined to HE2's census count, rule 9 is met: one law, read both ways, generalizing the census of a step's count below it. Two of its cases are model laws proved apart today. Only one of them is a central row.

## Re-check, 1 November

AI-written second look at the revised design. It was read at worktree commit `f4adae3b6`, three commits past `b30f4abe6` that change only CENSUS-ON-THE-ROOT.md (the names accepted, the move decided, twenty records counted); the scratch is unchanged. Reading time: about ten minutes.

### What was read and run

**Read.**
- The revised design, including §6's decisions and §8.
- `u4c-scratch/Becoming/U4cCensus.lean`, `u4c-scratch/Becoming/U4cCases.lean` and `u4c-scratch/scratch-build.log`.
- The package around every claim of §3–§5:
  - Identity.lean, the `Counting` section :784–966 and the covering laws :1163, :1210, :1311;
  - Persistence.lean :219–229;
  - Population.lean :119–262 and :455–513;
  - Decidedness.lean :514;
  - Prelude.lean :248, :483, :500, :644 and :785–840;
  - Flow.lean :103 and :183;
  - Standing.lean :85–92;
  - GrammarLaws.lean :1658–1760.
- The two records the design amends, and the twenty it re-points.
- RESULT-WORKFLOW's "Hashes" and "Markdown drift", `tools/research/registry.py` :1006–1026 and `tools/research/repoint.py`'s header.

**Run.** All with Lean 4.29.1, against the scratch's own build (`LEAN_PATH` set to `u4c-scratch/.build`). Nothing was run in the package, and the checker was not run.
- **A closure walk** over constants, reading each declaration's type and value. It looked for the five anchors (`balance_over_stretch_on`, `balance_over_stretch`, `Flow.Balances`, `Flow.BalancesOn`, `Flow.BalancesBetween`) in:
  - the closures of the scratch's `coming_of_ceasing` and `balanceFrom_at`;
  - each of the fifteen package lemmas that move;
  - `mem_pairs`, `pair_mem` and `not_decide_iff`.
- **The same walk, listing modules:** for each moved lemma, every package constant outside `Becoming.Prelude` that it uses.
- **The proof routes:** whether the re-proofs use `mark_le_total`, `total_le_mark`, `total_swap`, `Listed.over_stretch` or `Listed.coming_iff_excess`.
- **Two linter probes:**
  - a section instance `omit`ted from one theorem and kept by a same-section caller;
  - an unused anonymous instance binder in a theorem's own signature.
- **Counts over `theories/becoming/results/records/*.json`:**
  - records that reference or bind the seven Lean files U4c changes;
  - records whose declaration lists name a moved lemma under its old module.

### What holds

**(1) The scratch states what the note says, and the certificates are real.**
- The step law (U4cCensus.lean:209) has exactly §2's hypotheses: `Distinct after`, `«定后»`, the doubly negated arising test and the ceasing test restricted to the units after. Its conclusion is the one §2 gives.
- The mirror (:242) is the step law at `«逆» R`, `«逆» E`, with the lists and tests exchanged.
- The run law (:257) has §2's four hypotheses from `T` on. Its hypothesis and conclusion are stated with `«屡»` on the lists, as §2 reads them.
- `census_count_of_halves` (:294) has HE2's hypotheses and gives HE2's count, as §3.4 says.
- The `rfl` certificates for `coming_of_ceasing` (U4cCases.lean:171) and `across_at` (:205) compare the package's types with the re-proofs' types in one environment. They are real: definitional equality of the statements is what a proof swap needs, and the landing keeps the package's text.
- The `balanceFrom_at` check (:253) applies the re-proof at the package's binders, the `R` instance included. It is real. The re-proof's statement, without the instance, is strictly more general.
- The build log matches:
  - U4cCensus has 26 theorems in 27 declarations, U4cCases 11 in 15;
  - `with_axioms` is empty for both, and `unclean` is empty.

**(2) No balance anchor, and the support list covers D2.**
- None of the five anchors appears in the closure of:
  - `coming_of_ceasing` (402 constants) or `balanceFrom_at` (308);
  - any of the fifteen moved lemmas;
  - `mem_pairs`, `pair_mem` or `not_decide_iff`.
- §2's sentence holds: `gaining_of_losing_from` goes through `le_over_stretch` (Prelude.lean:813), which has its own induction.
- The move is closed: apart from Lean's generated matchers, each moved lemma uses only the prelude and other moved lemmas.
- The re-proof of `coming_of_ceasing` names, beyond the root and the moved lemmas:
  - the two bridges;
  - `Steps.along_fixed`, and through the bridges `along_hasPred_iff` and `along_hasSucc_iff`;
  - the three list and test lemmas going to the prelude.
- The proposed `support` covers D2 once those three are root theorems. R2 renames one of them.

**(3) The claims of §3–§5, apart from R1 and R5.**
- **`across_at`.** The laws §3.2 names go through it: `across`, `over_stretch_on` and the stretch laws.
- **`balanceFrom_at`.** The seven laws §3.3 names go through it.
- **The covering laws.** Identity's covering laws do not go through `balanceFrom_at` (R5).
- **The re-proofs' routes.** `balanceFrom_at`'s re-proof no longer uses the continuing pairs (`mark_le_total`, `total_le_mark`, `total_swap`). `coming_of_ceasing`'s re-proof uses neither `Listed.over_stretch` nor `coming_iff_excess`. This is why R3 matters.
- **No moved lemma reaches a balance anchor.** This is true.
- **The twenty records.** §6 counts twenty on main. The same twenty name a moved lemma under its old module here.
- **`keeps_at`.** It keeps a user (`keeps`, Population.lean:483) after `across_at` leaves it, so nothing goes dead.

**(4) The step law's hypotheses are right.**
- The tests are monotone. Marking more units arising, or fewer ceasing, only weakens the bound. At `b ≡ true` and `e ≡ false` the law is trivial.
- The arising test is the weakest usable form: a predecessor among the units before, under a double negation. The ceasing test asks only about the units after.
- `Distinct before` is rightly not asked.
- In the run law, both directions of each test are used:
  - `begins.mpr` and `ends.mp` feed the step law;
  - `ends.mpr` feeds the endings' count;
  - `begins.mp` reads the beginning found.
- Reading `«屡»` on lists through two-argument relations is exact for both the hypothesis and the conclusion.
- The only slack is the global `«定后»`, which §2 already names. One sentence there is inexact (R9).

### Findings

#### R1. Should fix (before package Lean): dropping the instance from `balanceFrom_at` alone makes seven theorems warn, and the checker fails on warnings

- **Where.**
  - CENSUS-ON-THE-ROOT.md:119 ("The landing drops it from this theorem (`omit … in`) … That is the one change of statement: one fewer instance argument, every caller unchanged"), :163 and :178, and §8's row 12.
  - Identity.lean:793 declares `variable {W R} [∀ t g f, Decidable (R t g f)]` for the whole `Counting` section. Each of `Census.balanceFrom` :879, `balanceFrom_eq_at` :889, `balanceFrom_eq` :902, `arisingFrom_of_ceasingFrom_from` :912, `arisingFrom_of_ceasingFrom` :932, `ceasingFrom_of_arisingFrom_from` :940 and `ceasingFrom_of_arisingFrom` :961 names `R`, so each gets the instance automatically. Today each uses it only through `balanceFrom_at`.
- **What happens.** Once `balanceFrom_at` no longer takes the instance, all seven leave it unused. `linter.unusedSectionVars` then warns on each. The probe gave, for a same-section caller of a theorem with the instance omitted, "automatically included section variable(s) unused in theorem `caller`". check_becoming.py:4088 asserts that no `warning:` appears.
- **Why it matters.** The core run fails at Identity. The design's "one change of statement" is in fact eight.
- **Fix.**
  - Delete the instance from line 793 (`variable {W R}`), so all eight statements lose it at once. `omit … in` eight times is the same change, written eight times.
  - No caller changes. The only caller outside the section, `Persistence.persisting_census` (Persistence.lean:219–229), takes the instance in its own signature. An unused anonymous instance binder there raises no warning (probe), so it can stay as it is.
  - Say "eight statements each lose one instance argument" in §3.3, §5, "Not changed" and §8.
  - Take the record text in R3.

#### R2. Should fix (before package Lean): `mem_pairs` is already declared

- **Where.** CENSUS-ON-THE-ROOT.md:154 and U4cCases.lean:76. Standing.lean:89 already declares `theorem mem_pairs` in `namespace Becoming`, beside `def pairs` (:85).
- **What happens.** Moved into `Becoming.Prelude` in `namespace Becoming`, the lemma is `Becoming.mem_pairs`. Standing imports the prelude, so the build fails with the name already declared.
- **Why it matters.**
  - The core build fails.
  - The name also states a wrong meaning: the lemma is about `zs.map (fun a => (t, a))`, not about `pairs`.
- **Fix.** Name both lemmas for what they say, for example `mem_map_at` and `map_at_mem`, at claim time. Check the new names against every `Becoming.*` declaration before the patch series.

#### R3. Should fix (record text): the records' proof-route laws become false; one sentence each is not enough

- **Where.**
  - ceasing-needs-arising, law 2: "The proof goes through the census balance … the list at the end with what ceased between is the list at N with what came between". It declares `recurring_accumulates`, `Listed.over_stretch` and `Listed.coming_iff_excess`. After the re-proof, `coming_of_ceasing` uses neither of the last two (closure walk). It goes through the run law, a one-sided count over `le_over_stretch`.
  - census-balance-under-continuation, law 4: "The proof goes through the continuing pairs", declaring `mark_le_total`, `total_le_mark` and `total_swap`. The re-proof of `balanceFrom_at` uses none of the three.
  - The same record, law 3 ("with activity and the continuation decided") and the second hypotheses entry ("Decided activity, a decided continuation and decided 'continues some active formation' are hypotheses of the theorems"). After R1, a decided continuation is a hypothesis of none of the eight theorems. What they take is decided `Continues` and `Continued`. `Census.decideContinues` and `Census.decideContinued` are one way to get them.
  - CENSUS-ON-THE-ROOT.md:175–176: each record "gains one sentence".
- **Why it matters.** The records would state proof routes and hypotheses that the Lean no longer has.
- **Fix.**
  - In §5, rewrite these laws and the hypotheses entry rather than adding a sentence: name the routes through the root's census of a run and of a step, and their declarations.
  - Add a history note in each record, since a law's text and its declaration list change.

#### R4. Should fix (records and cost): the twenty need hand edits and history notes, and about 130 more records re-point

- **The twenty.**
  - registry.py:1018–1024 checks that each declaration a reference lists was elaborated in the module that reference is bound to. After the move, a Change, Flow or Population reference that still lists, say, `Becoming.recurring_accumulates` fails `research-check`.
  - `repoint.py` rewrites only hashes and receipts (its header), so each of the twenty needs its declaration moved by hand to a Prelude reference:
    - five have no Prelude reference to move it to: bounded-census-keeps-pace, ceasing-needs-arising, laws-of-one-step, rising-and-falling-in-one-exchange and support-from-the-supported;
    - in two, a Change.lean reference is left with no declaration: closing-needs-net-draw and orders-as-a-sum-over-histories.
  - A changed declaration list takes a history note (RESULT-WORKFLOW "Hashes"). EC2's notes of 21 October are the form: "declarations moved with their full names … The cited Lean source and its proof binding follow them; the claim is unchanged", in both languages (census-balance, laws-at-coarser-steps).
- **The rest.** Lean sources are bound by their exact bytes. So every record that references a changed module drifts:
  - 133 records reference Prelude, GrammarLaws, Population, Change, Flow, Identity or Arising;
  - 118 of them bind one of those modules to a receipt, 90 of them the Prelude.
  - These are bookkeeping re-points: `repoint.py --paths … --receipt … --lean …` after reading each changed source, logged in one `rebinds.jsonl` line. EC2 and EC4, landed together, re-pointed 138 the same way.
- **Why it matters.**
  - §6 counts twenty and calls them re-points, which reads as the tool's bookkeeping.
  - The hand edits and their notes are the part that needs reading.
  - The re-point pass is shared with OU7's rebuild, so someone must own it.
- **Fix.**
  - In §6, name both kinds: the twenty edited by hand with EC2's note, and the rest re-pointed by the tool against the shared receipt, recounted on the landing tree.
  - Say which owner runs the shared re-point pass.

#### R5. Minor: Identity's covering laws are census laws that are not cases

- **Where.**
  - U4cCases.lean:25: "Every census law of Identity is proved through it."
  - CENSUS-ON-THE-ROOT.md:119: "So Identity has one route to the root, through the step, not two."
  - §0 (:20) and §3.5 (:127) name only Locality's covering law.
  - Identity's `not_not_arisingFrom_covered` :1163, `arisingFrom_not_stopping_covered` :1210 and `ceasingFrom_not_stopping_covered` :1311 go by lineages and `length_le_of_matched`, not through `balanceFrom_at`. census-balance-under-continuation's laws 10–11 cite them.
- **Fix.**
  - Scope both sentences to the `Counting` section.
  - Add the three to §0's "does not reach" and to §3.5, beside Locality's covering law.
  - Scope census-balance-under-continuation's new sentence to `balanceFrom_at` and the seven laws through it, so that it does not read over laws 10–11.

#### R6. Minor: `Counts.listed_across` is the census of a step in the identity reading, proved apart

- **Where.** Decidedness.lean:514. It proves the census across a step, with counts as relations, by its own search under a double negation.
- **Why it matters.** It is a case of the two halves by content, in the same way as `Web.arisesFrom_of_more`: tests can be had under the double negation, as §4 argues for `keep_pace`. Unnamed, it is a parallel proof that the design does not mention.
- **Fix.** Name it in §3.5 as a case by content that is not re-proved, as `arisesFrom_of_more` is named.

#### R7. Minor: `run_needs_fixedAfter` leaves out the tests

- **Where.** U4cCensus.lean:408. The statement has no `begins` and `ends` conjuncts, unlike `run_needs_predecessorsBefore` (:377–378). The docstring and §2 (:82) say that every `y` ends and that nothing listed after a step begins.
- **Why it matters.** As stated, the witness does not show that every other hypothesis of the run law holds.
- **Fix.** Add the two conjuncts at `b := fun _ => false` and `e := fun x => !x.2`:
  - `(t, true)` continues, so it does not end;
  - `(t, false)` ends;
  - every unit listed after a step has the predecessor `(t, true)`, so none begins.

#### R8. Minor (before package Lean): what the move to `Type u` takes, and §5 against §6

- **The proofs.**
  - The scratch's copies use `GrammarLaws.mem_cons_split` (U4cCensus.lean:35, :38, :73), which the prelude cannot use.
  - The package's proofs use `mem_cons_cases` (Prelude.lean:500), stated at `Type` in section `Lists` (`variable {α β γ : Type}`, :483).
  - Generalizing `mem_remove`, `length_le_of_matched` and `not_not_all` to `Type u` therefore needs one of two things:
    - `ListTests.mem_cons_iff.mp` (Prelude.lean:248, at `Type u`) in their proofs;
    - or `mem_cons_cases` generalized too, which is a fourth changed statement, against §6's "the only statements the move changes".
  - They must also sit after `Distinct` (:644), in a `Type u` section.
- **§5 against §6.**
  - CENSUS-ON-THE-ROOT.md:149 generalizes "where they are stated at `Type`", which also covers `total_pos`: Flow.lean:103 gives `{α β : Type}`, and the scratch keeps `{γ : Type}`.
  - §6 generalizes only three.
- **Fix.**
  - In §5, name the three and say the rest move verbatim.
  - In the patch series, use `ListTests.mem_cons_iff.mp`.

#### R9. Minor: one inexact clause on `«定后»`

- **Where.** CENSUS-ON-THE-ROOT.md:62: "so the law takes it, as the census section's other laws do". `GrammarLaws.census_pairs` (GrammarLaws.lean:1670), on which HE2's census rests, takes the local form: no split among the units listed.
- **Fix.** Say "as HE2's census does". Optionally state the step law in `census_pairs`'s local form:
  - its proof needs only that form (match into `keep (! e) before` with membership in the matching relation);
  - each case meets it directly;
  - `balanceFrom_at`'s no-split at `t` already is that form.

#### R10. Minor: OU7 should not wait on U4c's stage

- **Where.** §6, steps 4–5: U4c lands as one stage of `land_ou7.sh`.
- **Why it matters.** R1 and R2 are the kind of failure that appears only in the core run. As written, a failing U4c stage holds OU7's slot.
- **Fix.** Say in §6 that if U4c's stage fails the dry run, OU7 lands without it, and U4c takes the next core slot.

### Verdict

The revision takes all thirteen findings, and its mathematics holds:
- the laws, the witnesses and the three re-proofs are checked with empty axiom reports;
- the re-proof of `Listed.coming_of_ceasing` reaches no balance anchor;
- with the moves, the support list meets D2.

Derived remains the right standing for that row.

Four things should be fixed before the patch series:
- R1 and R2 would each fail the core build;
- R3 would leave two records stating proof routes and a hypothesis the Lean no longer has;
- R4 would fail `research-check` at twenty records unless they are edited by hand.

R5–R10 are small. With R1–R4 taken, the design is ready for package Lean.
