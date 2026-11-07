#!/usr/bin/env python3
"""RV round-1 fixes from the folders reader and the Chinese reader. Each old string must occur once."""
import json, re
WT = '/Users/ren/tmp/rv/wt'
def edit(path, pairs):
    p = f'{WT}/{path}'; s = open(p, encoding='utf-8').read()
    for a, b in pairs:
        assert s.count(a) == 1, (path, s.count(a), a[:90])
        s = s.replace(a, b, 1)
    open(p, 'w', encoding='utf-8').write(s)

# --- the banners, rebuilt (line 2 of each folder README) ---
design = {'wamotopia-and-the-wamo-protocol', 'evolving-community-swarms', 'human-solutions-museum', 'the-fork-and-cooperative-infrastructure',
          'architecture-for-a-living-earth'}
renamed = {'alignment-selection-on-cognition', 'drives-narrative-attractors-and-mind', 'jian-and-wenyan-as-formal-language',
           'the-fork-and-cooperative-infrastructure', 'wamotopia-and-the-wamo-protocol', 'relational-self-and-datong'}
dates = {'alignment-selection-on-cognition': '29 September 2026', 'relational-self-and-datong': '4 October 2026'}
views = {
 'meta-attractor': "Its inventory and assessment (the paragraph beginning \"Historical inventory\") is its view as of 8 October 2026, not the "
                   "live account's; the dated paragraphs above it, from 8 to 26 October and revised on 3 and 4 November, restate results "
                   "where they say \"on the spine\" and link their records, which state them.",
 'jian-and-wenyan-as-formal-language': "Its own assessments of standing and readiness are its view as of 25 September 2026 in the body and of "
                   "6 October 2026 in the three dated paragraphs above it, not the live account's.",
}
import subprocess
slugs = sorted(p.split('/')[1] for p in subprocess.run(['git', '-C', WT, 'ls-files', 'theories/*/README.md'], capture_output=True, text=True).stdout.split()
               if p.count('/') == 2 and not p.startswith('theories/becoming/'))
assert len(slugs) == 16, slugs
for slug in slugs:
    path = f'theories/{slug}/README.md'
    lines = open(f'{WT}/{path}', encoding='utf-8').read().split('\n')
    assert lines[0].startswith('<!-- Banner of 7 November 2026 (RV)') and lines[1].startswith('> ') and lines[2] == '', slug
    kind = 'An earlier folder' if slug == 'memories-and-working-style' else 'An earlier theory folder'
    view = views.get(slug, f"Its own assessments of standing and readiness are its view as of {dates.get(slug, '25 September 2026')}, not the live account's.")
    banner = (f"> {kind}, first written before the live account, [the theory of becoming](../becoming/ONE-PAGE.md). {view} "
              + ("Where it names `becoming`, it means that folder as it stood then, named `shengsheng-buxi-generative-existence` until a "
                 "rename of 9 October 2026. " if slug in renamed else '')
              + ("[Chapter 5](../becoming/chapters/05-COLLECTIVES.md#11-joint-plans-and-applications) counts it among applications "
                 "elsewhere: design programmes, not results; correspondence not established. " if slug in design else '')
              + f"What became of its claims is in [the crosswalk](../becoming/results/atlas/CROSSWALK.md#cxg-{slug}), where every entry "
              "is an AI reading with no person's behind it and not carried is an outcome, not a defect; [the index](../README.md) "
              "lists the sixteen earlier folders.")
    lines[1] = banner
    open(f'{WT}/{path}', 'w', encoding='utf-8').write('\n'.join(lines))

# --- locators the first pass missed ---
edit('theories/becoming/results/atlas/entries/correspondence_groups.json', [
 ('README.md, in full (all 1,253 lines)', 'README.md, in full (all 1,256 lines)'),
 ('drives-narrative-attractors-and-mind/README.md, all 566 lines', 'drives-narrative-attractors-and-mind/README.md, all 569 lines'),
 ('human-solutions-museum/README.md (all 509 lines)', 'human-solutions-museum/README.md (all 512 lines)'),
 ('jian-and-wenyan-as-formal-language/README.md, all of it (1-1300)', 'jian-and-wenyan-as-formal-language/README.md, all of it (1-1303)'),
 ("In Ren's own words) and 1144-end: headings", "In Ren's own words) and 1147-end: headings"),
 ('(the only file in the folder), all 567 lines', '(the only file in the folder), all 570 lines'),
 ('spirit-space-token-and-yi-substrate/README.md (all 930 lines)', 'spirit-space-token-and-yi-substrate/README.md (all 933 lines)'),
])

