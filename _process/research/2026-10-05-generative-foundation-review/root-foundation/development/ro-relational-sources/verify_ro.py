#!/usr/bin/env python3
"""Check the map of the Chinese sources onto the spine (board item RO). usage, from anywhere:
  python3 -B verify_ro.py [--receipt PATH] [--chapter PATH]   # check, exit 1 on any failure
  python3 -B verify_ro.py --table                             # print the passage tables, as the data now gives them
  python3 -B verify_ro.py --excerpt                           # rebuild atlas-excerpt.json from the packages

Checks, each against the repository's own files:
  1. every file preserved in sources/chinese-classical-texts/ has the SHA-256 its PROVENANCE.json
     binds, and every file there is bound;
  2. every fragment of passages.json occurs verbatim in the preserved text it names (a Wikisource
     page is read with its markup removed, as in the Y1 check);
  3. every atlas id a passage cites is in atlas-excerpt.json, whose entries are read from the two
     atlases' archives at the SHA-256 the provenance binds; where the archives are present in the
     external store the provenance names, the excerpt is rebuilt from them and must agree;
  4. every declaration a passage names is in the audited declaration list of a core receipt
     (default: the newest under becoming-checks/), or, for a module of this kit not yet landed, in
     its source, reported as such;
  5. every record a passage names exists, and no passage id repeats one of the Y1 passage map;
  6. the chapter (06-CLASSICAL-TEXTS, its section 六) gives, in its table of counts, for each part and in all, the
     numbers of passages and of each kind that passages.json gives, and says the total in its assessment; a missing
     chapter, section or row, or a row twice, is a failure. The section's other numbers are not checked. The passage tables were
     checked against the chapter of the map until RA moved it to history/ (23 October 2026); that chapter is frozen
     there and not checked, and --table prints the tables as the data now gives them;
  7. where the archives are present, passages.json is what build_passages.py builds from the mappers'
     entries and its FIXES (build_passages.py --check), so no edit was made in place.
It checks text and names, not the proofs: the core checker proves the declarations."""
import argparse
import hashlib
import html
import json
import re
import subprocess
import sys
import zipfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
SRC = ROOT / 'sources/chinese-classical-texts'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RECORDS = ROOT / 'theories/becoming/results/records'
CHAPTER = ROOT / 'theories/becoming/chapters/06-CLASSICAL-TEXTS.md'
SECTION = '<a id="nine-traditions"></a>'
# The chapter's name for each part, in the row of its table of counts.
ROW = {'易传': '易传（卦之诸节以外）', '老子': '老子（经与王弼、河上公、苏辙注，郭店与帛书之释文）', '儒家': '儒家',
       '文字': '文字', '庄子与玄学': '庄子与玄学', '墨家与名家': '墨家与名家', '兵家、法家与轻重纵横': '兵家、法家、管子与纵横',
       '佛教': '汉传佛教', '其他': '其他', None: '合计'}
Y1 = HERE.parent / 'y1-changes/passages.json'
KIND_ZH = {'agreement': '相合', 'scope': '定域', 'divergence': '相分'}
TRADITIONS = ['易传', '老子', '庄子与玄学', '儒家', '文字', '墨家与名家', '兵家、法家与轻重纵横', '佛教', '其他']


def begin(tradition):
    return f'<!-- passage-map:{tradition}:begin -->'


def end(tradition):
    return f'<!-- passage-map:{tradition}:end -->'


def clean(text):
    """Wikitext with its markup removed: character-variant markup, links (their shown text),
    the text templates of the 說文 and 禮記正義 pages ({{yw|…}} and {{+|…}}: their content),
    variant readings (the first), other templates and tags; character references are decoded."""
    text = html.unescape(text)
    text = re.sub(r'\{\{(?:yw|\+)\|([^{}]*)\}\}', r'\1', text)
    text = re.sub(r'-\{(?:[A-Za-z]\|)?|\}-', '', text)
    text = re.sub(r'\[\[(?:[^\]|]*\|)?([^\]]*)\]\]', r'\1', text)
    text = re.sub(r'\{\{另\|([^|}]*)\|[^}]*\}\}', r'\1', text)
    text = re.sub(r'\{\{[^{}]*\}\}', '', text)
    return re.sub(r'<[^>]+>', '', text)


