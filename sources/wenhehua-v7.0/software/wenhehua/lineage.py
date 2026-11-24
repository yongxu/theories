"""v5: finite typed-set seam histories with provenance-preserving lax comparison.

Mathematical scope: FINITE TYPED SETS, not general hypergraphs or a proven
changing-boundary double category. A seam-history step is compatible spans
for left, seam and right sets. Horizontal glue is pushout and temporal
composition is pullback; the canonical comparison is an explicitly computed
map from (vertical local then horizontal) to (horizontal then vertical).

Non-injective spans are ALLOWED: a witness denotes a *correspondence event*,
not a certificate that one physical individual persists unchanged.
"""
from __future__ import annotations
from collections import Counter
from dataclasses import dataclass
import json
from typing import Mapping

class LineageError(ValueError):
    pass


def pair_key(a: str, b: str) -> str:
    return json.dumps([a,b], ensure_ascii=False, separators=(',',':'))


def unpack_pair(s: str) -> tuple[str,str]:
    v=json.loads(s)
    if not isinstance(v,list) or len(v)!=2 or any(not isinstance(x,str) for x in v):
        raise LineageError('malformed pair witness')
    return v[0],v[1]

@dataclass(frozen=True)
class TSet:
    """Immutable finite typed set. Identifiers are local to each set."""
    items: tuple[tuple[str,str],...]
    def __post_init__(self):
        if len({k for k,_ in self.items})!=len(self.items):
            raise LineageError('duplicate set identifier')
        if any(not k or not t for k,t in self.items):
            raise LineageError('empty identifier or type')
    @classmethod
    def of(cls, **items: str) -> 'TSet':
        return cls(tuple(sorted(items.items())))
    @property
    def types(self): return dict(self.items)
    def __len__(self): return len(self.items)
    def keys(self): return list(self.types)

@dataclass(frozen=True)
class TMap:
    domain: TSet
    codomain: TSet
    mapping: Mapping[str,str]
    def __post_init__(self):
        d=self.domain.types;c=self.codomain.types
        if set(self.mapping)!=set(d):
            raise LineageError('map must be total over its domain')
        for k,v in self.mapping.items():
            if v not in c or d[k]!=c[v]:
                raise LineageError(f'nonexistent target or type mismatch: {k}->{v}')
    def __call__(self,k:str)->str:return self.mapping[k]
    @property
    def injective(self)->bool:return len(set(self.mapping.values()))==len(self.mapping)
    @property
    def surjective(self)->bool:return set(self.mapping.values())==set(self.codomain.types)
    @property
    def bijective(self)->bool:return self.injective and self.surjective


def identity(x:TSet)->TMap:return TMap(x,x,{a:a for a in x.keys()})

@dataclass(frozen=True)
class Pushout:
    apex:TSet
    left:TMap
    right:TMap


def pushout(j:TSet,l:TSet,r:TSet,jl:TMap,jr:TMap)->Pushout:
    if jl.domain!=j or jr.domain!=j or jl.codomain!=l or jr.codomain!=r:
        raise LineageError('cospan type mismatch')
    tokens=[('L',a) for a in l.keys()]+[('R',b) for b in r.keys()]
    parent={p:p for p in tokens}
    def find(x):
        while parent[x]!=x:
            parent[x]=parent[parent[x]];x=parent[x]
        return x
    def union(a,b):
        aa,bb=find(a),find(b)
        if aa!=bb:
            parent[max(aa,bb)]=min(aa,bb)
    for k in j.keys():
        union(('L',jl(k)),('R',jr(k)))
    groups={}
    for x in tokens: groups.setdefault(find(x),[]).append(x)
    label={}
    for group in groups.values():
        typ=(l.types if group[0][0]=='L' else r.types)[group[0][1]]
        if any((l.types if side=='L' else r.types)[k]!=typ for side,k in group):
            raise LineageError('mixed-type equivalence class')
        name='Q['+'|'.join(side+':'+k for side,k in sorted(group))+']'
        for token in group: label[token]=name
    a=TSet(tuple(sorted({(v,(l.types if token[0]=='L' else r.types)[token[1]]) for token,v in label.items()})))
    return Pushout(a,TMap(l,a,{k:label[('L',k)] for k in l.keys()}),
                       TMap(r,a,{k:label[('R',k)] for k in r.keys()}))

@dataclass(frozen=True)
class Pullback:
    object:TSet
    first:TMap
    second:TMap


