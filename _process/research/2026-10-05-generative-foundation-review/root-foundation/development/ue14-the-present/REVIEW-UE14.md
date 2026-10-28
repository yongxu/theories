# UE14 review: the present on causal-set growth

28 October 2026. An independent, adversarial review, AI-written, of board item UE14. It covers the module `Becoming.Presence` ([tree/Becoming/Presence.lean](tree/Becoming/Presence.lean)), its [note](NOTE.md) and [design](DESIGN.md), and the build log [scratch-11.log](scratch-11.log).

What the module was read against:
- in the package (`experiments/integrated-correction/general-framework/generative-basis/lean/becoming`): UE13's `Becoming/CausalGrowth.lean` and the core's `OrderNormal`, `Decidedness`, `Frontier`, `Frequency` and `Prelude`;
- in the chapters: [01](../../../../../../theories/becoming/chapters/01-ROOT.md) §1, §3 and its open entry on presence in time, and 07 §3;
- the [glossary](../../../../../../GLOSSARY.md), AGENTS.md and the [UE13 review](../ue13-causal-sets/REVIEW-UE13.md).

The sources checked:
- Wüthrich and Callender (2017), Rideout and Sorkin (2000), Brightwell and others (2003) and Dowker (2014), each in its arXiv edition;
- part of Rideout's thesis (2002);
- the Stanford Encyclopedia's entry on being and becoming in modern physics;
- for the order-theory attributions, search results only.

Stein's theorem was read through Wüthrich and Callender's statement of it. Third-party texts are paraphrased, not quoted.

The probes are in [probes/tree/Becoming/PresenceProbe.lean](probes/tree/Becoming/PresenceProbe.lean). The file imports an unchanged copy of the module and builds with `scratch_build.py` ([probes/build-5.log](probes/build-5.log)): 57 theorems in 63 declarations, every axiom report empty, no warning.

## Verdict

**The Lean is sound.**
- *The copy builds.* The unchanged copy builds in the probe tree with the module's own counts: 99 theorems in 120 declarations, every axiom report empty, which agrees with [scratch-11.log](scratch-11.log).
- *Pure core.* The module imports only `Becoming.CausalGrowth` and `Becoming.OrderNormal`. It uses no `simp`, `omega`, `funext`, `propext` or `Classical`, and `decide` only on closed goals. No other module or namespace of the package is named `Presence`.
- *Hypotheses and bounds.* Every theorem carries the hypotheses its claim needs. Natural labellings leave values from `size` on free, and every law about an element carries its bound, so no junk value does any work.
- *Reuse.* Law 2 is an instance of the core's `rearranges_iff`, not a reproof. The stable partition is a correct new construction.
- *Names cited.* Every Lean name the note cites is declared (153 checked by script).
- *The two calibrations are correct.*
  - `every_needs_decision` works on `onlyIf P`: `0` precedes `1` exactly where `P`. Where `P` is not refuted, every natural labelling bears `0` before `1`, since bearing `1` first refutes `P`. So the law gives `P`.
  - `present_every_needs_decision` works on `throughIf P`: `0` precedes `1` and `2`, and `1` precedes `2` exactly where `P`. Where `P` is not refuted, `0` is present at `1`'s birth on every course, and `Through` at `2` gives `P`.
  - Both say in their docstrings what the need says about the unfolding, and the note keeps them as lemmas of their laws, as AGENTS' calibration rule allows.

**The prose says more than the Lean in six places:**
- **The decision (F1).** The note says the bound on every course for presence at a birth needs decided precedence. In the form the note states as the law, the one link, it needs no decision. The decision lies only in passing to `Through`. The laws on some course need precedence only weakly decided.
- **Dowker (F2).** Her present is a birth, not a collection of atoms. Law 6's frontier is not her reading, and on her reading a condition is past at every later birth, on every course.
- **The main reading (F3).** 01's question is answered for one reading of presence, the frontier. "No relation of presence beyond the condition relation's reach" is either refuted by the module's own law on being present together or true by construction. Covariance is a premise of the model, not a result.
- **Wüthrich and Callender's relation (F4).** Read on the growth, it is the past joined with being present together on every course only on the diamond. Off the diamond that join is not their relation and is not transitive.
- **Stein (F5).** The growth gives a maximum, not a counterpart of a uniqueness theorem. `past_every_iff` is the local becoming Wüthrich and Callender already grant.
- **The stems (F6).** "Exactly the stems" needs decided membership. Brightwell and others' covariant events are stem sets, not stages.

**The readings.** They keep the two premises apart: NOTE:93 assigns scope to the continuation condition and order to calling widening better (C). Each reading carries its AI label. The standing, near-definitional, is right. F8 answers the literature check that the design left open (DESIGN:37).

**By the brief's checks:**
1. Lean against prose: F1, F4, F6, F9, F10, F17.
2. Presence and its rivals: F3.
3. Decisions: F1, F7, F18.
4. Literature: F2, F5, F6, F8.
5. Readings: F3, F13.
6. Naming: F14–F16.
7. Reuse: F11.
8. Pure core: clean.
9. Placement and record: F12.

**Recommendation:** take F1–F7 before landing; F1's corrected wording cites Lean that F7 adds to the module. F8–F13 go with the record and the landing. F14–F18 are small.

## Findings

