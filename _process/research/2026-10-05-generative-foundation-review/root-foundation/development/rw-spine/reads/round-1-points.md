# Round 1: findings on LINEAGE's turning points and thread (points 1–50)

*AI readers' findings, 8 November 2026, condensed by the item's owner; to be applied by a fixer who is none of the readers. Row numbers are the table's (1–50, in date order); ids are lineage.json's.*

## Decisions taken (apply them)

- Remove point 47 `nov-runhold` (a hold on work, not a change in the account) and point 50 `nov-edition-5` (a packaging event; the papers table keeps the editions).
- Translation rule for the Chinese fields (`title.zh`, `what.zh`): where the source is Chinese, quote its own words in 「」; where the source is English, keep the English words in 「」 followed by a Chinese gloss in （）, as rows 2–7 already do. Never put a Chinese translation of an English source inside quotation marks as if it were the source's words. The same for the English fields: a Chinese source quoted in English gets its Chinese kept beside it, or is marked as a translation.
- AI-written sources are marked as such where quoted (as rows 23, 34, 47 already do).
- No person named, including in evidence locators: a locator that names a source heading such as "## Ren's words" or "Decisions pending Ren" is rewritten without the name (e.g. "the section of words kept", "the board's decisions section").
- Chinese terms: the account is 本说明 / 现行说明 (not 本论述, 现行论述, 本理论, 现行理论); capture is 捕获 (经由规则的捕获, 闭合的捕获); living significance is 存活之意义 (not 生生之意义); totalization is 总体化; the overview is 总览; release gate is one term (发布闸门).

## Medium (evidence reader)

1. Thread intro: "the conjecture" reads as T7's. The conjecture that failed is H1-LA2 (02-MAP line ~436: "it tests the conjecture that a judge formed from what it selected is a pool of readers counted by kind"). Fix: "And in one trained system, T7's frozen test of the conjecture that such a judge is a pool of readers counted by kind: 'Every frozen verdict passed, and the conjecture failed for this judge'." (and the zh)
2. Row 14 `s26-02-the-fork`: the quoted rule is the Fork README's paraphrase. The conversation's words are in tracked `_process/history/2026-09-consolidation/reading-notes-inputs/hb-02.md` line 3627 ("Make the global coordination work based on one rule, that is forcefully executed: stop using AI compete with others, only use them for commons"), offered as a compromise (line 3626 "we need to compromise a little bit"); the pasted projection at line 3608. Rewrite: "On 2026-02-09 a conversation takes up a pasted scenario projection, Automated Feudalism versus Automated Commons, 'The deciding variable is institutional design', asks for a narrative from it (called The Fork, not in the corpus), and, as a compromise, proposes to 'Make the global coordination work based on one rule, that is forcefully executed: stop using AI compete with others, only use them for commons'." Label public; evidence hb-02 lines 3608 and 3627 (under the heading at line 3482).
3. Row 15 `s26-04-fork-retired`: the criterion is the Fork README's summary; the 2026-04-16 turn (hb-02 line 7194) says "i am also not saying the cooperative use of it expresses the good … cooperative on the wrong thing could be why worse than just competing on it"; "degenerative" comes 2026-04-28; the 03-18 turn (hb-02 line 5097) is a correction that the Fork was never binary, "the actual possibility space that we can pursuit is huge"; "moved on from the fork narrative" is verbatim at hb-02 line 7190. Title: "The Fork narrative left; cooperation not good in itself." Text: "The two-outcome narrative is left: 'I think I have moved on from the fork narrative, it becomes simpler', after a correction of 2026-03-18 that the Fork was never a binary, 'the actual possibility space that we can pursuit is huge'. Cooperation is not held good in itself: 'cooperative on the wrong thing could be why worse than just competing on it'; the Fork folder reads this as the criterion of generative versus degenerative, words that come on 2026-04-28." Label public.
4. Row 19 `sel-2026-05-28-selection-on-cognition`: a condition dropped (source line 19: "If principals are selected for instrumental cognition by the dynamic above, then an AI that does what its principal intends is amplifying the dynamic"). Fix: "…and, if principals are selected for instrumental cognition, 'an AI that does what its principal intends is amplifying the dynamic, not checking it'."
5. Row 21 `s26-07-zhishan`: "to this document and to those who hold it up" is a translation shown as the source's words; the source (sources/06-zhishan/manifesto/drafts/draft-1.md line 51) is 这里说的每一条，都适用于这份文件，和举着它的人; the draft does not end on the test (line 71 is 让世界继续生成。). Fix: "…closes, before its last line, with one test, 它在开路，还是在据门？ (is it opening a road, or holding a gate?), and says 这里说的每一条，都适用于这份文件，和举着它的人 (everything said here applies to this document and to those who hold it up)."
6. Row 22 `s26-09-consolidation`: wider than MAP.md ("The fifteen are not fifteen theories, and they are not one either"; one mechanism plus "a small set of adjacent commitments that are not reducible to it, and a family of engineering systems"). Title: "Corpus gathered into theory folders; one mechanism found under four names." Text: "…and the map reads them as neither fifteen theories nor one: 'one diagnostic mechanism restated four times under successive names', beside commitments not reducible to it and engineering systems that write them in code."
7. Row 44 `nov-ue32`: "before any series was read" drops "by it" (README: "frozen … before any series was read by it"; DESIGN: "The test is not blind to MQ5's results"). Fix: "…and a test frozen before any series was read by it (it drew on MQ5's earlier in-sample fits of the same stocks)." Also zh.
8. Row 45 `nov-rf-frozen`: TR1–TR9's first stages frozen on 4 November, the Stage A of TR1, TR2 and TR7 on 5 November (experiments/README; FREEZE-9 to -11; the board: "What stayed a design is frozen too, on 5 November"). Fix: "…were frozen on 4 November 2026, not run, and what of them stayed a design, the Stage A of TR1, TR2 and TR7 among it, on 5 November; …".
9. Row 32 `sel-2026-10-19-capture-on-the-spine` and the thread intro: closed capture quoted without its hypothesis (closed-capture.md line 8: "In a selection whose rule, and how the rule is read, are read from the share it selects, a loss…"). Fix: "…proved with empty axiom reports: in a selection whose rule, and how the rule is read, are read from the share it selects, 'a loss the loop does not read leaves it locked however large it grows, and a change of the reading is absorbed'."
10. Rows 8, 9, 13, 19, 20 (and the 2025-05-18 report in row 11): AI-written sources quoted with no mark (meta-attractor README: "2024 precursors (… all AI-drafted …)"; the 05-18 report is "[AI research-tool output …]"; the 2025-08-10 definition an AI-written expansion "written against a system prompt"; row 19 "an AI-written working stance"; row 20 the English FOUNDATION files, "… ideas, not … prose"). E.g. row 8: "An AI-drafted note of that day treats the capitalist system as…"; row 19: "A working stance, AI-written from a conversation of that day, makes the sharper claim that…".

