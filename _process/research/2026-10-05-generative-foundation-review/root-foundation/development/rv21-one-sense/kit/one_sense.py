#!/usr/bin/env python3
"""The twenty-first review's item 13: 生生 and 理, each in one sense. Each live passage the item changes, its current
words and the words that replace them; one list serves the check, the edits and the note (NOTE.md), so they cannot drift:
  python3 -B one_sense.py --check    (from the checkout root) every current passage occurs exactly once; writes nothing
  python3 -B one_sense.py --apply    applies every edit, after the same check
  python3 -B one_sense.py --doc      prints the texts as Markdown, for NOTE.md
Texts only: no theorem, record statement, proof or Lean name changes, and text in Ren's own voice is not touched."""
import sys
from pathlib import Path

ROOT = Path.cwd()
B = 'theories/becoming/'
GL = 'GLOSSARY.md'
CH1, CH2, CH6, CH7 = (B + 'chapters/' + n for n in ('01-ROOT.md', '02-MAP.md', '06-CLASSICAL-TEXTS.md',
                                                     '07-SIGNIFICANCE.md'))
OV, OVZ = B + 'THE-THEORY-OF-BECOMING.md', B + 'THE-THEORY-OF-BECOMING.zh.md'
OPZ = B + 'ONE-PAGE.zh.md'
CD = B + 'COLLECTIVE-DIRECTION.md'
CH8 = B + 'chapters/08-METHOD.md'
REC = B + 'results/records/'

