"""HE2's last owner-approved text fixes, run once after he2_land.sh post and before the commit, when two read-only
reviewers of the landing's diff found 01 §7 behind its record and two stale sentences; each fix at its owners' word
(OU's owner; items 2-4's owner for 01 §7 and law 4), each by flag: --s7 (01 §7's Closure and Balance), --law3 (master-laws law 4's last
sentence, rendered numbering), --crc-dns (continuation-relative-to-a-class's does-not-show item 5 reason). Run from the
landing worktree's root."""
import json, sys
R = 'theories/becoming/results/records/'
def sub(p, pairs):
    t = open(p, encoding='utf-8').read()
    for o, n in pairs:
        assert t.count(o) == 1, (p, o[:70]); t = t.replace(o, n)
    open(p, 'w', encoding='utf-8').write(t)
def rec(rid, fn):
    p = R + rid + '.json'; r = json.load(open(p, encoding='utf-8')); fn(r)
    open(p, 'w', encoding='utf-8').write(json.dumps(r, ensure_ascii=False, indent=2) + '\n')
if '--s7' in sys.argv:
    sub('theories/becoming/chapters/01-ROOT.md', [
     ("is being `x` or being reached from `x` (`«所闭当且仅当同一或及»`). ",
      "is being `x` or being reached from `x` (`«所闭当且仅当同一或及»`). Under the converse it is the closure read backward "
      "(`«所闭之逆»`); a closure through borrowed steps (each step of `R′` a step of `R`, or a step of `R` from `a` taken at "
      "`o`) lies within `o`'s or `a`'s closure under `R` (`«借步之所闭在二所闭»`), and where `R′` holds `R` and `a` lies within "
      "`o`'s closure under `R′`, the two lie within `o`'s closure under `R′` (`«二所闭在借步之所闭»`); Response's "
      "`WithinClosure.converse` and SelectionPool's `WithinClosure.of_reads` and `WithinClosureOf.to_reads` are proved as "
      "these. "),
     ("under the empty relation equal count gives no pairing (`«等长而不对之例»`).\n",
      "under the empty relation equal count gives no pairing (`«等长而不对之例»`). On the grammar itself, counting a region's "
      "units (`«计»`, a region read as a test, a modelling choice), a pairing keeps the count on every region the relation "
      "does not cross (`«对则不越域守数»`), so on every region closed under it and its converse (`«对则双闭域守数»`), closed "
      "one way not being enough (`«对而单闭域不守数之例»`); under a class decided by a test a pairing is exactly equal count "
      "in every class (`«类之对当且仅当类类等数»`), and the class does work (`«一对而静不对之例»`), so a pairing under "
      "continuation relative to such a class keeps the count in every class (`«续之对则类类等数»`). The census of a step: "
      "units listed once before and after it, under a continuation fixing successors and predecessors, pair the units "
      "before, joined with those arising, with the units after, joined with those ceasing, each pair a continuation or the "
      "same unit "
      "(`«定后定前则前并生对后并亡»`), and where the predecessors of the units after stand before and the successors of the "
      "units before stand after, arising and ceasing are beginning and ending (`«前者在前则所列生者生»`, "
      "`«后者在后则所列亡者亡»`). The listing and the test are supplied.\n")])
if '--law3' in sys.argv:
    def f(r):
        l = r['laws'][3]
        assert l['en'].endswith('The listing and the test are supplied, as the pairing is.')
        assert l['zh'].endswith('列表与判别皆为所给，如配对然。')
        l['en'] = l['en'][:-len(' as the pairing is.')].rstrip(',') + '.'
        l['zh'] = l['zh'][:-len('，如配对然。')] + '。'
        h = [h for h in r['history'] if 'board item HE2' in h.get('en', '')]; assert len(h) == 1; h = h[0]
        h['en'] = h['en'].replace(" HE2's design, review and receipt are referenced.", " the balance law's last sentence no "
            "longer says the pairing is supplied, since the census constructs its own; the home section, 01 §7, now states "
            "the closure and balance laws items 2 to 4 add; HE2's design, review and receipt are referenced.", 1)
        h['zh'] = h['zh'].replace('HE2 之设计、审查与回执已引。', '平衡之律末句不再言配对为所给，因清点自造其配对；其所在之节第一章 §7 '
            '今述第 2 至 4 项所增之闭包与平衡之律；HE2 之设计、审查与回执已引。', 1)
    rec('master-laws-on-the-grammar', f)
if '--crc-dns' in sys.argv:
    OLD_EN = 'the grammar states no counting and no map of carriers, so only their premises are connected.'
    NEW_EN = ("the grammar's counting on a region is not connected to the World model's, and the grammar states no map of "
              "carriers, so only their premises are connected.")
    OLD_ZH = '文法不陈述计数，也无载者之映射，故只连其前提。'
    NEW_ZH = '文法之域上计数未与 World 模型者相连，文法亦无载者之映射，故只连其前提。'
    def f(r):
        d = r['does_not_show'][4]
        assert d['en'].count(OLD_EN) == 1 and d['zh'].count(OLD_ZH) == 1
        d['en'] = d['en'].replace(OLD_EN, NEW_EN); d['zh'] = d['zh'].replace(OLD_ZH, NEW_ZH)
        h = [h for h in r['history'] if 'board item HE2' in h.get('en', '')]; assert len(h) == 1
        h[0]['en'] = h[0]['en'].replace('The landing:', "The landing: does-not-show item 5's reason no longer says the "
                                        "grammar states no counting, since GrammarLaws counts on a region;", 1) \
            if 'The landing:' in h[0]['en'] else h[0]['en']
        assert '落地：' in h[0]['zh']
        h[0]['zh'] = h[0]['zh'].replace('落地：', '落地：不示之第 5 项之理由不再言文法不陈述计数，因 GrammarLaws 于域上计数；', 1)
    rec('continuation-relative-to-a-class', f)
print('applied', [a for a in sys.argv[1:]])
