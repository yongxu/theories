export const meta = {
  name: 'lineage-finalize',
  description: 'Finalize each stratum of the lineage: apply verifier findings, add real missing points, fix renames and papers, write Chinese',
  phases: [{ title: 'Finalize', detail: 'one agent per stratum, English and Chinese' }],
}

const WT = '/Users/ren/theories/.claude/worktrees/rw-spine'
const BUDGET = { 'early': 9, 'pre-becoming': 10, 'becoming-october': 10, 'november': 9, 'thread': 7, 'papers': 3 }

const POINT = {
  type: 'object',
  properties: {
    id: { type: 'string' }, date: { type: 'string', description: 'YYYY-MM-DD, YYYY-MM or YYYY' },
    title_en: { type: 'string' }, title_zh: { type: 'string' }, what_en: { type: 'string' }, what_zh: { type: 'string' },
    evidence: { type: 'array', items: { type: 'object', properties: {
      path: { type: 'string' }, locator: { type: 'string' }, quote: { type: 'string', description: 'copied exactly from the file, at most 25 words; empty for a private path' },
      private: { type: 'boolean', description: 'true only for a path not in the repository (sources/12, 13, 18, or material not stored here)' } },
      required: ['path', 'locator', 'quote', 'private'] } },
    label: { type: 'string', enum: ['public', 'private', 'reconstruction'] }, label_why: { type: 'string' }, thread: { type: 'boolean' },
  },
  required: ['id', 'date', 'title_en', 'title_zh', 'what_en', 'what_zh', 'evidence', 'label', 'label_why', 'thread'],
}
const OUT = {
  type: 'object',
  properties: {
    points: { type: 'array', items: POINT },
    renames: { type: 'array', items: { type: 'object', properties: {
      date: { type: 'string' }, from: { type: 'string' }, to: { type: 'string' }, where_en: { type: 'string' }, where_zh: { type: 'string' },
      evidence_path: { type: 'string' }, quote: { type: 'string' }, label: { type: 'string', enum: ['public', 'private', 'reconstruction'] } },
      required: ['date', 'from', 'to', 'where_en', 'where_zh', 'evidence_path', 'quote', 'label'] } },
    papers: { type: 'array', items: { type: 'object', properties: {
      id: { type: 'string' }, title: { type: 'string' }, date: { type: 'string' }, paths: { type: 'array', items: { type: 'string' } },
      claimed_en: { type: 'string' }, claimed_zh: { type: 'string' }, stands_en: { type: 'string' }, stands_zh: { type: 'string' },
      stands_basis: { type: 'array', items: { type: 'string' } }, label: { type: 'string', enum: ['public', 'private', 'reconstruction'] } },
      required: ['id', 'title', 'date', 'paths', 'claimed_en', 'claimed_zh', 'stands_en', 'stands_zh', 'stands_basis', 'label'] } },
    output_readme: { type: 'string', description: 'papers stratum only: the final neutral output/README.md in English, markdown' },
    dropped: { type: 'array', items: { type: 'string' }, description: 'ids or items left out, each with its reason' },
  },
  required: ['points', 'renames', 'dropped'],
}

const DIR = args.dir
const threadIds = args.thread
const results = await parallel(args.strata.map(key => ({ key })).map(s => () => agent(
`You finalize one stratum ("${s.key}") of theories/LINEAGE.md, a generated page on how the account in this repository grew. Work READ-ONLY in ${WT}; edit nothing, run no tests. Never open /Users/ren/theories/sources/12-*, 13-*, 18-* or drafts/2026-10-02-friend-conversation.

Below are this stratum's verified points (a verifier already corrected them), the verifier's other findings (per-point problems still worth applying, "missing" turning points, rename problems, paper problems), the gathered renames and papers, and every stratum's point list.

Do:
1. Keep at most ${BUDGET[s.key]} points for this stratum: the real turning points, where vocabulary, method, structure or standing changed. Add a "missing" item only where it is a real turning point and you open its evidence and confirm it; otherwise list it in "dropped" with the reason. ${s.key === 'thread' ? 'All your points are thread:true, in order: the selection mechanism from its first statement (2024-07) through the meta-attractor to closed capture on the spine (and its first form, capture through the rule, 19 to 20 October 2026) to T7\'s failed bridge.' : 'Do not include the thread\'s points, which the thread stratum owns: ' + threadIds.join('; ') + '. thread:false on all yours.'} Do not duplicate a point another stratum has (list below); prefer this stratum's dates only.
2. For every point: date as exact as the evidence; title_en a noun phrase of at most 10 words; what_en one or two sentences copying the source's words for any claim, no standing word changed, no qualifier dropped, no person named (no author's name; "the author" is also to be avoided: say "a conversation", "a draft", "the notes"); evidence 1 to 3 items whose quote you have checked is in the file verbatim (copy exactly, including punctuation; at most 25 words; for a private path set private:true and quote ""); label by these rules: "public" where a tracked file states it; "private" where only private or unpublished material states it, which a public text cites; "reconstruction" where no source states it and it rests on a synthesis such as TIMELINE.md, the September timeline written by an AI from the corpus.
3. title_zh and what_zh: a faithful Chinese rendering for a Chinese reader, in the account's Chinese terms (read GLOSSARY.md's Chinese column and theories/becoming/THE-THEORY-OF-BECOMING.zh.md for terms: 续, 缘, 类, 文法, 生生, 选择, 耦合, 冻结检验, 已证明, 猜想, 未通过 …). Quotations stay in their original language inside「」 when the source is Chinese, or are translated with the English kept only where a term matters.
4. Renames: keep only real renames (a term replaced by another for the same thing), each with a quote you checked verbatim at evidence_path; label "reconstruction" where only TIMELINE's ledger states it; drop or relabel per the rename problems; where_en / where_zh say where and why, in a clause.
${s.key === 'papers' ? '5. Papers: apply the paper problems; claimed_en/zh in the paper\'s own words; stands_en/zh in the live account\'s or the crosswalk\'s words, with "[AI reading]" / "［AI 读法］" where it is your judgment; stands_basis paths must exist. Write output_readme: a neutral README.md for output/ in English (what each subfolder and file is and its date; the review-packet editions as frozen reader editions, naming which the board calls current in its "Which edition to send" line, without recommending any reading; what is history), checking each path exists.' : ''}

Read every stratum's point list (stratum, id, date, title) from ${DIR}/lineage-all-points.json, and this stratum's input (points, renames, papers, output_readme_en, missing, rename_problems, paper_problems, verdict_problems) from ${DIR}/lineage-stratum-${s.key}.json, with the Read tool.`,
  { label: `finalize:${s.key}`, phase: 'Finalize', schema: OUT, effort: 'high' })
  .then(r => ({ key: s.key, ...r }))))
return results
