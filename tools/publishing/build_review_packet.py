"""Build the reader edition of the review packet (theories/becoming/review/): one PDF per part.

The dossiers carry machine-checkable markup for check_dossiers.py: Quote [path]: "…", Source [ID]: "…",
引〔path〕：「…」 and 原文〔ID〕：「…」. A reader needs none of it. This builder turns each marker into a plain
citation ("…" (ch. 7); 「…」（第七章）), turns links into repository files (which a reader cannot follow) into
plain text, drops navigation lines made only of such links, keeps the links between items of one dossier, and
prints each part with headless Google Chrome, as the other builders here do. Each part names the commit it was
built from, under its title and at the foot of every page. The sources are not changed.

Drafts go to tmp/ (untracked). --release is for the frozen version that is sent: it refuses a dirty tree, a failing
dossier check or a defect in the built PDFs, and writes the whole edition, the re-coding sheet and a MANIFEST of
sha256 sums to output/pdf/review-packet/. The steps of a freeze are in the kit's FREEZE-STEPS.md.
Run from the repo root:  python3 tools/publishing/build_review_packet.py [--release] [PART ...]
"""
import hashlib
import html
import pathlib
import re
import shutil
import subprocess
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from build_xiaokang_datong import fix_tounicode  # noqa: E402  (normalizes CJK radicals in ToUnicode maps)
from pypdf import PdfReader  # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parents[2]
SRC = ROOT / "theories" / "becoming" / "review"
RELEASE = ROOT / "output" / "pdf" / "review-packet"  # with --release, for the frozen version that is sent
DRAFT = ROOT / "tmp" / "pdfs" / "review-packet-pdf"  # otherwise drafts, never tracked
BUILD = ROOT / "tmp" / "pdfs" / "review-packet"
CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
CHECKER = (ROOT / "_process/research/2026-10-05-generative-foundation-review/root-foundation/development"
           / "review-packet/check_dossiers.py")
SHEETS = [SRC / "recoding" / "SHEET.xlsx", SRC / "recoding" / "SHEET.tsv"]  # the codebook offers both

# Paths relative to SRC. The cover tells a reader to read the one page and the overview, and a coder the codebook.
PARTS = {
    "README.md": ("en", "Review packet"),
    "README.zh.md": ("zh", "审查包"),
    "CLASSICAL-TEXTS.md": ("zh", "审查材料 · 古文"),
    "BUDDHIST-THOUGHT.md": ("zh", "审查材料 · 佛学"),
    "LOGIC.md": ("en", "Review dossier · Logic"),
    "PHILOSOPHY.md": ("en", "Review dossier · Philosophy"),
    "ALIGNMENT.md": ("en", "Review dossier · Alignment"),
    "../ONE-PAGE.md": ("en", "The Theory of Becoming in one page"),
    "../ONE-PAGE.zh.md": ("zh", "生成变化之论：一页"),
    "../THE-THEORY-OF-BECOMING.md": ("en", "The Theory of Becoming"),
    "../THE-THEORY-OF-BECOMING.zh.md": ("zh", "生成变化之论"),
    "recoding/CODEBOOK.md": ("zh", "重新归类：编码手册"),
}

ZH_NUM = "〇一二三四五六七八九"

# The texts the Chinese dossiers quote from the repository's copies, by what a scholar calls them.
SOURCE_TITLES = [
    ("hexagrams/", "《周易》"),
    ("yizhuan/xugua", "《序卦》"),
    ("lueli/bianwei", "《周易略例·辩位》"),
    ("lueli/mingtuan", "《周易略例·明彖》"),
    ("commentary/waizhuan-5", "《周易外传》卷五"),
    ("texts/YWH-H", "《周易正义》"),
    ("V130-LAO-MA", "帛书《老子》甲本"),
    ("V130-LAO-MB", "帛书《老子》乙本"),
    ("corpus/sources/L.html", "《道德经》王弼本"),
    ("春秋左氏傳__宣公", "《春秋左氏传·宣公》"),
    ("texts/XS04", "《南华真经》郭象注"),
    ("texts/V4DA002", "《晋书》卷三十五"),
]


