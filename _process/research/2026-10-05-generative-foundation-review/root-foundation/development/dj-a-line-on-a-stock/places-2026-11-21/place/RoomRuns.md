# RoomRuns

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/RoomRuns.lean`
- *result records that name this place's file as a source* (computed; not a link): `rooms-tested-by-a-window`
- *dynamics in the atlas that name one of those records* (computed; not a link): `overshooting-thermostat-alternates`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-17, as "RoomRuns.lean: next_open, Unheated.window_cold, Overshooting.alternates, heated_possible_held" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-17.md.txt)); pass b: reader whole-b-65, as "RoomRuns.lean: next_open, window_line, Unheated.window_cold, Matched.window_held, Overshooting.alternation_shifted, Overshooting.holds_one_way, process, line_iff_held, heated_possible_held" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-65.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For every room the open-window update equals the regime step with unit draw and the room’s heater (`next_open`, l. 40). On that branch zero heat supply leaves the room cold from its margin onward, matched supply holds the positive set level, and the built overshooting room alternates three and four (`window_cold`, l. 70, `window_held`, l. 89, `alternates`, l. 94).
  - *pass b:* It joins the built rooms to RegimeMargin: with the window open, the rule is RegimeMargin's step (a draw of one, then the heater's giving), so the window's branch is the regime's run. On that run, the unheated room is at level 0 from step m on, the matched room holds its set level, and the overshooting room alternates 3 and 4 (Alternation's run shifted by two), with generation at its moments and no widening for any of them. It also reads a room as a process whose act opens the window: a coarse line is the possible with warmth held, all built.
- **moves**
  - *pass a:* S: `heated_possible_held` (l. 270) carries any possible admission from a warm start to one reachable with warmth held, for positive set level and heater.
  - *pass b:* B: `process` (l. 213) is a `Process Occurrence Bool`; the act says whether the window opens. `heated_held` (l. 262): in a heated room with m ≥ 1, every trace from a warm occurrence is made of moves holding warmth. `heated_possible_held` (l. 270): there everything possible is possible with warmth held, so every choice keeps warmth. `Unheated.cold_not_held` (l. 246): at margin three the cold occurrence is possible, but not with warmth held.
- **a reading**
  - *pass a:* S: `line_iff_held` (l. 231) identifies reachability along the coarse warmth class exactly with reachability by warmth-preserving moves.
  - *pass b:* B: `line_iff_held` (l. 231): what warmth's line reaches from x is what moves holding the class `alike` reach (`Reaching.heldMoves`). `Overshooting.not_widening` (l. 104): nothing read off the overshooting course by any F keeps widening.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* S: `next_open` (l. 40) identifies the open update with the heater applied in a regime of draw one. `matched_meets` (l. 78) gives the replacement condition below the set level.
  - *pass b:* B: `next_open` (l. 40): with the window open, the rule is `RegimeMargin.step (heater m c) 1`, so giving depends on what is left after the draw. `Unheated.window_cold` (l. 70): with no heater, the level is 0 at step m+k for every k (by `RegimeMargin.stays_ended`, giving short of the draw). `Matched.window_held` (l. 89): with c = 1, the level stays m (by `RegimeMargin.holds` with `matched_meets` and `matched_keeps`).
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the heater is a function parameter `heater m c`, not a going-on that can be lost.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* S: `Unheated.window_cold` (l. 70) concludes zero level at m+k for every k on the specified unheated window run.
  - *pass b:* B, concluded: `Unheated.window_cold` (l. 70): once the window opens, the unheated room's level is 0 at every step from m on (stays ended). The loss is at a low level (level 0), not the loss of what gives.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no single statement gives both outcomes. B, separately: the unheated room goes cold (`Unheated.window_cold`, l. 70), the matched room holds (`Matched.window_held`, l. 89), and the overshooting room stays in [3,4] (`Overshooting.holds_one_way`, l. 148).
- **a comparison between two**
  - *pass a:* S: `steps_of_net` (l. 217) and `net_of_steps` (l. 225) carry room steps between net and process. B: `Overshooting.alternation_shifted` (l. 187) equates two runs at every date up to a shift of two.
  - *pass b:* B: `Overshooting.alternation_shifted` (l. 187): the overshooting window course equals RegimeMargin.Alternation's run from 1, plus 2 at every step. `Overshooting.in_phase` (l. 170). `steps_of_net` and `net_of_steps` (l. 217, l. 225): the net's steps are exactly the process's.
- **a rank (an ending within a bound)**
  - *pass a:* S: `Unheated.window_cold` (l. 70) gives the deadline m on the open-window run from m.
  - *pass b:* B: `Unheated.window_cold` (l. 70): the condition is gone by step m (the margin), described as gone after as many steps as it stood. No general rank law here.
- **a closed region**
  - *pass a:* S: `Matched.window_held` (l. 89) keeps every positive set level at all dates under matched heating. B: `Overshooting.holds_one_way` (l. 148) keeps the overshooting run in [3,4] despite failure of the stated band certificate.
  - *pass b:* B: `Overshooting.holds_one_way` (l. 148): no band holding the set level meets RegimeMargin.holds' conditions (Meets and Keeps fail), yet the course stays within [3,4] at every n. `Matched.window_held` (l. 89): the level is m at every step.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `Overshooting.alternates` (l. 94) and `generation_at_moments` (l. 114) give alternating levels and generation at every moment; `not_widening` (l. 104) excludes continuing widening for every reading of those levels.
  - *pass b:* B: `Overshooting.generation_at_moments` (l. 114): every moment of the overshooting course is 全生成 at the level, because the level changes at every step. Together with `Overshooting.not_widening` (l. 104), this is generation without widening. `Matched.no_generation_at_moments` (l. 125) and `Unheated.no_generation_at_moments` (l. 134): where the level stops changing, no moment is 全生成. No widening: `Unheated.not_widening` (l. 195) and `Matched.not_widening` (l. 203).
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and docstrings. S for states, moves, reading, level, no_return, comparison, rank, closed_region. N for share, giving, cost, multiplying, both_outcomes. B for comparison, closed_region, forms_change.
  - *pass b:* All from statements of the built model (B or N). All statements were read (all 279 lines).
