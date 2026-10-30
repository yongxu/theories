# Review of U4, lever 1 (design and scratch), adversarial

Reviewer: independent, read-only. Worktree `wt-u4`, branch `u4-edge`.

**Version reviewed.** The design changed while this review was running. The review covers HEAD `b59e91471`: DESIGN.md (146 lines, with §2.7 re-pairing), `scratch/Becoming/U4Scratch.lean` (unchanged since `90716974d`) and `scratch/Becoming/U4Repairing.lean`. An untracked `scratch/Becoming/U4Bridge.lean` (17:02) appeared mid-review. It is work in progress, it fails to compile, and it is **not** reviewed here (see F15). Paths below are relative to `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/` for the design, and to `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/` for the package.

## Verdict

**Sound with fixes.** The Lean is correct, and every statement checks. Both committed modules build, with every axiom report empty. Most of §2 describes the Lean accurately. The verdict prose (§0, §3 (i), §5, the F13 sentence) claims a derivation that the scratch does not give. By the design's own `balances_at_iff_census`, the census hypothesis, closed existentially, *is* balance at a step, and the model is built from the numbers. That is the representation U1 and F13 already have. Two blocking findings concern this framing. The rest are scope and precision fixes.

## Findings

### F1 (blocking): "derived", "not a supplied equation", "the census of the root's «生» and «亡»"

**Design sentences:**
- §0 l.10: "as a derivation: it holds wherever …".
- §0 l.21: "Under this premise balance is derived".
- §0 l.23: "What the lift adds is a root reading of each condition's balance at a step: not a supplied equation, but the count of a census of the root's `«生»` and `«亡»` under `«定后»` and `«定前»`. F13's reason, 'balance needs amounts', becomes 'balance is what a one-to-one census counts'."
- §3 (i) l.100: "`balances_at_of_census` derives it from one-to-one continuation."

**What is wrong.**
1. **The premise is the conclusion, restated.** `balances_at_iff_census` (U4Repairing.lean:186–207) proves that a condition's balance at a step holds exactly where *some* one-to-one model exists with `level = length`, `given = |arising| + passing` and `taken = |ceasing| + passing`. That model is built from the four numbers (`census_counts`, l.164; `census_model`, l.119). This is the same shape as `Flow.balances_iff_units` (Flow.lean:331–336) and `«守数当且仅当可对»`. The package calls those "the matching is supplied, built from the numbers, not derived from the unfolding" (Flow.lean:335; GrammarLaws.lean:66–69). For a model in hand, the bridge equalities are balance restated relative to the census. I checked this independently (Lean via stdin, Init only):
   ```lean
   theorem bridge_iff_balance (B A ar ce g tk : Nat) (census : A + ce = B + ar) (cover : ar ≤ g) :
       (A + tk = B + g) ↔ ∃ p, g = ar + p ∧ tk = ce + p   -- checks
   ```
   So `balances_at_of_census` (U4Scratch.lean:489–498) replaces one supplied equation with two supplied equations and a free `passing`. Its only content beyond arithmetic is `census_balance`. That is `Census.balanceFrom_eq_at`'s equation, already in the package (Identity.lean:889), here with a pairing behind it (`census_pairs`, which is new).
2. **`arising` and `ceasing` are not `«生»` and `«亡»`.** They are `keep` filters on a Bool `k` over lists (U4Scratch.lean:393–396). `«生»` and `«亡»` are predicates of `«续» R E` (Grammar.lean:132–135). §4 l.117–119 says the bridge is left for the leaf, but §0 states it as done.
3. **WHAT-REMAINS:104 already says where content can come from.** "Content can only come from a relation of the unfolding that restricts which pairings exist." Here `k` is a free relation on a free carrier, so the model does not come from the unfolding.
4. **"The numbers are still a second sort" contradicts "F13's reason … becomes".** The levels, given and taken stay `Nat`, equated to list lengths by hypothesis, and the grammar still has no amounts.

**Fix.**
- Say: "At a step and condition, balance is represented both ways as the existence of a one-to-one census model (`balances_at_iff_census`). For a model in hand, one-to-one continuation together with the bridge equalities gives balance (`balances_at_of_census`), and the bridge equalities are balance restated relative to the census. It becomes a derivation only once the model is a World's own occurrences under `«续» R E`, which is the open bridge."
- Drop "not a supplied equation". Keep F13's reason as standing.

### F2 (blocking): the verdict does not follow its own test, and U1 §7 is quoted with its operative quantifier elided

**Design sentences:**
- §0 l.7: the headline "Balance is the count of a census of units continuing one to one".
- l.23: "U1's verdict stands, and is sharpened. Its §7 named the condition …: 'a line law … reads something the counts do not'".
- §3 l.102: "(ii) Not met as a law; met as a premise."

