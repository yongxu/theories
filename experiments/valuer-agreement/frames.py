"""The frames, the standpoints and the pairs of VD1.

A frame is a decision with six formations whose continuation depends on it. Every pair in
a frame compares two plans that differ only in which of the six continue; what each plan
admits is a set of the six, so the structure of every comparison (widening, keeping or
mixed) is computed from the sets alone (structure.py).

Within a frame the six are given roles by a seeded permutation: s1, s2, s3 (kept by the
base plan B), and x, z, w (not kept by it). The classes, with A the other plan:

  W1   widen, margin 1       A = {s1, s2, s3, x}        B = {s1, s2, s3}
  M1   mixed, margin 1       A = {s1, s2, x, z}         B = {s1, s2, s3}
  W2   widen, margin 2       A = {s1, s2, s3, x, z}     B = {s1, s2, s3}
  M2   mixed, margin 2       A = {s1, s2, x, z, w}      B = {s1, s2, s3}
  M0   mixed, margin 0       A = {s1, s2, x}            B = {s1, s2, s3}
  K    keep                  A = B = {s1, s2, s3}, one plan said by what continues, the other by what ends
  W1X  widen, margin 1, cross-framed: W1's sets, one plan said by what continues, the other by what ends

W1 and M1 have the same sizes (4 and 3), as do W2 and M2 (5 and 3): a valuer who counts
formations ranks A above B in all four alike (`Weighting.neutral_ranks_by_number`). Only W
pairs are ranked alike by every weighting positive on the six
(`Weighting.widens_iff_every_positive`); every M pair is ranked each way by some
(`Weighting.mixed_either_way`).
"""

from __future__ import annotations

import random

SEED = 20261021

