# ReachedCascade

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReachedCascade.lean`
- *result records that name this place's file as a source* (computed; not a link): `a-cascade-at-the-histories-reached`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-cascade-at-the-histories-reached`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-14, as "ReachedCascade.lean: Turns.acts_alike_along, cascade_through_along, Unreached.not_from" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-14.md.txt)); pass b: reader whole-b-54, as "ReachedCascade.lean: Turns.ReadsOnlyActsAlong, Turns.LawAlikeAlong, Turns.acts_alike_along, Turns.cascade_through_along, Turns.Unreached" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-54.md.txt)); the third pass, where the two differed: reader whole-c-settle-21, as "ReachedCascade.lean: settled fields no_return, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-21.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Turns.acts_alike_along` (l. 87) gives equal act lists at every length for two worlds agreeing on the first k couplings when each subsequent law agrees at the reached history on the pair of couplings. `Turns.Unreached.along` and `not_from` (ll. 129, 134) witness that coupling-independence on reached histories can hold while independence on all lists fails.
  - *pass b:* S: For every `Turns W O A` (members acting in turn, each on its own coupling of the world and on the list of earlier acts): where, from member `k` on, every member gives one act for the couplings of `w` and `w'` at the histories `w` reaches (`Turns.LawAlikeAlong`, l. 58), and the two worlds are alike in the couplings before `k`, the two worlds give the same acts to every member (`Turns.acts_alike_along`, l. 87, `act_alike_along`, l. 99). Where `ReadsOnlyActsAlong k` holds at every world, every selection through the acts is a selection through the first `k` couplings (`Turns.cascade_through_along`, l. 105). One built witness (`Turns.Unreached`) shows that the premise along the run is weaker than `Cascade`'s premise on every list.
- **moves**
  - *pass a:* N: `Turns.act_alike_along` (l. 99) concerns acts determined by a law of couplings and earlier acts. It does not quantify over alternative feasible moves at a state.
  - *pass b:* N: There is no choice among steps. Each member's `law n : O → List A → A` is a function, and the acts are determined by the world (`Turns.acts`, in Cascade).
- **a reading**
  - *pass a:* S: `Turns.cascade_through_along` (l. 105) makes every selection through the first N acts factor through likeness before k if ReadsOnlyActsAlong k holds at every world.
  - *pass b:* S: Each member reads its own coupling and the earlier acts. `Turns.cascade_through_along` (l. 105): given `∀ w, T.ReadsOnlyActsAlong k w`, `Learning.Training.Through (T.AlikeBefore k) (fun w => select (T.acts w N))`, so what the first `k` couplings register decides every selection made through the acts. `Turns.acts_alike_along` (l. 87): under `LawAlikeAlong k w w'` and `AlikeBefore k w w'`, `T.acts w n = T.acts w' n` for all `n`.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: Not found in what was read.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: Not found in what was read.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: Not found in what was read.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: Not found in what was read.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: Not found in what was read.
- **a point of no return**
  - *settled by the third pass:* S, as a premise only: `Turns.LawAlikeAlong` (l. 58) is the definition that for every n with k \<= n, `T.law n (T.coupling n w) (T.acts w n) = T.law n (T.coupling n w') (T.acts w n)`: from member k on, for ever, the coupling makes no difference at the histories w reaches. It is a hypothesis of `acts_alike_along` (l. 87) and `act_alike_along` (l. 99), which with `T.AlikeBefore k w w'` conclude equal acts; no statement concludes a loss that is not regained, and no level or giver is involved. [which pass was right: both in part; opened: ReadsOnlyActsAlong (l. 53), LawAlikeAlong (l. 58), readsOnlyActsAlong_of_from (l. 64), lawAlikeAlong_of_along (l. 70), law_alike_along (l. 76), acts_alike_along (l. 87), act_alike_along (l. 99), cascade_through_along (l. 105), Unreached.law (l. 118), turns (l. 124), along (l. 129), not_from (l. 134); section variable `(T : Turns W O A)` l. 49]
  - *pass a:* S: `Turns.LawAlikeAlong` (l. 58) assumes continued agreement from k onward at reached histories; `act_alike_along` (l. 99) concludes no subsequent act distinguishes the two worlds given earlier coupling agreement. The cutoff is a premise.
  - *pass b:* N: No irreversibility is stated. D: the opening account calls `acts_alike_along` "reach stops along the run". The statement says that from member `k` on, later couplings make no difference to the acts, and that is under a premise about the laws, not a loss that is concluded.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: Not found in what was read. The witness `Turns.Unreached` gives `along` (l. 129) and `not_from` (l. 134), a separation of two premises, not two outcomes.
- **a comparison between two**
  - *pass a:* S: `Turns.acts_alike_along` (l. 87) transfers every act prefix between the two worlds under the pairwise law and pre-k agreement.
  - *pass b:* S: The laws carry agreement between two starts (two worlds). `Turns.acts_alike_along` (l. 87): `LawAlikeAlong k w w'` and `AlikeBefore k w w'` give the same acts at every `n`. `Turns.law_alike_along` (l. 76) is the one-member step. `Turns.readsOnlyActsAlong_of_from` (l. 64): the premise on every list gives it along every world. `Turns.lawAlikeAlong_of_along` (l. 70): `ReadsOnlyActsAlong k w` gives `LawAlikeAlong k w w'` for every `w'`.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: Not found in what was read.
- **a closed region**
  - *settled by the third pass:* S, in a weaker form: `Turns.acts_alike_along` (l. 87): under `along : T.LawAlikeAlong k w w'` and `alike : T.AlikeBefore k w w'`, `T.acts w n = T.acts w' n` for every n; its step is `law_alike_along` (l. 76): equal act lists before member n give member n the same act. This is an invariant (agreement of two worlds' act lists) kept as each member is added, under premises on the pair; it is not a region of configurations closed under a step, a kernel or a fixed point. [which pass was right: both in part; opened: law_alike_along (l. 76), acts_alike_along (l. 87), act_alike_along (l. 99), cascade_through_along (l. 105); the whole module read]
  - *pass a:* S: `Turns.law_alike_along` (l. 76) preserves agreement of the next act from equal act histories under LawAlikeAlong and AlikeBefore; `acts_alike_along` (l. 87) gives equality at every length.
  - *pass b:* N: Not found in what was read.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: Not found in what was read.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration's statement and its docstring where present. General statements answer states, reading, no_return, comparison, closed_region. The remaining fields are N. No question was unreached.
  - *pass b:* I read the whole module, all 139 lines: every statement and its docstring, and `Turns`, `acts`, `AlikeBefore`, `ReadsOnlyActsFrom` (Cascade.lean) and `Learning.Training.Through` (Learning.lean) to understand the names. Answers from statements: states, reading and comparison. Answer from the account only: the D part of no_return. Every other field is N.
