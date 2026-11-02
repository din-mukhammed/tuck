import Combine
import Foundation

final class Preferences: ObservableObject {
    static let delayRange: ClosedRange<Double> = 2...60

    private enum Key {
        static let autoHideEnabled = "autoHideEnabled"
        static let autoHideDelay = "autoHideDelay"
        static let alwaysHiddenEnabled = "alwaysHiddenEnabled"
    }

    private let defaults: UserDefaults

    @Published var autoHideEnabled: Bool {
        didSet { defaults.set(autoHideEnabled, forKey: Key.autoHideEnabled) }
    }

    @Published var autoHideDelay: Double {
        didSet {
            let clamped = Self.clamp(autoHideDelay)
            if clamped != autoHideDelay {
                autoHideDelay = clamped
                return
            }
            defaults.set(autoHideDelay, forKey: Key.autoHideDelay)
        }
    }

    @Published var alwaysHiddenEnabled: Bool {
        didSet { defaults.set(alwaysHiddenEnabled, forKey: Key.alwaysHiddenEnabled) }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        defaults.register(defaults: [
            Key.autoHideEnabled: true,
            Key.autoHideDelay: 10.0,
            Key.alwaysHiddenEnabled: true,
        ])
        autoHideEnabled = defaults.bool(forKey: Key.autoHideEnabled)
        autoHideDelay = Self.clamp(defaults.double(forKey: Key.autoHideDelay))
        alwaysHiddenEnabled = defaults.bool(forKey: Key.alwaysHiddenEnabled)
    }

    private static func clamp(_ value: Double) -> Double {
        min(max(value, delayRange.lowerBound), delayRange.upperBound)
    }
}
