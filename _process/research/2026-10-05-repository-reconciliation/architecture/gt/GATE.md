# GT: the landing gate by what a change reaches, and trains

**Status:** landed 4 November 2026 (main `34a3b6c97`); GT1, the follow-up of 5 November, adds the push tier, link-only freeze differences, salvaged pins and the board guard's corrected replay (§3.5 to §3.7). AI-written. The tool is [tools/research/gate.py](../../../../../tools/research/gate.py), with its tests in [test_gate.py](../../../../../tools/research/tests/test_gate.py). Ren asked whether the checks are "just the right amount" and said the work waits on them; he agreed to this direction the same day ([source](../../../../../sources/15-codex-theory-conversations/2026-11-04-checks-and-order.md)). The coordinator's ten requirements, sent before any slot was asked ([kept here](COORDINATOR-REQUIREMENTS.md)), are all met (§9). The draft rests on four read-only maps of what each check reads and costs ([measurements/](measurements/)). It was reviewed by an independent author of its tests, who found twelve bugs, and by two readers, one for soundness and one for the text, whose findings are all taken (§10). About twenty-five minutes to read; §0 takes three.

## 0. In three minutes

A check's result is a function of what it reads. Two things follow.

1. **Run a check only when something it reads has changed.** A landing's changed paths select its checks (§3.1). A rule naming a path the tree lacks fails the gate, and a path in a new top-level area selects every check. So a stale rule stops the gate instead of skipping a check. A path missing from a rule inside a known area is not caught that way; the guards against it are the strict check, which reads nearly everything, the reasons stated beside each rule, and the full set at each phase's end (§7).
2. **Run it once for one state of what it reads.** A pass is kept with the tree it passed on and the command as run. It holds again on the same tree. It also holds on a later commit, when the passed commit is an ancestor and the diff between them touches nothing the check reads. When main moves under a landing, only what the move reaches is run again (§3.2).

Three further changes keep the runs that remain short and few:

- **The checks made cheaper where a part of one is a function of its inputs** (§2). `research.py check` took about 77 seconds, about 50 of them recomputing the same Markdown drift comparisons on every run. These are now kept by the bytes compared, with identical results, and the check takes 33 seconds.
- **Trains** (§4). Landings ready together are merged and checked once, each keeping its own commits and landed clause.
- **Slots** (§3.3). Heavy runs, the core run and the render included, take one of a few slots shared by this repository's worktrees, so its sessions queue instead of slowing each other.

**What does not change: what passes.** Every check that could fail on a change still runs on it. The strict check reads every path except three it is shown not to read (§3.1), so it runs on every landing that changes anything else. The whole set runs once at a phase's end and before a push (`make gate FULL=1`), as the machine-wide practice asks, and CI runs the check and the tests on every push.

**What it adds.** The gate runs checks no landing ran before (§3.1):

- the board guard, which would have caught US's wipe of the Queue line and six merges that dropped a landed clause;
- every freeze, read from its own files: a landing that edits a frozen file or a freeze record fails;
- the receipt check, that the committed core receipt covers the Lean now in the tree;
- the dossier check, run by the gate rather than by hand;
- a list of the live lines that link what a landing changed, for a reader other than the author (§3.4). About forty restatements had gone stale past every check.

## 1. What the checks cost now

Measured on 4 November 2026 at `3bf962941` (main `1e9bc6b85` and a board line), at loads of 7 to 93, or taken from landing logs where named.

