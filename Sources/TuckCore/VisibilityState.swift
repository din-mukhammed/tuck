import Foundation

enum DividerLength {
    static let expanded: CGFloat = 10_000
    static let collapsed: CGFloat = 8
}

enum VisibilityState: Equatable {
    case hidden
    case shown
    case allShown

    func clicked(option: Bool, alwaysHiddenEnabled: Bool) -> VisibilityState {
        let revealAll = option && alwaysHiddenEnabled
        switch self {
        case .hidden: return revealAll ? .allShown : .shown
        case .shown: return revealAll ? .allShown : .hidden
        case .allShown: return .hidden
        }
    }

    func normalized(alwaysHiddenEnabled: Bool) -> VisibilityState {
        self == .allShown && !alwaysHiddenEnabled ? .shown : self
    }

    var hiddenDividerExpanded: Bool { self == .hidden }

    var alwaysDividerExpanded: Bool { self != .allShown }
}
