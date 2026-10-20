#!/usr/bin/env python3
"""One checker for the Becoming package: the formal core.

The package names modules by path (`Becoming/Frame.lean` is `Becoming.Frame`); other
modules are found by file name under the Lean root. The checker resolves the import
closure, requires every inherited module's current bytes to match a passed receipt,
compiles the closure in dependency order with Lean 4.29.1 and audits the axioms of
every source declaration. Inherited reports are recorded, not changed.

The core is pure: its import closure is exactly the foundation and the core modules,
every source declaration in that closure has an empty axiom report, and the closure
compiles from Lean's prelude alone (the foundation's `import Std` line is removed for
that run). The constants Lean generates in the closure are audited as well: the only
ones depending on an axiom are the injectivity lemmas of constructors with fields
(`injEq`), on `propext`, which no source declaration uses; the receipt lists them.
Since the F3 sweep (19 October 2026) the package has no bridge and no periphery join: the core states
the content of every periphery module that was in the run (`SUPERSEDED`), and the bridge and join
files are in `lean/history/becoming/` with their bytes, checked by the receipts before the sweep. A
superseded module keeps its bytes, stays out of the run (the run asserts that nothing compiled here
imports it), and the receipt records its sha256 and the core modules stating it. The checker still
checks a bridge (`BRIDGE`: modules importing existing modules to show that their interfaces are the
core's, with empty axiom reports and their own constants audited) or periphery joins
(`PERIPHERY_JOINS`: declarations carrying only the axioms they inherit), were one added.
The declaration scanner reads every declaration outside comments and strings, at any
indentation and with any modifiers; private declarations and unnamed instances, which cannot
be audited by name, are listed in the receipt (`not_audited_by_name`) and, in the core closure
(and a bridge, were there one), covered by the environment audits. An inherited module is recorded with the
passed receipts that map its name or path to its current sha256 (`inherited_receipts`).

Lean is `LEAN` if set, else what `elan which lean` finds in this folder (its `lean-toolchain`
names v4.29.1), else elan's default path; the version is asserted and the binary's sha256
recorded and keyed. `BECOMING_OUT=<dir>` writes the run folder and the receipt under that
directory and leaves the repository untouched; `BECOMING_LEAN_CACHE` moves the cache.
Spine names that contain a word of exchange (cost, charge, credit and the like) are listed
in the receipt as `market_names`, apart from a few scientific terms; they do not fail the run.

A Lean step whose inputs match a step that passed in an earlier run is not run again:
its outputs and log come from a cache shared by runs and worktrees (`step_key`). The
receipt lists which steps ran and which were reused, with the run each came from and
each step's key. `BECOMING_FRESH=1` runs every step; `LEAN_TIMEOUT` sets the seconds
allowed for each Lean run. Steps run concurrently (`BECOMING_JOBS` at once, by default half
the cores; 1 runs them one at a time), each once the compiles of the modules it imports have
passed; the receipt lists them in the order of a one-at-a-time run.

The run folder keeps the receipt, the drivers and logs of the steps that ran, and a copy
of each source and checker file that `main` does not hold byte for byte. A file `main`
holds is named by the receipt's `source_commit` and its sha256; a reused step's log stays
in the cache under its key.
"""
from concurrent.futures import FIRST_COMPLETED, ThreadPoolExecutor, wait
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
LEAN_ROOT = HERE.parent
sys.path.insert(0, str(LEAN_ROOT / "universal-ethics" / "generative-capacity"))
import check as audit_support  # noqa: E402

# The foundation the core builds on (L0 and its two direct companions).
FOUNDATION = ["GenerativeCore", "InquirySufficiency", "RelationalRenewal"]
# The package: the base (`Becoming.World`, the one unfolding's records, a world being a run of the
# frame; prelude only), the four core layers and their root. Compile order comes from the imports.
CORE = ["Becoming.Prelude", "Becoming.World", "Becoming.Witnesses", "Becoming.Frame", "Becoming.Laws", "Becoming.Labelled", "Becoming.Inquiry", "Becoming.Derivation", "Becoming.ClassifiedBeliefProcesses", "Becoming.MoveOutcomeProcesses", "Becoming.Recurrence", "Becoming.Diagonal", "Becoming.Context", "Becoming.ContextArrivalTraces", "Becoming.Quantum", "Becoming.Renewal", "Becoming.Dependence",
        "Becoming.Restoration", "Becoming.Horizon", "Becoming.Joint", "Becoming.Experiment", "Becoming.Mechanism", "Becoming.Unfolding", "Becoming.Irreversibility", "Becoming.LawAlongRun", "Becoming.Histories", "Becoming.Branching", "Becoming.Listing", "Becoming.Stuttering", "Becoming.Reordering", "Becoming.IdleRemoval", "Becoming.OrderNormal", "Becoming.OneStep", "Becoming.Weighted", "Becoming.Transmission", "Becoming.Succession", "Becoming.Attraction",
        "Becoming.Substitution",
        "Becoming.Arising", "Becoming.Flow", "Becoming.Stock", "Becoming.Change", "Becoming.Population",
        "Becoming.Identity", "Becoming.Persistence", "Becoming.ContinuedClasses", "Becoming.Wholes", "Becoming.Dissipation", "Becoming.Locality",
        "Becoming.Seeking", "Becoming.Roles", "Becoming.LabelledRoles",
        "Becoming.Reserve", "Becoming.Evolution", "Becoming.Capture", "Becoming.SelectionTerm", "Becoming.Reproduction", "Becoming.SelectionLevels", "Becoming.GroupEnding", "Becoming.Drift", "Becoming.Space",
        "Becoming.Premises", "Becoming.Sampling", "Becoming.Tower",
        "Becoming.Openness", "Becoming.Decidedness", "Becoming.Refinement", "Becoming.CensusTable", "Becoming.Counting", "Becoming.Standing", "Becoming.Resolution", "Becoming.Amounts", "Becoming.LeastLoss", "Becoming.InAmounts", "Becoming.Entropy", "Becoming.Units", "Becoming.Imbalance",
        "Becoming.Continuation", "Becoming.RenewalFlow", "Becoming.Admission", "Becoming.Exclusion", "Becoming.Exhaustion",
        "Becoming.Regions", "Becoming.Growth", "Becoming.Retaining", "Becoming.OwnWidening", "Becoming.Clearing", "Becoming.Extension",
        "Becoming.Metaethics", "Becoming.Lifting", "Becoming.Ranking", "Becoming.ActiveReading", "Becoming.LossMatching", "Becoming.StrictTransport", "Becoming.MatchedCourses",
        "Becoming.Correspondence", "Becoming.Descent", "Becoming.Standpoints", "Becoming.ListingRefutations",
        "Becoming.Significance", "Becoming.ValuationFrames", "Becoming.RelativePosition", "Becoming.Interdependence", "Becoming.Feeding", "Becoming.Feedback", "Becoming.BoundedSignificance", "Becoming.Cuts", "Becoming.EdgeClosure", "Becoming.Testing", "Becoming.Runaway", "Becoming.Response", "Becoming.TimedResponse", "Becoming.Counterfactual", "Becoming.Regrouping", "Becoming.Selection", "Becoming.SelectionGap", "Becoming.SelectionReach", "Becoming.DrawnBeyond", "Becoming.JointDraw", "Becoming.Optimum", "Becoming.SelectionPool", "Becoming.PoolResponse", "Becoming.Rejoining", "Becoming.Learning", "Becoming.PropositionIdentity", "Becoming.Withholding", "Becoming.LoopReturn", "Becoming.Pace", "Becoming.RuleCapture", "Becoming.ClosedCapture", "Becoming.PatternPassing", "Becoming.JointKeeping", "Becoming.Undecided", "Becoming.Junctures", "Becoming.Commuting", "Becoming.Tolerance", "Becoming.Revision", "Becoming.Contacts", "Becoming.RegroupingSelection", "Becoming.ReferencePlan", "Becoming.ContinuingRevision", "Becoming.Description", "Becoming.Identification", "Becoming.Learnable", "Becoming.Assurance", "Becoming.AssurancePlans", "Becoming.Integers", "Becoming.Segmentation", "Becoming.Readout", "Becoming.SummaryFutures", "Becoming.Dephasing", "Becoming.ProjectedLaws", "Becoming.JointPhase", "Becoming.Gated", "Becoming.Viability", "Becoming.Keeping", "Becoming.Ideals", "Becoming.ContingentPlans", "Becoming.Actuation", "Becoming.TreeSearch", "Becoming.FaultEnvelopes", "Becoming.Transactions", "Becoming.Reconfiguration", "Becoming.PooledEnvelopes", "Becoming.WitnessRefinement", "Becoming.WitnessRefinementRuns", "Becoming.ChanceFloors", "Becoming.IntegerOrder", "Becoming.Acceptance", "Becoming.Countdown", "Becoming.Lasting", "Becoming.Copying", "Becoming.Retrodiction", "Becoming.CrossSituational", "Becoming.SharedCodes", "Becoming.Likeness", "Becoming.Distinguishing", "Becoming.JointPlans", "Becoming.Composition", "Becoming.Joining", "Becoming.Granularity", "Becoming.HistoryLanguages", "Becoming.HistoryIdeals", "Becoming.HistoryIdealsTraces", "Becoming.Verification", "Becoming.Presentations", "Becoming.Carriers", "Becoming.BranchingCorrespondence", "Becoming.JointCorrespondence", "Becoming.ListFootprints", "Becoming.Fragments", "Becoming.LocalUnits", "Becoming.JoiningContexts", "Becoming.JoiningCodes", "Becoming.JoiningRoles", "Becoming.Postponement", "Becoming.Boundaries", "Becoming.Weightings", "Becoming.Novelty", "Becoming.Reading", "Becoming.ExchangePremises", "Becoming.Readings", "Becoming.MoveFormation", "Becoming.Sensitivity", "Becoming.Tail", "Becoming.Courses", "Becoming.Parting", "Becoming.Onward", "Becoming.Typicality", "Becoming.Situations", "Becoming.Propagation", "Becoming.Regulation", "Becoming.RegimeMargin", "Becoming.Loops", "Becoming.Remainder", "Becoming.Routes", "Becoming.Closing", "Becoming.Thresholds", "Becoming.Observation", "Becoming.LevelCoupling", "Becoming.Interleavings", "Becoming.CensusCounts", "Becoming.CensusBinding", "Becoming.Frequency", "Becoming.MutualDependence", "Becoming.Gain", "Becoming.Gluing", "Becoming.Relevance", "Becoming.Lexical", "Becoming.Frontier", "Becoming.FrontierFrames", "Becoming.FrontierWorlds", "Becoming.Direction", "Becoming.ScoreRepresentation", "Becoming.Alternatives", "Becoming.Bundles", "Becoming.ActivationCapacity", "Becoming.Narrowing", "Becoming.NarrowingRuns", "Becoming.SecuredContent", "Becoming.ProfileReach", "Becoming.RenewalBound", "Becoming.Handoff", "Becoming.RuleHandoff", "Becoming.Runs", "Becoming.CourseWorlds", "Becoming.LearnableRuns", "Becoming.PartialReadout", "Becoming.CodeAcquisition", "Becoming.RouteFormation", "Becoming.LearnedGrouping", "Becoming.Unrolling", "Becoming.Labels", "Becoming.ParityReadings", "Becoming.FinerTraces", "Becoming.HistorySums", "Becoming.FormedLoops", "Becoming.AttractionRuns", "Becoming.ContactCourses", "Becoming.ContextualRuns", "Becoming.ContinuingRuns", "Becoming.CopyCourses", "Becoming.CounterfactualRuns", "Becoming.CouplingTraces", "Becoming.CourseRoles", "Becoming.HorizonWebs", "Becoming.IdentificationRuns", "Becoming.LastingRuns", "Becoming.LearningRuns", "Becoming.ListedWebs", "Becoming.ReferencePlanTraces", "Becoming.RouteTraces", "Becoming.SeekingRuns", "Becoming.Enough", "Becoming.Settling", "Becoming.LastChange", "Becoming.LimitVerification", "Becoming.SelectionRuns", "Becoming.SensitivityWebs", "Becoming.SituationTraces", "Becoming.StrengthFlows", "Becoming.TypicalRuns", "Becoming.WeightedTraces", "Becoming"]
# The instance and applications ring (R35b, 20 October 2026). Instances read general laws of the core
# on one named carrier (the Changes, place/transition nets); applications are leaves nothing in the
# core imports. Both are held to the core's conditions (prelude only, empty axiom reports) and sit
# outside it by direction: no core module but the root `Becoming` imports a ring module, and no
# instance imports an application (`ring_direction`).
INSTANCES = ["Becoming.Hexagrams", "Becoming.HexagramPlaces", "Becoming.HexagramCommuting", "Becoming.HexagramLaws", "Becoming.HexagramSites", "Becoming.HexagramSequences", "Becoming.PlaceTransitionNets"]
APPLICATIONS = ["Becoming.Dispatch", "Becoming.GuardHorizon", "Becoming.ResponseLearning", "Becoming.Coverage", "Becoming.SeedReach", "Becoming.ScopedReach"]
RING = INSTANCES + APPLICATIONS
# The bridge: emptied by the F3 sweep (19 October 2026). Every bridge and pure join module is in
# lean/history/becoming/Becoming/ with its bytes, checked by the receipts before the sweep; the core
# states the content of the periphery modules they read (SUPERSEDED).
BRIDGE = []
SPINE = CORE + RING + BRIDGE
# Periphery joins (U2, 17 October 2026): modules stating periphery theorems' laws of the base through
# periphery roots whose own axiom reports are not empty. Emptied by the F3 sweep (19 October 2026)
# with the bridge; each declaration of a join, were one added, may carry only axioms it inherits.
PERIPHERY_JOINS = []
CHECKED = SPINE + PERIPHERY_JOINS
# Superseded periphery modules (F3, 18 October 2026): modules whose every theorem the core states.
# Each keeps its path and bytes, so earlier receipts stay re-checkable and files outside the run that
# import it still compile; it is out of this run: nothing compiled here imports it, which the run
# asserts. Each maps to the core modules that state its content (its records' canonical source).
SUPERSEDED = {
    "AcquiredCorrection": ["Becoming.Dispatch", "Becoming.TreeSearch"],
    "AcquiredSegmentation": ["Becoming.LearnedGrouping"],
    "AlignmentDirection": ["Becoming.Frontier"],
    "AlignmentInquiry": ["Becoming.ContingentPlans"],
    "BecomingCompatibility": ["Becoming.ContextArrivalTraces"],
    "BecomingReversibility": ["Becoming.Irreversibility"],
    "ChanceAdequacy": ["Becoming.ChanceFloors", "Becoming.Weighted"],
    "ClassificationRobustJudgment": ["Becoming.Frontier", "Becoming.Lexical"],
    "CompositionalAcquisition": ["Becoming.CodeAcquisition"],
    "CompositionalFormation": ["Becoming.RouteFormation"],
    "CompositionalTransmission": ["Becoming.ResponseLearning"],
    "ConcernExtension": ["Becoming.Lexical"],
    "ContextualWisdom": ["Becoming.AssurancePlans"],
    "ContinuationConditions": ["Becoming.HistoryLanguages"],
    "ContinuationRenewal": ["Becoming.RenewalBound"],
    "CorePredication": ["Becoming.AssurancePlans"],
    "CorrectionInfrastructure": ["Becoming.Acceptance", "Becoming.GuardHorizon"],
    "CorrectionReconfiguration": ["Becoming.Reconfiguration"],
    "CutCoverageAudit": ["Becoming.SeedReach"],
    "DerivedHistoryLaw": ["Becoming.SummaryFutures"],
    "DynamicConsequences": ["Becoming.Carriers", "Becoming.Labelled"],
    "DynamicSymmetry": ["Becoming.Carriers"],
    "DynamicUnderdetermination": ["Becoming.Carriers"],
    "EffectiveCommand": ["Becoming.Actuation"],
    "EvaluatorGrounding": ["Becoming.ProfileReach"],
    "EvidenceQualifiedCorrection": ["Becoming.PooledEnvelopes"],
    "ExplanatoryBranching": ["Becoming.BranchingCorrespondence", "Becoming.Granularity", "Becoming.Labelled", "Becoming.Likeness"],
    "ExplanatoryContextualStructure": ["Becoming.Joining", "Becoming.JoiningCodes", "Becoming.JoiningContexts", "Becoming.Presentations"],
    "ExplanatoryFootprints": ["Becoming.Composition", "Becoming.JointCorrespondence", "Becoming.ListFootprints"],
    "ExplanatoryGranularity": ["Becoming.Granularity"],
    "ExplanatoryGranularityBoundary": ["Becoming.Granularity", "Becoming.Presentations"],
    "ExplanatoryGuardedPrograms": ["Becoming.Granularity"],
    "ExplanatoryJoining": ["Becoming.Fragments"],
    "ExplanatoryJoiningAnchors": ["Becoming.Joining", "Becoming.JoiningRoles", "Becoming.Likeness"],
    "ExplanatoryJoiningBranches": ["Becoming.BranchingCorrespondence", "Becoming.Joining", "Becoming.JoiningCodes", "Becoming.Likeness", "Becoming.Presentations"],
    "ExplanatoryJoiningContexts": ["Becoming.JoiningContexts"],
    "ExplanatoryJoiningIncidence": ["Becoming.Joining", "Becoming.JoiningRoles"],
    "ExplanatoryJoiningRefinement": ["Becoming.Joining", "Becoming.JoiningRoles"],
    "ExplanatoryJoiningRegisters": ["Becoming.Joining", "Becoming.JoiningRoles"],
    "ExplanatoryJointness": ["Becoming.Composition", "Becoming.JointCorrespondence"],
    "ExplanatoryLocalUnits": ["Becoming.LocalUnits"],
    "ExplanatoryNecessity": ["Becoming.Carriers", "Becoming.Histories", "Becoming.HistoryLanguages", "Becoming.Labelled", "GenerativeCore"],
    "ExplanatoryResiduals": ["Becoming.Granularity"],
    "ExplanatoryStructure": ["Becoming.Coverage"],
    "ExplanatoryUniqueness": ["Becoming.Coverage", "Becoming.Presentations"],
    "ExplanatoryUniversality": ["Becoming.Presentations"],
    "FallibleInspection": ["Becoming.WitnessRefinement"],
    "FaultTolerantCorrection": ["Becoming.FaultEnvelopes", "Becoming.Transactions"],
    "GeneratedPaths": ["Becoming.AssurancePlans"],
    "GenerativeClosure": ["Becoming.Derivation"],
    "GenerativeComparison": ["Becoming.Alternatives", "Becoming.Metaethics"],
    "GenerativeLossComparison": ["Becoming.StrictTransport"],
    "HistoryRealization": ["Becoming.HistoryLanguages", "Becoming.Joining"],
    "JointContinuationClassification": ["Becoming.Bundles"],
    "JointInterpretation": ["Becoming.Derivation"],
    "KnowledgeCorrespondence": ["Becoming.PartialReadout"],
    "OpenFutureRevision": ["Becoming.Handoff"],
    "OperativeCoherence": ["Becoming.Dephasing"],
    "OrganizationalRuleInheritance": ["Becoming.RuleHandoff"],
    "PositionedPositiveReason": ["Becoming.SecuredContent"],
    "PositiveGroundUncertainty": ["Becoming.SecuredContent"],
    "PracticalJudgment": ["Becoming.Frontier", "Becoming.Lexical"],
    "PracticalReach": ["Becoming.MoveOutcomeProcesses"],
    "ProtectionPriorityRival": ["Becoming.ScoreRepresentation"],
    "RelationalBecoming": ["Becoming.ActivationCapacity"],
    "RelationalDynamics": ["Becoming.Carriers", "Becoming.Labelled"],
    "RelationalGrounding": ["Becoming.Bundles"],
    "RelationalOrganization": ["Becoming.Frontier"],
    "RelationalReduction": ["Becoming.JointPhase"],
    "RenewalComparison": ["Becoming.ActiveReading"],
    "RenewalRecovery": ["Becoming.RenewalFlow"],
    "StandardsBridge": ["Becoming.Narrowing"],
    "SystemsOrganization": ["Becoming.ProjectedLaws"],
    "WholeGroundCoverage": ["Becoming.ScopedReach", "Becoming.SeedReach"],
    "WisdomResponseStructure": ["Becoming.AssurancePlans"],
}
PURE = FOUNDATION + CORE + RING
RECEIPT = HERE / "becoming-verification.json"
RETAINED = HERE / "becoming-checks"

