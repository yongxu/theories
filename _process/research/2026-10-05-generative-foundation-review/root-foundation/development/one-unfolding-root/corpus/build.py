#!/usr/bin/env python3
"""Step 0 corpus freeze: segment the first-batch texts of PLAN.md §5.3 into
sentence units with exact character offsets into the source files.

No normalization: every unit text is the concatenation of source substrings
src[s:e] for its ranges.  Offsets are Python str indices (Unicode code points)
into the source file decoded as UTF-8.  Run from anywhere:

    python3 build.py      # writes the TSVs and MANIFEST.json beside this file
    python3 verify.py     # checks every unit against its source

TSV text fields escape backslash, tab, newline and carriage return as
\\\\, \\t, \\n, \\r (see unescape() in verify.py).
"""
import hashlib, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, *[".."] * 7))

TERM = "。；？！"
CLOSE = "」』”’）》〉"

CN = {c: i for i, c in enumerate("零一二三四五六七八九")}


def cn2int(t):
    if t == "十":
        return 10
    if "十" in t:
        a, b = t.split("十")
        return (CN[a] if a else 1) * 10 + (CN[b] if b else 0)
    return CN[t]


def read(rel):
    p = os.path.join(REPO, rel)
    b = open(p, "rb").read()
    return b.decode("utf-8"), hashlib.sha256(b).hexdigest()


# ---------------------------------------------------------------- segmenter
def segment(src, spans, term=TERM, break_at_span_end=True):
    """Return a list of units, each a list of (start, end) ranges.

    Iterates the characters of the spans in order; a unit ends after a
    terminator plus any closing marks or further terminators that follow
    immediately.  With break_at_span_end, a unit also ends at a span end
    (a paragraph end without a terminator)."""
    stream = []  # (pos, span_index)
    for k, (s, e) in enumerate(spans):
        for p in range(s, e):
            stream.append((p, k))
    units, cur = [], []
    i, n = 0, len(stream)
    while i < n:
        p, k = stream[i]
        cur.append(p)
        end = False
        if src[p] in term:
            j = i + 1
            while j < n and (src[stream[j][0]] in CLOSE or src[stream[j][0]] in term):
                cur.append(stream[j][0])
                j += 1
            i = j
            end = True
        else:
            i += 1
            if break_at_span_end and (i >= n or stream[i][1] != k):
                end = True
        if end:
            units.append(cur)
            cur = []
    if cur:
        units.append(cur)
    out = []
    for u in units:
        while u and src[u[0]].isspace():
            u = u[1:]
        while u and src[u[-1]].isspace():
            u = u[:-1]
        if not u:
            continue
        ranges = []
        for p in u:
            if ranges and ranges[-1][1] == p:
                ranges[-1][1] = p + 1
            else:
                ranges.append([p, p + 1])
        out.append([tuple(r) for r in ranges])
    return out


def utext(src, ranges):
    return "".join(src[s:e] for s, e in ranges)


def ends_term(t):
    t = t.rstrip(CLOSE)
    return bool(t) and t[-1] in TERM


class Text:
    def __init__(self, text_id, title):
        self.text_id, self.title = text_id, title
        self.rows, self.sources, self.problems = [], [], []
        self.scope = ""

    def add(self, uid, section, utype, src, srcname, ranges, note=""):
        t = utext(src, ranges)
        if not ends_term(t) and utype not in ("题",):
            note = (note + "; " if note else "") + "no terminal punctuation at unit end"
        self.rows.append(dict(id=uid, text_id=self.text_id, section=section, unit_type=utype,
                              text=t, source=srcname,
                              offsets=";".join(f"{s}-{e}" for s, e in ranges), note=note))


def esc(t):
    return t.replace("\\", "\\\\").replace("\t", "\\t").replace("\n", "\\n").replace("\r", "\\r")


def source_entry(rel, sha, script, marks, provenance=None, role=""):
    d = dict(path=rel, sha256=sha, script=script, edition_marks_in_file=marks)
    if provenance:
        d["repository_provenance_record"] = provenance
    if role:
        d["role"] = role
    return d


