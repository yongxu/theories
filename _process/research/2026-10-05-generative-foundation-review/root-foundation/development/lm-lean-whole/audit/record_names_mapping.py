"""old -> new names for the records, from the merge's plan, BD4, the dropped premises and the rest."""
import sys,re
from pathlib import Path
sys.path.insert(0,'/Users/ren/tmp/lm/dedupe')
import importlib.util
spec=importlib.util.spec_from_file_location('block','/Users/ren/tmp/lm/dedupe/block.py'); m=importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
MAP={k:v.replace(' _','') for k,v in m.PLAN.items()}
MAP.update({
 'Continuity.count_append':'GrammarLaws.count_append','Continuity.count_replicate_true':'GrammarLaws.count_replicate_true',
 'Continuity.count_replicate_false':'GrammarLaws.count_replicate_false','Continuity.paired_single':'GrammarLaws.paired_single',
 'Continuity.unitsOn':'unitsOn','Weighting.unitsOf':'unitsOn','Weighting.total_unitsOf':'Weighting.total_unitsOn','Weighting.mem_unitsOf':'Weighting.mem_unitsOn',
 'unitsOf':'unitsOn','total_unitsOf':'total_unitsOn','mem_unitsOf':'mem_unitsOn',
 'Reproduction.total_replicate':'total_replicate','PairSelection.total_replicate':'total_replicate','Reproduction.Mutation.total_replicate':'total_replicate',
 'LineageDrawdown.below_of_excess':'Flow.below_of_excess',
 'LineageDrawdown.degeneration_of_excess':'LineageRegimes.degeneration_of_family_excess',
 'LineageDrawdown.landed_of_excess':'LineageRegimes.degeneration_of_family_excess',
 'LineageDrawdown.gone_of_excess':'Web.family_excess_gone','LineageDrawdown.landed_gone':'Web.family_excess_gone',
 'LineageDrawdown.horizon_of_excess':'Web.family_excess_degenerates','LineageDrawdown.landed_horizon':'Web.family_excess_degenerates',
 'LineageDrawdown.Drain.landed_met':'LineageDrawdown.Drain.gated_ends',
 '缕之无定性':'四相俱时',
 'Hexagram.all_sound':'ListTests.all_sound','Hexagram.all_complete':'ListTests.all_complete',
})
DROP={'LineageDrawdown.landed_of_excess_eq','LineageDrawdown.landed_gone_eq','LineageDrawdown.landed_horizon_eq',
 'repeatOnto','total_repeatOnto','mem_repeatOnto','Weighting.repeatOnto','Weighting.total_repeatOnto','Weighting.mem_repeatOnto',
 'Continuity.repeatOnto','Continuity.total_repeatOnto','Continuity.mem_repeatOnto'}