## Low (evidence reader)

- Row 2: "derives" too strong; "defines in sequence, from difference and change, structure, space, time, dynamic, possibility, thing and system".
- Row 4: repoint evidence 1 to hb-01 line 656 (the third conversation of that title, under the heading at line 652).
- Row 9: "after the request" implies an order; "The same day, in separate conversations, a name 'more creative, like moloch' is asked for, and a salon is planned around…".
- Row 11: title "Meta-attractor: it captures the mechanisms of selection themselves" (the naming is on 05-18, given in the row).
- Row 12: "A review kept as usis.md, under the same STS title, calls it the 'USIS model'…" ("the earlier version" is TIMELINE's reading).
- Row 13: "Under a zero-mean simplification the proxy weights grow as ẇ = λCw" (line 91); repoint evidence 2 to line 262 ("non-ideological target").
- Row 20: locator line 114, not 113.
- Row 24: MAP.md, tracked, quotes the transcript verbatim with timestamps; relabel public with MAP.md as evidence (rows 4–10 call tracked extracts public).
- Row 25: "committed two minutes before the pilot's log" (21:47:35 vs 21:49:40); title "The repository's first pre-specified predictions…".
- Row 27: "…which the record's AI interpretation reads, from 先, as 'the current name, not a final decision'. The same interpretation says: …".
- Row 28: "The Lean spine Becoming, begun that day, was made pure under the directive…" (d79d0d9d7 at 03:02, pure at 04:28, 1e66b6b91); zh too.
- Row 39: the T8 quote's gloss of 生生 is "[AI reading, D1]"; add "(the gloss of 生生 an AI reading, D1)".
- Row 43: "met but for the sending and the push" (WHAT-REMAINS: "Met but for the sending, …, and the push").
- Row 48: "The same day" is wrong (audit headed 6 November; LM landed 7 November); title "C no longer said to order alone; the Lean's duplicates cut".
- Row 49: "…the readers' flags corrected 26 live sentences at their homes, and nine more that 'gave ranking to C alone in other words'".
- Thread intro: "In May 2026 the system so selected concentrates 'not just resources but a way of seeing'."

## Chinese reader, on the points (LINEAGE.zh.md)

- H1: translations of English sources shown as the sources' words in rows 8, 11, 13, 19, 20, 22, 23, 25, 26, 32, 38, 40, 41, 44, 45, 47, 49; rows 14, 15, 24 put English words of a conversation as Chinese sentences never said ("I think I have moved on from the fork narrative, it becomes simpler"; "we have to work together, as a shared future of mankind…", sources/16-claude-code-directions/2026-10-02-paper-v3-spine-direction.md:15). Apply the translation rule above to every zh row.
- M1: row 30 "living significance" as 生生之意义; use 存活之意义 (overview line 144).
- M2: row 46 「不推翻 T2 在渔业中的成立」 presupposes T2 holds; use 「但并不因此在渔业中推翻 T2」.
- M7: capture as 俘获 in places; use 捕获.
- M12: row 44 「不可分」 for 'not separated' reads "inseparable"; use 「无从区分」.
- Low: row 2 「World of Possibilities（《可能性的世界》）」; row 27 add 「（今作生成变化之论）」; row 30's title adds 「而非权威」 not in the English; row 36 「一页与总览」; row 43 「许可一事当天定下：作品归于公共，有意不设许可」; one term for release gate; row 46 use the overview's 「水平自身的历史所及」; the account rendered six ways (use 本说明 / 现行说明); row titles end in 。 not . (the generator now adds 。).

## English reader, on these rows

- Names in locators: rows at LINEAGE.md lines 61, 64, 72, 78 print source headings "## Ren's words", "## Ren's message", "Decisions pending Ren". Rewrite those locators without the name.
- Thread intro: "the selection concentrates" → "the system … concentrates" (taken in finding above).
