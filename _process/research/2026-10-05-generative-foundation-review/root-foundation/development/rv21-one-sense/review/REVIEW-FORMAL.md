# Formal correctness (review of the first draft, 30 October 2026)

One of three Opus lenses on the first drafts of kit/one_sense.py and lw-the-way-for-life/kit/upw_question.py ([combined.diff.txt](combined.diff.txt)); how each finding was taken is in [NOTE §4](../NOTE.md#4-the-review-and-how-each-finding-was-taken). The report as returned:

**Lens: formal correctness.** Five findings survived my own attempts to refute them. I checked three counterexamples in Lean, in a standalone file that copies the grammar's definitions: `Witness.lean (in this folder)`. It compiles with no errors and no `sorry`.

The rest checks out against the Lean:
- **The core of a class.** It is the coarsest constant class inside the class, by «根», «核为类» and «类有常当且仅当含于核».
- **«生生».** The overview's and 07's "In the grammar «生生» names only renewal without end" is exact against `Grammar.lean:253` (docstring: "as continuation and renewal only"). 07 §2's "holds on no configuration … only on the chain's" is backed by `ordered_not_renews`, `antichainLimit_not_renews` and `chainLimit_renews`.
- **The name readings.** «守理则不穷», «亡前理变» and «足以定理» read correctly as statements about the core (`GrammarRegularity.lean:86/118`, `Grammar.lean:584`).
- **06 §八.** The new text is correct in its own setting, a determined law (`Law.core_is_sameFuture`, `Law.coarsest_iff_core`).
- **Links.** Every new link resolves.

**1. 01 §4, the glossary's 理 row and NOTE §2: the core is called a 理 in every net, but that holds only along a determined law. This also creates a second sense of "goes alike".**
- **Proposed words.**
  - 01 §4: "Where `E` is a class, its core is a 理 in knowing's sense, a lumping the step goes alike across (here, a constant class), and the coarsest inside `E`".
  - Glossary: "A class's 理 is its core, the coarsest such lumping inside it".
  - NOTE §2: "whatever two configurations it lumps become configurations it lumps, so it is constant under the step".
- **Why it is wrong.** In 03 and in the grammar, "goes alike" is «同行» (`R˘;E;R ⊆ E`). 03's `GoAlike` is «同行» at each move (`goAlikeUnder_iff_alike`), 01 §7 says so in its Lumping bullet, and 06 §八's new text writes 同行. Constancy («有常») is a different relation. The two coincide only where the successor is fixed and every occurrence has one:
  - `GrammarLaws.lean:1311` «有常局定后则同行» needs the successor fixed.
  - `GrammarLaws.lean:1333` «同行可续则有常» and 1340 «同行遍后则有常» need a successor available.
  - 1352 «同行当且仅当有常» needs both.
  
  The note's "so" skips the availability step. The 01 parenthesis turns "goes alike" into constancy, which contradicts 01 §7. 01 §4's own words admit the gap: "In a branching net a successor under E can leave the core where another keeps it".
- **Counterexamples (Lean-checked).**
  - Branching net `0→1, 0→2`: the core of identity is identity, and it does not go alike (`core_ident_not_goAlike`). So the core is not always a lumping the step goes alike across.
  - Net with an ending, `0→2` only: the class lumping {0,1} goes alike, but 0 and 1 lie apart in its core (`cls_goAlike`, `cls_not_in_core`). So the core is not always the coarsest such lumping.
- **Fix for 01 §4.**
  - First: "Where `E` is a class, its core is the coarsest constant class inside `E` (`«根»`, `«核为类»`)."
  - Then, as a theorem on a fixed successor that every occurrence has, citing «同行当且仅当有常», «有常定后则同行» and «类同行遍后则含于核»: "there constancy is going alike, so the core is a 理 in knowing's sense, the coarsest lumping inside `E` the step goes alike across: the 理 of `E`. In a branching net the core need not go alike, and where an occurrence has no successor, a class can go alike without lying in the core."
  - Drop "(here, a constant class)".
- **Fix for the glossary.** Add "under a determined step" to the 理 row's second sentence.
- **Fix for NOTE §2.** Replace its "so" with a citation of «同行当且仅当有常».
- **Further suggestion.** The class↔lumping identification is itself a reading. 03 §6 says a lumping is a map, and 03 notes that naming the classes "would take `Quot.sound`". So say "a class, a lumping read relationally", or move the sentence out of the Theorem paragraph.

**2. NOTE.md §2–§3 and the glossary's 理 row: wrong scope for the theorem names, and a wrong account of the grammar's class.**
- **NOTE words.**
  - "where the grammar's class is not a lumping (类同 need not be transitive)".
  - "No Lean name: each … reads 理 as a class's core".
- **Why it is wrong.**
  - «类» is an equivalence relation by definition (`Grammar.lean:84`; the glossary says "an equivalence relation"). What need not be transitive is «同于» (`GrammarReadings`, «同于不必传递»), which is not «类».
  - «守理则不穷», «守理之线不亡», «亡前理变» ("For every relation `E`", `GrammarRegularity.lean:117`) and the definition of «足以定理» all take any relation `E`, not a class. Their 理 is a 理 in 03's sense only where `E` is a class and the step is determined (finding 1). Elsewhere it is the core of an arbitrary relation, which is the residual second sense.
- **Fix.**
  - NOTE: "where `E` is a relation that is not a class (the core and these names take any relation; 墨经's 類同 read as «同于» need not be transitive)". State the residue plainly: "for any other `E` the names speak of its core, which is not a 理".
  - Glossary: "the grammar's names that write 理 (…) are stated for every relation and mean its core".

**3. 06 §十 "无损之复返（有不息而无生生）" and the NOTE's verdict on it.**
- **NOTE words.** "In the grammar's terms the parenthesis would be false: … a lossless return that renews nothing ceases".
- **What holds.** The cited half is true (`Grammar.lean:643` «自不复生则息»).
- **What is missing.** Ceasing («息») and «生生» are said relative to a class, and the parenthesis names none. A lossless return can renew at a class's grain: the four-cycle `0→1→2→3→0` with classes {1,2} and {3,0} holds «生生» at 0 (Lean-checked, `cycle_renews`). On that branch the parenthesis fails through its "无生生", not through «自不复生则息».
- **The live-text problem.** 06 §十 says "在脊柱上" (on the spine) and writes 不息 plain. The kit's 06 §三 edits leave plain 息 in the formal sense in the very sentences they mark: "`«生生»` 是持续复生之最大之族，息是其归纳之对偶" and "`«生生»` 即某一支上之延，息即诸支皆尽". So within 06, plain 息 now carries both the formal and the corpus sense, and the §十 phrase reads as a false grammar statement.
- **Fix.**
  - In those two 06 §三 sentences, write `«息»`.
  - In 06 §十, write "无损之复返（语料所谓“不息”而无“生生”）".
  - In the NOTE: "«息» and «生生» are said with a class: at a class under which the return renews nothing, its occurrences cease («自不复生则息»); at a class cutting it into parts, it can renew without end. Either way the parenthesis is not a grammar statement."

**4. The glossary's new 生生 row: wrong home, and C's comparison folded into the definition.**
- **Proposed words.** "life in the whole and its continuing generation, compared by widening what can form: for life, the way (T8) … | [07 §8](../../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#theses)".
- **Why it is wrong.**
  - 生生 is defined, with its pinyin, at 07 §2 (line 73, under anchor `order`: "生生 (*shēngshēng*) names life in the whole and its continuing generation"). §8 is the thesis that uses the word.
  - The row turns the comparison (C's role) and T8's verdict into the word's sense without naming the two premises. AGENTS.md says to name both wherever the ethics is summarized, and to hide no weight in a definition.
  - 07 §2 also says 生生 "can exceed what widening counts".
- **Fix.** "| 生生 (*shēngshēng*) | life in the whole and its continuing generation; T8 takes it as the way for life, compared by widening what can form, with the condition for scope and C for order. Neither the grammar's `«生生»` … | [07 §2](../../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#order) |".

**5. The record `universal-practical-warrant.json`: its last sentence says more than the cited result, and the record does not link to its evidence.**
- **Proposed statement (en).** "Neither logic nor the represented dynamics gives the condition such a warrant".
- **Why it is wrong.**
  - `ReadsOnlyDynamics.not_entails` needs "where there is a standpoint and a formation", which 07 keeps and the record drops.
  - The zh text says 单凭 ("alone") and the en does not.
  - The record's `related`, `dependencies` and `proof_bindings` name no record carrying this result. The results are `what-the-dynamics-leave-open` and `bounded_rival`.
  - 07's home item keeps "as one account of ends, selection, knowing and revision within becoming", which the record's statement drops. Statement and home section should match.
- **Fix.**
  - en: "Where there is a standpoint and a formation, neither logic alone nor a satisfiable statement reading only the represented dynamics entails the condition, so such a warrant, where it would ground the condition, comes from neither alone; neither shows that none exists."
  - Add a `related` entry for `what-the-dynamics-leave-open`, noting `bounded_rival`.
  - Make the two statements match in substance.

*Links in the quoted passages, written for the pages they propose text for, were rebased to this folder on 30 October 2026, and placeholder links `(…)` made plain; the text is otherwise as returned.*
