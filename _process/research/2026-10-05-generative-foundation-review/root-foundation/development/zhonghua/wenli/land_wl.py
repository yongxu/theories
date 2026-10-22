"""WL's landing texts, from the worktree root on a branch rebased onto main: python3 -I <kit>/wenli/land_wl.py SECTION D

Writes (or rewrites, if present) the study section, decision D (both registers: table row, request line, section),
the record wenli-on-the-spine, the history note and re-pointed references of civilization-thought-on-the-spine (its
name count changes with the seventh pass), the reading-catalogue entries, and the goal record's extension. Every
figure is computed from the kit; verify_zh.py must pass first. The board move is board_move.py's, after the commit."""
import collections, csv, datetime, hashlib, json, re, subprocess, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
KITP = HERE.parent
ROOT = HERE.parents[6]


def put(path, block, marker):
    """Insert the block at the end, or replace it where its marker already stands (landing_texts.py's rule)."""
    t = path.read_text(encoding='utf-8')
    if marker in t:
        start = t.index(marker)
        nxt = re.search(r'\n(?=## \d+\. |<a id="d\d+)', t[start + 1:])
        end = start + 1 + nxt.start() + 1 if nxt else len(t)
        t = t[:start] + block.strip() + '\n\n' + t[end:].lstrip('\n')
    else:
        t = t.rstrip('\n') + '\n\n' + block.strip() + '\n'
    path.write_text(t, encoding='utf-8')


def put_line(path, line, after_regex, key):
    t = path.read_text(encoding='utf-8')
    lines = [x for x in t.split('\n') if key not in x]
    idx = max(i for i, x in enumerate(lines) if re.match(after_regex, x))
    lines.insert(idx + 1, line)
    path.write_text('\n'.join(lines), encoding='utf-8')


S, D = sys.argv[1], sys.argv[2]
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
KIT = RF + '/development/zhonghua'
STUDY, DC, DCZ = RF + '/BECOMING-RENEWAL-READING.md', RF + '/DELEGATED-CHOICES.md', RF + '/DELEGATED-CHOICES.zh.md'
CH = 'theories/becoming/chapters/WENLI-AND-BECOMING.md'
ED = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING-ZHONGHUA.md'
MAP = 'theories/becoming/chapters/CIVILIZATION-THOUGHT-AND-BECOMING.md'
SRC = 'sources/15-codex-theory-conversations/2026-10-22-wenli-epistemology-centre.md'
PROV = 'sources/wenli-shengsheng-v0.4/PROVENANCE.json'
RECORDS = ROOT / 'theories/becoming/results/records'
ID = 'wenli-on-the-spine'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
HEAD = '文理生生 joined, with the epistemology of 文 at the centre (WL)'
ANCH = f'{S}-文理生生-joined-with-the-epistemology-of-文-at-the-centre-wl'
ASK = '“是的，让它成为整合的中心，至于文，文也不是很确定怎样给它“立名”最好，请找到最恰当的方式”'
ASK1 = '“文字中的符号体系和认知论更好的可以表达”'


def sha(p):
    return hashlib.sha256((ROOT / p).read_bytes()).hexdigest()


def git(*a):
    return subprocess.run(['git', *a], cwd=ROOT, capture_output=True, text=True, check=True).stdout


# figures
v = subprocess.run([sys.executable, '-I', str(KITP / 'verify_zh.py')], capture_output=True, text=True)
assert v.returncode == 0, v.stdout[-800:]
m = re.search(r'(\d+) names; chapters: (\d+) quotations, (\d+) declarations, (\d+) record links, \d+ 对照 lines; '
              r'receipt (\S+);', v.stdout)
names, nq, nd, nl, rcpt = m.groups()
cw = list(csv.DictReader(open(KITP / 'wenli/crosswalk.tsv', encoding='utf-8'), delimiter='\t'))
cat = collections.Counter(r['类别'] for r in cw)
comparable = cat['S'] + cat['O'] + cat['D']
meaningful = comparable + cat['NC']
agree = cat['S'] + cat['O'] + cat['NC']
rev = json.loads((KITP / 'agents/wl/revisions-check.json').read_text(encoding='utf-8'))['decisions']
nrev = sum(1 for r in rev if r['decision'] != 'keep')
ops = json.loads((KITP / 'work/seventh-pass.json').read_text(encoding='utf-8'))
rows7 = len({o['row'] for o in ops})
files = len(json.loads((ROOT / PROV).read_text(encoding='utf-8'))['files'])


