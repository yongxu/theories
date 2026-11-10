# Step 2b: every hypothesis a law binds, for families C and D

*AI-written, 10 November 2026, for AA's plan §13. Done on Ren's yes to about five agents ([his answer](../../../../../../../sources/15-codex-theory-conversations/2026-11-10-aa-premise-lists-agents.md)).*

Step 2 gave each law of families C and D a list of the premises it takes. Those lists were partial. This step made them complete in one respect: every hypothesis a law's Lean statement binds is now listed. That covers every binder whose type is a proposition, whether explicit, implicit or an instance, and whether before the colon or as a leading hypothesis after it.

## How it was done

1. **The binders, from Lean.** `binders_lean.py` writes a Lean module. For each law it runs `forallTelescope` over the elaborated type and prints the binders that `isProp` accepts. It ran on 10 November 2026 against the Becoming core at main `ea4e5c523`, with the core run's cached build. It read 344 laws; their binders are in `binders.json` (666 of them; 118 laws have none), with two rows marked missing: the two Becoming-named laws that lie in the periphery. The other 40 laws are in the periphery, outside the core, and their statements are in `periphery.json`. The extractors read their binders off the source, 34 in all.
2. **Each binder mapped to the premise it states.** An extractor for each family did this, and a checker set to refute it read every mapping. Their corrections are in `check-C.json` and `check-D.json`. Every binder now maps to at least one premise: 700 in all, 261 of them to one of the 126 new premises.
3. **Folded in by the session.** It applied the checkers' corrections and made three decisions of its own:
   - **The merges.** The brief's rule 4 (one premise per module) contradicted the ledger's rule (one proposition is one premise: the same definition, with its parameters in the same roles). The ledger's rule wins, so 14 per-module copies were merged into the 10 premises that receive them.
   - **The `data` class.** It replaced the D checker's `form` for decided, as said below.
   - **The merged statements.** Four were re-said generally. Two of them had dropped the C checker's fixes; those were restored after the reader's first round.

   A fresh reader then read the result against the Lean in two rounds, both fixed in full. The first found 1 high, 5 medium and 12 low:
   - six binders had been mapped to the World premise of balance where they state balance only on what couples in, and two premises were added for that;
   - `CarrierCounts`'s field of others present was added as a premise taken through data.

   The second read the fixes and found 1 medium and 9 low. Three laws on groups took others present through a definition the first script did not open.

   No existing premise was renamed, merged or removed.

`mapping.json` gives, for each law, its binders with the premises they state. It also says how each listed premise that no binder states is taken:
- `definition`: a definition the statement is made through;
- `commitment`: a commitment of the representation;
- `form`: held by the law's form. Unread where nothing beyond the share is read; Accrues where the course's loss grows by one a step by its definition; the in-sync start where the course starts at the rule read from its counts.
- `data`: a premise taken through data, not through a proposition:
  - decided, through binders of type `Decidable` or `DecidableEq`, instances or explicit;
  - a supplied law of exchange;
  - others present, a field of `CarrierCounts`, on 54 laws. `uses_lean.py` read each of the 344 core laws' statements: 51 use its constants, and 3 more (on groups) use them one definition deeper, through `RuleShaping.Grouped`. `uses.out` holds the result, one line per law. None of the 40 periphery laws' sources uses `CarrierCounts`.

A test in `tools/research/tests/test_atlas.py` (`Step2bTests`) checks every listing of a C or D law against the mapping, three ways:
- every premise a binder states is listed;
- every premise taken another way is listed;
- nothing else is listed.

## What it does not do

- It does not list every definition a statement is made through. Those stay as the readers found them.
- It does not check the Lean again after 10 November. A law changed later needs its binders read again.
- The lister reads the binders and the conclusion's leading implications, not what the conclusion assumes inside a conjunction, an iff, a negation or a definition that must be unfolded.
- A hypothesis carried in data (an instance of `Decidable`, a structure's field) is listed only where a reader or a script named it, as `data`. The lister does not find it.
- One proposition is held by two premises, because existing ids are kept. `lumpedseeking-weighs` is a positive mass under a likelihood. `expectedfreeenergyreals-weighs` is a positive mass under the seeking weight. `seeking_keeps_order` passes its binder to `order_kept` with the seeking weight in the likelihood's place.
