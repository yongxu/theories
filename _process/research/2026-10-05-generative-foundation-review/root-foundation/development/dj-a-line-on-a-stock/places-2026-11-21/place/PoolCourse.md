# PoolCourse

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PoolCourse.lean`
- *result records that name this place's file as a source* (computed; not a link): `a-pool-that-recruits-through-itself`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-pool-that-recruits-through-itself`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-13, as "PoolCourse.lean: RecruitsThrough.members_alike, RecruitsThrough.first_apart, scheduled_apart" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-13.md.txt)); pass b: reader whole-b-49, as "PoolCourse.lean: Web.SameMembers, Web.RecruitsThrough, Web.apart_while_member, RecruitsThrough.members_alike, RecruitsThrough.first_apart, RecruitsThrough.alike_iff, RecruitsThrough.selects_alike, PoolCourse.alone_never_apart, PoolCourse.called_not_through, PoolCourse.scheduled_apart" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-49.md.txt)); the third pass, where the two differed: reader whole-c-settle-19, as "PoolCourse.lean: settled fields no_return, both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-19.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For pools recruiting through their present members’ observations and starting with the same members, membership agrees up to and including the first distinguishable step (ll. 107, 120). In the examples, a keeper alone never distinguishes habitat loss, an externally called reader distinguishes at one, and a scheduled reader at two (ll. 216, 239, 251).
  - *pass b:* General laws for a pool whose members at each step may depend on the history. A member that has coupled two histories apart keeps the pool apart while it stays; a pool that recruits through its own pooled coupling has the same members under two histories up to and including the first step it couples them apart; and it never couples them apart exactly when the pool along the other history never does, so every selection through it then selects them alike. Built exits (PoolCourse: alone, called, scheduled) show what is needed for a pool to come to couple into a loss.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no choice among steps. Pool membership `pool : Nat → (Nat → C → Nat) → F → Prop` is a given function of step and history. Selections are predicates `select` on histories (`Web.selects_alike_of_members`, l. 96).
- **a reading**
  - *pass a:* S: `RecruitsThrough.selects_alike` (l. 148) gives equivalent selections on two histories from common membership and recruitment through the pool, if the other history never recruits a distinguishing observer and selection factors through the present pool.
  - *pass b:* S: coupling is `Web.AlikeThroughUpTo obs g l l' t` and `AlikeThroughAll` (from Becoming.Testing). `RecruitsThrough.selects_alike` (l. 148): under `RecruitsThrough` and the same members at the start, where no member of the pool along `l'` ever couples `l` and `l'` apart, every selection through the pool along `l` at every step selects them alike. `Web.selects_alike_of_members` (l. 96): where every member at `t` couples two histories alike up to `t`, every selection through the pool there selects them alike.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no count, weight or share, and no rule set again from one. The account says no rule of aggregation is assumed.
- **a level that runs down**
  - *pass a:* B: `PoolCourse.lost` (l. 187) and `spared` (l. 192) supply different habitat-level histories. No law of stock-dependent renewal accompanies them.
  - *pass b:* B: `PoolCourse.lost` (l. 187): the habitat stands at `1 - t`, lost from step 1. N: no general law of a level running down with a return depending on what is left.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: nothing gives to a level. Membership is supplied as a function.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: nothing charged to the one keeping or giving.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no units leaving units and no kinds forming kinds.
- **a point of no return**
  - *settled by the third pass:* S, of a distinction and not of a loss: `Web.apart_while_member` (l. 89): given `pool t l g`, `s ≤ t` and `¬ W.AlikeThroughUpTo obs g l l' s`, then `¬ W.AlikeThroughAll obs (pool t l) l l' t`. Being coupled apart is not undone while the member stays; that it stays is a premise. No statement of a level or a giver lost and not regained. [which pass was right: both in part; opened: `apart_while_member` l.89; `RecruitsThrough.alike_iff` l.137 and `selects_alike` l.148 (with section `variable (recruits) (start)` and `include recruits start`, l.101-102); `first_apart` l.120.]
  - *pass a:* S: `Web.apart_while_member` (l. 89) retains a past distinction at every later time the distinguishing member belongs. Permanent membership is not concluded.
  - *pass b:* N: no point of no return or irreversibility of a loss. S, of a lasting blindness: `RecruitsThrough.alike_iff` (l. 137) with `selects_alike` (l. 148) concludes that a difference the pool along `l'` never couples apart is never coupled apart along `l` either, at any step. This holds under the premises `RecruitsThrough` and same members at the start. It is not a loss that is not regained.