| What | Cost | Source |
|---|---|---|
| `research.py check` | 74.8 s (77.6 s on the starting tree, in the implementer's report); about 50 s of it in the drift comparisons, difflib over 79 (reviewed, current) pairs. A profile shows the same shares, inflated: 179 s, 131 s in drift | [timings](measurements/identity/), [profile](measurements/check-profile-2026-11-04.txt) |
| completion inside it | about 4.6 s parsing 386 Lean modules, 2.9 s of it stripping comments | the implementer's report |
| the strict check | 1:56 to 3:21 | landing logs (t2-land, ue31-land) |
| `make research-test` | 281.6 to 454.3 s for 307 or 308 tests, single-threaded | landing logs |
| render | about 2 to 4 min; 5.5 min (LA4); over 9 at load 60 | landing logs, memory |
| links | 6 to 9 s | landing logs |
| a core run with Lean changed low | 1,450 to 1,500 of its 1,544 steps, 3.6 to 4.7 min at six jobs; 80 to 115 s of any changing run is the environment audit's fixed tail | the Lean map |
| a new worktree | 2 to 5 minutes and 5.3 GB; switching an owned one to main took 2.2 s | memory; timed here |
| main held by a landing | median 24 minutes, up to 88, for the ten head clauses since 1 November | the board's commits |
| commits on main from the 3 November rewrite of AGENTS (`0423d4000`) to `1e9bc6b85`, 43 hours | 150, of which 41 board-only | `git rev-list --first-parent` |

A landing today runs render, the strict check, links, the whole test suite (which runs the dossier check again) and the dossier check twice more. It does so after a rehearsal that ran the same, and again whenever another landing moves main first. That is two to four runs of about ten minutes of checks per landing, where one run of what the change reaches would do.

**What the checks miss.** The same day, seven readers found about forty places where a page is stale or overstates its home, every one past every check ([the atlas plan](../../../2026-10-05-generative-foundation-review/root-foundation/development/aa-attractor-atlas/PLAN.md), Appendix C; verified in [Phase 0](../../../2026-10-05-generative-foundation-review/root-foundation/development/aa-attractor-atlas/phase0/ROUTING.md): 32 hold, 7 hold in part, 1 already fixed). The checks test form: links, freshness, schemas, receipts, the Lean. Whether a restatement still says what its home says is tested by a reader, and only where someone asks. Several area checks never run at a landing: the RO, ZH and Y verifiers, which have failed silently since 23 October, the periphery checkers (the fallible-inquiry receipt has been stale against the core since 31 October), the freeze hashes and the move receipts.

## 2. Part 1: the checks made cheaper

**The drift comparisons.** For each record whose Markdown source changed since its review, the check compares the reviewed version with the current text, line by line, with difflib, and keeps the rewrites that bear on what the record cites. That comparison depends on the two texts alone. Each one is now kept outside the repository, in `~/.cache/research-drift-comparisons/` (or `$RESEARCH_DRIFT_CACHE`):

- **One file per pair**, named by the two texts' sha256, under a tag of the algorithm and Python's version, so sessions running at once never write the same file.
- **Only the opcodes are kept.** The removed and replacing lines are rebuilt from the texts, exactly as before.
- **A bad entry is computed again.** An entry that cannot be read, or whose spans do not fit the lines, is computed and rewritten.
- **The cache only saves work.** A write that fails is ignored, and deleting the directory costs only time.

| `research.py check` at main | Real time |
|---|---|
| before | 74.8 to 77.6 s |
| new, cold cache | 72.7 s |
| new, warm cache | 33.4 s |

**The comment stripper.** Completion strips comments from every Lean module before reading its statements, one character at a time. It now jumps from mark to mark, as the Lean catalogue's scanner does, with the same rules: nested block comments, strings kept, and a quote after a backslash or an apostrophe neither opening nor closing one. Over the 30,373 tracked `.lean` files it took 3.4 s against 98.8 s; each check parses the 386 core modules, saving about 2.8 s.

**The results are the same.** On the starting tree, the old code, the new code with a cold cache and the new code with difflib forbidden (every answer from the cache) were compared ([identity/](measurements/identity/)):

- `changed_lines` is equal for 79 of 79 comparisons, and `scoped_drift` for 838 of 838 (record, source) pairs.
- The stripper's output is equal on every string up to length 7 over the characters that matter (960,800 strings), on 200,000 random strings and on every tracked `.lean` file; `parse_module` and `sources()` are equal too (26,373 declarations, in order).
- The check's whole JSON output is byte-identical between the old code, cold and warm.

**One record re-pointed.** `completion.py` is a source of the record `central-laws-over-every-exchange`, bound by exact bytes, so the new stripper drifts it. Its output is unchanged, so the landing re-points that reference with `repoint.py --reason`, a re-point that changes nothing the record says, logged in `rebinds.jsonl`.

**Left for later**, each a function of its inputs and kept by them the same way: re-hashing the 1,634 referenced files (about 1.2 GB) on every check; parsing 220 receipts (about 533 MB of JSON); the Lean catalogue's two whole-tree walks; the secrets scan per blob. The outputs map lists them with the keys each would need ([map](measurements/map-check-outputs.md)).

## 3. Part 2: the gate

### 3.1 The checks and what each reads

Every check is also reached by its own code: the research tools, the config and the script its command runs.

| Check | Command | Reads (a changed path here selects it) | Why the set is complete |
|---|---|---|---|
| `secrets` | `research.py secrets` | every path | it greps every tracked file |
| `strict` | `research.py check --strict-fresh` | every path, and any added or deleted path; not a modification under `tools/research/tests/` or `.github/`, nor one of the board that keeps its headings | it validates every record and every file a record references, renders every generated page in memory, and walks every `.lean` file and every directory index, untracked files included. No tool reads the tests or the workflows; the board is read only through a generated page's link to one of its headings (`OPEN-QUESTIONS.md`, from the config), and the Lean catalogue's documents leave `_process/` out but for its studies |
| `links` | `research.py links` | every `.md`, every `.gitignore`, `.gitattributes`, and any added or deleted path | a link breaks only through a change to Markdown, an added or deleted target, or a change to the ignore rules that decide whether a missing target counts |
| `test:<file>`, one per test file | `unittest discover -s tools/research/tests -p <file>` | the tests' own files, and the live files that test asserts on, with derived inputs where it reads them (the files the first screen times, the receipts records bind, what the migration drafts reference, what the dossiers quote) | from the test map ([map](measurements/map-test-suite.md)): a live assertion the strict check also makes is left to the strict check, which every content change reaches; a test file with no entry reads every path |
| `board` | `gate.py board` | the board | §3.5 |
| `frozen` | `gate.py frozen` | every live freeze record (a `*FROZEN*.sha256`, a `.json` named with *freeze*, a `*FROZEN-AT` pin), every path a record lists, and each pinned experiment's folder | derived from the records at each run, not from a hand list (§3.6) |
| `receipt` | `gate.py receipt` | the Lean directory | the core receipt names the bytes of every module it checked (§3.6) |
| `dossiers` | `check_dossiers.py` (no argument) | the review packet, the corpus, the Lean directories it searches and copies blocks from (`physics`, `warning`, `deeper`, `review-checks`), its own script, and every file a dossier quotes | the quotations are parsed with the checker's own pattern at each run, root-level files such as GLOSSARY.md included |

**Before the gate.** Three steps write what the landing commits, so they run first, each through `gate.py hold`, and their output is committed: the core run for changed Lean; the shared-laws generator after a change to the Lean, COVERAGE, the measure, the connectivity dump or a record's laws (RESULT-WORKFLOW, "Shared laws under each law"); the render whenever the strict check is selected. `gate.py plan` lists the ones the change reaches under `before_the_gate`. The gate verifies the core run through the receipt check and the render through the strict check, which fails on any page a render would change. The shared-laws data it cannot verify, since the check reports that data stale but never fails on it; the lander runs the generator where the plan lists it.

**The worktree is exactly its commit.** The directory indexes count untracked files and list the folders under `sources/`, and the Lean catalogue reads ignored `.lean` files and ignored Markdown in its documents. So the gate refuses a worktree with uncommitted or untracked files, stray ignored `.lean` or document Markdown, or a folder under `sources/` git tracks nothing in. It also refuses the shared checkout, which other sessions fast-forward and which holds their drafts.

**Unread paths.** The outputs map lists more paths that no check reads when only modified, such as some data files no generator opens. The table takes only the three above, where the reason is short and the cost of a mistake small. Others can be added by the same argument, each with its reason beside the rule.

### 3.2 A pass kept, and reused after main moves

A pass is stored under the repository's common git directory, so every worktree sees it. Its key covers:

- the check, and its command as run, arguments included (`--base`, `--all`);
- Python's version;
- the checkers' own code: the blobs of `tools/research`, its tests aside, and the command's script;
- where it matters, a tool's version (ripgrep for the Lean catalogue, Lean for the test that compiles stubs).

It is stored only when the command exits 0, for the tree and commit the check began on, and only if HEAD has not moved while it ran and the worktree is clean.

A kept pass holds for HEAD under one of two conditions:

- **The same tree.** HEAD has the tree the pass was kept on, and the passed commit is an ancestor of HEAD.
- **A later commit.** The passed commit is an ancestor of HEAD, and no path in the diff from it to HEAD is one the check reads.

Ancestry is required because the drift check reads history. A reviewed version found in the passed commit's history is still found in a descendant's. On the same tree the check's other inputs are the same bytes. Under the second condition they are unchanged by construction.

What this saves:

- **The rehearsal's run counts at the landing** when main has not moved, since the trees are the same.
- **When main moves**, the lander merges again, and only the checks the move reaches run again. A board-only move that keeps the board's headings runs the board check, links and secrets; any other change runs the strict check.
- **The coordinator's check after the fast-forward**, and the push's `--full` on that commit, reuse the landing's passes where the command is the same. The frozen check under `--full` is a different command (`--all`), so it runs. `make gate FULL=1 FRESH=1` runs everything again.

**Nothing cached lets a stale page or a changed hash pass.** The strict check is reused across a diff only of the paths it is shown not to read. The drift cache (§2) returns, for the same two texts, what difflib would. No source hash is refreshed anywhere.

### 3.3 Slots

`GATE_SLOTS` slots (two by default) are lock files under the common git directory, shared by this repository's worktrees; other repositories' runs take none, so the machine's load is still looked at before a heavy run. The kernel frees a slot's lock when its holder ends, so a dead process never blocks one. These take a slot:

- **the gate's heavy checks**, the strict check and the tests;
- **any heavy command run through `gate.py hold -- …`**, the core run and the render included.

Checking for a twin and taking a slot are one step, under a short lock. A run identical to one already held, the same command on the same tree, is refused rather than started twice. `gate.py status` shows who holds what. The core checker uses half the cores by default, so two slots keep the machine at most full from this repository.

### 3.4 Restatements to re-read

`gate.py restated` reports two kinds of change:

- **A home section with a changed line.** A table row carrying `r-<id>` anchors is the home of those records. Otherwise an anchor's block runs to the next anchor of any kind or heading; anchors stacked on bare lines, or over the heading they name, share one block, as do several anchors on one line.
- **A record whose stated fields changed**: title, statement, laws, hypotheses, what it does not show, counterexamples, standard boundaries, status or kind. A re-point changes none of these, so it lists nothing.

For each, it lists the other live Markdown lines, read at HEAD, that link it by its exact anchor or its record page, outside studies under `_process/research/` (they record past work) and outside the home itself. A line that is another record's home is kept, since it restates the one it links. The list covers the lines that link a change, a start and not every page that restates it in its own words. It goes to a reader other than the author, as AGENTS asks, and never fails the gate.

### 3.5 The board guard

The board check compares the board after the change with the board at the base:

- it keeps its five sections and has exactly one Queue line;
- it is not a fifth shorter: landed rows that move to history are a few kilobytes each;
- the Queue line loses no clause besides head clauses, waiting clauses whose item now has a head clause ("RAE behind GT and AA" becoming "RAE at the head of the queue (landing now …"), and the coordinator's closing order. A head clause is one worded "landing now", "landing run now", or "at (or holds) the head of the queue (" followed by its parenthesis, wherever the rule of its day put it. A clause that only mentions the head, such as "waits until L1 no longer holds the head of the queue", is not one. The order is the clause beginning "Then, in the coordinator's order" and what follows it. Clauses are cut at a full stop or a semicolon outside brackets and compared whole, their closing mark set aside, since a clause's ";" becomes "." as it moves along the line.

A board-only change is refused while the base's first clause is a head clause, since board-only commits go in gaps; nothing waives this. `GATE_BOARD_REWRITE='reason'` accepts a deliberate rewrite and prints the reason with the pass.

Replayed over main's own moves since 25 October (its reflog: each fast-forward from the board main had to the board it got, which is what the guard compares at a landing), 753 of which changed the board, the guard flags nine:

- US's wipe of 380 clauses (`90c8bfbaa` to `d1f855417`), the one loss; the Queue line points to `90c8bfbaa` for it;
- eight deliberate rewrites, each of which would now carry a reason: two moves of landed clauses to history (`15765701b`, 83 clauses; `88777db50`, the board halved), two landed clauses dropped as the next head claimed (U4's C line at `0249ba3fe`, SJ1's at `e98999fbf`), and four clauses amended in place (UE7's, given UE8's qualifier at UE9's landing; LA4's Stage A check line; the freeze line after its push; the pointer to the earlier landed clauses).

A first replay compared each commit on main's first-parent chain with its first parent. For a branch fast-forwarded in, that parent is the branch's side, not main's, so it flagged correct merges that took main's trimmed board; and it compared clauses with their closing mark, so it flagged clauses that had only moved. Both are corrected.

Every ordinary claim and landing passes.

### 3.6 Freezes and receipts

**Freezes.** The frozen check reads every live freeze record from its own files: `*FROZEN*.sha256` lines, a freeze JSON's `files`, `sources` or `source_sha256` (a list of {path, sha256}, or a map from path to hash; a path not in the tree is read from the record's folder), and `*FROZEN-AT` pins, each naming one or more commits. A record inside a run folder or under history is evidence of that run, not a freeze on the live tree, and is not read. The check judges what the landing does:

- deleting or editing a freeze record fails;
- changing a file a record lists fails, and so does changing a file a pin's experiment held at a pinned commit, unless `GATE_FROZEN_ACK` names that file with the reason;
- a record the landing touches must have every entry at the bytes it names;
- a pin the landing adds must name a commit in main's history, and every commit a pin names must be in main's history or kept under `refs/salvage/` (a pre-rebase original beside the rebased one); where a pin names its rebased commit ("on main, rebased, X", "rebased onto main as X"), X must be in main's history;
- a landing that changes the folder of a freeze record the check cannot read (its hashes name no path) fails until that record is read and acknowledged.

A frozen Markdown file whose difference from its frozen bytes lies only in link targets, as the repository's moves rewrite them, is listed apart as link-only (the frozen version is found in history by its sha256 and the two compared with every `](…)` target set aside) and never fails; any other difference is a content change. A freeze JSON that binds its sources to a parent commit (`parent_commit`, `accepted_parent_commit`) is read against that commit, and against the tree only for files absent there; a source that has moved on since its parent is noted, never failed, and so is one written after the parent to its frozen bytes. A frozen file never committed at the bytes its record names (the record states a state before the file's first commit) is noted as such: nothing after the freeze changed it. What already stands on main is listed for its owner and never fails, even under `--full`. A landing cannot cause it, and a gate cannot undo history. Under `--full` the list is given whole, with each pinned file changed since its pin. A pin may name a pre-rebase or salvage commit beside the one on main, so one commit in main's history is enough.