Severity: **E** an error in a claim, **O** an over- or understatement, **I** an improvement, **S** style or naming. Line numbers are those of the reviewed files. Theorems named in a fix that the module does not have are probes (the last section), each with an empty axiom report.

**F1 (E). The decision is attached to a law that needs none, and the laws on some course need only a weak one.**

Where:
- NOTE.md:12: "The laws on every course for born before and for presence at a birth need decided precedence: without it each gives double-negation elimination".
- NOTE.md:63: "The decision cannot be dropped for the bound on every course".
- NOTE.md:11, :55, :61: "With precedence decided"; :10 and :77 give no qualifier.
- NOTE.md:104: the list of laws stated with precedence decided.
- Presence.lean:42 and :50–55: "Without the decision the second bound gives double-negation elimination".

What the probes show:
- **Presence on every course needs no decision.** Presence at `j`'s birth on every course is exactly the one link (`present_every_iff_only_link_undecided`): that is the module's `present_every_iff_only_link` with its `Decidable` instance removed. So the bound on every course needs no decision in the form NOTE:11 and :62 state as the law. The decision enters only in passing from the one link to `Through`, where everything `i` precedes is `j` or above `j`. On every causal set that passage is exactly excluded middle (`only_link_through_iff_em`). The module's own calibration, stated as an equivalence, is `present_through_iff_em`.
- **Born before and present together, with no decision.** Being born before on every course is exactly precedence not refuted (`every_iff_not_not`). Being present together on every course is exactly the same future doubly negated (`together_every_iff_not_not`). Asserting precedence or the same future from these is, on every causal set, exactly excluded middle (`every_iff_em`, `together_every_iff_em`); `past_every_iff` from left to right gives it (`past_every_needs_decision`).
  - NOTE:12 omits the law on being present together, which needs the decision exactly as the law on born before does.
- **The laws on some course need only weak decidedness.**
  - With `∀ a b, WeaklyDecided (c.prec a b)`, each holds on that causal set: `before_of_weakly`, `either_order_of_weakly`, `together_some_of_weakly`, `present_some_of_weakly`.
  - On every causal set each is exactly weak excluded middle: `before_some_iff_weakly`, `either_order_iff_weakly`, `together_some_iff_weakly`, `present_some_iff_weakly`.
  - `antichain_present` holds under weak excluded middle, and on every causal set is exactly it (`antichain_present_of_weakly`, `antichain_present_iff_weakly`). A version for one causal set with its precedence weakly decided was not probed.

Failure scenarios:
- A reader of NOTE:12 and :63 concludes that the bound on every course for presence at a birth fails without a decision. In the form the note states as the law, it does not.
- A reader of NOTE:104 takes "no global now" (`either_order`) to need excluded middle. It needs only the weak form, as the core's normal form of arrangements needs only apartness decided (`OrderNormal.complete_iff`).

Fix (wording; the Lean is F7):
- NOTE:12: "**The decision.** With no decision, being born before on every course is precedence not refuted, being present together on every course is the same future doubly negated, and presence at a birth on every course is exactly the one link. Asserting precedence, the same future, or that everything a condition precedes is at or above what it conditions, is on every causal set excluded middle. The laws on some course need precedence only weakly decided, and on every causal set each is weak excluded middle."
- NOTE:11: "… on some course exactly where `i` conditions `j` directly, a link (with precedence weakly decided), and on every course exactly where `j` is the one element `i` is linked to (with no decision)."
- NOTE:63, first sentence: "*The decision cannot be dropped* in passing from the one link to `Through`: if on every causal set presence at `j`'s birth in every natural labelling gave `Through`, every proposition not refuted would hold (`present_every_needs_decision`); the bound read as the one link needs no decision (`present_every_iff_only_link`)."
- Presence.lean:50–55: "With precedence decided (weakly decided suffices, `present_some_of_weakly`), `i` is present at `j`'s birth on some course exactly where it conditions `j` directly, a link (`present_some_iff_link`); with no decision, on every course exactly where `j` is the one element `i` is linked to (`present_every_iff_only_link`). That everything `i` precedes is then `j` or above `j` (`present_every_iff`, `Through`) needs the decision (`present_every_needs_decision`)."
- Presence.lean:42, NOTE:10 and NOTE:77: "every antichain given by a Boolean test is the present of some course at some stage (with precedence decided; weak excluded middle suffices)".
- NOTE:104: replace the list with the exact needs:
  - excluded middle, beyond double negation, for `prec_iff_every`, `past_every_iff` and `together_every_iff` from left to right, and for `present_every_iff` and `through_iff_only_link` in passing to `Through`;
  - weak decidedness for `before_some_iff`, `either_order`, `together_some_iff` and `present_some_iff_link` from right to left, and for `antichain_present`;
  - none for `present_every_iff_only_link`.

**F2 (E). Dowker's reading is not what laws 5 and 6 state.**

NOTE.md:91: "Dowker's reading of the partially ordered birth process as the passage of time, with no global now, is what laws 5 and 6 state".

Dowker (2014), in her sections on continuum spacetime as order plus scale and on growing discrete spacetime:
- puts the present moment in the birth of each atom, not in any collection of atoms;
- counts an atom, once born, as belonging to the past;
- gives births of atoms that precedence does not order no physical order, her asynchronous becoming;
- rejects a global now.

