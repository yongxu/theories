# Brief: classify the frozen first-batch corpus (OU0, plan version 10 §三)

You classify sentence units of classical Chinese texts for a research plan. Read first, in `/Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/`:

- `PLAN.md` §一 (why the centre is continuation relative to a class, and the 中观 dilemma), §三 (the classes), §4.1–4.3 (the grammar's terms: 际, 缘, 类, 续, 生/住/异/亡, 有常, 核), §4.2 (operations read from sentence forms), §5.2 and §5.4 (chains and registrations already noted). Do not re-argue the plan; apply it.
- `corpus/MANIFEST.json` and the TSV(s) of your assignment: each row is one unit (id, text_id, chapter, unit_type, text, offsets).

## The classes (plan §三)

| code | class | use when |
|---|---|---|
| 甲 | 定义 | the unit defines a word by others (X 谓之 Y; X 曰 Y; X 者，Y 也; 墨经 "X，Y 也"), judged on the text and its commentary |
| 乙 | 文法之定理（候选） | the unit states something that should follow from definitions and the operations alone, in every model (e.g. 有无相生 as correlatives); you only propose; Lean decides later |
| 丙一 | 有条件之律 | "Z 则 Y" or "Z 而 Y 生" and the like, holding only under a condition stateable in the grammar; give Z and Y, and any counterexample in the corpus |
| 丁 | 评价 | ends in 吉凶, 悔吝, 利害, 善/不善, or is otherwise evaluative or prescriptive (what one should do) |
| 戊 | 相分 | the text itself sets up a hierarchy or a split of two kinds (天尊地卑, 贵贱之等, 金/师子 as unchanging substance and phenomena) |
| 己 | 反读 | the text explicitly rejects a thesis of the plan (e.g. 中论 refuting 相續, or the marks of arising, abiding and ceasing as established) |
| 庚 | 叙述与论证 | frames (問曰, 答曰), narrative, examples, rhetorical questions, argumentative steps that state no definition or law themselves |
| 未读出 | | cannot be read into the grammar; give the reason (sense unclear, form unclear, needs an operation the grammar lacks) |

One class per unit; if a unit does two things, choose the stronger (甲 > 丙一 > 乙 > 戊 > 己 > 丁 > 庚) and say the other in the note.

## Output

Write only into `/Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/classify/` (create files there; touch nothing else in the repository; do not commit; do not download anything). For each text of your assignment, write `<text>.tsv` (UTF-8, header row, tab-separated, escape tabs and newlines in fields) with columns:

`id	class	form	terms	commentary	registration	confidence	note`

- `form`: the unit's form in the grammar, short (e.g. `变 := 一阖一辟（交替）`, `丙一：Z=穷，Y=变`, `相待：有/无`), or empty for 庚.
- `terms`: key words with their sense in this context (`化=征之易（墨经）`), especially polysemous ones (生, 已, 盡, 窮, 化, 缘, 相, 分别, 事, 理).
- `commentary`: which commentary reading you follow and where (王弼, 韩康伯, 孔疏 with file, 青目, 承迁, 经说 item id), or `none`.
- `registration`: for units with pair words (乾坤, 阴阳, 刚柔, 天地, 尊卑, 理事, 体用, 二谛, 一心二门 …): 相合, 定域, 相分 or 反读, else empty.
- `confidence`: 高, 中 or 低.
- `note`: losses of meaning in the reconstruction, the second function of a dual unit, counterexamples, links to other unit ids.

Also write `<text>-summary.json`: counts by class, the units you judged most important for the plan (up to 25 ids, with one line each), the 戊 and 己 units, the 未读出 reasons, and every point where the text contradicts or strains a reading in the plan (§一, §5.2, §5.4), with unit ids.

## Rules

- Quote nothing that is not in the TSV or the repository's commentary files; if you rely on memory for a commentary, say so in the note and lower the confidence.
- Commentary is evidence, not verdict. Attribute commentary lines to the commentator, never to the base text.
- Read polysemy from context, not from modern meanings. Do not read the plan's structure into a sentence that does not carry it; when in doubt, 庚 or 未读出 with a reason is better than a forced 甲 or 丙一.
- Work efficiently: read the TSV in large chunks; classify in order; keep `form` and `note` short.

Reply (under 400 words) with: files written, counts by class per text, the five most important findings for the plan (with unit ids), and any problem with the corpus files.
