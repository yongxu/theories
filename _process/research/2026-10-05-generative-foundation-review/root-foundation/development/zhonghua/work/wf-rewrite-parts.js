export const meta = {
  name: 'zh-rewrite-parts',
  description: 'Rewrite each part of the restructured 中华本 in the decided names, carrying out the restructuring plan’s text work and writing the added 條, then review each part adversarially into exact edits',
  phases: [{ title: 'Rewrite', detail: 'one editor per part, returning its 條 by id' }, { title: 'Review', detail: 'one adversarial reviewer per part' }],
}
const K = '/Users/ren/theories/.claude/worktrees/zhonghua/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua'
const W = '/Users/ren/theories/.claude/worktrees/zhonghua'
const CTQ = `python3 -I ${K}/ctq.py`
const RES = `python3 -I ${K}/work/resolve.py`
const LEAN = `${W}/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming`
const READ = `Read first: ${K}/BRIEF-ZH.md, ${K}/STYLE-ZH.md, ${K}/NAMES-ZH.md (the name table, now with the names added by the naming pass), ${K}/work/plain-wordings.md (concepts that stay in plain modern Chinese, each with the one wording to use), ${K}/work/symbols-not-adopted.tsv. The restructured book's outline, every 條 id with the number and title it will have, is ${K}/work/book-1-outline.txt; a 條 is referred to in any text as ⟦id⟧ (for example ⟦四·一⟧ or ⟦NEW-3⟧), never by its number, and the renderer writes the number.`
const PART = {
  type: 'object',
  properties: {
    heading: { type: 'string' }, intro: { type: 'string' },
    tiao: { type: 'array', items: { type: 'object', properties: { id: { type: 'string' }, title: { type: 'string' }, body: { type: 'string', description: '**經**　…, **說**　…, **證**　… paragraphs' } }, required: ['id', 'title', 'body'] } },
    duizhao: { type: 'string', description: 'the part’s 「#### 对照」 section, or empty' },
    notes: { type: 'string', description: 'what you changed, what you could not do, and any name the table still lacks' },
  },
  required: ['heading', 'intro', 'tiao', 'duizhao', 'notes'],
}
const REVIEW = {
  type: 'object',
  properties: {
    edits: { type: 'array', items: { type: 'object', properties: { id: { type: 'string', description: 'the 條 id, or INTRO, or DUIZHAO' }, find: { type: 'string', description: 'exact substring, occurring once in that 條 (or intro, or 对照)' }, replace: { type: 'string' }, why: { type: 'string' } }, required: ['id', 'find', 'replace', 'why'] } },
    notes: { type: 'string' },
  },
  required: ['edits', 'notes'],
}
const rewrite = p => agent(`${READ}

You rewrite ${p.label} of the 中华本《变化论》 after its restructuring. The part as it stands now (JSON: heading, intro, tiao with id, title, body, duizhao) is the item "part" of ${K}/work/rewrite/${p.key}.json; the same file has "edits" (the restructuring plan's text work for this part's 條 and 篇首: carry out every one), "added" (the 條 to write in full from the specification given in edits: 經, 說 and 證, with real declarations and records), and "duizhao_issues" (对照 lines that name no entry of the map: give each the entry id that carries the passage, found in ${K}/passages.json by its fragment, or drop the line).

Rewrite it so that: (1) every concept is written with the table's name (simplified form) or, for a plain concept, its one wording from plain-wordings.md, in 經 and 說 alike; a name new to the table is explained at its first use in the book with its composition and source, once; (2) each 經 says exactly what its 證 proves, with every local condition, and a witness in one constructed model is called one; (3) references to other 條 are ⟦id⟧ and point where the outline says the content now is; references to a 篇 use its number in the outline; (4) the continuation condition (凡续皆有顾) is stated, never asserted, and ordering lies in 以广为愈 alone, both premises named wherever the ethics is touched; (5) periphery declarations (Mathlib, axioms reported) are marked 外围 in 證; (6) Chinese only, Lean names and ids excepted; quotations unchanged unless the frozen text differs (check with ${CTQ} text SOURCE_ID '…'), every declaration current (${RES} NAME; grep ${LEAN}/*.lean). Keep every 條 of the part and its id, in the given order; do not add or remove 條. Return the whole part. Do not edit any file.`, { label: `rewrite-${p.key}`, phase: 'Rewrite', schema: PART })

const review = (r, p) => r ? agent(`${READ}

Review adversarially the rewritten ${p.label} of the 中华本《变化论》:
<<<PART
${JSON.stringify(r)}
PART>>>
Its restructuring instructions are in ${K}/work/rewrite/${p.key}.json ("edits", "added"). Check every 條: the 經 against its 證 (grep ${LEAN}/*.lean: hypotheses, direction of iff, witness or law); names (only the table's, simplified, each for its own concept; plain wordings as fixed); every 「…」〔ID〕 exact (${CTQ} text ID '…'); every ⟦id⟧ exists in ${K}/work/book-1-outline.txt and points to the right content; no 經 uses a name or law defined only in a later 條 of the outline; the instructions carried out; Chinese only. Return exact edits (find occurs once in the named 條, intro or 对照). Do not edit any file.`, { label: `review-${p.key}`, phase: 'Review', schema: REVIEW }) : null

const res = await parallel(args.map(p => async () => {
  const r = await rewrite(p)
  const v = await review(r, p)
  return { key: p.key, tiao: r ? r.tiao.length : null, edits: v ? v.edits.length : null }
}))
return { res }
