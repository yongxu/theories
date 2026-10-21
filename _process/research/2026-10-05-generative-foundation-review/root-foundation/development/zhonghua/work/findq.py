"""Find which frozen texts contain a phrase (whitespace-insensitive); prints source id, title, exact span with context.
    python3 -I findq.py PHRASE [PHRASE ...] [--max N]"""
import json, os, re, sys
ROOT = '/private/tmp/claude-501/-Users-ren-theories/ab4fc732-b2ac-420a-aa49-cf63c999271c/scratchpad/ctpkg/civilization-thought-v1.0'
args = sys.argv[1:]; mx = 4
if '--max' in args: i = args.index('--max'); mx = int(args[i + 1]); del args[i:i + 2]
model = json.load(open(ROOT + '/data/model.json', encoding='utf-8'))
cache = {}
for ph in args:
    pat = re.compile(r'[\s，。、；：！？「」『』〈〉《》“”‘’,.;:]*'.join(map(re.escape, re.sub(r'[\s，。、；：]', '', ph))))
    hits = 0
    for s in model['sources']:
        tp = s.get('text_path')
        if not tp: continue
        if tp not in cache: cache[tp] = open(os.path.join(ROOT, tp), encoding='utf-8').read()
        m = pat.search(cache[tp])
        if m:
            t = cache[tp]
            print('%s\t%s\t%s\t…%s【%s】%s…' % (ph, s['id'], (s.get('title') or '')[:24], t[max(0, m.start() - 8):m.start()].replace('\n', ' '), m.group(0), t[m.end():m.end() + 8].replace('\n', ' ')))
            hits += 1
            if hits >= mx: break
    if not hits: print('%s\tNONE' % ph)
