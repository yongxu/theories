"""Import 《中华思想脉络》 v1.0 into sources/, byte for byte, bound by SHA-256 (board item ZH).

The release archive stays outside the repository; this script reads it (as data, never running
anything in it) and copies into sources/civilization-thought-v1.0/:

- the project's own documents (README, LICENSES, PROJECT_MAP, manifest, docs/*); its AGENTS.md
  enters as MAINTENANCE-AGENTS.md, bytes unchanged, so that no agent reads it as instructions
  for this repository;
- the canonical model data/model.json;
- every frozen text a source record of the model names (text_path), which is what the model's
  quotations are checked against;
- for each CBETA source, the <teiHeader> of its raw TEI file as an exact byte span, so that the
  rights and edition statement CBETA asks to keep travels with the text.

PROVENANCE.json binds every file. `--check` re-hashes the files (no archive needed) and, with
--zip, also re-reads each archive member and compares.

    python3 -I import_civilization.py --zip ARCHIVE --repo REPO [--check]
"""
import argparse
import hashlib
import json
import os
import re
import sys
import zipfile

ARCHIVE_SHA256 = '154592f818e1aa6cd22342f6b6fa92ad64b8a1fe07f14f817fcd5bbe19a5a3fe'
MODEL_SHA256 = '0a8ab02d0b15f9dcfd143f11ad636a0d7b65a89ed296154fc3a0410368f06b36'
PREFIX = 'civilization-thought-v1.0/'
DEST = 'sources/civilization-thought-v1.0'
DOCS = ['README.md', 'LICENSES.md', 'PROJECT_MAP.json', 'manifest.json',
        'docs/本轮覆盖.md', 'docs/数据与关系.md', 'docs/研究包格式.md', 'data/model.json']
RENAMED = {'AGENTS.md': 'MAINTENANCE-AGENTS.md'}


def sha(b):
    return hashlib.sha256(b).hexdigest()


def plan(z):
    """(repo-relative path, bytes, provenance entry) for every file to import."""
    model_bytes = z.read(PREFIX + 'data/model.json')
    if sha(model_bytes) != MODEL_SHA256:
        sys.exit('model sha256 differs from the release record')
    model = json.loads(model_bytes)
    out = []
    for rel in DOCS:
        b = z.read(PREFIX + rel)
        out.append((rel, b, {'form': 'archive-member', 'archive_member': PREFIX + rel}))
    for src, dst in RENAMED.items():
        b = z.read(PREFIX + src)
        out.append((dst, b, {'form': 'archive-member, renamed', 'archive_member': PREFIX + src,
                             'note': 'the project\'s maintenance conventions; renamed so that no agent reads them as instructions for this repository'}))
    seen = set()
    for s in model['sources']:
        tp = s.get('text_path')
        if not tp or tp in seen:
            continue
        seen.add(tp)
        b = z.read(PREFIX + tp)
        out.append((tp, b, {'form': 'archive-member', 'archive_member': PREFIX + tp, 'source_id': s['id'],
                            'title': s.get('title'), 'url': s.get('url')}))
        raw = s.get('raw_path')
        if raw and 'cbeta' in (s.get('url') or '').lower():
            rb = z.read(PREFIX + raw)
            m = re.search(rb'<teiHeader[\s>].*?</teiHeader>', rb, re.S)
            if m:
                rel = 'evidence/tei-headers/%s.teiHeader.xml' % s['id']
                out.append((rel, m.group(0), {'form': 'byte span of an archive member', 'archive_member': PREFIX + raw,
                                              'span': [m.start(), m.end()], 'member_sha256': sha(rb), 'source_id': s['id'],
                                              'note': 'the CBETA rights and edition statement of the raw TEI file, kept with the text'}))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--zip')
    ap.add_argument('--repo', required=True)
    ap.add_argument('--check', action='store_true')
    a = ap.parse_args()
    dest = os.path.join(a.repo, DEST)
    prov_path = os.path.join(dest, 'PROVENANCE.json')
    if a.check:
        prov = json.load(open(prov_path, encoding='utf-8'))
        bad = [f['file'] for f in prov['files'] if sha(open(os.path.join(dest, f['file']), 'rb').read()) != f['sha256']]
        if a.zip and os.path.exists(a.zip):
            z = zipfile.ZipFile(a.zip)
            for f in prov['files']:
                b = z.read(f['archive_member'])
                if 'span' in f:
                    b = b[f['span'][0]:f['span'][1]]
                if sha(b) != f['sha256']:
                    bad.append(f['file'] + ' (archive)')
        print('%d files, %d differ' % (len(prov['files']), len(bad)))
        for x in bad[:20]:
            print('  differs:', x)
        sys.exit(1 if bad else 0)
    zb = open(a.zip, 'rb').read()
    if sha(zb) != ARCHIVE_SHA256:
        sys.exit('archive sha256 differs')
    z = zipfile.ZipFile(a.zip)
    files = []
    for rel, b, entry in plan(z):
        p = os.path.realpath(os.path.join(dest, rel))
        assert p.startswith(os.path.realpath(dest) + os.sep)
        os.makedirs(os.path.dirname(p), exist_ok=True)
        open(p, 'wb').write(b)
        files.append({'file': rel, 'sha256': sha(b), 'bytes': len(b), **entry})
    prov = {
        'about': '《中华思想脉络》 v1.0 (a research project built with Codex at Ren\'s direction), imported for board item ZH. '
                 'Every file is an archive member byte for byte, one renamed and the CBETA TEI headers as exact byte spans; '
                 'import_civilization.py --check re-hashes them.',
        'archive': {'path': os.path.abspath(a.zip), 'sha256': ARCHIVE_SHA256, 'bytes': len(zb), 'members': len(z.infolist()),
                    'kept_outside': 'the web page, derived graphs and indexes, the SQLite index, raw responses, lineage snapshots, audits and tools'},
        'model_sha256': MODEL_SHA256,
        'files': files,
    }
    open(prov_path, 'w', encoding='utf-8').write(json.dumps(prov, ensure_ascii=False, indent=1) + '\n')
    print('%d files, %d bytes' % (len(files), sum(f['bytes'] for f in files)))


main()