def blocks(t):
    parts = re.split(r'^(### \S+　.+)$', t, flags=re.M)
    return {parts[i][4:].split('　', 1)[1]: parts[i + 1].split('\n## ')[0] for i in range(1, len(parts), 2)}


def jing(b):
    x = re.search(r'\*\*經\*\*\s*(.*)', b)
    return x.group(1) if x else ''


old_b, new_b = blocks(git('show', 'main:' + ED)), blocks((ROOT / ED).read_text(encoding='utf-8'))
added = [t for t in new_b if t not in old_b]
jing_changed = sum(1 for t in new_b if t in old_b and jing(old_b[t]) != jing(new_b[t]))
shuo_changed = sum(1 for t in new_b if t in old_b and old_b[t] != new_b[t] and jing(old_b[t]) == jing(new_b[t]))
ntiao = len(new_b)

study = f'''## {S}. {HEAD}

```text
Result(s): {ID} (new); civilization-thought-on-the-spine (history note: the name table's seventh pass)
Delta: 文 named the course, a run's states read through a map step by step (Becoming.Parting.course,
       Becoming.Learnable.course), and 文同 the sameness of two states' courses under a law (Becoming.Law.SameFuture);
       the 中华本 gains 一·二十一「文与文同」 ({ntiao} 條) and states 篇九's line of knowing on 文 ({jing_changed} 經
       and {shuo_changed} 說 edited); the epistemology of 文 (laws read off the unfolding, 读书百遍其义自见, 理 read
       off the 文, the least reading, knowing within the unfolding, composition) tied link by link to checked laws,
       each with where it holds and where it fails; 文理生生's {len(cw)} characters against the name table
       ({cat['S']} same structure, {cat['O']} partly, {cat['D']} same character with another structure, {cat['NC']}
       made names by neither: {agree} of {meaningful} agree); {len(rev)} divergent readings rechecked against its
       per-sense sources ({nrev} revised, {len(rev) - nrev} kept with the distance stated); the seventh pass of the
       name table ({len(ops)} changes over {rows7} rows, {names} names); 文理生生 v0.4 imported byte for byte ({files}
       files)
Supplied premises / correspondence: none, and no Lean; the naming and the readings are the AI's (D{D})
Evidence: verify_zh.py passes on the three chapters ({nq} quotations, {nd} declarations in receipt `{rcpt}`,
          {nl} record links, the name table, the generated tables); import_wenli.py --check; the central section
          checked name by name against the Lean statements, and the chapter and the changed 條 reviewed by three
          lenses (Lean fidelity; numbers, references and quotations; the whole account), each finding checked by a
          skeptic
Boundary: whether classical Chinese is the best expression of the core (untested); 文理生生's H2 (designed, not run); the
          fidelity count (designed, not run); Lean joining the laws of 文 to Web.AlikeThroughUpTo and to
          CrossSituational; 文理生生's G1 as a query layer of the spine
```

Ren, 22 October 2026, after comparing 文理生生 with the theory: {ASK1}; then {ASK} ([words](../../../{SRC})). The words are provenance; the name, the readings and the comparison are the AI's.

**The question.** 文理生生 is a classical-Chinese concept grammar Ren built with Codex apart from the 中华本, so the two can be compared. Is its line of 文 (文 as the intermixing of differing things, characters composed as operations, knowing by reconstructing an internally generative structure through repeated reading) the core's own epistemology? And what should 文 name?

**The move.** Three readers took 文 from philology, from the spine's structures and from epistemology; a judge chose among their candidates with the integrator. The epistemology was drafted section by section against the Lean statements and checked name by name; 文理生生's per-sense sources were used to recheck every reading where the two projects differ; the book's 經 were revised where the course had been called 历程 or 来, and 往 restated on 文. Six readers first compared the two projects (`development/zhonghua/agents/wenli/`).

**What was found.**
- *The name.* The spine has one object every link of 篇九's line of knowing is stated on and the name table lacked: a run's states read through a map step by step (`o : Nat → O`). 文 names it, from 「通其变，遂成天下之文」: its states are read off it (two steps from which every value agrees are one state, `Becoming.SameAhead`; such steps stay one state, `Becoming.SameAhead.next`), and under a law they are exactly the alike classes (`Becoming.IdentificationRuns.sameAhead_iff_alike`). 历 stays the given states and moves; the same sequence read as values is a 文. 文理生生's three senses fall into one 文 (the visible pattern; writing, a 文 whose values are names, matched to senses by a code) and 理 (the structure read: the coarsest value-keeping 理 merges exactly the states with the same 文, by four checked laws together).
- *The epistemology.* The laws are read off the unfolding (`Becoming.Shown.run`, `Becoming.exists_law_iff`); 读书百遍其义自见 is three laws (a bound makes a finite prefix fix the course, `Becoming.Identification.bounded_agree`, exact; a state value is learnable exactly when it is eventually a reading of the course, `Becoming.Learnable.learnable_iff`, `Becoming.Learnable.learnable_iff_reading`; given only that reading, prediction succeeds, `Becoming.Learnable.reading_predicts`), with its failures (meaning fixed outside the course, `Becoming.Learnable.not_predicts_on_both`; the diagonal course, `Becoming.Learning.diagonal_misses`); compression and generalization are one class (`Becoming.Learning.determines_lumped_iff`), exactly where it carries a law (`Becoming.Learning.goAlike_iff_lumped`).
- *The two projects.* They agree on about three quarters of the comparable characters, refuse the same characters as names, and reached the same two layers (a formal core and a classical reading layer); independence is partial (the same corpus, both AI-written). 文理生生 places 观/证 above the model; the core places knowing within the unfolding (识).

**What this changes.** The epistemology of the theory has a classical statement whose every link is a checked law with its scope; the 中华本 names the object of knowing; the name table carries, for every name where 文理生生 reads the character differently, the character's ordinary sense and the distance of the name from it. The English chapter and its modern Chinese edition are unchanged.

*Reading* [AI reading, D{D}]. The line of 文 is a fitting expression of the core's language and epistemology: each of its links is a checked law, with where it holds and where it fails (「物相杂」 only within a scope, composition only for a supplied grammar, how a reader reaches a class not derived). Whether it is closer than other expressions, or best, is untested; the designed tests compare only the codes they run, and none is run.

**Not done.** The H2 reading test and the fidelity count (`experiments/wenli-reading-transfer/`); the Lean items the chapter lists (the coarsest law-carrying class as one theorem; the laws of 文 joined to Web.AlikeThroughUpTo and CrossSituational), each to be claimed on the board; G1 embedded as a query layer.

**Self-review.** Every quotation, declaration, record link and generated table in the three chapters is checked by verify_zh.py; the central section was checked against each cited Lean statement (eleven corrections); the chapter and the changed 條 were reviewed by three independent lenses with a skeptic for each; the integrator's own edits are recorded with their reasons (kit `development/zhonghua/work/integrator-edits.json`, `work/seventh_pass.py`, `wenli/`).
'''

