# UE4 review: the second-order direction of 生生 (25 October 2026)

This is an AI-authored independent review of board item UE4 as committed at `92f41c5bf` (the files are unchanged since). It covers two files:

- [DESIGN.md](DESIGN.md), sha256 `26a7cfb7…69b69eee`;
- [tree/Becoming/EventualWidening.lean](tree/Becoming/EventualWidening.lean), sha256 `fadb950c…7ff186e6b`.

They were read with [AGENTS.md](../../../../../../AGENTS.md), [the one page](../../../../../../theories/becoming/ONE-PAGE.md), board rules 8 and 9, [the UE plan](../ue-unified-explanation/PLAN.md), THE-CORE's "What is open", chapters 02, 03, 07 and 08, D1 and D5 of [DELEGATED-CHOICES](../../DELEGATED-CHOICES.md), [PRACTICAL-JUDGMENT](../../../../../../theories/becoming/history/PRACTICAL-JUDGMENT.md), the treatise [生生不息论](../../../../../../sources/06-zhishan/shengsheng/生生不息论v1/生生不息论.md), and the package modules `Admission`, `Regions`, `ContinuedClasses`, `Gain`, `Novelty`, `Recurrence`, `Weightings`, `Horizon`, `Verification`, `Persistence` and `Grammar`.

**How it was checked.**

