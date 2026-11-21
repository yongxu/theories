# ParityReadings

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ParityReadings.lean`
- *result records that name this place's file as a source* (computed; not a link): `claims-shown-in-context`, `gluing-under-parity`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-13, as "ParityReadings.lean: world_free_iff, freeFrame_iff, quantum_readings" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-13.md.txt)); pass b: reader whole-b-48, as "ParityReadings.lean: Contextual.glues_iff_freeAt, ParitySystem.world_free_iff, ParitySystem.world_met_le, ParitySystem.freeFrame_iff, Square.QuantumAt.not_glues, Square.quantum_readings" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-48.md.txt)); the third pass, where the two differed: reader whole-c-settle-18, as "ParityReadings.lean: settled fields share, both_outcomes, comparison, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-18.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For decidable claims listed distinctly and a list covering the contexts, a respecting context-free world exists at a given run step exactly when no selection of contexts contradicts (l. 88). The built quantum square admits no fitting context-free frame for any process and no context-free step along any run (l. 183).
  - *pass b:* These are general laws about contextual systems read along a run of any process. What the contexts show glues at a step exactly where the world of readings is context-free there. For a parity system, a context-free world or frame exists exactly where no selection of contexts contradicts, with a Bell-type bound. For the Mermin–Peres square, a built contextual system `quantum` is quantum at every configuration and so never glues and no context-free frame fits it.
- **moves**
  - *pass a:* B: `Square.quantum_readings` (l. 183) gives failure of `FreeAt` at every time on every run of any process P, for the built square. Its supplied configuration s₀ does not restrict the starts of the quantified runs.
  - *pass b:* S, but nothing about choices: `Square.quantum_readings` (l. 183) holds for every process P, every run and every step (the quantum world is context-free at no step), and `freeFrame_iff` (l. 120) is stated for every process. N: no law about what some choice or every choice of step keeps.
- **a reading**
  - *pass a:* S: `Contextual.glues_iff_freeAt` (l. 66) equates gluing of the contextual observations at a run state with one assignment agreeing with every active claim there.
  - *pass b:* S: `Contextual.glues_iff_freeAt` (l. 66): what the contexts show at r.state t glues exactly where the active relata of the world of readings are read off one context-free assignment. `ParitySystem.world_free_iff` (l. 88): with claims listed without repetition and contexts listed, some world of readings respecting the possibilities at a step is context-free exactly where no selection of contexts contradicts.
- **a share**
  - *settled by the third pass:* N: `ParitySystem.world_met_le` (l.104; premises `S.Contradicts ks`, `X.within = S.within`, `X.FreeAt P r t`) concludes `total ks (fun k => cond (S.met k (X.shows (r.state t) k)) 1 0) + 1 ≤ ks.length`: a bound on how many of the selected contexts are met at one step. A count is there; no rule or favouring is set again from it, and nothing steps on it. Pass b's own answer says so. [which pass was right: a; opened: world_met_le l.104, met_congr l.79, world_free_iff l.88]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S, a count only: `ParitySystem.world_met_le` (l. 104): where a selection ks of contexts contradicts, a world context-free at a step meets at most length ks − 1 of them. N: no rule set again from a share.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `Square.QuantumAt.not_freeAt` (l. 160) says not context-free at any quantum step, which is not an irreversibility.
- **both outcomes**
  - *settled by the third pass:* N: `ParitySystem.world_free_iff` (l.88) states that some `Contextual` system with `X.within = S.within`, respecting `S.support` at `r.state t` and `FreeAt P r t`, exists `↔ ¬ ∃ ks, S.Contradicts ks` (premises: claims `Distinct`, contexts listed); `freeFrame_iff` (l.120) the same for a frame of context-free claims; `glues_iff_freeAt` (l.66) is gluing `↔` `FreeAt`. These are exact conditions for a context-free description at a step or configuration, not a dichotomy of going on and ending or of keeping and losing. Pass b's own answer says N for the field. [which pass was right: a; opened: glues_iff_freeAt l.66, world_free_iff l.88, freeFrame_iff l.120]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S, about gluing, not going on and ending: `world_free_iff` (l. 88) and `freeFrame_iff` (l. 120) are exact-when laws (context-free exactly where no selection contradicts). N for going on and ending.
- **a comparison between two**
  - *settled by the third pass:* N: `ParitySystem.met_congr` (l.79): for `u u' : C → Bool` with `∀ c, S.within k c → u c = u' c`, `S.met k u = S.met k u'`: whether an assignment meets a context depends only on the claims within it. It is a congruence for two assignments of one context, with no process, start or step in the statement; nothing is carried between two processes, two starts or two ways. No simulation, kept order or covering was found in the module's thirteen declarations, all opened. [which pass was right: b; opened: met_congr l.79, glues_iff_freeAt l.66, world_free_iff l.88, world_met_le l.104, freeFrame_iff l.120, QuantumAt.not_glues l.151, not_freeAt l.160, no_free_frame l.166, quantum_at l.177, quantum_readings l.183]
  - *pass a:* S: `ParitySystem.met_congr` (l. 79) gives equal satisfaction readings for two assignments agreeing on every claim in the context.
  - *pass b:* N: no carrying between two processes, starts or ways (frames and worlds are read of one process).
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *settled by the third pass:* N: `Square.quantum_readings` (l.183): for every `P : Process σ A` and `s₀`, no frame of context-free claims of `P` fits `quantum`, and `∀ (r : Run P) t, ¬ quantum.FreeAt P r t`. It holds at every step because `quantum_at` (l.177) holds at every configuration `s`; no region is named and no closure under the step is stated or used. A property true of every configuration, not an invariant region, kernel, certificate or fixed point. [which pass was right: b; opened: QuantumAt l.146, QuantumAt.not_freeAt l.160, quantum l.174, quantum_at l.177, quantum_readings l.183]
  - *pass a:* B: `Square.quantum_readings` (l. 183) proves the square reading fails `FreeAt` throughout every run. This is a uniform property of the reading.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: Read the opening account, every declaration statement and its docstring. Statements — states, reading, comparison. Built cases — moves, closed_region. Not found — share, level, giving, cost, multiplying, no_return, both_outcomes, rank, forms_change. No answer rests on commentary alone or was left unreached.
  - *pass b:* All statements read (whole module, l. 1–190). Answered from statements: reading, share, moves, both_outcomes. Every other question was N after all statements were read.
