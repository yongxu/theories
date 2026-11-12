export const meta = {
  name: 'map-chinese-read-and-code-review',
  description: 'Two readers read the map\'s Chinese through as Chinese; one reviewer reads the tool\'s code. Read only.',
  phases: [
    { title: 'Chinese', detail: 'boxes and arrows; paths, tests and page strings' },
    { title: 'Code', detail: 'the map tool, its template and tests', model: 'opus' },
  ],
}
const KIT = '/Users/ren/theories/tmp/r7/sheet/v2'
const WT = '/Users/ren/tmp/rw/map2/wt'
const EDITS = {
  type: 'object',
  properties: {
    edits: { type: 'array', items: { type: 'object', properties: {
      file: { type: 'string', description: 'sheet | passages | paths | laid | module | template' },
      where: { type: 'string', description: 'which box, row, arrow, step, test or string' },
      old: { type: 'string', description: 'the exact Chinese text now, copied character for character; the whole value of the field or a phrase that occurs exactly once in that file' },
      new: { type: 'string' },
      why: { type: 'string' },
      kind: { type: 'string', description: 'wrong (does not say what the English says) | unnatural | unclear | inconsistent | long' },
    }, required: ['file', 'where', 'old', 'new', 'why', 'kind'] } },
    read_through: { type: 'string', description: 'what a Chinese reader meets on these pages, in a paragraph: what reads well, what tires, what is still not Chinese' },
    terms: { type: 'string', description: 'terms used inconsistently, each with the form to keep' },
  },
  required: ['edits', 'read_through', 'terms'],
}
const ZH = `You are reading the Chinese of a map through, as a Chinese reader would: someone educated, not a specialist, who has never seen this work and does not look at the English first.

This is reading only. Change no file. Run nothing heavy; small read-only scripts that print fields from the JSON are fine.

The map. A sheet of rows; each row asks one thing of anything that keeps going. A box (方框) is one way the answer can stand. An arrow (箭头) is a way from one box to another, with a short tag and a full sentence. Paths (路) are told step by step on it; tests (检验) are laid on it. The data are in ${KIT}/data/: sheet.json (bands, rows, boxes: zh, says_zh, eg_zh, known_zh, unlike_zh), passages.json (arrows: tag_zh, zh; stays: zh), paths.json (paths: zh, lead_zh, sections' zh, steps' say_zh, shows_zh, known), laid.json (tests). Every Chinese field sits beside its English. The rendered Chinese pages, for reading through in order, are ${KIT}/out/THE-MAP.zh.md, ${KIT}/out/PATHS.zh.md and ${KIT}/out/PLACES.zh.md.

Who it is for. Ren, who directs the work, reads Chinese and English. Of earlier pages he said: too many words, too much of our own vocabulary, hard for a human to read; and that the Chinese used 人 where the thing is not only about people. The English sentences of arrows and steps were set against proofs, so their MEANING is fixed: every condition ("where…", "provided…", "only if…") and every limit on how far a thing is known ("built example", "given, not derived", "a reading") must survive in the Chinese. Within that, the Chinese should be Chinese: short sentences, ordinary words, the order a Chinese speaker would say it in, no calques of English syntax, no 的的的 chains, no stacked 被.

A rule the tool enforces: a box's name and an arrow's tag and sentence may not use 人, 谁 or 大家 (the laws hold of anything that keeps going, not only of people); 人为 is allowed. Do not introduce them there. Elsewhere (examples, test descriptions about real people) they are fine.

What to return. Only what a Chinese reader would stumble on or be misled by; do not polish what already reads well. For each: the file, where it is, the exact text now (copy it character for character from the JSON; the whole field value, or a phrase that occurs exactly once in that file), your replacement, why, and its kind. At most 45 edits, worst first. Then a paragraph on what reading these pages through was like, and the terms used inconsistently with the form to keep.`

