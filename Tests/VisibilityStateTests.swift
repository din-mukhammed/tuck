func visibilityStateTests() {
    test("click toggles hidden and shown") {
        expect(VisibilityState.hidden.clicked(option: false, alwaysHiddenEnabled: true) == .shown)
        expect(VisibilityState.shown.clicked(option: false, alwaysHiddenEnabled: true) == .hidden)
        expect(VisibilityState.allShown.clicked(option: false, alwaysHiddenEnabled: true) == .hidden)
    }
    test("option-click reveals everything") {
        expect(VisibilityState.hidden.clicked(option: true, alwaysHiddenEnabled: true) == .allShown)
        expect(VisibilityState.shown.clicked(option: true, alwaysHiddenEnabled: true) == .allShown)
        expect(VisibilityState.allShown.clicked(option: true, alwaysHiddenEnabled: true) == .hidden)
    }
    test("option-click without always-hidden section only shows") {
        expect(VisibilityState.hidden.clicked(option: true, alwaysHiddenEnabled: false) == .shown)
        expect(VisibilityState.shown.clicked(option: true, alwaysHiddenEnabled: false) == .hidden)
    }
    test("disabling the section drops allShown to shown") {
        expect(VisibilityState.allShown.normalized(alwaysHiddenEnabled: false) == .shown)
        expect(VisibilityState.allShown.normalized(alwaysHiddenEnabled: true) == .allShown)
        expect(VisibilityState.hidden.normalized(alwaysHiddenEnabled: false) == .hidden)
    }
    test("divider expansion per state") {
        expect(VisibilityState.hidden.hiddenDividerExpanded && VisibilityState.hidden.alwaysDividerExpanded)
        expect(!VisibilityState.shown.hiddenDividerExpanded && VisibilityState.shown.alwaysDividerExpanded)
        expect(!VisibilityState.allShown.hiddenDividerExpanded && !VisibilityState.allShown.alwaysDividerExpanded)
    }
}
