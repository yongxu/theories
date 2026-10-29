export const meta = {
  name: 'df3b-cold-read',
  description: 'DF3 batch B cold read: three readers check the 87 migrated records and the chapter edits as applied; a fourth reads the generativity chain entries that link them',
  phases: [{ title: 'Read', detail: 'three independent readers, about 29 records each, and one chain reader' }],
}
const W = '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/wt-df3b'
const KIT = '_process/research/2026-10-05-repository-reconciliation/architecture/df'
const HALVES = args.readers
const CHAIN = args.chain

const FINDINGS = {
  type: 'object',
  properties: {
    findings: { type: 'array', items: { type: 'object', properties: {
      id: { type: 'string', description: 'record id, a mapping file path, or a chapter path' },
      field: { type: 'string', description: 'e.g. statement.en, laws[3].zh, does_not_show[1].en, or the chapter row' },
      old: { type: 'string', description: 'exact substring now in the field or file' },
      new: { type: 'string', description: 'the replacement (for a list field, the whole new list as JSON)' },
      severity: { type: 'string', enum: ['error', 'overclaim', 'imprecise', 'dropped', 'home-disagrees', 'style'] },
      why: { type: 'string' }, evidence: { type: 'string', description: 'file:line of the Lean, the snapshot or the chapter' },
    }, required: ['id', 'field', 'old', 'new', 'severity', 'why', 'evidence'] } },
    sound: { type: 'array', items: { type: 'string' }, description: 'record ids read in full with nothing to report' },
    checked: { type: 'string' },
  },
  required: ['findings', 'sound', 'checked'],
}
const CHAINOUT = {
  type: 'object',
  properties: {
    sources: { type: 'array', items: { type: 'object', properties: {
      path: { type: 'string' },
      verdict: { type: 'string', enum: ['record', 'hold'] },
      entries: { type: 'array', items: { type: 'string' } },
      reading: { type: 'string', description: 'which sentences of the entries bear on the record, and why they hold or not' },
      proposal: { type: 'string', description: 'for hold: the entry, its exact current words, and the words proposed' },
    }, required: ['path', 'verdict', 'entries', 'reading', 'proposal'] } },
    checked: { type: 'string' },
  },
  required: ['sources', 'checked'],
}

const readerPrompt = h => `You are a cold reader of board item DF3, batch B, in the theory repository at ${W} (branch df3b). Read only; edit no file; return findings as exact edits. Use absolute paths, or cd into ${W} within each command.

DF3 batch B migrated 87 schema-1 result records to schema 2, with laws arrays; a skeptical reviewer per unit has already checked them and the reviews are applied; you read the result as applied, fresh. The plan is ${KIT}/DF3-PLAN.md; the rules for a schema-2 record are in _process/RESULT-WORKFLOW.md, "Writing a record (schema 2)". For each record: theories/becoming/results/records/<id>.json (the migrated record); its old bytes, the snapshot named in its first text_versions entry under _process/architecture/history/; its mapping table ${KIT}/df3-mapping/<id>.md; its home section in the chapter, the paragraph or table row after <a id="r-<id>"></a> in theories/becoming/chapters/; and the Lean of every declaration its laws cite. The chapter edits batch B made are in: cd ${W} && git diff 5acc60130 -- theories/becoming/chapters.

Your records: ${h.ids.join(', ')}.

Try to refute each record and each chapter edit in your records' home sections. Report: a law that says more than its declarations prove (a hypothesis the theorem takes left unnamed in that law item, an iff where the Lean proves one direction, a witness read as a law, a bound read as a limit, a negated universal read as an existential), or less than its home section says it proves; a declaration named that does not exist in the referenced file or is not listed in references; a condition, limitation or counterexample of the old record lost or weakened without a true reason in the mapping; a counterexample no declaration witnesses; a statement that disagrees with its laws or its home section (say which is right by the Lean, and give the edit to the wrong one); a does_not_show kind that is wrong, or a standard_boundaries key whose sentence is false of the record (no-ethical-premise needs empty axiom reports for every cited declaration in the receipts the proof_bindings name); the evidence paragraph misreporting a receipt's checker, Lean version or axioms; English and Chinese that say different things; process markers (round numbers, sections, dates, receipt timestamps, "this round", 本轮) in title, statement, claim, laws, does_not_show, counterexamples or next_delta; retired labels (G0, the one axiom, Part I/II, J, J1-J4, the registration vocabulary) or words of exchange in live fields; a reading without its AI label; Ren's words used as warrant; a mapping table that does not describe the record as it now is. Do not report preferences of wording that state no wrong meaning. Run cd ${W} && python3 -B tools/research/research.py lint --ids <your ids, comma-separated> and report any finding. List the records you read in full and found sound.`

const chainPrompt = `You read the generativity chain for board item DF3, batch B, in the theory repository at ${W} (branch df3b). Read only; edit no file. Use absolute paths, or cd into ${W} within each command.

The chain is a curated argument (theories/becoming/results/data/generativity-chain.json, rendered as theories/becoming/results/GENERATIVITY-CHAIN.md): its entries state claims and scopes and link evidence sources, each fingerprinted by sha256 in "reviewed_sources". DF3 batch B migrated 87 records to schema 2; ${CHAIN.sources.length} of the chain's sources are those records' JSON or pages (listed below with the entries that link each; a source no entry links is recorded once read). The pages are regenerated from the JSON, so read a page through its record. For each source: read the migrated record (and its snapshot, the first text_versions entry, for what changed), then every sentence of each linking entry's claim_en, claim_zh, scope_en and scope_zh that bears on that record, and say whether it still holds as the migrated record states the result. Verdict "record" where every bearing sentence holds (or no entry links it); "hold" where an entry's text would need to change to agree with the record (an overclaim the migration corrected, a condition the entry omits that the Lean takes, a retired label): then give the entry, its exact current words and the words proposed. The entry text is not edited here; a hold becomes a proposal. Already held, whatever you find, by the chain review GC's proposals (section gc-chain-review-28-october-2026 of _process/research/2026-10-05-generative-foundation-review/root-foundation/GENERATIVITY-CHAIN-INDEX-RECORD.md, which read them first): open-form-realization-under-revision.json (A1, the G0 wording), enacted-scene-binding.md and historical-source-binding.md (A2); say whether the migration changes what those proposals say, and give no second proposal for the same point. Batch A's section in the same file (df3-chain-review-28-october-2026) is the model of the reading.

Sources and their linking entries:
${JSON.stringify(CHAIN.links, null, 1)}
All sources (those absent above are linked by no entry):
${CHAIN.sources.join('\n')}`

const jobs = HALVES.map(h => () => agent(readerPrompt(h), { label: `cold:${h.key}`, phase: 'Read', schema: FINDINGS }).then(r => ({ reader: h.key, ...r })))
jobs.push(() => agent(chainPrompt, { label: 'chain', phase: 'Read', schema: CHAINOUT }).then(r => ({ reader: 'chain', ...r })))
return await parallel(jobs)
