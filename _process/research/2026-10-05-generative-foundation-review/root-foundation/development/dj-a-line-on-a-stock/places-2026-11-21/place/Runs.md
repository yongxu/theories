# Runs

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Runs.lean`
- *result records that name this place's file as a source* (computed; not a link): `worlds-are-runs`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-17, as "Runs.lean: World.balanced_iff_law, World.balancedRun_world, ExchangeLaw.process_runs, carriedRun_level" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-17.md.txt)); pass b: reader whole-b-67, as "Runs.lean: World.run, World.run_world, World.balanced_iff_run, World.balanced_iff_law, World.balanced_iff_exists_run, World.restRun, ExchangeLaw.courseRun, ExchangeLaw.process_runs, carriedRun_level" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-67.md.txt)); the third pass, where the two differed: reader whole-c-settle-25, as "Runs.lean: settled fields reading, level" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-25.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: Every world recovers from its shown run, and a balanced world has precisely the webs and moves of an exchange run (`World.run_world`, l. 121, `World.balanced_iff_exists_run`, l. 174). For any exchange law the process of its history has the specified states at every date from the specified start (`ExchangeLaw.process_runs`, l. 244).
  - *pass b:* Each reading of the unfolding is a run, exactly. Every World is a run of the law it shows, and a run with webs as configurations and exchanges as moves is a World. A world balances exactly where its run is a run of the law of exchange on webs (exchangeAt), and with the rest counted every world is such a run; a feasible course of an ExchangeLaw is such a run; its generation has exactly one run from the start; the carried amount is the standing of such a run. These are general identifications, almost all by rfl or Iff.rfl, with no dynamics beyond them.
- **moves**
  - *pass a:* S: `exchangeAt` (l. 151) admits precisely exchanges satisfying the level step; `World.balanced_iff_run` (l. 159) equates balance with this constraint on every actual move.
  - *pass b:* S: `exchangeAt` (l. 151): a Process (WebAt R) (Exchange R) whose moves are exchanges. `World.law` (l. 99): Shown w.webAt w.move. `World.balanced_iff_law` (l. 164): a world balances exactly where the law it shows lies within exchangeAt. `ExchangeLaw.process_runs` (l. 244): a determined process with exactly one run from the start. N: no law about what some or every choice keeps.
- **a reading**
  - *settled by the third pass:* N: every statement opened. `World.web_along` (l.143): `(WebAt.dependence w.Relatum).along w.run = w.web`, by `rfl`: the web is the run projected through its dependence fields. `ExchangeLaw.courseWorld_process` (l.252): the course world's level at `t`, `.inr c` equals `(r.state t).2 t c` for a run from the start. Both are identities of projection; neither has an observation, a class read alike, or anything decided by what is registered. [which pass was right: b; opened: `WebAt.dependence` (l.87), `World.web_along` (l.143), `ExchangeLaw.process` (l.239), `ExchangeLaw.process_runs` (l.244), `ExchangeLaw.courseWorld_process` (l.252), and the rest of the module's statements.]
  - *pass a:* S: `World.web_along` (l. 143) recovers the web by reading the dependence data along its run. `ExchangeLaw.courseWorld_process` (l. 252) reads generated standing from the diagonal history entry of any process run from the specified start.
  - *pass b:* N: no observation or rule made from what is registered. `World.web_along` (l. 143) states that a world's web is its run read through its dependences (Dependence.along), as an identity.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a level that runs down**
  - *settled by the third pass:* N for a level that runs down with a return depending on what is left: opened `exchangeAt` (l.151): a `Process (WebAt R) (Exchange R)` whose step is `(exchange R).step x.level m y.level` (standing after with what is taken equals standing before with what is given); `ExchangeLaw.courseRun_state` (l.231), `World.balancedRun_level` (l.183) and `carriedRun_level` (l.273) identify levels of runs by `rfl`. Standings are data under a balance; no statement says one falls or what comes back. [which pass was right: b; opened: `exchangeAt` (l.151), `balanced_iff_run` (l.159), `balancedRun_level` (l.183), `restRun_web` (l.193), `ExchangeLaw.courseWorld_level` (l.219), `ExchangeLaw.courseRun_state` (l.231), `carriedRun_level` (l.273).]
  - *pass a:* S: `exchangeAt` (l. 151) constrains moves by the exchange step on standings, and `ExchangeLaw.courseRun_state` (l. 231) identifies the resulting levels for any nonanticipating feasible law. The law of giving is supplied.
  - *pass b:* N: standings appear as data (`World.balancedRun_level`, l. 183; `carriedRun_level`, l. 273: the carried amount is the standing of a run), but no running down is stated.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a comparison between two**
  - *pass a:* S: `World.balanced_iff_law` (l. 164) characterizes balance by step inclusion from the shown law to exchangeAt; `World.balancedRun_world` (l. 203) recovers the balanced world and the exchange run’s states and acts.
  - *pass b:* S: exact correspondences between two readings. `World.run_world` (l. 121): the world of a world's run is the world. `Run.world_webAt`/`Run.world_move`/`Run.world_run` (l. 129–137). `World.balancedRun_world` (l. 203): balanced worlds and runs of exchangeAt are one, both ways. `World.balanced_iff_law` (l. 164): inclusion of one process in another.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and docstrings. S for states, moves, reading, level, comparison. N for share, giving, cost, multiplying, no_return, both_outcomes, rank, closed_region, forms_change.
  - *pass b:* Answered from statements: moves (processes, no choice law) and comparison. N after reading every statement: the rest. Nothing unreached. Read: the whole module, lines 1–279.
