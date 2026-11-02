# SJ: fourth review (the last landing's texts and Lean)

*AI-authored record, 2 November 2026. One read-only reviewer read SJ's last landing at c69077266 (GuardHorizon's bridge, the map at 08 §7, 07 §5's sentence, 03 §12's home, the root module's bullet and README row, the record edits in kit/reland_sj2.py and the study text) against the Lean, and one adversarial verifier read each finding and looked for misses: 2 agents, about 289 thousand subagent tokens, proposed with its count and agreed by the coordinator. 12 of 12 findings were verified real and 4 misses added; every one is taken, as below.*

Links quoted from the chapters are shown as code: their relative targets resolve from the chapters, not from this folder.

## Dispositions

1. **major**, verified real, major: theories/becoming/chapters/08-METHOD.md, block <a id="what-a-response-takes-in">, third sentence. *Taken, with the verifier's fix.*
2. **major**, verified real, major: theories/becoming/chapters/08-METHOD.md, table row "Between C and a requirement", column "Needed, by". *Taken, with the verifier's fix.*
3. **major**, verified real, major: theories/becoming/chapters/08-METHOD.md, table row "Choice over the readings". *Taken, with the verifier's fix.*
4. **minor**, verified real, minor: theories/becoming/chapters/08-METHOD.md, table row "Scope and order", column "Law up to it". *Taken, with the verifier's fix.*
5. **minor**, verified real, minor: theories/becoming/chapters/08-METHOD.md, table row "Requirement, executable", column "Needed, by". *Taken, with the verifier's fix.*
6. **minor**, verified real, minor: theories/becoming/chapters/08-METHOD.md, table row "Requirement, acceptable", column "Needed, by". *Taken, with the verifier's fix.*
7. **minor**, verified real, minor: theories/becoming/chapters/08-METHOD.md, table row "Sameness", column "Needed, by". *Taken, with the verifier's fix.*
8. **minor**, verified real, minor: theories/becoming/chapters/07-SIGNIFICANCE.md §5, first paragraph, new sentence. *Taken, with the verifier's fix.*
9. **minor**, verified real, minor: theories/becoming/chapters/03-KNOWING.md, Theorem label after <a id="r-a-response-common-over-a-reading">. *Taken, with the verifier's fix.*
10. **minor**, verified real, minor: 03-KNOWING.md §12 body; Becoming.lean GuardHorizon bullet; lean/becoming/README.md GuardHorizon row; reland_sj2.py law 7 (en and zh); study_sj2.txt Delta. *Taken, with the verifier's fix.*
11. **minor**, verified real, minor: reland_sj2.py: the GuardHorizon record's history line and the new dependency detail (en and zh). *Taken, with the verifier's fix.*
12. **minor**, verified real, minor: theories/becoming/chapters/08-METHOD.md, block intro. *Taken, with the verifier's fix.*
13. **missed**, added by the verifier: 08 table row "Requirement, executable", law cell. *Taken.*
14. **missed**, added by the verifier: reland_sj2.py, the related entry added to when-to-inquire-and-when-to-respond.json. *Taken.*
15. **missed**, added by the verifier: study_sj2.txt, Result(s). *Taken.*
16. **missed**, added by the verifier: study_sj2.txt, Delta for ungiven_reading_not_uniform. *Taken.*

The witness `ungiven_reading_not_uniform` (finding 10) works because there is no act as well as no situation; every text now says so, and the study notes that with some act the hypothesis might be weakened to the acts' being inhabited, not proved here.

## Findings as returned

#### 1. [major] theories/becoming/chapters/08-METHOD.md, block <a id="what-a-response-takes-in">, third sentence

