# Independent review of the OU5 design, first draft

The report of one independent AI review of the first draft of this design (committed at 40118c083). The text below the line is the report verbatim, as it was returned on 31 October 2026. Its line numbers and paths refer to that draft, and the absolute paths are those of the checkout it read; "D" is the draft's DESIGN.md and "GC" its scratch module. Its scratch Lean is kept beside it as [ReviewChecks.lean](ReviewChecks.lean); it imports the draft's module and uses the draft's names, so it builds against 40118c083, not against the current module, whose [checks](../tree/Becoming/GrammarConditionalsChecks.lean) carry its theorems under the current names. How each finding was taken is in the design's [Review](../DESIGN.md#review) section.

---

The review is finished and nothing in /Users/ren/theories was written or committed. There are 24 findings: 5 blocking, 6 should fix and 13 minor. The 5 blocking ones:
- G15's 前際/後際 asymmetry is false.
- G01 claims "exactly" and "closes 06 未决", which the Lean does not support.
- G08 gives no grammar statement for 10 of its 13 units.
- G16 reads ZL-01-099 backwards.
- G21's unit XZ-ZM-044 states the converse of the cited law.

**Files** (short names used below):
- **D** = /Users/ren/theories/.claude/worktrees/ou5-design/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou5-conditional-laws/DESIGN.md
- **GC** = /Users/ren/theories/.claude/worktrees/ou5-design/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou5-conditional-laws/tree/Becoming/GrammarConditionals.lean
- **groups.tsv** and **units.tsv** are in the same study's `data/` folder.
- **PKG** = /Users/ren/theories/.claude/worktrees/ou5-design/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/
- **06** = /Users/ren/theories/.claude/worktrees/ou5-design/theories/becoming/chapters/06-CLASSICAL-TEXTS.md
- **corpus** = /Users/ren/theories/.claude/worktrees/ou5-design/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/corpus/
- **RC** = /private/tmp/claude-501/-Users-ren-theories/06fee326-8a27-436c-8689-e8d27ff445bf/scratchpad/ou5-review/tree/Becoming/ReviewChecks.lean. It imports GC and holds 11 theorems. All build with scratch_build.py, and every axiom report is empty.

## Findings

**1. Blocking. G15: the asymmetry between 前際 and 後際 is false.**
- **Where:** D L36 "無後際 and 無前際 are not symmetric … A beginning is kept only along the two-way core"; L87 "further premise for 前際: the two-way core"; L198 "a premise its pair about 後際 does not need"; GC:316-319 "Beginning is kept only along the two-way core".
- **Problem, (a):** "Only" is wrong. A beginning (`«生» R E`) is also kept along the core of the converse net, `«核» («逆» R) E`, with no forward constancy at all. That core is not contained in the two-way core.
- **Problem, (b):** The design compares a property of a line on the 後際 side (`«不穷» R E`) with a property of a point on the 前際 side (`«生»`). Compared like for like, the two sides mirror each other under `«逆»`:
  - 無後際 (`«不穷» R E`) is kept along `«核» R E` (`«不穷于核下不变»`).
  - 無前際 (`«不穷» («逆» R) E`) is kept along `«核» («逆» R) E` (the same theorem applied to `«逆» R`).
  - `«亡»` is kept along `«核» R E` (`«亡于核下不变»`, PKG Grammar.lean:503).
  - `«生»` is kept along `«核» («逆» R) E`.
  
  The only asymmetry is in the connectives the design reads into the two sentences: 相應, read as the core, for JS-326, and 故, read as dependence, for JS-324.
- **Problem, (c):** JS-324 contains no 相應: 「以如來藏無前際故，無明之相亦無有始」 (corpus/qixinlun.tsv:386). The text itself denies the premise the design proposes for it. QXL-JS-318 (高, classed 戊, qixinlun.tsv:380) reads 「…煩惱染法…從無始世來未曾與如來藏相應故」, which denies it provided 無明 counts among the 染法. The classifier's own note on JS-324 says "a model property".
- **Evidence:**
  - RC `review_sheng_kept_along_converse_core`: beginning is kept along the converse core.
  - RC `review_converse_core_wider`: with R a b := a = 0 ∧ b = 2, the pair 0, 1 is in `«核» («逆» R) «一»` but not in `«核» R «一»`, so not in `«位核»` either.
  - RC `review_wushi_kept_along_converse_core`: beginninglessness is kept along the converse core.
  - PKG Grammar.lean:512-518: the existing `«生于位核下不变»` destructures `⟨S, hSE, hs, _, hc', hyy⟩` and so never uses the forward constancy.
- **Fix:**
  - Restate G15 as the four mirrored statements above.
  - Drop "only" and "not symmetric" at L36, L87, L198 and GC:316-319.
  - Make JS-324 a premise of the model (or false as read through dependence) and cite JS-318.
  - Optionally offer Grammar.lean's owner the converse-core form of `«生于位核下不变»`.

**2. Blocking. G01: the Lean gives no order from 變 to 通, so "exactly" and "closes" overclaim.**
- **Where:** D L32 "holds exactly where the design's premises say … This closes 06 未决's '穷 → 变 → 通'"; L320; L73; L104-105.
- **Problem, (a):** 06:113 asks *where the order* 穷 → 变 → 通 holds. In `«穷变通久»` (GC:52-56), 通 comes from `«感而遂通» hF hc hc' ⟨x, continues⟩` alone, and `ends` is used only for 異. So 變 does no work toward 通: the theorem joins two independent facts with "and" and gives no order. 久 is `passes.1`, a projection of `«通»` (PKG GrammarReadings.lean:113), so 通則久 holds by definition. 06:82 already names 穷而息 as the counterexample, and 06:113 already has `«有常而不通»` and `«两向有常则通»`.
- **Problem, (b):** Two-way constancy is sufficient for 通 but not necessary, so "exactly" is false.
- **Problem, (c):** The design takes 通 from the text's definition (XCS-11-010, 往來不窮). It does not take 變 from the same sentence's 一闔一闢 (XCS-11-009, 甲 高) or from 化而裁之 (XCS-12-013), even though 06:30 reads 谓之 as a definition.
- **Evidence:** RC `review_tong_without_constancy`, on Option Bool with R a b := ∃ x, a = some x ∧ b = some (!x). There ¬`«有常» R «一»`, `some false` ends under `«静»` and alters into `some true` under `«一»`, and `some true` passes through.
- **Fix:**
  - State what the Lean shows: under F constant both ways, whatever has a predecessor under F passes through. The condition is sufficient and not necessary.
  - Say that 變 does not enter 通 on this reading.
  - Keep 06 未决 open, or restate it as a question about one reading of 變. Either argue the reading of 變 against XCS-11-009 or adopt that definition.
  - Remove "closes" from L32 and L320.

**3. Blocking. G08: "The design records each with the grammar's statement" (L149; also L24) does not hold for 10 of 13 units.**
- **Problem:** Only 無緣不起 has a statement, `«无缘不起当且仅当皆有缘»`, which covers JSZ-C-005, -015 and -016. There is none, in D, groups.tsv or GC, for:
  - production: JSZ-P-01-003 高, JSZ-C-044, JSZ-C-069, ZL-07-133, ZL-07-170, XCX-04-050 and XCX-04-051;
  - 因 and 緣 both needed: QXL-JS-212 高 (classifier note: "joint sufficiency") and QXL-JS-214.
  
  The grammar's 缘 is only a necessary condition, and the grammar has no predicate for presence.
- ZL-07-127 is counted as 'premise' although D says it "has no reading" (L151).
- **Fix:** Either write a production statement, for example on the net of the possible, together with a net where it fails, or move these 10 units to not expressible with that reason. Then recount: premise goes from 30 to 20 and NE from 28 to 38 if all of them move.

**4. Blocking. G16 and G13: the "two horns" read ZL-01-099 backwards and use 斷 in two senses.**
- **Where:** D L209 "ZL-01-099, ZL-17-051 … no condition gives 斷 …; own condition gives 常"; L184 "One with no result ends under the one (斷)".
- **Problem:**
  - ZL-01-099 says 「若無因而有萬物者，是則為常」: no cause gives **常**.
  - ZL-17-051 says 「若離業有果報，則有斷常」: a result apart from deeds gives both 斷 and 常.
  - Neither says "own condition gives 常".
  - Read with 常 as abiding under every class (`«自缘则常»`), ZL-01-099 is false: what has no condition abides under no class.
  - 斷 means "no condition" in G16 but "no result" in G13.
- **Evidence:** RC `review_unconditioned_not_abiding`: from (∀ x, ¬ R x y), ∀ E, ¬ `«住» R E y`.
- **Fix:** Mark ZL-01-099 false as read, or give 常 another reading and state it. Read ZL-17-051 on its own terms. Use one sense of 斷 across G13 and G16, and update L13's false-as-read count.

**5. Blocking. G21: XZ-ZM-044 states the converse of `«可分则不在核»`.**
- **Where:** D L93 (standing "theorem") and L236.
- **Problem:** The text is 「征知必将待天官之当簿其类，然后可也」, and its classifier form is "Y=征知可 仅当 Z=天官当簿其类" (necessary condition). That makes registration at a stage a *conclusion*. In `«可分则不在核»` (PKG GrammarTesting.lean:53) it is the *hypothesis*. The unit's actual law is the converse. D itself says the converse fails without a premise, and it holds only under `«不可致诘而有常则混而为一»`.
- `«致诘不尽»` (PKG GrammarCandidates.lean:644) is therefore not a net where Z fails and Y fails, since Y holds there.
- XZ-ZM-043 is the composition 心 ∘ 天官, not this law.
- **Fix:** Give -044 the converse as its law, with standing "theorem under a further premise". Use `«致诘不尽»` as the net where that premise fails. Give -043 its own reading along `«而»`. The theorem count goes from 14 to 13.

**6. Should fix. Several "new" laws are definitional unfoldings or one-line compositions.**
- **Where:** D L23, L26, rows L73/L77/L78/L80/L94, and the table at L291-300.
- **Problem and evidence:**
  - `«穷则变»` (GC:27) is `«生于细而续于粗则异»` read in the converse net (RC `review_qiong_is_dual`, a single term).
  - `«穷则变当且仅当有后»` (GC:34) only unfolds `«异»` and `«亡»`.
  - `«感而遂通»` is one line from `«两向有常则通»` and `«有常则续不尽»` (RC `review_gan_is_composition`).
  - `«无异当且仅当类不分续»` is pure logic for any two relations (RC `review_wuyi_is_logic`).
  - `«无缘不起当且仅当皆有缘»` is two lines from `«一之生»` (RC `review_wuyuan_from_yizhisheng`).
  - G22's `«保之像»` (PKG GrammarLaws.lean:1941) unfolds `«像»` and `«则»`.
  - `«依则离无»` and `«依之传»` follow from the definition in two lines.
  - `«无环则无俱有»` is one transitivity step.
  
  The repository rule applies: "A wrapper, recheck, rename or repeated acceptance is not another result."
- **Fix:** Label these "definitional" or "corollary". Count as new only three laws (G02, G03, G15) and one definition (G09's `«依»`). Optionally offer GrammarReadings' owner a `«两向有常则通»` with the weaker hypothesis.

**7. Should fix. The method statements do not hold.**
- **Where:** D L9 and L44 ("one law each", "one Z and one Y"); L65; L69 ("a witness … or a named check … in the scratch module"); L321 (the gate).
- **Groups hold several laws:** G01, G10, G12, G13, G15, G16 and G18 each hold 3 or 4.
- **Countermodels not of the stated kind:**
  - G21's `«致诘不尽»`.
  - G19's `«有生不必有亡»` shows a pointwise failure, not a net where Z fails and Y fails.
  - G16's column is a refutation of LZ-07-002.
  - G18's `«遍而无相»` shows only that Z fails. That Y fails follows from `«有相»` (PKG GrammarCandidates.lean:158) but is not stated.
  - G14 cites `Map.Short.degeneration` (PKG GrammarMap.lean:411), which is about `false`, a point with no predecessor. It does not isolate the constancy premise; `true` with `Map.short_end` (:406) does.
  - G12 has no declaration at all.
- **Countermodels that live in the package, not in scratch:** `«有常而不通»`, `«从缘生非文法之律»`, `«自缘则常»`, `«遍而无相»`, `«有生不必有亡»`, `«致诘不尽»`, `«尺与尺可相尽»` and `Map.Short.degeneration`.
- **Fix:** Call the groups families or split them. Give every law a named net where Z fails and Y fails. Reword L69 to allow package declarations. Claim the gate only after findings 1-5 and 8-9 are taken.

**8. Should fix. Some units state another law's conditional, or invert this one.**
- **G10:** CWS-P3-074 高 reads 「如是能熏與所熏識，俱生俱滅，熏習義成」, with classifier Z=俱生俱滅 and Y=熏習義成. D swaps Z and Y. 俱生俱滅 is also not `«俱有»`, which is mutual reach.
- **G12, all three units:**
  - QXL-JS-058 高 has G09's form.
  - QXL-JS-167 高 contains 體不滅 → 心得相續 (G14-like) and 癡滅 → 心相隨滅 (G09).
  - ZL-02-091 is the claim that `«住因于续»` (PKG GrammarCandidates.lean:145) was written for.
- **G13:**
  - ZL-21-031 is `«住亡不并»`, which is not among G13's laws; the classifier notes that the two-grain reading makes it false.
  - ZL-01-047 is `«断则无相续»`, also not G13's.
  - ZL-21-113: D gets "exactly the two ways the premise fails" only by reading 無常 as "no result". On G13's own 不常, `«四相俱时»` (:287) has it together with abiding under the one. So 無常 → 斷 is false as read.
- **G11:**
  - CWS-P6+P7+P8-020 「不爾，便無恒相持用」 states the converse, which is false (RC `review_not_constant_yet_endless`; D L193 says the same).
  - ZL-10-043 (人功現有 → 火不異可燃) states non-difference, not 相须.
- **G09:**
  - QXL-JS-123 高 is a production conditional plus a temporal one; it is not "a chain of dependences".
  - QXL-JS-086's 緣 is 所緣緣, which the plan excludes (classifier).
  - ZL-17-013 goes from volition to action (compare XZ-ZM-143, classed NE).
- **G15:**
  - ZL-02-070's Z is 決定有去∧去者, which is G16's 定性, and the passage argues by reductio.
  - LZ-63-004 needs magnitude.
- **G17:** QXL-JS-012 and -252 have the 離X則無Y form that D sends to G09 for nine other units, and no criterion for the split is given.
- **Fix:** Reassign these units, mark the false ones as false as read, recount L13's "5", and correct their rows in groups.tsv.

**9. Should fix. Some dispositions break the design's own rules (L44, L50, L51).**
- **Valuations kept in a law:**
  - QXL-JS-195 has the attitude 厭求 in its Z, while JS-194, -206, -215 and -216 go to 丁 for the same attitude.
  - CWS-P6+P7+P8-043 reads 「…由善、惡業，下、上身分，冷觸漸起」 (corpus/chengweishi.tsv:330). This is the ground on which CWS-P2-007 goes to 丁.
  - LZ-39-002 contains 貴高.
- **Qualities, magnitudes or offices kept:**
  - LZ-39-001 and -002 (清寧靈盈, 侯王貞).
  - XCS-06-004/005: the qualities 專直/翕闢 are dropped, and 大生 is read as 全生成, though the classifier says this 生 means "to produce".
  - LZ-23-002 and LZ-63-004 need magnitude.
  - XZ-ZM-016 is kept, while XZ-ZM-026 goes to NE as "a ruler's naming practice".
  - LZ-33-005 is agentive under 王弼.
- **The commentary rule:** Under 王弼, LZ-07-002 and LZ-36-001…004 are not expressible, as D itself says at L210 and L253. Yet they are counted as laws that are false as read.
- **Split units:** CWS-P1-030 高 is split, but LZ-22-001 goes wholly to 丁, although its 敝則新 is structural.
- **Fix:** Apply the rules as written, or state one exception rule and apply it everywhere. Then recount.

**10. Should fix. More overclaims in the prose.**
- **L33**, "相推而生 is 全生成": `«相推则全生成»` proves one direction only.
- **L34**, "a line that never returns": the Lean assumes the whole net has no cycle (`«无环» R`). A version that only constrains the line itself is provable (RC `review_line_local_bound`).
- **L118**, "早已 is ending": the Lean proves ¬`«不穷»`, not that an end exists.
- **G04 (L76, L124)** cites the global law "all three". The local `«线有限不并则返»` (PKG GrammarLaws.lean:1479) fits L34 better. It gives `«及» R x x`, not `«复»`.
- **L131**, "parts nothing in the net": the iff says only that F parts no continuation's ends. The reading also ignores the grammar's own `«息»`.
- **G09:** the region premise named at L156 is missing from the table, is never stated and is not proved. "Co-present" clashes with `«俱有»`.

**11. Should fix. Provenance.**
- **L144:** the 韩注 「動止得其常體，則剛柔之分著矣」 appears nowhere in the repository except this study's own files, and XCS-01-003's commentary field is "none". Source it, or mark it as to be checked.
- **"OU6's candidates"** (L22, L35, L54, L204, L209, L220, L309, L320): GrammarCandidates came with OU2c (706b80293). OU6 (024986cf1) changed only Grammar, GrammarMap, GrammarReadings and MapInstances.
- **The board id "OU5"** already names the item that landed GrammarTesting (706b80293; PLAN.md:429). G21 uses that module, so this item needs a distinct id or a note on the board.

**12-24. Minor.**
- **12.** L304 says "witnesses (13)" but lists 14. The total of 38 holds with 14 and the helper.
- **13.** GC:281-283 and L302 say "symmetric", but `«核下线相随»` does not assume symmetry.
- **14.** `«变而不通之例»` and `«并而不返之例»` do not state that Z fails. The former repeats `«有常而不通»`.
- **15.** In `«相须之例»` the joint class is equality, which is the degenerate case.
- **16.** `«依于无始而有始之例»`'s verdict depends on E separating the two kinds. This should be said.
- **17.** G20 uses one class for perceivers and percepts, and the loss is not stated.
- **18.** G21 mixes `«层»` and `«诘»` without noting that they are equivalent.
- **19.** The generative reading of LZ-28-006 is lost and not listed under "Lost".
- **20.** L252 says "G03's converse". The false law is actually `«亡»` → `«有前»`.
- **21.** "Alters" points opposite ways: G01's prose means `«异» R F E`, while G05's prose "alters from E under F" means `«异» R E F`.
- **22.** Some batch readings in groups.tsv do not fit their unit: LZ-39-002 has "立種姓 definitional", QXL-JS-123 has "a chain", and JSZ-P-07-032 was read with the wrong batch.
- **23.** Names:
  - Several use corpus words where the core has its own: `«穷则变»`, `«感而遂通»`, `«穷变通久»`, `«相推则全生成»`, `«变而不通之例»`, `«寂而不感之例»`, `«分则见易之例»`. The "structural alternatives" promised at L309 are not given.
  - `«穷而息之例»` has 息 in its name but states no `«息»`.
  - `«无尽而不返之例»` uses the grammar term 尽 to mean "unbounded".
  - `«无缘不起当且仅当皆有缘»`, and L35's prose, say 有缘 where the statement is ¬¬∃.
  - `«无异当且仅当类不分续»` says 类, but F need not be a class.
  - `«依»` has no glossary row. It should be checked against the registered one-way 所依 (PLAN.md:296, marked 待核).
- **24.** Readings carry only a blanket AI label (L5). groups.tsv and the home-section text will need one per reading.

## Checked and found sound
- **Counts:** all of them hold. That covers 124/30/32/28/5 = 219, the first-batch column 87/26/24/25/0, every group's count and its 高/中/低 split, and 36 高 units. units.tsv matches the classification's 219 丙一 rows field for field.
- **Build and audit:** GC is unchanged from the original. It has 38 declarations (37 theorems and one definition), with empty axiom reports, no sorry, no automation and no propext or Classical. The new statements match the table.
- **Existing theorems:** every one D cites has the statement D gives it.
- **Genuinely new:** `«不穷于核下不变»`, `«相推则全生成»`, the two `«无环…»` laws and `«依»`.
- **Repository rules:** D's links resolve, and no text or person is used as warrant.
- **Remaining 高 units:** they fit their law as read. That includes CWS-P4-062, whose 無始 appears in the preceding unit CWS-P4-061.

## Doubts not settled
- **G22:** does 衡不正 mean the balance reverses (the unit is then definitional) or only that it fails to keep the order (then 重縣於仰 does not follow)? A commentary such as 楊倞's would settle it.
- **JS-326:** should 相應 be read as the forward core? A survey of the 起信论's uses of 相應, with JS-318 among them, would settle it.
- **Finding 1(c):** does 無明 count among JS-318's 煩惱染法? The 起信论's 熏習 sections would settle it.
