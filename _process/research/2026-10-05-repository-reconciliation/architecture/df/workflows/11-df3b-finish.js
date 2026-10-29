export const meta = {
  name: 'df3b-finish',
  description: 'DF3 batch B: finish what a network outage stopped (migrate three records of unit K; review units K, M, B, C and J)',
  phases: [{ title: 'Migrate', detail: 'one migrator per unit rewrites its records in place and writes mapping tables' }, { title: 'Review', detail: 'one skeptic per unit returns exact edits' }],
}
const W = '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/wt-df3b'
const KIT = '_process/research/2026-10-05-repository-reconciliation/architecture/df'
const UNITS = args.units
const MIGRATED_BY = args.migrated

const CONTEXT = `You are working on board item DF3, batch B, in the theory repository: migrating schema-1 result records to schema 2, with laws arrays. Your git worktree is ${W} (branch df3b, cut from main). Use absolute paths, or cd into ${W} within each command. Twelve other agents work in the same worktree at the same time on other records: edit only your own records and create only your own mapping files; edit no chapter, Lean file, regions.json, generated page or other record; never run make research-render (the lander renders); ignore check errors that name other ids, and ignore "generated view differs" errors (the views are rendered later). Use python3 -B tools/research/research.py lint --ids <your ids, comma-separated> as often as you like; run python3 -B tools/research/research.py check (it validates every record, slowly) at most twice, at the end.

Batch A (thirty records, landed) is the model: read ${KIT}/DF3-PLAN.md; three migrated records and their mapping tables, theories/becoming/results/records/market-finite-support-obstruction.json, joint-code-plan-lifting.json and metaethical-core-characterization.json with ${KIT}/df3-mapping/<the same id>.md; and _process/RESULT-WORKFLOW.md, sections "Writing a record (schema 2)" and "Migrating a schema-1 record" (the rules below are from it). Shared boundary keys and their exact sentences: theories/becoming/results/data/standard-boundaries.json (cite a key only where its sentence is true of the record: no-ethical-premise only where the hypotheses hold no ethical premise and the bound receipts report empty axioms for the cited declarations). The snapshots are taken already: ${KIT}/df3b/snapshots.json gives each record's text_versions entry (the exact bytes before migration). ${KIT}/df3b/triage-rows.json gives, for each record, the rows of ${KIT}/triage.json whose evidence and fix bear on it (DF1's triage; the proposals are a starting point, checked against the Lean as it now is).

Each migration, per record:
1. Read the record, its snapshot, its triage rows, its home section (the paragraph or table row after <a id="r-<id>"></a> in theories/becoming/chapters/), and every Lean declaration it cites, in the current worktree (statements, hypotheses, docstrings).
2. Set "schema_version": 2. Keep id, kind, status, family, canonical_source, aliases, dependencies, related, references' paths and sha256, proof_bindings, counterexamples that a declaration witnesses, and the earlier history entries unchanged unless a reason below requires it.
3. title: a short name, at most 100 English / 40 Chinese characters (keep it if it already is one). statement: what the result does, in one or two positive sentences, at most 300 / 150, no Lean names, sections, dates or receipts; keep the existing statement where it is exact; where there is none (46 of the 87 have none), write it from the record and its home section, saying what the home section says. If they disagree, the Lean decides: propose the chapter edit (exact old and new text), do not make it.
4. laws: one law per item {en, zh, declarations}, at most 420 / 190 characters each and 40 items, each saying exactly what its declarations prove. Each law item stands alone on the page: name in it every hypothesis its theorems take (decisions, finiteness, listing, positivity, ranges), never "so it" or "there" inheriting them from another item. iff only where the Lean proves both directions; a witness read as a witness ("can", "need not", "in a witness", "some e"), finite bounds not limits; a negated universal is not an existential (where the Lean proves ¬ ∀ k ≤ n, P k, write "no ... through n", not "... leaves within n steps", unless P is decided). Every declaration a law names must be listed in a references entry's declarations: add it to the entry of the file that defines it (grep the Lean to confirm it exists there, with its namespace); where the file has no references entry, add one with role proof and the file's sha256 and a proof binding: cd ${W} && python3 -B ${KIT}/binding_for.py <lean path> --decls prints both for the newest passing receipt binding the file's current bytes; if none binds it, say so and do not cite that file. Usually the claim splits into the laws; drop "claim" when the statement and laws carry all of it.
5. limitations is replaced: each substantive non-implication becomes a does_not_show item {en, zh, kind} with kind non-implication, converse, correspondence or scope, one sentence each, at most 240 / 110 and 8 items, an optional "witness" naming a declaration in references or an alias; "not shown" is a non-implication, not a negative result ("is not exact" needs a declaration that proves it); a sentence that a standard boundary key says exactly becomes that key in standard_boundaries; a premise goes to hypotheses (at most 9 items, 420 / 190 each); bookkeeping (rounds, receipts, sessions) goes to history or stays in the snapshot. A counterexample entry must be a case some declaration witnesses: one that no declaration witnesses, or that only repeats a limitation, becomes a does_not_show item (or goes, where an item already carries it; the mapping says so). A record needs counterexamples or does_not_show.
6. validation_scope: the kind of evidence and where its receipts are, at most 600 / 260 (an error above): name the modules, the checker that produced each bound receipt and its Lean version as the receipt records it (periphery receipts are often Lean 4.30.0-rc2, the core 4.29.1: read the receipt), the axiom reports as they are for the cited declarations ("at most propext and Quot.sound", "some none"), and receipts by directory or by name, never "the newest". next_delta: the next substantive step, stated positively, at most 400 / 180; not an instruction to reuse the result, not a step another record already completes. correspondence: keep it, cut only process markers; Ren's quoted words stay verbatim with their source and date; a choice presented as "Ren decided" becomes the construction with his proposal as provenance; every reading keeps its AI label ("an AI reading"), including readings of Lean names.
7. Never in title, statement, claim, laws, does_not_show, counterexamples or next_delta: round or item numbers (P92, DF1), section numbers (§29), dates, receipt timestamps, session ids, round narration ("this round", "has landed", 本轮), the status in other words ("remains open"), another record's status, instructions to later sessions. In every live field: no retired labels (G0, the one axiom, Part I/II, J, J1-J4, the registration vocabulary: use lumping, coupling, contacts or levels as the glossary says; the ids selection-under-registration-revision and formed-copying-registration stay, their renaming waits elsewhere); no words of exchange (account, cost, price, budget, fund, 账户, 成本) except where the record's subject is an exchange.
8. text_versions: first the record's entry from df3b/snapshots.json; then, if a history note names a compaction snapshot under _process/architecture/history/ (the R35 notes of 20 October 2026), that file as a second entry {path, sha256 (shasum -a 256), note {en: "Exact record bytes before its history was compacted (R35); every condensed note is kept here.", zh: "历史说明压缩前的记录原始字节（R35）；每条被合并的说明都保存在这里。"}}, if the file exists.
9. Map every old sentence: write ${KIT}/df3-mapping/<id>.md in batch A's form: "# Migration map: <id>", the old sha256 and snapshot path, the label legend (T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples; Chinese goes where its English goes), a sentence saying which Lean files the laws were read against and which conditions were kept, then | Old text | Type | New place | with every English sentence or clause of the old record in a row. Nothing is dropped silently: a sentence that goes nowhere public says where it is (history, snapshot) and why; a reason for dropping a condition must be true (check the Lean for a declaration that proves the condition is needed before saying none does). The table describes the record as you leave it.
10. Add one history entry and set reviewed_at_utc to the current UTC time ("2026-10-28T..:..:..+00:00"). History en: "28 October 2026: migrated to schema 2 (DF3 batch B, study section DF_N): <what changed: statement kept or written, the claim split into N laws each read against its declarations, limitations to does-not-show items, standard boundaries and hypotheses, declarations added to references, any narrowing>; no premise, status or source hash changed<, or say exactly what changed and why>. Every earlier sentence is mapped in [<id>.md](../../../../${KIT}/df3-mapping/<id>.md); the exact earlier record is the first text_versions entry." History zh: "2026年10月28日：迁移到 schema 2（DF3 第二批，研究第 DF_N 节）：……" saying the same. DF_N is filled at landing.
11. Write each record with json.dump(record, f, ensure_ascii=False, indent=2) and a final newline, keys in the model's order (schema_version, id, title, statement, kind, status, ...), as the records are. Lint must report no error for your ids, and each warning judged.

Terms: the account's current terms in the glossary's one sense (GLOSSARY.md); "first law" means only the spine's Flow.Gainless (第一律), thermodynamics' first law named in full; names structural, not social or financial words. The Chinese says what the English says. Ren's words are provenance, never the warrant for a claim; no person or AI is named in live fields except authors of cited literature.`

