All four findings are fixed as stated.

1. **Finding 5 — fixed.** [DESIGN.md:116](/Users/ren/theories/.claude/worktrees/rf-landing/experiments/formations-that-read/DESIGN.md:116) and REST now explicitly describe sensitivity, not an upper bound on leakage. The revised powers match `tr4.json`: **0.930–0.987** for the implicit matching leak and **0.485–0.698** for the permuted opaque token.

2. **Finding 12 — fixed.** [tr2.py:338](/Users/ren/theories/.claude/worktrees/rf-landing/experiments/formations-that-read/tr2.py:338) includes negative coupling and uses the Fréchet endpoint for maximum discordance. JSON and prose agree: at a 30% base, **4,800** pairs versus **3,200** under independence; at a 10% base, both need **1,600** on the tested grid.

3. **Finding 13 — fixed.** [DESIGN.md:196](/Users/ren/theories/.claude/worktrees/rf-landing/experiments/formations-that-read/DESIGN.md:196), REST and `full_protocol` consistently apply the guard to an otherwise supported whole bridge. A guard hit alongside an unresolved condition is reported without changing the verdict. JSON supports the reported mixed-case maxima, **0.0003/0.0006**, and G1’s guard detection.

4. **Finding 14 — fixed.** [tr8.py:1053](/Users/ren/theories/.claude/worktrees/rf-landing/experiments/formations-that-read/tr8.py:1053) computes the union over tied modal options, subtracting pairwise intersections. At 15 of 30, triple intersections are impossible. The shared TR8/TR9 implementation matches the stated “any modal option” rule.

**I found no new demonstrable problem in the inspected diff.** I checked the changed verdict rules, simulation logic, reported JSON values, and the revised plan-ranking citations against current `RevisionPlans`, `HeldForReading` and `ListingValuation`. I did not rerun scripts, build Lean, or repeat the full earlier audit. I made no file changes.

── cx · ok · session 01a19129-7766-7b41-b8c7-84a9d8cad544 · gpt-6-astra/high · read-only · 185s · 1060.4k tokens · 22 cmds
continue: cx -r 01a19129-7766-7b41-b8c7-84a9d8cad544 "…"
log: /Users/ren/.cache/cx/runs/20261031-174605-77785
