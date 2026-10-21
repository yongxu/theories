"""Read an R data file (.rda, .RData) with the standard library only (MQ7).

  python3 -I rda_read.py names FILE.rda          the objects in the file, and for each data frame its column names,
                                                 types and row count (no value printed)

An .rda file is R's serialization of a pairlist of named objects (format version 2 or 3, XDR binary), compressed
with gzip, bzip2 or xz. `load` returns {name: object}: a data frame as a `Frame` (columns in order, each a Python
list, a factor read as its labels), any other vector as a Python list. Only what data frames need is read:
vectors, lists, pairlists, symbols, attributes, references and R's compact (ALTREP) vectors. Closures,
environments other than the global one, and byte code stop the reader.
"""
from __future__ import annotations

import bz2
import gzip
import lzma
import math
import struct
import sys

NILVALUE, EMPTYENV, BASEENV, GLOBALENV, UNBOUND, MISSINGARG, BASENAMESPACE = 254, 242, 241, 253, 252, 251, 247
REFSXP, ALTREP, ATTRLIST, ATTRLANG = 255, 238, 239, 240
NILSXP, SYMSXP, LISTSXP, LANGSXP, CHARSXP, LGLSXP, INTSXP, REALSXP = 0, 1, 2, 6, 9, 10, 13, 14
CPLXSXP, STRSXP, VECSXP, EXPRSXP, RAWSXP = 15, 16, 19, 20, 24
NA_INT = -2 ** 31


class Frame:
    """A data frame: the column names, the columns (lists), and its attributes."""

    def __init__(self, names, columns, attrs):
        self.names, self.columns, self.attrs = names, columns, attrs

    def __len__(self):
        return len(self.columns[0]) if self.columns else 0

    def column(self, name):
        return self.columns[self.names.index(name)]


