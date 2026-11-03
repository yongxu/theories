#!/usr/bin/env python3
"""R31, item 5: the layers of the core, computed, and the module tables generated from them.

A module's layer is a checkable property of its source and imports (read by graph.py):
* L0: the base, `Becoming.World` with every module of the package it imports (Frame, Prelude, and the grammar's Grammar,
  GrammarMap and GrammarLaws, on which the frame rests);
* the foundation, `GenerativeCore`, `InquirySufficiency` and `RelationalRenewal`, lies below them in no layer: checked
  with the core and not counted in it (08 §3), it heads each table in a row of its own (`Foundation`, `基础`), which
  `--write` keeps as it is;
* L2: a module whose source, outside comments and imports, names the continuation condition or a
  valuation (`Unrestricted`, `Valuation`), or that imports an L2 module;
* L1: every other module of the core.
So no module imports one of a higher layer, which `check()` asserts. The instance and application ring
(the checker's `INSTANCES` and `APPLICATIONS`) is outside the core by direction (08 §3) and in no layer:
its rows are labelled by the ring (`Instance`, `Application`; `实例`, `应用`) and follow the layers.

`python3 layers.py` prints the foundation, the layers and the counts, and checks that every row of the
two tables carries its computed label; `--write` regenerates, from the import graph and the checker's
lists:
* the module table of the Lean README (`README.md`) and of its Chinese edition (`README.zh.md`),
  one row per core and ring module in an import order, layers first and the ring after them; each
  row keeps the description it had, and the modules R31 added take theirs from NOTES below (the
  Chinese table keeps the modules it had and adds R31's);
* the sentence after each table that says how the layers import one another.
`--notes` also retags the module notes in `Becoming.lean`, the ring's as `instance` or `application`
(a tag's reason, as in `(L2, through …)`, kept where the label stays and dropped where it changes);
it adds a note for each module R31 added (after the note of the module named by `after`) and, for any
other core or ring module without one, a note from its doc's subtitle after the nearest module before
it in the README's order that has one; it drops the note of a module that is gone. It changes the
root's bytes, so it waits for a change that renews the core's receipt. Every line starting like a
note must carry a tag `NOTE` reads, or the run stops. The plain run reports, without changing its exit
status, the root's notes whose label is not the computed one, the modules noted more than once (those
whose notes stand next to each other marked), notes of modules in no layer or ring, and reasons
`through Y` that are not an L2 module the noted module imports.
"""
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import graph  # noqa: E402

PKG = graph.PKG
# The base is computed: the World with every module of the package it imports (board item DF2, 27 October 2026; before the
# grammar joined it, the same rule gave World, Frame and Prelude).
BASE = ["Becoming.World"]
NOTES = json.load(open(HERE / "module-notes.json"))
GONE = ["Becoming.Order", "Becoming.Naturals", "Becoming.ListTests"]
# The foundation's row in each table: in no layer (08 §3).
FOUNDATION_ROW = ("| Foundation | ", "| 基础 | ")


RING = {"en": {"instance": "Instance", "application": "Application"}, "zh": {"instance": "实例", "application": "应用"}}


def ring():
    """The instance and application ring, in no layer."""
    return {**{m: "instance" for m in graph.checker_list("INSTANCES")},
            **{m: "application" for m in graph.checker_list("APPLICATIONS")}}


def label(m, layer, rim, lang):
    return f"L{layer[m]}" if m in layer else RING[lang][rim[m]]


def note_label(m, layer, rim):
    return f"L{layer[m]}" if m in layer else rim[m]


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


def order(core, mods, rank, prior):
    """Layers first, then the ring; within each, an import order, earlier rows first where free."""
    done, out = set(), []
    pending = sorted(core, key=lambda m: (rank[m], prior.get(m, 1e9)))
    while pending:
        for k, m in enumerate(pending):
            if all(i in done or i not in rank for i in mods[m]["imports"]):
                out.append(m)
                done.add(m)
                del pending[k]
                break
        else:
            raise SystemExit("import cycle")
    return out


ROW = re.compile(r"^\| (base|基底|L\d|Instance|Application|实例|应用) \| \[`(Becoming\.[\w]+)`\]\(Becoming/[\w]+\.lean\) \| (.*) \|$")


def table(path, core, mods, layer, rim, lang):
    lines = path.read_text().split("\n")
    rows = [k for k, l in enumerate(lines) if ROW.match(l)]
    first, last = rows[0], rows[-1]
    assert all(ROW.match(lines[k]) for k in range(first, last + 1)), path
    assert lines[first - 1].startswith(FOUNDATION_ROW), path
    desc, prior = {}, {}
    for n, k in enumerate(rows):
        m = ROW.match(lines[k])
        desc[m.group(2)] = m.group(3)
        prior[m.group(2)] = n
    for m, note in NOTES.items():
        if m not in desc:
            desc[m] = note[lang]
            prior[m] = prior.get(note["after"], 0) + 0.5
    listed = core + list(rim)
    rank = {**layer, **{m: 3 if r == "instance" else 4 for m, r in rim.items()}}
    if lang == "en":
        last_prior = -1
        for m in listed:
            if m in prior:
                last_prior = prior[m]
            else:
                desc[m] = title(mods[m]["src"])
                last_prior += 0.01
                prior[m] = last_prior
    keep = sorted((m for m in order(listed, mods, rank, prior) if m in desc), key=lambda m: rank[m])
    body = [f"| {label(m, layer, rim, lang)} | [`{m}`](Becoming/{m[9:]}.lean) | {desc[m]} |" for m in keep]
    new = lines[:first] + body + lines[last + 1:]
    return "\n".join(new), keep


