# Language and the repository's rules (review of the first draft, 30 October 2026)

One of three Opus lenses on the first drafts of kit/one_sense.py and lw-the-way-for-life/kit/upw_question.py ([combined.diff.txt](combined.diff.txt)); how each finding was taken is in [NOTE §4](../NOTE.md#4-the-review-and-how-each-finding-was-taken). The report as returned:

**Lens: language and the repository's rules. Ten findings, most severe first.**

Note first: `combined.diff.txt` was written at 19:59. `upw_question.py` changed after that. The kit now puts "alone" back in the statement, drops "not a goal" from it, rewrites the hypothesis and adds a related entry. Regenerate the diff before landing. Findings 4 and 7 below are against the kit as it stands now.

---

**1. The 理 edits claim more than the Lean proves, and the names keep a second sense** (most severe)

Files: `theories/becoming/chapters/01-ROOT.md` (§4, the sentences appended to the root theorem) and `GLOSSARY.md` (理 row).

- **Proposed 01 words:** "Where `E` is a class, its core is a 理 in knowing's sense, a lumping the step goes alike across (here, a constant class), and the coarsest inside `E`: the 理 of `E`. The names below that write 理 (`«守理则不穷»`, `«亡前理变»`, `«足以定理»`) mean the core…"
- **Proposed glossary words:** "A class's 理 is its core, the coarsest such lumping inside it, which the grammar's names that write 理 … mean".

Why this is wrong:
- **Going alike is not constancy in the grammar.** 01 §7 defines going alike as `«同行»`, `R˘;E;R ⊆ E` (GrammarLaws.lean:1301). It equals constancy only when every occurrence has exactly one successor (`«同行当且仅当有常»`; `«局定后则有常当且仅当同行可续»` names the gap).
- **Counterexample.** Take `x→a`, `x→b` with `E` the identity. The identity is a constant class and is its own core. It does not go alike, because `R˘;E;R` relates `a` to `b`. Inside this `E` there is no lumping the step goes alike across, so "the coarsest such lumping" does not exist.
- **The cited names are not about classes.** `«守理则不穷»` and `«亡前理变»` take any relation (`{R E : «际» α}`, no `«类» E`), and `«足以定理»` is a definition for any `E₁ E₂`. 01 §4 itself says `«亡前理变»` holds "for every relation `E`". Yet the addition concedes that where `E` is not a class the core "need not be a lumping". So the names' 理 still has a second sense, against the note's claim of "names it without a second sense".
- **Wrong standing.** The addition is glued into a **Theorem** (root) paragraph. It is a definition plus a claim, and it cites no Lean.
- **The note conflates two notions.** NOTE §2 says "(类同 need not be transitive)". That mixes up 类, an equivalence (`structure «类»`), with 类同 (`«同于不必传递»`).

Fix in 01 — a separate paragraph after the root theorem:

> **Definition** (the 理 of a class). Where `E` is a class, its core, the greatest class inside `E` that the relation carries (`«核为类»`, `«根»`), is the 理 of `E`. Where every occurrence has exactly one successor, carrying is going alike (`«同行当且仅当有常»`, [§7](../../../../../../../theories/becoming/chapters/01-ROOT.md#r-master-laws-on-the-grammar)), so the 理 of `E` is the coarsest 理 in [knowing's](../../../../../../../theories/becoming/chapters/03-KNOWING.md#li) sense inside `E`. On a branching relation it is carried but need not go alike (`«局定后则有常当且仅当同行可续»`). The names below that write 理 are stated for the core of every relation, and mean 理 in this sense only there.

Fix in the glossary:

> one the step goes alike across (`«同行»`). Where each occurrence has one successor, a class's 理 is its core, the coarsest such lumping inside it; the grammar's names that write 理 (…) are stated for the core of every relation and mean 理 only there

06 §八 is fine as it is: its setting is a determined law, where `Law.alike_iff_core` applies.

---

**2. A formal 生生不息 is still written plain; the kit missed it**

File: `theories/becoming/COLLECTIVE-DIRECTION.md:102`

- **Current words:** "renewal without end holds from moment `0` (`RaisedEveryOther.both`): widening relative to what is held and 生生不息 can hold together."
- **Why it is wrong:** this is the formal result. The theorem's docstring cites `«生生不息»`, and 07's home of the result writes "(`«生生»`, `«生生不息»`; `RaisedEveryOther.both`)". Under the new rule, plain text means the ethics' or the corpus's sense. Read that way, the sentence claims far more than the Lean. It also contradicts the note's claim that "every other plain use … is the ethics' sense or a quotation".
- **Fix:** "…renewal without end holds from moment `0`, so moment `0` does not cease (`«生生»`, `«生生不息»`; `RaisedEveryOther.both`): widening relative to what is held and renewal without end can hold together." Add the passage to `one_sense.py`.

---

**3. 08's table of words in one sense gives "generation" two senses, one of them 生生**

File: `theories/becoming/chapters/08-METHOD.md` (anchor `#five-words`)

- **Current words:** "| generation | 02's 生成: a pattern going on through carrying renewal; in 07, 生生 as life in the whole and its continuing generation |".
- **Why it is wrong:** the table states "Every chapter uses these words in one sense each", and the glossary's generation row says "it is not 生生". This row is the same two-sense fault item 13 is about.
- **Fix:** "| generation | 02's 生成: a pattern going on through carrying renewal | arising (…); 生生 (07), which generation at two orders does not give |".

---

**4. 08 still states the warrant in the old target framing**

File: `theories/becoming/chapters/08-METHOD.md` (`#philosophical-warrant`)

- **Current words:** "**A stronger universal practical warrant**: grounding reasons without an externally supplied end; the ethics does not wait on it".
- **Why it is wrong:** `upw_question.py` restates the record and 07's open item, but this summary of the same item still frames it as something to obtain, in different terms.
- **Fix:** "**Whether a universal practical warrant exists**: whether practical reasons have a warrant binding every possible mind, with zero substantive premises; one grounding the condition comes from neither logic alone nor the represented dynamics alone, and the ethics, life's stance, does not wait on it ([07](../../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-universal-practical-warrant), T8)."

---

**5. The Chinese gloss of the ethics' 生生 uses 生成, the defined word for 02's generation**

Files:
- `theories/becoming/chapters/06-CLASSICAL-TEXTS.md` §二 — the very sentence the kit edits: "本理论所用的“生生”是整体中的生命及其继续生成".
- `theories/becoming/ONE-PAGE.zh.md:7`: "即整体之中的生命及其不断的生成".

Why it is wrong: in the glossary, 生成 is 02's generation, which "is not 生生". The overview's Chinese edition deliberately writes "持续的生发" instead.

Fix: change 06 to "整体中的生命及其持续的生发" and ONE-PAGE.zh to "整体之中的生命及其持续的生发".

---

**6. The new 生生 glossary row: wrong home, both premises missing, no AI label**

File: `GLOSSARY.md`

- **Proposed row:** "life in the whole and its continuing generation, compared by widening what can form: for life, the way (T8) … | [07 §8](../../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#theses)".

Why it is wrong:
- **Home.** The glossary's rule is that a word's home is where it is defined and glossed with pinyin. That is 07 §2: "*What widening counts.* 生生 (*shēngshēng*) names life in the whole…". §8 holds the thesis, not the definition.
- **Premises.** "for life, the way" summarizes the ethics without naming its two premises, which AGENTS.md requires wherever the ethics is summarized.
- **Label.** The gloss is an AI reading (D1) of Ren's term, and readings keep their label.
- **The renewal row.** Its words "it is not 生生" are unclear, since they appear to say 生生 is not 生生.

Fix:

> | 生生 (*shēngshēng*) | life in the whole and its continuing generation [AI reading, D1], compared by widening what can form; T8 argues it as the way for life, with the continuation condition for scope and C for order. Neither the grammar's `«生生»` (renewal without end) nor any new organization | [07 §2](../../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#order) |

In the renewal row, write "it is not the ethics' 生生 (below)".

---

**7. The record and 07 still read as a target in several places, and the Chinese hypothesis is ambiguous**

Files: `theories/becoming/results/records/universal-practical-warrant.json` and the current `upw_question.py`.

- **Hypothesis (English):** "A question the restated goal, practical judgment for life on the fewest premises, leaves open: a warrant given as…". This is a garden-path sentence. It also uses process narration ("restated") in a field the page renders under Conditions.
  - Fix: "Left open by the goal of practical judgment for life, on the fewest premises: a warrant given as one account of ends, selection, knowing and revision within becoming. Supplied local norms, behavioural convergence or fuller description do not answer it."
- **Hypothesis (Chinese):** "重述后的目标（…）留作开放的问题" reads as if the goal itself is left as an open question.
  - Fix: "“生命的实践判断，立于最少的前提”这一目标把它留作开放的问题：…".
- **next_delta:** "is the goal's work" / "是目标的工作" does not say which goal.
  - Fix: "is the work of the goal of practical judgment for life" / "是“生命的实践判断”这一目标的工作".
- **Fields the kit did not touch** (rendered page lines 36 and 66):
  - does_not_show[7], "The revised question is itself an inquiry…", now reads as the newly restated question. It means the fulfillment question. Fix: "The revised fulfillment question…" / "修正后的完成问句…".
  - The related detail "P89 bounded realization … not reopened as a missing mechanism for this target" / "本目标" calls the record a target and carries a round marker. Fix: drop "P89" and write "this question" / "本问题".
- **07's new item:** "It is a question, not a goal" clashes with the record page, which shows kind "target" and the shared boundary "a separate open target". Fix: "It stays open:".

---

**8. "Renewal" still has two senses in the glossary**

File: `GLOSSARY.md`

- **Why it is wrong:** the revised row "renewal, renewal without end (复生, `«生生»`)" (01 §6: a line started by another) sits beside "renewal, consumption" (02 §3 `#renewal`: what a formation draws on is given back), which has a different sense and home. ONE-PAGE uses both senses in one paragraph.
- **Fix:** name 02's sense "renewal of a condition, consumption" and add "Not 复生 (01 §6)", or add the reverse "Not…" note to the 01 row.

---

**9. "unmarked" / 不加标记 uses a word the theory has already defined**

Files: 01 §6 D1, the overview (both editions) and `one_sense.py`.

- **Proposed words:** "The theory reads 生生, unmarked, as…" and "本理论把不加标记的生生读作…".
- **Why it is wrong:** "mark" is already a defined term here: the four marks 生住异亡, the gate as "a decided mark", and the 标 in `«两端分则中有标»`. The note itself says "plain 生生".
- **Fix:** "the theory reads plain 生生 (without guillemets) as…" / "本理论把不加 «» 的生生读作…".

---

**10. 06 §八's Chinese chains two colons and says the same thing twice**

File: `theories/becoming/chapters/06-CLASSICAL-TEXTS.md` §八

- **Proposed words:** "…所并恰是文同之状（[第三章]）：是[第三章之理]中守值之最粗者…".
- **Fix:** replace the second colon with "。它是[第三章之理](../../../../../../../theories/becoming/chapters/03-KNOWING.md#li)（步于其上同行之归并）中守值之最粗者，即值之类之理（[第一章 §4](../../../../../../../theories/becoming/chapters/01-ROOT.md#constancy-and-core)）；“文理”只在此义。"

---

**Checked and clean:**
- Every link in the added text resolves (files and anchors), including the new related id `what-the-dynamics-leave-open`.
- Every field in the current kit is within its cap: statement 297/91, title 44/11, next_delta 297/93, hypothesis 269/82.
- No public field carries a new date in YYYY-MM-DD form or a section sign.
- OPENING's body and the generativity chain are untouched.
- No edit cites Ren as warrant.
- The D1 and D45 AI labels are kept.

*Links in the quoted passages, written for the pages they propose text for, were rebased to this folder on 30 October 2026, and placeholder links `(…)` made plain; the text is otherwise as returned.*
