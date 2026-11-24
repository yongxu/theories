"""Compile v5 Markdown reading editions as PDF, preserving the prior history.
Usage: python make_v5_books.py (Pandoc, XeLaTeX, Noto Serif CJK SC).
"""
from pathlib import Path
import subprocess,sys
R=Path(__file__).resolve().parent
EXPORT=R/'export';EXPORT.mkdir(exist_ok=True)
GROUPS={
 '文合化_v5.0_续迹弱交换专论':[
  'research/31_续迹而不强同_第五阶段总论.md',
  'formal/32_带谱系共界与弱交换_形式规格.md',
  'examples/33_弱交换_程序与最小反例.md',
  'review/34_第五阶段_反例与结论强度.md',
  'research/37_文言精稿_v5.md',
  'planning/35_高阶完备性与语义路线.md',
  'sources/36_第五阶段_文献与归属.md',
 ],
 '文合化_v5.0_理论全集':[
  '00_一页导读.md',
  'research/31_续迹而不强同_第五阶段总论.md',
  'formal/32_带谱系共界与弱交换_形式规格.md',
  'examples/33_弱交换_程序与最小反例.md',
  'review/34_第五阶段_反例与结论强度.md',
  'research/37_文言精稿_v5.md',
  'planning/35_高阶完备性与语义路线.md',
  'sources/36_第五阶段_文献与归属.md',
  'research/25_共界重构_第四阶段总论.md',
  'formal/26_共享界变_定义判据与命题.md',
  'examples/27_共享界变_运行示例与反例.md',
  'review/28_第四阶段_严格审查.md',
  'research/18_界生时流观守_第三阶段总论.md',
  'formal/19_界变与稳定接缝的形式规格.md',
  'formal/20_时流与观守_多语义规格.md',
  'research/10_合化同体_高阶统一论.md',
  'formal/11_高阶形式规格.md',
  'formal/12_二维相容_定理证据与失败条件.md',
  'research/01_文法总论.md',
  'formal/02_形式定义与命题.md',
 ],
 '文合化_v5.0_概念词林':[
  'lexicon/09_谱系弱交换_概念增注.md',
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
 '文合化_v5.0_续迹弱交换专论':'续迹而不强同：共界谱系与合化弱交换',
 '文合化_v5.0_理论全集':'文·合·化：最小生成文法理论全集 v5.0',
 '文合化_v5.0_概念词林':'文之词林：谱系、同异、共界与生成构造 v5.0',
}
HEADER='''---
title: "%TITLE%"
author: "文·合·化｜最小生成文法研究"
date: "2026年11月24日 · 版本 5.0"
---

'''
if __name__=='__main__':
 for name,parts in GROUPS.items():
  doc=HEADER.replace('%TITLE%',TITLES[name]);
  for i,rel in enumerate(parts):
   if name.endswith('理论全集') and i==8:
    doc+='\n# 历史理论进展与前期推演\n\n**以下为此前研究记录。遇到旧结论与 v5.0 的「谱系关联／身份持续」区分不一致时，以 v5.0 新结论为准；前述历史判断保留供追溯。**\n\n'
   doc+=(R/rel).read_text(encoding='utf-8')+'\n\n'
  for src,dst in {'₀':'0','₁':'1','₂':'2','ᵀ':'T','⟦':'[[','⟧':']]','ł':'l'}.items():doc=doc.replace(src,dst)
  md=EXPORT/f'{name}.md';md.write_text(doc,encoding='utf-8')
  pdf=md.with_suffix('.pdf')
  cmd=['pandoc',str(md),'-f','markdown+tex_math_single_backslash+tex_math_dollars+link_attributes',
       '-o',str(pdf),'--pdf-engine=xelatex','--toc','--toc-depth=2','--number-sections',
       '-H',str(EXPORT/'unicode_map.tex'),'--resource-path',str(R),
       '-V','papersize=a4','-V','fontsize=10pt',
       '-V','geometry:top=2.25cm,bottom=2.05cm,left=2.2cm,right=2.2cm',
       '-V','CJKmainfont=Noto Serif CJK SC','-V','mainfont=Noto Serif CJK SC',
       '-V','sansfont=Noto Sans CJK SC','-V','monofont=Noto Sans Mono CJK SC',
       '-V','linestretch=1.17','-V','colorlinks=true','-V','linkcolor=blue',
       '-V','longtable=true']
  print('BUILD',name,'chars',len(doc),flush=True)
  p=subprocess.run(cmd,cwd=R,text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,timeout=240)
  if p.returncode:
   (EXPORT/f'{name}.errors.txt').write_text(p.stderr,encoding='utf-8')
   print('ERROR',p.stderr[-15000:]);sys.exit(p.returncode)
  if p.stderr.strip():
   (EXPORT/f'{name}.warnings.txt').write_text(p.stderr,encoding='utf-8')
   print('WARN',p.stderr[-700:])
  print('OK',pdf.stat().st_size,flush=True)
