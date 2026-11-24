# Ren: Wave 0–4 Dual-Track Roadmap & Low-CPU Execution Directive

24 November 2026, 22:10 to 22:49 WIB. Ren's words in an Antigravity session in `/Users/ren/theories`, kept verbatim with his punctuation preserved. Times follow prompt metadata stamps in WIB (UTC+7).

## Ren's words

*Context (AI-authored):* After earlier pilot and Landing 2 (`ObservationalFidelity`, `SurvivalDistinguishability`, and Track B3–B4 local CPU probes), this session reviewed four next items—periphery deduplication (`FiniteProbKrylov`), lightweight real-learner B1/B2/B3 tests (`neural-alignment-stress-lab` / `guarded-alignment-runtime`), `Becoming.RelSpan` core compression (`A3`), and the Track B3–B4 structural next steps—and asked Ren how to prioritize and approach them with Astra and Fable 5.2.

22:10:40 WIB, 24 November:

> 用astra和fable 5.2分析一下，这几个都要做，至少优先顺序问题和approach问题

*Context (AI-authored):* After querying three `cx -m astra` analyses and `claude-fable-5-2`, this session proposed a staged Waves 0–4 roadmap covering all four items: Wave 0 (citation verification + freeze), Wave 1 (`FiniteProbKrylov` deduplication + B1–B2 `FiberLumpable` join), Wave 2 (lightweight real-learner B1/B2/B3 experiments), Wave 3 (Track `A3` `Becoming.RelSpan` core inversion & verified compression), and Wave 4 (algebraic + small-`decide` `InterfaceBits.lean` + paper Schur/BBP & LDL check + deterministic `MovingFeatureCone.lean`), and noted the CPU cost of brute-force finite graph searches (`n = 3/4`) and large `n = 2048` dense sweeps.

22:49:03 WIB, 24 November:

> 目前这个机器还是挺忙的，不要使用大量 CPU 去搜索。不行可以先放一放，之后我们看看有没有其他办法解决。除此之外，我基本上全盘同意。然后你多用 Astra，在有一些情况下用 Fable（token少），然后以此推进至完成。

## How this session read it (AI-written, held loosely)

- **No heavy CPU searches on this machine:** Skip brute-force `C_7^{⊠3}`/`C_7^{⊠4}` exhaustive clique/coloring searches and large dense `n = 2048` Jacobi sweeps; keep Lean verification serial (`BECOMING_JOBS=1 BECOMING_LEAN_SLOTS=1`) and keep empirical checks lightweight (`< 20s` CPU).
- **Proceed cleanly across Waves 0–4:** Run `FiniteProbKrylov` (`Wave 1`) → real-learner B1/B2/B3 (`Wave 2`) → `Becoming.RelSpan` (`Wave 3`) → algebraic `InterfaceBits.lean` + analytic/LDL/deterministic B3 (`Wave 4`), using Astra primarily and Fable sparingly.
- **Rules 1–7 respected:** Lean premises stay explicit, empirical metrics never replace theorem verification, `AGENTS.md` is unchanged, and nothing leaves this MacBook.
