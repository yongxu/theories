# Viability

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Viability.lean`
- *table of 20 November:* Viability with Lasting, letters `NPNNNNYY`, standing core, told in chapter 5 §10 (never leaving, reaching, lasting, draining); chapter 3 §12 (Viability.kernel_iff_held); chapter 8 §2 and §5 (Lasting.lifting, step_iff_either). Chapter 5 §4 cites the kernel through JointKeeping (kernel_and_iff), not these two files.
- *result records that name this place's file as a source* (computed; not a link): `a-response-common-over-a-reading`, `conditions-kept-together`, `market-protected-continuation`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-reading-kept-by-its-update`, `never-leaving-a-guard`

## 21 November, a future opening or closing: reader courses-still-open

*As "Viability.lean: Kernel, kernel_step_iff, kernel_certificate". A reader's return, unchecked; what the note mended is in the note: [note](../../read-a-future-2026-11-21/NOTE.md), [report](../../read-a-future-2026-11-21/read-courses-still-open.md.txt).*

- **what stands for what can go on after**: Kernel P guard s := ∀ t, Reach P s t → guard t (55): the configurations from which no course leaves the guard, over every course of a process.
- **laws concluding an opening**: Kernel.mono (110): a wider guard has a wider kernel. This compares guards, not steps along a course. Nothing found along a course.
- **laws concluding a closing**: - kernel_step_iff (98), exact: Kernel s ↔ guard s ∧ ∀ a t, step s a t → Kernel t. The kernel is closed forward. - kernel_certificate (78), kernel_iff_certificate (85), kernel_largest (91), Kernel.run (115). - never_leaves_iff_kernel (215) and never_leaves_iff_certificate (230), with the premise of one admissible disturbance; needs_admissible (249) shows it is needed. - Built example: Leaves.within_not_kernel (127).
- **forms changing while it continues**: Not found in what was read.
- **from where an opening comes**: Not applicable.
- **a way related to widening**: Not found in what was read. The docstring: 'nothing here says that some certificate exists'.

## 21 November, a choice made from a reading: reader keeping-through-what-is-registered

*As "Viability.lean: Kernel, kernel_iff_held, kernel_iff_certificate, kernel_step_iff". A reader's return, unchecked; what the note mended is in the note: [note](../../read-a-choice-from-a-reading-2026-11-21/NOTE.md), [report](../../read-a-choice-from-a-reading-2026-11-21/read-keeping-through-what-is-registered.md.txt).*

- **what is read, and what chooses from it**: Statements read (lines 1 to 110). Nothing is read and nothing chooses: Kernel (55) counts every course from s.
- **the exact law**: kernel_iff_held (65): Kernel P guard s ↔ «承» («逆» («所闭» (Steps P))) guard s. In plain English: no course from s leaves the guard exactly where the guard holds throughout what the closure of the steps reaches from s. Every course, for ever, exact. kernel_iff_certificate (85) and kernel_step_iff (98) are also exact. Kernel.keptFor (Keeping 333) carries the kernel into KeptFor, given one move usable throughout it.
- **within one reading**: Not applicable: no reading. Not found in what was read.
- **two readings of one process**: Not found in what was read.
- **when a reading tells apart, and what can still be kept**: Not found in what was read.
- **the lock as a case**: Not found in what was read. The seven lock modules do not name Viability or Kernel (grep).

## 21 November, a choice made from a reading: reader response-common-over-a-reading

*As "Viability.lean: Kernel, kernel_iff_held, Certificate.kernel, kernel_certificate, kernel_step_iff". A reader's return, unchecked; what the note mended is in the note: [note](../../read-a-choice-from-a-reading-2026-11-21/NOTE.md), [report](../../read-a-choice-from-a-reading-2026-11-21/read-response-common-over-a-reading.md.txt).*