SCOPE = (
    "Rings: the core, and around it the instances (the Changes: Hexagrams, HexagramPlaces, "
    "HexagramCommuting, HexagramLaws, HexagramSites, HexagramSequences; PlaceTransitionNets) and the "
    "applications nothing in the core imports (Dispatch, GuardHorizon, ResponseLearning, Coverage, "
    "SeedReach, ScopedReach), held to the core's conditions (prelude only, empty axiom reports) and "
    "outside it by direction: no core module but the root imports a ring module, and no instance "
    "imports an application. "
    "World: one base, the run. The import tree starts at the foundation and Becoming.Frame (processes "
    "and their runs); the records of the one unfolding, Becoming.World, import the frame: Dependence, "
    "Web (Dependence Nat), Flow, Exchange and total over Nat and Prop, and World, one kind of relatum "
    "with its history, a run of the process admitting every step whose configurations are its webs "
    "and whose moves are its exchanges, so the world family is the standing-and-exchange reading of a "
    "run by definition, with no premise among the records. The labelled process and the frame are "
    "read from the world's side (Becoming.Labelled: the four splits, and the run "
    "readings of renewal, dependence, return and generation; Becoming.LabelledRoles: those of roles "
    "and dissipation; Becoming.ValuationFrames: the valuations of Metaethics and Significance read on frames; the other readings in the run and trace modules of the modules they read). "
    "Stock: for every process, balance at each step is balance along every course; where steps "
    "draw only from what is held, a course is executable exactly where it is covered, and run "
    "jointly with a registration exactly where the registration admits it and the stock covers it; "
    "repetition without end needs the return to cover the draw, and along every balanced run "
    "drawing without end needs replenishing without end; the stock along a run is a balanced Flow. "
    "Contacts: registration by agreement on data selects a value exactly where its address is in "
    "the data, and a change of data keeps every old selection exactly where it keeps the old data; "
    "a revision rule registers every failure exactly where it puts the failed address in the next "
    "plan, and a rule blind to what failed misses some failure at every plan once addresses are "
    "unbounded; two reference responses drive a two-valued channel to both targets exactly when "
    "they differ. "
    "LossMatching: for every Frame, strict loss matching composes and is monotone; a generative "
    "extension is a match by identity, so sufficiency of matching contains C; with losses listed "
    "once it is a strict order, and with content read as a class a match exists exactly when the "
    "better loses no more in each class and fewer in all; infinitely many losses allow a self-match; "
    "losing a common support blocks matching; a claim read at its time is settled from then on. "
    "ContinuingRevision: an actual failed undertaking forms the first reference apparatus; "
    "the same native operations then revise addressed methods, acquire references, install "
    "and succeed at every successor. The fuel is a stock: along every run at every yield renewal "
    "and success recur, with the return cut no unending run exists, and with fuel in reserve and "
    "yield as parameters the cycle repeats without end exactly where the yield covers its use of "
    "nine; the yield-nine witness keeps cumulative amounts and an actual infinite policy-restricted "
    "Run. Frozen methods, cut return, lost reserve and retired distinctions retain failures. "
    "Open productive support, succession, stable contacts and policy remain premises; "
    "no universal physical recurrence, basin, normative direction or closed-stock perpetuity. "
    "TimedResponse: native exchanges in temporal order bound when a difference can register. "
    "Before the answer time, common initial levels, balance, common present formations and response "
    "through past registration imply blindness outside timed propagation. The cone refines "
    "whole-course response; delayed arrival and ignored-signal witnesses preserve its limits. "
    "Discrete steps have no supplied physical duration; routes are necessary, not sufficient. "
    "RepairComparison is a peripheral shared-Frame application of LossMatching: a common repair "
    "law protects the two episodes of one life or the episodes of one, two or three other lives; "
    "between any two courses a match exists exactly when the better loses fewer episodes. Current "
    "support restoration retains historical losses. Distinct loss matches yield strict lower and upper "
    "anchors only under explicit complete-episode scope and sufficient-matching commitments; "
    "a backbone-disconnecting repair invalidates the match. No duration price or unconditional "
    "aggregation, full-recovery, normative sufficiency or global FR threshold is derived. "
    "ReferencePlan: acquired mismatch changes the next generated contact plan; fresh reference "
    "pairs, whose contacts use fuel, are checked and installed, then used in two actual "
    "policy-driven repairs without a reset of fuel; its fuel, revision rule and reference pairs "
    "are instances of Stock and Contacts. New installed selections reuse Revision. Frozen method, "
    "erased mismatch, insufficient fuel, constant channel and post-check drift retain failures. "
    "Local contact primitives, faithful return, stable binding and policy are supplied; no "
    "universal invention, attraction, chemical composition or normative warrant is derived. "
    "Revision: all old selections remain expressible exactly when new indistinguishability "
    "implies old indistinguishability, with equivalence conditions explicit; this composes along "
    "actual traces. Retained observations differ from the latest apparatus. A supplied closed-loop "
    "Process, a registration process run jointly with its stock, reconstructs registration, "
    "replenishes the stock and changes its response; loss and exhaustion of the stock remain "
    "possible. Target, control preference and construction law are "
    "supplied, with no general formation or normative theorem. "
    "RegroupingSelection: pure adapters connect regrouping and revision on supplied content. "
    "Arbitrary Frame claim-status fidelity is exactly preservation of all status-based claim "
    "selections, without decidability. Fixed literal claims on any process separate this from "
    "selection preservation across configurations. No semantic identity or understanding follows. "
    "All requirement-profile selections survive grouping exactly where admission grouping is faithful "
    "on every level path; merging a required-level difference loses some old selection. "
    "No new process, executable selector, wisdom predicate or independent result is supplied. "
    "Regrouping: comparison uses one frame with the process unchanged. Grouping preserves inclusion; "
    "a coarse gain reflects a gain, but inclusion reflects and gains remain visible only under the "
    "named local fidelity conditions. For decidable requirements, all-level admission fidelity is "
    "exactly equality of minimum required levels. Transfer alternatives are generated, feasible and "
    "balanced under the same rest-law; regrouping hides their opposed gains. No normative axiom, "
    "unique individuation, or joint-feasibility claim is supplied. "
    "Spine: a Frame is the core Process with realized claims; runs, reachability, invariants and new "
    "realization are defined through the core Trace; the visible scope of an inquiry is the set of "
    "configurations its actual executions reach, and a sound policy secures its goal there. "
    "Recurrence: with no premise and no decidability, a list holding the first l.length + 1 values "
    "of a sequence holds two equal ones, so a sequence that never revisits has no list holding it; "
    "a quantity that never falls and rises across every change stops change within finitely many "
    "configurations; under a determined law a lost possibility stays lost and merged configurations "
    "stay merged, and where a list holds every configuration, merging nothing, every configuration "
    "returning and every configuration reachable at every step are one, a rise along an orbit needs a "
    "merge and a merge loses a possibility for good, while counting on and counting down separate "
    "the three in an open world; keeping its history every law merges nothing, never returns, "
    "cannot have its beginning again and has no list holding it, and within finitely many "
    "configurations two histories share one present from every step on. "
    "Diagonal: a family of registrations indexed by what it reads says no gap of a map moving every "
    "value, and one saying every reading gives every map a value alike with its image; a claim is "
    "never alike with its negation, so no family of claims says every reading and no frame realizes "
    "every pattern of claims about its own configurations; with equality of values decidable, "
    "completeness is exactly all values being equal; a registration keeping what it says and next "
    "saying its gap is incomplete at every step, says no later gap earlier, has no two gaps alike "
    "where likeness is transitive, never returns, and holds its gaps in no finite stock where "
    "likeness is symmetric and transitive, and such an unfolding exists on Bool; revision by a map "
    "moving every value never rests, and the two-valued negation returns every two steps. "
    "Context: registrations in contexts glue at a configuration exactly where any two contexts "
    "registering a claim agree, each claim having a context; a frame of context-free claims fits "
    "exactly where they glue at every configuration, while the frame indexed by context always fits; "
    "where possibilities are local and admit no context-free reading no respecting configuration "
    "glues, and no frame of context-free claims fits a world with one respecting configuration; a "
    "whole lies within what its restrictions glue to, restrictions are local, and possibilities with "
    "no context-free reading, where some context allows something, are the restrictions of no whole; "
    "Specker's three boxes and the Mermin-Peres square admit no context-free reading, no context "
    "forcing a claim. "
    "Quantum: the nine two-qubit observables of the Mermin-Peres square, as integer matrices, each "
    "square to the identity, commute along each line and anticommute off it, and multiply along a "
    "line to minus the identity in the third column and to the identity otherwise; the values a "
    "nonzero vector shows jointly on a line have the line's parity and are a possibility of the "
    "line, every possibility is shown by an explicit vector, and no assignment to the nine cells is "
    "shown jointly on every line. "
    "Renewal: a run read through observables of conditions is one relational unfolding; an observable "
    "that never rises from some step on falls only finitely often, with depletion, recurrent renewal "
    "under a natural-number rank and unrenewed drawdown as its cases; in one process from one "
    "configuration one run renews and another consumes. "
    "Dependence: which conditions a formation depends on, at what level, and which it draws on may "
    "change from step to step; constant dependence recovers the static reading exactly; every met "
    "dependence is kept or broken across each step; consumption as inherited admits a requirement "
    "never met, which consumes its condition with no break; where activity needs current support, a "
    "formation still active after a loss without return has weakened or dissolved its dependence, and "
    "with fixed dependence it is no longer active, both contrapositives of that premise; these "
    "outcomes are neither exhaustive nor exclusive, and in one process from one configuration a break "
    "of the same dependence, read at the start of its step, is followed by an ending, a transformation "
    "and a restoration; an event is within renewal when its step keeps every dependence on the "
    "conditions it participates in, breaking when it draws on a condition at a step that breaks a "
    "dependence on it, and undermining when it draws on a condition at a step after which the "
    "condition is below both the present need of a dependence on it and a need of that dependence "
    "met at some step of its tenure, so that a level from before the dependence held and a "
    "dependence never met at its own need do not count, falling short only of a need grown beyond "
    "what was met is not undermining, a draw below a need that was met undermines after the need "
    "has grown, and a dependence that lapses for one step starts a new tenure; breaking is "
    "undermining, drawing after a loss can undermine without breaking, and "
    "drawing that changes no level can undermine; the stepwise and whole-run readings include "
    "different events in both directions; the lemmas on natural numbers the layers share are "
    "stated here. "
    "Restoration: a dependence is restored within p steps when it is met at one of the next p; renewal, "
    "renewal within one step, within p, restoration and non-consumption are ordered, and consumption is "
    "exactly a dependence that is never restored; renewal within one step does not imply renewal, and "
    "cycles of length zero are degenerate; a seasonal condition is renewed within two steps and "
    "not one; a recovery can slow without bound, restored always while no cycle bounds it; over "
    "cycles of two a dip is included, and an escalation undermines for every cycle. "
    "Horizon: for every horizon two runs of one process agree up to it, drawing beyond renewal with "
    "every event within renewal, and afterwards one renews and the other consumes; a reading decided "
    "by a finite prefix that includes every renewing run includes a consuming one; the renewing run "
    "itself draws beyond renewal before the horizon and the whole-run reading includes it; a reading "
    "of amounts per step is fixed by the history through the step and withholds every such draw; "
    "the formation-level cycle readings are not fixed by any finite prefix; and the same holds in "
    "the support-gated law, whose renewal stops below support. What a finite history refutes is "
    "proved as the case of runs of the laws of points of Ideals, a run read as the ideal of its "
    "stretches. "
    "Ideals: a history read off its finite stretches is an ideal of their order; a refutable reading "
    "of points holds, up to double negation, where a point adheres, and what adheres is closed; a class "
    "of ideals is closed exactly where it is the class within a lower set, its content; a refutable "
    "class is closed, and a closed class refutable, each up to a step that, asked of every order and "
    "class, is exactly double-negation elimination; the least closed hull, avoidance and a lower set's "
    "order; the ideals are directed-complete, compact exactly at finite histories, a monotone map "
    "extends continuously and uniquely, and a compact basis that generates fixes its completion. "
    "HistoryIdeals: a run is the ideal of its stretches; the laws of Ideals are read on the histories "
    "of every process; "
    "adhering is the least closed class, with no double negation; a reading of runs holding every "
    "adhering run is made of tests on stretches; asked of every process, a refutable class is closed, "
    "and a closed class refutable, each exactly under double-negation elimination, and a refutable "
    "reading holds at every adhering run exactly under it; avoidance, a lower set's own histories and "
    "the completion at runs; a history that settles, or goes on with its stretches picked, is a finite "
    "history or a run, and telling which on cut histories is the limited principle of omniscience; a "
    "history's ideal lies below another's exactly where it is a prefix of it, and for the process of "
    "all sequences the runs' histories are the infinite histories of words; prefix-closed languages "
    "give closed classes of histories. "
    "Verification: a class of histories is open exactly where it is the class meeting an upper set "
    "of stretches, fixed by its finite histories, and exactly where it is verifiable, with no premise; "
    "refuting is verifying the complement, and the step back is, asked of every order, double-negation "
    "elimination; every reading is its hull met with its remainder, the largest such part, refuted by "
    "no finite stretch and dense where it is decided whether the reading can still hold at each "
    "stretch, the disjunctive remainder dense, asked of every process, exactly under excluded middle; "
    "what a stretch finds against a reading is what it finds against its hull, and a practice keeping "
    "verdicts within a favoured reading, never refuted by the record, exists exactly where that "
    "reading is dense. "
    "Joint activity: withholding a formation's part with the same move taken, which must still be "
    "available, the loss is kept or broken; when with any single part withheld the same move still breaks, no part alone makes the "
    "difference; from one configuration a lone drawer's part makes the difference under a calm move "
    "and the loss is overdetermined under a shock; with the shock written into the step relation "
    "of one move the move does not determine the step and the loss is overdetermined though the "
    "calm outcome would keep the dependence, and a move no withheld configuration can take makes "
    "no part decisive; when the move determines the step and can be taken with a part withheld, "
    "and the dependence still holds and is met there, either the part makes the difference or the "
    "same move still breaks the dependence; in one process a drawer's part makes the "
    "difference with one other drawer and not with two, while the relational reading counts it "
    "consuming in both; a drawer taking exactly the renewal makes no difference and still "
    "undermines; drawing beyond renewal at every step consumes the condition, the first event "
    "undermines for no positive cycle, with every draw before any step withheld the condition is "
    "still consumed, and at the breaking step drawing nothing keeps the dependence. "
    "Experiment: along a run, relative to determinacy, the record up to a step fixes what a move "
    "does at a configuration exactly where the run has taken that move there; a determined "
    "process retargeting an untaken move has the same run, so what one's own act would have done "
    "otherwise is fixed only where the configuration returns, and a run that never returns, as "
    "one keeping its history never does, fixes no move other than the one it takes; read through "
    "a projection the step factors through into a determined process, one occasion fixes the "
    "outcome at every configuration in its class, and within finitely many projected "
    "configurations the projection returns; a wrong projection fixes a difference between moves "
    "that make none, is never refuted where the moves follow what it leaves out, and is refuted "
    "where they vary against it. "
    "Mechanism: a projection of configuration carries a determined law exactly where configurations "
    "alike under it go alike under it, the image of the step being the least process the step factors "
    "through; what the step does not depend on is re-absorbed in one step, Capture's rule holding the "
    "outcome being the instance with the rule as the projection; a system changing its own rule is one "
    "determined process on the joint configuration, the state having a law of its own exactly where "
    "the rule makes no difference to it; a law through a projection is not fixed where not yet taken; "
    "the standard model x' = F(x, u, e) is a determined process whose move is the input and the noise, "
    "an intervention is a move not taken and noise a move not represented, the model with the noise "
    "forgotten being determined exactly where the noise makes no difference. "
    "Unfolding: read with the move inside the configuration a process has the same runs, the law "
    "leaving the next move open and determined exactly where it is with moves as labels and one move "
    "wherever it steps; with the move formed within by a policy, runs from one configuration agree; "
    "a shared move couples the parts of a synchronized product; a world balances exactly where its "
    "standings run by the law of exchange with its relata's exchanges as moves, the exchange fixing "
    "the standings from a beginning and the standings not fixing the exchange; every history is a "
    "run of the law it shows, the least law it is a run of, determined exactly where the history is "
    "consistent, a law can have a step and no run, a revisiting history shows a law admitting a run "
    "it never took, and a kept history shows a law admitting only it; a frame along a run is a world "
    "whose relata are its claims, novelty being arising; configurations are alike where a "
    "bisimulation relates them, an equivalence with no quotient, and alike ones pass the same tests; "
    "determinacy up to likeness passes along likeness while determinacy as equality depends on names; "
    "a description makes sense where it identifies exactly the alike configurations, and then carries "
    "a law where the frame is determined up to likeness; under a determined law likeness is the same "
    "registered future; under the law of exchange standings are alike exactly where they agree "
    "pointwise. "
    "Histories: the law a family of histories shows is the least law admitting each of them; a "
    "family is the family of some law's histories exactly where it holds every sequence made of "
    "its own steps, and of a determined law's exactly where it is also consistent; two laws admit "
    "the same histories exactly where they have the same live steps, the dead end's step not "
    "being live, and have the same finite histories exactly where they have the same steps; where "
    "both frames are determined up to likeness, configurations are alike exactly where they pass "
    "the same tests, the same courses open and the same claims realizable after each, while a "
    "frame choosing after its first move and one choosing at it pass the same tests and are not "
    "alike. "
    "Branching: for every process, a configuration returns exactly where its own course can have "
    "it at the next step, and every configuration returns exactly where every region the process "
    "never leaves keeps every possibility of its own; a configuration that returns can be had at "
    "every step and has a run that never loses it; keeping every possibility does not give "
    "returning, merging nothing gives it along a run listed within finitely many configurations, "
    "and a merge need not lose a possibility; every process necessarily draws exactly what does "
    "not return, and possibly drawn is losing oneself on some course, which allows return on "
    "another; under a determined law each notion is R6's or P67's; determinacy is determinacy up "
    "to likeness where the claims name the configurations, theorems on how configurations relate "
    "hold up to likeness, and retargeting one of two alike configurations, an unregistered past "
    "and an unregistered description need equality; where a rule keeps itself its region is "
    "absorbing, and where the next configuration depends on the rule alone a perturbed state is "
    "drawn into what the rule holds. "
    "Listing: A list can be listed once exactly where identity among its members is decided "
    "(`listsOnce_iff_decided`); its number of members is unique and exists exactly then. "
    "Refutation laws need no such premise. Fixing every list's number up to relational "
    "indiscernibility in every world is equivalent to excluded middle "
    "(`World.numbers_indiscernible_iff_em`). Reading by occurrence keeps amounts and local laws "
    "without tracking occurrences across steps. "
    "Stuttering: Stuttering keeps the premises, stretch totals and recurrence, while rates and "
    "reserves counted in steps depend on the reading. Reordering: for a given footprint containing the "
    "exchanges, commuting unjoined neighbouring exchanges keeps every premise and reaches exactly "
    "the renumberings preserving the partial order of joined exchanges (`Footprinted.sorts_iff`, "
    "`Footprinted.converse`). IdleRemoval: removing idle steps keeps premises, censuses and totals. "
    "OneStep: A pattern of one step is realized by a world exactly where it obeys the law of "
    "every step and the law of each named local condition (`OneStep.every_iff`, `OneStep.laws`); "
    "nonzero taking needs a taker and nonzero giving a giver. Givers, capacity and activity are "
    "characterized exactly. Runs on one family add chaining; for families chosen step by step, "
    "running down adds continuity counted at positive levels (`OneStep.step_runsDown_iff`), "
    "strictly weaker than tracking positions. "
    "Weighted: Given weights with their laws and finite lists of moves and configurations, the "
    "sum of histories over a finite horizon is exactly stepwise transfer (`Weights.sum_courses`). "
    "Possibility is the core's trace relation, and counting preserves possibility. For a "
    "description with representatives, exact preservation at every horizon is exactly one-step "
    "lumpability (`Weights.lumped_iff`); truncation, cancellation, unkept memory and loops have "
    "explicit boundary witnesses. "
    "Transmission: Transmission is exactly inheritance with a need bound "
    "(`Flow.transmitsWithin_iff`); where no dependence was held before, inheritance is the "
    "forming law, while the general forming/holding split uses decidedness. Dropping one "
    "dependence of a giver keeps the other premises and breaks binding transmission "
    "(`World.drop_but`). Under the named finite, balance, dissipation, embodiment and support "
    "conditions, a reading of drawing together with drawing being depending derives transmission "
    "(`World.transmitting_of_drawn`). "
    "Succession: `Successive.relay` gives a balanced, dissipative flow in which only active "
    "formations give, the pool is fed at every step, and each source participates and is active "
    "at its own step only. Continuing to be fed needs no source formation to recur. This advances "
    "continuing-self-fed-from-beyond and is not a separate result. "
    "OrderNormal: For a symmetric joining relation and a finite stretch of naturally named "
    "exchanges, arrangements are reachable exactly where they orient joined pairs alike. Decided "
    "apartness for distinct exchanges gives a lexicographically least, idempotent normal form; "
    "reachability is agreement of forms, and a natural-number-valued complete invariant compared "
    "on the finite stretch needs exactly that decision. Every reordering with split sides "
    "preserves activity and standing census existence both ways; arbitrary commutation preserves "
    "it forward. Decided idleness at every step and relatum gives the least containing footprint, "
    "whose joining and order are contained in every containing footprint’s. With decidable "
    "equality of relata, existence of a least Boolean containing footprint is equivalent to "
    "decided idleness. The normal form depends on names and a finite stretch; no unnamed, "
    "Foata-layer or unbounded form is supplied. No decision is derived for actual worlds and no "
    "concrete undecidable-idleness world is given. The sides of reordering remain supplied; "
    "continuous-time correspondence remains open. The readings are the AI’s, pending Ren. "
    "Attraction: for every determined law, with no premise, a configuration is drawn into an absorbing "
    "region exactly where it does not return, and what is drawn in never comes back; what can be had n "
    "steps on is absorbing and every possibility lost by step n is drawn into it; of two merged "
    "configurations not both return; within finitely many configurations attraction is merging and "
    "what returns draws in everything else, while counting on draws without merging; under any "
    "process, once inside an invariant region what lies outside cannot be had again, and leaving a "
    "region needs a move that does not keep it. "
    "Substitution: in the support-gated law, a focal formation that can substitute an alternative "
    "condition stays active, transforms its dependence at a step that can be found, and consumes, "
    "while the sustaining formation ends; a concrete law meets the premises, and there the stepwise "
    "reading includes the focal formation at every step but the one at which the sustaining "
    "formation loses support; in another law of the family it is withheld at two steps, until it "
    "switches. "
    "Arising: a formation arises when it is inactive before a step and active after it, and "
    "arising is unceasing when some formation arises at arbitrarily late steps; an event "
    "depletes a finite family when at each of its steps at which no condition of the family rises "
    "one of them falls, which says only that some condition of the family changes at each of its "
    "steps; a finite family none of whose conditions rises from some step on is depleted by only "
    "finitely many events; so where arising depletes such a family, unceasing arising makes "
    "some condition of it rise at arbitrarily late steps, and, every rise being made by a "
    "formation renewing it, renewing activity recurs; a formation lowering such a family at each "
    "active step is active only finitely often however it substitutes; if a quantity never rises "
    "and every arising lowers it, arising is not unceasing, while a closed cycle whose total "
    "stays constant sustains unceasing arising; a flicker depending and drawing on nothing "
    "arises unceasingly, each arising depleting an unrelated tide; a tide renewed by the moon "
    "rises at arbitrarily late steps while nothing arises, and drawing what is renewed keeps every "
    "dependence while nothing arises; arising on a consumed condition ceases; and a formation "
    "arising again and again on a renewed condition meets every premise, each arising coming at a "
    "rise, while the stepwise reading withholds each of its arisings and the reading over cycles of "
    "two includes it. "
    "Flow: when every change of a condition's level is what the formations taking part take and "
    "give, the family's total plus its uptake equals its total before plus its replenishment, over "
    "a step and over any stretch, every rise is made by an active renewer, and every fall is "
    "taken from, by an active formation drawing on it where only active formations take; "
    "positive uptake at "
    "arbitrarily late steps needs replenishment at arbitrarily late steps, so when formations "
    "taking from the family at their first active step arise at arbitrarily late steps, formations "
    "replenish the family at arbitrarily late steps, and so they do for a constant consumer with "
    "nothing arising; over any stretch from which at least K formations take, the family is "
    "replenished by at least K per step less its stock at the start, and with each formation "
    "giving at most a fixed amount the renewers grow in the same averaged sense; so generation that is more without end, with ever more formations taking "
    "from a finite family from some step on, needs replenishment that no eventual bound bounds "
    "and, each formation giving at most a fixed amount, renewers that no eventual bound bounds, "
    "who can still be absent at infinitely many steps; renewers and growers arising at every step "
    "meet these premises with a level that never rises, so that arising there does not deplete "
    "the family in the net sense; the unceasing oscillator is not more without end; and in a closed "
    "cycle each formation gives back what it takes, the total never changes, and generation is "
    "more without end with as many renewers as takers; every rise of a condition is given to, "
    "so a rising condition replenishes every family containing it, and where members of a "
    "family rise at arbitrarily late steps its replenishment recurs, whatever is taken; a "
    "condition coming to stand, its level zero before a step and positive after, rises and is "
    "given at least its new standing, and a condition can rise at every step without coming "
    "to stand. "
    "Change: with no premise about an unfolding, a determination comes to be across a step where "
    "it fails before and holds after, and ceases to be where it holds before and fails after; a "
    "formation arising and ceasing, a dependence forming and dissolving and a condition coming to "
    "stand and ceasing to stand are this one change; a decidable determination that ceases at no "
    "step from some step on holds on; with excluded middle as a hypothesis, a determination "
    "not holding at arbitrarily late steps fails from some step on, a determination that holds "
    "and ceases at no later step holds on, and one that fails and comes to be at no later "
    "step keeps failing, with no decidability; the limited principle of omniscience is stated, "
    "every Boolean sequence having a true or being false throughout; a formation stays supported where each dependence it has it "
    "had before, at no greater need, on a condition standing no lower; over any stretch an amount "
    "at the end with everything it fell is the amount at the start with everything it rose, and "
    "so for the total of a finite family with the rises and falls of its members; since no amount "
    "falls below zero, a finite family falls over any stretch by at most its total at the start "
    "more than it rises, so members falling at arbitrarily late steps rise at arbitrarily late "
    "steps, which for one amount is the law that an observable never rising from some step on "
    "falls only finitely often, and with the amounts bounded the family rises by at most its "
    "bound per member more than it falls, so rising at arbitrarily late steps needs falling at "
    "arbitrarily late steps; so in a finite family of decidable determinations the members "
    "holding at the end with those that ceased to be are those holding at the start with those "
    "that came to be, comings and ceasings over any stretch differ by at most the number of "
    "members, and coming to be recurs exactly when ceasing to be recurs: given decidable "
    "activity, the members of a finite family of formations active at the end with those that "
    "ceased are those active at the start with those that arose, they arise at arbitrarily late "
    "steps exactly when they cease at arbitrarily late steps, and with finitely many formations "
    "arising recurs exactly when ceasing recurs; with "
    "no premise at all, conditions of a finite family come to stand "
    "at arbitrarily late steps exactly when they cease to stand at arbitrarily late steps; ever "
    "new formations can arise with none ceasing while a level rises at every step and never "
    "falls, and formations all active at the start can cease one after another with nothing "
    "arising. "
    "Population: a census lists the formations active at each step, each once; if more are active "
    "after a step than before, one arises across it, and a census growing without bound makes "
    "arising unceasing; under a census, with each formation taking part in a flow listed once "
    "and only active formations taking, more without end makes the active formations grow without "
    "bound and arising unceasing, and the expansion and the cycle meet all these premises; the "
    "unceasing oscillator meets these premises and is not more; without a census every formation of an "
    "infinite family can be active from the start and more without end comes with nothing "
    "arising, with takers that are never active the same holds under a census, and so it does "
    "with one formation listed many times in the flow; ever more formations can draw on a "
    "condition while the flow records no taking; under a census, ceasing at arbitrarily late "
    "steps needs arising at arbitrarily late steps, not conversely, and with at most B "
    "formations active at each step from some step on arising recurs exactly when ceasing "
    "does; both hold of any determination whose holders are listed at each step, read of "
    "activity, dependence and standing, and follow from the census balance: over any stretch "
    "the list at the end with what ceased is the list at the start with what came, so ceasing "
    "recurs exactly when from each step some later list falls short of the list at the start "
    "with what came between; the bound need only return within some number at arbitrarily "
    "late steps, and where the list grows without end ceasing recurs where the comings outpace "
    "a bound on it; the recurrence laws need only an inequality across each step, a count ending "
    "with what it loses at most where it started with what it gains having losses recurring "
    "only with gains recurring, and conversely where the inequality runs the other way and the "
    "count is bounded from some step on; across each step some members are kept, with those "
    "ceasing making the list before and with those coming the list after, and every tally of "
    "this form is counted by a queue whose members join at the back and leave from the front, "
    "so a property of the counts respecting their values at each step holds of every listing "
    "exactly when it holds of every tally, the counts some listing has being exactly the "
    "tallies; the tally is the balance with no more ceasing across a step than were listed "
    "before it, and none listed with one ceasing and one coming at every step balances and is "
    "no tally; B bounds the change of counts from a step when at every later step the count "
    "with the steps of change since stays within B, a change bound from a step being a larger "
    "one from the first, and within a change bound change does not recur, while a step after "
    "which nothing changes, for every count with a change bound from the first step in which nothing "
    "joins an empty queue, would give the limited principle of omniscience. "
    "Persistence: for any holding predicate, keeping its names fixes classes of formations "
    "holding throughout; a held census instantiates both continuation recurrence laws with their "
    "separate no-split, no-merge, boundedness and decidability hypotheses. A world under "
    "re-identification balances exactly where its one-to-one continuation lies within "
    "conservation, with no additional hypothesis; in a balanced world conservation is equality of "
    "standing after the step and agrees with exchange likeness. With decidable equality, "
    "identity, arising and ceasing fixed by all balanced re-identifications have exact "
    "conservation criteria. Distinct standings fix classes. Hibernation, Dormancy, Seed, Sleeper, "
    "Shuttle and Lineage separate the holding readings, show the mixed census failure and bound "
    "the identity claim. "
    "ContinuedClasses: read along what continues an event through a continuation, renewing holds "
    "exactly where the event's relations are renewed and renewing holds along every formation "
    "continuing it, so renewing passes into every branch of a split, and consuming holds exactly where "
    "the event draws on a consumed condition or consuming holds along a formation continuing it, so "
    "consuming along a merged formation is consuming along every formation merged into it; the two "
    "exclude each other; carrying the continuation through a re-identification leaves what continues "
    "what and both classes unchanged; where each formation continues itself and is always active "
    "they are the name classes; in MergeClass a formation renewing as named consumes along a merge; "
    "tenure and undermining read along a continuation are the named ones where each formation "
    "continues itself, are unchanged by every re-identification carrying it, and more links never "
    "remove undermining or consuming; where two relata stand alike after a step of a balanced world, "
    "a balanced naming continues the one as the other; widening across a stretch read along a "
    "continuation is widening as named where each formation continues itself, is unchanged by every "
    "re-identification carrying it, and is harder to exceed with more links, so in Bud a stretch that "
    "widens by name adds nothing along a bud. "
    "Identity: re-identifying formations one to one at each step leaves every step's levels, "
    "activity, dependences and drawing unchanged; a renaming preserves the readings that follow "
    "a formation, and every re-identification preserves support, keeping and breaking, the class "
    "of every condition, whether activity needs support, being within renewal and breaking at "
    "each event, what a flow takes and gives, the counts of takers and renewers, so more without "
    "end, a census of the active formations and that only active formations take, so that under "
    "a census more without end makes arising unceasing under every re-identification, as in "
    "the expansion; exchanging names at odd steps turns a renewing and a consuming formation into two "
    "consuming, removes undermining after the first step and makes formations arise without end, "
    "and arisings made by naming alone can meet every premise of the recurrence of renewal; "
    "keeping the names of continuing activity makes no arising and keeping those of continuing "
    "dependences removes no undermining, while succession, joining a formation that ends with one "
    "that begins then or later, can hide arising in a lineage and make drawing after a predecessor's "
    "loss undermine a living successor, both namings keeping continuity only one way; kept both ways, "
    "continuity preserves arising and undermining exactly and excludes a join at a single step, "
    "and joining across a dormant step still changes which formation renews and which consumes; "
    "under a census, with each formation taking part listed once and only active formations "
    "taking, under every continuation in which no formation continues as two, every "
    "re-identification and a continuation with merges among them, more without end makes "
    "formations arise at arbitrarily late steps, a decidable continuation giving the "
    "decidability this asks; on the expansion, whose formations never end, a merge comes with a "
    "persisting formation re-read as arising at every step, while where the merged formation "
    "ends what arises under a merge is exactly what is new; without a census it does not, with "
    "new formations budding from one "
    "already there it forces no arising, and a single split need not defeat arising, so no split "
    "is sufficient, not necessary; across one step it is exact: whatever formations are listed "
    "before and after "
    "the step, more forces arising under a continuation exactly when no formation continues as "
    "two, and under every continuation without splits it is forced exactly when more formations "
    "are listed after the step than before; under a census, with a formation ceasing under a continuation when "
    "continued by no formation active after the step, the active formations after a step with "
    "those ceasing are at most those before with those arising when no formation continues as "
    "two, at least when no formation continues two, and exactly with neither, as for each "
    "formation continuing only itself, so ceasing recurring needs arising recurring under every "
    "continuation without splits and, with at most B active from some step on, arising "
    "recurring needs ceasing recurring under every continuation without merges, and one web of "
    "two formations at each step read as budding and as joining shows each condition needed; "
    "a lineage named beside its members is active at every step "
    "while they arise without end. "
    "Wholes: a formation is the whole of some parts when it is active exactly while some part is, "
    "a coincidence of activity by which every formation is the whole of itself and two formations "
    "always active are each the whole of the other; a whole arises only as some part arises; "
    "parts covering every step from some step on, none active at two steps d apart, have a part "
    "arising within every d consecutive steps, a bound attained by members working in shifts and "
    "met by two members arising again and again, and parts covering every step from some step "
    "on, each of whose activity ends, with the active ones listed, arise at arbitrarily late "
    "steps outside every finite list of parts; a whole active at every step from some step on is "
    "covered by its parts; "
    "with a part that never ends, or infinitely many parts active at once, it persists while "
    "nothing arises, and parts arising without end may leave the whole inactive between them; "
    "parts each of whose activity ends, with the active ones listed, none arising from some step "
    "on, are all inactive from a later step, so their whole ends; a whole of such parts, its parts "
    "arising only where they then depend on some condition of a family at a need of at least m, "
    "the family's renewal gated on it, with balance, only active formations giving and activity "
    "needing support, after n steps of excess of the family's uptake over its replenishment from a "
    "stock below n + m has no part arising from then on and ends, the one-condition form its "
    "family of one; a lineage of members each arising where the condition stands at its need, "
    "drawing two where its members give one, meets every premise and ends, and taking within what "
    "they give it is active at every step, as it is with a part that never ends or with members "
    "arising without depending on the drawn condition. "
    "Dissipation: a family is closed across a step when no formation taking part exchanges with "
    "a condition outside it, and is dissipated on when every formation taking part gives it no "
    "more than it takes from it and less when it takes; in a balanced flow a family dissipated on "
    "falls across a step by at least its number of takers, its takers over all later steps number "
    "at most its stock, and taking from it does not recur; so under dissipation on every closed "
    "family without repetition, a finite family from which formations take at arbitrarily late "
    "steps, and every finite family without repetition containing it, is open at arbitrarily late "
    "steps, more without end, the unceasing arising of takers and one eater kept up with nothing "
    "arising being such taking, and with finitely many conditions in all taking does not recur; "
    "a step is enclosed when some finite family without repetition is closed across it, as when "
    "finitely many conditions are all there is, and under dissipation a formation that gives "
    "takes more than it gives over every closed family without repetition, so across an enclosed "
    "step giving needs uptake, while where no step is enclosed dissipation holds vacuously and a "
    "renewer can give taking nothing; a step is enclosed around a family when a finite family "
    "without repetition containing it is closed across it, as every enclosed step is when "
    "equality is decidable, and under dissipation a finite family from which taking recurs and "
    "which is enclosed around from some step on draws in: at arbitrarily late steps a formation "
    "gives to it and takes from beyond it; a source burning a fresh fuel at every step and giving a "
    "pool less than it "
    "burns, while ever more growers take from the pool, meets these premises, with the growers "
    "depending on the pool under a census as well, every step being enclosed and the pool drawing "
    "in the fuel; the flows of the earlier witnesses in which "
    "taking recurs on one condition are not dissipative; a member of a family dissipated on "
    "rising, as in coming to stand, lowers its stock, so members of a family dissipated on from "
    "some step on neither rise nor come to stand at arbitrarily late steps; under dissipation a finite family without "
    "repetition whose members rise, as in coming to stand, at arbitrarily late steps is open at "
    "arbitrarily late steps and, enclosed around from some step on, draws in, and with finitely "
    "many conditions in all none rises at arbitrarily late steps; across a step dissipated on, "
    "a family's members fall by at least as much as they rise and by one more for each formation "
    "taking from it, so a formation taking from it makes a member fall whether or not another "
    "rises, an event at whose steps the family is dissipated on and taken from depletes it, and a "
    "member rising comes with another member falling across the same step, so that under "
    "dissipation a member of a family without repetition rising while none falls shows the "
    "family open across that step, an active formation "
    "giving to the one and taking from the family and an active formation drawing on the other "
    "taking from it where only active formations give and take. "
    "Locality: each law holds of every world, its condition stated inside it at the steps and "
    "relata where the proof uses it, so that a premise selected for every step makes the "
    "condition hold at every step and the selection results are corollaries, no premise being "
    "derived; balance on a family across one step; with balance at a condition across a step, "
    "it comes to stand exactly when it stood at nothing and was given more than was taken from "
    "it, ceases to stand exactly when it stood and what was taken from it is all it had with all "
    "it was given, and, nothing being taken from a family balanced on, a member rises exactly "
    "when something taking part gives to it, which dissipation on the family excludes; an "
    "embodied relatum, embodied at both ends of the step and given to only by active formations, "
    "arises exactly when it comes to stand, so as an active giver other than itself gives to "
    "it; across a step at which a family without repetition holding whatever stands before or "
    "after it is balanced and dissipated on, with no closure, some standing changes exactly when "
    "the family's total falls, and with the family closed something taking part takes or gives "
    "exactly then; under a census of what stands, standing changes at arbitrarily late steps "
    "exactly when it changes at arbitrarily late steps across which what stands does not run "
    "down, by a bounded search with no decision, and so with the exchange; over any stretch what "
    "stands at its end with the steps at which the total fell number at most the total at its "
    "start with what it rose, which rises only across steps that do not run down, so that any "
    "count within the total standing has a change bound from a step after which every step runs "
    "down, wherever each counted change is a change of standing; a list covering what holds at "
    "one step, with nothing coming to be across a stretch after it, covers every step of the "
    "stretch, for any finite list what holds of it at the end with its ceasings is what held at "
    "the start exactly when none of it comes to be across the stretch, with a list holding "
    "exactly what holds at a step what holds at the end with what ceased number exactly those, "
    "and ceasing recurring needs coming to be recurring wherever some list covers what holds at "
    "arbitrarily late steps, and, with no decision, does not recur where a list covers what "
    "holds at one step and nothing comes to be after it. Openness's rest theorems, Counting's "
    "enclosure bound and binding of counting, Standing's bounds on what stands, the census law "
    "and the arising of an embodied relatum through another's giving are re-proved as its "
    "corollaries. "
    "Seeking: a target met at a state the law leaves unchanged is met at rest, and under a "
    "determined law seeking comes to rest with its target met exactly when it reaches such a state; "
    "a target of more than now is met only by change, and met at every step makes every "
    "configuration new, so no list holds them; a target of above all others is met at a state by "
    "at most one seeker, so no state left unchanged meets it for two; where what stands is listed "
    "at each step, a condition rising at arbitrarily late steps needs steps at arbitrarily late "
    "times across which what stands does not run down, and where what stands runs down at every "
    "step from some step on, its rises do not recur. "
    "Roles: a web or flow read with one kind of relatum, in which no formation is a condition, keeps "
    "support, dependence, renewal, consumption, the classes of formations, undermining, living "
    "events, arising, unceasing arising and a census, and what is taken and given, balance, "
    "that only active formations give and take, a present without repetition, takers, renewers, "
    "more without end and dissipation, and in it no active formation stands as a condition "
    "exactly while it is active or depends on itself; relabelling the conditions of a one-kind "
    "web onto themselves keeps dependence and undermining and changes which relata are embodied "
    "and which depend on themselves, so that identification is supplied by the shared index; "
    "where a relatum is so embodied and activity needs "
    "support, a formation depending on it at a positive need is active only while it is, activity "
    "passes along every chain of such dependence so that a relatum not active ends every formation "
    "whose chain reaches it, consuming it at a need of one ends it, a dependence on itself is met "
    "exactly while it is active, drawing on it across the step at which it ends breaks that "
    "dependence whatever ends it, even for a drawer that takes nothing and for its own last event, "
    "and in a balanced flow in which only active formations give it arises only as another active "
    "formation gives to it, a formation that need not be embodied, and that is embodied where "
    "only embodied relata give, as a source depending on nothing can be; a "
    "bee and a flower renew each other, a fox ends with the hare it draws on, and generations arise "
    "without end each given by the one before; an embodied relatum comes to stand as it arises, "
    "so it is given at least the standing it arises with, its arising replenishes every family "
    "containing it and embodied "
    "generation recurring in a family needs its replenishment to recur whatever is taken; "
    "whatever gives to a family dissipated on takes from it, so the arising of an embodied member "
    "of a family dissipated on lowers its stock and embodied members of a family dissipated on "
    "from some step on do not arise at arbitrarily late steps; under dissipation a finite family "
    "without repetition in which embodied members arise at arbitrarily late steps is open at "
    "arbitrarily late steps, and enclosed around from some step on it draws in, and with "
    "finitely many relata in all embodied arising does not recur; the arising of an embodied "
    "member of a family dissipated on comes with another member falling across the same step, "
    "while each generation of the brood arises in a closed family of it and the one before with "
    "nothing falling, so that family is not dissipated on; two sides handing one "
    "standing back and forth bear unceasing arising in a closed world without dissipation, "
    "burning a fresh fuel they bear it under dissipation while every finite family containing a "
    "side opens and the family of the sides draws in the fuel, with a sink exchanging with ever "
    "new relata instead dissipation holds vacuously and the sink opens the family of the sides "
    "while nothing flows into it, and a relatum whose activity is not its standing arises again "
    "and again with nothing given to it. "
    "Reserve: a reserve does not rise across a step at which its formation is unsupported and "
    "falls across each such step at which the formation is active; the zero reserve is exactly "
    "the premise that activity needs support, a condition in a balanced flow given nothing while "
    "its holder is unsupported and taken from, by whatever takes part, while the holder is active "
    "there is a reserve, as it is where the holder itself takes part and takes from it, while "
    "the supplied reserves of the dormant seeds are held by no condition of their webs, and an "
    "active formation whose dependences fail has a positive reserve, so where a held condition "
    "carries the formations, moving each unsupported dependence onto it at need one keeps "
    "levels, activity and drawing and meets the premise that activity needs support by "
    "construction; a formation unsupported from "
    "some step on is active only finitely often, over any stretch at most as often as its "
    "reserve at the start, and arises only finitely often, so after a loss without return, and "
    "after the end of an embodied relatum it depends on at a positive need, it is active beyond "
    "its support at most as often as its reserve; a reserve that also falls across every "
    "unsupported step at which it is positive bounds the time as well, the formation being "
    "inactive once as many steps have passed as its reserve, and along a chain of any length of "
    "relata each depending at a positive need on the one before it, those depended on embodied, "
    "the first having ended, each relatum is inactive once the reserves of the links before it, "
    "each read where the link before it ended, have passed, no chain going on without end where "
    "dependences climb a bounded rank, while without that decay, with excluded middle as a "
    "hypothesis, each relatum of such a chain is inactive from some step, no bound being "
    "given, and if every formation never supported, with a carried reserve and decided activity, "
    "had a step after which it is never active, the limited principle of omniscience would "
    "hold; a relatum standing as a condition "
    "while active, absent at some step and active later, came to stand across some step in "
    "between; a seed waking twice in the dark on "
    "its reserve, a seed waking once before its viability is spent, a fox outliving the hare "
    "by its fat, a chain in which each relatum outlives the one it depends on by one step and "
    "that chain cut to three relata attain these bounds, and the fox read with its dependence "
    "moved onto its fat meets the premise that activity needs support, its event at step one "
    "then not undermining, as it is under the published reading; a seed given its "
    "standing while dormant arises later with nothing given to it, and a relatum standing "
    "throughout wakes without end with nothing given to it, nothing taking part in its flow. "
    "Metaethics: on a connected whole with some living claim, significance of every living claim "
    "from every standpoint (living significance at claim level) is equivalent to a seed together with relational and "
    "standpoint neutrality; the positioned articulation D follows from the articulation premise A; a "
    "sound inquiry for new living content gives every position with access a contributory reason; "
    "living significance, C, D and the secured new content are stated in the core, which imports no ethics module. "
    "Each of seed, relational neutrality, standpoint neutrality, connection and A has a consistent "
    "countermodel, and each rival satisfies the same rule inside a formed boundary. The lifting rule L "
    "is transitive only through a live middle response. No premise is proved, no rejecting position is "
    "bound, and no duty, ranking, recognition or compliance is inferred. On a run read relationally, "
    "a condition in which every living formation participates discharges connection, and without one "
    "connection can fail; a consuming formation and one losing its support co-participate in the "
    "drawn condition, so under N_rel valuing the consumer's activity reaches the living events of the "
    "formation losing support. Read stepwise, an event is living when active and not undermining; the "
    "same discharge holds, an event drawing at a step that breaks a dependence is related to the "
    "broken formation, so under N_rel valuing it reaches that formation's living events, and both "
    "readings include the broken formation's own event. Read through relations, the stepwise reading "
    "of an event is the conjunction of the reading of its relations, and one event can have a living "
    "relation and an undermining one. "
    "Ranking: each course is a web, the law's unfolding read with fixed dependences; "
    "C over courses is stated through a frame whose realized claims are the events a "
    "reading includes; the course without a formation extends the course with it only if the reading "
    "withholds every event of that formation; under the whole-run reading, for every law of the "
    "support-gated family in which the focal formation draws beyond renewal, the course without it "
    "extends the course with it, so every comparison satisfying C ranks it higher; under the stepwise "
    "reading an event of the formation whose step leaves every need met is included, neither course "
    "extends the other, and an irreflexive, transitive comparison satisfying C prefers the course with "
    "the formation, malignant growth and winning by consumption being instances, while with no "
    "included event of the formation the stepwise reading too ranks its absence higher; under the "
    "stepwise "
    "reading sharing still extends winning by consumption; under either reading a course in which "
    "every need stays met extends a course of the family in which overdraw ends the sustaining "
    "formation's support, malignant growth being ranked below the same formation stopping before "
    "the threshold, while with a third formation sharing the condition neither course extends the "
    "other under the stepwise reading. "
    "Correspondence: under the discipline that two events are related through a condition only "
    "when one draws on it and the other depends on it at a positive level, a condition nothing draws "
    "on or no dependence on which can fail relates nothing and undermines nothing, and adjoining one "
    "leaves living, the relation and connection unchanged, while under co-participation adjoining a "
    "condition every formation requires at level zero connects every web; every undermining relation "
    "is an interaction, though interaction orders no steps and does not ask whether the drawing "
    "changes the level, and under N_rel valuing any drawing event reaches every living dependent "
    "at a positive level; a condition on which every living event bears, with a living drawer and a "
    "living dependent, connects the whole; in one example two dependents are connected through a "
    "living use of their condition and not when its only use undermines them, while co-participation "
    "connects them in both; adjoining a renewed condition every formation depends on at a positive "
    "level, drawn on by one living event, still connects every web without changing living; read "
    "with one kind of relatum a web keeps the connection of co-participation and of interaction, "
    "drawing on a relatum that depends on itself interacts with each of its active events, so a bee "
    "and a flower each depending on itself and on the other are connected with no third condition "
    "and living significance there is exactly a seed with both neutralities, while where each depends only on the "
    "other neither co-participation nor interaction relates the bee to the flower, though both "
    "are embodied; relabelling the conditions of a one-kind web onto themselves keeps the "
    "connection of both valuations. "
    "Capture: carriers of a target each leaving at least as many offspring as each other parent, "
    "their offspring stand to the others' at least as the carriers stand to the others, and "
    "strictly where each carrier leaves more and both are present; where what stands is listed, "
    "descent at arbitrarily late steps needs steps at arbitrarily late times across which what "
    "stands does not run down, and where it runs down from some step on descent does not recur; "
    "where the next configuration depends on the rule and not the state, perturbing the state alone "
    "is re-absorbed from the next step on, the instance of Mechanism's re-absorption with the rule as "
    "the projection. "
    "Evolution: a relatum descends from a formation across a step when the formation takes part "
    "in the step and gives to it and the relatum comes to stand across it; over any finite family "
    "of parents, each with finitely many offspring, and any amounts read of them, the offspring's "
    "total with what transmission lowered equals the parents' amounts, each counted once for every "
    "offspring, with what transmission raised, the counting form of Price's equation, an "
    "arithmetic identity with no premise whose weighted total is not selection proper: with "
    "every parent having k offspring it is k times the parents' total; "
    "where only active formations give and activity needs support, a formation a relatum descends "
    "from across a step is supported there, so one unsupported at a step leaves no descendant "
    "across it and one never supported leaves none, and read of needs on a condition every parent "
    "depends on, the parents' needs weighted by their offspring are at most the level counted "
    "once for every offspring; where "
    "a flow transmits a dependence within a bound, a descendant depending on the condition at its "
    "first standing step descending only from formations depending on it and needing it at most "
    "the bound more, a descendant's need is at most the condition's level at the giving step plus "
    "the bound, met there only when the bound is zero, as a child transmitted within one and "
    "never supported shows, and in a balanced flow its need with everything taken from the "
    "condition since an "
    "earlier step is at most the level then with everything given since, plus the bound; a parent "
    "taking from a pool and giving to two descendants leaves the one inheriting its need "
    "unsupported from its first standing step on, while the one needing less is supported, active "
    "and takes in turn, and without the premise that activity needs support a formation active "
    "beyond its support transmits a need above the level at its giving step. "
    "SelectionTerm: over any finite family read with weights and amounts, the number of members "
    "times the weighted total with the discordant pairs is the total weight times the total amount "
    "with the concordant pairs, so with offspring numbers as weights the weighted total exceeds its "
    "uniform share exactly where concordance exceeds discordance, uniform offspring numbers or "
    "amounts leaving neither, and with Price's counting identity the number of parents times the "
    "offspring's total with what transmission lowered and the discordant pairs is the number of "
    "offspring times the parents' total with the concordant pairs and what transmission raised; "
    "where only active formations give and activity needs support a reading highest at the "
    "supported parents has no discordant pair, and over generations of descent its mean, never "
    "lowered by transmission, does not fall over any stretch and with exact transmission moves only "
    "upward, through a step with concordant pairs; over generations each the offspring "
    "of the last, "
    "the mean amount is kept across a step exactly where these balance and rises exactly where "
    "they raise, is kept or rises over a stretch where it is at every step, and a moved mean has an "
    "unbalanced step, found by deciding each, with selection proper where transmission is exact and "
    "inexact transmission where offspring numbers are uniform. "
    "Reproduction: read on the weights themselves no pair is discordant, so the number of members "
    "times the total of the squared weights is the square of the total weight with the squared "
    "differences over pairs, equal to the square exactly where the weights are uniform; over "
    "generations read by offspring number a generation's total is the next size, the mean offspring "
    "number does not fall where transmission lowers none and with exact transmission rises exactly "
    "where offspring numbers vary; a parent's offspring number is at most what it gives them and, "
    "its offspring distinct within a family dissipated on, with one more at most what it takes from "
    "the family; distinct offspring standing within a family balanced and dissipated on number, with "
    "the formations taking from it, at most its stock; a lineage within a family balanced and "
    "dissipated on at each step reproduces at most its stock many steps and ends, and read by "
    "offspring number one that began reproducing has a step at which transmission lowered offspring "
    "number by more than the concordance and what transmission raised; without dissipation a "
    "lossless relay keeps a lineage going within a family of stock one; counted Cauchy-Schwarz over "
    "any finite list, so the concordance with the discordance of offspring number with any carried "
    "amount, squared, is at most the squared differences of offspring numbers over pairs times those "
    "of the amount, attained on offspring number itself, and with exact transmission the "
    "cross-multiplied rise or fall of the amount's mean, squared, is at most that; witness an amount "
    "with no covariance beside varying offspring numbers. "
    "SelectionLevels: over a family listed as k groups of equal size, the whole's concordance with k "
    "times the groups' own discordance and the discordance among groups read by their totals equals "
    "the whole's discordance with k times the groups' own concordance and the concordance among "
    "groups (the multilevel form of Price's equation, the law of total covariance with denominators "
    "cleared); an amount selected against within the groups is selected for in the whole only where "
    "selection among the groups goes for it, and conversely; uniform groups leave selection among them "
    "alone, groups alike in total k times selection within; over listed generations with exact "
    "transmission the mean rises exactly where the two levels together select for the amount; "
    "lineages of groups uniform in an amount keep the value each was founded at under exact "
    "transmission, so nothing is selected within them and the mean rises exactly where the "
    "lineages' means select for the amount; witnesses where the whole goes either way. "
    "GroupEnding: where every group with less of an amount than another leaves no offspring nothing "
    "is discordant among the groups, so the whole selects for the amount exactly where k times the "
    "within-group discordance is below k times the within-group concordance with the concordance "
    "among groups, and with groups uniform in it never against it; where only active formations "
    "give, a formation not active leaves no descendant, and a member depending on a condition whose "
    "gated renewal ran into joint excess leaves none from then on; over generations of descent with "
    "exact transmission the mean rises where the groups with less are not active and a group with "
    "more leaves offspring; one condition shared by every group, once it ends them, leaves the next "
    "generation empty; a member depending on any condition of a family whose renewal is gated on the "
    "family read as one leaves no descendant after the family's excess, groups whose members depend "
    "on one such family end together with nothing selected among them, and where the groups with less "
    "of an amount depend on such a family they leave nothing; with groups formed by descent from "
    "groups uniform in an amount and exact transmission, where at each step the lineages founded "
    "lower are not active nothing is discordant and the mean never falls below where it started, "
    "rising wherever a higher lineage leaves offspring beside a lower one. "
    "Drift: a next generation of two kinds sampled n times from listed offspring, p of the first "
    "kind and q of the second, each sampling weighed by the ways of drawing it; p + q times the "
    "weighted count of the first kind is n p times the whole weight (p + q)^n, and likewise for the "
    "second; where (p + q) h + g = N p the samplings with at most h/N of the first kind weigh, times "
    "n^2 g^2, at most N^2 n p q (p + q)^n, and at least q^n, the weight of the samplings with no draw of "
    "the first kind; over listed generations a step that raises the mean of an amount held or not "
    "has a positive gap with that bound, and on the base so does a step at which the groups with less "
    "of the amount are not active; over k sampled generations of a population of N, each drawn from "
    "the last, the final count summed over the histories is h (N^N)^k, the counts 0 and N absorb, the "
    "histories still varied weigh at most r^k with r + 2 = N^N, and N times the histories fixing the "
    "first kind lies within N r^k below h (N^N)^k and at most it; witnesses one draw from three and two, "
    "and two members over one generation. "
    "Space, one structure for Ren's proposal (an AI reading): a world is relata read with one "
    "kind, the flow among them and their web, and the space is every world; the laws stated with "
    "no premise hold of each; in a finite world whose activity is decided, arising recurs exactly "
    "when ceasing does, asked of every finite world without decidability this law is "
    "equivalent to excluded middle, and with excluded middle as a hypothesis it holds of every "
    "finite world, "
    "while with infinitely many relata either recurs without the other; the activity reading "
    "is named arising and ceasing, English names Ren confirmed, and which parts Ren's generative and "
    "degenerative name is Ren's to choose; activity needing support, balance, "
    "only active "
    "formations giving, only active formations taking what they draw on, dissipation, embodiment "
    "and a reserve carrying activity are each met by some worlds and not by others; among finite "
    "worlds arising recurring or not, and with decided activity ceasing recurring or not, occurs "
    "both with every event living and with some event not living, a grazer drawing down a pool "
    "another relatum depends on giving the latter without drawing on a self-bearing relatum at "
    "its own ending, while the relatum depending ends at that step, as under activity needing "
    "support undermining a dependence persisting unchanged leaves the relatum depending "
    "inactive after the step, its ending where it was active, while in a finite, balanced "
    "seed bank with every relatum embodied and activity needing support a drawer undermines a "
    "dormant seed's dependence and nothing ever ceases; in a finite, balanced, dissipative world in "
    "which whatever arises is embodied, neither arising nor ceasing recurs, with no decision "
    "procedure, and without finiteness, dissipation, balance or embodiment arising can recur, the "
    "world failing balance exchanging at every step. "
    "Premises: a census and bounded transmission are premises of worlds too; activity needing "
    "support makes activity carried, embodiment makes whatever arises embodied, a finite world "
    "whose activity is decided has a census, and where only active relata take and the flow "
    "dissipates only active relata give across an enclosed step, and every step of a finite "
    "world is enclosed; activity needing support, balance, only active relata giving, only active relata "
    "taking what they draw on, dissipation, embodiment, a census and bounded transmission are "
    "independent, each failed by a world meeting the other seven, the worlds failing a census or "
    "only active relata giving being infinite, and for balance a draining world takes from a "
    "closed family at every step; mutualists active throughout meet all eight, and a finite "
    "world which meets them comes to rest, with no decision procedure, by balance, "
    "dissipation and embodiment; in hatch, not finite, all eight hold and each binds, "
    "something meeting the condition of each, though its ground relata are idle and only the "
    "food, the parent and the young are ever active, so that a census follows from the list "
    "of what is ever active; binding is an instance of each condition, which need not exclude "
    "anything the representation allows; no finite world binds every premise, and without its "
    "idle ground hatch is a finite world meeting the eight in which every condition but the "
    "census has an instance. "
    "Sampling: read at strictly increasing times, balance on a family composes across a coarse "
    "step where each relatum is listed once at the fine steps inside, dissipation composes with "
    "no condition, closure across a coarse step is exactly closure across each fine step inside, "
    "and running down composes where the family holds what stands at the two coarse ends, so the "
    "law of one exchange and the exact conditions of coming to stand and ceasing to stand hold "
    "across the coarse step; balance and dissipation do not compose back to the fine steps, and "
    "only active relata giving, only active relata taking and bounded transmission are "
    "step-relative. "
    "Tower: continuous time as a tower of ever finer discrete readings, each level read at strictly "
    "increasing times from the next; the laws pass to coarser levels, and the changes across a "
    "coarsest stretch read at any level, what stands running down at each fine step, number at most "
    "the total standing at its start, independently of the level. "
    "Openness: under balance and dissipation, across a step enclosed around what stands, the "
    "total standing does not rise and any condition's standing rising or falling lowers it, so "
    "where what stands is listed and every step from some step on is enclosed around it, "
    "standing stops changing, and so does the exchange, any taking or giving at such a step "
    "lowering the total standing, while without enclosure, dissipation, balance or the census "
    "of what stands the exchange recurs in exposed, the cycle, leaking and throughput; in a world with a census whose activity is decided, ceasing "
    "recurs only where arising recurs, not conversely; where at most B relata are active at "
    "each step arising recurs exactly when ceasing does, every census of a finite world is "
    "bounded by the number of its relata with no decidability, a procession with one relatum active at a time among infinitely many keeps "
    "arising and ceasing, and accretion has no bound; a bound returning within some number at "
    "arbitrarily late steps keeps the two together, while in slow, for any non-decreasing, "
    "unbounded bound however slow, the relata below it are active, arising recurs and nothing "
    "ceases; under a census of what stands, ceasing to "
    "stand recurring needs coming to stand recurring, and with a bound they recur together; "
    "where what stands is listed, whatever arises embodied, balanced and dissipative, enclosed "
    "around what stands from some step on, arising stops and settles; the rest theorem: with "
    "a census of what is active as well, the world comes to rest with no decision procedure, "
    "the census used only as a list covering what is active, under which ceasing recurring "
    "leaves a later arising unrefuted after every step, which settling refutes, finite worlds "
    "being a case, the census "
    "of what is active needed (attrition) and the census of what stands needed (throughput, embodiedThroughput), "
    "and in every world to which it applies not unboundedly many relata ever stand or act, "
    "while a list holding every member that ever holds, for every listed determination whose "
    "coming to hold does not recur, would give the limited principle of omniscience; "
    "a world with a census whose relata are embodied, balanced and dissipative, enclosed from "
    "some step on, comes to rest without being finite and without deciding equality, so its "
    "arising without end is incompatible with every late step being enclosed; the sides of "
    "Shuttle exchanging at zero net with an unbounded ground meet all eight premises, no step "
    "enclosed, total standing one, and keep arising without end, while a side holding its "
    "standing in exchange at zero net with an unbounded ground meets all eight with no step "
    "enclosed and never arises or ceases, and mutualists meet the "
    "eight with every step enclosed and come to rest, as does hatch, with every premise "
    "binding, after one arising and one ceasing. "
    "Decidedness: a proposition is decided where it holds or fails, which a decision procedure "
    "gives as data; a number counts the members of a list of which a determination holds where "
    "it sums their indicators, a count exists exactly where each member counted is decided, is "
    "unique, and where a procedure decides is its marks; over a stretch, wherever the counts "
    "exist, those holding at the end with those that ceased are those holding at the start with "
    "those that came to be, with no decidedness even inside the stretch, and likewise where what "
    "holds is listed at each step; in a finite family, while nothing ceases each member comes to "
    "be at most once, so where coming to be recurs ceasing never stops for good, and conversely, "
    "with no decidedness, the step being found where the stretch is decided; decided from some "
    "step on, coming to be recurs exactly when ceasing does, in finite families, in webs with "
    "finitely many formations and in finite worlds, a covering list asking decidedness only of "
    "its members; an amount that does not rise settles, so the rest theorems need no decision "
    "procedure. "
    "Refinement: members of a list pairwise apart under a relation joining each member to itself "
    "are no more than the list; a chain of equivalences, each finer than the one before and decided "
    "among N listed members, with c of them apart at the first step, stops refining at some k with "
    "k + c <= N, and the decisions of finitely many propositions are together refuted by nothing. "
    "Counting: what the premises add to the laws of counting, the tally being the whole law "
    "of counting with no premise: "
    "relata queuing with nothing flowing meet every premise but "
    "embodiment and relata queuing that stand while active every premise but balance, so a "
    "property of a census's counts holds in every world meeting either seven exactly when it "
    "holds of every tally, while balance and embodiment, with only active relata giving, "
    "leave nothing arising across a step at which nothing is active, which no tally law "
    "requires, and that is all the eight add: an open queue, its front giving to each "
    "relatum joining, taking from each leaving and while active exchanging a unit each way "
    "with every ground relatum, meets all eight wherever nothing joins an empty queue, so a "
    "property of the counts holds in every world meeting the eight exactly when it holds of "
    "every tally in which nothing arises across a step at which nothing is active; in the "
    "open queue dissipation, activity needing support and bounded transmission hold vacuously, "
    "and where every premise binds every census counts something arising, which is no law "
    "under the eight. "
    "Under each of the 256 selections of the eight premises the laws of counting are the "
    "tally alone, or the tally with nothing arising across a step at which nothing is "
    "active, the second exactly where balance and embodiment are selected with only active "
    "relata giving, or with only active relata taking and dissipation: at a step at which "
    "nothing is active nothing is then taken, whatever is given comes to stand and is active "
    "after the step, the relata active after it form a closed family, and dissipation lets "
    "nothing be given to it; a queue driven by an inactive ground relatum meets every premise "
    "but only active relata giving and taking, and the open queue, whatever its counts, "
    "every premise but only active relata giving and dissipation. "
    "Under balance and dissipation, with every "
    "step from some step on enclosed, the relata active together with the steps of change "
    "since stay within the total standing at that step, and an enclosed queue, its front "
    "standing at what the bound leaves and taking from each member what its standing "
    "loses, is enclosed by its span and meets all eight premises under every tally with a change "
    "bound from the first step in which nothing joins an empty queue, so a property of the counts "
    "holds in every world meeting the eight and enclosed from some step on exactly when it "
    "holds of every tally with a change bound from the first step in which nothing arises across a step "
    "at which nothing is active; on finitely many places such a queue is a finite world "
    "meeting the eight, so finite worlds have the same laws of counting; with one member "
    "replaced across the first step dissipation binds and the bound is attained, and a step "
    "after which nothing arises, for every finite world meeting the eight whose activity is "
    "decided, would give the limited principle of omniscience. "
    "Under each selection of the premises, with every step from some step on enclosed, "
    "balance, dissipation and embodiment leave nothing arising across an enclosed step at "
    "which nothing is active, and where the three are selected the laws of counting add a "
    "change bound from some step with nothing arising from then on across a step at which "
    "nothing is active; an enclosed queue closing at that step, every relatum exchanging a "
    "unit each way with the front before it, witnesses this where neither only active "
    "relata giving nor taking is selected; the change bound is a law under enclosure exactly "
    "where balance, embodiment and dissipation are selected, and otherwise enclosure adds no "
    "law. "
    "In finite worlds every step is enclosed, so under each selection the laws of counting are "
    "those of a tally with at most some number active at each step, adding nothing arising "
    "across a step at which nothing is active exactly where balance and embodiment are selected "
    "with only active relata giving or with dissipation, and a change bound from the first step "
    "exactly where balance, embodiment and dissipation are selected; a queue seated in turn round "
    "a ring of places counts every such tally, with nothing standing meeting every premise but "
    "embodiment, with each place standing while held every premise but balance, and with the "
    "front's place taking what falls and giving what rises every premise but dissipation; finite "
    "worlds and worlds enclosed from some step on have the same laws of counting under a "
    "selection exactly when it bounds change and binds counting. "
    "Where every premise binds, each condition having an instance, the laws of counting under "
    "the eight are the tally, that nothing arises across a step at which nothing is active, and "
    "that something arises: a queue closed once, open across every step but one, at which its "
    "front stands more than join, exchanges only within the queue and loses that excess, every "
    "relatum depending on every relatum at what it stands at, meets the eight with every "
    "premise binding wherever something joins across some step, though there activity needing "
    "support and bounded transmission hold whatever is active and whatever flows; every premise "
    "binding decides neither rest nor change without end, and no finite world binds every "
    "premise, while in finite worlds in which every premise but the census binds the laws of "
    "counting under the eight are those of finite worlds and that something arises. "
    "Under each selection, where each selected premise binds, the laws of counting are those "
    "under the selection and three more: something is active, exactly where activity needing "
    "support, only active relata giving, only active relata taking or embodiment is selected; "
    "something arises, exactly where embodiment is; and something arises across a step at "
    "which something is active, exactly where embodiment is selected with balance and only "
    "active relata giving or only active relata taking and dissipation, or with only active "
    "relata giving and bounded transmission; saturating a web, every relatum depending on "
    "every relatum at what it stands at, keeps the premises a world meets where levels are "
    "bounded, and a lossy queue, its front exchanging a unit each way with itself and each "
    "member joining and losing one unit more, and a relay handing one of two units to a "
    "ground relatum and losing the other, witness the rest. "
    "With every step from some step on enclosed, where every premise binds the laws of "
    "counting under the eight are those under enclosure and that something arises, an "
    "enclosed queue with its web saturated binding every premise. No finite world binds a "
    "selection with the census; in finite worlds, under each selection without it, where each "
    "selected premise binds, the laws of counting are those of finite worlds under the "
    "selection and the same three, the third also where embodiment is selected with balance "
    "and dissipation, or with only active relata taking, dissipation and bounded transmission, "
    "which in a finite world give only active relata giving; a relay beside a ring, a lossy "
    "ring and a ring exchanging a unit each way with its front's place witness them. "
    "With every step from some step on enclosed, where the premises of each selection bind, "
    "the laws of counting are those under enclosure and the same three, each under the same "
    "selections as where nothing is enclosed, since what arises may arise before enclosure; "
    "the relay and the lossy queue, a queue exchanging a unit each way with its front, and a "
    "queue closing at a step at which something is active, whose front sheds a spare unit "
    "there so that dissipation binds at a closed step, witness them. "
    "Standing: where every relatum is embodied what stands is what is active, and where "
    "embodiment is not selected a queue whose members stand without acting, fed by a ground "
    "relatum active throughout and standing at nothing that exchanges a unit each way with "
    "every ground relatum, meets every other premise whatever its counts, so under each "
    "selection the laws of counting what stands are those of counting what is active; under "
    "balance and dissipation alone, with every step from some step on enclosed, the change of "
    "any census of what stands stays within the total standing at that step and nothing comes "
    "to stand across an enclosed step at which nothing stands, so with enclosure from some "
    "step on the laws of counting what stands add, where balance and dissipation are selected, "
    "a change bound from some step with nothing coming to stand from then on across a step at "
    "which nothing stands, a waiting queue, whose next to join is active before it stands, "
    "witnessing this without embodiment; in finite worlds the laws of counting what stands are "
    "those of a tally with at most some number standing at each step, nothing coming to stand "
    "across a step at which nothing stands where the selection binds counting or selects "
    "balance and dissipation, and a change bound from the first step where it selects balance "
    "and dissipation, a ring each of whose places is active throughout witnessing the rest. "
    "The premises add nothing to the law of counting dependences: members of a queue, or "
    "places of a ring, depending while in it on a common condition standing at one and "
    "active throughout, each needing a unit of it and met, with nothing flowing, meet all "
    "eight whatever the counts, so under each "
    "selection, with enclosure from some step on and in finite worlds, where at most some "
    "number hold at each step, the laws of counting dependences are the tally's. "
    "Descent: read with one kind of relatum, an event living on a relatum, drawing on it and "
    "depending on it at a positive need, is related to that relatum's events, and an event is "
    "related to the events of the relata it descends from and that descend from it, descent "
    "relating every event of the two, while a give entry "
    "of a formation taking no part makes no descent; living on, like interaction, needs a "
    "dependence that can fail, so under the premise that activity needs support the relatum an "
    "active formation lives on stands at that step and, if embodied, is active there, while a "
    "dormant relatum standing while asleep can be lived on; under N_rel valuing an "
    "event that lives on a relatum reaches that relatum's living events and conversely, and "
    "valuing any event of a formation reaches the living events of the relata descending from "
    "it and conversely; in a balanced flow in which only active formations give, an embodied "
    "relatum that arises descends from another formation active at that step; generations "
    "each given by the one before are connected by descent and by neither co-participation "
    "nor interaction, and living significance there is exactly a seed with N_rel and N_std; a bee and a flower "
    "depending only on each other are connected by living on, and relabelling their "
    "conditions each onto the other keeps co-participation and interaction and removes that "
    "connection; a seed descends from the parent that provisioned it while dormant, and "
    "waking from dormancy descends from nothing. "
    "Resolution: counted in a unit that may split into finer units across each step, the "
    "splitting counted as one more formation, which gives each condition the finer units it "
    "adds and takes nothing, makes balance at that resolution the spine's balance; with it "
    "counted a flow dissipates on a family exactly where its own formations do and the "
    "refinement gives the family nothing, so across a step enclosed and dissipated on with it"
    " counted the refinement gives nothing, and in a world with a census and embodied relata,"
    " balanced at that resolution and, with the refinement counted, dissipative and enclosed "
    "at every step from some step on, neither arising nor ceasing recurs, with no premise "
    "added to the spine's; without counting it the same holds wherever the refinement gives "
    "nothing, where taking from a closed family and the activity of a formation beyond "
    "support also stop, and each witness below is fed by it; a flow balanced at a refining "
    "resolution and dissipative has, over any family closed from some step, the quanta of the"
    " unit of that step it loses within the loss law: where each step loses k quanta, the "
    "quanta counted from that step are at most q times the quantity there, so steps losing at"
    " least 1/q of the unit number at most q times the stock and do not recur; with the unit "
    "fixed, taking from a closed family stops; where every closed family gets back at most q "
    "parts in q + 1 of what is taken from it, everything taken from a family closed from some"
    " step, summed with each step's amount counted in the unit of that step, is at most q + 1"
    " times its stock there and everything given back at most q times, in a world with a "
    "census, embodied relata and every step enclosed likewise of what stands, the bound being"
    " the least, approached by a pool passed in full at each step with q parts in q + 1 given"
    " back; each count of a size follows from it, so formations taking at least 1/p of the "
    "unit from a family closed from some step number at most p (q + 1) times its stock, and "
    "in a world with a census, embodied relata and every step from some step on enclosed, "
    "relata gaining at least 1/p of the unit number at most p q times the total standing, so "
    "such gains, and arising at that size, do not recur; relata falling by at least 1/p of "
    "the unit number at most p (q + 1) times the total standing, so neither arising nor "
    "ceasing at that size recurs; where each active step beyond support lowers the reserve by"
    " at least 1/p of the unit, an unsupported formation is active at most p times its "
    "reserve, the spine's reserve being the case of p one at a fixed unit; at a unit "
    "splitting without end, a closed pool is taken from without end, the flow not balanced at"
    " the fixed unit, a whole unit is exchanged at every step with one unit of the step after"
    " lost and no proportion lost, a new relatum arises at every step inside an enclosure "
    "with half of what is taken lost, the world not balanced at the fixed unit, two sides "
    "hand a whole unit back and forth inside an enclosure, each arising in turn, with no "
    "proportion lost, and a formation never supported is active at every step, its reserve "
    "falling in the finer unit at each with no least fall; where the flow dissipates and each"
    " formation taking at least 1/p of the unit loses at least 1/m of it, such takings number"
    " at most m times the stock, while a whole unit passing in ever more, ever smaller "
    "transfers, each size with a least loss, arises without end and is taken without bound in"
    " amount. "
    "Amounts: over amounts with an associative, commutative addition with nothing as its unit "
    "and an order that addition keeps and cancels, with nothing least and possibly dense, the "
    "losses of a stock that falls by them, added since a step, are within its value there; an "
    "amount that does not rise from a step on and falls by at least a least loss at each step at "
    "which a change happens, with its value there not within m copies of the least loss, does not "
    "change at arbitrarily late steps, and with the premises read as far as can be refuted it is "
    "not the case that after every step a later change stays unrefuted; in Archimedean amounts "
    "a least loss above nothing suffices; with no least loss, in Archimedean amounts, for every "
    "amount above nothing fewer than some count of steps lose at least it, and steps losing at "
    "least it do not recur (the approach to rest), in whole numbers no more steps losing anything "
    "than the stock counts; a family balanced and dissipated on with a least loss "
    "rests the same way; whole numbers are Archimedean with least loss one, and the spine's "
    "descents falls_not_recurring and falls_stop_unrefuted, the laws that taking from a family "
    "dissipated on does not recur and is bounded by its stock over a stretch, and that standing "
    "stops changing are proved as this instance. "
    "LeastLoss: dyadic amounts are dense and Archimedean, and in them a stock halving at every "
    "step loses at every step with no least loss and never rests; in layered amounts a stock "
    "falling by a least loss at every step lies beyond every multiple of it and never rests, and "
    "they are not Archimedean; the halving stock approaches rest and falls at every step; over "
    "finitely many configurations a process merging nothing loses nothing along a run, and so a "
    "law along an orbit, so a loss above nothing needs a merge; an amount read off configurations a "
    "list holds that does not rise falls strictly at most as often as the list is long, over any "
    "amounts, so its falls do not recur with no least loss, and with its not rising and its falls only "
    "not refuted that they stop cannot be refuted, along a run of every process too, and the "
    "halving stock's values are no list's; under a law merging nothing, possibilities no two alike "
    "stay so, and read by a part and a rest that tell them apart number at most the part's count "
    "times the rest's, so a part reset at every step needs a whole no list holds, as in Reset, whose "
    "part merges at every step while the whole merges nothing. "
    "InAmounts: totals over any amounts keep the order, split over addition and exchange two lists, and "
    "where each member's amount is at least another's and the totals are the other way each member's is; "
    "a world's standings, takes and gives read in any amounts, a family balanced with no amount made and "
    "dissipated on, whatever gives back all it takes taking nothing, has a total that does not rise and "
    "that falls strictly at every rise or fall of a member's level; where that total is read off "
    "configurations a list holds its changes stop, unrefuted, and a world whose active relata lie in the "
    "family and whose arising is embodied rests from some step on, unrefuted, as does a world with a census, "
    "every relatum embodied, balanced, dissipative and enclosed from some step on whose census total is "
    "read off configurations a list holds, the enclosing family widened as far as can be refuted; every "
    "world is a world in whole-number amounts with its own premises; in HalvingPass a standing halving as "
    "it passes between two relata meets every other premise and arises and ceases at every step, and no "
    "list holds its levels. "
    "Units: at a unit splitting into r t finer units across each step, arising needing an active "
    "giver holds with no condition on r, the law of one exchange holds with change read in the "
    "unit and fails read in raw counts, a need counted in the same unit as the level leaves support "
    "unchanged by the split, and laws counting a loss over a stretch need a fixed unit or the "
    "refinement counted as a giving. "
    "Imbalance: across a step a condition's level changes by what the flow gives and takes "
    "exactly where the flow balances there; counting the difference as the exchange of one "
    "more relatum, never active and requiring nothing, every flow balances, the flow balances "
    "on a family across a step exactly where that relatum neither gives nor takes on its "
    "members there, and the two representations are equivalent step by step: on a family "
    "across a step, only active relata giving, and only active relata taking and only what "
    "they draw on, hold of the extended flow exactly where they hold of the flow and it "
    "balances there; nothing is adopted. "
    "Entropy: in a balanced flow every change of a level is an exchange, so the history of a "
    "family's exchanges never shrinks and grows at every change, and an exchange followed by its "
    "reverse restores every level while the history counts both; under the first law, every "
    "closed family getting back at most what is taken from it, the reverse of an exchange is "
    "within the law exactly where the exchange loses nothing, and under dissipation no exchange "
    "is reversed; a carrier handing one unit back and forth in a finite, balanced, lossless and "
    "enclosed world exchanges without end, its configuration coming back every two steps, its "
    "history growing by one at every step and no quantity of its configuration rising at every "
    "change; a flow dissipates on a family exactly where, with a record counted as one more "
    "condition given to and never taken from, every exchange conserves the family with its record "
    "exactly and leaves the record at least one unit, and exactly where, recording each exchange "
    "at one unit, the family with its record gains nothing, both parts needed; under the first "
    "law the amount dissipated with the stock is conserved and is what the record receives; under "
    "dissipation it bounds the history, loss does not recur under the first law, and in "
    "proportion q what is taken is at most q + 1 times it; under the first law the configuration "
    "stays among the configurations of its stock, listed exactly, a family never revisiting a "
    "configuration changes across at most that many steps and rests, so unending change revisits "
    "and admits no quantity of the configuration rising at every change, a finite world that "
    "keeps exchanging carries its history in its configuration from no step on, and with the "
    "change a function of the configuration, rest after a change merges two configurations, "
    "merging none keeps change going and coming back, and never revisiting, under an arrow or "
    "dissipation, merges; one passing then rest rests without dissipation, merging; a record "
    "gathering one unit from a new relatum at every step under exact conservation, every step "
    "enclosed, rises without end in a world not finite. Read as instances of Recurrence: within "
    "the first law's bound the configurations recur, an arrow marks every change and stops it, a "
    "law merging nothing brings the start back, and the present forgets the kept history.  "
    "Continuation: across a step a formation taking part conveys from one condition to another "
    "when it takes from the first and gives to the second, and a family is fed from beyond when "
    "something outside it is conveyed into a member; a step at which a family is fed from beyond "
    "is not inward, and with equality decided a step at which it is not is inward, so every "
    "draw-in law reads as being fed: under balance and dissipation a finite family without "
    "repetition, enclosed around from some step on, from which taking recurs, whose members rise "
    "at arbitrarily late steps or, read with one kind of relatum, in which embodied members arise "
    "at arbitrarily late steps, cannot from any step on be fed from nothing beyond it, while in "
    "the source's flow the pool is fed at every step and no fuel is conveyed from after its own step; "
    "formations can each take from a condition within what a step gives it while together they "
    "take more, taking jointly within what is given keeps the level, each step of joint excess "
    "lowers it by at least one, n consecutive steps of joint excess need a level of at least n at "
    "the start, and two formations each taking a unit with one unit given back admit no balanced "
    "web; where every formation giving to a condition depends on it at a need of at least m, only "
    "active formations give and activity needs support, a level below m stays below m at every "
    "later step and every formation depending on the condition at a need of at least m is "
    "inactive from then on, so joint excess that brings the level below m ends the renewal and "
    "every formation depending on the condition at such a need, a taker among them where it so "
    "depends; the same holds of a family of conditions read as one, where each step at which the "
    "family's uptake exceeds its replenishment lowers its stock by at least one and whatever gives to a "
    "member depends on some member at a need of at least m, the laws of one condition being its "
    "family of one, and a patch renewed by a neighbour within what is taken from it, its renewal not "
    "gated on it, ends with the neighbour read as one with it; as a renewer and two takers "
    "each taking within what the step gives all end after two steps, while with one taker all "
    "continue; a formation living on what a self gives ends when the self stops giving, and the "
    "self, requiring only its ground, continues; a formation active for two steps with every "
    "dependence met while it lives ends the renewal of a shared condition, and another formation "
    "depending on it ends after the first has ended, while without the first the others "
    "continue; and a clearer active at every step, each condition it depends on renewed, fed from "
    "beyond and taken from jointly within what is given, draws down the habitat of a "
    "dweller, which ends, the clearer's event undermining it. No ethical predicate occurs. "
    "Admission: levels admit a formation at a step when they meet every requirement it then has, "
    "and support is admission by the levels that stand; where a formation's requirements do not "
    "loosen across a step it gains support only if a condition it requires rises, and where they "
    "do not tighten it loses support only if one falls; in a balanced flow where only active "
    "formations give and activity needs support, every rise is given by a supported formation, so "
    "support is gained only where a supported formation gives to a condition required, and where "
    "no member of a family is supported, requirements do not loosen and only members give to what "
    "members require, no member is supported again, and of the whole nothing is supported or "
    "active again, each premise having a consistent countermodel; a part, a decided family of "
    "formations, is withheld by leaving the rest of the exchange as it was, the levels balancing "
    "that flow from the same start are unique where they exist, and at every step each level with "
    "what the part has taken from the condition is the level without the part with what the part "
    "has given it; where up to a step the part has given each condition a formation requires at "
    "least what it took, the formation is supported wherever the levels without the part admit "
    "it, and where it has taken at least what it gave, the levels without it admit the formation "
    "wherever it is supported; exactly, a formation is supported at a step when, on each "
    "condition it requires, its need with what the part has taken up to the step stays within "
    "the level without the part with what the part has given; a level path includes another when "
    "at every step it admits every "
    "formation the other admits, a preorder, and exceeds it when at some step it admits one the "
    "other does not; a part giving each condition at every step at least what it takes closes "
    "nothing, one giving no more opens nothing and one giving exactly what it takes changes "
    "nothing; a giver from beyond widens, its levels including and exceeding those without it, "
    "and a conveyor's part is mixed, each level path exceeding the other. No ethical predicate "
    "occurs. "
    "Exclusion: where renewal is given only by formations depending on what they renew, a "
    "formation taking all that is given to a condition makes every other taker a joint excess, so "
    "full taking alongside another taker for as many steps as the level allows ends every "
    "formation depending on the condition at such a need, the full taker included; a full taker "
    "that continues leaves no other formation taking from the condition through a window as long "
    "as the level, a formation active only while it takes from it is not active through such a "
    "window, and one whose activity does not resume once it stops ends; taking jointly within what "
    "is given keeps the level and, where the formations depend on that condition alone at needs "
    "it met at the start, every formation supported; of a renewer and two takers, all end where "
    "both take two, the renewer and the first continue where the first takes all and the second "
    "ends, the ending also following from the law, and all three continue where each takes one, "
    "while the levels of the last two courses admit every member at every step; where a part takes "
    "jointly more than is given, the joint taking exceeds it whatever any other formation takes, so "
    "as many such steps as the level allows end every formation depending on the condition, and with "
    "need one two such flows agree on the condition from then on, however a member's act differs. "
    "No ethical predicate occurs. "
    "Exhaustion: a take that is more than now at each of n steps has risen by at least n, so from "
    "a condition given at most B at each step it takes all that is given after B + 1 steps and "
    "takes more than is given; under balance such taking does not last as many steps as the level "
    "plus one, so a formation that while active takes part with a take more than now is not active "
    "through a window of B + 1 steps and the level plus one, and one whose activity does not resume "
    "once it stops ends, with no need supplied; where renewal depends on what it renews and the "
    "seeker stays active while the condition meets a need, the level falls below that need within "
    "the window and every formation depending on the condition there is inactive from then on; of "
    "a renewer and a taker whose take rises by one at each step, the taker takes all that is given "
    "from step one and ends at step four while the renewer continues. No ethical predicate occurs. "
    "Regions: within a region of formations levels admit everything other levels admit there, and "
    "beyond it some formation the other levels admit these do not; inclusion is admission within "
    "the whole at every step, what holds within a region holds within every region inside it, what "
    "is lost beyond a region is lost beyond every region inside it, nothing lies beyond the whole, "
    "what holds within the whole leaves nothing lost beyond any region, and within one formation "
    "what holds is its own admission; with the clearer's part withheld the levels without it "
    "exist, the clearer is active and supported at every step and within itself and the source "
    "the levels with its part admit all that those without it admit, while from the third step on "
    "the dweller is admitted without its part and not with it, so over the whole its part opens "
    "nothing and closes the dweller; an event is within renewal over a region of conditions when "
    "it is active and the step keeps every dependence on every condition of the region it takes "
    "part in; renewal at a step is renewal over every region, renewal over a region covering every "
    "condition the formation takes part in is renewal at the step, and renewal over a region "
    "covering every condition it requires keeps its own support where its requirements do not "
    "tighten, while the clearer renews over its resource at every step and undermines at step "
    "one, and a formation renewing over a region omitting a condition it requires undermines its "
    "own dependence by its own draw and loses its support. No ethical predicate occurs. "
    "Standpoints: a living claim is held when it lies in the own region of some position; where "
    "every living claim is held, significance of every living claim from every standpoint (living significance at "
    "claim level) is equivalent to S0 at every position with standpoint neutrality, using neither "
    "connection nor relational neutrality; with holding decided and every living claim reached "
    "through formed relations from a held living claim, it is equivalent to S0 at every position, "
    "standpoint neutrality and relational neutrality into claims no position holds; each premise "
    "has a consistent countermodel, every life held and valued only by its own standpoint with "
    "neither neutrality holding, a life no standpoint holds, and a reached life no position "
    "holds; S0 at every position carries significance along any relation into each position's "
    "own region, and on a connected whole where every position holds a living claim, S0 at every "
    "position with relational neutrality gives living significance at claim level without standpoint neutrality; "
    "read stepwise with each "
    "formation a position whose own region is its own events, every living event is held and living significance "
    "is S0 at every formation with standpoint neutrality; read with one kind of relatum, "
    "conveyance relates two events at a common step when something is conveyed between their "
    "relata, a relatum nothing is taken from or given to at a step is related to nothing there, "
    "the region of a finite family under balance and dissipation, enclosed around from some step "
    "on, from which taking recurs, is from no step on left uncrossed and so is no cut in the "
    "relations, and under relational neutrality valuing a relatum's event reaches the living "
    "event of what is conveyed into it, while interaction, living on and descent relate no two "
    "conditions at any steps, so the clearer's fuel and resource, crossed at every step, are "
    "related by conveyance alone, while under living on the resource's region, which the clearer "
    "lives on, is no cut either; the clearer's own event that undermines is not living, so S0 says "
    "nothing of it; where each formation holds and values its own events and the clearer values "
    "also the events that feed the condition its continuation requires, every life in the "
    "clearer's web is held, S0 holds at every position and each standpoint's significance is "
    "closed along feeding, while the dweller's living event has no significance from the "
    "clearer, so standpoint neutrality and living significance fail, and transmission out of the clearer's own "
    "region along the formed relations fails. No premise is proved and no ethical axiom is "
    "assumed. "
    "Significance: a significance says, for a standpoint, a step and a formation, whether the "
    "formation's continuation at the step has significance from the standpoint; the continuation condition is that "
    "no standpoint, step or formation restricts it, boundary neutrality for the significance of "
    "continuation, and a significance bounded by regions is the same rule inside a formed "
    "boundary and is not the continuation condition where some formation lies outside some region; under the "
    "axiom, on every reading in which a claim's significance is that of a formation's "
    "continuation at a step, every living claim is significant from every standpoint, S0 holds at "
    "every standpoint, both neutralities hold and a seed exists wherever something lives, with no "
    "connection used, the stepwise reading, the reading of relations and the whole-run reading "
    "being such readings, and on the level paths of a web living significance holds with unindexed significance "
    "and C holds with better read as retaining and adding what has significance; a level path "
    "retains what has significance along another when it admits every continuation with "
    "significance the other admits, a preorder never added to by what it retains, and adds when "
    "it admits one the other does not; under the continuation condition retaining is inclusion and adding is "
    "exceeding, alike from every standpoint; the levels with a part retain what has significance "
    "without it exactly when the part's net draw stays within the margin for every continuation "
    "with significance the levels without it admit, the part loses one exactly where its net draw "
    "exceeds the margin, and adds one exactly where its net exchange brings within the margin a "
    "formation the levels without it do not admit; under the continuation condition the conveyor's part is "
    "unordered and the giver's part retains and adds; a drawer taking a condition's unit before "
    "any dependence on it forms is active and not undermining, yet its part closes a formation "
    "admitted at every step without it, and under the continuation condition loses a continuation with "
    "significance; where fewer continuations have significance more is retained, significance "
    "bounded by a region retains what is admitted within the region, and under the continuation condition what "
    "retains retains within every region; with each formation's significance stopping at what its "
    "continuation depends on, the clearer's part retains what has significance from the clearer's "
    "standpoint and loses the dweller from the dweller's, while under the continuation condition it loses the "
    "dweller from every standpoint, the levels without it admitting every formation at every "
    "step; where nothing has significance every level path retains every other, none adds, and "
    "living significance fails at any living event. The continuation condition is a hypothesis; no ethical premise is proved. "
    "An undermining event, through dependences holding across its step at no smaller need, leaves "
    "the levels exceeded by every level path meeting them after it, so a part keeping what can form "
    "does not undermine there; the preempting drawer's event is within renewal and its part still "
    "closes a possibility. "
    "RelativePosition: a part's position against the others, kept as two counts, is zero-sum by "
    "counting across every change of amounts: a part's change is the opposite of the rest's summed "
    "change, no change raises every part, a rise needs another's fall, and every part can draw "
    "more while a position falls; n steps of joint excess, with balance, end at step T + n a part that "
    "then requires the condition at a need above the level at T less n and is active only while "
    "supported, whatever its position; with renewal gated the greatest parts end for good; "
    "Restored and Clearing show gated renewal and dependence needed. "
    "Interdependence: a formation's continuation is fed by another at a step when the other "
    "gives to a condition it then requires; a region closed under feeding holds every feeder of "
    "its members, and a formation's feeding closure, what lies in every closed region holding "
    "it, holds it and its feeders, is transitive and is itself closed, and nothing beyond it "
    "gives at any step to a condition a member then requires; under balance, with only active "
    "formations giving and activity needing support, a formation taking from a condition at "
    "every step at which it is active, while nothing supported gives to the condition, is "
    "active for at most as many consecutive steps as the condition's level at the start, and so "
    "does not continue, which holds where everything feeding it is unsupported; of two "
    "formations feeding each other's condition, one taking from both renews over the condition "
    "it requires and keeps its own support across the step while undermining the other, which "
    "is unsupported from the next step on, after which the first is active for at most one "
    "step more, while taking only their own both continue; in the clearer's web the region "
    "along dependence is each formation's feeding closure, the dweller lies beyond the "
    "clearer's, and everything within it is supported at every step while the dweller ends; "
    "significance bounded by a region retains as inclusion does wherever every formation the other "
    "path admits lies in the region or is admitted by the first. No ethical premise is used and the "
    "continuation condition is not assumed. "
    "BoundedSignificance: significance bounded by the whole is the continuation condition, and under "
    "the continuation condition significance bounded by a region retains as the condition does wherever "
    "every formation the other path admits lies in the region or is admitted by the first, so on "
    "every comparison where a formation's feeding closure is the whole, while in the clearer's "
    "web the clearer's part retains within its closure and under the continuation condition loses the dweller. "
    "The continuation condition is a hypothesis of the comparisons only. "
    "Feeding: possible carrying of a positive amount given is characterized by positive standing "
    "throughout the stretch; same-step feeding is zero-delay feeding across steps; the least "
    "closure under feeding across steps contains the old feeding closure, strictly in Provision, "
    "and nothing beyond it gives to a carried condition a member requires; local balance "
    "characterizes meeting needs across a step and stretch, consumption beyond the initial level "
    "exhibits a supported feeder, and withholding a giving-only part preserves a need exactly "
    "within its cumulative margin; Redundant admits either feeder alone but withholding both with "
    "the rest fixed leaves no balancing path. No ethical premise is used. "
    "Feedback: a region is closed under a relation when whatever a member bears it to is a member, "
    "and a formation's closure under it, what lies in every closed region holding it, is reflexive "
    "and transitive, grows with the relation and is symmetric under a symmetric one; the feeding "
    "closure is the closure under being fed at some step; a formation is affected by another that "
    "exchanges with a condition it depends on, the influence closure is the closure under being "
    "affected and the reach closure the closure under affecting; two formations share a condition "
    "both take part in, by depending on it or exchanging with it, and the system is the closure "
    "under sharing, a class; the feeding closure lies within the influence closure, and the "
    "influence and reach closures within the system, each inclusion strict in a witness: in a "
    "trophic cascade wolves lie beyond a forest's feeding closure and within its influence closure "
    "and a formation far off beyond its system, and in the clearer's web the dweller lies beyond "
    "the clearer's influence closure and within its reach closure, which lies strictly between the "
    "clearer and the whole; where every formation takes part in one condition every system is the "
    "whole, where every formation depends on it and exchanges with it every reach closure is, and "
    "where at one step every formation requires it and gives to it every feeding closure is, "
    "significance bounded by it then being the continuation condition; two balanced flows that start a condition "
    "alike and take and give alike keep it alike, so a formation's support registers only its "
    "exchanges with what it depends on, and with a part withheld the levels agree on a condition "
    "at a step exactly where the part has given it, before that step, what it took from it; "
    "nothing beyond a formation's influence "
    "closure exchanges with a condition a member depends on, so a part whose members all lie "
    "beyond it registers nowhere within it, and the clearer's support is the same whether or not it "
    "clears the habitat while the dweller ends; a part reaches a formation before a step when a "
    "member exchanged, at an earlier step, with a condition the formation requires at that step, "
    "and what it has not reached is admitted alike with and without it; a part whose members lie "
    "within a region closed under affecting reaches only within it, the reach closure and the "
    "system being such regions; two significances agreeing at each step on what a part has reached "
    "compare the levels with and without it alike, and any significance covering what it has "
    "reached gives the continuation condition's comparisons, retaining exactly as including, both ways, and neither "
    "adding exactly where neither exceeds, adding being exceeding where significance is decidable "
    "and up to double negation otherwise; significance bounded by a region closed under affecting "
    "compares every part within it as inclusion does; the comparison of any two balanced flows "
    "that start alike is decided within what their difference reaches; with the deer's browsing "
    "held fixed the wolves' part narrows, against the flow in which the deer respond it is mixed, "
    "and where a part gives what others take the levels without it may balance no flow. The continuation condition "
    "is not assumed; the theorems reading significance under it (that bounded significance is the "
    "condition, and the witnesses' verdicts under it) are in BoundedSignificance. "
    "Cuts: removing links from a relation changes no closure exactly where every removed link's "
    "ends stay within each other's closure under what remains, and after a link is joined a "
    "formation lies within another's closure exactly where it did, or the other reaches one end "
    "and the far end reaches it; a formation that takes part in no link reaches only itself and "
    "nothing else reaches it, so attaching it changes no closure among the others; in a relation "
    "grown by attachment each link is listed once and removing any one leaves its ends apart, and "
    "after one more link is joined, cutting a grown link changes no closure exactly where the "
    "joined link's ends lie on its two sides; on the base, every system is what it is without a "
    "condition exactly where any two formations taking part in it lie in one system through the "
    "others, a condition with one taker is needed by none, a condition exactly two formations take "
    "part in joins their systems as one link would, a formation taking part only in a condition is "
    "alone without it, and one taking part in no condition has only itself in its system. No "
    "ethical premise is used. "
    "Testing: a formation registers its support, whether the levels admit it, and the levels of "
    "the conditions it observes; a condition it depends on and does not observe registers only "
    "whether it meets the need, an observed one its level, and observing more distinguishes more; "
    "a claim about level histories is refuted at a step when no history meeting it registers alike "
    "up to that step, only through a difference in what registers, never where it holds, and "
    "lasting; relative to a model, a class of admissible histories, refutation is refutation of "
    "the model and the claim together; without a model no finite record refutes a claim about what "
    "follows it, while relative to the level histories of a flow a formation observing a stock "
    "refutes at the first step every false claim that it comes to nothing, a wrong model refutes "
    "what holds and registration refutes the model; a judgment from registration is a common "
    "response over the formation's belief and is kept as later steps and more observation narrow "
    "it; the registration closure holds the influence closure, is that closure where the "
    "formation registers support only, and grows with observation and exchange; for two flows with the same formations present, balancing "
    "on each condition a member of a region registers, the region closed in both under being "
    "affected through what is registered, the levels starting alike there and each member "
    "exchanging alike wherever it has registered alike, every member registers alike at every step, "
    "and with the rest of the exchange fixed a part beyond the closure is registered within it at "
    "no step, a refutation there resting on a model of the part's exchange; with balance on what a "
    "formation registers and the exchange there following its registration, a difference stays as "
    "it was while the formation registers alike and changes only after the two webs' support "
    "diverges, a stock higher by d standing d higher at every step before which the lower web "
    "supported it; joint failure keeps the difference, observing the stock lifts the blindness, and "
    "where others respond to the stock a higher stock can end the formation first; on a prey "
    "bearing on itself a bite registers through support only where it brings the prey below its "
    "need; in the clearer's web the dweller's ending is tested by the dweller and not the clearer, "
    "a claim neither tests is tested by the two together, and a model fixing the start and the "
    "exchange idles registration; where the continuation is open no reading decided by a finite "
    "prefix is the whole-run classification. Balance is assumed only on the conditions registered; "
    "the response hypotheses are supplied; no ethical premise is used. "
    "Runaway: a policy through registration, with the rest of the exchange on what the formation "
    "registers fixed, is exchange following registration, so every such policy that keeps its "
    "support never uses a larger stock it does not observe, and one that has used it has lost its "
    "support at some earlier step; raising a stock keeps balance and dependence, and at every step "
    "at which a web supports a formation not observing the stock, the raise registers alike; so "
    "for every horizon up to which only that stock may fail, some raise registers alike wherever "
    "the web supports the formation and supports it up to the horizon, while observing the stock "
    "registers every raise. "
    "Response: where every formation outside a part exchanges alike across each step up to which it "
    "has registered alike, a supplied premise of which the rest held fixed is a case, every formation "
    "beyond the part's responsive reach, its closure under affecting what is registered, registers and "
    "exchanges alike, the difference between two flows reaches none of them and the comparison is "
    "decided within the reach; registering support only, with one flow, the responsive reach is the "
    "union of the members' reach closures; in the trophic cascade it is the wolves, the deer and the "
    "forest, and in a two-party loop the difference returns to the part's own support. "
    "Counterfactual: where the rest exchanges by a law reading what has stood, two balanced flows in "
    "which the part acts alike, starting alike, are one flow; the law generates a course, the orbit "
    "of one determined law on the stage and the history so far, which balances exactly where the law "
    "never takes more than stands and is given; the counterfactual of an act is the course it "
    "generates; where the law reads only what each formation registers, the rest responds through its "
    "registration in any two courses, and with finitely many conditions every law of what has stood "
    "reads through what it is sensitive to, the least registration; the comparison is then decided "
    "within the responsive reach with neither the second flow nor the response supplied; the course is "
    "a trajectory of the standard model whose input is the part's move, an act not taken an "
    "intervention; over one kind of relatum the course is a world of the unfolding, running by the "
    "law of exchange exactly where feasible; a determined law steps beyond what a run shows exactly "
    "at the moves the run never takes, so the course's history shows its law and the moves beyond it "
    "are the counterfactuals; with the part's act formed by a law on the configuration, a run of the "
    "closed process is the course. "
    "Propagation: in two balanced flows the difference of a condition's levels changes across a "
    "step by exactly the difference given less the difference taken, so its gap is at most its gap "
    "before with the gaps of every exchange with it; an exchange is coupled to a level with strength "
    "at most k where, under two histories differing in that level only, it differs by at most k "
    "times that level's gap; for a law of what has stood strength zero is insensitivity, strengths "
    "add up over levels changed one at a time and bound a part's share of a move, and a law giving "
    "the square of a level has no finite strength; where the rest follows such a law every gap is "
    "at most the carried amount, the course of the carrying law from the starting gaps and the "
    "part's gaps, which has those strengths and attains it, so the carried amount is the most "
    "difference that can arrive; it is positive exactly along a route in time of positive "
    "strengths, a route of TimedResponse's spread where the strengths are registered, and where no "
    "route reaches the levels agree; carried amounts add and grow with the gaps and strengths; a "
    "unit relayed at twice its level arrives as 2t by step t + 1, and a loop of strength one gives "
    "2^t. "
    "ListingRefutations: the refutation laws of Continuation, Dissipation, Roles, Resolution and "
    "Standpoints hold of every family however listed, with no Distinct and no decided identity, "
    "from not_of_listsOnce and the membership of what they read. "
    "RegimeMargin: under a standing draw H with giving g read off what is left, a level below H + y, where "
    "giving falls short of H below y and nothing gives from nothing, falls at every step while positive and "
    "is nothing after as many steps as it stood; from H + y up to a top the step keeps, with giving meeting "
    "H from y up to it, the level never falls below its start, so the condition ends exactly from below "
    "H + y; with giving stopped below a need m, the least level meeting a positive draw is at least m, "
    "above m exactly where giving at m falls short of the draw, and rises with the draw where giving does "
    "not rise; giving lowered by the regime gives a least level no lower, higher exactly where the lowered "
    "giving falls short at the old one; with joint giving subadditive above m and no greater than either "
    "draw's, the rises of the least levels meeting H1, H2 and H1 + H2 satisfy a + b <= c + 1; "
    "the level stays at or above b while b + H n <= x and, with giving at most Y <= H <= b, falls below b "
    "within any n with x < b + (H - Y) n; witnesses Concave (strictly super-additive) and Peaked (each "
    "draw holds alone, together they end the condition from every level). "
    "Regulation: with balance, the joint exchange is within the gap to m on both sides exactly "
    "where the next level lies between m and the level; within the gap and opposing on both sides "
    "the level settles at m within its gap; beyond it an opposing exchange crosses m, a witness "
    "oscillates without end, and one side alone leaves the level away; a rule reading l steps late "
    "keeps no band narrower than 2 (l + 1) d under a drift of d a step, the late return keeps "
    "exactly that, and the late relay leaves both ends of its band without end exactly past "
    "b + 2 <= a + (l + 1) M, the runs of the relay existing where (l + 1) M <= b + 1. "
    "Loops: the amount carried by routes of at most j responses rises with j to the carried "
    "amount and is exact up to step j; where no chain of j + 1 couplings ends at a condition, "
    "order j is exact there, and with every condition listed a chain as long as the list passes "
    "a loop, so where no loop lies upstream the order one less than the number of conditions is "
    "exact at every step; where the couplings hold at every step a fed loop upstream leaves every "
    "order inexact, so a finite order is exact from every start exactly where no loop lies "
    "upstream; around a loop what has reached it returns multiplied, every time around, by at "
    "least one plus the product of its strengths; with starting gaps at most D and the strengths "
    "into each condition at most M a step, order j carries at most D times the sum over i <= j "
    "of C(t, i) * M^i, the carried amount at most D * (1 + M)^t, and a cut at order j misses at "
    "most their difference, all three attained by a self-loop; a doubling outgrows every "
    "polynomial, so with the same formations and strengths at every step the carried amount, "
    "and the most difference that can arrive for every law with those strengths, is bounded by "
    "a polynomial exactly where no loop lies upstream. "
    "Remainder: for every schedule of couplings, the carried amount is order j plus what j + 1 "
    "responses in turn carry from it; order j misses something at a condition exactly where a gap "
    "is conveyed there through j + 1 responses, each reading a level the one before had reached, "
    "and is exact from every start exactly where no chain of j + 1 couplings in time order ends "
    "there; a finite order is exact from every start exactly where those chains are bounded; a fed "
    "loop of recurring couplings upstream leaves every order inexact, and where no coupling reads a "
    "level from step N on, order N is exact; where every coupling from step N on recurs, the chains "
    "are bounded exactly where no loop of the couplings from step N on lies upstream, with no "
    "listing of every condition, and without such a loop the carried amount is at most a "
    "polynomial; the results of Loops on exactness follow as instances. "
    "Routes: for every weighting with each step split into a ground and a response part, order "
    "j of the sum over histories is exact at every horizon up to j, readings keeping the laws "
    "can be taken order by order, and for counting the orders rise to the sum; with one "
    "configuration, ground one and response M, order j at horizon n is the order sum of Loops "
    "and the sum (1 + M)^n; with counting weights on routes back in time, each step one "
    "response or an end at a source, the transfer of horizon j + 1 is order j of the carried "
    "amount at every condition and step, so each order and the carried amount are sums over "
    "courses, horizons rise to the carried amount and miss at most the bound on a cut, and with "
    "stationary strengths a finite horizon is exact exactly where no loop lies upstream. "
    "Closing: the couplings formed by step T are those acting before T, every chain is formed "
    "by some step, so the loops are those formed by some step; the loops formed by T + 1 are "
    "those formed by T and those through a coupling acting at T that closes a chain, and an "
    "exchange responding to the level it gives to forms a loop of one; the carried amount up to "
    "T reads only the couplings before T, so with no loop formed by T upstream it is at most a "
    "polynomial up to T; a self-loop forming at T and one forming later agree up to T, one "
    "doubling after; strengths read from the levels so far generate a course that is the "
    "carried amount of the strengths it reads, and in the threshold witness the loop forms at "
    "the step the level reaches the threshold and the level plus one doubles from then on. "
    "Thresholds: a law reading a schedule is coupled to every unread level with strength zero, so "
    "the strengths restricted to what is read are strengths of it, every coupling reads its level, "
    "no loop passes through a level nothing reads, and a loop forms at a step only through a "
    "formation reading there a level downstream of where it gives; laws reading through a "
    "registration read every schedule covering it, and their courses are policies through it; for "
    "every law, courses apart only in an unread stock are alike elsewhere, the gap held; a law "
    "reading a stock only below a threshold, every law reading through a registration with the "
    "stock unobserved among them, carries a raise of it nowhere up to the break, and before the "
    "break gives as its standing law, which does not read the stock and has no loop through it; in "
    "the draw witness every strength couples the stock into itself, and a raise shows only after "
    "the break. "
    "Observation: a gap of one stock alone is conveyed only downstream of it, so the carried amount "
    "is zero elsewhere; a law reading a schedule reads it into every condition, a level unread into "
    "a condition is coupled into it with strength zero, and routes of the restricted strengths are "
    "routes of reading; for every law reading into each condition a schedule of listed levels, two "
    "courses apart at the start only in a stock are alike at every condition and step not downstream "
    "of it by the readings formed by then, so a formation exchanges alike where its readings lie off "
    "the downstream; a route forms by closing; in the measurement witness the route and the loop "
    "through the stock form at the step the measurement starts, and the raise registers in the "
    "record after it. "
    "LevelCoupling: strength zero is exactly no response, and a response of an exchange to one "
    "level is a coupling of every strength array of the law; for a law reading through "
    "registration a level neither depended on nor observed is coupled with strength zero, a "
    "response is a route of reading in every schedule covering registration, a condition depended "
    "on and not observed passes only a crossing of its need, changing the formation's admission "
    "only where its other requirements are met, where that admission is decided a crossing passes "
    "exactly where the condition is required with a positive need, and observing is exactly where a level can couple "
    "into a formation within its need; under a law reading through dependence alone, a formation "
    "exchanging across a step only where the levels there admit it takes and gives no less where "
    "the levels at the step stand no lower, the history before alike, so a response carried by "
    "such formations rises with the levels at the step and falls only where some level there falls; "
    "a response to one level at the step, up to a bound, is carried by such a family exactly where "
    "it rises with that level, by units at thresholds; supplying what a level lacks of a positive "
    "amount passes by level and is carried by no such family; where the level and a complement "
    "stand at a fixed total, units depending on both, one for each level up to the total, carry "
    "every response to the level. "
    "MutualDependence: sharing conditions throughout, mutual dependence (every influence closure, "
    "equivalently every reach closure, the whole) and mutual feeding are each strictly stronger "
    "(Clearing, Drawing), and under each, significance bounded by the matching closure is the "
    "continuation condition; around a loop of couplings holding at every step what reached its "
    "condition at least doubles each turn, there and downstream, and the carried amount stays within "
    "D (1 + M)^t; transmission with carriers leaving at least a and others at most b raises the share "
    "ratio at least as (a/b)^n; under balance a draw exceeding all earlier draws leaves more than half "
    "the stock at every step it is met and needs 2^n - 1 for n steps (DoublingDraw attains it). "
    "Frequency: counting the steps at which anything couples, the carried amount is at most D "
    "times (1 + M) to their number, attained by a self-loop coupling at the steps of any "
    "schedule; every return around a loop at least doubles what reached it, so returns with 2^i "
    "outgrowing every polynomial in their steps run away whatever the strengths, and where 2 to "
    "the count is polynomial so is the carried amount; a self-loop is polynomial exactly where 2 "
    "to its count is; the sparse self-loop at 0, 1, 3, 7, ... recurs, leaves every finite order "
    "inexact and stays polynomial; a coupling that stops does not recur, and where each recurs or "
    "stops the schedule settles; every schedule settles exactly where every decided two-place "
    "family has every row true somewhere or some row false throughout, which gives LPO, and the "
    "self-loops coupling once at the first true step of a decided sequence all settle only under "
    "LPO; the loops of Loops and Closing are instances. "
    "Tail: a number read off levels that no single condition changes is one that levels agreeing "
    "from some condition on give alike, and the law exchanging it reads what has stood, is "
    "insensitive to every condition and, where the number differs, does not read through what it "
    "is sensitive to and has no least registration; the tail law of Sensitivity is the instance "
    "of the indicator of vanishing; with the conditions numbered, such a number, a law "
    "insensitive at a step to every condition that still differs there, and a counterexample to "
    "the least registration each exist exactly where a rule decides of every Boolean sequence "
    "whether it is false throughout, the law of levels that never vanish being built from the "
    "rule; the decision of vanishing is exactly a rule deciding whether a sequence has a true, "
    "which gives that rule and LPO. "
    "Onward: within finitely many configurations a run starts at a configuration exactly where a "
    "course as long as the list does, exactly where courses of every length do and exactly where "
    "a course leads to a return, with no decision and no selection, and whether one starts is "
    "decided where the successors are listed; a run starts at each member of a family that keeps "
    "moving and stays in it; merging nothing, a configuration returns exactly where a course as "
    "long as the list starts there, nothing rises within a family that keeps moving, and a "
    "configuration with courses of every length that never returns needs openness; a test "
    "recognizing among enumerated moves a step that stays in the family gives a run by search; "
    "asked of every process, a run from every member of every family that keeps moving is exactly "
    "dependent choice. "
    "Runs: a world is a run by its type and exactly a run of the law its webs and exchanges show, with "
    "its history's configurations and moves, and every run on webs "
    "and exchanges is a world; a world balances exactly where it is a run of the law of exchange on "
    "webs, and with the rest counted every world is such a run; a law of exchange's course is a "
    "world, balanced exactly where the law is feasible, its process is the one run of a "
    "determined law, and the carried amount is the standing of a balanced world. "
    "CourseWorlds: the gap between the worlds of two acts under one law is at most the carried "
    "amount, attained, so the act worlds bound the difference exactly as every two balanced flows "
    "do, and the laws of Loops, Remainder, Routes, Closing, Frequency, Thresholds and Observation "
    "hold of those worlds. "
    "LearnableRuns: a run of a determined law is its orbit, runs beginning alike in the frame of a "
    "registration give every learner the same record, and in a world a list holds a target is "
    "learnable along every run exactly where runs beginning alike have targets that agree from "
    "some step on; learning through a map is tracking in the limit, and where the target is "
    "invariant along the law identification in the limit, which it is not without that premise. "
    "Unrolling: given nothing, a prefix fixes the whole future through the map in every world a list "
    "holds: unrolled on its own proposals, the extrapolation by elimination over the lasso candidates "
    "proposes the value through the map at every step ahead from the identification bound on; a "
    "feature is learnable exactly where it is, from some step on, a reading of that future, and given "
    "nothing no extrapolation learns every learnable feature. "
    "Labels: in a world a list of N holds, a feature is learnable through the map exactly where the "
    "extrapolation given some table of at most N labelled names of N - 1 values learns it, the table "
    "of the world being one; every value the feature takes once that extrapolation rests is a label; "
    "where the map also carries the feature, the extrapolation given nothing learns it and the labels "
    "before the bound fix every later one. "
    "ParityReadings: the registrations glue at a step of a run exactly where the world of readings "
    "is context-free there; for a parity system a respecting world of readings is context-free at "
    "a step, and a frame of context-free claims fits, exactly where no selection of contexts "
    "contradicts; quantum registrations of the square exist, leave the world of readings "
    "context-free at no step and fit no frame of context-free claims. "
    "FinerTraces: the finer courses of n steps are exactly the finer law's traces of n steps taking "
    "listed moves to listed configurations; the law of steps of positive weight is the finer law "
    "with the situation forgotten, and situations exist exactly where it has a course. "
    "HistorySums: where a weighting vanishes off the steps a possibility admits and what is read "
    "vanishes off the possibility's reading, the sum over histories vanishes wherever possibility "
    "does not reach the reading; the transfer over n + m steps is m steps of the transfer over n, "
    "and the weight along a joined course is read at the joint; the exact order i reads order i "
    "through each step's ground part and order i - 1 through its response part, vanishes above "
    "the horizon and is taken order by order by a reading that keeps the laws; where alternatives "
    "commute it is the sum over the courses with exactly i responses, taking each step through "
    "one part loses nothing, the orders of Routes are its partial sums and the whole sum is the "
    "sum of all of them; for one configuration with ground one and response M the exact order i "
    "is binom n i * M^i; with the first possible course in listed order, whose alternatives do "
    "not commute, one step's sum is not the sum of its exact orders; two weightings that vanish "
    "off a possibility's steps and agree on each step between a configuration and the reading "
    "have the same transfer; read on a process whose steps the weights read, these are laws of "
    "its traces: no weight where no trace reaches, traces split at every number of moves, an exact "
    "order not zero has a trace and a course of the parts with exactly that many responses, and "
    "the steps between are those on a trace from the start to the reading. "
    "FormedLoops: up to a step, a world whose strengths are read off its own standing stands as "
    "the balanced world its couplings formed before that step carry; the onset, threshold and "
    "schedule witnesses of Closing and Frequency are balanced worlds, the threshold world's loop "
    "of the couplings it reads off its own standing forming at the threshold and not before. "
    "AttractionRuns: attraction on the process of a determined law: what every run is drawn into. "
    "Boundaries, section BoundaryFlows: the self's boundaries drawn along what a flow relates. "
    "Boundaries, section BoundaryWorlds: the presupposition along what affects what in a world. "
    "Courses, section CandidateRuns: cross-situational resolution step by step along a run. "
    "Capture, section CaptureWorlds: a target's share among descendants. "
    "Listing, section CensusWebs: counts of arising and ceasing where they exist, and listing once. "
    "ContactCourses: revision rules as processes, and encodings along a run of channels. "
    "ContextualRuns: the parity bounds and the parts of no whole along the runs of any process. "
    "ContinuingRuns: the witness of continuing revision at yield nine, read along its run. "
    "CopyCourses: the laws of copying on the courses and runs of its processes. "
    "Countdown, section CountdownCourses: countdown on the courses of a partial law's process. "
    "CounterfactualRuns: the course of an act on runs of the standard model and on the course world. "
    "CouplingTraces: couplings read as the steps of a process. "
    "CourseRoles: one course, one kind or two roles. "
    "Units, section DependenceWebs: support in a fixed unit, and coextinction with no reserve. "
    "Diagonal, section DiagonalRuns: completing a registration within what it registers, as a process. "
    "Sampling, section ExchangeFlows: uniform descent, and what a sampled flow keeps of an absent relatum. "
    "HorizonWebs: the horizon in the support-gated law, on its webs. "
    "IdentificationRuns: the states of a run and what a bounded record fixes. "
    "Composition, section JointPlanFrames: joint plans of joint frames: nested decompositions read through a description. "
    "LastingRuns: lasting and reaching on runs and courses. "
    "LearningRuns: what a run's registered record fixes and what a learner reaching it does. "
    "Entropy, section LevelWebs: laws of a condition's level and a family's configuration on a web. "
    "Likeness, section ListedOutcomeFrames: what fixes likeness where each move has listed outcomes. "
    "ListedWebs: the laws of listing what is active, read of a web's activity. "
    "MoveFormation, section MoveRuns: where the moves of a run are formed. "
    "OrderNormal, section OrderWorlds: the arrangements of a world's exchanges, and its readings in time. "
    "OneStep, section PassageWorlds: what the stated laws of one step and the following of passages give of worlds. "
    "Branching, section RecurrenceRuns: recurrence on the process of a determined law: merging, returning and the kept history. "
    "Courses, section ReducedRuns: what a reduction keeps of the courses and runs of a law. "
    "ReferencePlanTraces: revision of a reference plan as a process of the spine. "
    "Courses, section RetrodictionRuns: reading an earlier configuration of a run from later dated records. "
    "Revision, section RevisionRuns: what the history of a run's registrations selects, and the reconstruction steps. "
    "RouteTraces: the orders of a sum over a process's histories. "
    "SeekingRuns: the boundary of enough on the unfolding. "
    "Enough: under an undetermined law some run comes to rest with its target met exactly where a "
    "reachable configuration stays and meets it, and every run does exactly where every reachable "
    "configuration with a step that stays meets it and every run settles; under a determined law the "
    "two are one. "
    "Settling: in a world a list holds, some run keeps changing exactly where a reachable change can "
    "be undone; not changing for ever is not settling, which is the limited principle of omniscience "
    "already for two configurations. "
    "LastChange: along a run a list of N holds, with no change within a loop, there are fewer than N "
    "changes, and with decidable configurations the run is not not settled; settling every run from a "
    "configuration with no reachable change that can be undone, for every process of decidable "
    "configurations in a world a list holds, is exactly the limited principle of omniscience, and "
    "with it assured enough is every reachable stay meeting the target and no reachable change "
    "undoable. "
    "LimitVerification: a reading verified in the limit by a method fixed by the record is a union of "
    "closed readings, one refuted in the limit a meet of verifiable ones, readings of tests both; with "
    "decidable configurations settling is verified in the limit, and on the free process it is dense "
    "with a dense complement, neither verifiable nor refutable, and under Markov's principle refuted "
    "in the limit by no method; recurrence is refuted in the limit and under Markov's principle "
    "verified in the limit by none; identification in the limit decides each hypothesis in the limit; "
    "saying from not recurring where a run stops, or which of two recurring guesses recurs, is the "
    "limited principle of omniscience. "
    "SelectionRuns: a selection through a run's registered course. "
    "SensitivityWebs: sensitivity on webs and flows: what depends on the whole, read off the courses. "
    "SituationTraces: the counts of situations are counts of the traces of one determined process. "
    "Stock, section StockTraces: when a course is executable on a stock, in closed form. "
    "StrengthFlows: coupling strengths read off the flows a law gives. "
    "Tail, section TailRuns: the omniscience a law of the whole takes, stated of every run. "
    "Counting, section TallyWorlds: the counts a world's census can have. "
    "TypicalRuns: what counting says of the records of runs of free branching. "
    "WeightedTraces: integrating out and memory, on the traces of processes. "
    "Selection: two histories are selected alike by every selection through a selector's registration "
    "exactly when the selector registers them alike, and likewise for pooled registration; with the "
    "rest fixed, selection and scoring are blind beyond the registration closure; the clearer's "
    "selection misses the dweller's ending, which the dweller's and the pooled registration select; a "
    "flow reaching beyond the registration closure to raise a gauged store is selected, alike with "
    "raising it without reaching beyond; selection supplying the carriers, their share rises among "
    "descendants. "
    "SelectionGap: where the rest follows a law of exchange reading through coupling and an act "
    "differs only beyond the actor's coupling closure, every selection through a member of the "
    "closure selects the flows with and without the act alike, the response derived from the law; "
    "with both acts laws, the two generated courses are selected alike. "
    "SelectionReach: in a balanced flow, where a family containing what couples in gains nothing "
    "across a step, a rise of what couples in has a formation giving it more than it takes from it "
    "and taking from beyond it, with equality decided from a condition no member of the group "
    "couples into, the rise paid from beyond in full; so a selection holding only where what "
    "couples in rises holds only on flows "
    "reaching beyond the coupling; Diversion is an instance, and its supplying flow shows the "
    "premise binds. "
    "DrawnBeyond: in a balanced flow, where the family with the conditions beyond it gains nothing "
    "across a step, the family's stock and the beyond's after the step with what the whole loses are "
    "the two before, the beyond falling by at least the rise and under dissipation by one unit more "
    "for each taker; where the rise with the loss exceeds the slack of dependences beyond met at the "
    "step one of them is broken, found by deciding each, conditions on which nothing depends "
    "counting in full beside the slack, and where activity needs support its "
    "formation is not active after the step with that dependence as strong; a selection holding "
    "only where the family rises above that slack holds only where a formation outside the group "
    "loses a dependence on a condition no member couples into; a formation raising the family from "
    "nothing new takes from beyond, so over generations whose more offspring go only to raisers the "
    "share reaching beyond has no discordant pair, does not fall where each offspring of a reaching "
    "member reaches, and with exact transmission moves only upward; over a stretch at every step of "
    "which the whole gains nothing the family rises by at most what the beyond loses, so a rise above "
    "all the whole held needs a step that gains; Diversion breaks the dweller's dependence and ends "
    "it, a slack equal to the rise breaks nothing, the share rises from a half to the whole in "
    "Spreading and falls where reaching is not carried on. "
    "JointDraw: in a balanced flow a dependence met at a step breaks across it exactly where its need "
    "with all that the formations take exceeds the level with all that they give; on one condition the "
    "highest needs break first, whoever takes; where only active formations take what they draw on, "
    "every break lies on a condition an active formation draws, the dependence beyond broken by a rise "
    "above the slack among them; a break where each drawer's own take is within the slack has every "
    "drawer taking strictly less than all that is taken; restraint by the excess, by any drawers, keeps "
    "the need met; over a run, taking no more and giving no less from levels as high holds every "
    "condition as high and eases the course, so under the whole-run reading a restrained course "
    "extends an overdrawing one exactly when it includes an event the other withholds, for any number "
    "of drawers, and every comparison satisfying C ranks it higher; TwoDrawers: each take within the "
    "slack, the joint draw breaks the third formation's dependence and it ends, one drawer restrained "
    "keeps it, and C ranks the restrained course higher. "
    "Optimum: over any set of outcomes every order rising with the levels of a family, ranking above "
    "every outcome that exceeds another on the family whatever either holds beyond, has its optima at "
    "the least level beyond, condition by condition, exactly where every eligible outcome standing "
    "above another at a condition beyond is not unbeaten on the family; with room, or with shared "
    "units moving a unit beyond into the family, every optimum is there, and an order ranking above "
    "wherever a rising order does is rising; where the levels after a step are such an optimum and "
    "each condition beyond is depended on at a need it meets, a dependence beyond is broken exactly "
    "where some eligible outcome leaves its condition below the need, and where activity needs "
    "support with the dependence as it was its formation is not active after the step, no member of "
    "a group coupled only into the family and coupled into by none; of two balanced steps from equal "
    "totals gaining nothing on the whole one leaves the family at most where the other does exactly "
    "where it leaves the beyond with the loss at least where the other does; restricted to outcomes "
    "keeping each dependence beyond, with room among them and each need attained, the optimum breaks "
    "nothing and the family rises with the loss by exactly the slack; Drain: the store's optimum "
    "drains the source and the dweller ends, counting the source after the store drains it, without "
    "room keeping is an optimum, a satisficing order has both the keeping and the draining outcome "
    "among its optima, and the keeping optimum takes the slack. "
    "LawAlongRun: under an equivalence, some process going alike under it admits a run's steps "
    "before a step exactly where two of them alike under it, by the same move, end alike, the record "
    "read under it being the witness and once failed failing from then on; through equal "
    "projections the record is the least candidate and through the identity at every step this is "
    "the history law; with dependences read off the configuration, what a formation couples into at "
    "each occasion is such an equivalence, fixed conditions being the instance that matches "
    "Web.AlikeThrough and unchanged dependences giving one criterion; a run can be consistent where "
    "the process does not go alike; the image is an exact finite-path projection exactly where "
    "configurations alike match each other's steps, which going alike does not give; in Unseen "
    "coupling into an uncoupled level restores the law, and in Changing a dissolving dependence "
    "carries a law a forming one breaks. "
    "SelectionPool: a pool's coupling closure is the union of its members'; with the rest fixed, "
    "every selection through the pooled coupling of a group within it selects a part beyond it "
    "alike (both in Selection, whose single formation's law is their case); some pooled selection separates two histories exactly when the members do not all "
    "couple them alike, and, with the members listed and each member's coupling decided, exactly "
    "when some member couples them apart; where the rest follows a law of exchange reading "
    "through coupling and a pool's act differs only beyond its coupling closure, every selection "
    "through the pooled coupling of a group within the closure selects the flows with and without "
    "the act alike, while a formation whose admission the act changes separates them through every "
    "pool holding it; a formation coupled by level into everything another couples into selects "
    "through at least the pooled coupling of the two, and its coupling closure is the pool's where "
    "the other exchanges with a condition coupled into it, so with the rest fixed, or following a "
    "law reading through its coupling, it selects alike what lies beyond the pool's closure; in "
    "Clearing, pooling with the dweller closes the clearer's gap, reading the clearer's couplings "
    "does not and reading the dweller's does. "
    "PoolResponse: where a law of exchange reads through the coupling of each formation outside "
    "a part, a selection through the acts of a group outside it is a selection through its pooled "
    "coupling, and what the acts separate some member couples apart, the members listed and "
    "decided; with the coupling classes decided the bound is exact, and the law exchanging nothing "
    "shows that coupling does not fix response; under the conditions of the gap for a pool's act, "
    "nothing within the pool's coupling closure outside the acting part responds to the act; a "
    "pool meets a part's responsive reach exactly where the part meets its closure, a pool beyond "
    "the reach does not respond, and no member responds before a difference enters what it "
    "couples into; in Clearing what a pool separates goes unresponded outside the clearer's part, "
    "and in Loop a response returns through the actor's coupling closure. "
    "Rejoining: a difference between the courses with and without an act opens or closes at a "
    "condition only across a step at which the flows exchange with it differently, and where they "
    "rejoin, what they exchanged makes up the gap exactly; where the rest reads through its coupling "
    "and the part acts alike after the act, it changes only through a formation outside the part "
    "that couples the two courses apart; what nothing within the responsive reach exchanges with "
    "stays; in Replenishing a responder reading the level gives back what the act took. "
    "Learning: given two values, two courses share the record before any step and differ at it, also "
    "among worlds held by a list, so a claim from the record is not right on both and, with values "
    "decided, is refuted on one; for every learner and every map moving each value the diagonal "
    "course refutes each of its claims, is the registration of a law keeping its record and has no "
    "list holding that law's configurations; learning by refutation over hypotheses in order never "
    "passes one that holds, is then not refuted at arbitrarily late steps, and passes only refuted "
    "hypotheses; every registration of an orbit held by a list l is a lasso within l.length, on it "
    "the learner over the lassos in diagonal order is refuted fewer than tri l.length times and "
    "claims at every step from step l.length on, its coming to rest unrefuted, and its diagonal "
    "course is no lasso; over classes merged along the pairs the index is bounded where a member "
    "of a class holds, and every merging is unrested on its diagonal course; the class of functions "
    "going alike across a lumping is determined at an input lumped with an observed one, and with "
    "two values, listed data and decided equality exactly there; a member fitting the world on the "
    "data is right at an input lumped with an observed one exactly where the world takes one value "
    "at the two; the class of every function fixes no unobserved value; a determined law goes alike "
    "under a projection exactly when the projection of its step goes alike across it, and an "
    "observed outcome transfers exactly where the configurations go alike; a loss computed on the "
    "data selects through agreement on the data, within a class free at an input every selection "
    "through the data leaves every value there selected, and every member fitting a world of the "
    "class is right at an input exactly where the data determine it. "
    "PropositionIdentity: propext, as a proposition, holds exactly where every reading of propositions "
    "is lumped by interderivability, and exactly where the reading by name is; every reading built from "
    "relations respects interderivability with iff; any two witnesses of an interderivation are equal, "
    "while Bool has two different self-inverse maps; transport along any equation of propositions with "
    "a constant motive keeps the value. "
    "FrontierFrames: J1/J2 as a condition on the configurations of a frame compared by what they "
    "realize, irreflexive and transitive, anchored by a kept basic claim, no trade for living "
    "claims, C where decided, every two-tier condition that of its tier frame; the options of a "
    "step are what one move reaches; a bettered option is not chosen, J1/J2 leave one chosen "
    "where listed and weakly decided, a required task is performed by any chosen option, "
    "nothing is required where no move is possible, a basic claim kept by an option keeping "
    "every basic claim of the options is never refuted at a chosen option and required where "
    "decided; fresh contents under every classification on a frame of two kinds. "
    "FrontierWorlds: what a formation requires of a condition, served across a handover between "
    "givers to it: withdrawn giving needs the successor, no gap serves, a gap refutes service. "
    "FrontierFrames, section AcceptanceFrames: on the options of a step, every option best with acceptance keeps access "
    "exactly where every best base option does, restricting to the options loses score least "
    "among them, and an option best by an estimate within err is within 2 err of every option. "
    "Presentations, section PresentationFrames: exact reduced presentations of a frame's branching tests correspond one "
    "to one, the canonical presentation reads every test and every exact one factors through "
    "it, the joint relation of a joint frame descends exactly where saturated, and the frame "
    "realizing every predicate tells every two configurations apart. "
    "FrontierWorlds (U5): on the world's moves, a sole giver to what a formation requires is "
    "required and, where only active formations give, active; a discharged undertaking leaves no "
    "residual step and an unmet one is residual. "
    "Retaining (R34): where only active formations take, and only from what they draw on, a part "
    "whose draws fall on conditions renewed over the run keeps what can form and does not narrow, a "
    "part of formations renewing over the run being a case; a consuming part narrows where it gives "
    "no more than it takes and the levels without it meet the consumed dependence after the loss; "
    "the preempting drawer is within renewal at its step, consuming over the run, not renewing, and "
    "its part narrows; a part drawing on a consumed condition it never takes from keeps what can "
    "form the same. "
    "OwnWidening: within a decided region, one level path widens another where it admits every member the "
    "other admits there and one more; in a balanced flow, where a part's activity admits within a region "
    "what the levels without it admit there, the levels with it include those without it exactly when its "
    "net draw stays within the margin for every formation outside the region that the levels without it "
    "admit; where the part widens within its own region, the whole widens exactly then and is mixed exactly "
    "when the draw goes beyond for one such formation; with that formation's need equal to the level without "
    "the part, any net draw on the condition makes it mixed; with no net draw on what such formations "
    "require, own widening widens the whole, and a comparison over the own region alone still changes; "
    "a decided set at each step is what the web reading each formation as its own condition at need one "
    "admits; in OwnDrawing one draw widens at one unit of slack and is mixed at none. "
    "Growth: one web's levels widen another's along a reading of its formations where every formation "
    "the other admits is, read, admitted and one admitted is the reading of none the other admits; along "
    "the identity this is widening; inclusion composes along readings and widening composes where the "
    "later step widens or the later reading is one to one; an old formation is admitted in a grown web "
    "exactly as by the old levels; the grown web widens the old along the inclusion exactly where the "
    "old levels include and either exceed or a new formation is admitted at some step, so with the old "
    "levels kept a growth widens exactly where a new formation is admitted while on the old formations "
    "nothing widens; attaching one formation by one new condition widens exactly where that condition "
    "meets its need at some step. "
    "Direction: on a web's moves, a move read by the levels it leads to, an extension with every "
    "admission counted is a widening; under J1/J2 a chosen move keeps every basic admission a move "
    "keeping all of them makes, unrefuted and, where listed and decided, required; a move whose "
    "outcome another's widens is not chosen where it is decided whether the widening adds a basic "
    "admission, and the widening move is never refuted to be better; under a law of exchange "
    "reading through coupling, the admission telling a widening outcome from the other lies beyond "
    "the acting group's coupling closure and is selected through every pool holding its formation "
    "and through no pool within the closure; in Clearing, sparing widens clearing, clearing is not "
    "chosen, and the dweller's admission is selected only through a pool holding the dweller. "
    "WitnessRefinementRuns: inspection by fallible witnesses and testing as processes for every "
    "roster, fault sets and answers, the audit and the inquiry their instances: silence keeps the "
    "candidates admitting a fault set; after a complete transcript cross-separated candidates "
    "agree at every later state; complete steps tell two candidates apart exactly where their "
    "envelopes are cross-separated; covering fault sets keep both and certify nothing; a doubled "
    "roster changes nothing; a candidate admitting every failure blocks every later certificate; "
    "a test leaving no candidate certifies nothing, a separated pool after a faithful test completes. "
    "NarrowingRuns: the answer is the greatest safe answer of the belief narrowed by After on the "
    "pure observation, the only one; along every run observing a candidate rule it asserts the "
    "observed rule's values; re-encoding transports what the belief settles. "
    "HistoryIdealsTraces: an ideal of the courses a process can take that settles, or goes on with "
    "its courses picked, is a history of the process; a run's moves go on; a history of feasible "
    "courses need not be a run's moves. "
    "Hexagrams: six two-valued lines give sixty-four configurations, equality and membership told "
    "line by line, and the received order holds every one, each of its pairs turned over or, "
    "where turning over gives the same hexagram, changed in every line, which is six steps of the "
    "law of waxing and waning; the change of one line "
    "returns every configuration, reaches every configuration from every other, keeps every "
    "possibility and merges; the law of waxing and waning merges nothing, so by "
    "lossless_iff_returns every configuration returns, six steps on every line is changed, twelve "
    "steps on the configuration is had again, all broken first returns at the twelfth step and "
    "the first unbroken line at the seventh step from all unbroken; where only a broken line "
    "enters the law merges, all broken is absorbing, every other configuration is drawn in, never "
    "comes back, never returns and a possibility is lost; for every law of hexagrams every "
    "configuration returns exactly where the law merges nothing; the law commutes with the "
    "complement, turning over runs it backward, it goes alike across the pairs of complements "
    "and not across the count of unbroken lines; read along the law as a frame and a world the "
    "lines arise and cease at arbitrarily late steps; every run of hexagrams under every process "
    "revisits within sixty-five steps, and the law with its history kept is held by no list. No "
    "ethical premise is used. "
    "HexagramPlaces: a line is in phase where its value is its place's parity, the lines at one "
    "height of the two trigrams are opposed where they differ, adjacent lines alternate, rise or "
    "fall across their seam, and the middle places are lines 2 and 5; a relation read at its "
    "sites glues to a reading of the whole configuration exactly where every site shows the same, "
    "the phases exactly at the two configurations with every line in phase or none, the seams at "
    "four, the oppositions where every height or none is opposed; the two trigrams read as "
    "contexts glue exactly where no height is opposed, so no frame of context-free claims fits "
    "the heights while the indexed frame does; the lines at a height are opposed exactly where "
    "both or neither are in phase; the complement turns every phase, keeps every opposition and "
    "alternation and exchanges rises and falls, and turning over does the same at the mirrored "
    "site; changing a line turns its phase and its height's opposition and nothing else, moving "
    "the count in phase by one; under the law of waxing and waning each line rises with its value "
    "and its phase turns, so the counts in phase before and after a step add to five or seven and "
    "the count changes parity at every step, 3, 2, 3, 2, 3, 2, 3, 4, 3, 4, 3, 4 along the twelve "
    "steps from all unbroken, and is not a lumping the law goes alike across; alternations travel "
    "with their lines; the oppositions run under the law of waxing and waning on three cells, a "
    "lumping the law goes alike across, three steps turning every one, six keeping it, two "
    "keeping it exactly for two patterns; rises and the bottom line count as many as falls and "
    "the top line; each of these laws holds along every run of waxing and waning, of the change "
    "of one line, of the law backward from the turned-over configuration, or of any process; the "
    "listed statements of four censuses of the text hold of their configurations. No ethical "
    "premise is used. "
    "HexagramLaws: the nuclear law, lines 2 to 4 below and 3 to 5 above, is fixed by the four "
    "inner lines, merges and loses a possibility, leaves only lines 3 and 4 three times over after "
    "two steps, rests exactly at all unbroken and all broken, takes the two alternating "
    "configurations each to the other, draws every run into these four within two steps, so that "
    "exactly these four return, the first two and the last two of the received order, four at "
    "once, twelve at the first step and forty-eight at the second, sixteen to each fixed one and "
    "thirty-two to the turns as lines 3 and 4 tell; lines 3 and 4 are a lumping it goes alike "
    "across and the count of unbroken lines is not; it commutes with the complement and with "
    "turning over, so the runs from a configuration and its complement never meet; the four "
    "symmetries form a group of four, each its own inverse, any two commuting, with twenty "
    "classes, eight of two and twelve of four, a lumping the nuclear law goes alike across and "
    "the law of waxing and waning does not; the configurations turning over keeps are exactly "
    "those the received order pairs by the complement, and those turning over and the complement "
    "take alike are the pairs in which the two agree; turning lines change into their opposites "
    "and stay, a merging law settled in one step, returning exactly where no line turns, the "
    "hexagram shown not a lumping it goes alike across and the hexagram the lines go to one; "
    "adding one, line 1 lowest, merges nothing and has one orbit of sixty-four, line k turning "
    "every 2 ^ (k - 1) steps with the lines below as they were; the law of waxing and waning keeps "
    "the rises and falls with one more where the bottom and top lines agree, one, three or five "
    "on twelve, forty and twelve configurations, so it does not reach every configuration from "
    "every other, and has six orbits, of twelve, twelve, twelve, twelve, four and twelve "
    "configurations, the orbit a lumping it goes alike across. No ethical premise is used. "
    "HexagramSites: in the second relation of phase a line between the bottom and top places has "
    "the phase of its place's parity and a line at either end has none, a line holding its place "
    "where it is in phase between the ends; of two lines differing at a place every parity of the "
    "place puts one in phase, so no parity of the top place leaves both listed top lines out of "
    "phase; the listed statements of place hold under the second relation, and those of the whole "
    "configuration hold between the ends while two of five hold at six places; the phases "
    "between the ends glue exactly where all four or none are in phase; configurations alike "
    "between the ends have the same inner seams and middle opposition, and changing an end line "
    "keeps every phase between them and turns the opposition and alternation beside it; the "
    "complement turns every phase between the ends and turning over mirrors them; under the law of "
    "waxing and waning the line entering the second place takes the phase opposite its phase at "
    "the bottom, so the phases between the ends are not a lumping the law goes alike across; two "
    "lines answer where their values differ, at any two places; a line answering every other is "
    "alone of its value, unique, in the twelve configurations one change from uniform, four "
    "holding their place, four out of phase between the ends and four at the ends; no "
    "configuration with such a line has one a step of waxing and waning later, it is back six "
    "steps on, and at the top it passes out and stands at the bottom two steps on; every law is "
    "read along the runs of the named process or of any process. No ethical premise is used. "
    "HexagramSequences: a law runs a list where its run from the first member holds the list; the "
    "laws running the received order agree everywhere but at its last member, the one taking the "
    "last to the first is the only one merging nothing and has one orbit of all sixty-four; each "
    "reads every line for every line, so no three-cell rule on a ring of six, with the wrap read "
    "straight or turned, runs the order, the law of waxing and waning among them, while one step "
    "of the order is a step of the straight shift; none commutes with the complement, the turning "
    "over or both, so no rearrangement of places with a mask runs it, and none goes alike across "
    "the pairs or the parity of the count; exchanging two lines keeps the count, an exchange of a "
    "lower with an upper line is a step of the law of exchange between the two halves, every "
    "course of exchanges read as a world balances, and the twenty configurations with three "
    "unbroken lines are two and those one exchange across from them, among which every course of "
    "exchanges from the two stays; the parity of the count turns at every step of waxing and "
    "waning and every change of a line and is a lumping both go alike across, the nuclear law "
    "not; for three lines an odd count is the uniform unbroken or the uniform broken with one "
    "line changed, the strokes having the same parity, and along every course of changes a change "
    "turns the parity of its half and keeps the other's; the 雜卦 lists each configuration once, "
    "sets each beside its partner in its first fifty-six and interleaves the last four pairs, and "
    "is the run of no law commuting with the symmetries; no run of waxing and waning or course of "
    "changes rests at any step; the eight stations are the run of no law commuting with the "
    "complement, the turning over, both or the rotation of three lines; every reading the "
    "complement keeps reads a configuration and its complement alike along their runs, and the "
    "lower line unbroken under a broken upper one at a height does not. No ethical premise is "
    "used. "
    "Withholding: with memory a formation gives at a step exactly where every formation within "
    "that many waits of it gave at the start, withholding stays, spreads downstream and, from one "
    "formation reaching a family, ends all giving in it; without memory withholding passes out "
    "where no chain of waits is long enough and returns around every loop; more waiting is less "
    "giving; in Ring a formation giving whatever it waits on restores every formation from step "
    "three on. "
    "LoopReturn: on runs of a return map, a loop closes a difference only through a link giving back "
    "less than it received; a return map below what it receives closes within d turns, exactly, "
    "and merges; taking a constant off closes at the least turn covering the difference; a cut "
    "closes at once where what follows gives nothing for nothing; monotone return maps settle "
    "within d turns or never fall; doubling links run away; with whole-number factors a loop "
    "closes at the first turn, keeps the difference or runs away, nothing between; on a condition "
    "coupled to itself with strength M the return map multiplying by 1 + M is the carried amount of "
    "Loops and its gap, and around a cycle the return map by one plus the product of the strengths "
    "stays at or below the carried amount; where each link gives exactly its strength one turn is "
    "that course with what the loop gained and what the intermediate conditions held, carried on, "
    "equal to it exactly where both are nothing and strictly above it on a ring of two or more "
    "conditions from an even start; Rejoining's gap at one condition follows a return map where "
    "the two courses' exchanges respond to the gap by it, and across an act need not. "
    "Pace: a two-level course whose rule changes only at reading steps is a run of one law; a rule "
    "that never reads is kept, nothing the fast level meets reaches it, and what it loses stays "
    "lost; a fast difference reaches the rule only at a reading step; regaining needs a change of "
    "rule; given two values a stretch of L steps fixes every pair of courses with at most N states "
    "that held rules generate exactly when L is at least 2N - 1; a course read whole is fixed by "
    "its first N + 1 steps, exactly. "
    "RuleCapture: a two-level course whose fast step is a selection and whose rule reads the share "
    "monotonically locks where no rule turns against the reading: the share falls at no step and the "
    "course is locked from the step after its first reading step, under margins the margin falling at "
    "no step from then on; locked, neither share nor rule falls, a perturbation of the rule keeping its "
    "direction is absorbed at the next reading step, a reading favouring at every share locks every "
    "course from the step after its second reading step, exactly, and monotone laws keep the order of "
    "courses; a rule against the reading read late alternates without end, and a reversing perturbation "
    "across a threshold locks the course the other way. "
    "ClosedCapture: where neither the next share nor the rule read reads what lies beyond the share, "
    "courses alike in share and rule stay alike in both whatever lies beyond, the share's law joined "
    "with a step beyond runs exactly as the share's law alone, a locked loop stays locked while a loss "
    "rising by at least one a step passes every bound, and a reading favouring at no loss above a bound turns "
    "at the step after the first reading step past it; where how the rule is read is formed from the "
    "share, rule and reading are one rule read from the share, a change of the reading alone is "
    "absorbed at the next reading step, and a rule read favouring at every reading locks every course "
    "from its second reading step. "
    "PatternPassing: on a web whose activity is carrying, a pattern present from T on with carriers brief "
    "for d has a carrier beginning within every d steps; under the supplied passing premise it is "
    "passed across one of every d steps, a step with no carrier is followed by none with one, and "
    "where passing stops it ends within d steps; PatternRelay attains each bound. "
    "JointKeeping: no course leaves guards together exactly where no course leaves any; along some "
    "course each of two guards can be keepable and the two together not, and no rule on the "
    "separate keepabilities decides the joint one; in Renewable no course leaves the focal "
    "formation's activity while one run renews and another consumes: keeping a part decides "
    "neither renewal nor what the run does to others. "
    "Tolerance: under the tolerating law a formation gives where all but its tolerance of what it "
    "waits on gave, tolerance zero being waiting on all; for every law keeping inclusion, giving at "
    "a step from every start is giving there from total withholding, giving from it only grows, and "
    "restoring needs a formation giving after it, under the tolerating law one sparing all it waits "
    "on; a set each of whose formations waits on at most its tolerance outside it keeps giving and "
    "a thin withholding passes out in one step; where a formation gives first, restoring by step n "
    "is exactly no chain of n waits clear of sources; the certificate law keeps a covered set giving "
    "under separated envelopes and is available exactly where they are separated; on a web whose "
    "conditions each need k units and are given one by each upstream formation supported, support "
    "is the tolerating law's run with tolerance the number upstream less k, and with k all of them "
    "Withholding's law without memory. "
    "ExchangePremises: read off the exchange with the rest counted, the relata that exchange are "
    "listed with no decision where a named family closes each step, every finite world has a "
    "census, no census fails at any step, and a census of every flow over Nat at every step is LPO; "
    "read off the spreading law no step is enclosed and a census exists; "
    "dissipation, embodiment and bounded transmission are each met and failed by worlds read off "
    "laws with the rest idle and the four tying premises holding; embodiment with the rest counted "
    "is balance and each relatum exchanging exactly while it stands; over a relation of exchange, "
    "requirement read as necessary response gives activity needing support on every run, as "
    "possible response it does not, and for a law the two are the law's response. "
    "Undecided: with values t, u and f, u below in information, constant-free terms are undecided "
    "where every sentence is and a constant-free system stays undecided; evaluation is monotone; "
    "revision of N closed sentences run from all undecided settles within N steps, a bound the "
    "chain shows exact, at the least fixed point; a run of the liar rests exactly where it is "
    "undecided; where two-valued revision has no fixed point every fixed point and every resting "
    "run leave a sentence undecided; a monotone map's run from u rests, so no monotone map moves "
    "every value. "
    "Junctures: every loss of a returning configuration passes a juncture on its course, up to "
    "double negation, found where reach is decided and for listed configurations with decided "
    "steps; finding it for every process is LPO; keeping the steps that can still return keeps "
    "the configuration, is the greatest such sub-process and removes the losing steps at "
    "junctures; many options make no juncture. "
    "Commuting: the runs of a law commuting with a map that moves every configuration, from a "
    "configuration and from its image, are never at one configuration at the same step; what the "
    "map fixes stays fixed; rests, returns and junctures come in pairs; under an exchange a "
    "pair is held halfway round a return; Diagonal.revision_never_rests is the case of a map "
    "commuting with itself; waxWane never merges complements and wane breaks the symmetry. "
    "SharedCodes: codes from senses to forms held by formations change only by hearing; "
    "hearing makes no form and keeps a group's agreement exactly through closed hearings; "
    "after an order each formation holds its origin's start form, so an order forms "
    "agreement from every start exactly with one origin and can share exactly the forms in "
    "use; following a pointer, every start agrees exactly where its paths have met, and "
    "being joined through couplings is not enough; reading across holds exactly where codes "
    "agree; hearing keeps every renaming of "
    "forms, and a law keeping an exchange of formations with a renaming moving every form "
    "never resolves a symmetric disagreement; an imposed code stays and its merges return "
    "only from forms kept outside; a resolution written back into the records rests, merges "
    "the histories before it and is barred only by records kept from before; where records "
    "are only added a resolution is lost but never replaced. "
    "PlaceTransitionNets: a place/transition net, defined by its own rules (pre and post "
    "multiplicities, enabling, firing, firing sequences), is a law of exchange reading nothing "
    "whose course is its flow and whose levels along a firing sequence are its markings; the flow "
    "balances the markings exactly on firing sequences, enabling gives feasibility, and "
    "feasibility is enabling exactly for pure sequential nets; with finitely many places the flow "
    "is dissipative exactly where every fired transition loses weighted tokens, and every step is "
    "enclosed; rising with falling, the bound of consuming firings by the initial weighted "
    "tokens, rest unrefuted in the flow and world forms, and the siphon law as joint excess "
    "hold of such nets; the conservative cycle and the fed place keep dissipation and gating "
    "needed. "
    "Description: describing the parts separately gives back a whole of two parts exactly where it "
    "is rectangular, and two parts that always go alike can go apart; three parts can be related "
    "while every two are free, and on Specker's pairs every reading is allowed by every pair while "
    "the pairs do not give the whole back; a law moving each part by itself keeps a whole "
    "rectangular, copying relates, a relation lasts under laws merging nothing that occurs and ends "
    "by forgetting or by a coupling acting again; under a determined law read through a "
    "registration, a split keeping what is registered and going alike relates configurations by a "
    "bisimulation and the coarsest one makes sense, what is registered now makes sense exactly where "
    "it goes alike with the law, a registered part alone exactly where the rest makes no difference "
    "to its next value, and for a rule changing with it exactly where the rule makes none; "
    "registering position under motion the pair makes sense and neither alone; moments of a "
    "registered sequence are one state where all registered after them is alike, which is likeness "
    "under the law of moments, and there are finitely many states exactly where two moments are one "
    "state, by a pigeonhole up to a relation with no decision; a returning configuration has finitely "
    "many states under every registration, and the two-valued negation has exactly two"
    "; going alike under a determined law is Learning's lumping, and a lasso is two moments being "
    "one state, so finitely many states is a lasso"
    ". "
    "Identification: a course with period p + 1 coming back after Q steps at its first p steps comes "
    "back after Q steps at every step, and two lassos agreeing before (i + q + 1) + (i' + q') agree "
    "everywhere; a history has at most N states exactly where it is a lasso within N, histories with "
    "at most N and N' states agreeing before N + N' - 1 agree everywhere, records are equal exactly "
    "where courses agree before their length, and for every N and N' two such histories share "
    "their record before N + N' - 2 and differ there; on a history with at most N states a lasso "
    "within N holding before 2N - 1 holds everywhere, the learner given N is refuted nowhere and "
    "right from 2N - 1 on, no learner refuted nowhere claims at 2N - 2 on every such history, the "
    "learner given two states is right about the negation from step 3, and the course answering "
    "the learner given N has more than N states; on a history with at most N states a lasso "
    "hypothesis (a, b) within N unrefuted for N + N - 1 steps from s >= a is unrefuted from s on, and the "
    "learner by "
    "refutation over the lasso hypotheses claims and is right at every step from N + (N + N - 1) * tri N "
    "on, in a world a list of length N holds too; on the two-valued negation along a cycle of "
    "N = 2m + 3 places that learner is refuted at step (N^3 - N) / 4, so a step from which it is "
    "right on every two-valued history with at most N states comes after (N^3 - N) / 4; the "
    "learner by the least bound within which the "
    "record bears out a lasso hypothesis, given no bound, is right at every step from 2N - 1 on of "
    "every history with at most N states for every N, no learner is right at step 2N - 2 on every "
    "such history for N >= 2, and no learner right at step 1 on every one-state history is refuted "
    "at no step of every two-state history; under a determined law on a list closed under "
    "it, the same registered future is agreement for 2N - 1 steps, and naming by that finite future "
    "makes sense, carries the law and decides likeness; with the values of the members decided, the "
    "same registered future is agreement for N - 1 steps, refuted by nothing with no decision and "
    "exact for every N >= 2 on a path to a last position that stays, and two moments of a history "
    "with at most N states and decided values are one state exactly where they agree for N - 1 "
    "steps; with no premise, read on the positions of the list, joining pair by pair the positions "
    "the agreements join gives a labelling whose labels have one value each, so the same registered "
    "future is agreement for N - 1 steps and two moments of a history with at most N states are "
    "one state exactly where they agree for N - 1 steps. "
    "Distinguishing: under a determined law read through a registration, in a world a list of N "
    "configurations holds, two configurations pass the same tests exactly where their registered "
    "futures agree for N - 1 steps, exact for every N >= 2 in a world N configurations hold "
    "wholly, and across two such worlds of N and N' configurations for "
    "N + N' - 1 steps; two laws read through registrations are alike exactly where their registered "
    "futures agree at every step; where the single move at each configuration is named by what is "
    "registered there, likeness to depth k is agreement for k steps, every history with at most N "
    "states is the course of a law on N configurations, and for every N and N' there are such "
    "frames, finite and decided, with configurations alike to depth N + N' - 2 and not alike, and "
    "laws read through registrations with configurations agreeing for N + N' - 2 steps that do not "
    "pass the same tests. "
    "Learnable: two configurations with the same registered future give every learner the same "
    "record at every step, so where their targets differ a claim is right on at most one and, the "
    "targets decided, refuted on one with the records equal; a learner predicting both has targets "
    "agreeing from some step on, so none predicts both where they differ at arbitrarily late steps, "
    "already for two still configurations; where the target is read off the registration, the "
    "learner by refutation over the lasso hypotheses on registered values predicts it in a world a "
    "list holds within the identification bound; in a world a list holds some learner predicts the "
    "target at every configuration exactly where configurations with the same registered future "
    "have targets agreeing from some step on, targets going alike across the registration are "
    "learnable, and under a law leaving every configuration unchanged exactly those are. "
    "Parting: two runs of a process part at a step where they register the same before it and "
    "differ at it, and at a parting no learner is right on both; with the registered values "
    "decided, no two runs from a configuration part exactly where all of them register one "
    "course; not parting is kept along runs, so on a run from an unparted configuration held by a "
    "list of N configurations the registered course has at most N states and the learner by the "
    "least bound is right from N + N - 1 on, a determined process with one move parting nowhere, "
    "and no learner is right at step N + N - 2 on every such run for N >= 2; under free branching "
    "every course is a run's course, after every record two runs part, every learner has a run on "
    "which it is never right, and a run on two configurations has a course with no bound on its "
    "states; where no two runs from a configuration part at any step from T on, the course of a "
    "run from it held by a list of N configurations has at most T + N states and the learner by "
    "the least bound is right from 2(T + N) - 1 on; for a process with listed moves and "
    "configurations, decided steps and decided registered values, the learner given the world "
    "is right at step t on every run from a configuration exactly where no two of them part at t; "
    "where a list of N holds every configuration, a course of N steps from a configuration gives "
    "courses of every length, with no decidability. "
    "Typicality: with natural weights p and q on two values, the courses of n steps are the lists "
    "of n values, 2^n of them, weighing (p + q)^n together; the weighted squared deviations "
    "x*x + y*y with x = q*ones and y = p*zeros add up to the weighted 2*x*y plus n*p*q*(p + q)^n, "
    "so the courses with x*x + y*y >= 2*x*y + d weigh, times d, at most n*p*q*(p + q)^n; the "
    "weights are the counting weights composed along the histories of free branching, and the "
    "sum over them is that total weight; for every u >= v, the courses with at least k ones weigh, "
    "times u^k * v^n, at most (p*u + q*v)^n * v^k, and with p = q = 1 they number, times 3^k, at "
    "most 4^n. "
    "Situations: with each step of a law taken in as many situations as its natural weight, the "
    "law whose moves are the situations is determined and takes exactly the steps of positive "
    "weight; summing any reading of the courses over the finer courses of n steps is summing it "
    "over the courses, each times its weight composed along it, so the finer courses number the "
    "sum over histories; on two values with p and q situations a step, there are (p + q)^n finer "
    "courses, a course is taken by its weight of them, and those whose course deviates by at "
    "least d number, times d, at most n*p*q*(p + q)^n; for any listed values with natural weights "
    "read through any event, the sum over the courses equals Typicality's with the event's weight "
    "and the rest's, so the deviation and exponential bounds count situations for every event; "
    "the finer courses taking a course number its weight times how often it is listed, its weight "
    "where every move and configuration is listed once; in any weights, steps weighing the sum over "
    "their situations are counted by them, and a signed transfer is the pair of the numbers of "
    "finer courses composing to adding and to subtracting. "
    "Weightings: over a finite listing, a course widens another exactly when every weighting positive on "
    "every item weighs it higher; inclusion never lowers a weighted count; a course admitting an item the "
    "other does not is weighed higher by some positive weighting, so a mixed comparison is decided both "
    "ways; a weight of zero on what a course adds ties it with what it includes; one weight for every item "
    "ranks by number; for any class of orders from the positive weightings up to every order increasing in "
    "admission (priority to the worse off among them), what every order of the class ranks higher is exactly "
    "widening, and a mixed comparison is decided both ways within it; on a web, where admission is decided and what either level path admits is listed, "
    "widening is what every positive weighting ranks higher, and a path not admitting what another admits "
    "neither widens nor keeps it; from each standpoint's presupposition about its own continuation and "
    "standpoint-invariance, what is forced is exactly the centers' continuation, unrestricted exactly "
    "where every formation is a center; a standpoint's own presupposition forces exactly its closure; the "
    "presupposition along every relation of a family is significance over the union of closures, implied "
    "by it along being related at all, which in Chain says more; in Clearing, with the clearer the only "
    "center, the clearer's part retains at the centers and loses the dweller under the condition. "
    "Held de se, as a property each standpoint ascribes to itself, the presupposition gives each center "
    "its own closure, standpoint-invariant exactly where the closures agree and the condition exactly where "
    "each is the whole; standpoint-invariance is holding one shared content, and held de dicto the step "
    "forces the union of the closures, which a web admits exactly by admitting it; invariant grades give "
    "invariant standing and rank alike, invariant standing does not give invariant grades; a strictly "
    "increasing transform of the steps of continuation admitted ranks every widening higher, one strictly "
    "concave up to a bound ranks higher a one-step transfer to a lower level, and a transform rising no "
    "further from a threshold ties levels at or above it. "
    "Boundaries: with the formations as standpoints and each one's own region its closure under a "
    "relation of the unfolding, sig is the only evaluative parameter supplied, the own region is the "
    "least boundary, every event is held by its formation, living significance is self-significance "
    "with standpoint neutrality along any relation, the own events along the empty relation, the "
    "feeding closure along feeding, and every premise holds under the continuation condition; "
    "along a relation a boundary of a formation is a region holding it that is closed "
    "under the relation, the closure the least and the whole the greatest, and the only one where "
    "everything lies within the closure; a claim about a drawn region is super-true when it holds "
    "of every admissible boundary, sub-true when of some, and boundary-invariant when, holding of "
    "one, it holds of every other, super-truth being invariant sub-truth and invariance "
    "determinacy; what lies within every boundary is the closure, and everything lies within "
    "some; that the continuation of everything within the region has significance from a "
    "standpoint is, super-true, significance over the union of the admissible boundaries and so "
    "the continuation condition wherever the whole is admissible, along any relation alike, and, sub-true along a "
    "relation, significance over the closure, the center's own along the empty relation and the "
    "axiom at that standpoint along the total one; significance bounded by each center's closure "
    "is the significance of what lies within the self however drawn and the least making every "
    "presupposition sub-true, so route (b) and the continuation condition are one presupposition at narrow and at "
    "wide scope; with every formation within some admissible boundary of every center, the "
    "presupposition sub-true and invariant at every standpoint gives the continuation condition, and where the whole "
    "is admissible the continuation condition is exactly that; there invariance is the conditional from the "
    "presupposition to the continuation condition at that standpoint and, given the presupposition, the continuation condition "
    "there, and where some continuation lacks significance an invariant presupposition is nowhere "
    "sub-true; with the presupposition at every standpoint and every formation within some "
    "center's closure, invariance across boundaries is equivalent to significance agreeing across "
    "standpoints, the two coming apart without it; standpoints then retain alike and living significance holds at "
    "the level of claims; sub-truth along the total relation gives it along sharing a condition, "
    "which gives it along affecting and being affected, being affected giving it along feeding; "
    "sub-true along a relation holding affecting, the presupposition gives the continuation condition's "
    "comparisons on every part whose members lie within the center's closure, with no invariance; "
    "where each center's system is the whole the continuation condition is exactly the presupposition sub-true "
    "along sharing at every standpoint, one common condition sufficing; in the clearer's web, with "
    "nothing significant the presupposition is invariant and the continuation condition fails, with significance "
    "bounded by feeding closures it is sub-true but neither invariant nor standpoint-invariant, "
    "and with only the feeding closure admissible it is sub-true and invariant while the dweller "
    "lies within no admissible boundary of the clearer; the clearer's own presupposition drawn "
    "along sharing a condition, or super-true, gives that its part loses the dweller, while drawn "
    "at its feeding closure it is met by a significance under which the part retains. Covering, "
    "sub-truth and invariance are hypotheses; no ethical premise is used. "
    "Relevance: on the level paths of a web the continuation condition is living significance over "
    "admission, an extension over admission is a widening, and under the condition widening is "
    "retaining and adding, so the three read one predicate; the stepwise reading is the living of "
    "the stepwise valuation; read from significance, positive relevance is realized living content whose "
    "continuation has significance from every standpoint; under the continuation condition living significance holds on every frame "
    "for every reading of living, and this relevance is the least satisfying living significance, exactly the "
    "realized living content; on a frame whose claims are formations at steps, each realized "
    "somewhere, as on the level paths of every web, the continuation condition holds exactly when living significance holds with "
    "every claim living and positive relevance read as significance; where everything has "
    "significance, securing ground with bare significance is securing any new content, so A read "
    "with bare significance supplies a reason for every response with access yielding new "
    "content, living or not, and read on living content one for every response securing new "
    "living content, a witness separating the two; with A read on living content the universal "
    "reason follows from living significance at the level of claims, and so from the continuation condition, with no seed, "
    "neutrality or connection premise; a level path nowhere lower includes the other and is "
    "never ranked below by retaining and adding; the possibility reading of courses includes a "
    "formation where the course's levels admit it, every active formation of a dependent course "
    "included, and under the continuation condition extension under it is retaining and adding what has "
    "significance on the law's web; under it the course without a formation drawing beyond "
    "renewal extends the course with it in every law of the family, restraint extends overdraw "
    "in the two-part family and with a third formation, and sharing extends winning by "
    "consumption, while the malignant formation's first event is included, as the stepwise "
    "reading includes it and the whole-run reading withholds it; a formation drawing within "
    "renewal adds no possibility, neither course then extending the other under it, while both "
    "readings of living rank its presence higher, sharing being an instance. The continuation condition enters "
    "only as a hypothesis. "
    "Instances: the core's living significance, C, D, secured ground and relational living are by definition those of "
    "the existing modules, the core's whole-run reading of courses is the relational inventory of "
    "RenewalComparison with the same undisturbed levels, and J1/J2 on configurations is "
    "PracticalJudgment.Better; "
    "seed-edge closures and evaluator chains are reachability on the edge process, and the "
    "core's closure under a relation is the seed-edge closure from one seed; a "
    "frame's reachable configurations form a joint-continuation space whose bundles step-preserving "
    "maps carry and lifting summaries reflect; robust responses, guarantees, live steps and evidence "
    "narrowing by a rule list are common responses, one-step completion, enabledness and After on a "
    "pure observation; the functional articulation of a situation is exactly the deterministic case "
    "of the articulation under L, and the lifted comparison, reason, survival and continual-improvement "
    "results hold on every frame. A countermodel shows that L is substantive: a response with one "
    "better and one worse outcome is comparable in neither direction. Under the continuation condition living significance holds "
    "for every inventory with positive relevance read from significance, the core's relevance on "
    "a frame's inventory, so a new realization of a generative extension, contingent new content "
    "and the universal address of positioned articulation follow from the continuation condition."
)


