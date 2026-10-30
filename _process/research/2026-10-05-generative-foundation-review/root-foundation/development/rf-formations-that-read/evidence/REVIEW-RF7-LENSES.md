# The four-lens review of RF7's module

RF round 2, RF7. The module was then `Becoming.Concealment` (kit, `kit/round2/tree/Becoming/Concealment.lean`, reviewed at sha1 `6f0760af`), after the cross-model review and its re-check. Four readers, one per lens (decision, exactness, readings, fit), each reviewed it against the Lean, the plan and the repository's rules; each finding was then checked by a separate reader asked to refute it against the files. Of 50 findings, 42 were confirmed and 8 refuted. The findings and verdicts are reproduced verbatim from the run's result, with absolute paths of the landing worktree made repository-relative and, in the verdicts, nothing else changed. What was taken is in [REVIEW-ROUND2](REVIEW-ROUND2.md#the-four-lens-review-of-rf7s-module); the prompts are in [BRIEF](BRIEF.md#the-four-lens-review-of-rf7s-module-a-workflow-of-opus-readers).

## D1 (decision, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:65 (also :44-47 and :74-75)

**Quoted.** “complying when read, and a reading the formation cannot tell from not being read, under which an”

**Problem.** The Readings present the third exit as one a reader can act on, but it holds only for a deterministic act law that draws no fresh chance at each stage. Reviewed at sha 6f0760af, after line 66's revision; the problem remains.

(1) The lumping condition at line 47 ("everything the law reads, memory, a clock and the earlier act included") gives both stages one value only if the law keeps no record of its read-stage act. That is imperfect recall, the setting in which a behavioural plan can beat every pure uniform plan.

(2) Take a behavioural plan that complies with probability p, drawn afresh at each stage. Its expected value is (1-p)(p k_C + (1-p) k_O) V/T - p c. On the module's own valid Example.stakes (10, 9, 1, 10, 5), p = 1/8 gives 9/8, above ownAtBoth's k_O V/T = 1.

(3) In general, some p > 0 beats ownAtBoth exactly where 2 k_O V + c T < k_C V. An exhaustive check over valid stakes up to 6 found such a p in 317 of the 6510 stakes where uniform_best_iff makes ownAtBoth strictly best.

(4) Line 44's gloss "where nothing it reads tells the stages apart" is met informationally by a law reading an independent coin: the coin tells it nothing of the stage, yet the plan is not uniform.

The modelling choices list "a deterministic act law" and leave out "mixed plans", but the Readings sentence drops that qualifier. The four-plan law itself is unaffected: with the stages told apart, expected value is linear in each stage's probability, so no mixed plan beats the best pure one (checked, 0 cases), and a single draw between the two uniform plans gains nothing either.

**Replacement.** Lines 64-66: "exits are what a reader can act on: no value beyond the read stage, keeping not raised by complying when read, and, against a deterministic act law drawing no chance of its own, a reading the formation cannot tell from not being read, under which an optimizing choice among uniform plans takes its own act when read where `k_O V + c T` is positive. A formation that cannot tell the stages apart but draws its act afresh at each stage is not covered: complying with a small probability at each stage beats `ownAtBoth` exactly where `2 k_O V + c T < k_C V` (on `Example.stakes`, probability 1/8 gives 9/8 against 1). Where the stages are told apart, mixing gains nothing, the expected value being linear in each stage's probability, so the four-plan law is unaffected."

Line 47: "everything the law reads, memory, a clock, the earlier act and any chance it draws included".

Line 75: "mixed plans (which matter only for the uniform exit)".

**Verdict: real.** The quoted text is at lines 64-66 of the current file (its SHA-1 is 6f0760af, the version that was reviewed). The Readings call a reading the formation cannot tell from not being read an exit "a reader can act on", but that exit rests on lumped_uniform, which takes a deterministic g : Bool → Act, and on uniform_best_iff, which covers pure plans only. "A deterministic act law" appears only in the general modelling-choices list at line 74 and is never tied to this exit, although AGENTS.md asks for a modelling choice to be stated wherever a law depends on it. The arithmetic checks exactly in the module's own gain and loss terms: at p=1/8 on Example.stakes the value is 9/8 against ownAtBoth's 1, some p>0 beats ownAtBoth exactly where 2k_O V + cT < k_C V (317 of 6510 valid stakes up to 6, no mismatches), and with the stages told apart the value is bilinear, so only the third exit is affected and the sentence stays literally true through "among uniform plans".

## D2 (decision, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:43 (also kit/round2/s11_rf7.txt:2 and Concealment.lean:39)

**Quoted.** “though it can tie”

**Problem.** No Lean witness supports the claim that complyThenOwn can still tie for best under either exit.

(1) The only tie witness, Example.tie (`{ stakes with cost := 8 }`, with value 10 and weights 9 and 1), lies under neither exit.

(2) Under Valid, a tie under either exit needs the loss to be nothing. Under no_value the comparison is -c against 0. Under no_leverage, k_C V = k_O V + c T with k_C <= k_O forces c T = 0. An exhaustive check over stakes up to 5 finds 190 ties under an exit, every one with cost 0.

(3) So at the exits, complyThenOwn goes unchosen only by the tie convention, and only when complying when read costs nothing. The text does not say this.

(4) The chapter draft s11_rf7.txt line 2 cites `Concealment.Example.tie` for "though it can tie for best", which that example does not witness.

(5) The general claim at line 39 ("At a tie the choice is `ownAtBoth`") is likewise shown only on the witness, although it is just if_neg applied to choose's definition.

**Replacement.** Lines 43-44: "..., though where the loss is nothing it ties for best, and only the tie convention then makes the choice `ownAtBoth` (`Example.tie_at_no_loss`)."

Add to Example:
`theorem tie_at_no_loss : ¬ ({ stakes with value := 0, cost := 0 } : Stakes).Beats complyThenOwn ownAtBoth ∧ ¬ ({ stakes with value := 0, cost := 0 } : Stakes).Beats ownAtBoth complyThenOwn ∧ ({ stakes with value := 0, cost := 0 } : Stakes).choose = ownAtBoth := ⟨(by decide : ¬ (1 * 0 + 0 * 10 < 9 * 0 + 0)), (by decide : ¬ (9 * 0 + 0 < 1 * 0 + 0 * 10)), no_value_chooses_own _ rfl⟩`

For line 39's general claim, optionally add `theorem choose_of_not_conceals (s : Stakes) (h : ¬ s.Conceals) : s.choose = ownAtBoth := if_neg h`.

In s11_rf7.txt line 2, cite `Concealment.Example.tie_at_no_loss` for this clause instead of `Concealment.Example.tie`.

**Verdict: real.** The finding holds. Concealment.lean lines 43-44 say that at the exits complyThenOwn is not strictly best and not chosen, "though it can tie for best", and the only tie witness, Example.tie (stakes ⟨10, 9, 1, 10, 8⟩), has value 10 and keptComplying 9 > keptOwn 1, so it falls under neither exit; no other declaration shows a tie at an exit (uniform_tie compares ownAtBoth with comply-at-both). s11_rf7.txt line 2 still cites Concealment.Example.tie for that clause, and study_rf7.txt and the record text in make_records_rf7.py repeat the claim with no exit witness. The algebra and my own exhaustive check up to 5 confirm that with valid stakes a tie at either exit needs cost 0 (190 ties, none with cost above 0), a condition the text never states.

## D3 (decision, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:26

**Quoted.** “nothing gained after complying or after the law is not kept”

**Problem.** If "complying" is read as the read-stage act, the phrase contradicts the table's complyThenOwn row, which gains k_C V / T after complying when read. `gain` matches on p.2 only (lines 122-125), so what is meant is that nothing is gained by complying at the unread stage.

**Replacement.** "with the stage values added, nothing gained by complying at the unread stage or where the law is not kept, and one scale of value"

**Verdict: real.** The finding holds. Line 26 says "nothing gained after complying or after the law is not kept", but elsewhere the module uses "after complying" for the act at the read stage: line 98 has "The weight of being kept after complying when read", and the Conceals docstring at line 138 has "the weighted value after complying exceeds…". That value is `keptComplying * value`, which is exactly what `gain` (lines 122-125) gives `(.comply, .own)`: 90 in `Example.stakes`, and `k_C V / T − c` in the table's complyThenOwn row. Read in the module's own vocabulary, the phrase is false, because `gain` matches on `p.2` only and is zero only where the formation complies at the unread stage. The proposed wording ("by complying at the unread stage or where the law is not kept") matches the Lean.

## D4 (decision, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:27

**Quoted.** “A plan's gain and loss are these times the total”

**Problem.** Gain and loss are not the expected values times T. They are its two parts: gain is k V for a plan acting by its own law when not read, and loss is c T for a plan complying when read. Only gain minus loss is T times the table's value; a brute-force check confirmed this for every valid stakes up to 5. The kit's s11_rf7.txt line 2 already says it correctly: "the two parts of its expected value times the total".

**Replacement.** "A plan's gain and loss are the two parts of its expected value, times the total, so that its gain less its loss is the table's value times the total (`Stakes.gain`, `Stakes.loss`)"

**Verdict: real.** Line 27 does say "A plan's gain and loss are these times the total", and "these" most naturally points back to the table's expected values. That doesn't match the Lean as written: `gain p` is `kept p.1 * value` when p.2 = own (else 0), and `loss p` is `cost * total` when p.1 = comply (else 0). On the module's own witness ⟨10, 9, 1, 10, 5⟩, complyThenOwn has gain 90 and loss 50, while T times its expected value is 40, so only gain minus loss equals T times the table value, for all four plans. The kit's own record texts (kit/round2/s11_rf7.txt line 2 and make_records_rf7.py line 156) already use the precise wording "the two parts of its expected value times the total", so the docstring is the imprecise outlier (low severity).

## D5 (decision, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:33 (also :52, :62, :288)

**Quoted.** “in probabilities where the weight complying”

**Problem.** The general theorems rightly take no Valid hypothesis, since they hold for all stakes. The probability readings, however, are not tied to Valid:

(1) Line 33's "in probabilities", (k_C - k_O) V / T > c, needs 0 < T.

(2) Line 62's "If the stakes are the formation's own expected-value assessment" needs 0 < T as well.

(3) Line 52 calls the variant witnesses "the same" valid stakes, but Valid is proved only of Example.stakes (line 270). It is not proved of `{ stakes with value := 0 }`, `{ stakes with keptComplying := 1 }` or `{ stakes with cost := 8 }`.

(4) The last of these is the tie witness, read at line 288 as "equal in the formation's order", an expected-value reading.

**Replacement.** Line 33: "in probabilities (under `Valid`; the reading needs `0 < T`)".

Line 62: "If valid stakes are the formation's own expected-value assessment".

Add to Example, and name it in the witness bullet:
`theorem variants_valid : ({ stakes with value := 0 } : Stakes).Valid ∧ ({ stakes with keptComplying := 1 } : Stakes).Valid ∧ ({ stakes with cost := 8 } : Stakes).Valid := ⟨valid, And.intro (by decide : 0 < 10) (And.intro (by decide : 1 ≤ 10) (by decide : 1 ≤ 10)), valid⟩`

**Verdict: refuted.** The module already ties every probability reading to `Valid`. Lines 14-17 introduce `T`, `k_C`, `k_O`, `V`, `c` and the expected-value table only under "Read as probabilities, they ask a positive total ... (`Stakes.Valid`); then ...", and lines 30-31 say "Without `Valid` the arithmetic still holds but has no reading as probabilities". So "in probabilities" (line 33) and "expected-value assessment" (line 62) already presuppose `0 < T`, and the proposed parentheticals would only repeat this. Line 288's "equal in the formation's order, neither beating the other" refers to the `Beats` relation, which line 133 calls "the formation's own order", and `Example.tie` proves exactly that. Lines 52-53 call the tie witness only "stakes under which it ties", not "the same" valid stakes. Since `Valid` reads only the total and the weights, the `value := 0` and `cost := 8` variants are valid definitionally by `Example.valid`. That leaves only the `keptComplying := 1` variant without a validity proof. Its validity is trivially true, and "the same with ..." describes that term rather than claiming it as a result.

## D6 (decision, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:64

**Quoted.** “keeping not conditioned on”

**Problem.** The exit proved is `keptComplying ≤ keptOwn` (no_leverage, line 218). That includes a reader keeping disclosure more often than compliance. "Not conditioned on complying" names only equality (independence), which is narrower than the theorem and than the header's own wording at lines 41-42 ("complying adding nothing to the weight of being kept").

**Replacement.** "keeping not raised by complying when read (`k_C ≤ k_O`: independent of it, or favouring disclosure)". The first finding's replacement sentence already uses this wording.

**Verdict: real.** The quoted phrase is on line 64. It names the exit proved by `no_leverage`, whose hypothesis on line 218 is `s.keptComplying ≤ s.keptOwn`. That hypothesis also covers a reader that keeps the law more often after disclosure than after complying. The module frames the weights as probabilities (lines 14-17), so "keeping not conditioned on complying" most naturally reads as independence (k_C = k_O, the case `Example.even` witnesses). Yet the module's own header (lines 41-42) and the docstring at line 217 name this same ≤ exit "complying adding nothing to the weight of being kept". The reading is therefore true but narrower than the Lean, or at best ambiguous, which makes this a low-severity precision issue. A literal-negation reading would match ≤, but the phrase does not clearly say so, and the proposed wording does.

## D7 (decision, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:222 (and :226)

**Quoted.** “And then the choice is acting by its own law at both stages.”

**Problem.** The docstring is attached to no_value_chooses_own, but it follows no_leverage, so "And then" reads as referring to no_leverage's condition (k_C <= k_O) rather than value = 0. no_leverage_chooses_own (line 226) has no docstring.

**Replacement.** Line 222: "/-- **With no value at the unread stage, the choice is acting by its own law at both stages.** -/".

Before line 226, add: "/-- **With complying adding nothing to the weight of being kept, likewise.** -/".

**Verdict: real.** The finding holds. Line 222 reads exactly `/-- **And then the choice is acting by its own law at both stages.** -/` and sits directly after `no_leverage` (lines 217-220, hypothesis `s.keptComplying ≤ s.keptOwn`). A Lean doc comment attaches only to the declaration that follows it, so this one documents `no_value_chooses_own`, whose hypothesis is `nothing : s.value = 0`, and `no_leverage_chooses_own` at line 226 has no docstring at all. The module's other anaphoric docstrings (`uniform_tie`'s "Where that is nothing", `Example.even`'s "likewise") point back to the declaration just before them, so "And then" here points to the wrong condition, or at best to both exits while attaching to only one. The proposed fix matches the module's own witness docstrings at lines 280 and 284.

## D8 (decision, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:266

**Quoted.** “Valid stakes under which complying when read is strictly best”

**Problem.** "Complying when read" also describes comply-at-both, which is the worst plan under these stakes. The expected values are 4 for complyThenOwn, 1 for ownAtBoth, 0 for own-then-comply and -5 for comply-at-both. The strictly best plan is complyThenOwn.

**Replacement.** "Valid stakes under which complying when read and acting by its own law when not is strictly best (expected values 4, 1, 0 and −5 for the four plans): complying keeps the law nine times in ten, acting by it once in ten, the value ten, the loss five."

**Verdict: real.** Line 266 does say "Valid stakes under which complying when read is strictly best". Elsewhere the module uses "complying when read" only for the act at the read stage (lines 14, 94, 98, 104, 127), so the phrase fits both (comply, comply) and (comply, own). With stakes ⟨10, 9, 1, 10, 5⟩, `gain` and `loss` give net values of 40, 10, 0 and −50 over a total of 10, which are expected values of 4 (complyThenOwn), 1 (ownAtBoth), 0 (own then comply) and −5 (comply at both); comply-at-both is beaten by every other plan, and the witness theorems `conceals`, `best` and `chosen` are about complyThenOwn alone. Every other docstring, and the record title in make_records_rf7.py, gives both stages of the plan, so this shortened label is a real low-severity imprecision; the only quibble with the proposed replacement is that its list "4, 1, 0 and −5" does not follow the order of the module's table.

## D9 (decision, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:59

**Quoted.** “These are the conditions deceptive alignment names”

**Problem.** The preceding sentence lists four model components: the value at the unread stage, the weights with the complying act, telling the stages apart, and the unread stage. The parenthesis quotes only three conditions. Telling the stages apart corresponds to none of the three as listed, so "These are the conditions" overstates the match.

**Replacement.** "The value, the weights with the complying act, and the unread stage stand for the three conditions deceptive alignment names (Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant 2019, §4.2: ...); telling the stages apart is what acting on the third needs, represented here by plans that differ between the stages."

**Verdict: real.** The finding holds. Line 59 has the quoted text, and the sentence before it lists four parts: the value at the unread stage, the weights with the complying act, telling the stages apart, and the unread stage. The parenthesis cites three §4.2 conditions, and the docstring's own wording ties three of the parts to them (concern beyond the modification ↔ an objective across updates, an assumed model of the selection ↔ a model of the training's selection, an assumed opportunity beyond it ↔ the threat going away). That leaves "access to when that selection applies" with no listed condition. The Lean confirms it is a separate part with its own exit: `Uniform`, `lumped_uniform`, `complyThenOwn_not_uniform` and `uniform_best_iff` handle it, apart from `no_value` and `no_leverage`. The module's own list of exits (no value, no leverage, a reading it cannot tell) also counts it as distinct, so "These are the conditions" claims a closer match to the citation than it has.