EDITS = [
    # (label, path, current, proposed)
    ("生生: the glossary's row for renewal", GL,
     "| renewal, renewal without end (复生, 生生) | a line started by another that goes on; a family that keeps renewing. "
     "生生 also names life in the whole and its continuing generation | "
     "[01 §6](theories/becoming/chapters/01-ROOT.md#renewal-and-grains), [07](theories/becoming/chapters/07-SIGNIFICANCE.md) |",
     "| renewal, renewal without end (复生, `«生生»`) | a line started by another that goes on; the greatest family that "
     "keeps renewing. The grammar's word is always written `«生生»`, as its Lean names write it; it is not the ethics' "
     "生生 (below), and 复生 is not 02's renewal of what a formation draws on | "
     "[01 §6](theories/becoming/chapters/01-ROOT.md#renewal-and-grains) |"),
    ("生生: the glossary's row for 02's renewal", GL,
     "| renewal, consumption | of a formation along a run: what it draws on is given back, or used up | "
     "[02](theories/becoming/chapters/02-MAP.md#renewal) |",
     "| renewal, consumption | of a formation along a run: what it draws on is given back, or used up. Not 复生, a line "
     "started by another (01 §6) | [02](theories/becoming/chapters/02-MAP.md#renewal) |"),
    ("生生: the glossary's row for generation", GL,
     "and it is not 生生: it can go on at two orders while what can form only returns",
     "and it is not 生生, whose English gloss \"continuing generation\" (07 §2) says 生发, not this sense: generation "
     "can go on at two orders while what can form only returns"),
    ("生生: the glossary's row for the ethics' word", GL,
     "| living significance | what the condition yields: the significance of what lives on | "
     "[07 §3](theories/becoming/chapters/07-SIGNIFICANCE.md#living-significance) |",
     "| living significance | what the condition yields: the significance of what lives on | "
     "[07 §3](theories/becoming/chapters/07-SIGNIFICANCE.md#living-significance) |\n"
     "| 生生 (*shēngshēng*) | life in the whole and its continuing generation (生发) [AI reading, D1]. T8 argues that "
     "it is the way for life, compared by widening what can form, with the continuation condition for scope and C for "
     "order. Neither the grammar's `«生生»` (renewal without end), nor 02's generation (生成) as such, which allows "
     "loss, nor any new organization. Read as widening, on a course's moments and under premises of deciding, it is "
     "generation of the possible that loses none of it [AI reading, D45] | "
     "[07 §2](theories/becoming/chapters/07-SIGNIFICANCE.md#order) |"),
    ("生生: 01 §6, the definition", CH1,
     "**Definition.** Renewal without end (生生) holds of `x`",
     "**Definition.** Renewal without end (`«生生»`) holds of `x`"),
    ("生生: 01 §6, reading D1", CH1,
     "**Reading** [AI reading, D1]. In the grammar 生生 names only renewal without end. The theory reads 生生 as life in "
     "the whole",
     "**Reading** [AI reading, D1]. In the grammar `«生生»` names only renewal without end. The theory reads plain "
     "生生, without guillemets, as life in the whole"),
    ("生生: 01 §6, reading D1's gloss marked", CH1,
     "continuing generation, generation generating generation: what forms",
     "continuing generation, generation generating generation (生发, not 02's 生成): what forms"),
    ("生生: 01 §6, reading D1's last clause (GW's text, carried at its owner's word)", CH1,
     "is renewal of what can form that loses none of it",
     "is generation of what can form that loses none of it"),
    ("生生: 02 §1, the row on renewing into under the one", CH2,
     "renewal without end (生生) of [the root](01-ROOT.md#renewal-and-grains)",
     "renewal without end (`«生生»`) of [the root](01-ROOT.md#renewal-and-grains)"),
    ("生生: 06 §二, the two senses of 「生生」", CH6,
     "本理论所用的“生生”是整体中的生命及其继续生成（[第七章](07-SIGNIFICANCE.md)），不是后者。",
     "本理论所用的“生生”是整体中的生命及其持续的生发（[第七章](07-SIGNIFICANCE.md)），不是后者；文法之 `«生生»` 只名"
     "无尽之复生（[第一章 §6](01-ROOT.md#renewal-and-grains)），是另一词。"),
    ("生生: 06 §三, the definition read", CH6,
     "生生是持续复生之最大之族，息是其归纳之对偶",
     "`«生生»` 是持续复生之最大之族，息是其归纳之对偶"),
    ("生生: 06 §三, read along renewing into", CH6,
     "在“一”之下沿复生至而读，生生即某一支上之延，息即诸支皆尽",
     "在“一”之下沿复生至而读，`«生生»` 即某一支上之延，息即诸支皆尽"),
    ("生生: 06 §十, the corpus's words in the nine sentences", CH6,
     "无损之复返（有不息而无生生）",
     "无损之复返（语料所谓“不息”而无“生生”）"),
    ("生生: 07 §2, the gloss marked at its home", CH7,
     "names life in the whole and its continuing generation. Widening compares it",
     "names life in the whole and its continuing generation (生发, not 02's 生成). Widening compares it"),
    ("生生: 07 §2, the reading on causal sets", CH7,
     "In the grammar 生生 names only renewal without end, which holds on no configuration",
     "In the grammar `«生生»` names only renewal without end, which holds on no configuration"),
    ("生生: 08, the table of words in one sense", CH8,
     "| generation | 02's 生成: a pattern going on through carrying renewal; in 07, 生生 as life in the whole and its "
     "continuing generation | arising (records titled with \"generation\" for arising are stated as laws of arising) |",
     "| generation | 02's 生成: a pattern going on through carrying renewal | arising (records titled with \"generation\" "
     "for arising are stated as laws of arising); 生生 (07), which generation at two orders does not give, and whose "
     "English gloss in 01 §6 and 07 §2 (\"continuing generation\", \"generation generating generation\") says 生发, not "
     "this sense |"),
    ("生生: COLLECTIVE-DIRECTION, the witness", CD,
     "renewal without end holds from moment `0` (`RaisedEveryOther.both`): widening relative to what is held and 生生不息 "
     "can hold together.",
     "renewal without end holds at every even moment (`«生生»`, `RaisedEveryOther.renews_without_end`), so moment `0` "
     "does not cease (`«生生不息»`, `RaisedEveryOther.both`): widening relative to what is held and renewal without end "
     "can hold together."),
    ("生生: the overview, §1", OV,
     "In the grammar 生生 names only renewal without end; the theory reads it as life in the whole",
     "In the grammar `«生生»` names only renewal without end; the theory reads plain 生生, without guillemets, as life "
     "in the whole"),
    ("生生: the overview (Chinese edition), §1", OVZ,
     "在文法中，生生只指无尽的复生；本理论把它读作整体中的生命",
     "在文法中，`«生生»` 只指无尽的复生；本理论把不加 «» 的生生读作整体中的生命"),
    ("生生: the one page (Chinese edition), the line of the argument", OPZ,
     "即整体之中的生命及其不断的生成",
     "即整体之中的生命及其持续的生发"),
    ("理: the glossary's row", GL,
     "| 理 (*lǐ*) | a lumping that models structure and change at once | "
     "[03](theories/becoming/chapters/03-KNOWING.md#li) |",
     "| 理 (*lǐ*) | a lumping that models structure and change at once: one the step goes alike across (`«同行»`). Where "
     "the step's successor is fixed (`«定后»`), a class's [core](theories/becoming/chapters/01-ROOT.md#constancy-and-core) is a "
     "理; where every occurrence also has a successor, the coarsest one inside the class, its 理. The root's names on "
     "cores that write 理 (`«守理则不穷»`, `«亡前理变»`, `«足以定理»`; `«有亡之线两端理异»` takes a class) mean the core "
     "of the relation they are stated for, shown a 理 where it is a class and the successor fixed | "
     "[03](theories/becoming/chapters/03-KNOWING.md#li) |"),
    ("理: 01 §4, before the theorem that writes 理", CH1,
     "<a id=\"r-a-regularity-kept-and-changed\"></a>",
     "**Theorem** (root; composed from the declarations it cites, with a witness, checked outside the package). *The "
     "core and 理.* "
     "Let `E` be a class. Where the step's successor is fixed (`«定后»`), the core of `E` is a class inside `E` (`«根»`, "
     "`«核为类»`) that the step goes alike across (`«有常定后则同行»`; going alike, `«同行»`, is "
     "[§7](#r-master-laws-on-the-grammar)'s): a 理 in [knowing's](03-KNOWING.md#li) sense, read relationally. Where "
     "every occurrence also has a successor, every class inside `E` that the step goes alike across lies inside the "
     "core (`«同行遍后则有常»` with `«根»`), so the core is the coarsest such class, the 理 of `E`. Off a fixed "
     "successor the core need not go alike: where one occurrence steps to two, the identity is a class whose core "
     "relates that occurrence to itself and not its two successors to each other, so the step does not go alike across "
     "it ([check](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21-one-sense/review/CoreAndLi.lean), the composition a declaration proposed for "
     "`Becoming.GrammarLaws`). Of the names below that write 理, `«守理则不穷»`, `«守理之线不亡»`, `«亡前理变»` and the "
     "definition `«足以定理»` are stated for the core of every relation `E`, and `«有亡之线两端理异»` and "
     "`«合有常则足以定理»` for classes. Where `E` is a class and the successor is fixed they name a 理, with a successor "
     "everywhere the 理 of `E`; elsewhere their 理 is the core.\n\n"
     "<a id=\"r-a-regularity-kept-and-changed\"></a>"),
    ("理: 06 §八, 理 and 文", CH6,
     "理自文读出，即守值而承载律之最粗归并，所并恰是文同之状（[第三章](03-KNOWING.md#r-the-split-that-makes-sense)），只在此义。",
     "文之理自文读出，即守值而承载律之最粗归并，所并恰是文同之状（[第三章](03-KNOWING.md#r-the-split-that-makes-sense)）。"
     "它是[第三章之理](03-KNOWING.md#li)（步于其上同行之归并）中守值之最粗者，即值之类之理"
     "（[第一章 §4](01-ROOT.md#constancy-and-core)）；“文理”只在此义。"),
    ("理: 06 §八, 文同 and 文之理", CH6,
     "文同与理在根之文法中同为一个结构（值之类沿律之步的核）",
     "文同与文之理（值之类之理）在根之文法中同为一个结构（值之类沿律之步的核）"),
]

