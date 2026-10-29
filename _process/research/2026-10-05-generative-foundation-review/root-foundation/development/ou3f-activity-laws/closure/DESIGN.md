# OU3f, derivations: the inductions over steps, by closure

AI-written design for the next part of board item OU3f's derivations, 29 October 2026, on main at `255acf565`, after the twins ([design](../derivations/DESIGN.md), study §443).

[The audit](../AUDIT.md) found six activity laws that keep a region along the steps by their own induction (*Closure: six inductions over steps*). EC6's audit put such lemmas among the cases of closure, and EC6b derived one through `Invariant.reach` with `Run.reach` (`Pace.stays`). The review of this part's first draft found three more in the same modules; two are derived here, and the third reads no activity (below). Each needs the one law that a region every step keeps holds from where it holds on, and that law is stated once. The coordinating session chose a small new module for it so that adding it rebuilds only the modules that use it. Its three conditions are below.

## The law, on the grammar

`Becoming.KeptOnward`, a leaf importing only `Becoming.GrammarLaws`, with one theorem ([tree](tree/Becoming/KeptOnward.lean)):

| declaration | statement |
|---|---|
| `kept_onward` | `(∀ n, I n → I (n + 1)) → I a → a ≤ b → I b`, for `I : Nat → Prop`: a region of the steps of time that every step keeps holds from where it holds on. Proof: the steps from `a` to `b` are a line under the successor (`«线则所闭»`), and a closed region holds what lies within the closure from where it holds (`«闭含所闭»`). It is the grammar's closure at the successor relation; no process and no run is needed. |

The coordinating session's three conditions:
1. **Not a second clock.** The module defines no run. The first draft stated a run of the successor law, `Law.clock`. The review showed that one already exists: `Law.run` (Recurrence), which `Pace.stays` uses at its own law; at `Nat.succ` its state is the step by `Law.succ_orbit`. It also noted that the law needs no run at all when stated on the grammar. The draft's run is gone. The local copies of the successor's process and run stand where they were:
   - `Changing.run` (LawAlongRun);
   - `Climb.course` (ReachableRanges), whose process is `Law.process (· + 1)` by `rfl`;
   - `AdjacentHeld.process` (HeldPossible);
   - `Stock.accumulating`;
   - MoveFormation's `clock` process.
2. **Named for what it is.** `kept_onward` states exactly what it proves. The module is named for its one law.
3. **Where it belongs.** Its home is beside `«线则所闭»` in `Becoming.GrammarLaws`, among the line laws. It uses only what that module sees (`le_dest` from `Becoming.Prelude`, which `GrammarLaws` imports), so the move is a cut and paste. It moves there at the next full rebuild of the package that someone needs anyway. The module doc and the study section say so.
   - The first draft named `Becoming.Frame` as the home. The review found that unreachable, since `Law.process` is in `Recurrence`, above `Frame`.

## The derivations

Each proof's induction is replaced by `kept_onward`. What remains is the step: the one-step argument that the region is kept, which the old induction's successor case held. Statements and names are unchanged. Each docstring gains a clause naming the region kept.

| theorem (module) | the region every step keeps | start |
|---|---|---|
| `Web.inactive_of_not_arising` (Retaining) | not being active (`never` at each step) | step 0 |
| `Web.active_back` (Wholes) | within the `k` steps, active there only if not inactive at `S` (`quiet` at each step) | step 0, bounded by `k` |
| `Web.active_before` (Exclusion) | active there only if active at `T + j` (`lasting` at each step) | step `j` |
| `Web.ended_for_good` (Reserve) | inactive with the reserve spent (`final` at each step from `U`) | step 0 after `U` |
| `Web.ByPassing.present_earlier` (PatternPassing) | presence at `t + n` giving presence at `t` (`present_back` at each step) | step 0 |
| `Web.steady_held` (Persistence) | from a step `u` of the stretch, having the name it had at `u` (`keeps` at each held step) | step `u`, bounded by the stretch |
| `Web.ByPassing.trace` (PatternPassing), found by the review | every carrier at `S + n` carried it at `S`, or some carrier passed it across one of the `n` steps | step 0 |
| `Web.ByPassing.line_back` (PatternPassing), found by the review | every carrier at `S + (n + 1)` lies on the pattern's line from a carrier at `S` | step 0 |

Where the start is not fixed by the shape of the region, it is named (`(a := 0)`, `(a := u)`), since elaboration meets the start before the bound.

