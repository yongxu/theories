# Round 1: findings on LINEAGE's renames (R1–R38) and papers (P1–P18)

*AI readers' findings, 8 November 2026, condensed by the item's owner; to be applied by a fixer who is none of the readers. Rename ids R1–R38 are lineage.json's `renames[].id`; papers P1–P18 are the table's order (lineage.json `papers`, in order).*

## Decisions taken (apply them)

- A rename is a term replaced by another for the same thing. Remove: R4 (meta-attractor is a successor, wider concept), R5 (CAOC is a new acronym; the drives keep their name), R13, R15 and R19 (titles changed with their content), R14 (molochlization is a coinage; turning point 24 covers it), R18 (its own text says a successor draft, not a retitle), R35 (a narrowing of the goal), R38 (one word split into three senses).
- Merge R7 and R11 into one row, meta-attractor → totalizing attractor / 总体化吸引子, dated 2026-01 → 2026-07 (a tracked January 2026 talk transcript already has "totalizing attractors", line 149; the Chinese 总体化吸引子 by July), with its evidence and label.
- Remove P13 (Guardian Anarchy): its draft's own README asks not to push, upload or deploy it further; the page does not feature it.
- Translation rule for the zh fields: Chinese sources quoted in their own words in 「」; English sources kept in English in 「」 with a Chinese gloss in （）, never a Chinese translation inside quotation marks as the source's words. Chinese terms: capture 捕获; totalization 总体化; the account 本说明 / 现行说明.
- No person named in any field.

## Renames (reader of renames and papers)

- High, R2 (competitive convergence → Ouroboros): "only the chat export's automatic conversation title" is false. In `_process/history/2026-09-consolidation/reading-notes-inputs/hb-02.md` line 119 a turn ends "how should we name this process? how about competitive convergence? is there any better name?", then "can you come up with something more creative, like moloch". Fix: the earlier name was proposed as a candidate, a better name asked for, then one "like moloch"; Ouroboros titles the same day's later conversations; "rejected as dull" is TIMELINE's reading. Evidence hb-02 lines 119 and 123; label public; say the earlier term was a candidate, never adopted.
- Medium, R8 (destructive → degenerative): label public; hb-02 lines 8193 and 8197 hold both turns ("When I said destruction, I just didn't have a better word, what I mean is more like the opposite of generative, maybe degenerative?"). Cite line 8197.
- Medium, R10 (expanding the possibility space → 开): the turn is verbatim in tracked hb-03.md lines 4437–4441 ("它可能比'扩张可能性空间'更稳。因为'扩张可能性空间'听起来像可以被测量、最大化、优化"); those words are the assistant's (out-hb-03.md #105: "[imported from another model, adopted …]"). Label public, cite hb-03, say the reason was a model's, adopted.
- Medium, R9 (SST → 間): the cited note describes subsumption (section VIII "SST 如何被含括"; "间不只能含括 SST,且更精确"); only TIMELINE line 151, quoting a private chat, says 改名. Either say 間 subsumes the three primitives (label public), or cite TIMELINE 151 for 改名 and label private.
- Medium, R27 (registration → coupling): only 43 of the 175 renamed declarations go from a registration name to a coupling name. Fix: "Web.Registers → Web.CoupledInto, among 175 declarations renamed off the registration vocabulary".
- Low, R1: "the unit of the psychological account" is TIMELINE's phrase; say "the essay's word self".
- Low, R3: TIMELINE reads it as a change of claim ("The unit moves from the individual to the collective"); note TIMELINE's reading.
- Low, R6 (USIS → STS): both files carry the same date; that USIS came first is TIMELINE's line 101; say so.
- Low, R23: the record's current title is "Selection through a map of the alternatives"; say the rename came with a reframed claim, and give the current title.
- Low, R36: name the record by its current id `shared-laws-on-the-grammar`.
- Low, R37: "the record's id keeps the older word": that word is "generation" (id `generation-is-replenishment`), not "Arising".
- Holding: R12, R16, R17, R20–R22, R24–R26, R28–R34.
- Chinese reader: R7's 「在同月」 and R17's 「失败的是竞赛」 say more than the English rows (both supported by the sources): align the two languages. R24 「生生之意义」 → 「存活之意义」. Renames 2026-05-02 zh adds 「只」; the USIS row puts 「重排以把主体放在首位」 in quotation marks though the English has none.

## Papers (reader of renames and papers)

- High, P5 (OCASC mission): 提交 here is a git commit. Fix: "v0.2 was committed unchanged before v0.3 began (commit 79f0261)."
- Medium, P2 (zhishan foundation): quote the crosswalk's words ("the account only states conditionally or not at all"), not "does not"; "superseded the next day" is unsupported: "followed the same afternoon by the whitepaper (v0.1 16:57; v1.1 on 6 September)". Low: "What it claimed" gives the draft's purpose, not its stance; the stance is line 15: "人的尊严、幸福与参与未来的资格，不应取决于人能否在效率和能力的竞争中胜过机器".
- Medium, P8 (IASEAI line): the v2 quote is reviewer R5's wording as quoted in NOTES.md line 13; quote v2's abstract ("We ask when selection itself favors practices that acquire control over later selection"); the v3.1 words are from the drafter's NOTES-v3.md line 103: attribute them to "the v3 notes".
- Medium, P10 (OCASC review): "another organization's" is misleading; "a review of the 32-page second draft of an OCASC Research Review paper on AI 2040's Plan A".
- Low, P6: `立场与使命-v0.3.md`'s header reads "Sep 26, 2026", the notes date v0.3 2026-09-27; say the date comes from the notes, or note both.
- Low, P14: "lightly edited, not verbatim" comes from translation-notes.md line 7, not the README.
- Holding: P1, P3, P4, P6 (but the date), P7, P9, P11, P12, P15–P18.
- Chinese reader: P4 (zh line 146) 「下文的日期与制度安排是拟议的故事元素。」, P7, P8, P9 (「因此这一版是对整个理论的一次新的英文陈述…」) translations shown as quotations: apply the translation rule. P12 (No Safe Way to Win): use the talk's own Chinese (`drafts/2026-10-04-no-safe-way-to-win/TALK.zh.md` lines 11, 13, 17: 「我们得先赢，然后才能安全」, 「没有办法安全地赢」, 「这场演讲本身就是一次对齐的尝试。对齐的不是模型，是我们自己」). Capture 捕获 (not 俘获) in P1, P7, P12; 总体化 (not 全体化) in P9; P17's zh adds 「而非假定」 not in the English.
