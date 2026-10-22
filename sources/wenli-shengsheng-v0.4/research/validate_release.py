#!/usr/bin/env python3
"""Read-only, offline validation of the v0.4 release using Python's standard library."""
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
from urllib.parse import unquote

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parent
CORE_SHA = '0377b9fc8477f2edbbf93bd3abcfff3f71218628cab3e0c8754b0e029022bbbc'


def read(name):
    return json.loads((ROOT / name).read_text(encoding='utf-8'))


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require(condition, description):
    if not condition:
        raise AssertionError(description)


def published_files():
    return {p.relative_to(ROOT).as_posix(): p for p in ROOT.rglob('*')
            if p.is_file() and p.name != 'manifest.json'
            and '__pycache__' not in p.parts and p.suffix != '.pyc'
            and p.name != '.DS_Store'}


def check_manifest():
    manifest = read('manifest.json')
    actual = published_files()
    recorded = manifest['files']
    require(set(actual) == set(recorded), 'The file list differs from manifest.json')
    for name, path in actual.items():
        require(sha(path) == recorded[name]['sha256'], f'Changed file: {name}')
        require(path.stat().st_size == recorded[name]['bytes'], f'Changed length: {name}')
    return len(actual)


def check_references():
    lex = read('references/08_组合文法逐字类型词典_v0.3.json')
    senses = {s['sense_id']: s for c in lex['core_lexemes'] for s in c['senses']}
    senses.update({s['sense_id']: s for s in lex['syntax_entries'] + lex['extension_entries']})
    chars = {s['char'] for s in senses.values()}
    require(len(senses) == 245 and len(chars) == 144, 'Frozen dictionary scope changed')
    graph = read('graph/typed_graph.json')
    existing = [s for n in graph['nodes'] for s in n['existing_senses']]
    used = {s['sense_id'] for s in existing if s['used_by_v04_rules']}
    require(len(existing) == 19 and len(used) == 13, 'Graph sense scope changed')
    require(len(graph['nodes']) == 8 and len(graph['edges']) == 13, 'Graph scope changed')
    require(set(graph['sources']).issubset(lex['sources']), 'Unknown graph source')
    for node in graph['nodes']:
        for s in node['existing_senses']:
            require(s['sense_id'] in senses, f'Unknown sense {s["sense_id"]}')
            require(senses[s['sense_id']]['char'] == node['char'], 'Sense character mismatch')
            require(set(s['source_ids']).issubset(lex['sources']), 'Unknown node source')
    bound = set()
    for edge in graph['edges']:
        require(not edge['modern_extension_ids'], 'Unregistered modern sense extension')
        for s in edge['sense_bindings']:
            require(s['sense_id'] in used and senses[s['sense_id']]['char'] == s['char'], 'Edge sense mismatch')
            bound.add(s['sense_id'])
        require(set(edge['evidence_boundary']['source_ids']).issubset(graph['sources']), 'Unknown edge source')
        require((ROOT/'graph'/edge['verification_contract']['result_file']).resolve()
                == ROOT/'engine/rule_results.json', 'Wrong query-result target')
    require(bound == used, 'Activated and bound senses differ')
    require(sum(e['resolution_status'] == 'bounded_modern_rule' for e in graph['edges']) == 9,
            'Bounded-rule count changed')
    require(sum(e['resolution_status'] == 'normative_interface' for e in graph['edges']) == 4,
            'Normative-interface count changed')
    require((ROOT/'graph'/graph['verification_snapshot']['source_file']).resolve()
            == ROOT/'engine/rule_results.json', 'Wrong verification snapshot target')
    require(graph['verification_snapshot']['engine_report'] == read('engine/rule_results.json')['verification'],
            'Graph snapshot and engine counts differ')
    constructions = read('constructions/constructions.json')
    for name, digest in constructions['input_fingerprints'].items():
        require(sha(ROOT/'references'/name) == digest, f'Construction source changed: {name}')
    require(sha(ROOT/'core/wenli.py') == CORE_SHA, 'The v0.3 interpreter changed')
    require(sha(ROOT/'references/10_组合文法参考实现_v0.3/wenli.py') == CORE_SHA,
            'Archived and active interpreters differ')
    return {'registered_characters': len(chars), 'registered_interfaces': len(senses),
            'graph_existing_senses': len(existing), 'graph_used_senses': len(used),
            'graph_sources': len(graph['sources']), 'graph_edges': len(graph['edges'])}


def check_local_links():
    count = 0
    # Check explicit local file links; strip code so modal formulas are not parsed as links.
    for path in ROOT.rglob('*.md'):
        content = re.sub(r'```[\s\S]*?```', '', path.read_text(encoding='utf-8'))
        content = re.sub(r'`[^`]*`', '', content)
        for target in re.findall(r'\]\(([^\n]+?)\)', content):
            if target.startswith(('https:', 'http:', '#', 'codex:')):
                continue
            name = unquote(target.split('#', 1)[0].strip('<>'))
            if not re.search(r'\.(md|json|py|html|png|zip)$', name):
                continue
            require(not Path(name).is_absolute(), f'Nonportable local file link: {path.name}: {name}')
            require((path.parent/name).is_file(), f'Broken local file link: {path.name}: {name}')
            count += 1
    return count


def run_checks():
    steps = [
        ('corpus/report_corpus.py', '--check'),
        ('constructions/validate_constructions.py', '--check'),
        ('constructions/independent_model_review.py', '--check'),
        ('engine/verify_rules.py', '--check'),
        ('basis/normalizer.py', '--check'),
    ]
    results = []
    env = dict(os.environ, PYTHONDONTWRITEBYTECODE='1')
    for script, flag in steps:
        result = subprocess.run([sys.executable, str(ROOT/script), flag], cwd=ROOT,
                                env=env, text=True, capture_output=True, timeout=180)
        require(result.returncode == 0,
                f'{script} failed:\n{result.stdout}\n{result.stderr}')
        results.append({'script': script, 'passed': True, 'report': result.stdout.strip()})
    return results


def main():
    file_count = check_manifest()
    references = check_references()
    links = check_local_links()
    checks = run_checks()
    require(check_manifest() == file_count, 'Validation modified published files')
    print(json.dumps({'release': '0.4', 'passed': True, 'manifest_files': file_count,
                      'local_file_links': links, 'reference_integrity': references,
                      'validation_groups': checks,
                      'scope': 'Frozen data, finite model calculations and implementation consistency; '
                               'not a proof of lexicon-wide prevalence, historical unity or universal minimality.'},
                     ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
