import Foundation

func preferencesTests() {
    func fresh() -> UserDefaults {
        UserDefaults(suiteName: "tuck.tests.\(UUID().uuidString)")!
    }
    test("defaults") {
        let p = Preferences(defaults: fresh())
        expect(p.autoHideEnabled && p.alwaysHiddenEnabled && p.autoHideDelay == 10)
    }
    test("persists across instances") {
        let d = fresh()
        let p = Preferences(defaults: d)
        p.autoHideEnabled = false
        p.autoHideDelay = 25
        p.alwaysHiddenEnabled = false
        let q = Preferences(defaults: d)
        expect(!q.autoHideEnabled && q.autoHideDelay == 25 && !q.alwaysHiddenEnabled)
    }
    test("delay clamped") {
        let d = fresh()
        d.set(500.0, forKey: "autoHideDelay")
        expect(Preferences(defaults: d).autoHideDelay == 60)
        let p = Preferences(defaults: d)
        p.autoHideDelay = 0.5
        expect(p.autoHideDelay == 2)
        expect(Preferences(defaults: d).autoHideDelay == 2)
    }
}
