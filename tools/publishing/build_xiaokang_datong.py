"""Build the Chinese and English PDFs of 《从小康到大同》 v0.3.

Source markdown lives in drafts/2026-09-26-community-mission/; output goes to output/pdf/.
Rendering: a small markdown-to-HTML converter, then headless Google Chrome print-to-PDF.
Run from the repo root:  python3 tmp/pdfs/build_xiaokang_datong.py
"""
import html
import pathlib
import re
import subprocess
import unicodedata

from pypdf import PdfWriter

ROOT = pathlib.Path(__file__).resolve().parents[2]
SRC = ROOT / "drafts" / "2026-09-26-community-mission"
OUT = ROOT / "output" / "pdf"
BUILD = ROOT / "tmp" / "pdfs" / "xiaokang-datong"
CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

EDITIONS = {
    "zh": {
        "src": SRC / "立场与使命-v0.3.md",
        "out": OUT / "从小康到大同-v0.3-zh.pdf",
        "lang": "zh-Hans",
        "title": "从小康到大同",
        "subtitle": "中华文明面对智能时代的态度与立场",
        "edition": "讨论稿 v0.3 · 2026 年 9 月",
        "motto": "天下生生，万物并育；智能向善，共赴大同。",
        "motto2": "",
        "contents": "目录",
        "running": "从小康到大同 · 讨论稿 v0.3",
        "ref_heads": {"引文出处", "References", "参考文献"},
    },
    "en": {
        "src": SRC / "From-Xiaokang-to-Datong-v0.3-en.md",
        "out": OUT / "From-Xiaokang-to-Datong-v0.3-en.pdf",
        "lang": "en",
        "title": "From Xiaokang to Datong",
        "subtitle": "The Outlook and Position of Chinese Civilization in the Age of Intelligence",
        "edition": "Discussion Draft v0.3 · September 2026",
        "motto": "May all under heaven go on generating, and the myriad things be nourished together; may intelligence turn toward the good, and all of us journey together toward Datong.",
        "motto2": "天下生生，万物并育；智能向善，共赴大同。",
        "contents": "Contents",
        "running": "From Xiaokang to Datong · Discussion Draft v0.3",
        "ref_heads": {"Classical and historical sources", "References"},
    },
}


def inline(text: str) -> str:
    t = html.escape(text, quote=False)
    t = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", r'<a href="\2">\1</a>', t)
    t = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", t)
    t = re.sub(r"(?<![\w*])\*(?!\s)(.+?)(?<!\s)\*(?![\w*])", r"<em>\1</em>", t)
    return t


def convert(md: str, ref_heads: set) -> tuple[str, list]:
    lines = md.split("\n")
    # drop the document title and the byline; the cover carries them
    body = [l for l in lines if not l.startswith("# ")]
    body = [l for l in body if not re.match(r"^[A-Z][a-z]{2} \d{1,2}, \d{4} · @", l)]
    out, toc = [], []
    i, refs, n = 0, False, 0
    para: list[str] = []

    def flush():
        nonlocal para, refs
        if not para:
            return
        text = " ".join(para).strip()
        para = []
        m = re.fullmatch(r"\*\*(.+?)\*\*", text)
        if m and m.group(1) in ref_heads:
            refs = True
            out.append(f'<h4 class="refhead">{inline(m.group(1))}</h4>')
            return
        if re.fullmatch(r"\*[^*].*\*", text):
            out.append(f'<p class="note">{inline(text[1:-1])}</p>')
            return
        m = re.fullmatch(r"\*\*(.+?)\*\*", text)
        if m:
            out.append(f'<p class="motto">{inline(m.group(1))}</p>')
            return
        out.append(f"<p>{inline(text)}</p>")

    while i < len(body):
        l = body[i]
        if l.startswith("## "):
            flush()
            n += 1
            title = l[3:].strip()
            toc.append((f"s{n}", title))
            out.append(f'<h2 id="s{n}">{inline(title)}</h2>')
        elif l.startswith("### "):
            flush()
            out.append(f"<h3>{inline(l[4:].strip())}</h3>")
        elif l.strip() == "---":
            flush()
            out.append('<hr class="end"/>')
        elif l.startswith("- "):
            flush()
            items = []
            while i < len(body) and body[i].startswith("- "):
                items.append(body[i][2:])
                i += 1
            cls = ' class="refs"' if refs else ""
            out.append(f"<ul{cls}>" + "".join(f"<li>{inline(x)}</li>" for x in items) + "</ul>")
            continue
        elif l.startswith("| "):
            flush()
            rows = []
            while i < len(body) and body[i].startswith("|"):
                rows.append([c.strip() for c in body[i].strip().strip("|").split("|")])
                i += 1
            head, rest = rows[0], [r for r in rows[1:] if not set("".join(r)) <= set("-: ")]
            t = "<table><thead><tr>" + "".join(f"<th>{inline(c)}</th>" for c in head) + "</tr></thead><tbody>"
            t += "".join("<tr>" + "".join(f"<td>{inline(c)}</td>" for c in r) + "</tr>" for r in rest)
            out.append(t + "</tbody></table>")
            continue
        elif not l.strip():
            flush()
        else:
            para.append(l.strip())
        i += 1
    flush()
    return "\n".join(out), toc