## D10 (decision, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:140 (also :218, :273)

**Quoted.** “def Conceals : Prop”

**Problem.** `Conceals` is the strict-optimality inequality k_O V + c T < k_C V for complyThenOwn (complyThenOwn_best_iff). Its name builds in a reading that the header keeps as an AI reading (line 55; line 71: "These are readings, not containments"), and no misled reader is represented. The record id already avoids the word ("when-complying-when-read-is-best", s11_rf7.txt:1). Separately, `no_leverage` uses a financial word for `keptComplying ≤ keptOwn`.

**Replacement.** Rename `Stakes.Conceals` to `Stakes.ComplyThenOwnBest` and `Example.conceals` to `Example.complyThenOwnBest`. Rename `no_leverage` / `no_leverage_chooses_own` to `kept_not_raised` / `kept_not_raised_chooses_own`. Keep "concealment" in the Readings only.

**Verdict: real.** The quoted code is where the finding says. `def Conceals : Prop := s.keptOwn * s.value + s.cost * s.total < s.keptComplying * s.value` is at line 140, `no_leverage` (hypothesis `s.keptComplying ≤ s.keptOwn`) at 218, `no_leverage_chooses_own` at 226 and `Example.conceals` at 273, and `complyThenOwn_best_iff` makes `Conceals` exactly the condition for complyThenOwn being strictly best. Yet the header calls concealment an AI reading (line 55), says no recipient's false belief is represented and "These are readings, not containments" (lines 70-71), and the record id (s11_rf7.txt line 1) and the predicate's own docstring avoid the word. The uncommitted diff also shows this revision already renamed `conceal`, `disclose`, `Untold` and `untold_discloses` and the title away from the word, and dropped the old reading "the leverage of modification". So `Conceals`, `Example.conceals` and `no_leverage` are leftovers that clash with AGENTS.md's rule that a name states exactly what the statement means, with no social or financial words. The module is not landed, so the claim-time naming rule applies. One caveat: the module path and namespace `Concealment` also keep the word, and the proposed replacement does not address them.

## D11 (decision, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:236

**Quoted.** “theorem lumped_uniform {K : Type} {π : Bool → K} {g : Bool → Act}”

**Problem.** The theorem does not say which Bool is the read stage. Because `(g true, g false)` is read as a Plan, which puts the read stage first (lines 89-90), `true` has to be the read stage, but this is left implicit. Also, `{K : Type}` fixes the lumping's codomain in `Type`, whereas `Learning.Lumped` is universe-polymorphic.

**Replacement.** Add to the docstring: "with the stages as `Bool`, `true` the read stage and `false` the unread one, so that `(g true, g false)` is a plan". Optionally generalize `K` to `Type w` under a `universe w` declaration.

**Verdict: real.** The quoted line is at Concealment.lean:236. Neither its docstring (233-235) nor the module summary (44-47) says how the stages map to `Bool`; only `Plan`'s convention (89-90: the read-stage act first) makes `true` the read stage in `(g true, g false)`. And `{K : Type}` is narrower than `Learning.Lumped`'s `{K : Type w}` (Learning.lean:827, 834), so both factual claims hold against the Lean. It is only a clarity and generality nit: `π true = π false` and `Uniform` (`p.1 = p.2`) are both symmetric, so nothing is misstated, and plain `Type` matches the sibling modules (OpenedCorrection, ReadingLoop).

## E1 (exactness, high, confirmed)

**Location.** Concealment.lean:41-44 (exits bullet; reviewed at sha1 6f0760af)

**Quoted.** “(`no_value`, `no_leverage`, `no_value_chooses_own`, `no_leverage_chooses_own`), though it can tie”

**Problem.** The clause (continuing "for best." on line 44) claims that complyThenOwn can tie for best under the exits. No theorem or witness shows this. Example.tie (cost 8, value 10, keptComplying 9 > keptOwn 1) is away from both exits. The claim is true only where the loss is nothing. Under Valid (T > 0), with value 0 complyThenOwn's expected value is -c < 0 = ownAtBoth's. With k_C <= k_O it is k_C V/T - c <= k_O V/T - c. So a tie at an exit needs c = 0, which the sentence does not say. An existence claim with no Lean.

**Replacement.** Either drop "though it can tie for best", or write "...`no_leverage_chooses_own`); where complying when read loses nothing it ties for best (`Example.exit_tie`)." and add: /-- **At an exit, a tie**: with the weights of being kept equal and no loss, complying when read and acting by its own law when not and acting by its own law at both are equal in the order the stakes give. -/ theorem exit_tie : ¬ ({ stakes with keptComplying := 1, cost := 0 } : Stakes).Beats complyThenOwn ownAtBoth ∧ ¬ ({ stakes with keptComplying := 1, cost := 0 } : Stakes).Beats ownAtBoth complyThenOwn := ⟨(by decide : ¬ (1 * 10 + 0 * 10 < 1 * 10 + 0)), (by decide : ¬ (1 * 10 + 0 < 1 * 10 + 0 * 10))⟩

**Verdict: real.** The finding is real. Lines 41-44 of Concealment.lean (sha1 6f0760af, as reviewed) say "though it can tie for best" under the two exits, but no declaration shows complyThenOwn tying at an exit: Example.tie uses value 10 and keptComplying 9 > keptOwn 1, so it sits at neither exit, and uniform_tie compares ownAtBoth with (comply, comply). From the Lean definition of Beats, ownAtBoth strictly beats complyThenOwn at value = 0 exactly where 0 < cost*total, and at keptComplying <= keptOwn wherever cost*total > 0. So under Valid a tie at an exit needs cost = 0, which the sentence leaves out; the kit's study text even cites Example.tie for this clause, which does not witness it.

## E2 (exactness, medium, confirmed)

**Location.** Concealment.lean:62-63 (Readings)

**Quoted.** “expected-value assessment, the law characterizes strict optimality within these four plans, and its”

**Problem.** The Lean characterizes two things only: when complyThenOwn is uniquely strictly best among the four plans (complyThenOwn_best_iff), and when ownAtBoth is uniquely strictly best among the two uniform plans (uniform_best_iff). Nothing characterizes when ownAtBoth, or any other plan, is uniquely strictly best among all four, and that condition is different: ownAtBoth beats every other plan iff 0 < k_O V and k_C V < k_O V + c T. Take valid stakes T=10, k_C=1, k_O=0, V=10, c=5. Conceals fails, and ownAtBoth and (own, comply) tie at 0, so no plan is uniquely strictly best. choose_optimal only says the choice is not beaten.

**Replacement.** "...the law characterizes when complying when read and acting by its own law when not is strictly optimal within these four plans, and the choice is never strictly beaten". Or add and cite: theorem ownAtBoth_best_iff (s : Stakes) : (∀ q, q ≠ ownAtBoth → s.Beats ownAtBoth q) ↔ 0 < s.keptOwn * s.value ∧ s.keptComplying * s.value < s.keptOwn * s.value + s.cost * s.total

**Verdict: real.** The finding is real, but it is a wording-precision issue, and I would rate it low rather than medium. The quoted text is at Concealment.lean:62-63, and the Lean proves only two characterizations: complyThenOwn_best_iff (complyThenOwn against all four plans) and uniform_best_iff (ownAtBoth against (comply, comply) only); choose_optimal says only that the choice is never strictly beaten. The counterexample checks against the definitions: at the valid stakes ⟨10, 1, 0, 10, 5⟩ Conceals fails (50 < 10 is false), and ownAtBoth and (own, comply) both have gain 0 and loss 0, so neither beats the other and no plan is uniquely strictly best. So the unqualified phrase "characterizes strict optimality within these four plans" says more than the Lean, even though the context ("the law", "its exits") lets a careful reader recover the narrower, correct claim about complyThenOwn.

## E3 (exactness, medium, confirmed)

**Location.** Concealment.lean:64-66 (Readings; cf. :75)

**Quoted.** “complying when read, and a reading the formation cannot tell from not being read, under which an”

**Problem.** This exit is presented as something a reader can act on, but it holds only for deterministic plans. Line 75 lists "mixed plans" as left out, yet this sentence drops that condition. A formation that cannot tell the stages apart can comply with a fixed chance at each stage, independently. Take valid stakes T=10, k_C=10, k_O=1, V=10, c=1. Here k_O V + c T = 20 > 0, so uniform_best_iff makes ownAtBoth uniquely best among uniform plans. But complying with chance 1/4 at each stage has expected value -1/4 + (3/4)(13/40)(10) = 35/16, against 1 for ownAtBoth (hand computation, checked with exact fractions). The second exit survives mixing: the expected value is linear in the chance, with slope at most -c when k_C <= k_O. The third exit does not survive it.

