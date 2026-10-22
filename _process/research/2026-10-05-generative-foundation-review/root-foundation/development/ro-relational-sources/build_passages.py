#!/usr/bin/env python3
"""Build passages.json of board item RO from the five mappers' entries (mappers/<slice>/entries.json),
and preserve the atlas texts they quote. usage: python3 -B build_passages.py [--preserve | --check]

- Each entry is normalized: its tradition into the chapter's sections, its text into a path under
  sources/chinese-classical-texts/ (an atlas text, or a Wikisource page retrieved by
  fetch_wikisource.py), and its atlas ids into {atlas, id} pairs resolved against both atlases.
- The corrections listed in FIXES are applied (each with its reason); every fragment is then checked
  against the preserved text, and every failure is printed.
- With --preserve, the atlas texts quoted are copied from the two archives into
  sources/chinese-classical-texts/<atlas>/ (never over an existing file) and PROVENANCE.json is written.
The mappers' readings are the AI's; this script does not change them, except where FIXES says
(a source, locator or fragments replaced, or a sentence of a reading replaced after review, or, where a later item
proved what an entry computed or its gap named, declarations and records added and the gap marked closed, or, where a
later decision judged the structure an entry reads differently, its kind and its whole reading replaced).
passages.json changes only through FIXES, never in place: a build rewrites the whole file, so an edit made
in place would be lost on the next build. With --check nothing is written: the file is compared with the
build, and differs only where it was edited in place (verify_ro.py runs it)."""
import argparse
import hashlib
import json
import sys
import urllib.parse
import zipfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import verify_ro as V  # noqa: E402

SLICES = ['yi', 'lao', 'ru', 'wen', 'other']
STORE = '/Users/ren/Documents/Codex/2026-10-13/referenced-chatgpt-conversation-this-is-an/outputs'
ATLASES = [
    {'id': 'yidao-v1.3', 'title': '周易易传与道德经体系图 v1.3.0',
     'zip_path': f'{STORE}/周易易传与道德经体系图-v1.3.0.zip',
     'zip_sha256': '4ddc4adb2bb3ed14da4191ef6d81120e836f24a6c3dc4ad48bd09207cfde0413',
     'zip_bytes': 23410000, 'prefix': 'yi-dao-system-v1.3/'},
    {'id': 'atlas-v9.1', 'title': '观其会通 · 中国传统思想研究图谱 v9.1.0',
     'zip_path': f'{STORE}/chinese-thought-atlas-v9.1.zip',
     'zip_sha256': 'bb2929d2e179f6d9dbbc8b4c43f13a9d4be92323c860fe246942b93dc4555f2b',
     'zip_bytes': 78036347, 'prefix': 'chinese-thought-atlas-v9.1/'},
]

ABOUT = {
    'work': ('Chinese classical texts quoted by the passage map of board item RO: the 易传 and its commentaries, the 老子 '
             'with the 王弼, 河上公 and 苏辙 commentaries and the 郭店 and 帛书 witnesses, the 儒家 line from the 论语 to '
             '戴震, the 说文解字 and the 左传 (止戈为武), 庄子 and 玄学, 墨辩 and 名家, 兵家, 法家, 管子 and 鬼谷子, '
             'the Buddhist texts received in China, 嵇康 and 王充.'),
    'edition': ('Two kinds of file. (1) Texts of two atlases built with Codex, each copied byte for byte from the atlas '
                'archive named in `atlases` (the archive member is given per file, with the atlas\'s own record of the '
                'text in `atlas_source`: its title, URL and edition note). The atlases\' texts are electronic '
                'transcriptions: 71 of the 79 from Chinese Wikisource, five from CBETA (the 雜阿含經, 中論, 壇經, '
                '成唯識論 and 華嚴五教章), two from xuges.com (王夫之《周易外傳》) and one checked against a scan of the '
                'National Diet Library (王夫之《思問錄》); the atlases do not claim them to be collated editions, and the '
                'excavated witnesses are the atlases\' transcriptions. (2) Chinese Wikisource pages the atlases do not '
                'hold, at the revisions named per file. Neither kind is collated with a printed edition.'),
    'retrieval': ('Archive members: read on 19 October 2026 from the two archives in the external store, verified by '
                  'their SHA-256 before reading. Wikisource pages: MediaWiki API, action=query, prop=revisions, '
                  'rvprop=ids|timestamp|content, rvslots=main, format=json, formatversion=2, redirects=1, with a user '
                  'agent naming the repository, on 19 October 2026 (fetch_wikisource.py in the RO kit, which never '
                  'overwrites a file).'),
    'forms': {'archive-member': 'The archive member, byte for byte.',
              'api-response': "The API's response body, byte for byte as received."},
    'license': ('The texts are pre-modern and in the public domain. Wikisource\'s punctuation and markup are CC BY-SA '
                '4.0. The five CBETA texts are CBETA\'s digital editions of the 大正藏, kept with attribution under '
                'CBETA\'s terms for non-commercial distribution; the xuges.com and National Diet Library notes are in '
                '`atlas_source`. The atlases themselves were built for this work.'),
    'markup': ('Wikisource wikitext carries character-variant markup, templates and links; a reading strips them '
               '(clean() in verify_ro.py) and keeps the content of {{yw|…}} and {{+|…}}.'),
    'reading_scope': ('Only the passages the map quotes were read closely, each in its chapter; retaining whole texts '
                      'does not imply reading them whole.'),
    'used_by': ['theories/becoming/chapters/CHINESE-SOURCES-AND-BECOMING.md',
                '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ro-relational-sources/passages.json'],
}

OTHER = [  # the other slice, by work
    ('庄子与玄学', ('庄子', '郭象', '裴頠')),
    ('墨家与名家', ('墨', '公孙龙', '惠施')),
    ('兵家、法家与轻重纵横', ('孙子', '吴子', '韩非', '商君', '管子', '鬼谷子')),
    ('佛教', ('阿含', '中论', '唯识', '华严', '坛经', '天台', '般若', '涅槃')),
]

ZHK_WHY = ('ZHK: decision D62 (chapter CIVILIZATION-THOUGHT-AND-BECOMING, section 六) judged the structure this entry reads, read again by the 脉络 map, as exact scope; kind changed from agreement and the reading rewritten to say where the claim holds, from the 脉络 entries')

