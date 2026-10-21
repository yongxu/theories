"""LU1: extend ClosedCapture's module doc (run once on the kit tree's copy)."""
import sys
p = sys.argv[1]
s = open(p).read()


def once(old, new):
    global s
    assert s.count(old) == 1, (old[:80], s.count(old))
    s = s.replace(old, new)


once("""  rule that come apart in either read beyond the share (`reads_beyond_of_apart`).
""", """  rule that come apart in either read beyond the share (`reads_beyond_of_apart`). This is the
  spine's law of a part read alone (`Law.part_identifiesAlike_iff_step` of
  `Becoming.IdentificationRuns`) on the two-level step: what the loop reads, share, rule and step
  count (`loopPart`), goes alike under the step where nothing beyond the share is read
  (`goAlike_of_unread`); it makes sense by itself along every schedule exactly then
  (`identifiesAlike_iff_unread`), and courses from starts alike in share and rule stay alike
  along every schedule exactly then (`courses_alike_iff_unread`). `unread_course` is
  `Law.sameFuture_of_goAlike` read along the course.
""")
once("""So a loop whose every level reads only the share is one two-level law of the share:""",
     """A reader formed within the run is a reading of the run: nothing here supposes that what reads
stands outside what it reads, and what the loop can tell apart is settled by the one law of
lumping that settles what a learner can identify (`Learning.goAlike_iff_lumped`) and what a
selection can reach.

So a loop whose every level reads only the share is one two-level law of the share:""")
open(p, 'w').write(s)