She does not speak of antichains, stems or the maximal elements of what has been born.

Law 6's present at a stage is a collection: the maximal elements of what a course has born. So it is not her present. On her reading, 01's question has an answer that does not vary with the course: at every later birth the condition is past.

What laws 5 and 6 share with her:
- unrelated elements are born in either order (`either_order`);
- a present read at a stage is a choice of course (`Vee.frontiers_differ`), consistent with her denial that stages are physical.

Fix (NOTE:91, last sentence): "Dowker reads the birth of each atom as the passage of time: the present is a birth, not a collection of atoms, what has been born is past, and births of unrelated atoms have no physical order. Law 5's `either_order` states the last of these on the growth, and `Vee.frontiers_differ` agrees that a present read at a stage is a choice of course. Her present is not law 6's frontier: read her way, a condition is past at every later birth, on every course."

**F3 (O, the main finding). The AI reading answers a narrowed question, and its general sentence is either false or true by construction.**

NOTE.md:15, :76, :89; Presence.lean:67–69; DESIGN.md:35.

- **(a) Which presence.** 01's open entry (01-ROOT.md:536) asks whether a condition must still be there when what it conditions arises. On the growth, the readings answer differently:
  - *Being in the configuration:* yes, on every course, since the growth holds its past (`CausalGrowth.step_holdsPast`; NOTE:7 says so).
  - *Dowker's present, the birth:* no, on every course; the condition is past (F2).
  - *Wüthrich and Callender's kinematic present, a maximal antichain of the configuration:* no, whatever the course, since no antichain holds a condition together with what it conditions.
  - *The module's frontier of what has been born:* on some course exactly at a link, on every course exactly at the one link.

  Only the last varies with the course. NOTE:83 discloses that the frontier is a choice of reading, but NOTE:15 and :76 say that 01's question "has an answer" without the reading.
- **(b) "Each bound is a relation of precedence" holds by construction** (NOTE:15, Presence.lean:67–69). Natural labellings depend only on size and precedence (probe `natural_congr`), so whatever is read on every course or on some course does too (`every_congr`, `some_congr`). The content lies in which relations come out:
  - for being born before: not preceded, and precedence;
  - for being present together: unrelated, and the same future;
  - for presence at a birth: the link, and the one link.

  These are relations defined from precedence, not "the condition relation's reach".
- **(c) The general sentence** (NOTE:89): "no relation of presence beyond the condition relation's reach is a relation of the unfolding; one added would be a choice of course, a foliation".
  - *Read with "reach" as precedence, the module refutes it.* On the diamond, `1` and `2` are present together on every course (`together_every_iff` with `Diamond.future_one_two`), and neither precedes the other (`Diamond.pastOrPair_pair`). That is a relation of presence every course keeps which precedence does not contain. Wüthrich and Callender's relation also goes beyond the past (`Diamond.pastOrPair_pair`). It is kept by every automorphism (`Diamond.pastOrPair_kept`), and being defined from the configuration, it is a choice of no course.
  - *Read with "reach" as "defined from precedence", the sentence holds by (b).*

  What is a choice of course is a relation read on one labelling, such as the present at a stage. The sentence runs two criteria together: being independent of the course, and being respected by every course's births. `Diamond.kept_not_agreed` separates them.
- **(d) Covariance is the model's premise, not a result.** Labels carry no physical meaning (Rideout and Sorkin), and the modelling choices read covariance only as relabelling. Given that premise, (b) makes the conclusion near-definitional. The earned form: a relation of presence adds to the grammar only what its condition relation defines, so the lack of a primitive one loses no covariant content in this model.
- **(e) NOTE:76** says that "what every course keeps of it is two relations of precedence, the link and the one link". The link is what holds on some course; only the one link holds on every course.

Fix:
- NOTE:15: "**[AI reading, D45]** In this model 01's open question has an answer for each reading of presence. Read as being in the configuration, a condition is still there, on every course; read as Dowker's present, the birth, or as a maximal antichain of the configuration, it is not, whatever the course. Read as being on the frontier of what has been born, the answer varies with the course, between two bounds that do not: present on some course exactly at a link, on every course exactly at the one link. Whatever every course keeps, or some course has, is defined from precedence, since the natural labellings are (`natural_congr`); a relation of presence read on one course is a choice of course. So, given covariance, a premise of the model, the grammar's condition relation defines every relation of presence the growth keeps, and its lack of a primitive relation of presence in time loses no covariant content here (§4)."
- NOTE:76: "In one model of becoming in which it can be asked exactly, 01's open question has an answer for presence read as being on the frontier of what has been born: whether a condition is present when what it conditions is born varies with the course, holding on some course exactly at a link and on every course exactly at the one link."
- NOTE:89, from "Read as being in the present": "Read as Dowker's present, the birth, a condition is past at every later birth; read as a maximal antichain of the configuration, it is never present with what it conditions. Read as being on the frontier of what has been born, the answer depends on the course: [the next sentence as it stands]. Being born before and being present together go the same way. Whatever every course keeps, or some course has, is defined from precedence (`every_congr`); some of it goes beyond precedence itself, since being present together on every course relates elements neither of which precedes the other, and a relation read on one course, a present at a stage or a foliation, is a choice of course. So, given covariance, a premise of the model, the grammar's condition relation defines every relation of presence the growth keeps, and its lack of a primitive relation of presence in time loses no covariant content here; the entry stays open for continuous time, for the present of a center and for growths whose courses are not all equal."
- Presence.lean:67–69: "So each relation of presence read on a course (born before, present at a birth, present together) has two bounds, what holds on some course and what holds on every course; both are defined from precedence, as everything read on all courses is, and which presence holds between them is a choice of course."
- Add `natural_congr`, `every_congr` and `some_congr` to the module.

