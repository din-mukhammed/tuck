import Foundation

var passedCount = 0
var failedCount = 0
private var currentFailed = false

func test(_ name: String, _ body: () -> Void) {
    currentFailed = false
    body()
    if currentFailed {
        failedCount += 1
        print("FAIL  \(name)")
    } else {
        passedCount += 1
        print("ok    \(name)")
    }
}

func expect(_ condition: Bool, _ message: String = "", file: StaticString = #fileID, line: UInt = #line) {
    if !condition {
        currentFailed = true
        print("      expectation failed at \(file):\(line) \(message)")
    }
}
