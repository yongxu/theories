export const meta = {
  name: 'df3-migrate',
  description: 'DF3 batch A: migrate 30 schema-1 records to schema 2 with laws, in four units, each reviewed by a skeptic against the Lean',
  phases: [{ title: 'Migrate', detail: 'one migrator per unit rewrites its records in place and writes mapping tables' }, { title: 'Review', detail: 'one skeptic per unit returns exact edits' }],
}
const W = '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/wt-df3'
const KIT = '_process/research/2026-10-05-repository-reconciliation/architecture/df'
const UNITS = [
  { key: 'A', region: 'root (01-ROOT.md)', ids: ['only-the-order-of-change-shows', 'normal-forms-need-decided-apartness', 'continuous-time-as-tower', 'trace-law-equivalence', 'joint-code-plan-lifting', 'finite-trace-transport'] },
  { key: 'B', region: 'root (01-ROOT.md)', ids: ['becoming-context-coherence', 'joint-correlation-reduced-dynamics', 'derived-history-law-exactness', 'least-footprint-where-idleness-decided', 'joint-decomposition-lifting', 'finite-joining-tree-lifting', 'exclusive-footprint-support'] },
  { key: 'C', region: 'collectives and map (05-COLLECTIVES.md, 02-MAP.md)', ids: ['market-partial-correction-boundary', 'market-supported-finite-transition', 'market-finite-support-obstruction', 'market-protected-continuation', 'joint-plan-composition', 'draws-on-a-shared-stock', 'growth-constrained-fragmentation', 'renewing-consuming-formation', 'control-coherence-loss', 'effective-capacity-and-eventual-reachability'] },
  { key: 'D', region: 'significance and method (07-SIGNIFICANCE.md, 08-METHOD.md)', ids: ['classification-robust-generative-comparison', 'significance-retained-within-margin', 'metaethical-core-characterization', 'pending-task-context-applicability', 'recoverable-mediated-change', 'derivation-soundness', 'finite-basis-common-interpretation'] },
]

