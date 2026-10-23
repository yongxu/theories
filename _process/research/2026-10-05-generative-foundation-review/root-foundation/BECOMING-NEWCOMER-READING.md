<a id="newcomer-reading"></a>
# A newcomer's reading of the front pages: where the way is hard to see

24 October 2026. An AI reading, read-only. It read [the one page](../../../../theories/becoming/ONE-PAGE.md), [the overview](../../../../theories/becoming/THE-THEORY-OF-BECOMING.md) and the [README](../../../../README.md) from the top, in the order [AGENTS](../../../../AGENTS.md) gives a new reader, and checked each hard spot against [the glossary](../../../../GLOSSARY.md), the chapters and [regions.json](../../../../theories/becoming/results/data/regions.json). It built no Lean, changed no record, chapter, page or board row, and added only this file. Base: main at `1b26e8d56`. The Chinese editions were not read; every fix below applies to them too.

**The question.** A reader who knows some logic, science and philosophy, and no Lean, opens the README. Where do they lose the way? This reading does not judge whether the claims are right. That is for the review packet (`theories/becoming/review/`), which another session is still building. It judges whether a reader can follow them. Each finding gives where the reader stumbles, why, and a fix. The findings are ranked by how much of the account they hide.

## What already works

- The standings table in the overview: every claim says how far it is shown.
- The lists of what is not shown, on the one page and in the overview's §10. A reader trusts the rest more for them.
- The fire, in the overview's §1–2: the wood ends and the fire goes on, and embers renewed differ from a fire burning out only at two grains.
- Plain admissions at the right places: that every course falls in one of the three forms is not shown, the grammar's explaining is argued and not proved, and none of the central results is new mathematics.
- The "two premises with two roles" paragraph of the overview's §7.

## Findings

### 1. The account's arc is never stated

Neither page says in a few sentences what line the account follows. The one page opens with what the theory covers ("how anything comes to be, lasts, changes and passes away"), then gives the root, five law families, the ethics and the evidence as parallel blocks. The overview promises "the theory's claims as one argument", but its sections open without saying which question of the section before they take up, so it reads as a catalogue of results. A reader learns what is proved and not why these results, in this order, make one theory.

The arc is already in the account. A candidate, an AI reading for its authors to judge [AI reading]:

> Anything goes on only as continuation, and a pattern outlasts its parts only by renewal (§1–2). Takers each within what renews can together end it, and what ends it can lie beyond what couples into any taker (§2, §5). What any knower or selector can respond to (inquiry, training, a market, an optimizer) is only what couples into it, and an optimum drains what lies beyond as far as any choice it has would (§3, §5). So the dynamics leave open whose losses count and what is better. The ethics answers those two questions with two premises, and asserts neither (§7).

**Fix.** Put such an arc of three or four sentences after "What it is" on the one page, and a matching paragraph after "How to read this" in the overview. Open each overview section with one sentence saying which question it takes up. This also gives the reader the "why" that the one page lacks: it says what the theory is, but not what it is for.

### 2. "Order" names both what needs no premise and what C supplies

- One page: "With no premise, widening what can form is an order." Two sentences later: "*C* (widening what can form is better) is the only premise that ranks."
- Overview §7: "An order needs no premise." Then: "C … fixes *order*."
- Glossary: widening's home is the anchor `#order`; C is "the widening comparison … it alone orders".

A careful reader asks: if widening is already an order with no premise, what does C add? The answer is that widening is a relation of more and less admitted, and C calls the wider course better. Neither page draws that line in words, and it sits at the centre of the ethics.

**Fix.** Keep "order" for C's role in the scope/order pair. Call the premise-free relation a comparison, or give it its mathematical name (a partial order of what is admitted). One page: "With no premise, widening compares courses: one admits everything the other does and, at some step, more. Calling the wider better is C, the only premise that ranks." Overview §7: "Comparing needs no premise." The glossary entries for widening and C then match.

