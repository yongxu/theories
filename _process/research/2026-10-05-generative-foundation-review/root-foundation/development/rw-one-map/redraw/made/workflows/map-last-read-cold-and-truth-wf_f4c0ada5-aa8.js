export const meta = {
  name: 'map-last-read-cold-and-truth',
  description: 'Before landing: one reader meets the map cold as a person would; one sets what changed this morning against what it stands on. Read only.',
  phases: [
    { title: 'Cold', detail: 'a person who has never seen it' },
    { title: 'Truth', detail: 'the lines, the chosen names, the note on how far it goes' },
  ],
}
const KIT = '/Users/ren/theories/tmp/r7/sheet/v2'
const WT = '/Users/ren/tmp/rw/map2/wt'
const COLD = {
  type: 'object',
  properties: {
    after_two_minutes: { type: 'string' }, after_fifteen_minutes: { type: 'string' },
    where_i_would_stop: { type: 'string' },
    is_it_a_map: { type: 'string', description: 'does the picture itself show what happens, or only the words beside it' },
    seven_complaints: { type: 'array', items: { type: 'object', properties: { complaint: { type: 'string' }, still_holds: { type: 'string', description: 'yes | partly | no' }, evidence: { type: 'string' } }, required: ['complaint', 'still_holds', 'evidence'] } },
    own_vocabulary: { type: 'array', items: { type: 'string' }, description: 'words or phrases a newcomer would not know, each with where it appears' },
    says_more_than_shown: { type: 'array', items: { type: 'string' } },
    changes: { type: 'array', items: { type: 'object', properties: { what: { type: 'string' }, where: { type: 'string' }, why: { type: 'string' }, size: { type: 'string', description: 'small (a wording, minutes) | medium | large (a redesign)' } }, required: ['what', 'where', 'why', 'size'] }, description: 'at most eight, the one that would help a reader most first' },
  },
  required: ['after_two_minutes', 'after_fifteen_minutes', 'where_i_would_stop', 'is_it_a_map', 'seven_complaints', 'own_vocabulary', 'says_more_than_shown', 'changes'],
}
const EDITS = {
  type: 'object',
  properties: {
    edits: { type: 'array', items: { type: 'object', properties: {
      file: { type: 'string', description: 'sheet | passages | paths | laid | module | template' },
      where: { type: 'string' }, old: { type: 'string', description: 'exact text now: a phrase that occurs exactly once in that file' }, new: { type: 'string' }, why: { type: 'string' },
    }, required: ['file', 'where', 'old', 'new', 'why'] } },
    checked: { type: 'array', items: { type: 'object', properties: { item: { type: 'string' }, verdict: { type: 'string', description: 'holds | corrected | cannot tell' }, against: { type: 'string' } }, required: ['item', 'verdict', 'against'] } },
    notes: { type: 'string' },
  },
  required: ['edits', 'checked', 'notes'],
}
phase('Cold')
const cold = agent(`You are a person who has never seen this work: educated, curious, not a specialist in any of it. Someone sent you a link to "the map". Read it the way such a person does: from the top, as long as it holds you, skipping what does not. Be honest about where you would stop.

Read only. Change no file, run nothing.

What you are sent, in the order a visitor meets it:
1. The page: ${KIT}/out/THE-MAP.md (it opens with a picture: ${KIT}/shots/k-lock.png shows that first path as the interactive page draws it, with its told steps on the right).
2. The whole map as the interactive page draws it: ${KIT}/shots/k-whole.png.
3. Another path: ${KIT}/shots/k-returns.png. A test laid on the map: ${KIT}/shots/k-season.png. The Chinese side: ${KIT}/shots/k-zh.png.
4. If you are still reading: ${KIT}/out/PATHS.md (every path and test in full) and ${KIT}/out/PLACES.md (every box and its arrows; long, dip into it).
Open the pictures with the Read tool: they are what a visitor sees.

The person who directs the work read an earlier version of its public face and gave it "probably just a 4" of 10. His complaints, in his words or close to them: (1) hard for a human to read; (2) no real map of the dynamics; (3) too many words; (4) too much AI vocabulary and vocabulary of its own; (5) the readings are unstructured, where he wants layers, an index and entry points, "something more like a Wikipedia"; (6) the concepts are still heavily dualistic (good and bad, right and wrong sides); (7) it does not feel very serious. Of the map that came after, he said: it is one map, not a set of maps; it must keep reasoning and situation apart and show where they meet, since one can be right while the other is wrong; and its words must not be only for persons. He read the first path of this version and said "Yes, go on". Your read is not a score and is not asked to be kind: say which of the seven still hold here, with the place that shows it.

Report: what you understood after two minutes, and after fifteen; where you would stop and why; whether the picture itself shows what happens or only the words beside it do; each of the seven complaints with whether it still holds and the evidence; words a newcomer would not know; anything that reads as claiming more than it shows; and at most eight changes, the most helpful first, each concrete (what, where, why) and sized.`, { label: 'cold:reader', phase: 'Cold', schema: COLD })

