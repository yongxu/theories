# Second read of U1's design (GPT astra, high effort, read-only; the same reviewer)

29 October 2026. The second read of [DESIGN.md](DESIGN.md), after its revision and a second scratch round (46 theorems in 68 declarations), asked by OU's owner to take the rewritten design as a whole against the landed Lean. Returned verbatim below with its run footer, links made repository-relative and line suffixes dropped. The design's final form takes every finding and adopts the narrower reviewed outcome of finding 7 as U1's verdict (§0 and §8 there).

**Verdict: not yet sound as one interface as stated.** The new scratch establishes the two conditional crossing joins, the normalized residual count, and the equivalence between balance and a family of selected frame bijections. I found no source-level proof error in those declarations or their uses of the landed lemmas. However, §3 combines these results with a different finite-family model and an exchange model containing additional ports. Those differences affect the claims of existence and invariant endings. Keep F13’s reason and the prohibition on rerouting numerical consumers. The second-sort verdict can be recorded only with a narrower, exact interface, or after the mismatches below are repaired. The source tally is indeed 46 theorems in 68 declarations; I did not rebuild or independently verify the axiom reports.

1. **High — The endings law omits the “leaving” outputs introduced by the contract.**

   **Location:** [Design §3.2, lines 69–77](../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u1-balance-under-units/DESIGN.md); [scratch `endings_count`, lines 447–455](../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u1-balance-under-units/scratch/Becoming/UnitScratch.lean).

   **Problem:** The theorem assumes
   `taken ++ beyond` pairs with `given ++ ended`.
   The contract instead has `given ++ leaving ++ ended`.

   Write their lengths as `T, B, G, L, E`. Under the stipulated normalization `B = excess G T`, the contract implies
   **`L + E = excess T G`**, not `E = excess T G`.

   For example, `T = 2`, `G = 1`, `B = 0` permits either one leaving unit and no ending, or no leaving unit and one ending. The theorem is correct; its application to the contract’s endings alone is not.

   There is a second incompatibility: actual outside inputs need not number `excess G T`. A formation can exchange positive amounts both inside and outside while its internal totals satisfy `T = G`. Calling all outside inputs “beyond” while requiring their count to be zero excludes such exchanges. Source-minimal completion is a residual accounting representation; it is not automatically a faithful representation of actual boundary traffic.

   **Fix:** Choose explicitly between:
   - a residual model with no separately represented leaving outputs, where `endings_count` applies; or
   - a model retaining actual boundary inputs and outputs, with their lengths included in the equation.

   At closed families, explicitly set actual external ports to zero. Do not identify residual endpoints with actual losses without the additional correspondence.

2. **High — The finite-family contract and `kunits_iff_balances` describe different domains.**

   **Location:** [Design §3.1, lines 59–64](../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u1-balance-under-units/DESIGN.md); [scratch `KUnits` through `kunits_iff_balances`, lines 559–574](../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u1-balance-under-units/scratch/Becoming/UnitScratch.lean).

   **Problem:** `KUnits` supplies a matching for **every `t c`**, with no `cs`, membership restriction, or finiteness hypothesis. Its equivalence with global `L.Balances W` is correct.

   A model restricted to one selected finite family establishes balance only there. It cannot establish global balance: a flow may balance on the selected conditions and fail elsewhere. The empty-family case makes the distinction immediate.

   The reason given for restricting the unit selection is also misplaced. Infinite condition support does not prevent a family of finite condition-frame bijections indexed by all conditions; `KUnits.canonical` constructs exactly that. It prevents collecting an entire formation’s unrestricted exchange into one finite list.

   **Fix:** Keep the condition-frame model global, as checked, and restrict finite enumeration only where formation exchange lists require it. Alternatively, introduce a restricted unit model and state its converse against balance on that family at every step. Do not cite the global equivalence as that restricted theorem.