CSS = """
@page { size: A4; margin: 24mm 22mm 22mm 22mm;
  @top-center { content: "%(running)s"; font-family: var(--sans); font-size: 7.5pt; color: #8a8378; letter-spacing: .06em; }
  @bottom-center { content: counter(page); font-family: var(--sans); font-size: 8pt; color: #8a8378; } }
@page :first { margin: 0; @top-center { content: none; } @bottom-center { content: none; } }
:root { --ink: #1f1c18; --muted: #6e675d; --rule: #c9bfae; --accent: #8c2f1e; }
html { color: var(--ink); background: #fff; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
body { margin: 0; font-family: var(--serif); font-size: %(size)s; line-height: %(lh)s; text-align: justify; hyphens: auto; }
.cover { text-align: left; hyphens: none; height: 297mm; box-sizing: border-box; padding: 58mm 26mm 30mm 26mm; display: flex; flex-direction: column; page-break-after: always; background: #f7f3ea; }
.cover .edition { font-family: var(--sans); font-size: 9pt; letter-spacing: .12em; color: var(--muted); }
.cover h1 { font-size: %(h1)s; line-height: 1.15; margin: 14mm 0 6mm; font-weight: 600; color: var(--ink); letter-spacing: %(h1ls)s; }
.cover .subtitle { font-size: 15pt; line-height: 1.5; color: var(--muted); max-width: 140mm; }
.cover .bar { width: 22mm; height: 2px; background: var(--accent); margin: 16mm 0 0; }
.cover .motto { margin-top: auto; font-size: 11pt; line-height: 1.8; color: var(--ink); max-width: 130mm; text-align: left; }
.cover .motto2 { font-size: 10.5pt; color: var(--muted); margin-top: 3mm; }
.toc { page-break-after: always; }
.toc h2 { border: none; margin-top: 0; }
.toc ol { list-style: none; padding: 0; margin: 0; }
.toc li { padding: 1.7mm 0; border-bottom: .5px solid #e4ddcf; font-size: 10.5pt; text-align: left; }
.toc a { color: var(--ink); text-decoration: none; }
h2 { font-size: 15pt; line-height: 1.4; font-weight: 600; margin: 12mm 0 5mm; padding-bottom: 2.5mm; border-bottom: .6px solid var(--rule); page-break-after: avoid; text-align: left; }
h3 { font-size: 12pt; font-weight: 600; margin: 7mm 0 2.5mm; color: #3b342c; page-break-after: avoid; text-align: left; }
p { margin: 0 0 3.2mm; orphans: 2; widows: 2; }
strong { font-weight: 600; }
a { color: var(--accent); text-decoration: none; }
ul { margin: 0 0 3.5mm; padding-left: 6mm; }
li { margin: 0 0 1.6mm; }
table { width: 100%%; border-collapse: collapse; margin: 3mm 0 5mm; font-size: .92em; page-break-inside: avoid; }
th, td { text-align: left; vertical-align: top; padding: 2mm 2.5mm; border-bottom: .5px solid #d9d0c0; }
th { font-family: var(--sans); font-weight: 600; font-size: .9em; color: var(--muted); border-bottom: .8px solid var(--rule); }
td:first-child { white-space: nowrap; font-weight: 600; width: %(firstcol)s; }
p.motto { text-align: center; font-size: 1.12em; margin: 8mm 0; color: var(--accent); }
hr.end { border: none; border-top: .6px solid var(--rule); margin: 10mm 0 6mm; }
h4.refhead { font-family: var(--sans); font-size: 9.5pt; letter-spacing: .08em; color: var(--muted); margin: 6mm 0 3mm; font-weight: 600; text-align: left; }
ul.refs { list-style: none; padding-left: 0; font-size: .82em; line-height: 1.55; text-align: left; }
ul.refs li { padding-left: 5mm; text-indent: -5mm; margin-bottom: 1.4mm; }
p.note { font-size: .82em; color: var(--muted); margin-top: 8mm; font-style: italic; text-align: left; }
:lang(zh-Hans) p.note { font-style: normal; }
"""

