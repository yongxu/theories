// The browser copy of the laws reproduces the numbers FeedbackAtlas.lean checks by decide.
const test=require('node:test'),assert=require('node:assert/strict');
require('../src/learning.js');
const M=globalThis.atlasLearning,q=p=>M.exact(p.reading.q);
const run=(a,m,plan,o={})=>plan.reduce((p,action)=>M.step(p,{action,...o}).pair,[M.initial(a),M.initial(m)]);
test('example_readings and same_lapse_different_updates',()=>{
 assert.deepEqual(['short','long','guarded'].map(h=>[q(M.initial(h)),M.initial(h).reading.c]),[['3/4',4],['11/12',12],['4/27',2]]);
 const s=M.learn(M.initial('short').reading,'defensive'),l=M.learn(M.initial('long').reading,'defensive');
 assert.deepEqual([M.exact(s.q),s.c,M.exact(l.q),l.c],['3/5',3,'11/13',7]);
});
test('guarded_reading_is_revisable and defense_keeps_confidence_low',()=>{
 assert.equal(M.exact(M.learn(M.initial('guarded').reading,'constructive').q),'35/81');
 let b=M.seed().reading;for(let n=0;n<40;n++){b=M.learn(b,'defensive');assert.ok(b.c<=2);}
 b=M.initial('long').reading;for(let n=0;n<6;n++){const next=M.learn(b,'defensive');assert.ok(next.c<=b.c);b=next;}
});
test('joint examples: replies, interruption and pause',()=>{
 assert.equal(M.step([M.initial('short'),M.initial('short')],{action:'lapse'}).event.reply,'defensive');
 assert.equal(M.step([M.initial('short'),M.initial('long')],{action:'lapse'}).event.reply,'constructive');
 assert.deepEqual(run('short','short',['lapse']).map(q)[0],'3/5');
 assert.deepEqual(run('short','long',['lapse']).map(q)[0],'4/5');
 const first=M.step([M.initial('long'),M.initial('short')],{action:'lapse'}).pair,second=M.step(first,{action:'habitual'});
 assert.deepEqual(second.event,{first:'constructive',reply:'constructive'});assert.equal(q(second.pair[1]),'7/10');
 const pause=M.step([M.initial('short'),M.initial('short')],{action:'lapse',responderGuard:'pause'});
 assert.equal(pause.event.reply,'pause');assert.equal(q(pause.pair[0]),'3/4');
});
test('credibility_is_separate and same_explanation_different_effect',()=>{
 const r=M.initial('short','reliable').reading,m=M.initial('short','misleading').reading;
 assert.deepEqual([M.exact(r.q),M.exact(m.q),M.exact(r.r),M.exact(m.r)],['3/4','3/4','3/4','1/4']);
 const dr=M.learn(r,'defensive'),dm=M.learn(m,'defensive');
 assert.deepEqual([M.exact(dr.q),M.exact(dm.q)],['3/5','3/5']);
 assert.deepEqual([M.exact(M.learn(dr,'explanation').q),M.exact(M.learn(dm,'explanation').q)],['17/25','41/65']);
 assert.deepEqual(M.learn(dr,'explanation',false),dr);
});
test('§3: every reading reached misreads some admitted situation; examples err both ways',()=>{
 assert.equal(M.readsPersonal(M.learn(M.initial('short').reading,'defensive')),true);
 assert.equal(M.readsPersonal(M.learn(M.initial('long').reading,'defensive')),false);
 const situations=[[false,false],[false,true],[true,false],[true,true]];
 const walk=(pair,depth)=>{
  for(const p of pair){const v=M.readsPersonal(p.reading);assert.ok(situations.some(([,personal])=>personal!==v));
   for(const s of[p.reading.q,p.reading.r])assert.ok(s.n>=0n&&s.n<=s.d&&s.d>0n);}
  if(!depth)return;
  for(const action of['lapse','cooperate','explain','habitual'])for(const responderGuard of['defend','pause']){
   const next=M.step(pair,{action,responderGuard}).pair;
   next.forEach((p,i)=>assert.deepEqual(p.record.slice(1),pair[i].record));walk(next,depth-1);}
 };
 for(const a of['short','long','guarded'])for(const m of['short','long','guarded'])walk([M.initial(a),M.initial(m)],3);
 assert.throws(()=>M.step([M.initial(),M.initial()],{action:'invented'}),/Unknown/);
});
