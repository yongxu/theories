# Downloads the annual reports the two listing pages link, each into OUT/<who>/, one manifest row per file.
# Standard library; a generic client name; no form, no login. Refusals and non-PDF replies go to the manifest as failed.
import hashlib, html, json, os, re, sys, time, urllib.parse, urllib.request, ssl
links, out = sys.argv[1], sys.argv[2]
UA = 'Mozilla/5.0 (compatible; research-download)'
def get(url, timeout=300):
    req = urllib.request.Request(url, headers={'User-Agent': UA})
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.read(), r.geturl(), r.headers.get('Content-Type', '')
def resolve(url):
    """A Widen share or stub page's own link to its PDF."""
    b, final, ty = get(url, 90)
    if b[:5] == b'%PDF-':
        return final, b
    t = b.decode('utf-8', 'replace')
    m = re.search(r'<iframe[^>]*src="(https://embed\.widencdn\.net/[^"]+)"', t)
    if m:
        b, final, ty = get(html.unescape(m.group(1)), 90)
        t = b.decode('utf-8', 'replace')
    m = re.search(r'id="download" href="([^"]+)"', t)
    if m and m.group(1) not in ('', '#'):
        return urllib.parse.urljoin(final, html.unescape(m.group(1))), None
    m = re.search(r'https://previews\.[^"\'\s\\<>]+', t)
    if m:
        return html.unescape(m.group(0)), None
    return None, None
man = []
mf = os.path.join(out, 'manifest.json')
for line in open(links, encoding='utf-8'):
    who, url, txt = line.rstrip('\n').split('\t')
    d = os.path.join(out, who); os.makedirs(d, exist_ok=True)
    name = urllib.parse.unquote(url.split('?')[0].rsplit('/', 1)[-1]).replace(' ', '_')
    if not name.lower().endswith('.pdf'):
        name += '.pdf'
    if who == 'wdnr':
        m = re.match(r'(\d{4}(?:-\d{4})?)', txt)
        name = 'wdnr_' + (m.group(1) if m else 'x') + '.pdf'
    p = os.path.join(d, name)
    rec = {'who': who, 'file': name, 'listed as': txt, 'link': url}
    for attempt in range(4):
        try:
            final, body = url, None
            if 'widen' in url:
                final, body = resolve(url)
                if final is None:
                    rec['failed'] = 'the viewer gave no link to a PDF'
                    break
            if body is None:
                body, f2, ty = get(final)
            rec['fetched from'] = final.split('?')[0]
            if body[:5] != b'%PDF-':
                rec['failed'] = 'not a PDF: ' + body[:40].decode('ascii', 'replace')
                continue
            open(p, 'wb').write(body)
            rec.update({'size': len(body), 'sha256': hashlib.sha256(body).hexdigest(), 'date': time.strftime('%Y-%m-%d')})
            rec.pop('failed', None)
            break
        except Exception as e:
            rec['failed'] = repr(e)[:120]
            time.sleep(6)
    man.append(rec)
    json.dump(man, open(mf, 'w'), indent=1)
    print(name, rec.get('size'), rec.get('failed', 'ok'), flush=True)
    time.sleep(1.5)
print('DONE', sum(1 for r in man if 'size' in r), 'of', len(man), round(sum(r.get('size', 0) for r in man) / 1e6, 1), 'MB', flush=True)
