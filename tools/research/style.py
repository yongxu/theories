"""Readability lint and growth ratchet for canonical result records.

Reports, never rewrites. The lint judges form only (length, process narration,
boilerplate written out instead of a shared key); whether a boundary is
substantive stays the author's reading.

Severity:
- schema 1: every finding is a warning, except on the optional `statement`, which
  is checked as strictly as in schema 2;
- schema 2: hard caps on title, statement, validation_scope and next_delta, process
  markers in public fields and round accretion are errors; everything else warns;
- README `overview` fields: always warnings.

The ratchet (`growth`) stops a changed schema-1 record from lengthening its
boundary, evidence or correspondence text until it is migrated to schema 2.
"""
from __future__ import annotations
from collections import Counter
import re

# Per-language caps: (en chars, zh chars). zh/en length ratio in current records:
# median 0.36, p95 0.50, so zh caps are about half the English cap.
STATEMENT_CAP = (300, 150)
CAPS_V1 = {'title': (120, 60), 'claim': (1500, 700), 'limitations': (800, 350),
           'validation_scope': (800, 350), 'correspondence': (1200, 500), 'next_delta': (400, 180)}
CAPS_V2 = {'title': (100, 40), 'statement': STATEMENT_CAP, 'claim': (1500, 700),
           'validation_scope': (600, 260), 'correspondence': (1200, 500), 'next_delta': (400, 180)}
# Hard caps only on the reading surface; elsewhere a cap warns, so it never forces a substantive boundary out.
HARD_CAPS = {'title', 'statement', 'validation_scope', 'next_delta'}
# (en cap, zh cap, maximum number of items)
ITEM_CAPS_V2 = {'does_not_show': (240, 110, 8), 'not_required': (200, 90, 6), 'progress': (240, 110, 16),
                'laws': (420, 190, 40), 'hypotheses': (420, 190, 9)}
LIST_FIELDS = ('does_not_show', 'not_required', 'progress', 'laws', 'hypotheses')

PROCESS = [
    ('receipt-timestamp', re.compile(r'\b\d{8}T\d{6}(?:\.\d+)?Z\b')),
    ('round-number', re.compile(r'(?<![A-Za-z0-9_.])P\d{2,3}[a-z]?(?![A-Za-z0-9_])')),
    ('section-reference', re.compile(r'\bSections? \d+|§+\s?\d+|第\s?\d+\s?节')),
    ('date', re.compile(r'\b20\d\d-\d\d-\d\d\b')),
    ('round-narration', re.compile(r'\b(?:this|the present|each) (?:round|session)\b|\bthis record (?:adds|registers|receives|records)\b|\bhas landed\b|\bCodex\b|本轮|本次|已落地', re.I)),
    ('session-id', re.compile(r'\[[0-9a-f]{6}\]')),
]
ROUND = re.compile(r'P\d{2,3}[a-z]?|Sections? \d+|§+\s?\d+|第\s?\d+\s?节')
EVIDENCE = re.compile(r'\bno new (?:theorem|Lean|empirical|experiment|independent|mathemat)|\bnot recounted\b|'
                      r'\bno (?:new )?independent (?:acceptance|review)\b|无新|新增[^。；]{0,12}为零|不重计|无新增', re.I)
STATUS = re.compile(r'\bremains? (?:open|unproved|unestablished)|\b(?:is|are) (?:unproved|unestablished)\b|'
                    r'\bnot (?:yet )?(?:established|derived)\b|仍(?:开放|未)|尚未|未完成', re.I)
NEGATIVE_EN = re.compile(r"\b(?:not|no|nor|neither|without|cannot|does not|do not|never)\b|n't\b|\bremains? open\b", re.I)

# Boilerplate that recurs across records and belongs in standard_boundaries (keys of the shared file).
STOCK = {
    'discrete-steps': re.compile(r'[Ss]tated for discrete steps|discrete steps'),
    'decidability': re.compile(r'needs? (?:the determination )?decid\w+ \(a logical commitment\)|decidability \(a logical commitment\)'),
    'pointwise-properties': re.compile(r'in place of function extensionality'),
    'no-evaluation': re.compile(r'[Ee]valuates neither|[Cc]ontains no ethical predicate'),
    'names-provisional': re.compile(r"names? (?:are|is) (?:the AI['’]s choice|Ren['’]s to choose)|readings? (?:remain|are) Ren['’]s"),
    'no-ethical-premise': re.compile(r'[Nn]o ethical premise and no Lean axiom'),
    'zero-axiom-target-open': re.compile(r'zero-substantive-axiom (?:grounding|normative warrant|foundation)'),
    'omission-not-refutation': re.compile(r'omission in a weaker description does not|is no counterexample to fuller'),
    'conditional-not-universal': re.compile(r'[Cc]onditional laws do not make their antecedents universal'),
}
STOCK_FIELDS = ('claim', 'statement', 'limitations', 'does_not_show')
# A cross-reference repeated as prose; better as a typed link (related).
RESTATEMENT = re.compile(r'exact restatement for every world is')

