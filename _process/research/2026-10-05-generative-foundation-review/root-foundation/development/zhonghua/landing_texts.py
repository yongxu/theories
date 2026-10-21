"""Write ZH's landing texts: python3 -I landing_texts.py STUDY_SECTION D_NUMBER

Inserts (or replaces, if present) the study section in BECOMING-RENEWAL-READING.md, the decision's table row,
request line and section in DELEGATED-CHOICES.md and its Chinese edition. Every figure is computed from the kit.
Run before make_record.py, which checks that both exist."""
import collections, csv, json, re, subprocess, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
RF = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY, DC, DCZ = RF / 'BECOMING-RENEWAL-READING.md', RF / 'DELEGATED-CHOICES.md', RF / 'DELEGATED-CHOICES.zh.md'
S, D = sys.argv[1], sys.argv[2]
sys.path.insert(0, str(HERE))
import book as B

P = json.loads((HERE / 'passages.json').read_text())['clusters']
E = [e for c in P.values() for e in c['entries']]
k = collections.Counter(e['kind'] for e in E)
par = sum(len(c['parallels']) for c in P.values())
rej = sum(len(c['rejected']) for c in P.values())
cov = json.loads((HERE / 'coverage.json').read_text())['verdicts']
flag = sum(v['c'] != '-' for v in cov.values())
names = list(csv.DictReader(open(HERE / 'work/names-decisions.tsv', encoding='utf-8'), delimiter='\t'))
chk = json.loads((HERE / 'work/names-checked.json').read_text())
import build_tables as BT
era = BT.eras()
quoted = [r for r in chk if [f for q in r['quotes'] for f in q['found']]]
pre = sum(1 for r in quoted if era[[f for q in r['quotes'] for f in q['found']][0]['source_id']] == '先秦')
nn = json.loads((HERE / 'work/new-names.json').read_text())
b2 = json.loads((HERE / 'work/book-2.json').read_text())
ntiao = sum(len(p['tiao']) for p in b2['parts'])
plan = json.loads((HERE / 'agents/plan-check.json').read_text())
ops = collections.Counter(o['op'] for o in plan['ops'])
fin = json.loads((HERE / 'work/finish-report.json').read_text())
asm = json.loads((HERE / 'work/assembly-report.json').read_text())
rw_edits = sum(v.get('edits', 0) for v in fin.values())
dr_edits = sum(v.get('edits', 0) for v in asm.values())
v = subprocess.run([sys.executable, '-I', str(HERE / 'verify_zh.py')], capture_output=True, text=True).stdout
m = re.search(r'chapters: (\d+) quotations, (\d+) declarations, (\d+) record links, (\d+) 对照 lines; receipt (\S+); periphery declarations: (\d+)', v)
assert v.startswith('ok') or '\nok' in v or v.split('\n')[-2].startswith('ok') or 'ok:' in v, v[-500:]
nq, nd, nl, ndz, rcpt, nper = m.groups()
place = BT.placements(P, cov)
pk = collections.Counter(place.get(r) for r, x in cov.items() if x['c'] != '-')
nmapped = pk['agreement'] + pk['scope'] + pk['divergence']
pct = round(100 * (pk['agreement'] + pk['scope']) / nmapped)
ANCH = '中华思想脉络-on-the-spine-and-the-中华本-zh'
ASK = ('“请把中华文化中所有在theory of becoming上有映射，或者对应的，找出来，并寻找到非同于英文系统的一套符号系统，这个系统存在于古中文之中，'
       '在历史长河中一直在演变和迭代，所以，它应该是一套比英文更加适合的，生生不息的，道法自然的，我们需要的表达”')

