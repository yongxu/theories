# Boundaries, read in one account (board item BD)

31 October 2026. Ren asked what a boundary is, whether it is "just a collection of relations", and what it is in a nondual sense ([source](../../../../../../sources/15-codex-theory-conversations/2026-10-31-what-is-a-boundary.md)). This note gathers what the account already proves about boundaries and writes one reading on it. **Purpose:** shared understanding with human readers (RP). Any reader of a nondual account asks what becomes of inside and outside, and the method asks every distinction to state its relational basis ([08 §1](../../../../../../theories/becoming/chapters/08-METHOD.md)); inside and outside had none stated. **Scope:** texts only. No Lean, no record, nothing proved changes and no theorem is renamed.

## 1. What the account already states

Each item is given as its home section states it, with the declarations read in the package (`experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`).

1. **The definition** (07 §4.1, record [presupposition-scopes](../../../../../../theories/becoming/results/records/presupposition-scopes.md), `Boundaries.lean`). `Boundary rel f region := ClosedUnder rel region ∧ region f`: along a relation, a boundary of `f` is a region holding `f` that the relation does not leave. The closure is a boundary (`Boundary.closure`) and every boundary holds it (`Boundary.holds`), so it is the least. The whole is the greatest (`Boundary.whole`). A boundary along a larger relation is one along a smaller (`Boundary.of_larger`). Where everything lies within `f`'s closure, the whole is the only boundary (`Boundary.only_whole`).
2. **One closure and its levels** (01 §9.9, record [levels-of-closure](../../../../../../theories/becoming/results/records/levels-of-closure.md)). The closure is the least closed region holding a point, and a process's reach is the same closure under its steps. The feeding closure lies within the influence closure, and the influence and reach closures within the system. In witnesses each inclusion is strict, and influence and reach point opposite ways. `Flow.system_whole_of_common`: where every formation takes part in one condition, every formation lies within every formation's system, and `WithinSystem` is `WithinClosure (L.Shares W)`.
3. **Conveyance crosses the boundary** (04 §1, record [conveyance-crosses-the-boundary](../../../../../../theories/becoming/results/records/conveyance-crosses-the-boundary.md), `Standpoints.lean`). `Cut V region := ∀ e e', region e → ¬ region e' → ¬ V.related e e'`. `Flow.boundary_crossed` assumes balance, dissipation, a family `ds` of conditions without repetition, decided equality, enclosure around `ds` from some `T₀` on (`Around`) and formations taking from `ds` at arbitrarily late steps. Under these, for every `N` it is not the case that from `N` on nothing outside `ds` is related by conveyance to a member (`Flow.region_not_a_cut`: the region is no cut). Beneath it, `Flow.fed_from_beyond` (`Continuation.lean`) states the direction: something beyond the family is conveyed into a member.
4. **The blanket** (03 §1, record [the-markov-blanket-as-a-coupling-structure](../../../../../../theories/becoming/results/records/the-markov-blanket-as-a-coupling-structure.md)). Take four parts of one determined law, told apart only by which part's next state reads which. Each side's course is fixed by its start and the blanket's (`Blanket.Blanketed.internal_through_blanket`). The record does not show that a World formation in general is the agent of a blanketed law. UE26 (blankets at a steady state) is on its own branch, not on main.
5. **A change between the ends has a place** (01 §3, `«两端分则中有标»`). Take a transitive `K`, with every step of continuation either keeping `K` or carrying a mark `P`. Then a line whose ends `K` tells apart has a step carrying the mark between them.
6. **The overlap witness** (01 §8.7, record [the-source-texts-test-systems](../../../../../../theories/becoming/results/records/the-source-texts-test-systems.md)). Two identities are each a class; their union is not, and its line drifts (`Overlap.continues_each`, `Overlap.tolerance_line_apart`). A vague boundary appears only as a relation that is not a class. A graded boundary is on 01's open list.
7. **Beyond a region** (07 §2, record [loss-beyond-a-region](../../../../../../theories/becoming/results/records/loss-beyond-a-region.md); 02 §3.1, record [represented-boundary-against-dependence](../../../../../../theories/becoming/results/records/represented-boundary-against-dependence.md); 03 §1, `Flow.unselected_beyond_coupling`). The smaller the region, the more lies beyond it. In `Clearing` the clearer closes nothing within itself and its source and closes the dweller beyond them (`Clearing.loses_beyond`). Omitting a required condition, a formation's own draw can lose its own support (`Omitted.loses_own`). Under balance on what couples in, every selection through the couplings of a formation within the coupling closure treats alike the levels with and without a part beyond it.
8. **Readings already adopted.** D61 (3) reads what a selection reaches, what a test can exclude, what the step across standpoints forces and what the neutralities force as one law: each is the closure of a relation. D45 (2) reads "everything exists in between" (the self and the whole) as the nesting of the closures. D65 (13), in 04 §8, says that a body's ecological participation crosses its anatomical boundary.

