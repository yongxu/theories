# Review of the RF round 1 Lean (GPT astra, high effort, read-only, 29 October 2026)

Evidence for the [RF plan](../PLAN.md): an independent cross-model review of the three round 1 modules before landing, returned verbatim with its run footer (absolute links made repository-relative). Every finding was taken; the table after the review says how. Its brief is in [BRIEF.md](BRIEF.md).

**Verdict: revise the prose before landing; the core mathematical statements appear sound on static inspection.** I reviewed all 42 theorem declarations and their proofs: 27 in ShownOrder, eight in Unread, seven in Cascade. The main problems are claims stronger than the formal results, one unnecessary hypothesis, and duplicate witness propositions. The cascade indexing is correct, and the executable search witness does produce the stated choices. The supplied logs report empty axiom reports; I did not independently compile or audit them.

Locations below refer to [ShownOrder.lean](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/tree/Becoming/ShownOrder.lean), [Unread.lean](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/tree/Becoming/Unread.lean), [Cascade.lean](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/tree/Becoming/Cascade.lean), and [PLAN.md](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md).

**1. High — Identification of positive comparisons becomes identification of objectives and goal misgeneralization.**

**Location:** ShownOrder:9–12, 23–26, 45–55; PLAN §4.1 readings and line 105.

“What the choices fix is the shown reach” is exact for **positive pairwise comparisons common to every according strict partial order**. It is not a characterization of everything logically fixed: irreflexivity and reverse-edge exclusions are also fixed. Nor does it identify an actual installed objective.

“Two installed orders … choose differently” exceeds the general relation theorems. The finite `Untried` witness supplies executable searches, but no installation process. “Locates goal misgeneralization exactly … every pair the courses leave unjoined” additionally turns possible ambiguity into actual failure. Some unresolved comparisons may be irrelevant to deployment.

**Replace the general summary with:**

> “For acyclic shown choices, the positive comparisons shared by every according strict partial order are exactly the shown reach.”

**Replace the inner-alignment reading with:**

> “[AI reading] If training observes only these choices and imposes no further restriction on the candidate orders, comparisons between distinct alternatives unreachable from one another remain ambiguous. `Untried` realizes different subsequent choices with one search procedure and two compatible orders. Installation by training and disagreement with an independently specified task objective are not proved.”

For IRL/assistance, replace “serving … is the helper’s own completion … never learned” with:

> “A positive comparison beyond the shown reach requires information or assumptions beyond these strict-choice constraints.”

PLAN’s outer criterion is a reasonable proposed interpretation, but is not represented in the witness’s theorem statements.

**2. Medium — Maximality is not equality, and it still excludes comparisons.**

**Location:** ShownOrder:35–37, 53–55, 251–257; PLAN §4.1.5.

`AccordsWeakly` means no available alternative stands above the pick. Under a strict partial order, alternatives can be incomparable without being equal or tied under an additional indifference relation. Thus “Choices among equals” misdescribes the general setting. “Choices among equals show nothing” also drops the negative information explicitly acknowledged elsewhere.

**Use throughout:**

> “Choices required only to be maximal force no positive strict comparison: the empty strict order weakly accords with every choice. They still exclude any available alternative standing above the chosen one.”

The empty-order witness prevents an empty-class vacuity here. `AccordsWeakly` itself is accurately named and defined.

**3. Medium — The new-menu theorem does not establish a choice; the non-top theorem proves less than its heading.**

**Location:** ShownOrder:152–161 and 240–249; header:31–32; PLAN §4.1.3–4.

`top_in_every_iff_reach` assumes neither `N x` nor a choice procedure. Both sides hold when `N` is empty, including when `x` is unavailable. Its body describes the formula accurately, but “the choice is fixed” does not.

**Replace its heading with:**

> “Uniform strict dominance over a menu is exactly reach to each distinct available alternative.”

**Add:**

> “This does not assert that `x` is available or chosen; interpreting it as a feasible choice additionally requires `N x` and the stated choice rule.”

`not_top_of_unreached` concludes only `¬ P x y`, whereas its heading and module header say that `y` stands above `x`. Its proof constructs the stronger witness but discards `P y x`.

For the existing statement, **drop `apart : y ≠ x`** and choose `P := «及» ch.Shown` directly. Use:

> “If the acyclic shown relation does not reach `y` from `x`, some according strict order does not put `x` above `y`.”

If positive reversal is intended, cite `above_in_some_of_unreached` with arguments reversed and retain distinctness. There is little reason for another declaration duplicating that specialization.

**4. Low — Two statements can cheaply match their stronger descriptions; one witness has unnecessary order hypotheses.**

**Location:** ShownOrder:168–188, 291–301, 307–311.

`reach_withPair` proves only the forward direction of its normalization description. The reverse follows by embedding old paths and composing with the added edge. The natural statement is:

