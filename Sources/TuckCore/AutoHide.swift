enum AutoHideAction: Equatable {
    case none
    case hide
    case rearm
}

func autoHideAction(state: VisibilityState, enabled: Bool, pointerInMenuBar: Bool) -> AutoHideAction {
    guard enabled, state != .hidden else { return .none }
    return pointerInMenuBar ? .rearm : .hide
}
