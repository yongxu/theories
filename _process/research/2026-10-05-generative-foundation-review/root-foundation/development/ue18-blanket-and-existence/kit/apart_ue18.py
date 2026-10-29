#!/usr/bin/env python3
"""UE18: register the module's sixteen apart roots in THEOREM-CONNECTIVITY-APART.json, each with a category and a
reason, as THEOREM-CONNECTIVITY.py --check reported them at UE18's landing (with UE19). Asserts each is absent before
and writes the register as it stands (entries appended, no other entry touched). Mirrors UE16's apart_ue16.py.
usage (from the checkout root of the landing worktree): python3 -B <kit>/apart_ue18.py"""
import json
from pathlib import Path

ROOT = Path.cwd()
PATH = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json'
M = 'Becoming.Blanket'
P = f'{M}.'
LAW = ('a law of every determined law of internal, sensory, active and external parts on any type; the base supplies '
       'no reading of its vocabulary, the join to the World proved for the threshold witness only (UE18)')
WEIGHTS = ('a law of every natural weighting of listed outcomes (the point and occupation weightings, conditioning on '
           'an outcome), an identity of counting with no world; the base supplies no reading of its vocabulary (UE18)')
WITNESS = 'a fact about one constructed model, the threshold witness: a supply draining by one, read by threshold (UE18)'
ROOTS = {
    P + 'Blanketed.external_through_blanket':
        ('general-structure', 'Blanketed.external_through_blanket: the external course fixed by its start and the '
                              'blanket\'s; ' + LAW),
    P + 'Blanketed.through_reading':
        ('general-structure', 'Blanketed.through_reading: courses alike through the map the sensory part reads are '
                              'alike for the agent; ' + LAW),
    P + 'Blanketed.world_through_active':
        ('general-structure', 'Blanketed.world_through_active: the world driven by the active course; ' + LAW),
    P + 'Deaf.lumps':
        ('model-witness', 'Deaf.lumps: a fact about one constructed model, an internal part reading nothing, with one '
                          'course while the blankets differ (UE18)'),
    P + 'ThresholdDrain.alike_before_four':
        ('model-witness', 'ThresholdDrain.alike_before_four: the blankets agree before step four; ' + WITNESS),
    P + 'ThresholdDrain.any_model':
        ('model-witness', 'ThresholdDrain.any_model: with any model and policy, every reading of the internal course '
                          'alike up to step four; ' + WITNESS),
    P + 'ThresholdDrain.reads_threshold':
        ('model-witness', 'ThresholdDrain.reads_threshold: the sensory part reads the supply only by threshold; '
                          + WITNESS),
    P + 'ThresholdDrain.sensed_at_break':
        ('model-witness', 'ThresholdDrain.sensed_at_break: the break registered when it comes; ' + WITNESS),
    P + 'ThresholdDrain.sensory_apart_at_four':
        ('model-witness', 'ThresholdDrain.sensory_apart_at_four: the sensory parts differ first at step four; '
                          + WITNESS),
    P + 'ThresholdDrain.short_rests':
        ('model-witness', 'ThresholdDrain.short_rests: the ended course rests at a fixed point of its law; ' + WITNESS),
    P + 'forbids_iff':
        ('general-structure', 'forbids_iff: a listed outcome has the share nothing exactly where its weight is nothing; '
                              + WEIGHTS),
    P + 'least_surprisal':
        ('general-structure', 'least_surprisal: under the point weighting a listed outcome is of least surprisal; '
                              + WEIGHTS),
    P + 'point_forbids_rest':
        ('general-structure', 'point_forbids_rest: under the point weighting every event off the outcome weighs '
                              'nothing; ' + WEIGHTS),
    P + 'point_is_restrict':
        ('general-structure', 'point_is_restrict: the point weighting is the counting weighting restricted to the '
                              'record of the outcome; ' + WEIGHTS),
    P + 'read_off_admits':
        ('general-structure', 'read_off_admits: the occupation weighting read off a run admits every visited, listed '
                              'state; ' + WEIGHTS),
    P + 'visits_zero':
        ('support', 'visits_zero: a list lemma, a state never visited has no visits (UE18)'),
}
d = json.loads(PATH.read_text(encoding='utf-8'))
for name, (category, reason) in ROOTS.items():
    assert name not in d['roots'], name
    assert category in d['categories'], category
    d['roots'][name] = {'module': M, 'category': category, 'reason': reason}
PATH.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('registered', len(ROOTS), 'apart roots of', M)