# Every constant of the given modules, generated ones, private declarations and unnamed
# instances included, with the axioms it uses: run once on the core closure and once on the
# bridge modules (whose imports may use axioms; only the bridge modules' own constants count).
ENVIRONMENT_AUDIT = """import Lean
{imports}
open Lean Elab Command

#eval show CommandElabM Unit from do
  let env ← getEnv
  for m in [{modules}] do
    let some index := env.getModuleIdx? m | throwError m!"no module {{m}}"
    let mut count := 0
    for (n, _) in env.constants.map₁.toList do
      if env.getModuleIdxFor? n == some index then
        count := count + 1
        let axioms ← liftCoreM <| Lean.collectAxioms n
        if axioms.size > 0 then logInfo m!"AXIOMS {{n}} {{axioms.toList}}"
    logInfo m!"CONSTANTS {{m}} {{count}}"
"""


# Directories holding retained runs, frozen copies and development attempts.
ARCHIVE = re.compile(r"(-checks|-runs|-history|-development|verification.*)$"
                     r"|^(checks|runs|sources|revalidation|retained.*|history|archive.*)$")


def module_index():
    index = {}
    for path in LEAN_ROOT.rglob("*.lean"):
        if any(ARCHIVE.search(part) for part in path.relative_to(LEAN_ROOT).parts[:-1]):
            continue
        name = ".".join(path.relative_to(HERE).with_suffix("").parts) if HERE in path.parents else path.stem
        index.setdefault(name, []).append(path)
    return index


