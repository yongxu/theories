# UE15 re-check: how the review's findings were folded

28 October 2026. AI-written re-check for board item UE15; read-only apart from this file. Read: the module (SHA-1 `238d966294ba`), [NOTE.md](NOTE.md) (`5158a9e022a4`), [LANDING.md](LANDING.md), the kit in [kit/](kit/), and the kit's dry run on a mirror of main (scratchpad `ue15mirror`, run at 14:14). The mirror's copy of the kit is byte-identical to `kit/` apart from the study text's placeholder. The folded module's audit (scratch-8) was reproduced in a separate tree with a probe beside it: 59 theorems in 73 declarations for the module and 3 in 3 for the probe, every axiom report empty.

## Verdict

The fold is sound. The new Lean is the review's probe, unchanged in substance and renamed as stated, and every axiom report is empty. Three wordings were checked against the Lean and are exact:
- the numberings wording of `reordering_iff_course`;
- `present_identity_iff` and the persistence laws;
- the claim that `MovedBack`'s footprint is least, which follows from `touches_moved` with `Contains`.

The gap's three routes (a dependence, a touch that does not move, a move later undone) exhaust the ways an exchange between can be joined while what the earlier exchange touched persists. Of the twelve findings, eight are taken exactly and one with a difference that is right apart from one phrase. F2, F5 and F9 were missed in some kit texts or note lines. R1 to R4 are corrections to text only and should be made before landing; R5 to R9 are style, to take or decline at landing. No Lean change is needed.

## Findings

**R1 (O). Moving a relatum and moving it back takes two exchanges, not one.**
*Where.* Header lines 66–67; NOTE lines 11, 14 and 55; the 01 §9.6 reading (texts_ue15.py); the study text's Readings.
*What the texts say.* The converse fails "wherever an exchange between is joined to the earlier one yet leaves what it touched as it was: through a dependence … or by moving it and moving it back". In `MovedBack`, exchange 1 moves the relatum and exchange 2 moves it back: no single exchange does both, and the one joined first does not leave the relatum as it was. The slip is the review's own, in F1's proposed text for NOTE line 14. `present_identity_iff` gives the exact statement: given precedence, presence fails exactly where some exchange between is joined to the earlier one, while persistence compares only the two ends.
*Fix.*
- Header and NOTE 11: "The converse fails wherever what the earlier exchange touched persists while an exchange between is joined to it: one joined through a dependence (`ByDependence…`), or ones that move what it touched and move it back (`MovedBack…`)."
- Readings (NOTE 14, 01, study): "…where an exchange between is joined to it while what it touched persists: through a dependence, through a touch that does not move it, or through a move that a later exchange between undoes."
- NOTE 55: "the gap is every way an exchange between can be joined to it while what it touched persists: a dependence, a touch that does not move it, or a move undone later."

**R2 (O). F2's slogan survives in two chapter texts and in Chinese.**
*Where.* As written on the mirror by texts_ue15.py: 01's open entry on presence in time ("the reorderings are the courses of growth of the order of exchanges") and the UE plan's structural gap ("a world's reorderings of a stretch are exactly the courses of growth of its order of exchanges"). In Chinese, the record's title 世界之重排即生长之历程 and the README.zh row 世界之重排即其交换之序之生长, where 即 says "are".
*Fix.* In 01 and the plan: "the numberings a world's reorderings give a stretch are the orders of birth of the courses of growth of its order of exchanges". In Chinese: 世界之重排作为生长之历程 and 世界之重排作为其交换之序之生长, matching the English "as".

**R3 (O). The record's statement widens the stretch.** The statement in kit/make_records_ue15.py says "give a finite stretch", but the module reads only the first `m` steps, as the record's hypotheses say. Fix: "give its first m steps" (in Chinese, 给其前 m 步).

**R4 (O). Persistence needs the footprint to contain the exchanges.**
*Where.* Three texts state persistence in a sentence that does not say so: NOTE line 11 ("So it leaves every relatum…"), and the root module's bullet and the checker's scope text in integrate_ue15.py ("and then it leaves every relatum it touched as it left it").
*Fix.* "and then, where the footprint contains the exchanges, it leaves every relatum it touched as it left it". The root bullet also cites `persists_of_present_reordering` under "on the world as it is"; add "on the world and on every reordering on which it is present", as the scope text already has.

