export const meta = {
  name: 'df2-records',
  description: 'DF2: draft the 30 missing records in four units, each reviewed by a skeptic against the Lean and its receipt',
  phases: [{ title: 'Draft', detail: 'one drafter per unit writes new record files' }, { title: 'Review', detail: 'one skeptic per unit returns exact edits' }],
}
const W2 = '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/wt-df2'
const KIT = '_process/research/2026-10-05-repository-reconciliation/architecture/df'
const UNITS = [
  { key: 'A', chapter: '03-KNOWING.md', rows: '94, 131, 132, 133, 134, 135, 136 with 96, 137, 138, 139, 140 with 284',
    ids: 'when-to-inquire-and-when-to-respond, certificates-sound-and-available, adaptive-closure-cannot-resolve, evidence-through-change, correction-is-not-calibration, learning-a-rule-by-narrowing, readings-a-response-needs (rows 136 and 96: row 96 is its law 1), composition-route, what-a-total-keeps, access-yet-to-form, one-move-covering (rows 140 and 284 are the same law, MoveOutcomeProcesses: covering exactly where every one-move goal is carried; one record, at home where the theorem is stated in full, 03 or 08, the other place linking to it; row 140 named it covering-of-moves, use one-move-covering)' },
  { key: 'B', chapter: '04-LIFE.md', rows: '144, 145, 146, 148, 149, 150, 151 (row 113 is covered by 148-151)',
    ids: 'stronger-arrangement-formed-by-reconfiguration, a-selected-template-need-not-raise-structure, groups-formed-by-bonds-share-a-founder, recurrence-without-selector-revision, equal-totals-can-hide-what-a-capacity-carries, the-updater-line, same-carrier-need-not-fix-the-response' },
  { key: 'C', chapter: '05-COLLECTIVES.md, 07-SIGNIFICANCE.md and 02-MAP.md', rows: '194, 195, 196, 197, 198, 267, 36',
    ids: 'market-model-share-margin-and-ends, joint-plans-from-a-supported-start (its periphery checker has just been run: SeededContinuation.lean is now bound by systems-complexity/analysis/seeded-continuation-verification.json), a-swap-symmetric-assignment-singles-out-none, reviewers-count-by-independent-causes, succession-on-a-funded-carrier, finite-agreement-does-not-identify-priority, significance-through-a-common-condition (row 36 also proposes a new statement for the existing record becoming-renewal-reading and dropping five aliases there, and a link in 02-MAP line 105: return those as edits, do not make them)' },
  { key: 'D', chapter: '01-ROOT.md and 08-METHOD.md', rows: '55, 283, 285, 286, 287',
    ids: 'reach-from-a-seed, what-a-summary-keeps, type-formation-gives-no-dynamics, contraction-where-duplication-is-reachable, self-reference-does-not-certify-itself' },
]