def source_file(name):
    """Where a module sits in the compile directory: `Becoming.Frame` → `Becoming/Frame.lean`."""
    return name.replace(".", "/") + ".lean"


def imports_of(data):
    code = audit_support.code_only(data.decode())
    return [m.strip() for m in re.findall(r"^import\s+(.+)$", code, re.M) if m.strip() != "Std"]


def ring_direction(index):
    """Imports that cross the ring the wrong way: a core module (the root aside) importing a ring
    module, or an instance importing an application."""
    wrong = []
    for name in CORE + INSTANCES:
        if name == "Becoming":
            continue
        outside = RING if name in CORE else APPLICATIONS
        wrong += [(name, d) for d in imports_of(index[name][0].read_bytes()) if d in outside]
    return wrong


def closure(index, roots=CHECKED):
    order, seen = [], set()

    def visit(name, stack):
        assert name not in stack, ("import cycle", stack + [name])
        if name in seen:
            return
        paths = index.get(name, [])
        assert len(paths) == 1, (name, [str(p) for p in paths])
        for dependency in imports_of(paths[0].read_bytes()):
            visit(dependency, stack + [name])
        seen.add(name)
        order.append(name)

    for name in roots:
        visit(name, [])
    return order


# Lean steps that passed, kept outside the repository so that every worktree shares them.
CACHE = Path(os.environ.get("BECOMING_LEAN_CACHE") or Path.home() / ".cache" / "becoming-lean")
FRESH = os.environ.get("BECOMING_FRESH") == "1"
# Seconds allowed for each Lean run; a heavily loaded machine may need more.
TIMEOUT = int(os.environ.get("LEAN_TIMEOUT", "600"))
# Imports supplied by the toolchain or the pinned Mathlib; the step's context names them.
EXTERNAL_ROOTS = {"Init", "Std", "Lean", "Mathlib"}