# ---------------------------------------------------------------- 系辞
def build_xici():
    T = Text("XC", "《周易·繫辭》上下")
    T.scope = "繫辭上、繫辭下全篇（維基文庫 wikitext，章次依文件）"
    for part, code, rel in (("上", "XCS", "sources/zhouyi-yizhuan/yizhuan/xici-shang.json"),
                            ("下", "XCX", "sources/zhouyi-yizhuan/yizhuan/xici-xia.json")):
        src, sha = read(rel)
        meta = json.loads(src)["query"]["pages"][0]
        rev = meta["revisions"][0]
        T.sources.append(source_entry(rel, sha, "繁（「八卦相荡」作简体「荡」，余繁体）" if part == "上" else "繁",
                                      f"Wikisource API JSON; page title {meta['title']}; revid {rev['revid']}; timestamp {rev['timestamp']}; "
                                      "Header template gives author=孔子, times=東周 (attribution, not an edition); no 底本 stated"))
        cs = src.index('"content":"') + len('"content":"')
        ce = src.index('"', cs)
        assert "\\" not in src[cs:ce].replace("\\n", ""), "unexpected JSON escape"
        # split raw content at the two-character escape \n
        lines, p = [], cs
        while True:
            q = src.find("\\n", p, ce)
            if q < 0:
                lines.append((p, ce))
                break
            lines.append((p, q))
            p = q + 2
        chap, chap_label, paras = None, None, {}
        order = []
        for s, e in lines:
            line = src[s:e]
            m = re.fullmatch(r"==第(.+)章==", line)
            if m:
                chap, chap_label = cn2int(m.group(1)), f"繫辭{part}·第{m.group(1)}章"
                order.append((chap, chap_label))
                paras[chap] = []
                continue
            if not line.strip() or line.startswith("{{NoteTA") or line.startswith("{{Header") or line == "''''''":
                continue
            if chap is None:
                T.problems.append(f"{code}: text before first chapter heading skipped: {line[:30]}")
                continue
            if line.startswith("{{gap}}"):
                s += len("{{gap}}")
            paras[chap].append((s, e))
        for chap, label in order:
            units = segment(src, paras[chap])
            for n, r in enumerate(units, 1):
                t = utext(src, r)
                note = "contains wiki link markup [[...]] kept byte for byte" if "[[" in t else ""
                T.add(f"{code}-{chap:02d}-{n:03d}", label, "传", src, rel, r, note)
        if part == "下":
            T.problems.append("XCX: the file divides 繫辭下 into 9 chapters (第一章–第九章), not the 12 of 朱熹's arrangement; chapter numbers in ids follow the file.")
            T.problems.append("XCX: the wikitext keeps wiki links such as 蓋取諸[[周易/離|離]] inside the text; units keep them byte for byte (flagged in the note column).")
    T.problems.append("XCS: chapter numbering follows the file (12 chapters).")
    T.problems.append("XC: the raw files are JSON; paragraph breaks are the two-character escape \\n, which is never inside a unit; offsets index the raw JSON file.")
    return T


# ---------------------------------------------------------------- 老子
def build_laozi():
    rel = "sources/wenli-shengsheng-v0.4/research/corpus/sources/L.html"
    src, sha = read(rel)
    T = Text("LZ", "《老子》王弼本經文")
    T.scope = "八十一章經文（<p> 元素）；王弼注（<dl><dd><small>）不收"
    assert "長短相較" in src
    T.sources.append(source_entry(rel, sha, "繁",
                                  "page title 道德經 (王弼本) (Wikisource, wgRevisionId 2354026); body heads: 老子《道德經》上篇 / 下篇, 華亭張氏原本, 晉　王弼注; chapter 2 reads 長短相較 (王弼本 reading confirmed)"))
    heads = [(m.start(), m.end(), m.group(1)) for m in re.finditer(r'<div class="mw-heading mw-heading[12]"><h[12] id="([^"]+)"', src)]
    chap_heads = [(i, h) for i, h in enumerate(heads) if re.fullmatch(r"[一二三四五六七八九十]+章", h[2])]
    assert len(chap_heads) == 81, len(chap_heads)
    for idx, (i, (hs, he, hid)) in enumerate(chap_heads):
        nxt = heads[i + 1][0] if i + 1 < len(heads) else len(src)
        n = cn2int(hid[:-1])
        assert n == idx + 1
        spans = []
        for m in re.finditer(r"<p>(.*?)</p>", src[he:nxt], re.S):
            s, e = he + m.start(1), he + m.end(1)
            while e > s and src[e - 1] in "\n":
                e -= 1
            if "<" in src[s:e] or "&" in src[s:e]:
                T.problems.append(f"LZ {hid}: <p> contains markup or entity; kept: {src[s:e][:30]}")
            spans.append((s, e))
        if not spans:
            T.problems.append(f"LZ {hid}: no 經文 paragraphs found")
        units = segment(src, spans, break_at_span_end=False)
        for k, r in enumerate(units, 1):
            note = "unit spans several <p> elements separated by 王弼注; ranges concatenated" if len(r) > 1 else ""
            T.add(f"LZ-{n:02d}-{k:03d}", hid, "经", src, rel, r, note)
    T.problems.append("LZ: 經文 in the file is cut into <p> pieces at the points where 王弼注 is inserted, often mid-sentence; a unit that runs across a note is stored as several ranges (note column).")
    return T