row = (f'| D{D} | 文 named the course, and the epistemology of 文 (22 October) | adopted with exact scope: 文 = a run\'s states '
       f'read through a map step by step (Parting.course, Learnable.course), 文同 = Law.SameFuture, 往 the prefix of a 文; '
       f'the epistemology of 文 (laws read off the unfolding, 读书百遍其义自见, 理 read off the 文) as readings of checked '
       f'laws with the scope each states; 文理生生\'s senses of 文 as one 文 and 理; whether classical Chinese is the best '
       f'expression left untested |')
req = (f'- Ren\'s request of 22 October 2026 to integrate 文理生生 with the epistemology of 文 at the centre and to find '
       f'the most fitting name for 文, {ASK} ([words](../../../../{SRC})): D{D} ([study section {S}](BECOMING-RENEWAL-READING.md#{ANCH})).')
sec = f'''<a id="d{D}-the-course-named-wen-and-the-epistemology-of-wen"></a>
### The course named 文, and the epistemology of 文

Where: the chapter [WENLI-AND-BECOMING](../../../../{CH}); the 中华本's 一·二十一 ([THE-THEORY-OF-BECOMING-ZHONGHUA](../../../../{ED})); the name table [names-decisions.tsv](development/zhonghua/work/names-decisions.tsv) (seventh pass, [seventh-pass.json](development/zhonghua/work/seventh-pass.json)); the record [{ID}](../../../../theories/becoming/results/records/{ID}.md); study section {S} ([WL](BECOMING-RENEWAL-READING.md#{ANCH})). Decided in the one account of D45; continues D62.

**Decision.** Adopted with exact scope.
1. **The name.** 文 names a run's states read through a map step by step (`Becoming.Parting.course`, `Becoming.Learnable.course`); every sequence of values is a 文; 文同 names two states whose courses under a law through a map agree at every step (`Becoming.Law.SameFuture`). From 「通其变，遂成天下之文」.
2. **文 and 历.** One sequence along the steps is a 历 as given states and moves (its law is its natural law) and a 文 as values read, whose states and law are read off it. A run's 往 is the prefix of the 文 its moves (state, act, next state) give; two runs agree up to a 涯 when the 文 of their states agrees up to it, inclusive, and that of their acts before it.
3. **理.** 理 is not the 文, and is read off it in one sense only: a class that keeps the values and carries the law merges only states with the same 文; one that also merges every such pair is the name that identifies alike (four checked laws together, not one theorem).
4. **The epistemology.** Internally generative explanation, 读书百遍其义自见 and its failures, compression and generalization by one class, the least reading and knowing within the unfolding are readings of the checked laws the chapter cites, each with the scope it states; they do not say that any actual book or reader meets the conditions.
5. **文理生生.** Its three senses of 文 are read as one 文 (the visible pattern, writing) and 理 (the structure read); its 观/证 is read as a reading within the unfolding (识), not a level above it; the twenty-nine divergent readings are decided as the chapter records.
6. **Open.** Whether 文理生生 or classical Chinese is the best expression of the core is untested, and the designed tests compare only the codes they run. 文理生生's H2 (understanding these compositions improves structural reconstruction, explanation and transfer to unseen cases) is a narrower hypothesis about readers, designed here as a test and not run.

**Reasons.** The course is the one object the line of knowing is stated on, and the name table lacked it; 历程 would mix it with 历, which gives states and moves; the character's oldest relevant senses (文 formed along a change; things intermixed) fit what the laws say of it, and its other senses are stated as not carried.

**What would change it.** A law of the course that the name misdescribes; a reading of 系辞 or of 文理生生's sources under which 文 denotes the structure read rather than the course; the reading test, if run, for the comparison with a controlled English code.
'''
zrow = (f'| D{D} | 以文名一历之状经一象逐步之值，与文之认识论（10-22） | 依所述范围采用：文＝一历之状经一象逐步之值（Parting.course、'
        f'Learnable.course），文同＝Law.SameFuture，往是文之前段；文之认识论（律读自展开、读书百遍其义自见、理与文）作已检之律之读法，'
        f'各以其所述范围采用；文理生生之文诸义归于一文一理；古汉语是否最好之表达未经检验 |')
