#!/usr/bin/env python3
"""The "law" pass: split the files in scope into pieces, check edited pieces, join them back.

AI-written, 13 November 2026.

  pieces.py split  <tree> <outdir>      write <outdir>/<piece>.orig.md and <piece>.md, and manifest.json
  pieces.py apply  <outdir> <piece>     build <piece>.md from its .orig.md and <piece>.edits.json, then check it
  pieces.py check  <outdir> [piece...]  mechanical checks of edited pieces against their originals
  pieces.py join   <tree> <outdir>      write the edited pieces back into <tree> (only files whose pieces all pass)

A piece is a run of whole `## ` sections of one file, at most MAXW words. Lines are never added
or removed by the pass, so a piece and its original have the same number of lines.
"""
import json, os, re, sys

FILES = [
    "GLOSSARY.md",
    "theories/becoming/ONE-PAGE.md",
    "theories/becoming/THE-THEORY-OF-BECOMING.md",
    "theories/becoming/USES.md",
    "theories/becoming/USES-EXAMPLES.md",
    "theories/becoming/COLLECTIVE-DIRECTION.md",
    "theories/becoming/FREE-ENERGY-PRINCIPLE.md",
    "theories/becoming/ONE-ARGUMENT.md",
] + [f"theories/becoming/chapters/{c}.md" for c in (
    "01-ROOT", "02-MAP", "03-KNOWING", "04-LIFE", "05-COLLECTIVES",
    "07-SIGNIFICANCE", "08-METHOD")]  # 06 is written in Chinese: not in this pass

MAXW = 7000
LAW = re.compile(r"\blaws?\b", re.I)
# sections left to their owners: (file suffix, text that the section's first lines contain)
SKIP = [("02-MAP.md", 'id="turning-in-time"')]


def words(s):
    return len(re.findall(r"[A-Za-z']+", s))


def sections(lines):
    """Runs of lines, each starting at a `## ` heading (the first run is what precedes any)."""
    out, cur = [], []
    for ln in lines:
        if ln.startswith("## ") and cur:
            out.append(cur); cur = []
        cur.append(ln)
    if cur:
        out.append(cur)
    return out


def subsplit(sec):
    """An oversized section, cut at `### ` headings, then at result anchors, then at blank lines."""
    if words("\n".join(sec)) <= MAXW:
        return [sec]
    best = [sec]
    for starts in (lambda l: l.startswith("### "), lambda l: l.startswith('<a id="r-'), lambda l: l == ""):
        cuts = [i for i, l in enumerate(sec) if starts(l) and i]
        if not cuts:
            continue
        parts = [sec[a:b] for a, b in zip([0] + cuts, cuts + [len(sec)])]
        out, cur = [], []
        for part in parts:
            if cur and words("\n".join(cur + part)) > MAXW:
                out.append(cur); cur = []
            cur = cur + part
        out.append(cur)
        if max(words("\n".join(o)) for o in out) < max(words("\n".join(o)) for o in best):
            best = out
        if max(words("\n".join(o)) for o in best) <= MAXW * 1.3:
            break
    return best


def is_skip(path, sec, prev_tail):
    head = "".join(prev_tail[-2:] + sec[:2])
    return any(path.endswith(sfx) and mark in head for sfx, mark in SKIP)


