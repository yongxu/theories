#!/usr/bin/env python3
"""RV21c: a record's axiom sentences brought to its renewed receipt's reports (the coordinator's ruling, 31 October).

A re-pointed record whose bound module reports fewer axioms in the renewed receipt than in the earlier one may state
the earlier reports in its own text ("propext in 13 of its 19 declarations, ... as the receipt reports"). Bound to
the renewed receipt as it stands, such a sentence would state figures the receipt no longer reports. AXIOM-SPECS.json
gives, for each such record, every sentence that states those reports as a template over the reports' counts, and
the sentence in its home section the same way. A template rendered with the earlier receipt's reports must occur
exactly once in the current text, at digit boundaries (so it reads the sentence as written); rendered with the
renewed receipt's reports, it gives the new text, so the sentence then says exactly what the renewed receipt reports
(its figures, and the clause of a class of report that appears or disappears). Only reductions are rewritten: the
same declarations, none gaining an axiom, at least one fewer; anything else stops, for the coordinator. Each
rewritten record gains the spec's history note, dated. The passing date and the run stamp follow in swap_stamps.py,
whose axiom-report guards give way for these records, since the sentence then describes the renewed run. Before any
rewrite, swap_stamps.kept_earlier (the swaps' own per-record logic) is asked, for each receipt whose module changed,
whether the swaps would leave the record naming an earlier run of it (its stamp left, an earlier run named, its date
left); if so the run stops, so a record is never rewritten whose stamp or date would then name the earlier run.

Which records. Every record bound to a renewed receipt (a passed periphery checker's pointer or runs, or an older-
layout receipt renewed in place), binding by binding: the bound file's module where the receipt audits it, or else
(a file the receipt compiles but does not audit as a module) every module the receipt audits. A record is read where
any of those modules' reports changed and its text or home section mentions an axiom or a count of reports
(MENTION). Then every such mention, in every field and in the home section, must lie inside an entry's stretch: a
template's, a reports entry's (below), or a `holds` entry's `text` with its reason (a stretch that states no report of
a module the record binds); every changed module must be read by a template or reports entry; anything else stops. So
the swaps' bypass for a rewritten record leaves no sentence about its reports unread.

Template syntax. Counts over the entry's declarations ("module": every declaration its module's receipt audits;
"cited": those of them the record's laws cite, at least one), by axiom set: N (no axiom), P (propext only), Q, C, PQ, PC, QC, PQC (P for
propext, Q for Quot.sound, C for Classical.choice), and total. `{X}` is a count, `{X:en}` and `{X:zh}` its number word.
`<<cond|text>>` keeps text only when cond holds; `<<assert:cond>>` renders nothing and stops when cond fails; cond is
`X` (X > 0), `!X` (X = 0), `X=n` or `X>n`. In each rendering (the earlier counts and the renewed), every axiom set
with a nonzero count must be named: by a `{X}` count in text that renders, by a rendered segment whose condition pins
it (`X=n`) and whose text states n, by an assertion that pins it, or by the entry's "covers" (a phrase such as "the rest none" that accounts for it); a
condition alone does not name it, nor a count inside a segment that does not render. A report naming another axiom
stops. An entry names its module ("module", or the spec's), any module
the record's bindings compare; entries on one field apply in order, each reading the field as first written.

A sentence naming declarations' reports ("`a`, `b`, each with `propext` only; `Quot.sound` enters only `c` and `d`")
takes a reports entry: its `text`, `reports` {declaration: axioms} and `only` {axiom: declarations}, each name in the
text, at least one; it must hold of the earlier receipt (it reads the sentence) and of the renewed one (else it
stops: the sentence needs a template), and it covers the stretch unchanged. out/axiom_texts.json lists under `kept`
every stretch a template or reports entry read and left as it was.

--check (gates.sh): all of the above, no writes; exits 1 on any problem, a malformed entry included (a problem line,
not a traceback, so every record's problems are listed). Otherwise everything is checked first and
the new texts built in memory; then --apply writes the records and chapters and out/axiom_texts.json (every field and
sentence old -> new, the `holds` reasons and the notes); without --apply, a dry run into out/axiom_texts-dry.json.

usage (from the checkout root): axiom_texts.py RUNBASE --check (gates.sh, after the runs)
       axiom_texts.py RUNBASE DATE SECTION [--apply] (land.sh, after repoint_all.py --apply)
"""
import datetime as _dt
import json
from pathlib import Path
import re
import subprocess
import sys