SENTENCE = {
    "en": ("The layers are computed",
           "The layers are computed (`development/r31-support/layers.py` in the R31 kit, which checks each "
           "row's label and can write this table): L0 is the base, `Becoming.World` with every module of the package it imports "
           "(`Becoming.Frame`, `Becoming.Prelude` and the grammar's `Becoming.Grammar`, `Becoming.GrammarMap` "
           "and `Becoming.GrammarLaws`, on which the frame rests), on the foundation, whose three modules are "
           "in no layer and head the table; L2 holds the modules whose source states the continuation condition or a valuation "
           "(`Unrestricted`, `Valuation`) and every module importing one of them; L1 holds the rest. No "
           "module imports one of a higher layer, which the script checks. The instance and application ring is "
           "outside the core by direction and in no layer; its rows are labelled Instance or Application. "
           "Within a layer the rows follow an import order."),
    "zh": ("各层由计算给出",
           "各层由计算给出（R31 工具包中的 `development/r31-support/layers.py`，它检查每行的标签，也可写出本表）：L0 是基底，即 "
           "`Becoming.World` 及其导入的本包每个模块（`Becoming.Frame`、`Becoming.Prelude`，以及框架所依的文法模块 "
           "`Becoming.Grammar`、`Becoming.GrammarMap` 与 `Becoming.GrammarLaws`），立于基础之上（基础的三个模块不属任何"
           "一层，列于表首）；L2 是源码陈述延续条件或赋值"
           "（`Unrestricted`、`Valuation`）的模块，以及导入其中任一者的模块；其余为 L1。没有模块导入更高层的模块，"
           "脚本检查这一点。实例与应用环按方向在核心之外，不属任何一层，其行标为实例或应用。层内各行按一种导入顺序排列。"),
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


def labels(path, core, layer, rim, lang):
    """The rows whose label is not the computed one, and the rows of core or ring modules missing."""
    lines = path.read_text().split("\n")
    rows = [ROW.match(l) for l in lines if ROW.match(l)]
    first = next(k for k, l in enumerate(lines) if ROW.match(l))
    wrong = [(m.group(2), m.group(1)) for m in rows
             if m.group(2) not in layer and m.group(2) not in rim
             or m.group(1) != label(m.group(2), layer, rim, lang)]
    if not lines[first - 1].startswith(FOUNDATION_ROW):
        wrong.append(("the foundation's row", lines[first - 1][:40]))
    have = {m.group(2) for m in rows}
    return len(rows), wrong, [m for m in core + list(rim) if m not in have]


# A note's tag is its label, with a reason after a comma where one is given (`(L2, through …)`,
# `(L1, instance ring)`): group 2 is the label, group 3 the reason.
NOTE = re.compile(r"^\* `(Becoming\.[\w]+)` \((base|L\d|instance|application)(, [^)]*)?\):")


def retag(line, m, label):
    """The note's first line with its label computed: the reason kept where the label stays, dropped
    where it changes (the reason was given for the old label)."""
    reason = (m.group(3) or "") if m.group(2) == label else ""
    return line[:m.start(2) - 1] + f"({label}{reason})" + line[m.end() - 1:]


NOTE_START = re.compile(r"^\* `Becoming\.")


def note_lines(text):
    """The notes' first lines, every line that starts like one read by `NOTE`, so that a tag of a
    new form fails here rather than leaving its module without a note found."""
    found = []
    for l in text.split("\n"):
        if NOTE_START.match(l):
            m = NOTE.match(l)
            assert m, ("a note's tag of a form NOTE does not read", l[:80])
            found.append(m)
    return found


THROUGH = re.compile(r"^, through `(Becoming\.[\w]+)`$")


def note_report(text, layer, rim, mods):
    """The root's notes whose label is not the computed one; the modules noted more than once, those
    whose notes stand next to each other marked; notes of modules in neither a layer nor the ring;
    and reasons `through Y` where `Y` is not an L2 module the noted module imports, or where the
    module names the condition or a valuation itself."""
    found = note_lines(text)
    names = [m.group(1) for m in found]
    wrong = [(m.group(1), m.group(2)) for m in found
             if (m.group(1) in layer or m.group(1) in rim) and m.group(2) != note_label(m.group(1), layer, rim)]
    twice = []
    for k, n in enumerate(names):
        if names.count(n) > 1 and n not in [t for t, _ in twice]:
            near = any(names[j] == names[j + 1] == n for j in range(len(names) - 1))
            twice.append((n, near))
    outside = [n for n in names if n not in layer and n not in rim and n != "Becoming"]
    reasons = []
    for m in found:
        t = THROUGH.match(m.group(3) or "")
        if t and m.group(1) in mods:
            y, src = t.group(1), graph.strip_comments(mods[m.group(1)]["src"])
            if y not in mods[m.group(1)]["imports"] or layer.get(y) != 2:
                reasons.append((m.group(1), "through " + y, "not an L2 module it imports"))
            elif graph.CONDITIONAL.search(src):
                reasons.append((m.group(1), "through " + y, "true, though the module names one itself"))
    return len(found), wrong, twice, outside, reasons


def notes(text, core, layer, rim, mods, order_en):
    """Retag every note, drop the notes of modules that are gone, and add a note for each core
    module without one: R31's from NOTES after its `after`, any other after the nearest module
    before it in the README's order that has a note."""
    lines = text.split("\n")
    have = {m.group(1) for m in note_lines(text)}
    anchor = {}
    for new, note in NOTES.items():
        if new not in have:
            anchor.setdefault(note["after"], []).append(new)
    for i, m in enumerate(order_en):
        if m in have or m in NOTES:
            continue
        before = [x for x in order_en[:i] if x in have]
        assert before, ("no noted module before", m)
        anchor.setdefault(before[-1], []).append(m)

    def emit(name, out, seen):
        for new in anchor.get(name, []):
            if new in seen:
                continue
            body = NOTES[new]["note"] if new in NOTES else [title(mods[new]["src"]) + "."]
            out.append(f"* `{new}` ({note_label(new, layer, rim)}): " + body[0])
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
                assert name in layer or name in rim, name
                block[0] = retag(l, m, note_label(name, layer, rim))
                out += block
                seen.add(name)
            emit(name, out, seen)
            k = j
            continue
        out.append(l)
        k += 1
    missing = [m for m in core + list(rim) if m not in seen]
    assert not missing, missing
    return "\n".join(out)


def main():
    core, mods, clo, layer, direct = layers()
    check(core, mods, layer)
    rim = ring()
    counts = [sum(1 for m in core if layer[m] == k) for k in range(3)]
    print(f"foundation, in no layer and not counted in the core: {', '.join(graph.checker_list('FOUNDATION'))}")
    print(f"core modules {len(core) + 1}: the root Becoming, and {len(core)} in layers: L0 {counts[0]}, "
          f"L1 {counts[1]}, L2 {counts[2]} (of which {len(direct)} state the condition or a valuation)")
    print("L0:", ", ".join(m for m in core if layer[m] == 0))
    kinds = [sum(1 for r in rim.values() if r == k) for k in ("instance", "application")]
    print(f"ring, outside the core and in no layer: {len(rim)} ({kinds[0]} instances, {kinds[1]} applications)")
    if "--list" in sys.argv:
        for m in core:
            if layer[m] == 2:
                print("L2", m, "states" if m in direct else "imports")
    bad = False
    for name, lang in (("README.md", "en"), ("README.zh.md", "zh")):
        n, wrong, missing = labels(PKG / name, core, layer, rim, lang)
        print(f"{name}: {n} rows, {len(wrong)} labels other than computed"
              + (f", {len(missing)} modules without a row" if lang == "en" else ""))
        for w in wrong:
            print("  ", *w)
        bad = bad or bool(wrong) or (lang == "en" and bool(missing))
    n, wrong, twice, outside, reasons = note_report((PKG / "Becoming.lean").read_text(), layer, rim, mods)
    plain = "--notes" not in sys.argv
    print(f"Becoming.lean: {n} notes, {len(wrong)} labels other than computed, "
          f"{len(twice)} modules noted more than once, {len(outside)} notes of modules in no layer or ring"
          + (" (reported, not changed: the root's bytes wait for a core run)" if plain else ""))
    for w in wrong:
        print("   label", *w)
    print("   noted more than once:", ", ".join(t + (" (next to each other)" if near else "") for t, near in twice))
    for o in outside:
        print("   in no layer or ring", o)
    for r in reasons:
        print("   reason", *r)
    if "--write" not in sys.argv and "--notes" not in sys.argv:
        sys.exit(1 if bad else 0)
    order_en, out = None, {}
    for name, lang in (("README.md", "en"), ("README.zh.md", "zh")):
        text, keep = table(PKG / name, core, mods, layer, rim, lang)
        order_en = order_en or keep
        out[name] = sentence(text, lang)
        print(name, "rows", len(keep))
    if "--notes" in sys.argv:
        out["Becoming.lean"] = notes((PKG / "Becoming.lean").read_text(), core, layer, rim, mods, order_en)
    for name, text in out.items():
        (PKG / name).write_text(text)
    print("written:", ", ".join(out))

if __name__ == "__main__":
    main()