# ---------------------------------------------------------------- 墨经
T2S = dict(zip("體慮義禮實夢譽誹舉賞罰窮盡損庫動長閒堅攖說辯爲謂聞見異諾執轉則觀別",
               "体虑义礼实梦誉诽举赏罚穷尽损库动长闲坚撄说辩为谓闻见异诺执转则观别"))
ALIAS = {"𢜔": "智", "𧨜": "誚", "侗": "同"}


def norm(ch):
    ch = ALIAS.get(ch, ch)
    return T2S.get(ch, ch)


def head(t):
    m = re.match(r"[^，。、；]*", t)
    return m.group(0)


def build_mojing():
    T = Text("MJ", "《墨經》經上、經說上")
    T.scope = "經上全篇（MI1-S-JS.txt）；經說上全篇（MI1-S-SS.txt），同一集合（civilization-thought-v1.0, ming）；M.html 作經上第二見證"
    relJ = "sources/civilization-thought-v1.0/evidence/additions/ming/MI1-S-JS.txt"
    relS = "sources/civilization-thought-v1.0/evidence/additions/ming/MI1-S-SS.txt"
    relW = "sources/wenli-shengsheng-v0.4/research/corpus/sources/M.html"
    J, shaJ = read(relJ)
    S, shaS = read(relS)
    W, shaW = read(relW)
    T.sources.append(source_entry(relJ, shaJ, "繁", "not stated (bare text, one line, no item numbers)",
                                  provenance="sources/civilization-thought-v1.0/data/model.json, source MI1-S-JS: 墨子/經上, permalink https://zh.wikisource.org/w/index.php?title=墨子/經上&oldid=2637042, accessed 2026-10-19; edition_note 依据传世网页转录，不是影印或现代校勘定本；断句与疑字保持所见",
                                  role="經上 (segmented)"))
    T.sources.append(source_entry(relS, shaS, "繁", "not stated (bare text, one 說 entry per paragraph, no numbers)",
                                  provenance="sources/civilization-thought-v1.0/data/model.json, source MI1-S-SS: 墨子/經說上, permalink https://zh.wikisource.org/w/index.php?title=墨子/經說上&oldid=2637044, accessed 2026-10-19; same edition_note",
                                  role="經說上 (segmented)"))
    wi = W.index("<p>故，所得") + 3
    wj = W.index("</p>", wi)
    same = W[wi:wj].strip() == J.strip()
    T.sources.append(source_entry(relW, shaW, "繁", "page title 墨子/經上 (Wikisource HTML); header 作者：墨翟; no 底本 or item numbering stated",
                                  role="second witness of 經上, not segmented; its 經上 <p> text is " + ("identical character for character to MI1-S-JS.txt (751 characters)" if same else "DIFFERENT from MI1-S-JS.txt")))
    junits = segment(J, [(0, len(J.rstrip()))])
    jheads = [head(utext(J, r)) for r in junits]
    # 說 paragraphs (non-empty lines)
    slines, p = [], 0
    for ln in S.split("\n"):
        if ln.strip():
            slines.append((p, p + len(ln)))
        p += len(ln) + 1
    sheads = [head(S[s:e]) for s, e in slines]

    # alignment: maximize score; match on 牒字 (first char, normalized)
    def score(a, b):
        if not a or not b:
            return -1
        if norm(a[0]) == norm(b[0]):
            return 3
        return -0.5  # order-only pairing allowed but penalized
    nJ, nS = len(jheads), len(sheads)
    D = [[0.0] * (nS + 1) for _ in range(nJ + 1)]
    B = [[None] * (nS + 1) for _ in range(nJ + 1)]
    for a in range(1, nJ + 1):
        B[a][0] = "u"
    for b in range(1, nS + 1):
        B[0][b] = "l"
    for a in range(1, nJ + 1):
        for b in range(1, nS + 1):
            opts = [(D[a - 1][b - 1] + score(jheads[a - 1], sheads[b - 1]), "d"),
                    (D[a - 1][b], "u"), (D[a][b - 1], "l")]
            D[a][b], B[a][b] = max(opts, key=lambda x: x[0])
    a, b, pairs = nJ, nS, {}
    while a > 0 or b > 0:
        mv = B[a][b]
        if mv == "d":
            pairs[b - 1] = a - 1
            a, b = a - 1, b - 1
        elif mv == "u":
            a -= 1
        else:
            b -= 1
    # an unlinked 說 line bracketed by linked neighbours with exactly one
    # unlinked 經 item between them is paired by order (marked uncertain)
    dp_pairs = dict(pairs)

    def bracket(li):
        lo = max([dp_pairs[x] for x in dp_pairs if x < li], default=-1)
        hi = min([dp_pairs[x] for x in dp_pairs if x > li], default=nJ)
        return lo, hi
    unl = [li for li in range(nS) if li not in dp_pairs]
    for li in unl:
        lo, hi = bracket(li)
        same = [x for x in unl if bracket(x) == (lo, hi)]
        cand = [a for a in range(lo + 1, hi) if a not in dp_pairs.values()]
        if len(same) == 1 and len(cand) == 1:
            pairs[li] = cand[0]
    # 經 units
    linked_J = set(pairs.values())
    for k, r in enumerate(junits, 1):
        note = "" if (k - 1) in linked_J else "no 經說 line linked"
        T.add(f"MJ-J-{k:03d}", "經上", "经", J, relJ, r, note)
    # 說 units
    uncertain = []
    for li, (s, e) in enumerate(slines):
        units = segment(S, [(s, e)])
        if li in pairs:
            jn = pairs[li] + 1
            ja, sb = jheads[pairs[li]], sheads[li]
            if norm(ja[0]) == norm(sb[0]):
                ln = f"linked to MJ-J-{jn:03d} by 牒字 ({ja} / {sb})"
                rivals = [x + 1 for x in (pairs[li] - 1, pairs[li] + 1)
                          if 0 <= x < nJ and x not in pairs.values() and norm(jheads[x][0]) == norm(sb[0])]
                if rivals:
                    ln += f"; UNCERTAIN: adjacent unlinked 經 item MJ-J-{rivals[0]:03d} has the same 牒字"
                    uncertain.append((li, jn, ja, sb))
                if ALIAS.get(sb[0]):
                    ln += f"; 牒字 variant {sb[0]} read as {ALIAS[sb[0]]}: uncertain"
                    uncertain.append((li, jn, ja, sb))
            else:
                ln = f"UNCERTAIN link to MJ-J-{jn:03d} by order only (牒字 differ: 經 {ja} / 說 {sb})"
                uncertain.append((li, jn, ja, sb))
            base = f"MJ-S-{jn:03d}"
        else:
            ln = "UNLINKED: no 經 item paired"
            base = f"MJ-S-X{li + 1:03d}"
            uncertain.append((li, None, None, sheads[li]))
        for q, r in enumerate(units, 1):
            uid = base if len(units) == 1 else f"{base}.{q}"
            T.add(uid, f"經說上 第{li + 1}段", "说", S, relS, r, ln)
    T.problems.append(f"MJ: 經上 (MI1-S-JS.txt) has no item numbers; each 。-unit is taken as one 經 item ({len(junits)} items). This may split or merge items relative to scholarly numberings (e.g. 孫詒讓); 經上 items 聞/循所聞/言/執所言 are separate units here.")
    T.problems.append("MJ: plan §5.3 lists M.html, which holds 經上 only; by the coordinator's correction 經上 and 經說上 are taken from one collection (MI1-S-JS.txt, MI1-S-SS.txt, Wikisource oldid 2637042 / 2637044). M.html is recorded as a second witness of 經上: " + ("its text is identical to MI1-S-JS.txt, no differences." if same else "it differs from MI1-S-JS.txt.") + " A simplified copy of 經說上 (sources/chinese-classical-texts/atlas-v9.1/evidence/texts/MS13.txt) exists and is not used.")
    T.problems.append(f"MJ: 經說上 paragraphs ({len(slines)}) were linked to 經上 items by sequence alignment on the 牒字 (first character, traditional/simplified folded by a small table in build.py); {len(uncertain)} links are uncertain or missing and are marked in the note column: "
                      + "; ".join(f"說段{li + 1}→" + (f"J-{jn:03d} ({ja}/{sb})" if jn else f"none ({sb})") for li, jn, ja, sb in uncertain))
    return T


