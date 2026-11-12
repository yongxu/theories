# AI-written, 12 November 2026. The Chinese pages were written through frames made for English: the word "At" in
# every pin line, half-width stops, colons and brackets glued to Chinese labels, a box's paragraph opening with its
# English name as if it were a sentence. The frames now punctuate by language, and the other language's name of a
# box stands in brackets. Replaces four writers in the worktree's module and patches a fifth. Run once.
M = '/Users/ren/tmp/rw/map2/wt/tools/research/map_sheet.py'
s = open(M, encoding='utf-8').read()


def between(start, end):
    a = s.index(start); b = s.index(end, a)
    return a, b


NEW_TOLD = r'''def _lab(label, lang, alone=False):
    """A bold label: alone on its line, or opening a paragraph."""
    if lang == 'zh': return '**%s：**' % label
    return '**%s.**' % label if alone else '**%s.** ' % label


def _note(text, lang):
    return '*（%s）*' % text if lang == 'zh' else ' *(%s)*' % text


def _br(text, lang):
    return '（%s）' % text if lang == 'zh' else ' (%s)' % text


def _col(lang):
    return '：' if lang == 'zh' else ': '


def _stop(text, lang):
    return text.rstrip('.。 ') + ('。' if lang == 'zh' else '.')


def _step_marks(m, st, lang):
    P = {p['id']: p for p in m['geo']['P']}
    r = st['refs'][0]
    k = P[r['p']]['kind'] if 'p' in r else ''
    return _note(S[lang]['kind'][k], lang) if k in ('needs', 'built', 'reading') else ''


def _told(m, path, lang, deep=False, places=''):
    """A path told step by step; with deep, each step is followed by what it stands on."""
    s, boxes, P = S[lang], m['geo']['boxes'], {p['id']: p for p in m['geo']['P']}
    out = []
    for sec in path['sections']:
        out += ['**%s**' % _nm(sec, lang), '']
        for st in sec['steps']:
            line = '%d. %s%s' % (st['n'], _L(st, 'say', lang), _step_marks(m, st, lang))
            if st.get('eg'): line += ('' if lang == 'zh' else ' ') + _L(boxes[st['eg']], 'eg', lang)
            if st.get('test'): line += ' *' + _nm(st['test'], lang) + '*'
            out.append(line)
            if deep:
                for r in st['refs']:
                    if 'c' in r: out.append('    - [%s](%s#%s)' % (_nm(boxes[r['c']], lang), places, _anchor(r['c'])))
                    elif 'stay' in r: out.append('    - [%s](%s#%s)%s%s' % (_nm(boxes[r['stay']], lang), places, _anchor(r['stay']), _col(lang), s['stay_t']))
                    else:
                        p = P[r['p']]
                        out.append('    - [%s](%s#%s)%s[%s](%s#%s)%s%s%s' % (_nm(boxes[p['from']], lang), places, _anchor(p['from']), _arrow(p), _nm(boxes[p['to']], lang), places, _anchor(p['to']),
                                                                         _col(lang), _L(p, 'tag', lang), _note(s['kind'][p['kind']], lang)))
        out.append('')
    return out


'''
a, b = between('def _step_marks(m, st, lang):', 'def _listed(label, items, lang):')
s = s[:a] + NEW_TOLD + s[b:]