## 2. The reading

**Home:** 01 §9.9, after the closure laws, as an added paragraph with the anchor `boundaries`. The definition stays where its record is (07 §4.1); the root is where a reader meets wholes, parts and closures. **Label:** [AI reading, D45, D61]. D61 gives the closure readings, and D45 the rule that a reading stands by its place in one account.

It says six things, each resting on the laws above:

1. **One sense.** A boundary is the delimitation of a region from the rest, inside from outside, given by the region: two boundaries are one where their regions are, which is why 07 §4.1 and `Boundary` take the region for the boundary. The word is used in two ways, both of this one sense. *Within* a boundary speaks of its region. *Where* a boundary lies speaks of where inside meets outside: a configuration two courses share where they join, a tie, a threshold, or 02 §1's points where going on is not decided. A relation crosses a boundary where it bears something inside to something outside. Every live use has this sense once one record title is reworded (§4, the sweep), whatever the region is of: formations (07 §4.1), the conditions of a family (04 §1), or the configurations or parameters where a law's verdict holds (02 §1, 03 §8, 05 §10).
2. **Not a collection of relations.** A boundary is no further thing or relation beside what it delimits. Along a relation it is given by a region holding the formation and closed under the relation, which the relation then never crosses (item 1).
3. **Short of the whole only along a narrower relation.** Every boundary holds the closure, so what a boundary leaves out lies beyond the formation's closure under the relation (`Boundary.holds`, read contrapositively). A relation reaching everything has no boundary but the whole (`Boundary.only_whole`). A boundary short of the whole is real, since its relation never crosses it, and relative to that relation.
4. **Many per formation.** Each relation draws its own least boundary, the closure: the closures of feeding, influence, reach and sharing a condition are nested or point opposite ways (item 2). Whether the self's presupposition is held de se of a self drawn along a privileged relation narrower than being related at all is 07 §4.2's open question. P2 is not asserted.
5. **Crossed, not where everything stops.** What is ordinarily called a boundary is read as one some relation crosses. Two cases are proved: the boundary of a finite family of conditions taken from at arbitrarily late steps (item 3) and the blanket (item 4). Along a line, §3's law places the crossing (item 5, read below). A vague boundary appears only as a relation that is not a class, which delimits no regions of sameness (item 6).
6. **Beyond is not outside the unfolding.** What a drawn boundary leaves out can still be lost (item 7).

## 3. Exactness audit

