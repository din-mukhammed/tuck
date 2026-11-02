import AppKit
import Combine

final class MenuBarController: NSObject {
    private let preferences: Preferences
    private let openSettings: () -> Void
    private let toggleItem: NSStatusItem
    private let hiddenDivider: NSStatusItem
    private let alwaysDivider: NSStatusItem
    private var autoHideTimer: Timer?
    private var subscriptions = Set<AnyCancellable>()

    private var state: VisibilityState = .hidden {
        didSet {
            if oldValue == .allShown { Self.rememberAlwaysDividerPosition() }
            apply()
        }
    }

    init(preferences: Preferences, openSettings: @escaping () -> Void) {
        self.preferences = preferences
        self.openSettings = openSettings
        toggleItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        toggleItem.autosaveName = "tuck.toggle"
        Self.pinHiddenDividerToToggle()
        Self.restoreAlwaysDividerPosition()
        hiddenDivider = NSStatusBar.system.statusItem(withLength: DividerLength.collapsed)
        hiddenDivider.autosaveName = "tuck.hidden"
        alwaysDivider = NSStatusBar.system.statusItem(withLength: DividerLength.collapsed)
        alwaysDivider.autosaveName = "tuck.always"
        super.init()

        if let button = toggleItem.button {
            button.target = self
            button.action = #selector(toggleClicked)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.setAccessibilityLabel("Tuck")
        }
        alwaysDivider.isVisible = preferences.alwaysHiddenEnabled

        preferences.$alwaysHiddenEnabled
            .dropFirst()
            .sink { [weak self] enabled in
                guard let self else { return }
                if enabled { Self.restoreAlwaysDividerPosition() }
                self.alwaysDivider.isVisible = enabled
                self.state = self.state.normalized(alwaysHiddenEnabled: enabled)
            }
            .store(in: &subscriptions)

        apply()
    }

    @objc private func toggleClicked() {
        guard let event = NSApp.currentEvent else { return }
        if event.type == .rightMouseUp || event.modifierFlags.contains(.control) {
            showMenu()
            return
        }
        state = state.clicked(
            option: event.modifierFlags.contains(.option),
            alwaysHiddenEnabled: preferences.alwaysHiddenEnabled
        )
    }

    private func showMenu() {
        guard let button = toggleItem.button else { return }
        let menu = NSMenu()
        let settings = NSMenuItem(title: "Settings…", action: #selector(settingsChosen), keyEquivalent: ",")
        settings.target = self
        menu.addItem(settings)
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit Tuck", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        menu.popUp(positioning: nil, at: NSPoint(x: 0, y: button.bounds.height + 4), in: button)
    }

    @objc private func settingsChosen() {
        openSettings()
    }

    private func apply() {
        toggleItem.button?.image = symbol(state == .hidden ? "chevron.compact.left" : "chevron.compact.right", label: "Tuck")
        if state.hiddenDividerExpanded {
            Self.pinHiddenDividerToToggle()
            hiddenDivider.length = DividerLength.expanded
            hiddenDivider.isVisible = true
        } else {
            hiddenDivider.isVisible = false
        }
        style(divider: alwaysDivider, expanded: state.alwaysDividerExpanded)
        if state == .allShown {
            DispatchQueue.main.async { Self.rememberAlwaysDividerPosition() }
        }
        scheduleAutoHide()
    }

    private static func pinHiddenDividerToToggle() {
        let defaults = UserDefaults.standard
        let toggle = defaults.double(forKey: StatusItemDefaults.position(of: "tuck.toggle"))
        guard toggle > 0 else { return }
        defaults.set(toggle + 1, forKey: StatusItemDefaults.position(of: "tuck.hidden"))
    }

    private static func rememberAlwaysDividerPosition() {
        let defaults = UserDefaults.standard
        let position = defaults.double(forKey: StatusItemDefaults.position(of: "tuck.always"))
        guard position > 0 else { return }
        defaults.set(position, forKey: StatusItemDefaults.collapsedAlwaysPosition)
    }

    private static func restoreAlwaysDividerPosition() {
        let defaults = UserDefaults.standard
        let position = defaults.double(forKey: StatusItemDefaults.collapsedAlwaysPosition)
        guard position > 0 else { return }
        defaults.set(position, forKey: StatusItemDefaults.position(of: "tuck.always"))
    }

    private func style(divider: NSStatusItem, expanded: Bool) {
        divider.length = expanded ? DividerLength.expanded : DividerLength.collapsed
        divider.button?.image = expanded ? nil : symbol("poweron", label: "Tuck divider")
        divider.button?.alphaValue = 0.5
    }

    private func symbol(_ name: String, label: String) -> NSImage? {
        let image = NSImage(systemSymbolName: name, accessibilityDescription: label)
        image?.isTemplate = true
        return image
    }

    private func scheduleAutoHide() {
        autoHideTimer?.invalidate()
        autoHideTimer = nil
        guard state != .hidden, preferences.autoHideEnabled else { return }
        autoHideTimer = Timer.scheduledTimer(withTimeInterval: preferences.autoHideDelay, repeats: false) { [weak self] _ in
            self?.autoHideTimerFired()
        }
    }

    private func autoHideTimerFired() {
        switch autoHideAction(state: state, enabled: preferences.autoHideEnabled, pointerInMenuBar: pointerInMenuBar()) {
        case .hide: state = .hidden
        case .rearm: scheduleAutoHide()
        case .none: break
        }
    }

    private func pointerInMenuBar() -> Bool {
        let location = NSEvent.mouseLocation
        guard let screen = NSScreen.screens.first(where: { NSMouseInRect(location, $0.frame, false) }) else { return false }
        let menuBarHeight = max(screen.frame.maxY - screen.visibleFrame.maxY, NSStatusBar.system.thickness)
        return location.y >= screen.frame.maxY - menuBarHeight
    }
}