FONTS = {
    "zh": {"serif": '"Songti SC", "STSong", serif', "sans": '"PingFang SC", "Hiragino Sans GB", sans-serif',
           "size": "11pt", "lh": "1.9", "h1": "34pt", "h1ls": ".04em", "firstcol": "14mm"},
    "en": {"serif": '"Iowan Old Style", "Charter", Georgia, "Songti SC", serif',
           "sans": '"Avenir Next", "Helvetica Neue", "PingFang SC", sans-serif',
           "size": "10.8pt", "lh": "1.58", "h1": "32pt", "h1ls": "0", "firstcol": "30mm"},
}


# The radicals supplement has no compatibility decomposition, so NFKC keeps these whole characters as radicals.
_WHOLE_CHARACTERS = {
    0x2EA0: 0x6C11, 0x2EC4: 0x897F, 0x2EC5: 0x89C1, 0x2EC6: 0x89D2, 0x2EC9: 0x8D1D, 0x2ECB: 0x8F66, 0x2ED1: 0x9577,
    0x2ED3: 0x957F, 0x2ED4: 0x95E8, 0x2ED7: 0x96E8, 0x2ED8: 0x9752, 0x2ED9: 0x97E6, 0x2EDA: 0x9875, 0x2EDB: 0x98CE,
    0x2EDC: 0x98DE, 0x2EDD: 0x98DF, 0x2EE2: 0x9A6C, 0x2EE3: 0x9AA8, 0x2EE4: 0x9B3C, 0x2EE5: 0x9C7C, 0x2EE6: 0x9E1F,
    0x2EE7: 0x5364, 0x2EE8: 0x9EA6, 0x2EE9: 0x9EC4, 0x2EEB: 0x6589, 0x2EEC: 0x9F50, 0x2EED: 0x6B6F, 0x2EEE: 0x9F7F,
    0x2EEF: 0x7ADC, 0x2EF0: 0x9F99, 0x2EF1: 0x9F9C, 0x2EF2: 0x4E80,
}


def _normalize(s: str) -> str:
    """Map Kangxi/CJK radicals and compatibility ideographs back to unified ideographs.

    macOS CJK fonts share one glyph between e.g. 小 and the radical ⼩; Chrome's ToUnicode
    CMap sometimes names the radical, so copied text reads ⼩康. Only those ranges change.
    """
    out = []
    for ch in s:
        cp = ord(ch)
        if 0x2E80 <= cp <= 0x2FDF or 0xF900 <= cp <= 0xFAFF:
            ch = unicodedata.normalize("NFKC", ch).translate(_WHOLE_CHARACTERS)
        out.append(ch)
    return "".join(out)