# ---------------------------------------------------------------- plain-text helpers
def paragraph_spans(src, a, b):
    spans, p = [], a
    for ln in src[a:b].split("\n"):
        if ln.strip():
            spans.append((p, p + len(ln)))
        p += len(ln) + 1
    return spans


def build_xunzi():
    rel = "sources/civilization-thought-v1.0/evidence/additions/ru2/RU2-S-XZ22.txt"
    src, sha = read(rel)
    T = Text("XZ", "《荀子·正名》")
    T.scope = "正名篇全篇（文件第4至第23非空行）"
    T.sources.append(source_entry(rel, sha, "简",
                                  "file head: 荀子正名篇第二十二 with navigation 解蔽篇第二十一 / 性恶篇第二十三; no 底本 stated",
                                  provenance="sources/civilization-thought-v1.0/data/model.json, source RU2-S-XZ22: url https://zh.wikisource.org/zh-hans/荀子/正名篇; edition_note 维基文库公开传世文本；非权威校勘定本；采用页面简体转换字形，标点为整理者所加"))
    a = src.index("后王之成名")
    b = src.index("君子慎之。") + len("君子慎之。")
    for n, r in enumerate(segment(src, paragraph_spans(src, a, b)), 1):
        T.add(f"XZ-ZM-{n:03d}", "正名篇第二十二", "本文", src, rel, r)
    T.problems.append("XZ: simplified script; plan §一 quotes the passage in traditional script, so quotations match only after script folding.")
    T.problems.append("XZ: completeness of the chapter not checked against another edition (none frozen here).")
    return T