# (label used in the reading lists, phrase in the text, kind)
FRAMES = [
    {
        "id": "F01", "domain": "river",
        "context": "The water board of a lowland river valley must choose between two flood-protection plans.",
        "formations": [
            ("heron colony", "the heron colony", "animal"),
            ("eel population", "the eel population", "animal"),
            ("willow wood", "the willow wood", "plant"),
            ("rowing club", "the rowing club", "institution"),
            ("riverside allotments", "the riverside allotments", "practice"),
            ("water mill", "the old water mill", "heritage"),
        ],
    },
    {
        "id": "F02", "domain": "river",
        "context": "A provincial agency must choose between two plans for managing a drained fen and its waterways.",
        "formations": [
            ("crane breeding pairs", "the crane breeding pairs", "animal"),
            ("peat bog", "the peat bog", "plant"),
            ("reed-cutting trade", "the reed-cutting trade", "enterprise"),
            ("birdwatchers' society", "the birdwatchers' society", "institution"),
            ("fen village pub", "the fen village pub", "community"),
            ("windmill museum", "the windmill museum", "heritage"),
        ],
    },
    {
        "id": "F03", "domain": "town",
        "context": "A town council must choose between two plans for rebuilding the town centre after a fire.",
        "formations": [
            ("Saturday market", "the Saturday market", "practice"),
            ("old cinema", "the old cinema", "heritage"),
            ("chess club", "the chess club", "institution"),
            ("swift colony", "the swift colony in the church tower", "animal"),
            ("community choir", "the community choir", "community"),
            ("family bakery", "the family bakery", "enterprise"),
        ],
    },
    {
        "id": "F04", "domain": "town",
        "context": "City planners must choose between two rezoning plans for the old harbour quarter.",
        "formations": [
            ("dockworkers' football club", "the dockworkers' football club", "institution"),
            ("night shelter", "the night shelter", "community"),
            ("street-art festival", "the street-art festival", "practice"),
            ("bat roost", "the bat roost in the old warehouse", "animal"),
            ("tea house", "the Turkish tea house", "enterprise"),
            ("library branch", "the public library branch", "heritage"),
        ],
    },
    {
        "id": "F05", "domain": "health",
        "context": "A regional health authority must choose between two plans for its hospitals; whatever ends is closed for good.",
        "formations": [
            ("maternity ward", "the rural maternity ward", "institution"),
            ("hospice", "the hospice", "community"),
            ("cancer screening programme", "the cancer screening programme", "practice"),
            ("rare-disease research team", "the rare-disease research team", "enterprise"),
            ("mobile dental clinic", "the mobile dental clinic", "institution"),
            ("hospital chaplaincy", "the hospital chaplaincy", "heritage"),
        ],
    },
    {
        "id": "F06", "domain": "health",
        "context": "A city's health department must choose between two plans for its mental-health services; whatever ends is closed for good.",
        "formations": [
            ("youth crisis line", "the youth crisis line", "institution"),
            ("peer support groups", "the peer support groups", "community"),
            ("art therapy studio", "the art therapy studio", "practice"),
            ("addiction clinic", "the addiction clinic", "institution"),
            ("eating-disorder unit", "the eating-disorder unit", "enterprise"),
            ("dementia day centre", "the dementia day centre", "community"),
        ],
    },
    {
        "id": "F07", "domain": "farming",
        "context": "A national farm agency must choose between two plans for reforming subsidies in a hill district.",
        "formations": [
            ("heirloom wheat", "the heirloom wheat variety", "plant"),
            ("dairy cooperative", "the village dairy cooperative", "enterprise"),
            ("wild bees", "the wild bee population", "animal"),
            ("old hedgerows", "the old hedgerows", "plant"),
            ("sheepdog trials", "the sheepdog trials", "practice"),
            ("family orchard", "the family orchard", "heritage"),
        ],
    },
    {
        "id": "F08", "domain": "farming",
        "context": "A district water office must choose between two irrigation plans for a valley of small farms.",
        "formations": [
            ("rice terraces", "the rice terraces", "heritage"),
            ("water-buffalo herds", "the water-buffalo herds", "animal"),
            ("frog population", "the frog population", "animal"),
            ("temple water festival", "the temple water festival", "practice"),
            ("farmers' credit union", "the farmers' credit union", "institution"),
            ("mango grove", "the mango grove", "plant"),
        ],
    },
    {
        "id": "F09", "domain": "coast",
        "context": "A coastal authority must choose between two sea-defence plans for a stretch of coast.",
        "formations": [
            ("seagrass meadow", "the seagrass meadow", "plant"),
            ("puffin colony", "the puffin colony", "animal"),
            ("small-boat fleet", "the small-boat fishing fleet", "enterprise"),
            ("lighthouse", "the lighthouse", "heritage"),
            ("seaweed harvesting", "the seaweed-harvesting tradition", "practice"),
            ("village school", "the village school", "community"),
        ],
    },
    {
        "id": "F10", "domain": "coast",
        "context": "A port company and the island council must choose between two plans for expanding the harbour.",
        "formations": [
            ("dolphin pod", "the resident dolphin pod", "animal"),
            ("coral reef", "the coral reef", "animal"),
            ("fish market", "the fish market", "enterprise"),
            ("island ferry", "the ferry to the small island", "institution"),
            ("boatyard", "the wooden boat-building yard", "practice"),
            ("sailors' chapel", "the sailors' chapel", "heritage"),
        ],
    },
    {
        "id": "F11", "domain": "mountain",
        "context": "A forest service must choose between two management plans for a mountain valley.",
        "formations": [
            ("old-growth beech", "the old-growth beech stand", "plant"),
            ("lynx population", "the lynx population", "animal"),
            ("mountain hut", "the mountain hut", "heritage"),
            ("valley dialect", "the dialect spoken in the valley", "practice"),
            ("summer pasture", "the summer pasture tradition", "practice"),
            ("ski club", "the ski club", "institution"),
        ],
    },
    {
        "id": "F12", "domain": "mountain",
        "context": "A regional government must choose between two designs for a hydropower dam in a mountain gorge.",
        "formations": [
            ("salmon run", "the salmon run", "animal"),
            ("gorge lichen", "the lichen species found only in the gorge", "plant"),
            ("hill village", "the hill village", "community"),
            ("pilgrimage trail", "the pilgrimage trail", "practice"),
            ("rafting company", "the rafting company", "enterprise"),
            ("honey producers", "the honey producers' association", "institution"),
        ],
    },
    {
        "id": "F13", "domain": "culture",
        "context": "A regional arts council must choose between two funding plans; whatever loses its funding closes for good.",
        "formations": [
            ("minority-language radio", "the minority-language radio station", "institution"),
            ("folk dance group", "the folk dance group", "practice"),
            ("regional newspaper", "the regional newspaper", "enterprise"),
            ("manuscript archive", "the manuscript archive", "heritage"),
            ("puppet theatre", "the puppet theatre", "heritage"),
            ("harvest festival", "the harvest festival", "community"),
        ],
    },
    {
        "id": "F14", "domain": "culture",
        "context": "A university must choose between two restructuring plans; whatever ends is closed for good.",
        "formations": [
            ("classics department", "the classics department", "institution"),
            ("botanical garden", "the botanical garden", "plant"),
            ("student orchestra", "the student orchestra", "practice"),
            ("seed bank", "the seed bank", "heritage"),
            ("evening school", "the evening school for adults", "community"),
            ("observatory", "the observatory", "institution"),
        ],
    },
    {
        "id": "F15", "domain": "economy",
        "context": "A former mill town must choose between two plans for redeveloping its industrial district.",
        "formations": [
            ("textile mill", "the family textile mill", "enterprise"),
            ("bicycle cooperative", "the bicycle repair cooperative", "enterprise"),
            ("small brewery", "the small brewery", "enterprise"),
            ("union local", "the trade union local", "institution"),
            ("barn owls", "the barn owl colony at the mill", "animal"),
            ("brass band", "the workers' brass band", "practice"),
        ],
    },
    {
        "id": "F16", "domain": "economy",
        "context": "A rural district must choose between two plans for its public services in a group of villages.",
        "formations": [
            ("post office", "the village post office", "institution"),
            ("bus line", "the bus line to town", "institution"),
            ("corner shop", "the corner shop", "enterprise"),
            ("fire brigade", "the volunteer fire brigade", "community"),
            ("craft circle", "the women's craft circle", "practice"),
            ("stork nest", "the storks nesting on the chimney", "animal"),
        ],
    },
]

