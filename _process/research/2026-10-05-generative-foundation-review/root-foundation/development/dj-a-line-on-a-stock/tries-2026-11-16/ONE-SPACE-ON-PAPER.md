# One space, tried on paper

*AI-written (Fable, holding the design; board row DJ), 16 November 2026, about 15:05 WIB. A working record. Nothing here is proved and nothing is built. Written before any reader of this round; corrections are appended with their date and never overwrite. The page it follows is `tmp/r7/one-model/THE-PICTURE.md`; the six reports it draws on are `tmp/r7/one-model/check/round10/what-the-map-has.json`.*

## What is wanted

Ren, 16 November: the interconnected map that includes the meta-attractor (cancer) and the generative and continuation dynamics, fully connected, with phase transitions, attractors and paths mapped out; no corners cut; no holding on to old words, his or mine.

## What would count as nothing having changed (frozen now, before any reader)

The try counts as something only if all three hold:

1. One theorem whose conditions are on the start, with no course run, gives both fates in the worked case where the higher start ends (`LineOnAStock.HigherStartEnds`: from six it never ends, from seven it ends).
2. A proof older than 12 November 2026 becomes its case and is deleted.
3. The Lean is shorter afterwards.

Also counted as nothing: a space so general that every existing model is a case by renaming (a dictionary); a "case" whose proof is longer than the proof it replaces; a law told in a new vocabulary with no proof deleted.

I expect test 1 may fail, and say so now. Where who is there depends on the level, more level can mean more takers, and the fate is not ordered by the level. If no condition short of running the course decides it, that is a finding about the map (its regions are not all cut by thresholds), and it is kept.

## The guess, in my words (to be attacked)

**The frame is already there.** `TurningInTime.pair` is a way and a level; `AloneOutside` says the level makes a difference to the way only at marked levels; `LineOnAStock.after_alike` says the same of needs. So the levels are cut into bands by the needs and the marks. Inside a band the way runs as it would with no level (`agrees_until_marked`, `ways_alike`, `way_while_met`), and the level follows what the way takes.