def _rewrite_cmap(data: str) -> tuple[str, int]:
    mapping: dict[str, str] = {}
    width = 2
    for block in re.findall(r"beginbfchar(.*?)endbfchar", data, re.S):
        for src, dst in re.findall(r"<([0-9A-Fa-f]+)>\s*<([0-9A-Fa-f]*)>", block):
            width = len(src)
            mapping[src.upper()] = bytes.fromhex(dst).decode("utf-16-be") if dst else ""
    for block in re.findall(r"beginbfrange(.*?)endbfrange", data, re.S):
        for lo, hi, rest in re.findall(r"<([0-9A-Fa-f]+)>\s*<([0-9A-Fa-f]+)>\s*(\[[^\]]*\]|<[0-9A-Fa-f]+>)", block):
            width = len(lo)
            a, b = int(lo, 16), int(hi, 16)
            if rest.startswith("["):
                dsts = re.findall(r"<([0-9A-Fa-f]+)>", rest)
                for k, d in zip(range(a, b + 1), dsts):
                    mapping[f"{k:0{width}X}"] = bytes.fromhex(d).decode("utf-16-be")
            else:
                base = bytes.fromhex(rest[1:-1]).decode("utf-16-be")
                for k in range(a, b + 1):
                    mapping[f"{k:0{width}X}"] = base[:-1] + chr(ord(base[-1]) + (k - a))
    changed = sum(1 for v in mapping.values() if _normalize(v) != v)
    if not changed:
        return data, 0
    items = sorted(mapping.items())
    blocks = []
    for i in range(0, len(items), 100):
        chunk = items[i:i + 100]
        lines = "\n".join(f"<{k}> <{_normalize(v).encode('utf-16-be').hex().upper()}>" for k, v in chunk)
        blocks.append(f"{len(chunk)} beginbfchar\n{lines}\nendbfchar")
    head = data[:data.find("endcodespacerange") + len("endcodespacerange")]
    tail = data[data.find("endcmap"):]
    return head + "\n" + "\n".join(blocks) + "\n" + tail, changed


def fix_tounicode(path: pathlib.Path) -> int:
    writer = PdfWriter(clone_from=str(path))
    seen, total = set(), 0
    for page in writer.pages:
        fonts = page.get("/Resources", {}).get("/Font", {})
        for ref in fonts.values():
            font = ref.get_object()
            tu = font.get("/ToUnicode")
            if tu is None:
                continue
            stream = tu.get_object()
            if id(stream) in seen:
                continue
            seen.add(id(stream))
            data, n = _rewrite_cmap(stream.get_data().decode("latin-1"))
            if n:
                stream.set_data(data.encode("latin-1"))
                total += n
    with open(path, "wb") as fh:
        writer.write(fh)
    return total


def build(key: str) -> None:
    e = EDITIONS[key]
    f = FONTS[key]
    body, toc = convert(e["src"].read_text(encoding="utf-8"), e["ref_heads"])
    css = CSS % {"running": e["running"], **f}
    css = f":root {{ --serif: {f['serif']}; --sans: {f['sans']}; }}\n" + css
    toc_html = "".join(f'<li><a href="#{a}">{inline(t)}</a></li>' for a, t in toc)
    motto2 = f'<div class="motto2">{e["motto2"]}</div>' if e["motto2"] else ""
    doc = f"""<!doctype html><html lang="{e['lang']}"><head><meta charset="utf-8">
<title>{e['title']} — {e['subtitle']}</title><style>{css}</style></head><body>
<section class="cover"><div class="edition">{e['edition']}</div><h1>{e['title']}</h1>
<div class="subtitle">{e['subtitle']}</div><div class="bar"></div>
<div class="motto">{e['motto']}{motto2}</div></section>
<section class="toc"><h2>{e['contents']}</h2><ol>{toc_html}</ol></section>
<main>{body}</main></body></html>"""
    BUILD.mkdir(parents=True, exist_ok=True)
    page = BUILD / f"{key}.html"
    page.write_text(doc, encoding="utf-8")
    OUT.mkdir(parents=True, exist_ok=True)
    subprocess.run([CHROME, "--headless=new", "--disable-gpu", "--no-pdf-header-footer",
                    "--run-all-compositor-stages-before-draw", "--virtual-time-budget=5000",
                    f"--print-to-pdf={e['out']}", page.as_uri()],
                   check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    fixed = fix_tounicode(e["out"])
    print("wrote", e["out"], f"({fixed} glyph mappings normalized)")


if __name__ == "__main__":
    for k in EDITIONS:
        build(k)
