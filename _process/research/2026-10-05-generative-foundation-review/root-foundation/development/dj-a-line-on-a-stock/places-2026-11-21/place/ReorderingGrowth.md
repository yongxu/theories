# ReorderingGrowth

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReorderingGrowth.lean`
- *result records that name this place's file as a source* (computed; not a link): `reorderings-as-courses-of-growth`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-16, as "ReorderingGrowth.lean: reordering_iff_course, present_every_reordering, persists_of_present_reordering, VeeWorld.presence_varies" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-16.md.txt)); pass b: reader whole-b-61, as "ReorderingGrowth.lean: exchanges, natural_iff, reordering_iff_course, precedes_iff_every_reordering, before_some_reordering, present_some_reordering, present_every_reordering, persists_of_present, ByDependence.persists_not_present, VeeWorld.presence_varies" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-61.md.txt)); the third pass, where the two differed: reader whole-c-settle-23, as "ReorderingGrowth.lean: settled fields both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-23.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `reordering_iff_course` (l. 198) identifies achievable numberings of a world’s first m exchanges with natural labellings and with relabellings onto the mth configuration of a growth run from empty, given containment and a reindexing. `persists_of_present_reordering` (l. 584) carries the earlier poststate of each touched relatum to the later exchange whenever the earlier exchange is present there on a reordering.
  - *pass b:* For any Footprinted world, the first m steps' exchanges ordered by Precedes form a causal set (exchanges_ordered). Where the footprint contains the exchanges, the numberings given by reorderings are exactly its natural labellings, and exactly the orders of birth of causal-set growth courses from empty (reordering_iff_course), so the laws of presence of Becoming.Presence hold on reorderings (precedes_iff_every_reordering, before_some_reordering, antichain_present_reordering, present_some_reordering, present_every_reordering); these laws are general. Presence on the world as it is implies the persistence of what the earlier exchange touched (persists_of_present); built witnesses (ByDependence, MovedBack, VeeWorld) show persistence without presence, and presence varying with the reordering.
- **moves**
  - *pass a:* S: `present_every_reordering` (l. 517) says that for a containing footprint and j in the stretch, i is present when j is taken under every permitted reordering exactly when j is its unique upper link in the stretch.
  - *pass b:* S: `Reordering r m ts` (l. 121): a list of commutations within the stretch, each of two exchanges that are not joined. Laws over every or some choice: `every_reordering_iff` / `some_reordering_iff` (ll. 167, 176) carry any stretch-read property between natural labellings and reorderings. `precedes_iff_every_reordering` (l. 404): with Precedes i j decided, i precedes j iff every reordering places i first. `either_order_reordering` (l. 433): two different unrelated exchanges are taken in either order on some reordering. `reordering_nil` (l. 186): if every consecutive pair is joined, the only reordering is []. Also `Run process` of CausalGrowth, in `reordering_iff_course` (l. 198).
- **a reading**
  - *pass a:* S: `presentAt_stretch` (l. 383) transfers presence between any numberings agreeing throughout the stretch. `present_identity_iff` (l. 550) characterizes presence in original order by precedence within the stretch and no intervening exchange joined to i.
  - *pass b:* S: the footprint registers what each step touches. `present_identity_iff` (l. 550): i is present when j is taken on the world as it is iff i precedes j within the stretch and no exchange between is joined to i. `persists_of_present` (l. 565): with Contains, that presence implies every relatum i touches is shown at j as right after i's step. `precedes_decided` (l. 297): joining decided on the stretch decides precedence. `every_reordering_iff` (l. 167) takes as premise a property read on the stretch (agreeing numberings).
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N in a general law. B: `ByDependence.web` / `ByDependence.dependent` (ll. 630, 639): relatum 1 needs relatum 0 to stand at 1, and relatum 0 always stands at 1 or more, so the need is met. No running down.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N in a general law. B: `ByDependence` (ll. 615-716): the condition relatum 1 needs is the standing of relatum 0, a relatum of the web touched by the first and last steps; it is not lost.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N for units leaving units. S only that a reordering's numbering is matched to a causal-set growth course from empty whose configuration at m births relabels the exchanges (`reordering_iff_course`, l. 198; `VeeWorld.one_course_two_numberings`, l. 958); births are in CausalGrowth, not read here.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *settled by the third pass:* N for going on and ending or keeping and losing. Opened: `present_some_reordering` (l. 505; premises `r.Contains`, precedence weakly decided on the stretch, j \< m): `(∃ ts, Reordering r m ts ∧ PresentAt (exchanges r m) (place ts) i j) ↔ links r.Precedes i j`; `present_every_reordering` (l. 517; `r.Contains`, j \< m): present on every reordering ↔ i is a link below j and below no other k \< m; `present_identity_iff` (l. 550, no premise): `PresentAt (exchanges r m) (fun k => k) i j ↔ (i < m ∧ j < m ∧ r.Precedes i j) ∧ ∀ k, i < k → k < j → ¬ r.Joined i k`; `VeeWorld.presence_varies` (l. 933, built): not present on `[]`, present on `[1]`. These are exact characterisations of `PresentAt` (being among the maximal exchanges taken); `persists_of_present` (l. 565) gives persistence from presence one way only, so not being present is not a losing. [which pass was right: b; opened: present_some_reordering (l. 505), present_every_reordering (l. 517), present_identity_iff (l. 550), persists_of_present (l. 565), persists_of_present_reordering (l. 584), VeeWorld.reordering (l. 927), VeeWorld.presence_varies (l. 933)]
  - *pass a:* B: `VeeWorld.presence_varies` (l. 933) exhibits absence of exchange 0 when 2 is taken in the original order and its presence at that event after one allowed swap.
  - *pass b:* N for going on or ending, or keeping or losing. S of exact characterisations of presence: `present_some_reordering` (l. 505): present on some reordering iff a link below. `present_every_reordering` (l. 517): present on every reordering iff a link below j and below no other exchange of the stretch. B: `VeeWorld.presence_varies` (l. 933): present on reordering [1], not on [].
- **a comparison between two**
  - *pass a:* S: `every_reordering_iff` (l. 167) and `some_reordering_iff` (l. 176) carry universal and existential properties of numberings between natural labellings and reorderings, given containment and invariance under agreement on the stretch.
  - *pass b:* S: `reordering_iff_course` (l. 198) carries between a world's reorderings and causal-set growth courses. `course_converse` (l. 224): a world r₂ taking r's exchanges in the order of a course agrees with some reordering over the stretch. `persists_of_present_reordering` (l. 584) carries persistence to the reordered world. `keeps_precedes` (l. 132): a renumbering keeping joined pairs keeps every chain.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N. S only that `present_unrelated` (l. 443) makes the present (MaximalBorn) of any numbering at a stage an antichain of Precedes, and `exchanges_ordered` (l. 110) makes the stretch a causal set.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `VeeWorld.one_course_two_numberings` (l. 958) realizes both numberings on the same growth run from empty to three births. `presence_varies` (l. 933) changes which exchange is present at a specified birth by changing the matching.
  - *pass b:* S, partly: the present of a numbering at a stage (MaximalBorn) changes with stage and reordering. `antichain_present_reordering` (l. 450): every Boolean-tested antichain is the present of some reordering at some stage. No statement that a going-on continues while its present changes. B: `VeeWorld.presence_varies` (l. 933). `MovedBack.persists_not_present` (l. 798): what the first exchange touched is moved and moved back by the middle two, and shown as before when the last is taken, though the first is not present.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. I used statements for states, moves, reading, comparison. Built cases support both_outcomes, forms_change. No answer depends on the opening account or docstrings alone. I found no matching result for share, level, giving, cost, multiplying, no_return, rank, closed_region. I reached every question.
  - *pass b:* All statements and docstrings read, and the account. The first 160 lines in full; after that, signatures and docstrings, with witness definitions to their first lines. Every field answered from statements or built cases. Three names cited in the account (reorder_determined, rearranges_iff_independent, reindexes_of_within) are in OrderNormal.lean and are not read here.