# Corrections, each with its reason. Keys: entry id; values: the fields replaced.
FIXES = {
    'ru-zhengxuan-ren-zhe-ren-ye': {
        'source': 'wikisource/禮記正義__52.json',
        'fragments': ['人也，讀如相人偶之「人」。以人意相存問之言。'],
        'locator': '《禮記·中庸》「仁者，人也」鄭玄注（《禮記正義》卷五十二）',
        'why': 'the note as it stands in 禮記正義 卷五十二 (the mapper gave it from memory, with 人 unquoted)'},
    'cy-xu-tiyong': {
        'source': 'wikisource/Page_文淵閣四庫全書_0009冊.djvu__162.json',
        'fragments': ['易變易也隨時變易以從道也', '至微者理也至著者', '象也體用一源顯微无間'],
        'why': 'the 四庫 page holding 程頤 易傳序; the page breaks the line after 至著者'},
    'shuowen-wu-zhi-ge-gloss': {
        'fragments': ['楚莊王曰：“夫武，定功戢兵。故止戈爲武。”'],
        'declarations_add': ['Becoming.SharedCodes.written_rests',
                             'Becoming.SharedCodes.resolved_alike_merged',
                             'Becoming.SharedCodes.no_reading_recovers',
                             'Becoming.SharedCodes.omitted_rest',
                             'Becoming.SharedCodes.kept_bars',
                             'Becoming.SharedCodes.added_never_replaced',
                             'Becoming.SharedCodes.Gloss.taken_up_locks',
                             'Becoming.SharedCodes.Gloss.uptake_loses'],
        'records_add': ['a-code-formed-between-formations'],
        'reading_sub': [('没有断言：律不判楚庄王之规范读法无价值，只判它不是字源。',
                         ('写回（SharedCodes）：读法一旦写入后人所读的记录，自下一代起即静止并自我确认（written_rests、Gloss.taken_up_locks）；判定相同的历史被合并，'
                          '后来的记录读不回此前（resolved_alike_merged、no_reading_recovers）；遗漏之下所静止者不是此前记录所判定之义（omitted_rest）。'
                          '只有保留下来的此前记录阻止另一种判定（kept_bars），只增补的记录使判定失去而不被替换（added_never_replaced、Gloss.uptake_loses）：止为足之读仍可读，'
                          '靠的是甲骨金文这些保留下来的此前记录。没有断言：律不判楚庄王之规范读法无价值，只判它不是字源。'))],
        'reading_en_sub': [('and keeps both readings indexed by context since they do not glue.',
                            ('and keeps both readings indexed by context since they do not glue; written back into the records '
                             'later readers learn from, the reading rests at once and confirms itself, and only records kept from '
                             'before (the bone and bronze forms) bar it (SharedCodes: written_rests, kept_bars, '
                             'added_never_replaced).'))],
        'gap_closed': ('SC (Becoming.SharedCodes, record a-code-formed-between-formations, study section 210); the '
                       'statement above is kept as proposed, and where the laws differ from it the record and the study '
                       'section say so (the coupling-closure form proposed for 名无固宜 is false, Path.never_agree).'),
        'why': ('the page quotes with “ ” (the mapper gave 「」); SC: Becoming.SharedCodes proved the code formed '
                'between formations the reading named as a gap; its laws and record added and the sentence that '
                'named the gap replaced (both languages)')},
    'huishi-li-wu': {
        'fragments': ['至大无外，謂之大一；至小无內，謂之小一。', '日方中方睨，物方生方死。', '氾愛萬物，天地一體也。'],
        'why': 'the page writes 无 (the mapper gave 無)'},
    'lao-01-ming-ke-ming': {
        'reading_sub': [('所以“可道者非常道”在“由内部说出”的意义上是定理。',
                         '所以把“可道”读作由内部说出、把“常道”读作每一种模式时，“可道者非常道”与这些定理同构；这一对应是读法，定理本身只说断言族与模式。')],
        'why': 'review: the reading called the line itself a theorem; the theorems are about claim families, and the line corresponds to them under a reading'},
    'hs-39-bu-ke-dan-yu': {
        'reading_sub': [('理论支持第三十九章。', '脊柱的定律与第三十九章相合，与第六、十六章所许诺的不死相分。')],
        'why': 'review: "the theory supports chapter 39" stated as which laws agree with which chapter'},
    'xugua-within-pairs': {
        'declarations_add': ['Becoming.Hexagram.bo',
                             'Becoming.Hexagram.fu',
                             'Becoming.Hexagram.bo_fu',
                             'Becoming.Hexagram.ringRule',
                             'Becoming.Hexagram.waxWane_twisted'],
        'records_add': ['hexagram-arrangements-and-laws'],
        'reading_sub': [('翻转把律倒过来走（reverse_waxWane）。',
                         '它也是读直之环上的移位：各爻上升一位、上爻不变而入初位，一步由剥至复；消息之律上爻入初时变其刚柔，由剥一步至坤，再一步至复（bo_fu，Y5）。翻转把律倒过来走（'
                         'reverse_waxWane）。')],
        'why': 'Y5: 剝窮上反下 is also one step of the straight ring shift, where waxing and waning passes through 坤 (bo_fu)'},
    'xugua-between-pairs': {
        'declarations_add': ['Becoming.Hexagram.RunsOrder',
                             'Becoming.Hexagram.orderNext',
                             'Becoming.Hexagram.orderNext_runsOrder',
                             'Becoming.Hexagram.runsOrder_agrees',
                             'Becoming.Hexagram.runsOrder_lossless_iff',
                             'Becoming.Hexagram.orderNext_one_orbit',
                             'Becoming.Hexagram.runsOrder_reads',
                             'Becoming.Hexagram.runsOrder_blind_not_lumped',
                             'Becoming.Hexagram.ringRule_not_runsOrder',
                             'Becoming.Hexagram.twistedRule_not_runsOrder',
                             'Becoming.Hexagram.waxWane_not_runsOrder',
                             'Becoming.Hexagram.runsOrder_not_commutes',
                             'Becoming.Hexagram.rearrange_not_runsOrder',
                             'Becoming.Hexagram.runsOrder_not_lumped'],
        'records_add': ['hexagram-arrangements-and-laws'],
        'reading_sub': [('计算核对：受传卦序不是任何三格局部规则（256 条，循环或扭转边界）的运行，最多合 9/63 步；也不是任何"置换六位并加掩码"之律（720×64 条）的运行，最好的是翻转，只合 28/'
                         '63 步，恰是对内翻转的那些；对与对之间的过渡改变一到六爻不等。',
                         'Y5 在 Lean 中证明：运行受传卦序之律，除未济一处外都与取每卦至其后一卦之律相同，其中恰取未济至乾者不合并，六十四卦成一轨（runsOrder_agrees、'
                         'runsOrder_lossless_iff、orderNext_one_orbit）；但这样的律每一爻皆读每一爻（runsOrder_reads），所以没有三格局部规则（循环或扭转边界'
                         '，消息之律在内）运行它（ringRule_not_runsOrder、twistedRule_not_runsOrder、waxWane_not_runsOrder）；它不与翻转、全变或'
                         '二者交换（runsOrder_not_commutes），而一切"置换六位并加掩码"之律都与全变交换，所以也没有这样的律运行它（rearrange_not_runsOrder）。脚本另算'
                         '部分相合：三格局部规则最多合 9/63 步；置换加掩码之律最好的是翻转，合 28/63 步，恰是对内翻转的那些；对与对之间的过渡改变一到六爻不等。'),
                        ('这回答 Yi 章 §8 的开放问题：卦序在对间是断言而非导出，只有对内是律。',
                         '这回答 Yi 章 §8 的开放问题，并改正那里“卦序本身不是任何律的轨道”之说：卦序是一张表之律的运行，不是只读部分构形或保持对称之律的运行；在对间是断言而非导出，只有对内是律。')],
        'gap_closed': 'Y5 (Becoming.HexagramSequences), in a stronger form: (a) and (b) as runsOrder_reads, '
                      'ringRule_not_runsOrder, twistedRule_not_runsOrder, runsOrder_not_commutes and '
                      'rearrange_not_runsOrder, with the laws running the order characterized (runsOrder_agrees, '
                      'runsOrder_lossless_iff, orderNext_one_orbit); the best partial agreements (9 and 28 of 63) and ('
                      'c) stay script computations.',
        'why': "Y5 proved in Lean what the reading computed, in a stronger form, and corrected the 易传 chapter's claim "
               'that the order is the orbit of no law'},
    'zagua-pairs': {
        'declarations_add': ['Becoming.Hexagram.zagua',
                             'Becoming.Hexagram.zagua_every',
                             'Becoming.Hexagram.partner',
                             'Becoming.Hexagram.paired_iff_partner',
                             'Becoming.Hexagram.partner_partner',
                             'Becoming.Hexagram.partner_run',
                             'Becoming.Hexagram.order_partners',
                             'Becoming.Hexagram.zagua_partners',
                             'Becoming.Hexagram.zagua_last_eight',
                             'Becoming.Hexagram.zagua_not_commutes'],
        'records_add': ['hexagram-arrangements-and-laws'],
        'reading_sub': [('AI读法：计算核对：杂卦六十四名恰是受传卦序的同样三十二对；',
                         'AI读法：Y5 在 Lean 中写成（zagua_every、order_partners、zagua_partners、zagua_last_eight，其序由易传章的检查脚本与所存杂'
                         '卦核对）：杂卦六十四名恰是受传卦序的同样三十二对；'),
                        ('它保留对，丢掉对与对之间的次序，与 xugua-between-pairs（对间次序是断言）相合。',
                         '它保留对，丢掉对与对之间的次序，与 xugua-between-pairs（对间次序是断言）相合；运行杂卦之序的律也不与翻转、全变或二者交换（zagua_not_commutes）。'),
                        ('Y1 未存杂卦原文。',
                         'Y1 未存杂卦原文，Y5 以本图谱所存之文核对。')],
        'gap_closed': 'Y5 (Becoming.HexagramSequences): zagua_every, zagua_partners and zagua_last_eight.',
        'why': 'Y5 proved in Lean what the reading computed'},
    'tuan-sun-yi': {
        'declarations_add': ['Becoming.Hexagram.swap',
                             'Becoming.Hexagram.yang_swap',
                             'Becoming.Hexagram.across',
                             'Becoming.Hexagram.passing',
                             'Becoming.Hexagram.across_exchange',
                             'Becoming.Hexagram.named_exchanges',
                             'Becoming.Hexagram.exchangesRun',
                             'Becoming.Hexagram.exchangeWorld_balances',
                             'Becoming.Hexagram.exchangeWorld_rise_fall',
                             'Becoming.Hexagram.three_iff',
                             'Becoming.Hexagram.exchanges_from_tai_pi'],
        'records_add': ['hexagram-arrangements-and-laws'],
        'reading_sub': [('AI读法：计算核对：损即泰交换第三、六爻',
                         'AI读法：Y5 在 Lean 中写成（named_exchanges、yang_swap）：损即泰交换第三、六爻'),
                        ('卦变（交换两爻）脊柱无，见 gap。',
                         '卦变（交换两爻）已由 Y5 写成：下卦与上卦之间的相易是两卦之间交换之律的一步（across_exchange），一切相易之历程读为世界皆平衡（'
                         'exchangeWorld_balances）；三阳三阴之卦二十，恰是泰、否与由之一易所得之十八卦，自泰否起的相易不出其外（three_iff、exchanges_from_tai_pi'
                         '）。')],
        'gap_closed': 'Y5 (Becoming.HexagramSequences): yang_swap, across_exchange, named_exchanges, '
                      'exchangeWorld_balances, three_iff.',
        'why': 'Y5 proved in Lean what the reading computed and what its gap named'},
    'xici-yanggua-qi': {
        'declarations_add': ['Becoming.Hexagram.yangOdd',
                             'Becoming.Hexagram.yangOdd_lumped',
                             'Becoming.Hexagram.yangOdd_goAlike',
                             'Becoming.Hexagram.yangOdd_goAlike_changes',
                             'Becoming.Hexagram.phaseCount_yangOdd',
                             'Becoming.Hexagram.count3',
                             'Becoming.Hexagram.strokes3',
                             'Becoming.Hexagram.odd3_iff',
                             'Becoming.Hexagram.trigramOdd_flip',
                             'Becoming.Hexagram.changes_run_trigram'],
        'records_add': ['hexagram-arrangements-and-laws'],
        'reading_sub': [('AI读法：计算核对：震坎艮各一阳二阴',
                         'AI读法：Y5 在 Lean 中写成（odd3_iff）：震坎艮各一阳二阴'),
                        ('所以奇偶两类是律通行的归并（理）。',
                         '所以奇偶两类是律通行的归并（理）；Y5 以阳爻数直接写出（yangOdd_goAlike、yangOdd_goAlike_changes、phaseCount_yangOdd）。'),
                        ('三爻层面的陈述与阳爻数的陈述脊柱尚无，见 gap。',
                         '三爻层面的陈述由 Y5 写成：一爻之变使其所在之卦由阳卦为阴卦或反之，另一卦不变（changes_run_trigram）。')],
        'gap_closed': 'Y5 (Becoming.HexagramSequences): odd3_iff, yangOdd_goAlike, yangOdd_goAlike_changes, '
                      'changes_run_trigram.',
        'why': 'Y5 proved in Lean what the reading computed and what its gap named'},
    'shuogua-tiandi-dingwei': {
        'declarations_add': ['Becoming.Hexagram.Trigram.complement3',
                             'Becoming.Hexagram.Trigram.opposite_stations'],
        'records_add': ['hexagram-arrangements-and-laws'],
        'reading_sub': [('AI读法：计算核对：四对恰是三爻层面的四对互补',
                         'AI读法：Y5 在 Lean 中写成（Trigram.opposite_stations）：四对恰是三爻层面的四对互补')],
        'why': 'Y5 proved in Lean what the reading computed'},
    'shuogua-di-chu-zhen': {
        'declarations_add': ['Becoming.Hexagram.Trigram.stations',
                             'Becoming.Hexagram.Trigram.stations_not_commutes',
                             'Becoming.Hexagram.Trigram.ringRule3_rotate',
                             'Becoming.Hexagram.Trigram.stations_not_rules',
                             'Becoming.Hexagram.Trigram.rearrange3_complement',
                             'Becoming.Hexagram.Trigram.rearrange3_not_stations',
                             'Becoming.Hexagram.Trigram.opposite_stations'],
        'records_add': ['hexagram-arrangements-and-laws'],
        'reading_sub': [('计算核对，震→巽→离→坤→兑→乾→坎→艮→震不是任何"置换各爻并加掩码"之律的运行（最多合 4/8 步），也不是任何三格局部规则（循环或扭转）的运行（最多 5/8）；圆上四对对位中只有离'
                         '坎互补，而第三章的四对全是互补。',
                         'Y5 在 Lean 中证明：运行震→巽→离→坤→兑→乾→坎→艮之律不与互补、翻转、二者或三爻之轮转交换（Trigram.stations_not_commutes），所以没有三格局部规则'
                         '（循环或扭转）、也没有"置换各爻并加掩码"之律运行它（Trigram.stations_not_rules、Trigram.rearrange3_not_stations）；圆上四对对位'
                         '中只有离坎互补，而第三章的四对全是互补（Trigram.opposite_stations）。脚本另算部分相合：置换加掩码之律最多合 4/8 步，三格局部规则最多 5/8。')],
        'gap_closed': 'Y5 (Becoming.HexagramSequences): Trigram.stations_not_commutes, Trigram.stations_not_rules, '
                      'Trigram.rearrange3_not_stations, Trigram.opposite_stations; the best partial agreements stay '
                      'script computations.',
        'why': 'Y5 proved in Lean what the reading computed'},
    'tuan-tai-pi-jiao': {
        'declarations_add': ['Becoming.Hexagram.meets',
                             'Becoming.Hexagram.meets_tai_pi',
                             'Becoming.Hexagram.pi_of_tai',
                             'Becoming.Hexagram.kept_alike',
                             'Becoming.Hexagram.tai_pi_runs'],
        'records_add': ['hexagram-arrangements-and-laws'],
        'reading_sub': [('但"交/不交"不能从脊柱现有的位之关系读出：泰与否在每个高度都"对"（oppositions_glue_iff），二者在"对"之下完全相同。区别它们要把一个方向读入两值（天升地降，故天在'
                         '下则交），这是额外前提，见 gap，交给 Y2–Y4。',
                         '但"交/不交"不能从为全变所保持的位之关系读出：泰与否在每个高度都"对"（oppositions_glue_iff），否是泰之全变，凡全变所保持之读法沿二者的消息历程每一步都相同（'
                         'kept_alike、tai_pi_runs）。区别它们要把一个方向读入两值（天升地降，故天在下则交）：Y5 写作交（meets），泰三个高度皆交、否皆不交（meets_tai_pi）；'
                         '这是一个读法，全变不保持它。')],
        'gap_closed': 'Y5 (Becoming.HexagramSequences): meets, meets_tai_pi, kept_alike, tai_pi_runs.',
        'why': 'Y5 stated the direction the reading named as a gap'},
    'tuan-jiji-weiji': {
        'declarations_add': ['Becoming.Hexagram.waxWane_moves',
                             'Becoming.Hexagram.run_never_rests',
                             'Becoming.Hexagram.never_comes_to_rest',
                             'Becoming.Hexagram.changes_run_never_rests'],
        'records_add': ['hexagram-arrangements-and-laws'],
        'reading_sub': [('消息之律无不动点，脊柱没有单独命名的引理，见 gap。',
                         '消息之律无不动点，由 Y5 写成：没有构形为其不动点（waxWane_moves），其运行在任何一步都不止，也不自某步起止（run_never_rests、'
                         'never_comes_to_rest），一爻之变的历程亦然（changes_run_never_rests）。')],
        'gap_closed': 'Y5 (Becoming.HexagramSequences): waxWane_moves, run_never_rests, never_comes_to_rest, '
                      'changes_run_never_rests.',
        'why': 'Y5 stated the lemma the reading named as a gap'},
    'xunzi-tong-ze-tong-zhi': {
        'declarations_add': ['Becoming.SharedCodes.run_held',
                             'Becoming.SharedCodes.kept_iff',
                             'Becoming.SharedCodes.run_agrees_every_start_iff',
                             'Becoming.SharedCodes.reads_iff',
                             'Becoming.SharedCodes.run_renamed',
                             'Becoming.SharedCodes.never_agrees_of_both',
                             'Becoming.SharedCodes.TwoFormations.three_agree'],
        'records_add': ['a-code-formed-between-formations'],
        'reading_sub': [(('“约定俗成”是编码在使用者之间形成并保持；脊柱只有单向取得（给定编码、教师）与已装入编码在信道变化下的保持（References.stays_iff），没有编码在使用者关系中形成的律（见缺口）。'
                          '结构相合，缺约定一环。'),
                         ('“约定俗成”是编码在使用者之间形成并保持（SharedCodes）：听取不造新形（run_held），一组在某义上的相合恰经对它封闭的听取而保持（kept_iff）；所成之形由起点与听取次序固定，'
                          '一个次序恰在给每个形成同一来源时从每个起点都形成相合（run_agrees_every_start_iff）；形成之间恰在编码相合处互读其别（reads_iff，'
                          'References.stays_iff 的形成之间形式）。不特许任何形式（run_renamed），而既不特许形式也不特许形成者的律永不使对称的分歧相合（never_agrees_of_both）'
                          '：约定之成要打破一个对称，中心、偏好之形与听取次序各是一途（TwoFormations.three_agree），约定俗成是次序一途。结构相合，约定一环已补上。'))],
        'reading_en_sub': [('what the spine lacks is the code formed between users (约定俗成).',
                            ('the code formed between users (约定俗成) is now SharedCodes: hearing makes no form, agreement is kept '
                             'exactly through closed hearings, the start and the order fix the form, users read each other where '
                             'codes agree, and a law privileging neither form nor user never settles a symmetric disagreement, so '
                             'convention breaks a symmetry by the order of use.'))],
        'gap_closed': ('SC (Becoming.SharedCodes, record a-code-formed-between-formations, study section 210); the '
                       'statement above is kept as proposed, and where the laws differ from it the record and the study '
                       'section say so (the coupling-closure form proposed for 名无固宜 is false, Path.never_agree).'),
        'why': ('SC: Becoming.SharedCodes proved the code formed between formations the reading named as a gap; its '
                'laws and record added and the sentence that named the gap replaced (both languages)')},
    'ru-xunzi-ming-wu-gu-yi': {
        'declarations_add': ['Becoming.SharedCodes.run_renamed_tells_apart_iff',
                             'Becoming.SharedCodes.renamed_carries_iff',
                             'Becoming.SharedCodes.never_agrees_of_both',
                             'Becoming.SharedCodes.TwoFormations.three_agree',
                             'Becoming.SharedCodes.follow_agrees_iff',
                             'Becoming.SharedCodes.Path.never_agree'],
        'records_add': ['a-code-formed-between-formations'],
        'reading_sub': [('剩余：荀子接着说“其民莫敢托为奇辞以乱正名”，由王者制名并禁止乱名，把约定的形成交给单一中心；而约定在众多使用者之间如何形成、如何保持，脊柱没有定理（见 gap）。',
                         ('荀子接着说“其民莫敢托为奇辞以乱正名”，由王者制名并禁止乱名，把约定的形成交给单一中心。SharedCodes 给出两者的关系：改名不改变编码所分别者，'
                          '也不改变它是否承载规律（run_renamed_tells_apart_iff、renamed_carries_iff）；'
                          '既不特许形式也不特许形成者的律永不使对称的分歧相合（never_agrees_of_both），中心、'
                          '偏好之形与听取次序各打破一个对称而在一步内相合（TwoFormations.three_agree）：王者制名是中心一途，约定俗成是次序一途。缺口原拟的陈述（各取其所耦合者中最小编号者之码，'
                          '恰在每个耦合闭包为全体时静止为同）不成立：在路 a–c–b 上两端各为其耦合中最小者，永不相合（Path.never_agree）；指针律之下相合恰是指针之路相遇（follow_agrees_iff）'
                          '。'))],
        'reading_en_sub': [('how a shared naming forms among many users, which Xunzi hands to the king, has no law on the spine.',
                            ('how a shared naming forms among many users, which Xunzi hands to the king, is SharedCodes: renaming '
                             'changes neither what a code tells apart nor what it carries, and a law privileging neither name nor '
                             'user never settles a symmetric disagreement, so a centre (the king), a preferred form or the order '
                             "of use must break the symmetry; the gap's coupling-closure form is false (Path.never_agree)."))],
        'gap_closed': ('SC (Becoming.SharedCodes, record a-code-formed-between-formations, study section 210); the '
                       'statement above is kept as proposed, and where the laws differ from it the record and the study '
                       'section say so (the coupling-closure form proposed for 名无固宜 is false, Path.never_agree).'),
        'why': ('SC: Becoming.SharedCodes proved the code formed between formations the reading named as a gap; its '
                'laws and record added and the sentence that named the gap replaced (both languages)')},
    'shuowen-xu-shu-tong-wen': {
        'declarations_add': ['Becoming.SharedCodes.run_from_imposition',
                             'Becoming.SharedCodes.source_loses_nothing',
                             'Becoming.SharedCodes.run_imposed_stays',
                             'Becoming.SharedCodes.outside_needed',
                             'Becoming.SharedCodes.outside_returns'],
        'records_add': ['a-code-formed-between-formations'],
        'reading_sub': [('与“约定俗成”所说在使用者之间形成的约定不同（见荀子正名条目的缺口）。',
                         ('与“约定俗成”所说在使用者之间形成的约定不同。SharedCodes 给出强加编码的确切律：强加使所有人在每一义上相合，每个形成恰失去其编码所分而强加编码所合并者，'
                          '被强加其编码的形成一无所失（run_from_imposition、source_loses_nothing）；此后在任何听取次序与规则下强加编码保持（run_imposed_stays），'
                          '被合并的分别只从强加之外保留的形式回来（outside_needed），从这样的形式则一步即回（outside_returns）。“古文由此絕”是外面再无保留旧形之处。'))],
        'reading_en_sub': [('unlike a convention formed among users.',
                            ('unlike a convention formed among users; its loss stays under every later exchange and comes back '
                             'only from a form kept outside the imposition (SharedCodes: run_from_imposition, outside_needed).'))],
        'why': ('SC: Becoming.SharedCodes proved the code formed between formations the reading named as a gap; its '
                'laws and record added and the sentence that named the gap replaced (both languages)')},
    'hanfei-er-bing': {
        'declarations_add': ['Becoming.RuleCapture.locked_stays',
                             'Becoming.RuleCapture.favouring_locks',
                             'Becoming.RuleCapture.perturbation_absorbed',
                             'Becoming.RuleCapture.uniform_locks'],
        'records_add': ['capture-through-the-rule'],
        'reading_sub': [('脊柱分别有这两部分，没有证明它们闭合成回路（见 gap）。',
                         ('回路的闭合由 RuleCapture 证明：规则从所选出者的份额单调地读出时，锁定之后回路不回转（locked_stays），没有规则反对读法时在第一个读取步锁定（favouring_locks），'
                          '保持方向的规则扰动在下一读取步被吸收（perturbation_absorbed），只有改变规则怎样读才离开（uniform_locks）。'))],
        'reading_en_sub': [('whose parts the spine has (Pace.rule_at_reading, Capture) but whose closure it does not prove.',
                            ('whose closure RuleCapture proves: with the rule read monotonically from the share it selects, the '
                             'loop locks (locked_stays; at the first reading step where no rule turns against the reading, '
                             'favouring_locks), a perturbation of the rule that keeps its direction is absorbed at the next '
                             'reading step (perturbation_absorbed), and only a change of how the rule reads leaves '
                             '(uniform_locks).'))],
        'gap_closed': ('RC (Becoming.RuleCapture, record capture-through-the-rule, study section 213); the statement above '
                       'is kept as proposed. With the margin a natural number, as stated, (i) and (ii) hold at every step, '
                       'not only at reading steps (Counts.margin_course, Counts.rises_strictly_along), and (iii) holds for '
                       'every change of the margin (perturbation_absorbed). Where rules can favour the others, (i) and (ii) '
                       'need the start locked (locked_stays; Alternating refutes them without it), (iii) holds exactly for '
                       'perturbations keeping the direction (Reversed.not_absorbed), and leaving needs a change of h where '
                       'the reading favours at every share (uniform_locks, exact by Second.second_exact). Readings D57.'),
        'why': ('RC: Becoming.RuleCapture proved the loop the reading named as a gap (capture through the rule); its '
                'laws and record added and a sentence of each reading replaced or extended (both languages)')},
    'guanzi-guoxu-ju-you-yu': {
        'declarations_add': ['Becoming.RuleCapture.Counts.proportional_locks'],
        'records_add': ['capture-through-the-rule'],
        'reading_sub': [('两个可互替的供给者任一即足（either_suffices）。',
                         ('两个可互替的供给者任一即足（either_suffices）。据有余而制不足若读作规则按各类所持之比例给出（比例读法），持多者被偏向而持得更多，'
                          '回路不回转（Counts.proportional_locks）。'))],
        'reading_en_sub': [('where two feeders would each suffice (either_suffices).',
                            ('where two feeders would each suffice (either_suffices). Read as a rule given in proportion to what '
                             'each kind holds, the kind holding more is favoured and holds more, and the loop does not turn back '
                             '(Counts.proportional_locks).'))],
        'why': ('RC: Becoming.RuleCapture proved the loop the reading named as a gap (capture through the rule); its '
                'laws and record added and a sentence of each reading replaced or extended (both languages)')},
    'shangjunshu-yi-shang-yi-xing-yi-jiao': {
        'declarations_add': ['Becoming.RuleCapture.uniform_locks',
                             'Becoming.RuleCapture.Second.second_exact'],
        'records_add': ['capture-through-the-rule'],
        'reading_sub': [('商君书把壹作为为国之道；',
                         ('壹读作一个在每个份额都偏向同一方向的读法时，每条进程自第二个读取步之后锁定，且确切（uniform_locks、Second.second_exact），只有改变规则怎样读才离开。'
                          '商君书把壹作为为国之道；'))],
        'reading_en_sub': [('(share_rises_through); the text takes',
                            ('(share_rises_through); read as one reading favouring one way at every share, every course is locked '
                             'from its second reading step, exactly, and only a change of how the rule reads leaves '
                             '(uniform_locks, Second.second_exact); the text takes'))],
        'why': ('RC: Becoming.RuleCapture proved the loop the reading named as a gap (capture through the rule); its '
                'laws and record added and a sentence of each reading replaced or extended (both languages)')},
    'lao-77-tian-zhi-dao': {
        'declarations_add': ['Becoming.Flow.withinGap_iff_between',
                             'Becoming.Flow.regulates',
                             'Becoming.Flow.settles',
                             'Becoming.Flow.restores_exactly',
                             'Becoming.Flow.crosses_of_above',
                             'Becoming.Regulation.Overshooting.oscillates',
                             'Becoming.Regulation.OneSided.above'],
        'records_add': ['two-sided-regulation-and-late-reading'],
        'reading_sub': [('双向调节的确切定律（含两种失败：单侧、矫枉过正而振荡）是缺口。',
                         '双向调节的确切定律已证（`Becoming.Regulation`）：平衡下，合取的交换在两侧都以与 m 的距离为界，恰是下一水平落在 m '
                         '与当前水平之间（`Flow.withinGap_iff_between`）；有界且两侧都与偏离相反时，距离为正则每步至少降一，距离用尽时水平定于 '
                         'm（`Flow.regulates`、`Flow.settles`）。两种失败也是确切的：越界的相反交换越过 m（`Flow.crosses_of_above`），其证人在 m '
                         '两侧往复而永不到 m（`Overshooting.oscillates`）；只有一侧时，恢复律的前提成立而水平永在 m 之上（`OneSided.above`）。')],
        'reading_en_sub': [('it is the property of a regulating coupling, and the two-sided law with its failure '
                            'modes is a gap.',
                            'it is the property of a regulating coupling. That law is proved (Becoming.Regulation): '
                            'bounded by the gap on both sides and opposing, the level settles at m within its gap; '
                            'beyond the bound it crosses m and can alternate without end; one side alone can leave '
                            'it away for ever.')],
        'gap_closed': ('RG (Becoming.Regulation, record two-sided-regulation-and-late-reading), as stated for one '
                       'condition, with the bound read as no overshoot: the exchange is within the gap to m on both '
                       'sides exactly where the next level lies between m and the level '
                       '(Flow.withinGap_iff_between); with it and opposing on both sides the level is m from T plus '
                       'its gap at T on (Flow.regulates, Flow.settles); (iii) is not needed, since at m the bound '
                       'itself keeps the level at m (Flow.withinGap_iff_of_at). Both failures are exact: beyond the '
                       'bound an opposing exchange crosses m and a witness alternates without end '
                       '(Flow.crosses_of_above, Regulation.Overshooting.oscillates); with one side only the premise '
                       'of Flow.restores holds and the level stays above m (Regulation.OneSided.above).'),
        'why': 'RG proved the two-sided law the reading named as a gap, with both of its failures'},
    'lao-42-chong-qi-yi-wei-he': {
        'declarations_add': ['Becoming.Flow.withinGap_iff_between',
                             'Becoming.Flow.settles',
                             'Becoming.Flow.stays_between_at',
                             'Becoming.Regulation.Overshooting.never_at'],
        'records_add': ['two-sided-regulation-and-late-reading'],
        'reading_sub': [('脊柱目前只有单向的部分：', '脊柱有单向的部分：'),
                        ('双向调节（高者抑、低者举）与其失败方式（单向、矫枉过正）没有被证明的定律，见缺口。',
                         '双向调节（高者抑、低者举）与其失败方式已证（`Becoming.Regulation`，见第七十七章条）：两种相反作用各以与 m 的距离为界时，水平在界内永不越过 '
                         'm（`Flow.stays_between_at`），与偏离相反时定于 m（`Flow.settles`）；越界则越过，可以永不到 '
                         'm（`Overshooting.never_at`）。所以“和”在此读作受两侧有界的相反作用所保持的水平，是一种耦合的性质。')],
        'reading_en_sub': [("'harmony' has only one-sided counterparts on the spine (restoration from below, excess "
                            'lowering, difference closing on a loop); the two-sided regulating law is a gap, stated '
                            'under lao-77-tian-zhi-dao.',
                            "'harmony' is the level two-sided regulation keeps (Becoming.Regulation, under "
                            'lao-77-tian-zhi-dao): bounded by the gap on both sides the level never crosses m, and '
                            'opposing it settles there; beyond the bound it crosses and can miss m for ever. The '
                            'one-sided counterparts (restoration from below, excess lowering, difference closing on '
                            'a loop) are its parts.')],
        'gap_closed': ('RG (Becoming.Regulation, record two-sided-regulation-and-late-reading), as stated for one '
                       'condition, with the bound read as no overshoot: the exchange is within the gap to m on both '
                       'sides exactly where the next level lies between m and the level '
                       '(Flow.withinGap_iff_between); with it and opposing on both sides the level is m from T plus '
                       'its gap at T on (Flow.regulates, Flow.settles); (iii) is not needed, since at m the bound '
                       'itself keeps the level at m (Flow.withinGap_iff_of_at). Both failures are exact: beyond the '
                       'bound an opposing exchange crosses m and a witness alternates without end '
                       '(Flow.crosses_of_above, Regulation.Overshooting.oscillates); with one side only the premise '
                       'of Flow.restores holds and the level stays above m (Regulation.OneSided.above).'),
        'why': 'RG proved the two-sided law the reading named as a gap (stated under lao-77-tian-zhi-dao)'},
    'zuo-zhao20-kuan-meng': {
        'declarations_add': ['Becoming.Regulation.late_spread',
                             'Becoming.Regulation.no_narrower_band',
                             'Becoming.Regulation.lateReturn_band',
                             'Becoming.Regulation.overshoot',
                             'Becoming.Regulation.crossing_oscillates',
                             'Becoming.Regulation.held_oscillates',
                             'Becoming.Regulation.held_below_settles',
                             'Becoming.Regulation.relay_threshold'],
        'records_add': ['two-sided-regulation-and-late-reading'],
        'reading_sub': [('范围与分歧：这是两档玩具模型、即时响应；“政宽则民慢，慢则纠之以猛，猛则民残”描述的是迟到的读法造成两端越界的往复，模型没有覆盖（见缺口）。',
                         '范围与分歧：这是两档玩具模型、即时响应。“政宽则民慢，慢则纠之以猛，猛则民残”所述的往复，是迟到读法的越界，已证（`Becoming.Regulation`）：迟 ℓ '
                         '步读的规则分不出其后 ℓ + 1 步内不同的扰动，所以扰动每步至多 d 时，任何这样的规则所保之带都不窄于 2(ℓ + '
                         '1)d（`late_spread`、`no_narrower_band`），而迟返恰保此带（`lateReturn_band`）。以步长 M 迟读的阈值调节越过入带处 '
                         'ℓM（`overshoot`），一旦越过便两端越出而无尽（`crossing_oscillates`）；带下的起点恰在 a + (ℓ + 1)M ≤ b + 1 '
                         '时都定于带内（`held_below_settles`、`relay_threshold`），过此阈值则贴近 a 的起点两端往复（`held_oscillates`）。')],
        'reading_en_sub': [("the passage's overshoot from a late reading (宽→慢→猛→残) is beyond the model, and its "
                            'frame governs the people as a regulated stock.',
                            "the passage's overshoot from a late reading (宽→慢→猛→残) is proved beyond the model "
                            '(Becoming.Regulation): no rule reading ℓ steps late keeps a band narrower than 2(ℓ + '
                            '1)d, and a relay reading late leaves both ends without end exactly past a threshold set '
                            'by lateness times step. Its frame governs the people as a regulated stock.')],
        'gap_closed': ('RG (Becoming.Regulation, record two-sided-regulation-and-late-reading), in part. (iii) '
                       'proved exactly: a start held at a - 1 for the first l + 1 steps leaves both ends without end '
                       'where b + 2 <= a + (l + 1) M (Regulation.held_oscillates), every start held below a settles '
                       'in the band where a + (l + 1) M <= b + 1 (Regulation.held_below_settles), and with the '
                       "relay's runs (Regulation.relay_runs, where (l + 1) M <= b + 1) the threshold is exact "
                       '(Regulation.relay_threshold). (i) proved for one start, the rule chosen with it: no rule '
                       'reading l late keeps a band narrower than 2 (l + 1) d under every rest within d a step '
                       '(Regulation.no_narrower_band), and the late return keeps that band '
                       '(Regulation.lateReturn_band); one policy keeping [a, b] from every start in it is not '
                       'proved. (ii) is not proved.'),
        'why': ("RG proved the late reading's overshoot the reading placed beyond the model, with the least band a "
                "late rule needs and the relay's exact threshold")},
    'ru-zhongyong-zhi-zhong-he': {
        'declarations_add': ['Becoming.Flow.withinGap_iff_between',
                             'Becoming.Flow.settles',
                             'Becoming.Flow.crosses_of_above'],
        'records_add': ['two-sided-regulation-and-late-reading'],
        'reading_sub': [('（见程颢“一体”条）。',
                         '（见程颢“一体”条）。“发而皆中节”的“节”也可读为（AI 读法）回应以距离为界：与偏离相反的回应在两侧都不超过它与 m 的距离，恰是下一水平落在 m '
                         '与当前水平之间（`Flow.withinGap_iff_between`），这时水平在距离用尽时定于 m（`Flow.settles`）；不中节的回应越过 '
                         'm（`Flow.crosses_of_above`）。这是一种耦合的性质，不涉及天地之位。')],
        'reading_en_sub': [('not as such.',
                            'not as such. 发而皆中节 can also be read (AI) as a response within the gap: opposing, it '
                            "stays within the level's distance to m on both sides exactly where the next level lies "
                            'between m and the present one, and the level then settles at m '
                            '(Flow.withinGap_iff_between, Flow.settles); a response beyond it crosses m.')],
        'why': 'RG: 中节 read as a response within the gap, the bound two-sided regulation proves exact'},

    # ZHK: five entries whose structure the 脉络 map (ZH, decision D62) read again and judged exact scope; each
    # reading rewritten from the 脉络 entries (development/zhonghua/passages.json) to say where the claim holds.
    'xunzi-hua-yi-shi': {
        'kind': 'scope',
        'declarations_add': ['Becoming.World.balanced_reidentify_iff_alike'],
        'reading': ('AI 读法：“二实”以“所”计数，所是关系：一个描述有意义，恰当它等同关系相同者、并等同凡相同者（identifiesAlike_iff）；'
                    '把在每一关系上都相同的两者分开命名没有意义（Twins.naming_not_identifiesAlike、left_alike_right，构造模型中的见证），'
                    '而处所不同即关系不同，故为二；此处“状同”只是在若干关系上相同，不含所处之关系。“化”是跨步的同一：在平衡、关系项的同一可判定的世界中，'
                    '守恒在一步上固定一关系项的同一，恰当此步之后没有其他关系项与它水平相同（World.fixed_iff）；使世界平衡的命名恰是守恒内的一一延续'
                    '（balanced_reidentify_iff）。定域：荀子把“实无别”当作可以稽察的事实，律只在上述之处定下它；步后有别的关系项与它水平相同之处，'
                    '守恒定不下谁是谁，要选一个延续，同一只定到水平相似为止（World.balanced_reidentify_iff_alike）。以所别实，也只在所即关系之处成立。'
                    '说文“化，教行也”是另一义，见下。'),
        'reading_en': ('AI reading, exact scope: 荀子 counts 实 by relation (different 所 makes two; naming apart what is alike in every '
                       'relation makes no sense), and 化 is identity across a step, which conservation fixes exactly where '
                       'nothing else stands after the step at the level of the relatum (World.fixed_iff); elsewhere a '
                       'continuation must be chosen and identity is fixed only up to likeness of standing '
                       '(balanced_reidentify_iff_alike), so 实无别 is a fact only where the law fixes it.'),
        'why': ZHK_WHY},
    'sunzi-wu-yue-tong-zhou': {
        'kind': 'scope',
        'declarations_add': ['Becoming.Flow.mutuallyDependent_of_common'],
        'records_add': ['mutual-dependence-and-its-pace'],
        'reading': ('AI 读法：吴越相恶，是各自为界的中心彼此不一（centers_disagree，构造之例）；同舟遇风，二者依赖同一条件，'
                    '依赖链到达一个不活跃的关系项就终结链上一切（Web.coextinct, Web.Dependent）；一个人人依赖并交换的共同条件使二者相互依赖'
                    '（mutuallyDependent_of_common）。在共同供给条件下，以各中心供给闭包为界的意义就是延续条件（feeding_unrestricted_of_common，'
                    '这是条件句，不断言延续条件）：各自为界的意义已覆盖对方。共同依存的结构与经文相合，"不得已"即此依赖。定域：同一片段说'
                    '"携手若使一人"，使之如一的是将帅；下文"能愚士卒之耳目，使之无知""帅与之期，如登高而去其梯"表明，这一处境是将帅使士卒无知、'
                    '去其梯而有意造成的，这一层是单一中心。所以同舟之依存成立，作为用兵之术，由一个中心设置众人之处境，不在脊柱之中。脊柱也不推出"相救"的行为。'),
        'reading_en': ('AI reading, exact scope: 吴 and 越 as self-bounded centers disagree (centers_disagree); in the storm both depend '
                       'on one boat, and a chain of dependence reaching an inactive relatum ends everything on it '
                       '(coextinct); a common condition all depend on makes them mutually dependent '
                       '(mutuallyDependent_of_common), and under it each center\'s bounded significance is already the '
                       'continuation condition (feeding_unrestricted_of_common). The structure of common dependence '
                       'agrees; but in the same passage the general makes them act as one man, and the text goes on to '
                       'his keeping the soldiers ignorant and removing the ladder: the situation is set by a single '
                       'centre, a layer the spine does not take. The rescuing behavior is not derived.'),
        'why': ZHK_WHY},
    'zaahan-ci-you-gu-bi-you': {
        'kind': 'scope',
        'reading': ('AI 读法："此无故彼无，此灭故彼灭"是依赖的必要方向：活跃只在所依赖条件支持时（Web.Dependent），依赖链到达不活跃者就终结链上一切'
                    '（coextinct）；每个满足的依赖在每步或保持或断开（kept_or_broken）。定域："此有故彼有，此生故彼生"若读作由此之有导出彼之有'
                    '（充分方向），脊柱不给：依赖只说活跃者须受支持，从不由支持推出活跃；此句只在彼已活跃之处成立，读作彼之有须此之有，即依赖结构中的共起。'
                    '"见世间集则不生无见，见世间灭则不生有见"：生起与止息是一个变化的读法（change_readings），有限族中生起反复恰当止息反复'
                    '（arising_recurs_iff），这一句在此结构上相合。'),
        'reading_en': ('AI reading, exact scope: "this not being, that is not" is the necessary direction of dependence (Web.Dependent, '
                       'coextinct); "this being, that is", read as sufficiency, the spine never gives, since dependence '
                       'says only that what is active is supported: it holds only where that is already active, as '
                       'co-arising within dependence. Seeing arising removes the view "is not" and seeing ceasing '
                       'removes "is", as arising and ceasing are one change read (change_readings, arising_recurs_iff).'),
        'why': ZHK_WHY},
    'lao-76-rou-ruo-sheng-zhi-tu': {
        'kind': 'scope',
        'declarations_add': ['Becoming.Tolerance.gives_needs_sparing', 'Becoming.Tolerance.total_stays'],
        'reading': ('AI 的读法：把“柔弱”读作容忍（一个形成可以缺少其所等待者中的若干而仍然给予），把“坚强”读作容忍为零（要求所等待者全部给予）。'
                    '脊柱：容忍为零就是等待全部（`Tolerance.tolerating_zero`）；有记忆时，一处扣留终结它所达的全部给予（`Withholding.withholding_absorbs`）；'
                    '三个互相等待的形成中，从一处扣留起，容忍 0 在第二步处处扣留，容忍 1 在一步内吸收（`Triad.spreads`、`Triad.absorbed`）；'
                    '稀薄的扣留在容忍之内一步消散（`thin_absorbed`），每个只在其容忍之外等待的集合一直给予（`kept_set`）。'
                    '所以“柔弱者生之徒”在“吸收局部扣留”之处成立。定域：自全面扣留起，任何形成之给予都须有一个形成的容忍不少于其所等待者之数'
                    '（`Tolerance.gives_needs_sparing`）；无此者，全面扣留永续（`Tolerance.total_stays`；三者之例中容忍为一亦然，`Triad.total_kept`）。'
                    '所以“柔弱者生之徒”作全称断言，在扣留落在容忍之内时成立，在全面扣留而无一形成全容时不成立：柔弱不是万能的。'
                    '第七十八章“柔之胜刚”是跨律比较，脊柱只在见证中有，没有一般定律，见缺口。帛书甲作“木強則恆”，乙作“木強則兢”。'),
        'reading_en': ("AI reading, exact scope: read as tolerance, softness absorbs a withholding within tolerance in one step while "
                       "zero tolerance lets one withholding end all giving it reaches; from total withholding, giving "
                       "needs some formation whose tolerance is at least the number it waits on, and without one total "
                       "withholding stays (gives_needs_sparing, total_stays), so 柔弱者生之徒 holds where withholding is "
                       "local, not universally; the comparison 'the soft overcomes the hard' across laws is a gap."),
        'why': ZHK_WHY},
}

