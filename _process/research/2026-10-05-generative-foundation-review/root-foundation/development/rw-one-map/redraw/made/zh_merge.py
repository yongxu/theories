# AI-written, 12 November 2026. Joins the Chinese readers' proposals to their checkers' verdicts: a proposal kept or
# fixed becomes a repair with the checker's final text; a dropped one is listed and left. Writes final-zh-checked.json
# (sections zh_boxes, zh_paths, open) for apply_final.py, and prints what the checkers said of the English.
#   python3 -B zh_merge.py <result json of the checking workflow>
import json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
props = json.load(open(os.path.join(HERE, 'final-zh-code.json'), encoding='utf-8')); props = props.get('result', props)
chk = json.load(open(sys.argv[1], encoding='utf-8')); chk = chk.get('result', chk)
out = {'zh_boxes': {'edits': []}, 'zh_paths': {'edits': []}, 'open': {'edits': []}}
seen = {'zh_boxes': set(), 'zh_paths': set()}
for c in chk['checks']:
    if not c or not c.get('r'): print('NO RESULT', (c or {}).get('section'), (c or {}).get('from')); continue
    sec = c['section']; edits = props[sec]['edits']
    for v in c['r']['verdicts']:
        n = v['n']; e = edits[n - 1]; seen[sec].add(n)
        if v['verdict'] == 'drop' or not v['final'].strip():
            print('DROPPED %s %d %s: %s' % (sec, n, e['where'][:60], v['why'][:200])); continue
        out[sec]['edits'].append({'file': e['file'], 'where': '%d %s' % (n, e['where']), 'old': e['old'], 'new': v['final'], 'why': '[%s] %s' % (v['verdict'], v['why'])})
        if v.get('english_off'): print('ENGLISH OFF %s %d %s: %s' % (sec, n, e['where'][:60], v['english_off'][:600]))
    for o in c['r'].get('open', []):
        print('OPEN: %s\n   -> %s' % (o['question'][:160], o['answer'][:700]))
        if o.get('edit_old') and o.get('edit_new'): out['open']['edits'].append({'file': o['edit_file'], 'where': o['question'][:60], 'old': o['edit_old'], 'new': o['edit_new'], 'why': o['answer'][:300]})
    if c['r'].get('notes'): print('NOTES %s %d-%d: %s' % (sec, c['from'], c['to'], c['r']['notes'][:1500]))
for sec in seen:
    missing = sorted(set(range(1, len(props[sec]['edits']) + 1)) - seen[sec])
    if missing: print('NOT CHECKED, not applied: %s %s' % (sec, missing))
json.dump(out, open(os.path.join(HERE, 'final-zh-checked.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print({k: len(v['edits']) for k, v in out.items()})