# Wording-only corrections in six records, each with one history note: the record's claim, premises and scope unchanged.
# Records write «» bare, so these do too. A path names the field (laws and items counted from 0 here; record pages and the
# notes count from 1).
def note(en, zh):
    return {"en": "30 October 2026: wording only, for the twenty-first review's item 13 (" + en,
            "zh": "2026年10月30日：仅措辞，依第二十一次审查第 13 项（" + zh}


RECORD_EDITS = [
    # (record id, path to the bilingual field, language, current, proposed, history note)
    ('continuation-relative-to-a-class', ('laws', 11), 'en',
     "does not cease (生生不息).", "does not cease («生生不息»).",
     note("生生 in one sense): the theorem's name written «生生不息» in law 12, in English and Chinese, and the grammar's "
          "word «生生» in the Chinese of laws 8 and 12 and of the third item it does not show; nothing the record states "
          "changed.",
          "生生一义）：律 12 之定理名写作 «生生不息»，中英文皆然；律 8、12 与所不表明之第三项之中文中，文法之词写作 «生生»；"
          "记录所述无改变。")),
    ('continuation-relative-to-a-class', ('laws', 11), 'zh',
     "生生是每一员皆复生至族中一员之最大之族，在此族中者不息（生生不息）。",
     "«生生» 是每一员皆复生至族中一员之最大之族，在此族中者不息（«生生不息»）。", None),
    ('continuation-relative-to-a-class', ('laws', 7), 'zh',
     "生生是最大之族，其每一员都复生出一条再到此族之线；生生必复生。",
     "«生生» 是最大之族，其每一员都复生出一条再到此族之线；«生生» 必复生。", None),
    ('continuation-relative-to-a-class', ('does_not_show', 2), 'zh',
     "生生分开维持生命之更新与毁灭之更替。", "«生生» 分开维持生命之更新与毁灭之更替。", None),
    ('generation-and-degeneration-at-two-grains', ('laws', 11), 'zh',
     "在“一”之下沿复生至而读，生生即某一支上之延", "在“一”之下沿复生至而读，«生生» 即某一支上之延",
     note("生生 in one sense): the grammar's «生生» marked in the Chinese of law 12, as 06 §三 marks it; nothing the record "
          "states changed.",
          "生生一义）：律 12 之中文中文法之 «生生» 加标，如第六章 §三；记录所述无改变。")),
    ('what-can-be-born-next', ('laws', 21), 'zh', "无构型生生不息。", "无构型 «生生»。",
     note("生生 in one sense): the Chinese of laws 22 and 23 and of the dependency detail listing the grammar's names writes "
          "«生生» (renewal without end), as the English and the theorems state, where it wrote 生生不息; nothing the record "
          "states changed.",
          "生生一义）：律 22、23 与列出文法诸名之依赖说明之中文写作 «生生»（无尽之复生），如英文与定理所述，原作生生不息；"
          "记录所述无改变。")),
    ('what-can-be-born-next', ('laws', 22), 'zh', "任何类下皆无生生不息者", "任何类下皆无 «生生» 者", None),
    ('what-can-be-born-next', ('laws', 22), 'zh', "1 生生不息（chainLimit_renews", "1 «生生»（chainLimit_renews", None),
    ('what-can-be-born-next', ('dependencies', 3, 'detail'), 'zh', "续及其诸位、息与生生不息。", "续及其诸位、息与 «生生»。",
     None),
    ('where-the-possible-grows', ('laws', 12), 'zh', "生成而无生生。隔步提升之规则上，每一时刻全生成，与生生及持续扩大并存。",
     "生成而无 «生生»。隔步提升之规则上，每一时刻全生成，与 «生生» 及持续扩大并存。",
     note("生生 in one sense): the grammar's «生生» and the theorem «生生不息» marked in the Chinese of laws 13 and 24 and of "
          "the dependency detail listing the grammar's names, as the English writes them; nothing the record states "
          "changed.",
          "生生一义）：律 13、24 与列出文法诸名之依赖说明之中文中，文法之 «生生» 与定理 «生生不息» 加标，如英文；"
          "记录所述无改变。")),
    ('where-the-possible-grows', ('laws', 23), 'zh', "相对于所持守者之增长与生生并存", "相对于所持守者之增长与 «生生» 并存",
     None),
    ('where-the-possible-grows', ('laws', 23), 'zh', "每一偶数时刻皆生生，故时刻 0 不息（生生不息）",
     "每一偶数时刻皆 «生生»，故时刻 0 不息（«生生不息»）", None),
    ('where-the-possible-grows', ('dependencies', 5, 'detail'), 'zh', "于彼复生、息或生生。", "于彼复生、息或 «生生»。", None),
    ('what-keeping-widening-needs', ('laws', 14), 'zh', "生生于种类粒度成立。", "«生生» 于种类粒度成立。",
     note("生生 in one sense): the grammar's «生生» marked in the Chinese of law 15 and of the second item it does not show, "
          "as the English and KindRelay.renews_without_end state; nothing the record states changed.",
          "生生一义）：律 15 与所不表明之第二项之中文中文法之 «生生» 加标，如英文与 KindRelay.renews_without_end 所述；"
          "记录所述无改变。")),
    ('what-keeping-widening-needs', ('does_not_show', 1), 'zh', "二阶之全生成与生生成立", "二阶之全生成与 «生生» 成立", None),
    ('projection-carrying-a-law', ('correspondence',), 'en',
     "reading 理 as a projection (Becoming.Experiment), this says when 理 carries a law.",
     "reading a model as a projection (Becoming.Experiment), this says when it carries a law: when it is a 理.",
     note("理 in one sense): the correspondence reads a model, not 理, as a projection, since a 理 is a lumping the step "
          "goes alike across; nothing the record states changed.",
          "理一义）：对应改为读模型（而非理）为投影，因理是步于其上同行之归并；记录所述无改变。")),
    ('projection-carrying-a-law', ('correspondence',), 'zh',
     "读 理 为投影（Becoming.Experiment），它何时承载规律由此给出。",
     "读模型为投影（Becoming.Experiment），它何时承载规律、即何时为理，由此给出。", None),
]