def label(path: str, lang: str) -> str:
    """A reader's name for a repository file a dossier quotes."""
    p = path.split("#")[0].strip()
    name = p.rsplit("/", 1)[-1]
    m = re.match(r"0(\d)-", name)
    if "/chapters/" in p and m:
        n = int(m.group(1))
        return f"第{ZH_NUM[n]}章" if lang == "zh" else f"ch. {n}"
    table = [
        ("THE-THEORY-OF-BECOMING-ZHONGHUA", "总览之早期中文本（已入历史）", "an earlier Chinese overview, now history"),
        ("CHINESE-SOURCES-AND-BECOMING", "古文来源之研究（已入历史）", "the study of the Chinese sources, now history"),
        ("CIVILIZATION-THOUGHT-AND-BECOMING", "文明思想之研究（已入历史）", "the study of civilization thought, now history"),
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
    if p.startswith("sources/"):
        title = next((v for k, v in SOURCE_TITLES if k in p), None)
        return title or ("仓库存本" if lang == "zh" else "a text kept in the repository")
    stem = name.rsplit(".", 1)[0]
    if p.startswith("experiments/") and not p.endswith(".lean"):
        if name == "README.md":
            return "该实验之说明" if lang == "zh" else "the experiment's README"
        if name.startswith("PREDICTIONS"):
            return "该实验预先冻结之预测" if lang == "zh" else "the experiment's frozen predictions"
        return "该实验之代码" if lang == "zh" else "the experiment's code"
    if name == "README.md":
        folder = p.rsplit("/", 2)[-2]
        return f"{folder} 之说明" if lang == "zh" else f"the {folder} README"
    if name.endswith(".lean"):
        return f"{stem} 模块" if lang == "zh" else f"the {stem} module"
    return f"{stem}.py" if name.endswith(".py") else stem


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
    # Latin letters only beside the stars: Chinese emphasis sits right against its neighbours, and \w would refuse it.
    t = re.sub(r"(?<![A-Za-z0-9_*])\*(?!\s)(.+?)(?<!\s)\*(?![A-Za-z0-9_*])", r"<em>\1</em>", t)
    return re.sub(r"\x00(\d+)\x00", lambda m: f"<code>{html.escape(codes[int(m.group(1))])}</code>", t)


REPO_LINK = re.compile(r"\[[^\]]+\]\((?!#)[^)]+\)")


def is_nav(line: str) -> bool:
    """A line of nothing but links into the repository: dead in print, and the edition's parts sit side by side."""
    rest, links = REPO_LINK.subn("", line)
    return links > 0 and not rest.strip(" ·（）()")


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
        elif l.startswith(">"):
            flush()
            quoted = []
            while i < len(lines) and lines[i].startswith(">"):
                said = lines[i].lstrip("> ").strip()
                quoted += [f"<p>{inline(said)}</p>"] if said else []
                i += 1
            out.append("<blockquote>" + "".join(quoted) + "</blockquote>")
            continue
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
        elif not para and is_nav(l):
            pass
        else:
            para.append(l.strip())
        i += 1
    flush()
    return "\n".join(out)


CSS = """
@page { size: A4; margin: 20mm 18mm 20mm 18mm;
  @bottom-center { content: counter(page); font-family: var(--sans); font-size: 8pt; color: #8a8378; }
  @bottom-right { content: "%(foot)s"; font-family: var(--sans); font-size: 7pt; color: #8a8378; } }
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
tr { break-inside: avoid; }
th, td { text-align: left; vertical-align: top; padding: 1.6mm 2mm; border-bottom: .5px solid #d9d0c0; }
th { font-family: var(--sans); font-weight: 600; color: var(--muted); border-bottom: .8px solid var(--rule); }
hr { border: none; border-top: .6px solid var(--rule); margin: 7mm 0; }
blockquote { margin: 0 0 3mm 3mm; padding-left: 3mm; border-left: 2px solid var(--rule); }
blockquote p { margin-bottom: 1mm; }
.stamp { font-family: var(--sans); font-size: 8.5pt; line-height: 1.5; color: var(--muted); margin: -3mm 0 6mm; }
"""

ONE_SHEET = {"../ONE-PAGE.md", "../ONE-PAGE.zh.md"}  # the page called one page prints on one sheet, both sides
BLIND = {"recoding/CODEBOOK.md"}  # a coder is sent to nothing else until the sheet is back, the repository least: the key is there
FONTS = {
    "zh": {"serif": '"Songti SC", "STSong", serif', "sans": '"PingFang SC", "Hiragino Sans GB", sans-serif',
           "size": "10.5pt", "lh": "1.85"},
    "en": {"serif": '"Iowan Old Style", "Charter", Georgia, "Songti SC", serif',
           "sans": '"Avenir Next", "Helvetica Neue", "PingFang SC", sans-serif', "size": "10.4pt", "lh": "1.55"},
}


def git(*args: str) -> str:
    return subprocess.run(["git", "-C", str(ROOT), *args], capture_output=True, text=True, check=True).stdout.rstrip("\n")


def dirty() -> list:
    """Changes in the tree, the edition's own output aside."""
    rel = RELEASE.relative_to(ROOT).as_posix() + "/"
    return [l for l in git("status", "--porcelain").splitlines() if not l[3:].strip('"').startswith(rel)]


def stamp(lang: str, commit: str, day: str, release: bool, changed: bool, blind: bool = False) -> str:
    y, m, d = (int(x) for x in day.split("-"))
    if release:
        if lang == "zh":
            return (f"本版依仓库之提交 {commit}（{y} 年 {m} 月 {d} 日）。文中指向仓库之链接，此处只存其文"
                    + ("。" if blind else "；如何取得仓库，见随附之信。"))
        month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October",
                 "November", "December"][m - 1]
        return (f"Reader edition of the work at commit {commit}, {d} {month} {y}. Links into the repository are plain "
                + ("text here." if blind else "text here; the covering letter says how to reach it."))
    if lang == "zh":
        return f"此为草稿，依提交 {commit}{'，另有未提交之改动' if changed else ''}；不是冻结之版。"
    return f"Draft from commit {commit}{' with uncommitted changes' if changed else ''}; not the frozen version."


