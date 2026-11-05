"""Rough text extraction from a PDF with only the standard library: inflate FlateDecode streams and
read the strings shown by Tj/TJ/'/" operators. For reading papers; not a faithful renderer."""
import re, sys, zlib

def unescape(b):
    out = bytearray(); i = 0
    while i < len(b):
        c = b[i]
        if c == 0x5c and i + 1 < len(b):
            n = b[i + 1]
            if n in b'nrtbf':
                out += {ord('n'): b'\n', ord('r'): b'\r', ord('t'): b'\t', ord('b'): b'\b', ord('f'): b'\f'}[n]; i += 2
            elif 0x30 <= n <= 0x37:
                j = i + 1; s = b''
                while j < len(b) and len(s) < 3 and 0x30 <= b[j] <= 0x37:
                    s += bytes([b[j]]); j += 1
                out.append(int(s, 8) & 0xff); i = j
            else:
                out.append(n); i += 2
        else:
            out.append(c); i += 1
    return bytes(out)

LIG = {0x0b: 'ff', 0x0c: 'fi', 0x0d: 'fl', 0x0e: 'ffi', 0x0f: 'ffl', 0x7b: '–', 0x7c: '—'}

def decode(bs):
    return ''.join(LIG.get(c, chr(c) if 32 <= c < 127 else ' ') for c in bs)

def strings_in(content):
    text = []
    # TJ arrays
    for m in re.finditer(rb'\[((?:\\.|[^\]])*)\]\s*TJ|\(((?:\\.|[^\\)])*)\)\s*(?:Tj|\'|")|(T\*|Td|TD|Tm|ET)', content):
        if m.group(1) is not None:
            parts = re.finditer(rb'\(((?:\\.|[^\\)])*)\)|(-?\d+\.?\d*)', m.group(1))
            for p in parts:
                if p.group(1) is not None:
                    text.append(decode(unescape(p.group(1))))
                elif p.group(2) is not None and float(p.group(2)) < -180:
                    text.append(' ')
        elif m.group(2) is not None:
            text.append(decode(unescape(m.group(2))))
        else:
            op = m.group(3)
            text.append('\n' if op in (b'ET', b'T*', b'TD', b'Tm') else ' ')
    return ''.join(text)

def main(path):
    data = open(path, 'rb').read()
    out = []
    for m in re.finditer(rb'stream\r?\n', data):
        start = m.end()
        end = data.find(b'endstream', start)
        if end < 0:
            continue
        raw = data[start:end]
        try:
            dec = zlib.decompressobj().decompress(raw)
        except Exception:
            continue
        if b'TJ' in dec or b'Tj' in dec:
            out.append(strings_in(dec))
    txt = '\n'.join(out)
    txt = re.sub(r'[ \t]+', ' ', txt)
    txt = re.sub(r'\n\s*\n+', '\n', txt)
    sys.stdout.write(txt)

if __name__ == '__main__':
    main(sys.argv[1])