3. **High — Numerical consequences are still presented as existence and compatibility of a complete representation.**

   **Location:** [Design §3.2, lines 72–78; §3.7, line 119; §6, lines 164–169](../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u1-balance-under-units/DESIGN.md); [scratch `source_free_of_dissipates` and `ends_of_dissipates`, lines 459–475](../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u1-balance-under-units/scratch/Becoming/UnitScratch.lean).

   **Problem:** The two dissipation declarations prove, for a **present** formation:

   - the numerical surplus `excess G T` is zero;
   - `excess T G` is positive when `T > 0`.

   Neither constructs a source-free selected exchange matching. `endings_count` assumes a pairing. `one_matched_iff` supplies a relational matching on `List Unit`, not the labelled selected exchange structure described here.

   Similarly, no declaration connects the aggregate given/taken positions of `KUnits` to formation-specific exchange occurrences, or establishes the claimed compatibility of both constraints on one model. `Flow.given` and `Flow.taken` sum over **list positions** in `present`; repeated formations must therefore also be handled.

   `KUnits`’ nonemptiness establishes nonvacuity for the frame-model fibre. It does not establish nonemptiness for an enriched fibre containing all the exchange contracts.

   **Fix:** Mark labelled exchange existence, attachment to condition frames, and enriched-fibre nonemptiness as proposed. Specify the attachment maps and multiplicities. Add a bridge from the bounded graph of a `FrameMatch` to `«对»` on labelled lists before treating the selected model as the checked input to the grammar’s pairing laws.

   These are straightforward-looking obligations in some restricted versions, but §6 cannot say all five items are done on the evidence supplied.

4. **Medium — “From `rest`” is checked; “from outside `ds`” needs a disjointness condition stated explicitly.**

   **Location:** [Design ledger lines 39–41; §3.5, lines 98–105](../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u1-balance-under-units/DESIGN.md); [scratch `Ex`, `takeL`, and `rise_crossing_strong`, lines 373–442](../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u1-balance-under-units/scratch/Becoming/UnitScratch.lean).

   **Problem:** The strong theorem assumes only `Distinct ds`. It does not require `rest` to be distinct or disjoint from `ds`. Its conclusion is exactly membership in `takeL … rest …`, which need not mean an outside condition.

   The contract calls this an explicit partition, which can supply the missing condition, but “with `es` written `ds ++ rest`” alone does not. The ledger should distinguish the theorem’s unrestricted list statement from that restricted interpretation.

   Also, indices in `Ex.took c i` do not distinguish repeated occurrences of the same condition in `cs`: the same labels are emitted again. Step and formation are fixed parameters of the construction, not fields of `Ex`. That is sufficient for the current local arithmetic lemmas, but not a globally unique occurrence carrier.

   **Fix:** State `Distinct (ds ++ rest)`, or explicit disjointness plus the required distinctness, for the outside-source interpretation. State tag restrictions on beyond and output lists. For global composition, include the necessary step, formation-occurrence, and list-occurrence indices—or explicitly restrict to distinct lists.

   The joins themselves use the landed theorem correctly: one formation precedes the universal quantification over relations and lists; the strong proof correctly uses its excess inequality and `excess_balance`.

5. **Medium — The ledger remains partly stale and overstates two declaration-level conclusions.**

   **Location:** [Design §1, lines 29, 43–47; §3.1, line 63; §6, line 164](../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u1-balance-under-units/DESIGN.md).

   **Problem:** Line 29 still says the kinded converse is proposed, contradicting the round-2 row and §3.1.

   More substantively, `FrameMatch.predecessor_unique` proves:
   `i < N → fwd i = j → i = bwd j`.
   Existence of a predecessor for an in-range output follows from the structure’s `bwd_lt` and `fwd_bwd`, not from that theorem alone. Likewise, `KUnits.next` proves the output lies in the standing block or the taken block; uniqueness comes from using the function `fwd`. Neither declaration defines a global kinded continuation graph.

   `KUnits.projects_along` proves exactly the displayed `Steps.along (t,c) (t+1,c)` proposition. Its proof ignores both unit hypotheses. This supports the limited coordinate observation now claimed; it is not yet a theorem about a defined projection preserving a defined unit relation.

   **Fix:** Remove the stale converse status. Attribute existence and uniqueness to the structure fields together with the listed lemmas. Describe `KUnits` as selected frame data with an intended kinded decoding until that decoding and graph are defined.

   The other round-1 ledger rows match their stated restrictions. `FrameMatch.le` correctly applies `revisits_within` to the first `M+1` inputs when `M < N`; no supplied decidability hypothesis is missing. The canonical cast has the correct orientation. The storage counterstatement also matches its Lean exactly.

