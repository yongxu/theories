# Review of PLAN.md v6: classical-text fidelity (Claude Opus 5.5 subagent, read-only)

23 October 2026. Brief: [BRIEF.md](BRIEF.md), with the classical-Chinese angle. Every quotation was checked against the repository texts except two (论语 "殷因於夏禮" and the attribution of "体用不二" to 熊十力, from memory). Text as returned.

---

**Verdict.** The classical side of the plan is not yet fully monist. Version 6 says the texts lead, but the formal root in §四 (`Way`, `becomes`, `theorem one`) is fixed before step 0 and the quotations are then fitted to it. The plan cuts the texts' chains where they turn hierarchical, evaluative or 气-based, and keeps the parts that match the old theory. In several key places it reads the texts against both the passages themselves and the commentators it names. Its name table brings back rank (等第), a hidden layer (a continuous 化 behind the discrete 变; 器 as "层"), a valued split of open against closed, and a one-way 相因. One quotation is from the wrong edition. The corpus holds stronger monist warrants than the plan uses, so the fix is to let those lead.

**Findings, most serious first**

1. **§2.3: "基底的"变"（一跳）就是化之裁，即离散这一承诺本身在古文中有名"** (*hidden layer*, *textual error*). 孔疏 reads 裁 as mutual moderation, not cutting into steps: "陰陽變化而相裁節之，謂之變也……陰陽之化，自然相裁". 朱熹 reads it as a human act: "因其自然之化而裁制之……此章以人言". Read the plan's way, a continuous 化 with no formal counterpart sits behind the base and something cuts it: a reality-against-representation split at the root. Separately, "一阖一辟谓之变" defines 变 as a two-phase alternation, not a single step. Fix: keep discreteness as a disclosed commitment, not "named in the text"; let 大化 be the whole relation and 化 any stretch of it; name the one-step primitive with a word the corpus leaves undefined, such as 之 ("各指其所之") or 往; define 变 := a 阖 followed by a 辟, and 通 := 往来不穷.

2. **§4.6: 物 = "有等第之分别"; §2.3: "正是"部分是读法""** (*dualism*, *textual error*). A few lines earlier in the same chapter (下第八章) the text reads "三多凶，五多功，贵贱之等也", so 等 means rank. The passage is about the book's six lines ("兼三材而两之，故六"), not about how things arise. The repository already judged this passage 相分 ("「爻有等」是等级"; theories/becoming/chapters/YI-ZHUAN-AND-BECOMING.md), and WENLI notes the 杂 is "一卦六爻同时之杂"; §5.1's "无（新）" is false: `SameAhead` and `Hexagram.inPhase` already map this passage. 物 has other definitions in the corpus: "精气为物" (上4) and "有物混成" (老子25, 物 as the undivided whole). Fix: define 物 as a class of a reading, anchored on "物以群分" (上1) and 墨经 "體，分於兼也"; record 爻有等 as 相分.

3. **§4.6: 阖、辟 = "闭、开"; §5.3: "退化的元吸引……其中闭" against "生成的……其中开"** (*dualism*). The plan makes 阖 (坤) the degenerative side. In the text, closing is half of generation: "夫坤，其静也翕，其动也辟，是以广生焉"; 朱熹: "闔闢動静之機也……乾坤變通者化育之功也". The generative condition is the alternation "往来不穷谓之通", not more opening. Decline is 息: "乾坤毁，则无以见易；易不可见，则乾坤或几乎息矣" (上12, missed). Fix: keep the old theory's widening and narrowing under their own names and separate them from 阖辟; read 生生 as 通 (no last alternation) and degeneration as 穷/息.

4. **§2.2: "相 X … 对称的相因"** (*textual error*, *word*). The corpus's 相 covers several relations: friction (相摩, 相荡), exchange (相易), conflict and taking ("爱恶相攻而吉凶生，远近相取而悔吝生"), comparison (相较), alternation of one reading's two values (相推: 日/月, 寒/暑), co-definition of correlates (相生), order (相随). In classical usage 相因 is one-way succession (论语 "殷因於夏禮"). 孔疏《序卦》 (sources/zhouyi-yizhuan/commentary/zhengyi-10.json) records 周氏's typology, in which 相因門 ("因小畜生履") is listed apart from 相反, 相須 and 相病. Fix: name the symmetric relation 相须 or 互因, keep 因 for the plan's 被驱, classify each 相X separately, and adopt 相病 ("賁盡致剝，進極致傷") as a degeneration cell.

5. **§4.6: a word given as defined where it is only the defining term** (*textual error*). The table cites "化而裁之谓之变" for 化, "阖户谓之坤，辟户谓之乾" for 阖辟, "日新之谓盛德" for 日新, "生生之谓易" for 生生; in each the word defines something else, so 化, 阖, 辟, 日新 and 生生 are undefined in the corpus. The base also inverts the text's order (阖+辟 → 变 → 通). The rows for 穷, 久 and 复 cite laws, not definitions; 同异 cites only "墨经". Fix: add a column for the word's role (defined, defining, law, usage); in the 可重构 test, count senses, not characters.