# Renamed declarations, a correction of every entry that names one: the Lean renamed them after the mappers
# wrote, statements unchanged (R22: development/r22-names/RENAME-TABLE.json, Widening -> LoopReturn; R30:
# development/r30-names/RENAME-TABLE.json). The declarations and the names in a reading follow; the reading's
# words do not change. Applied after FIXES, so a FIXES entry may still name an old declaration.
RENAMED_WHY = ('names follow the renamed declarations (R22, R30; tables in development/r22-names and '
               'development/r30-names), statements unchanged')


def renamed():
    out = dict(json.loads((HERE.parent / 'r22-names/RENAME-TABLE.json').read_text())['declarations'])
    r30 = HERE.parent / 'r30-names/RENAME-TABLE.json'
    if r30.exists():
        out.update(json.loads(r30.read_text())['declarations'])
    return out


def r30_rules():
    r30 = HERE.parent / 'r30-names/RENAME-TABLE.json'
    if not r30.exists():
        return {}, {}
    t = json.loads(r30.read_text())
    return t['text_windows'], t['text_words']


def rename_text_r30(s, windows, words):
    """R30's rule for prose (development/r30-names/text.py): a qualified suffix of at least two components that
    ends only renamed declarations, all renamed to one form, takes that form; a one-component name every declaration
    of which is renamed to one name takes it where it cannot be an English word."""
    import re
    ident = re.compile(r"(?<![A-Za-z0-9_'!?₀-₉])[A-Za-z_][A-Za-z0-9_'!?₀-₉]*(?:\.[A-Za-z_][A-Za-z0-9_'!?₀-₉]*)*")

    def one(tok):
        c = tok.split('.')
        out = list(c)
        i = len(c) - 1
        while i >= 0:
            for k in range(min(i + 1, 7), 1, -1):
                w = '.'.join(c[i - k + 1:i + 1])
                if w in windows:
                    out[i - k + 1:i + 1] = windows[w].split('.')
                    i -= k
                    break
            else:
                if len(c) == 1 and c[0] in words:
                    out[0] = words[c[0]]
                i -= 1
        return '.'.join(out)
    return ident.sub(lambda m: one(m.group(0)), s)