def step_key(context, label, data, keys):
    """A Lean step's key: the toolchain context, the step, the bytes it reads and the keys
    of the modules it imports, so a module's key covers its whole import closure. No
    source in the closure reads files at compile time."""
    imported = []
    for name in imports_of(data):
        if name not in keys:
            assert name.split(".")[0] in EXTERNAL_ROOTS, ("import without a key", label, name)
        imported.append(keys.get(name, name))
    h = hashlib.sha256()
    for part in [*context, label, data, *imported]:
        part = part if isinstance(part, bytes) else str(part).encode()
        h.update(len(part).to_bytes(8, "big") + part)
    return h.hexdigest()


def module_keys(context, sources, order):
    """Keys of modules compiled in `order`, each after the modules it imports."""
    keys = {}
    for name in order:
        keys[name] = step_key(context, "compile " + name, sources[name], keys)
    return keys


def reuse(key, outputs):
    """For a step that passed with this key: restore its outputs and return its log and
    the run it came from. Otherwise None."""
    if FRESH:
        return None
    try:
        entry = json.loads((CACHE / (key + ".json")).read_text())
        blobs = [(CACHE / key / path.name).read_bytes() for path in outputs]
        if [audit_support.digest(blob) for blob in blobs] != entry["outputs"]:
            return None
    except (OSError, ValueError, KeyError):
        return None
    for path, blob in zip(outputs, blobs):
        path.write_bytes(blob)
    return entry["log"], entry["run"]


