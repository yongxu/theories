# Third round: formal

30 October 2026. The third-round check, of the second round's changes only, the formal lens (one Opus reader, read-only), as returned. How each finding was taken is in [NOTE §6](../NOTE.md#6-the-third-round).

**Review of the 理 changes after round 2 (formal lens): three findings survive**

I compiled `review/CoreAndLi.lean` against a fresh scratch build of the package's `Grammar`, `Prelude`, `GrammarMap` and `GrammarLaws` (toolchain v4.29.1, built under /private/tmp). It compiles, all four axiom reports are empty, and the output matches `CoreAndLi.log` byte for byte. All its definitions and lemmas are the package's; only `branching` is local.

**What holds**
- **01 §4, first sentence.** With `«定后»`, the core of a class is a class inside `E` that the step goes alike across. `coreOfClassGoesAlike` proves it from `«核为类»`, `«根»`.1 and `«有常定后则同行»` with `«根»`.2.1.
- **Second sentence.** With a successor everywhere, every class inside `E` that goes alike lies in the core. `goesAlikeInsideCore` proves it from totality alone, so the Lean is a little stronger than the sentence.
- **"So the core is the coarsest such class."** `coreIsCoarsestGoingAlike`, with class, fixed and total, exactly.
- **Counterexample.** `coreNeedNotGoAlike` is valid.
- **The three names.** `«守理则不穷»` (GrammarRegularity.lean:86) and `«亡前理变»` (:118) take any `E`, and `«足以定理»` (Grammar.lean:584) is defined for any `E₁`, `E₂`.
- **Glossary row.** Its claims are exact.
- **Round-2 S1, S6, S7 and L1, L3.** Taken correctly in the paragraph and the row.
- **Links.** All resolve: the check link from theories/becoming/chapters/ reaches the file, and `#r-master-laws-on-the-grammar`, `03-KNOWING.md#li` and `#constancy-and-core` exist.

**1. NOTE §2 lists a name that needs a class as one stated for every relation**
- **File:** `rv21-one-sense/NOTE.md`, line 46.
- **Words:** "The root's names on cores that write 理 (`«守理则不穷»`, `«守理之线不亡»`, `«亡前理变»`, `«有亡之线两端理异»`, `«足以定理»`) are stated for every relation `E`, not only for classes".
- **Why it is wrong:**
  - `«有亡之线两端理异»` takes `(hE : «类» E)` (GrammarRegularity.lean:132). 01 §4 itself says "where `E` is a class" for it.
  - Lesser, the same scope fault: 01 §4's new sentence "The names below that write 理 (`«守理则不穷»`, `«亡前理变»`, `«足以定理»`) are stated for the core of every relation `E`", and the glossary row's "The root's names on cores that write 理 (…)", list three names. The paragraph right below adds `«守理之线不亡»` (any `E`, :111) and `«有亡之线两端理异»` (class only), and §5 adds `«合有常则足以定理»` (two classes, Grammar.lean:595). Read as covering every name below, the sentence is false for the two that need classes. Read as a closed list, it is true but leaves names out.
- **Fixes:**
  - NOTE: "The root's names on cores that write 理 (`«守理则不穷»`, `«守理之线不亡»`, `«亡前理变»` and the definition `«足以定理»`) are stated for every relation `E`, not only for classes, and mean its core; `«有亡之线两端理异»` and `«合有常则足以定理»` take classes."
  - 01 §4 (EDITS): "Of the names below that write 理, `«守理则不穷»`, `«守理之线不亡»`, `«亡前理变»` and the definition `«足以定理»` are stated for the core of every relation `E`, and `«有亡之线两端理异»` and `«合有常则足以定理»` for classes."
  - Glossary: "The root's names on cores that write 理 (`«守理则不穷»`, `«亡前理变»`, `«足以定理»`; `«有亡之线两端理异»` takes a class) mean the core of the relation they are stated for, shown a 理 where it is a class and the successor fixed".

**2. S1, S5 and L2 were not taken in two places**
- **Words, place 1:** `kit/repoint_os.py`, the REASON string: "the core a 理 only along a fixed step that always continues". `tools/research/repoint.py` writes this into the tracked `_process/architecture/rebinds.jsonl` at landing.
- **Words, place 2:** NOTE §4, line 84: "(the core a 理 only along a fixed, continuing step; …)".
- **Why "only" is wrong (S1):** the Lean conditions are sufficient, not necessary. The flame of 01 §5 has a fixed step and ash has no successor, yet its class cores are 理 by `«有常定后则同行»` and `«核为类»`.
- **Why "continues/continuing" is wrong (S5, L2):** it gives 续 a second sense. The glossary's continuation row defines 续 under a class. L2 named the REASON string by name, and S5 named NOTE §4, yet NOTE §5 records both as taken.
- **Fix, REASON:** "the core of a class a 理 where the step's successor is fixed, and its 理 where every occurrence also has a successor".
- **Fix, NOTE §4:** "(the core called a 理 in every net, which the Lean shows for a class with the successor fixed; a second sense of "goes alike")".

