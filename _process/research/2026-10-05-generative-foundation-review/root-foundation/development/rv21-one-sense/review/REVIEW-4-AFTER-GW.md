# The fourth review round: item 13 after GW1, GW2 and GW6 landed

Three Opus lenses (senses, substance, records and formal) read, read-only, the combined state: main at 24a17f202 (GW landed) with item 13's kit and the question's kit applied, before render and re-point. An adversarial verifier per lens tried to refute each finding (keep, revise or reject). How each was taken is in [NOTE §7](../NOTE.md#7-the-fourth-round-after-gw1-gw2-and-gw6-landed). Links inside quoted fixes are rebased to this folder; the fixes are quoted as proposed, not applied here.

## Lens: senses

### S1 (should; owner item13; verdict keep; taken)

`theories/becoming/chapters/01-ROOT.md`, line 151.

**Finding.** In D1 the word "generation" now appears five times in two senses, and nothing in 01 §6 marks the switch. The first two (the gloss) mean 生发. The next three are 02's 生成: "generation at two orders", "keeping widening is generation under the one", and the 01 §6 sentence's own "generation". GW's added sentence ties 生生 directly to "generation under the one that loses nothing", so a reader will take the gloss's "continuing generation" for that same generation. Worse, "generation generating generation" reads naturally as 02's generation at two orders, which the next sentence says does not give 生生. The only place this is marked is the glossary and 08's row, not the passage itself. So a reader cannot tell the senses apart here.

**Fix proposed.** Replace

> continuing generation, generation generating generation: what forms

with

> continuing generation, generation generating generation (生发, not 02's 生成): what forms

**Verifier.** Confirmed at 01-ROOT.md:151. Before GW, round 3 (R3) chose to mark the gloss only in the glossary and 08. GW then added a sentence to this same paragraph that ties 生生, read as widening, to 02's generation (keeping widening is generation under the one, and what 生生 asks, read as widening, is that). With that sentence there, a reader takes the unmarked "continuing generation, generation generating generation" to be the same 生成. "Generation generating generation" also reads naturally as 02's generation at two orders, which the next sentence says does not give 生生. This does not re-gloss anything, so rounds 1-3's decision stands; the mark is only placed where GW put 02's sense beside the gloss. It agrees with 08's row and the glossary rows, which already say that the gloss in 01 §6 and 07 §2 means 生发. The fix string occurs exactly once. 01 §6 is already in repoint_os.py's EXPECTED, so no new re-point section is needed.

### S2 (should; owner both; verdict keep; given to GW's owner)

`theories/becoming/chapters/01-ROOT.md`, line 151.

**Finding.** GW's sentence uses "renewal" for carrying renewal, in the section that defines renewal (复生) as a beginning whose line has a successor, "so the new line is not a flash" (Lean «复生» requires «有后»). On the course's moments under the same possible, a line begins wherever a step changes what is held. On GW's own witness Steps.Growing (growing n = {x < n}), which keeps widening and is 全生成, what is held changes at every step. So every begun line is a flash and there is no 复生 at all. In 01 §6's sense the sentence says something the Lean does not give. Its contrast with "renewal of lines" (which is 复生) also invites reading both as one sense. 07 §2's reading of the same result says "generation of the possible that loses none of it".

**Fix proposed.** Replace

> is renewal of what can form that loses none of it

with

> is generation of what can form that loses none of it

**Verifier.** Confirmed in the Lean. «复生» needs «有后» (Grammar.lean:146), while «传» needs only «生» (GrammarMap.lean:54). On GW's own witness, Steps.growing n = {x < n} (WideningOnTheMap.lean:328), what is held changes at every step. So under `same growing` each begun line is a flash, and nothing renews in 01 §6's sense, nor in its coarse sense. GW's "renewal of what can form" therefore uses "renewal" in a third sense (carrying renewal), in the home section of 复生. Read in the glossary's sense, the sentence is false of the theorem's own witness. The replacement is the exact form of Steps.keepsWidening_iff_generation_losing_nothing and matches 07 §2's "generation of the possible that loses none of it". The sentence is GW's, so tell GW's owner. Item 13's kit already rewrites this paragraph and can carry the change with the owner's agreement. The fix string occurs exactly once.

### S3 (should; owner item13; verdict keep; taken)

`theories/becoming/chapters/07-SIGNIFICANCE.md`, line 74.

**Finding.** This is the home of the glossary's new 生生 row, and the glossary's generation row points here ("(07 §2) says 生发"). The home section itself writes the gloss unmarked, both "continuing generation" and "read as generation generating generation". GW's landing added to the same §2 "So 生生 read as widening is generation of the possible that loses none of it", where generation is the map's 生成. Item 13's causal-set reading in the same section also says "the 生生 meant is generation generating generation". So in one section 生生 is glossed by "generation" in the 生发 sense and, read as widening, identified with "generation" in the 生成 sense, and nothing in the section tells the reader which is which.

**Fix proposed.** Replace

> names life in the whole and its continuing generation. Widening compares it

with

> names life in the whole and its continuing generation (生发, not 02's 生成). Widening compares it

**Verifier.** Confirmed at 07-SIGNIFICANCE.md:74. Item 13 makes 07 §2 (#order) the home of the new 生生 glossary row, and that row writes "continuing generation (生发)". The glossary's generation row also points here for the 生发 gloss. Yet the home sentence itself is unmarked, and GW's §2 reading (line 107) now says "So 生生 read as widening is generation of the possible that loses none of it", in 02's sense. With the mark at the home, the section's two uses read apart: 生生 is 生发, and read as widening it is 02's generation losing nothing. This is not a re-gloss. Item 13 owns 07 §2's readings. The fix string occurs exactly once, and 07 §2 is already in EXPECTED.

### S4 (optional; owner gw; verdict keep; given to GW's owner)

`theories/becoming/chapters/07-SIGNIFICANCE.md`, line 107.

**Finding.** GW's reading makes the same slip as in 01 §6. The admitted range "is renewed" is neither of the glossary's two senses of renewal: not 复生, since on Steps.Growing every begun line of the held possible is a flash, and not 02's renewal of what a formation draws on. What the theorem gives is that the range goes on through carrying renewal (全生成 under the one).

**Fix proposed.** Replace

> and the admitted range is renewed

with

> and the admitted range goes on through carrying renewal

**Verifier.** This is the same slip as S2, in GW's 07 §2 reading at line 107. The admitted range "is renewed" fits neither of the glossary's senses of renewal: it is not 复生, which fails on Steps.Growing, and not 02's renewal of what a formation draws on. What 全生成 at (nothing lost, the same possible) gives is that the range goes on, under nothing lost, through carrying renewal, which is the map's definition of generation. Optional: tell GW's owner. Item 13 does not touch this sentence. The fix string occurs exactly once.

### S5 (should; owner gw; verdict keep; given to GW's owner)

`theories/becoming/THE-THEORY-OF-BECOMING.zh.md`, line 62.

**Finding.** GW rewrote the English overview §2 to say that keeping widening is the map's generation under the one that loses nothing. The Chinese edition still says that no law yet relates the map's 生成 to widening what can form. That is now false, and the two editions contradict each other on exactly the 生成–widening–生生 relation that item 13's §1 edit sits beside.

**Fix proposed.** Replace

> 它不是生生，它从不与退化重叠，也还没有任何律把它与扩大可形成者联系起来［AI 读法］。

with

> 它不是生生，它从不与退化重叠［AI 读法］。在一个进程的诸时刻上读，在判定的前提下，持续扩大就是地图在“一”之下不失任何东西的生成；生成容许损失，分开二者的恰是损失（[07 §2](../../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-keeping-widening-is-generation-losing-nothing)）。

**Verifier.** Confirmed. GW removed "no law yet relates it to widening what can form" from the English overview §2 and added the keeping-widening sentence. The Chinese edition (line 62) still states the removed claim, which is now false, and it sits beside item 13's §1 edit. The wording follows the record's Chinese (持续扩大, 进程诸时刻, 不失, 判定之前提). 进程 is the edition's own word for course (line 154), and “一” is 06's. Tell GW's owner. The same staleness is in the Chinese open list at line 235: "地图的三个“某一分支”区域的覆盖，以及一条把其生成与扩大联系起来的律" (exactly once) should follow GW's English ("Keeping widening along a continuation other than by name, read as generation on a course's moments"), for example "按名以外之延续上的持续扩大，读作进程诸时刻上的生成". If item 13's kit carries these lines, 'THE-THEORY-OF-BECOMING.zh.md' needs '2. 生成、守与退化' (and the open-questions section) added to repoint_os.py's EXPECTED.

### S6 (should; owner gw; verdict revise; given to GW's owner)

`theories/becoming/THE-THEORY-OF-BECOMING.zh.md`, line 60.

**Finding.** The Chinese §2 still says that coverage by the three some-branch regions is open. GW's English now says that with excluded middle, and keeping read from some point on (后守), every point lies in one of the three regions, and that telling 后守 is deciding whether a line stops renewing. The open list at line 235 likewise still lists "地图的三个“某一分支”区域的覆盖，以及一条把其生成与扩大联系起来的律", where the English now reads "Keeping widening along a continuation other than by name, read as generation on a course's moments". Related: ONE-PAGE.md and ONE-PAGE.zh.md still say only that every course falling in one of the three is not shown. With strict 守, GW's Map.Once now refutes that at its start, and with 后守 it is shown.

**Fix proposed.** Replace

> 这三种形式彼此排除。三个“某一分支”区域是否覆盖每一点，未决

with

> 这三种形式彼此排除；把守读作自某一点起之守（后守），每一点也落在三个“某一分支”区域之一中；判定一条相续是否自某一点起守，就是判定它是否不再有传

**Verifier.** This one is real but off the senses lens: it is a coverage claim, made stale by GW's landing. The Chinese §2 (line 60) still says coverage by the three some-branch regions is open. GW's English and Lean now give two things: with strict 守, the line in Map.Once that renews once and then stays is none of the three at its start; and with 后守 and excluded middle, every point is 生成, 后守 or 退化 («三域之周»). So "未决" is stale. ONE-PAGE.md and ONE-PAGE.zh.md ("every course falls in one of the three is not shown" / "尚未证明") are stale in the same way. Tell GW's owner. The finder's fix is right in substance. Revised only to the edition's modern register (的, not 之).

**Revised fix.** Replace

> 这三种形式彼此排除。三个“某一分支”区域是否覆盖每一点，未决

with

> 这三种形式彼此排除；把守读作自某一点起的守（后守），每一点也落在三个“某一分支”区域之一中；判定一条相续是否自某一点起守，就是判定它是否不再有传

### What the verifier found the finder missed

1. GLOSSARY.md:31 (the generation row, as item 13's kit leaves it; optional). Item 13 put its 生发 clause between \"it is not 生生\" and the colon clause. The colon clause's \"it\" (\"it can go on at two orders while what can form only returns\") can now be read as 生生 or as its gloss, not as generation. That would say of 生生 what is true only of 生成. Exact fix (the old string occurs once): old `and it is not 生生, whose English gloss "continuing generation" (07 §2) says 生发, not this sense: it can go on at two orders while what can form only returns.` → new `and it is not 生生: it can go on at two orders while what can form only returns. The English gloss of 生生, "continuing generation" (07 §2), says 生发, not this sense.`

2. Item 13's NOTE §3 says the review packet \"already keeps the senses apart\". But theories/becoming/review/CLASSICAL-TEXTS.md (C-13) writes \"理论之“生生”指整体中的生命及其继续生成\": the same 生成 gloss that item 13 replaces in 06 §二, and its 用途 points to 06 §二. The packet is pinned to version 3f294b01c, so this is its owner's call. Either narrow the NOTE's claim, or, with the packet's owner, replace \"理论之“生生”指整体中的生命及其继续生成\" (it occurs once) with \"理论之“生生”指整体中的生命及其持续的生发\". This problem predates both items; it is reported only because the NOTE's claim is item 13's.

### What the finder checked

I read both diffs (GW's landed texts; item 13 and upw on top of GW) and NOTE.md, with its three review rounds. In the combined worktree I read: the glossary rows (renewal/«生生», carrying renewal, generation/keeping/degeneration, 02's renewal, 理, 生生); 01 §4 (the new core-and-理 paragraph and the theorem after it); 01 §6 (definition, theorem, D1); 02 Bases, the §1 «生生» row, GW's §1 theorem and D65 reading, and the Open list; 07 §2 ("What widening counts", the eventual-widening reading GW edited, GW's new theorem and reading, the causal-set reading item 13 edited) and the upw item; 08's naming row and its warrant item; the overview §§1, 2 and 7 in both editions; both ONE-PAGE editions; 06 §二, §三, §八, §十 and the glossary-senses reading; COLLECTIVE-DIRECTION's witness; and the 生生 fields of the records both items touch. In the Lean (Grammar, GrammarMap, WideningOnTheMap) I checked that «传» needs only «生» while «复生» needs «有后», and that Steps.Growing changes at every step, so its fine lines are flashes. Consistent: «生生» is written with guillemets wherever it is the grammar's word, in texts and record Chinese, and plain 生生 is the ethics' sense everywhere I read (including GW's 02 D65, the overview §2 \"It is not 生生\", and GW's records). 02's §1 row, 06 §二/§三/§十, and the zh overview §1 and ONE-PAGE.zh (持续的生发) are correct. GW's new record uses no 生生. 01 §4's 理 paragraph and the glossary's 理 row agree with each other and with 03 (06's \"建模结构与变化之律\" mirrors 03's own wording), and GW uses neither 理 nor core, so there is no clash there. 08's row and the glossary's generation row agree. On the gloss: GW's landing does not make \"continuing generation\" (生发) untenable. GW's result is first-order (keeping widening is 02's generation of the possible that loses nothing), and 07 §2 still reads generation generating generation as possibly exceeding widening. So rounds 1–3's decision holds. Only the in-place 生发 marks in 01 §6 and at the 07 §2 home are needed, and in 01 §6 the senses currently cannot be told apart. Not reported: the pre-existing record Chinese writing 理 for the core (continuation-relative-to-a-class's statement, a-regularity-kept-and-changed), which the 理 row's \"elsewhere their 理 is the core\" acknowledges as residue, and the overview's \"further generation\" (§7), which neither item touches.

## Lens: substance

### S1 (should; owner item13; verdict keep; taken, in GW's wording ("generation of the possible"))

`GLOSSARY.md`, line 64.

**Finding.** The new 生生 row lists 02's generation flatly among what 生生 is not. The row's own home, 07 §2, now has GW's reading: "So 生生 read as widening is generation of the possible that loses none of it, and the generation of a part's lines, which 02 reads, is not it." Read as it stands, the row denies GW's link. Nothing else in the glossary connects 生生 to keeping widening read as generation that loses nothing: the generation row states the law but never names 生生.

**Fix proposed.** Replace

> Neither the grammar's `«生生»` (renewal without end), nor 02's generation (生成), nor any new organization

with

> Neither the grammar's `«生生»` (renewal without end), nor 02's generation (生成) as such, which allows loss, nor any new organization; read as widening, on a course's moments and under premises of deciding, it is generation of what can form that loses none of it, not the generation of a part's lines [AI reading, D45] ([07 §2](../../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-keeping-widening-is-generation-losing-nothing))

**Verifier.** Confirmed. In the combined state, 07 §2's GW reading (line 107) says '生生 read as widening is generation of the possible that loses none of it'. The new 生生 row in GLOSSARY.md (line 64) is the row that defines the word, and it lists 02's generation (生成) flatly among what 生生 is not. Nothing in that row states the link. The generation row (line 31) states the law but never ties it to 生生. As an identity of senses the negation is true, because Steps.Moving shows that generation as such allows loss. As written, though, the row reads as denying GW's link. The fix keeps the negation exact ('as such, which allows loss', 'not the generation of a part's lines'), states the link with GW's premises and its D45 label, and points to the anchor, which exists at 07 line 104. fix_old occurs exactly once in GLOSSARY.md.

### S2 (should; owner both; verdict keep; given to GW's owner)

`theories/becoming/chapters/01-ROOT.md`, line 151.

**Finding.** GW's closing clause in reading D1 says that 生生 read as widening is "renewal of what can form". 01 §6, the home of renewal (复生), defines renewal three paragraphs above: a beginning whose line has a successor, so the new line is not a flash. The glossary row that item 13 rewrites keeps that one sense. GW's own witness Steps.Growing (held(n) = {k | k < n}) keeps widening and is 全生成 at (nothing lost, the same possible) (Steps.Growing.generation). Yet every step changes what is held, so no moment has a successor under the same possible. Under nothing lost nothing begins after moment 0, and under the one there is no renewal («一之下无复生»). Growing therefore has no 复生 at any grain GW reads, and in the paragraph's own sense the clause is false. The law and 07 §2's reading say "generation of the possible". The word also blurs the contrast D1 exists to draw, between the grammar's renewal (`«生生»`) and plain 生生.

**Fix proposed.** Replace

> is renewal of what can form that loses none of it

with

> is generation of what can form that loses none of it

**Verifier.** Confirmed against the Lean. «复生» R E x needs some y with R x y, «生» R E y and «有后» R E y, that is, a begun line that goes on. 01 §6 defines renewal the same way, 'so the new line is not a flash'. On Steps.growing (x < n) every step changes what is held, so each line under Steps.same is a flash. Under Steps.includes nothing begins after 0, and under the one there is no renewal («一之下无复生»). So the Growing witness, which keeps widening, has no 复生 at any grain GW reads. What GW proves is 全生成, whose «传» lets the fine line be a flash. The clause sets 'renewal of what can form' against 'renewal of lines' (the grammar's renewal) in the very paragraph whose point is to keep `«生生»` apart from plain 生生, so the word clash is real. 'Generation' (02's 生成, here 全生成 under the one) matches GW's own first clause and 07 §2. The clause is GW's text, but item 13 edits this paragraph, so its kit can carry the one-word fix once GW's owner agrees. fix_old occurs once in 01-ROOT.md.

### S3 (optional; owner item13; verdict reject; not taken (rejected by its verifier))

`theories/becoming/chapters/08-METHOD.md`, line 112.

**Finding.** "Which generation at two orders does not give" stays true: on KindRelay, 全生成 at two orders holds while what can form by name only returns. But after GW the cell gives only the negative half. Read on a course's moments, under premises of deciding, 生生 read as widening is generation of what can form that loses none of it, and the generation of a part's lines is not it. In the method's table of words in one sense, the bare negation reads as if no link exists.

**Fix proposed.** Replace

> 生生 (07), which generation at two orders does not give, and whose

with

> 生生 (07), which generation at two orders does not give (read as widening, on a course's moments and under premises of deciding, it is generation of what can form that loses none of it, not the generation of a part's lines: [07 §2](../../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-keeping-widening-is-generation-losing-nothing)), and whose

**Verifier.** The finder concedes that the cell is still exactly true: generation at two orders does not give 生生 (KindRelay, by name). The cell sits in the 'Not' column of 08's words-in-one-sense table, which lists what 'generation' does not mean. Writing there what generation that loses nothing does give would put a positive statement of sense into a negative column, and the cell would grow long. The link belongs in the glossary (S1) and in 07 §2, which both carry it. The cell implies no 'no link'. This is a matter of taste.

### S4 (optional; owner gw; verdict keep; given to GW's owner)

`theories/becoming/chapters/07-SIGNIFICANCE.md`, line 107.

**Finding.** GW's reading writes "renewed" for what its law shows: on the moments, what is held keeps changing with nothing lost (generation under the one that loses nothing). In the glossary's senses this is neither 01 §6's renewal (a beginning whose line has a successor), which Steps.Growing lacks at every grain, nor 02's renewal (what a formation draws on is given back). This is the same slip as S2, in text item 13 does not touch.

**Fix proposed.** Replace

> and the admitted range is renewed

with

> and the admitted range keeps changing with nothing of it lost

**Verifier.** Tell GW's owner; optional. In 07 §2's GW reading, plain 'renewed' fits neither glossary sense. It is not 01 §6's 复生, which Steps.Growing lacks at every grain. It is not 02's renewal either ('what it draws on is given back'), and in chapter 7 a bare 'renewing' would most naturally be read in 02's sense (for example 'a course renewing every condition'). The law gives only that the held range keeps changing with nothing lost: 全生成 at (nothing lost, the same possible). The replacement says exactly that. Item 13 does not touch this sentence. fix_old occurs once in 07-SIGNIFICANCE.md.

### S5 (should; owner gw; verdict keep; given to GW's owner)

`theories/becoming/THE-THEORY-OF-BECOMING.zh.md`, line 62.

**Finding.** The Chinese edition of the overview's §2 still says that no law yet relates the map's generation to widening. GW changed the English ("no law yet relates it to widening what can form" became the link, with its premises and "what parts the two is exactly loss") but not this edition, which item 13 lands beside its own §1 edit. As it stands, the sentence is false of the combined state.

**Fix proposed.** Replace

> 它不是生生，它从不与退化重叠，也还没有任何律把它与扩大可形成者联系起来［AI 读法］。

with

> 它不是生生，它从不与退化重叠［AI 读法］。读于一个进程的诸时刻、在判定的前提之下，持续扩大就是地图上在“一”之下不失任何东西的生成；生成容许损失，把二者分开的恰是损失（[07 §2](../../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-keeping-widening-is-generation-losing-nothing)）。

**Verifier.** Tell GW's owner. GW rewrote this sentence in the English overview §2 but not in the Chinese edition. The Chinese still says that no law yet relates the map's generation to widening, which is false once Steps.keepsWidening_iff_generation_losing_nothing has landed. Item 13 lands its §1 edit in the same file. The fix mirrors the English as GW landed it, premises included. fix_old occurs once.

### S6 (should; owner gw; verdict revise; given to GW's owner)

`theories/becoming/THE-THEORY-OF-BECOMING.zh.md`, line 60.

**Finding.** The Chinese overview's §2 still calls coverage by the three some-branch regions open. GW1 and GW2 settled it: «三域之周» gives coverage with keeping from some point on and excluded middle, and Map.Once shows that strict 守 leaves a gap. The English overview was updated; this edition was not.

**Fix proposed.** Replace

> 三个“某一分支”区域是否覆盖每一点，未决

with

> 把守读作自某点起之守，每一点也落在三个“某一分支”区域之一中；分辨一条相续是否自某点起而守，就是判定它此后是否不再有传

**Verifier.** Tell GW's owner. The Chinese overview §2 still says that coverage by the three some-branch regions is open. «三域之周» (with excluded middle) and Map.Once settled it, and the English was updated. The finder's fix opens a new sentence after '这三种形式彼此排除。', which leaves the excluded-middle hypothesis only implied by '也'. In the English, coverage with 后守 sits in the same sentence as 'With excluded middle as a hypothesis'. The revised fix keeps it in that sentence with a semicolon, so the hypothesis governs both. fix_old occurs once.

**Revised fix.** Replace

> 这三种形式彼此排除。三个“某一分支”区域是否覆盖每一点，未决

with

> 这三种形式彼此排除；把守读作自某点起之守，每一点也落在三个“某一分支”区域之一中。分辨一条相续是否自某点起而守，就是判定它此后是否不再有传

### S7 (should; owner gw; verdict keep; given to GW's owner)

`theories/becoming/THE-THEORY-OF-BECOMING.zh.md`, line 235.

**Finding.** The Chinese overview's Open list still names, as open particular laws, the coverage of the regions and a law relating generation to widening. GW landed both, and the English Open item now reads "Keeping widening along a continuation other than by name, read as generation on a course's moments".

**Fix proposed.** Replace

> 地图的三个“某一分支”区域的覆盖，以及一条把其生成与扩大联系起来的律

with

> 沿按名以外的接续之持续扩大，读作一个进程诸时刻上的生成

**Verifier.** Tell GW's owner. The Chinese overview's Open list still names coverage and a law relating generation to widening as open. GW landed both, and the English Open item was rewritten. The fix mirrors the English. fix_old occurs once.

### S8 (should; owner gw; verdict keep; given to GW's owner)

`theories/becoming/ONE-PAGE.md`, line 9.

**Finding.** Since GW1 and GW2 this understates the result. For generate, keep (go on with no renewal) and degenerate as this page defines them, Map.Once is a counterexample: a line that renews once and then stays is none of the three at its start. With keeping read from some point on and excluded middle, every point is in one of the three («三域之周»). 02's thesis and the English overview now say so, but GW did not update the one page.

**Fix proposed.** Replace

> that every course falls in one of the three is not shown

with

> a line that renews once and then stays is none of the three at its start (a witness), and with keeping read from some point on and excluded middle as a hypothesis every point lies in one of the three

**Verifier.** Tell GW's owner. With 守 as this page defines it ('go on with none'), Map.Once (renews once, then stays) is none of the three at its start, so 'every course falls in one of the three' is now refuted, not merely 'not shown'. With 后守 and excluded middle, «三域之周» covers every point. 02 and the English overview say so, and GW did not update the one page. The fix states the witness and the hypothesis as 02's table does. fix_old occurs once.

### S9 (should; owner gw; verdict keep; given to GW's owner)

`theories/becoming/ONE-PAGE.zh.md`, line 9.

**Finding.** S8's stale coverage sentence, in the Chinese edition. Item 13 edits this file (line 7), and this sentence is GW's to update.

**Fix proposed.** Replace

> 每一个进程是否都落在三者之一，尚未证明

with

> 一条只更新一次而后不变的相续，在其起点不落在三者任何一个之中（一个见证）；把守读作自某点起之守，以排中律为假设，每一点都落在三者之一

**Verifier.** Tell GW's owner. This is S8's stale sentence in the Chinese edition, which item 13 edits at line 7 but not at this sentence. The fix mirrors S8, uses the page's own '更新' and keeps the hypothesis. fix_old occurs once.

### What the verifier found the finder missed

Nothing further. I re-checked whether GW's landing makes the gloss decision untenable ('continuing generation' marked 生发, not 02's 生成). It does not. GW links 02's generation only to 生生 read as widening, and only on a course's moments under premises of deciding. Both 07 §2 and the overview (line 162) keep the fuller sense, generation generating generation, which can exceed what widening counts, so the gloss is still a different and wider sense than 生成. With S1 and S2 applied, 01 §6 D1 uses 'generation' in the 生发 sense only inside the gloss, which the glossary and 08 already mark, and in the 生成 sense in GW's link. That is consistent with the rule. The two premises (the condition for scope, C for order) are named in the 生生 row and T8, and nothing in the combined state says the ethics derives from the condition. The universal-practical-warrant record and 07's and 08's open items do not bear on GW's result.

### What the finder checked

I read GW's text diff and item 13's and upw's diff in full. In the combined worktree I read GLOSSARY.md, 01 §4 and §6, 02 §1, 07 §1, §2 (including GW's theorem and reading), T8, the does-not-show list and the Open list, 08's table of words in one sense, both overviews, both one-page editions, the item 13 note (rounds 1 to 3), GW's note §§1 and 18, and the universal-practical-warrant record. Against the Lean I checked the definitions in Grammar.lean and GrammarMap.lean («复生», «生生», «传», «生成», «全生成»), Steps.next, Steps.same, Steps.includes, Steps.growing and Steps.moving in WideningOnTheMap.lean, and RaisedEveryOther.renews_without_end and .both in HeldPossible.lean.

Consistent:
- **GW's premises.** Every live statement of GW's link keeps "read on a course's moments, under premises of deciding": the glossary's generation row, the English overview §2, 02's D65 reading and Open item, the first sentence of 01's D1 addition, and 07 §2's two readings.
- **The two premises.** The glossary's 生生 row and T8 name both (the condition for scope, C for order). Nothing says the ethics derives from the condition, and 07 says it does not.
- **Item 13's other edits.** The guillemets in 01 §6, 02, 06 §三, 07's causal-set reading, the overview §1 in both languages and the records are right. COLLECTIVE-DIRECTION's citations match the Lean: renews_without_end at even moments, both giving ¬«息» at 0. The renewal rows, the 理 row and the 01 §4 paragraph are untouched by GW.
- **The 生发 gloss decision stays tenable.** GW's generation is of the possible on a course's moments, and 07 §2 says it is not the generation of a part's lines. 07 §2 also says that 生生, read as generation generating generation, can exceed what widening counts. So the gloss "continuing generation" (life's 生发) is still not 02's sense, and nothing needs re-glossing.
- **08's non-implication.** "Which generation at two orders does not give" remains true (KindRelay, by name). It only lacks the positive link (S3).
- **universal-practical-warrant.** The restated record and 07's and 08's open items do not bear on GW's landing and agree with each other, with 07 §1's "satisfiable" non-entailment and with T8. No finding there.

Not reported: the generation row's colon, which now follows the inserted gloss clause. It is a language point.

## Lens: records-formal

### F1 (should; owner gw; verdict revise; given to GW's owner)

`theories/becoming/results/records/generation-and-degeneration-at-two-grains.json`, line 129.

**Finding.** GW rewrote this record and left this clause in law 8 (laws index 7) unchanged. It is now false of the same record. Law 6 (index 5) proves that the strict regions do not cover (Map.Once.not_generates, not_keeps, not_degenerates) and that with 后守 and excluded middle they do («三域之周»). So the record contradicts itself. The Chinese of law 8 has the same clause: 某支诸域之覆盖未证.

**Fix proposed.** Replace

> coverage by the some-branch regions is not proved

with

> with strict keeping the some-branch regions do not cover, and with keeping from some point on and excluded middle they do (law 6)

**Verifier.** Real, and it belongs to GW. Before GW this was law 4 (index 3). GW moved it to index 7 and left it unchanged. In the same record, law 6 (index 5) now states the gap, with `Map.Once.not_generates`, `not_keeps` and `not_degenerates`, and coverage with 后守 under excluded middle (`«三域之周»`). GW also rewrote the record's statement and LOGIC.md to say "the some-branch regions do not cover". So the clause is stale and contradicts its own record. The en fix is exact: the string occurs once in the JSON. Law 6 is index 5, so "(law 6)" is right. The zh fix in the finder's rationale needs correcting. In "以后守与排中则周遍", 以后 reads as "afterwards". Use laws 7 zh: 某支诸域之覆盖未证 → 某支诸域以严格之守不周遍，以排中为前提、守读作后守则周遍（律 6）. This string also occurs once. Tell GW's owner. A law's content changes, so a history note is needed.

**Revised fix.** Replace

> coverage by the some-branch regions is not proved

with

> with strict keeping the some-branch regions do not cover, and with keeping from some point on and excluded middle they do (law 6)

### F2 (should; owner gw; verdict keep; given to GW's owner)

`theories/becoming/chapters/07-SIGNIFICANCE.md`, line 105.

**Finding.** GW's theorem paragraph in 07 §2 uses "the first law" for the first law of its own result, the iff at (nothing lost, the same possible). The glossary's "first law" is Flow.Gainless, and the paragraph just before (what-keeping-widening-needs) uses "under the first law" three times in that sense. A reader takes the sentence as a claim about Flow.Gainless. It also does not match the record, where the representation is law 2.

**Fix proposed.** Replace

> so the first law is a representation of keeping widening on the map

with

> so the law that follows is a representation of keeping widening on the map

**Verifier.** Confirmed. The glossary row 'first law' gives the term one sense, `Flow.Gainless`. The paragraph just before (07 line 85) uses "under the first law" in that sense twice. GW's own study note uses 'the first law' only for Gainless. In GW's theorem, 'the first law' has no antecedent. The record's representation is law 2, 'The representation, both ways'. So this is a sense clash GW introduced. The old string occurs once in 07. The replacement is minimal and points at the iff after the colon. Tell GW's owner.

### F3 (should; owner gw; verdict revise; given to GW's owner)

`theories/becoming/THE-THEORY-OF-BECOMING.zh.md`, line 60.

**Finding.** GW updated the English overview's §2: with keeping read from some point on, every point lies in one of the three regions, and telling 后守 is deciding whether a line stops renewing. The Chinese edition still says coverage is open (未决). After GW that is false: strict coverage is refuted (Map.Once), and coverage with 后守 is proved under excluded middle. The two editions now contradict each other.

**Fix proposed.** Replace

> 三个“某一分支”区域是否覆盖每一点，未决

with

> 把守读作自某点起之守（后守），每一点也落在三个“某一分支”区域之一中；分辨一条相续是否自某点起而守，就是判定它是否止于更新

**Verifier.** Real. GW's English §2 now says that with excluded middle, and keeping read from some point on, every point lies in one of the some-branch regions. The zh edition still says 未决, which after GW is false: strict coverage is refuted by `Map.Once`. The finder's fix starts a new sentence, which drops the excluded-middle premise; 也 only hints at it. The premise must be stated, since `«三域之周»` takes em and the calibration makes it exact. The old string occurs once. Tell GW's owner.

**Revised fix.** Replace

> 三个“某一分支”区域是否覆盖每一点，未决

with

> 以排中律为假设、把守读作自某点起之守（后守），每一点也落在三个“某一分支”区域之一中；分辨一条相续是否自某点起而守，就是判定它是否止于更新

### F4 (should; owner gw; verdict revise; given to GW's owner)

`theories/becoming/THE-THEORY-OF-BECOMING.zh.md`, line 62.

**Finding.** The Chinese edition's §2 still says no law yet relates the map's generation to widening. GW's English replaced that sentence with the landed result: on a course's moments, under premises of deciding, keeping widening is generation under the one that loses nothing, and what parts the two is exactly loss. The Chinese now contradicts the English and GW's new record.

**Fix proposed.** Replace

> 它不是生生，它从不与退化重叠，也还没有任何律把它与扩大可形成者联系起来［AI 读法］。

with

> 它不是生生，它从不与退化重叠［AI 读法］。在进程的诸时刻上读，在判定的前提下，持续扩大就是一之下不失的生成；生成容许失，分开二者的恰是失（[07 §2](../../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-keeping-widening-is-generation-losing-nothing)）。

**Verifier.** Real. The zh edition says no law yet relates the map's generation to widening. GW's English and its record now state such a law. Keeping the plain 生生 is correct by item 13's rule, since it is the ethics' sense. Two changes make the new sentence match the English, "the map's generation under the one": add 地图 so it is the map's 生成 and not the arising sense, and write the class as “一”, as the two-grains record's zh does (在“一”之下). Neither the zh overview nor its readers otherwise meet a bare 一之下. The old string occurs once. Tell GW's owner.

**Revised fix.** Replace

> 它不是生生，它从不与退化重叠，也还没有任何律把它与扩大可形成者联系起来［AI 读法］。

with

> 它不是生生，它从不与退化重叠［AI 读法］。在进程的诸时刻上读，在判定的前提下，持续扩大就是地图在“一”之下不失的生成；生成容许失，分开二者的恰是失（[07 §2](../../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-keeping-widening-is-generation-losing-nothing)）。

### F5 (should; owner gw; verdict keep; given to GW's owner)

`theories/becoming/THE-THEORY-OF-BECOMING.zh.md`, line 235.

**Finding.** The Chinese edition's list of open laws still names the regions' coverage and a law relating generation to widening. GW closed both and changed the English item to "Keeping widening along a continuation other than by name, read as generation on a course's moments".

**Fix proposed.** Replace

> 地图的三个“某一分支”区域的覆盖，以及一条把其生成与扩大联系起来的律；

with

> 按名以外的延续上的持续扩大，读作进程诸时刻上的生成；

**Verifier.** Confirmed. GW replaced this open item in the English overview with "Keeping widening along a continuation other than by name, read as generation on a course's moments", and in 02's open list. The zh still lists coverage and a generation–widening law as open. The fix mirrors the English. The old string occurs once. Tell GW's owner.

### F6 (optional; owner gw; verdict revise; given to GW's owner)

`theories/becoming/ONE-PAGE.zh.md`, line 9.

**Finding.** The one page's root paragraph says it is not yet proved whether every course falls in one of 生成, 守 and 退化. GW proved that a course which renews once and then stays falls in none of them at its start (Map.Once), and that with 后守 and excluded middle every point falls in one («三域之周»). "尚未证明" now understates a settled result. GW changed neither edition of the one page.

**Fix proposed.** Replace

> 每一个进程是否都落在三者之一，尚未证明

with

> 一个更新一次而后静止的进程，其起点不落在三者任一之中；以排中律为前提、把守读作自某点起之守，每一个进程都落在三者之一

**Verifier.** Optional, and GW's. Before GW, "尚未证明" matched the state of the theory: coverage was open, with only a hand counterexample. GW's `Map.Once` and `«三域之周»` settle it, so the front page now presents as open what is settled. The finder's fix needs one change. The next sentence reads "these are theorems for every relation and every class" (这些都是对一切关系、一切类成立的定理), and the `Map.Once` part is a single constructed model. Mark it as a witness (08's label convention) so that sentence does not cover it. The old string occurs once. Tell GW's owner.

**Revised fix.** Replace

> 每一个进程是否都落在三者之一，尚未证明

with

> 一个更新一次而后静止的进程，其起点不落在三者任一之中（一个见证）；以排中律为前提、把守读作自某点起之守，每一个进程都落在三者之一

### F7 (optional; owner gw; verdict revise; given to GW's owner)

`theories/becoming/ONE-PAGE.md`, line 9.

**Finding.** Same as F6 in the English one page. After GW, strict coverage is refuted by Map.Once, and coverage with keeping from some point on is proved under excluded middle. "Not shown" leaves out a landed result.

**Fix proposed.** Replace

> that every course falls in one of the three is not shown

with

> a course that renews once and then stays falls in none of the three at its start, and with excluded middle every course falls in one once keeping is read from some point on

**Verifier.** Same as F6, for the English one page. Mark the `Map.Once` part as a witness, because the next sentence says "These are theorems for every relation and every class". The old string occurs once. Optional. Tell GW's owner.

**Revised fix.** Replace

> that every course falls in one of the three is not shown

with

> a course that renews once and then stays falls in none of the three at its start (a witness), and with excluded middle every course falls in one once keeping is read from some point on

### F8 (optional; owner item13; verdict keep; taken)

`GLOSSARY.md`, line 31.

**Finding.** Item 13 inserted a relative clause about 生生's gloss before the colon. As a result, "it" in "it can go on at two orders while what can form only returns" most nearly refers to 生生 or its gloss, not to generation. Read that way, the sentence says the opposite of the KindRelay witness it cites: generation, not 生生, goes on at two orders while what can form only returns.

**Fix proposed.** Replace

> not this sense: it can go on at two orders

with

> not this sense: generation can go on at two orders

**Verifier.** Optional, and item 13's own text. The relative clause about 生生's gloss sits between the main subject and the colon. That lets "it can go on at two orders" attach to 生生, which would assert of 生生 what `KindRelay.Runs.generation_two_orders` shows of generation. Naming the subject costs one word and keeps the claim on generation, as 08's row does ("which generation at two orders does not give"). The old string occurs once in GLOSSARY.md.

### What the verifier found the finder missed

Two minor items, both GW's text. Neither blocks item 13.

(1) 02-MAP.md: GW's new theorem is labelled \"(root)\" and says \"For every carrier, relation and pair of classes\". Its table includes the `Map.Once` row, which is a constructed witness. 08's standing table labels such rows \"(…; witness)\", and 01 uses \"(root; witness)\". Exact fix, occurring once in theories/becoming/chapters/02-MAP.md:
\"**Theorem** (root). *The regions' coverage, and the split of a beginning.*\" → \"**Theorem** (root; witness). *The regions' coverage, and the split of a beginning.*\"
Tell GW's owner.

(2) 01-ROOT.md §6, the D1 Reading: GW's closing clause reads \"what 生生 asks beyond renewal of lines, read as widening, is renewal of what can form that loses none of it\". The Lean result (`Steps.keepsWwidening_iff_generation_losing_nothing`) and 07 §2's own reading say generation (全生成 at (nothing lost, the same possible)), not renewal (复生), which is weaker and in 01 has its own glossary sense. Exact fix, occurring once in theories/becoming/chapters/01-ROOT.md:
\"is renewal of what can form that loses none of it\" → \"is generation of what can form that loses none of it\"
Tell GW's owner. Item 13 edits the same paragraph, so it could carry the change if the owner agrees.

Checked with no problem found:
- None of GW's records or its Lean (MapRegions, WideningOnTheMap) introduces a plain 生生 in the grammar's sense, a 生生不息 standing for «生生», or 理/核 in another sense. The one \"the core\" in MapRegions means the pure core, as in other Lean docstrings.
- All 17 of item 13's record phrases are in place, with exactly one history note per record, and the note's law numbers match the indices. That includes law 12 at index 11 in the two-grains record.
- The 01 §4 paragraph on the core and 理 is accurate against GrammarLaws. `«有常定后则同行»`, `«同行遍后则有常»` with `«根»`, and `«核为类»` give exactly what it says.
- GW does not make the gloss \"continuing generation\" (生发) untenable. GW shows that 生生 read as widening is a loss-free special case of generation of the possible. That is consistent with \"generation is not 生生\" and with 08's row.

### What the finder checked

Everything below was read-only, in wt-chk (main at 24a17f202 with both kits applied). The only command that ran a kit was `one_sense.py --check`, which writes nothing; git status had the same 28 entries before and after.

(a) Records GW touched.
- GW changed 16 record files (git diff 7b24eb02a 24a17f202 --stat). In nine JSON records the changes are source-hash re-points only: capture-by-counted-choices, exit-from-a-margin, loss-read-in-time-by-the-others, readers-drawn-from-the-selected, rules-that-change-themselves-in-the-grammar, shaping-read-by-readers-drawn-from-the-selected, shaping-the-rule-selected-by-what-comes-back, what-keeping-widening-needs and where-the-possible-grows. The other changed files are the two rewritten records and the .md pages.
- The new record keeping-widening-is-generation-losing-nothing contains no 生生, 生生不息 or 理, in any field. 核心 appears only as "core leaf" and "core checker", meaning the pure core.
- In the rewritten generation-and-degeneration-at-two-grains, GW's new laws 4–7, the statement, the hypothesis, the new does-not-show item and the counterexample write no 生生 or 理. Law 12's Chinese is now «生生». Does-not-show item 1's plain 生生 is the ethics' sense. The plain 生生 in OU6's history note is history, which item 13's sweep excludes by design.
- A sweep of every bilingual non-history field of every record found no other plain 生生 standing for renewal without end. The remaining hits are Ren's quotation, readings of 生生不息 at the whole (D5), or the ethics' sense.

(b) Item 13's record phrases.
- All 17 RECORD_EDITS are applied once: old count 0, new count 1 in each field. The kit's --check passes in the combined state (21 edits, 17 phrases).
- Exactly one item-13 history note is in each of the six records.
- The notes' law numbers match the indices:
  - continuation-relative-to-a-class: laws 8 and 12 are indices 7 and 11; the third does-not-show item is index 2.
  - generation-and-degeneration-at-two-grains: law 12 is index 11. GW grew the record to 12 laws, so this law was law 8 before GW; NOTE §1 says so.
  - what-can-be-born-next: laws 22 and 23 are indices 21 and 22; the dependency detail is dependencies 3.
  - where-the-possible-grows: laws 13 and 24 are indices 12 and 23; the dependency detail is dependencies 5.
  - what-keeping-widening-needs: law 15 is index 14; the second does-not-show item is index 1.
- RaisedEveryOther.renews_without_end and .both state what COLLECTIVE-DIRECTION and law 24 now say.

(c) Lean.
- MapRegions.lean and WideningOnTheMap.lean name no declaration with 生生, 理 or 核. No docstring uses 理.
- MapRegions' header docstring once says "the core" for the pure core. That is a widespread, pre-existing convention in Lean docstrings, so it is not reported.
- Item 13's 01 §4 paragraph is accurate against the grammar. Checked:
  - «定后» is R˘;R ⊆ 静, in GrammarLaws.
  - «核为类» needs a class; «根» gives inside-E, constancy, and maximality.
  - «有常定后则同行» and «同行遍后则有常» hold with no class needed.
  - «守理则不穷», «守理之线不亡», «亡前理变» and the definition «足以定理» hold for every E; «有亡之线两端理异» and «合有常则足以定理» take classes.
  - The anchors #r-master-laws-on-the-grammar (01 §7 Lumping) and 03#li exist.
  - CoreAndLi.lean imports only the unchanged GrammarLaws, its log has four empty axiom reports, and its witness is right: the core of 静 under branching is 静.

The gloss "continuing generation" (生发): GW does not make it untenable.
- GW's own 07 reading separates "generation of the possible" on a course's moments from "the generation of a part's lines, which 02 reads".
- That 生生, read as widening, is generation that loses nothing is a theorem about one reading, under premises of deciding. It is not the gloss's sense, which 01 §6 defines as preserving, restoring, transmitting or creating the conditions and generators of further forming.
- 08's row ("which generation at two orders does not give") stays true (KindRelay).
- The glossary's 生生 row ("Neither … nor 02's generation") is consistent with GW: generation allows loss.
- No re-gloss is needed.