**What is wrong.**
- **The test.** It is "The lift counts only if two things hold … If either fails, U1's verdict stands and the failure is written here" (ou3b…/WHAT-REMAINS.md:245). §2.7 and §3 find that (ii) fails as a law. "Met as a premise" is not a pass of (ii), so the outcome is U1's verdict standing, with the failure written down. The §0 headline reads as a lift.
- **The ellipsis.** It removes "over every selected matching (unique origin, Little's law)" (u1…/DESIGN.md:147). That is exactly OU's re-pairing condition, which the design applies correctly in §2.7 and §6 l.143. Quoted in full, U1 §7 is not met, which is the design's own finding.
- **U1's frames are one to one already.** In U1 every selected matching is a frame *bijection* (`FrameMatch`, `kunits_iff_balances`, u1 DESIGN.md:53). Restricted to before→after, it is one to one by construction. So the census premise holds of every U1 selection, and there the census reads only counts. `compensation` lies outside U1's selections. "Sharpened" needs that said.

**Fix.**
- Lead §0 with: "The round trip fails at (ii) by OU's condition; U1's verdict stands." Then list what lever 1 adds as by-products:
  - `«对则闭域守数»`;
  - the class law;
  - `census_pairs` behind the census equation;
  - the place reading as one pairing;
  - `same_counts_other_lines` showing one-to-one continuation is a premise not fixed by counts.
- Quote U1 §7 in full.
- State that `balances_at_iff_census` is `kunits_iff_balances` read in census vocabulary (four blocks: stay, cease, arise, pass) at one condition and step.

### F3 (should fix): §0 l.7 and §1 l.27: "the 31 … all read `Flow.Balances` or `Flow.BalancesOn`"

**What is wrong.** The measure tags "balance" by dependence on any of `Flow.Balances`, `Flow.BalancesOn`, `Flow.BalancesBetween` and `balance_over_stretch_on` (ec-elegant-completion/measure.py:23–24). I spot-checked 13 of the 31:
- **Read no flow:**
  - `Listed.coming_of_ceasing` (Population.lean:609) rests on `balance_over_stretch_on` (Population.lean:511).
  - `CensusWebs.keep_pace` (Listing.lean:1057, via `CountsAcross.keep_pace`, Decidedness.lean:438) rests on it through Decidedness.lean:410.
  - `RegimeMargin.ends_iff_below` (RegimeMargin.lean:674) is stated on the scalar `Law.run (step A H)`, with no flow in its statement.
- **Read only `BalancesBetween`:** `Optimum.optimum_beyond` (Optimum.lean:1551) reads it through `Outcome` (Optimum.lean:1027–1028).
- **Read `Balances` or `BalancesOn` as claimed:** `counterfactual_is_course` (Counterfactual.lean:629), `apart_only_downstream` (Observation.lean:292), `World.balanced_reidentify_iff` (Persistence.lean:534), `Flow.change_recurs_iff` (Locality.lean:320, via `RunsDownOn`, l.203–205), `Embodied.replenishes`, `Transmission.no_new_dependence`, `Reproduction.Flow.lineage_ends`, `GroupEnding.Flow.family_childless`, `Balances.retains_iff_within_margin`.

The two census rows count comings and ceasings of a listed family. They are the rows the census pairing reaches most directly: each member continues only itself, so `census_pairs` applies with `k` as identity on the listed members. The design misses them. The board line of `e9804332e` on main repeats the inaccurate sentence.

**Fix.**
- Recount by anchor, and name the rows that rest only on `balance_over_stretch_on`.
- Consider one of the two census rows as the transport trial in §5.
- Correct the board line.

Section 1's second claim stands for every row checked: `Continuity`'s locality reaches none of them directly.

### F4 (should fix): §3 (ii) l.103–104: "locality is not the extra. The extra is one-to-one continuation: `compensation` shows counts do not read it"; §0 l.14

**What is wrong.**
- **Locality detects `compensation`.** Its own proof is a count on a region closed both ways under the continuation (`splitRegion`, U4Scratch.lean:524, 531–549, through `«对则闭域守数»`). So what lines read there is locality at the grain of the continuation's regions, which the World does not fix. "Locality is not the extra" holds only at the place grain.
- **One-to-one is sufficient, not necessary, for the census pairing.** I checked a counterexample (Lean via stdin, local copy of `«对»`):
  ```lean
  def k (g f : Nat) : Bool := (g == 0 && (f == 2 || f == 3)) || (g == 1 && f == 2)
  -- 0 splits into 2 and 3, 2 merges 0 and 1, nothing arises or ceases, yet
  -- Pair (fun x y => k x y = true ∨ x = y) [0, 1] [2, 3] holds (0↦3, 1↦2). No axioms.
  ```
  So the pairing does not read one-to-one continuation either. What lines read and counts do not is whether a pairing under continuation exists (a Hall-type condition). One-to-one continuation is one sufficient condition for it.

