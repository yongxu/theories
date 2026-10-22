#!/usr/bin/env python3
"""Check the frozen corpus: source hashes, every unit against its offsets,
id uniqueness, the 金師子章 layer files against the combined file, and the
quotations cited in PLAN.md §一 and §5.2."""
import hashlib, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, *[".."] * 7))


def unescape(t):
    out, i = [], 0
    while i < len(t):
        if t[i] == "\\" and i + 1 < len(t):
            out.append({"\\": "\\", "t": "\t", "n": "\n", "r": "\r"}[t[i + 1]])
            i += 2
        else:
            out.append(t[i])
            i += 1
    return "".join(out)


def main():
    man = json.load(open(os.path.join(HERE, "MANIFEST.json"), encoding="utf-8"))
    cache, fails, total, ids = {}, 0, 0, set()
    allunits = []
    for t in man["texts"]:
        for s in t["sources"]:
            b = open(os.path.join(REPO, s["path"]), "rb").read()
            h = hashlib.sha256(b).hexdigest()
            if h != s["sha256"]:
                print("HASH MISMATCH", s["path"]); fails += 1
            cache[s["path"]] = b.decode("utf-8")
        rows = open(os.path.join(HERE, t["tsv"]), encoding="utf-8").read().split("\n")
        cols = rows[0].split("\t")
        n = 0
        for line in rows[1:]:
            if not line:
                continue
            r = dict(zip(cols, line.split("\t")))
            r["text"] = unescape(r["text"])
            src = cache[r["source"]]
            got = "".join(src[int(a):int(b)] for a, b in (x.split("-") for x in r["offsets"].split(";")))
            if got != r["text"]:
                print("OFFSET MISMATCH", r["id"]); fails += 1
            if r["id"] in ids:
                print("DUPLICATE ID", r["id"]); fails += 1
            ids.add(r["id"])
            n += 1
            allunits.append(r)
        if n != t["units_total"]:
            print("COUNT MISMATCH", t["text_id"], n, t["units_total"]); fails += 1
        total += n
        print(f"{t['text_id']}: {n} units checked")
    # 金師子章 layers: each an in-order subsequence of the combined file
    K = re.sub(r"\s", "", cache["sources/civilization-thought-v1.0/evidence/additions/fo2/FO2-KS.txt"])
    for lay in ("FO2-KS-P.txt", "FO2-KS-C.txt"):
        L = re.sub(r"\s", "", cache["sources/civilization-thought-v1.0/evidence/additions/fo2/" + lay])
        i, ok = 0, True
        for ch in L:
            j = K.find(ch, i)
            if j < 0:
                ok = False; break
            i = j + 1
        print(f"JSZ layer {lay} in-order subsequence of FO2-KS.txt: {ok}")
        fails += not ok
    print(f"TOTAL {total} units, {fails} failures")
    # quotation spot-check: search units, ignoring punctuation and whitespace
    strip = lambda s: re.sub(r"[\s，。；：？！、「」『』“”]", "", s)
    quotes = [
        ("四相 念念相續", "念念相續"), ("四相 生住異滅", "則知心相生住異滅"),
        ("四相 俱時而有", "以四相俱時而有，皆無自立"),
        ("六相 總相", "師子是總相，五根差別是別相"), ("六相 同異", "共一緣起是同相，眼耳各不相到是為異相"),
        ("六相 成壞", "諸根合會是成相，諸緣各住自位是壞相"), ("六相 無孤單法", "顯法界中無孤單法"),
        ("火傳", "指窮於爲薪，火傳也，不知其盡也"),
        ("正名 二實 (簡)", "状同而为异所者，虽可合，谓之二实"), ("正名 化 (簡)", "状变而实无别而为异者，谓之化"),
        ("正名 一實 (簡)", "有化而无别，谓之一实"), ("正名 同狀異所 (簡)", "物有同状而异所者，有异状而同所者，可别也"),
        ("墨經 化", "化，徵易也"), ("墨經 久", "久，彌異時也"), ("墨經 宇", "宇，彌異所也"),
        ("墨經 始", "始，當時也"), ("墨經 同", "同，異而俱於之一也"), ("墨經 體", "體，分於兼也"),
        ("中論 不常不斷", "不生亦不滅，不常亦不斷"),
    ]
    for name, q in quotes:
        hits = [u["id"] for u in allunits if strip(q) in strip(u["text"])]
        exact = [u["id"] for u in allunits if q in u["text"]]
        print(f"QUOTE {name}: {', '.join(hits) if hits else 'NOT FOUND'}"
              + ("" if exact or not hits else "  (found only ignoring punctuation)"))
    sys.exit(1 if fails else 0)


if __name__ == "__main__":
    main()
