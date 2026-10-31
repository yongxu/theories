# Checked formation and localized copying of competing variants

6 October 2026. [FormedSelection.lean](FormedSelection.lean) and [FormationRoot.lean](FormationRoot.lean) preserve **53 checked theorem declarations** for the discrete formation law and its exact connection to the repository's existing causal root. [FormationAccounts.lean](FormationAccounts.lean) adds **15 checked declarations** extending the shared formation-support bridge, for **68 in this package**. They use Lean 4.29.1 and `Std`. The root, conditional account and shared formation-support module are compiled from their original sources as dependencies; their 18, 24 and 25 existing audits are counted separately in the [verification record](verification.json).

The governing scope is in [FORMED-VARIANT-SELECTION-LEAN.md](../../../../../../_process/history/2026-10-05-support-and-shared-generativity/completion/FORMED-VARIANT-SELECTION-LEAN.md). These are event-law, accounting and reachability proofs. Expected selective advantage belongs to the separate analytical and computational work; it is not certified here.

## State and transition interface

The state fields, in order, are

`(aFree, hFree, resident, intact, localFuel, fuel, source)`.

`resident` is `empty`, `active` or `alternative`; the two site fields are Boolean. There is one site. Material M is a natural-number parameter; precursor is derived as M minus the count of all free and resident variants. Every step requires that count to be at most M and preserves the bound. The corresponding Python convention uses resident codes 0, 1 and 2 and Boolean site flags 0 and 1. This mapping is documented for review, not machine-proved as a Python refinement.

The sixteen event labels are two formation events, two paid association events, repair, capture, two local-copy events, two bulk-copy events, two free-variant wear events, resident wear, site damage and two leakage events. Formation requires a damaged site, available precursor and common fuel. Both types have that same enabling condition. Only an active resident can repair; any resident can copy using local fuel. Bulk copying requires an existing template of the corresponding type. Wear returns precursor; resident wear preserves the site's condition and local fuel.

`Enabled` and `advance` state every guard and update explicitly. Stochastic rate coefficients, negative controls and optional catalytic-consumption channels are outside this formal relation. Turning off a channel restricts its paths and preserves the universal path constraints; changing an update requires a separate check.

## Results that constrain the mechanism

- **Material and energy accounting:** every finite valid path preserves total precursor plus variants. Final common fuel, local fuel, incident support and all spent units equal their initial total. A separate ledger records common-fuel spending; source capture never silently refills the common pool. Copy count cannot exceed the initial total fuel.
- **Finite event bound:** `4E + 2F + 2L + C + population` decreases by one or two on every event. No infinite event sequence exists in this finite-stock law. This does not limit elapsed waiting time or imply a universal value measure.
- **Paid bootstrap:** from an absent, vacant, damaged preparation, restoring an intact site needs at least three initial common-fuel units. If an alternative variant is present with that restored site, at least four initial common units were necessary. The second result explicitly charges the competing variant's origin.
- **Type ancestry:** a previously absent type cannot appear along a trace containing none of its own formation events. Every copy requires an existing template and increases only that template's type. This checks type-level ancestry, not an individually tagged molecular genealogy.
- **Local access before resident wear:** on every history from the initial preparation without resident wear, an alternative resident never has an intact site or local fuel. Therefore no H local copy occurs. Free wear, additional formation and other enabled events are allowed by this invariant.
- **An actual counterpath:** when resident wear is allowed, an H variant can inherit the site repaired by A and then produce an H copy. The useful contributor's disappearance and the alternative's growth occur under the same supplied law.

The four-unit result uses a history-independent bound on common fuel plus paid progress. The progress term is three when the site is intact, two when an A resident is installed at a damaged site, and otherwise at most one for an existing A; a separate unit records whether H exists. Every event preserves or decreases their sum with common fuel. This avoids assuming that the second variant or the contest preparation is supplied for free.

## Mixed witness from complete variant absence

With M=3, initial F=4 and E=1, the checked path is

**form H → form A → associate A → repair → capture → copy A**.

Both variants begin absent and the site begins damaged, vacant and without local fuel. The final state contains A=2 and H=1. Four common units pay both formations, association and repair. The newly captured source packet pays copying. All intermediate states are carried through the same law; the proof does not restart at a favorable mixed preparation.

This proves an admissible mixed formation-to-copy path. It does not claim that every history follows it, that the path is likely, or that its population ratio establishes an expected selection effect. Those questions require the actual event rates and all competing histories.

The separate counterpath starts with M=2, F=5 and E=1:

**form A → form H → associate A → repair → resident wear → associate H → capture → copy H**.

It ends with A=0 and H=2. That witness makes the no-resident-wear premise of the access invariant explicit and rules out treating private access as an unconditional reward for useful contribution.

## Identified resource accounts on the actual history

`FormationAccounts.lean` imports [FormationSupport.lean](../../../../../integrated-correction/general-framework/generative-basis/lean/learning/FormationSupport.lean), the shared bridge from this formation law to [ResourceContinuation.lean](../../../../../integrated-correction/general-framework/generative-basis/lean/conditional/ResourceContinuation.lean). It reuses that bridge's source and usable ledgers, account laws, event-quantity adapter, actual-trace accounting, bounds, zero-tally lemma and paid witness. The uniform `Boundary` interface and overlapping theorem wrappers are supporting integration, not independent discoveries or additional evidence for the same law. The extension adds a common-fuel boundary, exact boundary cancellation, the reaction/leakage distinction and the unit-demand obstruction. The account boundary is explicit:

| Account | Reserve | Demand on an event | Credit on an event |
| --- | --- | --- | --- |
| Closed fuel | Common fuel + local fuel + incident source | All fuel spending, including leakage | Zero |
| Usable fuel | Common fuel + local fuel | All fuel spending, including leakage | One on capture |
| Incident source | Remaining incident source | One on capture | Zero |
| Common fuel | Remaining common fuel | Common-fuel spending, including common leakage | Zero |

Usable-account credit is a conversion from a tracked stock. Each capture consumes one incident packet and stores one local packet; adding the source and usable accounts cancels the credit exactly. Any finite history's capture credit is bounded by its inherited incident stock. Common fuel is never replenished by capture.

The imported `Support.root_trace_account` builds a generic `SupportTrace` on the original `rootProcess`, retaining every actual intermediate state. Its exact totals agree with the existing event ledgers. Our `root_account_balance` wraps the imported bound under the uniform boundary interface; the imported proof uses the generic `support_trace_bound` theorem. `root_append_account` composes those imported trace accounts through the same shared state using the generic append theorem. Phase boundaries retain that state's remaining fuel and source; the proof supplies no new preparation or reset. The mixed-witness wrapper reuses the checked usable account and records source and closed totals: usable demand 5 and credit 1, source demand 1, and closed demand 5 with zero credit.

The budget separates fuel allocated to formation, association, repair and copying from fuel lost by leakage. Reaction allocation is charged whether the response helps or harms; it is not a success score or a measured thermodynamic work quantity. With both usable fuel and incident stock exhausted, no fuel-spending reaction or leakage can occur along any subsequent valid trace. Damage and wear may still occur without consuming these fuel units.

An explicit enabled damage event has zero fuel demand. Therefore the generic theorem requiring at least one unit of demand on **every** event cannot be applied to this fuel account. The earlier finite event bound remains a separate ranking result. No stochastic, frequency, learning or universal-sufficiency conclusion is added by this composition. This bridge identifies a concrete instance of the conditional constraints; the event law, fuel units and local-access architecture remain supplied premises.

## Reproduce

Run `python3 check.py` from this directory. The checker explicitly selects `lean +leanprover/lean4:v4.29.1`, records the compiler hash, freezes all six source files, and compiles in a fresh temporary build. Its dependencies are the original [GenerativeCore.lean](../../../../../integrated-correction/general-framework/generative-basis/lean/GenerativeCore.lean), [ResourceContinuation.lean](../../../../../integrated-correction/general-framework/generative-basis/lean/conditional/ResourceContinuation.lean) and [FormationSupport.lean](../../../../../integrated-correction/general-framework/generative-basis/lean/learning/FormationSupport.lean). No previously compiled project object is reused. The shared formation-support source is read and audited in place; this package does not maintain a second copy.

Every new theorem must have an axiom audit. The script rejects proof placeholders, custom axioms, unsafe declarations, native decision shortcuts, warnings and unexpected axiom dependencies. [verification.json](verification.json) and [verification/](verification/) preserve source, checker, compiler and log hashes. Only the disclosed standard Lean foundations are accepted. The command replaces only this directory's verification artifacts.

`FormationRoot.lean` proves exact equivalence with `Generative.Trace`, transports the ledger, bootstrap bounds, mixed witness and inheritance counterpath, and obtains actual-state concatenation directly from the earlier root. This establishes formal compatibility with the root, while the chemistry, type repertoire, local-access architecture and copying specificity remain supplied premises.
