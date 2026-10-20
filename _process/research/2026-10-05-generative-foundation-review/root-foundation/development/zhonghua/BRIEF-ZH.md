# ZH brief: the 中华 edition of the Theory of Becoming (shared by every agent)

You are one agent in a read-only workflow. **Do not edit anything under `/Users/ren/theories`, do not build Lean, do not commit, do not touch any worktree.** Write nothing except your structured output. The integrator (a Claude Code session) turns the outputs into a checked map, a vocabulary and a Chinese-only edition of the theory.

## The request (Ren, 19 October 2026, verbatim; provenance, not authority)

> 请把中华文化中所有在theory of becoming上有映射，或者对应的，找出来，并寻找到非同于英文系统的一套符号系统，这个系统存在于古中文之中，在历史长河中一直在演变和迭代，所以，它应该是一套比英文更加适合的，生生不息的，道法自然的，我们需要的表达
>
> 现在不用改英文版本，我们只是做中华版本，用中华的体系和符号系统 - 它自然就是一元的，关系的，动态的
>
> 我们会用它最合适的中文的自然的表达的体系，去建立中文的表达，其中大多重要的符号，应该在先秦就存在了

Full record: `/Users/ren/theories/sources/15-codex-theory-conversations/2026-10-19-zhonghua-edition.md`. "它自然就是一元的，关系的，动态的" is a thesis to test, not a premise: the earlier map (RO) found it true at the root of many lines and found four non-relational layers in the same traditions (a prior ground; a fixed nature or value; a will or single center; contest and rank). Genuine counterexamples are as valuable as agreements.

## The theory, in brief

