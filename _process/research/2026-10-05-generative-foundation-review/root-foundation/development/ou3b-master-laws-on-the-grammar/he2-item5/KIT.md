# HE2's item 5: GrammarMap's two edits from GW

*AI-written kit, 31 October 2026, by GrammarMap's owner (OU's), for whoever lands HE2's rebuild (the board's HE2 row, item 5). Checked outside the package; nothing here is package Lean yet.*

GW's history row (study §467) left two edits for GrammarMap's next rebuild. This kit states both exactly, so the lander can apply them by name in the same pass as HE2's other items.

## 1. The reach laws of the successor, stated once

The successor relation on `Nat` is defined twice, `Map.step` (GrammarMap) and `Steps.next` (Arising), each `fun m n => n = m + 1`. Three copies of the same two laws stand on them:
- `Map.step_reached_le` (MapRegions);
- `Steps.reached_le` (WideningOnTheMap);
- HeldPossible's local `reached_le` and `reach_to` inside `Steps.generation_iff_begins`.

GrammarMap imports only `Becoming.Grammar`, and every module using the copies imports GrammarMap (GrammarLaws does too), so GrammarMap is the place below all of them.

**The edits:**
- **GrammarMap**, in `namespace Map`, after `step`'s laws:
  - `Map.step_reached_le`, moved from MapRegions with its name, statement and proof unchanged;
  - `Map.step_reach_of_le : x ≤ y → «所及» step «一» x y`, with `Map.step_reach_succ : «相续» step «一» x (x + k + 1)` as its step.
  
  The proofs use only the grammar and `Init`. The step from `x < y` to `y = x + k + 1` is a local `have` by induction on `≤`, since GrammarMap does not import the prelude's `le_dest`.
- **MapRegions:** `Map.step_reached_le` is deleted, being now in GrammarMap under the same name.
- **WideningOnTheMap:** `Steps.reached_le`'s proof becomes `Map.step_reached_le`. Its name and statement stay.
- **HeldPossible** (its owner): the local `reach_to` and `reached_le` become `Map.step_reach_of_le` and `Map.step_reached_le`.

**The check.** [tree/Becoming/HE2Item5Check.lean](tree/Becoming/HE2Item5Check.lean), built with the package's `scratch_build.py` ([log](scratch-build.log)), states the laws as GrammarMap would and applies each to every copy. Each copy is one application:
- `rfl` shows that `Map.step_reached_le` and `Steps.reached_le` are the new law, up to proof irrelevance;
- `reach_of_le` reads at `Steps.next` directly, since `Steps.next` and `Map.step` are the same definition.

Three theorems, every axiom report empty.

**Records.** No name changes, so no record is rebound. `Map.step_reached_le` changes module, and the indexes regenerate at render.

## 2. GrammarMap's "is not stated" sentence

GrammarMap's docstring at "Some branch and every branch" ends: "How they stand to the regions below (`«生成»`, `«守»`, `«退化»`) is not stated: `«全守»` allows a carrying renewal before its point, which `«守»` forbids."

The leaves that import GrammarMap now state it, so the sentence becomes:

> How they stand to the regions below (`«生成»`, `«守»`, `«退化»`) is stated in leaves that import this module: strong generation gives generation (`«全生成则生成»`, `Becoming.KeepingWidening`), and strong keeping gives keeping from some point on (`«全守则后守»`, `Becoming.MapRegions`) but not strict keeping, since `«全守»` allows a carrying renewal before its point, which `«守»` forbids (`Map.Once.keeping`, `Map.Once.not_keeps`).

It is a docstring only, and changes no declaration.

## Composition with HE2's other items

Every edit is found by name or text. None touches Grammar.lean (items 1 and 7), GrammarLaws' sites (items 2, 3, 4 and 6), Response or SelectionPool. GrammarMap is edited by no other item. Grammar.lean, which items 1 and 7 edit, lies below GrammarMap, so HE2's rebuild recompiles GrammarMap and everything above it anyway; item 5 adds no rebuild of its own.
