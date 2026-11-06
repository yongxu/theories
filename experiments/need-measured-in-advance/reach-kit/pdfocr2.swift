// OCR of chosen pages with a chosen rotation (0, 90, 180, 270 degrees clockwise on the rendered page), via the system's Vision.
// Writes TSV: page, x, y, w, h, confidence, text (normalised to the rotated image, y from the top). Prints counts only.
// Usage: pdfocr2 FILE OUT.tsv SCALE ROT first last
import Foundation
import PDFKit
import Vision
let a = CommandLine.arguments
guard a.count == 7, let d = PDFDocument(url: URL(fileURLWithPath: a[1])) else { print("usage or cannot open"); exit(1) }
let scale = CGFloat(Double(a[3]) ?? 3.0), rot = Int(a[4])!, first = Int(a[5])!, last = Int(a[6])!
var out = ""; var nobs = 0; var confsum = 0.0
for i in (first-1)..<min(last, d.pageCount) {
    guard let page = d.page(at: i) else { continue }
    let box = page.bounds(for: .mediaBox)
    let pw = box.width * scale, ph = box.height * scale
    let swap = rot == 90 || rot == 270
    let w = Int(swap ? ph : pw), h = Int(swap ? pw : ph)
    guard let ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { continue }
    ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1))
    ctx.fill(CGRect(x: 0, y: 0, width: w, height: h))
    ctx.translateBy(x: CGFloat(w) / 2, y: CGFloat(h) / 2)
    ctx.rotate(by: -CGFloat(rot) * .pi / 180)
    ctx.translateBy(x: -pw / 2, y: -ph / 2)
    ctx.scaleBy(x: scale, y: scale)
    ctx.translateBy(x: -box.origin.x, y: -box.origin.y)
    page.draw(with: .mediaBox, to: ctx)
    guard let img = ctx.makeImage() else { continue }
    let req = VNRecognizeTextRequest()
    req.recognitionLevel = .accurate
    req.usesLanguageCorrection = false
    try? VNImageRequestHandler(cgImage: img, options: [:]).perform([req])
    for o in req.results ?? [] {
        guard let c = o.topCandidates(1).first else { continue }
        let b = o.boundingBox
        let t = c.string.replacingOccurrences(of: "\t", with: " ")
        out += "\(i+1)\t\(String(format: "%.4f", b.minX))\t\(String(format: "%.4f", 1-b.maxY))\t\(String(format: "%.4f", b.width))\t\(String(format: "%.4f", b.height))\t\(String(format: "%.3f", c.confidence))\t\(t)\n"
        nobs += 1; confsum += Double(c.confidence)
    }
}
try! out.write(toFile: a[2], atomically: true, encoding: .utf8)
print("boxes \(nobs) mean confidence \(nobs > 0 ? confsum / Double(nobs) : 0)")
