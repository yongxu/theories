#!/usr/bin/env python3
"""Step 0, second round (PLAN.md §5.3 rows marked 待冻结 / 待定位): freeze and
segment, with the first round's segmenter and conventions (build.py):

  - 《中論》 chapters 10, 17, 19, 24 (verses and 青目's commentary separated as
    in the first round; each unit's note gives the speaker by the 問曰 / 答曰
    frame, a heuristic);
  - 《成唯識論》 passages on 種子, 一類相續, 恒轉如瀑流, 三法展轉因果同時 / 炷焰 /
    蘆束 and the store's 一類相續, each with about 300 characters of context on
    each side (windows snapped outward to sentence ends, overlapping windows
    merged);
  - 《華嚴五教章》 §4 六相圓融義 (located in FO2-FQ.txt), with about 300
    characters of context before it (the passage runs to the end of the file).

The first-round entries of MANIFEST.json are left as they are; this script
writes the key "second_round" only.  Run build.py first if the first round is
rebuilt (build.py keeps an existing "second_round" key).

    python3 build2.py && python3 verify.py
"""
import json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import build as B  # noqa: E402

CTX = 300
ENDS = B.TERM


def snap_back(src, p, floor=0):
    """Move p back to the start of the sentence containing it."""
    q = p
    while q > floor and src[q - 1] not in ENDS and src[q - 1] not in B.CLOSE:
        q -= 1
    return q


def snap_fwd(src, p, ceil):
    """Move p forward past the end of the sentence containing it."""
    q = p
    while q < ceil and src[q - 1] not in ENDS:
        q += 1
    while q < ceil and (src[q] in B.CLOSE or src[q] in ENDS):
        q += 1
    return q


# ---------------------------------------------------------------- 中論
def speaker_notes(src, units, kinds):
    """Heuristic speaker by frame: a unit opening with 問曰 starts the
    opponent's turn, one opening with 答曰 starts the reply; a verse inside
    the opponent's turn is the opponent's verse."""
    state, out = "Nāgārjuna/青目", []
    for r, kind in zip(units, kinds):
        t = B.utext(src, r)
        if t.startswith("問曰") or "問曰：" in t[:6]:
            state = "opponent"
        elif t.startswith("答曰") or "答曰：" in t[:6]:
            state = "reply"
        if kind == "偈":
            sp = "speaker: opponent (verse in the 問 turn)" if state == "opponent" else "speaker: Nāgārjuna (verse in the 答 turn or the author's own sequence)"
        elif kind == "释":
            sp = ("speaker: 青目 voicing the opponent (問 turn)" if state == "opponent"
                  else "speaker: 青目 (commentary, reply)")
        else:
            sp = ""
        out.append(sp)
        # a verse quoted after 答曰 keeps the reply; after a 問 verse the commentary on it is still the opponent's view
    return out


