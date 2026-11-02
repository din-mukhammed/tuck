func autoHideTests() {
    test("auto-hide decision") {
        expect(autoHideAction(state: .shown, enabled: true, pointerInMenuBar: false) == .hide)
        expect(autoHideAction(state: .allShown, enabled: true, pointerInMenuBar: true) == .rearm)
        expect(autoHideAction(state: .hidden, enabled: true, pointerInMenuBar: false) == .none)
        expect(autoHideAction(state: .shown, enabled: false, pointerInMenuBar: false) == .none)
    }
}
