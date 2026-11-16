# AI-written (Fable, refuter), 16 November 2026. Counts the words of report.json beside it; writes nothing.
import json
R = json.load(open(__file__.rsplit('/', 1)[0] + '/report.json'))
def words(o):
    if isinstance(o, str): return len(o.split())
    if isinstance(o, list): return sum(words(x) for x in o)
    if isinstance(o, dict): return sum(words(v) for v in o.values())
    return 0
for k, v in R.items(): print(k, words(v))
print('total', words(R))
