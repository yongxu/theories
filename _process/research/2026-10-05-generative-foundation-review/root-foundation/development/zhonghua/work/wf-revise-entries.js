export const meta = {
  name: 'zh-revise-entries',
  description: 'Revise each cluster\'s correspondences under the decided name table and the verifiers\' fixes, then check the revisions (two clusters at a time)',
  phases: [{ title: 'Revise', detail: 'one reviser per cluster: apply verifier fixes, the name table, current Lean names, add missing items' }, { title: 'Check', detail: 'one structure checker per cluster on revised and new entries' }],
}

const Z = '/private/tmp/claude-501/-Users-ren-theories/ab4fc732-b2ac-420a-aa49-cf63c999271c/scratchpad/zh'
const K = '/Users/ren/theories/.claude/worktrees/zhonghua/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua'
const BRIEF = `${K}/BRIEF-ZH.md`
const CTQ = `python3 -I ${Z}/ctq.py`
const RES = `python3 -I ${K}/work/resolve.py`
const NAMES = `${K}/work/names-decisions.tsv`
const NOT = `${K}/work/symbols-not-adopted.tsv`

const ENTRY = {
  type: 'object',
  properties: {
    id: { type: 'string' }, status: { type: 'string', enum: ['revised', 'new'] },
    record_ids: { type: 'array', items: { type: 'string' } },
    tradition: { type: 'string' }, work: { type: 'string' }, source_id: { type: 'string' }, locator: { type: 'string' },
    layer: { type: 'string', description: 'period first (先秦, 秦汉, 魏晋南北朝, 隋唐, 宋明, 清), then 经／传／注／疏／论, with any dating dispute' },
    fragments: { type: 'array', items: { type: 'string' } },
    kind: { type: 'string', enum: ['agreement', 'scope', 'divergence'] },
    declarations: { type: 'array', items: { type: 'string' } },
    records: { type: 'array', items: { type: 'string' } },
    relational: { type: 'string' },
    reading: { type: 'string', description: 'AI读法：…, in Chinese, using only names from the name table (simplified forms), quotations exactly as in the frozen text' },
    names_used: { type: 'array', items: { type: 'string' } },
    ro_passage: { type: 'string' }, gap: { type: 'string' },
    layer_checked: { type: 'string', description: 'for divergences: which of the four non-relational layers (本原, 固定本性或价值, 意志或单一中心, 争胜与等级) or other structure; else empty' },
  },
  required: ['id', 'status', 'record_ids', 'source_id', 'layer', 'fragments', 'kind', 'declarations', 'records', 'reading', 'names_used'],
}

const REVISE_SCHEMA = {
  type: 'object',
  properties: {
    cluster: { type: 'string' },
    revised: { type: 'array', items: ENTRY, description: 'every entry that needed a change, in full, and every new entry' },
    kept: { type: 'array', items: { type: 'object', properties: { id: { type: 'string' }, names_used: { type: 'array', items: { type: 'string' } } }, required: ['id', 'names_used'] }, description: 'entries kept as they were, with names_used restated in the name table\'s names' },
    dropped: { type: 'array', items: { type: 'object', properties: { id: { type: 'string' }, why: { type: 'string' }, now: { type: 'string', description: 'parallel of ENTRY_ID, rejected, or moved to cluster Cxx' } }, required: ['id', 'why', 'now'] } },
    candidate_changes: { type: 'array', items: { type: 'object', properties: { record_id: { type: 'string' }, now: { type: 'string', enum: ['entry', 'parallel', 'rejected'] }, same_as_entry: { type: 'string' }, why: { type: 'string' } }, required: ['record_id', 'now', 'why'] }, description: 'only parallels or rejections whose status changes' },
    name_flags: { type: 'array', items: { type: 'object', properties: { name: { type: 'string' }, issue: { type: 'string' }, proposal: { type: 'string' } }, required: ['name', 'issue', 'proposal'] }, description: 'where the name table is wrong or lacks a name this cluster needs; the integrator decides' },
    notes: { type: 'string', description: 'what changed and why, divergence coverage of the four layers, what is still open' },
  },
  required: ['cluster', 'revised', 'kept', 'dropped', 'candidate_changes', 'name_flags', 'notes'],
}

const CHECK_SCHEMA = {
  type: 'object',
  properties: {
    cluster: { type: 'string' },
    corrections: { type: 'array', items: ENTRY, description: 'entries that were still wrong, corrected in full (keep their id and status)' },
    drops: { type: 'array', items: { type: 'object', properties: { id: { type: 'string' }, why: { type: 'string' } }, required: ['id', 'why'] } },
    passed: { type: 'array', items: { type: 'string' }, description: 'ids checked and found right' },
    notes: { type: 'string' },
  },
  required: ['cluster', 'corrections', 'drops', 'passed', 'notes'],
}

const SPARSE = { C16: 1, C02: 1, C04: 1, C11: 1 }

