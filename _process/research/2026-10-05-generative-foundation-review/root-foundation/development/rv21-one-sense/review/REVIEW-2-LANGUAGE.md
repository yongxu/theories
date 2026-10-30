# Second round: language

30 October 2026. The second-round check of the revised kits, the language lens (one Opus reader, read-only), as returned. How each finding was taken is in [NOTE §5](../NOTE.md#5-the-second-round).

Eleven findings survived my attempts to refute them, most severe first.

**1. The core is called a 理 for every relation, but `«核为类»` only holds for classes**
- **Files:** `theories/becoming/chapters/01-ROOT.md`, new §4 paragraph; `GLOSSARY.md`, 理 row; `NOTE.md` §2.
- **Exact words:**
  - 01: "The names below that write 理 (…) are stated for the core of every relation, and mean a 理 only along such a step."
  - Glossary: "are stated for every relation and mean its core, which elsewhere need not be a 理".
  - NOTE: "That is a 理 only along such a step."
- **Why:**
  - `«核为类»` needs `«类» E` (Grammar.lean:391). For a relation that is not a class, the core need not be a class, so it is not a lumping even along such a step. For example, with `E` empty the core is empty, which is not reflexive. `«守理则不穷»` and `«亡前理变»` take any `E`.
  - Formal finding 2 said "a 理 in 03's sense only where `E` is a class and the step is determined". The revision dropped the class condition.
- **Fix:**
  - 01: "…and mean a 理 only where `E` is a class and the step is such."
  - Glossary: "…mean its core, a 理 only for a class along such a step."
  - NOTE: the same.

**2. "A step that is fixed and always continues" gives two defined words a second sense**
- **Files:** 01 §4, new paragraph (label "(root; a step that is fixed and always continues)", body "Along a step that is fixed and always has a successor"); `GLOSSARY.md`, 理 row ("Along a step that is fixed and always continues"); also NOTE §2 and the REASON string in `repoint_os.py`.
- **Why:**
  - "Continues" is the defined 续: the glossary's continuation row says "`y` continues `x` under `E`". Here it means "has a successor", with no class.
  - "A fixed law" already means an unchanging law (02-MAP.md:85).
  - The Lean says "the successor is fixed" (`«定后»`, GrammarLaws.lean:690), and so does 07-SIGNIFICANCE.md:104. 01 §4 itself says "along a determined law".
  - "Going alike" is used in §4 but only defined in §7, and the paragraph does not link to it. Language finding 1's suggested link was not added.
- **Fix:** in all three places write "where the successor is fixed (`«定后»`) and every occurrence has one", and write "constancy is [going alike](../../../../../../../theories/becoming/chapters/01-ROOT.md#r-master-laws-on-the-grammar)".

**3. The new "Theorem" is a hand composition, but it is labelled as if Lean proves it**
- **File:** 01 §4, new paragraph: "so the core of a class is the coarsest class inside it that the step goes alike across (with `«根»` and `«核为类»`)".
- **Why:**
  - No Lean declaration states this at the root. It is composed by hand from `«同行当且仅当有常»`, `«根»` and `«核为类»`. The "coarsest" half also needs `«同行遍后则有常»` with `«根»`'s maximality, or `«类同行遍后则含于核»` with `«核之单调»`.
  - AGENTS.md: "Claims say exactly what the Lean proves"; hand arguments do not replace Lean. 01 §6 marks such steps "(a hand step, not stated in Lean)".
- **Fix:** add "(a hand composition of these laws, not stated in Lean; `«类同行遍后则含于核»`, `«核之单调»`)". Optionally note that on a determined law `Law.coarsest_iff_core` (GrammarCourse.lean:156) states the value-class case.

**4. 08's table of words in one sense now uses "generation" in two senses in one row**
- **File:** `theories/becoming/chapters/08-METHOD.md`, the "generation" row. The new "Not" cell reads: "生生, life in the whole and its continuing generation (07), which generation at two orders does not give".
- **Why:**
  - The row says "generation" means 02's 生成. The same cell glosses 生生 with "generation".
  - The Chinese editions pair that English word with 生发, not 生成: "持续的生发" (overview zh line 46) and "生发产生生发" (line 156). That is the fix the revision itself made for language finding 5.
  - Language finding 3's proposed fix had no gloss here. The kit added it.
- **Fix:** "…; 生生 (07), which generation at two orders does not give". The glossary's new 生生 row uses the same gloss, so add "nor 02's generation (生成)" to its "Neither …" clause.

**5. Formal 生生 is still written plain in record zh fields, including the law the kit edits**
- **Files and words:**
  - `continuation-relative-to-a-class.json` laws[11].zh: "生生是每一员皆复生至族中一员之最大之族，在此族中者不息（生生不息）". Only the en of this law is changed.
  - The same record, laws[7].zh: "生生是最大之族，…；生生必复生".
  - `generation-and-degeneration-at-two-grains.json` laws[7].zh: "在“一”之下沿复生至而读，生生即某一支上之延，息即诸支皆尽". This is the sentence the kit marks in 06 §三.
- **Why:** the decision says the formal sense is always `«生生»`. NOTE §1 says "Every other plain use in the live texts is the ethics' sense or a quotation", which is false here.
- **Fix:** write `«生生»` and `«生生不息»` in these three zh strings (and `«息»` where 06 now marks it), add them to `RECORD_EDITS` with the existing wording-only notes (one new note for generation-and-degeneration-at-two-grains), and correct the NOTE sentence.

**6. The review reports add 12 broken links, so `make research-links` will not show 0 broken**
- **Files:** `rv21-one-sense/review/REVIEW-FORMAL.md` lines 58 and 63; `REVIEW-LANGUAGE.md` lines 27 (two), 63, 83, 93, 139 (two "…"), 140 (two); `REVIEW-SENSES.md` line 38.
- **Why:** the paths.py classifier gives these files the role `live`. `research.py links --paths <rv21-one-sense>` reports 12 broken: 11 missing-path, 1 missing-anchor. Their quoted proposed passages carry links written relative to the chapters or the repository root, plus "[…]" placeholders.
- **Fix:** put the quoted proposals in code spans or blocks, or rebase their links to the review folder as `one_sense.py`'s `rebase()` does; turn the "[…]" placeholders into plain text.

**7. Senses finding 3 was taken only in part: the record's Progress section still leads its public page**
- **File:** `universal-practical-warrant.json`.
- **Why:**
  - For an open target, registry.py renders `progress` first ("what is already connected comes first"). So under "Question: whether…" the page shows seven practical-judgment lines.
  - The history note, which is folded, says "none bears on whether such a warrant exists".
  - The review asked for that sentence in `validation_scope` as well. It is only in history (`validation_scope` is at 594/600 en).
- **Fix:** shorten `validation_scope`, for example replace the list "(elective concern, … ethical learning)" with "(named in the canonical source)", and add: "The progress lines are the earlier target's work on practical judgment, now the goal's; none bears on whether such a warrant exists." The zh is at 150/260, so it has room.

**8. Target wording is left in two other records**
- **positioned-positive-reason.json** (chapter 7, live, listed in the goal's result_ids), related detail:
  - en: "the stronger universal practical warrant without added normative premises remains open"
  - zh: "…普遍实践根据仍为开放目标"
  - Fix: add it to `upw_question.py`'s OTHER_RELATED with a history note. en: "whether a universal practical warrant binding every possible mind exists, with no added normative premise, stays an open question". zh: "是否存在无附加规范前提、对一切可能心智都有约束力的普遍实践根据，仍是开放问题。"
- **conditional-foundation-assessment.json**: "does not finish the stronger axiom-free normative target". Senses finding 2 named this record. It is superseded, so leaving it is right, but NOTE §4 claims every finding was taken without saying so. Fix: one clause in NOTE §4, "left: superseded".

**9. Smaller wording faults**
- **06 §三, inconsistent marking:** within the one edited sentence, "`«息»` 是其归纳之对偶" is followed by "线上无物复生者息（`«不复生则息»`…），一之类下皆息". The grammar's 息 is marked once and left plain twice. Fix: mark both (`«息»`), or leave all plain, since §十 now says "语料所谓“不息”", and drop the NOTE's rationale.
- **upw hypothesis (en):** "Left open by the goal of practical judgment for life, on the fewest premises; …" reads as if "on the fewest premises" modifies "left open". The zh quotes the title. Fix: 'Left open by the goal "Practical judgment for life, on the fewest premises"; …'.
- **navigation.py:** "The open question `universal-practical-warrant` and the independent target `wisdom-root` remain open" repeats itself. Fix: "The question `universal-practical-warrant` and the independent target `wisdom-root` remain open."
- **Glossary 生生 row:** "T8 argues it as the way for life" is not idiomatic. Fix: "T8 argues that it is the way for life, compared by widening what can form, with the continuation condition for scope and C for order."

**10. Two record fields already over their soft caps get longer (warnings, not errors)**
- `continuation-relative-to-a-class` laws[11] en goes from 521 to 525 characters (cap 420).
- `projection-carrying-a-law` correspondence goes from 1236 to 1268 en (cap 1200) and from 554 to 560 zh (cap 500).
- Fix (optional): en "…this says when it carries a law: when it is a 理."

**Checked and clean:**
- **Main fields:** the restated record's title (44/11), statement (178/56), next_delta (379/117), hypothesis (163/56) and does_not_show item (225/56) are within caps; style.lint finds nothing new and no process marker in public fields.
- **Links in the edited texts:** every link and anchor in the kits' edits resolves, and the NOTE's links resolve.
- **Ethics:** the ethics' two premises are named where it is summarized (the glossary row, ONE-PAGE.zh); no edit says it derives from the condition.
- **Labels and Ren's voice:** the AI labels (D1, D45, D49, D63) are kept, and no edit touches OPENING's body or the generativity chain.

*Links in the quoted passages, written for the pages they propose text for, were rebased to this folder on 30 October 2026, and placeholder links `(…)` made plain; the text is otherwise as returned.*