- **No new theorem.** Where two laws meet, they are cited side by side and not stated as one. `Boundary.only_whole` with `Flow.system_whole_of_common` gives the whole as every formation's only boundary along sharing a condition wherever one condition is common. The reading gives both laws and asserts no composed theorem.
- **Cut and closedness are not equated.** `ClosedUnder V.related region` implies `Cut V region`. The converse needs membership in the region to be stable under double negation. No declaration states either, so the texts do not equate them. With crossing defined as relating something inside to something outside, a cut is exactly a region no formed relation crosses, and closedness gives no crossing. So the glossary and the reading say that a relation never crosses the region it is closed under, never the converse.
- **Crossing has a direction.** A region closed under a directed relation can still be entered by it from outside: the reach closure under affecting is closed, while what lies outside can affect its members. So the texts say a relation never *crosses* a region it is closed under, crossing being from inside to outside in the order of the relation's places, and never that nothing relates across it. Conveyance's relation is symmetric, so 04 §1's crossing, the family fed from beyond, is crossing in this sense.
- **The line is an instance, not a new law.** Take `K` as lying on the same side of a region, `K x y` exactly where `x` lies in it exactly when `y` does: a transitive relation, constructively. Take the mark as joining the two sides. Then «两端分则中有标» gives a step joining them, placed on the line, on every line from inside to outside, wherever every step of continuation either keeps to one side or joins the two. That is the universal law used at one relation, stated with its hypothesis, as AGENTS.md reads instantiations.
- **04 §1 is a World law.** It holds for a finite family of conditions under its hypotheses. "A membrane, read so, is a place of crossing" is marked as a reading of that law, an analogy and not an identification (DELEGATED-CHOICES §0, standard 4).
- **Self-maintenance is not claimed.** The reading does not say that a living family maintains its boundary. That is on 01's open list.
- **What the chat answer got wrong.** It drew on 01 §3, 01 §8.7 and 03 §1 and missed the definition in 07 §4.1 and the law in 04 §1. The reading leads with the definition.

## 4. The texts

- **01 §9.9:** the reading, as an added paragraph. No record citing the section's other paragraphs drifts.
- **08 §1, "Distinctions state their basis":** "inside and outside" joins the list of distinctions, linked to the reading.
- **GLOSSARY, the root table:** a row for boundary (边界) giving the one sense, with its home in 07 §4.1 and the reading in 01 §9.9.
- **The source record** of Ren's question.
- **One record title:** type-formation-gives-no-dynamics, en and zh, from "the seed's boundary" to "the seed's size bounds", with a history note, and the same words in its regions.json note. Its claim, laws and declarations are unchanged.

**The sweep behind "one sense"** (31 October, on `1721c70ef` with BD's texts). The live documents were read: the eight chapters, the overview, OPENING and the glossary, with 70 uses outside BD's paragraph. So were the titles, statements, laws and does-not-show items of the live records: 134 uses in 39 records. Each delimits a region from the rest, and the region falls in one of six kinds:
- a region of formations or events drawn around a self: 07 §2–§4, the overview, OPENING's footnotes, `Boundary`, boundary-invariance and neutrality, "a formed boundary";
- a region a relation crosses: 04 §1, 04 §8's anatomical boundary, 07 §2's "across its boundary";
- a region of renewal represented by a center: 02 §3.1, 07 §3;
- a region of states or conditions where a law's verdict holds: 02 §1 and §9, 03 §8, 05 §10, 07 §4.4 and §6, Good's equality boundary, `n q = d p`, the margin as a phase boundary;
- a region of where a statement holds: OPENING's "the exact boundary where it can hold", the records' scope items;
- the delimitation of a stretch of a run or a block: shared boundary configurations, blocks' boundaries, boundary states of an interval.

The first five kinds mostly speak of what lies within a boundary. The last, with ties, thresholds and 02 §1's undecided points, speaks of where a boundary lies. Both are the one sense. One use did not fit: the title of type-formation-gives-no-dynamics, "keeps the seed's boundary", meant the seed's size bounds (empty, inhabited, at most one element). BD rewords that title, en and zh, with a history note saying only the wording changed, and the same words in its regions.json note. No other passage is renamed.

**Why one sense, and not a word of its own.** The coordinator offered two options. One was to show the verdict's edge has the same sense, as a region the relation setting the verdict does not leave. The other was to give it a word of its own. The first fails as stated: a region of parameters (05 §10's `M ≥ 0`) is closed under no relation of the unfolding, since parameters take no steps. It holds with the sense above, a delimitation given by its region, with "where it lies" as one way of speaking of it. The second would have meant either a new term or rewording eleven passages. "Edge" already names a link of a net (`EdgeClosure`, single-edge cuts) and "frontier" an unbettered set (`Frontier`). The eleven passages are five chapter sentences in 01 §9.3, 02 §1, 03 §12, 08 §5 and 08 §8, each inside some record's home section, and six records. Nothing in them states a wrong meaning under the delimitation sense, so AGENTS.md's rule for a renaming sweep does not call for it. EL's "selection–region boundary", its "boundary law" and U4's "boundary record" are exact delimitations of where a law's verdict holds: the fourth kind.