On main on 5 November, of 47 live freeze records, the check reads 25, alongside 20 pins, and finds no content changed after a freeze: seven frozen files differ in link targets only, seven have moved on since the parent commit their record binds them to, and three were never at their frozen bytes in any commit (agentdojo's `check_analysis.py` and `AGENTDOJO-EVIDENCE-REVIEW.md`, stochastic-prediction's `Exposure.lean`, each committed with its freeze record). Twenty-two records give hashes that name no path. A change to freeze 1's `told/` files reaches every record that lists them, so all eight freezes of formations-that-read are checked together.

**Receipts.** The receipt check reads the Lean package's receipts. The core receipt (`becoming-verification.json`) must have passed, and must bind the current bytes of every module it lists, so the core run ran on this Lean. A module under `Becoming/` that no receipt lists fails too. Another checker's receipt beside it, such as fallible-inquiry's, fails where the landing changes a source of its own that the core receipt does not list. Where only the core modules it imports moved on, it is listed as an area check to run again. That checker's receipt has been stale against the core since 31 October.

### 3.7 Use

```
make gate-plan                 # what the change reaches, and the steps before the gate
make gate                      # the gate on the merged tree (BASE=main by default)
make gate FULL=1               # every check: at a phase's end and before a push; FRESH=1 with it reuses nothing
make gate-push                 # the push screen from the remote's main (git ls-remote) to HEAD; GATE_PUSH_ACK names binaries looked at
python3 -B tools/research/gate.py run --train BRANCH ...   # names, under each check, the landings that reach it
python3 -B tools/research/gate.py hold -- make research-render
python3 -B tools/research/gate.py status
```

