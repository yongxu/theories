# CW: what its readers reported

*AI-written reviews of [`Becoming.RoutesToC`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/RoutesToC.lean), its home section, its record and [its note](NOTE.md), 6 November 2026. They are kept as reported, with what was done about them. The module was named `Becoming.PremiseLattice` when the first round read it, and the names below are of that draft. Links in proposed replacements are printed as code, because they resolve in the chapter and not here; that is the only change to the reports as received.*

## Round 1: the reader, on the whole draft


The line numbers below refer to these files:
- `tree/Becoming/PremiseLattice.lean` (LEAN)
- `kit/home-07.md` (HOME)
- `kit/make_record.py` (RECORD)
- `NOTE.md` (NOTE)

No proposed Lean or new sentence below has been compiled or checked.

## High

**1. A counterexample is removed by assertion.**
- **Where:** HOME L11 end ("A wider menu is not a wider course … counts against that claim and not against C"); LEAN L39; NOTE L36 ("C is not touched"), L53; RECORD L77.
- **What is wrong:**
  - `Restraint.widens` is `WidensOn items wide narrow`, the relation `Increasing` reads. So any order increasing in admission on that listing ranks `wide` above `narrow` while each reaches less.
  - No Lean separates a menu from a course, and nothing shows a wider course cannot have this shape. RECORD L95 itself leaves that open.
  - AGENTS says a counterexample in a weaker model stands until the full account removes it.
  - The texts also disagree: NOTE says "need not be", while HOME and LEAN say "is not".
- **Replacement, HOME:** "The witness states the widening with the same `WidensOn` (`Weighting.Restraint.widens`), so an order increasing in admission on that listing ranks the wider menu above the narrower while each reaches less. [AI reading, new] A menu of acts is neither shown to be nor shown not to be a course of what can form. C compares courses, and whether a wider course can have this shape is open. Until that is shown the witness stands against this route and against reading C as "more options are better", and what it does to C itself is open."
- **Replacement, LEAN L39:** "The menus are related by the same `WidensOn` (`Restraint.widens`); whether a wider menu is a wider course, which is what C compares, is not shown here."
- **Replacement, NOTE L36:**
  - Heading: "**It says where C's route stops, and leaves open whether C does.**"
  - Body: "The chooser route is stopped by this. Whether C is touched is open: the witness relates menus by the same `WidensOn`, and whether a wider course can have this shape is not shown, so the witness stands until it is."
- **Replacement, NOTE L53:** "and that reading C as "more options are better" meets a standing witness".
- **Replacement, RECORD L77:** "That more options are better: among several choosers a wider menu can lower what each reaches at game theory's solution; whether a wider course can do the same is open."

**2. `Shared` is not strict unanimity.**
- **Where:** LEAN L41, L77, L444, L455, L468, L500; HOME L7, L12; RECORD L34, L37, L65.
- **What is wrong:**
  - The definition is `(∃ p, R p b a) ∧ ∀ q, ¬ R q a b`. One standpoint may rank and all others may be silent.
  - `every_shared_iff` then ranks on "adds to *some* standpoint's own", which unanimity would not do.
  - HOME and RECORD give no gloss, so a reader believes every standpoint ranks it above.
- **Replacement, LEAN L444:** "The Pareto relation among standpoints' orders: some ranks `a` above `b`, and none ranks `b` above `a`. A standpoint ranking neither counts as no objection; this is not unanimity."
- **Replacement, HOME L12:** "read the shared order as the Pareto relation: some standpoint ranks a course above, none below, the rest may be silent". Later uses become "the shared order".
- **Other lines:** use "the Pareto relation" in the same places; in the zh text use 帕累托关系（有立场排其上，无立场排其下）.

**3. A false sentence in the header.**
- **Where:** LEAN L49–50, "none of widening's mixed pairs can tie".
- **What is wrong:** With weights 1, 1, 1, the courses {0} and {1} tie. The proof runs the other way: an exact weighting *would have* to tie them. "No weighting's" also drops "positive".
- **Replacement:** "No positive weighting's order is exactly widening: on three listed items it would tie two mixed pairs and so weigh the third item nothing (`widening_is_no_weighting`)."

## Medium

**4. "Only at other data, where that help fails" is neither exhaustive nor exact.**
- **Where:** HOME L2; LEAN L16; RECORD L25, L99 ("one sense open"); NOTE L15 ("one of two things").
- **What is wrong:**
  - (a) A premise can be weaker where the help *holds*, simply by not giving C there.
  - (b) C on a stated class is weaker than C on a wider frame at the same datum, and the plan asks about exactly this. The law's `frame` is fixed and never compares the two.
  - (c) The note's own route refutes "one of two things". By `increasing_iff_one_step`, C gives `StepAlike`; by `ranksFewer_alike` and `ranksFewer_reverses`, `StepAlike` with transitivity does not give C. So `StepAlike` is strictly weaker at the same datum and gives C beside help that reads an order.
  - (d) In the Lean, `premise` and `frame` do not vary with `d`, so "other data" is a reading of instances. It is not a Lean statement.
- **Replacement, HOME L2:** "So beside such help a premise can be weaker than C only where it does not give C with that help holding: at other data, or on a wider class. Beside help that reads an order a premise can be weaker at the same datum, as `Weighting.StepAlike` is."
- **Replacement, RECORD L99:** "Reading (the AI's): beside help that reads no order, "weaker" has other data or a wider class open; the range of valuations does the work positivity does."
- **NOTE L15:** see finding 5.

**5. The note gives the plan's question two answers.**
- **Where:** NOTE L11 and L13, L15.
- **What is wrong:**
  - L11 calls the limit "the answer to the question as first asked". L13 says "the plan's literal question has a positive answer".
  - The bold "**Yes at other data**" and "With the condition it gives C's order" invite a skim reading against AGENTS' rule.
  - L15's "second" sense does not fit standpoints, which has no `↔` with `Increasing`.
  - "Less content at the same strength" is not coherent for an `↔`: `increasing_iff_reads_choosers` gives the same proposition. Only the reading differs.
- **Replacement, L11 opening:** "**Beside help that reads no order and holds at a datum, no premise giving C there is weaker there; at other data or on a wider class one can be.**"
- **Replacement, L11 close:** "This is immediate. It answers the question read as "weaker where it gives C": no."
- **Replacement, L13 close:** "Read as "weaker elsewhere, and giving C where the help holds", the plan's question has a positive answer, with self-concern, a premise that reads an order, as its case. At each datum where the help holds, self-concern is exactly as strong as being increasing in admission, which is why this is no derivation."
- **Replacement, L15:** "So a claim of "something weaker" has to say which it means: weaker across data; weaker in scope, C on a stated class being less than C on a wider one; weaker at a datum beside help that reads an order; or not weaker at all, the same strength read differently. The later-chooser and one-step routes have the last, with an `↔`; the parts of one step have the third; the downstream route has the first two. The standpoints route is a different kind of law, saying when every such profile's shared order is increasing."

**6. Hypothesis `holds` dropped, and strength misstated.**
- **Where:** LEAN L13–14, L108–109; NOTE L11; RECORD L58; HOME L2 and RECORD L25 ("a premise C implies is C there").
- **What is wrong:**
  - With help `fun _ _ => False`, `entails` is vacuous and the premise can be anything.
  - "As strong as C" should be "at least as strong"; equal strength needs `iff_of_weaker`'s `weaker`.
  - "A premise C implies is C there" is literally false, since `True` is implied by C. The clause "which gives C with that help" must stay.
- **Replacement, HOME and RECORD third clause:** "and such a premise that C also implies is C there".
- **Replacement, LEAN L13 and NOTE L11:** "Beside help that reads no order and holds at a datum".
- **Replacement, LEAN L108 docstring end:** "with help that reads no order and holds there".
- **Replacement, RECORD L58:** see finding 10.

**7. "The first law's case" is not an instance.**
- **Where:** LEAN L17; HOME L14; implicit in NOTE L13.
- **What is wrong:**
  - The law concludes `Comparison frame living better`. `increasingInOwn_iff_increasing` concludes `Increasing items R`. No Lean connects them.
  - LEAN L68 itself says "not `Comparison`".
  - This is the type gap of the ethics reader's flag 12, which the plan says CW settles.
- **Replacement, LEAN L17:** "`Weighting.increasingInOwn_iff_increasing` has the same shape on a listing, for self-concern at the marking that marks everything. It is not an instance, since `Increasing` is not `Comparison`."
- **Replacement, HOME L14:** "the first law's shape on a listing".
- **Alternative:** prove a one-line bridge on the frame with `realized s c := c ∈ items ∧ s c = true`.

**8. The range qualifier understates what is needed.**
- **Where:** LEAN L27–28; HOME L11; NOTE L34; RECORD L75.
- **What is wrong:**
  - "For each item some possible chooser would take it" is not enough. Take the single chooser with `u x = 2`, `u y = 1`, refusal 0. Each item would be taken from a course admitting it alone. But `{x, y}` widens `{x}` and that chooser gains nothing.
  - For the strict half, the exact need is that each listed item has a possible chooser putting it above every other listed item and above refusal. To see this, take `b` as everything but `x`. I proved this by hand; it has no Lean.
  - The range also carries the converse of the `↔`: the `← includes` half uses `outside a`.
- **Replacement, each place:** "so that for each listed item some possible chooser puts it above every other listed item and above refusal".
- **Add to HOME and LEAN:** "The range also carries the converse: `outside a` is what stops agreement on a pair that is not a widening."

**9. "Refusal free" credits refusal with what the definition of `reach` does.**
- **Where:** LEAN L26–27; HOME L11; NOTE L21 ("a theorem about refusal").
- **What is wrong:**
  - `reach_le_of_includes` holds because `reach` is by definition a maximum, and a maximum over a superset is no lower. The inequality survives with refusal 0, where nothing stands below it.
  - Refusal matters only where the narrower course offers nothing above an added item. The weight sits in defining `reach` as "takes the best and bears the rest at no cost".
- **Replacement, LEAN and HOME:** "That none does worse comes from what a chooser leaves costing it nothing, which `reach` builds in by being the best of what is admitted, or refusal: near-definitional (`reach_le_of_includes`)."
- **Replacement, NOTE L21:** "that none does worse is built into `reach`, where leaving an item costs nothing".

**10. The record's headline drops the two things that carry the route.**
- **Where:** RECORD L58.
- **What is wrong:** "No chooser assumed to value any item" hides that the range holds a chooser for each item. "Self-concerned standpoints" drops `NotBelow`, without which `others_gain_stops` stops the shared order.
- **Replacement (298 characters):** "Beside what reads no order and holds, a premise giving C implies it. Widening is what no later chooser, over every valuation, does worse from and some does better from, and what self-concerned standpoints ranking no widening below share where every item is someone's own; each still reads an order."
- **Replacement, zh:** "在不读次序且成立者旁，给出 C 的前提蕴含 C。扩大是遍及每个赋值时无后来选择者更差且有选择者更好之处，也是不把扩大排在下面的自我关切立场在每项都为某立场所有时所共有者；每条路仍读次序。"

**11. "No chooser need value any item" is fair of each chooser and misleading as a summary.**
- **Where:** NOTE L32, L53.
- **What is wrong:**
  - "**Which side ranks higher need not come from any item's worth**" conflicts with `reach_eq_of_refused`: the strict half needs a possible chooser for whom the item is worth more.
  - "because admitting is not imposing" states the route's hypothesis as a fact about courses.
  - "None assumed good … for every chooser" leaves out that the order ends up ranking a course that adds an item every actual chooser would leave.
- **Replacement, heading:** "**Which side ranks higher need not come from an item's worth to everyone; it comes from its possible worth to someone.**"
- **Replacement, L32 sentence:** "It may put an item below refusal, so no chooser is assumed to find any item good, and, where the route takes admitting not to be imposing, none does worse from a wider course. The order the route ends in still ranks a course adding an item above the course without it, even if every actual chooser would leave that item."

**12. Witnesses stated as laws.**
- **Where:** HOME L2 label, L11 ("where each one's choice bears … lowers"); RECORD L31.
- **What is wrong:** Interdependence does not imply lowering. A coordination game can gain. "Where the chooser's order is not the order reading the result" has the same defect. 08's label table asks for witnesses to be labelled.
- **Replacement, HOME L2 label:** "**Theorem** (any type, and witnesses; root in the last route)".
- **Replacement, HOME L11:** "The route stops at witnesses: where admission is imposed (`Weighting.Refusing`); where the chooser's order is not the order reading the result, which can leave the chooser gaining and the reading falling (`Weighting.AnotherReads`); and among several choosers, where a choice bearing on what the other reaches can make a wider menu lower what each reaches, in a witness at the only mutual best response (`Weighting.Restraint`). Where no choice bears on another's it cannot (`Weighting.not_lowered_of_no_bearing`)."
- **Replacement, RECORD L31:** "can lower" and "can leave".

**13. "No step of invariance is needed" overclaims.**
- **Where:** NOTE L22, L38.
- **What is wrong:** `NotBelow` is asked of every standpoint at every item, its own or not. That is an order premise about what is not one's own. It replaces the condition's marking; it does not free the route of asking anything across standpoints.
- **Replacement, L22:** "the condition's marking of every item from every standpoint is not needed; `NotBelow`, asked of every standpoint at every item, its own or not, and `covers` stand in its place; no one's order need be increasing".
- **Replacement, L38 heading:** "**The shared order needs less marking than the condition, and pays in `NotBelow`.**"

**14. The note's position claim is not in the Lean.**
- **Where:** NOTE L38 ("an order reading position does exactly that"); the name `RanksOthersGainBelow` and its uses.
- **What is wrong:** The order reads only `WidensOn` and its own marking. `others_gain_stops` has no hypothesis that `x` is anyone else's own, and it reads no position.
- **Replacement, NOTE:** "and an order ranking below every widening that adds nothing of its own does exactly that (`others_gain_stops`); read as positional concern [AI reading, new], with the added item possibly no one's".
- **Name:** rename only if the owner agrees it states a wrong meaning; otherwise keep it and add "others' or no one's" to the docstring.

**15. The modelling list omits choices that could carry a route, though NOTE L49 says it is complete.**
- **Where:** LEAN L76–78; RECORD L63; NOTE L49.
- **What is missing:** a chooser takes one item. Its valuation, its refusal value and its being there at all do not depend on the course. "Later" has no Lean counterpart; a chooser is a function, and none need exist.
- **Add to LEAN L76–78 and RECORD L63:** "a chooser who takes one item; its values, its refusal and its being there at all fixed across courses; "later" a reading, with no time in `reach` and no chooser asserted to exist".