Other details:
- Exclusion's proof was a tactic block (`induction le`); it is now a term, like the rest.
- PatternPassing's header gains a bullet, *By closure*, naming `trace`, `line_back` and `present_earlier`, with `present_of_le` and `empty_stays` through it. *Not connected* now keeps only `begins_within` and `present_back`.
- `trace` was filed as a law of its model, its reason being that the route through the pattern's line would need deciding sameness of formations. Closure is a law of its shape, and that reason concerns only the line route. So the audit is corrected: (a) has 15 rows and (c) model 172, and 398 of the 436 are laws of their models.
- `line_back`, a representation, keeps its standing; only its proof changes.

**Outside this layer.** `Reidentify.old_still` (Persistence) also keeps a region along the steps, and the review compiled it by `kept_onward`. It reads no activity, so it belongs to the layer that reads no field, which the coordinating note takes whole through the representation of processes (WRP), not theorem by theorem. It is left to that layer.

The scratch build ([log](scratch-4.log)) gives every axiom report empty and no warnings:
- `Becoming.KeptOnward`: 1 theorem in 1 declaration.
- The six modules keep their counts: Retaining 34 in 49, Wholes 98 in 130, Exclusion 39 in 46, Reserve 89 in 131, PatternPassing 32 in 45, Persistence 86 in 106.

## Why each is a derivation

The test is OU3d's second review's: a derivation replaces part of the old proof by the law. In each of the eight, the old proof is an induction on the step count whose base case is the start and whose successor case is one step of the region. The new proof keeps the step as the argument `keeps` and replaces the induction by the grammar's closure at the successor. No part of the old induction survives inside the new term.

The review confirmed this for the six, including their bases and bounds, and compiled `trace` and `line_back` the same way. All 507 declarations of the six modules print as on main.

## Owners

The six modules were last changed by four sets of work:
- Wholes and Reserve by ZG1 to ZG3 (22 October);
- Persistence by OU2 and OU3a (23 October);
- Retaining and Exclusion by DF1's corrections to header text (26 October);
- PatternPassing by this item's twins.

No active session holds their proofs, so rule 3's fallback applies, as for the twins. DF1's text is not touched.

## Landing

Queued behind AJ5 and WRP.
- **Joining the module:**
  - `Becoming.KeptOnward` (L1, computed: `Becoming.World` does not import it) joins the checker's core list after `Becoming.GrammarTransport`, with a sentence in the scope text.
  - It joins the root module's imports, with an L1 doc bullet after GrammarTransport's.
  - It gets a README row in each language.
  - The six modules import it.
- **Signatures:** every statement of the six prints unchanged, and nothing is gone or added. `kept_onward` is new.
- **Connectivity register:** `kept_onward` has eight consumers.
- **Record:** `master-laws-on-the-grammar` takes `kept_onward` into its closure group and the eight derivations into its last group, with references and bindings for the seven modules.
- **The measure** is rechecked. The audit's correction is written down.
- **A study section,** which says where the law belongs.

## The review, and what was taken

One independent read-only review by a separate AI agent ([REVIEW-CLOSURE](review/REVIEW-CLOSURE.md), its compiled checks in `review/checks/`). It found the six derivations right, with statements unchanged and builds clean, but two of the three conditions unmet. Every finding was taken.
1. **A second clock.** `Law.run Nat.succ` already exists. The law is now stated on the grammar, with no run, and `Law.clock` is gone.
2. **The home in `Frame` was unreachable.** The home is now `GrammarLaws`, beside `«线则所闭»`, reachable with the proof unchanged.
3. **The search for clocks missed several.** `Law.run Nat.succ`, `AdjacentHeld.process` and `Stock.accumulating` are now listed, and `Climb.process` is noted as `Law.process (· + 1)` by `rfl`.
4. **Names.** With no run there is no clock to name. The module is named for its law, which collides with nothing.
5. **More inductions of the same kind.** `trace` and `line_back` are derived here; the audit and PatternPassing's header are corrected. `old_still` is left to the layer that reads no field, with the reason.
6. **The nit about `n + 1 = n + 1`** went with the run.

**Second pass.** The reviewer read the revised tree: every statement of the six modules prints as on main, `trace` and `line_back` included; `kept_onward` pasted beside `«线则所闭»` in a copy of `GrammarLaws` compiles with the same name, statement and empty report, so the move is a cut and paste; the builds are clean. Two fixes to the texts, both taken: the audit's closure paragraph and its six rows now say `kept_onward`, not a clock run, and this note says `Pace.stays` uses `Law.run` at its own law.
