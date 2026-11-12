export const meta = {
  name: 'map-last-truth-and-terms',
  description: 'Second readers for what the coordinator wrote last (the first path\'s cast, retold steps, the note and the frame), repairs to English the Chinese checkers found off, and one word for one thing in the Chinese. Read only.',
  phases: [
    { title: 'Truth', detail: 'the first path; arrows, names and the page\'s own statements' },
    { title: 'Terms', detail: 'one word for one thing, proposed then checked' },
  ],
}
const KIT = '/Users/ren/theories/tmp/r7/sheet/v2'
const WT = '/Users/ren/tmp/rw/map2/wt'
const LEAN = '/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/'
const EDITS = {
  type: 'object',
  properties: {
    edits: { type: 'array', items: { type: 'object', properties: {
      file: { type: 'string', description: 'sheet | passages | paths | laid | module | template' },
      where: { type: 'string' }, old: { type: 'string', description: 'the exact text now: the whole value of the field, or a phrase that occurs exactly once in that file' }, new: { type: 'string' }, why: { type: 'string' },
    }, required: ['file', 'where', 'old', 'new', 'why'] } },
    checked: { type: 'array', items: { type: 'object', properties: { item: { type: 'string' }, verdict: { type: 'string', description: 'holds | corrected | cannot tell' }, against: { type: 'string' } }, required: ['item', 'verdict', 'against'] } },
    data_changes: { type: 'array', items: { type: 'object', properties: { what: { type: 'string' }, why: { type: 'string' } }, required: ['what', 'why'] }, description: 'changes that are not a replacement of text: a kind of an arrow, an example to take off a step, a name to drop, a source id to record' },
    notes: { type: 'string' },
  },
  required: ['edits', 'checked', 'data_changes', 'notes'],
}
const COMMON = `
Read only. Change no file. Run no tests, builds or renders; small read-only scripts that print from JSON or count are fine. The files are final for the moment: no one else is editing them while you read.

The map's data: ${KIT}/data/sheet.json (rows; boxes with says, eg, known_*), ${KIT}/data/passages.json (arrows: tag, sentence, laws, kind, further ways under "more"; and "stays"), ${KIT}/data/paths.json (paths: lead, cast, sections of steps with say_en/say_zh, "on" naming the box, stay or arrow each step stands on, eg naming the box whose example is shown under the step, a test note; shows, want, known), ${KIT}/data/laid.json (tests laid on the map). The tool: ${WT}/tools/research/map_sheet.py (file "module"), ${WT}/tools/research/map_sheet.html (file "template"). Rendered: ${KIT}/out/THE-MAP.md, PATHS.md, PLACES.md and their .zh.md. The Lean: ${LEAN} (an arrow's "laws" gives module and name).

In this work, text written fast has again and again come out tidier than what it stands on: a condition dropped, a premise told as a consequence, "not contradicted" told as support, a number beside the wrong claim. This morning a second reader corrected all seven of the coordinator's one-line summaries of tests. What you are given now was written after that, by the same hand, and has had no second reader. Find where it says more, or less, than what it stands on, and give the repair.

Every repair is a replacement: the file, where, the exact text now (the whole field value, or a phrase occurring exactly once in that file), the new text, why. English and Chinese both, so they say the same. Plain words; a sentence a person can read once. A rule the tool enforces: a box's name and an arrow's tag and sentence may not use people, person, someone, anyone, everyone, no one, nobody, who, whom, nor 人, 谁, 大家 (the laws hold of anything that keeps going). Chinese terms to keep: the rule being updated 重定; shaping the rule 改规则; those that set the rule 定规则的各方; what the rule does not count 规则没算进去的; built example 造出来的例子; a system's own law 规律 and a proved law of the map 定律; range 范围; push back 推回; correction 纠正; lapse 中断; the lock 定局; a reading 解读.`