def build_zhonglun2():
    rel = "sources/civilization-thought-v1.0/evidence/additions/fo1/FO1-S-MMK.txt"
    src, sha = B.read(rel)
    T = B.Text("ZL2", "《中論》四品，第二輪（偈與青目釋）")
    T.scope = "觀燃可燃品第十、觀業品第十七、觀時品第十九、觀四諦品第二十四"
    T.sources.append(B.source_entry(rel, sha, "繁", "No.1564[cf.Nos.1565-1567]; 中論卷第一; 釋僧叡序; 龍樹菩薩造梵志青目釋姚秦三藏鳩摩羅什譯",
                                    provenance="sources/civilization-thought-v1.0/data/model.json, source FO1-S-MMK: url https://cbetaonline.dila.edu.tw/zh/T30n1564_001; edition_note 复用旧v9.1已冻结CBETA XML；仅提取body，保留lem，跳过note/rdg/back"))
    chaps = [(10, "觀燃可燃品第十", "觀本際品第十一"), (17, "觀業品第十七", "觀法品第十八"),
             (19, "觀時品第十九", "觀因果品第二十"), (24, "觀四諦品第二十四", "觀涅槃品第二十五")]
    hdr = re.compile(r"(中論卷第[一二三四])|(龍樹菩薩造梵志青目釋姚秦三藏鳩摩羅什譯)|((?:中論)?觀[^品]{1,6}品第[一二三四五六七八九十]+)")
    nverse, flagged = 0, 0
    for num, h, nh in chaps:
        s0 = src.index(h)
        if src[s0 - 2:s0] == "中論":
            s0 -= 2
        e0 = src.index(nh, s0)
        if src[e0 - 2:e0] == "中論":
            e0 -= 2
        while True:
            m = re.search(r"(中論卷第[一二三四]|龍樹菩薩造梵志青目釋姚秦三藏鳩摩羅什譯)$", src[s0:e0])
            if not m:
                break
            e0 = s0 + m.start()
        label = h
        cnt = {"H": 0, "U": 0}
        p = s0
        while True:
            m = hdr.match(src, p)
            if not m:
                break
            cnt["H"] += 1
            T.add(f"ZL-{num:02d}-H{cnt['H']}", label, "题", src, rel, [(m.start(), m.end())])
            p = m.end()
        # 卷 marks inside the chapter range (none expected) are reported
        for m in re.finditer(r"中論卷第[一二三四]", src[p:e0]):
            T.problems.append(f"ZL2: 卷 mark inside chapter {num} at {p + m.start()}")
        pieces = []
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
                if j < e0 and B.verse_like(src[i + 1:j]):
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
        units, kinds, notes = [], [], []
        for a, b, kind, note in pieces:
            for r in B.segment(src, [(a, b)], term="。？！" if kind == "偈" else B.TERM):
                n2 = note
                if kind == "释" and "「" in B.utext(src, r):
                    n2 = "contains a quotation not typed as verse (metre test failed)"
                    flagged += 1
                units.append(r); kinds.append(kind); notes.append(n2)
        sps = speaker_notes(src, units, kinds)
        for r, kind, n2, sp in zip(units, kinds, notes, sps):
            cnt["U"] += 1
            T.add(f"ZL-{num:02d}-{cnt['U']:03d}", label, kind, src, rel, r, "; ".join(x for x in (n2, sp) if x))
    T.problems.append(f"ZL2: same verse test as the first round ({nverse} quoted verses in the four chapters; {flagged} 释 units contain a quotation that failed the metre test).")
    T.problems.append("ZL2: the speaker in the note column is a heuristic from the 問曰 / 答曰 frame (a turn lasts until the next 問曰 or 答曰); a verse that Nāgārjuna states as the opponent's view without a 問曰 (e.g. the 不失法 verses of chapter 17) is not caught by it; the classification notes correct it where it matters.")
    T.problems.append("ZL2: the text before a quoted verse in the same sentence (答曰：, 復次：, 是故：) is its own short 释 unit without terminal punctuation, as in the first round.")
    return T


# ---------------------------------------------------------------- passages
def passage_text(T, code, rel, src, cores, header_re, label_of, kind_of):
    """cores: list of (pid, title, start_anchor, end_anchor, search_from).
    Writes units for the merged windows; returns the passage records."""
    ceil = len(src)
    recs, wins = [], []
    for pid, title, a, z, frm in cores:
        cs = src.index(a, frm)
        ce = src.index(z, cs) + len(z)
        ws = snap_back(src, max(0, cs - CTX))
        we = snap_fwd(src, min(ceil, ce + CTX), ceil)
        recs.append(dict(passage=pid, title=title, core=[cs, ce], window=[ws, we],
                         core_starts=a, core_ends=z, core_chars=ce - cs,
                         context_before=cs - ws, context_after=we - ce))
        wins.append([ws, we, [pid]])
    wins.sort()
    merged = []
    for w in wins:
        if merged and w[0] <= merged[-1][1]:
            merged[-1][1] = max(merged[-1][1], w[1])
            merged[-1][2] += w[2]
        else:
            merged.append(w)
    for k, (ws, we, pids) in enumerate(merged, 1):
        wid = "+".join(pids)
        for r in recs:
            if r["passage"] in pids:
                r["merged_window"] = wid
        # split out header tokens (卷 marks, attributions) as 题 spans
        spans, p = [], ws
        for m in header_re.finditer(src, ws, we):
            if p < m.start():
                spans.append((p, m.start(), "x"))
            spans.append((m.start(), m.end(), "题"))
            p = m.end()
        if p < we:
            spans.append((p, we, "x"))
        n = 0
        for s, e, t in spans:
            if t == "题":
                n += 1
                T.add(f"{code}-{wid}-{n:03d}", label_of(s), "题", src, rel, [(s, e)], f"window {wid}")
                continue
            for r in B.segment(src, [(s, e)]):
                n += 1
                us, ue = r[0][0], r[-1][1]
                inside = [x["passage"] for x in recs if x["passage"] in pids and us < x["core"][1] and ue > x["core"][0]]
                where = ("core of " + ",".join(inside)) if inside else "context (about 300 characters around a core)"
                T.add(f"{code}-{wid}-{n:03d}", label_of(us), kind_of(src, r), src, rel, r, f"window {wid}; {where}")
    return recs