from kit import HERE, OUT, RECEIPTS, RECORDS, REPO, bound_here, load, runs_folder, stem
from swap_stamps import kept_earlier

SPECS = HERE / "AXIOM-SPECS.json"
# An axiom named, or a count of reports stated without naming one.
MENTION = re.compile(r"(?i:propext|Quot\.sound|Classical\.choice|axiom|empty report|declarations audited)|公理|报告为空|"
                     r"项声明")
SKIP = {"history", "references", "proof_bindings", "id", "aliases"}
SHORT = {"propext": "P", "Quot.sound": "Q", "Classical.choice": "C"}
EN = "zero one two three four five six seven eight nine ten eleven twelve".split()
ZH = "零 一 两 三 四 五 六 七 八 九 十".split()
KEYS = ("N", "P", "Q", "C", "PQ", "PC", "QC", "PQC")
COND = re.compile(r"^(!?)([A-Z]+|total)(?:([=>])(\d+))?$")
# <<cond|text>> or <<assert:cond>>; text runs to the first ">>".
SEGMENT = re.compile(r"<<((?:assert:)?!?(?:[A-Z]+|total)(?:[=>]\d+)?)(?:\|((?:(?!>>).)*))?>>")
PLACE = re.compile(r"\{([A-Z]+|total)(?::(en|zh))?\}")
HOME = "#home"


class Problem(Exception):
    pass


def leaves(x, path=""):
    if isinstance(x, dict):
        for k, v in x.items():
            yield from leaves(v, f"{path}/{k}")
    elif isinstance(x, list):
        for i, v in enumerate(x):
            yield from leaves(v, f"{path}/{i}")
    elif isinstance(x, str):
        yield path, x


def get(d, path):
    for part in path.strip("/").split("/"):
        d = d[int(part)] if isinstance(d, list) else d[part]
    return d


def put(d, path, value):
    parts = path.strip("/").split("/")
    for part in parts[:-1]:
        d = d[int(part)] if isinstance(d, list) else d[part]
    last = parts[-1]
    if isinstance(d, list):
        d[int(last)] = value
    else:
        d[last] = value


def counts(reports, decls):
    c = {k: 0 for k in KEYS}
    for d in decls:
        other = set(reports[d]) - set(SHORT)
        if other:
            raise Problem(f"{d} reports {sorted(other)}, outside propext, Quot.sound and Classical.choice")
        key = "".join(sorted({SHORT[a] for a in reports[d]}, key="PQC".index)) or "N"
        c[key] += 1
    c["total"] = len(decls)
    return c


def holds(cond, c):
    m = COND.match(cond)
    if not m or m.group(2) not in c:
        raise Problem(f"a template condition {cond!r}")
    neg, key, op, n = m.groups()
    v = c[key]
    ok = v > 0 if op is None else (v == int(n) if op == "=" else v > int(n))
    return not ok if neg else ok


def states(text, n):
    """Whether a segment's text states the number n: as digits, or as its English or Chinese number word."""
    return bool(re.search(rf"(?<![0-9]){n}(?![0-9])", text)
                or n < len(EN) and re.search(rf"\b{EN[n]}\b", text, re.I) or n < len(ZH) and ZH[n] in text)


def named(template, c):
    """The axiom sets a template names rendered with the counts c: a count `{X}` in text that renders, a rendered
    segment whose condition pins the value (`X=n`) and whose text states it, or an assertion that pins it. A condition
    alone names nothing, nor does a count inside a segment that does not render."""
    keys = set()

    def segment(m):
        cond, text = m.group(1), m.group(2) or ""
        assertion = cond.startswith("assert:")
        mm = COND.match(cond[7:] if assertion else cond)
        if not mm:
            raise Problem(f"a template condition {cond!r}")
        if not mm.group(1) and mm.group(3) == "=" and holds(mm.group(0), c) and states(text, int(mm.group(4))):
            keys.add(mm.group(2))
        return "" if assertion or not holds(cond, c) else text
    keys |= {k for k, _ in PLACE.findall(SEGMENT.sub(segment, template))}
    return keys - {"total"}


