# GrammarMap

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarMap.lean`
- *result records that name this place's file as a source* (computed; not a link): `degeneration-from-a-horizon`, `generation-and-degeneration-at-two-grains`, `processes-represented-both-ways`, `the-world-represented-both-ways`
- *dynamics in the atlas that name one of those records* (computed; not a link): `degeneration-from-a-horizon`, `generation-and-degeneration-at-two-grains`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-06, as "GrammarMap.lean: «延尽之定当且仅当排中», «全三域之周», Map.«生守相杂», Map.Short.renews_and_ends_everywhere" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-06.md.txt)); pass b: reader whole-b-21, as "GrammarMap.lean: «传», «全生成», «全守», «有终», «延», «尽», «生成», «守», «退化», «延尽不并», «延尽之定当且仅当排中», «全三域之周», «尽则有终当且仅当排中», «生生即延», Map.Endless.generation, «生守相杂»" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-21.md.txt)); the third pass, where the two differed: reader whole-c-settle-08, as "GrammarMap.lean: settled fields rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-08.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `«延尽之定当且仅当排中»` (l. 330) equates a universal decision between some continuing branch and inductive ending of every branch with excluded middle. `«全三域之周»` (l. 157) places each point in strong generation, strong keeping or reaching an end given excluded middle.
  - *pass b:* For every carrier and relation R, read at a fine class E and a coarse class L, the module defines carrying renewal (the coarse line continues while a fine line begins), strong generation, strong keeping, reaching an end, going on along some branch («延») and ending on every branch («尽», inductive), generation, keeping and degeneration. It proves which of these exclude each other, that with excluded middle the strong forms cover every point, that telling them apart at every point of every model is exactly excluded middle, and that «尽» gives «有终» up to double negation or where going on is decided. All of this is general. Built cases on Nat, Unit, Bool and a two-branch fork show that each region is inhabited.
- **moves**
  - *pass a:* B: `Map.fork` (l. 537) offers two successor branches from one root. `Map.«生守相杂»` (l. 553) proves generation and keeping at that root on the respective branches.
  - *pass b:* S, partly: there is no Process with actions or policy, but R may branch. `«延»` (l. 225) is a family S holding x, each member continued under L by a member: going on along some branch. `«尽»` (l. 229) is ending on every branch. `«延尽不并»` (l. 233): «尽» R L x → ¬ «延» R L x. B: `Map.«生守相杂»` (l. 553): at the root of the fork, generation along the chain branch and keeping along the still branch.
- **a reading**
  - *pass a:* S: `«传»` (l. 62) tests a single edge by two relations, requiring a coarse continuation into a fine beginning. `«传则异»` (l. 65) entails that the fine relation distinguishes its endpoints.
  - *pass b:* S, as grains rather than observations: every law is read under two classes, a fine E and a coarse L. `«传则异»` (l. 65): a carrying renewal is an alteration, so the fine class tells its two ends apart. `«有常则无终»` (l. 111): where L is constant under R («有常» R L) and x has a predecessor, ¬ «有终» R L x. B: `Endless.generation` (l. 421, under «静») and `Endless.generation_in_pairs` (l. 445, under pairs): which fine class is used decides whether a step counts as a renewal. No rule is made from what is registered.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N for a law. D: the opening account glosses the fine parts as what makes up the pattern (cells, flames, members). No statement makes the coarse going-on depend on fine renewal that can be lost; «全生成» holds «不穷» as part of its definition (l. 80), so `«阶全生成则上无终»` (l. 199) follows from the definition.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: fine lines begin («生» within «传»), but nothing counts them and no law of the step changes their number.
- **a point of no return**
  - *pass a:* S: `«延尽不并»` (l. 233) rules out a continuing branch from a point assumed inductively ending on every branch. B: `Map.short_end` (l. 466) gives the terminal point of the built short life.
  - *pass b:* S, concluded: `«延尽不并»` (l. 233): from a point that ends on every branch, no branch goes on. `«尽则非不穷»` (l. 248). `«有终之所前亦有终»` (l. 149): what reaches a point whose line reaches an end reaches an end too. `«有常则无终»` (l. 111) / `«有终则粗不有常»` (l. 118): reaching an end after a continued step means the coarse class is not constant. All of these concern the loss of the coarse pattern itself, not a low level.
- **both outcomes**
  - *pass a:* S: `«延尽之定当且仅当排中»` (l. 330) gives the exact logical premise for the general branch dichotomy. `«不穷有终之定当且仅当排中»` (l. 125) separately treats continuation at every reachable point versus reaching some end.
  - *pass b:* S, general: `«延尽之定当且仅当排中»` (l. 330): every point of every model goes on along some branch or ends on every branch, iff excluded middle. `«不穷有终之定当且仅当排中»` (l. 125): the same for never ending vs reaching an end. `«全三域之周»` (l. 157): given excluded middle, every point is «全生成», «全守» or «有终». `«全三域之定当且仅当排中»` (l. 177). Exclusions: `«全生成有终不并»`, `«全生成全守不并»`, `«全守有终不并»` (l. 97-108), `«生成退化不并»` (l. 296), `«单行则生守不并»` (l. 317, where R is functional). `«尽则有终当且仅当排中»` (l. 584). B: `Map.Short.renews_and_ends` (l. 476) renews and still ends.
- **a comparison between two**
  - *pass a:* S: `«生生即延»` (l. 360) and `«息即尽»` (l. 367) translate endless renewal and ceasing into branch continuation and all-branch ending on the renewing-into relation.
  - *pass b:* S: `«生生即延»` (l. 360): «生生» R E x ↔ «延» («复生至» R E) «一» x. `«息即尽»` (l. 367): «息» R E x ↔ «尽» («复生至» R E) «一» x. Both carry renewal without end, and ceasing, to the some-branch and every-branch forms of a second relation. `«阶全生成»` (l. 195) / `«阶生成则上不退化»` (l. 355): generation at order k keeps order k+1 from degenerating. No law carries a property between two processes or two starts.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* B: `Map.StepWhere.ends` (l. 514): for every `P : Prop`, `«尽» (relation P) «一» false`, where `relation P` (l. 510) is `short x y ∧ P`; also `Map.Short.ends` (l. 494): `«退化» short «一» false`. These state ending on every branch in a built relation. No statement gives a bound, rank or variant: `«尽»` (l. 229) is inductive with no number, and `«尽而续可定则有终»` (l. 261) gives `«有终»` from `«尽»` and decided going on, with no bound. [which pass was right: both in part; opened: «尽» l.229; «延尽不并» l.233; «尽则非无终» l.252; «尽而续可定则有终» l.261; step_reached_le l.395; short l.464; Short.ends l.494; StepWhere.relation l.510, ends l.514, has_next_iff l.518, end_decides l.522]
  - *pass a:* B: `Map.StepWhere.relation` (l. 510) permits only a single false-to-true step when P holds, and `Map.StepWhere.ends` (l. 514) proves all branches end for any P.
  - *pass b:* N for a bound, rank or variant. The inductive `«尽»` (l. 229) is ending on every branch with no bound. `«尽而续可定则有终»` (l. 261): «尽», with going on decided at the points of its line, gives «有终».
- **a closed region**
  - *pass a:* S: `«全生成之所及亦全生成»` (l. 144) preserves strong generation throughout coarse reach. `«单行则族含所及»` (l. 305) turns existence of an internal successor per family member into closure along every continuation line when R is functional.
  - *pass b:* S: `«延»` (l. 225), `«生成»` (l. 274) and `«守»` (l. 279) are each the existence of a family closed under going on, a certificate. `«单行则族含所及»` (l. 305): where R is functional, a family closed under going on contains everything the line reaches. `«全生成之所及亦全生成»` (l. 144): «全生成» is kept along its own line.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* S: `«全生成»` (l. 80) requires coarse endlessness and a reachable carrying renewal ahead of each reached point. B: `Map.Endless.generation_in_pairs` (l. 445) realizes it while a fine kind also continues for a step. `Map.Short.renews_and_ends_everywhere` (l. 500) realizes carrying renewal with all branches ending.
  - *pass b:* S: `«全生成»` (l. 80) is defined as the coarse line never ending, with a carrying renewal (a new fine line beginning while the coarse pattern continues) ahead of every point. `«全生成之所及亦全生成»` (l. 144), `«生成退化不并»` (l. 296). B: `Map.Endless.generation` (l. 421), `Map.Endless.generation_in_pairs` (l. 445, where a kind goes on across one step and renews beyond every point), `Map.Endless.generates` (l. 483), `Map.«生守相杂»` (l. 553). N for a widening; the account says «全生成则生成» is in KeepingWidening.
- **how it was read**
  - *pass a:* S: Read the opening account, all declaration statements and their docstrings. Statements support states, reading, no_return, both_outcomes, comparison, closed_region, forms_change. Built statements support moves, no_return, rank, forms_change. No finding for share, level, giving, cost, multiplying. All questions reached.
  - *pass b:* I read all statements, docstrings and the opening account (589 lines). states, moves, reading, no_return, both_outcomes, comparison, rank, closed_region and forms_change come from statements and built cases; giving is N for a law, with D from the account; share, level, cost and multiplying are N.
