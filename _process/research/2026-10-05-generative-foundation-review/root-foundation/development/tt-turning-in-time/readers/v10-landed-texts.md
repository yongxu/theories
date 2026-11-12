AI-written reading, 13 November 2026. Cold read of the texts landed for TT, against TurningInTime.lean, GuardedStep.lean and the seven laws added to GrammarPath.lean after «有常则至终有常» (main 07b4d9f7c). Read only; nothing built or run.

Short names: MAP = theories/becoming/chapters/02-MAP.md; EN / ZH = tt-turning-in-time/TURNING-IN-TIME.md / .zh.md; FR = tt-turning-in-time/FOR-REN.md; REC = theories/becoming/results/records/turning-in-time.json.

## High

H1. MAP:510, "Where the going on does need a level, the lock is the first ending". `locked_ends_with_net` proves only this: a Locked start, with no marked level that meets a positive need and the level falling in Optimum's form, ends where the net ends and is still Locked. The ending comes from `ends_with_net`, and the lock only stays. Being locked does not stop a turn: at a marked level, `renew` can be anything. Least change: "Where the going on does need a level and no level that meets it is marked, a locked start ends the first way, still locked".

H2. FR:43, table row "a lock outliving its loss | a line that ends where the net ends | locked_ends_with_net". The column header says "What it is … Proved by", but the Lean docstring (TurningInTime.lean:767-770) calls this "a reading of the two statements, not a derivation". In the lock's own models the step is total, so no line ends where the net ends (lines 140-143). The parenthesis "(read side by side, not derived)" does not undo "what it is". Least change: take the row out of the table, or put "the counterpart, at a positive need, of" in the middle column and "a reading; locked_ends_with_net proves the counterpart" in the last.

H3. EN:9-11 and :35, ZH:9-11 and :35, FR:16. "Three levels of one quantity decide" and "the exact condition for a turn that holds (turns_in_time_iff)" leave out premises the exactness rests on. The "Given" row (EN:36) lists marks, need, kept kind and one standing use. It does not list these: one `giving` for every way, with the way entering only through its use (lines 124-126); nothing given from nothing; Short/Meets/Keeps up to `hi` with the start at most `hi`; the course as it was starting below H₁+y₁, so that it would end. Least change: add to the "Given" row (both languages) "the level's step: one return for every way, the way entering only through how much it uses, bounded above".

H4. FR:12, "Before this, every law's step in the package went on for ever, so no line on a law could end where the net ends." This is false as stated. GuardedStep.lean:15-17 cites `Map.StepWhere.relation` (GrammarMap) as a cut step already used in a witness, and FR:7 itself names the root's example of a line ending. `Viability.guardedStep` existed as well (FR:30). Least change: "Before this, `Law.step`, a law's step read as a relation, went on for ever; a cut step appeared only in one witness (`Map.StepWhere`)".

## Medium

M1. MAP:510, `locked_alone` sentence; and REC, the law {locked_alone, locked_ends_with_net}. Neither states the lock's premises (Raises, ReadsShare, favouring kept upward). MAP gives them one sentence earlier, for `locked_closed`. REC says "under the same premises", which points to another entry. REC also leaves out AloneOutside at `windowAlone` and "within as many steps as its level stood". Least change: start both with "Under Raises, ReadsShare and favouring kept upward"; in REC add "with AloneOutside at windowAlone"; do the same in the zh field.

M2. EN:7 / ZH:7, "not settled by the respect. It is settled by an amount." Whether a line ends while the net goes on depends on the class too (`kind_ends_while_net_goes` takes κ; under a coarser class there is no turn). The philosopher reader stops here. Least change: "not settled by the respect alone".

M3. EN:26 / ZH:26 (ML reader), "going on the same way is all that shows until the end". The level is part of the configuration and falls visibly. `alike_along` says only that the way does not differ. Least change: "the way shows nothing of the level until the end".

M4. EN:29 / ZH:29 (philosopher and lay reader), "has to be able to change it" / "必须". This reads as a should. What is proved is a condition: if it is to go on, and only under the premises. Least change: "If it is to go on, what it lives on has to…".

M5. EN:5 (lay reader). "the net" is never introduced. And "each is a condition of what happens next" contradicts "Nothing follows at all" two sentences later. Least change: "each can be a condition…; call all of them together the net".

M6. EN:5 / ZH:5, "The first is being used up as it was." In row "six" of the table, the line ends where the net ends after a turn, not as it was. Least change: "The first, where nothing has turned, is being used up as it was."

## Low

L1. EN:35 / ZH:35, "courses of this model where nothing is needed (window_is_pair)": the need-of-nothing part is `net_zero`; cite both.
L2. EN:9 / ZH:9, "At most levels": the Lean has no "most", only a given set of marked levels. Use "Outside some levels".
L3. MAP:512, "with eight or six left (Three.goes_on)": `goes_on` states only that the line never ends; the levels left are in its docstring and proof.
L4. FR:9 "Nothing was renamed" against FR:35 "I changed one name in the new work". Use "No existing name was changed".
L5. FR:39-41: `goAlikeUnder_iff_alike` is about `GoAlikeUnder` (GoAlike is its case at `Eq`); the two Unread theorems hold "along every schedule". Add both.

## Four readers (the one page)

- ML: EN:26 "all that shows" (M3). EN:26 "A warning exists only at levels that change the way": "warning" brings in an observer the model does not have.
- Systems/economics: EN:27 "This is overshoot": overshoot usually means delay, and there is none here. EN:13 "holds from six up": it is proved up to 12 (hi).
- Philosopher: EN:7 (M2); EN:29 "has to" (M4).
- Lay: EN:5 "the net" (M5); EN:9 "need a level of something, and lower it": who lowers what is unclear.

## Checked and not checked

Checked: MAP §11 at lines 491-518, sentence by sentence; EN and ZH (every number in Three recomputed: 9→8→6→2→0 at use 5, holding from 6 at use 3, rows 9/8/6/none, which match goes_on, turned_and_ends and ends_as_it_was); ZH against EN (no contradiction found); FR's claims and table (all named theorems exist: Laws.lean, ClosedCapture.lean, GrammarRegularity.lean, TurningInTime.lean); the REC entry.

Not checked: whether the Lean compiles or its axiom reports are empty (no build was run); FR:11 "no theorem relating them" before TT (the history was not searched); MAP's cross-links and anchors; the other REC entries; NEAR-WORK's bibliography.
