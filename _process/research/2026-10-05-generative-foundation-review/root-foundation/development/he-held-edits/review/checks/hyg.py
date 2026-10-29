import re, sys
sys.path.insert(0, '.')
exec(open('compare.py').read().split('old, new = load')[0])
old, new = load('dump-old.tsv'), load('dump-new.tsv')
hyg = re.compile(r'(\S*)\._@\.\S*')
for n in ('Becoming.kept_onward.match_1_1', 'Becoming.«保之像».match_1_1'):
    a, b = hyg.sub(r'\1._@HYG', old[n][4]), hyg.sub(r'\1._@HYG', new[n][4])
    print(n, 'types equal after masking hygienic binder names:', a == b, '| value hashes', old[n][3], new[n][3])
# Also: how many old types differ from new types after masking, overall
cnt = sum(1 for k in set(old)&set(new) if hyg.sub('H', old[k][4]) != hyg.sub('H', new[k][4]))
print('constants whose types differ after masking hygiene:', cnt)