phase('Truth')
const lock = agent(`You are the second reader of the first path of a map, "A rule that holds itself in place" (path id "lock" in paths.json), as the coordinating AI left it an hour ago.
${COMMON}

Your items. Say for each what you set it against.

1. The cast: lock.cast, ten entries (en, zh, says_en, says_zh), shown before step 1 as "Who and what is in it, and the words used". Set each against the objects of the Lean these steps stand on (RuleCapture, ClosedCapture, PoolFromCourse, ReadInTime, ReadOffInTime, Web: the rule, its update, the favoured side's share and lead, the rest, the loss, what reads or counts it, what sets the rule, the shapers) and against the boxes' own sentences in sheet.json (rows b1, b2, b3, bs). Is each entry what the steps mean by the word? In particular "the rest" (is it what is picked among besides the favoured side, or those whose judgments set the rule besides it?), "what sets the rule", "an update ... from what it has picked", and the two-part entry on "of the course itself; given from outside" (set it against how the arrows' kinds law and needs are actually used on this path: is "given from outside" always either a premise the laws assume or something supplied from outside the picking?). Repair, or cut an entry that cannot be made true in one line.

2. Steps 3 and 8, retold shorter than their second readers left them (the fuller statements stay on the arrows, one click below). Step 3: "A lock that goes by the lead alone runs the same however much is used up. That the loss goes on growing, locked or not, is assumed by the laws, not proved." Step 8: "The loss gets back to the rule in time exactly where at least one of those that set the rule can tell it while what is being lost can still be kept." Set each, English and Chinese, against its arrows (b1.held>b2.uncounted; b2.uncounted>b2.felt and b3.rest>b2.felt) and their Lean statements (ClosedCapture.lock_outlives_loss, join_course; Web.readableInTime_iff, Web.separates_all_iff_member). Does step 8's merging of two laws into one sentence hold?

3. "For good". Step 9 says: if the rest count the loss and the judgments taken together go against what the rule favoured at this update and the next, the rule turns for good. Step 16 tells a built case in which the rule had turned and the lock came back for good. A cold reader took these for a contradiction. Open ReadInTime.turned_iff, ClosedCapture.Thinned.turned_iff and kept_iff, and PoolFromCourse.Drained.strong_undone with what it depends on. Under which premises does "for good" hold in step 9's law (a fixed pool of what counts the loss? the rest judging what comes back to the shapers no higher than the shapers do, which a checker found unstated: lo' <= hi)? Does step 16's case break one of them, and which? Then give the wording, English and Chinese, for: step 9; the sentence of the arrow b2.felt>b2.counted; the sentence in the page's opening paragraph (sheet.json lead_en, lead_zh: "... the rule turns for good"); and the sentence in lock.want_en / want_zh ("the rule turns, for good if they still go against it at the next update"). The condition must be said where the claim is made, in as few words as it takes.

4. The examples now shown under steps 1, 6, 8, 9, 12, 14, 15, 17, 18 (each step's "eg" names a box; the box's eg_en / eg_zh is printed under the step as "Such as ..."). They are illustrations, not tested cases, and were written for the boxes, not the steps. For each: does the example illustrate what the step says, or would a reader take it to say something the step does not (for instance step 17, which says no law tells what first makes a rule start to be updated from its own picks, now followed by "Such as an entrance exam set by a ministry")? Report the ones to take off as data_changes.

5. The note under step 6 ("Laid on a judge reading its own picks: locked in 5 of 5 runs where nothing read the loss. Elsewhere in the same test the pairing gave way.") against the test "judge" in laid.json; and in lock.want_en / want_zh the sentence "Four arrows on the whole map lead into the first, two of them on this path" against passages.json and the path's steps.

6. The opening paragraph as it now stands (sheet.json lead_en and lead_zh, the Chinese merged by hand from two readers' repairs): does the Chinese say what the English says, clause for clause?

Return the repairs, what you checked, the data changes, and notes.`, { label: 'truth:first-path', phase: 'Truth', schema: EDITS })