NEW_PLACES = r'''def places(m, lang, head):
    s, f, sheet, boxes = S[lang], _files(lang), m['d']['sheet'], m['geo']['boxes']
    P = m['geo']['P']
    out = list(head) + [s['places_lead'].format(hub=f['hub']), '']
    link = lambda cid: '[%s](#%s)' % (_nm(boxes[cid], lang), _anchor(cid))
    semi = '；' if lang == 'zh' else '; '
    def way(w):
        t = (w['zh'] if lang == 'zh' else w['en']) + _note(s['kind'][w['kind']] + (semi + s['one'] if w.get('readers') == 1 and w.get('laws') else ''), lang)
        if w.get('laws'): t += ('' if lang == 'zh' else ' ') + _stop(s['lean'] + _col(lang) + ', '.join('`%s`' % l.replace('Becoming.', '') for l in w['laws']), lang)
        return t
    for band in sheet['bands']:
        out += ['## ' + _nm(band, lang), '']
        for rid in m['geo']['ri']:
            R = m['geo']['rows'][rid]
            if R['band'] != band['id']: continue
            out += ['### ' + _nm(R, lang), '']
            for b in sorted([b for b in boxes.values() if b['row'] == rid], key=lambda b: b['col']):
                # the other language's name stands in brackets: the pictures carry both
                other = '（%s）' % b['en'] if lang == 'zh' else '(%s) ' % b['zh']
                out += ['<a id="%s"></a>' % _anchor(b['id']), '#### ' + _nm(b, lang), '', other + _L(b, 'says', lang) + ('' if lang == 'zh' else ' ') + _L(b, 'eg', lang)]
                kn = b.get('known_' + lang) or b.get('known_en') or []
                if kn: out.append(_listed(s['known'], kn, lang))
                un = b.get('unlike_' + lang) or b.get('unlike_en') or []
                if un: out.append(_listed(s['unlike'], un, lang))
                if b.get('wanted'): out.append(s['wanted'])
                out.append('')
                st = m['geo']['stays'].get(b['id'], [])
                if st: out += [_lab(s['stays'], lang) + ('' if lang == 'zh' else ' ').join((x['zh'] if lang == 'zh' else x['en']) for x in st), '']
                outs = [p for p in P if p['from'] == b['id']]
                ins = [p for p in P if p['to'] == b['id']]
                out.append('**%s**' % s['from']); out.append('')
                if not outs and not any(p['kind'] in ('line', 'same') for p in ins): out += [s['none_out'], '']
                for p in outs:
                    out.append('-%s%s%s%s%s' % (_arrow(p), link(p['to']), _col(lang), _lab(_L(p, 'tag', lang), lang).replace('：**', '。**'), way(p)))
                    for w in p.get('more', []): out.append('    - %s%s%s' % (s['also'], _col(lang), way(w)))
                for p in ins:
                    if p['kind'] in ('line', 'same'): out.append('-%s%s%s%s%s' % (_arrow(p), link(p['from']), _col(lang), _L(p, 'tag', lang), _note(s['kind'][p['kind']], lang)))
                out.append('')
                directed = [p for p in ins if p['kind'] not in ('line', 'same')]
                out.append('**%s**' % s['into']); out.append('')
                if not directed: out.append(s['none_in'])
                for p in directed: out.append('- ← %s%s%s%s' % (link(p['from']), _col(lang), _L(p, 'tag', lang), _note(s['kind'][p['kind']], lang)))
                out.append('')
                tests = [t for t in m['tests'] if any(pin['at'] == b['id'] for pin in t['pins']) or (t.get('view') and t['view']['at'] == b['id'])]
                if tests: out += [_listed(s['tests_here'], ['[%s](%s#test-%s)' % (_nm(t, lang), f['paths'], t['id']) for t in tests], lang), '']
                dy = [m['dyn_names'].get(x, x) for x in b.get('dynamics', [])]
                if dy: out += ['<details><summary>%s%s</summary>' % (s['dyn'], _br(str(len(dy)), lang)), '', '; '.join(dy) + '.', '', '</details>', '']
    return registry.finish(out)


def paths_page(m, lang, head):
    s, f, boxes = S[lang], _files(lang), m['geo']['boxes']
    P = {p['id']: p for p in m['geo']['P']}
    semi = '；' if lang == 'zh' else '; '
    out = list(head) + [s['paths_lead'].format(hub=f['hub'], places=f['places']), '']
    for path in m['paths']:
        out += ['<a id="path-%s"></a>' % path['id'], '## ' + _nm(path, lang), '', _L(path, 'lead', lang), '',
                '![%s](path-%s%s.svg)' % (_nm(path, lang), path['id'], '.zh' if lang == 'zh' else ''), '']
        kn = _known(m, path, lang)
        if kn: out += [_listed(s['known'], kn, lang), '']
        out += _told(m, path, lang, deep=True, places=f['places'])
        out += [_lab(s['shows'], lang, alone=True), ''] + ['- ' + x for x in _L(path, 'shows', lang)] + ['']
        if _L(path, 'want', lang): out += [_lab(s['wants'], lang) + _L(path, 'want', lang), '']
    out += ['## ' + s['tests_title'], '', s['met_lead2'], '']
    for t in m['tests']:
        out += ['<a id="test-%s"></a>' % t['id'], '### %s%s' % (_nm(t, lang), _br(t['test'], lang)), '', _L(t, 'line', lang), '',
                _lab(s['situation'], lang) + _L(t, 'what', lang), '', _lab(s['said'], lang) + _L(t, 'said', lang), '', _lab(s['was_seen'], lang) + _L(t, 'seen', lang), '', '**%s**' % s['taken'], '']
        for pin in t['pins']:
            where = '[%s](%s#%s)' % (_nm(boxes[pin['at']], lang), f['places'], _anchor(pin['at']))
            found = semi + s['found_at'] + ('' if lang == 'zh' else ' ') + '[%s](%s#%s)' % (_nm(boxes[pin['found_at']], lang), f['places'], _anchor(pin['found_at'])) if pin.get('found_at') else ''
            taken = _stop(pin['zh'] if lang == 'zh' else pin['en'], lang)
            seen = '*%s*' % _stop(s['agree'][pin['agree']].capitalize() + _col(lang) + _L(pin, 'seen', lang), lang)
            if lang == 'zh': out.append('%d. %s放在%s，%s%s。%s' % (pin['n'], taken, where, s['how_t'][pin['how']], found, seen))
            else: out.append('%d. %s At %s, %s%s. %s' % (pin['n'], taken, where, s['how_t'][pin['how']], found, seen))
        out += ['', _lab(s['gave'], lang) + _L(t, 'broke', lang), '', _lab(s['after'], lang) + _L(t, 'after', lang), '', _lab(s['rival'], lang) + _L(t, 'rival', lang), '']
        if t.get('view'): out += [_lab(s['view'], lang) + _stop('[%s](%s#%s)' % (_nm(boxes[t['view']['at']], lang), f['places'], _anchor(t['view']['at'])), lang) + ('' if lang == 'zh' else ' ') + _nm(t['view'], lang), '']
        if t.get('used_ids'):
            out.append(_lab(s['used'], lang) + _stop(semi.join('[%s](%s#%s)%s[%s](%s#%s)' % (_nm(boxes[P[i]['from']], lang), f['places'], _anchor(P[i]['from']), _arrow(P[i]), _nm(boxes[P[i]['to']], lang), f['places'], _anchor(P[i]['to'])) for i in t['used_ids']), lang))
            out.append('')
    return registry.finish(out)


'''
a, b = between('def places(m, lang, head):', '# ---------------------------------------------------------------------------------------------- the render')
s = s[:a] + NEW_PLACES + s[b:]


