"""Critic: U4's table at 2cc1bac0b (draft 2's base) and fe2a1942b (current u4-edge) against draft 2's rule 1 (Flow's
anchors in the statement's closure only): which rows U4's rule places that draft 2's rule leaves unplaced, and what
U4's readings place."""
import collections, json
for tag in ('2cc', 'fe2'):
    T = json.load(open(f'table-{tag}.json'))
    rows = T['rows']
    hand = [r for r in rows if r['by'] != 'rule']
    pairs = collections.Counter((r['rule_would_give'], r['standing']) for r in hand)
    placed_unplaced = sum(n for (a, b), n in pairs.items() if a == 'unplaced')
    print(f'== {tag}: counts {T["counts"]}')
    print(f'   readings {len(hand)}; readings placing rows the rule leaves unplaced: {placed_unplaced}')
    for r in rows:
        b = r['balance']
        if r['by'] == 'rule' and r['standing'].startswith('balance') and not b['flow_statement']:
            # draft 2's rule 1 does not fire; rule 2 needs dependence grammar; rule 3 needs an F5 item
            d2 = 'connected' if r['dependence'] == 'grammar' else ('F5' if r['f5'] else 'unplaced')
            print(f'   U4 rule places {r["declaration"]} at {r["standing"]!r} (written_out={b.get("written_out")}); '
                  f'draft 2 rule gives {d2!r}; reading present: {r["by"] != "rule"}')
