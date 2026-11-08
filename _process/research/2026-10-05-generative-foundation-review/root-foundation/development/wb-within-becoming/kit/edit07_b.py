import sys
p = sys.argv[1]; s = open(p, encoding='utf-8').read()
def rep(a, b):
    global s
    assert s.count(a) == 1, ("count", s.count(a), a[:90])
    s = s.replace(a, b)

# Self-concern and C, last paragraph
rep("It does not derive C. A ranking of courses still needs C or a premise in its place, and self-concern and the condition both remain hypotheses; the condition varies with the net, the class and the direction. The ethics rests on its two premises with two roles, the continuation condition for scope and C for order.",
    "It does not derive C. Whoever ranks courses still holds C or another order, and self-concern and the condition both remain hypotheses; the condition varies with the net, the class and the direction. The ranking results rest on their two readings, the continuation condition for scope and C for order, each named where used.")

# T8
a = s.index("**Thesis T8. 生生 as the direction.**")
b = s.index("\n", a)
s = s[:a] + ("**Thesis T8. 生生, the continuation of life, as what the account's makers offer.** For life, the makers offer a way of seeing, not a verdict: what each course draws on, from what renewal and at which grain, what ends, what goes on through that ending, and who bears it. 生生 is the continuation of life, life wider than the biological and AI within it, its extent unfinished [AI reading, D1]; it is neither the grammar's `«生生»` nor 02's generation. *For life* says whose way it is, not whose losses count: under the continuation condition every continuation's still does. The offer binds no one. No law evaluates ([§1](#evaluation)); where a result ranks courses it does so under C or another named order, and the part every positive weighting shares is widening (`Weighting.widens_iff_every_of_class`, [§4.4](#r-widening-as-what-every-positive-weighting-ranks)). Eating and ending belong to life's going on; what the laws mark is a draw beyond what the renewal it depends on gives ([05](05-COLLECTIVES.md#r-own-count-misses-joint-excess)), its own or others', and where each course ends something the situation decides. The thesis is what the offer expects and could fail: that a selection reading what a course draws on, and what ends with it, leaves a draw beyond a renewal its readers depend on more often than one that does not read it. T4 is its first, partial test: untold, no season kept the bed; told, with talk, one model of two kept it in 8 of 10. Under P2 and P4 of [§4.6](#future-path) everything downstream of one's acts lies on one's line, so the line of any actor whose acts reach living lines runs through life; that is P1's reach without the step of invariance, and what that path does not reach is counted only by a standpoint taking the step. With significance supplied as the free predicate of [§1](#r-what-the-dynamics-leave-open), where there is a standpoint and a formation, neither logic alone nor a satisfiable statement reading only the represented dynamics entails the continuation condition, and `bounded_rival` gives a consistent denial of it; no warrant from outside is sought. The thesis as stated before 9 November 2026, that the shared verdict of the valuers who count everything binds those whose own line runs through life, is kept in [the chapter's before-copy](../history/07-SIGNIFICANCE-before-within-becoming.md#theses). *Standing:* argued; its test beyond T4 named, not designed. Open: P2 and P4, the crux of §4.6's path, with P3, a correspondence not shown for actual selves; how readings that count beyond one's own line form. *Forbids and refuted by:* selections that read a course's draw and what ends with it leaving a draw beyond the renewal their readers depend on no less often than selections that do not.") + s[b:]

# Does not show
rep("- That the continuation condition, C or the step of invariance is warranted. No warrant binding every possible mind is claimed; what still needs argument is named under T8 ([§8](#theses)).",
    "- That anyone must hold the continuation condition, C or the step of invariance: no warrant from outside is sought, and none binding every possible mind is claimed; what is open is named under T8 ([§8](#theses)).")
rep("- That the ethics derives from the condition: the condition fixes scope and orders nothing; C gives order, and a ranking of courses needs C or a premise in its place.",
    "- That the ethics derives from the condition: the condition fixes scope and orders nothing; C gives order, and whoever ranks courses holds C or another order, named where a result uses it.")

# Open: universal warrant
rep("It stays open: supplied local norms, behavioural convergence or fuller description do not answer it, and the ethics, life's stance, does not wait on it ([T8](#theses)).",
    "It stays open as a question the account does not pursue: on its method no warrant from outside is sought ([§1](#evaluation)), and what it offers does not wait on one ([T8](#theses)); supplied local norms, behavioural convergence or fuller description do not answer it.")

# Revision lines
rep("Renewal decides no region, so whether a revision is better is the ethics' question, under its two premises: the continuation condition for scope and C for order, a comparison apart from the prospects' order.",
    "Renewal decides no region, so whether a revision is ranked above another is a question for an order someone holds: under C, with the continuation condition for scope, a comparison apart from the prospects' order.")
open(p, 'w', encoding='utf-8').write(s)
print('ok')