6. **§2.3: "长短相形，高下相倾" labelled 《老子》二章, corpus given as 王弼本** (*textual error*). The repository's 王弼本 reads "長短相較"; its collation note forbids this mixing of editions (sources/wenli-shengsheng-v0.4/research/references/05_原典证据索引与校勘说明_v0.2.md, 校正 3). So the header's "古文引文都已在仓库原典中找到" is false.

7. **§4.6: 乾坤 "古文自己把它们读作一阖一辟…按此读"** (*overclaim*, *dualism*). Only 上11 reads them that way. The text also has 下5 "乾，阳物也；坤，阴物也……而刚柔有体", 上1 "乾知大始，坤作成物", 上5 "成象之谓乾，效法之谓坤" (what §2.3's "……" leaves out). 刚柔 carries a structure/dynamics split: "刚柔者，立本者也；变通者，趣时者也". For 一阴一阳, 韩康伯 and 孔疏 read 一 as 无 ("一謂無也，無陰無陽，乃謂之道"), a ground above the pair; the alternation reading is 朱熹's, itself a 理/气 split. `World.law_iff_em` shows the universal alternation law is as strong as excluded middle, so in the pure core it holds only for decidable worlds. Fix: record every 乾坤, 阴阳 and 刚柔 passage as 相合, 定域 or 相分, and name the commentator each reading follows.

8. **§4.6: 几 = "进程已定、读法未显之最早一步"** (*textual error*). The text says "君子见几而作" and "唯几也，故能成天下之务": 几 is the moment when acting still matters. 程颐: "獨言吉者，見之於先，豈復至有凶也". 孔疏 on 乾文言: "去無入有，有理而未形之時". Fix: define 几 as the earliest step at which the outcome shows in a coupled reading while it can still be changed; add 老子64 "其未兆易谋……常于几成而败之".

9. **Name-table words** (*word*, *dualism*). 道 as "大化之常" contradicts 下7 ("为道也屡迁…上下无常…不可为典要，唯变所适"), 老子1 ("道可道，非常道") and 解老 ("不得不化，故無常操"; "常者……無定理"), the last also undercutting 理 = "读法之常". 体用不二 is a 20th-century formula (熊十力); use the corpus's "神无方而易无体". 势 from 孙子 is outside the corpus and agent-laden ("擇人而任勢"; "勢如彍弩" is stored potential, not a basin); use 老子51 "道生之，德畜之，物形之，势成之". 固 is classically positive ("深根固柢，长生久视之道"); use 困 ("困于石"; exit "困，穷而通") or 执 ("执者失之"). 器 as "器、层" restores layering, while "形而上者谓之道，形而下者谓之器" in the same sentence as 化而裁之 goes uncited; adopt the existing 定域 reading (道 = 器之道). 和 from 论语 is outside the corpus; 老子42 and 55 give 和 within it.

10. **Overclaims and selection** (*overclaim*). §4.5's "精确对应" for 神: 韩康伯's 神 is "化之無主……故不知所以然", not WLPO. "这几乎就是旧理论…的次序" fits the text to the old theory. 生生 = "开之能开" has no textual basis; 孔疏: "生必有死，易主勸戒……故云生不云死", so naming the whole theory 易 makes it mean 生生 only. In context, 穷变通久 is about sages reforming institutions ("通其变，使民不倦"). Claiming the *minimal* set of undefined words needs proofs that the others cannot be defined. The chains are cut where the text turns evaluative ("文不当，故吉凶生焉", "吉凶生大业", "继之者善也", "不知常，妄作凶"); most "X 而 Y 生" sentences in the first batch end in 吉凶, 悔吝 or 利害, so deferring ethics drops a large, uncounted share of the corpus from the reconstruction test. Count it.

**Important chains the plan misses**

- 上4: "精气为物，游魂为变" (韩: "聚極則散"; 孔: "生變為死，成變為敗") and "原始反终，故知死生之说".
- 上12: 乾坤毁…息.
- 下7: 唯变所适.
- 下6: "困，穷而通", a counterexample inside the corpus to 穷→变→通.
- 上1: "动静有常，刚柔断矣", a distinction settled by constancy, which is what theorem one says.
- 上10: "通其变，遂成天下之文", and "极深而研几……唯深也……唯几也……唯神也", the text's own 深.
- 老子55: "知和曰常…益生曰祥…物壮则老，谓之不道，不道早已", a second definition of 常.
- 老子76: "坚强者死之徒，柔弱者生之徒".
- 老子28: "朴散则为器…大制不割"; 老子32: "始制有名…知止所以不殆".
- 老子1: "此两者同出而异名" (王弼: "在首則謂之始，在終則謂之母"), the texts' own pair rule.
- 老子22: "敝则新".

**Already sound (keep as is)**

Rule 2's two-way check; treating the texts' "则" as conditions with counterexamples; reading the 有无相生 pairs as correlatives (王弼: "不可偏舉"); refusing 尊卑 and 天命; using the commentaries as evidence, not verdicts; freezing the corpus first; taking 吉凶 only structurally; noting the commentators' disagreement over 化 and 变.