zreq = (f'- Ren 2026-10-22 要求以文之认识论为中心整合文理生生，并为文找到最恰当的立名，{ASK}'
        f'（[原话](../../../../{SRC})）：D{D}（研究第 {S} 节）。')
zsec = f'''<a id="d{D}-以文名一历之状经一象逐步之值与文之认识论--the-course-named-wen-and-the-epistemology-of-wen"></a>
### D{D}. 以文名一历之状经一象逐步之值，与文之认识论

所在：[《文理生生与变化论》](../../../../{CH})；中华本一·二十一（[《变化论》](../../../../{ED})）；名表 [names-decisions.tsv](development/zhonghua/work/names-decisions.tsv)（第七次之改，[seventh-pass.json](development/zhonghua/work/seventh-pass.json)）；记录 [{ID}](../../../../theories/becoming/results/records/{ID}.md)；研究第 {S} 节。在 D45 的一个说明中决定；接续 D62。

**决定。** 依所述范围采用。一、**名。** 文名一历之状经一象逐步之值（`Becoming.Parting.course`、`Becoming.Learnable.course`）；凡逐步之值皆文；二状于一法经一象逐步之值皆同，谓之文同（`Becoming.Law.SameFuture`）。名取「通其变，遂成天下之文」。二、**文与历。** 同一沿步之序列，作所给之状与动为历（其律为自然之法），作所读之值而自读其状与法为文。一行之往，是其诸移（状、动、次状）逐步所成之文之前段；二行至涯而同，是其状之文至涯（含）、其动之文于涯前皆同。三、**理。** 理不是文，只在一义自文读出：守值而载法之类只并文同之状；又并凡文同之状者为正名（四条已检之律之合，非一条定理）。四、**认识论。** 内在生成之解释、读书百遍其义自见及其失效、压缩与推广同一类、最小之读、知在展开之中，皆本章所引已检之律之读法，各以其所述范围采用；不说任何实际之书或读者满足其条件。五、**文理生生。** 其文之三义读为一文（可读之纹、书写）与一理（所读之构）；其观／证读为展开之中之读（识），不是在上之一层；二十九处异读依本章所记而决。六、**不决。** 文理生生或古汉语是否为核心最好之表达，未经检验；所设计之检验只比较所运行之码。文理生生之 H2（理解这些组合可改善对未见实例的结构重建、解释与迁移）是关于读者之较窄假说，本章设计其检验而未运行。

**理由。** 篇九之知来之线所陈述之对象只有一个，名表原无其名；称历程则与历相混，历给状与动；字之最相关之古义（文成于变之通；物相杂）合于诸律所说，其他字义写明不带。

**会改变它的。** 一条使此名误述之文之律；一种对系辞或文理生生出处之读，使文所指是所读之构而非文；阅读试验，若运行，于与受控英文码之比较。
'''
put(ROOT / STUDY, study, f'## {S}. {HEAD}')
put(ROOT / DC, sec, f'<a id="d{D}-the-course-named-wen')
put_line(ROOT / DC, row, r'^\| D\d+ \|', f'| D{D} |')
put_line(ROOT / DC, req, r'^- .*\bD\d+ \(\[study section \d+\]', f'D{D} ([study section {S}]')
put(ROOT / DCZ, zsec, f'<a id="d{D}-以文名一历之状')
put_line(ROOT / DCZ, zrow, r'^\| D\d+ \|', f'| D{D} |')
put_line(ROOT / DCZ, zreq, r'^- .*：D\d+（研究第 \d+ 节）。$', f'：D{D}（研究第 {S} 节）')

