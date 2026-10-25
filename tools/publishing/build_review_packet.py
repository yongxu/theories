"""Build the reader edition of the review packet (theories/becoming/review/): one PDF per part.

The dossiers carry machine-checkable markup for check_dossiers.py: Quote [path]: "…", Source [ID]: "…",
引〔path〕：「…」 and 原文〔ID〕：「…」. A reader needs none of it. This builder turns each marker into a plain
citation ("…" (ch. 7); 「…」（第七章）), turns links into repository files (which a reader cannot follow) into
plain text, keeps the links between items of one dossier, and prints each part with headless Google Chrome,
as the other builders here do. The sources are not changed. Drafts go to tmp/ (untracked); with --release, to
output/pdf/review-packet/ for the frozen version that is sent.
Run from the repo root:  python3 tools/publishing/build_review_packet.py [--release] [PART ...]
"""
import html
import pathlib
import re
import subprocess
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from build_xiaokang_datong import fix_tounicode  # noqa: E402  (normalizes CJK radicals in ToUnicode maps)

ROOT = pathlib.Path(__file__).resolve().parents[2]
SRC = ROOT / "theories" / "becoming" / "review"
RELEASE = ROOT / "output" / "pdf" / "review-packet"  # with --release, for the frozen version that is sent
DRAFT = ROOT / "tmp" / "pdfs" / "review-packet-pdf"  # otherwise drafts, never tracked
BUILD = ROOT / "tmp" / "pdfs" / "review-packet"
CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

PARTS = {
    "README.md": ("en", "Review packet"),
    "README.zh.md": ("zh", "审查包"),
    "CLASSICAL-TEXTS.md": ("zh", "审查材料 · 古文"),
    "BUDDHIST-THOUGHT.md": ("zh", "审查材料 · 佛学"),
    "LOGIC.md": ("en", "Review dossier · Logic"),
    "PHILOSOPHY.md": ("en", "Review dossier · Philosophy"),
    "ALIGNMENT.md": ("en", "Review dossier · Alignment"),
}

ZH_NUM = "〇一二三四五六七八九"


def label(path: str, lang: str) -> str:
    """A reader's name for a repository file a dossier quotes."""
    p = path.split("#")[0].strip()
    name = p.rsplit("/", 1)[-1]
    m = re.match(r"0(\d)-", name)
    if "/chapters/" in p and m:
        n = int(m.group(1))
        return f"第{ZH_NUM[n]}章" if lang == "zh" else f"ch. {n}"
    table = [
        ("ONE-PAGE", "一页概要", "the one page"),
        ("THE-THEORY-OF-BECOMING", "总览", "the overview"),
        ("THE-STEP-OF-INVARIANCE", "不变性之步的研究", "the study of the step"),
        ("GLOSSARY", "术语表", "the glossary"),
        ("DEFECTS-FOUND", "缺陷清单", "the defect list"),
        ("DECISIONS-ROUND-2", "审查记录", "a review record"),
        ("sources-against", "文法对其来源的审查", "the review of the grammar against its sources"),
        ("NOTE", "研究笔记", "a study note"),
        ("CODEBOOK", "编码手册", "the codebook"),
    ]
    for key, zh, en in table:
        if key in name or key in p:
            return zh if lang == "zh" else en
    if "/results/records/" in p:
        return "结果记录" if lang == "zh" else "a result record"
    if p.startswith("_process/"):
        return "研究记录" if lang == "zh" else "a study record"
    return name.rsplit(".", 1)[0]


def plain_citations(text: str, lang: str) -> str:
    text = re.sub(r'Quote\s*\[([^\]]+)\]\s*:\s*"([^"]+)"', lambda m: f'"{m.group(2)}" ({label(m.group(1), lang)})', text)
    text = re.sub(r'Source\s*\[([^\]]+)\]\s*:\s*"([^"]+)"', lambda m: f'"{m.group(2)}" ({m.group(1).strip()})', text)
    text = re.sub(r'引\s*〔([^〕]+)〕\s*[：:]\s*「([^」]+)」', lambda m: f'「{m.group(2)}」（{label(m.group(1), lang)}）', text)
    text = re.sub(r'原文\s*〔([^〕]+)〕\s*[：:]\s*「([^」]+)」', lambda m: f'「{m.group(2)}」（{m.group(1).strip()}）', text)
    return text


