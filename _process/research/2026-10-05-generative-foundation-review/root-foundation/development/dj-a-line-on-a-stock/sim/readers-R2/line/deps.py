#!/usr/bin/env python3
"""AI-written (Fable, reader), 16 November 2026. Name-level dependency trace in a Lean file with
comments stripped: for each declaration, which other declarations of the file its text names, and
which `LineOnAStock.` names; then the closure. By names, not by Lean (instances are not traced)."""
import re, sys
sys.path.insert(0, '.')
from headers import strip_comments  # noqa