const CONTEXT = `You are working on board item DF3, batch A, in the theory repository: migrating schema-1 result records to schema 2, with laws arrays. Your git worktree is ${W} (branch df3, cut from main). Use absolute paths, or cd into ${W} within each command. Three other agents work in the same worktree at the same time on other records: edit only your own records and create only your own mapping files; edit no chapter, Lean file, regions.json, generated page or other record; never run make research-render (the lander renders); ignore check errors that name other ids, and ignore "generated view differs" errors (the views are rendered later).

Read first: ${KIT}/DF3-PLAN.md; _process/RESULT-WORKFLOW.md, sections "Writing a record (schema 2)" and "Migrating a schema-1 record" (the rules below are from it); one migrated record and its mapping table as the model of form: theories/becoming/results/records/attraction-is-not-returning.json (its history entry of 14 October 2026 and its laws, does_not_show, standard_boundaries, text_versions) and _process/research/2026-10-05-generative-foundation-review/history/root-foundation/development/becoming-general-laws-plan/readability/migrations/attraction-is-not-returning.md. Shared boundary keys and their exact sentences: theories/becoming/results/data/standard-boundaries.json (cite a key only where its sentence is true of the record: no-ethical-premise only where the hypotheses hold no ethical premise and the bound receipts report empty axioms for the cited declarations). The snapshots are taken already: ${KIT}/df3/snapshots.json gives each record's text_versions entry (the exact bytes before migration, under _process/architecture/history/). ${KIT}/df3/triage-rows.json gives, for each record, the rows of ${KIT}/triage.json whose evidence and fix bear on it: DF1's editors found law content there that schema 1 could not hold, and put it into the statement and claim instead (${KIT}/reports/edit-records-0.json and edit-records-2.json, "not_applied", say so; some declarations, e.g. Stock.process, MatchesParts, Web.StandingCensus, Becoming.ActivationCapacity.joint_iff, were not added to references for that reason).

Each migration, per record:
1. Read the record, its snapshot, its triage rows, the home section of its chapter (the paragraph or row with <a id="r-<id>"></a>; theories/becoming/results/data/regions.json gives its region), and every Lean declaration it cites, in the current worktree (statements, hypotheses, docstrings).
2. Set "schema_version": 2. Keep id, kind, status, family, canonical_source, aliases, dependencies, related, references' paths and sha256, proof_bindings, counterexamples and the earlier history entries unchanged unless a reason below requires it.
3. title: a short name, at most 100 English / 40 Chinese characters (keep it if it already is one). statement: what the result does, in one or two positive sentences, at most 300 / 150, no Lean names, sections, dates or receipts; keep the existing statement where it is exact; where there is none, write it from the record and its home section, saying what the home section says (if they disagree, the Lean decides: propose the chapter edit, do not make it).
4. laws: one law per item {en, zh, declarations}, at most 420 / 190 characters each and 40 items, each saying exactly what its declarations prove: every hypothesis the theorem takes named, iff only where the Lean proves both directions, a witness read as a witness ("can", "need not", "in X"), finite bounds not limits. Every declaration a law names must be listed in a references entry's declarations: add it to the entry of the file that defines it (grep the Lean to confirm it exists there, with its namespace); where the file has no references entry, add one with role proof and the file's sha256 and a proof binding: cd ${W} && python3 -B ${KIT}/binding_for.py <lean path> --decls prints both for the newest passing receipt binding the file's current bytes; if none binds it, say so and do not cite that file. Usually the claim splits into the laws; drop "claim" when the statement and laws carry all of it, keep it only for an exact statement with its conditions written in that the laws do not give.
5. limitations is replaced: each substantive non-implication becomes a does_not_show item {en, zh, kind} with kind non-implication, converse, correspondence or scope, one sentence each, at most 240 / 110 and 8 items, an optional "witness" naming a declaration in references or an alias; a sentence that a standard boundary key says exactly becomes that key in standard_boundaries; a premise goes to hypotheses (at most 9 items, 420 / 190 each); bookkeeping (rounds, receipts, sessions) goes to history or stays in the snapshot. A record needs counterexamples or does_not_show.
6. validation_scope: the kind of evidence and where its receipts are, at most 600 / 260 (an error above): name the modules and the receipt directories, not every timestamp; the receipts stay in references. next_delta: the next substantive step, stated positively, at most 400 / 180. correspondence: keep it, cut only process markers; Ren's quoted words stay verbatim with their source; readings keep their AI label.
7. Never in title, statement, claim, laws, does_not_show, counterexamples or next_delta: round or item numbers (P92, DF1), section numbers (§29), dates, receipt timestamps, session ids, round narration ("this round", "has landed"), the status in other words ("remains open"), another record's status, instructions to later sessions.
8. text_versions: first the record's entry from snapshots.json; then, if a history note names a compaction snapshot under _process/architecture/history/ (the R35 notes of 20 October 2026), that file as a second entry {path, sha256 (shasum -a 256), note {en: "Exact record bytes before its history was compacted (R35); every condensed note is kept here.", zh: "历史说明压缩前的记录原始字节（R35）；每条被合并的说明都保存在这里。"}}, if the file exists.
9. Map every old sentence: write ${KIT}/df3-mapping/<id>.md in the model table's form: "# Migration map: <id>", the old sha256 and snapshot path, the label legend (T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples; Chinese goes where its English goes), a sentence saying which Lean files the laws were read against and which conditions were kept, then | Old text | Type | New place | with every English sentence or clause of the old record in a row. Nothing is dropped silently: a sentence that goes nowhere public says where it is (history, snapshot) and why.
10. Add one history entry and set reviewed_at_utc to the current UTC time ("2026-10-28T..:..:..+00:00"). History en: "28 October 2026: migrated to schema 2 (DF3, study section DF_N): <what changed: statement kept or written, the claim split into N laws each read against its declarations, limitations to does-not-show items, standard boundaries and hypotheses, declarations added to references, any narrowing>; no premise, status or source hash changed<, or say exactly what changed and why>. Every earlier sentence is mapped in [<id>.md](../../../../${KIT}/df3-mapping/<id>.md); the exact earlier record is the first text_versions entry." History zh: "2026年10月28日：迁移到 schema 2（DF3，研究第 DF_N 节）：……" saying the same. DF_N is filled at landing.
11. Check: cd ${W} && python3 -B tools/research/research.py check (JSON on stdout; read "errors" and "source_drift" for your ids) and python3 -B tools/research/research.py lint --ids <your ids> (every error must go; warnings should be few and each one judged). A record must stay as valid JSON with the key order of the model (schema_version, id, title, statement, kind, status, ...); write with json.dump(..., ensure_ascii=False, indent=1) and a final newline, as the records are.

Terms: the account's current terms in the glossary's one sense (GLOSSARY.md); no retired labels (G0, the one axiom, Part I/II, the registration vocabulary, J1-J4); "first law" means only the spine's Flow.Gainless (第一律), thermodynamics' first law named in full; names structural, not social or financial words (a record whose subject is an exchange, such as the market records, keeps its words). The Chinese says what the English says. Ren's words are provenance, never the warrant for a claim; no person or AI is named in live fields except authors of cited literature.`

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
      mapping_file: { type: 'string' }, check_clean: { type: 'boolean' }, lint_warnings: { type: 'string' }, notes: { type: 'string' },
    }, required: ['id', 'laws', 'does_not_show', 'statement', 'claim_kept', 'declarations_added', 'references_added', 'narrowed', 'chapter_edits', 'mapping_file', 'check_clean', 'lint_warnings', 'notes'] } },
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
      new: { type: 'string' },
      severity: { type: 'string', enum: ['error', 'overclaim', 'imprecise', 'dropped', 'missing', 'style'] },
      why: { type: 'string' }, evidence: { type: 'string', description: 'file:line of the Lean, the snapshot or the source' },
    }, required: ['id', 'field', 'old', 'new', 'severity', 'why', 'evidence'] } },
    verdicts: { type: 'array', items: { type: 'object', properties: { id: { type: 'string' }, verdict: { type: 'string', enum: ['sound', 'sound-after-edits', 'redo'] }, note: { type: 'string' } }, required: ['id', 'verdict', 'note'] } },
    checked: { type: 'string' },
  },
  required: ['edits', 'verdicts', 'checked'],
}

