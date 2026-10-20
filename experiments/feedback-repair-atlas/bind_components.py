#!/usr/bin/env python3
"""Write components.json: the excerpts the page shows.

Own excerpts are line ranges of FeedbackAtlas.lean, found by declaration name; build.py reads them
from the verified file. Core excerpts are snapshots taken with `git show` at the core commit named in
model/atlas-verification.json, so a later core landing leaves them exact. Rerun after verify_atlas.py.
"""
import json,re,subprocess
from pathlib import Path
A=Path(__file__).resolve().parent; ROOT=A.parents[1]
F='experiments/feedback-repair-atlas/model/FeedbackAtlas.lean'
lines=(ROOT/F).read_text().splitlines()
def block(names):
    out=[]
    for n in names:
        i=next(k for k,l in enumerate(lines) if re.match(r'(theorem|def|structure|inductive|abbrev|instance) '+re.escape(n)+r'\b',l))
        s=i
        while s>0 and lines[s-1].strip(): s-=1
        e=i
        while e+1<len(lines) and lines[e+1].strip(): e+=1
        out.append((s+1,e+1))
    return min(a for a,_ in out),max(b for _,b in out)
own=[
 ('remark',1,'The remark and its four situations',['Situation','possibilities','remark','taskEvidence'],'The situations and evidence functions are supplied.'),
 ('no-judge',1,'What the wording cannot settle',['no_personal_judge_from_remark','task_error_does_not_settle_personal'],'Uses the core law no_judge_of_merged.'),
 ('permits',1,'Which replies the evidence permits',['EvidencePermits','Common','request_without_verdict','cannot_always_accept_fault','cannot_always_name_personal'],'The permission rules are supplied; the inquiry is the core one-step judgment.'),
 ('reading',2,'A reading of the other end',['Reading','Signal'],'Expectation, confidence and credibility are model quantities, not measurements.'),
 ('learn',2,'The update laws',['learn'],'The laws are supplied and not fitted; EVIDENCE.md lists what motivates each.'),
 ('defense',2,'Defense keeps a reading revisable',['defense_does_not_consolidate','halve_small','defense_keeps_confidence_low'],'Holds for every reading and every run length, under the supplied law.'),
 ('exchange',2,'How one exchange forms',['form','step','readingStep'],'Both ends change by the one move the whole forms (core wholeNext).'),
 ('readout',2,'Readings evolve without the record',['step_commutes','readings_evolve_without_record'],'The records do no work in these laws; the readings are self-contained.'),
 ('examples',2,'Worked examples',['short','long','guarded','same_lapse_different_updates','responder_history_changes_reply','initiator_history_interrupts_returned_defense'],'Synthetic histories; every number is checked by decide.'),
 ('link',3,'The link: a reply reads the remark',['readsPersonal','every_reading_misreads_some_case','no_reading_settles_personal','every_course_misreads_some_case'],'Holds for every reading, hence every course of exchanges.'),
]
comps=[]
for cid,part,label,names,boundary in own:
    a,b=block(names); comps.append(dict(id=cid,part=part,label=label,path=F,line=a,end=b,boundary=boundary))
commit=json.loads((A/'model/atlas-verification.json').read_text())['core']['checked_against_commit']
core='experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/'
for cid,label,path,start,end,boundary in [
 ('core-merged','Core: no judge through a merging reduction',core+'Readout.lean',287,292,'§1 and §3 apply it.'),
 ('core-whole','Core: the coupled whole',core+'MoveFormation.lean',348,351,'§2 builds each exchange with it.'),
 ('core-fold','Core: a commuting reduction commutes with every course',core+'Readout.lean',114,121,'§2 applies it to readings.')]:
    text=subprocess.check_output(['git','show',f'{commit}:{path}'],cwd=ROOT,text=True).splitlines()
    comps.append(dict(id=cid,part=0,label=label,path=path,commit=commit,line=start,end=end,boundary=boundary,code='\n'.join(text[start-1:end])))
(A/'components.json').write_text(json.dumps({'components':comps},indent=1,ensure_ascii=False)+'\n')
for c in comps: print(c['id'],c['line'],c['end'])
