"""Rebuild the three v9 reading editions using Pandoc and XeLaTeX.

Requires pandoc, xelatex, Noto CJK fonts, and the TeX packages in the headers.
Run from any directory: python3 make_v9_books.py [monograph|theory|lexicon|all].
Source files and historical editions are never rewritten by this script.
"""
from pathlib import Path
import argparse
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
EXPORT = ROOT / "export"
NEW = [
    "research/58_v9_严格高阶生成框架.md",
    "formal/59_v9_自由双范畴与相对三维生成.md",
    "formal/60_v9_动态共界的oplax语义与相干性.md",
    "formal/67_v9_生成历史的语法语义接口.md",
    "formal/66_v9_并排组合与任意有限阶.md",
    "formal/61_v9_基变换与观察保真.md",
    "examples/62_v9_构造与反例.md",
    "review/63_v9_证明状态与交叉审查.md",
    "planning/64_v9_形式化与应用路线.md",
    "sources/65_v9_原始文献与归属.md",
    "evidence/v9_reproduction.md",
]
GROUPS = {
    "monograph": (
        "文合化_v9.0_严格高阶生成专论",
        "文·合·化：严格高阶生成框架",
        "自由生成 · 保守升维 · 余松语义 · 宏展开相干",
        NEW,
    ),
    "theory": (
        "文合化_v9.0_理论全集",
        "文·合·化：理论全集 v9.0",
        "最新研究在前 · 历史论证完整保留",
        ["00_一页导读.md"] + NEW + ["export/文合化_v8.0_理论全集.md"],
    ),
    "lexicon": (
        "文合化_v9.0_概念词林",
        "文·合·化：概念词林 v9.0",
        "严格生成词谱 · 角色与类型 · 历史词库",
        ["lexicon/13_v9_严格生成词谱.md", "export/文合化_v8.0_概念词林.md"],
    ),
}


def strip_yaml(text):
    return re.sub(r"^---\s*\n.*?\n---\s*\n", "", text, flags=re.S)


def render_text(title, subtitle, paths):
    text = (
        f'---\ntitle: "{title}"\nsubtitle: "{subtitle}"\n'
        'author: "文·合·化研究"\ndate: "2026年11月24日 · v9.0"\n'
        '---\n\n'
    )
    for path in paths:
        if path.startswith("export/文合化_v8"):
            text += (
                "\n\\clearpage\n\n# 历史汇编：v8 及此前版本\n\n"
                "**以下保留旧版的原有论述与阶段性判断。最新定义、证明范围、"
                "实现状态和纠错以本卷前部 v9 正式稿为准。旧版测试数字只表示当时的实现。**\n\n"
            )
        text += "\n\n" + strip_yaml((ROOT / path).read_text(encoding="utf8")) + "\n"
    # CJK fonts lack several Unicode subscripts in literal code spans. Render
    # readable ASCII equivalents there and preserve actual TeX math notation.
    table = str.maketrans("₀₁₂₃₄₅₆₇₈₉", "0123456789")
    text = text.translate(table)
    text = text.replace("ᵀ", "T").replace("⟦", "[[").replace("⟧", "]]")
    text = text.replace("⁻¹", "^(-1)")
    text = text.replace("ł", "l")
    return text


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("book", choices=["all", *GROUPS], default="all", nargs="?")
    args = parser.parse_args()
    EXPORT.mkdir(exist_ok=True)
    for key, (name, title, subtitle, paths) in GROUPS.items():
        if args.book not in ("all", key):
            continue
        text = render_text(title, subtitle, paths)
        md = EXPORT / (name + ".md")
        pdf = EXPORT / (name + ".pdf")
        md.write_text(text, encoding="utf8")
        command = [
            "pandoc", str(md), "-f",
            "markdown+tex_math_dollars+tex_math_single_backslash+link_attributes",
            "-o", str(pdf), "--pdf-engine=xelatex", "--toc", "--toc-depth=2",
            "--lua-filter", str(EXPORT / "v9_wrap.lua"),
            "-H", str(EXPORT / "v9_unicode.tex"),
            "-H", str(EXPORT / "v9_header.tex"),
            "--resource-path", str(ROOT),
            "-V", "papersize:a4", "-V", "fontsize:10pt",
            "-V", "geometry:top=2.1cm,bottom=2.0cm,left=2.2cm,right=2.2cm",
            "-V", "mainfont:Noto Serif CJK SC",
            "-V", "sansfont:Noto Sans CJK SC",
            "-V", "monofont:Noto Sans Mono CJK SC",
            "-V", "linestretch:1.14", "-V", "colorlinks:true",
            "-V", "linkcolor:blue", "-V", "urlcolor:blue",
        ]
        print("Generating", name, "characters", len(text), flush=True)
        result = subprocess.run(command, cwd=ROOT, capture_output=True,
                                encoding="utf8", errors="replace", timeout=360)
        (EXPORT / (name + ".texwarnings.log")).write_text(result.stderr, encoding="utf8")
        if result.returncode:
            print(result.stderr[-10000:], file=sys.stderr)
            return result.returncode
        print("OK", pdf.stat().st_size, "bytes", flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
