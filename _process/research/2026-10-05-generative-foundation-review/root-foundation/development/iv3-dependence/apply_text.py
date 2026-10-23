#!/usr/bin/env python3
"""IV3: the route through dependence in the texts. THE-STEP-OF-INVARIANCE (In brief item 5, a new §4.4, §5, §7, §8);
the canonical chapter §8.5 (EN, ZH); the study section; the significance review's dependence check; D64 in the delegated
choices; the package README row (EN, ZH). Every edit adds lines or extends one row, so records citing these files by
anchor see added lines only, except the README rows. The root module's doc changes with the Lean, before the checker
runs (integrate.py).
usage (from the checkout root): python3 -B apply_text.py STUDY_SECTION RECEIPT"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
N, RECEIPT = int(sys.argv[1]), sys.argv[2]
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = ROOT / (RF + 'BECOMING-RENEWAL-READING.md')
REVIEW = ROOT / (RF + 'BECOMING-SIGNIFICANCE-REVIEW.md')
CHOICES = ROOT / (RF + 'DELEGATED-CHOICES.md')
EN = ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
STEP = ROOT / 'theories/becoming/chapters/THE-STEP-OF-INVARIANCE.md'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
ANCHOR = f'#{N}-self-concern-through-dependence-iv3'
CH = '../../../' + RF  # from theories/becoming/chapters
SLINK = CH + 'BECOMING-RENEWAL-READING.md' + ANCHOR
CHECK = CH + 'BECOMING-SIGNIFICANCE-REVIEW.md#dependence-check'
WORDS = '../../../sources/15-codex-theory-conversations/2026-10-23-one-system.md'
REC = '../results/records/'
S, O = 'self-concern-through-dependence', 'what-self-concern-alone-ranks'
PENDING = {}


def text(path):
    return PENDING.get(path, path.read_text(encoding='utf-8'))


def insert_after(path, prefix, block):
    """Insert `block` (lines) after the one line that starts with `prefix`."""
    lines = text(path).split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith(prefix)]
    assert len(at) == 1, (path.name, prefix[:60], len(at))
    PENDING[path] = '\n'.join(lines[:at[0] + 1] + block + lines[at[0] + 1:])


def insert_before(path, prefix, block):
    lines = text(path).split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith(prefix)]
    assert len(at) == 1, (path.name, prefix[:60], len(at))
    PENDING[path] = '\n'.join(lines[:at[0]] + block + lines[at[0]:])


def replace_once(path, old, new):
    s = text(path)
    assert s.count(old) == 1, (path.name, old[:60], s.count(old))
    PENDING[path] = s.replace(old, new)


# ---- THE-STEP-OF-INVARIANCE ------------------------------------------------------------------------------
assert '### 4.4' not in text(STEP)
insert_after(STEP, '   - None of the objections is shown to defeat the step, and the step is not shown.', [
    '5. **Where the centers depend on one another, the de se question decides nothing** (section 4.4). Draw the self '
    'along a relation its continuation is carried along: what feeds it, or what it needs. Held de se, self-concern is '
    'then the same from every standpoint exactly where the centers lie within one another\'s closures '
    '(`ownClosure_standpointInvariant_iff_centersWithin`), and centers that share one condition do '
    '(`Flow.centersWithin_feeding_of_common`). Drawn along need, it reaches a copy of what it needs only where the copy '
    'is the only one (`forced_member_iff_only`). An order increasing only in its own continuation, weaker than C\'s '
    'premise, already ranks the ending of what everything needs below every course keeping the standpoint '
    '(`Weighting.ended_below`). The step keeps its work beyond the centers\' common closure and for each center '
    'counting from another\'s standpoint.',
])

insert_before(STEP, '## 5. Order: what every standpoint shares', [
    '### 4.4 Where the centers depend on one another',
    '',
    '*The relation a continuation is carried along.* The case against needs two things at once: the de se reading, and a '
    'relation the self is drawn along whose closures differ from center to center (section 4.1). The relation is not '
    'free. The presupposition is about continuation, and a continuation is carried along what feeds it and what it '
    'needs: no formation continues on its own relations alone, as a life cut off from what it draws on does not last. '
    'So a standpoint that holds its own continuation significant holds significant, at least as conditions of it, the '
    'continuation of what its continuation needs. This is the means-end step (to hold an end is to hold what the end '
    'needs), far weaker than invariance, and section 6.3 already counted covering by feeding as the defensible part of '
    'covering. Grant the critic the de se reading and draw the self along feeding or need. The route is the AI\'s '
    f'argument ([study §{N}]({SLINK})); its provenance is [Ren\'s words of 23 October 2026]({WORDS}).',
    '',
    '- **Within the centers\' common closure the de se question decides nothing.** Held de se, the presupposition is '
    'standpoint-invariant, and the de se and de dicto readings agree, exactly where every center lies within every '
    'center\'s closure (`ownClosure_standpointInvariant_iff_centersWithin`, '
    '`selfAscribed_iff_withinSome_iff_centersWithin`); each center\'s closure is then one closure '
    '(`withinClosure_iff_of_centersWithin`). The whole need not lie within it. Centers that at one step require one '
    'condition and give to it lie within one another\'s feeding closures, and centers that depend on one condition and '
    'exchange with it lie within one another\'s influence closures (`Flow.centersWithin_feeding_of_common`, '
    '`Flow.centersWithin_influence_of_common`), so self-concern held de se along either is one from all of them '
    '(`Flow.ownClosure_feeding_invariant_of_common`, `Flow.ownClosure_influence_invariant_of_common`). The whole-world '
    'case was proved before: on a mutually dependent or mutually fed flow, significance bounded by each center\'s '
    'closure is the condition (`Flow.MutuallyDependent.unrestricted`, `Flow.MutuallyFed.unrestricted`), and one '
    'condition every formation depends on and exchanges with makes a flow mutually dependent '
    '(`Flow.mutuallyDependent_of_common`). What is added is that only the centers need depend on one another.',
    '- **Copies.** Drawn along need, the presupposition reaches exactly what the continuation needs (`forced_needs_iff`). '
    'Where a continuation can be carried by any of several alternatives, each able to carry it alone, it needs none of '
    'them, and the presupposition reaches a member exactly where it is the only one (`needs_iff_only`, '
    '`forced_member_iff_only`; in `Copies` the user needs some copy and neither of the two, `Copies.two_copies`). With '
    'copies the means-end step reaches the class, which no significance of a single formation states; with one copy it '
    'reaches that copy. A condition of which there is one and which every center needs is reached from every standpoint '
    'by self-concern alone.',
    '- **Order.** An order that ranks higher only widenings adding to its own continuation already ranks the ending of '
    'what everything needs below every course keeping the standpoint (section 5).',
    '',
    '*What the step still does.* (i) Each center counting from another\'s standpoint beyond its part as a condition: '
    'along need a formation counts for another only as what it needs, and with copies not even that; this is the step '
    'across standpoints (`forced_iff_center`). (ii) What lies beyond every center\'s closure, such as the dweller of '
    '`Clearing` (`Clearing.centers_retain_yet_loses`). (iii) Along affecting, the shared scope is a formal fact without '
    'the means-end warrant, since valuing one\'s continuation does not commit one to valuing what merely affects it '
    '(section 6.3).',
    '',
    '*What is empirical.* Whether actual centers depend on one another is not a theorem. The AI\'s reading (D64): '
    'through one atmosphere, one biosphere and one economy, human beings now plausibly lie within one another\'s feeding '
    'closures, and several conditions they all need have no second copy. If so, the self-concern of every human being, '
    'held de se and drawn along what carries it, has one scope there, whoever holds it. Dependence is contingent: a '
    'center that makes itself independent of a common condition leaves the common closure, and its self-concern no '
    'longer reaches what it left. The scope this route secures is only as wide as the dependence that holds.',
    '',
    '*What it answers.* The route answers the privileged-relation half of the objection with the relation a '
    'continuation is carried along. It does not answer the de se question, and within the common closure it needs no '
    'answer to it. Its ingredients are known: Næss\'s ecological Self (1987); the convergence of anthropocentric and '
    'nonanthropocentric policy within what humans need (Norton 1991); the transmission of reasons to necessary means '
    '(Kiesewetter 2015) against facilitative means (Raz 2005); ecological redundancy (Walker 1992); Jonas on staking '
    f'the whole (1979). The [dependence check]({CHECK}) says what is new.',
    '',
])

insert_before(STEP, '## 6. The objections of §8.9', [
    '**What self-concern alone ranks** (section 4.4). Read one standpoint\'s self-concern as an order *increasing in its '
    'own continuation*: it ranks above what it widens every widening that adds to the items its own continuation marks '
    '(`Weighting.AddsOwn`, `Weighting.IncreasingInOwn`). This is weaker than C\'s premise: every order increasing in '
    'admission is one (`Weighting.increasingInOwn_of_increasing`), and the two coincide exactly where its own '
    'continuation is everything listed (`Weighting.increasingInOwn_iff_increasing`).',
    '',
    '- **What it ranks.** What every such order shares is exactly the widenings that add to its own continuation '
    '(`Weighting.widensOwn_iff_every_increasingInOwn`). Where one course adds to it, every such order ranks it above the '
    'other exactly where the other keeps nothing beyond it (`Weighting.every_increasingInOwn_iff_includes`); where the '
    'other keeps something beyond, some such order, a positive weighting, ranks the other higher '
    '(`Weighting.some_increasingInOwn_reverses`).',
    '- **The ending of what everything needs.** A course that admits nothing from an ending on, and agrees with another '
    'before it, keeps nothing beyond it; so from every standpoint whose continuation the other keeps, every order '
    'increasing in its own continuation ranks the ending below (`Weighting.includes_of_ended`, `Weighting.ended_below`). '
    'The dynamics say when a course admits nothing from an ending on: groups whose conditions are coupled end together, '
    'and nothing is selected among them (`GroupEnding.Flow.coupled_end_together`); after a family of conditions is drawn '
    'beyond its renewal, only what depended on none of it leaves descendants (`Founding.Flow.survivors_independent`). '
    'The two are joined by argument, not by one theorem: where every formation depends on one coupled family of '
    'conditions, its ending is ranked below by every standpoint\'s self-concern, with no C.',
    '- **An independent copy makes it mixed.** Where something continues without the ended family, the ended course keeps '
    'something beyond, and some order increasing in its own continuation ranks it higher. Copies whose conditions are '
    'independent protect the class, and they divide the shared ranking: each standpoint\'s self-concern ranks only the '
    'endings of what it needs. That a recurring risk of ending, on one run with nothing to average over, comes to an '
    'ending (Peters 2019) is not formalized here.',
    '- **Scope and order on one premise.** Drawn along feeding in a mutually fed flow, a standpoint\'s own continuation '
    'is everything listed, and an order increasing in it is increasing in admission (`Weighting.increasingInOwn_iff_increasing`, '
    'with `Flow.MutuallyFed`). C\'s premise is then self-concern\'s monotonicity in what carries it, under the same '
    'drawing that fixes the scope. This places the premise more narrowly; it does not warrant it.',
    '',
])

insert_after(STEP, 'None is settled by formal work. Each is stated so that an argument settles it.', [
    '',
    '**What the route through dependence changes** (section 4.4). Item 1 has force only beyond the centers\' common '
    'closure along what carries their continuation, and for each center counting from another\'s standpoint. Item 2 '
    'becomes, along feeding and need, the empirical question whether the actual centers depend on one another. Item 4 '
    'narrows to monotonicity in one\'s own continuation drawn along what carries it: that already ranks the ending of what '
    'everything needs, and in a mutually fed flow it is C\'s premise. None of these is settled by the route; each is '
    'narrowed to a question about which relations hold.',
])

insert_after(STEP, '| Priority on levels agrees with C and decides transfers; sufficiency ties above the threshold |', [
    '| Held de se, self-concern is one from every standpoint exactly where the centers lie within one another\'s closures; '
    'centers sharing one condition do | `CentersWithin`, `ownClosure_standpointInvariant_iff_centersWithin`, '
    '`selfAscribed_iff_withinSome_iff_centersWithin`, `Flow.centersWithin_feeding_of_common`, '
    '`Flow.centersWithin_influence_of_common` | `Becoming.Weightings` | landed |',
    '| Drawn along need, the presupposition reaches what is needed, and a copy only where it is the only one | `Needs`, '
    '`forced_needs_iff`, `needs_iff_only`, `forced_member_iff_only`, `Copies.two_copies` | `Becoming.Weightings` | '
    'landed |',
    '| An order increasing in its own continuation ranks exactly the widenings adding to it, the ending of what '
    'everything needs below; it is C\'s premise where its own continuation is everything | `Weighting.IncreasingInOwn`, '
    '`Weighting.every_increasingInOwn_iff_includes`, `Weighting.some_increasingInOwn_reverses`, '
    '`Weighting.ended_below`, `Weighting.increasingInOwn_iff_increasing` | `Becoming.Weightings` | landed |',
    '| The whole-world case, and coupled groups ending together | `Flow.MutuallyFed.unrestricted`, '
    '`Flow.mutuallyDependent_of_common`, `GroupEnding.Flow.coupled_end_together`, `Founding.Flow.survivors_independent` | '
    '`Becoming.MutualDependence`, `Becoming.GroupEnding`, `Becoming.Founding` | landed |',
])

insert_after(STEP, 'The records are [what-the-step-across-standpoints-reaches]', [
    '',
    f'The route through dependence is recorded in [{S}]({REC}{S}.md) and [{O}]({REC}{O}.md).',
])

# ---- the canonical chapter §8.5 ----------------------------------------------------------------------------
insert_after(EN, '- **Calling the generative space good**', [
    '- **What self-concern reaches through dependence** ([THE-STEP-OF-INVARIANCE §4.4](THE-STEP-OF-INVARIANCE.md'
    '#44-where-the-centers-depend-on-one-another); records '
    f'[{S}]({REC}{S}.md) and [{O}]({REC}{O}.md)). Drawn along what its continuation is carried along (what feeds it, '
    'what it needs), the self\'s presupposition held de se is one from every standpoint exactly where the centers lie '
    'within one another\'s closures, and centers that share one condition do. Drawn along need, it reaches a copy only '
    'where the copy is the only one. An order that ranks higher only widenings adding to its own continuation already '
    'ranks the ending of what everything needs below every course keeping the standpoint. The step of invariance keeps '
    'its work beyond the centers\' common closure and for each center counting from another\'s standpoint; C keeps its '
    'work in the comparisons self-concern leaves mixed. Whether actual centers depend on one another is empirical.',
])
insert_after(ZH, '整体的演绎必然性；更强的普遍实践根据', [
    '',
    '**自我关切经由依存所及**（[THE-STEP-OF-INVARIANCE §4.4](THE-STEP-OF-INVARIANCE.md'
    '#44-where-the-centers-depend-on-one-another)；记录 '
    f'[{S}]({REC}{S}.md) 与 [{O}]({REC}{O}.md)）。沿延续所凭借者（养之者、所需者）来画自我，从己持有的预设恰在诸中心彼此'
    '位于对方闭包之内处对每个立场都相同，共有一个条件的诸中心即如此。沿“所需”来画，它只在某个副本是唯一者时达到该副本。只把增加'
    '自身延续的扩大排得更高的次序，已把一切所需者的终结排在每个保留该立场的进程之下。不变之步只在诸中心的共同闭包之外、以及每个中心'
    '从他者立场算数处还有工作；C 只在自我关切留下的混合比较中还有工作。实际的诸中心是否彼此依存，是经验问题。',
])

# ---- the study and the review --------------------------------------------------------------------------------
st = text(STUDY)
assert f'\n## {N}. ' not in st and '(IV3)' not in st
last = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M))
assert N == last + 1, ('section number', N, last)
sec = (HERE / 'study_iv3.txt').read_text(encoding='utf-8')
import json
R = json.loads((PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Weightings')
sec = (sec.replace('## {N}.', f'## {N}.').replace('RECEIPT_ID', RECEIPT)
       .replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations']))))
assert '{N}' not in sec and 'THEOREMS' not in sec and 'DECLS' not in sec
PENDING[STUDY] = st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n'

rv = text(REVIEW)
assert 'id="dependence-check"' not in rv
PENDING[REVIEW] = rv.rstrip('\n') + '\n\n' + (HERE / 'review_iv3.txt').read_text(encoding='utf-8').rstrip('\n') + '\n'

# ---- D64 ---------------------------------------------------------------------------------------------------
assert '| D64 |' not in text(CHOICES)
insert_after(CHOICES, '| D63 |', [
    '| D64 | the readings of self-concern through dependence (23 October) | adopted with exact scope: the relation a self '
    'is drawn along read as one its continuation is carried along (feeding, need); the centers within one another\'s '
    'closures read as their depending on one another, the de se question deciding nothing within their common closure; '
    'need as continuing on every possible course, copies as alternatives each able to carry a continuation alone; an '
    'order increasing in its own continuation as self-concern\'s monotonicity; the planetary case an empirical reading |',
])
insert_after(CHOICES, '- Ren\'s request of 22 October 2026 to integrate 文理生生', [
    '- Ren\'s message of 23 October 2026 on what counts as a system and on there being one planetary system '
    '([words](../../../../sources/15-codex-theory-conversations/2026-10-23-one-system.md)), taken up by board item IV3: '
    f'D64 ([study section {N}](BECOMING-RENEWAL-READING.md{ANCHOR})).',
])
ch = text(CHOICES)
PENDING[CHOICES] = ch.rstrip('\n') + '\n\n' + '\n'.join([
    '<a id="d64-the-readings-of-self-concern-through-dependence"></a>',
    '### The readings of self-concern through dependence',
    '',
    'Where: the chapter [THE-STEP-OF-INVARIANCE](../../../../theories/becoming/chapters/THE-STEP-OF-INVARIANCE.md) §4.4, '
    '§5, §7 and §8; the canonical chapter §8.5; the records '
    f'[{S}](../../../../theories/becoming/results/records/{S}.md) and '
    f'[{O}](../../../../theories/becoming/results/records/{O}.md); the [significance review\'s dependence '
    'check](BECOMING-SIGNIFICANCE-REVIEW.md#dependence-check); study section '
    f'{N} ([IV3](BECOMING-RENEWAL-READING.md{ANCHOR})). Decided in the one account of D45; continues D59, D60 and D61.',
    '',
    '**Decision.** Adopted with exact scope.',
    '1. **The relation of the self.** The relation a self is drawn along, for the self\'s presupposition, is read as one '
    'its continuation is carried along: what feeds it (`Flow.FedFrom`) or what it needs (`Needs`). Being affected '
    '(`Flow.AffectedBy`) is a formal comparison, not a reading of the self. D61\'s question, which relation\'s closure is '
    'the scope, is answered by this reading, not settled: whether it is the right relation is argued in '
    'THE-STEP-OF-INVARIANCE §4.4.',
    '2. **The centers depending on one another.** That the centers lie within one another\'s closures (`CentersWithin`) '
    'is read as their depending on one another along that relation; within their common closure the de se and de dicto '
    'readings agree, and the de se question decides nothing there.',
    '3. **Need and copies.** That `f` needs `g` is read as `g` continuing on every possible course on which `f` does '
    '(`Needs`); copies as alternatives each able to carry a continuation alone (`CarriesAlone`). The class of copies, which '
    'the means-end step reaches and no significance of a single formation states, is not read as a formation.',
    '4. **Self-concern\'s order.** An order increasing in its own continuation (`Weighting.IncreasingInOwn`) is read as '
    'the monotonicity a self-concerned standpoint has in its own continuation, and a course admitting nothing from an '
    'ending on as the course on which a condition everything needs has ended.',
    '5. **The planetary case.** That human beings now lie within one another\'s feeding closures, and that some '
    'conditions they all need have no second copy, is an empirical reading, not a theorem.',
    '',
    '**Reasons.** Each reading says no more than the laws it names. The self\'s presupposition is about continuation, so '
    'the relation it is drawn along should be one a continuation is carried along; feeding and need are the two the base '
    'and the copies law state, and they part exactly at copies, as transmission to facilitative and to necessary means '
    'part in the theory of reasons.',
    '',
    '**What would change it.** An argument that the self\'s presupposition is drawn along a relation narrower than what '
    'carries its continuation (the organism\'s own organization, for instance) and does not pass to the conditions of '
    'that continuation; then the route reaches only the narrower self. A representation of need with weights, under '
    'which a copy is needed in degree and the class\'s continuation is stated.',
]) + '\n'

# ---- the package README row (EN, ZH) ------------------------------------------------------------------------
REL = '../../../../../../theories/becoming/results/records/'
replace_once(PKG / 'README.md', "; the readings are the AI's (D59, D60) |",
             '; held de se, self-concern is one from every standpoint exactly where the centers lie within one '
             'another\'s closures, and centers sharing one condition do (`ownClosure_standpointInvariant_iff_centersWithin`, '
             '`selfAscribed_iff_withinSome_iff_centersWithin`, `Flow.centersWithin_feeding_of_common`, '
             '`Flow.centersWithin_influence_of_common`); drawn along need it reaches a copy only where the copy is the only '
             f'one (`forced_needs_iff`, `forced_member_iff_only`, `Copies.two_copies`; record [{S}]({REL}{S}.md)); an order '
             'increasing in its own continuation ranks a course adding to it above another exactly where the other keeps '
             'nothing beyond it, so the ending of what everything needs is ranked below from every standpoint, and it is '
             'C\'s premise where its own continuation is everything (`Weighting.every_increasingInOwn_iff_includes`, '
             '`Weighting.some_increasingInOwn_reverses`, `Weighting.ended_below`, `Weighting.increasingInOwn_iff_increasing`; '
             f'record [{O}]({REL}{O}.md)); the readings are the AI\'s (D59, D60, D64) |')
replace_once(PKG / 'README.zh.md', '；读法是 AI 的（D59、D60） |',
             '；从己地持有，自我关切恰在诸中心彼此位于对方闭包之内处对每个立场都相同，共有一个条件的诸中心即如此'
             '（`ownClosure_standpointInvariant_iff_centersWithin`、`Flow.centersWithin_feeding_of_common`）；沿“所需”来画，它只在'
             '某个副本是唯一者时达到该副本（`forced_member_iff_only`、`Copies.two_copies`）；在自身延续上递增的次序，在一条进程增加'
             '其延续处，恰在另一条不保住任何超出者时把前者排在上面，故一切所需者的终结从每个立场都被排在下面，其自身延续为一切时即 C 的'
             '前提（`Weighting.every_increasingInOwn_iff_includes`、`Weighting.ended_below`、`Weighting.increasingInOwn_iff_increasing`）；'
             '读法是 AI 的（D59、D60、D64） |')

for path, s in PENDING.items():
    path.write_text(s, encoding='utf-8')
    print('wrote', path.relative_to(ROOT))
