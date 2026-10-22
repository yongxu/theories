#!/usr/bin/env python3
"""ZG1-ZG3 module text: for each module that gained laws, a bullet in its header, a sentence in its package-root
entry and in its checker scope, and a clause in its README rows (EN, ZH). Each anchor must match once.
usage (from the checkout root): python3 -B docs_zg13.py"""
import re
import textwrap
from pathlib import Path

PKG = Path('experiments/integrated-correction/general-framework/generative-basis/lean/becoming')
D = {
 'Change': ("**Coming to be of a negation.** What ceases to be is the coming to be of its negation and what comes to be the ceasing of its negation, with no premise (`CeasesToBe.not_comes`, `ComesToBe.not_ceases`); read back, the determination must be stable where it is read (`ComesToBe.of_not`, `CeasesToBe.of_not`); on a web, a formation ceasing is its inactivity coming to be (`Web.ceasing_readings`).",
   "What ceases to be is the coming to be of its negation, and back where the determination is stable.",
   "what ceases to be is the coming to be of its negation (`CeasesToBe.not_comes`, `ComesToBe.not_ceases`, `Web.ceasing_readings`; back where stable, `ComesToBe.of_not`, `CeasesToBe.of_not`)",
   "止息即其否定之生起（`CeasesToBe.not_comes`、`ComesToBe.not_ceases`、`Web.ceasing_readings`；反向须该规定稳定，`ComesToBe.of_not`、`CeasesToBe.of_not`）"),
 'Decidedness': ("**Cases into a stable conclusion.** A conclusion following from a proposition and from its failure holds wherever it is stable, the proposition left undecided (`Decided.cases_stable`): every negation and every equation of numbers is stable.",
   "A conclusion following from a proposition and from its failure holds wherever it is stable, with the proposition undecided.",
   "a stable conclusion follows by cases with the case undecided (`Decided.cases_stable`)",
   "稳定的结论可分情形推出而不判定其情形（`Decided.cases_stable`）"),
 'RelativePosition': ("**Least parts and equal shares.** A least part's amount counted once for each part is at most the family's total (`least_not_ahead`, `least_exists`), so with no more in all and at least `n` parts it is at most the total over `n` (`least_bound`). Equal shares meet every need exactly where they meet the greatest (`equal_share_iff`), giving more than the total need exactly where needs differ (`equal_share_exceeds`, `equal_share_even`); two parts needing one and three are short in equal shares of what suffices by need (`uneven_short`).",
   "A least part is not above the average, and with no more in all more parts leave it no more; equal shares meet every need exactly where they meet the greatest, which gives more than the total need where needs differ.",
   "least parts (`Least`, `least_not_ahead`, `least_exists`, `least_bound`) and equal shares (`equal_share_iff`, `equal_share_exceeds`, `equal_share_even`, witness `uneven_short`)",
   "最小之处（`Least`、`least_not_ahead`、`least_exists`、`least_bound`）与均分（`equal_share_iff`、`equal_share_exceeds`、`equal_share_even`，见证 `uneven_short`）"),
 'Attraction': ("**Entering within the count, and basins.** Within `m` listed configurations every course enters what returns before step `m` (`Law.enters_returning_within`). The courses of two configurations meeting is an equivalence under any determined law (`Law.Meet`, `Law.Meet.trans`): a course reaches every returning configuration of its basin (`Law.Meet.reaches_returning`), so within finitely many configurations each basin holds one cycle (`Law.basin_one_cycle`).",
   "Within m configurations every course enters what returns before step m; courses that meet form basins, each with one cycle where configurations are finitely many.",
   "every course enters what returns within the count of configurations (`Law.enters_returning_within`); courses meeting form basins, each with one cycle (`Law.Meet`, `Law.Meet.trans`, `Law.Meet.reaches_returning`, `Law.basin_one_cycle`)",
   "每一行程在构形数之内入复返之域（`Law.enters_returning_within`）；相会之行程成势，有限时每势一个回环（`Law.Meet`、`Law.Meet.trans`、`Law.Meet.reaches_returning`、`Law.basin_one_cycle`）"),
 'Regulation': ("**Beyond the gap, and local regulation.** With balance, a joint exchange beyond the gap leaves the next level off `m`, so overcorrecting at every step never comes to rest at `m` (`Flow.not_at_of_beyond`, `Flow.never_at_of_beyond`). Each formation weakly opposing, some strictly, makes the joint exchange oppose (`Flow.opposes_of_each`), and shares of the gap keep it within (`Flow.withinGap_of_shares`): each formation reads only the condition it exchanges with. Where each condition of a family is so regulated at its own level, the family's stock settles at their total with nothing reading the stock (`Flow.stock_settles`). One side does not restore (`Flow.never_returns_below`, in `Becoming.Continuation`).",
   "Overcorrecting never rests at m; formations each opposing on their own condition make the joint exchange regulate it, and a family whose conditions are each so regulated settles in total with nothing reading the total.",
   "beyond the gap no rest at `m` (`Flow.not_at_of_beyond`, `Flow.never_at_of_beyond`); local regulation (`Flow.opposes_of_each`, `Flow.withinGap_of_shares`, `Flow.stock_settles`)",
   "越出间距则不止于 m（`Flow.not_at_of_beyond`、`Flow.never_at_of_beyond`）；局部之调节（`Flow.opposes_of_each`、`Flow.withinGap_of_shares`、`Flow.stock_settles`）"),
 'Tolerance': ("**More tolerance gives no less.** A law keeping inclusion into another keeps it along their courses (`KeepsInclusionInto.course`; `KeepsInclusion.course` its case); the tolerating law keeps inclusion into any tolerating more (`tolerating_into`), so for the same waits and start a formation giving under it gives under every law tolerating at least as much, at every step (`tolerating_mono`).",
   "More tolerance gives no less at every step, for every structure of waiting.",
   "more tolerance gives no less (`KeepsInclusionInto`, `KeepsInclusionInto.course`, `tolerating_into`, `tolerating_mono`)",
   "容忍更大者给予不少（`KeepsInclusionInto`、`KeepsInclusionInto.course`、`tolerating_into`、`tolerating_mono`）"),
 'Significance': ("**Rivals of a formed boundary, and a rule bounded in time.** A rule holding exactly within a region accepts the continuation condition's rule there and is not it where something lies outside (`rival_of_outside`; `bounded_rival` its case); a rule bounded in time (`boundedInTime`) is such a rival (`bounded_in_time_rival`). In the clearer's witness, caring for the first two steps only, the clearer's part loses nothing, while under the continuation condition it loses the dweller (`Clearing.time_bounded_permits`).",
   "A rule bounded in time is a rival of the continuation condition, and in the clearer's witness it permits what the condition counts as a loss.",
   "rivals of a formed boundary (`rival_of_outside`), bounded in time (`boundedInTime`, `bounded_in_time_rival`, `Clearing.time_bounded_permits`)",
   "成界之对手（`rival_of_outside`），以时为界者（`boundedInTime`、`bounded_in_time_rival`、`Clearing.time_bounded_permits`）"),
 'Copying': ("**Copying `b`-fold.** Where every unit draws `d` and becomes `b`, `n` rounds from `k` units run exactly where the stock covers `d` times what they draw for, ending with `k * b ^ n` units (`copying_iff`, `copying_runs`, `requiredBy_add`); doubling is the case `b = 2` (`doubling_iff`); one teaching ten, five rounds give a hundred thousand from a stock of 11,111 (`tenfold`).",
   "Copying b-fold runs exactly where the stock covers what it draws for, doubling its case.",
   "copying `b`-fold (`copying`, `requiredBy`, `requiredBy_add`, `copying_iff`, `copying_runs`; doubling its case; witness `tenfold`)",
   "b 倍抄录（`copying`、`requiredBy`、`requiredBy_add`、`copying_iff`、`copying_runs`；倍增为其情形；见证 `tenfold`）"),
 'Continuation': ("**Far conveying, and one side.** Balanced and dissipated on across `N` steps, each conveying from a member of the family, the family's stock falls by at least `N`, so from a stock of `S` at most `S` stages are conveyed (`Flow.conveyed_loses`). With balance, a joint exchange giving no more than it takes below `m` holds a level below `m` there, never returning to `m` (`Flow.held_below`, `Flow.never_returns_below`); gated renewal is the case where nothing is given below `m` (`Flow.given_zero_below`, `Flow.stays_below`).",
   "Conveying runs a family down by a step for each stage; regulation from one side holds a level from that side only, gated renewal its case.",
   "far conveying runs the family down (`Flow.conveyed_loses`); one side does not restore (`Flow.held_below`, `Flow.never_returns_below`, `Flow.given_zero_below`)",
   "远输使族逐程耗减（`Flow.conveyed_loses`）；单侧不复原（`Flow.held_below`、`Flow.never_returns_below`、`Flow.given_zero_below`）"),
 'Admission': ("**A need with a cap, and no arising without change.** Levels keep a formation within its band where each required condition stands between its need and its cap (`Web.FitsBand`); with balance the band is exact on both sides, the part opening it from below by giving and closing it from above by giving beyond the margin to the cap (`Flow.fitsBand_iff_within_margins_at`). A formation active exactly where supported does not arise across a step at which what it reads does not change (`Web.not_arises_of_unchanged`).",
   "A need with a cap is harmed by too much as by too little, the band exact on both sides; what does not change gives no arising.",
   "a need with a cap (`Web.FitsBand`, `Flow.fitsBand_iff_within_margins_at`); no arising without change (`Web.not_arises_of_unchanged`)",
   "带上限之需（`Web.FitsBand`、`Flow.fitsBand_iff_within_margins_at`）；不变则无生起（`Web.not_arises_of_unchanged`）"),
 'Interleavings': ("**Shared relata need not commute.** Two exchanges sharing their relatum, taken in two orders from one configuration, can reach different configurations (`Shared.order_matters`): the condition of `act_comm` cannot be dropped.",
   "Exchanges sharing a relatum need not commute.",
   "exchanges sharing a relatum need not commute (`Shared.order_matters`)",
   "共享关系项之交换不必可交换（`Shared.order_matters`）"),
 'Learning': ("**Read off the map.** What matters goes alike across a map's lumping exactly where it is read off the map (`through_iff_reads`), so some selection through the map selects it exactly where the map reads it (`selects_right_iff`).",
   "A selection through a map can be right exactly where what matters is read off the map.",
   "going alike across a lumping is being read off the map (`through_iff_reads`, `selects_right_iff`)",
   "跨象一致即由象读出（`through_iff_reads`、`selects_right_iff`）"),
 'Frequency': ("**Repeated disturbance.** With the part giving gaps at most `E` at the steps a schedule marks, the carried amount is at most `(D + E * d) * (1 + M) ^ a`, `d` the disturbed steps and `a` the coupling steps (`carried_le_disturbed`; `carried_le_count` the case of none).",
   "Repeated disturbance adds what the later couplings multiply, the undisturbed rate its case.",
   "repeated disturbance (`carried_le_disturbed`, `carriedGive_with_gaps`, `count_step`; `carried_le_count` its case)",
   "反复扰动（`carried_le_disturbed`、`carriedGive_with_gaps`、`count_step`；`carried_le_count` 为其情形）"),
 'Wholes': ("**Lasting parts carry a whole.** Where from `T` on a part arises within every `d` steps and each arising part lasts `d` steps, the whole is active at every step from `T + d` on (`Whole.persists_of_arising`, `Whole.persists_from`): the converse of `Whole.arises_within`, needing the parts to last (`Gaps` fails without it).",
   "Parts arising within every d steps and each lasting d steps carry the whole.",
   "lasting parts carry a whole (`Whole.persists_of_arising`, `Whole.persists_from`)",
   "持续之部分承整体（`Whole.persists_of_arising`、`Whole.persists_from`）"),
 'Reserve': ("**Dormancy over a stretch, and final ending.** The decay and ending laws need their premises only over the stretch (`decays_by_on`, `ends_within_on`; the from-`S` forms their cases). An ending that is final stays whatever support returns (`ended_for_good`), so a return later than the reserve finds none (`late_return_finds_none`), while a reserve spanning the gap bridges it (`Bridged.bridged`).",
   "Bounded dormancy needs its premises only over the stretch; a final ending stays, so a return later than the reserve finds none.",
   "dormancy over a stretch (`decays_by_on`, `ends_within_on`), final ending (`ended_for_good`, `late_return_finds_none`), witness `Bridged.bridged`",
   "一段上之休眠（`decays_by_on`、`ends_within_on`），终局之终结（`ended_for_good`、`late_return_finds_none`），见证 `Bridged.bridged`"),
 'Evolution': ("**Drift along a lineage.** Along a lineage each member depending on `c` with its need not rising until it gives, transmission within `δ` keeps the need after `i + 1` descents within the founder's need, or the condition's level where the founder was supported, plus `(i + 1) * δ` (`Flow.transmitted_along`, `Flow.transmitted_along_supported`).",
   "Along a lineage need drifts at most δ a generation.",
   "drift along a lineage (`Flow.transmitted_along`, `Flow.transmitted_along_supported`)",
   "世系上之漂移（`Flow.transmitted_along`、`Flow.transmitted_along_supported`）"),
}