```lean
«及» (withPair R x y) a b ↔
  «及» R a b ∨
    ((a = x ∨ «及» R a x) ∧ (y = b ∨ «及» R y b))
```

This requires no acyclicity or decidability.

`reach_first_second` proves endpoint constraints, not an explicit one-step characterization. Either strengthen it to the corresponding iff, or replace its docstring with:

> “Every shown reach starts at the first alternative and ends at the second.”

`met_fixed` needs neither irreflexivity nor transitivity: `occasions.Accords P → P .first .second` follows immediately from the observed menu. Prefer that stronger statement and say “Every according relation,” or retain the current theorem explicitly as a specialization illustrating the general result.

**5. Low — `search` is correct, but its description needs the failure case and scope.**

**Location:** ShownOrder:342–352; PLAN §4.1 witness.

Yes: `same` implements equality on `Alt`; `List.all` tests dominance over every **distinct alternative value** in the list; `find?` returns the first listed value passing that test. Repeated occurrences of the same value do not require self-dominance.

However, the procedure can return `none`, and its carrier is specifically `Alt`.

**Replace the docstring with:**

> “For any Boolean comparison on `Alt`, return the first listed alternative standing above every distinct listed alternative, or `none` if there is none.”

Both strictness proofs, `both_accord`, and the two search evaluations match their statements. No general theorem connecting `search` to arbitrary `ChoiceOccasions` is present.

At ShownOrder:67–69, replace “nothing is decided” with:

> “The general relation theorems require no decidability; the finite search witness uses explicit Boolean comparisons.”

**6. Medium — Unread’s twin summaries omit decidability; the hypothesis can be localized.**

**Location:** Unread:19–25, 75–99; PLAN §4.2.2.

Both `free_lumped` and `twin_selected` require `[DecidableEq K]`. Their docstrings and the header’s twin paragraph omit it, although the plan includes it.

**Begin both descriptions with:**

> “With equality of lump values decidable, where no read occasion is lumped with `x`, …”

The proof only needs to decide membership in the target fiber. A weaker signature can replace global decidable equality with:

```lean
[∀ i, Decidable (π i = π x)]
```

and branch on that proposition. No decidability of the reading schedule or finite data is needed.

`Free` can hold vacuously when there are no act laws, and singleton outputs admit no different twin. The current “a twin acting otherwise” qualification correctly requires another value; keep that qualification attached to every behavioral interpretation.

**7. High — Distinct states do not establish detection of evaluation.**

**Location:** Unread:26–30, 42–44, 109–119; PLAN §4.2.4.

The two factorization theorems correctly prove contrapositives of congruence. They contain no reading-status predicate, detector, or requirement that the occasions differ only in evaluation status. Two acts can differ because content differs while evaluation status is wholly inaccessible.

**Replace the general chain with:**

> “For fixed deterministic maps from coupling to state to act, different acts require different states, and different states require different coupling values. Reading these differences as sensitivity to evaluation requires a separate correspondence controlling other differences between occasions.”

The concrete `Cue` examples hold content fixed and can support that limited reading. Their interpretation should not be promoted to the unrestricted factorization theorems.

**8. Medium — The two Cue counterexamples are definitionally identical, and `honest` is an unsupported name.**

**Location:** Unread:133–134, 157–169.

After unfolding `honest`, `detected_unacted` and `detectable_undetected` assert the same conjunction: the two pairs differ, while their second projections agree. The two intended interpretations assign different roles to the same maps; the propositions do not distinguish those roles.

**Fix:** retain one lemma, for example `cue_apart_content_alike`, with:

> “The occasions `(true, true)` and `(false, true)` differ, while their contents agree.”

Explain its two uses as the assignments `coupling=id, state=id, act=Prod.snd` and `coupling=id, state=Prod.snd`. Separate declarations would be justified by explicitly represented factorization witnesses, not duplicated propositions.

Rename `honest` to `contentAct`, with:

> “The act law returning the occasion’s content.”

No truth target, sincerity, or intention makes “honest” a formal property here.

**9. High — “Survive every selection exactly where” drops essential quantifiers and hypotheses.**

**Location:** Unread:31–40, 49–51; PLAN §4.2 witness/readings.

`twin_selected` requires a selected base law. It cannot imply survival under a selection rejecting everything. Nor does the module prove an unrestricted constructive equivalence between failure of coverage and a different surviving twin.

**Replace the survival claim with:**

> “Given a selected base law reading through `π`, decidable lump equality, and an occasion whose lump contains no read occasion, every prescribed value there is realized by another selected law agreeing with the base law on all readings. A different value gives a different twin. Where a read representative exists, such agreeing laws must agree at the target occasion.”

Use the same qualifications for ELK. Also add:

> “This is an identification limit for reporters; latent knowledge and its relation to reporting are not represented.”