def build_cwsl():
    rel = "sources/civilization-thought-v1.0/evidence/additions/fo1/FO1-S-CY.txt"
    src, sha = B.read(rel)
    T = B.Text("CWS", "《成唯識論》相續、種子、瀑流、三法展轉諸段")
    T.scope = "located passages, each core with about 300 characters of context on each side; overlapping windows merged; see 'passages'"
    T.sources.append(B.source_entry(rel, sha, "繁", "No.1585[cf.Nos.1586,1587]; 成唯識論卷第一–第十 (卷 marks at each 卷 end and start); 護法等菩薩造三藏法師玄奘奉詔譯; 頌 numbered with full-width digits",
                                    provenance="sources/civilization-thought-v1.0/data/model.json, source FO1-S-CY (locator T31n1585)"))
    cores = [
        ("P1", "本識一類相續任持種子（破實我）", "然諸有情，各有本識", "求趣涅槃。", 0),
        ("P2", "頌：恒轉如瀑流，阿羅漢位捨", "且初能變其相云何？頌曰：初阿賴耶識", "阿羅漢位捨。", 0),
        ("P3", "種子六義（恒隨轉：一類相續）、熏習四義、三法展轉因果同時（炷焰、蘆束）", "然種子義，略有六種。", "是謂略說一切種相。", 0),
        ("P4", "阿賴耶識非斷非常，以恒轉故，猶如瀑流；因果相續如流", "阿賴耶識為斷？為常？", "阿羅漢位方究竟捨。", 0),
        ("P5", "《解深密經》：一切種子如瀑流", "《解深密經》亦作是說：「阿陀那識", "故知別有第八識性。", 0),
        ("P6", "壽、煖、識三更互依持，一類相續", "又契經說：壽、煖、識三", "彼識即是此第八識。", 0),
        ("P7", "識緣名色，名色緣識，二法展轉相依，譬如蘆束", "又契經說：識緣名色", "故彼識言，顯第八識。", 0),
        ("P8", "識食：一類相續執持勝故", "四者、識食，執持為相。", "一類相續執持勝故。", 0),
        ("P9", "末那緣藏識見分：一類相續似常、一", "應知此意但緣藏識見分非餘", "說我所言。", 0),
    ]
    marks = [(m.start(), m.group(1)) for m in re.finditer(r"成唯識論卷第([一二三四五六七八九十]+)", src)]

    def label_of(pos):
        lab = "卷第一"
        for s, n in marks:
            if s <= pos:
                lab = f"卷第{n}"
        return lab

    def kind_of(s, r):
        t = B.utext(s, r)
        return "颂" if t.startswith("頌曰") or re.match(r"^[０-９]", t) else "本文"

    hdr = re.compile(r"成唯識論卷第[一二三四五六七八九十]+|護法等菩薩造三藏法師玄奘奉詔譯")
    recs = passage_text(T, "CWS", rel, src, cores, hdr, label_of, kind_of)
    for q in ("恒隨轉", "一類相續", "「恒」言遮斷", "猶如瀑流", "三法展轉因果同時", "如炷生焰、焰生焦炷", "蘆束"):
        T.problems.append(f"CWS: occurrences of {q} in the file at " + ", ".join(str(m.start()) for m in re.finditer(re.escape(q), src)))
    T.problems.append("CWS: 「「恒」言遮斷，「轉」表非常，猶如瀑流」 is at 18996 (P4); 「三法展轉因果同時，如炷生焰、焰生焦炷，亦如蘆束更互相依」 is one sentence at 14701 (P3); the second 蘆束 (識緣名色) is P7; 一類相續 at 2202, 13805, 14186, 25603, 26818, 34114 is covered by P1, P3, P6, P8, P9.")
    T.problems.append("CWS: the 頌 of 唯識三十頌 are inline, numbered with full-width digits (３, ４) that stand inside sentences; units starting with 頌曰 are typed 颂, the verse lines are not split from the 論曰 that follows within one sentence.")
    T.problems.append("CWS: 卷 boundaries (成唯識論卷第三成唯識論卷第四護法等菩薩造三藏法師玄奘奉詔譯) fall inside the merged window P6+P7+P8; they are 题 units.")
    T.problems.append("CWS: window starts and ends are snapped outward to the nearest sentence end, so context is 300 characters or a little more.")
    return T, recs