**Fix.** Restate (ii): "what unit lines read beyond counts is the existence of a pairing under continuation, detected in `compensation` by a count on a continuation-closed region; one-to-one continuation is sufficient for it, not necessary, and neither is fixed by the counts."

### F5 (should fix): §0 l.12: "Each hypothesis is shown to be needed"

**What is wrong.**
- **`Distinct before` is not witnessed.** I checked a counterexample (stdin, local copies of `keep`, `arising`, `ceasing`): `before = [0, 0]`, `after = [1]`, `k = (g == 0 && f == 1)`. No split and no merge among the listed units, `arising = ceasing = []`, and `1 + 0 ≠ 2 + 0`.
- **`teleport` is not a hypothesis witness.** It witnesses no hypothesis of `census_pairs` or `balances_at_of_census`. It separates `«一»` from `«静»` in the place reading.
- **"Listed once" is not needed in `balancesOn_iff_place`.** With a condition repeated `m ≥ 1` times, per-element counts are `m·(level + given)` against `m·(level′ + taken)`, and cancellation recovers balance.

**Fix.** Add the duplicate witness. Say what `teleport` witnesses. Either drop "listed once" from the place reading or say it is used for convenience only.

### F6 (should fix): §0 l.7–10 and §2.4 l.55: the two readings, and their scope

**What is wrong.**
- **Scope.** `balancesOn_iff_place` is about `BalancesOn W cs t` over a listed family at one step (U4Scratch.lean:293–307), not about `Flow.Balances` (∀ t c over a possibly unlisted `C`). No corollary for `Flow.Balances` is stated.
- **The place reading is a repackaging.** It is content-equivalent to `Flow.balancesOn_iff_units` (Flow.lean:383), and by the design's own class law it is per-place Hume's principle, the "near-definitional" case WHAT-REMAINS:104 names. It gives one pairing with fixed lists in place of per-condition existentials, which is a gain in form, not content.
- **The readings are not joined.** They are on different carriers. Place "units" are copies of condition labels with no identity, so continuation is undefined on them. The census is per condition, so a unit moving between conditions is "ceasing" at one and "arising" at the other. For example, a teleport with `taken = 1` at `0` and `given = 1` at `1` passes the census at each condition. Neither reading sees transfers, and no theorem relates them, for example through a unit model with a place map `π : U → C`.

**Fix.**
- State the scope as `BalancesOn` over a listed family at a step.
- Call the place reading equivalent to `balancesOn_iff_units`, which a one-line corollary can show.
- Add to §4 that the two readings are not joined and that the per-condition census does not read transfers.

### F7 (should fix): known package results not related

- **`World.balanced_reidentify_iff`** (Persistence.lean:526–534; one of the 31) is not cited. Its docstring reads: "The namings under which a world balances are exactly its one-to-one continuations within conservation". It is the package's existing join of balance and one-to-one continuation, at the relatum grain.
- **`Flow.balances_of_matched`** (Flow.lean:348) is not cited. `balances_at_of_census` is its corollary: take `census_pairs`, add `passing` units on both sides paired by sameness (`«对之并»`), then apply `«对则守数»`.
- **`Census.balanceFrom_eq_at`** (Identity.lean:889) concerns formations active under `R t` on a web. `census_balance` is "the same equation" on bare lists, but no instance theorem joins them.

**Fix.** Cite each result. Say what the census adds over it, or prove it as a case.

### F8 (should fix): modelling assumptions not stated

The laws depend on:
- natural-number amounts (`place` is `replicate`; levels, given and taken are list lengths);
- discrete steps (`t`, `t + 1`);
- finite listed units and conditions;
- Bool-decided continuation (`k`) and equality (`eq`, `dec`);
- `Nat` labels for units (`balances_at_iff_census`);
- equality on the unit carrier inside the pairing relation `k ∨ =` (U4Scratch.lean:405). Grammar.lean:37 says equality on the carrier is a commitment of the model.

The design names listing and decided tests. It never names natural-number amounts or discrete steps, and the census reading rests on both (U1 §0 names the atomism as resting on natural-number amounts).

**Fix.** Add one line in §0 or §4 naming each assumption.

### F9 (minor): §2.2 l.38–42, the class law and its cases