6. **Medium — The failure summary again confines content to closed dissipative families.**

   **Location:** [Design §5, line 154](../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u1-balance-under-units/DESIGN.md).

   **Problem:** “Its content is at closed families in dissipative flows, and only under the source-minimal normalization” contradicts the actual scope of the checked laws:

   - weak crossing assumes neither closure nor dissipation nor normalization;
   - strong crossing assumes normalization of the supplied list’s length, but neither closure nor dissipation;
   - `endings_count` also requires neither closure nor dissipation;
   - `DissipatesOn` may be supplied directly on a nonclosed family.

   The free-beyond existence assertion remains unproved for the complete port model, particularly after the distinction in finding 1.

   **Fix:** State that closure and `Dissipative` guarantee the specific source-free, positive-residual specialization. Preserve the broader scopes of the crossing and counting laws. Mark open-model existence separately.

7. **Medium — Completion by failure must identify the failed representation, not count unfinished proposals as established laws.**

   **Location:** [Design §0, line 19; §3.7–§3.9; §6](../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u1-balance-under-units/DESIGN.md).

   **Problem:** The revised distinction between validity, constancy, and individual representation is sound. The marked proposals for provenance, Little’s law, and the grammar’s positions are permissible future work. But they cannot supply the completed interface, and the unmarked existence/compatibility claims above cannot be absorbed into them.

   **Fix / completion by failure:** A narrower reviewed outcome could record:

   > Balance is represented by selected finite frame bijections at every condition; the conditional crossing laws and normalized residual-count law hold at the specified list selections. This does not derive balance from the unfolding. The attempted identification of residual endpoints with a faithful open exchange model fails when actual boundary traffic is retained; projection does not recover WRT conservation; correspondence orbits do not exhaust the matching fibre. Global exchange attachment and line laws remain outside the established interface. No numerical consumer is rerouted, and F13’s reason remains.

   That separates demonstrated limits from unfinished work. After correcting the scopes above, those exact laws can constitute a limited second-sort interface. Merely writing “global representation not yet proved” would not itself demonstrate its failure or complete that stronger claim.

The eleven earlier findings stand as follows:

| Earlier finding | Status | Reason |
|---|---|---|
| 1. Matching existence versus selected matching | **Partly resolved** | `FrameMatch` fixes the frame-level defect. A global selected graph and its exchange attachment remain unspecified. |
| 2. Open existence and finite support | **Partly resolved** | Infinite support is acknowledged, but finiteness is imposed on the wrong layer; complete port-model existence remains unproved. |
| 3. Closure, artificial sources, normalization | **Partly resolved** | Closure and residual normalization are distinguished correctly. Separate leaving outputs invalidate the advertised endings formula. |
| 4. Storage | **Resolved** | The lossless case is excluded with the correct hypotheses; later giving is assessed against current taking. The positive storage example is a local numerical clause, not a constructed whole World. |
| 5. Crossing join | **Partly resolved** | Both algebraic joins are now checked and correctly quantified. Outside-source interpretation and complete representation still require explicit partition and attachment conditions. |
| 6. Projection to WRT | **Resolved at the revised scope** | The false image claim is withdrawn. The checked projection observation is deliberately restricted and does not recover WRT relations. |
| 7. Correspondences versus re-pairings | **Resolved as a design correction** | The identification is withdrawn; fixed-base correspondences and same-World fibres are distinguished. Their implementation is not checked. |
| 8. Lifting principle | **Resolved conceptually** | Definition, constancy, and individual representation are separated; universal completeness remains a proposal. Nonvacuity must still be restricted to the demonstrated fibre. |
| 9. Exact checked scope | **Partly resolved** | Most ledger entries are accurate; stale status and representation/existence overstatements remain. |
| 10. Nine rows and two constraints | **Resolved** | The broad support category, reproduction hypotheses, injection obligation, and distinction between balance and dissipation are preserved. |
| 11. Completed second-sort interface | **Partly resolved** | The opening correctly calls it a direction, but §3 and §6 still overstate the established exchange interface. |

