# K1: how readings form, spread and lock — design draft (AI-written, Claude Opus 5.5, 10 November 2026)

Route (b), round K, piece K1 (brief: `/Users/ren/tmp/za-how-far/route-b/K-ROUND.md`; board row K1). Home: 07 §4.14. This draft is for one Fable reading before any Lean; the decisions it asks are at the end.

## The question

J2 (`Becoming.ReadingsPersist`, 07 §4.12) showed which readings *persist* when a line carries a fixed inherited reading: standing late selects no reading beyond the line's coupling closure; persistence selects acts on what returns, not scope. Missing is how readings *form*: readings that vary at descent (revision, RF's loop, 03 §8 and §12), lines carrying them selected by *share* in one world, the pool read off the course.

1. Which readings spread, which lock, and where does that depend on whether acts return?
2. Does selection by share favour a narrow reading (one whose act draws on what lies beyond its coupling) over a wide one? Where, and for how long?
3. Is there a reading that, once spread, removes the variation that could replace it (locks)?

Asked as dynamics (Ren, 8 November: "right or wrong are 'cognitive structures/dynamics' … 'higher order in dynamics/patterns' … which leads to cascading changes"), not as a ranking; the map to be connected, not widened (10 November).

## What exists and is reused

- J2: `ExchangeLaw.byReading act read` (each relatum acts by the act its reading gives; `read : X → Sig` static), `Flow.lineOf L W members first` (line read off a flow; `Generations` with `amount := 0`), `Flow.InheritsReading L W read := ∀ t x g, L.DescendsAt W t x g → read x = read g`, `Flow.lineOf_carries` (induction), `AliveIn`, `RemovesLine`, `RemovesItsReaders`, `SurvivorsPersist`, the `Habitat` witness (finite, closed-form courses, balance proved by `rfl` per step and parity).
- SelectionTerm: `Generations` (`first`, `kids`, `amount`), `family`, `size`, `sum`, `concordAt`, `discordAt`, `raisedAt`, `loweredAt`, `mean_step` (Price's equation, counting form, denominators cleared), `kept_step_iff`, `rises_step_iff`, `moved_by_selection` (exact transmission), `moved_by_transmission` (uniform offspring), `concord_alike`/`discord_alike` (uniform amounts give zero), `Flow.support_not_against` (only active formations give, activity needs support: a reading highest at the supported parents is not selected against), `Flow.Descended`.
- Evolution: `Flow.unsupported_childless` (an unsupported formation leaves no descendant).
- Capture / RuleCapture (02 §9): `share_rises`, `share_not_lower`; `favouring_locks`, `Locked`, `locked_stays` (a loop whose rule reads the share it selects locks). K2 owns the selection whose rule or pool is shaped by what it selects; K1 does not restate RuleCapture.
- ReadingLoop (03 §12): `kept_iff_closed` (a region kept along every finite reach of a relation is a closed region), `KeptBy`, `joint` (state updated from act and value sensed).
- LineageDrawdown: the ledger and `Drain` (a drawer's line drawn past renewal ends; offspring numbers supplied).

## The model (proposed)

1. **Readings carried by slots, revised at descent.** Keep J2's static `read : X → Sig`: a relatum is a slot an occurrence stands in, and the reading is carried by the slot. *Revision at descent* is a parent giving standing to a slot that carries another reading. `Flow.RevisesAlong L W read rev : Prop := ∀ t x g, L.DescendsAt W t x g → rev (read g) (read x)` for a revision relation `rev : Sig → Sig → Prop`; `InheritsReading` is the case `rev := Eq` (`Flow.inheritsReading_iff`, `Iff.rfl` up to symmetry). (Alternative: dated readings `read : Nat → X → Sig`; rejected for now because `byReading` and every J2 law are static, and static slots lose no generality where each occurrence is its own relatum.)
2. **One world, several lines, the pool read off the course.** The population at a step is the cohort of one `Generations` read off the flow from all founders (`Flow.lineOf L W members founders`), each line's members and descent read off the course.
3. **Share.** For a region of readings `inR : Sig → Bool`, `Flow.readingShare`: the population with `amount t x := if inR (read x) then 1 else 0`. Its `sum t` is the number of carriers, `size t` the population; the share is `sum/size`, compared by cross-multiplication as SelectionTerm does.
4. **The share's law is Price's.** `mean_step` read with that amount: the carriers move by selection proper (`concordAt`, `discordAt`: offspring numbers covarying with carrying the region) and by revision (`raisedAt` = the number of (parent, kid) pairs revised into the region, `loweredAt` = revised out of it). Lemmas: `raisedAt_eq_revisedIn`, `loweredAt_eq_revisedOut` (counts of descents across the region's boundary). Board rule 9: the share dynamics is a case of `Generations.mean_step`; revision at descent is its transmission term; with inheritance it moves only by selection proper (the case of `moved_by_selection`), with uniform offspring numbers only by revision (`moved_by_transmission`).

## The laws (proposed; all on the World or `Generations`, any type)

- **(S1) The share moves by selection and by revision** — `mean_step` at the indicator, with the revision counts (near-definitional).
- **(S2) Spread needs support.** Where only active formations give and activity needs support: where every supported member carries the region, the region is not selected against (`support_not_against`'s case); at a step where no carrier of the region is supported, its carriers leave no offspring and the next generation's carriers are exactly the revisions into it (`Flow.unsupported_childless` composed). So a reading spreads by selection only while its carriers are supported: *for as long as what feeds them lasts* (near-definitional composition).
- **(L1) At fixation selection proper vanishes.** Where every member carries the region, `concordAt = discordAt = 0` (`concord_alike`, `discord_alike`), and the next generation's carriers are its size less the revisions out (`sum (t+1) + loweredAt = size (t+1)` after cancelling). A reading that has spread to every member is turned only by revision, never by selection among the members present.
- **(L2) A lock is a region kept along descent.** A region fixed at `T` is fixed at every later step exactly where no descent along the population from a member at a step `≥ T` revises out of it (`kept_iff_closed`'s shape on dated descent; `lineOf_carries` is its case `T = 0`, region `{sig}`, inheritance, so rule 9 asks the general law into ReadingsPersist with `lineOf_carries` its corollary).
- **(L3) Variation drawn from what is present.** Revision *by copying*: every kid carries the reading of some member of its parent's generation (`Flow.CopiesFromPresent`: `∀ t x g, DescendsAt t x g → ∃ y ∈ family t, read x = read y`; social learning, recombination; a reading from outside is not copying). Under copying, fixation is a lock: a region fixed at `T` stays fixed at every later step (from L2; near-definitional).
- **(L4) A reading that removes the other readings' carriers locks itself.** Composition of J2's removal with L3: under copying, where from some step on every line carrying a reading outside the region is removed from the pool the course gives (`RemovesLine` for each), and the region's lines persist, the region is fixed from that step and locked: the reading has removed the variation that could replace it. Joins J2's `RemovesItsReaders` (the removed lines read as readers) to variation: removing one's readers removes one's revisers.
- **(R1) Where acts return.** Where the source a reading's carriers draw on is renewed only by a line its act removes, the carriers become unsupported once the renewal stops, so by S2 its spread ends with its line; where nothing returns, the spread stays. This is a composition of J2's persistence results with S2; probably witness-level only.

Every law above is near-definitional. The substantive content is in the witnesses and in which dynamics these compositions join (Price/selection, support, removal of readers, the reading loop's closure).

## Witnesses (proposed)

- **W1 `Commons`** (World, finite relata, closed-form courses, balance by `rfl` per step and parity; `back : Bool`). A source `s`, a habitat `h` and a dweller's line (`d0 d1`, carrying the wide reading); a narrow line and a wide line. The wide member draws one from `s` and passes its standing on to one slot; the narrow member also takes one from `h` and passes its standing on to two slots. With nothing coming back (`back = false`), the source renews itself: the narrow reading's share rises while the habitat lasts (for example 1/3 → 2/4 → 2/3), the dweller's line ends, and the share then stays (no selection either way afterwards): the narrow spreads by drawing beyond, removes a line carrying the other reading, and nothing turns it. Where the dweller renews the source (`back = true`), the source runs down after the dweller's end and every line ends: the narrow's gain lasts as long as the return takes to arrive. (Needs four narrow slots for a population of two at period 2.)
- **W2 `Copying`** (World or `Generations`): a narrow and a wide line, revision by copying through contact (a member coupled with a carrier of the other reading may give its standing on to a slot of that reading). The narrow reading that clears the habitat ends the dweller's line, the only carrier of the wide reading it couples with; from then on no narrow descent is revised: locked (L4). The narrow reading that spares it keeps being revised into the wide. Witness both ways.
- **W3** (cheap, `Generations` only): a share rising by selection with inheritance (`Rising`-like), a share moved by revision alone with uniform offspring, fixation then a revision out (L1 both ways).

Kept failures to watch for: a "lock" that is only fixation under inheritance (trivial; L3 is the content); the narrow spreading "because narrow" when it is because it draws more (the acts are assigned by design, as in J2).

## Placement (rule 9)

- New core leaf `Becoming.ReadingsSpread` (imports ReadingsPersist; L2), registered in `check_becoming.py` CORE and `Becoming.lean`.
- Rule-9 move: the general "region kept along descent" law (L2's line form) into ReadingsPersist, `Flow.lineOf_carries` its corollary (ReadingsPersist is a leaf: only the aggregate imports it). J2's record `readings-carried-on-their-course` rebound.
- SelectionTerm untouched (the indicator amount is K1's).

## For K2

K1's lines: `Flow.lineOf` with founders of several lines, `read : X → Sig` static on slots, `Flow.RevisesAlong`, `Flow.CopiesFromPresent`, the share's `Generations` (`Flow.readingShare`). K2's selection whose pool or rule changes with its course can read the pool as `AliveIn` over these lines, or the share.

## Decisions asked of the Fable reading

1. Is static readings on slots, revision as giving standing to a slot of another reading, the right representation, or should readings be dated?
2. Is L3/L4 (fixation is a lock under copying; removing the other readings' carriers removes one's revisers) the right content for "a reading that removes the variation that could replace it", or is there a better-founded notion of lock here (for example revision reading what couples in, the reading loop's `update`, with a lock where the reading's act keeps what couples in inside the region the update leaves unchanged)?
3. Which witnesses are worth their Lean: W1 on the World (several hundred lines of closed forms) and W2 on the World, or W2 on `Generations` with supplied descent?
4. Is anything here more than near-definitional, and if not, is that right for this piece (J2's laws were near-definitional too)?
5. Rule 9: the move into ReadingsPersist, yes or no.
