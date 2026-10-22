#!/usr/bin/env python3
"""TI1/TI2: register the apart roots of Becoming.Training in THEOREM-CONNECTIVITY-APART.json, and SD1's six roots that
landed unregistered (dropping the stale Becoming.bounded_rival entry), where not already done. From the checkout root."""
import json
p = '_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json'
d = json.load(open(p))
R = d['roots']
T = 'Becoming.Training'
S = 'Becoming.Significance'
entries = [(f'{T}.Commons.{n}', T, 'model-witness', r) for n, r in [
    ('drawing_responds', 'the drawing law of the computed commons takes one where the stock stands at three and nothing where it stands at none, and restraint takes nothing: a fact about two constructed act laws, read on the learner\'s courses by Training.start_decides'),
    ('outrun_drawing_settles', 'in the computed commons with the rest drawing two a step against a renewal of one, the drawing law is settled at every weight: a computed fact about one model, the witness of Training.outrun_settles_iff'),
    ('outrun_neighbourhood_decides', 'in the computed commons with the rest outrunning the renewal, restraint is settled at no weight, a local search with empty neighbourhoods rests at it and one with every candidate a neighbour leaves it: one model witnessing that a parameterization can install what no reward weight installs'),
    ('renewed_restraint_settles_iff', 'in the computed commons with the rest drawing within the renewal, restraint is settled exactly at weights of at least one: the contrast case of one model'),
    ('start_decides', 'in the computed commons at weight one every improving search keeps the law it starts from, one responding to the stock and one not: Training.settled_stays read on one model')]]
entries += [
    (f'{T}.LocalSearch.improving', T, 'general-structure', 'a local search over any neighbourhood relation on any type of candidates is an improving search; the candidates are read on the spine through Training.levels, the search law itself ranges over any type'),
    (f'{T}.comes_to_rest', T, 'general-structure', 'an improving search under a reward at most B rests by step B + 1 from every start, for candidates of any type: the search runs on Law.orbit, and the base supplies no reading of the candidates beyond Training.levels')]
entries += [(n, S, 'general-structure', r) for n, r in [
    ('Becoming.ReadsOnlyDynamics.admits_rival', 'a law of every statement whose truth does not change with the significance: it admits a rival significance; it ranges over any dynamics type and any significance, and the base supplies no reading of the statement'),
    ('Becoming.ReadsOnlyDynamics.not_entails', 'a law of every statement whose truth does not change with the significance: none entails the continuation condition where a standpoint and a formation exist; over any dynamics type'),
    ('Becoming.excludes_rivals_iff', 'a law of every premise on significance over any formations: it excludes every rival exactly where it implies that no point lacks significance'),
    ('Becoming.not_rival_unrestricted_iff_stable', 'over every significance on any formations, that excluding every rival gives the continuation condition is exactly double-negation elimination; the significance is supplied, not read off a world'),
    ('Becoming.readsOnlyDynamics_of', 'a statement whose truth is given without the significance reads only the dynamics: an unpacking over any dynamics type'),
    ('Becoming.unrestricted_iff_not_rival', 'a law of every significance on any formations decided at each point: excluding every rival is the continuation condition; the significance is supplied, not read off a world')]]
for name, mod, cat, reason in entries:
    R.setdefault(name, {'module': mod, 'category': cat, 'reason': reason})
R.pop('Becoming.bounded_rival', None)
json.dump(d, open(p, 'w'), ensure_ascii=False, indent=1)
open(p, 'a').write('\n')
print('registered')