Run it in the background with a log. A red under load is rerun alone (`--only NAME`) before it is called a failure, as the machine-wide practice asks. A report says which checks ran, which were reused and from which tree, and that the full set waits for the phase's end.

## 4. Part 3: trains

When landings are ready together, they go as one train under the Queue line's order, which still decides who boards.

- Each landing's head clause stands on the Queue line.
- The lander merges the branches in that order into one branch. Each landing keeps its own commits and, at the end, its own landed clause.
- The lander runs the steps that write once, then the gate once on the merged tree.
- A red names the landings whose own change reaches the failing check (`--train`). Those leave the train and the rest go on.
- Owners resolve merge conflicts within a train; the coordinator settles disputes over order.

A train costs one render, one strict check and one core run, however many landings it carries. It is worth the most for Lean. A batch of liftings costs as much as its lowest-reaching member (§5), so the root's unification lands as trains of batches.

## 5. Lean runs for the root's unification

From the Lean map ([measurements/](measurements/map-lean-speed.md)): a core run costs about 4|U|+2 Lean steps, where U is the changed modules and everything above them. Changing any of the 25 lowest modules (Prelude has 372 dependents, Grammar 369) is a near-full run; a module with only the root above it adds about four steps. So:

1. **One landing per batch of liftings, never one per module.**
2. **Batches bottom-up** by the import graph (depth 41). A lift that keeps the model law's name and statement, the grammar law below proving it (board rule 9), needs no edit to the modules above. Those only recompile.
3. **The base batch first.** Every lift touching the 25 low modules goes in one batch.