const rest = agent(`You are the second reader of several things on a map that changed in the last hour: English sentences that checkers of the Chinese found to say more than their laws; two arrows whose kind is in doubt; one name with no source; and the page's own statements about itself.
${COMMON}

Your items. Say for each what you set it against.

1. Six English sentences that a checker of the Chinese found off against the Lean. For each, open the Lean, decide, and give the repair in English and in Chinese (the Chinese beside it was repaired this hour to follow the English as it stood; it must follow your English).
 (a) the arrow between e2.good and e2.swing (kind line), second sentence: the start is unqualified; Regulation.relay_threshold proves settling for every start held below the band.
 (b) b2.uncounted > a2.supplied: "it takes exactly the spare above the needs" rests on premises the sentence leaves out (Optimum.keeping_optimum_takes_slack: each need reached exactly by some allowed outcome, the needs met before the step, the step balanced and gaining nothing on the whole).
 (c) b1.held > b2.counted: "go against what it favoured" includes a tie (ReadInTime.turned_early_iff); the sibling arrow b2.felt > b2.counted says "ties included", this one does not.
 (d) d1.gap > d1.round: "chains of waits are bounded, all give after that many steps" is loose by one step against Withholding.gives_without_chain.
 (e) e2.rest > a1.up, second clause: "arising without end needs exchange beyond every closed set" is stated with no condition; World.arising_opens assumes a listed world whose flow balances and loses something at each taking.
 (f) d2.handed > a2.ended: two conditions missing (the passing premise of Web.ByPassing.ends_within; no later revision to a nonzero quota).
 The checkers' full findings are in ${KIT}/zh-merge.log (lines starting ENGLISH OFF).

2. Two arrows that run back along the row "How many ways are in use": d3.merged > d3.several and d3.one > d3.several. Their kind is law (drawn solid, counted as "proved of the course itself"), and their tags say something comes in from outside. Open their Lean statements. Is what comes in a premise of the theorem (then the kind is needs, as on the rest of the map) or does the law derive the return from the course? Report a change of kind as a data_change, with the sentence repaired if needed.

3. The name at box b3.rest ("The rest count too"): 黄宗羲 (Huang Zongxi), 公其非是於學校. It was on the sheet before the names were checked and has no source recorded (known_src is null). The account's readings are in /Users/ren/theories/theories/becoming/results/atlas/entries/correspondences.json and, for the classical pilot, under /Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/tm-traditions-onto-the-map/pilot/. Find the reading it would come from (ids beginning cx-cc-huang, or the pilot's zhou.json), and set the name against it the way the other names were set (the relation the reading states, and whether what the reading carries is a dynamic or a law of this box). Keep, fix or drop; report the source id to record as a data_change.

4. What the page says of itself, written this hour: in the module, the dict ABOUT (English and Chinese rows of the table under "How far it goes", with its lead and rest), and in the dict S the entries 'how', 'along', 'settings', 'scope', 'by_name_lead', 'cast' for both languages; in the template, the two short "Each row asks one thing ..." strings. Set every statement against the data and the logs: ${KIT}/fill.log, short.log, final.log, zh-merge.log, final-zh-code.json, final-cold-truth.json, final-zh-check.json, and the counts the module computes. Points to press: (i) 'how' now says "A thing stands in one box of every row that applies to it" and that an arrow along a row is "a change of that row's answer" and between rows "from one row's answer to another's": is that what the arrows of kind line (a boundary) and same (one box a case of another) and the cross-row arrows are? (ii) the row on the Chinese: "read through as Chinese by two AI readers; their repairs set against the English, and the Lean where a condition was touched, by further readers": six checkers did this (final-zh-check.json); is it said right, and does it claim the whole Chinese was read (the first two readers were asked to read the pages through; the four later tests' full texts were left out)? (iii) the row "The sentence or two that opens each test; the names listed under each path; the opening paragraph; the cast of the first path ... by a second AI reader, who corrected most": the cast is being read now by another reader, not yet "corrected"; word the row so it is true whichever way that reading comes out. (iv) one statement you cannot check from files: "The person who directs the work has read the first path, in an earlier wording; no one outside the work has read it yet." It rests on this session's exchange (he was asked, after the page was published privately, "After reading the first path on the page: is this the map?" and answered "Yes, go on"). Leave its substance; say only if its wording claims more than that exchange carries.

5. Three Chinese sentences merged by hand this hour from two readers' repairs, in laid.json: line_zh of the tests lake, judge and season. Does each say what its line_en says, clause for clause?

Return the repairs, what you checked, the data changes, and notes.`, { label: 'truth:arrows-names-frame', phase: 'Truth', schema: EDITS })