**F4 (O). Wüthrich and Callender's relation, read on the growth, is stated beyond the diamond.**

Where:
- Presence.lean:70–72: "on the growth it joins what has been born by a birth with a relation of being present together".
- Presence.lean:1107–1108: the docstring headline of `Diamond.pastOrPair_iff_together`, which has no scope.
- NOTE.md:78 and :91: "their relation adds to it a relation of presence, being present together on every course".
- NOTE.md:84, which understates.

Wüthrich and Callender's general notion (their §3) is the non-Hegelian pair: distinct elements with the same past and the same future. The analogue of Stein's theorem fails wherever such pairs exist. Being present together on every course needs only the same future (`together_every_iff`). Off the diamond the two come apart, on four elements where `0` is below `1` and `3`, and `1` and `2` are below `3`:
- `SameFuture.together_different_pasts`: `1` and `2` are present together on every course, yet `0` precedes `1` and not `2`. So they are not a non-Hegelian pair.
- `SameFuture.pastOrTogether_not_trans`: the past joined with being present together on every course relates `2` to `1` and `1` to `0`, but not `2` to `0`. The join is not transitive, so it is not a relation of becoming in Stein's sense. Wüthrich and Callender's relation, the past with its non-Hegelian pairs, is transitive, and on these four elements it is the past alone.
- On the diamond the join is their relation (`Diamond.pastOrPair_iff_together`; probe `pastOrTogether_diamond`).

```lean
theorem SameFuture.pastOrTogether_not_trans :
    PastOrTogether sameFuture 2 1 ∧ PastOrTogether sameFuture 1 0 ∧ ¬ PastOrTogether sameFuture 2 0
```

Fix:
- Presence.lean:70–72: "Invariance under automorphisms admits Wüthrich and Callender's relation beside the past; on the diamond it is the past joined with being present together on every course (`Diamond.pastOrPair_iff_together`). In general their pairs share the past as well as the future, and the join need not be transitive."
- Docstring at :1107: "**On the diamond, Wüthrich and Callender's relation is the past with the pair present together on every course**".
- NOTE:78 and :91: add "on the diamond".
- NOTE:84: "… on other causal sets it is not: their pairs share the past as well as the future, and elsewhere the join is not transitive (`SameFuture.pastOrTogether_not_trans`)", with the witness added to the module.

**F5 (O). Stein: the growth gives a maximum, not a counterpart of a uniqueness theorem, and the reply to Wüthrich and Callender is one they grant.**

Where:
- Presence.lean:33–35 and :528–530: "the conclusion of Stein's theorem read on growth".
- Presence.lean:514–516: "the counterpart there of Stein's theorem".
- NOTE.md:9 and :78.
- NOTE.md:47: "with every course in place of every automorphism".
- NOTE.md:91.
- DESIGN.md:27.

**Uniqueness against identification.** Stein's theorem is a uniqueness result: a relation meeting its conditions, among them invariance under the automorphisms that preserve time orientation, can only be the causal past. Invariance is a condition on the candidate relation. `prec_iff_every` and `past_every_iff` do something else: they identify one relation, being born no later on every course, with the past. "Every course" there is a quantifier inside the relation, not a condition on candidates.

**What the growth gives in Stein's shape is a maximum.** The past is the largest relation every course respects (probe `past_largest`, from `past_every_iff`):
```lean
theorem past_largest {c : Causet} [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered)
    (R : Nat → Nat → Prop) (respected : ∀ x y, R x y → ∀ π σ, Natural c π σ → π y ≤ π x)
    {x y : Nat} (hx : x < c.size) (hy : y < c.size) (pair : R x y) : y = x ∨ c.prec y x
```
On the growth, the counterpart of Stein's condition is invariance under relabelling, and it admits Wüthrich and Callender's relation beside the past (`Diamond.kept_not_agreed`), as DESIGN:29 says.

**Wüthrich and Callender already grant this becoming** (their §3–4). They grant a Stein-type relation defined from the causal order: the local becoming of a past light cone, or Sorkin's asynchronous multiplicity of nows, which is observer-dependent. They set it aside for the global becoming they ask about. `past_every_iff` is that local becoming, read on courses. It agrees with them and leaves their negative result for a single causal set standing. NOTE:91 frames it as an answer ("On the growth the invariance asked for is over courses …").

**Attribution (small).** The intersection form, a finite order being the intersection of its linear extensions, is usually credited to Dushnik and Miller (1941), who derive it from Szpilrajn's extension theorem. NOTE:97 cites both; the header (:33) and the docstring (:514–515) cite only Szpilrajn.