# --- the index: lead, trust sentence, foot, counts from the groups ---
edit('tools/research/atlas.py', [
 ("FOLDERS_LEAD = ('The sixteen folders beside `becoming/` hold", "FOLDERS_LEAD = ('The {n} folders beside `becoming/` hold"),
 ("'when it was written, not the live account\\'s, and each folder\\'s README says so in a banner above its text as it was. '",
  "'as of the date its banner gives, not the live account\\'s, and each folder\\'s README says so in a banner above its text as it was. '"),
 ("'crosswalk also reads, from Chinese classical thought to psychology and logic, are in its own table; the originals '\n"
  "                'the folders draw on are in `sources/`.')",
  "'crosswalk also reads, from Chinese classical thought to psychology and logic, are in its own table. The originals the '\n"
  "                'folders draw on are in `sources/`, except the chat logs, memory exports and recorded conversations '\n"
  "                '(`sources/12-`, `13-` and `18-`), which are not published.')"),
 ("    folders = [g for g in groups if g['domain'] == 'earlier-folders']",
  "    folders = [g for g in groups if g['domain'] == EARLIER]"),
 ("    trust = (f' A second critic read {critic[\"sampled\"]} entries drawn at random against both sides; weighted by how many entries '\n"
  "             f'each kind holds, that estimates {est[\"holds\"]}% holding, {est[\"label\"]}% with a label or a target\\'s role wrong and '\n"
  "             f'{est[\"fails\"]}% with a wrong reading over all {critic[\"entries\"]}.') if est else ''",
  "    trust = (f' A second critic read {critic[\"sampled\"]} entries drawn at random, up to {critic[\"per_stratum\"]} from each kind of '\n"
  "             f'verdict, against both sides; weighted by how many entries each kind holds, that estimates {est[\"holds\"]}% holding, '\n"
  "             f'{est[\"label\"]}% with a label or a target\\'s role wrong and {est[\"fails\"]}% with a wrong reading over all '\n"
  "             f'{critic[\"entries\"]} entries, folders and domains together; its fixes are applied, and the other entries were not '\n"
  "             f'read again.') if est else ''"),
 ("           FOLDERS_LEAD + trust, '',", "           FOLDERS_LEAD.replace('{n}', NUMBER_WORDS.get(len(folders), str(len(folders)))) + trust, '',"),
])

# --- the Chinese: 06 §7.3 and its Open item ---
edit('theories/becoming/chapters/06-CLASSICAL-TEXTS.md', [
 ("中华本《变化论》（2026 年 10 月 21 日之本，[全书](../history/THE-THEORY-OF-BECOMING-ZHONGHUA.md)；10 月 23 日移入 history/，其所述由八章承担，此后各章的修订未入其中）以这些名把当时的理论重述一遍：",
  "中华本《变化论》（[全书](../history/THE-THEORY-OF-BECOMING-ZHONGHUA.md)）以这些名把当时的理论重述一遍："),
 ("它还不是以未参与设计之句检验过的文言内核（[§九](#pre-qin)）[AI reading, D62]。\n",
  "它还不是以未参与设计之句检验过的文言内核（[§九](#pre-qin)）[AI reading, D62]。此本书首署 2026 年 10 月 21 日，22 日仍有修订；10 月 23 日移入 history/，其律今由八章陈述（經与每篇之末的对照只见于此本），此后各章的修订未入其中。\n"),
 ("- **中华本之根基。** 它陈述在 World 模型上；规范之章改以根为基后，它须随之改写。",
  "- **中华本之根基。** 它陈述在 World 模型上，已移入 history/；以根为基重写一本古名之论，未做。"),
])

# --- the goal of the Chinese sources ---
p = f'{WT}/_process/goals/chinese-sources-and-becoming.json'
raw = open(p, encoding='utf-8').read(); g = json.loads(raw)
o = g['overview']
o['title'] = {'en': 'Mapping the relational thread in Chinese thought onto the spine', 'zh': '中国思想中的关系之线，逐段对应到脊柱'}
def sub(field, lang, pairs):
    s = o[field][lang]
    for a, b in pairs:
        assert s.count(a) == 1, (field, lang, a[:60]); s = s.replace(a, b)
    o[field][lang] = s