# Words of exchange. Ren on a name (6 October): “这个词选的很诡异，太市场了，不够基本”. A
# structural word says what a relation does; a market word reads it as a transaction. Warned on
# schema-2 public fields; a record whose subject is an exchange keeps its words. The spine's
# declaration names are checked with the same list in check_becoming.py (MARKET_WORDS).
MARKET_EN = re.compile(r"\b(?:cost(?:s|ly|ing)?|charg(?:e|es|ed|ing)|budget(?:s|ed)?|pay(?:s|ing|ment|ments)?|paid|"
                       r"pric(?:e|es|ed|ing)|spend(?:s|ing)?|spent|accounting|credit(?:s|ed|ing)?|fees?|"
                       r"profit(?:s|able)?|fund(?:s|ed|ing)?)\b", re.I)
# “account” is left out: here it means an explanation (“the full account”).
MARKET_ZH = re.compile(r'付费|支付|预算|(?<![生形构组完达变造促合养现落集])成本|价格|花费|费用|利润|资金|记账|账户|收费|开销|代价|免费|信用')
# Scientific terms that contain such a word.
MARKET_ALLOWED = re.compile(r"Price(?:['’]s)? equation|credit assignment|electric charge", re.I)

# Public statement of the result: process narration is never acceptable here.
PUBLIC_FIELDS = ('title', 'statement', 'claim', 'overview.', 'does_not_show', 'not_required', 'laws', 'next_delta',
                 'limitations', 'counterexamples', 'progress')
# Fields whose growth the ratchet blocks on a changed schema-1 record.
GROWTH_FIELDS = ('limitations', 'validation_scope', 'correspondence')
# Growth up to this many characters per language (en, zh) only warns: renamed
# identifiers and wording fixes lengthen a field slightly; an appended boundary
# sentence does not fit in it.
GROWTH_TOLERANCE = (40, 20)


def sentences(text, lang):
    if lang == 'zh':
        parts = re.split(r'(?<=[。；！？])', text)
    else:
        parts = re.split(r'(?<=[.;!?])\s+(?=[A-Z(“"`\[])', text)
    return [p.strip() for p in parts if p.strip()]


def text(value, lang):
    return value.get(lang, '') if isinstance(value, dict) and isinstance(value.get(lang), str) else ''


def text_fields(r):
    """(field label, language, text) for every public or evidence text in a record."""
    for key in ('title', 'statement', 'claim', 'limitations', 'correspondence', 'validation_scope', 'next_delta'):
        value = r.get(key)
        if isinstance(value, dict):
            for lang in ('en', 'zh'):
                yield key, lang, text(value, lang)
    for key in LIST_FIELDS:
        items = r.get(key)
        for i, item in enumerate(items if isinstance(items, list) else []):
            if isinstance(item, dict):
                for lang in ('en', 'zh'):
                    yield f'{key}[{i}]', lang, text(item, lang)
    items = r.get('counterexamples')
    for i, c in enumerate(items if isinstance(items, list) else []):
        if isinstance(c, dict) and isinstance(c.get('detail'), dict):
            for lang in ('en', 'zh'):
                yield f'counterexamples[{i}]', lang, text(c['detail'], lang)
    overview = r.get('overview') if isinstance(r.get('overview'), dict) else {}
    for key in ('title', 'summary', 'evidence'):
        if isinstance(overview.get(key), dict):
            for lang in ('en', 'zh'):
                yield f'overview.{key}', lang, text(overview[key], lang)


