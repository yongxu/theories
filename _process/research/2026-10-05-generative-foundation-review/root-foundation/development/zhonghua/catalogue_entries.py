"""Add the two ZH chapters to the reading catalogue (arguments-a-l / arguments-m-z), in the files' own format
(sorted by id, indent 2), and re-point the RO chapter's entry after its pointer line: python3 -I catalogue_entries.py"""
import json, hashlib
sha = lambda p: hashlib.sha256(open(p, 'rb').read()).hexdigest()
K = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua'
CH = 'theories/becoming/chapters/CIVILIZATION-THOUGHT-AND-BECOMING.md'
ED = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING-ZHONGHUA.md'
RO = 'theories/becoming/chapters/CHINESE-SOURCES-AND-BECOMING.md'
a = {"id": "civilization-thought-and-becoming", "source": CH,
     "title_zh": "《中华思想脉络》与变化论：逐条对应、古典之名与论题的检验",
     "title_en": "《中华思想脉络》 and the theory of becoming: every judgment mapped, the classical names, the thesis tested",
     "category": "classical-comparison",
     "status": "全部判断已对应并检查；无新 Lean / Every judgment mapped and checked; no new Lean",
     "argument_zh": "《中华思想脉络》v1.0 的 5,673 条完整判断逐条读过：3,499 条关乎理论之结构，各落一处，成 1,300 个已检查条目（相合 453、定域 647、相分 200）。“一元、关系、动态”之论题按域与按时代检验：在根上成立，全称形式大多需要定域，作为每一体系之性质不成立。由这些文字定出古典之名。",
     "argument_en": "Every one of the 5,673 complete judgments of 《中华思想脉络》 v1.0 is read: 3,499 bear on a structure of the theory and each lies in one place, in 1,300 checked entries (453 agreements, 647 exact scopes, 200 divergences). The thesis that the system is one, relational and dynamic is tested by domain and by era: it holds at the root, its universal forms mostly need a scope, and it fails as every system's property. The classical names are fixed from these texts.",
     "significance_zh": "RO 之选读扩展为一部图谱之全读；相分与四层保留，使原典能检验理论；古典之名有其出处与所不带之义。",
     "significance_en": "RO's selection becomes the full reading of one atlas; divergences and the four layers are kept so the texts can test the theory; the classical names carry their witnesses and what they do not carry.",
     "scope_zh": "读法与名为 AI 之读与约定（D62）；不新增 Lean；不说作者意谓这些律；未与刻本对校；无出处之名的先秦用例未全经检查。",
     "scope_en": "Readings and names are the AI's readings and conventions (D62); no new Lean; not a claim that the authors meant these laws; not collated with printed editions; the pre-Qin use of names without a witness not all checked.",
     "next_zh": "建议：古典文字提出之缺口各自认领并写成 Lean；五处已判之类别写入 RO 与易传之对应；独立审读。",
     "next_en": "Proposed: the gaps the texts raise, each claimed and written in Lean; the five decided kinds written into RO's and the 易传 map; an independent review.",
     "lean": [],
     "evidence": [K + '/passages.json', K + '/coverage.json', K + '/verify_zh.py', 'sources/civilization-thought-v1.0/PROVENANCE.json',
                  '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'],
     "source_sha256": sha(CH)}
z = {"id": "the-theory-of-becoming-zhonghua", "source": ED,
     "title_zh": "变化论（中华本）", "title_en": "The Theory of Becoming in classical Chinese names (中华本)",
     "category": "synthesis",
     "status": "以古典之名陈述理论；同一律、同一检查；无新 Lean / The theory stated in classical names; same laws and checks; no new Lean",
     "argument_zh": "理论以 447 个古典之名陈述：凡例、十六篇与论纲，393 條，每条有经（浅近文言）、说（现代汉语）与证（Lean 声明与记录），篇末列相对照之古典文字。从一个关系之展开说起，至感、识、知、名、择、环、传、群、顾与权；伦理之两个设分立，凡续皆有顾定范围，以广为愈定次序。",
     "argument_en": "The theory stated in 447 classical names: 凡例, sixteen 篇 and 论纲, 393 條, each with 經 (plain classical Chinese), 說 (modern Chinese) and 證 (Lean declarations and records), classical passages set beside each 篇. It runs from one relational unfolding to coupling, knowing, names, selection, loops, passing, groups, significance and judgment; the ethics' two premises kept apart, the continuation condition for scope and calling widening better for order.",
     "significance_zh": "理论有一个中文之本，用一套受检之古典词表，不是英文本之译；英文本与现代汉语版不变。",
     "significance_en": "The theory has a Chinese edition in one checked classical vocabulary, not a translation; the English chapter and its modern Chinese edition are unchanged.",
     "scope_zh": "同英文本之律与条件；名为约定（D62）；论纲之地位见其篇首；未经人之通读。",
     "scope_en": "The laws and conditions of the English chapter; the names are conventions (D62); the 论纲's standings as its preface states; not read through by a person.",
     "next_zh": "建议：独立通读；随理论之新律增补各篇。",
     "next_en": "Proposed: an independent reading; each 篇 extended as the theory gains laws.",
     "lean": [],
     "evidence": [K + '/work/names-decisions.tsv', K + '/book.py', K + '/finish.py', K + '/verify_zh.py'],
     "source_sha256": sha(ED)}
for f, e in [('theories/becoming/results/data/arguments-a-l.json', a), ('theories/becoming/results/data/arguments-m-z.json', z)]:
    d = [x for x in json.load(open(f, encoding='utf-8')) if x['id'] != e['id']]
    for x in d:
        if x['id'] == 'chinese-sources-and-becoming':
            x['source_sha256'] = sha(RO)
    d.append(e)
    d.sort(key=lambda x: x['id'])
    open(f, 'w', encoding='utf-8').write(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('catalogue entries written')