**A region** would then be a band together with a class of ways that the way's own step keeps, such that the level's step under every way of the class keeps the band. A course that enters a region never leaves it and never ends, if the band is at or above every need in the class. The root has this notion three times (`«闭»`, `Law.Absorbing`, `Viability.Kernel` with its certificates; `Lasting.avoids_iff_closed`), and the centre proves it again each time (`RegimeMargin.holds`, the right-to-left halves of `TurningInTime.unending_iff_above` and `LineOnAStock.unending_iff_holds`, `RuleCapture.turn_locked` in the way's coordinate alone).

**A transition** would be a crossing of a band's edge. Downward, a need is no longer met or a mark is read: the way changes, the take falls, and where the course goes next is decided by the level just after the crossing (`turns_in_time_iff`, `two_units_iff`). Upward, a need comes to be met: new members act, and the take can rise (the case where the higher start ends).

**A path** would be a sequence of crossings.

**In these terms.** The lock is a class of ways kept by the way's own step (how it selects is closed on itself) in a band with no mark above the need (nothing of the level reaches it). Cancer is that class with a take that grows, in a band whose only lower edge is its own need. A generative region is one whose members give, so that the band is kept by what they give and not by a stock that gives by itself.

**Members that give.** Let a met member also give. Then a stock's own giving that rises with what is left is the giving of members that need that much: every rising giving with nothing from nothing is a sum of gated givers. So "the stock remakes itself" would be a case of "what goes on remakes it", and October's renewer-and-taker law (`deeper/RelationalRenewal.lean`, `RenewalFlow.lean`) would be the case of two kinds with no other giving. A giving with a hump (`Three.giving`, `min z (12 − z)`) is not such a sum.

## What to find out, in this order

1. **Regions.** State the region lemma once, in the frame of `pair` with `AloneOutside`, in the root's language. Which existing proofs are its cases, and which get shorter or go? Does `Viability` or `Lasting` already have it?
2. **Both fates from the start (test 1).** In the worked case, and for ways of finitely many kinds in general: is there a condition on the start that decides the fate without running the course? If not, what is the strongest true statement (a region the start lies in; a first crossing and what it decides), and a small proof or search that no threshold in the level exists?
3. **Crossings.** Is `turns_in_time_iff` the law of a downward crossing between two regions, statable with both regions named? What is the law of an upward crossing?
4. **Giving.** With members that give and no other giving: is nothing-from-nothing a consequence; is October's law a case with a shorter proof; does `rises_by_draw` or `root_mono` already give "a giver lowers the boundary"?
5. **Old proofs.** Which proofs older than 12 November would be deleted, with the line counts (candidates named by the readers: `Founding.Flow.ConfinedRise.ends`; `RelationalRenewal`'s `independent_overdraw_persists` and `below_for_good`; `Optimum.kept_iff_within`; `RuleRebuilding`'s closed regions; `ReadingsSpread.Commons.overdrawn_spreads_then_ends`; `LineageDrawdown.gated_ends`).

## Not in this try

A drawing or a new view of the map (held until Ren has read the design). Any Lean. Any tracked change.

## 16 November, 15:30 WIB (from the clock): the try was run, and it failed all three tests

*AI-written (Fable). Three seats and one refuter, read-only; their reports are `one-space-try.json` beside this file (workflow `wf_e5bd5313-282`), their scripts in the folders beside it. Searches by script are not proofs.*

**Test 1 failed.** In the worked case every way has at most one level from which it never ends (from `[A]`: six only; five and seven both end). Below it the level runs down with no `C` ever met. Above it a `C` comes to be met and the take outruns the level. Six is a balance between two ways of ending, not a region. No threshold, band or half-space on the start sorts the fates. The only start condition that gives both fates is "it is at a fixed going configuration within two steps", which is the course run. The refuter reproduced the table with its own transcription (1,079 starts, 17 never end, no way with two such levels).

**Test 2 failed.** No proof older than 12 November becomes a case. The seven old proofs I named are already short instances of other laws on other carriers; each is a pair only by a dictionary. The one claimed deletion (three October laws through a "phase lemma") was broken by the refuter: the lemma holds only for a taker that needs nothing under a constant net draw, and those laws are used with any need and any schedule.

**Test 3 failed.** At most about twenty lines of 9,819 would go, nearly all from a private lemma written on 15 November. Every new statement lengthens.

**My guess was wrong in these places.**

- *A region is a band with a class of ways.* Too narrow. Regions here are sets of pairs, not products: the smallest ways-by-levels product that is closed and holds `([A], 6)` also holds configurations that end. The course from six goes on with `C`'s need unmet for ever; the class is kept because `C` is not met.
- *The fates are cut by thresholds.* Not in general, even with kids needing no more, taking the same, a rising giving and every need met at the start: with a ceiling of seven, a giving of one from anything positive, and units (need 5, use 2) and (need 1, use 1) each leaving itself, it ends from 5, never ends from 6, and ends from 7. All premises of `two_units_iff` hold there.
- *Members that give bring in the generative half.* For members that are always there, "the stock gives by what is left" and "members give" are one function, so that region is `RegimeMargin`'s holding region renamed. It is new only where givers can stop. A giving with a hump is givers less takers. A member that gives back at least what it takes still raised the boundary in most cases searched. `Relay` refutes "a band each of whose givers needs it".
- *October's renewer-and-taker law is a case.* It reads needs before anything is taken; this month's step takes first. They are one step read half a step apart only for a taker that needs nothing under a standing draw.

**What held, and is new or newly said** (on paper or in search; none built):

- With a step that rises in the level (`z + g z` rising), a way's levels are cut into intervals of one itinerary and one fate, and each cut is a threshold of a composed level map at a need. What fails is one threshold per way, and an order of the fates.
- The starts from which every unit is met at every step are an up-set, in any world with a rising step. One need gives an up-set.
- `Holds` alone is not closed. `Holds` with the level at most `hi` and the regime at the way is closed, under `even`, `some` and `down`.
- The root already has the region lemma (`Lasting.avoids_iff_closed`, `Viability.kernel_iff_certificate`). Using it once would tidy about twenty lines; it is not a join.
- An upward crossing is proved as a fact about the way (`after_length_lt`, `alike_iff`); what it decides for the fate has no law.

**What I take from it.** One more general model is not how these pieces join. Where who is there depends on the level, more can be worse, and which fate a start has is not a matter of a boundary. What stays exact and free of the start is which regions exist, and what a crossing decides. So the next try is not a space. It is the missing links between dynamics that are already there, each as a theorem that names both sides, or a countermodel that shows them apart.