const revise = c => agent(
`Read ${BRIEF} first (it was updated for current main: the continuation condition is §6.4; C alone orders; 识 per D45). Then the name table ${NAMES} (one classical name per concept; names are written in traditional form there, write their simplified form in your Chinese prose) and the decisions on symbols not adopted ${NOT}.

You revise cluster ${c.key} 「${c.title}」 (its theory concepts: the entry with key "${c.key}" in ${K}/clusters.json). Read:
- the mapper's output ${K}/agents/map-${c.key}.json (its names are superseded by the name table; its entries, parallels and rejections are your material);
- the two verifiers' verdicts ${K}/agents/verify-philology-${c.key}.json and ${K}/agents/verify-structure-${c.key}.json (an issue and an exact fix for every name and entry, and a "missing" list);
- the critic's issues that concern this cluster ${K}/work/critic/${c.key}.json.

Do this:
1. Every entry with a "revise" verdict from either verifier: apply the fixes (both lenses). Where a fix is itself wrong, say so in notes and do what is right. Entries with "reject": drop them, saying where the record now goes. Entries kept by both: list them in "kept" with names_used restated in the name table's names.
2. Lean names: main has renamed many declarations and record ids since the mapper wrote. Resolve every declaration and record id with ${RES} NAME [NAME ...] (prints the current name, or NONE). For NONE, find the current statement by grep in /Users/ren/theories/.claude/worktrees/zhonghua/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/*.lean, or drop the declaration. A declaration must state the structure the reading claims; when it is definitional (Iff.rfl) or a witness in one constructed model, say so and do not present it as a general law.
3. Names: names_used and the reading use only the name table's names (simplified form) or plain modern Chinese. Do not use a name for a concept other than the one the table gives it; do not bring in a symbol the table does not adopt as a name (道, 气, 天, 性, 仁 ...): such a symbol may appear only in quoted text, and its entry says what is or is not carried. If the table lacks a name you need, or a table name is wrong for its structure, put it in name_flags; the integrator decides.
4. Missing: from the verifiers' "missing" lists and the critic's coverage items for this cluster, add new entries (status "new") for those that hold structurally; ignore the rest with a reason in notes. Prefer 先秦 passages; date every entry by period first.${SPARSE[c.key] ? ` This cluster has very few divergences: check each of the four non-relational layers (本原, 固定本性或价值, 意志或单一中心, 争胜与等级) in its traditions at least once and record genuine counterexamples as divergence entries; never force a divergence or an agreement.` : ''}
5. Every fragment is copied exactly from the frozen text and checked with ${CTQ} text SOURCE_ID '...' (same characters and punctuation; whitespace may differ). Readings keep quotations in the frozen text's characters; your own prose in simplified Chinese. Every reading starts with 「AI读法：」 and claims exactly what the Lean proves.
6. Keep every primary candidate in exactly one place (entry, parallel or rejected); report only those whose place changes in candidate_changes.

Read-only: do not edit any file, do not build Lean, do not commit.`,
  { label: `revise-${c.key}`, phase: 'Revise', schema: REVISE_SCHEMA })

const check = (r, c) => {
  if (!r) return null
  const changed = { cluster: r.cluster, revised: r.revised, dropped: r.dropped, name_flags: r.name_flags }
  return agent(
`Read ${BRIEF} first, then the name table ${NAMES} and ${NOT}. You check the revisions of cluster ${c.key} 「${c.title}」. Be adversarial: find what is still wrong. The reviser's changed and new entries (JSON):
${JSON.stringify(changed)}

For EVERY entry in "revised": (1) run ${CTQ} text on each fragment (exactness, right source); (2) confirm every declaration exists under that full name by grep in /Users/ren/theories/.claude/worktrees/zhonghua/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/*.lean and states the structure the reading claims (a definitional Iff.rfl or a witness in one model is not a general law); record ids: ${RES} ID; (3) the kind: no divergence forced into an agreement, no agreement claimed on a shared word; (4) names: only the name table's names, each for its own concept; (5) the layer and period; (6) the reading claims exactly what the Lean proves, keeps the continuation condition stated and not asserted, and puts ordering in C alone. Return an entry in "corrections" (in full, same id and status) only when you changed it; ids found right go in "passed"; entries that cannot be repaired go in "drops". Read-only: do not edit any file.`,
    { label: `check-${c.key}`, phase: 'Check', schema: CHECK_SCHEMA })
}

const inBatches = async (items, size, fn) => {
  const out = []
  for (let i = 0; i < items.length; i += size) {
    const part = await parallel(items.slice(i, i + size).map(x => () => fn(x)))
    out.push(...part)
    log(`clusters done: ${Math.min(i + size, items.length)}/${items.length}`)
  }
  return out
}

const results = await inBatches(args.clusters, 2, async c => {
  const r = await revise(c)
  const k = await check(r, c)
  return { key: c.key, revised: r ? r.revised.length : null, kept: r ? r.kept.length : null, dropped: r ? r.dropped.length : null, flags: r ? r.name_flags.length : null, corrections: k ? k.corrections.length : null, drops: k ? k.drops.length : null, passed: k ? k.passed.length : null }
})
return { results }
