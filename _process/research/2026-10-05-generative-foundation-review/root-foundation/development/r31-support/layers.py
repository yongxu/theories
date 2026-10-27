#!/usr/bin/env python3
"""R31, item 5: the layers of the core, computed, and the module tables generated from them.

A module's layer is a checkable property of its source and imports (read by graph.py):
* L0: the base, `Becoming.World` with every module it imports (Frame, Prelude, and the grammar's Grammar,
  GrammarMap and GrammarLaws, on which the frame rests; the foundation
  `GenerativeCore`, `InquirySufficiency`, `RelationalRenewal` lies below them);
* L2: a module whose source, outside comments and imports, names the continuation condition or a
  valuation (`Unrestricted`, `Valuation`), or that imports an L2 module;
* L1: every other module of the core.
So no module imports one of a higher layer, which `check()` asserts.

`python3 layers.py` prints the layers and the counts; `--write` regenerates, from the import graph
and the checker's CORE list:
* the module table of the Lean README (`README.md`) and of its Chinese edition (`README.zh.md`),
  one row per core module in an import order, layers first; each row keeps the description it had,
  and the modules R31 added take theirs from NOTES below (the Chinese table keeps the modules it
  had and adds R31's);
* the layer tags of the module notes in `Becoming.lean`, with a note for each module R31 added
  (after the note of the module named by `after`) and none for a module that is gone;
* the sentence after each table that says how the layers import one another.
"""
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import graph  # noqa: E402

PKG = graph.PKG
# The base is computed: the World with every module it imports (board item DF2, 27 October 2026; before the
# grammar joined it, the same rule gave World, Frame and Prelude).
BASE = ["Becoming.World"]
NOTES = json.load(open(HERE / "module-notes.json"))
GONE = ["Becoming.Order", "Becoming.Naturals", "Becoming.ListTests"]


def layers():
    mods = graph.modules()
    core = [m for m in graph.core_list() if m != "Becoming"]
    clo = graph.closures(mods)
    direct = {m for m in core if graph.CONDITIONAL.search(graph.strip_comments(mods[m]["src"]))}
    layer = {}
    for m in core:
        if m in BASE or any(m in clo[b] for b in BASE):
            layer[m] = 0
        elif m in direct or any(i in direct for i in clo[m]):
            layer[m] = 2
        else:
            layer[m] = 1
    return core, mods, clo, layer, direct


def check(core, mods, layer):
    for m in core:
        for i in mods[m]["imports"]:
            if i in layer:
                assert layer[i] <= layer[m], (m, i, layer[m], layer[i])


def order(core, mods, layer, prior):
    """Layers first; within a layer, an import order, earlier rows first where free."""
    done, out = set(), []
    pending = sorted(core, key=lambda m: (layer[m], prior.get(m, 1e9)))
    while pending:
        for k, m in enumerate(pending):
            if all(i in done or i not in layer for i in mods[m]["imports"]):
                out.append(m)
                done.add(m)
                del pending[k]
                break
        else:
            raise SystemExit("import cycle")
    return out


ROW = re.compile(r"^\| (base|基底|L\d) \| \[`(Becoming\.[\w]+)`\]\(Becoming/[\w]+\.lean\) \| (.*) \|$")


def table(path, core, mods, layer, lang):
    lines = path.read_text().split("\n")
    rows = [k for k, l in enumerate(lines) if ROW.match(l)]
    first, last = rows[0], rows[-1]
    assert all(ROW.match(lines[k]) or lines[k].startswith("| L0 | `GenerativeCore`")
               for k in range(first, last + 1)), path
    desc, prior = {}, {}
    for n, k in enumerate(rows):
        m = ROW.match(lines[k])
        desc[m.group(2)] = m.group(3)
        prior[m.group(2)] = n
    for m, note in NOTES.items():
        if m not in desc:
            desc[m] = note[lang]
            prior[m] = prior.get(note["after"], 0) + 0.5
    if lang == "en":
        last_prior = -1
        for m in core:
            if m in prior:
                last_prior = prior[m]
            else:
                desc[m] = title(mods[m]["src"])
                last_prior += 0.01
                prior[m] = last_prior
    foundation =[l for l in lines[first:last + 1] if l.startswith("| L0 | `GenerativeCore`")]
    keep = [m for m in order(core, mods, layer, prior) if m in desc]
    body = []
    for m in keep:
        body.append(f"| L{layer[m]} | [`{m}`](Becoming/{m[9:]}.lean) | {desc[m]} |")
    lead = [r for r in body if r.startswith("| L0 ")]
    rest = [r for r in body if not r.startswith("| L0 ")]
    new = lines[:first] + foundation + lead + rest + lines[last + 1:]
    return "\n".join(new), keep


