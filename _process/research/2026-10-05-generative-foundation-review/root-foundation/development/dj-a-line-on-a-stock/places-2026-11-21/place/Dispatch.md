# Dispatch

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Dispatch.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-04, as "Dispatch.lean: succeeded_current, acquire_exact, dispatch_completes, discovery_then_dispatch" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-04.md.txt)); pass b: reader whole-b-13, as "Dispatch.lean: Dispatch.acquire, Dispatch.dispatch, Accepts, acquire_exact, dispatch_absent, dispatch_revoked, dispatch_succeeded_current, dispatch_completes, discovery_then_dispatch, Dispatch.process, acquire_reads_run, found_short_of_reserve, captured_epoch_passes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-13.md.txt)); the third pass, where the two differed: reader whole-c-settle-05, as "Dispatch.lean: settled fields both_outcomes, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-05.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `succeeded_current` (l. 315) requires the current addressed key, signature and matching epoch for every successful step of the dispatch model. `discovery_then_dispatch` (l. 270) guarantees successful completion for any inhabited tree with a signed current command, node-count fuel, and twice the node count plus three available in reserve and time.
  - *pass b:* Laws of one built installation model, the State of Actuation and TreeSearch with reserve, time, deadline, epoch and credential. Over every tree and state of it: acquisition draws exactly the inspections the search made; a dispatch fails without the route at the ticket's address or with a credential that is not the epoch; a successful one was current; a current dispatch with enough reserve completes with exact draws; every inhabited tree is found with its node count as fuel and its ticket carried out. Computed cases, checked by decide, cover shutdown, shortage, revocation, a stale ticket, renewal and a captured epoch.
- **moves**
  - *pass a:* S: `step_iff` (l. 298) gives each ticket’s unique dispatch result on a current tree. `revoked_fails` (l. 309) excludes success for every ticket from a mismatched credential.
  - *pass b:* S: `Dispatch.process` (l. 294): `Process Delivery Ticket`, where a delivery steps by a chosen ticket to `dispatch current t d.state`. `absent_route_fails` (l. 303) and `revoked_fails` (l. 309): every step fails if the route is absent or the credential is not the epoch. `succeeded_current` (l. 315): every successful step had the route and a signed, current command.
- **a reading**
  - *pass a:* S: `act_succeeded` (l. 125) requires a located, accepted key. `act_of_reject` (l. 108) leaves the checked state and reports failure for a located key failing acceptance.
  - *pass b:* S: `dispatch` (l. 86) re-reads the ticket's address in the current tree, and `act` (l. 75) enacts only under `Accepts` (l. 66: the key matches, signed, credential = epoch, 3 ≤ reserve, time+3 ≤ deadline). `dispatch_succeeded_current` (l. 186): success implies `locate current ticket.1 = some ticket.2`, signed, and credential = epoch. B: `captured_epoch_passes` (l. 403): a state with epoch = credential = 99 passes. The gate registers only that equality.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a level that runs down**
  - *pass a:* S: `acquire_exact` (l. 152) deducts inspected nodes from the starting reserve when fuel and deadline are covered. B: `short_step_fails` (l. 437) leaves reserve two after a failed dispatch. No return flow is supplied.
  - *pass b:* S: `acquire_exact` (l. 152): after.reserve + inspected = s.reserve. `dispatch_completes` (l. 207): given ticket length+1+3 ≤ reserve and the timing, the reserve falls by exactly that amount. Whether acting succeeds depends on what is left, through `Accepts` (l. 66, 3 ≤ reserve). B: `found_short_of_reserve` (l. 368): starting at reserve 9, the dispatch fails with drawn 7 and reserve 2. Nothing gives back to the reserve.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the reserve is a field of the State handed in, and nothing in the model gives to it.
- **a cost to the one that keeps or gives**
  - *pass a:* S: `dispatch_completes` (l. 207) charges the installation address length plus four in reserve, time and draw on a current signed dispatch with sufficient resources. Acquisition separately costs exactly the inspections made (`acquire_exact`, l. 152).
  - *pass b:* S: `acquire_exact` (l. 152) and `dispatch_completes` (l. 207): searching and dispatching draw the acting installation's own reserve and time. B: `revoked_keeps_drawn` (l. 375): after an epoch change the dispatch fails and the search and re-read stay drawn (drawn 7, reserve 3).
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a point of no return**
  - *pass a:* N: An epoch mismatch rules out the immediate step’s success. `renewed_search_step_succeeds` (l. 464) exhibits success in a renewed installation.
  - *pass b:* N: no general point of no return was concluded. B: `found_short_of_reserve` (l. 368) and `short_step_fails` (l. 437): short of reserve the step fails and what was drawn stays drawn. B: `renewed_epoch_recovers` (l. 391): after a change of epoch and tree, a renewed epoch and a new search succeed (a return).
