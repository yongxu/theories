# ChanceFloors

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ChanceFloors.lean`
- *result records that name this place's file as a source* (computed; not a link): `fulfillment-chance-floor`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-02, as "ChanceFloors.lean: fulfillment_gives_chance_floor, positive_chance_can_miss_due_protection" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-02.md.txt)); pass b: reader whole-b-04, as "ChanceFloors.lean: target, Fulfilled, fulfillment_gives_chance_floor, repair, repair_covers_target_and_candidate, repair_adds_new_protection, positive_chance_can_miss_due_protection" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-04.md.txt)); the third pass, where the two differed: reader whole-c-settle-02, as "ChanceFloors.lean: settled fields share" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-02.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `fulfillment_gives_chance_floor` (l. 57) bounds the new route’s mass below by due protection and above by total weight under positive total and pointwise fulfilment. B: `positive_chance_can_miss_due_protection` (l. 98) exhibits equal positive masses with a missed due entry.
  - *pass b:* General over any listed domain and any weighting: a new route that fulfils a due protection pointwise (works wherever demand && oldWorks holds) has a mass at least the protection's and at most the total. Repair, the protection or a candidate, fulfils it and raises the mass where the candidate works at a weighted entry where the protection was not due; one built case shows a route with positive chance, and the same success mass as the protection, failing exactly where the protection was due.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a reading**
  - *pass a:* S: `mass_dirac_pos_iff` (l. 44) detects a particular listed entry satisfying the Boolean event by positivity of its Dirac mass, assuming decidable equality.
  - *pass b:* B: positive_chance_can_miss_due_protection (l. 98): on [false, true] with unit weights, the route fun h => h has the same mass (1) as the protection, yet is not Fulfilled; the mass does not register where it fails. S: mass_dirac_pos_iff (l. 44): the weighting counting one entry gives an event positive mass exactly where the entry is listed and the event holds there.
- **a share**
  - *settled by the third pass:* N: opened every statement; fulfillment_gives_chance_floor (l. 57) states, from 0 \< total domain weight and Fulfilled, that mass of target \<= mass of newWorks \<= total, and repair_adds_new_protection (l. 86) a strict rise of mass. These are masses under one fixed weighting; no rule or favouring is set again from a count or fraction, and there is no step. [which pass was right: a; opened: all nine declarations, ll. 40-98]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: fulfillment_gives_chance_floor (l. 57): with 0 \< total, mass of target \<= mass of newWorks \<= total, a weighted fraction of the domain. N: no rule is set again from it.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: oldWorks, the old support that still works, is a handed-in function.
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
  - *pass b:* N.
- **a comparison between two**
  - *pass a:* S: `repair_covers_target_and_candidate` (l. 71) gives pointwise coverage of the due target and candidate by repair for every listed domain.
  - *pass b:* S: fulfillment_gives_chance_floor (l. 57): pointwise inclusion of the protection in the new route carries to mass order under every weighting, through mass_mono (another module). repair_covers_target_and_candidate (l. 71).
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* S: `repair_adds_new_protection` (l. 86) gives strictly greater protected mass for repair if a listed positive-weight entry satisfies the candidate outside the target; implementation in time is separate.
  - *pass b:* S: repair_adds_new_protection (l. 86): where a candidate works at an entry h of the domain with 0 \< weight h, and target is false there, mass of target \< mass of repair. This is the mass of a Boolean event, not of a going-on.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, reading, comparison, forms_change. Built-case answers cover states. I reached all fourteen questions.
  - *pass b:* All statements read (110 lines). reading (S and B), share, comparison and forms_change answered from statements; the rest are N.