def pullback(f:TMap,g:TMap)->Pullback:
    if f.codomain!=g.codomain:raise LineageError('pullback middle mismatch')
    pairs=[(pair_key(a,b),f.domain.types[a]) for a in f.domain.keys() for b in g.domain.keys() if f(a)==g(b)]
    obj=TSet(tuple(pairs))
    return Pullback(obj,TMap(obj,f.domain,{k:unpack_pair(k)[0] for k in obj.keys()}),
                    TMap(obj,g.domain,{k:unpack_pair(k)[1] for k in obj.keys()}))

@dataclass(frozen=True)
class Span:
    before:TSet
    after:TSet
    witness:TSet
    to_before:TMap
    to_after:TMap
    def __post_init__(self):
        if (self.to_before.domain!=self.witness or self.to_after.domain!=self.witness
            or self.to_before.codomain!=self.before or self.to_after.codomain!=self.after):
            raise LineageError('span legs inconsistent')
    def signature(self):
        """Complete isomorphism invariant for a finite typed span over FIXED endpoints."""
        return Counter((self.witness.types[w],self.to_before(w),self.to_after(w))
                       for w in self.witness.keys())


def identity_span(x:TSet)->Span:
    m=identity(x);return Span(x,x,x,m,m)


def compose_spans(first:Span, second:Span)->Span:
    if first.after!=second.before:raise LineageError('span composition middle mismatch')
    p=pullback(first.to_after,second.to_before)
    return Span(first.before,second.after,p.object,
      TMap(p.object,first.before,{w:first.to_before(p.first(w)) for w in p.object.keys()}),
      TMap(p.object,second.after,{w:second.to_after(p.second(w)) for w in p.object.keys()}))

@dataclass(frozen=True)
class SeamState:
    seam:TSet
    left:TSet
    right:TSet
    seam_to_left:TMap
    seam_to_right:TMap
    def __post_init__(self):
        if (self.seam_to_left.domain!=self.seam or self.seam_to_right.domain!=self.seam
            or self.seam_to_left.codomain!=self.left or self.seam_to_right.codomain!=self.right):
            raise LineageError('seam-state maps inconsistent')
    def glue(self)->Pushout:
        return pushout(self.seam,self.left,self.right,self.seam_to_left,self.seam_to_right)

@dataclass(frozen=True)
class SeamStep:
    old:SeamState
    new:SeamState
    left:Span
    seam:Span
    right:Span
    seam_to_left:TMap
    seam_to_right:TMap
    def __post_init__(self):
        if (self.left.before!=self.old.left or self.left.after!=self.new.left
           or self.right.before!=self.old.right or self.right.after!=self.new.right
           or self.seam.before!=self.old.seam or self.seam.after!=self.new.seam):
            raise LineageError('local histories do not match seam states')
        if (self.seam_to_left.domain!=self.seam.witness or self.seam_to_right.domain!=self.seam.witness
            or self.seam_to_left.codomain!=self.left.witness
            or self.seam_to_right.codomain!=self.right.witness):
            raise LineageError('history seam witness maps inconsistent')
        for w in self.seam.witness.keys():
            if self.left.to_before(self.seam_to_left(w))!=self.old.seam_to_left(self.seam.to_before(w)):
                raise LineageError('old-left square does not commute')
            if self.left.to_after(self.seam_to_left(w))!=self.new.seam_to_left(self.seam.to_after(w)):
                raise LineageError('new-left square does not commute')
            if self.right.to_before(self.seam_to_right(w))!=self.old.seam_to_right(self.seam.to_before(w)):
                raise LineageError('old-right square does not commute')
            if self.right.to_after(self.seam_to_right(w))!=self.new.seam_to_right(self.seam.to_after(w)):
                raise LineageError('new-right square does not commute')

@dataclass(frozen=True)
class HorizontalResult:
    span:Span
    from_left:TMap
    from_right:TMap


def horizontal(step:SeamStep)->HorizontalResult:
    old=step.old.glue();new=step.new.glue()
    witness=pushout(step.seam.witness,step.left.witness,step.right.witness,
                    step.seam_to_left,step.seam_to_right)
    def ambient_map(left_leg:TMap,right_leg:TMap,old_or_new:Pushout)->TMap:
        d={}
        for w in step.left.witness.keys():
            k=witness.left(w);v=old_or_new.left(left_leg(w))
            if k in d and d[k]!=v: raise LineageError('left history does not descend')
            d[k]=v
        for w in step.right.witness.keys():
            k=witness.right(w);v=old_or_new.right(right_leg(w))
            if k in d and d[k]!=v:raise LineageError('right history does not descend')
            d[k]=v
        return TMap(witness.apex,old_or_new.apex,d)
    span=Span(old.apex,new.apex,witness.apex,
              ambient_map(step.left.to_before,step.right.to_before,old),
              ambient_map(step.left.to_after,step.right.to_after,new))
    return HorizontalResult(span,witness.left,witness.right)


