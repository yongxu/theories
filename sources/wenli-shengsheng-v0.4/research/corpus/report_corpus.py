"""Verify frozen source/labels and reproduce descriptive pilot counts (stdlib)."""
from collections import Counter
from pathlib import Path
import hashlib,json,sys

R=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()

def calculate():
    corpus=json.loads((R/'corpus.json').read_text())
    protocol=json.loads((R/'protocol.json').read_text())
    files={x:json.loads((R/f'annotation_{x}.json').read_text()) for x in ('a','b')}
    units=corpus['units']; ids={u['unit_id'] for u in units}
    assert len(units)==len(ids)==55
    checks=0
    assert set(corpus['counts'])=={s['source'] for s in protocol['scope']};checks+=1
    for spec in protocol['scope']:
        group=[u for u in units if u['source_id']==spec['source']]
        assert len(group)==corpus['counts'][spec['source']]==spec['expected_units'];checks+=1
        assert [u['position'] for u in group]==list(range(1,spec['expected_units']+1));checks+=1
        assert [u['unit_id'] for u in group]==[spec['source']+f'{n:02d}' for n in range(1,spec['expected_units']+1)];checks+=1
        assert len({u['locator'] for u in group})==len(group);checks+=1
    for source in corpus['sources']:
        assert sha(R/source['raw_file'])==source['raw_sha256'];checks+=1
    for u in units:
        assert hashlib.sha256(u['text'].encode()).hexdigest()==u['text_sha256'];checks+=1
    indexes={}
    for key,d in files.items():
        assert d['corpus_sha256']==sha(R/'corpus.json');checks+=1
        assert d['protocol_sha256']==sha(R/'protocol.json');checks+=1
        entries=d['annotations']; index={e['unit_id']:e for e in entries}
        assert len(entries)==len(index)==55 and set(index)==ids;checks+=1
        for u in units:
            e=index[u['unit_id']]
            assert e['label'] in ('E','C','N') and e['evidence_span'] in u['text'];checks+=1
            assert all(k in e for k in protocol['required_annotation']);checks+=1
        indexes[key]=index
    def table(group):
        count=lambda key:{k:sum(indexes[key][u['unit_id']]['label']==k for u in group) for k in ('E','C','N')}
        agree=sum(indexes['a'][u['unit_id']]['label']==indexes['b'][u['unit_id']]['label'] for u in group)
        joint={k:sum(indexes['a'][u['unit_id']]['label']==indexes['b'][u['unit_id']]['label']==k for u in group) for k in ('E','C','N')}
        return {'units':len(group),'a':count('a'),'b':count('b'),'exact_agreement':agree,'disagreements':len(group)-agree,'joint_labels':joint}
    differing=[]
    for u in units:
        a=indexes['a'][u['unit_id']];b=indexes['b'][u['unit_id']]
        if a['label']!=b['label']:
            differing.append({'unit_id':u['unit_id'],'a':a['label'],'b':b['label'],'a_reason':a['reason'],'b_reason':b['reason']})
    output={'version':'v0.4-pilot-1','protocol_sha256':sha(R/'protocol.json'),'corpus_sha256':sha(R/'corpus.json'),
      'annotation_sha256':{k:sha(R/f'annotation_{k}.json') for k in files},
      'total':table(units),'by_source':{s['source_id']:table([u for u in units if u['source_id']==s['source_id']]) for s in corpus['sources']},
      'disagreements':differing,'integrity_checks':checks,
      'interpretation':'Unit-level presence of at least one schema, not lexical coverage or proportion of fully explained content. AI annotations, purpose-selected contiguous excerpts; no population estimate or human-learning claim.'}
    return output,corpus,indexes

