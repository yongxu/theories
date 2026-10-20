export const meta = {
  name: 'zh-map-and-names',
  description: 'Read every judgment of 《中华思想脉络》 against the spine, then build the classical vocabulary and correspondences per concept cluster, with adversarial checks',
  phases: [
    { title: 'Triage', detail: 'every judgment classified by concept cluster' },
    { title: 'Map', detail: 'per cluster: classical names and correspondences' },
    { title: 'Verify', detail: 'per cluster: philology lens and structure lens' },
    { title: 'Critic', detail: 'completeness and coherence of the vocabulary' },
  ],
}

const Z = '/private/tmp/claude-501/-Users-ren-theories/ab4fc732-b2ac-420a-aa49-cf63c999271c/scratchpad/zh'
const BRIEF = `${Z}/BRIEF-ZH.md`
const CLUSTERS = `${Z}/clusters.json`
const CTQ = `python3 -I ${Z}/ctq.py`

const TRIAGE_SCHEMA = {
  type: 'object',
  properties: {
    chunk: { type: 'integer' },
    n_lines: { type: 'integer' },
    verdicts: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          id: { type: 'string' },
          c: { type: 'string', description: 'primary cluster key C01..C17, or "-" for no correspondence' },
          s: { type: 'array', items: { type: 'string' } },
          k: { type: 'string', enum: ['a', 's', 'd', '-'] },
          w: { type: 'string', description: 'structural reason, at most 40 characters; required when c is not "-"' },
        },
        required: ['id', 'c', 'k'],
      },
    },
    patterns: { type: 'string' },
  },
  required: ['chunk', 'n_lines', 'verdicts', 'patterns'],
}

const ATTEST = {
  type: 'object',
  properties: {
    record_id: { type: 'string' }, source_id: { type: 'string' }, locator: { type: 'string' },
    quote: { type: 'string' }, layer: { type: 'string', description: '经／传／注／疏／论 and period: 先秦, 秦汉, 魏晋南北朝, 隋唐, 宋明, 清' },
    sense_in_context: { type: 'string' },
  },
  required: ['source_id', 'quote', 'layer', 'sense_in_context'],
}

const MAP_SCHEMA = {
  type: 'object',
  properties: {
    cluster: { type: 'string' },
    names: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          concept: { type: 'string', description: 'the theory concept, as in the glossary (zh and en)' },
          lean: { type: 'array', items: { type: 'string' } },
          name: { type: 'string', description: 'the proposed classical name' },
          form: { type: 'string', enum: ['单字', '复词', '短语', '新组合'] },
          pre_qin: { type: 'boolean' },
          attestations: { type: 'array', items: ATTEST },
          fit: { type: 'string', description: 'why the attested sense keeps the concept\'s structure: relation, condition, direction' },
          not_carried: { type: 'string', description: 'what the name\'s other senses carry that the theory does not' },
          course: { type: 'string', description: 'how its use changed in later layers, with record ids where possible' },
          alternatives: { type: 'array', items: { type: 'object', properties: { name: { type: 'string' }, why_not: { type: 'string' } }, required: ['name', 'why_not'] } },
          coinage: { type: 'boolean' },
          confidence: { type: 'string', enum: ['high', 'medium', 'low'] },
        },
        required: ['concept', 'name', 'form', 'pre_qin', 'attestations', 'fit', 'not_carried', 'course', 'alternatives', 'coinage', 'confidence'],
      },
    },
    entries: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          id: { type: 'string', description: 'slug, e.g. zhuang-qiwu-bi-shi' },
          record_ids: { type: 'array', items: { type: 'string' } },
          tradition: { type: 'string' }, work: { type: 'string' },
          source_id: { type: 'string' }, locator: { type: 'string' },
          layer: { type: 'string' },
          fragments: { type: 'array', items: { type: 'string' } },
          kind: { type: 'string', enum: ['agreement', 'scope', 'divergence'] },
          declarations: { type: 'array', items: { type: 'string' } },
          records: { type: 'array', items: { type: 'string' } },
          relational: { type: 'string' },
          reading: { type: 'string', description: 'AI读法：…, in Chinese' },
          names_used: { type: 'array', items: { type: 'string' } },
          ro_passage: { type: 'string', description: 'id of the RO passage if already mapped there, else empty' },
          gap: { type: 'string', description: 'empty, or the exact formal statement the spine lacks, with nearest declarations' },
        },
        required: ['id', 'record_ids', 'source_id', 'fragments', 'kind', 'declarations', 'records', 'reading'],
      },
    },
    parallels: { type: 'array', items: { type: 'object', properties: { record_id: { type: 'string' }, same_as_entry: { type: 'string' }, note: { type: 'string' } }, required: ['record_id', 'same_as_entry'] } },
    rejected: { type: 'array', items: { type: 'object', properties: { record_id: { type: 'string' }, why: { type: 'string' } }, required: ['record_id', 'why'] } },
    notes: { type: 'string', description: 'the cluster\'s overall finding, divergences, gaps ranked, and a self counter-review' },
  },
  required: ['cluster', 'names', 'entries', 'parallels', 'rejected', 'notes'],
}