The checker itself can be made faster without changing what it checks. In order of saving for risk:

- the environment audit in one pass: most of the 80 to 115 s tail every changing run pays;
- one driver per module for the audit and the signatures, about a quarter of the steps;
- skipping the root's empty drivers;
- a lock per step key, so two runs of one tree never run a step twice;
- a machine-wide cap on Lean processes, through the gate's slots;
- recording each step's time;
- one task builder shared with `scratch_build.py`.

Removing `import Std` from GenerativeCore would save about a quarter of the steps, but it changes a foundation module that 467 receipts bind, so it is a decision, not a speedup. These are GT2 (§8). They come before RU, after the atlas plan's objectives.

## 6. The text changed

- **AGENTS.md, Working together.** Before landing:
  - run what writes and commit it;
  - pass `make gate` on the merged tree, with the area checks it does not yet run;
  - `make gate FULL=1` runs the whole set at a phase's end and before a push.

  The gate keeps passes by tree and reruns only what a move of main reaches. Landings ready together go as one train, each keeping its own clauses. Heavy runs go through the gate or `gate.py hold`, which share slots among this repository's worktrees, after a look at the machine's load.
- **AGENTS.md, Records and text.** The gate lists the live lines that link what a landing changed, a start and not the whole set.
- **RESULT-WORKFLOW, landing.** The lander's order in one place: head clause, merge, steps that write, landed clause, gate, re-read, fast-forward. Use a worktree you own, switched to the branch, not a new one per rehearsal. Run the gate in the background and report what it reused. The `restated` list goes to a reader other than the author.
- **RESULT-WORKFLOW, Markdown drift.** The drift comparisons are kept outside the repository by the texts compared.
- **The board's rule 5.** Heavy runs take this repository's slots, and landings go in the queue's order; trains as in §4. This is edited at landing, on the board as it then stands.

Before-copies: [AGENTS](../../../../history/2026-11-04-instructions/AGENTS-before-gate.md), [RESULT-WORKFLOW](../../../../history/2026-11-04-instructions/RESULT-WORKFLOW-before-gate.md). GT lands under the rules it replaces, with AA's plan and Phase 0 in the same landing and the old checks run in full. The new rules apply from the landing after it.

## 7. What could go wrong

- **A rule misses an input,** so a check is skipped that would fail. The guards:
  - the strict check reads every path but three it is shown not to read;
  - a stale rule fails the gate, and a path in a new top-level area selects everything;
  - each rule's reason is stated beside it, for a reader other than its author;
  - the full set runs at each phase's end and before each push, and CI runs the check and the tests on every push.

  A path inside a known area that a narrow rule should name but does not is caught only by these. The soundness reviewer's GLOSSARY.md case was one.
