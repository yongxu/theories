# Coding task: referents a wording introduces that its Lean statement lacks

You are one of two independent coders in a measurement study (codebook v1, frozen before coding). Work alone; read only the packet you are given; never look for other coders' answers or for any other text.

Each item ("segment") is one wording of a formal law: either a clause of a book in plain classical Chinese, or a clause or statement in English. With it you get L(D): the Lean statement(s) the wording states. For each declaration: its binders (name, type, the sort assigned from a registered table as a hint, and whether it is a hypothesis, a decidability instance or a type parameter), its conclusion, the ∀/∃ nested in the conclusion, and one level of unfolding (U1) of the constants its type uses (their binders and bodies, or a structure's fields).

PASS tells you which pass this packet is:
- TABLE pass: the item carries the KEY: for Chinese, the adopted sense of each name of the book's name table found in the segment (所名) with its Lean anchors; for English, the glossary meaning and anchors of the terms found. Read the names in that adopted sense.
- NAIVE pass: no key. Read the wording as an untrained reader would, in the plain classical or plain English sense of its words, and code what that plain sense introduces.

Code every segment by the rules below. For each referent you count, give its span (the exact words), its sort, and either the counterpart it matches in L(D) (with the rule M1–M6) or its excess class (A, R or E) with tags. List the omissions (O: binders and hypotheses of L(D), including decidability instances and type parameters, that the wording does not render; give their names), the connective mismatches (S), and predicate excess (P). Counts are computed from your lists, so list each distinct referent once.

The rules, verbatim from the frozen design:

## From §2: the Lean statement

**The Lean statement L(d)** for each declaration d. Its referents are:

1. every binder of d's elaborated type, whether explicit, implicit or instance, including binders introduced by `variable`;
2. every variable bound inside the conclusion by ∀, ∃ or λ;
3. every term the statement forms by applying a constant to these, such as `w.web.level t x` or `π d`;
4. for each `Becoming.*` constant occurring in the type, one level of unfolding (U1): the binders and terms of its definition body.

Sensitivity runs use U0 (no unfolding) and U2 (two levels). For a `def` or `structure` cited in a 證, L is its binders plus its body or fields.

**Sorts.** Each referent gets one sort from a table reviewed once before scoring:

- relatum or role (types F and C, and elements of them);
- configuration (S);
- step (a `Nat` used as the index of a web field, a run or a history);
- amount (any other `Nat`);
- history or run;
- claim or predicate;
- map, lumping or feature;
- class of functions;
- law or process;
- world, web or flow;
- family or list;
- value;
- standpoint;
- significance.

Separately, each referent is classed as a hypothesis (a non-dependent `Prop` binder), a decidability instance, or a type parameter.

## 3. Coding rules (codebook v1)
### Referents
A referent is any expression in the segment that denotes something within the unfolding as represented, of any sort: a relatum, role holder, collection, state, step, amount, history, law, map, claim, value or agent.

- **Chinese:**
  - names from the name table, and the 37 words of `symbols-not-adopted.tsv`;
  - 者 and 所 nominalizations;
  - nouns, deictics (此, 彼, 其, 之, resolved to their antecedents), variables and numerals.
- **English:**
  - noun phrases, pronouns (resolved), variables and numerals.
- **Not counted:**
  - zero anaphora and dummy subjects (it, there);
  - quantifier words (凡, 皆, 莫, every, any);
  - connectives (恰当, 则, exactly where, if).

Count distinct referents per segment: two mentions of one referent count once.

### Matching (a referent has a counterpart if any rule applies)
- **M1 direct.** It denotes a binder, a bound variable or a constructed term of L(D). Use the name table's 所名 and 锚 columns for Chinese, and the glossary anchors for English.
- **M2 role.** A role nominalization (待者/所待, formation/condition, 读者/所读, taker/giver) of a relatum present in L(D) matches that relatum. If the relation defining the role is absent from L(D), code a predicate excess (P), not a referent excess.
- **M3 collective.** 兼, 诸物, the whole, the family or the world matches a binder of collection, type or world sort. Without one, it is excess R, tagged *ground*.
- **M4 quantity and step.** These match `Nat` terms of the right sort.
- **M5 unfolding.** A referent matches if it lies in the U1 body of a constant occurring in d's type.
- **M6 constructed examples.** In an 有例 or "for example" statement, a referent matches the witness constants of the construction (U1).
- **Sort preservation.** The counterpart must have the same sort, or an allowed coarsening from the registered table (for example, "relatum" matches formation or condition, and "observation" matches a coupling relation). A match across sorts, such as a "rival claim" mapped onto a history, counts as excess, and the Lean referent counts as omitted.

### Classes of excess
- **A (agent):** a referent presented as acting, perceiving, knowing, choosing, intending or owning, or any personal referent (人, 我, 吾, 君子, 知者, we, one, the observer, the learner). An exception: 我, 己 and 方 match the standpoint binder where one exists.
- **R (relatum):** a participant in the unfolding that L(D) lacks: an environment, another party, a third, a container, the rest.
- **E (entity):** a reified abstraction: knowledge, truth, nature, order, a law where L(D) has none, a "rival claim", 道 or 理 taken as a substance.

Tags on excess referents follow the four non-relational layers (CIV §四·三): *ground*, *nature*, *centre/will* and *rank*. Further tags mark referents in negated scope (*neg*), inside a reading (*reading*), and on the inherited-sense hazard list (*hazard*).

### Excluded from counting
- **META:** references to the text, the theory, Lean, a section or 條 number, 本书, 本篇, this law, the representation.
- Quotations (「…」 with 〔…〕).
- Lean names inside the wording.

### Secondary codes
- **O (omission):** binders and hypotheses of L(D), including decidability instances (定然否) and type parameters, that the wording does not render. A structure binder counts as rendered if any of its fields is mentioned. A target left implicit in a predicate ("couples in", with no stated target) counts as not rendered. O-rate = O / (binders + hypotheses).
- **S (connective mismatches):**
  - ↔ rendered in one direction only, or as plain "is";
  - ∀ rendered as a generic or habitual statement;
  - ¬¬ rendered as a plain assertion (not 不可非 / "cannot be refuted");
  - ∃ rendered as ∀;
  - a negation whose scope has moved;
  - a hypothesis rendered as a conclusion.
- **P (predicate excess):** an agentive or intentional predicate attached to a matched referent (seeks, tests, wants, 求, 欲) with no counterpart relation. P is reported apart from X.

### Two passes
- **X_table (primary).** Coders have the code's key: the name table's adopted senses for Chinese, the glossary for English.
- **X_naive (secondary).** Coders read without the key, as an untrained reader would, and code what the plain classical or plain English sense introduces. X_naive − X_table is the inherited-sense load.

### Worked examples
These are AI calibration codings for the codebook, not results.

1. **九·十二 against `Web.Excludes.not_of_alike`.**
   - The Lean statement has: F and C, W, `obs`, g, l, l′, a claim, t, the hypotheses `meets` and `alike`, and U1 of `Excludes` and of `AlikeThroughUpTo`.
   - The 經 clause 「如此辞之一历缘其感至此步与所然无异，则此辞于此不见去」: 辞 = claim; 一历 = l′; 其感 = `obs` at g; 此步 = t; 所然 = l. X = 0.
   - The English clause "a claim and its rival must differ where something couples in": "its rival" is a claim, and L has no second claim, so it is excess E (sort mismatch). "Something" matches a coupled condition by U1. X = 1. O includes the formation (only implicit) and the step.
2. **七·三 against `determines_lumped_iff`.**
   - The 經 renders 一族 (List), 定然否 (`DecidableEq K`), 相异之二 (`two`) and 恰当 (↔). X = 0, O = 0.
   - The English clause "Finite data fix an untried value exactly where it is lumped with an observed input" gives X = 0. O = 3: the class of functions lumped by π, the two values, and decidability. Its connective is right.
3. **X_naive on 運 (一·一).** The name table strips 「同段所设之推动者」. In the table pass X = 0. In the naive pass, a reader of 「天其運乎」 may posit a mover: excess A, tagged *centre/will*.

## Clarifications (v1.1, from the calibration; they override nothing above, they settle its ambiguities)

1. Variables, numerals and terms formed in L(D): before coding a variable, numeral or arithmetic expression as excess, check the binders, the nested ∀/∃ and the terms the conclusion forms (e.g. `2 ^ n - 1`, `l.length`, `k`); it matches (M1 or M4) if any of them denotes it. A numeral inside a stated example matches the example's witness (M6).
2. The naive pass reads plain senses; it does not penalize unfamiliar words. A word matches when its plain sense denotes something of the counterpart's sort, whether the word is a coined name or a common one. It is excess only where its plain sense introduces a referent of another sort or one L(D) lacks: an agent, a container, a substance, a ground, a third party. (运 read as implying a mover: excess A. 感域 read as "the domain one senses": still a set of relata, matched.)
3. Talk about names is META and is not counted: where a name comes from, which senses it carries or does not carry (所不带, 不带, 不取), the parallel texts and their kinds (对照; 相合/定域/相分 lines with the persons and doctrines they mention); likewise in English, talk about the vocabulary.
4. Omissions, by procedure: go through every binder of L(D) in order (type parameters, instances, variables, hypotheses) and list it unless the wording renders it. A variable is rendered by a matched referent; a type parameter when any element of that type is mentioned; a decidability instance only by 定然否 or an explicit "decidable / decided"; a hypothesis when its content is stated as a condition. List each omitted binder once, by name.
5. R or E for an excess referent: R is a participant of the unfolding as represented that L(D) lacks (a relatum, formation, condition, another party, an environment, a container, the rest); E is everything else excess (a reified abstraction; an excess step, amount, value, history, law or claim).