Fix:
- Presence.lean:514–516: "(Szpilrajn's extension theorem in Dushnik and Miller's intersection form, read on growth)", dropping "the counterpart there of Stein's theorem".
- Header :34–35 and docstring :528–530: "(the relation Stein's theorem singles out, here as the largest relation every course respects)".
- NOTE:47, from "So what is born": "So what is born no later than `x` in every natural labelling is `x`'s past with `x` (`past_every_iff`). This is the relation Stein's theorem singles out, here as the largest relation every course respects (`past_largest`), not by uniqueness under invariance. Invariance under relabelling, the counterpart of Stein's condition, admits Wüthrich and Callender's relation as well (`Diamond.kept_not_agreed`)."
- NOTE:91, first two sentences: "Wüthrich and Callender find Stein's theorem false for a single causal set, since invariance under the automorphisms of one configuration admits a relation beyond the past. They grant a local becoming defined from the causal order and ask instead about a global becoming, in which only the number of elements born is determinate. `past_every_iff` is that local becoming read on courses, the largest relation every course respects; it agrees with them and leaves their negative result standing."

**F6 (O). Law 4: "exactly the stems" drops the decision, Brightwell and others are misattributed, and "of `t` elements" and "says more" overstate.**

Where:
- NOTE.md:42: "So the stages of the courses are exactly the stems, the down-sets Brightwell and others use as the covariant content of a stage of growth".
- NOTE.md:91: "What has been born after `t` births is any stem of `t` elements … which agrees with their global becoming and says more".
- Presence.lean:29–31.
- DESIGN.md:26.

The problems:
- **The decision.** What a course has born by a stage is a stem whose membership is decided (`π x < t`), and `stem_born_first` needs decided membership. So the stages are exactly the stems with decided membership; "exactly the stems" holds only with that qualifier.
- **Brightwell and others.** In their §2–3 a stem is a finite set closed under taking ancestors. A stem set is the completed causets containing a stem of a given kind: equivalently, those having a natural labelling whose first `n` elements form it. That equivalence is law 4, on finite causal sets; cite it as theirs. They do not read a stage of growth as physical. What they prove is that stem sets generate the covariant events up to sets of measure zero, for generalized percolation. "The covariant content of a stage of growth" is not their claim.
- **"Of `t` elements".** The module proves that the stage is a stem (`born_stem`). It proves that a stem with decided membership is born first, in as many births as it has elements (`stem_born_first`). It does not prove that what is born by stage `t` has `t` elements.
- **"Says more".** Wüthrich and Callender's example, in which one of two candidates is born with no fact which, already says which sets can have been born. What law 4 adds is the general statement on finite causal sets.

Fix:
- NOTE:42: "So the stages of the courses are exactly the stems with decided membership. This is Brightwell and others' characterization of stem sets (a completed causet has a stem of a kind exactly where the first elements of some natural labelling form it), here on finite causal sets. Their stem sets, not stages, are the covariant events, proved to generate them up to measure zero for generalized percolation."
- Presence.lean:30–31: "…: the stems are what courses bear first, Brightwell and others' characterization of their stem sets."
- NOTE:91: "What has been born by a stage is a stem, and every stem with decided membership is what some course has born first, in as many births as it has elements (law 4): this states in general what their example of two candidates shows."

**F7 (I). Put the decision-free laws and the exact needs in the module.**

Presence.lean:576–596 (`every_needs_decision`), :821–825 (`present_every_iff_only_link`), :850–876 (`present_every_needs_decision`); NOTE.md:49, :63, :97, :104.