**16. One step: weight, vacuity and a table disagreement.**
- **Where:** HOME L13; LEAN L56; NOTE L23.
- **What is wrong:**
  - "Rests on that one comparison" sits in NOTE's "what becomes of C's weight" column, yet `StepAlike` does the generalising. It sets aside which item and what it is added to, which is where `ZeroWeight`'s boundary of scope falls.
  - `ranksFewer_alike` and `ranksOnlyMany_alike` hold with every step's verdict "not ranked", and `StepAlike` never reads `O a b`. The empty order meets it too. Only `OnlyMany` discloses this ("no step").
  - NOTE L23 says "nothing that reads no order", while HOME L8 says "a step to rank".
- **Replacement, HOME and LEAN:** "Fewer ranked above meets all of it but the instance, every step's one verdict being "not ranked above" (as the order relating nothing also has), so, given transitivity and one verdict, which side of the difference is ranked better rests on that one comparison. That the verdict is one is where it was set aside which item is added and to what, a premise of neutrality across items."
- **Replacement, NOTE L23, columns:** "a step to rank"; "given one verdict and transitivity, which side rests on one comparison; the neutrality is in the one verdict".

**17. "P2 and P4 give that premise".**
- **Where:** HOME L14; LEAN L64–65; RECORD L43.
- **What is wrong:**
  - The mapping to 07 §4.6 is correct: `«本类至终有常»` is P2 and `«所缘同于»` is P4. But "that premise" can be read as the order premise, which they do not give.
  - `goes` is a further hypothesis that HOME and RECORD drop. It is redundant, since `down` yields it where a listed item exists and the conclusion is vacuous otherwise.
- **Replacement, text:** "give that the class holds everything downstream".
- **Replacement, Lean (drop `goes`, uncompiled):** `(fun _ d => hE.symm («本类常闭则后皆续» hE atClass (match d with | .one s => ⟨_, s⟩ | .more s _ => ⟨_, s⟩) held (hE.refl m) d).1)`
- **Otherwise:** keep `goes` and write "P2 and P4, where one acts".

**18. AI readings sit unlabelled inside a Theorem block.**
- **Where:** HOME L11 ("That range does the work positivity does"), L13 ("read as enough", "read as what is too small to tell apart"), L12 ("a future beyond every present line").
- **What is wrong:** RECORD L99 labels the first as a reading; HOME does not. It is also inexact: positivity is asked of every weighting at every item, the range only of some chooser at each item.
- **Replacement, L11:** "[AI reading, new] That range does the work positivity does above: positivity asks it of every weighting at every item, the range of some possible chooser at each."
- **Other readings:** mark the L12–L13 readings "[AI reading, new]" too.

**19. Weaker left unreconciled.**
- **Where:** 07 L345, "Monotonicity at the standpoint is C's premise relocated: weaker, still a premise", a few lines above the new home. The plan says CW "settles what 'weaker' means" there, and the kit does not touch it.
- **Replacement, 07 L345:** "Monotonicity at the standpoint is C's premise relocated, still a premise; in what sense it can be called weaker is `[below](#r-what-would-give-c)`."
- **Also:** list this under NOTE's "What differs".

**20. Note against record and plan.**
- **Where:** NOTE L42–45.
- **What is wrong:**
  - "Quasi-option value is stated without learning or deferral" contradicts RECORD L83 and 08 ("not captured").
  - The plan asks for "P1–P4", and NOTE does not say P1 and P3 go unused.
- **Replacement, first sentence:** "Quasi-option value is not stated: it needs learning and deferral, and a chooser's values are fixed here, known or not, so the route is the preference for flexibility and not Arrow and Fisher's value of waiting, which 03 §12's holding for a reading covers."
- **Add bullet:** "The plan asked for §4.6's P1–P4. Only P2 and P4 are used. P3 is not needed for an order on a listing. P1 presupposes significance and ranks nothing, so self-concern is a further premise and is not obtained from P1."

**21. "What every later chooser agrees on".**
- **Where:** HOME L6; NOTE L21; RECORD L58 (also finding 10); LEAN L30.
- **What is wrong:** `ChoosersAgree` is ≤ for all and < for some. Most choosers are indifferent, so a reader takes "every chooser agrees it is better". "Reads that agreement" also suggests only that, while `Increasing` may rank more.
- **Replacement, HOME L6 and NOTE L21:** "calling better what no later chooser does worse from and some does better from".
- **Replacement, HOME L11 and LEAN L24–25:** "so being increasing in admission is ranking above whatever that holds of".

## Low

**22.** LEAN L67 cites `exists_increasingInOwn_not_increasing` for "an item the line does not reach". With `reads` one-way, `own` may mark such an item. Replacement: cite `exists_increasingInOwn_not_increasing_of_outside` and add "with the marking reading only what the line reaches".

**23.** HOME L2's link `#r-what-self-concern-alone-ranks` does not state the unmarked-item witness. Replacement: `(#r-self-concern-and-c-under-the-condition)`.

**24.** "That field's solution" (HOME L11; LEAN L37, L77; RECORD L65, L77) has no field named as its referent. Replacement: "game theory's solution, not a claim about what actual choosers do".

**25.** "One chooser" (HOME L6; NOTE L21; RECORD L65) clashes with "every later chooser". Replacement: "each chooser choosing alone".

**26.** "Stays unranked" (HOME L12; RECORD L79) is too strong: a particular profile may rank it. Replacement: "some such profile leaves it unranked".

**27.** "Every such profile ranks one course above another exactly when" (HOME L12; LEAN L42, L455) can be read as each profile ranking only those. Replacement: "One course is ranked above another by every such profile exactly when".

**28.** "Less than the condition" (HOME L12; LEAN L45) needs a qualifier: the free condition has no marking. Replacement: "less than the condition held de se".

**29.** HOME L11: "no chooser does worse … some does better" has no stated basis at first use. Replacement: "no chooser does worse by its own valuation, and some does better by its own".

**30.** "Leave an added item" (LEAN L28; HOME L11; RECORD L75): `reach_eq_of_refused` needs every added item left. Replacement: "who would each leave everything added".

**31.** "Fewer ranked above" (HOME, LEAN): `ranksFewer` reads weight, and a course with fewer items can weigh more. Replacement in the sentence: "A lighter course ranked above".

**32.** "Rank no gain below" (HOME L16; LEAN L81): the Lean says widening. Replacement: "rank no widening below".

**33.** Attributions, from memory. All the years are right.
- (a) Schelling 1960 (LEAN L73–74; RECORD L99). I am fairly sure this overclaims "each". His central case is one party gaining by binding itself against another; the mutual case here is the prisoner's dilemma's. Replacement: "that a chooser can gain by having fewer options is Schelling's (1960), there by commitment against another; that removing an option from both can leave each better off is the prisoner's dilemma's".
- (b) Gul and Pesendorfer 2001 (LEAN L73; RECORD L99). I am fairly sure `AnotherReads` has no self-control cost, so it is their no-self-control limit, Strotz's case. Replacement: "changing tastes (Strotz 1955–56), the no-self-control limit of temptation (Gul and Pesendorfer 2001)".
- (c) Luce 1956 (LEAN L75; RECORD L99). I am sure "are" is too strong. `ranksOnlyMany` is not a semiorder: {5,1,2} over {5} and {6,3,4} over {6} break the interval condition. Replacement: "that an order need not tell small steps apart is the idea of Luce's semiorders (1956); this order, read on inclusion, is not itself one".

**34.** Record declarations (L31–42) all exist and fit, but they are thin.
- `chooser_gains` and `each_falls` are bare inequalities. Add `Refusing.widens`, `AnotherReads.widens`, `AnotherReads.takes_narrow`, `AnotherReads.takes_wide`, `Restraint.widens`, `Restraint.narrow_best`, `ranksFewer_transitive`, `AboveNothing.transitive`, `ranksOnlyMany_transitive`.
- `choosers_mixed` has no sentence anywhere. Add to L28: "On a mixed pair each course is better for some chooser."

**35.** Dependencies (L105–134).
- `WidensBy`, `ranksNet` and `widensOn_of_widensBy` belong to `a-narrowing-above-its-widening`, not the record named. Add that dependency and drop them from L106.
- `«所缘同于»` belongs to `what-a-line-holds-and-a-regularity-takes-in`; add it.

**36.** RECORD L63, "Equality of items decided where a law names an item", is wrong: `others_gain_stops` names an item and uses none. Replacement: "Equality of items decided for `shared_increasing_iff_covers` and `increasing_iff_one_step`."

**37.** RECORD L73–74: `not_strictly_weaker` does not state the sentence, and every record's witness lies in its own proof declarations, so `not_entails` cannot be named there. Replacement: "That C derives from the continuation condition: nothing here does. What reads no order and holds gives C only if every order meets C (this law, at a premise every order meets), which an extension rules out."

**38.** RECORD L89: `no-evaluation` ("Contains no ethical predicate") does not fit a first law whose statement contains `Comparison`. `premises-met-and-failed`, which holds `not_entails`, omits it. Replacement: drop that key.

**39.** RECORD L147 gives `CH08` role `statement`, and HOME L16 links 08 §8, but the kit has no 08 text, and §8 lists its results by name. Replacement: add a bullet there: "What would give C (`[07 §4.4](07-SIGNIFICANCE.md#r-what-would-give-c)`) restates known forms: the unanimous form of a preference for flexibility (Kreps 1979), strict Pareto, and the prisoner's dilemma read as a menu. Each law is near-definitional or a witness." Otherwise remove the reference.

**40.** LEAN L434: `WidensOn.not_reversed` duplicates `Weighting.WidensOn.not_reverse`. Replacement: delete it and use the existing one at L462.

**41.** `Becoming.PremiseLattice` and the alias "the premise lattice" (RECORD L103): NOTE L43 says no lattice is built. Replacement: `Becoming.RoutesToC`, and drop the alias.

**42.** `EachItsOwn.not_increasing` (LEAN L527) does not state `NotBelow`, though the route's profiles need it. The witness order meets it. Replacement: conclude `IncreasingInOwn … O ∧ NotBelow … O ∧ ¬ Increasing … O`.

## Categories that came up clean

- **Argument order:** `R p b a`, `Increasing`, `NotBelow`, `Shared`, `RanksOthersGainBelow` and `ranksNet` are read correctly everywhere.
- **`reach`:** it is exactly the highest of refusal and the listed admitted values.
- **`Restraint`:** it shows what its own sentences say about the witness; the payoffs are a prisoner's dilemma, with the unique pure mutual best response proved.
- **Item 4:** P2 and P4 map correctly, apart from `goes`.
- **"Direction":** it appears only in NOTE L28, saying why it is kept out.
- **Derivation:** no sentence says C is derived or follows from the condition. The risk is the framing in finding 5.
- **New mathematics:** nothing claims it.
- **Other attributions:** Kreps 1979 and Arrow and Fisher 1974 are fine as used.

## What I checked and did not

I read the whole leaf, home section, record script and note sentence by sentence. I checked them against the named definitions and theorems, the §4 intro, §4.4 and §4.6 of 07, CD §1, AGENTS, the glossary rows for these terms, the plan's CW row, 08's label rules, and which records own the reused declarations.

I ran no build or checker and took the compile and axiom reports as given. I did not read `Weightings.lean` beyond the declarations named, or check the zh text beyond a skim. The literature is from memory, not read against the sources.

## Round 2: the same reader, on the rewrite

I re-read the rewrite against the Lean. Findings continue from round 1, starting at 43. I ran nothing, and none of the proposed Lean below has been compiled.

The line numbers refer to these files:
- `tree/Becoming/RoutesToC.lean` (LEAN)
- `kit/home-07.md` (HOME)
- `kit/make_record.py` (RECORD)
- `NOTE.md` (NOTE)
- `kit/apply_cw.py` (APPLY)

## Verdict on your departures

| Departure | Verdict |
|---|---|
| Finding 1, home's wording | Exact about the Lean. It underclaims what is settled and misstates when the witness lapses (46). |
| Finding 5, the note's "The answer" | Right, with two low qualifiers (54, 61). |
| Finding 19, 07's line | It uses my words, but they are no longer enough: the link lands on nothing about monotonicity at the standpoint (48). |
| Finding 14, renaming | Right. "Others" stated a wrong meaning and the draft has not landed. `RanksNotOwnBelow` says what the definition does. One sentence in NOTE is reversed (57). |
| Record statement, reworded finding 10 | Wrong. It drops the hypothesis finding 10 restored (43). |

## Status of the 42 findings

**Fixed:** 2, 3, 4, 5, 6, 7, 9, 11, 12, 13, 14, 16, 18, 20, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 32, 33, 34, 36, 37, 38, 39, 40, 41, 42.

**Not fixed or only partly fixed:**
- **10:** not fixed, in the record statement and the README rows (43).
- **1:** fixed apart from the lapse condition (46).
- **8:** the range condition is now exact and has Lean, but the new sentence has a quantifier error (45), and HOME L6 and NOTE L21 still use the old shorthand (56).
- **15:** fixed in LEAN and RECORD, not in HOME or fully in NOTE (60, 64).
- **17:** `goes` is gone and the mapping is exact; the citation is slightly off (58).
- **19:** see 48.
- **26:** partly (59).
- **35:** answering `«所缘同于»` with `related` is right, since a type used is not a verified inference. `not_reverse` now has an unlisted owner (65).

## High

**43. The record statement is false as worded.**
- **Where:** RECORD L67–68. The same drop is in APPLY L62–63 (EN, ZH).
- **What is wrong:**
  - "What self-concerned standpoints rank by the Pareto relation" omits `NotBelow`. `notOwnBelow_stops` gives a self-concerned profile whose relation does not rank a widening, so the omitted hypothesis decides the result.
  - "Every profile" is also gone. A single profile can rank more, and can be increasing without `covers`. For example, with `own` empty and each order ranking all widenings, the order is vacuously self-concerned and meets `NotBelow`.
  - The BULLET and SCOPE keep `NotBelow` but need "every profile" for "exactly where" to hold.
- **Replacement, RECORD L67 (295 characters):** "Beside what reads no order and holds, a premise giving C implies it. Widening is what no chooser, over every valuation, does worse from and some does better from; where every item is someone's own, what every self-concerned profile ranking no widening below ranks by Pareto; each reads an order."
- **Replacement, RECORD L68:** "在不读次序且成立者旁，给出 C 的前提蕴含 C。扩大是遍及每个赋值时无选择者更差且有选择者更好之处；每项都为某立场所有时，也是每个不把扩大排在下面的自我关切剖面以帕累托关系所排者；每条路仍读次序。"
- **Replacement, EN, BULLET, SCOPE:** "over every profile of self-concerned orders ranking no widening below, the Pareto relation is increasing in admission exactly where every listed item is someone's own".
- **Replacement, ZH:** "在每个自我关切且不把扩大排在下面的次序剖面上，帕累托关系随接纳递增恰当每个所列项都为某立场所有".