const VERDICT_SCHEMA = {
  type: 'object',
  properties: {
    cluster: { type: 'string' },
    lens: { type: 'string' },
    names: { type: 'array', items: { type: 'object', properties: { concept: { type: 'string' }, name: { type: 'string' }, verdict: { type: 'string', enum: ['keep', 'revise', 'reject'] }, issues: { type: 'string' }, fix: { type: 'string' } }, required: ['concept', 'name', 'verdict', 'issues'] } },
    entries: { type: 'array', items: { type: 'object', properties: { id: { type: 'string' }, verdict: { type: 'string', enum: ['keep', 'revise', 'reject'] }, issues: { type: 'string' }, fix: { type: 'string' } }, required: ['id', 'verdict', 'issues'] } },
    missing: { type: 'array', items: { type: 'string' }, description: 'names or passages this cluster should have and lacks' },
  },
  required: ['cluster', 'lens', 'names', 'entries', 'missing'],
}

const CRITIC_SCHEMA = {
  type: 'object',
  properties: {
    issues: { type: 'array', items: { type: 'object', properties: { type: { type: 'string', enum: ['unmapped-concept', 'unplaced-symbol', 'collision', 'inconsistency', 'coverage', 'other'] }, clusters: { type: 'array', items: { type: 'string' } }, detail: { type: 'string' }, action: { type: 'string' } }, required: ['type', 'detail', 'action'] } },
    system: { type: 'string', description: 'an assessment of the vocabulary as one system: is it one, relational and dynamic; where not' },
  },
  required: ['issues', 'system'],
}

// ---------- Triage ----------
phase('Triage')
const chunks = args.chunks
const triage = await parallel(chunks.map(ch => () => agent(
  `Read ${BRIEF} first, then ${CLUSTERS} (the 17 concept clusters C01–C17 of the theory, with the concepts each covers).

Your task: read EVERY line of ${ch.file}. It holds ${ch.n} complete judgments (判断) of 《中华思想脉络》, one per line: id | realm | partition/layer | title | [verb]from→to (type, premise_mode, level) | claim | first quotation (source, locator) | "RO已映射:…" when the earlier RO map already cites it.

For every line return a verdict:
- c: the primary cluster whose concept the judgment's STRUCTURE corresponds to (the same relation, condition and direction as something the theory states, or a structure the theory explicitly does not assert), or "-" if none.
- s: other clusters it also bears on (may be empty).
- k: "a" agreement, "s" holds only within a scope the theory makes exact, "d" divergence (a prior ground, a fixed nature or value, a will or single center, contest or rank, or another structure the theory denies), "-" when c is "-".
- w: at most 40 Chinese characters naming the structure (required when c is not "-").
Flag by structure, never by a shared word. Typically "-": narrative and biography, a particular divination outcome with no general structure, institutional detail, a gloss of a character with no relation, commentary that only paraphrases. Divergences are worth flagging. When a line is unclear, fetch the full record: ${CTQ} get ID.

Return exactly ${ch.n} verdicts, one per line, in file order (chunk = ${ch.chunk}). In "patterns", in a few sentences: what structures recur in this chunk, and which strongest divergences you saw.`,
  { label: `triage:${ch.chunk}`, phase: 'Triage', schema: TRIAGE_SCHEMA, effort: 'medium' })))

const byCluster = {}
let seen = 0, flagged = 0, missingChunks = []
triage.forEach((t, i) => {
  if (!t) { missingChunks.push(chunks[i].chunk); return }
  seen += t.verdicts.length
  if (t.verdicts.length !== chunks[i].n) log(`chunk ${chunks[i].chunk}: ${t.verdicts.length} verdicts for ${chunks[i].n} lines`)
  for (const v of t.verdicts) {
    if (!v.c || v.c === '-') continue
    flagged++
    ;(byCluster[v.c] = byCluster[v.c] || { primary: [], secondary: [] }).primary.push({ id: v.id, k: v.k, w: v.w || '' })
    for (const s of (v.s || [])) {
      if (s === v.c || s === '-') continue
      ;(byCluster[s] = byCluster[s] || { primary: [], secondary: [] }).secondary.push({ id: v.id, k: v.k, w: v.w || '', primary: v.c })
    }
  }
})
log(`triage: ${seen} verdicts, ${flagged} flagged; chunks failed: ${missingChunks.join(',') || 'none'}`)