const MIGRATED = {
  type: 'object',
  properties: {
    records: { type: 'array', items: { type: 'object', properties: {
      id: { type: 'string' }, laws: { type: 'integer' }, does_not_show: { type: 'integer' },
      statement: { type: 'string', enum: ['kept', 'edited', 'written'] },
      claim_kept: { type: 'boolean' },
      declarations_added: { type: 'array', items: { type: 'string' } },
      references_added: { type: 'array', items: { type: 'string' } },
      narrowed: { type: 'string', description: 'any sentence of the old record that said more than the Lean, and how the migrated text says it' },
      chapter_edits: { type: 'array', items: { type: 'object', properties: { file: { type: 'string' }, old: { type: 'string' }, new: { type: 'string' }, why: { type: 'string' } }, required: ['file', 'old', 'new', 'why'] } },
      mapping_file: { type: 'string' }, lint_clean: { type: 'boolean' }, lint_warnings: { type: 'string' }, notes: { type: 'string' },
    }, required: ['id', 'laws', 'does_not_show', 'statement', 'claim_kept', 'declarations_added', 'references_added', 'narrowed', 'chapter_edits', 'mapping_file', 'lint_clean', 'lint_warnings', 'notes'] } },
    not_migrated: { type: 'array', items: { type: 'object', properties: { id: { type: 'string' }, why: { type: 'string' } }, required: ['id', 'why'] } },
  },
  required: ['records', 'not_migrated'],
}