# the record
STUDY_ANCHOR = f'{STUDY}#{ANCH}'
old = RECORDS / f'{ID}.json'
first = json.loads(old.read_text())['history'][0] if old.exists() else None
record = {
    'schema_version': 2,
    'id': ID,
    'title': {'en': '文理生生 on the spine: the course named 文, and how a law is read from it',
              'zh': '文理生生在脊柱上：以文名一历逐步之值，与律何以自文读出'},
    'kind': 'assessment',
    'status': 'reviewed-scoped',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': ('文 names a run\'s states read through a map step by step (Parting.course), 文同 two states whose courses '
               'agree (Law.SameFuture); the epistemology of 文 (laws read off the unfolding, 读书百遍其义自见, 理 read off '
               'the 文) is tied to checked laws, each with its scope; 文理生生 is compared character by character.'),
        'zh': ('以文名一历之状经一象逐步之值，文同即二状之文逐步皆同（Law.SameFuture）；文之认识论（律读自展开、读书百遍其义自见、'
               '理与文）逐环对到已检之律，各写其域；文理生生逐字对照名表。')},
    'hypotheses': [{
        'en': (f'No Lean and no premise is added: each claim is tied to audited declarations as they stand, with their '
               f'hypotheses (a bound, a family holding every state, decidable values) stated where they apply. The name, '
               f'the division of 文 from 历 and the readings are the AI\'s (D{D}); 文理生生 is evidence of a separate '
               f'reading, partly independent (the same corpus, both AI-written).'),
        'zh': (f'不新增 Lean，不加前提：每一主张对到现有已审计之声明，其若（有界、一族尽其状、值之同异定然否）在所用之处写明。名、文与历之分、'
               f'诸读法是 AI 的（D{D}）；文理生生是另一阅读之证据，独立只是部分的（同一语料，都由 AI 写成）。')}],
    'does_not_show': [
        {'en': 'That any actual book or reader meets the conditions of the laws: the correspondence is not a theorem, and agreement is not confirmation.',
         'zh': '任一实际之书或读者满足诸律之条件：对应不是定理，相合不是印证。', 'kind': 'correspondence'},
        {'en': 'That 文理生生 or classical Chinese is the best expression of the core: untested; the reading test designed here (after 文理生生\'s H2) compares only the codes it runs, and is not run.',
         'zh': '文理生生或古汉语是核心最好之表达：未经检验；本章所设计之阅读试验（依文理生生之 H2）只比较所运行之码，且未运行。', 'kind': 'non-implication'},
        {'en': 'That the coarsest law-carrying class merges exactly the states with the same 文 as one theorem: it follows from four checked laws together.',
         'zh': '守值载法之最粗之类恰并文同之状为一条定理：它由四条已检之律合起来得出。', 'kind': 'scope'}],
    'counterexamples': [],
    'standard_boundaries': ['no-ethical-premise', 'formal-not-empirical', 'names-provisional',
                            'omission-not-refutation', 'nondual-method-not-proof'],
    'validation_scope': {
        'en': (f'verify_zh.py passes: {nq} quotations in their frozen texts, {nd} declarations in receipt {rcpt}, '
               f'{nl} record links, the name table ({names} names) and the generated tables of the three chapters; '
               f'import_wenli.py --check binds {files} files. The central section was checked against each cited Lean '
               f'statement; the chapter and the changed 條 were reviewed by three lenses with a skeptic each. All readers AI.'),
        'zh': (f'verify_zh.py 通过：{nq} 句引文在其冻结原文中，{nd} 个声明在回执 {rcpt} 中，{nl} 个记录链接，名表（{names} 个名）与三章之生成表；'
               f'import_wenli.py --check 绑定 {files} 个文件。中心一节逐条对照所引 Lean 声明检查；本章与所改之條经三个视角审读，各有一个质疑者。读者都是 AI。')},
    'next_delta': {
        'en': ('The H2 reading test and the fidelity count (experiments/wenli-reading-transfer); in Lean, the coarsest '
               'law-carrying class as one theorem and the laws of 文 joined to Web.AlikeThroughUpTo and CrossSituational, '
               'each claimed on the board first; 文理生生\'s G1 as a query layer of the spine.'),
        'zh': ('H2 阅读试验与忠实之测（experiments/wenli-reading-transfer）；Lean 中：守值载法之最粗之类作一条定理，文之律接到 '
               'Web.AlikeThroughUpTo 与 CrossSituational，各先在看板认领；文理生生之 G1 作脊柱之查询层。')},
    'correspondence': {
        'en': (f'Ren, 22 October 2026: {ASK} (provenance, not warrant). The chapter names 文, ties the epistemology of 文 '
               f'to the laws, and compares 文理生生 with the 中华本. Reading (the AI\'s, D{D}): the line of 文 is the '
               f'fitting expression of the core\'s language and epistemology, each link a checked law with its scope; whether it is closer than other expressions is untested.'),
        'zh': (f'Ren，2026年10月22日：{ASK}（来历，不是根据）。本章为文立名，把文之认识论对到诸律，并以文理生生对照中华本。读法（AI 的，D{D}）：'
               f'文之一线是核心之语言与认识论之一种贴切之表达，每一环是一条已检之律及其域；它是否比其他表达更贴近，未经检验。')},
    'canonical_source': CH,
    'aliases': ['文理生生', '文', '文同', 'the course named 文', 'the epistemology of 文', '读书百遍其义自见'],
    'dependencies': [
        {'id': 'civilization-thought-on-the-spine', 'relation': 'interpretive',
         'detail': {'en': 'The 中华本 and its name table, to which 文 and 文同 are added.',
                    'zh': '中华本与其名表，文与文同加入其中。'}},
        {'id': 'learnable-through-a-map', 'relation': 'interpretive',
         'detail': {'en': 'Learnable.learnable_iff gives 其义: a state value is learnable exactly when it is eventually a reading of the course.',
                    'zh': 'Learnable.learnable_iff 给出「其义」：状值可知，恰当它自某步起是文之一读。'}},
        {'id': 'identification-where-bounded', 'relation': 'interpretive',
         'detail': {'en': 'A bound makes a finite prefix fix the course, with the exact length.',
                    'zh': '有界则有穷之往定文，其长确切。'}}],
    'related': [{'id': r, 'detail': {'en': d, 'zh': z}} for r, d, z in [
        ('identification-where-runs-part', 'Parting.course, the course of a run.', 'Parting.course，一行之文。'),
        ('the-split-that-makes-sense', 'alike_moments_iff and identifiesAlike_of_law: states read off a course, the class that names the alike.',
         'alike_moments_iff 与 identifiesAlike_of_law：自文读状，名同之类。'),
        ('generalization-through-lumping', 'Compression and generalization by one class.', '压缩与推广同一类。'),
        ('learning-by-refutation', 'Learning by elimination and no prefix fixing the next value.', '过则改，与往不定其次值。'),
        ('chinese-sources-on-the-spine', 'The RO map, whose kinds and layers are used.', 'RO 之对应，用其关系与层。')]
        if (RECORDS / f'{r}.json').exists()],
    'references': [{'path': p, 'role': role, 'sha256': sha(p)} for p, role in [
        (CH, 'statement'), (ED, 'statement'), (f'{KIT}/work/names-decisions.tsv', 'integration'),
        (f'{KIT}/work/seventh-pass.json', 'integration'), (f'{KIT}/wenli/crosswalk.tsv', 'integration'),
        (f'{KIT}/verify_zh.py', 'integration'), (f'{KIT}/wenli/import_wenli.py', 'integration'),
        (STUDY, 'review'), (PROV, 'provenance'), (SRC, 'provenance')]],
    'proof_bindings': [],
    'progress': [{'en': 'The name 文, the epistemology of 文 on the laws, and the comparison with 文理生生.',
                  'zh': '文之立名，文之认识论在诸律上，与文理生生之对照。', 'source': STUDY_ANCHOR}],
    'history': [first or {
        'en': (f'22 October 2026: added (WL), on Ren\'s request to join 文理生生 with the epistemology of 文 at the centre '
               f'and to name 文; study section {S}; readings D{D}.'),
        'zh': f'2026年10月22日：新增（WL），按 Ren 以文之认识论为中心整合文理生生、并为文立名之要求；研究第 {S} 节；读法 D{D}。'}],
}
old.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n')