HERE = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21-one-sense'


def check():
    for label, path, old, new in EDITS:
        text = (ROOT / path).read_text(encoding='utf-8')
        n = text.count(old)
        assert n == 1 or new in text, (label, path, n)
    records(False)


def records(write):
    """The wording-only record corrections: each current phrase occurs once in its field (or the new one is there)."""
    import json
    from datetime import datetime, timezone
    by_id = {}
    for edit in RECORD_EDITS:
        by_id.setdefault(edit[0], []).append(edit)
    for rid, edits in by_id.items():
        path = ROOT / REC / (rid + '.json')
        raw = path.read_text(encoding='utf-8')
        record = json.loads(raw)
        changed = False
        for _, where, lang, old, new, note in edits:
            obj = record
            for key in where:
                obj = obj[key]
            text = obj[lang]
            assert text.count(old) == 1 or new in text, (rid, where, lang)
            if old in text and new not in text:
                obj[lang] = text.replace(old, new, 1)
                changed = True
                if note:
                    record['history'].append(note)
        if write and changed:
            record['reviewed_at_utc'] = datetime.now(timezone.utc).replace(microsecond=0).isoformat()
            path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + ('\n' if raw.endswith('\n') else ''),
                            encoding='utf-8')
    return len(by_id)


def apply():
    check()
    by_path = {}
    for label, path, old, new in EDITS:
        by_path.setdefault(path, []).append((label, old, new))
    for path, edits in by_path.items():
        p = ROOT / path
        text = p.read_text(encoding='utf-8')
        for label, old, new in edits:
            if old in text and new not in text:
                text = text.replace(old, new, 1)
        p.write_text(text, encoding='utf-8')
    n = records(True)
    print(f'applied: {len(EDITS)} edits in {len(by_path)} files, and wording in {n} records')


def rebase(passage, path):
    """The passage's relative links, written for the page at `path`, rewritten to resolve from NOTE.md's folder."""
    import os.path
    import re

    def one(m):
        target = m.group(2)
        if re.match(r'[a-z]+:', target):
            return m.group(0)
        file, _, anchor = target.partition('#')
        where = os.path.normpath(os.path.join(os.path.dirname(path), file)) if file else path
        return f'{m.group(1)}({os.path.relpath(where, HERE)}{"#" + anchor if anchor else ""})'
    return re.sub(r'(\[[^\]]*\])\(([^)\s]+)\)', one, passage)


def doc():
    out = []
    for label, path, old, new in EDITS:
        link = '../../../../../../' + path
        quote = lambda s: '\n'.join('> ' + line for line in rebase(s, path).split('\n'))
        out += [f'### {label}', '', f'[{Path(path).name}]({link}). Current:', '', quote(old), '',
                'Proposed:', '', quote(new), '']
    print('\n'.join(out))


if __name__ == '__main__':
    {'--check': check, '--apply': apply, '--doc': doc}[sys.argv[1]]()
    if sys.argv[1] == '--check':
        print(f'checked: {len(EDITS)} edits and {len(RECORD_EDITS)} record phrases, each current passage found exactly once')