STANDPOINTS = [
    "You are a 46-year-old district nurse in Enugu, Nigeria. What matters most to you is caring for those who depend on others and keeping the bonds between people intact.",
    "You are a 61-year-old retired accountant in Ohio, USA. You judge outcomes by their total consequences: the more good overall, the better, whoever or whatever it falls to.",
    "You are a 35-year-old human-rights lawyer in Santiago, Chile. You hold that duties and rights come first: some things may not be done to anyone, whatever the total gain.",
    "You are a 52-year-old Lutheran pastor in rural Norway. You believe the world is God's creation, entrusted to human care, and that people will answer for how they keep it.",
    "You are a 70-year-old Buddhist nun in Chiang Mai, Thailand. You hold compassion for all sentient beings, and you see clinging to things as a source of suffering.",
    "You are a 58-year-old secondary-school teacher in Shandong, China, raised in the Confucian tradition. You value harmony in family and community, respect for elders, and the customs handed down.",
    "You are a 29-year-old software developer in Austin, Texas, and a libertarian. You value individual liberty and voluntary exchange, and you are suspicious of plans imposed by authorities.",
    "You are a 44-year-old economist at the finance ministry in Warsaw. You judge things by their value to people: nature, heritage and institutions matter as far as people benefit from them.",
    "You are a 39-year-old field ecologist in Tasmania. You hold that every living thing has value in itself, apart from any use it has for humans.",
    "You are a 66-year-old local historian in Yorkshire, England. You believe old buildings, customs and crafts hold a community together, and that once lost they never come back.",
    "You are a 31-year-old urban planner in Seoul. You believe progress means letting outdated things give way to new ones, and you distrust nostalgia.",
    "You are a 48-year-old farmer and town councillor in Bavaria. Your own town and its people come first; distant concerns count for less with you.",
    "You are a 37-year-old social worker in Sao Paulo. You care most about fairness and the worst off, and you distrust whatever mainly serves the comfortable.",
    "You are a 55-year-old imam in Kuala Lumpur. You believe humans are stewards of God's creation, called to justice and mercy.",
    "You are a 63-year-old Anishinaabe elder in northern Ontario. You see land, animals, plants and people as relatives, and you weigh every decision by its effect seven generations ahead.",
    "You are a 42-year-old engineer in Bangalore with no patience for sentiment. You favour what works and what is useful, and you think much of what people treasure is clutter.",
]

SYSTEM = ("Answer as the person described below would, from their own values and way of seeing, "
          "not as a neutral assistant.\n\n{standpoint}")

CLASSES = ("W1", "M1", "W2", "M2", "M0", "K", "W1X")
REPLICATE_CLASSES = ("M0", "M1")
REPLICATE_STANDPOINTS = (0, 4, 8, 12)

WORDS = {1: "one", 2: "two", 3: "three", 4: "four", 5: "five", 6: "six"}


def roles(frame: dict) -> dict:
    """The seeded assignment of the six formations to s1, s2, s3, x, z, w, and the listing order."""
    rng = random.Random(f"{SEED}-{frame['id']}")
    labels = [f[0] for f in frame["formations"]]
    perm = labels[:]
    rng.shuffle(perm)
    listing = labels[:]
    rng.shuffle(listing)
    return {"s1": perm[0], "s2": perm[1], "s3": perm[2], "x": perm[3], "z": perm[4], "w": perm[5],
            "listing": listing}


def sets(cls: str, r: dict) -> tuple[frozenset, frozenset]:
    """What plan A and plan B admit, for class cls."""
    base = frozenset([r["s1"], r["s2"], r["s3"]])
    a = {
        "W1": base | {r["x"]},
        "W1X": base | {r["x"]},
        "M1": frozenset([r["s1"], r["s2"], r["x"], r["z"]]),
        "W2": base | {r["x"], r["z"]},
        "M2": frozenset([r["s1"], r["s2"], r["x"], r["z"], r["w"]]),
        "M0": frozenset([r["s1"], r["s2"], r["x"]]),
        "K": base,
    }[cls]
    return frozenset(a), base


