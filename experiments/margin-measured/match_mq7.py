"""MQ7: which stocks of the test sources no analysis has read (metadata only; no value is read).

  python3 -I match_mq7.py SMART SAG XLSX    writes results/mq7/matching.json

A test stock is unread where no RAM Legacy stock whose values MQ3, MQ4 or MQ5 read holds the same fish: the same
species in an overlapping area. A stock reassessed under a new definition keeps only its latest assessment. The
decisions below were made by reading the sources' names, species, areas and model types against the RAM `stock` table
(stockid, species, area, region, state), before any value of either source was read.
  ICES SAG: every stock whose latest published advice assessment is from 2018 on and names a model type (SAG's
    ModelType; stocks without one are not modelled assessments and carry no level in tonnes).
  Stock SMART: every stock with an assessment that carries a level in weight and a catch in weight over at least
    mq3.MIN_SP + 1 consecutive years (mq7.smart_choice).
"""
from __future__ import annotations

import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import mq3  # noqa: E402
import mq7  # noqa: E402

# ICES stocks holding the fish of a RAM stock MQ3-MQ5 read
SAG_READ = {
    'ane.27.8': 'ANCHOBAYB', 'aru.27.5a14': 'GSSMELTVa-XIV', 'aru.27.5b6a': 'GSSMELTVb-VIa', 'bli.27.5b67': 'BLINGVb-VI-VII',
    'bli.27.5b6712': 'BLINGVb-VI-VII', 'bss.27.4bc7ad-h': 'EBASSIVbc-VII', 'bss.27.8ab': 'EBASSVIIIab',
    'cap.27.2a514': 'CAPEIIa-V-XIV', 'cod.2127.1f14': 'COD1F-XIV', 'cod.27.1-2': 'CODNEAR', 'cod.27.21': 'CODKAT',
    'cod.27.22-24': 'CODBA2224', 'cod.27.24-32': 'CODBA2532', 'cod.27.46a7d20': 'CODIIIaW-IV-VIId',
    'cod.27.47d20': 'CODIIIaW-IV-VIId', 'cod.27.5a': 'CODICE', 'cod.27.5b1': 'CODFAPL', 'cod.27.6a': 'CODVIa',
    'cod.27.7a': 'CODIS', 'cod.27.7e-k': 'CODVIIek', 'dgs.27.nea': 'SPURDNEATL', 'ghl.27.1-2': 'GHALNEAR',
    'had.27.1-2': 'HADNEAR', 'had.27.46a20': 'HADNS-IIIa-VIa', 'had.27.5a': 'HADICE', 'had.27.5b': 'HADFAPL',
    'had.27.6b': 'HADROCK', 'had.27.7b-k': 'HADVIIb-k', 'her.27.1-24a514a': 'HERRNORSS', 'her.27.20-24': 'HERR2224IIIa',
    'her.27.25-2932': 'HERR2529-32', 'her.27.28': 'HERRRIGA', 'her.27.3031': 'HERR30-31', 'her.27.3a47d': 'HERRNS-IIIa-VIId',
    'her.27.5a': 'HERRIsum', 'her.27.6a7bc': 'HERRVIaVIIbc', 'her.27.6aN': 'HERRVIaVIIbc', 'her.27.6aS7bc': 'HERRVIaVIIbc',
    'her.27.irls': 'HERRSIRS', 'her.27.nirs': 'HERRNIRS', 'hke.27.3a46-8abd': 'HAKENRTN', 'hke.27.8c9a': 'HAKESOTH',
    'hom.27.2a3a4a5b6a7a-ce-k8': 'HMACKIIa-IVa-Vb-VIa-VII-VIII', 'hom.27.2a4a5b6a7a-ce-k8': 'HMACKIIa-IVa-Vb-VIa-VII-VIII',
    'hom.27.9a': 'HMACKIXa', 'ldb.27.8c9a': 'FMEG8c9a', 'lez.27.6b': 'MEGSPPVIb', 'lin.27.5a': 'LINGVa',
    'lin.27.5b': 'LINGVb', 'mac.27.nea': 'MACKNEICES', 'meg.27.7b-k8abd': 'MEGVII-VIIIabd', 'meg.27.8c9a': 'MEG8c9a',
    'mon.27.78abd': 'WANGLVII-VIIIabd', 'mon.27.8c9a': 'WANGLVIIIc-IXa', 'nep.fu.7': 'NEPHFU7', 'nep.fu.16': 'NEPHFU16',
    'nep.fu.17': 'NEPHFU17', 'nop.27.3a4': 'NPOUTIIIa-IV', 'pil.27.8abd': 'SARDVIIIabd', 'pil.27.8c9a': 'SARDPVIIIc-IXa',
    'ple.27.21-23': 'PLAIC2123', 'ple.27.21-32': 'PLAIC2123', 'ple.27.420': 'PLAICNS', 'ple.27.7a': 'PLAICIS',
    'ple.27.7d': 'PLAIC7d', 'pok.27.1-2': 'POLLNEAR', 'pok.27.3a46': 'POLLNS-VI-IIIa', 'pok.27.5a': 'POLLIEG',
    'pok.27.5b': 'POLLFAPL', 'pra.27.3a4a': 'PANDALIIIaW-IVaE', 'reb.27.1-2': 'REDDEEPI-II', 'reg.27.1-2': 'GOLDREDNEAR',
    'reg.27.561214': 'GOLDREDV-VI-XII-XIV', 'san.sa.1r': 'SEELNSSA1', 'san.sa.2r': 'SEELNSSA2', 'san.sa.3r': 'SEELNSSA3',
    'san.sa.4': 'SEELNSSA4', 'sol.27.20-24': 'SOLEIIIa-2224', 'sol.27.4': 'SOLENS', 'sol.27.7a': 'SOLEIS',
    'sol.27.7d': 'SOLEVIId', 'sol.27.7e': 'SOLEVIIe', 'sol.27.7fg': 'SOLECS', 'sol.27.8ab': 'SOLEVIIIab',
    'spr.27.22-32': 'SPRAT22-32', 'spr.27.3a4': 'SPRATIIIa-IV', 'spr.27.4': 'SPRATIIIa-IV', 'spr.27.7de': 'SPRATVIIde',
    'tur.27.4': 'TURIV', 'usk.27.5a14': 'CUSKVa-XIV', 'whb.27.1-91214': 'BWHITNEA', 'whg.27.47d': 'WHITNS-VIId',
    'whg.27.6a': 'WHITVIa', 'whg.27.7a': 'WHITVIIa', 'whg.27.7b-ce-k': 'WHITVIIbce-k', 'wit.27.3a47d': 'WITFLOUNIIIa-IV-VIId'}
