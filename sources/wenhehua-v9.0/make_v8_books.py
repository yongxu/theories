"""Generate v8 PDFs (dedicated monograph, integrated theory, integrated lexicon)."""
from pathlib import Path
import re, subprocess, sys
R=Path(__file__).resolve().parent
EXP=R/'export'
EXP.mkdir(exist_ok=True)
NEW=[
'research/52_合化同源_高阶生成总论.md',
'formal/53_双向生成与基变换_形式规格.md',
'examples/54_高阶拼接与基变换_复现.md',
'review/55_高阶统一_批判审查.md',
'planning/56_高阶统一下一阶段_形式化路线.md',
'sources/57_高阶统一_最新文献归属.md',
]
GROUPS={
'文合化_v8.0_合化同源高阶生成专论':('合化同源：双向生成图、高维粘合与保真比较',NEW),
'文合化_v8.0_理论全集':('文·合·化：最小生成文法理论全集 v8.0',
                             ['00_一页导读.md']+NEW+['export/文合化_v7.0_理论全集.md']),
'文合化_v8.0_概念词林':('文之词林：合化同源与高维生成 v8.0',
                             ['lexicon/12_高维粘合_概念精注.md',
                              'export/文合化_v7.0_概念词林.md']),
}
# Headings of inherited documents are retained to preserve original content,
# but the earlier YAML front matter must not be interpreted as another document.
def strip_yaml(text):
    return re.sub(r'^---\s*\n.*?\n---\s*\n','',text,flags=re.S)

additional=EXP/'v8_header.tex'
additional.write_text('\\usepackage{xurl}\n\\emergencystretch=3em\n',encoding='utf8')
for name,(title,paths) in GROUPS.items():
    text=f'---\ntitle: "{title}"\nauthor: "文·合·化研究"\ndate: "2026年11月24日 · v8.0"\n---\n\n'
    for idx,p in enumerate(paths):
        if p.startswith('export/文合化_v7'):
            text+='\n# 历史研究：第七阶段及此前理论\n\n**本节完整保留旧版。与 v8 新的数学角色、边界或证据等级冲突者，以本卷前部的 v8 专项审查为准。**\n\n'
        text+='\n\n'+strip_yaml((R/p).read_text(encoding='utf8'))+'\n'
    for old,new in {'₀':'0','₁':'1','₂':'2','ᵀ':'T','⟦':'[[','⟧':']]','ł':'l'}.items(): text=text.replace(old,new)
    md=EXP/(name+'.md'); md.write_text(text,encoding='utf8')
    pdf=EXP/(name+'.pdf')
    cmd=['pandoc',str(md),'-f','markdown+tex_math_dollars+tex_math_single_backslash+link_attributes',
         '-o',str(pdf),'--pdf-engine=xelatex','--toc','--toc-depth=2','--number-sections',
         '-H',str(EXP/'unicode_map.tex'),'-H',str(additional),
         '--resource-path',str(R),'-V','papersize:a4','-V','fontsize:10pt',
         '-V','geometry:top=2.1cm,bottom=2.0cm,left=2.2cm,right=2.2cm',
         '-V','CJKmainfont:Noto Serif CJK SC','-V','mainfont:Noto Serif CJK SC',
         '-V','sansfont:Noto Sans CJK SC','-V','monofont:Noto Sans Mono CJK SC',
         '-V','linestretch=1.14','-V','colorlinks:true','-V','linkcolor:blue']
    print('Generating',name,'text-length',len(text),flush=True)
    run=subprocess.run(cmd,cwd=R,encoding='utf8',errors='replace',capture_output=True,timeout=240)
    if run.returncode:
        (EXP/(name+'.error.log')).write_text(run.stderr,encoding='utf8')
        print('FAILED',run.stderr[-4000:],file=sys.stderr)
        sys.exit(1)
    (EXP/(name+'.texwarnings.log')).write_text(run.stderr,encoding='utf8')
    print('OK',pdf.stat().st_size,'bytes',flush=True)