def render(template, c):
    def cond(m):
        if m.group(1).startswith("assert:"):
            if not holds(m.group(1)[7:], c):
                raise Problem(f"the assertion {m.group(1)!r} fails on the reports {c}")
            return ""
        return (m.group(2) or "") if holds(m.group(1), c) else ""
    text = SEGMENT.sub(cond, template)
    if "<<" in text or ">>" in text:
        raise Problem(f"a template segment not parsed: {template!r}")

    def number(m):
        if m.group(1) not in c:
            raise Problem(f"an unknown count {m.group(1)!r}")
        v = c[m.group(1)]
        words = None if not m.group(2) else (EN if m.group(2) == "en" else ZH)
        if words is not None and v >= len(words):
            raise Problem(f"no {m.group(2)} number word for {v}")
        return str(v) if words is None else words[v]
    return PLACE.sub(number, text)


def spans(text, stretch):
    """Where `stretch` occurs in text, not inside a longer number."""
    pattern = ("(?<![0-9])" if stretch[:1].isdigit() else "") + re.escape(stretch) + \
        ("(?![0-9])" if stretch[-1:].isdigit() else "")
    return [m.span() for m in re.finditer(pattern, text)]


def stated(e, reports, module):
    """Whether a reports entry holds of a receipt's reports: each named declaration reports exactly the axioms given,
    and each axiom under "only" is reported by exactly the declarations named. Every name must occur in the entry's
    text, so the check is of what the stretch says."""
    def full(name):
        if name not in e["text"]:
            raise Problem(f"{name} is not in the entry's text")
        hit = [k for k in reports if k == name or k.endswith("." + name)]
        if len(hit) != 1:
            raise Problem(f"{name} names {hit or 'no declaration'} in {module}")
        return hit[0]
    for name, axioms in e.get("reports", {}).items():
        if reports[full(name)] != sorted(axioms):
            return False
    for axiom, names in e.get("only", {}).items():
        if axiom not in SHORT:
            raise Problem(f"an unknown axiom {axiom!r}")
        if {k for k, v in reports.items() if axiom in v} != {full(n) for n in names}:
            return False
    return True


def receipt_modules(receipt, rev):
    """{module: {declaration: sorted axioms}} from a renewed receipt at rev (or the working tree)."""
    for pointer in RECEIPTS:
        if bound_here(receipt, pointer, runs_folder(pointer, load(pointer))):
            d = load(pointer, rev)
            return {m["module"]: {k: sorted(v or []) for k, v in m.get("axiom_dependencies", {}).items()}
                    for m in d.get("modules", []) if isinstance(m, dict)}
    # An older-layout receipt, renewed in place: its modules list carries axioms_by_declaration.
    d = (json.loads(subprocess.check_output(["git", "show", f"{rev}:{receipt}"], cwd=REPO)) if rev
         else json.loads((REPO / receipt).read_text()))
    return {m["module"]: {k: sorted(v or []) for k, v in m.get("axioms_by_declaration", {}).items()}
            for m in d.get("modules", []) if isinstance(m, dict)}


def home(rid):
    """The record's home section: (chapter, its text, the level-2 heading above it). A table row holding the anchor
    is that row alone; otherwise the lines after the anchor up to the next anchor, row anchor or heading."""
    tag = f'<a id="r-{rid}"></a>'
    for path in sorted((REPO / "theories/becoming/chapters").glob("0*.md")):
        lines = path.read_text(encoding="utf-8").split("\n")
        at = [i for i, line in enumerate(lines) if tag in line]
        if not at:
            continue
        if len(at) > 1:
            raise Problem(f"two anchors r-{rid} in {path.name}")
        line = lines[at[0]]
        if line.split(tag, 1)[1].strip(" |"):
            text = line
        else:
            end = next((j for j in range(at[0] + 1, len(lines)) if re.match(r"(\| )?<a id=|#", lines[j])), len(lines))
            text = "\n".join(lines[at[0] + 1:end])
        if re.search(r'<a id="r-', text.replace(tag, "")):
            raise Problem(f"the home section of r-{rid} holds another record's anchor")
        # The level-2 heading above it, as research.py's drift names a changed section.
        heading = next(lines[j] for j in range(at[0], -1, -1) if re.match(r"##\s", lines[j]))
        return str(path.relative_to(REPO)), text, heading.lstrip("#").strip()
    return None, "", None


