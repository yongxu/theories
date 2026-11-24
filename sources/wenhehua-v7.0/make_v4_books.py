"""Build v4 Markdown reading editions and PDF with Pandoc/XeLaTeX."""
from pathlib import Path
import subprocess,sys,csv
R=Path(__file__).resolve().parent

base_lex=R/'lexicon/08_共界变化_概念增注.csv'
with base_lex.open(encoding='utf-8-sig') as f:items=list(csv.DictReader(f))
lines=['# 共界变化：术语精读','',f'**本册新增 {len(items)} 条概念、{len(set(x["语义族"] for x in items))} 个语义族。** 与此前词库的重叠不作为不同词条的累加统计。','',
       '所有词义为本研究的工作定义；若无独立考据，不把新复合词冒称古典惯用语。','']
for fam in dict.fromkeys(x['语义族'] for x in items):
    lines.extend([f'## {fam}','','| 词 | 构造性解释与数学参照 | 使用时应当防止的误读 |','|---|---|---|'])
    for x in (z for z in items if z['语义族']==fam):
        desc=x['工作定义']+'；'+x['形式参照']+'。'
        lines.append('| '+' | '.join([x['词条'],desc,x['误用警示']])+' |')
    lines.append('')
(R/'lexicon/08_共界变化_概念增注_阅读版.md').write_text('\n'.join(lines),encoding='utf-8')

GROUPS = {
 '文合化_v4.0_共界变化专论':[
   'research/25_共界重构_第四阶段总论.md',
   'formal/26_共享界变_定义判据与命题.md',
   'examples/27_共享界变_运行示例与反例.md',
   'review/28_第四阶段_严格审查.md',
   'planning/29_严格化路线_v4.0.md',
   'sources/30_第四阶段_来源与归属.md',
 ],
 '文合化_v4.0_理论全集':[
   '00_一页导读.md',
   'research/25_共界重构_第四阶段总论.md',
   'formal/26_共享界变_定义判据与命题.md',
   'examples/27_共享界变_运行示例与反例.md',
   'review/28_第四阶段_严格审查.md',
   'planning/29_严格化路线_v4.0.md',
   'sources/30_第四阶段_来源与归属.md',
   'research/18_界生时流观守_第三阶段总论.md',
   'formal/19_界变与稳定接缝的形式规格.md',
   'formal/20_时流与观守_多语义规格.md',
   'examples/21_界变时流观守_实验与实例.md',
   'review/22_第三阶段严格审查与最小反例.md',
   'research/10_合化同体_高阶统一论.md',
   'formal/11_高阶形式规格.md',
   'formal/12_二维相容_定理证据与失败条件.md',
   'research/01_文法总论.md',
   'formal/02_形式定义与命题.md',
 ],
 '文合化_v4.0_概念词林':[
   'lexicon/08_共界变化_概念增注_阅读版.md',
   'lexicon/07_界变时流观守_概念增注.md',
   'lexicon/06_高阶统一概念增注.md',
   'lexicon/05_同异_精辨与概念谱系.md',
   'lexicon/01_核心概念精注.md',
   'lexicon/03_文之构造图谱.md',
   'lexicon/04_广义词库389条_原稿.md',
   'lexicon/02_词库使用指南.md',
 ]
}
TITLES={
 '文合化_v4.0_共界变化专论':'共界之易：共享接缝重构、续迹与显式调适',
 '文合化_v4.0_理论全集':'文·合·化：最小生成文法理论全集 v4.0',
 '文合化_v4.0_概念词林':'文之词林：共界、续、同异与生成构造 v4.0',
}
HEADER='''---
title: "%TITLE%"
author: "文·合·化｜最小生成文法研究"
date: "2026年11月24日 · 版本 4.0"
---

'''
if __name__=='__main__':
 for base,parts in GROUPS.items():
    doc=HEADER.replace('%TITLE%',TITLES[base])
    for i,rel in enumerate(parts):
        if base=='文合化_v4.0_理论全集' and i==7:
            doc+='\n# 历史理论演进：v3.0 与更早版本\n\n**以下为前期研究记录；关于共享接缝改变，以本册 v4.0 的新判据与限制为准。**\n\n'
        doc+=(R/rel).read_text(encoding='utf-8')+'\n\n'
    for src,dst in {'₀':'0','₁':'1','₂':'2','ᵀ':'T','⟦':'[[','⟧':']]','ł':'l'}.items():doc=doc.replace(src,dst)
    target=R/'export'/f'{base}.md';target.write_text(doc,encoding='utf-8')
    pdf=target.with_suffix('.pdf')
    cmd=['pandoc',str(target),'-f','markdown+tex_math_single_backslash+tex_math_dollars',
         '-o',str(pdf),'--pdf-engine=xelatex','--toc','--toc-depth=2',
         '--number-sections','-H',str(R/'export/unicode_map.tex'),
         '--resource-path',str(R),
         '-V','papersize=a4','-V','fontsize=10pt',
         '-V','geometry:top=2.25cm,bottom=2.05cm,left=2.2cm,right=2.2cm',
         '-V','CJKmainfont=Noto Serif CJK SC','-V','mainfont=Noto Serif CJK SC',
         '-V','sansfont=Noto Sans CJK SC','-V','monofont=Noto Sans Mono CJK SC',
         '-V','linestretch=1.17','-V','colorlinks=true','-V','linkcolor=blue',
         '-V','longtable=true']
    print('BUILD',pdf.name,'chars',len(doc),flush=True)
    p=subprocess.run(cmd,cwd=R,text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,timeout=220)
    if p.returncode:
        (R/'export'/f'{base}.errors.txt').write_text(p.stderr,encoding='utf-8')
        print(p.stderr[-13000:]);sys.exit(p.returncode)
    if p.stderr.strip():
        (R/'export'/f'{base}.warnings.txt').write_text(p.stderr,encoding='utf-8')
        print('WARN',p.stderr[-1000:])
    print('OK',pdf.stat().st_size,flush=True)