def wrap(text, first, rest, width=100):
    lines = textwrap.wrap(text, width=width - len(rest), break_long_words=False, break_on_hyphens=False)
    return first + lines[0] + '\n' + ''.join(rest + l + '\n' for l in lines[1:])

root = (PKG / 'Becoming.lean').read_text(encoding='utf-8')
chk = (PKG / 'check_becoming.py').read_text(encoding='utf-8')
rd = (PKG / 'README.md').read_text(encoding='utf-8')
zh = (PKG / 'README.zh.md').read_text(encoding='utf-8')
missing = []
for mod, (head, rootline, readme, readme_zh) in D.items():
    p = PKG / 'Becoming' / f'{mod}.lean'
    s = p.read_text(encoding='utf-8')
    i = s.index('-/')
    s = s[:i].rstrip('\n') + '\n' + wrap(head, '* ', '  ') + s[i:]
    p.write_text(s, encoding='utf-8')
    # root entry: append before the next bullet
    start = root.index(f'* `Becoming.{mod}` (')
    nxt = root.index('\n* `Becoming.', start + 1)
    entry = root[start:nxt].rstrip('\n')
    new_entry = entry + '\n' + wrap(rootline, '  ', '  ')
    root = root[:start] + new_entry.rstrip('\n') + root[nxt:]
    # checker scope
    m = re.search(rf'^    "{mod}: ', chk, re.M)
    if m:
        after = re.search(r'^    "[A-Z][A-Za-z]+: ', chk[m.end():], re.M)
        pos = m.end() + after.start()
        prev_line_end = chk.rindex('\n', 0, pos - 1)
        assert chk[pos - 3:pos - 1] == ' "', (mod, chk[pos - 6:pos])
        chk = chk[:pos] + f'    "{rootline} "\n' + chk[pos:]
    else:
        missing.append(('scope', mod))
    # READMEs
    for name, text, clause in (('README.md', rd, readme), ('README.zh.md', zh, readme_zh)):
        key = f'[`Becoming.{mod}`](Becoming/{mod}.lean) |'
        lines = text.split('\n')
        hits = [k for k, l in enumerate(lines) if key in l]
        if len(hits) != 1:
            missing.append((name, mod, len(hits)))
            continue
        l = lines[hits[0]]
        assert l.endswith(' |'), (name, mod)
        sep = '；' if name == 'README.zh.md' else '; '
        lines[hits[0]] = l[:-2] + sep + clause + ' |'
        if name == 'README.md':
            rd = '\n'.join(lines)
        else:
            zh = '\n'.join(lines)
(PKG / 'Becoming.lean').write_text(root, encoding='utf-8')
(PKG / 'check_becoming.py').write_text(chk, encoding='utf-8')
(PKG / 'README.md').write_text(rd, encoding='utf-8')
(PKG / 'README.zh.md').write_text(zh, encoding='utf-8')
print('missing', missing)