def build_zhuangzi():
    rel = "sources/civilization-thought-v1.0/evidence/additions/zhuang/ZH1-S03.txt"
    src, sha = read(rel)
    T = Text("ZZ", "《莊子·養生主》")
    T.scope = "養生主全篇（文件即全篇，火傳一段為末句）"
    T.sources.append(source_entry(rel, sha, "繁（含「无」「爲」等字形，未轉換）", "not stated (file is bare text)",
                                  provenance="sources/civilization-thought-v1.0/data/model.json, source ZH1-S03: title 庄子·養生主, url https://zh.wikisource.org/wiki/莊子/養生主, retrieved 2026-10-19; edition_note 维基文库逐篇转录的不转换字形见证；仅取正文p元素"))
    for n, r in enumerate(segment(src, paragraph_spans(src, 0, len(src))), 1):
        T.add(f"ZZ-YSZ-{n:03d}", "養生主", "本文", src, rel, r)
    T.problems.append("ZZ: located by grep for 指窮於爲薪；other repository copies (sources/chinese-classical-texts/atlas-v9.1/evidence/texts/DS06.txt, simplified) not used.")
    return T


# ---------------------------------------------------------------- 大乘起信论
def build_qixin():
    rel = "sources/civilization-thought-v1.0/evidence/additions/fo2/FO2-QX.txt"
    src, sha = read(rel)
    T = Text("QXL", "《大乘起信論》")
    T.scope = "全篇，含卷首 智愷序（unit_type 序）與題署（题）"
    T.sources.append(source_entry(rel, sha, "繁", "No.1666[No.1667] (大正藏 numbering as given); 題署 大乘起信論序揚州僧智愷作; 大乘起信論一卷馬鳴菩薩造梁西印度三藏法師真諦譯; 尾題 大乘起信論一卷",
                                  provenance="sources/civilization-thought-v1.0/data/model.json, source FO2-QX: url https://cbetaonline.dila.edu.tw/zh/T32n1666_001; edition_note CBETA官方xml-p5固定提交；保留lem正文，去note/rdg/back、目录mulu与排版空白"))
    marks = ["No.1666[No.1667]", "大乘起信論序揚州僧智愷作"]
    p = 0
    for k, m in enumerate(marks, 1):
        assert src.startswith(m, p)
        T.add(f"QXL-T-{k:03d}", "題", "题", src, rel, [(p, p + len(m))])
        p += len(m)
    title = "大乘起信論一卷馬鳴菩薩造梁西印度三藏法師真諦譯"
    t0 = src.index(title)
    for n, r in enumerate(segment(src, [(p, t0)]), 1):
        T.add(f"QXL-XU-{n:03d}", "序（智愷）", "序", src, rel, r)
    T.add("QXL-T-003", "題", "题", src, rel, [(t0, t0 + len(title))])
    g0 = t0 + len(title)
    l0 = src.index("論曰：", g0)
    for n, r in enumerate(segment(src, [(g0, l0)], term="。？！"), 1):
        T.add(f"QXL-G-{n:03d}", "卷首偈（文件未標）", "偈", src, rel, r,
              "verse not marked in file; identified by position before 論曰 and five-character lines; split at 。 only")
    endtitle = "大乘起信論一卷"
    e0 = len(src) - len(endtitle)
    assert src[e0:] == endtitle
    v0 = src.rindex("諸佛甚深廣大義")
    secs = [("初說因緣分", "因緣分", "YY"), ("次說立義分", "立義分", "LY"), ("次說解釋分", "解釋分", "JS"),
            ("次說修行信心分", "修行信心分", "XX"), ("次說勸修利益分", "勸修利益分", "QX")]
    bounds = [(l0, "論曰（標五分）", "L")] + [(src.index(m, l0), lab, c) for m, lab, c in secs]
    units = segment(src, [(l0, v0)])
    counters = {}
    for r in units:
        s = r[0][0]
        lab, c = [(lab, c) for b, lab, c in bounds if b <= s][-1]
        counters[c] = counters.get(c, 0) + 1
        T.add(f"QXL-{c}-{counters[c]:03d}", lab, "本文", src, rel, r)
    for n, r in enumerate(segment(src, [(v0, e0)], term="。？！"), 1):
        T.add(f"QXL-G2-{n:03d}", "迴向偈（文件未標）", "偈", src, rel, r,
              "verse not marked in file; identified by position before 尾題 and seven-character lines")
    T.add("QXL-T-004", "尾題", "题", src, rel, [(e0, len(src))])
    T.problems.append("QXL: the file is one line with no layout; 卷首偈 and 迴向偈 are not marked and were typed 偈 by position and metre (note column). Section labels come from the file's own 初說/次說…分 sentences; a unit carrying 已說X分。次說Y分 starts before the marker and keeps the earlier label only if it starts before it.")
    T.problems.append("QXL: 智愷序 is included as unit_type 序; its authenticity question is not addressed.")
    return T


