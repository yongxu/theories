# OU3f, laws of steps: B1, B2 and the converse law

AI-written design for the second part of board item OU3f, 29 October 2026, on main at `7c3829c82`. [The audit](../AUDIT.md) found two laws of steps that the grammar lacks, B1 and B2, plus a converse law for steps, needed by nine activity laws:
- four to derive: `Lineage.split`, `through`, `onward` and `back`;
- five that follow from the web lemma `Web.reaches_onward`.

The coordinating session's decision was to state them in `GrammarLaws` and review them before any lineage law bridges to them, as OU3d was, and to retire `reaches_onward`'s own proof into B2 where it becomes a case of it (board rule 9). The derivations of the lineage laws are the item's third part, module by module. Only `GrammarLaws` and `MapInstances` change ([tree](tree/Becoming/)).

## What is stated

The block follows `«存承之迭»` in the finite-runs section; the header's bullet *Finite runs: steps counted* gains two sentences.

| declaration | statement | reason |
|---|---|---|
| `«迭之分»` (B1) | `«迭» R (b + a) x z → ∃ y, «迭» R a x y ∧ «迭» R b y z` | Steps split as they compose. It is the converse of `«迭之接»` in that law's order, with no arithmetic. The `m + n` reading that `Lineage.split` wants is one rewrite by `Nat.add_comm` and stays with its consumer. |
| `«迭之逆»` | `«迭» («逆» R) n x y ↔ «迭» R n y x` | Steps read backward are steps of the converse; `Lineage.back` reads B2 through it. |
| `«或有后则或迭»` (B2, bounded) | `(∀ k y, k < n → «迭» R k x y → ¬¬ ∃ z, R y z) → ¬¬ ∃ y, «迭» R n x y` | Where whatever is reached in fewer than `n` steps has a successor as far as can be refuted, `n` steps exist as far as can be refuted. It is bounded because `Lineage.back`'s hypothesis covers only steps from `M` on. The conclusion is a double negation because each successor is given only as far as can be refuted. The unbounded form is one line from it at its use. |
| `«迭则同一或及»` | `«迭» R n x y → x = y ∨ «及» R x y` | `n` steps lead to the occurrence itself or to what it reaches, for any relation; at a line's continuation this is lying within the line's reach (`«所及»`, by definition). It has no induction: a case split, through `«迭则及»`. |
| `«不穷则迭»` (B2, positive) | `«不穷» R E x → ∀ n, ∃ y, «迭» («续» R E) n x y` | An unending line has steps of every length, on the grammar's own term. |

The scratch build gives 125 theorems in 148 declarations, every axiom report empty, with no warnings ([log](scratch-1.log)). Before it, the module had 120 in 143.

**Names.**
- `分` (to divide) pairs with `接` (to join); `逆` is the grammar's converse.
- The leading `或` of `«或有后则或迭»` means "as far as can be refuted", as in `«或屡»`: a successor as far as can be refuted, so steps as far as can be refuted.
- `«不穷则迭»` is "unending, so steps", after `«不穷则延»` (GrammarMap).
- `«迭则同一或及»` is after `«迭则及»` and `«所闭当且仅当同一或及»`.
- None of the five names occurs elsewhere in the package.

## `reaches_onward`, retired into B2

`Web.reaches_onward` (MapInstances) proves, by its own induction, that an unending line reaches an occurrence at every later step. Its induction does two things at each step: it takes the next occurrence from endlessness, and it tracks the index. The first is `«不穷则迭»`'s content, so it is now proved from that law (rule 9):
- `«不穷则迭»` gives `k` steps;
- `«迭则同一或及»` places their end within the line's reach;
- a new web lemma, `steps_advance` (`k` steps of a continuation under `continuationStep R` advance the index by `k`, its own induction), gives the index.

The statement is unchanged. The law replaces the step-by-step taking of a successor, and what remains is the representation of the index, so the law is not applied and then undone. The five activity laws resting on `reaches_onward` reach `«不穷则迭»` through it, unchanged. `MapInstances` is compiled in the landing's rehearsal run, since a scratch build would recompile the whole closure above the changed `GrammarLaws`.

## What this part does not do

- It derives none of the four lineage laws; that is the third part.
- It states neither B2's unbounded form nor B1's `m + n` reading as grammar laws. Each is one line from what is stated, at its use.

## Landing

On OU3d's pattern, after WRT2, whose new module imports `GrammarLaws`. Main is merged first, and then:
1. a rehearsal run outside the repository, then the landing run reusing its steps;
2. signatures: every earlier statement of both modules unchanged; five new laws and `steps_advance`;
3. the connectivity register: `«迭之分»`, `«迭之逆»` and `«或有后则或迭»` are apart roots until the lineage laws use them; `«不穷则迭»` and `«迭则同一或及»` are used by `reaches_onward`;
4. 01 §7's finite-runs bullet;
5. the record master-laws-on-the-grammar's group of steps counted;
6. a study section, carrying the audit's main finding: of the 436 theorems that read only activity, 400 are laws of their models, so the general content this layer leaves to lift is small.

## The review, and what was taken

One independent read-only review by a separate AI agent, the reviewer of the audit ([REVIEW-LAWS](REVIEW-LAWS.md)). It found the five laws right and constructive and the set close to minimal. It also found `reaches_onward`'s re-proof a genuine rule-9 derivation, which it compiled over main's `MapInstances`, with empty axiom reports (`checks/`). Every finding was taken.
1. **The header overclaimed.** It now says three of the models' step-indexed laws follow from the laws of steps. *What is not shown* names the lineage laws, the item's next part.
2. **`«迭之分»`'s docstring** no longer calls `«迭之末步»` its case. That case is `1 + n` steps, the last read as `«迭» R 1`, and runs one way only.
3. **`«迭则所及»` is now the general `«迭则同一或及»`**, for any relation, of which lying within a line's reach is the case at the line's continuation, by definition (rule 9).
4. **`«或有后则或迭»`'s docstring** explains its double negation instead of claiming it is the exact strength, which nothing proves.

The review's note for the next part is kept for its design. Write the restricted step for `split` and `through` as `«续» (continuationStep R) E_N`, so that `steps_advance` fixes B1's middle step, and state the bridge for any bound `N ≤ M`.
