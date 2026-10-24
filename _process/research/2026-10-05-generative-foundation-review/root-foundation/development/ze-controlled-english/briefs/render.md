# Brief: the controlled English rendering of the 經 (ZE step 3)

AI-written task brief. The 中华本 (the Chinese edition of the Theory of Becoming in plain classical Chinese) states each checked law in a 經: one or a few short clauses, written only in the names of its name table, each clause a full statement with its conditions. You are rendering those 經 into English, clause by clause, under the same discipline: an English name table (`names-en.tsv` in this kit) gives each theory name an English name, the sense it takes and what it does not carry. The result is a controlled English edition that shares one source with the 經: every English clause is keyed by the 條 id and the clause number of the Chinese clause it renders.

## Inputs (read only these)

- `names-en.tsv` in this kit: the English name table. Columns: `名` (the Chinese name, traditional script; the 經 write it in simplified script), `name_en`, `sense_en`, `not_carried_en`, `锚` (Lean anchors), `glossary_term`. Read it in full first.
- Your batch file `data/render-input/batch_K.jsonl` (K is given in your task): one line per 條, with `tiao` (its id), `title`, `pian`, `clauses` (each with `j`, the clause number; `zh`, the Chinese clause; `names`, the table names found in it by string match, as [Chinese, English name] pairs; `states`, the Lean declarations the clause states, where an alignment exists), and `lean` (a compact form of those declarations: name, kind, binders, conclusion, and a definition's body, cut where long).

## Output

`data/render-output/batch_K.jsonl`: one JSON line per 條, in input order, `{"tiao": ..., "title_en": ..., "clauses": [{"j": 1, "en": "..."}, ...]}`, one entry per input clause, same `j`, same order. Write it with a Python script (`json.dumps(..., ensure_ascii=False)`); you may write it in several passes and append, but the final file has every 條 of the batch once.

## Rules

1. **One clause, one rendering.** Each Chinese clause becomes one English sentence (or clause ending with ";" where the Chinese clause ends with "；"). Do not merge, split or reorder clauses.
2. **Theory terms only from the table.** Where the clause uses a name of the table, write its `name_en` (inflected as English grammar needs: plural, verb form, article), in the table's sense. Write no other theory term: no word of the canonical English chapter or of any field's vocabulary that the table does not give. The `names` hints are string matches and include false hits inside ordinary Chinese compounds (for example 分别 "distinction", 方法 "method", 要求 "requirement", 所以 "so"): there, write plain English, and do not use the table's name. Where a clause uses an ordinary word that is not a theory term, write plain English for it.
3. **Statement form, like the 經.** A definition "X 者，Y 也" / "X，Y 也" becomes "X is Y." A law becomes a full statement with its quantifiers and conditions: "For every …, …", "If …, then …", "… exactly where …" (恰當 is exactly where, an if-and-only-if), "… and not …". Keep every condition and quantifier the clause states (有窮 finite, 已定 / 定然否 decided, 列出 listed, 凡 every, 有 some, 不可非 cannot be refuted, and so on, in the table's English names where they are names); add none it does not state.
4. **Nothing beyond the clause.** No slogans, metaphors, examples or value judgments the clause does not make; no first person, no "we", "one" (as a pronoun), "the reader", "the observer", "someone"; no agent where the clause has none. Pronouns and deictics (其, 之, 此, 彼) are rendered by the noun they refer to or by "it", "its", "this", as the English needs.
5. **The Lean is a key to the reading, not a source of content.** Use the `lean` forms only to settle which reading of an ambiguous clause is meant: which antecedent 其 or 之 has, which relatum a role word names, whether 恰當 joins what to what. Never add a binder, condition or conclusion the clause does not state, never drop one it states, and never correct the clause by the Lean. If a clause seems to disagree with its Lean, render the clause and list it in your report.
6. **Codes stay as they are.** Lean names in backticks, numerals, variables and cross-references (見三·七, "see 三·七") stay as written; render 見 as "see".
7. **English only.** No Chinese characters in the English, except a 條 id in a cross-reference.

## Before you finish

Run `python3 -I check_render.py data/render-output/batch_K.jsonl` in this kit; it checks that every 條 of your batch is there with the same clauses, that no clause is empty or holds Chinese characters (outside 條 ids), and lists personal words and table-name coverage for you to look at. Fix every failure.

Report in at most 12 lines: the number of 條 and clauses rendered, the clauses where the Chinese seemed to disagree with its Lean (條 id, j), and any recurring difficulty.