def candidates(rev):
    """{rid: {module: (receipt, old, new)}} for every module compared for the records bound to a renewed receipt,
    and {rid: [errors]} for bindings whose reports could not be read."""
    plan = json.loads((OUT / "receipts.json").read_text())
    status = json.loads((OUT / "status.json").read_text())
    older = json.loads((OUT / "older.json").read_text()) if (OUT / "older.json").exists() else {}
    passed = [pointer for pointer in RECEIPTS if status.get(stem(pointer), {}).get("passed")]
    renewed_older = {r for r, v in older.get("receipts", {}).items() if v["passed"]}
    rids = {rid for pointer, ids in plan["records"].items() if pointer in passed for rid in ids}
    rids |= {rid for r in renewed_older for rid in older["receipts"][r]["records"]}

    def renewed(receipt):
        return receipt in renewed_older or any(
            bound_here(receipt, pointer, runs_folder(pointer, load(pointer))) for pointer in passed)
    bound, errors, cache = {}, {}, {}
    for rid in sorted(rids):
        d = json.loads((REPO / RECORDS / f"{rid}.json").read_text())
        for b in d.get("proof_bindings", []):
            receipt, source = b.get("receipt", ""), Path(b.get("source", "")).stem
            if not receipt or not renewed(receipt):
                continue
            try:
                if receipt not in cache:
                    cache[receipt] = (receipt_modules(receipt, rev), receipt_modules(receipt, None))
                old, new = cache[receipt]
            except (subprocess.CalledProcessError, KeyError, ValueError, OSError) as e:
                errors.setdefault(rid, []).append(f"{receipt}: reports not read ({e})")
                continue
            hit = [m for m in set(old) | set(new) if m == source or m.endswith("." + source)]
            if len(hit) > 1:
                errors.setdefault(rid, []).append(f"{receipt}: {source} names {sorted(hit)}")
                continue
            for m in hit or sorted(set(old) | set(new)):
                bound.setdefault(rid, {})[m] = (receipt, old.get(m), new.get(m))
    return bound, errors