phase('Chinese')
const zhA = agent(ZH + `

Your part: the boxes, rows, bands and arrows. Read ${KIT}/out/PLACES.zh.md through in order (it is long: read it in parts), with sheet.json and passages.json beside it for the English and for exact text. Cover every band.`, { label: 'zh:boxes-and-arrows', phase: 'Chinese', schema: EDITS })
const zhB = agent(ZH + `

Your part: the page a reader meets first and the paths. Read ${KIT}/out/THE-MAP.zh.md and ${KIT}/out/PATHS.zh.md through in order, with paths.json and laid.json beside them. In laid.json read only the first three tests (ids lake, judge, stocks) and every test's line_zh if present; the other four tests are being rewritten now, so leave them. Also read the Chinese strings the tool itself writes: the dict S['zh'] and the function _about in ${WT}/tools/research/map_sheet.py (file "module"), and the Chinese entries of the T table and the Chinese branches of the panels in ${WT}/tools/research/map_sheet.html (file "template"). For module and template, "old" must be a phrase that occurs exactly once in that file.`, { label: 'zh:page-and-paths', phase: 'Chinese', schema: EDITS })

phase('Code')
const FIND = {
  type: 'object',
  properties: {
    findings: { type: 'array', items: { type: 'object', properties: {
      file: { type: 'string' }, line: { type: 'integer' }, summary: { type: 'string' }, failure_scenario: { type: 'string' },
      severity: { type: 'string', description: 'bug | risk | cleanup' }, fix: { type: 'string' },
    }, required: ['file', 'summary', 'failure_scenario', 'severity', 'fix'] } },
    notes: { type: 'string' },
  },
  required: ['findings', 'notes'],
}
const code = agent(`Review code that is about to land. Read only: change no file, run no tests, no render, no build (the machine is shared and loaded; the implementer's focused test runs are the evidence). You may run git diff, git status and read-only greps.

Worktree: ${WT} (branch rw-map-front). What is new or changed, all uncommitted: tools/research/map_sheet.py (new: validates four JSON files, lays out a chart, writes Markdown pages, SVG pictures and one HTML page to operate), tools/research/map_sheet.html (new: the template of that page, vanilla JS, data injected as JSON), tools/research/tests/test_map_sheet.py (new), and changes to tools/research/research.py, tools/research/the_map.py, tools/research/the_map.html, tools/research/tests/test_the_map.py, _process/research-config.json, MAP.md. The data it reads: theories/becoming/results/map/{sheet,passages,paths,laid}.json.

What it must hold to (the repository's rules for generated views): a render is deterministic, the same bytes each time; a generated page carries the GENERATED note; the page to operate is one HTML document with no external script, font or stylesheet and stays under 1,950,000 bytes; no generated body contains the two characters "](" outside a real Markdown link to a file that exists (a link checker scans every output body, HTML and SVG included, so JS like x[k](c) or a regex containing those characters would be read as a broken link); no href to a URL outside the site is written literally as href=" followed by the URL in the page to operate; user-visible strings from the data are escaped before they reach HTML or SVG.

Look for, in this order: (1) correctness bugs with a concrete failure: wrong geometry or routing class, a crop that hides or mislabels something (chart() with crop, the template's viewBox, the 'cut' stubs and their labels, a test's bands), validate() letting through data that then crashes build() or the template (a path step's ref to a missing arrow, a 'known' entry at a missing box, a test without pins, an empty path); (2) escaping holes: any data string reaching innerHTML, an attribute, or the SVG unescaped; JSON injected into a script tag where a "</script" or "<!--" in the data would break out; (3) non-determinism: iteration over a set or dict whose order reaches the output; (4) the state/URL-hash handling in the template: a hash naming an unknown path, test or box; language switch; (5) dead code and strings left from earlier rounds. For each finding give file, line, what is wrong, the concrete inputs that make it fail, and the smallest fix. Do not report style preferences.`, { label: 'code:map_sheet', phase: 'Code', schema: FIND, model: 'opus' })
const [a, b, c] = await Promise.all([zhA, zhB, code])
log('zh boxes/arrows: ' + (a ? a.edits.length : 'none') + ' edits; zh page/paths: ' + (b ? b.edits.length : 'none') + ' edits; code: ' + (c ? c.findings.length : 'none') + ' findings')
return { zh_boxes: a, zh_paths: b, code: c }