- **both outcomes**
  - *settled by the third pass:* S, in a different form: `RecruitsThrough.alike_iff` (l. 137), under the section's included premises `recruits : W.RecruitsThrough obs pool` and `start : SameMembers pool l l' 0`: `(∀ t, AlikeThroughAll obs (pool t l) l l' t) ↔ ∀ t, AlikeThroughAll obs (pool t l') l l' t`. An exactly-when of never coupling apart versus coming to (with `first_apart` l. 120 for the step), between two histories; not of going on and ending. B: `alone_never_apart` (l. 216) against `called_apart` (l. 239) and `scheduled_apart` (l. 251), three different pools on one web. [which pass was right: both in part; opened: `alike_iff` l.137, `members_alike` l.107, `first_apart` l.120, `members_alike_always` l.128, `alone_never_apart` l.216, `called_not_through` l.227, `called_apart` l.239, `scheduled_apart` l.251.]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S, of coupling rather than going on and ending: `RecruitsThrough.alike_iff` (l. 137) is general. Under `RecruitsThrough` and same members at 0, the pool along `l` never couples `l`, `l'` apart exactly when the pool along `l'` never does. B: `PoolCourse.alone_never_apart` (l. 216) against `PoolCourse.called_apart` (l. 239) and `scheduled_apart` (l. 251), different pools on one web.
- **a comparison between two**
  - *pass a:* S: `RecruitsThrough.alike_iff` (l. 137) equates all-time indistinguishability using either history’s pool, given self-recruitment and common initial membership.
  - *pass b:* S: laws carrying between the pool along two histories. `RecruitsThrough.members_alike` (l. 107): same members at every step up to the first step the pool couples them apart. `RecruitsThrough.first_apart` (l. 120): at that first step, the pool along `l'` has the same members and couples them apart too. `AlikeThroughAll.of_same` (l. 83) carries coupling between groups with the same members.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no variant, bound on ending or deadline.
- **a closed region**
  - *pass a:* S: `RecruitsThrough.members_alike_always` (l. 128) propagates equal memberships from equal starts under self-recruitment when the other pool never separates the histories.
  - *pass b:* S: `RecruitsThrough.members_alike_always` (l. 128): where the pool along `l'` never couples the histories apart, sameness of membership holds at every step (an invariant carried by `RecruitsThrough`). `Web.apart_while_member` (l. 89): coupled-apart stays while the member stays.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `PoolCourse.scheduled_apart` (l. 251) gives a pool that gains the habitat reader at step two and can then distinguish histories it read alike before.
  - *pass b:* B: membership changes along the run. `PoolCourse.scheduled` (l. 243) admits the reader at step 2 in every history, and `PoolCourse.scheduled_apart` (l. 251) shows that pool, recruiting through itself, coupling the loss apart at step 2 and not before: the pool widens. `PoolCourse.called_apart` (l. 239) does the same at step 1, through an admission not made through the pool (`called_not_through`, l. 227). N: no general law of widening.
- **how it was read**
  - *pass a:* S: Read the opening account, every declaration statement and its docstring. Statements — states, reading, no_return, comparison, closed_region. Built cases — level, forms_change. Not found — moves, share, giving, cost, multiplying, both_outcomes, rank. No answer rests on commentary alone or was left unreached.
  - *pass b:* All statements and docstrings read, to the end (l. 265). Answered from statements: reading, both_outcomes (of coupling), comparison, closed_region (S); level and forms_change (B). N after reading all: moves, share, giving, cost, multiplying, no_return (with an S note), rank. None from the account only. None unreached.
