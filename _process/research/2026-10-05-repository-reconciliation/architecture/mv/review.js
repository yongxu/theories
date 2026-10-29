export const meta = {
  name: 'mv-review',
  description: 'MV review: two independent readers check the computed master-law view (generator, registry note, check report) against the measure and the pages',
  phases: [{ title: 'Review', detail: 'code against the measure; pages against the Lean' }],
}
const W = '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/wt-mv'
const MEASURE = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/measure_grammar.py'
const OUT = {
  type: 'object',
  properties: {
    findings: { type: 'array', items: { type: 'object', properties: {
      file: { type: 'string' }, where: { type: 'string' },
      severity: { type: 'string', enum: ['error', 'misleading', 'imprecise', 'style'] },
      problem: { type: 'string' }, fix: { type: 'string', description: 'the exact change: old text and new text, or the code change' },
      evidence: { type: 'string' },
    }, required: ['file', 'where', 'severity', 'problem', 'fix', 'evidence'] } },
    checked: { type: 'string' },
  },
  required: ['findings', 'checked'],
}
const BASE = `You review board item MV in the theory repository at ${W} (branch mv, commit e1bcc4157). Read only; edit no file. Use absolute paths, or cd into ${W} within each command.

MV shows under each law of a record page which of five master laws (closure, balance, finite runs, lumping, order) the law's declarations rest on, by Lean dependency, whether they reach the grammar, and for central declarations of theories/becoming/results/completion/COVERAGE.json the measure's category and reason. The code: tools/research/master_laws.py (the generator: it reads the measure ${MEASURE}, which loads ../ec-elegant-completion/measure.py, and the checker cache's constants, and writes theories/becoming/results/data/master-laws.json); in tools/research/registry.py the functions master_laws, master_law_note and master_laws_status, the lines in load_records and render_record_v2 that use them, and the change to affected_ids; in tools/research/research.py the 'master_laws' entry of the check's result; the tests tools/research/tests/test_master_laws.py; the paragraph "Master laws under each law (MV)" in _process/RESULT-WORKFLOW.md. git -C ${W} show e1bcc4157 --stat lists the change; the record pages (theories/becoming/results/records/*.md) are rendered from it. Report as findings: errors (wrong results or code that breaks), misleading text (a note on a page, the docstring or the paragraph that says more or other than what the computation measures), imprecisions and style points worth taking; give each an exact fix. Do not report preferences that state no wrong meaning.`
const results = await parallel([
  () => agent(`${BASE}

Your lens: the code against the measure. Check that the generator's dependency closure, its five anchors, its grammar test and its four-way dependence are the measure's (it reuses the measure's module and asserts agreement on the 127 central rows: is the assertion sound, and does anything differ for non-central declarations?); that taking the union over a law's declarations, definitions included, is what the note claims; how declarations outside the core run are handled; whether the data file records enough to tell staleness (core receipt, measure hashes) and whether master_laws_status's report is right; whether affected_ids selects the right pages when the data file changes; whether render ever shows a note for a law whose declarations differ from the data's; whether any record field is written (none should be); edge cases (records without laws, schema-1 records, empty declarations, a law index beyond the data). You may run python3 -B -m unittest tools.research.tests.test_master_laws and python3 -B tools/research/research.py check (slow) in ${W}; do not run the generator (it needs the checker cache).`, { label: 'review:code', phase: 'Review', schema: OUT }),
  () => agent(`${BASE}

Your lens: the pages against the Lean. Pick at least twenty laws across different records (some from each note type: reaching the grammar; balance represented; anchor, not reached; none among its reasons; outside the core run; with a central declaration), read the rendered note under each, the record's law text and the Lean of its declarations (experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/*.lean and the grammar modules Becoming/Grammar*.lean), and judge whether a reader would be misled. For example: does "none among its reasons" read as a claim about the mathematics rather than about Lean dependency? Is "not reaching the grammar (balance is represented in it both ways)" accurate for balance? Is a definition-only law's note sensible? Do the central categories and reasons read correctly where they are shown? Is the RESULT-WORKFLOW paragraph accurate? Give the exact wording changes.`, { label: 'review:pages', phase: 'Review', schema: OUT }),
])
return results