**Before landing** (the coordinator's conditions, 31 October): one board line claiming BD in a gap with no head clause; the one sense settled in the reading, not in a row naming two uses; an independent read of the paragraph against the laws it cites and of the one-sense claim; and OU's owner, who has 01 and 08 §1 in hand for the front pages, asked about a conflict.

**The independent read** (31 October, an AI reviewer working read-only, not the author). Twelve findings. Its list of sentences verified as exact covers closedness against crossing, `Boundary.holds` read contrapositively, the five boundary laws, the levels of closure, `system_whole_of_common`, 04 §1's two laws, the blanket, the line instance and the third paragraph's three citations.
1. *Blocking: two senses, region and the points where regions or courses meet.* Taken differently from the reviewer's proposal, which named a second use. The reading now states the one sense as a delimitation given by its region and says how both ways of speaking belong to it. Its list of the points where a boundary lies takes the reviewer's examples. Of its outliers, CorrectionRelations' `Boundary` (a region given by a relation), "protective boundaries" and "boundaries in the grammar itself" (limits of where something holds) are delimitations. "The seed's boundary" is not, and is reworded, as above. The re-check of the revision found finding 1 resolved and nothing new inexact against the laws. Its minor points are taken: going on and ending are each other's rest only under excluded middle; "one exactly where their regions are one"; the glossary row's placing of 02 §1; this note's summary; and the seed's title.
2. *Crossing has a direction.* Taken: crossing bears something inside to something outside, and the text adds that along a relation that is not symmetric something outside can still bear it inward.
3. *The definition says delimitation, the text uses the region.* Taken through 1: given by the region, so the region stands for it.
4. *"Conditions" is a glossary term.* Taken: "configurations or parameters".
5. *The blanket sentence.* Taken: scoped to a determined law of four parts, the blanket given with inside and outside by the readings.
6. *The vague boundary.* Taken: the union relation, not being a class, delimits no regions of sameness, so the witness's vagueness lies in overlapping identities. A graded boundary stays open.
7. *The mark law's hypothesis covers every step of continuation.* Taken.
8. *07 §4.2's question.* Taken in its own words.
9. *04 §1's hypotheses.* Taken in full: one kind of relatum, no repetition, decided equality, enclosure around from some step on, and taking at arbitrarily late steps.
10. *"Reach" is ambiguous.* Taken: "lies beyond the formation's closure under the relation".
11. *Cut.* Taken: "04 §1's cut (`Cut`)".
12. *The label covers only the first paragraph.* Taken: each later paragraph says "on this reading".

## 5. Open, and what would change the reading

- **Open:** a graded boundary (01, Open); how a formation forms or represents its boundary (the represented-boundary record); whether some relation privileges the self's boundary (07 §4.2); a World formation as the inside of a blanketed law (03 §1; UE26). A lemma stating that a cut is a closed region where membership is decided would belong to whichever item first needs it.
- **What would change it:** a representation in which significance or dependence spreads by something other than a relation's steps, such as weights decaying along a path (D61's own condition of revision). There a boundary could be graded and not a closed region. A law of the dynamics fixing which relation a self is drawn along would also change it: point 3 would then name that relation's closure as the self's boundary.

## 6. Not going out, on the root (board item BD2)

31 October 2026. Ren asked to close the formal gap §5 left and to keep advancing the unification ([source](../../../../../../sources/15-codex-theory-conversations/2026-10-31-close-the-formal-gap.md)). **The gap:** the World's cut (`Flow.Cut`, 04 §1) was defined apart from the grammar's closed region (`«闭»`), and §2's sentence on a line crossing a region rested on a hand argument from 01 §3's mark law. **Scope:** two core modules, one changed proof, one new record, two laws added to an existing record, and texts. No definition of an earlier module changes. An independent AI review found twelve points and the grammar's owner made three; all are taken ([REVIEW.md](REVIEW.md)).

### 6.1 What is added

