# Brief: the English name table under the 中华本's discipline (ZE step 2)

AI-written task brief. You are building one table: an English name for every name of the 中华本's name table, under the same discipline that table follows. It is the control of a measurement: the 中华本's classical statements (經) introduced fewer referents the Lean lacks than the canonical English chapter, and one explanation is the name table's discipline (each name states the sense it takes and the senses it does not carry, and is anchored on Lean declarations), not the Chinese language. A controlled English edition will be written in your table and measured the same way. So the table must give English exactly the discipline the Chinese has: no less (or the control is unfair to English), and no more.

## Inputs (read only these)

- `data/names-input.jsonl` in this kit: the 449 rows of `../zhonghua/work/names-decisions.tsv`, in order. Fields: `row`, `zh` (the name), `pian` (its chapter, C01–C17), `sense_zh` (所名: the sense taken, usually with the English term in parentheses), `anchors_raw` (锚, the Lean anchors, verbatim), `anchors` (normalized), `note_zh` (注: provenance and what the name does not carry, 不带/不取), `glossary_same_anchor` (terms of the canonical English chapter's glossary §10 (a), (b) that share an anchor with the row, with their meaning).
- You may consult `../zhonghua/NAMES-ZH.md` (the same table, by chapter, with headings) and the glossary §10 of `theories/becoming/chapters/THE-THEORY-OF-BECOMING.md` (lines 1570–1790) when a row is unclear. Do not edit either.

## Output

`names-en.tsv` in this kit (tab-separated, UTF-8, header row, no quoting, no tabs or newlines inside a field), columns in this order:

`row`, `名`, `篇`, `name_en`, `sense_en`, `not_carried_en`, `锚`, `glossary_term`

- `row`, `名`, `篇`: copied from the input (`row`, `zh`, `pian`).
- `锚`: copied verbatim from `anchors_raw` (including `—` where there is none).
- `name_en`: the English name (see the rules below).
- `sense_en`: the sense taken, translated from `sense_zh` (one sentence or phrase; English only; a Lean name in backticks is allowed).
- `not_carried_en`: what the name does not carry. Two parts, in this order: (1) the 不带/不取 content of `note_zh`, translated (drop provenance and philology that states no exclusion; keep every stated exclusion); (2) the English-specific hazards of the English word you chose: its agentive senses (a chooser, an observer, a learner, an owner, intention, will, effort), its substantival senses (a thing or substance before relations, a container, a ground, an essence, a nature, a rank), and any technical sense from another field the word would import. Start part (2) with "In English, not". Never empty: where the Chinese note states no exclusion, part (2) still states the English hazards, or "In English, not: nothing beyond the sense; the word has no agentive or substantival reading here" when there truly is none.
- `glossary_term`: the glossary term you took the name from, or empty.

Write the table with a Python script (csv writer with `delimiter='\t'`, `quoting=csv.QUOTE_NONE`, an escapechar that never fires because you keep tabs and newlines out of fields). Work chapter by chapter if that helps; the final file has all 449 rows in input order.

## Rules for the English names

1. **One sense, one name, distinct.** Every row gets its own English name; no two rows share one (the checker ignores case, spacing and a plural -s/-es). Where the Chinese table distinguishes two names (for example 待者 / 所待, formation / condition; 变 / 变化, process / becoming; 生 / 化 / 变), the English names keep the distinction.
2. **Prefer the canonical glossary.** Where `glossary_same_anchor` holds a term whose meaning is the row's sense, take it (and record it in `glossary_term`). The English gloss inside `sense_zh`'s parentheses is often that term. Where two rows would take the same glossary term, the row whose sense is the glossary meaning keeps it and the other gets an exact variant.
3. **Structural and exact.** Formal, scientific and systems words; no dualist, social, financial or personal words. A name is adopted only where the statement means exactly that. Prefer a plain word with its hazard stated in `not_carried_en` over a coined phrase, but where the plain English word's leading sense is agentive or substantival (observer, chooser, agent, will, nature, essence, the Way, Heaven, law-giver, owner), choose a structural phrase instead (for example "what couples in", not "observer").
4. **Usable in running English.** The name is the word or phrase a statement will use: a noun phrase for a relatum, collection, amount, step or law; a predicate ("holds", "is decided", "couples into", "renews") where the Chinese name is a predicate. Function names of the table (negation 不, 未 "not excluded so far", 然 "holds", 定然否 "decided", and the like) get plain English names too.
5. **Keep the 中华本's sense, not the canonical chapter's where they differ.** The table's sense governs; where the glossary term means something else, do not take it.
6. **Each name is detected by string match** in the controlled English text (longest name first, whole words). Avoid names that are ordinary function words of English unless the Chinese name is the matching function word.

## Check before you finish

Run `python3 -I check_names.py` in this kit. It checks: 449 rows in order with the same 名, 篇 and 锚; every anchor resolves in the newest core receipt; English names distinct; every row has a name, a sense and a not-carried field; no Chinese characters in `name_en` or `sense_en`. Fix every failure and rerun until it prints `ok`.

Report: the number of rows, how many names were taken from the glossary, and any rows where you were unsure (row number and why), in at most 15 lines.
