// OCR of chosen pages of a PDF with the system's Vision framework. Writes TSV: page, x, y, w, h, confidence, text (normalised page coordinates, y from the top).
// Usage: pdfocr FILE OUT.tsv SCALE [first last]   (1-based pages; default all). Prints counts only.
import Foundation
import PDFKit
import Vision
import AppKit
let a = CommandLine.arguments
guard a.count >= 4, let d = PDFDocument(url: URL(fileURLWithPath: a[1])) else { print("cannot open"); exit(1) }
let scale = CGFloat(Double(a[3]) ?? 3.0)
let first = a.count > 4 ? Int(a[4])! : 1
let last = a.count > 5 ? Int(a[5])! : d.pageCount
var out = ""
var nobs = 0
for i in (first-1)..<min(last, d.pageCount) {
    guard let page = d.page(at: i) else { continue }
    let box = page.bounds(for: .mediaBox)
    let w = Int(box.width * scale), h = Int(box.height * scale)
    let cs = CGColorSpaceCreateDeviceRGB()
    guard let ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { continue }
    ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1))
    ctx.fill(CGRect(x: 0, y: 0, width: w, height: h))
    ctx.scaleBy(x: scale, y: scale)
    ctx.translateBy(x: -box.origin.x, y: -box.origin.y)
    page.draw(with: .mediaBox, to: ctx)
    guard let img = ctx.makeImage() else { continue }
    let req = VNRecognizeTextRequest()
    req.recognitionLevel = .accurate
    req.usesLanguageCorrection = false
    let hnd = VNImageRequestHandler(cgImage: img, options: [:])
    try? hnd.perform([req])
    for o in req.results ?? [] {
        guard let c = o.topCandidates(1).first else { continue }
        let b = o.boundingBox
        let t = c.string.replacingOccurrences(of: "\t", with: " ")
        out += "\(i+1)\t\(String(format: "%.4f", b.minX))\t\(String(format: "%.4f", 1-b.maxY))\t\(String(format: "%.4f", b.width))\t\(String(format: "%.4f", b.height))\t\(String(format: "%.3f", c.confidence))\t\(t)\n"
        nobs += 1
    }
}
try! out.write(toFile: a[2], atomically: true, encoding: .utf8)
print("pages \(d.pageCount) read \(max(0, min(last, d.pageCount)-first+1)) boxes \(nobs)")