def split(tree, out):
    os.makedirs(out, exist_ok=True)
    manifest = []
    for path in FILES:
        full = os.path.join(tree, path)
        lines = open(full, encoding="utf-8").read().split("\n")
        secs = sections(lines)
        # an anchor line just before a heading belongs to the section it names
        for i in range(1, len(secs)):
            while secs[i - 1] and (secs[i - 1][-1].startswith("<a id=") or secs[i - 1][-1] == ""):
                secs[i].insert(0, secs[i - 1].pop())
        groups, cur, curw = [], [], 0
        for i, sec in enumerate(secs):
            w = words("\n".join(sec))
            skip = is_skip(path, sec, secs[i - 1] if i else [])
            if skip:
                if cur:
                    groups.append((cur, False)); cur, curw = [], 0
                groups.append((sec, True)); continue
            for part in subsplit(sec):
                w = words("\n".join(part))
                if cur and curw + w > MAXW:
                    groups.append((cur, False)); cur, curw = [], 0
                cur = cur + part; curw += w
        if cur:
            groups.append((cur, False))
        assert sum(len(g) for g, _ in groups) == len(lines), path
        stem = os.path.basename(path)[:-3]
        for n, (g, skip) in enumerate(groups):
            name = f"{stem}--{n:02d}"
            text = "\n".join(g)
            laws = len(LAW.findall(text))
            for ext in (".orig.md", ".md"):
                with open(os.path.join(out, name + ext), "w", encoding="utf-8") as f:
                    f.write(text)
            manifest.append({"piece": name, "file": path, "lines": len(g), "words": words(text),
                             "law": laws, "skip": bool(skip or laws == 0),
                             "first": next((l for l in g if l.strip()), "")[:80]})
    with open(os.path.join(out, "manifest.json"), "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=1, ensure_ascii=False)
    todo = [m for m in manifest if not m["skip"]]
    print(f"{len(manifest)} pieces, {len(todo)} to edit, law in them {sum(m['law'] for m in todo)}, "
          f"largest {max(m['words'] for m in todo)} words")
    for m in manifest:
        print(f"  {m['piece']:34s} lines {m['lines']:4d} words {m['words']:6d} law {m['law']:4d} {'skip' if m['skip'] else ''}")


def apply(out, name):
    """Build <name>.md from <name>.orig.md and <name>.edits.json: [{"line": N, "old": "...", "new": "..."}]."""
    orig = open(os.path.join(out, name + ".orig.md"), encoding="utf-8").read().split("\n")
    edits = json.load(open(os.path.join(out, name + ".edits.json"), encoding="utf-8"))
    new, errs = list(orig), []
    for k, e in enumerate(edits):
        i = e["line"] - 1
        if not (0 <= i < len(orig)):
            errs.append(f"edit {k}: no line {e['line']}"); continue
        n = new[i].count(e["old"])
        if n != 1:
            errs.append(f"edit {k} (line {e['line']}): 'old' occurs {n} times in the line; give more of the sentence"); continue
        if not LAW.search(e["old"]):
            errs.append(f"edit {k} (line {e['line']}): 'old' has no 'law' in it"); continue
        new[i] = new[i].replace(e["old"], e["new"])
    if errs:
        print(f"NOT applied: {len(errs)} of {len(edits)} edits are wrong")
        for x in errs:
            print("  " + x)
        return 1
    with open(os.path.join(out, name + ".md"), "w", encoding="utf-8") as f:
        f.write("\n".join(new))
    print(f"applied {len(edits)} edits to {name}.md")
    errs, changed, left = check_piece(out, name)
    print(f"mechanical check: {'FAIL' if errs else 'ok'}; lines changed {changed}; 'law' left {left}")
    for x in errs:
        print("  " + x)
    return 1 if errs else 0


TICK = re.compile(r"`[^`]*`")
LINK = re.compile(r"\[[^\]]*\]\([^)]*\)")
ANCH = re.compile(r"<a id=\"[^\"]*\"></a>")
CJK = re.compile(r"[㐀-鿿]+")
QUOTE = re.compile(r"[“\"][^”\"]{12,}[”\"]")


def frozen(line):
    """What a changed line must keep exactly: code, links, anchors, Chinese, longer quotations."""
    t = TICK.findall(line)
    rest = TICK.sub(" ", line)
    return {"backticks": t, "links": LINK.findall(rest), "anchors": ANCH.findall(rest),
            "chinese": CJK.findall(rest), "quotes": QUOTE.findall(LINK.sub(" ", rest))}


WAIVE = []


def check_piece(out, name):
    global WAIVE
    wp = os.path.join(out, "waive.json")
    WAIVE = json.load(open(wp)) if os.path.exists(wp) else []
    a = open(os.path.join(out, name + ".orig.md"), encoding="utf-8").read().split("\n")
    b = open(os.path.join(out, name + ".md"), encoding="utf-8").read().split("\n")
    errs, changed = [], 0
    if len(a) != len(b):
        return [f"line count {len(a)} -> {len(b)}"], 0, 0
    for i, (x, y) in enumerate(zip(a, b), 1):
        if x == y:
            continue
        changed += 1
        if x.startswith("#"):
            errs.append(f"line {i}: a heading was changed"); continue
        if x.startswith(">"):
            errs.append(f"line {i}: a quoted line was changed"); continue
        fx, fy = frozen(x), frozen(y)
        for k in fx:
            if fx[k] != fy[k] and [name, i, k] not in WAIVE:
                errs.append(f"line {i}: {k} differ"); break
        # the change should be small: words removed should be about law
        wx, wy = re.findall(r"[A-Za-z]+", x), re.findall(r"[A-Za-z]+", y)
        gone = [w for w in set(wx) if wx.count(w) > wy.count(w)]
        if not any(LAW.fullmatch(w) for w in gone):
            errs.append(f"line {i}: changed without removing 'law'")
        if abs(len(wy) - len(wx)) > 12 + 3 * sum(1 for w in wx if LAW.fullmatch(w)):
            errs.append(f"line {i}: length changed by {len(wy) - len(wx)} words")
    left = sum(len(LAW.findall(l)) for l in b)
    return errs, changed, left


def check(out, names):
    man = json.load(open(os.path.join(out, "manifest.json"), encoding="utf-8"))
    bad = 0
    for m in man:
        if names and m["piece"] not in names:
            continue
        errs, changed, left = check_piece(out, m["piece"])
        if m["skip"] and changed:
            errs.append("a skipped piece was edited")
        flag = "FAIL" if errs else "ok"
        bad += bool(errs)
        print(f"{flag:4s} {m['piece']:34s} lines changed {changed:4d}  law {m['law']:4d} -> {left:4d}")
        for e in errs[:12]:
            print("       " + e)
    return bad


def join(tree, out):
    man = json.load(open(os.path.join(out, "manifest.json"), encoding="utf-8"))
    byfile = {}
    for m in man:
        byfile.setdefault(m["file"], []).append(m)
    for path, ms in byfile.items():
        if any(check_piece(out, m["piece"])[0] for m in ms):
            print("NOT joined (a piece fails):", path); continue
        orig = "\n".join(open(os.path.join(out, m["piece"] + ".orig.md"), encoding="utf-8").read() for m in ms)
        full = os.path.join(tree, path)
        cur = open(full, encoding="utf-8").read()
        if cur != orig:
            print("NOT joined (the tree's file is no longer the one that was split):", path); continue
        new = "\n".join(open(os.path.join(out, m["piece"] + ".md"), encoding="utf-8").read() for m in ms)
        if new != cur:
            with open(full, "w", encoding="utf-8") as f:
                f.write(new)
        print(f"joined {path}: {sum(1 for x, y in zip(cur.split(chr(10)), new.split(chr(10))) if x != y)} lines changed")


if __name__ == "__main__":
    cmd = sys.argv[1]
    if cmd == "split":
        split(sys.argv[2], sys.argv[3])
    elif cmd == "check":
        sys.exit(1 if check(sys.argv[2], sys.argv[3:]) else 0)
    elif cmd == "apply":
        sys.exit(apply(sys.argv[2], sys.argv[3]))
    elif cmd == "join":
        join(sys.argv[2], sys.argv[3])
