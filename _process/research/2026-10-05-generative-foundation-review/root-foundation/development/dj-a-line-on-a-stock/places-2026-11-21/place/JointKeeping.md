# JointKeeping

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/JointKeeping.lean`
- *result records that name this place's file as a source* (computed; not a link): `conditions-kept-together`
- *dynamics in the atlas that name one of those records* (computed; not a link): `never-leaving-a-guard`

## 21 November, a future opening or closing: reader courses-still-open

*As "JointKeeping.lean: Keepable and its laws". A reader's return, unchecked; what the note mended is in the note: [note](../../read-a-future-2026-11-21/NOTE.md), [report](../../read-a-future-2026-11-21/read-courses-still-open.md.txt).*

- **what stands for what can go on after**: Keepable P g s := ∃ r, r.state 0 = s ∧ ∀ n, g (r.state n) (91): some run from s stays within the guard.
- **laws concluding an opening**: Keepable.mono (99), across guards. Keepable is got from a family that keeps moving within finitely many configurations (docstring, via Onward). Nothing found along a course.
- **laws concluding a closing**: - Keepable.each (115): keepable together gives keepable each; the converse fails in the built example ChoicePoint.each_not_joint (218). - kernel_and_iff (64) and kernel_allOf_iff (75), exact. - keepable_and_iff_of_kernel_left/right (121, 127). - Built examples: no_rule_decides_joint (291), no_respecting_rule_decides_joint (314), keptFor_each_not_joint (366).
- **forms changing while it continues**: Built example kept_part_not_renewal (396): from one configuration one run renews and another consumes, and the sustaining formation ends. This is a difference of courses, not change while continuing.
- **from where an opening comes**: Not applicable.
- **a way related to widening**: Not found in what was read.

## 21 November, a choice made from a reading: reader keeping-through-what-is-registered

*As "JointKeeping.lean: Keepable, Keepable.each, keepable_and_iff_of_kernel_left/right, KeptFor.guard_mono, KeptFor.each, ChoicePoint.no_rule_decides_joint, no_respecting_rule_decides_joint, keptFor_each_not_joint". A reader's return, unchecked; what the note mended is in the note: [note](../../read-a-choice-from-a-reading-2026-11-21/NOTE.md), [report](../../read-a-choice-from-a-reading-2026-11-21/read-keeping-through-what-is-registered.md.txt).*

- **what is read, and what chooses from it**: Statements read. Keepable (91) means some single run from s stays within the guard for ever; there is no reading. The KeptFor laws carry Keeping's reading of steps. The 'rules' F in no_rule_decides_joint read the separate keepability answers, not states.
- **the exact law**: KeptFor.guard_mono (136): a wider guard is kept wherever a narrower one is, for n steps. KeptFor.each (146): kept for both guards gives kept for each. Keepable.each (115) holds in that direction only. keepable_and_iff_of_kernel_left/right (121, 127) are exact where one guard lies in the kernel; no KeptFor analogue of them was found in what was read.
- **within one reading**: Built case keptFor_each_not_joint (366): for every sense, the class {split} is kept for each guard at every n, and for both together not for 1 step, whatever moves are allowed. It concerns two guards, not states alike in a reading. Built cases no_rule_decides_joint (291) and no_respecting_rule_decides_joint (314): no F of the separate answers decides the joint one.
- **two readings of one process**: Not found in what was read.
- **when a reading tells apart, and what can still be kept**: Not found in what was read.
- **the lock as a case**: Not found in what was read.

## 22 November, every module by fifteen questions

*pass a: reader whole-a-08, as "JointKeeping.lean: kernel_allOf_iff, ChoicePoint.joint_differs, Renewable.kept_part_not_renewal" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-08.md.txt)); pass b: reader whole-b-31, as "JointKeeping.lean: Viability.kernel_and_iff, kernel_allOf_iff, Keepable, Keepable.each, keepable_and_iff_of_kernel_left, KeptFor.guard_mono, ChoicePoint.each_not_joint, ChoicePoint.no_rule_decides_joint, Renewable.kept_part_not_renewal" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-31.md.txt)); the third pass, where the two differed: reader whole-c-settle-11, as "JointKeeping.lean: settled fields rank, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-11.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For any process, the kernel of a finite conjunction equals the intersection of the guards' kernels (kernel_allOf_iff, l. 75), and existential joint keepability implies each separate keepability (Keepable.each, l. 115). B: ChoicePoint.joint_differs (l. 231) gives two starts with identical separate answers and opposite joint answers.
  - *pass b:* The module gives general laws. Under every course (Kernel), a conjunction or list of guards is kept exactly where each is. Along some course (Keepable), keepable together gives keepable each, and where one guard is in the kernel, keeping both is keeping the other. Built: on ChoicePoint each of two guards is keepable and both together are not, and no rule on the separate answers decides the joint one; in Renewable a guard kept under every course decides neither renewal nor what the run does to others.
- **moves**
  - *pass a:* S: KeptFor.each (l. 146) carries joint finite-horizon keeping to each guard under the same observation and allowed moves. B: ChoicePoint.keptFor_each_not_joint (l. 366) keeps each for every horizon with unrestricted moves but cannot keep both for one step under any allowance.
  - *pass b:* S: `Keepable` (l. 91): some run from s stays within the guard. `Keepable.each` (l. 115). `keepable_and_iff_of_kernel_left` (l. 121) and `_right` (l. 127). `KeptFor.guard_mono` (l. 136): with allowed moves, a wider guard is kept wherever a narrower one is. B: `ChoicePoint.each_not_joint` (l. 218) and `keptFor_each_not_joint` (l. 366): from split, each guard is keepable by one choice, both by none.
- **a reading**
  - *pass a:* B: ChoicePoint.decisions_exist and no_rule_decides_joint (ll. 264, 291) prove actual Boolean decisions exist, yet no function of the two correct separate decisions yields the joint decision everywhere.
  - *pass b:* B: `ChoicePoint.no_rule_decides_joint` (l. 291): for every F : Bool -> Bool -> Bool and every decision of the three keepabilities, the joint decision is not F of the separate ones. `no_respecting_rule_decides_joint` (l. 314). `decisions_exist` (l. 264).
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a level that runs down**
  - *pass a:* B: Renewable.kept_part_not_renewal (l. 396) distinguishes renewal and consumption along runs from one start and concludes inactivity of the sustaining formation on the consuming tail. It gives no amount-dependent refill rule.
  - *pass b:* B: `Renewable.kept_part_not_renewal` (l. 396): from the starting configuration, one run (beyondRenewal) is ConsumingIn for the focal formation and the sustaining formation is inactive from step 1. The level is in the imported Renewable model.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a point of no return**
  - *pass a:* B: ChoicePoint.each_not_joint (l. 218) concludes no run keeps both from split. Renewable.kept_part_not_renewal (l. 396) concludes persistent inactivity of sustaining from time one on the specified consuming run.
  - *pass b:* B: `Renewable.kept_part_not_renewal` (l. 396): along beyondRenewal the sustaining formation is not active at every t >= 1, and its activity guard is keepable but not in the kernel. This is taken from the imported `class_belongs_to_the_run`. `ChoicePoint.split_leaves` (l. 213): every step from split leaves one condition, and left and right stay at themselves by the definition of `next`.
- **both outcomes**
  - *pass a:* S: keepable_and_iff_of_kernel_left (l. 121) makes joint keepability exactly keepability of the other guard when the first lies in the kernel at the start. B: Renewable.kept_part_not_renewal (l. 396) exhibits renewal and consumption in one process from the same start.
  - *pass b:* B: `Renewable.kept_part_not_renewal` (l. 396): from one configuration one run renews (RenewingIn) and another consumes; built.
- **a comparison between two**
  - *pass a:* S: Keepable.mono (l. 99) transfers an infinite keeping run to every wider guard, and KeptFor.guard_mono (l. 136) does so for finite horizons with the same moves and sensing.
  - *pass b:* S: `Keepable.mono` (l. 99) and `KeptFor.guard_mono` (l. 136) carry keeping from a narrower guard to a wider one. B: `ChoicePoint.joint_differs` (l. 231): two configurations agree on the separate answers and differ on the joint one.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* B (weaker: a one-step loss in a built case, no rank that falls): `ChoicePoint.keptFor_each_not_joint` (l. 366), for every `sense`, states that `(· = .split)` is `KeptFor` `first` and for `second` for every `n`, and `∀ allowed, ¬ KeptFor process sense both allowed 1 (· = .split)`; `split_leaves` (l. 213) states `∀ a t, process.step .split a t → ¬ both t`. So on `ChoicePoint.process` every step from `split` leaves `both` within one step. There is no variant, drain or general law of ending within a bound in the module. [which pass was right: both in part; opened: ChoicePoint.split_leaves l.213; each_not_joint l.218; keptFor_each_not_joint l.366; KeptFor.guard_mono l.136; ChoicePoint.next l.166; process l.174]
  - *pass a:* B: ChoicePoint.keptFor_each_not_joint (l. 366) gives a one-step deadline for loss of the conjunction from split.
  - *pass b:* N.
- **a closed region**
  - *pass a:* S: kernel_and_iff and kernel_allOf_iff (ll. 64, 75) give exact intersection laws for regions safe under all courses.
  - *pass b:* S: `kernel_and_iff` (l. 64): Kernel of a conjunction iff Kernel of each. `kernel_allOf_iff` (l. 75), for lists. B: `ChoicePoint.first_closed` (l. 327) and `second_closed` (l. 346), via keptFor_of_closed. The kernel conjunct of `kept_part_not_renewal` (l. 396).
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* B (weaker: one formation stays active while another ends; no relay, nothing new forms): `Renewable.kept_part_not_renewal` (l. 396) states, with no premise, `Kernel process (fun s => conditions.active s .focal) (withinRenewal.state 0)`, `withinRenewal.state 0 = beyondRenewal.state 0`, `RenewingIn (conditions.along withinRenewal) .focal`, `ConsumingIn (conditions.along beyondRenewal) .focal`, `∀ t, 1 ≤ t → ¬ conditions.active (beyondRenewal.state t) .sustaining`, and that the sustaining formation's activity is `Keepable` there and not in the `Kernel`. So on the consuming run the focal formation is active at every step while the sustaining one is not from step 1; no statement says a form comes, alternates, or that more can go on after. [which pass was right: both in part; opened: Renewable.kept_part_not_renewal l.396; Keepable l.91; opening account ll.37-45]
  - *pass a:* B: Renewable.kept_part_not_renewal (l. 396) keeps focal activity under every course from the common start while the sustaining formation loses activity on the consuming run.
  - *pass b:* N.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. General statements support states, moves, both_outcomes, comparison, closed_region. Built cases support states, moves, reading, level, no_return, both_outcomes, rank, forms_change. I found no matching statement for share, giving, cost, multiplying. No answer rests on prose alone or was unreached.
  - *pass b:* All answered from statements. Read whole (412 lines, all statements); I opened Viability.lean for Kernel.