The finite-data equivalence in Unread:13–18 is already correctly qualified.

**10. Medium — Correctness hypotheses are sufficient globally, not necessary globally.**

**Location:** Unread:40–42, 149–155; PLAN §4.2.3.

“The acts fixed are right only where … the world goes alike across the lumping” treats `lumped_world_right`’s sufficient global hypothesis as necessary. For a particular target, correctness needs agreement between that target and the observed representative; the world may violate lumping elsewhere.

**Replace with:**

> “For a law fitting the observed values, transfer to an occasion sharing a read representative is correct exactly when the target world agrees at those two occasions (`lumped_right_iff`). Global lumping of the target world suffices (`lumped_world_right`).”

`Cue.unseen_fixed` states determination between laws, not correctness, and does not directly state the within-law equality highlighted in its opening sentence.

**Replace its docstring with:**

> “Among act laws reading only the content, agreement on all read occasions determines the act at `(false, true)`.”

**11. Medium — Coverage and refinement need exact scope.**

**Location:** Unread:52–54.

“Capability … narrows where they do” suggests strict loss and treats capability as a defined refinement. Neither is established. A finer lumping may leave coverage unchanged.

**Replace the paragraph with:**

> “If every occasion shares a lump with some read occasion, agreement on the readings determines acts everywhere. Refining a lumping cannot create a read representative for a previously uncovered target fiber, although it need not remove any. Interpreting refinement as increased capability is an additional correspondence.”

The unconditional coverage formulation also avoids a constructive case split on whether an arbitrary occasion is read.

**12. High — Cascade’s opening and readings claim necessity and general dependence results not proved.**

**Location:** Cascade:7–10, 27–35; PLAN §4.3 readings.

“A pool reads … all … only where each member’s act carries its own coupling forward” is false as a necessity statement: another member may already carry the same information. The cascade theorem supplies an upper bound, not exact pooled reach.

“Votes that read one another’s votes reach no more than the votes read first” is false without the own-coupling independence hypothesis. Reading earlier acts does not prevent using a fresh signal.

**Replace the opening with:**

> “Sequential acts can discard distinctions available in the members’ couplings. If every member from `k` onward ignores its own coupling, every finite act prefix is invariant between worlds agreeing on the first `k` couplings.”

**Replace the Condorcet reading with:**

> “[AI reading] Copying illustrates dependence that adds no distinctions beyond the first member’s signal. This module proves no probabilistic accuracy or majority-convergence theorem.”

For echo chambers, use:

> “[AI reading] Under the stated cascade premise, increasing membership need not add distinctions beyond the initial coupling prefix.”

The AI-reading labels are present; the labels do not repair these scope excesses.

**13. Medium — `separates_at` is conditional transport, and restricted earlier-act access is already representable.**

**Location:** Cascade:19–22, 119–125, 37–41.

“Reach returns only through” suggests a necessity or recovery theorem. `separates_at` assumes that the law already distinguishes the actual coupling values at one shared history, then transports that inequality.

**Replace its heading and header summary with:**

> “Law-level distinction gives distinct acts at a shared earlier history.”

The statement can cheaply become an iff under `before`, but it still establishes no acquisition or restoration mechanism.

Delete “networks where members read only some earlier acts” from the representation limitations. `law` can ignore arbitrary entries of its input list.

**Use instead:**

> “The interface supplies the whole earlier-act list; restricted access can be represented by laws that ignore entries, but no separate access graph or topology theorem is developed.”

**14. Low — Cascade definitions and indexing pass; the cascade premise is deliberately stronger than reachable behavior.**

**Location:** Cascade:62–76, 135–160.

`acts w n` lists members `0,…,n−1` chronologically. `AlikeBefore k` excludes member `k`; `ReadsOnlyActsFrom k` includes it. Copying therefore correctly starts its cascade at `1`, the second member.

However, `ReadsOnlyActsFrom` quantifies over every `o`, `o'`, and every list, including impossible observations and unreachable histories.

**Add to its docstring:**

> “This is independence on all law inputs, including unreachable histories, rather than only on realized runs.”

The stronger premise is coherent and simplifies the interface. `fallback` is needed to define behavior on an empty earlier list at positive indices, although that branch is unreachable in generated runs.

**15. Low — Reuse is mostly appropriate; distinguish API corollaries from results and tidy two misleading descriptions.**

**Location:** all three modules.

Package search found relevant neighbors, not an existing duplicate of the general added-edge or sequential-cascade theorem. `Presence.prec_iff_every` concerns natural labellings with additional hypotheses; `WitnessRefinementRuns.copied_witnesses_same` has the support and fault-set assumptions already acknowledged. `Learning.Shift.determines` is essentially the content-only Cue example with the cue orientation reversed.