def out_name(part: str) -> str:
    return pathlib.PurePosixPath(part).name.rsplit(".md", 1)[0]


def defects(pdf: pathlib.Path, page: pathlib.Path) -> list:
    """What a reader must not meet: checker markup, links to nowhere, a missing glyph's box, this machine's paths, and
    text that copies or searches wrongly."""
    reader = PdfReader(pdf)
    text = "\n".join(p.extract_text() or "" for p in reader.pages)
    found = [f"markup left: {m}" for m in ("<a id", "&lt;", "&gt;", "&amp;") if m in text]
    found += [f"a radical for a character in the text layer: {c}" for c in set(re.findall("[\u2e80-\u2fdf]", text))]
    body = page.read_text(encoding="utf-8")
    prose = re.sub(r"<(pre|code|style)\b.*?</\1>", "", body, flags=re.S)
    words = re.sub(r"<[^>]+>", "", prose)  # the page's words, before a line break can hide a marker
    found += [f"markup left: {m}" for m in ("Quote [", "Source [", "引〔", "原文〔", "](#", "```") if m in words]
    found += [f"markup left: {m.group(0)}" for m in re.finditer(r".{0,12}\*\S.{0,12}", prose)]
    found += ["markup left: a quote mark"] if "<p>&gt;" in prose else []
    ids = set(re.findall(r'\sid="([^"]+)"', body))
    found += [f"link to nowhere: #{h}" for h in sorted(set(re.findall(r'href="#([^"]+)"', body)) - ids)]
    for p in reader.pages:
        res = p.get("/Resources")
        for font in ((res.get_object().get("/Font") or {}).values() if res else ()):
            if "LastResort" in str(font.get_object().get("/BaseFont")):
                found.append("a glyph fell back to the box font")
    raw = pdf.read_bytes()
    found += [f"local path in the file: {w.decode()}" for w in (b"/Users/", b"/private/tmp", b"file:///") if w in raw]
    return sorted(set(found))


def print_pdf(page: pathlib.Path, pdf: pathlib.Path) -> None:
    """Print with headless Chrome under its own profile, apart from a person's browser. Under heavy load Chrome can write
    the file and then die in its teardown, so what counts is its saying it wrote every byte, not its exit status."""
    command = [CHROME, "--headless=new", "--disable-gpu", "--no-pdf-header-footer",
               "--run-all-compositor-stages-before-draw", "--virtual-time-budget=5000",
               f"--user-data-dir={BUILD / 'chrome-profile'}", f"--print-to-pdf={pdf}", page.as_uri()]
    said = ""
    for _ in range(3):
        pdf.unlink(missing_ok=True)
        try:
            run = subprocess.run(command, capture_output=True, text=True, timeout=300)
        except subprocess.TimeoutExpired:
            said = "no answer in 300 s"
            continue
        said = run.stdout + run.stderr
        wrote = re.search(r"(\d+) bytes written to file", said)
        if wrote and pdf.exists() and pdf.stat().st_size == int(wrote.group(1)):
            return
    sys.exit(f"Chrome failed on {page.name}:\n{said[-800:]}")


