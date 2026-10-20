const test=require('node:test'),assert=require('node:assert/strict');
require('../src/research.js');
const M=globalThis.researchDynamics,ex=p=>M.exact(p.belief.q);
const run=(a,m,plan,options={})=>plan.reduce((p,action)=>M.step(p,{action,...options}).pair,[M.initial(a),M.initial(m)]);
test('same expectation, different confidence and lapse updates match Lean',()=>{
 const a=M.initial('short'),b=M.initial('long');
 assert.equal(ex(a),'3/4');assert.equal(ex(b),'3/4');assert.equal(a.belief.c,4);assert.equal(b.belief.c,16);
 assert.equal(M.exact(M.learn(a.belief,'defensive').q),'3/5');
 assert.equal(M.exact(M.learn(b.belief,'defensive').q),'12/17');
});
test('both partner histories and pause alternatives match the Lean examples',()=>{
 assert.deepEqual(run('short','short',['lapse']).map(ex),['3/5','3/5']);
 assert.deepEqual(run('short','long',['lapse']).map(ex),['4/5','12/17']);
 assert.deepEqual(run('long','short',['lapse','habitual']).map(ex),['13/18','2/3']);
 assert.deepEqual(run('short','short',['lapse'],{mayaRetaliates:false}).map(ex),['3/4','3/5']);
});
test('credibility affects reports, not direct observation; stale reports do not update',()=>{
 for(const [kind,expected] of [['high','31/47'],['low','25/41']]){
  const b=M.initial('short',kind).belief,d=M.learn(b,'defensive');
  assert.equal(M.exact(d.q),'3/5');
  const report=M.learn(d,'explanation');
  assert.equal(M.exact(report.q),expected);assert.equal(report.c,d.c);assert.deepEqual(report.r,d.r);
  assert.deepEqual(M.learn(d,'explanation',false),d);
 }
});
test('all four-action plans through length four retain histories and bounded shares',()=>{
 const walk=(pair,depth)=>{
  for(const p of pair)for(const v of[p.belief.q,p.belief.r])assert.ok(v.n>=0n&&v.n<=v.d&&v.d>0n);
  if(depth===0)return;
  for(const action of ['lapse','cooperate','explain','habitual'])for(const mayaRetaliates of [true,false]){
   const next=M.step(pair,{action,mayaRetaliates}).pair;
   next.forEach((p,i)=>{assert.deepEqual(p.history.slice(1),pair[i].history);assert.ok(p.belief.c>=pair[i].belief.c);});
   walk(next,depth-1);
  }
 };
 for(const a of['short','long'])for(const m of['short','long'])walk([M.initial(a),M.initial(m)],4);
 assert.throws(()=>M.step([M.initial(),M.initial()],{action:'invented'}),/Unknown/);
});
