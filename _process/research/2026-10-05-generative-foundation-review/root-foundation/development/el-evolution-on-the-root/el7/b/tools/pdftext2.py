"""Rough PDF text extraction, standard library only, linear-time tokenizer: inflate FlateDecode
streams, walk content-stream tokens, print literal strings shown by Tj/TJ/'/" (kerning below -180
read as a space; ET/T*/Td/TD/Tm as breaks)."""
import re, sys, zlib, signal

LIG = {0x0b: 'ff', 0x0c: 'fi', 0x0d: 'fl', 0x0e: 'ffi', 0x0f: 'ffl', 0x7b: '–', 0x7c: '—',
       0x93: '"', 0x94: '"', 0x91: "'", 0x92: "'", 0x96: '–', 0x97: '—', 0xad: '-'}

def dec(bs):
    return ''.join(LIG.get(c, chr(c) if 32 <= c < 127 else (chr(c) if 160 <= c < 256 else ' ')) for c in bs)

def tokens(d):
    i, n = 0, len(d)
    while i < n:
        c = d[i]
        if c in b' \t\r\n\x00\x0c':
            i += 1
        elif c == 0x25:  # % comment
            j = d.find(b'\n', i); i = n if j < 0 else j + 1
        elif c == 0x28:  # (string)
            depth, j, out = 1, i + 1, bytearray()
            while j < n and depth:
                ch = d[j]
                if ch == 0x5c and j + 1 < n:
                    nx = d[j + 1]
                    if nx in b'nrtbf':
                        out += b' '; j += 2
                    elif 0x30 <= nx <= 0x37:
                        k = j + 1; s = b''
                        while k < n and len(s) < 3 and 0x30 <= d[k] <= 0x37:
                            s += bytes([d[k]]); k += 1
                        out.append(int(s, 8) & 0xff); j = k
                    else:
                        out.append(nx); j += 2
                    continue
                if ch == 0x28: depth += 1
                elif ch == 0x29:
                    depth -= 1
                    if depth == 0: j += 1; break
                out.append(ch); j += 1
            yield ('str', bytes(out)); i = j
        elif c == 0x3c and i + 1 < n and d[i + 1] == 0x3c:
            yield ('op', b'<<'); i += 2
        elif c == 0x3e and i + 1 < n and d[i + 1] == 0x3e:
            yield ('op', b'>>'); i += 2
        elif c == 0x3c:
            j = d.find(b'>', i); j = n if j < 0 else j
            yield ('hex', d[i + 1:j]); i = j + 1
        elif c in b'[]':
            yield ('op', bytes([c])); i += 1
        else:
            j = i
            while j < n and d[j] not in b' \t\r\n\x00\x0c()<>[]%/':
                j += 1
            if j == i:
                j = i + 1
                while j < n and d[j] not in b' \t\r\n\x00\x0c()<>[]%/':
                    j += 1
            yield ('word', d[i:j]); i = j

def text_of(d):
    out, arr, inarr = [], [], False
    pending = []
    for kind, v in tokens(d):
        if kind == 'op' and v == b'[':
            inarr, arr = True, []
        elif kind == 'op' and v == b']':
            inarr = False; pending = arr
        elif inarr:
            if kind == 'str': arr.append(dec(v))
            elif kind == 'word':
                try:
                    if float(v) < -180: arr.append(' ')
                except ValueError:
                    pass
        elif kind == 'str':
            pending = [dec(v)]
        elif kind == 'word':
            if v in (b'TJ', b'Tj', b"'", b'"'):
                out.append(''.join(pending)); pending = []
            elif v in (b'ET', b'T*', b'TD', b'Tm'):
                out.append('\n')
            elif v == b'Td':
                out.append(' ')
    return ''.join(out)

def main(path):
    signal.alarm(100)
    data = open(path, 'rb').read()
    res = []
    for m in re.finditer(rb'stream\r?\n', data):
        s = m.end(); e = data.find(b'endstream', s)
        try:
            dd = zlib.decompressobj().decompress(data[s:e])
        except Exception:
            continue
        if (b'TJ' in dd or b'Tj' in dd) and b'BT' in dd:
            res.append(text_of(dd))
    t = '\n'.join(res)
    t = re.sub(r'[ \t]+', ' ', t); t = re.sub(r'\n\s*\n+', '\n', t)
    sys.stdout.write(t)

if __name__ == '__main__':
    main(sys.argv[1])
