import Foundation

visibilityStateTests()
autoHideTests()
preferencesTests()

print("\(passedCount) passed, \(failedCount) failed")
exit(failedCount == 0 ? 0 : 1)