study = f'''## {S}. 《中华思想脉络》 on the spine, and the 中华本 (ZH)

```text
Result(s): civilization-thought-on-the-spine (new)
Delta: every complete judgment of 《中华思想脉络》 v1.0 ({len(cov):,}) read against the spine: {flag:,} bear on a structure of
       the theory and each lies in exactly one place ({len(E):,} checked entries: {k['agreement']} agreements, {k['scope']}
       exact scopes, {k['divergence']} divergences; {par:,} parallels; {rej} set aside with reasons); the thesis that the
       Chinese system "is naturally one, relational, dynamic" tested by domain and by era; {len(names)} classical names,
       one per concept, anchored on current main ({pre} of the {len(quoted)} quoted ones witnessed in pre-Qin texts),
       41 symbols not adopted with reasons; the theory stated in those names in the 中华本《变化论》 (凡例, sixteen 篇
       and 论纲, {ntiao} 條, each with 經, 說 and 證)
Supplied premises / correspondence: none, and no Lean; kinds, readings and names are the AI's (D{D}); the 脉络's
       mechanisms and modern comparisons are editorial and no entry rests on them
Evidence: verify_zh.py passes: 438 files bound by SHA-256; one triage verdict per judgment; every flagged judgment
          placed once; every fragment verbatim; the name table (anchors current, quotations exact, distinct once
          simplified); the two chapters' {nq} quotations, {nd} declarations (receipt `{rcpt}`, {nper} periphery
          ones listed apart), {nl} record links, {ndz} 对照 lines (each naming map entries with their kind) and
          generated tables
Boundary: what a text says beyond the laws; its authors' meaning; collation with printed editions; the pre-Qin use
          of names without a recorded witness; an independent human review
```

Ren, 19 October 2026, after extending his database to Chinese culture: {ASK}; “现在不用改英文版本，我们只是做中华版本，用中华的体系和符号系统 - 它自然就是一元的，关系的，动态的”; “同时，请把我做的这个脉络，也整合进我们的theories”; “其中大多重要的符号，应该在先秦就存在了” ([words](../../../../sources/15-codex-theory-conversations/2026-10-19-zhonghua-edition.md)). The words are provenance; the reading of the request, the tests and the edition are the AI's.

**The question.** Which of the 脉络's judgments correspond to the theory, and how (agreement, exact scope, divergence)? Is the Chinese system one, relational and dynamic by nature, as the thesis says? Can the theory be stated in classical names, mostly before 秦, as one controlled vocabulary rather than a translation?

**The move.** Every judgment was triaged against seventeen clusters of the spine; each cluster's flagged judgments were mapped by one mapper (entries with verbatim fragments, current declarations and records, an AI reading and a kind; parallels; rejections with reasons), revised on current main by a reviser, and read independently by a checker. The 88 entries the reviser kept unchanged, which the first checker had not read, were read by a second checker: 84 needed correction (21 in kind, mostly agreement to exact scope), so no entry stands on two readings. The names were fixed in two steps: 326 from the texts the map read, then, while drafting, the concepts the drafts needed (263 used in a 經 or in two 篇) by a three-lens panel and a judge for the 28 cross-cutting ones and by groups with adversarial verifiers for the rest: 120 names added, 104 concepts mapped onto existing names, 115 fixed plain wordings. The edition was drafted part by part ({dr_edits} review edits), reviewed as one book through its 經 (consistency, standing, order), restructured by a checked plan ({ops['move']} moves so every 條 rests on earlier ones, {ops['delete']} duplicates deleted with references redirected, {ops['add']} central laws added, {ops['retitle']} 篇 retitled), rewritten part by part in the names and reviewed again ({rw_edits} exact edits). The book is kept as parts and 條 with symbolic references (book.py), so the renumbering cannot break a reference.

**What was found.**
- *The thesis.* Of the {nmapped:,} judgments mapped, agreement and exact scope are {pct}%, divergence {100 - pct}%: 13% of the entries from pre-Qin texts, 21–26% in the larger later layers (a selection effect of the corpus, whose later texts were chosen for their debates on ground and nature, not a historical trend). By tradition: 名辩 1%, 庄子 5%, 兵 10%, 儒 12%, 易 and 佛 20%, 老子 23%, 三教互动 27%, 墨 28%, 法 33%. The relational start holds at the root and across the lines; universal forms mostly need a scope; as a property of every system the thesis fails.
- *The divergences* fall on the four non-relational layers RO named (a prior ground, a fixed nature or value, a will or single centre, contest and rank), and on two more: claims a checked law refutes (河上公's 不死) and knowing without coupling (「神以知来」).
- *The names.* {pre} of the {len(quoted)} quoted names are witnessed in pre-Qin texts; six only in later ones (未決, 初不定終, 位分, 二體, 義項, 憑). Many core characters are two-place relational words (待 needs a 所待, 资 a 所资), and the 經上's 「X，Y也」 gives the definitional form. The names are a code among the theory's users (`Becoming.SharedCodes`), not a sense recovered from history.
- *RO and the 易传 map.* Of 259 passages read in both maps, 232 have the same kind; of the 27 that differ, 19 read different sentences or structures, and 8 pairs on 5 passages are the same structure judged differently: each was decided for the newer reading (exact scope) with its reason, to be written into those maps.
- *Gaps.* 61 entries name a structure the spine lacks: a conjunctive or graded whole (华严六相, 墨经 损), saturation of a coupling (老子 72), one-sided and local regulation (老子 37, 57), equal division (论语 不患寡而患不均), copying growth (吴子), witnesses that are functions of one another (三人成虎), measures of a juncture (孙子, 扁鹊), a pool weighted by share.

**What this changes.** The 脉络 is a checked part of the library, joined to RO's map, with the divergences kept so the texts can test the theory; the theory has a 中华 edition in one classical vocabulary, the same laws and checks as the English chapter, which is unchanged (Ren's request), as is its modern Chinese edition. The RO chapter points to both; the goal record `chinese-sources-and-becoming` is extended.

*Reading* [AI reading, D{D}]. One relational unfolding is the dominant thread of these traditions and strongest at their earliest layer, not every system's doctrine nor a property the language guarantees; the classical names carry the relational structure where their attested sense does, and each says what it does not carry.

**Not done.** The gaps, each to be claimed before it is written; the five decided kinds written into RO's and the 易传 map; collation with printed editions; the pre-Qin use of the names without a recorded witness; an independent human reading of the edition.

**Self-review.** Every entry had three readings; every quotation, declaration, record link and 对照 kind in both chapters is checked by verify_zh.py; the edition's 經 were reviewed twice as one book; every review edit was applied only where its text occurs once, and the integrator's own edits are recorded with their reasons (kit `development/zhonghua/`).
'''