- **Rebuild.** The kit tree was rebuilt with `scratch_build.py`: 59 theorems in 80 declarations, every axiom report empty, as the note says (every step reused from the shared cache).
- **Probe.** Variants were built in a new scratch tree (`ue4-review2`): a module importing the kit, `Weightings` and `Verification`, 27 theorems in 36 declarations, every axiom report empty. Its text is in the [appendix](#appendix-the-probe-module), since the scratch folder is volatile. P1–P8 below refer to its sections.
- **Names and links.** Every Lean name the note cites exists in the core, the kit or the periphery, except those marked proposed. Every relative link and anchor resolves. The five treatise quotations are verbatim.
- **Sources read this round, through a fetching tool:** the assembly theory paper's full text at PMC (PMC10567559), and the arXiv abstracts of 2204.14115 (TAP) and 2406.12176 (Kempes and others). The other literature was checked from prior knowledge only.

## Verdict

The Lean is sound and constructive: every statement matches its docstring, and the witnesses prove what they are said to. Eventual widening is a premise-free strict partial order that never reverses widening. The probe shows it is exactly widening of every late tail (P1), so it is the long-run form of widening that F2 asks for. Keeping widening is rightly a property, not monotone in widening. `OpeningChain.carried` exactly shows that what carries a range is invisible to widening. C∞ is correctly identified as a premise beyond C, and neither the note nor the module asserts it. D5 is respected: the note concludes that the direction cannot simply be "keeps widening".

The prose says more than the kit in five places:

- Eventual widening is called "the comparison THE-CORE asks for", though it needs no growth, is silent where a course keeping everything lags another by one step (P8), and is first-order widening read on tails.
- `KeepsWidening.eventually_widens` assumes half its conclusion; its "nothing lost" hypothesis is idle (P2b).
- Proposed laws and witnesses are stated as established, and `Flow.support_passes_on` is said to "force" what it gives only as a double negation at some late steps.
- `Flow.OpenedByOpened` holds vacuously wherever nothing gains support, a dead whole included (P6b), yet it is read as "generation generating generation", D1's own reading of 生生.
- 07 §9's objection is said not to reach keeping widening.

C∞'s cost is not stated exactly:

- Its verdicts are dense, so a practice can keep them against every finite record (P7, 03 §5).
- It is the "unlimited continuation priority" rival that the practical judgment already names and basic-condition priority rejects.
- The characterization of C is silent on it because a course whose admissions are listed eventually widens nothing (P3), not because it lies outside the class.

Every law of the kit is near-definitional, which the note does not say. Board rule 9 is met only loosely: the order laws are a second proof beside widening's (P1 derives them), and the splice laws are density statements of 03's frame, proved beside it (P7).

**Recommendation: revise** (details at the end). After the revision, land eventual widening and the carrier witness as a near-definitional record in 07 §2. Keep C's laws, candidate B and the bridges as design. If UE4 is to land only with a result no neighbouring field states, which is the UE plan's purpose for it, hold it until the gain bridge or the givers law is proved.

**Counts:** 3 errors, 6 overclaims, 15 imprecisions, 5 suggestions.

## Findings

Each finding gives its severity, location, what is wrong and the fix. Suggested wording may be taken as written or in words that say the same.

### A. Statements against the Lean (checklist 1)

**1. "Over any first stretch."** *Error.*
- **Location.** Module docstring, first paragraph (lines 9–11): "A course wider over the first steps and a course that keeps opening later are then mixed, and over any first stretch the first widens the second."
- **What is wrong.** This is false for a first stretch that reaches the step where the later course first exceeds. In `OwnCondition`, up to step 1 the burst and the rising course are mixed: the burst admits formation 1 at step 0, the rising course at step 1.
- **Fix.** "…are then mixed, and over a first stretch that ends before the later course first admits something the first does not, the first widens the second (`OwnCondition.burst_widens_now`)."

**2. "None that widening decides."** *Error.*
- **Location.** DESIGN §3.1, "Relation to `Web.Widens`", fourth bullet: "It decides some pairs widening leaves mixed (F1) and none that widening decides."
- **What is wrong.** `full` widens `rising` and also eventually widens it (P5, `OwnCondition.full_eventually_widens_rising`). In general, widening without end is both (`WidensWithoutEnd.eventually`).
- **Fix.** "It orders some pairs that widening leaves mixed (F1), and reverses none that widening orders (`Widens.not_eventually_reversed`, `EventuallyWidens.not_included`). Where widening orders a pair, eventual widening agrees (widening without end) or is silent (the wider course exceeds only over a first stretch)."

**3. `KeepsWidening.eventually_widens` assumes half its conclusion.** *Overclaim.*
- **Location.**
  - The module bullet "Keeping widening outlasts a range that settles" and the theorem's docstring (line 344).
  - DESIGN "In short": "A course that keeps widening eventually widens every course that settles within its range."
  - DESIGN §3.1, First laws: "This is THE-CORE's comparison as a law".
- **What is wrong.**
  - The inclusion half of the conclusion is a hypothesis (`includes : W.IncludesFrom T₁ l l'`).
  - The proof uses only `keeps.2`. The same statement holds of any course that keeps opening, even one that loses what it admitted (P2b, `KeepsOpening.eventually_widens`), so "nothing lost" is idle.
  - A range that settles goes on, so it is not "outlasted".
- **Fix.**
  - Add P2, which derives the inclusion through `HoldsFrom`: `KeepsWidening.eventually_widens_of_within : W.KeepsWidening itself l T → W.SettlesFrom l' T₂ → T ≤ S → (∀ f, W.Admits (l' T₂) T₂ f → W.Admits (l S) S f) → W.EventuallyWidens l l'`.
  - State the present law under `KeepsOpening`, as a lemma of P2.
  - Retitle it "Keeping widening eventually widens a range that settles on what it admits at some step".
  - DESIGN: "…eventually widens every course that settles on what it admits at some step from `T` (P2). This is THE-CORE's pair in the case where the range merely wider now settles [AI reading]."

**4. `Flow.OpenedByOpened` is vacuous where nothing gains support.** *Imprecision.*
- **Location.**
  - Kit, `Flow.OpenedByOpened` (line 385).
  - DESIGN §3.3, Statement, and "Witnesses (proposed)": "A closed pair … is opened by the opened and keeps the range the same."
- **What is wrong.**
  - The definition quantifies over gains of support, so it holds of every flow on a web where nothing gains support after `T`. Every flow on `OwnCondition.web`, where nothing is ever supported, is opened by the opened from every step (P6b).
  - The end of degeneration (once nothing is supported, nothing is again, `Flow.nothing_supported_stays`) and a saturated whole both qualify.
  - The closed pair keeps the range the same with no gains, so it is this vacuous case and says nothing about C's content.
- **Fix.**
  - Add the recurrence clause that `Flow.support_passes_on` already carries: `(∀ N, ∃ t f, N ≤ t ∧ W.GainsSupport t f) ∧ ∀ t f, T < t → …`. The relay still meets it, with a gain at every step.
  - Restate the closed pair as the vacuous case. Or replace it by a closed cycle passing one unit around (as in `Recycle`), each gain given by the member that gained the step before. Such a cycle would be opened by the opened with a gain at every step, its range kept along the passing continuation: 不息 without 生生不息, non-vacuously (a witness to build).

**5. `Flow.OpenedByOpened` is not aligned with the account's gain laws.** *Imprecision.*
- **Location.** Kit line 386, `W.requires (t + 1) f c`. DESIGN §3.3: "The growth of what can form is then carried by what came to be able to form."
- **What is wrong.**
  - `Flow.gains_from_supported` and `Flow.support_passes_on` read the requirement before the step (`W.requires t f c`), so the "uniform form of `Flow.support_passes_on` with the same proof" (§3.3) would conclude the definition only after converting the requirement through the premise that requirements do not loosen.
  - The definition asks only for gross positive giving to some required condition, not to one that rose. So "carried by" says more than the definition.
  - The route of `gains_from_supported` already yields a required condition that rises (`GainsSupport.rises`) and a supported giver to it (`rise_given_by_supported_at`).
- **Fix.** Read `W.requires t f c ∧ W.Rises t c` (P6, `Flow.OpenedByOpenedRising`, which the relay meets). In the prose, write "every gain is given, on a required condition that rises across the step, by …".

**6. "No first stretch verifies or refutes it."** *Imprecision.*
- **Location.** Module bullet "No first stretch decides it" (lines 30–33); DESIGN F3; DESIGN §5's table.
- **What is wrong.**
  - **(a)** The laws vary the prefix of the first course only; the second is fixed and known in full.
  - **(b)** "Refutes" holds only where some course eventually widens `l'` (the hypothesis of `eventually_of_splice`); the summary drops it.
  - **(c)** F3 extends the claim to keeping widening, and that half is wrong. From a given step, a loss within a finite stretch refutes keeping widening by name, because `HoldsFrom` is refuted by a finite stretch. Only its verification is out of reach (`KeepsOpening` has recurrence's shape).
  - **(d)** The note leaves out where this sits in 03. Eventual inclusion has the form 03 calls verified in the limit, a union of closed readings. Exceeding at arbitrarily late steps has the form refuted in the limit, a meet of open ones. Their meet has neither form in general, and 03 gives no method for it.
- **Fix.**
  - State the laws in 03's frame (finding 26): "Where some course eventually widens `l'`, eventually widening `l'` and its complement are both dense among the sequences of levels (`eventually_dense`, `not_eventually_dense`), so the reading is neither verifiable nor refutable (`neither`)."
  - Amend F3 with (c) and (d).

**7. F4 and the gain bridge.** *Imprecision.*
- **Location.** DESIGN F4; §3.1, the gain bridge.
- **What is wrong.**
  - **(a) The citation.** "Formations first supported without end make the family pass every bound (`Web.rises_late_of_newly_supported`, `Flow.newly_supported_from_rest_or_open`)": these give rises, and net gifts from beyond, at arbitrarily late steps. Passing every bound is `Web.exceeds_of_firsts` with `Web.newAt_of_first`.
  - **(b) The escape.** "The witnesses below escape this way, each formation having a condition of its own": they escape the bound on one fixed finite family, not gain. The rising levels total `t + 1` at step `t`, and in `OpeningChain` each unit is given from nothing.
  - **(c) The calibration.** §3.1 says "This is a calibration point, not a gap. A proof through finite lists avoids both." The bridge is unproved, so it is a gap. If the list proof works, no calibration arises; if it needs a choice, that need is a lemma of the bridge (AGENTS, proof and naming).
- **Fix.**
  - Cite `Web.exceeds_of_firsts`.
  - Add: "the escape is from the bound on a fixed finite family; the total of the levels still grows without bound".
  - Replace (c) with: "The bridge is unproved. A proof through finite lists of formations would need neither a choice of witnesses nor decided support; should it need one, that need is a lemma of the bridge."

**8. "Under named premises it is forced."** *Overclaim.*
- **Location.** DESIGN "In short": "Under named premises it is forced: support that passes on is already the account's law (`Flow.support_passes_on`)." §1, the entry *Support passes on*.
- **What is wrong.**
  - **What the law gives.** Under balance, only active giving, activity needing support, requirements never loosening, brief support and gains recurring, it cannot be refuted (a double negation) that at some step from any `N` a gain is given by a newer gainer. That is not that every gain is so given, which is C.
  - **What its docstring says.** "A chain of support is not yet 生生, which asks a direction as well."
  - **The §1 entry.** It omits balance, active giving, dependence and unloosened requirements.
- **Fix.** "Under named premises (balance, only active giving, activity needing support, requirements never loosening, brief support, gains recurring), it cannot be refuted that at arbitrarily late steps some gain is given by a formation that gained support after any given step (`Flow.support_passes_on`, a double negation). Its uniform form, every late gain, is proposed (§3.3). A chain of support is not yet 生生 (the law's docstring)."

**9. Proposed laws and witnesses stated as established.** *Overclaim.*
- **Location.**
  - §3.4: "The laws join them: A's keeping widening with upkeep forces C's givers to multiply, brevity forces C's chain, and B says the possible grows only within a horizon".
  - F2: "The same holds for capacity (candidate B's witness)".
  - §3.2: "The exhaustion witness shows".
  - F4: "In bounded amounts, then, widening without end needs…", which rests on the proposed bridge.
- **What is wrong.** All four are proposed in §3.2 and §3.3; none is proved.
- **Fix.**
  - §3.4: "Proposed laws would join them: …".
  - F2: "(candidate B's proposed witness) would show".
  - §3.2: "would show".
  - F4: "With the proposed bridge, in bounded amounts…".

### B. The formalization (checklist 2)

**10. "It is the comparison THE-CORE asks for."** *Overclaim.*
- **Location.** DESIGN §5, reason 1; the opening of "In short".
- **What is wrong.**
  - Eventual widening needs no growth: a steady course eventually widens a collapsing one, and `full` eventually widens `rising` (P5).
  - It is silent where a course keeping widening lags another by one step (finding 12).
  - THE-CORE's pair, a range keeping widening against one merely wider now, is reached only through `KeepsWidening.eventually_widens` (finding 3).
- **Fix.** "Eventual widening is the long-run comparison: widening of every late tail (P1). THE-CORE's pair is the case where a course keeping widening meets a range that settles on what it admits at some step (P2) [AI reading]."

**11. What is second order.** *Imprecision.*
- **Location.** The title and §0; §3.4's first row; §5.
- **What is wrong.**
  - **A is first order.** Candidate A is first-order widening read on late tails (P1), plus sustained widening (`KeepsWidening`: nothing lost, something new after every step). Neither compares the widening itself, which is how "a range whose widening keeps widening" reads when the openings widen, as in the adjacent possible and TAP's acceleration.
  - **The second-order content is elsewhere.** What opens was opened, and the capacity to form, are C and B, which have no laws yet.
  - **A rate reading is missing.** Eventual widening of what each course newly admits across stretches is not considered.
- **Fix.**
  - §0 and §5: "Candidate A formalizes the long run and sustained widening, not growth of the widening itself; the second-order content is C's and B's."
  - Name the rate reading as a deferred candidate. It reads 生生不息 as growth, which D5 excludes, and it needs more gain than A.

**12. A lag defeats eventual widening.** *Imprecision.*
- **Location.** DESIGN §5, "What would show the definition wrong", *Too narrow*.
- **What is wrong.** P8 (`LagWitness`) gives two courses that eventual widening cannot compare:
  - `lagging` keeps widening by name;
  - it admits, from the step after and at every later step, every formation `travelling` admits (`kept_later`);
  - yet neither eventually widens the other (`not_eventually_lagging`, `not_eventually_travelling`).

  One-step novelties against a course that keeps each of them forever are mixed in every tail. The note's "too narrow" covers only growth "in other directions"; here the keeping course does come to include each formation, one step late.
- **Fix.** Add: "*Too narrow (2): a lag.* A course keeping widening that admits every formation of another from one step later, forever, is mixed with it in every tail (witness). A comparison made formation by formation (what each admits from some step on, and at arbitrarily late steps) would order them, at the cost of no longer being widening on tails. Per-step inclusion is chosen because eventual widening is then widening of every late tail (P1)."

**13. Keeping widening along a supplied continuation.** *Imprecision.*
- **Location.**
  - The module readings: "keeping widening is 'a range whose widening keeps widening'".
  - DESIGN §3.1, Premises: "a continuation `R`, supplied or read by name; naming is a commitment".
- **What is wrong.**
  - P4 (`MergedWitness`): over the listed type `Bool`, along the continuation in which every formation continues as `false`, a course admitting the same at every step keeps widening (`keeps_widening_along_merge`). By name it does not (`not_keeps_widening_by_name`).
  - Along a supplied continuation, keeping widening counts re-formation as opening, the converse of `Bud.readings`.
  - The kit's `not_listed` is rightly "by name", but neither the module readings nor §3.1's premises say this.
- **Fix.** After the `not_listed` bullet: "Along a supplied continuation it can hold of a course that admits the same at every step, where a formation re-formed at each step continues nothing (witness): read along `R`, keeping widening counts re-formation as opening." Add the same to §3.1's premises.

**14. "A property but not an order."** *Imprecision.*
- **Location.**
  - DESIGN "In short": "Keeping widening is not kept by widening, so it can be a property but not an order." This contradicts F2's last sentence ("or it is ranked after widening by a named premise").
  - The module readings: "calling any of them better is a premise beyond C".
- **What is wrong.**
  - **What is shown.** No wholesale ranking by keeping widening agrees with widening (`not_monotone`).
  - **What stays open.** After widening, keeping widening can still order pairs that widening leaves unranked.
  - **Against C, not beyond it.** For keeping widening, and for opened by the opened, "calling it better" runs against C wholesale (`not_monotone`; the note's tumour line), so either could enter only after C.
- **Fix.**
  - "In short": "Keeping widening is not kept by widening: no order ranking by it wholesale agrees with widening, and it can order only pairs widening leaves unranked, after widening, by a named premise."
  - Module readings: "None ranks. Calling eventual widening better is a premise beyond C (C∞); ranking by keeping widening or by opened by the opened runs against widening wholesale, so either could enter only after C, by a named premise."

**15. Standing.** *Imprecision.*
- **Location.** DESIGN §3.1, *Standing*; §5, reasons 3–4; the module docstring.
- **What is wrong.** The note omits the known-results standing that [08 §8](../../../../../../theories/becoming/chapters/08-METHOD.md#known-results) asks for. Every law of the kit is near-definitional:
  - irreflexivity and transitivity are widening's on late tails (P1);
  - the splice laws are the density of a tail reading in the topology of runs (03 §5; liveness in Alpern and Schneider's sense);
  - `not_listed` is the pigeonhole (`length_le_of_sub`);
  - `eventually_widens` uses its hypotheses directly (finding 3).

  The UE plan names UE4 among the candidates for "results no neighbouring field states" (§3), and nothing in the kit is yet such a result.
- **Fix.** "*Standing:* near-definitional. Eventual widening is widening on late tails; the splice laws are density in 03's frame; `not_listed` is the pigeonhole. The first candidates for a result no neighbouring field states are the gain bridge and the givers law."

### C. C∞ (checklist 3)

C∞ is rightly beyond C. C ranks a course above every course it widens and leaves mixed pairs unranked, while C∞ ranks some mixed pairs. Neither the note nor the module asserts it, and nothing in DESIGN ranks implicitly, apart from the wording in finding 19.

**16. Where C∞ stands relative to C.** *Imprecision.*
- **Location.** DESIGN §3.1, Premises: "It lies outside the orders C is characterized by (`Weighting.widens_iff_every_of_class`), since finite listings see no tail."
- **What is wrong.** Three points make it exact:
  - **(a)** `Web.widens_iff_every_of_class` needs both courses' admissions listed (`ListsAdmitted`), and a course whose admissions are listed eventually widens nothing (P3, `not_eventually_of_listed`). So the characterization is silent on eventual widening.
  - **(b)** On courses that are not listed, `WidensOrEventually` ranks each widening higher, so it is itself an order of the class's kind: a priority of the long run.
  - **(c)** By P1, C read on the frame of late tails (a new reading, as §1 says) ranks every late tail of the eventually wider course above the other's. C∞ is the further step from tails to whole courses.

  So C∞ is a premise of the same kind as the priorities that decide what C leaves mixed ([07 §4.4](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-graded-significance-and-priority): lexical priority, `Weighting.prior_transfer`), consistent with C. It is not outside the class.
- **Fix.** Replace the sentence with (a)–(c), and add P3 to the kit, which joins the module to `Weightings`.

**17. C∞'s cost.** *Imprecision.*
- **Location.** DESIGN §3.1, Premises: "Its cost is exact. It overrides every finite stretch, lexically: the inclusion form of an overtaking criterion with no discount (von Weizsäcker 1965; Gale 1967)." The module readings repeat "the inclusion form of an overtaking criterion".
- **What is wrong.** Four things are missing or inexact:
  - **(a) The epistemic cost.** By P7 the verdicts are dense and co-dense, so a practice fixed by the record can keep "better under C∞" against every finite record (`insulated`, by 03's `insulates_iff_dense`). That is the insulation 03's assessment of scientific standing flags, and only a law of the courses checks it (F3).
  - **(b) The account already names this rival.** [PRACTICAL-JUDGMENT §7](../../../../../../theories/becoming/history/PRACTICAL-JUDGMENT.md#7-有内容的反对及边界--substantive-rivals-and-limits), "Unlimited continuation priority": a rival "giving recurrence priority over every finite sacrifice", which basic-condition priority "explicitly rejects … for optional continuation".
  - **(c) Overtaking is a different comparison.** Overtaking compares partial sums, so an early loss must be made up; eventual widening ignores every finite stretch outright. Counting finitely many admissions at each step, eventual widening entails overtaking, not conversely.
  - **(d) The neighbour that names this pole.** A "dictatorship of the future" (Chichilnisky 1996, *Social Choice and Welfare* 13), excluded by axioms of sustainable preference.
- **Fix.** Add (a)–(d) to §3.1's Premises. Module readings: "a tail comparison in inclusion form; unlike overtaking, which sums, it ignores every finite stretch".

**18. The J1 example.** *Imprecision.*
- **Location.** DESIGN §3.1, Premises: "It must be ordered against J1: a course that loses basic conditions over a long first stretch and gains one formation forever would rank above one that keeps them, unless J1 comes first."
- **What is wrong.**
  - **Right in substance, not exact.** C∞ ranks `l` above `l'` only where `l` includes `l'` from some step on, so lasting losses (formations `l'` admits at arbitrarily late steps and `l` does not) block it. What C∞ discounts to nothing is every loss confined to a finite stretch, however long and however basic, against one formation more at arbitrarily late steps. `eventually_of_vanishing` is the extreme case.
  - **The label.** 07's list of further premises names the priority of basic conditions J2 (J1 there is complete comparison with retained losses), while 07 §5 and 08's open item 11 label it J1.
- **Fix.** "C∞ discounts every loss confined to a finite stretch. A course that loses basic conditions over a long first stretch, regains them, and admits one formation more at arbitrarily late steps eventually widens a course that keeps them throughout, so C∞ would rank it higher, unless the priority of basic conditions comes first. That priority already rejects unlimited continuation priority (finding 17b)." Name the commitment by its content, not its label.

**19. "Decide", "order", "favour".** *Imprecision.*
- **Location.**
  - "In short": "whatever decides it is a premise".
  - F1: "whatever decides it orders a mixed pair, which is a premise" and "it favours the course merely wider now".
  - §3.1: "It decides some pairs…".
- **What is wrong.**
  - **The account's vocabulary.** Widening orders with no premise; C ranks as better.
  - **The contradiction.** As written, F1 makes eventual widening, which orders a mixed pair with no premise, into a premise.
  - **"Favours".** It reads as a ranking.
- **Fix.**
  - F1: "whatever ranks one of them better orders a mixed pair as better, which is a premise (D1); eventual widening orders the pair as a comparison and ranks nothing".
  - "favours the course merely wider now" → "orders the course merely wider now above".
  - Use "orders" or "separates" for comparisons throughout.

### D. Readings toward 生生 (checklist 4)

**20. Opened by the opened read as "generation generating generation".** *Overclaim.*
- **Location.**
  - The module readings (lines 72–73): "opened by the opened is 'generation generating generation' read on support".
  - DESIGN "In short": "The mechanism the account's reading of 生生 names, generation generating generation, is invisible to widening". Unlabelled.
  - §1: "This is generation generating generation read on support". Unlabelled.
- **What is wrong.**
  - D1's revision reads 生生 itself as generation generating generation, so the identification makes C into 生生 read on support.
  - `Flow.support_passes_on`'s docstring denies that ("a chain of support is not yet 生生"), and so does the note's own §3.3 ("C alone is not the direction").
- **Fix.** "Opened by the opened reads, on support, one face of what D1 reads as generation generating generation: the generators of further forming. Like a chain of support it is not 生生, which asks a direction as well [AI reading]." Label the §1 and "In short" sentences.

**21. 07 §9's objection.** *Overclaim.*
- **Location.** DESIGN §3.1, "Relation to novelty and gain": "So it is not mere novelty, and 07 §9's objection does not reach it."
- **What is wrong.** [07 §9](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#objections) answers the objection two ways:
  - generation is carrying renewal and 生生 life in the whole, "not novelty or scale";
  - an expansion that ends forms of life another course keeps is mixed with that course.

  Keeping widening by name needs formations without end (F4), which is scale. As a property of one course, it holds of a course that another course widens (`not_monotone`). What it excludes is only closing along its own course.
- **Fix.** "Keeping widening closes nothing along its own course, by construction. It is not thereby generative: by name it needs formations without end, which 07 §9 answers (generation is carrying renewal, not novelty or scale), and another course can widen it (`not_monotone`)."

**22. The treatise's tests.** *Error.*
- **Location.** DESIGN §3.4: "Read with the treatise's tests of 不息 [AI reading]: … 「使新的生成者仍能出现」, that new generators can still appear, is C." The table row "returning capacity | A's `Web.HoldsFrom`".
- **What is wrong.**
  - **The attribution.** 「使新的生成者仍能出现」 is not one of the five tests of 不息 (treatise lines 97–103: 不耗尽自身赖以存在的条件; 不把其他存在者彻底降为工具; 能吸收反馈，修正错误; 能在变化中恢复和更新; 能把可继续生成的世界交给后来者). It comes from the account of 生生 after the triple (line 81).
  - **Modality.** The phrase is modal ("can still appear"), closer to B's kept capacity than to C.
  - **Returning capacity.** Test 4 (recovering and renewing in change) is returning capacity, which the table reads as `HoldsFrom`. But `HoldsFrom` excludes loss rather than measuring recovery: a course that loses and recovers fails it.
- **Fix.**
  - "「使新的生成者仍能出现」 (from the treatise's account of 生生, not its tests of 不息), modal, is closest to B's kept capacity".
  - Returning capacity row: "not read by A; `Web.HoldsFrom` excludes loss; recovery (test 4) needs 02's return grades (`Web.consumed_iff`)".
  - Say that tests 2–4 are not read by any candidate.

**23. The map law "to widening".** *Imprecision.*
- **Location.** DESIGN §3.3, "Relation to the map's generation": "That would be the first law relating the map's generation to widening, through local openings."
- **What is wrong.** An opening is a gain of support. A chain of gains can close as well as open, so the proposed law relates 全生成 to gains of support, and reaches widening only where nothing admitted is lost.
- **Fix.** "…the first law relating the map's generation to gains of support, and, with nothing admitted lost (`Web.HoldsFrom`), to widening ([02, open](../../../../../../theories/becoming/chapters/02-MAP.md#open))."

The other readings are labelled. D1 and D5 are cited correctly. No dualist word occurs: "better" appears only inside premise statements. On names, see finding 29.

### E. Neighbours (checklist 5)

**24. The column "what the account forbids that it leaves open".** *Imprecision.*
- **Location.** DESIGN §4, the table.
- **What is wrong.** Several entries are not left open by the neighbour, and the UE0 audit found that forbidden statements in this area are known in a neighbouring field.
  - **(a) The adjacent possible.**
    - Kauffman holds that the adjacent possible cannot be prestated, so "within one fixed process, the possible over every horizon growing along a course" is not his claim.
    - "'Cannot be stated in advance' as growth beyond `F` (`Web.WidensAlong`)" misplaces unprestatability: `WidensAlong` compares along a supplied reading of one given type in another. The account's form of that gap is self-changing conditions (UE plan §5).
  - **(b) RAF sets.** They are reflexively autocatalytic and food-generated (Hordijk and Steel 2004): every reactant is produced from a food set by reactions of the set. The row's "each of whose reactions is catalysed from within" omits the food set, which is F4's gain from beyond. "A closed autocatalytic set widening" is not RAF theory's claim.
  - **(c) Open-endedness.** Adams and others define unbounded evolution relative to the recurrence time of an isolated system, so the row's forbidden statement is already theirs.
  - **(d) Option value.** That options only narrow within one fixed process is Arrow–Fisher's and Henry's irreversibility premise.
  - **(e) TAP, missing.** The TAP equation carries extinction, and the paper studies the balance of innovation and extinction. So a rising count of types is not widening: 07 §9's mixed case, a contrast worth stating.
- **Verified.**
  - Assembly theory's assembly equation, the discovery law with α (α = 1 "historical dependence without selection", α < 1 selection) and the timescale regime (selection where τ_d ≈ τ_p) match the published text.
  - TAP's authors, arXiv number and plateau-then-blow-up are right, and so is Kempes and others' arXiv 2406.12176.
  - The critiques of assembly theory are acknowledged.
- **Fix.**
  - Mark each forbidden entry as known (in the neighbour or a neighbouring field) or not yet checked, and count none as a third part.
  - Correct (a) and (b); add (e).

### F. Board rule 9 and names (checklist 6)

No law of the kit duplicates an existing one. `unlisted_of_new` would need a sequence of witnesses, so the finite-list route of `gathers` is the constructive one. Three placements still fall short of "below, not beside".

**25. Derive eventual widening from widening.** *Suggestion.*
- **What the probe shows.** P1 introduces `Web.from_ W S`, the web from step `S`. The package has `World.after`, but a search found no shift of a `Web`. With it and `tailFrom S l`:
  - `eventuallyWidens_iff_tails : W.EventuallyWidens l l' ↔ ∃ T, ∀ S, T ≤ S → (W.from_ S).Widens (tailFrom S l) (tailFrom S l')`;
  - irreflexivity and transitivity then follow from `Widens.not_reverse` and `Widens.trans` (`irrefl_of_tails`, `trans_of_tails`).
- **What to do.**
  - Define eventual widening this way, or derive the order laws from the iff.
  - The module then rests on 08 §7's master law of order instead of proving a second strict partial order beside widening's, and "widening of every late tail" is F2's "long-run form of widening" exactly.
  - Name the shifted web as `World.after` names the world (`Web.after`).

**26. State the splice laws in 03's frame.** *Suggestion.*
- **What the probe shows.** P7 states them as `eventually_dense`, `not_eventually_dense`, `neither` and `insulated`, by `not_verifiable_of_adheres`, `not_refutable_of_adheres` and `insulates_iff_dense` on `Sequences.process (C → Nat)`.
- **What this gives.** The splice laws then stand as the instance of 03's general law they are, and the insulation consequence for C∞ (finding 17a) is a theorem.

**27. The leaf.** *Suggestion.*
- **What is wrong.** Nothing imports the module, and its laws are general rather than an instance, a tool or a model. Rule 9 therefore needs the row to say why it is a leaf.
- **Options.**
  - Put eventual widening, in its tail form, in or just above `Becoming.Regions` beside `Web.Widens`, and keeping widening above `ContinuedClasses`.
  - Or say "a leaf until the gain bridge imports it".
- **On landing.** Register the apart roots in the connectivity run, as UE1 did. Finding 25 removes some of them.

**28. C and the root's `«生生»`.** *Suggestion.*
- **The relation.** The grammar's `«生生»` (renewal without end: every member conditions a beginning whose line goes on to another member) is the root's form of generation generating generation. `Flow.OpenedByOpened` reads like its backward form on the World: every gain conditioned by an earlier gainer, with 缘 read as giving to a required condition.
- **What to do.** AGENTS asks that new results be stated on the grammar where possible. State the relation as an instance or a correspondence, at a relation and pair of classes chosen so that it holds, or say why C is stated on the World only. The DESIGN's proposed map law (§3.3) is the nearest such statement.

**29. Names.** *Suggestion.*
- **`OpeningChain.sun`.** A metaphor: a sun is an inflow from beyond (`Restoring.Inflow`'s structure), and this is a formation giving from nothing. Rename it `oneGiver` (its docstring's words), with `flow` → `relay` and `sun_not_opened` → `oneGiver_not_opened`.
- **`Web.HoldsFrom`.** It reads like `Web.Holds` (`Becoming.Persistence`: a formation holds where it is active or depending), in another sense. Rename it `Web.LosesNothingFrom` or `Web.IncludesAcrossFrom`.
- **`Web.SettlesFrom`.** It means admissions constant, beside 03's settling (the state stops changing, `Becoming.Settles`). Rename it `Web.AdmitsAlikeFrom`.
- **"Outlasts".** See finding 3.

## Recommendation

**Revise**, then land what is ready.

1. **The Lean.**
   - Fix the docstrings (findings 1, 3, 6, 13, 14, 17, 20).
   - Derive eventual widening on tails (25).
   - State the splice laws in 03's frame (26).
   - Add P2 and P3, and state the present `eventually_widens` under `KeepsOpening`.
   - Add the recurrence clause to `Flow.OpenedByOpened`, read the requirement before the step with a rising condition (4, 5), and rename (29).
   - Optionally add the lag and merging witnesses (12, 13).
2. **DESIGN.** Correct the errors and overclaims (2, 8, 9, 10, 19, 21, 22) and the C∞ section (16–18). Add the standing (15), the second-order caveat (11) and the neighbours' corrections (24).
3. **Land** eventual widening (tail form, 03's frame, P2, P3) and the carrier witness as one record with its home in 07 §2, beside widening along a reading. Its standing is near-definitional. It states what widening can and cannot say of the long run and of carriers, and names C∞ as the premise it is. 02's open item, a law relating 生成 to widening, stays open.
4. **Keep as design** C's laws (brevity, givers), candidate B, the map law and the gain bridge. Each is claimed and reviewed on its own. The gain bridge or the givers law is the first candidate for a result no neighbouring field states.

## Appendix: the probe module

`Becoming/UE4ReviewProbes.lean`, built with `scratch_build.py` against the kit (copied unchanged): 27 theorems in 36 declarations, every axiom report empty. It is a review probe, not proposed for landing as written.

```lean
import Becoming.EventualWidening
import Becoming.Weightings
import Becoming.Verification

/-! Review probes for UE4 (scratch only, not for landing). -/

namespace Becoming

open Generative

namespace Web

variable {F C : Type}

/-! ## P1. Eventual widening is widening of every late tail -/

/-- The web from step `S` on. -/
def from_ (W : Web F C) (S : Nat) : Web F C :=
  ⟨fun t => W.level (S + t), fun t => W.active (S + t), fun t => W.requires (S + t),
   fun t => W.need (S + t), fun t => W.draws (S + t)⟩

/-- A level path from step `S` on. -/
def tailFrom (S : Nat) (l : Nat → C → Nat) : Nat → C → Nat := fun t => l (S + t)

variable {W : Web F C} {l l' l'' : Nat → C → Nat}

theorem eventuallyWidens_iff_tails :
    W.EventuallyWidens l l' ↔
      ∃ T, ∀ S, T ≤ S → (W.from_ S).Widens (tailFrom S l) (tailFrom S l') :=
  ⟨fun ⟨⟨T, inc⟩, late⟩ => ⟨T, fun S le =>
     ⟨fun t f admitted => inc (S + t) f (Nat.le_trans le (Nat.le_add_right S t)) admitted,
      match late S with
      | ⟨_, f, from_, admitted, not⟩ => match exists_steps_between from_ with
        | ⟨k, apart⟩ =>
          ⟨k, f, Eq.subst (motive := fun x => W.Admits (l x) x f) apart admitted,
           fun back => not (Eq.subst (motive := fun x => W.Admits (l' x) x f) apart.symm back)⟩⟩⟩,
   fun ⟨T, tails⟩ =>
     ⟨⟨T, fun _ f from_ admitted => match exists_steps_between from_ with
        | ⟨k, apart⟩ =>
          Eq.subst (motive := fun x => W.Admits (l x) x f) apart.symm
            ((tails T (Nat.le_refl T)).1 k f
              (Eq.subst (motive := fun x => W.Admits (l' x) x f) apart admitted))⟩,
      fun S₀ => match (tails (S₀ + T) (Nat.le_add_left T S₀)).2 with
        | ⟨k, f, admitted, not⟩ =>
          ⟨S₀ + T + k, f, Nat.le_trans (Nat.le_add_right S₀ T) (Nat.le_add_right (S₀ + T) k),
           admitted, not⟩⟩⟩

/-- Irreflexivity derived from widening's. -/
theorem EventuallyWidens.irrefl_of_tails : ¬ W.EventuallyWidens l l := fun ev =>
  match eventuallyWidens_iff_tails.mp ev with
  | ⟨T, tails⟩ => (tails T (Nat.le_refl T)).not_reverse (tails T (Nat.le_refl T))

/-- Transitivity derived from widening's. -/
theorem EventuallyWidens.trans_of_tails (a : W.EventuallyWidens l l')
    (b : W.EventuallyWidens l' l'') : W.EventuallyWidens l l'' :=
  match eventuallyWidens_iff_tails.mp a, eventuallyWidens_iff_tails.mp b with
  | ⟨T, ta⟩, ⟨T', tb⟩ => eventuallyWidens_iff_tails.mpr ⟨T + T', fun S le =>
      (ta S (Nat.le_trans (Nat.le_add_right T T') le)).trans
        (tb S (Nat.le_trans (Nat.le_add_left T' T) le))⟩

/-! ## P2. The settled range within one step of the growing course: inclusion derived -/

theorem KeepsWidening.eventually_widens_of_within {T T₂ S : Nat}
    (keeps : W.KeepsWidening itself l T) (settles : W.SettlesFrom l' T₂)
    (from_ : T ≤ S) (within : ∀ f, W.Admits (l' T₂) T₂ f → W.Admits (l S) S f) :
    W.EventuallyWidens l l' :=
  keeps.eventually_widens (T₁ := S + T₂)
    (fun t f later admitted =>
      (includesAcross_itself_iff (Nat.le_trans (Nat.le_add_right S T₂) later)).mp
        (keeps.1 S t from_ (Nat.le_trans (Nat.le_add_right S T₂) later)) f
        (within f ((settles t f (Nat.le_trans (Nat.le_add_left T₂ S) later)).mp admitted)))
    settles

/-- P2b. The kit's law uses only that the course keeps opening: nothing lost is idle there,
because the inclusion is assumed. Same proof as `KeepsWidening.eventually_widens`, with
`opens` for `keeps.2`. -/
theorem KeepsOpening.eventually_widens {T T₁ T₂ : Nat} (opens : W.KeepsOpening itself l T)
    (includes : W.IncludesFrom T₁ l l') (settles : W.SettlesFrom l' T₂) :
    W.EventuallyWidens l l' :=
  ⟨⟨T₁, includes⟩, fun S₀ =>
    have inner : T₁ + T₂ ≤ T + (T₁ + T₂) := Nat.le_add_left (T₁ + T₂) T
    have outer : T + (T₁ + T₂) ≤ S₀ + (T + (T₁ + T₂)) := Nat.le_add_left _ S₀
    have atT : T ≤ S₀ + (T + (T₁ + T₂)) := Nat.le_trans (Nat.le_add_right T _) outer
    have atT₁ : T₁ ≤ S₀ + (T + (T₁ + T₂)) :=
      Nat.le_trans (Nat.le_add_right T₁ T₂) (Nat.le_trans inner outer)
    have atT₂ : T₂ ≤ S₀ + (T + (T₁ + T₂)) :=
      Nat.le_trans (Nat.le_add_left T₂ T₁) (Nat.le_trans inner outer)
    match opens (S₀ + (T + (T₁ + T₂))) atT with
    | ⟨U, later, exceeds⟩ => match (exceedsAcross_itself_iff later).mp exceeds with
      | ⟨g, admitted, before⟩ =>
        ⟨U, g, Nat.le_trans (Nat.le_add_right S₀ _) later, admitted, fun held =>
          before (includes _ g atT₁ ((settles _ g atT₂).mpr
            ((settles U g (Nat.le_trans atT₂ later)).mp held)))⟩⟩

/-! ## P3. A course whose admissions are listed eventually widens nothing -/

/-- A step beyond every listed step. -/
def stepBound : List (Nat × F) → Nat
  | [] => 0
  | p :: ps => p.1 + 1 + stepBound ps

theorem lt_stepBound : ∀ {ps : List (Nat × F)} {p : Nat × F}, p ∈ ps → p.1 < stepBound ps
  | _ :: _, _, .head _ => Nat.lt_of_lt_of_le (Nat.lt_succ_self _) (Nat.le_add_right _ _)
  | _ :: _, _, .tail _ mem => Nat.lt_of_lt_of_le (lt_stepBound mem) (Nat.le_add_left _ _)

theorem not_eventually_of_listed {items : List (Nat × F)} (listed : W.ListsAdmitted items l) :
    ¬ W.EventuallyWidens l l' :=
  fun ⟨_, late⟩ => match late (stepBound items) with
    | ⟨t, f, from_, admitted, _⟩ =>
      Nat.lt_irrefl t (Nat.lt_of_lt_of_le (lt_stepBound (listed t f admitted)) from_)

end Web

/-! ## P4. Along a merging continuation a constant course keeps widening over a listed type -/

namespace MergedWitness

/-- Two formations, requiring nothing. -/
def web : Web Bool Unit :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

/-- Every formation continues as `false`; nothing continues as `true`. -/
def merge : Nat → Bool → Bool → Prop := fun _ _ f => f = false

/-- The constant course. -/
def steady : Nat → Unit → Nat := fun _ _ => 0

theorem admits (m : Unit → Nat) (t : Nat) (f : Bool) : web.Admits m t f := fun _ no => nomatch no

theorem into_true_aux : ∀ {s : Nat} {g : Bool} {u : Nat} {h : Bool},
    Web.Linked merge s g u h → h = true → s = u ∧ g = true
  | _, _, _, _, .here _ _, same => ⟨rfl, same⟩
  | _, _, _, _, .next step rest, same => match into_true_aux rest same with
    | ⟨_, same'⟩ => nomatch (same'.symm.trans step : true = false)

theorem into_true {s : Nat} {g : Bool} {u : Nat} (linked : Web.Linked merge s g u true) :
    s = u ∧ g = true :=
  into_true_aux linked rfl

theorem to_false : ∀ (k s : Nat) (g : Bool), Web.Linked merge s g (s + 1 + k) false
  | 0, s, _ => .next (f := false) rfl (.here (s + 1) false)
  | k + 1, s, _ => .next (f := false) rfl
      (Eq.subst (motive := fun x => Web.Linked merge (s + 1) false x false)
        (Nat.succ_add (s + 1) k) (to_false k (s + 1) false))

theorem keeps_widening_along_merge : web.KeepsWidening merge steady 0 :=
  ⟨fun S _ _ le => fun f _ => match Nat.eq_or_lt_of_le le with
     | .inl same => ⟨f, same ▸ .here S f, admits _ _ _⟩
     | .inr lt => match Web.exists_steps_between (Nat.succ_le_of_lt lt) with
       | ⟨k, apart⟩ => ⟨false, apart ▸ to_false k S f, admits _ _ _⟩,
   fun S _ => ⟨S + 1, Nat.le_succ S, ⟨true, admits _ _ _, fun _ linked _ =>
     Nat.succ_ne_self S (into_true linked).1.symm⟩⟩⟩

theorem listed : ∀ f : Bool, f ∈ [false, true]
  | false => .head _
  | true => .tail _ (.head _)

theorem not_keeps_widening_by_name (T : Nat) : ¬ web.KeepsWidening Web.itself steady T :=
  Web.KeepsWidening.not_listed listed

end MergedWitness

/-! ## P5. A pair widening decides is also eventually widened -/

theorem OwnCondition.full_eventually_widens_rising :
    OwnCondition.web.EventuallyWidens OwnCondition.full OwnCondition.rising :=
  Web.WidensWithoutEnd.eventually ⟨OwnCondition.full_widens_rising.1, fun S =>
    ⟨S, S + 1, Nat.le_refl S, OwnCondition.full_admits,
     fun admitted => Nat.not_succ_le_self S (OwnCondition.rising_iff.mp admitted)⟩⟩

/-! ## P6. Opened by the opened, through a condition that rises -/

/-- Every gain after `T` is given, to a condition the gainer requires before the step and that rises
across it, by a supported formation taking part that itself gained support after `T`, earlier. -/
def Flow.OpenedByOpenedRising {F C : Type} (L : Flow F C) (W : Web F C) (T : Nat) : Prop :=
  ∀ t f, T < t → W.GainsSupport t f → ∃ c g u, W.requires t f c ∧ W.Rises t c ∧
    g ∈ L.present t ∧ 0 < L.give t g c ∧ W.Supported t g ∧ T ≤ u ∧ u < t ∧ W.GainsSupport u g

theorem OpeningChain.flow_opened_rising : Flow.OpenedByOpenedRising OpeningChain.flow OpeningChain.web 0 :=
  fun t f after gains => match t, after, OpeningChain.gains_iff.mp gains with
  | s + 1, _, same => ⟨f, s + 1, s, rfl,
      Eq.subst (motive := fun x => OpeningChain.web.Rises (s + 1) x) same.symm
        (show OwnCondition.rung (s + 2) (s + 1) < OwnCondition.rung (s + 2) (s + 2) from
          Eq.subst (motive := fun x => x < OwnCondition.rung (s + 2) (s + 2))
            (OwnCondition.rung_zero (Nat.lt_succ_self (s + 1))).symm
            (OwnCondition.rung_pos (Nat.le_refl (s + 2)))),
      .head [],
      Eq.subst (motive := fun x => 0 < OpeningChain.opening (s + 1) x) same.symm
        (OpeningChain.opening_pos (s + 1)),
      OpeningChain.supported_iff.mpr (Nat.le_refl (s + 1)), Nat.zero_le s, Nat.lt_succ_self s,
      OpeningChain.gains_iff.mpr rfl⟩

/-! ## P6b. Opened by the opened holds wherever nothing gains support -/

/-- On `OwnCondition.web` nothing is ever supported (its levels stand at zero, every need is one),
so every flow on it is opened by the opened, from every step. -/
theorem OwnCondition.opened_vacuously {L : Flow Nat Nat} {T : Nat} :
    Flow.OpenedByOpened L OwnCondition.web T :=
  fun _ f _ gains => absurd (gains.2 f rfl) (Nat.not_succ_le_zero 0)

/-! ## P8. A lag defeats eventual widening: kept forever one step late, yet mixed in every tail -/

namespace LagWitness

open OwnCondition

/-- At step `t` only formation `t` is admitted: each formation for one step. -/
def travelling : Nat → Nat → Nat := fun t c => if c = t then 1 else 0

/-- At step `t` the formations below `t` are admitted: each kept forever from the step after. -/
def lagging : Nat → Nat → Nat := fun t c => rung (c + 1) t

theorem lagging_iff {t n : Nat} : OwnCondition.web.Admits (lagging t) t n ↔ n < t :=
  ⟨fun admitted => le_of_rung_pos ((admits_iff (m := lagging t)).mp admitted),
   fun lt => (admits_iff (m := lagging t)).mpr (rung_pos lt)⟩

theorem travelling_iff {t n : Nat} : OwnCondition.web.Admits (travelling t) t n ↔ n = t :=
  ⟨fun admitted => match Nat.decEq n t with
     | .isTrue same => same
     | .isFalse other => absurd ((admits_iff (m := travelling t)).mp admitted)
         (show ¬ 0 < (if n = t then 1 else 0) from (if_neg other).symm ▸ Nat.lt_irrefl 0),
   fun same => (admits_iff (m := travelling t)).mpr
     (show 0 < (if n = t then 1 else 0) from (if_pos same).symm ▸ Nat.zero_lt_one)⟩

theorem lagging_keeps_widening : OwnCondition.web.KeepsWidening Web.itself lagging 0 :=
  ⟨fun _ _ _ later => (Web.includesAcross_itself_iff later).mpr fun _ admitted =>
      lagging_iff.mpr (Nat.lt_of_lt_of_le (lagging_iff.mp admitted) later),
   fun S _ => ⟨S + 1, Nat.le_succ S, (Web.exceedsAcross_itself_iff (Nat.le_succ S)).mpr
      ⟨S, lagging_iff.mpr (Nat.lt_succ_self S), fun admitted => Nat.lt_irrefl S (lagging_iff.mp admitted)⟩⟩⟩

/-- Every formation the travelling course admits, the lagging course admits at every later step. -/
theorem kept_later {t u n : Nat} (admitted : OwnCondition.web.Admits (travelling t) t n)
    (later : t < u) : OwnCondition.web.Admits (lagging u) u n :=
  lagging_iff.mpr (Eq.subst (motive := fun x => x < u) (travelling_iff.mp admitted).symm later)

theorem not_eventually_lagging : ¬ OwnCondition.web.EventuallyWidens lagging travelling :=
  fun ⟨⟨T, inc⟩, _⟩ => Nat.lt_irrefl T (lagging_iff.mp (inc T T (Nat.le_refl T) (travelling_iff.mpr rfl)))

theorem not_eventually_travelling : ¬ OwnCondition.web.EventuallyWidens travelling lagging :=
  fun ⟨⟨T, inc⟩, _⟩ => Nat.noConfusion
    (travelling_iff.mp (inc (T + 1) 0 (Nat.le_succ T) (lagging_iff.mpr (Nat.zero_lt_succ T))))

end LagWitness

/-! ## P7. The splice laws in chapter 03's frame: the reading and its complement are dense -/

section Frame

variable {F C : Type} {W : Web F C} {l' m : Nat → C → Nat}

/-- Where some path eventually widens `l'`, eventually widening it is dense among the sequences of
levels. -/
theorem eventually_dense (widens : W.EventuallyWidens m l') :
    Dense (fun r : Run (Sequences.process (C → Nat)) => W.EventuallyWidens r.act l') :=
  fun r h => ⟨Sequences.run (Web.splice h r.act m), Web.eventually_of_splice widens h r.act,
    Sequences.agree_iff.mpr fun _ before => (Web.splice_before (Nat.le_of_lt before)).symm⟩

/-- Not eventually widening `l'` is dense. -/
theorem not_eventually_dense :
    Dense (fun r : Run (Sequences.process (C → Nat)) => ¬ W.EventuallyWidens r.act l') :=
  fun r h => ⟨Sequences.run (Web.splice h r.act l'), Web.not_eventually_of_splice h r.act l',
    Sequences.agree_iff.mpr fun _ before => (Web.splice_before (Nat.le_of_lt before)).symm⟩

/-- Neither verifiable nor refutable, where some path eventually widens `l'`. -/
theorem neither (widens : W.EventuallyWidens m l') :
    ¬ Verifiable (fun r : Run (Sequences.process (C → Nat)) => W.EventuallyWidens r.act l') ∧
    ¬ Refutable (fun r : Run (Sequences.process (C → Nat)) => W.EventuallyWidens r.act l') :=
  ⟨not_verifiable_of_adheres (r := Sequences.run m) (not_eventually_dense _) widens,
   not_refutable_of_adheres (r := Sequences.run l') (eventually_dense widens _)
     Web.EventuallyWidens.irrefl⟩

/-- A practice fixed by the record can keep the verdict "eventually widens `l'`" against every
record. -/
theorem insulated (widens : W.EventuallyWidens m l') :
    ∃ V : Practice (Sequences.process (C → Nat)), ByRecord V ∧
      Insulates V (fun r => W.EventuallyWidens r.act l') :=
  insulates_iff_dense.mpr (eventually_dense widens)

end Frame

end Becoming
```

## Re-check of the revision (da9933409)

The same reviewer re-checked the revision at `da9933409` (AI-authored):

- DESIGN.md (`cf40a771…15d3925f`) and LANDING.md (`233a3437…5a581cf1`);
- `tree/Becoming/EventualWidening.lean` (`b753c1ae…3ee697c3`) and `EventualWideningInstances.lean` (`a70fbe3e…88f38e48`).

**How it was checked.**

- **Rebuild.** The kit was rebuilt with `scratch_build.py`: 25 theorems in 38 declarations and 77 theorems in 98, every axiom report empty, as the note says (all steps reused from the cache).
- **Statements.** Every theorem was read against its docstring and against the module docstrings.
- **Names and links.** Every Lean name cited in DESIGN.md and LANDING.md resolves. Every link and anchor resolves.
- **Clashes.** None of the new namespaces or declarations (`OwnCondition`, `LagWitness`, `MergedWitness`, `OpeningChain`, `ClosedCycle`, `Web.after`, `Web.splice`, `Web.eventually_dense` and the rest) clashes with a name in the package. The package's `eventually_dense` is `Sequences.eventually_dense`, in another namespace.
- **Probe.** A re-check probe, 4 theorems in 6 declarations with every axiom report empty, is given [below](#appendix-the-re-check-probe).

**Verdict.**

- **The findings.** All 29 are taken: 27 fully and 2 in part. The revision is careful: DESIGN §7's map was checked row by row against the files and is right.
- **The Lean.** It has no error. Eventual widening is now defined as widening on every late tail; its order laws come from widening's; and the splice laws are density statements in 03's frame. `eventually_widens_of_within` derives the inclusion, and `OpenedByOpened` is no longer vacuous.
- **New issues.** Five small ones, none in a Lean statement (below).
- **The landing set.** Right in substance, with one placement change.

### 1. The findings

- **Addressed (27):** 1–13, 15, 16 and 18–29, each where DESIGN §7 says.
- **Partly addressed (2):**
  - **14.** The opening of DESIGN.md says that nothing lost along a continuation "is refuted by a finite stretch". It can be, by a loss within the stretch, as F3 says correctly. Write "can be refuted by a finite stretch (a loss within it)".
  - **17(c).** DESIGN §3.1 labels "on counts eventual widening entails overtaking" as an argument, not in Lean. LANDING's row for 08 §8 drops both the label and the condition (finitely many admissions at each step). Restore both there, so the record does not cite it as a law.
- **Not addressed:** none.

### 2. New issues

**R1. "Ranking by opened by the opened runs against widening wholesale" is stated with no theorem.** *Imprecision.*
- **Location.** The module readings of `EventualWidening`; DESIGN §3.3, Premises.
- **What is wrong.** The claim is true but unproved in the kit. The probe proves it: the relay is opened by the opened and its levels are the rising course. A flow that gives nothing, on a web where every condition stands at one throughout, is opened by the opened from no step (no gain recurs). Its levels are the saturated course, which widens the rising one on the same requirements (`Saturated.reverses`).
- **Fix.** Add the witness to the instances module and cite it, or label the sentence "(a witness, `Saturated.reverses` in the review)".

**R2. The home-section draft omits two limits.** *Imprecision.*
- **Location.** LANDING.md, the draft text for 07 §2.
- **What is wrong.** The record's "does not show" says that the second-order direction stays open, but the draft paragraph for 07 §2 does not. 07 §2 is where "how far is open" stands.
- **Fix.**
  - Add the line: "It does not capture the second-order direction of 生生, a range whose widening keeps widening against one merely wider now, which stays open, as does a law relating 生成 to widening (02)."
  - Add the frame laws' qualifier: "the first course varied, the second fixed".

**R3. Candidate C's definition sits in the module whose row calls it "the long-run reading of widening".** *Suggestion.*
- **Location.** `Flow.OpenedByOpened` and `OpenedByOpened.not_of_unsupported` in `Becoming.EventualWidening`; LANDING.md, rule 9.
- **What is wrong.** The definition does not use eventual widening. Its witnesses (`OpeningChain`, `ClosedCycle`, `OwnCondition.not_opened`) are in the instances module.
- **Fix.** Move the two declarations into `Becoming.EventualWideningInstances`, beside their witnesses. `Becoming.EventualWidening` is then exactly the tool its row describes, and keeping C out of the core, if that is ever chosen, touches one module only.

**R4. C's definition may not be the form its first law concludes.** *Suggestion.*
- **Location.** `Flow.OpenedByOpened`; DESIGN §3.3, the proposed uniform form of support passing on.
- **What is wrong.** The definition asks for a giver outright. The proposed law, like `Flow.support_passes_on`, would conclude it only up to double negation (DESIGN §3.3 says so). Constructively, the first law then reaches a weaker form than the landed definition. Rule 9 would then ask for a second definition, or for decided support.
- **Fix.** State in the record that C's definition is provisional until its first law fixes its form. Or define it now with the double negation inside; the witnesses meet either form.

**R5. "Agrees or is silent".** *Nit.*
- **Location.** The `EventualWidening` module docstring and DESIGN §3.1.
- **What is wrong.** "Where widening orders a pair, eventual widening agrees … or is silent (the wider course exceeds only over a first stretch)" is a dichotomy only classically. Constructively, from no excess at arbitrarily late steps, no step after which excess stops can be named.
- **Fix.** Add "(classically)", as 07 does for the four cases.

### 3. The landing set

**Land both modules, with R3's move.** The record's limits rest on the instances module:

- the frame laws (dense both ways, neither verifiable nor refutable, insulable);
- the silence of the weighting characterization (`not_eventually_of_listed`);
- the lag, the merge, the disagreement and saturation.

So landing only `Becoming.EventualWidening` would drop the theorems that say what eventual widening cannot do. As the module stands, it would also land C's definition without the witnesses that delimit it, which is the worst combination.

Candidate C's definition with its two witnesses is fit to land as a property with no law. The relay and the single giver give "what carries a range is invisible to widening"; the closed cycle gives "possible with no widening". This is the exact form of 07 §2's sentence that 生生 can exceed what widening counts. Add R1's witness and R4's caveat.

If the integrator prefers C out of the core:

- remove the definition and `not_of_unsupported` from `Becoming.EventualWidening`;
- remove `OpeningChain`, `ClosedCycle` and `OwnCondition.not_opened` from the instances module;
- land the rest, and keep C whole as design.

Either way, the row should name each module as a leaf (a tool; an instance module and models) until the gain bridge or the givers law imports it, and register the apart roots.

### 4. What the record should and should not claim

**It should claim**, each as near-definitional:
- **Eventual widening.** It is first-order widening read on every late tail. Its order laws are widening's; it never reverses widening; with widening it is a strict partial order; and it reads only tails.
- **The frame.** Where some course eventually widens a second, the verdict and its complement are both dense (the first course varied, the second fixed). So it is neither verifiable nor refutable, and a practice fixed by the record can keep it against every record.
- **The listing.** A course whose admissions are listed eventually widens nothing, so C's weighting characterization is silent on eventual widening.
- **Keeping widening.** It is a property, not monotone in widening. By name over a listed type no course keeps widening. Along a supplied continuation, re-formation counts as opening. It eventually widens a range admitting alike on what it once admitted, which is the one case of THE-CORE's pair a law reaches.
- **The lag.** A course keeping every formation of another from one step later is mixed with it in every tail.
- **If C lands.** One range can be carried by a relay of openings or by one giver with every admission the same; opened by the opened is possible with no widening; the recurrence clause excludes a whole where nothing is supported. Both carrier flows give from nothing, so they do not meet the first law.

**It should not claim:**
- **The second-order direction of 生生.** It stays open. Say so in the record and in the 07 §2 paragraph (R2).
- **That eventual widening is better.** That is C∞, a premise beyond C, named and not asserted. If its cost is mentioned: it discounts every loss confined to a finite stretch, its verdicts can be insulated against every record, and it is the unlimited-continuation rival that the priority of basic conditions rejects.
- **That keeping widening or opened by the opened is 生生, a direction or a ranking.** Ranking by either runs against widening (`not_monotone`; R1).
- **A law relating 生成 to widening.** 02's open item stays open, and the record states no gain, renewal or giver law.
- **A third part of any neighbour's containment, or novelty.**
- **That eventual widening entails overtaking as a theorem.** It is an argument, under finitely many admissions at each step.

### Appendix: the re-check probe

`Becoming/UE4RecheckProbe.lean`, built against the revised kit (copied unchanged) in a new scratch tree: 4 theorems in 6 declarations, every axiom report empty. It is a probe for R1, not proposed for landing as written.

```lean
import Becoming.EventualWideningInstances

/-! Re-check probe (scratch only): ranking by opened by the opened reverses widening. -/

namespace Becoming

namespace Saturated

open OwnCondition

/-- Every condition stands at one throughout; each formation requires its own condition at need one. -/
def web : Web Nat Nat :=
  ⟨fun _ _ => 1, fun _ _ => True, fun _ n c => c = n, fun _ _ _ => 1, fun _ _ _ => False⟩

/-- Nothing takes part. -/
def still : Flow Nat Nat := ⟨fun _ => [], fun _ _ _ => 0, fun _ _ _ => 0⟩

theorem level_full : web.level = full := rfl

theorem still_balances : still.Balances web := fun _ _ => rfl

/-- Everything is supported throughout, so nothing gains support, and no gain recurs. -/
theorem still_not_opened (T : Nat) : ¬ Flow.OpenedByOpened still web T :=
  fun ⟨recur, _⟩ => match recur 0 with
    | ⟨_, _, _, gains⟩ => gains.1 (fun _ _ => Nat.le_refl 1)

/-- **Ranking by opened by the opened reverses widening.** The relay is opened by the opened and its
levels are the rising course; a flow that is not, on a web whose levels are the saturated course,
has levels that widen the rising course (read on the same requirements). -/
theorem reverses :
    Flow.OpenedByOpened OpeningChain.relay OpeningChain.web 0 ∧ OpeningChain.web.level = rising ∧
      (∀ T, ¬ Flow.OpenedByOpened still web T) ∧ web.level = full ∧
      OwnCondition.web.Widens full rising :=
  ⟨OpeningChain.relay_opened, OpeningChain.level_rising, still_not_opened, level_full,
   full_widens_rising⟩

end Saturated

end Becoming
```