# civilization-thought-on-the-spine: its name count and the files this landing changed
zp = RECORDS / 'civilization-thought-on-the-spine.json'
z = json.loads(zp.read_text())
for k in ('en', 'zh'):
    z['statement'][k] = re.sub(r'\d+( classical names| 个古典之名)', names + r'\1', z['statement'][k])
note = {'en': (f'22 October 2026 (WL, study section {S}, D{D}): the name table\'s seventh pass adds 文 and 文同 '
               f'({names} names) and revises others against 文理生生\'s sources; the 中华本 gains 一·二十一; see {ID}.'),
        'zh': (f'2026年10月22日（WL，研究第 {S} 节，D{D}）：名表第七次之改立文与文同（{names} 个名），并据文理生生之出处修订他名；'
               f'中华本增一·二十一；见 {ID}。')}
z['history'] = [h for h in z['history'] if not h['en'].startswith('22 October 2026 (WL')] + [note]
changed = {ED, MAP, f'{KIT}/work/names-decisions.tsv', f'{KIT}/verify_zh.py', f'{KIT}/build_tables.py', STUDY}
for r in z['references']:
    if r['path'] in changed:
        r['sha256'] = sha(r['path'])
zp.write_text(json.dumps(z, ensure_ascii=False, indent=2) + '\n')

