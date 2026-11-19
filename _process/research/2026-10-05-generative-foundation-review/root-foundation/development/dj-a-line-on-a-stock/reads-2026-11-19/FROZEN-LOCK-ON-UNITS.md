# A lock on units that multiply, on a level they need: the statements on paper, and what counts against them

*AI-written (Fable, board row DJ). Frozen 19 November 2026, 22:10 WIB (from the clock), after reading the home and before any worked course was computed or any reader started. Scratch; no Lean is written and no tracked file is changed. What comes back is appended below with its time; nothing above an appended line is changed.*

Ren, 19 November, of the question "Shall I work out on paper the one Lean join the page now names as missing?": "Yes, on paper".

## What it bears on

The direction page says, since 18 November, that no model that was found has units that multiply, a rule set again, and a level they need, all together. AGENTS.md's first rule is the Lean first: its statements say what we mean and its parts meet. The plan says what a stage is for: something the idea needs, and that is now assumed, comes out as a conclusion in one model.

## What I read before freezing

The plan whole to its item 9 (`_process/LEAN-TOWARD-THE-DIRECTION.md`); chapter 2, section 11, yesterday; in the Lean, at their statements and docstrings: `LineOnAStock`'s definitions and its laws `way_ends`, `need_unmet`, `falls_to_unmet`; `RuleCapture`'s `Raises`, `ReadsShare`, `Locked`; `TurningInTime`'s `rising_takes_all`, `locked_ends_rising`, `count_rises`. And one question to the program's output of 18 November: which theorems name the lock together with units or a needed level.

**What that showed, and it corrects the page I landed yesterday.** The Lean already has, since 16 November, a statement with all three in one form (the plan's item 5 tells it, and I did not re-read the plan yesterday): a locked way whose share is a count that every favouring rule raises strictly, its use that count times a positive amount, against a level that cannot pass a bound, ends, still locked, within that bound plus one steps (`locked_ends_rising` with `count_rises`). There the rule is set again from the share, the count multiplies, and the going on needs the level. What it does not have: units. The count is the share itself, one number. Nothing in it has a need of its own or leaves offspring; that the level makes no difference to the rule while the need is met is a premise; and that a share is a draw is the premise `count`. `LineOnAStock` has the units (each with a need, a use and offspring) and says in its own account that a lock on these units is not there. The two share one lemma (`rising_takes_all`). By the program's output, 13 theorems name the lock with a needed level, all in `TurningInTime`, and none names the lock together with units, in its statement or its proof. That is a search by name.

So the question is narrower than I put it to Ren: not whether the three can stand in one model, but whether the lock can be put on the units themselves, so that what the lock's law takes as given comes out of the units' law.

## The model, on paper

Units of some kinds, each kind with a need and a use. A rule. Under a rule each unit leaves offspring, `kids r u`. A configuration is the way (the units present), the rule in force, and the level.

One step: each unit whose need the level meets leaves its offspring under the rule in force, and the others leave nothing; the rule is set again by a reading of the share of the new way (a reading monotone in the share, as `ReadsShare`); the level steps by the regime's step under what the units present take together. This is `TurningInTime.pair` with the way and the rule together in the place of the way.

The share of a way is some order-valued reading of it (for instance the number of its units of a favoured kind). The lock's two premises are asked of the units: under a favouring rule the share of the offspring of a way is not lower than the share of the way (`Raises`), and favouring is kept by a rule not lower.

## The statements

- **L-a (the lock is kept while every need is met).** From a locked start, at every step up to the first at which some need is unmet, the configuration is locked, and the way is the plain line of descent under the rules in force, in which no level appears.
- **L-b (a need goes unmet).** Given besides: under every favouring rule each unit's offspring together take more than it; every unit that can arise needs something; a bound the level cannot pass, with the start within it; nothing given from nothing; a start that is not empty with every need met. Then within the bound plus one steps some need is unmet, and until then L-a holds. Given also that under favouring rules offspring need no more than their parent, the level at that step is below a need the start met.
- **L-c (after that the lock does not decide).** There is a worked course on which the favoured units, needing more, end first, the share falls, the rule set again no longer favours them, and the rest goes on; and one on which the line ends. So the model has, in one place, a lock that ends with what it uses up and a lock left by its own overdraw.
- **L-d (an exact condition, for two kinds).** With a favoured kind that multiplies under a favouring rule and another kind that leaves itself: the line never ends exactly where, at the first level below the favoured kind's need, the other kind's need is still met and the level one step later is at or above the point of no return of what the rest then takes. This is `WayOfUnits.two_units_iff`'s shape. I do not know that it holds; it is to be searched by a small program over small numbers before it is believed.

**What would become a case.** With one rule and no reading, L-b is `LineOnAStock.need_unmet` and `falls_to_unmet`. With one kind of unit, the share the number of units, L-b gives what `locked_ends_rising` with `count_rises` concludes.

**What would come out as a conclusion that is now a premise.** In `locked_ends_rising`: that the level makes no difference to the rule while the need is met (here it is the units' law, as `ways_alike`); and that the use rises with the share (here the use is what the units take). In `LineOnAStock`: that the offspring take more (here asked only under a favouring rule, and the lock keeps the rule favouring).

**What stays given.** The kinds, needs and uses; what offspring a rule gives; the reading of the share and that it is monotone; that the units' law raises the share under a favouring rule; the stock's regime and its bound. Nothing in the model reads the level except through whose need is met.

## What would count against it

- **K1.** L-a or L-b fails on some small instance, found by a program that runs the model over small numbers, or by a reader. It is then kept with its countermodel.
- **K2. The lock does no work.** If L-b's ending follows from the units' law alone under every rule that can occur, the lock is idle and this is two statements side by side. To count as a join there must be a course from a start that is not locked on which the rule stops favouring, the offspring stop multiplying, and the line goes on, where from the locked start beside it the line ends.
- **K3. The lock on units is assumed, not derived.** If the only way to have `Raises` for a share of units is a premise as strong as what the lock concludes, nothing has come out as a conclusion. A share that is a proportion and not a count is the likely failure: `LineOnAStock` keeps a worked course on which a share rises while the number of drawers falls.
- **K4. L-c has only one outcome.** If after the first unmet need the line always ends, or always goes on, the model does not hold "used up, and whether it can still be turned".
- **K5. It is a dictionary.** If every premise of L-b is a premise of `need_unmet` or of `locked_ends_rising` said again, and no older statement gets shorter or becomes a case with nothing proved afresh, it joins by renaming. Yesterday's nine statements failed this way.
- **K6. It is already there.** A reader sweeping by content, not by name, finds the lock on units in the Lean or in a chapter: the count models of chapter 2, section 9, have lines with offspring and a rule read from them.
- **K7. L-d is false**, or true only under premises so strong that it is `two_units_iff` again. It is a guess and may fail without the rest failing.

## The test

A small program that runs the model on small numbers, written before any reader starts: it checks L-a and L-b on every instance in a range, looks for both outcomes of L-c and for the course K2 asks for, and tests L-d. Then AI readers, read-only: one sets the model and the statements against the Lean's definitions, to say whether the premises are the Lean's and whether the two older results would be cases; one sweeps by content for K6; one is set to refute K2, K3 and K5; one proposes the join another way, without seeing this one's statements, to see whether a simpler form exists. Then readers who took no part read what I say of it. No Lean is written before Ren has seen it.

## What it cannot show

That the statements hold: only a proof does, and a search over small numbers shows where one fails, not that it never does. That this is the join the direction most needs. Whether leaving a lock because the favoured units ran out of what they need is what the idea means by turning.
