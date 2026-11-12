export const meta = {
  name: 'check-chinese-edits',
  description: 'Second readers set each proposed Chinese repair against the English beside it (and the Lean where a condition is touched) before it is applied. Read only.',
  phases: [{ title: 'Check', detail: 'six readers, fifteen repairs each' }],
}
const KIT = '/Users/ren/theories/tmp/r7/sheet/v2'
const WT = '/Users/ren/tmp/rw/map2/wt'
const SCHEMA = {
  type: 'object',
  properties: {
    verdicts: { type: 'array', items: { type: 'object', properties: {
      n: { type: 'integer', description: 'the repair\'s number in its section, counted from 1' },
      verdict: { type: 'string', description: 'keep | fix | drop' },
      final: { type: 'string', description: 'the Chinese to put in place of "old": the proposal as it is (keep), your corrected text (fix), or empty (drop)' },
      why: { type: 'string' },
      english_off: { type: 'string', description: 'empty unless the ENGLISH beside it says something the law or the record does not; then what, with the source' },
    }, required: ['n', 'verdict', 'final', 'why', 'english_off'] } },
    open: { type: 'array', items: { type: 'object', properties: { question: { type: 'string' }, answer: { type: 'string' }, edit_file: { type: 'string' }, edit_old: { type: 'string' }, edit_new: { type: 'string' } }, required: ['question', 'answer', 'edit_file', 'edit_old', 'edit_new'] } },
    notes: { type: 'string' },
  },
  required: ['verdicts', 'open', 'notes'],
}
const TERMS = `One word for one thing, across all six checkers (use these in every final text you return):
- the rule being updated from results: 重定 (never 改, which is kept for 改规则, shaping the rule in one's own favour)
- those whose judgments set the rule: 定规则的各方 (in sentences; never the headless 定规则的那些)
- what the rule does not count, in a sentence: 规则没算进去的（那样东西）
- a built example: 造出来的例子 (not 构造的例子)
- a system's own law of motion: 规律 (定律 only for the map's proved laws; a law on the map: 图上的定律)
- a band of levels: 范围 (not 带, 带内, 带宽)
- push back: 推回; correction: 纠正; a fresh look: 对照 / 重新对照一次; the means a correction draws on: 本钱
- a lapse in giving: 中断; a unit of stock: 一份; a link: 环节; what it waits on: 所等的
- a reading (not proved): 解读; the lock: 定局, 定住; the lock's loop: 圈; a ring of effects in the last band: 环
- a need loosens: 需要变小; pays: 划得来
- members who hold a taught rule: 守着它的 (not 持有的, not 持守的); quota: 名额
- "if and only if": say both directions plainly, or "……，只看……"; avoid 恰好是在……的时候
- "Where <condition>," at the head of a sentence: 要是…… / 只要……, never ……的地方：`
const part = (section, from, to, extra) => agent(`You are the second reader of repairs proposed to the Chinese of a map. A first reader read the Chinese pages through as a Chinese reader and proposed replacements. A replacement written for fluency is exactly where a condition gets dropped or a claim gets stronger, so nothing is applied until you have set it against what it stands on.

Read only. Change no file, run nothing heavy; small read-only scripts that print fields from JSON are fine.

The proposals: ${KIT}/final-zh-code.json, under result.${section}.edits (or .${section}.edits if there is no "result" key). Your share: numbers ${from} to ${to}, counted from 1. Each has file, where, old, new, why, kind.

Where the text lives. sheet, passages, paths, laid: ${KIT}/data/<file>.json, every Chinese field beside its English (zh / en, says_zh / says_en, tag_zh / tag_en, say_zh / say_en and so on). module: ${WT}/tools/research/map_sheet.py. template: ${WT}/tools/research/map_sheet.html. The Lean: /Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ (an arrow's "laws" names its statements, last name after the module).

For each proposal:
1. Find the field. Read the English beside it. The English of arrows, stays and path steps was set against the Lean by earlier readers, so it is the meaning the Chinese must carry: every condition (where, provided, only if, exactly when), every quantifier (each, some, at least once, every later), and every limit on how far a thing is known (a built example, given not derived, a reading, not contradicted, unresolved).
2. Where the proposal adds, drops or changes a condition or a quantifier, or the first reader says the English may be the one at fault, open the Lean statement (for a test: the test's own English fields) and settle it. If the English is off, say so in english_off; still give the Chinese that says what is proved.
3. Verdict. keep: the proposal says what the English says and is better Chinese than the old. fix: the idea is right but your text is needed (it lost or added something, or can be plainer); give the full replacement for "old". drop: the old was fine, or the proposal is worse or wrong.
4. A rule the tool enforces: a box's name, an arrow's tag and sentence, and a stay may not use 人, 谁 or 大家 (人为 is allowed). Do not let a final text introduce them there.
5. The final text replaces exactly the "old" string, nothing more; it must fit the words around it.

${TERMS}
${extra || ''}
Return one verdict for each of your numbers, and notes on anything a later reader of the Chinese should know.`, { label: `check:${section}:${from}-${to}`, phase: 'Check', schema: SCHEMA })
const OPEN = `
Three open questions the first reader left for you; answer each in "open", with an edit (file, exact old text occurring once in that file, new text) where one side should change, or empty edit fields where nothing should:
(a) arrow b0.together > a1.within in passages.json: the Chinese sentence ends with a clause the English lacks (实际的分法是不是这样，定律没有说). Which side is right by the Lean statement? Make the two say the same.
(b) arrow b2.uncounted > b3.gone: the Chinese adds 没有一般的定律 where the English says only "Shown in built cases, and as a reading." Make the two say the same, whichever is true to what the arrow's laws are.
(c) arrow between e1.ring and e1.line (kind line), and its further ways: the Chinese says the link takes a reading (取读数) from a standing level where the English says "fed". The Lean docstring is said to speak of reading the level. Which is right? Make the two say the same.
`
const jobs = [
  ['zh_boxes', 1, 15], ['zh_boxes', 16, 30], ['zh_boxes', 31, 45, OPEN],
  ['zh_paths', 1, 15], ['zh_paths', 16, 30], ['zh_paths', 31, 45],
]
const out = await parallel(jobs.map(j => () => part(j[0], j[1], j[2], j[3]).then(r => ({ section: j[0], from: j[1], to: j[2], r }))))
for (const o of out.filter(Boolean)) {
  const v = (o.r && o.r.verdicts) || []
  log(`${o.section} ${o.from}-${o.to}: keep ${v.filter(x => x.verdict === 'keep').length}, fix ${v.filter(x => x.verdict === 'fix').length}, drop ${v.filter(x => x.verdict === 'drop').length}, english off ${v.filter(x => x.english_off).length}`)
}
return { checks: out }
