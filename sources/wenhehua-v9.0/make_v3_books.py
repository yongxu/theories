"""Build three v3 reading PDFs from the UTF-8 Markdown manuscript sources."""
from __future__ import annotations
from pathlib import Path
import subprocess,sys
R=Path(__file__).resolve().parent
PREFIX='''---
title: "%TITLE%"
author: "文·合·化｜最小生成文法研究"
date: "2026年11月24日 · 版本 3.0"
---

'''
GROUPS={
 '文合化_v3.0_界变时流观守专论':[
     'research/18_界生时流观守_第三阶段总论.md',
     'formal/19_界变与稳定接缝的形式规格.md',
     'formal/20_时流与观守_多语义规格.md',
     'examples/21_界变时流观守_实验与实例.md',
     'review/22_第三阶段严格审查与最小反例.md',
     'planning/23_后续严格化路线_v3.0.md',
     'sources/24_第三阶段来源核对.md'],
 '文合化_v3.0_理论全集':[
     '00_一页导读.md',
     'research/18_界生时流观守_第三阶段总论.md',
     'formal/19_界变与稳定接缝的形式规格.md',
     'formal/20_时流与观守_多语义规格.md',
     'examples/21_界变时流观守_实验与实例.md',
     'review/22_第三阶段严格审查与最小反例.md',
     'planning/23_后续严格化路线_v3.0.md',
     'sources/24_第三阶段来源核对.md',
     'research/10_合化同体_高阶统一论.md',
     'formal/11_高阶形式规格.md',
     'formal/12_二维相容_定理证据与失败条件.md',
     'research/15_文言精稿与概念释义.md',
     'research/01_文法总论.md',
     'formal/02_形式定义与命题.md',
     'formal/07_第二轮_公理语义与同异.md',
 ],
 '文合化_v3.0_概念词林':[
     'lexicon/07_界变时流观守_概念增注.md',
     'lexicon/06_高阶统一概念增注.md',
     'lexicon/05_同异_精辨与概念谱系.md',
     'lexicon/01_核心概念精注.md',
     'lexicon/03_文之构造图谱.md',
     'lexicon/04_广义词库389条_原稿.md',
     'lexicon/02_词库使用指南.md'],
}
TITLES={
 '文合化_v3.0_界变时流观守专论':'界因所接而立：界变、时流与观守',
 '文合化_v3.0_理论全集':'文·合·化：最小生成文法理论全集 v3.0',
 '文合化_v3.0_概念词林':'文之词林：关系、界变与高阶生成 v3.0',
}
if __name__=='__main__':
    for base,parts in GROUPS.items():
        doc=PREFIX.replace('%TITLE%',TITLES[base])
        for i,rel in enumerate(parts):
            if i:doc+='\n\n'
            if base=='文合化_v3.0_理论全集' and i==8:
                doc+='\n# 历史理论演进：v2.0 与更早研究\n\n**以下部分是前期研究原稿；若与第三阶段规范冲突，以 v3.0 范围和限制为准。**\n\n'
            doc+=(R/rel).read_text(encoding='utf-8')+'\n'
        for src,dst in {'₀':'0','₁':'1','₂':'2','ᵀ':'T','⟦':'[[','⟧':']]','ł':'l'}.items():
            doc=doc.replace(src,dst)
        target=R/'export'/f'{base}.md';target.write_text(doc,encoding='utf-8')
        pdf=target.with_suffix('.pdf')
        cmd=['pandoc',str(target),'-f','markdown+tex_math_single_backslash+tex_math_dollars',
             '-o',str(pdf),'--pdf-engine=xelatex','--toc','--toc-depth=2',
             '--number-sections','-H',str(R/'export/unicode_map.tex'),
             '--resource-path',str(R),
             '-V','papersize=a4','-V','fontsize=10pt',
             '-V','geometry:top=2.25cm,bottom=2.1cm,left=2.25cm,right=2.25cm',
             '-V','CJKmainfont=Noto Serif CJK SC','-V','mainfont=Noto Serif CJK SC',
             '-V','sansfont=Noto Sans CJK SC', '-V','monofont=Noto Sans Mono CJK SC',
             '-V','linestretch=1.18','-V','colorlinks=true','-V','linkcolor=blue']
        print('BUILD',pdf.name,'md bytes:',len(doc),flush=True)
        proc=subprocess.run(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,
                            text=True,cwd=R,timeout=210)
        if proc.returncode:
            print(proc.stderr[-9000:]);sys.exit(proc.returncode)
        if proc.stderr.strip():
            (R/'export'/f'{base}.warnings.txt').write_text(proc.stderr,encoding='utf-8')
            print('WARN',len(proc.stderr.splitlines()),proc.stderr[-450:].replace('\n',' '))
        print('OK',pdf.stat().st_size,flush=True)