def render(result,corpus,indexes):
    t=result['total']
    names={s['source_id']:s['title'] for s in corpus['sources']}
    lines=['# 固定文本范围的关系图式试点','',
    '本试点逐项考察四组连续文本的55个单元，判断其中是否至少有一处可识别的关系、过程或条件图式。两份AI标注在同一冻结准则下分别完成，再比较分歧。它提供可复查的文本分母，不提供古典词汇总体覆盖率。','',
    '两份标注分别判出36个与31个明确关系单元；其中30个双方均判明确，12个双方均判非关系或未解决，4个双方均判需语境解释，另9个存在分歧。此处“非关系”只指未满足本试点的结构判据，不否定相应思想内容。','',
    '## 文本与统计单位','',
    '| 文本范围 | 单元 | 分节及版本 |','|---|---:|---|',
    '| 《老子》王弼本经文第一至八章 | 8 | 网页章界；经文与王弼注分开，只取经文。 |',
    '| 《论语 学而》全篇 | 16 | 一之一至一之十六；正文保留原字形，异文悬浮注释不并入。 |',
    '| 《易传 说卦》全篇 | 11 | 网页传统十一章；每章包含其完整正文。 |',
    '| 《墨子 经上》开头二十条 | 20 | 从“故，所得而後成也”起，按网页正文句号连续切分；项目序号不冒充原书统一条号。 |','',
    '范围按篇章和连续序号固定，没有删除不适配单元。四部经典及开头片段的选择仍受既有研究影响，不是随机或代表性抽样。各单元长度也显著不同：一整章出现一处关系，与一句短训释出现一处关系，不能当成同等长度的词汇覆盖。','',
    '## 判定方法','',
    '- **E 明确关系**：原文至少有一处两语义角色、两阶段或条件与结果，以及可辨识的联系。','- **C 语境候选**：有关系或过程线索，但需解释补足关键角色、关系或断言方式。','- **N 非关系或未解决**：孤立训释、单项性质、象征对配，或疑难字义尚不足以识别所要求的结构。','',
    '“乾为马”可以登记为象征对应，但本试点不因它能写成二元表就把它判成系统动力模型。反过来，定义内部若确有部分与整体、言与意等实质关系，仍可判E。规范、认识、描述和象征标签另存，不将规范转为自然因果。','',
    '标注者A与B分别锁定原标签；共享研究背景，未对经典背景盲化，亦非独立人类实验。原标签未按事后讨论覆盖。协议、文本、标注和原网页均保存哈希。','',
    '## 分文本结果','',
    '| 文本 | 单元数 | A E C N | B E C N | 双方均E | 标签一致 | 分歧 |','|---|---:|---|---|---:|---:|---:|']
    for k,d in result['by_source'].items():
        vals=lambda f:' / '.join(str(d[f][x]) for x in 'ECN')
        lines.append(f"| {names[k]} | {d['units']} | {vals('a')} | {vals('b')} | {d['joint_labels']['E']} | {d['exact_agreement']} | {d['disagreements']} |")
    lines += ['',f"合计标签一致{t['exact_agreement']}/55。标签一致不等于所选证据跨度、角色或解释一致；例如L01、A01、Y05的两份标注使用了不同证据跨度。‘双方均E’是锁定后直接计算的交集，不是由人类复核获得的金标准；不据此给‘large part’设事后阈值。",'',
    '## 分歧揭示的边界','',
    '九处分歧主要集中于三个判据：省略的作用对象能否由语法直接补出；一个及物动作是否已构成足够独立的关系图式；紧邻的两个分句是否已经断言因果或条件联系。它们说明“可组合”的操作定义仍需要进一步细化，而不能靠单一标注者给出漂亮比例。','',
    '| 单元 | A | B | 分歧焦点 |','|---|---|---|---|']
    focus={'L04':'消解动作的施事、受事及道的比喻是否已足够明确。','A09':'慎终追远与民德归厚的并置是否已明确断言联系。','Y04':'无本单元先行词的“之”是否足以充当可复用角色。','Y10':'索得次序是否已形成过程，或仍须解释“索”。','M05':'“接”提供关系候选，还是仍只是孤立训释。','M13':'“利亲”的隐含施事与明确受益者是否足够构成图式。','M15':'“自作”的施事线索是否足以超出训释。','M18':'“不为所非”是否已给出稳定的评价与行为约束。','M20':'“所以敢”是根据关系，还是需先解决属性释义。'}
    for x in result['disagreements']:lines.append(f"| {x['unit_id']} | {x['a']} | {x['b']} | {focus[x['unit_id']]} |")
    lines += ['',
    '本版保留九处分歧而不制造一致结论。下一轮应在未参与本次判定的新材料上检验更细准则；不能先调整本次规则至两人一致，再把提高的一致率说成独立验证。','',
    '## 可得结论','',
    '连续文本中确有可指认的关系与条件结构，且它们并不限于直接说“生”“变”的段落，例如《学而》的情境规范、观察方向与推知关系。另一方面，《说卦》的单项训释与物象表，以及《墨经》的若干短定义，不能不加区分地当成小型动力理论。','',
    '这些结果推进了文本层H1的可复查性。它们没有测量单字或复合词在古典词汇中的比例，没有判定每个E单元的全部内容已经形式化，也没有检验相对于一般建模的学习或预测增益。','',
    '## 全部单元的标签与证据','',
    '| 单元 | A | B | A的证据跨度 | B的证据跨度 |','|---|---|---|---|---|']
    for u in corpus['units']:
        i=u['unit_id'];a=indexes['a'][i];b=indexes['b'][i]
        lines.append(f"| {i} | {a['label']} | {b['label']} | {a['evidence_span']} | {b['evidence_span']} |")
    lines += ['','## 来源与复算','']
    for source in corpus['sources']:
        lines.append(f"- [{source['title']}]({source['permalink']})；网页修订号{source['revision_id']}，本次只采用原典正文，页面传统作者栏不作为成书年代证据。")
    lines += ['', '数据见同目录的 `corpus.json`、`protocol.json`、`annotation_a.json`、`annotation_b.json` 与 `pilot_results.json`。运行 `python3 report_corpus.py --check` 可以检查原网页、单元与标注哈希、证据跨度、范围完整性及统计结果。复算只检验记录一致性，不替代语义判断。','']
    return '\n'.join(lines)

def main():
    result,corpus,indexes=calculate()
    text=render(result,corpus,indexes)
    result_path=R/'pilot_results.json'; report_path=R/'固定语料覆盖试点.md'
    if '--check' in sys.argv:
        assert json.loads(result_path.read_text())==result
        assert report_path.read_text()==text
    else:
        result_path.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
        report_path.write_text(text)
    print(json.dumps({'pass':True,'units':result['total']['units'],'agreement':result['total']['exact_agreement'],'joint_E':result['total']['joint_labels']['E'],'integrity_checks':result['integrity_checks']},ensure_ascii=False))

if __name__=='__main__':main()