def read_record(rid, d, bound, spec, problems):
    """Check one record against its spec; return its rewrite (or None) and whether it stopped."""
    changed = {m: v for m, v in bound.items() if v[1] != v[2]}
    chapter, para, heading = home(rid)
    fields = {p: s for p, s in leaves({k: v for k, v in d.items() if k not in SKIP}) if MENTION.search(s)}
    if para and MENTION.search(para):
        fields[HOME] = para
    if not fields:
        return None
    start = len(problems)
    for m, (receipt, old, new) in sorted(changed.items()):
        if old is None or new is None or set(old) != set(new):
            problems.append(f"{rid}: {m}'s declarations changed between the receipts")
        elif any(not set(new[k]) <= set(old[k]) for k in new):
            gained = sorted(k for k in new if not set(new[k]) <= set(old[k]))
            problems.append(f"{rid}: {m}: axioms gained in {gained[:5]} (the ruling covers fewer only)")
    if len(problems) > start:
        return None
    if not spec:
        problems.append(f"{rid}: the reports of {sorted(changed)} changed and the record mentions axioms or counts in "
                        f"{sorted(fields)}: write its entry in AXIOM-SPECS.json")
        return None
    cited = sorted({x for law in d.get("laws", []) for x in law.get("declarations", [])})
    texts = dict(fields)
    current, covered = dict(fields), {p: [] for p in fields}
    out = {"modules": {}, "fields": {}, "chapter": [], "holds": [], "kept": []}
    templated = set()
    for e in spec["entries"]:
        where = e.get("path") or HOME
        if where == HOME and e.get("chapter") != chapter:
            problems.append(f"{rid}: an entry names the chapter {e.get('chapter')}, the home section is in {chapter}")
            continue
        if where not in texts:
            try:
                value = para if where == HOME else get(d, where)
            except (KeyError, IndexError, ValueError, TypeError):
                problems.append(f"{rid}: no field {where}")
                continue
            if not isinstance(value, str):
                problems.append(f"{rid}: {where} is not a text")
                continue
            texts[where] = current[where] = value
            covered[where] = []
        original = texts[where]
        if "holds" in e:
            at = spans(original, e.get("text", ""))
            if not e.get("text") or len(at) != 1:
                problems.append(f"{rid} {where}: a holds entry's text must occur once ({e.get('text')!r})")
                continue
            covered[where].append(at[0])
            out["holds"].append({"where": where, "text": e["text"], "reason": e["holds"]})
            continue
        m = e.get("module", spec.get("module"))
        if m not in bound:
            problems.append(f"{rid} {where}: the module {m} is not one the record's bindings compare")
            continue
        receipt, old, new = bound[m]
        if old is None or new is None:
            problems.append(f"{rid} {where}: {m} is missing from one of the receipts")
            continue
        if "reports" in e or "only" in e:
            if not (list(e.get("reports", {})) + [n for v in e.get("only", {}).values() for n in v]):
                problems.append(f"{rid} {where}: a reports entry names no declaration")
                continue
            at = spans(original, e.get("text", ""))
            if not e.get("text") or len(at) != 1:
                problems.append(f"{rid} {where}: a reports entry's text must occur once ({e.get('text')!r})")
                continue
            try:
                ok = [stated(e, old, m), stated(e, new, m)]
            except Problem as err:
                problems.append(f"{rid} {where}: {err}")
                continue
            if not ok[0]:
                problems.append(f"{rid} {where}: the stretch does not state the earlier receipt's reports ({e['text']!r})")
            elif not ok[1]:
                problems.append(f"{rid} {where}: the stretch states reports the renewed receipt changed: write a "
                                f"template ({e['text']!r})")
            else:
                covered[where].append(at[0])
                templated.add(m)
                out["kept"].append({"where": where, "kind": "reports", "text": e["text"]})
                if m in changed:
                    out["modules"][m] = sorted(k for k in new if set(new[k]) < set(old[k]))
            continue
        if e.get("decls") not in ("module", "cited") or not isinstance(e.get("template"), str):
            problems.append(f"{rid} {where}: a template entry needs decls (module or cited) and a template")
            continue
        decls = sorted(old) if e["decls"] == "module" else sorted(set(cited) & set(old))
        if not decls:
            problems.append(f"{rid} {where}: the record cites no declaration of {m}")
            continue
        try:
            co, cn = counts(old, decls), counts(new, decls)
            for c in (co, cn):
                loose = sorted(k for k in KEYS if c[k] and k not in named(e["template"], c) | set(e.get("covers", [])))
                if loose:
                    raise Problem(f"axiom sets not named: {loose} (reports {c})")
            before, after = render(e["template"], co), render(e["template"], cn)
        except (Problem, KeyError) as err:
            problems.append(f"{rid} {where}: {err}")
            continue
        at = spans(original, before)
        if len(at) != 1:
            problems.append(f"{rid} {where}: the template does not read the sentence once (rendered: {before!r})")
            continue
        covered[where].append(at[0])
        templated.add(m)
        if m in changed:
            out["modules"][m] = sorted(k for k in new if set(new[k]) < set(old[k]))
        if before == after:
            out["kept"].append({"where": where, "kind": "template", "text": before})
            continue
        if where == HOME and len(spans((REPO / chapter).read_text(encoding="utf-8"), before)) != 1:
            problems.append(f"{rid}: the home sentence occurs more than once in {chapter}")
            continue
        now = spans(current[where], before)
        if len(now) != 1:
            problems.append(f"{rid} {where}: an earlier entry on this field overlaps this one")
            continue
        a, b = now[0]
        current[where] = current[where][:a] + after + current[where][b:]
        if where == HOME:
            out["chapter"].append({"file": chapter, "heading": heading, "old": before, "new": after})
    for m in sorted(set(changed) - templated):
        problems.append(f"{rid}: {m}'s reports changed and no template entry reads a sentence on it")
    for where, text in fields.items():
        for mm in MENTION.finditer(text):
            if not any(a <= mm.start() and mm.end() <= b for a, b in covered[where]):
                problems.append(f"{rid} {where}: “…{text[max(0, mm.start() - 50):mm.end() + 30]}…” lies in no entry")
                break
    if len(problems) > start:
        return None
    out["fields"] = {p: [texts[p], current[p]] for p in current if p != HOME and current[p] != texts[p]}
    if not (out["fields"] or out["chapter"]):
        return None
    # The swaps must then name the renewed run wherever the record names a run of these receipts.
    text = json.dumps(d.get("validation_scope"), ensure_ascii=False)
    out["receipts"] = sorted({changed[m][0] for m in changed})
    for receipt in out["receipts"]:
        why = kept_earlier(rid, text, receipt, True)
        if why:
            problems.append(f"{rid}: its axiom sentences would be rewritten from {receipt}, but the swaps would leave "
                            f"it naming an earlier run ({why}): route to the coordinator")
            return None
    return out


