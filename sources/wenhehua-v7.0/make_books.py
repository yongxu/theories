"""Regenerate reading copies from the Markdown research sources."""
from pathlib import Path
import html,subprocess,re
from weasyprint import HTML
ROOT=Path(__file__).resolve().parent
OUT=ROOT/'export';OUT.mkdir(exist_ok=True)
STYLE='''
@page {size:A4; margin:18mm 18mm 19mm 18mm; @bottom-left{content:"文·合·化｜研究基准 v1.2";font-family:"Noto Sans CJK SC";font-size:8pt;color:#77858b} @bottom-right{content:counter(page);font-family:"Noto Sans CJK SC";font-size:8pt;color:#77858b}}
*{box-sizing:border-box}
body{font-family:"Noto Serif CJK SC","Noto Sans CJK SC",serif;color:#142832;font-size:10pt;line-height:1.72}
h1,h2,h3{font-family:"Noto Sans CJK SC",sans-serif;line-height:1.35;page-break-after:avoid;color:#123a43}
h1{font-size:21pt;letter-spacing:.2pt;margin:0 0 14pt}
h2{font-size:14.5pt;border-bottom:1pt solid #cddfe0;padding-bottom:5pt;margin:18pt 0 7pt}
h3{font-size:11.5pt;color:#0c7880;margin:12pt 0 4pt}
p{margin:5pt 0 9pt} strong{color:#133d49} em{color:#365b61}
blockquote{border-left:3px solid #128b87;background:#f0f6f5;padding:5pt 10pt;margin:10pt 0;color:#28484e}
pre{background:#edf4f3;padding:8pt;border-left:2px solid #0f8e8a;white-space:pre-wrap;overflow-wrap:anywhere;word-break:break-word;font-size:8.3pt;line-height:1.43;font-family:"Noto Sans Mono CJK SC",monospace}
code{font-size:8.3pt;font-family:"Noto Sans Mono CJK SC",monospace;background:#f1f5f5;overflow-wrap:anywhere;white-space:normal}
pre code{background:none}
table{border-collapse:collapse;width:100%;table-layout:fixed;font-size:8pt;line-height:1.48;margin:9pt 0 14pt}
th,td{border-bottom:0.5pt solid #dde7e6; padding:5pt;vertical-align:top;overflow-wrap:anywhere;word-wrap:break-word}
th{background:#e9f3f1;color:#16454a;font-family:"Noto Sans CJK SC"}
tr{break-inside:avoid}thead{display:table-header-group}
tr:nth-child(2n) td{background:#fafcfc}
li{margin:3pt 0} a{color:#087c7e;text-decoration:none;overflow-wrap:anywhere}
.chapter{page-break-before:always}
.bookcover{height:242mm;display:flex;flex-direction:column;justify-content:center;padding:12mm 8mm;break-after:page}
.bookcover .en{color:#107e7f;font-family:"Noto Sans CJK SC";font-size:10pt;letter-spacing:3pt;margin-bottom:16mm}
.bookcover h1{font-size:40pt;letter-spacing:4pt;margin:0 0 8mm;color:#0e333e}
.bookcover h2{font-size:18pt;border:0;padding:0;font-weight:400;line-height:1.6;color:#345d65;margin:0}
.bookcover .bar{height:3px;width:23mm;background:#0c8d8a;margin:17mm 0 11mm}
.bookcover .note{font-size:9pt;color:#72858a;font-family:"Noto Sans CJK SC";line-height:1.9}
.toc{break-after:page}.toc h1{font-size:20pt;margin-bottom:12pt}.toc p{border-bottom:0.5pt solid #e2ecec;padding:6pt 0}
.chapterhead{font-size:8pt;color:#6a8b8b;margin-bottom:8pt;font-family:"Noto Sans CJK SC"}
'''

def md2html(path):
    p=subprocess.run(['pandoc','--from=gfm','--to=html5','--wrap=none'],
                     input=path.read_text(encoding='utf-8'),text=True,capture_output=True)
    if p.returncode:raise RuntimeError(p.stderr)
    return p.stdout

