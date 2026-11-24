"""Build the three v2 PDFs from Markdown with pandoc / XeLaTeX.
Uses no network access; provides a reproducible document build pipeline.
"""
from __future__ import annotations
from pathlib import Path
import subprocess,sys
R=Path(__file__).resolve().parent
PREFIX='''---
title: "%TITLE%"
author: "文·合·化｜最小生成文法研究"
date: "2026年11月24日 · 版本 2.0"
---

'''
GROUPS={
 '文合化_v2.0_高阶统一专论':[
    'research/10_合化同体_高阶统一论.md',
    'formal/11_高阶形式规格.md',
    'formal/12_二维相容_定理证据与失败条件.md',
    'examples/13_高阶实验与复现.md',
    'review/14_高阶统一_严谨性审查.md',
    'research/15_文言精稿与概念释义.md',
    'sources/17_高阶统一文献核对.md'],
 '文合化_v2.0_理论全集':[
    '00_一页导读.md',
    'research/10_合化同体_高阶统一论.md',
    'formal/11_高阶形式规格.md',
    'formal/12_二维相容_定理证据与失败条件.md',
    'examples/13_高阶实验与复现.md',
    'review/14_高阶统一_严谨性审查.md',
    'research/15_文言精稿与概念释义.md',
    'planning/16_高阶统一后_下一阶段路线.md',
    'sources/17_高阶统一文献核对.md',
    'research/01_文法总论.md',
    'formal/02_形式定义与命题.md',
    'formal/07_第二轮_公理语义与同异.md',
    'review/06_第一轮_破缺审查.md',
    'sources/参考文献与考据.md'],
 '文合化_v2.0_概念词林':[
    'lexicon/06_高阶统一概念增注.md',
    'lexicon/05_同异_精辨与概念谱系.md',
    'lexicon/01_核心概念精注.md',
    'lexicon/03_文之构造图谱.md',
    'lexicon/04_广义词库389条_原稿.md',
    'lexicon/02_词库使用指南.md'],
}
TITLES={
 '文合化_v2.0_高阶统一专论':'合化同体：一体二向的高阶生成文法',
 '文合化_v2.0_理论全集':'文·合·化：最小生成文法理论全集 v2.0',
 '文合化_v2.0_概念词林':'文之词林：概念谱系与高阶构造 v2.0',
}

if __name__=='__main__':
    for base,parts in GROUPS.items():
        document=PREFIX.replace('%TITLE%',TITLES[base])
        for i,rel in enumerate(parts):
            if i:
                document+='\n\\newpage\n\n'
            if base=='文合化_v2.0_理论全集' and i==9:
                document+='\n# 历史基准资料：v1.0—v1.2\n\n**下列章节为历史研究材料；后续若有冲突，以上述 v2.0 理论声明为准。**\n\n'
            document+=(R/rel).read_text(encoding='utf-8')+'\n'
        # Unicode subscripts and double brackets in old code blocks are absent
        # from the available monospaced CJK font. Keep source files intact; in
        # printable combined copy, use legible ASCII representatives.
        for src,dst in {
            '₀':'0','₁':'1','₂':'2','ᵀ':'T',
            '⟦':'[[','⟧':']]','ł':'l'
        }.items():
            document=document.replace(src,dst)
        md=R/'export'/f'{base}.md'
        md.write_text(document,encoding='utf-8')
        pdf=R/'export'/f'{base}.pdf'
        cmd=['pandoc',str(md),'-f','markdown+tex_math_single_backslash+tex_math_dollars',
             '-o',str(pdf),'--pdf-engine=xelatex','--toc','--toc-depth=2',
             '--number-sections','-H',str(R/'export/unicode_map.tex'),
             '--resource-path',str(R),
             '-V','papersize=a4', '-V','fontsize=10pt',
             '-V','geometry:top=2.25cm,bottom=2.1cm,left=2.25cm,right=2.25cm',
             '-V','CJKmainfont=Noto Serif CJK SC',
             '-V','mainfont=Noto Serif CJK SC',
             '-V','sansfont=Noto Sans CJK SC',
             '-V','monofont=Noto Sans Mono CJK SC',
             '-V','linestretch=1.22',
             '-V','colorlinks=true','-V','linkcolor=blue']
        print('building',pdf.name, 'markdown bytes:',len(document),flush=True)
        proc=subprocess.run(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True,cwd=R,timeout=180)
        if proc.returncode!=0:
            print(proc.stderr[-5000:]);sys.exit(proc.returncode)
        if proc.stderr.strip():
            (R/'export'/f'{base}.warnings.txt').write_text(proc.stderr,encoding='utf-8')
            print('warnings:',len(proc.stderr.splitlines()),proc.stderr[-220:].replace('\n',' '))
        print('done',pdf.stat().st_size,flush=True)
