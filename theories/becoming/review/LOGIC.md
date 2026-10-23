# Review dossier L: logic

**What this is.** One part of the review packet of the Theory of Becoming, for readers in logic: relation algebra, coalgebra and bisimulation, constructive mathematics and modal logic. It sets out 29 items, each a definition or theorem of the theory's formal root or of its logical method, and asks whether each is correctly stated, correctly described in the chapters, credited where it restates known work, and stated at its exact strength.

**How it was made.** Everything in the theory was made with AI: the Lean proofs, the chapters, the readings of the classical texts and this dossier; no human has reviewed any of it. A script copied the Lean statements from the source files; the prose is AI-written and may be wrong. The [defects already found](../../../_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md) and the [review of the grammar against its sources](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/reviews/2026-10-23-sources-against-v10.md) (its Lean corrections are open as board item OU6) are cited under each item they concern. Under **Known weaknesses**, a bullet citing DEFECTS-FOUND, a review or a chapter reports a recorded weakness; one marked [this dossier, AI] is this dossier's own assessment, recorded nowhere else, for the reviewer to confirm or reject. The chapter reviews found one fault everywhere: Quote [_process/research/2026-10-05-repository-reconciliation/architecture/DECISIONS-ROUND-2.md]: "theorem sentences that drop an operative hypothesis, change a quantifier, turn a negative constructive conclusion into an existential one, or cite a neighbouring declaration of different strength". The chapters were then corrected against the Lean; whether the corrections are complete is part of what is asked.