def rename_text(s, table):
    """A declaration named qualified (Becoming.X.y or X.y) takes its new name."""
    import re
    short = {o[len('Becoming.'):]: n[len('Becoming.'):] for o, n in table.items()}
    pat = re.compile(r'(?<![\w.])(Becoming\.)?(' + '|'.join(re.escape(k) for k in sorted(short, key=len, reverse=True)
                                                           if '.' in k) + r')(?![\w])')
    return pat.sub(lambda m: (m.group(1) or '') + short[m.group(2)], s)


RENAMES = renamed()
R30_WINDOWS, R30_WORDS = r30_rules()

# Renamed records (R35, E4): a passage's records, and record ids named in its readings, follow the record renames
# (receipts in _process/architecture/renames/), claims unchanged. Applied after FIXES, so a FIXES entry may still
# name a former id.
RECORDS_RENAMED_WHY = 'record ids follow the renamed records (R35; receipts in _process/architecture/renames), claims unchanged'


def renamed_records():
    out = {}
    for f in sorted((V.ROOT / '_process/architecture/renames').glob('*.json')):
        for x in json.loads(f.read_text())['renames']:
            out[x['old']] = x['new']
    return out


def rename_records_text(s, table):
    import re
    for old, new in table.items():
        s = re.sub(r'(?<![A-Za-z0-9_-])' + re.escape(old) + r'(?![A-Za-z0-9_-])', new, s)
    return s


