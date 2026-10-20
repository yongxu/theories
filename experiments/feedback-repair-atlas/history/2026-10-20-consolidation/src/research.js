// Exact rational interpretation of ResearchInteractionTrial. No sampling law.
(() => {
  const gcd=(a,b)=>b===0n?a:gcd(b,a%b);
  function fraction(n,d=1n){n=BigInt(n);d=BigInt(d);if(d<=0n||n<0n||n>d)throw Error('Invalid share');const g=gcd(n,d);return {n:n/g,d:d/g};}
  const weighted=(c,p,v,y)=>fraction(c.n*p.n*v.d*y.d+v.n*y.n*c.d*p.d,(c.n*v.d+v.n*c.d)*p.d*y.d);
  // Weight fractions need not be shares: c is a positive natural evidence mass.
  const avg=(c,p,v,y)=>weighted({n:BigInt(c),d:1n},p,v,y);
  const zero=fraction(0),one=fraction(1),half=fraction(1,2),probe=fraction(2,3);
  function learn(b,s,fresh=true){
    if(s==='constructive'||s==='defensive')return {...b,q:avg(b.c,b.q,one,s==='constructive'?one:zero),c:b.c+1};
    if(s==='explanation'&&fresh)return {...b,q:avg(b.c,b.q,b.r,one)};
    if(s==='verifiedReliable'||s==='verifiedMisleading')return {...b,r:avg(1,b.r,one,s==='verifiedReliable'?one:zero)};
    if(s==='unresolved'||s==='explanation')return {...b};
    throw Error('Unknown signal: '+s);
  }
  const observe=(p,s,fresh=true)=>({belief:learn(p.belief,s,fresh),history:[{signal:s,fresh},...p.history]});
  function initial(kind='short',credibility='neutral'){
    if(!['short','long'].includes(kind)||!['neutral','high','low'].includes(credibility))throw Error('Unknown history');
    let p={belief:{q:half,c:2,r:half},history:[]};
    const events=kind==='short'?Array(2).fill('constructive'):[...Array(11).fill('constructive'),...Array(3).fill('defensive')];
    if(credibility!=='neutral')events.push(...Array(2).fill(credibility==='high'?'verifiedReliable':'verifiedMisleading'));
    for(const s of events)p=observe(p,s);
    return p;
  }
  const choose=(b,retaliate=true,threshold=probe)=>threshold.n*b.q.d<=b.q.n*threshold.d?'constructive':retaliate?'defensive':'unresolved';
  function step(pair,input){
    if(!['lapse','cooperate','explain','habitual'].includes(input.action))throw Error('Unknown initiative');
    const first=input.action==='lapse'?'defensive':input.action==='cooperate'?'constructive':input.action==='explain'?'explanation':choose(pair[0].belief,input.alexRetaliates!==false);
    const maya=observe(pair[1],first,input.fresh!==false);
    const reply=choose(maya.belief,input.mayaRetaliates!==false);
    return {pair:[observe(pair[0],reply),maya],event:{first,reply}};
  }
  const ratio=p=>Number(p.n)/Number(p.d),exact=p=>p.n+'/'+p.d;
  globalThis.researchDynamics={fraction,learn,observe,initial,choose,step,ratio,exact};
})();
