#!/usr/bin/env python3
"""Write ZH's record civilization-thought-on-the-spine: python3 -I make_record.py STUDY_SECTION D_NUMBER

verify_zh.py must pass with both chapters in place, and the study section and the decision must exist. No Lean is
added: the record is an assessment, reviewed and scoped, whose evidence is the checked map, the name table and their
check. Rewrites the record if it exists (the history keeps the first date)."""
import collections
import datetime
import hashlib
import json
import re
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
KIT = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
DC = '_process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md'
RECORDS = ROOT / 'theories/becoming/results/records'
CHAPTER = 'theories/becoming/chapters/CIVILIZATION-THOUGHT-AND-BECOMING.md'
EDITION = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING-ZHONGHUA.md'
RO = 'theories/becoming/chapters/CHINESE-SOURCES-AND-BECOMING.md'
SOURCE = 'sources/15-codex-theory-conversations/2026-10-19-zhonghua-edition.md'
PROVENANCE = 'sources/civilization-thought-v1.0/PROVENANCE.json'
ID = 'civilization-thought-on-the-spine'
section, d = sys.argv[1], sys.argv[2]
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
ASK = ('“请把中华文化中所有在theory of becoming上有映射，或者对应的，找出来，并寻找到非同于英文系统的一套符号系统，这个系统存在于古中文之中，'
       '在历史长河中一直在演变和迭代……现在不用改英文版本，我们只是做中华版本，用中华的体系和符号系统 - 它自然就是一元的，关系的，动态的……'
       '同时，请把我做的这个脉络，也整合进我们的theories”')


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


check = subprocess.run([sys.executable, '-I', str(HERE / 'verify_zh.py')], capture_output=True, text=True)
assert check.returncode == 0, check.stdout + check.stderr
assert (ROOT / EDITION).exists() and (ROOT / CHAPTER).exists()
assert re.search(rf'^## {section}\. ', (ROOT / STUDY).read_text(), re.M), section
assert f'| D{d} | the readings of 《中华思想脉络》 on the spine' in (ROOT / DC).read_text(), d
P = json.loads((HERE / 'passages.json').read_text())['clusters']
entries = [e for c in P.values() for e in c['entries']]
kinds = collections.Counter(e['kind'] for e in entries)
cov = json.loads((HERE / 'coverage.json').read_text())['verdicts']
flagged = sum(v['c'] != '-' for v in cov.values())
names = sum(1 for _ in open(HERE / 'work/names-decisions.tsv', encoding='utf-8')) - 1
notad = sum(1 for _ in open(HERE / 'work/symbols-not-adopted.tsv', encoding='utf-8')) - 1
decls = len({x for e in entries for x in e['declarations']})
records = sorted({r for e in entries for r in e['records']})
files = len(json.loads((ROOT / PROVENANCE).read_text())['files'])
ANCHOR = f'{STUDY}#{section}-中华思想脉络-on-the-spine-and-the-中华本-zh'
old = RECORDS / f'{ID}.json'
first = json.loads(old.read_text())['history'][0] if old.exists() else None
n, a, s, v = len(entries), kinds['agreement'], kinds['scope'], kinds['divergence']

