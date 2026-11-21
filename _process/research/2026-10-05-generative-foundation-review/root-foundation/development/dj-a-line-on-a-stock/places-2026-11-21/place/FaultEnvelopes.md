# FaultEnvelopes

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/FaultEnvelopes.lean`
- *result records that name this place's file as a source* (computed; not a link): `certificates-sound-and-available`, `copied-witnesses-change-nothing`, `thresholds-of-waiting`
- *dynamics in the atlas that name one of those records* (computed; not a link): `thresholds-of-waiting`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-05, as "FaultEnvelopes.lean: certificate_sound, availability_iff_separated, copied_roster_same" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-05.md.txt)); pass b: reader whole-b-16, as "FaultEnvelopes.lean: certificate, separated, certificate_sound, availability_iff_separated, copied_roster_same, duplicated_roster_same, stronger_envelope_no_new_acceptance, correlated_three_blocks" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-16.md.txt)); the third pass, where the two differed: reader whole-c-settle-06, as "FaultEnvelopes.lean: settled fields both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-06.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `certificate_sound` (l. 89) gives the warranted proposition when the certificate accepts, the actual fault set is admitted and every supporting roster member outside it warrants that proposition. `availability_iff_separated` (l. 129) characterizes acceptance for every admitted actual set when precisely those outside it support, by each pair of admitted sets leaving a roster member outside both.
  - *pass b:* General certificate laws over a roster of domains and an envelope of fault sets that may fail together: an accepted certificate has, for each admitted fault set, a supporting domain outside it, so what faithful outside domains warrant holds. The certificate is available for every admitted fault set exactly where the envelope is separated. Copied or duplicated witnesses, an empty envelope, a total fault and a stronger envelope add no acceptance. Named envelopes (one fault among three, correlated pairs among four and three) are built cases.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a reading**
  - *pass a:* S: `certificate_iff` (l. 67) decides acceptance from a nonempty envelope and a reported supporter outside every admitted set; `copied_roster_same` (l. 167) preserves it when added reports copy both support and admitted fault memberships.
  - *pass b:* S: `certificate` (l. 53) is a Boolean read of domains' reports (`supports`) against the envelope. `certificate_sound` (l. 89): if every domain on the roster outside the actual fault set that supports warrants P, an accepted certificate with the actual fault set admitted gives P. `copied_roster_same` (l. 167): witnesses supporting as a roster witness does and lying in exactly the same fault sets leave the certificate unchanged.
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
  - *pass b:* N. `duplicated_roster_same` (l. 179): listing the roster twice warrants nothing more. That is multiplicity of reports, not units leaving units.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **both outcomes**
  - *settled by the third pass:* N: `availability_iff_separated` (l. 129), for any `roster : List Domain` and `faults : Envelope`, states `(∀ actual, actual ∈ faults → certificate roster faults (fun d => !(actual.contains d)) = true) ↔ separated roster faults`. An 'exactly when' between two static conditions on a roster and an envelope; there is no step, course or state, so nothing goes on or ends and nothing is kept or lost over time. The two passes read it alike. Opened to rule out: certificate (l. 53), separated (l. 57), certificate_iff (l. 67), certificate_available (l. 100), support_inside_fault_rejected (l. 110), covering_faults_reject (l. 120), availability_iff_separated. [which pass was right: b; opened: certificate l. 53; separated l. 57; certificate_iff l. 67; certificate_witness l. 81; certificate_sound l. 89; certificate_available l. 100; support_inside_fault_rejected l. 110; covering_faults_reject l. 120; availability_iff_separated l. 129]
  - *pass a:* S: `availability_iff_separated` (l. 129) gives both directions for certificate availability under the specified outside-set support rule, a static condition.
  - *pass b:* N for going on and ending. `availability_iff_separated` (l. 129) is an 'exactly when' for certificate availability (for every admitted actual fault set) against separation of the envelope.
- **a comparison between two**
  - *pass a:* S: `stronger_envelope_no_new_acceptance` (l. 196) transfers acceptance to a nonempty old envelope when each old fault set is contained in some new one.
  - *pass b:* S: `stronger_envelope_no_new_acceptance` (l. 196): where a new envelope covers each fault set of a nonempty old one, acceptance under the new envelope carries to the old. `copied_roster_same` (l. 167) carries the certificate between a roster and its extension by copies.
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
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statements — states, reading, both_outcomes, comparison. Not found — moves, share, level, giving, cost, multiplying, no_return, rank, closed_region, forms_change. No answer rests on commentary alone; all questions were reached.
  - *pass b:* All statements of the module read (l. 1 to 242). reading and comparison answered from statements; the rest not found (both_outcomes and multiplying with notes on near statements).