# ---------------------------------------------------------------- 金师子章
def build_jinshizi():
    T = Text("JSZ", "《金師子章》（法藏章文與承遷注分層）")
    T.scope = "法藏章文（FO2-KS-P.txt）與承遷注文（FO2-KS-C.txt）分別切分；合排本 FO2-KS.txt 僅作分層核對；卷首序不收"
    relK = "sources/civilization-thought-v1.0/evidence/additions/fo2/FO2-KS.txt"
    relP = "sources/civilization-thought-v1.0/evidence/additions/fo2/FO2-KS-P.txt"
    relC = "sources/civilization-thought-v1.0/evidence/additions/fo2/FO2-KS-C.txt"
    K, shaK = read(relK)
    P, shaP = read(relP)
    C, shaC = read(relC)
    T.sources.append(source_entry(relK, shaK, "繁", "No. 1881; 金師子章序 (unattributed preface); 大方廣佛華嚴經金師子章; 五臺山真容院沙門承遷註; 唐崇福寺賢首法師法藏述; 尾題 大方廣佛華嚴經金師子章一卷",
                                  provenance="sources/civilization-thought-v1.0/data/model.json, source FO2-KS: title 华严经金师子章注; url https://cbetaonline.dila.edu.tw/zh/T45n1881_001; CBETA xml-p5",
                                  role="combined layout (章文 and 注 interleaved, hard-wrapped CBETA lines; layers not marked); used only to check the layer files"))
    T.sources.append(source_entry(relP, shaP, "繁", "file head 金師子章唐崇福寺賢首法師法藏述; no number stated in the file",
                                  provenance="sources/civilization-thought-v1.0/PROVENANCE.json, FO2-KS-P: 法藏《金师子章》章文（从承迁注本分层提取）, url https://cbetaonline.dila.edu.tw/zh/T45n1881_001",
                                  role="章文 layer → unit_type 本文"))
    T.sources.append(source_entry(relC, shaC, "繁", "not stated (bare text)",
                                  provenance="sources/civilization-thought-v1.0/PROVENANCE.json, FO2-KS-C: 承迁《金师子章注》注文（分层提取）",
                                  role="注 layer → unit_type 注"))
    tm = "金師子章唐崇福寺賢首法師法藏述"
    assert P.startswith(tm)
    T.add("JSZ-T-001", "題", "题", P, relP, [(0, len("金師子章"))])
    T.add("JSZ-T-002", "題", "题", P, relP, [(len("金師子章"), len(tm))])
    menu_end = P.index("第一、明緣起者")
    # the ten-gate list 初、明緣起二、辨色空… has no terminators: one unit
    T.add("JSZ-P-000", "十門目", "本文", P, relP, [(len(tm), menu_end)], "list of the ten gates, no internal punctuation besides 、")
    gates = ["第一、明緣起者", "第二、辨色空者", "第三、約三性者", "第四、顯無相者", "第五、說無生者", "第六、論五教",
             "第七、勒十玄", "第八、括六相者", "第九、成菩提者", "第十、入涅槃者"]
    gpos = []
    q = menu_end
    for g in gates:
        q = P.index(g, q)
        gpos.append(q)
        q += len(g)
    pe = len(P.rstrip())
    for gi, g0 in enumerate(gpos):
        g1 = gpos[gi + 1] if gi + 1 < len(gpos) else pe
        for n, r in enumerate(segment(P, [(g0, g1)]), 1):
            T.add(f"JSZ-P-{gi + 1:02d}-{n:03d}", gates[gi], "本文", P, relP, r)
    ce_ = len(C.rstrip())
    for n, r in enumerate(segment(C, [(0, ce_)]), 1):
        T.add(f"JSZ-C-{n:03d}", "承遷注", "注", C, relC, r)
    T.problems.append("JSZ: FO2-KS.txt (the path in plan §5.3) interleaves 章文 and 承遷注 with no markup separating them (hard-wrapped CBETA lines, e.g. 謂以金無自性。喻真理不變也。 on one line). The separation used here is the repository's own layered extraction FO2-KS-P.txt / FO2-KS-C.txt (PROVENANCE: 从承迁注本分层提取, from CBETA T45n1881 TEI); the TEI raw file is not in the repository, so the layer boundary cannot be rechecked here beyond verify.py's check that each layer is an in-order subsequence of FO2-KS.txt.")
    T.problems.append("JSZ: in the layer files, 顯法界中無孤單法 (quoted in plan §5.2 as part of the 六相 passage) belongs to the 注 layer (承遷), not to 法藏's 章文; the 章文 六相 passage ends 諸緣各住自位是壞相。")
    T.problems.append("JSZ: the commentary file is a single run without the gate headings; 注 units carry no gate label. The unattributed 金師子章序 at the head of FO2-KS.txt is outside scope and not segmented.")
    T.problems.append("JSZ: the 十門 list in the 章文 (初、明緣起二、辨色空…十、入涅槃) has no sentence punctuation and is kept as one unit JSZ-P-000.")
    return T


