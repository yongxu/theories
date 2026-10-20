const test = require('node:test');
const assert = require('node:assert/strict');
require('../src/dynamics.js');
const {compute,learned}=globalThis.feedbackDynamics;
const C='clarify',H='habitual',D='defend';
const run=(plan,overrides={})=>compute({plan,receptive:true,credible:true,penalty:2,...overrides});
const end=(plan,overrides)=>run(plan,overrides).at(-1).q;

test('concrete courses agree with the named Lean application theorems',()=>{
  assert.deepEqual(run([C,C,C,C,C]).map(s=>s.q),[[0,0],[0,1],[0,2],[1,3],[2,4],[3,5]]);
  assert.deepEqual(end([C,C,C,D]),[0,1]); // early_lapse
  assert.deepEqual(end([C,C,C,D,C,H,H,H]),[3,5]); // early_lapse_repair
  assert.deepEqual(end([C,C,C,C,C,D]),[1,3]); // buffered_lapse
  assert.deepEqual(end([C,C,C,C,C,D,H,H]),[3,5]); // buffered_lapse_recovers
  assert.deepEqual(end([C,C,C,C,C,D,D]),[0,1]); // repeated_lapses_remove_buffer
  assert.deepEqual(end([C,C,C,C,C,D],{penalty:6}),[0,0]); // larger_setback_counterexample
});

test('a failed retry is preserved when the required conditions are absent',()=>{
  assert.deepEqual(end([C,C,C,C,C],{receptive:false}),[0,0]);
  assert.deepEqual(end([C,C,C,C,C],{credible:false}),[0,5]);
  assert.deepEqual(end([C,C,C,D,...Array(20).fill(H)]),[0,0]);
});

test('a lapse retains the past; order matters and negative tallies are impossible',()=>{
  const history=run([C,C,C,D]);
  assert.deepEqual(history[4].a.slice(1),history[3].a);
  assert.deepEqual(history[4].m.slice(1),history[3].m);
  assert.equal(learned(['supporting','defensive'],2),1);
  assert.equal(learned(['defensive','supporting'],2),0);
});

test('all response plans through length five preserve histories and tally projection',()=>{
  let plans=[[]];
  for(let depth=0;depth<=5;depth++){
    for(const plan of plans)for(const receptive of [false,true])for(const credible of [false,true]){
      for(const penalty of [2,6]){
        const states=run(plan,{receptive,credible,penalty});
        states.forEach((s,i)=>{
          assert.equal(s.a.length,1+i);assert.equal(s.m.length,2+i);
          assert.deepEqual(s.q,[learned(s.a,penalty),learned(s.m,penalty)]);
          assert.ok(s.q.every(n=>Number.isInteger(n)&&n>=0));
        });
      }
    }
    plans=plans.flatMap(p=>[C,H,D].map(c=>[...p,c]));
  }
});
