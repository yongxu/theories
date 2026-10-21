export const meta = {
  name: 'zh-draft-pian',
  description: 'Draft each 篇 of the 中华本《变化论》 in 經/說/證 form from the name table and the checked passages, then review each adversarially into exact edits (two 篇 at a time)',
  phases: [{ title: 'Draft', detail: 'one drafter per 篇' }, { title: 'Review', detail: 'one adversarial reviewer per 篇, returning exact edits' }],
}

const Z = '/private/tmp/claude-501/-Users-ren-theories/ab4fc732-b2ac-420a-aa49-cf63c999271c/scratchpad/zh'
const K = '/Users/ren/theories/.claude/worktrees/zhonghua/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua'
const W = '/Users/ren/theories/.claude/worktrees/zhonghua'
const CTQ = `python3 -I ${Z}/ctq.py`
const RES = `python3 -I ${K}/work/resolve.py`
const LEAN = `${W}/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming`
const READ = `Read first, in this order: ${K}/BRIEF-ZH.md (the theory in brief and the rules), ${K}/STYLE-ZH.md (how the edition is written: 經/說/證, the 篇 format in §六, quotation marking), ${K}/NAMES-ZH.md (the name table: one classical name per concept, simplified forms; use no other name for a concept), ${K}/work/symbols-not-adopted.tsv (symbols that are not names, with reasons).`

const DRAFT = {
  type: 'object',
  properties: {
    pian: { type: 'string' },
    markdown: { type: 'string', description: 'the whole 篇, in Chinese, in the format of STYLE-ZH §六, starting with its ## heading' },
    declarations: { type: 'array', items: { type: 'string' }, description: 'every Lean declaration cited, full name' },
    records: { type: 'array', items: { type: 'string' } },
    quotes: { type: 'array', items: { type: 'object', properties: { text: { type: 'string' }, source_id: { type: 'string' } }, required: ['text', 'source_id'] } },
    missing_names: { type: 'array', items: { type: 'object', properties: { concept: { type: 'string' }, used: { type: 'string' } }, required: ['concept', 'used'] }, description: 'concepts you needed that the table has no name for, and what you wrote instead' },
    open: { type: 'string', description: 'what this 篇 leaves open or could not state exactly' },
  },
  required: ['pian', 'markdown', 'declarations', 'records', 'quotes', 'missing_names', 'open'],
}

const REVIEW = {
  type: 'object',
  properties: {
    pian: { type: 'string' },
    edits: { type: 'array', items: { type: 'object', properties: { find: { type: 'string', description: 'an exact substring of the draft, occurring once' }, replace: { type: 'string' }, why: { type: 'string' } }, required: ['find', 'replace', 'why'] } },
    verdict: { type: 'string', enum: ['sound after edits', 'needs redrafting'] },
    notes: { type: 'string' },
  },
  required: ['pian', 'edits', 'verdict', 'notes'],
}

const draft = p => agent(
`${READ}

You write ${p.no}「${p.title}」 of the 中华本《变化论》, the Chinese edition of the Theory of Becoming written in the classical names (cluster ${p.key}; its theory concepts are the entry with key "${p.key}" in ${K}/clusters.json; the names this 篇 owns are the rows of NAMES-ZH.md under "${p.key}", and it may use any other name in the table).${p.extra ? ' ' + p.extra : ''}

Material:
- the checked correspondences of this cluster: ${K}/work/passages/${p.key}.json (entries with kind 相合 agreement／定域 scope／相分 divergence, fragments exact from the frozen texts, current Lean declarations and records, AI readings);
- the laws themselves: the canonical chapter /Users/ren/theories/.claude/worktrees/zhonghua/theories/becoming/chapters/THE-THEORY-OF-BECOMING.md and its Chinese edition THE-THEORY-OF-BECOMING.zh.md (grep them; do not read them whole), the records under /Users/ren/theories/.claude/worktrees/zhonghua/theories/becoming/results/records/, and the Lean under ${LEAN}/*.lean (grep "theorem NAME\\|def NAME\\|structure NAME" and read the docstring and hypotheses). Resolve any name with ${RES} NAME.

Write the 篇: a 篇首 paragraph; then one 條 for each concept this 篇 names (its definition, 「X，Y也」) and one 條 for each law those names carry that the theory states (「凡……，則……」 with every local condition the Lean has, written in the table's names); a 條's 經 says no more than its 證 proves; 說 says the structure, its conditions, where it fails (counterexample, boundary), how it joins the 條 before and after, and may set one or two classical passages beside it, marked 相合、定域 or 相分 as in the passages file; 證 lists the declarations (full names, in backticks) and record links that carry it. Order the 條 so that each builds on the earlier: first how relations in the one unfolding form, persist and change, then what differentiates within them. End with 「#### 对照」 as STYLE-ZH §六 says, with at least one 相分 where this cluster has one.

Exactness: every Lean name exists (grep); every classical quotation is copied from the frozen text with ${CTQ} text SOURCE_ID '…' and written 「…」〔SOURCE_ID〕; the continuation condition is stated and never asserted, and ordering lies in C alone (以广为愈); no "Ren 说" as a reason; readings labelled 讀（AI，Dn）. Do not edit any file; return the 篇 in "markdown".`,
  { label: `draft-${p.key}`, phase: 'Draft', schema: DRAFT })

const review = (d, p) => {
  if (!d) return null
  return agent(
`${READ}

You review ${p.no}「${p.title}」 (cluster ${p.key}) of the 中华本《变化论》. Be adversarial: find what is wrong. The draft (markdown):
<<<DRAFT
${d.markdown}
DRAFT>>>

Check every 條: (1) 經: does it say exactly what its 證 proves, with every local condition of the Lean (grep ${LEAN}/*.lean; read hypotheses and docstrings), no stronger universal, no hidden weight or value, the continuation condition stated not asserted, ordering only in C? (2) names: only the table's names, each for its own concept, simplified forms; a 新 name explained at first use; no unadopted symbol used as a name; (3) every 「…」〔ID〕 quotation exact in the frozen text (${CTQ} text ID '…') and its period and layer stated rightly where the text dates it; (4) kinds: no divergence written as agreement, no agreement claimed on a shared word; (5) 證: each declaration exists under that full name (${RES} NAME) and carries the claim; each record link exists under /Users/ren/theories/.claude/worktrees/zhonghua/theories/becoming/results/records/; (6) one relational unfolding first: no separate entities presupposed, no dualist framing; (7) Chinese only (Lean names and ids excepted), clear and not padded.

Return exact edits: each "find" is a substring that occurs exactly once in the draft (copy it exactly, long enough to be unique), "replace" its corrected text, "why" in a few words. If the draft needs more than edits, say "needs redrafting" and why. Do not edit any file.`,
    { label: `review-${p.key}`, phase: 'Review', schema: REVIEW })
}

const inBatches = async (items, size, fn) => {
  const out = []
  for (let i = 0; i < items.length; i += size) {
    out.push(...await parallel(items.slice(i, i + size).map(x => () => fn(x))))
    log(`篇 done: ${Math.min(i + size, items.length)}/${items.length}`)
  }
  return out
}

const res = await inBatches(args.pian, 2, async p => {
  const d = await draft(p)
  const r = await review(d, p)
  return { key: p.key, chars: d ? d.markdown.length : null, decls: d ? d.declarations.length : null, quotes: d ? d.quotes.length : null, missing_names: d ? d.missing_names.length : null, edits: r ? r.edits.length : null, verdict: r ? r.verdict : null }
})
return { res }