def build(name,title,subtitle,chapters,description):
    content=f'<div class="bookcover"><div class="en">RESEARCH MONOGRAPH · 2026</div><h1>{title}</h1><h2>{subtitle}</h2><div class="bar"></div><div class="note">{description}<br>2026 年 11 月 24 日<br>两轮深化研究 · 不是普适本体论完备性证明<br>文·合·化 v1.2</div></div>'
    content+='<div class="toc"><h1>目录</h1>'
    for idx,(label,file) in enumerate(chapters,1):
        content+=f'<p>{idx:02d}　{html.escape(label)}</p>'
    content+='</div>'
    for label,file in chapters:
        content+=f'<section class="chapter"><div class="chapterhead">文·合·化　/　{html.escape(label)}</div>{md2html(ROOT/file)}</section>'
    local_style = STYLE + ('body{font-size:9.5pt;line-height:1.60} table{font-size:7.8pt;line-height:1.43} th,td{padding:4pt} p{margin:4pt 0 7pt} h2{margin:16pt 0 6pt}' if '概念词林' in name else '')
    complete='<!doctype html><html lang="zh"><head><meta charset="utf-8"><style>'+local_style+'</style></head><body>'+content+'</body></html>'
    (OUT/(name+'.html')).write_text(complete,encoding='utf-8')
    HTML(string=complete,base_url=str(ROOT)).write_pdf(str(OUT/(name+'.pdf')))
    print(name, (OUT/(name+'.pdf')).stat().st_size)

main=[
('一页导读与研究位置','00_一页导读.md'),
('第一轮：破缺审查与真实修复','review/06_第一轮_破缺审查.md'),
('第二轮：公理、语义与同异','formal/07_第二轮_公理语义与同异.md'),
('理论基准：文法总论（v1.0）','research/01_文法总论.md'),
('有限图定义与 P1/P2（v1.0）','formal/02_形式定义与命题.md'),
('原基准实例与证据','examples/03_可复现示例与证据.md'),
('新版实验：接口、抽象与资源','examples/09_第二轮_实验与复现.md'),
('原始反例与审查结论','review/04_反例与审查结论.md'),
('研究路线图与验收','planning/05_路线图与验收.md'),
('参考文献与考据基准','sources/参考文献与考据.md'),
('第二轮来源核验与异文','sources/08_二轮来源核对.md'),
]
lexicon=[
('同异精辨：34组关键概念','lexicon/05_同异_精辨与概念谱系.md'),
('核心概念精注：84词','lexicon/01_核心概念精注.md'),
('文之构造：100种图式','lexicon/03_文之构造图谱.md'),
('词库使用指南','lexicon/02_词库使用指南.md'),
('广义候选全集：389条工作词','lexicon/04_广义词库389条_原稿.md'),
]
review=[
('阅读导引','00_一页导读.md'),
('第一轮：破缺审查','review/06_第一轮_破缺审查.md'),
('第二轮：公理与语义修订','formal/07_第二轮_公理语义与同异.md'),
('新版的实验见证','examples/09_第二轮_实验与复现.md'),
('同异精辨','lexicon/05_同异_精辨与概念谱系.md'),
('来源核验','sources/08_二轮来源核对.md'),
]
build('文合化_理论全集_v1.2','文 · 合 · 化','最小生成文法｜两轮深化后的理论全集',main,'修订版研究总论 · 数学定义与证明边界 · 构造、反例、复现')
build('文合化_概念词林_v1.2','文 之 词 林','概念谱系｜辨义、生成与形式条件',lexicon,'34组关键分辨 · 84个精注概念 · 100构造模式 · 389候选词')
build('文合化_两轮审查精读_v1.2','文 · 合 · 化','两轮审查｜从反例到严密构造',review,'重读最小性与可组合性 · 可重现实验 · 语义分层')