- *Quote:* A response made from a reading meets a requirement exactly where the acts' kernels cover the situations, the law of a common response
- *Issue:* Says more than the cited law. «共应当且仅当所闭之承遍» is about a response common over a reading: a closed relation from situations to acts whose regions may overlap. It is not a response made from the reading, which is a rule. A rule from readings (UniformPolicy) exists exactly there only when choice over the readings is given and every reading is given by some situation (uniform_policy_iff_common). The sentence drops both hypotheses, and the table's own Choice row then lists them as inputs.
- *Evidence:* CommonResponse.lean: `theorem «共应当且仅当所闭之承遍» (E : «际» α) (G : A → α → Prop) : (∃ J, «共应» E G J) ↔ ∀ s, ∃ a, «承» («逆» («所闭» E)) (G a) s`. The module docstring says: "The regions of a common response may overlap, so it is a closed admissible relation from situations to acts, not a rule; one act fixed for each class is a rule, which needs choice." GuardHorizon.lean:351 `uniform_policy_iff_common {O} (choice : Viability.ChoiceOver O A) (obs) (given : ∀ o, ∃ s, obs s = o) ...`
- *Fix:* A response common over a reading exists within a requirement exactly where the acts' kernels cover the situations, the law of a common response (03 §12); a rule made from the reading needs, besides, choice over the readings and every reading given (the Choice row).
- *Verifier:* real (major). The quoted sentence is in 08 at c69077266. «共应当且仅当所闭之承遍» is about a common response: a relation from situations to acts whose regions may overlap, not a rule. CommonResponse's docstring says one act fixed for each class "is a rule, which needs choice". A response "made from" a reading is a rule, and a rule exists there only under uniform_policy_iff_common's two hypotheses. The sentence leaves both out, though its own Choice row lists them.
- *Verifier's fix:* Replace with: "A response common over a reading exists within a requirement exactly where the acts' kernels cover the situations, the law of a common response (`[03 §12](03-KNOWING.md#r-a-response-common-over-a-reading)`); a rule made from the reading needs, besides, choice over the readings and every reading given by some situation (the Choice row)."

#### 2. [major] theories/becoming/chapters/08-METHOD.md, table row "Between C and a requirement", column "Needed, by"

- *Quote:* J1 does not follow from C (`ScoreRepresentation.comparison_does_not_yield_priority`)
- *Issue:* Wrong commitment named. The theorem shows that the priority of basic conditions does not follow from C. In 07 that priority is J2. J1 is "complete comparison with retained losses".
- *Evidence:* 07 Bases: "J1–J4, complete comparison with retained losses, priority of basic conditions, bounded responsibility, legitimate feasible choice". 07 line 509 cites the theorem for "the priority does not follow from C". ScoreRepresentation.lean:139 docstring: "C does not yield the priority: a scalar order satisfying C ranks gains above protection, where the lexical order does not." history/G0-WARRANT.zh.md: "因此 J2 不由 C 推出".
- *Fix:* J2, the priority of basic conditions, does not follow from C (`ScoreRepresentation.comparison_does_not_yield_priority`)
- *Verifier:* real (major). 07 Bases defines J1 as "complete comparison with retained losses" and J2 as "priority of basic conditions". ScoreRepresentation.comparison_does_not_yield_priority shows that a scalar order satisfying C ranks gains above protection. 07 line 509 cites it for "the priority does not follow from C". So the cell names the wrong commitment, and the Lean says nothing about J1.
- *Verifier's fix:* "J2, the priority of basic conditions, does not follow from C (`ScoreRepresentation.comparison_does_not_yield_priority`)"

#### 3. [major] theories/becoming/chapters/08-METHOD.md, table row "Choice over the readings"

- *Quote:* `GuardHorizon.uniform_policy_iff_common` (any type; ring module), free for listed readings (`Viability.choiceOver_fin`) | `Viability.plans_iff_choice`; a reading no situation gives (`GuardHorizon.ungiven_reading_not_uniform`)
- *Issue:* Three problems with this row. (1) The law cell drops the law's second hypothesis, that every reading is given by some situation. (2) ungiven_reading_not_uniform is listed as a witness that choice is needed, but choice holds in it (its first conjunct proves ChoiceOver Unit Empty). It shows that the givenness hypothesis does work, not choice. (3) plans_iff_choice shows choice is needed for plans, which 03 §12 and the record's does_not_show say explicitly: "not for this rule". The cell gives no such qualifier.
- *Evidence:* GuardHorizon.lean:351-353 has the hypothesis `(given : ∀ o, ∃ s, obs s = o)`. Lines 369-373: `ungiven_reading_not_uniform : Viability.ChoiceOver Unit Empty ∧ ¬ (∀ o : Unit, ∃ s : Empty, ...) ∧ ...`. 03 §12: "That such choice cannot be dropped is shown for plans (§9), not for this rule."
- *Fix:* Law cell: `GuardHorizon.uniform_policy_iff_common` (any type; ring module), with every reading given by some situation, choice free for listed readings (`Viability.choiceOver_fin`). Needed cell: for plans, not yet for this rule (`Viability.plans_iff_choice`); the reading's being given does work, with choice holding (`GuardHorizon.ungiven_reading_not_uniform`, no situation and no act).
- *Verifier:* real (major). All three points hold. (1) The law cell leaves out `given : ∀ o, ∃ s, obs s = o`. (2) ungiven_reading_not_uniform proves ChoiceOver Unit Empty as its first conjunct. So it shows that the givenness hypothesis does work, not that choice is needed. (3) Viability.plans_iff_choice concerns plans, and 03 §12 and the record's does_not_show both say "not for this rule". The table cell carries no such qualifier.
- *Verifier's fix:* Law cell: "`GuardHorizon.uniform_policy_iff_common` (any type; ring module), given every reading by some situation; choice free for listed readings (`Viability.choiceOver_fin`)". Needed cell: "for plans, not yet for this rule (`Viability.plans_iff_choice`); the readings' being given does work, choice holding (`GuardHorizon.ungiven_reading_not_uniform`, with no situation and no act)"