const CONTEXT = `You are working on board item DF2 in the theory repository: making the result records that DF1's triage found missing. Your git worktree is ${W2} (branch df2, cut from main 04c7f93ae). Use absolute paths, or cd into ${W2} within each command. Other agents work in the same worktree at the same time on other records: create only your own new record files, edit no existing file, and ignore errors that belong to other ids.

Read first: ${KIT}/DF2-PLAN.md (the units); ${KIT}/triage.json, a JSON list whose rows by index give for each missing result the evidence (what the chapter states and which Lean declarations prove it, checked at commit 0e368fbf2) and a proposed fix (id, title in both languages, home section and anchor, statement, laws with their declarations, hypotheses, regions entry). The proposals are a starting point, not a verdict: main has moved since, so recheck every name and every sentence against the Lean as it now is in the worktree. _process/RESULT-WORKFLOW.md says how records are made. Model records to copy the form from: theories/becoming/results/records/comparing-two-courses-on-what-they-admit.json (a core result) and organizational-formation-from-generative-comparison.json (a periphery result), and the records already at home in the same chapter section (take the family F-number and conventions of the nearest one). Valid standard_boundaries keys are in theories/becoming/results/data/standard-boundaries.json.

A record (schema 2) has: schema_version 2; id; title {en, zh}; kind (theorem, or argument / assessment where no Lean proves it); status recorded-checked (needs a proof reference and a receipt reference bound by proof_bindings) or reviewed-scoped (needs statement and review references) where no passing receipt binds the source's current bytes; family "Fnn"; reviewed_at_utc "2026-10-26T..:..:..+00:00"; statement {en, zh}, at most 300 English and 150 Chinese characters, leading with what holds; laws [{en, zh, declarations}], at most 420 / 190 characters each, every declaration also listed in a references entry's declarations; hypotheses [{en, zh}] naming the modelling choices and, for the periphery, the axioms (core: "No axiom", empty axiom reports); does_not_show [{en, zh, kind}] with kind non-implication, converse, correspondence or scope; counterexamples [] or entries {path, detail{en, zh}} on a hashed source; standard_boundaries; validation_scope {en, zh} naming the receipt and module; next_delta {en, zh} at most 400 / 180; correspondence {en, zh} (literature you can verify; readings labelled as the AI's); canonical_source, the proof source's path; aliases (the titles and central Lean names); dependencies [{id, relation formal-reuse|application|interpretive, detail{en, zh}}] and related [{id, detail{en, zh}}] to records that exist; references [{path, role, declarations?, sha256}] with roles proof, receipt, statement (the home chapter), integration; proof_bindings; history: one entry, en "26 October 2026: added (DF2), <what it states>; from DEFECTS-FOUND (triage row N); study section DF_N.", zh "2026年10月26日：新增（DF2），…；出自 DEFECTS-FOUND（分诊第 N 行）；研究第 DF_N 节。" (DF_N is filled at landing).

For bindings run: cd ${W2} && python3 -B ${KIT}/binding_for.py <lean source path> --decls. It prints the references entries (with sha256) and the proof_bindings entry for the newest passing receipt binding the file's current bytes, and the declarations that receipt lists. Hash the chapter yourself (shasum -a 256). Check your records with: cd ${W2} && python3 -B tools/research/research.py check (JSON; read the errors and drift naming your ids) and python3 -B tools/research/research.py lint --ids <your ids> (every error must go; warnings should be few). Search existing records first (cd ${W2} && make research-find QUERY=<words>, or grep theories/becoming/results/records) so you do not duplicate a record that already states the result: where one does, say so and do not write a second.

Rules: a claim says exactly what its Lean proves: a witness is read as a witness ("can", "need not", "in X"), an implication is not written as an equivalence, finite bounds are not limits, every hypothesis the theorem takes is named. Use the account's current terms in the glossary's one sense (GLOSSARY.md); no retired labels (G0, the one axiom, Part I/II, the registration vocabulary, J1-J4). "First law" means only the spine's Flow.Gainless (第一律); thermodynamics' first law is named in full. Names are structural, not social or financial words. The Chinese says what the English says. Ren's words are provenance, never the warrant for a claim; no person or AI is named in live fields except authors of cited literature.`

const DRAFT = {
  type: 'object',
  properties: {
    records: { type: 'array', items: { type: 'object', properties: {
      id: { type: 'string' }, rows: { type: 'string' }, file: { type: 'string' },
      status: { type: 'string' },
      home: { type: 'string', description: 'chapter path and section heading' },
      anchor_before: { type: 'string', description: 'an exact text of at least 40 characters, unique in the chapter, at the start of the paragraph (or the first cell of the table row) before which <a id="r-<id>"></a> goes' },
      regions: { type: 'object', properties: { region: { type: 'string' }, base: { type: 'string' }, note: { type: 'string' } }, required: ['region', 'base', 'note'] },
      chapter_edits: { type: 'array', items: { type: 'object', properties: { file: { type: 'string' }, old: { type: 'string' }, new: { type: 'string' }, why: { type: 'string' } }, required: ['file', 'old', 'new', 'why'] } },
      record_edits: { type: 'array', description: 'edits to existing records the triage proposes', items: { type: 'object', properties: { id: { type: 'string' }, field: { type: 'string' }, old: { type: 'string' }, new: { type: 'string' }, why: { type: 'string' } }, required: ['id', 'field', 'old', 'new', 'why'] } },
      check_clean: { type: 'boolean' }, notes: { type: 'string' },
    }, required: ['id', 'rows', 'file', 'status', 'home', 'anchor_before', 'regions', 'chapter_edits', 'record_edits', 'check_clean', 'notes'] } },
    not_written: { type: 'array', items: { type: 'object', properties: { id: { type: 'string' }, why: { type: 'string' } }, required: ['id', 'why'] } },
  },
  required: ['records', 'not_written'],
}

