# Step 2b: every hypothesis a law binds, for families C and D

*AI-written, 10 November 2026, for AA's plan §13. Done on Ren's yes to about five agents ([his answer](../../../../../../../sources/15-codex-theory-conversations/2026-11-10-aa-premise-lists-agents.md)).*

Step 2 gave each law of families C and D a list of the premises it takes. Those lists were partial. This step made them complete in one respect: every hypothesis a law's Lean statement binds is now listed. That covers every binder whose type is a proposition, whether explicit, implicit or an instance, and whether before the colon or as a leading hypothesis after it.

## How it was done

1. **The binders, from Lean.** `binders_lean.py` writes a Lean module. For each law it runs `forallTelescope` over the elaborated type and prints the binders that `isProp` accepts. It ran on 10 November 2026 against the Becoming core at main `ea4e5c523`, with the core run's cached build. It read 344 laws; their binders are in `binders.json` (666 of them, and 120 laws have none). The other 40 laws are in the periphery, outside the core, and their statements are in `periphery.json`. The extractors read their binders off the source, 34 in all.
2. **Each binder mapped to the premise it states.** An extractor for each family did this, and a checker set to refute it read every mapping. Their corrections are in `check-C.json` and `check-D.json`. Every binder now maps to at least one premise: 700 in all, 124 of them to new premises.
3. **Folded in by the session.** It applied every correction the checkers gave. It also made one decision of its own. The brief's rule 4 (one premise per module) contradicted the ledger's rule (one proposition passed unchanged from law to law is one premise). The ledger's rule wins, so 12 new premises that a law passes unchanged to another module's law were merged into the receiving module's premise. No existing premise was renamed, merged or removed.

`mapping.json` gives, for each law, its binders with the premises they state. It also says how each listed premise that no binder states is taken:
- `definition`: a definition the statement is made through;
- `commitment`: a commitment of the representation;
- `form`: Unread, held by the law's form;
- `data`: a premise taken through a binder that is data, not a proposition. This is decided, through instances of `Decidable` or `DecidableEq`, and a supplied law of exchange.

A test in `tools/research/tests/test_atlas.py` (`Step2bTests`) checks every listing of these laws against the mapping.

## What it does not do

- It does not list every definition a statement is made through. Those stay as the readers found them.
- It does not check the Lean again after 10 November. A law changed later needs its binders read again.
- The lister reads binders, not what a law's conclusion assumes inside an implication or an iff.
- A data binder that carries a hypothesis, such as an instance of `Decidable`, is listed only where a reader named it (as `data`). The lister does not find it.
- Two existing premises may state one proposition, and are left apart because existing ids are kept: `expectedfreeenergyreals-weighs` and `lumpedseeking-weighs`. The D checker named the pair.
