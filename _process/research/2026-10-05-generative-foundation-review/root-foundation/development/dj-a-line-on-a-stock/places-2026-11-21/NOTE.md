# One listing of places, from the table and three reads

*AI-written (Claude Fable, board row DJ), 21 November 2026. No Lean was written or read for this, no agent ran, and nothing was built. The listing is made by a script from records already in this study; this note says what it is and adds nothing about any place.*

## Why

Ren, 21 November: "i am drawing the map not saying the map" ([his words](../../../../../../../sources/15-codex-theory-conversations/2026-11-21-drawing-the-map-not-saying-it.md)). Both other sessions had said the order of work had no step for the map as data. Between 20 and 21 November this row made a table of 89 places by eight properties and three reads in which AI readers answered fixed questions place by place. Each stands in its own folder, in its own form. Here they are put side by side, by place.

## What it is

- [`places.json`](places.json): for each place, its rows in the table of 20 November (letters, standing, where it is told) and, for each read that covered it, the reader's return for that place, field by field and word for word, with which read and which reader, the path of that read's note and of the reader's report, and one fixed line: "a reader's return, unchecked; what the note mended is in the note".
- [`PLACES.md`](PLACES.md): a view of it. First one line a place; then, for each place that a read covered, the readers' words.
- [`build_places.py`](build_places.py): the script, with the readers' returns it reads in `returns/`. A place is keyed by the first Lean file name in the reader's own name for it, or the last part of a path; names with neither stay as their own rows. Each place carries the tracked file of that name, found by the script with copies left out: of the 150, 139 are one file, 2 are a name that several files carry, and 9 are no file (a namespace inside a file, a program, a scratch module, a folder, a page). The rows say which, since two places can share a row; the readers' own names for the place are kept under it. Both outputs are made by it and never edited by hand. Whoever lands a place-by-place read adds its returns and runs the script in that landing; a listing that is not made again after the next read is worse than none.

150 places: 85 with a row in the table, 108 in at least one read. The three reads are of 20 November (things kept by goings-on) and 21 November (a future opening or closing; how a registering comes to be). The read of 20 November that set the renewal files against the package's keeping did not answer place by place and is not in it; nor are the four scratch modules.

## What it is not

- **Not checked.** Every field is one AI reader's return, read by no second reader. The notes of the three reads were each checked against the readers' full reports and mended; these returns are the readers' short structured answers, the least checked text of each read, and a checker found the writer misquoting from them. So every return carries the path of its read's note and of the reader's report. Where a return and the report differ, the report stands; where the note mended something, the note stands.
- **Not the atlas, not a replacement for it, and not the data structure of the map.** The atlas lists dynamics and the links the Lean proves between them. This lists places and what readers said of them. Nothing here is a link. The open item on who holds the atlas and what becomes of the second store (the board's line 0, e) stays open, and the rows that hold them are not answered by this.
- **Not a count to move.** The figures above are a description in this note; the files hold no totals and nothing that adds up per place.
- **Not complete.** A blank means a place was not in that read. The package has some four hundred modules; these are the places that were named.

## What it is for

To find, for a place, what has already been read of it before anyone reads it again or proposes something about it; and to see, across places, which have been set against which question. That is all it can bear.

What the place might carry later, if this ever grows toward the map's own structure, is not readings but what was drawn: which statement is a case of which, and how that was checked. That is the coordinating session's thought and is not done here.

*Added the same day by the survey session, at this row's asking (function `joins` in the script): each place that has a file carries, computed, the ids of the result records whose references name that file (`records`) and of the atlas's dynamics that name one of those records (`dynamics`), so that a reader can step from a place to its records and dynamics and back. A record names a file as a source of its statement or proof, and a dynamic names records; neither says that the file states the dynamic. It is no link, nothing was read in the Lean for it, and the atlas's unlinked dynamics are not changed by it. The ids are those of the records and the atlas's entries as they stood when the script last ran. The survey session also asked for the file path and kind, and for a warning in each place's own heading, since a search lands there and not at the head of the file; both are done.*

*The coordinating session weighed filing this before it was landed and set four conditions, which are met as above: every return carries its note and report with a fixed line; the outputs are generated and say so; one pointer to it stands in the board's row for this work; and the files hold no totals.*