## Medium

**44. "Self-concern is C" says more than `increasingInOwn_iff_comparison`.**
- **Where:** HOME L2; LEAN L18–21, L183; RECORD L28–29; NOTE L13, L45; SCOPE.
- **What is wrong:**
  - The Lean says an order meets one exactly when it meets the other, on a frame built so that `Comparison` unfolds to `Increasing`. The unmarked case aside, `iff_of_weaker` adds nothing beyond `increasingInOwn_iff_increasing`.
  - Read beside "with the condition", a reader takes C to reduce to self-concern. `PremiseWitnesses` L89 says it "does not equate C with self-concern", and 07 says "placed more narrowly, not warranted".
- **Replacement, HOME L2 and LEAN L18–21:** "On a frame reading a course by what it admits on a listing, every claim counted, C unfolds to being increasing in admission (…). There, with every listed item marked, an order is self-concerned exactly when it meets C (…): one premise in two forms, and no reason for either."
- **Replacement, LEAN L183:** "**Where every listed item is marked, an order is self-concerned exactly when it meets C on that frame**".
- **Replacement, RECORD L28:** "There, with every listed item marked, an order is self-concerned exactly when it meets C, through the law above."
- **Replacement, RECORD L29:** "在那里，每个所列项都被标记时，次序自我关切恰当它满足 C，经由上一律。"
- **Replacement, NOTE L13 and SCOPE:** the same wording.
- **Add to NOTE L45:** "; on level paths it stays one way".

**45. A quantifier error is new in the range law's sentence.**
- **Where:** HOME L11; LEAN L36–38, L366; RECORD L34–35; SCOPE.
- **What is wrong:** "Some chooser in it does better from every widening" reads as one chooser for all widenings. The Lean is `∀ a b, WidensOn a b → ∃ u refusal`. One chooser cannot gain from every widening: a chooser gains nothing where its top item is already admitted. 08 asks a sentence to keep the Lean's quantifiers.
- **Replacement, HOME, LEAN, RECORD L34:** "for every widening some chooser in it does better, exactly when, for each listed item, some chooser in it puts that item above every other listed item and above refusal".
- **Replacement, RECORD L35:** "对每个扩大，其中都有选择者得益，恰当对每个所列项，其中有选择者把该项置于其他每个所列项与拒绝之上。"
- **Replacement, SCOPE:** "for every widening some chooser in a range does better exactly when for each listed item some chooser in it puts that item above every other and above refusal".

**46. Finding 1's departure: exact on the Lean, underclaims what is settled, wrong lapse condition.**
- **Where:** HOME L13; LEAN L47–50; RECORD L40–41; NOTE L36.
- **Exact:** `comparison_ranks_wide` with `each_falls` proves the sentence, provided "the frame above" means `listingFrame` on `Restraint.items` with the menus as its courses and every claim counted. That proviso should be stated, or "every order meeting C" reads as C on what can form.
- **Underclaim:** three things are settled.
  - There is no inconsistency: C's order does not read `pays`, and orders meeting C exist there (`increasing_ranks` through the bridge). So the witness cannot refute C; it can only show a conflict and a cost.
  - The added act must count as living; where it does not, there is no extension and C does not rank it.
  - The nearest law, own widening within the margin, has a part's widening leave the whole mixed, where C is silent.
- **Lapse:** "the witness stands until it is" means until it is shown whether, but showing that a wider course *can* have this shape would not lapse it. AGENTS says it stands until the full account is shown to remove it.
- **Replacement, HOME L13 from "The witness relates":** "The witness relates the menus by the same widening, so on the frame above, with the menus read as its courses and every claim counted, every order meeting C ranks the wider menu above the narrower, while each reaches less at that solution (`Weighting.Restraint.comparison_ranks_wide`, `Weighting.Restraint.each_falls`). [AI reading, new] That is no inconsistency: C's order does not read what each reaches, and orders meeting C exist there. It is a conflict between what C ranks and what each reaches. A menu of acts is neither shown to be nor shown not to be a course of what can form, and whether a wider course can have this shape, with the added act counted as living, is open. If one can, C ranks it above a course where each reaches more, a loss that stands. The nearest law here, `[own widening within the margin](#r-own-widening-within-the-margin)`, has a part's widening leave the whole mixed, where C is silent; whether the menu's shape falls under it is not shown. The witness stands against this route and against reading C as "more options are better" unless the full account is shown to remove it, and what it costs C is open."
- **Replacement, LEAN L50 and RECORD L40 ending:** "is not shown; the witness stands unless the full account is shown to remove it."
- **Replacement, RECORD L41 ending:** "皆未表明；除非表明全部理论能消除它，此见证成立。"
- **Replacement, NOTE L36:** "So the witness stands unless the full account is shown to remove it, as AGENTS asks of a counterexample found in a weaker model."

**47. The new law takes C as a hypothesis, so three labels no longer fit.**
- **Where:** RECORD L100; HOME L2; APPLY L62–63.
- **What is wrong:**
  - `comparison_ranks_wide` has `meets : Comparison …`. RESULT-WORKFLOW allows `no-ethical-premise` only where the hypotheses contain none, and AGENTS counts C as a premise of the ethics. No record holding a law with C as a hypothesis cites that key.
  - 08 labels a result holding under C **Conditional**.
  - The README rows now say "no ethical predicate" for a module whose laws contain `Comparison`, the point of finding 38.
- **Replacement, RECORD L100:** `['conditional-not-universal', 'decidability', 'no-definition-by-verdict', 'names-provisional', 'formal-not-empirical']`. Empty axioms stay stated in `validation_scope`.
- **Replacement, HOME L2 label:** "**Theorem** (any type, and witnesses; root in the last route; a finite listing, two-valued admission, natural values) **and Conditional** (C, at the menu witness on the listing's frame)."
- **Replacement, EN:** "C only as a stated hypothesis or conclusion;" in place of "no ethical predicate;".
- **Replacement, ZH:** "C 只作为所述假设或结论出现；" in place of "无伦理谓词；".

**48. Finding 19: the pointer lands on nothing about monotonicity at the standpoint.**
- **Where:** APPLY L78; NOTE L42, L46.
- **What is wrong:**
  - The home never names it, and NOTE L42 leaves the plan's first candidate unmapped.
  - With the bridge the line can say the answer: on the listing's frame it is not weaker at all. My round 1 text was written before the bridge existed.
- **Replacement, APPLY L78:** "Monotonicity at the standpoint is C's premise relocated, still a premise: on a listing's frame, every claim counted, an order is increasing in admission exactly when it meets C, so it is weaker only in scope, a listing and not all of what can form (`[below](#r-what-would-give-c)`)."
- **Add to NOTE L42 after its first sentence:** "Monotonicity at each standpoint is `Increasing` at that standpoint's order, on the listing's frame exactly C (`comparison_listingFrame_iff`), and standpoint-Pareto is `ParetoAmong`."
- **Replacement, NOTE L46 middle:** "the sentence on monotonicity at the standpoint now says which sense holds of it, scope".

**49. Provenance is misstated.**
- **Where:** RECORD L102–103; `kit/READER.md` L3, L5; NOTE L3.
- **What is wrong:**
  - "Attributions from reading" is false: round 1 said they are from memory, and AGENTS says to say exactly what was done.
  - "Independent AI readers" and "the first reader" are plural, but one reader has read this in two rounds.
  - READER's header promises "with what was done about them", and NOTE L3 says "every finding taken or answered", yet the file ends at my report with no dispositions.
- **Replacement, RECORD L102 middle:** "Written by an AI; one independent AI reader, in two rounds, of the home section, the record and the note against the Lean, findings taken or answered (READER in the study folder); no human audit. Attributions from the AI's knowledge, not checked against the sources."
- **Replacement, RECORD L103 middle:** "AI 所写；一位独立 AI 读者分两轮对照 Lean 读了本节、记录与笔记，发现已处理或作答；无人类审计。文献出自 AI 所知，未核对原文。"
- **Replacement, READER L5:** "Round 1: the reader, on the whole draft".
- **Also:** add the disposition list before landing.

**50. APPLY L82, KNOWN: false as stated.** "That no chooser does worse from a course including another and some does better": a course including another may admit the same items, and then none does better. Replacement: "That no chooser does worse from a course widening another and some does better".

**51. "Every claim counted" is dropped in the restatements.**
- **Where:** BULLET L25; SCOPE L45; EN; ZH.
- **What is wrong:** `comparison_listingFrame_iff` is at `fun _ => True`. With a narrower `living`, C is less than being increasing.
- **Replacement, EN, BULLET, SCOPE:** "On a frame reading a course by what it admits on a listing, every claim counted, C is being increasing in admission".
- **Replacement, ZH:** "在按列举上之接纳读进程、每项皆计的框上".

## Low

**52.** APPLY L85 and NOTE L46: 08's sentence states only two of the four senses, while NOTE says 08 "states them".
- **Replacement, 08:** "… only at other data or on a wider class; beside what reads an order a premise can be weaker at one datum (`[07 §4.4](07-SIGNIFICANCE.md#r-what-would-give-c)`)."
- **Replacement, NOTE:** "and 08 §8 states the first three".

**53.** APPLY L62–63: "so a premise can be weaker" drops the scope the BULLET keeps.
- **Replacement, EN:** "so beside such help a premise can be weaker than C only at other data or on a wider class".
- **Replacement, ZH:** "故在这样的助力旁，前提只能在别的数据或更宽的类上弱于 C".

**54.** LEAN L23–24 and NOTE L15: `increasing_iff_one_step` has `transitive` and a step as hypotheses, so "being increasing gives `StepAlike`" has no Lean for other orders.
- **Add (uncompiled):**
  `theorem Increasing.stepAlike {items : List X} {O : (X → Bool) → (X → Bool) → Prop} (increasing : Increasing items O) : StepAlike items O := fun _ _ _ _ _ _ first second => ⟨fun _ => increasing _ _ (widensOn_of_widensBy second), fun _ => increasing _ _ (widensOn_of_widensBy first)⟩`
- **Cite it** at both places.
- **Replacement, NOTE L15:** "The chooser route has the last with an `↔`, and the one-step law among transitive orders."

**55.** HOME L2 and LEAN L17–18: "it fixes the sense of the word" conflicts with the senses now listed. "Self-concern is the case" now follows the order-reading sentence and has no clear antecedent. Replacement: "This much is near-definitional: it sorts the senses of the word. Self-concern is the first law's case."

**56.** HOME L11 and LEAN L34: "does that work" has no antecedent. HOME L6 and NOTE L21: "a range holding a chooser for each item" is finding 8's understatement again.
- **Replacement, HOME L11 and LEAN L34:** "The range over every valuation does the work an assumption of value would:".
- **Replacement, HOME L6 and NOTE L21:** "a range holding, for each item, a chooser who puts it above every other listed item and above refusal".

**57.** NOTE L32: "A chooser assumes less of each chooser" is garbled. Replacement: "The chooser route assumes less of each chooser." NOTE L38: "does exactly that" reads backwards. Replacement: "breaks exactly that".

**58.** HOME L16 and LEAN L80: `…_of_regularity` concludes `Increasing`, not that the class holds it; that step is `«本类常闭则后皆续»`. Replacement: "give that the class holds it, and so the same law (`…`)". RECORD L52: "gives that the class holds it, and so the same law."

**59.** HOME L14: an item is not what gets ranked, and no declaration is cited.
- **Replacement, HOME L14:** "A widening adding only what is no one's own is not ranked by every such profile (`Weighting.every_pareto_iff`)."
- **Replacement, RECORD L90:** "not every such profile ranks a widening adding only that, so that route does not do the step of invariance's work."
- **Replacement, NOTE L38:** "is not ranked by every such profile".

**60.** HOME L11 omits finding 15's choices. Add after "read as choosing later": "; it takes one item, and its values, its refusal and its being there at all are fixed across courses".

**61.** NOTE L13: "With the condition" means the condition on the root, with a marking reading the line; "now" is history in live text.
- **Replacement, first sentence:** "Self-concern is the case, in the law's own terms."
- **Replacement, later clause:** "With the condition on the root, the marking reading what the line reaches, it gives…".

**62.** LEAN L8: `not_entails` needs an extension. Replacement: "and on a frame with an extension a statement reading no order entails C only where it fails".

**63.** BULLET L23–27: `implies_comparison` is the declaration whose strength matches "implies C there", and "under any valuation" sits beside "some does better".
- **Replacement, citation:** `ReadsNoOrder.implies_comparison`, `ReadsNoOrder.iff_of_weaker`.
- **Replacement, sentence:** "exactly when, over every valuation, no chooser does worse and some does better".

**64.** The texts differ.
- NOTE L50 says its list is the header's but omits "no chooser asserted to exist" and "with every claim counted and the process free". Replacement: copy LEAN L95–100.
- HOME L9 omits a stop NOTE L24 names. Replacement, HOME L9: "where one's line ends with its last stage still conditioning; what lies beyond the listing".

**65.** RECORD L149: "its own options" is not that record's claim.
- **Replacement:** "A part widening what can form within its own region, the whole mixed beyond the others' margins, where C does not rank it; the menu witness is a different shape, two choosers on one menu at game theory's solution."
- **Also:** add `shared-laws-on-the-grammar` as a `formal-reuse` dependency for `WidensOn.not_reverse`.

## Came up clean

- **Declarations:** every declaration named in RECORD's laws, aliases and witnesses, and in HOME and NOTE, exists in the leaf or its imports.
- **Stale names:** a grep found none. "Direction" appears only at NOTE L28, saying why it is kept out.
- **New Lean:** the new statements say what their docstrings say.
  - `listingFrame`, `extension_listingFrame_iff` and `comparison_listingFrame_iff` read `O s t` in the right order, and `comparison_ranks_wide` gives `O narrow wide`.
  - `gains_every_widening_iff` states exactly my condition.
  - That condition also suffices for the converse half by my hand check, so "what a range needs is exact" holds.
  - `RanksNotOwnBelow` and `exists_selfConcerned_notBelow_not_increasing` are as described.
