"""Import 文理生生 into sources/, byte for byte, bound by SHA-256 (board item WL).

The release archive 26_文理生生关系图谱_v2.2.zip stays outside the repository; this script reads it as data
(never running anything in it) and copies into sources/wenli-shengsheng-v0.4/:

- the frozen research v0.4, all 92 files of dist/research/ (README, the six layers, references 01-18, the
  release validator and its results), unchanged: the release states these bytes are unchanged from v0.4;
- the atlas's three derived data files that carry the characters and their relations
  (dist/data/word-network.json, integrity.json, models.json) and the release's README, review record and
  release.json; the website code, screenshots and the large generated indexes (catalog, search, details) stay
  in the archive.

PROVENANCE.json binds every file and the archive. `--check` re-hashes the files; with --zip it also re-reads
each member and compares.

    python3 -I import_wenli.py --zip ARCHIVE --repo REPO [--check]
"""
import argparse, hashlib, json, os, sys, zipfile

ARCHIVE_SHA256 = 'e98c76582fe23f6e0e4b421b6aa4194b82cec477ad8560f27a5232e6fd9df919'
ROOT_IN = '26_文理生生关系图谱_v2.2/'
DEST = 'sources/wenli-shengsheng-v0.4'
EXTRA = ['README.md', '复核记录.txt', 'release.json', 'dist/data/word-network.json', 'dist/data/integrity.json',
         'dist/data/models.json']
RENAME = {'README.md': 'RELEASE-README.md', '复核记录.txt': 'release-review.txt', 'release.json': 'release.json',
          'dist/data/word-network.json': 'atlas/word-network.json', 'dist/data/integrity.json': 'atlas/integrity.json',
          'dist/data/models.json': 'atlas/models.json'}


def sha(b):
    return hashlib.sha256(b).hexdigest()


def members(z):
    out = []
    for n in z.namelist():
        if n.endswith('/'):
            continue
        rel = n[len(ROOT_IN):]
        if rel.startswith('dist/research/'):
            out.append((n, 'research/' + rel[len('dist/research/'):]))
        elif rel in EXTRA:
            out.append((n, RENAME[rel]))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--zip')
    ap.add_argument('--repo', required=True)
    ap.add_argument('--check', action='store_true')
    a = ap.parse_args()
    dest = os.path.join(a.repo, DEST)
    if a.check:
        prov = json.load(open(os.path.join(dest, 'PROVENANCE.json'), encoding='utf-8'))
        bad = [f['file'] for f in prov['files'] if sha(open(os.path.join(dest, f['file']), 'rb').read()) != f['sha256']]
        if a.zip:
            z = zipfile.ZipFile(a.zip)
            assert sha(open(a.zip, 'rb').read()) == prov['archive_sha256']
            bad += [f['file'] for f in prov['files'] if sha(z.read(f['member'])) != f['sha256']]
        print('check:', 'ok' if not bad else 'FAILED %s' % bad[:5], len(prov['files']), 'files')
        sys.exit(1 if bad else 0)
    data = open(a.zip, 'rb').read()
    assert sha(data) == ARCHIVE_SHA256, 'archive hash differs'
    z = zipfile.ZipFile(a.zip)
    files = []
    for member, rel in sorted(members(z), key=lambda x: x[1]):
        b = z.read(member)
        p = os.path.join(dest, rel)
        os.makedirs(os.path.dirname(p), exist_ok=True)
        open(p, 'wb').write(b)
        files.append({'file': rel, 'member': member, 'bytes': len(b), 'sha256': sha(b)})
    prov = {'about': ('文理生生: frozen research v0.4 and the relational atlas v2.2 data, built by Ren with Codex '
                      '(21-22 October 2026), imported for board item WL byte for byte from the release archive, which '
                      'stays outside the repository with the website code, screenshots and generated indexes.'),
            'archive': '26_文理生生关系图谱_v2.2.zip', 'archive_sha256': ARCHIVE_SHA256,
            'release_commit': '4e517c13803237095f21a6685bd8166dc2b5d527', 'files': files}
    open(os.path.join(dest, 'PROVENANCE.json'), 'w', encoding='utf-8').write(json.dumps(prov, ensure_ascii=False, indent=1) + '\n')
    print(len(files), 'files imported to', DEST)


if __name__ == '__main__':
    main()
