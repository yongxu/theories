# Quantum

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Quantum.lean`
- *result records that name this place's file as a source* (computed; not a link): `claims-shown-in-context`, `unity-of-readings`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-14, as "Quantum.lean: Square.line_parity, support_shown, no_context_free_values" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-14.md.txt)); pass b: reader whole-b-53, as "Quantum.lean: Square.obs, Shows, line_parity, shows_support, support_shown, no_context_free_values, line_product" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-53.md.txt)); the third pass, where the two differed: reader whole-c-settle-20, as "Quantum.lean: settled fields comparison" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-20.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* B: `Square.shows_support` and `support_shown` (ll. 427, 449) identify the value assignments jointly shown on one line of the explicit Mermin–Peres square by a nonzero integer vector with that line's supports. `Square.no_context_free_values` (l. 464) excludes any one assignment so shown on every line, even allowing a different vector per line.
  - *pass b:* This is one built model: explicit integer 4×4 matrices realize the Mermin–Peres square. Each observable squares to the identity (`obs_sq`), the observables of a line commute (`line_commute`), each line multiplies to -I where it is odd and +I elsewhere (`line_product`), and what a nonzero vector shows jointly on a line has the line's parity (`line_parity`). The headline `no_context_free_values` states that no single assignment to the nine cells is shown jointly on every line by quantum states (Kochen–Specker in Mermin and Peres's form, built).
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a reading**
  - *pass a:* B: `Square.line_parity` (l. 419) forces the three jointly shown values of any nonzero vector on a line to have the prescribed parity; `line_realized` (l. 437) realizes each choice of the first two with the corresponding third.
  - *pass b:* S/B, all of the one built square. `Shows` (l. 246): a vector shows value b at a cell where the cell's observable sends it to itself with sign b. `line_parity` (l. 419): wherever a nonzero vector shows values at a line's three cells, their parity is the line's. `shows_support` (l. 427): what is shown jointly on a line is a support of the line. `support_shown` (l. 449): every support of a line is shown by some nonzero vector. `no_context_free_values` (l. 464): no assignment f : Cell → Bool is shown jointly on every line, because it would be a global support, which `noGlobal` excludes.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
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
  - *pass b:* N: no outcomes of going on and ending, or keeping and losing. B: by `shows_support` with `support_shown` (l. 427, 449), the values shown jointly on a line are exactly its supports.
- **a comparison between two**
  - *settled by the third pass:* B: `Square.act_congr` (l. 304), in the built Mermin-Peres square: for any cell c, vectors u, v and b with `∀ m, u m = flip b (v m)`, `act c u k = flip b (act c v k)`, so a common sign flip between two vectors is kept by a cell's action. It is a relation between two vectors kept by one operator application, not a law between two processes or a simulation. `line_commute` (l. 412) states `Same` of the two orders of product of two observables on a line, an equality of two matrices and nothing carried. `shows_support` (l. 427) and `support_shown` (l. 449) relate what a vector shows on a line to `support` of Becoming.Context. [which pass was right: both in part; opened: act l.195; Shows l.246; Shows.act l.278; act_three l.283; act_congr l.304; line_commute l.412; line_parity l.419; shows_support l.427; support_shown l.449; no_context_free_values l.464]
  - *pass a:* B: `Square.act_congr` (l. 304) carries a common pointwise sign flip between two vectors through any cell action; `line_commute` (l. 412) equates both operator orders for any two cells on a line.
  - *pass b:* N.
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
  - *pass a:* S: I read the opening account, every declaration's statement and its docstring where present. Built statements answer states, reading, comparison. The remaining fields are N. No question was unreached.
  - *pass b:* Every statement and docstring was read, all 473 lines; proofs by `decide` were not opened. `reading` was answered from statements of the built model; the rest are N.