phase('Terms')
const TERMSCHEMA = {
  type: 'object',
  properties: {
    edits: { type: 'array', items: { type: 'object', properties: {
      file: { type: 'string', description: 'sheet | passages | paths | laid | module | template' },
      where: { type: 'string' }, old: { type: 'string', description: 'a phrase that occurs exactly once in that file, long enough to be unique, short enough to hold only what changes' }, new: { type: 'string' }, why: { type: 'string' },
    }, required: ['file', 'where', 'old', 'new', 'why'] } },
    left: { type: 'array', items: { type: 'string' }, description: 'inconsistencies seen and deliberately left, each with the reason' },
  },
  required: ['edits', 'left'],
}
const terms = agent(`You are making the Chinese of a map use one word for one thing. Two readers read the Chinese pages through and each left a list of terms used inconsistently, with the form to keep; six checkers then repaired ninety sentences and noted what still stands. Your work is the remainder: every place where the other form still stands.
${COMMON}

The two lists: ${KIT}/final-zh-code.json, under result.zh_boxes.terms and result.zh_paths.terms (or without "result"). What the checkers noted as still standing: ${KIT}/zh-merge.log (the NOTES paragraphs and the OPEN items). Where the two lists disagree, these decide: holders of a taught rule 守着它的 (not 持有的, not 持守的); those that set the rule 定规则的各方; what the rule does not count 规则没算进去的 (in sentences; box names stay as they are); built example 造出来的例子 (not 构造的例子, 构造出来的例子); a system's own law 规律 (not bare 律); a band of levels 范围 (not 带, 带内, 带宽); push back 推回 (not 回推); correction 纠正 (not 修正, 改正); the rule's update 重定 (改 only in 改规则); a fresh look 对照; the means a correction draws on 本钱; a unit 一份 (not 一个单位); a link 环节; a lapse 中断; a reading 解读; the lock's loop 圈, a ring of effects in the last band 环; pays 划得来 (not 划算); a law on the map 图上的定律 (not 画出的定律); "if and only if" as two plain directions or ……，只看……, not 恰好是在……的时候 / 恰在……; a sentence-head "Where ..." as 要是 / 只要, not ……的地方：; 过程 not counted with 条.

Search the four data files (every Chinese field: zh, says_zh, eg_zh, tag_zh, say_zh, lead_zh, shows_zh, want_zh, known_zh, unlike_zh, line_zh and the tests' fields) and the Chinese strings of the module and the template. For each place, give a replacement of the smallest phrase that is unique in its file. Do not touch these, which another reader is rewriting now: in paths.json the path "lock": its cast, steps 3, 8 and 9, and want_zh; in sheet.json lead_zh; in passages.json the arrows b2.felt>b2.counted, b1.held>b2.counted, b2.uncounted>a2.supplied, d1.gap>d1.round, e2.rest>a1.up, d2.handed>a2.ended, d3.merged>d3.several, d3.one>d3.several and the arrow between e2.good and e2.swing; in laid.json no line_zh.

A change of word must not change what is said: where the other form carries a condition or a limit in its sentence (an "exactly when", a "built"), the replacement carries it too; read the English beside it before each. A box's name, an arrow's tag and sentence, and a stay may not use 人, 谁 or 大家. Where rewording for a term would need a whole sentence rewritten, list it under "left" with the reason instead.`, { label: 'terms:propose', phase: 'Terms', schema: TERMSCHEMA })
  .then(t => t && agent(`You are the second reader of ${t.edits.length} small replacements proposed to make the Chinese of a map use one word for one thing. A replacement of a word is where a sentence quietly changes what it says. For each, find the field, read the English beside it, and decide.
${COMMON}

The proposals:
${JSON.stringify(t.edits, null, 1)}

For each: does "old" occur exactly once in that file (count it in the file's text as string values; for module and template, raw text)? After the replacement, does the Chinese sentence still say what the English beside it says, with every condition and limit? Is it natural Chinese? Does it avoid 人, 谁, 大家 in a box's name, an arrow's tag or sentence, a stay? Return in "edits" only the replacements to apply, each as it should be applied (yours where you corrected one), and in "left" the ones you dropped, each with the reason.`, { label: 'terms:check', phase: 'Terms', schema: TERMSCHEMA }).then(c => ({ proposed: t, checked: c })))

const [a, b, c] = await Promise.all([lock, rest, terms])
log('first path: ' + (a ? a.edits.length + ' edits, ' + a.data_changes.length + ' data changes' : 'none') + '; arrows, names, frame: ' + (b ? b.edits.length + ' edits, ' + b.data_changes.length + ' data changes' : 'none') + '; terms: ' + (c && c.checked ? c.checked.edits.length + ' kept of ' + c.proposed.edits.length : 'none'))
return { lock: a, rest: b, terms: c && c.checked ? { edits: c.checked.edits, left: c.checked.left, proposed: c.proposed } : null }
