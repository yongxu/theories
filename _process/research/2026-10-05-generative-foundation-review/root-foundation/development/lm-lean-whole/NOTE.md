# LM's audit of the compiled package

Reading time: three minutes. Board item LM. What came of it is in [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#lm-what-rode-the-near-full-rebuild-and-what-stays-open-6-november-2026) and [the study](../../BECOMING-RENEWAL-READING.md); this note says what the scripts are. They were run from a scratch folder, so their paths name it, and they write nothing to the repository.

- `audit/EnvAudit.lean`: every written constant's name and module, statements and definitions given more than once, structures with the same fields, wrappers, binders nothing uses, declarations nothing reads. Run with `LEAN_PATH` at the compiled modules: `lean --run EnvAudit.lean OUTDIR`.
- `audit/EnvAudit2.lean`: predicates no theorem concludes, and imports a module does not read or that another import already implies. The 206 implied imports were left: they show what a module reads directly.
- `audit/EnvAudit3.lean`: predicates assumed by some theorem and supplied by no proof (`data/never_discharged.tsv`, 61, on the tree before LM), and those established only by being used (`data/discharged_only_by_use.tsv`). A name's absence from every proof term is a pointer to read, not a finding: most of the 61 are ordinary hypotheses of conditional laws.
- `audit/broken.py`: names in live text that resolved in the package before and do not now.
- `audit/merge.py`, `audit/merge_plan_block.py`: the merge of helpers stated more than once; `merge_plan_block.py`'s `PLAN` is the map from each copy to the one statement. `audit/record_names_mapping.py` and `audit/record_names_apply.py` carry the same map into the records.