- **P2 and P4:** the mapping is exact now that `goes` is dropped.
- **Derivation and new mathematics:** no sentence claims either. The nearest risk is 44.
- **Decidability:** RECORD's hypothesis names exactly the three laws that have `[DecidableEq X]`.
- **Attributions as revised:** fine, from memory.
- **Apply anchors:** those I grepped each occur once or match one row (08's sentence, `Becoming.lean`, `check_becoming.py`, both README rows). 07's two were read in round 1, not grepped, and the 08 "Where the possible grows" bullet was read, not counted.
- **Caps:** the current statement is 296 of 300 characters; the proposed one is 295.

## What I checked and did not

I read the whole of `RoutesToC.lean`, the home section, the record script, the note and `apply_cw.py`, and I re-checked each round 1 finding against them. I checked which records cite C as a hypothesis, and I read the own-widening record's statement.

I ran no build and took your compile and axiom reports as given. I did not diff the leaf's unchanged proofs against the old draft line by line. I read the zh only where a replacement touches it. I read the top and tail of `READER.md`, not all of it. The literature is from memory.

## Two lenses, on the draft after round 1

Two further AI readers, each without the others' reports. They read while round 2's fixes were going in, so a few findings overlap them. Findings and what they checked are verbatim; the line numbers are of the draft they read. "What was done" is the author's. The literature reader edited nothing and ran no build; the cold reader read in the order a reader would and ran nothing.

### The cold reader

**C1 (high).** home-07.md line 2 (title, opening) and the table's last column

- **Problem:** After the first read I believed each route reaches C itself, the C that ranks courses of what can form, and stops only where the last column says. The Lean does not support this. All four routes end in `Weighting.Increasing items`, which is C only on `listingFrame`, where any `X -> Bool` is a course and the process is free. The chapter says a course on a listing need not be what any level path admits, and that listed paths admit nothing from some step on (07 lines 244, 252-253). The draft says this only in the last route ('This is an order on a listing'), so the choosers, standpoints and one-step rows read as having no such limit.
- **Replacement:** Title: '*What would give C's order on a listing.*' After 'puts its weight' add: 'Every route below ends in an order increasing in admission on a finite listing. That is what C asks only on a frame reading a course by what it admits on that listing. A course on a listing need not be what any level path admits, and a listed level path admits nothing from some step on (`[above](#r-self-concern-and-c-under-the-condition)`). So between level paths a route gives what C asks only with admission decided and both paths' admissions listed, one way, and no route gives C on all of a web's level paths.' Table header: 'Where it stops (each also at the edge of the listing)'.
- **What was done:** Taken. The title is now "What would give C's order on a listing", a paragraph after the first says every route ends on a listing and what that gives between level paths, and the table's last column says each also stops at the edge of the listing. The record keeps its id; "here" added to "no route gives C on all of a web's level paths", which is what 07 lists as not shown.

**C2 (high).** line 13, last sentence ('Until that is shown ...')

- **Problem:** The menu counterexample is kept and is not settled either way, but the AGENTS rule is only partly honoured. 'Until that is shown' has two possible outcomes, so it reads as if the witness lapses when the question is resolved in either direction. I came away believing that showing a wider course can have this shape would end the witness's standing, which is backwards: it would then stand against C. The AGENTS rule lapses in one way only, when the full account is shown to remove it. The sentence also moves the burden: C counts as untouched unless someone lifts the witness, and 'against reading C as "more options are better"' frames the hit as landing on a misreading. Separately, 'A menu ... is neither shown to be' a course comes right after a theorem that treats menus as courses on a frame, with no explanation of the two senses. 'This shape' is never defined, so the open question has no test.
- **Replacement:** [AI reading, new] A menu of acts is neither shown to be nor shown not to be a course of what can form: the frame above reads anything listed as a course by construction, and a course on a listing need not be what any level path admits. So the witness stands against this route, against reading C as "more options are better", and as what C does on that frame, until the full account is shown to remove it, by showing that no wider course of what can form has this shape: one course widening another while, at game theory's solution among those choosing within it, what each gets falls. Whether one has it is open. If one has, the witness stands against C there too.
- **What was done:** Taken. "This shape" is defined, the witness stands until the full account removes it by showing no wider course has the shape, and if one has it, it stands against C there too.

**C3 (medium).** line 2, first sentence; the same phrase in the Lean header and the module-table row in apply_cw.py

- **Problem:** 'This derives C from nothing' is the sentence meant to block a false belief, yet it can be parsed as 'derives C with no premises', and this repository talks of zero axioms. 'And gives no reason for it' only partly rescues it. The Chinese row in the kit says 不推出 C, which is the intended sense.
- **Replacement:** This does not derive C from anything and gives no reason for it.
- **What was done:** Taken everywhere: home, Lean header, module bullet, scope, READMEs.

**C4 (medium).** line 2, 'Let help read no order ... on a wider class ... Self-concern is the case'

- **Problem:** I could not follow this on first reading. 'Help' and 'datum' are never introduced, and 'reads no order' is defined about 90 lines earlier with no link. 'Weaker' is the word being fixed but is never defined; the Lean's sense is that C implies it and some order meets it and fails C. 'At other data, or on a wider class' reads as exhaustive and is not: one verdict on every step is strictly weaker than C at the same datum and simply does not give C with order-free help, which is the draft's own later example. 'On a wider class' has no referent I could find in the Lean, and 'class' is a glossary term meaning an equivalence relation, used in that sense in the last route of this same item. 'Self-concern is the case' does not say what it is a case of. 'It fixes the sense of the word' credits the lemma with what only a definition does.
- **Replacement:** Call a premise on orders strictly weaker than C at a datum where C implies it and some order meets it and fails C. Let a further statement, the help, read no order (`[§4](#scope-and-order)`) and hold at a datum, the facts it is about. A premise that with that help gives C at that datum implies C there, so no order meets it and fails C, and if C also implies it, it is C there (`ReadsNoOrder.implies_comparison`, `ReadsNoOrder.not_strictly_weaker`, `ReadsNoOrder.iff_of_weaker`). So no premise is both strictly weaker than C at a datum and, with such help holding there, enough for C at that datum. It can give C at one datum and be strictly weaker at another, or be strictly weaker at that datum and not give C with that help. Where the help itself reads an order, a premise can be strictly weaker at one datum and still give C with it, as one verdict on every one-item widening does below; there the help supplies the order the premise lacks. This much is near-definitional. Self-concern shows the first of these.
- **What was done:** Taken, with "strictly weaker", "help" and "datum" defined. "On a wider class" became "in scope" throughout, because class has a glossary sense. "It fixes the sense" had already gone in round 2.

**C5 (medium).** line 2, 'every claim counted, C is being increasing in admission'; 'no order meets it and fails C'

- **Problem:** After the first read I took C to be a property of orders, 'being increasing in admission'. The draft never says C is 'widening what can form is better', nor that it is using C as a condition an order meets or fails. 'Every claim counted' is the Lean's `living := True`, a choice that settles scope inside the frame's definition. In a chapter that keeps scope and order apart, a reader should be told this; four words do not do it.
- **Replacement:** Read C here as a condition an order can meet or fail: it ranks a course above every course it widens (`Comparison`). On a frame reading a course by what it admits on a listing, with the process free and every claim counted as living, so that scope is already total, an order meets C exactly when it is increasing in admission (`Weighting.listingFrame`, `Weighting.comparison_listingFrame_iff`).
- **What was done:** Taken.

**C6 (medium).** line 11, opening and 'No chooser is assumed to value any item. The range ... gives the converse'

- **Problem:** This is the weight that sits in a definition. I read 'no chooser does worse and some does better' as Pareto over agents, and 'No chooser is assumed to value any item' as an assumption removed. In the Lean a chooser is a pair of values and 'nothing here says one exists'. The chooser doing better is `outside b`, built from the course being compared. So the assumption moved to counting a merely possible chooser, and only the AI-reading sentence at the end hints at that ('some possible chooser'). 'The converse' has lost its referent because `outside` was dropped. Also missing are that the chooser takes one item, that its values and refusal stay fixed across courses, and that 'later' is a reading with no time in `reach`. All of these are in the Lean's Standing and none is in the home. 'It is read as choosing later' cannot be followed as written.
- **Replacement:** Opening: 'A chooser here is a pair of values, and none is asserted to exist: a valuation of the listed items, which may put an item below refusal, and a value of refusing, both fixed across courses. From a course it takes one item, so it reaches the highest of refusal and what the course admits; it is read, not modelled, as choosing later.' Later: 'No chooser is assumed to value any item. The range over every possible valuation does that work, and what is assumed instead is that a merely possible chooser counts: the one valuing only what a course leaves out, with refusal at zero, does better from any widening of that course and stops the relation on any pair where the first does not include the second.'
- **What was done:** Taken: a chooser is a pair of values, none asserted to exist, and what is assumed instead is that a merely possible chooser counts (`Weighting.outside`).

**C7 (medium).** line 13, the witness named `Weighting.Restraint`, against 07 §5 (lines 536-541) and ONE-PAGE's lake

- **Problem:** This looks like a contradiction with neighbouring text and the draft does not address it. §5 says every comparison satisfying C ranks restraint above overdraw (`Ranking.restraint_ranks_over_drawers`), and ONE-PAGE has thirty a month ranked over fifty. Here, under the name Restraint, every order meeting C ranks the menu that adds taking above the menu of restraint alone. The two differ in frame: acts in one, courses in the other. That difference is the best evidence the account has on the menu question, and the draft leaves it out. It must not be overread as removing the witness.
- **Replacement:** Insert after 'need not be what any level path admits.': 'The one case the account compares as courses runs the other way: a restrained course extends overdraw where it includes an event overdraw withholds, and every comparison satisfying C then ranks it higher (`[§5](#r-ranking-under-readings)`). There fewer acts gave the course ranked above, so a wider menu is not as such a wider course. That does not show that no wider course has this shape.'
- **What was done:** Taken, reworded: what the §5 case compares is what each course admits and not what is open to act, so a wider menu of acts is not as such a wider course. The reader's "fewer acts" was not carried, because §5 compares courses of one law and states no menu. (Both this rewording and its reason were themselves wrong about §5: finding 66 in round 3 below.)

**C8 (medium).** line 13, 'what it does to C itself is open'

- **Problem:** The chapter already says what this would be, and the draft does not connect it. T8 is 'refuted by ... a pure closing argued good for life', and the table in this same subsection has `Web.not_widens_of_closes` (a closing is never ranked above by C). Lifted to courses, the narrow menu is a closing from which each gets more. Saying only 'open' hides that the witness has the shape of the account's own stated refuter, which is the thing AGENTS item 2 asks a reader to be able to see.
- **Replacement:** Append after 'If one has, the witness stands against C there too.': 'The narrower course is then a closing from which each gets more. C never ranks such a closing above (`Web.not_widens_of_closes`), and T8 names a pure closing argued good for life as what refutes it (`[§8](#theses)`): the witness would have that refuter's shape, wanting only the argument that what each gets there is good for life.'
- **What was done:** Taken, conditional on a wider course having the shape, under the [AI reading, new] label.

**C9 (medium).** line 13, the first two witnesses (`Weighting.Refusing`, `Weighting.AnotherReads`)

- **Problem:** Only the third witness is carried to C and given a standing sentence. The other two also relate their courses by the same widening (`Refusing.widens`, `AnotherReads.widens`), so every order meeting C on that frame ranks the wider above the narrower there too, against a net weighting or the reading order. I came away thinking only several choosers trouble C. Yet 'imposed' may be the closest of the three to what C compares: as ONE-PAGE defines it, what a course admits has no chooser in it, so a formation that can form is not obviously something anyone can leave.
- **Replacement:** Add after the third witness: 'The first two witnesses relate their courses by the same widening, so on the frame above every order meeting C ranks the wider above the narrower there too, while a net weighting, or the order reading the result, puts it lower. [AI reading, new] Nothing in a course's admitting a formation makes the formation chosen, so whether what a course adds is left by a chooser or imposed is not shown; the first witness stands with the third.'
- **What was done:** Taken, and proved rather than asserted: `Weighting.Refusing.comparison_ranks_wide` and `Weighting.AnotherReads.comparison_ranks_wide` are new.

**C10 (medium).** line 13, 'lower what each reaches ... while each reaches less'

- **Problem:** 'Reaches' was defined two lines earlier as the maximum of refusal and a valuation of items, and under that definition a wider course is never lower. The witness uses `pays`, which reads both acts, and no `reach` at all, so the word changes sense at the point that matters. This comparison also has no stated basis. C reads what is admitted and each chooser reads a payoff, and the draft never says these are two comparisons. The witness is not named as the prisoner's dilemma, though the Lean says it is and a specialist would then follow it at once.
- **Replacement:** Among several choosers, where a choice bears on what the other gets, widening the one menu both choose from can lower what each gets by the game's payoffs, which read both acts and not an item alone: in a witness, the prisoner's dilemma read as a menu, at the only mutual best response, game theory's solution and no claim about what actual choosers do (`Weighting.Restraint`); where no choice bears on another's it cannot (`Weighting.not_lowered_of_no_bearing`). The witness relates the menus by the same widening, so on the frame above every order meeting C ranks the wider menu above the narrower while each gets less (`Weighting.Restraint.comparison_ranks_wide`, `Weighting.Restraint.each_falls`). C's comparison reads what is admitted, each chooser's what it gets, and neither reading is shown to be the one that counts.
- **What was done:** Taken: "gets" by the game's payoffs, the prisoner's dilemma named, and both comparisons stated. With L5, "the pure Nash equilibrium of one play" replaces "game theory's solution".

**C11 (medium).** line 14, '[AI reading, new] A future beyond every present line would be such an item, so this route does not do the step's work.'

- **Problem:** Stated flatly, this holds only if the profile holds present standpoints alone. `every_pareto_iff` ranges over any `P`, the glossary has a center as 'a formation as a standpoint', and 07's Open list leaves 'which formations hold standpoints' open. With later formations among the standpoints, the covering hypothesis can be met and all the cost falls on the ban on ranking a widening below. A philosopher will raise future generations at once. 'The step' is also not named as the step of invariance, and the next bullet uses 'step' in another sense.
- **Replacement:** [AI reading, new] With standpoints read as present ones, a future beyond every present line would be such an item, and so read this route does not do the work of the step of invariance. With later formations among the standpoints it would be someone's own; which formations hold standpoints is `[open](#open)`.
- **What was done:** Taken. `#open` does list which formations hold standpoints (07 line 784 at the time).

**C12 (medium).** table row 'one step'; line 15; line 18 ('an order's steps are alike')

- **Problem:** 'Step' here means a widening by one item. In this subsection a listed item is 'a formation at a step', the next theorem speaks of 'one step of continuation', and the previous bullet has 'the step's work'. That makes three senses within a few lines, against the one-sense rule, and I first read 'every step' as temporal.
- **Replacement:** Name the route '*One item at a time.*' Table row: 'one item at a time | one addition ranked; every addition of one item one verdict; transitivity | an addition to rank | a course admitting less ranked above, a zero weight, enough, additions too small to tell'. Line 18: 'that an order gives every one-item widening one verdict'. Keep `StepAlike` only as the Lean name.
- **What was done:** Taken in prose: the route is "one item at a time" and the widening "a one-item widening". The Lean names `StepAlike`, `increasing_iff_one_step` and the like stay; a name changes only if it states a wrong meaning.

**C13 (medium).** line 15, 'A lighter course ranked above meets all of it but the instance ... which side of the difference is ranked better'

- **Problem:** I could not follow this on first reading. The subject is an order, not a course. 'Lighter' is a comparison with no stated basis: the weights `w`, positive, appear nowhere in the bullet. 'The instance' was introduced only as 'the given one'. 'Which side of the difference' has no referent. 'Ranked better' overstates, because with the instance absent the order relating nothing ranks neither side.
- **Replacement:** An order ranking the course of lower total weight above, on positive weights, meets all of it but the given comparison, every one-item widening's one verdict being "not ranked above" (`Weighting.ranksLighter_alike`, `Weighting.ranksLighter_reverses`), as the order relating nothing does too. So, given transitivity and one verdict, whether every widening is ranked above what it widens rests on that one comparison.
- **What was done:** Taken.

**C14 (medium).** line 16, 'between listed level paths it gives C one way', 'P1 ...', 'Whether P2 and P4 hold is the crux.'

- **Problem:** The gloss drops qualifiers its home keeps (07 lines 244, 249, 252): admission decided, every admission of both paths listed, and courses whose admissions end. On this listing those admissions must also all lie downstream. I came away thinking self-concern with P2 and P4 gives C between level paths generally. 'One way' is not explained. P1 to P4 are forward references to §4.6, a chapter which also has a different P1 to P4 in §4.2, and neither P2 nor P4 is stated here, so 'P1 presupposes significance and ranks nothing' cannot be followed in sequence. 'The crux' has no link.
- **Replacement:** Replace the P2/P4 clause: '`[§4.6](#future-path)`'s P2, that one's class is constant up to the net's end at oneself, and P4, that it holds one's effects, give that the class holds it (`Weighting.increasing_on_downstream_of_regularity`).' Replace the level-paths sentence: 'This is an order on a listing. Between level paths with admission decided whose admissions are all listed, so all downstream and so courses whose admissions end, it ranks every extension as C asks there; the converse is not shown (`[above](#r-self-concern-and-c-under-the-condition)`). It says nothing of what lies beyond the listing.' End: 'Whether P2 and P4 hold is `[the crux](#crux)`.'
- **What was done:** Taken. P2 and P4 stated in place, checked against §4.6; the level-path qualifiers restored and the crux linked.

**C15 (medium).** line 2, the label

- **Problem:** Neighbours put their modelling choices and conditional standing in the label (07 lines 238, 333). This one omits both, though AGENTS asks that the modelling choices a law depends on be stated: finite listing, two-valued admission, natural-number values, one refusal value for all items. The last route takes self-concern, P2 and P4 as hypotheses, yet the item is labelled Theorem only.
- **Replacement:** **Theorem** (any type, and witnesses; root in the last route; a finite listing, two-valued admission, natural-number values, one refusal value for all items) **and Conditional** (in the last route, self-concern, P2 and P4 as hypotheses).
- **What was done:** Taken, and extended: Conditional also at the witnesses, C on the listing's frame.

**C16 (medium).** line 14, last sentence (`Weighting.widening_is_no_weighting`)

- **Problem:** 'No positive weighting's order is exactly widening' reads as universal, and I believed it for any listing. It is false on two listed items, where equal weights rank exactly the widenings, and the Lean proves it only on `[0,1,2]`. 'Tie two mixed pairs' does not say why a tie is forced. The sentence has no connection to the Standpoints bullet it sits in; it belongs with `Weighting.widens_iff_every_positive` in the table above.
- **Replacement:** Move after the first table of §4.4: 'On three listed items no positive weighting's order is exactly widening (on two, equal weights are): a total leaves a pair unranked only by tying it, so it would tie the mixed pairs {0} and {1, 2}, and {1} and {0, 2}, which weighs the third item nothing (`Weighting.widening_is_no_weighting`). Widening is what every positive weighting shares, not any one's order.'
- **What was done:** Taken in part. The sentence left the Standpoints bullet and now opens "On three listed items", which is all the Lean says. It stays in this home and not after §4.4's first table, because this record states it. "On two, equal weights are" was not carried: it is true but not in Lean, and proving it for a parenthesis was not worth it.

**C17 (low).** line 14, 'the Pareto relation among them ... the rest may be silent'

- **Problem:** §4.4 has just used 'Pareto dominance as the unanimity of positive weightings'. The Lean says this relation 'is not unanimity' and names counting silence as no objection a modelling choice. The home drops both, so the same word carries two senses and a choice reads as a neutral aside.
- **Replacement:** read what they share as the Pareto relation among them, which is not the unanimity above: some standpoint ranks a course above, none below, and a standpoint ranking neither counts as no objection, a modelling choice.
- **What was done:** Taken.

**C18 (low).** line 14, 'no standpoint's own order need be increasing in admission'

- **Problem:** This is unqualified. The Lean's witness needs a listed item that the standpoint's marking leaves, and where a marking marks everything listed, self-concern is increasing in admission. The positional reading of `notOwnBelow_stops`, which a specialist would want, is also dropped.
- **Replacement:** and a standpoint whose marking leaves a listed item need not have an order increasing in admission (`Weighting.EachItsOwn`, `Weighting.exists_selfConcerned_notBelow_not_increasing`). ... an order ranking below every widening that adds nothing to its own, read as positional concern, is self-concerned
- **What was done:** Taken.

**C19 (low).** line 11, '[AI reading, new] That range does the work positivity does above: positivity asks it of every weighting at every item, the range of some possible chooser at each.'

- **Problem:** 'It' has no clear referent, and the second clause lost its verb.
- **Replacement:** [AI reading, new] In the law above, that an added item raises the rank comes from positivity, asked of every weighting at every item; here it comes from the range, which asks only that at each item some possible chooser put that item first.
- **What was done:** Taken.

**C20 (low).** table row 'choosers', 'a range holding a chooser for each item'

- **Problem:** The gloss drops the strength of the exact condition (`gains_every_widening_iff`): for each item there must be a chooser who puts it above every other listed item and above refusal, not merely one who values it. A reader of the table alone would believe much less is needed.
- **Replacement:** a range holding, for each item, a chooser who puts it above every other listed item and above refusal
- **What was done:** Already done in round 2.

**C21 (low).** line 2 'puts its weight'; line 13 'an item weighing below zero'

- **Problem:** 'Weight' is metaphorical in the first and literal in a subsection that has just defined weights as natural numbers above zero, so 'below zero' is puzzling until one finds a net weighting in the Lean.
- **Replacement:** 'where each route to C's order rests'; 'an item a net weighting counts below zero can put a widening below what it widens'
- **What was done:** Taken.

**C22 (low).** fit: 07 lines 233 and 249, line 512, glossary row C ('C gives order, in general alone')

- **Problem:** This phrase now sits beside an item giving premises that stand in C's place across a whole listing. It is not contradicted if 'in general' means level paths, but nothing says that, and §4 line 233 is also the natural place for a pointer here, since `ReadsNoOrder.not_entails` is stated there and this item's first paragraph is its companion. The rest of the fit is fine: self-concern and the coincidence law are repeated (lines 242, 360) but each repeat adds the frame step, and the kit already rewrites line 345's unqualified 'weaker'.
- **Replacement:** Line 233: 'A ranking of courses needs C or a premise in its place: C gives order, on courses in general alone, an order rising with one's own continuation ranks one case with no C (`[§4.4](#r-what-self-concern-alone-ranks)`), and what could stand in C's place on a listing, each reading an order, is set out `[there](#r-what-would-give-c)`.'
- **What was done:** Taken as a pointer at 07 §4's sentence, keeping "in general alone", which the glossary and the ethics summary use.

**C23 (low).** line 18, closing paragraph

- **Problem:** 'None is new' is backed only by a link, while neighbours name their antecedents in place (Sen, Pareto, Pigou-Dalton). The chooser route is the idea 08 already attaches to §2's covering, and neither is linked to the other. The closing list of order-reading premises also omits the bare self-concern of the last route.
- **Replacement:** Every law here is short and none is new as mathematics (`[08 §8](08-METHOD.md#known-results)`): the chooser route is the unanimous form of a preference for flexibility (Kreps 1979), on a list with refusal as a default, as `[covering](#r-what-a-course-keeps-reachable)` is; `Weighting.AnotherReads` is changing tastes (Strotz 1955-56); `Weighting.Restraint` is the prisoner's dilemma read as a menu. That what no chooser does worse from should be called better, that an order is self-concerned, that standpoints' orders rank no widening below, and that an order gives every one-item widening one verdict are each a premise reading an order.
- **What was done:** Taken, with L2's attribution in place of Kreps.

*What this reader checked:* Read in the order asked, and tested every Lean name the draft cites against RoutesToC.lean by reading its statements, without running anything; the formal sentences hold apart from the findings above. I grepped apply_cw.py only to avoid reporting what the kit already patches (line 345, 08's named antecedents), and I took §4.6 and the Web laws from the chapter's text, not their proofs; the record and the zh text were not read. Clean categories: it does not read as new mathematics, each route's table row names a premise reading an order, and nothing proves why C is true, which is what I believed on first read; the only slips against 'does not derive' are the ambiguous 'derives C from nothing' and the title's scope. The menu counterexample is neither settled in either direction nor dismissed, though the lapse condition and burden depart from AGENTS' rule; game theory's solution is labelled as that field's; and the hidden weights and unbased comparisons are those listed: the range over possible choosers, silence as no objection, every claim counted, 'lighter' and 'each reaches less'.

### The literature check

**L1 (high).** /Users/ren/tmp/cw/tree/Becoming/RoutesToC.lean:94-95; /Users/ren/tmp/cw/kit/make_record.py:110-111 (correspondence en, zh)

- **Problem:** "`ranksOnlyMany`, read on inclusion, is not itself one" is false as stated; it holds only from four listed items. I enumerated the Lean definition (a above b when a properly includes b on the listing and is not WidensBy, so at least two items more) against the semiorder conditions for 1 to 6 items. It is asymmetric and transitive throughout. On up to 3 items it has no 2+2 and no 3+1, so it is a semiorder there, including on `OnlyMany`'s own two-item listing, where it relates one pair. From 4 items a 2+2 appears: {0} below {0,2,3} and {1} below {1,2,3}, with no other comparison. From 5 a 3+1 appears: {} below {1,3} below {0,1,3,4}, with {2} unrelated to all three. The cause is that a mixed pair stays unranked however large its difference, so incomparability is not a threshold on one scale. The first half (not telling small steps apart is the idea of semiorders) is fair. Read: Luce's abstract only (econometricsociety.org, 1956/04/01); the conditions from Wikipedia's Semiorder article and from memory of S3 and S4, not Luce's pages.
- **Replacement:** Lean header: "that an order need not tell small steps apart is the idea of Luce's semiorders (1956). `ranksOnlyMany`, read on inclusion, is a semiorder on at most three listed items, `OnlyMany`'s two among them, and not from four, where {0} below {0,2,3} and {1} below {1,2,3} are two chains with no comparison between them, which a semiorder forbids: a mixed pair stays unranked however large its difference." Record en: "that an order need not tell small steps apart is the idea of Luce's semiorders (1956); the order here is one on at most three listed items and not from four, a mixed pair staying unranked however large its difference." Record zh: "次序不必分清小步是 Luce 半序（1956）的想法；此处的次序在至多三个所列项上是半序，自四项起不是：混合的一对无论差多大都不排。"
- **What was done:** Taken. Rechecked by my own enumeration of the definition: a semiorder on one to three items, a 2+2 at four and five. Stated as by enumeration, not in Lean.

**L2 (medium).** /Users/ren/tmp/cw/kit/apply_cw.py:82 (KNOWN); /Users/ren/tmp/cw/kit/make_record.py:110-111; /Users/ren/tmp/cw/tree/Becoming/RoutesToC.lean:88-89

- **Problem:** "is the unanimous [ordinal] form of a preference for flexibility (Kreps 1979)" credits Kreps with a relation he does not state and omits the result that does. Kreps's order is one agent's complete order on nonempty menus, aggregating state-wise maxima by a sum or any strictly increasing function. `reach` is one state's term in that representation, with refusal as an item in every menu, so that part is right. "Ordinal" is right too: it is Kreps's own word for the aggregator-free form, and `reach` reads only comparisons. Neither the quantifier over valuations nor "some does better" is his, since his axioms allow flexibility of no value. "Unanimous" fits only the weak part; the strict part is Pareto dominance across state-wise indirect utilities. The named result is Foster's effective freedom: the intersection of indirect-utility rankings, whose strict part is none lower, some higher. He states that with all logically possible orderings it is set inclusion, the least complete quasi-ordering consistent with monotonicity, and he contrasts this with Kreps and Arrow, who aggregate. The drafts also drop a label: live 08 line 516 marks this reading [AI reading, new] and the covering record says "read by the AI". Read: Kreps abstract only, the full text being unreachable on JSTOR and scispace; his representation through Dekel, Lipman and Rustichini 2001 pp. 895-896 (sites.bu.edu/blipman/files/2021/10/DLR2001.pdf); Foster read in the source, OPHI WP35 printed pp. 3, 20-25 (ophi.org.uk/sites/default/files/OPHI_WP35.pdf).
- **Replacement:** 08 KNOWN: "That no chooser does worse from a course including another and some does better is, over every valuation, Foster's effective freedom (1993; 2011): the intersection of indirect-utility rankings, which he states is set inclusion where every preference ordering is admitted. A chooser's reach is one state's term in Kreps's (1979) representation of a preference for flexibility, with refusal an item in every menu; Kreps aggregates those terms into one complete order, and reading their intersection as the unanimous form of his preference is the AI's [AI reading, new]. That an item adds strictly exactly when some possible preference puts it uniquely best is Nehring and Puppe's (1999), and the range's law is that at every listed item." Lean header and record en: "Choosers: Foster's effective freedom (1993; 2011) with every preference admitted, set inclusion, on a list, with refusal an item in every menu; `reach` is one state's term in Kreps's (1979) representation of a preference for flexibility, which aggregates what this intersects; the range's law is Nehring and Puppe's (1999) condition for an element to add strictly, at every listed item." Record zh: "选择者：Foster 的有效自由（1993；2011）在容纳一切偏好时的情形，即集合包含，在列表上，以拒绝为每个菜单中的一项；所及是 Kreps（1979）灵活性偏好表示中一个状态的项，Kreps 聚合这些项，此处取其交；范围之律是 Nehring 与 Puppe（1999）所述元素严格增值的条件，用于每个所列项。"
- **What was done:** Taken in the Lean header, the record and 08 §8. 08's live line on covering and the covering record `what-a-course-keeps-reachable` also omitted Foster and now name him. No law of that record changed. A separate search confirmed WP35 is Foster's paper and that it treats effective freedom, but returned no text of the set-inclusion statement, so that claim rests on this reader's reading of WP35.

**L3 (medium).** /Users/ren/tmp/cw/NOTE.md:32 and :54; /Users/ren/tmp/cw/kit/make_record.py:148

- **Problem:** "the law on a listing, its exact converse and its use here are what is added" presents the converse as an addition, and NOTE:54 and the section heading offer "possible worth to someone" as what a reader newly learns. Named results already state both prior forms I was asked to search. (1) Monotone iff ranks what every maximiser weakly prefers: Foster 2011, printed p. 23, has the all-orderings case as set inclusion and as the least complete quasi-ordering consistent with monotonicity. Only refusal is absent. (2) Exact condition for strict gain: Nehring and Puppe, working paper 97-7 (repec.dss.ucdavis.edu/files/XHnyJgJNGjPiXDytvMnDYrri/97-7.pdf), read in the source. Their intro already states that adding an element helps strictly iff it beats the whole set for some possible preference. Their restated Theorem 3.1, built on Kreps, says that for nested sets the larger is strictly better iff it is strictly better from some viewpoint, and that x is essential at A iff uniquely best in A with x from some viewpoint. I did not find the whole-range condition stated verbatim, but taking A as everything but x gives `gains_every_widening_iff` in one line. Their remark that strict monotonicity forces a trivial rigid preference is the same fact's consequence. The repository's blanket "none is new as mathematics" stands; these specific lines undercut it. The same omission of Foster stands in live 08 line 516 and the covering record.
- **Replacement:** NOTE:32: "That is Foster's effective freedom (1993; 2011) with every preference admitted, which he states is set inclusion, and its strict part follows Nehring and Puppe (1999): an element adds exactly when it is uniquely best from some possible preference. 08 already reads covering through Kreps. What is added is only the law checked on a listing, with refusal, and its use here." NOTE:54: "that the side C ranks better can be had with no chooser assumed to value any item, the range of valuations doing that work, as the multi-preference literature on opportunity sets already has it (Jones and Sugden 1982; Pattanaik and Xu 1998; Nehring and Puppe 1999; Foster 2011)". make_record.py:148 en: "Covering is already read as the unanimous form of a preference for flexibility; here the relation on a listing, with refusal, which is Foster's effective freedom with every preference admitted."
- **What was done:** Taken. The note says the point is not new here. The section's heading stays, softened to "can come from", because the chapter did not say it.

**L4 (medium).** /Users/ren/tmp/cw/NOTE.md:42

- **Problem:** "a chooser's values are fixed here, known or not, so the route is the preference for flexibility and not Arrow and Fisher's value of waiting" gives a reason that points the wrong way. In the sources, an agent who knows her future preference does not value flexibility; the value comes from unresolved uncertainty, and Kreps's agent learns her state at an unmodelled later stage (Dekel, Lipman and Rustichini 2001 p. 895; Foster 2011 printed p. 3). One chooser here has plain indirect utility: `reach` of a union is the higher of the two reaches, the condition Kreps's preference relaxes. So learning does not separate Kreps from quasi-option value, and the likeness to Kreps lies in the state-wise maximum and the range standing in for states. "Value of waiting" also conflates two things: Mensink and Requate (2005) split the Dixit-Pindyck waiting value into the Arrow-Fisher-Hanemann-Henry part, the value of information, and a postponement value. Read: Mensink and Requate from listings only, their PDF yielding no text; Arrow and Fisher through secondary accounts only.
- **Replacement:** "Quasi-option value is not stated: it needs learning across a deferred irreversible step, and there is no time in `reach`. Nor does the route carry Kreps's reason for valuing flexibility: his agent values it because she has yet to learn her tastes, while one chooser here has plain indirect utility. The route shares his state-wise maximum, reading a range of choosers where he has states. So it is not Arrow and Fisher's quasi-option value, the value of information usable only if an irreversible step is deferred, which 03 §12's holding for a reading covers."
- **What was done:** Taken.

**L5 (medium).** /Users/ren/tmp/cw/tree/Becoming/RoutesToC.lean:45-46, :99, :473-475, :494-495; /Users/ren/tmp/cw/kit/home-07.md:13; /Users/ren/tmp/cw/kit/make_record.py:76, :88, :149; /Users/ren/tmp/cw/NOTE.md:36, :50

- **Problem:** "game theory's solution" overclaims. The table is a prisoner's dilemma: T=3 > R=2 > P=1 > S=0 and 2R > T+S, computed from `pays`, and taking strictly dominates. A mutual best response in pure acts is the definition of a pure Nash equilibrium. But that is one solution concept for one frame: with binding agreements or repeated play, mutual restraint is attainable, and those are exactly the conditions under which each reaching less need not follow. The stated modelling choices name neither. Gul and Pesendorfer 2004, note 1 (read), themselves speak of Nash equilibrium as a solution concept. The claims about agreements and repetition are remembered standard results, not read for this check.
- **Replacement:** Global: "game theory's solution" becomes "the pure Nash equilibrium of one play", and zh "博弈论之解" becomes "一次博弈的纯策略纳什均衡". Lean:99: "`MutualBest` as a pure Nash equilibrium, in one play with no binding agreement, not a claim about what actual choosers do;". make_record.py:76 en: "A pure Nash equilibrium read as a mutual best response from one menu, in one play with no binding agreement, not as what actual choosers do." zh: "纯策略纳什均衡读作同一菜单上的相互最优反应，限一次博弈、无约束性协议，而非实际选择者所为。"
- **What was done:** Taken everywhere, Lean docstrings and the record's hypotheses included.

**L6 (low).** /Users/ren/tmp/cw/tree/Becoming/RoutesToC.lean:89-91; /Users/ren/tmp/cw/kit/make_record.py:110-111; /Users/ren/tmp/cw/kit/apply_cw.py:82

- **Problem:** "`AnotherReads` is changing tastes (Strotz 1955–56), the no-self-control limit" is too flat. Strotz (read in the source, pp. 165, 173; ceremade.dauphine.fr/~ekeland/lectures/strotz1955.pdf) has the inconsistency arise with expectations verified, through a discount depending on time-distance. He says the plan is dropped not because tastes changed unexpectedly but because today the man is "a different person with a new discount function" (Strotz 1955-56, p. 173). "Changing preferences" is Gul and Pesendorfer's 2004 gloss of him, so the label is the field's, but the witness has no time and no one person. The no-self-control part is right, and they do identify it with Strotz. The 2001 paper I saw only through search excerpts, its PDF not rendering: limiting case, v then u lexicographically, same behavioural implications. The 2004 paper I read: Strotz is a special case on finite deterministic problems, or in two periods with continuity dropped, and the converse fails.
- **Replacement:** Lean: "`AnotherReads` has the shape of Strotz's inconsistency (1955–56), one person's order differing at two dates, there through a discount that shifts with the date rather than tastes changing unexpectedly, and of temptation without self-control (Gul and Pesendorfer 2001), whose behaviour they show is Strotz's for two dates with continuity dropped, while keeping a commitment ranking to read it by. The witness has no time and does not say the two orders are one person's." 08 KNOWN: "Where the route stops: the shape of Strotz's inconsistency (1955-56) and of temptation without self-control (Gul and Pesendorfer 2001), and among several choosers the prisoner's dilemma read as a menu;". Record zh: "他者的次序：Strotz（1955-56）之不一致的形状（贴现随日期移动，非品味意外改变），亦即诱惑（Gul 与 Pesendorfer 2001）的无自制情形；见证本身无时间，也不说两序属同一人。"
- **What was done:** Taken in shortened form: the clause on Gul and Pesendorfer's commitment ranking was dropped as more than the witness needs.

**L7 (low).** /Users/ren/tmp/cw/tree/Becoming/RoutesToC.lean:91-92; /Users/ren/tmp/cw/kit/make_record.py:110-111; /Users/ren/tmp/cw/kit/apply_cw.py:82

- **Problem:** "is Schelling's (1960), there by commitment against another" is fair for the half it names, but it misplaces the origin and narrows him. Strotz has the same gain four years earlier, against one's later self, by precluding future options (read, pp. 165, 173), and the same record cites Strotz without it. Schelling's own treatment includes the promise: the right to be sued as the power to make one, at p. 43, which is mutual gain and nearer to `Restraint` than "against another". Read: Schelling only through passages quoted in secondary sources (p. 22, p. 43), not the book.
- **Replacement:** "That a chooser can gain by having fewer options is older than Schelling: Strotz (1955–56) has it against one's later self, by precluding future options; Schelling (1960) has it toward another, by binding oneself in a threat or a promise." Record zh: "选项更少可使一方得益早于 Schelling：Strotz（1955-56）用于对后来之己的预先承诺；Schelling（1960）用于对他方的约束，或威胁或承诺。"
- **What was done:** Taken.

**L8 (low).** /Users/ren/tmp/cw/kit/make_record.py:94-95 (does_not_show)

- **Problem:** "needs learning and deferral" is right but leaves out irreversibility: the sources describe the value as learning conditional on deferring an irreversible step, vanishing if that step is taken now. "Values are fixed" is also only part of the reason it is not captured; the module's own statement that there is no time in `reach` is the other part, as live 08 line 516 says for covering. Read: secondary sources only (search excerpts of Costello and Kolstad, Saphores, and the Toulouse papers on the Arrow-Fisher model); Arrow and Fisher 1974 itself not reached.
- **Replacement:** en: "A chooser who learns across a deferred irreversible step: values are fixed and there is no time in what it reaches, so quasi-option value is not captured; nor refusal at a price." zh: "跨越被推迟之不可逆一步而学习的选择者：此处赋值固定、所及中无时间，所以未捕捉准选择价值；也未涉有代价的拒绝。"
- **What was done:** Taken.

**L9 (low).** /Users/ren/tmp/cw/kit/apply_cw.py:82 (KNOWN); /Users/ren/tmp/cw/NOTE.md:36

- **Problem:** Names missing from the known-results line. (1) Braess's paradox (1968) is the closest named statement of the `Restraint` shape: an added option lowers what every player reaches at equilibrium. Read: popular expositions only. (2) Luce appears in the Lean header and record, but not in 08's bullet, though home-07 uses the reading "too small to tell apart". (3) The thesis the witness stands against, "more options are better", has a philosophical locus in G. Dworkin, "Is more choice better than less?" (1982). That is remembered only; my search returned nothing on it, so verify it before citing. Separately, "positional concern" and "enough" have obvious named neighbours (Hirsch 1976, Frank 1985; Frankfurt 1987, Simon 1956), also remembered only. [AI reading, new] here means unregistered (08 line 66), not novel, so those labels are not themselves an overclaim.
- **Replacement:** Append to 08 KNOWN after the prisoner's dilemma clause: "; widening a shared menu so that each reaches less at equilibrium is also the shape of Braess's paradox (1968)". Replace "The rest is the Pareto relation over self-concerned orders and an order's verdict made uniform." with: "The rest is the Pareto relation over self-concerned orders and an order's verdict made uniform; steps too small to tell apart are the idea of Luce's semiorders (1956)."
- **What was done:** Taken. Braess and Luce are in 08's line. G. Dworkin (1982) was the one remembered citation worth using, and a search confirmed its bibliographic details and its target (Midwest Studies in Philosophy 7, 47-61); it is cited by its listing only and said to be. Hirsch, Frank, Frankfurt and Simon were not added: remembered only, and the [AI reading, new] labels are not an overclaim.

**L10 (low).** /Users/ren/tmp/cw/kit/make_record.py:102-103 (validation_scope)

- **Problem:** "Attributions from reading, not all checked against the sources" should say what was done, now that a check has run, by AGENTS' rule to say exactly what was done. The replacement stays under make_record's 600-character cap by my estimate, about 545 characters; I did not run it, so check the printed count.
- **Replacement:** en: "Attributions checked by an AI reader (READER in the study folder): Strotz, Foster, and Nehring and Puppe read in the source; Kreps, Luce, Gul and Pesendorfer 2001, Schelling, and Arrow and Fisher through abstracts, excerpts or others' accounts." zh: "文献由 AI 读者核对（见研究目录 READER）：Strotz、Foster、Nehring 与 Puppe 读原文；Kreps、Luce、Gul 与 Pesendorfer 2001、Schelling、Arrow 与 Fisher 经摘要、摘录或他人转述。"
- **What was done:** Taken, with Braess and Dworkin added to what was checked and how.

*What this reader checked:* Read in the source: Strotz 1955-56, Foster 2011 (OPHI WP35) and the abstract of Foster 1993 (WP34), Nehring and Puppe's working paper 97-7 (selected pages), Dekel-Lipman-Rustichini 2001 on Kreps, Gul and Pesendorfer 2004, and the opening of Dekel and Lipman 2012. Not read in full: Kreps 1979 (abstract plus those accounts; JSTOR and scispace yielded no text after a retry), Gul and Pesendorfer 2001 (search excerpts; the NYU PDF did not render), Luce 1956 (abstract, with the conditions from Wikipedia and memory), Schelling (quoted passages in secondary sources), Arrow and Fisher and Mensink and Requate (secondary accounts and listings), Braess (popular expositions), and from memory only Dworkin 1982, Hirsch, Frank, Frankfurt, Simon and the results on binding agreements and repeated play. Found no fault: the Restraint table is a prisoner's dilemma, mutual best response is the pure Nash condition, the no-self-control reading fits and Gul and Pesendorfer identify it with Strotz, quasi-option value does need learning and deferral, the first half of the Luce sentence is fair, and refusal as a default is apt; I checked the semiorder claim by enumeration and the table by computation in my scratchpad, edited no repository file and ran no build or test.

## Round 3: the same reader, on the rewrite after the two lenses

Read only. I ran no build, test or checker, and none of the replacement text below has been compiled. Line numbers refer to the current files:
- LEAN = `/Users/ren/tmp/cw/tree/Becoming/RoutesToC.lean`
- HOME = `/Users/ren/tmp/cw/kit/home-07.md`
- NOTE = `/Users/ren/tmp/cw/NOTE.md`
- RECORD = `/Users/ren/tmp/cw/kit/make_record.py`
- APPLY = `/Users/ren/tmp/cw/kit/apply_cw.py`
- READER = `/Users/ren/tmp/cw/kit/READER.md`

**Totals:** one high (66) and five new mediums (67–71). 50 is not fixed and 49 and 60 are partly fixed. The rest of 43–65 are fixed.

## 1. Status of findings 43–65

| # | Status | Where |
|---|---|---|
| 43 | fixed | RECORD L67–68; APPLY L31–33, L54–55, L64–65 |
| 44 | fixed | HOME L2; LEAN L25–29, L218–220; RECORD L28–29; NOTE L15, L51; APPLY L47–48 |
| 45 | fixed | HOME L15; LEAN L48–50, L402–404; RECORD L34–35; APPLY L50–51 |
| 46 | fixed | HOME L19, L21; LEAN L62–72; RECORD L40–41; NOTE L40, L42. The living clause is in NOTE L40; HOME carries it as "every claim counted" |
| 47 | fixed | RECORD L109; HOME L2; APPLY L64–65 |
| 48 | fixed | APPLY L79–80; NOTE L48, L52 |
| 49 | **partly** | RECORD L111–112 is right. NOTE L3 and READER L3 promise what was done about each finding, but "What was done" occurs nowhere before READER L455 |
| 50 | **not fixed** | APPLY L86 still says "including". The literature check's L2 replacement brought it back; see section 2 |
| 51 | fixed | APPLY L26, L47, L64, L65 |
| 52 | fixed | APPLY L89; NOTE L52 |
| 53 | fixed, differently | APPLY L64–65 |
| 54 | fixed | LEAN L755–759; NOTE L17 |
| 55 | fixed | LEAN L24–25; HOME L2 |
| 56 | fixed | LEAN L44–48; HOME L8, L15; NOTE L25, L38 |
| 57 | fixed | NOTE L36, L44 |
| 58 | fixed | LEAN L104–106; HOME L24; RECORD L52 |
| 59 | fixed | HOME L22; RECORD L90; NOTE L44 |
| 60 | **partly** | HOME L15 has one item and values fixed. "Its being there at all" is only in LEAN L132, RECORD L74 and NOTE L56 |
| 61 | fixed | NOTE L15 |
| 62 | fixed | LEAN L8 |
| 63 | fixed | APPLY L24, L27–28 |
| 64 | fixed | NOTE L56 matches LEAN L130–135; HOME L11; NOTE L28 |
| 65 | fixed | RECORD L148–152, L163 |

## 2. What the rewrite got wrong, and entries that do not match

**Finding 50 came back.** The replacement is under finding 50 in section 3.

**C7 introduced a false clause.** The rewording of the cold reader's sentence is finding 66. C7's reason, "§5 compares courses of one law", also does not fit the cited law. 07 says "two courses of one law" only of the possibility reading. `Ranking.restraint_ranks_over_drawers` has two flows, `L` and `L'`, on `U w` and `U w'`.

| Entry | What it says | What the files have |
|---|---|---|
| C1 | "here" added to "no route gives C…" | LEAN L139–140 and RECORD L92–93 lack it; HOME L4 and NOTE L19 have it |
| C12 | taken in prose | RECORD L72–73 still says "the one-step law" and "一步之律" |
| C18 | taken | LEAN L664's docstring heading stays unqualified: "No standpoint's order need be increasing in admission" |

All the other "What was done" entries match the files.

## 3. New findings

### High

**66. The §5 contrast is false about what the cited law compares.** Locations: HOME L21; NOTE L42; RECORD L165.
- "There what is compared is what each course admits" holds only of the possibility reading.
- The clause it follows, "includes an event overdraw withholds", and `restraint_ranks_over_drawers` are whole-run. That reading includes events active and not consuming (`wholeRun`).
- The sentence drops the reading. With a third formation sharing, §5's table has stepwise not ranked.
- "The one case" is unshown. §5's table has other rows, such as sharing above winning by consumption.
- "So a wider menu of acts is not as such a wider course" has no support from a section that states no menu. It sits awkwardly beside "nor shown not to be", and it leans toward dismissing the witness.

Replacement, HOME L21:

> The case the account compares as courses in `[§5](#r-ranking-under-readings)` runs the other way. Under the whole-run reading, with the hypotheses stated there, a restrained course extends overdraw exactly when it includes an event overdraw withholds, and every comparison satisfying C then ranks it higher; the two-part family is ranked so under all three readings, and with a third formation sharing the stepwise reading leaves it unranked. There what is compared is the events a reading includes (active and not consuming under the whole-run reading; admitted, active or not, under the possibility reading) and not what is open to act, and no menu is stated, so that case does not say what a wider menu of acts is as a course. It does not show that no wider course has this shape.

Replacement, NOTE L42:

> The case the account compares as courses in 07 §5 runs the other way (`Ranking.restraint_ranks_over_drawers`, under the whole-run reading): what it compares is the events a reading includes, or under the possibility reading what each course admits, and not what is open to act, which does not show that no wider course has this shape.

Replacement, RECORD L165 en:

> A case the account compares as courses runs the other way from the menu witness: under the whole-run reading, with the hypotheses there, the restrained course extends overdraw exactly when it includes an event overdraw withholds; what is compared is the events a reading includes, not what is open to act, which does not show that no wider course has the witness's shape.

Replacement, RECORD L165 zh:

> 理论以进程比较的一例与菜单之见证方向相反：整段读法下（依其假设），节制的进程扩展过度汲取，恰当它包含后者所扣下的事件；所比较者是读法所记入的事件，不是可行之举；这并不表明无更宽的进程有见证之形。

The zh terms 整段读法, 节制 and 扣下 come from the `ranking-under-readings` record. RECORD L165 now uses 克制.

### Medium

**67. "Wanting only the argument that what each gets there is good for life" overstates the witness.** Location: HOME L21. T8's refuter is a pure closing argued good for life. What each gets by the payoffs, at one solution concept, is not that argument, and what the closing closes is itself counted under the condition's scope. The replacement is combined with 68.

**68. "C never ranks such a closing above (`Web.not_widens_of_closes`)" is stronger than the Lean.** Locations: HOME L21; NOTE L42.
- The theorem says only `¬ W.Widens l l' ∧ ¬ W.Keeps l l'` on level paths, with no order in it.
- This section reads C as a condition on orders, and the total relation meets C and ranks the closing above.
- The wording copies 07's table at L343, which is fine there. It is inexact here, beside "an order meeting C… It may rank more".

Replacement, HOME L21:

> If one has, the witness stands against C there too, and the narrower course is a closing from which each gets more. Such a closing neither widens the other nor keeps it (`Web.not_widens_of_closes`, on level paths), so C does not ask that it be ranked above, and an asymmetric order meeting C ranks it below. T8 names a pure closing argued good for life as what refutes T8 (`[§8](#theses)`): the witness would have that refuter's shape. What it would still want is the argument that the closing is good for life, what it closes counted; that each gets more by the game's payoffs is not yet that argument.

Replacement, NOTE L42:

> …and the narrower course is a closing from which each gets more: it neither widens the other nor keeps it (`Web.not_widens_of_closes`), so C does not ask that it be ranked above, and T8 names a pure closing argued good for life as what refutes T8, so the witness would have that refuter's shape, still wanting the argument that the closing is good for life, what it closes counted.

**69. Two lists claim exhaustion beyond what is shown.**

(a) APPLY L89, 08: `"weaker" can mean there only at other data or in scope`. "Only" holds for implication among orders, not for premises of other types or for being easier to warrant. Replacement:

> Beside what reads no order and holds, a premise that gives C implies it, so no order meets it and fails C there; it can be weaker at other data or in scope, and beside what reads an order it can be weaker at one datum (`[07 §4.4](07-SIGNIFICANCE.md#r-what-would-give-c)`).

(b) NOTE L17: "has to say which it means" followed by four senses, leaving out HOME's third. Replacement:

> So a claim of "something weaker" has to say what it means. The senses met here: weaker across data; weaker in scope, C over a listing's frame being less than C over all of what it compares; weaker at a datum beside help that reads an order; strictly weaker and not giving C with that help; or not weaker at all, the same strength read differently. Being easier to warrant is another sense, and not a Lean question.

Then "The parts of the one-item law have the third" stays true. "The chooser route has the last" also stays true.

(c) RECORD L120 zh says "只余" where the en says "has… open". Replacement:

> 在不读次序的助力旁，"更弱"尚可在别的数据或范围上

**70. "C's comparison reads what is admitted, each chooser's what it gets" misdescribes two of the three witnesses.** Locations: LEAN L62–65; HOME L19; NOTE L40; RECORD L40–41; APPLY L53. In `Refusing` the chooser is unchanged and a net weighting falls. In `AnotherReads` the chooser gains, and what it takes stands lower in another's order. "The reading order… falls" is also not what `reading_falls` says.

Replacement for the falling clause:

> while the net weighting falls, what the chooser takes stands lower in the reading order, or what each gets falls

zh:

> 而净加权下降、选择者所取在读结果的次序中更低，或各自所得下降

Replacement for the reading clause:

> C's comparison reads what is admitted, the other a net weighting of what is imposed, another's order or what each gets by the payoffs; neither reading is shown to be the one that counts

**71. The account's own several-chooser law is omitted, and the extension reads as if none existed.** Locations: HOME L21; NOTE L42, L56; RECORD L115, L160–167.
- `Optimum.MutualBest` already has several optimizers at a mutual best response on a flow.
- `Optimum.MutualBest.full` says restraint is no mutual best response wherever something stands beyond their families. See 05's `r-several-optimizers-drain-by-their-joint-capacity`, cited at 07 L701.
- That law compares no courses by C and does not show what each gets falling. `TwoTakers` orders by the store.
- It is still nearer than own widening within the margin. The relation between the two `MutualBest` definitions should be said, and is not.

Replacement, HOME L21's last sentence:

> The nearest laws here are two. On a flow, at `[a mutual best response of several optimizers](05-COLLECTIVES.md#r-several-optimizers-drain-by-their-joint-capacity)`, each optimizing alone by its own rising order takes its whole capacity wherever something stands beyond its family, so restraint is no mutual best response (`Optimum.MutualBest.full`); that law compares no courses by C and does not show what each gets falling. `[Own widening within the margin](#r-own-widening-within-the-margin)` has a part's widening leave the whole mixed, where C is silent. Whether the menu's shape falls under either is not shown.

Replacement, NOTE L56 and RECORD L115:

> several choosers compared by C on courses, joining `Optimum.MutualBest`, which has them on a flow, to the menu witness

Add to RECORD's related list:

```python
{'id': 'several-optimizers-drain-by-their-joint-capacity', 'detail': {'en': 'Several choosers at a mutual best response on a flow: restraint is no mutual best response, with no comparison of courses by C and no fall in what each gets shown; whether the menu witness\'s shape is a case of it is not shown.', 'zh': '流上多个选择者的相互最优反应：克制不是相互最优反应；未以 C 比较进程，也未表明各自所得下降；菜单之见证之形是否其一例，未表明。'}}
```

**Finding 50, restated (medium).** Location: APPLY L86. Replacement, which also keeps Foster's weak and strict parts apart, as L2 itself reports:

> That no chooser does worse from a course widening another and some does better is, over every valuation, the strict part of Foster's effective freedom (1993; 2011), the intersection of indirect-utility rankings, which he states is set inclusion where every preference ordering is admitted.

### Low

**72. The lapse covers what cannot lapse.** Locations: HOME L21; LEAN L67–69; NOTE L42. `Restraint.widens`, `each_falls` and `comparison_ranks_wide` are theorems on that frame. Showing that no wider course has the shape would not end the witness against "more options are better"; it would confirm that C is not that reading. Replacement:

> The witness is a theorem on that frame, and there it stands against reading C as "more options are better"; that does not lapse. Its bearing on this route for courses of what can form, and on C, stands until the full account is shown to remove it, by showing that…

**73. "At a datum" needs a premise that reads the datum.** Locations: HOME L2; LEAN L22. In Lean, `premise`, `frame` and `living` are not indexed by `d`, so a premise that does not read the datum and gives C once implies C everywhere. Replacement:

> It can, where it reads the datum as self-concern reads a marking, give C at one datum and be strictly weaker at another;

**74. The colon in the first law reads as a closed list.** Location: RECORD L25–26. Replacement: "…enough for C there. It can give C at one datum…", and in zh a 。 for the ：.

**75. Add "here".** LEAN L139–140: "No route here gives C…". RECORD L92 en: "no route here gives C"; L93 zh: "且此处没有哪条路给出".

**76. "One-step law".** RECORD L72: "the one-item law". L73: "一项之律".

**77. "A premise of neutrality across items" is too narrow.** Locations: HOME L23; LEAN L96. `AboveNothing` is blind to the item and still has two verdicts. Replacement: "a premise of neutrality across items and across what they are added to".

**78. Unqualified docstring heading.** LEAN L664. Replacement: "**A standpoint whose marking leaves a listed item need not have an order increasing in admission.**"

**79. Decidability is missing from the label.** Location: HOME L2. 08's rule lists "decided". Add to the Theorem parenthesis: "equality of items decided in the range's, covering and one-item laws".

**80. `choosers_mixed` is in the record but not the home.** It is at RECORD L31 and L33, and in LEAN, but neither HOME nor NOTE states it. Add to HOME L15: "On a mixed pair each course is better for some chooser (`Weighting.choosers_mixed`)."

**81. "Read in the source" is broader than what L2 and L3 report.** Locations: RECORD L111–112; APPLY L86. The reader read selected pages of Nehring and Puppe's working paper, and Foster through OPHI WP35 and WP34's abstract. Replacement: "Strotz read in the source; Foster in his working papers (OPHI WP35, WP34's abstract); Nehring and Puppe in selected pages of working paper 97-7;". The scope field stands at 472 of 600 by my count.

**82. The dispositions promised for 43–65 do not yet exist (finding 49).** NOTE L3's claim becomes true only if this report's status table and dispositions for 66 onward go into READER.

**83. README rows lack "over every valuation".** APPLY L64–65. Add it after "exactly when", and in zh "遍及每个赋值时".

**84. "The first witness stands with the third" has no link to T5.** Location: HOME L19. `imposed_below` is the negative valuation T5 already names. Add: "(the negative valuation `[T5](#theses)` names; `[a narrowing above its widening](#r-a-narrowing-above-its-widening)`)".

## 4. Your five questions

**1. "Strictly weaker".** Clean, apart from low 73.
- The sentence follows from `ReadsNoOrder.not_strictly_weaker`, and its scope matches. The theorem is in fact stronger, since it does not use "C implies it" and needs no extension.
- "Strictly weaker" exists only in prose. No Lean definition states it, and I do not ask for one.

**2. The three routes.** HOME L2 and LEAN L22–24 are modal and witnessed as far as they claim.
- The first case is witnessed by self-concern.
- The third is witnessed by `StepAlike` (`ranksLighter_*`).
- "Weaker in scope" has no Lean relation behind it and is an informal sense, labelled as such in effect.
- The exhaustive claims are elsewhere: 69(a), 69(b) and low 74.

**3. T8, `Web.not_widens_of_closes` and §5.**
- T8's refuter is quoted exactly.
- "Pure closing" has no definition beyond T8 and its restatements. Reading the narrower course as one is a reading, and it sits under the paragraph's AI label.
- The `Web.not_widens_of_closes` sentence is not exact (68).
- The §5 contrast is not exact (66).
- No sentence dismisses the witness outright. Two lean toward dismissing it: "not as such a wider course" (66) and the lapse (72).
- "Wanting only" (67) overstates it.

**4. The Conditional label.** Right.
- At the witnesses, C is a hypothesis in the three `comparison_ranks_wide` theorems.
- In the last route, self-concern, P2 and P4 are hypotheses, with precedent at 07 L238.
- The first law, the frame laws and the Pareto laws take C or self-concern inside an `↔` or a quantifier, so Theorem is right for them.

**5. English and Chinese.** I compared the statement, laws, hypotheses, does_not_show, counterexamples, related, correspondence, validation_scope, next_delta, history and both README rows.
- They say the same thing except 69(c).
- One small difference at RECORD L119–120: en says "and of temptation", zh says "亦即".
- Field lengths by my count: statement 299/300, scope 472/600, next_delta 281/400.

## What came up clean

- Every declaration in RECORD exists in LEAN.
- The new `comparison_ranks_wide` theorems have the right direction.
- `Refusing`, `AnotherReads` and `Restraint` say what the prose says, apart from 70.
- The `ranksOnlyMany` semiorder sentence holds by my own check: a 2+2 from four items, none on three.
- The chapter anchors cited exist.
- APPLY's three new chapter strings each match once: the 07 pointer, 08's verdict sentence and 08's covering line. So do the 07 "weaker" sentence, the home-section insertion anchor and the 08 known-results anchor, and the covering record's zh string matches too.
- Nothing says C is derived, that the condition gives it, or that anything is new mathematics.
- "Direction" is not used for C.

## What I read and did not

**Read in full:**
- LEAN, plus its diff against `/Users/ren/tmp/cw/old/RoutesToC.round2.lean`
- HOME, NOTE, RECORD and APPLY
- READER L455–663

**Read in part:**
- READER L1–16, L261–272, L300–309 and L374
- 07 L226–256, L340–346, L359, L530–541, L592, L650, L701, L742, L751 and the objections table
- 08 L49–76 and the start of L516
- 05 L215 and L232–234
- JointDraw L40–52 and L195–226
- Optimum L88–104, L1845–1868 and L2135–2200
- Weightings' `not_widens_of_closes`
- the records `ranking-under-readings`, `what-a-course-keeps-reachable` and `several-optimizers-drain-by-their-joint-capacity`, printed and truncated

**Not read this round:**
- `PremiseWitnesses`, `Extension` and the grammar modules; I used their statements from rounds 1 and 2
- `patch_kit.py`, `patch_note.py`, `header.lean.txt`, `lenses.json` and `append_lenses.py`
- any literature source, so attributions rest on the literature reader's account
- 05's law in Lean beyond the lines above, so finding 71's "does not show what each gets falling" comes from those lines, `TwoTakers` and the record's text

### What was done about round 3

The status of findings 1-42 is in round 2's table above and that of 43-65 in the table above in this round; together with what follows, that is the disposition finding 82 asked for.

- **50 and 49.** 50 taken as restated, in 08's line. 49 is met by this list.
- **60.** Taken: the home says a chooser's being there at all is fixed too.
- **66 (high).** Taken as given in the home, the note and the record's related entry. It was the author's error, introduced in rewording the cold reader's C7, and the old sentence's reading was checked against §5's table before the replacement went in.
- **67, 68.** Taken together. The home and the note no longer say C never ranks such a closing above, or that the witness wants "only" an argument about what each gets.
- **69.** (a), (b) and (c) taken as given.
- **70.** Taken in the Lean header, the home, the note, the record's law and the checker's scope.
- **71.** Taken in the home, the note, the record's related list and its next step. The relation between the two `MutualBest` definitions is said only as far as shown: one on a flow, one from a menu, and whether the menu's shape falls under the first is not shown.
- **72.** Taken, keeping that the witness is what C does on that frame.
- **73.** Taken in the home and the Lean header; the record says "where it reads the datum".
- **74-81, 83, 84.** Taken as given.
- **82.** Done here.

## Round 4: the same reader, on the diff

**No high or medium finding remains.** All of 50, 60 and 66–84 are fixed. Nine low findings remain, listed below; by your rule this round ends the readings, and none of the lows needs another one.

I ran no build, test or checker, and none of the replacement text has been compiled. Line numbers refer to the current files:
- LEAN = `/Users/ren/tmp/cw/tree/Becoming/RoutesToC.lean`
- HOME = `/Users/ren/tmp/cw/kit/home-07.md`
- NOTE = `/Users/ren/tmp/cw/NOTE.md`
- RECORD = `/Users/ren/tmp/cw/kit/make_record.py`
- APPLY = `/Users/ren/tmp/cw/kit/apply_cw.py`
- READER = `/Users/ren/tmp/cw/kit/READER.md`

## 1. Status of findings

| # | Status | Where |
|---|---|---|
| 50 | fixed | APPLY L91 |
| 60 | fixed | HOME L15 |
| 66 | fixed | HOME L21; NOTE L42; RECORD L165 (en, zh) |
| 67 | fixed | HOME L21; NOTE L42 |
| 68 | fixed, with one slip in my own replacement (85) | HOME L21; NOTE L42 |
| 69 | fixed, with one slip in my own replacement (86) | (a) APPLY L94; (b) NOTE L17; (c) RECORD L120 |
| 70 | fixed | LEAN L64–67; HOME L19; NOTE L40; RECORD L40–41; APPLY L53–54 |
| 71 | fixed | HOME L21; NOTE L42, L56; RECORD L115–116, L166 |
| 72 | fixed | LEAN L68–74; HOME L21; NOTE L42; RECORD L40–41, L100–101 |
| 73 | fixed | HOME L2; LEAN L22–23; RECORD L25–26 |
| 74 | fixed | RECORD L25–26 |
| 75 | fixed | LEAN L141–142; RECORD L92–93 |
| 76 | fixed | RECORD L72–73 |
| 77 | fixed | HOME L23; LEAN L98–99 |
| 78 | fixed | LEAN L666 |
| 79 | fixed | HOME L2 |
| 80 | fixed | HOME L15 |
| 81 | fixed | RECORD L111–112; APPLY L91 |
| 82 | fixed | READER L915–929 |
| 83 | fixed | APPLY L64–65 |
| 84 | fixed | HOME L19 |

## 2. What the diff got wrong, and the dispositions

**Nothing false was introduced.** Three sentences came out worse, and each is a low below:
- "The last" in NOTE L17 (86), which my round 3 note wrongly said would stay clear.
- "That help" in NOTE L17 (86), from my own replacement.
- "This" in NOTE L42 (87), whose referent moved when a sentence was inserted before it.

**Every disposition in READER L915–929 matches the files.** Two "as given" entries are harmless rewordings:
- 84 is phrased as "whose item below zero is the negative valuation T5 names".
- 81 is shortened in APPLY L91.

READER L501 now says C7's rewording and its reason were wrong, which disposes of my round 3 point on "courses of one law".

**The round 3 baseline differs from what I read in two places.** I compared `/Users/ren/tmp/cw/old/round3/` with my own earlier reads:
- RECORD's statement is trimmed from "and some does better from" to "and some better from". It is still exact, and it now counts 299 of 300.
- `old/round3/apply_cw.py` already contains the Open bullet, so the diff does not show it. I read it directly at APPLY L84–87 (finding 92).

## 3. New findings

### High and medium

None.

### Low

**85. "An asymmetric order meeting C ranks it below" is mis-scoped.** Location: HOME L21. The wording is mine. Every order meeting C ranks it below, and asymmetry is what stops an order ranking it above as well. Replacement:

> so C does not ask that it be ranked above: every order meeting C ranks it below, and an asymmetric one does not also rank it above.

**86. Two slips in the list.** Location: NOTE L17.
- "With that help" now attaches to help that reads an order, which is the opposite of HOME's case. Replacement: "strictly weaker and not giving C with help that reads no order".
- "The last" now follows "Being easier to warrant is another sense". Replacement:

> The chooser route is the same strength read differently, with an `↔`, and so is the one-item law among transitive orders.

"The third" and "the first two" stay right.

**87. "This" now points at the wrong thing.** Location: NOTE L42, last sentence. It follows the new sentence on `Optimum.MutualBest.full`, which is already a drain law. Replacement:

> Whether the menu's shape is the shape of T3's drains is not shown here.

**88. "Which would say" attaches to the menu witness.** The zh is already clear. Replacements:
- NOTE L56: "…to the menu witness, to say whether `Restraint` bears on C and on T3;"
- RECORD L115: "…to the menu witness, to say whether it bears on C and on the drains;"

**89. RECORD L163 says more than HOME and L166.** This one predates the diff; it comes from my own finding 65, and I missed it in round 3. The new L166 puts it beside "is not shown". L163 says the menu witness "is a different shape", while HOME L21 says whether it falls under either law is not shown.

Replacement en:

> A part widening what can form within its own region, the whole mixed beyond the others' margins, where C does not rank it; whether the menu witness's shape, two choosers on one menu at the pure Nash equilibrium of one play, falls under it is not shown.

Replacement zh:

> 部分扩大其区域内可成者，超出他者余量时整体为混合，C 不排它；菜单之见证之形（两个选择者在同一菜单上、一次博弈的纯策略纳什均衡处）是否落入其中，未表明。

**90. Referents after the §5 insert.** Location: HOME L21. "That frame" now follows §5's sentences, and §5 has a frame of its own. "This shape" is used before it is defined. Replacement:

> It does not show that no wider course has the menu's shape. The menu witness is a theorem on the listing's frame, and there it stands against…

The later "has this shape:" stays, since that is where the shape is defined.

**91. The flow law's qualifiers are dropped.** Location: HOME L21. 05 L215 and 07 L673 keep them. Replacement:

> On a flow, with balance at the step, at `[a mutual best response of several optimizers](05-COLLECTIVES.md#r-several-optimizers-drain-by-their-joint-capacity)` (its existence not shown in general), each optimizing alone…

**92. The Open bullet drops a label and a qualifier.** Location: APPLY L85–86. Its first sentence is exact and matches HOME. Its second sentence is a reading that HOME labels and qualifies, and 08's Open label asks what would show it. Replacement:

> - **The menu's shape on courses** (`[§4.4](#r-what-would-give-c)`): whether a course of what can form can widen another while, at the pure Nash equilibrium of one play among those choosing within it, what each gets falls. [AI reading, new] If one can, the menu witness stands against C there, with the shape of T8's refuter, still wanting the argument that the closing is good for life; if none can, that removes its bearing on courses.

**93. "Covering" in the label has no referent in the home.** Location: HOME L2. §2 of the chapter uses the word in another sense. Replacement:

> equality of items decided in the range's, the standpoints' and the one-item laws

Cosmetic: LEAN L23, L99 and L666 are long unwrapped lines from this diff, longer than the header's others.

## What came up clean in the diff

- **§5 replacement:** the readings and table rows agree with 07 L530–541.
- **T8:** "as what refutes T8" is exact.
- **`Web.not_widens_of_closes`:** it is now stated with its level paths and as what C does not ask.
- **Foster:** the strict part and the intersection are kept apart.
- **Record caps:** statement 299 of 300, validation_scope 563 of 600, next_delta 336 of 400.
- **Zh against en:** every changed record field and both README rows say the same thing.
- **Applier:** the Open bullet's anchor occurs once in live 07.

## What I read and did not

**Read:**
- line diffs of LEAN and APPLY, and word diffs of HOME, NOTE and RECORD
- each changed passage in full: HOME L19 and L21; NOTE L3, L17, L40, L42, L56 and L60; RECORD L25, L40, L67, L88, L100, L111, L115, L163 and L166; LEAN L20–26 and L62–76
- READER L915–929, L501 and the opening of L665–676, plus the diff of READER against round 3, which shows one changed line and the appended text
- 07 L780–790, for the Open list

**Not read:**
- unchanged text, beyond this context
- READER's appended round 3 text, which I did not compare word for word with my report
- the Lean bodies this round, the Lean evidence being your report of a clean build
- the record or checker output from your scratch run
- any literature source

### What was done about round 4

No high or medium remained, so the readings ended here; the changes below were not read again by this reader. 85-93 taken as given, 91 and 92 worded as replaced. The long Lean lines were rewrapped. The Lean was rebuilt and bound at the core run, which is the evidence for it.

## A last check: the same reader, on the lines the gate listed

The landing's gate failed on three things: links in these reports, read as live; the review packet's dossiers quoting two 07 sentences the applier had reworded; and no region for the new record. The links are printed as code, each of the two sentences is restored word for word with the new matter after it, and the record and module have regions. The reader then read the lines that restate the new section.

None: no high or medium in the five lines. Lines 233 and 345 say what the home says, and each restored sentence appears word for word with the new matter after it.

**Two lows, neither blocking:**

1. **07 line 345, second "it".** With the sentences split, "it meets C, so it is weaker" uses "it" for two things, and the second reads as the order. Only the first sentence is quoted elsewhere, so the second can change. Replacement:

   > On a listing's frame, every claim counted, an order is increasing in admission exactly when it meets C, so monotonicity at the standpoint is weaker only in scope, a listing and not all of what can form (`[below](#r-what-would-give-c)`).

2. **08 line 551, "at other data".** It drops the home's "where it reads the datum". It is still true as a "can", so this one is optional. Replacement:

   > it can, where it reads the data, be weaker at other data, or be weaker in scope, and beside what reads an order it can be weaker at one datum

**Each line against the home in the worktree:**
- **07 line 233:** "each route reading an order" matches the route table, and the link and "there" both land in §4.4 at line 362.
- **07 line 345:** "weaker only in scope" holds in the home's sense of scope.
- **07 line 811:** the question matches the shape in line 382, and the "[AI reading, new]" label is kept. "Still wanting the argument" and "removes its bearing on courses" both match line 382.
- **08 line 517:** matches line 387 and the home's reading of each witness.
- **08 line 551:** apart from low 2, matches the first paragraph of the home.

**What I read:**
- In `/Users/ren/tmp/cw/land/theories/becoming/chapters/07-SIGNIFICANCE.md`: lines 233, 345, 362–364, 382 from "It does not show" to its end, 387 and 809–812. The 26 lines from the anchor at 362 are identical to `/Users/ren/tmp/cw/kit/home-07.md`.
- In `/Users/ren/tmp/cw/land/theories/becoming/chapters/08-METHOD.md`: lines 517 and 551.

**What I did not read or run:**
- I ran no build or gate.
- I did not open the dossiers. I only searched for which files carry the two sentences, so "word for word" rests on your wording and the live lines, not on comparing them with the quotes.
- The rest of 07 and 08 was not read for this check.

### What was done

Both lows taken as given.
