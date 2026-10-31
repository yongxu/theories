# Stages

Extra patch sets that ride in OU7's rebuild, each its owner's, such as U4c's census laws and ND's renames. A stage is a directory here, `NN-name/`, and stages are taken in name order.

| file | what it is |
|---|---|
| `*.patch` | the series: unified diffs from the repository root, applied in name order. Make them against the tree after the kit's `apply` (its patches and joins) and the stages before this one. In a throwaway copy of main, run `land_ou7.sh prepare` and `apply` first |
| `EXPECTED.json` | what the audit and the register expect of the series ([below](#expectedjson)) |
| `repoint_reason.txt` | one line, joined to the kit's reason for the one re-point pass. `{N}` stands for the study section |
| `study.md` | the stage's paragraph in OU7's study section |
| `SKIP` | leaves the stage out |

`OU7_STAGES`, when set, names the stages taken, and `none` takes none. A stage whose series does not apply is dropped, and OU7 lands without it (R10). The audit, the receipt line, the study section and the commit name only the stages in place.

A stage leaves the counts in the validation scopes of `master-laws-on-the-grammar` and `not-going-out-of-a-region` to the record stage, which reads them from the receipt.

## EXPECTED.json

Every name is written as the audit keys it: `Becoming.` and the name as written in its source. So a declaration written `foo` inside `namespace X` is `Becoming.foo`. Each key is optional:

- `added`: `{module: [names]}`. List every module whose code the stage changes, with the names it adds, possibly none. A module not listed must keep its code, comments blanked.
- `cases`: `{module: {name: proof}}`. A law proved as a case of a new one, with the proof text it must contain.
- `moved`: `{name: [from module, to module]}`. The declaration moves unchanged, and the target need not list it under `added`.
- `redefined`: `{name: [old body, new body, definition, {bound name: argument}]}`. The new body must unfold to the old one.
- `restated`: `{name: why}`. A statement that changes, such as a universe generalization or a renamed name inside it.
- `renamed`: `{old: new}`. The statement is kept but for the name.
- `roots`: `{name: [module, category, reason]}`. The register entries for the stage's apart roots.
- `now_used`: `[names]`. Register roots the stage's code now uses, whose entries go.

## The dry run

[dry_run.py](../dry_run.py) takes every stage the landing takes:
- its tree holds the files the series changes;
- its synthetic receipt holds the declarations `EXPECTED.json` names;
- the records the series changes are re-pointed and validated with the rest.

A module a stage adds is not modelled in the synthetic receipt.
