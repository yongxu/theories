// Writes each page's text of a PDF to OUT as "\f" separated pages, using the system's PDFKit. Prints page count only.
import Foundation
import PDFKit
let a = CommandLine.arguments
guard a.count == 3, let d = PDFDocument(url: URL(fileURLWithPath: a[1])) else { print("cannot open"); exit(1) }
var s = ""
var empty = 0
for i in 0..<d.pageCount {
    let t = d.page(at: i)?.string ?? ""
    if t.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { empty += 1 }
    s += t + "\u{0C}"
}
try! s.write(toFile: a[2], atomically: true, encoding: .utf8)
print("pages \(d.pageCount) empty \(empty) chars \(s.count)")
