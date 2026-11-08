# WB review, step 3: read the revision

The revision of what readers are told about evaluation is on branch `wb-homes`, worktree `/Users/ren/tmp/wb/homes`. Read the whole diff against main: `git -C /Users/ren/tmp/wb/homes diff main -- theories GLOSSARY.md GLOSSARY.zh.md AGENTS.md _process/navigation tools/research`.

You are one of two readers, Fable and GPT astra. Each reads the whole diff independently, for a separate perspective. Read-only: no edits, commits, runs or subagents. The machine is loaded.

**The standard.** Read these first:
- `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/wb-within-becoming/UNDERSTANDING.md` §3, §5 and §10;
- the inventories in `review/readers/`.

Two corrections from astra's inventory hold over UNDERSTANDING's own wording:
- "every reader counting the bed ranks thirty above" does not follow without a comparison model. The texts now say "whoever holds C ranks it higher".
- A draw within renewal can still close what has not yet formed (07 §2's `Preemption`), so "what the laws mark is a draw beyond renewal" was too general.

**For each changed sentence, ask:**
1. **True.** Does it say more than its home or its Lean states (scope, quantifier, necessity, guarantee)? Does a restatement match its home's words?
2. **The direction.** Does any sentence still put a should, a ranking, or a warrant from outside in the account's own voice?
   - The account describes. It ranks only under readings it names.
   - Its ethics is its makers' offer, a way of seeing, not a verdict.
   - 生生 is the continuation of life.
   - Seeing conditions acting and guarantees nothing.
3. **Losses kept.** Did the revision soften or drop a loss, a failure, a counterexample, or a "does not show"?
4. **Both languages.** Does each Chinese edition say what its English says?
5. **What still runs.** The generators' quoted sentences (`tools/research/navigation.py` OPEN_LEAD and the start list; `theories/becoming/results/data/spine.json` quotes and captions) must still be found word for word in their homes. Are the tests' expectations still met (`tools/research/tests/test_featured_results.py`, `test_spine.py`, `test_navigation_pages.py`)?
6. **Clear.** Any sentence a reader would stumble on, or that reads as AI hedging.
7. **Missed.** Lines the revision should have changed and did not, among them restatements of T8, "two premises", "warrant open" and "a ranking needs C or a premise in its place".

The opening (`theories/becoming/OPENING.md`) is Ren's first person, revised in place on argument. Its heading names each revised passage. Check that the names match what changed.

**Report:** a table, one row per finding: file; line; quoted (25 words at most); severity (high, medium, low); what is wrong; the exact replacement. High first. Then at most 300 words on patterns. Say what you read in full.

## Round 1 (9 November 2026, branch tip `223f917bc`)

The diff, sentence by sentence (`kit/sentence_diff.py main 223f917bc`): [diff-round1.txt](diff-round1.txt), about 230 KB. Read all of it. Each block names the file and line in the branch; `-` is main's sentence, `+` the branch's, `…` an unchanged neighbour. For any block whose context you need, open the file in `/Users/ren/tmp/wb/homes` at that line.

Secondary: [diff-round1-records.txt](diff-round1-records.txt), the records' and the crosswalk's changes. Most record blocks are re-pointed source hashes (skip those); read the changed `claim`, `summary`, `scope` or `reading` sentences and the 9 November history notes, and the crosswalk's re-said `says` and `reading` fields.

Not in the diff, by design: the before-copies under `theories/becoming/history/` and `_process/history/`; generated pages (the crosswalk's pages, RESULTS, OPEN-QUESTIONS, README, the indexes), which the render writes from what is in the diff.

Write your report to `review/readers/round1-<your name>.md` only if you can write files; otherwise return it as your answer.

## Round 2 (9 November 2026, branch tip `00b2fbec2`)

The same reader reads what changed since round 1: [diff-round2.txt](diff-round2.txt), from round 1's tip `223f917bc` to `00b2fbec2`, without what the merge of main brought in (RW's Chinese round; a block whose new sentences are all main's is left out). Secondary: [diff-round2-records.txt](diff-round2-records.txt) (skip hash-only blocks). Generated pages in the diff (LINEAGE, THEORY-GRAPH, the indexes) are the render's; read their sources instead.

Check first that each of your round-1 findings is fixed as you meant, or say why the fix differs; the fixes are `kit/edit_round1.py`, `kit/crosswalk_round1.py` and `kit/crosswalk_round1b.py`, then the merge's resolution. Then read the rest of the diff by the same seven questions. The same table; high first; say what you read in full.
