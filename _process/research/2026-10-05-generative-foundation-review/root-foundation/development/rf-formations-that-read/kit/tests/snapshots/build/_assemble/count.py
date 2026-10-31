import re, sys
s=open(sys.argv[1]).read()
def words(t):
    t=re.sub(r'\]\([^)]*\)',']',t); t=re.sub(r'[`*\[\]#|]','',t)
    return len(t.split())
ten=s.split('## The tests in ten minutes')[1].split('## The tests in an hour')[0]
hour=s.split('## The tests in an hour')[1].split('## The rest')[0]
print('ten-minute words', words(ten), '| hour words', words(hour), '| total', words(s))