**What I did not read:** I did not inspect build logs, compiled artifacts, generated axiom reports, or the full imported dependency closure; I did not rebuild. I reread the whole revised design, whole 619-line scratch file, and saved first review. Against current landed Lean, I read the relevant Flow and Dissipation definitions, the crossing theorem and proof, `excess` and its balance identity, the pigeonhole and pairing machinery, the relevant occurrence-model declarations, and `Steps.along`. I did not reread every unrelated declaration in those modules, the full chapters, WRP’s implementation, or rerun the nine-row audit. Nothing was edited, created, committed, rendered, or built.

── cx · ok · session 01a18751-ad46-7433-8692-adde4c4b2bfb · gpt-6-astra/high · read-only · 278s · 886.9k tokens · 6 cmds
continue: cx -r 01a18751-ad46-7433-8692-adde4c4b2bfb "…"
log: /Users/ren/.cache/cx/runs/20261029-181842-68385

## Confirmation read

After the rewrite, the same reviewer read the final §0, §1 and §2 narrowly (`cx -r`, 70 s), returned verbatim:

**Not fully confirmed.** §0 matches the narrower verdict. The two new proofs are sound on source inspection, but these wording issues remain:

1. **Medium — Closed ports do not alone identify the two models.** [§3.2, lines 71–73](../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u1-balance-under-units/DESIGN.md) applies the normalized theorem to faithful traffic. `endings_count_closed` assumes source-minimal beyond inputs and an empty leaving list; it assumes no closure and proves no correspondence. Closure alone permits `G > T`, requiring positive residual sources despite zero actual outside inputs. Add `G ≤ T`—for example from dissipation—and keep the identification with actual loss conditional on the proposed representation.

2. **Medium — Normalization is missing from the new ledger row.** [§1, line 42, and §2.4, line 56](../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u1-balance-under-units/DESIGN.md) should explicitly retain `beyondL.length = excess given taken` and the supplied pairing for **both** new lemmas. Keeping leaving outputs alone does not establish the displayed count.

3. **Low — The dissipation specialization omits distinctness.** [§2.5, line 57](../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u1-balance-under-units/DESIGN.md): write “closure of a **distinct** family with `Flow.Dissipative`.”

4. **Low — The taken block belongs to the current exchange frame.** [§1, line 45](../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u1-balance-under-units/DESIGN.md): replace “standing or the taken block of the next frame” with “the current frame’s output blocks: standing at `t + 1` or taken at `t`.”

The remaining ledger rows match their declarations at the stated scopes. No build or axiom-audit verification was performed; nothing was changed.

── cx · ok · session 01a18751-ad46-7433-8692-adde4c4b2bfb · gpt-6-astra/high · read-only · 70s · 647.7k tokens · 3 cmds
continue: cx -r 01a18751-ad46-7433-8692-adde4c4b2bfb "…"
log: /Users/ren/.cache/cx/runs/20261029-182537-82446

All four issues were taken in the design (the ledger rows for the two new lemmas and for `KUnits.next`, §2.4, §2.5 and §3.2). §0 was confirmed as matching the narrower verdict.
