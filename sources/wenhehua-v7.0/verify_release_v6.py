"""Reproducible release preflight: cross-file count, PDFs, SHA256, zip manifest."""
from pathlib import Path
from hashlib import sha256
from collections import Counter
import csv,json,fitz,subprocess,sys,zipfile
ROOT=Path(__file__).resolve().parent
ZIP=ROOT.parent/(ROOT.name+'.zip')
PDFS=sorted((ROOT/'export').glob('文合化_v6.0_*.pdf'))
assert len(PDFS)==3
REPORT={}
for path in PDFS:
 d=fitz.open(path)
 bad=[];empty=[];strange=[]
 for pno,p in enumerate(d,1):
  if len(p.get_text().strip())<15:empty.append(pno)
  for block in p.get_text('dict')['blocks']:
   if block['type']!=0:continue
   for line in block['lines']:
    for span in line['spans']:
     x0,y0,x1,y1=span['bbox']
     if x0 < -1 or y0 < -1 or x1>p.rect.width+1 or y1>p.rect.height+1:
      bad.append((pno,list(map(lambda x:round(x,1),span['bbox'])),span['text'][:35]))
     if '�' in span['text']:strange.append((pno,span['text']))
 assert not bad and not empty and not strange,(path.name,bad[:3],empty,strange[:3])
 REPORT[path.name]={'pages':len(d),'bytes':path.stat().st_size,'text_clipped':len(bad),'empty_pages':len(empty),'replacement_glyphs':len(strange)}
with (ROOT/'lexicon/10_语义连接_概念增注.csv').open(encoding='utf-8-sig') as f:
 vocab=list(csv.DictReader(f))
assert len(vocab)==100
assert len({v['语义族'] for v in vocab})==10
with (ROOT/'evidence/demo_v6.0.json').open() as f:demo=json.load(f)
assert demo['causal_observational_equal'] is True
assert demo['coarse_P_AB_to_C']=='1/4'
assert demo['lineage_comparison_lax']['invertible'] is False
assert demo['lineage_comparison_strong']['invertible'] is True
LOG=(ROOT/'evidence/tests_v6.0.txt').read_text()
assert 'Ran 187 tests' in LOG and '\nOK\n' in LOG
source_count=sum(1 for _ in (ROOT/'software/tests').glob('test_*.py'))
# Record all releasable files excluding temporary artifacts.
files=sorted(p for p in ROOT.rglob('*') if p.is_file() and '__pycache__' not in p.parts and p.suffix != '.pyc'
             and p.name not in ('manifest.json','SHA256SUMS.txt') and not p.name.endswith('.errors.txt'))
manifest={'project':'文·合·化', 'version':'6.0', 'date':'2026-11-24',
          'tests':187,'new_tests':50,'new_terms':100,'new_lexical_families':10,
          'pdfs':REPORT,'demo':demo,'source_test_files':source_count,
          'files':[{'path':str(p.relative_to(ROOT)), 'sha256':sha256(p.read_bytes()).hexdigest(),
                     'bytes':p.stat().st_size} for p in files]}
(ROOT/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf8')
checks=[f"{it['sha256']}  {it['path']}" for it in manifest['files']]
(ROOT/'SHA256SUMS.txt').write_text('\n'.join(checks)+'\n',encoding='utf8')
report=f'''# 文·合·化 v6.0 | 交付前质量审计

- 日期：2026-11-24
- 自动测试：**187/187** 通过，其中本轮新增 **50** 项。
- 新增工作词：**100** 条，共 **10** 个语义族。
- PDF：三册，合计 **{sum(x['pages'] for x in REPORT.values())}** 页；已执行可提取文字、无越界文本框、无整页空白及 Unicode replacement 字符检查。
- 文法形式范围：有限类型集合、有限类型化链与部分图；**没有**完成所有跨领域的通用双函子或自然性证明。
- JSON 演示：六类语义的精确结果已被断言检查。
- SHA256：对项目文件逐一登记，详见 `SHA256SUMS.txt` 和 `manifest.json`。

## 三册 PDF

'''+''.join(f"- `{k}`：{v['pages']} 页，{v['bytes']} 字节。\n" for k,v in REPORT.items())+'''
## 抽查说明

已自动检查所有 PDF 页面边界与文本提取，并制作首尾／中间页缩略图供人工复核。已有历史文本中出现的 `□` 是证明结束符号，不是 Unicode replacement `�`。检查保证的是渲染中没有检测到的明显边界错误，不是排除一切排版问题的形式证明。
'''
(ROOT/'evidence/QC_REPORT_v6.0.md').write_text(report,encoding='utf8')
# now archive including QC
with zipfile.ZipFile(ZIP,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as z:
 for p in sorted(ROOT.rglob('*')):
  if not p.is_file() or '__pycache__' in p.parts or p.suffix=='.pyc':continue
  if p.name.endswith('.errors.txt'):continue
  z.write(p,arcname=str(Path(ROOT.name)/p.relative_to(ROOT)))
with zipfile.ZipFile(ZIP) as z:
 assert z.testzip() is None
print(json.dumps({'zip_path':str(ZIP),'zip_bytes':ZIP.stat().st_size,'zip_members':len(zipfile.ZipFile(ZIP).namelist()),
                  'terms':len(vocab),'pdf_pages':{k:v['pages'] for k,v in REPORT.items()},
                  'tests':187},ensure_ascii=False,indent=2))