const REVIEW = {
  type: 'object',
  properties: {
    edits: { type: 'array', items: { type: 'object', properties: {
      id: { type: 'string', description: 'record id, a mapping file path, or a chapter path for a proposed chapter edit' },
      field: { type: 'string', description: 'e.g. statement.en, laws[2].zh, laws[2].declarations, does_not_show[0].kind, hypotheses[0].en, references, mapping' },
      old: { type: 'string', description: 'exact substring now in the field (empty to set the whole field)' },
      new: { type: 'string', description: 'the replacement; for a list field (declarations), the whole new list as JSON' },
      severity: { type: 'string', enum: ['error', 'overclaim', 'imprecise', 'dropped', 'missing', 'style'] },
      why: { type: 'string' }, evidence: { type: 'string', description: 'file:line of the Lean, the snapshot or the source' },
    }, required: ['id', 'field', 'old', 'new', 'severity', 'why', 'evidence'] } },
    verdicts: { type: 'array', items: { type: 'object', properties: { id: { type: 'string' }, verdict: { type: 'string', enum: ['sound', 'sound-after-edits', 'redo'] }, note: { type: 'string' } }, required: ['id', 'verdict', 'note'] } },
    checked: { type: 'string' },
  },
  required: ['edits', 'verdicts', 'checked'],
}


const reviewPrompt = (u, migrated, note) => `${CONTEXT}

You are the skeptical reviewer of unit ${u.key} (records ${u.ids.join(', ')}; home chapter ${u.chapter}). Its migrator rewrote these records in place and wrote their mapping files (do not edit any file; return edits). ${note}
${migrated ? JSON.stringify(migrated, null, 1) : ''}

For every record, read the snapshot (the old bytes), the migrated record and its mapping file in full, and try to refute each part: (1) every old sentence is mapped and nothing substantive is lost (a limitation, hypothesis or condition dropped is an error, and a reason for dropping one that the Lean contradicts is an error); (2) every law says exactly what its declarations prove: open the Lean of each declaration and compare hypotheses, quantifiers, iff or only if, witness or law, bounds or limits, a negated universal or an existential; each law item names its own hypotheses; a law that states more than its declarations is an overclaim; a declaration named that does not exist in the referenced file, or is not in references, is an error; (3) each does_not_show kind is right, each counterexample is witnessed by a declaration, and each standard_boundaries key's sentence is true of the record (no-ethical-premise needs empty axiom reports for every cited declaration: read the receipts the proof_bindings name); (4) the statement agrees with the home section and the laws, within the caps; the home section says no more and no less than the Lean (propose the chapter edit where it does); (5) the evidence paragraph names each receipt's checker, Lean version and axiom reports as the receipt records them; (6) no process markers in public fields, no retired labels or words of exchange, readings with their AI label, English and Chinese saying the same, the history note and text_versions as required, the mapping table describing the record as it is; (7) run cd ${W} && python3 -B tools/research/research.py lint --ids <these ids, comma-separated>, and check once, and report any error for these ids. Check any proposed chapter edits the same way. Return each finding as an exact edit (record id or file, field path, exact old substring, new text) with the file:line that shows it, and a verdict per record. Default to reporting when unsure.`

const K = UNITS.K, M = UNITS.M, LOST = 'The migrator finished its edits but its returned summary was lost in a network failure; read what it left in the files.'
const kRest = ['target-capture', 'becoming-renewal-reading', 'represented-boundary-against-dependence']
const jobs = [
  () => agent(`${CONTEXT}

Your unit is K, region ${K.region} (home chapter ${K.chapter}); your records: ${kRest.join(', ')}. (Unit K's other records, ${K.ids.filter(i => !kRest.includes(i)).join(', ')}, are already migrated by an earlier migrator; do not edit them.)

Migrate each of your records as above, in place, and write its mapping file. Return, per record, what you did, any sentence you narrowed, and any chapter edit the home section needs (exact old and new text), without making it. Say what you did not migrate and why.`, { label: 'migrate:K-rest', phase: 'Migrate', schema: MIGRATED })
    .then(m => agent(reviewPrompt(K, m, `For ${K.ids.filter(i => !kRest.includes(i)).join(', ')}: ${LOST} For the other three, the migrator's summary follows.`), { label: 'review:K', phase: 'Review', schema: REVIEW }).then(review => ({ unit: 'K', migrated: m, review }))),
  () => agent(reviewPrompt(M, null, LOST), { label: 'review:M', phase: 'Review', schema: REVIEW }).then(review => ({ unit: 'M', migrated: null, review })),
  ...['B', 'C', 'J'].map(k => () => agent(reviewPrompt(UNITS[k], MIGRATED_BY[k], ''), { label: `review:${k}`, phase: 'Review', schema: REVIEW }).then(review => ({ unit: k, migrated: MIGRATED_BY[k], review }))),
]
return await parallel(jobs)