def inline(text: str) -> str:
    codes = []

    def keep(m):
        codes.append(m.group(1))
        return f"\x00{len(codes) - 1}\x00"

    t = re.sub(r"`([^`]+)`", keep, text)
    t = html.escape(t, quote=False)
    # links: in-document anchors stay links; links into the repository become their text
    t = re.sub(r"\[([^\]]+)\]\((#[^)]+)\)", r'<a href="\2">\1</a>', t)
    t = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", r"\1", t)
    t = re.sub(r"\[([^\]]+)\]\[[^\]]*\]", r"\1", t)
    t = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", t)
    t = re.sub(r"(?<![\w*])\*(?!\s)(.+?)(?<!\s)\*(?![\w*])", r"<em>\1</em>", t)
    return re.sub(r"\x00(\d+)\x00", lambda m: f"<code>{html.escape(codes[int(m.group(1))])}</code>", t)


def convert(md: str) -> str:
    lines = md.split("\n")
    out, para, i = [], [], 0
    pending_id = None

    def flush():
        nonlocal para
        if para:
            out.append(f"<p>{inline(' '.join(para).strip())}</p>")
            para = []

    def heading(level, text):
        nonlocal pending_id
        ident = f' id="{pending_id}"' if pending_id else ""
        pending_id = None
        out.append(f"<h{level}{ident}>{inline(text)}</h{level}>")

    def lst(start):
        """A list, ordered or not, with items nested by two-space indents."""
        nonlocal i
        html_out, stack = [], []
        while i < len(lines):
            l = lines[i]
            m = re.match(r"^(\s*)(- |\d+\. )(.*)$", l)
            if not m:
                if l.strip() and l.startswith("  ") and html_out:
                    html_out[-1] = html_out[-1][:-5] + " " + inline(l.strip()) + "</li>"
                    i += 1
                    continue
                break
            depth = len(m.group(1)) // 2
            tag = "ol" if m.group(2)[0].isdigit() else "ul"
            while len(stack) > depth + 1:
                html_out.append(f"</{stack.pop()}>")
            if len(stack) < depth + 1:
                stack.append(tag)
                html_out.append(f"<{tag}>")
            html_out.append(f"<li>{inline(m.group(3))}</li>")
            i += 1
        while stack:
            html_out.append(f"</{stack.pop()}>")
        out.append("".join(html_out))

    while i < len(lines):
        l = lines[i]
        if re.match(r"^\[[^\]]+\]:\s", l):
            i += 1
            continue
        m = re.fullmatch(r'\s*<a id="([^"]+)"></a>\s*', l)
        if m:
            flush()
            pending_id = m.group(1)
        elif l.startswith("```"):
            flush()
            i += 1
            code = []
            while i < len(lines) and not lines[i].startswith("```"):
                code.append(lines[i])
                i += 1
            out.append("<pre><code>" + html.escape("\n".join(code)) + "</code></pre>")
        elif l.startswith("#"):
            flush()
            level = len(l) - len(l.lstrip("#"))
            heading(min(level, 4), l[level:].strip())
        elif l.strip() == "---":
            flush()
            out.append("<hr/>")
        elif re.match(r"^(- |\d+\. )", l):
            flush()
            lst(i)
            continue
        elif l.startswith("|"):
            flush()
            rows = []
            while i < len(lines) and lines[i].startswith("|"):
                rows.append([c.strip() for c in lines[i].strip().strip("|").split("|")])
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
    return "\n".join(out)