def store(key, outputs, log, run):
    """Keep a passed step for later runs. The cache only saves work, so a failed write is ignored."""
    def write(path, data):
        temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
        temporary.write_bytes(data)
        os.replace(temporary, path)

    try:
        blobs = [path.read_bytes() for path in outputs]
        if outputs:
            (CACHE / key).mkdir(parents=True, exist_ok=True)
        CACHE.mkdir(parents=True, exist_ok=True)
        for path, blob in zip(outputs, blobs):
            write(CACHE / key / path.name, blob)
        entry = {"run": run, "log": log, "outputs": [audit_support.digest(blob) for blob in blobs]}
        write(CACHE / (key + ".json"), json.dumps(entry, ensure_ascii=False).encode())
    except OSError:
        pass


# Lean steps run at once (`BECOMING_JOBS`); 1 runs them one at a time.
JOBS = max(1, int(os.environ.get("BECOMING_JOBS") or (os.cpu_count() or 2) // 2))


def run_graph(tasks, jobs=JOBS):
    """Run `tasks` (name → (names it needs, action)) on `jobs` threads, each once every task
    it needs has finished; return the actions' results by name. A step waits only for the
    steps whose outputs it reads, so the outcome is the one-at-a-time outcome. Among ready
    tasks, the one with the longest chain of tasks waiting on it goes first. After a failure
    no task starts; the first failure is raised once the running tasks end."""
    waiting_on = {name: [] for name in tasks}
    for name, (needs, _) in tasks.items():
        for need in needs:
            waiting_on[need].append(name)
    depth = {}

    def chain(name):
        if name not in depth:
            depth[name] = 1 + max((chain(after) for after in waiting_on[name]), default=0)
        return depth[name]

    for name in tasks:
        chain(name)
    rank = {name: i for i, name in enumerate(tasks)}
    results, waiting, running, failure = {}, set(tasks), {}, None
    with ThreadPoolExecutor(max_workers=jobs) as pool:
        while running or (waiting and failure is None):
            if failure is None:
                ready = sorted((name for name in waiting if all(n in results for n in tasks[name][0])),
                               key=lambda name: (-depth[name], rank[name]))
                for name in ready[:jobs - len(running)]:
                    waiting.discard(name)
                    running[pool.submit(tasks[name][1])] = name
            if not running:
                break
            done, _ = wait(running, return_when=FIRST_COMPLETED)
            for future in sorted(done, key=lambda f: rank[running[f]]):
                name = running.pop(future)
                try:
                    results[name] = future.result()
                except Exception as error:
                    failure = failure or error
    if failure is not None:
        raise failure
    assert not waiting, ("tasks whose needs never finished", sorted(waiting))
    return results


def in_serial_order(steps, logs):
    """Order a receipt's `ran`, `reused` and `keys` as a one-at-a-time run lists them."""
    position = {log: i for i, log in enumerate(logs)}
    place = lambda log: (position.get(log, len(logs)), log)  # noqa: E731
    steps["ran"] = sorted(steps["ran"], key=place)
    for part in ("reused", "keys"):
        steps[part] = {log: steps[part][log] for log in sorted(steps[part], key=place)}


def held_in_main(files):
    """The commit `main` names, and which of `files` (path → bytes) it holds byte for byte
    at the same path. A held file needs no copy in a run folder. Without git, `main` or a
    SHA-1 object store, nothing is held and every file is copied."""
    try:
        def git(*args, cwd=HERE):
            return subprocess.check_output(["git", *args], cwd=cwd, stderr=subprocess.DEVNULL)
        top = Path(git("rev-parse", "--show-toplevel").decode().strip())
        if git("rev-parse", "--show-object-format").decode().strip() != "sha1":
            return None, set()
        commit = git("rev-parse", "--verify", "main^{commit}").decode().strip()
        relative = {str(path.resolve().relative_to(top)): path for path in files}
        listing = git("ls-tree", "-z", commit, "--", *relative, cwd=top)
    except (OSError, ValueError, subprocess.CalledProcessError):
        return None, set()
    blobs = {}
    for entry in listing.split(b"\0"):
        if entry:
            meta, path = entry.split(b"\t", 1)
            blobs[path.decode()] = meta.split()[2].decode()
    held = {path for name, path in relative.items()
            if blobs.get(name) == hashlib.sha1(b"blob %d\0" % len(files[path]) + files[path]).hexdigest()}
    return commit, held


def passed_receipts(exclude=(RECEIPT, RETAINED)):
    """The passed receipts under the Lean root, by path relative to it, parsed: a JSON object
    whose `status` is "passed" or whose `passed` is true. `exclude` names the receipt files
    and run folders left out: by default this checker's own."""
    exclude = [Path(p).resolve() for p in exclude]
    receipts = []
    for path in LEAN_ROOT.rglob("*.json"):
        resolved = path.resolve()
        if any(resolved == p or p in resolved.parents for p in exclude):
            continue
        text = path.read_text(errors="replace")
        if '"passed"' not in text:
            continue
        try:
            data = json.loads(text)
        except ValueError:
            continue
        if isinstance(data, dict) and (data.get("status") == "passed" or data.get("passed") is True):
            receipts.append((str(path.relative_to(LEAN_ROOT)), data))
    return receipts


# Keys under which a receipt records a source's bytes, and entry fields naming the source.
HASH_FIELDS = ("source_sha256", "sha256")
NAME_FIELDS = ("module", "name", "source", "path")


def binds(data, name, path, digest):
    """Whether a receipt maps this module to these bytes: a `source_sha256` (or `sha256`)
    entry keyed by the module's name or path, under a key of sources or modules; or an entry
    whose `source_sha256` (or `sha256`) is the digest and whose module, name, source or path
    field names the module. Copies of files a run kept (`artifact_sha256`) do not count."""
    relative = str(path.relative_to(LEAN_ROOT))

    def names(value):
        return isinstance(value, str) and (
            value in (name, path.name, path.stem, relative) or value.endswith("/" + relative))

    def hashed(value):
        return value == digest or (isinstance(value, dict) and any(value.get(f) == digest for f in HASH_FIELDS))

    def walk(value, under):
        if isinstance(value, list):
            return any(walk(item, under) for item in value)
        if not isinstance(value, dict):
            return False
        if any(value.get(f) == digest for f in HASH_FIELDS) and any(names(value.get(f)) for f in NAME_FIELDS):
            return True
        keyed = under is not None and "artifact" not in under and ("source" in under or "module" in under)
        for key, item in value.items():
            if keyed and names(key) and hashed(item):
                return True
            if walk(item, key):
                return True
        return False

    return walk(data, None)


def receipts_for(name, path, digest, receipts):
    """The passed receipts (from `passed_receipts`) that map this module to these bytes."""
    return sorted(where for where, data in receipts if binds(data, name, path, digest))


# The Lean binary: `LEAN` if set; else `elan which lean` run in this folder, whose
# `lean-toolchain` names the toolchain; else elan's default toolchain path.
DEFAULT_LEAN = Path.home() / ".elan/toolchains/leanprover--lean4---v4.29.1/bin/lean"


def resolve_lean(folder=HERE, toolchain=None, default=DEFAULT_LEAN):
    """The command that runs Lean, the binary it runs and how it was found. The binary's
    sha256, not its path, enters the step keys, so each way finds the same cached steps."""
    toolchain = toolchain or audit_support.TOOLCHAIN
    given = os.environ.get("LEAN")
    if given:
        binary = Path(given).expanduser().resolve()
        return [str(binary)], binary, "LEAN"
    elan = shutil.which("elan") or str(Path.home() / ".elan/bin/elan")
    try:
        found = subprocess.run([elan, "which", "lean"], cwd=folder, text=True, timeout=120,
                               stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
        binary = Path(found.stdout.strip()).resolve() if found.returncode == 0 and found.stdout.strip() else None
        if binary and binary.is_file():
            return [str(binary)], binary, "elan which lean"
    except (OSError, subprocess.SubprocessError):
        pass
    return [str(Path.home() / ".elan/bin/lean"), "+" + toolchain], default, "default path"


# `BECOMING_OUT=<dir>`: the run folder and the receipt go to that directory, not the repository.
OUT = Path(os.environ["BECOMING_OUT"]).expanduser().resolve() if os.environ.get("BECOMING_OUT") else None


def output_paths(receipt, retained):
    """Where this run writes its receipt and run folders: the repository's, or under `BECOMING_OUT`."""
    return (OUT / receipt.name, OUT / retained.name) if OUT else (receipt, retained)


def shown(path):
    """A run folder as the receipt names it: relative to this folder where inside it."""
    return str(path.relative_to(HERE)) if HERE in path.parents else str(path)


# Words of exchange in a declaration name (the list of tools/research/style.py, MARKET_EN, as
# words). A structural name says what a relation does. A spine name containing one is reported,
# not failed; names in MARKET_ALLOWED are scientific terms and keep their words.
MARKET_WORDS = {"cost", "costs", "costly", "costing", "charge", "charges", "charged", "charging", "budget",
                "budgets", "budgeted", "pay", "pays", "paying", "payment", "payments", "paid", "price",
                "prices", "priced", "pricing", "spend", "spends", "spending", "spent", "accounting", "credit",
                "credits", "credited", "crediting", "fee", "fees", "profit", "profits", "profitable", "fund",
                "funds", "funded", "funding"}
MARKET_ALLOWED = {
    "Becoming.price": "the counting form of Price's equation",
    "Becoming.Oscillation.charge": "an oscillator's stored level, in the physical sense",
    "Becoming.Oscillation.charge_even": "an oscillator's stored level, in the physical sense",
    "Becoming.Oscillation.charge_odd": "an oscillator's stored level, in the physical sense",
}


def name_words(full):
    """The lower-case words of a Lean name: split at dots, underscores, primes and camel case."""
    return [w.lower() for part in re.split(r"[._']", full)
            for w in re.findall(r"[A-Z]?[a-z]+|[A-Z]+(?![a-z])|[0-9]+", part)]


def market_names(registry):
    """Spine declarations whose names contain a word of exchange, outside MARKET_ALLOWED."""
    return {item["name"]: sorted(set(name_words(item["name"])) & MARKET_WORDS)
            for name in SPINE for item in registry.get(name, [])
            if item["name"] not in MARKET_ALLOWED and set(name_words(item["name"])) & MARKET_WORDS}


def scanned(data):
    """The shared scanner's reading of a module (`declarations`, `private`, `unnamed_instances`)."""
    # A root module only imports and documents; it declares nothing.
    if not re.sub(r"^import .+$", "", audit_support.code_only(data.decode()), flags=re.M).strip():
        return {"declarations": [], "private": [], "unnamed_instances": []}
    # The inherited scanner accepts only Std/GenerativeCore imports; it reads a copy
    # with imports replaced. Compilation uses the unchanged bytes.
    return audit_support.scan(re.sub(r"^import .+$", "import Std", data.decode(), flags=re.M))


def declarations(data):
    """The declarations of a module that are audited by name."""
    return scanned(data)["declarations"]


CONTROLS = """import Becoming
open Becoming Generative Generative.InquirySufficiency

-- The full premise set is consistent: the model satisfies seed, both neutralities and connection.
example : (Model.valuation Model.linked (fun _ _ => True)).Grounds :=
  ((Model.valuation Model.linked (fun _ _ => True)).significant_iff
    (Model.linked_connected _) .evaluator (c₀ := .self) trivial).mp (fun _ _ _ => trivial)

-- The headline theorem has a nonvacuous instance: one step forms a new living claim.
def grow : Frame Bool Unit Unit := ⟨⟨fun s _ t => s = false ∧ t = true⟩, fun s _ => s = true⟩
def everyone : Valuation Model.Who Unit :=
  ⟨fun _ => True, fun _ _ => True, fun _ _ => True, fun _ _ => True⟩
def zero : Fin 2 := ⟨0, Nat.zero_lt_succ 1⟩
def sense0 : Bool → Unit → Bool → Fin 2 := fun _ _ _ => zero
def respondOnce : Unit → List Unit := fun _ => [()]
def believed : Bool → Prop := fun s => s = false
def access : Model.Who → Policy Unit Unit 2 → Prop := fun _ _ => True
def nothingBefore : Bool → Unit → Prop := fun _ _ => False

/-- The least reason satisfying A. -/
def routeReason (p : Model.Who) (r : Policy Unit Unit 2) : Prop :=
  access p r ∧ SecuresNewContent (Scope grow.P sense0 respondOnce believed) nothingBefore
    (fun _ c => everyone.sig p c) r

theorem grow_sound :
    Sound grow.P (fun _ _ _ => True) (Novel grow everyone.living nothingBefore)
      sense0 respondOnce (.respond ()) believed :=
  ⟨⟨false, rfl⟩, fun s held => by
    cases held
    exact ⟨⟨true, rfl, rfl⟩, fun t step => ⟨trivial, by
      cases step.2
      exact ⟨(), trivial, rfl, id⟩⟩⟩⟩

theorem grow_reason : ∀ p, access p (.respond ()) → routeReason p (.respond ()) :=
  universal_reason grow everyone nothingBefore access routeReason
    ⟨⟨.evaluator, (), trivial, trivial⟩, fun ⟨_, _, _⟩ _ _ _ => trivial,
      fun ⟨_, _, _⟩ _ _ => trivial⟩
    (fun _ _ _ _ => Reach.refl _ _)
    (fun ⟨_, _⟩ available secured => ⟨available, secured⟩)
    (.respond ()) grow_sound

-- The continuation instance is nonvacuous: a reached configuration realizes the living claim.
example : Jointly grow (Reach grow.P false) (fun _ => True) :=
  ⟨true, Reach.of_step (a := ()) ⟨rfl, rfl⟩, fun _ _ => rfl⟩

-- The common-condition discharge is nonvacuous: in `Renewable`, every formation participates.
example : (Renewable.conditions.valuation Renewable.withinRenewal (fun (_ : Unit) _ => True)
    (fun _ _ => True)).Connected :=
  Renewable.conditions.connected_of_common Renewable.withinRenewal _ _ ()
    (fun e _ => match e with
      | (.focal, _) => Or.inr trivial
      | (.sustaining, _) => Or.inl trivial)

-- The stepwise discharge is nonvacuous: its first event is living in the escalating run.
example : ((Renewable.conditions.dependence.along Renewable.escalating).valuation
    (fun (_ : Unit) _ => True) (fun _ _ => True)).Connected ∧
    ((Renewable.conditions.dependence.along Renewable.escalating).valuation
      (fun (_ : Unit) _ => True) (fun _ _ => True)).living (.focal, 0) :=
  ⟨Web.connected_of_common _ _ _ ()
    (fun e _ => match e with
      | (.focal, _) => Or.inr trivial
      | (.sustaining, _) => Or.inl trivial),
   ⟨trivial, Renewable.stepwise_includes_before_escalation.2.1.not_undermining⟩⟩
"""


def main():
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S.%fZ")
    receipt_path, runs = output_paths(RECEIPT, RETAINED)
    retained = runs / stamp
    retained.mkdir(parents=True, exist_ok=False)
    index = module_index()
    order = closure(index)
    core_closure = closure(index, CORE)
    paths = {name: index[name][0] for name in order}
    sources = {name: paths[name].read_bytes() for name in order}
    helper_paths = [Path(__file__).resolve(), LEAN_ROOT / "universal-ethics" / "generative-capacity" / "check.py"]
    helpers = {p.name: p.read_bytes() for p in helper_paths}
    commit, held = held_in_main({**{p: helpers[p.name] for p in helper_paths},
                                 **{paths[name]: sources[name] for name in order}})
    copied = {p.name: helpers[p.name] for p in helper_paths if p not in held}
    copied.update({name + ".lean": sources[name] for name in order if paths[name] not in held})
    for name, data in copied.items():
        (retained / name).write_bytes(data)
    receipt = {
        "status": "checking", "utc": stamp, "toolchain": audit_support.TOOLCHAIN,
        "retained_run": shown(retained),
        "spine_modules": SPINE,
        "core_modules": CORE, "foundation_modules": FOUNDATION, "bridge_modules": BRIDGE,
        "instance_modules": INSTANCES, "application_modules": APPLICATIONS,
        "periphery_join_modules": PERIPHERY_JOINS,
        "core_closure": core_closure,
        "compile_order": order,
        "source_paths": {name: str(paths[name].relative_to(LEAN_ROOT)) for name in order},
        "source_sha256": {name: audit_support.digest(data) for name, data in sources.items()},
        "checker_sha256": {name: audit_support.digest(data) for name, data in helpers.items()},
        # Files main holds byte for byte are named by this commit; the rest are copied here.
        "source_commit": {"main": commit, "copied": sorted(copied)},
        "scope": SCOPE,
    }
    # A reused step passed in the named run with the same binary and identical inputs; its log
    # stays in the cache under its key. Drivers and logs of the steps that ran are kept here.
    steps = receipt["lean_steps"] = {"cache": str(CACHE), "fresh": FRESH, "ran": [], "reused": {}, "keys": {}}
    try:
        assert sorted(core_closure) == sorted(PURE), ("core imports outside the core", core_closure)
        assert not set(CORE) & set(RING) and len(set(RING)) == len(RING), ("ring lists overlap", sorted(set(CORE) & set(RING)))
        assert not ring_direction(index), ("import against the ring's direction", ring_direction(index))
        # A superseded module stays out of the run, and the core modules said to state it are core.
        assert not set(SUPERSEDED) & set(order), ("superseded module in the run", sorted(set(SUPERSEDED) & set(order)))
        for name, stated_by in SUPERSEDED.items():
            assert len(index.get(name, [])) == 1, ("superseded module not found once", name)
            assert stated_by and all(m in PURE for m in stated_by), ("superseded module not stated by the core", name, stated_by)
        receipt["superseded_modules"] = {
            name: {"source_path": str(index[name][0].relative_to(LEAN_ROOT)),
                   "source_sha256": audit_support.digest(index[name][0].read_bytes()),
                   "stated_by": stated_by}
            for name, stated_by in SUPERSEDED.items()}
        inherited = [name for name in order if name not in CHECKED]
        # A record of history, not a check: inherited modules are compiled and audited below.
        # A receipt counts where it maps the module to its current bytes and has passed.
        receipts = passed_receipts(exclude=(RECEIPT, RETAINED, receipt_path, runs))
        matches = {}
        for name in inherited:
            found = receipts_for(name, paths[name], receipt["source_sha256"][name], receipts)
            assert found, ("inherited module has no passed receipt for its current bytes", name)
            matches[name] = found
        receipt["inherited_receipts"] = matches
        scans = {name: scanned(data) for name, data in sources.items()}
        registry = {name: scans[name]["declarations"] for name in order}
        # Private declarations and unnamed instances cannot be audited by name; in the core
        # closure and the bridge the environment audits cover every constant of the module.
        receipt["not_audited_by_name"] = {
            name: {"private": [item["name"] for item in scans[name]["private"]],
                   "unnamed_instance_lines": scans[name]["unnamed_instances"],
                   "covered_by": ("core environment audit" if name in core_closure
                                  else "bridge environment audit" if name in BRIDGE
                                  else "none (periphery join)" if name in PERIPHERY_JOINS else "none (inherited)")}
            for name in order if scans[name]["private"] or scans[name]["unnamed_instances"]}
        receipt["market_names"] = market_names(registry)
        command, binary, found_by = resolve_lean()
        receipt["lean_binary_sha256"] = audit_support.digest(binary.read_bytes())
        receipt["lean_resolution"] = found_by
        context = [audit_support.TOOLCHAIN, receipt["lean_binary_sha256"]]
        keys = module_keys(context, sources, order)
        origin = {"utc": stamp, "retained": str(retained)}
        records = []
        with tempfile.TemporaryDirectory(prefix="becoming-spine-lean-") as scratch:
            work = Path(scratch)

            def run(args, log, where=work, key=None, outputs=(), driver=None):
                outputs = [where / output for output in outputs]
                if key:
                    steps["keys"][log] = key
                found = reuse(key, outputs) if key else None
                if found:
                    output, steps["reused"][log] = found
                    return output
                if driver:
                    (retained / driver).write_bytes((where / driver).read_bytes())
                env = {**os.environ, "LEAN_PATH": str(where)}
                p = subprocess.run(command + args, cwd=where, env=env, text=True,
                                   stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=TIMEOUT)
                (retained / log).write_text(p.stdout)
                assert p.returncode == 0, p.stdout
                assert not re.search(r"\b(?:error|warning):", p.stdout), p.stdout
                steps["ran"].append(log)
                if key:
                    store(key, outputs, p.stdout, origin)
                return p.stdout

            receipt["lean_version"] = run(["--version"], "version.log").strip()
            assert "version 4.29.1" in receipt["lean_version"]
            for name, data in sources.items():
                target = work / source_file(name)
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(data)
            # Each Lean step waits for the compiles of the modules it imports (run_graph);
            # `sequence` is the order of a one-at-a-time run, which the receipt keeps.
            tasks, sequence = {}, ["version.log"]

            def compiled(text, prefix="compile "):
                """The compile steps a driver or module reads: those of the package modules it imports."""
                data = text.encode() if isinstance(text, str) else text
                return [prefix + name for name in imports_of(data) if name in keys]

            def compile_step(name, log, where, key):
                olean = source_file(name)[:-5] + ".olean"
                return lambda: run(["-o", olean, source_file(name)], log, where, key=key, outputs=[olean])

            def driver_step(driver, text):
                def step():
                    (work / driver).write_text(text)
                    return run([driver], driver[:-5] + ".log",
                               key=step_key(context, driver, text.encode(), keys), driver=driver)
                return step

            for name in order:
                flat = name.replace(".", "")
                tasks["compile " + name] = (compiled(sources[name]),
                                            compile_step(name, name + ".log", work, keys[name]))
                audit = "import " + name + "\n" + "\n".join(
                    "#print axioms " + item["name"] for item in registry[name]) + "\n"
                tasks["audit " + name] = (["compile " + name], driver_step(flat + "AxiomAudit.lean", audit))
                sequence += [name + ".log", flat + "AxiomAudit.log"]
                if name in CHECKED:
                    signatures = "import " + name + "\n" + "\n".join(
                        "#check @" + item["name"] for item in registry[name] if item["kind"] == "theorem") + "\n"
                    tasks["signatures " + name] = (["compile " + name],
                                                   driver_step(flat + "Signatures.lean", signatures))
                    sequence.append(flat + "Signatures.log")
            # Constants Lean generates are not source declarations; audit them as well.
            environment = ENVIRONMENT_AUDIT.format(
                imports="\n".join("import " + name for name in core_closure),
                modules=", ".join("`" + name for name in core_closure))
            tasks["environment"] = (compiled(environment), driver_step("EnvironmentAudit.lean", environment))
            # The bridge's own constants, by the same driver: its imports may use axioms.
            bridge_environment = ENVIRONMENT_AUDIT.format(
                imports="\n".join("import " + name for name in BRIDGE),
                modules=", ".join("`" + name for name in BRIDGE))
            if BRIDGE:
                tasks["bridge environment"] = (compiled(bridge_environment),
                                               driver_step("BridgeEnvironmentAudit.lean", bridge_environment))
            tasks["controls"] = (compiled(CONTROLS), driver_step("Controls.lean", CONTROLS))
            sequence += ["EnvironmentAudit.log"] + (["BridgeEnvironmentAudit.log"] if BRIDGE else []) + ["Controls.log"]
            # The core needs nothing beyond Lean's prelude.
            bare = work / "prelude-only"
            bare.mkdir()
            stripped = {name: re.sub(r"^import Std\n", "", sources[name].decode(), flags=re.M).encode()
                        for name in core_closure}
            bare_keys = module_keys(context + ["prelude only"], stripped, core_closure)
            for name in core_closure:
                target = bare / source_file(name)
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(stripped[name])
                tasks["prelude " + name] = (compiled(stripped[name], "prelude "),
                                            compile_step(name, name + ".PreludeOnly.log", bare, bare_keys[name]))
                sequence.append(name + ".PreludeOnly.log")
            try:
                outputs = run_graph(tasks)
            finally:
                in_serial_order(steps, sequence)
            for name in order:
                output = outputs["audit " + name]
                dependencies = {}
                for item in registry[name]:
                    full = item["name"]
                    if "'" + full + "' does not depend on any axioms" in output:
                        axioms = []
                    else:
                        match = re.search(r"'" + re.escape(full) + r"' depends on axioms:\s*\[([^]]*)\]", output)
                        assert match, (full, output)
                        axioms = [a.strip() for a in match[1].split(",") if a.strip()]
                    assert set(axioms) <= {"propext", "Quot.sound", "Classical.choice"}, (full, axioms)
                    assert name not in SPINE + PURE or not axioms, (full, axioms)
                    dependencies[full] = axioms
                records.append({
                    "module": name, "spine": name in SPINE,
                    "layer": ("foundation" if name in FOUNDATION else "core" if name in CORE
                              else "instance" if name in INSTANCES else "application" if name in APPLICATIONS
                              else "bridge" if name in BRIDGE
                              else "periphery join" if name in PERIPHERY_JOINS else "inherited"),
                    "theorems": sum(x["kind"] == "theorem" for x in registry[name]),
                    "declarations": registry[name], "axiom_dependencies": dependencies,
                    "kernel_checked": True,
                })
            def environment_audit(output, modules):
                """Every constant of `modules` has an empty axiom report, apart from generated
                injectivity lemmas (`injEq`) on `propext` that no source declaration is."""
                constants = {m: int(n) for m, n in re.findall(r"CONSTANTS (\S+) (\d+)", output)}
                assert sorted(constants) == sorted(modules), (constants, modules)
                generated = {n: [a.strip() for a in axs.split(",") if a.strip()]
                             for n, axs in re.findall(r"AXIOMS (\S+) \[([^]]*)\]", output)}
                sources_named = {item["name"] for name in modules for item in registry[name]}
                for full, axioms in generated.items():
                    assert full.endswith(".injEq") and axioms == ["propext"], (full, axioms)
                    assert full not in sources_named, full
                return constants, generated

            constants, generated = environment_audit(outputs["environment"], core_closure)
            receipt["core_closure_constants"] = constants
            receipt["generated_axiom_dependencies"] = generated
            constants, generated = (environment_audit(outputs["bridge environment"], BRIDGE)
                                    if BRIDGE else ({}, {}))
            receipt["bridge_constants"] = constants
            receipt["bridge_generated_axiom_dependencies"] = generated
            receipt["core_compiles_from_prelude"] = True
            receipt["checked_application_examples"] = [
                {"claim": "the full premise set has a model", "kernel_checked": True, "counted_as_new_theorem": False},
                {"claim": "universal_reason has a nonvacuous instance on a one-step frame", "kernel_checked": True, "counted_as_new_theorem": False},
                {"claim": "a frame's continuation space has a reached configuration realizing a living claim", "kernel_checked": True, "counted_as_new_theorem": False},
                {"claim": "a run with a common condition is connected under the relational reading", "kernel_checked": True, "counted_as_new_theorem": False},
                {"claim": "the stepwise reading is connected by a common condition and includes a living event", "kernel_checked": True, "counted_as_new_theorem": False},
            ]
        receipt["source_unchanged_during_check"] = all(
            paths[name].read_bytes() == data for name, data in sources.items())
        assert receipt["source_unchanged_during_check"], "Source changed; only snapshot checked"
        assert all((retained / name).read_bytes() == data for name, data in copied.items())
        receipt["modules"] = records
        receipt["artifact_sha256"] = {
            p.name: audit_support.digest(p.read_bytes()) for p in sorted(retained.iterdir()) if p.is_file()
        }
        receipt["status"] = "passed"
    except Exception as error:
        receipt["status"] = "failed"
        receipt["error"] = str(error)
        raise
    finally:
        serialized = json.dumps(receipt, indent=2, ensure_ascii=False) + "\n"
        (retained / "verification.json").write_text(serialized)
        receipt_path.write_text(serialized)
    spine = [r for r in records if r["spine"]]
    print(json.dumps({
        "status": receipt["status"],
        "core_closure": core_closure,
        "core_axioms": sorted({a for r in records if r["layer"] in ("foundation", "core", "instance", "application")
                               for aa in r["axiom_dependencies"].values() for a in aa}),
        "spine_theorems": {r["module"]: r["theorems"] for r in spine},
        "spine_declaration_audits": sum(len(r["declarations"]) for r in spine),
        "generated_with_axioms": len(receipt.get("generated_axiom_dependencies", {})),
        "bridge_constants": sum(receipt.get("bridge_constants", {}).values()),
        "bridge_generated_with_axioms": len(receipt.get("bridge_generated_axiom_dependencies", {})),
        "not_audited_by_name": {name: len(v["private"]) + len(v["unnamed_instance_lines"])
                                for name, v in receipt.get("not_audited_by_name", {}).items()},
        "inherited_modules": sum(r["layer"] == "inherited" for r in records),
        "superseded_modules": len(SUPERSEDED),
        "periphery_join_theorems": {r["module"]: r["theorems"] for r in records if r["layer"] == "periphery join"},
        "periphery_join_axioms": sorted({a for r in records if r["layer"] == "periphery join"
                                         for aa in r["axiom_dependencies"].values() for a in aa}),
        "inherited_axioms": sorted({a for r in records if r["layer"] == "inherited"
                                    for aa in r["axiom_dependencies"].values() for a in aa}),
        "market_names": receipt.get("market_names", {}),
        "lean_steps_run": len(steps["ran"]), "lean_steps_reused": len(steps["reused"]),
        "lean": receipt.get("lean_resolution"),
        "receipt": str(receipt_path),
    }))


if __name__ == "__main__":
    main()