#### 4. [minor] theories/becoming/chapters/08-METHOD.md, table row "Scope and order", column "Law up to it"

- *Quote:* self-concern ranks extensions as C asks, one way only (`Web.extension_ranked_of_increasingInOwn`, a named model)
- *Issue:* Wrong base. The theorem is stated for every web `W : Web F C`, with any relation, center, marking, listing and order. It is a World-family law, not a result on a named model. 08 §7's edge text cites it with no model label.
- *Evidence:* PremiseWitnesses.lean, section Paths: `variable {F C : Type} {W : Web F C}`. `theorem Web.extension_ranked_of_increasingInOwn {Pos : Type} {rel : F → F → Prop} {center : Pos → F} (unrestricted : ...) ... (extension : Extension W.paths (fun _ => True) l' l) : O (admitted l') (admitted l)`, which is general in W.
- *Fix:* self-concern ranks every extension between two level paths whose admissions are listed, as C asks, one way only (`Web.extension_ranked_of_increasingInOwn`, World)
- *Verifier:* real (minor). In PremiseWitnesses.lean the theorem sits in `section Paths` with `variable {F C : Type} {W : Web F C}`, so it holds for every web. That makes it a World-family law, not a named model. 08 §7's edge text cites it with no model label.
- *Verifier's fix:* "self-concern ranks every extension between two level paths whose admissions are listed, as C asks, one way only (`Web.extension_ranked_of_increasingInOwn`, World)"

#### 5. [minor] theories/becoming/chapters/08-METHOD.md, table row "Requirement, executable", column "Needed, by"

- *Quote:* executability opens a correction the reading leaves unchanged, and with none nothing is correctable (`OpenedCorrection.Linked.opens_by_support`, `starved_uncorrectable`, a named model)
- *Issue:* "with none" reads as "with no executability", and "nothing is correctable" reads as every configuration. The theorem says only that the linked configuration with zero stock, where the correction cannot be executed, is not correctable. Replenishing is still executable there, and opens_by_support uses exactly that. The short name also drops the `OpenedCorrection.Linked.` prefix that the first name carries.
- *Evidence:* OpenedCorrection.lean: `theorem starved_uncorrectable (v : Bool) : ¬ Correctable read acceptable executable (0, true, v)`. 03 §8 states it as "with it on and no stock none is".
- *Fix:* executability opens a correction the reading leaves unchanged, and with the link on and no stock no configuration is correctable (`OpenedCorrection.Linked.opens_by_support`, `OpenedCorrection.Linked.starved_uncorrectable`, a named model)
- *Verifier:* real (minor). starved_uncorrectable states only `¬ Correctable … (0, true, v)`: the link on and no stock. "With none nothing is correctable" reads as a claim about every configuration lacking executability. Replenishing stays executable there. The bare name `starved_uncorrectable` also does not resolve without its namespace.
- *Verifier's fix:* "executability opens a correction the reading leaves unchanged, and with the link on and no stock no configuration is correctable (`OpenedCorrection.Linked.opens_by_support`, `OpenedCorrection.Linked.starved_uncorrectable`, a named model)"

#### 6. [minor] theories/becoming/chapters/08-METHOD.md, table row "Requirement, acceptable", column "Needed, by"