def build(part: str, out_dir: pathlib.Path = DRAFT, release: bool = False) -> list:
    """Build one part and return its defects."""
    lang, title = PARTS[part]
    f = FONTS[lang]
    commit, day = git("rev-parse", "--short=9", "HEAD"), git("show", "-s", "--format=%cs", "HEAD")
    md = plain_citations((SRC / part).read_text(encoding="utf-8"), lang)
    foot = commit if release else f"draft {commit}"
    css = f":root {{ --serif: {f['serif']}; --sans: {f['sans']}; }}\n" + CSS % {**f, "foot": foot}
    if part in ONE_SHEET:
        css += "body { line-height: 1.48; } p { margin-bottom: 2mm; } li { margin-bottom: .8mm; }\n"
    line = f'<p class="stamp">{html.escape(stamp(lang, commit, day, release, bool(dirty()), part in BLIND))}</p>'
    main = convert(md).replace("</h1>", "</h1>\n" + line, 1)
    doc = (f'<!doctype html><html lang="{"zh-Hans" if lang == "zh" else "en"}"><head><meta charset="utf-8">'
           f"<title>{html.escape(title)}</title><style>{css}</style></head><body><main>{main}</main></body></html>")
    BUILD.mkdir(parents=True, exist_ok=True)
    page = BUILD / (out_name(part) + ".html")
    page.write_text(doc, encoding="utf-8")
    out_dir.mkdir(parents=True, exist_ok=True)
    pdf = out_dir / (out_name(part) + ".pdf")
    print_pdf(page, pdf)
    fixed = fix_tounicode(pdf)
    print("wrote", pdf.relative_to(ROOT), f"({fixed} glyph mappings normalized)")
    if part in ONE_SHEET and len(PdfReader(pdf).pages) > 2:
        print(f"  warning: {out_name(part)} runs past one sheet")  # the measure warns and never blocks (amendment 2)
    return defects(pdf, page)


def sha256(path: pathlib.Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def release() -> None:
    """The frozen version that is sent: from a clean tree at one commit, or not at all."""
    changes = dirty()
    if changes:
        sys.exit("--release needs a clean tree (use a detached worktree of the frozen commit); changed:\n  "
                 + "\n  ".join(changes[:20]))
    commit = git("rev-parse", "HEAD")
    manifest = RELEASE / "MANIFEST.txt"
    if manifest.exists() and commit not in manifest.read_text(encoding="utf-8"):
        sys.exit(f"{manifest.relative_to(ROOT)} is another commit's edition; move it aside first")
    if subprocess.run([sys.executable, "-B", str(CHECKER)]).returncode:
        sys.exit("the dossier check fails; nothing built")
    built = BUILD / "release"  # moved into place only if every part passes, so that a refused edition leaves nothing
    problems = {part: found for part in PARTS if (found := build(part, built, release=True))}
    if problems:
        sys.exit("defects in the edition:\n" + "\n".join(f"  {p}: {x}" for p, xs in problems.items() for x in xs))
    RELEASE.mkdir(parents=True, exist_ok=True)
    chrome = subprocess.run([CHROME, "--version"], capture_output=True, text=True).stdout.strip()
    for source in [built / (out_name(p) + ".pdf") for p in PARTS] + SHEETS:
        shutil.copyfile(source, RELEASE / source.name)
    files = [RELEASE / (out_name(p) + ".pdf") for p in PARTS] + [RELEASE / s.name for s in SHEETS]
    manifest.write_text(f"Reader edition of the review packet\ncommit {commit}\ncommitted {git('show', '-s', '--format=%cs', 'HEAD')}\n"
                        f"built with {chrome}\n\n" + "".join(f"{sha256(f)}  {f.name}\n" for f in files), encoding="utf-8")
    print("wrote", manifest.relative_to(ROOT), f"({len(files)} files, commit {commit[:9]})")


if __name__ == "__main__":
    args = sys.argv[1:]
    named = [a for a in args if a != "--release"]
    if "--release" in args:
        if named:
            sys.exit("--release builds the whole edition, not one part")
        release()
    else:
        for part in named or PARTS:
            for problem in build(part):
                print(f"  {part}: {problem}")
