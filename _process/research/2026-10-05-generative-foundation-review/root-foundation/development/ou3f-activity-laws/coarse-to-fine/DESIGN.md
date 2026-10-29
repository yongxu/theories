# OU3f, derivations: the coarse-to-fine pair

AI-written design for the last part of board item OU3f's derivations, 30 October 2026, on main at `cf5202bd7`, after the lineage laws (§451) and HE (§455).

## The two derivations

[The audit](../AUDIT.md) found two activity laws of `Becoming.Persistence` that are cases of the grammar's laws of lines and change, both small (*Two coarse-to-fine laws, both small*). Each old proof destructured the witness's "alike in the state class" to reach "alike in activity". That use of the projection is the grammar's law that what ends or begins under a coarser class ends or begins under a finer one; the projection itself stays, as the proof that the state class is finer. Its sibling `arises_of_persisting_arises` already goes through the law.

| theorem | the law | what it replaces |
|---|---|---|
| `Web.wang_state_of_change` | `«亡于粗则亡于细»`: what ends under a coarser class ends under the finer one | the projection's use on the witness, the state class's pair read at its activity half. Where activity changes across the step from `t`, the occurrence before it ends under activity, and the state class is finer than activity, so it ends there too. |
| `Web.sheng_state_of_change` | `«生于粗则生于细»`, the dual | the same use of the projection. The occurrence after the step begins under activity, so it begins under the finer state class. |

- Statements and names are unchanged. Each docstring names the law.
- Persistence's header (*Derived from grammar laws*) gains the two.
- The coarse class is named (`E' := W.activityClass`), and the finer-than proof is the state class's first half (`fun _ _ same => same.1`).

**The PartForms test.** The law replaces the old proofs' one use of the projection on the witness; the projection stays as the finer-than proof, and what remains, unchanged, is the argument that no successor along the names is alike in activity, since activity changes. Nothing is applied and then undone. Each derivation is small, as the audit counted it: genuine by the test, but minimal. Unfolding the law gives back the old proof term.

## OU3f is then done

The audit's derivations were:
- the fifteen rows in (a), to derive: seven by closure, `trace` among them; the twins and `ends_within`; the restricted bridge's `unique` and `origin`; this pair;
- the four rows in (b), with B1 and B2: `split`, `through`, `onward` and `back`.

All are derived after this part, and the rows that follow from them reach the grammar unchanged. The audit's *What follows* says nothing else among the theorems reading only activity is a derivation to make. The laws of their models keep their standing, with their reasons written down: three representations among them were re-proved through grammar laws along the way, standing unchanged (`ByPassing.line_back`, `Lineage.line`, `line_lineage`), and `Lineage.cons` was retired. So the landing closes OU3f's board row and moves it to the history file.

What the audit set aside, and the row's closing leaves for OU's plan to place:
- the alternation of a two-valued class over a listing, the seven Decidedness rows (b, not proposed);
- `arises_within`, a candidate case of `«两端分则中有标»` that reads no field;
- the theorems that read `active` with other fields, the dependency audit's next groups;
- the layer that reads no field (WRP), such as `Reidentify.old_still` and `Linked.mono`.

## The signature scanner

OU3b's helper `signatures_ou3b.py` compares the definitions of the changed modules by their source text, and its scanner read lines of docstrings as definitions. HE's audit met one; OC5's owner counted eight more in GrammarPath.

The helper now blanks comments and docstrings before matching (`blank_comments`), as the catalogue's parser does.
- String literals (raw strings among them), «» names and character literals are kept, and a comment marker inside one is not read as a comment.
- A docstring opens with all of `/--`, so `/--/` opens one.
- A comment, string or «» name still open at the end of a file stops the scan, naming the module.
- Strings nested in an interpolated string's braces are not parsed; the package has none.
- Definitions are compared with runs of whitespace collapsed, so an edit of a comment inside a definition no longer reads as a rewrite.

[scanner_cases.out](kit/scanner_cases.out) runs it on 30 lexical cases, the review's five gaps among them, and on six texts left open at the end, all as Lean reads them. Run on every module of the package (receipt `20261029T191748.070149Z`, 349 modules; [scanner_check.out](kit/scanner_check.out), the review's check rerun), it drops 26 such lines, none of them a real declaration, adds none, and finds all 6,159 definitions. The review replayed the old and the new scanner over main's history since 15 October; rerun on the hardened scanner ([scanner_history.out](kit/scanner_history.out), 1,406 module changes), the new one never flags anything the old one did not, so no landed kit's verdict changes.

