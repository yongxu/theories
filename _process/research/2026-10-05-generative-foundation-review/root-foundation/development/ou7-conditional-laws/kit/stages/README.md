# Stages

Extra patch sets that ride in OU7's rebuild, each its owner's. A stage is a directory here, `NN-name/`, and stages are taken in name order: U4c's census on the root as `10-u4c/`, then ND's names that state relations as `20-nd/`.

| file | what it is |
|---|---|
| `*.patch` | the series: unified diffs from the repository root, applied in name order, each to the tree the one before it leaves, so two patches may change one file. Make the first against the tree after the kit's `apply` (its patches and joins) and the stages before this one: in a throwaway copy of main, run `land_ou7.sh prepare` and `apply` with the earlier stages in place |
| `EXPECTED.json` | what the audit and the register expect of the series ([below](#expectedjson)) |
| `repoint_reason.txt` | one line, joined to the kit's reason for the one re-point pass. `{N}` stands for the study section |
| `study.md` | the stage's paragraph in OU7's study section |
| `SKIP` | leaves the stage out |

`OU7_STAGES`, when set, names the stages taken, and `none` takes none.

**Apply.** Each stage is tried first on a copy of the files its series changes, as the tree has them, patch by patch. A stage with no patch, or one whose series does not apply there, stops `apply` with the patch and git's words, and nothing of the stage is written. Its owner then rebases the series on that tree, or the landing leaves the stage out with a `SKIP` file or `OU7_STAGES`, and OU7 lands without it (R10). Run again, `apply` finds the stages already in place and goes on from the first that is not. The dry run drops such a stage itself, names it, and goes on without it, so that a failed stage never holds up OU7's own patches; it prints the `OU7_STAGES` the landing then takes.

The audit requires every selected stage in place. The audit, the receipt line, the study section and the commit name exactly the stages taken.

A stage leaves the counts in the validation scopes of `master-laws-on-the-grammar` and `not-going-out-of-a-region` to the record stage, which reads them from the receipt.

A rename of a record id is not a stage. It changes every record and page that names the id, so it comes after the rebuild, last, in its owner's own landing.

## EXPECTED.json

Every name is written as the audit keys it: `Becoming.` and the name as written in its source. So a declaration written `foo` inside `namespace X` is `Becoming.foo`. Each key is optional:

- `added`: `{module: [names]}`. List every module whose code the stage changes, with the names it adds, possibly none. A module not listed must keep its code, comments blanked.
- `cases`: `{module: {name: proof}}`. A law proved as a case of a new one, with the proof text it must contain.
- `moved`: `{name: [from module, to module]}`. The declaration moves unchanged, and the target need not list it under `added`. A name also under `restated` may arrive with its statement changed.
- `redefined`: `{name: [old body, new body, definition, {bound name: argument}]}`. The new body must unfold to the old one.
- `restated`: `{name: why}`. A statement that changes, such as a universe generalization or a renamed name inside it.
- `renamed`: `{old: new}`. The statement is kept but for the stage's renames: the audit takes the old statement, and a definition's whole text, replaces every renamed name (and each dotted suffix of it, as a name is written relative to its namespace) and every binder of `binders` by its new form, and requires the result to equal the new text exactly. A new name or binder already standing in the old text fails it, so no two names can be swapped. A kept declaration whose statement changes only so is accepted the same way, with no `restated` entry.
- `binders`: `{old: new}`. Bound names a rename carries along (`obeys` to `marks`), read only by that check.
- `roots`: `{name: [module, category, reason]}`. The register entries for the stage's apart roots.
- `now_used`: `[names]`. Register roots the stage's code now uses, whose entries go.

## The dry run

[dry_run.py](../dry_run.py) takes every stage the landing takes:
- its tree holds the files the series changes;
- the land script's `apply` tries and applies each series there, as in the landing; a stage that stops it is dropped and named, and the run goes on with the stages left;
- its synthetic receipt holds the declarations `EXPECTED.json` names;
- the records the series changes are re-pointed and validated with the rest.

A module a stage adds is not modelled in the synthetic receipt. The dry run builds nothing: a stage's Lean is checked by the rehearsal's `scratch_build.py` on the tree the earlier stages leave.
