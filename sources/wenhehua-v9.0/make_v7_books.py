"""Build v7.0 updated PDFs using pandoc + XeLaTeX, while retaining older PDFs.

Run from project root: python make_v7_books.py
Creates complete Markdown and PDF versions of the new dedicated monograph,
integrated theory, and integrated historical/current lexicon.
"""
from pathlib import Path
import subprocess,sys
R=Path(__file__).resolve().parent
EXP=R/'export'; EXP.mkdir(exist_ok=True)
NEW=[
 'research/45_依观判守_第七阶段总论.md',
 'formal/46_依观判守_形式规格与定理.md',
 'examples/47_依观判守_复现实验与证据.md',
 'review/48_依观判守_反例审查与边界.md',
 'research/49_文言精稿_依观判守.md',
 'planning/50_第八阶段_形式解释与端到端路线.md',
 'sources/51_第七阶段文献与数学归属.md',
]
STAGE6=[
 'research/38_从合化到诸语义_第六阶段总论.md',
 'formal/39_语义连接_形式规格与证明义务.md',
 'examples/40_语义连接_可复现实验.md',
 'review/41_第六阶段严格审查_反例及边界.md',
 'research/42_文言精稿_诸观相通.md',
 'planning/43_语义网络下一步路线.md',
 'sources/44_语义桥_文献依据与归属.md',
]
EARLIER=[
 'research/31_续迹而不强同_第五阶段总论.md',
 'formal/32_带谱系共界与弱交换_形式规格.md',
 'review/34_第五阶段_反例与结论强度.md',
 'research/25_共界重构_第四阶段总论.md',
 'formal/26_共享界变_定义判据与命题.md',
 'research/18_界生时流观守_第三阶段总论.md',
 'formal/20_时流与观守_多语义规格.md',
 'research/10_合化同体_高阶统一论.md',
 'formal/11_高阶形式规格.md',
 'research/01_文法总论.md',
 'formal/02_形式定义与命题.md',
]
LEX=[
 'lexicon/11_依观判守_概念增注.md',
 'lexicon/10_语义连接_概念增注.md',
 'lexicon/09_谱系弱交换_概念增注.md',
 'lexicon/08_共界变化_概念增注_阅读版.md',
 'lexicon/07_界变时流观守_概念增注.md',
 'lexicon/06_高阶统一概念增注.md',
 'lexicon/05_同异_精辨与概念谱系.md',
 'lexicon/01_核心概念精注.md',
 'lexicon/03_文之构造图谱.md',
 'lexicon/04_广义词库389条_原稿.md',
]
GROUPS={
 '文合化_v7.0_依观判守专论': ('文合化：依观判守 · 第七阶段专论', NEW),
 '文合化_v7.0_理论全集': ('文合化：最小生成文法理论全集 v7.0', ['00_一页导读.md']+NEW+STAGE6+EARLIER),
 '文合化_v7.0_概念词林': ('文之词林：依观判守与诸文相成 v7.0', LEX),
}
HEADER='''---
title: "%TITLE%"
author: "文·合·化｜最小生成文法研究"
date: "2026年11月24日 · 版本 7.0"
---

'''
for key,(title,parts) in GROUPS.items():
    text=HEADER.replace('%TITLE%',title)
    for i,rel in enumerate(parts):
        if key.endswith('理论全集') and i == len(NEW)+1:
            text += '\n# 研究史料：第六阶段及此前版本\n\n**本节收录已完成的研究发展阶段。旧稿若与第七阶段的定义、证明义务、反例或证据等级冲突，应以本卷第七阶段的精确结论为准。**\n\n'
        if key.endswith('理论全集') and i == len(NEW)+1+len(STAGE6):
            text += '\n# 研究史料：第一至第五阶段\n\n**下列文本保留历史原貌，未必采用 v7 的全部限制条件。**\n\n'
        content=(R/rel).read_text(encoding='utf8')
        text += '\n\n' + content + '\n'
    # Some non-math Unicode subscripts have no glyph in the TeX font stack.
    for a,b in {'₀':'0','₁':'1','₂':'2','ᵀ':'T','⟦':'[[','⟧':']]','ł':'l'}.items():
        text=text.replace(a,b)
    markdown=EXP/(key+'.md')
    markdown.write_text(text,encoding='utf8')
    pdf=markdown.with_suffix('.pdf')
    cmd=['pandoc',str(markdown),'-f','markdown+tex_math_single_backslash+tex_math_dollars+link_attributes',
         '-o',str(pdf),'--pdf-engine=xelatex','--toc','--toc-depth=2','--number-sections',
         '-H',str(EXP/'unicode_map.tex'),'--resource-path',str(R),
         '-V','papersize=a4','-V','fontsize=10pt',
         '-V','geometry:top=2.15cm,bottom=2.05cm,left=2.22cm,right=2.22cm',
         '-V','CJKmainfont=Noto Serif CJK SC','-V','mainfont=Noto Serif CJK SC',
         '-V','sansfont=Noto Sans CJK SC','-V','monofont=Noto Sans Mono CJK SC',
         '-V','linestretch=1.15','-V','colorlinks=true','-V','linkcolor=blue','-V','longtable=true']
    print('Build',pdf.name,'length',len(text),flush=True)
    run=subprocess.run(cmd,cwd=R,text=True,capture_output=True,timeout=240)
    if run.returncode:
        (EXP/(key+'.errors.txt')).write_text(run.stderr,encoding='utf8')
        print(run.stderr[-12000:],file=sys.stderr)
        sys.exit(run.returncode)
    if run.stderr.strip():
        (EXP/(key+'.warnings.txt')).write_text(run.stderr,encoding='utf8')
        print('Warnings:',run.stderr[-800:],flush=True)
    print('Done',pdf.stat().st_size,'bytes',flush=True)