**R5 (S). F9's wording was not carried through, and one text has a looser variant.** NOTE line 44 and the record's law 13 still say "a link below `j` and below no other exchange of the stretch". The study text's item (4) and the board's history row say "exactly where it is the one link of the stretch", which reads as "the only link in the stretch". Fix: "a link below `j` and a link below no other exchange of the stretch"; and "exactly where the other is the one exchange of the stretch it is linked to".

**R6 (S). F5's old phrase remains in three places.** NOTE line 70 ("their no-decision forms are reachable"), LANDING.md's Decisions ("their forms with no decision reaching the World through the transfer lemmas") and the record's second does-not-show item ("their forms with no decision reach it"). Fix: "three of their forms with no decision are instanced, and `past_every_iff` has none".

**R7 (S). A remark that no declaration states.** Module lines 679–680 and 779–780, and NOTE line 53, say: "Every two … are joined, so the only reordering is the world as it is." This is true, but nothing in the module proves it. Either drop it, or add the probe's `reordering_nil` with its two instances (appendix).

**R8 (S). A docstring that cites the note.** The docstring of `VeeWorld.one_course_two_numberings` (line 935) refers to "law 2", which is the note's numbering. Write "the correspondence of `reordering_iff_course`".

**R9 (S). Small points.**
- The record's first hypothesis lists what needs no hypothesis on the footprint but omits the decisions and presence on the world as it is (`first_of_precedes`, `present_identity_iff`).
- The record's law 16 ("four exchanges each touching only one relatum") can be read as different relata; write "each touching only the relatum 0".
- Header line 29 drops `Footprinted.reorder_determined`, which NOTE line 8 cites.
- Module line 210 runs past the module's line width, and lines 55 and 83–84 are wrapped unevenly.

## F1–F12

| Finding | Folded | Remark |
|---|---|---|
| F1 (E) the gap | with a difference | `present_identity_iff` and `MovedBack` are in the module and every text is reworded; the difference is right, except for one phrase (R1) |
| F2 (O) numberings | partly | taken in the module, note, record statement, 01 row, root bullet, README (EN) and checker scope; missed in 01's open entry, the plan and the Chinese texts (R2) |
| F3 (I) | exactly | |
| F4 (O) | exactly | docstring, header, note and record |
| F5 (O) | partly | the lemma and law 4 are exact; leftovers in R6 |
| F6 (S) | exactly | name, statement and record id |
| F7 (I) | exactly | the counts, 59 in 73, agree everywhere |
| F8 (S) | exactly | |
| F9 (S) | partly | exact in the module; R5 |
| F10 (S) | exactly | |
| F11 (I) | exactly | note, record correspondence, 08 and study |
| F12 (S) | exactly | |

## Appendix: the probe

Built from the package with `python3 -B scratch_build.py <tree> Becoming.ReorderingGrowth Becoming.UE15RecheckProbe`, the tree holding a byte-identical copy of the folded module: 3 theorems in 3 declarations, every axiom report empty.

```lean
import Becoming.ReorderingGrowth

/-! Re-check probe for UE15 (not for landing). -/

namespace Becoming

namespace UE15RecheckProbe

open ReorderingGrowth

variable {X : Type}

/-- Where every two consecutive exchanges of the stretch are joined, the only reordering of the
stretch is the world as it is. -/
theorem reordering_nil {r : Footprinted X} {m : Nat}
    (chain : ∀ t, t + 2 ≤ m → r.Joined t (t + 1)) : ∀ ts, Reordering r m ts → ts = []
  | [], _ => rfl
  | t :: _, ⟨⟨⟨_, bound⟩, _⟩, ⟨apart, _⟩⟩ =>
    absurd (chain t (Eq.subst (motive := fun v => t + 2 ≤ v) (Nat.zero_add m) bound)) apart

theorem byDependence_only : ∀ ts, Reordering ByDependence.world 3 ts → ts = [] :=
  reordering_nil fun t bound => match t, bound with
    | 0, _ => ByDependence.joined_first_middle
    | 1, _ => ByDependence.joined_middle_last
    | k + 2, b => absurd b (Nat.not_le_of_lt (Nat.lt_of_lt_of_le (Nat.lt_succ_self 3) (Nat.le_add_left 4 k)))

theorem movedBack_only : ∀ ts, Reordering MovedBack.world 4 ts → ts = [] :=
  reordering_nil fun t bound => MovedBack.joined t (t + 1) (Nat.lt_trans (Nat.lt_succ_self t) bound) bound

end UE15RecheckProbe

end Becoming
```