def sub(x, y):
    global s
    assert s.count(x) == 1, (s.count(x), x[:80])
    s = s.replace(x, y)


# the page itself
sub("'## %s: %s' % (s['first'], _nm(first, lang)), '', _L(first, 'lead', lang), '']", "'## %s%s%s' % (s['first'], _col(lang), _nm(first, lang)), '', _L(first, 'lead', lang), '']")
sub("    out += ['**%s.**' % s['shows'], ''] + ['- ' + x for x in _L(first, 'shows', lang)] + ['']\n"
    "    if _L(first, 'want', lang): out += ['**%s.** %s' % (s['wants'], _L(first, 'want', lang)), '']\n",
    "    out += [_lab(s['shows'], lang, alone=True), ''] + ['- ' + x for x in _L(first, 'shows', lang)] + ['']\n"
    "    if _L(first, 'want', lang): out += [_lab(s['wants'], lang) + _L(first, 'want', lang), '']\n")
sub("        out += ['- **[%s](%s#path-%s)** (%d %s). %s' % (_nm(p, lang), f['paths'], p['id'], p['n'], s['steps'], _L(p, 'lead', lang)) for p in m['paths'][1:]] + ['']\n",
    "        out += ['- **[%s](%s#path-%s)**%s%s' % (_nm(p, lang), f['paths'], p['id'], _stop(_br('%d %s' % (p['n'], s['steps']), lang), lang) + ('' if lang == 'zh' else ' '), _L(p, 'lead', lang)) for p in m['paths'][1:]] + ['']\n")
sub("        out.append('- **[%s](%s#test-%s)** (%s). %s' % (_nm(t, lang), f['paths'], t['id'], t['test'], _L(t, 'line', lang)))\n",
    "        out.append('- **[%s](%s#test-%s)**%s%s' % (_nm(t, lang), f['paths'], t['id'], _stop(_br(t['test'], lang), lang) + ('' if lang == 'zh' else ' '), _L(t, 'line', lang)))\n")
sub("            out.append('- *%s*: %s' % (_nm(R, lang), ' · '.join(", "            out.append('- *%s*%s%s' % (_nm(R, lang), _col(lang), ' · '.join(")
sub("'wanted': '这项工作想到达的方框之一。'", "'wanted': '这项工作想要到达的方框之一。'")
sub("'dyn': '图谱里放在这里的动态'", "'dyn': '图谱里放在这里的动态，名字是英文'")
open(M, 'w', encoding='utf-8').write(s)
print('ok')