- **what is read, and what chooses from it**: Nothing is read and no move is chosen. Kernel (55) is ∀ t, Reach P s t → guard t, over every course. It uses only «共应»'s grammar laws. Lines 1-110 read.
- **the exact law**: kernel_iff_held (65): Kernel P guard s ↔ «承»(«逆»(«所闭»(Steps P))) guard s. Certificate.kernel (72) and kernel_certificate (78) are proved from «闭在内则在所闭之承», «所闭之承在内» and «所闭之承闭». kernel_step_iff (98) is exact for one step, and the kernel holds for every course. This is the same grammar law as «共应», with the steps standing where the reading stands.
- **within one reading**: Not found in what was read.
- **two readings of one process**: Not found in what was read; Kernel.mono (110) compares guards, not readings.
- **when a reading tells apart, and what can still be kept**: Not found in what was read.
- **the lock as a case**: Not named. No share, stock or level was found.

## 22 November, every module by fifteen questions

*pass a: reader whole-a-20, as "Viability.lean: kernel_largest, kernel_step_iff, never_leaves_iff_certificate, guarded_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-20.md.txt)); pass b: reader whole-b-79, as "Viability.lean: Kernel, Certificate, kernel_iff_certificate, kernel_largest, kernel_step_iff, disturbed, never_leaves_iff_certificate, guarded_never_fails_iff, Leaves.within_not_kernel, needs_admissible" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-79.md.txt)); the third pass, where the two differed: reader whole-c-settle-29, as "Viability.lean: settled fields reading" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-29.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `kernel_largest` (l. 91) gives the largest step-invariant subset of any guard for any process, and `kernel_step_iff` (l. 98) characterizes it by present membership in the guard and kernel membership of every successor. `never_leaves_iff_certificate` (l. 230) gives the certificate characterization for all disturbance histories when at least one disturbance is admissible.
  - *pass b:* S: For every process and every guard, the invariance kernel (the configurations from which no course leaves the guard) is the largest certificate, meaning a set within the guard that every step keeps (kernel_iff_certificate, kernel_largest, kernel_step_iff). For every law of change under admissible disturbances, given one admissible disturbance, no admissible history leaves the guard exactly when some set containing the start lies within the guard and is closed under every admissible disturbance (never_leaves_iff_certificate); the same holds for guarded histories, which stop at the first step outside the guard. These are general laws, with the built cases Leaves.within_not_kernel and needs_admissible.
- **moves**
  - *pass a:* S: `certificate_disturbed_iff` (l. 172) requires closure under every admissible disturbance and inclusion in the guard. `trace_disturbed_iff` (l. 147) characterizes executable finite plans by admissibility of all their moves and the folded endpoint.
  - *pass b:* S: Kernel (l. 55): every t reachable from s satisfies the guard, so every course keeps it. disturbed (l. 137): the process whose steps are the admissible disturbances adm a, going to f s a. never_leaves_iff_kernel (l. 215): given adm a₀, every admissible sequence d keeps the guard at every time exactly when s is in the kernel. certificate_never_leaves (l. 241): from a certificate, every admissible history stays within the guard.
