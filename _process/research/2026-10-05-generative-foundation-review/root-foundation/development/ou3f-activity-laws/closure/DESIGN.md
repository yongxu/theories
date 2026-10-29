# OU3f, derivations: the six inductions over steps, by closure

AI-written design for the next part of board item OU3f's derivations, 29 October 2026, on main at `255acf565`, after the twins ([design](../derivations/DESIGN.md), study §443).

[The audit](../AUDIT.md) found six activity laws that keep a region along the steps by their own induction (its section *Closure: six inductions over steps*). EC6's audit put such lemmas among the cases of closure, and EC6b derived one through `Invariant.reach` with `Run.reach` (`Pace.stays`). Each of the six needs a run whose steps are the steps of time, and that run is stated once. The coordinating session chose a small new module for it rather than `Frame`, its natural home, so that adding it rebuilds only the modules that use it. Its conditions are below.

## The clock module

`Becoming.Clock`, a leaf importing `Becoming.Recurrence` (where `Law.process` is), with two declarations ([tree](tree/Becoming/Clock.lean)):

| declaration | statement |
|---|---|
| `Law.clock` | `Run (Law.process Nat.succ) := ⟨id, fun _ => (), fun _ => rfl⟩`: the successor law's run, its state at step `n` being `n` |
| `kept_onward` | `(∀ n, I n → I (n + 1)) → I a → a ≤ b → I b`, for `I : Nat → Prop`: a region of the steps of time that every step keeps holds from where it holds on. The proof: the clock reaches `b` from `a` (`Run.reach`), and a region the steps keep is closed under what they reach (`Invariant.reach`). |

The coordinating session set three conditions.
1. **Not a second clock.** The package was searched in every namespace for a run of `Law.process Nat.succ` and for runs whose state is the step:
   - No run of `Law.process Nat.succ` exists.
   - Two runs whose state is the step exist, on local copies of the successor's process, as witnesses in high modules that the six cannot import: `Changing.run` (`LawAlongRun`, `⟨fun x _ y => y = x + 1⟩`) and `Climb.course` (`ReachableRanges`).
   - `MoveFormation`'s `clock` is a process (the successor's step at any action), not a run. Its name `Becoming.clock` is taken, so the run is `Law.clock`.

   The module's doc names all three, to be read through the clock once it moves.
2. **Named for what it is.** `Law.clock` is exactly the successor law's run with the step as its state. `kept_onward` states exactly what it proves: kept by every step, held onward.
3. **Where it belongs.** The module's doc says its home is beside `Run.reach` and `Invariant.reach` in `Becoming.Frame`, and that it moves there at the next full rebuild of the package that someone needs anyway. The landing note and the study section say so too.

## The six derivations

Each proof's induction is replaced by `kept_onward`. What remains is the step: the one-step argument that the region is kept, which the old induction's successor case held. Statements and names are unchanged. Each docstring gains a clause naming the region kept.

| theorem (module) | the region every step keeps | start |
|---|---|---|
| `Web.inactive_of_not_arising` (Retaining) | not being active (`never` at each step) | step 0 |
| `Web.active_back` (Wholes) | within the `k` steps, active there only if not inactive at `S` (`quiet` at each step) | step 0, bounded by `k` |
| `Web.active_before` (Exclusion) | active there only if active at `T + j` (`lasting` at each step) | step `j` |
| `Web.ended_for_good` (Reserve) | inactive with the reserve spent (`final` at each step from `U`) | step 0 after `U` |
| `Web.ByPassing.present_earlier` (PatternPassing) | presence at `t + n` giving presence at `t` (`present_back` at each step) | step 0 |
| `Web.steady_held` (Persistence) | from a step `u` of the stretch, having the name it had at `u` (`keeps` at each held step) | step `u`, bounded by the stretch |

Where the start is not fixed by the shape of the region, it is named (`(a := 0)`, `(a := u)`), since elaboration meets the start before the bound.

Exclusion's proof was a tactic block (`induction le`); it is now a term, like the rest. PatternPassing's header now says presence goes back by closure (`present_earlier`, and through it `present_of_le` and `empty_stays`). Its *Not connected* paragraph no longer lists them.

The scratch build ([log](scratch-3.log)) gives every axiom report empty and no warnings:
- `Becoming.Clock`: 1 theorem in 2 declarations.
- The six keep their counts: Retaining 34 in 49, Wholes 98 in 130, Exclusion 39 in 46, Reserve 89 in 131, PatternPassing 32 in 45, Persistence 86 in 106.

## Why each is a derivation

The test is OU3d's second review's: a derivation replaces part of the old proof by the law. In each of the six, the old proof is an induction on the step count whose base case is the start and whose successor case is one step of the region. The new proof keeps the step as the argument `keeps` and replaces the induction by closure: the clock's reach and a closed region holding what is reached. No part of the old induction survives inside the new term.

This is EC6b's derivation of `Pace.stays` in form. The audit and its review found these six to be the closure family the first audit had missed.

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
  - `Becoming.Clock` joins the checker's core list after `Becoming.Recurrence`, with a sentence in the scope text.
  - It joins the root module's imports, with an L1 doc bullet after Recurrence's.
  - It gets a README row in each language.
  - The six modules import it.
- **Signatures:** every statement of the six prints unchanged, and nothing is gone or added. `Becoming.Clock`'s two declarations are new.
- **Connectivity register:** `kept_onward` has six consumers, and `Law.clock` is used by it.
- **Record:** `master-laws-on-the-grammar` takes the clock law into its closure group and the six derivations into its last group, with references and bindings for the seven modules.
- **The measure** is rechecked.
- **A study section,** which says where the clock belongs.