def read_text(rel):
    """The text of a preserved file: a .txt as stored; a Wikisource page object or API response
    as its wikitext with the markup removed."""
    path = SRC / rel
    if path.suffix == '.txt':
        return path.read_text()
    data = json.loads(path.read_text())
    page = data['query']['pages'][0] if 'query' in data else data
    return clean(page['revisions'][0]['slots']['main']['content'])


def lean_declarations(text):
    names, stack = set(), []
    for line in text.splitlines():
        m = re.match(r'namespace\s+(\S+)', line)
        if m:
            stack.append(m.group(1))
            continue
        m = re.match(r'end\s+(\S+)', line)
        if m and stack and stack[-1] == m.group(1):
            stack.pop()
            continue
        m = re.match(r'(?:@\[[^\]]*\]\s*)?(?:protected\s+|private\s+|noncomputable\s+)*'
                     r'(theorem|def|structure|inductive|abbrev|instance|lemma)\s+([^\s:({\[]+)', line)
        if m:
            names.add('.'.join(stack + [m.group(2)]))
    return names


# Law level (R35, G12): computed from the declarations a passage cites, never stored in passages.json.
ENCODING = 'Hexagram'  # the hexagram encoding: Becoming.Hexagram lemmas about Fin 64, tables, decide
LEVEL_ZH = {'general': '一般律', 'encoding': '编码', 'mixed': '兼有', None: '—'}


def law_level(p):
    """'encoding' where every cited declaration is in namespace Becoming.Hexagram, 'general' where none is, 'mixed'
    where both occur; None for a passage citing no declaration."""
    names = [d.removeprefix('Becoming.') for d in p.get('declarations', [])]
    if not names:
        return None
    enc = [n.split('.')[0] == ENCODING for n in names]
    return 'encoding' if all(enc) else 'mixed' if any(enc) else 'general'


def level_split(passages, kinds):
    """{kind: {level: count}} for the summary line."""
    out = {k: {} for k in kinds}
    for p in passages:
        lv = law_level(p)
        out[p['kind']][lv] = out[p['kind']].get(lv, 0) + 1
    return out


def level_line(passages, kinds):
    names = {'general': 'general laws', 'encoding': 'the encoding only', 'mixed': 'both', None: 'no declaration'}
    split = level_split(passages, kinds)
    return 'by law level: ' + '; '.join(
        f"{k} {sum(v.values())} (" + ', '.join(f'{v[lv]} through {names[lv]}' for lv in ('general', 'encoding', 'mixed', None) if v.get(lv)) + ')'
        for k, v in split.items())


def table(passages, tradition):
    rows = ['| 原文 | 出处 | 关系 | 律的层次 | 脊柱上的声明与记录 | 读法（AI） |', '|---|---|---|---|---|---|']
    for p in passages:
        if p['tradition'] != tradition:
            continue
        text = '……'.join(f'「{f}」' for f in p['fragments'])
        decls = '<br>'.join(f"`{d.removeprefix('Becoming.')}`" for d in p['declarations'])
        recs = '<br>'.join(f"[{r}](../results/records/{r}.md)" for r in p.get('records', []))
        cell = decls + ('<br>' if decls and recs else '') + recs
        rows.append(f"| <a id=\"p-{p['id']}\"></a>{text} | {p['locator']} | {KIND_ZH[p['kind']]} | {LEVEL_ZH[law_level(p)]} | {cell} | {p['reading']} |")
    return '\n'.join(rows)


def excerpt_from_packages(prov):
    """The cited atlas records, read from the two packages (zip archives in the external store the
    provenance names, each checked against its SHA-256); None where an archive is absent."""
    out = {}
    for atlas in prov['atlases']:
        path = Path(atlas['zip_path'])
        if not path.exists():
            return None
        if hashlib.sha256(path.read_bytes()).hexdigest() != atlas['zip_sha256']:
            raise SystemExit(f"{atlas['id']}: the archive differs from the bound SHA-256")
        with zipfile.ZipFile(path) as zf:
            def read(name, zf=zf, prefix=atlas['prefix']):
                return zf.read(prefix + name).decode()
            out[atlas['id']] = load_atlas(atlas['id'], read)
    return out


