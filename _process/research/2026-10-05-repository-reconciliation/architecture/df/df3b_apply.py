#!/usr/bin/env python3
"""DF3 batch B: apply the skeptical reviews of the migrated records.

python3 -B <kit>/df3b_apply.py <results.json> <unit keys>    record and mapping edits; chapter edits collected
python3 -B <kit>/df3b_apply.py --chapters                     the collected chapter edits, applied

Every review edit is taken, as in batch A: errors, overclaims, imprecisions, dropped and missing items, and the
style points. A reviewer's chapter edit that says it supersedes or replaces a migrator's proposal for a record
replaces it. Records are written as the repository's tools write them (indent 2, final newline). Run from the
worktree root.
"""
import json, re, sys
from pathlib import Path

KIT = Path('_process/research/2026-10-05-repository-reconciliation/architecture/df')
RECORDS = Path('theories/becoming/results/records')
CHAPTERS = KIT / 'df3b/chapter-edits.json'
PART = re.compile(r'[^.\[\]]+|\[-?\d+\]')


def get(obj, path):
    for part in PART.findall(path):
        obj = obj[int(part[1:-1])] if part.startswith('[') else obj[part]
    return obj


def setp(obj, path, value):
    parts = PART.findall(path)
    for part in parts[:-1]:
        obj = obj[int(part[1:-1])] if part.startswith('[') else obj[part]
    last = parts[-1]
    if last.startswith('['):
        k = int(last[1:-1])
        if k == len(obj):
            obj.append(value)
        else:
            obj[k] = value
    else:
        obj[last] = value


def replace_in_file(path, old, new):
    p = Path(path)
    s = p.read_text()
    if s.count(old) != 1:
        return f'{path}: old occurs {s.count(old)} times: {old[:70]}'
    p.write_text(s.replace(old, new))


def parse(text):
    try:
        return json.loads(text)
    except (ValueError, TypeError):
        return None


def chapters():
    edits = json.loads(CHAPTERS.read_text())
    failures = [f for f in (replace_in_file(c['file'], c['old'], c['new']) for c in edits) if f]
    print(json.dumps({'chapter_edits': len(edits), 'failures': failures}, ensure_ascii=False, indent=1))
    return 1 if failures else 0


def main(results_path, keys):
    res = [x for x in json.loads(Path(results_path).read_text()) if x and x['unit'] in keys and x.get('review')]
    assert sorted(x['unit'] for x in res) == sorted(keys), [x['unit'] for x in res]
    recs, changed, failures = {}, {}, []
    pending = json.loads(CHAPTERS.read_text()) if CHAPTERS.exists() else []

    def rec(i):
        if i not in recs:
            recs[i] = json.loads((RECORDS / f'{i}.json').read_text())
            changed[i] = []
        return recs[i]

    for x in res:
        superseded, reviewer_chapter = set(), []
        for e in x['review']['edits']:
            i, f, old, new = e['id'], e['field'], e['old'], e['new']
            tag = f"{x['unit']}:{i}:{f}"
            if 'chapters/' in i:
                ids = re.findall(r'r-([a-z0-9-]+)', f)
                if re.search(r'supersed|replac|refin', f) and ids:
                    superseded.update(ids)
                reviewer_chapter.append({'unit': x['unit'], 'record': ids[0] if ids else '', 'file': i, 'old': old, 'new': new, 'by': 'reviewer'})
                continue
            if i.endswith('.md'):
                fail = replace_in_file(i, old, new)
                if fail:
                    failures.append(tag + ': ' + fail)
                continue
            r = rec(i)
            try:
                cur = get(r, f)
            except (KeyError, IndexError, TypeError):
                cur = None
            value = parse(new)
            if isinstance(cur, list) or (cur is None and isinstance(value, (dict, list))):
                if cur is not None and old and parse(old) != cur:
                    failures.append(tag + ': list differs from the reviewer\'s old')
                    continue
                if value is None:
                    failures.append(tag + ': new is not JSON')
                    continue
                setp(r, f, value)
            elif new == '' and f.endswith('.witness'):
                parent = get(r, f.rsplit('.', 1)[0])
                parent.pop('witness', None)  # the reviewer drops an optional witness
            elif old == '' or cur is None:
                setp(r, f, new)
            elif isinstance(cur, str) and cur.count(old) == 1:
                setp(r, f, cur.replace(old, new))
            elif isinstance(cur, str) and cur == old:
                setp(r, f, new)
            else:
                failures.append(f'{tag}: old occurs {cur.count(old) if isinstance(cur, str) else "?"} times')
                continue
            top = re.sub(r'\[.*', '', f.split('.')[0])
            if top != 'history':
                changed[i].append(top)
        for m in x['migrated']['records'] if x.get('migrated') else []:
            if m['id'] in superseded:
                continue
            for c in m.get('chapter_edits', []):
                pending.append({'unit': x['unit'], 'record': m['id'], 'file': c['file'], 'old': c['old'], 'new': c['new'], 'by': 'migrator'})
        pending += reviewer_chapter

    EN = {'statement': 'the statement', 'laws': 'laws', 'does_not_show': 'does-not-show items', 'validation_scope': 'the evidence paragraph',
          'correspondence': 'the correspondence', 'next_delta': 'the next step', 'hypotheses': 'hypotheses', 'counterexamples': 'the counterexamples',
          'references': 'the references', 'proof_bindings': 'the proof bindings', 'related': 'related entries', 'dependencies': 'a dependency',
          'title': 'the title', 'aliases': 'the aliases', 'text_versions': 'the text versions', 'standard_boundaries': 'the standard boundaries'}
    ZH = {'statement': '陈述', 'laws': '规律', 'does_not_show': '“未表明”各项', 'validation_scope': '证据段', 'correspondence': '对应', 'next_delta': '下一步',
          'hypotheses': '前提', 'counterexamples': '反例', 'references': '引用', 'proof_bindings': '证明绑定', 'related': '相关条目', 'dependencies': '依赖',
          'title': '标题', 'aliases': '别名', 'text_versions': '早期文本', 'standard_boundaries': '通用边界'}
    for i, r in recs.items():
        tops = list(dict.fromkeys(changed[i]))
        h = r['history'][-1]
        assert h['en'].startswith('28 October 2026: migrated to schema 2 (DF3 batch B'), i
        if tops:
            h['en'] = h['en'].rstrip() + " The migration's skeptical review was taken in " + ', '.join(EN.get(k, k) for k in tops) + ', each read against the Lean it cites.'
            h['zh'] = h['zh'].rstrip() + '迁移的审查意见已采纳，涉及' + '、'.join(ZH.get(k, k) for k in tops) + '，各条对照所引 Lean 核读。'
        (RECORDS / f'{i}.json').write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n')
    CHAPTERS.write_text(json.dumps(pending, ensure_ascii=False, indent=1) + '\n')
    print(json.dumps({'units': keys, 'records': len(recs), 'chapter_edits_pending': len(pending), 'failures': failures}, ensure_ascii=False, indent=1))
    return 1 if failures else 0


if __name__ == '__main__':
    sys.exit(chapters() if sys.argv[1:] == ['--chapters'] else main(sys.argv[1], sys.argv[2].split(',')))