phase('Truth')
const truth = agent(`You are the second reader of text that was written fast this morning on a map that is about to land. In this work fast writing has repeatedly come out tidier than what it stands on: a condition dropped, a "not contradicted" turned into support, a number attached to the wrong thing. Find where that happened here and give the repair.

Read only. Change no file. Run no tests, builds or renders; small read-only scripts that print from JSON or count are fine.

The map's data: ${KIT}/data/sheet.json (rows, boxes; a box's known_en/known_zh are names others gave it, unlike_en what it is told apart from, known_src the sources), ${KIT}/data/passages.json (arrows: tag, sentence, laws, kind; and "stays"), ${KIT}/data/paths.json (paths told step by step), ${KIT}/data/laid.json (tests laid on the map). The tool that writes the pages: ${WT}/tools/research/map_sheet.py (file "module"); the page template: ${WT}/tools/research/map_sheet.html (file "template"). Rendered pages: ${KIT}/out/THE-MAP.md, PATHS.md, PLACES.md. The Lean: /Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/.

Check each of these, and say for each what you set it against:

1. The seven tests' lines: line_en and line_zh of every test in laid.json. Each is one to three sentences that the page shows first for that test. Set each against the test's own fields (what, said, seen, broke, pins) and, for every number and every "as the reasoning said / where the reasoning said", against the test's record. The records: for lake, judge, stocks, find them through TESTS.md at the repository root (/Users/ren/theories/TESTS.md; ids IN1, LA2, MQ3); for season, patch, harvest, checkedonce the record files are named in ${KIT}/short.log and in ${KIT}/fill-tests.json under tests[i].checked.notes. A line must not read stronger than the record, and must say what gave way (or that nothing did) as the test's "broke" field does.

2. Each path's "known" list in paths.json (shown on the page as "Close to what others call"). Each entry names a box ("at") and a short form. Set the short form against the full names at that box in sheet.json (known_en, known_zh) and their sources (known_src; the readings are in /Users/ren/theories/theories/becoming/results/atlas/entries/correspondences.json). Is the short form a fair shortening of a name that box carries? Does shortening make it claim more (for instance dropping "in its popular wording" or "in its generalised form" where that qualifier is what makes the name fit)? Is the Chinese the same name?

3. The page's opening paragraph: lead_en and lead_zh in sheet.json. Set it against the first path's steps and its "shows" lines in paths.json (path id lock) and the arrows they stand on. In particular: "can lock itself in where the rule is updated from its own picks", "in built examples loses what would have read the loss", "One way out is proved of the course itself: ...", "Every other way out drawn needs something given from outside."

4. The arrow b3.gone>b3.inside in passages.json: its sentence was amended this morning to add "provided what is used up never lowers the lead". Set the whole sentence, with "while the loss passes every bound" and "whatever the removed would have judged changes nothing", against the three Lean statements it names (PoolFromCourse.closed_stays_closed, window_locked_after_removal, window_removed_unregistered). Is each clause proved by one of them, under the premises the sentence gives?

5. The note on how far the map goes: the function _about in the module (English and Chinese), as rendered under "How far it goes" in THE-MAP.md. Set every count and every statement of who wrote and who checked what against ${KIT}/fill.log, ${KIT}/short.log, the "notes" in ${KIT}/fill-paths-names.json and ${KIT}/fill-tests.json, and the data. One thing to know: the short lines of item 1 and the lists of item 2 were written by the coordinating AI this morning and you are their first second reader; if the note does not say how they were made, propose the sentence that does.

6. The sentence on the whole-map panel of the template (search "Among the arrows drawn so far that run along a row"), English and Chinese: set it against the counts the module computes (function build, counts['along']): of arrows along a row outside the last band, right: 12 law, 3 needs, 2 built, 1 reading; left: 6 law, 12 needs, 2 built. Does "most that run right are laws of the course itself; most that run back need something given from outside the course, or are shown only in a built example" hold as worded?

Return each repair as an edit (file, where, the exact text now as a phrase that occurs exactly once in that file, the new text, why); a list of what you checked with a verdict each; and notes on anything you could not settle.`, { label: 'truth:what-changed', phase: 'Truth', schema: EDITS })
const [c, t] = await Promise.all([cold, truth])
log('cold: ' + (c ? c.changes.length + ' changes' : 'none') + '; truth: ' + (t ? t.edits.length + ' edits, ' + t.checked.length + ' checked' : 'none'))
return { cold: c, truth: t }