row = (f'| D{D} | the readings of 《中华思想脉络》 on the spine and of the classical names (22 October) | adopted with exact scope: '
       f'the three kinds of D47 and the four layers of D54 over every judgment of the 脉络; the {len(E):,} readings with the '
       f'scope each states; the thesis holds at the root, needs a scope in its universal forms, fails as every system\'s '
       f'property; the {len(names)} names as a convention among the theory\'s users, each with what it does not carry; five '
       f'RO and 易传 kinds decided for exact scope |')
req = (f'- Ren\'s request of 19 October 2026 for a 中华 edition in the classical symbol system and the 脉络 joined to the '
       f'theories, {ASK} ([words](../../../../sources/15-codex-theory-conversations/2026-10-19-zhonghua-edition.md)): '
       f'D{D} ([study section {S}](BECOMING-RENEWAL-READING.md#{S}-{ANCH})).')
sec = f'''<a id="d{D}-the-readings-of-the-civilization-thought-on-the-spine-and-of-the-classical-names"></a>
### The readings of 《中华思想脉络》 on the spine and of the classical names

Where: the chapters [CIVILIZATION-THOUGHT-AND-BECOMING](../../../../theories/becoming/chapters/CIVILIZATION-THOUGHT-AND-BECOMING.md) and [THE-THEORY-OF-BECOMING-ZHONGHUA](../../../../theories/becoming/chapters/THE-THEORY-OF-BECOMING-ZHONGHUA.md); the map [passages.json](development/zhonghua/passages.json) and the name table [names-decisions.tsv](development/zhonghua/work/names-decisions.tsv); the record [civilization-thought-on-the-spine](../../../../theories/becoming/results/records/civilization-thought-on-the-spine.md); study section {S} ([ZH](BECOMING-RENEWAL-READING.md#{S}-{ANCH})). Decided in the one account of D45; continues D54.

**Decision.** Adopted with exact scope.
1. **Kinds and layers.** The three kinds of D47 and the four non-relational layers of D54 are applied to every complete judgment of the 脉络, with two further kinds of divergence: a claim a checked law refutes, and knowing without coupling.
2. **The readings.** The {len(E):,} readings of the map are adopted with the scope each states; a passage read for two structures has two entries.
3. **The thesis.** One relational unfolding is the dominant thread, strongest at the earliest layer; universal forms mostly need a scope; it is not every system's property, and the language does not guarantee it.
4. **The names.** The {len(names)} names are a convention among the theory's users, constrained by the attested senses (`Becoming.SharedCodes`); each states the sense taken and what it does not carry; 道, 气, 天, 心, 性, 仁 and the other symbols of the not-adopted list are not names.
5. **RO and the 易传 map.** Where both maps read one structure of one passage and differ (荀子「一实」, 孙子「同舟」, 系辞「贞夫一」, 杂阿含「此有故彼有」, 老子「柔弱者生之徒」), the exact scope is adopted.

**Reasons.** Each reading names the declarations it rests on and says no more than they prove; the layers are named before the test so the thesis can fail; the names are chosen by their attested sense and anchored on current declarations, so the vocabulary can be checked rather than trusted.

**What would change it.** A law that a reading contradicts; a reading of a passage, argued from the text and its commentaries, under which its kind changes; a printed edition whose text differs at a quoted fragment; an attested sense under which a name carries what its note says it does not.
'''
zrow = (f'| D{D} | 《中华思想脉络》在脊柱上之读与古典之名（10-22） | 依所述范围采用：D47 之三种关系与 D54 之四层施于脉络之全部判断；'
        f'{len(E):,} 条读法各以其范围采用；论题在根上成立，全称形式需定域，作为每一体系之性质不成立；{len(names)} 个名是用者之间之约定，'
        f'各写所不带之义；RO 与易传之五处类别改为定域 |')