- **`Becoming.GrammarCrossing`** (core, imports only `Becoming.GrammarLaws`): one definition and eleven theorems, all with empty axiom reports. `«不出» R P := ∀ x y, P x → ¬ P y → ¬ R x y`: nothing in `P` goes out of it along `R`.
  - `«闭则不出»`, `«所闭不出»`: a closed region is not gone out of, an occurrence's closure among them. The second is the closure law `«所闭之界»` read through `«不出»`, and its proof is that law applied. `GrammarLaws` cannot import this module, so the two state one law twice until `«不出»` moves into `GrammarLaws` (§6.5).
  - `«不出当且仅当不外者闭»`: not going out is exactly the closedness of `¬ ¬ P`, with no decision. `«不外者内则不出当且仅当闭»`: where membership is stable (`¬ ¬ P y → P y`), not going out is being closed.
  - `«不出皆闭当且仅当排中»`: that this holds for every carrier, relation and region is exactly excluded middle. Witness: `Bool`, the relation `false → true`, the region `b = false ∨ S`. A lemma of the logic, not a calibration (§6.3).
  - `«逆之不出当且仅当外者不出»`: nothing comes in along `R` (not going out along `«逆» R`) exactly where nothing goes out of `¬ P`, with no decision. `«对称则不出当且仅当逆不出»`: along a symmetric relation the two coincide. `«闭而有入之例»`: a witness, a closed region that something outside bears the relation into, in the positive form (`∃ x y, ¬ P x ∧ P y ∧ R x y`).
  - `«内至外之线则非不出»`: a line under any class from inside to outside means `¬ «不出» R P`, with no decision; it names no step going out. `«内至外之线有出步»`: with every step of continuation keeping to `P` (`P u → P v`) or going out of it (`P u ∧ ¬ P v`), the line has a step going out, placed on the line. `«定则内至外之线有出步»`: where membership is decided, every step is of one kind or the other.
- **`Becoming.ConveyanceBoundaries`** (core, imports `Becoming.Boundaries` and `Becoming.GrammarCrossing`; a leaf, the World's case of the crossing laws): eight theorems.
  - `Flow.cut_iff_notGoingOut` (`Iff.rfl`). `Flow.cut_of_closedUnder`, and `Flow.closedUnder_of_cut` for stable membership: §5's "lemma stating that a cut is a closed region where membership is decided", needing only that it is stable.
  - `Flow.conveyance_symm`, `Flow.cut_iff_not_come_into`: conveyance's relation is symmetric, so along it nothing goes out of a region exactly where nothing comes in. `Flow.boundary_crossed` states coming in; with these, 04 §1's "crosses" is exact in the glossary's sense, bearing something inside to something outside.
  - `Flow.region_no_boundary`, `Flow.closures_not_within_region`: 04 §1's law read on 07 §4.1's boundaries.
  - `Clearing.resource_no_boundary`: the clearing's witness read the same way.
- **`«所经必同»`** (`Becoming.GrammarPath`) is proved from `«定则内至外之线有出步»`: the step going out lands in the set, and its end is alike to the start by `«线内同类»`. This is rule 9 (an existing statement derived from a grammar law, its direct induction dropped). Its statement is unchanged. `GrammarPath` has one dependent (`GrammarCases`), so the rebuild is small.

### 6.2 Choices

- **On the grammar, not on the World.** `«不出»` is defined for every carrier and relation. The World's cut is its case at a valuation's relation by definition, so no definition of `Becoming.Standpoints` changes and its eighteen dependents do not rebuild. Defining the cut as `«不出»`, rule 9's way below, would add an import to `Standpoints` now; once `«不出»` stands in `GrammarLaws`, which `Standpoints` already reaches, it needs none, so it waits for that rebuild (§6.5).
- **Keeping, not lying on the same side.** §2's sentence used the mark law with the class of lying on the same side, marking a step that joins the two sides. Such a step may enter the region rather than leave it. With keeping to the region (`P a → P b`, transitive, not symmetric) as what the ends fail, the step found goes out: from a member to something outside. The reading now cites that.
- **Stable, not decided.** The coincidence of not going out and being closed needs only that membership is stable (`¬ ¬ P → P`), weaker than decided membership. "Stable" is 01's word for this; "settled" is kept for a run that stops changing (08's LPO row). `«不出皆闭当且仅当排中»` shows that without stability nothing more holds.
- **Coming in.** The reading's clause on a relation that is not symmetric is now a witness (`«闭而有入之例»`). The symmetric case (`«对称则不出当且仅当逆不出»`) is conveyance's: its relation is symmetric (`Flow.conveyance_symm`), so the crossing of 04 §1 goes both ways.
- **The cut's laws in 04's record.** The World's cut belongs to conveyance-crosses-the-boundary (home 04 §1), whose seventh law states it as not going out; the new record stays on the grammar.