- "Sameness" and "the class of being at one place" are one instance in the scratch: `E := «静»` on `C`, inside `balancesOn_iff_place`. No standalone sameness corollary exists. `teleport` and `nat_same_class` do not use the class law.
- §0 l.16 says "reads nothing beyond counts". It should say "beyond per-class counts", for a class decided by a test. Under `«静»` the per-class counts are the whole multiset.
- The law itself is correct: `«类之对当且仅当类类等数»` (U4Scratch.lean:138) is a two-way statement with exactly the stated hypotheses.

### F10 (minor): §2.3 heading "(the proposal's (a))"

The proposal asked for `«所闭»` (WHAT-REMAINS: sub-claim (a)). The scratch states `«闭»` regions (`closes_iff`, l.180; `balancesOn_iff_closed`, l.190). The two agree on conservation over a finite listed set, but that equivalence is not proved. Say `«闭»`.

### F11 (minor): `census_pairs_of_fixed`

It uses global `«定后»` and `«定前»` over all of `U`, while `census_pairs` uses the local, listed form (U4Scratch.lean:402–404 against 470–476). Following GrammarLaws' convention, say the global form is a corollary of the local one.

### F12 (minor): §3 (ii) l.106, "F1 is the relational representation forgetting the located units"

No Lean ties `place` or `countIn_place` to `WorldRepresentation` or `World.standingAt_alike` (WorldRepresentation.lean:437). Label the sentence a reading, or add the one-line separation through the representation.

### F13 (minor): `«续之对则类类等数»` (U4Scratch.lean:206)

It is a corollary of `«对之单调»` and the class law. It adds to equal count only where `E` is finer than `«一»`. Cite `teleport` (with `E = «静»`) as the witness that it adds something there.

### F14 (minor): names and placement

- **`compensation`.** The word has a financial and social sense. A structural name, such as `split_merge_balanced`, fits the naming rule. The names are provisional.
- **`countIn`.** It would be a new shared definition beside `«对»` in GrammarLaws, which is OU's to decide.
- **"The census pairing, stated on `«续» R E`"** (§5 l.135). This presupposes the open bridge.

### F15 (minor): build provenance

- **The cited base.** Header l.3 says "built … against main at `3a728388e`". That commit is not an ancestor of HEAD. The build ran against this worktree. The package files in `Becoming/` are identical between `282fda08f` and `3a728388e` (empty `git diff --stat`), so the result holds, but the sentence should say what was built.
- **The new bridge module.** The untracked `U4Bridge.lean` makes a whole-tree `scratch_build.py` run fail. It failed in `Becoming.U4Bridge` with an unsolved goal `(fun g => k g f) g = false`. Before citing a new log, build with module names or keep the module passing.

## What I checked and found right

- **Build.** `python3 -B scratch_build.py <scratch> Becoming.U4Scratch Becoming.U4Repairing` gave 0 failures and 0 unclean.
  - U4Scratch: 43 theorems in 51 declarations, `with_axioms: {}`.
  - U4Repairing: 15 theorems in 18 declarations, `with_axioms: {}`.
  - Steps were restored from the shared cache keyed on source bytes. The audit file lists every declaration.
  - Imports are `Becoming.GrammarLaws` and `Becoming.Continuity` (core modules).
- **Statements matching their sentences:**
  - `«对则闭域守数»`, its primed form and `closed_both`;
  - the class law, both directions, with its hypotheses `«类» E` and a Bool test;
  - `one_case` as `«一之对»`;
  - `teleport`;
  - `closes_iff`;
  - `balancesOn_iff_closed`, a faithful restatement of `Continuity.balancesOn_iff_conserved`, which the design honestly says reaches none of the 31;
  - `balancesOn_iff_place`, two-way as claimed (levels recovered through `countIn_place` and `total_pick`);
  - `census_pairs` and `census_pairs_of_fixed`, with `«定后»` = no unit continues as two and `«定前»` = no two continue as one (GrammarLaws.lean:691–699);
  - `census_balance`;
  - `balances_at_of_census`, whose hypotheses are exactly as §2.5 states.
- **Witnesses.** `compensation` is correct: `arising = ceasing = []`, `«一»` pairing, no `k ∨ =` pairing, and the region `{0, 3, 4}` holds 1 before and 2 after. `split_breaks` and `merge_breaks` are correct, with no pairing under any relation, by length.
- **Re-pairing.** `same_counts_other_lines`, `census_model`, `census_counts` and `balances_at_iff_census` are correct. The §2.7 table's classification of which laws are invariant under re-pairing is right.
- **Honest limits.** §1's second claim holds: `Continuity`'s locality reaches none of the 31 directly, since the rows' flows are `Flow F C` with formations apart from conditions, not `Continuity.flow`. §4 states honestly that the bridge to `«续» R E`, the cross-step model, formations, Hall's condition and the known results (multiset equality, Gale/Hoffman) are left open.
