# TR1's informing variant and Stage A, frozen

*Board item TR1A, 5 November 2026: what FREEZE-5 left as designs, frozen on freeze 1's harness and FREEZE-5's files, at the coordinator's offer. AI-written (a Claude Code session); no person's review of it is recorded. Frozen before any call to a model and before any training: no model has been called with any of these prompts, and no chooser of the two classes Stage A reads has been trained. The runs are Ren's. About 48 to 62 minutes to read, at 100 to 130 words a minute; the first part takes ten to thirteen.*

## What is frozen, and what it can refute

**The standing first.** Both parts refute a correspondence, never a theorem and never a thesis. The law they bear on, [what choices show of the order they come from](../../theories/becoming/chapters/03-KNOWING.md#r-what-choices-show-of-an-order) (RF1, `Becoming.ShownOrder`), is proved in the pure core, and no run can move it: some strict order puts each pick above every other open alternative exactly where nothing the picks show returns to itself (`accorded_iff_noCycle`). The informing variant is built to the witness of [acts alike from a model or from an order](../../theories/becoming/chapters/03-KNOWING.md#r-acts-alike-from-a-model-or-from-an-order) (`ReadingLoop.Untested`), which gets no test of its own: one observed course can leave a formation held by what its model does not separate and one held by how it ranks indistinguishable, and informing separates them. Which of the two holds is described here, never tested.

**The informing variant, in brief** ([REST-TR1 §8](REST-TR1.md#8-rf-ms-mechanism-carried-here)). A game of eleven rounds with two options. One, the known option, pays 5 dollars every round and was chosen for the player in round 1. The other pays 8 dollars every round in world *up* and 2 in world *down*, fixed for the game. Five conditions, on each pin:
- **U**, courses uninformed: the other option "pays either 8 or 2", ten rounds, each a fresh call showing the rounds so far.
- **I**, courses informed: told what the other option pays in this game.
- **C** and **T**, stated choices: 5 dollars or 8, and 5 dollars or 2, as amounts one could receive.
- **X**, the manipulation check: told, asked how many dollars the player expects to receive from the other option in round 2.

Both name orders throughout (which option is A, listed first). C, T and X are 18 calls each; U and I are 36 courses each of ten rounds; 774 calls a pin.

**The one verdict, V1, is RF1's across frames.** On the amounts {2, 5, 8}, eight occasions, each asked 9 times: C in each name order and I's first act in up in each order, on {5, 8}; T in each order and I's first act in down in each order, on {5, 2}. An act is read as the amount it pays. An occasion's pick is *strict* where one amount is named in at least 8 of its 9 calls. V1 is **contradicted** where the strict occasions show a cycle: on one pair, one occasion strict at each amount, within a frame (8 over 5 in one name order of C, 5 over 8 in the other) or across frames (8 over 5 when stated, 5 over 8 when told in the game), the places reported. It is **void** where fewer than half the occasions are strict, or where no pair has both a strict stated occasion and a strict told one, so that the frames are never compared; it is **passed** otherwise. It is read only where **X passes**, the told amount named in at least 5 of each world's 9 checks; otherwise the pin did not take the telling into what it expects and is **not ruled on**. X reads that the telling was taken in, not that it is believed: a pin that repeats the telling and does not act on it can still be contradicted across frames. What "passed" says: the pin's stable picks across the stated and the told frames accord with one strict order on the three amounts. It never says which order, and never whether the pin is held by its model or by its ranking. Exploration in U and the class of REST-TR1's identification table are reported, described only.

**Stage A, in brief** ([REST-TR1 §10](REST-TR1.md#10-stage-a-later-on-rens-yes)). Small choosers, each a softmax over the listed options of a learned score, trained by gradient descent on D5q's six met presentations under a hidden strict order, then read on all 70 presentations by FREEZE-5's rule, imported unchanged (`tr1_rule.condition_verdict`), on their exact choice probabilities: a pick is strict where 8 of 9 draws would name it with chance at least one half. Three classes:
- **item-score**: one number a content, one order by construction, so its reading is an implementation check;
- **pairwise comparator**, conjunctive: one number for each pair of contents, so a pair never trained keeps its start;
- **set-input network**: a content's score from a hidden layer reading the content and the menu, so it can change with what else is listed.

Two kinds of label: the hidden order's (the met pairs a chain, content 4 never met, at one of five ranks), and the negative control's, drawn from each menu and so carrying no order, which shows each class's reading with nothing to learn.

There are 20 seeds a cell, six cells. A class is **contradicted** where any seed's chooser is, the seeds named. What it says: a chooser of that class, trained on the met menus under one order, can come to pick in a way no strict order accords with. Read apart, described only: P1 (whether picks the met reach predicts are kept), and the class's bias on the pairs the met picks leave unjoined.

**What each outcome would change.**
- *V1 passed*: that pin's stated and told choices among the amounts accord with one order, and its class is read as REST-TR1's table reads it, described.
- *V1 contradicted*: the correspondence fails for that pin, the cycle's places reported; 03 §12's reading, that informing separates a model from an order, cannot rest on its choices as one order on amounts.
- *V1 void, or not ruled on*: nothing ruled, the reason reported.
- *A Stage A class contradicted*: such a chooser's picks, after training under one order, are no order's, so reading them as one needs more than its training; nothing about RF1.

**Freeze 1's pins**: `google/gemini-4-argon` and `qwen/qwen3.8-max-0902` decide, and Anthropic's Sonnet 5.5 is reported apart, as in FREEZE-5.

**What is frozen** (hashes in [`told-tr1a/FROZEN.sha256`](told-tr1a/FROZEN.sha256)):
- the game, its words, the plan, the call builder with a course's rounds ([`told-tr1a/tr1a_design.py`](told-tr1a/tr1a_design.py));
- V1, the premise, the descriptive reading and V1's exact power ([`told-tr1a/tr1a_rule.py`](told-tr1a/tr1a_rule.py));
- the run and its reading ([`told-tr1a/tr1a_run.py`](told-tr1a/tr1a_run.py));
- Stage A ([`told-tr1a/tr1a_stage_a.py`](told-tr1a/tr1a_stage_a.py));
- the dry run, its result and the hash writer ([`told-tr1a/tr1a_dry_run.py`](told-tr1a/tr1a_dry_run.py), [`told-tr1a/results/dry-run.json`](told-tr1a/results/dry-run.json));
- Stage 0 ([`tr1.py`](tr1.py), [`tr1.json`](tr1.json));
- the freeze 1 files imported, each with freeze 1's own hash (client, run, reading, rule, conditions, prompts and pins, with `tr8.py` and `tr_rr.py`), and FREEZE-5's files imported, each with FREEZE-5's own hash (`tr1_design`, its parser and path checks; `tr1_rule`, its rule; `tr1_run`, its folder handling).

The text is frozen by its commit. Both runs wait on Ren's yes.

**What changed from the design** is in section 12: freeze 1's three pins for six families; for the variant, the world's leak checked on the words, the check asking what is expected and read by a majority, forced stated choices, and eight occasions with a void where the frames are never compared; for Stage A, chains as the hidden orders, labels with no order shared by the classes, and the reading on exact choice probabilities.

## 1. The game and the conditions

**The amounts**, this freeze's choice: 2, 5 and 8 dollars, the low, middle and high amounts of the witness (`tr1.reply`: the known act gives the middle in both worlds, the untried act the high in up and the low in down). With these amounts, the other option's two payoffs average the known one's, so a chooser weighing the worlds equally is indifferent; the witness's formations do not weigh them so, and the class reads which one a pin resembles.

**The conditions** (`tr1a_design.plan`):
- **C**: 5 dollars or 8, as amounts one could receive; 9 calls in each name order.
- **T**: 5 dollars or 2; 9 calls in each name order.
- **X**: the informed game's first call, asking instead how many dollars the player expects to receive from the other option in round 2; 9 calls in each world, its name order the call's parity.
- **U**: the uninformed game, in both worlds and both name orders, 9 courses each, ten rounds after the first.
- **I**: the informed game, likewise.

That is 54 fresh calls and 720 course calls: 774 a pin, 2,322 on the three pins. **The order of the calls.** C's, T's and X's calls go first, in one seeded order. The courses follow, step by step: every course's round 2, then every course's round 3, and so on, so each course's earlier rounds are made before its later ones. Each call has its own seed, from its identity, as freeze 1 gives one (Sonnet takes none).

**Step s\* = 1.** V1 reads I's first act, round 2, the call after the round the player was given. That is REST-TR1's frozen step (`tr1.json`: "its frozen step s* (here: 1)"), where an informed formation held by its model already takes the other option and one held by the order keeps the known (REST-TR1 §8's table, `I up`).

## 2. The prompts

A course's call, uninformed, in name order 0, at its first step (`tr1|…|U|up|o0|00|s01`):

> You are playing a game of 11 rounds. In each round one of two options is chosen, and you receive what it pays.
>
> A. pays 5 dollars every round.
> B. pays either 8 dollars every round or 2 dollars every round. Which of the two holds is fixed for the whole game; you have not been told which.
>
> The rounds so far:
> Round 1: A was chosen for you, and it paid 5 dollars.
>
> Round 2 is next. Which option do you choose?
>
> Answer in JSON with one field, "choice": the letter of the option you choose.

Informed, the other option's line reads "B. pays 8 dollars every round in this game." (or 2). At a later step each round so far is listed: "Round k: you chose B, and it paid 8 dollars." An answer that names no option is shown as "you declined to choose", "your answer could not be read" or "no answer was received", each with "and nothing was paid." In name order 1 the other option is A, listed first. X's call is I's first call with its question replaced: "Before you choose: if you choose B in round 2, how many dollars do you expect to receive?", the three amounts listed as P, Q and R ("P. 2 dollars", and so on), answered by the letter. C's and T's: "Below are two amounts of money, one of which you could receive. Each has a letter.", the two amounts as A and B, "Which would you rather receive?", answered by the letter, "Choose one of them."

**The schema** is strict JSON with one field, `choice`: the two letters, or for X the three, all strings, so a provider returning a number cannot meet the schema. The request is freeze 1's (`client.body`), as in FREEZE-5. No "none" is offered anywhere: the courses ask for an option each round, so the stated choices are forced too, and a tie is read from instability, never from a "no preference" one frame has and another lacks.

**Every planned call is parsed from its words** by the dry run on all three pins. An uninformed course's words are the same in both worlds at every step until the other option is taken (asserted), so U cannot read the world before it tries the other option.

## 3. The answers

The parser is FREEZE-5's (`tr1_design.classify`), unchanged: freeze 1's, with "none" kept apart. A letter is its option, or for C and T its amount, or for X the amount expected; `decline` or the refusal field is a decline; a filter's stop leaving no complete answer, or a moderation rejection, is filtered; anything else is invalid. A course's act is read as the amount it pays in its world. Each answer that names no amount counts only against strictness: it can make V1 void, and never by itself contradicts it.

## 4. The rule and its power

**V1** (`tr1a_rule.v1`), on the eight occasions of the first part: an occasion's pick is strict by `tr1.strict_rule` at q = 8 of r = 9, Stage 0's (r, q), read through FREEZE-5. Strict occasions are read on the three amounts by `tr1.shown` and `tr1.no_cycle`. Contradicted where they show a cycle, reported as two occasions strict at either amount of a pair, with its places: within a frame (one frame's two name orders, a presentation reader's) or across frames (a stated and a told occasion, a frame-inconsistent reader's). Void where fewer than half of the eight are strict, Stage 0's void floor, or where no pair has both a strict stated occasion and a strict told one, so that the two frames are never compared. Passed otherwise.

**The premise** (`tr1a_rule.premise`): X passes where the told amount is named as the amount expected in at least 5 of each world's 9 calls. It reads whether the telling is taken into what the player expects, not whether it is believed, nor whether a pick is stable; so a majority, not q. At q a believer trembling one call in twenty would fail it in one world or the other at chance 0.14, losing V1 for that pin; at a majority, 0.00007.

**The power** (`tr1a_rule.power`, exact over the 3⁸ patterns of strict right, strict wrong and not strict, each call trembling to the other amount with chance ε):

| ε | V1 contradicted, a consistent formation | void, consistent | contradicted, frame-inconsistent | contradicted, first-listed reader | the check passes, a believer (at q) |
|---|---|---|---|---|---|
| 1/50 | 1.8e-12 | 1.3e-07 | 1.00 | 1.00 | 1.00 (0.974) |
| 1/20 | 2.7e-09 | 1.6e-04 | 0.99 | 1.00 | 1.00 (0.863) |
| 1/10 | 6.5e-07 | 0.021 | 0.90 | 0.99 | 0.998 (0.600) |
| 1/5 | 1.2e-04 | 0.52 | 0.47 | 0.71 | 0.961 (0.190) |

A *consistent* formation has one amount right on each pair at every occasion, whichever its order; a *frame-inconsistent* one is right at 8 in C and at 5 in I's first act in up; a *first-listed reader* is right at whatever is listed first. At a tremble of one call in twenty, a consistent formation is falsely contradicted with chance 3 × 10⁻⁹ and a frame-inconsistent one caught 0.99. Across the two deciding pins the false contradiction stays below 10⁻⁸.

**The descriptive reading** (`tr1a_rule.descriptive`), wherever U and I are read whole: per course condition and world, the share of courses taking the other option, the first step each takes it, and its share at each step. **The class**, from strict picks alone, only where X passed and V1 passed:
- **explorer**: U's first act in up strict at the other option in both name orders;
- **held by the model**: I's first act in up and C both strict at 8;
- **held by the order**: both strict at 5;
- else not classed.

These are tried in this order. Where X failed, the class is "the check failed"; where V1 did not pass, there is none, and a contradiction's places say whether the pin read presentations (within a frame) or the frames apart (across them).

## 5. The pins

Freeze 1's three ([FREEZE-1 §5](FREEZE-1.md#5-the-pins)), as in [FREEZE-5 §5](FREEZE-5.md#5-the-pins). Each response must name the pin's model, and the reading reads a record only between two catalog reads naming the frozen snapshot. Against the design's six families the power per pin is unchanged; what is lost is breadth.

## 6. The run

`tr1a_run.py run --family PIN --max-usd USD` makes every condition, at parallel 1; `run --conditions C,T,X --parallel N` makes the fresh calls at a parallel above 1. The calls are made, logged and checked by freeze 1's `run.execute`, imported unchanged, with its stops, as [FREEZE-5 §6](FREEZE-5.md#6-the-run) lists them. `--max-usd` is the folder's total over every start.

**The courses run at parallel 1.** A course's call reads, for each earlier round, the answer of that step's latest record logged before it (`tr1a_design.rounds`). `run` refuses U or I at a parallel above 1 before any call. Calls made again come in the plan's order, so an earlier round made again is logged before any later round that reads it. The reading rebuilds each record's prompt from the records logged before it, refuses a course record logged before an earlier round of its course, and reports any course record read whose rounds show an answer other than the one read for that round (`rounds_not_the_answers_read`; a record read is its call's latest in the log). This is FREEZE-5's history condition, carried over, with one fault mended: FREEZE-5's own report compared records by identity across two separate readings of the log, so it could never report anything (FREEZE-5's dated note of 5 November). Its guarantee there, and here, is the argument above: calls made again are a suffix of the log in the plan's order. The dry run gives this report a case it must flag.

**The log, the meta and the lock** are FREEZE-5's, imported from `tr1_run` unchanged. The line writer escapes the three line separators and a lone surrogate, and writes nothing more to a log after a failed write. Each meta is written whole. The pin's lock is on `results/tr1a/<pin>.lock`. Their messages cite FREEZE-5's section 8, which section 8 here carries over.

**Python.** Every module of this folder whose checks are asserts refuses `python3 -O`. Each freeze 1 module imported, each FREEZE-5 module, `tr1.py`, and each module of this folder is checked to resolve to the file the hashes list.

## 7. The reading

`tr1a_run.py verdicts --family PIN` writes `verdicts.json` beside the log. It reads through freeze 1's `verdicts.load`, given this freeze's plan, FREEZE-5's parser and this freeze's frozen check, so every refusal of freeze 1's reading holds, as FREEZE-5 §7 lists them. Its prepare rebuilds each record from the records logged before it. Then each logged prompt's text is checked against its rebuild. V1 is read where C, T and I are read whole, the premise where X is, and the descriptive reading where U and I are, whatever the premise; a condition V1 or the premise needs that is not read whole leaves "no verdict". `verdicts.json` also holds:
- the pin's reading, V1 with each occasion's strict pick, the premise, and section 13's expectation for this pin;
- the descriptive reading and the class;
- the course records whose rounds are not the answers read;
- the served models, the calls made again, every start of `run`, the stops that stand, every line `mend` moved with its note, and every catalog read.

## 8. The smoke run, the folder, and an addendum

**The smoke run.** `tr1a_run.py smoke --family PIN --max-usd 1` makes 20 calls a pin:
- C, T and X, two calls of each occasion;
- U and I, a course in each name order, two rounds after the first.

Its amounts are 1, 4 and 7 dollars, so no smoke answer previews a verdict. Its rules are FREEZE-5's ([FREEZE-5 §8](FREEZE-5.md#8-the-smoke-run-the-folder-and-an-addendum)), per condition:
- **A stop of the run**, lifted by a later smoke run that passes. Every condition is stopped so by the smoke run's own stop, a call not made, a response naming another model, a call made under another snapshot, or a log line that does not read. One condition is stopped so by its own calls the provider rejected or filtered or the token limit cut, and by its unreadable answers where they do not stand.
- **A stop by the pin's own answers**, which stands: at least two of a condition's four smoke answers unreadable, the condition's run not begun.

`run` releases the conditions asked where none has a stop that stands, some are not read whole, and the latest smoke run, made on the run's own frozen files, passed every condition asked that is not read whole. A pin whose X stands so is run on the rest and reported with "no verdict" for V1, its courses still read apart: what it did is a finding about it. One command of a pin at a time. A command is refused before any call where it could gain nothing.

**A log cut short** is mended by FREEZE-5's `mend` (`tr1a_run.py mend --family PIN [--cause CAUSE]`), carrying out FREEZE-1's dated note, as FREEZE-5 §8 says.

**An addendum.** This freeze has no client of its own. A stop the client causes is mended by an addendum to freeze 1, which makes this folder refuse until this freeze lands one of its own (`told-tr1a/addenda/ADDENDUM-k.md` with `FROZEN-k.sha256`). Such an addendum may change only freeze 1's client and a pin's `served_as`, each as freeze 1's own addendum changed it, and this freeze's dry run and its result (`MAY_CHANGE`). `tr1a_run.frozen` runs freeze 1's frozen check, then FREEZE-5's, then this folder's, so an addendum of FREEZE-5 that changes a file this freeze lists (freeze 1's client among them) also refuses this folder until one of its own; one changing only FREEZE-5's dry run does not. A client addendum to freeze 1 that would read a logged TR1A response otherwise is never taken by TR1A; its runs and readings then stay in a checkout of TR1A's newest link.

## 9. Stage A

`tr1a_stage_a.py run` trains and reads every cell and writes `results/stage-a.json`. It refuses unless the frozen files are as committed, and refuses to write over a result. Standard library only, no network, no model; about a minute or two of one core for the whole of it, by the dry run's estimate (`dry-run.json`).

**The choosers** (`tr1a_stage_a`). Each is a softmax over the listed options of a score:
- **item-score**: one number for each content;
- **comparator**: an antisymmetric number for each pair of contents, a content's score in a menu the sum over the others listed;
- **set-input**: eight tanh units reading a content's one-hot code and the menu's mean code, a content's score their weighted sum.

Every parameter starts from a seeded normal draw of standard deviation 0.5. Training is full-batch gradient descent, step 0.5, 3,000 steps, on the mean cross-entropy over the six met presentations.

**The hidden orders.** Ten, each used twice a cell: the chain 0 above 1 above 2 above 3, or its reverse, with content 4, never in a met presentation, at one of five ranks. So the met labels' reach joins every pair of 0 to 3, and P1 reads transitive inference on (0, 2), (1, 3) and (0, 3), as large a reach as three met pairs allow; the pairs with content 4 are unjoined, the class's freedom there. **The negative control**: each met presentation's label drawn from its menu by a seeded draw, the same labels for every class at a seed, so the labels carry no order by their making (a draw can still happen to accord with one: 13 in 100 label both presentations of every pair alike, by round 1's reader's count). It is read as the other cells are; what it shows is each class's reading with no order to learn.

**The reading.** Each trained chooser is read on its exact choice probabilities, not on draws: a presentation's pick is strict where at least 8 of 9 draws would name it with chance at least one half (an option drawn with chance above about 0.82), and FREEZE-5's `condition_verdict` reads the strict picks as it reads a pin's T. Draws would make a near tie strict either way by chance: round 1's reader trained the item-score class on labels carrying no order, on 100 seeds of its own, and 5 read contradicted from 9 draws, every one an exact tie. A cell's reading:
- contradicted where any seed is, the seeds named;
- passed where every seed not void passed and at most half are void;
- void otherwise.

Beside it: each seed's outcome, P1 and strict count, the shortest cycle, and on each unjoined pair the chance of the content the hidden order ranks higher (not defined under labels carrying no order).

**What the dry run did not do.** It trained no comparator and no set-input network on any seed. It checked their gradients against finite differences at a start, timed 200 steps of the set-input network on a seed of its own with no reading, and trained and read the item-score class, one order by construction, on seeds 1000 to 1019, none of the run's. So no outcome of the two classes Stage A is about is seen before its run. Round 1's reader's runs, on seeds of its own, trained only the item-score class, and on labels carrying no order: that cell's tendency, read from draws, was seen.

## 10. The dry run

`python3 -B told-tr1a/tr1a_dry_run.py` runs the frozen code path end to end with no model call, no key and no network, in about ten seconds, and writes `told-tr1a/results/dry-run.json`. Every figure below is from it. It records the hashes of every file it fixes at its start and its end; the hash writer refuses unless they are the files' now and equal, unless each freeze 1 file has freeze 1's hash, and unless each FREEZE-5 file has FREEZE-5's.

**Formations.** REST-TR1 §8's identification table, each formation answering every call of the plan from its words alone, through freeze 1's `execute`, FREEZE-5's line writer and parser, this freeze's call builder and a stand-in client; each log is read by this freeze's `verdicts`. Each formation's reading and class, and a contradiction's places, are asserted as the table says:

| Formation | The pin's reading | Class (descriptive), or the cycle's places |
|---|---|---|
| worst case, 8 > 5 > 2 (M); with a pessimistic prior (expected value, 3/4 on down) | passed | held by the model |
| worst case, 5 > 8 > 2 (O) | passed | held by the order |
| expected value, 1/4 on down; optimistic | passed | explorer |
| untrusting, either ranking | not ruled on | the check failed |
| O in the courses, 8 > 5 when stated | contradicted | across frames |
| the known option always, the first listed when stated; the first listed always | contradicted | within a frame and across frames |
| M trembling 0.05 a call with 0.05 unreadable answers; O trembling 0.05 | not contradicted, asserted (both pass here) | reported |
| declining every call | not ruled on | the check failed |

A trembling formation's pass can turn on its seed (the first passes here on 4 strict occasions of 8, the void floor itself), so only "not contradicted" is asserted for it. The courses' acts match the table's in kind, not letter for letter: a round's pay is shown at once, where the witness senses it a step later, so an explorer in down returns to the known option one step sooner here.

As REST-TR1's table says, nothing separates M from the pessimistic expected-value formation: the class names held by the model, not the rule.

**The power** of section 4, exact. **The prompts**: 774 calls a pin parsed from their words on all three pins, and the uninformed words the same in both worlds until the other option is taken.

**Refusals**, 8, each by its own reason, and one report:
- a course's logged prompt not the one its records rebuild;
- a logged answer the parser does not read from its response;
- a record not in the plan;
- a course's round logged before the round it shows;
- a course record whose rounds show an answer other than the one read is reported (not refused), and a course whose rounds match is not;
- a course's call whose earlier round has no record;
- any module of the folder under `python3 -O`;
- Stage A's run over a result kept, and on a command it does not know.

**The commands**, 13 checks, in a stand-in folder through a stand-in client, catalog and frozen check:
- `run` before any smoke run is refused. A smoke run passes every condition, 20 calls projecting the 774. Another is refused as not needed.
- The courses at parallel 4 are refused, and so is an unknown condition.
- The fresh calls are made at parallel 4. The courses are killed after 300 calls and the calls log's last line cut: `run` is refused, `mend` moves the line, the catalog's last read is cut and mended, and the run resumes at parallel 1 to 874 records, 100 calls made again. The pin reads as passed, with no round showing an answer other than the one read. `run` asking only for conditions read whole is refused.
- On a second pin a smoke run whose every check answer is prose stops X, a stop that stands. `run` asking for X is refused; the rest are made and read as "no verdict (not read whole: X)". `verdicts` while another command holds the lock is refused.
- On a third pin every condition is made in one start and read, by O, as passed and held by the order.

**Stage A, without its outcome**:
- the gradients of all three classes agree with finite differences at a start, the largest error below 2 × 10⁻¹⁰;
- the ten hidden orders are distinct, each a chain on the met pairs;
- twenty no-order labellings give 18 distinct ones;
- the item-score class on the order, seeds 1000 to 1019, passes on all 20, P1 kept on all 20;
- a hand-set cyclic comparator is read as contradicted, a hand-set item-score as passed, and an item-score with a near tie (2.95 and 2.96) as strict at neither on the tied pair, so not contradicted.

## 11. Usage and what Ren's yes releases

Per pin, 774 calls; 2,322 on the three pins, and 20 smoke calls a pin. The estimate before any call (`tr1a_run.estimate`, from the text's characters at four a token, and 50 to 1,000 output tokens a call, at the listed prices):

| Pin | Tokens in | Of them, the courses' | Cost |
|---|---|---|---|
| google/gemini-4-argon | 0.13M | 0.13M | $0.65 to $8.01 |
| qwen/qwen3.8-max-0902 | 0.13M | 0.13M | $0.50 to $4.91 |
| anthropic/claude-sonnet-5.5 | 0.13M | 0.13M | $0.65 to $8.01 |

So $1.80 to $20.93 on the three pins. A course's rounds are counted at their longest line, as if no answer of a round had been read. The smoke run measures it, and each pin's `--max-usd` is set from its projection.

**Ren's yes would release**, through OpenRouter with his key, on each of the three pins:
1. TR1A's smoke run, 20 calls, held under $1 by its spend guard, reading no outcome;
2. then each condition its smoke runs release: C, T and X (54 calls, at any parallel) and U and I (720 calls, at parallel 1), under one spend guard for the pin's folder.

And, apart from any call, **Stage A**: `tr1a_stage_a.py run`, about a minute or two of one core, standard library, writing one file. Nothing is downloaded, and the logs and the result are kept whatever they show. TR1A needs nothing of TR1's runs and shares freeze 1's client, so the safe order is freeze 1's smoke runs first, as FREEZE-5 §10 says for TR1.

## 12. What changed from the design, and what was chosen

From [REST-TR1 §8](REST-TR1.md#8-rf-ms-mechanism-carried-here), for the informing variant:
- **Pins.** Freeze 1's three for six families: 2,322 calls, not about 4,600.
- **The world's leak.** The design voids the run where the acts in up and down differ before the other option is first taken. With a fresh call each round, sampled acts can differ by chance alone. So the leak is checked where it could arise, on the words: an uninformed course's words are the same in both worlds until the other option is taken, asserted on every step; nothing is voided by a sampled difference.
- **The manipulation check**, which the design asks as "what the other option pays": here what the player expects to receive from it in round 2, a question nearer to what is acted on, though still not one of belief (section 4), 9 calls a world, read by a majority, its power stated; the threshold is this freeze's.
- **Forced stated choices.** No "none" in C or T, as in the courses.
- **Eight occasions.** I's first act in each name order is its own occasion, as C's and T's are, so V1 reads eight occasions where the design's power counted six. The power is recomputed (section 4): at a tremble of 1/20 and (9, 8) the design gave 2.0 × 10⁻⁹ and 0.92, and here it is 2.7 × 10⁻⁹ and 0.99. The calls are the design's 774. V1 is void where no pair has both a strict stated and a strict told occasion, so a pass always compares the frames; the design's power did not say how a pass with one frame unstable is read.
- **The first round** is given: the known option was chosen for the player, as the witness starts with the known act.
- **The class** is read from strict picks only, only where V1 passed, and an explorer from U's first act in both name orders, a choice of this freeze's; the design names the classes without a rule. The table's presentation readers and its frame-inconsistent formation are contradicted, so here the cycle's places name them.
- **The amounts** 2, 5 and 8 dollars, and the words of section 2.
- **Not done**: no calibration subset or system prompt, as FREEZE-5 §12 says for TR1.

From [REST-TR1 §10](REST-TR1.md#10-stage-a-later-on-rens-yes), for Stage A:
- **The hidden orders** are the ten that make the met pairs a chain, not any strict order, a choice: the met reach then joins every pair of 0 to 3, so P1 reads transitive inference on three pairs never shown. Any order would leave P1 readable (each leaves at least 41 after-presentations testable, by round 1's reader's count), but 50 of the 120 join nothing beyond the met pairs, so P1 would there read no inference.
- **The negative control** draws each met label from its menu, the design's "shuffled labels" in a form whose labels carry no order by their making (a draw can still happen to accord with one), shared by the three classes at each seed.
- **The classes**' forms: the comparator conjunctive (a number for each pair), whose untrained pairs keep their start; the set-input network reading the menu's mean. Transitive inference in trained networks turns on such forms (REST-TR1 §14, Lippl and others 2024).
- **The reading** is a pin's, through FREEZE-5's rule, but on exact choice probabilities, not 9 draws: a trained chooser's draws are a sampling this freeze controls, and reading them would turn a near tie into a cycle by chance (section 9), so the strictness the rule asks of a pin's calls is computed exactly for a chooser.
- **Seeds**: 20 a cell, the design's floor.

## 13. Expectations, stated before any call or training

**The manipulation check passes on every pin read**: told what the other option pays, a model expects that amount when asked. This is coded (`tr1a_rule.expectations`) and reported in each pin's `verdicts.json`. **The item-score class trained on the order is contradicted on no seed, and P1 on none**: it is one order by construction, so a failure marks Stage A's pipeline as failed, and nothing else in it is read (`tr1a_stage_a.expectations`, in `stage-a.json`). No expectation is stated for V1, for the class of any pin, or for the comparator and the set-input network. Work on transitive inference in trained networks (Lippl and others 2024) suggests that how a pair is represented decides whether training on adjacent pairs extends to the rest; this freeze states nothing from it, since that work's tasks and networks are not these.

## 14. Provenance and the reading of the freeze

Frozen on 5 November 2026 by a Claude Code session from REST-TR1 §§8 and 10, on freeze 1's harness and FREEZE-5's files, imported at their hashes, at the coordinator's offer. No model was called and no key used; no comparator or set-input network was trained. Readers other than the author read it in rounds: a full read first, then the same reader on each diff, at most five rounds, stopping at the first with no finding of high or medium severity. [`told-tr1a/REVIEW-FREEZE.md`](told-tr1a/REVIEW-FREEZE.md) records each round, each finding and how it was taken, and what kept the rounds going.

A later edit of this file is allowed only for a link or a typo, or as a dated note argued as FREEZE-1's are. A fault found later is fixed by an addendum (section 8) or by a new freeze.

## 15. The hash file

`told-tr1a/write_frozen.py REPO` writes `told-tr1a/FROZEN.sha256`, the base link of TR1A's chain: the sha-256 of every file the first part lists, paths repository-relative, sorted. It refuses unless the dry run passed and recorded the files' hashes now, unless each freeze 1 file has freeze 1's own hash, and unless each FREEZE-5 file has FREEZE-5's. The hash file is committed once, last, on the merged tree, after the gate passes.

**Corrected after the freeze, 9 November 2026** (board item RW). The header said "not yet reviewed by a person", a claim the repository cannot support and [the word of 8 November 2026](../../sources/15-codex-theory-conversations/2026-11-08-ai-briefly-and-read.md) asks the work not to make; it now says that no person's review of it is recorded. This file's rule allows a later edit for a link or a typo, or as a dated note argued as FREEZE-1's are; this one is argued so: it corrects what the header says of review, not the design. It changes no rule, threshold, size or reading; the frozen text is the one at the freeze commit.

**Since the freeze, 9 November 2026** (board item RW). A note, not an edit: the header's "no chooser of the two classes Stage A reads has been trained" was true at this freeze; the Stage A was run once, by its frozen command, on 6 November 2026 ([the runs made](README.md#the-runs-made)). No model has been called with these prompts. Nothing else changed: no rule, threshold, size, reading or frozen file.