def lint(r):
    """Return findings: dicts with id, field, rule, severity and detail."""
    out = []
    v2 = r.get('schema_version') == 2
    ident = r.get('id', '<missing>')

    def add(field, rule, detail, hard=False):
        error = hard and not field.startswith('overview.') and (v2 or field.split('[')[0] == 'statement')
        out.append({'id': ident, 'field': field, 'rule': rule, 'severity': 'error' if error else 'warning', 'detail': detail})

    caps = CAPS_V2 if v2 else {**CAPS_V1, 'statement': STATEMENT_CAP}
    for key, (en_cap, zh_cap) in caps.items():
        value = r.get(key)
        if isinstance(value, dict):
            for lang, cap in (('en', en_cap), ('zh', zh_cap)):
                n = len(text(value, lang))
                if n > cap:
                    add(key, 'length', f'{lang} {n} chars > {cap}', hard=key in HARD_CAPS)
    if v2:
        for key, (en_cap, zh_cap, max_items) in ITEM_CAPS_V2.items():
            items = r.get(key) if isinstance(r.get(key), list) else []
            if len(items) > max_items:
                add(key, 'item-count', f'{len(items)} items > {max_items}')
            for i, item in enumerate(items):
                if not isinstance(item, dict):
                    continue
                for lang, cap in (('en', en_cap), ('zh', zh_cap)):
                    n = len(text(item, lang))
                    if n > cap:
                        add(f'{key}[{i}]', 'length', f'{lang} {n} chars > {cap}')
                if key in ('does_not_show', 'not_required') and len(sentences(text(item, 'en'), 'en')) > 2:
                    add(f'{key}[{i}]', 'one-sentence', 'item has more than two sentences')

    markers_by_field = {}
    for field, lang, body in text_fields(r):
        base = field.split('[')[0]
        public = field.startswith(PUBLIC_FIELDS)
        for rule, pattern in PROCESS:
            hits = sorted(set(pattern.findall(body)))
            if hits:
                markers_by_field.setdefault(field, set()).update(hits)
                if public:
                    add(field, 'process-marker:' + rule, f'{lang}: ' + ', '.join(map(str, hits[:5])), hard=True)
        if v2 and public and not field.startswith('overview.'):
            words = (MARKET_ZH if lang == 'zh' else MARKET_EN).findall(MARKET_ALLOWED.sub('', body))
            if words:
                add(field, 'market-word', f'{lang}: ' + ', '.join(sorted(set(words))[:5]) + '; name what the relation does')
        if base in ('claim', 'statement', 'limitations', 'does_not_show', 'next_delta') and EVIDENCE.search(body):
            add(field, 'evidence-in-claim', f'{lang}: evidence disclaimer belongs in validation_scope')
        if lang != 'en':
            continue
        if RESTATEMENT.search(body):
            add(field, 'prose-cross-reference', 'state the restatement as a typed related link')
        if base in ('limitations', 'does_not_show'):
            n = sum(bool(STATUS.search(s)) for s in sentences(body, 'en'))
            if n:
                add(field, 'status-restatement', f'{n} sentence(s) restate open/unproved status')
        if base in STOCK_FIELDS:
            for key, pattern in STOCK.items():
                if pattern.search(body):
                    add(field, 'stock-boundary', f'use standard_boundaries key "{key}"')
        if field == 'statement' and body:
            lead_text = re.sub(r'^(?:Target|Open target|Candidate):\s*', '', body)
            # Mathematical negation is often the content of a theorem ("never returns"), so
            # claims are not checked; only the short statement must lead positively.
            ss = sentences(lead_text, 'en')
            neg = sum(bool(NEGATIVE_EN.search(s)) for s in ss)
            lead = re.split(r'[;:]| — ', ss[0])[0] if ss else ''
            # "makes no difference to" is the relation a theorem states (which differences make a difference), not a
            # negation to lead away from (13 November 2026, after the dig into what brings a doer back into a statement)
            if (lead and NEGATIVE_EN.search(lead) and not re.search(r'\b(?:exactly|only|iff)\b', lead)
                    and not re.search(r'\bma(?:kes?|de|king) no difference\b', lead, re.I)):
                add(field, 'negation-lead', f'{neg}/{len(ss)} sentences are negations; lead with what holds')
    for field, hits in markers_by_field.items():
        rounds = {h for h in hits if ROUND.fullmatch(str(h))}
        if len(rounds) >= 3:
            add(field, 'round-accretion', f'{len(rounds)} rounds/sections cited: per-round notes belong in history/progress', hard=True)
    title = text(r.get('title'), 'en')
    if not v2 and (len(title) > 120 or re.search(r':\s.{60,}', title)):
        add('title', 'title-is-statement', 'split into a short title and a statement')
    return out


def growth(old, new, fields=GROWTH_FIELDS):
    """Ratchet for the migration window: a changed schema-1 record may not lengthen these fields."""
    if new.get('schema_version') == 2:
        return []
    ident = new.get('id')
    if old.get('schema_version') == 2:
        return [{'id': ident, 'field': 'schema_version', 'rule': 'schema-downgrade', 'severity': 'error',
                 'detail': 'a schema-2 record may not return to schema 1'}]
    found = []
    for key in fields:
        for lang, tolerance in zip(('en', 'zh'), GROWTH_TOLERANCE):
            before, after = len(text(old.get(key), lang)), len(text(new.get(key), lang))
            if after > before:
                severity = 'error' if after - before > tolerance else 'warning'
                found.append({'id': ident, 'field': key, 'rule': 'v1-growth', 'severity': severity,
                              'detail': f'{lang} grew {before} -> {after} chars; migrate the record to schema 2 before adding text here'})
    return found


def summary(findings):
    """Counts for a check report; the full list comes from `research.py lint`."""
    return {'findings': len(findings), 'records': len({f['id'] for f in findings}),
            'by_severity': dict(sorted(Counter(f['severity'] for f in findings).items())),
            'by_rule': dict(Counter(f['rule'] for f in findings).most_common())}
