# ZG8 record specification, read by make_records_zg8.py
MODS = ['Transmission']
REMOVED = set()


def spec(S1, S2, S3):
    return [
 ('forming-anew-necessary-and-sufficient', S1, ['Transmission'],
  ('Forming anew, necessary and sufficient', '新结之依存，充要'),
  ('A dependence forms anew at a descent exactly where inheritance fails, and, depending and drawing coinciding at the giver, exactly where the descendant depends on what its giver did not draw on; the reading of drawing is inheritance with the givers drawing what they pass on.',
   '一依存在一降中新结，恰在因不成之处；给予者处依存与汲取相合时，恰在后代依于给予者所未汲者之处；汲取之读法恰是因加上给予者汲取其所传。'),
  [('A dependence forming anew at a descent excludes inheritance there, and, the giver\'s dependence stable, its exclusion gives inheritance; depending and drawing coinciding at the giver, it forms anew exactly where the descendant depends on what the giver did not draw on.',
    '一降中新结之依存排除因，给予者之依存稳定时，排除新结即得因；给予者处依存与汲取相合时，新结恰在后代依于给予者所未汲者之处。',
    ['Web.FormsAnewAt', 'Web.inheritsAt_iff_not_formsAnew', 'Web.formsAnew_iff_undrawn']),
   ('At a descent, inheritance gives the drawing exactly where the giver draws on what it holds and passes on; so the reading of drawing is inheritance with the givers drawing what they pass on, with no premise for this half.',
    '一降中，因得汲取，恰在给予者汲取其所持而传下者之处；所以汲取之读法恰是因加上给予者汲取其所传，此一半无前提。',
    ['Web.drawn_necessary_iff', 'Flow.PassesDrawn', 'Flow.dependsOnDrawn_iff']),
   ('Depending and drawing coinciding at the givers, their dependences stable: inheritance, the reading of drawing, and no descendant depending on what its giver did not draw on are one.',
    '给予者处依存与汲取相合、其依存稳定时：因、汲取之读法、无后代依于给予者所未汲者，三者为一。', ['Flow.inherits_iff_none_undrawn'])],
  ('No axiom; drawing being depending (DrawingDepends) for the sufficient half; depending being drawing at the givers and stable dependences where the full equivalence is stated.', '不加公理；充分之一半须汲取即依存（DrawingDepends）；全等价须给予者处依存即汲取且依存稳定。'),
  [('How dependences form at coming to stand, or that depending and drawing coincide in any actual descent.', '依存在首立时如何结成，或在实际之降中依存与汲取相合。', 'non-implication')],
  ('Inheritance as transmission of what the parent uses: a trait is passed on where the parent expresses it.', '因为亲之所用之传：亲所表达者才传下。'),
  [('transmission-is-inheritance-and-need', 'Its inherits_of_drawn, here with its necessary half.', '其 inherits_of_drawn，此处加上必要之一半。')],
  ['weishi-shiqi-wu-yin']),
    ]