# ---------------------------------------------------------------- 中论
def verse_like(inner):
    cl = [c for c in re.split(r"[，；。？！：]", inner) if c]
    return len(cl) >= 2 and all(len(c) == 5 for c in cl)


def build_zhonglun():
    rel = "sources/civilization-thought-v1.0/evidence/additions/fo1/FO1-S-MMK.txt"
    src, sha = read(rel)
    T = Text("ZL", "《中論》四品（偈與青目釋）")
    T.scope = "觀因緣品第一、觀去來品第二、觀三相品第七、觀成壞品第二十一"
    T.sources.append(source_entry(rel, sha, "繁", "No.1564[cf.Nos.1565-1567]; 中論卷第一; 釋僧叡序; 龍樹菩薩造梵志青目釋姚秦三藏鳩摩羅什譯",
                                  provenance="sources/civilization-thought-v1.0/data/model.json, source FO1-S-MMK: url https://cbetaonline.dila.edu.tw/zh/T30n1564_001; edition_note 复用旧v9.1已冻结CBETA XML；仅提取body，保留lem，跳过note/rdg/back"))
    chaps = [(1, "觀因緣品第一", "觀去來品第二"), (2, "觀去來品第二", "觀六情品第三"),
             (7, "觀三相品第七", "觀作作者品第八"), (21, "觀成壞品第二十一", "觀如來品第二十二")]
    hdr = re.compile(r"(中論卷第[一二三四])|(龍樹菩薩造梵志青目釋姚秦三藏鳩摩羅什譯)|((?:中論)?觀[^品]{1,6}品第[一二三四五六七八九十]+)")
    nverse = nunq = 0
    for num, h, nh in chaps:
        s0 = src.index(h)
        if src[s0 - 2:s0] == "中論":
            s0 -= 2
        e0 = src.index(nh, s0)
        if src[e0 - 2:e0] == "中論":
            e0 -= 2
        # back off trailing 卷 marks / attribution
        while True:
            m = re.search(r"(中論卷第[一二三四]|龍樹菩薩造梵志青目釋姚秦三藏鳩摩羅什譯)$", src[s0:e0])
            if not m:
                break
            e0 = s0 + m.start()
        label = h
        cnt = {"H": 0, "U": 0}
        # leading header tokens
        p = s0
        while True:
            m = hdr.match(src, p)
            if not m:
                break
            cnt["H"] += 1
            T.add(f"ZL-{num:02d}-H{cnt['H']}", label, "题", src, rel, [(m.start(), m.end())])
            p = m.end()
        # pieces: prose / quoted verse
        pieces = []  # (start, end, kind, note)
        if num == 1:
            q = src.index("問曰：", p)
            if verse_like(src[p:q]):
                pieces.append((p, q, "偈", "opening verse, unquoted in file; typed 偈 by position and five-character metre"))
                nunq += 1
                p = q
        i, last = p, p
        while i < e0:
            if src[i] == "「":
                depth, j = 0, i
                while j < e0:
                    if src[j] == "「":
                        depth += 1
                    elif src[j] == "」":
                        depth -= 1
                        if depth == 0:
                            break
                    j += 1
                if j < e0 and verse_like(src[i + 1:j]):
                    if last < i:
                        pieces.append((last, i, "释", ""))
                    pieces.append((i, j + 1, "偈", "quoted verse: 「」 with five-character lines"))
                    nverse += 1
                    last = j + 1
                i = j + 1
            else:
                i += 1
        if last < e0:
            pieces.append((last, e0, "释", ""))
        for a, b, kind, note in pieces:
            units = segment(src, [(a, b)], term="。？！" if kind == "偈" else TERM)
            for r in units:
                cnt["U"] += 1
                n2 = note
                if kind == "释" and "「" in utext(src, r):
                    n2 = "contains a quotation not typed as verse (metre test failed)"
                T.add(f"ZL-{num:02d}-{cnt['U']:03d}", label, kind, src, rel, r, n2)
    T.problems.append(f"ZL: the file is one line with no layout; 偈 are identified as quotations 「…」 whose every clause (split at ，；。？！：) has five characters ({nverse} quoted verses) plus {nunq} unquoted opening verse of chapter 1. Quotations failing the metre test stay inside 释 units (flagged). Verse units split only at 。？！ and at the closing 」, not at ； (hemistich mark).")
    T.problems.append("ZL: the text before a quoted verse in the same sentence (e.g. 答曰：, 復次：, 如偈說) becomes its own short 释 unit without terminal punctuation.")
    T.problems.append("ZL: 卷 marks and the attribution line that stand between chapter 6 and 7 (中論卷第一中論卷第二龍樹…譯) and between 20/21 and 22 are outside the chapter ranges; the attribution after 觀因緣品第一 is kept as a 题 unit.")
    return T