# reading catalogue
e = {"id": "wenli-and-becoming", "source": CH,
     "title_zh": "文理生生与变化论：文、理与读",
     "title_en": "文理生生 and the theory of becoming: 文, 理 and reading",
     "category": "classical-comparison",
     "status": "文已立名，认识论对到已检之律；无新 Lean / 文 named, the epistemology tied to checked laws; no new Lean",
     "argument_zh": ("以文名一历之状经一象逐步之值（文同即二状之文逐步皆同），名取「通其变，遂成天下之文」。文之状与法自文读出；律读自展开；"
                     "读书百遍其义自见是三条律（有界则往定文、状值可知恰当它是文之一读、给其读则自见），各有其失效；理不是文，只在一义自文读出。"
                     f"文理生生之 {len(cw)} 字逐字对照名表，{agree} / {meaningful} 相合。"),
     "argument_en": ("文 names a run's states read through a map step by step (文同: two states whose courses agree), from "
                     "「通其变，遂成天下之文」. A 文's states and law are read off it; laws are read off the unfolding; "
                     "读书百遍其义自见 is three laws (a bound makes a prefix fix the course; a state value is learnable exactly "
                     "when it is a reading of the course; given that reading it shows itself), each with its failure; 理 is "
                     f"not the 文 and is read off it in one sense only. 文理生生's {len(cw)} characters are compared with the name table: {agree} of {meaningful} agree."),
     "significance_zh": "理论之认识论有一古典之陈述，每一环是一条已检之律及其域；中华本为知之对象立名。",
     "significance_en": "The theory's epistemology has a classical statement whose every link is a checked law with its scope; the 中华本 names the object of knowing.",
     "scope_zh": f"名与读法为 AI 之约定与读（D{D}）；不新增 Lean；不说任何实际之书满足诸律之条件；古汉语是否最好之表达未经检验。",
     "scope_en": f"The name and readings are the AI's (D{D}); no new Lean; not a claim that any actual book meets the laws' conditions; whether classical Chinese is the best expression is untested.",
     "next_zh": "建议：运行 H2 阅读试验与忠实之测；认领本章所列之 Lean 项。",
     "next_en": "Proposed: run the H2 reading test and the fidelity count; claim the Lean items the chapter lists.",
     "lean": [],
     "evidence": [f'{KIT}/verify_zh.py', f'{KIT}/wenli/crosswalk.tsv', f'{KIT}/work/seventh-pass.json', PROV, STUDY],
     "source_sha256": sha(CH)}
