// Exact rational mirror of FeedbackAtlas.lean §2–§3. Fractions are kept reduced here and
// unreduced in Lean; values agree because both compare by cross multiplication.
(() => {
  const gcd=(a,b)=>b===0n?a:gcd(b,a%b);
  function share(n,d=1n){n=BigInt(n);d=BigInt(d);if(d<=0n||n<0n||n>d)throw Error('Invalid share');const g=gcd(n,d);return {n:n/g,d:d/g};}
  // weighted(w,v,p,y) = (w p + v y)/(w + v); w is a positive count, v a count or a share.
  const weighted=(w,v,p,y)=>{w=typeof w==='object'?w:{n:BigInt(w),d:1n};v=typeof v==='object'?v:{n:BigInt(v),d:1n};
    return share(w.n*v.d*p.n*y.d+v.n*w.d*y.n*p.d,(w.n*v.d+v.n*w.d)*p.d*y.d);};
  const zero=share(0),one=share(1),half=share(1,2),probe=share(2,3);
  const halve=c=>Math.floor(c/2);
  const SIGNALS=['constructive','defensive','explanation','checkedReliable','checkedMisleading','pause'];
  function learn(b,s,fresh=true){
    if(!SIGNALS.includes(s))throw Error('Unknown signal: '+s);
    if(s==='constructive')return {...b,q:weighted(b.c,1,b.q,one),c:b.c+1};
    if(s==='defensive')return {...b,q:weighted(b.c,1,b.q,zero),c:halve(b.c)+1};
    if(s==='explanation')return fresh?{...b,q:weighted(b.c,b.r,b.q,one)}:{...b};
    if(s==='checkedReliable')return {...b,r:weighted(b.k,1,b.r,one),k:b.k+1};
    if(s==='checkedMisleading')return {...b,r:weighted(b.k,1,b.r,zero),k:b.k+1};
    return {...b};
  }
  const observe=(p,s,fresh=true)=>({reading:learn(p.reading,s,fresh),record:[{signal:s,fresh},...p.record]});
  const seed=()=>({reading:{q:half,c:2,r:half,k:2},record:[]});
  const HISTORIES={short:['constructive','constructive'],long:Array(10).fill('constructive'),guarded:Array(3).fill('defensive')};
  const CHECKS={none:[],reliable:['checkedReliable','checkedReliable'],misleading:['checkedMisleading','checkedMisleading']};
  function initial(history='short',checks='none'){
    if(!HISTORIES[history]||!CHECKS[checks])throw Error('Unknown history');
    return [...HISTORIES[history],...CHECKS[checks]].reduce((p,s)=>observe(p,s),seed());
  }
  const atLeast=(t,q)=>t.n*q.d<=q.n*t.d;
  const choose=(b,guard='defend',threshold=probe)=>atLeast(threshold,b.q)?'constructive':guard==='pause'?'pause':'defensive';
  // §3: a guarded reply reads the terse remark as personal.
  const readsPersonal=(b,guard='defend',threshold=probe)=>choose(b,guard,threshold)!=='constructive';
  // The initiator's move for each initiative; habit consults its own reading.
  const FIRST={lapse:()=>'defensive',cooperate:()=>'constructive',explain:()=>'explanation',habitual:(b,guard)=>choose(b,guard)};
  function step(pair,input){
    if(!Object.hasOwn(FIRST,input.action))throw Error('Unknown initiative');
    const first=FIRST[input.action](pair[0].reading,input.initiatorGuard);
    const responder=observe(pair[1],first,input.fresh!==false);
    const reply=choose(responder.reading,input.responderGuard);
    return {pair:[observe(pair[0],reply),responder],event:{first,reply}};
  }
  const ratio=p=>Number(p.n)/Number(p.d),exact=p=>p.n+'/'+p.d;
  globalThis.atlasLearning={share,weighted,learn,observe,seed,initial,choose,readsPersonal,step,ratio,exact,probe};
})();
