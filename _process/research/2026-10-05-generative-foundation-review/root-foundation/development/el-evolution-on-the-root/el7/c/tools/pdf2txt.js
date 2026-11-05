ObjC.import('PDFKit');
ObjC.import('Foundation');
function run(argv) {
  var d = $.PDFDocument.alloc.initWithURL($.NSURL.fileURLWithPath(argv[0]));
  if (!d || d.isNil && d.isNil()) { return "could not open"; }
  var n = d.pageCount;
  var out = [];
  for (var i = 0; i < n; i++) {
    var p = d.pageAtIndex(i);
    out.push("\n=== page " + (i+1) + " ===\n" + ObjC.unwrap(p.string));
  }
  var s = $(out.join("\n"));
  s.writeToFileAtomicallyEncodingError($(argv[1]), true, $.NSUTF8StringEncoding, null);
  return "pages " + n;
}
