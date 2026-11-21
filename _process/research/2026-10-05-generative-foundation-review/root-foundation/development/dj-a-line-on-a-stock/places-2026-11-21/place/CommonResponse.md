# CommonResponse

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/CommonResponse.lean`
- *result records that name this place's file as a source* (computed; not a link): `a-response-common-over-a-reading`, `kept-at-the-length-of-a-list`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-reading-kept-by-its-update`

## 21 November, a choice made from a reading: reader response-common-over-a-reading

*As "CommonResponse.lean: «共应», «所闭之承最大», «共应当且仅当所闭之承遍», «自反传递则共应当且仅当承遍», «共应之细», «静之共应当且仅当遍», «一之共应当且仅当一应遍», «依读而应则共应», «遍定应共应当且仅当同读同应», «遍定应共应当且仅当像定后», «映应共应当且仅当同读同应», «共应之例»". A reader's return, unchecked; what the note mended is in the note: [note](../../read-a-choice-from-a-reading-2026-11-21/NOTE.md), [report](../../read-a-choice-from-a-reading-2026-11-21/read-response-common-over-a-reading.md.txt).*

- **what is read, and what chooses from it**: What is read is a supplied relation E on situations (or a map's sameness), and a requirement G a is given for each act. «共应» (line 88) is a family of regions J a: each inside G a, each closed under E, and together covering every situation. It is relational and may overlap, so it is not a rule. A rule appears only as rule : O → A in «依读而应则共应» (205). All statements read.
- **the exact law**: «共应当且仅当所闭之承遍» (153): a common response exists ↔ every situation s has an act a with G a holding throughout the E-closure of s. It is exact for every carrier, reading and requirement, with no choice. «自反传递则共应当且仅当承遍» (164) gives the same along E itself, with premises that E is reflexive and transitive. «依读而应则共应» (205), given meets : ∀ s, G (rule (read s)) s, yields a common response, in one direction only. There are no steps: these are laws of one act, not of keeping over steps.
- **within one reading**: Stated as laws: «一之共应当且仅当一应遍» (194; under the reading that tells nothing apart, on an inhabited carrier, a common response exists ↔ one act meets G everywhere), and «遍定应共应当且仅当同读同应» (248; given covering and exactly one act per situation, a common response exists ↔ situations read alike have the same act). Shown as built cases: «共应之例».EachNotCommon (408) and PairsNotCommon (422).
- **two readings of one process**: «共应之细» (178): a common response over E is one over every E' inside E, with the same J. It runs in one direction. That a finer reading has strictly more is seen only from the extremes «静之共应当且仅当遍» (184) and «一之共应当且仅当一应遍» (194) and from the built cases. No exact statement of what a finer reading keeps more was found in what was read.
- **when a reading tells apart, and what can still be kept**: Not found in what was read; the module has no time or steps.
- **the lock as a case**: The module does not name the lock, a share, a stock, a line or a level that runs down. To read the lock through it, three things would have to be supplied: situations (a class of starts), a reading E, and an act-indexed requirement G. The law would still be about one act, not a course.

## 22 November, every module by fifteen questions

*pass a: reader whole-a-02, as "CommonResponse.lean: «共应当且仅当所闭之承遍», «所闭之承最大», «共应之细»" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-02.md.txt)); pass b: reader whole-b-06, as "CommonResponse.lean: «共应», «所闭之承最大», «共应当且仅当所闭之承遍», «依读而应则共应», «映应共应当且仅当同读同应», «遍定应共应当且仅当像定后», «共应之细»" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-06.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `«共应当且仅当所闭之承遍»` (l. 153) characterizes existence of a common admissible response for any relation and requirement by coverage by the acts’ kernels. `«遍定应共应当且仅当同读同应»` (l. 248) reduces the criterion to agreement of acts on equal readings when there is exactly one admissible act per situation.
  - *pass b:* For every relation E read as a reading on situations and every requirement G (a region for each act), a response common over E within G (regions inside G, closed under E, covering every situation) exists exactly when every situation has an act whose region holds throughout its closure under E; and what holds throughout the closure is the largest region inside P closed under E. These are general laws; the built cases in «共应之例» (NotReflexive, NotTransitive, EachNotCommon, PairsNotCommon, NotCovering, NotOne, OneCarrier) show that each hypothesis is needed.
- **moves**
  - *pass a:* S: `«共应»` (l. 88) specifies an admissible covering family of acts closed under the reading; `«依读而应则共应»` (l. 205) constructs it from a rule meeting the requirement everywhere.
  - *pass b:* S: «共应» (l. 88): acts are an index A with an allowed region G a for each act. A common response is a choice of an act region per situation, closed under the reading, and «共应当且仅当所闭之承遍» (l. 153) says exactly when such a choice exists. There is no Process S A or step in any statement. D: the account (l. 27-28) says that at a process's steps the kernel is Viability.kernel_iff_held, which this module does not state.
- **a reading**
  - *pass a:* S: `«映应共应当且仅当同读同应»` (l. 274) characterizes a common response for an act map by equality of acts wherever the reading agrees.
  - *pass b:* S: the reading is a relation E (l. 88). «依读而应则共应» (l. 205): a rule from what a map read registers that meets G at every situation gives a response common over the map's sameness, with no choice. «映应共应当且仅当同读同应» (l. 274): with an act map, a common response over read's sameness exists exactly when situations read alike get the same act. «遍定应共应当且仅当同读同应» (l. 248) and «遍定应共应当且仅当像定后» (l. 265): with exactly one act per situation, existence holds exactly when the image of the response relation along read has a fixed successor.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no dichotomy of going on and ending, or of keeping and losing. The iff laws (l. 153, l. 164, l. 184, l. 194) say exactly when a common response exists.
- **a comparison between two**
  - *pass a:* S: `«共应之细»` (l. 178) carries any common response to every subrelation of its reading.
  - *pass b:* S: «共应之细» (l. 178): a response common over E is common over every reading E' inside E. «应际同行当且仅当同读同应» (l. 231): on the sum carrier, the response relation goes alike (同行) across the map's sameness exactly when situations read alike have the same act.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* S: `«所闭之承最大»` (l. 142) identifies the largest E-closed subregion of any P by requiring P throughout the closure from the situation.
  - *pass b:* S: «所闭之承最大» (l. 142): for every relation E and region P, «承» along the converse of E's closure lies inside P, is closed under E, and contains every region inside P that is closed under E (the largest closed region). Also «闭在内则在承» (l. 120), with no hypothesis on E. «诸承在内当且仅当自反» (l. 100) and «诸承闭当且仅当传递» (l. 112) give the same along E itself, exactly when E is reflexive and transitive respectively.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, moves, reading, comparison, closed_region. I reached all fourteen questions.
  - *pass b:* All statements and docstrings read (whole file). Answered from statements: states, moves, reading, both_outcomes, comparison, closed_region. The rest are N. Moves also has a D part from the account.
