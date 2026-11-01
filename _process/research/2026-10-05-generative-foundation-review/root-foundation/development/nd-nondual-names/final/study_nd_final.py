#!/usr/bin/env python3
"""ND's final stage: append its section to the study (argv[1] the section number), once.
usage (from the checkout root, after nd_final.py): python3 -B study_nd_final.py N"""
import sys
from pathlib import Path

N = int(sys.argv[1])
STUDY = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md')
text = STUDY.read_text(encoding='utf-8')
assert '(ND, final stage)' not in text, 'the section is written'
last = max(int(l[3:].split('.')[0]) for l in text.split('\n') if l.startswith('## ') and l[3:4].isdigit())
assert last + 1 == N, (last, N)
SECTION = f"""
## {N}. Names that state relations, not rule: the record id and the view (ND, final stage)

Board item ND's last part, after part 1 (§486, the documents) and stage 20-nd in OU7's rebuild (§492, the core's
names and docstrings). What part 1 kept because it is matched, not read, while four items edited the record, and
what 20-nd could not reach from inside a core rebuild: the record id, the view's names, keys and category values.
08 §10's criterion holds for each: "master" states rank where 08 §7 measures only proof dependence
([study](development/nd-nondual-names/final/)).

```text
Result(s): no new result. master-laws-on-the-grammar renamed shared-laws-on-the-grammar by research.py rename-id
       (receipt _process/architecture/renames/nd-shared-laws-id.json): the old id in former_ids, records/
       master-laws-on-the-grammar.md a generated redirect, links and mentions in the live texts and the records'
       dependencies rewritten; a history note on it and on one-root-to-its-edge.
Delta:
  - The view: tools/research/master_laws.py, data/master-laws.json and tests/test_master_laws.py are
    shared_laws.py, shared-laws.json and test_shared_laws.py (git mv). In the research tools, the two measure
    scripts (measure_grammar.py, EC's measure.py) and the connectivity script, every key, identifier and category
    value naming a master law names a shared law: master_laws → shared_laws (also the coverage file's key and
    THEOREM-CONNECTIVITY.json's), 'master law' → 'shared law', 'no master law' → 'no shared law',
    resting_on_no_master_law → resting_on_no_shared_law. The renderer's labels were already "shared law" (§486),
    so no record page reads differently.
  - Regenerated, not edited: THEOREM-CONNECTIVITY.json and data/shared-laws.json from the checker's cache (no core
    run); each equals the old one with every key and string mapped, but for the commit and receipt the
    connectivity was written at, the inputs' digests (the renamed and edited scripts) and boundary_check.lean's
    digest, whose comment names the generator (nd_final_verify.py).
  - Texts: 08 §7 and one-root-to-its-edge's validation scope name shared_laws.py; 08 §10's sentence on where the
    old name stays, which rename-id had turned into naming the new id, now reads where it is matched, not read
    (the former id, anchors kept beside the new ones, the studies' paths); the glossary's note likewise; the
    workflow's section on the view; the Lean README's two rows; two notes in regions.json; one item in
    arguments-a-l.json; the connectivity register's reasons (the record id, "a shared law on the grammar", and
    Concave.roots naming rises_superadditive, 20-nd's name).
  - Kept, with reasons: the study folders' paths (ou3b-master-laws-on-the-grammar, ec6-no-master-law), receipts,
    reviews, the board's and the study's past entries, history notes; the anchors master-laws and
    7-master-laws-and-connectivity beside the new ones; the record's aliases; "one master law of optimization"
    (arguments-a-l.json), which names what a collective's activity is not.
Supplied premises / correspondence: none; no statement's content changed.
Evidence: every change beyond a mapped name listed above and checked by repoint_nd_final.py (the old text with
       the names mapped equals the new one elsewhere); render, strict check, links, the tests and both dossier
       checks pass; the records citing the changed texts re-pointed, each read against the new text, nothing it
       says changed.
Standing: naming only.
Boundary:
  - Left for the next core landing: check_becoming.py's scope text says "the five master laws" and "rest on no
    master law" (proposed-checker-scope.patch). The scope is written into each core receipt, so edited without a
    core run it would stand apart from the latest receipt's; the next core landing carries it.
  - Passed to its owner, not edited: AJ4's failure-mode map says "master law" in its prose (its link to the view
    and the generator's name follow here).
  - After this stage a live text names a master law only as an alias, a former id, an old anchor, in history, in
    the checker's scope until that landing, or on AJ4's map until its owner's edit.
```
"""
STUDY.write_text(text.rstrip('\n') + '\n' + SECTION, encoding='utf-8')
print(f'study section {N} written')