// ---------- Map + Verify, pipelined per cluster ----------
const fmt = xs => xs.map(x => `${x.id} [${x.k}] ${x.w}${x.primary ? ' (primary ' + x.primary + ')' : ''}`).join('\n')

const results = await pipeline(
  args.clusters,
  c => {
    const g = byCluster[c.key] || { primary: [], secondary: [] }
    return agent(
`Read ${BRIEF} first. You are the mapper of cluster ${c.key} 「${c.title}」.

Theory concepts of this cluster: ${c.theory}

Seed characters and phrases to examine (candidates, not conclusions): ${c.seeds}

Candidate judgments from the sweep, primary for you (${g.primary.length}):
${fmt(g.primary) || '(none)'}

Candidates primary elsewhere that also bear on you (context; another mapper decides them) (${g.secondary.length}):
${fmt(g.secondary.slice(0, 150)) || '(none)'}

A. NAMES (名). Split this cluster's theory into its distinct concepts (every item named above, plus any you find in the glossary that belongs here). For each concept find the most fitting classical Chinese name: a character or a compound whose attested sense in context has the concept's structure. Search the 脉络 (${CTQ} label X; find X --in nodes; find X --in units) and its frozen texts. Prefer 先秦 attestations, and give the name's later course (秦汉, 魏晋 玄学, the Buddhist translations, 宋明, 清) with record ids where the 脉络 has them. One name per concept and no name for two concepts within your cluster. Where no classical name is exact, say so and build a compound from attested parts (HANZI §4), coinage=true, saying how the parts combine; never force a single character. Keep the already adopted names (识 明 无明 理 机 护闭 约定俗成 中和) and Ren's earlier terms unless you show a reason. List rejected candidates with why. "not_carried" must name the non-relational senses the character also carries (天 as will, 性 as a fixed nature, 理 as a prior ground, 尊卑 as rank, a positive valence, an independent substance), so a reader of the 中华 edition knows what the name does not bring.

B. CORRESPONDENCES. For each primary candidate decide: a full entry (it corresponds structurally; write it), a parallel (same structure as one of your entries; attach it), or rejected (shared word only, or no structure). Every primary candidate must end in exactly one of the three. Add entries of your own beyond the candidates where the 脉络 holds a passage that carries this cluster's structure or one of your names, 先秦 first. Fragments are copied exactly from the frozen text and checked with ${CTQ} text SOURCE_ID '...'. Declarations are full Lean names you have confirmed by grep. If the RO map (passages.json) already has the passage, reuse its kind and declarations and set ro_passage; differ only with a reason.

C. GAPS. Where a passage states a structure the spine lacks, say so in the entry's gap field with the exact statement you would prove and the nearest declarations; claim absence only after searching the digests and grepping the Lean.

Notes: the cluster's overall finding (is it one, relational and dynamic here, and where not), the strongest divergences, gaps ranked, and a short counter-review of your own work (where you may be matching words rather than structure).`,
      { label: `map:${c.key}`, phase: 'Map', schema: MAP_SCHEMA })
  },
  (m, c) => {
    if (!m) return null
    const payload = JSON.stringify(m)
    const common = `Read ${BRIEF} first. You verify the output of the mapper of cluster ${c.key} 「${c.title}」 (theory concepts: ${c.theory}). Be adversarial: your job is to find what is wrong. If you are uncertain whether an item holds, mark it revise and say what would settle it. Return one verdict for EVERY name and EVERY entry (keep, revise or reject), with the issue and the exact fix. List in "missing" the names or passages the cluster should have and lacks.

The mapper's output (JSON):
${payload}`
    return parallel([
      () => agent(`${common}

LENS: PHILOLOGY. For each name: run ${CTQ} text on every attestation quote (exactness); check the source's layer and period (${CTQ} src; the 脉络 node's own definition and limits); check that the attestation really carries the claimed sense in context (no anachronism: no Song 理 read into a 先秦 理, no Buddhist sense read into a 先秦 character, no modern compound passed off as classical); check whether an earlier or better-attested name exists in the 脉络; check that not_carried names the other senses honestly. For each entry: every fragment verbatim and in the named source, the layer right (经, 传, 注, 疏 kept apart), the reading faithful to the text in context.`,
        { label: `verify-philology:${c.key}`, phase: 'Verify', schema: VERDICT_SCHEMA }),
      () => agent(`${common}

LENS: STRUCTURE. For each name: does the attested sense have exactly the structure of the theory concept (relation, condition, direction), or only a shared word? Does it bring in an independent entity, a dualism, a prior ground, a single center, rank, or a valuation the theory does not assert (a name for significance that implies positive valence; a name for 生生 that implies any new organization is good; a name for law that implies a lawgiver outside the unfolding)? Is the theory concept itself described correctly (check the canonical chapter and the glossary)? Is the name consistent with the adopted names and with one name per concept? For each entry: grep the Lean to confirm every declaration exists under that full name and states the structure claimed; check the kind (agreement, scope, divergence) and that no divergence is forced into an agreement; check the reading claims exactly what the Lean proves.`,
        { label: `verify-structure:${c.key}`, phase: 'Verify', schema: VERDICT_SCHEMA }),
    ]).then(vs => ({ key: c.key, map: m, verdicts: vs.filter(Boolean) }))
  },
)