def main():
    check, apply = "--check" in sys.argv, "--apply" in sys.argv
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if check:
        assert len(args) == 1, __doc__
        rev, date, section = args[0], "2026-01-01", 0
    else:
        assert len(args) == 3, __doc__
        rev, date, section = args[0], args[1], int(args[2])
    day = _dt.date.fromisoformat(date)
    specs = json.loads(SPECS.read_text()) if SPECS.exists() else {}
    bound, errors = candidates(rev)
    problems = [f"{rid}: {e}" for rid, es in sorted(errors.items()) for e in es]
    result = {}
    for rid, modules in sorted(bound.items()):
        if all(v[1] == v[2] for v in modules.values()):
            continue
        d = json.loads((REPO / RECORDS / f"{rid}.json").read_text())
        try:
            out = read_record(rid, d, modules, specs.get(rid), problems)
        except (Problem, KeyError, TypeError, IndexError, ValueError, AttributeError) as err:
            problems.append(f"{rid}: {type(err).__name__} {err}")
            continue
        if out:
            spec = specs[rid]
            out["note"] = {"en": f"{day.day} {day:%B} {day.year}, RV21c (study section {section}): {spec['note']['en']}",
                           "zh": f"{day.year}年{day.month}月{day.day}日，RV21c（研究第 {section} 节）：{spec['note']['zh']}"}
            result[rid] = out
    records, chapters = build(result, problems)
    unused = sorted(r for r in specs if not r.startswith("_") and r not in result)
    for rid, v in sorted(result.items()):
        fewer = "; ".join(f"{m}: {len(x)} declaration" + ("s report" if len(x) != 1 else " reports") + " fewer axioms"
                          for m, x in v["modules"].items())
        print(f"{rid} ({fewer}):")
        for p, (a, b) in v["fields"].items():
            print(f"  {p}: {diff(a, b)}")
        for c in v["chapter"]:
            print(f"  {c['file']} ({c['heading']}): {c['old']!r} -> {c['new']!r}")
        for h in v["holds"]:
            print(f"  {h['where']} holds {h['text']!r}: {h['reason']}")
    print(f"records rewritten: {len(result)}; specs not used this run: {unused or 'none'}; problems: {len(problems)}")
    for p in problems:
        print("  " + p)
    if problems:
        sys.exit(1)
    if check:
        return
    if apply:
        for rid, text in records.items():
            (REPO / RECORDS / f"{rid}.json").write_text(text)
        for f, text in chapters.items():
            (REPO / f).write_text(text, encoding="utf-8")
    (OUT / ("axiom_texts.json" if apply else "axiom_texts-dry.json")).write_text(
        json.dumps(result, indent=1, ensure_ascii=False) + "\n")


def build(result, problems):
    """Every new record and chapter text, in memory, so nothing is written unless all of it applies."""
    records, chapters = {}, {}
    for rid, v in sorted(result.items()):
        d = json.loads((REPO / RECORDS / f"{rid}.json").read_text())
        for p, (a, b) in v["fields"].items():
            if get(d, p) != a:
                problems.append(f"{rid} {p}: the field changed under the run")
                continue
            put(d, p, b)
        d["history"].append(v["note"])
        records[rid] = json.dumps(d, ensure_ascii=False, indent=2) + "\n"
        for c in v["chapter"]:
            t = chapters.get(c["file"]) or (REPO / c["file"]).read_text(encoding="utf-8")
            at = spans(t, c["old"])
            if len(at) != 1:
                problems.append(f"{rid}: {c['file']} does not hold its home sentence once when applied")
                continue
            chapters[c["file"]] = t[:at[0][0]] + c["new"] + t[at[0][1]:]
    return records, chapters


def diff(a, b):
    """The changed stretch of a field, with a little context."""
    i = 0
    while i < min(len(a), len(b)) and a[i] == b[i]:
        i += 1
    j = 0
    while j < min(len(a), len(b)) - i and a[-1 - j] == b[-1 - j]:
        j += 1
    lo = max(0, i - 30)
    return f"{a[lo:len(a) - j]!r} -> {b[lo:len(b) - j]!r}"


if __name__ == "__main__":
    main()