record = {
    'schema_version': 2,
    'id': ID,
    'title': {'en': '《中华思想脉络》 on the spine, and the theory in classical names',
              'zh': '《中华思想脉络》在脊柱上，与以古典之名所写的理论'},
    'kind': 'assessment',
    'status': 'reviewed-scoped',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': (f'Every one of the {len(cov):,} complete judgments of 《中华思想脉络》 v1.0 is read against the spine: '
               f'{flagged:,} bear on a structure of the theory and each lies in exactly one place, as one of {n:,} '
               f'checked entries ({a} agreements, {s} exact scopes, {v} divergences), a parallel of one, or set aside '
               f'with its reason. The relational start holds across the traditions and most at the earliest layer; '
               f'universal forms mostly need a scope; divergences fall on the four non-relational layers and on claims a '
               f'checked law refutes. {names} classical names, one per concept and each anchored on the current spine, '
               f'state the theory in the 中华本《变化论》.'),
        'zh': (f'《中华思想脉络》v1.0 的 {len(cov):,} 条完整判断逐条对照脊柱读过：{flagged:,} 条关乎理论的某一结构，各自恰好落在一处，'
               f'或是 {n:,} 个已检查条目之一（相合 {a}、定域 {s}、相分 {v}），或与一个条目并列，或写明理由而不取。关系的起点贯穿诸传统，'
               f'在最早的一层最强；全称形式大多需要定域；相分落在四种非关系之层，以及一条已检查之律所否定的断言上。{names} 个古典之名，'
               f'每个概念一个、各锚定在现行脊柱上，在中华本《变化论》中陈述这一理论。')},
    'hypotheses': [{
        'en': (f'No Lean and no premise is added: each entry is tied to audited declarations and records as they stand; '
               f'its kind, its reading and the names are the AI\'s (D{d}). A passage counts as relational when it reads '
               f'the relation first and lets the terms differentiate within it, not from a prior ground, a nature or value '
               f'fixed before relations, a will or single centre, or a contest or rank: a method requirement, not a proof '
               f'of the ontology. The names are a code formed among the theory\'s users, constrained by the attested '
               f'senses, not a sense recovered from history.'),
        'zh': (f'不新增 Lean，不加前提：每个条目对应到现有的已审计声明与记录，其关系类别、读法与名都是 AI 的（D{d}）。“关系的”以方法的要求检验：'
               f'先读关系，让诸项在其中分化；其反面是先在的根据、先于关系而定的性或价值、意志或单一中心、争胜与等级。这是方法的要求，'
               f'不是本体论的证明。名是理论的用者之间形成的码，受所见之义约束，不是从历史中复原的意义。')}],
    'does_not_show': [
        {'en': ('That any passage is true as stated, or that its authors meant these laws; agreement means the spine '
                'has a law of that structure, often under conditions the reading names.'),
         'zh': '任何一段如所说那样为真，或其作者意谓这些律；相合是说脊柱上有结构相同之律，常在读法写明的条件下。',
         'kind': 'correspondence'},
        {'en': ('That the language or the tradition is relational by nature: the relational start is a dominant thread '
                'strongest at the earliest layer, not a property of every system; the distribution by era is of this '
                'corpus, whose later texts were chosen for their debates on ground and nature.'),
         'zh': '语言或传统天然是关系的：关系的起点是一条在最早一层最强的主导线索，不是每一体系的性质；按时代的分布是这一语料的，'
               '其后世文本多为本原与心性之争而选。',
         'kind': 'non-implication'},
        {'en': ('That the classical names recover what the texts meant, or that names without a recorded witness were '
                'in pre-Qin use: 94 classical words in the table carry no checked quotation.'),
         'zh': '古典之名复原了文本之意，或未录出处之名在先秦已有用例：名表中 94 个古名与复名没有经核对的引文。',
         'kind': 'scope'},
        {'en': ('That a divergence of standing (a text asserting what the theory gives only under the continuation '
                'condition) shows the text wrong; the theory asserts no ethical axiom.'),
         'zh': '地位的相分（原文断言理论只在延续条件之下给出者）说明原文错了；理论不断言伦理公理。',
         'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': ['no-ethical-premise', 'formal-not-empirical', 'names-provisional',
                            'omission-not-refutation', 'nondual-method-not-proof'],
    'validation_scope': {
        'en': (f'verify_zh.py passes: the import ({files} files bound by SHA-256), one triage verdict per judgment, every '
               f'flagged judgment placed once, every fragment verbatim in its frozen text, {decls} declarations in the '
               f'current receipt, {len(records)} records, the name table (anchors current, quotations exact, no two names '
               f'alike once simplified), and both chapters\' quotations, declarations, record links and generated tables. '
               f'Each entry had three readings (mapper, reviser on current main, independent checker); the 中华本\'s 篇 '
               f'were drafted and reviewed adversarially into exact edits. All readers were AI; no collation with a '
               f'printed edition.'),
        'zh': (f'verify_zh.py 通过：导入（{files} 个文件以 SHA-256 绑定）、每条判断一个分拣裁定、每条所标判断恰落一处、每个片段在其冻结原文中'
               f'逐字可见、{decls} 个声明在现行回执中、{len(records)} 份记录、名表（锚为现行之名、引文逐字、简化后无重），以及两章的引文、'
               f'声明、记录链接与生成之表。每个条目经三读（映射者、以现行主干重读的修订者、独立检查者）；中华本各篇起草后经对抗审读改为'
               f'精确修改。读者都是 AI；未与刻本对校。')},
    'next_delta': {
        'en': ('The gaps the texts raise, each to be claimed before it is written: a conjunctive or graded whole; '
               'saturation of a coupling by what it has carried; one-sided and local regulation; equal division; '
               'copying growth; witnesses that are functions of one another; measures of a juncture; a pool weighted '
               'by share. Then the three RO and 易传 kinds decided in the chapter written into those maps.'),
        'zh': ('古典文字提出的缺口，各先认领再写：合取或分级的整体；耦合随已传之量而饱和；单侧与局部的调节；均分；抄录之增；'
               '互为函数的见证；机之度量；按份额加权的池。然后把本章判定的 RO 与易传三处类别写入那两份对应。')},
    'correspondence': {
        'en': (f'Ren, 19 October 2026, after extending his database to Chinese culture: {ASK} (provenance, not warrant). '
               f'The chapter places the 脉络 in the theory and tests the thesis judgment by judgment; the 中华本 states '
               f'the theory in the classical names, with 經, 說 and 證 for each law and the classical passages set '
               f'beside it. Reading (the AI\'s, D{d}): the thesis holds at the root and in most mapped judgments, '
               f'needs a scope in its universal forms, and fails as a property of every system.'),
        'zh': (f'Ren，2026年10月19日，把数据库扩展到中华文化之后说：{ASK}（来历，不是根据）。本章把脉络安放在理论中，并逐条检验论题；'
               f'中华本以古典之名陈述理论，每条律有经、说、证，并列出相对照的古典文字。读法（AI 的，D{d}）：论题在根上与大多数已对应的'
               f'判断中成立，其全称形式需要定域，作为每一体系的性质不成立。')},
    'canonical_source': CHAPTER,
    'aliases': ['《中华思想脉络》 on the spine', '中华思想脉络', '中华本', '变化论', 'the 中华 edition',
                'the theory in classical names', '古典之名'],
    'dependencies': [
        {'id': 'chinese-sources-on-the-spine', 'relation': 'interpretive',
         'detail': {'en': 'Extends the RO map from 248 chosen passages to every judgment of the 脉络, with the same three kinds and four layers.',
                    'zh': '把 RO 的对应从选读的 248 段扩展到脉络的全部判断，用同样的三种关系与四层。'}},
        {'id': 'a-code-formed-between-formations', 'relation': 'interpretive',
         'detail': {'en': 'Why the name table is a convention among users: a code forms between formations (约定俗成).',
                    'zh': '名表为何是用者之间的约定：码在形成之间形成（约定俗成）。'}}],
    'related': [{'id': r, 'detail': {'en': 'Its 易传 entries keep these maps\' correspondences.',
                                     'zh': '其易传条目沿用这些对应。'}}
                for r in ('hexagrams-on-the-spine', 'hexagram-arrangements-and-laws') if (RECORDS / f'{r}.json').exists()],
    'references': [
        {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)},
        {'path': EDITION, 'role': 'statement', 'sha256': sha(EDITION)},
        {'path': f'{KIT}/passages.json', 'role': 'integration', 'sha256': sha(f'{KIT}/passages.json')},
        {'path': f'{KIT}/coverage.json', 'role': 'integration', 'sha256': sha(f'{KIT}/coverage.json')},
        {'path': f'{KIT}/work/names-decisions.tsv', 'role': 'integration', 'sha256': sha(f'{KIT}/work/names-decisions.tsv')},
        {'path': f'{KIT}/verify_zh.py', 'role': 'integration', 'sha256': sha(f'{KIT}/verify_zh.py')},
        {'path': f'{KIT}/build_tables.py', 'role': 'integration', 'sha256': sha(f'{KIT}/build_tables.py')},
        {'path': STUDY, 'role': 'review', 'sha256': sha(STUDY)},
        {'path': RO, 'role': 'statement', 'sha256': sha(RO)},
        {'path': PROVENANCE, 'role': 'provenance', 'sha256': sha(PROVENANCE)},
        {'path': SOURCE, 'role': 'provenance', 'sha256': sha(SOURCE)}],
    'proof_bindings': [],
    'progress': [{'en': 'What the full reading found, the name table, the 中华本, and the gaps the texts raise.',
                  'zh': '全读所得、名表、中华本，以及古典文字提出的缺口。', 'source': ANCHOR}],
    'history': [first or {
        'en': (f'21 October 2026: added (ZH), on Ren\'s request for a 中华 edition and for the 脉络 to be joined to the '
               f'theories; study section {section}; readings D{d}.'),
        'zh': f'2026年10月21日：新增（ZH），按 Ren 关于中华本、并把脉络整合进理论的要求；研究第 {section} 节；读法 D{d}。'}],
}
old.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n')
print(old.relative_to(ROOT))