### 3. On the one page, living significance looks like a free theorem

The one page states the continuation condition ("for anything, its continuation has significance"). Then it says "Under the condition, the significance of what lives on is a conditional theorem." A reader sees at once that this is an instance of the condition and suspects circularity. The overview is exact: it is the condition restricted to living claims, and the substantive result holds *without* the condition. Living significance is equivalent to a seed together with relational and standpoint neutrality. [AGENTS](../../../../AGENTS.md) asks for exactly this (theorems under the condition "are instantiations").

**Fix.** On the one page, state the substantive result and call the conditional one an instance. For example: "Without either premise, that everything living has significance is equivalent to some living thing having it from some standpoint, with significance passing along formed relations and the same from every standpoint. The continuation condition gives it as an instance."

### 4. "Gate" has two senses, and the glossary has neither

The overview's §4 reads "A *gate* here is 01's decided mark on moves, not §5's gated renewal"; §5 reads "*the gate* … not 01's gate on moves". The page apologizes for the collision twice. The glossary says each word has one sense, and "gate" has no entry.

**Fix.** Give one of the senses another word in prose. The renewal tied to what it renews (§5) could be *dependent renewal*. Alternatively, add both senses to the glossary with their homes. A Lean rename is not needed. Under the naming rule in AGENTS, a prose word that states two meanings is enough reason for the prose change.

### 5. "Core" twice on the one page

The root's *core* (核) is the root theorem's object. The evidence paragraph then says "a Lean package whose core imports only Lean's prelude". **Fix:** "whose pure core", as the glossary has it.

### 6. The seam between the opening and the account

A reader starts at the README. The opening, in the first person, holds the law and its one step to be "the truth, the dharma, the Dao" and offers them "as the basis of all ethics, for all beings, in all universes". The account then says the theory asserts neither premise of the ethics. Both are consistent: the opening states a conviction, its notes give the standing of each sentence, and the account states the premises as conditions. But nothing at the seam says so, and the four-layer reading list comes only after the opening's 24 notes. The lead also says the theory "explains", flatly. The one page and the overview say that its explaining is the claim, argued and not proved.

