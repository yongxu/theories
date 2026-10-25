"""Re-pointing from a drift list (repoint.py --drift-json) touches exactly the listed (record, path) pairs, so an
empty list touches nothing: before the guard it left the record filter empty and re-pointed every changed reference
of every record."""
import io
import json
import tempfile
import unittest
from contextlib import redirect_stdout
from pathlib import Path
from unittest import mock

from tools.research import repoint


class DriftList(unittest.TestCase):
    def test_empty_list_visits_no_record(self):
        with tempfile.TemporaryDirectory() as tmp:
            drift = Path(tmp) / 'drift.json'
            drift.write_text(json.dumps({'source_drift': []}))
            out = io.StringIO()
            with mock.patch.object(repoint, 'repoint_record', side_effect=AssertionError('a record was visited')), \
                    redirect_stdout(out):
                self.assertEqual(repoint.main(['--reason', 'test', '--drift-json', str(drift)]), 0)
            self.assertEqual(json.loads(out.getvalue())['records'], 0)


if __name__ == '__main__':
    unittest.main()