const results = await pipeline(
  UNITS,
  u => agent(`${CONTEXT}

Your unit is ${u.key}, region ${u.region}; your records: ${u.ids.join(', ')}.

Migrate each record as above, in place, and write its mapping file. Return, per record, what you did, any sentence you narrowed, and any chapter edit the home section needs (exact old and new text), without making it. Say what you did not migrate and why.`, { label: `migrate:${u.key}`, phase: 'Migrate', schema: MIGRATED }),
  (migrated, u) => agent(`${CONTEXT}

You are the skeptical reviewer of unit ${u.key} (records ${u.ids.join(', ')}). Its migrator rewrote these records in place and wrote their mapping files (do not edit any file; return edits):
${JSON.stringify(migrated, null, 1)}

For every record, read the snapshot (the old bytes), the migrated record and its mapping file in full, and try to refute each part: (1) every old sentence is mapped and nothing substantive is lost (a limitation, hypothesis or condition dropped is an error); (2) every law says exactly what its declarations prove: open the Lean of each declaration and compare hypotheses, quantifiers, iff or only if, witness or law, bounds or limits; a law that states more than its declarations is an overclaim; a declaration named that does not exist in the referenced file, or is not in references, is an error; (3) each does_not_show kind is right and each standard_boundaries key's sentence is true of the record (no-ethical-premise needs empty axiom reports for every cited declaration: read the receipts the proof_bindings name); (4) the statement agrees with the home section and the laws, within the caps; (5) no process markers in public fields, English and Chinese say the same, the history note and text_versions are as required; (6) run cd ${W} && python3 -B tools/research/research.py check and lint --ids for these ids and report any error. Check the proposed chapter edits the same way. Return each finding as an exact edit (record id or file, field path, exact old substring, new text) with the file:line that shows it, and a verdict per record. Default to reporting when unsure.`, { label: `review:${u.key}`, phase: 'Review', schema: REVIEW }).then(review => ({ unit: u.key, migrated, review })),
)
return results