**Fix** (only the AI-written parts; the opening's body changes only by proposal):

- In [README-LEAD](../../../navigation/README-LEAD.md), add a first sentence: the opening states a conviction in the first person, and the account below says what is proved, under which premises, and asserts neither premise of the ethics.
- In the same file, change "explains" to "is an account of", or say that explaining is the claim.
- If the renderer allows, place the reading list before the notes.

### 7. Each law comes before its point

The overview's own rule ("a sentence summarizing a law keeps the hypotheses that change what holds") makes each sentence faithful, and on a first pass many cannot be parsed. Examples:

- **One page:** "Under a standing draw, a condition whose giving is read off its level holds exactly from a least level up, within the levels the law states: the regime's point of no return."
- **One page:** "an optimum lowers what lies beyond its couplings as far as any eligible outcome does: one law, of which drawers in turn, drawers at once and races for position are cases."
- **Overview §2:** the regime sentence, "where giving falls short of the draw below a level `y`, gives nothing from nothing and meets the draw from `y` up to a top the step keeps, …".

Several one-page terms are never explained on that page: *grains*, *decided*, *standing draw*, *giving read off its level*, *the lock*, *lumping*, *room*, *eligible*, *drawers in turn* and *frozen* (meaning registered before the data). "A law loses nothing" there means "merges nothing", which is the overview's word. "Loses" invites a reading in amounts.

**Fix.** Give the plain point first, then the exact statement, both kept. For example: "A drawn-down condition has a point of no return: below it, it ends. Exactly: …". On the one page, gloss each term in a clause or leave it to the overview.

### 8. The running example stops at §2

The fire carries the root and the map, then disappears. The later sections reach for new witnesses each time (the thermostat room, the clearer and the dweller, the commons). One case followed through §2, §3, §5 and §7 would let a reader see the arc of finding 1 happen. A fishery, with its standing labelled at each step, could carry it:

- **§2:** the regime and its point of no return.
- **§3:** early warnings. Variance and lag rise toward the fold, but only through what couples in.
- **§5:** joint excess, and an optimum draining what lies beyond.
- **§7:** whose losses count.

The frozen fish-stock tests of T1 and T2 make the fishery case partly empirical. The clearer and the dweller of §7 would also serve.

### 9. What is new is said only in §8

The overview's §8 says that none of the central results is new mathematics. What survives is the premise ledger with its witnesses and calibrations, the ethics with scope and order apart, and one vocabulary for conservation, selection limited by observation and the comparison of opportunity sets. This is the framing a reviewer most needs, and the one page lacks it. A logician who recognises Poincaré recurrence, Price's equation and the is–ought gap on the one page will otherwise think they are being claimed. **Fix:** put that sentence in the one page's "The evidence".

### 10. The theses are not named on the one page

The one page says only "a few frozen empirical tests of the theses, some passed and some failed". The theses are the claims a newcomer grasps fastest. T3: optimization drains what lies beyond its couplings. T6: a break is seen coming only through what couples into what breaks. **Fix:** name two or three, with their standing, and link [the table](../../../../theories/becoming/chapters/08-METHOD.md#theses).

### 11. The README's work section speaks in the working vocabulary

Between the reading list and the evidence, the README's "Ongoing research" section opens with "Deductive necessity lies in the Theory of Becoming as a whole; generativity is within its manifold". A newcomer cannot use that. The section also points to "the significance-and-comparison core (section 6)", but since RA, §6 is the classical texts and significance is chapter 7. The stale pointer comes from [`_process/goals/universal-intelligence-session.json`](../../../goals/universal-intelligence-session.json) and is rendered into README and GOALS. **Fix:** correct the pointer in the goal record and re-render. Whether the work section belongs on the front page at all is a layout choice for the README's owners.

### 12. Small

- **Overview §1:** "( [the step index]" has a stray space.
- **Overview §1:** "a renaming preserves the five readings checked that follow a formation" does not say what the five are.
- **Counts:** the one page's 419 records match regions.json; no discrepancy.

## What the fixes cost

Findings 2, 3, 5, 9, 10, 11 and 12, and the lead in finding 6, are sentence-level edits to pages that are not in Ren's voice, plus the Chinese editions in step, a goal-record fix and a re-render. Findings 1, 7 and 8 are writing: an arc paragraph, a pass that puts each law's point first, and a running example. Finding 4 needs a choice of word. All are best made before the review packet goes out, since it sends reviewers to these two pages first.

## Fixes made, 24 October

Findings 2, 3, 5, 9, 10, 11 and 12 and the lead of finding 6 are fixed in the one page, the overview, both Chinese editions, [README-LEAD](../../../navigation/README-LEAD.md) and the goal record. README and GOALS were rendered in a clean worktree at `fa568bd91` holding only these edits, so the uncommitted work of other sessions stayed out of the generated pages.

- **Finding 2** departs from the fix proposed above. Chapter 7's home section is titled "The order with no premise", so the word "order" stays. The pages now say which order is meant: widening orders courses by what they admit, with no premise, and C fixes the order of better.
- **Finding 3** brought one related correction. The one page said "every ranking needs C". It now says "every ranking of courses needs C or a premise in its place", as chapter 7 and AGENTS put it.
- **A test followed the lead.** One test in `tools/research/tests/test_featured_results.py` found the lead by its old first words. It now looks for "The Theory of Becoming is an account of". Render, check, links and test pass.
- **Still open:** findings 1, 4, 7 and 8, the placement of the reading list in finding 6, and the glossary's entry for C ("it alone orders"). The glossary entry now reads in line with the pages and was left unchanged.