- **both outcomes**
  - *settled by the third pass:* B: `acquired_step_stops` (l. 423): from `initial` (reserve ten) `acquire 4 exampleTree` gives a pair from whose state every step of `process exampleTree` by `exampleTicket` has (succeeded, running, drawn, reserve, time) = (true, false, 10, 0, 10); `short_step_fails` (l. 437): from reserve nine the ticket is found and every such step has succeeded = false, drawn 7, reserve 2. Same tree and ticket, two computed outcomes. No general exactly-when: `dispatch_succeeded_current` (l. 186) is necessary and `dispatch_completes` (l. 207) sufficient under reserve and deadline premises, stated apart. Pass b's second part names the same cases at l. 361 and l. 368. [which pass was right: a; opened: dispatch_succeeded_current l. 186; dispatch_completes l. 207; acquired_then_shutdown l. 361; found_short_of_reserve l. 368; acquired_step_stops l. 423; short_step_fails l. 437]
  - *pass a:* B: `acquired_step_stops` (l. 423) and `short_step_fails` (l. 437) give successful shutdown from reserve ten and failure after finding the ticket from reserve nine in the same tree.
  - *pass b:* N: no single exactly-when. The necessary condition (`dispatch_succeeded_current`, l. 186) and a sufficient one with reserve premises (`dispatch_completes`, l. 207) are stated separately. B: computed cases of both outcomes for one model (`acquired_then_shutdown` l. 361, `found_short_of_reserve` l. 368).
- **a comparison between two**
  - *pass a:* S: `acquire_reads_run` (l. 328) identifies the acquisition scan and its exact costs with the search run after n steps, from the same tree with n covered by reserve and deadline.
  - *pass b:* S: `acquire_reads_run` (l. 328): along every run of `Law.process advance` from `start root`, acquisition with fuel n yields the scan at step n and draws what the run inspected. `search_then_dispatch` (l. 340) carries `discovery_then_dispatch` to every such run.
- **a rank (an ending within a bound)**
  - *pass a:* S: `discovery_then_dispatch` (l. 270) bounds fuel for finding a ticket by node count and provides a sufficient reserve/time budget of twice that count plus three for signed, fresh dispatch on an inhabited tree.
  - *pass b:* S: `discovery_then_dispatch` (l. 270): every inhabited tree is found with fuel = nodes root, and the ticket is carried out given 2*nodes root+3 in reserve and time before the deadline. This is finding within a bound, with a deadline as premise. `search_then_dispatch` (l. 340) states the same along runs.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* B (weak): `changed_route_rejects_stale_ticket` (l. 384): on `changedTree` the dispatch of `exampleTicket` from `start false .shutdown 6 6` fails; `renewed_epoch_recovers` (l. 391) and `renewed_search_step_succeeds` (l. 464): on `changedTree` from `renewedState` the search finds a ticket whose dispatch succeeds. The changed tree is a second definition (`changedTree` l. 381), not a step of a course, so no statement has one course in which the tree changes and the going on continues; the two computations stand side by side. [which pass was right: both in part; opened: changedTree l. 381; changed_route_rejects_stale_ticket l. 384; renewedState l. 388; renewed_epoch_recovers l. 391; stale_ticket_fails l. 409; changed_epoch_step_fails l. 451; renewed_search_step_succeeds l. 464]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* B: `changed_route_rejects_stale_ticket` (l. 384) and `renewed_epoch_recovers` (l. 391): when the tree changes, a stale ticket fails and a new search with a renewed epoch succeeds on the changed tree. No general statement was found.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and its docstring. I used statements for states, moves, reading, level, cost, comparison, rank, and built cases for both_outcomes. I reached all fourteen questions.
  - *pass b:* All statements and docstrings read (l. 1-479). moves, reading, level, cost, comparison and rank are answered from statements (with built parts); no_return, both_outcomes and forms_change are B or N; share, giving, multiplying and closed_region are N.