for f in ['theories/becoming/results/data/arguments-a-l.json', 'theories/becoming/results/data/arguments-m-z.json']:
    d = json.loads((ROOT / f).read_text(encoding='utf-8'))
    d = [x for x in d if x['id'] != e['id']]
    for x in d:
        if x['id'] == 'the-theory-of-becoming-zhonghua':
            x['argument_zh'] = re.sub(r'以 \d+ 个古典之名', f'以 {names} 个古典之名', x['argument_zh'])
            x['argument_zh'] = re.sub(r'\d+ 條', f'{ntiao} 條', x['argument_zh'])
            x['argument_en'] = re.sub(r'in \d+ classical names', f'in {names} classical names', x['argument_en'])
            x['argument_en'] = re.sub(r'\d+ 條', f'{ntiao} 條', x['argument_en'])
            x['source_sha256'] = sha(ED)
        if x['id'] == 'civilization-thought-and-becoming':
            x['source_sha256'] = sha(MAP)
    if 'm-z' in f:
        d.append(e)
    d.sort(key=lambda x: x['id'])
    (ROOT / f).write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# the goal record
gp = ROOT / '_process/goals/chinese-sources-and-becoming.json'
g = json.loads(gp.read_text(encoding='utf-8'))
add = {'en': (' Extended on 22 October 2026, at his request of that day, to 文理生生 (a classical-Chinese concept grammar '
              'built apart from the 中华本), with the epistemology of 文 at the centre and 文 named the course.'),
       'zh': '2026年10月22日应其当日之要求，扩展到文理生生（与中华本分开所建之古汉语概念文法），以文之认识论为中心，以文名一历逐步之值。'}
for k in ('en', 'zh'):
    if add[k].strip() not in g['scope'][k]:
        g['scope'][k] = g['scope'][k].rstrip() + add[k]
for s in (SRC, CH):
    if s not in g['sources']:
        g['sources'].append(s)
if ID not in g['result_ids']:
    g['result_ids'].append(ID)
gp.write_text(json.dumps(g, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('WL landing texts: study section', S, 'decision D' + D, 'record', ID)