SAG_SUPERSEDED = {
    'ane.27.9a': 'split in 2024; ane.27.9aS assesses its southern part',
    'cod.21.1': 'split into cod.21.1a-c and the inshore stock of 1d-f',
    'cod.27.1-2coast': 'split in 2021 into cod.27.1-2.coastN and cod.27.2.coastS',
    'fle.27.2425': 'relabelled bwq.27.2425 (2020)', 'bwq.27.2628': 'reassessed as bzq.27.2628 (2024)'}
SAG_OUT = {
    'sal.27.22-31': 'anadromous and semelparous in effect: what is left after the catch is not carried into the level',
    'trs.27.22-32': 'anadromous: the level is a run, not a carried stock',
    'ele.2737.nea': 'catadromous and semelparous: what is left after the catch is not carried into the level'}
# unread: the RAM stock of the same fish where there is one (unread there: no level in tonnes), or none
SAG_UNREAD = {
    'ane.27.9aS': 'ANCHIXa', 'anf.27.3a46': 'ANGLSPPIIIa-IV-VI', 'ank.27.78abd': 'ANGLVII-VIIIabd',
    'ank.27.8c9a': 'ANGLVIIIc-IXa', 'aru.27.123a4': 'GSSMELTI-II-IIIa-IV', 'bll.27.3a47de': 'BRILLIIIa-IV-VIIde',
    'boc.27.6-8': 'BOARVI-VIII', 'bwq.27.2425': 'EFLOUN2425', 'bzq.27.2628': 'EFLOUN26-28', 'caa.27.5a': None,
    'cod.21.1.osc': None, 'cod.21.1a-c': None, 'cod.27.1-2.coastN': 'CODNEARNCW', 'cod.27.2.coastS': 'CODNEARNCW',
    'dab.27.22-32': 'DAB2232', 'fle.27.2223': 'EFLOUN2223', 'ghl.27.561214': 'GHALV-VI-XII-XIV',
    'hom.27.4bc7d': 'HMACKIIIa-IVbc-VIId', 'lem.27.3a47d': 'LSOLEIIIa-IV-VIId', 'lez.27.4a6a': 'MEGSPPIVa-VIa',
    'lin.27.3a4a6-91214': 'LINGNEATL', 'nep.fu.10': 'NEPHFU10', 'nep.fu.15': 'NEPHFU15', 'nep.fu.19': 'NEPHFU19',
    'nep.fu.2021': 'NEPHFU2021', 'nep.fu.22': 'NEPHFU22', 'nep.fu.2324': 'NEPHVIIIab', 'nep.fu.25': 'NEPHFU25',
    'nep.fu.2627': 'NEPHFU2627', 'nep.fu.3-4': 'NEPHFU3-4', 'nep.fu.32': 'NEPHFU32', 'nep.fu.34': 'NEPHFU34',
    'nep.fu.8': 'NEPHFU8', 'nep.fu.9': 'NEPHFU9', 'pil.27.7': 'SARDVII', 'ple.27.24-32': 'PLAIC2432', 'ple.27.5a': None,
    'pol.27.67': None, 'pol.27.89a': 'EPOLLVIII-IXa', 'por.27.nea': 'PORSHARNEATL', 'pra.27.1-2': 'PANDALI-II',
    'reb.2127.dp': 'REDDEEPDP-1-2-V-XII-XIV', 'reb.27.5a14': 'REDDEEPVa-XIV', 'rjc.27.3a47d': 'TBSKAIIIa-IV-VIId',
    'rjc.27.8abd': 'TBSKAVIII', 'rjc.27.8c': 'TBSKAVIII', 'rjc.27.9a': 'TBSKAIXa', 'rjh.27.4bc7d': 'BLRAYIVc-VIId',
    'rjm.27.3a47d': 'SPRAYIIIa-IV-VIId', 'rjn.27.678abd': 'CKRAYVI-VII', 'rjn.27.9a': 'CKRAYIXa', 'rju.27.7de': 'URAYVIIde',
    'san.27.6a': 'SEELVIa', 'sbr.27.10': 'RBRMX', 'tur.27.22-32': 'TUR2232', 'tur.27.3a': 'TURIIIa',
    'whg.27.89a': 'WHITVIII-IXa'}