def main():
    texts = [build_xici(), build_laozi(), build_mojing(), build_xunzi(), build_zhuangzi(),
             build_qixin(), build_jinshizi(), build_zhonglun()]
    files = {"XC": "xici.tsv", "LZ": "laozi.tsv", "MJ": "mojing.tsv", "XZ": "xunzi-zhengming.tsv",
             "ZZ": "zhuangzi-yangshengzhu.tsv", "QXL": "qixinlun.tsv", "JSZ": "jinshizizhang.tsv", "ZL": "zhonglun.tsv"}
    cols = ["id", "text_id", "section", "unit_type", "text", "source", "offsets", "note"]
    manifest = {"plan": "../PLAN.md §5.3 (first batch)", "built_by": "build.py", "checked_by": "verify.py",
                "conventions": {
                    "offsets": "Python str indices (Unicode code points) into the source file decoded as UTF-8; 's-e' half-open; several ranges joined by ';' are concatenated without separator",
                    "segmentation": "a unit ends after one of 。；？！ plus any immediately following closing marks 」』”’）》〉 or further terminators; also at a paragraph/line end in line-based files; verse units (偈) end only at 。？！ or the closing 」",
                    "tsv_escaping": "text fields escape \\ as \\\\, tab as \\t, newline as \\n, CR as \\r",
                    "unit_types": "经 传 偈 释 注 本文 说 序 题 (说 = 經說; 序 = preface; 题 = title/attribution lines)",
                    "normalization": "none"},
                "texts": []}
    ids = set()
    for T in texts:
        fn = files[T.text_id]
        with open(os.path.join(HERE, fn), "w", encoding="utf-8", newline="") as f:
            f.write("\t".join(cols) + "\n")
            for r in T.rows:
                assert r["id"] not in ids, r["id"]
                ids.add(r["id"])
                f.write("\t".join(esc(r[c]) for c in cols) + "\n")
        counts = {}
        for r in T.rows:
            counts[r["unit_type"]] = counts.get(r["unit_type"], 0) + 1
        manifest["texts"].append(dict(text_id=T.text_id, title=T.title, tsv=fn, scope=T.scope, sources=T.sources,
                                      units_total=len(T.rows), units_by_type=counts, problems=T.problems))
    with open(os.path.join(HERE, "MANIFEST.json"), "w", encoding="utf-8") as f:
        json.dump(manifest, f, ensure_ascii=False, indent=1)
        f.write("\n")
    for t in manifest["texts"]:
        print(t["text_id"], t["units_total"], t["units_by_type"])


if __name__ == "__main__":
    main()
