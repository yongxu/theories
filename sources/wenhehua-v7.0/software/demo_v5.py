"""Reproducible v5 examples. Run from software/: PYTHONPATH=. python demo_v5.py"""
from __future__ import annotations
from collections import Counter
import json
from wenhehua.lineage import (
    TSet,TMap,Span,compose_spans,interchanger,example_interchange,
    identity_span,pullback,pushout
)

out={'version':'v5.0','semantics':'finite typed sets; correspondence witnesses, not proven physical identity'}
for full,label in [(True,'certified_shared_seam'),(False,'untraced_cross_side_handoff')]:
    a,b=example_interchange(full)
    comp=interchanger(a,b)
    out[label]={
        'local_then_global_witnesses':len(comp.horizontal_after_vertical.witness),
        'global_then_temporal_witnesses':len(comp.vertical_after_horizontal.witness),
        'comparison_map':dict(comp.comparison.mapping),
        'comparison_invertible':comp.invertible,
        'extra_formal_global_paths':comp.extra_mixed_histories,
    }
a=TSet.of(a='T');b=TSet.of(b1='T',b2='T');c=TSet.of(c='T')
w1=TSet.of(x='T',y='T');w2=TSet.of(p='T',q='T')
s1=Span(a,b,w1,TMap(w1,a,{'x':'a','y':'a'}),TMap(w1,b,{'x':'b1','y':'b2'}))
s2=Span(b,c,w2,TMap(w2,b,{'p':'b1','q':'b2'}),TMap(w2,c,{'p':'c','q':'c'}))
s=compose_spans(s1,s2)
out['two_distinct_routes_same_endpoints']={
    'full_provenance_path_count':len(s.witness),
    'boolean_relation_pair_count':len(set((s.to_before(z),s.to_after(z)) for z in s.witness.keys())),
    'witnesses':s.witness.keys()
}
print(json.dumps(out,ensure_ascii=False,indent=2))
