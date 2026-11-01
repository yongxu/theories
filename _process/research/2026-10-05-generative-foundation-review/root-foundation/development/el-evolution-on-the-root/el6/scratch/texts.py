def edit(p,pairs):
    s=open(p).read()
    for a,b in pairs:
        assert s.count(a)==1,(p,a[:80],s.count(a))
        s=s.replace(a,b)
    open(p,'w').write(s)
def droprow(p,mod):
    lines=open(p).read().split('\n')
    hit=[i for i,l in enumerate(lines) if l.startswith('| L') and f'[`Becoming.{mod}`]' in l]
    assert len(hit)==1,(p,hit); del lines[hit[0]]
    open(p,'w').write('\n'.join(lines))
# --- README.md
edit('README.md',[
("telling going on from ending at every point is exactly excluded middle (`«延尽之定当且仅当排中»`); along the successor",
 "telling going on from ending at every point is exactly excluded middle (`«延尽之定当且仅当排中»`); ending on every branch reaches an end up to double negation (`«尽则非无终»`) and where going on is decided (`«尽而续可定则有终»`), and with no decision exactly under excluded middle (`«尽则有终当且仅当排中»`, witnessed by `Map.StepWhere`, the short life gated by a proposition); along the successor"),
("consumption held, a family drawn beyond renewal and stopped passing refute going on every branch; the relay renews and ends (`Map.relay_renews_and_ends`) |",
 "degeneration constructively: along any class, a line whose reach at a step `N` not before it ends on every branch ends on every branch (`Web.ends_of_ends_at`), so at every class within activity, from an active occurrence where nothing the line reaches at `N` is active, the pattern degenerates (`«退化»`, `Web.every_branch_ends_of_gone`); read coarser it does not go on (`Web.not_endless_of_gone`) and where going on is decided reaches an end (`Web.end_of_gone`), which with no decision is exactly excluded middle (`Map.end_of_gone_iff_excluded_middle`); consumption held, a family drawn beyond renewal and stopped passing degenerate the line through one step each (`Web.consumed_held_degenerates`, `Web.family_excess_degenerates`, `Web.stopped_degenerates`), so they refute going on every branch; the relay renews and ends (`Map.relay_renews_and_ends`) |"),
("and brief supports as 全生成 (`Flow.generation_of_brief`); under the World premises nothing keeps opening",
 "and brief supports as 全生成 (`Flow.generation_of_brief`); degeneration at the kind grain wherever a uniform horizon is known, the kind instance of MapInstances' law (`Web.kind_every_branch_ends_of_gone`); under the World premises nothing keeps opening"),
])
droprow('README.md','LineDegeneration')
# --- README.zh.md
edit('README.zh.md',[
("在每一点分辨延与尽恰是排中律（`«延尽之定当且仅当排中»`）；沿后继之线",
 "在每一点分辨延与尽恰是排中律（`«延尽之定当且仅当排中»`）；诸支皆尽者在双重否定下有终（`«尽则非无终»`），延续可判定时有终（`«尽而续可定则有终»`），不判定时恰在排中之下有终（`«尽则有终当且仅当排中»`，以 `Map.StepWhere` 为见证，即以一命题为门的短命之线）；沿后继之线"),
("所耗仍持、家族超出更新、传之止，皆否诸支之不穷；中继复生而终（`Map.relay_renews_and_ends`） |",
 "构造地退化：沿任一类，线在不早于它的某步 `N` 所及者都在每一支上终结时，这条线在每一支上终结（`Web.ends_of_ends_at`），故在活动以内的每一类上，从一个活动的出现出发，线在 `N` 所及者都不活动时，其式退化（`«退化»`，`Web.every_branch_ends_of_gone`）；读得更粗，它不延续（`Web.not_endless_of_gone`），延续可判定时有终（`Web.end_of_gone`），不判定时恰为排中（`Map.end_of_gone_iff_excluded_middle`）；所耗仍持、家族超出更新、传之止，各经一步使线退化（`Web.consumed_held_degenerates`、`Web.family_excess_degenerates`、`Web.stopped_degenerates`），故皆否诸支之不穷；中继复生而终（`Map.relay_renews_and_ends`） |"),
("支撑短暂时读作全生成（`Flow.generation_of_brief`）；在世界前提下",
 "支撑短暂时读作全生成（`Flow.generation_of_brief`）；凡已知一致视界处，种类粒度上的退化，即 MapInstances 之律在种类上的实例（`Web.kind_every_branch_ends_of_gone`）；在世界前提下"),
])
droprow('README.zh.md','LineDegeneration')
# --- Becoming.lean
B=open('Becoming.lean').read()
i=B.index('* `Becoming.LineDegeneration` (L2, through `Becoming.KeepingWidening`)')
j=B.index('* `Becoming.GrammarTesting` (L1)',i)
B=B[:i]+B[j:]
open('Becoming.lean','w').write(B)
edit('Becoming.lean',[
("""  telling going on from ending at every point is exactly excluded middle (`«延尽之定当且仅当排中»`);
  a sequence of classes""","""  telling going on from ending at every point is exactly excluded middle (`«延尽之定当且仅当排中»`);
  ending on every branch reaches an end up to double negation (`«尽则非无终»`) and where going on is
  decided (`«尽而续可定则有终»`), and that it always does is exactly excluded middle
  (`«尽则有终当且仅当排中»`, witnessed by the short life gated by a proposition, `Map.StepWhere`);
  a sequence of classes"""),
("""  did not carry on as itself (`Web.carries_iff`); under passing, generation makes carriers arise at
  arbitrarily late steps (`Web.generation_arises_late`); read by names alone nothing generates and
  an always-active formation keeps (`Web.itself_not_generation`, `Web.always_keeps`); consumption
  still held, a family drawn beyond renewal and passing that stops refute going on every branch
  (`Web.consumed_held_not_endless`, `Web.family_excess_not_endless`, `Web.stopped_not_endless`);
  the relay renews and still ends (`Map.relay_renews_and_ends`). A leaf.""","""  did not carry on as itself (`Web.carries_iff`); under passing, generation makes carriers arise at
  arbitrarily late steps (`Web.generation_arises_late`); read by names alone nothing generates and
  an always-active formation keeps (`Web.itself_not_generation`, `Web.always_keeps`). Degeneration,
  constructively (board item EL, its part EL3, placed here by EL6): along any class, where
  everything the line from an occurrence reaches at a step `N` not before it ends on every branch,
  the line ends on every branch (`Web.ends_of_ends_at`, by induction on the steps left, with no
  excluded middle and no premise of one continuation); so at every class within activity, from an
  active occurrence where nothing the line reaches at `N` is active, the pattern degenerates
  (`«退化»`, `Web.every_branch_ends_of_gone`; at activity `Web.activity_every_branch_ends_of_gone`,
  at the kind grain in `Becoming.KeepingWidening`). Read coarser the line does not go on
  (`Web.not_endless_of_gone`) and, where going on is decided, reaches an end (`Web.end_of_gone`),
  both proved from degeneration; that every line meeting the law's premise reaches an end is
  exactly excluded middle (`Map.end_of_gone_iff_excluded_middle`, witnessed by `Map.Undecided`).
  Consumption still held, a family drawn beyond renewal and passing that stops degenerate the line
  through one step each (`Web.consumed_held_degenerates`, `Web.family_excess_degenerates`,
  `Web.stopped_degenerates`), so they refute going on every branch
  (`Web.consumed_held_not_endless`, `Web.family_excess_not_endless`, `Web.stopped_not_endless`),
  with witnesses whose lines take a step first; the relay renews and still ends
  (`Map.relay_renews_and_ends`). Imported by `Becoming.KeepingWidening`."""),
("""  only returns (`KindRelay.Runs.generation_two_orders`, `KindRelay.returns`). Witnesses show each
  premise needed""","""  only returns (`KindRelay.Runs.generation_two_orders`, `KindRelay.returns`). Wherever a uniform
  horizon is known, the kind grain degenerates (`Web.kind_every_branch_ends_of_gone`, the kind
  instance of MapInstances' law, witnessed by `Map.Undecided.kind_degenerates`), the other side of
  its generation laws; the horizon is a modelling choice. Witnesses show each
  premise needed"""),
("""  EventualWidening with Gain, Flow and the map (board items UE7, GW); imported by
  `Becoming.WideningOnTheMap`.""","""  EventualWidening with Gain, Flow and the map (board items UE7, GW); imported by
  `Becoming.WideningOnTheMap` and `Becoming.LineageRegions`."""),
])
print('ok')
