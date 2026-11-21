# Growth

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Growth.lean`
- *result records that name this place's file as a source* (computed; not a link): `comparing-two-courses-on-what-they-admit`, `widening-along-a-reading`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-06, as "Growth.lean: Web.grow_widensAlong_iff, Web.grow_widens_unregistered, Web.attach_widensAlong_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-06.md.txt)); pass b: reader whole-b-23, as "Growth.lean: Web.IncludesAlong, Web.WidensAlong, Web.Growth, Web.grow, Web.grow_widensAlong_iff, Web.grow_widensAlong_iff_new, Web.grow_widens_unregistered, Web.attach_widensAlong_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-23.md.txt)); the third pass, where the two differed: reader whole-c-settle-09, as "Growth.lean: settled fields both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-09.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Web.grow_widensAlong_iff` (l. 171) characterizes widening over a growth by inclusion on old formations together with either strict excess there or admission of a new formation. `Web.attach_widensAlong_iff` (l. 230) gives the exact criterion for a single attachment when old levels agree: the comparison path's new condition reaches its need at some step.
  - *pass b:* The module gives general laws of widening along a reading `e : F → F'` between level paths of two webs. Inclusion composes, and widening composes where the later step widens or the later reading is one to one. For a web grown by new formations N and conditions D, the grown web widens the old exactly where the old levels include and either exceed or admit a new formation at some step; with the old levels kept, it widens exactly where a new formation is admitted, while nothing widens on the old formations.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a reading**
  - *pass a:* S: `Web.grow_widens_unregistered` (l. 199) derives strict widening along the inclusion while neither direction widens on the old formations alone if old levels agree and a new formation is admitted.
  - *pass b:* S: `Web.IncludesAlong` (l. 52) and `Web.ExceedsAlong` (l. 57) read formations of one web in another by `e`. `Web.grow_widens_unregistered` (l. 199): where a growth keeps the old levels and admits a new formation at some step, the grown web widens the old along `Sum.inl`, while on the old formations the levels neither widen nor narrow. So a reading of the old formations alone does not register the widening. `Web.widensAlong_id_iff` (l. 78): along the identity, widening along is `Web.Widens`.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* S: `Web.attach` (l. 215) makes activity of the added formation depend on k≤level t. The level path is supplied, with no law of depletion or return.
  - *pass b:* S, partly: a formation is admitted where the level paths meet its needs (`Web.Admits`, from the imported Regions). `Web.attach_widensAlong_iff` (l. 230): with the old levels kept, attaching one formation by one new condition widens exactly where, at some step, the new condition's level reaches k. N: no law of a level running down; the level paths are given.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: levels are given paths, not given by formations of the model.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: a growth adds a given type N of formations (`Web.Growth`, l. 118); no law of the step changes their number.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *settled by the third pass:* N: `Web.grow_admits_old` (l. 155) states `(W.grow X).Admits (l' t) t (.inl f) ↔ W.Admits (oldLevels l' t) t f`: admission of an old formation at one step is the same in the grown web as by the old levels, an equivalence between two webs and not a pair of outcomes. `Web.attach_widensAlong_iff` (l. 230), under `keep : ∀ t c, m t (.inl c) = l t c`, states widening along `Sum.inl` exactly where `∃ t, k ≤ m t (.inr ())`. The exactly-when statements are of widening or of admission at a step; none is of going on and ending, or of keeping and losing. [which pass was right: b; opened: `grow_admits_old` l. 155, `grow_includesAlong_iff` l. 163, `grow_widensAlong_iff` l. 171, `grow_widensAlong_iff_new` l. 185, `grow_widens_unregistered` l. 199, `attach_widensAlong_iff` l. 230, defs l. 52-61, l. 118-149; variables l. 42, l. 48, l. 152.]
  - *pass a:* S: `Web.grow_admits_old` (l. 155) gives an exact admission test at one time for an old formation after growth. `Web.attach_widensAlong_iff` (l. 230) characterizes widening by a new threshold being met sometime.
  - *pass b:* N for going on and ending. The exactly-when laws `Web.grow_widensAlong_iff` (l. 171) and `Web.grow_widensAlong_iff_new` (l. 185) are about widening.
- **a comparison between two**
  - *pass a:* S: `Web.WidensAlong.comp` (l. 102) composes an earlier widening with later inclusion along a one-to-one later reading. `Web.IncludesAlong.widensAlong_comp` (l. 93) requires no injectivity when the later step is itself a widening.
  - *pass b:* S: `Web.IncludesAlong.comp` (l. 87): inclusion along readings composes. `Web.IncludesAlong.widensAlong_comp` (l. 93): inclusion followed by widening is widening along the composite reading. `Web.WidensAlong.comp` (l. 102): widening followed by inclusion along a one-to-one reading is widening. `Web.grow_includesAlong_iff` (l. 163): inclusion along `Sum.inl` into the grown web is inclusion by the old levels.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* S: `Web.grow_widensAlong_iff_new` (l. 185) says that, with old levels unchanged, growth strictly widens exactly when some new formation is admitted at some time.
  - *pass b:* S: `Web.grow_widensAlong_iff_new` (l. 185): a growth that keeps the old levels widens the old web exactly where some new formation `.inr n` is admitted at some step, so more can go on after. `Web.attach_widensAlong_iff` (l. 230) is the case of one attached formation, whose condition reaches its need.
- **how it was read**
  - *pass a:* S: Read the opening account, all declaration statements and their docstrings. Statements support states, reading, level, both_outcomes, comparison, forms_change. No finding for moves, share, giving, cost, multiplying, no_return, rank, closed_region. All questions reached.
  - *pass b:* All 241 lines were read. reading, level (partly), comparison and forms_change were answered from statements. The rest are N. None was answered from the account alone, and nothing was left unreached.
