"""`#check @name` for every source declaration (theorems and definitions) of the thirteen modules HE touches,
taken from both receipts' registries, run against each build (all modules imported, pp.fullNames, pp.universes).
usage: python3 -I gen_checks.py OLD_RECEIPT NEW_RECEIPT OUT_DIR; then
  LEAN_PATH=<old tree> lean ChecksOld.lean > checks-old.out; LEAN_PATH=<new tree> lean ChecksNew.lean > checks-new.out"""
import json, sys
o, n, out = json.load(open(sys.argv[1])), json.load(open(sys.argv[2])), sys.argv[3]
CH = ['GrammarLaws', 'GrammarTransport', 'Mechanism', 'KeepingWidening', 'Dissipation', 'Retaining', 'Wholes',
      'Exclusion', 'Reserve', 'PatternPassing', 'Persistence', 'GrammarPath', 'KeptOnward']
names = []
for r in (o, n):
    for m in r['modules']:
        if m['module'] in ['Becoming.' + c for c in CH]:
            for d in m['declarations']:
                if d['name'] not in names:
                    names.append(d['name'])
def drv(r):
    return ('\n'.join('import ' + x for x in r['compile_order']) + '\nset_option pp.fullNames true\n'
            'set_option pp.universes true\nset_option pp.proofs true\n' + ''.join('#check @' + x + '\n' for x in names))
open(f'{out}/ChecksOld.lean', 'w').write(drv(o))
open(f'{out}/ChecksNew.lean', 'w').write(drv(n))
print(len(names), 'declarations')