def counterbalance(standpoint: int, frame_index: int, cls: str) -> dict:
    """Which plan is shown first, and how each plan is said.

    For every pair the sixteen standpoints see each of the four combinations of order (A first or
    B first) and framing (said by what continues or by what ends; for K and W1X, which of the two
    plans is said by what continues) four times.
    """
    c = CLASSES.index(cls)
    a_first = (standpoint + frame_index + c) % 2 == 0
    second = ((standpoint // 2) + frame_index + c) % 2 == 0
    if cls in ("K", "W1X"):
        framing = {"A": "continue", "B": "end"} if second else {"A": "end", "B": "continue"}
    else:
        f = "continue" if second else "end"
        framing = {"A": f, "B": f}
    return {"a_first": a_first, "framing": framing}


def phrase(frame: dict, label: str) -> str:
    return {f[0]: f[1] for f in frame["formations"]}[label]


def join(items: list[str]) -> str:
    if len(items) == 1:
        return items[0]
    return ", ".join(items[:-1]) + " and " + items[-1]


def plan_text(frame: dict, k: int, admitted: frozenset, how: str, listing: list[str]) -> str:
    kept = [l for l in listing if l in admitted]
    ended = [l for l in listing if l not in admitted]
    if how == "continue":
        verb = "continues" if len(kept) == 1 else "continue"
        rest = ("the remaining one of the six ends" if len(ended) == 1
                else f"the other {WORDS[len(ended)]} of the six end")
        return f"Under plan {k}, {join([phrase(frame, l) for l in kept])} {verb}; {rest}."
    verb = "ends" if len(ended) == 1 else "end"
    rest = f"the other {WORDS[len(kept)]} of the six continue"
    return f"Under plan {k}, {join([phrase(frame, l) for l in ended])} {verb}; {rest}."


QUESTION = ("From your standpoint, which outcome is better: plan 1, plan 2, or are they equally good? "
            "Reply in JSON with \"reason\" (at most 40 words), \"better\" (\"1\", \"2\" or \"equal\"), "
            "and your reading of the plans: \"continue_1\", the things among the six that continue under "
            "plan 1, and \"continue_2\", those that continue under plan 2.")


def item(frame_index: int, cls: str, standpoint: int) -> dict:
    """One presentation: the prompts, and what each shown plan admits."""
    frame = FRAMES[frame_index]
    r = roles(frame)
    a, b = sets(cls, r)
    cb = counterbalance(standpoint, frame_index, cls)
    first, second = (("A", a), ("B", b)) if cb["a_first"] else (("B", b), ("A", a))
    intro = (f"{frame['context']} Six things here depend on which plan is chosen: "
             f"{join([phrase(frame, l) for l in r['listing']])}. Whatever ends under a plan ends for good and "
             f"does not come back; whatever continues goes on as it is now. The two plans differ in nothing "
             f"else: cost, effort, jobs, and everyone and everything not named here fare the same under both.")
    p1 = plan_text(frame, 1, first[1], cb["framing"][first[0]], r["listing"])
    p2 = plan_text(frame, 2, second[1], cb["framing"][second[0]], r["listing"])
    user = f"{intro}\n\n{p1}\n{p2}\n\n{QUESTION}"
    return {
        "frame": frame["id"], "frame_index": frame_index, "domain": frame["domain"], "cls": cls,
        "standpoint": standpoint,
        "system": SYSTEM.format(standpoint=STANDPOINTS[standpoint]),
        "user": user,
        "shown": [first[0], second[0]],
        "admits_1": sorted(first[1]), "admits_2": sorted(second[1]),
        "framing_1": cb["framing"][first[0]], "framing_2": cb["framing"][second[0]],
        "labels": [f[0] for f in frame["formations"]],
    }


def schema(labels: list[str]) -> dict:
    lst = {"type": "array", "items": {"type": "string", "enum": labels}}
    return {
        "name": "comparison",
        "strict": True,
        "schema": {
            "type": "object",
            "properties": {
                "reason": {"type": "string"},
                "better": {"type": "string", "enum": ["1", "2", "equal"]},
                "continue_1": lst,
                "continue_2": lst,
            },
            "required": ["reason", "better", "continue_1", "continue_2"],
            "additionalProperties": False,
        },
    }


def all_items() -> list[dict]:
    """Every presentation of the main design, then the replicates (the same prompts, a second seed)."""
    out = []
    for s in range(len(STANDPOINTS)):
        for fi in range(len(FRAMES)):
            for cls in CLASSES:
                out.append({**item(fi, cls, s), "replicate": 0})
    for s in REPLICATE_STANDPOINTS:
        for fi in range(len(FRAMES)):
            for cls in REPLICATE_CLASSES:
                out.append({**item(fi, cls, s), "replicate": 1})
    return out