CSS = """
@page { size: A4; margin: 20mm 18mm 20mm 18mm;
  @bottom-center { content: counter(page); font-family: var(--sans); font-size: 8pt; color: #8a8378; } }
:root { --ink: #1f1c18; --muted: #6e675d; --rule: #c9bfae; --accent: #8c2f1e; }
html { color: var(--ink); background: #fff; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
body { margin: 0; font-family: var(--serif); font-size: %(size)s; line-height: %(lh)s; }
h1, h2, h3, h4 { font-family: var(--sans); }
h1 { font-size: 20pt; line-height: 1.25; font-weight: 600; margin: 0 0 6mm; }
h2 { font-size: 14pt; font-weight: 600; margin: 9mm 0 3mm; padding-bottom: 2mm; border-bottom: .6px solid var(--rule); page-break-after: avoid; }
h3 { font-size: 11.5pt; font-weight: 600; margin: 7mm 0 2mm; color: #3b342c; page-break-after: avoid; }
h4 { font-size: 11pt; font-weight: 600; margin: 6mm 0 2mm; color: #3b342c; page-break-after: avoid; }
p { margin: 0 0 2.6mm; orphans: 2; widows: 2; }
strong { font-weight: 600; }
a { color: var(--accent); text-decoration: none; }
ul, ol { margin: 0 0 3mm; padding-left: 6mm; }
li { margin: 0 0 1.2mm; }
code { font-family: Menlo, "PingFang SC", monospace; font-size: .86em; background: #f4f0e8; padding: 0 .5mm; }
pre { background: #f7f3ea; border-left: 2px solid var(--rule); padding: 2.5mm 3mm; font-size: 8.2pt; line-height: 1.45; white-space: pre-wrap; page-break-inside: avoid; }
pre code { background: none; padding: 0; font-size: inherit; }
table { width: 100%%; border-collapse: collapse; margin: 3mm 0 5mm; font-size: .9em; }
th, td { text-align: left; vertical-align: top; padding: 1.6mm 2mm; border-bottom: .5px solid #d9d0c0; }
th { font-family: var(--sans); font-weight: 600; color: var(--muted); border-bottom: .8px solid var(--rule); }
hr { border: none; border-top: .6px solid var(--rule); margin: 7mm 0; }
"""

FONTS = {
    "zh": {"serif": '"Songti SC", "STSong", serif', "sans": '"PingFang SC", "Hiragino Sans GB", sans-serif',
           "size": "10.5pt", "lh": "1.85"},
    "en": {"serif": '"Iowan Old Style", "Charter", Georgia, "Songti SC", serif',
           "sans": '"Avenir Next", "Helvetica Neue", "PingFang SC", sans-serif', "size": "10.4pt", "lh": "1.55"},
}


def build(part: str, out_dir: pathlib.Path = DRAFT) -> pathlib.Path:
    lang, title = PARTS[part]
    f = FONTS[lang]
    md = plain_citations((SRC / part).read_text(encoding="utf-8"), lang)
    css = f":root {{ --serif: {f['serif']}; --sans: {f['sans']}; }}\n" + CSS % f
    doc = (f'<!doctype html><html lang="{"zh-Hans" if lang == "zh" else "en"}"><head><meta charset="utf-8">'
           f"<title>{html.escape(title)}</title><style>{css}</style></head><body><main>{convert(md)}</main></body></html>")
    BUILD.mkdir(parents=True, exist_ok=True)
    page = BUILD / (part.rsplit(".md", 1)[0] + ".html")
    page.write_text(doc, encoding="utf-8")
    out_dir.mkdir(parents=True, exist_ok=True)
    pdf = out_dir / (part.rsplit(".md", 1)[0] + ".pdf")
    subprocess.run([CHROME, "--headless=new", "--disable-gpu", "--no-pdf-header-footer",
                    "--run-all-compositor-stages-before-draw", "--virtual-time-budget=5000",
                    f"--print-to-pdf={pdf}", page.as_uri()],
                   check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    fixed = fix_tounicode(pdf)
    print("wrote", pdf.relative_to(ROOT), f"({fixed} glyph mappings normalized)")
    return pdf


if __name__ == "__main__":
    args = sys.argv[1:]
    release = "--release" in args
    for part in [a for a in args if a != "--release"] or PARTS:
        build(part, RELEASE if release else DRAFT)
