# Review of the HE2 items 6 and 7 kit

31 October 2026. An AI review, read-only, of `kit/he2_core_li.py` as first written, applied in a scratch worktree on main `8a8b0df82`. Four lenses ran, each reviewer reporting findings and one skeptic re-checking each lens's findings against the files: Lean and statement fidelity, records, texts and readings, and completeness and composition. Of 30 findings, 22 were confirmed: no blocker, 12 should-fix and 10 minor. 8 were refuted. Every confirmed finding is taken; one taking is a proposal to the grammar's owner. The kit, NOTE §8, `kit/he2_rebinds.tsv` and `kit/he2_compile_audit.log` are the revised state.

## What the reviewers checked and found sound

- **The four laws.** The three laws are type for type the statements of `CoreAndLi.lean`, closed by `example`s with its exact types. «则» S T is S ⊆ T, and "coarsest" is greatest by inclusion among the classes inside `E` that go alike, so coarser means more pairs, as in «粗化». The witness's conjuncts hold for `R = fun x y => x = 0 ∧ (y = 1 ∨ y = 2)` and `E = «静»`.
- **The renames.** No name in the live package writes 理 for the core afterwards, and no alias is left (`#check` on each old name fails). No new name collides with a declaration anywhere in the repository or on any unmerged branch. Of the 104 unmerged branches, only `mv-status` writes an old name, and only in frozen probe output.
- **The axioms.** Every axiom report of the new laws, the renamed declarations and their neighbours is empty, recompiled independently. GrammarLaws' imports are unchanged and all in the core.
- **The records.** The JSON is valid and keeps the repository's formatting. Every renamed name matches the Lean exactly. Validation fails before the checker run only as every Lean-changing item fails then, and the drift is for the re-point.
- **The texts.** The links resolve, the language rule holds, and the dossier checker reports no problem. HE2's item 1 and RV21b's edits do not overlap the kit's.
- **The kept flame names.** On both flame models the successor is fixed and the alike relation is a class, so the core there is a class the step goes alike across, a 理. In the one flame the core is also the coarsest such class, though ash has no successor.

## Confirmed findings and what was done

| Finding | Severity | Taken |
|---|---|---|
| The apart register (`THEOREM-CONNECTIVITY-APART.json`) is written by hand and is keyed by two renamed names. The kit's scan skipped it as generated, and the measure's `--check` would fail on stale and unregistered roots (three lenses). | should-fix | A register part (`--apply register LOG`) re-keys the two roots with their reasons and registers item 6's laws that the measure lists. The scan's generated list now names the generated files only. |
| «遍后则同行之类含于核» and «定后遍后则核为最粗同行之类» take `S` inside `E`, which the names do not say. Read literally they are false, since the whole relation goes alike under every step (shown in Lean, empty axiom report). | should-fix | Proposed to OU's owner: «遍后则其内同行之类含于核» and «定后遍后则核为其内最粗同行之类». The kit holds the names in four lines. |
| Prose still writes 理 for a line's regularity, the core, where it need not be one. This is in two docstrings, four README.zh cells and seven record fields. Decay's core, which the README calls 「完与否」之理, does not go alike (three lenses). | should-fix | Where the English writes "regularity", the Chinese now writes 规律. Where it glosses «足以定核», it writes 核. The correspondence says where the core is a 理. The flame clauses keep 理. |
| The board row lists items 1–5 only and says "every statement and name kept", and items 6 and 7 existed only as uncommitted work (three lenses). | should-fix | Asked of the row's owner, OU's owner. The hand-over documents are to be committed with the study. |
| Law 15's clause "a class going alike lies in its core" drops the successor everywhere that «类同行遍后则含于核» takes, and the new clause beside it made the drop easier to misread (two lenses). | should-fix | The clause now carries the premise, and the new law stands beside it as the general case. |
| The master-laws record's `validation_scope` and 08's counts change with item 6's four theorems, and neither the kit nor NOTE §8 said so. | should-fix | Added to the landing steps in NOTE §8, since these are HE2-wide. The records part adds the integration and review references for item 6. |
| One identical history note went into every record. It listed all seven renames and gave the core's reason even for the law rename (two lenses). | minor | Each record's note names its own renames and rewordings. The law rename gets its own reason. |
| The kit always wrote its notes, so a record that other HE2 items also change could get two HE2 notes. | minor | `--no-notes` prints the clauses for one HE2 note per record. |
| The witness's type ties neither the occurrences to `R` nor `E` to the identity, so the sentence in 01 §4 described the proof term, not the statement. | minor | The witness now states `R 0 1 ∧ R 0 2 ∧ (∀ x y, E x y ↔ x = y)`. |
| Keeping the flame names rested on «定后» of both flame steps, which no audit checked. | minor | The audit adds the two «定后» facts, the class of the two flames' alike relation, and «定后则类之核同行» on both models, all with empty reports. |
| NOTE §8 did not say what a signature audit should expect. | minor | NOTE §8 lists the expected differences. |
| The kit edits two passages of the pinned review packet without saying so. | minor | NOTE §8 states the exception (the dossier's own checker needs the Lean names to exist), and RP's owner is told. |
| The lumping bullet in 01 §7, the master-laws record's home section, does not mention the law's new sentence. | minor | One sentence points to the theorem in §4. |
| The records part found the lumping law by its position, contrary to the docstring. | minor | It finds the law by «类同行遍后则含于核». |
| NOTE §8 gave the wrong number of rebind rows and an incomplete list of landing steps. | minor | Corrected. |

## Refuted

The skeptics refuted these as non-defects: the pre-run validation failures and drift (expected before the checker run); the compile log's scope (it claims only the import closure); `CoreAndLi.lean` staying live (study Lean stays as evidence, as with DrawnShaping and ReadInTime); the history note's word 理 (used in the glossary's sense); the one flame's "its 理" in BUDDHIST-THOUGHT (exactly true on that model); 01 §7 not listing every declaration of law 15 (refuted, though a pointer was added on the composition lens's minor finding). Two findings were raised twice and are counted once above.

## Beside the review

RP2b's independent read found that 07 glosses 生生 without its label [AI reading, D1], in §2's "What widening counts" and in T8. GLOSSARY.md and 01 §6 carry the label. The texts part adds the label in both places and puts it inside P-26's quote of T8 in the philosophy dossier, keeping it once, as agreed with RP's owner.