sub('summary', 'en', [
 ("Gaps the map found are being proved in the core:", "Most gaps the map found are proved in the core:"),
 ("and the four earlier Chinese chapters keep only", "and the four earlier Chinese chapters (in history since 23 October 2026) keep only"),
 ("and the theory as it stood on 21 October 2026 was stated in them in the 中华本《变化论》, with 經, 說 and 證 for each law (in history since 23 October 2026, the eight chapters carrying what it states).",
  "and the theory as it stood on 22 October 2026 (the book dated 21 October) was stated in them in the 中华本《变化论》, with 經, 說 and 證 for each law (in history since 23 October 2026, its laws now stated by the eight chapters)."),
])
sub('summary', 'zh', [
 ("相合是说脊柱有一条结构相同的律，常常只在读法所写明的前提下，不是说原文如其所说为真，或其作者意谓此律。关系性的起点在诸线中都成立",
  "相合是说脊柱有一条结构相同的律（常常只在读法所写明的前提下），不是说原文如其所说为真，或其作者意谓此律。关系的起点在诸线中都成立"),
 ("对应所发现的缺口正在核心中证明：", "对应所发现的缺口，多已在核心中证明："),
 ("较早的四个中国章节只保留", "较早的四个中国章节（10 月 23 日移入 history/）只保留"),
 ("理论以这些名写成中华本《变化论》（2026年10月21日之本，10月23日移入 history/，其所述由八章承担），每条律有经、说、证。",
  "理论以这些名写成中华本《变化论》（书首署2026年10月21日，22日仍有修订；10月23日移入 history/，其律今由八章陈述），每条律有经、说、证。"),
])
o['next_step']['en'] = ("Review by people, the line's last step: the classifications, mappings, readings, names and the census's choices are all AI's, "
  "and no person has read them through. Two gaps stay open: the Hall-type existence condition for division across several conditions (分), of "
  "which a sufficient condition is proved, and a law grading by the least closure level from a centre, with whether that order is the same from "
  "every standpoint (亲亲之杀; the map's correspondence marks it a note of scope, and no law yet). Tolerance compared across laws (柔弱者生之徒) is "
  "proved on both sides proposed (showing only that more tolerance gives no less, not that it is better), and every gap the full reading named is "
  "answered by a law or marked a note of scope. Also open (06's Open): whether the readings fit the texts' history; the 181 later candidates, "
  "untested; what change 穷 → 变 → 通 speaks of; and whether the corpus gives pairing and power.")
o['next_step']['zh'] = ("人审是这条线的最后一步：归类、对应、读法、名与普查之选都是 AI 所为，没有人通读过。两项缺口仍开：跨多个条件之“分”的霍尔型存在条件"
  "（一个充分条件已证），以及从中心按最小闭包层级分等之律及此序是否对每一立场相同（亲亲之杀；《脉络》之对应标为范围之注，尚无律）。跨律比较容忍"
  "（柔弱者生之徒）所拟两面皆已证（只表明容忍较多者给予不少，不表明它更好）；全读所提之缺口，或得其律，或标为范围之注。另有未决（见第六章未决）："
  "读法是否合于史义；后加的 181 条乙类候选尚未检验；“穷 → 变 → 通”所言何变；语料是否给出配对与幂。")
open(p, 'w', encoding='utf-8').write(json.dumps(g, ensure_ascii=False, indent=2) + '\n')

# --- the goal of alignment: 撤下 a draft ---
p = f'{WT}/_process/goals/generative-alignment.json'
raw = open(p, encoding='utf-8').read()
a = "AJ4 面向对齐研究者的一页已于 2026 年 10 月 31 日退下，由对齐档案的开篇一节（The dossier in ten minutes）取代。"
assert raw.count(a) == 1
raw = raw.replace(a, "AJ4 面向对齐研究者的一页草稿已于 2026 年 10 月 31 日撤下，移入 history/，由对齐档案（英文）的开篇一节（The dossier in ten minutes）取代。")
open(p, 'w', encoding='utf-8').write(raw)

# --- the chain: its Chinese lead, nav year, heading, and its scope text in the data ---
edit('tools/research/generative_chain.py', [
 ("本页是一条策展的理论链，共 {total} 条，自 2026 年 10 月 8 日起维护，沿用当时的词汇（如 G0），与现行陈述并列，而不是现行陈述。现行陈述见[一页]",
  "本页是按论证关系选编的一条理论链，共 {total} 条，自 2026 年 10 月 8 日起维护，沿用当时的词汇（如 G0）；它与理论的现行陈述并存，本身不陈述现行理论。理论今陈述于[一页]"),
 ("[10 月 8 日起的章节读法 / Chapter readings", "[2026 年 10 月 8 日起的章节读法 / Chapter readings"),
 ('"## 核心论断 / The central claim"', '"## 本链的核心论断（其时的候选） / The chain\'s central claim (a candidate of its time)"'),
])
edit('theories/becoming/results/data/generativity-chain.json', [
 ("精细章节与声明可由总成果目录继续查阅", "精细章节与声明可由 2026 年 10 月 8 日起的章节读法目录继续查阅"),
])

# --- small lines ---
edit('_process/REPOSITORY-LAYOUT.md', [("The fifteen September branch folders stay in place", "The sixteen September branch folders stay in place")])
print('ok')