RECORD_RENAMES = renamed_records()


def tradition(slice_, e):
    fixed = {'yi': '易传', 'lao': '老子', 'ru': '儒家', 'wen': '文字'}
    if slice_ in fixed:
        return fixed[slice_]
    work = e.get('tradition', '')
    for name, keys in OTHER:
        if any(k in work for k in keys):
            return name
    return '其他'


def source_path(e, atlas_of_text):
    if e.get('needs_source'):
        title = urllib.parse.unquote(e['needs_source']).split('/wiki/', 1)[1].replace('_', ' ')
        title = {'莊子/雜篇/天下': '莊子/天下'}.get(title, title)
        return 'wikisource/' + title.replace('/', '__').replace(' ', '_').replace(':', '_') + '.json'
    tp = e['text_path']
    name = tp.split('evidence/texts/', 1)[1]
    return f'{atlas_of_text}/evidence/texts/{name}'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--preserve', action='store_true')
    ap.add_argument('--check', action='store_true')
    args = ap.parse_args()
    assert not (args.preserve and args.check), '--check writes nothing'
    archives = {a['id']: zipfile.ZipFile(a['zip_path']) for a in ATLASES}
    members = {a['id']: {n[len(a['prefix']):] for n in archives[a['id']].namelist()} for a in ATLASES}
    index = {}
    for a in ATLASES:
        zf = archives[a['id']]
        index[a['id']] = V.load_atlas(a['id'], lambda n, zf=zf, p=a['prefix']: zf.read(p + n).decode())

    passages, problems, wanted = [], [], set()
    seen = set()
    y1 = {p['id'] for p in json.loads(V.Y1.read_text())['passages']}
    for s in SLICES:
        for e in json.loads((HERE / 'mappers' / s / 'entries.json').read_text()):
            e = dict(e)
            fix = FIXES.get(e['id'], {})
            order = [a.strip() for a in (e.get('atlas') or '').split(';') if a.strip() in members]
            order += [a for a in members if a not in order]
            name = (e.get('text_path') or '').split('evidence/texts/', 1)[-1]
            text_atlas = next((a for a in order if 'evidence/texts/' + name in members[a]), order[0])
            src = fix.get('source') or source_path(e, text_atlas)
            pid = e['id'] if e['id'] not in seen and e['id'] not in y1 else f"{s}-{e['id']}"
            seen.add(pid)
            ids = []
            for i in e.get('atlas_ids') or []:
                where = [a for a in ('yidao-v1.3', 'atlas-v9.1') if i in index[a]]
                if not where:
                    problems.append(f'{pid}: atlas id in neither atlas: {i}')
                    continue
                ids.append({'atlas': where[0], 'id': i})
            p = {
                'id': pid,
                'tradition': tradition(s, e),
                'work': e.get('tradition', ''),
                'source': src,
                'locator': fix.get('locator', e.get('locator', '')),
                'fragments': fix.get('fragments', e['fragments']),
                'kind': fix.get('kind', e['kind']),
                'declarations': e.get('declarations', []) + fix.get('declarations_add', []),
                'records': e.get('records', []) + fix.get('records_add', []),
                'atlas_ids': ids,
                'relational': e.get('relational', ''),
                'reading': e['reading'],
                'reading_en': e.get('reading_en', ''),
                'mapper': s,
            }
            for k in ('layer', 'variants', 'gap'):
                if e.get(k):
                    p[k] = e[k]
            if fix.get('gap_closed') and 'gap' in p:
                p['gap'] = dict(p['gap'], closed=fix['gap_closed'])
            if 'reading' in fix:
                p['reading'], p['reading_en'] = fix['reading'], fix['reading_en']
            for old, new in fix.get('reading_sub', []):
                if old not in p['reading']:
                    problems.append(f'{pid}: reading correction does not apply: {old}')
                p['reading'] = p['reading'].replace(old, new)
            for old, new in fix.get('reading_en_sub', []):
                if old not in p['reading_en']:
                    problems.append(f'{pid}: English reading correction does not apply: {old}')
                p['reading_en'] = p['reading_en'].replace(old, new)
            if fix:
                p['corrected'] = fix['why']
            before = (p['declarations'], p['reading'], p['reading_en'])
            p['declarations'] = [RENAMES.get(d, d) for d in p['declarations']]
            p['reading'] = rename_text_r30(rename_text(p['reading'], RENAMES), R30_WINDOWS, R30_WORDS)
            p['reading_en'] = rename_text_r30(rename_text(p['reading_en'], RENAMES), R30_WINDOWS, R30_WORDS)
            if (p['declarations'], p['reading'], p['reading_en']) != before:
                p['corrected'] = (p['corrected'] + '; ' if p.get('corrected') else '') + RENAMED_WHY
            before = (p['records'], p['reading'], p['reading_en'])
            p['records'] = [RECORD_RENAMES.get(r, r) for r in p['records']]
            p['reading'] = rename_records_text(p['reading'], RECORD_RENAMES)
            p['reading_en'] = rename_records_text(p['reading_en'], RECORD_RENAMES)
            if (p['records'], p['reading'], p['reading_en']) != before:
                p['corrected'] = (p['corrected'] + '; ' if p.get('corrected') else '') + RECORDS_RENAMED_WHY
            if not src.startswith('wikisource/'):
                wanted.add(src)
            passages.append(p)

    if args.preserve:
        # Each atlas's own record of where a text came from, by the text's path or name.
        origin = {}
        for a in ATLASES:
            zf, p = archives[a['id']], a['prefix']
            if a['id'] == 'yidao-v1.3':
                records = json.loads(zf.read(p + 'data/model.json'))['sources']
            else:
                records = [json.loads(x) for x in zf.read(p + 'data/sources.jsonl').decode().splitlines() if x.strip()]
            for r in records:
                keys = {r.get('text_path'), r.get('snapshot_path'), f"evidence/texts/{r['id']}.txt"}
                for k in keys - {None}:
                    origin.setdefault((a['id'], k.split('evidence/texts/')[-1]), r)
        files = []
        root = V.SRC
        for rel in sorted(wanted):
            atlas, inner = rel.split('/', 1)
            a = next(x for x in ATLASES if x['id'] == atlas)
            data = archives[atlas].read(a['prefix'] + inner)
            path = root / rel
            if path.exists():
                if path.read_bytes() != data:
                    raise SystemExit(f'preserved file differs from the archive: {rel}')
            else:
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_bytes(data)
        for path in sorted(root.rglob('*')):
            rel = path.relative_to(root).as_posix()
            if path.is_file() and rel not in ('README.md', 'PROVENANCE.json'):
                entry = {'file': rel, 'sha256': hashlib.sha256(path.read_bytes()).hexdigest(), 'bytes': path.stat().st_size}
                if rel.startswith('wikisource/'):
                    page = json.loads(path.read_text())['query']['pages'][0]
                    rev = page['revisions'][0]
                    entry.update({'title': page['title'], 'revid': rev['revid'], 'timestamp': rev['timestamp'],
                                  'form': 'api-response'})
                else:
                    a = next(x for x in ATLASES if x['id'] == rel.split('/', 1)[0])
                    entry.update({'archive_member': a['prefix'] + rel.split('/', 1)[1], 'form': 'archive-member'})
                    r = origin.get((a['id'], rel.split('evidence/texts/')[-1]))
                    if r:
                        entry['atlas_source'] = {k: r[k] for k in ('id', 'title', 'url', 'oldid', 'immutable_url',
                                                                   'edition_note', 'rights_note', 'license_note')
                                                 if r.get(k)}
                files.append(entry)
        prov = json.loads((root / 'PROVENANCE.json').read_text()) if (root / 'PROVENANCE.json').exists() else {}
        prov.update(ABOUT)
        prov['atlases'] = ATLASES
        prov['files'] = files
        (root / 'PROVENANCE.json').write_text(json.dumps(prov, ensure_ascii=False, indent=1) + '\n')
        print(f'{len(files)} files bound')

    for p in passages:
        path = V.SRC / p['source']
        if not path.exists():
            problems.append(f"{p['id']}: no preserved text {p['source']}")
            continue
        text = V.read_text(p['source'])
        for f in p['fragments']:
            if f not in text:
                problems.append(f"{p['id']}: not verbatim in {p['source']}: {f}")
    data = {
        'about': ('The passage map of board item RO: passages of the Chinese sources, each quoted verbatim from a '
                  'text preserved in sources/chinese-classical-texts/ (two atlases built with Codex, and Wikisource '
                  'pages), its kind of relation to the spine, the declarations and records it corresponds to, and '
                  'the atlas records it cites. Built by build_passages.py from the five mappers\' entries '
                  '(mappers/); the readings, relational notes and gaps are AI readings. verify_ro.py checks it.'),
        'kinds': {'agreement': '相合：原文所说之结构，脊柱上有已检查之律与之对应。',
                  'scope': '定域：脊柱给出此句成立的确切范围，并修正其全称形式。',
                  'divergence': '相分：原文所断言者，理论不断言，或与理论的结构相冲突。'},
        'passages': passages,
    }
    out = json.dumps(data, ensure_ascii=False, indent=1) + '\n'
    if args.check:
        if (HERE / 'passages.json').read_text() != out:
            problems.append('passages.json differs from the build: change it through FIXES, not in place')
        else:
            print('passages.json is the build')
    else:
        (HERE / 'passages.json').write_text(out)
        print(f'{len(passages)} passages written')
    for x in problems:
        print('PROBLEM', x)
    return 1 if problems else 0


if __name__ == '__main__':
    sys.exit(main())
