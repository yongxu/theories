#!/usr/bin/env python3
"""Source-bound fresh kernel check; saves failed as well as successful attempts."""
from datetime import datetime, timezone
import hashlib,json,os,re,subprocess,tempfile,time
from pathlib import Path
HERE=Path(__file__).resolve().parent
REPO=next(p for p in HERE.parents if (p/'AGENTS.md').exists())
FORMAL=HERE.parent/'formal'
CORE=REPO/'experiments/integrated-correction/general-framework/generative-basis/lean'
AUDIT=re.compile(r"'([^']+)' (?:does not depend on any axioms|depends on axioms: \[([^\]]*)\])")
def sha(b):return hashlib.sha256(b).hexdigest()
def main():
    inherited_bytes=(FORMAL/'verification.json').read_bytes()
    inherited=json.loads(inherited_bytes)
    assert inherited['status']=='passed'
    compiler=Path(inherited['compiler_binary'])
    assert sha(compiler.read_bytes())==inherited['compiler_sha256']
    version=subprocess.check_output([str(compiler),'--version'],text=True).strip()
    assert 'version 4.29.1,' in version
    paths={'GenerativeCore':CORE/'GenerativeCore.lean',
           'FormedSelection':FORMAL/'FormedSelection.lean',
           'FormationRoot':FORMAL/'FormationRoot.lean',
           'ConsequenceTransmission':HERE/'ConsequenceTransmission.lean'}
    frozen={n:p.read_bytes() for n,p in paths.items()}
    for row in inherited['modules']:
        if row['module'] in paths:
            assert sha(frozen[row['module']])==row['source_sha256'],row['module']
    checker=Path(__file__).read_bytes()
    seen={'Std'}
    for n,b in frozen.items():
        s=b.decode()
        assert not re.search(r'\b(sorry|admit|native_decide|unsafe)\b',s),n
        assert not re.search(r'^\s*(axiom|constant|opaque)\s',s,re.M),n
        assert set(re.findall(r'^import (\S+)$',s,re.M))<=seen,n
        if n=='ConsequenceTransmission':
            declared=re.findall(r'^theorem (\w+)',s,re.M)
            audited=[x.split('.')[-1] for x in re.findall(r'^#print axioms (\S+)$',s,re.M)]
            assert len(declared)==len(audited) and set(declared)==set(audited)
        seen.add(n)
    attempt=HERE/'checks'/str(time.time_ns());attempt.mkdir(parents=True)
    for n,b in frozen.items():(attempt/(n+'.lean')).write_bytes(b)
    (attempt/'check.py').write_bytes(checker)
    inputs={n:{'source':str(paths[n].relative_to(REPO)),'sha256':sha(b)} for n,b in frozen.items()}
    (attempt/'inputs.json').write_text(json.dumps(inputs,indent=2)+'\n')
    rows=[]
    with tempfile.TemporaryDirectory(prefix='generative-evolution-') as td:
        build=Path(td)
        for n,b in frozen.items():(build/(n+'.lean')).write_bytes(b)
        env=dict(os.environ,LEAN_PATH=str(build))
        for n,b in frozen.items():
            try:
                result=subprocess.run([str(compiler),'-s65536','-o',n+'.olean',n+'.lean'],cwd=build,env=env,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=240)
            except subprocess.TimeoutExpired as e:
                output=e.stdout or '';output=output.decode(errors='replace') if isinstance(output,bytes) else output
                result=subprocess.CompletedProcess([],124,output+'\nTimeout after 240s\n')
            log=attempt/(n+'.txt');log.write_text(result.stdout)
            requested=re.findall(r'^#print axioms (\S+)$',b.decode(),re.M)
            audits={q:sorted(a.strip() for a in deps.split(',') if a.strip()) for q,deps in AUDIT.findall(result.stdout)}
            clean=result.returncode==0 and 'warning:' not in result.stdout and len(audits)==len(requested)
            clean=clean and all(q==r or q.endswith('.'+r) for q,r in zip(audits,requested))
            clean=clean and all(set(a)<={'propext','Quot.sound','Classical.choice'} for a in audits.values())
            rows.append({'module':n,'source':str(paths[n].relative_to(REPO)),'sha256':sha(b),'new':n=='ConsequenceTransmission','passed':clean,'exit_code':result.returncode,'axioms_by_declaration':audits,'log':str(log.relative_to(HERE)),'log_sha256':sha(log.read_bytes())})
            print(json.dumps({'module':n,'passed':clean,'audits':len(audits)}),flush=True)
            if not clean:print(result.stdout,flush=True);break
    unchanged=all(p.read_bytes()==frozen[n] for n,p in paths.items()) and Path(__file__).read_bytes()==checker and (FORMAL/'verification.json').read_bytes()==inherited_bytes
    passed=len(rows)==len(paths) and all(r['passed'] for r in rows) and unchanged
    record={'status':'passed' if passed else 'failed','checked_at_utc':datetime.now(timezone.utc).isoformat(),'compiler':str(compiler),'compiler_sha256':sha(compiler.read_bytes()),'version':version,'checker_sha256':sha(checker),'inherited_receipt_sha256':sha(inherited_bytes),'fresh_temporary_build':True,'inputs_unchanged':unchanged,'modules':rows,'new_audits':sum(len(r['axioms_by_declaration']) for r in rows if r['new']),'scope':'Finite weighted single-event copy/unchanged-count fraction criterion, guarded native access and faithful native response copying, explicit non-native transmission matrix and positive-channel reversal. No CTMC refinement, migration/loss drift, long-run trend, evolution of transmission architecture, biological liangzhi or ethical warrant.'}
    (attempt/'receipt.json').write_text(json.dumps(record,indent=2)+'\n')
    if passed:(HERE/'verification.json').write_text(json.dumps(record,indent=2)+'\n')
    print('RECEIPT '+str(attempt/'receipt.json'),flush=True)
    raise SystemExit(0 if passed else 1)
if __name__=='__main__':main()