def build_wujiaozhang():
    rel = "sources/civilization-thought-v1.0/evidence/additions/fo2/FO2-FQ.txt"
    src, sha = B.read(rel)
    T = B.Text("WJZ", "《華嚴一乘教義分齊章》（五教章）第四、六相圓融義")
    T.scope = "第四、六相圓融義 to the end of 卷第四 (end of file), with about 300 characters of context before; nothing follows the passage in the file but the 尾題"
    T.sources.append(B.source_entry(rel, sha, "繁", "No.1866; 華嚴一乘教義分齊章卷第一–第四; 唐大薦福寺沙門法藏述; 尾題 華嚴一乘教義分齊章卷第四",
                                    provenance="sources/civilization-thought-v1.0/PROVENANCE.json, FO2-FQ: 华严一乘教义分齐章, url https://cbetaonline.dila.edu.tw/zh/T45n1866_001; tei header evidence/tei-headers/FO2-FQ.teiHeader.xml",
                                    role="segmented"))
    rel2 = "sources/chinese-classical-texts/atlas-v9.1/evidence/texts/R5BU003.txt"
    src2, sha2 = B.read(rel2)
    T.sources.append(B.source_entry(rel2, sha2, "繁", "same as FO2-FQ.txt", role="second copy, byte-identical to FO2-FQ.txt (same sha256), not segmented" if sha2 == sha else "second copy, differs from FO2-FQ.txt"))
    cores = [("P1", "六相圓融義（總別同異成壞；舍與椽）", "第四、六相圓融義。", "華嚴一乘教義分齊章卷第四", 40000)]
    hdr = re.compile(r"華嚴一乘教義分齊章卷第[一二三四]$")

    def kind_of(s, r):
        t = B.utext(s, r)
        return "偈" if r[0][0] >= s.index("別為頌曰", 48900) else "本文"

    recs = passage_text(T, "WJZ", rel, src, cores, hdr, lambda p: "卷第四", kind_of)
    T.problems.append("WJZ: the 六相 passage is the last section of 卷第四 and of the file; after-context is only the 尾題 (题 unit).")
    T.problems.append("WJZ: 問「…」答「…」 dialogues are 法藏's own text (not an opponent's), typed 本文; the closing 頌 (seven-character lines) is typed 偈 by form.")
    T.problems.append("WJZ: other mentions of 六相 in the file (20002, 35292, 41601–41758, 46158, 48675) are outside the frozen window; 35292 and 41915 are in the 十玄 section.")
    return T, recs


def main():
    cols = ["id", "text_id", "section", "unit_type", "text", "source", "offsets", "note"]
    zl = build_zhonglun2()
    cw, cw_recs = build_cwsl()
    wj, wj_recs = build_wujiaozhang()
    files = {"ZL2": "zhonglun-2.tsv", "CWS": "chengweishi.tsv", "WJZ": "wujiaozhang-liuxiang.tsv"}
    mp = os.path.join(HERE, "MANIFEST.json")
    man = json.load(open(mp, encoding="utf-8"))
    ids = set()
    for t in man["texts"]:
        for line in open(os.path.join(HERE, t["tsv"]), encoding="utf-8").read().split("\n")[1:]:
            if line:
                ids.add(line.split("\t", 1)[0])
    sec = {"plan": "../PLAN.md §5.3 (rows 待冻结 / 待定位)", "built_by": "build2.py", "checked_by": "verify.py",
           "conventions": "as the first round (top-level 'conventions'); new unit types 颂 (成唯識論 頌) and the passage windows below",
           "texts": []}
    for T, recs in ((zl, None), (cw, cw_recs), (wj, wj_recs)):
        fn = files[T.text_id]
        with open(os.path.join(HERE, fn), "w", encoding="utf-8", newline="") as f:
            f.write("\t".join(cols) + "\n")
            for r in T.rows:
                assert r["id"] not in ids, r["id"]
                ids.add(r["id"])
                f.write("\t".join(B.esc(r[c]) for c in cols) + "\n")
        counts = {}
        for r in T.rows:
            counts[r["unit_type"]] = counts.get(r["unit_type"], 0) + 1
        d = dict(text_id=T.text_id, title=T.title, tsv=fn, scope=T.scope, sources=T.sources,
                 units_total=len(T.rows), units_by_type=counts, problems=T.problems)
        if recs is not None:
            d["passages"] = recs
        sec["texts"].append(d)
        print(T.text_id, len(T.rows), counts)
    sec["not_in_repository"] = []
    man["second_round"] = sec
    with open(mp, "w", encoding="utf-8") as f:
        json.dump(man, f, ensure_ascii=False, indent=1)
        f.write("\n")


if __name__ == "__main__":
    main()