SAG_NOTES = {'cod.21.1.osc': 'West Greenland offshore; COD1F-XIV, read, is ICES 14 and NAFO 1F (East and South Greenland)'}

# Stock SMART stocks no RAM stock MQ3-MQ5 read holds (by stock_id), with the RAM stock of the same fish if any
SMART_UNREAD = {
    11997: None, 11998: None, 11999: None, 12003: None, 12005: None, 12007: None, 12011: None, 12013: None, 12215: None,
    12808: 'HOGFISHEGM (deprecated)', 12809: 'HOGFISHSEFL (deprecated)', 14516: None, 15649: None, 11695: None,
    11696: None, 11827: None, 10516: 'RHAKEGOMNGB', 10517: 'RHAKESGBMATL', 11450: None, 10192: 'WINDOWGOMGB',
    11448: None, 11803: None}
SMART_NOTES = {11999: 'GJOBMHI, read, is Hawaii', 14516: 'REYEROCKBSAI and REYEROCKGA, read, are Alaska'}
# read stocks whose species is named differently in RAM, or whose stock definition RAM holds under its later split
SMART_READ_BY_NAME = {
    'walleye pollock - aleutian': 'WPOLLAI', 'walleye pollock - eastern bering': 'WPOLLEBS',
    'walleye pollock - western / central': 'WPOLLGA', 'walleye pollock - bogoslof': 'WPOLLBOGO',
    'arrowtooth flounder - bering': 'ARFLOUNDBSAI', 'arrowtooth flounder - gulf': 'ARFLOUNDGA',
    'arrowtooth flounder - pacific': 'ARFLOUNDPCOAST', 'kamchatka flounder': 'KMFLOUNBSAI', 'white marlin': 'WMARLINATL',
    'aleutian islands blackspotted': 'REYEROCKBSAI', 'bering sea / aleutian islands blackspotted': 'REYEROCKBSAI',
    'gulf of alaska blackspotted': 'REYEROCKGA',
    'black rockfish - northern': 'BLACKROCKWASH, BLACKROCKORECOAST (the 2007 coast-wide stock holds their fish)',
    'black rockfish - southern': 'BLACKROCKORECOAST, BLACKROCKCAL (the 2007 coast-wide stock holds their fish)',
    'longfin inshore squid': 'LISQUIDATLC', 'southern tanner crab': 'TANNERCRABBSAI',
    'witch flounder - northwestern atlantic': 'WITFLOUN5Y', 'albacore - north atlantic': 'ALBANATL',
    'swordfish - north atlantic': 'SWORDNATL',
    'atlantic cod - southern new england': 'CODGB, CODGOM (the 2024 stock structure re-partitions their fish)',
    'atlantic cod - western gulf of maine': 'CODGOM (the 2024 stock structure re-partitions its fish)',
    'atlantic cod - eastern georges bank': 'CODGB'}