**What the theory says of itself.** Quote [theories/becoming/chapters/08-METHOD.md]: "None of the central results is new mathematics: each is near-definitional or a known result restated." That verdict comes from an AI prior-art review of 20 October 2026 ([BECOMING-SIGNIFICANCE-REVIEW](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#ranked-table)), which read the ten central results of the earlier chapter before the grammar (Parts 1 and 2 below) existed; of the items here it covered only the premise ledger with its calibrations and the significance result of L-23. On the grammar, the judgments of prior art are the chapters' own credits at each result (01 §4 names bisimulation equivalence), the sources review's verdict that the operations are Tarski's relation algebra with Chinese names (L-01), and the credits this dossier states at each item, which the reviewer is asked to check.

**Conventions.** Lean paths are relative to `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/` unless they begin otherwise. Lean blocks give statements exactly, proofs cut at `:=`, definitions whole. *Root* means a theorem for every carrier, relation and class; *witness* a single constructed model; *calibration* a law proved equivalent to, or conditional on, an omniscience principle, which by the theory's own criterion ([08 §5](../chapters/08-METHOD.md#calibrations)) is a result only where it says what the need means for the unfolding: Quote [theories/becoming/chapters/08-METHOD.md]: "Only a calibration that says something of that kind is a result. One that concerns the logic alone is a lemma of its law."; *periphery* a proof outside the pure core, with its axioms reported. The grammar's Lean names are Chinese; the glosses are:

| Name | Gloss | Name | Gloss |
|---|---|---|---|
| `«际»` | relation `α → α → Prop` | `«续»` | continuation `R ⊓ E` |
| `«而»`, `«逆»` | composition, converse | `«相续»` | line: reach of continuation |
| `«合»`, `«非»` | meet, complement | `«有前»`, `«有后»` | has a predecessor, a successor |
| `«则»`, `«谓»` | inclusion, pointwise equivalence | `«生»`, `«住»`, `«亡»`, `«异»` | begins, abides, ends, alters |
| `«一»`, `«静»` | full relation, identity | `«有常»` | constancy `E˘;R ⊆ R;E˘` |
| `«及»` | transitive closure | `«核»`, `«位核»` | the core; the two-way core |
| `«类»` | equivalence relation (a class) | `«延»`, `«尽»` | coinductive going on; inductive accessibility (L-09) |

---

## Part 1. The grammar

<a id="l-01"></a>
### L-01 The calculus and its operations

```lean
abbrev «际» (α : Type u) : Type u := α → α → Prop

def «而» (R S : «际» α) : «际» α := fun x z => ∃ y, R x y ∧ S y z

def «非» (R : «际» α) : «际» α := fun x y => ¬ R x y

inductive «及» (R : «际» α) : «际» α
  | one {x y : α} : R x y → «及» R x y
  | more {x y z : α} : R x y → «及» R y z → «及» R x z

structure «类» (E : «际» α) : Prop where
  refl : ∀ x, E x x
  symm : ∀ {x y}, E x y → E y x
  trans : ∀ {x y z}, E x y → E y z → E x z
```

File: `Becoming/Grammar.lean`. **Meaning.** A relation is a Prop-valued two-place predicate on a type parameter; composition, converse, meet and complement are defined pointwise; reach is the inductive transitive (not reflexive) closure; a class is an equivalence relation. Theorems are inclusions or pointwise equivalences, never equations between relations, so neither propositional nor function extensionality is used. Equality on the carrier is declared a commitment of the model. The operations are those of Tarski's calculus of relations (Tarski 1941; Tarski and Givant 1987), with three departures: complement is intuitionistic, reach (not expressible in Tarski's calculus) is added, and the core (L-06) quantifies over all relations. **Standing and use.** Definitions; the base of every root theorem ([01 §1](../chapters/01-ROOT.md#one-kind-of-symbol)). The chapter: Quote [theories/becoming/chapters/01-ROOT.md]: "Every result is pointwise, so no extensionality enters, and the grammar imports only Lean's prelude." **Reading and class.** The Chinese names are read from classical sentence forms ([06](../chapters/06-CLASSICAL-TEXTS.md#three-relations)); no corpus unit is classified as this definition.

**Known weaknesses.**
- The review against the sources: Quote [_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/reviews/2026-10-23-sources-against-v10.md]: "The landed operations are Tarski's relation algebra with Chinese names."
- [this dossier, AI] The module header calls the calculus point-free; the operations have pointwise semantics, as relation algebra has in set relations, and no term syntax is fixed, so which expressions make up the point-free calculus is not stated.
- [this dossier, AI] With reach and quantification over relations, the method chapter's literature sentence, Quote [theories/becoming/chapters/08-METHOD.md]: "A pure relational calculus is as strong as three-variable first-order logic." does not describe this calculus.
- That sentence and the rest of 08 §6 on pairing and power have no standing of their own: Quote [_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md]: "pairing and power, mutual interpretation with Lean, and 'a type gives no dynamics' have no record and no Lean result." (DEFECTS-FOUND, 08; the first two are cited literature, not checked).
- What the calculus is said not to state. The grammar's relation being fixed, 01 says self-changing conditions (a pattern reshaping its own position and limits) and selection of selection cannot be stated ([01, Open](../chapters/01-ROOT.md#open)); the review adds history dependence and a time-varying law (§3–4). Limit (限) is defined nowhere, and the conflict relation of a net of possibilities is asserted in the module header and defined nowhere (review §4).
- [this dossier, AI] These are missing constructions, not shown limits of expressiveness: the relation is fixed, the carrier unrestricted. `continuationStep` already encodes a time-varying law `R : Nat → F → F → Prop` as one relation on `Nat × F`, and the pre-spine `historyProcess` (HistoryRealization, in `lean/deeper/`) history dependence as steps between complete histories. Missing are native operators or representation theorems; a non-expressibility claim would need an object language, admissible encodings and a preservation criterion, none of which is fixed.

**Questions.**
1. Which expressions would form the point-free syntax the header names, and what is the accurate name for the resulting calculus?
2. Which laws of relation algebra (Tarski's axioms, the Schröder rules, the modular law) hold for these operations with intuitionistic complement, which makes the algebra not Boolean (none are listed anywhere), and should the theory state them?
3. With transitive closure and quantification over relations, where does the calculus sit in expressive strength (relation algebra with star, Freyd and Scedrov's allegories, higher-order logic), and against which object language should the missing constructions be judged?

<a id="l-02"></a>
### L-02 Reach, precedence and co-presence

```lean
theorem «缘先果后当且仅当无环» (R : «际» α) : (∀ x y, R x y → ¬ «及» R y x) ↔ «无环» R

def «俱有» (R : «际» α) : «际» α := fun x y => «及» R x y ∧ «及» R y x

theorem «俱有为一念» (R : «际» α) :
    (∀ {x y}, «俱有» R x y → «俱有» R y x) ∧
      (∀ {x y z}, «俱有» R x y → «俱有» R y z → «俱有» R x z) ∧
      (∀ {x y}, «俱有» R x y → «俱有» R x x)
```

Files: `Becoming/Grammar.lean`, `Becoming/GrammarCandidates.lean`. **Meaning.** Without cycles reach is a strict order (`«无环则及为序»`); every condition strictly precedes what it conditions exactly where there is no cycle; mutual conditions are co-present (`«相由则俱有»`), and co-presence is symmetric, transitive, and reflexive on what it relates. These are standard graph facts: an acyclic relation's transitive closure is a strict order; mutual reach relates nodes on a cycle within one strongly connected component. **Standing and use.** Root theorems; the order of time is taken to be reach ([01 §1](../chapters/01-ROOT.md#one-kind-of-symbol)). **Reading and class.** Source [ZL-01-132]: "緣成由於果，以果後、緣先故。" classified 乙, outcome conditional (needs no cycle); Source [JSZ-P-07-029]: "雖則九世有隔不同，相由成立；" and Source [JSZ-P-07-030]: "融通無礙，同為一念。" classified 乙, outcome proved. The readings of these lines are for the Buddhist dossier.

**Known weaknesses.**
- Time and the four marks separate two occurrences alike in every relation only by equality on the carrier; the stationary-process witness is only in an unreceipted review script (`review-checks/V9.lean`). The plan still says time is defined by 缘 (review §5).
- Co-presence is mutual reach, not presence in time; the grammar has no relation of presence in time ([01, Open](../chapters/01-ROOT.md#open)).

**Questions.**
1. Is taking precedence as the transitive closure of an arbitrary condition relation, strict only where acyclic, a sound basis for an order of time (compare causal sets, which assume acyclicity)?
2. Is treating equality on the carrier as a commitment of the model a coherent stance in a type theory where every type carries an equality?
<a id="l-03"></a>
### L-03 Continuation as a meet of a relation and an equivalence

```lean
def «续» (R E : «际» α) : «际» α := «合» R E

theorem «任一缘可为续» {R : «际» α} {x y : α} (h : R x y) :
    ∃ E : «际» α, «类» E ∧ «续» R E x y

theorem «分叉» :
    ∃ (α : Type) (R : «际» α) (a b c : α),
      «相续» R «一» a b ∧ «相续» R «一» a c ∧ ¬ «相续» R «一» b c ∧ ¬ «相续» R «一» c b ∧ b ≠ c
```

File: `Becoming/Grammar.lean`. **Meaning.** `y` continues `x` under `E` where `R x y` and `E x y`. Coarsening the class keeps every continuation (`«粗化»`); every single condition `R x y` is a continuation under the class relating `a` and `b` where `(a = x ∨ a = y) ↔ (b = x ∨ b = y)` (classically, a partition into at most two blocks, the ends and the rest; constructively, membership in the ends is not decided); two alike conditions of one occurrence are both continued by it (`«蜡烛之合»`); continuation under the full class can fork so that line-sameness is not transitive. **Standing and use.** The centre of the root, used by every later chapter ([01 §2](../chapters/01-ROOT.md#r-continuation-relative-to-a-class)). **Reading and class.** [AI reading, D45]: the class is plural, after Source [MJ-S-089.4]: "有以同，類同也。" (classified 甲). The dilemma Source [ZL-01-031]: "若一則無緣，若異則無相續，後當種種破，是故復說不一不異。" is classified 己 (a rejection of the plan's thesis); it is the Buddhist dossier's.

**Known weaknesses.**
- Containment in the condition relation is necessary only: by that class, continuation cannot by itself tell a fire passed on from one fire ending and another lighting ([01, does not show](../chapters/01-ROOT.md#does-not-show)).
- The record's wording of the merge repeated an earlier ambiguity (DEFECTS-FOUND, second round, from chapter 01).

**Questions.**
1. Is the meet `R ⊓ E` the natural formal choice for *conditioned and alike*, against alternatives such as `E;R;E` or a named sub-relation of `R`?
2. Does this construction show that the admissible classes must be restricted (for instance, to classes definable without parameters), and is that a known problem for criteria of persistence?
3. Is this construction known, for example as genidentity (Reichenbach, Lewin) or a relational form of it?

<a id="l-04"></a>
### L-04 The four marks and coarsening

```lean
def «生» (R E : «际» α) (y : α) : Prop := ¬ «有前» R E y

def «住» (R E : «际» α) (x : α) : Prop := «有前» R E x ∧ «有后» R E x

theorem «四相无自立» {R : «际» α} (irr : ∀ z, ¬ R z z) {x y z : α} (hxy : R x y) (hyz : R y z) :
    «住» R «一» y ∧ «生» R «静» y ∧ «亡» R «静» y

theorem «两端分则中有标» {R E K P : «际» α} (hK : «类» K)
    (split : ∀ x y, «续» R E x y → K x y ∨ P x y) {x y : α} (line : «相续» R E x y) :
    ¬ K x y → ∃ u v, «续» R E u v ∧ P u v ∧ (x = u ∨ «相续» R E x u) ∧ (v = y ∨ «相续» R E v y)
```

File: `Becoming/Grammar.lean`. **Meaning.** Under a class, an occurrence begins where it has no predecessor under continuation, ends where it has no successor, and abides where it has both a predecessor and a successor. With `R` irreflexive, a middle occurrence abides under the full class and both begins and ends under identity. Ending under a coarser class implies ending under a finer one (`«亡于粗则亡于细»`); a beginning under a finer class continued under a coarser one is an alteration (`«生于细而续于粗则异»`); if every step either keeps `K` or carries `P`, a line whose ends `K` separates has a step carrying `P`. **Standing and use.** Root theorems ([01 §3](../chapters/01-ROOT.md#four-marks)). **Reading and class.** Not a corpus unit; the readings of 四相 are the Buddhist dossier's.

**Known weaknesses.**
- The marks are one-step notions: a flash both begins and ends, so they are no partition even where decided (01 §3 says so).
- In `«异»` the second class is not required to be finer (review §2).

**Questions.**
1. Is `«四相无自立»` correctly described by the chapter's statement (irreflexive `R`, the full class and identity) and by its gloss?
2. Are one-step predecessor and successor an adequate formalization of beginning and ending, given cycles and two-way infinite lines, where nothing begins or ends?
3. Is `«两端分则中有标»` a known discrete intermediate-value form, and should it be credited?

<a id="l-05"></a>
### L-05 Constancy never lets a continuation end

```lean
def «有常» (R E : «际» α) : Prop := «则» («而» («逆» E) R) («而» R («逆» E))

theorem «有常则续不尽» {R E : «际» α} (h : «有常» R E) {y : α} (hy : «有前» R E y) : «有后» R E y

theorem «有亡之续则不有常» {R E : «际» α} {x y : α} (hxy : «续» R E x y) (hy : «亡» R E y) :
    ¬ «有常» R E
```

File: `Becoming/Grammar.lean`. **Meaning.** `E` is constant under `R` where it is a one-way simulation: an `E`-mate of a node matches each of its steps by a step to an `E`-mate (`«有常之逐点»`). Then whatever continues something is continued, for every relation `E`, symmetric or not; a class under which some line ends is not constant. This is the standard fact that a simulation transfers the ability to step (Park 1981; Milner 1989), applied as the first weakness says. **Standing and use.** Root theorems ([01 §4](../chapters/01-ROOT.md#constancy-and-core)); they move the regularity of an ending line from its class to its core. **Reading and class.** None.

**Known weaknesses.**
- The proof applies constancy to the pair `(x, y)` itself, which is both `E`-related and `R`-related: the theorem says that a simulation relating a node to its successor propagates along the line. Found by the formal review of plan version 9 (F1), which moved the root to the core.
- Constancy warrants no class ([01, does not show](../chapters/01-ROOT.md#does-not-show)): Quote [theories/becoming/chapters/01-ROOT.md]: "identity is constant under every relation" (`«静有常»`). A class's being constant says only that it agrees with the relation, and the finest class always qualifies; this bears on Q2 and on the reading of the core (L-06).

**Questions.**
1. Is that description of the theorem and its proof accurate?
2. Does the name *constancy* fit a condition that no class of an ending line meets and that identity always meets?
3. Would a weaker notion (simulation restricted to pairs not related by `R`, or relative to a sub-relation) capture regularity of patterns that end, and is such a notion known?

<a id="l-06"></a>
### L-06 The root theorem: the core

```lean
def «核» (R E : «际» α) : «际» α :=
  fun u u' => ∃ S : «际» α, «则» S E ∧ «则» S («逆» S) ∧ «有常» R S ∧ S u u'

theorem «根» (R E : «际» α) :
    «则» («核» R E) E ∧ «有常» R («核» R E) ∧ «则» («核» R E) («逆» («核» R E)) ∧
      ∀ S, «则» S E → «则» S («逆» S) → «有常» R S → «则» S («核» R E)

theorem «类有常当且仅当含于核» (R : «际» α) {E : «际» α} (hE : «类» E) :
    «有常» R E ↔ «则» E («核» R E)
```

File: `Becoming/Grammar.lean`. **Meaning.** The core of `E` under `R` is the union of all symmetric relations inside `E` that are constant under `R`; it lies inside `E`, is constant and symmetric, and contains every such relation. For a class, the core is a class (`«核为类»`), and the class is constant exactly where it lies inside its core. This is the greatest bisimulation inside `E` (inside `E ∩ E˘` where `E` is not symmetric), built as the union of bisimulations, the last conjunct of `«根»` being the coinduction principle (Park 1981; Milner 1989; coalgebraically, Rutten 2000); for a class it is, classically, the coarsest stable refinement of `E` (Paige and Tarjan 1987; Kanellakis and Smolka 1990). **Standing and use.** Root theorem; the core is what testing approximates (L-12), what the flame witness of 01 §5 uses and, for a determined law read through a map, what knowing's 文 instantiates ([01 §4](../chapters/01-ROOT.md#constancy-and-core)). **Reading and class.** [AI reading, D65]: Quote [theories/becoming/chapters/01-ROOT.md]: "The core is what continues of its own, the regularity a line carries by itself." Not a corpus unit.

**Known weaknesses.**
- [this dossier, AI] At the theorem the chapter credits no prior result, Quote [theories/becoming/chapters/01-ROOT.md]: "So the core is the greatest matching relation within the class, and it always exists." The credit above is this dossier's.
- [this dossier, AI] The core is defined by an existential over all relations inside `Prop`, so its existence uses Lean's impredicative `Prop`; the pure-core discipline (L-19) reports axioms, not this.
- The flame witness that uses the core singles out nothing ([01 §5](../chapters/01-ROOT.md#fire-and-fuel); review §5): the joint class of its two descriptions is identity on the four moments, so Quote [theories/becoming/chapters/01-ROOT.md]: "the witness singles out neither the fuel nor a direction." The reverse dependence and the mutual need are argued by hand, not stated in Lean.

**Questions.**
1. Is the credit above accurate and sufficient, and is the restriction to `E ∩ E˘` stated correctly?
2. Does the existence of the core for every relation and class depend on impredicativity, and should that be stated as a commitment in a predicative or coinductive setting?
3. Does the mathematics support the D65 reading of the core?

<a id="l-07"></a>
### L-07 Closure and bisimulation equivalence

```lean
theorem «闭合当且仅当有常» (R : «际» α) {E : «际» α} (hE : «类» E) :
    «有常» R E ↔ «则» («而» («而» E R) E) («而» R E)

theorem alike_iff_core {next : S → S} {o : S → R} {s s' : S} :
    Alike (frameBy next o) (frameBy next o) s s' ↔ «核» (step next) (sameValue o) s s'

theorem core_iff_same_course {p : Nat → Prop} {s s' : Nat} :
    «核» Steps.next (Steps.alike p) s s' ↔ ∀ n, (p (s + n) ↔ p (s' + n))
```

Files: `Becoming/Grammar.lean`, `Becoming/GrammarCourse.lean`, `Becoming/Change.lean`. **Meaning.** For a class, constancy is exactly `E;R;E ⊆ R;E`: the stability of the partition `E` under `R` of partition refinement (Kanellakis and Smolka 1990; Paige and Tarjan 1987), that is, `E` is a bisimulation equivalence, as the module credits (Park, Milner). For a determined law read through a map, bisimilarity is the core of the value class (`Law.alike_iff_core`); along the steps, the core of *alike in `p`* relates two steps where `p` agrees at every pair of steps equally far after them. **Standing and use.** Root theorem and two instances; the chapter: Quote [theories/becoming/chapters/01-ROOT.md]: "For a class this is bisimulation equivalence, with the lumpability of Markov chains and computational closure as analogues not proved here." ([01 §4](../chapters/01-ROOT.md#constancy-and-core)). **Reading and class.** None.

**Known weaknesses.**
- DEFECTS-FOUND (01, what could not be stated well): Quote [_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md]: "For branching processes, 'constancy is bisimulation equivalence' is stated in Grammar.lean as a named correspondence, not proved." So likeness on processes ([01 §9.2](../chapters/01-ROOT.md#r-configurations-alike-by-relation)) and the core are joined by no theorem except for determined laws.
- Lumpability is probabilistic and computational closure concerns ε-machines (plan version 9 review, F12). Lumpability (Kemeny and Snell 1960; as probabilistic bisimulation, Larsen and Skou 1991) asks equal transition-probability totals from a block's members into each block, which nothing here expresses; both stay analogies, as the chapter says.

**Questions.**
1. In an intuitionistic setting, where a block's lying inside or outside a preimage is not decided, is `E;R;E ⊆ R;E` the right form of stability?
2. Should the correspondence for branching processes be proved before the chapter calls the core the familiar invariant on the models?
3. Is the chapter's wording of the two analogies accurate?

<a id="l-08"></a>
### L-08 The two-way core and positions

```lean
def «位核» (R E : «际» α) : «际» α :=
  fun u u' => ∃ S : «际» α, «则» S E ∧ «则» S («逆» S) ∧ «有常» R S ∧ «有常» («逆» R) S ∧ S u u'

theorem «位同则四相同» {R E : «际» α} (hE : «类» E) {y y' : α} (hk : «位核» R E y y') :
    («生» R E y → «生» R E y') ∧ («亡» R E y → «亡» R E y')
```

File: `Becoming/Grammar.lean`. **Meaning.** The two-way core asks constancy under `R` and its converse; it is the greatest such relation and lies inside the core (`«位根»`, `«位核含于核»`). Ending is invariant under the core, beginning under the two-way core (`«亡于核下不变»`, `«生于位核下不变»`). The two-way core is the greatest bisimulation inside `E` (in general `E ∩ E˘`, as for the core) for `R` and its converse together: bisimulation for the basic temporal language, with future and past: the standard notion of bisimulation (Blackburn, de Rijke and Venema 2001, §2.2) taken for a language with the converse modality (its §1.3), as that book leaves to its exercises. **Standing and use.** Root theorems ([01 §4](../chapters/01-ROOT.md#constancy-and-core)): Quote [theories/becoming/chapters/01-ROOT.md]: "A position is fixed by all its relations, before as well as after." **Reading and class.** None.

**Known weaknesses.**
- `«位同则四相同»`, whose name glosses as *same position, same four marks*, proves only beginning and ending (review §5); the chapter now says so.
- Two moments of a stationary process lie in one two-way core class and are separated only by carrier equality (L-02).

**Questions.**
1. Is that identification correct?
2. Should the theorem's name be changed to what it proves?

<a id="l-09"></a>
### L-09 The map at two grains: 延 coinductive, 尽 inductive

```lean
def «延» (R L : «际» α) (x : α) : Prop := ∃ S : α → Prop, S x ∧ ∀ z, S z → ∃ w, S w ∧ «续» R L z w

inductive «尽» (R L : «际» α) : α → Prop
  | mk {x : α} : (∀ y, «续» R L x y → «尽» R L y) → «尽» R L x

theorem «延尽不并» {R L : «际» α} {x : α} (h : «尽» R L x) : ¬ «延» R L x

def «生成» (R L E : «际» α) (x : α) : Prop :=
  ∃ S : α → Prop, S x ∧ (∀ z, S z → ∃ w, S w ∧ «续» R L z w) ∧
    ∀ z, S z → ∃ u v, S u ∧ S v ∧ «所及» R L z u ∧ «传» R L E u v

theorem «生守相杂» : «生成» fork «一» «静» .root ∧ «守» fork «一» «静» .root
```

File: `Becoming/GrammarMap.lean`. **Meaning.** 延 (glossed *goes on along some branch*) is coinductive: `x` lies in some predicate `S` each member of which has a continuation in `S`. It names no sequence of points; obtaining one is a dependent-choice step (the shape `runs_iff_dependentChoice` calibrates for processes, L-18; no such theorem for 延). 尽 (glossed *ends on every branch*) is inductive accessibility: the least predicate holding at `x` wherever it holds at every continuation of `x`. How it relates to *every path is finite* depends on branching, decidability and bar induction or the fan theorem, and is not stated here. The two exclude each other. Generation is such an `S` containing `x` with, ahead of every member `z`, a carrying renewal between members `u`, `v`, `u` reached from `z`; keeping, such an `S` with no carrying renewal between members. Where each occurrence conditions at most one other, they exclude each other (`«单行则生守不并»`); on a branching relation they can share a point. **Standing and use.** Root theorems; the regions generation, keeping, degeneration ([02 §1](../chapters/02-MAP.md#r-generation-and-degeneration-at-two-grains)). **Reading and class.** [AI reading, D65]: 生成 is continuation at two grains, not 生生.

**Known weaknesses.**
- The module's docstrings call `«全守»` keeping and `«有终»` degeneration, against the chapter (Quote [experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarMap.lean]: "Degeneration (退化): the coarse line from `x` reaches an end."), and the record misread the strong forms (DEFECTS-FOUND, second round, from chapter 02). The docstring of `«阶全生成»` says the classes are each finer than the next, which is not a hypothesis (review §5).

**Questions.**
1. Is 尽, inductive accessibility, the right constructive reading of *ends on every branch*, and under which hypotheses (finite or decided branching, decidable bars, bar induction, the fan theorem) should its relation to *every path is finite* be stated?
2. Is 延, a union of post-fixed predicates, the right coinductive reading where dependent choice is not assumed?
3. Are generation and keeping well defined as stated, and is the mixed region `«生守相杂»` the expected consequence?

<a id="l-10"></a>
### L-10 The strong forms and coverage

```lean
def «全生成» (R L E : «际» α) (x : α) : Prop :=
  «不穷» R L x ∧ ∀ y, «所及» R L x y → ∃ z w, «所及» R L y z ∧ «传» R L E z w

def «全守» (R L E : «际» α) (x : α) : Prop :=
  «不穷» R L x ∧ ∃ y, «所及» R L x y ∧ ∀ z w, «所及» R L y z → ¬ «传» R L E z w

def «有终» (R L : «际» α) (x : α) : Prop := ∃ y, «所及» R L x y ∧ «亡» R L y

theorem «全三域之周» (em : ∀ P : Prop, P ∨ ¬ P) (R L E : «际» α) (x : α) :
    «全生成» R L E x ∨ «全守» R L E x ∨ «有终» R L x
```

File: `Becoming/GrammarMap.lean`. **Meaning.** Three forms read the whole coarse line; they exclude each other pairwise, and with excluded middle every point lies in one. **Standing and use.** Root theorems ([02 §1](../chapters/02-MAP.md#r-generation-and-degeneration-at-two-grains)). **Reading and class.** None.

**Known weaknesses.**
- `«全三域之周»` takes excluded middle for all propositions, while the module header says Quote [experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarMap.lean]: "where going on and renewal are decided they cover every point" (DEFECTS-FOUND, 02).
- Coverage by the some-branch regions is open, and the chapter's counterexample is Quote [theories/becoming/chapters/02-MAP.md]: "(a hand check, not in the Lean)".

**Questions.**
1. Would local decidedness (of having a successor and of carrying renewal at each reached point) suffice for `«全三域之周»`, and is that its exact strength?
2. Is the hand counterexample to coverage by 生成, 守 and 退化 correct?
3. Do the names generation, keeping and degeneration fit regions that may not cover every point?

<a id="l-11"></a>
### L-11 Excluded-middle calibrations of the marks and the map

```lean
theorem «四相之定当且仅当排中» :
    (∀ (α : Type) (R E : «际» α) (x : α), «生» R E x ∨ «有前» R E x) ↔ ∀ P : Prop, P ∨ ¬ P

theorem «延尽之定当且仅当排中» :
    (∀ (β : Type) (R L : «际» β) (x : β), «延» R L x ∨ «尽» R L x) ↔ ∀ P : Prop, P ∨ ¬ P

theorem «全生有终之定当且仅当排中» :
    (∀ (β : Type) (R L : «际» β) (x : β), «不穷» R L x ∨ «有终» R L x) ↔ ∀ P : Prop, P ∨ ¬ P

theorem law_iff_em :
    (∀ w : World, w.Finite → (w.ArisingRecurs ↔ w.CeasingRecurs)) ↔ ∀ Q : Prop, Q ∨ ¬ Q
```

Files: `Becoming/Grammar.lean`, `Becoming/GrammarMap.lean`, `Becoming/Space.lean`. **Meaning.** Deciding, in every model, whether an occurrence begins or has a predecessor; whether a point goes on or ends on every branch; and whether a coarse line is without end or reaches an end: each is exactly excluded middle. **Standing and use.** Calibrations ([01 §3](../chapters/01-ROOT.md#four-marks), [02 §1](../chapters/02-MAP.md#r-generation-and-degeneration-at-two-grains)): Quote [theories/becoming/chapters/02-MAP.md]: "the boundary between going on and ending is where a line's going on is not decided". **Reading and class.** None.

**Known weaknesses.**
- Each proof encodes an arbitrary proposition `P` as the relation `fun _ _ => P` on `Unit`. For the World's law the method chapter relabels the same pattern a lemma: Quote [theories/becoming/chapters/08-METHOD.md]: "the need comes from activity being an arbitrary proposition, not from change". By that rule the grammar's three may be lemmas too. DEFECTS-FOUND (06) applies the rule to two similar calibrations of the readings (相待之还 ⇔ double-negation elimination, 必或不当 ⇔ weak excluded middle): Quote [_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md]: "These are calibrations of logic, which by repository rule are lemmas of their items".
- `«全生有终之定当且仅当排中»` is a dichotomy of `«不穷»` against `«有终»`, not of generation against degeneration (review §5; the chapter says so).

**Questions.**
1. By the theory's own criterion (a calibration says something about the unfolding), are these calibrations or lemmas?
2. Are local forms (decidedness of having a predecessor at a given point) the exact strength the marks and regions need?

---

## Part 2. Testing and the Hennessy–Milner converse

<a id="l-12"></a>
### L-12 Testing by stages

```lean
def «层» (R E : «际» α) : Nat → «际» α
  | 0 => E
  | k + 1 => fun x y => «层» R E k x y ∧
      (∀ v, R x v → ∃ v', R y v' ∧ «层» R E k v v') ∧
      (∀ v', R y v' → ∃ v, R x v ∧ «层» R E k v v')

theorem «可分则不在核» {R E : «际» α} {x y : α} (h : ∃ k, ¬ «层» R E k x y) : ¬ «核» R E x y

theorem «恒温与平衡» :
    «核» Room.closed Room.alike Room.balanced Room.held ∧
      ¬ «核» Room.opened Room.alike Room.balanced Room.held
```

File: `Becoming/GrammarTesting.lean`. **Meaning.** Finite stages approximate the core from above: stage 0 is the class, stage `k + 1` matches steps both ways at stage `k`; the core lies in every stage (`«核在每层之内»`), so what a finite stage separates is not in the core. The stages are the finite-depth approximants of bisimilarity (Milner's `∼k`; Hennessy and Milner 1985; Milner 1989), started from `E`; this direction needs no image-finiteness. A four-element witness: two warm rooms are in one core class of *warm or not* under one relation and separated at stage 1 under a larger relation that includes the window's opening. **Standing and use.** Root theorem and witness: testing within the net ([03 §3](../chapters/03-KNOWING.md#r-testing-within-the-net)). **Reading and class.** 《荀子·正名》's 验 is cited in the module; the reading is the classical dossier's.

**Known weaknesses.**
- The spine attached the Hennessy–Milner direction to the room theorem rather than to `«可分则不在核»` (DEFECTS-FOUND, 03).
- The module header describes the converse as Quote [experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarTesting.lean]: "The other direction is a calibration … not stated here … a periphery check". In fact the core refutes the unconditional converse and proves a conditional one (L-13, review §5), and the script it names lies outside the package, not in the periphery (L-14).

**Questions.**
1. Is that credit accurate for stages started from a class?
2. Does the module's claim, Quote [experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarTesting.lean]: "A wider net tells apart what a narrower one does not", say more than that two relations have different bisimilarities?

<a id="l-13"></a>
### L-13 The converse in the grammar: refuted, and proved under a premise

```lean
def «诘» (R E : «际» α) : Nat → «际» α
  | 0 => E
  | k + 1 => fun u u' => E u u' ∧ (∀ v, R u v → ∃ v', R u' v' ∧ «诘» R E k v v') ∧
      (∀ v', R u' v' → ∃ v, R u v ∧ «诘» R E k v v')

theorem «核则不可致诘» {R E : «际» α} {u u' : α} (h : «核» R E u u') (k : Nat) : «诘» R E k u u'

theorem «不可致诘而有常则混而为一» {R E : «际» α} (hE : «则» E («逆» E))
    (hc : «有常» R (fun u u' => ∀ k, «诘» R E k u u')) {u u' : α} (h : ∀ k, «诘» R E k u u') :
    «核» R E u u'

theorem «致诘不尽» :
    ∃ (β : Type) (R : «际» β) (u u' : β), (∀ k, «诘» R «一» k u u') ∧ ¬ «核» R «一» u u'
```

File: `Becoming/GrammarCandidates.lean`. **Meaning.** The core is separated at no stage of inquiry. The converse fails unconditionally: in an infinitely branching net (one node to every finite chain, another also to an endless one) two nodes agree at every finite stage and lie in no core class; this is the standard image-infinite example (Hennessy and Milner 1985; Milner 1989). It holds where the class is symmetric and the relation *separated at no stage* is itself constant, by the usual coinduction step (that relation is put into the core's definition). Classically, image-finiteness makes the limit relation constant: the convergence of the approximants, which is distinct from the modal characterization by Hennessy–Milner logic. **Standing and use.** Root theorems and a witness ([03 §3](../chapters/03-KNOWING.md#r-testing-within-the-net)). **Reading and class.** Source [LZ-14-002]: "此三者，不可致詰，故混而為一。" classified 乙 (candidate theorem), outcome conditional: 致詰 is read as inquiry by finite stages. The reading is the classical dossier's.

**Known weaknesses.**
- Two stage notions coexist: `«诘»` asks `E` at each stage, `«层»` the previous stage; Quote [theories/becoming/chapters/03-KNOWING.md]: "which no theorem yet relates to the stages 层". The review against the sources lists this (§5).
- The record states the conditional converse with one premise of two: Quote [_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md]: "Its law for «不可致诘而有常则混而为一» names only the constancy premise, but the Lean also requires the class E to be symmetric" (DEFECTS-FOUND, 06; the chapter states both).
- The converse is not where the module headers put it (L-12): Quote [_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/reviews/2026-10-23-sources-against-v10.md]: "The converse of 验 is not only peripheral".
- [this dossier, AI] The premise (the limit relation is constant) is global and the conclusion concerns one pair; no theorem derives the premise from an independently stated condition such as image-finiteness with decided steps.
- [this dossier, AI] Neither the module nor the chapter credits the countermodel.

**Questions.**
1. Which independently stated conditions ensure that the limit relation is constant, and can one be proved in the core?
2. Is the countermodel described correctly?
3. Should `«诘»` and `«层»` be merged, or proved to agree?

<a id="l-14"></a>
### L-14 The Hennessy–Milner limit and LLPO

Unreceipted script, `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/review-checks/HM.lean`:

```lean
def Within (U : Unfolding) (E : U.Way → U.Way → Prop) (u u' : U.Way) : Prop :=
  ∃ R : U.Way → U.Way → Prop, (∀ x y, R x y → E x y) ∧ (∀ x y, R x y → R y x) ∧ Carries U R ∧ R u u'

theorem limit_gives_llpo
    (limit : ∀ α, (∀ k, Stage (U α) top k .u .u') → Within (U α) top .u .u') : LLPO
```

Core, `Becoming/Likeness.lean`:

```lean
def LLPOForDecided : Prop :=
  ∀ γ : Nat → Prop, (∀ n, Decided (γ n)) → (∀ m n, γ m → γ n → m = n) →
    (∀ n, ¬ γ (2 * n)) ∨ ∀ n, ¬ γ (2 * n + 1)

theorem sameBranchingTests_fix_iff_llpoForDecided :
    (∀ (S : Type) (F G : Frame S Unit Empty) (s s' : S), OutcomesListed F → OutcomesListed G →
        SameBranchingTests F G s s' → Alike F G s s') ↔ LLPOForDecided
```

**Meaning.** The script builds, for each Boolean sequence with at most one `true`, a finitely branching unfolding in which two nodes agree at every finite stage; the limit form of the converse, asked of all of them, gives LLPO. In the pure core, on processes with one move and no claims whose outcomes are listed, *same branching tests give likeness* is exactly `EitherThroughout`, which is exactly LLPO for decided families. Beside it, on listed configurations with one move and no claims and with steps not decided, *same branching tests give likeness* is exactly excluded middle (`alike_of_sameBranchingTests_iff_em`), proved by encoding an arbitrary proposition as a frame, the pattern of L-11. Over Bishop's mathematics, with countable and dependent choice, LLPO is equivalent to weak König's lemma (Ishihara 1990; credited in the Likeness docstring); the pure core assumes neither choice, so comparisons of strength depend on the base theory. **Standing and use.** The script: Quote [theories/becoming/chapters/03-KNOWING.md]: "is checked only in an unreceipted" script; the core result is a calibration ([03 §3](../chapters/03-KNOWING.md#r-tests-fix-likeness-where-determined)). **Reading and class.** None; LZ-14-002 as in L-13.

**Known weaknesses.**
- The script lies outside the package (not in the periphery) and has no receipt or record. Run once with Lean 4.29.1 for this dossier (`lean` on a copy; the two `#print axioms` lines at its end), both theorems depend on propext and Quot.sound, from tactics, not on Classical.choice. It shows one direction only.
- [this dossier, AI] The script uses its own copies of the notions (an unfolding, a one-way carrying condition, and stages that ask the class at every stage, shaped like `«诘»` and unlike `«层»`), not the grammar's `«际»`, `«核»` or `«诘»`. No theorem relates them to the grammar, so the script is not a statement in the grammar.
- The record this calibration's section links, tests-fix-likeness-where-determined, has a law the current run does not check: its law 10 cites Quote [_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md]: "Becoming.BranchingTest.toTest/ofTest, sameBranchingTests_iff_same, same_iff_alike_of_finiteDecided and Alike.same", which exist only in the retired lean/history Bridge.lean (DEFECTS-FOUND, 03).
- No theorem connects the processes' branching tests to the grammar's stages (L-07), so the core's exact calibration does not reach the grammar.
- 03 says of the principle on processes Quote [theories/becoming/chapters/03-KNOWING.md]: "whether that principle is weaker is not shown". That stands for `EitherThroughout` against excluded middle; the Likeness module says showing it would take a model outside the core. 03 omits the principle's name: the core proves it exactly LLPO for decided families (`eitherThroughout_iff_llpoForDecided`, `sameBranchingTests_fix_iff_llpoForDecided`), which uses Prop-valued decidedness; the core derives standard LLPO from it, and the converse only where decisions are data (`LLPO.decidable`).

**Questions.**
1. Is the calibration stated at its exact strength, and does the converse direction (LLPO giving the limit form for finitely branching decided unfoldings) hold?
2. Is LLPO for Prop-decided families equivalent to LLPO without a choice principle?
3. How do these calibrations relate to the constructive literature on Hennessy–Milner-type theorems, LLPO and weak König's lemma?
4. Does `EitherThroughout` give `NowhereDecided` or excluded middle, and does a principle weaker than excluded middle suffice where the moves or the claims are not listed? Both are recorded as not derived in `Becoming/Likeness.lean`.
5. By the criterion of L-11, is `alike_of_sameBranchingTests_iff_em` a calibration or a lemma?

---

## Part 3. Omniscience and choice

<a id="l-15"></a>
### L-15 Settling is LPO

```lean
def LPO : Prop :=
  ∀ s : Nat → Bool, (∃ n, s n = true) ∨ ∀ n, s n = false

theorem lpo_iff_settles :
    LPO ↔ ∀ (S : Type) [DecidableEq S] (l : List S), (∀ x, x ∈ l) → ∀ (A : Type) (P : Process S A) (s : S),
      (¬ ∃ x a y, Reach P s x ∧ P.step x a y ∧ y ≠ x ∧ Reach P y x) →
        ∀ r : Run P, r.state 0 = s → Enough.Settles r

theorem lpo_of_settles (settle : ∀ r : Run process, r.state 0 = false → Enough.Settles r) : LPO
```

Files: `Becoming/LastChange.lean`, `Becoming/Settling.lean`, `Becoming/HistoryIdeals.lean` (the second theorem in namespace Settling.OneWay; `Stretches.cut_decided_iff_lpo` in HistoryIdeals). **Meaning.** Over every finite world of decidable configurations, every run from a configuration with no reachable change that can be undone settles exactly under LPO; in a two-configuration one-way process, every run settling gives LPO; deciding whether a cut history has a latest stretch or goes on is LPO. **Standing and use.** Calibrations ([08 §5](../chapters/08-METHOD.md#r-the-last-change-of-a-run)): Quote [theories/becoming/chapters/08-METHOD.md]: "What the need says: settling is deciding whether the run changes again." The chapter cites Bishop (1967), Bridges and Richman (1987) and Ishihara as the known source. **Reading and class.** None.

**Known weaknesses.**
- Worlds that no list holds are outside these laws. That WLPO does not give LPO is cited and not checked.

**Questions.**
1. Is the equivalence stated at its exact strength, and is the credit adequate?
2. Is that gloss an accurate description of what the need says?

<a id="l-16"></a>
### L-16 Tails: WLPO and LPO as rules

```lean
def ChangedByNoCondition (f : (Nat → Nat) → Nat) : Prop :=
  ∀ (c : Nat) (α β : Nat → Nat), (∀ m, m ≠ c → α m = β m) → f α = f β

theorem changedByNoCondition_iff_rule :
    (∃ f : (Nat → Nat) → Nat, ChangedByNoCondition f ∧ ∃ α β, f α ≠ f β) ↔
      Nonempty (∀ s : Nat → Bool, Decidable (∀ n, s n = false))

theorem vanishDecision_iff_lpoRule :
    Nonempty (∀ α : Nat → Nat, Decidable (VanishFrom α)) ↔
      Nonempty (∀ s : Nat → Bool, Decidable (∃ n, s n = true))
```

File: `Becoming/Tail.lean`. **Meaning.** A number read off a sequence of levels that no single coordinate changes, yet that differs between two sequences, exists exactly where a rule decides of every Boolean sequence whether it is false throughout; deciding eventual vanishing is exactly the LPO rule. **Standing and use.** Calibrations, read as what a law of the whole and no part takes; used for the least coupling ([08 §5](../chapters/08-METHOD.md#r-what-a-law-of-the-whole-and-no-part-takes)). **Reading and class.** None.

**Known weaknesses.**
- The statements concern uniform rule forms, `Nonempty` of a decision function, which imply the propositions WLPO and LPO (`WLPO.of_rule`, `LPO.of_rule`); the reverse implications are not established, and no separation is proved (strengths compared with Ishihara's results also depend on the base theory, L-14): Quote [theories/becoming/chapters/08-METHOD.md]: "That the proposition WLPO gives a rule is not shown, since that step chooses a function from a relation."

**Questions.**
1. Is calling these WLPO and LPO accurate, or should they carry the names of the rule forms only?
2. Is the first equivalence the known link between discontinuous functionals and WLPO (Brouwer's continuity principle; Ishihara), and should it be credited?

<a id="l-17"></a>
### L-17 Refutation, verification, double negation and Markov

```lean
theorem refutable_closed_iff :
    (∀ (S A : Type) (P : Process S A) (C : Ideals.Ideal (stretchOrder P) → Prop),
      Ideals.Refutable C → Ideals.ScottClosed C) ↔ ∀ φ : Prop, ¬ ¬ φ → φ

theorem refutable_passes_iff_markov :
    (∀ (S A : Type) (P : Process S A) (fails : Nat → Run P → Bool),
      ByPrefixes fails → Refutable (Passes fails)) ↔ Markov
```

Files: `Becoming/HistoryIdeals.lean` (namespace Stretches; beside it `Stretches.closed_refutable_iff` and `refutable_holds_iff`), `Becoming/Horizon.lean`. **Meaning.** Histories are ideals of finite stretches. Asked of every process: refutable classes are closed, closed classes refutable, and a refutable reading holds at every adhering run, each exactly under double-negation elimination; a reading made of tests is refutable exactly under Markov's principle. **Standing and use.** Calibrations; the formal side of falsifiability ([03 §5](../chapters/03-KNOWING.md#refutation)), with the safety–liveness decomposition (Alpern and Schneider 1985) credited, constructively. **Reading and class.** [AI reading, D26]: refutability is not made the criterion of scientific standing.

**Known weaknesses.**
- [this dossier, AI] Each is asked of every process. The double-negation calibrations encode an arbitrary proposition in a witness process, so the L-11 question applies to them; the Markov calibration instead reduces a Boolean sequence (the test at `n` fails where its move is `true`).
- A record states the limit results more strongly than the Lean (DEFECTS-FOUND, 03: verifying unions of closed readings is shown one way only).

**Questions.**
1. Are these known in constructive topology or formal topology (closed sublocales, the double-negation nucleus), and how should they be credited?
2. Are calibrations universal over all processes informative, or would a calibration at a fixed process be the exact strength?
3. Do the two diagonal limit laws, `Limit.Free.settles_not_refuted` and `Limit.Sequences.recurs_not_verified` (no method fixed by the record refutes settling, or verifies recurrence, in the limit), need Markov's principle, under which each is proved? 03 §5 records this as open: Quote [theories/becoming/chapters/03-KNOWING.md]: "whether the two diagonal laws need Markov's principle is open". Separately, two other laws each imply LPO, one way only (`Limit.Sequences.eventuallyFalse_lpo`, `Limit.Sequences.either_recurs_lpo`).

<a id="l-18"></a>
### L-18 Runs, dependent choice and finite branching

```lean
def DependentChoice : Prop :=
  ∀ (α : Type) (R : α → α → Prop), (∀ x, ∃ y, R x y) →
    ∀ x, ∃ f : Nat → α, f 0 = x ∧ ∀ n, R (f n) (f (n + 1))

theorem runs_iff_dependentChoice :
    (∀ (S A : Type) (P : Process S A) (K : S → Prop), KeepsMoving P K →
      ∀ s, K s → ∃ r : Run P, r.state 0 = s ∧ ∀ n, K (r.state n)) ↔ DependentChoice

theorem step_iff_either :
    (∀ (S A : Type) (P : Process S A), FinitelyBranching P → ∀ s, Unbounded P s →
      ∃ t, (∃ a, P.step s a t) ∧ Unbounded P t) ↔ EitherThroughout
```

Files: `Becoming/Onward.lean`, `Becoming/Lasting.lean` (namespaces `Onward`, `Lasting`). **Meaning.** A run from every member of every family that keeps moving is exactly dependent choice. In a finitely branching process an unbounded configuration having an unbounded successor is exactly `EitherThroughout` (L-14). `Lasting.lifting` separates three steps: with that principle and finite branching an unbounded successor exists (`Unbounded.step_of_either`); a supplied function `choose` turns that existence proof into a successor with its move; `runOf` iterates the selection. So every unbounded configuration starts a run along unbounded ones, explicit relative to these data; no selector is obtained unconditionally. **Standing and use.** Calibrations ([08 §5](../chapters/08-METHOD.md#r-lifting-where-branching-is-finite)); the line from an occurrence never ending (`«不穷»`) yields an endless chain only with dependent choice ([01 §2](../chapters/01-ROOT.md#class-and-continuation)). **Reading and class.** None.

**Known weaknesses.**
- `choose` is data-level choice; `lifting` gives a run's existence, not an effective selection (the chapter says so). Weak König's lemma is credited in the Likeness and Lasting docstrings, not in the chapter.

**Questions.**
1. Is the hypothesis set of `lifting` minimal? `choose` acts only on a proof that an unbounded successor exists, which `EitherThroughout` with finite branching supplies; can that proof be had with less?
2. Should the relation of `step_iff_either` to König's lemma and weak König's lemma be stated in the chapter?

---

## Part 4. The method

<a id="l-19"></a>
### L-19 The pure-core discipline

The checker's assertion on every source declaration, `check_becoming.py`:

```python
assert set(axioms) <= {"propext", "Quot.sound", "Classical.choice"}, (full, axioms)
assert name not in SPINE + PURE or not axioms, (full, axioms)
```

**Meaning.** In the chapter's words, Quote [theories/becoming/chapters/08-METHOD.md]: "the pure core imports only the foundation and itself, and compiles from Lean's prelude (`Init`) alone, with the foundation's `import Std` removed"; every source declaration in the core and its foundation has an empty axiom report (no propext, Quot.sound or Classical.choice); the only constants with an axiom are generated injectivity lemmas, on propext, which no source declaration uses. **Standing and use.** A checked discipline at each landing ([08 §3](../chapters/08-METHOD.md#pure-core-and-periphery)). Quote [theories/becoming/chapters/08-METHOD.md]: "An empty report shows that no logical axiom is used. It says nothing about whether the modelling fits an actual unfolding". **Reading and class.** None.

**Known weaknesses.**
- [this dossier, AI] An empty report does not record which kernel features a proof uses: impredicative `Prop` (L-06), definitional proof irrelevance, large elimination, the primitive quotient, kernel computation by `decide`.
- The chapter gives two reasons for excluding propext and none for quotient soundness, or for function extensionality, which follows from it. First, from the relational start: Quote [theories/becoming/chapters/08-METHOD.md]: "says that a proposition is nothing beyond them. Whether to assume it is therefore a question about lumping." Second, transport along propext does not reduce, which defeats checks by computation (L-20). The heading Quote [theories/becoming/chapters/08-METHOD.md]: "Stricter than constructive, and about logic only." means that the report concerns logic and not the modelling, not that the exclusion has a logical motive.
- [this dossier, AI] Propositional extensionality and quotient soundness are constructively acceptable, so the extra strictness appears to concern computation (transport that reduces) rather than logic.
- Some cited results are outside it (the HM script, L-14; periphery modules with Mathlib).

**Questions.**
1. Is the discipline meaningful as stated? Is the strictness beyond constructivity about computation, and should the chapter give a reason for excluding quotient soundness and function extensionality?
2. Should the report also list impredicativity and other kernel features a declaration depends on?

<a id="l-20"></a>
### L-20 propext as the lumping of every reading

```lean
def Extensional : Prop := ∀ a b : Prop, (a ↔ b) → a = b

theorem extensional_iff_lumped :
    Extensional ↔ ∀ g : Prop → Prop, Learning.Lumped relation (fun i => g (endOf i))

theorem byName_lumped_iff : Learning.Lumped relation (fun i => byName (endOf i)) ↔ Extensional
```

File: `Becoming/PropositionIdentity.lean` (namespace `PropositionIdentity`). **Meaning.** propext, stated as a proposition, holds exactly where every map from propositions to propositions is constant on interderivable propositions, and exactly where the reading by name is. **Standing and use.** Theorem (any type); the reason the pure core states `↔` where `=` would need propext ([08 §3](../chapters/08-METHOD.md#r-proposition-identity)). **Reading and class.** The case for excluding propext is argued in the chapter, not registered as a reading.

**Known weaknesses.**
- The claim that transport along propext does not reduce is Quote [theories/becoming/chapters/08-METHOD.md]: "a kernel observation with Lean 4.29.1 on one value, not a theorem."
- Function extensionality and quotient soundness are not treated.

**Questions.**
1. Is the equivalence anything beyond the folklore that propext is congruence of every predicate on `Prop` under `↔`, and does the word *lumping* add content?
2. Is the argument from loss of computation a sound reason to exclude propext from a core whose claims are propositions?

<a id="l-21"></a>
### L-21 Expressible is not derived; the World as a model

```lean
theorem arises_iff_sheng {t : Nat} {f : F} :
    W.Arises t f ↔ W.active (t + 1) f ∧ «生» Steps.along W.activityClass (t + 1, f)

theorem carries_iff {x y : Nat × F} (start : W.active x.1 x.2) :
    «传» (continuationStep R) W.activityClass W.carrierClass x y ↔
      continuationStep R x y ∧ W.active y.1 y.2 ∧ ¬ (W.active x.1 y.2 ∧ R x.1 y.2 y.2)
```

Files: `Becoming/Arising.lean`, `Becoming/MapInstances.lean` (namespace `Web`). **Meaning.** Instance theorems state the World model's continuation family in the grammar: a formation arises exactly where the occurrence after the step is active and begins under the class of activity; from an active occurrence, a carrying renewal on the World is exactly a continuation step into an active occurrence whose formation was not both active at the earlier step and related to itself by `R` there. A law proved on a model passes to the grammar only by a dependency audit, a lifting theorem and a representation theorem. **Standing and use.** Theorems (World) and a method ([08 §6](../chapters/08-METHOD.md#expressible-is-not-derived), [01 §8.6](../chapters/01-ROOT.md#instances)). The audit: Quote [theories/becoming/chapters/08-METHOD.md]: "Of these, 9,370 read no World field; 348 read only". **Reading and class.** None.

**Known weaknesses.**
- No representation theorem exists for the World or for processes; most modules are not on the grammar (the review against the sources counted 14 of 312, eight only through instance sections).
- The statements of 08 §6 on representation have no record and no Lean result (DEFECTS-FOUND, 08; quoted at L-01).

**Questions.**
1. Is audit, lifting and representation a sound criterion for a law of the grammar, and what form should the representation theorem take (a faithful functor, an equivalence of categories of models, an interpretation)?
2. In what sense is the grammar the theory's root while most laws are not lifted, and what would have to be lifted for the name to fit?
3. Can mutual interpretation with a named fragment of Lean (each compiled into the other, provability kept both ways), which 08 §6 leaves open, be shown, and which fragment is natural?

<a id="l-22"></a>
### L-22 The World's premises read off one exchange

```lean
theorem withRest_balanced : w.withRest.Balanced

theorem listed_iff_lpo :
    (∀ L : Flow Nat Nat, (∀ t, Distinct (L.present t)) →
        ∀ t, ∃ l, Distinct l ∧ ∀ f, L.Exchanging t f ↔ f ∈ l) ↔ LPO

theorem respondsBelow_weakest {R : (Nat → C → Nat) → Nat → F → C → Nat → Prop}
    (sound : rel.Supports present R) (local_ : Local R) {l : Nat → C → Nat} {t : Nat} {f : F}
    {c : C} {n : Nat} (reads : R l t f c n) : rel.RespondsBelow present l t f c n
```

Files: `Becoming/Reading.lean` (namespace `World`), `Becoming/ExchangePremises.lean` (namespace `Flow`), `Becoming/OverExchange.lean` (namespace `ExchangeRelation`). **Meaning.** With the rest of the whole counted as one more relatum, every world balances; listing what exchanges at every step of every flow over `Nat` is exactly LPO; necessary response is the weakest sound reading of requirement that does not read the current level. **Standing and use.** Theorems (World) and a calibration: four premises of the World hold by the reading ([01 §8.3](../chapters/01-ROOT.md#r-premises-read-off-the-exchange)). **Reading and class.** [AI reading, D65]: locality, and what internal relations mean here.

**Known weaknesses.**
- Counting the difference as a relatum makes balance hold by construction; the chapter grants it, Quote [theories/becoming/chapters/01-ROOT.md]: "Balance is not removed: nothing comes from nothing becomes feasibility, a premise located in the law."
- An earlier text said five premises hold by construction; the census does only where a named family closes each step (DEFECTS-FOUND, 01; corrected in the chapter).

**Questions.**
1. Is holding by the reading a derivation, or a definitional extension that relocates the premise?
2. Is `Flow.listed_iff_lpo` stated at its exact strength, and does it say something about exchange rather than about listing?

<a id="l-23"></a>
### L-23 What the dynamics do not entail

```lean
def ReadsOnlyDynamics {D : Type} (law : D → (Pos → Nat → F → Prop) → Prop) : Prop :=
  ∀ d sig sig', law d sig → law d sig'

theorem ReadsOnlyDynamics.not_entails {D : Type} {law : D → (Pos → Nat → F → Prop) → Prop}
    (reads : ReadsOnlyDynamics law) (entails : ∀ d sig, law d sig → Unrestricted sig)
    (p : Pos) (f : F) {d : D} {sig : Pos → Nat → F → Prop} : ¬ law d sig

theorem not_rival_unrestricted_iff_stable (p : Pos) (f : F) :
    (∀ sig : Pos → Nat → F → Prop, ¬ Rival sig → Unrestricted sig) ↔ ∀ q : Prop, ¬ ¬ q → q
```

File: `Becoming/Significance.lean`. **Meaning.** A statement whose truth does not change with the significance, if it entails the continuation condition for every significance, holds of nothing (where a standpoint and a formation exist); over every significance, that excluding every rival gives the condition is exactly double-negation elimination. **Standing and use.** Theorem (any type) and calibration: the ethics needs premises, the condition for scope and C for order, neither asserted ([07 §1](../chapters/07-SIGNIFICANCE.md#r-what-the-dynamics-leave-open)). Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "That every World law reads only the dynamics is a fact about the representation". **Reading and class.** None.

**Known weaknesses.**
- The proof instantiates the significance as the empty one; the method chapter rates it near-definitional.
- [this dossier, AI] *Reading only the dynamics* is semantic invariance, not a syntactic condition on statements.
- Quote [_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/reviews/2026-10-23-sources-against-v10.md]: "Root and ethics are not joined." `Unrestricted` and `ReadsOnlyDynamics` are stated on the significance formalism, not on `«续»`; 07 ties them to the World and processes, not to the grammar (review §4; [01, Open](../chapters/01-ROOT.md#open)), so Part 1 and this item are not yet one account.

**Questions.**
1. Is invariance under change of significance the right formalization of reading only the dynamics, against syntactic forms of Hume's law (Prior 1960; Schurz 1997), and should these be credited?
2. Is the double-negation calibration informative about evaluation, or a lemma of the logic?

<a id="l-24"></a>
### L-24 Widening as what every positive weighting ranks

```lean
theorem widens_iff_every_positive {items : List X} {a b : X → Bool} :
    WidensOn items a b ↔ ∀ w, Positive items w → weighed items w b < weighed items w a

theorem widens_iff_every_of_class {items : List X} {a b : X → Bool}
    {K : ((X → Bool) → (X → Bool) → Prop) → Prop}
    (weightings : ∀ w, Positive items w → K (ranks items w))
    (increasing : ∀ R, K R → Increasing items R) :
    WidensOn items a b ↔ ∀ R, K R → R b a
```

File: `Becoming/Weightings.lean` (namespace `Weighting`). **Meaning.** On a finite list of items with two-valued admission, one course widens another exactly when every weighting by positive natural numbers on the items weighs it higher. The same holds for any class `K` of comparisons (binary relations on courses, not assumed complete, transitive or irreflexive) containing every positive weighting's comparison and only relations ranking each widening above what it widens. This is a finite, natural-weight form of the idea of Sen's intersection quasi-ordering (Sen, "Interpersonal aggregation and partial comparability", *Econometrica* 1970), widening being Pareto dominance, proved directly. **Standing and use.** Theorem (any type): C, the premise that orders, is decomposed into the unanimity of standpoints whose comparisons increase in admission ([07 §4.4](../chapters/07-SIGNIFICANCE.md#r-widening-as-what-every-weighting-ranks)); the chapter credits Sen's intersection approach and Pareto dominance. **Reading and class.** None.

**Known weaknesses.**
- Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "Monotonicity at the standpoint is C's premise relocated: weaker, still a premise." Weights are natural numbers and the listing finite.

**Questions.**
1. Is the credit above accurate, and what does the class version state beyond monotonicity?
2. Do natural weights and a finite listing limit the result in a way the chapter should state?

<a id="l-25"></a>
### L-25 Lawvere's diagonal as an unfolding

```lean
def Says (same : B → B → Prop) (ψ : A → A → B) (g : A → B) : Prop :=
  ∃ a, ∀ x, same (ψ a x) (g x)

def gap (f : B → B) (ψ : A → A → B) (x : A) : B := f (ψ x x)

def Moves (same : B → B → Prop) (f : B → B) : Prop := ∀ b, ¬ same b (f b)

theorem gap_unsaid {same : B → B → Prop} {f : B → B} (moves : Moves same f) (ψ : A → A → B) :
    ¬ Says same ψ (gap f ψ)

theorem Unfolds.never_returns (U : Unfolds same f φ) (moves : Moves same f) (n k : Nat) :
    ¬ ∀ g, Says same (φ (n + 1 + k)) g → Says same (φ n) g
```

File: `Becoming/Diagonal.lean` (namespace `Diagonal`). **Meaning.** For a map moving every value, no member of a family of readings indexed by what it reads says the diagonal gap, for any likeness `same`. For inhabited `A` and `B`, with decidable equality on `B` and likeness taken as equality, some family says every reading exactly when all values of `B` are equal (`Diagonal.complete_iff_alike`). A family that keeps what it said and next says its last gap never returns. **Standing and use.** Theorem (any type): how far a description made within what it describes can complete itself ([03 §6](../chapters/03-KNOWING.md#r-readings-within-what-they-read)): Quote [theories/becoming/chapters/03-KNOWING.md]: "Lawvere's fixed point as an unfolding; coding and provability are not stated." **Reading and class.** None; the liar is read as a rhythm with no still value. That rhythm is the liar's revision sequence in the revision theory of truth (Herzberger 1982; Gupta 1982; Gupta and Belnap 1993), here for one sentence, with no limit rules or truth predicate.

**Known weaknesses.**
- [this dossier, AI] The gap theorem is Cantor's diagonal in Lawvere's form (Lawvere 1969), which 03 credits; the unfolding iterates it. Neither the chapter nor the module credits revision theory for the rhythm; the module assigns that comparison to the study.

**Questions.**
1. What does the unfolding (completion that never returns) state beyond iterating the diagonal argument?
2. How does the reading of the liar as a rhythm relate to the revision theory's treatment of it? The three-valued counterpart, where the liar rests undecided, is L-27.

<a id="l-26"></a>
### L-26 The completion criterion K1–K7

No Lean statement: a tool, `tools/research/completion.py`, run at each landing. **Meaning.** Seven checks: coverage, unity of the base families, premises named with witnesses, representation over dense amounts, enclosure of supplied parameters, one ethics chain, an open register. **Standing and use.** A method ([08 §12](../chapters/08-METHOD.md#completion-criterion)): Quote [theories/becoming/chapters/08-METHOD.md]: "On the registered coverage, the configured checks have no finding. That is all they establish." **Reading and class.** None.

**Known weaknesses.**
- Quote [tools/research/completion.py]: "so patterns match source text, not elaborated terms: a premise named only through a definition the statement unfolds is not found." K4 and K5 look only at the patterns their coverage file lists; Quote [theories/becoming/chapters/08-METHOD.md]: "So the criterion is completion in a qualified sense, not a proof that every premise is named, and not a proof of necessity."

**Questions.**
1. Is a check on source text a meaningful criterion of completion, and what would a logician require instead (for example, an audit of hypotheses on elaborated terms)?
2. Is K3's treatment of logical premises (a witness meeting decidedness, a proof it is never refuted, a calibration) sound?

---

## Part 5. Further results in logic

<a id="l-27"></a>
### L-27 Revision with an undecided value

```lean
def stage (sys : Nat → Term) (n : Nat) : Nat → Value := (Law.run (revise sys) blank).state n

theorem least_fixed (closed : Closed sys N) :
    (∀ i, i < N → revise sys (stage sys N) i = stage sys N i) ∧
      ∀ w : Nat → Value, (∀ i, i < N → eval w (sys i) = w i) → ∀ i, i < N → Le (stage sys N i) (w i)

theorem chain_exact (N : Nat) : Steady chain (N + 1) (N + 1) ∧ ¬ Steady chain (N + 1) N

theorem liar_rests : ∀ n i, stage liar n i = u

theorem undecided_of_moves (closed : Closed sys N)
    (moves : ∀ b : Nat → Bool, ∃ i, i < N ∧ eval₂ b (sys i) ≠ b i) {w : Nat → Value}
    (fixed : ∀ i, i < N → eval w (sys i) = w i) : ∃ i, i < N ∧ w i = u
```

File: `Becoming/Undecided.lean` (namespace `Undecided`). **Meaning.** With an undecided value below true and false and Kleene's strong three-valued tables, revising `N` sentences that speak only of one another, from all undecided, settles within `N` steps at the least fixed point: Kripke's construction (1975) for finitely many sentences, as the module credits, where each sentence rises at most once, so no limit stage is needed (the count `Undecided.settles_within`). The bound is exact (a chain of `N + 1` sentences is not steady at step `N`). Where two-valued revision has no fixed point, every three-valued fixed point leaves a sentence undecided, and the liar rests undecided. No map monotone in information moves every value (`Undecided.monotone_not_moves`). **Standing and use.** Theorem on the module's own syntax (terms over `Nat`-indexed sentences with the two constants, negation, conjunction and disjunction), for `N` sentences whose terms mention only sentences below `N` (`Closed`); no type parameter occurs, though 03 labels it "any type" ([03 §6](../chapters/03-KNOWING.md#r-revision-with-an-undecided-value); [record](../results/records/revision-with-an-undecided-value.md)); with L-25 it bounds how far a description within what it describes completes itself ([08 §6](../chapters/08-METHOD.md#describing-from-within)). **Reading and class.** Quote [theories/becoming/chapters/03-KNOWING.md]: "Undecided is what revision has not decided, not a third truth." Not a corpus unit.

**Known weaknesses.**
- The chapter credits no source at the theorem. The module does: Quote [experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Undecided.lean]: "The tables are Kleene's strong three-valued tables; settling at the least fixed point from all undecided is Kripke's construction (1975) restricted to finitely many sentences".
- Infinitely many sentences, where the least fixed point needs a limit stage, and fixed points other than the least are not derived (module header).

**Questions.**
1. Is the finite specialization stated correctly, and is the module's credit adequate for the chapter?
2. Is the exact bound (`Undecided.chain_exact`) recorded in the literature?
3. Taken with L-25, how does the reading of the liar on both sides (two values, a rhythm that never rests; three values, resting undecided) relate to revision theory and to Kripke's fixed point?

<a id="l-28"></a>
### L-28 Curry and contraction (pre-spine)

```lean
theorem curry_fixed_point {C Q : Prop} (h : C ↔ (C → Q)) : Q

theorem admissible_contraction_iff_duplicate {P : Process S E} {join : S → S → S}
    (unit : S) (hu : ∀ x, join unit x = x) (hf : StepFrame P join) (a : S) :
    AdmissibleContraction P join a ↔ Reach P a (join a a)
```

Files: `experiments/integrated-correction/general-framework/generative-basis/lean/deeper/ReflectiveIdentity.lean` (namespace Generative.ReflectiveIdentity, a pre-spine module outside the Becoming package; beside it RecognitionalBinding.lean) and `experiments/integrated-correction/general-framework/generative-basis/lean/deeper/GeneratedContraction.lean`. **Meaning.** Admitting `C ↔ (C → Q)` under implication and reuse of a hypothesis yields any `Q`. In an object calculus of configurations with identity, steps, cut and framing but no contraction, given a left unit and steps compatible with each declared context, contraction is admissible at `a` exactly where duplication `a ⇝ a ⊗ a` is reachable. **Standing and use.** Theorems (any type; any process), pre-spine modules with empty axiom reports and their own receipts ([08 §6, contraction](../chapters/08-METHOD.md#contraction), [self-reference](../chapters/08-METHOD.md#self-reference)). From the first and its companions 08 concludes Quote [theories/becoming/chapters/08-METHOD.md]: "So self-reference does not certify itself, and the reference back of a bound use is stipulated rather than derived." **Reading and class.** None.

**Known weaknesses.**
- Neither has a record (DEFECTS-FOUND, second round, from chapter 08): Quote [_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md]: "contraction (deeper/GeneratedContraction) and the self-reference limits (ReflectiveIdentity, RecognitionalBinding)".
- 08 claims no novelty for the contraction theorem: Quote [theories/becoming/chapters/08-METHOD.md]: "no novelty over linear, graded or Petri-net logics is claimed". Binary duplication gives every finite multiplicity, not the exponential modality.
- [this dossier, AI] The Curry statement, which 08 credits to Curry, is the propositional form of Curry's paradox with the fixed point taken as a hypothesis; no self-referential sentence is constructed.

**Questions.**
1. Is the contraction theorem a known fact of substructural or resource logics (linear logic, bunched implications, Petri-net semantics), and how should it be credited?
2. Does 08's conclusion about self-reference follow from these statements?

<a id="l-29"></a>
### L-29 The other calibrations of 08 §5

No Lean block: the statements are long; each is named and linked, and the third column gives its quantifiers and hypotheses. The middle column is 08 §5's account of what the need says.

| Principle | What needing it says (08 §5) | What the Lean states | Lean |
|---|---|---|---|
| Decidedness, local | a count or a named step exists only where its object is decided | any list, any property: a count exists exactly where the property is decided at each member; no principle | `counts_iff_decided` (`Becoming/Decidedness.lean`; [08](../chapters/08-METHOD.md#r-counts-exist-where-decided)) |
| Weak excluded middle | where it is open whether one move betters another, no move need be known to be chosen | every type and relation: each nonempty list on whose members the relation is irreflexive and transitive has an undominated member, exactly where every proposition is weakly decided (`¬ p ∨ ¬ ¬ p`); the frame form, the same for a configuration's listed options | `exists_undominated_iff_weakly` (`Becoming/Decidedness.lean`), `FrontierFrames.choice_exists_iff_weakly` (`Becoming/FrontierFrames.lean`) |
| Double-negation elimination | reach without a path | every process, seed predicate and configuration: where no invariant property separates it from the seeds, it is reached from a seed (`∃ s, seed s ∧ Reach P s x`, a finite path), exactly under the principle | `fromSeed_of_not_separated_iff_dne` (`Becoming/SeedReach.lean`) |
| Excluded middle | names carry one decided identity more than relations | every World: indiscernibility of any two relata is decided; (second law) every list of relata has a number up to indiscernibility; each exactly under the principle. Carrier equality is not at issue | `World.indiscernible_decided_iff_em`, `World.numbers_indiscernible_iff_em` (`Becoming/Listing.lean`; [08](../chapters/08-METHOD.md#r-relata-counted-up-to-indiscernibility)) |

**Standing and use.** Calibrations ([08 §5](../chapters/08-METHOD.md#calibrations)); the weak excluded middle row is the core form of a frontier that the older classical periphery stated without the hypothesis (DEFECTS-FOUND, 07). **Reading and class.** None.

**Known weaknesses.**
- The records of the weak excluded middle and double-negation rows were not confirmed (DEFECTS-FOUND, 08), and reach from a seed has no record (DEFECTS-FOUND, second round, from chapter 01).
- `counts_iff_decided` holds for any list and any property, while its record's base says otherwise (DEFECTS-FOUND, 08).
- [this dossier, AI] 08's gloss of the double-negation row, Quote [theories/becoming/chapters/08-METHOD.md]: "reach without a path", misdescribes the law: its conclusion is reach, which carries a path; what needs the principle is the step from the absence of an invariant separation to such a path.

**Questions.**
1. By the criterion of L-11, which of these are calibrations and which lemmas?
2. Is each stated at its exact strength, and is any a known equivalence of constructive reverse mathematics that should be credited?

---


## References

The works cited above, each checked against the publication's record (a library catalogue, the publisher or the DOI) on 24 October 2026; where the check reached only the record, not the text, the citation is of the standard result the work is known for.

- Bowen Alpern and Fred B. Schneider (1985). Defining liveness. Information Processing Letters 21(4), 181-185.
- Errett Bishop, Foundations of Constructive Analysis, New York: McGraw-Hill, 1967, xiii+370 pp.
- Patrick Blackburn, Maarten de Rijke and Yde Venema, Modal Logic, Cambridge Tracts in Theoretical Computer Science 53, Cambridge University Press, 2001, xxii+554 pp.
- Douglas Bridges and Fred Richman, Varieties of Constructive Mathematics, London Mathematical Society Lecture Note Series 97, Cambridge University Press, 1987, x+149 pp., ISBN 0-521-31802-5
- Anil Gupta (1982). Truth and paradox. Journal of Philosophical Logic 11(1), 1-60.
- Anil Gupta and Nuel Belnap (1993). The Revision Theory of Truth. Cambridge, MA and London: MIT Press (Bradford Books), xii+299 pp. ISBN 0-262-07144-4.
- Matthew Hennessy and Robin Milner, 'Algebraic laws for nondeterminism and concurrency', Journal of the ACM 32(1):137-161, January 1985, doi:10.1145/2455.2460. (Companion: Robin Milner, Communication and Concurrency, Prentice Hall, 1989.)
- Hans G. Herzberger (1982). Notes on naive semantics. Journal of Philosophical Logic 11(1), 61-102. doi:10.1007/BF00302339
- Hajime Ishihara, 'An omniscience principle, the König lemma and the Hahn-Banach theorem', Zeitschrift für mathematische Logik und Grundlagen der Mathematik 36(3):237-240, 1990 (the journal later became Mathematical Logic Quarterly)
- Paris C. Kanellakis and Scott A. Smolka (1990). CCS expressions, finite state processes, and three problems of equivalence. Information and Computation 86(1), 43-68. doi:10.1016/0890-5401(90)90025-D (extended version of PODC 1983, pp. 228-240)
- John G. Kemeny and J. Laurie Snell, Finite Markov Chains, University Series in Undergraduate Mathematics, Princeton NJ: D. Van Nostrand, 1960, viii+210 pp. (lumpable processes in ch. VI, §6.3; 2nd ed. Springer-Verlag 1976, p. 124)
- Kim G. Larsen and Arne Skou, 'Bisimulation through probabilistic testing', Information and Computation 94(1):1-28, 1991, doi:10.1016/0890-5401(91)90030-6 (preliminary report in POPL '89 (16th ACM Symposium on Principles of Programming Languages), 1989, pp. 344-352)
- F. William Lawvere (1969). Diagonal arguments and cartesian closed categories. In Category Theory, Homology Theory and their Applications II, Lecture Notes in Mathematics 92, Springer, 134-145. doi:10.1007/BFb0080769. Reprinted with author commentary in Reprints in Theory and Applications of Categories 15 (2006), 1-13.
- Robin Milner (1989). Communication and Concurrency. Prentice Hall International Series in Computer Science. New York/Hemel Hempstead: Prentice Hall. xi+260 pp. ISBN 0-13-115007-3
- Robert Paige and Robert E. Tarjan (1987). Three partition refinement algorithms. SIAM Journal on Computing 16(6), 973-989. doi:10.1137/0216062
- David Park (1981). Concurrency and automata on infinite sequences. In P. Deussen (ed.), Theoretical Computer Science: 5th GI-Conference, Karlsruhe, LNCS 104, Springer, pp. 167-183. doi:10.1007/BFb0017309
- A. N. Prior (1960). The autonomy of ethics. Australasian Journal of Philosophy 38(3), 199-206.
- J. J. M. M. Rutten (2000). Universal coalgebra: a theory of systems. Theoretical Computer Science 249(1), 3-80. doi:10.1016/S0304-3975(00)00056-6
- Gerhard Schurz (1997). The Is-Ought Problem: An Investigation in Philosophical Logic. Trends in Logic (Studia Logica Library) vol. 1. Dordrecht: Kluwer, x+332 pp.
- Alfred Tarski (1941). On the calculus of relations. Journal of Symbolic Logic 6(3), 73-89. doi:10.2307/2268577
- Alfred Tarski and Steven Givant (1987). A Formalization of Set Theory without Variables. American Mathematical Society Colloquium Publications, vol. 41. Providence, RI: AMS. xxi+318 pp. ISBN 0-8218-1041-3

## Response form

For each item give one verdict: **accept** (the statement is correctly described and credited), **accept with changes** (say which), **reject** (say why), or **cannot judge**. Comments may answer the numbered questions by number.

| Item | Verdict | Comment |
|---|---|---|
| [L-01](#l-01) The calculus and its operations | | |
| [L-02](#l-02) Reach, precedence and co-presence | | |
| [L-03](#l-03) Continuation as a meet | | |
| [L-04](#l-04) The four marks and coarsening | | |
| [L-05](#l-05) Constancy never lets a continuation end | | |
| [L-06](#l-06) The root theorem: the core | | |
| [L-07](#l-07) Closure and bisimulation equivalence | | |
| [L-08](#l-08) The two-way core and positions | | |
| [L-09](#l-09) The map at two grains | | |
| [L-10](#l-10) The strong forms and coverage | | |
| [L-11](#l-11) Excluded-middle calibrations | | |
| [L-12](#l-12) Testing by stages | | |
| [L-13](#l-13) The converse in the grammar | | |
| [L-14](#l-14) The Hennessy–Milner limit and LLPO | | |
| [L-15](#l-15) Settling is LPO | | |
| [L-16](#l-16) Tails: WLPO and LPO as rules | | |
| [L-17](#l-17) Refutation, verification, double negation, Markov | | |
| [L-18](#l-18) Runs, dependent choice, finite branching | | |
| [L-19](#l-19) The pure-core discipline | | |
| [L-20](#l-20) propext as a lumping | | |
| [L-21](#l-21) Expressible is not derived | | |
| [L-22](#l-22) Premises read off one exchange | | |
| [L-23](#l-23) What the dynamics do not entail | | |
| [L-24](#l-24) Widening and positive weightings | | |
| [L-25](#l-25) Lawvere's diagonal as an unfolding | | |
| [L-26](#l-26) The completion criterion K1–K7 | | |
| [L-27](#l-27) Revision with an undecided value | | |
| [L-28](#l-28) Curry and contraction | | |
| [L-29](#l-29) The other calibrations | | |

**General.** What would an expert in relation algebra, coalgebra, constructive mathematics or modal logic add or object to, beyond the items? Is any classical result restated without credit?

**Returning the form.** Fill in the table (a copy of this file, a printout or a list by item number all serve), add any longer comments, and return it to whoever sent you the packet. Say whether your comments may be quoted, and under what description of your field.
