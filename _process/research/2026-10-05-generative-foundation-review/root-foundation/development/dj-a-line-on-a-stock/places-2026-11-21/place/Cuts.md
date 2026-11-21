# Cuts

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Cuts.lean`
- *result records that name this place's file as a source* (computed; not a link): `growth-constrained-fragmentation`, `which-links-a-closure-needs`
- *dynamics in the atlas that name one of those records* (computed; not a link): `growth-constrained-fragmentation`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-04, as "Cuts.lean: closure_unchanged_iff_bypassed, attached_link_separates, Flow.GrownBy.cut_unchanged_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-04.md.txt)); pass b: reader whole-b-12, as "Cuts.lean: closure_unchanged_iff_bypassed, within_link_iff, within_of_steps, attached_link_separates, joined_cut_unchanged_iff, Flow.system_unchanged_without_iff, Flow.GrownBy.condition_needed, Flow.GrownBy.every_condition_needed, Flow.GrownBy.cut_unchanged_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-12.md.txt)); the third pass, where the two differed: reader whole-c-settle-05, as "Cuts.lean: settled fields moves" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-05.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `closure_unchanged_iff_bypassed` (l. 102) characterizes preservation of all closures on removing a family of links by reachability of each removed target from its source in the remaining relation. For any list grown by attachment, `attached_link_separates` (l. 266) puts each listed link’s ends apart upon its removal.
  - *pass b:* General laws for any relation on any type: removing links changes no closure exactly where every removed link is bypassed (closure_unchanged_iff_bypassed), joining one link changes closures as within_link_iff says, and in a relation grown by attachment every link separates its ends without it (attached_link_separates) and is bypassed after one join exactly where the join crosses it (joined_bypass_iff, joined_cut_unchanged_iff). Read on a Flow's systems (closures of sharing a condition), these give which conditions a system needs, and in a world grown by attachment (Flow.GrownBy, a hypothesis) every grown condition is needed (condition_needed, every_condition_needed) until one new two-taker condition crosses it (bypass_iff, cut_unchanged_iff).
- **moves**
  - *settled by the third pass:* N: `within_of_steps` (l. 94) compares two relations (each link of `rel` within a closure of `rel'` gives each closure of `rel` within one of `rel'`), and `within_attached_iff` (l. 195) says joining `Link p n` to a relation in which n is `Unlinked` changes no closure among the others; both are about relations on `F` with `variable {F : Type}` only, with no process, plan, policy or allowed set, and `Attaches` (l. 230) is a predicate on a list of links. Opened to rule it out: within_of_steps, closure_unchanged_iff_bypassed, within_link_iff, within_attached_iff, Links. [which pass was right: b; opened: Joined l. 78; within_of_steps l. 94; closure_unchanged_iff_bypassed l. 102; link_cut_unchanged_iff l. 117; within_link_iff l. 137; within_attached_iff l. 195; Links l. 207]
  - *pass a:* S: `within_of_steps` (l. 94) treats the supplied relation as allowed links: if each is reachable in a second relation, every closure-reachable target is reachable there too. `within_attached_iff` (l. 195) preserves exactly the old reachability among formations other than a newly attached unlinked formation.
  - *pass b:* N: no process with moves; cuts and joins are relations compared, not steps.
- **a reading**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: conditions are taken part in, with no amount and nothing that runs down.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no level. Note: `Flow.GrownBy.condition_needed` (l. 655) states that in a world grown by attachment the two takers of the condition attaching n to p lie in one system and lie apart without it. That condition holds a system together, but it is an index of a fixed Web, not a going-on that is lost over steps.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `Attaches` (l. 230) is a hypothesis that each listed link attaches a formation that took part in no earlier link. No law of a step changes a number; the account says no count of links or formations is derived.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no step in time and no irreversibility.
- **both outcomes**
  - *pass a:* S: `Flow.GrownBy.cut_unchanged_iff` (l. 769) decides preservation of every system after cutting one listed condition, given decidable condition equality and a grown world with one extra two-taker condition: its takers must reach opposite ends through the other conditions.
  - *pass b:* S: `link_cut_unchanged_iff` (l. 117): cutting one link changes no closure exactly where each end stays within the other's closure under the rest. `Flow.GrownBy.cut_unchanged_iff` (l. 769): in a grown world plus one condition j with exactly two takers a and b, every system is unchanged without cond n exactly where a and b lie on the two sides of the p-n link. General, and about keeping or losing connectedness, not about going on or ending.
- **a comparison between two**
  - *pass a:* S: `within_of_steps` (l. 94) carries closure membership between relations if each source step is reachable in the other.
  - *pass b:* S: `within_of_steps` (l. 94): where each link of one relation lies within a closure under another, every closure under the first lies within one under the second. `within_congr` (l. 88): relations with the same links have the same closures. `closure_unchanged_iff_bypassed` (l. 102) compares a relation with the same relation plus links. These relate two relations, not two processes.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* S: `within_of_unlinked` (l. 183) and `not_within_unlinked` (l. 189) isolate an unlinked formation in its singleton closure and exclude it from every other formation’s closure.
  - *pass b:* S: every statement concerns WithinClosure, which Frame.lean l. 91 defines as holding where every region closed under the relation that holds f also holds g. `within_of_unlinked` (l. 183): an unlinked formation's closure holds only itself. `Flow.withinSystem_of_no_part` (l. 441): a formation taking part in no condition has only itself in its system.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* S: `within_link_iff` (l. 137) describes the possible enlargement of reachability after a symmetric link is added: an old path suffices, or the old relation reaches one end and reaches the target from the other.
  - *pass b:* S (a widening of a relation, not a step): `within_attached_iff` (l. 195): attaching an unlinked formation n by one link leaves every closure among the other formations unchanged. `Flow.GrownBy.suffix` (l. 693): what grew up to any stage is grown by attachment beside the conditions attached later. No statement has a going-on continuing over steps.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and its docstring. I used statements for states, moves, both_outcomes, comparison, closed_region, forms_change. I reached all fourteen questions.
  - *pass b:* Answered from statements: states, both_outcomes, comparison, closed_region, forms_change; the N answers come after reading every statement. WithinClosure was checked in Frame.lean. All statements read (797 lines).

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge2-03

*As "Cuts.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge2-03.md.txt).*

- **an exact statement of both outcomes**: S: `closure_unchanged_iff_bypassed` (l. 102): `(∀ f g, WithinClosure (Joined rel added) f g ↔ WithinClosure rel f g) ↔ ∀ g h, added g h → WithinClosure rel g h`, for any `rel added : F → F → Prop` on `{F : Type}` (l. 73), no other premise. Its cases: `link_cut_unchanged_iff` (l. 117), `joined_cut_unchanged_iff` (l. 297, premise `Attaches (newer ++ (p, n) :: older)`), `Flow.system_unchanged_without_iff` (l. 418, `[DecidableEq C]`), and `Flow.GrownBy.cut_unchanged_iff` (l. 769, premises `[DecidableEq C]`, `grown : L.GrownBy W (fun d => d = j) es cond`, `takers : ∀ g, L.TakesPart W g j ↔ g = a ∨ g = b`, `split : es = newer ++ (p, n) :: older`, with `L : Flow F C`, `W : Web F C` from l. 396/406). The outcomes are every closure unchanged by a cut and some closure changed; two relations are compared and there is no step in time.
- **the side that keeps**: The unchanged side is stated as equality of closures, and the exact condition is itself membership in a closure: `WithinClosure rel g h` (Frame.lean l. 91) holds where every region closed under `rel` that holds `g` holds `h`. So the condition is about regions closed under a relation, not a region kept by the step of a process. `within_of_unlinked` (l. 183) and `Flow.withinSystem_of_no_part` (l. 441) give a closure that holds only the formation itself.
- **the side that ends**: N. On the changed side the statements say only that the ends lie apart: `attached_link_separates` (l. 266) concludes `¬ WithinClosure (Links (newer ++ older)) p n`; `Flow.GrownBy.condition_needed` (l. 655) and `every_condition_needed` (l. 670) the same of systems. Nothing is bounded and nothing falls; the account (l. 63-66) says no count of links or formations is derived. `Attaches` (l. 230) is growth along a list, with no measure on it.
- **moves in that statement**: N. `rel` and `added` are relations handed in; the quantifiers are over formations (`∀ f g`, `∀ g h`). Which link is cut or joined is a parameter (`a b`, `p n`), fixed once. `within_of_steps` (l. 94) carries closures from one relation to another; it is not a choice among steps.
- **a reading in that statement**: N. No observation or class of things read alike occurs; the conditions are on the relation and on `L.TakesPart W` themselves.
- **the carrier**: A relation `rel : F → F → Prop` on any type and its `WithinClosure`; lists of links `List (F × F)` read by `Links` (l. 207) under `Attaches`; in the second half a `Flow F C` with a `Web F C` and `L.WithinSystem W`, `L.SharesBeside W c`, `L.SharesOutside W cut`.
- **what is handed in**: All handed in: the relation, the links cut or joined, that the world grew by attachment (`GrownBy`, said in the account to be a hypothesis on the list), who takes part in which condition. No level, giving, share, favouring, reading or turn occurs; concluded is only which closures stay.
- **links to other modules**: `Flow.system_unchanged_without_iff` (l. 418) names `L.WithinSystem W` and `L.TakesPart W` (Feedback.lean l. 187, 179) and `WithinClosure` (Frame.lean l. 91): the case of `closure_unchanged_iff_bypassed` for one condition. `Flow.GrownBy.cut_unchanged_iff` (l. 769) and `bypass_iff` (l. 753): the same names, the case of `joined_cut_unchanged_iff` and `joined_bypass_iff` for a grown world. `Flow.withinSystem_two_takers_iff` (l. 452): `WithinSystem` equals the closure with one link joined. `Flow.shares_iff_beside` (l. 409) names `L.Shares W` (Feedback.lean l. 183): it is `Joined (SharesBeside c) (BothTakePart c)`. `closure_unchanged_iff_bypassed` (l. 102) and every other statement of `Cuts` name `WithinClosure` (Frame.lean).
- **standing**: None seen. The account (l. 9-11) says no premise beyond each statement's hypotheses; `[DecidableEq C]` is an instance premise of the Flow statements from l. 409 on; `within_link_iff` (l. 137) is said to use no symmetry and no decision.
- **note**: An exact condition with no process, no moves, no reading and no bound: the two sides are closures unchanged and ends apart. It bears on a both-outcomes statement only as a law of which links a closed region needs.
