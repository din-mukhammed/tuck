import CoreGraphics
import Foundation

let windows = CGWindowListCopyWindowInfo([.optionAll], kCGNullWindowID) as? [[String: Any]] ?? []
let statusLevel = Int(CGWindowLevelForKey(.statusWindow))
var rows: [(Double, Double, String)] = []
for w in windows where (w[kCGWindowLayer as String] as? Int) == statusLevel {
    guard let b = w[kCGWindowBounds as String] as? [String: Double], let x = b["X"], let y = b["Y"], let width = b["Width"] else { continue }
    if y != 0 { continue }
    let owner = w[kCGWindowOwnerName as String] as? String ?? "?"
    let onScreen = (w[kCGWindowIsOnscreen as String] as? Bool) ?? false
    rows.append((x, width, "\(owner)\(onScreen ? "" : " (offscreen)")"))
}
for (x, width, owner) in rows.sorted(by: { $0.0 < $1.0 }) {
    print(String(format: "%9.0f %7.0f  %@", x, width, owner))
}
