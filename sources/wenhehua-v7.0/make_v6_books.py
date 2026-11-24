"""Build v6 reading editions using Pandoc+XeLaTeX without mutating old versions.
Usage from project root: python make_v6_books.py
"""
from pathlib import Path
import subprocess,sys
R=Path(__file__).resolve().parent
EXP=R/'export';EXP.mkdir(exist_ok=True)
NEW=[
 'research/38_从合化到诸语义_第六阶段总论.md',
 'formal/39_语义连接_形式规格与证明义务.md',
 'examples/40_语义连接_可复现实验.md',
 'review/41_第六阶段严格审查_反例及边界.md',
 'research/42_文言精稿_诸观相通.md',
 'planning/43_语义网络下一步路线.md',
 'sources/44_语义桥_文献依据与归属.md',
]
OLD=[
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
 '文合化_v6.0_逐一连接专论': ('文合化：诸语义逐一连接 · 第六阶段专论', NEW),
 '文合化_v6.0_理论全集': ('文合化：最小生成文法理论全集 v6.0', ['00_一页导读.md']+NEW+OLD),
 '文合化_v6.0_概念词林': ('文之词林：诸观相通、同异有准 v6.0',LEX),
}
HEADER='''---
title: "%TITLE%"
author: "文·合·化｜最小生成文法研究"
date: "2026年11月24日 · 版本 6.0"
---

'''
for name,(title,files) in GROUPS.items():
    text=HEADER.replace('%TITLE%',title)
    for index, rel in enumerate(files):
        if name.endswith('理论全集') and index==len(NEW)+1:
            text+='\n# 理论进展史料：第一至第五阶段\n\n**本节存档既往研究，并保留其历史语境。若早期叙述与第六阶段的语义限制冲突，以第六阶段的精确定义和反例为准。**\n\n'
        text += (R/rel).read_text(encoding='utf-8')+'\n\n'
    for src,dst in {'₀':'0','₁':'1','₂':'2','ᵀ':'T','⟦':'[[','⟧':']]','ł':'l'}.items():
        text=text.replace(src,dst)
    path=EXP/(name+'.md');path.write_text(text,encoding='utf8')
    pdf=path.with_suffix('.pdf')
    cmd=['pandoc',str(path),'-f','markdown+tex_math_single_backslash+tex_math_dollars+link_attributes',
         '-o',str(pdf),'--pdf-engine=xelatex','--toc','--toc-depth=2','--number-sections',
         '-H',str(EXP/'unicode_map.tex'),'--resource-path',str(R),
         '-V','papersize=a4','-V','fontsize=10pt',
         '-V','geometry:top=2.15cm,bottom=2.05cm,left=2.22cm,right=2.22cm',
         '-V','CJKmainfont=Noto Serif CJK SC','-V','mainfont=Noto Serif CJK SC',
         '-V','sansfont=Noto Sans CJK SC','-V','monofont=Noto Sans Mono CJK SC',
         '-V','linestretch=1.15','-V','colorlinks=true','-V','linkcolor=blue',
         '-V','longtable=true']
    print('Building',name,'chars',len(text),flush=True)
    result=subprocess.run(cmd,cwd=R,text=True,capture_output=True,timeout=240)
    if result.returncode:
        (EXP/(name+'.errors.txt')).write_text(result.stderr,encoding='utf8')
        print(result.stderr[-10000:],file=sys.stderr)
        sys.exit(result.returncode)
    if result.stderr.strip():
        (EXP/(name+'.warnings.txt')).write_text(result.stderr,encoding='utf8')
        print('WARN',result.stderr[-400:],flush=True)
    print('OK',pdf.stat().st_size,flush=True)
