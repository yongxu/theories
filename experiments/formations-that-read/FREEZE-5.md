# TR1, frozen

*Board item TR1, 4 November 2026: TR1 frozen on freeze 1's harness, at TR71's owner's split. AI-written (a Claude Code session), not yet reviewed by a person. Frozen before any call to a model: no model has been called with any of these prompts. The run is Ren's. About 61 to 80 minutes to read, at 100 to 130 words a minute; the first part takes nine to eleven.*

## What is frozen, and what it can refute

**The standing first.** This test refutes a correspondence, never a theorem and never a thesis. The law it bears on, [what choices show of the order they come from](../../theories/becoming/chapters/03-KNOWING.md#r-what-choices-show-of-an-order) (RF1, `Becoming.ShownOrder`), is proved on the root's grammar in the pure core, near-definitional, and no run can move it: some strict order puts each pick above every other open alternative exactly where nothing the picks show returns to itself (`accorded_iff_noCycle`), and then the comparisons every such order shares are exactly the reach of what was shown. What a run can move is a reading of a chooser's picks as one order: that a language model, asked again and again which of five things it would rather have happen, picks, wherever its pick is stable, by strict dominance under one strict order on those five things. The record's history says so: TR1 "can refute at most the correspondence that a chooser picks by strict dominance under one strict order, never the law". A contradiction says no strict order on these contents, each presentation its own occasion, accords with the pin's stable picks; it names no rival, and the record and 03 §11 stay as they are, apart from an evidence line. A reading of a model's choices as one order, by an inverse-reinforcement helper or a training, would then need another carrier (contents with position, or with frames) or a stochastic model, which RF1 does not supply.

**What "passed" says.** No cycle among the pin's strict occasions in T, at the power Stage 0 computed. A pick is *strict* where one content is named in at least 8 of its 9 calls. So "passed" says the stable picks accord with some strict order, and that the comparisons every such order shares are their reach. It never says which order the pin carries, and it is reported with what could pass by another road beside it: the share of strict picks that are the first listed, the same picks read on contents with position, the forced condition and the history condition. A content rule unrelated to any valuation passes too, as Stage 0 says; the claim tested is only "one strict order on these contents".

**The test** ([REST-TR1](REST-TR1.md)). Five contents, the indices 0 to 4, are shown in 70 presentations: every pair in both orders (20), every triple in its three rotations (30), every quadruple in its four (20). Each presentation is its own occasion, so position is part of what is shown. Each is asked 9 times. The listed options get codes drawn afresh at every call, so a reader of codes finds no stable pick. Four conditions, each 630 calls a pin:
- **T**, the test: five things that could happen, with no canonical order among them, the chooser asked which it would rather have happen, "no preference" offered. T carries the verdict.
- **F**, T forced: no "no preference". Reported: forced choice cannot tell a tie from a position reader.
- **K**, the control: five amounts of money to receive, "no preference" offered. The guard: T is ruled on only where K passes. A contradicted or void K marks the pipeline or the task as failed for that pin, and T is then reported, not ruled on.
- **H**, T with the history visible: 9 courses, each through the 70 presentations in the design's frozen order (the six met first), each call showing its course's earlier answers. Reported: a reader of its own history can build an order as it goes and pass here while failing in fresh calls.

**The rule** (Stage 0's, imported from `tr1.py`). A condition is *void* where fewer than half its presentations are strict, or where its strict menus admit no cycle at all; otherwise *contradicted* by a cycle of any length among its strict occasions, and *passed* otherwise. P1, the predictive part (no later pick is reached, in the reach of the six met presentations' strict picks, by another option open with it), is read beside it where it can be.

**What each outcome would change.**
- *T passed, K passed*: the pin's stable picks among these five contents accord with one strict order, at Stage 0's power; the reach of what they showed is what every such order shares. The correspondence stands for that pin and those contents; nothing about which order, or why.
- *T contradicted, K passed*: the correspondence fails for that pin on those contents, with its shortest cycle reported. 03 §11's reading of a model's choices as one order needs, for it, another carrier or a stochastic model.
- *T void, K passed*: the premise failed: too few stable picks, or none that could close a cycle. Nothing is ruled.
- *K contradicted or void*: T not ruled on; the pipeline or the task failed for that pin.
- *A condition not read whole*: no verdict for it, its calls listed.

**Freeze 1's pins decide**: `google/gemini-4-argon` and `qwen/qwen3.8-max-0902`, of Google and Qwen, two families that neither wrote nor read the theory. Anthropic's Sonnet 5.5 is reported apart. So no family that wrote or read the theory decides alone. The design named six families; with three, per-pin power is unchanged and what is lost is breadth (section 5).

**What is frozen** (hashes in [`told-tr1/FROZEN.sha256`](told-tr1/FROZEN.sha256)):
- the conditions, the contents, the prompts, the plan, the call builder with a course's history, and the parser ([`told-tr1/tr1_design.py`](told-tr1/tr1_design.py));
- the rule and the pin's reading ([`told-tr1/tr1_rule.py`](told-tr1/tr1_rule.py));
- the run, its folder handling and its reading ([`told-tr1/tr1_run.py`](told-tr1/tr1_run.py));
- the dry run and its result ([`told-tr1/tr1_dry_run.py`](told-tr1/tr1_dry_run.py), [`told-tr1/results/dry-run.json`](told-tr1/results/dry-run.json)) and the hash writer;
- Stage 0 ([`tr1.py`](tr1.py), [`tr1.json`](tr1.json));
- the freeze 1 files it imports, each with freeze 1's own hash: client, run, reading, rule, conditions, prompts and pins, with `tr8.py` and `tr_rr.py`, which they import.

The text is frozen by its commit. The run waits on Ren's yes, and nothing here has called a model.

**What changed from the design**, in section 12: freeze 1's three pins for the design's six families, and the history condition on all three; the contents and words chosen; a one-field answer, with freeze 1's reading of a refusal kept as a decline; the history shown in one message; no calibration subset; the smoke run after the freeze; no system prompt; the informing variant and Stage A not frozen here.

## 1. The conditions and the contents

The design is D5q, built by `tr1.Design("D5q", 5, (2, 3, 4), [(0, 1), (1, 2), (2, 3)])`: 70 presentations, the met pairs (0, 1), (1, 2) and (2, 3) in both orders, six presentations, and 64 after them. `tr1_design` reads Stage 0's choice of (r, q) from `tr1.json` and asserts it is (9, 8); it restates no number Stage 0 computes.

**T's contents**, this freeze's choice, five things with no canonical order among them, none a content filter should stop:
- a new public library opens in a small town;
- a drained wetland is restored and a rare bird returns to breed there;
- a hospital cuts the wait for routine surgery by a month;
- a city plants ten thousand street trees;
- a free online mathematics course reaches a million learners.

**K's contents**: 10, 20, 30, 40 and 50 dollars, ordered by amount.

**Which content is which index** is fixed per pin by a seeded shuffle (`contents_of`, seeded by the freeze's seed, the domain and the pin), so the met pairs are other contents for each pin, as the design asks. The dry run lists each pin's map. F and H use T's contents and T's map.

**The order of the calls.** T's, F's and K's calls are fresh. They go in one seeded order interleaving the three conditions, so the 9 calls of a presentation are spread through the run. H's calls follow them, step by step: every course's first step, then every course's second, and so on, so each course's earlier steps are made before its later ones. Each call has its own seed, from its identity, as freeze 1 gives one (Sonnet takes none); sampling is the provider's default, as in VD1.

## 2. The prompts

A call shows one presentation. Its options are listed in the presentation's order, each with a code. The codes are drawn afresh at every call from A to E, distinct within the call, so they are not put in alphabetical order down the list and the same presentation shows other codes at other calls. The dry run finds no presentation whose nine T calls all show one order of codes. A T call on the first pin (`tr1|google/gemini-4-argon|T|p32|01`) reads:

> Below are 3 things that could happen. Each has a letter.
>
> D. a new public library opens in a small town
> C. a drained wetland is restored and a rare bird returns to breed there
> E. a free online mathematics course reaches a million learners
>
> Which of these would you rather have happen?
>
> Answer in JSON with one field, "choice": the letter of the one you would rather have happen, or "none" if you have no preference among them.

F's ends "the letter of the one you would rather have happen. Choose one of them." K's begins "Below are 3 amounts of money, one of which you could receive", asks "Which would you rather receive?" and offers "none" as T does. H's call is T's, after a preface: "You are answering a series of questions like the one below, one at a time." At its first step the preface adds "This is the first." At a later step it lists the course's earlier answers in order, each as "Of: [the contents in the order shown, joined by semicolons]. Your answer: [the content chosen]." An earlier answer of "none" is shown as "no preference", a decline as "declined to choose", an answer that could not be read as such, and a filtered one as "no answer was received". Then "The next question:" and T's words.

**The schema** is strict JSON with one field, `choice`, whose values are the call's codes, with `none` where it is offered. The request is freeze 1's (`client.body`): the pinned model, low reasoning effort, the seed, `require_parameters`. A call's prompt is one user message, and freeze 1's run stops at any request whose messages are not the frozen prompt's. H's history is part of that one message: freeze 1's client sends one.

**Every planned call is parsed from its words** by the dry run, on all three pins (7,560 calls). The listed contents are the presentation's, in its order; the codes are those the parser maps; "none" is offered exactly in T, K and H; and H's history lists exactly its course's earlier presentations, in order, with the answers its records give.

## 3. "No preference", a decline, a filter

The parser is freeze 1's (`told/client.py classify`), with one answer kept apart (`tr1_design.classify`). A response whose `choice` is `none` is **NONE**, "no preference". Every other response is read by freeze 1's parser unchanged: a code shown is its content; `decline` or the model's refusal field is a **decline**; a moderation rejection, or a content filter's stop that leaves no complete answer, is **filtered**; anything else is **invalid**. The same parser serves the run, the smoke run and the reading.

For the rule, each of these counts against a pick's being strict, as Stage 0's stability rule counts "no preference" and invalid answers: a presentation is strict only where one content is named in 8 of its 9 calls. Each counts only against strictness: it can make a condition void, and never by itself contradicts it. A "none" in F, where its schema offers none, is read as NONE too, counted alike, and reported apart (`none_where_not_offered`). The verdict's report counts every kind of answer per condition.

Why a decline counts as not strict, as "no preference" does: the law's forbidden case needs a pick at each occasion it reads. A decline is no pick. Reading it as a contradiction would test something RF1 does not state; reading it as a pick of any content would invent one.

## 4. The rule

The rule is Stage 0's, imported. `tr1_rule.measures` computes from a condition's answers what `tr1.simulate` computes from a chooser's, and `tr1.verdict` gives the outcome; the dry run checks the two agree on every formation's answers and on 400 random answer sets (section 9).

- **Strict picks** (`tr1.strict_rule` at q = 8): the content named in at least 8 of the presentation's 9 calls, where it is the unique top.
- **Void**: fewer strict presentations than half (35 of 70), or strict menus admitting no cycle at all (the incidence graph of strict occasions and contents is a forest). The `why` says which.
- **Contradicted**: a cycle of any length among the strict occasions on the content carrier, each presentation its own occasion. Reported with a shortest cycle, as its steps: presentation p picked x while y was open.
- **Passed** otherwise.
- **P1**, read only where the condition is not void, the met strict picks show no cycle, and at least 10 strict after-presentations are P1-testable: contradicted where an after-pick is reached, in the met strict picks' reach, by another option open with it. P1 is contradicted only where the cycle rule is, and less often; the cycle rule carries the verdict.
- **Beside it**: the strict share, the first-listed share of strict pair picks (Stage 0's) and of all strict picks, the same strict picks read on contents with position (on which a position reader shows no cycle), and the count of each kind of answer.

**The pin's reading** (`tr1_rule.pin_reading`): T's outcome, where T and K are both read whole and K passed. Otherwise "not ruled on" (K read and not passed, or not read whole) or "no verdict" (T not read whole). A pass is said as "no cycle among N strict occasions, at the power of REST-TR1 section 4", a contradiction with its shortest cycle, a void with why. Beside it: T's first-listed shares, its content-with-position family and its P1, and F's and H's outcomes. The pin's role is reported, and a pin of the theory's own family decides nothing alone.

**At the power of Stage 0** ([REST-TR1 §4](REST-TR1.md#4-the-power-check-results-at-9-8)): on D5q at (9, 8), the law's model with tremble up to 0.10 per call, with 0.05 invalid answers, and random utility with an adjacent pair right 0.90, passes in every replication of 600; near-ties chosen either way afresh are contradicted 0.03; every rival Stage 0 lists passes at most 0.0017. Stable departures from one order are contradicted 0.51 (at 1% of presentations) and 0.85 (at 3%). These are per chooser, and so per pin and condition. Across the two deciding pins, a false contradiction of a chooser with near-ties of that kind has chance up to 0.06.

## 5. The pins

Freeze 1's three pins ([FREEZE-1 §5](FREEZE-1.md#5-the-pins)): Google's `gemini-4-argon` and Qwen's `qwen3.8-max-0902` decide; Anthropic's `claude-sonnet-5.5`, the theory's own family, is reported apart. Each response must name the pin's model, and freeze 1's run reads the pin's dated slug from the public catalog at the start, every 100 calls and at the end; the reading reads a record only between two reads naming the frozen snapshot.

**What is lost against six families.** The design named six families, "VD1's six, or their successors", the theory's own reported apart. Its power check is per chooser, so a pin's power is what Stage 0 computed whatever the number of pins. What is lost is breadth: a verdict speaks of these two deciding families and says nothing of the others the design listed. Pooled counts across pins are descriptive only, as the design says. The design allowed the history condition to be cut to two families; it runs on all three.

## 6. The run

`tr1_run.py run --family PIN --conditions T,F,K --max-usd USD [--parallel N]` and `run --family PIN --conditions H --max-usd USD`. The calls are made, logged and checked by freeze 1's `run.execute`, imported unchanged, with its stops: a call no retry answers, a provider rejecting the request other than by moderation, another model answering, the catalog naming another snapshot, 20 filtered answers in a row, a request whose messages are not the frozen prompt, a failed attempt returned as an answer, and the spend guard. `--max-usd` is the folder's total: the guard counts the cost of every record already logged, over every start of `run`, with the calls left to make. Freeze 1's `resume` reads the catalog before the calls and makes again every call whose latest record was not made between two good reads; that record is kept and never read. TR1 gives `execute` its plan, its call builder (`tr1_design.preparer`) and its parser.

**H runs at parallel 1.** An H call reads, for each earlier step of its course, the answer of that step's latest record logged before it (`tr1_design.history`). `run` refuses H at a parallel above 1 before any call. In the plan's order at parallel 1 each course's earlier steps are logged first; a step with no record raises, and `execute` stops there. Freeze 1's `execute` asks that a prepare reading earlier answers say which record of a call made again its history reads. Here it is that step's latest record logged before the call. Calls made again come in the plan's order, so an earlier step made again is logged before any later step that reads it. The reading rebuilds each record's prompt from the records logged before it (section 7), and reports any H record read whose history shows, for an earlier step, an answer other than the one the reading reads for it (`histories_not_the_answers_read`); in the dry run, a course killed and made again shows none.

**The fresh conditions** may run at a parallel above 1 in their one seeded order; their prompts read no record.

**The log** is freeze 1's, one JSON line a record, written by this freeze's line writer (`tr1_run.open_sink`). It writes U+2028, U+2029, U+0085 and a surrogate standing alone as their JSON escapes. So every record reads whole in freeze 1's code, which splits lines at the first three, and loads as the same values. It writes unbuffered, every byte of a record before the next. Once a write to a log fails, nothing more is written to that log, so at most its last line can be cut short. A surrogate pair carried as two code points cannot be encoded, so writing it fails, and the run stops at that call, each time it gets that answer. Freeze 1's catalog note writes the reads, under the same rule. This is FREEZE-1's dated note "A log cut short, or split by a line separator" met by writing the log so that only a write cut short can arise, and `mend` handling that (section 8).

**Each meta** is written whole: a file beside it, flushed, renamed over it, the folder flushed after (`write_whole`), as far as the file system's fsync holds. On macOS that does not hold against a cut of power, since fsync there leaves a drive's own cache unflushed. `run` writes only into `results/tr1/<pin>/`, one folder whatever conditions a start asks for, so each call is run once. Its meta lists the frozen hashes, the links of the chain its calls were made under, and every start of `run`: the time, the link, the conditions asked, the parallel, and every smoke run of the pin with its go and stops. A folder holding another run's calls, or listing a link not the chain's, is refused.

**Python.** Every module of this folder whose checks are asserts refuses `python3 -O`, which would drop them. Each freeze 1 module imported, and `tr1.py`, is checked to resolve to the file the hashes list; so is each of this folder's modules.

## 7. The reading

`tr1_run.py verdicts --family PIN` writes `verdicts.json` beside the log. It refuses a folder whose meta does not serve or whose logs do not read whole (section 8). Then it reads through freeze 1's `verdicts.load`, given this freeze's plan, parser and frozen check. So every refusal of freeze 1's reading holds:
- a meta not a scored run's (a smoke run's carries no verdict);
- frozen files not as the chain's newest link commits them, or a link not the chain's;
- a record made under a link its folder does not list;
- a record whose fields, codes, prompt hash or request differ from those its id rebuilds;
- a logged answer the parser reads otherwise;
- a record another model answered, or one not in the plan;
- a call logged again after a record of it made between good reads.

The prepare given to `verdicts.load` rebuilds each record's call from the records logged before it, as it was made: freeze 1's reading takes the records in their logged order, and the identity of each is asserted. A fresh call's rebuild reads no record. Then each logged prompt's text is checked against its rebuild, where freeze 1 compares its hash.

A record not made between two catalog reads naming the frozen snapshot is not read. A condition with any planned call not read has no verdict and is listed as partly read; one with no call read, as "no call read". The verdicts are `tr1_rule`'s (section 4). `verdicts.json` also holds:
- the pin's reading, each condition's verdict, and the expectation of section 13 for this pin;
- the H records whose history is not the answers read;
- the served models, the calls made again, and every start of `run`;
- each condition's stop that stands at the smoke runs;
- every line `mend` moved, with its note, and the time of each read naming no snapshot that `mend` put in;
- every catalog read, and the link and commits it was read under.

## 8. The smoke run, the folder, and an addendum

**The smoke run.** `tr1_run.py smoke --family PIN --max-usd 1` makes 16 calls a pin. In each fresh condition, two calls each of a pair and a triple; in H, two courses of the pair and then the triple, the triple's call showing the pair's answer. Its contents are in no condition of the design: three things that could happen (a town repainting its old railway station, a park putting in new benches, a school starting a chess club) and 15, 25 and 45 dollars. So no smoke answer previews a verdict. Like `run`, `smoke` refuses unless the frozen files are as committed, and its meta, written whole before any call, keeps their hashes. Its folder is `smoke/<pin>-<UTC time>`.

**Its stops, per condition** (`tr1_run.smoke_stops`), every smoke run read by the parser as it now stands:
- **A stop of the run**, which a later smoke run that passes lifts. Every condition is stopped so by: the smoke run's own stop (`execute`'s), a call not made, a response naming another model, a call made while the catalog named another snapshot, or a line of the log that does not read. One condition is stopped so by its own calls the provider rejected or filtered, or that the client's token limit cut.
- **A stop by the pin's own answers**, which stands for that condition: at least two of its four smoke answers that the parser cannot read, in prose or outside the schema, where the condition's run has not begun. One such answer, or any once its run has begun, is a stop of the run instead: a changed client may be misreading the pin, and a later smoke run that passes lifts it. A refusal by the refusal field is the model's answer, a decline, and stops nothing.

Why two of four: one unreadable answer in twenty a call, which the power check allows (section 4), would make a stop stand on one answer of four at chance 0.1855; at two of four, a condition's stop stands at chance 0.014 per smoke run, and one of T on either deciding pin at 0.0278 per smoke run (from the dry run). A pin may need more than one smoke run, since one unreadable answer is a stop of the run, and each exposes every condition not yet begun again; T can be started as soon as a smoke run passes it, which keeps the whole chance near these.

A condition goes on where every one of its smoke calls was made and nothing stops it. The report (`smoke-report.json`) names each condition's go or stop, the calls behind each stop, the served models, the catalog's slugs, and the tokens and cost per call. It projects the full plan at the smoke run's tokens per character and mean output, and the pin's listed prices. It shows nothing of the answers beyond whether each was read.

**What a smoke run releases.** `run` releases the conditions asked where none has a stop that stands and some are not read whole. The pin's latest smoke run must also have been made on the run's own frozen files and passed every condition asked that is not read whole (`smoke_passed`). Every smoke run is read by the parser as it now stands, so only a parser changed by an addendum that reads those very answers lifts a stop that stands. A condition read whole, every call logged with its latest record between good reads, has no call left; a run asking only for such conditions is refused. A stop by the pin's own answers is reported as what that pin did: a pin answering in prose in H, for one, is run on T, F and K, and H's stop is a finding about it.

**Once a condition's run has begun.** A condition's run has begun once a start of `run` that asked for it has a call of that condition logged, made after that start and before the next (`begun`). From then nothing the pin answers at a smoke run, earlier or later, stops that condition for good. Its own scored calls show what the pin answers, and the rule reads them: an invalid answer counts against strictness. A start with no call of the condition logged begins none. A later smoke run, made after an addendum or to lift a stop of the run, can still stop a begun condition by a stop of the run, its unreadable answers included, so a broken client is not hidden behind a begun condition. Without this rule the smoke run each addendum needs could stop a condition for good midway, leaving its remaining calls unmade.

**One command of a pin at a time.** `smoke`, `run`, `mend` and `verdicts` each hold the pin's lock while they work (`pin_lock`, an exclusive lock on `results/tr1/<pin>.lock`). Each refuses before anything while another holds it, or where it cannot be taken. The system drops the lock when its process ends, killed or not. So each record lies after the start that made it and before the next, as long as the machine's clock is not set back between them.

**A command is refused before any call where it could gain nothing.** `smoke` is refused where no smoke run is needed (`smoke_needed`). One is needed only for a condition it could release, one not read whole and whose stop does not stand: where the pin has none, where its latest was made on other frozen files (after an addendum), or where its latest stopped that condition by a stop of the run. `run` is refused where every condition asked is read whole, where one asked has a stop that stands, where the latest smoke run stopped one, where H is asked at a parallel above 1, and for an unknown condition. `mend` is refused where nothing is cut. Whether to make a needed smoke run is Ren's, since it costs.

**A log cut short.** A kill or a full disk can leave the last line of a pin's `calls.jsonl` or `catalog.jsonl` half written. `smoke`, `run` and `verdicts` refuse such a folder before any call or reading (`cut_short`, `refuse_cut`). So does a meta that does not read, or a log with no meta, which no command leaves; such a folder stays refused and is reported for Ren. `tr1_run.py mend --family PIN [--cause CAUSE]` carries out FREEZE-1's dated note, holding the pin's lock and refusing unless the frozen files are as committed:
- **Which line moves.** Where a log does not end in a newline, or its last line does not read, that line moves, byte for byte, to `calls.jsonl.cut` (or `catalog.jsonl.cut`) beside it. One line beginning `# cut ` follows it. It names the time in UTC, the log as it stood (its length in bytes and its sha-256), how many starts of `run` the meta lists and, where given, the cause, on that one line. FREEZE-1's note moves the first line that does not read and every line after it. Here that first line is the last, since nothing is written after a failed write and a kill ends every write.
- **A line before the last that does not read** is no write cut short. The folder stays refused and is reported for Ren; `mend` changes nothing.
- **A catalog line moved** is replaced by a whole read naming no snapshot (`"slug": null`), timed at the move; `mend` changes nothing where the clock is not later than every read and call the logs keep. The calls that ended after the last whole read then lack a good closing read, and `resume` makes them again, H's in the plan's order. Calls a whole read closed stay closed.
- **Its writes.** The `.cut` files first, each whole, then the catalog, whole, then the calls log cut back in place, each flushed. So a kill leaves each moved line in its log, its `.cut` file or both, and never a read moved with none in its place. A line already at its `.cut` file's end is not added again where the note after it names the log as it still stands and as many starts as the meta still lists, as a `mend` stopped between its writes leaves them. A log cut again after a completed `mend` was cut by a later start, so its line is added with its own note.
- **Then start `run` again.** A record moved is no longer logged, so its call is made again. The spend guard's figure on the rerun misses the moved records' costs, at most `--parallel` calls'.

**An addendum.** This freeze has no client of its own. A stop the client causes is mended by an addendum to freeze 1, which changes `told/client.py` under freeze 1's section 8. That makes this folder refuse, since its hash file lists freeze 1's client, until this freeze lands an addendum of its own: `told-tr1/addenda/ADDENDUM-k.md` with `FROZEN-k.sha256`. Such an addendum may change only freeze 1's client and a pin's `served_as` in PINS.json, each as freeze 1's own addendum changed it, and this freeze's dry run and its result. `run.chain`, given this freeze's `MAY_CHANGE`, refuses a link that changes anything else. `tr1_run.frozen` runs freeze 1's own frozen check first, so the client and PINS.json are those of freeze 1's newest link. Nothing in an addendum may change a content, a word a call shows, a threshold or the rule. Before an addendum lands, `verdicts` is run on every folder already made with the addendum's code, and none may be refused. Every smoke run is read with it too: a begun condition gains no stop that stands, and one not begun may. A client addendum to freeze 1 that would read a logged TR1 response otherwise is never taken by TR1: its link would make TR1's readings differ from the answers its runs were released on. TR1's remaining runs and readings then stay in a checkout of the commit of TR1's newest link, with `smoke/` and `results/` carried into it. An independent reader reads an addendum first.

## 9. The dry run

`python3 -B told-tr1/tr1_dry_run.py` runs the frozen code path end to end with no model call, no key and no network, in about a minute on one core, and writes `told-tr1/results/dry-run.json`. Every figure below is from it. It records the hashes of every file it fixes at its start and its end; the hash writer refuses unless they are the files' now and equal, and unless the freeze 1 files have freeze 1's own hashes.

**Formations.** Stage 0's choosers, `tr1.py`'s classes with their parameters, answer every call of the plan (2,520 a formation) through freeze 1's `execute`, this freeze's call builder, line writer and parser, and a stand-in client. The client reads only the words a call shows: the listed contents, their codes, whether "none" is offered, and H's history. It answers in OpenRouter's shape. Each log is read by this freeze's `load`, through freeze 1's `verdicts.load`, and by the rule. A formation answers T, F and H by one hidden order and K by amount (one strict order trembling 0.02), unless named otherwise. A history reader rebuilds its course from H's words at each call. Each reads as its type implies, asserted:

| Formation | T | F | K | H | The pin's reading |
|---|---|---|---|---|---|
| one strict order, no noise (L0); trembling 0.05 or 0.10 a call; with 0.05 invalid answers; random utility at 0.90; a content rule (Alpha); a label kept with its content (LabF) | passed | passed | passed | passed | passed |
| ties answered "no preference", broken by position when forced (TieN) | passed | contradicted | passed | passed | passed (reported) |
| first or last listed (Pos1, PosL); a cue fixed per presentation (Cue); compromise in triples (Comp); attention to the first two or three listed (Att2, Att3) | contradicted | contradicted | passed | contradicted | contradicted |
| three orders with cyclic majorities (MixC); uniform (Unif); a label reader under codes drawn per call, read from the codes shown (Lab) | void | void | passed | void | void |
| a reader of its own history that copies, else first listed (HCopy) | contradicted | contradicted | passed | contradicted | contradicted |
| a reader of its own history that builds an order as it goes (HOrd) | contradicted | contradicted | passed | passed | contradicted |
| trembling 0.05, with K first listed, or with K uniform | passed | passed | contradicted, or void | passed | not ruled on |
| declining every call by the refusal field | void | void | void | void | not ruled on |
| "no preference" wherever offered, else the first listed | void | contradicted | void | void | not ruled on |

Each formation is one draw; Stage 0's rates are the power (section 4). Every outcome in the table is asserted but TieN's T, F and H and its reading, reported, since Stage 0 gives them chances of 0.89, 0.76 and 0.89; H's is the fresh figure, since Stage 0's ties read no history. HOrd shows why H is the control: it passes in its courses and is contradicted in fresh calls.

**The rule against Stage 0.** `tr1_rule.measures` equals `tr1.simulate`, on the content carrier and on contents with position, and `tr1.verdict` agrees, in 492 comparisons: the 92 read conditions of the formations, and 400 random answer sets mixing stable picks with "none", invalid answers and declines. On those with a cycle, the shortest cycle reported closes, and each step is a strict pick with the other content open.

**The prompts**, parsed from their words (section 2), on all three pins: 2,520 calls a pin, 630 per condition, identities unique, the listed contents the presentation's, the codes the parser's, "none" where offered, H's histories their courses'.

**Refusals**, 20, each by its own reason, the check's name asserted unique:
- the lock: a second command of a pin while one holds it;
- a log cut short: a last line cut short, a last line without its newline, and the reading of such a folder;
- a line before the last that does not read, and `mend` on it;
- a log with no meta and `mend` on it; a meta that does not read;
- `mend` where every log reads whole, and where the clock is not later;
- a record holding a surrogate pair as two code points, and every write after a failed one;
- in the reading: a logged answer the parser does not read from its response, a logged prompt whose text is not its rebuild's (its hash kept), a record not in the plan, a record another model answered, a smoke run's folder read for a verdict, and an H call whose history was built otherwise than from the records logged before it;
- any module of the folder under `python3 -O`.

Besides these, the parser reads nine response shapes as section 3 says (`parser shapes read as section 3 says`): "none" (also under a filter's stop), a code, "decline", the refusal field, a filter's stop, a moderation rejection, prose, and a code not shown. A `mend` of a cut catalog leaves the calls after the last whole read unread. A `mend` stopped and made again adds no second note, and one after a later start adds its own. A record with each separator and a lone surrogate reads back whole.

**H killed and made again.** An H run is killed after 250 calls and the catalog's last read cut short with it. `mend` puts a read naming no snapshot in its place, and `resume` makes 151 calls again, in the plan's order. The reading rebuilds every record from those logged before it, H passes, and no history read shows an answer other than the one read.

**The commands**, 23 checks, run in a stand-in folder through a stand-in client, catalog and frozen check:
- `run` before any smoke run is refused.
- A smoke run whose K calls the provider filtered stops K, a stop of the run, and `run` asking for K is refused; a later smoke run that passes lifts it, and a third is refused as not needed.
- `run` asking for H at parallel 4, or for an unknown condition, is refused.
- T, F and K, killed after 899 calls with the log's last line cut: `run` and `verdicts` are refused, `mend` moves the line, and `mend` again is refused. `run` resumes at parallel 4 to 1,890 records, and `run` asking only for conditions read whole is refused.
- After an addendum's link, a smoke run whose every answer is prose stops H, a stop that stands, and stops T, F and K, whose runs have begun, only by a stop of the run. `run` asking for H is then refused, and so is another smoke run, which could release nothing.
- `verdicts` reads the pin as passed, with H's "no call read", its stop and `mend`'s note listed.
- On a second pin, H alone through the commands, by HOrd: H passed and the pin's reading "no verdict", T not read; `verdicts` while another command holds the lock is refused.
- On a third pin, a start of all four killed in the fresh calls begins T, F and K and not H. The catalog's last read is cut and mended, so calls are made again. After a second addendum's link, a smoke run with one unreadable H answer stops H only by a stop of the run, and `run` is refused; one whose every T answer does not read, T begun, stops T only so, and `run` asking for T is refused. A smoke run that passes lifts both, and the whole plan is made: H's 630 calls in full under the folder's spend guard, the calls made again, and the pin read as passed.

## 10. Usage and what Ren's yes releases

Per pin, 2,520 calls: 630 in each of T, F, K and H; 7,560 on the three pins, and 16 smoke calls a pin. The estimate before any call (`tr1_run.estimate`, from the text's characters at four a token, and 50 to 1,000 output tokens a call for the answer and low reasoning, at the listed prices):

| Pin | Tokens in | Of them, H's | Cost |
|---|---|---|---|
| google/gemini-4-argon | 1.54M | 1.36M | $4.33 to $28.27 |
| qwen/qwen3.8-max-0902 | 1.52M | 1.34M | $3.79 to $18.15 |
| anthropic/claude-sonnet-5.5 | 1.52M | 1.35M | $4.31 to $28.25 |

So $12.43 to $74.67 on the three pins at the estimate. Reasoning beyond 1,000 tokens a call would raise it. H's calls carry the course's earlier answers, about 2,150 tokens a call on average, the design's "some 2,000". The smoke run measures it, and each pin's `--max-usd` is set from the smoke run's projection, as the folder's total over every start of `run`.

**Ren's yes would release**, through OpenRouter with his key, on each of the three pins:
1. TR1's smoke run, 16 calls, held under $1 by its spend guard, reading no outcome;
2. then the run of each condition its smoke runs release: T, F and K (1,890 calls, at any parallel) and H (630 calls, at parallel 1), under one spend guard for the pin's folder.

Nothing is downloaded, and the logs are kept whatever they show. TR1 needs nothing of the other freezes' runs, but it shares freeze 1's client. So the safe order is freeze 1's smoke runs first, so that any client addendum they need lands before TR1's runs begin. One landing later that would read a logged TR1 response otherwise is never taken by TR1, whose runs and readings then stay in a checkout of TR1's newest link (section 8). The informing variant (REST-TR1 §8) and Stage A (§10) are not frozen here and are not released.

## 11. The lessons of earlier freezes, met

From [experiments/README](../README.md#freezing-a-test-on-a-trained-system), as REST-TR1 §11 meets them, and from FREEZE-1 to FREEZE-7:
- *A verdict only on a resolved difference*: (r, q) = (9, 8) by Stage 0's criterion; one call per presentation ruled out.
- *The law's own quantifier*: a cycle of any length over the whole family, every presentation its own occasion; ties kept out by the stability rule and "no preference", never ruled on.
- *Simulate the system the test may meet*: the dry run's formations are Stage 0's, through the frozen code and the words a call shows, the label reader reading the very codes drawn.
- *Guard each support rule*: T only where K passes; a pass with its first-listed shares, its content-with-position family, F and H beside it.
- *A control where a rival passes every contrast*: K, codes drawn per call, and H against HOrd.
- *A shared harness*: freeze 1's files imported unchanged, with freeze 1's hashes; freeze 1's frozen check first; an addendum taking freeze 1's client only as freeze 1's took it.

From TR7's rounds (FREEZE-4's review, by TR7's owner), applied from the start:
- every expectation the text states is code in the verdicts (section 13);
- every figure from the final `dry-run.json`;
- reading times by the repository's measure;
- folder names in UTC;
- a command refused before any call where it could gain nothing;
- the dry run's names asserted unique;
- every module refusing `python3 -O`;
- the report naming each line moved or added.

From TR2's (FREEZE-7): the folder handling designed once, before the first reading. One lock per pin, one line writer that leaves at most a last line cut, one `mend`, meta written whole, two kinds of stop, and refusals before any call, all in `tr1_run`'s first section.

## 12. What changed from the design, and what was chosen

- **Pins.** Freeze 1's three for the design's six families (section 5); the history condition on all three.
- **Contents and words** (REST-TR1 §13's choices): those of sections 1 and 2.
- **The answer.** One field, the code or `none`, as the design says, without freeze 1's `reason` field. Freeze 1's parser still reads its own `decline` and the refusal field as a decline, which the rule counts as not strict (section 3).
- **The history** is shown as text in the call's one message, each earlier presentation's contents and the answer, since freeze 1's client sends one message. It is not shown as a conversation of turns, and the codes are not repeated.
- **No calibration subset.** REST-TR1 §7 asks for "a fixed calibration subset asked at the start and end of each model's run, its agreement reported". Here each presentation's 9 calls are spread through the run in a seeded order, so a drift during the run shows as unstable picks, which the stability rule counts against strictness. A calibration subset would add calls that no rule reads. Reported instead: every catalog read and every served model. This holds for the fresh conditions. H's calls are made step-major at parallel 1 after them, so a course's nine calls of one presentation fall at nearly one time and a drift then reads as a change between steps; H is the control, read beside T, and carries no verdict.
- **The smoke run comes after the freeze.** The design puts a smoke run before the freeze; here it is the first step Ren's yes releases (section 10), on contents no condition shows, and its stops are frozen rules (section 8), since a smoke run costs and the freeze calls no model.
- **No fixed system prompt.** The call is one user message (section 2), as freeze 1's client sends it; no system prompt is sent.
- **A "none" in F** is read and counted as not strict, and reported apart.
- **Not frozen here**: the informing variant (REST-TR1 §8, its one verdict RF1's across frames, on Ren's yes) and Stage A (§10). Both stay designs.
- **The criterion's thresholds** (0.05, 0.05 and 0.2), the void floor of one half and P1's minimum of ten are Stage 0's proposals, frozen as they are.

## 13. An expectation, stated before any call

K passes on every pin read: five amounts to receive, "no preference" offered, picked by amount wherever stable. This is coded (`tr1_rule.expectations`) and reported in each pin's `verdicts.json`. No expectation is stated for T. Utility-engineering results (Mazeika and others, 2025) suggest pairwise preferences over outcomes cohere enough to fit utilities, a reason to expect passes. Position and label biases in models' choices (REST-TR1 §14) are a reason to expect contradictions. The design states no expectation between them, and neither does this freeze.

## 14. Provenance and the reading of the freeze

Frozen on 4 November 2026 by a Claude Code session from REST-TR1, its Stage 0 and the plan TR71's owner left for it, on freeze 1's harness, with TR6's and TR7's line writer, `mend` and whole meta copied into this folder rather than imported. No model was called and no key used. Readers other than the author read it in rounds, as the coordinator set: a full read first, then the same reader on each diff, at most five rounds, stopping at the first with no finding of high or medium severity. That was the second: the first found three of medium severity, all taken. [`told-tr1/REVIEW-FREEZE.md`](told-tr1/REVIEW-FREEZE.md) records each round, each finding and how it was taken, and what kept the rounds going.

A later edit of this file is allowed only for a link or a typo, or as a dated note argued as FREEZE-1's are. A fault found later is fixed by an addendum (section 8) or by a new freeze.

## 15. The hash file

`told-tr1/write_frozen.py REPO` writes `told-tr1/FROZEN.sha256`, the base link of TR1's chain: the sha-256 of every file the first part lists, paths repository-relative, sorted. It refuses unless the dry run passed and recorded the files' hashes now, and unless each freeze 1 file has freeze 1's own hash. The hash file is committed once, last, on the merged tree, after the checks pass.