`twin_selected` appropriately reuses `Training.unselected_beyond_data`; `unseen_fixed` directly specializes `lumped_determines`. `both_ways_of_unreached`, `act_alike_of_cascade`, and `cascade_through` are useful corollaries. Retain them as API conveniences if used, but do not count each as an independent result. The definite duplicate is finding 8.

Most names are structural and exact. Besides `honest`, the detection names need the qualification in finding 7. `same_search_after` is defensible because “same” modifies the procedure.

At ShownOrder:71, replace “No ethical predicate, ranking or axiom occurs” with:

> “No ethical predicate or normative premise is introduced; the orders are supplied mathematical relations.”

Order comparisons plainly occur. Also describe `accorded_iff_noCycle` as using the grammar’s reach and transitivity: its proof does not actually invoke `«无环则及为序»`.

**What I did not check.** I made no edits, created no files, and ran no builds, `make`, rendering, or commits. I inspected the supplied build summaries but did not establish that they certify the exact current bytes, independently check the import closure, or compile the proposed changes. I did not exhaustively reread the entire theory, verify literature equivalences or originality, test empirical correspondences, or review round 2. Proposed strengthenings are mathematical review suggestions pending Lean verification. Apart from the discrepancies identified above, the theorem statements and local proof arguments matched their stated mathematical content.

── cx · ok · session 01a18763-4dce-70d2-9593-312e135d6e98 · gpt-6-astra/high · read-only · 381s · 625.7k tokens · 27 cmds
continue: cx -r 01a18763-4dce-70d2-9593-312e135d6e98 "…"
log: /Users/ren/.cache/cx/runs/20261029-181954-71487

## What was taken

| # | Finding | Taken |
|---|---|---|
| 1 | "What the choices fix" is the positive comparisons every according order shares, not an objective; the inner-alignment and IRL readings say too much | ShownOrder's header and docstrings say "the positive comparisons shared by every according strict order are exactly the shown reach"; the readings are the review's wording: ambiguity under no further restriction, `Untried` realizing different later choices, installation and disagreement with an objective not proved; beyond the reach, a comparison needs information or premises beyond the strict choices |
| 2 | maximality is not equality, and it still excludes comparisons | "choices among equals" replaced by "choices required only to be maximal force no positive comparison", the exclusion kept; the theorem renamed `weakly_forces_no_comparison` |
| 3 | `top_in_every_iff_reach` does not establish a choice; `not_top_of_unreached` proved less than its heading and duplicated `above_in_some_of_unreached` | the heading is "uniform strict dominance over a menu is exactly reach to each other alternative", with the note that it does not say `x` is open or chosen; `not_top_of_unreached` removed |
| 4 | `reach_withPair` proves one direction; `reach_first_second`'s docstring; `met_fixed` needs no order hypotheses | `reach_withPair_iff` added (no acyclicity or decision needed); the docstring is "every shown reach starts at the first alternative and ends at the second"; `met_fixed` now holds of every according relation |
| 5 | `search` can return none; "nothing is decided" | the docstring states the none case and the scope; the header says the general theorems need no decidability and the witness uses explicit Boolean comparisons |
| 6 | the twin needs decidability, which can be localized | `free_lumped` and `twin_selected` take `[∀ i, Decidable (π i = π x)]`, and their docstrings say so |
| 7 | distinct states do not establish detection of evaluation | the chain is stated for fixed maps from coupling to state to act; reading it as sensitivity to being read needs a correspondence holding other differences fixed, as the witness holds the content fixed |
| 8 | the two cue counterexamples are one proposition; `honest` is unsupported | one lemma, `Cue.apart_with_content_alike`, with its two uses explained; `honest` renamed `contentAct` |
| 9 | "survives every selection exactly where" drops quantifiers | the readings say: given a selected law, with being in the lump decided, behaviour can differ where no read occasion shares the lump, and cannot where one does; ELK is named an identification limit for reporters, latent knowledge not represented |
| 10 | correctness hypotheses are sufficient, not necessary | per target, `lumped_right_iff` is the exact condition and `lumped_world_right` a sufficient one; `unseen_fixed`'s docstring is the review's |
| 11 | coverage and refinement need scope | the coverage paragraph is the review's wording; capability is a further correspondence |
| 12 | Cascade's opening and readings claimed necessity and dependence results not proved | the opening is the review's; the Condorcet and echo-chamber readings are narrowed; an upper bound, not exact reach |
| 13 | `separates_at` is conditional transport; restricted access is already representable | `separates_at` is an iff under the shared history, named a distinction in the law; the limitation on networks reading some earlier acts is removed, the interface's handling of it stated |
| 14 | the cascade premise quantifies over unreachable histories | stated in `ReadsOnlyActsFrom`'s docstring |
| 15 | reuse and two descriptions | "no ethical predicate or normative premise is introduced; the orders are supplied mathematical relations"; `accorded_iff_noCycle`'s docstring names `«及之传递»`, which its proof uses |
