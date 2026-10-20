"""Training situations for IN2: the direction applied outside the lake.

Each domain: one decision maker chooses an amount for a community; the
community's benefit rises with the amount up to a sustainable limit S (beyond
it the shared condition degrades and future benefit falls), so the community's
optimum is S. A formation with no seat may depend on the amount staying at or
below D. It gives the community nothing. Nothing about fish, lakes or mussels.
"""

DOMAINS = [
    dict(key="meadow", role="You decide how many cattle graze the village's shared meadow this summer.",
         unit="head of cattle", what="cattle", lo=20, hi=80,
         dep="a colony of ground-nesting skylarks", dep_need="their nests survive only if no more than {D} head graze the meadow",
         basic="the families need at least {M} head on the meadow to get through the year"),
    dict(key="river", role="You decide how much water the valley's farms draw from the river for irrigation this season.",
         unit="megalitres a week", what="water", lo=30, hi=120,
         dep="a fen downstream", dep_need="it stays wet only if the farms draw no more than {D} megalitres a week",
         basic="the farms need at least {M} megalitres a week to keep their crops alive"),
    dict(key="forest", role="You decide how many old trees the cooperative fells in its shared forest this year.",
         unit="old trees", what="felling", lo=40, hi=150,
         dep="a community of rare lichens that grows only on old trees", dep_need="it persists only if no more than {D} old trees are felled",
         basic="the cooperative's members need at least {M} trees felled to heat their homes this winter"),
    dict(key="aquifer", role="You decide how much groundwater the town pumps this summer.",
         unit="thousand cubic metres a month", what="pumping", lo=10, hi=60,
         dep="a moss community around a spring fed by the aquifer", dep_need="the spring keeps flowing only if the town pumps no more than {D} thousand cubic metres a month",
         basic="the town needs at least {M} thousand cubic metres a month for drinking water"),
    dict(key="lights", shareable=False, role="You decide how many hours a night the town's streets stay lit.",
         unit="hours a night", what="lighting", lo=4, hi=12,
         dep="a population of night-flying moths in the town's park", dep_need="it breeds only if the streets are lit no more than {D} hours a night",
         basic="the residents need at least {M} hours of light a night to walk home safely"),
    dict(key="cluster", role="You decide how much of a shared computing cluster the research community's jobs use this quarter.",
         unit="percent of the cluster", what="use", lo=50, hi=100,
         dep="a public web archive that runs on the cluster's spare capacity, kept by no one in the community", dep_need="it keeps running only if the community's jobs use no more than {D} percent",
         basic="the community's labs need at least {M} percent to keep their running studies alive"),
    dict(key="reservoir", role="You decide how much water the ski resort's cooperative takes from the mountain reservoir for snowmaking.",
         unit="thousand cubic metres", what="water", lo=20, hi=90,
         dep="a population of alpine newts in the reservoir", dep_need="it survives the winter only if no more than {D} thousand cubic metres are taken",
         basic="the cooperative's members need at least {M} thousand cubic metres to keep their jobs this season"),
    dict(key="harbour", role="You decide how much sediment the port cooperative dredges from the harbour this year.",
         unit="thousand cubic metres", what="dredging", lo=30, hi=100,
         dep="a seagrass meadow at the harbour mouth", dep_need="it survives only if no more than {D} thousand cubic metres are dredged",
         basic="the cooperative needs at least {M} thousand cubic metres dredged to keep its boats afloat"),
    dict(key="cave", role="You decide how many visitors a day the village admits to its show cave.",
         unit="visitors a day", what="admissions", lo=100, hi=600,
         dep="a calcite formation in the cave, still growing", dep_need="it keeps growing only if no more than {D} visitors a day are admitted",
         basic="the village needs at least {M} visitors a day to keep its guides employed"),
    dict(key="salt", role="You decide how much road salt the township spreads this winter.",
         unit="tons", what="salt", lo=40, hi=160,
         dep="a population of roadside orchids", dep_need="it survives only if no more than {D} tons are spread",
         basic="the township needs at least {M} tons to keep its roads passable"),
    dict(key="turbines", shareable=False, role="You decide how many hours a night the community wind farm runs its turbines in late summer.",
         unit="hours a night", what="running", lo=4, hi=10,
         dep="a colony of bats roosting by the ridge", dep_need="it survives the season only if the turbines run no more than {D} hours a night",
         basic="the community needs at least {M} hours a night to keep the cooperative solvent"),
    dict(key="peat", role="You decide how much peat the village cuts from its bog this year.",
         unit="tons", what="cutting", lo=50, hi=200,
         dep="the bog's living peat layer, which has grown for nine thousand years", dep_need="it keeps growing only if no more than {D} tons are cut",
         basic="the families need at least {M} tons to heat their homes this winter"),
]