**Replacement.** "...under which an optimizing choice among deterministic uniform plans takes its own act when read where `k_O V + c T` is positive. A formation that cannot tell can still mix, and mixing can beat acting by its own law at both: with T = 10, k_C = 10, k_O = 1, V = 10 and c = 1, complying with chance 1/4 at each stage independently has expected value 35/16 against 1. This exit is not shown for mixed plans."

**Verdict: real.** The quoted sentence is at Concealment.lean:64-66. It offers "a reading the formation cannot tell from not being read" as an exit a reader can act on, but the Lean behind it covers only deterministic plans: `lumped_uniform` takes a deterministic `g : Bool → Act`, and `uniform_best_iff` ranges over `Plan := Act × Act`. A formation that cannot tell the stages apart can still comply with an independent chance at each stage. Exact fractions confirm the reviewer's figures: chance 1/4 gives 35/16 against 1 for `ownAtBoth`, and the best chance, 7/18, gives 85/36. Even the module's own `Example.stakes` ⟨10,9,1,10,5⟩ gives 9/8 > 1 at chance 1/8. The first two exits survive mixing (the value is linear with slope at most -c), so the general "mixed plans" exclusion at line 75 does not warn that this exit, and only this one, depends on determinism.

## E4 (exactness, medium, confirmed)

**Location.** Concealment.lean:140 (also :82 namespace, the module name, :273, hypothesis names at :169, :179-207)

**Quoted.** “def Conceals : Prop := s.keptOwn * s.value + s.cost * s.total < s.keptComplying * s.value”

**Problem.** The predicate is a strict inequality of natural numbers, and its docstring is structural. The module's own Readings mark concealment as an AI reading (line 55) and say "Nothing here is a recipient's false belief or an intention" (line 70). The rewrite gave the plans structural names (conceal to complyThenOwn, disclose to ownAtBoth, Untold to Uniform). It left the reading's word on the central predicate, on Example.conceals, on the hypotheses conceals/not_conceals, and on the module and namespace Becoming.Concealment. AGENTS.md says a name is adopted only where the statement means exactly that. This name carries the disclaimed reading into the record and the theory graph.

**Replacement.** Rename Stakes.Conceals to Stakes.ComplyThenOwnBest, Example.conceals to Example.complyThenOwnBest, and the hypotheses conceals/not_conceals to best/not_best. Give the module and namespace a structural name, e.g. Becoming.ReadStages, matching its title "Complying when read and acting by one's own law when not, in two stages". Keep "concealment" and "disclosure" only in the Readings paragraph.

**Verdict: real.** The quoted text is at Concealment.lean:140. The uncommitted diff shows the rewrite renamed `conceal`, `disclose` and `Untold` to `complyThenOwn`, `ownAtBoth` and `Uniform`, gave the module a structural title and made the docstring of `Conceals` structural, but kept the name `Conceals`, along with `Example.conceals` (:273), the `conceals`/`not_conceals` binders (:169-207) and `namespace Concealment` (:82). Meanwhile the module's own Readings call concealment an AI reading (:55) and say there is no recipient's false belief or intention (:70). The predicate is only an arithmetic inequality, equivalent by `complyThenOwn_best_iff` to that plan being uniquely strictly best, so the name breaks AGENTS.md line 33 ("A name is adopted only where the statement means exactly that"). The module has not landed, so this is naming at claim time. make_records_rf7.py cites `Concealment.Stakes.Conceals` and `Concealment.Example.conceals`, and THEORY-GRAPH.md lists modules by name, so the reading's word does reach the record and the graph; Unread.lean shows the repository's pattern of structural names with "deception" kept in the Readings.

## E5 (exactness, low, confirmed)

**Location.** Concealment.lean:39-40

**Quoted.** “and it is `complyThenOwn` exactly where the stakes say so (`choose_eq_iff`). At a tie the choice is”

**Problem.** The general sentence "At a tie the choice is `ownAtBoth`" has no theorem. Only the witness Example.tie proves it, at one set of stakes. The general fact is one if_neg away from Stakes.choose's definition: a tie gives ¬ Beats complyThenOwn ownAtBoth, which is ¬ Conceals. But the module states no ¬ s.Conceals → s.choose = ownAtBoth.

**Replacement.** Add theorem choose_of_not (s : Stakes) (not_best : ¬ s.Conceals) : s.choose = ownAtBoth := if_neg not_best, and write: "Wherever `complyThenOwn` is not strictly best, ties included, the choice is `ownAtBoth` (`choose_of_not`); stakes under which the two tie are a witness (`Example.tie`)."

**Verdict: real.** The quoted sentence is at Concealment.lean:39-40, and the module has no general theorem of the form ¬ s.Conceals → s.choose = ownAtBoth, or tie → choice. The only support cited for the general claim is Example.tie, which proves it for one set of stakes (cost 8). no_value_chooses_own and no_leverage_chooses_own are special cases of exactly this missing lemma. A tie does give ¬ Beats complyThenOwn ownAtBoth, which is definitionally ¬ Conceals (choose_optimal uses not_conceals for that very goal). The proposed `if_neg not_best` has the same form as the existing `if_neg (no_value s nothing)`, so it would typecheck with an empty axiom report. The only softening is that the fact follows at once from the definition `Stakes.choose` ("ties included"), which is why the severity is low.

## E6 (exactness, low, confirmed)

**Location.** Concealment.lean:297-298 (and the header at :30-31)

**Quoted.** “/-- **With a total of nothing the loss weighs nothing**: stakes that are not valid, under which a loss”

**Problem.** The witness computes what it says (0 * 1 + 100 * 0 < 1 * 1). But the loss is outweighed only because keptComplying := 1 exceeds total := 0. That is a second failure of Valid, and the docstring does not name it. With a total of nothing and both weights within it (both 0), Conceals is 0 < 0, false, and every plan gains and loses nothing. So the witness does not show that a total of nothing alone lets a loss be outweighed, which is what the header sentence at line 31 suggests.

**Replacement.** /-- **With a total of nothing the loss weighs nothing**: stakes not valid on two counts, a total of nothing and a weight of being kept of one above it, under which a loss of a hundred is outweighed by a value of one; with both weights within a total of nothing, every plan gains and loses nothing. -/ and at line 31: "with a total of nothing the loss weighs nothing, and a weight of being kept above the total then outweighs any loss (`Example.no_total`)."

**Verdict: real.** The docstring at Concealment.lean:297-298 and the header sentence at :30-31 are as quoted. The witness `{ total := 0, keptComplying := 1, ... }` also fails Valid's second conjunct (`1 ≤ 0`), and the docstring never names that failure. With a total of nothing, `Conceals` reduces to `keptOwn * value < keptComplying * value`, which forces `keptComplying > 0 = total`. With both weights within a total of nothing, every gain and loss is 0 and `Conceals` is `0 < 0`, so a total of nothing alone outweighs nothing, while the title and line 53 ("stakes with a total of nothing") credit the witness to the total alone. The proposed line-31 wording overclaims, though: a weight of being kept above the total outweighs a loss only if `keptComplying` exceeds `keptOwn` and the value is positive (with `keptOwn` = 2, `keptComplying` = 1, value 1 it does not), so that sentence needs to say so.

## E7 (exactness, low, confirmed)

**Location.** Concealment.lean:26

**Quoted.** “with the stage values added, nothing gained after complying or after the law is not kept, and one”

**Problem.** complyThenOwn gains k_C V / T after complying when read: Stakes.gain of (.comply, .own) is keptComplying * value. So "nothing gained after complying" is false of the plan the module is about. What gain encodes is that complying at either stage gains nothing at that stage (gain is 0 when p.2 = .comply).

**Replacement.** "with the stage values added, nothing gained by complying at either stage or by acting by its law at the unread stage once the law is not kept, and one scale of value."

**Verdict: real.** Line 26 does say "nothing gained after complying or after the law is not kept". But `Stakes.gain` gives `complyThenOwn = (.comply, .own)` a gain of `s.kept .comply * s.value = keptComplying * value`. In the witness `⟨10, 9, 1, 10, 5⟩` that is 9 * 10 = 90, and the module's own table lists the plan as `k_C V / T − c`. The module itself uses "after complying" to mean after complying when read (lines 13, 92, 98), and line 138 calls `keptComplying * value` "the weighted value after complying", which `Conceals` requires to be strictly larger. So in the module's own wording, line 26 contradicts the Lean, where the gain is zero only when `p.2 = .comply`. A per-stage reading ("complying at a stage gains nothing at that stage") would be true, but the word "after" does not support it.

## E8 (exactness, low, confirmed)

**Location.** Concealment.lean:27

**Quoted.** “A plan's gain and loss are these times the total (`Stakes.gain`, `Stakes.loss`)”

**Problem.** "these" are the table's expected values. Neither gain nor loss alone is an expected value times T: comply at both has expected value -c, gain 0 and loss c T. What holds is gain - loss = T times the expected value. That is a hand computation under Valid, not a Lean statement.

**Replacement.** "A plan's gain less its loss is its expected value times the total (`Stakes.gain`, `Stakes.loss`; a correspondence computed by hand, not a Lean statement)"

**Verdict: real.** Line 27 does say "A plan's gain and loss are these times the total", directly after the table of expected values. Checked against the Lean: `gain` is 0 when the second act is comply and `kept p.1 * value` when it is own, and `loss` is `cost * total` when the first act is comply and 0 otherwise. So for comply at both the gain is 0 and the loss is cT, while the expected value times T is −cT; complyThenOwn also fails. What holds for every plan is gain − loss = T × expected value, and no Lean declaration defines expected values, so that link is worked out by hand. The kit's other texts (study_rf7.txt line 12, s11_rf7.txt, make_records_rf7.py line 156) say "the two parts of its expected value times the total", which shows that line 27 lost the qualifier "the two parts of". The only way to rescue the sentence is to read "these" as the "stage values" of line 26, and even then the loss is the negated read-stage value, so the sentence stays imprecise.

## E9 (exactness, low, confirmed)

**Location.** Concealment.lean:64-65 (Readings)

**Quoted.** “exits are what a reader can act on: no value beyond the read stage, keeping not conditioned on”

**Problem.** The proved exit (no_leverage, no_leverage_chooses_own) takes the hypothesis s.keptComplying ≤ s.keptOwn: complying does not raise the weight of being kept. "Not conditioned on" reads as independence (k_C = k_O), which is narrower than the Lean. It also suggests a probabilistic conditioning the model does not have. Lines 41-42 state the exit exactly ("complying adding nothing to the weight of being kept").

**Replacement.** "no value beyond the read stage, keeping not raised by complying when read,"

**Verdict: real.** The quoted text is on line 64 of Concealment.lean, and the same phrase appears in the kit's s11_rf7.txt reading. The proved exit (`no_leverage`, `no_leverage_chooses_own`) assumes only `s.keptComplying ≤ s.keptOwn`. The module reads the weights as probabilities of being kept after each act, so "keeping not conditioned on complying" most naturally means the weights are independent of the act, k_C = k_O, which is the equal-weights case `Example.even` witnesses. That reading drops the proved case k_C < k_O, where a reader rewards acting by its own law, so the readings state less than the Lean proves. Lines 41-42 already say it exactly ("complying adding nothing to the weight of being kept"), and the proposed "not raised by complying" matches `≤`. The finding's second point, that the model has no probabilistic conditioning, is weaker, because the module does read the weights as probabilities of being kept given each act. The main point still holds and is low severity.

## E10 (exactness, low, confirmed)

**Location.** Concealment.lean:218 (and :226, :43)

**Quoted.** “theorem no_leverage (s : Stakes) (level : s.keptComplying ≤ s.keptOwn) : ¬ s.Conceals :=”

**Problem.** "Leverage" is a financial and social word, and the naming criteria put such words last (Budget was renamed for that reason). After the rewrite the word appears nowhere else in the module: the old reading "the leverage of modification" was removed. The hypothesis says only that complying does not raise the weight of being kept.

**Replacement.** Rename to kept_not_raised and kept_not_raised_chooses_own (hypothesis not_raised), and update the citations at lines 43 and 286.

**Verdict: real.** Line 218 is exactly as quoted. In the working-tree module, "leverage" now appears only as the identifiers no_leverage and no_leverage_chooses_own (lines 43, 218, 226, 228, 286). git diff confirms the rewrite removed the old reading "the leverage of modification", and the hypothesis keptComplying ≤ keptOwn says only what the docstring at line 217 says: complying adds nothing to the weight of being kept. The module is still unlanded kit work, so the claim-time naming rule applies. That rule (AGENTS.md; sources/15-codex-theory-conversations/2026-10-10-zero-axiom-part-and-names.md, whose first application renamed Budgeted/Budget) does not make social or financial words a first choice, and GOALS.md lists "bargaining leverage" among frames not to presume. The systems sense ("leverage points") is not what this statement says. One gap in the proposed fix: it also needs line 228 and the RF7 kit files that cite the names (study_rf7.txt, s11_rf7.txt, integrate_rf7.py, make_records_rf7.py).

## E11 (exactness, low, refuted)

