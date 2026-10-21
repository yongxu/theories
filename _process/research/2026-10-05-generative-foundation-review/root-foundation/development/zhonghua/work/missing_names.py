"""Collect the concepts the drafters needed and the name table lacks: python3 -I work/missing_names.py

Reads agents/draft-*.json and writes work/missing-names.json: one item per concept key (the Lean name in the
concept text when there is one, else the concept's first words), with every 篇 that reported it, what each wrote
instead, and how often the stand-in occurs in that draft. The integrator decides which recurring concepts get a
classical name (apply_flags.py) and which stay in plain modern Chinese."""
import glob, json, os, re

H = os.path.dirname(os.path.abspath(__file__)); KIT = os.path.dirname(H)
items = {}
for f in sorted(glob.glob(KIT + '/agents/draft-*.json')):
    pian = os.path.basename(f)[6:-5]
    d = json.load(open(f, encoding='utf-8'))
    for m in d.get('missing_names', []):
        lean = re.findall(r'\b(?:[A-Z][A-Za-z]+\.)*[A-Za-z_]+\b', m['concept'])
        lean = [x for x in lean if '.' in x or x[:1].isupper()]
        key = (lean[0] if lean else re.split(r'[ (（,，;；/]', m['concept'].strip())[0]).lower()
        used = re.split(r'[ (（;；]', m['used'].strip())[0]
        it = items.setdefault(key, {'key': key, 'concepts': [], 'uses': []})
        it['concepts'].append(m['concept'])
        it['uses'].append({'pian': pian, 'used': m['used'], 'count': d['markdown'].count(used) if used else 0})
out = sorted(items.values(), key=lambda x: (-len({u['pian'] for u in x['uses']}), x['key']))
json.dump(out, open(H + '/missing-names.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print(len(out), 'concepts;', sum(1 for x in out if len({u['pian'] for u in x['uses']}) > 1), 'reported by more than one 篇')