SENTENCE = {
    "en": ("Each layer imports only those below it",
           "The layers are computed (`development/r31-support/layers.py` in the R31 kit, which writes this "
           "table): L0 is the base, `Becoming.World`, `Becoming.Frame` and `Becoming.Prelude`, on the "
           "foundation; L2 holds the modules whose source states the continuation condition or a valuation "
           "(`Unrestricted`, `Valuation`) and every module importing one of them; L1 holds the rest. No "
           "module imports one of a higher layer, which the script checks. Within a layer the rows follow an "
           "import order."),
    "zh": ("每层只导入它下面的层",
           "各层由计算给出（R31 工具包中的 `development/r31-support/layers.py`，它写出本表）：L0 是基底 "
           "`Becoming.World`、`Becoming.Frame` 与 `Becoming.Prelude`，在基础之上；L2 是源码陈述延续条件或赋值"
           "（`Unrestricted`、`Valuation`）的模块，以及导入其中任一者的模块；其余为 L1。没有模块导入更高层的模块，"
           "脚本检查这一点。层内各行按导入顺序排列。"),
}


def sentence(text, lang):
    head, new = SENTENCE[lang]
    lines = text.split("\n")
    hits = [k for k, l in enumerate(lines) if l.startswith(head)]
    assert len(hits) <= 1, hits
    if hits:
        lines[hits[0]] = new
    else:
        assert any(l == new for l in lines), lang
    return "\n".join(lines)


def title(src):
    """The subtitle of a module's doc (`# Name: subtitle`), its description where it has none."""
    t = re.search(r"^# ([^\n]+)$", src, re.M).group(1)
    return t.split(": ", 1)[1] if ": " in t else t


NOTE = re.compile(r"^\* `(Becoming\.[\w]+)` \((base|L\d)\):")


def notes(text, core, layer, mods, order_en):
    """Retag every note, drop the notes of modules that are gone, and add a note for each core
    module without one: R31's from NOTES after its `after`, any other after the nearest module
    before it in the README's order that has a note."""
    lines = text.split("\n")
    have = {m.group(1) for m in map(NOTE.match, lines) if m}
    anchor = {}
    for new, note in NOTES.items():
        if new not in have:
            anchor.setdefault(note["after"], []).append(new)
    for i, m in enumerate(order_en):
        if m in have or m in NOTES:
            continue
        before = [x for x in order_en[:i] if x in have]
        anchor.setdefault(before[-1], []).append(m)

    def emit(name, out, seen):
        for new in anchor.get(name, []):
            if new in seen:
                continue
            body = NOTES[new]["note"] if new in NOTES else [title(mods[new]["src"]) + "."]
            out.append(f"* `{new}` (L{layer[new]}): " + body[0])
            out.extend("  " + x for x in body[1:])
            seen.add(new)
            emit(new, out, seen)

    out, k, seen = [], 0, set()
    while k < len(lines):
        l = lines[k]
        m = NOTE.match(l)
        if m:
            name = m.group(1)
            j = k + 1
            while j < len(lines) and lines[j].startswith("  ") and not NOTE.match(lines[j]):
                j += 1
            block = lines[k:j]
            if not (name in GONE and name not in layer):
                assert name in layer, name
                block[0] = l.replace(f"({m.group(2)}):", f"(L{layer[name]}):", 1)
                out += block
                seen.add(name)
            emit(name, out, seen)
            k = j
            continue
        out.append(l)
        k += 1
    missing = [m for m in core if m not in seen]
    assert not missing, missing
    return "\n".join(out)


def main():
    core, mods, clo, layer, direct = layers()
    check(core, mods, layer)
    counts = [sum(1 for m in core if layer[m] == k) for k in range(3)]
    print(f"core modules {len(core)}: L0 {counts[0]}, L1 {counts[1]}, L2 {counts[2]} "
          f"(of which {len(direct)} state the condition or a valuation)")
    if "--list" in sys.argv:
        for m in core:
            if layer[m] == 2:
                print("L2", m, "states" if m in direct else "imports")
    if "--write" not in sys.argv:
        return
    order_en = None
    for name, lang in (("README.md", "en"), ("README.zh.md", "zh")):
        path = PKG / name
        text, keep = table(path, core, mods, layer, lang)
        order_en = order_en or keep
        text = sentence(text, lang)
        path.write_text(text)
        print(name, "rows", len(keep))
    path = PKG / "Becoming.lean"
    path.write_text(notes(path.read_text(), core, layer, mods, order_en))
    print("Becoming.lean notes retagged")


if __name__ == "__main__":
    main()