F1's wording cites Lean that the module does not yet have. From the probes, in the core's vocabulary (`Decided`, `WeaklyDecided`, both already in the leaf's imports through `Becoming.Decidedness`):
- Drop the `Decidable` instance from `present_every_iff_only_link`, with the proof of `present_every_iff_only_link_undecided`. It needs `through_of_only_not_not`, `present_every_of_only_link` and `only_link_of_present_every`, and the table lemmas `Tabulates`, `table_not_not`, `natural_of_table`, `table_false` and `down_closed`.
- Add `every_iff_not_not` and `together_every_iff_not_not`.
- State the calibrations as equivalences: `every_iff_em`, `together_every_iff_em`, `present_through_iff_em`, `only_link_through_iff_em`.
- Add the weak forms for the laws on some course (`before_of_weakly`, `either_order_of_weakly`, `together_some_of_weakly`, `present_some_of_weakly`), and if wanted their equivalences with weak excluded middle.

```lean
theorem every_iff_not_not {c : Causet} (ordered : c.Ordered) {i j : Nat} (hi : i < c.size)
    (hj : j < c.size) : (∀ π σ, Natural c π σ → π i < π j) ↔ ¬ ¬ c.prec i j
theorem together_every_iff_not_not {c : Causet} (ordered : c.Ordered) {x y : Nat} (hx : x < c.size)
    (hy : y < c.size) :
    (∀ π σ, Natural c π σ → ∃ t, OnFrontier c π t x ∧ OnFrontier c π t y) ↔
      ∀ k, (c.prec x k → ¬ ¬ c.prec y k) ∧ (c.prec y k → ¬ ¬ c.prec x k)
theorem present_every_iff_only_link_undecided {c : Causet} (ordered : c.Ordered) {i j : Nat} :
    (∀ π σ, Natural c π σ → PresentAt c π i j) ↔ links c.prec i j ∧ ∀ k, links c.prec i k → k = j
theorem only_link_through_iff_em :
    (∀ c : Causet, c.Ordered → ∀ i j, links c.prec i j → (∀ k, links c.prec i k → k = j) →
      Through c i j) ↔ ∀ p : Prop, Decided p
theorem either_order_of_weakly {c : Causet} (weakly : ∀ a b, WeaklyDecided (c.prec a b))
    (ordered : c.Ordered) {x y : Nat} (hx : x < c.size) (hy : y < c.size) (nxy : ¬ c.prec x y)
    (nyx : ¬ c.prec y x) (ne : x ≠ y) :
    (∃ π σ, Natural c π σ ∧ π x < π y) ∧ (∃ π σ, Natural c π σ ∧ π y < π x)
```

**How the proofs avoid the decision.** A test on the first `n` numbers has a table doubly negated (`table_not_not`). That suffices wherever the goal is a refutation or a comparison of numbers.

**What the needs say about the unfolding,** for AGENTS' calibration rule:
- Agreement across all courses settles a relation only up to double negation. Asserting that one element conditions another, or shares its future, is deciding it.
- Finding a course that shows a link present at a birth, or two unrelated elements in either order, is deciding, for each pair, only whether its precedence fails.

Kept as lemmas of their laws, as NOTE:49 and :63 keep the two now there, they stay lemmas. Stated with this meaning in the record, they could stand as one result. NOTE:97's "two calibrations" becomes the list above.

**F8 (I). The literature check the design and the note leave to the review.**

NOTE.md:97: "whether the bounds are stated there is for the review to check"; DESIGN.md:37.

What the sources read state:
- **Rideout and Sorkin (§1.1, §3).**
  - Natural labellings are the linear extensions, and links are the irreducible relations.
  - A partial stem is a finite set containing its own past.
  - Partial stems correspond one to one with antichains, their maximal elements; this is asserted without proof.
  - Labels carry no physical meaning, and there is no order of birth beyond what precedence implies.

  `frontier_front` and `antichain_present` are this correspondence read at a stage. Law 2 and `either_order` are the absence of an order of birth beyond precedence.
- **Brightwell and others (§2–3).** Stems, and stem sets defined through the first elements of a natural labelling: law 4 (F6).
- **Wüthrich and Callender (§3–4).**
  - Labels respect precedence, and unrelated pairs are ordered either way across labellings: `either_order`.
  - Their co-presentness of non-Hegelian pairs, the same past and the same future, is the nearest statement to `together_every_iff`, and it is strictly narrower (F4).
- **Not found.** No source states the bounds on presence at a birth (the link, the one link) or on being present together (unrelated, the same future), or any present read on a stage of a course. Rideout and Sorkin and Brightwell and others use maximal elements only in technical roles, and Dowker does not use antichains. Part of Rideout's thesis was also read, with the same result.

Fix: replace NOTE:97's open clause with "In causal set theory, natural labellings as linear extensions, links, partial stems and their correspondence with antichains are Rideout and Sorkin's; stem sets through the first elements of natural labellings are Brightwell and others'; and the order of births of unrelated elements as gauge is theirs and Wüthrich and Callender's. The bounds of laws 6 and 7 are not stated in these sources; Wüthrich and Callender's co-presentness of non-Hegelian pairs is the nearest, and it is narrower than being present together on every course."

DESIGN:37's rule ("if it does, the containment restates") then applies to law 2, law 4 and the correspondence of stems and antichains, and the record should say so.

**F9 (I). The orders of birth as one theorem.**

Where:
- Presence.lean:19–20: "So the natural labellings are the orders of birth of the courses growing a configuration's kind".
- Presence.lean:411–412: the docstring of `courseOf_isomorphic` says "and through a natural labelling every order of its births", which its statement does not contain.
- NOTE.md:8 and :27: "not stated as one theorem".

The headline of law 1 is read from three theorems. The probe states it as one; it needs `CausalGrowth.ordered_of_empty` and `CausalGrowth.size_of_run` for the converse:
```lean
theorem orders_of_birth {c : Causet} (ordered : c.Ordered) {π σ : Nat → Nat} :
    Natural c π σ ↔ ∃ r : Run process, r.state 0 = empty ∧
      CausalGrowth.Kinds.Relabels c (r.state c.size) π σ
```

Fix:
- Add the theorem to the module.
- Cite it at :20, NOTE:8 and NOTE:27, dropping "not stated as one theorem".
- Cut :411–412 to what the theorem says: "So every causal set is a course's configuration up to kind."

**F10 (I). The header's modelling paragraph omits the decisions.**

Presence.lean:74–77. NOTE:104 states decided precedence and decided membership, but the header does not, although its laws carry them.

Fix: after "covariance read only as relabelling;" insert "precedence decided where a law says so (weakly decided suffices for the laws on some course, and presence on every course needs no decision), membership decided for `stem_born_first`, antichains given by a Boolean test;".

**F11 (I). Reuse: the counting and Boolean lemmas restate the package's.**

Presence.lean:89–196, the counting section, with the Boolean lemmas at :157–176.
- **`count`.** It computes `Frequency.count` (`Becoming/Frequency.lean:139`; the definitions differ only in `cond` against `bif … then 1 else 0`). Five of its lemmas restate Frequency's: `count_succ_of_true` (`count_succ_on`), `count_succ_of_false` (`count_succ_off`), `count_le_succ`, `count_mono` and `count_le`. Importing `Becoming.Frequency` would add six modules to the leaf's closure: `Closing`, `Counterfactual`, `Frequency`, `Loops`, `Propagation`, `Remainder`.
- **Boolean lemmas.** `bool_or_true`, `bool_and_true`, `false_of_not_true` and `not_true_of_false` restate the prelude's `ListTests.or_true_iff`, `ListTests.and_true_iff`, `ListTests.false_of_not` and `ListTests.not_eq_true_of_false` (`Becoming/Prelude.lean:221`, :216, :438, :446).
- **Two names with other statements.** The root's `Becoming.bool_and_true` (Prelude.lean:492) takes two hypotheses to a conjunction, and `ListTests.false_of_not_true` (Prelude.lean:442) starts from `¬ b = true`. Inside `Becoming.Presence` the module's lemmas shadow them.

Fix:
- Use the prelude's four lemmas (`open ListTests (and_true_iff or_true_iff false_of_not not_eq_true_of_false)`) and delete the local copies.
- For `count`, either import `Becoming.Frequency` and keep only the new lemmas (`count_le_add`, `count_lt_of`, `count_inj`, `count_reaches`, `count_pos_iff`, `count_add_not`), or keep the local `count` and say in its docstring and in NOTE §2, law 3, that it restates `Frequency.count` to keep the leaf's imports to `CausalGrowth` and `OrderNormal`.

**F12 (I). Placement and the record.**

NOTE.md:102–103.
- **The clash check is done** (NOTE:103 says it is still to run). The package has no other `Becoming.Presence` module and no other `Presence` namespace. The module's names resolve inside its namespace, apart from the shadowing in F11, and the probes build against it.
- **Landing needs what UE13's landing (b6d4f1493) had:**
  - the record, homed at 01 §1 after *precedence and its links* as NOTE:102 proposes, consistent with UE13's placement;
  - its entry in `regions.json`;
  - 01's open entry narrowed;
  - 08 §8's bullets and counts;
  - the study entry and the UE plan's item on presence in time (PLAN §5);
  - the module in `check_becoming.py`'s core list (line 82), with a scope string like causal growth's (:1757);
  - `import Becoming.Presence` and a bullet in `Becoming.lean` (beside :100 and :1439);
  - an L1 row in `README.md` and `README.zh.md` (beside :152 and :114).
- **The narrowed open entry (01-ROOT.md:536) should carry F3's scope.** On the growth, read as being on the frontier of what has been born, presence of a condition at what it conditions holds on some course exactly at a link and on every course exactly at the one link. Read as being in the configuration, as Dowker's birth or as a maximal antichain, it does not vary with the course. The entry stays open for continuous time and a center's present.

**F13 (I). The continuation reading and "no global now".**

NOTE.md:93; NOTE.md:9 and :77; Presence.lean:37 and :544.
- **The continuation reading** (NOTE:93) reads "the future" of something as its up-set. In the grammar, continuation is continuation under a class. On the growth, under the one class it is precedence, and under a finer class it is part of precedence, read on precedence or on links (UE13's `Finer`). Each is defined from precedence and the class, never from a course. The scope claim therefore holds for every class, not only for the up-set; say so.
- **"No global now"** (NOTE:9, :77; Presence.lean:37, :544). `either_order` shows that unrelated elements have no order of birth common to all courses. Which elements have been born by a stage is a choice of course, but how many is not. That count is Wüthrich and Callender's global becoming, which NOTE:91 says the laws agree with. Write "no order of birth of unrelated elements common to all courses", or "no global now beyond the number born".

**F14 (S). `OnFrontier` is an instance of the core's `Requirement.Frontier`: say so, or rename.**

Presence.lean:606–609; NOTE.md:53.

The package's frontier is the set of eligible alternatives that no eligible alternative betters (`Becoming/Frontier.lean:72`). The probe `onFrontier_iff_frontier` shows that `OnFrontier c π t x` is that frontier of what has been born by `t`, with `b` bettering `a` read as `a` preceding `b`. As an instance, the word is exact; read alone, it brings a comparison into a relation of presence.

Fix, one of:
- add the instance (it imports `Becoming.Frontier`) and the docstring sentence "the core's `Requirement.Frontier` of what has been born, with precedence as the comparison and no evaluation";
- rename to `MaximalBorn` ("`x` is a maximal element of what `π` has born by stage `t`") and keep "the present at a stage" for the reading.

**F15 (S). "Every line from `i` passes through `j`" uses the glossary's word in another sense.**

Presence.lean:751, :759–760, :790–791, :806, :851–853, :944; NOTE.md:63–64.

The glossary's line is the reach of continuation (GLOSSARY.md:13): a relation, not a path. `Through c i j` says that everything `i` precedes is `j` or above `j`. Together with `c.prec i j`, it says `j` is the least element above `i`.

Fix:
- Use the definition's own words: "everything `i` precedes is `j` or above `j`".
- Consider `LeastAbove c i j := c.prec i j ∧ ∀ k, c.prec i k → k = j ∨ c.prec j k`, so that `present_every_iff` reads `↔ LeastAbove c i j`.

**F16 (S). Other names.**
- `Related` (Presence.lean:424–425): elements related either way are *comparable*, the order-theoretic word. Rename to `Comparable`.
- `Natural` (:317–320): the property is a natural labelling, as the note says throughout. Rename to `NaturalLabelling`.
- `front` and `back` (:201, :205): the docstring calls the construction the stable partition. Rename to `stablePartition` and `stablePartitionInverse`, or keep the names and say so in their docstrings.
- `onlyIf` (:566) repeats the name of UE13's `CausalGrowth.Undecided.onlyIf` (CausalGrowth.lean:897), which is a different witness, a course. Rename to `pairIf`.

**F17 (S). The vee's present after two births is shown only for `1` and `2`.**

Presence.lean:57–58 ("the present after two births is `1` on one course and `2` on another") and :949–957 (`Vee.frontiers_differ`); NOTE.md:56.

`frontiers_differ` shows whether `1` and `2` are on the frontier, but it does not exclude `0`. The probes `present_after_two_identity` (`OnFrontier vee (fun i => i) 2 x ↔ x = 1`) and `present_after_two_swap` (`↔ x = 2`) give the present exactly.

Fix: add the two probes. Otherwise write "after two births, `1` is on the frontier and `2` is not on one course, and the reverse on another".

**F18 (S). State the calibrations in the core's vocabulary, as equivalences.**

Presence.lean:576–583 and :850–858. Both calibrations conclude `∀ P : Prop, ¬ ¬ P → P`. The core's `Decided` and `WeaklyDecided` (`Becoming/Decidedness.lean:100`, :810) name the principles the other calibrations use, and the equivalences are what the probes prove (`every_iff_em`, `present_through_iff_em`).

Fix: restate them as in F7.

## Probes

**The tree:** `probes/tree/Becoming/`. It holds a byte-identical copy of `Presence.lean` and `PresenceProbe.lean`, namespace `Becoming.Presence.Probe`. The probe file imports the module, and `Becoming.Frontier` only for `onFrontier_iff_frontier`.

**The build command**, from the package folder:

`python3 -B scratch_build.py <…>/ue14-the-present/probes/tree Becoming.Presence Becoming.PresenceProbe`

**Logs:**
- [build-1.log](probes/build-1.log): elaboration errors, from a beta-redex left in `table_false`'s statement.
- [build-2.log](probes/build-2.log): three unused-variable warnings.
- [build-3.log](probes/build-3.log): clean, 55 theorems in 61 declarations.
- [build-4.log](probes/build-4.log): clean, after `some_congr` and `past_largest` were added and the header and three docstrings reworded; probe audit only.
- [build-5.log](probes/build-5.log): final, with both audits.
  - `Becoming.Presence`: 99 theorems in 120 declarations.
  - `Becoming.PresenceProbe`: 57 theorems in 63 declarations.
  - Both `with_axioms: {}`, no warning.

Every step of build-5 was restored from the checker's step cache under identical inputs. The module copy's compile was restored the same way in every build; no fresh build was forced.

The probes use no `simp`, `omega`, `funext`, `propext` or `Classical`, and `decide` only on closed goals.

| Block | Declarations | Findings |
|---|---|---|
| Tables | `Tabulates`, `beq_false_of_ne`, `table_yes`, `table_no`, `table_not_not`, `table_of`, `natural_of_table`, `table_false`, `down_closed` | the device behind every law without a decision (F1, F7) |
| Every course | `every_not_not`, `every_iff_not_not`, `every_iff_em`, `past_every_needs_decision`, `through_not_not`, `present_through_iff_em`, `apartIf`, `apartIf_ordered`, `together_every_needs_decision`, `together_not_not`, `together_every_iff_not_not`, `together_every_iff_em` | the forms without a decision; excluded middle exactly (F1, F7, F18) |
| One link | `through_of_only_not_not`, `present_every_of_only_link`, `only_link_of_present_every`, `present_every_iff_only_link_undecided`, `only_link_through_iff_em` | the bound on every course needs no decision; the decision lies in passing to `Through` (F1, F7) |
| Some course | `weakly_of_deMorgan`, `middleIf`, `middleIf_ordered`, `middleIf_not_two_zero`, `middleIf_not_zero_two`, `either_order_deMorgan`, `before_of_weakly`, `either_order_of_weakly`, `either_order_iff_weakly`, `before_some_iff_weakly`, `together_some_deMorgan`, `together_some_of_weakly`, `together_some_iff_weakly`, `together_of_antichain`, `antichain_present_of_weakly`, `antichain_present_iff_weakly`, `linkIf`, `linkIf_ordered`, `present_some_deMorgan`, `present_some_of_weakly`, `present_some_iff_weakly` | weak excluded middle exactly (F1, F7) |
| Composition and invariance | `orders_of_birth`, `natural_congr`, `every_congr`, `some_congr`, `past_largest`, `onFrontier_iff_frontier` | F9; F3 (b); F5; F14 |
| Witnesses | `present_after_two_identity`, `present_after_two_swap`, `PastOrTogether`, `SameFuture.sameFuture` and its instance, `SameFuture.prec_below`, `SameFuture.ordered`, `SameFuture.future_one_two`, `SameFuture.together_different_pasts`, `SameFuture.pastOrTogether_not_trans`, `pastOrTogether_diamond` | F17; F4 |

Nothing was written outside `ue14-the-present/probes/` and this file. The probe tree's `.build/` is scratch output (ignored by git) and can be removed once no session uses it.