- **A cache hides a change.** Passes are keyed by tree, ancestry, the command as run, the checkers' code and their versions; the drift cache by the two texts' bytes, with the same algorithm and Python. Neither can return a result for different inputs.
- **A slot holder hangs.** A slot holds one run and never waits on another, so slots cannot deadlock. The kernel frees a dead holder's lock, and a hung run blocks one slot until its own timeout.
- **A train hides which landing broke.** The gate names, under each failing check, the landings whose change reaches it.
- **The board guard refuses a legitimate rewrite.** `GATE_BOARD_REWRITE` with a reason, printed with the pass.
- **A freeze changes legitimately.** `GATE_FROZEN_ACK` names each file with its reason, so the change is deliberate and on the record of the landing.

## 8. What comes next

- **GT2, the Lean checker** (§5): the environment audit in one pass, the merged drivers, the per-key lock, Lean processes in the slots. Each keeps every check identical and lands with a fresh core run and an independent reader of the checker. It comes before RU.
- **GT3, the tests on fixtures.** Thirteen test files assert on the live records today, so a landing that touches a record runs most of the suite. The test map gives the way out:
  - move the live assertions the strict check does not yet make into it: the regions, the front-page rules, the stock against the standard boundaries, the shape of the shared laws;
  - drop those it already makes;
  - move the thirty tests whose only live use is a fixture onto a temporary root.

  Each test then runs only when its code changes ([map](measurements/map-test-suite.md)).
- **E30**, found in Phase 0 of the atlas: an explicit `<a id>` or a `###` anchor a record cites locates no section, so 39 citations are not protected from drift. Fixing it will show drift on main that then needs reading, so it is its own item.
- **The area checks no landing runs**: the RO, ZH and Y verifiers (mended under the atlas's Phase 0, E3), the periphery checkers (the fallible-inquiry receipt first), the move receipts. Each joins the gate with its inputs once it passes.
- **The freeze records with no paths**, and the seven standing mismatches: for their owners, through the coordinator.

## 9. The coordinator's requirements

The coordinator sent ten requirements on 4 November before any slot was asked ([text](COORDINATOR-REQUIREMENTS.md)). Each is met as follows.

1. **A clean tree, keyed by its hash, plus the checkers' code and Python; never the shared checkout.** §3.1, §3.2.
2. **The landing order:** the head clause first, the merge, the render committed, the checks on the merged tree, the Queue line re-read, a fast-forward only. No cache lets a stale page or a changed hash pass. §3.1, §3.2, RESULT-WORKFLOW.
3. **A board guard.** §3.5.
4. **Board-only commits in gaps only,** needing only links and the board's parse. §3.5, §3.2.
5. **Freeze integrity derived from the hash files, and the review packet's check.** §3.6, §3.1.
6. **A missing path fails, and an unplaced one selects everything.** §0, §3.1.
7. **The push screen outside the research checks.** The coordinator's script, copied unchanged into `tools/research/push_screen.sh`, run by `gate.py push` (`make gate-push`) from the remote's main read by `git ls-remote`; a binary is a finding to look at, passed when `GATE_PUSH_ACK` names it; every other finding fails. Pushing stays Ren's.
8. **Load:** slots shared by this repository's worktrees, the core run included, a dead holder's lock freed, no second copy of a run, and a red rerun alone. §3.3, §3.7.
9. **Trains:** each landing keeps its own commits and clause, and the Queue line decides who boards. §4.
10. **Before-copies** in `_process/history/…-instructions/`, linked from AGENTS.md's header. §6.

## 10. The reviews

- **The tests' author** wrote 77 tests against the tool's stated contract and found twelve bugs. The worst four: a change to a check's own code did not select it; train attribution was always empty; a pass could be kept for a tree the check never read; and the shared-checkout guard missed the shared checkout when run from another directory. All twelve are fixed, and their tests pass. Eight more tests cover what the readers found. 85 tests pass in about 50 s.
- **The soundness reader** found five high gaps, all fixed:
  - round pins went unread;
  - freeze records with other names went unread;
  - a root-level file a dossier quotes selected no check;
  - the full set reused a landing's frozen pass;
  - nothing checked that the core run ran.

  It also asked that a pin's salvage commits be allowed beside the one on main, and that only true head clauses be exempt.
- **The text reader** found the rules claiming more than the tool does: the strict check "never" reused, a "machine-wide" slot, the restatement list as "every" page that restates. It also found the dropped "area's own checks", a missing landing order and figures off against their sources. All are corrected above.
