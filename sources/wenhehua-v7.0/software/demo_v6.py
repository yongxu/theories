"""Run from software/: PYTHONPATH=. python demo_v6.py"""
import json
from wenhehua.semantic_bridges import demo_data
from wenhehua.lineage import example_interchange, interchanger

if __name__ == '__main__':
    d=demo_data()
    for strong in (True, False):
        x,y=example_interchange(strong)
        comp=interchanger(x,y)
        d['lineage_comparison_' + ('strong' if strong else 'lax')]= {
            'invertible': comp.invertible,
            'local_paths': len(comp.horizontal_after_vertical.witness),
            'global_paths': len(comp.vertical_after_horizontal.witness),
            'extra_global_paths': comp.extra_mixed_histories
        }
    print(json.dumps(d, ensure_ascii=False, indent=2, sort_keys=True))