class _Reader:
    def __init__(self, data):
        self.d, self.i, self.refs = data, 0, []

    def int(self):
        v = struct.unpack_from('>i', self.d, self.i)[0]
        self.i += 4
        return v

    def length(self):
        n = self.int()
        if n == -1:
            hi, lo = self.int(), self.int()
            n = (hi << 32) + (lo & 0xFFFFFFFF)
        return n

    def item(self):
        flags = self.int()
        t = flags & 0xFF
        has_attr, has_tag = bool(flags & (1 << 9)), bool(flags & (1 << 10))
        if t == NILVALUE:
            return None
        if t in (EMPTYENV, BASEENV, GLOBALENV, UNBOUND, MISSINGARG, BASENAMESPACE):
            return ('env', t)
        if t == REFSXP:
            k = flags >> 8
            if k == 0:
                k = self.int()
            return self.refs[k - 1]
        if t == SYMSXP:
            s = self.item()
            sym = ('sym', s)
            self.refs.append(sym)
            return sym
        if t in (LISTSXP, LANGSXP, ATTRLIST, ATTRLANG):
            items, attrs = [], None
            while True:
                if has_attr:
                    attrs = self.item()
                tag = self.item() if has_tag else None
                car = self.item()
                items.append((tag[1] if isinstance(tag, tuple) and tag[0] == 'sym' else tag, car))
                nxt = self.int()
                nt = nxt & 0xFF
                if nt == NILVALUE:
                    break
                if nt not in (LISTSXP, LANGSXP, ATTRLIST, ATTRLANG):
                    self.i -= 4
                    items.append((None, self.item()))
                    break
                has_attr, has_tag = bool(nxt & (1 << 9)), bool(nxt & (1 << 10))
            return ('pairlist', items, attrs)
        if t == CHARSXP:
            n = self.int()
            if n == -1:
                return None
            s = self.d[self.i:self.i + n]
            self.i += n
            return s.decode('utf-8', errors='replace')
        if t == ALTREP:
            info = self.item()
            state = self.item()
            attrs = self.item()
            return self._attach(self._altrep(info, state), attrs)
        if t in (LGLSXP, INTSXP):
            n = self.length()
            v = list(struct.unpack_from('>%di' % n, self.d, self.i))
            self.i += 4 * n
            v = [None if x == NA_INT else x for x in v]
            if t == LGLSXP:
                v = [None if x is None else bool(x) for x in v]
        elif t == REALSXP:
            n = self.length()
            v = list(struct.unpack_from('>%dd' % n, self.d, self.i))
            self.i += 8 * n
            v = [None if math.isnan(x) else x for x in v]
        elif t == CPLXSXP:
            n = self.length()
            raw = struct.unpack_from('>%dd' % (2 * n), self.d, self.i)
            self.i += 16 * n
            v = [complex(raw[2 * j], raw[2 * j + 1]) for j in range(n)]
        elif t == STRSXP:
            n = self.length()
            v = [self.item() for _ in range(n)]
        elif t in (VECSXP, EXPRSXP):
            n = self.length()
            v = [self.item() for _ in range(n)]
        elif t == RAWSXP:
            n = self.length()
            v = self.d[self.i:self.i + n]
            self.i += n
        else:
            raise ValueError(f'R type {t} is not read here')
        attrs = self.item() if has_attr else None
        return self._attach(v, attrs)

    def _altrep(self, info, state):
        cls = info[1][0][1][1] if isinstance(info, tuple) else None
        if cls in ('compact_intseq', 'compact_realseq'):
            n, start, step = state
            n = int(n)
            v = [start + step * j for j in range(n)]
            return [int(x) for x in v] if cls == 'compact_intseq' else v
        if cls and cls.startswith('wrap_'):
            return state[0] if isinstance(state, list) else state
        if cls == 'deferred_string':
            arg = state[1][0][1] if isinstance(state, tuple) else state
            return [None if x is None else (str(int(x)) if isinstance(x, float) and x.is_integer() else str(x))
                    for x in arg]
        raise ValueError(f'ALTREP class {cls} is not read here')

    def _attach(self, v, attrs):
        if attrs is None:
            return v
        a = {k: x for k, x in attrs[1]} if isinstance(attrs, tuple) else {}
        cls = a.get('class') or []
        if 'factor' in cls:
            labels = a.get('levels') or []
            return [None if x is None else labels[x - 1] for x in v]
        if 'data.frame' in cls:
            return Frame(list(a.get('names') or []), v, a)
        if isinstance(v, list) and a.get('names') is not None and not isinstance(v, Frame):
            return {'names': a['names'], 'values': v, 'attrs': a}
        return v


def _decompress(raw):
    if raw[:2] == b'\x1f\x8b':
        return gzip.decompress(raw)
    if raw[:3] == b'BZh':
        return bz2.decompress(raw)
    if raw[:6] == b'\xfd7zXZ\x00':
        return lzma.decompress(raw)
    return raw


def load(path):
    with open(path, 'rb') as f:
        data = _decompress(f.read())
    if data[:5] not in (b'RDX2\n', b'RDX3\n'):
        raise ValueError('not an R data file (RDX2 or RDX3)')
    if data[5:7] != b'X\n':
        raise ValueError('only the XDR binary format is read here')
    r = _Reader(data)
    r.i = 7
    version = r.int()
    r.int()
    r.int()
    if version == 3:
        n = r.int()
        r.i += n
    top = r.item()
    return {name: obj for name, obj in top[1]}


def describe(path):
    out = {}
    for name, obj in load(path).items():
        if isinstance(obj, Frame):
            out[name] = {'rows': len(obj), 'columns': [
                (c, type(next((x for x in col if x is not None), None)).__name__) for c, col in zip(obj.names, obj.columns)]}
        else:
            out[name] = type(obj).__name__
    return out


if __name__ == '__main__':
    if len(sys.argv) == 3 and sys.argv[1] == 'names':
        import json
        print(json.dumps(describe(sys.argv[2]), indent=1))
    else:
        raise SystemExit(__doc__)
