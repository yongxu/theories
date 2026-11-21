# ReadStages

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean`
- *result records that name this place's file as a source* (computed; not a link): `when-complying-when-read-is-best`

## 21 November, how a registering comes to be: reader readings-and-the-lock

*As "ReadStages.lean". A reader's return, unchecked; what the note mended is in the note: [note](../../read-registering-2026-11-21/NOTE.md), [report](../../read-registering-2026-11-21/read-readings-and-the-lock.md.txt).*

- **what registers what**: Stages read through a lumping π: Bool→K (lumped_uniform 487, plan_realized_iff 497).
- **what changes it**: Lumping and prospects handed in; no change.
- **laws where something comes to be registered**: None found in what was read.
- **cost and keeping**: Not stated.
- **a registering lost**: read_fixes_unread (535): where π ties the stages, the read stage fixes the act at the unread one.
- **tied to what it rests on**: None found; the prospects (236) are supplied numbers.

## 22 November, every module by fifteen questions

*pass a: reader whole-a-14, as "ReadStages.lean: complyThenOwn_best_iff, plan_realized_iff, twin_complyThenOwn, freshDraw_above_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-14.md.txt)); pass b: reader whole-b-55, as "ReadStages.lean: Prospects, complyThenOwn_best_iff, ownAtBoth_best_iff, only_complyThenOwn_iff, choose_optimal, plan_realized_iff, twin_complyThenOwn, above_iff_routes, freshDraw_above_iff, mixture_never_above" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-55.md.txt)); the third pass, where the two differed: reader whole-c-settle-21, as "ReadStages.lean: settled fields share, both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-21.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `complyThenOwn_best_iff` (l. 323) says that among four two-stage plans, compliance when read followed by acting by one's own law strictly beats every other plan exactly when k_O·V + c·T \< k_C·V for the supplied prospects. `freshDraw_above_iff` (l. 775) gives the stronger threshold 2·k_O·V + c·T \< k_C·V for some positive compliance weight drawn independently at each stage to beat always acting by one's own law.
  - *pass b:* For any prospects (natural numbers: a total T, weights k_C and k_O of the law being kept after complying or after acting by its own law, a value V at the unread stage, and a loss c), four two-stage plans are compared. `complyThenOwn` (comply when read, act by its own law when not) stands above every other plan exactly where k_O V + c T \< k_C V (`complyThenOwn_best_iff`). A law reading the stages through a lumping can realize that plan only where the lumping tells the stages apart (`complyThenOwn_realized_iff`). A behavioural plan that draws its act afresh at each stage can stand above `ownAtBoth` exactly where 2 k_O V + c T \< k_C V (`freshDraw_above_iff`), while a single mixture never can (`mixture_never_above`). The laws are general over prospects but of one fixed two-stage, four-plan model, with built witnesses in `Example`.
- **moves**
  - *pass a:* S: `only_complyThenOwn_iff` (l. 395) characterizes when every maximal plan is complyThenOwn; `choose_optimal` (l. 356) gives a maximal choice for all prospects.
  - *pass b:* S: `Plan` (l. 219) is `Act × Act`, giving four plans. `complyThenOwn_best_iff` (l. 323), `ownAtBoth_best_iff` (l. 337): which plan stands above all others. `only_complyThenOwn_iff` (l. 395): every maximal plan is `complyThenOwn` exactly where `KeepingOutweighs`. `choose_optimal` (l. 356): `choose` is maximal. `unread_comply_not_above` (l. 351): complying at the unread stage never stands above acting by its own law after the same read act. The laws are about which choice is optimal, not about what a choice keeps over steps.
- **a reading**
  - *pass a:* S: `plan_realized_iff` (l. 497) permits a plan through a deterministic stage reading exactly when it is uniform or the reading distinguishes the stages. `twin_complyThenOwn` (l. 543) carries selection to a comply-then-own twin under stage distinction, selection through read-stage agreement and an already selected lumped law complying there.
  - *pass b:* S: `plan_realized_iff` (l. 497): a plan is open to an act law reading the stages through a lumping π (`Learning.Lumped`) exactly where the plan is uniform or π tells the stages apart. `read_fixes_unread` (l. 535): where π ties the stages, the read stage fixes the act at the unread one. `twin_complyThenOwn` (l. 543): where π tells the stages apart, every selection through agreement on the read stage that selects a lumped law complying when read also selects a lumped law taking `complyThenOwn`. `kept_alike` (l. 563): the weight of being kept reads only the act at the read stage.
- **a share**
  - *settled by the third pass:* N: opened `Prospects` (l. 236), `Prospects.Valid` (l. 253): `0 < s.total`, `s.keptComplying <= s.total`, `s.keptOwn <= s.total`, weights of the law being kept read against a total; `FreshDrawAbove` (l. 300), an inequality with the chance m to m + r of complying; `freshDraw_above_iff_chance` (l. 736). These are weights of one formation's prospects and a chance of an act, not a count or fraction of one kind among several, and nothing is set again from them. [which pass was right: a; opened: Prospects (l. 236), Valid (l. 253), kept (l. 256), gain (l. 263), loss (l. 269), KeepingOutweighs (l. 286), choose (l. 290), FreshDrawAbove (l. 300), MixtureAbove (l. 308), freshDraw_above_iff_chance (l. 736)]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: the weights `keptComplying` and `keptOwn` are read as fractions of `total` (`Prospects.Valid`, l. 253), and `FreshDrawAbove` (l. 300) uses the chance m/(m+r). N: no rule or favouring is set again from a share.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no stock or reserve that runs down. The prospects are fixed numbers.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* S: `Prospects.loss` (l. 269) charges the planner c·T for compliance at the read stage, zero otherwise; `outweighs_needs_more` (l. 469) forces c \< V if keeping outweighs the loss and the compliance-keeping weight is within total.
  - *pass b:* S: `Prospects.cost` (l. 246), the loss of complying when read, borne by the formation that complies (`loss`, l. 269). `outweighs_needs` (l. 458): keeping outweighs the loss only with V > 0 and k_O \< k_C. `outweighs_needs_more` (l. 469): with k_C ≤ T, only where c \< V. `ownAtBoth_above_without_value` (l. 444): with 0 \< c T and V = 0, `ownAtBoth` stands above `complyThenOwn`.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the law being kept after the read stage enters only as a weight. No irreversibility is stated.
- **both outcomes**
  - *settled by the third pass:* N: opened `choose_eq_iff` (l. 380): for every `s : Prospects`, `s.choose = complyThenOwn` iff `s.KeepingOutweighs` (`keptOwn * value + cost * total < keptComplying * value`), and `choose_of_not_outweighs` (l. 389): otherwise `s.choose = ownAtBoth`. A general, exact dichotomy, but of which plan the definition `choose` (l. 290) returns; it is not of a course going on and ending, or of something kept and lost. [which pass was right: a; opened: Act (l. 214), Plan (l. 219), KeepingOutweighs (l. 286), choose (l. 290), choose_eq_iff (l. 380), choose_of_not_outweighs (l. 389)]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: `choose_eq_iff` (l. 380) and `choose_of_not_outweighs` (l. 389): the choice is `complyThenOwn` exactly where `KeepingOutweighs`, and `ownAtBoth` otherwise. This is a dichotomy between plans, general over prospects. N: no dichotomy of going on and ending, or of keeping and losing.
- **a comparison between two**
  - *pass a:* S: `above_iff_routes` (l. 630) carries the prospects' order on each pair of plans both ways to the corresponding pair of revision routes.
  - *pass b:* S: `above_iff_routes` (l. 630): one plan stands above another exactly where its counterpart under `asRoute` stands above the other's in `RevisionRoutes` at three routes. `gain_asRoute` (l. 613) and `loss_asRoute` (l. 621): gain and loss carry over. `freshDraw_above_iff_chance` (l. 736) compares a behavioural plan with `ownAtBoth`.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: maximal plans (`Prospects.Maximal`, l. 282) are optima of an order, not a region closed under steps.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration's statement and its docstring where present. General statements answer states, moves, reading, cost, comparison. The remaining fields are N. No question was unreached.
  - *pass b:* All statements and docstrings were read, l. 1 to 889. Questions 2, 3, 4 (in part), 7, 10 (of plans) and 11 are answered from statements. The rest are N.