// ---------- Critic ----------
phase('Critic')
const ok = results.filter(Boolean)
const table = ok.map(r => ({
  cluster: r.key,
  names: r.map.names.map(n => ({ concept: n.concept, name: n.name, pre_qin: n.pre_qin, coinage: n.coinage, confidence: n.confidence,
    verdicts: r.verdicts.map(v => (v.names.find(x => x.concept === n.concept || x.name === n.name) || {}).verdict).filter(Boolean) })),
  entries: r.map.entries.length, parallels: r.map.parallels.length, rejected: r.map.rejected.length,
  missing: r.verdicts.flatMap(v => v.missing),
}))
const critic = await agent(`Read ${BRIEF} first, then ${CLUSTERS}. Seventeen mappers built a classical Chinese vocabulary for the Theory of Becoming, one cluster each, and two verifiers judged each. Here is the compact table (cluster → concept → proposed name, with the verifiers' verdicts, entry counts and what verifiers said is missing):
${JSON.stringify(table)}

Triage coverage: ${seen} verdicts over ${chunks.reduce((a, c) => a + c.n, 0)} judgments; failed chunks: ${missingChunks.join(',') || 'none'}.

Judge the vocabulary as ONE system, not cluster by cluster:
1. unmapped-concept: theory concepts (check the canonical chapter's "theory stated in full" and §10 glossary) with no name.
2. unplaced-symbol: major classical symbols that the 中华 edition must place, either as a name or as an explicit "not adopted, because" (at least: 道 德 仁 义 礼 智 信 诚 气 理 心 性 命 天 人 阴阳 五行 太极 中 和 几 势 时 位 象 数 名 实 一 多 有 无 虚 静 动 变 化 通 久 常 反 复 生 死 损 益 感 应 公 私 空 缘起 自然 无为).
3. collision: one name used for two concepts across clusters, or two names for one concept.
4. inconsistency: a name at odds with the adopted ones (识 明 无明 理 机 护闭 约定俗成 中和) or with the theory (e.g. a valence smuggled in).
5. coverage: clusters whose correspondences look thin relative to their candidates, or traditions (庄 墨 名辩 兵 法 儒 道 佛 易) underrepresented.
For each issue give the concrete action. In "system", assess whether the vocabulary is one, relational and dynamic, and where it is not.`,
  { label: 'critic', phase: 'Critic', schema: CRITIC_SCHEMA })

return {
  triage: { seen, flagged, failed: missingChunks, perCluster: Object.fromEntries(Object.entries(byCluster).map(([k, v]) => [k, { primary: v.primary.length, secondary: v.secondary.length }])) },
  clusters: ok.map(r => ({ key: r.key, names: r.map.names.length, entries: r.map.entries.length, parallels: r.map.parallels.length, rejected: r.map.rejected.length,
    verdicts: r.verdicts.map(v => ({ lens: v.lens, keep: v.names.filter(x => x.verdict === 'keep').length + v.entries.filter(x => x.verdict === 'keep').length, revise: v.names.filter(x => x.verdict === 'revise').length + v.entries.filter(x => x.verdict === 'revise').length, reject: v.names.filter(x => x.verdict === 'reject').length + v.entries.filter(x => x.verdict === 'reject').length })) })),
  failedClusters: args.clusters.filter((c, i) => !results[i]).map(c => c.key),
  critic,
}