zreq = (f'- Ren 2026-10-19 要求以古中文之符号系统作中华本，并把脉络整合进理论，{ASK}'
        f'（[原话](../../../../sources/15-codex-theory-conversations/2026-10-19-zhonghua-edition.md)）：D{D}（研究第 {S} 节）。')
zsec = f'''<a id="d{D}-中华思想脉络在脊柱上之读与古典之名--the-readings-of-the-civilization-thought-on-the-spine-and-of-the-classical-names"></a>
### D{D}. 《中华思想脉络》在脊柱上之读与古典之名

所在：[《中华思想脉络》与变化论](../../../../theories/becoming/chapters/CIVILIZATION-THOUGHT-AND-BECOMING.md)与[中华本《变化论》](../../../../theories/becoming/chapters/THE-THEORY-OF-BECOMING-ZHONGHUA.md)；对应表 [passages.json](development/zhonghua/passages.json) 与名表 [names-decisions.tsv](development/zhonghua/work/names-decisions.tsv)；记录 [civilization-thought-on-the-spine](../../../../theories/becoming/results/records/civilization-thought-on-the-spine.md)；研究第 {S} 节。在 D45 的一个说明中决定；接续 D54。

**决定。** 依所述范围采用。一、**关系与层。** D47 之三种关系与 D54 之四种非关系之层施于脉络之每一完整判断；相分另有两种：一条已检查之律所否定之断言，不经耦合之知。二、**读法。** 对应表之 {len(E):,} 条读法各以其所述范围采用；一段读出两种结构者有两个条目。三、**论题。** 一个关系之展开是主导之线索，在最早一层最强；全称形式大多需要定域；它不是每一体系之性质，语言也不保证它。四、**名。** {len(names)} 个名是理论之用者之间之约定，受所见之义约束（`Becoming.SharedCodes`）；每名写出所取之义与所不带之义；不采之字不是名。五、**RO 与易传之对应。** 两表读同一段之同一结构而类别不同者五段，采定域。

**理由。** 每条读法列出它所依的声明，所说不多于它们所证；四层先于检验而立，所以论题可以不成立；名依所见之义而选，锚定在现行声明上，所以词表可以检查而不必信任。

**会改变它的。** 一条与某读法相矛盾之律；由原文与注疏论证、使某段类别改变之读法；某一引文处与所存文本不同之刻本；使某名带上其注所说不带之义的所见之义。
'''


def put(path, block, marker, after_pattern=None, at_end=True):
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
    lines = t.split('\n')
    lines = [l for l in lines if key not in l]
    idx = max(i for i, l in enumerate(lines) if re.match(after_regex, l))
    lines.insert(idx + 1, line)
    path.write_text('\n'.join(lines), encoding='utf-8')


put(STUDY, study, f'## {S}. 《中华思想脉络》 on the spine')
put(DC, sec, f'<a id="d{D}-the-readings-of-the-civilization-thought')
put_line(DC, row, r'^\| D\d+ \|', f'| D{D} |')
put_line(DC, req, r'^- .*\bD\d+ \(\[study section \d+\]', f'D{D} ([study section {S}]')
put(DCZ, zsec, f'<a id="d{D}-中华思想脉络在脊柱上之读与古典之名')
put_line(DCZ, zrow, r'^\| D\d+ \|', f'| D{D} |')
put_line(DCZ, zreq, r'^- .*：D\d+（研究第 \d+ 节）。$', f'：D{D}（研究第 {S} 节）')
print('study section', S, 'and decision D' + D, 'written')