## Scratch build

[scratch-1.log](scratch-1.log), the build the review read: `Becoming.Persistence` has 86 theorems in 106 declarations, as on main, every axiom report empty, with no warnings. Fourteen modules depend on Persistence, the root among them. [scratch-2.log](scratch-2.log) rebuilds the tree after the review's header fix (*By closure*), with the same counts and reports.

## Owners

Persistence was last changed by HE (§455), which dropped its KeptOnward import, and before that by this item's closure part (`steady_held`, §445). OU3b's helper belongs to this item's line too (OU3b, §417).

## Landing

Behind any earlier clause, with no rehearsal needed for fourteen modules beyond a run outside the repository first. The steps run from [kit/land_ctf.sh](kit/land_ctf.sh) stage by stage (`run`, `texts`, `records`, `board`), each stopping at its first failure, their outputs kept in `kit/landing/`.
- **Signatures.** Every statement of Persistence prints unchanged, and nothing is gone or added.
- **Records.** None changes. The records pinning Persistence are re-pointed, each read first.
- **Texts.** The study section and 08's counts.
- **The board.**
  - OU3f's row moves to the history file, its state cell built from the row's own account with this part's landing added.
  - Persistence's header gains *By closure* (`steady_held`), which no longer stands under *Not connected*.
  - The queue gets its landed clause.
- **The measure** is rerun, and MV's generator after the receipt.

## The rehearsal

On main at `8a4eddb9a`, with the receipt written outside the repository (`20261029T202455.829613Z`, passed, every axiom report empty; 61 steps ran and 1,335 were reused):
- the signature audit: all 86 statements of Persistence unchanged, nothing added, gone, moved or rewritten;
- the connectivity check is clean, with no apart root unclassified;
- the measure is unchanged: 45 of 127 central rows reach the grammar, and of the 118 distinct declarations 44, 31, 7 and 36, with no gap;
- the texts render, and the records check finds drift in exactly the four records pinning Persistence (`continuation-relative-to-a-class`, `identity-across-steps`, `master-laws-on-the-grammar`, `the-world-represented-both-ways`), each read: none names the two theorems, and `steady_held`, which two of them name, keeps its statement and proof. The re-point clears the drift;
- MV's generator, the render, the strict check, the links and the tests then run as at landing.

## The review, and what was taken

One independent read-only review by a separate AI agent ([REVIEW-CTF](review/REVIEW-CTF.md), its checks in `review/checks/`).
- **What it confirmed.**
  - All 106 declarations of Persistence print identically on main's build and the tree's, and the checker's own signature log is byte-identical.
  - Only the two proofs and their pattern-match helpers change, and the fourteen dependents compile cleanly.
  - The derivations are genuine but minimal.
  - The scanner fix drops 26 comment lines, adds none, and keeps all 6,122 definitions it scans.
  - OU3f is complete: all fifteen (a) rows and four (b) rows reach their named grammar laws.

Every finding was taken.
1. **Persistence's header** still listed `steady_held` under *Not connected*; it now has a *By closure* bullet.
2. **"Replaces the projection"** said too much: the projection stays as the finer-than proof, and its use on the witness goes; what remains is stated exactly. "The 398 keep their proofs" is now their standing kept, with the three representations re-proved and `Lineage.cons` retired named.
3. **The review paragraphs** are written, and `texts_ctf.py` refuses a placeholder.
4. **Three texts other owners hold** still say OU3f is open: OU's row, the board's "The way now" item 4, and the record the-world-represented-both-ways' `next_delta`. Their owners are told at landing.
5. **What the audit set aside** is listed above, for OU's plan to place.
6. **The board's land step** builds OU3f's closing state from the row's own cell.
7. **`blank_comments`** keeps strings and «» names, reads raw strings and `/--/` as Lean does, and stops, naming the module, on anything still open at the end of a file.
8. **Definitions are compared with whitespace collapsed**, and the claims about comment edits and spurious differences are stated exactly.
9. **Counts:** seven by closure, HE as the last change to Persistence, fourteen dependents.
10. **The history row** goes after the last row of the recent landed block, wherever HE's is.
11. **The kit's usage lines** name its own scripts.
