AI-written, 13 November 2026. Second reader of the map card for the dynamic "turning-in-time" (theories/becoming/results/map/cards.json in /Users/ren/tmp/tt/wt). I read it against TurningInTime.lean (header and the named statements and docstrings, namespace Three), GuardedStep.lean, the atlas entry, its premises and web.json.

## Corrections (four, each the least change)

1. plain_en, the turning clause. As written, "the line never ends exactly where the level one step after the first marked level is at or above that kind's point of no return" is false without turns_in_time_iff's regime premises. A course as it was that is never marked and never falls below the need never ends, yet has no first marked step. The sentence now says "under a standing giving and use from which the course as it was comes to nothing" (this is what short₁, uses₁, below and nothing give, by RegimeMargin.ends_below). It also adds "with one standing use" (uses) and "the need met there and before" (the conjuncts ∀ j < T, need ≤ … and need ≤ (… T).2).
2. plain_en, the marks. "No level ... is marked" said nothing about what a mark is, although AloneOutside is a premise that carries weight in ends_with_net and in every split. The model's description now adds "with marked levels outside which the level makes no difference to the way after a step". "the level as it was" now reads "the level of the course as it was". plain_zh was changed to match, and says no more than the English.
3. misfit (1). "some of them marked, at which the level's difference reaches the way after a step (AloneOutside)" was too strong. AloneOutside only says that outside the marked levels the way after a step is alone of the way; it does not say that a marked level makes a difference. It now reads "outside which the level's difference does not reach the way after a step (AloneOutside)".
4. toEnd_iff, sameness. "the way after a step" became "the way". The class in the statement is sameValue Prod.fst, configurations with one way; the way after a step is what the right-hand side compares, not the sameness.

## Tried to refute and could not

- Built cases against Three. Giving min z (12 − z), use 5 (true) or 3 (false), so H₂ + y₂ = 6. As it was: 9 → 4+4 = 8 → 3+3 = 6 → 1+1 = 2 → 0+0 = 0, as the card says.
  - goes_on: T = 0 (mark 9) leaves 8, and T = 1 (mark 8) leaves 6, both at least 6.
  - turned_and_ends: orbit 3 = (false, 2), and «迭» 4 reaches (false, 0), which conditions nothing. That is two steps after the marked step 2, as said. At (true, 6) the line ends under the class of ways (κ := id) while the net goes on. The non-constancy is Three.line_ends_while_net_goes, as cited.
  - ends_as_it_was: the marks 10..0 hold no level.
- Every law's lean name exists. "exact" is used only for the three iffs (turns_in_time_iff, unending_iff_first_marked, toEnd_iff). The two sufficient laws are implications.
- Each evidence line matches its statement. Each main_ifs id is in the ledger and means the binder it stands for (aloneoutside, unmarked, coupled-need-positive, level-law, renews-at-most, draws-above-renewal, k3-decided, turns, kept, uses, short, meets, keeps, within, uses-along-orbit, start-below-point, as-it-was-ends, level-meets-need, other-kind).
- Each law's then_en and then_zh against its conclusion. turns_in_time_iff: ∃ T with the first marked step, the need met before and at T, and H₂ + y₂ ≤ level at T + 1. unending_iff_first_marked: the next configuration is pair renew left of the orbit at T. ends_with_net: n ≤ s.2, t.1 = orbit alone s.1 n. kind_ends_while_net_goes: «亡» and ∃ v.
- Cast and ties against web.json. The way is pattern, the level is stock, use is drawers ("taken first, as much as there is" is (x − H) + g (x − H)) and giving is renewer. Short and Meets read as in RegimeMargin. The needs tie is net and net_zero. The reaches tie is AloneOutside with "only" and agrees_until_marked up to n with no mark before n. The stretches (needs from pattern, no dependent; reaches into a pattern, which web.json's "can be" leaves open) are named in misfit.
- misfit (3) and (5) against the header: locked_closed, locked_at_class (under the total step), join_is_asItWas, window_is_pair, window_agrees_until_marked, net_zero; underDraws is not identified, and the closed form of T is not stated. misfit (6): the names in GrammarPath and GuardedStep exist (atlas declarations).

## Validator

I imported tools/research/the_map.py read-only, with bytecode writing off. load() returned no errors, validate() returned [], and build() returned an empty error list. git status shows only cards.json modified. No check_becoming.py, render, gate or test suite was run (deliberately deferred to the landing).

## Still doubtful

- turns_in_time_iff's main_ifs leave out nothing (FromNothing), needs (0 < need) and high (x ≤ hi). high is said in then_en. The validator allows a subset, so I left them out.
- toEnd_iff has no run, and one-course is the nearest frame (misfit 4). The marks cannot tell ending where the net ends from ending while it goes on (misfit 4).
- In plain_en, "a standing giving and use" stands for the whole regime set (Short for H₁ and H₂, Meets, Keeps, need ≤ H₂ + y₂, start ≤ hi). The plain sentence still does not list them all.
- misfit (3)'s gloss of "the lock" as "the class of a kind kept as it was" is a reading. Locked is a property of share and rule, closed under the step that reads off the share.