**3. The counterexample: the Lean states less than the sentence claims, and the sentence cites nothing**
- **Words (01 §4 EDITS):** "Off a fixed successor the core need not go alike: where one occurrence steps to two, the core of the identity relates the first to itself, and the step does not go alike across it."
- **What is missing in the Lean:** `coreNeedNotGoAlike` states only `¬ «同行» branching («核» branching «静»)`. Three things the sentence relies on are not in the statement:
  - that the identity is a class (needed under "Let `E` be a class");
  - that `branching` is off a fixed successor;
  - that the core relates `0` to itself, which is only a `have` inside the proof.
- **What is missing in the text:**
  - The `[check]` link sits one sentence earlier, so this sentence cites no declaration (08 §2: a sentence "cites the declaration whose strength matches the sentence").
  - The label does not mark a witness (08 §2: "(…; witness) | a constructed example, labelled as one").
  - "The first" can be read as the first of the two successors.
- **Fix, CoreAndLi.lean.** Replace `coreNeedNotGoAlike` with this version. It compiles against the package build, axiom report empty.
```lean
/-- Off a fixed successor the core of a class need not go alike: under `branching` the identity is a class,
its core relates `0` to itself and not `1` to `2`, and the step does not go alike across it. -/
theorem coreNeedNotGoAlike :
    «类» («静» : «际» Nat) ∧ ¬ «定后» branching ∧ «核» branching «静» 0 0 ∧ ¬ «核» branching «静» 1 2 ∧
      ¬ «同行» branching («核» branching «静») := by
  have hid : «核» branching «静» 0 0 :=
    ⟨«静», fun _ _ h => h, fun _ _ h => h.symm, «静有常» branching, rfl⟩
  have apart : ¬ «核» branching «静» 1 2 := fun ⟨_, hS, _, _, h12⟩ => by
    have same : (1 : Nat) = 2 := hS 1 2 h12
    exact absurd same (by decide)
  refine ⟨⟨fun _ => rfl, Eq.symm, Eq.trans⟩, fun fixed => ?_, hid, apart, fun h => ?_⟩
  · have same : (1 : Nat) = 2 := fixed 1 2 ⟨0, ⟨rfl, Or.inl rfl⟩, ⟨rfl, Or.inr rfl⟩⟩
    exact absurd same (by decide)
  · exact apart (h 1 2 ⟨0, ⟨0, ⟨rfl, Or.inl rfl⟩, hid⟩, ⟨rfl, Or.inr rfl⟩⟩)
```
- **Fix, label (01 §4):** "(root; composed from the declarations it cites, with a witness, checked outside the package)".
- **Fix, text (01 §4):** replace "the 理 of `E` ([check](CoreAndLi.lean), a declaration proposed for `Becoming.GrammarLaws`). Off a fixed successor … across it." with: "the 理 of `E`. Off a fixed successor the core need not go alike: where one occurrence steps to two, the identity is a class whose core relates that occurrence to itself and not its two successors to each other, so the step does not go alike across it ([check](CoreAndLi.lean), the composition a declaration proposed for `Becoming.GrammarLaws`)." Keep the same link target.

**Outside this lens:** the `repoint_os.py` docstring still says "marked as unmarked 生生". That keeps the round-1 language-9 word that NOTE §4 records as taken.

Files read:
- /Users/ren/theories/AGENTS.md (in context)
- /Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21-one-sense/NOTE.md
- /Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21-one-sense/kit/one_sense.py
- /Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21-one-sense/kit/repoint_os.py
- /Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21-one-sense/review/CoreAndLi.lean
- /Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21-one-sense/review/CoreAndLi.log
- /Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21-one-sense/review/Witness.lean
- /Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21-one-sense/review/REVIEW-FORMAL.md
- /Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21-one-sense/review/REVIEW-SENSES.md (理 parts)
- /Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21-one-sense/review/REVIEW-2-SUBSTANCE.md
- /Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21-one-sense/review/REVIEW-2-LANGUAGE.md
- /Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21-one-sense/review/combined-2.diff.txt (理 lines)
- /Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Grammar.lean (75–95, 300–410, 582–597)
- /Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarLaws.lean (684–695, 1280–1370)
- /Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarRegularity.lean (1–140)
- /Users/ren/theories/theories/becoming/chapters/01-ROOT.md (§4–§7)
- /Users/ren/theories/theories/becoming/chapters/03-KNOWING.md (§6)
- /Users/ren/theories/theories/becoming/chapters/08-METHOD.md (§2)
- /Users/ren/theories/tools/research/repoint.py (header)
- Scratch check: /private/tmp/claude-501/-Users-ren-theories/9aba857c-ddb0-4120-8fd6-1280d56ef976/scratchpad/coreli/src/Fix2.lean

*The placeholder link `(…CoreAndLi.lean)` in the quoted passages was pointed at this folder's file on 30 October 2026; the text is otherwise as returned.*