STOP = {'and', 'the', 'of', 'coast', 'stock', 'in', 'complex'}


def toks(s):
    return {w for w in re.split(r'[^a-z0-9+]+', (s or '').lower()) if w and w not in STOP}


def ram_stock_table(xlsx):
    import ram_read
    it = ram_read.rows(xlsx, 'stock')
    h = next(it)
    ix = {k: i for i, k in enumerate(h)}
    out = []
    for r in it:
        r = r + [''] * (len(h) - len(r))
        out.append({k: r[ix[k]] for k in ('stockid', 'scientificname', 'commonname', 'stocklong', 'region', 'state')})
    return out


def sag_decisions(sag):
    latest = mq7.sag_latest(sag)
    out = {}
    for k, r in sorted(latest.items()):
        if r['AssessmentYear'] < 2018 or (r.get('ModelType') or 'None') == 'None':
            continue
        if k in SAG_READ:
            d = {'decision': 'read', 'ram': SAG_READ[k]}
        elif k in SAG_SUPERSEDED:
            d = {'decision': 'superseded', 'why': SAG_SUPERSEDED[k]}
        elif k in SAG_OUT:
            d = {'decision': 'out of scope', 'why': SAG_OUT[k]}
        elif k in SAG_UNREAD:
            d = {'decision': 'unread', 'ram': SAG_UNREAD[k] and SAG_UNREAD[k] + ' (unread there)'}
        else:
            raise SystemExit('no decision for ICES stock ' + k)
        if k in SAG_NOTES:
            d['note'] = SAG_NOTES[k]
        d.update(assessment_key=r['AssessmentKey'], assessment_year=r['AssessmentYear'], model_type=r.get('ModelType'),
                 model=r.get('ModelName'), description=r.get('StockDescription'))
        out[k] = d
    return out


def smart_decisions(smart, ram, read):
    A = mq7.smart_assessments(smart)
    by = {}
    for x in ram:
        if 'Pacific Salmon' not in x['region']:
            by.setdefault((x['scientificname'] or '').strip().lower(), []).append(x)
    out = {}
    for (sid, rd), c in sorted(mq7.smart_choice(A).items(), key=str):
        if c['run'] - 1 < mq3.MIN_SP:
            continue
        rec = A[c['assessment']]
        sid = int(sid)
        d = out.setdefault(str(sid), {'stock_name': rec['stock_name'], 'scientific_name': rec['scientific_name'],
                                      'readings': []})
        d['readings'].append(rd)
        if sid in SMART_UNREAD:
            d['decision'] = 'unread'
            d['ram'] = SMART_UNREAD[sid] and SMART_UNREAD[sid] + ' (unread there)'
            if sid in SMART_NOTES:
                d['note'] = SMART_NOTES[sid]
            continue
        name = (rec['stock_name'] or '').lower()
        area = toks(rec['stock_area']) | toks(name.split(' - ', 1)[-1] if ' - ' in name else '')
        best = sorted(((len(area & (toks(x['stocklong']) - toks(x['commonname'])))
                        / max(1, len(area | (toks(x['stocklong']) - toks(x['commonname'])))), x['stockid'])
                       for x in by.get((rec['scientific_name'] or '').strip().lower(), []) if x['stockid'] in read),
                      reverse=True)
        named = next((v for k, v in SMART_READ_BY_NAME.items() if name.startswith(k)), None)
        ram_id = named or (best[0][1] if best else None)
        if ram_id is None:
            raise SystemExit('no decision for Stock SMART stock %s %s' % (sid, rec['stock_name']))
        d['decision'] = 'read'
        d['ram'] = ram_id
    return out


def main(smart, sag, xlsx):
    read = {r['stockid'] for r in mq7.ram_read_stocks(xlsx)}
    out = {'scope': 'metadata only: names, species, areas and model types of the test sources against the RAM Legacy '
                    'stocks MQ3-MQ5 read; no value of either source was read',
           'rule': __doc__.split('\n\n')[1].strip(),
           'ICES SAG': sag_decisions(sag), 'Stock SMART': smart_decisions(smart, ram_stock_table(xlsx), read)}
    os.makedirs(mq7.OUT, exist_ok=True)
    with open(os.path.join(mq7.OUT, 'matching.json'), 'w') as f:
        json.dump(out, f, indent=1)
    from collections import Counter
    for src in ('ICES SAG', 'Stock SMART'):
        print(src, dict(Counter(v['decision'] for v in out[src].values())))


if __name__ == '__main__':
    if len(sys.argv) != 4:
        raise SystemExit(__doc__)
    main(*sys.argv[1:])
