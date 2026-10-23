# Decisions for the second round of the eight chapters

Board item RA, 23 October 2026. The first drafts of `theories/becoming/chapters/01-ROOT.md` … `08-METHOD.md` were reviewed three ways: per chapter against records and Lean, by one reader of all eight for coherence, by one critic per chapter for material the old chapters carry and the drafts do not, and by an independent cross-model review of each chapter. These decisions settle what the reviews found in common; the [spine](SPINE.md) is amended to match. Every fixer applies them.

## 1. Every theorem sentence says exactly what the Lean proves

The cross-model reviews found the same fault in every chapter: theorem sentences that drop an operative hypothesis, change a quantifier, turn a negative constructive conclusion into an existential one, or cite a neighbouring declaration of different strength. The rule:

- A sentence labelled **Theorem** carries every hypothesis of the declaration it cites that changes what holds (finiteness, listing without repetition, decidedness, balance at the steps used, a supplied bound, an initial condition, a nonzero or strictly positive condition). A hypothesis may be named by a short defined phrase, never dropped.
- Quantifiers as in Lean: "for every law and every pair of acts" is not "for this pair"; "exactly where" only for an `↔`.
- A constructive negative stays negative: `¬ ∀ …` is "not every …", not "some … fails".
- Each cited declaration is the one whose statement matches the sentence's strength; where the sentence summarizes two, cite both.
- A periphery result names its axioms (`propext`, `Quot.sound`, `Classical.choice`) as its record reports them.
- A witness (a constructed example) is labelled as one: "**Theorem** (…; witness)".

## 2. Description and explanation

The grammar's theorems are about every relation and class. That reading a subject as continuation relative to a class *explains* how it goes on is the theory's claim, argued from the laws on the models, not a theorem of the grammar; and that every becoming has a faithful representation in the grammar is open. Openings say this at the first claim of sufficiency (01, 02), not only at the end. "The core" is the greatest symmetric relation inside a class that the relation never tells apart (the greatest matching relation); "what continues of its own" is its reading [AI reading]. The flame witness distinguishes descriptions: it does not derive combustion.

## 3. Words in one sense

| Word | Sense | Not |
|---|---|---|
| 无明 | seeking locked onto a target that cannot be met at rest; the position every formation selects from grounds it and is not it (D25, D26, D45). Home: 03 §8 | "what lies beyond what couples in" (that is the reach of a selection, not 无明) |
| 明 | coupling joined to a selection, so it reaches what support does not mark (D26, D45) | |
| generation | 02's 生成: a pattern going on through carrying renewal; and, in 07, 生生 as life in the whole and its continuing generation | arising. Records whose titles use "generation" for arising (`generation-is-replenishment`, `unceasing-generation-needs-renewal`) are stated as laws of *arising* and linked by title |
| 生 | the mark "begins" (01) | "what lives and arises" |
| the core | 核 (01) | the Lean package: write "the pure core" |
| base | the base of a label: root, any process, World, periphery, or a named model | "the old base": write "the World model" |
| view | process, frame and world are views of one unfolding | "readings" (a reading is an interpretation, labelled) |
| condition | a relatum's role, or the continuation condition | a law's local premises: write "hypotheses" |
| selection | goes through couplings (03) | a subset of the World premises: write "a choice of premises" |
| standing | the standing of a result (08); a level stands, comes to stand, ceases to stand (02) | graded significance: write "a positive grade" |
| center | a formation as a standpoint (07 §1) | where a formation's acts return: say that |
| widening | what can form is widened (07 §2) | "generative" |

## 4. Labels

The spine's labels, plus:

- **Assessment.** A scoped evaluation with evidence and no Lean (records of kind `assessment`, published methods read against the laws, empirical tests); it states what was evaluated and against what. An assessment is not also a reading; where an interpretation is involved, label the interpretation separately.
- **Bases naming a model**: (World), (any process), (any type), (the Changes) for `Becoming.Hexagrams` and its sibling modules; a law shown by computing over a finite model is "**Theorem** (the Changes, by computation)".
- **Calibration** only where the need says something about the unfolding; a calibration of the logic alone is a lemma of the law that needs it, stated in its sentence.
- **New readings.** Write `[AI reading, new]`, never an invented D number, and list each in the report; the integrator registers them in the decision register and replaces the label.

## 5. Facts to state the same everywhere

- Read off one exchange: four tying premises hold by the reading; a census holds where a named family closes each step, and in every finite world, with participation listed without repetition; dissipation, embodiment and bounded transmission are states of the law.
- How much of the package is on the grammar: say "most modules" and link [the theory graph](../../../../theories/becoming/results/THEORY-GRAPH.md) rather than a number; a count from the checker names the receipt.
- Theses T1–T8 are stated in their home chapters; 08 lists each with its home link and nothing that disagrees with it.
- The ethics, wherever summarized: the continuation condition for scope, C for order, neither asserted.

## 6. Hand-overs

Each chapter's opening says in one or two sentences where it sits: what it takes from earlier chapters (with links) and what it hands on. In particular: 03 takes couplings and carried differences from 02 and hands pools to 05 and alignment to 07; 05 takes group selection from 04 and the margin from 02; 07 takes the margin from 02, the reach of a selection from 03 and pools from 05.

## 7. Moving results between chapters

Forty results change home (table in the packets). The receiving chapter states the result in its own section, in its own voice, with the anchor `<a id="r-<id>"></a>`, from the first-round text in the snapshot and the record; the sending chapter replaces the statement by one sentence and a link, and rewrites any section opening that announced it. Every link to a moved result points to its new home.

## 8. Length

Up to 12,500 words (06: up to 24,000 Chinese characters). Compress by tables and by sending detail to the records, never by dropping a result or a hypothesis.