const REVIEW = {
  type: 'object',
  properties: {
    edits: { type: 'array', items: { type: 'object', properties: {
      id: { type: 'string', description: 'record id, or a chapter path for a proposed chapter edit' },
      field: { type: 'string', description: 'e.g. statement.en, laws[2].zh, hypotheses[0].en, references, anchor_before' },
      old: { type: 'string', description: 'exact substring now in the field (empty to set the whole field)' },
      new: { type: 'string' },
      severity: { type: 'string', enum: ['error', 'overclaim', 'imprecise', 'missing', 'duplicate', 'style'] },
      why: { type: 'string' }, evidence: { type: 'string', description: 'file:line of the Lean or source' },
    }, required: ['id', 'field', 'old', 'new', 'severity', 'why', 'evidence'] } },
    verdicts: { type: 'array', items: { type: 'object', properties: { id: { type: 'string' }, verdict: { type: 'string', enum: ['sound', 'sound-after-edits', 'rewrite', 'drop'] }, note: { type: 'string' } }, required: ['id', 'verdict', 'note'] } },
    checked: { type: 'string' },
  },
  required: ['edits', 'verdicts', 'checked'],
}

const results = await pipeline(
  UNITS,
  u => agent(`${CONTEXT}

Your unit is ${u.key}: chapter ${u.chapter}; triage rows ${u.rows}; records ${u.ids}.

For each record: read its triage row; read the home section of the chapter and the Lean it cites (statements, hypotheses, docstrings); find the binding; write theories/becoming/results/records/<id>.json; run check and lint until your ids have no errors. Return, for each, where its anchor goes (an exact unique text in the chapter), its regions entry, and any chapter or existing-record edits the triage proposes or you find needed (exact old and new text), without making them. Say what you did not write and why.`, { label: `draft:${u.key}`, phase: 'Draft', schema: DRAFT }),
  (draft, u) => agent(`${CONTEXT}

You are the skeptical reviewer of unit ${u.key} (chapter ${u.chapter}; triage rows ${u.rows}). Its drafter wrote these record files and proposals (do not edit any file; return edits):
${JSON.stringify(draft, null, 1)}

For every record file the drafter wrote, read it in full and try to refute each sentence: compare it with the exact Lean statement of every declaration it cites (hypotheses, quantifiers, iff or only if, witness or law, bounds or limits), the docstrings, and the home section of the chapter (the record must say what the chapter says, or the chapter is wrong: then propose the chapter edit). Check that every cited declaration exists in the source, that the proof binding passes (run research.py check and read errors for these ids), that the receipt's axioms match the hypotheses and validation_scope, that no existing record already states the same result (search), that dependencies and related point to the right records, that English and Chinese say the same, the caps (lint), the anchor text exists exactly once in the chapter, and the regions base is right (core, frame, general, grammar, old-base, periphery as regions.json uses them). Check the proposed chapter and record edits the same way. Return each finding as an exact edit (record id, field path, exact old substring, new text), with the Lean file:line that shows it, and a verdict per record. Default to reporting when unsure.`, { label: `review:${u.key}`, phase: 'Review', schema: REVIEW }).then(review => ({ unit: u.key, draft, review })),
)
return results
