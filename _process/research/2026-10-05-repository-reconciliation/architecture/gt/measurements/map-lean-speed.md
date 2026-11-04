<!-- AI-written: one of four read-only readers, 4 November 2026, for GT's design (GATE.md). Read against main 1e9bc6b85; not checked line by line. -->
# The Lean checker and the cost of liftings

## Lean runs for the root unification: structure, cascade, speedups, batches

I only read code. I ran no make, research.py, unittest, check_becoming.py, scratch_build.py, lake or lean, and wrote no files. My evidence:
- reading check_becoming.py, scratch_build.py, the README, lean.yml, the Lean 4.29.1 sources under ~/.elan and the two memory files;
- inline Python that parsed import lines (a regex, not the checker's own parser);
- reading the committed receipts' lean_steps;
- stat calls on cache entries to time past runs.

### The run (check_becoming.py:4206-4442)
- **1,544 Lean steps:** 1,543 keyed plus an unkeyed `--version`. lean.yml:30 still says "About 1,100".
  - Per module: compile (386), `#print axioms` audit (386), `#check @` signatures (383), and a prelude-only recompile with `import Std` stripped (386). Built at 4336-4376.
  - Whole package: EnvironmentAudit (3767-3783, 4351-4354) and Controls (4362).
- **Keys** (step_key, 3850-3863) hash the toolchain string, the binary's sha256, the label, the step's bytes and its imports' keys, chained by module_keys (3866-3871). A key therefore covers the whole import closure.
  - Not in the key: the lean argument vector, the toolchain's own Init/Std .olean files, and the checker's bytes.
- **Cache:** ~/.cache/becoming-lean, shared by all worktrees and tools. Outputs are digest-checked on reuse, and only passed steps are stored (3874-3909, 4303-4307). It holds 34 GB in 139,511 entries locally, with no eviction.
- **Parallelism exists already:** run_graph (3915-3956) with JOBS = cpu_count//2, 6 here (3912), runs ready tasks by longest dependent chain first.
  - Each step is its own lean process with LEAN_TIMEOUT 600 s (3845).
  - No `-j` is passed, so every process uses a hardware-sized thread pool (Lean/Shell.lean:226-229) with Elab.async on (Lean/Elab/Frontend.lean:152-153).
  - There is no machine-wide cap or lock.

### Cascade
A change reruns compile, audit, signatures and prelude for the module and every dependent, plus EnvironmentAudit and Controls.
- Prelude has 372 dependents, Grammar 369, GrammarMap 364, GrammarLaws 362, Frame 351, World 331.
- A Grammar edit reruns about 1,482 of 1,543 steps.
- 17 modules have more than 300 dependents and 45 more than 100. 112 modules have only the root above them (about 10 steps each). The longest chain is 41.

### Measured (cache store times against run stamps)
- Near-full cascades on 21-28 Oct (1,020-1,170 steps ran) took 3.6-4.7 min.
- Small landings on 1-3 Nov (72-135 steps) took 2.0-3.6 min, of which **EnvironmentAudit is a fixed 80-115 s tail** (38 s vs 118 s, 52 vs 144, 101 vs 215).
- scratch_build stores only compile and audit results. Landing 20261101T094230 therefore reran 375 signature steps and 375 prelude compiles.

### Speedups, in priority order
1. **Single-pass environment audit.** The driver rebuilds `env.constants.map₁.toList` over the whole environment once for each of 386 modules (3773-3776). Iterate once, with the same collectAxioms (CollectAxioms.lean:46-49). This likely removes most of the tail; confirm with one timed run. Risk is low.
2. **Record step durations,** wall and CPU, in the receipt and cache. Nothing is timed today.
3. **Put the argument vectors into step_key** before adding -j, --json or batching.
4. **Machine-wide slots plus a per-process -j:** flock slot files (pattern at tr7_run.py:268-276), acquired before the timeout clock starts.
5. **Per-key in-progress lock,** so concurrent identical runs compute each step once.
6. **One driver per module for audit and signatures,** parsed with `--json`. Saves 383 processes per full cascade.
7. **Further batching:**
   - drivers per dirty chunk, J processes, with per-module result slices;
   - optionally, fold the audit into the environment audit, which uses the same function (Print.lean:237-251) with a stricter assertion. That one is a method decision.
8. **Prelude chain:**
   - The 32 modules that do not depend on GenerativeCore have identical inputs; drop the 'prelude only' tag from their keys (4369).
   - Larger: GenerativeCore.lean:1 is the only Std import. Removing it merges the two chains (about 386 compiles saved per cascade). It changes a foundation module bound by 467 receipts and needs a new receipt, so it is a decision.
9. **Shared task builder** so scratch_build runs every per-module step kind.
10. **Rehearse on the exact merged train tree** with BECOMING_OUT, so the landing reuses everything.
11. **A 'receipt still current' tier skip** that uses the checker's own preamble functions.
12. Smaller items:
   - prune the directory walks (73,773 files walked; 161 MB of JSON read per run);
   - restore oleans by hard link (601 MB per run);
   - skip the root's empty drivers;
   - spot-check reused steps fresh, with the full fresh run left to CI (weekly) and to before a push;
   - a cache retention policy that keeps receipt-named keys.

### What the Lean tier reads (for a sound path rule)
- Every `*.lean` under the Lean root outside archive directories. A file there can clash with a module's stem (3794, 3829-3830).
- Every `*.json` under the Lean root except the checker's own receipt and run folders (passed_receipts 3993-4013; these bind the foundation).
- check_becoming.py and universal-ethics/generative-capacity/check.py (4216).
- becoming/lean-toolchain and the Lean binary (4062-4080, 4282).
- Environment variables: LEAN, BECOMING_*, LEAN_TIMEOUT.

Changes only to other files (for example *.md) cannot change its result. A narrower rule, such as watching only Becoming/*.lean, would be unsound. Inside the tier, the step cache already reruns only what changed.

### Batches
- One train, one core run per batch.
- Bottom-up, with the base batch first: all lifts that touch the roughly 25 modules with more than 200 dependents.
- New grammar laws go in a new module just above GrammarLaws rather than edits to Grammar, GrammarLaws or Prelude.
- Middle batches of 25-40 modules grouped by subtree, giving 8-12 cascades instead of about 303.
- Root-only modules ride along with any batch; never land one alone.
- Inside a batch: scratch-build each target, build dependents once with the root as target, rehearse on the merged tree, then land.
