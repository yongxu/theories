// Text layer of a PDF via macOS PDFKit (JavaScript for Automation), used to read the data
// section of Cury et al.'s (2011) Supporting Online Material:
//   osascript -l JavaScript pdftext.js /absolute/path/14307.pdf > som.txt
//   python3 -I ew2.py extract som.txt cury2011_som_data.csv
ObjC.import('PDFKit');
function run(argv){
  var url=$.NSURL.fileURLWithPath(argv[0]);
  var doc=$.PDFDocument.alloc.initWithURL(url);
  return ObjC.unwrap(doc.string);
}
