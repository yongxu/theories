#!/usr/bin/env python3
"""ZG4-ZG6 module text: for each module that gained laws, a bullet in its header, a sentence in its package-root
entry and in its checker scope, and a clause in its README rows (EN, ZH). Each anchor must match once.
usage (from the checkout root): python3 -B docs_zg46.py"""
import re
import textwrap
from pathlib import Path

PKG = Path('experiments/integrated-correction/general-framework/generative-basis/lean/becoming')
D = {
 'FaultEnvelopes': ("**Copied witnesses warrant nothing more.** Where each added witness copies one on the roster, supporting as it supports and inside every fault set it is inside, the certificate is unchanged (`copied_roster_same`; `duplicated_roster_same`, the roster listed twice, its case).",
   "Witnesses copying witnesses on the roster leave the certificate unchanged.",
   "copied witnesses warrant nothing more (`copied_roster_same`, `or_absorbed`; `duplicated_roster_same` its case)",
   "抄录之见证不增保证（`copied_roster_same`、`or_absorbed`；`duplicated_roster_same` 为其情形）"),
 'WitnessRefinementRuns': ("**Copied witnesses change nothing.** Where each added witness copies one on the roster, in its reports, its support and every fault set it is inside, inspection takes the same steps and gives the same certificate (`copied_witnesses_same`; `doubled_roster_same` its case).",
   "Witnesses copying witnesses on the roster change no step of inspection and no certificate.",
   "copied witnesses change no step and no certificate (`copied_witnesses_same`, `witnessed_copy`, `and_absorbed`, `any_congr_on`; `doubled_roster_same` its case)",
   "抄录之见证不改任何检查步骤与证书（`copied_witnesses_same`、`witnessed_copy`、`and_absorbed`、`any_congr_on`；`doubled_roster_same` 为其情形）"),
 'SharedCodes': ("**Synonyms, a coined form, majority and imposing.** A code letting a sense hold several forms reads back exactly where no two senses hold one form (`synonyms_read_iff`; `one_form_reads_iff` the case of one form a sense). Coining a form (`coin`) is the step hearing lacks: a form coined at `m` and heard by all brings back a distinction an imposed code merged (`coined_returns`). Taking what most hold (`majority`) makes no form (`majority_held`); two of three agree at once and one of two rests (`Majority.odd_agrees`, `Majority.even_rests`). Imposing a code keeps every exchange of formations (`impose_keeps_exchange`) and privileges its forms (`impose_privileges_forms`), the symmetry it breaks.",
   "Synonyms do no harm and homonyms do; a coined form brings back a merged distinction; taking what most hold agrees on an odd split and rests on an even one; imposing a code keeps the exchange of formations and privileges forms.",
   "synonyms (`synonyms_read_iff`), coining (`coin`, `coined_returns`), taking what most hold (`majority`, `majority_held`, `Majority.odd_agrees`, `Majority.even_rests`), imposing (`impose_keeps_exchange`, `impose_privileges_forms`)",
   "同义之名（`synonyms_read_iff`）、造形（`coin`、`coined_returns`）、从众（`majority`、`majority_held`、`Majority.odd_agrees`、`Majority.even_rests`）、施加之码（`impose_keeps_exchange`、`impose_privileges_forms`）"),
 'Situations': ("**The move alone underdetermines.** Where a step by `a` from `s` has situations reaching two configurations, the finer law takes both by the same move and no law giving the next configuration from the configuration and the move alone is right on both (`move_underdetermines`): `Confound.misattributes` generalized.",
   "Where a move has two situations, no law from the move alone is right on both.",
   "the move alone underdetermines (`move_underdetermines`)",
   "动作本身不定结果（`move_underdetermines`）"),
 'Junctures': ("**Within the count, and before a juncture.** With every configuration listed and steps decided, what can be had again is had within as many steps as there are configurations (`reach_within_listed`, `leadsWithin_trace`), so a keeping step at a juncture reaches `s` within that count; at a configuration that is not a juncture, no step can be refuted to keep `s` (`keeps_before_juncture`): choosing is needed only at a juncture.",
   "What can be had is had within the count of configurations, and before a juncture no step needs choosing.",
   "reaching within the count (`leadsWithin_trace`, `reach_within_listed`); before a juncture no step needs choosing (`keeps_before_juncture`)",
   "在构形数之内可得（`leadsWithin_trace`、`reach_within_listed`）；机前无须择步（`keeps_before_juncture`）"),
 'Pace': ("**Reading through a pool.** Where the rule reads the fast configuration only through what a pool reads of it, rules part across a reading step only where what the pool reads parts (`rule_through_pool`).",
   "Where the rule reads through a pool, rules part at a reading step only where the pool's reading parts.",
   "reading through a pool (`rule_through_pool`)",
   "经池读取（`rule_through_pool`）"),
 'Exclusion': ("**Division by exclusive footprints.** Where what the formations take from `c` is what the leaves of a realized joint plan draw, the parts' footprints within their whole's and apart, and the root's within what is given, the joint draw is within what is given (`withinJoint_of_plan`, by `distinct_of_nodup`); under balance, with such a division at every step, the level never falls (`level_kept_of_plans`).",
   "Division by exclusive footprints keeps the joint draw within what is given, so under balance the level stands.",
   "division by exclusive footprints (`distinct_of_nodup`, `withinJoint_of_plan`, `level_kept_of_plans`)",
   "以互斥之足迹分（`distinct_of_nodup`、`withinJoint_of_plan`、`level_kept_of_plans`）"),
 'Admission': ("**Support passed on.** In a balanced flow where only active formations give, activity needs support, requirements never loosen and support spells are bounded, support gained at arbitrarily late steps is, not refutably otherwise, gained from givers that themselves gained support after any given step (`Flow.support_passes_on`, with `comes_within_not_not`).",
   "Support gained ever later is passed on by formations that gained it later.",
   "support passed on by later gainers (`Flow.support_passes_on`, `comes_within_not_not`)",
   "支持由后得者传下（`Flow.support_passes_on`、`comes_within_not_not`）"),
 'HexagramPlaces': ("**Censuses and bands.** Every 小象 sentence saying a line is 中 is of a middle place, four other sentences listed apart (`xiaoxiangMiddle_census`); every sentence saying a line's way is spent is of the top place, five others apart (`spent_census`); every sentence of a broken line carrying an unbroken one is of a rise (`riseStatements_agree`); every 彖 中正 is of a middle line in phase (`tuanCentreStatements_agree`); two more place statements agree (`placeStatementsMore_agree`). The bands of the three powers and the heights are two divisions, jointly fixing a place and neither a function of the other, each band spanning one seam (`bands_and_heights`, `neither_function`, `band_seams`, `band_seam_unique`).",
   "The 象 and 彖 sentences on middles, spent tops, rises, 中正 and places are counted against the places; bands and heights are two divisions.",
   "censuses (`xiaoxiangMiddle_census`, `spent_census`, `riseStatements_agree`, `tuanCentreStatements_agree`, `placeStatementsMore_agree`); bands and heights (`bandOf`, `bands_and_heights`, `neither_function`, `band_seams`)",
   "普查（`xiaoxiangMiddle_census`、`spent_census`、`riseStatements_agree`、`tuanCentreStatements_agree`、`placeStatementsMore_agree`）；三才之带与高度（`bandOf`、`bands_and_heights`、`neither_function`、`band_seams`）"),
 'HexagramSequences': ("**One search, one line.** On three lines, a line is the sole one differing from the others exactly where the three are 乾 or 坤 with that line turned (`Trigram.sole_iff_searched`, `Trigram.searched`).",
   "A line of three is the sole one differing exactly where 乾 or 坤 is searched at its height.",
   "one search, one line (`Trigram.flip3`, `Trigram.soleAt`, `Trigram.sole_iff_searched`, `Trigram.searched`)",
   "一索一线（`Trigram.flip3`、`Trigram.soleAt`、`Trigram.sole_iff_searched`、`Trigram.searched`）"),
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
