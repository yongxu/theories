# Weighted

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Weighted.lean`
- *result records that name this place's file as a source* (computed; not a link): `conditioning-by-restriction`, `draws-on-a-shared-stock`, `exit-from-a-margin`, `fulfillment-chance-floor`, `losses-of-the-sum-over-histories`, `orders-as-a-sum-over-histories`, `sum-over-histories-exact`, `sums-over-histories-by-support-horizon-and-order`, `typicality-by-counting`, `weights-count-situations`
- *dynamics in the atlas that name one of those records* (computed; not a link): `exit-from-a-margin`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-20, as "Weighted.lean: Weights.sum_courses, Weights.lumped_iff, Weights.Hom.transfer, every_weighting_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-20.md.txt)); pass b: reader whole-b-79, as "Weighted.lean: Weights, Weights.sum_courses, Weights.transfer, Weights.lumped_iff, Weights.Hom.transfer, possibility, counting, support, Lumping.loses, Interference.unseen, Memory.not_of_steps, Memory.of_kept, Weighted.Loop.courses_double, mass_mono, every_weighting_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-79.md.txt)); the third pass, where the two differed: reader whole-c-settle-29, as "Weighted.lean: settled fields moves, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-29.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Weights.sum_courses` (l. 183) equates the sum of composed weights over all length-n listed move/outcome histories with n one-step transfers for any supplied weight algebra. `Weights.lumped_iff` (l. 204) characterizes equal transfer at every horizon for all readings through a description by equal transfer at one step, given a representative for every description.
  - *pass b:* S: For every weighting with semiring-like laws (Weights) and listed moves and configurations, the sum over every course of n steps equals n steps of the one-step transfer (sum_courses). Integrating out through a description is exact at every horizon exactly where it is exact at one step (lumped_iff), a law-keeping reading commutes with the transfer (Hom.transfer), and on a listed domain every weighting keeps an event's mass from falling exactly where the event is included (every_weighting_iff). These are general; the losses are built cases (Lumping.loses, Interference, Memory, Loop.courses_double, entries_within_not_together).
- **moves**
  - *settled by the third pass:* S (weaker): `Weights.sum_courses` (l. 183): for every `weight : S → A → S → R`, listed `moves : List A` and `all : List S`, and f, the sum over `courses moves all n` of `W.along weight f s` is `W.transfer weight moves all f n s` (section variables R, W, S, A at l. 153); `Weights.lumped_iff` (l. 204): what is read through π after n steps depends on π alone for every n exactly where it does for one step. Steps with listed moves are there, and the laws sum over every sequence of moves and outcomes; no `Process S A`, policy or allowed set occurs in this module, and no statement says what some choice or every choice keeps. [which pass was right: both in part; opened: openSteps (l. 157), courses (l. 161), Weights.along (l. 167), Weights.transfer (l. 172), Weights.sum_courses (l. 183), Weights.lumped_iff (l. 204), Weights.Hom.transfer (l. 255), Memory.not_of_steps (l. 473), Memory.kept (l. 495), Memory.of_kept (l. 500), Weighted.Loop.courses_double (l. 517).]
  - *pass a:* S: Weights.along and Weights.sum_courses (ll. 167, 183) compose each course’s listed moves and outcomes and sum across all choices. B: `Memory.of_kept` (l. 500) gives precisely the distinct consecutive move pairs positive Boolean weight with the last move stored.
  - *pass b:* N: courses (l. 161) is every sequence of n open steps (a listed move paired with a listed outcome), and sum_courses sums over all of them. No law about what some or every choice keeps was found.
- **a reading**
  - *pass a:* S: `Weights.lumped_iff` (l. 204) makes one-step indistinguishability sufficient and necessary for every horizon for all terminal readings through a split-surjective description. B: `Lumping.loses` (l. 365) exhibits unequal one-step transfers at identical descriptions.
  - *pass b:* S: lumped_iff (l. 204): for a description π with representatives, what is read through π after any n steps depends only on π exactly where it does after one step. Hom (l. 239) and Hom.transfer (l. 255): a reading of one weighting in another that keeps the laws. Interference.unseen (l. 448): a reading into Bool that keeps joins marks every sum a marked course enters. every_weighting_iff (l. 621). B: Lumping.loses (l. 365): one description, different one-step reads. Memory.not_of_steps (l. 473): no step weighting on one configuration gives 'the second move differs from the first'.
- **a share**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N: mass (l. 533) is the weight of an event on a listed domain, but no rule is set again from it.
- **a level that runs down**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a giving that is itself a going-on**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: `Weighted.Loop.courses_double` (l. 517) counts 2^n alternative courses of a two-move loop on one configuration. No units reproducing within a configuration were found.
  - *pass b:* N: B: Weighted.Loop.courses_double (l. 517): around a loop of two moves the count of courses is 2^n. These are courses, not units.
- **a point of no return**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a comparison between two**
  - *pass a:* S: `Weights.Hom.transfer` (l. 255) carries each finite transfer through any map preserving the weight algebra. `every_weighting_iff` (l. 621) characterizes event inclusion on a list by mass order under every natural weighting, given decidable equality.
  - *pass b:* S: Hom.transfer (l. 255) carries the transfer from one weighting to another. lumped_iff (l. 204) carries equal reads between two starts s and s' with π s = π s'. mass_mono (l. 558): inclusion carries to mass under every weighting. mass_lt_of_added (l. 567): strict where an entry of positive weight is added.
- **a rank (an ending within a bound)**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* N: opened `mass_lt_of_added` (l. 567: for `weight : Ω → Nat` with `0 < weight x`, `before x = false`, `after x = true`, `IncludedOn domain before after` and `x ∈ domain`, `mass domain weight before < mass domain weight after`; `before` and `after` are two events Ω → Bool on one listed domain, and no process, step or time is in the statement), `mass_mono` (l. 558), `every_weighting_iff` (l. 621), `Memory.of_kept` (l. 500: a Boolean equation, `possibility.along kept (fun _ => true) none [(a, some a), (b, some b)] = differ a b`, with no process or trace), `Weighted.Loop.courses_double` (l. 517: the count of courses on one configuration with two moves is 2 ^ n). None states a going-on continuing while what is present changes, or that more can go on after. [which pass was right: b; opened: Memory.differ (l. 464), Memory.of_kept (l. 500), Weighted.Loop.courses (l. 512), courses_double (l. 517), mass (l. 533), IncludedOn (l. 539), mass_mono (l. 558), mass_lt_of_added (l. 567), every_weighting_iff (l. 621), every_event_within_iff (l. 630).]
  - *pass a:* S: `mass_lt_of_added` (l. 567) gives strict widening in weighted event mass given inclusion and a newly included listed entry of positive weight. This compares events on a supplied domain.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, moves, reading, comparison, forms_change. Named cases contribute to moves, reading. No answer relies on prose alone. The remaining questions are N, and I reached all fourteen.
  - *pass b:* Every statement and docstring and the opening account were read; reading and comparison are answered from statements, multiplying from a built case, and the rest are N after reading every statement.