- *Quote:* with every act acceptable, correctability is trivial (`OpenedCorrection.widened_correctable`)
- *Issue:* Overstates the theorem. With every act acceptable, a configuration is correctable only if it has an executable act. That is the theorem's hypothesis `can`, and "trivial" drops it.
- *Evidence:* OpenedCorrection.lean: `theorem widened_correctable (reading) (executable) {x : X} {a : A} (can : executable x a) : Correctable reading (fun _ _ => True) executable x`. 03 §8: "with every act counted acceptable, a configuration with an executable act is correctable already".
- *Fix:* with every act counted acceptable, a configuration with an executable act is correctable already (`OpenedCorrection.widened_correctable`)
- *Verifier:* real (minor). widened_correctable has the hypothesis `(can : executable x a)`. Calling correctability "trivial" drops that hypothesis. The module docstring and 03 §8 both say "a configuration with an executable act is correctable already".
- *Verifier's fix:* "with every act counted acceptable, a configuration with an executable act is correctable already (`OpenedCorrection.widened_correctable`)"

#### 7. [minor] theories/becoming/chapters/08-METHOD.md, table row "Sameness", column "Needed, by"

- *Quote:* noise forgotten keeps a process determined only where it makes no difference (`forget_inputs_determined_iff`, any type)
- *Issue:* Overgeneralizes. The theorem is about the standard causal model `inputs F` (x′ = F(x, u, ε)) with its noise forgotten, not any process. It is also an iff, so "exactly where" is the accurate word.
- *Evidence:* Mechanism.lean:356: `theorem forget_inputs_determined_iff {F : X → U → E → X} : Determined (forget (inputs F)) ↔ ∀ x u e e', F x u e = F x u e'`, docstring "With the noise forgotten, the standard model stays determined exactly where the noise makes no difference."
- *Fix:* with the noise forgotten, the standard causal model stays determined exactly where the noise makes no difference (`forget_inputs_determined_iff`, any type)
- *Verifier:* real (minor). forget_inputs_determined_iff is stated for the standard model `inputs F` with F : X → U → E → X, not for any process. It is also an iff, so "only where" understates it as one direction.
- *Verifier's fix:* "with the noise forgotten, the standard model x′ = F(x, u, ε) stays determined exactly where the noise makes no difference (`forget_inputs_determined_iff`, any type)"

#### 8. [minor] theories/becoming/chapters/07-SIGNIFICANCE.md §5, first paragraph, new sentence

- *Quote:* Where a requirement is filled from these choices, with the condition for scope and C for order, and fixed before the outcome, a response common over a reading exists within it exactly where the acts' kernels cover the situations
- *Issue:* Two problems. (1) "choices" changes sense within one paragraph. The sentence before says "choices take more", meaning acts of choosing. Here "these choices" must mean the reading of living, L and J1–J4, which are commitments. The same landing also uses "choice over the readings" in a third sense. (2) The "Where ..." clause makes the law read as if it depended on the two premises and those commitments. The law holds for every supplied requirement, whatever its source. It does not rest on the ethics' premises, and the sentence should not suggest that it does or that they settle the requirement.
- *Evidence:* «共应当且仅当所闭之承遍» is quantified over every `G : A → α → Prop` with no hypothesis. The previous sentence: "choices take more, following from neither the condition nor C: a reading of `living` ..., the lifting L and the commitments J1–J4." AGENTS.md: use each term in one sense.
- *Fix:* The law of a common response holds for every requirement supplied and fixed before the outcome, so also for one filled from these (a reading of living, L and J1–J4), with the condition for scope and C for order: a response common over a reading exists within it exactly where the acts' kernels cover the situations (`[03 §12](03-KNOWING.md#r-a-response-common-over-a-reading)`); that law says nothing of which requirement is better.
- *Verifier:* real (minor). "choices take more" (acts of choosing) and "filled from these choices" (meaning the reading of living, L and J1–J4) use "choices" in two senses within one paragraph. The "Where …" clause also makes a law that has no hypothesis on G read as conditional on the premises.
- *Verifier's fix:* "The law of a common response holds for every requirement supplied and fixed before the outcome, so also for one filled from these (a reading of `living`, L and J1–J4), with the condition for scope and C for order: a response common over a reading exists within it exactly where the acts' kernels cover the situations (`[03 §12](03-KNOWING.md#r-a-response-common-over-a-reading)`); that law says nothing of which requirement is better."

#### 9. [minor] theories/becoming/chapters/03-KNOWING.md, Theorem label after <a id="r-a-response-common-over-a-reading">