def vertical(first:SeamStep,second:SeamStep)->SeamStep:
    if first.new!=second.old:raise LineageError('local temporal seams do not match')
    lh=compose_spans(first.left,second.left)
    rh=compose_spans(first.right,second.right)
    sh=compose_spans(first.seam,second.seam)
    def into_side(a:TMap,b:TMap,witness:TSet, side:TSet)->TMap:
        d={}
        for w in witness.keys():
            w1,w2=unpack_pair(w)
            d[w]=pair_key(a(w1),b(w2))
        return TMap(witness,side,d)
    return SeamStep(first.old,second.new,lh,sh,rh,
      into_side(first.seam_to_left,second.seam_to_left,sh.witness,lh.witness),
      into_side(first.seam_to_right,second.seam_to_right,sh.witness,rh.witness))

@dataclass(frozen=True)
class Comparison:
    horizontal_after_vertical:Span
    vertical_after_horizontal:Span
    comparison:TMap
    def __post_init__(self):
        if (self.horizontal_after_vertical.before!=self.vertical_after_horizontal.before
           or self.horizontal_after_vertical.after!=self.vertical_after_horizontal.after):
            raise LineageError('comparison endpoint mismatch')
        for w in self.comparison.domain.keys():
            t=self.comparison(w)
            if (self.horizontal_after_vertical.to_before(w)!=self.vertical_after_horizontal.to_before(t)
                or self.horizontal_after_vertical.to_after(w)!=self.vertical_after_horizontal.to_after(t)):
                raise LineageError('comparison does not preserve boundary histories')
    @property
    def invertible(self): return self.comparison.bijective
    @property
    def extra_mixed_histories(self):
        return len(self.vertical_after_horizontal.witness)-len(set(self.comparison.mapping.values()))


def interchanger(first:SeamStep,second:SeamStep)->Comparison:
    h1=horizontal(first);h2=horizontal(second)
    global_temporal=compose_spans(h1.span,h2.span)
    local_then_glue=vertical(first,second)
    h_local=horizontal(local_then_glue)
    d={}
    for side,glue_inj,inj1,inj2 in (
      (local_then_glue.left,h_local.from_left,h1.from_left,h2.from_left),
      (local_then_glue.right,h_local.from_right,h1.from_right,h2.from_right)):
        for w in side.witness.keys():
            a,b=unpack_pair(w)
            k=glue_inj(w)
            v=pair_key(inj1(a),inj2(b))
            if k in d and d[k]!=v:raise LineageError('comparison not well-defined across seam')
            d[k]=v
    comparison=TMap(h_local.span.witness,global_temporal.witness,d)
    return Comparison(h_local.span,global_temporal,comparison)


def example_interchange(full:bool=True):
    """All stages same singleton seam, with 2 temporal steps.

    Full: both local and shared seam histories preserve the node in each step;
    comparison is bijective.
    Not full: first step retains only left event, second only right event,
    with NO common seam lineage: the global midpoint can create a mixed path.
    """
    j=TSet.of(j='T');l=TSet.of(l='T');r=TSet.of(r='T')
    state=SeamState(j,l,r,TMap(j,l,{'j':'l'}),TMap(j,r,{'j':'r'}))
    def history(x:TSet, yes:bool, label:str):
        if yes:
            w=TSet.of(**{label:'T'})
            k=x.keys()[0]
            return Span(x,x,w,TMap(w,x,{label:k}),TMap(w,x,{label:k}))
        w=TSet(())
        return Span(x,x,w,TMap(w,x,{}),TMap(w,x,{}))
    def step(i:int):
        if full: yes_l=yes_r=yes_j=True
        else: yes_l=i==1;yes_r=i==2;yes_j=False
        a=history(l,yes_l,f'left{i}');b=history(r,yes_r,f'right{i}')
        s=history(j,yes_j,f'seam{i}')
        sl={f'seam{i}':f'left{i}'} if yes_j else {}
        sr={f'seam{i}':f'right{i}'} if yes_j else {}
        return SeamStep(state,state,a,s,b,TMap(s.witness,a.witness,sl),TMap(s.witness,b.witness,sr))
    return step(1),step(2)