def load_atlas(atlas_id, read):
    """Every record of an atlas that an id can cite: id -> (kind, evidence quotes)."""
    records = {}

    def quotes(r):
        out = [x['quote'] for x in r.get('evidence', []) if isinstance(x, dict) and x.get('quote')]
        return out + ([r['quote']] if isinstance(r.get('quote'), str) and r['quote'] else [])
    if atlas_id == 'yidao-v1.3':
        model = json.loads(read('data/model.json'))
        for kind, value in model.items():
            if isinstance(value, list):
                for r in value:
                    if isinstance(r, dict) and isinstance(r.get('id'), str):
                        records[r['id']] = (kind, quotes(r))
    else:
        def jl(name):
            return [json.loads(line) for line in read('data/' + name).splitlines() if line.strip()]
        for c in jl('concepts.jsonl'):
            for s in c['senses']:
                records[s['sense_id']] = ('sense', quotes(s))
        for name in ('expressions.jsonl', 'knowledge_nodes.jsonl', 'knowledge_relations.jsonl',
                     'comparisons.jsonl', 'relations.jsonl'):
            for r in jl(name):
                if isinstance(r.get('id'), str):
                    records.setdefault(r['id'], (name.split('.')[0], quotes(r)))
    return records


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--receipt', type=Path)
    ap.add_argument('--chapter', type=Path, default=CHAPTER)
    ap.add_argument('--table', action='store_true')
    ap.add_argument('--excerpt', action='store_true')
    args = ap.parse_args()
    data = json.loads((HERE / 'passages.json').read_text())
    passages = data['passages']
    if args.table:
        for t in TRADITIONS:
            if any(p['tradition'] == t for p in passages):
                print(f'### {t}\n\n{begin(t)}\n{table(passages, t)}\n{end(t)}\n')
        return 0
    prov = json.loads((SRC / 'PROVENANCE.json').read_text())
    cited = {(a['atlas'], a['id']) for p in passages for a in p.get('atlas_ids', [])}
    if args.excerpt:
        full = excerpt_from_packages(prov)
        if full is None:
            raise SystemExit('a package named in the provenance is not present')
        excerpt = {'about': 'The atlas records the passage map cites, read from the packages the '
                            'provenance binds (verify_ro.py --excerpt). quotes: the record\'s evidence quotes.',
                   'records': {f'{a}:{i}': {'kind': full[a][i][0], 'quotes': full[a][i][1]}
                               for a, i in sorted(cited) if i in full.get(a, {})}}
        (HERE / 'atlas-excerpt.json').write_text(json.dumps(excerpt, ensure_ascii=False, indent=1) + '\n')
        missing = sorted(f'{a}:{i}' for a, i in cited if i not in full.get(a, {}))
        print(f"{len(excerpt['records'])} records written" + (f'; not in the atlases: {missing}' if missing else ''))
        return 1 if missing else 0

    failures = []
    # 1. preserved files
    bound = {}
    for f in prov['files']:
        path = SRC / f['file']
        if not path.exists():
            failures.append(f"missing preserved file: {f['file']}")
            continue
        if hashlib.sha256(path.read_bytes()).hexdigest() != f['sha256']:
            failures.append(f"bytes changed: {f['file']}")
        bound[f['file']] = f
    for path in SRC.rglob('*'):
        rel = path.relative_to(SRC).as_posix()
        if path.is_file() and rel not in bound and rel not in ('README.md', 'PROVENANCE.json'):
            failures.append(f'file not bound by the provenance: {rel}')

    # 2. fragments verbatim
    ids = set()
    y1 = {p['id'] for p in json.loads(Y1.read_text())['passages']} if Y1.exists() else set()
    for p in passages:
        if p['id'] in ids or p['id'] in y1:
            failures.append(f"passage id repeated: {p['id']}")
        ids.add(p['id'])
        if p['tradition'] not in TRADITIONS:
            failures.append(f"{p['id']}: tradition not listed: {p['tradition']}")
        if p['source'] not in bound:
            failures.append(f"{p['id']}: source not bound by the provenance: {p['source']}")
            continue
        text = read_text(p['source'])
        for frag in p['fragments']:
            if frag not in text:
                failures.append(f"{p['id']}: not verbatim in {p['source']}: {frag}")
        if p['kind'] not in KIND_ZH or not (p['declarations'] or p.get('records')):
            failures.append(f"{p['id']}: kind, or declarations and records, missing")

    # 3. atlas ids
    excerpt = json.loads((HERE / 'atlas-excerpt.json').read_text())['records']
    for a, i in sorted(cited):
        if f'{a}:{i}' not in excerpt:
            failures.append(f'atlas id not in the excerpt: {a}:{i}')
    full = excerpt_from_packages(prov)
    rebuilt = 'packages absent: excerpt not rebuilt'
    if full is not None:
        for key, rec in excerpt.items():
            a, i = key.split(':', 1)
            if i not in full.get(a, {}) or full[a][i][1] != rec['quotes']:
                failures.append(f'excerpt differs from the package: {key}')
        rebuilt = 'excerpt rebuilt from the packages and agrees'

    # 4. declarations
    checks = PKG / 'becoming-checks'
    receipt = args.receipt or max(checks.glob('*/verification.json'))
    audited = {d['name'] for m in json.loads(receipt.read_text())['modules'] for d in m['declarations']}
    kit_sources = set()
    for path in (HERE / 'Becoming').glob('*.lean') if (HERE / 'Becoming').exists() else []:
        landed = PKG / 'Becoming' / path.name
        kit_sources |= lean_declarations((landed if landed.exists() else path).read_text())
    by_source = set()
    for p in passages:
        for d in p['declarations']:
            if d in audited:
                continue
            if d in kit_sources:
                by_source.add(d)
            else:
                failures.append(f"{p['id']}: no such audited declaration: {d}")

    # 5. records
    for p in passages:
        for r in p.get('records', []):
            if not (RECORDS / f'{r}.json').exists():
                failures.append(f"{p['id']}: no such record: {r}")

    # 6. the chapter's table of counts
    n_rows = 0
    if not args.chapter.exists():
        failures.append(f'no chapter at {args.chapter}')
    elif SECTION not in args.chapter.read_text():
        failures.append(f'{args.chapter.name}: no section {SECTION}')
    else:
        text = args.chapter.read_text()
        section = text[text.index(SECTION):]
        nxt = section.find('\n## ', section.find('\n## ') + 1)   # the section ends at the next heading of its level
        section = section if nxt < 0 else section[:nxt]
        rows = {}
        for line in section.splitlines():
            cells = [c.strip() for c in line.strip().strip('|').split('|')]
            if len(cells) == 5 and all(c.isdigit() for c in cells[1:]):
                if cells[0] in rows:
                    failures.append(f'{args.chapter.name}: row {cells[0]} appears twice in the table of counts')
                rows[cells[0]] = tuple(map(int, cells[1:]))
        for t in TRADITIONS + [None]:
            mine = [p for p in passages if t is None or p['tradition'] == t]
            want = (len(mine),) + tuple(sum(p['kind'] == k for p in mine) for k in KIND_ZH)
            if ROW[t] not in rows:
                failures.append(f'{args.chapter.name}: no row {ROW[t]} in the table of counts')
            elif rows[ROW[t]] != want:
                failures.append(f'{args.chapter.name}: row {ROW[t]} says {rows[ROW[t]]}, passages.json gives {want}')
            else:
                n_rows += 1
        if f'的 {len(passages)} 段文字' not in section:
            failures.append(f'{args.chapter.name}: the section does not say {len(passages)} passages')

    # 7. the map is the build: passages.json changes only through build_passages.py's FIXES
    if full is not None:
        build = subprocess.run([sys.executable, '-B', str(HERE / 'build_passages.py'), '--check'],
                               capture_output=True, text=True)
        if build.returncode:
            failures += ([x[len('PROBLEM '):] for x in build.stdout.splitlines() if x.startswith('PROBLEM ')]
                         or [f'build_passages.py --check failed: {build.stderr.strip()[-300:]}'])
        rebuilt += '; passages.json is the build'

    kinds = {k: sum(p['kind'] == k for p in passages) for k in KIND_ZH}
    per = {t: sum(p['tradition'] == t for p in passages) for t in TRADITIONS}
    decls = {d for p in passages for d in p['declarations']}
    recs = {r for p in passages for r in p.get('records', [])}
    print(f"{len(passages)} passages ({kinds['agreement']} agreement, {kinds['scope']} scope, "
          f"{kinds['divergence']} divergence), {sum(len(p['fragments']) for p in passages)} fragments in "
          f"{len(bound)} files bound, {len(decls)} declarations, {len(recs)} records, {len(cited)} atlas ids; "
          f"receipt {receipt.parent.name}; {rebuilt}"
          + (f'; {len(by_source)} names checked against the kit modules, not yet in the receipt' if by_source else ''))
    print('by tradition: ' + ', '.join(f'{t} {n}' for t, n in per.items() if n))
    print(f'chapter {args.chapter.name}: {n_rows} of {len(TRADITIONS) + 1} rows of its table of counts agree')
    print(level_line(passages, KIND_ZH))
    for f in failures:
        print('FAIL', f)
    return 1 if failures else 0


if __name__ == '__main__':
    sys.exit(main())