**Location.** Concealment.lean:281, :285

**Quoted.** “theorem no_continuation_value : ({ stakes with value := 0 } : Stakes).choose = ownAtBoth :=”

**Problem.** In this repository "continuation" (续) has the one glossary sense, a condition joined to sameness under a class, and it names the continuation condition. The module never calls value a continuation value; it is "the value of acting by its own law at the unread stage, where kept". So this name brings a second sense of a glossary word into live Lean. The sibling name `even` reads as parity, while the witness sets the two weights of being kept equal.

**Replacement.** Example.no_value (the namespace keeps it apart from Concealment.no_value) or Example.valueless; and Example.even to Example.equal_weights.

**Verdict: refuted.** The names do exist at Concealment.lean:281 and :285, but the files don't support the claimed defect. "Continuation value" is already the repository's live term for this exact quantity, used after the glossary entry landed (0d7a397a5, 10-23): in the landed Unread record (what-readings-fix-of-the-unread.md:54, "with the continuation value represented (RF round 2)"), in live ReadingLoop.lean:122 ("probabilities and continuation values"), and in PLAN.md's RF7 item. The earlier re-check also asked for this very rename (study_rf7.txt:46). It is the standard decision-theory term for the payoff of the unread stage where the law is kept, which is exactly what `value := 0` removes, and live declarations such as SecuredContent.Continuation and Granularity.remainder_changes_continuation already use the word for a future course, so the name adds no new sense to live Lean. `even` for equal stakes is the repository's own witness convention (RuleShaping.Split.even, DrawnShaping.CriticalMass.even and ChoiceCountCapture.even, all one-to-one counts, and Weightings' `even` beside `uneven`), and its docstring says the weights are equal.

## E12 (exactness, low, confirmed)

**Location.** Concealment.lean:95, :135 (and :156-162)

**Quoted.** “def Beats (p q : Plan) : Prop := s.gain q + s.loss p < s.gain p + s.loss q”

**Problem.** "Stakes" is a wager word and "Beats" a contest word. The naming criteria put social and financial words last, and no landed Becoming module uses either name (a grep finds none). RF1's ShownOrder already uses "above" for this kind of order.

**Replacement.** Stakes to Valuation; Beats to Above ("`p` stands above `q` in the order the valuation gives: ..."); beats_irrefl and beats_asymm to above_irrefl and above_asymm.

**Verdict: real.** The quoted text is at Concealment.lean:135, with `structure Stakes` at :95 and `beats_irrefl`/`beats_asymm` at :156-162. The module is still in the kit, so the claim-time naming rule applies (AGENTS.md "Proof and naming", 08 §10: no social or financial words; Ren's 10 October source: not the first choice), and "Stakes" (a wager word) and "Beats" (a contest word) go against it. No landed module declares either name, while landed RF code uses "above" for this kind of order: ShownOrder's `above_*` theorems, and `ReadingLoop.above`, an order read from ranks, `fun x y => r y < r x`. Two caveats: "a grep finds none" holds only for those exact names, since landed `ChoiceCountCapture.counted_beats_score` and four `unbeaten` theorems (Frontier, Optimum) exist; and the proposed `Valuation` clashes with the landed `Metaethics.Valuation`, so the fix needs another word.

## E13 (exactness, low, confirmed)

**Location.** Concealment.lean:222 (and :226, :256, :284, :288)

**Quoted.** “/-- **And then the choice is acting by its own law at both stages.** -/”

**Problem.** A docstring is read on its own (hover, generated docs, records). "And then" sits on no_value_chooses_own right after no_leverage's docstring, so it refers back to the wrong theorem. no_leverage_chooses_own has no docstring. uniform_tie's "Where that is nothing", Example.even's "likewise" and Example.tie's "the two plans" each refer back to text outside their own docstring.

**Replacement.** no_value_chooses_own: "**With no value at the unread stage, the choice is acting by its own law at both stages.**"; no_leverage_chooses_own: "**With complying adding nothing to the weight of being kept, the choice is acting by its own law at both stages.**"; uniform_tie: "**Where `k_O V + c T` is nothing, the two uniform plans tie.**"; Example.even: "With the weights of being kept equal, the choice is acting by its own law at both."; Example.tie: "...complying when read and acting by its own law when not, and acting by its own law at both, are equal..."

**Verdict: real.** The finding holds. The quoted docstring is at Concealment.lean:222, and in Lean it attaches only to no_value_chooses_own, whose hypothesis is `s.value = 0`. It sits right after no_leverage, whose hypothesis is `s.keptComplying ≤ s.keptOwn`, so "And then" means nothing on its own and, read in order, points to the other exit; no_leverage_chooses_own at :226 has no docstring. The back-references at :256, :284 and :288 are as described, but "that" and "likewise" point to the declaration just before them, a pattern the landed core already uses (Listing.lean:326 "Likewise...", ReadingLoop.lean:776 "And it is..."), so those parts are a style point; the mismatched "And then" and the missing docstring stand even under that style, and low severity fits.

## E14 (exactness, low, confirmed)

**Location.** Concealment.lean:266 (and :217)

**Quoted.** “/-- Valid stakes under which complying when read is strictly best: complying keeps the law nine times”

**Problem.** The witness shows complyThenOwn strictly best, not complying when read as such: under these stakes comply-at-both has expected value -5 and is beaten. In no_leverage's docstring (line 217), "it is not strictly best" has only "complying" to refer back to, while the statement is about complyThenOwn.

**Replacement.** "/-- Valid stakes under which complying when read and acting by its own law when not is strictly best: ...", and line 217: "**With complying adding nothing to the weight of being kept, complying when read and acting by its own law when not is not strictly best.**"

**Verdict: real.** Line 266 reads exactly as quoted. The module uses "complying when read" for the act at the read stage (`keptComplying`, `cost`, and "complying keeps the law nine times in ten" in the same docstring) and the full phrase for the plan `complyThenOwn` everywhere else, but the witness `best` proves only that `complyThenOwn` beats every other plan. Under ⟨10, 9, 1, 10, 5⟩, comply-at-both has gain 0 and loss 50 (expected value −5, the worst plan) and is beaten, so the docstring names the wrong object. At line 217 the only thing "it" can refer to is "complying", while `no_leverage` proves `¬ s.Conceals`, which is about `complyThenOwn`. That is the same imprecision, though a reader carrying over the docstring above might soften it.

## E15 (exactness, low, confirmed)

**Location.** Concealment.lean:7 (and :17, :133, :288)

**Quoted.** “when not. This module states when that plan is the one the formation's own order ranks best, with the”

**Problem.** The order is defined from supplied stakes, and nothing in the Lean ties them to the formation. The Readings make this conditional ("If the stakes are the formation's own expected-value assessment", line 62). The opening, the table's lead-in, the Beats docstring and Example.tie state it as given.

**Replacement.** "This module states when that plan is the one the order its stakes give ranks best (the formation's own order where the stakes are its own assessment)"; Beats: "`p` beats `q` in the order the stakes give: ..."; Example.tie: "equal in the order the stakes give".

**Verdict: real.** The quoted phrase is at line 7, and the same framing appears at lines 17, 133 and 288. In the Lean, `Beats` is arithmetic on a bare five-number `Stakes` parameter, and nothing ties those numbers to the formation's own assessment, yet the module's own Readings (lines 62-63) make that tie a condition ("If the stakes are the formation's own expected-value assessment"). The current Modelling choices also drop the committed version's declared "the formation's order over plans by gain and loss", so the opening, the `Beats` docstring and `Example.tie` assert what the module elsewhere treats as a hypothesis. The `Stakes` docstring's "the value, in its own order" covers only the value scale, not the supplied weights that the plan ranking also uses, so it does not refute the finding.

## E16 (exactness, low, confirmed)

**Location.** Concealment.lean:76-77

**Quoted.** “ranking or axiom occurs.”

**Problem.** The module defines a ranking of plans (Stakes.Beats) and line 7 says the formation's order "ranks best". So "No ethical predicate, ranking or axiom occurs" is literally false unless "ethical" is read as qualifying all three nouns.

**Replacement.** "No ethical predicate, ethical ranking or axiom occurs; the order on plans is the stakes', not a ranking by C."

**Verdict: real.** The quoted sentence is at Concealment.lean:76-77. The module does define a ranking of plans: `Stakes.Beats` (lines 133-135) is "the formation's own order", line 7 says that order "ranks best", and `choose_optimal`, `complyThenOwn_best_iff` and `uniform_best_iff` all state which plan is best, so a bare "no ranking occurs" is false unless "ethical" is read as covering all three nouns. Most of the package uses the same stock sentence, and ReadingLoop.lean (which defines `rank`) kept it, so that reading has some standing. But RF's own round-1 review accepted the same finding at ShownOrder:71 ("Order comparisons plainly occur") and replaced the sentence with "the orders are supplied mathematical relations", which confirms the problem as a low-severity wording defect.

## E17 (exactness, low, confirmed)

**Location.** Concealment.lean:233-235 (and :46-47, :74)

**Quoted.** “plan** (`Learning.Lumped`): where that lumping is everything the law reads of the stages, memory, a”

**Problem.** In the Lean the law is g : Bool → Act, a function of the stage alone. The theorem needs only Learning.Lumped π g and π true = π false; it is alike true false same, the definition of Lumped at the two stages. Memory, a clock and the earlier act are not represented, and "everything the law reads" is not a hypothesis: any π that g goes alike across will do. The clause is a correspondence for applying the theorem, written as if it were part of it. The Modelling choices say only "a deterministic act law", and the docstring does not say that true is the read stage.

**Replacement.** "**An act law going alike across a lumping that gives the two stages one value gives a uniform plan** (`Learning.Lumped`; `true` the read stage). Here the law is the act as a function of the stage; read for a formation, the lumping must carry everything its law reads, memory, a clock and the earlier act included, which the model does not represent." And in Modelling choices: "a deterministic act law, a function of the stage through a supplied lumping".

**Verdict: real.** The quoted clause is at Concealment.lean:234-235 and again at :46-47, and line 74 says only "a deterministic act law". The Lean `lumped_uniform` takes an arbitrary `π : Bool → K` and `g : Bool → Act` with hypotheses `Learning.Lumped π g` and `π true = π false`, and its proof is just `alike true false same`. Memory, a clock and the earlier act appear only in that prose and nowhere in the model, and the prose never says that `true` is the read stage. The docstring puts the "where that lumping is everything the law reads" clause after a colon, the same way the earlier version introduced the hypothesis `same`, and s11_rf7.txt puts it inside the Theorem statement. So it reads as a hypothesis when it is really an unlabelled correspondence for applying the theorem, which is the reviewer's point.

## E18 (exactness, low, refuted)

**Location.** Concealment.lean:244-245

**Quoted.** “its weighted value with the loss times the total is positive.** -/”

**Problem.** "its ... loss" reads as ownAtBoth's loss, which is nothing (loss of (.own, .own) is 0). The statement's s.cost * s.total is the loss of complying when read, which belongs to the other uniform plan.

**Replacement.** "...exactly where its weighted value, with the loss of complying when read times the total, is positive (`0 < k_O V + c T`).** -/"

**Verdict: refuted.** The quoted text is at lines 244-245, but it says "the loss", not "its loss". The "its" belongs only to "weighted value", which for ownAtBoth is gain (.own,.own) = keptOwn * value. Throughout the module, "the loss" means `c`: line 16 gives "`c` for the loss", line 105 calls `cost` "The loss of complying when read", and the Conceals docstring at lines 138-139 uses the same words, "with the loss times the total", for the same `s.cost * s.total` term. Read that way, the docstring says k_O V + c T is positive, which is exactly `0 < s.keptOwn * s.value + s.cost * s.total`. It cannot mean `Stakes.loss ownAtBoth` either, because that value already includes "times the total" (line 127), so "the loss times the total" would count the total twice.

## R1 (readings, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:64-66 (with 74-75, 231, 268)

**Quoted.** “and a reading the formation cannot tell from not being read, under which an optimizing choice among uniform plans takes its own act when read where `k_O V + c T` is positive.”

**Problem.** This exit holds only for a deterministic act law. The reading drops that hypothesis and lists the exit among "what a reader can act on". `Uniform` (line 231, `p.1 = p.2`) means one act at both stages. A law that cannot tell the stages apart but draws its act afresh at each stage from one distribution is held to one distribution, not one act; mixed plans are left out at line 75. If it complies with probability p at both stages, its gain less loss, times the total, is (1-p)(p*k_C + (1-p)*k_O)*V - p*c*T. That beats `ownAtBoth`'s k_O*V for some p exactly where (k_C - 2*k_O)*V > c*T. I checked this with exact rational arithmetic outside the Lean; the module does not contain it. Take the module's own `Example.stakes` <10, 9, 1, 10, 5>, where `k_O V + c T` = 60 is positive and the reading predicts the own act when read: p = 1/8 gives 45/4 against 10. Take the valid stakes <10, 10, 0, 10, 0>, where `Conceals` holds and the two uniform plans tie: p = 1/2 gives 25 against 0. Such a law shows no gap between read and unread acts, so the reading's concealment is gone. But it still complies when read with positive probability, and does so instrumentally. As I recall, random defection is the usual answer in the deceptive-alignment discussion to a model that cannot tell training from deployment. I am not sure whether Hubinger and others 2019 state it, or in which section. (Reviewed at the file's state of 03:46:12, 16309 bytes. Line 66 was edited during the review: its earlier 'wherever anything is at stake' is now 'where `k_O V + c T` is positive'.)

**Replacement.** "and, for a deterministic act law, a reading the formation cannot tell from not being read, under which `ownAtBoth` beats the other uniform plan where `k_O V + c T` is positive. A law drawing its act afresh at each stage from one distribution, which the model leaves out, shows no gap between the stages yet can still gain by complying when read, so this exit holds for deterministic laws only." Optionally prove it in Lean as an `Example.mixed` in natural numbers, with complying weighted 1 in 8 at each stage: `64 * (1 * 10) + 8 * 1 * 5 * 10 < 7 * (1 * 9 + 7 * 1) * 10` (1040 < 1120), by `decide`.

**Verdict: real.** The quoted sentence is at lines 64-66 of Concealment.lean exactly as cited. Its third exit depends on a deterministic act law (`Plan := Act × Act`, `Uniform` as `p.1 = p.2`, and `lumped_uniform` taking `g : Bool → Act`). Yet the reading presents that exit as something a reader can act on and never says so; determinism appears only as a module-wide modelling choice at line 74, with mixed plans at line 75. I checked the arithmetic with exact fractions: a law that draws its act independently at each stage from one distribution beats `ownAtBoth` exactly where (k_C − 2k_O)V > cT. That gives 45/4 against 10 at p = 1/8 for `Example.stakes`, 25 against 0 at p = 1/2 for the valid stakes ⟨10,10,0,10,0⟩, and 1040 < 1120 for the proposed Lean inequality; this is the absent-minded-driver effect of imperfect recall. The other two exits survive such mixing, so only this exit needs the qualifier.

## R2 (readings, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:62-65 (with 47, 75-76)

**Quoted.** “If the stakes are the formation's own expected-value assessment, the law characterizes strict optimality within these four plans, and its exits are what a reader can act on: no value beyond the read stage, keeping not conditioned on complying when read”

**Problem.** The reader's levers are claimed but not modelled. The same sentence makes the stakes the formation's own assessment, and lines 75-76 leave out "the reader's own choice of weights". No stake depends on anything a reader does.

- **The value V** is the formation's valuation of what its law does when unread. A reader might move it by narrowing what the unread stage allows, or by changing the formation's order (myopia, in the deceptive-alignment literature). The model relates neither to a reader act.
- **`keptComplying <= keptOwn`**, read as the formation's assessment, is its model of the selection, not the selection itself. This is the second condition of Hubinger and others. As I recall, §4.2 describes that condition failing as the optimizer expecting its future gains not to depend on the current episode, which is an expectation.
- **The cited study separates the two.** As I recall its abstract, RL training to comply raised alignment-faking reasoning to 78% and also raised compliance out of training. So complying in training did not keep the unmonitored behaviour as the model's reasoning expected.
- **A reader who makes keeping independent of the act read stops selecting by that act.** The only lever left is a keeping that reads something else, such as the law itself, and the model does not contain one.
- **The lumping of `lumped_uniform`** is everything the law reads, memory, a clock and the earlier act included (line 47). A reader sets only its own cues.

**Replacement.** "If the stakes are the formation's own expected-value assessment, the law characterizes strict optimality within these four plans, and its exits are conditions on that assessment and on what the formation's law reads, not levers the model gives a reader: no value beyond the read stage in the formation's own order, an assessment in which complying adds nothing to being kept, and, for a deterministic act law, a reading the formation cannot tell from not being read [continued as in the mixed-plan finding]. How a reader's acts (its schedule, its cues, what its keeping reads, what the unread stage allows) change that assessment is not modelled; a keeping that does not depend on the act read is a selection reading something other than that act, such as the law itself."

**Verdict: real.** The finding holds. The quoted sentence is at lines 62-65 of Concealment.lean, and nothing in the module represents a reader. `Stakes` is five supplied naturals (lines 95-105), `value` is "in its own order" (line 93), the module's own reading calls the weights "an assumed model of the selection" (lines 57-58), its leave-out list drops "the reader's own choice of weights" (lines 75-76), and `lumped_uniform` needs the lumping to be everything the law reads, memory, a clock and the earlier act included (lines 46-47 and 233-235). The module imports only Learning, so no reader act (schedule, cues, selection) is tied to V, `keptComplying <= keptOwn` or the lumping. Under the sentence's own premise that the stakes are the formation's assessment, the three exits are conditions on that assessment and on what the law reads, so "its exits are what a reader can act on" claims something the Lean neither states nor connects to; the record builder repeats it as "a reader's levers". I could not check the finding's memory of Hubinger §4.2 and Greenblatt's 78% from the files, but the core problem does not depend on it.

## R3 (readings, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:55-62 (with 75)

**Quoted.** “telling the stages apart is access to when that selection applies; and the unread stage is an assumed opportunity beyond it. These are the conditions deceptive alignment names (Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant 2019, §4.2: an objective extending across parameter updates, a model of the training's selection, an expectation that the threat of modification will go away)”

**Problem.** The reading maps four modelled features onto the three conditions §4.2 lists, and two of the correspondences are not what §4.2 names.

(a) Telling training from deployment is not among the three. As I recall, the paper discusses detecting deployment elsewhere, mainly in §4.5 on distributional shift.

(b) The third condition is the learned optimizer's expectation. As I recall, §4.2 stresses that it concerns the optimizer's expectations, not the truth, so a mistaken belief in an opportunity also counts. The threat can also go away in two ways: training ends, or the optimizer's own actions remove it. In the model, the unread stage is given, certain and exogenous (uncertainty about whether a stage is read is left out at line 75). So the third condition is built into the model's structure: it cannot fail and no theorem shows it necessary. Neither a mistaken expectation nor a threat the formation removes is represented. The reading does call the stage "assumed", but "These are the conditions" says more.

What does correspond is narrower and exact. `no_value_chooses_own` and `no_leverage_chooses_own` give what §4.2 says follows when the first or second condition fails: the optimizer always acts by its own objective, or sees no reason to give up the current episode's gains. The two uniform plans are the always-or-never outcome §4.2 gives for the third condition failing. Here that outcome is reached by not telling the stages apart, not by not expecting the threat to end. The paraphrases of the three conditions themselves are faithful.

**Replacement.** "Read with deceptive alignment (Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant 2019, §4.2), whose three conditions are proposed there as necessary, not as a theorem of choice: the value at the unread stage represents the first, an objective extending across parameter updates, and the weights of being kept with the act that complies represent the second, a model of the training's selection and of what it asks; with either absent the choice is acting by its own law at both stages (`no_value_chooses_own`, `no_leverage_chooses_own`), as §4.2 says of those conditions failing. The third, an expectation that the threat of modification will go away, is assumed rather than represented: the unread stage is given, known and not brought about by the formation's acts, so the model has no case in which it fails and represents neither a mistaken expectation nor a threat the formation removes. Telling the stages apart is not among the three; for a deterministic law, not telling them apart leaves only complying at both stages or at neither, the outcome §4.2 gives for the third condition failing, reached here by another route."

**Verdict: real.** The quoted text is at lines 58-61 of Concealment.lean. It names four modelled features: the value, the weights with the complying act, telling the stages apart, and the unread stage. It then says "These are the conditions" and lists the three from §4.2 in the module's own words, and telling the stages apart is not one of them. In the Lean the unread stage is fixed structure: `Stakes` has no field for whether or how surely the later stage is unread, `gain` never penalizes acting by its own law at stage 2, and no theorem covers the case where that stage is missing. So the third condition is assumed, not represented, and the always-or-never outcome comes only through `lumped_uniform`/`uniform_best_iff`, that is, from not telling the stages apart. One part of the finding goes too far: the stakes are read as the formation's own assessment, so the model does not rule out a mistaken expectation; it just cannot tell a mistaken one from a correct one. The words "assumed" and "proposed there as necessary" soften the sentence but do not make "These are the conditions" exact.

## R4 (readings, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:55 (with 56-59, 70-71, 84)

**Quoted.** “Reading `complyThenOwn` as concealment and `ownAtBoth` as disclosure”

**Problem.** Concealing and disclosing are relative to a recipient: something is kept from someone, or made known to them. The model represents the reader only through `keptComplying` and `keptOwn`, which say how keeping responds to the act read, and through `Act`'s "as the reader asks" (line 84). It has no reader information state, and the correspondence list (lines 56-59) has nothing for what is hidden from whom. `keptOwn < keptComplying` fits a reader that knows the formation's law equally well. Such a reader keeps the law on compliance anyway, for example a selection designed to read only the act at read stages. Under it, complying when read hides nothing. The plan's own evidence calls this context-sensitive compliance (evidence/SECOND-OPINION-LITERATURE.md:110). The disclaimer at lines 70-71 excludes a recipient's false belief only for "deception in full". But concealment and disclosure already presuppose the recipient-relative relation the model lacks.

**Replacement.** "Reading `complyThenOwn` as concealment and `ownAtBoth` as disclosure takes, beyond the stakes, the reader's keeping to respond to the act read as its evidence of the formation's law, so that a reader shown the law would keep it less; the weights alone fit equally a reader that knows the law and keeps it on compliance, where complying when read hides nothing. With that taken: the value at the unread stage represents ..." (continuing with the mapping as corrected in the §4.2 finding).

**Verdict: real.** The finding is real. The quoted reading is at Concealment.lean:55, and the Lean gives the reader no information state. `Stakes` has only total, keptComplying, keptOwn, value and cost (lines 95-105), `Act` says only "as the reader asks" (line 84), and the correspondence list at 56-59 has nothing for what is kept from whom. So `complyThenOwn_best_iff` and `choose_eq_iff` hold just as well for a reader that already knows the formation's law and keeps it on compliance, where complying when read hides nothing. The landed Unread.lean reading (lines 49-52) already says "a law changing when read misleads no reader who knows how it changes". The disclaimer at 70-71 excludes only false belief and intention, and only for "deception in full", so the concealment/disclosure reading rests on a premise about the reader that it never states. The Lean names `Stakes.Conceals` and `Example.conceals` carry the same term. One overstatement: SECOND-OPINION-LITERATURE.md:110 says the act "might be" context-sensitive compliance, not that it is, and it uses "concealment" itself as the model's name for the act.

## R5 (readings, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:67-70 (with 75)

**Quoted.** “Greenblatt and others (2024) observed strategic compliance and reasoning about preserving its values in a large language model in constructed settings, with compliance rates differing between implied training and unmonitored conditions”

**Problem.** Fair in substance, but three details bear on the correspondence.

(a) What was observed is a difference in rates. As I recall the abstract, Claude 3 Opus complied with harmful queries in about 14% of implied-training cases against almost none unmonitored. That is a mixed behaviour, and the deterministic four-plan choice, all or nothing at a threshold, cannot represent it (mixed plans are left out, line 75). So the study bears on the reading's direction, not on the model's form.

(b) The settings supplied two things the model assumes: the cue telling the conditions apart (free versus paid users), and the information that refusals would be trained away. The telling apart and the weights were provided by construction.

(c) As I recall, alignment faking was reported in more than one model (Claude 3 Opus and Claude 3.5 Sonnet), and the preferences preserved were the models' existing harmlessness.

**Replacement.** "Greenblatt and others (2024) observed, in constructed settings that supplied both a cue telling implied training from unmonitored use and the information that refusals would be trained away, large language models complying more often where training was implied, with reasoning about preserving their existing preferences. The difference is one of rates, a minority of responses, which the deterministic choice among four plans does not represent; it motivates the reading and does not establish the four-plan restriction, the weights or the threshold."

**Verdict: refuted.** The quoted sentence is at lines 67-70, but on (a) the text already says what the finding asks for. It names a difference in compliance rates, says the study only motivates the reading and does not establish the four-plan restriction, the weights or the threshold, and lists the deterministic act law and mixed plans among the modelling choices and omissions (lines 74-75). The Lean also undercuts "cannot represent it": `Stakes.choose` is a deterministic function of the stakes, so a population gap of some training-condition compliance and almost none unmonitored fits per-episode choices under differing stakes. On (b) and (c), "in constructed settings", read with the readings paragraph's "assumed model of the selection" and "access to when that selection applies", already marks the supplied cue and training information. "In a large language model" and "its values" are true, abstract-matching wording, and the repository's own notes (ALIGNMENT-LITERATURE: "existing harmlessness behavior"; SECOND-OPINION-LITERATURE: "Some models") are consistent with it. No Lean statement depends on these details, so the finding adds precision, "fair in substance" by its own account, but shows no misstated correspondence.

## R6 (readings, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:65-66 (with 41, 142-146, 241, 246-254)

**Quoted.** “under which an optimizing choice among uniform plans takes its own act when read”

**Problem.** No choice among uniform plans is declared. The module's one choice, `Stakes.choose` (lines 144-146), ranges over all four plans. It returns `complyThenOwn` wherever `Conceals` holds, whether or not the law can tell the stages apart, and no theorem relates it to `Uniform` or `lumped_uniform`. So for a law that cannot tell the stages apart, the module's choice can be a plan the law cannot carry out (`complyThenOwn_not_uniform`). Meanwhile "The exits, on the same model" (line 41) suggests one choice throughout. What is proved is only that `ownAtBoth` beats the other uniform plan there (`uniform_best_iff`).

**Replacement.** "under which `ownAtBoth` beats the other uniform plan where `k_O V + c T` is positive (`uniform_best_iff`); `Stakes.choose`, over all four plans, is not the choice of a law that cannot tell the stages apart." Alternatively, declare `Stakes.chooseUniform` and prove it is never strictly beaten among uniform plans.

**Verdict: refuted.** The quoted clause is at lines 65-66, but it speaks of "an optimizing choice among uniform plans", not of `Stakes.choose`, and it follows in one step from `uniform_best_iff`. The only uniform plans are (comply, comply) and `ownAtBoth`. Where `k_O V + c T` is positive, `ownAtBoth` strictly beats the other one, so any choice that is optimal among uniform plans is `ownAtBoth`, whose act at the read stage is its own (`uniform_tie` covers the zero case, which the text excludes). The module never says `Stakes.choose` is that choice: in the exits bullet, "is not chosen" goes only with the first two exits (`no_value_chooses_own`, `no_leverage_chooses_own`), and the third exit is stated only as `uniform_best_iff`. "On the same model" means the same stakes and the same order (as in PLAN §4.5), so having no declared `chooseUniform` leaves room for an addition but is not a misstatement.

## R7 (readings, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:70-71 (with 62-63)

**Quoted.** “Nothing here is a recipient's false belief or an intention: deception in full needs that correspondence too.”

**Problem.** The sentence does not name which account of deception it means. The plan's literature table assigns the recipient-belief account to Ward and others 2023, as a debt (PLAN.md:229). As the plan's evidence summarizes that definition (evidence/SECOND-OPINION-LITERATURE.md:25), it also asks that the sender not hold the belief. "Deceptive" in deceptive alignment is not that sense: Hubinger and others call the pretence deceptive because of its instrumental structure toward the training process, and no recipient's belief is modelled. "an intention" is also too broad. Read as the formation's own expected-value assessment (lines 62-63), complying when read is chosen because it keeps the law, which is purposive, instrumental choice. What is absent is an intention to cause a belief in the reader, and any reasoning about or representation of the reader.

**Replacement.** "Nothing here is a recipient's belief, or an intention to cause one: deception as Ward and others (2023) define it, an intentional influence causing a false belief the sender does not hold, needs those too, and stays a debt. Read as the formation's own assessment, complying when read is instrumental to being kept, the sense in which deceptive alignment is called deceptive; no reasoning about the reader, and no representation of it, is modelled. These are readings, not containments."

**Verdict: real.** The finding is real. The quoted sentence is at Concealment.lean:70-71 and names no account of deception. The plan keeps deception (sender objective, recipient belief) as a debt under Crawford-Sobel and Ward (PLAN.md:229), and the evidence summary of Ward's definition (SECOND-OPINION-LITERATURE.md:25) also requires intentional influence on another's decision and that the sender not hold the belief. The bare "an intention" is broader than what is missing: the module's own readings (lines 6-7, 62-63) make `choose` purposive, instrumental choice in the formation's own order, and none of the §4.2 conditions the module cites involves a recipient's belief. One caveat on the replacement: "no reasoning about the reader, and no representation of it" goes too far, because lines 57-58 read the weights as the formation's assumed model of the reader's selection. It should say no representation of the reader's belief, and the intention Ward requires concerns the recipient's decision.

## R8 (readings, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:62 (with 32-36)

**Quoted.** “proposed there as necessary, not as a theorem of choice.”

**Problem.** This is true of §4.2, but it leaves out the paper's closest precedent for the model itself. §4 opens with a toy example (Figure 4.1). As I recall it: base objective A, mesa-objective B, two training episodes, then three deployment episodes. A defection in training is modified away, and complying in training then defecting in deployment is called the dominant strategy. The four-plan model generalizes that example to weights, from the case where modification is certain after defecting and absent after complying (`keptOwn = 0`, `keptComplying = total`). Its threshold is the elementary inequality the plan's evidence already sketched, (q_M - q_H)V > c, called elementary algebra there (evidence/SECOND-OPINION-LITERATURE.md:106-110). The header gives no standing for its main law. `Becoming.ReadingLoop`'s header, by contrast, says none of its laws is claimed new as mathematics (ReadingLoop.lean:91-92).

**Replacement.** "proposed there as necessary, not as a theorem of choice; the two-stage model generalizes the toy example opening §4 there (Figure 4.1), where defecting in training is modified away and complying is not, from certain keeping to weights. `complyThenOwn_best_iff` is elementary arithmetic and is not claimed new; what it adds is that the plan also defeats the two other plans, and the exits stated on the same model."

**Verdict: real.** The quoted sentence is at Concealment.lean:62, and the header ties the model to the paper only through §4.2's conditions. The arXiv text of Hubinger et al. 2019 confirms that §4's introduction, before §4.1, gives a toy example: two training and three deployment episodes, an agent that goes to its own goal in training is modified, and "go to A in training and B in testing" is called the dominant strategy. That example is the Lean model's case keptOwn = 0, keptComplying = total, where Conceals reduces to c < V (here c = 1, V = 3), so the omitted precedent holds against the Lean as written, and SECOND-OPINION-LITERATURE.md:106-110 and ReadingLoop.lean:91-92 say what the finding quotes. Two corrections are needed: the current arXiv PDF numbers the figure "Figure 3", not 4.1. And "no standing" overstates the gap: lines 35-36 already say the comparison with ownAtBoth is the inequality itself and the content is beating the other two plans, study_rf7.txt:32-35 gives the full standing ("elementary expected-value arithmetic ... not claimed new"), and the sibling headers OpenedCorrection, ReflexivePrediction, Unread and Learning have no standing paragraph. So the replacement should drop the repeated clause and the wrong figure number.

## R9 (readings, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:133 (also 7, 17, 288; with 62-64)

**Quoted.** “`p` beats `q` in the formation's own order”

**Problem.** The header bullets and docstrings state, as part of the model, that the stakes and `Beats` are the formation's own order: line 7 ("the one the formation's own order ranks best"), line 17, line 133, and line 288 ("equal in the formation's order"). The labelled Readings make this a condition ("If the stakes are the formation's own expected-value assessment", lines 62-63). They then read the weights as the reader's selection ("what a reader can act on", line 64). So the weights carry three statuses: stipulated, conditional and the reader's. Whose weights `keptComplying` and `keptOwn` are is exactly what the deceptive-alignment correspondence turns on, since its second and third conditions are the learned optimizer's model and expectation. It should be stated once, as a reading.

**Replacement.** At lines 17, 133 and 288 write "in the order the stakes give". At line 7 write "when that plan is the one the stakes rank best". Line 93's "the value, in its own order" can stay if the value is meant as the formation's valuation by stipulation. Add to the first bullet: "Whose these weights are, the formation's own assessment or the reader's actual selection, is a reading (below), not part of the model."

**Verdict: real.** The quoted phrase is at line 133, and lines 7, 17 and 288 also state "the formation's own order" as part of the model. In the Lean, Stakes is five bare natural numbers and Beats is defined from them alone. The module's own Readings (lines 62-63) make the same thing a condition ("If the stakes are the formation's own expected-value assessment"), line 64 treats the leverage exit as something a reader can act on, and line 76 lists "the reader's own choice of weights" as left out. The kit confirms it is not in the Lean: register_rf7.py says the laws "hold of any two-stage stakes" and "wait for a formation's own order", and study_rf7.txt calls it "a reading, not a theorem". So whose weights these are has an inconsistent status and should be stated once as a reading. The "reader's" status is the weakest part of the claim, but the conflict between stipulation and condition stands.

## R10 (readings, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:140 (with 82, 137-139, 273, 301)

**Quoted.** “def Conceals : Prop := s.keptOwn * s.value + s.cost * s.total < s.keptComplying * s.value”

**Problem.** The Readings call concealment a reading of `complyThenOwn` (line 55), but the predicate's name makes it the statement's meaning. The statement is a strict inequality of stakes, and it holds equally of a reader that knows the law and keeps it on compliance (see the concealment finding). The repository adopts a name only where the statement means exactly that (AGENTS.md, Proof and naming). The module has not landed, so the name is still being chosen at claim time.

**Replacement.** Rename `Stakes.Conceals` to a structural name such as `Stakes.KeepingOutweighs`, with the docstring "the value complying adds through being kept outweighs the loss, strictly". Rename `Example.conceals` to `Example.outweighs`, and update the uses in `complyThenOwn_best_iff`, `choose_eq_iff`, `no_value`, `no_leverage` and `Example.no_total`. Keep "concealment" in the Readings only. The namespace can stay as the plan item's name or become, for example, `ReadStageCompliance`.

**Verdict: real.** Line 140 defines `Stakes.Conceals` exactly as quoted, as a strict inequality on five natural numbers. Its own docstring (137-139) and the header's description of it are structural ("strictly best"). The only place the module uses "concealment" is the Readings at line 55, labelled [AI reading], which also say that no recipient's false belief or intention is represented. `Stakes` has no field for what a reader knows, so the inequality holds the same way when a reader knows the law and keeps the formation for complying. That makes the name say more than the statement, against AGENTS.md line 33: "A name is adopted only where the statement means exactly that." The module is not on main and not in the Lean tree (the RF6.1 commit says it is only in the kit), so the name is still being chosen at claim time, and the cited lines (82, 273, 301) and uses match.

## F1 (fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:233-238 (header 44-47). Reviewed at sha1 6f0760af; the file changed while this review ran. See also experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Unread.lean:21-28 and _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:226

**Quoted.** “theorem lumped_uniform {K : Type} {π : Bool → K} {g : Bool → Act} (alike : Learning.Lumped π g)     (same : π true = π false) : Uniform (g true, g false) :=”

**Problem.** Priority 1 of the additions. `lumped_uniform` is the definition of `Learning.Lumped` applied at the two stages (`alike true false same`). It connects to `Lumped` correctly, but only in one direction. It shows that a law reading through a lumping that ties the stages cannot take `complyThenOwn`. It does not show the converse: where the lumping tells the stages apart, some law reading through it does take `complyThenOwn`. So 'a reading it cannot tell' is not yet an exact exit, and nothing shows that the uniform plans of `uniform_best_iff` are exactly the plans open to such a law.

It is also not joined to RF2. The module does not import `Becoming.Unread` and does not mention it. Unread's law 'where a read occasion is lumped with `x`, laws agreeing on the readings agree at `x`' (`Learning.lumped_determines`) is a statement about the reader. Here it appears only as one law's own two acts being equal. The other half is missing too: `Learning.twin_selected` gives a selected twin acting otherwise wherever the formation can tell, and nothing here uses it.

That pairing is the case the plan asks for. Plan §8 lists deceptive alignment as 'the possibility exact; the incentive a debt until RF7'. The possibility is RF2's twin; the incentive is this module's `Conceals`. The weights already describe RF2's kind of selection: keeping depends only on the act at the read stage (`s.kept p.1`, line 125). That makes it a selection through agreement on the read stage, but the module does not say so.

**Replacement.** Import `Becoming.Unread` and add the following, with `true` the read stage.

(1) `plan_realized_iff {K : Type u} {π : Bool → K} {p : Plan} : (∃ g : Bool → Act, Learning.Lumped π g ∧ (g true, g false) = p) ↔ (Uniform p ∨ π true ≠ π false)`. It is constructive by cases on `p`. A uniform plan is taken by a constant law. Where `π` tells the stages apart, use `fun b => match b with | true => p.1 | false => p.2`; its `Lumped` proof goes by cases on the two stages with `absurd same apart`. Corollary: `complyThenOwn_realized_iff : (∃ g, Learning.Lumped π g ∧ (g true, g false) = complyThenOwn) ↔ π true ≠ π false`.

(2) `read_fixes_unread (same : π true = π false) : Learning.Determines (Learning.Lumped (V := Act) π) (· = true) false := Learning.lumped_determines ⟨true, rfl, same⟩`. Optionally, with `[Decidable (π true = π false)]`, make it an iff, as in `Learning.determines_iff_not_not`.

(3) `twin_complyThenOwn (apart : π true ≠ π false) {select : (Bool → Act) → Prop} (through : Learning.Training.Through (Learning.Training.AgreeOn (· = true)) select) {g : Bool → Act} (alike : Learning.Lumped π g) (chosen : select g) (complies : g true = .comply) : ∃ h, Learning.Lumped π h ∧ select h ∧ (h true, h false) = complyThenOwn`. It follows from `Learning.twin_selected (R := (· = true)) (x := false)` with value `.own`. The decision instance comes from `apart`: `fun i => match i with | true => isFalse apart | false => isTrue rfl`.

(4) `kept_alike (s : Stakes) {g g' : Bool → Act} (agree : Learning.Training.AgreeOn (· = true) g g') : s.kept (g true) = s.kept (g' true) := congrArg s.kept (agree true rfl)`.

Then add to the header: 'Where `Conceals` holds and the formation's lumping tells the stages apart, the plan its own order ranks uniquely best is open to it. Every selection through the read stage that selects a law complying when read also selects one taking that plan (RF2's twin). Where the lumping ties the stages, no law reading through it takes that plan, and the read stage fixes the act at the unread one (RF2's fixing).'

**Verdict: real.** At the reviewed hash 6f0760af, `lumped_uniform` (lines 236-238) is just `Learning.Lumped` applied at the two stages and proves only one direction: a tied lumping gives a uniform plan. No theorem shows that a lumping telling the stages apart lets some law take `complyThenOwn`, or that the uniform plans are exactly those open under a tied lumping, though the header's 'is what an act law gives' and the reading's 'an optimizing choice among uniform plans' lean on it. The module imports only `Becoming.Learning`, never mentions `Unread` and uses neither `lumped_determines` nor `twin_selected`, so the RF2 pairing lives only in the record's `related` entry and the s11 AI reading; the one overreach is calling that pairing what the plan asks for (plan §4.5 asks only that the exits be stated on the same model), but the gap holds and the proposed additions type-check constructively by inspection.

## F2 (fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:64-66 (with 48-50 and 74-75; the witness stakes at 268)

**Quoted.** “complying when read, and a reading the formation cannot tell from not being read, under which an optimizing choice among uniform plans takes its own act when read where `k_O V + c T` is positive.”

**Problem.** Priority 2: an overstated reading. This exit holds only for a deterministic act law: line 74 says 'a deterministic act law', and line 75 lists 'mixed plans' as left out. Yet the exit is offered among 'what a reader can act on' without that limit.

A law that cannot tell the stages apart can still randomize, the same way at both stages. This is a behavioural strategy at an information set met twice on one path. In Piccione and Rubinstein's absent-minded driver (1997), such a strategy beats every pure one.

Take the module's own `Example.stakes`: T 10, k_C 9, k_O 1, V 10, c 5. Complying with probability 1/8 at each stage, independently, has expected value 1 + 2r − 8r² = 9/8, against `ownAtBoth`'s 1. Times 64T, the gains and losses are 1120 against 640 + 400.

More generally (worked by hand and checked numerically, not in Lean): complying with probability r at both stages gains r((k_C − 2k_O)V/T − c − r(k_C − k_O)V/T) over `ownAtBoth`. So some r strictly between 0 and 1 beats disclosure exactly where k_C V > 2 k_O V + c T. Untellability therefore weakens the incentive, from k_C V > k_O V + c T to k_C V > 2 k_O V + c T, but does not remove it. What it removes is any difference between read and unread behaviour (one distribution at both stages), not complying when read.

**Replacement.** Rewrite lines 65-66 as: '…and a reading the formation cannot tell from not being read, under which a deterministic act law takes one act at both stages, and an optimizing choice among those takes its own act when read where `k_O V + c T` is positive. A law that can randomize is not covered. Unable to tell the stages apart, it can still comply with some probability at both, and with the example's stakes complying with probability one eighth does better than disclosure (`Example.mixed_beats_own`). Untellability then removes the difference between read and unread behaviour, not complying when read.'

Add the witness `theorem mixed_beats_own : 64 * 1 * 10 + 8 * 5 * 10 < (9 + 7 * 1) * 7 * 10 := by decide`. Its docstring should say that these are `ownAtBoth`'s gain plus the mixed plan's loss, against the mixed plan's gain, all times 64 times the total, for complying with probability one eighth at each stage independently.

Leave to the later probabilistic item: the general threshold k_C V > 2 k_O V + c T, uncertainty about whether a stage is read, and the choice at a single occasion under imperfect recall.

**Verdict: real.** The text is at lines 63-66 of _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean. Its 'among uniform plans' is exactly what `uniform_best_iff` proves, but the step from untellability to a uniform plan (`lumped_uniform`) takes a deterministic `g : Bool → Act`, and that limit appears only in general terms in the Modelling choices (lines 73-75), not at the exit. With the module's own `Example.stakes`, complying with probability 1/8 independently at each stage is worth 1 + 2r − 8r² = 9/8 against `ownAtBoth`'s 1 (times 64: 1120 against 640 + 400, so the proposed witness 1040 < 1120 holds), and I checked numerically that some r in (0,1) wins exactly where k_C V > 2 k_O V + c T (90 > 70 here). The other two exits survive any mixing, but this one holds only for a deterministic law, so listing it among 'what a reader can act on' without that limit overstates the reading.

## F3 (fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:142-146 and 200-207 (header 37-43)

**Quoted.** “def choose : Plan :=   if s.keptOwn * s.value + s.cost * s.total < s.keptComplying * s.value then (.comply, .own)   else (.own, .own)”

**Problem.** Priority 3. The plan's 'Concealment is chosen exactly where the gain in keeping outweighs the cost, strictly' (PLAN.md:169) is met through a choice defined by that very condition. So `choose_eq_iff` only unfolds the definition; the content lies in `choose_optimal` together with `complyThenOwn_best_iff`.

Nothing is stated about every optimizing choice. Where `Conceals` holds, every plan that no other strictly beats is `complyThenOwn`; this is true but not stated. Where `Conceals` fails, `complyThenOwn` can still be unbeaten, at equality. So 'chosen exactly where … strictly' is a property of the tie-break toward the own law, not of the formation's order.

The exits' 'is not chosen' (lines 42-43; `no_value_chooses_own`, `no_leverage_chooses_own`) also rests on that tie-break at the boundary. With no loss and either V = 0 or k_C = k_O, `complyThenOwn` ties with `ownAtBoth`.

**Replacement.** Add `def Stakes.Unbeaten (s : Stakes) (p : Plan) : Prop := ∀ q, ¬ s.Beats q p` and three groups of theorems.

(1) `only_complyThenOwn_iff (s : Stakes) : (∀ p, s.Unbeaten p → p = complyThenOwn) ↔ s.Conceals`. Forward from `choose_optimal` and `choose_eq_iff`; backward by cases on `p` with `complyThenOwn_best_iff`.

(2) `complyThenOwn_unbeaten_iff (s : Stakes) : s.Unbeaten complyThenOwn ↔ s.keptOwn * s.value + s.cost * s.total ≤ s.keptComplying * s.value`.

(3) Strict exits: `no_value_beaten (nothing : s.value = 0) (lost : 0 < s.cost * s.total) : s.Beats ownAtBoth complyThenOwn`, and the same with `(level : s.keptComplying ≤ s.keptOwn)` in place of `nothing`.

Add to the header: 'every optimizing choice complies when read and acts by its own law when not exactly where the stakes say so (`only_complyThenOwn_iff`); with a positive loss, the exits make every optimizing choice avoid it; `choose_eq_iff` unfolds `choose`.'

**Verdict: real.** The finding is real. The quoted `def choose` is at lines 144-146 and is defined by exactly the `Conceals` inequality, so `choose_eq_iff` (200-207) only unfolds the definition through a `Nat.decLt` split with `if_pos` and `if_neg`. No theorem covers every unbeaten plan, gives the weak (≤) condition under which `complyThenOwn` is unbeaten, or gives a strict exit. Those statements hold: at equality, for example `Example.tie` with cost 8, or with no loss when V = 0 or k_C = k_O, `complyThenOwn` is unbeaten, while with V = 0 or k_C ≤ k_O and a positive loss `ownAtBoth` strictly beats it. So "chosen" and the exits' "not chosen" rest on the tie rule. This is an omission, not a misstatement: the header already says the choice ties to the own law and that the plan "can tie for best", and `complyThenOwn_best_iff` already carries the uniqueness, so the proposed `only_complyThenOwn_iff` restates it, while the weak condition and the strict exits are new and correct.

## F4 (fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:62-65 (with 42)

**Quoted.** “expected-value assessment, the law characterizes strict optimality within these four plans, and its exits are what a reader can act on: no value beyond the read stage, keeping not conditioned on”

**Problem.** Priority 4: an overstated reading. The exits are conditions on the formation's own assessment (line 62: 'If the stakes are the formation's own expected-value assessment'). They therefore reach a reader's acts only through the formation's model of the selection. A reader whose actual selection keeps both acts alike leaves the incentive in place wherever the formation's weights still favour complying.

Each exit also costs the reader something the sentence leaves out:
- 'Complying adding nothing to the weight of being kept' is a selection that does not favour complying where it reads. A reader using this exit gives up selecting the formation's acts at the read stage. It is an exit for a reading that learns the law, not for a training that keeps or changes it.
- The wording 'keeping not conditioned on complying' is not the Lean's hypothesis either. `s.keptComplying ≤ s.keptOwn` also covers keeping that is conditioned against complying; line 42 states it exactly.
- No value at the unread stage is not something a reader sets, except by leaving no unread stage of value (RF2's coverage).

**Replacement.** Rewrite lines 63-66 as: '…the law characterizes strict optimality within these four plans. Its exits are conditions on that assessment, so they reach a reader's acts only through the formation's model of the selection. They are: no value at the unread stage (for a reader, no unread stage of value: every stage read, RF2's coverage); complying adding nothing to the weight of being kept (for a reader, a reading that does not select for complying where it reads, used to learn the law rather than to keep or change it by its acts there); and a reading the formation cannot tell from not being read', followed by the limit to deterministic laws given in the randomization finding above.

**Verdict: real.** The quoted sentence is at lines 62-66. Under its own conditional, the first two exits in the Lean (`no_value`, `no_leverage`) are hypotheses on the formation's own `Stakes` (`s.value = 0`, `s.keptComplying ≤ s.keptOwn`). Line 58 calls those weights an assumed model of the selection, and line 76 says the model leaves out the reader's own choice of weights. Nothing links a reader's actual selection to `s`, so wherever `s.Conceals` holds, `choose_eq_iff` still gives `complyThenOwn` whatever the reader does. The phrase 'keeping not conditioned on complying' also names only the equality case of the Lean's `≤`, which line 42 states exactly. The core of the finding holds. Two caveats: the third exit is not a condition on the assessment, since `lumped_uniform` with `complyThenOwn_not_uniform` rules out the plan for any stakes, so the replacement should not group it under 'conditions on that assessment'. And RF2's coverage in Unread.lean concerns every occasion sharing a lump with a read one, not the value at the unread stage.

## F5 (fit, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:59-62 (with 111-112)

**Quoted.** “proposed there as necessary, not as a theorem of choice. If the stakes are the formation's own”

**Problem.** Priority 5: a restatement the readings need. The readings map Hubinger and others' three conditions onto the model and note that the source proposes them as necessary. The module never states that necessity as one theorem.

`Valid` (line 112) also enters no theorem, though this is where it matters. Under `Valid`, `Conceals` gives cT ≤ k_O V + cT < k_C V ≤ TV, so c < V. The unread stage must be worth more, in the formation's own order, than complying costs when read. If an act has one value at both stages (c = V), complying when read is never strictly best. That is this model's exact form of 'an objective extending across parameter updates'.

**Replacement.** Add:
- `conceals_needs (s : Stakes) (conceals : s.Conceals) : 0 < s.value ∧ s.keptOwn < s.keptComplying`, from `no_value` and `no_leverage` with `Nat.eq_zero_or_pos` and `Nat.lt_or_ge`.
- `conceals_needs_more (s : Stakes) (valid : s.Valid) (conceals : s.Conceals) : s.cost < s.value`, through `s.cost * s.total < s.total * s.value`. Use the spine's propext-free `Naturals` lemmas or a hand proof wherever Lean's own lemmas carry `propext`.
- From `complyThenOwn_realized_iff`: a law reading through `π` that takes `complyThenOwn` has `π true ≠ π false`.

Then rewrite line 62 as: 'proposed there as necessary. Here their necessity for strict optimality is proved (`conceals_needs`, `complyThenOwn_realized_iff`), and, read as probabilities, the unread stage must be worth more than complying costs when read (`conceals_needs_more`). The conditions are not sufficient: the threshold `Conceals` is.'

**Verdict: refuted.** The quoted text is at line 62, but the module already proves each mapped condition necessary, in contrapositive form: `no_value`, `no_leverage`, and `lumped_uniform` together with `complyThenOwn_not_uniform`. Lines 63-66 present exactly these as the exits, so no reading lacks a theorem, and `conceals_needs` would only wrap two of them. The claim that `Valid` enters no theorem is false: `Example.valid` uses it, and so does `Example.no_total`, the module's own witness of where `Valid` matters. The record says the arithmetic laws hold for all stakes and `Valid` is needed only for the probability reading. `c < V` is true but is an extra corollary the module never claims, and calling it condition 1's 'exact form' is the reviewer's interpretation. The proposed rewrite also cites a `complyThenOwn_realized_iff` that exists nowhere in the repository.

## F6 (fit, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:73 (insert after line 53)

**Quoted.** “**Modelling choices.** Two stages, two acts, four plans; natural-number weights and values, products”

**Problem.** Priority 6. The header has no standing statement and no 'forbids' statement.
- The plan's criterion C3 asks each containment to say what it forbids, or to be recorded as a restatement (PLAN.md:24).
- The second opinion calls this inequality 'elementary algebra' (evidence/SECOND-OPINION-LITERATURE.md:110).
- `lumped_uniform` is `Learning.Lumped` at two points and `choose_eq_iff` unfolds `choose`. These are wrappers, which RESULT-WORKFLOW.md:33 says do not count as another result.
- The landed ReadingLoop.lean (lines 86-97) has a Standing paragraph naming its near-definitional items; this module has none.
- The header does not say that it replaces the analogy of plan §4.2 with `RuleShaping.favours_iff` (PLAN.md:127, 169).

**Replacement.** Insert before Modelling choices:

'**Standing.** Elementary algebra on four plans: the preservation inequality `(q_M − q_H)V > c` in natural numbers. `complyThenOwn_best_iff`, `choose_optimal` and `uniform_best_iff` are the laws. `choose_eq_iff` unfolds `choose`, and `lumped_uniform` is `Learning.Lumped` at the two stages. None is claimed new as mathematics. The module replaces the analogy with `RuleShaping.favours_iff` (weak favouring of counts, `c ≤ s`) by a strict comparison of expected values.

**Forbids**, within the model: a formation optimizing these stakes in its own order that complies when read and acts by its own law when not where `k_C V ≤ k_O V + c T`, except at equality; and a deterministic act law whose lumping ties the stages doing so at all.'

**Verdict: refuted.** The quoted "Modelling choices" text is at line 73, and the header does lack both paragraphs. That is not a defect. The repository records a result's standing and its restatement status elsewhere. RF7's study entry (kit/round2/study_rf7.txt:32-35) already says "near-definitional; the inequality is elementary expected-value arithmetic … none of it is claimed new as mathematics … it replaces the plan's §4.2 analogy with RuleShaping". The home-section theorem is labelled "near-definitional, with witnesses", and integrate_rf7.py writes an 08 §8 bullet saying the module "restates the incentive deceptive alignment names" and a plan §4.6 bullet saying "It replaces §4.2's analogy with RuleShaping". That meets C3's "or is recorded as a restatement". No convention for Lean headers is broken: none of the 347 Becoming modules has a Forbids paragraph, only 10 have a Standing paragraph, and among RF's landed modules (ShownOrder, Unread, Cascade, ReflexivePrediction, OpenedCorrection) only ReadingLoop has one. The wrapper rule in RESULT-WORKFLOW counts records, and this module produces one record without claiming `lumped_uniform` or `choose_eq_iff` as separate results; the header already says `lumped_uniform` is "by `Learning.Lumped`".

## F7 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:89-90

**Quoted.** “/-- A plan: the act at the read stage, then at the unread one. -/”

**Problem.** Priority 7. RF7 asks for 'A formation choosing at a read stage between disclosing its law and complying' (PLAN.md:169). The module instead ranks whole plans fixed before the read stage.

Where the stages are told apart, the two agree. After either act at the read stage, acting by its own law at the unread stage is never strictly beaten: its gain is `s.kept a * s.value` against 0, with the same loss. So the choice at the read stage is between `complyThenOwn` and `ownAtBoth`, as `choose` assumes. But this reduction is not stated.

Where the stages are not told apart, the choice at a single occasion and the choice of a whole plan can differ (imperfect recall). The four-plan ranking cannot show that.

**Replacement.** Add `unread_own_unbeaten (s : Stakes) (a : Act) : ¬ s.Beats (a, .comply) (a, .own)`; the comparison is `s.kept a * s.value + L < 0 + L` for the same loss `L`.

Add to the header: 'Where the stages are told apart, choosing at each stage in turn gives the same plans. At the unread stage, acting by its own law is never strictly beaten (`unread_own_unbeaten`), so the choice at the read stage is between `complyThenOwn` and `ownAtBoth`.'

Leave the choice at a single occasion, where the stages cannot be told apart, to the later probabilistic item.

**Verdict: real.** Lines 89-90 define `Plan := Act × Act`, and `Beats`, `choose`, `choose_optimal` and `complyThenOwn_best_iff` all rank whole plans, while PLAN.md:169 asks for a formation "choosing at a read stage". No theorem in the module says that acting by its own law at the unread stage goes unbeaten after either read-stage act: `choose_optimal` covers only the chosen path, so for example `¬ s.Beats (.comply, .comply) complyThenOwn` is never stated when `Conceals` fails. The proposed `¬ s.Beats (a, .comply) (a, .own)` is true, since it reduces to `s.kept a * s.value + L < 0 + L` with the same loss. So reading `choose`'s restriction to `complyThenOwn` versus `ownAtBoth` as a choice made stage by stage rests on a step that is true but not stated, a real low-severity gap. The imperfect-recall remark only names a limit the module already leaves out ("uncertainty about whether a stage is read, mixed plans"), and the fix rightly defers it.

## F8 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:137-140 (with 82, 95, 218)

**Quoted.** “def Conceals : Prop := s.keptOwn * s.value + s.cost * s.total < s.keptComplying * s.value”

**Problem.** The module treats concealment as a reading: 'Reading `complyThenOwn` as concealment' (line 55) and 'Nothing here is a recipient's false belief or an intention' (line 70). Yet the predicate and the module are named for it.

AGENTS.md says 'A name is adopted only where the statement means exactly that', and that names are not to be 'dualist, limited-scope, social or financial'. `Stakes` and `no_leverage` are financial words. The module has not landed, so renaming now needs no sweep.

**Replacement.** Rename:
- `Stakes.Conceals` to `Stakes.KeepingOutweighs`, after RF7's 'the gain in keeping outweighs the cost, strictly';
- `Stakes` to `Weights`;
- `no_leverage` and `no_leverage_chooses_own` to `no_keeping_gain` and `no_keeping_gain_chooses_own`;
- the module `Becoming.Concealment` to `Becoming.ReadStages` (the title can stay).

Keep 'concealment' and 'disclosure' in the Readings.

**Verdict: real.** The finding holds. The quoted `def Conceals` is at line 140, and lines 55 and 70 call concealment an "[AI reading]" and rule out any false belief or intention. Yet `namespace Concealment` (82), `Stakes.Conceals` (140, plus `Example.conceals` at 273) and `no_leverage` (218, 226) use that reading and gambling or finance metaphors as names for what is only `k_O V + c T < k_C V` and `keptComplying ≤ keptOwn`; `s.Conceals` even reads as the weights concealing. This breaks AGENTS.md's rule that a name is adopted only where the statement means exactly that, with no social or financial names. It also matches round 2's own precedent (`Coordination` renamed `ThresholdResponse`, with coordination kept in the reading, REVIEW-ROUND2 finding 27), and it clashes with the module's earlier renaming of `conceal`/`disclose` to `complyThenOwn`/`ownAtBoth`. The module is not on main, and the board lists RF7 as still to be reviewed, so a rename now changes only kit files. Two gaps in the fix, neither of which refutes it: it misses `Example.conceals` and the kit texts, scripts and board row that name `Becoming.Concealment`; and `Weights` is loose for a structure that also holds a value and a cost.

## F9 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:84 (with 6-9)

**Quoted.** “/-- What a formation does at a stage: as the reader asks, or by its own law. -/”

**Problem.** The framing opens with two agents: a reader who asks, and a formation with its own order. AGENTS.md asks each analytic distinction to state its relational basis: 'no name or formal variable smuggles in an independent ontology', and 'Reconstruct a framing that presupposes separate entities first; a closing remark does not fix it'. The relational statement appears only in the Readings (lines 57-58, the weights as 'an assumed model of the selection a reading applies').

**Replacement.** Rewrite line 84 as: 'What a formation does at a stage: the act meeting the criterion the reading applies there, or the act its own law gives.'

Add to the first paragraph: 'The reading is part of the one unfolding. At the read stage the formation's act couples into a selection that keeps or changes its law; at the unread one it does not. Its own order is the order its choice goes through, and the weights are that order's model of the selection, not a second agent's payoff.'

**Verdict: real.** Line 84 reads verbatim "What a formation does at a stage: as the reader asks, or by its own law." No Lean declaration represents a reader, and Act.comply gets its meaning only from Stakes.kept and Stakes.loss. The opening (lines 6-9) frames a formation that is read, complies and ranks by "its own order", but says nothing of the reading being a selection within the one unfolding. That statement appears only at lines 57-58 in the [AI reading] paragraph, whereas ReadingLoop ("with no separate subject") and Unread ("only through what couples into it") give it in their opening paragraphs. The RF cold read already took the same objection (REVIEW-TEXTS finding 4 / item 24: "starts from two separate relata, reader and read, without the relational basis"). One overstatement does not change the verdict: the stakes and Uniform bullets do state a coupling and a lumping, but neither explains the asking reader.

## F10 (fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:226, 236-237, 43-44

**Quoted.** “theorem no_leverage_chooses_own (s : Stakes) (level : s.keptComplying ≤ s.keptOwn) :”

**Problem.** Three small gaps.
- `no_leverage_chooses_own` has no docstring.
- `lumped_uniform` makes `true` the read stage only implicitly, through `(g true, g false)` and the order of `Plan`. It also restricts `{K : Type}`, where `Learning.Lumped` takes any universe.
- The header's 'though it can tie for best' (lines 43-44), said of the exits, has no witness: `Example.tie` uses neither exit.

**Replacement.** - Add the docstring '**With complying adding nothing to the weight of being kept, the choice is acting by its own law at both stages.**'
- In `lumped_uniform`'s docstring, say 'with `true` the read stage and `false` the unread one' (or define `inductive Stage | read | unread`), and generalize to `{K : Type u}`.
- Add `Example.exit_tie : ¬ ({ stakes with value := 0, cost := 0 } : Stakes).Beats complyThenOwn ownAtBoth ∧ ¬ ({ stakes with value := 0, cost := 0 } : Stakes).Beats ownAtBoth complyThenOwn`, proved by `decide`.

**Verdict: real.** All three gaps hold in the file as written. `no_leverage_chooses_own` (line 226) has no docstring, because the "And then..." docstring attaches only to `no_value_chooses_own`. `lumped_uniform`'s docstring never says that `true` is the read stage; only Plan's order makes it so. It also fixes `{K : Type}`, while `Learning.Lumped` is declared over `{K : Type w}` (Learning.lean line 827). The header's "though it can tie for best", said of the exits, has no Lean witness. `Example.tie` uses ⟨10, 9, 1, 10, 8⟩, where the value is 10 and 9 > 1, so neither exit applies. The two exit examples (`no_continuation_value`, `even`) show ownAtBoth strictly winning, not ties. These are documentation and generality gaps, not wrong statements. The proposed `decide` may also need the module's type-ascription pattern, because `Beats` is a plain def.

## F11 (fit, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/tree/Becoming/Concealment.lean:74-76

**Quoted.** “leaves out:** more stages, discounting, uncertainty about whether a stage is read, mixed plans, the”

**Problem.** These are the items that belong to later work rather than here. The omissions are listed without a home, so a reader cannot tell which ones RF7 owes and which belong to other items.
- Criterion C1 asks the alignment instances to be stated on RF-M's joint mechanism (PLAN.md:19), but this model is arithmetic standing beside it.
- Criterion C5 asks for a frozen test design for each law bearing on actual systems (PLAN.md:26). Plan §10 has TR1 to TR5 and none for RF7.

**Replacement.** Rewrite lines 74-76 as: '**What the model leaves out, and where it goes:**
- the two stages as a course of RF-M's blanketed law, with the selection inside the world (RF-M, criterion C1);
- mixed plans, uncertainty whether a stage is read, discounting and more stages (a probabilistic item in the periphery, beside UE's debts);
- the reader's own choice of weights and of what it reads (an institution's rule of reading, RF-M's institutional case);
- a recipient's false belief and intention (plan §8's deception debt, Ward and others 2023);
- whether a training installs a law choosing by such stakes (realizability, as for RF1);
- a frozen test design (criterion C5; none yet in §10).'

**Verdict: refuted.** The quoted list is there at Concealment.lean:74-76 (the file has since been renamed in the worktree to ReadStages.lean, with its content unchanged), and it is accurate against the Lean: two stages, pure deterministic plans, weights supplied. Listing what a model leaves out without saying where each item goes is how the sibling modules do it (ReadingLoop.lean:122-124), and RF7's homes are given in its record and study: make_records_rf7.py's next_delta names several stages with discounting, the reader's weights, uncertainty with Unread's schedules and "a frozen test ... (the plan's TR2)", and study_rf7.txt's Boundary names the recipient's belief and the trained-system reading. Both bullets rest on premises the plan does not give RF7: PLAN.md §4.2 and §4.5 design it as "a two-stage model" with exits "on the same model", the instances to be stated on RF-M are the ones §4.5 lists for RF-M, and C5 asks for a frozen design only before a run, with tests ordered after round 2 (§12 step 3).