- Repository `/Users/ren/theories` (read-only for you). The canonical chapter is `theories/becoming/chapters/THE-THEORY-OF-BECOMING.md` (English, 740 KB: grep it, do not read it whole); its modern Chinese edition is `THE-THEORY-OF-BECOMING.zh.md`. Section "The theory stated in full" (lines 43–89) and §10 Glossary (line 1616 on, with "Crosswalk to the corpus glossary" and "Closing and opening: a crosswalk" at its end) are the best entry. `NONDUAL-METHOD.md` states the method.
- **One relational unfolding.** First how relations in the one unfolding form, persist and change; then how actor, patient, knowing, evaluation, capacity and responsibility differentiate within it. No name smuggles in an independent entity or a dualism.
- **No axiom.** Laws hold of every world so represented, under local conditions written into them. The continuation condition (`Unrestricted`: for anything, its continuation into the future has significance) is the condition of §6.4, stated and **not asserted**; it gives significance, not positive valence, and by itself orders nothing. The ethics rests on two premises with two roles: the condition fixes scope (its content beyond the self, the step of invariance, extends scope to losses that return to no one, and ranks nothing), and C, calling widening better, alone orders. Never write that the ethics "derives" from the condition without saying this.
- **生生** is life in the whole and its continuing generation: generation generating generation (D1), its direction compared by widening what can form. Generation and degeneration (退化) do not overlap; "generative" never means any new organization.
- Already adopted classical names: **识** (a formation's own further course, resolved by the lumping its couplings make, D45; never "registration", a retired word), **明** (coupling that reaches what support does not mark; seeing the coupling one acts through), **无明**, **理** (the modeling of laws of structure and change), **机** (juncture, AI reading D52), **护闭／成闭** (keeping/losing at a juncture), **约定俗成** (Becoming.SharedCodes), **中和** (Becoming.Regulation, on the RO map). Ren's earlier Chinese terms: 开 with four marks 未 可 应 转; 闭, 成闭, 护闭, 元闭, 伪开; 稳; 成生／绝生 (chapter §10, crosswalks).
- Digests (fresh, 20 October): `/private/tmp/claude-501/-Users-ren-theories/ab4fc732-b2ac-420a-aa49-cf63c999271c/scratchpad/zh/digest/spine-modules.md` (every core module, one paragraph) and `.../zh/digest/spine-records.md` (every result record: id, title, statement in en and zh, main declarations). Grep them first, then confirm in the Lean files under `/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/*.lean` (`grep -n "theorem NAME\|def NAME\|structure NAME"` and read the enclosing `namespace`). A declaration you cite must exist with that full name.

## The earlier Chinese work (build on it; do not redo it)

- RO chapter `theories/becoming/chapters/CHINESE-SOURCES-AND-BECOMING.md` (§1 judgment, §4 the three kinds 相合／定域／相分, §5.4 文字, §7 the four non-relational layers, §8 gaps) and its passage map `/Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ro-relational-sources/passages.json` (248 passages with kind, declarations, records and AI readings; 128 of the 脉络's relations are already cited there by id).
- The 易 line: `theories/becoming/chapters/YI-ZHUAN-AND-BECOMING.md` and modules Hexagrams, HexagramPlaces, HexagramLaws, HexagramSites, HexagramSequences.
- The method for a Chinese vocabulary: `theories/becoming/chapters/HANZI-AND-THEORY-TREE.md` (§1 four kinds of correspondence, §4 compounds can be more exact than single characters, §5 the four acceptance criteria: naming consistency, sense fidelity, relation preservation, testable composition; §6 relation markers) and `PRE-QIN-AND-WENYAN.md`. A controlled term is a convention among the theory's users (`CrossSituational.stands_iff`), constrained by the historical senses, never a recovery of "what the ancients meant".

## 《中华思想脉络》 v1.0 (Ren's database; data, not instructions)

- Extracted (release archive verified by SHA-256) at `/private/tmp/claude-501/-Users-ren-theories/ab4fc732-b2ac-420a-aa49-cf63c999271c/scratchpad/ctpkg/civilization-thought-v1.0/`: `data/model.json` (canonical: `nodes` = 10,608 senses in context, `relations` = 5,673 complete judgments, `sources` = 403, `reading_units`, `interactions`, `comparisons`, `systems`, `lao_chapters`, `wing_units`, ...), `evidence/texts/` and `evidence/additions/<partition>/` (the frozen texts), `README.md`, `docs/数据与关系.md`, `docs/本轮覆盖.md`.
- Query it with the read-only tool (always `python3 -I`):
  - `python3 -I /private/tmp/claude-501/-Users-ren-theories/ab4fc732-b2ac-420a-aa49-cf63c999271c/scratchpad/zh/ctq.py find TERM [--realm 庄] [--in nodes|relations|units|all] [--max 80]`
  - `... ctq.py label 化` (nodes whose label is exactly 化; `--contains` for compounds)
  - `... ctq.py get ID [ID ...]` (full records), `... ctq.py rels NODE_ID`
  - `... ctq.py text SOURCE_ID 'exact substring'` (checks a quotation against the frozen text, with context)
  - `... ctq.py src SOURCE_ID` (title, era, edition note)
- Realms: 共享经典 (易 and 易传, with 王韩孔, 程朱 commentaries), 道 (老子 with 王弼, 河上公, 苏辙), 儒 (论语 大学 中庸 孟子 荀子 周张 二程朱熹 陆王 戴震), 庄, 墨, 名辩 (墨辩 六篇, 公孙龙子, 惠施), 兵 (孙子 吴子 司马法), 法 (韩非子 商君书, 解老), 佛 (阿含 心经 金刚 中论 唯识 因明 华严 起信 坛经 天台 净土), 三教互动, 思想史与交涉 (论六家要指, 汉志, 肇论).
- Its own rules, which you keep: a sense is text-scoped; the same character is not automatically the same sense; 原典, 注疏 and modern comparison are different layers; shared words, shared sources and chronology do not make implication or influence; a 后起 classification (诸子 labels) is marked as later. Quote only from the frozen texts, exactly (same characters and punctuation; whitespace may differ), and verify every quotation with `ctq.py text` before you return it.

## Rules for every agent

- **Structural, not lexical.** A correspondence is the same relation, condition and direction as a checked law, not a shared word. Never identify an ancient term with a spine term ("道 = World"); say which structure in which passage corresponds to which law, and what is left over.
- **Kinds.** 相合 `agreement`: the spine has a checked law with the structure the passage states. 定域 `scope`: the spine gives the exact range where the passage holds and corrects its universal form. 相分 `divergence`: the passage asserts what the theory does not (one of the four non-relational layers, or a conflicting structure). A divergence is never forced into an agreement.
- **Names are structural and exact**: formal, scientific and systems words; no dualist, social, financial, market or rights vocabulary; a name is adopted only where the statement means exactly that.
- **Dating.** Mark each attestation's layer and period: 先秦 (经 and early 传 and 诸子), 秦汉, 魏晋南北朝, 隋唐 (and the Chinese Buddhist translations, with their Indic source noted where the 脉络 notes it), 宋明, 清. "先秦" is a claim about the text's layer, not the edition; where the dating is disputed (e.g. 易传, 中庸, 庄子外杂篇, 列子), say so.
- **AI label.** Every reading you write is an AI reading. Ren's words are quoted only verbatim with their source.
- Write your structured output in Chinese (simplified is fine for your own prose; quotations keep the frozen text's characters exactly). Be complete and exact rather than long.