### 6.3 Why the excluded-middle law is a lemma

By `«不出当且仅当不外者闭»`, where nothing goes out of a region, what a member bears the relation to is not outside it, and it is inside where membership there is stable. `«不出皆闭当且仅当排中»` shows that asking this of every region is excluded middle. Its witness has one edge from a member, and its forward direction is double-negation elimination for an arbitrary proposition read as membership. The need comes from membership being any proposition, not from the relation, so by 08's rule, as for `World.law_iff_em`, it is a lemma of `«不外者内则不出当且仅当闭»`, not a calibration. The kit first called it a calibration, reading it as saying that a boundary drawn where membership is undecided leaves open where what a member bears the relation to lies; the review found that this restates the logic (finding 3).

### 6.4 Exactness audit

Each sentence of the texts against the Lean:

| Text | Claim | Lean |
|---|---|---|
| 01 §9.9 theorem | the eleven laws as listed; the cut as a pointer | `GrammarCrossing` |
| 01 §9.9 reading, ¶1 | a relation crossing a region is the region's not being `«不出»` | `«不出»` (definition) |
| 01 §9.9 reading, ¶2 | along some relation that is not symmetric something outside bears the relation into a closed region | `«闭而有入之例»` |
| 01 §9.9 reading, ¶3 | a continuing family's region is no cut and no boundary of any event's self along conveyance | `Flow.region_not_a_cut`, `Flow.region_no_boundary` |
| 01 §9.9 reading, ¶3 | a line's step going out, placed on the line, where every step keeps to the region or goes out of it | `«内至外之线有出步»` |
| 04 §1 | the cut as not going out; closed regions cuts; stable cuts closed; conveyance symmetric | `Flow.cut_iff_notGoingOut`, `Flow.cut_of_closedUnder`, `Flow.closedUnder_of_cut`, `Flow.conveyance_symm`, `Flow.cut_iff_not_come_into` |
| 04 §1 | the family's region no boundary; closures not within it; the clearing | `Flow.region_no_boundary`, `Flow.closures_not_within_region`, `Clearing.resource_no_boundary` |
| 07 (line record) | `«所经必同»` is proved from a step going out | `«所经必同»`'s proof |
| glossary | the cut is the grammar's not going out | `Flow.cut_iff_notGoingOut` |

### 6.5 Open

- A graded boundary: nested regions along one relation, the steps by which one line goes out of each, and their order along it (the new record's next step).
- Which relation a self's boundary is drawn along (07 §4.2), and a World formation as the inside of a blanketed law (UE26, UE27).
- `«所闭之界»` and `«所闭不出»` are one law, stated twice: unfolded in `GrammarLaws`, and here through `«不出»`, proved as that law. The grammar's owner holds the edit for the next near-full rebuild: `«不出»` moves into `GrammarLaws` beside `«闭»`, `«所闭之界»` is stated as `«所闭不出»` or derived as one application, and the restatement here goes. `Flow.Cut` can then be defined as `«不出»` with no new import, and `Flow.cut_iff_notGoingOut` goes too.
- A stronger line law. That every step from a member lands decidedly inside or outside (`P u → P v ∨ ¬ P v`) suffices for a step going out, by induction from the start, as `«所经必同»`'s old proof went; it asks less than the split `«内至外之线有出步»` takes. The mark law as stated asks the split of every step, so the stronger law would come with a mark law asking it only along what is kept so far (the review's finding 2).