- *Quote:* the rule's converse at any type, in a ring module, given choice over the readings
- *Issue:* The label names one of the converse's two hypotheses and leaves out the other, that every reading is given by some situation. The label is where a reader looks for a law's hypotheses (08 §2: labels name each law's hypotheses). The body states the hypothesis, but the label reads as complete.
- *Evidence:* GuardHorizon.lean:351-352 has both `(choice : Viability.ChoiceOver O A)` and `(given : ∀ o, ∃ s, obs s = o)`, and the second does work by `ungiven_reading_not_uniform`.
- *Fix:* the rule's converse at any type, in a ring module, given choice over the readings and every reading given by some situation
- *Verifier:* real (minor). The label names choice but not `given`, and `given` does work: ungiven_reading_not_uniform shows it. The body does state it, but the label reads as the full list of hypotheses.
- *Verifier's fix:* "the rule's converse at any type, in a ring module, given choice over the readings and every reading given by some situation"

#### 10. [minor] 03-KNOWING.md §12 body; Becoming.lean GuardHorizon bullet; lean/becoming/README.md GuardHorizon row; reland_sj2.py law 7 (en and zh); study_sj2.txt Delta

- *Quote:* a reading no situation gives can leave a common response with no rule (`GuardHorizon.ungiven_reading_not_uniform`)
- *Issue:* The witness works only because there is no act at all (A = Empty) as well as no situation. If any act exists, a common response at an ungiven reading leaves an arbitrary act free there, and classically a rule follows. The texts present the ungiven reading alone as what breaks the rule. The theorem's own docstring says "with no configuration and no move". The record's law 7 says the same in both languages ("with that choice and a reading no situation gives, a common response can exist with no such rule" / "有此选择而有一读数无情境给出时，共应可存在而无此规则").
- *Evidence:* GuardHorizon.lean:369-378: `ungiven_reading_not_uniform : Viability.ChoiceOver Unit Empty ∧ ... ¬ UniformPolicy (A := Empty) (fun _ : Empty => ()) ...`, with proof `fun ⟨policy, _⟩ => nomatch policy ()`. The failure comes from having no act.
- *Fix:* 03 §12: "a reading no situation gives, with no act at all, can leave a common response with no rule (`GuardHorizon.ungiven_reading_not_uniform`)". In the same way: README/Becoming.lean "... with no move at all ..."; law 7 en "... with that choice, no situation and no act, a common response exists with no such rule"; law 7 zh "有此选择而无情境亦无行时，共应存在而无此规则".
- *Verifier:* real (minor). The witness takes A = Empty, and its proof `nomatch policy ()` fails only because there is no act. With any act and classical case analysis on whether a reading is given, a rule follows. "Can" is literally true, but the texts credit the failure to the ungiven reading alone. The theorem's own docstring says "with no configuration and no move".
- *Verifier's fix:* 03 §12: "a reading no situation gives, with no act at all, can leave a common response with no rule (`GuardHorizon.ungiven_reading_not_uniform`)"; Becoming.lean and README: "a reading no configuration gives, with no move at all, can leave a common response with no choice from readings"; law 7 en: "…; with that choice, no situation and no act, a common response exists with no such rule." zh: "……；有此选择而无情境亦无行时，共应存在而无此规则。"

#### 11. [minor] reland_sj2.py: the GuardHorizon record's history line and the new dependency detail (en and zh)

- *Quote:* GuardHorizon gains uniform_policy_iff_common, law 1's equivalence with the condition read as a response common over the reading's sameness
- *Issue:* The history line and the dependency detail ("uniform_policy_iff_common is its uniform_policy_iff_fiber_feasible with the condition rearranged into this record's covering law") present the new theorem as law 1 with its condition rearranged. The rearrangement FiberFeasible ↔ common response is valid only given every reading by some configuration, a hypothesis law 1 does not have. The Chinese texts omit it in the same way.
- *Evidence:* GuardHorizon.lean:354-360: the `fibers` step's reverse direction uses `match given o with`. when-to-inquire record law 1 has only choice.
- *Fix:* en: "GuardHorizon gains uniform_policy_iff_common: with every reading given by some configuration, law 1's equivalence with the condition read as a response common over the reading's sameness, ..."; zh: "GuardHorizon 新增 uniform_policy_iff_common：每一读数皆由某一配置给出时，即第 1 律之等价，其条件读作对读之同的共应，……". Dependency detail: "... with the condition rearranged, every reading given, into this record's covering law ..." / "……每一读数皆被给出时条件改写为本记录之遍盖律……".
- *Verifier:* real (minor). The `fibers` step's reverse direction uses `match given o`. So the rearrangement FiberFeasible ↔ covering holds only with every reading given. Law 1 of when-to-inquire assumes only choice. Both the history line and the dependency detail present the new theorem as law 1 rearranged and omit the hypothesis, in English and in Chinese.
- *Verifier's fix:* History en: "GuardHorizon gains uniform_policy_iff_common: with every reading given by some configuration, law 1's equivalence with the condition read as a response common over the reading's sameness, recorded as …"; zh: "GuardHorizon 新增 uniform_policy_iff_common：每一读数皆由某一配置给出时，即第 1 律之等价，其条件读作对读之同的共应，记为……". Dependency en: "… is its uniform_policy_iff_fiber_feasible with, every reading given, the condition rearranged into this record's covering law …"; zh: "……即其 uniform_policy_iff_fiber_feasible，每一读数皆被给出时条件改写为本记录之遍盖律……"

#### 12. [minor] theories/becoming/chapters/08-METHOD.md, block intro

- *Quote:* Each row names an input, the law up to it with its base (root, any type, or a ring module), at most two witnesses that the input is needed, and its home. No row's standing is a premise.
- *Issue:* (1) "ring module" is given as a base, but the glossary's base list (08 §2 Words in one sense) is root, the steps, any process, any type, World, periphery, a named model. The ring is where a module sits, not a base, and the rows themselves write "any type; ring module". Some witness cells also use World and "a named model". (2) "No row's standing is a premise" can be read as "no input is a premise", which contradicts the rows "Between C and a requirement (... each a premise where used)" and "Scope and order (... supplied by the two premises)". The standings in question are the edge record's, in the last column.
- *Evidence:* 08 line 115: `| base | the base of a label (root, the steps, any process, any type, World, periphery, a named model) |`. 08 line 160 calls the ring "the instance and application ring" and says it lies outside the core by direction.
- *Fix:* Each row names an input, the law up to it with its base (root or any type, and "ring module" where it lies in the instance and application ring), at most two witnesses that the input is needed, each with its base, and its home. No standing in the last column is a premise.
- *Verifier:* real (minor). 08 §2 lists the bases as root, the steps, any process, any type, World, periphery and a named model. "Ring module" names where a module sits, not a base, and the rows themselves write "any type; ring module". The witness cells also use World and "a named model", which the intro does not list. "No row's standing is a premise" clashes with rows whose inputs are premises where used ("each a premise where used").
- *Verifier's fix:* "Each row names an input, the law up to it with its base (root or any type, and \"ring module\" where it lies in the instance and application ring), at most two witnesses that the input is needed, each with its base, and its home. No standing in the last column is a premise."

#### Misses the verifier added

- 08 table row "Requirement, executable", law cell: "`OpenedCorrection.correctable_iff` (any type; ring module)" leaves out the theorem's hypothesis `(choice : Viability.ChoiceOver O A)`. Fix: "`OpenedCorrection.correctable_iff` (any type; ring module), given choice over the readings".
- reland_sj2.py, the related entry added to when-to-inquire-and-when-to-respond.json: "Its seventh law reads law 1's equivalence with the condition as a response common over the reading's sameness." / "其第七律把第 1 律之等价的条件读作对读之同的共应。" Both leave out givenness, as in finding 10. Fix: "Its seventh law reads law 1's equivalence, with every reading given by some configuration, with the condition as a response common over the reading's sameness." / "其第七律在每一读数皆由某一配置给出时，把第 1 律之等价的条件读作对读之同的共应。"
- study_sj2.txt, Result(s): "a seventh law, the rule's converse with choice, at any type in a ring module" leaves out the second hypothesis. Fix: "a seventh law, the rule's converse with choice over the readings and every reading given, at any type in a ring module".
- study_sj2.txt, Delta for ungiven_reading_not_uniform: "with that choice and a reading no configuration gives, a common response exists with no choice from readings" also leaves out that the witness has no move (A = Empty). Fix: "with that choice, no configuration and no move, the one reading given by none, a common response exists with no choice from readings, so the second hypothesis cannot simply be dropped".