- **a reading**
  - *settled by the third pass:* S (weaker): `ready_of_step` (l. 275) and `step_of_ready` (l. 284): for f : S → A → S and guard : S → Prop with `[DecidablePred guard]`, `guardedStep f guard a (some s) = some t` gives `guard s ∧ guard (f s a)`, and that conjunction gives `guardedStep f guard a (some s) = some (f s a)`; `guarded_iff` (l. 299): the guarded history equals the history at every time exactly where the history is within the guard at every time. A decidable test decides whether the guarded step goes on; the test is the guard, a predicate on the configurations themselves (S and A are the section's variables, l. 50), and no observation map or class of configurations read alike appears in any statement. [which pass was right: both in part; opened: Kernel (l. 55), Certificate (l. 59), kernel_iff_certificate (l. 85), disturbed (l. 137), never_leaves_iff_certificate (l. 230), guardedStep (l. 259), guardedHistory (l. 265), guardedStep_none (l. 271), ready_of_step (l. 275), step_of_ready (l. 284), agrees_of_within (l. 290), guarded_iff (l. 299), guarded_never_fails_iff (l. 311).]
  - *pass a:* S: `guardedStep` (l. 259) tests the decidable guard at both ends and stops if either fails. ready_of_step and step_of_ready (ll. 275, 284) give necessity and sufficiency for continuing the guarded step.
  - *pass b:* N
- **a share**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N: The guard is a predicate on configurations with no amount (D: the opening account calls it the configurations where an activity can go on).
- **a giving that is itself a going-on**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N: The guard, the law f and the admissibility adm are handed in.
- **a cost to the one that keeps or gives**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* S: `guardedStep_none` (l. 271) proves by definition that once the guarded state is none, every next disturbance keeps it none. This absorption is built into guardedStep.
  - *pass b:* S: guardedStep_none (l. 271): a stopped guarded history stays stopped (none goes to none). This holds by the definition of guardedStep, so it is built into the construction rather than concluded. Leaves.within_not_kernel (l. 127), built: the guard holds at true, yet a course from true leaves it. No statement that from outside the kernel every course leaves was found; outside it only some course does.
- **both outcomes**
  - *pass a:* S: `guarded_iff` (l. 299) says a guarded history agrees at every time with the underlying history exactly when the underlying history stays in the decidable guard throughout. `guarded_never_fails_iff` (l. 311) gives the all-admissible-histories version with an admissible disturbance and a certificate.
  - *pass b:* S: kernel_iff_certificate (l. 85), general: no course from s leaves the guard exactly when some certificate contains s. never_leaves_iff_certificate (l. 230) and guarded_never_fails_iff (l. 311), general for disturbed laws given one admissible disturbance: no guarded history ever stops exactly when some set containing the start lies within the guard and is closed under every admissible disturbance. B: needs_admissible (l. 249): without an admissible disturbance the equivalence fails.
- **a comparison between two**
  - *pass a:* S: `Kernel.mono` (l. 110) carries membership to the kernel of any pointwise wider guard on the same process.
  - *pass b:* S: Kernel.mono (l. 110): a wider guard has a wider kernel. Certificate.kernel (l. 72): every certificate lies within the kernel.
- **a rank (an ending within a bound)**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* S: `kernel_largest` (l. 91) makes the kernel a certificate and includes every certificate in it. `kernel_iff_certificate` (l. 85) expresses membership by existence of a certificate containing the start.
  - *pass b:* S: Certificate (l. 59) is a set within the guard that is an Invariant of P. kernel_certificate (l. 78): the kernel is one. kernel_largest (l. 91): it contains every other. kernel_iff_held (l. 65): the kernel is what holds throughout the closure of the steps. kernel_step_iff (l. 98): one-step characterisation. certificate_disturbed_iff (l. 172): the certificate condition for a disturbed law.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, moves, reading, no_return, both_outcomes, comparison, closed_region. No answer relies on prose alone. The remaining questions are N, and I reached all fourteen.
  - *pass b:* Every statement and docstring and the opening account were read; moves, no_return, both_outcomes, comparison and closed_region are answered from statements, and the rest are N after reading every statement.

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge2-12

*As "Viability.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge2-12.md.txt).*

- **an exact statement of both outcomes**: S. `kernel_iff_certificate` (l. 85): for any `P : Process S A`, `guard : S → Prop`, `s : S` (section variables are only the types `S`, `A`): `Kernel P guard s ↔ ∃ K : S → Prop, K s ∧ Certificate P guard K`. For disturbed laws, `guarded_never_fails_iff` (l. 311): for `f : S → A → S`, `adm : A → Prop`, `guard` with `[DecidablePred guard]`, `s`, and `h₀ : adm a₀`: `(∀ d : Nat → A, (∀ n, adm (d n)) → ∀ n, guardedHistory f guard s d n = some (history f s d n)) ↔ ∃ K, K s ∧ (∀ x, K x → guard x) ∧ ∀ x a, adm a → K x → K (f x a)`; `never_leaves_iff_certificate` (l. 230) is the same without the guarded form. The going-on side is exact. The other outcome is given only as the negation of the equivalence.
- **the side that keeps**: S: a region closed under the step. `Certificate` (l. 59): `within : ∀ s, K s → guard s` and `closed : Invariant P K`. `kernel_certificate` (l. 78): the kernel is one. `kernel_largest` (l. 91): it contains every other. `kernel_step_iff` (l. 98): `Kernel P guard s ↔ guard s ∧ ∀ a t, P.step s a t → Kernel P guard t`. `certificate_disturbed_iff` (l. 172): for a disturbed law, within the guard and closed under every admissible disturbance. `certificate_never_leaves` (l. 241).
- **the side that ends**: N, plainly. Where no certificate holds `s` the module says only that the equivalence fails: not every admissible history stays within the guard (not every guarded history is `some …` at every time). No statement gives a leaving course, a time by which a guarded history stops, or a quantity that falls. `guardedStep_none` (l. 271) is `guardedStep f guard a none = none` by `rfl` (a stopped history stays stopped, by definition). `Leaves.within_not_kernel` (l. 127) is a built case: the guard holds at `true` and `true` is not in the kernel. `needs_admissible` (l. 249) is a built case that the premise `h₀` is needed. All 21 theorems were opened.
- **moves in that statement**: S, every move: `Kernel` (l. 55) is `∀ t, Reach P s t → guard t`, so every course of moves from `s`; `Certificate.closed` is `Invariant P K`, every step by every move. In `guarded_never_fails_iff` the quantifier is `∀ d : Nat → A, (∀ n, adm (d n))`, every admissible sequence of disturbances, and the certificate is closed under `∀ x a, adm a`. The allowed set is `adm`; no single move or policy is chosen. One admissible disturbance `a₀` is a premise.
- **a reading in that statement**: N. The guard is `S → Prop` on configurations and a certificate is a set of configurations; nothing registered or read alike is in the condition. `[DecidablePred guard]` in the guarded statements decides the guard at a configuration; `guardedStep` (l. 259) tests it at both ends of a step.
- **the carrier**: A `Process S A` with `guard : S → Prop` (`Kernel`, `Certificate`); for the second half `disturbed f adm : Process S A` with `history f s d : Nat → S` and `guardedHistory f guard s d : Nat → Option S`.
- **what is handed in**: Handed in: the process or the law `f`, the admissibility `adm`, the guard, and one admissible disturbance. Concluded: the equivalence of never leaving (never stopping) with a certificate holding the start. No level, giving, share, favouring, reading or turn is in the statement; the account (ll. 36-38) says which guard and which disturbances are supplied with each application and that nothing says a certificate exists.
- **links to other modules**: (1) `kernel_iff_held` (l. 65): `Kernel P guard s ↔ «承» («逆» («所闭» (Steps P))) guard s`; an equivalence with the grammar's relation of what holds throughout the closure of `Steps P` (Frame.lean l. 241), from which `Certificate.kernel` (l. 72) and `kernel_certificate` (l. 78) are proved as cases of the grammar's largest-closed-region laws. (2) `Certificate` (l. 59): its field `closed` is `Invariant P K` (Frame.lean l. 265). (3) `trace_disturbed_iff` (l. 147): `Trace (disturbed f adm) s plan t ↔ (∀ a, a ∈ plan → adm a) ∧ plan.foldl f s = t`, on Frame's `Trace`. (4) `Kernel.run` (l. 115): along every `Run P` starting in the kernel the guard holds at every `n`. (5) `Leaves.process` (l. 124) is `Witnesses.single Unit true false`.
- **standing**: None seen. The account (ll. 38-39) says no premise is added and every declaration has an empty axiom report. `[DecidablePred guard]` is an instance premise of the guarded statements only.
- **note**: This is an exact edge with a closed region on the going-on side and every move in the statement, and with nothing bounded or falling on the other side: outside the kernel the module does not even state that some course leaves, only that not all stay. No reading is in it, so it is not a statement with both outcomes, moves and a reading.
